
// C:\Users\aljaz\.platformio\packages\framework-arduinoespressif32\tools\sdk\esp32\include\ws2812_led
//  https://github.com/martinberlin/esp-rainmaker-examples/blob/master/components/ws2812_led/ws2812_led.c

#include "__CONFIG.h"
#include "esp32-hal-rmt.h"
#include "Logger.h"
#include "LEDs.h"

//======================================================================================================================

#define NR_OF_LEDS 128 // 0...127
#define NR_OF_ALL_BITS (24 * NR_OF_LEDS + 1)
#define LED_OFFSET 64

byte GlobalBrightness = 255;

struct LEDdata_t
{
    uint8_t Green;
    uint8_t Red;
    uint8_t Blue;
};

LEDdata_t LEDdata[NR_OF_LEDS];

rmt_data_t LEDtxBuffer[NR_OF_ALL_BITS];
//rmt_data_t LEDtxReset[1];
rmt_obj_t *MyRMT = NULL;

void LED_init(void)
{
    MyRMT = rmtInit(WS2812_LED_PIN, RMT_TX_MODE, RMT_MEM_64);

    if (MyRMT == NULL)
    {
        Log("RMT init failed");
    }
    float tickTime = rmtSetTick(MyRMT, 100); // 1 tick = 0.1 us (divisor = 8)
    Log("RMT Tick time = %.1f", tickTime);

    /*
    // reset code = LOW for minimum 50 or 280 us
    LEDtxReset[0].level0 = 0;
    LEDtxReset[0].duration0 = 1500;
    LEDtxReset[0].level1 = 0;
    LEDtxReset[0].duration1 = 1500;
    */
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

void LEDtransmitData(void)
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
                data = LEDdata[led].Red;
                break;
            case 2:
                data = LEDdata[led].Blue;
                break;
            }

            for (bit = 0; bit < 8; bit++)
            {                                // 1 tick = 0.1 us
                if (data & (1 << (7 - bit))) // bit 1 = 1.0 us HI + 0.2 us LO
                {
                    LEDtxBuffer[streamBitIdx].level0 = 1;
                    LEDtxBuffer[streamBitIdx].duration0 = 12;
                    LEDtxBuffer[streamBitIdx].level1 = 0;
                    LEDtxBuffer[streamBitIdx].duration1 = 3;
                }
                else                          // bit 0 = 0.2 us HI + 1.0 us LO
                {
                    LEDtxBuffer[streamBitIdx].level0 = 1;
                    LEDtxBuffer[streamBitIdx].duration0 = 3;
                    LEDtxBuffer[streamBitIdx].level1 = 0;
                    LEDtxBuffer[streamBitIdx].duration1 = 12;
                }
                streamBitIdx++;
            }
        }
    }

    // finish with constant HIGH (does not help...)
    LEDtxBuffer[streamBitIdx].level0 = 1;
    LEDtxBuffer[streamBitIdx].duration0 = 100;
    LEDtxBuffer[streamBitIdx].level1 = 1;
    LEDtxBuffer[streamBitIdx].duration1 = 100;

    // Send the data
    rmtWrite(MyRMT, LEDtxBuffer, NR_OF_ALL_BITS);
}

void LED_SetPixelColor(int LedNum, uint32_t RGB, bool UpdateNow)
{
    int LedNumOffset = LedNum - LED_OFFSET;
    if (LedNumOffset < 0)
        LedNumOffset += NR_OF_LEDS;

    if ((LedNumOffset < 0) || (LedNumOffset >= NR_OF_LEDS) || (GlobalBrightness == 0))
        return;

    LEDdata[LedNumOffset].Red = (((RGB >> 16) & 0xFF) * GlobalBrightness) >> 8;
    LEDdata[LedNumOffset].Green = (((RGB >> 8) & 0xFF) * GlobalBrightness) >> 8;
    LEDdata[LedNumOffset].Blue = (((RGB) & 0xFF) * GlobalBrightness) >> 8;

    if (UpdateNow)
    {
        LEDtransmitData();
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
        //rmtWrite(MyRMT, LEDtxReset, 1);
        LEDtransmitData();
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
        LEDdata[LedNum].Red = R;
        LEDdata[LedNum].Green = G;
        LEDdata[LedNum].Blue = B;
    }
    if (UpdateNow)
    {
        LEDtransmitData();
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
        LEDtransmitData();
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
    LEDtransmitData();
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

//==========================================================================================================

// rainbow functions


const uint16_t max_phase = 768;  // 256 up, 256 down, 256 off

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
  uint8_t green = phaseToIntensity((phase + 256) % max_phase);
  uint8_t blue = phaseToIntensity((phase + 512) % max_phase);
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
  phase = phase % max_phase;
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

void adjustBrightness(uint32_t *RGB, const uint8_t brightness)
{
  uint32_t R = (*RGB & 0xFF0000) >> 16;
  uint32_t G = (*RGB & 0x00FF00) >> 8;
  uint32_t B = (*RGB & 0x0000FF);
  R = (R * brightness) >> 8;
  G = (G * brightness) >> 8;
  B = (B * brightness) >> 8;
  *RGB = (R << 16) | (G << 8) | B;
}

// width = 1 -> full rainbow at once; 3 -> one third displayed at once
void rainbowPattern(uint16_t width, float duration_sec, uint8_t brightness)
{
  const float phase_per_pixel = (max_phase / NR_OF_LEDS) / width;

  // Rainbow roatation speed now configurable
  float duration = duration_sec * 1000;
  float phase = (float(millis() % (int)duration) / duration * max_phase);

  for (uint8_t pixel = 0; pixel < NR_OF_LEDS; pixel++)
  {
    // Shift the phase for this LED.
    uint16_t my_phase = ((uint32_t)round(phase + pixel * phase_per_pixel) % max_phase);
    uint32_t RGBcolor = phaseToColor(my_phase);
    adjustBrightness(&RGBcolor, brightness);
    LED_SetPixelColor(pixel, RGBcolor, false);
  }
}


