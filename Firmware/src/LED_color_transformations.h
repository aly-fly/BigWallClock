#include "LEDs.h"

void adjustColorBrightness(uint32_t *RGB, const uint8_t brightness);
void adjustColorBrightness(LEDdata_t *RGB, const uint8_t brightness);
uint8_t gammaCorrection(uint8_t brightness);
void LED_fade_to_black_one_step(void);
void LED_fade_to_color_one_step(uint32_t targetColor, uint8_t speed);

uint8_t phaseToIntensity(uint16_t phase);
uint32_t phaseToColor(uint16_t phase);
uint32_t hueToPhase(float hue);
float phaseToHue(uint32_t phase);
