
#include "__CONFIG.h"
#include "Logger.h"
#include "Version.h"
#include "GlobalVariables.h"
#include "utils.h"
#include "Mqtt_client_HA.h"

#ifdef MQTT_ENABLED
#include "WiFi.h" // for ESP32
#include <PubSubClient.h>
#include <ArduinoJson.h>

#ifdef MQTT_USE_TLS
#include <WiFiClientSecure.h> // for secure WiFi client
WiFiClientSecure espClient;
#else
WiFiClient espClient;
#endif
PubSubClient MQTTclient(espClient);

#define concat2(first, second) first second
#define concat3(first, second, third) first second third
#define concat4(first, second, third, fourth) first second third fourth
#define concat5(first, second, third, fourth, fifth) first second third fourth fifth

#define MQTT_STATE_ON "ON"
#define MQTT_STATE_OFF "OFF"

#define MQTT_BRIGHTNESS_MIN 0
#define MQTT_BRIGHTNESS_MAX 255

#define MQTT_HOME_ASSISTANT_DISCOVERY_SW_VERSION VERSION // Firmware version shown in HA

#define TopicHAstatus "homeassistant/status"

int splitCommand(char *topic, char *tokens[], int tokensNumber);
void callback(char *topic, byte *payload, unsigned int length);
void MqttReportDiscovery(void);

unsigned long lastTimeSent = ULONG_MAX - (MQTT_REPORT_STATUS_EVERY_SEC * 1001);      // execute on the first call
unsigned long LastTimeTriedToConnect = ULONG_MAX - (MQTT_RECONNECT_WAIT_SEC * 1001); // make sure it is executed on the first call
bool discoveryReported = false;
bool availabilityReported = false;

// ========== APPLICATION VARIABLES ==========

// commands from server; states to be returned; last value that was sent
#define TopicLight "back_light"
bool MqttCommandPowerReceived = false;
bool MqttStatusPowerLastSent = false;

bool MqttCommandBrightnessReceived = false;
uint8_t MqttStatusBrightnessLastSent = 0;

bool MqttCommandEffectReceived = false;
String MqttStatusEffectLastSent = "";
const String EffectList[NumEffects] =
    {"Static color", "Uniform rainbow", "Rainbow", "Partial rainbow", "Twinkle fade", "TEST"};

bool MqttCommandColorReceived = false;

#define TopicEffectDuration "effect_duration"
bool MqttCommandEffectDurationReceived = false;
float MqttStatusEffectDurationLastSent = 0;

#define TopicDotsBrightness "dots_brightness"
bool MqttCommandDotsBrightnessReceived = false;
uint8_t MqttStatusDotsBrightnessLastSent = 0;

// read-only statuses
#define TopicRssi "rssi"
int MqttStatusRssi = 0;
int MqttStatusRssiLastSent = 999;

#define TopicTemperature "temperature"
float MqttStatusTemperture = 0;
float MqttStatusTempertureLastSent = 999;

#define TopicErrorWarning "error_counter"
int MqttStatusErrorCounter = 0;
int MqttStatusErrorCounterLastSent = 999;

#define TopicErrorText "error_text"
String MqttStatusErrorText = "-";
String MqttStatusErrorTextLastSent = "xyz";

// ===========================================================

bool MqttPublish(const char *Topic, const char *Message, const bool Retain)
{
  if (!MQTTclient.connected())
    return false;

  bool ok = MQTTclient.publish(Topic, Message, Retain);

#ifdef DEBUG_OUTPUT
  if (ok)
  {
    Serial.print("TX MQTT: ");
    Serial.print(Topic);
    Serial.print(" - ");
    Serial.println(Message);
  }
  else
  {
    Serial.print("TX MQTT ERROR: ");
    Serial.println(Topic);
  }
#endif
  return ok;
}

