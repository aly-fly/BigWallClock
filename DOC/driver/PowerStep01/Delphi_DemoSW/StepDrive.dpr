program StepDrive;

uses
  Windows,
  SysUtils,
  Vcl.Forms,
  StepDrive_Main in 'StepDrive_Main.pas' {Form1},
  StSpin in '..\_LIB\StSpin\StSpin.pas',
  ftd2xx in '..\_LIB\FTDI\ftd2xx.pas',
  LibFT4222 in '..\_LIB\FTDI\LibFT4222.pas',
  meIDS in '..\_LIB\Meilhaus\meIDS.pas',
  meError in '..\_LIB\Meilhaus\meError.pas',
  ME4670_RLS in '..\_LIB\Meilhaus\ME4670_RLS.pas',
  MahUSB in '..\_LIB\MahUSB\MahUSB.pas',
  ComPort in '..\_LIB\ComPort\ComPort.pas',
  StepDrive_MotPar in 'StepDrive_MotPar.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
