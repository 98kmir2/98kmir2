unit DrawScrn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StrUtils, MShare,
  DXDraws, DXClass, DirectX, IntroScn, HumanActor, Actor, cliUtil, ClFunc, HUtil32, GList, DxHint;

const
  USECENTERMAG = True;
  MAXSYSLINE = 8;
  AREASTATEICONBASE = 150;
  HEALTHBAR_BLACK = 0;
  HEALTHBAR_RED = 1;
 

type
{$IF not NEWHINTSYS}
  THintMgr = class
  public
    HintIdx: Integer;
    FirstHint: Boolean;
    HintList: TStringList;
    HintColorList: TStringList;
    HintFontList: TStringList;
    HintX, HintY, HintWidth, HintHeight: Integer;
    HintLines: Boolean;
    HintBold: Boolean;
    HintUp: Boolean;
    HintLeft: Boolean;
    HintColor: TColor;
    HintTakeOn: Boolean;
    constructor Create;
    destructor Destroy; override;
    function ShowHint(X, Y: Integer;
      Str: string;
      Color: TColor;
      drawup: Boolean;
      drawLeft: Boolean = False;
      bfh: Boolean = False;
      Lines: Boolean = False;
      TakeOn: Boolean = False): Integer;
    procedure ClearHint;
    procedure DrawHint(MSurface: TDirectDrawSurface);
  end;
{$IFEND NEWHINTSYS}

  TDrawScreen = class
  private
    m_dwFrameTime: LongWord;
    m_dwFrameCount: LongWord;
    m_SysMsgList: TStringList;
    m_SysMsgListEx: TStringList;
    m_SysMsgListEx2: TStringList;
  public
    CurrentScene: TScene;
    ChatStrs: TStringList;
    ChatBks: TList;
    ChatBoardTop: Integer;

    m_adList, m_adList2: TStringList;
{$IFDEF OPENCENTERMAG}
{$IF USECENTERMAG}
    m_smListCnt: TGList;
    m_smListCntFree: TGList;
{$ELSE}
    m_smListCnt: TStringList;
    m_smListBkc: TList;
    m_smListSec: TList;
    m_smListNow: TList;
{$IFEND}
{$ENDIF OPENCENTERMAG}

{$IF NEWHINTSYS}
    m_Hint1: TDxHintMgr;
    m_Hint2: TDxHintMgr;
    m_Hint3: TDxHintMgr;
{$ELSE}
    m_Hint1: THintMgr;
    m_Hint2: THintMgr;
    m_Hint3: THintMgr;
{$IFEND NEWHINTSYS}
    constructor Create;
    destructor Destroy; override;
    procedure KeyPress(var Key: Char);
    procedure KeyDown(var Key: Word; Shift: TShiftState);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Initialize;
    procedure Finalize;
    procedure ChangeScene(scenetype: TSceneType);
    procedure DrawScreen(MSurface: TDirectDrawSurface);
    procedure DrawScreenTop(MSurface: TDirectDrawSurface);
    procedure DrawScreenBottom(MSurface: TDirectDrawSurface);
{$IFDEF OPENCENTERMAG}
    procedure DrawScreenCenter(MSurface: TDirectDrawSurface);
{$ENDIF OPENCENTERMAG}
    procedure AddSysMsg(Msg: string);
    procedure AddSysMsgBottom(Msg: string);
    procedure AddSysMsgBottom2(Msg: string);

{$IFDEF OPENCENTERMAG}
    procedure AddSysMsgCenter(Msg: string; fc, bc, sec: Integer);
{$ENDIF OPENCENTERMAG}

    procedure AddChatBoardString(Str: string; fcolor, bcolor: Integer);
    procedure ClearChatBoard;

    function ShowHint(X, Y: Integer;
      Str: string;
      Color: TColor;
      drawup: Boolean;
      drawLeft: Boolean = False;
      bfh: Boolean = False;
      Lines: Boolean = False;
      mgr: Byte = 1;
      TakeOn: Boolean = False): Integer;
    procedure ClearHint;
    procedure DrawHint(MSurface: TDirectDrawSurface);
  end;

implementation

uses
  ClMain, FState, Grobal2;

{$IF not NEWHINTSYS}

constructor THintMgr.Create;
begin
  HintList := TStringList.Create;
  HintColorList := TStringList.Create;
  //HintImageList := TStringList.Create;
  HintFontList := TStringList.Create;
end;

destructor THintMgr.Destroy;
begin
  HintList.Free;
  HintColorList.Free;
  HintFontList.Free;
  //HintImageList.Free;
  inherited Destroy;
end;

function THintMgr.ShowHint(X, Y: Integer; Str: string; Color: TColor; drawup: Boolean; drawLeft: Boolean; bfh: Boolean; Lines: Boolean; TakeOn: Boolean): Integer;
var
  b: Boolean;
  cl: TColor;
  scl, data: string;
  i, w, h, j: Integer;
