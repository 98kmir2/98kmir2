unit LMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SyncObjs, Grids, Buttons, IniFiles, MudUtil, Parse,
  Menus, Grobal2, LSShare, D7ScktComp;

const
  GATEMAXSESSION = 100;

type
  TSendUserData = record
    nSocketIdx: Integer;
    nSocketHandle: Integer;
    sMsg: string;
    sRemoteAddress: string;
  end;
  pTSendUserData = ^TSendUserData;

  TCLSessionInfo = record
    Socket: TCustomWinSocket; //1
    sSocData: string; //2
    sSendData: string; //3
    nUserListIndex: Integer; //4
    nPacketIdx: Integer; //5
    nPacketErrCount: Integer; //6
    boStartLogon: Boolean; //7
    boSendLock: Boolean; //8
    boOverNomSize: Boolean; //9
    nOverNomSizeCount: ShortInt; //10
    dwSendLatestTime: LongWord; //11
    nCheckSendLength: Integer; //12
    boSendAvailable: Boolean; //13
    boSendCheck: Boolean; //14
    dwTimeOutTime: LongWord; //15
    nReceiveLength: Integer; //16
    dwReceiveTick: LongWord; //17
    nSckHandle: Integer; //18
    sRemoteAddr: string; //19
  end;
  pTCLSessionInfo = ^TCLSessionInfo;

  TConnInfo = record
    sAccount: string;
    sIPaddr: string;
    sServerName: string;
    nSessionID: Integer;
    boPayCost: Boolean;
    boCheckOK: Boolean;
    dwKickTick: LongWord;
    dwStartTick: LongWord;
    boKicked: Boolean;
    nLockCount: Integer;
  end;
  pTConnInfo = ^TConnInfo;

  TGateInfo = record
    Socket: TCustomWinSocket;
    sIPaddr: string;
    sReceiveMsg: string;
    UserList: TList;
    dwKeepAliveTick: LongWord;
    dwConnectTick: LongWord;
  end;
  pTGateInfo = ^TGateInfo;

  TUserInfo = record
    sAccount: string;
    sUserIPaddr: string;
    sGateIPaddr: string;
    sSockIndex: string;
    nVersionDate: Integer;
    boCertificationOK: Boolean;
    nSessionID: Integer;
    boPayCost: Boolean;
    nIDDay: Integer;
    nIDHour: Integer;
    nIPDay: Integer;
    nIPHour: Integer;
    dtDateTime: TDateTime;
    boSelServer: Boolean;
    Socket: TCustomWinSocket;
    sReceiveMsg: string;
    dwClientTick: LongWord;
    Gate: pTGateInfo;
    nGetIDFail: Integer;
    //sLoginPassWord: string;
  end;
  pTUserInfo = ^TUserInfo;

  TFrmMain = class(TForm)
    GSocket: TServerSocket;
    ExecTimer: TTimer;
    Panel1: TPanel;
    Memo1: TMemo;
    Timer1: TTimer;
    StartTimer: TTimer;
    BtnDump: TSpeedButton;
    MonitorGrid: TStringGrid;
    Panel2: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    LbMasCount: TLabel;
    CkLogin: TCheckBox;
    CbViewLog: TCheckBox;
    BtnView: TSpeedButton;
    CountLogTimer: TTimer;
    BtnShowServerUsers: TSpeedButton;
    MonitorTimer: TTimer;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_VIEW: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_HELP: TMenuItem;
    MENU_HELP_ABOUT: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_ROUTE: TMenuItem;
    MENU_VIEW_SESSION: TMenuItem;
    C1: TMenuItem;
    ServerSocket: TServerSocket;
    DecodeTimer: TTimer;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ExecTimerTimer(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BtnViewClick(Sender: TObject);
    procedure CountLogTimerTimer(Sender: TObject);
    procedure BtnShowServerUsersClick(Sender: TObject);
    procedure MonitorTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure GSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Panel2DblClick(Sender: TObject);
    procedure CbViewLogClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_OPTION_ROUTEClick(Sender: TObject);
    procedure MENU_VIEW_SESSIONClick(Sender: TObject);
    procedure MENU_HELP_ABOUTClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure ServerSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DecodeTimerTimer(Sender: TObject);
  private
    ParseList: TThreadParseList;
    {IPCClient: TIPCClient;
    procedure IPCClientConnect(AHwnd: HWND);
    procedure IPCClientDisconnect(AHwnd: HWND);
    procedure IPCClientData(MsgPointer: Pointer);}

    procedure ProcessUserPacket(UserData: pTSendUserData);
    procedure GameCenterGetUserAccount(sData: string);
    procedure GameCenterGetUserAccount2(sData: string; Socket: TCustomWinSocket);
    procedure GameCenterChangeAccountInfo(sData: string);
    procedure GameCenterChangeAccountInfo2(sData: string; Socket: TCustomWinSocket);
    procedure OpenRouteConfig();
    { Private declarations }
  public
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    procedure OnProgramException(Sender: TObject; E: Exception);
    procedure CheckGSocketTimeOut();
    { Public declarations }
  end;

procedure StartService(Config: pTConfig);
procedure StopService(Config: pTConfig);
procedure InitializeConfig(Config: pTConfig);
procedure UnInitializeConfig(Config: pTConfig);
procedure LoadConfig(Config: pTConfig);
procedure LoadAddrTable(Config: pTConfig);
procedure GenServerNameList(Config: pTConfig);

procedure WriteLogMsg(Config: pTConfig; sType: string; var UserEntry: TUserEntry; var UserAddEntry: TUserEntryAdd);
procedure SaveContLogMsg(Config: pTConfig; sLogMsg: string);

procedure SendGateMsg(Socket: TCustomWinSocket; sSockIndex, sMsg: string);
procedure SendGateKickMsg(Socket: TCustomWinSocket; sSockIndex: string);
procedure SendKeepAlivePacket(Socket: TCustomWinSocket);

procedure SessionAdd(Config: pTConfig; sAccount, sIPaddr: string; nSessionID: Integer; boPayCost, boCheckOK: Boolean);
procedure SessionDel(Config: pTConfig; nSessionID: Integer);
procedure SessionKick(Config: pTConfig; sLoginID: string);
procedure SessionUpdate(Config: pTConfig; nSessionID: Integer; sServerName: string; boPayCost: Boolean);
procedure SessionClearKick(Config: pTConfig);
function IsPayMent(Config: pTConfig; sIPaddr, sAccount: string): Boolean;
procedure SessionClearNoPayMent(Config: pTConfig);
function IsLogin(Config: pTConfig; sLoginID: string): Boolean; overload;
function IsLogin(Config: pTConfig; nSessionID: Integer): Boolean; overload;
function GetServerListInfo(): string;
procedure GetSelGateInfo(Config: pTConfig; sServerName, sIPaddr: string; var sSelGateIP: string; var nSelGatePort: Integer);
function KickUser(Config: pTConfig; UserInfo: pTUserInfo): Boolean;
procedure CloseUser(Config: pTConfig; sAccount: string; nSessionID: Integer);
procedure CloseUserA(Config: pTConfig; sAccount: string; nSessionID: Integer);
procedure AccountCreate(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
procedure AccountChangePassword(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
procedure AccountCheckProtocol(UserInfo: pTUserInfo; nDate: Integer);
procedure AccountLogin(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
procedure AccountSelectServer(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
procedure AccountUpdateUserInfo(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
procedure AccountGetBackPassword(UserInfo: pTUserInfo; sData: string);

procedure ReceiveSendUser(Config: pTConfig; sSockIndex: string; GateInfo: pTGateInfo; sData: string);
procedure ReceiveOpenUser(Config: pTConfig; sSockIndex: string; sIPaddr: string; GateInfo: pTGateInfo);
procedure ReceiveCloseUser(Config: pTConfig; sSockIndex: string; GateInfo: pTGateInfo);

procedure ProcessUserMsg(Config: pTConfig; UserInfo: pTUserInfo; sMsg: string);

procedure DecodeGateData(Config: pTConfig; GateInfo: pTGateInfo);
procedure DecodeUserData(Config: pTConfig; UserInfo: pTUserInfo);
procedure ProcessGate(Config: pTConfig);

procedure LoadAccountCostList(Config: pTConfig; QuickList: TQuickList);
procedure LoadIPaddrCostList(Config: pTConfig; QuickList: TQuickList);

var
  FrmMain: TFrmMain;
  SessionArray: array[0..GATEMAXSESSION - 1] of TCLSessionInfo;

implementation

uses{$IFDEF SQLDB}IDSQL, {$ELSE}IDDB, {$ENDIF}MasSock, FrmFindId, HUtil32, EDcode, GateSet, sdk, FAccountView, GrobalSession, GeneralConfig;

{$R *.DFM}

procedure TFrmMain.OpenRouteConfig;
begin
  FrmGateSetting := TFrmGateSetting.Create(nil);
  FrmGateSetting.Open;
  FrmGateSetting.Free;
end;
{
procedure TFrmMain.OpenRouteConfig;
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  if FrmGateSetting.Open then begin
    LoadAddrTable(Config);
  end;
end;
}

procedure TFrmMain.MENU_OPTION_ROUTEClick(Sender: TObject);
begin
  OpenRouteConfig();
end;

procedure TFrmMain.MENU_VIEW_SESSIONClick(Sender: TObject);
begin
  frmGrobalSession := TfrmGrobalSession.Create(nil);
  frmGrobalSession.Open;
  frmGrobalSession.Free;
end;

procedure TFrmMain.CbViewLogClick(Sender: TObject);
var
  Config: pTConfig;
begin
  Config := @g_Config;
  Config.boShowDetailMsg := CbViewLog.Checked;
end;

procedure TFrmMain.CheckGSocketTimeOut();
var
  I: Integer;
  II: Integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
  Config: pTConfig;
begin
  Config := @g_Config;
  EnterCriticalSection(Config.GateCriticalSection);
  try
    for I := 0 to Config.GateList.Count - 1 do
    begin
      GateInfo := Config.GateList.Items[I];
      if (GateInfo.Socket <> nil) then
      begin
        if (GetTickCount - GateInfo.dwConnectTick > g_nCloseLoginGateTime * 3600 * 1000) then
        begin
          GateInfo.dwConnectTick := GetTickCount;
          GateInfo.Socket.Close;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

procedure TFrmMain.GSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  GateInfo: pTGateInfo;
  Config: pTConfig;
begin
  Config := @g_Config;
  if not ExecTimer.Enabled then
  begin
    Socket.Close;
    Exit;
  end;
  New(GateInfo);
  GateInfo.Socket := Socket;
  GateInfo.sIPaddr := GetGatePublicAddr(Config, Socket.RemoteAddress);
  GateInfo.sReceiveMsg := '';
  GateInfo.UserList := TList.Create;
  GateInfo.dwKeepAliveTick := GetTickCount();
  GateInfo.dwConnectTick := GetTickCount();
  EnterCriticalSection(Config.GateCriticalSection);
  try
    Config.GateList.Add(GateInfo);
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

procedure TFrmMain.GSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
  II: Integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
  Config: pTConfig;
begin
  Config := @g_Config;
  EnterCriticalSection(Config.GateCriticalSection);
  try
    for I := 0 to Config.GateList.Count - 1 do
    begin
      GateInfo := Config.GateList.Items[I];
      if GateInfo.Socket = Socket then
      begin
        GateInfo.dwConnectTick := GetTickCount();
        for II := 0 to GateInfo.UserList.Count - 1 do
        begin
          UserInfo := GateInfo.UserList.Items[II];
          if Config.boShowDetailMsg then
            MainOutMessage('Close: ' + UserInfo.sUserIPaddr);
          Dispose(UserInfo);
        end;
        GateInfo.Socket := nil;
        GateInfo.UserList.Free;
        Dispose(GateInfo);
        Config.GateList.Delete(I);
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

procedure TFrmMain.GSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.GSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  I: Integer;
  GateInfo: pTGateInfo;
  Config: pTConfig;
begin
  Config := @g_Config;
  EnterCriticalSection(Config.GateCriticalSection);
  try
    for I := 0 to Config.GateList.Count - 1 do
    begin
      GateInfo := Config.GateList.Items[I];
      if GateInfo.Socket = Socket then
      begin
        GateInfo.sReceiveMsg := GateInfo.sReceiveMsg + Socket.ReceiveText;
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

procedure LoadAddrTable(Config: pTConfig);
var
  LoadList: TStringList;
  sFileName: string;
  I: Integer;
  nRouteIdx: Integer;
  nSelGateIdx: Integer;
  sLineText, sTitle, sServerName, sGate, sRemote, sPublic, sGatePort: string;
begin
  sFileName := '.\!addrtable.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    LoadList.LoadFromFile(sFileName);
    nRouteIdx := 0;
    for I := 0 to LoadList.Count - 1 do
    begin
      sLineText := LoadList.Strings[I];
      if (sLineText <> '') and (sLineText[1] <> ';') then
      begin
        sLineText := GetValidStr3(sLineText, sServerName, [' ']);
        sLineText := GetValidStr3(sLineText, sTitle, [' ']);
        sLineText := GetValidStr3(sLineText, sRemote, [' ']);
        sLineText := GetValidStr3(sLineText, sPublic, [' ']);
        sLineText := Trim(sLineText);
        if (sTitle <> '') and (sRemote <> '') and (sPublic <> '') and (nRouteIdx < 60) then
        begin
          Config.GateRoute[nRouteIdx].sServerName := sServerName;
          Config.GateRoute[nRouteIdx].sTitle := sTitle;
          Config.GateRoute[nRouteIdx].sRemoteAddr := sRemote;
          Config.GateRoute[nRouteIdx].sPublicAddr := sPublic;
          nSelGateIdx := 0;
          while (sLineText <> '') do
          begin
            if nSelGateIdx > 9 then
              Break;
            sLineText := GetValidStr3(sLineText, sGate, [' ']);
            if sGate <> '' then
            begin
              if sGate[1] = '*' then
              begin
                sGate := Copy(sGate, 2, Length(sGate) - 1);
                Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].boEnable := False;
              end
              else
                Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].boEnable := true;
              sGatePort := GetValidStr3(sGate, sGate, [':']);
              Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].sIPaddr := sGate;
              Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].nPort := Str_ToInt(sGatePort, 0);
              Config.GateRoute[nRouteIdx].nSelIdx := 0;
              Inc(nSelGateIdx);
            end;
            sLineText := Trim(sLineText);
          end;
          Inc(nRouteIdx);
        end;
      end;
    end;
    Config.nRouteCount := nRouteIdx;
  end;
  LoadList.Free;
  GenServerNameList(Config);
end;

procedure TFrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  nX, nY: Integer;
  Config: pTConfig;
begin
  Application.OnException := OnProgramException;
  Config := @g_Config;
  StartService(Config);
  g_dwGameCenterHandle := Str_ToInt(ParamStr(1), 0);
  nX := Str_ToInt(ParamStr(2), -1);
  nY := Str_ToInt(ParamStr(3), -1);
  if (nX >= 0) or (nY >= 0) then
  begin
    Left := nX;
    Top := nY;
  end;
  Config.boRemoteClose := False;
  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(Self.Handle));

  AccountDB := nil;
  //g_MainMsgList:=TStringList.Create;
  CS_DB := TCriticalSection.Create;
  StringList_0 := TStringList.Create;
  FilterIPList := TStringList.Create;
  if FileExists('.\AllowConnectIPList.txt') then
    FilterIPList.LoadFromFile('.\AllowConnectIPList.txt');
  nSessionIdx := 1;
  n47328C := 1;
  nMemoHeigh := Memo1.Height;
  Config.GateList := TList.Create;
  Config.SessionList := TGList.Create;
  Config.ServerNameList := TStringList.Create;
  Config.AccountCostList := TQuickList.Create;
  Config.IPaddrCostList := TQuickList.Create;
  ParseList := TThreadParseList.Create(true);
  LoadAddrTable(Config);
  MonitorGrid.Cells[0, 0] := '服务器名';
  MonitorGrid.Cells[1, 0] := '用户数';
  MonitorGrid.Cells[2, 0] := '状态';
  MonitorGrid.Cells[3, 0] := '服务器名';
  MonitorGrid.Cells[4, 0] := '用户数';
  MonitorGrid.Cells[5, 0] := '状态';
  {IPCClient := TIPCClient.Create(Self);
  IPCClient.OnConnect := IPCClientConnect;
  IPCClient.OnDisconnect := IPCClientDisconnect;
  IPCClient.OnData := IPCClientData;}
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
var
  I, II: Integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
  Config: pTConfig;
begin
  Config := @g_Config;
  StopService(Config);
  if AccountDB <> nil then
    AccountDB.Free;
  for I := 0 to Config.GateList.Count - 1 do
  begin
    GateInfo := Config.GateList.Items[I];
    for II := 0 to GateInfo.UserList.Count - 1 do
    begin
      UserInfo := GateInfo.UserList.Items[I];
      Dispose(UserInfo);
    end;
    GateInfo.UserList.Free;
    Dispose(GateInfo);
  end;
  Config.GateList.Free;
  Config.SessionList.Free;
  Config.ServerNameList.Free;
  StringList_0.Free;
  FilterIPList.Free;
  CS_DB.Free;
end;

procedure TFrmMain.ExecTimerTimer(Sender: TObject);
var
  Config: pTConfig;
begin
  Config := @g_Config;
  if bo470D20 and not g_boDataDBReady then
    Exit;
  bo470D20 := true;
  try
    ProcessGate(Config);
  finally
    bo470D20 := False;
  end;
end;

procedure TFrmMain.Memo1DblClick(Sender: TObject);
begin
  OpenRouteConfig();
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  I: Integer;
var
  Config: pTConfig;
begin
  Config := @g_Config;
  Label1.Caption := IntToStr(Config.dwProcessGateTime);
  CkLogin.Checked := GSocket.Socket.Connected;
  CkLogin.Caption := '连接 (' + IntToStr(GSocket.Socket.ActiveConnections) + ')';
  LbMasCount.Caption := IntToStr(nOnlineCountMin) + '/' + IntToStr(nOnlineCountMax);
  if Memo1.Lines.Count > 200 then
    Memo1.Clear;
  EnterCriticalSection(g_OutMessageCS);
  try
    for I := 0 to g_MainMsgList.Count - 1 do
      Memo1.Lines.Add(g_MainMsgList.Strings[I]);
    g_MainMsgList.Clear;
  finally
    LeaveCriticalSection(g_OutMessageCS);
  end;
  I := 0;
  while (true) do
  begin
    if StringList_0.Count <= I then
      Break;
    if GetTickCount - LongWord(StringList_0.Objects[I]) > 60 * 1000 then
    begin
      StringList_0.Delete(I);
      Continue;
    end;
    Inc(I);
  end;
  SessionClearKick(Config);
  SessionClearNoPayMent(Config);
end;

procedure TFrmMain.StartTimerTimer(Sender: TObject);
var
  Config: pTConfig;
begin
  Config := @g_Config;
  //StartService(Config);
  SendGameCenterMsg(SG_STARTNOW, '正在启动登录服务器...');
  StartTimer.Enabled := False;
  Application.ProcessMessages;

{$IFDEF SQLDB}
  Memo1.Lines.Add('0) 正在连接SQL服务器...');
  AccountDB := TFileIDDB.Create(Config.sSQLString);
  if (AccountDB <> nil) and AccountDB.Open then
  begin
    Memo1.Lines.Add('1) 连接SQL服务器成功...');
    ParseList.Resume;
    Memo1.Lines.Add('2) 正在等待服务器连接...');
    while (true) do
    begin
      Application.ProcessMessages;
      if Application.Terminated then
        Exit;
      if FrmMasSoc.CheckReadyServers then
        Break;
      Sleep(1);
    end;

    GSocket.Active := False;
    GSocket.Address := Config.sGateAddr;
    GSocket.Port := Config.nGatePort;
    GSocket.Active := true;
    Memo1.Lines.Add('3) 服务器启动完成...');
    ExecTimer.Enabled := true;
    SendGameCenterMsg(SG_STARTOK, '登录服务器启动完成...');
  end
  else
    Memo1.Lines.Add('1) 连接SQL服务器失败...');
{$ELSE}
  Memo1.Lines.Add('0) 正在启动服务器...');
  AccountDB := TFileIDDB.Create(Config.sIdDir + 'Id.DB');
  ParseList.Resume;
  Memo1.Lines.Add('1) 正在等待服务器连接...');
  while (true) do
  begin
    Application.ProcessMessages;
    if Application.Terminated then
      Exit;
    if FrmMasSoc.CheckReadyServers then
      Break;
    Sleep(1);
  end;

  ServerSocket.Active := False;
  if Config.CLOpen then
  begin
    ServerSocket.Address := '0.0.0.0';
    ServerSocket.Port := Config.CLPort;
    ServerSocket.Active := true;
  end;

  GSocket.Active := False;
  GSocket.Address := Config.sGateAddr;
  GSocket.Port := Config.nGatePort;
  GSocket.Active := true;
  Memo1.Lines.Add('2) 服务器启动完成...');
  ExecTimer.Enabled := true;
  SendGameCenterMsg(SG_STARTOK, '登录服务器启动完成...');
{$ENDIF}
end;

procedure TFrmMain.ServerSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  boOK: Boolean;
  I, nSockIdx: Integer;
  sRemoteIPaddr: string;
  UserSession: pTCLSessionInfo;
begin
  if not ExecTimer.Enabled then
  begin
    Socket.Close;
    Exit;
  end;
  Socket.nIndex := -1;
  sRemoteIPaddr := Socket.RemoteAddress;
  boOK := False;
  if FilterIPList.Count > 0 then
  begin
    for I := 0 to FilterIPList.Count - 1 do
    begin
      if CompareText(sRemoteIPaddr, FilterIPList[I]) = 0 then
      begin
        boOK := true;
        Break;
      end;
    end;
  end
  else
    boOK := true;

  if not boOK then
  begin
    MainOutMessage(format('[远程ID管理] %s 不允许的IP...', [sRemoteIPaddr]));
    Socket.Close;
    Exit;
  end;

  for nSockIdx := 0 to GATEMAXSESSION - 1 do
  begin
    UserSession := @SessionArray[nSockIdx];
    if UserSession.Socket = nil then
    begin
      UserSession.Socket := Socket;
      UserSession.sSocData := '';
      UserSession.sSendData := '';
      UserSession.nUserListIndex := 0;
      UserSession.nPacketIdx := -1;
      UserSession.nPacketErrCount := 0;
      UserSession.boStartLogon := true;
      UserSession.boSendLock := False;
      UserSession.dwSendLatestTime := GetTickCount();
      UserSession.boSendAvailable := true;
      UserSession.boSendCheck := False;
      UserSession.nCheckSendLength := 0;
      UserSession.nReceiveLength := 0;
      UserSession.dwReceiveTick := GetTickCount();
      UserSession.nSckHandle := Socket.SocketHandle;
      UserSession.sRemoteAddr := sRemoteIPaddr;
      UserSession.boOverNomSize := False;
      UserSession.nOverNomSizeCount := 0;
      Socket.nIndex := nSockIdx;
      MainOutMessage(format('[远程ID管理] %s 打开连接...', [sRemoteIPaddr]));
      Break;
    end;
  end;

  if nSockIdx < GATEMAXSESSION then
  begin
    Socket.nIndex := nSockIdx;
  end
  else
  begin
    Socket.nIndex := -1;
    Socket.Close;
    MainOutMessage(format('[远程ID管理] %s 允许的连接已满...', [sRemoteIPaddr]));
  end;
end;

procedure TFrmMain.ServerSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  I: Integer;
  nSockIndex: Integer;
  sRemoteAddr: string;
  UserSession: pTCLSessionInfo;
begin
  sRemoteAddr := Socket.RemoteAddress;
  nSockIndex := Socket.nIndex;
  if (nSockIndex >= 0) and (nSockIndex < GATEMAXSESSION) then
  begin
    UserSession := @SessionArray[nSockIndex];
    UserSession.Socket := nil;
    UserSession.nSckHandle := -1;
    UserSession.sSocData := '';
    UserSession.sSendData := '';
    Socket.nIndex := -1;
  end;
end;

procedure TFrmMain.ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  I, nReviceLen: Integer;
  sReviceMsg, sMsgFilter: string;
  sRemoteAddress, sData, sMsg: string;
  nSocketIndex: Integer;
  nPos: Integer;
  UserData: pTSendUserData;
  nMsgCount: Integer;
  nDataLen: Integer;
  UserSession: pTCLSessionInfo;
  sDefMsg, sDataMsg, sText: string;
  dmsg, DefMsg: TDefaultMessage;
  boCheckMsg: Boolean;
begin
  sRemoteAddress := Socket.RemoteAddress;
  nSocketIndex := Socket.nIndex;
  sReviceMsg := Socket.ReceiveText;
  nReviceLen := Length(sReviceMsg);
  if (nSocketIndex >= 0) and (nSocketIndex < GATEMAXSESSION) and (sReviceMsg <> '') and ExecTimer.Enabled then
  begin
    if nReviceLen > 1000 then
    begin
      MainOutMessage(format('[远程ID管理] %s 封包过长...', [sRemoteAddress]));
      Socket.Close;
      Exit;
    end;
    UserSession := @SessionArray[nSocketIndex];
    if UserSession.Socket = Socket then
    begin
      //MainOutMessage(format('[远程ID管理] %s 接受处理数据...', [sRemoteAddress]));

      nPos := Pos('*', sReviceMsg);
      if nPos > 0 then
      begin
        UserSession.boSendAvailable := true;
        UserSession.boSendCheck := False;
        UserSession.nCheckSendLength := 0;
        UserSession.dwReceiveTick := GetTickCount();
        sReviceMsg := Copy(sReviceMsg, 1, nPos - 1) + Copy(sReviceMsg, nPos + 1, Length(sReviceMsg));
      end;
      if (sReviceMsg <> '') then
      begin
        New(UserData);
        UserData.nSocketIdx := nSocketIndex;
        UserData.nSocketHandle := Socket.SocketHandle;
        UserData.sMsg := sReviceMsg;
        UserData.sRemoteAddress := sRemoteAddress;
        ReviceMsgList.Add(UserData);
      end;
    end;
  end;
end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
begin
  FrmFindUserId.Show;
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean); //0x0046DDB0
var
  Config: pTConfig;
