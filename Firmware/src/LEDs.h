
#include <stdint.h>

void LED_init(void);
void LED_off(void);
void LED_Dimming (byte dim);
void LED_color(int LedNum, uint32_t RGB, bool UpdateNow = false);

#define LED_REDbright 0xFF0000
#define LED_REDdim    0x440000
#define LED_GRNbright 0x00FF00
#define LED_GRNdim    0x003300
#define LED_BLUbright 0x0000FF
#define LED_BLUdim    0x000044

#define LED_ORANGE    0x663300
