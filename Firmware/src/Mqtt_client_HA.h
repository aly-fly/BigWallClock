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
extern bool MqttCommandPower;
extern bool MqttCommandPowerReceived;
extern bool MqttStatusPower;

extern uint8_t MqttCommandBrightness;
extern bool MqttCommandBrightnessReceived;
extern uint8_t MqttStatusBrightness;

#define NumEffects  4
#define EffectTxtLen 30
extern const String Effect[NumEffects];
extern int MqttCommandEffectNumber;
extern char MqttCommandEffect[EffectTxtLen];
extern bool MqttCommandEffectReceived;
extern char MqttStatusEffect[EffectTxtLen];

extern uint32_t MqttCommandColor;
extern bool MqttCommandColorReceived;

extern float MqttCommandRainbowSec;
extern bool MqttCommandRainbowSecReceived;
extern float MqttStatusRainbowSec;

/*
extern bool MqttCommandDots;
extern bool MqttCommandDotsReceived;
extern bool MqttStatusDots;
*/
extern uint8_t MqttCommandDotsBrightness;
extern bool MqttCommandDotsBrightnessReceived;
extern uint8_t MqttStatusDotsBrightness;

// read-only statuses
extern int MqttStatusRssi;

extern float MqttStatusTemperture;

extern int MqttStatusErrorWarning;

// ===========================================================

#endif // MQTT_ENABLED

#endif /* mqtt_client_H_ */
