
// C:\Users\aljaz\.platformio\packages\framework-arduinoespressif32\tools\sdk\esp32\include\ws2812_led
//  https://github.com/martinberlin/esp-rainmaker-examples/blob/master/components/ws2812_led/ws2812_led.c

#include "__CONFIG.h"
#include "esp32-hal-rmt.h"

//======================================================================================================================

#define NR_OF_LEDS 5
#define NR_OF_ALL_BITS 24 * NR_OF_LEDS

struct LEDdata_t
{
    uint8_t Green;
    uint8_t Red;
    uint8_t Blue;
};

LEDdata_t LEDdata[NR_OF_LEDS];
byte Dimming = 255;

rmt_data_t LEDtxBuffer[NR_OF_ALL_BITS];
rmt_data_t LEDtxReset[1];
rmt_obj_t *MyRMT = NULL;

void LED_init(void)
{
    MyRMT = rmtInit(WS2812_LED_PIN, RMT_TX_MODE, RMT_MEM_64);

    if (MyRMT == NULL)
    {
        Serial.println("RMT init failed\n");
    }
    float tickTime = rmtSetTick(MyRMT, 100); // 1 tick = 0.1 us (divisor = 8)
    log_i("RMT Tick time = %f\n", tickTime);

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
                if (data & (1 << (7 - bit)))  // bit 1 = 0.8 us HI + 0.4 us LO
                {
                    LEDtxBuffer[streamBitIdx].level0 = 1;
                    LEDtxBuffer[streamBitIdx].duration0 = 8;
                    LEDtxBuffer[streamBitIdx].level1 = 0;
                    LEDtxBuffer[streamBitIdx].duration1 = 4;
                }
                else                          // bit 0 = 0.4 us HI + 0.8 us LO
                {
                    LEDtxBuffer[streamBitIdx].level0 = 1;
                    LEDtxBuffer[streamBitIdx].duration0 = 4;
                    LEDtxBuffer[streamBitIdx].level1 = 0;
                    LEDtxBuffer[streamBitIdx].duration1 = 8;
                }
                streamBitIdx++;
            }
        }
    }

    // Send the data
    rmtWrite(MyRMT, LEDtxBuffer, NR_OF_ALL_BITS);
}

void LED_color(int LedNum, uint32_t RGB, bool UpdateNow = false)
{
    if (LedNum >= NR_OF_LEDS)
        return;

    LEDdata[LedNum].Red   = (((RGB >> 16) & 0xFF) * Dimming) >> 8;
    LEDdata[LedNum].Green = (((RGB >>  8) & 0xFF) * Dimming) >> 8;
    LEDdata[LedNum].Blue  = (((RGB      ) & 0xFF) * Dimming) >> 8;

    if (UpdateNow)
    {
        LEDtransmitData();
    }
}

void LED_off(void)
{
    // Send the data
    rmtWrite(MyRMT, LEDtxReset, 1);
    memset(LEDdata, 0, sizeof(LEDdata));
}

void LED_Dimming (byte dim)
{
    Dimming = dim;
}

