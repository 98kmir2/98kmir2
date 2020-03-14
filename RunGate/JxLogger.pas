unit JxLogger;

interface

uses Windows, Classes, SysUtils, StdCtrls, ComCtrls, ComObj, Messages;

const
  WRITE_LOG_DIR = 'log\'; //记录日志默认目录
  BACK_LOG_DIR = 'log\back\'; //记录日志默认目录
  WRITE_LOG_MIN_LEVEL = 0; //记录日志的最低级别，小于此级别只显示不记录
  WRITE_LOG_ADD_TIME = True; //记录日志是否添加时间
  WRITE_LOG_TIME_FORMAT = 'hh:nn:ss.zzz'; //记录日志添加时间的格式
  LogDebugView = False;
  MAX_LOG_LINE = 1000; // 记录多少条之后保存到文件
type
  eLogLevel = (eInfo, eNotice, eWarnning, eDebug, eErr);
type TLogger = class
  private
    FCSLock: TRTLCriticalSection; //临界区
    FFileStream: TFileStream; //文件流
    FMemStream: TMemoryStream;
    FLogDir: AnsiString; //日志目录
    FLogName: AnsiString; //日志名称
    FSaveCount: Integer;
//    FSavespace: Cardinal;
//    FVCLZip: TVCLZip;
    FMaxWriteSize: Integer;
    FLastSave: Cardinal;
    procedure SavetoFile;
    procedure ZipLogfile;
  public
    procedure WriteLog(Log: AnsiString; const LogLevel: eLogLevel = eInfo);
      overload;
    procedure WriteLog(Log: AnsiString; const Args: array of const;
      const LogLevel: eLogLevel = eInfo); overload;
    constructor Create(LogDir: AnsiString);
    destructor Destroy; override;
  end;


var g_pJxLogger: TLogger;
implementation




uses VCLUnZip, VCLZip;

function ComPressFile(dstFile, srcFile: string): Boolean;
var
  vclzip: TVCLZip;
begin
  Result := False;
  vclzip := TVCLZip.create(nil);
  try
    with vclzip do
    begin
      try
        ZipName := dstFile;
        RecreateDirs := true; //注意这里
        StorePaths := False;
        FilesList.Add(srcFile);
        Recurse := True;
        Zip;
        Result := True;
      except
        Result := False;
        exit;
      end;
    end;
  finally
    vclzip.Free;
  end;
end;

function UnComPressFile(sFile, sOutFile: string): Boolean;
var
  vcluzip: TVCLUnZip;
begin
  Result := False;
  vcluzip := TVCLUnZip.Create(nil);
  try
    with vcluzip do
    begin
      try
        ZipName := sFile;
        ReadZip;
        FilesList.Add('*.*');
        DoAll := False;
        DestDir := sOutFile;
        RecreateDirs := False;
        RetainAttributes := True;
        Unzip;
        Result := True;
      except
        Result := False;
        exit;
      end;
    end;
  finally
    vcluzip.Free;
  end;
end;


constructor TLogger.Create(LogDir: AnsiString);
begin
  InitializeCriticalSection(FCSLock);
  if Trim(LogDir) = '' then
    FLogDir := ExtractFilePath(ParamStr(0)) + WRITE_LOG_DIR
  else
    FLogDir := LogDir;
  if not DirectoryExists(FLogDir) then
    if not ForceDirectories(FLogDir) then
    begin
      raise Exception.Create('日志路径错误，日志类对象不能被创建');
    end;
  FMemStream := TMemoryStream.Create();
  FMemStream.SetSize(1024 * 1024);
  FMaxWriteSize := FMemStream.Size * 8 div 10; //0.8
  FMemStream.Position := 0;

end;

procedure TLogger.WriteLog(Log: AnsiString; const Args: array of const;
  const LogLevel: eLogLevel = eInfo);
begin
  WriteLog(Format(Log, args), LogLevel);
end;



procedure TLogger.ZipLogfile;
var bakcpath: string;
  logpath: string;
begin

  bakcpath := ExtractFilePath(ParamStr(0)) + BACK_LOG_DIR;
  if not DirectoryExists(bakcpath) then
    if not ForceDirectories(bakcpath) then
    begin
      raise Exception.Create('日志路径错误，日志类对象不能被创建');
    end;
  bakcpath := bakcpath + FormatDateTime('yyyymmddhhnnss', Now) + '.zip';
  logpath := FLogDir + FLogName;
  ComPressFile(bakcpath, logpath);
  DeleteFile(logpath);

end;

procedure TLogger.WriteLog(Log: AnsiString; const LogLevel: eLogLevel = eInfo);
var
  logName: AnsiString;
  fMode: Word;
  slen: Integer;
begin
  EnterCriticalSection(FCSLock);
  try
    if ord(LogLevel) >= WRITE_LOG_MIN_LEVEL then
    begin
      case LogLevel of
        eInfo: Log := '[Information] ' + Log;
        eNotice: Log := '[Notice] ' + Log;
        eWarnning: Log := '[Warning] ' + Log;
        eDebug: Log := '[Debug] ' + Log;
        eErr: Log := '[Error] ' + Log;
      end;
      if LogDebugView then
      begin
        OutputDebugStringA(pchar(Log));
      end;

      if WRITE_LOG_ADD_TIME then
        Log := FormatDateTime(WRITE_LOG_TIME_FORMAT, Now) + ' ' + Log
          + #13#10;

      slen := StrLen(PAnsiChar(Log));

      if (slen + FMemStream.Position) > FMaxWriteSize then // 先强制保存
      begin
        FSaveCount := 100000; // 强制保存
        SavetoFile;
      end;
      FMemStream.Write(PAnsiChar(Log)^, slen);
      SavetoFile;
    end;
  finally
    LeaveCriticalSection(FCSLock);
  end;
end;


destructor TLogger.Destroy;
begin


  DeleteCriticalSection(FCSLock);
  FSaveCount := 100000;
  SavetoFile;
end;

procedure TLogger.SavetoFile;
var bSave: Boolean;
  dwcur: Cardinal;
  logName: AnsiString;
  fMode: Word;
  r: Integer;
begin
  Inc(FSaveCount);
  bSave := False;

  if FMemStream.Position > FMaxWriteSize then
    bSave := True;
  if FSaveCount > 1000 then
    bSave := True;
  if (dwcur - FLastSave) > 1000 * 60 * 5 then
    bSave := True;
  if True then
  begin
    FSaveCount := 0;
    FLastSave := dwcur;

    logName := FormatDateTime('yyyymmdd', Now) + '.log';
    if FLogName <> logName then
      FLogName := logName;
    if FileExists(FLogDir + FLogName) then //如果当天的日志文件存在
      fMode := fmOpenWrite or fmShareDenyNone
    else
      fMode := fmCreate or fmShareDenyNone;

    FFileStream := TFileStream.Create(FLogDir + FLogName, fmode);
    FFileStream.Position := FFileStream.Size; //追加到最后


    FFileStream.Write(FMemStream.Memory^, FMemStream.Position);
    FMemStream.Position := 0;

    if FFileStream.Size > 1024 * 1024 * 50 then
    begin
      FreeAndNil(FFileStream);
      ZipLogfile;
    end;
    FreeAndNil(FFileStream);
  end;


end;


initialization
  g_pJxLogger := TLogger.Create('');
end.
