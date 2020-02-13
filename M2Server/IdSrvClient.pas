unit IdSrvClient;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, ExtCtrls, IniFiles,
  WinSock, Grobal2, MudUtil, M2Share, D7ScktComp;

type
  TFrmIDSoc = class(TForm)
    IDSocket: TClientSocket;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IDSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure IDSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure IDSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure IDSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  private
    IDSrvAddr: string;
    IDSrvPort: Integer;
    procedure GetPasswdSuccess(sData: string);
    procedure GetCancelAdmission(sData: string);
    procedure GetCancelAdmissionA(sData: string);
    procedure SetTotalHumanCount(sData: string);
    procedure GetServerLoad(sData: string);
    procedure NewSession(sAccount, sIPaddr: string; nSessionID, nPayMent, nPayMode: Integer);
    procedure ClearSession();
    // procedure ClearEmptySession();                    
    procedure SendSocket(sSENDMSG: string);
    { Private declarations }
  public
    m_SessionList: TGList;
    procedure Initialize();
    procedure Run();

    procedure SendOnlineHumCountMsg(nCount: Integer);
    procedure SendHumanLogOutMsg(sUserID: string; nID: Integer);
    //procedure SendHumanLogOutMsgA(sUserID: string; nID: Integer);

    function GetAdmission(sAccount, sIPaddr: string; nSessionID: Integer; var nPayMode: Integer; var nPayMent: Integer): pTSessInfo;
    function GetSessionCount(): Integer;
    procedure GetSessionList(List: TList);
    procedure SendLogonCostMsg(sAccount: string; nTime: Integer);
    procedure DelSession(nSessionID: Integer);
    procedure Close();
    { Public declarations }
  end;

procedure IDSocketThread(ThreadInfo: pTThreadInfo); stdcall;
var
  FrmIDSoc: TFrmIDSoc;

implementation

uses HUtil32;

{$R *.dfm}

procedure TFrmIDSoc.FormCreate(Sender: TObject);
var
  Conf: TIniFile;
begin
  IDSocket.Host := '';
  if FileExists(sConfigFileName) then
  begin
    Conf := TIniFile.Create(sConfigFileName);
    if Conf <> nil then
    begin
      IDSrvAddr := Conf.ReadString('Server', 'IDSAddr', '127.0.0.1');
      IDSrvPort := Conf.ReadInteger('Server', 'IDSPort', 5600);
      Conf.Free;
    end;
  end
  else
    ShowMessage('配置文件' + sConfigFileName + '未找到');
  m_SessionList := TGList.Create;
  g_Config.boIDSocketConnected := False;
end;

procedure TFrmIDSoc.FormDestroy(Sender: TObject);
begin
  ClearSession();
  m_SessionList.Free;
end;

procedure TFrmIDSoc.Timer1Timer(Sender: TObject);
begin
  if not IDSocket.Active then
    IDSocket.Active := True;
end;

procedure TFrmIDSoc.IDSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmIDSoc.IDSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  EnterCriticalSection(g_Config.UserIDSection);
  try
    g_Config.sIDSocketRecvText := g_Config.sIDSocketRecvText + Socket.ReceiveText;
  finally
    LeaveCriticalSection(g_Config.UserIDSection);
  end;
end;

procedure TFrmIDSoc.Initialize();
begin
  IDSocket.Active := False;
  IDSocket.Address := IDSrvAddr;
  IDSocket.Port := IDSrvPort;
  IDSocket.Active := True;
  Timer1.Enabled := True;
end;
{$IF IDSOCKETMODE = TIMERENGINE}

procedure TFrmIDSoc.SendSocket(sSENDMSG: string);
begin
  if IDSocket.Socket.Connected then
  begin
    IDSocket.Socket.SendText(sSENDMSG);
  end;
end;
{$ELSE}

procedure TFrmIDSoc.SendSocket(sSENDMSG: string);
var
  boSendData: Boolean;
  Config: pTConfig;
  ThreadInfo: pTThreadInfo;
  timeout: TTimeVal;
  writefds: TFDSet;
  nRet: Integer;
  s: TSocket;
