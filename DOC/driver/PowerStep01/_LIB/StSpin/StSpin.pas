unit StSpin;
//////////// Verzija: 7
/// Dodal sem sinhronizacijo "PocakajNaVrsto", da ne prihala do napak
///  Dodal sem proceduro  "GetStatus_AllDev" in tabelo dekodiranih statusov v boolean obliki
///  Dodal sem Try/except, da se manjkrat obesi
///
interface

uses
  Windows, Mmsystem, Math, Messages, Vcl.Forms,
  Dialogs,
  ftd2xx, LibFT4222,
  SysUtils,
  Classes;

type
    TByteArr = array of Byte;
    TWordArr = array of Word;
    TCardArr = array of Cardinal;

    TPwrStp_Params= array[$01..$1B] of Cardinal;      // registri od kontrolerja

    TPwrStepRegInfo= record
      NrBit  : Cardinal;                 // Koliko bitov je velik podatek v registru
      NrBayt : Cardinal;                 // Koliko bytov je velik podatek v registru
      AccLvl : Cardinal;                 // Access level, 0= NotWrite, 1= WriteStop, 2= WriteHigh, 3= WriteAlways
      DefVal: Cardinal;                  // Koliko je default vrednost
      RegName: string;                   // Register name
      Opis: string;                      // Opis registra
    end;

    TPwrStp_MotorData= record
      OznakaMotorja : string;            // Oznaka motorja
      StepsPerRev   : Integer;           // 200 ali 400
      Resistance    : Double;            // v ohmih
      Inductance    : Double;            // v mH
      Ke            : Double;            // elektricna konstanta V/Hz
      RatedCurrent  : Double;            // v Amperih
      Vm_Config     : TPwrStp_Params;    // Register vrednosti za voltage mode
      Cm_Config     : TPwrStp_Params;    // Register vrednosti za current mode
      CyclicMoving  : Boolean;           // Ali naj se motorji ciklicno premikajo
      St_Slp_k      : Double;            // Vpliv Toka na StartSlope, k
      St_Slp_n      : Double;            // Vpliv Toka na StartSlope, n
      Fn_Slp_k      : Double;            // Vpliv Toka na FinalSlope, k
      Fn_Slp_n      : Double;            // Vpliv Toka na FinalSlope, n
    end;

    TPwrStepStatus = record
      Stall_A     : Boolean;
      Stall_B     : Boolean;
      OCD         : Boolean;
      TH_Warning  : Boolean;
      UVLO_ADC    : Boolean;
      UVLO        : Boolean;
      STCK_Mode   : Boolean;
      CMD_Error   : Boolean;
      MOT_Running : Boolean;
      DIR_Positive: Boolean;
      SW_Event    : Boolean;
      SW_Closed   : Boolean;
      Busy        : Boolean;
      HiZ         : Boolean;
    end;

  // Tip PowerStep komand za sinhronizacijsko akcijo, nastete so samo smiselne komande
  TPwrCmd=(cNOP,                                                     // no operation
           cRun_DirFwd, cRun_DirBck,                                  // Run with target speed
           cMove_DirFwd, cMove_DirBck,                                // Makes desired number of counts
           cGoTo_Short,                                               // Brings the motor in desired position in shortest path
           cGoTo_DirFwd, cGoTo_DirBck,                                // Brings the motor in desired position with forced direction
           cGoUntil_ResetAbs_DirFwd, cGoUntil_ResetAbs_DirBck,        // Motion with desired speed until SW closed, after event SoftStop. At SW event ABS register is reset
           cGoUntil_PresetMark_DirFwd, cGoUntil_PresetMark_DirBck,    // Motion with desired speed until SW closed, after event SoftStop. At SW event MARK register is preset with ABS register
           cReleseSW_ResetAbs_DirFwd, cReleseSW_ResetAbs_DirBck,      // Motion with minimum speed until SW opened, after event HardStop. At SW event ABS register is reset
           cReleseSW_PresetMark_DirFwd, cReleseSW_PresetMark_DirBck,  // Motion with minimum speed until SW opened, after event HardStop. At SW event MARK register is preset with ABS register
           cGoHome, cGoMark, cReset_Pos, cSoftStop, cHardStop, cSoftHiZ, cHardHiZ); // To, kar pise, to je.

  function CardToBitStr(Stevilo, DolzinaBesede: Cardinal): string;

type
  TStSpin = class(TObject)
  private
    var FT4222_Hnd_A: Pointer;
    var FT4222_Hnd_B: Pointer;
    const ImePorta_A = 'StepController_PowerStep A';
    const ImePorta_B = 'StepController_PowerStep B';
    var BfCmd: array [0..255] of Byte;
    var BfRsp: array [0..255] of Byte;
    procedure PocakajNaVrsto;

  protected
  public
    var   DevOK: Boolean;
    var   IsBusy: Boolean;                         // Ce je komunikacija zasedena
    var   Count: Integer;                          // Koliko Driverjev je povezanih v SPI daisy-chain
    var   Config: array of TPwrStp_Params;         // registri od vseh kontrolerjev
    var   MotorData: Array of TPwrStp_MotorData;
    var   Vbus: Double;                            // Koliko je napajalna napetost v voltih
    var   MotorStatus: Array of TPwrStepStatus;
    const Rs = 0.2266667;                           // Upornost upora na vezju za merjenje toka

    function Get_FTDI_Serial_Number: string;
    function Get_All_Available_Controllers: TStringList;   // vrne seznam serijskih od vseh prostih kontrolerjev
    function Lista_FTDI_Naprav: string;
    function  Open                : Boolean; Overload;     // Odpre prvi mozen kontroler,  vrne serijsko, ki se je odprla.
    function  Open(var SN: string): Boolean; Overload;     // Preferirajoca serijska stevilka kontrolerja. Vrne serijsko, ki se je odprla
    procedure Close;

    procedure HW_ResetDevice    (StNaprave: Cardinal);
    procedure NoOp              (StPonovitev: Cardinal);
    function  SetParam          (StNaprave: Cardinal; Address: Byte; Value: Cardinal): Integer;
    function  GetParam          (StNaprave: Cardinal; Address: Byte): Cardinal;
    function  GetParams_AllDev  (Address: Byte): TCardArr;
    procedure GetStatus_AllDev;
    function  Run_DirFwd        (StNaprave: Cardinal; Speed: Double): Double;      // hitrost je v step/s,  vrne zaokrozeno hitrost
    function  Run_DirBck        (StNaprave: Cardinal; Speed: Double): Double;      // hitrost je v step/s,  vrne zaokrozeno hitrost
    procedure StpClk_DirFwd     (StNaprave: Cardinal);
    procedure StpClk_DirBck     (StNaprave: Cardinal);
    function  Move_DirFwd       (StNaprave: Cardinal; NrClocks: Integer): Integer;
    function  Move_DirBck       (StNaprave: Cardinal; NrClocks: Integer): Integer;
    function  GoTo_Short        (StNaprave: Cardinal; AbsPos: Integer): Integer;
    function  GoTo_DirFwd       (StNaprave: Cardinal; AbsPos: Integer): Integer;
    function  GoTo_DirBck       (StNaprave: Cardinal; AbsPos: Integer): Integer;
    function  GoUntil_rAbs_dFwd (StNaprave: Cardinal; Speed: Double): Double;      // Motion with desired speed until SW closed, after event SoftStop. At SW event ABS register is reset
    function  GoUntil_rAbs_dBck (StNaprave: Cardinal; Speed: Double): Double;      // Motion with desired speed until SW closed, after event SoftStop. At SW event ABS register is reset
    function  GoUntil_pMrk_dFwd (StNaprave: Cardinal; Speed: Double): Double;      // Motion with desired speed until SW closed, after event SoftStop. At SW event MARK register is preset with ABS register
    function  GoUntil_pMrk_dBck (StNaprave: Cardinal; Speed: Double): Double;      // Motion with desired speed until SW closed, after event SoftStop. At SW event MARK register is preset with ABS register
    procedure RlsSW_rAbs_DirFwd (StNaprave: Cardinal);                             // Motion with minimum speed until SW opened, after event HardStop. At SW event ABS register is reset
    procedure RlsSW_rAbs_DirBck (StNaprave: Cardinal);                             // Motion with minimum speed until SW opened, after event HardStop. At SW event ABS register is reset
    procedure RlsSW_pMrk_DirFwd (StNaprave: Cardinal);                             // Motion with minimum speed until SW opened, after event HardStop. At SW event MARK register is preset with ABS register
    procedure RlsSW_pMrk_DirBck (StNaprave: Cardinal);                             // Motion with minimum speed until SW opened, after event HardStop. At SW event MARK register is preset with ABS register
    procedure GoHome            (StNaprave: Cardinal);
    procedure GoMark            (StNaprave: Cardinal);
    procedure ResetPos          (StNaprave: Cardinal);
    procedure ResetDevice       (StNaprave: Cardinal);
    procedure SoftStop          (StNaprave: Cardinal);
    procedure HardStop          (StNaprave: Cardinal);
    procedure SoftHiZ           (StNaprave: Cardinal);
    procedure HardHiZ           (StNaprave: Cardinal);
    function  GetClearStatus    (StNaprave: Cardinal): Cardinal;
    function  Set_Acc           (StNaprave: Cardinal; Value: Double  ): Double;    // Pospesek je v step/s2, vrne nastavljen pospesek
    function  Set_Dec           (StNaprave: Cardinal; Value: Double  ): Double;    // Pospesek je v step/s2, vrne nastavljen pospesek
    function  Set_MaxSpeed      (StNaprave: Cardinal; Value: Double  ): Double;    // Htrost je v step/s, vrne nastavljeno hitrost
    function  Set_MinSpeed      (StNaprave: Cardinal; Value: Double  ): Double;    // Htrost je v step/s, vrne nastavljeno hitrost
    function  Set_AbsPos        (StNaprave: Cardinal; Value: Integer ): Integer;   // Nastavi ABSPOS register na zeljeno vrednost, vrne nastavljeno
    function  Set_MarkPos       (StNaprave: Cardinal; Value: Integer ): Integer;   // Nastavi MARK register na zeljeno vrednost, vrne nastavljeno
    function  Set_HoldCurrent   (StNaprave: Cardinal; Value: Double  ): Double;    // Peak tok. Tok je v mA, vrne nastavljen tok
    function  Set_RunCurrent    (StNaprave: Cardinal; Value: Double  ): Double;    // Peak tok. Tok je v mA, vrne nastavljen tok
    function  Set_AccCurrent    (StNaprave: Cardinal; Value: Double  ): Double;    // Peak tok. Tok je v mA, vrne nastavljen tok
    function  Set_DecCurrent    (StNaprave: Cardinal; Value: Double  ): Double;    // Peak tok. Tok je v mA, vrne nastavljen tok
    function  Set_StpMode       (StNaprave: Cardinal; Value: Cardinal): Cardinal;  // Nastavi MicroStep, vrne nastavljeno vrednost
    function  Get_Acc           (StNaprave: Cardinal): Double;                     // Pospesek je v step/s2, vrne nastavljen pospesek
    function  Get_Dec           (StNaprave: Cardinal): Double;                     // Pospesek je v step/s2, vrne nastavljen pospesek
    function  Get_MaxSpeed      (StNaprave: Cardinal): Double;                     // Htrost je v step/s, vrne nastavljeno hitrost
    function  Get_MinSpeed      (StNaprave: Cardinal): Double;                     // Htrost je v step/s, vrne nastavljeno hitrost
    function  Get_AbsPos        (StNaprave: Cardinal): Integer;                    // Prebere ABSPOS register
    function  Get_MarkPos       (StNaprave: Cardinal): Integer;                    // Prebere MARK register
    function  Get_Speed         (StNaprave: Cardinal): Double;                     // Koliko je trenutna hitrost, v step/s
    function  Get_HoldCurrent   (StNaprave: Cardinal): Double;                     // Peak tok. Tok je v mA, vrne nastavljen tok
    function  Get_RunCurrent    (StNaprave: Cardinal): Double;                     // Peak tok. Tok je v mA, vrne nastavljen tok
    function  Get_AccCurrent    (StNaprave: Cardinal): Double;                     // Peak tok. Tok je v mA, vrne nastavljen tok
    function  Get_DecCurrent    (StNaprave: Cardinal): Double;                     // Peak tok. Tok je v mA, vrne nastavljen tok
    function  Get_StpMode       (StNaprave: Cardinal): Cardinal;                   // Vrne MicroStep nastavitev

    function  VoltMode          (StNaprave: Cardinal): Boolean;
    function  RegParamInfo      (StNaprave: Cardinal; Address: Byte): TPwrStepRegInfo;
    function  Interp_Reg_Value  (StNaprave: Cardinal; Address: Byte; WithUnits: Boolean): string;
    function  InterpReg_AbsPos  (StNaprave: Cardinal): Integer;
    function  InterpReg_MarkPos (StNaprave: Cardinal): Integer;
    function  InterpReg_Speed   (StNaprave: Cardinal): Double;
    function  InterpReg_MaxSpeed(StNaprave: Cardinal): Double;

    procedure AddCommand        (StNaprave: Cardinal; Komanda: TPwrCmd; Parameter: Integer);   // za sinhronizirane komande

    procedure ExecuteCommands;                                                         // za sinhronizirane komande
    function  GetNumberOfDevices: Integer;

    constructor Create;
    destructor Destroy; Override;