begin
  Result := 0;
  ClearHint;
  HintX := X;
  HintY := Y;
  HintWidth := 0;
  HintHeight := 0;
  HintBold := bfh;
  HintLines := Lines;
  HintTakeOn := TakeOn;
  HintUp := drawup;
  HintLeft := drawLeft;
  HintColor := Color;
  i := 0;
  while True do
  begin
    if Str = '' then
      Break;
    Str := GetValidStr3(Str, data, ['\']);
    cl := Color;
    j := Pos('COLOR=', UpperCase(data));
    if j > 0 then
    begin
      data := GetValidStr3(data, scl, [' ', #9, ',']);
      scl := Copy(scl, 7, Length(scl) - 6);
      if scl <> '' then
      begin
        if scl[1] = '#' then
          cl := StrToInt(Copy(scl, 2, Length(scl) - 1))
        else if CompareText('clLtGray', scl) = 0 then
          cl := clLtGray
        else if CompareText('clDkGray', scl) = 0 then
          cl := clDkGray
        else
          cl := StringToColor(scl);
      end;
      if (i = 0) and (HintBold) then
        w := frmMain.Canvas.TextWidth(data) + 8 + Length(data) * 3
      else
        w := frmMain.Canvas.TextWidth(data) + 8;
    end
    else
      w := frmMain.Canvas.TextWidth(data) + 8;
    if w > HintWidth then
      HintWidth := w;

    if data <> '' then
    begin
      HintList.Add(data);
      //if cl <> HintColor then
      HintColorList.AddObject('', TObject(cl));
      if (i = 0) and (HintBold) then
        HintFontList.AddObject('', TObject(1))
      else
        HintFontList.AddObject('', TObject(0));
    end;
    Inc(i);
  end;
  if HintLines and (HintWidth <> 148) then
    HintWidth := 148;
  HintHeight := (frmMain.Canvas.TextHeight('A') + 2) * HintList.Count + 3 * 2 + Integer(HintBold) * 12;
  Result := HintHeight;
  if HintUp then
    HintY := HintY - HintHeight;
  if HintLeft then
    HintX := HintX - HintWidth;
end;

procedure THintMgr.ClearHint;
begin
  if HintList.Count > 0 then
    HintList.Clear;
  if HintColorList.Count > 0 then
    HintColorList.Clear;
  if HintFontList.Count > 0 then
    HintFontList.Clear;
end;

procedure THintMgr.DrawHint(MSurface: TDirectDrawSurface);
var
  cl, ncl: TColor;
  d, dd: TDirectDrawSurface;
  i, n, hx, hy, old: Integer;
  Str: string;
  rc: TRect;
  b1, b2: Boolean;
begin
  hx := 0;
  hy := 0;
  if HintList.Count > 0 then
  begin
    if HintColor <> clBlack then
    begin
{$IF MIR2EX}
      if HintLines or HintBold then
      begin
        if HintTakeOn then
          d := g_HintSurface_Olive
        else
          d := g_HintSurface_B
      end
      else
        d := g_WMainImages.Images[394]; //g_HintSurface_B
{$ELSE}
      d := g_WMainImages.Images[394];
{$IFEND}
      if d = nil then
        Exit;

      if HintWidth > d.Width then
        HintWidth := d.Width;

      if HintHeight > d.Height then
        HintHeight := d.Height;

      if HintX + HintWidth > SCREENWIDTH then
        hx := SCREENWIDTH - HintWidth
      else
        hx := HintX;

      if HintY < 0 then
        hy := 0
      else
        hy := HintY;

      if hx < 0 then
        hx := 0;

      DrawBlend_Mix(MSurface, hx, hy, d, 0, 0, HintWidth, HintHeight, 0);

      if HintLines then
        with MSurface.Canvas do
        begin

          Pen.Color := GetRGB(85);
          MoveTo(hx - 1, hy);
          LineTo(hx + HintWidth, hy);
          LineTo(hx + HintWidth, hy + HintHeight);
          LineTo(hx - 1, hy + HintHeight);
          LineTo(hx - 1, hy);

          Pen.Color := GetRGB(87);
          MoveTo(hx - 2, hy - 1);
          LineTo(hx + HintWidth + 1, hy - 1);
          LineTo(hx + HintWidth + 1, hy + HintHeight + 1);
          LineTo(hx - 2, hy + HintHeight + 1);
          LineTo(hx - 2, hy - 1);

          Pen.Color := GetRGB(84);
          MoveTo(hx - 3, hy - 2);
          LineTo(hx + HintWidth + 2, hy - 2);
          LineTo(hx + HintWidth + 2, hy + HintHeight + 2);
          LineTo(hx - 3, hy + HintHeight + 2);
          LineTo(hx - 3, hy - 2);
          Release;
        end;

      b1 := False;
      b2 := False;
      for i := 0 to HintList.Count - 1 do
      begin
        cl := HintColor;
        if i < HintColorList.Count then
          cl := TColor(HintColorList.Objects[i]);

        if (i = 0) and (i < HintFontList.Count) and (Integer(HintFontList.Objects[i]) <> 0) then
        begin

          ncl := cl div High(Word);
          cl := cl mod High(Word);

          old := MSurface.Canvas.Font.Size;
          MSurface.Canvas.Font.Size := 10;
          try
            BoldTextOut(MSurface, hx + 4, hy + 4 + (MSurface.Canvas.TextHeight('A', False) + 2) * i, clWhite, clBlack, HintList[i], 2);
            Inc(hy, 8); // +15  +8
            with MSurface.Canvas do
            begin
              Pen.Color := clGray;
              MoveTo(hx + 4, hy + 3 + 10);
              LineTo(hx + HintWidth - 4, hy + 3 + 10);

              Pen.Color := GetRGB(0);
              MoveTo(hx + 4, hy + 4 + 10);
              LineTo(hx + HintWidth - 4, hy + 4 + 10);
              Release;
            end;

          finally
            MSurface.Canvas.Font.Size := old;
          end;
          //end;
        end
        else
        begin
          if not b1 and (cl = GetLevelColor(3)) then
          begin
            b1 := True;
            n := hy + (MSurface.Canvas.TextHeight('A', False) + 2) * i - 4;
            with MSurface.Canvas do
            begin
              Pen.Color := clGray;
              MoveTo(hx + 4, n - 1 + 10);
              LineTo(hx + HintWidth - 4, n - 1 + 10);

              Pen.Color := GetRGB(0);
              MoveTo(hx + 4, n + 10);
              LineTo(hx + HintWidth - 4, n + 10);
              Release;
            end;
          end;
          BoldTextOut(MSurface, hx + 4, Byte(b1) * 6 + hy + 4 + (MSurface.Canvas.TextHeight('A', False) + 2) * i, cl, clBlack, HintList[i]);

          {if b1 and not b2 and (cl = GetLevelColor(3)) then begin
            b2 := True;
            n := hy + (MSurface.Canvas.TextHeight('A', False) + 2) * i - 4;
            with MSurface.Canvas do begin
              Pen.Color := clGray;
              MoveTo(hx + 4, n - 1 + 10);
              LineTo(hx + HintWidth - 4, n - 1 + 10);

              Pen.Color := GetRGB(0);
              MoveTo(hx + 4, n + 10);
              LineTo(hx + HintWidth - 4, n + 10);
              Release;
            end;
          end;
          BoldTextOut(MSurface, hx + 4, Byte(b2) * 6 + Byte(b1) * 6 + hy + 4 + (MSurface.Canvas.TextHeight('A', False) + 2) * i, cl, clBlack, HintList[i]);
          }
        end;

      end;
    end
    else
    begin

{$IF MIR2EX}
      d := g_HintSurface_Y;
{$ELSE}
      d := g_HintSurface_Y;
{$IFEND}
      if d = nil then
        Exit;

      if HintWidth > d.Width then
        HintWidth := d.Width;

      if HintHeight > d.Height then
        HintHeight := d.Height;

      if HintX + HintWidth > SCREENWIDTH then
        hx := SCREENWIDTH - HintWidth
      else
        hx := HintX;

      if HintY < 0 then
        hy := 0
      else
        hy := HintY;

      if hx < 0 then
        hx := 0;

      rc := d.ClientRect;
      rc.Right := rc.Left + HintWidth;
      rc.Bottom := rc.Top + HintHeight;
      MSurface.Draw(hx, hy, rc, d, True);

      with MSurface.Canvas do
      begin
        Pen.Color := 0;
        MoveTo(hx - 1, hy);
        LineTo(hx + HintWidth, hy);
        LineTo(hx + HintWidth, hy + HintHeight);
        LineTo(hx - 1, hy + HintHeight);
        LineTo(hx - 1, hy);
        Release;
      end;

      for i := 0 to HintList.Count - 1 do
      begin
        MSurface.Canvas.Font.Color := HintColor;
        MSurface.Canvas.TextOutA(hx + 4, hy + 4 + (MSurface.Canvas.TextHeight('A', False) + 2) * i, HintList[i]);
      end;
    end;
  end;
end;
{$IFEND NEWHINTSYS}

constructor TDrawScreen.Create;
begin
  CurrentScene := nil;
  m_dwFrameTime := GetTickCount;
  m_dwFrameCount := 0;
  m_SysMsgList := TStringList.Create;
  m_SysMsgListEx := TStringList.Create;
  m_SysMsgListEx2 := TStringList.Create;
{$IFDEF OPENCENTERMAG}
{$IF USECENTERMAG}
  m_smListCnt := TGList.Create;
  m_smListCntFree := TGList.Create;
{$ELSE}
  m_smListCnt := TStringList.Create;
  m_smListBkc := TList.Create;
  m_smListSec := TList.Create;
  m_smListNow := TList.Create;
{$IFEND}
{$ENDIF OPENCENTERMAG}
  ChatStrs := TStringList.Create;
  m_adList := TStringList.Create;
  m_adList2 := TStringList.Create;

  ChatBks := TList.Create;
  ChatBoardTop := 0;
{$IF NEWHINTSYS}
  m_Hint1 := TDxHintMgr.Create;
  m_Hint2 := TDxHintMgr.Create;
  m_Hint3 := TDxHintMgr.Create;
{$ELSE}
  m_Hint1 := THintMgr.Create;
  m_Hint1.HintIdx := 1;
  m_Hint2 := THintMgr.Create;
  m_Hint2.HintIdx := 2;
  m_Hint3 := THintMgr.Create;
  m_Hint3.HintIdx := 3;
{$IFEND NEWHINTSYS}
end;

destructor TDrawScreen.Destroy;
var
  i: Integer;
begin

  m_SysMsgList.Free;
  m_SysMsgListEx.Free;
  m_SysMsgListEx2.Free;
{$IFDEF OPENCENTERMAG}
{$IF USECENTERMAG}
  for i := 0 to m_smListCnt.Count - 1 do
  begin
    if PTCenterMsg(m_smListCnt[i]) <> nil then
     Dispose(PTCenterMsg(m_smListCnt[i]));
  end;
  m_smListCnt.Free;
  for i := 0 to m_smListCntFree.Count - 1 do
  begin
    if PTCenterMsg(m_smListCntFree[i]) <> nil then
      Dispose(PTCenterMsg(m_smListCntFree[i]));
  end;
  m_smListCntFree.Free;
{$ELSE}
  m_smListCnt.Free;
  m_smListBkc.Free;
  m_smListSec.Free;
  m_smListNow.Free;
{$IFEND}
{$ENDIF OPENCENTERMAG}
  ChatStrs.Free;
  m_adList.Free;
  m_adList2.Free;
  ChatBks.Free;

{$IF NEWHINTSYS}
  m_Hint1.Free;
  m_Hint2.Free;
  m_Hint3.Free;
{$ELSE}
  m_Hint1.Free;
  m_Hint2.Free;
  m_Hint3.Free;
{$IFEND NEWHINTSYS}
  inherited Destroy;
end;

procedure TDrawScreen.Initialize;
begin
end;

procedure TDrawScreen.Finalize;
begin
end;

procedure TDrawScreen.KeyPress(var Key: Char);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyPress(Key);
end;

procedure TDrawScreen.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyDown(Key, Shift);
end;

procedure TDrawScreen.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseMove(Shift, X, Y);
end;

procedure TDrawScreen.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseDown(Button, Shift, X, Y);
end;

procedure TDrawScreen.ChangeScene(scenetype: TSceneType);
begin
  if CurrentScene <> nil then
    CurrentScene.CloseScene;
  case scenetype of
    stIntro:
      begin
        CurrentScene := IntroScene;
        IntroScene.m_dwStartTime := GetTickCount + 2000;
      end;
    stLogin: CurrentScene := LoginScene;
    stSelectCountry: ;
    stSelectChr: CurrentScene := SelectChrScene;
    stNewChr: ;
    stLoading: ;
    stLoginNotice: CurrentScene := LoginNoticeScene;
    stPlayGame: CurrentScene := g_PlayScene;
  end;
  if CurrentScene <> nil then
    CurrentScene.OpenScene;
end;

procedure TDrawScreen.AddSysMsg(Msg: string);
begin
  if m_SysMsgList.Count >= 10 then
    m_SysMsgList.Delete(0);
  m_SysMsgList.AddObject(Msg, TObject(GetTickCount));
end;

procedure TDrawScreen.AddSysMsgBottom(Msg: string);
begin
  if m_SysMsgListEx.Count >= 10 then
    m_SysMsgListEx.Delete(0);
  m_SysMsgListEx.AddObject(Msg, TObject(GetTickCount));
end;

procedure TDrawScreen.AddSysMsgBottom2(Msg: string);
begin
  if m_SysMsgListEx2.Count >= 10 then
    m_SysMsgListEx2.Delete(0);
  m_SysMsgListEx2.AddObject(Msg, TObject(GetTickCount));
end;
{$IFDEF OPENCENTERMAG}

procedure TDrawScreen.AddSysMsgCenter(Msg: string; fc, bc, sec: Integer);
var
  i, n, p: Integer;
  s: string;
  pm, pmfree: PTCenterMsg;
begin
  if Msg = '' then
    Exit;
{$IF USECENTERMAG}
  //if TagCount(Msg, '%') >= 2 then Exit;

  m_smListCnt.Lock;
  try
    if m_smListCnt.Count >= 5 then
    begin
      m_smListCnt.Delete(0);
      pm := m_smListCnt[0];
      pm.dwCloseTick := GetTickCount;
      m_smListCntFree.Lock;
      try
        m_smListCntFree.Add(pm);
      finally
        m_smListCntFree.UnLock;
      end;
    end;
    {i := 0;
    while True do begin
      if i >= m_smListCnt.Count then Break;
      pm := m_smListCnt[I];
      try
        if (GetTickCount - pm.dwNow) div 1000 >= pm.dwSec then begin
          m_smListCnt.Delete(i);
          pm.dwCloseTick := GetTickCount;
          m_smListCntFree.Lock;
          try
            m_smListCntFree.Add(pm);
          finally
            m_smListCntFree.UnLock;
          end;
        end else
          Inc(i);
      except
        on E: Exception do begin
          DebugOutStr('[DrawCntMsg] :: Close - ' + E.Message);
          if i < m_smListCnt.Count then m_smListCnt.Delete(i);
          Break;
        end;
      end;
    end;}
  finally
    m_smListCnt.UnLock;
  end;

  m_smListCntFree.Lock;
  try
    for i := m_smListCntFree.Count - 1 downto 0 do
    begin
      pmfree := m_smListCntFree[i];
      if (pmfree.dwCloseTick > 0) and (GetTickCount - pmfree.dwCloseTick > 5 * 60 * 1000) then
      begin
        m_smListCntFree.Delete(i);
        Dispose(pmfree);
        //Break;
      end;
    end;
  finally
    m_smListCntFree.UnLock;
  end;

  i := 0;
  s := Msg;
  n := Length(Msg);
  while True do
  begin
    p := Pos('%', s);
    if p > 0 then
    begin
      if p < n then
      begin
        if (Msg[p + 1] = 't') then
          Msg[p + 1] := 'd'
        else
        begin
          Msg[p] := ' ';
          Msg[p + 1] := ' ';
        end;
      end
      else if p = n then
      begin
        Msg[p] := ' ';
      end;
      s := Copy(Msg, p + 1, n - p);
    end
    else
      Break;
    Inc(i);
    if i > 10 then
      Break;
  end;
  if Trim(Msg) <> '' then
  begin
    New(pm);
    pm.s := Msg;
    pm.fc := fc;
    pm.bc := bc;
    pm.dwSec := _MAX(1, sec);
    pm.dwNow := GetTickCount;
    pm.dwCloseTick := 0;
    m_smListCnt.Lock;
    try
      m_smListCnt.Add(pm);
    finally
      m_smListCnt.UnLock;
    end;
  end;
{$ELSE}
EnterCriticalSection(ProcMsgCS);
try
  if m_smListCnt.Count >= 10 then
  begin
    m_smListCnt.Delete(0);
    m_smListBkc.Delete(0);
    m_smListSec.Delete(0);
    m_smListNow.Delete(0);
  end;
  while True do
  begin
    p := Pos('%t', Msg);
    if p > 0 then
      Msg[p + 1] := 'd'
    else
      Break;
  end;
  //s := AnsiReplaceText(Msg, '%t', '%d');
  m_smListCnt.AddObject(Msg, TObject(fc));
  m_smListBkc.Add(Pointer(bc));
  m_smListSec.Add(Pointer(sec));
  m_smListNow.Add(Pointer(GetTickCount));
finally
  LeaveCriticalSection(ProcMsgCS);
end;
{$IFEND}
end;
{$ENDIF OPENCENTERMAG}

procedure TDrawScreen.AddChatBoardString(Str: string; fcolor, bcolor: Integer);
var
  i, Len, aline: Integer;
  temp: string;
begin
  Len := Length(Str);
  temp := '';
  i := 1;
  while True do
  begin
    if i > Len then
      Break;
    if Byte(Str[i]) >= 128 then
    begin
      temp := temp + Str[i];
      Inc(i);
      if i <= Len then
        temp := temp + Str[i]
      else
        Break;
    end
    else
      temp := temp + Str[i];

    aline := TextWidthA(temp, False);
    //aline := frmMain.DXDraw.Surface.Canvas.TextWidth(temp);
    if aline > BOXWIDTH then
    begin
      ChatStrs.AddObject(temp, TObject(fcolor));
      ChatBks.Add(Pointer(bcolor));
      Str := Copy(Str, i + 1, Len - i);
      temp := '';
      Break;
    end;
    Inc(i);
  end;
  if temp <> '' then
  begin
    ChatStrs.AddObject(temp, TObject(fcolor));
    ChatBks.Add(Pointer(bcolor));
    Str := '';
  end;

  if ChatStrs.Count > 200 then
  begin
    ChatStrs.Delete(0);
    ChatBks.Delete(0);
    if ChatStrs.Count - ChatBoardTop < VIEWCHATLINE then
      Dec(ChatBoardTop);
  end
  else
  begin
    if not frmDlg.DBChat.Visible then
    begin
      if (ChatStrs.Count - ChatBoardTop) > VIEWCHATLINE then
        Inc(ChatBoardTop);
    end
    else
    begin
      if (ChatStrs.Count - ChatBoardTop) > VIEWCHATLINE then
        Inc(ChatBoardTop);
    end;
  end;
  if Str <> '' then
    AddChatBoardString(' ' + Str, fcolor, bcolor);
end;

function TDrawScreen.ShowHint(X, Y: Integer; Str: string; Color: TColor;
  drawup: Boolean;
  drawLeft: Boolean;
  bfh: Boolean;
  Lines: Boolean;
  mgr: Byte;
  TakeOn: Boolean): Integer;
begin
  //  g_DxHintMgr.AnalyseText(X, Y, STR, clWhite, drawup, drawLeft, False, False);
{$IF NEWHINTSYS}
  case mgr of
    1: Result := m_Hint1.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
    2: Result := m_Hint2.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
    3: Result := m_Hint3.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
  else
    begin
      Result := m_Hint1.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
      Result := Result + m_Hint2.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
      Result := Result + m_Hint3.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
    end;
  end;
{$ELSE}
  case mgr of
    1: Result := m_Hint1.ShowHint(X, Y, Str, Color, drawup, drawLeft, bfh, Lines, TakeOn);
    2: Result := m_Hint2.ShowHint(X, Y, Str, Color, drawup, drawLeft, bfh, Lines, TakeOn);
    3: Result := m_Hint3.ShowHint(X, Y, Str, Color, drawup, drawLeft, bfh, Lines, TakeOn);
  else
    begin
      Result := m_Hint1.ShowHint(X, Y, Str, Color, drawup, drawLeft, bfh, Lines, TakeOn);
      Result := Result + m_Hint2.ShowHint(X, Y, Str, Color, drawup, drawLeft, bfh, Lines, TakeOn);
      Result := Result + m_Hint3.ShowHint(X, Y, Str, Color, drawup, drawLeft, bfh, Lines, TakeOn);
    end;
  end;
{$IFEND NEWHINTSYS}
end;

procedure TDrawScreen.ClearChatBoard;
begin
  m_SysMsgList.Clear;
  m_SysMsgListEx.Clear;
  m_SysMsgListEx2.Clear;
{$IFDEF OPENCENTERMAG}
{$IF USECENTERMAG}
  {m_smListCnt.Lock;
  try
    for i := 0 to m_smListCnt.Count - 1 do
      DisPose(PTCenterMsg(m_smListCnt[i]));}
  m_smListCnt.Clear;
  {finally
    m_smListCnt.UnLock;
  end;}
  {m_smListCntFree.Lock;
  try
    for i := 0 to m_smListCntFree.Count - 1 do
      DisPose(PTCenterMsg(m_smListCntFree[i]));}
  m_smListCntFree.Clear;
  {finally
    m_smListCntFree.UnLock;
  end;}
{$ELSE}
  EnterCriticalSection(ProcMsgCS);
  try
    m_smListCnt.Clear;
    m_smListBkc.Clear;
    m_smListSec.Clear;
    m_smListNow.Clear;
  finally
    LeaveCriticalSection(ProcMsgCS);
  end;
{$IFEND}
{$ENDIF OPENCENTERMAG}
  ChatStrs.Clear;
  ChatBks.Clear;
  ChatBoardTop := 0;
end;

procedure TDrawScreen.DrawScreen(MSurface: TDirectDrawSurface);

  procedure NameTextOut(Surface: TDirectDrawSurface; X, Y, fcolor, bcolor: Integer; namestr: string; bExplore: Boolean = False);
  var
    i, Row: Integer;
    nstr: string;
    tmpcolor: TColor;
  begin
    Row := 0;
    for i := 0 to 10 do
    begin
      if namestr = '' then
        Break;
      namestr := GetValidStr3(namestr, nstr, ['\']);
      if bExplore and (i = 0) then
        tmpcolor := clLime
      else if tmpcolor <> fcolor then
        tmpcolor := fcolor;
      BoldTextOut(Surface,
        X - TextWidthA(nstr, False) shr 1,
        Y + Row * 12,
        tmpcolor, bcolor, nstr);
      Inc(Row);
    end;
  end;

  procedure NameTextOut2(Surface: TDirectDrawSurface; X, Y, fcolor, bcolor: Integer; Actor: TActor);
  begin
    if Actor.m_sUserName <> '' then
      BoldTextOut(Surface,
        X - Actor.m_sUserNameOffSet,
        Y,
        fcolor,
        bcolor,
        Actor.m_sUserName);
  end;

var
  t, t2: DWORD;
  i, n, k, line, sX, sY, fcolor, bcolor: Integer;
  Actor: TActor;
  uname: string[255];
  dsurface: TDirectDrawSurface;
  d, dd {, dh}: TDirectDrawSurface;
  rc: TRect;
  infoMsg: string[255];
  nNameColor: Integer;
  sad: string;
  p: pTClientStdItem;
begin
  if CurrentScene <> nil then
  begin
    CurrentScene.PlayScene(MSurface);
  end;

  if not g_ProcCanDraw then
    Exit;

  if g_MySelf = nil then
    Exit;

  if CurrentScene = g_PlayScene then
  begin
    t := GetTickCount;
    with MSurface do
    begin
      with g_PlayScene do
      begin
        dd := g_WMain3Images.Images[HEALTHBAR_BLACK];
        for k := 0 to m_ActorList.Count - 1 do
        begin
          Actor := m_ActorList[k];
          if IsInMyRange(Actor) then
          begin

            if (Actor.m_btRace = RCC_MERCHANT) and (Actor.m_wAppearance in [33..75, 84..98, 112..123, 130..132]) then
              Continue;

            if (g_boShowHPNumber or Actor.m_boOpenHealth) and (Actor.m_btRace <> RCC_MERCHANT) and (Actor.m_Abil.MaxHP > 1) and not Actor.m_boDeath then
            begin //显示人物血量
              infoMsg := IntToStr(Actor.m_Abil.HP) + '/' + IntToStr(Actor.m_Abil.MaxHP);
              BoldTextOut(MSurface, Actor.m_nSayX - Canvas.TextWidth(infoMsg, False) div 2, Actor.m_nSayY - 22 - 4, clWhite, clBlack, infoMsg);
            end;

            if (Actor.m_btRace <> RCC_MERCHANT) then
            begin
              if (Actor.m_boOpenHealth or Actor.m_noInstanceOpenHealth or g_boShowRedHPLable) and not Actor.m_boDeath then
              begin
                if Actor.m_noInstanceOpenHealth then
                  if t - Actor.m_dwOpenHealthStart > Actor.m_dwOpenHealthTime then
                    Actor.m_noInstanceOpenHealth := False;

                if dd <> nil then
                begin
                  if (Actor <> g_MySelf) and (Actor <> g_MySelf.m_HeroObject) then
                  begin
                    rc := dd.ClientRect;
                    if Actor.m_Abil.MaxHP > 0 then
                      rc.Right := Round((rc.Right - rc.Left) / Actor.m_Abil.MaxHP * Actor.m_Abil.HP);
                    MSurface.Draw(Actor.m_nSayX - dd.Width div 2 + 1, Actor.m_nSayY - 10 - 4 + 1, rc, g_HeathBar_Red, True);
                  end
                  else
                  begin
                    if (Actor = g_MySelf) then
                    begin
                      if not g_MySelf.m_boDeath then
                      begin
                        rc := dd.ClientRect;
                        if g_MySelf.m_Abil.MaxHP > 0 then
                          rc.Right := Round((rc.Right - rc.Left) / g_MySelf.m_Abil.MaxHP * g_MySelf.m_Abil.HP);
                        MSurface.Draw(g_MySelf.m_nSayX - dd.Width div 2 + 1, g_MySelf.m_nSayY - 10 - 4 + 1, rc, g_HeathBar_Green, True);
                      end;
                    end;
                    if (g_MySelf <> nil) and (g_MySelf.m_HeroObject <> nil) and (Actor = g_MySelf.m_HeroObject) then
                    begin
                      if IsInMyRange(g_MySelf.m_HeroObject) then
                      begin
                        rc := dd.ClientRect;
                        if g_MySelf.m_HeroObject.m_Abil.MaxHP > 0 then
                          rc.Right := Round((rc.Right - rc.Left) / g_MySelf.m_HeroObject.m_Abil.MaxHP * g_MySelf.m_HeroObject.m_Abil.HP);
                        MSurface.Draw(Actor.m_nSayX - dd.Width div 2 + 1, Actor.m_nSayY - 10 - 4 + 1, rc, g_HeathBar_Green, True);
                      end;
                    end;
                  end;
                  MSurface.Draw(Actor.m_nSayX - dd.Width div 2, Actor.m_nSayY - 10 - 4, dd.ClientRect, dd, True);

                  if (Actor.m_btRace = 0) and (Actor.m_nIPower >= 0) then
                  begin
                    if (Actor.m_nIPowerLvl in [1..MAX_IPLEVEL]) then
                    begin
                      rc := dd.ClientRect;
                      if Actor.m_nIPower > 0 then
                        rc.Right := Round((rc.Right - rc.Left) / g_dwIPNeedInfo[Actor.m_nIPowerLvl].nPower * Actor.m_nIPower)
                      else
                        rc.Right := 0;
                      MSurface.Draw(Actor.m_nSayX - dd.Width div 2 + 1, Actor.m_nSayY - 7 - 4 + 1, rc, g_HeathBar_Yellow, True);
                      MSurface.Draw(Actor.m_nSayX - dd.Width div 2, Actor.m_nSayY - 7 - 4, dd.ClientRect, dd, True);
                    end;
                  end;

                end;
              end;
            end
            else
            begin
              if dd <> nil then
              begin
                MSurface.Draw(Actor.m_nSayX - dd.Width div 2 + 1, Actor.m_nSayY - 10 - 4 + 1, g_HeathBar_Blue.ClientRect, g_HeathBar_Blue {g_ImgNpcSurface}, True);
                MSurface.Draw(Actor.m_nSayX - dd.Width div 2, Actor.m_nSayY - 10 - 4, dd.ClientRect, dd, True);
              end;
            end;
          end;
        end;
      end;

      //显示人名 ShowActorName
      if g_gcGeneral[0] then
      begin
        with g_PlayScene do
        begin
          for k := 0 to m_ActorList.Count - 1 do
          begin
            Actor := m_ActorList[k];
            if (Actor = nil) or (Actor.m_boDeath) then
              Continue;
            if (Actor.m_BodySurface = nil) then
              Continue;
            if (Actor.m_nSayX = 0) and (Actor.m_nSayY = 0) then
              Continue;

            if ((Actor.m_btRace = 0) or (Actor.m_btRace = RCC_MERCHANT)) and IsInMyRange(Actor) then
            begin

              if (Actor <> g_FocusCret) and (not g_boSelectMyself or (Actor <> g_MySelf)) then
              begin
                NameTextOut2(MSurface,
                  Actor.m_nSayX,
                  Actor.m_nSayY + 30,
                  Actor.m_nNameColor,
                  clBlack,
                  Actor);
              end;

              if Actor is THumActor then
              begin
                if THumActor(Actor).m_StallMgr.OnSale then
                begin
                  if THumActor(Actor).m_StallMgr.mBlock.StallName <> '' then
                  begin
                    if g_boShowHPNumber and (Actor.m_Abil.MaxHP > 1) then
                      BoldTextOut(MSurface, THumActor(Actor).m_nSayX - (TextWidthA(THumActor(Actor).m_StallMgr.mBlock.StallName, False) div 2),
                        THumActor(Actor).m_nSayY - 36,
                        GetRGB(94),
                        clBlack,
                        THumActor(Actor).m_StallMgr.mBlock.StallName)
                    else
                      BoldTextOut(MSurface, THumActor(Actor).m_nSayX - (TextWidthA(THumActor(Actor).m_StallMgr.mBlock.StallName, False) div 2),
                        THumActor(Actor).m_nSayY - 24,
                        GetRGB(94),
                        clBlack,
                        THumActor(Actor).m_StallMgr.mBlock.StallName);
                  end;
                  if g_gcGeneral[16] and (Actor.m_btTitleIndex > 0) then
                  begin
                    p := GetTitle(Actor.m_btTitleIndex);
                    if p <> nil then
                    begin
                      if g_boShowHPNumber and (Actor.m_Abil.MaxHP > 1) then
                      begin
                        if p.Reserved = 0 then
                        begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (TextWidthA(p.Name, False) + dd.Width) div 2 - 4,
                              Actor.m_nSayY - 55 - (dd.Width - TextHeightA(p.Name, False)) div 2,
                              dd, True);
                          if dd <> nil then
                            BoldTextOut(MSurface, Actor.m_nSayX - ((TextWidthA(p.Name, False) - dd.Width) div 2),
                              Actor.m_nSayY - 55,
                              GetLevelColor(p.Source),
                              clBlack,
                              p.Name)
                          else
                            BoldTextOut(MSurface, Actor.m_nSayX - (TextWidthA(p.Name, False) div 2),
                              Actor.m_nSayY - 55,
                              GetLevelColor(p.Source),
                              clBlack,
                              p.Name);
                        end
                        else
                        begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (dd.Width div 2),
                              Actor.m_nSayY - 55 - (dd.Height - TextHeightA('a', False)) div 2 - 5,
                              dd);
                        end;
                      end
                      else
                      begin
                        if p.Reserved = 0 then
                        begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (TextWidthA(p.Name, False) + dd.Width) div 2 - 4,
                              Actor.m_nSayY - 43 - (dd.Width - TextHeightA(p.Name, False)) div 2,
                              dd);
                          if dd <> nil then
                            BoldTextOut(MSurface, Actor.m_nSayX - ((TextWidthA(p.Name, False) - dd.Width) div 2),
                              Actor.m_nSayY - 43,
                              GetLevelColor(p.Source),
                              clBlack,
                              p.Name)
                          else
                            BoldTextOut(MSurface, Actor.m_nSayX - ((TextWidthA(p.Name, False)) div 2),
                              Actor.m_nSayY - 43,
                              GetLevelColor(p.Source),
                              clBlack,
                              p.Name);
                        end
                        else
                        begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (dd.Width div 2),
                              Actor.m_nSayY - 43 - (dd.Height - TextHeightA('a', False)) div 2 - 5,
                              dd);
                        end;
                      end;
                    end;
                  end;
                end
                else
                begin
                  if g_gcGeneral[16] and (Actor.m_btTitleIndex > 0) then
                  begin
                    p := GetTitle(Actor.m_btTitleIndex);
                    if p <> nil then
                    begin
                      if g_boShowHPNumber and (Actor.m_Abil.MaxHP > 1) then
                      begin
                        if p.Reserved = 0 then
                        begin
                          dd := g_wui.Images[p.looks];
                          //MSurface.Draw(Actor.m_nSayX - dd.Width div 2, Actor.m_nSayY - 10 - 4, dd.ClientRect, dd, True);
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (TextWidthA(p.Name, False) + dd.Width) div 2 - 4,
                              Actor.m_nSayY - 40 - (dd.Width - TextHeightA(p.Name, False)) div 2,
                              dd, True);
                          if dd <> nil then
                            BoldTextOut(MSurface, Actor.m_nSayX - ((TextWidthA(p.Name, False) - dd.Width) div 2),
                              Actor.m_nSayY - 40,
                              GetLevelColor(p.Source),
                              clBlack,
                              p.Name)
                          else
                            BoldTextOut(MSurface, Actor.m_nSayX - ((TextWidthA(p.Name, False)) div 2),
                              Actor.m_nSayY - 40,
                              GetLevelColor(p.Source),
                              clBlack,
                              p.Name);
                        end
                        else
                        begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (dd.Width div 2),
                              Actor.m_nSayY - 40 - (dd.Height - TextHeightA('a', False)) div 2 - 5,
                              dd);
                        end;
                      end
                      else
                      begin
                        if p.Reserved = 0 then
                        begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (TextWidthA(p.Name, False) + dd.Width) div 2 - 4,
                              Actor.m_nSayY - 28 - (dd.Width - TextHeightA(p.Name, False)) div 2,
                              dd);
                          if dd <> nil then
                            BoldTextOut(MSurface, Actor.m_nSayX - ((TextWidthA(p.Name, False) - dd.Width) div 2),
                              Actor.m_nSayY - 28,
                              GetLevelColor(p.Source),
                              clBlack,
                              p.Name)
                          else
                            BoldTextOut(MSurface, Actor.m_nSayX - ((TextWidthA(p.Name, False)) div 2),
                              Actor.m_nSayY - 28,
                              GetLevelColor(p.Source),
                              clBlack,
                              p.Name);
                        end
                        else
                        begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (dd.Width div 2),
                              Actor.m_nSayY - 28 - (dd.Height - TextHeightA('a', False)) div 2 - 5,
                              dd);
                        end;
                      end;
                    end;
                  end;
                end;

              end;

            end;
          end;
        end;
      end;

      if (g_FocusCret <> nil) and (g_FocusCret.m_BodySurface <> nil) and g_PlayScene.IsValidActor(g_FocusCret) then
      begin //1001
        if g_FocusCret.m_boDeath and not g_FocusCret.m_boSkeleton and g_FocusCret.m_boItemExplore {and (g_FocusCret.m_btRace <> 0)} then
        begin
          uname := Format('(可探索)\%s\%s', [g_FocusCret.m_sDescUserName, g_FocusCret.m_sUserName]);
          NameTextOut(MSurface,
            g_FocusCret.m_nSayX,
            g_FocusCret.m_nSayY + 18,
            g_FocusCret.m_nNameColor, clBlack,
            uname, True);
        end
        else
        begin
          if not (g_FocusCret.m_boDeath and g_gcGeneral[8] and not g_FocusCret.m_boItemExplore and (g_FocusCret.m_btRace <> 0)) then
          begin
            uname := Format('%s\%s', [g_FocusCret.m_sDescUserName, g_FocusCret.m_sUserName]);
            if g_FocusCret.m_btRace = RCC_MERCHANT then
              nNameColor := clLime
            else
              nNameColor := g_FocusCret.m_nNameColor;
            NameTextOut(MSurface,
              g_FocusCret.m_nSayX,
              g_FocusCret.m_nSayY + 30,
              nNameColor, clBlack,
              uname);
          end;
        end;
      end;

      if g_boSelectMyself then
      begin
        uname := Format('%s\%s', [g_MySelf.m_sDescUserName, g_MySelf.m_sUserName]);
        NameTextOut(MSurface,
          g_MySelf.m_nSayX,
          g_MySelf.m_nSayY + 30,
          g_MySelf.m_nNameColor, clBlack,
          uname);
      end;

      Canvas.Font.Color := clWhite;

      //显示角色说话文字
      with g_PlayScene do
      begin
        for k := 0 to m_ActorList.Count - 1 do
        begin
          Actor := m_ActorList[k];
          if (Actor = nil) {or (Actor.m_boDeath)} then
            Continue;
          for i := 0 to Actor.m_StruckDamage2.Count - 1 do
          begin
            with MSurface.Canvas do
            begin
              n := Font.Size;
              uname := Font.Name;
              try
                sX := 18;
                Font.Size := sX;
                Font.Name := 'Times New Roman Bold Italic';
                sY := Integer(Actor.m_StruckDamage2.Objects[i]);
                if sY <= 1 then
                  sY := 0;
                BoldTextOut(MSurface,
                  Actor.m_nSayX + Integer(Actor.m_StruckDamage2.Objects[i]) - TextWidth(Actor.m_StruckDamage2[i], True, sX) div 2,
                  Actor.m_nSayY - 10 - Round(Integer(Actor.m_StruckDamage2.Objects[i]) * 1.4) - TextHeight(Actor.m_StruckDamage2[i], True, sX),
                  $000061EB,
                  GetRGB(16), //clBlack,
                  Actor.m_StruckDamage2[i], 4, True, _MAX(0, 256 - sY * 6));

              finally
                Font.Size := n;
                Font.Name := uname;
              end;
            end;
            Actor.m_StruckDamage2.Objects[i] := TObject(Integer(Actor.m_StruckDamage2.Objects[i]) + 1);
          end;
          for i := Actor.m_StruckDamage2.Count - 1 downto 0 do
          begin
            if Integer(Actor.m_StruckDamage2.Objects[i]) > 32 then
            begin
              Actor.m_StruckDamage2.Delete(i);
            end;
          end;
        end;

        for k := 0 to m_ActorList.Count - 1 do
        begin
          Actor := m_ActorList[k];
          if (Actor = nil) {or (Actor.m_boDeath)} then
            Continue;
          for i := 0 to Actor.m_StruckDamage.Count - 1 do
          begin
            with MSurface.Canvas do
            begin
              n := Font.Size;
              uname := Font.Name;
              try
                sX := 18;
                Font.Size := sX;
                Font.Name := 'Times New Roman Bold Italic';

                BoldTextOut(MSurface,
                  Actor.m_nSayX + Integer(Actor.m_StruckDamage.Objects[i]) - TextWidth(Actor.m_StruckDamage[i], True, sX) div 2,
                  Actor.m_nSayY - 10 - Round(Integer(Actor.m_StruckDamage.Objects[i]) * 1.4) - TextHeight(Actor.m_StruckDamage[i], True, sX),
                  $00FF35B1,
                  GetRGB(16),
                  Actor.m_StruckDamage[i], 4, True, 256 - Integer(Actor.m_StruckDamage.Objects[i]) * 4);

              finally
                Font.Size := n;
                Font.Name := uname;
              end;
            end;
            Actor.m_StruckDamage.Objects[i] := TObject(Integer(Actor.m_StruckDamage.Objects[i]) + 1);
          end;

          for i := Actor.m_StruckDamage.Count - 1 downto 0 do
          begin
            if Integer(Actor.m_StruckDamage.Objects[i]) > 38 then
            begin
              Actor.m_StruckDamage.Delete(i);
            end;
          end;
        end;

        for k := 0 to m_ActorList.Count - 1 do
        begin
          Actor := m_ActorList[k];
          if Actor.m_SayingArr[0] <> '' then
          begin
            if t - Actor.m_dwSayTime < 4 * 1000 then
            begin
              for i := 0 to Actor.m_nSayLineCount - 1 do
              begin
                if (Actor is THumActor) and THumActor(Actor).m_StallMgr.OnSale then
                begin
                  if Actor.m_boDeath then
                    BoldTextOut(MSurface,
                      Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                      Actor.m_nSayY - (Actor.m_nSayLineCount * 14) + i * 14 - 35,
                      clGray, clBlack,
                      Actor.m_SayingArr[i])
                  else
                  begin
                    if g_boShowHPNumber and (Actor.m_Abil.MaxHP > 1) then
                      BoldTextOut(MSurface,
                        Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                        Actor.m_nSayY - (Actor.m_nSayLineCount * 16) + i * 14 - 35,
                        clWhite, clBlack,
                        Actor.m_SayingArr[i])
                    else
                      BoldTextOut(MSurface,
                        Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                        Actor.m_nSayY - (Actor.m_nSayLineCount * 14) + i * 14,
                        clWhite, clBlack,
                        Actor.m_SayingArr[i]);
                  end;
                end
                else
                begin
                  if Actor.m_boDeath then
                    BoldTextOut(MSurface,
                      Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                      Actor.m_nSayY - (Actor.m_nSayLineCount * 16) + i * 14,
                      clGray, clBlack,
                      Actor.m_SayingArr[i])
                  else
                    BoldTextOut(MSurface,
                      Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                      Actor.m_nSayY - (Actor.m_nSayLineCount * 16) + i * 14,
                      clWhite, clBlack,
                      Actor.m_SayingArr[i]);
                end;
              end;
            end
            else
              Actor.m_SayingArr[0] := '';
          end;
        end;
      end;

      with MSurface do
      begin
        if m_adList.Count > 0 then
        begin
          n := Canvas.Font.Size;
          Canvas.Font.Size := 11;
          Canvas.Font.Style := [fsBold];
          try
            //   滚动文字应该随着窗体宽度改变  2019-11-22
            DrawBlend_Mix(MSurface, 0, 0, g_HintSurface_C, 0, 0, SCREENWIDTH, 28, 0);

            for i := m_adList.Count - 1 downto 0 do
            begin
              if i = m_adList.Count - 1 then
              begin
                BoldTextOut(MSurface,
                  g_SkidAD_Rect.Right - Integer(m_adList2.Objects[i]),
                  g_SkidAD_Rect.Top,
                  GetRGB(LoByte(Word(m_adList.Objects[i]))),
                  GetRGB(HiByte(Word(m_adList.Objects[i]))),
                  m_adList[i] {, 4, 1, sX});

                m_adList2.Objects[i] := TObject(Integer(m_adList2.Objects[i]) + 1);

                if Integer(m_adList2.Objects[i]) >= Round(8.255 * Length(m_adList[i])) + SCREENWIDTH then
                begin
                  m_adList.Delete(i);
                  m_adList2.Delete(i);
                end;
              end
              else
              begin
                if (i < m_adList.Count - 1) and (i >= 0) then
                begin
                  sX := Round(8.255 * Length(m_adList[i + 1]));
                  if Integer(m_adList2.Objects[i + 1]) >= sX + 82 then
                  begin

                    BoldTextOut(MSurface,
                      g_SkidAD_Rect.Right - Integer(m_adList2.Objects[i]),
                      g_SkidAD_Rect.Top,
                      GetRGB(LoByte(Word(m_adList.Objects[i]))),
                      GetRGB(HiByte(Word(m_adList.Objects[i]))),
                      m_adList[i] {, 4, 1, sX});

                    m_adList2.Objects[i] := TObject(Integer(m_adList2.Objects[i]) + 1);
                  end;
                end;
              end;
            end;
          finally
            Canvas.Font.Size := n;
            Canvas.Font.Style := [];
          end;
        end;
      end;

      if g_boViewMiniMap then
        g_PlayScene.DrawMiniMap(MSurface);

      if (g_nAreaStateValue and 4) <> 0 then
        BoldTextOut(MSurface, 0, 0, clWhite, clBlack, '攻城区域');

      k := 0;
      for i := 0 to 1 do
      begin
        if g_nAreaStateValue and ($01 shl i) <> 0 then
        begin
          d := g_WMainImages.Images[AREASTATEICONBASE + i];
          if d <> nil then
          begin
            k := k + d.Width;
            MSurface.Draw(SCREENWIDTH - k, 0, d.ClientRect, d, True);
          end;
        end;
      end;
      if frmMain.TimerAutoPlay.Enabled and (g_sAPstr <> '') then
        BoldTextOut(MSurface, 190, 5, clLime, clBlack, g_sAPstr);
    end;
  end;
