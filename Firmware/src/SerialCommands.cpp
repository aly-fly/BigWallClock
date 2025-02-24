
#include <Arduino.h>
#include <stdint.h>
#include <stdlib.h>
#include "__CONFIG.h"
#include "GlobalVariables.h"
#include "Clock.h"
#include "motorDriver.h"
#include "TempSensor.h"
#include "Aksim2_encoder_uart2.h"
#include "Logger.h"
#include "fileSystem.h"
#include "TcpSocket.h"
#include "ResetReason.h"

String sSerialCmd;

void ReceiveAndProcessSerialCommands(void)
{
    // RX commands
    if (Serial.available() > 0)
    {
        sSerialCmd.concat(Serial.readString()); // add new data to the existing queue
    }
    if (DataAvailableInSocket())
    {
        sSerialCmd.concat(ReadFromSocket()); // add new data to the existing queue
    }
    if (sSerialCmd.length() >= 2)
    {
        int pp = sSerialCmd.indexOf('\r'); // find first command
        if (pp > 0)
        {
            char Cmd = sSerialCmd.charAt(pp - 1);
            LogNS("=====================================================\r\n");
            LogNS("Command received: %c\r\n", Cmd);

            switch (Cmd)
            {
            case 'M':
            {
                LogNS("-> Multiturn preset\r\n");
                if (pp > 2)
                {
                    char param1 = sSerialCmd.charAt(pp - 3);
                    char param2 = sSerialCmd.charAt(pp - 2);
                    param1 = param1 - '0';
                    param2 = param2 - '0';
                    uint16_t val = (param1 * 10) + param2;
                    if ((val >= 0) && (val <= 11))
                    {
                        LogNS("  New MT = %d\r\n", val);
                        EncoderSetMT(val);
                    }
                }
                encoderRead(true); // print new pos value
                break;
            }

            case 'Z':
                LogNS("-> Encoder zero\r\n");
                EncoderSetZeroHere();
                encoderRead(true); // print new pos value
                break;

            case 'E':
                LogNS("-> Enable clock\r\n");
                if (pp > 1)
                {
                    char param = sSerialCmd.charAt(pp - 2);
                    ClockEnabled = (param == '1');
                    EnableMotor(ClockEnabled);
                    ErrorCounter = 0;
                }
                break;

            case 'T':
            {
                LogNS("-> Test mode\r\n");
                if (pp > 1)
                {
                    char param = sSerialCmd.charAt(pp - 2);
                    TestMode = (param == '1');
                }
                break;
            }

            case 'C':
            {
                LogNS("-> Constant speed\r\n");
                if (pp > 1)
                {
                    byte param = sSerialCmd.charAt(pp - 2);
                    param = param - '0';
                    if ((param >= 0) && (param <= 9))
                    {
                        ClockEnabled = false;
                        TestMode = true;
                        int speed = 1 << param;
                        LogNS("  Speed = %d\r\n", speed);
                        MoveConstSpeed((float)speed, TestMode);
                    }
                }
                break;
            }

            case 'G':
            {
                LogNS("-> Encoder air gap? (loop)\r\n");
                bool oldTM = TestMode;
                TestMode = true; // do not save messages
                EnableMotor(false);
                for (int i = 0; i < 240; i++)
                {
                    encoderReadAirGap();
                    delay(1000);
                }
                TestMode = oldTM;
                break;
            }

            case 'P':
            {
                LogNS("-> Encoder position? (loop)\r\n");
                bool oldTM = TestMode;
                TestMode = true; // do not save messages
                EnableMotor(false);
                float ClocklPos;
                for (int i = 0; i < 240; i++)
                {
                    encoderRead(false);
                    ClocklPos = ((float)EncoderPosST * 12) / CPR;
                    LogNS("Clock position: %.2f\r\n", ClocklPos);
                    delay(1000);
                }
                TestMode = oldTM;
                break;
            }

            case 'S':
            {
                Log("-> System status?");
                Log( get_reset_reason().c_str() );
                Log("Boot time: %s.", BootTime);
                MotorGetStatusOk(true);
                Log("Motor temperature = %.1f C", TempSensorRead());

                encoderRead(true);
                encoderReadAirGap();

                fileSystemPrintInfo();

                Log("Free memory: %u bytes", esp_get_free_heap_size());
                multi_heap_info_t info;
                heap_caps_get_info(&info, MALLOC_CAP_INTERNAL | MALLOC_CAP_8BIT); // internal RAM, memory capable to store data or to create new task
                Log("Largest available block: %u bytes", info.largest_free_block);
                Log("Minimum free ever: %u bytes", info.minimum_free_bytes);
                break;
            }

            case 'L':
            {
                LogNS("-> LOG\r\n");
                if (pp > 1)
                {
                    byte param = sSerialCmd.charAt(pp - 2);
                    switch (param)
                    {
                    case 'L':
                        sSerialCmd.clear(); // otherwise it loops recursively
                        ReadAndPrintContentsOfTheLog();
                        break;
                    case 'D':
                        DeleteLogFile();
                        break;
                    }
                }
                break;
            }

            case 'R':
            {
                Log("-> Reboot!");
                EnableMotor(false);
                ESP.restart();
            }

            case '?':
            {
                SendToSocket(SERIAL_COMMANDS_LIST);
                SendToSocket("\r\n");
            }

            default:
                LogNS("-> Unknown\r\n");
                break;
            }
            sSerialCmd.clear(); // process only one command in one main loop
        } // pp > 0
    } // cmd length > 2
}
