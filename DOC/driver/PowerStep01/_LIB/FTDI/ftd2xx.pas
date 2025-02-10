// Pripravil Gregor Dolsak
// Predloga je bila narejena z CToPas 2.0 programom za konvertiranje
// Odstranil sem podporo za druge operacijske sisteme
// Zadnja sprememba je bila narejena 1.6.2016

unit ftd2xx;
{$WARN SYMBOL_DEPRECATED OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}

interface

uses
  Windows, WinTypes, Messages, SysUtils, Vcl.Dialogs, Classes, System.UITypes;

type
  LPWORD = ^WORD;
  LPLONG = ^LongInt;
  PDWORD = ^DWORD;

  FT_HANDLE = PVOID;                   {$EXTERNALSYM FT_HANDLE}
  FT_STATUS = ULONG;                   {$EXTERNALSYM FT_STATUS}
  FT_DEVICE = ULONG;

  FT_DEVICE_LIST_INFO_NODE = record
    Flags         : DWord;
    DeviceType    : Dword;
    ID            : DWord;
    LocID         : DWord;
    SerialNumber  : array [0..15] of AnsiChar;
    Description   : array [0..63] of AnsiChar;
    DeviceHandle  : PDWORD;
  end;
  TFT_DEVICE_LIST_INFO_NODE = FT_DEVICE_LIST_INFO_NODE;  {$EXTERNALSYM TFT_DEVICE_LIST_INFO_NODE}

  TFT_DEVICE_DATA = record                                             // pripravil grgr
    Buffer_In  : Array[0..$FFFF] of Byte;   // buffer sprejetih podatkov
    Buffer_Out : Array[0..$FFFF] of Byte;   // buffer oddanih podatkov
    Q_Bytes    : Cardinal;                  // stevilo cakajocih podatkov za prebrat
    TxQ_Bytes  : Cardinal;                  // stevilo cakajocih podatkov za poslat
    OutIndex   : Cardinal;
  end;

// structure to hold program data for FT_EE_Program, FT_EE_ProgramEx, FT_EE_Read and FT_EE_ReadEx functions
  T_PROGRAM_DATA = record
    Signature1        : DWord;      // Header - must be 0x0000000
    Signature2        : DWord;      // Header - must be 0xffffffff
    Version           : DWord;      // Header - FT_PROGRAM_DATA version
                                    // 0 = original (FT232B)
                                    // 1 = FT2232 extensions
                                    // 2 = FT232R extensions
                                    // 3 = FT2232H extensions
                                    // 4 = FT4232H extensions
                                    // 5 = FT232H extensions
    VendorID          : Word;       // 0x0403
    ProductID         : Word;       // 0x6001
    Manufacturer      : PAnsiChar;  // "FTDI"
    ManufacturerID    : PAnsiChar;  // "FT"
    Description       : PAnsiChar;  // "USB HS Serial Converter"
    SerialNumber      : PAnsiChar;  // "FT000001" if fixed, or NULL
    MaxPower          : Word;       // 0 < MaxPower <= 500
    PnP               : Word;       // 0 = disabled, 1 = enabled
    SelfPowered       : Word;       // 0 = bus powered, 1 = self powered
    RemoteWakeup      : Word;       // 0 = not capable, 1 = capable
  // Rev4 (FT232B) extensions
    Rev4              : Byte;       // non-zero if Rev4 chip, zero otherwise
    IsoIn             : Byte;       // non-zero if in endpoint is isochronous
    IsoOut            : Byte;       // non-zero if out endpoint is isochronous
    PullDownEnable    : Byte;       // non-zero if pull down enabled
    SerNumEnable      : Byte;       // non-zero if serial number to be used
    USBVersionEnable  : Byte;       // non-zero if chip uses USBVersion
    USBVersion        : Word;       // BCD (0x0200 => USB2)
  // Rev 5 (FT2232) extensions
    Rev5              : Byte;       // non-zero if Rev5 chip, zero otherwise
    IsoInA            : Byte;       // non-zero if in endpoint is isochronous
    IsoInB            : Byte;       // non-zero if in endpoint is isochronous
    IsoOutA           : Byte;       // non-zero if out endpoint is isochronous
    IsoOutB           : Byte;       // non-zero if out endpoint is isochronous
    PullDownEnable5   : Byte;       // non-zero if pull down enabled
    SerNumEnable5     : Byte;       // non-zero if serial number to be used
    USBVersionEnable5 : Byte;       // non-zero if chip uses USBVersion
    USBVersion5       : Word;       // BCD (0x0200 => USB2)
    AIsHighCurrent    : Byte;       // non-zero if interface is high current
    BIsHighCurrent    : Byte;       // non-zero if interface is high current
    IFAIsFifo         : Byte;       // non-zero if interface is 245 FIFO
    IFAIsFifoTar      : Byte;       // non-zero if interface is 245 FIFO CPU target
    IFAIsFastSer      : Byte;       // non-zero if interface is Fast serial
    AIsVCP            : Byte;       // non-zero if interface is to use VCP drivers
    IFBIsFifo         : Byte;       // non-zero if interface is 245 FIFO
    IFBIsFifoTar      : Byte;       // non-zero if interface is 245 FIFO CPU target
    IFBIsFastSer      : Byte;       // non-zero if interface is Fast serial
    BIsVCP            : Byte;       // non-zero if interface is to use VCP drivers
  // Rev 6 (FT232R) extensions
    UseExtOsc         : Byte;       // Use External Oscillator
    HighDriveIOs      : Byte;       // High Drive I/Os
    EndpointSize      : Byte;       // Endpoint size
    PullDownEnableR   : Byte;       // non-zero if pull down enabled
    SerNumEnableR     : Byte;       // non-zero if serial number to be used
    InvertTXD         : Byte;       // non-zero if invert TXD
    InvertRXD         : Byte;       // non-zero if invert RXD
    InvertRTS         : Byte;       // non-zero if invert RTS
    InvertCTS         : Byte;       // non-zero if invert CTS
    InvertDTR         : Byte;       // non-zero if invert DTR
    InvertDSR         : Byte;       // non-zero if invert DSR
    InvertDCD         : Byte;       // non-zero if invert DCD
    InvertRI          : Byte;       // non-zero if invert RI
    Cbus0             : Byte;       // Cbus Mux control
    Cbus1             : Byte;       // Cbus Mux control
    Cbus2             : Byte;       // Cbus Mux control
    Cbus3             : Byte;       // Cbus Mux control
    Cbus4             : Byte;       // Cbus Mux control
    RIsVCP            : Byte;       // non-zero if using D2XX driver
  // Rev 7 (FT2232H) Extensions
    PullDownEnable7   : Byte;       // non-zero if pull down enabled
    SerNumEnable7     : Byte;       // non-zero if serial number to be used
    ALSlowSlew        : Byte;       // non-zero if AL pins have slow slew
    ALSchmittInput    : Byte;       // non-zero if AL pins are Schmitt input
    ALDriveCurrent    : Byte;       // valid values are 4mA, 8mA, 12mA, 16mA
    AHSlowSlew        : Byte;       // non-zero if AH pins have slow slew
    AHSchmittInput    : Byte;       // non-zero if AH pins are Schmitt input
    AHDriveCurrent    : Byte;       // valid values are 4mA, 8mA, 12mA, 16mA
    BLSlowSlew        : Byte;       // non-zero if BL pins have slow slew
    BLSchmittInput    : Byte;       // non-zero if BL pins are Schmitt input
    BLDriveCurrent    : Byte;       // valid values are 4mA, 8mA, 12mA, 16mA
    BHSlowSlew        : Byte;       // non-zero if BH pins have slow slew
    BHSchmittInput    : Byte;       // non-zero if BH pins are Schmitt input
    BHDriveCurrent    : Byte;       // valid values are 4mA, 8mA, 12mA, 16mA
    IFAIsFifo7        : Byte;       // non-zero if interface is 245 FIFO
    IFAIsFifoTar7     : Byte;       // non-zero if interface is 245 FIFO CPU target
    IFAIsFastSer7     : Byte;       // non-zero if interface is Fast serial
    AIsVCP7           : Byte;       // non-zero if interface is to use VCP drivers
    IFBIsFifo7        : Byte;       // non-zero if interface is 245 FIFO
    IFBIsFifoTar7     : Byte;       // non-zero if interface is 245 FIFO CPU target
    IFBIsFastSer7     : Byte;       // non-zero if interface is Fast serial
    BIsVCP7           : Byte;       // non-zero if interface is to use VCP drivers
    PowerSaveEnable   : Byte;       // non-zero if using BCBUS7 to save power for self-powered designs
  // Rev 8 (FT4232H) Extensions
    PullDownEnable8    : Byte;      // non-zero if pull down enabled
    SerNumEnable8      : Byte;      // non-zero if serial number to be used
    ASlowSlew          : Byte;      // non-zero if AL pins have slow slew
    ASchmittInput      : Byte;      // non-zero if AL pins are Schmitt input
    ADriveCurrent      : Byte;      // valid values are 4mA, 8mA, 12mA, 16mA
    BSlowSlew          : Byte;      // non-zero if AH pins have slow slew
    BSchmittInput      : Byte;      // non-zero if AH pins are Schmitt input
    BDriveCurrent      : Byte;      // valid values are 4mA, 8mA, 12mA, 16mA
    CSlowSlew          : Byte;      // non-zero if BL pins have slow slew
    CSchmittInput      : Byte;      // non-zero if BL pins are Schmitt input
    CDriveCurrent      : Byte;      // valid values are 4mA, 8mA, 12mA, 16mA
    DSlowSlew          : Byte;      // non-zero if BH pins have slow slew
    DSchmittInput      : Byte;      // non-zero if BH pins are Schmitt input
    DDriveCurrent      : Byte;      // valid values are 4mA, 8mA, 12mA, 16mA
    ARIIsTXDEN         : Byte;      // non-zero if port A uses RI as RS485 TXDEN
    BRIIsTXDEN         : Byte;      // non-zero if port B uses RI as RS485 TXDEN
    CRIIsTXDEN         : Byte;      // non-zero if port C uses RI as RS485 TXDEN
    DRIIsTXDEN         : Byte;      // non-zero if port D uses RI as RS485 TXDEN
    AIsVCP8            : Byte;      // non-zero if interface is to use VCP drivers
    BIsVCP8            : Byte;      // non-zero if interface is to use VCP drivers
    CIsVCP8            : Byte;      // non-zero if interface is to use VCP drivers
    DIsVCP8            : Byte;      // non-zero if interface is to use VCP drivers
  // Rev 9 (FT232H) Extensions
    PullDownEnableH    : Byte;      // non-zero if pull down enabled
    SerNumEnableH      : Byte;      // non-zero if serial number to be used
    ACSlowSlewH        : Byte;      // non-zero if AC pins have slow slew
    ACSchmittInputH    : Byte;      // non-zero if AC pins are Schmitt input
    ACDriveCurrentH    : Byte;      // valid values are 4mA, 8mA, 12mA, 16mA
    ADSlowSlewH        : Byte;      // non-zero if AD pins have slow slew
    ADSchmittInputH    : Byte;      // non-zero if AD pins are Schmitt input
    ADDriveCurrentH    : Byte;      // valid values are 4mA, 8mA, 12mA, 16mA
    Cbus0H             : Byte;      // Cbus Mux control  Cbus1H: Byte;       // Cbus Mux control
    Cbus2H             : Byte;      // Cbus Mux control  Cbus3H: Byte;       // Cbus Mux control
    Cbus4H             : Byte;      // Cbus Mux control  Cbus5H: Byte;       // Cbus Mux control
    Cbus6H             : Byte;      // Cbus Mux control  Cbus7H: Byte;       // Cbus Mux control
    Cbus8H             : Byte;      // Cbus Mux control  Cbus9H: Byte;       // Cbus Mux control
    IsFifoH            : Byte;      // non-zero if interface is 245 FIFO
    IsFifoTarH         : Byte;      // non-zero if interface is 245 FIFO CPU target
    IsFastSerH         : Byte;      // non-zero if interface is Fast serial
    IsFT1248H          : Byte;      // non-zero if interface is FT1248
    FT1248CpolH        : Byte;      // FT1248 clock polarity - clock idle high (1) or clock idle low (0)
    FT1248LsbH         : Byte;      // FT1248 data is LSB (1) or MSB (0)
    FT1248FlowControlH : Byte;      // FT1248 flow control enable
    IsVCPH             : Byte;      // non-zero if interface is to use VCP drivers
    PowerSaveEnableH   : Byte;      // non-zero if using ACBUS7 to save power for self-powered designs
  end;
  FT_PROGRAM_DATA = T_PROGRAM_DATA;      {$EXTERNALSYM FT_PROGRAM_DATA}
  PFT_PROGRAM_DATA = ^T_PROGRAM_DATA;    {$EXTERNALSYM PFT_PROGRAM_DATA}


  T_EEPROM_HEADER = record
    DeviceType         : FT_DEVICE;	// FTxxxx device cType to be programmed
    VendorId           : WORD;			// 0x0403
    ProductId          : WORD;			// 0x6001
    SerNumEnable       : UCHAR;			// non-zero if serial number to be used
    MaxPower           : WORD;			// 0 < MaxPower <= 500
    SelfPowered        : UCHAR;			// 0 = bus powered, 1 = self powered
    RemoteWakeup       : UCHAR;			// 0 = not capable, 1 = capable
    PullDownEnable     : UCHAR;		  // non-zero if pull down in suspend enabled
  end;
	FT_EEPROM_HEADER = T_EEPROM_HEADER;
  {$EXTERNALSYM FT_EEPROM_HEADER}
	PFT_EEPROM_HEADER = ^T_EEPROM_HEADER;
  {$EXTERNALSYM PFT_EEPROM_HEADER}