//  published
  end;


implementation

constructor TStSpin.Create;
begin
  inherited Create;
  IsBusy := False;
  FT4222_Hnd_A := nil;
  FT4222_Hnd_B := nil;
  Count := 0;
  Vbus := 24;
  SetLength(Config, 0);
  SetLength(MotorData, 0);
  SetLength(MotorStatus, 0);
  DevOK := False;
end;

destructor TStSpin.Destroy;
begin
  inherited Destroy;
end;

procedure TStSpin.PocakajNaVrsto;
var
  T, T1: Cardinal;
begin
  T1 := 0;
  if IsBusy then
  begin
    T := TimeGetTime;
    repeat
      T1 := TimeGetTime- T;
    until (not IsBusy) or (T1 > 50);
  end;
  if T1 > 50 then IsBusy := False else IsBusy := True;
end;

function TStSpin.Open: Boolean;    // funkcija, ki ne potrebuje serijske stevilke kontrolerja
var
  I: Integer;
  R: Cardinal;
  IO_DirArr: GPIO_DirArr;
  Str_Buff: Array [1 .. 63] of AnsiChar;
  Res: Cardinal;
begin
  Result := False;
  DevOK := False;
  if FT4222_Hnd_A = nil then
  begin
    for I := 1 to Length(ImePorta_A) do Str_Buff[I] := AnsiChar(ImePorta_A[I]);
    Str_Buff[Length(ImePorta_A)+ 1] := #0;
    Res := FT_OpenEx(@Str_Buff, FT_OPEN_BY_DESCRIPTION, FT4222_Hnd_A);
    if Res <> FT_OK then
    begin
//      FT_Error_Report('Na USB-ju ni kontrolerja za koraène motorje.', Res);
      Close;
      Exit;
    end;
  end else begin Close; Exit; end;
  if FT4222_Hnd_B = nil then
  begin
    for I := 1 to Length(ImePorta_B) do Str_Buff[I] := AnsiChar(ImePorta_B[I]);
    Str_Buff[Length(ImePorta_B)+ 1] := #0;
    Res := FT_OpenEx(@Str_Buff, FT_OPEN_BY_DESCRIPTION, FT4222_Hnd_B);
    if Res <> FT_OK then
    begin
//      FT_Error_Report('Na USB ni kontrolerja za koraène motorje.', Res);
      Close;
      Exit;
    end;
  end else begin Close; Exit; end;
  if FT4222_Hnd_B <> nil then
  begin
    FT4222_SetSuspendOut(FT4222_Hnd_B, False);
    FT4222_SetWakeUpInterrupt(FT4222_Hnd_B, False);
    IO_DirArr[0] := GPIO_INPUT;
    IO_DirArr[1] := GPIO_INPUT;
    IO_DirArr[2] := GPIO_INPUT;
    IO_DirArr[3] := GPIO_INPUT;
    R := FT4222_GPIO_Init(FT4222_Hnd_B, IO_DirArr);
    if R <> FT_OK then FT_Error_Report('FT4222 GPIO inicializacija ni uspela.', R);
    FT4222_GPIO_Write(FT4222_Hnd_B, GPIO_PORT3, True); // da ni v standbuyu
  end;
  if FT4222_Hnd_A <> nil then
  begin
    R := FT4222_SPIMaster_Init(FT4222_Hnd_A,
                               SPI_IO_SINGLE,
                               CLK_DIV_32,
                               CLK_IDLE_HIGH,
                               CLK_TRAILING,         // pri prehodu gor se prebere stanje
                               $01);                 // SSO map
    if R <> FT_OK then FT_Error_Report('FT4222 SPI inicializacija ni uspela.', R) else begin DevOK := True; Result := True; end;
  end;
end;

function TStSpin.Open(var SN: string): Boolean;    // Preferirajoca serijska stevilka kontrolerja. Vrne serijsko, ki se je odprla
var
  I: Integer;
  R: Cardinal;
  IO_DirArr: GPIO_DirArr;
  Str_Buff: Array [1 .. 63] of AnsiChar;
  Res: Cardinal;
begin
  Result := False;
  if (FT4222_Hnd_A <> nil) and (FT4222_Hnd_B <> nil) then Exit;
  DevOK := False;
  if SN <> '' then   // najprej poskusim odpret glede na serijsko stevilko
  begin
    if (FT4222_Hnd_A = nil) and (FT4222_Hnd_B = nil) then
    begin
      for I := 1 to Length(SN) do Str_Buff[I] := AnsiChar(SN[I]);
      Str_Buff[Length(SN)+ 1] := AnsiChar('A');
      Str_Buff[Length(SN)+ 2] := #0;
      Res := FT_OpenEx(@Str_Buff, FT_OPEN_BY_SERIAL_NUMBER, FT4222_Hnd_A);
      if Res = FT_OK then
      begin
        for I := 1 to Length(SN) do Str_Buff[I] := AnsiChar(SN[I]);
        Str_Buff[Length(SN)+ 1] := AnsiChar('B');
        Res := FT_OpenEx(@Str_Buff, FT_OPEN_BY_SERIAL_NUMBER, FT4222_Hnd_B);
      end;
      if Res <> FT_OK then
      begin
        FT4222_Hnd_A := nil;
        FT4222_Hnd_B := nil;
      end;
    end;
  end;
  if (FT4222_Hnd_A = nil) and (FT4222_Hnd_B = nil) then
  begin
    for I := 1 to Length(ImePorta_A) do Str_Buff[I] := AnsiChar(ImePorta_A[I]);
    Str_Buff[Length(ImePorta_A)+ 1] := #0;
    Res := FT_OpenEx(@Str_Buff, FT_OPEN_BY_DESCRIPTION, FT4222_Hnd_A);
    if Res = FT_OK then
    begin
      for I := 1 to Length(ImePorta_B) do Str_Buff[I] := AnsiChar(ImePorta_B[I]);
      Res := FT_OpenEx(@Str_Buff, FT_OPEN_BY_DESCRIPTION, FT4222_Hnd_B);
    end;
    if Res = FT_OK then
    begin
      SN := Get_FTDI_Serial_Number;
    end else
    begin
