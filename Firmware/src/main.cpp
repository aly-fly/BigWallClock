
#include <Arduino.h>
#include <stdint.h>
#include <stdlib.h>
#include <SPIFFS.h>
#include "Version.h"
#include "__CONFIG.h"
#include "GlobalVariables.h"
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

void setup()
{
  Serial.begin(115200);
  pinMode(GPIO_NUM_0, INPUT_PULLUP);

  // delay 2 sec on the start to connect from programmer to serial terminal
  int i;
  for (i = 0; i < 10; i++)
  {
    Serial.print("*");
    delay(100);
  }
  Serial.println();
  Serial.println("Project: github.com/aly-fly/BigWallClock");
  Serial.print("Version: ");
  Serial.println(VERSION);
  Serial.print("Build: ");
  Serial.println(BUILD_TIMESTAMP);

  LED_init();
  LED_color(0, LED_BLUbright, true);
  delay(200);

  fileSystem_init();
  LED_color(1, LED_ORANGE, true);
  if (encoderInit())
    LED_color(1, LED_BLUbright, true);
  else
  {
    LED_color(1, LED_REDbright, true);
    Log("ENCODER INIT FAILED. HALTED.") while (1) yield(); // stop here
  }
  delay(200);

  LED_color(2, LED_ORANGE, true);
  if (MotorInit() & TempSensorInit())
    LED_color(2, LED_BLUbright, true);
  else
  {
    LED_color(2, LED_REDbright, true);
    Log("MOTOR OR TEMP SENSOR INIT FAILED. HALTED.") while (1) yield(); // stop here
  }
  delay(200);

  LED_color(3, LED_ORANGE, true);
  if (WifiInit())
    LED_color(3, LED_BLUbright, true);
  else
    LED_color(3, LED_REDbright, true);
  delay(200);

  LED_color(4, LED_ORANGE, true);
  setClock();
  LED_color(4, LED_BLUbright, true);
  delay(200);

  startTcpSocket();

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

  Serial.println("INIT FINISHED.");
  Serial.println();
  Serial.println("Serial commands:");
  Serial.println("  00..12M -> Hour preset");
  Serial.println("  Z       -> Encoder zero");
  Serial.println("  1..0E   -> Enable clock");
  Serial.println("  1..0T   -> Test mode");
  Serial.println("  1..9C   -> Constant speed");
  Serial.println("  P       -> Encoder position?");
  Serial.println("  G       -> Encoder air gap? (loop)");
  Serial.println("  S       -> Motor status?");
  Serial.println(" LL       -> Print log contents");
  Serial.println(" DL       -> Delete log file");
  Serial.println();
  Log("Clock running.");

  LED_off();
  LED_color(0, LED_GRNdim, true);
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
int ErrorCounter = 0;
bool ErrorCounterLogged = false;

String sSerialCmd;
int LEDlastUpdate = 0; // limit refresh rate
int LEDsequence = 0;
int LastHour = 0;
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
            Serial.printf("MT12 = %d; Hr = %d; Hr12 = %d;\n", EncoderPosMT12, CurrentHour, CurrentHour12);

          delta = TimeCurrent - TimeDisplayed;
          // handle overflow over 0:00 and 12:00
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
            Serial.printf("Encoder = %d; Time = %d; delta = %d; speedAdj = %f; Filtered = %f\n", TimeDisplayed, TimeCurrent, delta, speedAdj, speedAdjFiltered);

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
  if (abs(MotorTempLastLogged - MotorTemperature) > 2)
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
  if ((ErrorCounter > 0) && (!ErrorCounterLogged))
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
    LED_color(0, LED_GRNdim);
  }
  else
  {
    if (!ClockEnabled)
    {
      LED_color(0, LED_REDbright);
    }
    else
    {
      if (ErrorCounter > 0)
      {
        LED_color(0, LED_ORANGE);
      }
    }
  }

  // if clock is not correctly adjusted in 100 seconds or motor error is read 10 times then disable motor for 500 seconds (cool down)
  if ((ErrorCounter > 3000) && ClockEnabled && !TestMode)
  {
    Log("Error counter exceeded threshold. Clock disabled.");
    EnableMotor(false);
    ClockEnabled = false;
    LED_color(0, LED_REDbright, true);
  }
  if ((ErrorCounter < 10) && !ClockEnabled && !TestMode)
  {
    Log("Error counter ok. Clock enabled.");
    EnableMotor(true);
    ClockEnabled = true;
    LED_color(0, LED_GRNdim, true);
  }

  //========================================================================================================

  if (CurrentHour != LastHour)
  {
    NightMode = ((CurrentHour >= NIGHT_TIME) || (CurrentHour < DAY_TIME));
    if (NightMode)
    {
      LED_Dimming(NIGHT_TIME_DIMMING);
    }
    else
    {
      LED_Dimming(DAY_TIME_BRIGHTNESS);
    }
    LastHour = CurrentHour;
  }

  if (LEDlastUpdate != CurrentSecond) // limit to 1x per second
  {
    byte LedNum, LedColorIdx;
    // clear pixels
    for (LedNum = 1; LedNum < 5; LedNum++)
    {
      LED_color(LedNum, 0, false);
    }
    LedNum = (LEDsequence % 4) + 1;
    LedColorIdx = (LEDsequence / 4);
    uint32_t LedColor;
    switch (LedColorIdx)
    {
    case 0:
      LedColor = LED_REDdim;
      break;
    case 1:
      LedColor = LED_GRNdim;
      break;

    default:
      LedColor = LED_BLUdim;
      break;
    }
    LED_color(LedNum, LedColor, true);
    LEDsequence++;
    if (LEDsequence >= 12)
      LEDsequence = 0;

    // LED_color(2, ((59 * 2) - (CurrentSecond * 2) << 16) | (CurrentSecond * 2), true);
    LEDlastUpdate = CurrentSecond;
  }

  //========================================================================================================

  // RX commands
  if (Serial.available() > 0)
  {
    sSerialCmd.concat(Serial.readString()); // add new data to the existing queue
  }
  if (DataAvailableInSocket())
  {
    sSerialCmd.concat(ReadFromSocket()); // add new data to the existing queue
  }
  if (sSerialCmd.length() >= 2)
  {
    int pp = sSerialCmd.indexOf('\r'); // find first command
    if (pp > 0)
    {
      char Cmd = sSerialCmd.charAt(pp - 1);
      Serial.println("=====================================================");
      Serial.print("Command received: ");
      Serial.println(Cmd);
      switch (Cmd)
      {
      case 'M':
        Serial.println("-> Multiturn preset");
        if (pp > 2)
        {
          char param1 = sSerialCmd.charAt(pp - 3);
          char param2 = sSerialCmd.charAt(pp - 2);
          param1 = param1 - '0';
          param2 = param2 - '0';
          uint16_t val = (param1 * 10) + param2;
          if ((val >= 0) && (val <= 11))
          {
            Serial.printf("  New MT = %d\n", val);
            EncoderSetMT(val);
          }
        }
        encoderRead(true); // print new pos value
        break;

      case 'Z':
        Serial.println("-> Encoder zero");
        EncoderSetZeroHere();
        encoderRead(true); // print new pos value
        break;

      case 'E':
        Serial.println("-> Enable clock");
        if (pp > 1)
        {
          char param = sSerialCmd.charAt(pp - 2);
          ClockEnabled = (param == '1');
          EnableMotor(ClockEnabled);
          ErrorCounter = 0;
        }
        break;

      case 'T':
        Serial.println("-> Test mode");
        if (pp > 1)
        {
          char param = sSerialCmd.charAt(pp - 2);
          TestMode = (param == '1');
        }
        // debug
        Serial.println("[IDLE] Free memory: " + String(esp_get_free_heap_size()) + " bytes");
        multi_heap_info_t info;
        heap_caps_get_info(&info, MALLOC_CAP_INTERNAL | MALLOC_CAP_8BIT); // internal RAM, memory capable to store data or to create new task
        Serial.println("[IDLE] Largest available block: " + String(info.largest_free_block) + " bytes");
        Serial.println("[IDLE] Minimum free ever: " + String(info.minimum_free_bytes) + " bytes");
        break;

      case 'C':
        Serial.println("-> Constant speed");
        if (pp > 1)
        {
          byte param = sSerialCmd.charAt(pp - 2);
          param = param - '0';
          if ((param >= 0) && (param <= 9))
          {
            ClockEnabled = false;
            TestMode = true;
            int speed = 1 << param;
            Serial.printf("  Speed = %d\n", speed);
            MoveConstSpeed((float)speed, TestMode);
          }
        }
        break;

      case 'P':
        Serial.println("-> Encoder position, status, air gap?");
        encoderRead(true);
        encoderReadAirGap();
        break;

      case 'G':
      {
        Serial.println("-> Encoder air gap?");
        bool oldTM = TestMode;
        TestMode = true; // do not save messages
        for (int i = 0; i < 240; i++)
        {
          EnableMotor(false);
          encoderReadAirGap();
          delay(1000);
        }
        TestMode = oldTM;
        break;
      }

      case 'S':
        Serial.println("-> Motor status?");
        MotorGetStatusOk(true);
        break;

      case 'L':
        Serial.println("-> LOG");
        if (pp > 1)
        {
          byte param = sSerialCmd.charAt(pp - 2);
          switch (param)
          {
          case 'L':
            ReadAndPrintContentsOfTheLog();
            break;
          case 'D':
            DeleteLogFile();
            break;
          }
        }
        break;

      default:
        Serial.println("-> Unknown");
        break;
      }
      sSerialCmd.clear(); // process only one command in one main loop
    }
  } // serial available

  // WifiReconnectIfNeeded();

  loggerPurgeToFile();

  LoopSocketServer();

  delay(100);

} // loop
