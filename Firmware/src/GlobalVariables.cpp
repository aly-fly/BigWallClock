#include <Arduino.h>
#include <stdint.h>
#include "GlobalVariables.h"

bool ClockEnabled = true;
bool TestMode = false;
bool ClockError;
bool ClockWarning;
int ErrorCounter = 0;
char * BootTime;


bool     ConfigBgPower = true;
uint8_t  ConfigBgBrightness = 127;
String   ConfigBgEffectStr = "";
int      ConfigBgEffectNumber = 0;
uint32_t ConfigBgColor = 0x002233; // very dim blue-green
float    ConfigRainbowSec = 30;
uint8_t  ConfigDotsBrightness = 200;

