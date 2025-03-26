
// C:\Users\aljaz\.platformio\packages\framework-arduinoespressif32\tools\sdk\esp32\include\ws2812_led
//  https://github.com/martinberlin/esp-rainmaker-examples/blob/master/components/ws2812_led/ws2812_led.c

#include <Arduino.h>
#include "esp32-hal-rmt.h"
#include "Logger.h"
#include "LEDs.h"
#include "LED_color_transformations.h"

//======================================================================================================================

#define NR_OF_ALL_BITS (24 * NR_OF_LEDS)

byte GlobalBrightness = 255;

LEDdata_t LEDdata[NR_OF_LEDS];

rmt_data_t LEDtxBuffer[NR_OF_ALL_BITS];
rmt_obj_t *MyRMT = NULL;

// defines copied from FastLED library:

#ifndef F_CPU_RMT_CLOCK_MANUALLY_DEFINED // if user has not defined it manually then...
#if defined(CONFIG_IDF_TARGET_ESP32C6) && CONFIG_IDF_TARGET_ESP32C6 == 1
#define F_CPU_RMT_CLOCK_MANUALLY_DEFINED (80 * 1000000)
#elif defined(CONFIG_IDF_TARGET_ESP32H2) && CONFIG_IDF_TARGET_ESP32H2 == 1
#define F_CPU_RMT_CLOCK_MANUALLY_DEFINED (80 * 1000000)
#endif

#ifdef F_CPU_RMT_CLOCK_MANUALLY_DEFINED
#define F_CPU_RMT (F_CPU_RMT_CLOCK_MANUALLY_DEFINED)
#else
#define F_CPU_RMT (APB_CLK_FREQ)
#endif
#endif //  F_CPU_RMT_CLOCK_MANUALLY_DEFINED

#define DIVIDER 2 /* 4, 8 still seem to work, but timings become marginal */

// -- Convert ESP32 CPU cycles to RMT device cycles, taking into account the divider
// RMT Clock is typically APB CLK, which is 80MHz on most devices, but 40MHz on ESP32-H2 and ESP32-C6
#define RMT_CYCLES_PER_SEC (F_CPU_RMT / DIVIDER)
#define RMT_CYCLES_PER_ESP_CYCLE (F_CPU / RMT_CYCLES_PER_SEC)
#define ESP_TO_RMT_CYCLES(n) ((n) / (RMT_CYCLES_PER_ESP_CYCLE))

#define CLOCKLESS_FREQUENCY F_CPU

#define C_NS(_NS) (((_NS * ((CLOCKLESS_FREQUENCY / 1000000L)) + 999)) / 1000)

#define FASTLED_OVERCLOCK 1.0
#define FASTLED_OVERCLOCK_WS2812 FASTLED_OVERCLOCK

// Allow overclocking various LED chipsets in the clockless family.
// Clocked chips like the APA102 don't need this because they allow
// you to control the clock speed directly.
#define C_NS_WS2812(_NS) (C_NS(int(_NS / FASTLED_OVERCLOCK_WS2812)))

#define FASTLED_WS2812_T1 250
#define FASTLED_WS2812_T2 625
#define FASTLED_WS2812_T3 375

#define T1 C_NS_WS2812(FASTLED_WS2812_T1)
#define T2 C_NS_WS2812(FASTLED_WS2812_T2)
#define T3 C_NS_WS2812(FASTLED_WS2812_T3)

// T1H
#define T1H ESP_TO_RMT_CYCLES(T1 + T2)
// T1L
#define T1L ESP_TO_RMT_CYCLES(T3)
// T0H
#define T0H ESP_TO_RMT_CYCLES(T1)
// T0L
#define T0L ESP_TO_RMT_CYCLES(T2 + T3)

/* LED = WS2812
  RMT Tick time = 25.0 ns
  Bit 0 timing: H 250.0 ns - L 1000.0 ns
  Bit 1 timing: H 875.0 ns - L 375.0 ns
*/

void LED_init(void)
{
  MyRMT = rmtInit(WS2812_LED_PIN, RMT_TX_MODE, RMT_MEM_256);

  if (MyRMT == NULL)
  {
    Log("RMT init failed");
  }
  //    float tickTime = rmtSetTick(MyRMT, 100); // 1 tick = 0.1 us (divisor = 8)
  float tickTime = rmtSetTick(MyRMT, 25); // 1 tick = 25 ns (divisor = 2) <- default
  Log("RMT Tick time = %.1f ns", tickTime);

  Log(" Bit 0 timing: H %.1f ns - L %.1f ns", (tickTime * T0H), (tickTime * T0L));
  Log(" Bit 1 timing: H %.1f ns - L %.1f ns", (tickTime * T1H), (tickTime * T1L));

  memset(LEDdata, 0, sizeof(LEDdata));
}

