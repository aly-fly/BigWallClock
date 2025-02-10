unit StepDrive_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Mmsystem, Vcl.StdCtrls, Vcl.ExtCtrls, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  VCLTee.Chart,
  Vcl.Buttons,
  IniFiles,
  Vcl.ComCtrls, System.Types, Math, ClipBrd,
  StSpin,
  MahUSB,
  ftd2xx, LibFT4222,
  Vcl.Grids, Vcl.DBGrids, VCLTee.TeeGDIPlus, Vcl.Samples.Spin,
  ComPort,
  Registry, Vcl.Menus
  ;

type
  TCom0com_Read= class(TThread)        // berem bufferje iz com0com porta
  protected
    procedure Execute; override;
  end;

type
  TForm1 = class(TForm)
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    Panel1: TPanel;
    TabCnOs: TTabControl;
    PageControl1: TPageControl;
    TbShUkazi: TTabSheet;
    PnlPwrKomande: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label18: TLabel;
    Label14: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label38: TLabel;
    Label44: TLabel;
    BtnPwr_RunFw: TButton;
    BtnPwr_MoveFw: TButton;
    BtnPwr_GoTo: TButton;
    BtnPwr_GoToDirFwd: TButton;
    BtnPwr_GoUntil_dFwd: TButton;
    BtnPwr_GoHome: TButton;
    BtnPwr_GoMark: TButton;
    BtnPwr_ResetPos: TButton;
    BtnPwr_ResetDevice: TButton;
    BtnPwr_SoftStop: TButton;
    BtnPwr_HardStop: TButton;
    BtnPwr_SoftHiZ: TButton;
    BtnPwr_HardHiZ: TButton;
    BtnPwr_RunBck: TButton;
    BtnPwr_MoveBck: TButton;
    BtnPwr_GoToDirBck: TButton;
    BtnPwr_GoUntil_dBck: TButton;
    BtnPwr_ReleseSW_dFwd: TButton;
    BtnPwr_ReleseSW_dBck: TButton;
    Button2: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    TbShRegistri: TTabSheet;
    StringGrid1: TStringGrid;
    TbShMeilhaus: TTabSheet;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    LblSmpl: TLabel;
    Label113: TLabel;
    Label26: TLabel;
    Label23: TLabel;
    Label16: TLabel;
    CmbObm: TComboBox;
    RgAnConnType: TRadioGroup;
    RgAnScanStart: TRadioGroup;
    RgAnAcqStart: TRadioGroup;
    C00: TCheckBox;
    C01: TCheckBox;
    C02: TCheckBox;
    C03: TCheckBox;
    C04: TCheckBox;
    C05: TCheckBox;
    C06: TCheckBox;
    C07: TCheckBox;
    C08: TCheckBox;
    C09: TCheckBox;
    C10: TCheckBox;
    C11: TCheckBox;
    C12: TCheckBox;
    C13: TCheckBox;
    C14: TCheckBox;
    C15: TCheckBox;
    C16: TCheckBox;
    C17: TCheckBox;
    C18: TCheckBox;
    C19: TCheckBox;
    C20: TCheckBox;
    C21: TCheckBox;
    C22: TCheckBox;
    C23: TCheckBox;
    C24: TCheckBox;
    C25: TCheckBox;
    C26: TCheckBox;
    C27: TCheckBox;
    C28: TCheckBox;
    C29: TCheckBox;
    C30: TCheckBox;
    C31: TCheckBox;
    EdConvTime: TEdit;
    EdScanTime: TEdit;
    EdScanSamplNr: TEdit;
    BtnNastaviAI: TButton;
    Chart16: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Series3: TFastLineSeries;
    Series4: TFastLineSeries;
    BtnRisiSignale: TButton;
    BtnStartAI: TButton;
    BtnStopAI: TButton;
    Button24: TButton;
    EdPovp: TEdit;
    CbVsakaDeseta: TCheckBox;
    Button27: TButton;
    Button1: TButton;
    Button4: TButton;
    Button6: TButton;
    Chart1: TChart;
    Series5: TFastLineSeries;
    Series6: TFastLineSeries;
    Series7: TFastLineSeries;
    Series8: TFastLineSeries;
    Series9: TFastLineSeries;
    Edit1: TEdit;
    Button7: TButton;
    Button8: TButton;
    Button10: TButton;
    StBar5: TStatusBar;
    StBar0: TStatusBar;
    StBar1: TStatusBar;
    StBar2: TStatusBar;
    StBar3: TStatusBar;
    StBar4: TStatusBar;
    PnlPwrGibParam: TPanel;
    Label17: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    EdStpNstep: TEdit;
    EdStpSpeed: TEdit;
    EdStpAbsPos: TEdit;
    PnlPwrGibParam2: TPanel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    EdStpAcceleration: TEdit;
    EdStpDeceleration: TEdit;
    EdStpMaxSpeed: TEdit;
    EdStpMinSpeed: TEdit;
    BtnSetMovements: TButton;
    GroupBox_PwrClkSet: TGroupBox;
    Label11: TLabel;
    Label13: TLabel;
    LblConf_PwmTswN: TLabel;
    LblConf_PwmTswV: TLabel;
    Label6: TLabel;
    Label15: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    RgConf_ClkSrc: TRadioGroup;
    RgConf_ClkSrcType: TRadioGroup;
    CmbBConf_ClkFreq: TComboBox;
    CmbBConf_OscOut: TComboBox;
    CmbBConf_WD_EN: TCheckBox;
    RgConf_ExtSW: TRadioGroup;
    CmbBConf_BridgOff: TCheckBox;
    RgConf_VccVolt: TRadioGroup;
    RgConf_UVLO: TRadioGroup;
    CmbBConf_Bit5: TCheckBox;
    TbConfigPwmTsw: TTrackBar;
    CmbBConf_PredEn: TCheckBox;
    CbAl_7: TCheckBox;
    CbAl_6: TCheckBox;
    CbAl_5: TCheckBox;
    CbAl_4: TCheckBox;
    CbAl_3: TCheckBox;
    CbAl_2: TCheckBox;
    CbAl_1: TCheckBox;
    CbAl_0: TCheckBox;
    RgPwrConfMode: TRadioGroup;
    CmbBConf_StepM: TComboBox;
    CmbBConf_SyncM: TComboBox;
    CmbBConf_LowSpeedOpt: TCheckBox;
    CmbBConf_IGATE: TComboBox;
    CmbBConf_TCC: TComboBox;
    CmbBConf_TBOOST: TComboBox;
    CmbBConf_TDT: TComboBox;
    CmbBConf_TBLANK: TComboBox;
    Panel2: TPanel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    EdKe: TEdit;
    EdRm: TEdit;
    EdLm: TEdit;
    BtnHwReset: TButton;
    Label1: TLabel;
    PnlSaveLoad: TPanel;
    BtnSaveConfig: TButton;
    BtnOpenConfig: TButton;
    BtnPwrBeriVse: TButton;
    Label3: TLabel;
    EdStpMarkPos: TEdit;
    Button23: TButton;
    Button5: TButton;
    Button3: TButton;
    Panel3: TPanel;
    CmbBoxKontrolerji: TComboBox;
    Label37: TLabel;
    Label22: TLabel;
    EdVbus: TEdit;
    Label45: TLabel;
    CbCiguMigu: TCheckBox;
    TBarKval: TTrackBar;
    LblKval: TLabel;
    Label2: TLabel;
    CmbBoxMotorji: TComboBox;
    BtnVoltageDefault: TButton;
    BtnCurrentDefault: TButton;
    Label49: TLabel;
    BtnVnesiParametreMotorja: TButton;
    Label24: TLabel;
    BtnDodajMotor: TButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1TopLeftChanged(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure BtnHwResetClick(Sender: TObject);
    procedure BtnPwrBeriVseClick(Sender: TObject);
    procedure BtnPwrResetClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure RgPwrConfModeClick(Sender: TObject);
    procedure RgConf_ClkSrcClick(Sender: TObject);
    procedure RgConf_ClkSrcTypeClick(Sender: TObject);
    procedure CmbBConf_ClkFreqChange(Sender: TObject);
    procedure CmbBConf_OscOutChange(Sender: TObject);
    procedure CmbBConf_WD_ENClick(Sender: TObject);
    procedure RgConf_ExtSWClick(Sender: TObject);
    procedure CmbBConf_BridgOffClick(Sender: TObject);
    procedure RgConf_VccVoltClick(Sender: TObject);
    procedure RgConf_UVLOClick(Sender: TObject);
    procedure CmbBConf_Bit5Click(Sender: TObject);
    procedure TbConfigPwmTswChange(Sender: TObject);
    procedure CmbBConf_PredEnClick(Sender: TObject);
    procedure CbAl_7Click(Sender: TObject);
    procedure CbAl_6Click(Sender: TObject);
    procedure CbAl_5Click(Sender: TObject);
    procedure CbAl_4Click(Sender: TObject);
    procedure CbAl_3Click(Sender: TObject);
    procedure CbAl_2Click(Sender: TObject);
    procedure CbAl_1Click(Sender: TObject);
    procedure CbAl_0Click(Sender: TObject);
    procedure CmbBConf_StepMChange(Sender: TObject);
    procedure CmbBConf_SyncMChange(Sender: TObject);
    procedure BtnPwr_RunFwClick(Sender: TObject);
    procedure BtnPwr_MoveFwClick(Sender: TObject);
    procedure BtnPwr_GoToClick(Sender: TObject);
    procedure BtnPwr_GoToDirFwdClick(Sender: TObject);
    procedure BtnPwr_GoUntil_dFwdClick(Sender: TObject);
    procedure BtnPwr_GoHomeClick(Sender: TObject);
    procedure BtnPwr_GoMarkClick(Sender: TObject);
    procedure BtnPwr_ResetPosClick(Sender: TObject);
    procedure BtnPwr_ResetDeviceClick(Sender: TObject);
    procedure BtnPwr_SoftStopClick(Sender: TObject);
    procedure BtnPwr_HardStopClick(Sender: TObject);
    procedure BtnPwr_SoftHiZClick(Sender: TObject);
    procedure BtnPwr_HardHiZClick(Sender: TObject);
    procedure BtnSaveConfigClick(Sender: TObject);
    procedure BtnOpenConfigClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CmbBConf_LowSpeedOptClick(Sender: TObject);
    procedure BtnNastaviAIClick(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure TBarKvalChange(Sender: TObject);
    procedure BtnVnesiParametreMotorjaClick(Sender: TObject);
    procedure CmbBConf_IGATEChange(Sender: TObject);
    procedure CmbBConf_TCCChange(Sender: TObject);
    procedure CmbBConf_TBOOSTChange(Sender: TObject);
    procedure CmbBConf_TDTChange(Sender: TObject);
    procedure CmbBConf_TBLANKChange(Sender: TObject);
    procedure BtnPwr_RunBckClick(Sender: TObject);
    procedure BtnPwr_MoveBckClick(Sender: TObject);
    procedure BtnPwr_GoToDirBckClick(Sender: TObject);
    procedure BtnPwr_GoUntil_dBckClick(Sender: TObject);
    procedure BtnPwr_ReleseSW_dFwdClick(Sender: TObject);
    procedure BtnPwr_ReleseSW_dBckClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure BtnSetMovementsClick(Sender: TObject);
    procedure TabCnOsChange(Sender: TObject);
    procedure StBar0DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure StBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure StBar2DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure StBar3DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure StBar4DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure StBar5DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure StBar0DblClick(Sender: TObject);
    procedure StBar1DblClick(Sender: TObject);
    procedure StBar2DblClick(Sender: TObject);
    procedure StBar3DblClick(Sender: TObject);
    procedure StBar4DblClick(Sender: TObject);
    procedure StBar5DblClick(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure CmbBoxMotorjiChange(Sender: TObject);
    procedure CbCiguMiguClick(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PopUp1Popup(Sender: TObject);
    procedure CmbBoxKontrolerjiChange(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BtnVoltageDefaultClick(Sender: TObject);
    procedure BtnCurrentDefaultClick(Sender: TObject);
    procedure BtnDodajMotorClick(Sender: TObject);

  private
    ComP: TComPort;
    USB: TUsbClass;
    procedure ChangeEvent(const bInserted: Boolean; const bRemoved: Boolean; const ADevType, ADriverName, AFriendlyName: string);


    { Private declarations }
  public
    FTCom0com_Read: TThread;
    procedure AutoSizeCol(Grid: TStringGrid; Column: integer);
    procedure Btn_RegTabela_Click(Sender: TObject);
    procedure UpdateVrsticoRegTabele(Addr: Byte);
    procedure PowerSTP_PrikaziCeloParamArrayTabelo;
    procedure PowerSTP_Update_StatusPanele;
    procedure NastaviFormoGledeNaPrikljuceno;
    procedure ClipBoardChanged(var Message: TMessage); message WM_DRAWCLIPBOARD;
    procedure RefreshStatusSemafor(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect; MotorIndex: Integer);
    procedure Naredi_Seznam_com0com(var ComPars:  TStringList);   // naredim seznam com0com mostickov, imeni ComPort parov sta loceni s presledkom
    function  StSpin_IzvediUkaz(var Ukaz: string): Boolean;       // ce ukaz obstaja, potem vrne true
    function  StrItem(DelmtdTxt: string; Ind: Integer; Delimiter: Char): string;  // vrne string, ki je na indexu.
    procedure InicializacijaKontrolerja;

    var StpDrv: TStSpin;
    var Com0Com_Name: string;                          // Ime com porta za povezavo, da se lahko izpise
    var TimerTece: Boolean;
    var Ind: Integer;
    var TmArr: Array[0..999] of Cardinal;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  StepDrive_MotPar;


{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  ComPars: TStringList;
  AsTxt: string;
begin
  Ind := 0;
//// com0com  ////   //// com0com  ////
  ComP := TComPort.Create;
  try
    ComPars := TstringList.Create;
    Naredi_Seznam_com0com(ComPars);
    for I := 0 to ComPars.Count- 1 do
    begin
      ComP.Open(StrItem(ComPars[I], 0, ' '));
      Com0Com_Name := StrItem(ComPars[I], 1, ' ');
      if ComP.IsConnected then Break else ComP.Close;
    end;
    if not ComP.IsOpen then
    begin
      for I := 0 to ComPars.Count- 1 do
      begin
        ComP.Open(StrItem(ComPars[I], 0, ' '));
        Com0Com_Name := StrItem(ComPars[I], 1, ' ');
        if ComP.IsOpen then Break;
      end;
    end;
    Comp.Config(230400, 8, TWOSTOPBITS, NOPARITY);
    if not ComP.IsOpen then Com0Com_Name := '';
  finally
    ComPars.Free;
  end;

  if FTCom0com_Read= nil then
  begin
    FTCom0com_Read := TCom0com_Read.Create(True);
//    FTCom0com_Read.FreeOnTerminate := True;
    FTCom0com_Read.Priority := tpNormal;                // Set the priority to normal.
    FTCom0com_Read.Start;                               // Now run the thread.
  end;
////  ////  ///   ////  //// ////
  SetClipboardViewer(Handle);
  AsTxt := Clipboard.AsText;
  if (Copy(AsTxt, 1, 16 )= 'UkazZaStepDrive(') and (Copy(AsTxt, Length(AsTxt), 1 )= ')') then Clipboard.Clear;
//  if (Copy(Clipboard.AsText, 1, 16 )= 'UkazZaStepDrive(') and (Copy(Clipboard.AsText, Length(Clipboard.AsText), 1 )= ')') then Clipboard.Clear;
  Form1.Caption := 'StepDrive';
  PageControl1.ActivePageIndex := 0;
  USB := TUsbClass.Create;
  USB.OnUsbChange := Self.ChangeEvent;

    TbShMeilhaus.TabVisible := False;
  Application.HintPause := 100;
  FormatSettings.DecimalSeparator := ',';

  try
    StpDrv := TStSpin.Create;
  except
    StpDrv.Free;
    ShowMessage('Napaka pri kreiranju StSpin objekta.');
    Form1.Close;
  end;
  InicializacijaKontrolerja;
  Timer1.Enabled := True;
end;

procedure TForm1.InicializacijaKontrolerja;
var
  I: Integer;
  Str, SN, SN1: string;
  Ini_File: TCustomIniFile;
  StrLst: TStringList;
begin
  StrLst := StpDrv.Get_All_Available_Controllers;
  CmbBoxKontrolerji.Visible := True;
  CmbBoxKontrolerji.Items.Clear;
  for I := 0 to StrLst.Count-1 do CmbBoxKontrolerji.Items.Add(StrLst.Strings[I]);
  StrLst.Free;
  Ini_File := TMemIniFile.Create(ExtractFilePath(Application.ExeName)+ 'StepDrive.ini');
  try
    SN := Ini_File.ReadString('Kontroler_informacije', 'SN_Nazadnje_Odprtega', '');
    SN1 := SN;
    StpDrv.Open(SN1);
    if SN1 = SN then
      CmbBoxKontrolerji.ItemIndex := CmbBoxKontrolerji.Items.IndexOf(SN1)
    else
      CmbBoxKontrolerji.ItemIndex := -1;
    StpDrv.Vbus := StrToFloat(EdVbus.Text);
    NastaviFormoGledeNaPrikljuceno;
    BtnPwrBeriVseClick(nil);
    if (SN1 <> '') then
    begin
      if SN = '' then
      begin
        ShowMessage('Odprt je bil kontroler s serijsko tevilko '+ SN1+ '.');
        Ini_File.WriteString('Kontroler_informacije', 'SN_Nazadnje_Odprtega', SN1);
      end else
      begin
        if SN <> SN1 then
        begin
           if MessageDlg('Kontroler s serijsko številko '+ SN+ ' ni prikljuèen. '+ #13#10+
                         'Ali odpremo kontroler s serijsko tevilko '+ SN1+ '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
           begin
             Ini_File.WriteString('Kontroler_informacije', 'SN_Nazadnje_Odprtega', SN1);
             CmbBoxKontrolerji.ItemIndex := CmbBoxKontrolerji.Items.IndexOf(SN1)
           end else
           begin
             StpDrv.Close;
           end;
        end;
      end;
    end;
    if StpDrv.Count > 0 then
    begin
      for I := 0 to StpDrv.Count- 1 do
      begin
        Str := 'Motor_'+ IntToStr(I);
        StpDrv.MotorData[I].OznakaMotorja := Ini_File.ReadString('Oznake_Prikljucenih_Motorjev_za_Kontroler_'+  CmbBoxKontrolerji.Items[CmbBoxKontrolerji.ItemIndex], Str, '');
      end;
    end;
  finally
    Ini_File.UpdateFile;
    Ini_File.Free;
  end;
  if CmbBoxKontrolerji.Items.Count < 1 then CmbBoxKontrolerji.Visible := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  I: Integer;
  Ini_File: TCustomIniFile;
begin
  if FTCom0com_Read <> nil then
  begin
    FTCom0com_Read.Terminate;
    FTCom0com_Read.WaitFor;
    FTCom0com_Read.Free;
    FTCom0com_Read := nil;
  end;
  ComP.Close;
  ComP.Free;
  if Assigned(USB) then USB.Free;

  Ini_File := TMemIniFile.Create(ExtractFilePath(Application.ExeName)+ 'StepDrive.ini');
  try
    try
      if StpDrv.Count > 0 then
      begin
        for I := 0 to StpDrv.Count- 1 do
          Ini_File.WriteString('Oznake_Prikljucenih_Motorjev_za_Kontroler_'+  CmbBoxKontrolerji.Items[CmbBoxKontrolerji.ItemIndex],
                                'Motor_'+ IntToStr(I), StpDrv.MotorData[I].OznakaMotorja);
      end;
      Ini_File.UpdateFile;
    except
      ShowMessage('Uporabnik nima dovolj pravic za spreminjanje datoteke >> StepDrive.ini <<');
    end;
  finally
    Ini_File.Free;
  end;

  StpDrv.Close;
  StpDrv.Free;
end;

procedure TForm1.BtnPwr_ReleseSW_dFwdClick(Sender: TObject);
begin
  StpDrv.RlsSW_rAbs_DirFwd(TabCnOs.TabIndex);
end;

procedure TForm1.BtnPwr_GoUntil_dBckClick(Sender: TObject);
var
  Speed: Double;
begin
  Speed := StrToFloat(EdStpSpeed.Text);
  Speed := StpDrv.GoUntil_rAbs_dBck(TabCnOs.TabIndex, Speed);
  EdStpSpeed.Text := FloatToStrF(Speed, ffFixed, 32, 4);
end;

procedure TForm1.BtnPwr_GoUntil_dFwdClick(Sender: TObject);
var
  Speed: Double;
begin
  Speed := StrToFloat(EdStpSpeed.Text);
  Speed := StpDrv.GoUntil_rAbs_dFwd(TabCnOs.TabIndex, Speed);
  EdStpSpeed.Text := FloatToStrF(Speed, ffFixed, 32, 4);
end;

procedure TForm1.Button10Click(Sender: TObject);
type
  TDat= record
    Cas: Double;
    Sin: Double;
    Cos: Double;
    Ampl: Double;
    A2: Double;
    Poz: Double;
    Hit: Double;
  end;
var
  Dat: Array of TDat;
  I, J, N: Integer;
  Zac: Integer;
  tmp: Double;
begin
  N := StrToInt(Edit1.Text);
  Series5.Clear;
  Series6.Clear;
  Series7.Clear;
  Series8.Clear;
  Series9.Clear;
  SetLength(Dat, Series4.Count);

  Zac := 0;
  for I := 0 to Series1.Count- 1 do
    if Series1.XValue[I] >= Series4.XValue[0] then
    begin
      Zac := I;
      Break;
    end;

  for I := 0 to Length(Dat)- 1 do
  begin
    Dat[I].Cas := Series1.XValue[I+ Zac]- Series4.XValue[0];
    Dat[I].Sin := Series1.YValue[I+ Zac];
    Dat[I].Cos := Series2.YValue[I+ Zac];
    Dat[I].Ampl:= Series3.YValue[I+ Zac];
    Dat[I].Poz := Abs(Series4.YValue[I]*1000);
  end;
  for I := Zac to Length(Dat)- 1 do
  begin
    Tmp := 0;
    for J := I downto 0 do
    begin
      Tmp := Tmp+ Dat[J].Ampl;
      if (Dat[I].Poz- Dat[J].Poz) >= 1/N then
      begin
        Dat[I].Hit := 4*1000/N/(Dat[I].Cas- Dat[J].Cas);
        Dat[I].A2 := tmp/(I-J);
        Break;
      end;
    end;
  end;
  for I := Zac to Length(Dat)- 1 do
  begin
//    Series5.AddXY(Dat[I].Cas, Dat[I].Sin);
//    Series6.AddXY(Dat[I].Cas, Dat[I].Cos);
    Series7.AddXY(Dat[I].Cas, Dat[I].Ampl);
    Series8.AddXY(Dat[I].Cas, Dat[I].A2);
//    Series9.AddXY(Dat[I].Cas, Dat[I].Hit);
  end;
end;

procedure TForm1.BtnCurrentDefaultClick(Sender: TObject);
var
  I: Integer;
begin
  for I := $01 to $1B do
  begin
    StpDrv.Config[TabCnOs.TabIndex, I] := StpDrv.MotorData[TabCnOs.TabIndex].Cm_Config[I] ;
    StpDrv.SetParam(TabCnOs.TabIndex, I,StpDrv.Config[TabCnOs.TabIndex, I]);
  end;
end;

procedure TForm1.BtnDodajMotorClick(Sender: TObject);
begin
  CmbBoxMotorji.Items.Add(CmbBoxMotorji.Text);
end;

procedure TForm1.BtnHwResetClick(Sender: TObject);
begin
  if MessageDlg('Èe resetiraš, bo potrebno ponovno nastaviti kontroler. Ali to res želiš? ', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    StpDrv.HW_ResetDevice(TabCnOs.TabIndex);
end;

procedure TForm1.Button13Click(Sender: TObject);
var
  Speed: Double;
begin
  Speed := StrToFloat(EdStpSpeed.Text);
  Speed := StpDrv.GoUntil_pMrk_dBck(TabCnOs.TabIndex, Speed);
  EdStpSpeed.Text := FloatToStrF(Speed, ffFixed, 32, 4);
end;

procedure TForm1.Button14Click(Sender: TObject);
var
  Speed: Double;
begin
  Speed := StrToFloat(EdStpSpeed.Text);
  Speed := StpDrv.GoUntil_pMrk_dFwd(TabCnOs.TabIndex, Speed);
  EdStpSpeed.Text := FloatToStrF(Speed, ffFixed, 32, 4);
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  StpDrv.RlsSW_pMrk_DirBck(TabCnOs.TabIndex);
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  StpDrv.RlsSW_pMrk_DirFwd(TabCnOs.TabIndex);
end;

procedure TForm1.BtnPwr_GoHomeClick(Sender: TObject);
begin
  StpDrv.GoHome(TabCnOs.TabIndex);
end;

procedure TForm1.BtnPwr_GoMarkClick(Sender: TObject);
begin
  StpDrv.GoMark(TabCnOs.TabIndex);
end;

procedure TForm1.BtnPwr_ResetPosClick(Sender: TObject);
begin
  StpDrv.ResetPos(TabCnOs.TabIndex);
end;

procedure TForm1.BtnPwr_ReleseSW_dBckClick(Sender: TObject);
begin
  StpDrv.RlsSW_rAbs_DirBck(TabCnOs.TabIndex);
end;

procedure TForm1.BtnPwr_ResetDeviceClick(Sender: TObject);
begin
  if MessageDlg('Èe resetiraš, bo potrebno ponovno nastaviti kontroler. Ali to res želiš? ', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    StpDrv.ResetDevice(TabCnOs.TabIndex);
    BtnPwrBeriVseClick(nil);
  end;
end;

procedure TForm1.BtnPwr_SoftStopClick(Sender: TObject);
begin
  StpDrv.SoftStop(TabCnOs.TabIndex);
end;

procedure TForm1.BtnPwr_HardStopClick(Sender: TObject);
begin
  StpDrv.HardStop(TabCnOs.TabIndex);
end;

procedure TForm1.BtnPwrBeriVseClick(Sender: TObject);
var
  Adr: Byte;
begin
  if StpDrv.Count < 1 then Exit;
  if TabCnOs.TabIndex < 0 then Exit;
  for Adr := $01 to $1B do StpDrv.GetParams_AllDev(Adr);   // nafilam tabelo
  PowerSTP_PrikaziCeloParamArrayTabelo;
  if StpDrv.VoltMode(TabCnOs.TabIndex) then
    TBarKval.Position := StpDrv.Config[TabCnOs.TabIndex, $0A]
  else
    TBarKval.Position := StpDrv.Config[TabCnOs.TabIndex, $0A] and $7F;
  TBarKvalChange(nil);
end;

procedure TForm1.PopUp1Popup(Sender: TObject);
begin
//  PopUp1.Items.Add(  .Add('eee');
end;

procedure TForm1.PowerSTP_PrikaziCeloParamArrayTabelo;
var
  I, J: Integer;
  Adr: Byte;
  N: Integer;
  Str: string;
  Point: TPoint;
  MySpeedBtn: TSpeedButton;
  Row: integer;
  Rect: TRect;
  Rs: Integer;
  Item: TComponent;
  Int, Dec: Integer;
  d, f: Double;
begin
  if TabCnOs.TabIndex < 0 then Exit;
  for I := 0 to StringGrid1.ColCount - 1 do StringGrid1.Cols[I].Clear;
  if StpDrv.VoltMode(TabCnOs.TabIndex) then RgPwrConfMode.ItemIndex := 0 else RgPwrConfMode.ItemIndex := 1;
  N := 1;
  for Adr := $01 to $1B do if StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).RegName <> '' then N := N+ 1;
  StringGrid1.RowCount := N;
  Str := '';

  StringGrid1.Cells[0, 0] := 'Ime';
  StringGrid1.Cells[1, 0] := 'Naslov';
  StringGrid1.Cells[2, 0] := 'Opis';
  StringGrid1.Cells[3, 0] := 'Interpretacija';
  StringGrid1.Cells[4, 0] := 'Hex';
  StringGrid1.Cells[5, 0] := 'Default';
  StringGrid1.Cells[6, 0] := 'Bits';

  I := 0;
  for Adr := $01 to $1B do
  begin
    if StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).RegName <> '' then
    begin
      I := I+ 1;
      StringGrid1.Cells[0, I] := StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).RegName;
      StringGrid1.Cells[1, I] := '$'+ IntToHex(Adr, 2);
      StringGrid1.Cells[2, I] := StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).Opis ;
      StringGrid1.Cells[3, I] := StpDrv.Interp_Reg_Value(TabCnOs.TabIndex, Adr, True);
      StringGrid1.Cells[4, I] := '$'+ IntToHex( StpDrv.Config[TabCnOs.TabIndex, Adr], 2*StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).NrBayt);
      StringGrid1.Cells[5, I] := '$'+ IntToHex(StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).DefVal , 2*StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).NrBayt);
      StringGrid1.Cells[6, I] :=  IntToStr(StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).NrBit);

      if StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).RegName= 'MAX_SPEED' then
        EdStpMaxSpeed.Text := FloatToStrF( StpDrv.Config[TabCnOs.TabIndex, Adr]* 15.2587890625, ffFixed, 8, 3);
      if StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).RegName= 'MIN_SPEED' then
        EdStpMinSpeed.Text := FloatToStrF(( StpDrv.Config[TabCnOs.TabIndex, Adr] and $FFF)* 0.2384185791015625, ffFixed, 8, 3);
      if StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).RegName= 'ACC' then
        EdStpAcceleration.Text := FloatToStrF( StpDrv.Config[TabCnOs.TabIndex, Adr]* 14.551915228366851806640625, ffFixed, 8, 3);
      if StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).RegName= 'DEC' then
        EdStpDeceleration.Text := FloatToStrF( StpDrv.Config[TabCnOs.TabIndex, Adr]* 14.551915228366851806640625, ffFixed, 8, 3);
      if StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).RegName= 'MARK' then
         EdStpMarkPos.Text := StpDrv.Interp_Reg_Value(TabCnOs.TabIndex, Adr, False);
    end;
  end;

  for J := 0 to 6 do
    for I := 0 to StringGrid1.ColCount- 1 do AutoSizeCol(StringGrid1, J);

  for I := StringGrid1.ControlCount-1 downto 0 do
  begin
    Item := StringGrid1.Controls[I];
    if Item.ClassType = TSpeedButton then Item.Free;
  end;
  Rs := 1;
  for Row := StringGrid1.TopRow to StringGrid1.VisibleRowCount do
  begin
    Rect := StringGrid1.CellRect(7, Row);

    Point := ScreenToClient(ClientToScreen(Rect.TopLeft));
    MySpeedBtn := TSpeedButton.Create(Self);
    MySpeedBtn.Caption := 'Read';
    MySpeedBtn.Name := 'BtnReadReg_'+ IntToStr(Row);
    MySpeedBtn.Parent := StringGrid1;
    MySpeedBtn.OnClick := Btn_RegTabela_Click;
    MySpeedBtn.Tag := Row;
    MySpeedBtn.Width := StringGrid1.ColWidths[7]- 2*Rs;
    MySpeedBtn.Height := StringGrid1.RowHeights[Row]- 2*Rs;
    MySpeedBtn.Top := Point.Y+ Rs;
    MySpeedBtn.Left := Point.X + StringGrid1.ColWidths[7]- MySpeedBtn.Width- Rs;
    FreeOnRelease;

    Str := '';
    I := 0;
    if TryStrToInt(StringGrid1.Cells[1, Row], I) then
    case StpDrv.RegParamInfo(TabCnOs.TabIndex, I).AccLvl of
      0: Str := '';
      1: Str := 'WS';
      2: Str := 'WH';
      3: Str := 'WA';
    end;
    if Str <> '' then
    begin
      Rect := StringGrid1.CellRect(8, Row);
      Point := ScreenToClient(ClientToScreen(Rect.TopLeft));
      MySpeedBtn := TSpeedButton.Create(Self);
      MySpeedBtn.Caption := Str;
      MySpeedBtn.Name := 'BtnWriteReg_'+ IntToStr(Row);
      MySpeedBtn.Parent := StringGrid1;
      MySpeedBtn.OnClick := Btn_RegTabela_Click;
      MySpeedBtn.Tag := Row;
      MySpeedBtn.Width := StringGrid1.ColWidths[8]- 2*Rs;
      MySpeedBtn.Height := StringGrid1.RowHeights[Row]- 2*Rs;
      MySpeedBtn.Top := Point.Y+ Rs;
      MySpeedBtn.Left := Point.X + StringGrid1.ColWidths[8]- MySpeedBtn.Width- Rs;
      FreeOnRelease;
    end;
  end;