end;

procedure TDrawScreen.DrawScreenTop(MSurface: TDirectDrawSurface);
var
  i, sX, sY: Integer;
begin
  if g_MySelf = nil then
    Exit;
  if CurrentScene = g_PlayScene then
  begin
    with MSurface do
    begin
      if m_SysMsgList.Count > 0 then
      begin
        sX := 20;
        if frmDlg.DWHeroStatus.Visible then
          sY := 88
        else
          sY := 30;
        for i := 0 to m_SysMsgList.Count - 1 do
        begin
          BoldTextOut(MSurface, sX, sY, clGreen, clBlack, m_SysMsgList[i]);
          Inc(sY, 16);
        end;
        if GetTickCount - LongWord(m_SysMsgList.Objects[0]) >= 3000 then
          m_SysMsgList.Delete(0);
      end;
    end;
  end;
end;

procedure TDrawScreen.DrawScreenBottom(MSurface: TDirectDrawSurface);
var
  cl: TColor;
  i, sX, sY: Integer;
begin
  if g_MySelf = nil then
    Exit;
  if CurrentScene = g_PlayScene then
  begin
    with MSurface do
    begin
      if m_SysMsgListEx.Count > 0 then
      begin
        sX := 20;
        sY := SCREENHEIGHT - 250;
        for i := 0 to m_SysMsgListEx.Count - 1 do
        begin
          cl := clRed;
          if Pos('灵气', m_SysMsgListEx[i]) > 0 then
            cl := clLime;
          BoldTextOut(MSurface, sX, sY, cl, clBlack, m_SysMsgListEx[i]);
          Dec(sY, 16);
        end;
        if GetTickCount - LongWord(m_SysMsgListEx.Objects[0]) >= 3000 then
          m_SysMsgListEx.Delete(0);
      end;

      if m_SysMsgListEx2.Count > 0 then
      begin
        sY := SCREENHEIGHT - 270;
        for i := 0 to m_SysMsgListEx2.Count - 1 do
        begin
          cl := clRed;
          sX := SCREENWIDTH - TextWidthA(m_SysMsgListEx2[i], False) - 14;
          BoldTextOut(MSurface, sX, sY, cl, clBlack, m_SysMsgListEx2[i]);
          Dec(sY, 16);
        end;
        if GetTickCount - LongWord(m_SysMsgListEx2.Objects[0]) >= 4000 then
          m_SysMsgListEx2.Delete(0);
      end;

    end;
  end;
