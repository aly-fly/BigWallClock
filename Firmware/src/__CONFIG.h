/*
 * Author: Aljaz Ogrin
 * Project: 
 * Hardware: ESP32
 * File description: Global configuration for the project
 */
 
#ifndef __CONFIG_H_
#define __CONFIG_H_

#include <arduino.h>
#include "____CONFIG_SECRETS.h"

// ********************* General config *********************
#define DEBUG_OUTPUT
#define DBG_SOCKET_ENABLED 1
#define DBG_SOCKET_PORT 23

#define DEVICE_NAME "WallClock" // no spaces!
#define WIFI_CONNECT_TIMEOUT_SEC 240  // How long to wait for WiFi

#define TIME_SERVER1  "si.pool.ntp.org"
#define TIME_SERVER2  "pool.ntp.org"
#define TIME_SERVER3  "time.nist.gov"
/* timezone: 
find your string here: https://github.com/nayarsystems/posix_tz_db/blob/master/zones.csv
decoding of the string: https://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html
*/
#define TIMEZONE "CET-1CEST,M3.5.0,M10.5.0/3"  // Europe/Ljubljana
/*
#define DAY_TIME       6
#define EVENING_TIME  22
#define NIGHT_TIME    23
*/
// ********************* WiFi config *********************
//#define WIFI_SSID  "..." -> enter into the file __CONFIG_SECRETS.h
//#define WIFI_PASSWD "..."
#define WIFI_RETRY_CONNECTION_SEC  90


// ********************* MQTT config *********************
#define MQTT_ENABLED                     1  // enable general MQTT support
#define MQTT_SAVE_PREFERENCES_AFTER_SEC 30  // auto save config X seconds after last MQTT message received

#define MQTT_REPORT_STATUS_EVERY_SEC    60  // report status to MQTT every X seconds
#define MQTT_RECONNECT_WAIT_SEC         20  // wait X seconds before trying to reconnect to MQTT broker

#define MQTT_RETAIN_STATE_MESSAGES      false  // https://www.home-assistant.io/integrations/mqtt/#using-retained-state-messages

#define MQTT_ALIVE_TOPIC             "connection" // availability_topic :: https://www.home-assistant.io/integrations/mqtt/#availability_topic
#define MQTT_ALIVE_MSG_ONLINE        "online"     // default in HA. If changed, configure "payload_available" and "payload_not_available"
#define MQTT_ALIVE_MSG_OFFLINE       "offline"
#define MQTT_RETAIN_ALIVE_MESSAGES   false

// --- MQTT Home Assistant settings ---
// You will either need a local MQTT broker to use MQTT with Home Assistant (e.g. Mosquitto) or use an internet-based broker with Home Assistant support.
// If not done already, you can set up a local one easily via an Add-On in HA. See: https://www.home-assistant.io/integrations/mqtt/
// Enter the credential data into the MQTT broker settings section below accordingly.

#define MQTT_HOME_ASSISTANT_DISCOVERY                     1             // Uncomment if you want HA auto-discovery
#define MQTT_RETAIN_DISCOVERY_MESSAGES                    false         // https://www.home-assistant.io/integrations/mqtt/#discovery-messages-and-availability
// retain discovery = true:  Configuration is stored in the MQTT broker. HA directly responds to the existing messages. Configuration can be deleted on the MQTT broker (use MQTT Explorer program).  Restart of the broker, device or HA does not clear the config.
// retain discovery = false: Configuration is stored in the HA and can be deleted in Settings -> Devices -> MQTT. Restart of the broker, device or HA does not clear the config.
#define MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MANUFACTURER "Aljaz"       // Name of the manufacturer shown in HA
#define MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL        DEVICE_NAME   // Name of the model shown in HA
//#define MQTT_HOME_ASSISTANT_DISCOVERY_SW_VERSION          VERSION       // Firmware version shown in HA
#define MQTT_HOME_ASSISTANT_DISCOVERY_HW_VERSION          "1.0"         // Hardware version shown in HA

// --- MQTT broker settings ---
/*  -> enter into the file __CONFIG_SECRETS.h
#define MQTT_BROKER    ...                    // Broker host
#define MQTT_PORT      1883                   // Broker port
#define MQTT_USERNAME  ...                    // Username
#define MQTT_PASSWORD  ...                    // Password
*/
#define MQTT_CLIENT    DEVICE_NAME            // Device Id 
// #define MQTT_USE_TLS                                 // Use TLS for MQTT connection. Setting a root CA certificate is needed!
                                                     // Don't forget to copy the correct certificate file into the 'data' folder and rename it to mqtt-ca-root.pem!
                                                     // Example CA cert (Let's Encrypt CA cert) can be found in the 'data - other graphics' subfolder in the root of this repo

// ********************* Hardware *********************
  
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

// ********************* Motor *********************

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

// ********************* Motor temp sensor *********************

#define TEMP_SENS_PIN     GPIO_NUM_39 // ADC1_CH03, input only, No internal pullup (label "VN")
#define TEMP_SENS_R25       10000
#define TEMP_SENS_BETA      3984      // part number NTCALUG01T103G201 
#define TEMP_SENS_RPULLUP   10000
#define TEMP_SENS_OFFSET    -3.0

#define MOTOR_TEMP_MAX        50      // °C

// ********************* Encoder *********************

#define RXD2pin  16
#define TXD2pin  17

#define CPR 131072
#define CPR12 (CPR * 12)
#define CPR12half (CPR * 5)

// ********************* LED *********************

#define WS2812_LED_PIN      GPIO_NUM_32
#define HOUR_DOT_COLOR      clREDbright
#define MINUTE_DOT_COLOR    clGREENbright
#define SECONDS_DOT_COLOR   clWHITEbright

#define EVENING_TIME_DIMMING     25
#define DAY_TIME_BRIGHTNESS     255

#define SYS_LED_PIN        GPIO_NUM_2

// ********************* LOG *********************

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
