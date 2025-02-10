unit ME4670_RLS;

interface

uses
  Forms,
  Windows, Messages,
  meIDS, meError,
  ClipBrd, StrUtils, Math, Classes,
  Dialogs, SysUtils,
  IniFiles,
  Mmsystem
  ;


  function ME4670_NastaviNapetost(Kanal: Integer; Napetost: Double): Double; // Nastavi napetost v voltih



  function ME4670_Poglej_SN(var Serijska: Integer): Integer;   // pogleda serijsko od prve ME4670 kartice, ki jo najde
  function ME4670_Nastavi_DIO_Port(DIO_Port, FunkcijaPorta: Integer): Integer;
  function ME4670_FindDeviceIndex: Integer;   // Najde index kartice ME4670 in ce je sploh prisotna
  function ME4670_GetByte(DIO_Port: Integer; var PortValue: Byte): Integer;
  function ME4670_GetBit(DIO_Port, BitNr: Integer; var BitValue: Integer): Integer;
  function ME4670_SetByte(DIO_Port: Integer; PortValue: Byte): Integer;
  function ME4670_SetBit(DIO_Port, BitNr, BitValue: Integer): Integer;
  function ME4670_MeriNapetost(Kanal: Integer): Double; // vrne vrednost v voltih
  function ME4670_Nastavi_AI_Zajemanje: Integer;
  function ME4670_Zacni_AI_Zajemanje: Integer;
  function ME4670_PWM_Start(DutyCycle: Integer): Integer;
  function ME4670_PWM_Stop: Integer;
  function ME4670_Stream_Stop: Integer;
  function ME4670_StreamIsRunning: Boolean;
  function ME4670_PocakajNaKonecStraminga(MaxCas: Double): Boolean;  // Najvecji cas cakanja je v milisekundah

  function StreamReadNewValuesCallback(iDevice: Integer; iSubdevice: Integer; iCount: Integer; pvContext: Pointer; iErrorCode: Integer): Integer; stdcall;
  function StreamReadStartCallback(iDevice: Integer; iSubdevice: Integer; iCount: Integer; pvContext: Pointer; iErrorCode: Integer): Integer; stdcall;
  function StreamReadEndCallback(iDevice: Integer; iSubdevice: Integer; iCount: Integer; pvContext: Pointer; iErrorCode: Integer): Integer; stdcall;

type
   TME4670_AI_Config= record
     MerRange     : Integer;           // Index za merilno obmocje (-10V do +10V, 0 do +10V, -2.5V do +2.5V, 0 do +2.5V)
     AI_Groud_Type: Integer;           // ME_REF_AI_GROUND ali ME_REF_AI_DIFFERENTIAL
     ScanType     : Integer;           // ME4670_AISM_TRIGGER ali  ME4670_AISM_CASOVNO
     ChanList     : array of Integer;  // Seznam kanalov za merjenje ob scanu
     ChanTime     : Double;            // Cas pavze med kanali iz ChanListe v ms
     ScanTime     : Double;            // Cas med dvema scanoma v ms
     AcqStartType : Integer;           // Kako naj se glavna mertev zacne (ME_TRIG_TYPE_SW ali ME_TRIG_TYPE_EXT_DIGITAL)
     StevKanalov  : Integer;           // Koliko je dolzina ChanListe
     MaxSamplesNr : Integer;           // Po koliko vzorcenjih naj se samplanje neha. Ce je tu 0, potem stevilo vzorcev ni omejeno.
   end;

const
// subdevice indexi za DIO porte
  ME4670_DIO_A = 0;
  ME4670_DIO_B = 1;
  ME4670_DIO_C = 2;
  ME4670_DIO_D = 3;

  ME4670_AI_RANGE_BIPOLAR_10 = 0;
  ME4670_AI_RANGE_UNIPOLAR_10= 1;
  ME4670_AI_RANGE_BIPOLAR_25 = 2;
  ME4670_AI_RANGE_UNIPOLAR_25= 3;

  ME4670_AISM_TRIGGER = 0;                          // Nacin samplanja analognih signalov, seznam se triga na digitalni triger
  ME4670_AISM_CASOVNO = 1;                          // Nacin samplanja analognih signalov, seznam se triga na casovne intervale

  ME4670_AISM_START_SW = 0;                         // Nacin zacetka vzorcenja, pozene se softwersko               SM je ScanMode
  ME4670_AISM_START_HW = 1;                         // Nacin zacetka vzorcenja, pozene se z digitalnim trigerjem

  ME4670_COUNTER_0=  9;
  ME4670_COUNTER_1= 10;
  ME4670_COUNTER_2= 11;

