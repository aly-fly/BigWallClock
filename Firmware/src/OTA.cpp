#include <Arduino.h>
#include <ArduinoOTA.h>
#include "Logger.h"
#include "LED_builtin.h"
#include "LEDs.h"
#include "Mqtt_client_HA.h"

// hint: for web server version of OTA use: https://github.com/ayushsharma82/ElegantOTA

int divisor = 0;

//**************************************************************************************************
//                                         O T A S E T U P                                         *
//**************************************************************************************************
// Update via WiFi/Ethernet has been started by Arduino IDE or PlatformIO.                         *
//**************************************************************************************************

void OTA_init(void)
{
  ArduinoOTA.setRebootOnSuccess(true);

  ArduinoOTA.onStart([]()
                     {
                       if (ArduinoOTA.getCommand() == U_FLASH)
                       {
                         Log("OTA Update Started. Loading Program.");
                       }
                       else
                       {
                         Log("OTA Update Started. Loading Data section.");
                       }

                       // stop any interrupts or background tasks here...
                       MqttStop();
                       divisor = 99; // update LEDs imediatelly
                     });

  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total)
                        {
    divisor++;
    if (divisor >= 5)
    {
      unsigned int percent = (progress * 100) / total;
      LogNS("Progress: %u%%\r\n", percent);
      LED_showProgressPercent(percent, clGREENbright, clGREENdim);
      LEDbuiltin_Toggle();
      divisor = 0;
    } });

  ArduinoOTA.onEnd([]()
                   {
    Log("OTA Update Finished.");
    loggerPurgeToFile(true);
    LED_allSameColor(clBLUEdim, true);
    delay (600); });

  ArduinoOTA.onError([](ota_error_t error)
                     {
    const char* msgb = "" ;
    if ( error == OTA_AUTH_ERROR )
    {
      msgb = "Authentication Failed" ;
    }
    else if ( error == OTA_BEGIN_ERROR )
    {
      msgb = "Begin Failed" ;
    } 
    else if ( error == OTA_CONNECT_ERROR )
    {
      msgb = "Connection Failed" ;
    }
    else if ( error == OTA_RECEIVE_ERROR )
    {
      msgb = "Receive Failed" ;
    }
    else if ( error == OTA_END_ERROR )
    {
      msgb = "End Failed" ;
    }
    Log("OTA Error: %s", msgb);
    loggerPurgeToFile(true);
    LED_allSameColor(clREDdim, true);
    delay (2000); });

  ArduinoOTA.begin(); // Initialize
}

//**************************************************************************************************

void OTA_loop(void)
{
  ArduinoOTA.handle(); // Check for OTA
}

//**************************************************************************************************
