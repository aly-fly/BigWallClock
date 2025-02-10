unit StepDrive_MotPar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  IniFiles
  ;

type
  TForm2 = class(TForm)
    Button3: TButton;
    EdMotorModel: TEdit;
    Button18: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure EdMotorModelKeyPress(Sender: TObject; var Key: Char);
    procedure EdMotorModelChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  StepDrive_Main;

{$R *.dfm}

procedure TForm2.Button18Click(Sender: TObject);
begin
  Form1.StpDrv.MotorData[Form1.TabCnOs.TabIndex].OznakaMotorja := EdMotorModel.Text;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  I: Integer;
  Ini_File: TCustomIniFile;
begin
  with Form1 do
  begin
    Ini_File := TMemIniFile.Create(ExtractFilePath(Application.ExeName)+ 'MotorDatabase.ini');
    try
      try
        Ini_File.WriteInteger('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'StepsPerRev' , StpDrv.MotorData[TabCnOs.TabIndex].StepsPerRev);
        Ini_File.WriteFloat  ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'Resistance'  , StpDrv.MotorData[TabCnOs.TabIndex].Resistance);
        Ini_File.WriteFloat  ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'Inductance'  , StpDrv.MotorData[TabCnOs.TabIndex].Inductance);
        Ini_File.WriteFloat  ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'Ke'          , StpDrv.MotorData[TabCnOs.TabIndex].Ke);
        Ini_File.WriteFloat  ('PodatkiZaMotor_'+ StpDrv.MotorData[TabCnOs.TabIndex].OznakaMotorja, 'RatedCurrent', StpDrv.MotorData[TabCnOs.TabIndex].RatedCurrent);
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
end;

procedure TForm2.EdMotorModelChange(Sender: TObject);
begin
  Form1.CmbBoxMotorji.ItemIndex := Form1.CmbBoxMotorji.Items.IndexOf(EdMotorModel.Text);
end;

procedure TForm2.EdMotorModelKeyPress(Sender: TObject; var Key: Char);
begin
  if Key= #13 then
  begin
    if Form1.CmbBoxMotorji.Items.IndexOf(EdMotorModel.Text) = -1 then
      Form1.CmbBoxMotorji.Items.Add(EdMotorModel.Text);
    Form1.CmbBoxMotorji.ItemIndex := Form1.CmbBoxMotorji.Items.IndexOf(EdMotorModel.Text);
  end;

end;

end.
