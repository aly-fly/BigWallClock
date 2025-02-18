
#include <Arduino.h>
#include <stdint.h>
#include <stdlib.h>
#include <SPIFFS.h>
#include "Version.h"
#include "__CONFIG.h"
#include "GlobalVariables.h"
#include "LED_builtin.h"
#include "myWiFi.h"
#include "Clock.h"
#include "myPing.h"
#include "motorDriver.h"
#include "TempSensor.h"
#include "Aksim2_encoder_uart2.h"
#include "LEDs.h"
#include "Logger.h"
#include "fileSystem.h"
#include "TcpSocket.h"
#include "OTA.h"
#include "SerialCommands.h"

void MainLoopBackgroundTasks(void);

void setup()
{
  Serial.begin(115200);
  pinMode(GPIO_NUM_0, INPUT_PULLUP);
  LEDbuiltin_init();
  LEDbuiltin_ON();

  // delay 2 sec on the start to connect from programmer to serial terminal
  int i;
  for (i = 0; i < 10; i++)
  {
    Serial.print("*");
    delay(100);
  }
  Serial.println();
  Log("Project: github.com/aly-fly/BigWallClock");
  Log("Version: %s", VERSION);
  Log("Build: %s", BUILD_TIMESTAMP);

  LED_init();

  if (!digitalRead(GPIO_NUM_0))
  {
    LED_test();
    while (1)
      yield();
  }

  uint32_t tailColor = clBLUEdim;
  LED_showProgress(10, clORANGEbright, tailColor);
  if (fileSystem_init())
    LED_showProgress(15, clBLUEbright, tailColor);
  else
  {
    tailColor = clREDdim;
    LED_showProgress(15, clREDbright, tailColor);
  }
  delay(200);

  LED_showProgress(20, clORANGEbright, tailColor);
  if (WifiInit())
    LED_showProgress(25, clBLUEbright, tailColor);
  else
  {
    tailColor = clREDdim;
    LED_showProgress(25, clREDbright, tailColor);
  }
  delay(200);
  startTcpSocket();
  OTA_init();

  LED_showProgress(30, clORANGEbright, tailColor);
  if (encoderInit())
    LED_showProgress(35, clBLUEbright, tailColor);
  else
  {
    tailColor = clREDdim;
    LED_showProgress(35, clREDbright, tailColor);
    Log("ENCODER INIT FAILED. HALTED.");
    while (1) // stop here
    {
      MainLoopBackgroundTasks();
    }
  }
  delay(200);

  LED_showProgress(40, clORANGEbright, tailColor);
  if (MotorInit())
    LED_showProgress(45, clBLUEbright, tailColor);
  else
  {
    tailColor = clREDdim;
    LED_showProgress(45, clREDbright, tailColor);
    Log("MOTOR INIT FAILED. HALTED.");
    while (1) // stop here
    {
      MainLoopBackgroundTasks();
    }
  }
  delay(200);

  LED_showProgress(50, clORANGEbright, tailColor);
  if (MotorInit() & TempSensorInit())
    LED_showProgress(55, clBLUEbright, tailColor);
  else
  {
    tailColor = clREDdim;
    LED_showProgress(55, clREDbright, tailColor);
    Log("TEMP SENSOR INIT FAILED. HALTED.");
    while (1) // stop here
    {
      MainLoopBackgroundTasks();
    }
  }
  delay(200);

  LED_showProgress(60, clORANGEbright, tailColor);
  setClock();
  LED_showProgress(65, clBLUEbright, tailColor);
  delay(200);

  EnableMotor(true);
  LED_showProgress(70, clBLUEbright, tailColor);
  delay(200);

  /*
    String sPingIP;
    IPAddress pingIP;
    sPingIP = "216.58.205.46"; // google.com
    pingIP.fromString(sPingIP);
    Serial.println(sPingIP);
    int pingOk = ppiinngg(pingIP);

    if (pingOk == 0) {
      Serial.println("=== REBOOT ===");
      delay (15000);
      ESP.restart();  // retry everything from the beginning
    }
  */

  LogNS("INIT FINISHED.\r\n\r\n");
  Serial.println(SERIAL_COMMANDS_LIST); // don't send to other channels
  Log("Clock running.");

  LEDbuiltin_OFF();
  LED_clear(false);
  LED_color(0, clGREENbright, true);
}