///// ********** K O N F I G U R A C I J E **************************
  GroupBox_PwrClkSet.Enabled := False;

  if  StpDrv.Config[TabCnOs.TabIndex, $1A] and $0004 = 0 then // internal clock source
  begin
    RgConf_ClkSrc.ItemIndex := 0;
    RgConf_ClkSrcType.Enabled := False;
    CmbBConf_ClkFreq.ItemIndex := 1;
    CmbBConf_ClkFreq.Enabled := False;
    if StpDrv.Config[TabCnOs.TabIndex, $1A] and $0008 <> 0 then
     CmbBConf_OscOut.ItemIndex := StpDrv.Config[TabCnOs.TabIndex, $1A] and $0003
     else
      CmbBConf_OscOut.ItemIndex := 4;
  end else
  begin
    RgConf_ClkSrc.ItemIndex := 1;
    RgConf_ClkSrcType.Enabled := True;
    CmbBConf_ClkFreq.Enabled := True;
    CmbBConf_ClkFreq.ItemIndex := StpDrv.Config[TabCnOs.TabIndex, $1A] and $0003;
    if StpDrv.Config[TabCnOs.TabIndex, $1A] and $0008 = 0 then RgConf_ClkSrcType.ItemIndex := 0 else RgConf_ClkSrcType.ItemIndex := 1;
    if StpDrv.Config[TabCnOs.TabIndex, $1A] and $0008 = 0 then CmbBConf_OscOut.ItemIndex := 5 else CmbBConf_OscOut.ItemIndex := 6;
  end;

  CmbBConf_WD_EN.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $18] and $0800) <> 0;
  if StpDrv.Config[TabCnOs.TabIndex, $1A] and $0010 = 0 then RgConf_ExtSW.ItemIndex := 0 else RgConf_ExtSW.ItemIndex := 1;
  CmbBConf_BridgOff.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $1A] and $0080) <> 0;
  if StpDrv.Config[TabCnOs.TabIndex, $1A] and $0200 = 0 then RgConf_VccVolt.ItemIndex := 0 else RgConf_VccVolt.ItemIndex := 1;
  if StpDrv.Config[TabCnOs.TabIndex, $1A] and $0100 = 0 then RgConf_UVLO.ItemIndex := 0 else RgConf_UVLO.ItemIndex := 1;
  CmbBConf_Bit5.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $1A] and $0020) <> 0;

  CbAl_7.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $17] and $80) <> 0;
  CbAl_6.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $17] and $40) <> 0;
  CbAl_5.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $17] and $20) <> 0;
  CbAl_4.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $17] and $10) <> 0;
  CbAl_3.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $17] and $08) <> 0;
  CbAl_2.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $17] and $04) <> 0;
  CbAl_1.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $17] and $02) <> 0;
  CbAl_0.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $17] and $01) <> 0;


  CmbBConf_IGATE.ItemIndex  := ( StpDrv.Config[TabCnOs.TabIndex, $18] and $00E0) shr 5;
  CmbBConf_TCC.ItemIndex    := ( StpDrv.Config[TabCnOs.TabIndex, $18] and $001F);
  CmbBConf_TBOOST.ItemIndex := ( StpDrv.Config[TabCnOs.TabIndex, $18] and $0700) shr 8;
  CmbBConf_TDT.ItemIndex    := ( StpDrv.Config[TabCnOs.TabIndex, $19] and $1F);
  CmbBConf_TBLANK.ItemIndex := ( StpDrv.Config[TabCnOs.TabIndex, $19] and $E0) shr 5;

  if StpDrv.VoltMode(TabCnOs.TabIndex) then      /// VOLTAGE MODE
  begin
    CmbBConf_LowSpeedOpt.Visible := True;
    CmbBConf_LowSpeedOpt.Left := 8;
    CmbBConf_StepM.Items[5] := '1/32 µStep';
    CmbBConf_StepM.Items[6] := '1/64 µStep';
    CmbBConf_StepM.Items[7] := '1/128 µStep';

    CmbBConf_SyncM.Items[6] := '1/32 µStep';
    CmbBConf_SyncM.Items[7] := '1/64 µStep';
    CmbBConf_SyncM.Items[8] := '1/128 µStep';

    CbAl_5.Visible := True;
    CmbBConf_PredEn.Visible := False;
    CmbBConf_Bit5.Caption := 'Motor supply voltage compensation';
    LblConf_PwmTswN.Caption := 'PWM frequency:';

    Int := ( StpDrv.Config[TabCnOs.TabIndex, $1A] and $E000) shr 13;    // division factor
    Dec := ( StpDrv.Config[TabCnOs.TabIndex, $1A] and $1C00) shr 10;    // multiplication factor


    TbConfigPwmTsw.Max := 37;
    if (Dec= 0) and (Int= 6) then TbConfigPwmTsw.Position :=  0;
    if (Dec= 0) and (Int= 5) then TbConfigPwmTsw.Position :=  1;
    if (Dec= 1) and (Int= 6) then TbConfigPwmTsw.Position :=  2;
    if (Dec= 0) and (Int= 4) then TbConfigPwmTsw.Position :=  3;
    if (Dec= 1) and (Int= 5) then TbConfigPwmTsw.Position :=  3;
    if (Dec= 2) and (Int= 6) then TbConfigPwmTsw.Position :=  3;
    if (Dec= 3) and (Int= 6) then TbConfigPwmTsw.Position :=  4;
    if (Dec= 2) and (Int= 5) then TbConfigPwmTsw.Position :=  5;
    if (Dec= 1) and (Int= 4) then TbConfigPwmTsw.Position :=  6;
    if (Dec= 0) and (Int= 3) then TbConfigPwmTsw.Position :=  7;
    if (Dec= 3) and (Int= 5) then TbConfigPwmTsw.Position :=  8;
    if (Dec= 2) and (Int= 4) then TbConfigPwmTsw.Position :=  9;
    if (Dec= 4) and (Int= 6) then TbConfigPwmTsw.Position := 10;
    if (Dec= 1) and (Int= 3) then TbConfigPwmTsw.Position := 11;
    if (Dec= 3) and (Int= 4) then TbConfigPwmTsw.Position := 12;
    if (Dec= 0) and (Int= 2) then TbConfigPwmTsw.Position := 13;
    if (Dec= 4) and (Int= 5) then TbConfigPwmTsw.Position := 13;
    if (Dec= 5) and (Int= 6) then TbConfigPwmTsw.Position := 14;
    if (Dec= 2) and (Int= 3) then TbConfigPwmTsw.Position := 15;
    if (Dec= 1) and (Int= 2) then TbConfigPwmTsw.Position := 16;
    if (Dec= 3) and (Int= 3) then TbConfigPwmTsw.Position := 16;
    if (Dec= 4) and (Int= 4) then TbConfigPwmTsw.Position := 16;
    if (Dec= 5) and (Int= 5) then TbConfigPwmTsw.Position := 16;
    if (Dec= 6) and (Int= 6) then TbConfigPwmTsw.Position := 16;
    if (Dec= 7) and (Int= 6) then TbConfigPwmTsw.Position := 17;
    if (Dec= 2) and (Int= 2) then TbConfigPwmTsw.Position := 18;
    if (Dec= 6) and (Int= 5) then TbConfigPwmTsw.Position := 18;
    if (Dec= 5) and (Int= 4) then TbConfigPwmTsw.Position := 19;
    if (Dec= 0) and (Int= 1) then TbConfigPwmTsw.Position := 20;
    if (Dec= 4) and (Int= 3) then TbConfigPwmTsw.Position := 20;
    if (Dec= 3) and (Int= 2) then TbConfigPwmTsw.Position := 21;
    if (Dec= 7) and (Int= 5) then TbConfigPwmTsw.Position := 21;
    if (Dec= 6) and (Int= 4) then TbConfigPwmTsw.Position := 22;
    if (Dec= 1) and (Int= 1) then TbConfigPwmTsw.Position := 23;
    if (Dec= 5) and (Int= 3) then TbConfigPwmTsw.Position := 23;
    if (Dec= 7) and (Int= 4) then TbConfigPwmTsw.Position := 24;
    if (Dec= 4) and (Int= 2) then TbConfigPwmTsw.Position := 25;
    if (Dec= 2) and (Int= 1) then TbConfigPwmTsw.Position := 26;
    if (Dec= 6) and (Int= 3) then TbConfigPwmTsw.Position := 26;
    if (Dec= 3) and (Int= 1) then TbConfigPwmTsw.Position := 27;
    if (Dec= 5) and (Int= 2) then TbConfigPwmTsw.Position := 27;
    if (Dec= 7) and (Int= 3) then TbConfigPwmTsw.Position := 27;
    if (Dec= 6) and (Int= 2) then TbConfigPwmTsw.Position := 28;
    if (Dec= 0) and (Int= 0) then TbConfigPwmTsw.Position := 29;
    if (Dec= 4) and (Int= 1) then TbConfigPwmTsw.Position := 29;
    if (Dec= 7) and (Int= 2) then TbConfigPwmTsw.Position := 30;
    if (Dec= 1) and (Int= 0) then TbConfigPwmTsw.Position := 31;
    if (Dec= 5) and (Int= 1) then TbConfigPwmTsw.Position := 31;
    if (Dec= 2) and (Int= 0) then TbConfigPwmTsw.Position := 32;
    if (Dec= 6) and (Int= 1) then TbConfigPwmTsw.Position := 32;
    if (Dec= 3) and (Int= 0) then TbConfigPwmTsw.Position := 33;
    if (Dec= 7) and (Int= 1) then TbConfigPwmTsw.Position := 33;
    if (Dec= 4) and (Int= 0) then TbConfigPwmTsw.Position := 34;
    if (Dec= 5) and (Int= 0) then TbConfigPwmTsw.Position := 35;
    if (Dec= 6) and (Int= 0) then TbConfigPwmTsw.Position := 36;
    if (Dec= 7) and (Int= 0) then TbConfigPwmTsw.Position := 37;

    if Int < 7 then Int := Int+ 1;
    case (Dec) of // multiplication factor
      0: d := 0.625;
      1: d := 0.750;
      2: d := 0.875;
      3: d := 1.000;
      4: d := 1.250;
      5: d := 1.500;
      6: d := 1.750;
      7: d := 2.000;
    else
         d := 1.000;
    end;
    f := (CmbBConf_ClkFreq.ItemIndex +1)*8000;          // frekvenca v kHz
    f := f/512/Int*d;
    LblConf_PwmTswV.Caption :=  FloatToStrF(f, ffFixed, 32, 2)+ ' kHz';
  end else
  begin                                           /// CURRENT MODE
    CmbBConf_StepM.Items[5] := '1/16 µStep';
    CmbBConf_StepM.Items[6] := '1/16 µStep';
    CmbBConf_StepM.Items[7] := '1/16 µStep';

    CmbBConf_SyncM.Items[6] := 'Always low';
    CmbBConf_SyncM.Items[7] := 'Always low';
    CmbBConf_SyncM.Items[8] := 'Always low';

    CmbBConf_LowSpeedOpt.Visible := False;
    CbAl_5.Visible := False;
    CmbBConf_PredEn.Visible := True;
    CmbBConf_Bit5.Caption := 'Torque regulated with ADC_OUT';
    LblConf_PwmTswN.Caption := 'Switching period:';
    TbConfigPwmTsw.Max := 31;
    TbConfigPwmTsw.Position := ( StpDrv.Config[TabCnOs.TabIndex, $1A] and $7C00) shr 10;
    Int := TbConfigPwmTsw.Position;
    if Int = 0 then Int := 1;
    if TbConfigPwmTsw.Position > 0 then LblConf_PwmTswV.Caption := IntToStr(Int *4)+ ' µs';
    CmbBConf_PredEn.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $1A] and $8000) <> 0;
  end;

  CmbBConf_StepM.ItemIndex := ( StpDrv.Config[TabCnOs.TabIndex, $16] and $07);      // ker sem spreminjl items, moram to narest kasneje
  if  StpDrv.Config[TabCnOs.TabIndex, $16] and $80 <> 0 then
    CmbBConf_SyncM.ItemIndex := (( StpDrv.Config[TabCnOs.TabIndex, $16] and $70) shr 4)+ 1
  else
    CmbBConf_SyncM.ItemIndex := 0;

  CmbBConf_LowSpeedOpt.Checked := ( StpDrv.Config[TabCnOs.TabIndex, $08] and $1000) <> 0;

  CmbBConf_OscOut.Refresh;  // da nei bele lise...
  CmbBConf_StepM.Refresh;
  CmbBConf_SyncM.Refresh;

  CmbBConf_IGATE.Refresh;
  CmbBConf_TCC.Refresh;
  CmbBConf_TBOOST.Refresh;
  CmbBConf_TDT.Refresh;
  CmbBConf_TBLANK.Refresh;

  GroupBox_PwrClkSet.Enabled := True;