var
  ME_Err: Integer;
  ME4670_DevInd: Integer;                           // index kartice ME4670
  ME4670_Buff_An_Mer: array [0..7499999]of Single;  // pri 2탎 ticku in 32 kanalih je to za 15s bufferja
  ME4670_Ind_An_Buff: Integer;                      // index zadnje pomerjene vrednosti. Pri startu meritve bo sel index na 0
  ME4670_AI_Config: TME4670_AI_Config;              // vse nastavitve od analognega merjenja
  ME4670_AI_EncPos: array of Integer;               // ce se ob merjenju uporablja enkoder, se sem shranjujejo polozaji enkoderja

implementation
//uses
//  RingMag_Funkcije,
//  RingMag_Spremenljivke;
//  RingMag_Threads,
//  RingMag_Main;


function ME4670_FindDeviceIndex: Integer;   // Najde index kartice ME4670 in ce je sploh prisotna
var
  I, StNaprav: Integer;
  DevName: array[0..ME_DEVICE_NAME_MAX_COUNT- 1] of AnsiChar;
  BusNo: Integer;
  VendorId: Integer;
  DeviceId: Integer;
  FuncNo: Integer;
  BusType: Integer;
  DevNo: Integer;
  SerialNo: Integer;
  Plugged: Integer;
begin
  ME4670_DevInd := -1;
  Result := meQueryNumberDevices(StNaprav);
  if StNaprav > 0 then
  begin
    for I := 0 to StNaprav- 1 do
    begin
       Result := meQueryNameDevice(I, DevName, ME_DEVICE_NAME_MAX_COUNT);
       if DevName= 'ME-4670' then
       begin
         Result := meQueryInfoDevice(I, VendorId, DeviceId, SerialNo, BusType, BusNo, DevNo, FuncNo, Plugged);
         if Plugged = ME_PLUGGED_IN then ME4670_DevInd := I;
         Break;
       end;
    end;
  end;
end;

function ME4670_Poglej_SN(var Serijska: Integer): Integer;   // pogleda serijsko od prve ME4670 kartice, ki jo najde
var
  I, StNaprav: Integer;
  BusNo: Integer;
  VendorId: Integer;
  DeviceId: Integer;
  FuncNo: Integer;
  BusType: Integer;
  DevNo: Integer;
  SerialNo: Integer;
  Plugged: Integer;
begin
  Serijska := -1;
  Result := meQueryInfoDevice(ME4670_DevInd, VendorId, DeviceId, SerialNo, BusType, BusNo, DevNo, FuncNo, Plugged);
  if Plugged = ME_PLUGGED_IN then Serijska := SerialNo;
  if Serijska = -1 then ShowMessage('Kartica ME-4670 ni bila zaznana!');
end;

function ME4670_Nastavi_DIO_Port(DIO_Port, FunkcijaPorta: Integer): Integer;
begin
  Result := meIOSingleConfig(ME4670_DevInd,                  //  iDevice
                             DIO_Port,                       //  iSubDevice
                             0,                              //  iChannel
                             FunkcijaPorta,                  //  iSingleConfig
                             ME_REF_NONE,                    //  iRef
                             ME_TRIG_CHAN_NONE,              //  iTrigChan
                             ME_TRIG_TYPE_NONE,              //  iTrigtype
                             ME_TRIG_EDGE_NONE,              //  iTrigedge
                             ME_IO_SINGLE_CONFIG_DIO_BYTE);  //  iFlags
end;

function ME4670_GetByte(DIO_Port: Integer; var PortValue: Byte): Integer;
var
  IO_Single: array[0..0] of TMeIOSingle;
begin
  IO_Single[0].iDevice    := ME4670_DevInd;
  IO_Single[0].iSubDevice := DIO_Port;
  IO_Single[0].iChannel   := 0;
  IO_Single[0].iDir       := ME_DIR_INPUT;
  IO_Single[0].iValue     := 0;
  IO_Single[0].iTimeOut   := 0;
  IO_Single[0].iFlags     := ME_IO_SINGLE_CONFIG_DIO_BYTE;
  IO_Single[0].iErrno     := 0;
  Result := meIOSingle(IO_Single[0], 1, ME_IO_SINGLE_NO_FLAGS);
  PortValue := IO_Single[0].iValue and $FF;
end;

function ME4670_GetBit(DIO_Port, BitNr: Integer; var BitValue: Integer): Integer;
var
  Bv: Byte;
  Maska :Byte;
begin
  Result := ME4670_GetByte(DIO_Port, Bv);
  BitValue := Bv and (1 shl BitNr);
  if BitValue <> 0 then BitValue := 1;
