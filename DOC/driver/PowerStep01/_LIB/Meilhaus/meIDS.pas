//==============================================================================
//Copyright(c), Meilhaus Electronic GmbH
//              http://www.meilhaus.de
//              support@meilhaus.de
//
//Source File : meIDS.pas
//Note        : import library for ME-iDS API 32bit: meIDSmain.dll
//              import library for ME-iDS API 64bit: meIDSmain64.dll
//Changes     : 2011-02-21 updated from metypes.h, medriver.h, medefines.h
//            : 2011-09-09 changed PChar to PAnsiChar
//            : 2012-04-04 new Property Get and Set functions,
//              new constants for property functions
//==============================================================================
unit meIDS;

interface

uses
    SysUtils, Windows;

const

{$IFDEF WIN32}
  MEIDSMAIN_DLL = 'meIDSmain.dll';               //import dll for ME-iDS API (32bit)
{$ENDIF}

{$IFDEF WIN64}
  MEIDSMAIN_DLL = 'meIDSmain64.dll';             //import dll for ME-iDS API (64bit)
{$ENDIF}

type
  //record of the single-config-list
  me_IOSingle = record                           //see Manual ME-iDS, Input/Output Functions, meIOSingle()
    iDevice: Integer;                            //Index of the device to be accessed
    iSubDevice: Integer;                         //Index of the sub-device to be accessed
    iChannel: Integer;                           //Channel index resp. index of the group
    iDir: Integer;                               //ME_DIR_INPUT, ME_DIR_OUTPUT, ME_DIR_SET_OFFSET
    iValue: Integer;                             //e.g. DIO: Read resp. output a 32 bit digital value. Depending on port width always the lower significant bits are relevant.
    iTimeOut: Integer;                           //Time-out value in milliseconds. If no external trigger is being used or no time-out value is used, pass 0
    iFlags: Integer;                             //Extended settings
    iErrno: Integer;                             //Error code returned by the particular entry
  end;
  TMeIOSingle = me_IOSingle;
  PMeIOSingle = ^TMeIOSingle;

  //record of the channel-list
  me_IOStreamConfig = record
    iChannel: Integer;                           //Channel index. Depending on sub-device this can be analog inputs or outputs as well as a group of digital I/Os
    iStreamConfig: Integer;                      //Index of analog input or analog output range; On bit pattern output pass ME_VALUE_NOT_USED
    iRef: Integer;                               //Defines the ground reference for analog inputs and outputs, ME_REF_NONE, ME_REF_AI_GROUND, ME_REF_AI_DIFFERENTIAL, ME_REF_AO_GROUND, ME_REF_AO_DIFFERENTIAL
    iFlags: Integer;                             //No extended options available, use ME_IO_STREAM_CONFIG_TYPE_NO_FLAGS
  end;
  TMeIOStreamConfig = me_IOStreamConfig;
  PMeIOStreamConfig = ^TMeIOStreamConfig;

  //trigger structure
  me_IOStreamTrigger = record
    iAcqStartTrigType: Integer;                  //defines the trigger type for start of the whole operation (ME_TRIG_TYPE_SW, ME_TRIG_TYPE_EXT_ANALOG, ME_TRIG_TYPE_THRESHOLD...)
    iAcqStartTrigEdge: Integer;                  //defines the trigger edge for start of a single conversion (ME_TRIG_EDGE_NONE, ME_TRIG_EDGE_RISING, ME_TRIG_EDGE_FALLING...)
    iAcqStartTrigChan: Integer;                  //choose whether triggering should be done separatly for each channel (standard) or if a channel should be started synchronously with other channels
    iAcqStartTicksLow: Integer;                  //Offset time in number of ticks between "start" of the measurement and the first conversion.
    iAcqStartTicksHigh: Integer;                 //Higher significant part of the offset time (bits 63 to 32)
    iAcqStartArgs: array [0..9] of Integer;      //List of Start Arguments (threshold value in [uV], slew rate in [uV/Sample], lower threshold value of the window in [uV])
    iScanStartTrigType: Integer;                 //defines the trigger type for start of a scan (ME_TRIG_TYPE_TIMER, ME_TRIG_TYPE_FOLLOW, ME_TRIG_TYPE_EXT_DIGITAL...)
    iScanStartTicksLow: Integer;                 //Time interval in ticks between the start of two consecutive scans
    iScanStartTicksHigh: Integer;                //Higher significant part of the scan-time (bits 63 to 32)
    iScanStartArgs: array [0..9] of Integer;     //reserved
    iConvStartTrigType: Integer;                 //defines the trigger type for start of a single conversion (ME_TRIG_TYPE_TIMER, ME_TRIG_TYPE_EXT_DIGITAL, ME_TRIG_TYPE_EXT_ANALOG)
    iConvStartTicksLow: Integer;                 //Chan interval in number of ticks between two conversions (Sample resp. output rate)
    iConvStartTicksHigh: Integer;                //Higher significant part of the chan interval (bits 63 to 32)
    iConvStartArgs: array [0..9] of Integer;     //reserved
    iScanStopTrigType: Integer;                  //defines the trigger type for ending the scan (ME_TRIG_TYPE_NONE, ME_TRIG_TYPE_COUNT)
    iScanStopCount: Integer;                     //Total number of conversions after which the scans will be ended and at the same time the measurement as a whole.
    iScanStopArgs: array [0..9] of Integer;      //MEphisto Scope in oscilloscope mode: trigger point in percent between 0% to 100%,
    iAcqStopTrigType: Integer;                   //defines the trigger type for ending the whole operation (ME_TRIG_TYPE_NONE, ME_TRIG_TYPE_COUNT, ME_TRIG_TYPE_FOLLOW)
    iAcqStopCount: Integer;                      //Number of scans (channel-list processings) after which the complete operation should be ended
    iAcqStopArgs: array [0..9] of Integer;       //reserved
    iFlags: Integer;                             //ME_IO_STREAM_TRIGGER_TYPE_NO_FLAGS (default) (no flags available)
  end;
  TMeIOStreamTrigger = me_IOStreamTrigger;
  PMeIOStreamTrigger = ^TMeIOStreamTrigger;

  me_IOStreamStart = record                      //StartList, defines by which streaming operations can be started
    iDevice: Integer;                            //Index of the device to be accessed
    iSubDevice: Integer;                         //Index of the sub-device to be accessed
    iStartMode: Integer;                         //ME_START_MODE_BLOCKING (waits until the proper trigger signal occurs), ME_START_MODE_NONBLOCKING (Function returns immediately)
    iTimeOut: Integer;                           //time interval in milliseconds within the first trigger pulse must occur
    iFlags: Integer;                             //ME_IO_STREAM_START_TYPE_NO_FLAGS, ME_IO_STREAM_START_TYPE_TRIG_SYNCHRONOUS for Synchronous start
    iErrno: Integer;                             //If an error occurs, an error code will be set
  end;
  TMeIOStreamStart = me_IOStreamStart;
  PMeIOStreamStart = ^TMeIOStreamStart;

  me_IOStreamStop = record                       //StopList, defines end of input/output operations
    iDevice: Integer;                            //Index of the device to be accessed
    iSubDevice: Integer;                         //Index of the sub-device to be accessed
    iStopMode: Integer;                          //ME_STOP_MODE_IMMEDIATE stopped at once, ME_STOP_MODE_LAST_VALUE
    iFlags: Integer;                             //ME_IO_STREAM_STOP_TYPE_NO_FLAGS, ME_IO_STREAM_STOP_TYPE_PRESERVE_BUFFERS (Linux only)
    iErrno: Integer;                             //If an error occurs, an error code will be set
  end;
  TMeIOStreamStop = me_IOStreamStop;
  PMeIOStreamStop = ^TMeIOStreamStop;

    // Typedef for general API error procedure - used in meErrorSetUserProc
  meErrorCB_t = function(pcFunctionName: PAnsiChar; iErrorCode: Integer): Integer; stdcall;

    // Typedef for streaming callback function - used in meIOStreamSetCallbacks
  meIOStreamCB_t = function(iDevice: Integer; iSubdevice: Integer; iCount: Integer; pvContext: Pointer; iErrorCode: Integer): Integer; stdcall;

    // Typedef for IRQ callback function - used in meIOIrqSetCallback
  meIOIrqCB_t = function(iDevice: Integer; iSubdevice: Integer; iChannel: Integer; iIrqCount: Integer; iValue: Integer; pvContext: Pointer; iErrorCode: Integer): Integer; stdcall;