end;

{$IFDEF OPENCENTERMAG}

procedure TDrawScreen.DrawScreenCenter(MSurface: TDirectDrawSurface);
var
  sOutMsg: string;
  i, sX, sY: Integer;
  pm: PTCenterMsg;
begin
  if g_MySelf = nil then
    Exit;
  if CurrentScene = g_PlayScene then
  begin
{$IF USECENTERMAG}
    m_smListCnt.Lock;
    try
      if m_smListCnt.Count > 0 then
      begin
        sY := SCREENHEIGHT - 220;

        with MSurface do
        begin
          for i := m_smListCnt.Count - 1 downto 0 do
          begin
            pm := m_smListCnt[i];
            try
              if (GetTickCount - pm.dwNow) div 1000 < pm.dwSec then
              begin
                sOutMsg := pm.s;
                if Pos('%d', sOutMsg) > 0 then
                  sOutMsg := Format(sOutMsg, [pm.dwSec - (GetTickCount - pm.dwNow) div 1000]);
                sX := (SCREENWIDTH - TextWidthA(sOutMsg, False)) div 2 + 14;
                BoldTextOut(MSurface, sX, sY, pm.fc, pm.bc, sOutMsg);
                Dec(sY, 16);
              end;
            except
              Break;
            end;
          end;
        end;
      end;
    finally
      m_smListCnt.UnLock;
    end;