//      FT_Error_Report('Na USB-ju ni kontrolerja za koraène motorje.', Res);
      Close;
      Sn := '';
      Exit;
    end;
  end;
  if FT4222_Hnd_B <> nil then
  begin
    FT4222_SetSuspendOut(FT4222_Hnd_B, False);
    FT4222_SetWakeUpInterrupt(FT4222_Hnd_B, False);
    IO_DirArr[0] := GPIO_INPUT;
    IO_DirArr[1] := GPIO_INPUT;
    IO_DirArr[2] := GPIO_INPUT;
    IO_DirArr[3] := GPIO_INPUT;
    R := FT4222_GPIO_Init(FT4222_Hnd_B, IO_DirArr);
    if R <> FT_OK then FT_Error_Report('FT4222 GPIO inicializacija ni uspela.', R);
    FT4222_GPIO_Write(FT4222_Hnd_B, GPIO_PORT3, True); // da ni v standbuyu
  end;
  if FT4222_Hnd_A <> nil then
  begin
    R := FT4222_SPIMaster_Init(FT4222_Hnd_A,
                               SPI_IO_SINGLE,
                               CLK_DIV_32,
                               CLK_IDLE_HIGH,
                               CLK_TRAILING,         // pri prehodu gor se prebere stanje
                               $01);                 // SSO map
    if R <> FT_OK then FT_Error_Report('FT4222 SPI inicializacija ni uspela.', R) else begin DevOK := True; Result := True; end;
  end;
end;

procedure TStSpin.HW_ResetDevice(StNaprave: Cardinal);
var
  IO_DirArr: GPIO_DirArr;
begin
  if StNaprave > 3 then Exit;
  IO_DirArr[3- StNaprave] := GPIO_OUTPUT;
  FT4222_GPIO_Init(FT4222_Hnd_B, IO_DirArr);
  FT4222_GPIO_Write(FT4222_Hnd_B, 3- StNaprave, False);
  Sleep(10);
  FT4222_GPIO_Write(FT4222_Hnd_B, 3- StNaprave, True);
  IO_DirArr[3- StNaprave] := GPIO_INPUT;
  FT4222_GPIO_Init(FT4222_Hnd_B, IO_DirArr);
end;

function TStSpin.Get_All_Available_Controllers: TStringList;   // vrne seznam serijskih od vseh prostih kontrolerjev
var
  I: Integer;
  Str: string;
begin
  Result := TStringList.Create;
  Result.Sorted := True;
  Str := '';
  FT_CreateDeviceInfoList(@FT_Device_Count);
  SetLength(FT_DeviceInfoList, FT_Device_Count);
  FT_GetDeviceInfoList(FT_DeviceInfoList, @FT_Device_Count);
  if FT_Device_Count > 0 then
  begin
    for I := 0 to FT_Device_Count- 1 do
    begin
      if FT_DeviceInfoList[I].Description = ImePorta_A then
      begin
        Str := string(FT_DeviceInfoList[I].SerialNumber);
        Str := Copy(Str, 1, Str.Length- 1);
        Result.Add(Str);
      end;
    end;
  end;
end;

function TStSpin.Lista_FTDI_Naprav: string;
var
  I: Integer;
  Str: string;
begin
  Str := '';
  FT_CreateDeviceInfoList(@FT_Device_Count);
  SetLength(FT_DeviceInfoList, FT_Device_Count);
  FT_GetDeviceInfoList(FT_DeviceInfoList, @FT_Device_Count);
  if FT_Device_Count > 0 then
  begin
    for I := 0 to FT_Device_Count- 1 do
    begin
      if FT_DeviceInfoList[I].Description = '' then
      begin
        Str := Str+ 'Port '+ IntToStr(I)+ ' je zaseden...'+ #13#10;
        Str := Str+ #13#10;
      end else
      begin
        Str := Str+ 'Port '+ IntToStr(I)+':'+ #13#10;
        Str := Str+   string(FT_DeviceInfoList[I].Description)  + ' .... Desc.'+ #13#10;
        if FT_DeviceInfoList[I].DeviceHandle <> nil then
          Str := Str+ 'Port je ODPRT'+ #13#10 else Str := Str+ 'Port je zaprt'+ #13#10;
        Str := Str+ FT_DEVICE_TYPE_LIST[FT_DeviceInfoList[I].DeviceType]  + ' .... DeviceType'+ #13#10;
        Str := Str+ IntToStr(FT_DeviceInfoList[I].Flags)        + ' .... Flags'+ #13#10;
        Str := Str+ IntToStr(FT_DeviceInfoList[I].ID)           + ' .... ID'+ #13#10;
        Str := Str+ IntToStr(FT_DeviceInfoList[I].LocID)        + ' .... LocID'+ #13#10;
        Str := Str+   string(FT_DeviceInfoList[I].SerialNumber) + ' .... SerialNumber'+ #13#10;
        Str := Str+ #13#10;
      end;
    end;
  end;
  Result := Str;
end;

function TStSpin.Get_FTDI_Serial_Number: string;
var
  I: Integer;
  Str: string;
begin
  Str := '';
  FT_CreateDeviceInfoList(@FT_Device_Count);
  SetLength(FT_DeviceInfoList, FT_Device_Count);
  FT_GetDeviceInfoList(FT_DeviceInfoList, @FT_Device_Count);
  if FT_Device_Count > 0 then
  begin
    for I := 0 to FT_Device_Count- 1 do
    begin
      if (FT4222_Hnd_A <> nil) and (FT_DeviceInfoList[I].DeviceHandle = FT4222_Hnd_A) then
      begin
        Str := string(FT_DeviceInfoList[I].SerialNumber);
        Str := Copy( Str, 1, Length(Str)- 1);
      end;
    end;
  end;
  Result := Str;
end;

function CardToBitStr(Stevilo, DolzinaBesede: Cardinal): string;
var
  I: Integer;
  Maska: Cardinal;
  Str: string;
begin
  Maska := $00000001;
  Maska := Maska shl (DolzinaBesede- 1);
  Str := '';
  for I := 0 to (DolzinaBesede- 1) do
  begin
    if (Maska and Stevilo) <> 0 then
      Str := Str+ '1'
    else
      Str := Str+ '0';
    Maska := Maska shr 1;
  end;
  Result := Str;
end;

function TStSpin.RegParamInfo(StNaprave: Cardinal; Address: Byte): TPwrStepRegInfo;
begin
  Result.NrBit  := 0;
  Result.NrBayt := 0;
  Result.AccLvl := 0;
  Result.RegName := '';
  Result.DefVal := 0;
  Result.Opis := '';

  case Address of
    $11:           Result.NrBit :=  4;
    $12, $13, $14: Result.NrBit :=  5;
    $09, $0A, $0B, $0C,
    $0E, $0F, $10, $16,
    $17, $19:      Result.NrBit :=  8;
    $02:           Result.NrBit :=  9;
    $07:           Result.NrBit := 10;
    $15, $18:      Result.NrBit := 11;
    $05, $06, $08: Result.NrBit := 12;
    $0D:           Result.NrBit := 14;
    $1A, $1B:      Result.NrBit := 16;
    $04:           Result.NrBit := 20;
    $01, $03:      Result.NrBit := 22;
  end;
  if Result.NrBit > 0 then Result.NrBayt := (Result.NrBit- 1) div 8+ 1;
  case Address of
   $04, $12, $1B:                                    Result.AccLvl := 0;       // Read only
   $01, $05, $06, $08, $17:                          Result.AccLvl := 1;       // WS   $02 sem prestavil eno stopnjo visje, ker je veretno napaka v DS
   $02, $0D, $0E, $0F, $10, $16, $18, $19, $1A:      Result.AccLvl := 2;       // WH
   $03, $07, $09, $0A, $0B, $0C, $11, $13, $14, $15: Result.AccLvl := 3;       // WA
  end;

  case Address of
    $01: Result.RegName := 'ABS_POS';
    $02: Result.RegName := 'EL_POS';
    $03: Result.RegName := 'MARK';
    $04: Result.RegName := 'SPEED';
    $05: Result.RegName := 'ACC';
    $06: Result.RegName := 'DEC';
    $07: Result.RegName := 'MAX_SPEED';
    $08: Result.RegName := 'MIN_SPEED';
    $12: Result.RegName := 'ADC_OUT';
    $13: Result.RegName := 'OCD_TH';
    $15: Result.RegName := 'FS_SPD';
    $16: Result.RegName := 'STEP_MODE';
    $17: Result.RegName := 'ALARM_EN';
    $18: Result.RegName := 'GATECFG1';
    $19: Result.RegName := 'GATECFG2';
    $1B: Result.RegName := 'STATUS';
    $1A: Result.RegName := 'CONFIG';
  end;
  if VoltMode(StNaprave) then
  begin
    case Address of
      $09: Result.RegName := 'KVAL_HOLD';
      $0A: Result.RegName := 'KVAL_RUN';
      $0B: Result.RegName := 'KVAL_ACC';
      $0C: Result.RegName := 'KVAL_DEC';
      $0D: Result.RegName := 'INT_SPEED';
      $0E: Result.RegName := 'ST_SLP';
      $0F: Result.RegName := 'FN_SLP_ACC';
      $10: Result.RegName := 'FN_SLP_DEC';
      $11: Result.RegName := 'K_THERM';
      $14: Result.RegName := 'STALL_TH';
    end;
  end else
  begin
    case Address of
      $09: Result.RegName := 'TVAL_HOLD';
      $0A: Result.RegName := 'TVAL_RUN';
      $0B: Result.RegName := 'TVAL_ACC';
      $0C: Result.RegName := 'TVAL_DEC';
      $0E: Result.RegName := 'T_FAST';
      $0F: Result.RegName := 'TON_MIN';
      $10: Result.RegName := 'TOFF_MIN';
    end;
  end;

  case Address of
    $01: Result.Opis := 'Current position';
    $02: Result.Opis := 'Electrical position';
    $03: Result.Opis := 'Mark position';
    $04: Result.Opis := 'Current speed';
    $05: Result.Opis := 'Acceleration';
    $06: Result.Opis := 'Deceleration';
    $07: Result.Opis := 'Maximum speed';
    $08: Result.Opis := 'Minimum speed';
    $12: Result.Opis := 'ADC output';
    $13: Result.Opis := 'OCD treshold';
    $15: Result.Opis := 'Full-step speed';
    $16: Result.Opis := 'Step mode';
    $17: Result.Opis := 'Alarm enables';
    $18: Result.Opis := 'Gate driver configuration';
    $19: Result.Opis := 'Gate driver configuration';
    $1B: Result.Opis := 'Status';
    $1A: Result.Opis := 'IC configuration';
  end;
  if VoltMode(StNaprave) then
  begin
    case Address of
      $09: Result.Opis := 'Holding Kval';
      $0A: Result.Opis := 'Constant speed Kval';
      $0B: Result.Opis := 'Acceleration starting Kval';
      $0C: Result.Opis := 'Deceleration starting Kval';
      $0D: Result.Opis := 'Intersect speed';
      $0E: Result.Opis := 'Start slope';
      $0F: Result.Opis := 'Acceleration final slope';
      $10: Result.Opis := 'Deceleration final slope';
      $11: Result.Opis := 'Thermal compensation factor';
      $14: Result.Opis := 'STALL treshold';
    end;
  end else
  begin
    case Address of
      $09: Result.Opis := 'Holding reference voltage';
      $0A: Result.Opis := 'Constant speed reference voltage';
      $0B: Result.Opis := 'Deceleration reference voltage';
      $0C: Result.Opis := 'Acceleration reference voltage';
      $0E: Result.Opis := 'Fast decay settings';
      $0F: Result.Opis := 'Minimum on-time';
      $10: Result.Opis := 'Minimum off-time';
    end;
  end;
  case Address of
    $01: Result.DefVal := $0;
    $02: Result.DefVal := $0;
    $03: Result.DefVal := $0;
    $04: Result.DefVal := $0;
    $05: Result.DefVal := $8A;
    $06: Result.DefVal := $8A;
    $07: Result.DefVal := $41;
    $08: Result.DefVal := 0;
    $12: Result.DefVal := 0;
    $13: Result.DefVal := $8;
    $15: Result.DefVal := $27;
    $16: Result.DefVal := $7;
    $17: Result.DefVal := $FF;
    $18: Result.DefVal := $0;
    $19: Result.DefVal := $0;
    $1B: Result.DefVal := $0;
    $1A: Result.DefVal := $2C88;

    $09: Result.DefVal := $29;
    $0A: Result.DefVal := $29;
    $0B: Result.DefVal := $29;
    $0C: Result.DefVal := $29;
    $0D: Result.DefVal := $408;
    $0E: Result.DefVal := $19;
    $0F: Result.DefVal := $29;
    $10: Result.DefVal := $29;
    $11: Result.DefVal := $0;
    $14: Result.DefVal := $10;
  end;
