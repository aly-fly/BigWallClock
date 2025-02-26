#include <Arduino.h>
#include <stdint.h>
#include "__CONFIG.h"
#include "Logger.h"
#include "Aksim2_encoder_uart2.h"

uint8_t RxBuffer[1 + 58];
String dbgStr;

uint32_t EncoderPosST;
int16_t EncoderPosMT;
bool EncoderWarning, EncoderError;
uint16_t EncoderDetailedStatus;
uint16_t EncoderSignalLevel;
float EncoderAirGap;

bool queryEncoder(uint8_t command, uint8_t DataLength, bool printData)
{
    while (Serial2.available())
        Serial2.read(RxBuffer, 1); // clear rx buffer

    // unsigned long startTime = millis();
    Serial2.write(command);
    memset(RxBuffer, 0x00, sizeof(RxBuffer));
    if (command == 'v')
        delay(20);
    else
        delay(2);
    uint8_t bytesRead;
    // log_i("Encoder data available: %d", Serial2.available());
    bytesRead = Serial2.read(RxBuffer, 1 + DataLength);
    //    log_i("Encoder read bytes: %d; TRX duration: %d ms", bytesRead, millis() - startTime);

    if (printData)
    {
        dbgStr.clear();
        for (int i = 0; i < bytesRead; i++)
        {
            dbgStr.concat("%2X ", RxBuffer[i]);
        }
        LogNS("Data: %s\r\n", dbgStr);
    }

    if (command == 'v')
    {
        dbgStr.clear();
        char ch;
        for (int i = 0; i < bytesRead; i++)
        {
            ch = (char)RxBuffer[i];
            if ((ch >= '!') && (ch <= 'z'))
                dbgStr.concat(ch);
        }
        dbgStr.trim();
        LogNS("Data: %s \r\n", dbgStr);
    }
    return (bytesRead == (DataLength + 1));
}

bool encoderInit(void)
{
    bool result = false;
    Log("Encoder init...");
    Serial2.begin(115200, SERIAL_8N1, RXD2pin, TXD2pin);
    delay(20);
    Serial2.flush();
    Serial2.setTimeout(300); // max 0.3 sec
    /*
    [  3382][I][Aksim2_encoder_uart2.cpp:55] encoderRead(): Encoder read bytes: 59
    [  3389][I][Aksim2_encoder_uart2.cpp:56] encoderRead(): Read duration: 12 ms
    Data: vAksIM-2URA_01MB029SFA17MFNT00'!----------------
    Data: 76 41 6B 73 49 4D 2D 32 20 55 52 41 5F 30 31 20 20 20 4D 42 30 32 39 53 46 41 31 37 4D 46 4E 54 30 30 20  2  9  3  0  0 27 21 20 2D 2D 2D 2D 2D 2D 2D 2D 2D 2D 2D 2D 2D 2D 2D 2D
    */
    if (queryEncoder('v', 58, true))
    {
        int idx = dbgStr.indexOf("MB029SFA17MFNT00");
        if (idx > 0)
        {
            Log("Encoder found and data is correct.");
            if (encoderRead(true))
            {
                result = !EncoderError;
            }
        }
        else
        {
            Log("Encoder didn't return correct identification! idx = %d", idx);
        }
    }
    else
    {
        Log("No useful data returned from encoder!");
    }
    return result;
}