begin
  Config := @g_Config;
  ThreadInfo := @g_Config.DBSOcketThread;
  s := Config.IDSocket;
  boSendData := False;
  while True do
  begin
    if not boSendData then
      Sleep(1)
    else
      Sleep(0);
    boSendData := False;
    ThreadInfo.dwRunTick := GetTickCount();
    ThreadInfo.boActived := True;
    //ThreadInfo.nRunFlag := 128;

    ThreadInfo.nRunFlag := 129;
    timeout.tv_sec := 0;
    timeout.tv_usec := 20;
    writefds.fd_count := 1;
    writefds.fd_array[0] := s;

    nRet := select(0, nil, @writefds, nil, @timeout);
    if nRet = SOCKET_ERROR then
    begin
      nRet := WSAGetLastError();
      Config.nIDSocketWSAErrCode := nRet - WSABASEERR;
      Inc(Config.nIDSocketErrorCount);
      if nRet = WSAEWOULDBLOCK then
        Continue;
      if Config.IDSocket = INVALID_SOCKET then
        Break;
      Config.IDSocket := INVALID_SOCKET;
      Sleep(100);
      Config.boIDSocketConnected := False;
      Break;
    end;
    if nRet <= 0 then
      Continue;
    boSendData := True;
    nRet := send(s, sSENDMSG[1], Length(sSENDMSG), 0);
    if nRet = SOCKET_ERROR then
    begin
      Inc(Config.nIDSocketErrorCount);
      Config.nIDSocketWSAErrCode := WSAGetLastError - WSABASEERR;
      Continue;
    end;
    Inc(Config.nDBSocketSendLen, nRet);
    Break;
  end;
end;
{$IFEND}

procedure TFrmIDSoc.SendHumanLogOutMsg(sUserID: string; nID: Integer); //0048D448
resourcestring
  sFormatMsg = '(%d/%s/%d)';
begin
  {m_SessionList.Lock;
  try
    for i := 0 to m_SessionList.Count - 1 do begin
      SessInfo := m_SessionList.Items[i];
      if (SessInfo.nSessionID = nID) and (SessInfo.sAccount = sUserID) then begin
        //SessInfo.dwCloseTick:=GetTickCount();
        //SessInfo.boClosed:=True;
        break;
      end;
    end;
  finally
    m_SessionList.UnLock;
  end;}
  if GetSessionCount() > 0 then
    SendSocket(Format(sFormatMsg, [SS_SOFTOUTSESSION, sUserID, nID]));
end;

{procedure TFrmIDSoc.SendHumanLogOutMsgA(sUserID: string; nID: Integer);
var
  i                         : Integer;
  SessInfo                  : pTSessInfo;
resourcestring
  sFormatMsg                = '(%d/%s/%d)';
begin
  if GetSessionCount() > 0 then
    SendSocket(Format(sFormatMsg, [SS_CLOSESESSIONA, sUserID, nID]));
end;}

procedure TFrmIDSoc.SendLogonCostMsg(sAccount: string; nTime: Integer);
resourcestring
  sFormatMsg = '(%d/%s/%d)';
begin
  SendSocket(Format(sFormatMsg, [SS_LOGINCOST, sAccount, nTime]));
end;

procedure TFrmIDSoc.SendOnlineHumCountMsg(nCount: Integer);
resourcestring
  sFormatMsg = '(%d/%s/%d/%d)';
begin
  SendSocket(Format(sFormatMsg, [SS_SERVERINFO, g_Config.sServerName, g_nServerIndex, nCount]));
end;

procedure TFrmIDSoc.Run();
var
  sSocketText: string;
  sData: string;
  sBody: string;
  sCode: string;
  Config: pTConfig;
resourcestring
  sExceptionMsg = '[Exception] TFrmIdSoc::DecodeSocStr';
