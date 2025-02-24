#include <Arduino.h>
#include <ArduinoOTA.h>
#include "Logger.h"
#include "LED_builtin.h"
#include "LEDs.h"

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
                       const char *msga = "OTA Update Started";
                       const char *msgb = "";
                       if (ArduinoOTA.getCommand() == U_FLASH)
                       {
                         msgb = "Type: sketch";
                       }
                       else
                       {
                         msgb = "Type: filesystem"; // U_SPIFFS, U_LITTLEFS
                       }
                       Log(msga); // Show messages in debug
                       Log(msgb);
                       // stop any interrupts or background tasks here...
                       // ...
                       divisor = 99;
                     });

  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total)
                        {
    divisor++;
    if (divisor >= 5)
    {
      int percent = (progress * 100) / total;
      LogNS("Progress: %u%%\r\n", percent);
      LED_showProgress(percent, clGREENbright, clGREENdim);
      LEDbuiltin_Toggle();
      divisor = 0;
    } });

  ArduinoOTA.onEnd([]()
                   {
    const char* msg = "OTA Done!" ;
    Log(msg) ;                     // Show message in debug
    LED_allSameColor(clBLUEbright, true);
    delay (600); });

  ArduinoOTA.onError([](ota_error_t error)
                     {
    const char* msga = "OTA Error" ;
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
    Log(msga) ;                    // Show messages in debug
    Log(msgb) ;

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