end;


procedure TForm1.BtnPwrResetClick(Sender: TObject);
begin
  StpDrv.ResetDevice(TabCnOs.TabIndex);
  BtnPwrBeriVseClick(nil);
end;

procedure TForm1.BtnPwr_SoftHiZClick(Sender: TObject);
begin
  StpDrv.SoftHiZ(TabCnOs.TabIndex);
end;

procedure TForm1.BtnPwr_HardHiZClick(Sender: TObject);
begin
  StpDrv.HardHiZ(TabCnOs.TabIndex);
end;

procedure TForm1.Button23Click(Sender: TObject);
begin
  StpDrv.GetParams_AllDev($03);     // Mark
  StpDrv.GetParams_AllDev($05);     // Acc
  StpDrv.GetParams_AllDev($06);     // Dec
  StpDrv.GetParams_AllDev($07);     // MaxSpeed
  StpDrv.GetParams_AllDev($08);     // MinSpeed
  EdStpMaxSpeed.Text     := FloatToStrF(  StpDrv.Config[TabCnOs.TabIndex, $07]          * 15.2587890625              , ffFixed, 8, 3);
  EdStpMinSpeed.Text     := FloatToStrF(( StpDrv.Config[TabCnOs.TabIndex, $08] and $FFF)* 0.2384185791015625         , ffFixed, 8, 3);
  EdStpAcceleration.Text := FloatToStrF(  StpDrv.Config[TabCnOs.TabIndex, $05]          * 14.551915228366851806640625, ffFixed, 8, 3);
  EdStpDeceleration.Text := FloatToStrF(  StpDrv.Config[TabCnOs.TabIndex, $06]          * 14.551915228366851806640625, ffFixed, 8, 3);
  EdStpMarkPos.Text      := StpDrv.Interp_Reg_Value(TabCnOs.TabIndex, $03, False);