begin
  Config := @g_Config;
  EnterCriticalSection(Config.UserIDSection);
  try
    if Pos(')', Config.sIDSocketRecvText) <= 0 then
      Exit;
    sSocketText := Config.sIDSocketRecvText;
    Config.sIDSocketRecvText := '';
  finally
    LeaveCriticalSection(Config.UserIDSection);
  end;
  try
    while (True) do
    begin
      sSocketText := ArrestStringEx(sSocketText, '(', ')', sData);
      if sData = '' then
        Break;
      sBody := GetValidStr3(sData, sCode, ['/']);
      case Str_ToInt(sCode, 0) of
        SS_OPENSESSION: GetPasswdSuccess(sBody);
        SS_CLOSESESSION: GetCancelAdmission(sBody);
        SS_KEEPALIVE: SetTotalHumanCount(sBody);
        SS_KICKUSER: GetCancelAdmissionA(sBody);
        SS_SERVERLOAD: GetServerLoad(sBody);
      end;
      if Pos(')', sSocketText) <= 0 then
        Break;
    end;
    EnterCriticalSection(Config.UserIDSection);
    try
      if (sSocketText <> '') and (Config.sIDSocketRecvText <> '') then //0325
        Config.sIDSocketRecvText := sSocketText + Config.sIDSocketRecvText;
    finally
      LeaveCriticalSection(Config.UserIDSection);
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
  {if GetTickCount - dwClearEmptySessionTick > 10000 then begin
    dwClearEmptySessionTick := GetTickCount();
    ClearEmptySession();
  end;}
  //{$IF (DEBUG = 0) and (SoftVersion <> VERDEMO)}
  //  if IsDebuggerPresent then
  //    Application.Terminate;
  //{$IFEND}
end;

procedure TFrmIDSoc.GetPasswdSuccess(sData: string); //0048D9B4
var
  sAccount: string;
  sSessionID: string;
  sPayCost: string;
  sIPaddr: string;
  sPayMode: string;
resourcestring
  sExceptionMsg = '[Exception] TFrmIdSoc::GetPasswdSuccess';
begin
  try
    sData := GetValidStr3(sData, sAccount, ['/']);
    sData := GetValidStr3(sData, sSessionID, ['/']);
    sData := GetValidStr3(sData, sPayCost, ['/']);
    sData := GetValidStr3(sData, sPayMode, ['/']);
    sData := GetValidStr3(sData, sIPaddr, ['/']);
    NewSession(sAccount, sIPaddr, Str_ToInt(sSessionID, 0), Str_ToInt(sPayCost, 0), Str_ToInt(sPayMode, 0));
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

procedure TFrmIDSoc.GetCancelAdmission(sData: string);
var
  SC, sSessionID: string;
resourcestring
  sExceptionMsg = '[Exception] TFrmIdSoc::GetCancelAdmission';
begin
  try
    sSessionID := GetValidStr3(sData, SC, ['/']);
    DelSession(Str_ToInt(sSessionID, 0));
  except
    on E: Exception do
    begin
      MainOutMessageAPI(sExceptionMsg);
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

procedure TFrmIDSoc.NewSession(sAccount, sIPaddr: string; nSessionID, nPayMent, nPayMode: Integer); //0048DC44
var
  SessInfo: pTSessInfo;
begin
  New(SessInfo);
  SessInfo.sAccount := sAccount;
  SessInfo.sIPaddr := sIPaddr;
  SessInfo.nSessionID := nSessionID;
  SessInfo.nPayMent := nPayMent;
  SessInfo.nPayMode := nPayMode;
  SessInfo.nSessionStatus := 0;
  SessInfo.dwStartTick := GetTickCount();
  SessInfo.dwActiveTick := GetTickCount();
  SessInfo.nRefCount := 1;
  m_SessionList.Lock;
  try
    m_SessionList.Add(SessInfo);
  finally
    m_SessionList.UnLock;
  end;
end;

procedure TFrmIDSoc.DelSession(nSessionID: Integer);
var
  i: Integer;
  sAccount: string;
  SessInfo: pTSessInfo;
resourcestring
  sExceptionMsg = '[Exception] FrmIdSoc::DelSession %d';
