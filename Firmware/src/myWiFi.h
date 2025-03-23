#ifndef MYWIFI_H
#define MYWIFI_H

#include "__CONFIG.h"

bool WifiInit(void);
bool WifiIsConnected(void);
void WifiPrintStatus(void);
int8_t WifiGetSignalLevel(void);

extern bool inHomeLAN;

#endif // MYWIFI_H
