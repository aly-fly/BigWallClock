#ifndef _LEDS_H_
#define _LEDS_H_

#include <stdint.h>
#include "__CONFIG.h"

struct LEDdata_t
{
  uint8_t Red__;
  uint8_t Green;
  uint8_t Blue_;
};

extern LEDdata_t LEDdata[NR_OF_LEDS];

#define MAX_PHASE  768 // 256 up, 256 down, 256 off


void LED_init(void);
void LED_SetBrigtness (byte bright);
bool LED_mustBeOff(void);
void LED_SetPixelColor(int LedNum, uint32_t RGB, bool UpdateNow = false);
void LED_SetPixelColor(int LedNum, LEDdata_t RGB, bool UpdateNow);
void LED_clear(bool UpdateNow);
void LED_allSameColor(uint32_t RGB, bool UpdateNow);
void LED_showSingleDot(float pixel01, uint32_t dotColor, bool UpdateNow);
void LED_showProgressNumber(int clockNumber, uint32_t dotColor, uint32_t trailColor);
void LED_showProgressPercent(int percent, uint32_t dotColor, uint32_t trailColor);
void LED_transmitData(void);
void LED_test(void);

uint8_t gammaCorrection(uint8_t brightness);
void adjustColorBrightness(uint32_t *RGB, const uint8_t brightness);
void adjustColorBrightness(LEDdata_t *RGB, const uint8_t brightness);
void LED_EffectRainbow(uint16_t width, float duration_sec, uint8_t brightness);
void LED_EffectSparkling(uint32_t bgColor, uint32_t dotColor, uint8_t timeGap);
void LED_EffectTwinkleFade(uint32_t bgColor, uint32_t dotColor, uint8_t timeGap);
void LED_EffectTEST(void);


#define clREDbright    0xFF0000
#define clREDdim       0x440000
#define clGREENbright  0x00FF00
#define clGREENdim     0x004400
#define clBLUEbright   0x0000FF
#define clBLUEdim      0x000066

#define clWHITEbright  0xFFFFFF
#define clWHITEdim     0x444444

#define clORANGEdim    0x663300
#define clORANGEbright 0xFF7F00

#define clPINKbright   0xFF00FF

//#define LEDStatusLocation 64 // at the bottom
//#define LEDStatusLocation 127 // at the top

#endif // _LEDS_H_