bool encoderRead(bool PrintData)
{
    bool result = false;
    if (queryEncoder('d', 7, false)) // detailed status
    {
        if (RxBuffer[0] == 'd')
        {
            // endiannness is incorrect, can't use memcpy...
            EncoderPosMT = (RxBuffer[1] << 8) | RxBuffer[2];
            EncoderPosST = (RxBuffer[3] << 24) | (RxBuffer[4] << 16) | RxBuffer[5];
            EncoderDetailedStatus = (RxBuffer[6] << 8) | RxBuffer[7];

            EncoderError = !(EncoderPosST & 0x0002);
            EncoderWarning = !(EncoderPosST & 0x0001);
            EncoderPosST = EncoderPosST >> (32 - 17); // align LSB of the position and cut status bits

            if ((EncoderDetailedStatus != 0) || PrintData)
            {
                Log("Encoder: MT = %d; ST = %d; E = %d; W = %d;  status = 0x%4X.", EncoderPosMT, EncoderPosST, EncoderError, EncoderWarning, EncoderDetailedStatus);
                String sDetStatus;
                if ((EncoderDetailedStatus & 0x8000) > 0)
                    sDetStatus.concat("Multiturn error  ");
                if ((EncoderDetailedStatus & 0x4000) > 0)
                    sDetStatus.concat("Signal clipping error  ");
                if ((EncoderDetailedStatus & 0x2000) > 0)
                    sDetStatus.concat("Signal clipping warning  ");
                if ((EncoderDetailedStatus & 0x1000) > 0)
                    sDetStatus.concat("Sensor error  ");
                if ((EncoderDetailedStatus & 0x0800) > 0)
                    sDetStatus.concat("Sensor read error  ");
                if ((EncoderDetailedStatus & 0x0400) > 0)
                    sDetStatus.concat("Config error  ");
                if ((EncoderDetailedStatus & 0x0080) > 0)
                    sDetStatus.concat("Signal high warning  ");
                if ((EncoderDetailedStatus & 0x0040) > 0)
                    sDetStatus.concat("Signal low warning  ");
                if ((EncoderDetailedStatus & 0x0020) > 0)
                    sDetStatus.concat("Signal lost error  ");
                if ((EncoderDetailedStatus & 0x0010) > 0)
                    sDetStatus.concat("Temperature warning  ");
                if ((EncoderDetailedStatus & 0x0008) > 0)
                    sDetStatus.concat("Supply error  ");
                if ((EncoderDetailedStatus & 0x0004) > 0)
                    sDetStatus.concat("System error  ");
                if ((EncoderDetailedStatus & 0x0002) > 0)
                    sDetStatus.concat("Magnetic error  ");
                if ((EncoderDetailedStatus & 0x0001) > 0)
                    sDetStatus.concat("Acceleration error  ");
                if (sDetStatus.length() > 2)
                    Log("Encoder status:  %s.", sDetStatus.c_str());
            }
            result = true;
        }
        else
        {
            Log("Incorrect header returned!");
        }
    }
    else
    {
        Log("No useful data returned from encoder!");
    }
    return result;
}

bool encoderReadAirGap(void)
{
    bool result = false;
    if (queryEncoder('a', 7, false)) // signal level
    {
        if (RxBuffer[0] == 'a')
        {
            // endiannness is incorrect, can't use memcpy...
            EncoderPosMT = (RxBuffer[1] << 8) | RxBuffer[2];
            EncoderPosST = (RxBuffer[3] << 24) | (RxBuffer[4] << 16) | RxBuffer[5];
            EncoderSignalLevel = (RxBuffer[6] << 8) | RxBuffer[7];

            EncoderError = !(EncoderPosST & 0x0002);
            EncoderWarning = !(EncoderPosST & 0x0001);
            EncoderPosST = EncoderPosST >> (32 - 17); // align LSB of the position and cut signal level

            if (EncoderSignalLevel > 0)
                EncoderAirGap = -95.49 * log(EncoderSignalLevel) + 977.0; // K × Ln (SignalLevel) + N
            else
                EncoderAirGap = 0;

            Log("Encoder: MT = %d; ST = %d; E = %d; W = %d;  SignalLevel = %u; Air gap = %.1f um", EncoderPosMT, EncoderPosST, EncoderError, EncoderWarning, EncoderSignalLevel, EncoderAirGap);
            result = true;
        }
        else
        {
            Log("Incorrect header returned!");
        }
    }
    else
    {
        Log("No useful data returned from encoder!");
    }
    return result;
}

extern "C" const byte UnlockSeq[] = {0xCD, 0xEF, 0x89, 0xAB};
uint8_t TxBuffer[10];

