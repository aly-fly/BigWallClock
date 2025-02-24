#include <Arduino.h>
#include <stdint.h>
#include "GlobalVariables.h"

bool ClockEnabled = true;
bool TestMode = false;
bool ClockError;
bool ClockWarning;
int ErrorCounter = 0;
char * BootTime;
