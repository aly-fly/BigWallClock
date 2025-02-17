
#include <stdint.h>

void LED_init(void);
void LED_Dimming (byte dim);
void LED_color(int LedNum, uint32_t RGB, bool UpdateNow = false);
void LED_clear(bool UpdateNow);
void LED_allSameColor(uint32_t RGB, bool UpdateNow);
void LED_showProgress(int percent);

void LED_test(void);

#define LED_REDbright 0xFF0000
#define LED_REDdim    0x440000
#define LED_GRNbright 0x00FF00
#define LED_GRNdim    0x003300
#define LED_BLUbright 0x0000FF
#define LED_BLUdim    0x000044

#define LED_WHTdim    0x555555

#define LED_ORANGE    0x663300
