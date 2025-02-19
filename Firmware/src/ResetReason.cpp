
// https://github.com/espressif/arduino-esp32/blob/646785e08668c299fc8c8a90ead588a57385d509/libraries/ESP32/examples/ResetReason/ResetReason/ResetReason.ino

/*
*  Print last reset reason of ESP32
*  =================================
*
*  Use either of the methods print_reset_reason
*  or verbose_print_reset_reason to display the
*  cause for the last reset of this device.
*/

#include <Arduino.h>

#if CONFIG_IDF_TARGET_ESP32
#include "esp32/rom/rtc.h"
#elif CONFIG_IDF_TARGET_ESP32S2
#include "esp32s2/rom/rtc.h"
#elif CONFIG_IDF_TARGET_ESP32C2
#include "esp32c2/rom/rtc.h"
#elif CONFIG_IDF_TARGET_ESP32C3
#include "esp32c3/rom/rtc.h"
#elif CONFIG_IDF_TARGET_ESP32S3
#include "esp32s3/rom/rtc.h"
#elif CONFIG_IDF_TARGET_ESP32C6
#include "esp32c6/rom/rtc.h"
#elif CONFIG_IDF_TARGET_ESP32H2
#include "esp32h2/rom/rtc.h"
#elif CONFIG_IDF_TARGET_ESP32P4
#include "esp32p4/rom/rtc.h"
#else
#error Target CONFIG_IDF_TARGET is not supported
#endif


String get_reset_reason(void) {
  int reason = rtc_get_reset_reason(0); // cpu core 0
  String result = "Reset reason: ";
  switch (reason) {
    case 1:  result.concat("POWERON_RESET - Vbat power on reset"); break;          /**<1,  Vbat power on reset*/
    case 3:  result.concat("SW_RESET - Software reset digital core"); break;               /**<3,  Software reset digital core*/
    case 4:  result.concat("OWDT_RESET - Legacy watch dog reset digital core"); break;             /**<4,  Legacy watch dog reset digital core*/
    case 5:  result.concat("DEEPSLEEP_RESET - Deep Sleep reset digital core"); break;        /**<5,  Deep Sleep reset digital core*/
    case 6:  result.concat("SDIO_RESET - Reset by SLC module, reset digital core"); break;             /**<6,  Reset by SLC module, reset digital core*/
    case 7:  result.concat("TG0WDT_SYS_RESET - Timer Group0 Watch dog reset digital core"); break;       /**<7,  Timer Group0 Watch dog reset digital core*/
    case 8:  result.concat("TG1WDT_SYS_RESET - Timer Group1 Watch dog reset digital core"); break;       /**<8,  Timer Group1 Watch dog reset digital core*/
    case 9:  result.concat("RTCWDT_SYS_RESET - RTC Watch dog Reset digital core"); break;       /**<9,  RTC Watch dog Reset digital core*/
    case 10: result.concat("INTRUSION_RESET - Instrusion tested to reset CPU"); break;        /**<10, Instrusion tested to reset CPU*/
    case 11: result.concat("TGWDT_CPU_RESET - Time Group reset CPU"); break;        /**<11, Time Group reset CPU*/
    case 12: result.concat("SW_CPU_RESET - Software reset CPU"); break;           /**<12, Software reset CPU*/
    case 13: result.concat("RTCWDT_CPU_RESET - RTC Watch dog Reset CPU"); break;       /**<13, RTC Watch dog Reset CPU*/
    case 14: result.concat("EXT_CPU_RESET - for APP CPU, reset by PRO CPU"); break;          /**<14, for APP CPU, reset by PRO CPU*/
    case 15: result.concat("RTCWDT_BROWN_OUT_RESET - Reset when the vdd voltage is not stable"); break; /**<15, Reset when the vdd voltage is not stable*/
    case 16: result.concat("RTCWDT_RTC_RESET - RTC Watch dog reset digital core and rtc module"); break;       /**<16, RTC Watch dog reset digital core and rtc module*/
    default: result.concat("NO_MEAN");
  }
  return result;
}

