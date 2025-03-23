
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
#include "ResetReason.h"

#ifdef MQTT_ENABLED
#include "Mqtt_client_HA.h"
#endif

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
  Log("########################################");
  Log("Project: github.com/aly-fly/BigWallClock");
  Log("Version: %s", VERSION);
  Log("Build: %s", BUILD_TIMESTAMP);
  Log(get_reset_reason().c_str());

  LED_init();

  if (!digitalRead(GPIO_NUM_0))
  {
    LED_test();
    while (1)
      yield();
  }

  uint32_t tailColor = clBLUEdim;
  LED_showProgressNumber(1, clORANGEbright, tailColor);
  if (fileSystem_init())
    LED_showProgressNumber(1, clBLUEbright, tailColor);
  else
  {
    tailColor = clREDdim;
    LED_showProgressNumber(1, clREDbright, tailColor);
  }
  delay(200);

  LED_showProgressNumber(2, clORANGEbright, tailColor);
  if (WifiInit())
    LED_showProgressNumber(2, clBLUEbright, tailColor);
  else
  {
    tailColor = clREDdim;
    LED_showProgressNumber(2, clREDbright, tailColor);
  }
  delay(200);
  startTcpSocket();
  OTA_init();

  LED_showProgressNumber(4, clORANGEbright, tailColor);
  if (encoderInit())
    LED_showProgressNumber(4, clBLUEbright, tailColor);
  else
  {
    tailColor = clREDdim;
    LED_showProgressNumber(4, clREDbright, tailColor);
    Log("ENCODER INIT FAILED. HALTED.");
    while (1) // stop here
    {
      MainLoopBackgroundTasks();
    }
  }
  delay(200);

  LED_showProgressNumber(6, clORANGEbright, tailColor);
  if (MotorInit())
    LED_showProgressNumber(6, clBLUEbright, tailColor);
  else
  {
    tailColor = clREDdim;
    LED_showProgressNumber(6, clREDbright, tailColor);
    Log("MOTOR INIT FAILED. HALTED.");
    while (1) // stop here
    {
      MainLoopBackgroundTasks();
    }
  }
  delay(200);

  LED_showProgressNumber(8, clORANGEbright, tailColor);
  if (TempSensorInit())
    LED_showProgressNumber(8, clBLUEbright, tailColor);
  else
  {
    tailColor = clREDdim;
    LED_showProgressNumber(8, clREDbright, tailColor);
    Log("TEMP SENSOR INIT FAILED. HALTED.");
    while (1) // stop here
    {
      MainLoopBackgroundTasks();
    }
  }
  delay(200);

  LED_showProgressNumber(9, clORANGEbright, tailColor);
  setClock();
  LED_showProgressNumber(9, clBLUEbright, tailColor);
  delay(300);

#ifdef MQTT_ENABLED
  LED_showProgressNumber(10, clORANGEbright, tailColor);
  Log("MQTT start...");
  if (MqttStart())
  {
    LED_showProgressNumber(10, clBLUEbright, tailColor);
    Log("MQTT start Done.");
  }
  else
  {
    tailColor = clREDdim;
    LED_showProgressNumber(10, clREDbright, tailColor);
    Log("MQTT start Error!");
  }
#endif

  EnableMotor(true);
  LED_showProgressNumber(12, clBLUEbright, tailColor);
  delay(300);

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
  LED_SetPixelColor(0, clGREENbright, true);
}

// ===============================================================================================================================================================

int CurrentHour12, EncoderPosMT12;
int TimeCurrent, TimeDisplayed; // 0...131'071 (2^17)
int delta;                      // positive -> move forward
float speedAdj, speedAdjFiltered, speedMotor;
bool filterValid = false;
bool ErrorCounterLogged = false;

int LastHour = -1;
float MotorTemperature = 0;
float MotorTempLastLogged = -100;

int heartBeatLed = 0;

unsigned long LastTimeClockTaskRun = 0;

int LastTimeLEDTaskRun = 0; // limit refresh rate