bool MqttPublish(const char *Topic, JsonDocument *Json, const bool Retain)
{
  size_t buffSize = measureJson(*Json) + 3; // Discovery Light = about 720 bytes
#ifdef DEBUG_OUTPUT
  // LogNS("JSON size = %d\r\n", buffSize);
#endif
  char *buffer = (char *)malloc(buffSize);
  if (buffer == NULL)
  {
    Log("Error allocating %d bytes to serialize JSON.", buffSize);
    return false;
  }
  size_t dataSize = serializeJson(*Json, buffer, buffSize);
  if ((dataSize < buffSize) && (dataSize > 0))
  {
    bool ok = MqttPublish(Topic, buffer, Retain);
    Json->clear();
    free(buffer);
    return ok;
  }
  else
  {
    Log("Error serializing JSON data.");
    Json->clear();
    free(buffer);
    return false;
  }
}

void MqttPublishValues(bool forceUpdateEverything)
{
  if (!MQTTclient.connected())
    return;

  // send availability message
  if (forceUpdateEverything || !availabilityReported)
  {
    if (!MqttPublish(concat3(MQTT_CLIENT, "/", MQTT_ALIVE_TOPIC), MQTT_ALIVE_MSG_ONLINE, MQTT_RETAIN_ALIVE_MESSAGES))
      return;
    availabilityReported = true;
  }

  if (forceUpdateEverything ||
      ConfigBgPower != MqttStatusPowerLastSent ||
      ConfigBgBrightness != MqttStatusBrightnessLastSent ||
      ConfigBgEffectStr != MqttStatusEffectLastSent)
  {
    JsonDocument state;
    state["state"] = ConfigBgPower == 0 ? MQTT_STATE_OFF : MQTT_STATE_ON;
    state["brightness"] = ConfigBgBrightness;
    state["effect"] = ConfigBgEffectStr;

    if (!MqttPublish(concat3(MQTT_CLIENT, "/", TopicLight), &state, MQTT_RETAIN_STATE_MESSAGES))
      return;
    MqttStatusPowerLastSent = ConfigBgPower;
    MqttStatusBrightnessLastSent = ConfigBgBrightness;
    MqttStatusEffectLastSent = ConfigBgEffectStr;
  }

  if (forceUpdateEverything || (abs(ConfigEffectDuration - MqttStatusEffectDurationLastSent) > 0.2))
  {
    JsonDocument state;
    state["state"] = ConfigEffectDuration;

    if (!MqttPublish(concat3(MQTT_CLIENT, "/", TopicEffectDuration), &state, MQTT_RETAIN_STATE_MESSAGES))
      return;
    MqttStatusEffectDurationLastSent = ConfigEffectDuration;
  }

  if (forceUpdateEverything || ConfigDotsBrightness != MqttStatusDotsBrightnessLastSent)
  {
    JsonDocument state;
    state["state"] = map(ConfigDotsBrightness, 0, 255, 0, 100); // convert 0..255 to 0..100 %

    if (!MqttPublish(concat3(MQTT_CLIENT, "/", TopicDotsBrightness), &state, MQTT_RETAIN_STATE_MESSAGES))
      return;
    MqttStatusDotsBrightnessLastSent = ConfigDotsBrightness;
  }

  if (forceUpdateEverything || (abs(MqttStatusRssi - MqttStatusRssiLastSent) > 6))
  {
    JsonDocument state;
    state["state"] = MqttStatusRssi;

    if (!MqttPublish(concat3(MQTT_CLIENT, "/", TopicRssi), &state, MQTT_RETAIN_STATE_MESSAGES))
      return;
    MqttStatusRssiLastSent = MqttStatusRssi;
  }

  if (forceUpdateEverything || (abs(MqttStatusTemperture - MqttStatusTempertureLastSent) > 1))
  {
    JsonDocument state;
    state["state"] = MqttStatusTemperture;

    if (!MqttPublish(concat3(MQTT_CLIENT, "/", TopicTemperature), &state, MQTT_RETAIN_STATE_MESSAGES))
      return;
    MqttStatusTempertureLastSent = MqttStatusTemperture;
  }

  if (forceUpdateEverything || MqttStatusErrorCounter != MqttStatusErrorCounterLastSent)
  {
    JsonDocument state;
    state["state"] = (float)MqttStatusErrorCounter;

    if (!MqttPublish(concat3(MQTT_CLIENT, "/", TopicErrorWarning), &state, MQTT_RETAIN_STATE_MESSAGES))
      return;
    MqttStatusErrorCounterLastSent = MqttStatusErrorCounter;
  }

  if (forceUpdateEverything || MqttStatusErrorText != MqttStatusErrorTextLastSent)
  {
    JsonDocument state;
    state["state"] = MqttStatusErrorText;

    if (!MqttPublish(concat3(MQTT_CLIENT, "/", TopicErrorText), &state, MQTT_RETAIN_STATE_MESSAGES))
      return;
    MqttStatusErrorTextLastSent = MqttStatusErrorText;
  }
}

