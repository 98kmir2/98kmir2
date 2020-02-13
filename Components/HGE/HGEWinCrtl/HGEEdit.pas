unit HGEEdit;

interface

uses
  Windows, Messages, HGE, HGEGUI, HGEFont, HGEColor, HGESprite, HGERect;

const
  COOKIE_SIZE               = 1024;

type
  tagDeletePos = (DP_LEFT, DP_RIGHT);
  TDP = tagDeletePos;

  IHGEGUIEdit = interface(IHGEGUIObject)
    ['{F99C1E65-DBCD-4C31-AAF6-87D28E4C1601}']
    procedure ClearCookie();            // 清除编辑框内容
    procedure InsertCookie(const lpCookie: string); // 插入字符串到编辑框当前光标处
    function GetCookie(): string;       // 获取编辑框当前内容
    procedure InsertCookieW(const lpCookie: PWideChar); // 插入字符串到编辑框当前光标处(宽字符模式)
    function GetCookieW(): PWideChar;   // 获取编辑框当前内容(宽字符模式)
    { No new public functionality }
  end;

  THGEGUIEdit = class(THGEGUIObject, IHGEGUIEdit)
    m_sCookie: array[0..COOKIE_SIZE - 1] of WideChar;
    m_nEditW: Single;
    m_nEditH: Single;
    m_nCharPos: UINT;                   // 字符位置
    m_pSprite: IHGESprite;              // 光标精灵
    m_pFont: IHGEFont;                  // 字体精灵
    m_Focus: Boolean;
    m_Scale: Single;
    m_Left: Single;
    m_Top: Single;
    m_bBlink: Boolean;
    m_fTime: Single;
    m_bComposition: Boolean;
    m_szImeChar: array[0..2] of Char;
  protected
    { IHGEGUIObject}
    procedure Render; override;
    procedure Update(const DT: Single); override;
    procedure Enter; override;          //进入
    procedure Leave; override;          //出去
    procedure Focus(const Focused: Boolean); override;
    procedure MouseOver(const Over: Boolean); override;
    function MouseLButton(const Down: Boolean): Boolean; override;

    procedure ClearCookie();            // 清除编辑框内容

    procedure InsertCookie(const lpCookie: string); // 插入字符串到编辑框当前光标处
    function GetCookie(): string;       // 获取编辑框当前内容
    procedure InsertCookieW(const lpCookie: PWideChar); // 插入字符串到编辑框当前光标处(宽字符模式)
    function GetCookieW(): PWideChar;   // 获取编辑框当前内容(宽字符模式)

  public
    ///
    /// nEditWidth		编辑框宽度
    ///	nFontColor		字体颜色
    /// lpFont    		字体
    ///	nFontSize		  字体大小
    /// bBold			    是否粗体
    /// bItalic			  是否斜体
    /// bAntialias		是否平滑
    ///
    constructor Create(const AId: Integer; nEditWidth: UINT; nFontColor: DWORD; const lpFontName: string = '宋体';
      nFontSize: UINT = 12; bBold: Boolean = FALSE; bItalic: Boolean = FALSE; bAntialias: Boolean = TRUE); overload;
    constructor Create(const AId: Integer; nEditWidth: UINT; nFontColor: DWORD; const AFont: IHGEFont; nFontSize: UINT = 12); overload;
    destructor Destroy; override;
    procedure SetFocus();               // 设置编辑框焦点，只有拥有编辑框焦点才能响应输入
    procedure KillFocus();              // 清除编辑框焦点，失去编辑框焦点后将不再响应输入

  private
  class var
      m_pHGE                : IHGE;
function OnKey(nKey, nRepCnt, nFlags: UINT): Boolean;
procedure OnChar(nChar, nRepCnt, nFlags: UINT);
procedure InsertChar(aChar: WideChar);
procedure DeleteChar(aPos: TDP);

    end;

  type
    TWndProc = function(HWindow: HWnd; Msg, WParam, LParam: Longint): Longint; stdcall;

  var
    g_lpLastHgeWndProc      : Integer = 0;
    g_lpFocusEditPtr        : THGEGUIEdit = nil;