// FT232B EEPROM structure for use with FT_EEPROM_Read and FT_EEPROM_Program
	T_EEPROM_232B = record
		Common             : FT_EEPROM_HEADER;	// common elements for all device EEPROMs
  end;
  FT_EEPROM_232B = T_EEPROM_232B;        {$EXTERNALSYM FT_EEPROM_232B}
  PFT_EEPROM_232B = ^T_EEPROM_232B;      {$EXTERNALSYM PFT_EEPROM_232B}

// FT2232 EEPROM structure for use with FT_EEPROM_Read and FT_EEPROM_Program
  T_Eeprom_2232 = record
    Common             : FT_EEPROM_HEADER;	// common elements for all device EEPROMs
    AIsHighCurrent     : UCHAR;		// non-zero if interface is high current
    BIsHighCurrent     : UCHAR;		// non-zero if interface is high current
    AIsFifo            : UCHAR;		// non-zero if interface is 245 FIFO
    AIsFifoTar         : UCHAR;		// non-zero if interface is 245 FIFO CPU target
    AIsFastSer         : UCHAR;		// non-zero if interface is Fast serial
    BIsFifo            : UCHAR;		// non-zero if interface is 245 FIFO
    BIsFifoTar         : UCHAR;		// non-zero if interface is 245 FIFO CPU target
    BIsFastSer         : UCHAR;		// non-zero if interface is Fast serial
    ADriverType        : UCHAR;		//
    BDriverType        : UCHAR;		//
  end;
  FT_EEPROM_2232 = T_Eeprom_2232;        {$EXTERNALSYM FT_EEPROM_2232}
  PFT_EEPROM_2232 = ^T_Eeprom_2232;      {$EXTERNALSYM PFT_EEPROM_2232}

// FT232R EEPROM structure for use with FT_EEPROM_Read and FT_EEPROM_Program
  T_Eeprom_232r = record
    Common: FT_EEPROM_HEADER;     // common elements for all device EEPROMs
    IsHighCurrent      : UCHAR;   // non-zero if interface is high current
    UseExtOsc          : UCHAR;   // Use External Oscillator
    InvertTXD          : UCHAR;   // non-zero if invert TXD
    InvertRXD          : UCHAR;   // non-zero if invert RXD
    InvertRTS          : UCHAR;   // non-zero if invert RTS
    InvertCTS          : UCHAR;   // non-zero if invert CTS
    InvertDTR          : UCHAR;   // non-zero if invert DTR
    InvertDSR          : UCHAR;   // non-zero if invert DSR
    InvertDCD          : UCHAR;   // non-zero if invert DCD
    InvertRI           : UCHAR;   // non-zero if invert RI
    Cbus0              : UCHAR;   // Cbus Mux control
    Cbus1              : UCHAR;   // Cbus Mux control
    Cbus2              : UCHAR;   // Cbus Mux control
    Cbus3              : UCHAR;   // Cbus Mux control
    Cbus4              : UCHAR;   // Cbus Mux control
    DriverType         : UCHAR;
  end;
  FT_EEPROM_232R = T_Eeprom_232r;        {$EXTERNALSYM FT_EEPROM_232R}
  PFT_EEPROM_232R = ^T_Eeprom_232r;      {$EXTERNALSYM PFT_EEPROM_232R}

// FT2232H EEPROM structure for use with FT_EEPROM_Read and FT_EEPROM_Program
  T_Eeprom_2232h = record
    Common             : FT_EEPROM_HEADER;// common elements for all device EEPROMs
    ALSlowSlew         : UCHAR;   // non-zero if AL pins have slow slew
    ALSchmittInput     : UCHAR;   // non-zero if AL pins are Schmitt input
    ALDriveCurrent     : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    AHSlowSlew         : UCHAR;   // non-zero if AH pins have slow slew
    AHSchmittInput     : UCHAR;   // non-zero if AH pins are Schmitt input
    AHDriveCurrent     : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    BLSlowSlew         : UCHAR;   // non-zero if BL pins have slow slew
    BLSchmittInput     : UCHAR;   // non-zero if BL pins are Schmitt input
    BLDriveCurrent     : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    BHSlowSlew         : UCHAR;   // non-zero if BH pins have slow slew
    BHSchmittInput     : UCHAR;   // non-zero if BH pins are Schmitt input
    BHDriveCurrent     : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    AIsFifo            : UCHAR;   // non-zero if interface is 245 FIFO
    AIsFifoTar         : UCHAR;   // non-zero if interface is 245 FIFO CPU target
    AIsFastSer         : UCHAR;   // non-zero if interface is Fast serial
    BIsFifo            : UCHAR;   // non-zero if interface is 245 FIFO
    BIsFifoTar         : UCHAR;   // non-zero if interface is 245 FIFO CPU target
    BIsFastSer         : UCHAR;   // non-zero if interface is Fast serial
    PowerSaveEnable    : UCHAR;   // non-zero if using BCBUS7 to save power for self-powered designs
    ADriverType        : UCHAR;
    BDriverType        : UCHAR;
  end;
  FT_EEPROM_2232H = T_Eeprom_2232h;      {$EXTERNALSYM FT_EEPROM_2232H}
  PFT_EEPROM_2232H = ^T_Eeprom_2232h;    {$EXTERNALSYM PFT_EEPROM_2232H}


// FT4232H EEPROM structure for use with FT_EEPROM_Read and FT_EEPROM_Program
  T_Eeprom_4232h = record
    Common     : FT_EEPROM_HEADER;// common elements for all device EEPROMs
    ASlowSlew          : UCHAR;   // non-zero if A pins have slow slew
    ASchmittInput      : UCHAR;   // non-zero if A pins are Schmitt input
    ADriveCurrent      : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    BSlowSlew          : UCHAR;   // non-zero if B pins have slow slew
    BSchmittInput      : UCHAR;   // non-zero if B pins are Schmitt input
    BDriveCurrent      : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    CSlowSlew          : UCHAR;   // non-zero if C pins have slow slew
    CSchmittInput      : UCHAR;   // non-zero if C pins are Schmitt input
    CDriveCurrent      : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    DSlowSlew          : UCHAR;   // non-zero if D pins have slow slew
    DSchmittInput      : UCHAR;   // non-zero if D pins are Schmitt input
    DDriveCurrent      : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    ARIIsTXDEN         : UCHAR;   // non-zero if port A uses RI as RS485 TXDEN
    BRIIsTXDEN         : UCHAR;   // non-zero if port B uses RI as RS485 TXDEN
    CRIIsTXDEN         : UCHAR;   // non-zero if port C uses RI as RS485 TXDEN
    DRIIsTXDEN         : UCHAR;   // non-zero if port D uses RI as RS485 TXDEN
    ADriverType        : UCHAR;
    BDriverType        : UCHAR;
    CDriverType        : UCHAR;
    DDriverType        : UCHAR;
  end;
  FT_EEPROM_4232H = T_Eeprom_4232h;    {$EXTERNALSYM FT_EEPROM_4232H}
  PFT_EEPROM_4232H = ^T_Eeprom_4232h;  {$EXTERNALSYM PFT_EEPROM_4232H}

