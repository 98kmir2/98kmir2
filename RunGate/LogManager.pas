unit LogManager;

interface

uses
  Windows, Messages, SysUtils;

type
  TLogMgr = class
    m_hWnd: HWND;
  public
    constructor Create(nWnd: HWND);
    destructor Destroy; override;
    function CheckLevel(const nShowLv: Integer): Boolean;
    procedure Add(const szMsg: string);
    procedure AddLogFile(const szMsg: string);
  end;

var
  g_pLogMgr: TLogMgr;

implementation

uses
  Protocol, ConfigManager;

constructor TLogMgr.Create(nWnd: HWND);
begin
  m_hWnd := nWnd;
end;

destructor TLogMgr.Destroy;
begin
  inherited;
end;

function TLogMgr.CheckLevel(const nShowLv: Integer): Boolean;
begin
  Result := g_pConfig.m_nShowLogLevel >= nShowLv;
end;

procedure TLogMgr.AddLogFile(const szMsg: string);
const
  g_szDebugFileName = '.\Log.txt';
var
  fhandle: TextFile;
begin
  AssignFile(fhandle, g_szDebugFileName);
  if FileExists(g_szDebugFileName) then
  begin
    Append(fhandle);
  end
  else
  begin
    Rewrite(fhandle);
  end;
  Writeln(fhandle, szMsg);
  CloseFile(fhandle);
end;

procedure TLogMgr.Add(const szMsg: string);
var
  szTempMsg, szTempMsg2: string;
  nLen: Integer;
const
  FormatStr = '[%s] %s'#13#10;
  FormatStr2 = '[%s] %s';
begin
  szTempMsg := Format(FormatStr, [TimeToStr(Now), szMsg]);
  if g_pConfig.m_fAddLog then
  begin
    szTempMsg2 := Format(FormatStr2, [TimeToStr(Now), szMsg]);
    AddLogFile(szTempMsg2);
  end;
  nLen := SendMessage(m_hWnd, WM_GETTEXTLENGTH, 0, 0);
  SendMessage(m_hWnd, EM_SETSEL, nLen, nLen + Length(szTempMsg));
  SendMessage(m_hWnd, EM_REPLACESEL, 1, LongInt(szTempMsg));
  SendMessage(m_hWnd, WM_VSCROLL, SB_LINEDOWN, 0);
end;

end.