bool EncoderTransferCommand(uint8_t DataLength)
{
    LogNS("Sending command: ");
    bool result = true;
    while (Serial2.available())
        Serial2.read(RxBuffer, 1); // clear rx buffer

    int i;
    for (i = 0; i < 4; i++)
    {
        TxBuffer[i] = UnlockSeq[i];
    }

    for (i = 0; i < DataLength; i++)
    {
        Serial2.write(TxBuffer[i]);
        delay(2);
        Serial2.read(RxBuffer, 1);
        if (TxBuffer[i] != RxBuffer[0])
            result = false;
        LogNS("(%2X / %2X) ", TxBuffer[i], RxBuffer[0]);
    }
    LogNS(".\r\n");
    return result;
}

bool EncoderSetMT(uint16_t NewMTvalue)
{
    bool result;
    TxBuffer[4] = 'M';
    TxBuffer[5] = 0;
    TxBuffer[6] = 0;
    TxBuffer[7] = (NewMTvalue >> 8) & 0xFF;
    TxBuffer[8] = (NewMTvalue) & 0xFF;
    result = EncoderTransferCommand(9);
    return result;
}

bool EncoderSetZeroHere(void)
{
    Log("Setting encoder zero position...");
    bool result = true;
    bool fncRes;

    // Clear any existing zero offset
    LogNS("- Set offset to zero\r\n");
    TxBuffer[4] = 'Z';
    TxBuffer[5] = 0;
    TxBuffer[6] = 0;
    TxBuffer[7] = 0;
    TxBuffer[8] = 0;
    fncRes = EncoderTransferCommand(9);
    LogNS("  OK : %d\r\n", fncRes);
    result = result && fncRes;
    delay(10);

    // Save to Flash
    LogNS("- Save to flash\r\n");
    TxBuffer[4] = 'c';
    fncRes = EncoderTransferCommand(5);
    LogNS("  OK : %d\r\n", fncRes);
    result = result && fncRes;
    delay(500);

    // Clear any MT error
    LogNS("- Clear MT error\r\n");
    fncRes = EncoderSetMT(0);
    LogNS("  OK : %d\r\n", fncRes);
    result = result && fncRes;
    delay(10);

    // Read position
    LogNS("- Read position\r\n");
    fncRes = encoderRead(true);
    delay(10);
    fncRes = encoderRead(true);
    LogNS("  OK : %d\r\n", fncRes);
    result = result && fncRes;
    delay(10);

    // Set new zero with a tiny offset to prevent MT jumping
    LogNS("- Set new offset\r\n");
    uint32_t NewOffset = EncoderPosST - 5;
    TxBuffer[4] = 'Z';
    TxBuffer[5] = (NewOffset >> 24) & 0xFF;
    TxBuffer[6] = (NewOffset >> 16) & 0xFF;
    TxBuffer[7] = (NewOffset >> 8) & 0xFF;
    TxBuffer[8] = NewOffset & 0xFF;
    fncRes = EncoderTransferCommand(9);
    LogNS("  OK : %d\r\n", fncRes);
    result = result && fncRes;
    delay(10);

    // Read position
    LogNS("- Read position\r\n");
    fncRes = encoderRead(true);
    delay(10);
    fncRes = encoderRead(true);
    LogNS("  OK : %d\r\n", fncRes);
    result = result && fncRes;
    delay(10);

    // Save to Flash
    LogNS("- Save to flash\r\n");
    TxBuffer[4] = 'c';
    fncRes = EncoderTransferCommand(5);
    LogNS("  OK : %d\r\n", fncRes);
    result = result && fncRes;
    delay(500);

    // Clear any MT error
    LogNS("- Clear MT error\r\n");
    fncRes = EncoderSetMT(0);
    LogNS("  OK : %d\r\n", fncRes);
    result = result && fncRes;
    delay(10);

    // Read position
    LogNS("- Read position\r\n");
    fncRes = encoderRead(true);
    fncRes = encoderRead(true);
    LogNS("  OK : %d\r\n", fncRes);
    result = result && fncRes;

    LogNS("Result: %d\r\n", result);
    return result;
}