unit IntroScn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, StdCtrls, Controls, Forms, Dialogs,
  ExtCtrls, DXDraws, DXClass, FState, Grobal2, cliUtil, ClFunc, SoundUtil,
  HUtil32, DWinCtl;

const
  SELECTEDFRAME = 16;
  FREEZEFRAME = 13;
  EFFECTFRAME = 14;

type
  TLoginState = (lsLogin, lsNewid, lsNewidRetry, lsChgpw, lsCloseAll);
  TSceneType = (stIntro, stLogin, stSelectCountry, stSelectChr, stNewChr, stLoading, stLoginNotice, stPlayGame);
  TSelChar = record
    Valid: Boolean;
    UserChr: TUserCharacterInfo;
    Selected: Boolean;
    FreezeState: Boolean;
    Unfreezing: Boolean;
    Freezing: Boolean;
    AniIndex: Integer;
    DarkLevel: Integer;
    EffIndex: Integer;
    StartTime: LongWord;
    moretime: LongWord;
    startefftime: LongWord;
  end;

  TScene = class
  private
  public
    scenetype: TSceneType;
    constructor Create(scenetype: TSceneType);
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure OpenScene; virtual;
    procedure CloseScene; virtual;
    procedure OpeningScene; virtual;
    procedure KeyPress(var Key: Char); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure PlayScene(MSurface: TDirectDrawSurface); virtual;
  end;

  // 刚开始进入游戏的场景
  TIntroScene = class(TScene)
    m_boOnClick: Boolean;
    m_dwStartTime: LongWord;
  private
  public
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
  end;

  TLoginScene = class(TScene)
  private
    {
    m_EdNewId: TEdit;
    m_EdNewPasswd: TEdit;
    m_EdConfirm: TEdit;
    m_EdYourName: TEdit;
    m_EdSSNo: TEdit;
    m_EdBirthDay: TEdit;
    m_EdQuiz1: TEdit;
    m_EdAnswer1: TEdit;
    m_EdQuiz2: TEdit;
    m_EdAnswer2: TEdit;
    m_EdPhone: TEdit;
    m_EdMobPhone: TEdit;
    m_EdEMail: TEdit;
     }


    {
    m_EdChgId: TEdit;
    m_EdChgCurrentpw: TEdit;
    m_EdChgNewPw: TEdit;
    m_EdChgRepeat: TEdit;  }


    m_nCurFrame: Integer;
    m_nMaxFrame: Integer;
    m_dwStartTime: LongWord;
    m_boNowOpening: Boolean;
    m_boOpenFirst: Boolean;
    m_NewIdRetryUE: TUserEntry;
    m_NewIdRetryAdd: TUserEntryAdd;

    function CheckUserEntrys: Boolean;
    function NewIdCheckNewId: Boolean;
    function NewIdCheckSSno: Boolean;
    function NewIdCheckBirthDay: Boolean;
  public
    m_sLoginId: string;
    m_sLoginPasswd: string;
    //m_boUpdateAccountMode: Boolean;
    m_EditIDHandle: THandle;
    m_EditIDPointer: Pointer;
    m_EditPassHandle: THandle;
    m_EditPassPointer: Pointer;
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;

    procedure EdLoginIdKeyPress(Sender: TObject; var Key: Char);
    procedure EdLoginPasswdKeyPress(Sender: TObject; var Key: Char);
    procedure EdNewIdKeyPress(Sender: TObject; var Key: Char);
    procedure EdNewOnEnter(Sender: TObject);

    procedure PlayScene(MSurface: TDirectDrawSurface); override;
    procedure ChangeLoginState(State: TLoginState);
    procedure NewClick;
    procedure NewIdRetry(boupdate: Boolean);
    procedure UpdateAccountInfos(ue: TUserEntry);
    procedure OkClick;
    procedure ChgPwClick;
    procedure NewAccountOk;
    procedure NewAccountClose;
    procedure ChgpwOk;
    procedure ChgpwCancel;
    procedure HideLoginBox;
    procedure OpenLoginDoor;
    procedure PassWdFail;
    procedure EditIDWndProc(var Message: TMessage);
    procedure EditPassWndProc(var Message: TMessage);
  end;

  TSelectChrScene = class(TScene)
  private
    SoundTimer: TTimer;
    CreateChrMode: Boolean;
    //EdChrName: TEdit;
    procedure SoundOnTimer(Sender: TObject);
    procedure MakeNewChar(Index: Integer);
    //procedure EdChrnameKeyPress(Sender: TObject; var Key: Char);
  public
    NewIndex: Integer;
    ChrArr: array[0..1] of TSelChar;
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
    procedure SelChrSelect1Click;
    procedure SelChrSelect2Click;
    procedure SelChrStartClick;
    procedure SelChrNewChrClick;
    procedure SelChrEraseChrClick;
    procedure SelChrCreditsClick;
    procedure SelChrExitClick;
    procedure SelChrNewClose;
    procedure SelChrNewJob(job: Integer);
    procedure SelChrNewm_btSex(sex: Integer);
    procedure SelChrNewPrevHair;
    procedure SelChrNewNextHair;
    procedure SelChrNewOk;
    procedure ClearChrs;
    procedure AddChr(uname: string; job, hair, Level, sex: Integer);
    procedure SelectChr(Index: Integer);
  end;

  TLoginNotice = class(TScene)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

function RotateBits(C: Char; Bits: Integer): Char;

implementation

uses
  ClMain, MShare, EDcode, MirThread;

constructor TScene.Create(scenetype: TSceneType);
begin
  Self.scenetype := scenetype;
end;

procedure TScene.Initialize;
begin
end;

procedure TScene.Finalize;
begin
end;

procedure TScene.OpenScene;
begin
  ;
end;

procedure TScene.CloseScene;
begin
  ;
end;

procedure TScene.OpeningScene;
begin
end;

procedure TScene.KeyPress(var Key: Char);
begin
end;

procedure TScene.KeyDown(var Key: Word; Shift: TShiftState);
begin
end;

procedure TScene.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TScene.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TScene.PlayScene(MSurface: TDirectDrawSurface);
begin
  ;
end;

{------------------- TIntroScene ----------------------}

constructor TIntroScene.Create;
begin
  inherited Create(stIntro);
end;

destructor TIntroScene.Destroy;
begin
  inherited Destroy;
end;

procedure TIntroScene.OpenScene;
begin
  m_boOnClick := False;
  m_dwStartTime := GetTickCount + 2 * 1000;
end;

procedure TIntroScene.CloseScene;
begin

end;

procedure TIntroScene.KeyPress(var Key: Char);
begin
  m_boOnClick := True;
end;

procedure TIntroScene.KeyDown(var Key: Word; Shift: TShiftState);
begin
  m_boOnClick := True;
end;

procedure TIntroScene.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  m_boOnClick := True;
end;