end;

function TStSpin.Interp_Reg_Value(StNaprave: Cardinal; Address: Byte; WithUnits: Boolean): string;
var
  I: Integer;
  V: Double;
  Str: string;
  R: TRect;
  RegName: string;
  Val: Cardinal;
begin
  Result := 'Err';
//  if StNaprave > (Count- 1) then Exit;
  if Length(Config) < 1 then Exit;
  if StNaprave > (Length(Config)- 1) then Exit;
  Val := Config[StNaprave, Address];
  RegName := RegParamInfo(StNaprave, Address).RegName;
  if (RegName = 'ABS_POS') or (RegName = 'MARK') then
  begin
    I := Val;       // da se znebim cardinala in bo lahko stevilo tudi negativno
    if I > $3FFFFF then I := $3FFFFF; // 22 bitov
    Config[StNaprave, Address] := I;
    I := (I and $1FFFFF)- (I and $200000);
    Result := IntToStr(I);
    Exit;
  end;
  if RegName= 'EL_POS' then
  begin
    if Val > $1FF then Val := $1FF;       // 9 bitov
    Config[StNaprave, Address] := Val;
    I := (Val and $180) shr 7;
    Result := 'Step='+ IntToStr(I)+ ', µStep='+ IntToStr(Val and $7F);
    Exit;
  end;
  if RegName= 'SPEED' then
  begin
    if Val > $FFFFF then Val := $FFFFF;    // 20 bitov
    Config[StNaprave, Address] := Val;
    Result := FloatToStrF(Val* 0.01490116119384765625, ffFixed, 8, 3);  // Power(2, -28)/250* Power(10, 9)= 0.01490116119384765625
    if WithUnits then Result := Result+ ' step/s';
    Exit;
  end;
  if RegName= 'ACC' then
  begin
    if Val > $FFE then Val := $FFE;       // 12 bitov
    Config[StNaprave, Address] := Val;
    Result := FloatToStrF(Val* 14.551915228366851806640625, ffFixed, 8, 3);  // Power(2, -40)/250/250* Power(10, 18)= 14.551915228366851806640625
    if WithUnits then Result := Result+ ' step/s2';
    Exit;
  end;
  if RegName= 'DEC' then
  begin
    if Val > $FFE then Val := $FFE;       // 12 bitov
    Config[StNaprave, Address] := Val;
    Result := FloatToStrF(Val* 14.551915228366851806640625, ffFixed, 8, 3); // Power(2, -40)/250/250* Power(10, 18)= 14.551915228366851806640625
    if WithUnits then Result := Result+ ' step/s2';
    Exit;
  end;
  if RegName= 'MAX_SPEED' then
  begin
    if Val > $3FF then Val := $3FF;       // 10 bitov
    Config[StNaprave, Address] := Val;
    Result := FloatToStrF(Val* 15.2587890625, ffFixed, 8, 3); // Power(2, -18)/250* Power(10, 9)= 15.2587890625
    if WithUnits then Result := Result+ ' step/s';
    Exit;
  end;
  if RegName= 'MIN_SPEED' then
  begin
    if Val > $1FFF then Val := $1FFF;     // 12 bitov
    Config[StNaprave, Address] := Val;
    if Val > $FFF then
    begin
      Result := FloatToStrF((Val and $FFF)* 0.2384185791015625, ffFixed, 8, 3);  // Power(2, -24)/250* Power(10, 9)= 0.2384185791015625
      if WithUnits then Result := Result+ ' step/s (Low speed opt.)';
    end else
    begin
      Result := FloatToStrF((Val and $FFF)* 0.2384185791015625, ffFixed, 8, 3);  // Power(2, -24)/250* Power(10, 9)= 0.2384185791015625
      if WithUnits then Result := Result+ ' step/s';
    end;
    Exit;
  end;
  if RegName= 'ADC_OUT' then
  begin
    if Val > $1F then Val := $1F;         // 5 bitov
    Config[StNaprave, Address] := Val;
    Result := IntToStr(Val);
    Exit;
  end;
  if RegName= 'OCD_TH' then
  begin
    if Val > $1F then Val := $1F;         // 5 bitov
    Config[StNaprave, Address] := Val;
    Result := FloatToStrF((Val+ 1)*31.25, ffFixed, 8, 1);
    if WithUnits then Result := Result+ ' mV';
    Exit;
  end;
  if RegName= 'FS_SPD' then
  begin
    if Val > $7FF then Val := $7FF;       // 11 bitov
    Config[StNaprave, Address] := Val;
    if Val > $3FF then
    begin
      Result := FloatToStrF(((Val and $3FF)+ 0.5)* Power(2, -18)/250* Power(10, 9), ffFixed, 8, 3);
      if WithUnits then Result := Result+ ' step/s (Boost mode)';
    end else
    begin
      Result := FloatToStrF(((Val and $3FF)+ 0.5)* Power(2, -18)/250* Power(10, 9), ffFixed, 8, 3);
      if WithUnits then Result := Result+ ' step/s';
    end;
    Exit;
  end;
  if RegName= 'STEP_MODE' then
  begin
    if Val > $FF then Val := $FF;         // 8 bitov
    Config[StNaprave, Address] := Val;
    Str := '';
    if (Val and $08 = 0) then Str := Str+ 'V mode, ' else Str := Str+ 'I mode, ';  // PwrStp_VoltMode
    I := Round(Power(2, (Val and $07)));
    if (not VoltMode(StNaprave)) and (I > 16) then I := 16;   // Current mode gre samo do 16 stepov
    Str := Str+ '1/'+ IntToStr(I)+ ' step, ';
    if Val and $80 = 0 then
      Str := Str+ 'Sclk disabled'
    else begin
      I := Round(Power(2, (Val and $70) shr 4));
      if (I < 17) then
        Str := Str+ 'Sclk= 1/'+ IntToStr(I)
      else begin
        if (not VoltMode(StNaprave)) then
          Str := Str+ 'Sclk= Low'
        else
          Str := Str+ 'Sclk= 1/'+ IntToStr(I);
      end;
    end;
    Result := Str;
    Exit;
  end;
  if RegName= 'ALARM_EN' then
  begin
    if Val > $FF then Val := $FF;         // 8 bitov
    Config[StNaprave, Address] := Val;
    Result := 'Alarmi: '+ CardToBitStr(Val, 8);
    Exit;
  end;
  if RegName= 'GATECFG1' then
  begin
    if Val > $FFF then Val := $FFF;       // 12 bitov, v datasheetu je 11 bitov
    Config[StNaprave, Address] := Val;
    Str := 'wden=';
    if Val and $800 <> 0 then Str := Str+ '1, ' else Str := Str+ '0, ';
    I := (Val and $E0) shr 5;
    case I of
      0: I := 4;   1: I := 4;   2: I := 8;   3: I := 16;   4: I := 24;   5: I := 32;   6: I := 64;   7: I := 96;
    end;
    Str := Str+ 'Igate= '+ IntToStr(I)+ 'mA, ';
    I := (Val and $1F)+ 1;
    if I > 30 then I := 30;
    Str := Str+ 'tcc='+ IntToStr(I*125)+ 'ns, ';
    I := (Val and $700) shr 8;
    if I > 30 then I := 30;
    case I of
      0: I := 0;   1: I := 62;   2: I := 125;   3: I := 250;   4: I := 375;   5: I := 500;   6: I := 750;   7: I := 1000;
    end;
    Str := Str+ 'tboost='+ IntToStr(I)+ 'ns';
    Result := Str;
    Exit;
  end;
  if RegName= 'GATECFG2' then
  begin
    if Val > $FF then Val := $FF;         // 8 bitov
    Config[StNaprave, Address] := Val;
    I := (Val and $E0) shr 5+ 1;
    Str := Str+ 'Blanking time= '+ IntToStr(I*125)+ 'ns, ';
    I := (Val and $1F)+ 1;
    Str := Str+ 'Dead time= '+ IntToStr(I*125)+ 'ns';
    Result := Str;
    Exit;
  end;
  if (RegName= 'STATUS') or (RegName= 'CONFIG')then
  begin
    if Val > $FFFF then Val := $FFFF;     // 16 bitov
    Config[StNaprave, Address] := Val;
    Result := CardToBitStr(Val, 16);
    Exit;
  end;
  if (RegName= 'KVAL_HOLD') or (RegName= 'KVAL_RUN') or
     (RegName= 'KVAL_ACC' ) or (RegName= 'KVAL_DEC') then
  begin
    if Val > $FF then Val := $FF;         // 8 bitov
    Config[StNaprave, Address] := Val;
    Result := 'Vs x '+ FloatToStrF(Val/256, ffFixed, 8, 3);
    Exit;
  end;
  if RegName= 'INT_SPEED' then
  begin
    if Val > $3FFF then Val := $3FFF;     // 14 bitov
    Config[StNaprave, Address] := Val;
    Result := FloatToStrF(Val* Power(2, -26)/250* Power(10, 9), ffFixed, 8, 3); // v datasheetu je napaka, ker pise, da je exponent -18
    if WithUnits then Result := Result+ ' step/s';
    Exit;
  end;
  if (RegName= 'ST_SLP') or (RegName= 'FN_SLP_ACC') or (RegName= 'FN_SLP_DEC') then
  begin
    if Val > $FF then Val := $FF;         // 8 bitov
    Config[StNaprave, Address] := Val;
    Result := FloatToStrF(Val* 15, ffFixed, 8, 3);
    if WithUnits then Result := Result+ ' µs/step';
    Exit;
  end;
  if RegName= 'K_THERM' then
  begin
    if Val > $F then Val := $F;           // 4 bitov
    Config[StNaprave, Address] := Val;
    Result :=FloatToStrF(1+ (Val* 0.03125), ffFixed, 8, 3);
    Exit;
  end;
  if RegName= 'STALL_TH' then
  begin
    if Val > $1F then Val := $1F;         // 5 bitov
    Config[StNaprave, Address] := Val;
    Result := FloatToStrF((Val+ 1)* 31.25, ffFixed, 8, 2)+ ' mV';
    Exit;
  end;
  if (RegName= 'TVAL_HOLD') or (RegName= 'TVAL_RUN') or
     (RegName= 'TVAL_ACC' ) or (RegName= 'TVAL_DEC') then
  begin
    if Val > $FF then  Val := $FF;        // 8 bitov, v datasheetu pravi, da je 7 bitov
    Config[StNaprave, Address] := Val;
    Result := FloatToStrF((Val+ 1)*7.8, ffFixed, 8, 1);
    if WithUnits then Result := Result+ ' mV';
    Exit;
  end;
  if RegName= 'T_FAST' then
  begin
    if Val > $FF then Val := $FF;         // 8 bitov
    Config[StNaprave, Address] := Val;
    Result := 'TOFF_FAST= '+ IntToStr(2*(1+ ((Val and $F0) shr 4)))+ ', FAST_STEP= '+ IntToStr(2*(1+ (Val and $F)));
    if WithUnits then Result := Result+ ' µs';
    Exit;
  end;
  if (RegName= 'TON_MIN') or (RegName= 'TOFF_MIN') then
  begin
    if Val > $FF then Val := $FF;         // 8 bitov
    Config[StNaprave, Address] := Val;
    Result := FloatToStrF((Val+1)*0.5, ffFixed, 8, 1);
    if WithUnits then Result := Result+ ' µs';
    Exit;
  end;
