/*
 * Author: Aljaz Ogrin
 * Project: 
 * Hardware: ESP32
 * File description: Global configuration for the project
 */
 
#ifndef __CONFIG_H_
#define __CONFIG_H_

#include <arduino.h>

// ************ General config *********************
#define DEBUG_OUTPUT
#define DBG_SOCKET_ENABLED 1
#define DBG_SOCKET_PORT 23

#define DEVICE_NAME "WallClock"
#define WIFI_CONNECT_TIMEOUT_SEC 240  // How long to wait for WiFi

#define TIME_SERVER1  "si.pool.ntp.org"
#define TIME_SERVER2  "pool.ntp.org"
#define GMT_OFFSET  1
#define DST_OFFSET  1

#define DAY_TIME       7
#define EVENING_TIME  22
#define NIGHT_TIME    23

// ************ WiFi config *********************
//#define WIFI_SSID  "..." -> enter into the file __CONFIG_SECRETS.h
//#define WIFI_PASSWD "..."
#define WIFI_RETRY_CONNECTION_SEC  90


// ************ Hardware *********************

#define RXD2pin  16
#define TXD2pin  17

  
#ifdef FREE_JTAG_PINS
  #define TFT_CS        0
  #define TFT_SCLK      0
  #define TFT_MISO      0
  #define TFT_MOSI      0
#else
  #define TFT_CS        15  // JTAG !!
  #define TFT_SCLK      14  // JTAG !!
  #define TFT_MISO      12  // JTAG !!
  #define TFT_MOSI      13  // JTAG !!
#endif

// ************ Motor *********************

// Pin definitions
#define nSTBY_nRESET_PIN   GPIO_NUM_21
//#define nBUSY_PIN          not connected

// VSPI bus is normally attached to pins 5, 18, 19 and 23, but can be matrixed to any pins
#define VSPI_nCS           GPIO_NUM_5
#define VSPI_SCK           GPIO_NUM_18
#define VSPI_MISO          GPIO_NUM_19 // SDO
#define VSPI_MOSI          GPIO_NUM_23 // SDI

#define HIGH_POWER      50
#define LOW_POWER       33
#define OVERCURRENT_LVL  2
#define STALL_LVL        5
#define SPEED_LIMIT     50

// ************ Motor temp sensor *********************

#define TEMP_SENS_PIN     GPIO_NUM_39 // ADC1_CH03, input only, No internal pullup (label "VN")
#define TEMP_SENS_R25       10000
#define TEMP_SENS_BETA      3984      // part number NTCALUG01T103G201 
#define TEMP_SENS_RPULLUP   10000
#define TEMP_SENS_OFFSET    -3.0

#define MOTOR_TEMP_MAX        50      // °C

// ************ Encoder *********************

#define CPR 131072
#define CPR12 (CPR * 12)
#define CPR12half (CPR * 5)

// ************ LED *********************

#define WS2812_LED_PIN      GPIO_NUM_32
#define SECONDS1_DOT_COLOR  clWHITEdim
#define SECONDS2_DOT_COLOR  clBLUEbright

#define EVENING_TIME_DIMMING     14
#define DAY_TIME_BRIGHTNESS     200  // max 255

#define SYS_LED_PIN        GPIO_NUM_2

// ************ LOG *********************

#define LOG_FILE_wPATH "/log.txt"

#define SERIAL_COMMANDS_LIST  "Serial commands: \r\n" \
                              "  00..12M -> Hour preset\r\n" \
                              "  Z       -> Encoder zero\r\n" \
                              "  1..0E   -> Enable clock\r\n" \
                              "  1..0T   -> Test mode\r\n" \
                              "  1..9C   -> Constant speed\r\n" \
                              "  G       -> Encoder air gap? (loop)\r\n" \
                              "  P       -> Encoder position? (loop)\r\n" \
                              "  S       -> System status?\r\n" \
                              " LL       -> Print log contents\r\n" \
                              " DL       -> Delete log file\r\n" \
                              "  R       -> Reboot\r\n" \
                              "  ?       -> Print this message\r\n"


#endif /* __CONFIG_H_ */
