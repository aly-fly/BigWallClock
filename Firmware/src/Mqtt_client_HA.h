#ifndef mqtt_client_H_
#define mqtt_client_H_

#include <Arduino.h>
#include "__CONFIG.h"

#ifdef MQTT_ENABLED
extern bool MqttConnected;

// functions
bool MqttStart(bool restart = false);
void MqttLoopFrequently();
void MqttLoopInFreeTime();

// ========== APPLICATION VARIABLES ==========

// commands from server; states to be returned; last value that was sent
extern bool MqttCommandPowerReceived;
extern bool MqttCommandBrightnessReceived;
#define NumEffects  4
extern const String EffectList[NumEffects];
extern bool MqttCommandEffectReceived;
extern bool MqttCommandColorReceived;
extern bool MqttCommandRainbowSecReceived;
//extern bool MqttCommandDotsReceived;
extern bool MqttCommandDotsBrightnessReceived;

// read-only statuses
extern int MqttStatusRssi;
extern float MqttStatusTemperture;
extern int MqttStatusErrorCounter;
extern String MqttStatusErrorText;

// ===========================================================

#endif // MQTT_ENABLED

#endif /* mqtt_client_H_ */