end;

function TStSpin.InterpReg_AbsPos(StNaprave: Cardinal): Integer;
var
  I: Integer;
begin
  Result := 0;
  if Length(Config) < 1 then Exit;
  if StNaprave > (Length(Config)- 1) then Exit;
  I := Config[StNaprave, $01];
  if I > $3FFFFF then I := $3FFFFF; // 22 bitov
  Result := (I and $1FFFFF)- (I and $200000);
end;


function TStSpin.InterpReg_MarkPos(StNaprave: Cardinal): Integer;
var
  I: Integer;
begin
  Result := 0;
  if Length(Config) < 1 then Exit;
  if StNaprave > (Length(Config)- 1) then Exit;
  I := Config[StNaprave, $03];
  if I > $3FFFFF then I := $3FFFFF; // 22 bitov
  Result := (I and $1FFFFF)- (I and $200000);
end;

function TStSpin.InterpReg_Speed(StNaprave: Cardinal): Double;
var
  I: Integer;
begin
  Result := 0;
  if Length(Config) < 1 then Exit;
  if StNaprave > (Length(Config)- 1) then Exit;
  I := Config[StNaprave, $04];
  if I > $FFFFF then I := $FFFFF;   // 20 bitov
  Result := I* 0.01490116119384765625;
end;

function TStSpin.InterpReg_MaxSpeed(StNaprave: Cardinal): Double;
var
  I: Integer;
begin
  Result := 0;
  if Length(Config) < 1 then Exit;
  if StNaprave > (Length(Config)- 1) then Exit;
  I := Config[StNaprave, $07];
  if I > $3FF then I := $3FF;   // 10 bitov
  Result := I* 15.2587890625;
end;

procedure TStSpin.NoOp(StPonovitev: Cardinal);
var
  I: Integer;
  NrW: Word;
begin
  for I := 0 to Count- 1 do BfCmd[I] := $00;
  PocakajNaVrsto;
  for I := 0 to StPonovitev- 1 do
  begin
    try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  end;
  IsBusy := False;
end;

function TStSpin.SetParam(StNaprave: Cardinal; Address: Byte; Value: Cardinal): Integer;
var
  J, N: Integer;
  NrW: Word;
  DevNr: Cardinal;
begin
  Result := -1;
  if Count <= Integer(StNaprave) then Exit;
  DevNr := Count- 1- Integer(StNaprave);
  Address := Address and $1F;
  if RegParamInfo(StNaprave, Address).AccLvl < 1 then Exit;
  PocakajNaVrsto;
  N := RegParamInfo(StNaprave, Address).NrBayt;
  for J := 0 to ((N+ 1)* Count- 1) do BfCmd[J] := $00;
  BfCmd[DevNr] := Address;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  if NrW <> Count then begin IsBusy := False; Exit end;
  if N= 1 then
  begin
    BfCmd[DevNr] := Value and $FF;
    try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False;  Exit; end;
    if NrW <> Count then begin IsBusy := False; Exit end;
  end;
  if N= 2 then
  begin
    BfCmd[DevNr] := (Value and $FF00) shr 8;
    try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
    if NrW <> Count then begin IsBusy := False; Exit end;
    BfCmd[DevNr] := Value and $FF;
    try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
    if NrW <> Count then begin IsBusy := False; Exit end;
  end;
  if N= 3 then
  begin
    BfCmd[DevNr] := ((Value and $FF0000) shr 16) and $FF;
    try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
    if NrW <> Count then begin IsBusy := False; Exit end;
    BfCmd[DevNr] := ((Value and $FF00) shr 8) and $FF;
    try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
    if NrW <> Count then begin IsBusy := False; Exit end;
    BfCmd[DevNr] := Value and $FF;
    try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
    if NrW <> Count then begin IsBusy := False; Exit end;
  end;
  IsBusy := False;
  Result := GetParam(StNaprave, Address);
// Preberi ce je napaka....
end;

function TStSpin.GetParam(StNaprave: Cardinal; Address: Byte): Cardinal;
var
  J, N: Integer;
  NrW: Word;
begin
  Sleep(0); // Vcasih se pojavi napaka, ce takoj preberem status
  Result := 0;
  if Count < 1 then Exit;
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  Address := Address and $1F;
  N := RegParamInfo(StNaprave, Address).NrBayt;
  for J := 0 to ((N+ 1)* Count- 1) do BfCmd[J] := $00;

  BfCmd[StNaprave] := $20+ Address;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[0], @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  if NrW <> Count then begin IsBusy := False; Exit end;
  BfCmd[StNaprave] := 0;
  for J := 1 to ((N+ 1)* Count)- 1 do
    try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[J*Count], @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  if NrW <> Count then begin IsBusy := False; Exit end;
  for J := 1 to N do
  begin
   Result := Result* 256;
   Result := Result+ BfRsp[J* Count+ Integer(StNaprave)];
  end;
  Config[Count- 1- Integer(StNaprave), Address] := Result;
  IsBusy := False;
end;

function TStSpin.GetParams_AllDev(Address: Byte): TCardArr;
var
  I, J, N: Integer;
  NrW: Word;
begin
  SetLength(Result, 0);
  SetLength(Result, Count);
  if Count < 1 then Exit;
  PocakajNaVrsto;
  Address := Address and $1F;
  N := RegParamInfo(0, Address).NrBayt;
  for J := 0 to (Count- 1) do BfCmd[J] := $20+ Address;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[0], @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  if NrW <> Count then begin
   IsBusy := False; DevOK := False; Exit end;
  for J := 0 to ((N+ 1)* Count- 1) do BfCmd[J] := $00;
  for J := 1 to ((N+ 1)* Count)- 1 do
  begin
    try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[J*Count], @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
    if NrW <> Count then begin
     IsBusy := False; DevOK := False; Exit end;
  end;

  for I := 0 to Count- 1 do
  begin
    for J := 1 to N do
    begin
     Result[I] := Result[I]* 256;
     Result[I] := Result[I]+ BfRsp[J* Count+ Count- 1- I];
    end;
    Config[I, Address] := Result[I];
  end;
  IsBusy := False;