resourcestring
  sExitMsg = '是否确认停止登录服务器 ?';
  sExitTitle = '确认信息';
begin
  Config := @g_Config;
  if Config.boRemoteClose then
    Exit;
  if MessageBox(Handle, PChar(sExitMsg), PChar(sExitTitle), MB_YESNO + MB_ICONQUESTION) = mrYes then
    CanClose := true
  else
    CanClose := False;
end;

procedure TFrmMain.BtnViewClick(Sender: TObject);
var
  Config: pTConfig;
begin
  Config := @g_Config;
  try
    CS_DB.Enter;
    FrmAccountView.ListBox1.Items := Config.AccountCostList;
    FrmAccountView.ListBox2.Items := Config.IPaddrCostList;
  finally
    CS_DB.Leave;
  end;
  FrmAccountView.ShowModal;
end;

procedure TFrmMain.CountLogTimerTimer(Sender: TObject);
var
  sLogMsg: string;
  Config: pTConfig;
resourcestring
  sFormatMsg = '%d/%d';
begin
  Config := @g_Config;
  sLogMsg := format(sFormatMsg, [nOnlineCountMin, nOnlineCountMax]);
  SaveContLogMsg(Config, sLogMsg);
  nOnlineCountMax := 0;
end;

procedure TFrmMain.BtnShowServerUsersClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to nUserLimit - 1 do
    MainOutMessage(UserLimit[I].sServerName + ' ' + IntToStr(UserLimit[I].nLimitCountMin) + '/' + IntToStr(UserLimit[I].nLimitCountMax));
