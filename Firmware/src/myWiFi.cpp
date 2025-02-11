#include <Arduino.h>
#include <stdint.h>
#include <esp_wifi.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <esp_sntp.h>
#include "esp_wps.h"
#include "myWiFi.h"
#include "Logger.h"

WiFiMulti wifiMulti;


void WiFiEvent(WiFiEvent_t event, WiFiEventInfo_t info){
  IPAddress myIP;
  switch(event){
    case ARDUINO_EVENT_WIFI_STA_START:
      //WifiState = disconnected;
      Log("Station Mode Started");
      break;
    case ARDUINO_EVENT_WIFI_STA_CONNECTED: // IP not yet assigned
      Log("Connected to AP: %s", WiFi.SSID());
      break;     
    case ARDUINO_EVENT_WIFI_STA_GOT_IP:
      myIP = WiFi.localIP();
      Log("Got IP: %s", myIP.toString());
      //WifiState = connected;
      break;
    case ARDUINO_EVENT_WIFI_STA_DISCONNECTED:
      //WifiState = disconnected;
      Log("WiFi lost connection. Reason: %d", info.wifi_sta_disconnected.reason);
      break;
    default:
      break;
  }
}


// !! The bit 0 of the first byte of ESP32 MAC address can not be 1. For example, the MAC address can set to be “1a:XX:XX:XX:XX:XX”, but can not be “15:XX:XX:XX:XX:XX”.
uint8_t newMACAddress[] = {0x50, 0xCD, 0x98, 0x76, 0x54, 0x10};

bool WifiInit(void)  {
/*
  // Get MAC address of the WiFi station interface
  uint8_t baseMac[6];
  esp_read_mac(baseMac, ESP_MAC_WIFI_STA);
*/  
/*
  WiFi.mode(WIFI_OFF);
  Serial.print("My old MAC = ");
  Serial.println(WiFi.macAddress());

//  esp_err_t err = esp_wifi_set_mac(WIFI_IF_STA, &newMACAddress[0]);
  esp_err_t err = esp_wifi_set_mac(WIFI_IF_STA, newMACAddress);
  if (err == ESP_OK) {
      ESP_LOGI("MAC address", "MAC address successfully set.");
  } else {
      ESP_LOGE("MAC address", "Failed to set MAC address");
  }

  Serial.print("My new MAC = ");
  Serial.println(WiFi.macAddress());
*/

  WiFi.mode(WIFI_STA);
  WiFi.config(INADDR_NONE, INADDR_NONE, INADDR_NONE, INADDR_NONE);  
  WiFi.setHostname(DEVICE_NAME);  
  WiFi.onEvent(WiFiEvent);

#ifdef WIFI_SSID2
  Log("Multi WiFi start...");
  wifiMulti.addAP(WIFI_SSID1, WIFI_PASSWD1);
  wifiMulti.addAP(WIFI_SSID2, WIFI_PASSWD2);
#ifdef WIFI_SSID3
  wifiMulti.addAP(WIFI_SSID3, WIFI_PASSWD3);
#endif
  if(wifiMulti.run() != WL_CONNECTED) {
    Log("WiFi connection timeout!");
    delay(2000);
    //WifiState = disconnected;
    return false; // exit loop, exit procedure, continue startup
  }
#else
  Log("WiFi start...");
  WiFi.begin(WIFI_SSID1, WIFI_PASSWD1); 
  unsigned long StartTime = millis();
  while ((WiFi.status() != WL_CONNECTED)) {
    delay(500);
    //Serial.print(".");
    if ((millis() - StartTime) > (WIFI_CONNECT_TIMEOUT_SEC * 1000)) {
      //Serial.println();
      Log("WiFi connection timeout!");
      //delay(2000);
      //WifiState = disconnected;
      return false; // exit loop, exit procedure, continue startup
    }
  }
#endif
  
  //Serial.println();
  Log("WiFi connected. SSID: %s, IP: %s", WiFi.SSID(), WiFi.localIP().toString());
  delay(200);
  return true;
}

void WifiReconnectIfNeeded(void) {
  if (!WiFi.isConnected()) {
    Log("Attempting WiFi reconnection...");
    WiFi.reconnect();
  }    
}


