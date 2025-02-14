/*
 * Author: Aljaz Ogrin
 * Project:
 * Original location: https://github.com/aly-fly/
 * Hardware: ESP32
 * File description: Puts a server on defined port. Opens a raw socket (plain text), same as serial monitor. This application sends limited diagnostic data.
 * Useful for debugging, when wired serial port is not available, for example when Roomba is moving around the house.
 * To receive data, use Android app: https://play.google.com/store/apps/details?id=de.kai_morich.serial_wifi_terminal
 * Or on Windows: https://ttssh2.osdn.jp/   (https://en.wikipedia.org/wiki/Tera_Term)
 * Configuration: open file "global_defines.h"
 * Reference: /
 */

#include "__CONFIG.h"
#include "Arduino.h"
#include "WiFi.h"
#include <WiFiClient.h>

#include "TcpSocket.h"

#ifdef DBG_SOCKET_ENABLED
WiFiServer SocketServer(DBG_SOCKET_PORT);
WiFiClient SocketClient;
#endif

bool SocketConnected = false;

void startTcpSocket()
{
#ifdef DBG_SOCKET_ENABLED
  SocketServer.begin();
  Serial.println("Debug Socket Server running on port: " + String(DBG_SOCKET_PORT));
  Serial.println("");
#endif
}

void SendToSocket(String txt)
{
#ifdef DBG_SOCKET_ENABLED
  if (SocketClient.connected())
  {
    SocketClient.write(txt.c_str(), txt.length());
  }
#endif
}

void SendToSocket(char cc)
{
#ifdef DBG_SOCKET_ENABLED
  if (SocketClient.connected())
  {
    SocketClient.write(cc);
  }
#endif
}

bool DataAvailableInSocket(void)
{
#ifdef DBG_SOCKET_ENABLED
  if (SocketClient.connected())
  {
    return SocketClient.available();
  }
#endif
  return false;
}

String ReadFromSocket(void)
{
#ifdef DBG_SOCKET_ENABLED
  if (SocketClient.connected())
  {
    if (SocketClient.available())
    {
      return SocketClient.readString();
    }
  }
#endif
  return "";
}

void LoopSocketServer()
{
#ifdef DBG_SOCKET_ENABLED

  // can handle only one client at once. Process this client until disconnected.
  if (SocketClient.connected())
  {
    SocketConnected = true;
  }
  else
  {
    if (SocketConnected) // has just disconnected
    {
      SocketClient.stop();
      Serial.println("SocketClient Disconnected.");
      SocketConnected = false;
    }
    SocketClient = SocketServer.available(); // listen for incoming Clients
    if (SocketClient)
    {                                      // if you get a SocketClient,
      Serial.println("New SocketClient."); // print a message out the serial port
      // send welcome message
      SendToSocket(SERIAL_COMMANDS_LIST);
    }
  }
#endif
}