end;

procedure TForm1.BtnSaveConfigClick(Sender: TObject);
var
  F: TextFile;
  I: Integer;
begin
  if SaveDialog1.Execute then
  begin
    AssignFile(F, SaveDialog1.FileName);
    Rewrite(F);
    for I := $01 to $1B do
    begin
      Writeln(F, IntToStr( StpDrv.Config[TabCnOs.TabIndex, I]));
    end;
    CloseFile(F);
  end;
end;

procedure TForm1.BtnNastaviAIClick(Sender: TObject);
var
  I: Integer;
  A: array of Integer;
  BfLn: Integer;
begin
  SetLength(A, 0);
  if C00.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 00; end;
  if C01.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 01; end;
  if C02.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 02; end;
  if C03.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 03; end;
  if C04.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 04; end;
  if C05.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 05; end;
  if C06.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 06; end;
  if C07.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 07; end;
  if C08.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 08; end;
  if C09.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 09; end;
  if C10.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 10; end;
  if C11.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 11; end;
  if C12.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 12; end;
  if C13.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 13; end;
  if C14.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 14; end;
  if C15.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 15; end;
  if C16.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 16; end;
  if C17.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 17; end;
  if C18.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 18; end;
  if C19.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 19; end;
  if C20.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 20; end;
  if C21.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 21; end;
  if C22.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 22; end;
  if C23.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 23; end;
  if C24.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 24; end;
  if C25.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 25; end;
  if C26.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 26; end;
  if C27.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 27; end;
  if C28.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 28; end;
  if C29.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 29; end;
  if C30.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 30; end;
  if C31.Checked then begin SetLength(A, Length(A)+ 1); A[Length(A)- 1] := 31; end;
  if Length(A)= 0 then begin ShowMessage('Ni izbranih kanalov za merjenje.'); Exit end;
end;

procedure TForm1.BtnOpenConfigClick(Sender: TObject);
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
        StpDrv.Config[TabCnOs.TabIndex, I] := StrToInt(V);
        StpDrv.SetParam(TabCnOs.TabIndex, I, StpDrv.Config[TabCnOs.TabIndex, I]);
      end;
    end;
    CloseFile(f);
    BtnPwrBeriVseClick(nil);
    PowerSTP_PrikaziCeloParamArrayTabelo;
  end;
end;

procedure TForm1.Button27Click(Sender: TObject);
var
  t: Double;
  s1, s2, l, k: Extended;
  I: Integer;
  N, Z: Integer;
  Aa, Ab: Double;
  Oa, Ob: Double;
  TokMeja: Double;
  Risi: Boolean;
begin
  if TabCnOs.TabIndex < 0 then Exit;
  N := 40;   // vzorcev  za povprecit  //40
  Z := 2;    // na koliko vzorcev narisat
  if StpDrv.VoltMode(TabCnOs.TabIndex) then
    TokMeja := (TBarKval.Position+ 1)/(StrToFloat(EdRm.Text)+ StpDrv.Rs)*StrToFloat(EdVbus.Text)/256/1.41421
  else
    TokMeja := (TBarKval.Position+ 1)/128/StpDrv.Rs;
  Series1.Clear;
  Series2.Clear;
  Series3.Clear;
  Series4.Clear;
// najprej kalibracija tokmeritve
  Oa := 0;
  Ob := 0;

  StpDrv.Config[TabCnOs.TabIndex, $02] := 0;
  StpDrv.SetParam(TabCnOs.TabIndex, $02, StpDrv.Config[TabCnOs.TabIndex, $02]);
  BtnPwr_SoftStopClick(nil);  // SoftStop
  Sleep(50);
  BtnPwr_RunFwClick(nil);    // start motor
  Sleep(2200);
//  StpDrv.SoftStopClick(nil);  // SoftStop
//  Sleep(2200);
  BtnPwr_HardStopClick(nil);
//  StpDrv.SoftHiZClick(nil);  // SoftHiz
//  Sleep(200);
//  Sleep(20);
  BtnPwr_SoftHiZClick(nil);  // SoftHiz

  Risi := True;
  Aa := 0;
  Ab := 0;
  s1 := 0;
  k := 0;
end;

procedure TForm1.BtnVnesiParametreMotorjaClick(Sender: TObject);
var
  I: Integer;
  IntSpd, StSlp, FnSlp: Integer;
  R, L, Ke, Vb, Ib: Double;
begin
  StpDrv.Vbus := Abs(StrToFloat(EdVbus.Text));
  StpDrv.MotorData[TabCnOs.TabIndex].Resistance := Abs(StrToFloat(EdRm.Text));
  if TabCnOs.TabIndex < 0 then Exit;
  for I := $09 to $0C do // Tokovi......
  begin
    StpDrv.Config[TabCnOs.TabIndex, I] := TBarKval.Position;
//    StpDrv.Config[TabCnOs.TabIndex, $09] := TBarKval.Position div 5;  // Holding current naj bo 5x manjsi
    StpDrv.SetParam(TabCnOs.TabIndex, I, StpDrv.Config[TabCnOs.TabIndex, I]);
    UpdateVrsticoRegTabele(I);
  end; // Tokovi......

  R := StpDrv.MotorData[TabCnOs.TabIndex].Resistance;
  L := StrToFloat(EdLm.Text)/1000;
  Ke := StrToFloat(EdKe.Text);
  Vb := StpDrv.Vbus;
  Ib := TBarKval.Position/R*Vb/256;
  if L= 0 then L := 0.00001;
// Intersect speed
  IntSpd := Round(4*R/2/pi/L*16.777216);
  if IntSpd > $3FFF then IntSpd := $3FFF;     // 14 bitov
  StpDrv.Config[TabCnOs.TabIndex, $0D] := IntSpd;
  StpDrv.SetParam(TabCnOs.TabIndex, $0D, StpDrv.Config[TabCnOs.TabIndex, $0D]);
  UpdateVrsticoRegTabele($0D);
// Starting slope
  StSlp := Round(65536*Ke/4/Vb);
  if StSlp > $FF then StSlp := $FF;         // 8 bitov
  StpDrv.Config[TabCnOs.TabIndex, $0E] := StSlp;
  StpDrv.SetParam(TabCnOs.TabIndex, $0E, StpDrv.Config[TabCnOs.TabIndex, $0E]);
  UpdateVrsticoRegTabele($0E);

// Final slope
//  FnSlp := Round(65536*(2*pi*L*Ib)/4/Vb);
  FnSlp := Round(65536*(2*pi*L*Ib+ Ke)/4/Vb);
  if FnSlp > $FF then FnSlp := $FF;         // 8 bitov
  StpDrv.Config[TabCnOs.TabIndex, $0F] := FnSlp;          // FN_SLP_ACC
  StpDrv.SetParam(TabCnOs.TabIndex, $0F, StpDrv.Config[TabCnOs.TabIndex, $0F]);
  UpdateVrsticoRegTabele($0F);

  StpDrv.Config[TabCnOs.TabIndex, $10] := FnSlp;          // FN_SLP_DEC
  StpDrv.SetParam(TabCnOs.TabIndex, $10, StpDrv.Config[TabCnOs.TabIndex, $10]);
  UpdateVrsticoRegTabele($10);
  Label24.Caption := 'INT_SPD:    $'+ IntToHex(IntSpd, 4)+ #13#10+
                     'ST_SLP:     $'+ IntToHex(StSlp, 2) + #13#10+
                     'FN_SLP_ACC: $'+ IntToHex(FnSlp, 2) + #13#10+
                     'FN_SLP_DEC: $'+ IntToHex(FnSlp, 2);
end;

procedure TForm1.BtnVoltageDefaultClick(Sender: TObject);
var
  I: Integer;
begin
  for I := $01 to $1B do
  begin
    StpDrv.Config[TabCnOs.TabIndex, I] := StpDrv.MotorData[TabCnOs.TabIndex].Vm_Config[I] ;
    StpDrv.SetParam(TabCnOs.TabIndex, I,StpDrv.Config[TabCnOs.TabIndex, I]);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  StpDrv.HardHiZ(TabCnOs.TabIndex);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  I: Integer;
  D: string;
  F: TextFile;
  tFile, tMotList: TStringList;
  Ini_File: TCustomIniFile;
begin
  Ini_File := TMemIniFile.Create(ExtractFilePath(Application.ExeName)+ 'MotorDatabase.ini');
  try
    try
      Ini_File.WriteString ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'OznakaMotorja', StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja);
      Ini_File.WriteInteger('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'StepsPerRev'  , StpDrv.MotorData[TabCnOs.TabIndex].StepsPerRev  );
      Ini_File.WriteFloat  ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'Resistance'   , StpDrv.MotorData[TabCnOs.TabIndex].Resistance   );
      Ini_File.WriteFloat  ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'Inductance'   , StpDrv.MotorData[TabCnOs.TabIndex].Inductance   );
      Ini_File.WriteFloat  ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'Ke'           , StpDrv.MotorData[TabCnOs.TabIndex].Ke           );
      Ini_File.WriteFloat  ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'RatedCurrent' , StpDrv.MotorData[TabCnOs.TabIndex].RatedCurrent );
      for I := $01 to $1B do
      begin
        Ini_File.WriteFloat ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'Vm_Cnf[$'+ IntToHex(I, 2)+']', StpDrv.MotorData[TabCnOs.TabIndex].Vm_Config[I]);
      end;
      for I := $01 to $1B do
      begin
        Ini_File.WriteFloat ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'Cm_Cnf[$'+ IntToHex(I, 2)+']', StpDrv.MotorData[TabCnOs.TabIndex].Vm_Config[I]);
      end;
      Ini_File.UpdateFile;
    except
      ShowMessage('Uporabnik nima dovolj pravic za spreminjanje datoteke >> MotorDatabase.ini <<');
    end;
  finally
    Ini_File.Free;
  end;
end;

procedure TForm1.BtnPwr_MoveBckClick(Sender: TObject);
begin
  StpDrv.Move_DirBck(TabCnOs.TabIndex, StrToInt(EdStpNstep.Text));
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  t: Double;
  s1, s2: Extended;
  I: Integer;
  N, Z: Integer;
  Aa, Ab: Double;
begin
  N := 4;   // vzorcev  za povprecit
  Z := 10;    // na koliko vzorcev narisat
  Series1.Clear;
  Series2.Clear;
  Series3.Clear;
  Series4.Clear;

  Label16.Caption := 'Zavrti motor';
  Label16.Update;
  for I := 0 to 3 do
  begin
    Sleep(1000);
    Label16.Caption := IntToStr(3-I);
    Label16.Update;
  end;

//  BtnRisiSignaleClick(nil);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
//  Form2.ShowModal;
end;

procedure TForm1.BtnSetMovementsClick(Sender: TObject);
begin
  EdStpMaxSpeed.Text := FloatToStrF( StpDrv.Set_MaxSpeed(TabCnOs.TabIndex, StrToFloat(EdStpMaxSpeed.Text)), ffFixed, 16, 3);
  EdStpMinSpeed.Text := FloatToStrF( StpDrv.Set_MinSpeed(TabCnOs.TabIndex, StrToFloat(EdStpMinSpeed.Text)), ffFixed, 16, 3);
  EdStpAcceleration.Text := FloatToStrF( StpDrv.Set_Acc(TabCnOs.TabIndex, StrToFloat(EdStpAcceleration.Text)), ffFixed, 16, 3);
  EdStpDeceleration.Text := FloatToStrF( StpDrv.Set_Dec(TabCnOs.TabIndex, StrToFloat(EdStpDeceleration.Text)), ffFixed, 16, 3);
  EdStpMarkPos.Text := IntToStr( StpDrv.Set_MarkPos(TabCnOs.TabIndex, StrToInt(EdStpMarkPos.Text)));
  BtnPwrBeriVseClick(nil);
end;

procedure TForm1.Button6Click(Sender: TObject);
type
  TDat= record
    Cas: Double;
    Sin: Double;
    Cos: Double;
    Ampl: Double;
    Poz: Double;
    Hit: Double;
  end;
var
  Dat: Array of TDat;
  I, J, N: Integer;
  Zac: Integer;
begin
  N := StrToInt(Edit1.Text);
  Series5.Clear;
  Series6.Clear;
  Series7.Clear;
  Series8.Clear;
  Series9.Clear;
  SetLength(Dat, Series4.Count);

  Zac := 0;
  for I := 0 to Series1.Count- 1 do
    if Series1.XValue[I] >= Series4.XValue[0] then
    begin
      Zac := I;
      Break;
    end;

  for I := 0 to Length(Dat)- 1 do
  begin
    Dat[I].Cas := Series1.XValue[I+ Zac]- Series4.XValue[0];
    Dat[I].Sin := Series1.YValue[I+ Zac];
    Dat[I].Cos := Series2.YValue[I+ Zac];
    Dat[I].Ampl:= Series3.YValue[I+ Zac];
    Dat[I].Poz := Abs(Series4.YValue[I]*1000);
  end;
  for I := Zac to Length(Dat)- 1 do
  begin
    for J := I downto 0 do
    begin
      if (Dat[I].Poz- Dat[J].Poz) >= 1/N then
      begin
        Dat[I].Hit := 4*1000/N/(Dat[I].Cas- Dat[J].Cas);
        Break;
      end;
    end;
  end;
  for I := 0 to Length(Dat)- 1 do
  begin