end;

function ME4670_SetByte(DIO_Port: Integer; PortValue: Byte): Integer;
var
  IO_Single: array[0..0] of TMeIOSingle;
begin
  IO_Single[0].iDevice    := ME4670_DevInd;
  IO_Single[0].iSubDevice := DIO_Port;
  IO_Single[0].iChannel   := 0;
  IO_Single[0].iDir       := ME_DIR_OUTPUT;
  IO_Single[0].iValue     := PortValue and $FF;
  IO_Single[0].iTimeOut   := 0;
  IO_Single[0].iFlags     := ME_IO_SINGLE_CONFIG_DIO_BYTE;
  IO_Single[0].iErrno     := 0;
  Result := meIOSingle(IO_Single[0], 1, ME_IO_SINGLE_NO_FLAGS);
end;

function ME4670_SetBit(DIO_Port, BitNr, BitValue: Integer): Integer;
var
  Bv : Byte;
begin
  if BitNr < 0 then BitNr := 0;
  if BitNr > 7 then BitNr := 7;
  ME4670_GetByte(DIO_Port, Bv);
  if BitValue= 0 then
    Bv := Bv and not(1 shl BitNr)
  else
    Bv := Bv or (1 shl BitNr);
  Result := ME4670_SetByte(DIO_Port, Bv);
end;

function ME4670_MeriNapetost(Kanal: Integer): Double; // vrne vrednost v voltih, operacija traja cca 31 탎
var
  IO_Single: array[0..0] of TMeIOSingle;
  physMax: Double;
  iUnit: Integer;
  physMin: Double;
  digitalMax: Integer;
  Vrednost: Double;
begin
// nastavim branje, ta operacija traja cca 2 탎
  meIOSingleConfig(ME4670_DevInd,
                   4,                // Subdevice 4 je AI
                   Kanal,
                   ME4670_AI_RANGE_BIPOLAR_10,
                   ME_REF_AI_GROUND,
                   ME_TRIG_CHAN_DEFAULT,
                   ME_TRIG_TYPE_SW,
                   ME_VALUE_NOT_USED,
                   ME_IO_SINGLE_CONFIG_NO_FLAGS);
// Berem vrednost, ta operacija traja cca 29 탎   ne splaca se brati 32 vrednosti naenkrat, ker traja isto dolgo
  IO_Single[0].iDevice    := ME4670_DevInd;
  IO_Single[0].iSubDevice := 4;               // Subdevice 4 je AI
  IO_Single[0].iChannel   := Kanal;
  IO_Single[0].iDir       := ME_DIR_INPUT;
  IO_Single[0].iValue     := 0;
  IO_Single[0].iTimeOut   := 0;
  IO_Single[0].iFlags     := ME_IO_SINGLE_TYPE_NO_FLAGS;
  IO_Single[0].iErrno     := 0;
  meIOSingle(IO_Single[0],  1,  ME_IO_SINGLE_NO_FLAGS);
// pretvorim v vrednost
  meQueryRangeInfo(ME4670_DevInd, 4, ME4670_AI_RANGE_BIPOLAR_10, iUnit, PhysMin, PhysMax, DigitalMax);
  meUtilityDigitalToPhysical(PhysMin, PhysMax, DigitalMax, IO_Single[0].iValue, ME_VALUE_NOT_USED, 0, Vrednost);
  Result := Vrednost;
end;


function StreamReadStartCallback(iDevice: Integer; iSubdevice: Integer; iCount: Integer; pvContext: Pointer; iErrorCode: Integer): Integer; stdcall;
var
  plStatus: Integer;
  plCount: Integer;
begin
{
  Form1.FTRecEncPos := TRecEncPos.Create(True);
  Form1.FTRecEncPos.FreeOnTerminate := False;
  Form1.FTRecEncPos.Priority := tpHighest;                // Set the priority to lower than normal.
  Form1.FTRecEncPos.Start;                                // Now run the thread.
}
  Result := 0;
end;

function StreamReadEndCallback(iDevice: Integer; iSubdevice: Integer; iCount: Integer; pvContext: Pointer; iErrorCode: Integer): Integer; stdcall;
var
  I: Integer;
  Bufi: array[0..4095] of Integer;
  Ptr: Integer;
  Str: string;
  physMax: Double;
  iUnit: Integer;
  physMin: Double;
  digitalMax: Integer;
  Vr: Double;
begin
{
  if Form1.FTRecEncPos <> nil then
  begin
    Form1.FTRecEncPos.Terminate;
    Form1.FTRecEncPos.WaitFor;
    FreeAndNil(Form1.FTRecEncPos);
  end;
}
  Result := 0;
