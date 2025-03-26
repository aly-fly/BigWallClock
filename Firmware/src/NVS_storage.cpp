
#include <Preferences.h>
#include "__CONFIG.h"
#include "GlobalVariables.h"
#include "Logger.h"

Preferences preferences;

#define NAMESPACE DEVICE_NAME  // Namespace name is limited to 15 chars.

void storedConfigLoad(void)
{
    Log("Loading NVS config.");
    preferences.begin(NAMESPACE, true); // read only

    // keep same value if error on reading
    ConfigBgPower = preferences.getBool("BgPower", ConfigBgPower);
    ConfigBgBrightness = preferences.getUChar("BgBrightness", ConfigBgBrightness);
    ConfigBgEffectNumber = preferences.getInt("BgEffectNum", ConfigBgEffectNumber);
    ConfigBgEffectStr = preferences.getString("BgEffectStr", ConfigBgEffectStr);
    ConfigBgColor = preferences.getUInt("BgColor", ConfigBgColor);
    ConfigEffectDuration = preferences.getFloat("EffectDuration", ConfigEffectDuration);
    ConfigDotsBrightness = preferences.getUChar("DotsBrightness", ConfigDotsBrightness);

    // Close the Preferences
    preferences.end();
}

void storedConfigSave(void)
{
    Log("Saving NVS config.");
    preferences.begin(NAMESPACE, false);

    preferences.putBool("BgPower", ConfigBgPower);
    preferences.putUChar("BgBrightness", ConfigBgBrightness);
    preferences.putInt("BgEffectNum", ConfigBgEffectNumber);
    preferences.putString("BgEffectStr", ConfigBgEffectStr);
    preferences.putUInt("BgColor", ConfigBgColor);
    preferences.putFloat("EffectDuration", ConfigEffectDuration);
    preferences.putUChar("DotsBrightness", ConfigDotsBrightness);

    // Close the Preferences
    preferences.end();
}