//    Series5.AddXY(Dat[I].Cas, Dat[I].Sin);
//    Series6.AddXY(Dat[I].Cas, Dat[I].Cos);
//    Series7.AddXY(Dat[I].Cas, Dat[I].Ampl);
//    Series8.AddXY(Dat[I].Cas, Dat[I].Poz/1000);
    Series9.AddXY(Dat[I].Cas, Dat[I].Hit);
  end;
end;

procedure TForm1.BtnPwr_RunFwClick(Sender: TObject);
var
  Speed: Double;
begin
  Speed := StrToFloat(EdStpSpeed.Text);
  Speed := StpDrv.Run_DirFwd(TabCnOs.TabIndex, Speed);
  EdStpSpeed.Text := FloatToStrF(Speed, ffFixed, 32, 4);
end;

procedure TForm1.BtnPwr_RunBckClick(Sender: TObject);
var
  Speed: Double;
begin
  Speed := StrToFloat(EdStpSpeed.Text);
  Speed := StpDrv.Run_DirBck(TabCnOs.TabIndex, Speed);
  EdStpSpeed.Text := FloatToStrF(Speed, ffFixed, 32, 4);
end;

procedure TForm1.BtnPwr_MoveFwClick(Sender: TObject);
begin
  StpDrv.Move_DirFwd(TabCnOs.TabIndex, StrToInt(EdStpNstep.Text));
end;

procedure TForm1.BtnPwr_GoToClick(Sender: TObject);
begin
  StpDrv.GoTo_Short(TabCnOs.TabIndex, StrToInt(EdStpAbsPos.Text));
end;

procedure TForm1.BtnPwr_GoToDirBckClick(Sender: TObject);
begin
  StpDrv.GoTo_DirBck(TabCnOs.TabIndex, StrToInt(EdStpAbsPos.Text));
end;

procedure TForm1.BtnPwr_GoToDirFwdClick(Sender: TObject);
begin
  StpDrv.GoTo_DirFwd(TabCnOs.TabIndex, StrToInt(EdStpAbsPos.Text));
end;

procedure TForm1.Btn_RegTabela_Click(Sender: TObject);
var
  I: Integer;
  Adr: Cardinal;
  Val: Cardinal;
begin
  for I := 1 to StringGrid1.RowCount- 1 do
  begin
    if Sender = FindComponent('BtnReadReg_' + IntToStr(I)) then
    begin
      Adr := StrToInt(StringGrid1.Cells [1, I]);
      StpDrv.GetParam(TabCnOs.TabIndex, Adr);
      UpdateVrsticoRegTabele(Adr);
      Break;
    end;
    if Sender = FindComponent('BtnWriteReg_' + IntToStr(I)) then
    begin
      Adr := StrToInt(StringGrid1.Cells [1, I]);
      Val := StrToInt(StringGrid1.Cells[4, I]);
      if StpDrv.SetParam(TabCnOs.TabIndex, Adr, Val) < 0 then ShowMessage('Napaka');
      StringGrid1.Refresh;
      if Adr= $16 then
      begin
// ee        if ( StpDrv.Config[TabCnOs.TabIndex, $16] and $08 = 0) <> StpDrv.VoltMode(TabCnOs.TabIndex) then BtnPwrBeriVseClick(nil);
//        BtnPwrBeriVseClick(nil);
      end;
      PowerSTP_PrikaziCeloParamArrayTabelo;
    end;
  end;
end;

procedure TForm1.CbAl_0Click(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CbAl_0.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $17] or $01 else Vi := StpDrv.Config[TabCnOs.TabIndex, $17] and $FE;
  StpDrv.SetParam(TabCnOs.TabIndex, $17, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $17] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($17);
end;

procedure TForm1.CbAl_1Click(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CbAl_1.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $17] or $02 else Vi := StpDrv.Config[TabCnOs.TabIndex, $17] and $FD;
  StpDrv.SetParam(TabCnOs.TabIndex, $17, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $17] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($17);
end;

procedure TForm1.CbAl_2Click(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CbAl_2.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $17] or $04 else Vi := StpDrv.Config[TabCnOs.TabIndex, $17] and $FB;
  StpDrv.SetParam(TabCnOs.TabIndex, $17, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $17] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($17);
end;

procedure TForm1.CbAl_3Click(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CbAl_3.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $17] or $08 else Vi := StpDrv.Config[TabCnOs.TabIndex, $17] and $F7;
  StpDrv.SetParam(TabCnOs.TabIndex, $17, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $17] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($17);
end;

procedure TForm1.CbAl_4Click(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CbAl_4.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $17] or $10 else Vi := StpDrv.Config[TabCnOs.TabIndex, $17] and $EF;
  StpDrv.SetParam(TabCnOs.TabIndex, $17, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $17] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($17);
end;

procedure TForm1.CbAl_5Click(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CbAl_5.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $17] or $20 else Vi := StpDrv.Config[TabCnOs.TabIndex, $17] and $DF;
  StpDrv.SetParam(TabCnOs.TabIndex, $17, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $17] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($17);
end;

procedure TForm1.CbAl_6Click(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CbAl_6.Checked then
    Vi :=  StpDrv.Config[TabCnOs.TabIndex, $17] or $40 else Vi := StpDrv.Config[TabCnOs.TabIndex, $17] and $BF;
  StpDrv.SetParam(TabCnOs.TabIndex, $17, Vi);
  if Vi <>  StpDrv.Config[TabCnOs.TabIndex, $17] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($17);
end;

procedure TForm1.CbAl_7Click(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CbAl_7.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $17] or $80 else Vi := StpDrv.Config[TabCnOs.TabIndex, $17] and $7F;
  StpDrv.SetParam(TabCnOs.TabIndex, $17, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $17] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($17);
end;

procedure TForm1.CbCiguMiguClick(Sender: TObject);
begin
  StpDrv.MotorData[TabCnOs.TabIndex].CyclicMoving := CbCiguMigu.Checked;
end;

procedure TForm1.CmbBConf_Bit5Click(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CmbBConf_Bit5.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] or $0020 else Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] and $FFDF;
  StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $1A] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.CmbBConf_BridgOffClick(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CmbBConf_BridgOff.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] or $0080 else Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] and $FF7F;
  StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $1A] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.CmbBConf_ClkFreqChange(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  Vi := (StpDrv.Config[TabCnOs.TabIndex, $1A] and $FFFC) or Cardinal(CmbBConf_ClkFreq.ItemIndex);
  StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $1A] then
    PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.CmbBConf_IGATEChange(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  Vi := (StpDrv.Config[TabCnOs.TabIndex, $18] and $FF1F) or Cardinal(CmbBConf_IGATE.ItemIndex shl 5);
  StpDrv.SetParam(TabCnOs.TabIndex, $18, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $18] then
    PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($18);
end;

procedure TForm1.CmbBConf_LowSpeedOptClick(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CmbBConf_LowSpeedOpt.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $08] or $1000 else Vi := StpDrv.Config[TabCnOs.TabIndex, $08] and $EFFF;
  StpDrv.SetParam(TabCnOs.TabIndex, $08, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $08] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($08);
end;

procedure TForm1.CmbBConf_OscOutChange(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  Vi := StpDrv.Config[TabCnOs.TabIndex, $1A];
  if Vi and $0004 <> 0 then
  begin
    if CmbBConf_OscOut.ItemIndex = 5 then Vi := Vi and $FFF7;
    if CmbBConf_OscOut.ItemIndex = 6 then Vi := Vi or $0008;
  end else
  begin
    if CmbBConf_OscOut.ItemIndex = 4 then Vi := Vi and $FFF7;
    if CmbBConf_OscOut.ItemIndex < 4 then Vi := (Vi and $FFFC) or $0008 or Cardinal(CmbBConf_OscOut.ItemIndex);
  end;
  StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $1A] then
    PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.CmbBConf_PredEnClick(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CmbBConf_PredEn.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] or $8000 else Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] and $7FFF;
  StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $1A] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.CmbBConf_StepMChange(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  Vi := (StpDrv.Config[TabCnOs.TabIndex, $16] and $F8) or Cardinal(CmbBConf_StepM.ItemIndex);
  StpDrv.SetParam(TabCnOs.TabIndex, $16, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $16] then
    PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($16);
end;

procedure TForm1.CmbBConf_SyncMChange(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  Vi := StpDrv.Config[TabCnOs.TabIndex, $16];
  if CmbBConf_SyncM.ItemIndex > 0 then
    Vi := (Vi and $8F) or Cardinal(((CmbBConf_SyncM.ItemIndex- 1) shl 4));
  if CmbBConf_SyncM.ItemIndex = 0 then Vi := Vi and  $7F else  Vi := Vi or  $80;
  StpDrv.SetParam(TabCnOs.TabIndex, $16, Vi);
  if StpDrv.Config[TabCnOs.TabIndex, $16] <> Vi then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($16);
end;

procedure TForm1.CmbBConf_TBLANKChange(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  Vi := (StpDrv.Config[TabCnOs.TabIndex, $19] and $1F) or Cardinal(CmbBConf_TBLANK.ItemIndex shl 5);
  StpDrv.SetParam(TabCnOs.TabIndex, $19, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $19] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($19);
end;

procedure TForm1.CmbBConf_TBOOSTChange(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  Vi := (StpDrv.Config[TabCnOs.TabIndex, $18] and $F8FF) or Cardinal(CmbBConf_TBOOST.ItemIndex shl 8);
  StpDrv.SetParam(TabCnOs.TabIndex, $18, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $18] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($18);
end;

procedure TForm1.CmbBConf_TCCChange(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  Vi := (StpDrv.Config[TabCnOs.TabIndex, $18] and $FFE0) or Cardinal(CmbBConf_TCC.ItemIndex);
  StpDrv.SetParam(TabCnOs.TabIndex, $18, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $18] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($18);
end;

procedure TForm1.CmbBConf_TDTChange(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  Vi := (StpDrv.Config[TabCnOs.TabIndex, $19] and $E0) or Cardinal(CmbBConf_TDT.ItemIndex);
  StpDrv.SetParam(TabCnOs.TabIndex, $19, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $19] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($19);
end;

procedure TForm1.CmbBConf_WD_ENClick(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if CmbBConf_WD_EN.Checked then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $18] or $0800 else Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] and $F7FF;
  StpDrv.SetParam(TabCnOs.TabIndex, $18, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $18] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($18);
end;

procedure TForm1.CmbBoxKontrolerjiChange(Sender: TObject);
var
  I: Integer;
  Str, SN, SN1: string;
  Ini_File: TCustomIniFile;
  StrLst: TStringList;
begin
  Ini_File := TMemIniFile.Create(ExtractFilePath(Application.ExeName)+ 'StepDrive.ini');
  try
    SN := CmbBoxKontrolerji.Items[CmbBoxKontrolerji.ItemIndex];
    SN1 := StpDrv.Get_FTDI_Serial_Number;
    if SN <> SN1 then
    begin
      begin
        if MessageDlg('Sedaj je prikljuèen kontroler s serijsko štrvilko '+ SN1+ '.'+ #13#10+
                      'Ali odpremo kontroler s serijsko tevilko '+ SN+ '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          StpDrv.Close;
          StpDrv.Open(SN);
          StpDrv.Vbus := StrToFloat(EdVbus.Text);
          NastaviFormoGledeNaPrikljuceno;
          BtnPwrBeriVseClick(nil);
          Ini_File.WriteString('Kontroler_informacije', 'SN_Nazadnje_Odprtega', SN);
        end else
        begin
          CmbBoxKontrolerji.ItemIndex := CmbBoxKontrolerji.Items.IndexOf(SN1);
        end;
      end;
    end;
  finally
    Ini_File.UpdateFile;
    Ini_File.Free;
  end;
end;

procedure TForm1.CmbBoxMotorjiChange(Sender: TObject);
begin
//  Form2.EdMotorModel.Text := CmbBoxMotorji.Text;
  if CmbBoxMotorji.Text= '' then
  begin
    BtnDodajMotor.Visible := False;
  end else
  begin
    if (CmbBoxMotorji.Items.IndexOf(CmbBoxMotorji.Text) < 0) then
    begin
      BtnDodajMotor.Visible := True;
    end else
    begin
      BtnDodajMotor.Visible := False;
    end;
  end;
  StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja := CmbBoxMotorji.Items[CmbBoxMotorji.ItemIndex];
end;

procedure TForm1.RgConf_UVLOClick(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if RgConf_UVLO.ItemIndex = 0 then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] and $FEFF else Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] or $0100;
  StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $1A] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.RgConf_ClkSrcClick(Sender: TObject);
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;

  if RgConf_ClkSrc.ItemIndex = 0 then
    StpDrv.SetParam(TabCnOs.TabIndex, $1A, StpDrv.Config[TabCnOs.TabIndex, $1A] and $FFFB)
  else begin
    if RgConf_ClkSrcType.Enabled then
    begin
      if MessageDlg('Èe ni oscilator prikljuèen pomeni, da bo kontroler nehal delovati. Ali to res naredim? ',
                     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      StpDrv.SetParam(TabCnOs.TabIndex, $1A, StpDrv.Config[TabCnOs.TabIndex, $1A] or $0004)
      else
        RgConf_ClkSrc.ItemIndex := 0;
    end else
    begin
      if MessageDlg('Najprej moram omogoèiti nastavitve za oscilator. Ali to res naredim? ',
                     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        RgConf_ClkSrc.ItemIndex := 0;
        CmbBConf_ClkFreq.Enabled := True;
        RgConf_ClkSrcType.Enabled := True;
        Exit;
      end;
    end;
  end;
  BtnPwrBeriVseClick(nil);
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.RgConf_ClkSrcTypeClick(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if RgConf_ClkSrcType.ItemIndex = 0 then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] and $FFF7 else Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] or $0008;
  StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $1A] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.RgConf_ExtSWClick(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if RgConf_ExtSW.ItemIndex = 0 then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] and $FFEF else Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] or $0010;
  StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $1A] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.RgConf_VccVoltClick(Sender: TObject);
var
  Vi: Cardinal;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if RgConf_VccVolt.ItemIndex = 0 then
    Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] and $FDFF else Vi := StpDrv.Config[TabCnOs.TabIndex, $1A] or $0200;
  StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $1A] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.RgPwrConfModeClick(Sender: TObject);