// ===============================================================================================================================================================

#define CPR 131072
#define CPR12 (CPR * 12)
#define CPR12half (CPR * 5)

int CurrentHour12, EncoderPosMT12;
int TimeCurrent, TimeDisplayed; // 0...131'071 (2^17)
int delta;                      // positive -> move forward
float speedAdj, speedAdjFiltered, speedMotor;
bool filterValid = false;
bool ErrorCounterLogged = false;

int LEDlastUpdateSec = 0; // limit refresh rate
unsigned long LEDlastUpdateMS = 0;
int LastHour = -1;
float MotorTemperature = 0;
float MotorTempLastLogged = -100;

void loop()
{
  if (GetCurrentTime())
  {
    if (ClockEnabled)
    {
      speedAdj = 0;
      if (encoderRead(TestMode))
      {
        if (!EncoderError)
        {
          EncoderPosMT12 = (EncoderPosMT % 12);
          TimeDisplayed = EncoderPosST + EncoderPosMT12 * CPR;

          CurrentHour12 = (CurrentHour % 12);
          TimeCurrent = (CurrentHour12 * CPR) + (CurrentMinute * CPR) / 60 + ((CurrentSecond * CPR) / 60 / 60);
          if (TestMode)
            LogNS("MT12 = %d; Hr = %d; Hr12 = %d;\r\n", EncoderPosMT12, CurrentHour, CurrentHour12);

          delta = TimeCurrent - TimeDisplayed;
          // handle overflow at 0:00 and 12:00
          if (delta > CPR12half)
            delta -= CPR12;
          if (delta < -CPR12half)
            delta += CPR12;

          if (abs(delta) > 1000)
            ErrorCounter += 2;

          speedAdj = (float)delta / 600; // P regulator

          // low-pass filter for small movements
          if ((abs(speedAdj) > 2) || (!filterValid))
          {
            speedAdjFiltered = speedAdj; // pass through - no filter
            filterValid = true;
          }
          else
          {
            speedAdjFiltered = (speedAdj * 0.05) + (speedAdjFiltered * 0.95);
          }
          if (TestMode)
            LogNS("Encoder = %d; Time = %d; delta = %d; speedAdj = %f; Filtered = %f\r\n", TimeDisplayed, TimeCurrent, delta, speedAdj, speedAdjFiltered);

        } // encoder no error
        else
        { // encoder error
          filterValid = false;
        }

        if ((EncoderPosMT == 12) && (EncoderPosST > 100))
          EncoderSetMT(0);
      } // encoder read ok
      else
      { // reading encoder failed
        filterValid = false;
      }

      // 400 steps = 1 hour = 60 min = 3600 s
      // speed = 400 steps / 3600 s = 0.11111 step / s
      speedMotor = 0.11111111;

      if (abs(speedAdj) > 0.05) // ignore very tiny corrections
      {
        speedMotor += speedAdjFiltered;
      }

      MoveConstSpeed(speedMotor); // constant movement + corrections
    } // clock enabled
    else
    {
      filterValid = false;
      if (encoderRead(true))
        if ((EncoderPosMT == 12) && (EncoderPosST > 100))
          EncoderSetMT(0);
    } // clock not enabled
  } // get time
  else
  {
    Log("Getting current time failed!");
  }

  if (!MotorGetStatusOk())
  {
    ErrorCounter += 50;
  }

  MotorTemperature = TempSensorRead();
  if (abs(MotorTempLastLogged - MotorTemperature) > 4)
  {
    Log("Motor temperature = %.1f C", MotorTemperature);
    MotorTempLastLogged = MotorTemperature;
  }
  if (MotorTemperature > MOTOR_TEMP_MAX)
  {
    Log("Motor overheating! Temperature = %.1f C", MotorTemperature);
    ErrorCounter += 2;
  }

  //========================================================================================================

  if (ErrorCounter > 0x00FFFFFF)
    ErrorCounter = 0x00FFFFFF;
  ErrorCounter--;
  if (ErrorCounter < 0)
    ErrorCounter = 0;
  if ((ErrorCounter > 20) && (!ErrorCounterLogged))
  {
    Log("ErrorCounter increasing!");
    ErrorCounterLogged = true;
  }
  if ((ErrorCounter == 0) && (ErrorCounterLogged))
  {
    Log("ErrorCounter 0.");
    ErrorCounterLogged = false;
  }

  if ((ErrorCounter == 0) && ClockEnabled)
  {
    LED_color(LEDStatusLocation, clGREENdim);
  }
  else
  {
    if (!ClockEnabled)
    {
      LED_color(LEDStatusLocation, clREDbright);
    }
    else
    {
      if (ErrorCounter > 0)
      {
        LED_color(LEDStatusLocation, clORANGEbright);
      }
    }
  }

  // if clock is not correctly adjusted in 100 seconds or motor error is read 10 times then disable motor for 500 seconds (cool down)
  if ((ErrorCounter > 3000) && ClockEnabled && !TestMode)
  {
    Log("Error counter exceeded threshold. Clock disabled.");
    EnableMotor(false);
    ClockEnabled = false;
    LED_color(LEDStatusLocation, clREDbright, true);
  }
  if ((ErrorCounter < 10) && !ClockEnabled && !TestMode)
  {
    Log("Error counter ok. Clock enabled.");
    EnableMotor(true);
    ClockEnabled = true;
    LED_color(LEDStatusLocation, clGREENdim, true);
  }

  //========================================================================================================

  if (CurrentHour != LastHour)
  {
    if ((CurrentHour >= NIGHT_TIME) || (CurrentHour < DAY_TIME))
    {
      LED_clear(true);
      LED_Dimming(0);
    }
    else
    {
      if (CurrentHour >= EVENING_TIME)
      {
        LED_Dimming(EVENING_TIME_DIMMING);
      }
      else
      {
        LED_Dimming(DAY_TIME_BRIGHTNESS);
      }
    }
    LastHour = CurrentHour;
  }

  if (LEDlastUpdateSec != CurrentSecond) // limit to 1x per second
  {
    byte LedNum;
    if (CurrentSecond == 0)
    {
      LED_clear(false);
    }
    LedNum = CurrentSecond * 2;
    if (LedNum >= 2)
    {
      LED_color(LedNum - 2, 0, false); // clear previous one
    }
    LED_color(LedNum, SECONDS1_DOT_COLOR, true);

    LEDlastUpdateSec = CurrentSecond;
    LEDlastUpdateMS = millis();
  }
  // half-second dot
  if ((millis() - LEDlastUpdateMS) > 450)
  {
    byte LedNum = CurrentSecond * 2 + 1;
    if (LedNum >= 3)
    {
      LED_color(LedNum - 2, 0, false); // clear previous one
    }
    LED_color(LedNum, SECONDS2_DOT_COLOR, true);

    LEDlastUpdateMS = millis();
  }

  //========================================================================================================

  MainLoopBackgroundTasks();

} // loop

  //========================================================================================================

  void MainLoopBackgroundTasks(void)
{

  ReceiveAndProcessSerialCommands();

  loggerPurgeToFile();

  LoopSocketServer();

  LEDbuiltin_Toggle(); // toggle onboard LED

  OTA_loop();

  delay(100);
}