//
// Note: WS2812 LEDs chained one after another, each RGB LED has its 24 bit value
//      for color configuration (8b for each color)
//
//      Bits encoded as pulses as follows:
//
//      "0":
//         +-------+              +--
//         |       |              |
//         |       |              |
//         |       |              |
//      ---|       |--------------|
//         +       +              +
//         | 0.4us |   0.85 0us   |
//
//      "1":
//         +-------------+       +--
//         |             |       |
//         |             |       |
//         |             |       |
//         |             |       |
//      ---+             +-------+
//         |    0.8us    | 0.4us |

void LED_transmitData(void)
{
  int led, color, bit;
  int streamBitIdx = 0;
  byte data;

  for (led = 0; led < NR_OF_LEDS; led++)
  {
    for (color = 0; color < 3; color++)
    {
      switch (color) // WS2812 transfer bit order: G7...G0 R7...R0 B7...B0
      {
      case 0:
        data = LEDdata[led].Green;
        break;
      case 1:
        data = LEDdata[led].Red__;
        break;
      case 2:
        data = LEDdata[led].Blue_;
        break;
      }

      for (bit = 0; bit < 8; bit++)
      {                              // 1 tick = 0.1 us
        if (data & (1 << (7 - bit))) // bit 1 = 1.0 us HI + 0.2 us LO
        {
          LEDtxBuffer[streamBitIdx].level0 = 1;
          LEDtxBuffer[streamBitIdx].duration0 = T1H;
          LEDtxBuffer[streamBitIdx].level1 = 0;
          LEDtxBuffer[streamBitIdx].duration1 = T1L;
        }
        else // bit 0 = 0.2 us HI + 1.0 us LO
        {
          LEDtxBuffer[streamBitIdx].level0 = 1;
          LEDtxBuffer[streamBitIdx].duration0 = T0H;
          LEDtxBuffer[streamBitIdx].level1 = 0;
          LEDtxBuffer[streamBitIdx].duration1 = T0L;
        }
        streamBitIdx++;
      }
    }
  }

  // Send the data
  rmtWrite(MyRMT, LEDtxBuffer, NR_OF_ALL_BITS);
}

void LED_SetPixelColor(int LedNum, uint32_t RGB, bool UpdateNow)
{
  LEDdata_t pix;
  pix.Red__ = ((RGB >> 16) & 0xFF);
  pix.Green = ((RGB >> 8) & 0xFF);
  pix.Blue_ = ((RGB) & 0xFF);
  LED_SetPixelColor(LedNum, pix, UpdateNow);
}

void LED_SetPixelColor(int LedNum, LEDdata_t RGB, bool UpdateNow)
{
  int LedNumOffset = LedNum - LED_OFFSET;
  if (LedNumOffset < 0)
    LedNumOffset += NR_OF_LEDS;

  if ((LedNumOffset < 0) || (LedNumOffset >= NR_OF_LEDS) || (GlobalBrightness == 0))
    return;

  LEDdata[LedNumOffset].Red__ = (RGB.Red__ * GlobalBrightness) >> 8;
  LEDdata[LedNumOffset].Green = (RGB.Green * GlobalBrightness) >> 8;
  LEDdata[LedNumOffset].Blue_ = (RGB.Blue_ * GlobalBrightness) >> 8;

  if (UpdateNow)
  {
    LED_transmitData();
  }
}

void LED_SetBrigtness(byte bright)
{
  GlobalBrightness = gammaCorrection(bright);
  if (GlobalBrightness == 0)
    LED_clear(true);
}

// global brightness == 0
bool LED_mustBeOff(void)
{
  return GlobalBrightness == 0;
}

void LED_clear(bool UpdateNow)
{
  memset(LEDdata, 0, sizeof(LEDdata));
  if (UpdateNow)
  {
    LED_transmitData();
  }
}

void LED_allSameColor(uint32_t RGB, bool UpdateNow)
{
  uint32_t R = (RGB & 0xFF0000) >> 16;
  uint32_t G = (RGB & 0x00FF00) >> 8;
  uint32_t B = (RGB & 0x0000FF);
  R = (R * GlobalBrightness) >> 8;
  G = (G * GlobalBrightness) >> 8;
  B = (B * GlobalBrightness) >> 8;

  for (int LedNum = 0; LedNum < NR_OF_LEDS; LedNum++)
  {
    LEDdata[LedNum].Red__ = R;
    LEDdata[LedNum].Green = G;
    LEDdata[LedNum].Blue_ = B;
  }
  if (UpdateNow)
  {
    LED_transmitData();
  }
}