begin
//  if (RgPwrConfMode.ItemIndex = 0) then RgPwrConfMode.Color := $00FFB0B0 else RgPwrConfMode.Color := $00B9B9FF;
  if (RgPwrConfMode.ItemIndex = 0) and (StpDrv.Config[TabCnOs.TabIndex, $16] and $08 <> 0) then
  begin
    StpDrv.SetParam(TabCnOs.TabIndex, $16, StpDrv.Config[TabCnOs.TabIndex, $16] and $F7);
    TBarKval.Max := 255;
    BtnPwrBeriVseClick(nil);
    Exit;
  end;
  if (RgPwrConfMode.ItemIndex = 1) and (StpDrv.Config[TabCnOs.TabIndex, $16] and $08 = 0) then
  begin
    StpDrv.SetParam(TabCnOs.TabIndex, $16, StpDrv.Config[TabCnOs.TabIndex, $16] or $08);
    TBarKval.Position := TBarKval.Position and $7F;
    TBarKval.Max := 127;
    BtnPwrBeriVseClick(nil);
    Exit;
  end;
end;

procedure TForm1.RefreshStatusSemafor(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect; MotorIndex: Integer);
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
      Panel.Text := 'M'+ IntToStr(MotorIndex+ 1)+' ( V )';
      StatusBar.Canvas.Brush.Color := $00FFB0B0;
    end else
    begin
      if StpDrv.Config[MotorIndex, $16] and $08<> 0 then Panel.Text := 'M'+ IntToStr(MotorIndex+ 1)+' ( C )';
      StatusBar.Canvas.Brush.Color := $00B9B9FF;
    end;
  end;
  if Panel.Index = 1 then   // Stall A
  begin
    Panel.Text := 'Stall A';
    STALL_A := (StpDrv.Config[MotorIndex, $1B] and $8000) shr 15;
    if STALL_A = 1 then StatusBar.Canvas.Font.Color := clMedGray;         //  Stall A not detected
    if STALL_A = 0 then StatusBar.Canvas.Brush.Color := ClRed;            //  STEP LOSS detected on bridge A
    if STALL_A = 1 then StatusBar.Canvas.Brush.Color := ClNeutr;          //  Stall A not detected
  end;
  if Panel.Index = 2 then  // Stall B
  begin
    Panel.Text := 'Stall B';
    STALL_B    := (StpDrv.Config[MotorIndex, $1B] and $4000) shr 14;
    if STALL_B = 1 then StatusBar.Canvas.Font.Color := clMedGray;         //  Stall A not detected
    if STALL_B = 0 then StatusBar.Canvas.Brush.Color := ClRed;            //  STEP LOSS detected on bridge A
    if STALL_B = 1 then StatusBar.Canvas.Brush.Color := ClNeutr;          //  Stall A not detected
  end;
  if Panel.Index = 3 then  //  OCD
  begin
    Panel.Text := 'OCD';
    OCD := (StpDrv.Config[MotorIndex, $1B] and $2000) shr 13;
    if OCD = 1 then StatusBar.Canvas.Font.Color := clMedGray;             //  Overcurrent was not detected
    if OCD = 0 then StatusBar.Canvas.Brush.Color := ClRed;                //  Overcurrent was DETECTED
    if OCD = 1 then StatusBar.Canvas.Brush.Color := ClNeutr;              //  Overcurrent was not detected
  end;
  if Panel.Index = 4 then  // Temperature
  begin
    Panel.Text := ' T';
    TH_STATUS := (StpDrv.Config[MotorIndex, $1B] and $1800) shr 11;
    if TH_STATUS = 0 then StatusBar.Canvas.Brush.Color := ClMoneyGreen;   //  Temperature is normal
    if TH_STATUS = 1 then StatusBar.Canvas.Brush.Color := ClYellow;       //  Temperature warning is ON
    if TH_STATUS = 2 then StatusBar.Canvas.Brush.Color := ClRed;          //  Temperature warning with bridge shutdown
    if TH_STATUS = 3 then StatusBar.Canvas.Brush.Color := clFuchsia;      //  Temperature warning with device shutdown
  end;
  if Panel.Index = 5 then  // UV_ADC
  begin
    UVLO_ADC := (StpDrv.Config[MotorIndex, $1B] and $0400) shr 10;
    if UVLO_ADC = 1 then StatusBar.Canvas.Font.Color := clMedGray;        //  ADC input voltage is OK
    if UVLO_ADC = 1 then StatusBar.Canvas.Brush.Color := ClNeutr;         //  ADC input voltage is OK
    if UVLO_ADC = 1 then Panel.Text := ' ADC OK';
    if UVLO_ADC = 0 then StatusBar.Canvas.Brush.Color := ClRed;           //  ADC input voltage is LOW
    if UVLO_ADC = 0 then Panel.Text := 'ADC LOW';
  end;
  if Panel.Index = 6 then  // UVLO
  begin
    Panel.Text := 'UVLO';
    UVLO := (StpDrv.Config[MotorIndex, $1B] and $0200) shr  9;
    if UVLO = 0 then StatusBar.Canvas.Brush.Color := ClRed;               // Undervoltage lockout IS ACTIVE
    if UVLO = 1 then StatusBar.Canvas.Font.Color := clMedGray;            // Undervoltage lockout is not active
    if UVLO = 1 then StatusBar.Canvas.Brush.Color := ClNeutr;             // Undervoltage lockout is not active
  end;
  if Panel.Index = 7 then // Motor Status
  begin
    StatusBar.Canvas.Brush.Color := ClNeutr;
    MOT_STATUS := (StpDrv.Config[MotorIndex, $1B] and $0060) shr 5;
    if MOT_STATUS = 0 then Panel.Text := '  STOP';                        // Motor is stopped
    if MOT_STATUS = 1 then Panel.Text := ' ACCEL.';                       // Motor is accelerating
    if MOT_STATUS = 2 then Panel.Text := ' DECEL.';                       // Motor is decelerating
    if MOT_STATUS = 3 then Panel.Text := 'C. SPEED';                      // Motor is in constant speed
  end;
  if Panel.Index = 8 then  // Command error
  begin
    Panel.Text := 'C. error';
    CMD_ERROR := (StpDrv.Config[MotorIndex, $1B] and $0080) shr 7;
    if CMD_ERROR = 0 then StatusBar.Canvas.Font.Color := clMedGray;       // SPI commands OK
    if CMD_ERROR = 0 then StatusBar.Canvas.Brush.Color := ClNeutr;        // SPI commands OK
    if CMD_ERROR = 1 then StatusBar.Canvas.Brush.Color := ClRed;          // SPI command error is ON
  end;
  if Panel.Index = 9 then  // Direction
  begin
    StatusBar.Canvas.Brush.Color := ClNeutr;
    DIR := (StpDrv.Config[MotorIndex, $1B] and $0010) shr 4;
    if DIR = 0 then Panel.Text := ' <--';                                 // Direction is REVERSE
    if DIR = 1 then Panel.Text := ' -->';                                 // Direction is FORWARD
  end;
  if Panel.Index = 10 then // Switch event
  begin
    Panel.Text := 'SW';
    SW_EVN := (StpDrv.Config[MotorIndex, $1B] and $0008) shr 3;
    if SW_EVN = 0 then StatusBar.Canvas.Font.Color := clMedGray;          // Switch event was not detected
    if SW_EVN = 0 then StatusBar.Canvas.Brush.Color := ClNeutr;           // Switch event was not detected
    if SW_EVN = 1 then StatusBar.Canvas.Brush.Color := ClYellow;          // Switch event was DETECTED
  end;
  if Panel.Index = 11 then  // Switch status
  begin
    SW_F := (StpDrv.Config[MotorIndex, $1B] and $0004) shr 2;
    if SW_F = 0 then StatusBar.Canvas.Brush.Color := ClSilver;            // Switch is opened
    if SW_F = 0 then Panel.Text := 'OFF';                                 // Switch is opened
    if SW_F = 1 then StatusBar.Canvas.Brush.Color := ClLime;              // Switch is CLOSED
    if SW_F = 1 then Panel.Text := 'ON';                                  // Switch is CLOSED
  end;
  if Panel.Index = 12 then  // Busy
  begin
    Panel.Text := 'Busy';
    BUSY := (StpDrv.Config[MotorIndex, $1B] and $0002) shr 1;
    if BUSY = 0 then StatusBar.Canvas.Brush.Color := $0028FF2E;           // Motor is in action
    if BUSY = 1 then StatusBar.Canvas.Brush.Color := ClNeutr;             // All commands completed
    if BUSY = 1 then StatusBar.Canvas.Font.Color := clMedGray;            // All commands completed
  end;
  if Panel.Index = 13 then // Bridges ON
  begin
    HiZ := (StpDrv.Config[MotorIndex, $1B] and $0001) shr 0;
    if HiZ = 0 then StatusBar.Canvas.Brush.Color := ClYellow;             // Bridges are in LOW impedance state
    if HiZ = 1 then StatusBar.Canvas.Brush.Color := ClSilver;             // Bridges are in HIGH impedance state
    if HiZ = 0 then Panel.Text := 'Bridg. ON';                            // Bridges are in LOW impedance state
    if HiZ = 1 then Panel.Text := 'Bridg. OFF';                           // Bridges are in HIGH impedance state
  end;
  if Panel.Index = 14 then // pozicija
  begin
    StatusBar.Canvas.Font.Style := [FsBold];
    Panel.Text := StpDrv.Interp_Reg_Value(MotorIndex, $01, False);
    StatusBar.Canvas.Brush.Color := ClCream;
    StatusBar.Canvas.Font.Color := clNavy;
  end;
  if Panel.Index = 15 then // hitrost
  begin
    Panel.Text := StpDrv.Interp_Reg_Value(MotorIndex, $04, False);
    StatusBar.Canvas.Brush.Color := ClCream;
    StatusBar.Canvas.Font.Color := clGreen;
  end;
  if Panel.Index = 16 then  // I/V Mode
  begin
    if StpDrv.VoltMode(TabCnOs.TabIndex) then
    begin
      Panel.Text := 'Voltage';
      StatusBar.Canvas.Brush.Color := ClNeutr;
    end else
    begin
      Panel.Text := 'Current';
      StatusBar.Canvas.Brush.Color := $0028FF2E;
    end;
  end;
//////
  StatusBar.Canvas.FillRect(Rect);
  StatusBar.Canvas.TextOut(Rect.left+ 2, Rect.top, Panel.Text);
end;

procedure TForm1.StBar0DblClick(Sender: TObject);
begin
  StpDrv.GetClearStatus(0);
end;

procedure TForm1.StBar0DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  RefreshStatusSemafor(StatusBar, Panel, Rect, 0);
end;

procedure TForm1.StBar1DblClick(Sender: TObject);
begin
  StpDrv.GetClearStatus(1);
end;

procedure TForm1.StBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  RefreshStatusSemafor(StatusBar, Panel, Rect, 1);
end;

procedure TForm1.StBar2DblClick(Sender: TObject);
begin
  StpDrv.GetClearStatus(2);
end;

procedure TForm1.StBar2DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  RefreshStatusSemafor(StatusBar, Panel, Rect, 2);
end;

procedure TForm1.StBar3DblClick(Sender: TObject);
begin
  StpDrv.GetClearStatus(3);
end;

procedure TForm1.StBar3DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  RefreshStatusSemafor(StatusBar, Panel, Rect, 3);
end;

procedure TForm1.StBar4DblClick(Sender: TObject);
begin
  StpDrv.GetClearStatus(4);
end;

procedure TForm1.StBar4DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  RefreshStatusSemafor(StatusBar, Panel, Rect, 4);
end;

procedure TForm1.StBar5DblClick(Sender: TObject);
begin
  StpDrv.GetClearStatus(5);
end;

procedure TForm1.StBar5DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  RefreshStatusSemafor(StatusBar, Panel, Rect, 5);
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S, V: Integer;
  R: TRect;
  I: Integer;
  Str: string;
  Adr: Integer;
  Val: Integer;
begin
  if TabCnOs.TabIndex < 0 then Exit;
  S := ACol;
  V := ARow;
  if (S = 4 ) and (V > 0) then
  begin
    if TryStrToInt(StringGrid1.Cells[1, V], Adr) then
    begin
      if (Adr= $04) or (Adr= $12) or (Adr= $1B) then Exit;
      if TryStrToInt(StringGrid1.Cells[S, V], Val) then
      begin
        if Cardinal(StrToInt(StringGrid1.Cells[S, V])) <>StpDrv.Config[TabCnOs.TabIndex, Adr] then
        begin
          StringGrid1.Canvas.Brush.Color :=  ClYellow; // clInfoBk;
          StringGrid1.Canvas.Font.Style := [ TFontStyle.fsBold ];
          R := StringGrid1.CellRect(S, V);
          Str := StringGrid1.Cells[S, V];
          I := R.Top+ ((R.Bottom- R.Top- StringGrid1.Canvas.TextHeight(Str)) div 2);
          StringGrid1.Canvas.FillRect(R);
          StringGrid1.Canvas.TextRect(R, R.Left+ 2,I, Str);
        end;
      end else
        StringGrid1.Cells[4, V] := '$'+ IntToHex(StpDrv.Config[TabCnOs.TabIndex, Adr], 2*StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).NrBayt);
    end;
  end;
end;

procedure TForm1.StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
var
  Val1: Cardinal;
  Adr: Byte;
begin
  if (ACol= 4) then
  begin
    if Length(StringGrid1.Cells[4, ARow])> 1 then
    begin
      Val1 := StrToInt(StringGrid1.Cells[4, ARow]);
      Adr := StrToInt(StringGrid1.Cells[1, ARow]) and $FF;
      StpDrv.Config[TabCnOs.TabIndex, Adr] := Val1;
      StringGrid1.Cells[3, ARow] := StpDrv.Interp_Reg_Value(TabCnOs.TabIndex, Adr, True);
      if Val1 <> StpDrv.Config[TabCnOs.TabIndex, Adr] then StringGrid1.Cells[4, ARow] := '$'+ IntToHex(StpDrv.Config[TabCnOs.TabIndex, Adr], 2*StpDrv.RegParamInfo(TabCnOs.TabIndex, Adr).NrBayt);
      StringGrid1.Repaint;
    end;
  end;
end;

procedure TForm1.StringGrid1TopLeftChanged(Sender: TObject);
begin
  StringGrid1.Repaint;
end;

procedure TForm1.TabCnOsChange(Sender: TObject);
begin
  BtnPwrBeriVseClick(nil);
//  Form2.EdMotorModel.Text := StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja;
  CmbBoxMotorji.ItemIndex := CmbBoxMotorji.Items.IndexOf(StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja);
  CbCiguMigu.Checked := StpDrv.MotorData[TabCnOs.TabIndex].CyclicMoving;
end;

procedure TForm1.TBarKvalChange(Sender: TObject);
var
  I: Integer;
  Kval: Cardinal;
  R: Double;