end;

procedure TStSpin.GetStatus_AllDev;
var
  I: Integer;
begin
  GetParams_AllDev($1B);
  for I := 0 to Count- 1 do
  begin
    MotorStatus[I].Stall_A      := (Config[I, $1B] and $8000 shr 15) = 1;
    MotorStatus[I].Stall_B      := (Config[I, $1B] and $4000 shr 14) = 1;
    MotorStatus[I].OCD          := (Config[I, $1B] and $2000 shr 13) = 1;
    MotorStatus[I].TH_Warning   := (Config[I, $1B] and $1800 shr 11) > 0;
    MotorStatus[I].UVLO_ADC     := (Config[I, $1B] and $0400 shr 10) = 1;
    MotorStatus[I].UVLO         := (Config[I, $1B] and $0200 shr 09) = 1;
    MotorStatus[I].STCK_Mode    := (Config[I, $1B] and $0100 shr 08) = 1;
    MotorStatus[I].CMD_Error    := (Config[I, $1B] and $0080 shr 07) = 1;
    MotorStatus[I].MOT_Running  := (Config[I, $1B] and $0060 shr 05) > 0;
    MotorStatus[I].DIR_Positive := (Config[I, $1B] and $0010 shr 04) = 1;
    MotorStatus[I].SW_Event     := (Config[I, $1B] and $0008 shr 03) = 1;
    MotorStatus[I].SW_Closed    := (Config[I, $1B] and $0004 shr 02) = 1;
    MotorStatus[I].Busy         := (Config[I, $1B] and $0002 shr 01) = 1;
    MotorStatus[I].HiZ          := (Config[I, $1B] and $0001 shr 00) = 1;
  end;
end;


function TStSpin.Set_Acc(StNaprave: Cardinal; Value: Double): Double;          // Pospesek je v step/s2, vrne nastavljen pospesek
var
  Acc: Cardinal;
begin
  Acc := Round(Value/14.551915228366851806640625);
  if Acc > $0FFE then Acc := $0FFE;
  Acc := SetParam(StNaprave, $05, Acc);
  Result := Acc* 14.551915228366851806640625;
end;

function TStSpin.Get_Acc(StNaprave: Cardinal): Double;                         // Pospesek je v step/s2
begin
  Result := GetParam(StNaprave, $05)* 14.551915228366851806640625;
end;

function TStSpin.Set_Dec(StNaprave: Cardinal; Value: Double): Double;          // Pospesek je v step/s2, vrne nastavljen pospesek
var
  Dec: Cardinal;
begin
  Dec := Round(Value/14.551915228366851806640625);
  if Dec > $0FFE then Dec := $0FFE;
  Dec := SetParam(StNaprave, $06, Dec);
  Result := Dec* 14.551915228366851806640625;
end;

function TStSpin.Get_Dec(StNaprave: Cardinal): Double;                         // Pospesek je v step/s2
begin
  Result := GetParam(StNaprave, $06)* 14.551915228366851806640625;
end;

function TStSpin.Set_MaxSpeed(StNaprave: Cardinal; Value: Double): Double;     // Htrost je v step/s, vrne nastavljeno hitrost
var
  Spd: Cardinal;
begin
  Spd := Round(Value/15.2587890625);
  Spd := SetParam(StNaprave, $07, Spd);
  Result := Spd* 15.2587890625;
end;

function TStSpin.Get_MaxSpeed(StNaprave: Cardinal): Double;                    // Hitrost je v step/s
begin
  Result := GetParam(StNaprave, $07)* 15.2587890625;
end;

function TStSpin.Set_MinSpeed(StNaprave: Cardinal; Value: Double): Double;     // Htrost je v step/s, vrne nastavljeno hitrost
var
  Spd: Integer;
begin
  Spd := Round(Value/0.2384185791015625);
  Spd := SetParam(StNaprave, $08, Spd);
  Result := Spd* 0.2384185791015625;
//  Result := (GetParam(StNaprave, $1B) and $0080) = 0;
end;

function TStSpin.Get_MinSpeed(StNaprave: Cardinal): Double;                    // Hitrost je v step/s
begin
  Result := GetParam(StNaprave, $08)* 0.2384185791015625;
end;

function TStSpin.Set_AbsPos(StNaprave: Cardinal; Value: Integer): Integer;     // Nastavi ABSPOS register na zeljeno vrednost, vrne nastavljeno
var
  Pos: Integer;
begin
  Pos := Value;
  if Pos > $1FFFFF then Pos := $1FFFFF; // position je predznaceno 22 bitno stevilo
  if Pos <-$200000 then Pos :=-$200000;
  if Pos < 0 then Pos := (Pos and $FFFFFF) or $200000;
  Pos := SetParam(StNaprave, $01, Pos);
  Result := (Pos and $1FFFFF)- (Pos and $200000);
end;

function TStSpin.Get_AbsPos(StNaprave: Cardinal): Integer;                    // Beri ABSPOS register
var
  Pos: Integer;
begin
  Pos := GetParam(StNaprave, $01);
  Result := (Pos and $1FFFFF)- (Pos and $200000);
end;

function TStSpin.Set_MarkPos(StNaprave: Cardinal; Value: Integer): Integer;  // Nastavi MARK register na zeljeno vrednost, vrne nastavljeno
var
  Pos: Integer;
begin
  Pos := Value;
  if Pos > $1FFFFF then Pos := $1FFFFF; // position je predznaceno 22 bitno stevilo
  if Pos <-$200000 then Pos :=-$200000;
  if Pos < 0 then Pos := (Pos and $FFFFFF) or $200000;
  Pos := SetParam(StNaprave, $03, Pos);
  Result := (Pos and $1FFFFF)- (Pos and $200000);
end;

function TStSpin.Get_MarkPos(StNaprave: Cardinal): Integer;                  // Beri MARK register
var
  Pos: Integer;
begin
  Pos := GetParam(StNaprave, $03);
  Result := (Pos and $1FFFFF)- (Pos and $200000);
end;

function TStSpin.Get_Speed(StNaprave: Cardinal): Double;                   // Koliko je trenutna hitrost, v step/s
begin
  Result := GetParam(StNaprave, $04)*0.01490116119384765625;
end;

function TStSpin.Set_HoldCurrent(StNaprave: Cardinal; Value: Double): Double;  // Peak tok. Tok je v mA, vrne nastavljen tok
var
  R: Double;
  Kv: Integer;
begin
  if VoltMode(StNaprave) then
  begin
    R := MotorData[StNaprave].Resistance+ Rs;
    Kv := Round(Value*256*R/1000/Vbus);
    if Kv < 0 then Kv := 0;
    if Kv > 255 then Kv := 255;
    Kv := SetParam(StNaprave, $09, Kv);
    Result := Kv*1000/256/R*Vbus;
  end else
  begin
    R := Rs;
    Kv := Round(Value*128*R/1000- 1);
    if Kv < 0 then Kv := 0;
    if Kv > 127 then Kv := 127;
    Kv := SetParam(StNaprave, $09, Kv);
    Result := (Kv+ 1)*1000/128/R;
  end;
end;

function TStSpin.Get_HoldCurrent(StNaprave: Cardinal): Double;                 // Peak tok. Tok je v mA, vrne nastavljen tok
var
  R: Double;
  Kv: Integer;
begin
  if VoltMode(StNaprave) then
  begin
    R := MotorData[StNaprave].Resistance+ Rs;
    Kv := GetParam(StNaprave, $09);
    Result := Kv*1000/256/R*Vbus;
  end else
  begin
    R := Rs;
    Kv := GetParam(StNaprave, $09);
    Result := (Kv+ 1)*1000/128/R;
  end;
end;

function TStSpin.Set_RunCurrent(StNaprave: Cardinal; Value: Double): Double;  // Peak tok. Tok je v mA, vrne nastavljen tok
var
  R: Double;
  Kv: Integer;
begin
  if VoltMode(StNaprave) then
  begin
    R := MotorData[StNaprave].Resistance+ Rs;
    Kv := Round(Value*256*R/1000/Vbus);
    if Kv < 0 then Kv := 0;
    if Kv > 255 then Kv := 255;
    Kv := SetParam(StNaprave, $0A, Kv);
    Result := Kv*1000/256/R*Vbus;
  end else
  begin
    R := Rs;
    Kv := Round(Value*128*R/1000- 1);
    if Kv < 0 then Kv := 0;
    if Kv > 127 then Kv := 127;
    Kv := SetParam(StNaprave, $0A, Kv);
    Result := (Kv+ 1)*1000/128/R;
  end;
end;

function TStSpin.Get_RunCurrent(StNaprave: Cardinal): Double;                 // Peak tok v mA, vrne nastavljen tok
var
  R: Double;
  Kv: Integer;
begin
  if VoltMode(StNaprave) then
  begin
    R := MotorData[StNaprave].Resistance+ Rs;
    Kv := GetParam(StNaprave, $0A);
    Result := Kv*1000/256/R*Vbus;
  end else
  begin
    R := Rs;
    Kv := GetParam(StNaprave, $0A);
    Result := (Kv+ 1)*1000/128/R;
  end;
end;

function TStSpin.Set_AccCurrent(StNaprave: Cardinal; Value: Double): Double;  // Peak tok. Tok je v mA, vrne nastavljen tok
var
  R: Double;
  Kv: Integer;