end;

function StreamReadNewValuesCallback(iDevice: Integer; iSubdevice: Integer; iCount: Integer; pvContext: Pointer; iErrorCode: Integer): Integer; stdcall;
var
  I: Integer;
//  Bufi: array[0..4095] of Integer;
  Bufi: array[0..8191] of Integer;
//  Bufi: array[0..16381] of Integer;
  Ptr: Integer;
  Str: string;
  physMax: Double;
  iUnit: Integer;
  physMin: Double;
  digitalMax: Integer;
  Vr: Double;
begin
  if iCount > 0 then
  begin
    ME_Err := meIOStreamRead(iDevice,                    // Device index
                             iSubdevice,                 // Subdevice index,
                             ME_READ_MODE_NONBLOCKING,
//                             ME_READ_MODE_BLOCKING,
                             Bufi[0],
                             iCount,                      // Size of buffer in data values - Number of data values returned here
                             ME_IO_STREAM_READ_FRAMES );
    if ME_Err <> 0 then ME4670_Stream_Stop;
  end;
  if iCount > 0 then
  begin
    meQueryRangeInfo(ME4670_DevInd, 4, ME4670_AI_Config.MerRange, iUnit, PhysMin, PhysMax, DigitalMax);
    for I := 0 to iCount- 1 do
    begin
      meUtilityDigitalToPhysical(PhysMin, PhysMax, DigitalMax, Bufi[I], ME_VALUE_NOT_USED, 0, Vr);
      ME4670_Buff_An_Mer[ME4670_Ind_An_Buff mod 7500000] := Vr;
      ME4670_Ind_An_Buff := (ME4670_Ind_An_Buff+ 1);
    end;
  end;

  if (ME4670_AI_Config.MaxSamplesNr > 0) and (ME4670_Ind_An_Buff >= ME4670_AI_Config.MaxSamplesNr* ME4670_AI_Config.StevKanalov) then
  begin
    ME4670_Stream_Stop;
  end;
  Result := 0;
end;

function ME4670_Nastavi_AI_Zajemanje: Integer;
var
  I: Integer;
  StMeritev: Integer;                       // Stevilo skupnih meritev ob enem samplu
  Acq_TckL, Acq_TckH: Integer;
  Scan_TckL, Scan_TckH: Integer;
  Conv_TckL, Conv_TckH: Integer;
  d_Time: Double;

  Acq_DelayTime: Double;
  Stream_Config : array of TMeIOStreamConfig;
  Stream_Trigger: TMeIOStreamTrigger;
  WW: meIOStreamCB_t;
  FlushNr: Integer;
begin
  if (ME4670_AI_Config.ScanType < 0) or (ME4670_AI_Config.ScanType > 1) then
  begin
    Result := 93;   // ME_ERRNO_PROPERTY_VALUE_INVALID
    Exit;
  end;
  ME4670_AI_Config.ChanTime := ME4670_AI_Config.ChanTime/1000;                                     // pretvorim v sekunde
  ME4670_AI_Config.ScanTime := ME4670_AI_Config.ScanTime/1000;                                     // pretvorim v sekunde
	ME_Err := meIOStreamSetCallbacks( ME4670_DevInd,               // Device index
                                    4,                           // Subdevice index
                                    StreamReadStartCallback,     // Start callback
                                    0,                           // Start callback context
                                    StreamReadNewValuesCallback, // New values callback
                                    0,                           // New values callback context
                                    StreamReadEndCallback,       // End callback
                                    0,                           // End callback context
                                    ME_IO_STREAM_SET_CALLBACKS_NO_FLAGS ); // Flags

  Acq_DelayTime := 0;
  ME_Err := meIOStreamTimeToTicks( ME4670_DevInd,               // Device index
                                   4,                           // Subdevice index,
                                   ME_TIMER_ACQ_START,          // Timer used
                                   Acq_DelayTime,               // Required time seconds, Achieved time returned here
                                   Acq_TckL,                    // Lower 32 bits of the corresponding tick value returned here
                                   Acq_TckH,                    // Upper 32 bits of the corresponding tick value returned here
                                   ME_IO_FREQUENCY_TO_TICKS_NO_FLAGS); // No flags

  if ME4670_AI_Config.ScanType= ME4670_AISM_TRIGGER then ME4670_AI_Config.ScanTime := 0;
  ME_Err := meIOStreamTimeToTicks( ME4670_DevInd,               // Device index
                                   4,                           // Subdevice index,
                                   ME_TIMER_SCAN_START,         // Timer used
                                   ME4670_AI_Config.ScanTime,   // Required time seconds, Achieved time returned here
                                   Scan_TckL,                   // Lower 32 bits of the corresponding tick value returned here
                                   Scan_TckH,                   // Upper 32 bits of the corresponding tick value returned here
                                   ME_IO_FREQUENCY_TO_TICKS_NO_FLAGS); // No flags
  ME4670_AI_Config.ScanTime := ME4670_AI_Config.ScanTime* 1000; //Rezultat bo v ms

  ME_Err := meIOStreamTimeToTicks( ME4670_DevInd,               // Device index
                                   4,                           // Subdevice index,
                                   ME_TIMER_CONV_START,         // Timer used
                                   ME4670_AI_Config.ChanTime,   // Required time seconds, Achieved time returned here
                                   Conv_TckL,                   // Lower 32 bits of the corresponding tick value returned here
                                   Conv_TckH,                   // Upper 32 bits of the corresponding tick value returned here
                                   ME_IO_FREQUENCY_TO_TICKS_NO_FLAGS); // No flags
  ME4670_AI_Config.ChanTime := ME4670_AI_Config.ChanTime* 1000; //Rezultat bo v ms