begin
  try
    sAccount := '';
    m_SessionList.Lock;
    try
      for i := 0 to m_SessionList.Count - 1 do
      begin
        SessInfo := m_SessionList.Items[i];
        if SessInfo.nSessionID = nSessionID then
        begin
          sAccount := SessInfo.sAccount;
          m_SessionList.Delete(i);
          Dispose(SessInfo);
          Break;
        end;
      end;
    finally
      m_SessionList.UnLock;
    end;
    if sAccount <> '' then
      RunSocket.KickUser(sAccount, nSessionID);
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [0]));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;
{
procedure TFrmIDSoc.ClearEmptySession;
var
  i: Integer;
  SessInfo: pTSessInfo;
begin
  m_SessionList.Lock;
  try
    for i := m_SessionList.Count - 1 downto 0 do
    begin
      SessInfo := m_SessionList.Items[i];
      if SessInfo.nRefCount <= 0 then
      begin
        Dispose(SessInfo);
        m_SessionList.Delete(i);
        Continue;
      end;
      {if GetTickCount - SessInfo.dwActiveTick > 10 * 60 * 1000 then begin
        Dispose(SessInfo);
        m_SessionList.Delete(I);
        Continue;
      end;
    end;
  finally
    m_SessionList.UnLock;
  end;
end;
 }
procedure TFrmIDSoc.ClearSession;
var
  i: Integer;
begin
  m_SessionList.Lock;
  try
    for i := 0 to m_SessionList.Count - 1 do
      Dispose(pTSessInfo(m_SessionList.Items[i]));
    m_SessionList.Clear;
  finally
    m_SessionList.UnLock;
  end;
end;

function TFrmIDSoc.GetAdmission(sAccount, sIPaddr: string; nSessionID: Integer; var nPayMode: Integer; var nPayMent: Integer): pTSessInfo; //0048DE80
var
  i: Integer;
  SessInfo: pTSessInfo;
  boFound: Boolean;
resourcestring
  sGetFailMsg = '[非法登录] 全局会话验证失败(%s/%s/%d)';
begin
  boFound := False;
  Result := nil;
  nPayMent := 0;
  nPayMode := 0;
  m_SessionList.Lock;
  try
    for i := 0 to m_SessionList.Count - 1 do
    begin
      SessInfo := m_SessionList.Items[i];
      if (SessInfo.nSessionID = nSessionID) and (SessInfo.sAccount = sAccount) {and (SessInfo.sIPaddr = sIPaddr)} then
      begin
        //if SessInfo.nSessionStatus <> 0 then break; SessInfo.nSessionStatus:=1;
        case SessInfo.nPayMent of
          2: nPayMent := 3;
          1: nPayMent := 2;
          0: nPayMent := 1;
        end;
        Result := SessInfo;
        nPayMode := SessInfo.nPayMode;
        boFound := True;
        Break;
      end;
    end;
  finally
    m_SessionList.UnLock;
  end;
  if g_Config.boViewAdmissionFailure and not boFound then
    MainOutMessageAPI(Format(sGetFailMsg, [sAccount, sIPaddr, nSessionID]));
end;

procedure TFrmIDSoc.SetTotalHumanCount(sData: string);
begin
  g_nTotalHumCount := Str_ToInt(sData, 0)
end;

procedure TFrmIDSoc.GetCancelAdmissionA(sData: string);
var
  nSessionID: Integer;
  sSessionID: string;
  sAccount: string;
resourcestring
  sExceptionMsg = '[Exception] FrmIdSoc::GetCancelAdmissionA';
begin
  try
    sSessionID := GetValidStr3(sData, sAccount, ['/']);
    nSessionID := Str_ToInt(sSessionID, 0);
    if not g_Config.boTestServer then
    begin
      UserEngine.HumanExpire(sAccount);
      DelSession(nSessionID);
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

procedure TFrmIDSoc.GetServerLoad(sData: string); //0048E174
var
  SC, s10, s14, s18, s1C: string;
begin
  sData := GetValidStr3(sData, SC, ['/']);
  sData := GetValidStr3(sData, s10, ['/']);
  sData := GetValidStr3(sData, s14, ['/']);
  sData := GetValidStr3(sData, s18, ['/']);
  sData := GetValidStr3(sData, s1C, ['/']);
  nCurrentMonthly := Str_ToInt(SC, 0);
  nLastMonthlyTotalUsage := Str_ToInt(s10, 0);
  nTotalTimeUsage := Str_ToInt(s14, 0);
  nGrossTotalCnt := Str_ToInt(s18, 0);
  nGrossResetCnt := Str_ToInt(s1C, 0);
end;

procedure TFrmIDSoc.IDSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  g_Config.boIDSocketConnected := True;
  MainOutMessageAPI('登录服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')连接成功...');
  SendOnlineHumCountMsg(UserEngine.OnlinePlayObject);
end;

procedure TFrmIDSoc.IDSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  if g_Config.boIDSocketConnected then
  begin
    ClearSession();
    g_Config.boIDSocketConnected := False;
    MainOutMessageAPI('登录服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')断开连接...');
  end;
end;
{$IF IDSOCKETMODE = TIMERENGINE}

procedure TFrmIDSoc.Close;
begin
  Timer1.Enabled := False;
  IDSocket.Active := False;
end;
{$ELSE}

procedure TFrmIDSoc.Close;
var
  ThreadInfo: pTThreadInfo;
begin
  ThreadInfo := @g_Config.IDSocketThread;
  ThreadInfo.boTerminaled := True;
  if WaitForSingleObject(ThreadInfo.hThreadHandle, 1000) <> 0 then
    SuspendThread(ThreadInfo.hThreadHandle);
end;
{$IFEND}

function TFrmIDSoc.GetSessionCount: Integer;
begin
  m_SessionList.Lock;
  try
    Result := m_SessionList.Count;
  finally
    m_SessionList.UnLock;
  end;
end;

procedure TFrmIDSoc.GetSessionList(List: TList);
var
  i: Integer;
begin
  m_SessionList.Lock;
  try
    for i := 0 to m_SessionList.Count - 1 do
      List.Add(m_SessionList.Items[i]);
  finally
    m_SessionList.UnLock;
  end;
end;

procedure IDSocketRead(Config: pTConfig);
var
  dwReceiveTimeTick: LongWord;
  nReceiveTime: Integer;
  sRecvText: string;
  nRecvLen: Integer;
  nRet: Integer;
begin
  if Config.IDSocket = INVALID_SOCKET then
    Exit;

  dwReceiveTimeTick := GetTickCount();
  nRet := ioctlsocket(Config.IDSocket, FIONREAD, nRecvLen);
  if (nRet = SOCKET_ERROR) or (nRecvLen = 0) then
  begin
    // nRet := WSAGetLastError;
    Config.IDSocket := INVALID_SOCKET;
    Sleep(100);
    Config.boIDSocketConnected := False;
    Exit;
  end;
  SetLength(sRecvText, nRecvLen);
  nRecvLen := recv(Config.IDSocket, Pointer(sRecvText)^, nRecvLen, 0);
  SetLength(sRecvText, nRecvLen);

  Inc(Config.nIDSocketRecvIncLen, nRecvLen);
  if (nRecvLen <> SOCKET_ERROR) and (nRecvLen > 0) then
  begin
    if nRecvLen > Config.nIDSocketRecvMaxLen then
      Config.nIDSocketRecvMaxLen := nRecvLen;
    EnterCriticalSection(Config.UserIDSection);
    try
      Config.sIDSocketRecvText := Config.sIDSocketRecvText + sRecvText;
    finally
      LeaveCriticalSection(Config.UserIDSection);
    end;
    FrmIDSoc.Run;
  end;
  Inc(Config.nIDSocketRecvCount);
  nReceiveTime := GetTickCount - dwReceiveTimeTick;
  if Config.nIDReceiveMaxTime < nReceiveTime then
    Config.nIDReceiveMaxTime := nReceiveTime;
end;

procedure IDSocketProcess(Config: pTConfig; ThreadInfo: pTThreadInfo);
var
  s: TSocket;
  Name: sockaddr_in;
  HostEnt: PHostEnt;
  argp: Longint;
  readfds: TFDSet;
  timeout: TTimeVal;
  nRet: Integer;
  boRecvData: BOOL;
  nRunTime: Integer;
  dwRunTick: LongWord;
resourcestring
  sIDServerConnected = '登录服务器(%s:%d)连接成功...';
begin
  s := INVALID_SOCKET;
  if Config.IDSocket <> INVALID_SOCKET then  s := Config.IDSocket;

  dwRunTick := GetTickCount();
  ThreadInfo.dwRunTick := dwRunTick;
  boRecvData := False;
  while True do
  begin
    if ThreadInfo.boTerminaled then
      Break;
    if not boRecvData then
      Sleep(1)
    else
      Sleep(0);
    boRecvData := False;
    nRunTime := GetTickCount - ThreadInfo.dwRunTick;
    if ThreadInfo.nRunTime < nRunTime then
      ThreadInfo.nRunTime := nRunTime;
    if ThreadInfo.nMaxRunTime < nRunTime then
      ThreadInfo.nMaxRunTime := nRunTime;
    if GetTickCount - dwRunTick >= 1000 then
    begin
      dwRunTick := GetTickCount();
      if ThreadInfo.nRunTime > 0 then
        Dec(ThreadInfo.nRunTime);
    end;

    ThreadInfo.dwRunTick := GetTickCount();
    ThreadInfo.boActived := True;
    ThreadInfo.nRunFlag := 125;
    if (Config.IDSocket = INVALID_SOCKET) or (s = INVALID_SOCKET) then
    begin
      if Config.IDSocket <> INVALID_SOCKET then
      begin
        Config.IDSocket := INVALID_SOCKET;
        Sleep(100);
        ThreadInfo.nRunFlag := 126;
        Config.boIDSocketConnected := False;
      end;
      if s <> INVALID_SOCKET then
      begin
        closesocket(s);
        s := INVALID_SOCKET;
      end;
      if Config.sIDSAddr = '' then
        Continue;

      s := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
      if s = INVALID_SOCKET then
        Continue;

      ThreadInfo.nRunFlag := 127;

      HostEnt := gethostbyname(PChar(@Config.sIDSAddr[1]));
      if HostEnt = nil then
        Continue;

      PInteger(@Name.sin_addr.S_addr)^ := PInteger(HostEnt.h_addr^)^;
      Name.sin_family := HostEnt.h_addrtype;
      Name.sin_port := htons(Config.nIDSPort);
      Name.sin_family := PF_INET;

      ThreadInfo.nRunFlag := 128;
      if Connect(s, Name, SizeOf(Name)) = SOCKET_ERROR then
      begin
        // nRet := WSAGetLastError; //Correct By Blue
        closesocket(s);
        s := INVALID_SOCKET;
        Continue;
      end;

      argp := 1;
      if ioctlsocket(s, FIONBIO, argp) = SOCKET_ERROR then
      begin
        closesocket(s);
        s := INVALID_SOCKET;
        Continue;
      end;
      ThreadInfo.nRunFlag := 129;
      Config.IDSocket := s;
      Config.boIDSocketConnected := True;
      MainOutMessageAPI(Format(sIDServerConnected, [Config.sIDSAddr, Config.nIDSPort]));
    end;
    readfds.fd_count := 1;
    readfds.fd_array[0] := s;
    timeout.tv_sec := 0;
    timeout.tv_usec := 20;
    ThreadInfo.nRunFlag := 130;
    nRet := select(0, @readfds, nil, nil, @timeout);
    if nRet = SOCKET_ERROR then
    begin
      ThreadInfo.nRunFlag := 131;
      nRet := WSAGetLastError;
      if nRet = WSAEWOULDBLOCK then
      begin
        Sleep(10);
        Continue;
      end;
      ThreadInfo.nRunFlag := 132;
      nRet := WSAGetLastError;
      Config.nIDSocketWSAErrCode := nRet - WSABASEERR;
      Inc(Config.nIDSocketErrorCount);
      Config.DBSocket := INVALID_SOCKET;
      Sleep(100);
      Config.boIDSocketConnected := False;
      closesocket(s);
      s := INVALID_SOCKET;
      Continue;
    end;
    boRecvData := True;
    ThreadInfo.nRunFlag := 133;
    while (nRet > 0) do
    begin
      IDSocketRead(Config);
      Dec(nRet);
    end;
  end;
  if Config.IDSocket <> INVALID_SOCKET then
  begin
    Config.IDSocket := INVALID_SOCKET;
    Config.boIDSocketConnected := False;
  end;
  if s <> INVALID_SOCKET then
    closesocket(s);
end;

procedure IDSocketThread(ThreadInfo: pTThreadInfo); stdcall;
var
  nErrorCount: Integer;
resourcestring
  sExceptionMsg = '[Exception] DBSocketThread ErrorCount = %d';
begin
  nErrorCount := 0;
  while True do
  begin
    try
      IDSocketProcess(ThreadInfo.Config, ThreadInfo);
      Break;
    except
      Inc(nErrorCount);
      if nErrorCount > 10 then
        Break;
      MainOutMessageAPI(Format(sExceptionMsg, [nErrorCount]));
    end;
  end;
  ExitThread(0);
end;

end.