//==============================================================================
//  System constants
//==============================================================================
const

//==================================================================
//  General
//==================================================================
    ME_VALUE_NOT_USED = $0;
    ME_VALUE_DEFAULT = $0;
    ME_NO_FLAGS = $0;

    ME_VALUE_INVALID = -1;
//==================================================================
//Defines common to access functions
//================================================================
    ME_LOCK_RELEASE = $10001;
    ME_LOCK_SET = $10002;
    ME_LOCK_CHECK = $10003;

//==================================================================
//  Defines meOpen function
//==================================================================
    ME_OPEN_NO_FLAGS = $0;

//==================================================================
//  Defines meClose function
//==================================================================
    ME_CLOSE_NO_FLAGS = $0;

//==================================================================
//  Defines meLockDriver function
//==================================================================
    ME_LOCK_DRIVER_NO_FLAGS = $0;

//==================================================================
//  Defines meLockDevice function
//==================================================================
    ME_LOCK_DEVICE_NO_FLAGS = $0;

//==================================================================
//  Defines meLockSubdevice function
//==================================================================
    ME_LOCK_SUBDEVICE_NO_FLAGS = $0;

//==================================================================
//  Defines common to error functions
//==================================================================
    ME_ERROR_MSG_MAX_COUNT = 256;
    ME_SWITCH_DISABLE = $20001;
    ME_SWITCH_ENABLE = $20002;

//==================================================================
//  Defines for meErrorGetLast function
//==================================================================
    ME_ERROR_GET_LAST_NO_FLAGS = $0;
    ME_ERROR_GET_LAST_CLEAR = $1;
    
//==================================================================
//  Defines common to IO functions
//==================================================================
    ME_REF_NONE =   $0;
    ME_REF_DIO_FIFO_LOW = $30001;
    ME_REF_DIO_FIFO_HIGH = $30002;

    ME_REF_CTR_PREVIOUS = $40001;
    ME_REF_CTR_INTERNAL_1MHZ = $40002;
    ME_REF_CTR_INTERNAL_10MHZ = $40003;
    ME_REF_CTR_EXTERNAL = $40004;

    ME_REF_AI_GROUND = $50001;
    ME_REF_AI_DIFFERENTIAL = $50002;

    ME_REF_AO_GROUND = $60001;
    ME_REF_AO_DIFFERENTIAL = $60002;

    ME_TRIG_CHAN_NONE = ME_VALUE_NOT_USED;
    ME_TRIG_CHAN_DEFAULT = $70001;
    ME_TRIG_CHAN_SYNCHRONOUS = $70002;

    ME_TRIG_TYPE_NONE = ME_VALUE_NOT_USED;
    ME_TRIG_TYPE_SW = $80001;
    ME_TRIG_TYPE_THRESHOLD = $80002;
    ME_TRIG_TYPE_WINDOW = $80003;
    ME_TRIG_TYPE_EDGE = $80004;
    ME_TRIG_TYPE_SLOPE = $80005;
    ME_TRIG_TYPE_EXT_DIGITAL = $80006;
    ME_TRIG_TYPE_EXT_ANALOG = $80007;
    ME_TRIG_TYPE_PATTERN = $80008;          //These two defines are the same
    ME_TRIG_TYPE_PATTERN_MATCH = $00080008; //to preserve compatibility
    ME_TRIG_TYPE_TIMER = $80009;
    ME_TRIG_TYPE_COUNT = $8000A;
    ME_TRIG_TYPE_FOLLOW = $8000B;
    ME_TRIG_TYPE_PATTERN_NO_MATCH = $0008000C;
    ME_TRIG_TYPE_EXT_DIGITAL_OR_COUNT = $0008000D;
    ME_TRIG_TYPE_PATTERN_MATCH_OR_COUNT = $0008000E;
    ME_TRIG_TYPE_PATTERN_NO_MATCH_OR_COUNT = $0008000F;

    ME_TRIG_EDGE_NONE = ME_VALUE_NOT_USED;
    ME_TRIG_EDGE_ABOVE = $90001;
    ME_TRIG_EDGE_BELOW = $90002;
    ME_TRIG_EDGE_ENTRY = $90003;
    ME_TRIG_EDGE_EXIT = $90004;
    ME_TRIG_EDGE_RISING = $90005;
    ME_TRIG_EDGE_FALLING = $90006;
    ME_TRIG_EDGE_ANY = $90007;

    ME_TIMER_ACQ_START = $A0001;
    ME_TIMER_SCAN_START = $A0002;
    ME_TIMER_CONV_START = $A0003;
    ME_TIMER_FIO_TOTAL = $A0004;
    ME_TIMER_FIO_FIRST_PHASE = $A0005;

