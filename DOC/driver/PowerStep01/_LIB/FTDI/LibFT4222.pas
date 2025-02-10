// *************************************************************************
// ** Converted with C to Pascal Converter 2.0
// ** @cFile LibFT4222.h  date 2015-06-09
// ** Datum zadnje spremembe: 7.11.2016

// Revision History:
// 1.2 - initial original .h version  @cFile LibFT4222.h  date 2015-06-09
// 1.3 - LibFT4222.h  date 2016-08-08, added: - FT4222_I2CSlave_SetClockStretch
//                                            - FT4222_I2CSlave_SetRespWord
// **************************************************************************)


unit LibFT4222;

{$WARN SYMBOL_DEPRECATED OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}

interface


uses
   Windows, Messages, SysUtils, Classes, ftd2xx;

const
  FT4222_EVENT_RXCHAR        = 8;    {$EXTERNALSYM FT4222_EVENT_RXCHAR}
  FT4222_SPI_SLAVE_SYNC_WORD = $5A;  {$EXTERNALSYM FT4222_SPI_SLAVE_SYNC_WORD}
  SPI_MASTER_TRANSFER        = $80;  {$EXTERNALSYM SPI_MASTER_TRANSFER}
  SPI_SLAVE_TRANSFER         = $81;  {$EXTERNALSYM SPI_SLAVE_TRANSFER}
  SPI_SHORT_MASTER_TRANSFER  = $82;  {$EXTERNALSYM SPI_SHORT_MASTER_TRANSFER}
  SPI_SHORT_SLAVE_TRANSFER   = $83;  {$EXTERNALSYM SPI_SHORT_SLAVE_TRANSFER}
  SPI_SHART_SLAVE_TRANSFER   = $83;  {$EXTERNALSYM SPI_SHART_SLAVE_TRANSFER}      // Backwards compatibility for typo in earlier version
  SPI_ACK                    = $84;  {$EXTERNALSYM SPI_ACK}

//  FT4222_DEVICE STATUS
  FT4222_OK                                   =  0;
  FT4222_INVALID_HANDLE                       =  1;
  FT4222_DEVICE_NOT_FOUND                     =  2;
  FT4222_DEVICE_NOT_OPENED                    =  3;
  FT4222_IO_ERROR                             =  4;
  FT4222_INSUFFICIENT_RESOURCES               =  5;
  FT4222_INVALID_PARAMETER                    =  6;
  FT4222_INVALID_BAUD_RATE                    =  7;
  FT4222_DEVICE_NOT_OPENED_FOR_ERASE          =  8;
  FT4222_DEVICE_NOT_OPENED_FOR_WRITE          =  9;
  FT4222_FAILED_TO_WRITE_DEVICE               = 10;
  FT4222_EEPROM_READ_FAILED                   = 11;
  FT4222_EEPROM_WRITE_FAILED                  = 12;
  FT4222_EEPROM_ERASE_FAILED                  = 13;
  FT4222_EEPROM_NOT_PRESENT                   = 14;
  FT4222_EEPROM_NOT_PROGRAMMED                = 15;
  FT4222_INVALID_ARGS                         = 16;
  FT4222_NOT_SUPPORTED                        = 17;
  FT4222_OTHER_ERROR                          = 18;
  FT4222_DEVICE_LIST_NOT_READY                = 19;
  FT4222_DEVICE_NOT_SUPPORTED                 = 1000;        // FT_STATUS extending message
  FT4222_CLK_NOT_SUPPORTED                    = 22;          // spi master do not support 80MHz/CLK_2
  FT4222_VENDER_CMD_NOT_SUPPORTED             = 23;
  FT4222_IS_NOT_SPI_MODE                      = 24;
  FT4222_IS_NOT_I2C_MODE                      = 25;
  FT4222_IS_NOT_SPI_SINGLE_MODE               = 26;
  FT4222_IS_NOT_SPI_MULTI_MODE                = 27;
  FT4222_WRONG_I2C_ADDR                       = 28;
  FT4222_INVAILD_FUNCTION                     = 29;
  FT4222_INVALID_POINTER                      = 30;
  FT4222_EXCEEDED_MAX_TRANSFER_SIZE           = 31;
  FT4222_FAILED_TO_READ_DEVICE                = 32;
  FT4222_I2C_NOT_SUPPORTED_IN_THIS_MODE       = 33;
  FT4222_GPIO_NOT_SUPPORTED_IN_THIS_MODE      = 34;
  FT4222_GPIO_EXCEEDED_MAX_PORTNUM            = 35;
  FT4222_GPIO_WRITE_NOT_SUPPORTED             = 36;
  FT4222_GPIO_PULLUP_INVALID_IN_INPUTMODE     = 37;
  FT4222_GPIO_PULLDOWN_INVALID_IN_INPUTMODE   = 38;
  FT4222_GPIO_OPENDRAIN_INVALID_IN_OUTPUTMODE = 39;
  FT4222_INTERRUPT_NOT_SUPPORTED              = 40;
  FT4222_GPIO_INPUT_NOT_SUPPORTED             = 41;
  FT4222_EVENT_NOT_SUPPORTED                  = 42;
  FT4222_FUN_NOT_SUPPORT                      = 43;