// ====================================== DISCOVERY ===================================================

// https://www.home-assistant.io/integrations/mqtt/#configuration-via-mqtt-discovery
// To avoid high IO loads on the MQTT broker, adding some random delay in sending the discovery payload is recommended.

bool MqttPublishDiscoveryMessages()
{
#ifdef MQTT_HOME_ASSISTANT_DISCOVERY
  JsonDocument discovery;

  Log("Sending MQTT HA Discovery messages...");

  // Back Light - LIGHT
  // https://www.home-assistant.io/integrations/light.mqtt/
  discovery.clear();
  discovery["device"]["identifiers"][0] = MQTT_CLIENT;
  discovery["device"]["manufacturer"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MANUFACTURER;
  discovery["device"]["model"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["name"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["sw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_SW_VERSION;
  discovery["device"]["hw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_HW_VERSION;
  discovery["device"]["connections"][0][0] = "mac";
  discovery["device"]["connections"][0][1] = WiFi.macAddress();
  discovery["unique_id"] = concat3(MQTT_CLIENT, "_", TopicLight);
  discovery["default_entity_id"] = concat4("light.", MQTT_CLIENT, "_", TopicLight);
  discovery["availability_topic"] = concat3(MQTT_CLIENT, "/", MQTT_ALIVE_TOPIC);
  discovery["name"] = "Back light";
  discovery["icon"] = "mdi:television-ambient-light"; //"mdi:sun-wireless";
  discovery["schema"] = "json";
  discovery["platform"] = "light";
  discovery["state_topic"] = concat3(MQTT_CLIENT, "/", TopicLight);
  discovery["json_attributes_topic"] = concat3(MQTT_CLIENT, "/", TopicLight);
  discovery["command_topic"] = concat4(MQTT_CLIENT, "/", TopicLight, "/set");
  discovery["brightness"] = true;
  discovery["brightness_scale"] = MQTT_BRIGHTNESS_MAX;
  discovery["supported_color_modes"][0] = "rgb";
  discovery["effect"] = true;
  for (size_t i = 0; i < NumEffects; i++)
  {
    discovery["effect_list"][i] = EffectList[i];
  }

  delay(250);
  if (!MqttPublish(concat5("homeassistant/light/", MQTT_CLIENT, "_", TopicLight, "/light/config"), &discovery, MQTT_RETAIN_DISCOVERY_MESSAGES))
    return false;

  // Rainbow duration - NUMBER
  discovery.clear();
  discovery["device"]["identifiers"][0] = MQTT_CLIENT;
  discovery["device"]["manufacturer"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MANUFACTURER;
  discovery["device"]["model"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["name"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["sw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_SW_VERSION;
  discovery["device"]["hw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_HW_VERSION;
  discovery["device"]["connections"][0][0] = "mac";
  discovery["device"]["connections"][0][1] = WiFi.macAddress();
  discovery["unique_id"] = concat3(MQTT_CLIENT, "_", TopicEffectDuration);
  discovery["default_entity_id"] = concat4("number.", MQTT_CLIENT, "_", TopicEffectDuration);
  discovery["availability_topic"] = concat3(MQTT_CLIENT, "/", MQTT_ALIVE_TOPIC);
  discovery["name"] = "Effect duration";
  discovery["icon"] = "mdi:play-speed";
  discovery["schema"] = "json";
  discovery["platform"] = "number";
  discovery["unit_of_measurement"] = "sec";
  discovery["state_topic"] = concat3(MQTT_CLIENT, "/", TopicEffectDuration);
  discovery["json_attributes_topic"] = concat3(MQTT_CLIENT, "/", TopicEffectDuration);
  discovery["command_topic"] = concat4(MQTT_CLIENT, "/", TopicEffectDuration, "/set");
  discovery["command_template"] = "{\"state\":{{value}}}";
  discovery["step"] = 1;
  discovery["min"] = 1;
  discovery["max"] = 60;
  discovery["mode"] = "slider";
  discovery["value_template"] = "{{ value_json.state }}";

  delay(250);
  if (!MqttPublish(concat5("homeassistant/number/", MQTT_CLIENT, "_", TopicEffectDuration, "/number/config"), &discovery, MQTT_RETAIN_DISCOVERY_MESSAGES))
    return false;

  // Dots brightness - NUMBER
  // https://www.home-assistant.io/integrations/number.mqtt/
  discovery.clear();
  discovery["device"]["identifiers"][0] = MQTT_CLIENT;
  discovery["device"]["manufacturer"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MANUFACTURER;
  discovery["device"]["model"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["name"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["sw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_SW_VERSION;
  discovery["device"]["hw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_HW_VERSION;
  discovery["device"]["connections"][0][0] = "mac";
  discovery["device"]["connections"][0][1] = WiFi.macAddress();
  discovery["unique_id"] = concat3(MQTT_CLIENT, "_", TopicDotsBrightness);
  discovery["default_entity_id"] = concat4("number.", MQTT_CLIENT, "_", TopicDotsBrightness);
  discovery["availability_topic"] = concat3(MQTT_CLIENT, "/", MQTT_ALIVE_TOPIC);
  discovery["name"] = "Dots brightness";
  discovery["icon"] = "mdi:dots-circle";
  discovery["schema"] = "json";
  discovery["platform"] = "number";
  discovery["unit_of_measurement"] = "%";
  discovery["state_topic"] = concat3(MQTT_CLIENT, "/", TopicDotsBrightness);
  discovery["json_attributes_topic"] = concat3(MQTT_CLIENT, "/", TopicDotsBrightness);
  discovery["command_topic"] = concat4(MQTT_CLIENT, "/", TopicDotsBrightness, "/set");
  discovery["command_template"] = "{\"state\":{{value}}}";
  discovery["step"] = 1;
  discovery["min"] = 0;
  discovery["max"] = 100;
  discovery["mode"] = "slider";
  discovery["value_template"] = "{{ value_json.state }}";

  delay(250);
  if (!MqttPublish(concat5("homeassistant/number/", MQTT_CLIENT, "_", TopicDotsBrightness, "/number/config"), &discovery, MQTT_RETAIN_DISCOVERY_MESSAGES))
    return false;

  // rssi - SENSOR
  // https://www.home-assistant.io/integrations/sensor.mqtt/
  discovery.clear();
  discovery["device"]["identifiers"][0] = MQTT_CLIENT;
  discovery["device"]["manufacturer"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MANUFACTURER;
  discovery["device"]["model"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["name"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["sw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_SW_VERSION;
  discovery["device"]["hw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_HW_VERSION;
  discovery["device"]["connections"][0][0] = "mac";
  discovery["device"]["connections"][0][1] = WiFi.macAddress();
  discovery["unique_id"] = concat3(MQTT_CLIENT, "_", TopicRssi);
  discovery["default_entity_id"] = concat4("sensor.", MQTT_CLIENT, "_", TopicRssi);
  discovery["availability_topic"] = concat3(MQTT_CLIENT, "/", MQTT_ALIVE_TOPIC);
  discovery["name"] = "RSSI";
  discovery["icon"] = "mdi:wifi";
  discovery["schema"] = "json";
  discovery["platform"] = "sensor";
  discovery["device_class"] = "signal_strength"; // https://www.home-assistant.io/integrations/sensor#device-class
  discovery["state_topic"] = concat3(MQTT_CLIENT, "/", TopicRssi);
  discovery["json_attributes_topic"] = concat3(MQTT_CLIENT, "/", TopicRssi);
  discovery["value_template"] = "{{ value_json.state }}";
  discovery["unit_of_measurement"] = "dBm";

  delay(250);
  if (!MqttPublish(concat5("homeassistant/sensor/", MQTT_CLIENT, "_", TopicRssi, "/sensor/config"), &discovery, MQTT_RETAIN_DISCOVERY_MESSAGES))
    return false;

  // temperature - SENSOR
  discovery.clear();
  discovery["device"]["identifiers"][0] = MQTT_CLIENT;
  discovery["device"]["manufacturer"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MANUFACTURER;
  discovery["device"]["model"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["name"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["sw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_SW_VERSION;
  discovery["device"]["hw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_HW_VERSION;
  discovery["device"]["connections"][0][0] = "mac";
  discovery["device"]["connections"][0][1] = WiFi.macAddress();
  discovery["unique_id"] = concat3(MQTT_CLIENT, "_", TopicTemperature);
  discovery["default_entity_id"] = concat4("sensor.", MQTT_CLIENT, "_", TopicTemperature);
  discovery["availability_topic"] = concat3(MQTT_CLIENT, "/", MQTT_ALIVE_TOPIC);
  discovery["name"] = "Motor temperature";
  discovery["icon"] = "mdi:sun-thermometer-outline";
  discovery["schema"] = "json";
  discovery["platform"] = "sensor";
  discovery["device_class"] = "temperature"; // https://www.home-assistant.io/integrations/sensor#device-class
  discovery["state_topic"] = concat3(MQTT_CLIENT, "/", TopicTemperature);
  discovery["json_attributes_topic"] = concat3(MQTT_CLIENT, "/", TopicTemperature);
  discovery["value_template"] = "{{ value_json.state }}";
  discovery["unit_of_measurement"] = "°C";

  delay(250);
  if (!MqttPublish(concat5("homeassistant/sensor/", MQTT_CLIENT, "_", TopicTemperature, "/sensor/config"), &discovery, MQTT_RETAIN_DISCOVERY_MESSAGES))
    return false;

  // error counter - SENSOR
  discovery.clear();
  discovery["device"]["identifiers"][0] = MQTT_CLIENT;
  discovery["device"]["manufacturer"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MANUFACTURER;
  discovery["device"]["model"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["name"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["sw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_SW_VERSION;
  discovery["device"]["hw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_HW_VERSION;
  discovery["device"]["connections"][0][0] = "mac";
  discovery["device"]["connections"][0][1] = WiFi.macAddress();
  discovery["unique_id"] = concat3(MQTT_CLIENT, "_", TopicErrorWarning);
  discovery["default_entity_id"] = concat4("sensor.", MQTT_CLIENT, "_", TopicErrorWarning);
  discovery["availability_topic"] = concat3(MQTT_CLIENT, "/", MQTT_ALIVE_TOPIC);
  discovery["name"] = "Error counter";
  discovery["icon"] = "mdi:counter";
  discovery["schema"] = "json";
  discovery["platform"] = "sensor";
  discovery["state_topic"] = concat3(MQTT_CLIENT, "/", TopicErrorWarning);
  discovery["json_attributes_topic"] = concat3(MQTT_CLIENT, "/", TopicErrorWarning);
  discovery["value_template"] = "{{ value_json.state }}";
  discovery["unit_of_measurement"] = "cnt";

  delay(250);
  if (!MqttPublish(concat5("homeassistant/sensor/", MQTT_CLIENT, "_", TopicErrorWarning, "/sensor/config"), &discovery, MQTT_RETAIN_DISCOVERY_MESSAGES))
    return false;

  // error text - SENSOR
  // https://www.home-assistant.io/integrations/sensor.mqtt/
  discovery.clear();
  discovery["device"]["identifiers"][0] = MQTT_CLIENT;
  discovery["device"]["manufacturer"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MANUFACTURER;
  discovery["device"]["model"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["name"] = MQTT_HOME_ASSISTANT_DISCOVERY_DEVICE_MODEL;
  discovery["device"]["sw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_SW_VERSION;
  discovery["device"]["hw_version"] = MQTT_HOME_ASSISTANT_DISCOVERY_HW_VERSION;
  discovery["device"]["connections"][0][0] = "mac";
  discovery["device"]["connections"][0][1] = WiFi.macAddress();
  discovery["unique_id"] = concat3(MQTT_CLIENT, "_", TopicErrorText);
  discovery["default_entity_id"] = concat4("sensor.", MQTT_CLIENT, "_", TopicErrorText);
  discovery["availability_topic"] = concat3(MQTT_CLIENT, "/", MQTT_ALIVE_TOPIC);
  discovery["name"] = "Error descr.";
  discovery["icon"] = "mdi:exclamation-thick";
  discovery["schema"] = "json";
  discovery["platform"] = "sensor";
  discovery["state_topic"] = concat3(MQTT_CLIENT, "/", TopicErrorText);
  discovery["json_attributes_topic"] = concat3(MQTT_CLIENT, "/", TopicErrorText);
  discovery["value_template"] = "{{ value_json.state }}";

  delay(250);
  if (!MqttPublish(concat5("homeassistant/sensor/", MQTT_CLIENT, "_", TopicErrorText, "/sensor/config"), &discovery, MQTT_RETAIN_DISCOVERY_MESSAGES))
    return false;

  Log("Sending Discovery done.");
#endif
  return true;
}

#ifdef MQTT_USE_TLS
bool loadCARootCert()
{
  const char *filename = "/mqtt-ca-root.pem";
  Serial.println("Loading CA Root Certificate");

  // Check if the PEM file exists
  if (!SPIFFS.exists(filename))
  {
    Serial.println("ERROR: File not found mqtt-ca-root.pem");
    return false;
  }

  // Open the PEM file in read mode
  File file = SPIFFS.open(filename, "r");
  if (!file)
  {
    Serial.println("ERROR: Failed to open mqtt-ca-root.pem");
    return false;
  }

  // Get the size of the file
  size_t size = file.size();
  if (size == 0)
  {
    Serial.println("ERROR: Empty mqtt-ca-root.pem");
    file.close();
    return false;
  }

  // Use the loadCA() method to load the certificate directly from the file stream
  bool result = espClient.loadCACert(file, size);

  file.close();

  if (result)
  {
    Serial.println("CA Root Certificate loaded successfully");
  }
  else
  {
    Serial.println("ERROR: Failed to load CA Root Certificate");
  }

  return result;
}
#endif // tls

void printMQTTconnectionStatus(void)
{
  switch (MQTTclient.state())
  {
  case MQTT_CONNECTION_TIMEOUT:
    Log("Error: MQTT_CONNECTION_TIMEOUT");
    break;

  case MQTT_CONNECTION_LOST:
    Log("Error: MQTT_CONNECTION_LOST");
    break;

  case MQTT_CONNECT_FAILED:
    Log("Error: MQTT_CONNECT_FAILED");
    break;

  case MQTT_DISCONNECTED:
    Log("Error: MQTT_DISCONNECTED");
    break;

  case MQTT_CONNECT_BAD_PROTOCOL:
    Log("Error: MQTT_CONNECT_BAD_PROTOCOL");
    break;

  case MQTT_CONNECT_BAD_CLIENT_ID:
    Log("Error: MQTT_CONNECT_BAD_CLIENT_ID");
    break;

  case MQTT_CONNECT_UNAVAILABLE:
    Log("Error: MQTT_CONNECT_UNAVAILABLE");
    break;

  case MQTT_CONNECT_BAD_CREDENTIALS:
    Log("Error: MQTT_CONNECT_BAD_CREDENTIALS");
    break;

  case MQTT_CONNECT_UNAUTHORIZED:
    Log("Error: MQTT_CONNECT_UNAUTHORIZED");
    break;

  case MQTT_CONNECTED:
    Log("MQTT_CONNECTED");
    break;

  default:
    Log("Unknown MQTT error: %d", MQTTclient.state());
    break;
  }
}

bool MqttStart(bool restart)
{
#ifdef MQTT_ENABLED
  if (HasTimeElapsed(&LastTimeTriedToConnect, MQTT_RECONNECT_WAIT_SEC * 1000))
  {
    if (restart)
    {
      printMQTTconnectionStatus();
    }
    else
    {
      MQTTclient.setSocketTimeout(5); // default 15 seconds, reduce for LAN
      MQTTclient.setServer(MQTT_BROKER, MQTT_PORT);
      MQTTclient.setCallback(callback);
      MQTTclient.setBufferSize(3000);
#ifdef MQTT_USE_TLS
      bool result = loadCARootCert();
      if (!result)
      {
        return false; // load certificate failed -> do not continue
      }
#endif
    }
    Serial.println("Connecting to MQTT...");

    if (MQTTclient.connect(MQTT_CLIENT,
                           MQTT_USERNAME,
                           MQTT_PASSWORD,
                           concat3(MQTT_CLIENT, "/", MQTT_ALIVE_TOPIC), // LWT topic
                           0,                                           // LWT QoS
                           MQTT_RETAIN_ALIVE_MESSAGES,                  // LWT retain
                           MQTT_ALIVE_MSG_OFFLINE))                     // LWT message to be sent by the Broker when device goes offline
    {
      Serial.println("MQTT connected");
    }
    else
    {
      printMQTTconnectionStatus();
      return false; // do not continue if not connected
    } // connect failed

    MQTTclient.subscribe(concat4(MQTT_CLIENT, "/", TopicLight, "/set"));

    MQTTclient.subscribe(concat4(MQTT_CLIENT, "/", TopicEffectDuration, "/set"));

    MQTTclient.subscribe(concat4(MQTT_CLIENT, "/", TopicDotsBrightness, "/set"));

    // Home Assistant sends "online" and "offline" to "homeassistant/status" when being shut down or restarted.
    MQTTclient.subscribe(TopicHAstatus);

    MqttReportDiscovery();
  }
#endif
  return true;
}

void MqttStop(void)
{
#ifdef MQTT_ENABLED
  MqttPublish(concat3(MQTT_CLIENT, "/", MQTT_ALIVE_TOPIC), MQTT_ALIVE_MSG_OFFLINE, MQTT_RETAIN_ALIVE_MESSAGES);
  delay(100);
  MQTTclient.disconnect();
#endif
}

int splitCommand(char *topic, char *tokens[], int tokensNumber)
{
  int mqttClientLength = strlen(MQTT_CLIENT);
  int topicLength = strlen(topic);
  int finalLength = topicLength - mqttClientLength + 2;
  char *command = (char *)malloc(finalLength);

  strncpy(command, topic + (mqttClientLength + 1), finalLength - 2);

  const char s[2] = "/";
  int pos = 0;
  tokens[0] = strtok(command, s);
  while (pos < tokensNumber - 1 && tokens[pos] != NULL)
  {
    pos++;
    tokens[pos] = strtok(NULL, s);
  }

  free(command);

  return pos;
}

void checkMqtt()
{
  if (!MQTTclient.connected())
  {
    MqttStart(true);
  }
}

void callback(char *topic, byte *payload, unsigned int length)
{ // A new message has been received
#ifdef DEBUG_OUTPUT
  Serial.print("Received MQTT topic: ");
  Serial.print(topic); // long output
#endif
  int commandNumber = 10;
  char *command[commandNumber];
  commandNumber = splitCommand(topic, command, commandNumber);

  char message[length + 1];
  strncpy(message, (char *)payload, length);
  message[length] = '\0';

  if (commandNumber < 2)
  {
    Serial.println("Detected number of commands in MQTT message is lower then 2! -> Ignoring message because it is not valid!");
    return;
  }
#ifdef DEBUG_OUTPUT
  Serial.println();
  Serial.print("RX MQTT: ");
  Serial.print(topic);
  Serial.print(" ");
  Serial.println(message);
#endif
  // resend all discovery messages if HA is restarted
  if (strcmp(topic, TopicHAstatus) == 0 && strcmp(message, "online") == 0)
  {
    discoveryReported = false;
    availabilityReported = false;
    Serial.println("HA was restarted. Resending discovery messages.");
  }

  if (strcmp(command[0], TopicLight) == 0 && strcmp(command[1], "set") == 0)
  {
    JsonDocument doc;
    deserializeJson(doc, payload, length);

    if (doc["state"].is<const char *>())
    {
      ConfigBgPower = strcmp(doc["state"], MQTT_STATE_ON) == 0;
      MqttCommandPowerReceived = true;
    }
    if (doc["brightness"].is<int>())
    {
      ConfigBgBrightness = doc["brightness"];
      MqttCommandBrightnessReceived = true;
    }
    if (doc["effect"].is<const char *>())
    {
      ConfigBgEffectStr = doc["effect"].as<String>();
      MqttCommandEffectReceived = true;

      // find the number of the effect
      for (int8_t i = 0; i < NumEffects; i++)
      {
        if (ConfigBgEffectStr == EffectList[i])
        {
          ConfigBgEffectNumber = i;
          break;
        }
      }
    }

    // RX MQTT: test02/back/set {"state":"ON","color":{"r":255,"g":114,"b":152}}
    if (doc["color"]["r"].is<int>())
    {
      byte r = doc["color"]["r"];
      byte g = doc["color"]["g"];
      byte b = doc["color"]["b"];
      ConfigBgColor = (r << 16) | (g << 8) | (b);
      Serial.printf("RGB = %d, %d, %d\r\n", r, g, b);
      MqttCommandColorReceived = true;
      // request for fixed color -> disable effects
      ConfigBgEffectNumber = 0;
      ConfigBgEffectStr = EffectList[ConfigBgEffectNumber];
    }
    doc.clear();
  }

  if (strcmp(command[0], TopicEffectDuration) == 0 && strcmp(command[1], "set") == 0)
  {
    JsonDocument doc;
    deserializeJson(doc, payload, length);

    if (doc["state"].is<float>())
    {
      ConfigEffectDuration = doc["state"];
      MqttCommandEffectDurationReceived = true;
    }
    doc.clear();
  }

  if (strcmp(command[0], TopicDotsBrightness) == 0 && strcmp(command[1], "set") == 0)
  {
    JsonDocument doc;
    deserializeJson(doc, payload, length);

    if (doc["state"].is<float>())
    {
      ConfigDotsBrightness = map(doc["state"].as<long>(), 0, 100, 0, 255); // convert 0..100 % to 0..255
      MqttCommandDotsBrightnessReceived = true;
    }
    doc.clear();
  }
}

void MqttReportDiscovery(void)
{
#ifdef MQTT_HOME_ASSISTANT_DISCOVERY
  if (!MQTTclient.connected())
    return;
    
  if (!discoveryReported)
  {
    if (MqttPublishDiscoveryMessages())
    {
      discoveryReported = true;
      // after discovery is sent, all values must be updated.
      lastTimeSent = (unsigned long)(millis() - (MQTT_REPORT_STATUS_EVERY_SEC * 1001)); // execute on the first call to send Periodic messages
    }
    else
    {
      Log("Error sending discovery!");
      delay(2000);
    }
  }
#endif
}

void MqttReportBackOnChange()
{
  MqttPublishValues(false);
}

void MqttPeriodicReportBackEverything()
{
  if (HasTimeElapsed(&lastTimeSent, MQTT_REPORT_STATUS_EVERY_SEC * 1000))
  {
    MqttPublishValues(true);
  }
}

void MqttLoopFrequently()
{
#ifdef MQTT_ENABLED
  MQTTclient.loop();
  checkMqtt();
#endif
}

void MqttLoopInFreeTime()
{
#ifdef MQTT_ENABLED
  MqttReportDiscovery();
  MqttPeriodicReportBackEverything();
  MqttReportBackOnChange();
#endif
}

#endif // mqtt