//==================================================================
//  Defines for meIOFrequencyToTicks function
//==================================================================
    ME_IO_FREQUENCY_TO_TICKS_NO_FLAGS = $0;
    ME_IO_STREAM_FREQUENCY_TO_TICKS_NO_FLAGS = ME_IO_FREQUENCY_TO_TICKS_NO_FLAGS;
    ME_IO_FREQUENCY_TO_TICKS_MEPHISTO_SCOPE_OSCILLOSCOPE  = $1;

//==================================================================
//  Defines for meIOIrqStart function
//==================================================================
    ME_IRQ_SOURCE_DIO_PATTERN = $B0001;
    ME_IRQ_SOURCE_DIO_MASK = $B0002;
    ME_IRQ_SOURCE_DIO_LINE = $B0003;
    ME_IRQ_SOURCE_DIO_OVER_TEMP = $B0004;         //temperature changing from cool -> hot
    ME_IRQ_SOURCE_DIO_NORMAL_TEMP = $B0005;       //temperature changing from hot -> cool
    ME_IRQ_SOURCE_DIO_CHANGE_TEMP = $B0006;       //temperature changing both, from cool -> hot and hot -> cool

    ME_IRQ_EDGE_NOT_USED = ME_VALUE_NOT_USED;
    ME_IRQ_EDGE_RISING = $C0001;
    ME_IRQ_EDGE_FALLING = $C0002;
    ME_IRQ_EDGE_ANY = $C0003;

    ME_IO_IRQ_START_NO_FLAGS = $0;
    ME_IO_IRQ_START_DIO_BIT = $1;
    ME_IO_IRQ_START_DIO_BYTE = $2;
    ME_IO_IRQ_START_DIO_WORD = $4;
    ME_IO_IRQ_START_DIO_DWORD = $8;
    ME_IO_IRQ_START_PATTERN_FILTERING = $00000010;
    ME_IO_IRQ_START_EXTENDED_STATUS = $00000020;
    ME_IO_IRQ_START_USE_PROPERTIES = $40000000;

//==================================================================
//  Defines for meIOIrqWait function
//==================================================================
    ME_IO_IRQ_WAIT_NO_FLAGS = $0;
    ME_IO_IRQ_WAIT_NORMAL_STATUS = $00000001;
    ME_IO_IRQ_WAIT_EXTENDED_STATUS = $00000002;

//==================================================================
//  Defines for meIOIrqStop function
//==================================================================
    ME_IO_IRQ_STOP_NO_FLAGS = $0;

//==================================================================
//  Defines for meIOIrqSetCallback function
//==================================================================
    ME_IO_IRQ_SET_CALLBACK_NO_FLAGS = $0;

//==================================================================
//  Defines for meIOResetDevice function
//==================================================================
    ME_IO_RESET_DEVICE_NO_FLAGS = $0;
    ME_IO_RESET_SUBDEVICE_NO_FLAGS = $0;

//==================================================================
//  Defines for meIOSetChannelOffset function
//==================================================================
    ME_IO_SET_CHANNEL_OFFSET_NO_FLAGS = $0;

//==================================================================
//  Defines for meIOSingleConfig function
//==================================================================
//Definitions for digital subdevice.
    ME_SINGLE_CONFIG_DIO_INPUT = $D0001;
    ME_SINGLE_CONFIG_DIO_OUTPUT = $D0002;
    ME_SINGLE_CONFIG_DIO_HIGH_IMPEDANCE = $D0003;
    ME_SINGLE_CONFIG_DIO_SINK = $D0004;
    ME_SINGLE_CONFIG_DIO_SOURCE = $D0005;
    ME_SINGLE_CONFIG_DIO_MUX32M = $D0006;
    ME_SINGLE_CONFIG_DIO_DEMUX32 = $D0007;
    ME_SINGLE_CONFIG_DIO_BIT_PATTERN = $D0008;

//Definitions for frequency subdevice.
    ME_SINGLE_CONFIG_FIO_INPUT = $1E0001;
    ME_SINGLE_CONFIG_FIO_OUTPUT = $1E0002;
    ME_SINGLE_CONFIG_FIO_HIGH_IMPEDANCE = $001E0002;
    ME_SINGLE_CONFIG_FIO_SINK = $001E0003;
    ME_SINGLE_CONFIG_FIO_SOURCE = $001E0004;

//Definitions for counter 8254 subdevice
    ME_SINGLE_CONFIG_CTR_8254_MODE_0 = $E0001;
    ME_SINGLE_CONFIG_CTR_8254_MODE_1 = $E0002;
    ME_SINGLE_CONFIG_CTR_8254_MODE_2 = $E0003;
    ME_SINGLE_CONFIG_CTR_8254_MODE_3 = $E0004;
    ME_SINGLE_CONFIG_CTR_8254_MODE_4 = $E0005;
    ME_SINGLE_CONFIG_CTR_8254_MODE_5 = $E0006;

    ME_IO_SINGLE_CONFIG_NO_FLAGS = $0;
    ME_IO_SINGLE_CONFIG_DIO_BIT = $1;
    ME_IO_SINGLE_CONFIG_DIO_BYTE = $2;
    ME_IO_SINGLE_CONFIG_DIO_WORD = $4;
    ME_IO_SINGLE_CONFIG_DIO_DWORD = $8;
    ME_IO_SINGLE_CONFIG_MULTISIG_LED_ON = $10;
    ME_IO_SINGLE_CONFIG_MULTISIG_LED_OFF = $20;
    ME_IO_SINGLE_CONFIG_AI_RMS = $40;

//==================================================================
//  Defines for meIOSingle function
//==================================================================
    ME_IO_SINGLE_NO_FLAGS = $0;
    
    ME_DIR_INPUT = $F0001;
    ME_DIR_OUTPUT = $F0002;
    ME_DIR_SET_OFFSET = $F0003;

    ME_IO_SINGLE_TYPE_NO_FLAGS = $0;
    ME_IO_SINGLE_TYPE_DIO_BIT = $1;
    ME_IO_SINGLE_TYPE_DIO_BYTE = $2;
    ME_IO_SINGLE_TYPE_DIO_WORD = $4;
    ME_IO_SINGLE_TYPE_DIO_DWORD = $8;
    ME_IO_SINGLE_TYPE_TRIG_SYNCHRONOUS = $10;
    ME_IO_SINGLE_TYPE_NONBLOCKING = $20;
    ME_IO_SINGLE_TYPE_WRITE_NONBLOCKING = ME_IO_SINGLE_TYPE_NONBLOCKING;
    ME_IO_SINGLE_TYPE_READ_NONBLOCKING = ME_IO_SINGLE_TYPE_NONBLOCKING;

    ME_IO_SINGLE_TYPE_FIO_DIVIDER = $40;
    ME_IO_SINGLE_TYPE_FO_START_LOW = $80;
    ME_IO_SINGLE_TYPE_FO_START_SOFT = $100;
    ME_IO_SINGLE_TYPE_FI_LAST_VALUE = $200;
    ME_IO_SINGLE_TYPE_FO_UPDATE_ONLY = $200;
    ME_IO_SINGLE_TYPE_FIO_TICKS_TOTAL = $400;
    ME_IO_SINGLE_TYPE_FIO_TICKS_FIRST_PHASE = $800;
    ME_IO_SINGLE_TYPE_FO_USE_PROPERTIES = $40000000;