begin
  if VoltMode(StNaprave) then
  begin
    R := MotorData[StNaprave].Resistance+ Rs;
    Kv := Round(Value*256*R/1000/Vbus);
    if Kv < 0 then Kv := 0;
    if Kv > 255 then Kv := 255;
    Kv := SetParam(StNaprave, $0B, Kv);
    Result := Kv*1000/256/R*Vbus;
  end else
  begin
    R := Rs;
    Kv := Round(Value*128*R/1000- 1);
    if Kv < 0 then Kv := 0;
    if Kv > 127 then Kv := 127;
    Kv := SetParam(StNaprave, $0B, Kv);
    Result := (Kv+ 1)*1000/128/R;
  end;
end;

function TStSpin.Get_AccCurrent(StNaprave: Cardinal): Double;                 // Peak tok v mA, vrne nastavljen tok
var
  R: Double;
  Kv: Integer;
begin
  if VoltMode(StNaprave) then
  begin
    R := MotorData[StNaprave].Resistance+ Rs;
    Kv := GetParam(StNaprave, $0B);
    Result := Kv*1000/256/R*Vbus;
  end else
  begin
    R := Rs;
    Kv := GetParam(StNaprave, $0B);
    Result := (Kv+ 1)*1000/128/R;
  end;
end;

function TStSpin.Set_DecCurrent(StNaprave: Cardinal; Value: Double): Double;  // Peak tok. Tok je v mA, vrne nastavljen tok
var
  R: Double;
  Kv: Integer;
begin
  if VoltMode(StNaprave) then
  begin
    R := MotorData[StNaprave].Resistance+ Rs;
    Kv := Round(Value*256*R/1000/Vbus);
    if Kv < 0 then Kv := 0;
    if Kv > 255 then Kv := 255;
    Kv := SetParam(StNaprave, $0C, Kv);
    Result := Kv*1000/256/R*Vbus;
  end else
  begin
    R := Rs;
    Kv := Round(Value*128*R/1000- 1);
    if Kv < 0 then Kv := 0;
    if Kv > 127 then Kv := 127;
    Kv := SetParam(StNaprave, $0C, Kv);
    Result := (Kv+ 1)*1000/128/R;
  end;
end;

function TStSpin.Get_DecCurrent(StNaprave: Cardinal): Double;                 // Peak tok v mA, vrne nastavljen tok
var
  R: Double;
  Kv: Integer;
begin
  if VoltMode(StNaprave) then
  begin
    R := MotorData[StNaprave].Resistance+ Rs;
    Kv := GetParam(StNaprave, $0C);
    Result := Kv*1000/256/R*Vbus;
  end else
  begin
    R := Rs;
    Kv := GetParam(StNaprave, $0C);
    Result := (Kv+ 1)*1000/128/R;
  end;
end;

function TStSpin.Set_StpMode(StNaprave: Cardinal; Value: Cardinal): Cardinal;   // Nastavi najblizji MicroStep, vrne nastavljeno vrednost
var
  Stp: Cardinal;
  Vi: Cardinal;
begin
  case value of
     0.. 1: Stp := 0;  // 1
         2: Stp := 1;  // 2
     3.. 6: Stp := 2;  // 4
     7..12: Stp := 3;  // 8
    13..24: Stp := 4;  // 16
    25..48: Stp := 5;  // 32
    49..96: Stp := 6;  // 64
  else      Stp := 7;  // 128
  end;
  if (not VoltMode(StNaprave)) and (Stp > 4) then Stp := 4;
  Vi := ( Config[StNaprave, $16] and $F8) or Stp;
  Stp := SetParam(StNaprave, $16, Vi) and $07;
  Result := 1;
  case Stp of
    0: Result :=   1;
    1: Result :=   2;
    2: Result :=   4;
    3: Result :=   8;
    4: Result :=  16;
    5: Result :=  32;
    6: Result :=  64;
    7: Result := 128;
  end;
end;

function TStSpin.Get_StpMode(StNaprave: Cardinal): Cardinal;   // Vrne nastavljeno vrednost µStepa
var
  Stp: Cardinal;
begin
  Stp := GetParam(StNaprave, $16) and $07;
  Result := 1;
  case Stp of
    0: Result :=   1;
    1: Result :=   2;
    2: Result :=   4;
    3: Result :=   8;
    4: Result :=  16;
    5: Result :=  32;
    6: Result :=  64;
    7: Result := 128;
  end;
end;

function TStSpin.Run_DirFwd(StNaprave: Cardinal; Speed: Double): Double;       // hitrost je v step/s, vrne zaokrozeno hitrost
var
  Dir: Cardinal;
  I: Integer;
  NrW: Word;
  Spd: Integer;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  Spd := Round(67.108864* Speed);
  Dir := 1;
  if Spd < 0 then
  begin
    Spd := Abs(Spd);
    Dir := 0;
  end;
  Spd := Spd and $0FFFFF;
  Result := Spd/67.108864;
  if Dir = 0 then Result := -1* Result;
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for I := 0 to 4* Count- 1 do BfCmd[I] := $00;

  BfCmd[StNaprave] := $50 or Dir;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((Spd and $FF0000) shr 16) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((Spd and $00FF00) shr  8) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((Spd and $0000FF) shr  0) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

function TStSpin.Run_DirBck(StNaprave: Cardinal; Speed: Double): Double;   // hitrost je v step/s, vrne zaokrozeno hitrost
begin
  Result := -1* Run_DirFwd(StNaprave, -1* Speed);
end;

