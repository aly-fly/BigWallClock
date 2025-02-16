#include <Arduino.h>
#include <ArduinoOTA.h>
#include "Logger.h"
#include "LED_builtin.h"

//**************************************************************************************************
//                                         O T A S E T U P                                         *
//**************************************************************************************************
// Update via WiFi/Ethernet has been started by Arduino IDE or PlatformIO.                         *
//**************************************************************************************************
void OTA_init(void)
{
  ArduinoOTA.setRebootOnSuccess(true);

  ArduinoOTA.onStart([]() {
    const char* msga = "OTA Update Started" ;
    const char* msgb = "" ;
    if ( ArduinoOTA.getCommand() == U_FLASH ) {
      msgb = "Type: sketch";
    } else {
      msgb = "Type: filesystem" ;                     // U_SPIFFS, U_LITTLEFS
    }
    Log(msga);                    // Show messages in debug
    Log(msgb);
    // stop any interrupts or background tasks here...
    // ...
  });

  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
    LogNS("Progress: %u%%\r\n", (progress / (total / 100))); // Show event for debug
    LEDbuiltin_Toggle();
  });

  ArduinoOTA.onEnd([]() {
    const char* msg = "OTA Done!" ;
    Log(msg) ;                     // Show message in debug
  });

  ArduinoOTA.onError([](ota_error_t error) {
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
  });

  ArduinoOTA.begin();                                 // Initialize
}

//**************************************************************************************************

void OTA_loop(void)
{
  ArduinoOTA.handle() ;                           // Check for OTA
}

//**************************************************************************************************