begin
  Exit;
  Kval := TBarKval.Position;
  if not Form1.Visible then Exit;
  if StpDrv.VoltMode(TabCnOs.TabIndex) then
  begin
    Kval := TBarKval.Position;
    StpDrv.Vbus := StrToFloat(EdVbus.Text);
    R := StrToFloat(EdRm.Text)+ StpDrv.Rs;
    LblKval.Caption := 'Tok: ' + IntToStr(Round(Kval/R*StpDrv.Vbus/256*1000/1.41421        ))+ ' / '+
                       IntToStr(Round(Kval/R*StpDrv.Vbus/256*1000))+' mA'  ;
  end else
  begin
    R := StpDrv.Rs;
    LblKval.Caption := 'Tok: ' + IntToStr(Round((Kval+ 1)/128/R*1000/1.41421))+ ' / '+ IntToStr(Round((Kval+ 1)/128/R*1000))+ ' mA';
  end;
  for I := $09 to $0C do // Tokovi......
  begin
    StpDrv.Config[TabCnOs.TabIndex, I] := TBarKval.Position;
    StpDrv.SetParam(TabCnOs.TabIndex, I, StpDrv.Config[TabCnOs.TabIndex, I]);
    UpdateVrsticoRegTabele(I);
  end; // Tokovi......
end;

procedure TForm1.TbConfigPwmTswChange(Sender: TObject);
var
  Vi: Cardinal;
  Dec, Int: Cardinal;
  f: Integer;
begin
  if not GroupBox_PwrClkSet.Enabled then Exit;
  if StpDrv.VoltMode(TabCnOs.TabIndex) then
  begin
    Dec := 0;
    Int := 6;
    f := (CmbBConf_ClkFreq.ItemIndex +1)*8;     // tabela je normirana na 1MHz
    case TbConfigPwmTsw.Position of
       0: begin Dec := 0; Int := 6; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.174386161 , ffFixed, 32, 2)+ ' kHz'; end;
       1: begin Dec := 0; Int := 5; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.203450521 , ffFixed, 32, 2)+ ' kHz'; end;
       2: begin Dec := 1; Int := 6; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.209263393 , ffFixed, 32, 2)+ ' kHz'; end;
       3: begin Dec := 0; Int := 4; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.244140625 , ffFixed, 32, 2)+ ' kHz'; end;
       4: begin Dec := 3; Int := 6; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.279017857 , ffFixed, 32, 2)+ ' kHz'; end;
       5: begin Dec := 2; Int := 5; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.284830729 , ffFixed, 32, 2)+ ' kHz'; end;
       6: begin Dec := 1; Int := 4; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.29296875  , ffFixed, 32, 2)+ ' kHz'; end;
       7: begin Dec := 0; Int := 3; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.305175781 , ffFixed, 32, 2)+ ' kHz'; end;
       8: begin Dec := 3; Int := 5; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.325520833 , ffFixed, 32, 2)+ ' kHz'; end;
       9: begin Dec := 2; Int := 4; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.341796875 , ffFixed, 32, 2)+ ' kHz'; end;
      10: begin Dec := 4; Int := 6; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.348772321 , ffFixed, 32, 2)+ ' kHz'; end;
      11: begin Dec := 1; Int := 3; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.366210938 , ffFixed, 32, 2)+ ' kHz'; end;
      12: begin Dec := 3; Int := 4; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.390625    , ffFixed, 32, 2)+ ' kHz'; end;
      13: begin Dec := 0; Int := 2; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.406901042 , ffFixed, 32, 2)+ ' kHz'; end;
      14: begin Dec := 5; Int := 6; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.418526786 , ffFixed, 32, 2)+ ' kHz'; end;
      15: begin Dec := 2; Int := 3; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.427246094 , ffFixed, 32, 2)+ ' kHz'; end;
      16: begin Dec := 1; Int := 2; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.48828125  , ffFixed, 32, 2)+ ' kHz'; end;
      17: begin Dec := 7; Int := 6; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.558035714 , ffFixed, 32, 2)+ ' kHz'; end;
      18: begin Dec := 2; Int := 2; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.569661458 , ffFixed, 32, 2)+ ' kHz'; end;
      19: begin Dec := 5; Int := 4; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.5859375   , ffFixed, 32, 2)+ ' kHz'; end;
      20: begin Dec := 0; Int := 1; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.610351563 , ffFixed, 32, 2)+ ' kHz'; end;
      21: begin Dec := 3; Int := 2; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.651041667 , ffFixed, 32, 2)+ ' kHz'; end;
      22: begin Dec := 6; Int := 4; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.68359375  , ffFixed, 32, 2)+ ' kHz'; end;
      23: begin Dec := 1; Int := 1; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.732421875 , ffFixed, 32, 2)+ ' kHz'; end;
      24: begin Dec := 7; Int := 4; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.78125     , ffFixed, 32, 2)+ ' kHz'; end;
      25: begin Dec := 4; Int := 2; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.813802083 , ffFixed, 32, 2)+ ' kHz'; end;
      26: begin Dec := 2; Int := 1; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.854492188 , ffFixed, 32, 2)+ ' kHz'; end;
      27: begin Dec := 3; Int := 1; LblConf_PwmTswV.Caption := FloatToStrF(f* 0.9765625   , ffFixed, 32, 2)+ ' kHz'; end;
      28: begin Dec := 6; Int := 2; LblConf_PwmTswV.Caption := FloatToStrF(f* 1.139322917 , ffFixed, 32, 2)+ ' kHz'; end;
      29: begin Dec := 0; Int := 0; LblConf_PwmTswV.Caption := FloatToStrF(f* 1.220703125 , ffFixed, 32, 2)+ ' kHz'; end;
      30: begin Dec := 7; Int := 2; LblConf_PwmTswV.Caption := FloatToStrF(f* 1.302083333 , ffFixed, 32, 2)+ ' kHz'; end;
      31: begin Dec := 1; Int := 0; LblConf_PwmTswV.Caption := FloatToStrF(f* 1.46484375  , ffFixed, 32, 2)+ ' kHz'; end;
      32: begin Dec := 2; Int := 0; LblConf_PwmTswV.Caption := FloatToStrF(f* 1.708984375 , ffFixed, 32, 2)+ ' kHz'; end;
      33: begin Dec := 3; Int := 0; LblConf_PwmTswV.Caption := FloatToStrF(f* 1.953125    , ffFixed, 32, 2)+ ' kHz'; end;
      34: begin Dec := 4; Int := 0; LblConf_PwmTswV.Caption := FloatToStrF(f* 2.44140625  , ffFixed, 32, 2)+ ' kHz'; end;
      35: begin Dec := 5; Int := 0; LblConf_PwmTswV.Caption := FloatToStrF(f* 2.9296875   , ffFixed, 32, 2)+ ' kHz'; end;
      36: begin Dec := 6; Int := 0; LblConf_PwmTswV.Caption := FloatToStrF(f* 3.41796875  , ffFixed, 32, 2)+ ' kHz'; end;
      37: begin Dec := 7; Int := 0; LblConf_PwmTswV.Caption := FloatToStrF(f* 3.90625     , ffFixed, 32, 2)+ ' kHz'; end;
    end;
    Vi := (StpDrv.Config[TabCnOs.TabIndex, $1A] and $03FF) or (Int shl 13 ) or (Dec shl 10);
    StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
  end else
  begin
    Vi := (StpDrv.Config[TabCnOs.TabIndex, $1A] and $83FF) or Cardinal(((TbConfigPwmTsw.Position shl 10) and $7C00));
    StpDrv.SetParam(TabCnOs.TabIndex, $1A, Vi);
    Int := TbConfigPwmTsw.Position;
    if Int = 0 then Int := 1;
    if TbConfigPwmTsw.Position > 0 then LblConf_PwmTswV.Caption := IntToStr(Int *4)+ ' µs';
  end;
  if Vi <> StpDrv.Config[TabCnOs.TabIndex, $1A] then PowerSTP_PrikaziCeloParamArrayTabelo;
  UpdateVrsticoRegTabele($1A);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  I: Integer;
  Spd: Double;
  Sm: Integer;
  P: Cardinal;
  A: Double;
begin
//  Exit;
  TimerTece := True;
  if (TimeGetTime mod 500) < Timer1.Interval then NastaviFormoGledeNaPrikljuceno;
  if not ComP.IsOpen then
    Form1.Caption := 'StepDrive - com0com ni na voljo'
  else
    if ComP.IsConnected then Form1.Caption := 'StepDrive - '+ Com0Com_Name+ ' je povezan' else Form1.Caption := 'StepDrive - '+ Com0Com_Name+ ' je pripravljen na povezavo';
  PowerSTP_Update_StatusPanele;
  if Length(StpDrv.MotorData) > 0 then
  begin
    for I := 0 to Length(StpDrv.MotorData)- 1 do
    begin
      if StpDrv.MotorData[I].CyclicMoving then
      begin
        if (StpDrv.Config[I, $1B ] and $0002) <> 0 then      // if not Busy
        begin
          Sleep(100);
          if (StpDrv.Config[I, $01 ] = 0) then StpDrv.GoMark(I) else StpDrv.GoHome(I);
        end;
      end;
    end;
  end;
  TimerTece := False;
end;

procedure TForm1.AutoSizeCol(Grid: TStringGrid; Column: integer);
var
  I, W, WMax: integer;
begin
  WMax := 0;
  for I := 0 to (Grid.RowCount - 1) do begin
    W := Grid.Canvas.TextWidth(Grid.Cells[Column, I]);
    if W > WMax then
      WMax := W;
  end;
  Grid.ColWidths[Column] := WMax + 12;
end;

procedure TForm1.UpdateVrsticoRegTabele(Addr: Byte);
var
  I: Integer;
  V: Integer;
begin
  for I := 1 to StringGrid1.RowCount- 1 do
  begin
    if TryStrToInt(StringGrid1.Cells[1, I], V) then
    begin
      if V = Addr then
      begin
        StringGrid1.Cells[0, I] := StpDrv.RegParamInfo(TabCnOs.TabIndex, Addr).RegName;
        StringGrid1.Cells[2, I] := StpDrv.RegParamInfo(TabCnOs.TabIndex, Addr).Opis ;
        StringGrid1.Cells[3, I] := StpDrv.Interp_Reg_Value(TabCnOs.TabIndex, Addr, True);
        StringGrid1.Cells[4, I] := '$'+ IntToHex(StpDrv.Config[TabCnOs.TabIndex, Addr], 2*StpDrv.RegParamInfo(TabCnOs.TabIndex, Addr).NrBayt);
        StringGrid1.Cells[5, I] := '$'+ IntToHex(StpDrv.RegParamInfo(TabCnOs.TabIndex, Addr).DefVal, 2*StpDrv.RegParamInfo(TabCnOs.TabIndex, Addr).NrBayt);
        StringGrid1.Cells[6, I] :=  IntToStr(StpDrv.RegParamInfo(TabCnOs.TabIndex, Addr).NrBit);
      end;
    end;
  end;
end;

procedure TForm1.NastaviFormoGledeNaPrikljuceno;
var
  I, J, R: Integer;
begin
  R := StpDrv.GetNumberOfDevices;
  if StpDrv.Count < 1 then
  begin
    for I := 0 to GroupBox_PwrClkSet.ControlCount- 1 do GroupBox_PwrClkSet.Controls[I].Enabled := False;
    for I := 0 to PnlPwrKomande.ControlCount- 1 do PnlPwrKomande.Controls[I].Enabled := False;
    for I := 0 to StringGrid1.ControlCount- 1 do StringGrid1.Controls[I].Enabled := False;
    StringGrid1.Font.Color := ClGrayText;
  end;
  if R < 0 then
  begin
    TabCnOs.TabIndex := -1;
    TabCnOs.Tabs.Clear;
    TabCnOs.Refresh;
//    StpDrv.Close;
//    StpDrv.Open;
// nekaj se izmisli, ce je napaka
  end else
  begin
    if StpDrv.Count = 0 then
    begin
      TabCnOs.TabIndex := -1;
      TabCnOs.Tabs.Clear;
      TabCnOs.Refresh;
    end else
    begin
      if TabCnOs.Tabs.Count <> StpDrv.Count then
      begin
        J := TabCnOs.TabIndex;
        TabCnOs.Tabs.Clear;
        for I := 0 to StpDrv.Count- 1 do
        begin
          TabCnOs.Tabs.Add('Kontroler osi '+ IntToStr(I+ 1));
        end;
        if (J <  0) then TabCnOs.TabIndex := 0;                           // ce ni bilo nobenega izbranega, izberem prvega
        if (J > StpDrv.Count) then TabCnOs.TabIndex := 0;                 // ce ni vec prej izbranega, izberem prvega
        if (J > -1) and (J <StpDrv.Count) then TabCnOs.TabIndex := J;     // ce izbran kontroler obstaja se naprej, pustim kakor je bilo
        TabCnOs.Refresh;

        if TabCnOs.TabIndex <> J then
        begin
          for I := 0 to GroupBox_PwrClkSet.ControlCount- 1 do GroupBox_PwrClkSet.Controls[I].Enabled := True;
          for I := 0 to PnlPwrKomande.ControlCount- 1 do PnlPwrKomande.Controls[I].Enabled := True;
          for I := 0 to StringGrid1.ControlCount- 1 do StringGrid1.Controls[I].Enabled := True;
          StringGrid1.Font.Color := ClBlack;
          BtnPwrBeriVseClick(nil);
        end;
      end;
    end;
  end;
  case StpDrv.Count of
    0: begin StBar5.height :=  0; StBar4.height :=  0; StBar3.height :=  0; StBar2.height :=  0; StBar1.height :=  0; StBar0.height :=  0; end;
    1: begin StBar5.height :=  0; StBar4.height :=  0; StBar3.height :=  0; StBar2.height :=  0; StBar1.height :=  0; StBar0.height := 19; end;
    2: begin StBar5.height :=  0; StBar4.height :=  0; StBar3.height :=  0; StBar2.height :=  0; StBar1.height := 19; StBar0.height := 19; end;
    3: begin StBar5.height :=  0; StBar4.height :=  0; StBar3.height :=  0; StBar2.height := 19; StBar1.height := 19; StBar0.height := 19; end;
    4: begin StBar5.height :=  0; StBar4.height :=  0; StBar3.height := 19; StBar2.height := 19; StBar1.height := 19; StBar0.height := 19; end;
    5: begin StBar5.height :=  0; StBar4.height := 19; StBar3.height := 19; StBar2.height := 19; StBar1.height := 19; StBar0.height := 19; end;
  else
       begin StBar0.height := 19 ; StBar1.height := 19 ; StBar2.height := 19 ; StBar3.height := 19 ; StBar4.height := 19 ; StBar5.height := 19 ; end;
  end;
end;

procedure TForm1.PowerSTP_Update_StatusPanele;
var
  I: Integer;
begin
  if StpDrv.Count > 0 then
  begin
    StpDrv.GetParams_AllDev($01);     // Current position - R/WS
    StpDrv.GetParams_AllDev($04);     // SPEED  - read only
    StpDrv.GetParams_AllDev($1B);     // Status - read only
    if PageControl1.ActivePageIndex= 1 then
    begin
      StpDrv.GetParams_AllDev($12);     // ADC    - read only
      StpDrv.GetParams_AllDev($02);     // Electrical position - R/WS
      StpDrv.GetParams_AllDev($03);     // MARK position    - R/WR
      for I := 0 to StringGrid1.RowCount- 1 do StringGrid1.Rows[I].BeginUpdate;
      UpdateVrsticoRegTabele($1B);
      UpdateVrsticoRegTabele($04);
      UpdateVrsticoRegTabele($12);
      if not StringGrid1.EditorMode then   // ce hocem vpisati vrednost, potem takoj pritisnem write
      begin
        UpdateVrsticoRegTabele($01);
        UpdateVrsticoRegTabele($02);
        UpdateVrsticoRegTabele($03);
      end;
      for I := 0 to StringGrid1.RowCount- 1 do StringGrid1.Rows[I].EndUpdate;
    end;
  end;
  StBar0.Refresh;
  StBar1.Refresh;
  StBar2.Refresh;
  StBar3.Refresh;
  StBar4.Refresh;
  StBar5.Refresh;