end;

procedure TFrmMain.MonitorTimerTimer(Sender: TObject);
var
  I: Integer;
  nCol: Integer;
  sServerName: string;
  ServerList: TList;
  MsgServer: pTMsgServerInfo;
begin
  try
    ServerList := FrmMasSoc.m_ServerList;
    if (ServerList.Count div 2) < 2 then
    begin
      MonitorGrid.RowCount := 2;
      MonitorGrid.Cells[0, 1] := '';
      MonitorGrid.Cells[1, 1] := '';
      MonitorGrid.Cells[2, 1] := '';
      MonitorGrid.Cells[3, 1] := '';
      MonitorGrid.Cells[4, 1] := '';
      MonitorGrid.Cells[5, 1] := '';
    end
    else
      MonitorGrid.RowCount := ((ServerList.Count div 2) + 1) + (ServerList.Count mod 2);

    for I := 0 to ServerList.Count - 1 do
    begin
      nCol := (I mod 2) * 3;
      MsgServer := ServerList.Items[I];
      sServerName := MsgServer.sServerName;
      if sServerName <> '' then
      begin
        if MsgServer.nServerIndex = 99 then
          MonitorGrid.Cells[nCol, (I div 2 + 1)] := sServerName + '[DB]'
        else
          MonitorGrid.Cells[nCol, (I div 2 + 1)] := sServerName + ' ' + IntToStr(MsgServer.nServerIndex);
        MonitorGrid.Cells[nCol + 1, (I div 2 + 1)] := IntToStr(MsgServer.nOnlineCount);
        if (GetTickCount - MsgServer.dwKeepAliveTick) < 30000 then
          MonitorGrid.Cells[nCol + 2, (I div 2 + 1)] := '正常'
        else
          MonitorGrid.Cells[nCol + 2, (I div 2 + 1)] := '超时';
      end
      else
      begin
        MonitorGrid.Cells[nCol, (I div 2 + 1)] := '-';
        MonitorGrid.Cells[nCol + 1, (I div 2 + 1)] := '-';
        MonitorGrid.Cells[nCol + 2, (I div 2 + 1)] := '-';
      end;
    end;

    if g_boCloseLoginGate then
      CheckGSocketTimeOut();
  except
    MainOutMessage('TFrmMain.MonitorTimerTimer');
  end;
end;

function IsPayMent(Config: pTConfig; sIPaddr, sAccount: string): Boolean;
begin
  Result := False;
  try
    CS_DB.Enter;
    if (Config.AccountCostList.GetIndex(sAccount) >= 0) or (Config.IPaddrCostList.GetIndex(sIPaddr) >= 0) then
      Result := true;
  finally
    CS_DB.Leave;
  end;
end;

procedure CloseUser(Config: pTConfig; sAccount: string; nSessionID: Integer);
var
  ConnInfo: pTConnInfo;
  I: Integer;
begin
  Config.SessionList.Lock;
  try
    for I := Config.SessionList.Count - 1 downto 0 do
    begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.sAccount = sAccount) or (ConnInfo.nSessionID = nSessionID) then
      begin
        FrmMasSoc.SendServerMsg(SS_CLOSESESSION, ConnInfo.sServerName, ConnInfo.sAccount + '/' + IntToStr(ConnInfo.nSessionID));
        Dispose(ConnInfo);
        Config.SessionList.Delete(I);
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure CloseUserA(Config: pTConfig; sAccount: string; nSessionID: Integer);
var
  ConnInfo: pTConnInfo;
  I: Integer;
begin
  Config.SessionList.Lock;
  try
    for I := Config.SessionList.Count - 1 downto 0 do
    begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.sAccount = sAccount) or (ConnInfo.nSessionID = nSessionID) then
      begin
        //FrmMasSoc.SendServerMsg(SS_CLOSESESSION, ConnInfo.sServerName, ConnInfo.sAccount + '/' + IntToStr(ConnInfo.nSessionID));
        Dispose(ConnInfo);
        Config.SessionList.Delete(I);
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure ProcessGate(Config: pTConfig);
var
  I: Integer;
  II: Integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
begin
  EnterCriticalSection(Config.GateCriticalSection);
  try
    Config.dwProcessGateTick := GetTickCount();
    I := 0;
    while (true) do
    begin
      if Config.GateList.Count <= I then
        Break;
      GateInfo := Config.GateList.Items[I];
      if GateInfo.sReceiveMsg <> '' then
      begin
        DecodeGateData(Config, GateInfo);
        Config.sGateIPaddr := GateInfo.sIPaddr;
        II := 0;
        while (true) do
        begin
          if GateInfo.UserList.Count <= II then
            Break;
          UserInfo := GateInfo.UserList.Items[II];
          if UserInfo.sReceiveMsg <> '' then
            DecodeUserData(Config, UserInfo);
          Inc(II);
        end;
      end;
      Inc(I);
    end;
    if Config.dwProcessGateTime < Config.dwProcessGateTick then
      Config.dwProcessGateTime := GetTickCount - Config.dwProcessGateTick;
    if Config.dwProcessGateTime > 100 then
      Dec(Config.dwProcessGateTime, 100);
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

procedure DecodeGateData(Config: pTConfig; GateInfo: pTGateInfo);
var
  m, nCount: Integer;
  sMsg: string;
  sSockIndex: string;
  sData: string;
  Code: Char;
resourcestring
  sExceptionMsg = '[Exception] TFrmMain.DecodeGateData';
begin
  try
    //m := 0;
    nCount := 0;
    while (true) do
    begin
      //Inc(m);
      if (Pos('$', GateInfo.sReceiveMsg) <= 0) then
        Break;
      if (Pos('%', GateInfo.sReceiveMsg) <= 0) then
        Break;

      //if (m > 10) then begin
      //  GateInfo.sReceiveMsg := '';
      //  Break;
      //end;
      //if TagCount(GateInfo.sReceiveMsg, '$') <= 0 then Break;

      GateInfo.sReceiveMsg := ArrestStringEx(GateInfo.sReceiveMsg, '%', '$', sMsg);

      if sMsg <> '' then
      begin
        Code := sMsg[1];
        sMsg := Copy(sMsg, 2, Length(sMsg) - 1);
        case Code of
          '-':
            begin
              SendKeepAlivePacket(GateInfo.Socket);
              GateInfo.dwKeepAliveTick := GetTickCount();
            end;
          'D':
            begin
              sData := GetValidStr3(sMsg, sSockIndex, ['/']);
              ReceiveSendUser(Config, sSockIndex, GateInfo, sData);
            end;
          'L':
            begin
              sData := GetValidStr3(sMsg, sSockIndex, ['/']);
              ReceiveOpenUser(Config, sSockIndex, sData, GateInfo);
            end;
          'X':
            begin
              sSockIndex := sMsg;
              ReceiveCloseUser(Config, sSockIndex, GateInfo);
            end;
        end;
      end
      else
      begin
        if nCount >= 1 then
          GateInfo.sReceiveMsg := '';
        Inc(nCount);
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure SendKeepAlivePacket(Socket: TCustomWinSocket);
begin
  if Socket.Connected then
    Socket.SendText('%++$');
end;

procedure ReceiveCloseUser(Config: pTConfig; sSockIndex: string; GateInfo: pTGateInfo);
var
  UserInfo: pTUserInfo;
  I: Integer;
resourcestring
  sCloseMsg = 'Close: %s';
begin
  for I := 0 to GateInfo.UserList.Count - 1 do
  begin
    UserInfo := GateInfo.UserList.Items[I];
    if UserInfo.sSockIndex = sSockIndex then
    begin
      if Config.boShowDetailMsg then
        MainOutMessage(format(sCloseMsg, [UserInfo.sUserIPaddr]));
      if not UserInfo.boSelServer then
        SessionDel(Config, UserInfo.nSessionID);
      Dispose(UserInfo);
      GateInfo.UserList.Delete(I);
      Break;
    end;
  end;
end;

