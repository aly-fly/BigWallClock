unit StpTest_Main;

interface

uses
  Ftd2xx, LibFT4222, MahUSB, StSpin,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    BtnLoadParam: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    EdStpSpeed: TEdit;
    Button3: TButton;
    BtnClearStatus: TButton;
    RgMotor: TRadioGroup;
    Button1: TButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnLoadParamClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BtnClearStatusClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    USB: TUsbClass;
    procedure ChangeEvent(const bInserted: Boolean; const bRemoved: Boolean; const ADevType, ADriverName, AFriendlyName: string);

    { Private declarations }
  public
    var StpDrv: TStSpin;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  SN: string;
begin
  USB := TUsbClass.Create;
  USB.OnUsbChange := Self.ChangeEvent;
  try
    StpDrv := TStSpin.Create;
  except
    StpDrv.Free;
    ShowMessage('Napaka pri kreiranju StSpin objekta.');
    Form1.Close;
  end;
  StpDrv.Open(SN);
  Label1.Caption := SN;
  StpDrv.GetNumberOfDevices;
  RgMotor.Items.Clear;
  for I := 0 to StpDrv.Count- 1 do
    RgMotor.Items.Add('Motor_'+ IntToStr(I));
  RgMotor.ItemIndex := 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Assigned(USB) then USB.Free;
  if Assigned(StpDrv) then StpDrv.Free;
end;

procedure TForm1.BtnLoadParamClick(Sender: TObject);
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
        StpDrv.Config[RgMotor.ItemIndex, I] := StrToInt(V);
        StpDrv.SetParam(RgMotor.ItemIndex, I, StpDrv.Config[RgMotor.ItemIndex, I]);
      end;
    end;
    CloseFile(f);
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  P: Integer;
begin
  P := StpDrv.Get_AbsPos(RgMotor.ItemIndex);
  Label2.Caption := IntToStr(P);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Speed: Double;
begin
  Speed := StrToFloat(EdStpSpeed.Text);
  Speed := StpDrv.Run_DirFwd(RgMotor.ItemIndex, Speed);
  EdStpSpeed.Text := FloatToStrF(Speed, ffFixed, 32, 4);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  StpDrv.HardHiZ(RgMotor.ItemIndex);
end;

procedure TForm1.BtnClearStatusClick(Sender: TObject);
begin
  StpDrv.GetClearStatus(RgMotor.ItemIndex);
end;

procedure TForm1.ChangeEvent(const bInserted: Boolean; const bRemoved: Boolean; const ADevType, ADriverName, AFriendlyName: string);
var
  I: Integer;
  SN: string;
begin
  if (AFriendlyName = 'FT4222H') then
  begin
    RgMotor.Items.Clear;
    if bInserted then
    begin
      Sleep(250); // malo mu dam casa, da se zbrihta, 100 je premalo
      StpDrv.Open(SN);
      Label1.Caption := SN;
      StpDrv.GetNumberOfDevices;
      for I := 0 to StpDrv.Count- 1 do
        RgMotor.Items.Add('Motor_'+ IntToStr(I));
      RgMotor.ItemIndex := 0;
    end else
    begin
      StpDrv.Close;
      Label1.Caption := '';
    end;
  end;
end;


end.