void MainLoopClockTasks(void)
{
  if ((millis() - LastTimeClockTaskRun) < 100)
    return; // run 10x per second
  LastTimeClockTaskRun = millis();

  ClockWarning = false;
  ClockError = false;

  if (GetCurrentTime())
  {
    if (ClockEnabled)
    {
      speedAdj = 0;
      if (encoderRead(false)) // print only if encoder encounters an error
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
          ClockError = true;
        }

        if ((EncoderPosMT == 12) && (EncoderPosST > 100))
        {
          EncoderSetMT(0);
        }
        if (EncoderWarning)
        {
          ClockWarning = true;
        }
      } // encoder read ok
      else
      { // reading encoder failed
        filterValid = false;
        ClockError = true;
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
      if (encoderRead(false)) // print only if encoder encounters an error
        if ((EncoderPosMT == 12) && (EncoderPosST > 100))
          EncoderSetMT(0);
    } // clock not enabled
  } // get time
  else
  {
    Log("Getting current time failed!");
    ClockError = true;
  }

  motorStatus_t motSta = MotorGetStatus();
  if (motSta == MSFAULT)
  {
    Log("Motor failure!");
    ErrorCounter = 4000;
    ClockError = true;
    // disable immediatelly
    EnableMotor(false);
    ClockEnabled = false;
    ErrorCounter += 50;
  }
  if (motSta == MSSTALL)
  {
    Log("Stall detected. Moving backwards a bit.");
    ErrorCounter += 50;
    MoveConstSpeed(-SPEED_LIMIT); // max speed reverse
    delay(500);
    MoveConstSpeed(+SPEED_LIMIT); // max speed forward
    delay(600);
    filterValid = false;
  }

  MotorTemperature = TempSensorRead();
  MqttStatusTemperture = round(MotorTemperature);
  if (abs(MotorTempLastLogged - MotorTemperature) > 4)
  {
    Log("Motor temperature = %.1f C", MotorTemperature);
    MotorTempLastLogged = MotorTemperature;
  }
  if (MotorTemperature > (MOTOR_TEMP_MAX + 5))
  {
    Log("Motor too hot! Temperature = %.1f C", MotorTemperature);
    ErrorCounter = 4000;
    ClockError = true;
    // disable immediatelly
    EnableMotor(false);
    ClockEnabled = false;
  }
  else if (MotorTemperature > MOTOR_TEMP_MAX)
  {
    Log("Motor overheating! Temperature = %.1f C", MotorTemperature);
    ErrorCounter += 30;
    ClockWarning = true;
  }
  if (MotorTemperature < 10)
  {
    Log("Reading motor temperature failed! Temperature = %.1f C", MotorTemperature);
    ErrorCounter = 4000;
    ClockError = true;
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
    encoderRead(true); // log position
    ErrorCounterLogged = true;
  }
  if ((ErrorCounter == 0) && (ErrorCounterLogged))
  {
    Log("ErrorCounter 0.");
    ErrorCounterLogged = false;
  }

  // if clock is not correctly adjusted in 100 seconds or motor error is read 10 times then disable motor for 500 seconds (cool down)
  if ((ErrorCounter > 3000) && ClockEnabled && !TestMode)
  {
    Log("Error counter exceeded threshold. Clock disabled.");
    EnableMotor(false);
    ClockEnabled = false;
    ClockError = true;
  }
  if ((ErrorCounter < 10) && !ClockEnabled && !TestMode)
  {
    Log("Error counter ok. Clock enabled.");
    EnableMotor(true);
    ClockEnabled = true;
  }

  if (ErrorCounter > 0)
    ClockWarning = true;

  if (ErrorCounter > 1000)
    ClockError = true;

  if (!WifiIsConnected())
    ClockWarning = true;

  heartBeatLed++;
  if (heartBeatLed >= 10)
  {
    LEDbuiltin_Toggle(); // toggle onboard LED
    heartBeatLed = 0;
  }
}

//========================================================================================================

#ifdef MQTT_ENABLED
unsigned long lastMqttCommandExecuted = -1;
bool MqttCommandReceived = false;
#endif