end;

procedure TForm1.ChangeEvent(const bInserted: Boolean; const bRemoved: Boolean; const ADevType, ADriverName, AFriendlyName: string);
begin
  if (AFriendlyName = 'FT4222H') then
  begin
    if bInserted then
    begin
      Sleep(250); // malo mu dam casa, da se zbrihta, 100 je premalo
      InicializacijaKontrolerja;
//      StpDrv.Open;
      NastaviFormoGledeNaPrikljuceno;
      BtnPwrBeriVseClick(nil);
    end else
    begin
      StpDrv.Close;
      InicializacijaKontrolerja;
      NastaviFormoGledeNaPrikljuceno;
    end;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
type
  TDat= record
    Cas: Double;
    Sin: Double;
    Cos: Double;
    Ampl: Double;
    A2: Double;
    Poz: Double;
    Hit: Double;
  end;
var
  Dat: Array of TDat;
  I, J, N: Integer;
  Zac: Integer;
  Tmp: Double;
begin
  N := StrToInt(Edit1.Text);
  Series5.Clear;
  Series6.Clear;
  Series7.Clear;
  Series8.Clear;
  Series9.Clear;
  SetLength(Dat, Series4.Count);
  Zac := 0;
  for I := 0 to Series1.Count- 1 do
  begin
    if Series1.XValue[I] >= Series4.XValue[0] then
    begin
      Zac := I;
      Break;
    end;
  end;
  for I := 0 to Length(Dat)- 1 do
  begin
    Dat[I].Cas := Series1.XValue[I+ Zac]- Series4.XValue[0];
    Dat[I].Sin := Series1.YValue[I+ Zac];
    Dat[I].Cos := Series2.YValue[I+ Zac];
    Dat[I].Ampl:= Series3.YValue[I+ Zac];
    Dat[I].Poz := Abs(Series4.YValue[I]*1000);
  end;
  for I := Zac to Length(Dat)- 1 do
  begin
    Tmp := 0;
    for J := I downto 0 do
    begin
      Tmp := Tmp+ Dat[J].Ampl;
      if (Dat[I].Poz- Dat[J].Poz) >= 1/N then
      begin
        Dat[I].Hit := 4*1000/N/(Dat[I].Cas- Dat[J].Cas);
        Dat[I].A2 := tmp/(I-J);
        Break;
      end;
    end;
  end;

  for I := Zac to Length(Dat)- 1 do
  begin
    if Dat[I].Hit > 0 then
    begin
//      Series6.AddXY(Dat[I].Hit, Dat[I].Ampl);
      Series5.AddXY(Dat[I].Hit, Dat[I].A2);
    end;
    if Dat[I].Hit > 0.99*Dat[Length(Dat)- 2].Hit then Break;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
type
  TDat= record
    Cas: Double;
    Sin: Double;
    Cos: Double;
    Ampl: Double;
    Poz: Double;
    Hit: Double;
  end;
var
  Dat: Array of TDat;
  I, J, N: Integer;
  Zac: Integer;
begin
  N := StrToInt(Edit1.Text);
  Series5.Clear;
  Series6.Clear;
  Series7.Clear;
  Series8.Clear;
  Series9.Clear;
  SetLength(Dat, Series4.Count);

  Zac := 0;
  for I := 0 to Series1.Count- 1 do
    if Series1.XValue[I] >= Series4.XValue[0] then
    begin
      Zac := I;
      Break;
    end;

  for I := 0 to Length(Dat)- 1 do
  begin
    Dat[I].Cas := Series1.XValue[I+ Zac]- Series4.XValue[0];
    Dat[I].Sin := Series1.YValue[I+ Zac];
    Dat[I].Cos := Series2.YValue[I+ Zac];
    Dat[I].Ampl:= Series3.YValue[I+ Zac];
    Dat[I].Poz := Abs(Series4.YValue[I]*1000);
  end;
  for I := Zac to Length(Dat)- 1 do
  begin
    for J := I downto 0 do
    begin
      if (Dat[I].Poz- Dat[J].Poz) >= 1/N then
      begin
        Dat[I].Hit := 4*1000/N/(Dat[I].Cas- Dat[J].Cas);
        Break;
      end;
    end;
  end;
  for I := 0 to Length(Dat)- 1 do
  begin
//    Series5.AddXY(Dat[I].Cas, Dat[I].Sin);
//    Series6.AddXY(Dat[I].Cas, Dat[I].Cos);
//    Series7.AddXY(Dat[I].Cas, Dat[I].Ampl);
    Series8.AddXY(Dat[I].Cas, Dat[I].Poz/1000);
//    Series9.AddXY(Dat[I].Cas, Dat[I].Hit);
  end;
end;

procedure TForm1.ClipBoardChanged(var Message: TMessage);
var
  AsTxt: string;
  Ukaz: string;
begin
  AsTxt := Clipboard.AsText;
  if (Copy(AsTxt, 1, 16)= 'UkazZaStepDrive(') and (Copy(AsTxt, Length(AsTxt), 1 )= ')') then
  begin
    Ukaz := Copy(AsTxt, 17, Length(AsTxt)- 17);               // odstranim header in footer
    if StSpin_IzvediUkaz(Ukaz) then
    begin
      ClipBoard.SetTextBuf(Pchar(AsTxt+ ' '+ Ukaz));
//      Sleep(1);
    end;
  end;
end;

procedure TCom0com_Read.Execute;
var
  Ch: Char;
  Str: string;
begin
  Str := '';
  while not Terminated do
  begin
   if Form1.ComP.cbInQue > 0 then
   begin
     Form1.ComP.ReadChar(Ch);
     if Ch <> #13 then
     begin
       Str := Str+ Ch;
     end else
     begin
//       ShowMessage(Str);
       if Form1.StSpin_IzvediUkaz(Str) then Form1.ComP.SendString(Str);
       Str := '';
     end;
   end;
  end;
  Sleep(1);
end;

procedure TForm1.Naredi_Seznam_com0com(var ComPars:  TStringList);  // naredim seznam com0com mostickov, imeni ComPort parov sta loceni s presledkom
var
  I, J: Integer;
  Reg: TRegistry;
  St: Tstrings;
  ss: string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKeyReadOnly('hardware\devicemap\serialcomm');
    St := TstringList.Create;
    ComPars.Clear;
    try
      Reg.GetValueNames(St);
      for I := 0 to St.Count- 1 do  // naredim seznam com0com parov, ki so loceni s presledkom
      begin
        if Copy(St.Strings[I], 1, 16) = '\Device\com0com1' then
        begin
          ss := St.Strings[I];
          ss[16] := '2';
          for J := 0 to St.Count- 1 do
          begin
            if St.Strings[J] = ss then
            begin
              ComPars.Add(Reg.Readstring(St.Strings[I])+ ' '+ Reg.Readstring(St.Strings[J]));
            end;
          end;
        end;
      end;
    finally
      St.Free;
    end;
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function TForm1.StSpin_IzvediUkaz(var Ukaz: string): Boolean;  // ce ukaz obstaja, potem vrne true
var
  StrArr: array of string;
  I, J: Integer;
  tSt: TStringList;
  StNaprave: Integer;
  dVal: Double;
  iVal: Integer;
  cVal: Cardinal;
  F: TextFile;
  V: string;
begin
  Result := False;
  tSt := TStringList.Create;
  try
    Timer1.Enabled := False;
//    Sleep(10);
    repeat until not TimerTece;
    tSt.Delimiter := ';';
    tSt.StrictDelimiter := True;
    tSt.DelimitedText := Ukaz;
    for I := 0 to tSt.Count- 1 do tSt[I] := Trim(tSt[I]);
    if tSt.Count > 1 then
    begin
      if AnsiCompareText(tSt[0], 'Run_WithSpeed')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.Run_DirFwd(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Move_For')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            iVal := Round(StrToFloat(tSt[2]));
            iVal := StpDrv.Move_DirFwd(StNaprave, iVal);
            Ukaz := IntToStr(iVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'GoTo_Short')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            iVal := Round(StrToFloat(tSt[2]));
            iVal := StpDrv.GoTo_Short(StNaprave, iVal);
            Ukaz := IntToStr(iVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'GoTo_DirPos')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            iVal := Round(StrToFloat(tSt[2]));
            iVal := StpDrv.GoTo_DirFwd(StNaprave, iVal);
            Ukaz := IntToStr(iVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'GoTo_DirNeg')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            iVal := Round(StrToFloat(tSt[2]));
            iVal := StpDrv.GoTo_DirBck(StNaprave, iVal);
            Ukaz := IntToStr(iVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Move_Cyclic')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            iVal := Round(StrToFloat(tSt[2]));
            StpDrv.MotorData[TabCnOs.TabIndex].CyclicMoving := (iVal <> 0);
            Ukaz := '';
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Stop_Hard')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            StpDrv.HardStop(StNaprave);
            Ukaz := '';
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Stop_Soft')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            StpDrv.SoftStop(StNaprave);
            Ukaz := '';
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Driver_OFF')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            StpDrv.HardHiZ(StNaprave);
            Ukaz := '';
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'GetClear_Status')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            cVal := StpDrv.GetClearStatus(StNaprave);
            Ukaz := IntToStr(cVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_Status')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            cVal := StpDrv.GetParam(StNaprave, $1B);
            Ukaz := IntToStr(cVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_Position')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            iVal := Round(StrToFloat(tSt[2]));
            iVal := StpDrv.Set_AbsPos(StNaprave, iVal);
            Ukaz := IntToStr(iVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_MarkPosition')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            iVal := Round(StrToFloat(tSt[2]));
            iVal := StpDrv.Set_MarkPos(StNaprave, iVal);
            Ukaz := IntToStr(iVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_Acceleration')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.Set_Acc(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_Deceleration')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.Set_Dec(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_MaxSpeed')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.Set_MaxSpeed(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_MinSpeed')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.Set_MinSpeed(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_HoldCurrent')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.Set_HoldCurrent(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_RunCurrent')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.Set_RunCurrent(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_AccCurrent')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.Set_AccCurrent(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_DecCurrent')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.Set_DecCurrent(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Set_MicroStep')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            cVal := Round(StrToFloat(tSt[2]));
            cVal := StpDrv.Set_StpMode(StNaprave, cVal);
            Ukaz := IntToStr(cVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_IsBusy')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            cVal := StpDrv.GetParam(StNaprave, $1B);
            if (cVal and $0002) <> 0 then Ukaz := '0' else Ukaz := '1';
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_IsBridgeOn')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            cVal := StpDrv.GetParam(StNaprave, $1B);
            if (cVal and $0001) <> 0 then Ukaz := '0' else Ukaz := '1';
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_IsSwitchOn')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            cVal := StpDrv.GetParam(StNaprave, $1B);
            if (cVal and $0004) <> 0 then Ukaz := '1' else Ukaz := '0';
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_WasSwitchOn')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            cVal := StpDrv.GetParam(StNaprave, $1B);
            if (cVal and $0008) <> 0 then Ukaz := '1' else Ukaz := '0';
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_Acceleration')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StpDrv.Get_Acc(StNaprave);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_Deceleration')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StpDrv.Get_Dec(StNaprave);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_MaxSpeed')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StpDrv.Get_MaxSpeed(StNaprave);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_MinSpeed')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StpDrv.Get_MinSpeed(StNaprave);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_Position')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            iVal := StpDrv.Get_AbsPos(StNaprave);
            Ukaz := IntToStr(iVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_MarkPosition')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            iVal := StpDrv.Get_MarkPos(StNaprave);
            Ukaz := IntToStr(iVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_Speed')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StpDrv.Get_Speed(StNaprave);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_HoldCurrent')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StpDrv.Get_HoldCurrent(StNaprave);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_RunCurrent')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StpDrv.Get_RunCurrent(StNaprave);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_AccCurrent')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StpDrv.Get_AccCurrent(StNaprave);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_DecCurrent')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StpDrv.Get_DecCurrent(StNaprave);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'Get_MicroStep')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            cVal := StpDrv.Get_StpMode(StNaprave);
            Ukaz := IntToStr(cVal);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'GoToSwitch_ResetAbs_SoftStop')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.GoUntil_rAbs_dFwd(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'GoToSwitch_AbsToMark_SoftStop')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            dVal := StrToFloat(tSt[2]);
            dVal := StpDrv.GoUntil_pMrk_dFwd(StNaprave, dVal);
            Ukaz := FloatToStrF(dVal, ffFixed, 32, 4);
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'ReleaseSwitch_ResetAbs')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            StpDrv.RlsSW_rAbs_DirFwd(StNaprave);
            Ukaz := '';
          end;
        end;
      end;
      if AnsiCompareText(tSt[0], 'ReleaseSwitch_AbsToMark')= 0 then
      begin
        if tSt.Count = 2 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            StpDrv.RlsSW_pMrk_DirFwd(StNaprave);
            Ukaz := '';
          end;
        end;
      end;

      if AnsiCompareText(tSt[0], 'LoadConfiguration_FromFile')= 0 then
      begin
        if tSt.Count = 3 then
        begin
          StNaprave := StrToIntDef(tSt[1], -1)- 1;
          if StNaprave > -1 then
          begin
            Result := True;
            Ukaz := '';
            if FileExists(tSt[2]) then
            begin
              AssignFile(F, tSt[2]);
              Reset(F);
              I := 0;
              while not Eof(F) do
              begin
                Readln(F, V);
                I := I+ 1;
                if (I <= $1B) then
                begin
                  StpDrv.Config[StNaprave, I] := StrToInt(V);
                  StpDrv.SetParam(StNaprave, I, StpDrv.Config[StNaprave, I]);
                end;
              end;
              CloseFile(f);
              BtnPwrBeriVseClick(nil);
              PowerSTP_PrikaziCeloParamArrayTabelo;
              StpDrv.GetClearStatus(StNaprave);
            end else
            begin
              Ukaz := 'Datoteka ne obstaja';
              ShowMessage('Datoteka "'+ tSt[2]+ '" ne obstaja!');
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(tSt);
    Timer1.Enabled := True;
  end;
end;

function TForm1.StrItem(DelmtdTxt: string; Ind: Integer; Delimiter: Char): string;  // vrne string, ki je na indexu.
var
  St: TStringList;
begin
  Result := '';
  St := TstringList.Create;
  try
    St.Clear;
    St.Delimiter := ' ';
    St.DelimitedText := DelmtdTxt;
    Result := St[Ind]
  finally
    St.Free;
  end;
end;

end.
