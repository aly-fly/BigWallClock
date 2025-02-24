
#ifndef __GLOBALVARIABLES_H_
#define __GLOBALVARIABLES_H_

#include <stdint.h>

//enum ClockStatus_t {stOK, stWarning, stError};

extern bool ClockEnabled;
extern bool TestMode;
extern bool ClockError;
extern bool ClockWarning;
extern int ErrorCounter;
extern char * BootTime;

#endif //__GLOBALVARIABLES_H_
