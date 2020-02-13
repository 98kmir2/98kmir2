unit GMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, SDK, Dialogs, ComCtrls, FileCtrl,
  StdCtrls, INIFiles, ExtCtrls, Spin, D7ScktComp, Buttons, ShellApi, jpeg, Graphics,
  {XPman,} tlhelp32, PsAPI, Grids, ValEdit, RzLstBox, RzChkLst, RzPanel, RzRadGrp, ButtonGroup, CheckLst, Menus;

const
  Idx_Market_Def = 1;
  Idx_Npc_Def = 2;
  Idx_Robot_def = 3;
  Idx_MapQuest_def = 4;

type
  TMyStatusBar = class(TStatusBar)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TfrmMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    PageControl3: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditGameDir: TEdit;
    Button1: TButton;
    Label2: TLabel;
    EditHeroDB: TEdit;
    ButtonNext1: TButton;
    ButtonNext2: TButton;
    GroupBox2: TGroupBox;
    ButtonPrv2: TButton;
    EditGameName: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EditGameExtIPaddr: TEdit;
    TimerStartGame: TTimer;
    TimerStopGame: TTimer;
    TimerCheckRun: TTimer;
    ButtonReLoadConfig: TButton;
    GroupBox7: TGroupBox;
    Label9: TLabel;
    EditLoginGate_MainFormX: TSpinEdit;
    Label10: TLabel;
    EditLoginGate_MainFormY: TSpinEdit;
    GroupBox3: TGroupBox;
    GroupBox8: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    EditSelGate_MainFormX: TSpinEdit;
    EditSelGate_MainFormY: TSpinEdit;
    TabSheet7: TTabSheet;
    GroupBox9: TGroupBox;
    GroupBox10: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    EditLoginServer_MainFormX: TSpinEdit;
    EditLoginServer_MainFormY: TSpinEdit;
    TabSheet8: TTabSheet;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    EditDBServer_MainFormX: TSpinEdit;
    EditDBServer_MainFormY: TSpinEdit;
    TabSheet9: TTabSheet;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    EditLogServer_MainFormX: TSpinEdit;
    EditLogServer_MainFormY: TSpinEdit;
    TabSheet10: TTabSheet;
    GroupBox15: TGroupBox;
    GroupBox16: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    EditM2Server_MainFormX: TSpinEdit;
    EditM2Server_MainFormY: TSpinEdit;
    TabSheet11: TTabSheet;
    ButtonSave: TButton;
    ButtonGenGameConfig: TButton;
    ButtonPrv3: TButton;
    ButtonNext3: TButton;
    TabSheet12: TTabSheet;
    ButtonPrv4: TButton;
    ButtonNext4: TButton;
    ButtonPrv5: TButton;
    ButtonNext5: TButton;
    ButtonPrv6: TButton;
    ButtonNext6: TButton;
    ButtonPrv7: TButton;
    ButtonNext7: TButton;
    ButtonPrv8: TButton;
    ButtonNext8: TButton;
    ButtonPrv9: TButton;
    GroupBox17: TGroupBox;
    GroupBox18: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    EditRunGate_MainFormX: TSpinEdit;
    EditRunGate_MainFormY: TSpinEdit;
    GroupBox19: TGroupBox;
    Label23: TLabel;
    EditRunGate_Connt: TSpinEdit;
    ButtonLoginServerConfig: TButton;
    CheckBoxDynamicIPMode: TCheckBox;
    TabSheet14: TTabSheet;
    GroupBox22: TGroupBox;
    LabelRunGate_GatePort1: TLabel;
    EditRunGate_GatePort1: TEdit;
    LabelLabelRunGate_GatePort2: TLabel;
    EditRunGate_GatePort2: TEdit;
    LabelRunGate_GatePort3: TLabel;
    EditRunGate_GatePort3: TEdit;
    LabelRunGate_GatePort4: TLabel;
    EditRunGate_GatePort4: TEdit;
    LabelRunGate_GatePort5: TLabel;
    EditRunGate_GatePort5: TEdit;
    LabelRunGate_GatePort6: TLabel;
    EditRunGate_GatePort6: TEdit;
    LabelRunGate_GatePort7: TLabel;
    EditRunGate_GatePort7: TEdit;
    EditRunGate_GatePort8: TEdit;
    LabelRunGate_GatePort78: TLabel;
    ButtonRunGateDefault: TButton;
    ButtonSelGateDefault: TButton;
    ButtonGeneralDefalult: TButton;
    ButtonLoginGateDefault: TButton;
    ButtonLoginSrvDefault: TButton;
    ButtonDBServerDefault: TButton;
    ButtonLogServerDefault: TButton;
    ButtonM2ServerDefault: TButton;
    GroupBox23: TGroupBox;
    Label28: TLabel;
    EditLoginGate_GatePort1: TEdit;
    GroupBox24: TGroupBox;
    Label29: TLabel;
    EditSelGate_GatePort1: TEdit;
    TabSheet15: TTabSheet;
    GroupBox25: TGroupBox;
    EditSearchLoginAccount: TEdit;
    Label30: TLabel;
    ButtonSearchLoginAccount: TButton;
    GroupBox26: TGroupBox;
    Label31: TLabel;
    EditLoginAccount: TEdit;
    Label32: TLabel;
    EditLoginAccountPasswd: TEdit;
    Label33: TLabel;
    EditLoginAccountUserName: TEdit;
    Label34: TLabel;
    EditLoginAccountSSNo: TEdit;
    Label35: TLabel;
    EditLoginAccountBirthDay: TEdit;
    Label36: TLabel;
    EditLoginAccountQuiz: TEdit;
    Label37: TLabel;
    EditLoginAccountAnswer: TEdit;
    Label38: TLabel;
    Label39: TLabel;
    EditLoginAccountQuiz2: TEdit;
    EditLoginAccountAnswer2: TEdit;
    Label40: TLabel;
    EditLoginAccountMobilePhone: TEdit;
    EditLoginAccountMemo1: TEdit;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    EditLoginAccountEMail: TEdit;
    EditLoginAccountMemo2: TEdit;
    CkFullEditMode: TCheckBox;
    Label44: TLabel;
    EditLoginAccountPhone: TEdit;
    GroupBox27: TGroupBox;
    CheckBoxboLoginGate_GetStart: TCheckBox;
    GroupBox28: TGroupBox;
    CheckBoxboSelGate_GetStart: TCheckBox;
    TimerAutoBackup: TTimer;
    GroupBox32: TGroupBox;
    Label61: TLabel;
    Label62: TLabel;
    EditM2Server_TestLevel: TSpinEdit;
    EditM2Server_TestGold: TSpinEdit;
    GroupBox33: TGroupBox;
    Label50: TLabel;
    Label51: TLabel;
    EditLoginServerGatePort: TEdit;
    EditLoginServerServerPort: TEdit;
    GroupBox34: TGroupBox;
    CheckBoxboLoginServer_GetStart: TCheckBox;
    GroupBox35: TGroupBox;
    CheckBoxDBServerGetStart: TCheckBox;
    GroupBox36: TGroupBox;
    Label52: TLabel;
    Label53: TLabel;
    EditDBServerGatePort: TEdit;
    EditDBServerServerPort: TEdit;
    GroupBox37: TGroupBox;
    CheckBoxLogServerGetStart: TCheckBox;
    GroupBox38: TGroupBox;
    Label54: TLabel;
    EditLogServerPort: TEdit;
    GroupBox39: TGroupBox;
    Label55: TLabel;
    EditM2ServerGatePort: TEdit;
    GroupBox40: TGroupBox;
    CheckBoxM2ServerGetStart: TCheckBox;
    Label56: TLabel;
    EditM2ServerMsgSrvPort: TEdit;
    GroupBox5: TGroupBox;
    EditM2ServerProgram: TEdit;
    EditDBServerProgram: TEdit;
    EditLoginSrvProgram: TEdit;
    EditLogServerProgram: TEdit;
    EditLoginGateProgram: TEdit;
    EditSelGateProgram: TEdit;
    EditRunGateProgram: TEdit;
    ButtonStartGame: TButton;
    CheckBoxM2Server: TCheckBox;
    CheckBoxDBServer: TCheckBox;
    CheckBoxLoginServer: TCheckBox;
    CheckBoxLogServer: TCheckBox;
    CheckBoxLoginGate: TCheckBox;
    CheckBoxSelGate: TCheckBox;
    CheckBoxRunGate: TCheckBox;
    EditRunGate1Program: TEdit;
    EditRunGate2Program: TEdit;
    MemoLog: TMemo;
    GroupBox6: TGroupBox;
    Label8: TLabel;
    GroupBox43: TGroupBox;
    Label64: TLabel;
    EditIDDB: TEdit;
    EditFDB: TEdit;
    BitBtnFDB: TBitBtn;
    BitBtnBACKUP: TBitBtn;
    EditBakDir: TEdit;
    BitBtnGUILD: TBitBtn;
    EditGuild: TEdit;
    BitBtnIDDB: TBitBtn;
    BitBtnBak: TBitBtn;
    BitBtnSaveSetup: TBitBtn;
    BitBtnPrv: TBitBtn;
    GroupBox44: TGroupBox;
    RadioButtonWeek: TRadioButton;
    RadioButtonMin: TRadioButton;
    SpinEditMinInter: TSpinEdit;
    SpinEditHour: TSpinEdit;
    SpinEditMin: TSpinEdit;
    ComboBoxInterDay: TComboBox;
    CheckBoxBackupTimer: TCheckBox;
    EditData: TEdit;
    BitBtnData: TBitBtn;
    EditBigBagSize: TEdit;
    BitBtnBigBagSize: TBitBtn;
    BitBtnSabuk: TBitBtn;
    EditSabuk: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    EditOtherSourceDir1: TEdit;
    BitBtn1: TBitBtn;
    CheckBox7: TCheckBox;
    EditOtherSourceDir2: TEdit;
    BitBtn2: TBitBtn;
    CheckBox8: TCheckBox;
    LabelNotice: TLabel;
    CheckBoxLoginGateSleep: TCheckBox;
    SpinEditLoginGateSleep: TSpinEdit;
    EditUpdateDate: TEdit;
    Label66: TLabel;
    EditCreateDate: TEdit;
    Label67: TLabel;
    ButtonLoginAccountOK: TButton;
    EditWinrarFile: TEdit;
    BitBtnWinrarFile: TBitBtn;
    OpenDlg: TOpenDialog;
    CheckBox9: TCheckBox;
    Timer: TTimer;
    TimerCheckDebug: TTimer;
    GroupBox29: TGroupBox;
    CheckBox10: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label24: TLabel;
    Label25: TLabel;
    EditLogListenPort: TEdit;
    Button2: TButton;
    EditMirDir: TEdit;
    BitBtnMirDir: TBitBtn;
    Label26: TLabel;
    GroupBox21: TGroupBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    GroupBox30: TGroupBox;
    PopupMenu1: TPopupMenu;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    N1: TMenuItem;
    OpenDialog1: TOpenDialog;
    CheckListBoxClear: TListBox;
    GroupBox31: TGroupBox;
    CheckListBoxDel: TListBox;
    PopupMenu2: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    N2: TMenuItem;
    O1: TMenuItem;
    N3: TMenuItem;
    O2: TMenuItem;
    ProgressBarCur: TProgressBar;
    Button3: TButton;
    EditLoginGateCount: TSpinEdit;
    Label5: TLabel;
    EditLoginGate_GatePort2: TEdit;
    Label6: TLabel;
    EditLoginGate_GatePort3: TEdit;
    Label7: TLabel;
    EditLoginGate_GatePort4: TEdit;
    EditLoginGate_GatePort5: TEdit;
    EditLoginGate_GatePort6: TEdit;
    EditLoginGate_GatePort7: TEdit;
    EditLoginGate_GatePort8: TEdit;
    Label27: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    EditSelGate_GateCount: TSpinEdit;
    Label48: TLabel;
    Label49: TLabel;
    Label57: TLabel;
    EditSelGate_GatePort2: TEdit;
    EditSelGate_GatePort3: TEdit;
    EditSelGate_GatePort4: TEdit;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label63: TLabel;
    EditSelGate_GatePort5: TEdit;
    EditSelGate_GatePort6: TEdit;
    EditSelGate_GatePort7: TEdit;
    EditSelGate_GatePort8: TEdit;
    Label65: TLabel;
    procedure ButtonNext1Click(Sender: TObject);
    procedure ButtonPrv2Click(Sender: TObject);
    procedure ButtonNext2Click(Sender: TObject);
    procedure ButtonPrv3Click(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonGenGameConfigClick(Sender: TObject);
    procedure ButtonStartGameClick(Sender: TObject);
    procedure TimerStartGameTimer(Sender: TObject);
    procedure CheckBoxDBServerClick(Sender: TObject);
    procedure CheckBoxLoginServerClick(Sender: TObject);
    procedure CheckBoxM2ServerClick(Sender: TObject);
    procedure CheckBoxLogServerClick(Sender: TObject);
    procedure CheckBoxLoginGateClick(Sender: TObject);
    procedure CheckBoxSelGateClick(Sender: TObject);
    procedure CheckBoxRunGateClick(Sender: TObject);
    procedure TimerStopGameTimer(Sender: TObject);
    procedure TimerCheckRunTimer(Sender: TObject);
    procedure ButtonReLoadConfigClick(Sender: TObject);
    procedure EditLoginGate_MainFormXChange(Sender: TObject);
    procedure EditLoginGate_MainFormYChange(Sender: TObject);
    procedure EditSelGate_MainFormXChange(Sender: TObject);
    procedure EditSelGate_MainFormYChange(Sender: TObject);
    procedure EditLoginServer_MainFormXChange(Sender: TObject);
    procedure EditLoginServer_MainFormYChange(Sender: TObject);
    procedure EditDBServer_MainFormXChange(Sender: TObject);
    procedure EditDBServer_MainFormYChange(Sender: TObject);
    procedure EditLogServer_MainFormXChange(Sender: TObject);
    procedure EditLogServer_MainFormYChange(Sender: TObject);
    procedure EditM2Server_MainFormXChange(Sender: TObject);
    procedure EditM2Server_MainFormYChange(Sender: TObject);
    procedure MemoLogChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonNext3Click(Sender: TObject);
    procedure ButtonNext4Click(Sender: TObject);
    procedure ButtonNext5Click(Sender: TObject);
    procedure ButtonNext6Click(Sender: TObject);
    procedure ButtonNext7Click(Sender: TObject);
    procedure ButtonPrv4Click(Sender: TObject);
    procedure ButtonPrv5Click(Sender: TObject);
    procedure ButtonPrv6Click(Sender: TObject);
    procedure ButtonPrv7Click(Sender: TObject);
    procedure ButtonPrv8Click(Sender: TObject);
    procedure ButtonNext8Click(Sender: TObject);
    procedure ButtonPrv9Click(Sender: TObject);
    procedure EditRunGate_ConntChange(Sender: TObject);
    procedure ButtonLoginServerConfigClick(Sender: TObject);
    procedure ButtonAdvClick(Sender: TObject);
    procedure CheckBoxDynamicIPModeClick(Sender: TObject);

    {procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);}
    procedure Button2Click(Sender: TObject);
    procedure EditNoticeUrlChange(Sender: TObject);
    procedure EditClientFormChange(Sender: TObject);
    procedure MemoGameListChange(Sender: TObject);
    procedure ButtonRunGateDefaultClick(Sender: TObject);
    procedure ButtonGeneralDefalultClick(Sender: TObject);
    procedure ButtonLoginGateDefaultClick(Sender: TObject);
    procedure ButtonSelGateDefaultClick(Sender: TObject);
    procedure ButtonLoginSrvDefaultClick(Sender: TObject);
    procedure ButtonDBServerDefaultClick(Sender: TObject);
    procedure ButtonLogServerDefaultClick(Sender: TObject);
    procedure ButtonM2ServerDefaultClick(Sender: TObject);
    procedure ButtonSearchLoginAccountClick(Sender: TObject);
    procedure CkFullEditModeClick(Sender: TObject);
    procedure ButtonLoginAccountOKClick(Sender: TObject);
    procedure EditLoginAccountChange(Sender: TObject);
    procedure CheckBoxboLoginGate_GetStartClick(Sender: TObject);
    procedure CheckBoxboSelGate_GetStartClick(Sender: TObject);
    procedure TimerAutoBackupTimer(Sender: TObject);
    procedure ButtonM2SuspendClick(Sender: TObject);
    procedure EditM2Server_TestLevelChange(Sender: TObject);
    procedure EditM2Server_TestGoldChange(Sender: TObject);
    procedure CheckBoxboLoginServer_GetStartClick(Sender: TObject);
    procedure CheckBoxDBServerGetStartClick(Sender: TObject);
    procedure CheckBoxLogServerGetStartClick(Sender: TObject);
    procedure CheckBoxM2ServerGetStartClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure BitBtnIDDBClick(Sender: TObject);
    procedure BitBtnFDBClick(Sender: TObject);
    procedure BitBtnGUILDClick(Sender: TObject);
    procedure BitBtnDataClick(Sender: TObject);
    procedure BitBtnBigBagSizeClick(Sender: TObject);
    procedure BitBtnSabukClick(Sender: TObject);
    procedure BitBtnBACKUPClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtnPrvClick(Sender: TObject);
    procedure BitBtnSaveSetupClick(Sender: TObject);
    procedure CheckBoxBackupTimerClick(Sender: TObject);
    procedure RadioButtonWeekClick(Sender: TObject);
    procedure RadioButtonMinClick(Sender: TObject);
    procedure SpinEditMinInterChange(Sender: TObject);
    procedure SpinEditHourChange(Sender: TObject);
    procedure SpinEditMinChange(Sender: TObject);
    procedure EditIDDBChange(Sender: TObject);
    procedure EditSearchLoginAccountKeyPress(Sender: TObject; var Key: Char);
    procedure CheckBoxLoginGateSleepClick(Sender: TObject);
    procedure SpinEditLoginGateSleepChange(Sender: TObject);
    procedure ButtonAboutClick(Sender: TObject);
    procedure BitBtnWinrarFileClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure TimerCheckDebugTimer(Sender: TObject);
    procedure ButtonDbsSuspendClick(Sender: TObject);
    procedure ButtonM2ResumeClick(Sender: TObject);
    procedure ButtonM2TerminateClick(Sender: TObject);
    procedure ButtonDbsResumeClick(Sender: TObject);
    procedure ButtonDbsTerminateClick(Sender: TObject);
    procedure BitBtnBakClick(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure BitBtnMirDirClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure O2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    m_boOpen: Boolean;
    m_nStartStatus: Integer;
    m_dwShowTick: LongWord;
    procedure RefGameConsole();
    procedure GenGameConfig();
    procedure GenDBServerConfig();
    procedure GenLoginServerConfig();
    procedure GenLogServerConfig();
    procedure GenMirServerConfig();
    procedure GenLoginGateConfig();
    procedure GenSelGateConfig();
    procedure GenRunGateConfig;
    procedure StartGame();
    procedure StopGame();
    procedure MainOutMessage(sMsg: string);
    procedure ProcessDBServerMsg(wIdent: Word; sData: string);
    procedure ProcessLoginSrvMsg(wIdent: Word; sData: string);
    procedure ProcessLoginSrvGetUserAccount(sData: string);
    procedure ProcessLoginSrvChangeUserAccountStatus(sData: string);
    procedure UserAccountEditMode(boChecked: Boolean);
    procedure ProcessLogServerMsg(wIdent: Word; sData: string);
    procedure ProcessLoginGateMsg(wIdent: Word; sData: string);
    procedure ProcessSelGateMsg(wIdent: Word; sData: string);
    procedure ProcessRunGateMsg(wIdent: Word; sData: string);
    procedure ProcessMirServerMsg(wIdent: Word; sData: string);
    procedure ProcessClientPacket();
    procedure SendGameList(Socket: TCustomWinSocket);
    // procedure SendSocket(Socket: TCustomWinSocket; SendMsg: string);   定义未使用 涂修东  2019-10-08 11:31:13
    function StartService(): Boolean;
     // procedure StopService();                                          定义未使用 涂修东  2019-10-08 11:31:13
    procedure RefGameDebug();
    procedure BackUpFiles(Sender: TObject; bHint: Boolean = False);
    procedure SwitchSeting(Switch: Boolean);
    { Private declarations }
  public
    procedure ModValue();
    procedure ProcessMessage(var Msg: TMsg; var Handled: Boolean);
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    function CurrentIsValidDir(SearchRec: TSearchRec): Integer;
    procedure RecurSearchFile(CurrentDir: string; SearchFileType: string; SearchResult: TStrings; var Number: Integer);
    procedure Xcopy(SourceDir, TargetDir: string);
    procedure addToTextClearList(s: string);
    procedure addToTextClearList2(s: string);
    procedure analyseScript(idx: Integer; s: string);
    procedure FindFiles(APath: string; list: TStringList);
    //procedure DeleteDirAll(APath: string; rdir: Boolean);
    procedure SetControlState(State: Boolean);
    { Public declarations }
  end;

var
  frmMain: TfrmMain;


implementation

uses GShare, HUtil32, Grobal2, GLoginServer, {GCertServerSet,} EDcode, Share;

{$R *.dfm}

constructor TMyStatusBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
end;

function TfrmMain.CurrentIsValidDir(SearchRec: TSearchRec): Integer;
begin
  if ((SearchRec.Attr <> 16) and
    (SearchRec.Name <> '.') and
    (SearchRec.Name <> '..')) then
    Result := 0
  else if ((SearchRec.Attr = 16) and
    (SearchRec.Name <> '.') and
    (SearchRec.Name <> '..')) then
    Result := 1
  else
    Result := 2;
end;

procedure TfrmMain.RecurSearchFile(CurrentDir: string; SearchFileType: string; SearchResult: TStrings; var Number: Integer);
var
  i: Integer;
  Subdir: TStringList;
  SearchRec: TSearchRec;
begin
  if (FindFirst(CurrentDir + SearchFileType, faAnyFile, SearchRec) = 0) then
  begin
    repeat
      if CurrentIsValidDir(SearchRec) = 0 then
      begin
        Inc(Number);
        //SearchResult.Add('[' + DateTimeToStr(Now) + ']: ' + CurrentDir + SearchRec.Name + ' 备份成功');
      end;
      Application.ProcessMessages;
    until (FindNext(SearchRec) <> 0);
  end;
  FindClose(SearchRec);
  Subdir := TStringList.Create;
  if (FindFirst(CurrentDir + '*.*', faDirectory, SearchRec) = 0) then
  begin
    repeat
      if CurrentIsValidDir(SearchRec) = 1 then
      begin
        Subdir.Add(SearchRec.Name);
      end;
      Application.ProcessMessages;
    until (FindNext(SearchRec) <> 0);
  end;
  FindClose(SearchRec);
  for i := 0 to Subdir.Count - 1 do
  begin
    RecurSearchFile(CurrentDir + Subdir.Strings[i] + '\', SearchFileType, SearchResult, Number);
  end;
  Subdir.Free;
end;

procedure TfrmMain.Xcopy(SourceDir, TargetDir: string);
var
  OpStruc: TSHFileOpStruct; //声明一个TSHFileOpStruct记录结构
  FromBuf, ToBuf: array[0..255] of Char; //定义源和目的缓冲区
begin
  FillChar(FromBuf, SizeOf(FromBuf), 0);
  FillChar(ToBuf, SizeOf(ToBuf), 0);
  StrPCopy(FromBuf, SourceDir + '*.*');
  StrPCopy(ToBuf, TargetDir);
  with OpStruc do
  begin
    Wnd := Handle; //设定句柄为当前Form窗体，因此对话框为系统对话框
    wFunc := FO_Copy; //操作类型为从源到目的地的拷贝操作
    pFrom := @FromBuf;
    pTo := @ToBuf;
    fFlags := FOF_NOCONFIRMATION { Don't prompt the user. } or FOF_NOCONFIRMMKDIR { don't confirm making any needed dirs } or FOF_RENAMEONCOLLISION;
    fAnyOperationsAborted := False;
    hNameMappings := nil;
    lpszProgressTitle := nil;
  end;
  SHFileOperation(OpStruc); //调用Api函数，传入参数完成操作
end;

procedure TfrmMain.MainOutMessage(sMsg: string);
begin
  sMsg := '[' + DateTimeToStr(Now) + '] ' + sMsg;
  MemoLog.Lines.Add(sMsg);
end;

procedure TfrmMain.ButtonNext1Click(Sender: TObject);
var
  sGameDirectory: string;
  sHeroDBName: string;
  sMirServer_Reg, sRunGate_Reg, sDBServer_Reg: string;
  sGameName: string;
  sExtIPAddr: string;
begin
  sGameDirectory := Trim(EditGameDir.Text);
  sHeroDBName := Trim(EditHeroDB.Text);

  sGameName := Trim(EditGameName.Text);
  sExtIPAddr := Trim(EditGameExtIPaddr.Text);
  if sGameName = '' then
  begin
    Application.MessageBox('游戏服务器名称输入不正确...', '提示信息', MB_OK + MB_ICONEXCLAMATION);
    EditGameName.SetFocus;
    Exit;
  end;
  if (sExtIPAddr = '') or not IsIPaddr(sExtIPAddr) then
  begin
    Application.MessageBox('游戏服务器外部IP地址输入不正确...', '提示信息', MB_OK + MB_ICONEXCLAMATION);
    EditGameExtIPaddr.SetFocus;
    Exit;
  end;

  if (sGameDirectory = '') or not DirectoryExists(sGameDirectory) then
  begin
    Application.MessageBox('游戏目录输入不正确...', '提示信息', MB_OK + MB_ICONEXCLAMATION);
    EditGameDir.SetFocus;
    Exit;
  end;
  if not (sGameDirectory[Length(sGameDirectory)] = '\') then
  begin
    Application.MessageBox('游戏目录名称最后一个字符必须为"\"...', '提示信息', MB_OK + MB_ICONEXCLAMATION);
    EditGameDir.SetFocus;
    Exit;
  end;
  if sHeroDBName = '' then
  begin
    Application.MessageBox('游戏数据库名称输入不正确...', '提示信息', MB_OK + MB_ICONEXCLAMATION);
    EditHeroDB.SetFocus;
    Exit;
  end;
  g_sMirServer_RegKey := sMirServer_Reg;
  g_sRunGate_RegKey := sRunGate_Reg;
  g_sDBServer_Config_RegKey := sDBServer_Reg;
  g_sGameDirectory := sGameDirectory;
  g_sHeroDBName := sHeroDBName;
  g_sGameName := sGameName;
  g_sExtIPaddr := sExtIPAddr;
  g_boDynamicIPMode := CheckBoxDynamicIPMode.Checked;

  PageControl3.ActivePageIndex := 1;
end;

procedure TfrmMain.ButtonPrv2Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex := 0;
end;

procedure TfrmMain.ButtonNext2Click(Sender: TObject);
var
  nPort: Integer;
begin
  g_nLoginGate_GateCount := EditLoginGateCount.Value;

  nPort := Str_ToInt(Trim(EditLoginGate_GatePort1.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('登录网关端口1设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLoginGate_GatePort1.SetFocus;
    Exit;
  end;
  g_nLoginGate_GatePort1 := nPort;

  nPort := Str_ToInt(Trim(EditLoginGate_GatePort2.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('登录网关端口2设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLoginGate_GatePort2.SetFocus;
    Exit;
  end;
  g_nLoginGate_GatePort2 := nPort;

  nPort := Str_ToInt(Trim(EditLoginGate_GatePort3.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('登录网关端口3设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLoginGate_GatePort3.SetFocus;
    Exit;
  end;
  g_nLoginGate_GatePort3 := nPort;

  nPort := Str_ToInt(Trim(EditLoginGate_GatePort4.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('登录网关端口4设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLoginGate_GatePort4.SetFocus;
    Exit;
  end;
  g_nLoginGate_GatePort4 := nPort;

  nPort := Str_ToInt(Trim(EditLoginGate_GatePort5.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('登录网关端口5设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLoginGate_GatePort5.SetFocus;
    Exit;
  end;
  g_nLoginGate_GatePort5 := nPort;

  nPort := Str_ToInt(Trim(EditLoginGate_GatePort6.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('登录网关端口6设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLoginGate_GatePort6.SetFocus;
    Exit;
  end;
  g_nLoginGate_GatePort6 := nPort;

  nPort := Str_ToInt(Trim(EditLoginGate_GatePort7.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('登录网关端口7设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLoginGate_GatePort7.SetFocus;
    Exit;
  end;
  g_nLoginGate_GatePort7 := nPort;

  nPort := Str_ToInt(Trim(EditLoginGate_GatePort8.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('登录网关端口8设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLoginGate_GatePort8.SetFocus;
    Exit;
  end;
  g_nLoginGate_GatePort8 := nPort;

  PageControl3.ActivePageIndex := 2;
end;

procedure TfrmMain.ButtonPrv3Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex := 1;
end;

procedure TfrmMain.ButtonNext3Click(Sender: TObject);
var
  nPort: Integer;
begin
  g_nSeLGate_GateCount := EditSelGate_GateCount.Value;

  nPort := Str_ToInt(Trim(EditSelGate_GatePort1.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('网关端口1设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditSelGate_GatePort1.SetFocus;
    Exit;
  end;
  g_nSeLGate_GatePort1 := nPort;

  nPort := Str_ToInt(Trim(EditSelGate_GatePort2.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('网关端口2设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditSelGate_GatePort2.SetFocus;
    Exit;
  end;
  g_nSeLGate_GatePort2 := nPort;

  nPort := Str_ToInt(Trim(EditSelGate_GatePort3.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('网关端口3设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditSelGate_GatePort3.SetFocus;
    Exit;
  end;
  g_nSeLGate_GatePort3 := nPort;

  nPort := Str_ToInt(Trim(EditSelGate_GatePort4.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('网关端口4设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditSelGate_GatePort4.SetFocus;
    Exit;
  end;
  g_nSeLGate_GatePort4 := nPort;

  nPort := Str_ToInt(Trim(EditSelGate_GatePort5.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('网关端口5设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditSelGate_GatePort5.SetFocus;
    Exit;
  end;
  g_nSeLGate_GatePort5 := nPort;

  nPort := Str_ToInt(Trim(EditSelGate_GatePort6.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('网关端口6设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditSelGate_GatePort6.SetFocus;
    Exit;
  end;
  g_nSeLGate_GatePort6 := nPort;

  nPort := Str_ToInt(Trim(EditSelGate_GatePort7.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('网关端口7设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditSelGate_GatePort7.SetFocus;
    Exit;
  end;
  g_nSeLGate_GatePort7 := nPort;

  nPort := Str_ToInt(Trim(EditSelGate_GatePort8.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('网关端口8设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditSelGate_GatePort8.SetFocus;
    Exit;
  end;
  g_nSeLGate_GatePort8 := nPort;

  PageControl3.ActivePageIndex := 3;
end;

procedure TfrmMain.ButtonNext4Click(Sender: TObject);
var
  nPort1, nPort2, nPort3, nPort4, nPort5, nPort6, nPort7, nPort8: Integer;
begin
  nPort1 := Str_ToInt(Trim(EditRunGate_GatePort1.Text), -1);
  nPort2 := Str_ToInt(Trim(EditRunGate_GatePort2.Text), -1);
  nPort3 := Str_ToInt(Trim(EditRunGate_GatePort3.Text), -1);
  nPort4 := Str_ToInt(Trim(EditRunGate_GatePort4.Text), -1);
  nPort5 := Str_ToInt(Trim(EditRunGate_GatePort5.Text), -1);
  nPort6 := Str_ToInt(Trim(EditRunGate_GatePort6.Text), -1);
  nPort7 := Str_ToInt(Trim(EditRunGate_GatePort7.Text), -1);
  nPort8 := Str_ToInt(Trim(EditRunGate_GatePort8.Text), -1);

  if (nPort1 < 0) or (nPort1 > 65535) then
  begin
    Application.MessageBox('网关一端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditRunGate_GatePort1.SetFocus;
    Exit;
  end;
  if (nPort2 < 0) or (nPort2 > 65535) then
  begin
    Application.MessageBox('网关二端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditRunGate_GatePort2.SetFocus;
    Exit;
  end;
  if (nPort3 < 0) or (nPort3 > 65535) then
  begin
    Application.MessageBox('网关三端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditRunGate_GatePort3.SetFocus;
    Exit;
  end;
  if (nPort4 < 0) or (nPort4 > 65535) then
  begin
    Application.MessageBox('网关四端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditRunGate_GatePort4.SetFocus;
    Exit;
  end;
  if (nPort5 < 0) or (nPort5 > 65535) then
  begin
    Application.MessageBox('网关五端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditRunGate_GatePort5.SetFocus;
    Exit;
  end;
  if (nPort6 < 0) or (nPort6 > 65535) then
  begin
    Application.MessageBox('网关六端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditRunGate_GatePort6.SetFocus;
    Exit;
  end;
  if (nPort7 < 0) or (nPort7 > 65535) then
  begin
    Application.MessageBox('网关七端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditRunGate_GatePort7.SetFocus;
    Exit;
  end;
  if (nPort8 < 0) or (nPort8 > 65535) then
  begin
    Application.MessageBox('网关八端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditRunGate_GatePort8.SetFocus;
    Exit;
  end;

  g_nRunGate_GatePort := nPort1;
  g_nRunGate1_GatePort := nPort2;
  g_nRunGate2_GatePort := nPort3;
  g_nRunGate3_GatePort := nPort4;
  g_nRunGate4_GatePort := nPort5;
  g_nRunGate5_GatePort := nPort6;
  g_nRunGate6_GatePort := nPort7;
  g_nRunGate7_GatePort := nPort8;

  PageControl3.ActivePageIndex := 4;
end;

procedure TfrmMain.ButtonNext5Click(Sender: TObject);
var
  nGatePort, nServerPort, n: Integer;
begin
  nGatePort := Str_ToInt(Trim(EditLoginServerGatePort.Text), -1);
  nServerPort := Str_ToInt(Trim(EditLoginServerServerPort.Text), -1);
  n := Str_ToInt(Trim(EditLogListenPort.Text), -1);
  if (nGatePort < 0) or (nGatePort > 65535) then
  begin
    Application.MessageBox('网关端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLoginServerGatePort.SetFocus;
    Exit;
  end;
  if (nServerPort < 0) or (nServerPort > 65535) then
  begin
    Application.MessageBox('通讯端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLoginServerServerPort.SetFocus;
    Exit;
  end;
  if (n < 0) or (n > 65535) then
  begin
    Application.MessageBox('监听端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLogListenPort.SetFocus;
    Exit;
  end;
  g_nLoginServer_GatePort := nGatePort;
  g_nLoginServer_ServerPort := nServerPort;
  g_nLoginServer_ListenPort := n;
  PageControl3.ActivePageIndex := 5;
end;

procedure TfrmMain.ButtonNext6Click(Sender: TObject);
var
  nGatePort, nServerPort: Integer;
begin
  nGatePort := Str_ToInt(Trim(EditDBServerGatePort.Text), -1);
  nServerPort := Str_ToInt(Trim(EditDBServerServerPort.Text), -1);

  if (nGatePort < 0) or (nGatePort > 65535) then
  begin
    Application.MessageBox('网关端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditDBServerGatePort.SetFocus;
    Exit;
  end;
  if (nServerPort < 0) or (nServerPort > 65535) then
  begin
    Application.MessageBox('通讯端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditDBServerServerPort.SetFocus;
    Exit;
  end;
  g_nDBServer_Config_GatePort := nGatePort;
  g_nDBServer_Config_ServerPort := nServerPort;
  PageControl3.ActivePageIndex := 6;
end;

procedure TfrmMain.ButtonNext7Click(Sender: TObject);
var
  nPort: Integer;
begin
  nPort := Str_ToInt(Trim(EditLogServerPort.Text), -1);
  if (nPort < 0) or (nPort > 65535) then
  begin
    Application.MessageBox('端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditLogServerPort.SetFocus;
    Exit;
  end;
  g_nLogServer_Port := nPort;
  PageControl3.ActivePageIndex := 7;
end;

procedure TfrmMain.ButtonNext8Click(Sender: TObject);
var
  nGatePort, nMsgSrvPort: Integer;
begin
  nGatePort := Str_ToInt(Trim(EditM2ServerGatePort.Text), -1);
  nMsgSrvPort := Str_ToInt(Trim(EditM2ServerMsgSrvPort.Text), -1);
  if (nGatePort < 0) or (nGatePort > 65535) then
  begin
    Application.MessageBox('网关端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditM2ServerGatePort.SetFocus;
    Exit;
  end;
  if (nMsgSrvPort < 0) or (nMsgSrvPort > 65535) then
  begin
    Application.MessageBox('通讯端口设置错误...', '错误信息', MB_OK + MB_ICONERROR);
    EditM2ServerMsgSrvPort.SetFocus;
    Exit;
  end;
  g_nMirServer_GatePort := nGatePort;
  g_nMirServer_MsgSrvPort := nMsgSrvPort;
  PageControl3.ActivePageIndex := 8;
end;

procedure TfrmMain.ButtonPrv4Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex := 2;
end;

procedure TfrmMain.ButtonPrv5Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex := 3;
end;

procedure TfrmMain.ButtonPrv6Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex := 4;
end;

procedure TfrmMain.ButtonPrv7Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex := 5;
end;

procedure TfrmMain.ButtonPrv8Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex := 6;
end;

procedure TfrmMain.ButtonPrv9Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex := 7;
end;

procedure TfrmMain.ButtonSaveClick(Sender: TObject);
begin

  g_IniConf.WriteBool('GameConf', 'MultiSvrSet', g_boMultiSvrSet);
  g_IniConf.WriteBool('GameConf', 'MainServer', g_boMainServer);

  //  ButtonSave.Enabled:=False;
  g_IniConf.WriteInteger('GameConf', 'dwStopTimeOut', g_dwStopTimeOut);
  g_IniConf.WriteString('GameConf', 'GameDirectory', g_sGameDirectory);
  g_IniConf.WriteString('GameConf', 'HeroDBName', g_sHeroDBName);
  g_IniConf.WriteString('GameConf', 'GameName', g_sGameName);
  g_IniConf.WriteString('GameConf', 'ExtIPaddr', g_sExtIPaddr);
  g_IniConf.WriteBool('GameConf', 'DynamicIPMode', g_boDynamicIPMode);

  //g_IniConf.WriteString('DBServer', 'RegKey', g_sDBServer_Config_RegKey);
  //g_IniConf.WriteString('DBServer', 'RegServerAddr', g_sDBServer_Config_RegServerAddr);
  //g_IniConf.WriteInteger('DBServer', 'RegServerPort', g_nDBServer_Config_RegServerPort);
  g_IniConf.WriteInteger('DBServer', 'MainFormX', g_nDBServer_MainFormX);
  g_IniConf.WriteInteger('DBServer', 'MainFormY', g_nDBServer_MainFormY);
  g_IniConf.WriteInteger('DBServer', 'GatePort', g_nDBServer_Config_GatePort);
  g_IniConf.WriteInteger('DBServer', 'ServerPort', g_nDBServer_Config_ServerPort);
  g_IniConf.WriteBool('DBServer', 'DisableAutoGame', g_boDBServer_DisableAutoGame);
  g_IniConf.WriteBool('DBServer', 'GetStart', g_boDBServer_GetStart);

  //g_IniConf.WriteString('MirServer', 'RegKey', g_sMirServer_RegKey);
  //g_IniConf.WriteString('MirServer', 'RegServerAddr', g_sMirServer_Config_RegServerAddr);
  //g_IniConf.WriteInteger('MirServer', 'RegServerPort', g_nMirServer_Config_RegServerPort);
  g_IniConf.WriteInteger('MirServer', 'MainFormX', g_nMirServer_MainFormX);
  g_IniConf.WriteInteger('MirServer', 'MainFormY', g_nMirServer_MainFormY);
  g_IniConf.WriteInteger('MirServer', 'TestLevel', g_nMirServer_TestLevel);
  g_IniConf.WriteInteger('MirServer', 'TestGold', g_nMirServer_TestGold);

  g_IniConf.WriteInteger('MirServer', 'GatePort', g_nMirServer_GatePort);
  g_IniConf.WriteInteger('MirServer', 'MsgSrvPort', g_nMirServer_MsgSrvPort);
  g_IniConf.WriteBool('MirServer', 'GetStart', g_boMirServer_GetStart);

  //g_IniConf.WriteString('RunGate', 'RegKey', g_sRunGate_RegKey);
  //g_IniConf.WriteString('RunGate', 'RegServerAddr', g_sRunGate_Config_RegServerAddr);
  //g_IniConf.WriteInteger('RunGate', 'RegServerPort', g_nRunGate_Config_RegServerPort);
  g_IniConf.WriteInteger('RunGate', 'Count', g_nRunGate_Count);
  g_IniConf.WriteInteger('RunGate', 'GatePort1', g_nRunGate_GatePort);
  g_IniConf.WriteInteger('RunGate', 'GatePort2', g_nRunGate1_GatePort);
  g_IniConf.WriteInteger('RunGate', 'GatePort3', g_nRunGate2_GatePort);
  g_IniConf.WriteInteger('RunGate', 'GatePort4', g_nRunGate3_GatePort);
  g_IniConf.WriteInteger('RunGate', 'GatePort5', g_nRunGate4_GatePort);
  g_IniConf.WriteInteger('RunGate', 'GatePort6', g_nRunGate5_GatePort);
  g_IniConf.WriteInteger('RunGate', 'GatePort7', g_nRunGate6_GatePort);
  g_IniConf.WriteInteger('RunGate', 'GatePort8', g_nRunGate7_GatePort);

  g_IniConf.WriteInteger('LoginGate', 'MainFormX', g_nLoginGate_MainFormX);
  g_IniConf.WriteInteger('LoginGate', 'MainFormY', g_nLoginGate_MainFormY);
  g_IniConf.WriteInteger('LoginGate', 'GateCount', g_nLoginGate_GateCount);
  g_IniConf.WriteInteger('LoginGate', 'GatePort', g_nLoginGate_GatePort1);
  g_IniConf.WriteInteger('LoginGate', 'GatePort2', g_nLoginGate_GatePort2);
  g_IniConf.WriteInteger('LoginGate', 'GatePort3', g_nLoginGate_GatePort3);
  g_IniConf.WriteInteger('LoginGate', 'GatePort4', g_nLoginGate_GatePort4);
  g_IniConf.WriteInteger('LoginGate', 'GatePort5', g_nLoginGate_GatePort5);
  g_IniConf.WriteInteger('LoginGate', 'GatePort6', g_nLoginGate_GatePort6);
  g_IniConf.WriteInteger('LoginGate', 'GatePort7', g_nLoginGate_GatePort7);
  g_IniConf.WriteInteger('LoginGate', 'GatePort8', g_nLoginGate_GatePort8);
  g_IniConf.WriteInteger('LoginGate', 'SleepTick', g_nLoginGateSleep);
  g_IniConf.WriteBool('LoginGate', 'GetStart', g_boLoginGate_GetStart);
  g_IniConf.WriteBool('LoginGate', 'StartSleep', g_boLoginGateSleep);

  g_IniConf.WriteInteger('SelGate', 'MainFormX', g_nSelGate_MainFormX);
  g_IniConf.WriteInteger('SelGate', 'MainFormY', g_nSelGate_MainFormY);
  g_IniConf.WriteBool('SelGate', 'GetStart', g_boSelGate_GetStart);
  g_IniConf.WriteInteger('SelGate', 'GateCount', g_nSeLGate_GateCount);
  g_IniConf.WriteInteger('SelGate', 'GatePort', g_nSeLGate_GatePort1);
  g_IniConf.WriteInteger('SelGate', 'GatePort2', g_nSeLGate_GatePort2);
  g_IniConf.WriteInteger('SelGate', 'GatePort3', g_nSeLGate_GatePort3);
  g_IniConf.WriteInteger('SelGate', 'GatePort4', g_nSeLGate_GatePort4);
  g_IniConf.WriteInteger('SelGate', 'GatePort5', g_nSeLGate_GatePort5);
  g_IniConf.WriteInteger('SelGate', 'GatePort6', g_nSeLGate_GatePort6);
  g_IniConf.WriteInteger('SelGate', 'GatePort7', g_nSeLGate_GatePort7);
  g_IniConf.WriteInteger('SelGate', 'GatePort8', g_nSeLGate_GatePort8);

  g_IniConf.WriteInteger('LoginServer', 'MainFormX', g_nLoginServer_MainFormX);
  g_IniConf.WriteInteger('LoginServer', 'MainFormY', g_nLoginServer_MainFormY);
  g_IniConf.WriteInteger('LoginServer', 'GatePort', g_nLoginServer_GatePort);
  g_IniConf.WriteInteger('LoginServer', 'ServerPort', g_nLoginServer_ServerPort);
  g_IniConf.WriteInteger('LoginServer', 'MonPort', g_nLoginServer_ListenPort);

  g_IniConf.WriteBool('LoginServer', 'GetStart', g_boLoginServer_GetStart);

  g_IniConf.WriteInteger('LogServer', 'MainFormX', g_nLogServer_MainFormX);
  g_IniConf.WriteInteger('LogServer', 'MainFormY', g_nLogServer_MainFormY);

  g_IniConf.WriteInteger('LogServer', 'Port', g_nLogServer_Port);
  g_IniConf.WriteBool('LogServer', 'GetStart', g_boLogServer_GetStart);

  Application.MessageBox('配置文件已经保存完毕...', '提示信息', MB_OK + MB_ICONINFORMATION);
  if Application.MessageBox('是否生成新的游戏服务器配置文件...', '提示信息', MB_YESNO + MB_ICONQUESTION) = mrYes then
  begin
    ButtonGenGameConfigClick(ButtonGenGameConfig);
  end;
  PageControl3.ActivePageIndex := 0;
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmMain.SetControlState(State: Boolean);
var
  i: Integer;
begin
  for i := 0 to GroupBox21.ControlCount - 1 do
    GroupBox21.Controls[i].Enabled := State;
  GroupBox21.Enabled := State;
  for i := 0 to GroupBox30.ControlCount - 1 do
    GroupBox30.Controls[i].Enabled := State;
  GroupBox30.Enabled := State;
  for i := 0 to GroupBox31.ControlCount - 1 do
    GroupBox31.Controls[i].Enabled := State;
  GroupBox31.Enabled := State;
  Button2.Enabled := State;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  m_boOpen := False;
  SetControlState(False);

  CheckBox10Click(nil);
  RadioButton1Click(nil);

  Application.OnMessage := ProcessMessage;
  PageControl1.ActivePageIndex := 0;
  PageControl3.ActivePageIndex := 0;
  m_nStartStatus := 0;
  MemoLog.Clear;

  LoadConfig();
  if not StartService() then
    Exit;
  RefGameConsole();
  TimerAutoBackup.Enabled := True;
  //TabSheetDebug.TabVisible := false;
  //TabSheet14.TabVisible := false;
  if g_boShowDebugTab then
  begin
    //TabSheetDebug.TabVisible := True;
    TimerCheckDebug.Enabled := True;
  end;
  m_boOpen := True;
  TotalFileNumbers := 0;
  SearchFileType := '*.*';
  Copying := False;
  LoadSetup();

  if Copy(g_sWinrarFile, Length(g_sWinrarFile), 1) <> '\' then
    g_sWinrarFile := g_sWinrarFile + '\';
  EditWinrarFile.Text := g_sWinrarFile;
  CheckBox9.Checked := FileExists(EditWinrarFile.Text + 'Rar.exe');

  BitBtnSaveSetup.Enabled := False;

  InterTime := GetTickCount();
  MainOutMessage('98K游戏数据引擎控制台启动成功...');
  //SetWindowPos(Self.Handle, HWND_TOPMOST, Self.Left, Self.Top, Self.Width, Self.Height, $40);
end;

procedure TfrmMain.ButtonGenGameConfigClick(Sender: TObject);
begin
  ButtonGenGameConfig.Enabled := False;
  GenGameConfig();
  RefGameConsole();
  Application.MessageBox('引擎配置文件已经生成完毕...', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain.GenGameConfig;
begin
  GenDBServerConfig();
  GenLoginServerConfig();
  GenLogServerConfig();
  GenMirServerConfig();
  GenLoginGateConfig();
  GenSelGateConfig();
  GenRunGateConfig();
end;

procedure TfrmMain.GenDBServerConfig;
var
  IniGameConf: TIniFile;
  sIniFile: string;
  SaveList: TStringList;
begin
  sIniFile := g_sGameDirectory + g_sDBServer_Directory;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;

  IniGameConf := TIniFile.Create(sIniFile + g_sDBServer_ConfigFile);

  //IniGameConf.WriteString('Reg', 'Key', g_sDBServer_Config_RegKey);
  //IniGameConf.WriteString('Reg', 'ServerAddr', g_sDBServer_Config_RegServerAddr);
  //IniGameConf.WriteInteger('Reg', 'ServerPort', g_nDBServer_Config_RegServerPort);
  IniGameConf.WriteString('Server', 'DBName', g_sHeroDBName);

  IniGameConf.WriteString('Setup', 'ServerName', g_sGameName);
  IniGameConf.WriteString('Setup', 'ServerAddr', g_sDBServer_Config_ServerAddr);
  IniGameConf.WriteInteger('Setup', 'ServerPort', g_nDBServer_Config_ServerPort);
  IniGameConf.WriteString('Setup', 'MapFile', g_sDBServer_Config_MapFile);
  IniGameConf.WriteBool('Setup', 'ViewHackMsg', g_boDBServer_Config_ViewHackMsg);
  IniGameConf.WriteBool('Setup', 'DynamicIPMode', g_boDynamicIPMode);
  IniGameConf.WriteBool('Setup', 'DisableAutoGame', g_boDBServer_DisableAutoGame);
  IniGameConf.WriteString('Setup', 'GateAddr', g_sDBServer_Config_GateAddr);
  IniGameConf.WriteInteger('Setup', 'GatePort', g_nDBServer_Config_GatePort);

  IniGameConf.WriteString('Server', 'IDSAddr', g_sLoginServer_ServerAddr); //登录服务器IP
  IniGameConf.WriteInteger('Server', 'IDSPort', g_nLoginServer_ServerPort); //登录服务器端口

  IniGameConf.WriteInteger('DBClear', 'Interval', g_nDBServer_Config_Interval);
  IniGameConf.WriteInteger('DBClear', 'Level1', g_nDBServer_Config_Level1);
  IniGameConf.WriteInteger('DBClear', 'Level2', g_nDBServer_Config_Level2);
  IniGameConf.WriteInteger('DBClear', 'Level3', g_nDBServer_Config_Level3);
  IniGameConf.WriteInteger('DBClear', 'Day1', g_nDBServer_Config_Day1);
  IniGameConf.WriteInteger('DBClear', 'Day2', g_nDBServer_Config_Day2);
  IniGameConf.WriteInteger('DBClear', 'Day3', g_nDBServer_Config_Day3);
  IniGameConf.WriteInteger('DBClear', 'Month1', g_nDBServer_Config_Month1);
  IniGameConf.WriteInteger('DBClear', 'Month2', g_nDBServer_Config_Month2);
  IniGameConf.WriteInteger('DBClear', 'Month3', g_nDBServer_Config_Month3);

  IniGameConf.WriteString('DB', 'Dir', sIniFile + g_sDBServer_Config_Dir);
  IniGameConf.WriteString('DB', 'IdDir', sIniFile + g_sDBServer_Config_IdDir);
  IniGameConf.WriteString('DB', 'HumDir', sIniFile + g_sDBServer_Config_HumDir);
  IniGameConf.WriteString('DB', 'FeeDir', sIniFile + g_sDBServer_Config_FeeDir);
  IniGameConf.WriteString('DB', 'BackupDir', sIniFile + g_sDBServer_Config_BackupDir);
  IniGameConf.WriteString('DB', 'ConnectDir', sIniFile + g_sDBServer_Config_ConnectDir);
  IniGameConf.WriteString('DB', 'LogDir', sIniFile + g_sDBServer_Config_LogDir);

  IniGameConf.Free;

  SaveList := TStringList.Create;
  SaveList.Add(g_sLocalIPaddr);
  SaveList.Add(g_sExtIPaddr);
  SaveList.SaveToFile(sIniFile + g_sDBServer_AddrTableFile);

  SaveList.Clear;
  case g_nRunGate_Count of
    1: SaveList.Add(Format('0 %s %s %d',
        [g_sLocalIPaddr, g_sExtIPaddr, g_nRunGate_GatePort]));
    2: SaveList.Add(Format('0 %s %s %d %s %d',
        [g_sLocalIPaddr, g_sExtIPaddr, g_nRunGate_GatePort, g_sExtIPaddr, g_nRunGate1_GatePort]));
    3: SaveList.Add(Format('0 %s %s %d %s %d %s %d',
        [g_sLocalIPaddr, g_sExtIPaddr, g_nRunGate_GatePort, g_sExtIPaddr, g_nRunGate1_GatePort, g_sExtIPaddr, g_nRunGate2_GatePort]));
    4: SaveList.Add(Format('0 %s %s %d %s %d %s %d %s %d',
        [g_sLocalIPaddr, g_sExtIPaddr, g_nRunGate_GatePort, g_sExtIPaddr, g_nRunGate1_GatePort, g_sExtIPaddr, g_nRunGate2_GatePort, g_sExtIPaddr, g_nRunGate3_GatePort]));
    5: SaveList.Add(Format('0 %s %s %d %s %d %s %d %s %d %s %d',
        [g_sLocalIPaddr, g_sExtIPaddr, g_nRunGate_GatePort, g_sExtIPaddr, g_nRunGate1_GatePort, g_sExtIPaddr, g_nRunGate2_GatePort, g_sExtIPaddr, g_nRunGate3_GatePort, g_sExtIPaddr, g_nRunGate4_GatePort]));
    6: SaveList.Add(Format('0 %s %s %d %s %d %s %d %s %d %s %d %s %d',
        [g_sLocalIPaddr, g_sExtIPaddr, g_nRunGate_GatePort, g_sExtIPaddr, g_nRunGate1_GatePort, g_sExtIPaddr, g_nRunGate2_GatePort, g_sExtIPaddr, g_nRunGate3_GatePort, g_sExtIPaddr, g_nRunGate4_GatePort, g_sExtIPaddr, g_nRunGate5_GatePort]));
    7: SaveList.Add(Format('0 %s %s %d %s %d %s %d %s %d %s %d %s %d %s %d',
        [g_sLocalIPaddr, g_sExtIPaddr, g_nRunGate_GatePort, g_sExtIPaddr, g_nRunGate1_GatePort, g_sExtIPaddr, g_nRunGate2_GatePort, g_sExtIPaddr, g_nRunGate3_GatePort, g_sExtIPaddr, g_nRunGate4_GatePort, g_sExtIPaddr, g_nRunGate5_GatePort, g_sExtIPaddr, g_nRunGate6_GatePort]));
    8: SaveList.Add(Format('0 %s %s %d %s %d %s %d %s %d %s %d %s %d %s %d %s %d',
        [g_sLocalIPaddr, g_sExtIPaddr, g_nRunGate_GatePort, g_sExtIPaddr, g_nRunGate1_GatePort, g_sExtIPaddr, g_nRunGate2_GatePort, g_sExtIPaddr, g_nRunGate3_GatePort, g_sExtIPaddr, g_nRunGate4_GatePort, g_sExtIPaddr, g_nRunGate5_GatePort, g_sExtIPaddr, g_nRunGate6_GatePort, g_sExtIPaddr, g_nRunGate7_GatePort]));
  end;

  SaveList.SaveToFile(sIniFile + g_sDBServer_ServerinfoFile);
  SaveList.SaveToFile(g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_ServerTableFile);
  SaveList.Free;

  sIniFile := g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_Dir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_IdDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_HumDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_FeeDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_BackupDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_ConnectDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_LogDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
end;

procedure TfrmMain.GenLoginServerConfig;
var
  IniGameConf: TIniFile;
  sIniFile: string;
  SaveList: TStringList;
begin
  sIniFile := g_sGameDirectory + g_sLoginServer_Directory;
  if not DirectoryExists(sIniFile) then
    CreateDir(sIniFile);

  IniGameConf := TIniFile.Create(sIniFile + g_sLoginServer_ConfigFile);
  IniGameConf.WriteInteger('Server', 'ReadyServers', g_sLoginServer_ReadyServers);
  IniGameConf.WriteString('Server', 'EnableMakingID', BoolToStr(g_sLoginServer_EnableMakingID));
  IniGameConf.WriteString('Server', 'EnableTrial', BoolToStr(g_sLoginServer_EnableTrial));
  IniGameConf.WriteString('Server', 'TestServer', BoolToStr(g_sLoginServer_TestServer));
  IniGameConf.WriteBool('Server', 'DynamicIPMode', g_boDynamicIPMode);
  IniGameConf.WriteString('Server', 'GateAddr', g_sLoginServer_GateAddr);
  IniGameConf.WriteInteger('Server', 'GatePort', g_nLoginServer_GatePort);
  IniGameConf.WriteString('Server', 'ServerAddr', g_sLoginServer_ServerAddr);
  IniGameConf.WriteInteger('Server', 'MonPort', g_nLoginServer_ListenPort);
  IniGameConf.WriteInteger('Server', 'ServerPort', g_nLoginServer_ServerPort);

  IniGameConf.WriteString('DB', 'IdDir', sIniFile + g_sLoginServer_IdDir);
  IniGameConf.WriteString('DB', 'FeedIDList', sIniFile + g_sLoginServer_FeedIDList);
  IniGameConf.WriteString('DB', 'FeedIPList', sIniFile + g_sLoginServer_FeedIPList);
  IniGameConf.WriteString('DB', 'CountLogDir', sIniFile + g_sLoginServer_CountLogDir);
  IniGameConf.WriteString('DB', 'WebLogDir', sIniFile + g_sLoginServer_WebLogDir);

  IniGameConf.Free;

  SaveList := TStringList.Create;

  if g_nSeLGate_GateCount = 8 then
    SaveList.Add(Format('%s %s %s %s %s:%d %s:%d %s:%d %s:%d %s:%d %s:%d %s:%d %s:%d',
      [g_sGameName, 'Title1', g_sLocalIPaddr, g_sLocalIPaddr,
      g_sExtIPaddr, g_nSeLGate_GatePort1,
        g_sExtIPaddr, g_nSeLGate_GatePort2,
        g_sExtIPaddr, g_nSeLGate_GatePort3,
        g_sExtIPaddr, g_nSeLGate_GatePort4,
        g_sExtIPaddr, g_nSeLGate_GatePort5,
        g_sExtIPaddr, g_nSeLGate_GatePort6,
        g_sExtIPaddr, g_nSeLGate_GatePort7,
        g_sExtIPaddr, g_nSeLGate_GatePort8
        ]))
  else if g_nSeLGate_GateCount = 7 then
    SaveList.Add(Format('%s %s %s %s %s:%d %s:%d %s:%d %s:%d %s:%d %s:%d %s:%d',
      [g_sGameName, 'Title1', g_sLocalIPaddr, g_sLocalIPaddr,
      g_sExtIPaddr, g_nSeLGate_GatePort1,
        g_sExtIPaddr, g_nSeLGate_GatePort2,
        g_sExtIPaddr, g_nSeLGate_GatePort3,
        g_sExtIPaddr, g_nSeLGate_GatePort4,
        g_sExtIPaddr, g_nSeLGate_GatePort5,
        g_sExtIPaddr, g_nSeLGate_GatePort6,
        g_sExtIPaddr, g_nSeLGate_GatePort7
        ]))
  else if g_nSeLGate_GateCount = 6 then
    SaveList.Add(Format('%s %s %s %s %s:%d %s:%d %s:%d %s:%d %s:%d %s:%d',
      [g_sGameName, 'Title1', g_sLocalIPaddr, g_sLocalIPaddr,
      g_sExtIPaddr, g_nSeLGate_GatePort1,
        g_sExtIPaddr, g_nSeLGate_GatePort2,
        g_sExtIPaddr, g_nSeLGate_GatePort3,
        g_sExtIPaddr, g_nSeLGate_GatePort4,
        g_sExtIPaddr, g_nSeLGate_GatePort5,
        g_sExtIPaddr, g_nSeLGate_GatePort6
        ]))
  else if g_nSeLGate_GateCount = 5 then
    SaveList.Add(Format('%s %s %s %s %s:%d %s:%d %s:%d %s:%d %s:%d',
      [g_sGameName, 'Title1', g_sLocalIPaddr, g_sLocalIPaddr,
      g_sExtIPaddr, g_nSeLGate_GatePort1,
        g_sExtIPaddr, g_nSeLGate_GatePort2,
        g_sExtIPaddr, g_nSeLGate_GatePort3,
        g_sExtIPaddr, g_nSeLGate_GatePort4,
        g_sExtIPaddr, g_nSeLGate_GatePort5
        ]))
  else if g_nSeLGate_GateCount = 4 then
    SaveList.Add(Format('%s %s %s %s %s:%d %s:%d %s:%d %s:%d',
      [g_sGameName, 'Title1', g_sLocalIPaddr, g_sLocalIPaddr,
      g_sExtIPaddr, g_nSeLGate_GatePort1,
        g_sExtIPaddr, g_nSeLGate_GatePort2,
        g_sExtIPaddr, g_nSeLGate_GatePort3,
        g_sExtIPaddr, g_nSeLGate_GatePort4
        ]))
  else if g_nSeLGate_GateCount = 3 then
    SaveList.Add(Format('%s %s %s %s %s:%d %s:%d %s:%d',
      [g_sGameName, 'Title1', g_sLocalIPaddr, g_sLocalIPaddr,
      g_sExtIPaddr, g_nSeLGate_GatePort1,
        g_sExtIPaddr, g_nSeLGate_GatePort2,
        g_sExtIPaddr, g_nSeLGate_GatePort3
        ]))
  else if g_nSeLGate_GateCount = 2 then
    SaveList.Add(Format('%s %s %s %s %s:%d %s:%d',
      [g_sGameName, 'Title1', g_sLocalIPaddr, g_sLocalIPaddr,
      g_sExtIPaddr, g_nSeLGate_GatePort1,
        g_sExtIPaddr, g_nSeLGate_GatePort2
        ]))
  else
    SaveList.Add(Format('%s %s %s %s %s:%d',
      [g_sGameName, 'Title1', g_sLocalIPaddr, g_sLocalIPaddr,
      g_sExtIPaddr, g_nSeLGate_GatePort1
        ]));

  SaveList.SaveToFile(sIniFile + g_sLoginServer_AddrTableFile);
  SaveList.Clear;
  SaveList.Add(g_sLocalIPaddr);
  SaveList.SaveToFile(sIniFile + g_sLoginServer_ServeraddrFile);
  SaveList.Clear;
  SaveList.Add(Format('%s %s %d', [g_sGameName, g_sGameName, g_nLimitOnlineUser]));
  SaveList.SaveToFile(sIniFile + g_sLoginServerUserLimitFile);
  SaveList.Free;

  sIniFile := g_sGameDirectory + g_sLoginServer_Directory + g_sLoginServer_IdDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;

  sIniFile := g_sGameDirectory + g_sLoginServer_Directory + g_sLoginServer_CountLogDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;

  sIniFile := g_sGameDirectory + g_sLoginServer_Directory + g_sLoginServer_WebLogDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
end;

procedure TfrmMain.GenLogServerConfig;
var
  IniGameConf: TIniFile;
  sIniFile: string;
begin
  sIniFile := g_sGameDirectory + g_sLogServer_Directory;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;

  IniGameConf := TIniFile.Create(sIniFile + g_sLogServer_ConfigFile);
  IniGameConf.WriteString('Setup', 'ServerName', g_sGameName);
  IniGameConf.WriteInteger('Setup', 'Port', g_nLogServer_Port);
  IniGameConf.WriteString('Setup', 'BaseDir', sIniFile + g_sLogServer_BaseDir);

  sIniFile := sIniFile + g_sLogServer_BaseDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  IniGameConf.Free;
end;

procedure TfrmMain.GenMirServerConfig;
var
  IniGameConf: TIniFile;
  sIniFile: string;
  SaveList: TStringList;
begin
  sIniFile := g_sGameDirectory + g_sMirServer_Directory;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;

  IniGameConf := TIniFile.Create(sIniFile + g_sMirServer_ConfigFile);
  //IniGameConf.WriteString('Reg', 'Key', g_sMirServer_RegKey);
  //IniGameConf.WriteString('Reg', 'IP', g_sExtIPaddr);
  //IniGameConf.WriteString('Reg', 'ServerAddr', g_sMirServer_Config_RegServerAddr);
  //IniGameConf.WriteInteger('Reg', 'ServerPort', g_nMirServer_Config_RegServerPort);

  IniGameConf.WriteString('Server', 'ServerName', g_sGameName);
  IniGameConf.WriteInteger('Server', 'ServerNumber', g_nMirServer_ServerNumber);
  IniGameConf.WriteInteger('Server', 'ServerIndex', g_nMirServer_ServerIndex);

  IniGameConf.WriteString('Server', 'VentureServer', BoolToStr(g_boMirServer_VentureServer));
  IniGameConf.WriteString('Server', 'TestServer', BoolToStr(g_boMirServer_TestServer));
  IniGameConf.WriteInteger('Server', 'TestLevel', g_nMirServer_TestLevel);
  IniGameConf.WriteInteger('Server', 'TestGold', g_nMirServer_TestGold);
  IniGameConf.WriteInteger('Server', 'TestServerUserLimit', g_nLimitOnlineUser);
  IniGameConf.WriteString('Server', 'ServiceMode', BoolToStr(g_boMirServer_ServiceMode));
  IniGameConf.WriteString('Server', 'NonPKServer', BoolToStr(g_boMirServer_NonPKServer));

  IniGameConf.WriteString('Server', 'DBAddr', g_sDBServer_Config_ServerAddr);
  IniGameConf.WriteInteger('Server', 'DBPort', g_nDBServer_Config_ServerPort);
  IniGameConf.WriteString('Server', 'IDSAddr', g_sLoginServer_ServerAddr);
  IniGameConf.WriteInteger('Server', 'IDSPort', g_nLoginServer_ServerPort);
  IniGameConf.WriteString('Server', 'MsgSrvAddr', g_sMirServer_MsgSrvAddr);
  IniGameConf.WriteInteger('Server', 'MsgSrvPort', g_nMirServer_MsgSrvPort);
  IniGameConf.WriteString('Server', 'LogServerAddr', g_sLogServer_ServerAddr);
  IniGameConf.WriteInteger('Server', 'LogServerPort', g_nLogServer_Port);
  IniGameConf.WriteString('Server', 'GateAddr', g_sMirServer_GateAddr);
  IniGameConf.WriteInteger('Server', 'GatePort', g_nMirServer_GatePort);

  IniGameConf.WriteString('Server', 'DBName', g_sHeroDBName);

  IniGameConf.WriteInteger('Server', 'UserFull', g_nLimitOnlineUser);

  IniGameConf.WriteString('Share', 'BaseDir', sIniFile + g_sMirServer_BaseDir);
  IniGameConf.WriteString('Share', 'GuildDir', sIniFile + g_sMirServer_GuildDir);
  IniGameConf.WriteString('Share', 'GuildFile', sIniFile + g_sMirServer_GuildFile);
  IniGameConf.WriteString('Share', 'VentureDir', sIniFile + g_sMirServer_VentureDir);
  IniGameConf.WriteString('Share', 'ConLogDir', sIniFile + g_sMirServer_ConLogDir);
  IniGameConf.WriteString('Share', 'LogDir', sIniFile + g_sMirServer_LogDir);

  IniGameConf.WriteString('Share', 'CastleDir', sIniFile + g_sMirServer_CastleDir);
  IniGameConf.WriteString('Share', 'EnvirDir', sIniFile + g_sMirServer_EnvirDir);
  IniGameConf.WriteString('Share', 'MapDir', sIniFile + g_sMirServer_MapDir);
  IniGameConf.WriteString('Share', 'NoticeDir', sIniFile + g_sMirServer_NoticeDir);

  IniGameConf.Free;

  sIniFile := g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_BaseDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_GuildDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_VentureDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_ConLogDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_LogDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_CastleDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_EnvirDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_MapDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;
  sIniFile := g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_NoticeDir;
  if not DirectoryExists(sIniFile) then
  begin
    CreateDir(sIniFile);
  end;

  sIniFile := g_sGameDirectory + g_sMirServer_Directory;
  SaveList := TStringList.Create;
  SaveList.Add('GM');
  SaveList.SaveToFile(sIniFile + g_sMirServer_AbuseFile);

  SaveList.Clear;
  SaveList.Add(g_sLocalIPaddr);
  SaveList.SaveToFile(sIniFile + g_sMirServer_RunAddrFile);

  //SaveList.Clear;
  //SaveList.Add(g_sLocalIPaddr);
  //SaveList.SaveToFile(sIniFile + g_sMirServer_ServerTableFile);
  SaveList.Free;
end;

procedure TfrmMain.GenLoginGateConfig;
var
  IniGameConf: TIniFile;
  sIniFile: string;
label
  lab1, lab2, lab3, lab4, lab5, lab6, lab7, lab8;
begin
  sIniFile := g_sGameDirectory + g_sLoginGate_Directory;
  if not DirectoryExists(sIniFile) then
    CreateDir(sIniFile);
  IniGameConf := TIniFile.Create(sIniFile + g_sLoginGate_ConfigFile);

  IniGameConf.WriteString('Strings', 'Title', g_sGameName);
  IniGameConf.WriteInteger('GameGate', 'Count', g_nLoginGate_GateCount);
  case g_nLoginGate_GateCount of
    8: goto lab8;
    7: goto lab7;
    6: goto lab6;
    5: goto lab5;
    4: goto lab4;
    3: goto lab3;
    2: goto lab2;
    1: goto lab1;
  end;

  lab8:
  IniGameConf.WriteString('GameGate', 'ServerAddr8', g_sLoginGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort8', g_nLoginServer_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort8', g_nLoginGate_GatePort8);
  lab7:
  IniGameConf.WriteString('GameGate', 'ServerAddr7', g_sLoginGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort7', g_nLoginServer_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort7', g_nLoginGate_GatePort7);
  lab6:
  IniGameConf.WriteString('GameGate', 'ServerAddr6', g_sLoginGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort6', g_nLoginServer_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort6', g_nLoginGate_GatePort6);
  lab5:
  IniGameConf.WriteString('GameGate', 'ServerAddr5', g_sLoginGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort5', g_nLoginServer_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort5', g_nLoginGate_GatePort5);
  lab4:
  IniGameConf.WriteString('GameGate', 'ServerAddr4', g_sLoginGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort4', g_nLoginServer_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort4', g_nLoginGate_GatePort4);
  lab3:
  IniGameConf.WriteString('GameGate', 'ServerAddr3', g_sLoginGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort3', g_nLoginServer_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort3', g_nLoginGate_GatePort3);
  lab2:
  IniGameConf.WriteString('GameGate', 'ServerAddr2', g_sLoginGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort2', g_nLoginServer_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort2', g_nLoginGate_GatePort2);
  lab1:
  IniGameConf.WriteString('GameGate', 'ServerAddr1', g_sLoginGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort1', g_nLoginServer_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort1', g_nLoginGate_GatePort1);

  IniGameConf.Free;
end;

procedure TfrmMain.GenSelGateConfig();
var
  IniGameConf: TIniFile;
  sIniFile: string;
label
  lab1, lab2, lab3, lab4, lab5, lab6, lab7, lab8;
begin
  sIniFile := g_sGameDirectory + g_sSelGate_Directory;
  if not DirectoryExists(sIniFile) then
    CreateDir(sIniFile);
  IniGameConf := TIniFile.Create(sIniFile + g_sSelGate_ConfigFile);

  IniGameConf.WriteString('Strings', 'Title', g_sGameName);
  IniGameConf.WriteInteger('GameGate', 'Count', g_nSeLGate_GateCount);
  case g_nSeLGate_GateCount of
    8: goto lab8;
    7: goto lab7;
    6: goto lab6;
    5: goto lab5;
    4: goto lab4;
    3: goto lab3;
    2: goto lab2;
    1: goto lab1;
  end;

  lab8:
  IniGameConf.WriteString('GameGate', 'ServerAddr8', g_sSelGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort8', g_nDBServer_Config_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort8', g_nSeLGate_GatePort8);
  lab7:
  IniGameConf.WriteString('GameGate', 'ServerAddr7', g_sSelGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort7', g_nDBServer_Config_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort7', g_nSeLGate_GatePort7);
  lab6:
  IniGameConf.WriteString('GameGate', 'ServerAddr6', g_sSelGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort6', g_nDBServer_Config_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort6', g_nSeLGate_GatePort6);
  lab5:
  IniGameConf.WriteString('GameGate', 'ServerAddr5', g_sSelGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort5', g_nDBServer_Config_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort5', g_nSeLGate_GatePort5);
  lab4:
  IniGameConf.WriteString('GameGate', 'ServerAddr4', g_sSelGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort4', g_nDBServer_Config_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort4', g_nSeLGate_GatePort4);
  lab3:
  IniGameConf.WriteString('GameGate', 'ServerAddr3', g_sSelGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort3', g_nDBServer_Config_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort3', g_nSeLGate_GatePort3);
  lab2:
  IniGameConf.WriteString('GameGate', 'ServerAddr2', g_sSelGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort2', g_nDBServer_Config_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort2', g_nSeLGate_GatePort2);
  lab1:
  IniGameConf.WriteString('GameGate', 'ServerAddr1', g_sSelGate_ServerAddr);
  IniGameConf.WriteInteger('GameGate', 'ServerPort1', g_nDBServer_Config_GatePort);
  IniGameConf.WriteInteger('GameGate', 'GatePort1', g_nSeLGate_GatePort1);

  IniGameConf.Free;
end;

procedure TfrmMain.GenRunGateConfig;
var
  i, n: Integer;
  IniGameConf: TIniFile;
  sIniFile: string;
begin
  sIniFile := g_sGameDirectory + g_sRunGate_Directory;
  if not DirectoryExists(sIniFile) then  CreateDir(sIniFile);
  
  IniGameConf := TIniFile.Create(sIniFile + g_sRunGate_ConfigFile);

  IniGameConf.WriteInteger('GameGate', 'Count', g_nRunGate_Count);
  n := 0;
  for i := 1 to g_nRunGate_Count do
  begin
    case i of
      1: n := g_nRunGate_GatePort;
      2: n := g_nRunGate1_GatePort;
      3: n := g_nRunGate2_GatePort;
      4: n := g_nRunGate3_GatePort;
      5: n := g_nRunGate4_GatePort;
      6: n := g_nRunGate5_GatePort;
      7: n := g_nRunGate6_GatePort;
      8: n := g_nRunGate7_GatePort;
    end;
    IniGameConf.WriteString('GameGate', 'ServerAddr' + IntToStr(i), g_sExtIPaddr);
    IniGameConf.WriteInteger('GameGate', 'ServerPort' + IntToStr(i), g_nMirServer_GatePort);
    IniGameConf.WriteInteger('GameGate', 'GatePort' + IntToStr(i), n);
  end;
  IniGameConf.Free;
end;

procedure TfrmMain.RefGameConsole;
begin
  m_boOpen := False;

  CheckBox10.Checked := g_boMultiSvrSet;
  if g_boMainServer then
    RadioButton1.Checked := True
  else
    RadioButton2.Checked := True;
  CheckBox10Click(nil);

  EditM2ServerProgram.Text := g_sGameDirectory + g_sMirServer_Directory + g_sMirServer_ProgramFile;
  EditDBServerProgram.Text := g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_ProgramFile;
  EditDBServerGatePort.Text := IntToStr(g_nDBServer_Config_GatePort);
  EditDBServerServerPort.Text := IntToStr(g_nDBServer_Config_ServerPort);
  CheckBoxDBServerGetStart.Checked := g_boDBServer_GetStart;

  EditLoginSrvProgram.Text := g_sGameDirectory + g_sLoginServer_Directory + g_sLoginServer_ProgramFile;
  EditLogServerProgram.Text := g_sGameDirectory + g_sLogServer_Directory + g_sLogServer_ProgramFile;
  EditLoginGateProgram.Text := g_sGameDirectory + g_sLoginGate_Directory + g_sLoginGate_ProgramFile;
  EditSelGateProgram.Text := g_sGameDirectory + g_sSelGate_Directory + g_sSelGate_ProgramFile;
  EditRunGateProgram.Text := g_sGameDirectory + g_sRunGate_Directory + g_sRunGate_ProgramFile;
  EditRunGate1Program.Text := g_sGameDirectory + g_sRunGate_Directory + g_sRunGate_ProgramFile;
  EditRunGate2Program.Text := g_sGameDirectory + g_sRunGate_Directory + g_sRunGate_ProgramFile;

  CheckBoxM2Server.Checked := g_boMirServer_GetStart;
  CheckBoxM2Server.Hint := Format('程序所在位置: %s%s%s', [g_sGameDirectory, g_sDBServer_Directory, g_sMirServer_ProgramFile]);
  CheckBoxDBServer.Checked := g_boDBServer_GetStart;
  CheckBoxDBServer.Hint := Format('程序所在位置: %s%s%s', [g_sGameDirectory, g_sDBServer_Directory, g_sDBServer_ProgramFile]);
  CheckBoxLoginServer.Checked := g_boLoginServer_GetStart;
  CheckBoxLoginServer.Hint := Format('程序所在位置: %s%s%s', [g_sGameDirectory, g_sDBServer_Directory, g_sLoginServer_ProgramFile]);
  CheckBoxLogServer.Checked := g_boLogServer_GetStart;
  CheckBoxLogServer.Hint := Format('程序所在位置: %s%s%s', [g_sGameDirectory, g_sDBServer_Directory, g_sLogServer_ProgramFile]);
  CheckBoxLoginGate.Checked := g_boLoginGate_GetStart;
  CheckBoxLoginGate.Hint := Format('程序所在位置: %s%s%s', [g_sGameDirectory, g_sDBServer_Directory, g_sLoginGate_ProgramFile]);
  CheckBoxSelGate.Checked := g_boSelGate_GetStart;
  CheckBoxSelGate.Hint := Format('程序所在位置: %s%s%s', [g_sGameDirectory, g_sDBServer_Directory, g_sSelGate_ProgramFile]);

  CheckBoxRunGate.Checked := g_boRunGate_GetStart;
  CheckBoxRunGate.Hint := Format('程序所在位置: %s%s%s', [g_sGameDirectory, g_sDBServer_Directory, g_sRunGate_ProgramFile]);

  EditGameDir.Text := g_sGameDirectory;
  EditHeroDB.Text := g_sHeroDBName;
  EditGameName.Text := g_sGameName;
  EditGameExtIPaddr.Text := g_sExtIPaddr;
  CheckBoxDynamicIPMode.Checked := g_boDynamicIPMode;
  EditGameExtIPaddr.Enabled := not g_boDynamicIPMode;

  EditLoginGate_MainFormX.Value := g_nLoginGate_MainFormX;
  EditLoginGate_MainFormY.Value := g_nLoginGate_MainFormY;
  CheckBoxboLoginGate_GetStart.Checked := g_boLoginGate_GetStart;
  EditLoginGateCount.Value := g_nLoginGate_GateCount;
  EditLoginGate_GatePort1.Text := IntToStr(g_nLoginGate_GatePort1);
  EditLoginGate_GatePort2.Text := IntToStr(g_nLoginGate_GatePort2);
  EditLoginGate_GatePort3.Text := IntToStr(g_nLoginGate_GatePort3);
  EditLoginGate_GatePort4.Text := IntToStr(g_nLoginGate_GatePort4);
  EditLoginGate_GatePort5.Text := IntToStr(g_nLoginGate_GatePort5);
  EditLoginGate_GatePort6.Text := IntToStr(g_nLoginGate_GatePort6);
  EditLoginGate_GatePort7.Text := IntToStr(g_nLoginGate_GatePort7);
  EditLoginGate_GatePort8.Text := IntToStr(g_nLoginGate_GatePort8);
  SpinEditLoginGateSleep.Value := g_nLoginGateSleep;
  CheckBoxLoginGateSleep.Checked := g_boLoginGateSleep;

  EditSelGate_MainFormX.Value := g_nSelGate_MainFormX;
  EditSelGate_MainFormY.Value := g_nSelGate_MainFormY;
  CheckBoxboSelGate_GetStart.Checked := g_boSelGate_GetStart;
  EditSelGate_GateCount.Text := IntToStr(g_nSeLGate_GateCount);
  EditSelGate_GatePort1.Text := IntToStr(g_nSeLGate_GatePort1);
  EditSelGate_GatePort2.Text := IntToStr(g_nSeLGate_GatePort2);
  EditSelGate_GatePort3.Text := IntToStr(g_nSeLGate_GatePort3);
  EditSelGate_GatePort4.Text := IntToStr(g_nSeLGate_GatePort4);
  EditSelGate_GatePort5.Text := IntToStr(g_nSeLGate_GatePort5);
  EditSelGate_GatePort6.Text := IntToStr(g_nSeLGate_GatePort6);
  EditSelGate_GatePort7.Text := IntToStr(g_nSeLGate_GatePort7);
  EditSelGate_GatePort8.Text := IntToStr(g_nSeLGate_GatePort8);

  EditRunGate_Connt.Value := g_nRunGate_Count;
  EditRunGate_GatePort1.Text := IntToStr(g_nRunGate_GatePort);
  EditRunGate_GatePort2.Text := IntToStr(g_nRunGate1_GatePort);
  EditRunGate_GatePort3.Text := IntToStr(g_nRunGate2_GatePort);
  EditRunGate_GatePort4.Text := IntToStr(g_nRunGate3_GatePort);
  EditRunGate_GatePort5.Text := IntToStr(g_nRunGate4_GatePort);
  EditRunGate_GatePort6.Text := IntToStr(g_nRunGate5_GatePort);
  EditRunGate_GatePort7.Text := IntToStr(g_nRunGate6_GatePort);
  EditRunGate_GatePort8.Text := IntToStr(g_nRunGate7_GatePort);

  EditLoginServer_MainFormX.Value := g_nLoginServer_MainFormX;
  EditLoginServer_MainFormY.Value := g_nLoginServer_MainFormY;
  EditLoginServerGatePort.Text := IntToStr(g_nLoginServer_GatePort);
  EditLoginServerServerPort.Text := IntToStr(g_nLoginServer_ServerPort);
  EditLogListenPort.Text := IntToStr(g_nLoginServer_ListenPort);
  CheckBoxboLoginServer_GetStart.Checked := g_boLoginServer_GetStart;

  EditDBServer_MainFormX.Value := g_nDBServer_MainFormX;
  EditDBServer_MainFormY.Value := g_nDBServer_MainFormY;
  EditLogServer_MainFormX.Value := g_nLogServer_MainFormX;
  EditLogServer_MainFormY.Value := g_nLogServer_MainFormY;
  EditLogServerPort.Text := IntToStr(g_nLogServer_Port);
  CheckBoxLogServerGetStart.Checked := g_boLogServer_GetStart;

  EditM2Server_MainFormX.Value := g_nMirServer_MainFormX;
  EditM2Server_MainFormY.Value := g_nMirServer_MainFormY;
  EditM2Server_TestLevel.Value := g_nMirServer_TestLevel;
  EditM2Server_TestGold.Value := g_nMirServer_TestGold;
  EditM2ServerGatePort.Text := IntToStr(g_nMirServer_GatePort);
  EditM2ServerMsgSrvPort.Text := IntToStr(g_nMirServer_MsgSrvPort);

  CheckBoxM2ServerGetStart.Checked := g_boMirServer_GetStart;
  CheckBoxLoginGateSleep.Checked := g_boLoginGateSleep;
  SpinEditLoginGateSleep.Value := g_nLoginGateSleep;
  m_boOpen := True;
end;

procedure TfrmMain.CheckBoxDBServerClick(Sender: TObject);
begin
  g_boDBServer_GetStart := CheckBoxDBServer.Checked;
end;

procedure TfrmMain.CheckBoxLoginServerClick(Sender: TObject);
begin
  g_boLoginServer_GetStart := CheckBoxLoginServer.Checked;
end;

procedure TfrmMain.CheckBoxM2ServerClick(Sender: TObject);
begin
  g_boMirServer_GetStart := CheckBoxM2Server.Checked;
end;

procedure TfrmMain.CheckBoxLogServerClick(Sender: TObject);
begin
  g_boLogServer_GetStart := CheckBoxLogServer.Checked;
end;

procedure TfrmMain.CheckBoxLoginGateClick(Sender: TObject);
begin
  g_boLoginGate_GetStart := CheckBoxLoginGate.Checked;
end;

procedure TfrmMain.CheckBoxSelGateClick(Sender: TObject);
begin
  g_boSelGate_GetStart := CheckBoxSelGate.Checked;
end;

procedure TfrmMain.CheckBoxRunGateClick(Sender: TObject);
begin
  g_boRunGate_GetStart := CheckBoxRunGate.Checked;
end;

procedure TfrmMain.ButtonStartGameClick(Sender: TObject);
begin
  //SetWindowPos(Self.Handle, Self.Handle, Self.Left, Self.Top, Self.Width, Self.Height, $40);
  case m_nStartStatus of
    0:
      begin
        if Application.MessageBox('是否确认启动游戏服务器 ?', '确认信息', MB_YESNO + MB_ICONQUESTION) = mrYes then
        begin
          StartGame();
        end;
      end;
    1:
      begin
        if Application.MessageBox('是否确认中止启动游戏服务器 ?', '确认信息', MB_YESNO + MB_ICONQUESTION) = mrYes then
        begin
          TimerStartGame.Enabled := False;
          m_nStartStatus := 2;
          ButtonStartGame.Caption := g_sButtonStopGame;
        end;
      end;
    2:
      begin
        if Application.MessageBox('是否确认停止游戏服务器 ?', '确认信息', MB_YESNO + MB_ICONQUESTION) = mrYes then
        begin
          StopGame();
        end;
      end;
    3:
      begin
        if Application.MessageBox('是否确认中止启动游戏服务器 ?', '确认信息', MB_YESNO + MB_ICONQUESTION) = mrYes then
        begin
          TimerStopGame.Enabled := False;
          m_nStartStatus := 2;
          ButtonStartGame.Caption := g_sButtonStopGame;
        end;
      end;
  end;
end;

procedure TfrmMain.StartGame;
begin
  FillChar(DBServer, SizeOf(TProgram), #0);
  DBServer.boGetStart := g_boDBServer_GetStart;
  DBServer.boReStart := True;
  DBServer.sDirectory := g_sGameDirectory + g_sDBServer_Directory;
  DBServer.sProgramFile := g_sDBServer_ProgramFile;
  DBServer.nMainFormX := g_nDBServer_MainFormX;
  DBServer.nMainFormY := g_nDBServer_MainFormY;

  FillChar(LoginServer, SizeOf(TProgram), #0);
  LoginServer.boGetStart := g_boLoginServer_GetStart;
  LoginServer.boReStart := True;
  LoginServer.sDirectory := g_sGameDirectory + g_sLoginServer_Directory;
  LoginServer.sProgramFile := g_sLoginServer_ProgramFile;
  LoginServer.nMainFormX := g_nLoginServer_MainFormX;
  LoginServer.nMainFormY := g_nLoginServer_MainFormY;

  FillChar(LogServer, SizeOf(TProgram), #0);
  LogServer.boGetStart := g_boLogServer_GetStart;
  LogServer.boReStart := True;
  LogServer.sDirectory := g_sGameDirectory + g_sLogServer_Directory;
  LogServer.sProgramFile := g_sLogServer_ProgramFile;
  LogServer.nMainFormX := g_nLogServer_MainFormX;
  LogServer.nMainFormY := g_nLogServer_MainFormY;

  FillChar(MirServer, SizeOf(TProgram), #0);
  MirServer.boGetStart := g_boMirServer_GetStart;
  MirServer.boReStart := True;
  MirServer.sDirectory := g_sGameDirectory + g_sMirServer_Directory;
  MirServer.sProgramFile := g_sMirServer_ProgramFile;
  MirServer.nMainFormX := g_nMirServer_MainFormX;
  MirServer.nMainFormY := g_nMirServer_MainFormY;

  FillChar(RunGate, SizeOf(TProgram), #0);
  RunGate.boGetStart := g_boRunGate_GetStart;
  RunGate.boReStart := True;
  RunGate.sDirectory := g_sGameDirectory + g_sRunGate_Directory;
  RunGate.sProgramFile := g_sRunGate_ProgramFile;

  FillChar(SelGate, SizeOf(TProgram), #0);
  SelGate.boGetStart := g_boSelGate_GetStart;
  SelGate.boReStart := True;
  SelGate.sDirectory := g_sGameDirectory + g_sSelGate_Directory;
  SelGate.sProgramFile := g_sSelGate_ProgramFile;
  SelGate.nMainFormX := g_nSelGate_MainFormX;
  SelGate.nMainFormY := g_nSelGate_MainFormY;

  FillChar(LoginGate, SizeOf(TProgram), #0);
  LoginGate.boGetStart := g_boLoginGate_GetStart;
  LoginGate.boReStart := True;
  LoginGate.sDirectory := g_sGameDirectory + g_sLoginGate_Directory;
  LoginGate.sProgramFile := g_sLoginGate_ProgramFile;
  LoginGate.nMainFormX := g_nLoginGate_MainFormX;
  LoginGate.nMainFormY := g_nLoginGate_MainFormY;

  ButtonStartGame.Caption := g_sButtonStopStartGame;
  m_nStartStatus := 1;
  TimerStartGame.Enabled := True;
end;

procedure TfrmMain.StopGame;
begin
  ButtonStartGame.Caption := g_sButtonStopStopGame;
  MainOutMessage('正在开始停止服务器...');
  TimerCheckRun.Enabled := False;
  TimerStopGame.Enabled := True;
  m_nStartStatus := 3;
end;

procedure TfrmMain.TimerStartGameTimer(Sender: TObject);
var
  nRetCode: Integer;
begin
  if DBServer.boGetStart then
  begin
    case DBServer.btStartStatus of //
      0:
        begin
          nRetCode := RunProgram(DBServer, IntToStr(Self.Handle), 0);
          if nRetCode = 0 then
          begin
            DBServer.btStartStatus := 1;
            DBServer.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, DBServer.ProcessInfo.dwProcessId);
          end
          else
          begin
            if not DBServer.IsShowError then
            begin
              MainOutMessage(Format('DBServer启动失败; 错误代码:%d; %s', [nRetCode, SysErrorMessage(nRetCode)]));
              DBServer.IsShowError := True;          //   服务器启动失败错误日志只提示一次  2019-10-08 11:38:00
            end
          end;
          Exit;
        end;
      1:
        begin //如果状态为1 则还没启动完成
          //        DBServer.btStartStatus:=2;
          Exit;
        end;
    end;
  end;
  if LoginServer.boGetStart then
  begin
    case LoginServer.btStartStatus of //
      0:
        begin
          nRetCode := RunProgram(LoginServer, IntToStr(Self.Handle), 0);
          if nRetCode = 0 then
          begin
            LoginServer.btStartStatus := 1;
            LoginServer.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, LoginServer.ProcessInfo.dwProcessId);
          end
          else
          begin
            LoginServer.btStartStatus := 9;
            if not LoginServer.IsShowError then
            begin
              MainOutMessage(Format('LoginServer启动失败; 错误代码:%d; %s', [nRetCode, SysErrorMessage(nRetCode)]));
              LoginServer.IsShowError := True;         //   服务器启动失败错误日志只提示一次  2019-10-08 11:38:00
            end;

          end;
          Exit;
        end;
      1:
        begin //如果状态为1 则还没启动完成
          //        LoginServer.btStartStatus:=2;
          Exit;
        end;
    end;
  end;

  if LogServer.boGetStart then
  begin
    case LogServer.btStartStatus of //
      0:
        begin
          nRetCode := RunProgram(LogServer, IntToStr(Self.Handle), 0);
          if nRetCode = 0 then
          begin
            LogServer.btStartStatus := 1;
            LogServer.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, LogServer.ProcessInfo.dwProcessId);
          end
          else
          begin
            LogServer.btStartStatus := 9;
            if not LogServer.IsShowError then
            begin
              MainOutMessage(Format('LogServer启动失败; 错误代码:%d; %s', [nRetCode, SysErrorMessage(nRetCode)]));
              LogServer.IsShowError := True;        //  服务器启动失败错误日志只提示一次  2019-10-08 11:38:00
            end;
           Exit;
           end;
        end;
      1:
        begin //如果状态为1 则还没启动完成
          //LogServer.btStartStatus := 2;
          Exit;
        end;
    end;
  end;

  if MirServer.boGetStart then
  begin
    case MirServer.btStartStatus of
      0:
        begin
          nRetCode := RunProgram(MirServer, IntToStr(Self.Handle), 0);
          if nRetCode = 0 then
          begin
            MirServer.btStartStatus := 1;
            MirServer.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, MirServer.ProcessInfo.dwProcessId);
          end
          else
          begin
            MirServer.btStartStatus := 9;
            if not MirServer.IsShowError then
            begin
              MainOutMessage(Format('MirServer启动失败; 错误代码:%d; %s', [nRetCode, SysErrorMessage(nRetCode)]));
              MirServer.IsShowError := True;            //    服务器启动失败错误日志只提示一次  2019-10-08 11:38:00
            end;
          end;
          Exit;
        end;
      1:
        begin
          //MirServer.btStartStatus:=2;
          Exit;
        end;
    end;
  end;

  if RunGate.boGetStart then
  begin
    case RunGate.btStartStatus of //
      0:
        begin
          //GetMutRunGateConfing(0);
          nRetCode := RunProgram(RunGate, IntToStr(Self.Handle), 2000);
          if nRetCode = 0 then
          begin
            RunGate.btStartStatus := 1;
            RunGate.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, RunGate.ProcessInfo.dwProcessId);
          end
          else
          begin
            RunGate.btStartStatus := 9;
            if not RunGate.IsShowError then
            begin
              MainOutMessage(Format('RunGate启动失败; 错误代码:%d; %s', [nRetCode, SysErrorMessage(nRetCode)]));
              RunGate.IsShowError := True;             //   服务器启动失败错误日志只提示一次  2019-10-08 11:38:00
            end;
          end;
          Exit;
        end;
      1:
        begin //如果状态为1 则还没启动完成
          RunGate.btStartStatus := 2;
          //        exit;
        end;
    end;
  end;

  if SelGate.boGetStart then
  begin
    case SelGate.btStartStatus of
      0:
        begin
          //GenMutSelGateConfig(0);
          nRetCode := RunProgram(SelGate, IntToStr(Self.Handle), 0);
          if nRetCode = 0 then
          begin
            SelGate.btStartStatus := 1;
            SelGate.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, SelGate.ProcessInfo.dwProcessId);
          end
          else
          begin
            SelGate.btStartStatus := 9;
            if not SelGate.IsShowError then
            begin
              MainOutMessage(Format('SelGate启动失败; 错误代码:%d; %s', [nRetCode, SysErrorMessage(nRetCode)]));
              SelGate.IsShowError := True;           //  服务器启动失败错误日志只提示一次  2019-10-08 11:38:00
            end;
          end;
          Exit;
        end;
      1:
        begin //如果状态为1 则还没启动完成
          SelGate.btStartStatus := 2;
          Exit;
        end;
    end;
  end;

  if LoginGate.boGetStart then
  begin
    case LoginGate.btStartStatus of //
      0:
        begin
          if g_boLoginGateSleep then
            nRetCode := RunProgram(LoginGate, IntToStr(Self.Handle), g_nLoginGateSleep * 1000)
          else
            nRetCode := RunProgram(LoginGate, IntToStr(Self.Handle), g_nLoginGateSleep * 1000);
          if nRetCode = 0 then
          begin
            LoginGate.btStartStatus := 1;
            LoginGate.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, LoginGate.ProcessInfo.dwProcessId);
          end
          else
          begin
            LoginGate.btStartStatus := 9;
            if not LoginGate.IsShowError then
            begin
              MainOutMessage(Format('LoginGate启动失败; 错误代码:%d; %s', [nRetCode, SysErrorMessage(nRetCode)]));
              LoginGate.IsShowError := True;        //  服务器启动失败错误日志只提示一次  2019-10-08 11:38:00
            end;
          end;
          Exit;
        end;
      1:
        begin //如果状态为1 则还没启动完成
          LoginGate.btStartStatus := 2;
          Exit;
        end;
    end;
  end;

  TimerStartGame.Enabled := False;
  TimerCheckRun.Enabled := True;
  ButtonStartGame.Caption := g_sButtonStopGame;
  //ButtonStartGame.Enabled := True;
  m_nStartStatus := 2;
  //SetWindowPos(Self.Handle, HWND_TOPMOST, Self.Left, Self.Top, Self.Width, Self.Height, $40);
end;

procedure TfrmMain.TimerStopGameTimer(Sender: TObject);
var
  dwExitCode: LongWord;
  nRetCode: Integer;
begin
  if LoginGate.boGetStart and (LoginGate.btStartStatus in [2, 3]) then
  begin
    GetExitCodeProcess(LoginGate.ProcessHandle, dwExitCode);
    if dwExitCode = STILL_ACTIVE then
    begin
      if LoginGate.btStartStatus = 3 then
      begin
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then
        begin
          StopProgram(LoginGate, 0);
          MainOutMessage('正常关闭超时，登录网关已被强行停止...');
        end;
        Exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(LoginGate.MainFormHandle, GS_QUIT, '');
      g_dwStopTick := GetTickCount();
      LoginGate.btStartStatus := 3;
      Exit;
    end
    else
    begin
      CloseHandle(LoginGate.ProcessHandle);
      LoginGate.btStartStatus := 0;
      MainOutMessage('登录网关已停止...');
    end;
  end;

  if SelGate.boGetStart and (SelGate.btStartStatus in [2, 3]) then
  begin
    GetExitCodeProcess(SelGate.ProcessHandle, dwExitCode);
    if dwExitCode = STILL_ACTIVE then
    begin
      if SelGate.btStartStatus = 3 then
      begin
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then
        begin
          StopProgram(SelGate, 0);
          MainOutMessage('正常关闭超时，角色网关已被强行停止...');
        end;
        Exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(SelGate.MainFormHandle, GS_QUIT, '');
      g_dwStopTick := GetTickCount();
      SelGate.btStartStatus := 3;
      Exit;
    end
    else
    begin
      CloseHandle(SelGate.ProcessHandle);
      SelGate.btStartStatus := 0;
      MainOutMessage('角色网关一已停止...');
    end;
  end;

  if RunGate.boGetStart and (RunGate.btStartStatus in [2, 3]) then
  begin
    GetExitCodeProcess(RunGate.ProcessHandle, dwExitCode);
    if dwExitCode = STILL_ACTIVE then
    begin
      nRetCode := StopProgram(RunGate, 2000);
      if nRetCode = 0 then
      begin
        CloseHandle(RunGate.ProcessHandle);
        RunGate.btStartStatus := 0;
        MainOutMessage('游戏网关一已停止...');
      end;
    end;
  end;

  if MirServer.boGetStart and (MirServer.btStartStatus in [2, 3]) then
  begin
    GetExitCodeProcess(MirServer.ProcessHandle, dwExitCode);
    if dwExitCode = STILL_ACTIVE then
    begin
      if MirServer.btStartStatus = 3 then
      begin
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then
        begin
          StopProgram(MirServer, 1000);
          MainOutMessage('正常关闭超时，游戏引擎主程序(M2Server.exe)已被强行停止...');
        end;
        Exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(MirServer.MainFormHandle, GS_QUIT, '');
      g_dwStopTick := GetTickCount();
      MirServer.btStartStatus := 3;
      Exit;
    end
    else
    begin
      CloseHandle(MirServer.ProcessHandle);
      MirServer.btStartStatus := 0;
      MainOutMessage('游戏引擎主程序已停止...');
    end;
  end;

  if LoginServer.boGetStart and (LoginServer.btStartStatus in [2, 3]) then
  begin
    GetExitCodeProcess(LoginServer.ProcessHandle, dwExitCode);
    if dwExitCode = STILL_ACTIVE then
    begin
      if LoginServer.btStartStatus = 3 then
      begin
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then
        begin
          StopProgram(LoginServer, 1000);
          MainOutMessage('正常关闭超时，登陆服务器已被强行停止...');
        end;
        Exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(LoginServer.MainFormHandle, GS_QUIT, '');
      g_dwStopTick := GetTickCount();
      LoginServer.btStartStatus := 3;
      Exit;
    end
    else
    begin
      CloseHandle(LoginServer.ProcessHandle);
      LoginServer.btStartStatus := 0;
      MainOutMessage('登录服务器已停止...');
    end;
  end;

  if LogServer.boGetStart and (LogServer.btStartStatus in [2, 3]) then
  begin
    GetExitCodeProcess(LogServer.ProcessHandle, dwExitCode);
    if dwExitCode = STILL_ACTIVE then
    begin
      if LogServer.btStartStatus = 3 then
      begin
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then
        begin
          StopProgram(LogServer, 0);
          MainOutMessage('正常关闭超时，游戏日志服务器已被强行停止...');
        end;
        Exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(LogServer.MainFormHandle, GS_QUIT, '');
      g_dwStopTick := GetTickCount();
      LogServer.btStartStatus := 3;
      Exit;
    end
    else
    begin
      CloseHandle(LogServer.ProcessHandle);
      LogServer.btStartStatus := 0;
      MainOutMessage('游戏日志服务器已停止...');
    end;
  end;

  if DBServer.boGetStart and (DBServer.btStartStatus in [2, 3]) then
  begin
    GetExitCodeProcess(DBServer.ProcessHandle, dwExitCode);
    if dwExitCode = STILL_ACTIVE then
    begin
      if DBServer.btStartStatus = 3 then
      begin
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then
        begin
          StopProgram(DBServer, 0);
          MainOutMessage('正常关闭超时，游戏数据库服务器已被强行停止...');
        end;
        Exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(DBServer.MainFormHandle, GS_QUIT, '');
      g_dwStopTick := GetTickCount();
      DBServer.btStartStatus := 3;
      Exit;
    end
    else
    begin
      CloseHandle(DBServer.ProcessHandle);
      DBServer.btStartStatus := 0;
      MainOutMessage('游戏数据库服务器已停止...');
    end;
  end;

  TimerStopGame.Enabled := False;
  ButtonStartGame.Caption := g_sButtonStartGame;
  m_nStartStatus := 0;
end;

procedure TfrmMain.TimerCheckRunTimer(Sender: TObject);
var
  dwExitCode: LongWord;
  nRetCode: Integer;
begin
  if DBServer.boGetStart then
  begin
    GetExitCodeProcess(DBServer.ProcessHandle, dwExitCode);
    if dwExitCode <> STILL_ACTIVE then
    begin
      nRetCode := RunProgram(DBServer, IntToStr(Self.Handle), 0);
      if nRetCode = 0 then
      begin
        CloseHandle(DBServer.ProcessHandle);
        DBServer.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, DBServer.ProcessInfo.dwProcessId);
        MainOutMessage('数据库异常关闭，已被重新启动...');
      end;
    end;
  end;

  if LoginServer.boGetStart then
  begin
    GetExitCodeProcess(LoginServer.ProcessHandle, dwExitCode);
    if dwExitCode <> STILL_ACTIVE then
    begin
      nRetCode := RunProgram(LoginServer, IntToStr(Self.Handle), 0);
      if nRetCode = 0 then
      begin
        CloseHandle(LoginServer.ProcessHandle);
        LoginServer.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, LoginServer.ProcessInfo.dwProcessId);
        MainOutMessage('登录服务器异常关闭，已被重新启动...');
      end;
    end;
  end;

  if LogServer.boGetStart then
  begin
    GetExitCodeProcess(LogServer.ProcessHandle, dwExitCode);
    if dwExitCode <> STILL_ACTIVE then
    begin
      nRetCode := RunProgram(LogServer, IntToStr(Self.Handle), 0);
      if nRetCode = 0 then
      begin
        CloseHandle(LogServer.ProcessHandle);
        LogServer.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, LogServer.ProcessInfo.dwProcessId);
        MainOutMessage('日志服务器异常关闭，已被重新启动...');
      end;
    end;
  end;

  if MirServer.boGetStart then
  begin
    GetExitCodeProcess(MirServer.ProcessHandle, dwExitCode);
    //MainOutMessage(IntToStr(dwExitCode));
    if dwExitCode <> STILL_ACTIVE then
    begin
      nRetCode := RunProgram(MirServer, IntToStr(Self.Handle), 0);
      if nRetCode = 0 then
      begin
        CloseHandle(MirServer.ProcessHandle);
        MirServer.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, MirServer.ProcessInfo.dwProcessId);
        MainOutMessage('游戏引擎服务器异常关闭，已被重新启动...');
      end;
    end;
  end;

  if RunGate.boGetStart then
  begin
    GetExitCodeProcess(RunGate.ProcessHandle, dwExitCode);
    if dwExitCode <> STILL_ACTIVE then
    begin
      //GetMutRunGateConfing(0);
      nRetCode := RunProgram(RunGate, IntToStr(Self.Handle), 2000);
      if nRetCode = 0 then
      begin
        CloseHandle(RunGate.ProcessHandle);
        RunGate.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, RunGate.ProcessInfo.dwProcessId);
        MainOutMessage('游戏网关一异常关闭，已被重新启动...');
      end;
    end;
  end;

  if SelGate.boGetStart then
  begin
    GetExitCodeProcess(SelGate.ProcessHandle, dwExitCode);
    if dwExitCode <> STILL_ACTIVE then
    begin
      nRetCode := RunProgram(SelGate, IntToStr(Self.Handle), 0);
      if nRetCode = 0 then
      begin
        CloseHandle(SelGate.ProcessHandle);
        SelGate.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, SelGate.ProcessInfo.dwProcessId);
        MainOutMessage('角色网关一异常关闭，已被重新启动...');
      end;
    end;
  end;

  if LoginGate.boGetStart then
  begin
    GetExitCodeProcess(LoginGate.ProcessHandle, dwExitCode);
    if dwExitCode <> STILL_ACTIVE then
    begin
      nRetCode := RunProgram(LoginGate, IntToStr(Self.Handle), 0);
      if nRetCode = 0 then
      begin
        CloseHandle(LoginGate.ProcessHandle);
        LoginGate.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, LoginGate.ProcessInfo.dwProcessId);
        MainOutMessage('登录网关异常关闭，已被重新启动...');
      end;
    end;
  end;
end;

procedure TfrmMain.ProcessMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.message = WM_SENDPROCMSG then
  begin
    Handled := True;
  end;
end;

procedure TfrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  ProgramType: TProgamType;
  wIdent: Word;
begin
  wIdent := HiWord(MsgData.From);
  ProgramType := TProgamType(LoWord(MsgData.From));
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case ProgramType of //
    tDBServer: ProcessDBServerMsg(wIdent, sData);
    tLoginSrv: ProcessLoginSrvMsg(wIdent, sData);
    tLogServer: ProcessLogServerMsg(wIdent, sData);
    tM2Server: ProcessMirServerMsg(wIdent, sData);
    tLoginGate: ProcessLoginGateMsg(wIdent, sData);
    tSelGate: ProcessSelGateMsg(wIdent, sData);
    tRunGate: ProcessRunGateMsg(wIdent, sData);
  end;
end;

procedure TfrmMain.analyseScript(idx: Integer; s: string);
var
  l, c, f, ff: string;
  i: Integer;
  tlist: TStringList;
label
  lab;
begin
  tlist := TStringList.Create;
  try
    if FileExists(s) then
    begin
      tlist.LoadFromFile(s);
      for i := 0 to tlist.Count - 1 do
      begin
        l := tlist[i];
        if (l = '') or (l[1] = ';') or (l[1] = '/') or (l[1] = '[') or (l[1] = '#') then
          continue;
        //g_Config.sEnvirDir + 'UnMarry.txt';

        if (Pos(uppercase('LoadVar'), uppercase(l)) > 0) or
          (Pos(uppercase('SaveVar'), uppercase(l)) > 0) then
        begin
          l := GetValidStr3(l, c, [' ', #9]);
          l := GetValidStr3(l, c, [' ', #9]); //1
          l := GetValidStr3(l, c, [' ', #9]); //2
          l := GetValidStr3(l, f, [' ', #9]); //3

          goto lab;

        end
        else if
          //(Pos(uppercase('ReadRandomStr'), uppercase(l)) > 0) or
//(Pos(uppercase('ReadRandomLine'), uppercase(l)) > 0) or
        (Pos(uppercase('CheckAccountIPList'), uppercase(l)) > 0) or
          (Pos(uppercase('CheckNameListPosition'), uppercase(l)) > 0) or
          (Pos(uppercase('CheckNameIPList'), uppercase(l)) > 0) or
          //(Pos(uppercase('WriteLineList'), uppercase(l)) > 0) or
        (Pos(uppercase('AddNameDateList'), uppercase(l)) > 0) or
          (Pos(uppercase('CheckUserDateType'), uppercase(l)) > 0) or
          (Pos(uppercase('CheckCodeList'), uppercase(l)) > 0) or
          (Pos(uppercase('DelCodeList'), uppercase(l)) > 0) or
          (Pos(uppercase('AddUseDateList'), uppercase(l)) > 0) or
          (Pos(uppercase('DELUseDateList'), uppercase(l)) > 0) or
          (Pos(uppercase('ADDNAMELIST'), uppercase(l)) > 0) or
          (Pos(uppercase('DELNAMELIST'), uppercase(l)) > 0) or
          (Pos(uppercase('CheckNameDateList'), uppercase(l)) > 0) or
          (Pos(uppercase('CheckStringList'), uppercase(l)) > 0) or
          (Pos(uppercase('CheckCodeList'), uppercase(l)) > 0) or
          (Pos(uppercase('DelNameDateList'), uppercase(l)) > 0) or
          (Pos(uppercase('ClearNameList'), uppercase(l)) > 0) then
        begin
          l := GetValidStr3(l, c, [' ', #9]);
          l := GetValidStr3(l, f, [' ', #9]);

          lab:
          ff := '';
          if Pos('..', f) > 0 then
          begin
            case idx of
              Idx_Market_Def: ff := g_sEnvirDir + 'Market_Def\' + f;
              Idx_Npc_Def: ff := g_sEnvirDir + 'Npc_def\' + f;
              Idx_Robot_def: ff := g_sEnvirDir + 'Robot_def\' + f;
              Idx_MapQuest_def: ff := g_sEnvirDir + 'MapQuest_def\' + f;
            end;
          end
          else
          begin
            ff := g_sEnvirDir + f;
          end;
          ff := ExpandFileName(ff);
          if FileExists(ff) then
            addToTextClearList(ff);

        end;

      end;
    end;
  finally
    tlist.Free;
  end;
end;

procedure TfrmMain.FindFiles(APath: string; list: TStringList);
var
  FindResult: Integer;
  FSearchRec: TSearchRec;

  function IsDirNotation(ADirName: string): Boolean;
  begin
    Result := ((ADirName = '.') or (ADirName = '..'));
  end;

begin
  if APath[Length(APath)] <> '\' then
    APath := APath + '\';
  FindResult := FindFirst(APath + '*.*', faAnyFile, FSearchRec); //进入当前目录的子目录继续查找
  try
    while FindResult = 0 do
    begin
      if ExtractFileExt(FSearchRec.Name) = '.txt' then
        list.Add(APath + FSearchRec.Name)
      else if ((FSearchRec.Attr and faDirectory) = faDirectory) and not IsDirNotation(FSearchRec.Name) then
        FindFiles(APath + FSearchRec.Name, list);
      FindResult := FindNext(FSearchRec);
    end;
  finally
    FindClose(FSearchRec);
  end;
end;

procedure TfrmMain.N1Click(Sender: TObject);
var
  s: string;
  i: Integer;
  tlist: TStringList;
begin
  s := EditMirDir.Text + 'Mir200\Envir\AutoLogin.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\DenyAccountList.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\DenyChrNameList.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\DenyChrNameList.txt';
  addToTextClearList(s);

  s := EditMirDir.Text + 'Mir200\Envir\DenyIPAddrList.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\DisableSendMsgList.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\ItemBindAccount.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\ItemBindChrName.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\ItemBindIPaddr.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\ItemNameList.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\master.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\UnForceMaster.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\unmarry.txt';
  addToTextClearList(s);
  s := EditMirDir.Text + 'Mir200\Envir\UnMaster.txt';
  addToTextClearList(s);

  //s := EditMirDir.Text + 'Mir200\Envir\MapQuest_def\QManage.txt';
  //analyseScript(s);

  s := EditMirDir.Text + 'Mir200\Envir\MapQuest_def\';
  tlist := TStringList.Create;
  try
    FindFiles(s, tlist);
    for i := 0 to tlist.Count - 1 do
    begin
      analyseScript(Idx_MapQuest_def, tlist[i]);
    end;
  finally
    tlist.Free;
  end;

  s := EditMirDir.Text + 'Mir200\Envir\Market_Def\';
  tlist := TStringList.Create;
  try
    FindFiles(s, tlist);
    for i := 0 to tlist.Count - 1 do
    begin
      analyseScript(Idx_Market_Def, tlist[i]);
    end;
  finally
    tlist.Free;
  end;

  s := EditMirDir.Text + 'Mir200\Envir\Npc_Def\';
  tlist := TStringList.Create;
  try
    FindFiles(s, tlist);
    for i := 0 to tlist.Count - 1 do
    begin
      analyseScript(Idx_Npc_Def, tlist[i]);
    end;
  finally
    tlist.Free;
  end;

  s := EditMirDir.Text + 'Mir200\Envir\Robot_def\';
  tlist := TStringList.Create;
  try
    FindFiles(s, tlist);
    for i := 0 to tlist.Count - 1 do
    begin
      analyseScript(Idx_Robot_def, tlist[i]);
    end;
  finally
    tlist.Free;
  end;

end;

procedure TfrmMain.O1Click(Sender: TObject);
var
  i: Integer;
begin
  {if (CheckListBoxClear.ItemIndex >= 0) and (CheckListBoxClear.ItemIndex < CheckListBoxClear.Items.Count) then begin
    if FileExists(CheckListBoxClear.Items[CheckListBoxClear.ItemIndex]) then
      ShellExecute(Handle, nil, PChar(CheckListBoxClear.Items[CheckListBoxClear.ItemIndex]), nil, nil, sw_shownormal);
  end;}
  for i := 0 to CheckListBoxClear.Items.Count - 1 do
  begin
    if CheckListBoxClear.Selected[i] and FileExists(CheckListBoxClear.Items[i]) then
    begin
      ShellExecute(Handle, nil, PChar(CheckListBoxClear.Items[i]), nil, nil, sw_shownormal);
      Application.ProcessMessages;
    end;
  end;
end;

procedure TfrmMain.O2Click(Sender: TObject);
var
  i: Integer;
begin
  {if (CheckListBoxClear.ItemIndex >= 0) and (CheckListBoxClear.ItemIndex < CheckListBoxClear.Items.Count) then begin
    if FileExists(CheckListBoxClear.Items[CheckListBoxClear.ItemIndex]) then
      ShellExecute(Handle, nil, PChar(CheckListBoxClear.Items[CheckListBoxClear.ItemIndex]), nil, nil, sw_shownormal);
  end;}
  for i := 0 to CheckListBoxDel.Items.Count - 1 do
  begin
    if CheckListBoxDel.Selected[i] and FileExists(CheckListBoxDel.Items[i]) then
    begin
      ShellExecute(Handle, nil, PChar(CheckListBoxDel.Items[i]), nil, nil, sw_shownormal);
      Application.ProcessMessages;
    end;
  end;
end;

procedure TfrmMain.ProcessDBServerMsg(wIdent: Word; sData: string);
var
  Handle: THandle;
begin
  case wIdent of
    SG_FORMHANDLE:
      begin
        Handle := Str_ToInt(sData, 0);
        if Handle <> 0 then
        begin
          DBServer.MainFormHandle := Handle;
          //SetWindowPos(Self.Handle, Handle, Self.Left, Self.Top, Self.Width, Self.Height, $40);
        end;
      end;
    SG_STARTNOW:
      begin
        MainOutMessage(sData);
      end;
    SG_STARTOK:
      begin
        DBServer.btStartStatus := 2;
        MainOutMessage(sData);
      end;
    SG_CHECKCODEADDR:
      begin
        g_dwDBCheckCodeAddr := Str_ToInt(sData, -1);
      end;
  end;
end;

procedure TfrmMain.ProcessLoginGateMsg(wIdent: Word; sData: string);
var
  Handle: THandle;
begin
  case wIdent of
    SG_FORMHANDLE:
      begin
        Handle := Str_ToInt(sData, 0);
        if Handle <> 0 then
        begin
          LoginGate.MainFormHandle := Handle;
          //SetWindowPos(Self.Handle, Handle, Self.Left, Self.Top, Self.Width, Self.Height, $40);
        end;
      end;
    SG_STARTNOW:
      begin
        MainOutMessage(sData);
      end;
    SG_STARTOK:
      begin
        LoginGate.btStartStatus := 2;
        MainOutMessage(sData);
      end;
    2: ;
    3: ;
  end;
end;

procedure TfrmMain.ProcessSelGateMsg(wIdent: Word; sData: string);
var
  Handle: THandle;
begin
  case wIdent of
    SG_FORMHANDLE:
      begin
        Handle := Str_ToInt(sData, 0);
        if Handle <> 0 then
        begin
          SelGate.MainFormHandle := Handle;
        end;
      end;
    SG_STARTNOW:
      begin
        MainOutMessage(sData);
      end;
    SG_STARTOK:
      begin
        if SelGate.btStartStatus <> 2 then
        begin
          SelGate.btStartStatus := 2;
        end
        else
        begin
          SelGate.btStartStatus := 2;
        end;
        MainOutMessage(sData);
      end;
  end;
end;

procedure TfrmMain.ProcessMirServerMsg(wIdent: Word; sData: string);
var
  Handle: THandle;
begin
  case wIdent of
    SG_FORMHANDLE:
      begin
        Handle := Str_ToInt(sData, 0);
        if Handle <> 0 then
        begin
          MirServer.MainFormHandle := Handle;
          // SetWindowPos(Self.Handle, Handle, Self.Left, Self.Top, Self.Width, Self.Height, $40);
        end;
      end;
    SG_STARTNOW:
      begin
        MainOutMessage(sData);
      end;
    SG_STARTOK:
      begin
        MirServer.btStartStatus := 2;
        MainOutMessage(sData);
      end;
    SG_CHECKCODEADDR:
      begin
        g_dwM2CheckCodeAddr := Str_ToInt(sData, -1);
      end;
  end;

end;

procedure TfrmMain.ProcessLoginSrvMsg(wIdent: Word; sData: string);
var
  Handle: THandle;
begin
  case wIdent of
    SG_FORMHANDLE:
      begin
        Handle := Str_ToInt(sData, 0);
        if Handle <> 0 then
        begin
          LoginServer.MainFormHandle := Handle;
          //SetWindowPos(Self.Handle, Handle, Self.Left, Self.Top, Self.Width, Self.Height, $40);
        end;
      end;
    SG_STARTNOW:
      begin
        MainOutMessage(sData);
      end;
    SG_STARTOK:
      begin
        LoginServer.btStartStatus := 2;
        MainOutMessage(sData);
      end;
    SG_USERACCOUNT:
      begin
        ProcessLoginSrvGetUserAccount(sData);
      end;
    SG_USERACCOUNTCHANGESTATUS:
      begin
        ProcessLoginSrvChangeUserAccountStatus(sData);
      end;
  end;

end;

procedure TfrmMain.ProcessLogServerMsg(wIdent: Word; sData: string);
var
  Handle: THandle;
begin
  case wIdent of
    SG_FORMHANDLE:
      begin
        Handle := Str_ToInt(sData, 0);
        if Handle <> 0 then
        begin
          LogServer.MainFormHandle := Handle;
          //SetWindowPos(Self.Handle, Handle, Self.Left, Self.Top, Self.Width, Self.Height, $40);
        end;
      end;
    SG_STARTNOW:
      begin
        MainOutMessage(sData);
      end;
    SG_STARTOK:
      begin
        LogServer.btStartStatus := 2;
        MainOutMessage(sData);
      end;
  end;

end;

procedure TfrmMain.ProcessRunGateMsg(wIdent: Word; sData: string);
var
  Handle: THandle;
begin
  case wIdent of
    SG_FORMHANDLE:
      begin
        Handle := Str_ToInt(sData, 0);
        if Handle <> 0 then
        begin
          RunGate.MainFormHandle := Handle;
        end;
      end;
    1: ;
    2: ;
    3: ;
  end;
end;

procedure TfrmMain.ButtonReLoadConfigClick(Sender: TObject);
begin
  LoadConfig();
  RefGameConsole();
  Application.MessageBox('配置重加载完成...', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain.EditLoginGate_MainFormXChange(Sender: TObject);
begin
  if EditLoginGate_MainFormX.Text = '' then
  begin
    EditLoginGate_MainFormX.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nLoginGate_MainFormX := EditLoginGate_MainFormX.Value;
end;

procedure TfrmMain.EditLoginGate_MainFormYChange(Sender: TObject);
begin
  if EditLoginGate_MainFormY.Text = '' then
  begin
    EditLoginGate_MainFormY.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nLoginGate_MainFormY := EditLoginGate_MainFormY.Value;
end;

procedure TfrmMain.CheckBoxboLoginGate_GetStartClick(Sender: TObject);
begin
  if not m_boOpen then
    Exit;
  g_boLoginGate_GetStart := CheckBoxboLoginGate_GetStart.Checked;
end;

procedure TfrmMain.EditSelGate_MainFormXChange(Sender: TObject);
begin
  if EditSelGate_MainFormX.Text = '' then
  begin
    EditSelGate_MainFormX.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nSelGate_MainFormX := EditSelGate_MainFormX.Value;
end;

procedure TfrmMain.EditSelGate_MainFormYChange(Sender: TObject);
begin
  if EditSelGate_MainFormY.Text = '' then
  begin
    EditSelGate_MainFormY.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nSelGate_MainFormY := EditSelGate_MainFormY.Value;
end;

procedure TfrmMain.CheckBoxboSelGate_GetStartClick(Sender: TObject);
begin
  if not m_boOpen then
    Exit;
  g_boSelGate_GetStart := CheckBoxboSelGate_GetStart.Checked;
end;

procedure TfrmMain.EditLoginServer_MainFormXChange(Sender: TObject);
begin
  if EditLoginServer_MainFormX.Text = '' then
  begin
    EditLoginServer_MainFormX.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nLoginServer_MainFormX := EditLoginServer_MainFormX.Value;
end;

procedure TfrmMain.EditLoginServer_MainFormYChange(Sender: TObject);
begin
  if EditLoginServer_MainFormY.Text = '' then
  begin
    EditLoginServer_MainFormY.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nLoginServer_MainFormY := EditLoginServer_MainFormY.Value;
end;

procedure TfrmMain.CheckBoxboLoginServer_GetStartClick(Sender: TObject);
begin
  if not m_boOpen then
    Exit;
  g_boLoginServer_GetStart := CheckBoxboLoginServer_GetStart.Checked;
end;

procedure TfrmMain.EditDBServer_MainFormXChange(Sender: TObject);
begin
  if EditDBServer_MainFormX.Text = '' then
  begin
    EditDBServer_MainFormX.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nDBServer_MainFormX := EditDBServer_MainFormX.Value;
end;

procedure TfrmMain.EditDBServer_MainFormYChange(Sender: TObject);
begin
  if EditDBServer_MainFormY.Text = '' then
  begin
    EditDBServer_MainFormY.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nDBServer_MainFormY := EditDBServer_MainFormY.Value;
end;

procedure TfrmMain.CheckBoxDBServerGetStartClick(Sender: TObject);
begin
  if not m_boOpen then
    Exit;
  g_boDBServer_GetStart := CheckBoxDBServerGetStart.Checked;
end;

procedure TfrmMain.EditLogServer_MainFormXChange(Sender: TObject);
begin
  if EditLogServer_MainFormX.Text = '' then
  begin
    EditLogServer_MainFormX.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nLogServer_MainFormX := EditLogServer_MainFormX.Value;
end;

procedure TfrmMain.EditLogServer_MainFormYChange(Sender: TObject);
begin
  if EditLogServer_MainFormY.Text = '' then
  begin
    EditLogServer_MainFormY.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nLogServer_MainFormY := EditLogServer_MainFormY.Value;
end;

procedure TfrmMain.CheckBoxLogServerGetStartClick(Sender: TObject);
begin
  if not m_boOpen then
    Exit;
  g_boLogServer_GetStart := CheckBoxLogServerGetStart.Checked;
end;

procedure TfrmMain.EditM2Server_MainFormXChange(Sender: TObject);
begin
  if EditM2Server_MainFormX.Text = '' then
  begin
    EditM2Server_MainFormX.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nMirServer_MainFormX := EditM2Server_MainFormX.Value;
end;

procedure TfrmMain.EditM2Server_MainFormYChange(Sender: TObject);
begin
  if EditM2Server_TestLevel.Text = '' then
  begin
    EditM2Server_TestLevel.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nMirServer_TestLevel := EditM2Server_TestLevel.Value;
end;

procedure TfrmMain.EditM2Server_TestLevelChange(Sender: TObject);
begin
  if EditM2Server_MainFormY.Text = '' then
  begin
    EditM2Server_MainFormY.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nMirServer_MainFormY := EditM2Server_MainFormY.Value;
end;

procedure TfrmMain.EditM2Server_TestGoldChange(Sender: TObject);
begin
  if EditM2Server_TestGold.Text = '' then
  begin
    EditM2Server_TestGold.Text := '0';
  end;
  if not m_boOpen then
    Exit;
  g_nMirServer_TestGold := EditM2Server_TestGold.Value;
end;

procedure TfrmMain.CheckBoxM2ServerGetStartClick(Sender: TObject);
begin
  if not m_boOpen then
    Exit;
  g_boMirServer_GetStart := CheckBoxM2ServerGetStart.Checked;
end;

procedure TfrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 100 then
    MemoLog.Clear;
end;

procedure TfrmMain.addToTextClearList(s: string);
var
  n, m: Integer;
begin
  m := -1;
  for n := 0 to CheckListBoxClear.Items.Count - 1 do
  begin
    if CompareText(CheckListBoxClear.Items.Strings[n], s) = 0 then
    begin
      m := n;
      Break;
    end;
  end;
  if m = -1 then
  begin
    CheckListBoxClear.AddItem(s, nil);
  end;
end;

procedure TfrmMain.addToTextClearList2(s: string);
var
  n, m: Integer;
begin
  m := -1;
  for n := 0 to CheckListBoxDel.Items.Count - 1 do
  begin
    if CompareText(CheckListBoxDel.Items.Strings[n], s) = 0 then
    begin
      m := n;
      Break;
    end;
  end;
  if m = -1 then
  begin
    CheckListBoxDel.AddItem(s, nil);
  end;
end;

procedure TfrmMain.MenuItem1Click(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  OpenDialog1.InitialDir := EditMirDir.Text;

  if not OpenDialog1.Execute then
    Exit;

  for i := 0 to OpenDialog1.Files.Count - 1 do
  begin
    s := OpenDialog1.Files.Strings[i];
    addToTextClearList2(s);
  end;
end;

procedure TfrmMain.MenuItem3Click(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  OpenDialog1.InitialDir := EditMirDir.Text;
  if not OpenDialog1.Execute then
    Exit;

  for i := 0 to OpenDialog1.Files.Count - 1 do
  begin
    s := OpenDialog1.Files.Strings[i];
    addToTextClearList(s);
  end;
end;

procedure TfrmMain.MenuItem4Click(Sender: TObject);
begin
  CheckListBoxClear.DeleteSelected;
end;

procedure TfrmMain.MenuItem5Click(Sender: TObject);
begin
  CheckListBoxClear.Clear;
end;

procedure TfrmMain.MenuItem6Click(Sender: TObject);
begin
  CheckListBoxDel.DeleteSelected;
end;

procedure TfrmMain.MenuItem7Click(Sender: TObject);
begin
  CheckListBoxDel.Clear;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if m_nStartStatus = 2 then
  begin
    if Application.MessageBox('游戏服务器正在运行，是否停止游戏服务器？', '确认信息', MB_YESNO + MB_ICONQUESTION) = mrYes then
    begin
      ButtonStartGameClick(ButtonStartGame);
    end;
    CanClose := False;
    Exit;
  end;

  if Application.MessageBox('是否确认关闭游戏控制台？', '确认信息', MB_YESNO + MB_ICONQUESTION) = mrYes then
  begin
    CanClose := True;
  end
  else
  begin
    CanClose := False;
  end;
end;

procedure TfrmMain.EditRunGate_ConntChange(Sender: TObject);
begin
  if EditRunGate_Connt.Text = '' then
    EditRunGate_Connt.Text := '0';
  if not m_boOpen then
    Exit;
  g_nRunGate_Count := EditRunGate_Connt.Value;
  g_sDBServer_Config_GateAddr := g_sAllIPaddr;
  RefGameConsole();
end;

procedure TfrmMain.ButtonLoginServerConfigClick(Sender: TObject);
begin
  frmLoginServerConfig.Open;
end;

procedure TfrmMain.ButtonAdvClick(Sender: TObject);
begin
  //frmCertServerSet.Open;
end;

procedure TfrmMain.CheckBoxDynamicIPModeClick(Sender: TObject);
begin
  EditGameExtIPaddr.Enabled := not CheckBoxDynamicIPMode.Checked;
end;

function TfrmMain.StartService: Boolean;
begin
  Result := False;
  MainOutMessage('正在启动98K游戏引擎控制台...');
  g_SessionList := TStringList.Create;
  //if FileExists(g_sGameFile) then
  //  MemoGameList.Lines.LoadFromFile(g_sGameFile);
  g_sNoticeUrl := g_IniConf.ReadString('Client', 'NoticeUrl', g_sNoticeUrl);
  g_nClientForm := g_IniConf.ReadInteger('Client', 'ClientForm', g_nClientForm);
  g_nServerPort := g_IniConf.ReadInteger('Client', 'ServerPort', g_nServerPort);
  g_sServerAddr := g_IniConf.ReadString('Client', 'ServerAddr', g_sServerAddr);

  g_sServerAddr := g_IniConf.ReadString('Client', 'ServerAddr', g_sServerAddr);
  g_nServerPort := g_IniConf.ReadInteger('Client', 'ServerPort', g_nServerPort);
  //EditNoticeUrl.Text := g_sNoticeUrl;
  //EditClientForm.Value := g_nClientForm;
  try
    //ServerSocket.Address := g_sServerAddr;
    //ServerSocket.Port := g_nServerPort;
    //ServerSocket.Active := True;
    m_dwShowTick := GetTickCount();
    Timer.Enabled := True;
  except
    on e: ESocketError do
    begin
      //MainOutMessage(Format('端口%d打开异常，检查端口是否被其它程序占用...', [g_nServerPort]));
      MainOutMessage(e.message);
      Exit;
    end;

  end;
  MainOutMessage('98K游戏引擎控制台启动完成...');
  Result := True;
end;
{
procedure TfrmMain.StopService;
begin
  Timer.Enabled := False;
  g_SessionList.Free;
  g_IniConf.Free;
end;
}
procedure TfrmMain.ProcessClientPacket;
var
  i: Integer;
  sLineText, sData, sDefMsg: string;
  nDataLen: Integer;
  DefMsg: TDefaultMessage;
  Socket: TCustomWinSocket;
begin
  for i := 0 to g_SessionList.Count - 1 do
  begin
    Socket := TCustomWinSocket(g_SessionList.Objects[i]);
    sLineText := g_SessionList.Strings[i];
    if sLineText = '' then
      continue;
    while TagCount(sLineText, '!') > 0 do
    begin
      sLineText := ArrestStringEx(sLineText, '#', '!', sData);
      nDataLen := Length(sData);
      if (nDataLen >= DEFBLOCKSIZE) then
      begin
        sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
        DefMsg := DecodeMessage(sDefMsg);
        case DefMsg.Ident of
          CM_GETGAMELIST: SendGameList(Socket);
        end;
      end;
    end;
    g_SessionList.Strings[i] := sLineText;
  end;
end;

procedure TfrmMain.SendGameList(Socket: TCustomWinSocket);
begin
  {sNoticeUrl := Trim(EditNoticeUrl.Text);
  DefMsg := MakeDefaultMsg(SM_SENDGAMELIST, 0, 0, 0, 0);
  for i := 0 to MemoGameList.Lines.Count - 1 do begin
    sLineText := MemoGameList.Lines.Strings[i];
    if (sLineText <> '') and (sLineText[1] <> ';') then begin
      SendSocket(Socket, EncodeMessage(DefMsg) + EncodeString(MemoGameList.Lines.Strings[i]));
    end;
  end;
  DefMsg := MakeDefaultMsg(SM_SENDGAMELIST, g_nClientForm, 1, 0, 0);
  SendSocket(Socket, EncodeMessage(DefMsg) + EncodeString(sNoticeUrl));}
end;
{
procedure TfrmMain.SendSocket(Socket: TCustomWinSocket; SendMsg: string);
begin
  SendMsg := '#' + SendMsg + '!';
  if Socket.Connected then
    Socket.SendText(SendMsg);
end;
}
{procedure TfrmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i                         : Integer;
  boFound                   : Boolean;
begin
  boFound := False;
  for i := 0 to g_SessionList.Count - 1 do begin
    if g_SessionList.Objects[i] = Socket then begin
      boFound := True;
      Break;
    end;
  end;
  if not boFound then begin
    g_SessionList.AddObject('', Socket)
  end;
end;

procedure TfrmMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i                         : Integer;
begin
  for i := 0 to g_SessionList.Count - 1 do begin
    if g_SessionList.Objects[i] = Socket then begin
      g_SessionList.Delete(i);
      Break;
    end;
  end;
end;

procedure TfrmMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TfrmMain.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i                         : Integer;
begin
  for i := 0 to g_SessionList.Count - 1 do begin
    if g_SessionList.Objects[i] = Socket then begin
      g_SessionList.Strings[i] := g_SessionList.Strings[i] + Socket.ReceiveText;
      Break;
    end;
  end;
end; }

{procedure TfrmMain.DeleteDirAll(APath: string; rdir: Boolean);
var
  r, FindResult             : Integer;
  FSearchRec                : TSearchRec;

  function IsDirNotation(ADirName: string): Boolean;
  begin
    Result := ((ADirName = '.') or (ADirName = '..'));
  end;
begin
  if APath[Length(APath)] <> '\' then
    APath := APath + '\';
  FindResult := FindFirst(APath + '*.*', faAnyFile, FSearchRec); //进入当前目录的子目录继续查找
  try
    while FindResult = 0 do begin
      if ExtractFileExt(FSearchRec.Name) = '.txt' then
        SysUtils.DeleteFile(APath + FSearchRec.Name)
      else if ((FSearchRec.Attr and faDirectory) = faDirectory) and not IsDirNotation(FSearchRec.Name) then
        DeleteDir(APath + FSearchRec.Name, rdir);
      FindResult := FindNext(FSearchRec);
    end;
  finally
    FindClose(FSearchRec);
  end;
end;}

procedure TfrmMain.Button2Click(Sender: TObject);
var
  i, ii: Integer;
  s, sCastleFile, sCastleDir, sFileName: string;
  ini, CastleConf, Config: TIniFile;
  LoadList, LoadList2: TStringList;
  GuildDir, GuildFile: string;
begin
  //
  Button2.Enabled := False;
  try
    //引擎日志
    ProgressBarCur.Max := 13;
    ProgressBarCur.Position := 0;
    if CheckBox11.Checked then
    begin
      if DirectoryExists(g_sMirDir + 'Mir200\log') then
        DeleteDir(g_sMirDir + 'Mir200\log', False);
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;

    //引擎登陆日志
    if CheckBox12.Checked then
    begin
      if DirectoryExists(g_sMirDir + 'Mir200\ConLog') then
        DeleteDir(g_sMirDir + 'Mir200\ConLog', False);
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;

    //沙城数据
    if CheckBox13.Checked then
    begin
      ini := TIniFile.Create(g_sSetupFile);

      s := ini.ReadString('Share', 'CastleDir', ''); //CastleDir=D:\MirServer\Mir200\Castle\
      if DirectoryExists(s) then
      begin
        if Copy(s, Length(s), 1) <> '\' then
          s := s + '\';

        sCastleFile := ini.ReadString('Share', 'CastleFile', '');
        if FileExists(sCastleFile) then
        begin
          LoadList := TStringList.Create;
          LoadList.LoadFromFile(sCastleFile);
          for i := 0 to LoadList.Count - 1 do
          begin
            sCastleDir := Trim(LoadList.Strings[i]);
            if sCastleDir <> '' then
            begin
              sCastleDir := s + sCastleDir;
              if DirectoryExists(sCastleDir) then
              begin
                if Copy(s, Length(sCastleDir), 1) <> '\' then
                  sCastleDir := sCastleDir + '\';

                sFileName := sCastleDir + 'AttackSabukWall.txt';
                LoadList2 := TStringList.Create;
                LoadList2.SaveToFile(sFileName);
                LoadList2.Free;

                sFileName := sCastleDir + 'SabukW.txt';
                CastleConf := TIniFile.Create(sFileName);
                CastleConf.WriteString('Setup', 'OwnGuild', '');
                CastleConf.WriteDateTime('Setup', 'ChangeDate', EncodeDate(1998, 01, 01));
                CastleConf.WriteDateTime('Setup', 'WarDate', EncodeDate(1998, 01, 01));
                CastleConf.WriteDateTime('Setup', 'IncomeToday', EncodeDate(1998, 01, 01));
                CastleConf.WriteInteger('Setup', 'TotalGold', 0);
                CastleConf.WriteInteger('Setup', 'TodayIncome', 0);

                CastleConf.WriteBool('Defense', 'MainDoorOpen', False);

                CastleConf.WriteInteger('Defense', 'MainDoorHP', High(Integer));
                CastleConf.WriteInteger('Defense', 'LeftWallHP', High(Integer));
                CastleConf.WriteInteger('Defense', 'CenterWallHP', High(Integer));
                CastleConf.WriteInteger('Defense', 'RightWallHP', High(Integer));

                for ii := 0 to 12 - 1 do
                begin
                  CastleConf.WriteInteger('Defense', 'Archer_' + IntToStr(ii + 1) + '_HP', High(Integer));
                end;

                for ii := 0 to 4 - 1 do
                begin
                  CastleConf.WriteInteger('Defense', 'Guard_' + IntToStr(ii + 1) + '_HP', High(Integer));
                end;
                CastleConf.Free;
              end;
            end;
          end;
          LoadList.Free;
        end;
      end;
      ini.Free;
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;

    //行会数据
    if CheckBox14.Checked then
    begin
      ini := TIniFile.Create(g_sSetupFile);

      GuildDir := ini.ReadString('Share', 'GuildDir', ''); //CastleDir=D:\MirServer\Mir200\Castle\
      if DirectoryExists(GuildDir) then
      begin
        if Copy(GuildDir, Length(GuildDir), 1) <> '\' then
          GuildDir := GuildDir + '\';

        DeleteDir(GuildDir, False);

        GuildFile := ini.ReadString('Share', 'GuildFile', '');
        LoadList2 := TStringList.Create;
        LoadList2.SaveToFile(GuildFile);
        LoadList2.Free;
      end;
      ini.Free;
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;

    //交易市场
    if CheckBox15.Checked then
    begin
      ExtractRes('MirDataSet', 'ResData', g_sEnvirDir + 'Data.mdb');
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;

    //武器升级数据
    if CheckBox16.Checked then
    begin
      DeleteDir(g_sEnvirDir + 'Market_Upg', False);
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;

    //商人数据
    if CheckBox17.Checked then
    begin
      DeleteDir(g_sEnvirDir + 'Market_Saved', False);
      DeleteDir(g_sEnvirDir + 'Market_Prices', False);
      DeleteDir(g_sEnvirDir + 'Market_SellOff', False);
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;

    //全局变量
    if CheckBox23.Checked then
    begin
      Config := TIniFile.Create(g_sSetupFile);

      Config.WriteInteger('Setup', 'ItemNumber', 0);
      Config.WriteInteger('Setup', 'ItemNumberEx', High(Integer) div 2);

      for i := 0 to 99 do
        Config.WriteInteger('Setup', 'GlobalVal' + IntToStr(i), 0);
      for i := 0 to 99 do
        Config.WriteInteger('Setup', 'HGlobalVal' + IntToStr(i), 0);
      for i := 0 to 99 do
        Config.WriteString('Setup', 'GlobaStrVal' + IntToStr(i), '');

      Config.Free;
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;

    //角色
    if CheckBox18.Checked then
    begin
      DeleteDir(g_sMirDir + 'DBServer\FDB', False);
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;

    //IDDB
    if CheckBox19.Checked then
    begin
      DeleteDir(g_sMirDir + 'LoginSrv\IDDB', False);
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;
    if CheckBox20.Checked then
    begin
      DeleteDir(g_sMirDir + 'LoginSrv\Chrlog', False);
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;
    if CheckBox21.Checked then
    begin
      DeleteDir(g_sMirDir + 'LoginSrv\Countlog', False);
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;
    if CheckBox22.Checked then
    begin
      DeleteDir(g_sMirDir + 'LogServer\BaseDir', False);
    end;
    ProgressBarCur.Position := ProgressBarCur.Position + 1;

    LoadList2 := TStringList.Create;
    ProgressBarCur.Max := CheckListBoxClear.Items.Count;
    ProgressBarCur.Position := 0;
    for i := 0 to CheckListBoxClear.Items.Count - 1 do
    begin
      if FileExists(CheckListBoxClear.Items.Strings[i]) then
      begin
        LoadList2.Clear;
        LoadList2.SaveToFile(CheckListBoxClear.Items.Strings[i]);
      end;
      ProgressBarCur.Position := ProgressBarCur.Position + 1;
      Application.ProcessMessages;
    end;
    LoadList2.Free;

    ProgressBarCur.Max := CheckListBoxDel.Items.Count;
    ProgressBarCur.Position := 0;
    for i := 0 to CheckListBoxDel.Items.Count - 1 do
    begin
      if FileExists(CheckListBoxDel.Items.Strings[i]) then
        SysUtils.DeleteFile(CheckListBoxDel.Items.Strings[i]);
      ProgressBarCur.Position := ProgressBarCur.Position + 1;
      Application.ProcessMessages;
    end;
  finally
    Button2.Enabled := True;
    g_IniConf.WriteBool('CleanUpSet', 'GameEngine_Log', CheckBox11.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'GameEngineLoginLog', CheckBox12.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'GameEngineSabuk', CheckBox13.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'GameEngineGuild', CheckBox14.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'GameEnginePersonalMarket', CheckBox15.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'GameEngineMarket_Upg', CheckBox16.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'GameEngineMarket_Tmp', CheckBox17.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'GameEngineGlobal', CheckBox23.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'DBServer_FDB', CheckBox18.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'LoginSrv_IDDB', CheckBox19.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'LoginSrv_Chrlog', CheckBox20.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'LoginSrv_Countlog', CheckBox21.Checked);
    g_IniConf.WriteBool('CleanUpSet', 'LogServer_Log', CheckBox22.Checked);

    g_IniConf.WriteInteger('Text2CleanUp', 'Count', CheckListBoxClear.Items.Count);
    for i := 0 to CheckListBoxClear.Items.Count - 1 do
      g_IniConf.WriteString('Text2CleanUp', Format('TextFile%d', [i]), CheckListBoxClear.Items[i]);

    g_IniConf.WriteInteger('Text2Delete', 'Count', CheckListBoxDel.Items.Count);
    for i := 0 to CheckListBoxDel.Items.Count - 1 do
      g_IniConf.WriteString('Text2Delete', Format('TextFile%d', [i]), CheckListBoxDel.Items[i]);
    ProgressBarCur.Max := 13;
    ProgressBarCur.Position := 13;
    Application.MessageBox('数据清理完成...', '提示信息', MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  i: Integer;
begin
  g_IniConf.WriteBool('CleanUpSet', 'GameEngine_Log', CheckBox11.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'GameEngineLoginLog', CheckBox12.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'GameEngineSabuk', CheckBox13.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'GameEngineGuild', CheckBox14.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'GameEnginePersonalMarket', CheckBox15.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'GameEngineMarket_Upg', CheckBox16.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'GameEngineMarket_Tmp', CheckBox17.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'GameEngineGlobal', CheckBox23.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'DBServer_FDB', CheckBox18.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'LoginSrv_IDDB', CheckBox19.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'LoginSrv_Chrlog', CheckBox20.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'LoginSrv_Countlog', CheckBox21.Checked);
  g_IniConf.WriteBool('CleanUpSet', 'LogServer_Log', CheckBox22.Checked);

  g_IniConf.WriteInteger('Text2CleanUp', 'Count', CheckListBoxClear.Items.Count);
  for i := 0 to CheckListBoxClear.Items.Count - 1 do
    g_IniConf.WriteString('Text2CleanUp', Format('TextFile%d', [i]), CheckListBoxClear.Items[i]);

  g_IniConf.WriteInteger('Text2Delete', 'Count', CheckListBoxDel.Items.Count);
  for i := 0 to CheckListBoxDel.Items.Count - 1 do
    g_IniConf.WriteString('Text2Delete', Format('TextFile%d', [i]), CheckListBoxDel.Items[i]);
  Application.MessageBox('数据清理设置保存完成！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain.EditNoticeUrlChange(Sender: TObject);
begin
  if not m_boOpen then
    Exit;
  //g_sNoticeUrl := Trim(EditNoticeUrl.Text);
  //Button2.Enabled := True;
end;

procedure TfrmMain.EditClientFormChange(Sender: TObject);
begin
  if not m_boOpen then
    Exit;
  //g_nClientForm := EditClientForm.Value;
  //Button2.Enabled := True;
end;

procedure TfrmMain.MemoGameListChange(Sender: TObject);
begin
  if not m_boOpen then
    Exit;

  //Button2.Enabled := True;
end;

procedure TfrmMain.ButtonGeneralDefalultClick(Sender: TObject);
begin
  EditGameDir.Text := 'D:\MirServer\';
  EditHeroDB.Text := 'HeroDB';
  EditGameName.Text := '热血传奇';
  EditGameExtIPaddr.Text := '127.0.0.1';
  CheckBoxDynamicIPMode.Checked := False;
  CheckBox10.Checked := False;
  CheckBox10Click(nil);
  RadioButton1.Checked := True;
  RadioButton1Click(nil);
end;

procedure TfrmMain.ButtonRunGateDefaultClick(Sender: TObject);
begin
  EditRunGate_Connt.Value := 3;
  EditRunGate_GatePort1.Text := '7200';
  EditRunGate_GatePort2.Text := '7300';
  EditRunGate_GatePort3.Text := '7400';
  EditRunGate_GatePort4.Text := '7500';
  EditRunGate_GatePort5.Text := '7600';
  EditRunGate_GatePort6.Text := '7700';
  EditRunGate_GatePort7.Text := '7800';
  EditRunGate_GatePort8.Text := '7900';
end;

procedure TfrmMain.ButtonLoginGateDefaultClick(Sender: TObject);
begin
  EditLoginGateCount.Value := 1;
  EditLoginGate_MainFormX.Text := '0';
  EditLoginGate_MainFormY.Text := '0';
  EditLoginGate_GatePort1.Text := '7000';
  EditLoginGate_GatePort2.Text := '7001';
  EditLoginGate_GatePort3.Text := '7002';
  EditLoginGate_GatePort4.Text := '7003';
  EditLoginGate_GatePort5.Text := '7004';
  EditLoginGate_GatePort6.Text := '7005';
  EditLoginGate_GatePort7.Text := '7006';
  EditLoginGate_GatePort8.Text := '7007';
end;

procedure TfrmMain.ButtonSelGateDefaultClick(Sender: TObject);
begin
  EditSelGate_GateCount.Value := 1;
  EditSelGate_MainFormX.Text := '0';
  EditSelGate_MainFormY.Text := '163';
  EditSelGate_GatePort1.Text := '7100';
  EditSelGate_GatePort2.Text := '7101';
  EditSelGate_GatePort3.Text := '7102';
  EditSelGate_GatePort4.Text := '7103';
  EditSelGate_GatePort5.Text := '7104';
  EditSelGate_GatePort6.Text := '7105';
  EditSelGate_GatePort7.Text := '7106';
  EditSelGate_GatePort8.Text := '7107';
end;

procedure TfrmMain.ButtonLoginSrvDefaultClick(Sender: TObject);
begin
  EditLoginServer_MainFormX.Text := '253';
  EditLoginServer_MainFormY.Text := '0';
  EditLoginServerGatePort.Text := '5500';
  EditLoginServerServerPort.Text := '5600';
  EditLogListenPort.Text := '3000';
  CheckBoxboLoginServer_GetStart.Checked := True;
end;

procedure TfrmMain.ButtonDBServerDefaultClick(Sender: TObject);
begin
  EditDBServer_MainFormX.Text := '0';
  EditDBServer_MainFormY.Text := '326';
  EditDBServerGatePort.Text := '5100';
  EditDBServerServerPort.Text := '6000';
  CheckBoxDBServerGetStart.Checked := True;
end;

procedure TfrmMain.ButtonLogServerDefaultClick(Sender: TObject);
begin
  EditLogServer_MainFormX.Text := '253';
  EditLogServer_MainFormY.Text := '239';
  EditLogServerPort.Text := '10000';
  CheckBoxLogServerGetStart.Checked := True;
end;

procedure TfrmMain.ButtonM2ServerDefaultClick(Sender: TObject);
begin
  EditM2Server_MainFormX.Text := '560';
  EditM2Server_MainFormY.Text := '0';
  EditM2Server_TestLevel.Value := 1;
  EditM2Server_TestGold.Value := 0;
  EditM2ServerGatePort.Text := '5000';
  EditM2ServerMsgSrvPort.Text := '4900';
  CheckBoxM2ServerGetStart.Checked := True;
end;

procedure TfrmMain.ButtonSearchLoginAccountClick(Sender: TObject);
var
  sAccount: string;
begin
  if LoginServer.btStartStatus <> 2 then
  begin
    Application.MessageBox('游戏登录服务器未启动...' + #13#13 + '启动游戏登录服务器后才能使用此功能。', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  sAccount := Trim(EditSearchLoginAccount.Text);
  if sAccount = '' then
  begin
    Application.MessageBox('帐号不能为空！', '错误信息', MB_OK + MB_ICONERROR);
    EditSearchLoginAccount.SetFocus;
    Exit;
  end;
  EditLoginAccount.Text := '';
  EditLoginAccountPasswd.Text := '';
  EditLoginAccountUserName.Text := '';
  EditLoginAccountSSNo.Text := '';
  EditLoginAccountBirthDay.Text := '';
  EditLoginAccountPhone.Text := '';
  EditLoginAccountMobilePhone.Text := '';
  EditLoginAccountQuiz.Text := '';
  EditLoginAccountAnswer.Text := '';
  EditLoginAccountQuiz2.Text := '';
  EditLoginAccountAnswer2.Text := '';
  EditLoginAccountEMail.Text := '';
  EditLoginAccountMemo1.Text := '';
  EditLoginAccountMemo2.Text := '';
  CkFullEditMode.Checked := False;
  UserAccountEditMode(False);
  EditLoginAccount.Enabled := False;
  SendProgramMsg(LoginServer.MainFormHandle, GS_USERACCOUNT, sAccount);
end;

procedure TfrmMain.ProcessLoginSrvGetUserAccount(sData: string);
var
  DBRecord: TAccountDBRecord;
  DefMsg: TDefaultMessage;
  sDefMsg: string;
begin
  if Length(sData) < DEFBLOCKSIZE then
    Exit;
  sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
  sData := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
  DefMsg := DecodeMessage(sDefMsg);

  case DefMsg.Ident of //
    SG_USERACCOUNTNOTFOUND:
      begin
        Application.MessageBox('帐号未找到...', '提示信息', MB_OK + MB_ICONINFORMATION);
        Exit;
      end;
  else
    DecodeBuffer(sData, @DBRecord, SizeOf(DBRecord));
  end;

  EditLoginAccount.Text := DBRecord.UserEntry.sAccount;
  EditLoginAccountPasswd.Text := DBRecord.UserEntry.sPassword;
  EditLoginAccountUserName.Text := DBRecord.UserEntry.sUserName;
  EditLoginAccountSSNo.Text := DBRecord.UserEntry.sSSNo;
  EditLoginAccountBirthDay.Text := DBRecord.UserEntryAdd.sBirthDay;
  EditLoginAccountPhone.Text := DBRecord.UserEntry.sPhone;
  EditLoginAccountMobilePhone.Text := DBRecord.UserEntryAdd.sMobilePhone;
  EditLoginAccountQuiz.Text := DBRecord.UserEntry.sQuiz;
  EditLoginAccountAnswer.Text := DBRecord.UserEntry.sAnswer;
  EditLoginAccountQuiz2.Text := DBRecord.UserEntryAdd.sQuiz2;
  EditLoginAccountAnswer2.Text := DBRecord.UserEntryAdd.sAnswer2;
  EditLoginAccountEMail.Text := DBRecord.UserEntry.sEMail;
  EditLoginAccountMemo1.Text := DBRecord.UserEntryAdd.sMemo;
  EditLoginAccountMemo2.Text := DBRecord.UserEntryAdd.sMemo2;
  try
    EditCreateDate.Text := DateToStr(DBRecord.Header.CreateDate);
    EditUpdateDate.Text := DateToStr(DBRecord.Header.UpdateDate);
  except
  end;
  ButtonLoginAccountOK.Enabled := False;
end;

procedure TfrmMain.EditLoginAccountChange(Sender: TObject);
begin
  ButtonLoginAccountOK.Enabled := True;
end;

procedure TfrmMain.CkFullEditModeClick(Sender: TObject);
begin
  UserAccountEditMode(CkFullEditMode.Checked);
end;

procedure TfrmMain.UserAccountEditMode(boChecked: Boolean);
begin
  //boChecked := CkFullEditMode.Checked;
  EditLoginAccountUserName.Enabled := boChecked;
  EditLoginAccountSSNo.Enabled := boChecked;
  EditLoginAccountBirthDay.Enabled := boChecked;
  EditLoginAccountQuiz.Enabled := boChecked;
  EditLoginAccountAnswer.Enabled := boChecked;
  EditLoginAccountQuiz2.Enabled := boChecked;
  EditLoginAccountAnswer2.Enabled := boChecked;
  EditLoginAccountMobilePhone.Enabled := boChecked;
  EditLoginAccountPhone.Enabled := boChecked;
  EditLoginAccountMemo1.Enabled := boChecked;
  EditLoginAccountMemo2.Enabled := boChecked;
  EditLoginAccountEMail.Enabled := boChecked;
end;

procedure TfrmMain.ButtonLoginAccountOKClick(Sender: TObject);
var
  DBRecord: TAccountDBRecord;
  DefMsg: TDefaultMessage;
  //  sDefMsg: string;
  sAccount, sPassword, sUserName, sSSNo, sPhone, sQuiz, sAnswer, sEMail, sQuiz2, sAnswer2, sBirthDay, sMobilePhone, sMemo, sMemo2: string;
begin
  sAccount := Trim(EditLoginAccount.Text);
  sPassword := Trim(EditLoginAccountPasswd.Text);
  sUserName := Trim(EditLoginAccountUserName.Text);
  sSSNo := Trim(EditLoginAccountSSNo.Text);
  sPhone := Trim(EditLoginAccountPhone.Text);
  sQuiz := Trim(EditLoginAccountQuiz.Text);
  sAnswer := Trim(EditLoginAccountAnswer.Text);
  sEMail := Trim(EditLoginAccountEMail.Text);
  sQuiz2 := Trim(EditLoginAccountQuiz2.Text);
  sAnswer2 := Trim(EditLoginAccountAnswer2.Text);
  sBirthDay := Trim(EditLoginAccountBirthDay.Text);
  sMobilePhone := Trim(EditLoginAccountMobilePhone.Text);
  sMemo := Trim(EditLoginAccountMemo1.Text);
  sMemo2 := Trim(EditLoginAccountMemo2.Text);
  if sAccount = '' then
  begin
    Application.MessageBox('帐号不能不空...', '提示信息', MB_OK + MB_ICONERROR);
    EditLoginAccount.SetFocus;
    Exit;
  end;
  if sPassword = '' then
  begin
    Application.MessageBox('密码不能不空...', '提示信息', MB_OK + MB_ICONERROR);
    EditLoginAccountPasswd.SetFocus;
    Exit;
  end;
  FillChar(DBRecord, SizeOf(DBRecord), 0);
  DBRecord.UserEntry.sAccount := sAccount;
  DBRecord.UserEntry.sPassword := sPassword;
  DBRecord.UserEntry.sUserName := sUserName;
  DBRecord.UserEntry.sSSNo := sSSNo;
  DBRecord.UserEntry.sPhone := sPhone;
  DBRecord.UserEntry.sQuiz := sQuiz;
  DBRecord.UserEntry.sAnswer := sAnswer;
  DBRecord.UserEntry.sEMail := sEMail;
  DBRecord.UserEntryAdd.sQuiz2 := sQuiz2;
  DBRecord.UserEntryAdd.sAnswer2 := sAnswer2;
  DBRecord.UserEntryAdd.sBirthDay := sBirthDay;
  DBRecord.UserEntryAdd.sMobilePhone := sMobilePhone;
  DBRecord.UserEntryAdd.sMemo := sMemo;
  DBRecord.UserEntryAdd.sMemo2 := sMemo2;
  DefMsg := MakeDefaultMsg(0, 0, 0, 0, 0);
  SendProgramMsg(LoginServer.MainFormHandle, GS_CHANGEACCOUNTINFO, EncodeMessage(DefMsg) + EncodeBuffer(@DBRecord, SizeOf(DBRecord)));
  ButtonLoginAccountOK.Enabled := False;
end;

procedure TfrmMain.ProcessLoginSrvChangeUserAccountStatus(sData: string);
var
  DefMsg: TDefaultMessage;
  sDefMsg: string;
begin
  if Length(sData) < DEFBLOCKSIZE then
    Exit;
  sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
  sData := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
  DefMsg := DecodeMessage(sDefMsg);
  case DefMsg.Recog of
    -1: Application.MessageBox('指定的帐号不存在...', '提示信息', MB_OK + MB_ICONERROR);
    1: Application.MessageBox('帐号更新成功...', '提示信息', MB_OK + MB_ICONINFORMATION);
    2: Application.MessageBox('帐号更新失败...', '提示信息', MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TfrmMain.RefGameDebug;
begin
  {EditM2CheckCodeAddr.Text := IntToHex(g_dwM2CheckCodeAddr, 2);
  FillChar(CheckCode, SizeOf(CheckCode), 0);
  ReadProcessMemory(MirServer.ProcessHandle, Pointer(g_dwM2CheckCodeAddr), @CheckCode, SizeOf(CheckCode), dwReturn);
  if dwReturn = SizeOf(CheckCode) then begin
    EditM2CheckCode.Text := IntToStr(CheckCode.dwThread0);
    EditM2CheckStr.Text := string(CheckCode.sThread0);
  end;

  EditDBCheckCodeAddr.Text := IntToHex(g_dwDBCheckCodeAddr, 2);
  FillChar(CheckCode, SizeOf(CheckCode), 0);
  ReadProcessMemory(DBServer.ProcessHandle, Pointer(g_dwDBCheckCodeAddr), @CheckCode, SizeOf(CheckCode), dwReturn);
  if dwReturn = SizeOf(CheckCode) then begin
    EditDBCheckCode.Text := IntToStr(CheckCode.dwThread0);
    EditDBCheckStr.Text := string(CheckCode.sThread0);
  end;}
end;

procedure TfrmMain.TimerAutoBackupTimer(Sender: TObject);
var
  s, s1, s2: string;
begin
  if CheckBoxBackupTimer.Checked then
  begin
    frmMain.Caption := '98K游戏控制台 ' + FormatDateTime('[yyyy-MM-dd dddd]', Now);
    s := IntToStr(SpinEditHour.Value) + ':' + IntToStr(SpinEditMin.Value);
    s1 := s + ':00';
    s2 := s + ':59';
    s := TimeToStr(Now);
    if RadioButtonWeek.Checked then
    begin
      if (s >= s1) and (s < s2) then
        BackUpFiles(Sender);
    end;
    if RadioButtonMin.Checked then
    begin
      if (GetTickCount() - InterTime) > (SpinEditMinInter.Value * 60000) then
      begin
        InterTime := GetTickCount();
        BackUpFiles(Sender);
      end;
    end;
  end;
end;

procedure TfrmMain.ButtonM2SuspendClick(Sender: TObject);
begin
  SuspendThread(MirServer.ProcessInfo.hThread);
end;

procedure TfrmMain.CheckBox10Click(Sender: TObject);
begin
  g_boMultiSvrSet := CheckBox10.Checked;
  RadioButton1.Enabled := CheckBox10.Checked;
  RadioButton2.Enabled := CheckBox10.Checked;
end;

procedure TfrmMain.CheckBox1Click(Sender: TObject);
begin
  if (Sender = CheckBox9) and CheckBox9.Checked then
    if not FileExists(EditWinrarFile.Text + 'Rar.exe') then
    begin
      Application.MessageBox('Winrar.exe文件路径设置有误！', '错误提示', MB_ICONERROR + MB_OK);
      CheckBox9.Checked := False;
      Exit;
    end;
  ModValue();
end;

procedure TfrmMain.ModValue();
begin
  BitBtnSaveSetup.Enabled := True;
  BitBtnPrv.Enabled := True;
end;

procedure TfrmMain.BitBtnIDDBClick(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := (EditIDDB.Text);
  if SelectDirectory('选择IDDB目录:', Folder, Dir) then
    EditIDDB.Text := Dir + '\';
end;

procedure TfrmMain.BitBtnFDBClick(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := (EditFDB.Text);
  if SelectDirectory('选择FDB目录:', Folder, Dir) then
    EditFDB.Text := Dir + '\';
end;

procedure TfrmMain.BitBtnGUILDClick(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := (EditGuild.Text);
  if SelectDirectory('选择GuildBase目录:', Folder, Dir) then
    EditGuild.Text := Dir + '\';
end;

procedure TfrmMain.BitBtnDataClick(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := (EditData.Text);
  if SelectDirectory('选择数据文件目录:', Folder, Dir) then
    EditData.Text := Dir + '\';
end;

procedure TfrmMain.BitBtnBigBagSizeClick(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := (EditBigBagSize.Text);
  if SelectDirectory('选择大包裹目录:', Folder, Dir) then
    EditBigBagSize.Text := Dir + '\';
end;

procedure TfrmMain.BitBtnSabukClick(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := (EditSabuk.Text);
  if SelectDirectory('选择Castle目录:', Folder, Dir) then
    EditSabuk.Text := Dir + '\';
end;

procedure TfrmMain.BitBtnBACKUPClick(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := (EditBakDir.Text);
  if SelectDirectory('数据将备份到目录:', Folder, Dir) then
    EditBakDir.Text := Dir + '\';
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := (EditOtherSourceDir1.Text);
  if SelectDirectory('选择自定义目录1:', Folder, Dir) then
    EditOtherSourceDir1.Text := Dir + '\';
end;

procedure TfrmMain.BitBtn2Click(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := (EditOtherSourceDir2.Text);
  if SelectDirectory('选择自定义目录2:', Folder, Dir) then
    EditOtherSourceDir2.Text := Dir + '\';
end;

procedure TfrmMain.BitBtnMirDirClick(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := ExtractFilePath(Application.Exename);
  if SelectDirectory('选择传奇的基本目录:', Folder, Dir) then
  begin
    if Copy(Dir, Length(Dir), 1) <> '\' then
      Dir := Dir + '\';
    if DirectoryExists(Dir + 'Mir200\Envir') and
      DirectoryExists(Dir + 'LoginGate') and
      DirectoryExists(Dir + 'LoginSrv') and
      DirectoryExists(Dir + 'LogServer') and
      DirectoryExists(Dir + 'DBServer') and
      FileExists(Dir + 'Mir200\!Setup.txt') then
    begin

      EditMirDir.Text := Dir;
      g_sMirDir := Dir;
      g_sEnvirDir := Dir + 'Mir200\Envir\';
      g_sSetupFile := Dir + 'Mir200\!Setup.txt';

      SetControlState(True);
    end
    else
    begin
      g_sMirDir := '';
      g_sEnvirDir := '';
      g_sSetupFile := '';
      SetControlState(False);
      Application.MessageBox('请选择传奇的根目录，比如：X:\MirServer\', '错误', MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TfrmMain.BitBtnWinrarFileClick(Sender: TObject);
var
  Dir: string;
  Folder: WideString;
begin
  Dir := (EditWinrarFile.Text);
  if SelectDirectory('选择WinRar路径:', Folder, Dir) then
    EditWinrarFile.Text := Dir + '\';
end;

procedure TfrmMain.BackUpFiles(Sender: TObject; bHint: Boolean = False);
var
  i: Integer;
  s, fdir, TempDir,sRarpath: string;
begin
  sRarpath := EditWinrarFile.Text;
  if Copy(sRarpath, Length(sRarpath), 1) <> '\' then
    sRarpath := sRarpath + '\';

  //if CheckBox9.Checked then begin
  if not FileExists(EditWinrarFile.Text + 'Rar.exe') then
  begin
    Application.MessageBox('Winrar 文件路径设置有误！ (注：必须安装WinRar并设置好路径！)', '错误提示', MB_ICONERROR + MB_OK);
    CheckBox9.Checked := False;
    Exit;
  end;
  //end;

  TempDir := Time_ToStr(TimeToStr(Now));
  if CheckDir() then
  begin
    Copying := True;
    BitBtnBak.Enabled := False;
    fdir := DateToStr(Now);
    fdir := Format('%s__%s.rar', [fdir, TempDir]);
    for i := 1 to Length(fdir) do
    begin
      if (fdir[i] = '/') or (fdir[i] = '\') then
        fdir[i] := '-';
    end;

    TotalFileNumbers := 0;
    s := sBackupDir + fdir;
    if CheckBox1.Checked then
    begin
      RecurSearchFile(sIDDBDir, SearchFileType, MemoLog.Lines, TotalFileNumbers);
      //Xcopy(sIDDBDir, s + '\IDDB\' + TempDir);
      AddToRAR(sBackupDir, sRarpath, fdir, sIDDBDir, '-r');
    end;
    if CheckBox2.Checked then
    begin
      RecurSearchFile(sFDBDir, SearchFileType, MemoLog.Lines, TotalFileNumbers);
      //Xcopy(sFDBDir, s + '\FDB\' + TempDir);
      AddToRAR(sBackupDir, sRarpath, fdir, sFDBDir, '-r');
    end;
    if CheckBox3.Checked then
    begin
      RecurSearchFile(sGuildDir, SearchFileType, MemoLog.Lines, TotalFileNumbers);
      //Xcopy(sGuildDir, s + '\GuildBase\' + TempDir);
      AddToRAR(sBackupDir, sRarpath, fdir, sGuildDir, '-r');
    end;
    if CheckBox4.Checked then
    begin
      RecurSearchFile(sDataDir, SearchFileType, MemoLog.Lines, TotalFileNumbers);
      //Xcopy(sDataDir, s + '\数据文件\' + TempDir);
      AddToRAR(sBackupDir, sRarpath, fdir, sDataDir, '-r');
    end;
    if CheckBox5.Checked then
    begin
      RecurSearchFile(sBigBagSize, SearchFileType, MemoLog.Lines, TotalFileNumbers);
      //Xcopy(sBigBagSize, s + '\BigBag\' + TempDir);
      AddToRAR(sBackupDir, sRarpath, fdir, sBigBagSize, '-r');
    end;
    if CheckBox6.Checked then
    begin
      RecurSearchFile(sSabukDir, SearchFileType, MemoLog.Lines, TotalFileNumbers);
      //Xcopy(sSabukDir, s + '\Castle\' + TempDir);
      AddToRAR(sBackupDir, sRarpath, fdir, sSabukDir, '-r');
    end;
    if CheckBox7.Checked then
    begin
      RecurSearchFile(sOtherSourceDir1, SearchFileType, MemoLog.Lines, TotalFileNumbers);
      //Xcopy(sOtherSourceDir1, s + '\Other1\' + TempDir);
      AddToRAR(sBackupDir, sRarpath, fdir, sOtherSourceDir1, '-r');
    end;
    if CheckBox8.Checked then
    begin
      RecurSearchFile(sOtherSourceDir2, SearchFileType, MemoLog.Lines, TotalFileNumbers);
      //Xcopy(sOtherSourceDir2, s + '\Other2\' + TempDir);
      AddToRAR(sBackupDir, sRarpath, fdir, sOtherSourceDir2, '-r');
    end;

    //c := AddToRAR(sBackupDir, sRarpath, Format('%s.rar', [fdir]), fdir, '-r');
    //if c = 0 then
    //  DeleteDir(s);

    Copying := False;
    LabelNotice.Caption := '备份完毕，共拷贝 ' + IntToStr(TotalFileNumbers) + ' 个文件到目标目录...';
    MemoLog.Lines.Add('[' + DateTimeToStr(Now) + '] ' + '备份操作完毕，一共拷贝 ' + IntToStr(TotalFileNumbers) + ' 个文件到目标目录...');
    if bHint then
      MessageBox(0, PChar(LabelNotice.Caption), '提示信息', MB_ICONINFORMATION + MB_OK);
    BitBtnBak.Enabled := True;
  end;
end;

procedure TfrmMain.BitBtnBakClick(Sender: TObject);
begin
  BackUpFiles(Sender, True);
end;

procedure TfrmMain.BitBtnPrvClick(Sender: TObject);
begin
  if Application.MessageBox('是否恢复默认设置？', '确认信息', MB_YESNO + MB_ICONQUESTION) = IDyes then
  begin
    EditIDDB.Text := spIDDBDir;
    EditFDB.Text := spFDBDir;
    EditGuild.Text := spGuildDir;
    EditData.Text := spDataDir;
    EditBakDir.Text := spBackupDir;
    EditBigBagSize.Text := spBigBagSize;
    EditSabuk.Text := spSabukDir;
    ComboBoxInterDay.ItemIndex := 0;
    SpinEditHour.Value := 00;
    SpinEditMin.Value := 00;
    SpinEditMinInter.Value := 1000;
    EditOtherSourceDir1.Text := spOtherSourceDir1;
    EditOtherSourceDir2.Text := spOtherSourceDir2;
    RadioButtonWeek.Checked := True;
    RadioButtonMin.Checked := False;
    BitBtnSaveSetupClick(Sender); //调用 BitBtnSaveSetupClick
  end;
end;

procedure TfrmMain.BitBtnSaveSetupClick(Sender: TObject);
begin
  if CheckDir() then
  begin
    SaveSetup();
    MainOutMessage('所有设置保存成功...');
  end;
end;

procedure TfrmMain.CheckBoxBackupTimerClick(Sender: TObject);
begin
  if CheckBoxBackupTimer.Checked then
  begin
    RadioButtonWeek.Enabled := True;
    //ComboBoxInterDay.Enabled := True;
    SpinEditHour.Enabled := True;
    SpinEditMin.Enabled := True;
    SpinEditMinInter.Enabled := True;
    RadioButtonMin.Enabled := True;
    TimerAutoBackup.Enabled := True;
  end
  else
  begin
    RadioButtonWeek.Enabled := False;
    //ComboBoxInterDay.Enabled := false;
    SpinEditHour.Enabled := False;
    SpinEditMin.Enabled := False;
    SpinEditMinInter.Enabled := False;
    RadioButtonMin.Enabled := False;
    TimerAutoBackup.Enabled := False;
  end;
  SpinEditHourChange(Sender);
end;

procedure TfrmMain.RadioButtonWeekClick(Sender: TObject);
begin
  if RadioButtonWeek.Checked then
  begin
    SpinEditMinInter.Enabled := False;
    //ComboBoxInterDay.Enabled := True;
    SpinEditHour.Enabled := True;
    SpinEditMin.Enabled := True;
    BitBtnSaveSetup.Enabled := True;
  end;
end;

procedure TfrmMain.RadioButton1Click(Sender: TObject);
begin
  g_boMainServer := False;
  if RadioButton1.Checked then
    g_boMainServer := True;
  SwitchSeting(g_boMainServer);
end;

procedure TfrmMain.SwitchSeting(Switch: Boolean);
begin
  if g_boMainServer then
  begin
    EditRunGate_Connt.Value := 3;
    EditRunGate_GatePort1.Text := '7200';
    EditRunGate_GatePort2.Text := '7300';
    EditRunGate_GatePort3.Text := '7400';
    EditRunGate_GatePort4.Text := '7500';
    EditRunGate_GatePort5.Text := '7600';
    EditRunGate_GatePort6.Text := '7700';
    EditRunGate_GatePort7.Text := '7800';
    EditRunGate_GatePort8.Text := '7900';

    EditLoginGateCount.Value := 1;
    EditLoginGate_MainFormX.Text := '0';
    EditLoginGate_MainFormY.Text := '0';
    EditLoginGate_GatePort1.Text := '7000';
    EditLoginGate_GatePort2.Text := '7001';
    EditLoginGate_GatePort3.Text := '7002';
    EditLoginGate_GatePort4.Text := '7003';
    EditLoginGate_GatePort5.Text := '7004';
    EditLoginGate_GatePort6.Text := '7005';
    EditLoginGate_GatePort7.Text := '7006';
    EditLoginGate_GatePort8.Text := '7007';

    EditSelGate_GateCount.Value := 1;
    EditSelGate_MainFormX.Text := '0';
    EditSelGate_MainFormY.Text := '163';
    EditSelGate_GatePort1.Text := '7100';
    EditSelGate_GatePort2.Text := '7101';
    EditSelGate_GatePort3.Text := '7102';
    EditSelGate_GatePort4.Text := '7103';
    EditSelGate_GatePort5.Text := '7104';
    EditSelGate_GatePort6.Text := '7105';
    EditSelGate_GatePort7.Text := '7106';
    EditSelGate_GatePort8.Text := '7107';

    EditLoginServer_MainFormX.Text := '253';
    EditLoginServer_MainFormY.Text := '0';
    EditLoginServerGatePort.Text := '5500';
    EditLoginServerServerPort.Text := '5600';
    EditLogListenPort.Text := '3000';
    CheckBoxboLoginServer_GetStart.Checked := True;

    EditDBServer_MainFormX.Text := '0';
    EditDBServer_MainFormY.Text := '326';
    EditDBServerGatePort.Text := '5100';
    EditDBServerServerPort.Text := '6000';
    CheckBoxDBServerGetStart.Checked := True;

    EditLogServer_MainFormX.Text := '253';
    EditLogServer_MainFormY.Text := '239';
    EditLogServerPort.Text := '10000';
    CheckBoxLogServerGetStart.Checked := True;

    EditM2Server_MainFormX.Text := '560';
    EditM2Server_MainFormY.Text := '0';
    EditM2Server_TestLevel.Value := 1;
    EditM2Server_TestGold.Value := 0;
    EditM2ServerGatePort.Text := '5000';
    EditM2ServerMsgSrvPort.Text := '4900';
    Exit;
  end;
  EditRunGate_Connt.Value := 3;
  EditLoginGateCount.Value := 1;
  EditRunGate_GatePort1.Text := '7201';
  EditRunGate_GatePort2.Text := '7301';
  EditRunGate_GatePort3.Text := '7401';
  EditRunGate_GatePort4.Text := '7501';
  EditRunGate_GatePort5.Text := '7601';
  EditRunGate_GatePort6.Text := '7701';
  EditRunGate_GatePort7.Text := '7801';
  EditRunGate_GatePort8.Text := '7901';

  EditSelGate_GateCount.Value := 1;
  EditLoginGate_MainFormX.Text := '0';
  EditLoginGate_MainFormY.Text := '0';
  EditLoginGate_GatePort1.Text := '7010';
  EditLoginGate_GatePort2.Text := '7011';
  EditLoginGate_GatePort3.Text := '7012';
  EditLoginGate_GatePort4.Text := '7013';
  EditLoginGate_GatePort5.Text := '7014';
  EditLoginGate_GatePort6.Text := '7015';
  EditLoginGate_GatePort7.Text := '7016';
  EditLoginGate_GatePort8.Text := '7017';

  EditSelGate_MainFormX.Text := '0';
  EditSelGate_MainFormY.Text := '163';
  EditSelGate_GatePort1.Text := '7110';
  EditSelGate_GatePort2.Text := '7111';
  EditSelGate_GatePort3.Text := '7112';
  EditSelGate_GatePort4.Text := '7113';
  EditSelGate_GatePort5.Text := '7114';
  EditSelGate_GatePort6.Text := '7115';
  EditSelGate_GatePort7.Text := '7116';
  EditSelGate_GatePort8.Text := '7117';

  EditLoginServer_MainFormX.Text := '253';
  EditLoginServer_MainFormY.Text := '0';
  EditLoginServerGatePort.Text := '5501';
  EditLoginServerServerPort.Text := '5601';
  EditLogListenPort.Text := '3001';
  CheckBoxboLoginServer_GetStart.Checked := True;

  EditDBServer_MainFormX.Text := '0';
  EditDBServer_MainFormY.Text := '326';
  EditDBServerGatePort.Text := '5101';
  EditDBServerServerPort.Text := '6001';
  CheckBoxDBServerGetStart.Checked := True;

  EditLogServer_MainFormX.Text := '253';
  EditLogServer_MainFormY.Text := '239';
  EditLogServerPort.Text := '10001';
  CheckBoxLogServerGetStart.Checked := True;

  EditM2Server_MainFormX.Text := '560';
  EditM2Server_MainFormY.Text := '0';
  EditM2Server_TestLevel.Value := 1;
  EditM2Server_TestGold.Value := 0;
  EditM2ServerGatePort.Text := '5001';
  EditM2ServerMsgSrvPort.Text := '4901';
end;

procedure TfrmMain.RadioButtonMinClick(Sender: TObject);
begin
  if RadioButtonMin.Checked then
  begin
    SpinEditMinInter.Enabled := True;
    ComboBoxInterDay.Enabled := False;
    SpinEditHour.Enabled := False;
    SpinEditMin.Enabled := False;
    BitBtnSaveSetup.Enabled := True;
  end;
end;

procedure TfrmMain.SpinEditMinInterChange(Sender: TObject);
begin
  ModValue();
end;

procedure TfrmMain.SpinEditHourChange(Sender: TObject);
begin
  ModValue();
end;

procedure TfrmMain.SpinEditMinChange(Sender: TObject);
begin
  ModValue();
end;

procedure TfrmMain.EditIDDBChange(Sender: TObject);
begin
  ModValue();
end;

procedure TfrmMain.EditSearchLoginAccountKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key <> #13 then
    Exit;
  ButtonSearchLoginAccountClick(Sender);
end;

procedure TfrmMain.CheckBoxLoginGateSleepClick(Sender: TObject);
begin
  g_boLoginGateSleep := CheckBoxLoginGateSleep.Checked;
  SpinEditLoginGateSleep.Enabled := g_boLoginGateSleep;
end;

procedure TfrmMain.SpinEditLoginGateSleepChange(Sender: TObject);
begin
  g_nLoginGateSleep := SpinEditLoginGateSleep.Value;
end;

procedure TfrmMain.ButtonAboutClick(Sender: TObject);
begin
  ShellAbout(Handle, PChar('98K游戏引擎控制台 v1.05 By 98KM2'),
    PChar('版权所有(C) 2019 98KM2'), HICON(nil));
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
begin
  ProcessClientPacket();
  if GetTickCount - m_dwShowTick > 1000 then
  begin
    m_dwShowTick := GetTickCount();
    //LabelConnect.Caption := Format('端口：%d   当前连接数：%d', [ServerSocket.Port, ServerSocket.Socket.ActiveConnections]);
  end;
end;

procedure TfrmMain.TimerCheckDebugTimer(Sender: TObject);
begin
  RefGameDebug();
end;

procedure TfrmMain.ButtonDbsSuspendClick(Sender: TObject);
begin
  SuspendThread(DBServer.ProcessInfo.hThread);
end;

procedure TfrmMain.ButtonM2ResumeClick(Sender: TObject);
begin
  ResumeThread(MirServer.ProcessInfo.hThread);
end;

procedure TfrmMain.ButtonM2TerminateClick(Sender: TObject);
begin
{$I '..\Common\Macros\VMPB.inc'}
  TerminateProcess(MirServer.ProcessInfo.hProcess, 4);
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure TfrmMain.ButtonDbsResumeClick(Sender: TObject);
begin
  ResumeThread(DBServer.ProcessInfo.hThread);
end;

procedure TfrmMain.ButtonDbsTerminateClick(Sender: TObject);
begin
{$I '..\Common\Macros\VMPB.inc'}
  TerminateProcess(DBServer.ProcessInfo.hProcess, 4);
{$I '..\Common\Macros\VMPE.inc'}
end;

function KillProc(ExeFileName: string): Integer;
//KernelHandle := GetModuleHandle(kernel32);
//ExpandFileName
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
{$I '..\Common\Macros\VMPB.inc'}
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if (uppercase(FProcessEntry32.szExeFile) = uppercase(ExeFileName)) or
      (uppercase(ExtractFileName(FProcessEntry32.szExeFile)) = uppercase(ExeFileName)) then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure CheckSelfModule();
var
  i, ii: Integer;
  ModuleNameList: TStringList;
  ModuleList: THandle;
  FModuleEntry32: TModuleEntry32;
  ModuleName: string;
begin
  ModuleList := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, 0);
  FModuleEntry32.dwSize := SizeOf(TModuleEntry32);
  ModuleNameList := TStringList.Create;
  if Module32First(ModuleList, FModuleEntry32) then
  begin
    ModuleNameList.Add(uppercase(ExtractFileName(FModuleEntry32.szModule)));
    while Module32Next(ModuleList, FModuleEntry32) do
      ModuleNameList.Add(uppercase(ExtractFileName(FModuleEntry32.szModule)));
  end;
  CloseHandle(ModuleList);
  for i := ModuleNameList.Count - 1 downto 0 do
  begin
    ModuleName := ModuleNameList.Strings[i];
    for ii := i - 1 downto 0 do
    begin
      if ModuleName = ModuleNameList.Strings[ii] then
      begin

        Break;
      end;
    end;
  end;
  ModuleNameList.Free;
end;

procedure KillProgram(Classname, WindowTitle: PChar);
const
  PROCESS_TERMINATE = $0001;
var
  ProcessHandle: THandle;
  ProcessID: Dword;
  TheWindow: HWND;
begin
{$I '..\Common\Macros\VMPB.inc'}
  TheWindow := FindWindow(Classname, WindowTitle);
  GetWindowThreadProcessId(TheWindow, ProcessID);
  ProcessHandle := OpenProcess(PROCESS_TERMINATE, False, ProcessID);
  TerminateProcess(ProcessHandle, 4);
{$I '..\Common\Macros\VMPE.inc'}
end;

end.