implementation

function WStrEnd(Str: PWideChar): PWideChar;
begin
  Result := Str;
  while Result^ <> #0 do
    Inc(Result);
end;

function WStrLen(Str: PWideChar): Cardinal;
begin
  Result := WStrEnd(Str) - Str;
end;

function GfxEditWndProc(HWindow: HWnd; nMsg, WParam, LParam: Longint): Longint; stdcall;
var
  aMsg                      : TMsg;
begin
  if (WM_KEYDOWN = nMsg) or (WM_KEYUP = nMsg) then begin
    FillChar(aMsg, sizeof(TMsg), 0);
    aMsg.HWnd := HWindow;
    aMsg.message := nMsg;
    aMsg.WParam := WParam;
    aMsg.LParam := LParam;
    aMsg.time := GetTickCount();
    TranslateMessage(aMsg);

    if (g_lpFocusEditPtr <> nil) and (WM_KEYDOWN = nMsg) then begin
      case WParam of
        VK_DELETE,                      //key delete
        VK_LEFT,                        //key left
        VK_RIGHT,                       //key right
        VK_HOME,                        //key home
        VK_END:                         //key end
          g_lpFocusEditPtr.OnKey(WParam, LOWORD(LParam), HIWORD(LParam));
      end;
    end;
  end else
    if (WM_CHAR = nMsg) or (WM_IME_CHAR = nMsg) then begin
      if (g_lpFocusEditPtr <> nil) then begin
        g_lpFocusEditPtr.OnChar(WParam, LOWORD(LParam), HIWORD(LParam));
        Result := 1;
        Exit;
      end;
    end;
  if g_lpLastHgeWndProc <> 0 then
    Result := TWndProc(g_lpLastHgeWndProc)(HWindow, nMsg, WParam, LParam)
  else Result := 1;

end;

{ THGEGUI Edit }

constructor THGEGUIEdit.Create(const AId: Integer; nEditWidth: UINT; nFontColor: DWORD;
  const AFont: IHGEFont; nFontSize: UINT);
var
  nWnd                      : HWnd;
begin
  inherited Create;
  m_pHGE := HGECreate(HGE_VERSION);
  if (m_pHGE = nil) then begin
    Free;
    Exit;
  end;

  nWnd := m_pHGE.System_GetState(HGE_HWND);
  if (nWnd = 0) then begin
    Free;
    Exit;
  end;
  if not (g_lpLastHgeWndProc <> 0) then begin
    g_lpLastHgeWndProc := GetWindowLong(nWnd, GWL_WNDPROC);
    if g_lpLastHgeWndProc <> SetWindowLong(nWnd, GWL_WNDPROC, Longint(@GfxEditWndProc)) then begin
      Free;
      Exit;
    end;
  end;

  Id := AId;
  IsStatic := FALSE;
  Visible := TRUE;
  Enabled := TRUE;
  Rect.SetRect(0, 0, 0, 0);

  if nEditWidth = 0 then
    nEditWidth := 1;
  if nFontSize = 0 then
    nFontSize := 12;

  m_nEditW := nEditWidth;
  m_nEditH := nFontSize;

  m_pSprite := THGESprite.Create(nil, 0, 0, 3, m_nEditH);
  m_pSprite.SetColor($FFFF00FF);
  m_pFont := AFont;
  if (m_pFont = nil) then
    Free;
  m_pFont.SetScale(nFontSize / m_pFont.GetHeight);
  m_pFont.SetColor(nFontColor);
  m_nCharPos := 0;
  m_Left := 110;
  m_Top := 110;
  m_fTime := 0;
  m_bBlink := FALSE;
  m_bComposition := FALSE;
  m_szImeChar[0] := #0;
  m_szImeChar[1] := #0;
  m_szImeChar[2] := #0;
  ClearCookie();
