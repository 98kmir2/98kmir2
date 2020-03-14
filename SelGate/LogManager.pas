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

procedure TLogMgr.Add(const szMsg: string);
var
  szTempMsg: string;
  nLen: Integer;
const
  FormatStr = '[%s] %s'#13#10;
begin
  szTempMsg := Format(FormatStr, [TimeToStr(Now), szMsg]);
  nLen := SendMessage(m_hWnd, WM_GETTEXTLENGTH, 0, 0);
  SendMessage(m_hWnd, EM_SETSEL, nLen, nLen + Length(szTempMsg));
  SendMessage(m_hWnd, EM_REPLACESEL, 1, LongInt(szTempMsg));
  SendMessage(m_hWnd, WM_VSCROLL, SB_LINEDOWN, 0);
end;

end.