void MainLoopMQTTTasks(void)
{
#ifdef MQTT_ENABLED
  MqttLoopFrequently();

  MqttCommandReceived = false;

  if (MqttCommandPowerReceived)
  {
    MqttCommandPowerReceived = false;
    LogNS("CMD: Power = %d\r\n", MqttCommandPower);
    MqttCommandReceived = true;
  }
  if (MqttCommandBrightnessReceived)
  {
    MqttCommandBrightnessReceived = false;
    LogNS("CMD: Brightness = %d\r\n", MqttCommandBrightness);
    // LED_SetDimming(MqttCommandBrightness); // system indicators have own brightness
    MqttCommandReceived = true;
  }
  if (MqttCommandColorReceived)
  {
    MqttCommandColorReceived = false;
    LogNS("CMD: RGB = 0x%6X\r\n", MqttCommandColor);
    MqttCommandReceived = true;
  }
  if (MqttCommandEffectReceived)
  {
    MqttCommandEffectReceived = false;
    LogNS("CMD: Effect = %d (%s)\r\n", MqttCommandEffectNumber, MqttCommandEffect);
    MqttCommandReceived = true;
  }
  if (MqttCommandRainbowSecReceived)
  {
    MqttCommandRainbowSecReceived = false;
    LogNS("CMD: Rainbow sec = %.1f\r\n", MqttCommandRainbowSec);
    MqttCommandReceived = true;
  }
  if (MqttCommandDotsReceived)
  {
    MqttCommandDotsReceived = false;
    LogNS("CMD: Dots = %d\r\n", MqttCommandDots);
    MqttCommandReceived = true;
  }

  if (MqttCommandReceived)
  {
    lastMqttCommandExecuted = millis();
  }

  /*
    if ((millis() - lastMqttCommandExecuted) > (MQTT_SAVE_PREFERENCES_AFTER_SEC * 1000)) && (lastMqttCommandExecuted != -1))
    {
      lastMqttCommandExecuted = -1;

      Serial.print("Saving config...");
      // stored_config.save();
      Serial.println(" Done.");
    }
*/

  // copy - confirm received values
  MqttStatusBrightness = MqttCommandBrightness; // LED_GetDimming();
  MqttStatusPower = MqttCommandPower;           // LED_GetDimming() > 0;
  strncpy(MqttStatusEffect, Effect[MqttCommandEffectNumber].c_str(), sizeof(MqttStatusEffect) - 1);
  MqttStatusEffect[sizeof(MqttStatusEffect) - 1] = '\0';
  MqttStatusRainbowSec = MqttCommandRainbowSec;
  MqttStatusDots = MqttCommandDots;
  MqttStatusRssi = WifiGetSignalLevel();
  MqttStatusErrorWarning = ErrorCounter;

  MqttLoopInFreeTime();
#endif
}

//========================================================================================================

void MainLoopLEDTasks(void)
{
  uint32_t LEDcolor;

  if ((millis() - LastTimeLEDTaskRun) < 100)
    return; // run 10x per second
  LastTimeLEDTaskRun = millis();

  if (CurrentHour != LastHour)
  {
    if ((CurrentHour >= NIGHT_TIME) || (CurrentHour < DAY_TIME))
    {
      LED_clear(true);
      LED_SetDimming(0);
      MqttCommandPower = false;
    }
    else
    {
      MqttCommandPower = true;
      if (CurrentHour >= EVENING_TIME)
      {
        LED_SetDimming(EVENING_TIME_DIMMING);
      }
      else
      {
        LED_SetDimming(DAY_TIME_BRIGHTNESS);
      }
    }
    LastHour = CurrentHour;
  }

  if (!MqttCommandPower)
  {
    LED_clear(false); // OFF
  }
  else
  {
    // background effect
    switch (MqttCommandEffectNumber)
    {
    case 0: // Static color
      LEDcolor = MqttCommandColor;
      adjustColorBrightness(&LEDcolor, MqttCommandBrightness); // background has individually adjustable brightness; not linked to clock's brightness
      LED_allSameColor(LEDcolor, false);                       // set background
      break;

    case 1: // Uniform rainbow
      rainbowPattern(8, MqttCommandRainbowSec, MqttCommandBrightness);
      break;

    case 2: // Travelling full rainbow
      rainbowPattern(1, MqttCommandRainbowSec, MqttCommandBrightness);
      break;

    case 3: // Travelling partial rainbow
      rainbowPattern(3, MqttCommandRainbowSec, MqttCommandBrightness);
      break;

    default:
      LED_clear(false); // dark
      break;
    }
  } // power = on

  if (MqttCommandDots || ClockError || ClockWarning)
  {
    if (ClockError)
      LEDcolor = clREDbright;
    else if (ClockWarning)
      LEDcolor = clORANGEbright;
    else if (ClockEnabled)
      LEDcolor = clGREENdim;
    else
      LEDcolor = clPINKbright;

    LED_showSingleDot(0.00, LEDcolor, false);
    LED_showSingleDot(0.25, LEDcolor, false);
    LED_showSingleDot(0.50, LEDcolor, false);
    LED_showSingleDot(0.75, LEDcolor, false);
  }

  LED_showSingleDot((float)CurrentSecond / 60, SECONDS_DOT_COLOR, true); // push everything to the LED strip
}

//========================================================================================================

void MainLoopBackgroundTasks(void) // called also from startup blocking errors
{
  ReceiveAndProcessSerialCommands();
  loggerPurgeToFile();
  LoopSocketServer();
  OTA_loop();
}

//========================================================================================================

void loop()
{
  MainLoopClockTasks();
  MainLoopMQTTTasks();
  MainLoopLEDTasks();
  MainLoopBackgroundTasks();
} // loop