//  FT4222_ClockRate
  SYS_CLK_60 = 0;
  SYS_CLK_24 = 1;
  SYS_CLK_48 = 2;
  SYS_CLK_80 = 3;

//  FT4222_FUNCTION
  FT4222_I2C_MASTER = 1;
  FT4222_I2C_SLAVE  = 2;
  FT4222_SPI_MASTER = 3;
  FT4222_SPI_SLAVE  = 4;

//  FT4222_SPIMode
  SPI_IO_NONE   = 0;
  SPI_IO_SINGLE = 1;
  SPI_IO_DUAL   = 2;
  SPI_IO_QUAD   = 4;

//  FT4222_SPIClock
  CLK_NONE   =  0;
  CLK_DIV_2   = 1;      // 1/2   System Clock
  CLK_DIV_4   = 2;      // 1/4   System Clock
  CLK_DIV_8   = 3;      // 1/8   System Clock
  CLK_DIV_16  = 4;      // 1/16  System Clock
  CLK_DIV_32  = 5;      // 1/32  System Clock
  CLK_DIV_64  = 6;      // 1/64  System Clock
  CLK_DIV_128 = 7;      // 1/128 System Clock
  CLK_DIV_256 = 8;      // 1/256 System Clock
  CLK_DIV_512 = 9;      // 1/512 System Clock

//  FT4222_SPICPOL
  CLK_IDLE_LOW  = 0;
  CLK_IDLE_HIGH = 1;

//   FT4222_SPICPHA
  CLK_LEADING  = 0;
  CLK_TRAILING = 1;

//  SPI_DrivingStrength
  DS_4MA  = 0;
  DS_8MA  = 1;
  DS_12MA = 2;
  DS_16MA = 3;

//  GPIO_Port
  GPIO_PORT0 = 0;
  GPIO_PORT1 = 1;
  GPIO_PORT2 = 2;
  GPIO_PORT3 = 3;

//  GPIO_Dir
  GPIO_OUTPUT = 0;
  GPIO_INPUT  = 1;

//  GPIO_Trigger
  GPIO_TRIGGER_RISING     = $01;
  GPIO_TRIGGER_FALLING    = $02;
  GPIO_TRIGGER_LEVEL_HIGH = $04;
  GPIO_TRIGGER_LEVEL_LOW  = $08;

//  GPIOt_Output
  GPIO_OUTPUT_LOW  = 0;
  GPIO_OUTPUT_HIGH = 1;

//  I2C_MasterFlag
  NONE           = $80;
  START          = $02;
  Repeated_START = $03;      // Repeated_START will not send master code in HS mode
  STOP           = $04;
  START_AND_STOP = $06;      // START condition followed by SEND and STOP condition

//  SPI_SlaveProtocol
  SPI_SLAVE_WITH_PROTOCOL = 0;
  SPI_SLAVE_NO_PROTOCOL   = 1;
  SPI_SLAVE_NO_ACK        = 2;

type
  FT4222_STATUS       = FT_STATUS;    // iz d2xx.dll
  FT4222_ClockRate    = ULONG;
  FT4222_FUNCTION     = ULONG;
  FT4222_SPIMode      = ULONG;
  FT4222_SPIClock     = ULONG;
  FT4222_SPICPOL      = ULONG;
  FT4222_SPICPHA      = ULONG;
  SPI_DrivingStrength = ULONG;
  GPIO_Port           = ULONG;
  GPIO_Dir            = ULONG;
  GPIO_Trigger        = ULONG;
  GPIO_Tigger         =  GPIO_Trigger; {$EXTERNALSYM GPIO_Tigger} // Backwards compatibility for typo in earlier version
  GPIOt_Output        = ULONG;
  I2C_MasterFlag      = ULONG;
  SPI_SlaveProtocol   = ULONG;

  FT4222_Version = record
    chipVersion: DWORD;
    dllVersion : DWORD;
  end;

  GPIO_DirArr =  array[0..3] of GPIO_Dir;
  GPIO_State= BOOL;