/////////////////////////////////
  SetLength(Stream_Config, Length(ME4670_AI_Config.ChanList));
  for I := 0 to Length(ME4670_AI_Config.ChanList)- 1 do
  begin
    Stream_Config[I].iChannel      := ME4670_AI_Config.ChanList[I];  // Channel index
    Stream_Config[I].iStreamConfig := ME4670_AI_Config.MerRange;     // Index of analog input range
    Stream_Config[I].iRef          := ME4670_AI_Config.AI_Groud_Type;// Defines the ground reference for analog inputs
    Stream_Config[I].iFlags        := ME_IO_STREAM_CONFIG_TYPE_NO_FLAGS;
  end;

  FlushNr := Length(ME4670_AI_Config.ChanList);
  Stream_Trigger := Default(TMeIOStreamTrigger);                     // Inicializacija spremenljivke z samimi nulami. Manual ME-iDS na strani 59 pravi, da daj 0 na nepomembne parametre

  if (ME4670_AI_Config.ScanType    = ME4670_AISM_CASOVNO) and
     (ME4670_AI_Config.AcqStartType= ME_TRIG_TYPE_SW    ) then       // Starti: Acq na SW , Scan na timer, Conv na timer
  begin
    Stream_Trigger.iAcqStartTrigType   := ME_TRIG_TYPE_SW;           // Defines the trigger type for start of the whole operation (ME_TRIG_TYPE_SW, ME_TRIG_TYPE_EXT_ANALOG, ME_TRIG_TYPE_THRESHOLD...)
    Stream_Trigger.iAcqStartTrigEdge   := ME_TRIG_EDGE_NONE;         // Defines the trigger edge for start of a single conversion (ME_TRIG_EDGE_NONE, ME_TRIG_EDGE_RISING, ME_TRIG_EDGE_FALLING...)
    Stream_Trigger.iAcqStartTrigChan   := ME_TRIG_CHAN_DEFAULT;      // Choose whether triggering should be done separatly for each channel (standard) or if a channel should be started synchronously with other channels
    Stream_Trigger.iAcqStartTicksLow   := Acq_TckL;                  // Offset time in number of ticks between "start" of the measurement and the first conversion.
    Stream_Trigger.iAcqStartTicksHigh  := Acq_TckH;                  // Higher significant part of the offset time (bits 63 to 32)
    Stream_Trigger.iScanStartTrigType  := ME_TRIG_TYPE_TIMER;        // Defines the trigger type for start of a scan (ME_TRIG_TYPE_TIMER, ME_TRIG_TYPE_FOLLOW, ME_TRIG_TYPE_EXT_DIGITAL...)
    Stream_Trigger.iScanStartTicksLow  := Scan_TckL;                 // Time interval in ticks between the start of two consecutive scans
    Stream_Trigger.iScanStartTicksHigh := Scan_TckH;                 // Higher significant part of the scan-time (bits 63 to 32)
    Stream_Trigger.iConvStartTrigType  := ME_TRIG_TYPE_TIMER;        // Defines the trigger type for start of a single conversion (ME_TRIG_TYPE_TIMER, ME_TRIG_TYPE_EXT_DIGITAL, ME_TRIG_TYPE_EXT_ANALOG)
    Stream_Trigger.iConvStartTicksLow  := Conv_TckL;                 // Chan interval in number of ticks between two conversions (Sample resp. output rate)
    Stream_Trigger.iConvStartTicksHigh := Conv_TckH;                 // Higher significant part of the chan interval (bits 63 to 32)
    if ME4670_AI_Config.ScanTime < 0.1 then
