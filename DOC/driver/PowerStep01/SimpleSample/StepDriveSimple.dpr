program StepDriveSimple;

uses
  Vcl.Forms,
  StSpin in '..\_LIB\StSpin\StSpin.pas',
  ftd2xx in '..\_LIB\FTDI\ftd2xx.pas',
  LibFT4222 in '..\_LIB\FTDI\LibFT4222.pas',
  MahUSB in '..\_LIB\MahUSB\MahUSB.pas',
  ComPort in '..\_LIB\ComPort\ComPort.pas',
  StpTest_Main in 'StpTest_Main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