{$HPPEMIT '#pragma pack(push, 1)'}
  SPI_Slave_Header = packed record
    SyncWord: Byte;
    Cmd     : Byte;
    Sn      : Byte;
    Size    : Word;
  end;
{$HPPEMIT '#pragma pack(pop)'}

// FT4222 General Functions
  function FT4222_UnInitialize             ( ftHandle         : FT_HANDLE               ): FT4222_STATUS; stdcall;
  function FT4222_SetClock                 ( ftHandle         : FT_HANDLE;
                                             Clk              : FT4222_ClockRate        ): FT4222_STATUS; stdcall;
  function FT4222_GetClock                 ( ftHandle         : FT_HANDLE;
                                         var Clk              : FT4222_ClockRate        ): FT4222_STATUS; stdcall;
  function FT4222_SetWakeUpInterrupt       ( ftHandle         : FT_HANDLE;
                                             Enable           : LongBool                ): FT4222_STATUS; stdcall;
  function FT4222_SetInterruptTrigger      ( ftHandle         : FT_HANDLE;
                                             Trigger          : GPIO_Trigger            ): FT4222_STATUS; stdcall;
  function FT4222_SetSuspendOut            ( ftHandle         : FT_HANDLE;
                                             Enable           : LongBool                ): FT4222_STATUS; stdcall;
  function FT4222_GetMaxTransferSize       ( ftHandle         : FT_HANDLE;
                                         var pMaxSize         : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_SetEventNotification     ( ftHandle         : FT_HANDLE;
                                             Mask             : DWORD;
                                             Param            : PVOID                   ): FT4222_STATUS; stdcall;
  function FT4222_GetVersion               ( ftHandle         : FT_HANDLE;
                                         var pVersion         : FT4222_Version          ): FT4222_STATUS; stdcall;
// FT4222 SPI Functions
  function FT4222_SPIMaster_Init           ( ftHandle         : FT_HANDLE;
                                             IoLine           : FT4222_SPIMode;
                                             Clock            : FT4222_SPIClock;
                                             Cpol             : FT4222_SPICPOL;
                                             Cpha             : FT4222_SPICPHA;
                                             SsoMap           : Byte                    ): FT4222_STATUS; stdcall;
  function FT4222_SPIMaster_SetLines       ( ftHandle         : FT_HANDLE;
                                             SpiMode          : FT4222_SPIMode          ): FT4222_STATUS; stdcall;
  function FT4222_SPIMaster_SingleRead     ( ftHandle         : FT_HANDLE;
                                             Buffer           : Pointer;          // var Buffer   : Byte;
                                             BufferSize       : Word;
                                         var SizeOfRead       : Word;
                                             IsEndTransaction : LongBool                ): FT4222_STATUS; stdcall;
  function FT4222_SPIMaster_SingleWrite    ( ftHandle         : FT_HANDLE;
                                             Buffer           : Pointer;          // var Buffer    : Byte;
                                             BufferSize       : Word;
                                         var SizeTransferred  : Word;
                                             IsEndTransaction : LongBool                ): FT4222_STATUS; stdcall;

  function FT4222_SPIMaster_SingleReadWrite( ftHandle         : FT_HANDLE;
                                             ReadBuffer       : Pointer;          //  var ReadBuffer : Byte;
                                             WriteBuffer      : Pointer;          //  var WriteBuffer: Byte;
                                             BufferSize       : Word;
                                         var SizeTransferred  : Word;
                                             IsEndTransaction : LongBool                ): FT4222_STATUS; stdcall;
  function FT4222_SPIMaster_MultiReadWrite ( ftHandle         : FT_HANDLE;
                                             ReadBuffer       : Pointer;          //  var ReadBuffer : Byte;
                                             WriteBuffer      : Pointer;          //  var WriteBuffer: Byte;
                                             SingleWriteBytes : Byte;
                                             MultiWriteBytes  : Word;
                                             MultiReadBytes   : Word;
                                         var SizeOfRead       : LongWord                ): FT4222_STATUS; stdcall;

  function FT4222_SPISlave_Init            ( ftHandle         : FT_HANDLE               ): FT4222_STATUS; stdcall;
  function FT4222_SPISlave_InitEx          ( ftHandle         : FT_HANDLE;
                                             ProtocolOpt      : SPI_SlaveProtocol       ): FT4222_STATUS; stdcall;
  function FT4222_SPISlave_GetRxStatus     ( ftHandle         : FT_HANDLE;
                                         var pRxSize          : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_SPISlave_Read            ( ftHandle         : FT_HANDLE;
                                             Buffer           : Pointer;          //   var Buffer   : Byte;
                                             BufferSize       : Word;
                                         var SizeOfRead       : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_SPISlave_Write           ( ftHandle         : FT_HANDLE;
                                             Buffer           : Pointer;          //   var Buffer   : Byte;
                                             BufferSize       : Word;
                                         var SizeTransferred  : Word                    ): FT4222_STATUS; stdcall;

  function FT4222_SPI_Reset                ( ftHandle         : FT_HANDLE               ): FT4222_STATUS; stdcall;
  function FT4222_SPI_ResetTransaction     ( ftHandle         : FT_HANDLE;
                                             SpiIdx           : Byte                    ): FT4222_STATUS; stdcall;
  function FT4222_SPI_SetDrivingStrength   ( ftHandle         : FT_HANDLE;
                                             ClkStrength      : SPI_DrivingStrength;
                                             IoStrength       : SPI_DrivingStrength;
                                             SsoStregth       : SPI_DrivingStrength     ): FT4222_STATUS; stdcall;
  // FT4222 I2C Functions
  function FT4222_I2CMaster_Init           ( ftHandle         : FT_HANDLE;
                                             kbps             : LongWord                ): FT4222_STATUS; stdcall;
  function FT4222_I2CMaster_Read           ( ftHandle         : FT_HANDLE;
                                             DeviceAddress    : Word;
                                             Buffer           : Pointer;          //   var Buffer   : Byte;
                                             BufferSize       : Word;
                                         var SizeTransferred  : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_I2CMaster_Write          ( ftHandle         : FT_HANDLE;
                                             DeviceAddress    : Word;
                                             Buffer           : Pointer;          //   var Buffer   : Byte;
                                             BufferSize       : Word;
                                         var SizeTransferred  : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_I2CMaster_ReadEx         ( ftHandle         : FT_HANDLE;
                                             DeviceAddress    : Word;
                                             Flag             : Byte;
                                             Buffer           : Pointer;          //   var Buffer   : Byte;
                                             BufferSize       : Word;
                                         var SizeTransferred  : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_I2CMaster_WriteEx        ( ftHandle         : FT_HANDLE;
                                             DeviceAddress    : Word;
                                             Flag             : Byte;
                                             Buffer           : Pointer;          //   var Buffer   : Byte;
                                             BufferSize       : Word;
                                         var SizeTransferred  : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_I2CMaster_Reset          ( ftHandle         : FT_HANDLE               ): FT4222_STATUS; stdcall;
  function FT4222_I2CMaster_GetStatus      ( ftHandle         : FT_HANDLE;
                                          var ControllerStatus: Byte                    ): FT4222_STATUS; stdcall;
  function FT4222_I2CSlave_Init            ( ftHandle         : FT_HANDLE               ): FT4222_STATUS; stdcall;
  function FT4222_I2CSlave_Reset           ( ftHandle         : FT_HANDLE               ): FT4222_STATUS; stdcall;
  function FT4222_I2CSlave_GetAddress      ( ftHandle         : FT_HANDLE;
                                         var Addr             : Byte                    ): FT4222_STATUS; stdcall;
  function FT4222_I2CSlave_SetAddress      ( ftHandle         : FT_HANDLE;
                                             Addr: Byte                                 ): FT4222_STATUS; stdcall;
  function FT4222_I2CSlave_GetRxStatus     ( ftHandle         : FT_HANDLE;
                                         var pRxSize          : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_I2CSlave_Read            ( ftHandle         : FT_HANDLE;
                                             Buffer           : Pointer;          //   var Buffer   : Byte;
                                             BufferSize       : Word;
                                         var SizeTransferred  : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_I2CSlave_Write           ( ftHandle         : FT_HANDLE;
                                             Buffer           : Pointer;          //   var Buffer   : Byte;
                                             BufferSize       : Word;
                                         var SizeTransferred  : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_I2CSlave_SetClockStretch ( ftHandle         : FT_HANDLE;
                                             Enable           : Boolean                 ): FT4222_STATUS; stdcall;
  function FT4222_I2CSlave_SetRespWord     ( ftHandle         : FT_HANDLE;
                                             ResponseWord     : Word                    ): FT4222_STATUS; stdcall;

  // FT4222 GPIO Functions
  function FT4222_GPIO_Init                ( ftHandle         : FT_HANDLE;
                                             GpioDir          : GPIO_DirArr             ): FT4222_STATUS; stdcall; // array[0..3] of GPIO_Dir
  function FT4222_GPIO_Read                ( ftHandle         : FT_HANDLE;
                                             PortNum          : GPIO_Port;
                                         var Value            : GPIO_State              ): FT4222_STATUS; stdcall;  // Boolean ne dela
  function FT4222_GPIO_Write_Orig          ( ftHandle         : FT_HANDLE;
                                             PortNum          : GPIO_Port;
                                             BValue           : LongBool                 ): FT4222_STATUS; stdcall;
  function FT4222_GPIO_SetInputTrigger     ( ftHandle         : FT_HANDLE;
                                             PortNum          : GPIO_Port;
                                             Trigger          : GPIO_Trigger            ): FT4222_STATUS; stdcall;
  function FT4222_GPIO_GetTriggerStatus    ( ftHandle         : FT_HANDLE;
                                             PortNum          : GPIO_Port;
                                         var QueueSize        : Word                    ): FT4222_STATUS; stdcall;
  function FT4222_GPIO_ReadTriggerQueue    ( ftHandle         : FT_HANDLE;
                                             PortNum          : GPIO_Port;
                                         var Events           : GPIO_Trigger;
                                             ReadSize         : Word;
                                         var SizeofRead       : Word                    ): FT4222_STATUS; stdcall;

/// RLS
  function FT4222_GPIO_Write               ( ftHandle        : FT_HANDLE;
                                             PortNum         : GPIO_Port;
                                             BValue          : Boolean                 ): FT4222_STATUS;


implementation
  const FT_DLL = 'LibFT4222.dll';

  function FT4222_UnInitialize;              external FT_DLL name 'FT4222_UnInitialize';
  function FT4222_SetClock;                  external FT_DLL name 'FT4222_SetClock';
  function FT4222_GetClock;                  external FT_DLL name 'FT4222_GetClock';
  function FT4222_SetWakeUpInterrupt;        external FT_DLL name 'FT4222_SetWakeUpInterrupt';
  function FT4222_SetInterruptTrigger;       external FT_DLL name 'FT4222_SetInterruptTrigger';
  function FT4222_SetSuspendOut;             external FT_DLL name 'FT4222_SetSuspendOut';
  function FT4222_GetMaxTransferSize;        external FT_DLL name 'FT4222_GetMaxTransferSize';
  function FT4222_SetEventNotification;      external FT_DLL name 'FT4222_SetEventNotification';
  function FT4222_GetVersion;                external FT_DLL name 'FT4222_GetVersion';
  function FT4222_SPIMaster_Init;            external FT_DLL name 'FT4222_SPIMaster_Init';
  function FT4222_SPIMaster_SetLines;        external FT_DLL name 'FT4222_SPIMaster_SetLines';
  function FT4222_SPIMaster_SingleRead;      external FT_DLL name 'FT4222_SPIMaster_SingleRead';
  function FT4222_SPIMaster_SingleWrite;     external FT_DLL name 'FT4222_SPIMaster_SingleWrite';
  function FT4222_SPIMaster_SingleReadWrite; external FT_DLL name 'FT4222_SPIMaster_SingleReadWrite';
  function FT4222_SPIMaster_MultiReadWrite;  external FT_DLL name 'FT4222_SPIMaster_MultiReadWrite';
  function FT4222_SPISlave_Init;             external FT_DLL name 'FT4222_SPISlave_Init';
  function FT4222_SPISlave_InitEx;           external FT_DLL name 'FT4222_SPISlave_InitEx';
  function FT4222_SPISlave_GetRxStatus;      external FT_DLL name 'FT4222_SPISlave_GetRxStatus';
  function FT4222_SPISlave_Read;             external FT_DLL name 'FT4222_SPISlave_Read';
  function FT4222_SPISlave_Write;            external FT_DLL name 'FT4222_SPISlave_Write';
  function FT4222_SPI_Reset;                 external FT_DLL name 'FT4222_SPI_Reset';
  function FT4222_SPI_ResetTransaction;      external FT_DLL name 'FT4222_SPI_ResetTransaction';
  function FT4222_SPI_SetDrivingStrength;    external FT_DLL name 'FT4222_SPI_SetDrivingStrength';
  function FT4222_I2CMaster_Init;            external FT_DLL name 'FT4222_I2CMaster_Init';
  function FT4222_I2CMaster_Read;            external FT_DLL name 'FT4222_I2CMaster_Read';
  function FT4222_I2CMaster_Write;           external FT_DLL name 'FT4222_I2CMaster_Write';
  function FT4222_I2CMaster_ReadEx;          external FT_DLL name 'FT4222_I2CMaster_ReadEx';
  function FT4222_I2CMaster_WriteEx;         external FT_DLL name 'FT4222_I2CMaster_WriteEx';
  function FT4222_I2CMaster_Reset;           external FT_DLL name 'FT4222_I2CMaster_Reset';
  function FT4222_I2CMaster_GetStatus;       external FT_DLL name 'FT4222_I2CMaster_GetStatus';
  function FT4222_I2CSlave_Init;             external FT_DLL name 'FT4222_I2CSlave_Init';
  function FT4222_I2CSlave_Reset;            external FT_DLL name 'FT4222_I2CSlave_Reset';
  function FT4222_I2CSlave_GetAddress;       external FT_DLL name 'FT4222_I2CSlave_GetAddress';
  function FT4222_I2CSlave_SetAddress;       external FT_DLL name 'FT4222_I2CSlave_SetAddress';
  function FT4222_I2CSlave_GetRxStatus;      external FT_DLL name 'FT4222_I2CSlave_GetRxStatus';
  function FT4222_I2CSlave_Read;             external FT_DLL name 'FT4222_I2CSlave_Read';
  function FT4222_I2CSlave_Write;            external FT_DLL name 'FT4222_I2CSlave_Write';
  function FT4222_I2CSlave_SetClockStretch;  external FT_DLL name 'FT4222_I2CSlave_SetClockStretch';
  function FT4222_I2CSlave_SetRespWord;      external FT_DLL name 'FT4222_I2CSlave_SetRespWord';
  function FT4222_GPIO_Init;                 external FT_DLL name 'FT4222_GPIO_Init';
  function FT4222_GPIO_Read;                 external FT_DLL name 'FT4222_GPIO_Read';
  function FT4222_GPIO_Write_Orig;           external FT_DLL name 'FT4222_GPIO_Write';
  function FT4222_GPIO_SetInputTrigger;      external FT_DLL name 'FT4222_GPIO_SetInputTrigger';
  function FT4222_GPIO_GetTriggerStatus;     external FT_DLL name 'FT4222_GPIO_GetTriggerStatus';
  function FT4222_GPIO_ReadTriggerQueue;     external FT_DLL name 'FT4222_GPIO_ReadTriggerQueue';

// I2C Master Controller Status
//   bit 0 = controller busy: all other status bits invalid
//   bit 1 = error condition
//   bit 2 = slave address was not acknowledged during last operation
//   bit 3 = data not acknowledged during last operation
//   bit 4 = arbitration lost during last operation
//   bit 5 = controller idle
//   bit 6 = bus busy

  function I2CM_CONTROLLER_BUSY ( Status: Integer): Boolean; begin Result := (Status and $01) <> 0; end;
  function I2CM_DATA_NACK       ( Status: Integer): Boolean; begin Result := (Status and $0A) <> 0; end;
  function I2CM_ADDRESS_NACK    ( Status: Integer): Boolean; begin Result := (Status and $06) <> 0; end;
  function I2CM_ARB_LOST        ( Status: Integer): Boolean; begin Result := (Status and $12) <> 0; end;
  function I2CM_IDLE            ( Status: Integer): Boolean; begin Result := (Status and $20) <> 0; end;
  function I2CM_BUS_BUSY        ( Status: Integer): Boolean; begin Result := (Status and $40) <> 0; end;

  function FT4222_GPIO_Write(ftHandle: FT_HANDLE; PortNum: GPIO_Port; BValue: Boolean ): FT4222_STATUS;          // Originalno mi javi memory error
  var
    V: LongBool;
  begin
    V := BValue;
    Result := FT4222_GPIO_Write_Orig(ftHandle, PortNum, V);
  end;

end.
