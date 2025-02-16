#include <Arduino.h>
#include "__CONFIG.h"

void LEDbuiltin_init(void)
{
    pinMode(SYS_LED_PIN, OUTPUT);
}

void LEDbuiltin_ON(void)
{
    digitalWrite(SYS_LED_PIN, HIGH); // ON
}

void LEDbuiltin_OFF(void)
{
    digitalWrite(SYS_LED_PIN, LOW); // OFF
}

void LEDbuiltin_Toggle(void)
{
    digitalWrite(SYS_LED_PIN, !digitalRead(SYS_LED_PIN));
}