// Change single pixel color. Position 0.00 to 0.99
void LED_showSingleDot(float pixel01, uint32_t dotColor, bool UpdateNow)
{
  int idx = (int)round(pixel01 * NR_OF_LEDS);
  if (idx < 0)
    idx = 0;
  if (idx >= NR_OF_LEDS)
    idx = NR_OF_LEDS - 1;

  LED_SetPixelColor(idx, dotColor, false);
  if (UpdateNow)
    LED_transmitData();
}

void LED_showProgressNumber(int clockNumber, uint32_t dotColor, uint32_t trailColor)
{
  float percent = (float)clockNumber * 100 / 12;
  LED_showProgressPercent(round(percent), dotColor, trailColor);
}

void LED_showProgressPercent(int percent, uint32_t dotColor, uint32_t trailColor)
{
  // int idx = (int)round(((float)percent * NR_OF_LEDS) / 100);
  int idx = ((percent * ((NR_OF_LEDS * 2) + 1)) / 200); // + 0.5 to show both 0% and 100%
  uint32_t color;
  for (int i = 0; i < NR_OF_LEDS; i++)
  {
    if (i < idx)
      color = trailColor;
    else if (i == idx)
      color = dotColor;
    else
      color = 0; // 0x000505; // dim blue/green
    LED_SetPixelColor(i, color, false);
  }
  LED_transmitData();
}

//=====================================================================================================

void LED_test(void)
{
  Serial.println("LED test");
  uint32_t color;
  for (int i = 0; i < NR_OF_LEDS; i++)
  {
    Serial.println(i);
    switch (i % 3)
    {
    case 0:
      color = clREDdim;
      break;

    case 1:
      color = clGREENdim;
      break;

    default:
      color = clBLUEdim;
      break;
    }
    LED_SetPixelColor(i, color, true);
    delay(500);
  }

  delay(2000);
  LED_clear(true);
  Serial.println("LED test random");
  useRealRandomGenerator(true);
  byte r, g, b;

  for (int i = 0; i < NR_OF_LEDS; i++)
  {
    Serial.println(i);

    r = random(0, 123);
    g = random(0, 123);
    b = random(0, 123);
    color = (r << 16) | (g << 8) | b;
    LED_SetPixelColor(i, color, true);
    delay(500);
  }
}

/*
RGB sequencer

  if (LEDlastUpdate != CurrentSecond) // limit to 1x per second
  {
    byte LedNum, LedColorIdx;
    // clear pixels
    for (LedNum = 1; LedNum < 5; LedNum++)
    {
      LED_SetPixelColor(LedNum, 0, false);
    }
    LedNum = (LEDsequence % 4) + 1;
    LedColorIdx = (LEDsequence / 4);
    uint32_t LedColor;
    switch (LedColorIdx)
    {
    case 0:
      LedColor = LED_REDdim;
      break;
    case 1:
      LedColor = LED_GRNdim;
      break;

    default:
      LedColor = LED_BLUdim;
      break;
    }
    LED_SetPixelColor(LedNum, LedColor, true);
    LEDsequence++;
    if (LEDsequence >= 12)
      LEDsequence = 0;

    // LED_SetPixelColor(2, ((59 * 2) - (CurrentSecond * 2) << 16) | (CurrentSecond * 2), true);
    LEDlastUpdate = CurrentSecond;
  }
*/

//=======================================================================================================

// width = 1 -> full rainbow at once; 3 -> one third displayed at once
void LED_EffectRainbow(uint16_t width, float duration_sec, uint8_t brightness)
{
  const float phase_per_pixel = (MAX_PHASE / NR_OF_LEDS) / width;

  // Rainbow roatation speed is configurable
  float duration = duration_sec * 1000;
  float phase = (float(millis() % (unsigned int)duration) / duration * MAX_PHASE);

  for (uint8_t pixel = 0; pixel < NR_OF_LEDS; pixel++)
  {
    // Shift the phase for this LED.
    uint16_t my_phase = ((uint32_t)round(phase + pixel * phase_per_pixel) % MAX_PHASE);
    uint32_t RGBcolor = phaseToColor(my_phase);
    adjustColorBrightness(&RGBcolor, brightness);
    LED_SetPixelColor(pixel, RGBcolor, false);
  }
}

