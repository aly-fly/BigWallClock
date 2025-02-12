
#include <Arduino.h>
#include "Clock.h"
#include "fileSystem.h"

char int_logbuffer[150];
char timebuf[15];
String CollectForSaving;
unsigned long LastTimeSaved = 0;

void int_log(void)
{
    if (CurrentYear != 0) // time is initialized
    {
        GetCurrentTime();
        sprintf(timebuf, "[%02d:%02d:%02d] ", CurrentHour, CurrentMinute, CurrentSecond);
        Serial.print(timebuf);
        CollectForSaving.concat(timebuf);
    }
    Serial.println(int_logbuffer);
    CollectForSaving.concat(int_logbuffer);
    CollectForSaving.concat('\n');

    if ((CollectForSaving.length() > 1000) && FSready)
    {
        if (saveToFile(&CollectForSaving))
        {
            CollectForSaving.clear();
            LastTimeSaved = millis();
        }
    }
    if (CollectForSaving.length() > 2000)
        CollectForSaving.clear(); // mem leak protection
}

void loggerPurgeToFile(void)
{
    if (((millis() - LastTimeSaved) > 30000) && FSready && (CollectForSaving.length() > 50))
    {
        if (saveToFile(&CollectForSaving))
        {
            CollectForSaving.clear();
            LastTimeSaved = millis();
        }
    }
}