// FT232H EEPROM structure for use with FT_EEPROM_Read and FT_EEPROM_Program
  T_Eeprom_232h = record
    Common  : FT_EEPROM_HEADER;   // common elements for all device EEPROMs
    ACSlowSlew         : UCHAR;   // non-zero if AC bus pins have slow slew
    ACSchmittInput     : UCHAR;   // non-zero if AC bus pins are Schmitt input
    ACDriveCurrent     : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    ADSlowSlew         : UCHAR;   // non-zero if AD bus pins have slow slew
    ADSchmittInput     : UCHAR;   // non-zero if AD bus pins are Schmitt input
    ADDriveCurrent     : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    Cbus0              : UCHAR;   // Cbus Mux control
    Cbus1              : UCHAR;   // Cbus Mux control
    Cbus2              : UCHAR;   // Cbus Mux control
    Cbus3              : UCHAR;   // Cbus Mux control
    Cbus4              : UCHAR;   // Cbus Mux control
    Cbus5              : UCHAR;   // Cbus Mux control
    Cbus6              : UCHAR;   // Cbus Mux control
    Cbus7              : UCHAR;   // Cbus Mux control
    Cbus8              : UCHAR;   // Cbus Mux control
    Cbus9              : UCHAR;   // Cbus Mux control
    FT1248Cpol         : UCHAR;   // FT1248 clock polarity - clock idle high (1) or clock idle low (0)
    FT1248Lsb          : UCHAR;   // FT1248 data is LSB (1) or MSB (0)
    FT1248FlowControl  : UCHAR;   // FT1248 flow control enable
    IsFifo             : UCHAR;  	// non-zero if interface is 245 FIFO
    IsFifoTar          : UCHAR;   // non-zero if interface is 245 FIFO CPU target
    IsFastSer          : UCHAR;   // non-zero if interface is Fast serial
    IsFT1248           : UCHAR;   // non-zero if interface is FT1248
    PowerSaveEnable    : UCHAR;
    DriverType         : UCHAR;
  end;
  FT_EEPROM_232H = T_Eeprom_232h;    {$EXTERNALSYM FT_EEPROM_232H}
  PFT_EEPROM_232H = ^T_Eeprom_232h;  {$EXTERNALSYM PFT_EEPROM_232H}

// FT X Series EEPROM structure for use with FT_EEPROM_Read and FT_EEPROM_Program
  T_Eeprom_x_series = record
    Common: FT_EEPROM_HEADER;	    // common elements for all device EEPROMs
    ACSlowSlew         : UCHAR;   // non-zero if AC bus pins have slow slew
    ACSchmittInput     : UCHAR;   // non-zero if AC bus pins are Schmitt input
    ACDriveCurrent     : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    ADSlowSlew         : UCHAR;   // non-zero if AD bus pins have slow slew
    ADSchmittInput     : UCHAR;   // non-zero if AD bus pins are Schmitt input
    ADDriveCurrent     : UCHAR;   // valid values are 4mA, 8mA, 12mA, 16mA
    Cbus0              : UCHAR;   // Cbus Mux control
    Cbus1              : UCHAR;   // Cbus Mux control
    Cbus2              : UCHAR;   // Cbus Mux control
    Cbus3              : UCHAR;   // Cbus Mux control
    Cbus4              : UCHAR;   // Cbus Mux control
    Cbus5              : UCHAR;   // Cbus Mux control
    Cbus6              : UCHAR;   // Cbus Mux control
    InvertTXD          : UCHAR;   // non-zero if invert TXD
    InvertRXD          : UCHAR;   // non-zero if invert RXD
    InvertRTS          : UCHAR;   // non-zero if invert RTS
    InvertCTS          : UCHAR;   // non-zero if invert CTS
    InvertDTR          : UCHAR;   // non-zero if invert DTR
    InvertDSR          : UCHAR;   // non-zero if invert DSR
    InvertDCD          : UCHAR;   // non-zero if invert DCD
    InvertRI           : UCHAR;   // non-zero if invert RI
    BCDEnable          : UCHAR;   // Enable Battery Charger Detection
    BCDForceCbusPWREN  : UCHAR;   // asserts the power enable signal on CBUS when charging port detected
    BCDDisableSleep    : UCHAR;   // forces the device never to go into sleep mode
    I2CSlaveAddress    : WORD;    // I2C slave device address
    I2CDeviceId        : DWORD;   // I2C device ID
    I2CDisableSchmitt  : UCHAR;   // Disable I2C Schmitt trigger
    FT1248Cpol         : UCHAR;   // FT1248 clock polarity - clock idle high (1) or clock idle low (0)
    FT1248Lsb          : UCHAR;   // FT1248 data is LSB (1) or MSB (0)
    FT1248FlowControl  : UCHAR;   // FT1248 flow control enable
    RS485EchoSuppress  : UCHAR;
    PowerSaveEnable    : UCHAR;
    DriverType         : UCHAR;
  end;
  FT_EEPROM_X_SERIES = T_Eeprom_x_Series;    {$EXTERNALSYM FT_EEPROM_X_SERIES}
  PFT_EEPROM_X_SERIES = ^T_Eeprom_x_Series;  {$EXTERNALSYM PFT_EEPROM_X_SERIES}

// Win32 COMM API type functions
  FTCOMSTAT = record
    fCtsHold          : DWORD;       //  :1
    fDsrHold          : DWORD;       //  :1
    fRlsdHold         : DWORD;       //  :1
    fXoffHold         : DWORD;       //  :1
    fXoffSent         : DWORD;       //  :1
    fEof              : DWORD;       //  :1
    fTxim             : DWORD;       //  :1
    fReserved         : DWORD;       //  :25
    cbInQue           : DWORD;
    cbOutQue          : DWORD;
  end;
  TFTCOMSTAT = FTCOMSTAT;        {$EXTERNALSYM TFTCOMSTAT}
  LPFTCOMSTAT = ^FTCOMSTAT;      {$EXTERNALSYM LPFTCOMSTAT}

  FTDCB = record
    DCBlength         : DWORD;    // sizeof(FTDCB)
    BaudRate          : DWORD;    // Baudrate at which running
    fBinary           : DWORD;    // Binary Mode (skip EOF check)         //  :1
    fParity           : DWORD;    // Enable parity checking               //  :1
    fOutxCtsFlow      : DWORD;    // CTS handshaking on output            //  :1
    fOutxDsrFlow      : DWORD;    // DSR handshaking on output            //  :1
    fDtrControl       : DWORD;    // DTR Flow control                     //  :2
    fDsrSensitivity   : DWORD;    // DSR Sensitivity                      //  :1
    fTXContinueOnXoff : DWORD;    // Continue TX when Xoff sent              //  :1
    fOutX             : DWORD;    // Enable output X-ON/X-OFF             //  :1
    fInX              : DWORD;    // Enable input X-ON/X-OFF              //  :1
    fErrorChar        : DWORD;    // Enable Err Replacement               //  :1
    fNull             : DWORD;    // Enable Null stripping                //  :1
    fRtsControl       : DWORD;    // Rts Flow control                     //  :2
    fAbortOnError     : DWORD;    // Abort all reads and writes on Error  //  :1
    fDummy2           : DWORD;    // Reserved                             //  :17
    wReserved         : WORD;     // Not currently used
    XonLim            : WORD;     // Transmit X-ON threshold
    XoffLim           : WORD;     // Transmit X-OFF threshold
    ByteSize          : BYTE;     // Number of bits/byte, 4-8
    Parity            : BYTE;     // 0-4=None,Odd,Even,Mark,Space
    StopBits          : BYTE;     // FT_STOP_BITS_1 or FT_STOP_BITS_2
    XonChar           : char;     // Tx and Rx X-ON character
    XoffChar          : char;     // Tx and Rx X-OFF character
    ErrorChar         : char;     // Error replacement PChar
    EofChar           : char;     // End of Input character
    EvtChar           : char;     // Received Event character
    wReserved1        : WORD;     // Fill for now.
  end;
  TFTDCB = FTDCB;              {$EXTERNALSYM TFTDCB}
  LPFTDCB = ^FTDCB;            {$EXTERNALSYM LPFTDCB}

  FTTIMEOUTS = record
    ReadIntervalTimeout        : DWORD; // Maximum time between read chars.
    ReadTotalTimeoutMultiplier : DWORD; // Multiplier of characters.
    ReadTotalTimeoutConstant   : DWORD; // Constant in milliseconds.
    WriteTotalTimeoutMultiplier: DWORD; // Multiplier of characters.
    WriteTotalTimeoutConstant  : DWORD; // Constant in milliseconds.
  end;
  TFTTIMEOUTS = FTTIMEOUTS;    {$EXTERNALSYM TFTTIMEOUTS}
  LPFTTIMEOUTS = ^FTTIMEOUTS;  {$EXTERNALSYM LPFTTIMEOUTS}

const
  FT_DEVICE_TYPE_LIST : array[0..14] of string =(
    'BM',        //  0
    'AM',        //  1
    '100AX',     //  2
    'UNKNOWN',   //  3
    '2232C',     //  4
    '232R',      //  5
    '2232H',     //  6
    '4232H',     //  7
    '232H',      //  8
    'X_SERIES',  //  9
    '4222H_0',   // 10
    '4222H_1_2', // 11
    '4222H_3',   // 12
    '4222_PROG', // 13
    '900');      // 14