{$ELSE}
EnterCriticalSection(ProcMsgCS);
try
  with MSurface do
  begin
    if m_smListCnt.Count > 0 then
    begin

      sY := SCREENHEIGHT - 220;

      for i := 0 to m_smListCnt.Count - 1 do
      begin
        try
          srMsg := m_smListCnt[i];
          if srMsg = '' then
            Continue;
          if (GetTickCount - LongWord(m_smListNow[i])) div 1000 >= Integer(m_smListSec[i]) then
            Continue;
          if Pos('%d', srMsg) > 0 then
            srMsg := Format(srMsg, [Integer(m_smListSec[i]) - ((GetTickCount - LongWord(m_smListNow[i])) div 1000)]);
          sX := (SCREENWIDTH - TextWidthA(srMsg, False)) div 2 + 14;
          BoldTextOut(MSurface, sX, sY, Integer(m_smListCnt.Objects[i]), Integer(m_smListBkc[i]), srMsg);
          Dec(sY, 16);
        except
          Break;
        end;
      end;

      {if (GetTickCount - LongWord(m_smListNow[0])) div 1000 >= LongWord(m_smListSec[0]) then begin
        m_smListCnt.Delete(0);
        m_smListBkc.Delete(0);
        m_smListSec.Delete(0);
        m_smListNow.Delete(0);
      end;}
    end;
  end;
finally
  LeaveCriticalSection(ProcMsgCS);
end;
{$IFEND}
end;
end;
{$ENDIF OPENCENTERMAG}

procedure TDrawScreen.ClearHint;
begin
{$IF NEWHINTSYS}
  m_Hint1.ClearHint;
  m_Hint2.ClearHint;
  m_Hint3.ClearHint;
{$ELSE}
  m_Hint1.ClearHint;
  m_Hint2.ClearHint;
  m_Hint3.ClearHint;
{$IFEND NEWHINTSYS}
end;

procedure TDrawScreen.DrawHint(MSurface: TDirectDrawSurface);
begin
{$IF NEWHINTSYS}
  m_Hint1.DrawHint(MSurface);
  m_Hint2.DrawHint(MSurface);
  m_Hint3.DrawHint(MSurface);
{$ELSE}
  m_Hint1.DrawHint(MSurface);
  m_Hint2.DrawHint(MSurface);
  m_Hint3.DrawHint(MSurface);
{$IFEND NEWHINTSYS}
end;

end.