procedure TIntroScene.PlayScene(MSurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  MSurface.Fill(clWhite);
  d := g_WMainUibImages.Images['data\ui\snda.uib'];
  if d <> nil then
    MSurface.Draw((SCREENWIDTH - d.Width) div 2, (SCREENHEIGHT - d.Height) div 2, d.ClientRect, d, True);

  {
  n := MSurface.Canvas.Font.Size;
  MSurface.Canvas.Font.Size := 145;
  s := MSurface.Canvas.Font.Name;
  MSurface.Canvas.Font.Name := '黑体';
  MSurface.Canvas.Font.Style := [fsBold];
  try
    BoldTextOut(MSurface,
      (SCREENWIDTH - MSurface.Canvas.TextWidth(COPYRIGHTNAME, True, 145)) div 2,
      (SCREENHEIGHT - MSurface.Canvas.TextHeight(COPYRIGHTNAME, True, 145)) div 2,
      GetRGB(249),
      GetRGB(249),
      COPYRIGHTNAME);
  finally
    MSurface.Canvas.Font.Size := n;
    MSurface.Canvas.Font.Name := s;
    MSurface.Canvas.Font.Style := [];
  end;
 }

  if GetTickCount > m_dwStartTime then
  begin
    m_boOnClick := True;
    DScreen.ChangeScene(stLogin);
    if not g_boDoFadeOut and not g_boDoFadeIn then
    begin
      //g_boDoFadeOut := True;
      g_boDoFadeIn := True;
      g_nFadeIndex := 0;
    end;
  end;
end;

{--------------------- Login ----------------------}

procedure TLoginScene.EditIDWndProc(var Message: TMessage);
begin
  //HideCaret(m_EditIDHandle);
  case Message.Msg of
    EM_SETSEL,
      WM_KEYFIRST,
      WM_LBUTTONDBLCLK,
      WM_RBUTTONDOWN,
      WM_RBUTTONUP,
      WM_COPY,
      WM_MOUSEMOVE,
      WM_SETCURSOR,
      WM_GETTEXT,
      WM_MOUSELEAVE: Exit;
  end;
  Message.Result := CallWindowProc(m_EditIDPointer, m_EditIDHandle, Message.Msg, Message.WParam, Message.LParam);
end;

procedure TLoginScene.EditPassWndProc(var Message: TMessage);
begin
  //HideCaret(m_EditPassHandle);
  case Message.Msg of
    EM_SETSEL, WM_KEYFIRST, WM_LBUTTONDBLCLK,
      WM_RBUTTONDOWN, WM_RBUTTONUP,
      WM_COPY, WM_MOUSEMOVE, WM_SETCURSOR,
      WM_GETTEXT, WM_MOUSELEAVE: Exit;
  end;
  Message.Result := CallWindowProc(m_EditPassPointer, m_EditPassHandle, Message.Msg, Message.WParam, Message.LParam);
end;

constructor TLoginScene.Create;
  // p: Pointer;
  // nX, nY: Integer;
begin
  inherited Create(stLogin);
  m_boOpenFirst := False;

  // nX := SCREENWIDTH div 2 - 320;
  // nY := SCREENHEIGHT div 2 - 238;

  {
  m_EdNewId := TDxEdit.Create(FrmMain.Owner);
  with m_EdNewId do
  begin
    Parent := FrmMain;
    Color := clBlack;
    m_EdNewId.Transparent := False;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 116;
    //BorderStyle := bsNone;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    Visible := True;
    OnKeyPress := EdNewIdKeyPress;
    //OnEnter := EdNewOnEnter;
    tag := 11;
  end;
   m_EdNewId.Refresh;
  }


  {
  m_EdNewPasswd := TEdit.Create(frmMain);
  with m_EdNewPasswd do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 137;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdConfirm := TDxEdit.Create(frmMain);
  with m_EdConfirm do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 158;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdYourName := TDxEdit.Create(frmMain);
  with m_EdYourName do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 187;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 20;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdSSNo := TDxEdit.Create(frmMain);
  with m_EdSSNo do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 207;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 14;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdBirthDay := TDxEdit.Create(frmMain);
  with m_EdBirthDay do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 227;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 10;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdQuiz1 := TDxEdit.Create(frmMain);
  with m_EdQuiz1 do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 163;
    Left := nX + 161;
    Top := nY + 256;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 20;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdAnswer1 := TDxEdit.Create(frmMain);
  with m_EdAnswer1 do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 163;
    Left := nX + 161;
    Top := nY + 276;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 12;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdQuiz2 := TDxEdit.Create(frmMain);
  with m_EdQuiz2 do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 163;
    Left := nX + 161;
    Top := nY + 297;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 20;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdAnswer2 := TDxEdit.Create(frmMain);
  with m_EdAnswer2 do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 163;
    Left := nX + 161;
    Top := nY + 317;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 12;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdPhone := TDxEdit.Create(frmMain);
  with m_EdPhone do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 347;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 14;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdMobPhone := TDxEdit.Create(frmMain);
  with m_EdMobPhone do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 368;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 13;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdEMail := TDxEdit.Create(frmMain);
  with m_EdEMail do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 388;
    // BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 40;
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    // OnEnter := EdNewOnEnter;
    tag := 11;
  end;}

 // nX := SCREENWIDTH div 2 - 210 {192} {192};
 // nY := SCREENHEIGHT div 2 - 150 {146} {150};

{
  with m_EdChgId do
  begin
    //Parent := frmMain;
    Height := 16;
    Width := 137;
    Left := nX + 239;
    Top := nY + 117;
    //BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 10;
    //Visible := False;
    OnKeyPress := EdNewIdKeyPress;
   // OnEnter := EdNewOnEnter;
    tag := 12;
  end;

  m_EdChgCurrentpw := TEdit.Create(frmMain.Owner);
  with m_EdChgCurrentpw do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 137;
    Left := nX + 239;
    Top := nY + 149;
    BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    tag := 12;
  end;
  m_EdChgNewPw := TEdit.Create(frmMain.Owner);
  with m_EdChgNewPw do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 137;
    Left := nX + 239;
    Top := nY + 176;
    BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    tag := 12;
  end;
  m_EdChgRepeat := TEdit.Create(frmMain.Owner);
  with m_EdChgRepeat do
  begin
    Parent := frmMain;
    Height := 16;
    Width := 137;
    Left := nX + 239;
    Top := nY + 208;
    BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := False;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    tag := 12;
  end;}
end;

destructor TLoginScene.Destroy;
begin
  inherited Destroy;
end;

procedure TLoginScene.OpenScene;
begin
  m_nCurFrame := 0;
  m_nMaxFrame := 10;
  m_sLoginId := '';
  m_sLoginPasswd := '';

  if (FrmDlg<>nil) and (not m_boOpenFirst) then
  begin
    FrmDlg.m_EdChgId.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdChgId.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdChgCurrentpw.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdChgCurrentpw.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdChgNewPw.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdChgNewPw.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdChgRepeat.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdChgRepeat.OnEntered := EdNewOnEnter;


    FrmDlg.m_EdNewId.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdNewId.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdNewPasswd.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdNewPasswd.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdConfirm.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdConfirm.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdYourName.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdYourName.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdSSNo.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdSSNo.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdBirthDay.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdBirthDay.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdQuiz1.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdQuiz1.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdAnswer1.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdAnswer1.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdQuiz2.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdQuiz2.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdAnswer2.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdAnswer2.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdPhone.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdPhone.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdMobPhone.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdMobPhone.OnEntered := EdNewOnEnter;
    FrmDlg.m_EdEMail.OnKeyPress := EdNewIdKeyPress;
    FrmDlg.m_EdEMail.OnEntered := EdNewOnEnter;
  end;
  {with m_EdPasswd do begin
    Left := SCREENWIDTH div 2 - 24 - 0;
    Top := SCREENHEIGHT div 2 - 51 - 0;
    Height := 16;
    Width := 136;
    Visible := False;
  end;}

  m_boOpenFirst := True;

  FrmDlg.DLogin.Visible := True;
  FrmDlg.DNewAccount.Visible := False;
  m_boNowOpening := False;
  g_SndMgr.PlayBKGSound(bmg_intro);

end;

procedure TLoginScene.CloseScene;
begin
  FrmDlg.DLogin.Visible := False;
  g_SndMgr.SilenceSound;
end;

procedure TLoginScene.EdLoginIdKeyPress(Sender: TObject; var Key: Char);
begin
  if byte(Key) = VK_RETURN then
  begin
    Key := #0;
    m_sLoginId := LowerCase(FrmDlg.DxEditLoginID.Caption);
    if m_sLoginId <> '' then
      SetDFocus(FrmDlg.DxEditPassword);
  end
  else if byte(Key) = VK_TAB then
  begin
    Key := #0;
    SetDFocus(FrmDlg.DxEditPassword);
  end;
end;

function RotateBits(C: Char; Bits: Integer): Char;
var
  SI: Word;
begin
  Bits := Bits mod 8;
  if Bits < 0 then
  begin
    SI := MakeWord(byte(C), 0);
    SI := SI shl Abs(Bits);
  end
  else
  begin
    SI := MakeWord(0, byte(C));
    SI := SI shr Abs(Bits);
  end;
  SI := Swap(SI);
  SI := Lo(SI) or Hi(SI);
  Result := chr(SI);
end;

procedure TLoginScene.EdLoginPasswdKeyPress(Sender: TObject; var Key: Char);
var
  //S, ss                     : string;
  iLen: Integer;
  Msg: TDefaultMessage;
  A, PwdChk, Direction, ShiftVal, PasswordDigit: Integer;
  sResult: string;
  sSend, EnStr, sKey: string;
begin
{$I '..\Common\Macros\VMPBU.inc'}
  {dwExit := 0;
  try
    Windows.GetExitCodeThread(g_ModuleDetect.HANDLE, dwExit);
  except
    ExitProcess(0);
    frmMain.Close;
    FrmDlg.free;
    frmMain.free;
    g_MySelf.free;
    Exit;
  end;
  if dwExit <> STILL_ACTIVE then begin
    ExitProcess(0);
    frmMain.Close;
    FrmDlg.free;
    frmMain.free;
    g_MySelf.free;

    UnLoadWMImagesLib();

    DScreen.Finalize;
    g_PlayScene.Finalize;
    LoginNoticeScene.Finalize;

    DScreen.free;
    IntroScene.free;
    LoginScene.free;
    SelectChrScene.free;
    g_PlayScene.free;
    g_ShakeScreen.free;
    LoginNoticeScene.free;
    g_SaveItemList.free;
    g_MenuItemList.free;
    Exit;
  end;}

  if (Key = '~') or (Key = '''') then
    Key := '_';
  if byte(Key) = VK_RETURN then
  begin
    Key := #0;
    m_sLoginId := LowerCase(FrmDlg.DxEditLoginID.Caption);
    m_sLoginPasswd := FrmDlg.DxEditPassword.Caption;
    if (m_sLoginId <> '') and (m_sLoginPasswd <> '') then
    begin
      //frmMain.SendLogin(m_sLoginId, m_sLoginPasswd);
      frmMain.LoginID := m_sLoginId;
      frmMain.LoginPasswd := m_sLoginPasswd;
      try
        //if {(@frmMain.FEncodeFunc <> nil) and} (g_pkeywords <> nil) then     //  add // 2019-09-20
        begin

          Msg := MakeDefaultMsg(CM_IDPASSWORD, 0, 0, 0, 0);
          Move(Msg, frmMain.FTempBuffer[0], 12);
          EnStr := m_sLoginId + '/' + m_sLoginPasswd;

          //MessageBox(0, PChar(g_pkeywords^), nil, 0);

          sKey := g_pkeywords^;
          PasswordDigit := 1;
          PwdChk := 0;
          for A := 1 to Length(sKey) do
            Inc(PwdChk, Ord(sKey[A]));
          sResult := EnStr;

          //if Encode then
          Direction := -1;
          //else
          //Direction := 1;

          for A := 1 to Length(sResult) do
          begin
            if Length(sKey) = 0 then
              ShiftVal := A
            else
              ShiftVal := Ord(sKey[PasswordDigit]);
            if Odd(A) then
              sResult[A] := RotateBits(sResult[A], -Direction * (ShiftVal + PwdChk))
            else
              sResult[A] := RotateBits(sResult[A], Direction * (ShiftVal + PwdChk));
            Inc(PasswordDigit);
            if PasswordDigit > Length(sKey) then
              PasswordDigit := 1;
          end;

          //MessageBox(0, PChar(sResult), nil, 0);

          iLen := Length(sResult);
          Move(sResult[1], frmMain.FTempBuffer[12], iLen);
          //frmMain.FEncodeFunc(@frmMain.FTempBuffer, iLen + 12);
          iLen := EncodeBuf(Integer(@frmMain.FTempBuffer), iLen + 12, Integer(@frmMain.FSendBuffer));
          SetLength(sSend, iLen);
          Move(frmMain.FSendBuffer[0], sSend[1], iLen);
          frmMain.SendSocket(sSend);

          //frmMain.SendSocket(EncodeMessage(Msg) + EncodeString(sResult));
        end;
      finally
        g_boSendLogin := True;
        FrmDlg.DxEditLoginID.Caption := '';
        FrmDlg.DxEditPassword.Caption := '';
      end;
    end
    else if (FrmDlg.DxEditLoginID.Visible) and (FrmDlg.DxEditLoginID.Caption = '') then
      SetDFocus(FrmDlg.DxEditLoginID);
  end
  else if byte(Key) = VK_TAB then
  begin
    Key := #0;
    SetDFocus(FrmDlg.DxEditLoginID);
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure TLoginScene.PassWdFail;
begin
  SetDFocus(FrmDlg.DxEditLoginID);
end;

function TLoginScene.NewIdCheckNewId: Boolean;
begin
  Result := True;
  FrmDlg.m_EdNewId.Text := Trim(FrmDlg.m_EdNewId.Text);
  if Length(FrmDlg.m_EdNewId.Text) < 3 then
  begin
    FrmDlg.DMessageDlg('登录帐号的长度必须大于3位.', [mbOk]);
    Beep;
    SetDFocus(FrmDlg.m_EdNewId);
    Result := False;
  end;
end;

function TLoginScene.NewIdCheckSSno: Boolean;
var
  Str, t1, t2, smon, sday: string;
  amon, aday, sex: Integer;
  flag: Boolean;
begin
  Result := True;
  Str := FrmDlg.m_EdSSNo.Text;
  Str := GetValidStr3(Str, t1, ['-']);
  GetValidStr3(Str, t2, ['-']);
  flag := True;
  if (Length(t1) = 6) and (Length(t2) = 7) then
  begin
    smon := Copy(t1, 3, 2);
    sday := Copy(t1, 5, 2);
    amon := Str_ToInt(smon, 0);
    aday := Str_ToInt(sday, 0);
    if (amon <= 0) or (amon > 12) then
      flag := False;
    if (aday <= 0) or (aday > 31) then
      flag := False;
    sex := Str_ToInt(Copy(t2, 1, 1), 0);
    if (sex <= 0) or (sex > 2) then
      flag := False;
  end
  else
    flag := False;
  if not flag then
  begin
    Beep;
    SetDFocus(FrmDlg.m_EdSSNo);
    Result := False;
  end;
end;

function TLoginScene.NewIdCheckBirthDay: Boolean;
var
  Str,syear,smon,sday: string;
  ayear, amon, aday: Integer;
  flag: Boolean;
begin
  Result := True;
  flag := True;
  Str := FrmDlg.m_EdBirthDay.Text;
  Str := GetValidStr3(Str, syear, ['/']);
  Str := GetValidStr3(Str, smon, ['/']);
  Str := GetValidStr3(Str, sday, ['/']);
  ayear := Str_ToInt(syear, 0);
  amon := Str_ToInt(smon, 0);
  aday := Str_ToInt(sday, 0);
  if (ayear <= 1890) or (ayear > 2101) then
    flag := False;
  if (amon <= 0) or (amon > 12) then
    flag := False;
  if (aday <= 0) or (aday > 31) then
    flag := False;
  if not flag then
  begin
    Beep;
    SetDFocus(FrmDlg.m_EdBirthDay);
    Result := False;
  end;
end;

procedure TLoginScene.EdNewIdKeyPress(Sender: TObject; var Key: Char);
begin
  if (Sender = FrmDlg.m_EdNewPasswd) or (Sender = FrmDlg.m_EdChgNewPw) or (Sender = FrmDlg.m_EdChgRepeat) then
    if (Key = '~') or (Key = '''') or (Key = ' ') then
      Key := #0;



  if Key = #13 then
  begin
    Key := #0;
    if Sender = FrmDlg.m_EdNewId then
    begin
      if not NewIdCheckNewId then
        Exit;
    end;
    if Sender = FrmDlg.m_EdNewPasswd then
    begin
      if Length(FrmDlg.m_EdNewPasswd.Text) < 4 then
      begin
        FrmDlg.DMessageDlg('密码长度必须大于 4位.', [mbOk]);
        Beep;
         SetDFocus(FrmDlg.m_EdNewPasswd);
        Exit;
      end;
    end;
    if Sender = FrmDlg.m_EdConfirm then
    begin
      if FrmDlg.m_EdNewPasswd.Text <> FrmDlg.m_EdConfirm.Text then
      begin
        FrmDlg.DMessageDlg('二次输入的密码不一至！！！', [mbOk]);
        Beep;
        SetDFocus(FrmDlg.m_EdConfirm);
        Exit;
      end;
    end;
    if (Sender = FrmDlg.m_EdYourName) or (Sender = FrmDlg.m_EdQuiz1) or (Sender = FrmDlg.m_EdAnswer1) or
      (Sender = FrmDlg.m_EdQuiz2) or (Sender = FrmDlg.m_EdAnswer2) or (Sender = FrmDlg.m_EdPhone) or
      (Sender = FrmDlg.m_EdMobPhone) or (Sender = FrmDlg.m_EdEMail) then
    begin
      TDxEdit(Sender).Text := Trim(TDxEdit(Sender).Text);
      if TDxEdit(Sender).Text = '' then
      begin
        Beep;
        SetDFocus(TDxEdit(Sender));
        Exit;
      end;
    end;
    if (Sender = FrmDlg.m_EdSSNo) and (not EnglishVersion) then
    begin //茄惫牢 版快.. 林刮殿废锅龋 埃帆 盲农
      if not NewIdCheckSSno then
        Exit;
    end;
    if Sender = FrmDlg.m_EdBirthDay then
    begin
      if not NewIdCheckBirthDay then
        Exit;
    end;
    if TDxEdit(Sender).Text <> '' then
    begin
      if Sender = FrmDlg.m_EdNewId then
        SetDFocus(FrmDlg.m_EdNewPasswd);
      if Sender = FrmDlg.m_EdNewPasswd then
        SetDFocus(FrmDlg.m_EdConfirm);
      if Sender = FrmDlg.m_EdConfirm then
        SetDFocus(FrmDlg.m_EdYourName);
      if Sender = FrmDlg.m_EdYourName then
      //  SetDFocus(FrmDlg.m_EdSSNo);
      //if Sender = FrmDlg.m_EdSSNo then
        SetDFocus(FrmDlg.m_EdBirthDay);
      if Sender = FrmDlg.m_EdBirthDay then
        SetDFocus(FrmDlg.m_EdQuiz1);
      if Sender = FrmDlg.m_EdQuiz1 then
        SetDFocus(FrmDlg.m_EdAnswer1);
      if Sender = FrmDlg.m_EdAnswer1 then
        SetDFocus(FrmDlg.m_EdQuiz2);
      if Sender = FrmDlg.m_EdQuiz2 then
        SetDFocus(FrmDlg.m_EdAnswer2);
      if Sender = FrmDlg.m_EdAnswer2 then
        SetDFocus(FrmDlg.m_EdPhone);
      if Sender = FrmDlg.m_EdPhone then
        SetDFocus(FrmDlg.m_EdMobPhone);
      if Sender = FrmDlg.m_EdMobPhone then
        SetDFocus(FrmDlg.m_EdEMail);
      if Sender = FrmDlg.m_EdEMail then
      begin
        if FrmDlg.m_EdNewId.Enabled then
          SetDFocus(FrmDlg.m_EdNewId)
        else if FrmDlg.m_EdNewPasswd.Enabled then
          SetDFocus(FrmDlg.m_EdNewPasswd);
      end;

      if Sender = FrmDlg.m_EdChgId then
        SetDFocus(FrmDlg.m_EdChgCurrentpw);
      if Sender = FrmDlg.m_EdChgCurrentpw then
        SetDFocus(FrmDlg.m_EdChgNewPw);
      if Sender = FrmDlg.m_EdChgNewPw then
        SetDFocus(FrmDlg.m_EdChgRepeat);
      if Sender = FrmDlg.m_EdChgRepeat then
        SetDFocus(FrmDlg.m_EdChgId);


    end;
  end;


end;

procedure TLoginScene.EdNewOnEnter(Sender: TObject);
begin
  FrmDlg.NAHelps.Clear;
  // hx := TDxEdit(Sender).Left + TDxEdit(Sender).Width + 10;
  // hy := TDxEdit(Sender).Top + TDxEdit(Sender).Height - 18;
  if Sender = FrmDlg.m_EdNewId then
  begin
    FrmDlg.NAHelps.Add('您的帐号名称可以包括：');
    FrmDlg.NAHelps.Add('字符、数字的组合。');
    FrmDlg.NAHelps.Add('帐号名称长度必须为4或以上。');
    FrmDlg.NAHelps.Add('登陆帐号并游戏中的人物名称。');
    FrmDlg.NAHelps.Add('请仔细输入创建帐号所需信息。');
    FrmDlg.NAHelps.Add('您的登陆帐号可以登陆游戏');
    FrmDlg.NAHelps.Add('及我们网站，以取得一些相关信息。');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('建议您的登陆帐号不要与游戏中的角');
    FrmDlg.NAHelps.Add('色名相同，');
    FrmDlg.NAHelps.Add('以确保你的密码不会被爆力破解。');
  end;
  if Sender = FrmDlg.m_EdNewPasswd then
  begin
    FrmDlg.NAHelps.Add('您的密码可以是字符及数字的组合，');
    FrmDlg.NAHelps.Add('但密码长度必须至少4位。');
    FrmDlg.NAHelps.Add('建议您的密码内容不要过于简单，');
    FrmDlg.NAHelps.Add('以防被人猜到。');
    FrmDlg.NAHelps.Add('请记住您输入的密码，如果丢失密码');
    FrmDlg.NAHelps.Add('将无法登录游戏。');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = FrmDlg.m_EdConfirm then
  begin
    FrmDlg.NAHelps.Add('再次输入密码');
    FrmDlg.NAHelps.Add('以确认。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = FrmDlg.m_EdYourName then
  begin
    FrmDlg.NAHelps.Add('请输入您的全名.');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = FrmDlg.m_EdSSNo then
  begin
    FrmDlg.NAHelps.Add('请输入你的身份证号');
    FrmDlg.NAHelps.Add('例如： 720101-146720');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = FrmDlg.m_EdBirthDay then
  begin
    FrmDlg.NAHelps.Add('请输入您的生日');
    FrmDlg.NAHelps.Add('例如：1977/10/15');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = FrmDlg.m_EdQuiz1 then
  begin
    FrmDlg.NAHelps.Add('请输入第一个密码提示问题');
    FrmDlg.NAHelps.Add('这个提示将用于密码丢失后找');
    FrmDlg.NAHelps.Add('回密码用。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = FrmDlg.m_EdAnswer1 then
  begin
    FrmDlg.NAHelps.Add('请输入上面问题的');
    FrmDlg.NAHelps.Add('答案。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = FrmDlg.m_EdQuiz2 then
  begin
    FrmDlg.NAHelps.Add('请输入第二个密码提示问题');
    FrmDlg.NAHelps.Add('这个提示将用于密码丢失后找');
    FrmDlg.NAHelps.Add('回密码用。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = FrmDlg.m_EdAnswer2 then
  begin
    FrmDlg.NAHelps.Add('请输入上面问题的');
    FrmDlg.NAHelps.Add('答案。');
    FrmDlg.NAHelps.Add('');
  end;
  if (Sender = FrmDlg.m_EdYourName) or (Sender = FrmDlg.m_EdSSNo) or (Sender = FrmDlg.m_EdQuiz1) or (Sender = FrmDlg.m_EdQuiz2) or (Sender = FrmDlg.m_EdAnswer1) or (Sender = FrmDlg.m_EdAnswer2) then
  begin
    FrmDlg.NAHelps.Add('您输入的信息必须真实正确的信息');
    FrmDlg.NAHelps.Add('如果使用了虚假的注册信息');
    FrmDlg.NAHelps.Add('您的帐号将被取消。');
    FrmDlg.NAHelps.Add('');
  end;

  if Sender = FrmDlg.m_EdPhone then
  begin
    FrmDlg.NAHelps.Add('请输入您的电话');
    FrmDlg.NAHelps.Add('号码。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = FrmDlg.m_EdMobPhone then
  begin
    FrmDlg.NAHelps.Add('请输入您的手机号码。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = FrmDlg.m_EdEMail then
  begin
    FrmDlg.NAHelps.Add('请输入您的邮件地址。您的邮件将被');
    FrmDlg.NAHelps.Add('接收最近更新的一些信息');
    FrmDlg.NAHelps.Add('');
  end;
end;

procedure TLoginScene.HideLoginBox;
begin
  ChangeLoginState(lsCloseAll);
end;

procedure TLoginScene.OpenLoginDoor;
begin
  m_boNowOpening := True;
  m_dwStartTime := GetTickCount;
  HideLoginBox;
  g_SndMgr.PlaySound(s_rock_door_open);
end;

procedure TLoginScene.PlayScene(MSurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  if m_boOpenFirst then
  begin
    m_boOpenFirst := False;
    SetDFocus(FrmDlg.DxEditLoginID);
  end;
{$IF CUSTOMLIBFILE = 1}
  d := g_WMainImages.Images[83];
{$ELSE}
  d := g_WChrSelImages.Images[22 {381}];
{$IFEND}
  if d <> nil then
  begin
    MSurface.Draw((SCREENWIDTH - 800) div 2, (SCREENHEIGHT - 600) div 2, d.ClientRect, d, False);
  end;
  if m_boNowOpening then
  begin
    if GetTickCount - m_dwStartTime > 28 then
    begin
      m_dwStartTime := GetTickCount;
      Inc(m_nCurFrame);
    end;
    if m_nCurFrame >= m_nMaxFrame - 1 then
    begin
      m_nCurFrame := m_nMaxFrame - 1;
      if not g_boDoFadeOut and not g_boDoFadeIn then
      begin
        g_boDoFadeOut := True;
        g_boDoFadeIn := True;
        g_nFadeIndex := 29;
      end;
    end;
    d := g_WChrSelImages.Images[103 + m_nCurFrame - 80];
    if d <> nil then
      MSurface.Draw((SCREENWIDTH - 800) div 2 + 152, (SCREENHEIGHT - 600) div 2 + 96, d.ClientRect, d, True);
    if g_boDoFadeOut then
    begin
      if g_nFadeIndex <= 1 then
      begin
        g_WMainImages.ClearCache;
        g_WChrSelImages.ClearCache;
        //if g_Logined then FrmDlg.DscStart.tag := FrmDlg.DscStart.WLib.Images[FrmDlg.DscStart.FaceIndex].Height;
        if g_Logined then
          FrmDlg.DscStart.tag := FrmDlg.DscStart.WLib.Images[FrmDlg.DscStart.FaceIndex].Height;
          //FrmDlg.DscStart.tag := FrmDlg.DscStart.ULib.Images[Format(g_sDscStart, [byte(FrmDlg.DscStart.Downed)])].Height;
        if not g_boDoFadeOut and not g_boDoFadeIn then
        begin
          //g_boDoFadeOut := True;
          g_boDoFadeIn := True;
          g_nFadeIndex := 0;
        end;
        DScreen.ChangeScene(stSelectChr);
      end;
    end;
  end;
end;

procedure TLoginScene.ChangeLoginState(State: TLoginState);
var
  i, focus: Integer;
  C: TControl;
begin
  focus := -1;
  case State of
    lsLogin: focus := 10;
    lsNewidRetry, lsNewid: focus := 11;
    lsChgpw: focus := 12;
    lsCloseAll: focus := -1;
  end;
  with frmMain do
  begin //login
    for i := 0 to ControlCount - 1 do
    begin
      C := Controls[i];
      if C is TEdit then
      begin
        if C.tag in [10..12] then
        begin
          if C.tag = focus then
          begin
            C.Visible := True;
            TEdit(C).Text := '';
          end
          else
          begin
            C.Visible := False;
            TEdit(C).Text := '';
          end;
        end;
      end;
    end;
    if EnglishVersion then
      FrmDlg.m_EdSSNo.Visible := False;

    case State of
      lsLogin:
        begin
          FrmDlg.DNewAccount.Visible := False;
          FrmDlg.DChgPw.Visible := False;
          FrmDlg.DLogin.Visible := True;
          if FrmDlg.DxEditLoginID.Visible then
            SetDFocus(FrmDlg.DxEditLoginID);
        end;
      lsNewidRetry,
        lsNewid:
        begin
          //if m_boUpdateAccountMode then
          //  m_EdNewId.Enabled := False
          //else
          FrmDlg.m_EdNewId.Enabled := True;
          FrmDlg.DNewAccount.Visible := True;
          FrmDlg.DChgPw.Visible := False;
          FrmDlg.DLogin.Visible := False;
          if FrmDlg.m_EdNewId.Visible and FrmDlg.m_EdNewId.Enabled then
          begin
            FrmDlg.m_EdNewId.SetFocus;
          end
          else
          begin
            if FrmDlg.m_EdConfirm.Visible and FrmDlg.m_EdConfirm.Enabled then
              FrmDlg.m_EdConfirm.SetFocus;
          end;
        end;
      lsChgpw:
        begin
          FrmDlg.DNewAccount.Visible := False;
          FrmDlg.DChgPw.Visible := True;
          FrmDlg.DLogin.Visible := False;
       //   if m_EdChgId.Visible then
        //    m_EdChgId.SetFocus;
        end;
      lsCloseAll:
        begin
          FrmDlg.DNewAccount.Visible := False;
          FrmDlg.DChgPw.Visible := False;
          FrmDlg.DLogin.Visible := False;
        end;
    end;
  end;
end;

procedure TLoginScene.NewClick;
begin
  //m_boUpdateAccountMode := False;
  FrmDlg.NewAccountTitle := '';
  ChangeLoginState(lsNewid);
end;

procedure TLoginScene.NewIdRetry(boupdate: Boolean);
begin
  //m_boUpdateAccountMode := boupdate;
  ChangeLoginState(lsNewidRetry);
  FrmDlg.m_EdNewId.Text := m_NewIdRetryUE.sAccount;
  FrmDlg.m_EdNewPasswd.Text := m_NewIdRetryUE.sPassword;
  FrmDlg.m_EdYourName.Text := m_NewIdRetryUE.sUserName;
  FrmDlg.m_EdSSNo.Text := m_NewIdRetryUE.sSSNo;
  FrmDlg.m_EdQuiz1.Text := m_NewIdRetryUE.sQuiz;
  FrmDlg.m_EdAnswer1.Text := m_NewIdRetryUE.sAnswer;
  FrmDlg.m_EdPhone.Text := m_NewIdRetryUE.sPhone;
  FrmDlg.m_EdEMail.Text := m_NewIdRetryUE.sEMail;
  FrmDlg.m_EdQuiz2.Text := m_NewIdRetryAdd.sQuiz2;
  FrmDlg.m_EdAnswer2.Text := m_NewIdRetryAdd.sAnswer2;
  FrmDlg.m_EdMobPhone.Text := m_NewIdRetryAdd.sMobilePhone;
  FrmDlg.m_EdBirthDay.Text := m_NewIdRetryAdd.sBirthDay;
end;

procedure TLoginScene.UpdateAccountInfos(ue: TUserEntry);
begin
  m_NewIdRetryUE := ue;
  FillChar(m_NewIdRetryAdd, SizeOf(TUserEntryAdd), #0);
  //m_boUpdateAccountMode := True;
  NewIdRetry(True);
  FrmDlg.NewAccountTitle := '(请填写帐号相关信息)';
end;

procedure TLoginScene.OkClick;
var
  Key: Char;
begin
  Key := #13;
  EdLoginPasswdKeyPress(Self, Key);
end;

procedure TLoginScene.ChgPwClick;
begin
  ChangeLoginState(lsChgpw);
end;

function TLoginScene.CheckUserEntrys: Boolean;
begin
  Result := False;
  FrmDlg.m_EdNewId.Text := Trim(FrmDlg.m_EdNewId.Text);
  FrmDlg.m_EdQuiz1.Text := Trim(FrmDlg.m_EdQuiz1.Text);
  FrmDlg.m_EdYourName.Text := Trim(FrmDlg.m_EdYourName.Text);
  if not NewIdCheckNewId then
    Exit;

  if not EnglishVersion then
  begin
    if not NewIdCheckSSno then
      Exit;
  end;

  if not NewIdCheckBirthDay then
    Exit;
  if Length(FrmDlg.m_EdNewId.Text) < 3 then
  begin
    FrmDlg.m_EdNewId.SetFocus;
    Exit;
  end;
  if Length(FrmDlg.m_EdNewPasswd.Text) < 3 then
  begin
    FrmDlg.m_EdNewPasswd.SetFocus;
    Exit;
  end;
  if FrmDlg.m_EdNewPasswd.Text <> FrmDlg.m_EdConfirm.Text then
  begin
    FrmDlg.m_EdConfirm.SetFocus;
    Exit;
  end;
  if Length(FrmDlg.m_EdQuiz1.Text) < 1 then
  begin
    FrmDlg.m_EdQuiz1.SetFocus;
    Exit;
  end;
  if Length(FrmDlg.m_EdAnswer1.Text) < 1 then
  begin
    FrmDlg.m_EdAnswer1.SetFocus;
    Exit;
  end;
  if Length(FrmDlg.m_EdQuiz2.Text) < 1 then
  begin
    FrmDlg.m_EdQuiz2.SetFocus;
    Exit;
  end;
  if Length(FrmDlg.m_EdAnswer2.Text) < 1 then
  begin
    FrmDlg.m_EdAnswer2.SetFocus;
    Exit;
  end;
  if Length(FrmDlg.m_EdYourName.Text) < 1 then
  begin
    FrmDlg.m_EdYourName.SetFocus;
    Exit;
  end;
  if not EnglishVersion then
  begin
    if Length(FrmDlg.m_EdSSNo.Text) < 1 then
    begin
      FrmDlg.m_EdSSNo.SetFocus;
      Exit;
    end;
  end;
  Result := True;
end;

procedure TLoginScene.NewAccountOk;
var
  ue: TUserEntry;
  ua: TUserEntryAdd;
begin
  if CheckUserEntrys then
  begin
    FillChar(ue, SizeOf(TUserEntry), #0);
    FillChar(ua, SizeOf(TUserEntryAdd), #0);
    ue.sAccount := LowerCase(FrmDlg.m_EdNewId.Text);
    ue.sPassword := FrmDlg.m_EdNewPasswd.Text;
    ue.sUserName := FrmDlg.m_EdYourName.Text;

    if not EnglishVersion then
      ue.sSSNo := FrmDlg.m_EdSSNo.Text
    else
      ue.sSSNo := '650101-1455111';

    ue.sQuiz := FrmDlg.m_EdQuiz1.Text;
    ue.sAnswer := Trim(FrmDlg.m_EdAnswer1.Text);
    ue.sPhone := FrmDlg.m_EdPhone.Text;
    ue.sEMail := Trim(FrmDlg.m_EdEMail.Text);

    ua.sQuiz2 := FrmDlg.m_EdQuiz2.Text;
    ua.sAnswer2 := Trim(FrmDlg.m_EdAnswer2.Text);
    ua.sBirthDay := FrmDlg.m_EdBirthDay.Text;
    ua.sMobilePhone := FrmDlg.m_EdMobPhone.Text;

    m_NewIdRetryUE := ue;
    m_NewIdRetryUE.sAccount := '';
    m_NewIdRetryUE.sPassword := '';
    m_NewIdRetryAdd := ua;

    //if not m_boUpdateAccountMode then
    frmMain.SendNewAccount(ue, ua);
    //else
    //  frmMain.SendUpdateAccount(ue, ua);
    //m_boUpdateAccountMode := False;
    NewAccountClose;
  end;
end;

procedure TLoginScene.NewAccountClose;
begin
  //if not m_boUpdateAccountMode then
  ChangeLoginState(lsLogin);
end;

procedure TLoginScene.ChgpwOk;
var
  uid, passwd, newpasswd: string;
begin
  if FrmDlg.m_EdChgNewPw.Text = FrmDlg.m_EdChgRepeat.Text then
  begin
    uid := FrmDlg.m_EdChgId.Text;
    passwd := FrmDlg.m_EdChgCurrentpw.Text;
    newpasswd := FrmDlg.m_EdChgNewPw.Text;
    frmMain.SendChgPw(uid, passwd, newpasswd);
    ChgpwCancel;
  end
  else
  begin
    FrmDlg.DMessageDlg('二次输入的密码不匹配！！！。', [mbOk]);
    FrmDlg.m_EdChgNewPw.SetFocus;
  end;
end;

procedure TLoginScene.ChgpwCancel;
begin
  ChangeLoginState(lsLogin);
end;

{-------------------- TSelectChrScene ------------------------}

constructor TSelectChrScene.Create;
begin
  CreateChrMode := False;
  FillChar(ChrArr, SizeOf(TSelChar) * 2, #0);
  ChrArr[0].FreezeState := True;
  ChrArr[1].FreezeState := True;
  NewIndex := 0;

  {EdChrName := TEdit.Create(frmMain.Owner);
  with EdChrName do begin
    Parent := frmMain;
    Height := 16;
    Width := 137;
    BorderStyle := bsNone;
    Color := clblack;
    Font.Color := clWhite;
    MaxLength := 14;
    Visible := False;
    OnKeyPress := EdChrnameKeyPress;
  end;}

  SoundTimer := TTimer.Create(frmMain.Owner);
  with SoundTimer do
  begin
    OnTimer := SoundOnTimer;
    Interval := 1;
    Enabled := False;
  end;
  inherited Create(stSelectChr);
end;

destructor TSelectChrScene.Destroy;
begin
  inherited Destroy;
end;

procedure TSelectChrScene.OpenScene;
begin
  FrmDlg.DSelectChr.Visible := True;
  SoundTimer.Enabled := True;
  SoundTimer.Interval := 1;
end;

procedure TSelectChrScene.CloseScene;
begin
  g_SndMgr.SilenceSound;
  FrmDlg.DSelectChr.Visible := False;
  SoundTimer.Enabled := False;
end;

procedure TSelectChrScene.SoundOnTimer(Sender: TObject);
begin
  g_SndMgr.PlayBKGSound(bmg_select);
  SoundTimer.Enabled := False;
end;

procedure TSelectChrScene.SelChrSelect1Click;
begin
  if (not ChrArr[0].Selected) and (ChrArr[0].Valid) and ChrArr[0].FreezeState then
  begin
    frmMain.SelectChr(ChrArr[0].UserChr.Name); //2004/05/17
    ChrArr[0].Selected := True;
    ChrArr[1].Selected := False;
    ChrArr[0].Unfreezing := True;
    ChrArr[0].AniIndex := 0;
    ChrArr[0].DarkLevel := 0;
    ChrArr[0].EffIndex := 0;
    ChrArr[0].StartTime := GetTickCount;
    ChrArr[0].moretime := GetTickCount;
    ChrArr[0].startefftime := GetTickCount;
    g_SndMgr.PlaySound(s_meltstone);
  end;
end;

procedure TSelectChrScene.SelChrSelect2Click;
begin
  if (not ChrArr[1].Selected) and (ChrArr[1].Valid) and ChrArr[1].FreezeState then
  begin
    frmMain.SelectChr(ChrArr[1].UserChr.Name); //2004/05/17
    ChrArr[1].Selected := True;
    ChrArr[0].Selected := False;
    ChrArr[1].Unfreezing := True;
    ChrArr[1].AniIndex := 0;
    ChrArr[1].DarkLevel := 0;
    ChrArr[1].EffIndex := 0;
    ChrArr[1].StartTime := GetTickCount;
    ChrArr[1].moretime := GetTickCount;
    ChrArr[1].startefftime := GetTickCount;
    g_SndMgr.PlaySound(s_meltstone);
  end;
end;

procedure TSelectChrScene.SelChrStartClick;
var
  chrname: string;
begin
{$IFNDEF TEST}
  if FrmDlg.DscStart.tag > 0 then
    Exit;
{$ENDIF}
  chrname := '';
  if ChrArr[0].Valid and ChrArr[0].Selected then
    chrname := ChrArr[0].UserChr.Name;
  if ChrArr[1].Valid and ChrArr[1].Selected then
    chrname := ChrArr[1].UserChr.Name;
  if chrname <> '' then
  begin
    if not g_boDoFadeOut and not g_boDoFadeIn then
    begin
      g_boDoFastFadeOut := True;
      g_nFadeIndex := 29;
    end;
    frmMain.SendSelChr(chrname);
  end
  else
    FrmDlg.DMessageDlg('开始游戏前你应该先创建一个新角色！\点击<创建角色>按钮创建一个游戏角色。', [mbOk]);
end;

procedure TSelectChrScene.SelChrNewChrClick;
begin
  if not ChrArr[0].Valid or not ChrArr[1].Valid then
  begin
    if not ChrArr[0].Valid then
      MakeNewChar(0)
    else
      MakeNewChar(1);
  end
  else
    FrmDlg.DMessageDlg('一个帐号最多只能创建 2 个游戏角色！', [mbOk]);
end;

procedure TSelectChrScene.SelChrEraseChrClick;
var
  n: Integer;
begin
  n := 0;
  if ChrArr[0].Valid and ChrArr[0].Selected then
    n := 0;
  if ChrArr[1].Valid and ChrArr[1].Selected then
    n := 1;
  if (ChrArr[n].Valid) and (not ChrArr[n].FreezeState) and (ChrArr[n].UserChr.Name <> '') then
  begin
    if mrYes = FrmDlg.DMessageDlg('"' + ChrArr[n].UserChr.Name + '" 是否确认删除此游戏角色？', [mbYes, mbNo]) then
      frmMain.SendDelChr(ChrArr[n].UserChr.Name);
  end;
end;

procedure TSelectChrScene.SelChrCreditsClick;
begin

  //[失败] 没有找到被删除的角色。
  //[失败] 客户端版本错误。
  //[失败] 你没有这个角色。
  //[失败] 角色已被删除。
  //[失败] 角色数据读取失败，请稍候再试。
  //[失败] 你选择的服务器用户满员。
  {if not ChrArr[0].Valid or not ChrArr[1].Valid then begin
    if not ChrArr[0].Valid then
      MakeNewChar(0)
    else
      MakeNewChar(1);
  end else
    FrmDlg.DMessageDlg('一个帐号最多只能创建二个游戏角色！', [mbOk]);}
end;

procedure TSelectChrScene.SelChrExitClick;
begin
  frmMain.Close;
end;

procedure TSelectChrScene.ClearChrs;
begin
  FillChar(ChrArr, SizeOf(TSelChar) * 2, #0);
  ChrArr[0].FreezeState := False;
  ChrArr[1].FreezeState := True; //扁夯捞 倔绢 乐绰 惑怕
  ChrArr[0].Selected := True;
  ChrArr[1].Selected := False;
  ChrArr[0].UserChr.Name := '';
  ChrArr[1].UserChr.Name := '';
end;

procedure TSelectChrScene.AddChr(uname: string; job, hair, Level, sex: Integer);
var
  n: Integer;
begin
  if not ChrArr[0].Valid then
    n := 0
  else if not ChrArr[1].Valid then
    n := 1
  else
    Exit;
  ChrArr[n].UserChr.Name := uname;
  ChrArr[n].UserChr.job := job;
  ChrArr[n].UserChr.hair := hair;
  ChrArr[n].UserChr.Level := Level;
  ChrArr[n].UserChr.sex := sex;
  ChrArr[n].Valid := True;
end;

procedure TSelectChrScene.MakeNewChar(Index: Integer);   //   创建角色界面显示问题   2019-11-15 17:32:33
begin
  CreateChrMode := True;
  NewIndex := Index;
  if Index = 0 then
  begin
    FrmDlg.DCreateChr.Left := (SCREENWIDTH div 2) + 15;    // 415;
    FrmDlg.DCreateChr.Top := (SCREENHEIGHT - 600) div 2  + 15  ; // 15
  end
  else
  begin
    FrmDlg.DCreateChr.Left := ((SCREENWIDTH div 2) -  FrmDlg.DCreateChr.Width) - 15 ;     //75;
    FrmDlg.DCreateChr.Top := (SCREENHEIGHT - 600) div 2  + 15; // 15
  end;
  FrmDlg.DCreateChr.Visible := True;
  ChrArr[NewIndex].Valid := True;
  ChrArr[NewIndex].FreezeState := False;
  //EdChrName.Left := FrmDlg.DCreateChr.Left + 71;
  //EdChrName.Top := FrmDlg.DCreateChr.Top + 107;
  //EdChrName.Visible := True;
  FrmDlg.DxEdChrName.SetFocus;
  SelectChr(NewIndex);
  FillChar(ChrArr[NewIndex].UserChr, SizeOf(TUserCharacterInfo), #0);
end;

{procedure TSelectChrScene.EdChrnameKeyPress(Sender: TObject; var Key: Char);
begin

end;}

procedure TSelectChrScene.SelectChr(Index: Integer);
begin
  ChrArr[Index].Selected := True;
  ChrArr[Index].DarkLevel := 30;
  ChrArr[Index].StartTime := GetTickCount;
  ChrArr[Index].moretime := GetTickCount;
  if Index = 0 then
    ChrArr[1].Selected := False
  else
    ChrArr[0].Selected := False;
end;

procedure TSelectChrScene.SelChrNewClose;
begin
  ChrArr[NewIndex].Valid := False;
  CreateChrMode := False;
  FrmDlg.DCreateChr.Visible := False;
  //EdChrName.Visible := False;
  ChrArr[NewIndex].Selected := True;
  ChrArr[NewIndex].FreezeState := False;
end;

procedure TSelectChrScene.SelChrNewOk;
var
  chrname, shair, sjob, ssex: string;
  s: IStrings;
begin
{$I '..\Common\Macros\VMPB.inc'}

  s := IStrings.Create;
  try
    //s.LoadFromFile(Application.ExeName);
{$IF CHECKPACKED} {if Pos('lscfg.ini', s.Text) <> 0 then
      ExitProcess(0)
else}{$IFEND}begin
      chrname := Trim(FrmDlg.DxEdChrName.Text);
      if chrname <> '' then
      begin
        ChrArr[NewIndex].Valid := False;
        CreateChrMode := False;
        FrmDlg.DCreateChr.Visible := False;
        //EdChrName.Visible := False;
        ChrArr[NewIndex].Selected := True;
        ChrArr[NewIndex].FreezeState := False;
        shair := IntToStr(1 + Random(5)); //////****IntToStr(ChrArr[NewIndex].UserChr.Hair);
        sjob := IntToStr(ChrArr[NewIndex].UserChr.job);
        ssex := IntToStr(ChrArr[NewIndex].UserChr.sex);
        frmMain.SendNewChr(frmMain.LoginID, chrname, shair, sjob, ssex); //货 某腐磐甫 父电促.
      end;
    end;
  finally
    s.free;
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure TSelectChrScene.SelChrNewJob(job: Integer);
begin
  if (job in [0..2]) and (ChrArr[NewIndex].UserChr.job <> job) then
  begin
    ChrArr[NewIndex].UserChr.job := job;
    SelectChr(NewIndex);
  end;
end;

procedure TSelectChrScene.SelChrNewm_btSex(sex: Integer);
begin
  if sex <> ChrArr[NewIndex].UserChr.sex then
  begin
    ChrArr[NewIndex].UserChr.sex := sex;
    SelectChr(NewIndex);
  end;
end;

procedure TSelectChrScene.SelChrNewPrevHair;
begin
end;

procedure TSelectChrScene.SelChrNewNextHair;
begin
end;

procedure TSelectChrScene.PlayScene(MSurface: TDirectDrawSurface);
var
  n, bx, by, fx, fy, img: Integer;
  ex, ey: Integer; //选择人物时显示的效果光位置
  d, E, dd: TDirectDrawSurface;
  svname: string;
begin
  if g_boOpenAutoPlay and (g_nAPReLogon = 2) then
  begin //0613
    if GetTickCount - g_nAPReLogonWaitTick > g_nAPReLogonWaitTime then
    begin
      g_nAPReLogonWaitTick := GetTickCount;
      g_nAPReLogon := 3;
      if not g_boDoFadeOut and not g_boDoFadeIn then
      begin
        g_boDoFastFadeOut := True;
        g_nFadeIndex := 29;
      end;
      frmMain.SendSelChr(frmMain.m_sCharName);
    end;
  end;

  bx := 0;
  by := 0;
  fx := 0;
  fy := 0;
  d := g_WMain3Images.Images[400];
  if d <> nil then
  begin
    MSurface.Draw((SCREENWIDTH - d.Width) div 2, (SCREENHEIGHT - d.Height) div 2, d.ClientRect, d, False);
  end;
  //Tips.dat

  for n := 0 to 1 do
  begin
    if ChrArr[n].Valid then
    begin
      ex := (SCREENWIDTH - 800) div 2 + 90 {90};
      ey := (SCREENHEIGHT - 600) div 2 + 60 - 2 {60-2};
      case ChrArr[n].UserChr.job of
        0:
          begin
            if ChrArr[n].UserChr.sex = 0 then
            begin
              bx := (SCREENWIDTH - 800) div 2 + 71 {71};
              by := (SCREENHEIGHT - 600) div 2 + 75 - 23 {75-23};
              fx := bx;
              fy := by;
            end
            else
            begin
              bx := (SCREENWIDTH - 800) div 2 + 65 {65};
              by := (SCREENHEIGHT - 600) div 2 + 75 - 2 - 18;
              fx := bx - 28 + 28;
              fy := by - 16 + 16;
            end;
          end;
        1:
          begin
            if ChrArr[n].UserChr.sex = 0 then
            begin
              bx := (SCREENWIDTH - 800) div 2 + 77 {77};
              by := (SCREENHEIGHT - 600) div 2 + 75 - 29;
              fx := bx;
              fy := by;
            end
            else
            begin
              bx := (SCREENWIDTH - 800) div 2 + 141 + 30;
              by := (SCREENHEIGHT - 600) div 2 + 85 + 14 - 2;
              fx := bx - 30;
              fy := by - 14;
            end;
          end;
        2:
          begin
            if ChrArr[n].UserChr.sex = 0 then
            begin
              bx := (SCREENWIDTH - 800) div 2 + 85;
              by := (SCREENHEIGHT - 600) div 2 + 75 - 12;
              fx := bx;
              fy := by;
            end
            else
            begin
              bx := (SCREENWIDTH - 800) div 2 + 141 + 23;
              by := (SCREENHEIGHT - 600) div 2 + 85 + 20 - 2;
              fx := bx - 23;
              fy := by - 20;
            end;
          end;
      end;
      if n = 1 then
      begin
        ex := (SCREENWIDTH - 800) div 2 + 430;
        ey := (SCREENHEIGHT - 600) div 2 + 60;
        bx := bx + 340;
        by := by + 2;
        fx := fx + 340;
        fy := fy + 2;
      end;
      if ChrArr[n].Unfreezing then
      begin
        img := 140 - 80 + ChrArr[n].UserChr.job * 40 + ChrArr[n].UserChr.sex * 120;
        d := g_WChrSelImages.Images[img + ChrArr[n].AniIndex];
        E := g_WChrSelImages.Images[4 + ChrArr[n].EffIndex];
        if d <> nil then
          MSurface.Draw(bx, by, d.ClientRect, d, True);
        if E <> nil then
          DrawBlend(MSurface, ex, ey, E, 1);
        if GetTickCount - ChrArr[n].StartTime > 110 then
        begin
          ChrArr[n].StartTime := GetTickCount;
          ChrArr[n].AniIndex := ChrArr[n].AniIndex + 1;
        end;
        if GetTickCount - ChrArr[n].startefftime > 110 then
        begin
          ChrArr[n].startefftime := GetTickCount;
          ChrArr[n].EffIndex := ChrArr[n].EffIndex + 1;
        end;
        if ChrArr[n].AniIndex > FREEZEFRAME - 1 then
        begin
          ChrArr[n].Unfreezing := False;
          ChrArr[n].FreezeState := False;
          ChrArr[n].AniIndex := 0;
        end;
      end
      else if not ChrArr[n].Selected and (not ChrArr[n].FreezeState and not ChrArr[n].Freezing) then
      begin
        ChrArr[n].Freezing := True;
        ChrArr[n].AniIndex := 0;
        ChrArr[n].StartTime := GetTickCount;
      end;
      if ChrArr[n].Freezing then
      begin
        img := 140 - 80 + ChrArr[n].UserChr.job * 40 + ChrArr[n].UserChr.sex * 120;
        d := g_WChrSelImages.Images[img + FREEZEFRAME - ChrArr[n].AniIndex - 1];
        if d <> nil then
          MSurface.Draw(bx, by, d.ClientRect, d, True);
        if GetTickCount - ChrArr[n].StartTime > 110 then
        begin
          ChrArr[n].StartTime := GetTickCount;
          ChrArr[n].AniIndex := ChrArr[n].AniIndex + 1;
        end;
        if ChrArr[n].AniIndex > FREEZEFRAME - 1 then
        begin
          ChrArr[n].Freezing := False;
          ChrArr[n].FreezeState := True;
          ChrArr[n].AniIndex := 0;
        end;
      end;
      if not ChrArr[n].Unfreezing and not ChrArr[n].Freezing then
      begin
        if not ChrArr[n].FreezeState then
        begin
          img := 120 - 80 + ChrArr[n].UserChr.job * 40 + ChrArr[n].AniIndex + ChrArr[n].UserChr.sex * 120;
          d := g_WChrSelImages.Images[img];
          if d <> nil then
          begin
            if ChrArr[n].DarkLevel > 0 then
            begin
              dd := TDirectDrawSurface.Create(frmMain.DXDraw.DDraw);
              dd.SetSize(d.Width, d.Height);
              dd.Draw(0, 0, d.ClientRect, d, False);
              MakeDark(dd, 30 - ChrArr[n].DarkLevel);
              MSurface.Draw(fx, fy, dd.ClientRect, dd, True);
              dd.free;
            end
            else
              MSurface.Draw(fx, fy, d.ClientRect, d, True);
          end;
        end
        else
        begin
          img := 140 - 80 + ChrArr[n].UserChr.job * 40 + ChrArr[n].UserChr.sex * 120;
          d := g_WChrSelImages.Images[img];
          if d <> nil then
            MSurface.Draw(bx, by, d.ClientRect, d, True);
        end;
        if ChrArr[n].Selected then
        begin
          if GetTickCount - ChrArr[n].StartTime > 230 then
          begin
            ChrArr[n].StartTime := GetTickCount;
            ChrArr[n].AniIndex := ChrArr[n].AniIndex + 1;
            if ChrArr[n].AniIndex > SELECTEDFRAME - 1 then
              ChrArr[n].AniIndex := 0;
          end;
          if GetTickCount - ChrArr[n].moretime > 25 then
          begin
            ChrArr[n].moretime := GetTickCount;
            if ChrArr[n].DarkLevel > 0 then
              ChrArr[n].DarkLevel := ChrArr[n].DarkLevel - 1;
          end;
        end;
      end;
      //显示选择角色时人物名称等级
      if n = 0 then
      begin
        if ChrArr[n].UserChr.Name <> '' then
        begin
          with MSurface do
          begin
            //SetBkMode(Canvas.Handle, Transparent);
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 117 {117}, (SCREENHEIGHT - 600) div 2 + 492 + 2 {492+2}, clWhite, clblack, ChrArr[n].UserChr.Name);
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 117 {117}, (SCREENHEIGHT - 600) div 2 + 523 {523}, clWhite, clblack, IntToStr(ChrArr[n].UserChr.Level));
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 117 {117}, (SCREENHEIGHT - 600) div 2 + 553 {553}, clWhite, clblack, GetJobName(ChrArr[n].UserChr.job));
            //Canvas.Release;
          end;
        end;
      end
      else
      begin
        if ChrArr[n].UserChr.Name <> '' then
        begin
          with MSurface do
          begin
            //SetBkMode(Canvas.Handle, Transparent);
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 671 {671}, (SCREENHEIGHT - 600) div 2 + 492 + 4 {492+4}, clWhite, clblack, ChrArr[n].UserChr.Name);
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 671 {671}, (SCREENHEIGHT - 600) div 2 + 525 {525}, clWhite, clblack, IntToStr(ChrArr[n].UserChr.Level));
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 671 {671}, (SCREENHEIGHT - 600) div 2 + 555 {555}, clWhite, clblack, GetJobName(ChrArr[n].UserChr.job));
            //Canvas.Release;
          end;
        end;
      end;
      with MSurface do
      begin
        //SetBkMode(Canvas.Handle, Transparent);
        //if BO_FOR_TEST then svname := 'gameofblue'
        //else
        //svname := 'gameoflegend';
        svname := g_sServerName;
        BoldTextOut(MSurface, SCREENWIDTH div 2 {405} - Canvas.TextWidth(svname, False) div 2, (SCREENHEIGHT - 600) div 2 + 8 {8}, clWhite, clblack, svname);
        //Canvas.Release;
      end;
    end;
  end;
end;

{--------------------------- TLoginNotice ----------------------------}

constructor TLoginNotice.Create;
begin
  inherited Create(stLoginNotice);
end;

destructor TLoginNotice.Destroy;
begin
  inherited Destroy;
end;

end.
