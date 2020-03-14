unit LogDataMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, ExtCtrls, Controls,
  StdCtrls, Forms, Dialogs, IniFiles, NMUDP;
type
  TFrmLogData = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    TimerWriteLog: TTimer;
    NMUDP: TNMUDP;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerWriteLogTimer(Sender: TObject);
    procedure WriteLogFile();
    function IntToString(nInt: Integer): string;
    procedure NMUDPDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: string; Port: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    LogMsgList: TStringList;
    m_boRemoteClose: Boolean;
    { Private declarations }
  public
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    { Public declarations }
  end;

var
  FrmLogData: TFrmLogData;

implementation

uses LDShare, HUtil32, SDK;

{$R *.DFM}

procedure TFrmLogData.NMUDPDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: string; Port: Integer);
var
  MStream: TMemoryStream;
  s8: string;
begin
  try
    try
      MStream := TMemoryStream.Create;
      NMUDP.ReadStream(MStream);
      SetLength(s8, NumberBytes);
      MStream.Read(s8[1], NumberBytes);
      LogMsgList.Add(s8);
    finally
      MStream.Free;
    end;
  except
  end;
end;

procedure TFrmLogData.FormCreate(Sender: TObject);
var
  Conf: TIniFile;
  nX, nY: Integer;
begin
  g_dwGameCenterHandle := Str_ToInt(ParamStr(1), 0);
  nX := Str_ToInt(ParamStr(2), -1);
  nY := Str_ToInt(ParamStr(3), -1);
  if (nX >= 0) or (nY >= 0) then
  begin
    Left := nX;
    Top := nY;
  end;
  m_boRemoteClose := False;
  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(Self.Handle));
  SendGameCenterMsg(SG_STARTNOW, '正在启动日志服务器...');
  LogMsgList := TStringList.Create;
  Conf := TIniFile.Create('.\logdata.ini');
  if Conf <> nil then
  begin
    sBaseDir := Conf.ReadString('Setup', 'BaseDir', sBaseDir);
    sServerName := Conf.ReadString('Setup', 'Caption', sServerName);
    sServerName := Conf.ReadString('Setup', 'ServerName', sServerName);
    nServerPort := Conf.ReadInteger('Setup', 'Port', nServerPort);
    Conf.Free;
  end;
  Caption := sCaption + ' (' + sServerName + ')';
  NMUDP.LocalPort := nServerPort;
  SendGameCenterMsg(SG_STARTOK, '日志服务器启动完成...');
end;

procedure TFrmLogData.FormDestroy(Sender: TObject);
begin
  LogMsgList.Free;
end;

procedure TFrmLogData.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if m_boRemoteClose then
    exit;
  if Application.MessageBox('是否确认退出服务器？', '提示信息', MB_YESNO + MB_ICONQUESTION) = IDNO then
    CanClose := False;
end;

procedure TFrmLogData.TimerWriteLogTimer(Sender: TObject);
begin
  WriteLogFile();
end;

procedure TFrmLogData.WriteLogFile();
var
  I: Integer;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  sLogDir, sLogFile: string;
  s2E8: string;
  F: TextFile;
begin
  if LogMsgList.Count <= 0 then
    exit;
  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  sLogDir := sBaseDir + IntToStr(Year) + '-' + IntToString(Month) + '-' + IntToString(Day);
  if not FileExists(sLogDir) then
    CreateDirectoryA(PChar(sLogDir), nil);
  sLogFile := sLogDir + '\Log-' + IntToString(Hour) + 'h' + IntToString((Min div 10) * 2) + 'm.txt';
  Label4.Caption := sLogFile;
  try
    AssignFile(F, sLogFile);
    if not FileExists(sLogFile) then
      Rewrite(F)
    else
      Append(F);
    for I := 0 to LogMsgList.Count - 1 do
    begin
      Writeln(F, LogMsgList.Strings[I] + #9 + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now));
      Flush(F)
    end;
    LogMsgList.Clear;
  finally
    CloseFile(F);
  end;
end;

function TFrmLogData.IntToString(nInt: Integer): string;
begin
  if nInt < 10 then
    Result := '0' + IntToStr(nInt)
  else
    Result := IntToStr(nInt);
end;

procedure TFrmLogData.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  ProgramType: TProgamType;
  wIdent: Word;
begin
  wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    GS_QUIT:
      begin
        m_boRemoteClose := True;
        Close();
      end;
  end;
end;

end.