end;

constructor THGEGUIEdit.Create(const AId: Integer; nEditWidth: UINT; nFontColor: DWORD;
  const lpFontName: string; nFontSize: UINT; bBold: Boolean; bItalic: Boolean; bAntialias: Boolean);
var
  nWnd                      : HWnd;
begin
  inherited Create;
  m_pHGE := HGECreate(HGE_VERSION);
  if (m_pHGE = nil) then begin
    Free;
    Exit;
  end;

  nWnd := m_pHGE.System_GetState(HGE_HWND);
  if (nWnd = 0) then begin
    Free;
    Exit;
  end;
  if not (g_lpLastHgeWndProc <> 0) then begin
    g_lpLastHgeWndProc := GetWindowLong(nWnd, GWL_WNDPROC);
    if g_lpLastHgeWndProc <> SetWindowLong(nWnd, GWL_WNDPROC, Longint(@GfxEditWndProc)) then begin
      Free;
      Exit;
    end;
  end;

  Id := AId;
  IsStatic := FALSE;
  Visible := TRUE;
  Enabled := TRUE;
  Rect.SetRect(0, 0, 0, 0);
  m_Scale := 1.0;
  if nEditWidth = 0 then
    nEditWidth := 1;
  if nFontSize = 0 then
    nFontSize := 12;

  m_nEditW := nEditWidth;
  m_nEditH := nFontSize;

  m_pSprite := THGESprite.Create(nil, 0, 0, 1, m_nEditH);
  m_pSprite.SetColor($FFFF00FF);
  m_pFont := THGEFont.Create(lpFontName, nFontSize, bBold, bItalic, bAntialias);
  if (m_pFont = nil) then begin
    Free;
    Exit;
  end;

  m_pFont.SetColor(nFontColor);
  m_nCharPos := 0;
  m_Left := 0;
  m_Top := 0;
  m_fTime := 0;
  m_bBlink := FALSE;
  m_bComposition := FALSE;
  m_szImeChar[0] := #0;
  m_szImeChar[1] := #0;
  m_szImeChar[2] := #0;
  ClearCookie();
end;

destructor THGEGUIEdit.Destroy;
begin
  m_pSprite := nil;
  m_pFont := nil;
  inherited;
end;

procedure THGEGUIEdit.ClearCookie;
begin
  FillChar(m_sCookie, COOKIE_SIZE, 0);
  m_nCharPos := 0;
end;

function THGEGUIEdit.GetCookie: string;
begin
  Result := WideCharToString(m_sCookie);
end;

procedure THGEGUIEdit.InsertCookieW(const lpCookie: PWideChar);
var
  I                         : Integer;
  P                         : PWideChar;
