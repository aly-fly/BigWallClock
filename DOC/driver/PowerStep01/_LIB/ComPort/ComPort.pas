unit ComPort;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TComPort = class(TObject)
  private
    ComID: Integer;
    ComError: Integer;
    DcbOld: TDCB;
    CommTimeoutsOld: TCommTimeouts;
  protected
  public
    function Open(PortName: string): Boolean;
    procedure Close;
    function Config(Baudrate: Cardinal; ByteSize, StopBits, Parity: Byte): Boolean;
    function ReadBlock(var Ch: array of char; BlockSize: Cardinal): Integer;
    function ReadChar(var Ch: Char): Boolean;
    function WriteBlock(var Ch: array of Char; BlockSize: Cardinal): Boolean;
    function SendString(Str: string): Boolean;
    function WriteChar(Ch: Char): boolean;
    procedure Purge;
    function Error: Integer;
    function IsOpen: Boolean;
    function IsConnected: Boolean;
    function cbInQue: Cardinal;
    constructor Create;
  published
  end;

const
  cpReadError  = 1;
  cpWriteError = 2;
  cpOpenError  = 3;

implementation

constructor TComPort.Create;
begin
  inherited Create;
  ComID := -1;
end;

function TComPort.Open(PortName: string): Boolean;
var
  CommTimeouts: TCommTimeouts;
  ComPortNameRBS: string;
begin
  if (ComID <> -1) then Close;
  ComPortNameRBS := '\\.\'+ AnsiToUtf8(PortName);              // ce je portnumber vec kot 9, rabi te crtice udspred
  ComID := CreateFile(pChar(ComPortNameRBS), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, 0, 0);
  if ComID <> -1 then
  begin
    GetCommState(ComID, DcbOld);
    GetCommTimeouts(ComID, CommTimeoutsOld);
    CommTimeouts.ReadIntervalTimeout := 1;
    CommTimeouts.ReadTotalTimeoutMultiplier := 1;
    CommTimeouts.ReadTotalTimeoutConstant := 1;
    CommTimeouts.WriteTotalTimeoutMultiplier := 10;
    CommTimeouts.WriteTotalTimeoutConstant := 10;
    SetCommTimeouts(ComID, CommTimeouts);
    ComError := 0;
  end
  else
    ComError := cpOpenError;
  Result := (ComID <> -1)
end;

procedure TComPort.Close;
begin
  if ComID <> -1 then
  begin
    SetCommState(ComID, DcbOld);
    SetCommTimeouts(ComID, CommTimeoutsOld);
    CloseHandle(ComID);
  end;
  ComID := -1;
end;

function TComPort.Config(Baudrate: Cardinal; ByteSize, StopBits, Parity: Byte): boolean;
var
  Dcb: TDCB;
begin
  if ComID <> -1 then
  begin
    GetCommState(ComID, Dcb);
    Dcb.Baudrate := Baudrate;
    Dcb.ByteSize := ByteSize;
    Dcb.StopBits := StopBits;
    Dcb.Parity := Parity;
    SetCommState(ComID, Dcb);
  end
  else
    ComError := cpOpenError;
  Result := (ComID <> -1)
end;

function TComPort.ReadBlock(var Ch: array of char; BlockSize: Cardinal): integer;
var
  rdBlockSize: Cardinal;
begin
  Result := 0;
  if ComID <> -1 then
  begin
    rdBlockSize := BlockSize;
    if not ReadFile(ComID, Ch, BlockSize, rdBlockSize, nil) then
    begin
      GetLastError;
      ComError := cpReadError;
    end
    else
      Result := rdBlockSize;
  end
  else
    ComError := cpOpenError;
end;

function TComPort.ReadChar(var Ch: Char): Boolean;
var
  BlockSize: Cardinal;
begin
  Result := False;
  if ComID <> -1 then
  begin
    if not ReadFile(ComID, Ch, 1, BlockSize, nil) then
    begin
      GetLastError;
      ComError := cpReadError;
    end
    else
      Result := (BlockSize = 1);
  end
  else
    ComError := cpOpenError;
end;

function TComPort.WriteBlock(var Ch: array of char; BlockSize: Cardinal): boolean;
var
  W: Cardinal;
begin
  Result := False;
  if ComID <> -1 then
  begin
    if not WriteFile(ComID, Ch, BlockSize, W, nil) then
    begin
      GetLastError;
      ComError := cpWriteError;
    end
    else
      Result := (BlockSize = W)
  end
  else
    ComError := cpOpenError;
end;

function TComPort.WriteChar(Ch: char): boolean;
var
  W: Cardinal;
begin
  Result := False;
  if ComID <> -1 then
  begin
    if not WriteFile(ComID, Ch, 1, W, nil) then
    begin
      GetLastError;
      ComError := cpWriteError;
    end
    else
      Result := (W = 1)
  end
  else
    ComError := cpOpenError;
end;

procedure TComPort.Purge;
begin
  if ComID <> -1 then
  begin
    PurgeComm(ComID, Purge_TXABORT);
    PurgeComm(ComID, Purge_RXABORT);
    PurgeComm(ComID, Purge_TXCLEAR);
    PurgeComm(ComID, Purge_RXCLEAR);
  end
  else
    ComError := cpOpenError;
end;

function TComPort.Error: Integer;
begin
  Result := ComError;
  ComError := 0;
end;

function TComPort.IsOpen: Boolean;
begin
  if ComID <> -1 then
    Result := True else Result := False;
end;

function TComPort.IsConnected: Boolean;
var
  MdmStat: Cardinal;
begin
  Result := False;
  if ComID <> -1 then
  begin
    GetCommModemStatus(ComID, MdmStat);
    if (MdmStat and EV_RLSD) <> 0 then Result := True;
  end;
end;

function TComPort.SendString(Str: string): Boolean;
var
  W: Cardinal;
  StrIn: RawByteString;
begin
  Result := False;
  if ComID <> -1 then
  begin
    StrIn := Str;
    if not WriteFile(ComID, PAnsiChar(StrIn)^, Length(StrIn), W, nil) then
    begin
      GetLastError;
      ComError := cpWriteError;
    end
    else
      Result := (Length(StrIn) = W);
  end else
    ComError := cpOpenError;
end;

function TComPort.cbInQue: Cardinal;
var
  CST: TComStat;
  Err: Cardinal;
begin
  Result := 0;
  ClearCommError(ComID, Err, @CST);
  Result := CST.cbInQue;
end;


end.