//==================================================================
//  Defines for meIOSingleTimeToTicks function
//==================================================================
    ME_IO_SINGLE_TIME_TO_TICKS_NO_FLAGS = $0;

//==================================================================
//  Defines for meIOSingleTicksToTime function
//==================================================================
    ME_IO_SINGLE_TICKS_TO_TIME_NO_FLAGS = $0;

//==================================================================
//  Defines for meIOStreamConfig function
//==================================================================
    ME_IO_STREAM_CONFIG_NO_FLAGS = $0;
    ME_IO_STREAM_CONFIG_BIT_PATTERN = $1;
    ME_IO_STREAM_CONFIG_WRAPAROUND = $2;
    ME_IO_STREAM_CONFIG_SAMPLE_AND_HOLD = $4;
    ME_IO_STREAM_CONFIG_INTERNAL_COUNTER = Integer($80000000);
    ME_IO_STREAM_CONFIG_TYPE_NO_FLAGS = $0;

    ME_IO_STREAM_TRIGGER_TYPE_NO_FLAGS = $0;

//==================================================================
//  Defines for meIOStreamRead function
//==================================================================
    ME_READ_MODE_BLOCKING = $100001;
    ME_READ_MODE_NONBLOCKING = $100002;
    
    ME_IO_STREAM_READ_NO_FLAGS = $0;
    ME_IO_STREAM_READ_FRAMES = $1;

//==================================================================
//  Defines for meIOStreamWrite function
//==================================================================
    ME_WRITE_MODE_BLOCKING = $110001;
    ME_WRITE_MODE_NONBLOCKING = $110002;
    ME_WRITE_MODE_PRELOAD = $110003;
    
    ME_IO_STREAM_WRITE_NO_FLAGS = $0;

//==================================================================
//  Defines for meIOStreamStart function
//==================================================================
    ME_IO_STREAM_START_NO_FLAGS = $0;
    ME_IO_STREAM_START_NONBLOCKING = $20;
    
    ME_START_MODE_BLOCKING = $120001;
    ME_START_MODE_NONBLOCKING = $120002;
    
    ME_IO_STREAM_START_TYPE_NO_FLAGS = $0;
    ME_IO_STREAM_START_TYPE_TRIG_SYNCHRONOUS = $1;

//==================================================================
//  Defines for meIOStreamStop function
//==================================================================
    ME_IO_STREAM_STOP_NO_FLAGS = $0;
    ME_IO_STREAM_STOP_NONBLOCKING = $20;
    
    ME_STOP_MODE_IMMEDIATE = $130001;
    ME_STOP_MODE_LAST_VALUE = $130002;
    
    ME_IO_STREAM_STOP_TYPE_NO_FLAGS = $0;

//==================================================================
//Defines for meIOStreamStatus function
//==================================================================
    ME_WAIT_NONE = $140001;
    ME_WAIT_IDLE = $140002;
    ME_WAIT_BUSY = $140003;

    ME_STATUS_INVALID = $0;
    ME_STATUS_IDLE = $150001;
    ME_STATUS_BUSY = $150002;
    ME_STATUS_ERROR = $150003;
    
    ME_IO_STREAM_STATUS_NO_FLAGS = $0;

//==================================================================
//  Defines for meIOStreamSetCallbacks function
//==================================================================
    ME_IO_STREAM_SET_CALLBACKS_NO_FLAGS = $0;

//==================================================================
//  Defines for meIOStreamTimeToTicks function
//==================================================================
    ME_IO_TIME_TO_TICKS_NO_FLAGS = $0;
    ME_IO_STREAM_TIME_TO_TICKS_NO_FLAGS = ME_IO_TIME_TO_TICKS_NO_FLAGS;
    ME_IO_TIME_TO_TICKS_MEPHISTO_SCOPE_OSCILLOSCOPE = $1;

//==================================================================
//  Defines for module types
//==================================================================
    ME_MODULE_TYPE_MULTISIG_NONE = $0;
    ME_MODULE_TYPE_MULTISIG_DIFF16_10V = $160001;
    ME_MODULE_TYPE_MULTISIG_DIFF16_20V = $160002;
    ME_MODULE_TYPE_MULTISIG_DIFF16_50V = $160003;
    ME_MODULE_TYPE_MULTISIG_CURRENT16_0_20MA = $160004;
    ME_MODULE_TYPE_MULTISIG_RTD8_PT100 = $160005;
    ME_MODULE_TYPE_MULTISIG_RTD8_PT500 = $160006;
    ME_MODULE_TYPE_MULTISIG_RTD8_PT1000 = $160007;
    ME_MODULE_TYPE_MULTISIG_TE8_TYPE_B = $160008;
    ME_MODULE_TYPE_MULTISIG_TE8_TYPE_E = $160009;
    ME_MODULE_TYPE_MULTISIG_TE8_TYPE_J = $16000A;
    ME_MODULE_TYPE_MULTISIG_TE8_TYPE_K = $16000B;
    ME_MODULE_TYPE_MULTISIG_TE8_TYPE_N = $16000C;
    ME_MODULE_TYPE_MULTISIG_TE8_TYPE_R = $16000D;
    ME_MODULE_TYPE_MULTISIG_TE8_TYPE_S = $16000E;
    ME_MODULE_TYPE_MULTISIG_TE8_TYPE_T = $16000F;
    ME_MODULE_TYPE_MULTISIG_TE8_TEMP_SENSOR = $160010;