//      FlushNr := Length(ME4670_AI_Config.ChanList)* Round(0.2/ME4670_AI_Config.ScanTime);
      FlushNr := Length(ME4670_AI_Config.ChanList)* Round(0.8/ME4670_AI_Config.ScanTime);
  end;

  if (ME4670_AI_Config.ScanType    = ME4670_AISM_CASOVNO     ) and
     (ME4670_AI_Config.AcqStartType= ME_TRIG_TYPE_EXT_DIGITAL) then  // Starti: Acq na triger , Scan na timer, Conv na timer
  begin
    Stream_Trigger.iAcqStartTrigType   := ME_TRIG_TYPE_EXT_DIGITAL;  // Defines the trigger type for start of the whole operation (ME_TRIG_TYPE_SW, ME_TRIG_TYPE_EXT_ANALOG, ME_TRIG_TYPE_THRESHOLD...)
    Stream_Trigger.iAcqStartTrigEdge   := ME_TRIG_EDGE_RISING;       // Defines the trigger edge for start of a single conversion (ME_TRIG_EDGE_NONE, ME_TRIG_EDGE_RISING, ME_TRIG_EDGE_FALLING...)
    Stream_Trigger.iAcqStartTrigChan   := ME_TRIG_CHAN_DEFAULT;      // Choose whether triggering should be done separatly for each channel (standard) or if a channel should be started synchronously with other channels
    Stream_Trigger.iAcqStartTicksLow   := Acq_TckL;                  // Offset time in number of ticks between "start" of the measurement and the first conversion.
    Stream_Trigger.iAcqStartTicksHigh  := Acq_TckH;                  // Higher significant part of the offset time (bits 63 to 32)
    Stream_Trigger.iScanStartTrigType  := ME_TRIG_TYPE_TIMER;        // Defines the trigger type for start of a scan (ME_TRIG_TYPE_TIMER, ME_TRIG_TYPE_FOLLOW, ME_TRIG_TYPE_EXT_DIGITAL...)
    Stream_Trigger.iScanStartTicksLow  := Scan_TckL;                 // Time interval in ticks between the start of two consecutive scans
    Stream_Trigger.iScanStartTicksHigh := Scan_TckH;                 // Higher significant part of the scan-time (bits 63 to 32)
    Stream_Trigger.iConvStartTrigType  := ME_TRIG_TYPE_TIMER;        // Defines the trigger type for start of a single conversion (ME_TRIG_TYPE_TIMER, ME_TRIG_TYPE_EXT_DIGITAL, ME_TRIG_TYPE_EXT_ANALOG)
    Stream_Trigger.iConvStartTicksLow  := Conv_TckL;                 // Chan interval in number of ticks between two conversions (Sample resp. output rate)
    Stream_Trigger.iConvStartTicksHigh := Conv_TckH;                 // Higher significant part of the chan interval (bits 63 to 32)
    if ME4670_AI_Config.ScanTime < 0.1 then