procedure TStSpin.StpClk_DirFwd(StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $59;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[0], @BfCmd[0], Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.StpClk_DirBck(StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $58;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[0], @BfCmd[0], Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

function TStSpin.Move_DirFwd(StNaprave: Cardinal; NrClocks: Integer): Integer;
var
  Dir: Integer;
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  Dir := 1;
  if NrClocks < 0 then
  begin
    Dir := 0;
    NrClocks := Abs(NrClocks);
  end;
  if NrClocks > $3FFFFF then NrClocks := $3FFFFF;
  Result := NrClocks;
  if Dir= 0 then Result := -Result;
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to (4* Count- 1) do BfCmd[J] := $00;
  BfCmd[StNaprave] := $40 or Dir;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  BfCmd[StNaprave] := ((NrClocks and $FF0000) shr 16) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  BfCmd[StNaprave] := ((NrClocks and $FF00) shr 8) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  BfCmd[StNaprave] := NrClocks and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

function TStSpin.Move_DirBck(StNaprave: Cardinal; NrClocks: Integer): Integer;
begin
  Result := Move_DirFwd(StNaprave, -1* NrClocks);
  Result := -Result;
end;

function TStSpin.GoTo_Short(StNaprave: Cardinal; AbsPos: Integer): Integer;
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if AbsPos > $1FFFFF then AbsPos := $1FFFFF; // position je predznaceno 22 bitno stevilo
  if AbsPos <-$200000 then AbsPos :=-$200000;
  if AbsPos < 0 then AbsPos := (AbsPos and $FFFFFF) or $200000;
  Result := AbsPos;
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to (4* Count- 1) do BfCmd[J] := $00;

  BfCmd[StNaprave] := $60;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((AbsPos and $FF0000) shr 16) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((AbsPos and $FF00) shr 8) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := AbsPos and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

function TStSpin.GoTo_DirFwd(StNaprave: Cardinal; AbsPos: Integer): Integer;
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if AbsPos > $1FFFFF then AbsPos := $1FFFFF; // position je predznaceno 22 bitno stevilo
  if AbsPos <-$200000 then AbsPos :=-$200000;
  if AbsPos < 0 then AbsPos := (AbsPos and $FFFFFF) or $200000;
  Result := AbsPos;
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to (4* Count- 1) do BfCmd[J] := $00;

  BfCmd[StNaprave] := $69;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((AbsPos and $FF0000) shr 16) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((AbsPos and $FF00) shr 8) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := AbsPos and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

function TStSpin.GoTo_DirBck(StNaprave: Cardinal; AbsPos: Integer): Integer;
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if AbsPos > $1FFFFF then AbsPos := $1FFFFF; // position je predznaceno 22 bitno stevilo
  if AbsPos <-$200000 then AbsPos :=-$200000;
  if AbsPos < 0 then AbsPos := (AbsPos and $FFFFFF) or $200000;
  Result := AbsPos;
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to (4* Count- 1) do BfCmd[J] := $00;

  BfCmd[StNaprave] := $68;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((AbsPos and $FF0000) shr 16) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((AbsPos and $FF00) shr 8) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := AbsPos and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

//GoUntil_ResetAbs_DirFwd, GoUntil_ResetAbs_DirBck,        // Motion with desired speed until SW closed, after event SoftStop. At SW event ABS register is reset
//GoUntil_PresetMark_DirFwd, GoUntil_PresetMark_DirBck,    // Motion with desired speed until SW closed, after event SoftStop. At SW event MARK register is preset with ABS register

function TStSpin.GoUntil_rAbs_dFwd(StNaprave: Cardinal; Speed: Double): Double;
var
  Dir: Cardinal;
  Spd: Integer;
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  Spd := Round(67.108864* Speed);
  Dir := 1;
  if Spd < 0 then
  begin
    Spd := Abs(Spd);
    Dir := 0;
  end;
  Spd := Spd and $0FFFFF;
  Result := Spd/67.108864;
  if Dir = 0 then Result := -1* Result;
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to (4* Count- 1) do BfCmd[J] := $00;

  BfCmd[StNaprave] := $82 or Dir;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((Spd and $FF0000) shr 16) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((Spd and $00FF00) shr  8) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((Spd and $0000FF) shr  0) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

function TStSpin.GoUntil_rAbs_dBck(StNaprave: Cardinal; Speed: Double): Double;
begin
  Result := GoUntil_rAbs_dFwd(StNaprave, -1* Speed);
  Result := -Result;
end;

function TStSpin.GoUntil_pMrk_dFwd(StNaprave: Cardinal; Speed: Double): Double;
var
  Dir: Cardinal;
  Spd: Integer;
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  Spd := Round(67.108864* Speed);
  Dir := 1;
  if Spd < 0 then
  begin
    Spd := Abs(Spd);
    Dir := 0;
  end;
  Spd := Spd and $0FFFFF;
  Result := Spd/67.108864;
  if Dir = 0 then Result := -1* Result;
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to (4* Count- 1) do BfCmd[J] := $00;

  BfCmd[StNaprave] := $8A or Dir;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((Spd and $FF0000) shr 16) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((Spd and $00FF00) shr  8) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;

  BfCmd[StNaprave] := ((Spd and $0000FF) shr  0) and $FF;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

function TStSpin.GoUntil_pMrk_dBck(StNaprave: Cardinal; Speed: Double): Double;
begin
  Result := GoUntil_pMrk_dFwd(StNaprave, -1* Speed);
  Result := -Result;
end;

procedure TStSpin.RlsSW_rAbs_DirFwd (StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $93;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.RlsSW_rAbs_DirBck (StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $92;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.RlsSW_pMrk_DirFwd (StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $9B;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.RlsSW_pMrk_DirBck (StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $9A;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.GoHome(StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $70;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.GoMark(StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $78;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.ResetPos(StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $D8;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.ResetDevice(StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $C0;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.SoftStop(StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $B0;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.HardStop(StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $B8;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.SoftHiZ(StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $A0;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.HardHiZ(StNaprave: Cardinal);
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := Count- 1- Integer(StNaprave);
  for J := 0 to Count- 1 do BfCmd[J] := $00;
  BfCmd[StNaprave] := $A8;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp, @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

function TStSpin.GetClearStatus(StNaprave: Cardinal): Cardinal;
var
  J: Integer;
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
  PsCnt: Cardinal;
begin
  Result := 0;
  PsCnt := Abs(Count);
  if Count <= Integer(StNaprave) then Exit;
  PocakajNaVrsto;
  StNaprave := PsCnt- 1- StNaprave;
  for J := 0 to (3* PsCnt- 1) do BfCmd[J] := $00;
  BfCmd[StNaprave] := $D0;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[0* PsCnt], @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  BfCmd[StNaprave] := 0;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[1* PsCnt], @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  BfCmd[StNaprave] := 0;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[2* PsCnt], @BfCmd, Count, NrW, True); except IsBusy := False; Exit; end;
  Result := BfRsp[1* PsCnt+ StNaprave]*256+  BfRsp[2* PsCnt+ StNaprave];
  IsBusy := False;
end;

function TStSpin.GetNumberOfDevices: Integer;  // Pogledam, koliko kontrolerjev je prikljucenih, vrne koliko jih je. Ce ni nobenega je 0, ce je napaka, je -1. Inicializiram tabele
var                                            // Najvecje stevilo kontrolerjev je 10
  J, N: Integer;
  NrW: Word;
  R: Cardinal;
begin
  Result := -1;
  PocakajNaVrsto;
  N := 0;
  BfCmd[0] := $5F;  // $5F je unvalid komanda
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[0], @BfCmd, 1, NrW, False); except Count := 0; IsBusy := False; Exit; end;
  BfCmd[0] := $00;  // nop
  for J := 0 to 9 do
  begin
    try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[0], @BfCmd, 1, NrW, False); except Count := 0; IsBusy := False; Exit; end;
    if BfRsp[0]= $5F then
    begin
      N := J+ 1;
      Break;
    end;
  end;
  try R := FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[0], @BfCmd, 1, NrW, True); except Count := 0; IsBusy := False; Exit; end;
  if R <> 0 then
  begin
    Result := -1;
    Count := 0;
  end else
  begin
    Result := N;
    Count := N;
    SetLength(Config, N);
    SetLength(MotorData, N);
    SetLength(MotorStatus, N)
  end;
  IsBusy := False;
end;

function TStSpin.VoltMode(StNaprave: Cardinal): Boolean;
begin
  Result := False;
  if Length(Config) > StNaprave then
    if Config[StNaprave, $16] and $08 = 0 then Result := True else Result := False;
end;

procedure TStSpin.AddCommand(StNaprave: Cardinal; Komanda: TPwrCmd; Parameter: Integer);
var
  Speed, Pozic: Integer;
  PsCnt: Cardinal;
begin
  PsCnt := Abs(Count);
  if Count <= Integer(StNaprave) then Exit;
  StNaprave := PsCnt- 1- StNaprave;
  Speed := Parameter;
  Pozic := Parameter;

  if Pozic > $1FFFFF then Pozic := $1FFFFF; // position je predznaceno 22 bitno stevilo
  if Pozic <-$200000 then Pozic :=-$200000;
  if Pozic < 0 then Pozic := (Pozic and $FFFFFF) or $200000;

  if Speed < 0 then Speed := 0;                // speed je nepredznaceno 20 bitno stevilo
  if Speed > $0FFFFF then Speed :=$0FFFFF;
  case Komanda of
    cNOP:                       begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00;
                                  BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00;
                                  BfCmd[3* PsCnt+ StNaprave] := $00;
                                end;
    cRun_DirFwd:                begin
                                  BfCmd[0* PsCnt+ StNaprave] := $51;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Speed and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Speed and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Speed and $0000FF) shr  0) and $FF;
                                end;
    cRun_DirBck:                begin
                                  BfCmd[0* PsCnt+ StNaprave] := $50;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Speed and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Speed and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Speed and $0000FF) shr  0) and $FF;
                                end;

    cMove_DirFwd:               begin
                                  BfCmd[0* PsCnt+ StNaprave] := $41;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Pozic and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Pozic and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Pozic and $0000FF) shr  0) and $FF;
                                end;
    cMove_DirBck:               begin
                                  BfCmd[0* PsCnt+ StNaprave] := $40;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Pozic and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Pozic and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Pozic and $0000FF) shr  0) and $FF;
                                end;
    cGoTo_Short:                 begin
                                  BfCmd[0* PsCnt+ StNaprave] := $60;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Pozic and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Pozic and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Pozic and $0000FF) shr  0) and $FF;
                                end;

    cGoTo_DirFwd:               begin
                                  BfCmd[0* PsCnt+ StNaprave] := $69;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Pozic and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Pozic and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Pozic and $0000FF) shr  0) and $FF;
                                end;
    cGoTo_DirBck:               begin
                                  BfCmd[0* PsCnt+ StNaprave] := $68;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Pozic and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Pozic and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Pozic and $0000FF) shr  0) and $FF;
                                end;
    cGoUntil_ResetAbs_DirFwd:   begin
                                  BfCmd[0* PsCnt+ StNaprave] := $83;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Speed and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Speed and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Speed and $0000FF) shr  0) and $FF;
                                end;
    cGoUntil_ResetAbs_DirBck:   begin
                                  BfCmd[0* PsCnt+ StNaprave] := $82;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Speed and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Speed and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Speed and $0000FF) shr  0) and $FF;
                                end;
    cGoUntil_PresetMark_DirFwd: begin
                                  BfCmd[0* PsCnt+ StNaprave] := $8B;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Speed and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Speed and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Speed and $0000FF) shr  0) and $FF;
                                end;
    cGoUntil_PresetMark_DirBck: begin
                                  BfCmd[0* PsCnt+ StNaprave] := $8A;
                                  BfCmd[1* PsCnt+ StNaprave] := ((Speed and $FF0000) shr 16) and $FF;
                                  BfCmd[2* PsCnt+ StNaprave] := ((Speed and $00FF00) shr  8) and $FF;
                                  BfCmd[3* PsCnt+ StNaprave] := ((Speed and $0000FF) shr  0) and $FF;
                                end;
    cReleseSW_ResetAbs_DirFwd:  begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $93;
                                end;
    cReleseSW_ResetAbs_DirBck:  begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $92;
                                end;
    cReleseSW_PresetMark_DirFwd:begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $9B;
                                end;
    cReleseSW_PresetMark_DirBck:begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $9A;
                                end;
    cGoHome:                    begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $70;
                                end;
    cGoMark:                    begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $78;
                                end;
    cReset_Pos:                 begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $D8;
                                end;
    cSoftStop:                  begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $B0;
                                end;
    cHardStop:                  begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $B8;
                                end;
    cSoftHiZ:                   begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $A0;
                                end;
    cHardHiZ:                   begin
                                  BfCmd[0* PsCnt+ StNaprave] := $00; BfCmd[1* PsCnt+ StNaprave] := $00;
                                  BfCmd[2* PsCnt+ StNaprave] := $00; BfCmd[3* PsCnt+ StNaprave] := $A8;
                                end;
  else
    Exit;
  end;
end;

procedure TStSpin.ExecuteCommands;
var
  NrW: Word;
  K, KK: Integer;   // brez tega se pojavlja napaka
begin
  PocakajNaVrsto;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[0* Count], @BfCmd[0* Count], Count, NrW, True); except IsBusy := False; Exit; end;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[1* Count], @BfCmd[1* Count], Count, NrW, True); except IsBusy := False; Exit; end;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[2* Count], @BfCmd[2* Count], Count, NrW, True); except IsBusy := False; Exit; end;
  try FT4222_SPIMaster_SingleReadWrite(FT4222_Hnd_A, @BfRsp[3* Count], @BfCmd[3* Count], Count, NrW, True); except IsBusy := False; Exit; end;
  IsBusy := False;
end;

procedure TStSpin.Close;
var
  K: array [0..3]of Integer;   // brez tega se pojavlja napaka
  R: Cardinal;
begin
  DevOK := False;
  FT4222_UnInitialize(FT4222_Hnd_A);
  FT4222_UnInitialize(FT4222_Hnd_B);
  FT_Close(FT4222_Hnd_A);
  FT4222_Hnd_A := nil;
  FT_Close(FT4222_Hnd_B);
  FT4222_Hnd_B := nil;
  Sleep(10);
end;


end.
