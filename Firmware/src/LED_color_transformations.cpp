#include <Arduino.h>
#include "LEDs.h"

void adjustColorBrightness(uint32_t *RGB, const uint8_t brightness)
{
  uint8_t br = gammaCorrection(brightness);
  uint32_t R = (*RGB & 0xFF0000) >> 16;
  uint32_t G = (*RGB & 0x00FF00) >> 8;
  uint32_t B = (*RGB & 0x0000FF);
  R = (R * br) >> 8;
  G = (G * br) >> 8;
  B = (B * br) >> 8;
  *RGB = (R << 16) | (G << 8) | B;
}

void adjustColorBrightness(LEDdata_t *RGB, const uint8_t brightness)
{
  uint8_t br = gammaCorrection(brightness);
  RGB->Red__ = (RGB->Red__ * br) >> 8;
  RGB->Green = (RGB->Green * br) >> 8;
  RGB->Blue_ = (RGB->Blue_ * br) >> 8;
}

uint8_t gammaCorrection(uint8_t brightness)
{
  /* gamma = 2:
    0 ->   0
   64 ->  16
  128 ->  64
  192 -> 144
  255 -> 255
  */
  float input = brightness;
  float calc = input * input;
  calc = calc * 0.0039215686274509803921568627451;
  return (uint8_t)round(calc);
}

// custom gamma - create a look-uptable
// (int)(pow((float)i / (float)max_in, gamma) * max_out + 0.5));

// fade out functions
void LED_fade_to_black_one_step(void)
{
  for (int i = 0; i < NR_OF_LEDS; i++)
  {
    adjustColorBrightness(&LEDdata[i], 200);
    /*
    LEDdata_t pix;
    pix.Red__ = (LEDdata[i].Red__ >> 1) & 0x7F;
    pix.Green = (LEDdata[i].Green >> 1) & 0x7F;
    pix.Blue_ = (LEDdata[i].Blue_ >> 1) & 0x7F;
    LED_SetPixelColor(i, pix, false);
    */
  }
}

// speed = 1 (fastest) ... 6 (slowest)
void LED_fade_to_color_one_step(uint32_t targetColor, uint8_t speed)
{
  uint32_t color = targetColor;
  int r2 = (color >> 16) & 0xff;
  int g2 = (color >> 8) & 0xff;
  int b2 = color & 0xff;
  
  if (speed < 1) speed = 1;
  if (speed > 6) speed = 6;

  for (int i = 0; i < NR_OF_LEDS; i++)
  {
    int r1 = LEDdata[i].Red__;
    int g1 = LEDdata[i].Green;
    int b1 = LEDdata[i].Blue_;

    // calculate the color differences between the current and target colors
    int rdelta = r2 - r1;
    int gdelta = g2 - g1;
    int bdelta = b2 - b1;

    // if the current and target colors are almost the same, jump right to the target
    // color, otherwise calculate an intermediate color. (fixes rounding issues)
    rdelta = abs(rdelta) < 3 ? rdelta : (rdelta >> speed);
    gdelta = abs(gdelta) < 3 ? gdelta : (gdelta >> speed);
    bdelta = abs(bdelta) < 3 ? bdelta : (bdelta >> speed);

    LEDdata[i].Red__ = r1 + rdelta;
    LEDdata[i].Green = g1 + gdelta;
    LEDdata[i].Blue_ = b1 + bdelta;
  }
}

//==========================================================================================================

// rainbow functions

uint8_t phaseToIntensity(uint16_t phase)
{
  uint16_t color = 0;
  if (phase <= 255)
  {
    // Ramping up
    color = phase;
  }
  else if (phase <= 511)
  {
    // Ramping down
    color = 511 - phase;
  }
  else
  {
    // Off
    color = 0;
  }
  if (color > 255)
  {
    // TODO: Trigger ERROR STATE, bug in code.
  }
  return uint8_t(color % 256);
}

uint32_t phaseToColor(uint16_t phase)
{
  uint8_t red = phaseToIntensity(phase);
  uint8_t green = phaseToIntensity((phase + 256) % MAX_PHASE);
  uint8_t blue = phaseToIntensity((phase + 512) % MAX_PHASE);
  return (uint32_t(red) << 16 | uint32_t(green) << 8 | uint32_t(blue));
}

uint32_t hueToPhase(float hue)
{
  hue = hue - 120.f;
  if (hue < 0)
  {
    hue = hue + 360.f;
  }
  uint32_t phase = uint32_t(round(768.f * (1.f - hue / 360.f)));
  phase = phase % MAX_PHASE;
  return (phase);
}

float phaseToHue(uint32_t phase)
{
  float hue = 120.f + ((768.f - float(phase)) / 768.f) * 360.f;
  // h = 120 + (1 - p/768)*360
  if (hue >= 360.f)
  {
    hue = hue - 360.f;
  }
  return (round(hue));
}