//==================================================================
//  Defines for meQuerySubdeviceCaps function
//==================================================================
    ME_CAPS_DIO_DIR_BIT = $1;
    ME_CAPS_DIO_DIR_BYTE = $2;
    ME_CAPS_DIO_DIR_WORD = $4;
    ME_CAPS_DIO_DIR_DWORD = $8;
    ME_CAPS_DIO_SINK_SOURCE = $10;
    ME_CAPS_DIO_BIT_PATTERN_IRQ = $20;
    ME_CAPS_DIO_BIT_MASK_IRQ_EDGE_RISING = $40;
    ME_CAPS_DIO_BIT_MASK_IRQ_EDGE_FALLING = $80;
    ME_CAPS_DIO_BIT_MASK_IRQ_EDGE_ANY = $100;
    ME_CAPS_DIO_OVER_TEMP_IRQ = $200;
    ME_CAPS_DIO_NORMAL_TEMP_IRQ = $400;

    ME_CAPS_CTR_CLK_PREVIOUS = $1;
    ME_CAPS_CTR_CLK_INTERNAL_1MHZ = $2;
    ME_CAPS_CTR_CLK_INTERNAL_10MHZ = $4;
    ME_CAPS_CTR_CLK_EXTERNAL = $8;

    ME_CAPS_AI_TRIG_SIMULTANEOUS = $1;
    ME_CAPS_AI_FIFO = $2;
    ME_CAPS_AI_FIFO_THRESHOLD = $4;
    ME_CAPS_AI_SAMPLE_HOLD = $8;

    ME_CAPS_AO_TRIG_SIMULTANEOUS = $1;
    ME_CAPS_AO_FIFO = $2;
    ME_CAPS_AO_FIFO_THRESHOLD = $4;

    ME_CAPS_FIO_SINK_SOURCE = $10;

    ME_CAPS_EXT_IRQ_EDGE_RISING = $1;
    ME_CAPS_EXT_IRQ_EDGE_FALLING = $2;
    ME_CAPS_EXT_IRQ_EDGE_ANY = $4;

//==================================================================
//  Defines for meQuerySubdeviceCapsArgs function
//==================================================================

    ME_CAP_AI_FIFO_SIZE                     = $001D0000;
    ME_CAP_AI_BUFFER_SIZE                   = $001D0001;
    ME_CAP_AI_CHANNEL_LIST_SIZE             = $001D0002;
    ME_CAP_AI_MAX_THRESHOLD_SIZE            = $001D0003;

    ME_CAP_AO_FIFO_SIZE                     = $001F0000;
    ME_CAP_AO_BUFFER_SIZE                   = $001F0001;
    ME_CAP_AO_CHANNEL_LIST_SIZE             = $001F0002;
    ME_CAP_AO_MAX_THRESHOLD_SIZE            = $001F0003;

    ME_CAP_CTR_WIDTH                        = $00200000;

    ME_CAP_FPGA_IN_FIFO_SIZE                = $00300000;
    ME_CAP_FPGA_IN_BUFFER_SIZE              = $00300001;
    ME_CAP_FPGA_OUT_FIFO_SIZE               = $00300002;
    ME_CAP_FPGA_OUT_BUFFER_SIZE             = $00300003;


//==================================================================
//  Defines common to query functions
//==================================================================

    ME_UNIT_INVALID = $0;
    ME_UNIT_VOLT = $170001;
    ME_UNIT_AMPERE = $170002;
    ME_UNIT_ANY = $170003;
    ME_UNIT_HZ = $170004;

    ME_TYPE_INVALID = $0;
    ME_TYPE_AO = $180001;
    ME_TYPE_AI = $180002;
    ME_TYPE_DIO = $180003;
    ME_TYPE_DO = $180004;
    ME_TYPE_DI = $180005;
    ME_TYPE_CTR = $180006;
    ME_TYPE_EXT_IRQ = $180007;
    ME_TYPE_FIO =   $180008;
    ME_TYPE_FO = $180009;
    ME_TYPE_FI = $18000A;
    ME_TYPE_FPGA = $18000B;

    ME_SUBTYPE_INVALID = $0;
    ME_SUBTYPE_SINGLE = $190001;
    ME_SUBTYPE_STREAMING = $190002;
    ME_SUBTYPE_CTR_8254 = $190003;
    ME_SUBTYPE_ANY = $190004;
    ME_SUBTYPE_CTR = $190006;

    ME_DEVICE_DRIVER_NAME_MAX_COUNT = 64;
    ME_DEVICE_NAME_MAX_COUNT = 64;
    ME_DEVICE_DESCRIPTION_MAX_COUNT = 256;

    ME_BUS_TYPE_INVALID = $0;
    ME_BUS_TYPE_ANY = $1A0000;
    ME_BUS_TYPE_PCI = $1A0001;
    ME_BUS_TYPE_USB = $1A0002;
    ME_BUS_TYPE_LAN_PCI = $1A0101;
    ME_BUS_TYPE_LAN_USB = $1A0102;

    ME_PLUGGED_INVALID = $0;
    ME_PLUGGED_ANY = $1B0000;
    ME_PLUGGED_IN = $1B0001;
    ME_PLUGGED_OUT = $1B0002;

    ME_EXTENSION_TYPE_INVALID = $0;
    ME_EXTENSION_TYPE_NONE = $1C0001;
    ME_EXTENSION_TYPE_MUX32M = $1C0002;
    ME_EXTENSION_TYPE_DEMUX32 = $1C0003;
    ME_EXTENSION_TYPE_MUX32S = $1C0004;
    ME_EXTENSION_TYPE_ME1001 = $1C0005;

    ME_ACCESS_TYPE_INVALID = $0;
    ME_ACCESS_TYPE_ANY = $1D0000;
    ME_ACCESS_TYPE_LOCAL = $1D0001;
    ME_ACCESS_TYPE_REMOTE = $1D0002;

//==================================================================
//  Defines for ConfigLoad
//==================================================================
    ME_CONF_LOAD_CUSTOM_DRIVER = $00001000;

//==================================================================
//  Defines for FPGA device
//==================================================================
    ME_FPGA_FIRMWARE = $FF000001;
    ME_FPGA_SUBDEVICE = $FF000002;

//==================================================================
//  Defines for meUtilityPWM
//==================================================================
    ME_PWM_START_NO_FLAGS = $00000000;
    ME_PWM_START_CONNECT_INTERNAL = $00000001;

//==================================================================
//  Defines of flags for error handling
//==================================================================
    ME_ERRNO_CLEAR_FLAGS = $01;

//==================================================================
//  Defines of flags for device settings, used with property functions
//==================================================================
    ME_IO_PIN_VOLTAGE_LEVEL_5_VOLTS = $0;
    ME_IO_PIN_VOLTAGE_LEVEL_3_3_VOLTS = $1;

//==================================================================
//  Defines of flags for property functions
//==================================================================
    ME_PROPERTY_TYPE_INVALID = $0;
    ME_PROPERTY_TYPE_CONTAINER = $1;
    ME_PROPERTY_TYPE_BOOL = $2;
    ME_PROPERTY_TYPE_INT = $3;
    ME_PROPERTY_TYPE_DOUBLE = $4;
    ME_PROPERTY_TYPE_STRING = $5;
    ME_PROPERTY_TYPE_DEFINE = $6;

    ME_PROPERTY_ACCESS_READ_ONLY = $0;
    ME_PROPERTY_ACCESS_READ_WRITE = $1;

    ME_PROPERTY_BOOLEAN_FALSE = $00;
    ME_PROPERTY_BOOLEAN_TRUE = $01;

    ME_CALIBRATION_TYPE_FACTORY = $001E0000;
    ME_CALIBRATION_TYPE_USER_1 = $001E0001;


