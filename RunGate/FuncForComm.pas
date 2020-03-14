unit FuncForComm;

interface

uses
  Windows, Messages, SysUtils, Classes, ClientSession,
  WinSock2, ThreadPool, Protocol, ExtCtrls, CDServerSDK;

type
  TProcMsgThread = class(TTimer)
  public
    m_nProcIdx: Integer;
    m_xUserList: Classes.TList;
    m_xTempUserList: Classes.TList;
    m_csAccess: TRTLCriticalSection;
  protected
    //procedure Run(); override;
    procedure Run(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock();
    procedure Unlock();
    procedure AddSession(CSession: TSessionObj);
    procedure DelSession(CSession: TSessionObj);
  end;

procedure StartService();
procedure StopService();
procedure OnTimerProc(hWnd: hWnd; uMsg: UINT; idEvent: UINT_PTR; dwTime: DWORD); stdcall;

var
  g_ProcMsgThread: TProcMsgThread = nil;

implementation

uses
  AppMain, IOCPManager, AcceptExWorkedThread, SHSocket, ChatCmdFilter, Punishment,
  AbusiveFilter, ConfigManager, Grobal2, HUtil32, Misc, LogManager, Filter,
  UJxModule;

constructor TProcMsgThread.Create;
begin
  InitializeCriticalSection(m_csAccess);
  inherited Create(nil);
  m_nProcIdx := 0;
  m_xUserList := Classes.TList.Create;
  m_xTempUserList := Classes.TList.Create;
  Self.Interval := 1;
  Self.Enabled := True;
  Self.OnTimer := Run;
end;

destructor TProcMsgThread.Destroy;
begin
  m_xUserList.Free;
  m_xTempUserList.Free;
  DeleteCriticalSection(m_csAccess);
  inherited Destroy;
end;

procedure TProcMsgThread.Lock;
begin
  EnterCriticalSection(m_csAccess);
end;

procedure TProcMsgThread.Unlock;
begin
  LeaveCriticalSection(m_csAccess);
end;

procedure TProcMsgThread.AddSession(CSession: TSessionObj);
begin
  Lock();
  try
    m_xUserList.Add(CSession);
  finally
    Unlock();
  end;
end;

procedure TProcMsgThread.DelSession(CSession: TSessionObj);
var
  i: Integer;
begin
  Lock();
  try
    i := m_xUserList.IndexOf(CSession);
    if i >= 0 then
      m_xUserList.Delete(i);
  finally
    Unlock();
  end;
end;

procedure TProcMsgThread.Run(Sender: TObject);
var
  i: Integer;
  fKick: Boolean;
  CSession: TSessionObj;
begin
  //while not Terminated do begin
  if not g_fServiceStarted then
    Exit;

  if m_xTempUserList.Count > 0 then
    m_xTempUserList.Clear;

  Lock();
  //try
  for i := 0 to m_xUserList.Count - 1 do
    m_xTempUserList.Add(m_xUserList[i]);
  //finally
  Unlock();
  //end;

  //try
  for i := 0 to m_xTempUserList.Count - 1 do
  begin
    if not g_fServiceStarted then
      Break;
    CSession := TSessionObj(m_xTempUserList[i]);
    if (CSession <> nil) and (CSession.m_tLastGameSvr <> nil) then
    begin
        //单向包验证

      if not CSession.m_fKickFlag then
      begin
        CSession.ProcessDelayMsg();
        if (CSession.m_fHandleLogin < 3) then
        begin
          if (GetTickCount - CSession.m_dwClientTimeOutTick > g_pConfig.m_nClientTimeOutTime) then
          begin
            CSession.m_dwClientTimeOutTick := GetTickCount;
            KickUser(CSession);
            if g_pLogMgr.CheckLevel(5) then
            begin
              g_pLogMgr.Add('Client Connect Time Out: ' + CSession.m_pUserOBJ.pszIPAddr);
            end;
          end;
        end
        else
        begin

        end;
      end
      else
      begin
        fKick := False;
        if (GetTickCount - CSession.m_dwClientTimeOutTick > g_pConfig.m_nClientTimeOutTime) then
        begin
          CSession.m_dwClientTimeOutTick := GetTickCount;
          fKick := True;
        end;

        if fKick then
        begin
          SHSocket.FreeSocket(CSession.m_pUserOBJ._SendObj.Socket);
        end;
      end;

    end;
  end;
  //finally
  //  m_xTempUserList.Clear;
  //end;

  //  Sleep(1);
  //end;
end;

procedure StartService();
begin
  g_fServiceStarted := True;

  g_ProcMsgThread.Enabled := True;

  g_pLogMgr.Add('正在启动服务 ...');
  g_pConfig.LoadConfig();

  Filter.ClearConnectOfIP();
  g_HWIDFilter.ClearHWIDCount();

  with FormMain do
  begin
    Caption := g_pConfig.m_szTitle + ' [' + g_szStr + ']';
    MENU_CONTROL_START.Enabled := False;
    MENU_CONTROL_STOP.Enabled := True;
    FormMain.m_xRunServerList := TIOCPManager.Create;
    FormMain.m_xGameServerList := TGameServerManager.Create;
    FormMain.InitIOCPServer;
  end;

  g_pLogMgr.Add('服务已启动成功...');

  SetTimer(g_hMainWnd, _IDM_TIMER_KEEP_ALIVE, 10 * 1000, Pointer(@OnTimerProc));
  SetTimer(g_hMainWnd, _IDM_TIMER_THREAD_INFO, 1000, Pointer(@OnTimerProc));


  g_pJXMgr.LoadJx;
  FormMain.MENU_VIEW_HELP_ABOUTClick(nil);
end;

procedure StopService;
var
  i: Integer;
begin
  g_fServiceStarted := False;

  //g_ProcMsgThread.Terminated := True;
  g_ProcMsgThread.Enabled := False;

  g_pLogMgr.Add('正在停止服务...');

  KillTimer(g_hMainWnd, _IDM_TIMER_KEEP_ALIVE);

  with FormMain do
  begin
    for i := 1 to GridSocketInfo.RowCount - 1 do
      GridSocketInfo.Rows[i].Clear;
    StatusBar.Panels[0].Text := Format('在线: %d/%d', [0, 0]);

    MENU_CONTROL_START.Enabled := True;
    MENU_CONTROL_STOP.Enabled := False;
    try
      m_xGameServerList.CloseAllGameServer;
      Sleep(80);
      m_xRunServerList.Free;
      Sleep(20);
      m_xGameServerList.Free;
    except
    end;
  end;
  Filter.ClearConnectOfIP();
  g_HWIDFilter.ClearHWIDCount();

  SaveBlockIPList();
  SaveBlockIPAreaList();

  g_ChatCmdFilterList.SaveToFile(_STR_CHAT_CMD_FILTER_FILE);
  g_AbuseList.SaveToFile(_STR_CHAT_FILTER_FILE);
  g_PunishList.SaveToFile(_STR_PUNISH_USER_FILE);

  //g_ProcMsgThread.Free;
  //g_ProcMsgThread := nil;

  g_pLogMgr.Add('服务停止成功...');
end;

procedure KeepAlive();
var
  i: Integer;
  CmdPacket: TSvrCmdPack;
begin
  with CmdPacket do
  begin
    Flag := RUNGATECODE;
    SockID := 0;
    Cmd := GM_CHECKCLIENT;
    DataLen := 0;
  end;
  try
    for i := 0 to FormMain.m_xGameServerList.GameServerCount - 1 do
    begin
      if FormMain.m_xGameServerList[i].Active then
        FormMain.m_xGameServerList[i].SendBuffer(@CmdPacket, SizeOf(TSvrCmdPack));
    end;

    //FormMain.m_xRunServerList.IOCPServer.Writer.PostAllUserSend(_STR_KEEP_ALIVE, SizeOf(Char));
  except
    on E: Exception do
      if g_pLogMgr.CheckLevel(5) then
        g_pLogMgr.Add('Keep Alive Except: ' + E.Message);
  end;
end;

procedure ShowThreadInfo();
var
  i, nRow: Integer;
  IOCPAccepter: TIOCPAccepter;
  PSI: PServerInfo;
  pszBuf: array[0..255] of Char;
begin
  if not g_fServiceStarted then
    Exit;

  IOCPAccepter := FormMain.m_xRunServerList.IOCPServer.AcceptExSocket;
  FormMain.StatusBar.Panels[0].Text := Format('在线: %d/%d', [IOCPAccepter.InUseBlock, IOCPAccepter.MaxInUseBlock]);

  nRow := 1;
  for i := 0 to IOCPAccepter.ServerCount - 1 do
  begin
    if IOCPAccepter.Active then
    begin
      PSI := @IOCPAccepter.FServerInfoList[i];
      if not PSI^.pClient.Active then
        Continue;
      FormMain.GridSocketInfo.Cells[0, nRow] := PSI^.pClient.ServerIP;
      FormMain.GridSocketInfo.Cells[1, nRow] := IntToStr(PSI^.nPort);
      case PSI.pClient.m_tSockThreadStutas of
        stConnecting: FormMain.GridSocketInfo.Cells[2, nRow] := '连接中..';
        stConnected: FormMain.GridSocketInfo.Cells[2, nRow] := '已连接';
        stTimeOut: FormMain.GridSocketInfo.Cells[2, nRow] := '超时';
      end;

      if PSI^.pClient.m_dwSendBytes > (1024 * 1000) then
        StrFmt(@pszBuf[0], '%fM', [PSI^.pClient.m_dwSendBytes / (1024 * 1000)])
      else if PSI^.pClient.m_dwSendBytes > 1024 then
        StrFmt(@pszBuf[0], '%fK', [PSI^.pClient.m_dwSendBytes / 1024])
      else
        StrFmt(@pszBuf[0], '%dB', [PSI^.pClient.m_dwSendBytes]);
      PSI^.pClient.m_dwSendBytes := 0;
      FormMain.GridSocketInfo.Cells[3, nRow] := pszBuf;

      if PSI^.pClient.m_dwRecvBytes > (1024 * 1000) then
        StrFmt(@pszBuf[0], '%fM', [PSI^.pClient.m_dwRecvBytes / (1024 * 1000)])
      else if PSI^.pClient.m_dwRecvBytes > 1024 then
        StrFmt(@pszBuf[0], '%fK', [PSI^.pClient.m_dwRecvBytes / 1024])
      else
        StrFmt(@pszBuf[0], '%dB', [PSI^.pClient.m_dwRecvBytes]);
      PSI^.pClient.m_dwRecvBytes := 0;
      FormMain.GridSocketInfo.Cells[4, nRow] := pszBuf;

    end;
    Inc(nRow);
  end;
end;

procedure BroadCastUserItemSpeed();
var
  i, nLen: Integer;
  tCmd: TCmdPack;
  pszSendBuf: array[0..48 - 1] of Char;
  tUserObj: TSessionObj;
begin
  if not g_fServiceStarted then
    Exit;

  for i := 0 to USER_ARRAY_COUNT - 1 do
  begin
    tUserObj := g_UserList[i];
    if (tUserObj <> nil) and (tUserObj.m_tLastGameSvr <> nil) and (tUserObj.m_tLastGameSvr.Active) and not tUserObj.m_fKickFlag then
    begin
      tCmd.UID := tUserObj.m_nSvrObject;
      tCmd.Cmd := SM_CHARSTATUSCHANGED;
      tCmd.X := LoWord(tUserObj.m_nChrStutas);
      tCmd.Y := HiWord(tUserObj.m_nChrStutas);
      InterlockedExchange(tUserObj.m_nItemSpeed, _MIN(g_pConfig.m_nMaxItemSpeed, tUserObj.m_nDefItemSpeed));
      tCmd.Direct := tUserObj.m_nItemSpeed;

      pszSendBuf[0] := '#';
      nLen := EncodeBuf(Integer(@tCmd), 12, Integer(@pszSendBuf[1]));
      pszSendBuf[nLen + 1] := '!';
      tUserObj.m_tIOCPSender.SendData(tUserObj.m_pOverlapSend, @pszSendBuf[0], nLen + 2);
    end;
  end;
end;

procedure BroadCastClientActionSpeed();
var
  i, nLen: Integer;
  tCmd: TCmdPack;
  pszSendBuf: array[0..48 - 1] of Char;
  tUserObj: TSessionObj;
begin
  if not g_fServiceStarted then
    Exit;

  for i := 0 to USER_ARRAY_COUNT - 1 do
  begin
    tUserObj := g_UserList[i];
    if (tUserObj <> nil) and (tUserObj.m_tLastGameSvr <> nil) and (tUserObj.m_tLastGameSvr.Active) and not tUserObj.m_fKickFlag then
    begin
      tCmd.UID := tUserObj.m_nSvrObject;
      tCmd.Cmd := SM_SERVERCONFIG3;
      tCmd.X := MakeWord(g_pConfig.m_nClientAttackSpeedRate, g_pConfig.m_nClientSpellSpeedRate);
      tCmd.Y := MakeWord(g_pConfig.m_nClientMoveSpeedRate, Byte(not g_pConfig.m_fClientShowHintNewType));
      tCmd.Direct := MakeWord(Byte(g_pConfig.m_fOpenClientSpeedRate), 0);
      pszSendBuf[0] := '#';
      nLen := EncodeBuf(Integer(@tCmd), 12, Integer(@pszSendBuf[1]));
      pszSendBuf[nLen + 1] := '!';
      tUserObj.m_tIOCPSender.SendData(tUserObj.m_pOverlapSend, @pszSendBuf[0], nLen + 2);
    end;
  end;
end;

procedure OnTimerProc(hWnd: hWnd; uMsg: UINT; idEvent: UINT_PTR; dwTime: DWORD);
var
  i: Integer;
begin
  case idEvent of
    _IDM_TIMER_STARTSERVICE:
      begin
        KillTimer(g_hMainWnd, _IDM_TIMER_STARTSERVICE);
        StartService();
      end;
    _IDM_TIMER_STOPSERVICE:
      begin
        KillTimer(g_hMainWnd, _IDM_TIMER_STOPSERVICE);
        StopService();
      end;
    _IDM_TIMER_KEEP_ALIVE:
      begin
        KeepAlive();
      end;
    _IDM_TIMER_THREAD_INFO:
      begin
        ShowThreadInfo();
      end;
    _IDM_TIMER_BROADCAST_USER_ITEM_SPEED:
      begin
        KillTimer(g_hMainWnd, _IDM_TIMER_BROADCAST_USER_ITEM_SPEED);
        BroadCastUserItemSpeed();
      end;
    _IDM_TIMER_BROADCAST_CLIENT_ACTION_SPEED:
      begin
        KillTimer(g_hMainWnd, _IDM_TIMER_BROADCAST_CLIENT_ACTION_SPEED);
        BroadCastClientActionSpeed();
      end;
  end;
end;

end.