void LED_EffectSparkling(uint32_t bgColor, uint32_t dotColor, uint8_t timeGap)
{
  LED_allSameColor(bgColor, false);

  uint32_t dotColor2 = dotColor;
  adjustColorBrightness(&dotColor2, 120);
  if (random(0, timeGap) == 2)
    LED_SetPixelColor(random(0, NR_OF_LEDS - 1), dotColor2); // show dimmer dot
  if (random(0, timeGap) == 1)
    LED_SetPixelColor(random(0, NR_OF_LEDS - 1), dotColor2); // show dimmer dot
  if (random(0, timeGap) == 0)
    LED_SetPixelColor(random(0, NR_OF_LEDS - 1), dotColor); // show brighter dot
}

uint16_t twinkleLoopCounter = 0;
void LED_EffectTwinkleFade(uint32_t bgColor, uint32_t dotColor, uint8_t timeGap)
{
  if (twinkleLoopCounter == 0)
  {
    LED_allSameColor(bgColor, false);
    twinkleLoopCounter = 300; // repaint background every 30 seconds (to iron out any residual artefacts)
  }

  LED_fade_to_color_one_step(bgColor, timeGap / 10);

  if (random(0, (timeGap / 7 + 1)) == 0)
    LED_SetPixelColor(random(0, NR_OF_LEDS - 1), dotColor);

  twinkleLoopCounter--;
}

void LED_EffectTEST(void)
{

}