//      FlushNr := Length(ME4670_AI_Config.ChanList)* Round(0.2/ME4670_AI_Config.ScanTime);
      FlushNr := Length(ME4670_AI_Config.ChanList)* Round(0.8/ME4670_AI_Config.ScanTime);

  end;

  if ME4670_AI_Config.ScanType= ME4670_AISM_TRIGGER then             // Starti: Acq na triger , Scan na triger, Conv na timer
  begin
    Stream_Trigger.iAcqStartTrigType   := ME_TRIG_TYPE_EXT_DIGITAL;  // Defines the trigger type for start of the whole operation (ME_TRIG_TYPE_SW, ME_TRIG_TYPE_EXT_ANALOG, ME_TRIG_TYPE_THRESHOLD...)
    Stream_Trigger.iAcqStartTrigEdge   := ME_TRIG_EDGE_RISING;       // Defines the trigger edge for start of a single conversion (ME_TRIG_EDGE_NONE, ME_TRIG_EDGE_RISING, ME_TRIG_EDGE_FALLING...)
    Stream_Trigger.iAcqStartTrigChan   := ME_TRIG_CHAN_DEFAULT;      // Choose whether triggering should be done separatly for each channel (standard) or if a channel should be started synchronously with other channels
    Stream_Trigger.iAcqStartTicksLow   := Acq_TckL;                  // Offset time in number of ticks between "start" of the measurement and the first conversion.
    Stream_Trigger.iAcqStartTicksHigh  := 0;                         // Higher significant part of the offset time (bits 63 to 32)
    Stream_Trigger.iScanStartTrigType  := ME_TRIG_TYPE_EXT_DIGITAL;  // Defines the trigger type for start of a scan (ME_TRIG_TYPE_TIMER, ME_TRIG_TYPE_FOLLOW, ME_TRIG_TYPE_EXT_DIGITAL...)
    Stream_Trigger.iScanStartTicksLow  := 0;                         // Time interval in ticks between the start of two consecutive scans
    Stream_Trigger.iScanStartTicksHigh := 0;                         // Higher significant part of the scan-time (bits 63 to 32)
    Stream_Trigger.iConvStartTrigType  := ME_TRIG_TYPE_TIMER;        // Defines the trigger type for start of a single conversion (ME_TRIG_TYPE_TIMER, ME_TRIG_TYPE_EXT_DIGITAL, ME_TRIG_TYPE_EXT_ANALOG)
    Stream_Trigger.iConvStartTicksLow  := Conv_TckL;                 // Chan interval in number of ticks between two conversions (Sample resp. output rate)
    Stream_Trigger.iConvStartTicksHigh := Conv_TckH;                 // Higher significant part of the chan interval (bits 63 to 32)
  end;

  if ME4670_AI_Config.MaxSamplesNr > 0 then
  begin
    Stream_Trigger.iScanStopTrigType   := ME_TRIG_TYPE_NONE;         // Defines the trigger type for ending the scan (ME_TRIG_TYPE_NONE, ME_TRIG_TYPE_COUNT)
    Stream_Trigger.iScanStopCount      := 0;                         // Total number of conversions after which the scans will be ended and at the same time the measurement as a whole.
    Stream_Trigger.iAcqStopTrigType    := ME_TRIG_TYPE_COUNT;        // Defines the trigger type for ending the whole operation (ME_TRIG_TYPE_NONE, ME_TRIG_TYPE_COUNT, ME_TRIG_TYPE_FOLLOW)
    Stream_Trigger.iAcqStopCount       := ME4670_AI_Config.MaxSamplesNr; // Number of scans (channel-list processings) after which the complete operation should be ended
  end else
  begin
    Stream_Trigger.iScanStopTrigType   := ME_TRIG_TYPE_NONE;         // Defines the trigger type for ending the scan (ME_TRIG_TYPE_NONE, ME_TRIG_TYPE_COUNT)
    Stream_Trigger.iScanStopCount      := 0;                         // Total number of conversions after which the scans will be ended and at the same time the measurement as a whole.
    Stream_Trigger.iAcqStopTrigType    := ME_TRIG_TYPE_NONE;         // Defines the trigger type for ending the whole operation (ME_TRIG_TYPE_NONE, ME_TRIG_TYPE_COUNT, ME_TRIG_TYPE_FOLLOW)
    Stream_Trigger.iAcqStopCount       := 0;                         // Number of scans (channel-list processings) after which the complete operation should be ended
  end;

	ME_Err := meIOStreamConfig( ME4670_DevInd,                         // Device index
                              4,                                     // Subdevice index,
                              Stream_Config[0],
                              Length(ME4670_AI_Config.ChanList),     // Number of elements in the stream config array above
                              Stream_Trigger,                        // Pointer to an TmeIOStreamTrigger structure
                              FlushNr,                               // koliko stevilk flusha. Kar naj jih toliko, kot je kanalov
                              ME_IO_STREAM_CONFIG_NO_FLAGS );        // No flags
end;

function ME4670_Zacni_AI_Zajemanje: Integer;
var
  Str_Start_Config: TMeIOStreamStart;
  T: Cardinal;
begin
  Str_Start_Config.iDevice    := ME4670_DevInd;                      // Index of the device to be accessed
  Str_Start_Config.iSubdevice := 4;                                  // Index of the sub-device to be accessed
  Str_Start_Config.iStartMode := ME_START_MODE_NONBLOCKING;          // ME_START_MODE_BLOCKING (waits until the proper trigger signal occurs), ME_START_MODE_NONBLOCKING (Function returns immediately)
  Str_Start_Config.iTimeOut   := 10000;                              // Time interval in milliseconds within the first trigger pulse must occur
  Str_Start_Config.iFlags     := ME_IO_STREAM_START_TYPE_NO_FLAGS;   // ME_IO_STREAM_START_TYPE_NO_FLAGS, ME_IO_STREAM_START_TYPE_TRIG_SYNCHRONOUS for Synchronous start
  Str_Start_Config.iErrno     := 0;                                  // If an error occurs, an error code will be set
  ME4670_Ind_An_Buff := 0;
  ME_Err := meIOStreamStart( Str_Start_Config,
                             1,                                     // Number of elements in the stream start array above
                             ME_IO_STREAM_START_NO_FLAGS );         // No flags
  Result := ME_Err;