// Device status
  FT_OK                          = 0;
  FT_INVALID_HANDLE              = 1;
  FT_DEVICE_NOT_FOUND            = 2;
  FT_DEVICE_NOT_OPENED           = 3;
  FT_IO_ERROR                    = 4;
  FT_INSUFFICIENT_RESOURCES      = 5;
  FT_INVALID_PARAMETER           = 6;
  FT_INVALID_BAUD_RATE           = 7;
  FT_DEVICE_NOT_OPENED_FOR_ERASE = 8;
  FT_DEVICE_NOT_OPENED_FOR_WRITE = 9;
  FT_FAILED_TO_WRITE_DEVICE      = 10;
  FT_EEPROM_READ_FAILED          = 11;
  FT_EEPROM_WRITE_FAILED         = 12;
  FT_EEPROM_ERASE_FAILED         = 13;
  FT_EEPROM_NOT_PRESENT          = 14;
  FT_EEPROM_NOT_PROGRAMMED       = 15;
  FT_INVALID_ARGS                = 16;
  FT_NOT_SUPPORTED               = 17;
  FT_OTHER_ERROR                 = 18;
  FT_DEVICE_LIST_NOT_READY       = 19;

  FT_SUCCESS                     = 0;

// FT_Open_Ex Flags
  FT_OPEN_BY_SERIAL_NUMBER       = 1;    {$EXTERNALSYM FT_OPEN_BY_SERIAL_NUMBER}
  FT_OPEN_BY_DESCRIPTION         = 2;    {$EXTERNALSYM FT_OPEN_BY_DESCRIPTION}
  FT_OPEN_BY_LOCATION            = 4;    {$EXTERNALSYM FT_OPEN_BY_LOCATION}
  FT_OPEN_MASK = (FT_OPEN_BY_SERIAL_NUMBER or FT_OPEN_BY_DESCRIPTION or FT_OPEN_BY_LOCATION);    {$EXTERNALSYM FT_OPEN_MASK}

// FT_List_Devices Flags (used in conjunction with FT_OpenEx Flags)
  FT_LIST_NUMBER_ONLY            = $80000000;  {$EXTERNALSYM FT_LIST_NUMBER_ONLY}
  FT_LIST_BY_INDEX               = $40000000;  {$EXTERNALSYM FT_LIST_BY_INDEX}
  FT_LIST_ALL                    = $20000000;  {$EXTERNALSYM FT_LIST_ALL}
  FT_LIST_MASK = LongInt(FT_LIST_NUMBER_ONLY or FT_LIST_BY_INDEX or FT_LIST_ALL); {$EXTERNALSYM FT_LIST_MASK}

// Baud Rates
  FT_BAUD_300                   =    300;   {$EXTERNALSYM FT_BAUD_300}
  FT_BAUD_600                   =    600;   {$EXTERNALSYM FT_BAUD_600}
  FT_BAUD_1200                  =   1200;   {$EXTERNALSYM FT_BAUD_1200}
  FT_BAUD_2400                  =   2400;   {$EXTERNALSYM FT_BAUD_2400}
  FT_BAUD_4800                  =   4800;   {$EXTERNALSYM FT_BAUD_4800}
  FT_BAUD_9600                  =   9600;   {$EXTERNALSYM FT_BAUD_9600}
  FT_BAUD_14400                 =  14400;   {$EXTERNALSYM FT_BAUD_14400}
  FT_BAUD_19200                 =  19200;   {$EXTERNALSYM FT_BAUD_19200}
  FT_BAUD_38400                 =  38400;   {$EXTERNALSYM FT_BAUD_38400}
  FT_BAUD_57600                 =  57600;   {$EXTERNALSYM FT_BAUD_57600}
  FT_BAUD_115200                = 115200;   {$EXTERNALSYM FT_BAUD_115200}
  FT_BAUD_230400                = 230400;   {$EXTERNALSYM FT_BAUD_230400}
  FT_BAUD_460800                = 460800;   {$EXTERNALSYM FT_BAUD_460800}
  FT_BAUD_921600                = 921600;   {$EXTERNALSYM FT_BAUD_921600}

// Word Lengths
  FT_BITS_8                     = 8;        {$EXTERNALSYM FT_BITS_8}
  FT_BITS_7                     = 7;        {$EXTERNALSYM FT_BITS_7}

// Stop Bits
  FT_STOP_BITS_1                = 0;        {$EXTERNALSYM FT_STOP_BITS_1}
  FT_STOP_BITS_2                = 2;        {$EXTERNALSYM FT_STOP_BITS_2}

// Parity
  FT_PARITY_NONE                 = 0;       {$EXTERNALSYM FT_PARITY_NONE}
  FT_PARITY_ODD                  = 1;       {$EXTERNALSYM FT_PARITY_ODD}
  FT_PARITY_EVEN                 = 2;       {$EXTERNALSYM FT_PARITY_EVEN}
  FT_PARITY_MARK                 = 3;       {$EXTERNALSYM FT_PARITY_MARK}
  FT_PARITY_SPACE                = 4;       {$EXTERNALSYM FT_PARITY_SPACE}

// Flow Control
  FT_FLOW_NONE                   = $0000;   {$EXTERNALSYM FT_FLOW_NONE}
  FT_FLOW_RTS_CTS                = $0100;   {$EXTERNALSYM FT_FLOW_RTS_CTS}
  FT_FLOW_DTR_DSR                = $0200;   {$EXTERNALSYM FT_FLOW_DTR_DSR}
  FT_FLOW_XON_XOFF               = $0400;   {$EXTERNALSYM FT_FLOW_XON_XOFF}

// Purge rx and tx buffers
  FT_PURGE_RX                    = 1;       {$EXTERNALSYM FT_PURGE_RX}
  FT_PURGE_TX                    = 2;       {$EXTERNALSYM FT_PURGE_TX}

// Events
  FT_EVENT_RXCHAR                = 1;       {$EXTERNALSYM FT_EVENT_RXCHAR}
  FT_EVENT_MODEM_STATUS          = 2;       {$EXTERNALSYM FT_EVENT_MODEM_STATUS}
  FT_EVENT_LINE_STATUS           = 4;       {$EXTERNALSYM FT_EVENT_LINE_STATUS}

// Timeouts
  FT_DEFAULT_RX_TIMEOUT          = 300;     {$EXTERNALSYM FT_DEFAULT_RX_TIMEOUT}
  FT_DEFAULT_TX_TIMEOUT          = 300;     {$EXTERNALSYM FT_DEFAULT_TX_TIMEOUT}


// Device types
  FT_DEVICE_BM                   = 0;
  FT_DEVICE_AM                   = 1;
  FT_DEVICE_100AX                = 2;
  FT_DEVICE_UNKNOWN              = 3;
  FT_DEVICE_2232C                = 4;
  FT_DEVICE_232R                 = 5;
  FT_DEVICE_2232H                = 6;
  FT_DEVICE_4232H                = 7;
  FT_DEVICE_232H                 = 8;
  FT_DEVICE_X_SERIES             = 9;
  FT_DEVICE_4222H_0              = 10;
  FT_DEVICE_4222H_1_2            = 11;
  FT_DEVICE_4222H_3              = 12;
  FT_DEVICE_4222_PROG            = 13;
  FT_DEVICE_900                  = 14;

// Bit Modes
  FT_BITMODE_RESET              = $00;     {$EXTERNALSYM FT_BITMODE_RESET}
  FT_BITMODE_ASYNC_BITBANG      = $01;     {$EXTERNALSYM FT_BITMODE_ASYNC_BITBANG}
  FT_BITMODE_MPSSE              = $02;     {$EXTERNALSYM FT_BITMODE_MPSSE}
  FT_BITMODE_SYNC_BITBANG       = $04;     {$EXTERNALSYM FT_BITMODE_SYNC_BITBANG}
  FT_BITMODE_MCU_HOST           = $08;     {$EXTERNALSYM FT_BITMODE_MCU_HOST}
  FT_BITMODE_FAST_SERIAL        = $10;     {$EXTERNALSYM FT_BITMODE_FAST_SERIAL}
  FT_BITMODE_CBUS_BITBANG       = $20;     {$EXTERNALSYM FT_BITMODE_CBUS_BITBANG}
  FT_BITMODE_SYNC_FIFO          = $40;     {$EXTERNALSYM FT_BITMODE_SYNC_FIFO}

// FT232R CBUS Options EEPROM values
  FT_232R_CBUS_TXDEN            = $00;  // Tx Data Enable
  {$EXTERNALSYM FT_232R_CBUS_TXDEN}
  FT_232R_CBUS_PWRON            = $01;  // Power On
  {$EXTERNALSYM FT_232R_CBUS_PWRON}
  FT_232R_CBUS_RXLED            = $02;  // Rx LED
  {$EXTERNALSYM FT_232R_CBUS_RXLED}
   FT_232R_CBUS_TXLED           = $03;  // Tx LED
  {$EXTERNALSYM FT_232R_CBUS_TXLED}
   FT_232R_CBUS_TXRXLED         = $04;  // Tx and Rx LED
  {$EXTERNALSYM FT_232R_CBUS_TXRXLED}
   FT_232R_CBUS_SLEEP           = $05;  // Sleep
  {$EXTERNALSYM FT_232R_CBUS_SLEEP}
   FT_232R_CBUS_CLK48           = $06;  // 48MHz clock
  {$EXTERNALSYM FT_232R_CBUS_CLK48}
   FT_232R_CBUS_CLK24           = $07;  // 24MHz clock
  {$EXTERNALSYM FT_232R_CBUS_CLK24}
   FT_232R_CBUS_CLK12           = $08;  // 12MHz clock
  {$EXTERNALSYM FT_232R_CBUS_CLK12}
   FT_232R_CBUS_CLK6            = $09;  // 6MHz clock
  {$EXTERNALSYM FT_232R_CBUS_CLK6}
   FT_232R_CBUS_IOMODE          = $0A;  // IO Mode for CBUS bit-bang
  {$EXTERNALSYM FT_232R_CBUS_IOMODE}
   FT_232R_CBUS_BITBANG_WR      = $0B;  // Bit-bang write strobe
  {$EXTERNALSYM FT_232R_CBUS_BITBANG_WR}
   FT_232R_CBUS_BITBANG_RD     = $0C;  // Bit-bang read strobe
  {$EXTERNALSYM FT_232R_CBUS_BITBANG_RD}

