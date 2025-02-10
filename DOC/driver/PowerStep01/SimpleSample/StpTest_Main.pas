unit StpTest_Main;

interface

uses
  Ftd2xx, LibFT4222, MahUSB, StSpin,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.Samples.Spin, Registry;


const
  CRLF = #13#10;

  RegPath : string = '\Software\RLS\stepper_control_PowerStep01';
  RegValuePomikNaprej : string = 'PomikNaprej';
  RegValuePomikNazaj : string = 'PomikNazaj';
  RegValueKorakovNaObrat : string = 'KorakovNaObrat';
  RegValueHitrost : string = 'Hitrost';
  RegValuePospesek : string = 'Pospesek';
  RegValuePodporaAksIM : string = 'PodporaAksIM';
  RegValueEnableControl : string = 'KrmiliEnable';





type
  TMainForm = class(TForm)
    BtnLoadParam: TButton;
    OpenDialog1: TOpenDialog;
    BtnClearStatus: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    btnStop: TButton;
    btnCikel: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    udNaprej: TUpDown;
    udNazaj: TUpDown;
    Label3: TLabel;
    seHitrost: TSpinEdit;
    cbKratNicCelaEna: TCheckBox;
    Label8: TLabel;
    Label9: TLabel;
    sbVecManj: TSpeedButton;
    seStKorakovNaObrat: TSpinEdit;
    sePospesek: TSpinEdit;
    cbPodporaAksIMDebug: TCheckBox;
    cbEnableControl: TCheckBox;
    pnlEnabled: TPanel;
    StBar0: TStatusBar;
    LoopTimer: TTimer;
    stBar1: TStatusBar;
    cbPonavljaj: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnLoadParamClick(Sender: TObject);
    procedure BtnClearStatusClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnCikelClick(Sender: TObject);
    procedure StBar0DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure LoopTimerTimer(Sender: TObject);
    procedure sbVecManjClick(Sender: TObject);
    procedure pnlEnabledClick(Sender: TObject);
    procedure cbPodporaAksIMDebugClick(Sender: TObject);
    procedure stBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure StBar0DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbPonavljajClick(Sender: TObject);
  private
    USB: TUsbClass;
    MotorID: Integer;
    procedure ChangeEvent(const bInserted: Boolean; const bRemoved: Boolean; const ADevType, ADriverName, AFriendlyName: string);
    procedure RefreshStatusMain(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect; MotorIndex: Integer);
    procedure RefreshStatusAux(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect; MotorIndex: Integer);
    procedure UpdateStatus;

    { Private declarations }
  public
    var StpDrv: TStSpin;
    { Public declarations }
    Vec: Boolean;
    KoncnaStikala : byte;
    IsciReferenco : boolean;
    ReferencaNajdena : boolean;
    PremikZakljucen : boolean;
    ESC: Boolean;
  end;


  THandleData = record
    ClassName: WideString;
    WinText: WideString;
    FormHandle: THandle;
    Visible: Boolean;
    Icon: Boolean;
    Child: Boolean;
    Exists: Boolean;
    Enabled: Boolean;
    Result: THandle;
  end;
  PHandleData = ^THandleData;




var
  HandleData: THandleData;
  MainForm: TMainForm;

implementation

{$R *.dfm}


function EnumWindowsProc2(Handle: THandle; HandleData: PHandleData): Boolean; stdcall;
var
  Caption: array[0..MAX_PATH] of WideChar;
  ClassName: array[0..MAX_PATH] of WideChar;
{  HParent: THandle;}
begin
  Result := True;
  GetClassName(Handle, @ClassName, MAX_PATH-1);
try
  if (ClassName) <> '' then
  begin
    GetWindowText(Handle, @Caption, MAX_PATH-1);
    if (UpperCase(ClassName) = UpperCase(HandleData.ClassName)) then begin
      if (Pos(UpperCase(HandleData.WinText),UpperCase(Caption)) > 0) then begin
    {
          if IsIconic(AHandle) then
            AppData^.Icon := True;
          if IsWindow(AHandle) then
            AppData^.Exists := True;
          if IsWindowVisible(AHandle) then
            AppData^.Visible := True;
          HParent := GetParent(AHandle);
          if HParent <> 0 then
            AppData^.Child := IsChild(HParent,AHandle);
          IsWindowEnabled(AHandle);      // Preverjamo vse mogoce, kar bi lahki izvedeli o Handlu
    }
        HandleData.Result := Handle;
        Result := False;
      end;
    end;
  end;
