
#include <stdint.h>

void LED_init(void);
void LED_Dimming (byte dim);
void LED_color(int LedNum, uint32_t RGB, bool UpdateNow = false);
void LED_clear(bool UpdateNow);
void LED_allSameColor(uint32_t RGB, bool UpdateNow);
void LED_showProgress(int percent, uint32_t dotColor, uint32_t trailColor);
void LED_test(void);

#define clREDbright    0xFF0000
#define clREDdim       0x440000
#define clGREENbright  0x00FF00
#define clGREENdim     0x004400
#define clBLUEbright   0x0000FF
#define clBLUEdim      0x000066

#define clWHITEdim     0x444444

#define clORANGEdim    0x663300
#define clORANGEbright 0xFF7F00

#define clPINKbright   0xFF00FF

//#define LEDStatusLocation 64 // at the bottom
#define LEDStatusLocation 127 // at the top
