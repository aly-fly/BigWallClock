
// C:\Users\aljaz\.platformio\packages\framework-arduinoespressif32\tools\sdk\esp32\include\ws2812_led
//  https://github.com/martinberlin/esp-rainmaker-examples/blob/master/components/ws2812_led/ws2812_led.c

#include "__CONFIG.h"
#include "esp32-hal-rmt.h"
#include "Logger.h"
#include "LEDs.h"

//======================================================================================================================

#define NR_OF_LEDS 128  // 0...127
#define NR_OF_ALL_BITS 24 * NR_OF_LEDS
#define LED_OFFSET  64

byte Dimming = 255;

struct LEDdata_t
{
    uint8_t Green;
    uint8_t Red;
    uint8_t Blue;
};

LEDdata_t LEDdata[NR_OF_LEDS];

rmt_data_t LEDtxBuffer[NR_OF_ALL_BITS];
rmt_data_t LEDtxReset[1];
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

    // reset code duration defaults to 50us
    LEDtxReset[0].level0 = 0;
    LEDtxReset[0].duration0 = 500;
    LEDtxReset[0].level1 = 0;
    LEDtxReset[0].duration1 = 500;

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
            {
                if (data & (1 << (7 - bit))) // bit 1 = 0.25 us HI + 1.0 us LO
                {
                    LEDtxBuffer[streamBitIdx].level0 = 1;
                    LEDtxBuffer[streamBitIdx].duration0 = 10;
                    LEDtxBuffer[streamBitIdx].level1 = 0;
                    LEDtxBuffer[streamBitIdx].duration1 = 2;
                }
                else // bit 0 = 1.0 us HI + 1.0 us LO
                {
                    LEDtxBuffer[streamBitIdx].level0 = 1;
                    LEDtxBuffer[streamBitIdx].duration0 = 2;
                    LEDtxBuffer[streamBitIdx].level1 = 0;
                    LEDtxBuffer[streamBitIdx].duration1 = 10;
                }
                streamBitIdx++;
            }
        }
    }

    // Send the data
    rmtWrite(MyRMT, LEDtxBuffer, NR_OF_ALL_BITS);
}

void LED_color(int LedNum, uint32_t RGB, bool UpdateNow)
{
    int LedNumOffset = LedNum - LED_OFFSET;
    if (LedNumOffset < 0) LedNumOffset += NR_OF_LEDS;

    if ((LedNumOffset < 0) || (LedNumOffset >= NR_OF_LEDS) || (Dimming == 0))
        return;

    LEDdata[LedNumOffset].Red   = (((RGB >> 16) & 0xFF) * Dimming) >> 8;
    LEDdata[LedNumOffset].Green = (((RGB >>  8) & 0xFF) * Dimming) >> 8;
    LEDdata[LedNumOffset].Blue  = (((RGB)       & 0xFF) * Dimming) >> 8;

    if (UpdateNow)
    {
        LEDtransmitData();
    }
}

void LED_Dimming(byte dim)
{
    Dimming = dim;
}

void LED_clear(bool UpdateNow)
{
    /*
    for (int LedNum = 0; LedNum < NR_OF_LEDS; LedNum++)
    {
        //LED_color(LedNum, 0, false);
        LEDdata[LedNum].Red = 0;
        LEDdata[LedNum].Green = 0;
        LEDdata[LedNum].Blue = 0;
    }
    */
    memset(LEDdata, 0, sizeof(LEDdata));
    if (UpdateNow)
    {
        rmtWrite(MyRMT, LEDtxReset, 1);
        LEDtransmitData();
    }
}

// No dimming!
void LED_allSameColor(uint32_t RGB, bool UpdateNow)
{
    for (int LedNum = 0; LedNum < NR_OF_LEDS; LedNum++)
    {
        LEDdata[LedNum].Red =   (RGB >> 16) & 0xFF;
        LEDdata[LedNum].Green = (RGB >>  8) & 0xFF;
        LEDdata[LedNum].Blue =  (RGB      ) & 0xFF;
    }
    if (UpdateNow)
    {
        LEDtransmitData();
    }
}

void LED_showProgress(int percent, uint32_t dotColor, uint32_t trailColor)
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
        else color = 0; // 0x000505; // dim blue/green
        LED_color(i, color, false);
    }
    LEDtransmitData();
}

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
        LED_color(i, color, true);
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
        LED_color(i, color, true);
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
      LED_color(LedNum, 0, false);
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
    LED_color(LedNum, LedColor, true);
    LEDsequence++;
    if (LEDsequence >= 12)
      LEDsequence = 0;

    // LED_color(2, ((59 * 2) - (CurrentSecond * 2) << 16) | (CurrentSecond * 2), true);
    LEDlastUpdate = CurrentSecond;
  }
*/