procedure ReceiveOpenUser(Config: pTConfig; sSockIndex, sIPaddr: string; GateInfo: pTGateInfo);
var
  UserInfo: pTUserInfo;
  I: Integer;
  sGateIPaddr, sServerName: string;
  sUserIPaddr: string;
  DefMsg: TDefaultMessage;
resourcestring
  sOpenMsg = 'Open: %s/%s';
begin
  sGateIPaddr := GetValidStr3(sIPaddr, sUserIPaddr, ['/']);
  if not IsIPaddr(sGateIPaddr) or not IsIPaddr(sUserIPaddr) then
    Exit;
  try
    for I := 0 to GateInfo.UserList.Count - 1 do
    begin
      UserInfo := GateInfo.UserList.Items[I];
      if UserInfo.sSockIndex = sSockIndex then
      begin
        UserInfo.sUserIPaddr := sUserIPaddr;
        UserInfo.sGateIPaddr := sGateIPaddr;
        UserInfo.sAccount := '';
        UserInfo.nSessionID := 0;
        UserInfo.sReceiveMsg := '';
        UserInfo.dwClientTick := GetTickCount();
        Exit;
      end;
    end;
    New(UserInfo);
    UserInfo.sAccount := '';
    UserInfo.sUserIPaddr := sUserIPaddr;
    UserInfo.sGateIPaddr := sGateIPaddr;
    UserInfo.sSockIndex := sSockIndex;
    UserInfo.nVersionDate := 0;
    UserInfo.boCertificationOK := False;
    UserInfo.nSessionID := 0;
    UserInfo.Socket := GateInfo.Socket;
    UserInfo.sReceiveMsg := '';
    UserInfo.dwClientTick := GetTickCount();
    UserInfo.Gate := GateInfo;
    UserInfo.nGetIDFail := 0;
    GateInfo.UserList.Add(UserInfo);

    //UserInfo.nSessionID := GetSessionID();
    //UserInfo.boSelServer := False;
    //DefMsg := MakeDefaultMsg(SM_PASSOK_SELECTSERVER, 0, 0, 0, Config.ServerNameList.Count);
    //sServerName := GetServerListInfo;
    //SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg) + EncodeString(sServerName));

    if Config.boShowDetailMsg then
      MainOutMessage(format(sOpenMsg, [sUserIPaddr, sGateIPaddr]));

  except
    MainOutMessage('TFrmMain.ReceiveOpenUser');
  end;
end;

procedure ReceiveSendUser(Config: pTConfig; sSockIndex: string; GateInfo: pTGateInfo; sData: string);
var
  UserInfo: pTUserInfo;
  I: Integer;
resourcestring
  sExceptMsg = '[Exception] TFrmMain.ReceiveSendUser';
begin
  try
    for I := 0 to GateInfo.UserList.Count - 1 do
    begin
      UserInfo := GateInfo.UserList.Items[I];
      if UserInfo.sSockIndex = sSockIndex then
      begin
        if Length(UserInfo.sReceiveMsg) < 4069 then
        begin
          UserInfo.sReceiveMsg := UserInfo.sReceiveMsg + sData;
        end
        else
        begin
          MainOutMessage('数据长度超出限制');
        end;
        Break;
      end;
    end;
  except
    MainOutMessage(sExceptMsg);
  end;
end;

procedure SessionClearKick(Config: pTConfig);
var
  I: Integer;
  ConnInfo: pTConnInfo;
begin
  Config.SessionList.Lock;
  try
    for I := Config.SessionList.Count - 1 downto 0 do
    begin
      ConnInfo := Config.SessionList.Items[I];
      if ConnInfo.boKicked and ((GetTickCount - ConnInfo.dwKickTick) > 3000) then
      begin
        Dispose(ConnInfo);
        Config.SessionList.Delete(I);
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure DecodeUserData(Config: pTConfig; UserInfo: pTUserInfo);
var
  sMsg: string;
  n, nCount: Integer;
resourcestring
  sExceptMsg = '[Exception] TFrmMain.DecodeUserData';
begin
  nCount := 0;
  try
    while (true) do
    begin
      //if TagCount(UserInfo.sReceiveMsg, '!') <= 0 then Break;
      if (Pos('#', UserInfo.sReceiveMsg) <= 0) then
        Break;
      if (Pos('!', UserInfo.sReceiveMsg) <= 0) then
        Break;
      UserInfo.sReceiveMsg := ArrestStringEx(UserInfo.sReceiveMsg, '#', '!', sMsg);
      if sMsg <> '' then
      begin
        if Length(sMsg) >= DEFBLOCKSIZE + 1 then
        begin
          sMsg := Copy(sMsg, 2, Length(sMsg) - 1);
          ProcessUserMsg(Config, UserInfo, sMsg);
        end;
      end
      else
      begin
        if nCount >= 1 then
          UserInfo.sReceiveMsg := '';
        Inc(nCount);
      end;
      //if UserInfo.sReceiveMsg = '' then Break;
    end;
  except
    MainOutMessage(sExceptMsg);
  end;
end;

procedure SessionDel(Config: pTConfig; nSessionID: Integer);
var
  ConnInfo: pTConnInfo;
  I: Integer;
begin
  Config.SessionList.Lock;
  try
    for I := 0 to Config.SessionList.Count - 1 do
    begin
      ConnInfo := Config.SessionList.Items[I];
      if ConnInfo.nSessionID = nSessionID then
      begin
        Dispose(ConnInfo);
        Config.SessionList.Delete(I);
        Break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure ProcessUserMsg(Config: pTConfig; UserInfo: pTUserInfo; sMsg: string);
var
  sDefMsg: string;
  sData: string;
  DefMsg: TDefaultMessage;
begin
  try
    sDefMsg := Copy(sMsg, 1, DEFBLOCKSIZE);
    sData := Copy(sMsg, DEFBLOCKSIZE + 1, Length(sMsg) - DEFBLOCKSIZE);
    DefMsg := DecodeMessage(sDefMsg);
    case DefMsg.Ident of
      CM_SELECTSERVER: if not UserInfo.boSelServer then
          AccountSelectServer(Config, UserInfo, sData);
      CM_PROTOCOL: AccountCheckProtocol(UserInfo, DefMsg.Recog);
      CM_IDPASSWORD:
        begin
          if UserInfo.sAccount = '' then
            AccountLogin(Config, UserInfo, sData)
          else
            KickUser(Config, UserInfo);
        end;
      CM_ADDNEWUSER:
        begin
          if Config.boEnableMakingID then
          begin
            if (GetTickCount - UserInfo.dwClientTick) > Config.dwAddNewUserTick then
            begin
              UserInfo.dwClientTick := GetTickCount();
              AccountCreate(Config, UserInfo, sData);
            end
            else
              MainOutMessage('[超速操作] 创建帐号 /' + UserInfo.sUserIPaddr);
          end;
        end;
      CM_CHANGEPASSWORD:
        begin
          if Config.boAllowChangePassword then
          begin
            if UserInfo.sAccount = '' then
            begin
              if (GetTickCount - UserInfo.dwClientTick) > Config.dwChgPassWordTick then
              begin
                UserInfo.dwClientTick := GetTickCount();
                AccountChangePassword(Config, UserInfo, sData);
              end
              else
                //MainOutMessage('[超速操作] 修改密码 /' + UserInfo.sUserIPaddr);
            end
            else
              UserInfo.sAccount := '';
          end;
        end;
      CM_UPDATEUSER:
        begin
          if (GetTickCount - UserInfo.dwClientTick) > Config.dwUpdateUserInfoTick then
          begin
            UserInfo.dwClientTick := GetTickCount();
            AccountUpdateUserInfo(Config, UserInfo, sData);
          end
          else
            //MainOutMessage('[超速操作] 更新帐号 /' + UserInfo.sUserIPaddr);
        end;
      CM_GETBACKPASSWORD:
        begin
          if Config.boGetbackPassword then
          begin
            if (sData = '') or (Length(sData) < 20) then
            begin
              //MainOutMessage('[攻击操作] IDDB攻击 /' + UserInfo.sUserIPaddr);
              Exit;
            end;
            if (GetTickCount - UserInfo.dwClientTick) > Config.GetBackPasswordTick then
            begin
              UserInfo.dwClientTick := GetTickCount();
              AccountGetBackPassword(UserInfo, sData);
            end
            else
              //MainOutMessage('[超速操作] 找回密码 /' + UserInfo.sUserIPaddr);
          end;
        end;
    end;
  except
    MainOutMessage('[Exception] TFrmMain.ProcessUserMsg ' + 'wIdent: ' + IntToStr(DefMsg.Ident) + ' sData: ' + sData);
  end;
end;