const
  MEIDS_LibHandle: Cardinal = 0;
//==================================================================
// me-iDS API Functions
//==================================================================
  meOpen: function(iFlags: Integer): Integer; cdecl = nil;
  meClose: function(iFlags: Integer): Integer; cdecl = nil;
  meLockDriver: function(iLock: Integer; iFlags: Integer):Integer; cdecl = nil;
  meLockDevice: function(iDevice: Integer; iLock: Integer; iFlags: Integer): Integer; cdecl = nil;
  meLockSubdevice: function(iDevice: Integer; iSubDevice: Integer; iLock: Integer; iFlags: Integer): Integer; cdecl = nil;
  //  Error handling functions
  meErrorGetLast: function(var piErrorCode: Integer; iFlags: Integer): Integer; cdecl = nil;
  meErrorGetLastMessage: function(pcErrorMsg: PAnsiChar; iCount: Integer): Integer; cdecl = nil;
  meErrorGetMessage: function(iErrorCode: Integer; pcErrorMsg: PAnsiChar; iCount: Integer): Integer; cdecl = nil;
  meErrorSetDefaultProc: function(iSwitch: Integer): Integer; cdecl = nil;
  meErrorSetUserProc: function(pErrorProc: meErrorCB_t): Integer; cdecl = nil;
  // Functions to perform I/O on a device
  meIOIrqSetCallback: function(iDevice: Integer; iSubDevice: Integer; pCallback: meIOIrqCB_t; pCallbackContext: Pointer; iFlags: Integer): Integer; cdecl = nil;
  meIOIrqStart: function(iDevice: Integer; iSubDevice: Integer; iChannel: Integer; iIrqSources: Integer; iIrqEdge : Integer; iIrqArg : Integer; iFlags : Integer):  Integer; cdecl = nil;
  meIOIrqStop: function(iDevice: Integer; iSubDevice: Integer; iChannel: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOIrqWait: function(iDevice: Integer; iSubDevice: Integer ;iChannel: Integer; var piIrqCount: Integer; var piValue: Integer; iTimeOut: Integer; iFlags: Integer ): Integer; cdecl = nil;
  meIOResetDevice: function(iDevice: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOResetSubdevice: function(iDevice: Integer; iSubDevice: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOStreamFrequencyToTicks: function(iDevice: Integer; iSubDevice: Integer; iTimer: Integer; var pdFrequency: Double; var piTicksLow: Integer; var piTicksHigh: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOSetChannelOffset: function(iDevice: Integer; iSubdevice: Integer; iChannel: Integer; iRange: Integer; var pdOffset: Double; iFlags: Integer): Integer; cdecl = nil;
  meIOSingleConfig: function(iDevice: Integer; iSubDevice: Integer; iChannel: Integer; iSingleconfig: Integer; iRef: Integer; iTrigChan: Integer; iTrigtype: Integer; iTrigedge: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOSingle: function(var pSingleList: TMeIOSingle; iCount: Integer; iFlag: Integer): Integer; cdecl = nil;
  meIOSingleTimeToTicks: function(iDevice: Integer; iSubDevice: Integer; iTimer: Integer; var pdTime: Double; var piTicksLow: Integer; var piTicksHigh: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOSingleTicksToTime: function(iDevice: Integer; iSubDevice: Integer; iTimer: Integer; iTicksLow: Integer; iTicksHigh: Integer; var pdTime: Double; iFlags: Integer): Integer; cdecl = nil;
  meIOStreamConfig: function(iDevice: Integer; iSubDevice: Integer; var pConfigList: TMeIOStreamConfig; iCount: Integer; var pTrigger: TMeIOStreamTrigger; iFifoIrqThreshold: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOStreamRead: function(iDevice: Integer; iSubDevice: Integer; lReadMode: Integer; var piValues: Integer; var plCount: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOStreamWrite: function(iDevice: Integer; iSubDevice: Integer; lWriteMode: Integer; var piValues: Integer; var plCount: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOStreamStart: function(var pStartList: TMeIOStreamStart; iCount: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOStreamStop: function(var pStopList: TMeIOStreamStop; iCount: Integer; iFlags: Integer): Integer; cdecl = nil;
  meIOStreamStatus: function(iDevice: Integer; iSubDevice: Integer; lWait: Integer; var plStatus: Integer; var plCount: Integer; iFlags: Integer ): Integer; cdecl = nil;
  meIOStreamSetCallbacks: function(iDevice: Integer; iSubDevice: Integer; pStartCB: meIOStreamCB_t; pStartCBContext: Pointer; pNewValuesCB: meIOStreamCB_t; pNewValuesCBContext: Pointer; pEndCB: meIOStreamCB_t; pEndCBContext: Pointer; iFlags: Integer): Integer; cdecl = nil;
  meIOStreamTimeToTicks: function(iDevice: Integer; iSubDevice: Integer; iTimer: Integer; var pdTime: Double; var piTicksLow: Integer; var piTicksHigh: Integer; iFlags: Integer): Integer; cdecl = nil;
  //  Functions to query the driver system
  meQueryDescriptionDevice: function(iDevice: Integer; pcDescription: PAnsiChar; iCount: Integer): Integer; cdecl = nil;
  meQueryInfoDevice: function(iDevice: Integer; var piVendorId: Integer; var piDeviceId: Integer; var piSerialNo: Integer; var piBusType: Integer; var piBusNo: Integer; var plDevNo: Integer; var plFuncNo: Integer; var plPlugged: Integer): Integer; cdecl = nil;
  meQueryNameDevice: function(iDevice: Integer; pcName: PAnsiChar; iCount: Integer): Integer overload; cdecl = nil;
  meQueryNameDeviceDriver: function(iDevice: Integer; pcName: PAnsiChar; iCount: Integer): Integer; cdecl = nil;
  meQueryNumberDevices: function(var piNumber: Integer): Integer; cdecl = nil;
  meQueryNumberSubdevices: function(iDevice: Integer; var piNumber: Integer): Integer; cdecl = nil;
  meQueryNumberChannels: function(iDevice: Integer; iSubDevice: Integer; var piNumber: Integer): Integer; cdecl = nil;
  meQueryNumberRanges: function(iDevice: Integer; iSubDevice: Integer; lUnit: Integer; var piNumber: Integer): Integer; cdecl = nil;
  meQueryRangeByMinMax: function(iDevice: Integer; iSubDevice: Integer; lUnit: Integer; var pdMin: Double; var pdMax: Double; var piMaxData: Integer; var piRange: Integer): Integer; cdecl = nil;
  meQueryRangeInfo: function(iDevice: Integer; iSubDevice: Integer; lRange: Integer; var piUnit: Integer; var pdMin: Double; var pdMax: Double; var piMaxData: Integer): Integer; cdecl = nil;
  meQuerySubdeviceByType: function(iDevice: Integer; iStartSubdevice: Integer; iType: Integer; lSubtype: Integer; var piSubdevice: Integer): Integer; cdecl = nil;
  meQuerySubdeviceType: function(iDevice: Integer; iSubDevice: Integer; var piType: Integer; var piSubtype: Integer): Integer; cdecl = nil;
  meQuerySubdeviceCaps: function(iDevice: Integer; iSubDevice: Integer; var piCaps: Integer): Integer; cdecl = nil;
  meQuerySubdeviceCapsArgs: function(iDevice: Integer; iSubDevice: Integer; iCap: Integer; piArgs: PInteger; iCount: Integer): Integer; cdecl = nil;
  meQueryVersionLibrary: function(var piVersion: Integer): Integer; cdecl = nil;
  meQueryVersionMainDriver: function(var piVersion: Integer): Integer; cdecl = nil;
  meQueryVersionDeviceDriver: function(iDevice: Integer; var piVersion: Integer): Integer; cdecl = nil;
  //  Common utility functions
  meUtilityExtractValues: function(iChannel: Integer; var piAIBuffer: Integer; lAIBufferCount: Integer; var pConfigList: TMeIOStreamConfig; iConfigListCount: Integer; var piChanBuffer: Integer; var plChanBufferCount: Integer): Integer; cdecl = nil;
  meUtilityDigitalToPhysical: function(dMin: Double; dMax: Double; iMaxData: Integer; iData: Integer; iModuleType: Integer; dRefValue: Double; var pdPhysical: Double): Integer; cdecl = nil;
  meUtilityDigitalToPhysicalV: function(dMin: Double; dMax: Double; iMaxData: Integer; var piDataBuffer: Integer; iCount: Integer; iModuleType: Integer; drefValue: Double; var pdPhysicalBuffer: Integer): Integer; cdecl = nil;
  meUtilityPhysicalToDigital: function(dMin: Double; dMax: Double; iMaxData: Integer; dPhysical: Double; var piData: Integer): Integer; cdecl = nil;
  meUtilityPhysicalToDigitalV: function(dMin: Double; dMax: Double; iMaxData: Integer; var pdPhysicalBuffer: Double; iCount: Integer; var piDataBuffer: Integer): Integer; cdecl = nil;
  meUtilityPWMStart: function(iDevice: Integer; iSubdevice1: Integer; iSubdevice2: Integer; iSubdevice3: Integer; iRef: Integer; iPrescaler: Integer; iDutyCycle: Integer; iFlag: Integer): Integer; cdecl = nil;
  meUtilityPWMRestart: function(iDevice: Integer; iSubDevice1: Integer; iRef: Integer; iPrescaler: Integer): Integer; cdecl = nil;
  meUtilityPWMStop: function(iDevice: Integer; iSubDevice: Integer): Integer; cdecl = nil;
  //  Property Get and Set functions
  mePropertyGetIntA: function(pcPropertyPath: PAnsiChar; var piPropertyValue: Integer): Integer; cdecl = nil;
  mePropertyGetIntW: function(pcPropertyPath: PWideChar; var piPropertyValue: Integer): Integer; cdecl = nil;
  mePropertyGetDoubleA: function(pcPropertyPath: PAnsiChar; var pdPropertyValue: Double): Integer; cdecl = nil;
  mePropertyGetDoubleW: function(pcPropertyPath: PWideChar; var pdPropertyValue: Double): Integer; cdecl = nil;
  mePropertyGetStringA: function(pcPropertyPath: PAnsiChar; pcPropertyValue: PAnsiChar; iBufferLength: Integer): Integer; cdecl = nil;
  mePropertyGetStringW: function(pcPropertyPath: PWideChar; pcPropertyValue: PWideChar; iBufferLength: Integer): Integer; cdecl = nil;
  mePropertySetIntA: function(pcPropertyPath: PAnsiChar; iPropertyValue: Integer): Integer; cdecl = nil;
  mePropertySetIntW: function(pcPropertyPath: PWideChar; iPropertyValue: Integer): Integer; cdecl = nil;
  mePropertySetDoubleA: function(pcPropertyPath: PAnsiChar; dPropertyValue: Double): Integer; cdecl = nil;
  mePropertySetDoubleW: function(pcPropertyPath: PWideChar; dPropertyValue: Double): Integer; cdecl = nil;
  mePropertySetStringA: function(pcPropertyPath: PAnsiChar; pcPropertyValue: PAnsiChar): Integer; cdecl = nil;
  mePropertySetStringW: function(pcPropertyPath: PWideChar; pcPropertyValue: PWideChar): Integer; cdecl = nil;

implementation

initialization
  MEIDS_LibHandle := LoadLibrary(MEIDSMAIN_DLL);
  if MEIDS_LibHandle <> 0 then
  begin
    @meOpen := GetProcAddress(MEIDS_LibHandle, 'meOpen');
    @meClose := GetProcAddress(MEIDS_LibHandle, 'meClose');
    @meLockDriver := GetProcAddress(MEIDS_LibHandle, 'meLockDriver');
    @meLockDevice := GetProcAddress(MEIDS_LibHandle, 'meLockDevice');
    @meLockSubdevice := GetProcAddress(MEIDS_LibHandle, 'meLockSubdevice');
    @meErrorGetLast := GetProcAddress(MEIDS_LibHandle, 'meErrorGetLast');
    @meErrorGetLastMessage := GetProcAddress(MEIDS_LibHandle, 'meErrorGetLastMessage');
    @meErrorGetMessage := GetProcAddress(MEIDS_LibHandle, 'meErrorGetMessage');
    @meErrorSetDefaultProc := GetProcAddress(MEIDS_LibHandle, 'meErrorSetDefaultProc');
    @meErrorSetUserProc := GetProcAddress(MEIDS_LibHandle, 'meErrorSetUserProc');
    @meIOIrqSetCallback := GetProcAddress(MEIDS_LibHandle, 'meIOIrqSetCallback');
    @meIOIrqStart := GetProcAddress(MEIDS_LibHandle, 'meIOIrqStart');
    @meIOIrqStop := GetProcAddress(MEIDS_LibHandle, 'meIOIrqStop');
    @meIOIrqWait := GetProcAddress(MEIDS_LibHandle, 'meIOIrqWait');
    @meIOResetDevice := GetProcAddress(MEIDS_LibHandle, 'meIOResetDevice');
    @meIOResetSubdevice := GetProcAddress(MEIDS_LibHandle, 'meIOResetSubdevice');
    @meIOStreamFrequencyToTicks := GetProcAddress(MEIDS_LibHandle, 'meIOStreamFrequencyToTicks');
    @meIOSetChannelOffset := GetProcAddress(MEIDS_LibHandle, 'meIOSetChannelOffset');
    @meIOSingleConfig := GetProcAddress(MEIDS_LibHandle, 'meIOSingleConfig');
    @meIOSingle := GetProcAddress(MEIDS_LibHandle, 'meIOSingle');
    @meIOSingleTimeToTicks := GetProcAddress(MEIDS_LibHandle, 'meIOSingleTimeToTicks');
    @meIOSingleTicksToTime := GetProcAddress(MEIDS_LibHandle, 'meIOSingleTicksToTime');
    @meIOStreamConfig := GetProcAddress(MEIDS_LibHandle, 'meIOStreamConfig');
    @meIOStreamRead := GetProcAddress(MEIDS_LibHandle, 'meIOStreamRead');
    @meIOStreamWrite := GetProcAddress(MEIDS_LibHandle, 'meIOStreamWrite');
    @meIOStreamStart := GetProcAddress(MEIDS_LibHandle, 'meIOStreamStart');
    @meIOStreamStop := GetProcAddress(MEIDS_LibHandle, 'meIOStreamStop');
    @meIOStreamStatus := GetProcAddress(MEIDS_LibHandle, 'meIOStreamStatus');
    @meIOStreamSetCallbacks := GetProcAddress(MEIDS_LibHandle, 'meIOStreamSetCallbacks');
    @meIOStreamTimeToTicks := GetProcAddress(MEIDS_LibHandle, 'meIOStreamTimeToTicks');
    @meQueryDescriptionDevice := GetProcAddress(MEIDS_LibHandle, 'meQueryDescriptionDevice');
    @meQueryInfoDevice := GetProcAddress(MEIDS_LibHandle, 'meQueryInfoDevice');
    @meQueryNameDevice := GetProcAddress(MEIDS_LibHandle, 'meQueryNameDevice');
    @meQueryNameDeviceDriver := GetProcAddress(MEIDS_LibHandle, 'meQueryNameDeviceDriver');
    @meQueryNumberDevices := GetProcAddress(MEIDS_LibHandle, 'meQueryNumberDevices');
    @meQueryNumberSubdevices := GetProcAddress(MEIDS_LibHandle, 'meQueryNumberSubdevices');
    @meQueryNumberChannels := GetProcAddress(MEIDS_LibHandle, 'meQueryNumberChannels');
    @meQueryNumberRanges := GetProcAddress(MEIDS_LibHandle, 'meQueryNumberRanges');
    @meQueryRangeByMinMax := GetProcAddress(MEIDS_LibHandle, 'meQueryRangeByMinMax');
    @meQueryRangeInfo := GetProcAddress(MEIDS_LibHandle, 'meQueryRangeInfo');
    @meQuerySubdeviceByType := GetProcAddress(MEIDS_LibHandle, 'meQuerySubdeviceByType');
    @meQuerySubdeviceType := GetProcAddress(MEIDS_LibHandle, 'meQuerySubdeviceType');
    @meQuerySubdeviceCaps := GetProcAddress(MEIDS_LibHandle, 'meQuerySubdeviceCaps');
    @meQuerySubdeviceCapsArgs := GetProcAddress(MEIDS_LibHandle, 'meQuerySubdeviceCapsArgs');
    @meQueryVersionLibrary := GetProcAddress(MEIDS_LibHandle, 'meQueryVersionLibrary');
    @meQueryVersionMainDriver := GetProcAddress(MEIDS_LibHandle, 'meQueryVersionMainDriver');
    @meQueryVersionDeviceDriver := GetProcAddress(MEIDS_LibHandle, 'meQueryVersionDeviceDriver');
    @meUtilityExtractValues := GetProcAddress(MEIDS_LibHandle, 'meUtilityExtractValues');
    @meUtilityDigitalToPhysical := GetProcAddress(MEIDS_LibHandle, 'meUtilityDigitalToPhysical');
    @meUtilityDigitalToPhysicalV := GetProcAddress(MEIDS_LibHandle, 'meUtilityDigitalToPhysicalV');
    @meUtilityPhysicalToDigital := GetProcAddress(MEIDS_LibHandle, 'meUtilityPhysicalToDigital');
    @meUtilityPhysicalToDigitalV := GetProcAddress(MEIDS_LibHandle, 'meUtilityPhysicalToDigitalV');
    @meUtilityPWMStart := GetProcAddress(MEIDS_LibHandle, 'meUtilityPWMStart');
    @meUtilityPWMRestart := GetProcAddress(MEIDS_LibHandle, 'meUtilityPWMRestart');
    @meUtilityPWMStop := GetProcAddress(MEIDS_LibHandle, 'meUtilityPWMStop');
    @mePropertyGetIntA := GetProcAddress(MEIDS_LibHandle, 'mePropertyGetIntA');
    @mePropertyGetIntW := GetProcAddress(MEIDS_LibHandle, 'mePropertyGetIntW');
    @mePropertyGetDoubleA := GetProcAddress(MEIDS_LibHandle, 'mePropertyGetDoubleA');
    @mePropertyGetDoubleW := GetProcAddress(MEIDS_LibHandle, 'mePropertyGetDoubleW');
    @mePropertyGetStringA := GetProcAddress(MEIDS_LibHandle, 'mePropertyGetStringA');
    @mePropertyGetStringW := GetProcAddress(MEIDS_LibHandle, 'mePropertyGetStringW');
    @mePropertySetIntA := GetProcAddress(MEIDS_LibHandle, 'mePropertySetIntA');
    @mePropertySetIntW := GetProcAddress(MEIDS_LibHandle, 'mePropertySetIntW');
    @mePropertySetDoubleA := GetProcAddress(MEIDS_LibHandle, 'mePropertySetDoubleA');
    @mePropertySetDoubleW := GetProcAddress(MEIDS_LibHandle, 'mePropertySetDoubleW');
    @mePropertySetStringA := GetProcAddress(MEIDS_LibHandle, 'mePropertySetStringA');
    @mePropertySetStringW := GetProcAddress(MEIDS_LibHandle, 'mePropertySetStringW');
  end;

finalization
  if MEIDS_LibHandle <> 0 then FreeLibrary(MEIDS_LibHandle);


end.