// FT232H CBUS Options EEPROM values
  FT_232H_CBUS_TRISTATE         = $00; // Tristate
{$EXTERNALSYM FT_232H_CBUS_TRISTATE}
  FT_232H_CBUS_TXLED            = $01; // Tx LED
{$EXTERNALSYM FT_232H_CBUS_TXLED}
  FT_232H_CBUS_RXLED            = $02; // Rx LED
{$EXTERNALSYM FT_232H_CBUS_RXLED}
  FT_232H_CBUS_TXRXLED          = $03; // Tx and Rx LED
{$EXTERNALSYM FT_232H_CBUS_TXRXLED}
  FT_232H_CBUS_PWREN            = $04; // Power Enable
{$EXTERNALSYM FT_232H_CBUS_PWREN}
  FT_232H_CBUS_SLEEP            = $05; // Sleep
{$EXTERNALSYM FT_232H_CBUS_SLEEP}
  FT_232H_CBUS_DRIVE_0          = $06; // Drive pin to logic 0
{$EXTERNALSYM FT_232H_CBUS_DRIVE_0}
  FT_232H_CBUS_DRIVE_1          = $07; // Drive pin to logic 1
{$EXTERNALSYM FT_232H_CBUS_DRIVE_1}
  FT_232H_CBUS_IOMODE           = $08; // IO Mode for CBUS bit-bang
{$EXTERNALSYM FT_232H_CBUS_IOMODE}
  FT_232H_CBUS_TXDEN            = $09; // Tx Data Enable
{$EXTERNALSYM FT_232H_CBUS_TXDEN}
  FT_232H_CBUS_CLK30            = $0A; // 30MHz clock
{$EXTERNALSYM FT_232H_CBUS_CLK30}
  FT_232H_CBUS_CLK15            = $0B; // 15MHz clock
{$EXTERNALSYM FT_232H_CBUS_CLK15}
  FT_232H_CBUS_CLK7_5           = $0C; // 7.5MHz clock
{$EXTERNALSYM FT_232H_CBUS_CLK7_5}

// FT X Series CBUS Options EEPROM values
  FT_X_SERIES_CBUS_TRISTATE     = $00; // Tristate
{$EXTERNALSYM FT_X_SERIES_CBUS_TRISTATE}
  FT_X_SERIES_CBUS_TXLED        = $01; // Tx LED
{$EXTERNALSYM FT_X_SERIES_CBUS_TXLED}
  FT_X_SERIES_CBUS_RXLED        = $02; // Rx LED
{$EXTERNALSYM FT_X_SERIES_CBUS_RXLED}
  FT_X_SERIES_CBUS_TXRXLED      = $03; // Tx and Rx LED
{$EXTERNALSYM FT_X_SERIES_CBUS_TXRXLED}
  FT_X_SERIES_CBUS_PWREN        = $04; // Power Enable
{$EXTERNALSYM FT_X_SERIES_CBUS_PWREN}
  FT_X_SERIES_CBUS_SLEEP        = $05; // Sleep
{$EXTERNALSYM FT_X_SERIES_CBUS_SLEEP}
  FT_X_SERIES_CBUS_DRIVE_0      = $06; // Drive pin to logic 0
{$EXTERNALSYM FT_X_SERIES_CBUS_DRIVE_0}
  FT_X_SERIES_CBUS_DRIVE_1      = $07; // Drive pin to logic 1
{$EXTERNALSYM FT_X_SERIES_CBUS_DRIVE_1}
  FT_X_SERIES_CBUS_IOMODE       = $08;  // IO Mode for CBUS bit-bang
{$EXTERNALSYM FT_X_SERIES_CBUS_IOMODE}
  FT_X_SERIES_CBUS_TXDEN        = $09; // Tx Data Enable
{$EXTERNALSYM FT_X_SERIES_CBUS_TXDEN}
  FT_X_SERIES_CBUS_CLK24       = $0A; // 24MHz clock
{$EXTERNALSYM FT_X_SERIES_CBUS_CLK24}
  FT_X_SERIES_CBUS_CLK12       = $0B; // 12MHz clock
{$EXTERNALSYM FT_X_SERIES_CBUS_CLK12}
  FT_X_SERIES_CBUS_CLK6        = $0C; // 6MHz clock
{$EXTERNALSYM FT_X_SERIES_CBUS_CLK6}
  FT_X_SERIES_CBUS_BCD_CHARGER = $0D; // Battery charger detected
{$EXTERNALSYM FT_X_SERIES_CBUS_BCD_CHARGER}
  FT_X_SERIES_CBUS_BCD_CHARGER_N = $0E; // Battery charger detected inverted
{$EXTERNALSYM FT_X_SERIES_CBUS_BCD_CHARGER_N}
  FT_X_SERIES_CBUS_I2C_TXE     = $0F; // I2C Tx empty
{$EXTERNALSYM FT_X_SERIES_CBUS_I2C_TXE}
  FT_X_SERIES_CBUS_I2C_RXF     = $10; // I2C Rx full
{$EXTERNALSYM FT_X_SERIES_CBUS_I2C_RXF}
  FT_X_SERIES_CBUS_VBUS_SENSE  = $11; // Detect VBUS
{$EXTERNALSYM FT_X_SERIES_CBUS_VBUS_SENSE}
  FT_X_SERIES_CBUS_BITBANG_WR  = $12; // Bit-bang write strobe
{$EXTERNALSYM FT_X_SERIES_CBUS_BITBANG_WR}
  FT_X_SERIES_CBUS_BITBANG_RD  = $13; // Bit-bang read strobe
{$EXTERNALSYM FT_X_SERIES_CBUS_BITBANG_RD}
  FT_X_SERIES_CBUS_TIMESTAMP   = $14; // Toggle output when a USB SOF token is received
{$EXTERNALSYM FT_X_SERIES_CBUS_TIMESTAMP}
  FT_X_SERIES_CBUS_KEEP_AWAKE  = $15;
{$EXTERNALSYM FT_X_SERIES_CBUS_KEEP_AWAKE}

// Driver types
  FT_DRIVER_TYPE_D2XX           = 0;
{$EXTERNALSYM FT_DRIVER_TYPE_D2XX}
  FT_DRIVER_TYPE_VCP            = 1;
{$EXTERNALSYM FT_DRIVER_TYPE_VCP}

// Device information flags
  FT_FLAGS_OPENED               = 1;
  FT_FLAGS_HISPEED              = 2;

{$ifdef FTD2XX_STATIC}
  {$EXTERNALSYM FT_Initialise}
  function FT_Initialise(): FT_STATUS; stdcall;
{$EXTERNALSYM FT_Finalise}
  procedure FT_Finalise(); stdcall;
{$endif}	// FTD2XX_STATIC


{$EXTERNALSYM FT_Open}
  function FT_Open ( DeviceNumber    : Integer;
                 var pHandle         : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_OpenEx}
  function FT_OpenEx                  ( pArg1           : PVOID;
                                        Flags           : DWORD;
                                    var pHandle         : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_ListDevices}
  function FT_ListDevices             ( pArg1           : PVOID;
                                        pArg2           : PVOID;
                                        Flags           : DWORD                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_Close}
  function FT_Close                   ( ftHandle        : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_Read}
  function FT_Read                    ( ftHandle        : FT_HANDLE;
                                        LpBuffer        : LPVOID;
                                        DwBytesToRead   : DWORD;
                                        LpBytesReturned : LPDWORD               ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_Write}
  function FT_Write                   ( ftHandle        : FT_HANDLE;
                                        lpBuffer        : LPVOID;
                                        dwBytesToWrite  : DWORD;
                                        lpBytesWritten  : LPDWORD               ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_IoCtl}
  function FT_IoCtl                   ( ftHandle        : FT_HANDLE;
                                        dwIoControlCode : DWORD;
                                        lpInBuf         : LPVOID;
                                        nInBufSize      : DWORD;
                                        lpOutBuf        : LPVOID;
                                        nOutBufSize     : DWORD;
                                        lpBytesReturned : LPDWORD;
                                        lpOverlapped    : POverlapped           ): FT_STATUS; stdcall;