except

end;
end;


function FindHandle(MainForm, MainFormCaption, TheClass, TheClassCaption: WideString): THandle;
begin
  FillChar(HandleData,SizeOf(THandleData),#0);
  HandleData.FormHandle := Invalid_Handle_Value;
  HandleData.Result := Invalid_Handle_Value;
  HandleData.ClassName := MainForm;
  HandleData.WinText := MainFormCaption;
  EnumWindows(@EnumWindowsProc2, LongInt(@HandleData));                // Najprej iscemo TApplication
  if HandleData.Result <> Invalid_Handle_Value then begin
    HandleData.FormHandle := HandleData.Result;
    HandleData.Result := Invalid_Handle_Value;
    HandleData.ClassName := TheClass;
    HandleData.WinText := TheClassCaption;
    EnumChildWindows(HandleData.FormHandle,@EnumWindowsProc2, LongInt(@HandleData));  // Nato iscemo pravi TMainForm
    if HandleData.Result <> Invalid_Handle_Value then begin
//        if not IsWindowVisible(HandleData.Result) then
        if not IsWindow(HandleData.Result) then
          HandleData.Result := Invalid_Handle_Value;
    end;
  end;
  Result := HandleData.Result;
end;




procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with TRegistry.Create do
    try
    Access := KEY_ALL_ACCESS;
    if OpenKey (RegPath, True) then begin
      WriteInteger(RegValuePomikNaprej,udNaprej.Position);
      WriteInteger(RegValuePomikNazaj,udNazaj.Position);
      WriteInteger(RegValueKorakovNaObrat,seStKorakovNaObrat.Value);
      WriteInteger(RegValueHitrost,seHitrost.Value);
      WriteInteger(RegValuePospesek,sePospesek.Value);
      WriteBool(RegValuePodporaAksIM,cbPodporaAksIMDebug.Checked);
      WriteBool(RegValueEnableControl,cbEnableControl.Checked);
      CloseKey;
    end
    else ShowMessage ('Ne morem odpreti poti v registru:' + CRLF + RegPath);
    finally
      Free;
    end; // with reg

end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
  SN: string;

  PomikNaprej,
  PomikNazaj: Integer;
  Hitrost: Integer;
  Pospesek: Integer;
  KorakovNaObrat: Integer;

begin
  MotorID := -1;
  SN := '';
  USB := TUsbClass.Create;
  USB.OnUsbChange := Self.ChangeEvent;
  try
    StpDrv := TStSpin.Create;
  except
    StpDrv.Free;
    ShowMessage('Napaka pri kreiranju StSpin objekta.');
    MainForm.Close;
  end;
  if  StpDrv.Open(SN) then
  begin
    Caption := Caption + ' ' +SN;
    StpDrv.GetNumberOfDevices;
    if StpDrv.Count > 0 then
    begin
      MotorID := 0;
      with TRegistry.Create do
      begin
        try
          if OpenKey (RegPath, False) then
          begin
            if ValueExists (RegValuePomikNaprej) then
              PomikNaprej := ReadInteger (RegValuePomikNaprej)
            else
              PomikNaprej := 450;
            if ValueExists (RegValuePomikNazaj) then
              PomikNazaj := ReadInteger (RegValuePomikNazaj)
            else
              PomikNazaj := -90;
            if ValueExists (RegValueKorakovNaObrat) then
              KorakovNaObrat := ReadInteger (RegValueKorakovNaObrat)
            else
              KorakovNaObrat := -90;
            if ValueExists (RegValueHitrost) then
              Hitrost := ReadInteger (RegValueHitrost)
            else
              Hitrost := 200;
            if ValueExists (RegValuePospesek) then
              Pospesek := ReadInteger (RegValuePospesek)
            else
              Pospesek := 50;
            if ValueExists (RegValuePodporaAksIM) then
              cbPodporaAksIMDebug.Checked := ReadBool (RegValuePodporaAksIM)
            else
              cbPodporaAksIMDebug.Checked := True;
            if ValueExists (RegValueEnableControl) then
              cbEnableControl.Checked := ReadBool (RegValueEnableControl)
            else
              cbEnableControl.Checked := False;
            CloseKey;
          end;
        finally
          Free;
        end;
      end;
      if StpDrv.Count > 0 then
      begin
        StpDrv.Config[MotorID, 1] := 2408559;
        StpDrv.Config[MotorID, 2] := 247;
        StpDrv.Config[MotorID, 3] := 0;
        StpDrv.Config[MotorID, 4] := 0;
        StpDrv.Config[MotorID, 5] := 74;
        StpDrv.Config[MotorID, 6] := 74;
        StpDrv.Config[MotorID, 7] := 1023;
        StpDrv.Config[MotorID, 8] := 4096;
        StpDrv.Config[MotorID, 9] := 12;
        StpDrv.Config[MotorID, 10] := 60;
        StpDrv.Config[MotorID, 11] := 60;
        StpDrv.Config[MotorID, 12] := 60;
        StpDrv.Config[MotorID, 13] := 16383;
        StpDrv.Config[MotorID, 14] := 16;
        StpDrv.Config[MotorID, 15] := 27;
        StpDrv.Config[MotorID, 16] := 27;
        StpDrv.Config[MotorID, 17] := 0;
        StpDrv.Config[MotorID, 18] := 16;
        StpDrv.Config[MotorID, 19] := 8;
        StpDrv.Config[MotorID, 20] := 16;
        StpDrv.Config[MotorID, 21] := 2047;
        StpDrv.Config[MotorID, 22] := 7;
        StpDrv.Config[MotorID, 23] := 255;
        StpDrv.Config[MotorID, 24] := 195;
        StpDrv.Config[MotorID, 25] := 64;
        StpDrv.Config[MotorID, 26] := 40870;
        StpDrv.Config[MotorID, 27] := 58899;
        for I := 1 to 27 do
          StpDrv.SetParam(MotorID, I, StpDrv.Config[MotorID, I]);
        Pospesek := Round(StpDrv.Get_Acc(MotorID));
        LoopTimer.Enabled := True;
        ClientWidth := sbVecManj.Width + sbVecManj.Left + 8;
        udNaprej.Position := PomikNaprej;
        udNazaj.Position := PomikNazaj;
        seStKorakovNaObrat.Value := KorakovNaObrat;
        seHitrost.Value := Hitrost;
        sePospesek.Value := Pospesek;
        cbPodporaAksIMDebugClick(nil);  // pravi zaslov gumba za premik in snemanje
        StpDrv.GetClearStatus(MotorID);
      end;
    end;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(USB) then
    USB.Free;
  if Assigned(StpDrv) then
    StpDrv.Free;
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = vk_ESCAPE then
    Esc := True;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
var
  Speed: Double;
begin
  Speed := seHitrost.Value;
  if cbKratNicCelaEna.Checked then
    Speed := Speed * 0.1;
  StpDrv.Run_DirBck(MotorID,Speed);
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
var
  Speed: Double;
begin
  Speed := seHitrost.Value;
  if cbKratNicCelaEna.Checked then
    Speed := Speed * 0.1;
  StpDrv.Run_DirFwd(MotorID,Speed);
end;

procedure TMainForm.StBar0DblClick(Sender: TObject);
begin
  stpDrv.ResetPos(MotorID);
end;

procedure TMainForm.StBar0DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  RefreshStatusMain(StatusBar, Panel, Rect, 0);
end;

procedure TMainForm.stBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  RefreshStatusAux(StatusBar, Panel, Rect, 0);
end;

procedure TMainForm.LoopTimerTimer(Sender: TObject);
begin
  UpdateStatus;
end;



procedure TMainForm.pnlEnabledClick(Sender: TObject);
begin
    if pnlEnabled.BevelOuter = bvRaised then begin
      StpDrv.SoftStop(MotorID);

//      StepEnable (seNaslovKontrolerja.Value, True) then begin
        pnlEnabled.BevelOuter := bvLowered;
    end
    else begin
      StpDrv.SoftHiZ(MotorID);
      pnlEnabled.BevelOuter := bvRaised;
    end;

end;

procedure TMainForm.UpdateStatus;
begin
  if StpDrv.Count > 0 then
  begin
    StpDrv.GetParams_AllDev($01);     // Current position - R/WS
    StpDrv.GetParams_AllDev($04);     // SPEED  - read only
    StpDrv.GetParams_AllDev($1B);     // Status - read only
  end;
  StBar0.Refresh;
  StBar1.Refresh;
end;



procedure TMainForm.BtnLoadParamClick(Sender: TObject);
var
  F: TextFile;
  I: Integer;
  V: string;
begin
  if OpenDialog1.Execute then
  begin
    AssignFile(F, OpenDialog1.FileName);
    Reset(F);
    I := 0;
    while not Eof(F) do
    begin
      Readln(F, V);
      I := I+ 1;
      if (I <= $1B) then
      begin
        StpDrv.Config[MotorID, I] := StrToInt(V);
        StpDrv.SetParam(MotorID, I, StpDrv.Config[MotorID, I]);
      end;
    end;
    CloseFile(f);
  end;
end;

procedure TMainForm.cbPodporaAksIMDebugClick(Sender: TObject);
begin
  if cbPodporaAksIMDebug.Checked then
    btnCikel.Caption := 'Start motorja in snemanja'
  else
    btnCikel.Caption := 'Start motorja';
end;

procedure TMainForm.cbPonavljajClick(Sender: TObject);
begin
  if cbPonavljaj.Checked then 
    begin
    cbPodporaAksIMDebug.Checked := False;
    repeat
      btnCikelClick(nil);
      Application.ProcessMessages;
    until Esc OR Application.Terminated OR (cbPonavljaj.Checked = False);
    end;  
end;

procedure TMainForm.btnStopClick(Sender: TObject);
begin
  StpDrv.SoftStop(MotorID);
end;

procedure TMainForm.btnCikelClick(Sender: TObject);
var
  OnPos: boolean;
  P1, P2: Integer;
  H: THandle;
  Pogoj: Boolean;
  BUSY: Cardinal;
  fSpeed: Double;
  nSpeed: Double;
begin

  H := Invalid_Handle_Value;
  if cbPodporaAksIMDebug.Checked then
    H :=  FIndHandle('TFormOmejitevPisanja','omejitev','TButton','OK');
  P1 := udNaprej.Position;
  P2 := udNazaj.Position;
  fSpeed := StpDrv.Get_MaxSpeed(MotorID);
  nSpeed := seHitrost.Value;
  if cbKratNicCelaEna.Checked then
    nSpeed := nSpeed / 10;
  if nSpeed < 16  then
    Application.MessageBox('Minimalna hitrost v pozicijskem naèinu je 16!','Snemanje posnetkov',MB_OK or MB_ICONWARNING);
  StpDrv.Set_MaxSpeed(MotorID,nSpeed);
  StpDrv.Set_Acc(MotorID,sePospesek.Value);
  BtnCikel.Enabled := False;
  if cbPodporaAksIMDebug.Checked then begin
    H :=  FIndHandle('TFormOmejitevPisanja','omejitev','TButton','OK');
    Pogoj := False;
    if H <>  Invalid_Handle_Value then begin
      Pogoj := IsWindowVisible(H);
    end;
  end
  else
    Pogoj := True;
  Esc := False;
  if Pogoj then begin
    OnPos := False;
    StpDrv.Move_DirFwd(MotorID,Round(seStKorakovNaObrat.Value*P1/360));
    if cbPodporaAksIMDebug.Checked then begin
      PostMessage(H,WM_LBUTTONDOWN,0,0);
      Sleep(10);
      PostMessage(H,WM_LBUTTONUP,0,0);
    end;
    repeat
      Sleep(50);
      Application.ProcessMessages;
      StpDrv.GetParams_AllDev($1B);     // Status - read only
      BUSY := (StpDrv.Config[MotorID, $1B] and $0002) shr 1;
      Pogoj := (BUSY = 1);
    until Pogoj or Esc;
  end
  else begin
    Application.MessageBox('Dialog za omejitev snemanja z gumbom OK mora biti viden.'+#13#10+
                           'Aksim vmesnik / debugger ni pripravljen na snemanje posnetkov.'+#13#10+#13#10+
                           'Vpišite komentar, kliknite gumb Shrajuj BIN, izberite ime datoteke in kliknite Save.'+#13#10+
                           'Kliknite gumb ''Start motorja in snemanja'' šele, ko se prikaže dialog za omejitev snemanja.'
                           ,'Snemanje posnetkov',MB_OK or MB_ICONWARNING);
    BtnCikel.Enabled := True;
    Exit;
  end;
  if Esc then
    StpDrv.HardStop(MotorID)
  else begin
    H :=  FindHandle('TMainForm','RLS d.o.o. aksim','TPanel','Shranjuj bin');
    if cbPodporaAksIMDebug.Checked then
      Pogoj := H <>  Invalid_Handle_Value
    else
      Pogoj := True;
    if Pogoj then begin
      if cbPodporaAksIMDebug.Checked then begin
        PostMessage(H,WM_LBUTTONDOWN,0,0);
        Sleep(1);
        PostMessage(H,WM_LBUTTONUP,0,0);
      end;
    end;
    StpDrv.Move_DirFwd(MotorID,Round(seStKorakovNaObrat.Value*P2/360));
    repeat
      Sleep(50);
      Application.ProcessMessages;
      StpDrv.GetParams_AllDev($1B);     // Status - read only
      BUSY := (StpDrv.Config[MotorID, $1B] and $0002) shr 1;
      Pogoj := (BUSY = 1);
    until Pogoj or Esc;
    StpDrv.Set_MaxSpeed(MotorID,fSpeed);
  end;
  if cbEnableControl.Checked then begin
    StpDrv.SoftHiZ(MotorID);
    pnlEnabled.BevelOuter := bvRaised;
  end;
  BtnCikel.Enabled := True;
end;

procedure TMainForm.BtnClearStatusClick(Sender: TObject);
begin
  StpDrv.GetClearStatus(MotorID);
end;

procedure TMainForm.ChangeEvent(const bInserted: Boolean; const bRemoved: Boolean; const ADevType, ADriverName, AFriendlyName: string);
var
  I: Integer;
  SN: string;
begin
  if (AFriendlyName = 'FT4222H') then
  begin
    MotorID := -1;
    SN := '';
    if bInserted then
    begin
      Sleep(250); // malo mu dam casa, da se zbrihta, 100 je premalo
      if StpDrv.Open(SN) then
      begin
        Caption := 'Pogon koraènega motorja '+SN;
        StpDrv.GetNumberOfDevices;
        if StpDrv.Count > 0 then
          MotorID := 0;
      end;
    end else
    begin
      StpDrv.Close;
      Caption := 'Pogon koraènega motorja ';
    end;
  end;
end;


procedure TMainForm.RefreshStatusMain(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect; MotorIndex: Integer);
var
  STALL_A, STALL_B, OCD, TH_STATUS, UVLO_ADC, UVLO, CMD_ERROR, MOT_STATUS, DIR, SW_EVN, SW_F, BUSY, HiZ: Cardinal;
  ClNeutr: TColor;
begin
  if Length(StpDrv.Config) < (MotorIndex+ 1) then Exit;
  StatusBar.Panels.EndUpdate;   // nepravilna uporaba preventive flickeringa
  ClNeutr := $00EAEAEA;
  StatusBar.Canvas.Font.Name := 'Tahoma';
  if Panel.Index = 0 then  // Busy
  begin
    Panel.Text := 'Busy';
    BUSY := (StpDrv.Config[MotorIndex, $1B] and $0002) shr 1;
    if BUSY = 0 then StatusBar.Canvas.Brush.Color := $0028FF2E;           // Motor is in action
    if BUSY = 1 then StatusBar.Canvas.Brush.Color := ClNeutr;             // All commands completed
    if BUSY = 1 then StatusBar.Canvas.Font.Color := clMedGray;            // All commands completed
  end;
  if Panel.Index = 1 then // Bridges ON
  begin
    HiZ := (StpDrv.Config[MotorIndex, $1B] and $0001) shr 0;
    if HiZ = 0 then
    begin
      StatusBar.Canvas.Brush.Color := ClYellow;             // Bridges are in LOW impedance state
      Panel.Text := 'Enabled';                            // Bridges are in LOW impedance state
      pnlEnabled.BevelOuter := bvLowered;
    end
    else begin
      Panel.Text := 'Disabled';                           // Bridges are in HIGH impedance state
      StatusBar.Canvas.Brush.Color := ClSilver;             // Bridges are in HIGH impedance state
      pnlEnabled.BevelOuter := bvRaised;
    end;
  end;
  if Panel.Index = 2 then // pozicija
  begin
    StatusBar.Canvas.Font.Style := [FsBold];
    Panel.Text := StpDrv.Interp_Reg_Value(MotorIndex, $01, False);
    StatusBar.Canvas.Brush.Color := ClCream;
    StatusBar.Canvas.Font.Color := clNavy;
  end;
  if Panel.Index = 3 then // hitrost
  begin
    Panel.Text := StpDrv.Interp_Reg_Value(MotorIndex, $04, False);
    StatusBar.Canvas.Brush.Color := ClCream;
    StatusBar.Canvas.Font.Color := clGreen;
  end;
//////
  StatusBar.Canvas.FillRect(Rect);
  StatusBar.Canvas.TextOut(Rect.left+ 2, Rect.top, Panel.Text);
end;

procedure TMainForm.RefreshStatusAux(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect; MotorIndex: Integer);
var
  STALL_A, STALL_B, OCD, TH_STATUS, UVLO_ADC, UVLO, CMD_ERROR, MOT_STATUS, DIR, SW_EVN, SW_F, BUSY, HiZ: Cardinal;
  ClNeutr: TColor;
begin
  if Length(StpDrv.Config) < (MotorIndex+ 1) then Exit;
  StatusBar.Panels.EndUpdate;   // nepravilna uporaba preventive flickeringa
  ClNeutr := $00EAEAEA;
  StatusBar.Canvas.Font.Name := 'Tahoma';
  if Panel.Index = 0 then   // MOTOR številka
  begin
    if StpDrv.Config[MotorIndex, $16] and $08 = 0 then
    begin
      Panel.Text := 'M'+ IntToStr(MotorIndex+ 1)+' (V)';
      StatusBar.Canvas.Brush.Color := $00FFB0B0;
    end else
    begin
      if StpDrv.Config[MotorIndex, $16] and $08<> 0 then Panel.Text := 'M'+ IntToStr(MotorIndex+ 1)+' (C)';
      StatusBar.Canvas.Brush.Color := $00B9B9FF;
    end;
  end;
  if Panel.Index = 1 then   // Stall A
  begin
    Panel.Text := 'Stall';
    STALL_A := (StpDrv.Config[MotorIndex, $1B] and $8000) shr 15;
    STALL_B := (StpDrv.Config[MotorIndex, $1B] and $4000) shr 14;
    if (STALL_A = 1) and (STALL_B = 1) then
    begin
      StatusBar.Canvas.Font.Color := clMedGray;         //  Stall A not detected
      StatusBar.Canvas.Brush.Color := ClNeutr;          //  Stall A not detected
    end;
    if (STALL_A = 0) or (STALL_B = 0) then
      StatusBar.Canvas.Brush.Color := ClRed;            //  STEP LOSS detected on bridge A
  end;
  if Panel.Index = 2 then  //  OCD
  begin
    Panel.Text := 'OCD';
    OCD := (StpDrv.Config[MotorIndex, $1B] and $2000) shr 13;
    if OCD = 1 then StatusBar.Canvas.Font.Color := clMedGray;             //  Overcurrent was not detected
    if OCD = 0 then StatusBar.Canvas.Brush.Color := ClRed;                //  Overcurrent was DETECTED
    if OCD = 1 then StatusBar.Canvas.Brush.Color := ClNeutr;              //  Overcurrent was not detected
  end;
  if Panel.Index = 3 then  // Temperature
  begin
    Panel.Text := ' T';
    TH_STATUS := (StpDrv.Config[MotorIndex, $1B] and $1800) shr 11;
    if TH_STATUS = 0 then StatusBar.Canvas.Brush.Color := ClMoneyGreen;   //  Temperature is normal
    if TH_STATUS = 1 then StatusBar.Canvas.Brush.Color := ClYellow;       //  Temperature warning is ON
    if TH_STATUS = 2 then StatusBar.Canvas.Brush.Color := ClRed;          //  Temperature warning with bridge shutdown
    if TH_STATUS = 3 then StatusBar.Canvas.Brush.Color := clFuchsia;      //  Temperature warning with device shutdown
  end;
  if Panel.Index = 4 then  // UV_ADC
  begin
    UVLO_ADC := (StpDrv.Config[MotorIndex, $1B] and $0400) shr 10;
    if UVLO_ADC = 1 then StatusBar.Canvas.Font.Color := clMedGray;        //  ADC input voltage is OK
    if UVLO_ADC = 1 then StatusBar.Canvas.Brush.Color := ClNeutr;         //  ADC input voltage is OK
    if UVLO_ADC = 1 then Panel.Text := ' ADC OK';
    if UVLO_ADC = 0 then StatusBar.Canvas.Brush.Color := ClRed;           //  ADC input voltage is LOW
    if UVLO_ADC = 0 then Panel.Text := 'ADC LOW';
  end;
  if Panel.Index = 5 then  // UVLO
  begin
    Panel.Text := 'UVLO';
    UVLO := (StpDrv.Config[MotorIndex, $1B] and $0200) shr  9;
    if UVLO = 0 then StatusBar.Canvas.Brush.Color := ClRed;               // Undervoltage lockout IS ACTIVE
    if UVLO = 1 then StatusBar.Canvas.Font.Color := clMedGray;            // Undervoltage lockout is not active
    if UVLO = 1 then StatusBar.Canvas.Brush.Color := ClNeutr;             // Undervoltage lockout is not active
  end;
  if Panel.Index = 6 then  // Command error
  begin
    Panel.Text := 'C. error';
    CMD_ERROR := (StpDrv.Config[MotorIndex, $1B] and $0080) shr 7;
    if CMD_ERROR = 0 then StatusBar.Canvas.Font.Color := clMedGray;       // SPI commands OK
    if CMD_ERROR = 0 then StatusBar.Canvas.Brush.Color := ClNeutr;        // SPI commands OK
    if CMD_ERROR = 1 then StatusBar.Canvas.Brush.Color := ClRed;          // SPI command error is ON
  end;
//////
  StatusBar.Canvas.FillRect(Rect);
  StatusBar.Canvas.TextOut(Rect.left+ 2, Rect.top, Panel.Text);
end;

procedure TMainForm.sbVecManjClick(Sender: TObject);
begin
  Vec := Vec xor True;
  Label8.Visible := Vec;
  Label9.Visible := Vec;
  seStKorakovNaObrat.Visible := Vec;
  sePospesek.Visible := Vec;
  cbEnableControl.Visible := Vec;
  cbPodporaAksIMDebug.Visible := Vec;
  stBar1.Visible := Vec;
  btnLoadParam.Visible := Vec;
  if stBar1.Visible then
  begin
    stBar1.Top := ClientHeight - stBar1.Height;
    stBar0.Top := stBar1.Top - stBar0.Height;
  end
  else
    stBar0.Top := ClientHeight - stBar0.Height;
  if Vec then begin
    ClientWidth := BtnLoadParam.Width + BtnLoadParam.Left + 12;
//    ClientHeight := Memo1.Height + Memo1.Top + 8;
    sbVecManj.Caption := 'Manj <';
  end
  else begin
    ClientWidth := sbVecManj.Width + sbVecManj.Left + 12;
//    ClientHeight := btnCikel.Height + btnCikel.Top + 8;
    sbVecManj.Caption := 'Veè  >';
  end;

end;

end.