// #############################################################################################################
// #############################################################################################################
// #############################################################################################################
// #############################################################################################################
// #############################################################################################################
/*






// color blend function

uint32_t WS2812FX::color_blend(uint32_t color1, uint32_t color2, uint8_t blendAmt) {
  uint32_t blendedColor;
  blend((uint8_t*)&blendedColor, (uint8_t*)&color1, (uint8_t*)&color2, sizeof(uint32_t), blendAmt);
  return blendedColor;
}

uint8_t* WS2812FX::blend(uint8_t *dest, uint8_t *src1, uint8_t *src2, uint16_t cnt, uint8_t blendAmt) {
  if(blendAmt == 0) {
    memmove(dest, src1, cnt);
  } else if(blendAmt == 255) {
    memmove(dest, src2, cnt);
  } else {
    for(uint16_t i=0; i<cnt; i++) {
//    dest[i] = map(blendAmt, 0, 255, src1[i], src2[i]);
      dest[i] =  blendAmt * ((int)src2[i] - (int)src1[i]) / 256 + src1[i]; // map() function
    }
  }
  return dest;
}


// twinkle_fade function

uint16_t WS2812FX::twinkle_fade(uint32_t color) {
  fade_out();

  if(random8(3) == 0) {
    uint8_t size = 1 << SIZE_OPTION;
    uint16_t index = _seg->start + random16(_seg_len - size + 1);
    fill(color, index, size);
    SET_CYCLE;
  }
  return (_seg->speed / 16);
}


// color chase function.
// color1 = background color
// color2 and color3 = colors of two adjacent leds

uint16_t WS2812FX::chase(uint32_t color1, uint32_t color2, uint32_t color3) {
  uint8_t size = 1 << SIZE_OPTION;
  for(uint8_t i=0; i<size; i++) {
    uint16_t a = (_seg_rt->twinkleLoopCounter + i) % _seg_len;
    uint16_t b = (a + size) % _seg_len;
    uint16_t c = (b + size) % _seg_len;
    if(IS_REVERSE) {
      setPixelColor(_seg->stop - a, color1);
      setPixelColor(_seg->stop - b, color2);
      setPixelColor(_seg->stop - c, color3);
    } else {
      setPixelColor(_seg->start + a, color1);
      setPixelColor(_seg->start + b, color2);
      setPixelColor(_seg->start + c, color3);
    }
  }

  if(_seg_rt->twinkleLoopCounter + (size * 3) == _seg_len) SET_CYCLE;

  _seg_rt->twinkleLoopCounter = (_seg_rt->twinkleLoopCounter + 1) % _seg_len;
  return (_seg->speed / _seg_len);
}


// running white flashes function.
// color1 = background color
// color2 = flash color

uint16_t WS2812FX::chase_flash(uint32_t color1, uint32_t color2) {
  const static uint8_t flash_count = 4;
  uint8_t flash_step = _seg_rt->counter_mode_call % ((flash_count * 2) + 1);

  if(flash_step < (flash_count * 2)) {
    uint32_t color = (flash_step % 2 == 0) ? color2 : color1;
    uint16_t n = _seg_rt->twinkleLoopCounter;
    uint16_t m = (_seg_rt->twinkleLoopCounter + 1) % _seg_len;
    if(IS_REVERSE) {
      setPixelColor(_seg->stop - n, color);
      setPixelColor(_seg->stop - m, color);
    } else {
      setPixelColor(_seg->start + n, color);
      setPixelColor(_seg->start + m, color);
    }
    return 30;
  } else {
    _seg_rt->twinkleLoopCounter = (_seg_rt->twinkleLoopCounter + 1) % _seg_len;
    if(_seg_rt->twinkleLoopCounter == 0) {
      // update aux_param so mode_chase_flash_random() will select the next color
      _seg_rt->aux_param = get_random_wheel_index(_seg_rt->aux_param);
      SET_CYCLE;
    }
  }
  return (_seg->speed / _seg_len);
}


// Alternating pixels running function.

uint16_t WS2812FX::running(uint32_t color1, uint32_t color2) {
  uint8_t size = 2 << SIZE_OPTION;
  uint32_t color = (_seg_rt->twinkleLoopCounter & size) ? color1 : color2;

  if(IS_REVERSE) {
    copyPixels(_seg->start, _seg->start + 1, _seg_len - 1);
    setPixelColor(_seg->stop, color);
  } else {
    copyPixels(_seg->start + 1, _seg->start, _seg_len - 1);
    setPixelColor(_seg->start, color);
  }

  _seg_rt->twinkleLoopCounter++;
  if((_seg_rt->twinkleLoopCounter % _seg_len) == 0) SET_CYCLE;
  return (_seg->speed / 16);
}


// Fireworks function.

uint16_t WS2812FX::fireworks(uint32_t color) {
  fade_out();

// for better performance, manipulate the Adafruit_NeoPixels pixels[] array directly
  uint8_t *pixels = getPixels();
  uint8_t bytesPerPixel = getNumBytesPerPixel(); // 3=RGB, 4=RGBW
  uint16_t startPixel = _seg->start * bytesPerPixel + bytesPerPixel;
  uint16_t stopPixel = _seg->stop * bytesPerPixel;
  for(uint16_t i=startPixel; i <stopPixel; i++) {
    uint16_t tmpPixel = (pixels[i - bytesPerPixel] >> 2) +
      pixels[i] +
      (pixels[i + bytesPerPixel] >> 2);
    pixels[i] =  tmpPixel > 255 ? 255 : tmpPixel;
  }

  uint8_t size = 2 << SIZE_OPTION;
  if(!_triggered) {
    uint16_t numBursts = _seg_len/20 > 1 ? _seg_len/20 : 1;
    for(uint16_t i=0; i<numBursts; i++) {
      if(random8(10) == 0) {
        uint16_t index = _seg->start + random16(_seg_len - size + 1);
        fill(color, index, size);
        SET_CYCLE;
      }
    }
  } else {
    uint16_t numBursts = _seg_len/10 > 1 ? _seg_len/10 : 1;
    for(uint16_t i=0; i<numBursts; i++) {
      uint16_t index = _seg->start + random16(_seg_len - size + 1);
      fill(color, index, size);
      SET_CYCLE;
    }
  }

  return (_seg->speed / 16);
}


// Fire flicker function

uint16_t WS2812FX::fire_flicker(int rev_intensity) {
  uint8_t w = (_seg->colors[0] >> 24) & 0xFF;
  uint8_t r = (_seg->colors[0] >> 16) & 0xFF;
  uint8_t g = (_seg->colors[0] >>  8) & 0xFF;
  uint8_t b = (_seg->colors[0]        & 0xFF);
  uint8_t maxLum = g > b ? g : b;
  maxLum = maxLum > r ? maxLum : r;
  maxLum = maxLum > w ? maxLum : w;
  uint8_t lum = maxLum / rev_intensity;
  for(uint16_t i=_seg->start; i <= _seg->stop; i++) {
    uint8_t flicker = random8(lum);
    uint8_t r2 = (r - flicker) > 0 ? (r - flicker) : 0;
    uint8_t g2 = (g - flicker) > 0 ? (g - flicker) : 0;
    uint8_t b2 = (b - flicker) > 0 ? (b - flicker) : 0;
    uint8_t w2 = (w - flicker) > 0 ? (w - flicker) : 0;
    setPixelColor(i, r2, g2, b2, w2);
  }

  SET_CYCLE;
  return (_seg->speed / _seg_len);
}

*/