{$EXTERNALSYM FT_SetBaudRate}
  function FT_SetBaudRate             ( ftHandle        : FT_HANDLE;
                                         BaudRate       : ULONG                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetDivisor}
  function FT_SetDivisor              ( ftHandle        : FT_HANDLE;
                                        Divisor         : USHORT                ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetDataCharacteristics}
  function FT_SetDataCharacteristics  ( ftHandle        : FT_HANDLE;
                                        WordLength      : UCHAR;
                                        StopBits        : UCHAR;
                                        Parity          : UCHAR                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetFlowControl}
  function FT_SetFlowControl          ( ftHandle        : FT_HANDLE;
                                        FlowControl     : USHORT;
                                        XonChar         : UCHAR;
                                        XoffChar        : UCHAR                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_ResetDevice}
  function FT_ResetDevice             ( ftHandle        : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetDtr}
  function FT_SetDtr                  ( ftHandle        : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_ClrDtr}
  function FT_ClrDtr                  ( ftHandle        : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetRts}
  function FT_SetRts                  ( ftHandle        : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_ClrRts}
  function FT_ClrRts                  ( ftHandle        : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetModemStatus}
  function FT_GetModemStatus          ( ftHandle        : FT_HANDLE;
                                    var pModemStatus    : ULONG                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetChars}
  function FT_SetChars                ( ftHandle        : FT_HANDLE;
                                        EventChar       : UCHAR;
                                        EventCharEnabled: UCHAR;
                                        ErrorChar       : UCHAR;
                                        ErrorCharEnabled: UCHAR                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_Purge}
  function FT_Purge                   ( ftHandle        : FT_HANDLE;
                                        Mask            : ULONG                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetTimeouts}
  function FT_SetTimeouts             ( ftHandle        : FT_HANDLE;
                                        ReadTimeout     : ULONG;
                                        WriteTimeout    : ULONG                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetQueueStatus}
  function FT_GetQueueStatus          ( ftHandle        : FT_HANDLE;
                                    var dwRxBytes       : DWORD                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetEventNotification}
  function FT_SetEventNotification    ( ftHandle        : FT_HANDLE;
                                        Mask            : DWORD;
                                        Param           : PVOID                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetStatus}
  function FT_GetStatus               ( ftHandle        : FT_HANDLE;
                                    var dwRxBytes       : DWORD;
                                    var dwTxBytes       : DWORD;
                                    var dwEventDWord    : DWORD                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetBreakOn}
  function FT_SetBreakOn              ( ftHandle        : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetBreakOff}
  function FT_SetBreakOff             ( ftHandle        : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetWaitMask}
  function FT_SetWaitMask             ( ftHandle        : FT_HANDLE;
                                        Mask            : DWORD                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_WaitOnMask}
  function FT_WaitOnMask              ( ftHandle        : FT_HANDLE;
                                    var Mask            : DWORD                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetEventStatus}
  function FT_GetEventStatus          ( ftHandle        : FT_HANDLE;
                                    var dwEventDWord    : DWORD                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_ReadEE}
  function FT_ReadEE                  ( ftHandle        : FT_HANDLE;
                                        dwWordOffset    : DWORD;
                                        lpwValue        : LPWORD                ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_WriteEE}
  function FT_WriteEE                 ( ftHandle        : FT_HANDLE;
                                        dwWordOffset    : DWORD;
                                        wValue          : WORD                  ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EraseEE}
  function FT_EraseEE                 ( ftHandle        : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EE_Program}
  function FT_EE_Program              ( ftHandle        : FT_HANDLE;
                                        pData           : PFT_PROGRAM_DATA      ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EE_ProgramEx}
  function FT_EE_ProgramEx            ( ftHandle        : FT_HANDLE;
                                        pData           : PFT_PROGRAM_DATA;
                                        Manufacturer    : PChar;
                                        ManufacturerId  : PChar;
                                        Description     : PChar;
                                        SerialNumber    : PChar                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EE_Read}
  function FT_EE_Read                ( ftHandle         : FT_HANDLE;
                                       pData            : PFT_PROGRAM_DATA      ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EE_ReadEx}
  function FT_EE_ReadEx              ( ftHandle         : FT_HANDLE;
                                       pData            : PFT_PROGRAM_DATA;
                                       Manufacturer     : PChar;
                                       ManufacturerId   : PChar;
                                       Description      : PChar;
                                       SerialNumber     : PChar                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EE_UASize}
  function FT_EE_UASize              ( ftHandle         : FT_HANDLE;
                                       lpdwSize         : LPDWORD               ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EE_UAWrite}
  function FT_EE_UAWrite             ( ftHandle         : FT_HANDLE;
                                       pucData          : PUCHAR;
                                       dwDataLen        : DWORD                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EE_UARead}
  function FT_EE_UARead              ( ftHandle         : FT_HANDLE;
                                       pucData          : PUCHAR;
                                       dwDataLen        : DWORD;
                                       lpdwBytesRead    : LPDWORD               ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EEPROM_Read}
  function FT_EEPROM_Read            ( ftHandle         : FT_HANDLE;
                                       eepromData       : Pointer;
                                       eepromDataSize   : DWORD;
                                       Manufacturer     : PChar;
                                       ManufacturerId   : PChar;
                                       Description      : PChar;
                                       SerialNumber     : PChar                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EEPROM_Program}
  function FT_EEPROM_Program         ( ftHandle         : FT_HANDLE;
                                       eepromData       : Pointer;
                                       eepromDataSize   : DWORD;
                                       Manufacturer     : PChar;
                                       ManufacturerId   : PChar;
                                       Description      : PChar;
                                       SerialNumber     : PChar                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetLatencyTimer}
  function FT_SetLatencyTimer        ( ftHandle         : FT_HANDLE;
                                       ucLatency: UCHAR                         ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetLatencyTimer}
  function FT_GetLatencyTimer        ( ftHandle         : FT_HANDLE;
                                       pucLatency       : PUCHAR                ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetBitMode}
  function FT_SetBitMode             ( ftHandle         : FT_HANDLE;
                                       ucMask           : UCHAR;
                                       ucEnable         : UCHAR                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetBitMode}
  function FT_GetBitMode             ( ftHandle         : FT_HANDLE;
                                       pucMode          : PUCHAR                ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetUSBParameters}
  function FT_SetUSBParameters      (  ftHandle         : FT_HANDLE;
                                       ulInTransferSize : ULONG;
                                       ulOutTransferSize: ULONG                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetDeadmanTimeout}
  function FT_SetDeadmanTimeout      ( ftHandle         : FT_HANDLE;
                                       ulDeadmanTimeout : ULONG                 ): FT_STATUS; stdcall;

{$EXTERNALSYM FT_GetDeviceLocId}
  function FT_GetDeviceLocId         ( ftHandle         : FT_HANDLE;
                                       lpdwLocId        : LPDWORD               ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetDeviceInfo}
  function FT_GetDeviceInfo          ( ftHandle         : FT_HANDLE;
                                   var lpftDevice       : FT_DEVICE;
                                       lpdwID           : LPDWORD;
                                       SerialNumber     : PCHAR;
                                       Description      : PCHAR;
                                       Dummy            : LPVOID                ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_StopInTask}
  function FT_StopInTask             ( ftHandle         : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_RestartInTask}
  function FT_RestartInTask          ( ftHandle         : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_SetResetPipeRetryCount}
  function FT_SetResetPipeRetryCount ( ftHandle         : FT_HANDLE;
                                       dwCount          : DWORD                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_ResetPort}
  function FT_ResetPort              ( ftHandle         : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_CyclePort}
  function FT_CyclePort              ( ftHandle         : FT_HANDLE             ): FT_STATUS; stdcall;

// Win32-type s
{$EXTERNALSYM FT_W32_CreateFile}
  function FT_W32_CreateFile         ( lpszName         : LPCTSTR;
                                       dwAccess         : DWORD;
                                       dwShareMode      : DWORD;
                                       lpSecurityAttributes: PSecurityAttributes;
                                       dwCreate         : DWORD;
                                       dwAttrsAndFlags  : DWORD;
                                       hTemplate        : THandle               ): FT_HANDLE; stdcall;
{$EXTERNALSYM FT_W32_CloseHandle}
  function FT_W32_CloseHandle        ( ftHandle         : FT_HANDLE             ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_ReadFile}
  function FT_W32_ReadFile           ( ftHandle         : FT_HANDLE;
                                       lpBuffer         : LPVOID;
                                       nBufferSize      : DWORD;
                                       lpBytesReturned  : LPDWORD;
                                       LpOverlapped     : POverlapped ): BOOL; stdcall;      // LpOverlapped: LPOVERLAPPED ne dela
{$EXTERNALSYM FT_W32_WriteFile}
  function FT_W32_WriteFile          ( ftHandle         : FT_HANDLE;
                                       lpBuffer         : LPVOID;
                                       nBufferSize      : DWORD;
                                       lpBytesWritten   : LPDWORD;
                                       lpOverlapped     : POverlapped           ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_GetLastError}
  function FT_W32_GetLastError       ( ftHandle         : FT_HANDLE             ): DWORD;     stdcall;
{$EXTERNALSYM FT_W32_GetOverlappedResult}
  function FT_W32_GetOverlappedResult (ftHandle         : FT_HANDLE;
                                       lpOverlapped     : POverlapped;
                                       lpdwBytesTransferred: LPDWORD;
                                       bWait            : BOOL                  ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_CancelIo}
  function FT_W32_CancelIo           ( ftHandle         : FT_HANDLE             ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_ClearCommBreak}
  function FT_W32_ClearCommBreak     ( ftHandle         : FT_HANDLE             ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_ClearCommError}
  function FT_W32_ClearCommError     ( ftHandle         : FT_HANDLE;
                                       lpdwErrors       : LPDWORD;
                                       lpftComstat      : LPFTCOMSTAT           ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_EscapeCommFunction}
  function FT_W32_EscapeCommFunction ( ftHandle         : FT_HANDLE;
                                       dwFunc           : DWORD                 ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_GetCommModemStatus}
  function FT_W32_GetCommModemStatus ( ftHandle         : FT_HANDLE;
                                       lpdwModemStatus  : LPDWORD               ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_GetCommState}
  function FT_W32_GetCommState       ( ftHandle         : FT_HANDLE;
                                       lpftDcb          : LPFTDCB               ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_GetCommTimeouts}
  function FT_W32_GetCommTimeouts    ( ftHandle         : FT_HANDLE;
                                   var pTimeouts        : FTTIMEOUTS            ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_PurgeComm}
  function FT_W32_PurgeComm          ( ftHandle         : FT_HANDLE;
                                       dwMask           : DWORD                 ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_SetCommBreak}
  function FT_W32_SetCommBreak       ( ftHandle         : FT_HANDLE             ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_SetCommMask}
  function FT_W32_SetCommMask        ( ftHandle         : FT_HANDLE;
                                       ulEventMask      : ULONG                 ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_GetCommMask}
  function FT_W32_GetCommMask        ( ftHandle         : FT_HANDLE;
                                       lpdwEventMask    : LPDWORD               ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_SetCommState}
  function FT_W32_SetCommState       ( ftHandle         : FT_HANDLE;
                                       lpftDcb          : LPFTDCB               ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_SetCommTimeouts}
  function FT_W32_SetCommTimeouts    ( ftHandle         : FT_HANDLE;
                                   var pTimeouts        : FTTIMEOUTS            ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_SetupComm}
  function FT_W32_SetupComm          ( ftHandle         : FT_HANDLE;
                                       dwReadBufferSize : DWORD;
                                       dwWriteBufferSize: DWORD                 ): BOOL;      stdcall;
{$EXTERNALSYM FT_W32_WaitCommEvent}
  function FT_W32_WaitCommEvent      ( ftHandle         : FT_HANDLE;
                                       pulEvent         : PULONG;
                                       lpOverlapped     : POverlapped           ): BOOL;      stdcall;
//  function FT_CreateDeviceInfoList   ( lpdwNumDevs      : LPDWORD               ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_CreateDeviceInfoList}
  function FT_CreateDeviceInfoList  ( NumDevs: Pointer): FT_Status; stdcall;
//  function FT_GetDeviceInfoList      ( var pDest        : FT_DEVICE_LIST_INFO_NODE;
//                                       lpdwNumDevs      : LPDWORD               ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetDeviceInfoList}
  function FT_GetDeviceInfoList      ( pFT_Device_Info_List:Pointer;
                                       NumDevs:Pointer                          ):FT_Status; stdcall;

{$EXTERNALSYM FT_GetDeviceInfoDetail}
  function FT_GetDeviceInfoDetail    ( dwIndex          : DWORD;
                                       lpdwFlags        : LPDWORD;
                                       lpdwType         : LPDWORD;
                                       lpdwID           : LPDWORD;
                                       lpdwLocId        : LPDWORD;
                                       lpSerialNumber   : LPVOID;
                                       lpDescription    : LPVOID;
                                   var pftHandle        : FT_HANDLE             ): FT_STATUS; stdcall;
