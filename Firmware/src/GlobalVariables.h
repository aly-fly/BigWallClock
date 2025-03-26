
#ifndef __GLOBALVARIABLES_H_
#define __GLOBALVARIABLES_H_

#include <stdint.h>

extern bool ClockEnabled;
extern bool TestMode;
extern bool ClockError;
extern bool ClockWarning;
extern int ErrorCounter;
extern char * BootTime;

extern bool     ConfigBgPower;
extern uint8_t  ConfigBgBrightness;
extern String   ConfigBgEffectStr;
extern int      ConfigBgEffectNumber;
extern uint32_t ConfigBgColor;
extern float    ConfigEffectDuration;
extern uint8_t  ConfigDotsBrightness;


#endif //__GLOBALVARIABLES_H_
