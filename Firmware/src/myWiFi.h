#ifndef MYWIFI_H
#define MYWIFI_H

#include "__CONFIG.h"
#include "____CONFIG_SECRETS.h"


//enum WifiState_t {disconnected, connected};
bool WifiInit(void);
void WifiReconnectIfNeeded(void);

//extern WifiState_t WifiState;
extern bool inHomeLAN;

#endif // MYWIFI_H
