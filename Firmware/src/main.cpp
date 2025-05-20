
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
#include "utils.h"
#include "NVS_storage.h"

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
  Serial.println(F(__FILE__ __DATE__ __TIME__));
  Log(get_reset_reason().c_str());

  LED_init();

  if (!digitalRead(GPIO_NUM_0))
  {
    LED_test();
    while (1)
      yield();
  }

  storedConfigLoad();

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
  Log("===== Init finished. Clock running. ===== ");

  LEDbuiltin_OFF();
  LED_clear(false);
  LED_SetPixelColor(0, clGREENbright, true);
}

// ===============================================================================================================================================================

int CurrentHour12;
int delta;
float speedAdjFiltered;
bool speedFilterValid = false;
bool ErrorCounterLogged = false;

int LastHour = -1;
float MotorTemperatureFiltered = 0;
float MotorTemperature = 0;
float MotorTempLastLogged = -100;
bool tempFilterValid = false;

int heartBeatLed = 0;

unsigned long LastTimeClockTaskRun = 0;

unsigned long LastTimeLEDTaskRun = 0; // limit refresh rate

String ClockErrorText;

void MainLoopClockTasks(void)
{
  if (!HasTimeElapsed(&LastTimeClockTaskRun, 100))
    return; // run 10x per second

  ClockErrorText = "-"; // not an empty string

  ClockWarning = false;
  ClockError = false;
  delta = 0;

  if (GetCurrentTime())
  {
    if (ClockEnabled)
    {
      float speedAdj = 0;
      if (encoderRead(false)) // print only if encoder encounters an error
      {
        if (!EncoderError)
        {
          int EncoderPosMT12 = (EncoderPosMT % 12);
          int TimeDisplayed = EncoderPosST + EncoderPosMT12 * CPR; // 0...131'071 (2^17)

          CurrentHour12 = (CurrentHour % 12);
          int TimeCurrent = (CurrentHour12 * CPR) + (CurrentMinute * CPR) / 60 + ((CurrentSecond * CPR) / 60 / 60);
          if (TestMode)
            LogNS("MT12 = %d; Hr = %d; Hr12 = %d;\r\n", EncoderPosMT12, CurrentHour, CurrentHour12);

          delta = TimeCurrent - TimeDisplayed; // positive -> move forward
          // handle overflow at 0:00 and 12:00
          if (delta > CPR12half)
            delta -= CPR12;
          if (delta < -CPR12half)
            delta += CPR12;

          if (abs(delta) > ((int)CPR / 60)) // more than 1 minute off
          {
            ErrorCounter += 2;
            // ClockErrorText.concat("OneMinDiff ");
          }

          speedAdj = (float)delta / 600; // P regulator

          // low-pass filter for small movements
          if ((abs(speedAdj) > 2) || (!speedFilterValid))
          {
            speedAdjFiltered = speedAdj; // pass through - no filter
            speedFilterValid = true;
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
          speedFilterValid = false;
          ClockError = true;
          ClockErrorText.concat("EncoderError ");
        }

        if ((EncoderPosMT == 12) && (EncoderPosST > 100))
        {
          LogNS("Clock is at 12:00 -> Reset MT to 0...\r\n");
          EncoderSetMT(0);
        }
        if (EncoderWarning)
        {
          ClockWarning = true;
          ClockErrorText.concat("EncoderWarning ");
        }
      } // encoder read ok
      else
      { // reading encoder failed
        speedFilterValid = false;
        ClockError = true;
        ClockErrorText.concat("EncoderReadErr ");
      }

      // 400 steps = 1 hour = 60 min = 3600 s
      // speed = 400 steps / 3600 s = 0.11111 step / s
      float speedMotor = 0.11111111;

      if (abs(speedAdj) > 0.05) // ignore very tiny corrections
      {
        speedMotor += speedAdjFiltered;
      }

      MoveConstSpeed(speedMotor); // constant movement + corrections
    } // clock enabled
    else
    {
      speedFilterValid = false;
      if (encoderRead(false)) // print only if encoder encounters an error
        if ((EncoderPosMT == 12) && (EncoderPosST > 100))
        {
          LogNS("Clock is at 12:00 -> Reset MT to 0...\r\n");
          EncoderSetMT(0);
        }
    } // clock not enabled
  } // get time
  else
  {
    Log("Getting current time failed!");
    ClockErrorText.concat("GetTimeFail ");
    ClockError = true;
  }

  motorStatus_t motSta = MotorGetStatus();
  if (motSta == MSFAULT)
  {
    Log("Motor failure!");
    ClockErrorText.concat("MotorFail ");
    ErrorCounter = 4000;
    ClockError = true;
    // disable immediatelly
    EnableMotor(false);
    ClockEnabled = false;
  }
  if (motSta == MSSTALL)
  {
    Log("Stall detected. Moving backwards a bit.");
    ClockErrorText.concat("MotorStall ");
    ErrorCounter += 50;
    MoveConstSpeed(-SPEED_LIMIT); // max speed reverse
    delay(500);
    MoveConstSpeed(+SPEED_LIMIT); // max speed forward
    delay(600);
    speedFilterValid = false;
  }

  float MotorTemperatureRaw = TempSensorRead();

  // low-pass filter
  if ((abs(MotorTemperatureRaw - MotorTemperatureFiltered) > 7) || (!tempFilterValid))
  {
    MotorTemperatureFiltered = MotorTemperatureRaw; // pass through - no filter
    tempFilterValid = true;
  }
  else
  {
    MotorTemperatureFiltered = (MotorTemperatureRaw * 0.04) + (MotorTemperatureFiltered * 0.96);
  }

  MotorTemperature = roundToOneDecimal(MotorTemperatureFiltered);

  if (abs(MotorTempLastLogged - MotorTemperature) > 4)
  {
    Log("Motor temperature = %.1f C", MotorTemperature);
    MotorTempLastLogged = MotorTemperature;
  }
  if (MotorTemperature > (MOTOR_TEMP_MAX + 5))
  {
    Log("Motor too hot! Temperature = %.1f C", MotorTemperature);
    ClockErrorText.concat("MotorTooHot ");
    ErrorCounter = 4000;
    ClockError = true;
    // disable immediatelly
    EnableMotor(false);
    ClockEnabled = false;
  }
  else if (MotorTemperature > MOTOR_TEMP_MAX)
  {
    Log("Motor overheating! Temperature = %.1f C", MotorTemperature);
    ClockErrorText.concat("MotorHot ");
    ErrorCounter += 30;
    ClockWarning = true;
  }
  if (MotorTemperature < 10)
  {
    Log("Reading motor temperature failed! Temperature = %.1f C", MotorTemperature);
    ClockErrorText.concat("TempSensorFail ");
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
    Log("ErrorCounter increasing! (diff = %.2f min) ", (float)delta * 60 / CPR);
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
    ClockErrorText.concat("ErrCntrTooBig ");
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

  if (ErrorCounter > 10)
    ClockWarning = true;

  if (ErrorCounter > 1000)
    ClockError = true;

  if (!WifiIsConnected())
    ClockWarning = true;

  if (ClockWarning)
  {
    ClockErrorText.concat("WARNING (diff = ");
    ClockErrorText.concat(round((float)delta * 60 / CPR));
    ClockErrorText.concat(" min) ");
  }
  if (ClockError)
    ClockErrorText.concat("ERROR ");

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
    LogNS("CMD: Power = %d\r\n", ConfigBgPower);
    MqttCommandReceived = true;
  }
  if (MqttCommandBrightnessReceived)
  {
    MqttCommandBrightnessReceived = false;
    LogNS("CMD: Brightness = %d\r\n", ConfigBgBrightness);
    // LED_SetDimming(MqttCommandBrightness); // system indicators have own brightness
    MqttCommandReceived = true;
  }
  if (MqttCommandColorReceived)
  {
    MqttCommandColorReceived = false;
    LogNS("CMD: RGB = 0x%6X\r\n", ConfigBgColor);
    MqttCommandReceived = true;
  }
  if (MqttCommandEffectReceived)
  {
    MqttCommandEffectReceived = false;
    LogNS("CMD: Effect = %d (%s)\r\n", ConfigBgEffectNumber, ConfigBgEffectStr.c_str());
    MqttCommandReceived = true;
  }
  if (MqttCommandEffectDurationReceived)
  {
    MqttCommandEffectDurationReceived = false;
    LogNS("CMD: Rainbow sec = %.1f\r\n", ConfigEffectDuration);
    MqttCommandReceived = true;
  }
  /*
  if (MqttCommandDotsReceived)
  {
    MqttCommandDotsReceived = false;
    LogNS("CMD: Dots = %d\r\n", MqttCommandDots);
    MqttCommandReceived = true;
  }
  */
  if (MqttCommandDotsBrightnessReceived)
  {
    MqttCommandDotsBrightnessReceived = false;
    LogNS("CMD: Dots brightness = %d\r\n", ConfigDotsBrightness);
    MqttCommandReceived = true;
  }

  if (MqttCommandReceived)
  {
    lastMqttCommandExecuted = millis();
  }

  if (((millis() - lastMqttCommandExecuted) > (MQTT_SAVE_PREFERENCES_AFTER_SEC * 1000)) && (lastMqttCommandExecuted != -1))
  {
    lastMqttCommandExecuted = -1; // this means data was saved.
    storedConfigSave();
  }

  // fill sensors
  MqttStatusTemperture = MotorTemperature;
  MqttStatusRssi = WifiGetSignalLevel();
  MqttStatusErrorCounter = ErrorCounter;
  MqttStatusErrorText = ClockErrorText;

  MqttLoopInFreeTime();
#endif
}

//========================================================================================================

void MainLoopLEDTasks(void)
{
  uint32_t LEDcolor;

  if (!HasTimeElapsed(&LastTimeLEDTaskRun, 100))
    return; // run 10x per second

  /*
  if (CurrentHour != LastHour)
  {
    if ((CurrentHour >= NIGHT_TIME) || (CurrentHour < DAY_TIME))
    {
      LED_clear(true);
      LED_SetBrigtness(0);
      return; // don't process anything else. Keep it off.
    }
    else
    {
      if (CurrentHour >= EVENING_TIME)
      {
        LED_SetBrigtness(EVENING_TIME_DIMMING);
      }
      else
      {
        LED_SetBrigtness(DAY_TIME_BRIGHTNESS);
      }
    }
    LastHour = CurrentHour;
  }
  if (LED_mustBeOff())
    return; // don't process anything else. Keep it off.
*/

  if (!ConfigBgPower)
  {
    LED_clear(false); // background off
  }
  else
  {
    // background effect
    switch (ConfigBgEffectNumber)
    {
    case 0: // Static color
      LEDcolor = ConfigBgColor;
      adjustColorBrightness(&LEDcolor, ConfigBgBrightness); // background has individually adjustable brightness; not linked to clock's brightness
      LED_allSameColor(LEDcolor, false);                    // set background
      break;

    case 1: // Uniform rainbow
      LED_EffectRainbow(8, ConfigEffectDuration, ConfigBgBrightness);
      break;

    case 2: // Travelling full rainbow
      LED_EffectRainbow(1, ConfigEffectDuration, ConfigBgBrightness);
      break;

      case 3: // Travelling partial rainbow
      LED_EffectRainbow(3, ConfigEffectDuration, ConfigBgBrightness);
      break;

      case 4: // White sparkles over configured background
      LEDcolor = ConfigBgColor;
      adjustColorBrightness(&LEDcolor, ConfigBgBrightness);
      LED_EffectTwinkleFade(LEDcolor, clWHITEbright, (uint8_t)ConfigEffectDuration);
      //LED_EffectSparkling(LEDcolor, clWHITEbright, (uint8_t)(ConfigEffectDuration / 10));
      break;

      case 5: // 
      LED_EffectTEST();
      break;

    default:
      LED_clear(false); // dark
      break;
    }
  } // power = on

  if ((ConfigDotsBrightness > 0) || ((ConfigBgBrightness > 0) && (ConfigBgPower))) // show status if not total darkness
  {
    if (ClockError)
      LEDcolor = clREDbright;
    else if (ClockWarning)
      LEDcolor = clORANGEbright;
    else if (ClockEnabled)
      LEDcolor = clBLUEdim;
    else
      LEDcolor = clPINKbright;

    adjustColorBrightness(&LEDcolor, ((ConfigDotsBrightness + ConfigBgBrightness) / 2));

    LED_showSingleDot(0.00, LEDcolor, false); // just the top one
    if (ClockError || ClockWarning)
    {
      LED_showSingleDot(0.25, LEDcolor, false);
      LED_showSingleDot(0.50, LEDcolor, false);
      LED_showSingleDot(0.75, LEDcolor, false);
    }
  }

  if (ConfigDotsBrightness > 0)
  {
    LEDcolor = SECONDS_DOT_COLOR;
    adjustColorBrightness(&LEDcolor, ConfigDotsBrightness);
    LED_showSingleDot((float)CurrentSecond / 60, LEDcolor, false);

    LEDcolor = MINUTE_DOT_COLOR;
    adjustColorBrightness(&LEDcolor, ConfigDotsBrightness);
    LED_showSingleDot((float)CurrentMinute / 60, LEDcolor, false);

    LEDcolor = HOUR_DOT_COLOR;
    adjustColorBrightness(&LEDcolor, ConfigDotsBrightness);
    LED_showSingleDot((((float)CurrentHour12 + (float)CurrentMinute / 60)) / 12, LEDcolor, false);
  }

  LED_transmitData(); // push everything to the LED strip
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