begin
  P := lpCookie;
  if (P <> '') then begin
    while (P^ <> #0) do begin
      InsertChar(P^);
      Inc(P);
    end;
  end;
end;

procedure THGEGUIEdit.InsertCookie(const lpCookie: string);
var
  pwc                       : PWideChar;
begin
  GetMem(pwc, Length(lpCookie) * sizeof(PWideChar) + 1);
  try
    StringToWideChar(lpCookie, pwc, Length(lpCookie) * sizeof(WideChar) + 1);
    InsertCookieW(pwc);
  finally
    FreeMem(pwc);
  end;
end;

function THGEGUIEdit.GetCookieW: PWideChar;
begin
  Result := m_sCookie;
end;

procedure THGEGUIEdit.Update(const DT: Single);
var
  mouse_x                   : Single;
  mouse_y                   : Single;
begin
  inherited;
  mouse_x := 0;
  mouse_y := 0;
  m_pHGE.Input_GetMousePos(mouse_x, mouse_y);
  if (m_pHGE.Input_GetKeyState(HGEK_LBUTTON)) then begin
    if (Rect.TextPoint(mouse_x, mouse_y)) then begin
      SetFocus();
    end else KillFocus;
  end;
  if (m_Focus) then begin
    m_fTime := m_fTime + DT;
    if (m_fTime > 0.5) then begin
      m_fTime := 0;
      m_bBlink := not m_bBlink;
    end;
  end;

end;

procedure THGEGUIEdit.Render;
var
  x, y                      : Single;
  box_x                     : Single;
  box_y                     : Single;
  box_w                     : Single;
  box_h                     : Single;
  text_x                    : Single;
  text_y                    : Single;
  char_x                    : Single;
  char_y                    : Single;
  tmp_w                     : Single;
  clip_x                    : Integer;
  clip_y                    : Integer;
  clip_w                    : Integer;
  clip_h                    : Integer;
  Str, st3                  : string;
  P                         : array[0..COOKIE_SIZE - 1] of WideChar;

begin
  inherited;
  x := m_Left;
  y := m_Top;
  box_x := x - 1;
  box_y := y - 1;
  box_w := m_nEditW + 2;
  box_h := m_nEditH + 2;

  // 外框
  m_pHGE.Gfx_RenderLine(box_x, box_y, box_x + box_w, box_y);
  m_pHGE.Gfx_RenderLine(box_x, box_y, box_x, box_y + box_h);
  m_pHGE.Gfx_RenderLine(box_x + box_w, box_y + box_h, box_x + box_w, box_y);
  m_pHGE.Gfx_RenderLine(box_x + box_w, box_y + box_h, box_x, box_y + box_h);

  // 保存编辑框区域
  Rect.SetRect(x, y, x + m_nEditW, y + m_nEditH);

  text_x := x;
  text_y := y;
  char_x := x;
  char_y := y;
  Str := WideCharToString(m_sCookie);
  if (m_nCharPos > 0) then begin
    FillChar(P, sizeof(P), 0);
    Move(m_sCookie[0], P[0], m_nCharPos * sizeof(WideChar));
    st3 := WideCharToString(P);
    tmp_w := m_pFont.GetStringWidth(st3);

    if (tmp_w > m_nEditW) then begin
      text_x := text_x - (tmp_w - m_nEditW);
    end;
    char_x := text_x + tmp_w;
  end;

  clip_x := Round(box_x);
  clip_y := Round(box_y);
  clip_w := Round(box_w);
  clip_h := Round(box_h);

  m_pHGE.Gfx_SetClipping(clip_x, clip_y, clip_w, clip_h);
  m_pFont.Render(text_x, text_y, HGETEXT_LEFT, Str);
  if m_Focus and m_bBlink then
    m_pSprite.Render(char_x, char_y);
  m_pHGE.Gfx_SetClipping();
end;

function THGEGUIEdit.OnKey(nKey, nRepCnt, nFlags: UINT): Boolean;
begin
  Result := FALSE;
  if (VK_DELETE = nKey) then begin      // key delete
    DeleteChar(DP_RIGHT);
    m_bBlink := TRUE;
    m_fTime := 0;
    Result := TRUE;
  end else if (VK_HOME = nKey) then begin
    m_nCharPos := 0;
    m_bBlink := TRUE;
    m_fTime := 0;
    Result := TRUE;
  end else if (VK_END = nKey) then begin
    m_nCharPos := WStrLen(m_sCookie);
    Result := TRUE;
  end else if (VK_LEFT = nKey) then begin // key left
    if (m_nCharPos > 0) then begin
      Dec(m_nCharPos);
      m_bBlink := TRUE;
      m_fTime := 0;
    end;
    Result := TRUE;
  end else if (VK_RIGHT = nKey) then begin // key right
    if (m_nCharPos < WStrLen(m_sCookie)) then begin
      Inc(m_nCharPos);
      m_bBlink := TRUE;
      m_fTime := 0;
    end;
    Result := TRUE;
  end;
end;

procedure THGEGUIEdit.OnChar(nChar, nRepCnt, nFlags: UINT);
var
  I                         : Integer;
  wstr                      : PWideChar;
begin
  if (nChar = 0) then Exit;
  if (VK_RETURN = nChar) then           // key enter

  else if (VK_ESCAPE = nChar) then      // key enter

  else if (VK_TAB = nChar) then begin   // key tab
    for I := 0 to 8 - 1 do
      InsertChar(' ');                  // insert 7 space
    m_bBlink := TRUE;
    m_fTime := 0;
  end
  else if (VK_BACK = nChar) then begin  // key back space
    DeleteChar(DP_LEFT);
    m_bBlink := TRUE;
    m_fTime := 0;
  end else begin
    if (m_nCharPos < COOKIE_SIZE) then begin
      m_bBlink := TRUE;
      m_fTime := 0;
      if (nChar < 128) then begin
        m_szImeChar[0] := Char(nChar);
        m_szImeChar[1] := #0;
        m_bComposition := FALSE;
      end else begin
        if nChar > 255 then begin
          m_szImeChar[0] := Char(nChar shr 8);
          m_szImeChar[1] := Char(nChar);
          m_bComposition := FALSE;
        end else begin
          if not m_bComposition then
            m_szImeChar[0] := Char(nChar)
          else m_szImeChar[1] := Char(nChar);
          m_bComposition := not m_bComposition;
        end;
        m_szImeChar[2] := #0;
        if m_bComposition then Exit;
      end;
      GetMem(wstr, 4);
      try
        StringToWideChar(m_szImeChar, wstr, 4);
        InsertChar(wstr^);
      finally
        FreeMem(wstr);
      end;
    end;
  end;
end;

procedure THGEGUIEdit.InsertChar(aChar: WideChar);
var
  nLen                      : UINT;
begin
  if aChar <> #0 then begin
    nLen := WStrLen(m_sCookie);
    if (m_nCharPos < nLen) then begin
      while (m_nCharPos < nLen) do begin
        m_sCookie[nLen] := m_sCookie[nLen - 1];
        Dec(nLen);
      end;
    end;
    m_sCookie[m_nCharPos] := aChar;
    Inc(m_nCharPos);
  end;
end;

procedure THGEGUIEdit.DeleteChar(aPos: TDP);
var
  nIndex                    : UINT;
begin
  if (DP_LEFT = aPos) then begin
    if (m_nCharPos = 0) then
      Exit;
    Dec(m_nCharPos);
  end else if (DP_RIGHT = aPos) then begin
    if (m_nCharPos = WStrLen(m_sCookie)) then
      Exit;
  end else
    Exit;

  nIndex := m_nCharPos;
  while (m_sCookie[nIndex] <> #0) do begin
    m_sCookie[nIndex] := m_sCookie[nIndex + 1];
    Inc(nIndex);
  end;
end;

procedure THGEGUIEdit.SetFocus;
begin
  m_Focus := TRUE;
  g_lpFocusEditPtr := Self;
end;

procedure THGEGUIEdit.KillFocus;
begin
  m_Focus := FALSE;
  if (g_lpFocusEditPtr <> nil) and (g_lpFocusEditPtr = Self) then
    g_lpFocusEditPtr := nil;
end;

procedure THGEGUIEdit.Leave;
begin
  inherited;

end;

procedure THGEGUIEdit.Enter;
begin
  inherited;

end;

procedure THGEGUIEdit.Focus(const Focused: Boolean);
begin
  inherited;
  if Focused then
    SetFocus
  else KillFocus;
end;

function THGEGUIEdit.MouseLButton(const Down: Boolean): Boolean;
begin
  if (not Down) then begin
    Result := TRUE;
  end else begin
    Result := FALSE;
  end;
end;

// This method is called to notify the control
// that the mouse cursor has entered or left it's area

procedure THGEGUIEdit.MouseOver(const Over: Boolean);
begin
  inherited;
  if (Over) then
    GUI.SetFocus(Id);
end;

end.