// Version information
{$EXTERNALSYM FT_GetDriverVersion}
  function FT_GetDriverVersion       ( ftHandle         : FT_HANDLE;
                                       lpdwVersion      : LPDWORD               ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetLibraryVersion}
  function FT_GetLibraryVersion      ( lpdwVersion      : LPDWORD               ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_Rescan}
  function FT_Rescan                 (                                          ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_Reload}
  function FT_Reload                 ( wVid             : WORD;
                                       wPid             : WORD                  ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetComPortNumber}
  function FT_GetComPortNumber       ( ftHandle         : FT_HANDLE;
                                       lpdwComPortNumber: LPLONG                ): FT_STATUS; stdcall;
// FT232H additional EEPROM s
{$EXTERNALSYM FT_EE_ReadConfig}
  function FT_EE_ReadConfig          ( ftHandle         : FT_HANDLE;
                                       ucAddress        : UCHAR;
                                       pucValue         : PUCHAR                ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EE_WriteConfig}
  function FT_EE_WriteConfig         ( ftHandle         : FT_HANDLE;
                                       ucAddress        : UCHAR;
                                       ucValue          : UCHAR                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_EE_ReadECC}
  function FT_EE_ReadECC             ( ftHandle         : FT_HANDLE;
                                       ucOption         : UCHAR;
                                       lpwValue         : LPWORD                ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_GetQueueStatusEx}
  function FT_GetQueueStatusEx       ( ftHandle         : FT_HANDLE;
                                   var dwRxBytes        : DWORD                 ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_ComPortIdle}
  function FT_ComPortIdle            ( ftHandle         : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_ComPortCancelIdle}
  function FT_ComPortCancelIdle      ( ftHandle         : FT_HANDLE             ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_VendorCmdGet}
  function FT_VendorCmdGet           ( ftHandle         : FT_HANDLE;
                                       Request          : UCHAR;
                                   var Buf              : UCHAR;
                                       Len              : USHORT                ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_VendorCmdSet}
  function FT_VendorCmdSet           ( ftHandle         : FT_HANDLE;
                                       Request          : UCHAR;
                                   var Buf              : UCHAR;
                                       Len              : USHORT                ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_VendorCmdGetEx}
  function FT_VendorCmdGetEx         ( ftHandle         : FT_HANDLE;
                                       wValue           : USHORT;
                                   var Buf              : UCHAR;
                                       Len              : USHORT                ): FT_STATUS; stdcall;
{$EXTERNALSYM FT_VendorCmdSetEx}
  function FT_VendorCmdSetEx         ( ftHandle         : FT_HANDLE;
                                        wValue          : USHORT;
                                    var Buf             : UCHAR;
                                        Len             : USHORT                ): FT_STATUS; stdcall;


  procedure FT_Error_Report(ErrStr: string; PortStatus: Integer);
  procedure FT_AddToBuffer(DeviceIndex: Integer; Data: Byte);
  function  FT_DevInd(DeviceName: string): Integer;                        // vrne DeviceIndex od imena naprave, ce jo ne najde, vrne -1
  function  FT_ReadFromDevice(DeviceIndex: Integer; NumberOfBytes: Cardinal; Mesage: Boolean): Cardinal;
  function  FT_WriteToDevice(DeviceIndex, NumberOfBytes: Integer): FT_Status;
  function  FT_AllDevice_Init: FT_Status;
  function  FT_ArrayToAString(const a: array of AnsiChar): AnsiString;


var
//  LibHandle: Integer = 0;
  FT_Device_Count: DWord          = 0;
  FT_Enable_Error_Report: Boolean = True;
  FT_DeviceInfoList: array of TFT_Device_List_Info_Node;
  FT_DEVICE_DATA: Array of TFT_DEVICE_DATA;


implementation
  const FT_DLL_Name = 'ftd2xx.dll';

  function FT_Open;                   external FT_DLL_Name name 'FT_Open';
  function FT_OpenEx;                 external FT_DLL_Name name 'FT_OpenEx';
  function FT_ListDevices;            external FT_DLL_Name name 'FT_ListDevices';
  function FT_Close;                  external FT_DLL_Name name 'FT_Close';
  function FT_Read;                   external FT_DLL_Name name 'FT_Read';
  function FT_Write;                  external FT_DLL_Name name 'FT_Write';
  function FT_IoCtl;                  external FT_DLL_Name name 'FT_IoCtl';
  function FT_SetBaudRate;            external FT_DLL_Name name 'FT_SetBaudRate';
  function FT_SetDivisor;             external FT_DLL_Name name 'FT_SetDivisor';
  function FT_SetDataCharacteristics; external FT_DLL_Name name 'FT_SetDataCharacteristics';
  function FT_SetFlowControl;         external FT_DLL_Name name 'FT_SetFlowControl';
  function FT_ResetDevice;            external FT_DLL_Name name 'FT_ResetDevice';
  function FT_SetDtr;                 external FT_DLL_Name name 'FT_SetDtr';
  function FT_ClrDtr;                 external FT_DLL_Name name 'FT_ClrDtr';
  function FT_SetRts;                 external FT_DLL_Name name 'FT_SetRts';
  function FT_ClrRts;                 external FT_DLL_Name name 'FT_ClrRts';
  function FT_GetModemStatus;         external FT_DLL_Name name 'FT_GetModemStatus';
  function FT_SetChars;               external FT_DLL_Name name 'FT_SetChars';
  function FT_Purge;                  external FT_DLL_Name name 'FT_Purge';
  function FT_SetTimeouts;            external FT_DLL_Name name 'FT_SetTimeouts';
  function FT_GetQueueStatus;         external FT_DLL_Name name 'FT_GetQueueStatus';
  function FT_SetEventNotification;   external FT_DLL_Name name 'FT_SetEventNotification';
  function FT_GetStatus;              external FT_DLL_Name name 'FT_GetStatus';
  function FT_SetBreakOn;             external FT_DLL_Name name 'FT_SetBreakOn';
  function FT_SetBreakOff;            external FT_DLL_Name name 'FT_SetBreakOff';
  function FT_SetWaitMask;            external FT_DLL_Name name 'FT_SetWaitMask';
  function FT_WaitOnMask;             external FT_DLL_Name name 'FT_WaitOnMask';
  function FT_GetEventStatus;         external FT_DLL_Name name 'FT_GetEventStatus';
  function FT_ReadEE;                 external FT_DLL_Name name 'FT_ReadEE';
  function FT_WriteEE;                external FT_DLL_Name name 'FT_WriteEE';
  function FT_EraseEE;                external FT_DLL_Name name 'FT_EraseEE';
  function FT_EE_Program;             external FT_DLL_Name name 'FT_EE_Program';
  function FT_EE_ProgramEx;           external FT_DLL_Name name 'FT_EE_ProgramEx';
  function FT_EE_Read;                external FT_DLL_Name name 'FT_EE_Read';
  function FT_EE_ReadEx;              external FT_DLL_Name name 'FT_EE_ReadEx';
  function FT_EE_UASize;              external FT_DLL_Name name 'FT_EE_UASize';
  function FT_EE_UAWrite;             external FT_DLL_Name name 'FT_EE_UAWrite';
  function FT_EE_UARead;              external FT_DLL_Name name 'FT_EE_UARead';
  function FT_EEPROM_Read;            external FT_DLL_Name name 'FT_EEPROM_Read';
  function FT_EEPROM_Program;         external FT_DLL_Name name 'FT_EEPROM_Program';
  function FT_SetLatencyTimer;        external FT_DLL_Name name 'FT_SetLatencyTimer';
  function FT_GetLatencyTimer;        external FT_DLL_Name name 'FT_GetLatencyTimer';
  function FT_SetBitMode;             external FT_DLL_Name name 'FT_SetBitMode';
  function FT_GetBitMode;             external FT_DLL_Name name 'FT_GetBitMode';
  function FT_SetUSBParameters;       external FT_DLL_Name name 'FT_SetUSBParameters';
  function FT_SetDeadmanTimeout;      external FT_DLL_Name name 'FT_SetDeadmanTimeout';
  function FT_GetDeviceLocId;         external FT_DLL_Name name 'FT_GetDeviceLocId';
  function FT_GetDeviceInfo;          external FT_DLL_Name name 'FT_GetDeviceInfo';
  function FT_StopInTask;             external FT_DLL_Name name 'FT_StopInTask';
  function FT_RestartInTask;          external FT_DLL_Name name 'FT_RestartInTask';
  function FT_SetResetPipeRetryCount; external FT_DLL_Name name 'FT_SetResetPipeRetryCount';
  function FT_ResetPort;              external FT_DLL_Name name 'FT_ResetPort';
  function FT_CyclePort;              external FT_DLL_Name name 'FT_CyclePort';
  function FT_W32_CreateFile;         external FT_DLL_Name name 'FT_W32_CreateFile';
  function FT_W32_CloseHandle;        external FT_DLL_Name name 'FT_W32_CloseHandle';
  function FT_W32_ReadFile;           external FT_DLL_Name name 'FT_W32_ReadFile';
  function FT_W32_WriteFile;          external FT_DLL_Name name 'FT_W32_WriteFile';
  function FT_W32_GetLastError;       external FT_DLL_Name name 'FT_W32_GetLastError';
  function FT_W32_GetOverlappedResult;external FT_DLL_Name name 'FT_W32_GetOverlappedResult';
  function FT_W32_CancelIo;           external FT_DLL_Name name 'FT_W32_CancelIo';
  function FT_W32_ClearCommBreak;     external FT_DLL_Name name 'FT_W32_ClearCommBreak';
  function FT_W32_ClearCommError;     external FT_DLL_Name name 'FT_W32_ClearCommError';
  function FT_W32_EscapeCommFunction; external FT_DLL_Name name 'FT_W32_EscapeCommFunction';
  function FT_W32_GetCommModemStatus; external FT_DLL_Name name 'FT_W32_GetCommModemStatus';
  function FT_W32_GetCommState;       external FT_DLL_Name name 'FT_W32_GetCommState';
  function FT_W32_GetCommTimeouts;    external FT_DLL_Name name 'FT_W32_GetCommTimeouts';
  function FT_W32_PurgeComm;          external FT_DLL_Name name 'FT_W32_PurgeComm';
  function FT_W32_SetCommBreak;       external FT_DLL_Name name 'FT_W32_SetCommBreak';
  function FT_W32_SetCommMask;        external FT_DLL_Name name 'FT_W32_SetCommMask';
  function FT_W32_GetCommMask;        external FT_DLL_Name name 'FT_W32_GetCommMask';
  function FT_W32_SetCommState;       external FT_DLL_Name name 'FT_W32_SetCommState';
  function FT_W32_SetCommTimeouts;    external FT_DLL_Name name 'FT_W32_SetCommTimeouts';
  function FT_W32_SetupComm;          external FT_DLL_Name name 'FT_W32_SetupComm';
  function FT_W32_WaitCommEvent;      external FT_DLL_Name name 'FT_W32_WaitCommEvent';
  function FT_CreateDeviceInfoList;   external FT_DLL_Name name 'FT_CreateDeviceInfoList';
  function FT_GetDeviceInfoList;      external FT_DLL_Name name 'FT_GetDeviceInfoList';
  function FT_GetDeviceInfoDetail;    external FT_DLL_Name name 'FT_GetDeviceInfoDetail';
  function FT_GetDriverVersion;       external FT_DLL_Name name 'FT_GetDriverVersion';
  function FT_GetLibraryVersion;      external FT_DLL_Name name 'FT_GetLibraryVersion';
  function FT_Rescan;                 external FT_DLL_Name name 'FT_Rescan';
  function FT_Reload;                 external FT_DLL_Name name 'FT_Reload';
  function FT_GetComPortNumber;       external FT_DLL_Name name 'FT_GetComPortNumber';
  function FT_EE_ReadConfig;          external FT_DLL_Name name 'FT_EE_ReadConfig';
  function FT_EE_WriteConfig;         external FT_DLL_Name name 'FT_EE_WriteConfig';
  function FT_EE_ReadECC;             external FT_DLL_Name name 'FT_EE_ReadECC';
  function FT_GetQueueStatusEx;       external FT_DLL_Name name 'FT_GetQueueStatusEx';
  function FT_ComPortIdle;            external FT_DLL_Name name 'FT_ComPortIdle';
  function FT_ComPortCancelIdle;      external FT_DLL_Name name 'FT_ComPortCancelIdle';
  function FT_VendorCmdGet;           external FT_DLL_Name name 'FT_VendorCmdGet';
  function FT_VendorCmdSet;           external FT_DLL_Name name 'FT_VendorCmdSet';
  function FT_VendorCmdGetEx;         external FT_DLL_Name name 'FT_VendorCmdGetEx';
  function FT_VendorCmdSetEx;         external FT_DLL_Name name 'FT_VendorCmdSetEx';
{$ifdef FTD2XX_STATIC}
  function FT_Initialise;             external FT_DLL_Name name 'FT_Initialise';
  procedure FT_Finalise;              external FT_DLL_Name name 'FT_Finalise';
{$endif}	// FTD2XX_STATIC

