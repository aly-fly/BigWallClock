
#include <Arduino.h>
#include "Clock.h"

char int_logbuffer[150];
char timebuf[15];

void int_log (void)
{
    if (CurrentYear != 0) // time is initialized
    {
        GetCurrentTime();
        sprintf(timebuf, "[%02d:%02d:%02d] ", CurrentHour, CurrentMinute, CurrentSecond);
        Serial.print(timebuf);
    }
    Serial.println(int_logbuffer);
}