procedure AccountCreate(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
var
  UserEntry: TUserEntry;
  UserAddEntry: TUserEntryAdd;
  UserEntryA: TUserEntryA;
  DBRecord: TAccountDBRecord;
  nLen: Integer;
  //sUserEntryMsg             : string;
  //sUserAddEntryMsg          : string;
  nErrCode: Integer;
  DefMsg: TDefaultMessage;
  boAccountOK: Boolean;
  n10: Integer;
resourcestring
  sAddNewuserFail = '[新建帐号失败] %s/%s';
  sLogFlag = 'new';
begin
  try
    nErrCode := -1;
    if sData <> '' then
    begin
      FillChar(UserEntry, SizeOf(TUserEntry), #0);
      FillChar(UserEntryA, SizeOf(TUserEntryA), #0);
      FillChar(UserAddEntry, SizeOf(TUserEntryAdd), #0);
      boAccountOK := False;
      if (sData <> '') then
      begin
        DecodeBuffer(sData, @UserEntryA, SizeOf(TUserEntryA));
        if CheckAccountName(UserEntryA.sAccount) then
          boAccountOK := true;
        if boAccountOK then
        begin
          try
            if AccountDB.Open then
            begin
              n10 := AccountDB.Index(UserEntryA.sAccount);
              if n10 < 0 then
              begin
                FillChar(DBRecord, SizeOf(TAccountDBRecord), #0);
                Move(UserEntryA, UserEntry, SizeOf(TUserEntry));
                UserAddEntry.sQuiz2 := UserEntryA.sQuiz2;
                UserAddEntry.sAnswer2 := UserEntryA.sAnswer2;
                UserAddEntry.sBirthDay := UserEntryA.sBirthDay;
                UserAddEntry.sMobilePhone := UserEntryA.sMobilePhone;
                UserAddEntry.sMemo := UserEntryA.sMemo;
                UserAddEntry.sMemo2 := UserEntryA.sMemo2;
                DBRecord.UserEntry := UserEntry;
                DBRecord.UserEntryAdd := UserAddEntry;
                if UserEntryA.sAccount <> '' then
                  if AccountDB.Add(DBRecord) then
                    nErrCode := 1;
              end
              else
                nErrCode := 0;
            end;
          finally
            AccountDB.Close;
          end;
        end
        else
        begin
          MainOutMessage(format(sAddNewuserFail, [UserEntryA.sAccount, UserEntryA.sQuiz2]));
        end;
      end;
      if nErrCode = 1 then
      begin
        WriteLogMsg(Config, sLogFlag, UserEntry, UserAddEntry);
        DefMsg := MakeDefaultMsg(SM_NEWID_SUCCESS, 0, 0, 0, 0);
      end
      else
        DefMsg := MakeDefaultMsg(SM_NEWID_FAIL, nErrCode, 0, 0, 0);

      {FillChar(UserEntry, SizeOf(TUserEntry), #0);
      FillChar(UserAddEntry, SizeOf(TUserEntryAdd), #0);
      nLen := GetCodeMsgSize(SizeOf(TUserEntry) * 4 / 3);
      bo21 := False;
      sUserEntryMsg := Copy(sData, 1, nLen);
      sUserAddEntryMsg := Copy(sData, nLen + 1, Length(sData) - nLen);
      if (sUserEntryMsg <> '') and (sUserAddEntryMsg <> '') then begin
        DecodeBuffer(sUserEntryMsg, @UserEntry, SizeOf(TUserEntry));
        DecodeBuffer(sUserAddEntryMsg, @UserAddEntry, SizeOf(TUserEntryAdd));
        if CheckAccountName(UserEntry.sAccount) then
          bo21 := true;
        if bo21 then begin
          try
            if AccountDB.Open then begin
              n10 := AccountDB.Index(UserEntry.sAccount);
              if n10 < 0 then begin
                FillChar(DBRecord, SizeOf(TAccountDBRecord), #0);
                DBRecord.UserEntry := UserEntry;
                DBRecord.UserEntryAdd := UserAddEntry;
                if UserEntry.sAccount <> '' then
                  if AccountDB.Add(DBRecord) then
                    nErrCode := 1;
              end else
                nErrCode := 0;
            end;
          finally
            AccountDB.Close;
          end;
        end else begin
          MainOutMessage(Format(sAddNewuserFail, [UserEntry.sAccount, UserAddEntry.sQuiz2]));
        end;
      end;
      if nErrCode = 1 then begin
        WriteLogMsg(Config, sLogFlag, UserEntry, UserAddEntry);
        DefMsg := MakeDefaultMsg(SM_NEWID_SUCCESS, 0, 0, 0, 0);
      end else
        DefMsg := MakeDefaultMsg(SM_NEWID_FAIL, nErrCode, 0, 0, 0);}

      SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
    end;
  except
    //MainOutMessage('TFrmMain.AddNewUser');
  end;
end;

procedure AccountChangePassword(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
var
  sMsg, sPassPro: string;
  sLoginID: string;
  sOldPassword: string;
  sNewPassword: string;
  DefMsg: TDefaultMessage;
  nCode: Integer;
  n10: Integer;
  DBRecord: TAccountDBRecord;
resourcestring
  sChgMsg = 'chg';
begin
  try
    if sData = '' then
    begin
      DefMsg := MakeDefaultMsg(SM_CHGPASSWD_FAIL, 0, 0, 0, 0);
      SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
      Exit;
    end;
    sMsg := DecodeString(sData);
    sMsg := GetValidStr3(sMsg, sLoginID, [#9]);
    sMsg := GetValidStr3(sMsg, sOldPassword, [#9]);
    sPassPro := GetValidStr3(sMsg, sNewPassword, [#9]);
    if (sLoginID = '') or (sNewPassword = '') or (Length(sLoginID) > 10) then
    begin
      DefMsg := MakeDefaultMsg(SM_CHGPASSWD_FAIL, 0, 0, 0, 0);
      SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
      Exit;
    end;
    nCode := 0;
    try
      if (Length(sNewPassword) >= 3) and AccountDB.Open then
      begin
        n10 := AccountDB.Index(sLoginID);
        if (n10 >= 0) and (AccountDB.Get(n10, DBRecord) >= 0) then
        begin
          if (DBRecord.nErrorCount < 5) or ((GetTickCount - DBRecord.dwActionTick) > 3 * 60 * 1000) then
          begin
            if DBRecord.UserEntry.sPassword = sOldPassword then
            begin
              DBRecord.nErrorCount := 0;
              DBRecord.UserEntry.sPassword := sNewPassword;
              nCode := 1;
            end
            else
            begin
              Inc(DBRecord.nErrorCount);
              DBRecord.dwActionTick := GetTickCount();
              nCode := -1;
            end;
            AccountDB.Update(n10, DBRecord);
          end
          else
          begin
            nCode := -2;
            if GetTickCount < DBRecord.dwActionTick then
            begin
              DBRecord.dwActionTick := GetTickCount();
              AccountDB.Update(n10, DBRecord);
            end;
          end;
        end;
      end;
    finally
      AccountDB.Close;
    end;
    if nCode = 1 then
    begin
      DefMsg := MakeDefaultMsg(SM_CHGPASSWD_SUCCESS, 0, 0, 0, 0);
      WriteLogMsg(Config, sChgMsg, DBRecord.UserEntry, DBRecord.UserEntryAdd);
    end
    else
    begin
      DefMsg := MakeDefaultMsg(SM_CHGPASSWD_FAIL, nCode, 0, 0, 0);
    end;
    SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
  except
    //MainOutMessage('TFrmMain.ChangePassword');
  end;
end;

procedure AccountCheckProtocol(UserInfo: pTUserInfo; nDate: Integer);
var
  DefMsg: TDefaultMessage;
begin
  if nDate < nVersionDate then
  begin
    DefMsg := MakeDefaultMsg(SM_CERTIFICATION_FAIL, 0, 0, 0, 0);
  end
  else
  begin
    DefMsg := MakeDefaultMsg(SM_CERTIFICATION_SUCCESS, 0, 0, 0, 0);
    UserInfo.nVersionDate := nDate;
    UserInfo.boCertificationOK := true;
  end;
  SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
end;

function KickUser(Config: pTConfig; UserInfo: pTUserInfo): Boolean;
var
  I: Integer;
  II: Integer;
  GateInfo: pTGateInfo;
  User: pTUserInfo;
resourcestring
  sKickMsg = 'Kick: %s';
begin
  Result := False;
  EnterCriticalSection(Config.GateCriticalSection);
  try
    for I := 0 to Config.GateList.Count - 1 do
    begin
      GateInfo := Config.GateList.Items[I];
      for II := 0 to GateInfo.UserList.Count - 1 do
      begin
        User := GateInfo.UserList.Items[II];
        if User = UserInfo then
        begin
          if Config.boShowDetailMsg then
            MainOutMessage(format(sKickMsg, [UserInfo.sUserIPaddr]));
          SendGateKickMsg(GateInfo.Socket, UserInfo.sSockIndex);
          Dispose(UserInfo);
          GateInfo.UserList.Delete(II);
          Result := true;
          Exit;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

procedure AccountLogin(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
var
  sLoginID: string;
  sPassword: string;
  nCode: Integer;
  boNeedUpdate: Boolean;
  DefMsg: TDefaultMessage;
  UserEntry: TUserEntry;
  nIDCost: Integer;
  nIPCost: Integer;
  nIDCostIndex: Integer;
  nIPCostIndex: Integer;
  DBRecord: TAccountDBRecord;
  n10: Integer;
  boPayCost: Boolean;
  sInputPwd, sServerName: string;
  nRandomNO: Integer;
begin
  try
    sPassword := GetValidStr3(DecodeString(sData), sLoginID, ['/']);
    if (sPassword = '') or (sLoginID = '') or (Length(sPassword) > 10) or (Length(sLoginID) > 10) then
      Exit;
    nCode := 0;
    boNeedUpdate := False;
    try
      if AccountDB.Open then
      begin
        n10 := AccountDB.Index(sLoginID);
        if n10 < 0 then
        begin
          Inc(UserInfo.nGetIDFail);
          //SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, '__ID__' + IntToStr(UserInfo.nGetIDFail));
          DefMsg := MakeDefaultMsg(SM_PASSWD_FAIL, nCode, 0, 0, 0);
          SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg) + IntToStr(UserInfo.nGetIDFail));
          Exit;
        end;
        if (n10 >= 0) and (AccountDB.Get(n10, DBRecord) >= 0) then
        begin
          if (DBRecord.nErrorCount < 5) or ((GetTickCount - DBRecord.dwActionTick) > 30 * 1000) then
          begin
            if DBRecord.UserEntry.sPassword = sPassword then
            begin
              DBRecord.nErrorCount := 0;
              {if (DBRecord.UserEntry.sUserName = '') or (DBRecord.UserEntryAdd.sQuiz2 = '') then begin
                UserEntry := DBRecord.UserEntry;
                boNeedUpdate := true;
              end;}
              DBRecord.Header.CreateDate := UserInfo.dtDateTime;
              nCode := 1;
            end
            else
            begin
              Inc(DBRecord.nErrorCount);
              DBRecord.dwActionTick := GetTickCount();
              nCode := -1;
            end;
            AccountDB.Update(n10, DBRecord);
          end
          else
          begin
            nCode := -2;
            DBRecord.dwActionTick := GetTickCount();
            AccountDB.Update(n10, DBRecord);
          end;
        end;
      end;
    finally
      AccountDB.Close;
    end;

    if (nCode = 1) and IsLogin(Config, sLoginID) then
    begin
      SessionKick(Config, sLoginID);
      nCode := -3;
    end;

    {if boNeedUpdate then begin
      DefMsg := MakeDefaultMsg(SM_NEEDUPDATE_ACCOUNT, 0, 0, 0, 0);
      SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg) + EncodeBuffer(@UserEntry, SizeOf(TUserEntry)));
    end;}

    if nCode = 1 then
    begin
      UserInfo.sAccount := sLoginID;
      UserInfo.nSessionID := GetSessionID();
      UserInfo.boSelServer := False;
      try
        CS_DB.Enter;
        nIDCostIndex := Config.AccountCostList.GetIndex(UserInfo.sAccount);
        nIPCostIndex := Config.IPaddrCostList.GetIndex(UserInfo.sUserIPaddr);
        nIDCost := 0;
        nIPCost := 0;
        boPayCost := False;
        if nIDCostIndex >= 0 then
          nIDCost := Integer(Config.AccountCostList.Objects[nIDCostIndex]);
        if nIPCostIndex >= 0 then
        begin
          nIPCost := Integer(Config.IPaddrCostList.Objects[nIPCostIndex]);
          boPayCost := true;
        end;
      finally
        CS_DB.Leave;
      end;
      if (nIDCost >= 0) or (nIPCost >= 0) then
        UserInfo.boPayCost := true
      else
        UserInfo.boPayCost := False;
      UserInfo.nIDDay := LoWord(nIDCost);
      UserInfo.nIDHour := HiWord(nIDCost);
      UserInfo.nIPDay := LoWord(nIPCost);
      UserInfo.nIPHour := HiWord(nIPCost);
      if not UserInfo.boPayCost then
      begin
        DefMsg := MakeDefaultMsg(SM_PASSOK_SELECTSERVER, 0, 0, 0, Config.ServerNameList.Count);
      end
      else
      begin
        //MainOutMessage(Format('days:%d hours:%d ', [LoWord(nIDCost), HiWord(nIDCost)]));
        DefMsg := MakeDefaultMsg(SM_PASSOK_SELECTSERVER,
          nIDCost,
          LoWord(nIPCost),
          HiWord(nIPCost),
          Config.ServerNameList.Count);
      end;

      sServerName := GetServerListInfo;

      SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg) + EncodeString(sServerName));
      SessionAdd(Config, UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID, UserInfo.boPayCost, False);

      {nRandomNO := Random(9999);
      while nRandomNO < 1000 do begin
        nRandomNO := Random(9999);
        if nRandomNO >= 1000 then
          Break;
      end;
      UserInfo.sLoginPassWord := IntToStr(nRandomNO); // + IntToStr(Random(10)) + IntToStr(Random(10)) + IntToStr(Random(10));
      DefMsg := MakeDefaultMsg(SM_PLAYDICE, 0, MakeWord(1, 10), 0, 0);
      sInputPwd := '@@PassWord' + #13 + '请输入服务器登陆验证码：' + UserInfo.sLoginPassWord;
      SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg) + EncodeString(sInputPwd));}

    end
    else
    begin
      DefMsg := MakeDefaultMsg(SM_PASSWD_FAIL, nCode, 0, 0, 0);
      SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
    end;
  except
    MainOutMessage('TFrmMain.LoginUser');
  end;
end;

procedure GetSelGateInfo(Config: pTConfig; sServerName, sIPaddr: string; var sSelGateIP: string; var nSelGatePort: Integer);
var
  I: Integer;
  nGateIdx: Integer;
  nGateCount: Integer;
  nSelIdx: Integer;
  boSelected: Boolean;
begin
  try
    sSelGateIP := '';
    nSelGatePort := 0;
    for I := 0 to Config.nRouteCount - 1 do
    begin
      if Config.boDynamicIPMode or ((Config.GateRoute[I].sServerName = sServerName) and (Config.GateRoute[I].sPublicAddr = sIPaddr)) then
      begin
        nGateCount := 0;
        nGateIdx := 0;
        while (true) do
        begin
          if (Config.GateRoute[I].Gate[nGateIdx].sIPaddr <> '') and (Config.GateRoute[I].Gate[nGateIdx].boEnable) then
            Inc(nGateCount);
          Inc(nGateIdx);
          if nGateIdx >= 10 then
            Break;
        end;
        if nGateCount <= 0 then
          Break;

        nSelIdx := Config.GateRoute[I].nSelIdx;
        boSelected := False;
        for nGateIdx := nSelIdx + 1 to 9 do
        begin
          if (Config.GateRoute[I].Gate[nGateIdx].sIPaddr <> '') and (Config.GateRoute[I].Gate[nGateIdx].boEnable) then
          begin
            Config.GateRoute[I].nSelIdx := nGateIdx;
            boSelected := true;
            Break;
          end;
        end;
        if not boSelected then
        begin
          for nGateIdx := 0 to nSelIdx - 1 do
          begin
            if (Config.GateRoute[I].Gate[nGateIdx].sIPaddr <> '') and (Config.GateRoute[I].Gate[nGateIdx].boEnable) then
            begin
              Config.GateRoute[I].nSelIdx := nGateIdx;
              Break;
            end;
          end;
        end;
        nSelIdx := Config.GateRoute[I].nSelIdx;
        sSelGateIP := Config.GateRoute[I].Gate[nSelIdx].sIPaddr;
        nSelGatePort := Config.GateRoute[I].Gate[nSelIdx].nPort;
        Break;
      end;
    end;
  except
    MainOutMessage('TFrmMain.GetSelGateInfo');
  end;
end;

function GetServerListInfo: string;
var
  sServerInfo: string;
  I: Integer;
  sServerName: string;
  Config: pTConfig;
begin
  Config := @g_Config;
  try
    for I := 0 to Config.ServerNameList.Count - 1 do
    begin
      sServerName := Config.ServerNameList.Strings[I];
      if sServerName <> '' then
        sServerInfo := sServerInfo + sServerName + '/' + IntToStr(FrmMasSoc.ServerStatus(sServerName)) + '/';
    end;
    Result := sServerInfo;
  except
    MainOutMessage('TFrmMain.GetServerListInfo');
  end;
end;

procedure AccountSelectServer(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
var
  sServerName: string;
  DefMsg: TDefaultMessage;
  boPayCost: Boolean;
  nPayMode: Integer;
  sSelGateIP: string;
  nSelGatePort: Integer;
resourcestring
  sSelServerMsg = 'Server: %s/%s-%s:%d';
begin
  sServerName := DecodeString(sData);
  if (UserInfo.sAccount <> '') and (sServerName <> '') and IsLogin(Config, UserInfo.nSessionID) then
  begin
    GetSelGateInfo(Config, sServerName, Config.sGateIPaddr, sSelGateIP, nSelGatePort);
    if (sSelGateIP <> '') and (nSelGatePort > 0) then
    begin
      if Config.boDynamicIPMode then
        sSelGateIP := UserInfo.sGateIPaddr; //增加支动态IP
      if Config.boShowDetailMsg then
        MainOutMessage(format(sSelServerMsg, [sServerName, Config.sGateIPaddr, sSelGateIP, nSelGatePort]));
      UserInfo.boSelServer := true;

      boPayCost := False;
      nPayMode := 5;

      if UserInfo.nIDHour > 0 then
        nPayMode := 2;
      if UserInfo.nIPHour > 0 then
        nPayMode := 4;
      if UserInfo.nIPDay > 0 then
        nPayMode := 3;
      if UserInfo.nIDDay > 0 then
        nPayMode := 1;

      if FrmMasSoc.IsNotUserFull(sServerName) then
      begin
        //MainOutmessage(format('nPayMode:%d  boPayCost:%d', [nPayMode, ]));
        SessionUpdate(Config, UserInfo.nSessionID, sServerName, boPayCost);
        FrmMasSoc.SendServerMsg(SS_OPENSESSION,
          sServerName,
          UserInfo.sAccount + '/' +
          IntToStr(UserInfo.nSessionID) + '/' +
          IntToStr(Integer(UserInfo.boPayCost)) + '/' +
          IntToStr(nPayMode) + '/' +
          UserInfo.sUserIPaddr);
        DefMsg := MakeDefaultMsg(SM_SELECTSERVER_OK, UserInfo.nSessionID, 0, 0, 0);
        SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg) + EncodeString(sSelGateIP + '/' + IntToStr(nSelGatePort) + '/' + IntToStr(UserInfo.nSessionID)));
      end
      else
      begin
        UserInfo.boSelServer := False;
        SessionDel(Config, UserInfo.nSessionID);
        DefMsg := MakeDefaultMsg(SM_STARTFAIL, 0, 0, 0, 0);
        SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
      end;
    end;
  end;
end;

procedure AccountUpdateUserInfo(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
var
  UserEntry: TUserEntry;
  UserAddEntry: TUserEntryAdd;
  DBRecord: TAccountDBRecord;
  nLen: Integer;
  sUserEntryMsg: string;
  sUserAddEntryMsg: string;
  nCode: Integer;
  DefMsg: TDefaultMessage;
  n10: Integer;
begin
  try
    FillChar(UserEntry, SizeOf(TUserEntry), #0);
    FillChar(UserAddEntry, SizeOf(TUserEntryAdd), #0);
    nLen := pGetCodeMsgSize(SizeOf(TUserEntry) * 4 / 3);
    sUserEntryMsg := Copy(sData, 1, nLen);
    sUserAddEntryMsg := Copy(sData, nLen + 1, Length(sData) - nLen);
    DecodeBuffer(sUserEntryMsg, @UserEntry, SizeOf(TUserEntry));
    DecodeBuffer(sUserAddEntryMsg, @UserAddEntry, SizeOf(TUserEntryAdd));
    nCode := -1;
    if (UserInfo.sAccount = UserEntry.sAccount) and CheckAccountName(UserEntry.sAccount) then
    begin
      try
        if AccountDB.Open then
        begin
          n10 := AccountDB.Index(UserEntry.sAccount);
          if (n10 >= 0) then
          begin
            if (AccountDB.Get(n10, DBRecord) >= 0) then
            begin
              DBRecord.UserEntry := UserEntry;
              DBRecord.UserEntryAdd := UserAddEntry;
              AccountDB.Update(n10, DBRecord);
              nCode := 1;
            end;
          end
          else
            nCode := 0;
        end;
      finally
        AccountDB.Close;
      end;
    end; //0046C74B
    if nCode = 1 then
    begin
      WriteLogMsg(Config, 'upg', UserEntry, UserAddEntry);
      DefMsg := MakeDefaultMsg(SM_UPDATEID_SUCCESS, 0, 0, 0, 0);
    end
    else
    begin
      DefMsg := MakeDefaultMsg(SM_UPDATEID_FAIL, nCode, 0, 0, 0);
    end;
    SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
  except
    MainOutMessage('TFrmMain.UpdateUserInfo');
  end;
end;

procedure AccountGetBackPassword(UserInfo: pTUserInfo; sData: string);
var
  sMsg: string;
  sAccount: string;
  sQuest1: string;
  sAnswer1: string;
  sQuest2: string;
  sAnswer2: string;
  sPassword: string;
  sBirthDay: string;
  nCode: Integer;
  nIndex: Integer;
  DefMsg: TDefaultMessage;
  DBRecord: TAccountDBRecord;
begin
  sMsg := DecodeString(sData);
  sMsg := GetValidStr3(sMsg, sAccount, [#9]);
  sMsg := GetValidStr3(sMsg, sQuest1, [#9]);
  sMsg := GetValidStr3(sMsg, sAnswer1, [#9]);
  sMsg := GetValidStr3(sMsg, sQuest2, [#9]);
  sMsg := GetValidStr3(sMsg, sAnswer2, [#9]);
  sMsg := GetValidStr3(sMsg, sBirthDay, [#9]);
  //frmMain.Memo1.Lines.add(sAccount);
  nCode := 0;
  try
    if (sAccount <> '') and AccountDB.Open then
    begin
      nIndex := AccountDB.Index(sAccount);
      if (nIndex >= 0) and (AccountDB.Get(nIndex, DBRecord) >= 0) then
      begin
        if (DBRecord.nErrorCount < 5) or ((GetTickCount - DBRecord.dwActionTick) > 180000) then
        begin
          nCode := -1;
          if (DBRecord.UserEntry.sQuiz = sQuest1) then
          begin
            nCode := -3;
            if DBRecord.UserEntry.sAnswer = sAnswer1 then
            begin
              if DBRecord.UserEntryAdd.sBirthDay = sBirthDay then
              begin
                nCode := 1;
              end;
            end;
          end;
          if nCode <> 1 then
          begin
            if (DBRecord.UserEntryAdd.sQuiz2 = sQuest2) then
            begin
              nCode := -3;
              if DBRecord.UserEntryAdd.sAnswer2 = sAnswer2 then
              begin
                if DBRecord.UserEntryAdd.sBirthDay = sBirthDay then
                begin
                  nCode := 1;
                end;
              end;
            end;
          end;
          if nCode = 1 then
          begin
            sPassword := DBRecord.UserEntry.sPassword;
          end
          else
          begin
            Inc(DBRecord.nErrorCount);
            DBRecord.dwActionTick := GetTickCount();
            AccountDB.Update(nIndex, DBRecord);
          end;
        end
        else
        begin
          nCode := -2;
          if GetTickCount < DBRecord.dwActionTick then
          begin
            DBRecord.dwActionTick := GetTickCount();
            AccountDB.Update(nIndex, DBRecord);
          end;
        end;
      end;
    end;
  finally
    AccountDB.Close;
  end;
  if nCode = 1 then
  begin
    DefMsg := MakeDefaultMsg(SM_GETBACKPASSWD_SUCCESS, 0, 0, 0, 0);
    SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg) + EncodeString(sPassword));
  end
  else
  begin
    DefMsg := MakeDefaultMsg(SM_GETBACKPASSWD_FAIL, nCode, 0, 0, 0);
    SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
  end;
end;

procedure SendGateMsg(Socket: TCustomWinSocket; sSockIndex, sMsg: string);
var
  sSendMsg: string;
begin
  sSendMsg := '%' + sSockIndex + '/#' + sMsg + '!$';
  Socket.SendText(sSendMsg);
end;

function IsLogin(Config: pTConfig; nSessionID: Integer): Boolean;
var
  ConnInfo: pTConnInfo;
  I: Integer;
begin
  Result := False;
  Config.SessionList.Lock;
  try
    for I := 0 to Config.SessionList.Count - 1 do
    begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.nSessionID = nSessionID) then
      begin
        Result := true;
        Break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

function IsLogin(Config: pTConfig; sLoginID: string): Boolean;
var
  ConnInfo: pTConnInfo;
  I: Integer;
begin
  Result := False;
  Config.SessionList.Lock;
  try
    for I := 0 to Config.SessionList.Count - 1 do
    begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.sAccount = sLoginID) then
      begin
        Result := true;
        Break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure SessionKick(Config: pTConfig; sLoginID: string);
var
  ConnInfo: pTConnInfo;
  I: Integer;
begin
  Config.SessionList.Lock;
  try
    for I := 0 to Config.SessionList.Count - 1 do
    begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.sAccount = sLoginID) and not ConnInfo.boKicked then
      begin
        FrmMasSoc.SendServerMsg(SS_CLOSESESSION, ConnInfo.sServerName, ConnInfo.sAccount + '/' + IntToStr(ConnInfo.nSessionID));
        ConnInfo.dwKickTick := GetTickCount();
        ConnInfo.boKicked := true;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure SessionAdd(Config: pTConfig; sAccount, sIPaddr: string;
  nSessionID: Integer; boPayCost, boCheckOK: Boolean);
var
  ConnInfo: pTConnInfo;
begin
  New(ConnInfo);
  ConnInfo.sAccount := sAccount;
  ConnInfo.sIPaddr := sIPaddr;
  ConnInfo.nSessionID := nSessionID;
  ConnInfo.boPayCost := boPayCost;
  ConnInfo.boCheckOK := boCheckOK;
  ConnInfo.dwKickTick := GetTickCount();
  ConnInfo.dwStartTick := GetTickCount();
  ConnInfo.boKicked := False;
  Config.SessionList.Lock;
  try
    Config.SessionList.Add(ConnInfo);
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure SendGateKickMsg(Socket: TCustomWinSocket; sSockIndex: string);
var
  sSendMsg: string;
begin
  sSendMsg := '%+-' + sSockIndex + '$';
  Socket.SendText(sSendMsg);
end;

procedure SessionUpdate(Config: pTConfig; nSessionID: Integer; sServerName: string; boPayCost: Boolean);
var
  ConnInfo: pTConnInfo;
  I: Integer;
begin
  Config.SessionList.Lock;
  try
    for I := 0 to Config.SessionList.Count - 1 do
    begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.nSessionID = nSessionID) then
      begin
        ConnInfo.sServerName := sServerName;
        ConnInfo.boCheckOK := boPayCost;
        Break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure GenServerNameList(Config: pTConfig);
var
  I, II: Integer;
  boD: Boolean;
begin
  try
    Config.ServerNameList.Clear;
    for I := 0 to Config.nRouteCount - 1 do
    begin
      boD := true;
      for II := 0 to Config.ServerNameList.Count - 1 do
        if Config.ServerNameList.Strings[II] = Config.GateRoute[I].sServerName then
          boD := False;
      if boD then
        Config.ServerNameList.Add(Config.GateRoute[I].sServerName);
    end;
  except
    MainOutMessage('TFrmMain.GenServerNameList');
  end;
end;

procedure SessionClearNoPayMent(Config: pTConfig);
var
  I: Integer;
  ConnInfo: pTConnInfo;
begin
  Config.SessionList.Lock;
  try
    for I := Config.SessionList.Count - 1 downto 0 do
    begin
      ConnInfo := Config.SessionList.Items[I];
      if not ConnInfo.boKicked and not Config.boTestServer and not ConnInfo.boCheckOK then
      begin
        if (GetTickCount - ConnInfo.dwStartTick) > 60 * 60 * 1000 then
        begin
          ConnInfo.dwStartTick := GetTickCount();
          if not IsPayMent(Config, ConnInfo.sIPaddr, ConnInfo.sAccount) then
          begin
            FrmMasSoc.SendServerMsg(SS_KICKUSER, ConnInfo.sServerName, ConnInfo.sAccount + '/' + IntToStr(ConnInfo.nSessionID));
            Dispose(ConnInfo);
            Config.SessionList.Delete(I);
          end;
        end;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure LoadIPaddrCostList(Config: pTConfig; QuickList: TQuickList);
begin
  try
    CS_DB.Enter;
    Config.IPaddrCostList.Clear;
    Config.IPaddrCostList.AddStrings(QuickList);
  finally
    CS_DB.Leave;
  end;
end;

procedure LoadAccountCostList(Config: pTConfig; QuickList: TQuickList);
begin
  try
    CS_DB.Enter;
    Config.AccountCostList.Clear;
    Config.AccountCostList.AddStrings(QuickList);
  finally
    CS_DB.Leave;
  end;
end;

procedure TFrmMain.Panel2DblClick(Sender: TObject);
begin
  MainOutMessage(GetServerListInfo)
end;

procedure TFrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  wIdent: Word;
  Config: pTConfig;
begin
  Config := @g_Config;
  wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    GS_QUIT:
      begin
        Config.boRemoteClose := true;
        Close();
      end;
    GS_USERACCOUNT:
      begin
        GameCenterGetUserAccount(sData);
      end;
    GS_CHANGEACCOUNTINFO: GameCenterChangeAccountInfo(sData);
  end;
end;

procedure TFrmMain.GameCenterGetUserAccount(sData: string);
var
  DBRecord: TAccountDBRecord;
  nIndex: Integer;
  nCode: Integer;
  DefMsg: TDefaultMessage;
begin
  try
    nCode := -1;
    if AccountDB.Open then
    begin
      nIndex := AccountDB.Index(sData);
      if (nIndex >= 0) and (AccountDB.Get(nIndex, DBRecord) >= 0) then
        nCode := 1;
    end;
  finally
    AccountDB.Close;
  end;
  if nCode > 0 then
  begin
    DefMsg := MakeDefaultMsg(0, nCode, 0, 0, 0);
    SendGameCenterMsg(SG_USERACCOUNT, EncodeMessage(DefMsg) + EncodeBuffer(@DBRecord, SizeOf(DBRecord)));
  end
  else
  begin
    DefMsg := MakeDefaultMsg(SG_USERACCOUNTNOTFOUND, nCode, 0, 0, 0);
    SendGameCenterMsg(SG_USERACCOUNT, EncodeMessage(DefMsg));
  end;
end;

procedure TFrmMain.GameCenterChangeAccountInfo(sData: string);
var
  NewRecord, DBRecord: TAccountDBRecord;
  DefMsg: TDefaultMessage;
  sDefMsg: string;
  nCode, nIndex: Integer;
begin
  if Length(sData) < DEFBLOCKSIZE then
    Exit;
  sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
  sData := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
  DefMsg := DecodeMessage(sDefMsg);
  DecodeBuffer(sData, @NewRecord, SizeOf(NewRecord));
  nCode := -1;
  try
    if AccountDB.Open then
    begin
      nIndex := AccountDB.Index(NewRecord.UserEntry.sAccount);
      if (nIndex >= 0) and (AccountDB.Get(nIndex, DBRecord) >= 0) then
      begin
        if DBRecord.UserEntry.sAccount = NewRecord.UserEntry.sAccount then
        begin
          DBRecord.nErrorCount := 0;
          DBRecord.dwActionTick := 0;
          DBRecord.UserEntry := NewRecord.UserEntry;
          DBRecord.UserEntryAdd := NewRecord.UserEntryAdd;
          AccountDB.Update(nIndex, DBRecord);
          nCode := 1;
        end
        else
        begin
          nCode := 2;
        end;
      end;
    end;
  finally
    AccountDB.Close;
  end;
  DefMsg := MakeDefaultMsg(0, nCode, 0, 0, 0);
  SendGameCenterMsg(SG_USERACCOUNTCHANGESTATUS, EncodeMessage(DefMsg));
end;

procedure SaveContLogMsg(Config: pTConfig; sLogMsg: string);
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  sLogDir, sLogFileName: string;
  LogFile: TextFile;
begin
  if sLogMsg = '' then
    Exit;

  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  if not DirectoryExists(Config.sCountLogDir) then
  begin
    CreateDir(Config.sCountLogDir);
  end;
  sLogDir := Config.sCountLogDir + IntToStr(Year) + '-' + IntToStr2(Month);
  if not DirectoryExists(sLogDir) then
  begin
    CreateDirectory(PChar(sLogDir), nil);
  end;
  sLogFileName := sLogDir + '\' + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day) + '.txt';
  AssignFile(LogFile, sLogFileName);
  if not FileExists(sLogFileName) then
    Rewrite(LogFile)
  else
    Append(LogFile);
  sLogMsg := sLogMsg + #9 + TimeToStr(Time);
  Writeln(LogFile, sLogMsg);
  CloseFile(LogFile);
end;

procedure WriteLogMsg(Config: pTConfig; sType: string; var UserEntry: TUserEntry; var UserAddEntry: TUserEntryAdd);
var
  Year, Month, Day: Word;
  sLogDir, sLogFileName: string;
  LogFile: TextFile;
  sLogFormat, sLogMsg: string;
begin
  DecodeDate(Date, Year, Month, Day);
  if not DirectoryExists(Config.sChrLogDir) then
    CreateDir(Config.sChrLogDir);
  sLogDir := Config.sChrLogDir + IntToStr(Year) + '-' + IntToStr2(Month);
  if not DirectoryExists(sLogDir) then
    CreateDirectory(PChar(sLogDir), nil);
  sLogFileName := sLogDir + '\Id_' + IntToStr2(Day) + '.log';
  AssignFile(LogFile, sLogFileName);
  if not FileExists(sLogFileName) then
    Rewrite(LogFile)
  else
    Append(LogFile);
  sLogFormat := '*%s*'#9'%s'#9'"%s"'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'[%s]';
  sLogMsg := format(sLogFormat, [sType,
    UserEntry.sAccount,
      UserEntry.sPassword,
      UserEntry.sUserName,
      UserEntry.sSSNo,
      UserEntry.sQuiz,
      UserEntry.sAnswer,
      UserEntry.sEMail,
      UserAddEntry.sQuiz2,
      UserAddEntry.sAnswer2,
      UserAddEntry.sBirthDay,
      UserAddEntry.sMobilePhone,
      TimeToStr(Now)]);
  //sLogMsg := UserAddEntry.sQuiz2 + UserAddEntry.sAnswer2 + UserAddEntry.sBirthDay + UserAddEntry.sMobilePhone + '[' + TimeToStr(Now) + ']';
  Writeln(LogFile, sLogMsg);
  CloseFile(LogFile);
end;

procedure StartService(Config: pTConfig);
begin
  InitializeConfig(Config);
  LoadConfig(Config);
  Config.sSQLString := 'Provider=SQLNCLI.1;Password=' + g_Config.sSQLPassword + ';Persist Security Info=True;User ID=' + g_Config.sSQLUserName + ';Initial Catalog=' + g_Config.sSQLDatabase + ';Data Source=' + g_Config.sSQLHost;
end;

procedure StopService(Config: pTConfig);
begin
  UnInitializeConfig(Config);
end;

procedure InitializeConfig(Config: pTConfig);
resourcestring
  sConfigFile = '.\Logsrv.ini';
begin
  Config.IniConf := TIniFile.Create(sConfigFile);
  InitializeCriticalSection(Config.GateCriticalSection);
end;

procedure UnInitializeConfig(Config: pTConfig);
begin
  Config.IniConf.Free;
  DeleteCriticalSection(Config.GateCriticalSection);
end;

procedure LoadConfig(Config: pTConfig);

  function LoadConfigString(sSection, sIdent, sDefault: string): string;
  var
    sString: string;
  begin
    sString := Config.IniConf.ReadString(sSection, sIdent, '');
    if sString = '' then
    begin
      Config.IniConf.WriteString(sSection, sIdent, sDefault);
      Result := sDefault;
    end
    else
    begin
      Result := sString;
    end;
  end;

  function LoadConfigInteger(sSection, sIdent: string; nDefault: Integer): Integer;
  var
    nLoadInteger: Integer;
  begin
    nLoadInteger := Config.IniConf.ReadInteger(sSection, sIdent, -1);
    if nLoadInteger < 0 then
    begin
      Config.IniConf.WriteInteger(sSection, sIdent, nDefault);
      Result := nDefault;
    end
    else
    begin
      Result := nLoadInteger;
    end;
  end;

  function LoadConfigBoolean(sSection, sIdent: string; boDefault: Boolean): Boolean;
  var
    nLoadInteger: Integer;
  begin
    nLoadInteger := Config.IniConf.ReadInteger(sSection, sIdent, -1);
    if nLoadInteger < 0 then
    begin
      Config.IniConf.WriteBool(sSection, sIdent, boDefault);
      Result := boDefault;
    end
    else
    begin
      Result := nLoadInteger = 1;
    end;
  end;
resourcestring
  sSectionServer = 'Server';
  sSectionDB = 'DB';
  sIdentDBServer = 'DBServer';
  sIdentFeeServer = 'FeeServer';
  sIdentLogServer = 'LogServer';
  sIdentGateAddr = 'GateAddr';
  sIdentGatePort = 'GatePort';
  sIdentServerAddr = 'ServerAddr';
  sIdentServerPort = 'ServerPort';
  sIdentMonAddr = 'MonAddr';
  sIdentMonPort = 'MonPort';
  sIdentDBSPort = 'DBSPort';
  sIdentFeePort = 'FeePort';
  sIdentLogPort = 'LogPort';
  sIdentReadyServers = 'ReadyServers';
  sIdentTestServer = 'TestServer';
  sIdentDynamicIPMode = 'DynamicIPMode';
  sEnableMakingID = 'EnableMakingID';
  sEnableGetbackPassword = 'EnableGetbackPassword';
  sAutoClear = 'AutoClear';
  sAutoClearTime = 'AutoClearTime';
  sChrLogDir = 'IdLogDir';
  sIdentIdDir = 'IdDir';
  sIdentWebLogDir = 'WebLogDir';
  sIdentCountLogDir = 'CountLogDir';
  sIdentFeedIDList = 'FeedIDList';
  sIdentFeedIPList = 'FeedIPList';
  sAllowChangePassword = 'AllowChangePassword';
begin
  g_boCloseLoginGate := LoadConfigBoolean(sSectionServer, 'CloseLoginGate', g_boCloseLoginGate);
  g_nCloseLoginGateTime := LoadConfigInteger(sSectionServer, 'CloseLoginGateTime', g_nCloseLoginGateTime);

  Config.CLPort := LoadConfigInteger(sSectionServer, 'CLPort', Config.CLPort);
  Config.CLPwd := LoadConfigInteger(sSectionServer, 'CLPwd', Config.CLPwd);
  Config.CLOpen := LoadConfigBoolean(sSectionServer, 'CLOpen', Config.CLOpen);

  Config.sSQLHost := LoadConfigString('SqlConfig', 'SqlServerAddress', Config.sSQLHost);
  Config.sSQLDatabase := LoadConfigString('SqlConfig', 'SqlDataBase', Config.sSQLDatabase);
  Config.sSQLUserName := LoadConfigString('SqlConfig', 'SqlAccount', Config.sSQLUserName);
  Config.sSQLPassword := LoadConfigString('SqlConfig', 'SqlPassWord', Config.sSQLPassword);

  Config.sDBServer := LoadConfigString(sSectionServer, sIdentDBServer, Config.sDBServer);
  Config.sFeeServer := LoadConfigString(sSectionServer, sIdentFeeServer, Config.sFeeServer);
  Config.sLogServer := LoadConfigString(sSectionServer, sIdentLogServer, Config.sLogServer);

  Config.sGateAddr := LoadConfigString(sSectionServer, sIdentGateAddr, Config.sGateAddr);
  Config.nGatePort := LoadConfigInteger(sSectionServer, sIdentGatePort, Config.nGatePort);
  Config.sServerAddr := LoadConfigString(sSectionServer, sIdentServerAddr, Config.sServerAddr);
  Config.nServerPort := LoadConfigInteger(sSectionServer, sIdentServerPort, Config.nServerPort);
  Config.sMonAddr := LoadConfigString(sSectionServer, sIdentMonAddr, Config.sMonAddr);
  Config.nMonPort := LoadConfigInteger(sSectionServer, sIdentMonPort, Config.nMonPort);

  Config.nDBSPort := LoadConfigInteger(sSectionServer, sIdentDBSPort, Config.nDBSPort);
  Config.nFeePort := LoadConfigInteger(sSectionServer, sIdentFeePort, Config.nFeePort);
  Config.nLogPort := LoadConfigInteger(sSectionServer, sIdentLogPort, Config.nLogPort);

  Config.dwAddNewUserTick := LoadConfigInteger(sSectionServer, 'AddNewUserTick', Config.dwAddNewUserTick);
  Config.dwChgPassWordTick := LoadConfigInteger(sSectionServer, 'ChgPassWordTick', Config.dwChgPassWordTick);
  Config.dwUpdateUserInfoTick := LoadConfigInteger(sSectionServer, 'UpdateUserInfoTick', Config.dwUpdateUserInfoTick);
  Config.GetBackPasswordTick := LoadConfigInteger(sSectionServer, 'BackPasswordTick', Config.GetBackPasswordTick);
  Config.nLockIdTick := LoadConfigInteger(sSectionServer, 'UnLockIdTick', Config.nLockIdTick);

  Config.nReadyServers := LoadConfigInteger(sSectionServer, sIdentReadyServers, Config.nReadyServers);
  Config.boEnableMakingID := LoadConfigBoolean(sSectionServer, sEnableMakingID, Config.boEnableMakingID);
  Config.boDynamicIPMode := LoadConfigBoolean(sSectionServer, sIdentDynamicIPMode, Config.boDynamicIPMode);
  Config.boTestServer := LoadConfigBoolean(sSectionServer, sIdentTestServer, Config.boTestServer);
  Config.boGetbackPassword := LoadConfigBoolean(sSectionServer, sEnableGetbackPassword, Config.boGetbackPassword);
  Config.boAutoClear := LoadConfigBoolean(sSectionServer, sAutoClear, Config.boAutoClear);
  Config.dwAutoClearTime := LoadConfigInteger(sSectionServer, sAutoClearTime, Config.dwAutoClearTime);
  Config.boAllowChangePassword := LoadConfigBoolean(sSectionServer, sAllowChangePassword, Config.boAllowChangePassword);

  Config.sIdDir := LoadConfigString(sSectionDB, sIdentIdDir, Config.sIdDir);
  Config.sWebLogDir := LoadConfigString(sSectionDB, sIdentWebLogDir, Config.sWebLogDir);
  Config.sCountLogDir := LoadConfigString(sSectionDB, sIdentCountLogDir, Config.sCountLogDir);
  Config.sChrLogDir := LoadConfigString(sSectionDB, sChrLogDir, Config.sChrLogDir);
  Config.sFeedIDList := LoadConfigString(sSectionDB, sIdentFeedIDList, Config.sFeedIDList);
  Config.sFeedIPList := LoadConfigString(sSectionDB, sIdentFeedIPList, Config.sFeedIPList);

end;

procedure TFrmMain.MENU_HELP_ABOUTClick(Sender: TObject);
begin
  Memo1.Lines.Add(sPrograme + sOwen);
  Memo1.Lines.Add(sVersion);
  Memo1.Lines.Add(sWebSite);
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  frmGeneralConfig := TfrmGeneralConfig.Create(nil);
  frmGeneralConfig.Open;
  frmGeneralConfig.Free;
end;

procedure TFrmMain.C1Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TFrmMain.DecodeTimerTimer(Sender: TObject);
var
  I: Integer;
  dwProcessReviceMsgLimiTick: LongWord;
  UserData: pTSendUserData;
  tUserData: TSendUserData;
begin
  dwProcessReviceMsgLimiTick := GetTickCount();
  while (true) do
  begin
    if ReviceMsgList.Count <= 0 then
      Break;
    UserData := ReviceMsgList.Items[0];
    ReviceMsgList.Delete(0);
    ProcessUserPacket(UserData);
    Dispose(UserData);
    if (GetTickCount - dwProcessReviceMsgLimiTick) > 30 then
      Break;
  end;
end;

procedure TFrmMain.GameCenterChangeAccountInfo2(sData: string; Socket: TCustomWinSocket);
var
  NewRecord, DBRecord: TAccountDBRecord;
  DefMsg: TDefaultMessage;
  sDefMsg: string;
  nCode, nIndex: Integer;
begin
  if Length(sData) < DEFBLOCKSIZE then
    Exit;
  DecodeBuffer(sData, @NewRecord, SizeOf(NewRecord));
  nCode := -1;
  try
    if AccountDB.Open then
    begin
      nIndex := AccountDB.Index(NewRecord.UserEntry.sAccount);
      if (nIndex >= 0) and (AccountDB.Get(nIndex, DBRecord) >= 0) then
      begin
        if DBRecord.UserEntry.sAccount = NewRecord.UserEntry.sAccount then
        begin
          DBRecord.nErrorCount := 0;
          DBRecord.dwActionTick := 0;
          DBRecord.UserEntry := NewRecord.UserEntry;
          DBRecord.UserEntryAdd := NewRecord.UserEntryAdd;
          AccountDB.Update(nIndex, DBRecord);
          nCode := 1;
        end
        else
        begin
          nCode := 2;
        end;
      end;
    end;
  finally
    AccountDB.Close;
  end;
  DefMsg := MakeDefaultMsg(SG_USERACCOUNTCHANGESTATUS, nCode, 0, 0, 0);
  Socket.SendText('#' + EncodeMessage(DefMsg) + '!');
end;

procedure TFrmMain.GameCenterGetUserAccount2(sData: string; Socket: TCustomWinSocket);
var
  DBRecord: TAccountDBRecord;
  nIndex: Integer;
  nCode: Integer;
  DefMsg: TDefaultMessage;
begin
  try
    nCode := -1;
    if AccountDB.Open then
    begin
      nIndex := AccountDB.Index(sData);
      if (nIndex >= 0) and (AccountDB.Get(nIndex, DBRecord) >= 0) then
        nCode := 1;
    end;
  finally
    AccountDB.Close;
  end;
  if nCode > 0 then
  begin
    DefMsg := MakeDefaultMsg(SG_USERACCOUNT, nCode, 0, 0, 0);
    Socket.SendText('#' + EncodeMessage(DefMsg) + EncodeBuffer(@DBRecord, SizeOf(DBRecord)) + '!');
  end
  else
  begin
    DefMsg := MakeDefaultMsg(SG_USERACCOUNTNOTFOUND, nCode, 0, 0, 0);
    Socket.SendText('#' + EncodeMessage(DefMsg) + '!');
  end;
end;

procedure TFrmMain.ProcessUserPacket(UserData: pTSendUserData);
var
  sMsg, sData, sDefMsg, sDataMsg, sDataText, sHumName: string;
  Buffer: PChar;
  nDataLen, n14: Integer;
  DefMsg: TDefaultMessage;
begin
  n14 := 0;
  if (UserData.nSocketIdx >= 0) and (UserData.nSocketIdx < GATEMAXSESSION) then
  begin
    if (UserData.nSocketHandle = SessionArray[UserData.nSocketIdx].nSckHandle) and (SessionArray[UserData.nSocketIdx].nPacketErrCount < 15) and (SessionArray[UserData.nSocketIdx].Socket <> nil) then
    begin
      sMsg := SessionArray[UserData.nSocketIdx].sSocData + UserData.sMsg;
      while (true) do
      begin
        sData := '';
        sMsg := ArrestStringEx(sMsg, '#', '!', sData);
        //MainOutMessage(format('[远程ID管理] %s', [sData]));
        nDataLen := Length(sData);
        if nDataLen > 1 then
        begin
          if (nDataLen >= DEFBLOCKSIZE) then
          begin
            if nDataLen = DEFBLOCKSIZE then
            begin
              sDefMsg := sData;
              sDataMsg := '';
            end
            else
            begin
              sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
              sDataMsg := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
            end;
            DefMsg := DecodeMessage(sDefMsg);
            if DefMsg.Recog <> g_Config.CLPwd then
            begin
              MainOutMessage(format('[远程ID管理] %s 密码错误！', [UserData.sRemoteAddress]));
              SessionArray[UserData.nSocketIdx].Socket.Close;
              Break;
            end;

            if (sDataMsg <> '') then
            begin
              if DefMsg.Ident = GS_USERACCOUNT then
              begin
                sDataText := DecodeString(sDataMsg);
                //MainOutMessage(format('[远程ID管理] 获取ID信息：%s', [sDataText]));
                if (sDataText <> '') and (Length(sDataText) <= 10) then
                begin
                  GameCenterGetUserAccount2(sDataText, SessionArray[UserData.nSocketIdx].Socket);
                end;
              end
              else if DefMsg.Ident = GS_CHANGEACCOUNTINFO then
              begin
                GameCenterChangeAccountInfo2(sDataMsg, SessionArray[UserData.nSocketIdx].Socket);
              end;

            end;
          end;
        end
        else if n14 >= 1 then
          sMsg := ''
        else
          Inc(n14);
        if TagCount(sMsg, '!') < 1 then
          Break;
      end;
      SessionArray[UserData.nSocketIdx].sSocData := sMsg;
    end
    else
      SessionArray[UserData.nSocketIdx].sSocData := '';
  end;
end;

end.