/////// RLS FUNKCIJE

procedure FT_Error_Report(ErrStr: string; PortStatus: Integer);
var
  Str: string;
begin
  if not FT_Enable_Error_Report then Exit;
  if PortStatus = FT_OK then Exit;
  case PortStatus of
    FT_INVALID_HANDLE             : Str := 'Invalid handle...'             + #13#10+ ErrStr;
    FT_DEVICE_NOT_FOUND           : Str := 'Device not found...'           + #13#10+ ErrStr;
    FT_DEVICE_NOT_OPENED          : Str := 'Device not opened...'          + #13#10+ ErrStr;
    FT_IO_ERROR                   : Str := 'General IO error...'           + #13#10+ ErrStr;
    FT_INSUFFICIENT_RESOURCES     : Str := 'Insufficient resources...'     + #13#10+ ErrStr;
    FT_INVALID_PARAMETER          : Str := 'Invalid parameter...'          + #13#10+ ErrStr;
    FT_INVALID_BAUD_RATE          : Str := 'Invalid baud rate...'          + #13#10+ ErrStr;
    FT_DEVICE_NOT_OPENED_FOR_ERASE: Str := 'Device not opened for erase...'+ #13#10+ ErrStr;
    FT_DEVICE_NOT_OPENED_FOR_WRITE: Str := 'Device not opened for write...'+ #13#10+ ErrStr;
    FT_FAILED_TO_WRITE_DEVICE     : Str := 'Failed to write...'            + #13#10+ ErrStr;
    FT_EEPROM_READ_FAILED         : Str := 'EEPROM read failed...'         + #13#10+ ErrStr;
    FT_EEPROM_WRITE_FAILED        : Str := 'EEPROM write failed...'        + #13#10+ ErrStr;
    FT_EEPROM_ERASE_FAILED        : Str := 'EEPROM erase failed...'        + #13#10+ ErrStr;
    FT_EEPROM_NOT_PRESENT         : Str := 'EEPROM not present...'         + #13#10+ ErrStr;
    FT_EEPROM_NOT_PROGRAMMED      : Str := 'EEPROM not programmed...'      + #13#10+ ErrStr;
    FT_INVALID_ARGS               : Str := 'Invalid arguments...'          + #13#10+ ErrStr;
    FT_OTHER_ERROR                : Str := 'Other error ...'               + #13#10+ ErrStr;
  end;
  MessageDlg(Str, mtError, [mbOk], 0);
end;

function FT_DevInd(DeviceName: string): Integer; // vrne DeviceIndex od imena naprave, ce jo ne najde, vrne -1
var
  I: Integer;
begin
  Result := -1;
  if Length(FT_DeviceInfoList) < 1 then Exit;
  for I := 0 to Length(FT_DeviceInfoList) - 1 do
  begin
    if string(FT_DeviceInfoList[I].Description) = DeviceName then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

procedure FT_AddToBuffer(DeviceIndex: Integer; Data: Byte);
begin
  if DeviceIndex < 0 then Exit;
  FT_Device_Data[DeviceIndex].Buffer_Out[FT_Device_Data[DeviceIndex].OutIndex] := Data and $FF; // na koncu dam data
  Inc(FT_Device_Data[DeviceIndex].OutIndex);
end;

function FT_ReadFromDevice(DeviceIndex: Integer; NumberOfBytes: Cardinal; Mesage: Boolean): Cardinal;
var
  NrBytesRead: Cardinal;
  IO_St: FT_Status;
begin
  Result := 0;
  if (NumberOfBytes = 0) then
  begin
    NrBytesRead := 0;
    Exit;
  end;
  if DeviceIndex < 0 then Exit;

  IO_St := FT_Read(FT_DeviceInfoList[DeviceIndex].DeviceHandle, @FT_Device_Data[DeviceIndex].Buffer_In, NumberOfBytes, @NrBytesRead);
  if IO_St <> FT_OK then FT_Error_Report('FT_Read', IO_St);
  if (NumberOfBytes > NrBytesRead) and Mesage then
  begin
    if NrBytesRead = 1 then
      MessageDlg('Read timeout error' + #13#13 + 'Namesto ' + IntToStr(NumberOfBytes) + ' je bilo prebrano samo 1 bajt.', mtError, [mbOk], 0);
    if NrBytesRead = 2 then
      MessageDlg('Read timeout error' + #13#13 + 'Namesto ' + IntToStr(NumberOfBytes) + ' je bilo prebrano samo 2 bajta.', mtError, [mbOk], 0);
    if NrBytesRead > 2 then
      MessageDlg('Read timeout error' + #13#13 + 'Namesto ' + IntToStr(NumberOfBytes) + ' je bilo prebranih samo ' + IntToStr(NrBytesRead)+ ' bajtov.', mtError, [mbOk], 0);
  end;
  Result := NrBytesRead;
end;


function FT_WriteToDevice(DeviceIndex, NumberOfBytes: Integer): FT_Status;
var
//  Write_Result: Integer;
  Write_Result: Cardinal;
begin
  if DeviceIndex < 0 then
  begin
    Result := 17; // other error
    Exit;
  end;
  Result := FT_Write(FT_DeviceInfoList[DeviceIndex].DeviceHandle, @FT_Device_Data[DeviceIndex].Buffer_Out, NumberOfBytes, @Write_Result);
  if Result <> FT_OK then FT_Error_Report('FT_Write', Result);
  FT_Device_Data[DeviceIndex].OutIndex := FT_Device_Data[DeviceIndex].OutIndex - Write_Result;
end;

function FT_AllDevice_Init: FT_Status;
var
  I, J: Integer;
begin
  // kreiram DeviceInfoList
  Result := FT_CreateDeviceInfoList(@FT_Device_Count);
  if Result <> FT_OK then
  begin
    FT_Error_Report('FT_CreateDeviceInfoList', Result);
    Exit;
  end;
  // nafilam listo s podatki
  SetLength(FT_DeviceInfoList, FT_Device_Count);
  Result := FT_GetDeviceInfoList(FT_DeviceInfoList, @FT_Device_Count);
  if Result <> FT_OK then
  begin
    FT_Error_Report('FT_GetDeviceInfoList', Result);
    Exit;
  end;
  SetLength(FT_Device_Data, FT_Device_Count);      // pripravim bufferje
  for I := 0 to FT_Device_Count - 1 do
  begin
    for J := 0 to Length(FT_Device_Data[I].Buffer_In) - 1 do
    begin
      FT_Device_Data[I].Buffer_In[J] := $00;
      FT_Device_Data[I].Buffer_Out[J] := $00;
    end;
    FT_Device_Data[I].Q_Bytes := 0;
    FT_Device_Data[I].TxQ_Bytes := 0;
    FT_Device_Data[I].OutIndex := 0;
  end;
end;

function FT_ArrayToAString(const a: array of AnsiChar): AnsiString;
var
  I, Len: Integer;
begin
  Result := '';
  if Length(a) > 0 then
  begin
    Len := Length(a);
    for I := 0 to Length(a) - 1 do
      if a[I] = #0 then
      begin
        Len := I;
        Break;
      end;
    for I := 0 to Len - 1 do
      Result := Result + a[I];
  end;
end;


end.