end;


function ME4670_PWM_Start(DutyCycle: Integer): Integer;
begin
  Result := meUtilityPWMStart(ME4670_DevInd,
                              ME4670_COUNTER_0,       // iSubdevice1
                              ME4670_COUNTER_1,       // iSubdevice2
                              ME4670_COUNTER_2,       // iSubdevice3
                              ME_REF_CTR_EXTERNAL,    // iRef
                              13,                     // iPrescaler  --> 13 je za za 1MHz kristal, da gladko spreminja hitrost
                              DutyCycle,              // iDutyCycle
                              ME_PWM_START_NO_FLAGS); // iFlag
end;

function ME4670_PWM_Stop: Integer;
begin
  Result := meUtilityPWMStop(ME4670_DevInd, ME4670_COUNTER_0);
end;

function ME4670_NastaviNapetost(Kanal: Integer; Napetost: Double): Double; // Nastavi napetost v voltih
var
  IO_Single: array[0..0] of TMeIOSingle;
  physMax: Double;
  iUnit: Integer;
  physMin: Double;
  DigitalMax: Integer;
  Vrednost: Double;
  meError: Integer;
  piData: Integer;
begin
  meQueryRangeInfo(ME4670_DevInd,
                   5,
                   0,
                   iUnit,       // ME_UNIT_VOLT
                   physMin,     // -10
                   physMax,     // 9,999695
                   DigitalMax); // 65535

  meUtilityPhysicalToDigital( physMin,
                              physMax,
                              DigitalMax,
                              Napetost,
                              piData  );

  meIOSingleConfig( ME4670_DevInd,
                    Kanal+ 5,                // devajsi so 5, 6, 7, 8
                    0,
                    0,
                    ME_REF_AO_GROUND,
                    ME_TRIG_CHAN_DEFAULT,
                    ME_TRIG_TYPE_SW,
                    ME_VALUE_NOT_USED,
                    ME_IO_SINGLE_CONFIG_NO_FLAGS);

  IO_Single[0].iDevice:= ME4670_DevInd;
  IO_Single[0].iSubdevice := Kanal+ 5;
  IO_Single[0].iChannel := 0;
  IO_Single[0].iDir := ME_DIR_OUTPUT;
  IO_Single[0].iValue := piData;
  IO_Single[0].iTimeOut := 0;
  IO_Single[0].iFlags := ME_IO_SINGLE_TYPE_NO_FLAGS;
  IO_Single[0].iErrno := 0;
  Result := meIOSingle(IO_Single[0], 1, ME_IO_SINGLE_NO_FLAGS);
end;

function ME4670_Stream_Stop: Integer;
var
  StreamStop: TMeIOStreamStop;
  plStatus: Integer;
  plCount: Integer;
begin
  StreamStop.iDevice    := ME4670_DevInd;
  StreamStop.iSubdevice := 4;
  StreamStop.iStopMode  := ME_STOP_MODE_LAST_VALUE;
  StreamStop.iFlags     := ME_IO_STREAM_STOP_TYPE_NO_FLAGS;
  StreamStop.iErrno     := 0;
  Result := meIOStreamStop( StreamStop,
                            1,                           // Number of elements in the stream stop array above
                            ME_IO_STREAM_STOP_NO_FLAGS); // No flags
end;


function ME4670_StreamIsRunning: Boolean;
var
  plStatus, plCount: Integer;
  Str: string;
begin
  meIOStreamStatus(ME4670_DevInd,
                   4,              // iSubDevice
                   ME_WAIT_NONE,
                   plStatus,
                   plCount,
                   ME_IO_STREAM_STATUS_NO_FLAGS);
  if plStatus = ME_STATUS_BUSY then Result := True else Result := False;
end;


function ME4670_PocakajNaKonecStraminga(MaxCas: Double): Boolean;  // Najvecji cas cakanja je v milisekundah
var
  T: Cardinal;
  NotRn, TmOut: Boolean;
begin
  T := TimeGetTime;
  repeat
    TmOut := ((TimeGetTime- T) > MaxCas);
    Sleep(5);
    NotRn := not ME4670_StreamIsRunning;
  until TmOut or NotRn;
  if TmOut then ME4670_Stream_Stop;
  Result := not TmOut;
end;

end.
