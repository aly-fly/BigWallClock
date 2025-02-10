#include <Arduino.h>
#include "__CONFIG.h"

#define ADCbits 12
#define ADCmax 4095

// Note: ADC2 cannot be used when Wi-Fi is used. 

bool TempSensorInit(void)
{
    adcAttachPin(TEMP_SENS_PIN);
    analogSetWidth(12);
    analogSetAttenuation(ADC_11db); // default
    analogSetClockDiv(128); // slow
    //analogSetCycles(128); // long sampling time
    int val = analogRead(TEMP_SENS_PIN);
    log_n("ADC = %d", val);
    if (abs(val - 1600) < 400) return true; else return false;
}

float TempSensorRead(void)
{
    float ADCvalue = (float)analogRead(TEMP_SENS_PIN);
    // T =   1 / ((1/Tnominal) + log((    Rpullup        *  adcVal   / (adcMax – adcVal  )) /    Rnominal)   /  B)   – 273.15
    return  (1 / ((1 / 298.15) + log(((TEMP_SENS_RPULLUP * ADCvalue) / (ADCmax - ADCvalue)) / TEMP_SENS_R25) / 3435) - 273.15) + TEMP_SENS_OFFSET;
}
