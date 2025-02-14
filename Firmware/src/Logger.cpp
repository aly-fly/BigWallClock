
#include <Arduino.h>
#include "Clock.h"
#include "fileSystem.h"
#include "GlobalVariables.h"
#include "TcpSocket.h"

char int_logbuffer[150];
char timebuf[20];
String CollectForSaving;
unsigned long LastTimeSaved = 0;

void int_log(void)
{
    if (CurrentYear != 0) // time is initialized
    {
        GetCurrentTime();
        sprintf(timebuf, "[%d.%d. %02d:%02d:%02d] ", CurrentDay, CurrentMonth, CurrentHour, CurrentMinute, CurrentSecond);
        Serial.print(timebuf);
        SendToSocket(timebuf);
        if (!TestMode)
            CollectForSaving.concat(timebuf);
    }
    Serial.println(int_logbuffer);
    if (!TestMode)
    {
        CollectForSaving.concat(int_logbuffer);
        CollectForSaving.concat('\n');
    }
    SendToSocket(int_logbuffer);
    SendToSocket("\n");
    int_logbuffer[0] = '\0';

    if ((CollectForSaving.length() > 1500) && FSready)
    {
        if (saveToFile(&CollectForSaving))
        {
            CollectForSaving.clear();
            LastTimeSaved = millis();
        }
    }
    if (CollectForSaving.length() > 5000)
        CollectForSaving.clear(); // mem leak protection
}

void int_logNS(void)
{
    Serial.print(int_logbuffer);
    SendToSocket(int_logbuffer);
    int_logbuffer[0] = '\0';
}

void LogNSc(char cc)
{
    Serial.print(cc);
    SendToSocket(cc);
}

void loggerPurgeToFile(bool immediatelly = false)
{
    if ((((millis() - LastTimeSaved) > 90000) && FSready && (CollectForSaving.length() > 1500)) || immediatelly)
    {
        if (saveToFile(&CollectForSaving))
        {
            CollectForSaving.clear();
            LastTimeSaved = millis();
        }
    }
}