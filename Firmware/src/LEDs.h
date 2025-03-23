
#include <stdint.h>

void LED_init(void);
void LED_SetDimming (byte dim);
byte LED_GetDimming(void);
void LED_SetPixelColor(int LedNum, uint32_t RGB, bool UpdateNow = false);
void LED_clear(bool UpdateNow);
void LED_allSameColor(uint32_t RGB, bool UpdateNow);
void LED_showSingleDot(float pixel01, uint32_t dotColor, bool UpdateNow);
void LED_showProgressNumber(int clockNumber, uint32_t dotColor, uint32_t trailColor);
void LED_showProgressPercent(int percent, uint32_t dotColor, uint32_t trailColor);
void LED_test(void);

uint8_t gammaCorrection(uint8_t brightness);
void adjustColorBrightness(uint32_t *RGB, const uint8_t brightness);
void rainbowPattern(uint16_t width, float duration_sec, uint8_t brightness);


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
