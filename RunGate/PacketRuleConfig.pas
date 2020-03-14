unit PacketRuleConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Clipbrd,
  Dialogs, ComCtrls, StdCtrls, Spin, Menus, WinSock2, HUtil32, ExtCtrls, Mask, Grids,
  FileCtrl;

type
  TfrmPacketRule = class(TForm)
    pcProcessPack: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ActiveListPopupMenu: TPopupMenu;
    APOPMENU_REFLIST: TMenuItem;
    APOPMENU_SORT: TMenuItem;
    APOPMENU_ADDTEMPLIST: TMenuItem;
    APOPMENU_BLOCKLIST: TMenuItem;
    APOPMENU_KICK: TMenuItem;
    TempBlockListPopupMenu: TPopupMenu;
    TPOPMENU_REFLIST: TMenuItem;
    TPOPMENU_SORT: TMenuItem;
    TPOPMENU_ADD: TMenuItem;
    TPOPMENU_AddtoBLOCKLIST: TMenuItem;
    TPOPMENU_DELETE: TMenuItem;
    BlockListPopupMenu: TPopupMenu;
    BPOPMENU_REFLIST: TMenuItem;
    BPOPMENU_SORT: TMenuItem;
    BPOPMENU_ADD: TMenuItem;
    BPOPMENU_ADDTEMPLIST: TMenuItem;
    BPOPMENU_DELETE: TMenuItem;
    APOPMENU_AllToTempBLOCKLIST: TMenuItem;
    TPOPMENU_ALLTOBLOCKLIST: TMenuItem;
    TPOPMENU_DELETE_ALL: TMenuItem;
    BPOPMENU_ALLTOTEMPLIST: TMenuItem;
    BPOPMENU_DELETE_ALL: TMenuItem;
    APOPMENU_AllToBLOCKLIST: TMenuItem;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    btnSave: TButton;
    btnClose: TButton;
    Label11: TLabel;
    Label13: TLabel;
    Label9: TLabel;
    ListBoxActiveList: TListBox;
    ListBoxTempList: TListBox;
    LabelTempList: TLabel;
    ListBoxBlockList: TListBox;
    Label10: TLabel;
    APOPMENU_AllNullNameToBLOCKLIST: TMenuItem;
    PopupMenuSpeedLimit: TPopupMenu;
    MenuItem_SpeedLimitPunish_Renew: TMenuItem;
    MenuItem_SpeedLimitPunish_Add: TMenuItem;
    MenuItem_SpeedLimitPunish_Del: TMenuItem;
    MenuItem_SpeedLimitPunish_DelAll: TMenuItem;
    TabSheet5: TTabSheet;
    etPacketDecryptErrMsg: TEdit;
    Label35: TLabel;
    Label36: TLabel;
    etCDVersionErrMsg: TEdit;
    cbClientItemShowMode: TCheckBox;
    cbAttackInterval: TCheckBox;
    cbButchInterval: TCheckBox;
    cbMoveInterval: TCheckBox;
    cbSitDownInterval: TCheckBox;
    cbSpellInterval: TCheckBox;
    cbTurnInterval: TCheckBox;
    cbEat: TCheckBox;
    cbPickUp: TCheckBox;
    cbSpeedHackWarning: TCheckBox;
    cbxMagicList: TComboBox;
    cbxSpeedHackWarningMethod: TComboBox;
    cbxSpeedHackPunishMethod: TComboBox;
    etSpeedHackSendBackMsg: TEdit;
    GroupBox3: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    TrackBarMoveSpd: TTrackBar;
    TrackBarAttackSpd: TTrackBar;
    TrackBarSpellSpd: TTrackBar;
    GroupBox5: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label27: TLabel;
    Label34: TLabel;
    speSpellNextMoveCompensate: TSpinEdit;
    speAttackNextMoveCompensate: TSpinEdit;
    speMoveNextAttackCompensate: TSpinEdit;
    spePunishBaseInterval: TSpinEdit;
    spePunishIntervalRate: TMaskEdit;
    speMoveNextSpellCompensate: TSpinEdit;
    Label19: TLabel;
    Label21: TLabel;
    cbKickUserOverPackCnt: TCheckBox;
    speAttackInterval: TSpinEdit;
    speButchInterval: TSpinEdit;
    speSpellInterval: TSpinEdit;
    speMoveInterval: TSpinEdit;
    speSitDownInterval: TSpinEdit;
    speTurnInterval: TSpinEdit;
    speEatItemInvTime: TSpinEdit;
    speItemSpeedRate: TSpinEdit;
    spePickUpItemInvTime: TSpinEdit;
    speMaxItemSpeed: TSpinEdit;
    GroupBoxNullConnect: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    etMaxClientPacketSize: TSpinEdit;
    etMaxClientMsgCount: TSpinEdit;
    etNomClientPacketSize: TSpinEdit;
    cbChatInterval: TCheckBox;
    cbChatFilter: TCheckBox;
    cbxChatFilterMethod: TComboBox;
    cbSpaceMoveNextPickupInterval: TCheckBox;
    cbChatCmdFilter: TCheckBox;
    etCmdMove: TEdit;
    etAbuseReplaceWords: TEdit;
    Label22: TLabel;
    ListBoxAbuseFilterText: TListBox;
    MemoCmdFilter: TMemo;
    speCltSay: TSpinEdit;
    speSpaceMovePickUpInvTime: TSpinEdit;
    cbSyncSpeedRate: TCheckBox;
    cbOpenClientSpeedRate: TCheckBox;
    GroupBox7: TGroupBox;
    rdAddBlockList: TRadioButton;
    rdAddTempList: TRadioButton;
    rdDisConnect: TRadioButton;
    cbKickOverPacketSize: TCheckBox;
    GroupBox1: TGroupBox;
    etMaxConnectOfIP: TSpinEdit;
    Label12: TLabel;
    Label14: TLabel;
    etClientTimeOutTime: TSpinEdit;
    cbCheckNullConnect: TCheckBox;
    Label20: TLabel;
    btnAbuseMod: TButton;
    btnAbuseAdd: TButton;
    btnAbuseDel: TButton;
    APOPMENU_AddToPunishList: TMenuItem;
    Bevel: TBevel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Label15: TLabel;
    spePunishMoveInterval: TSpinEdit;
    spePunishAttackInterval: TSpinEdit;
    Label24: TLabel;
    Label26: TLabel;
    spePunishSpellInterval: TSpinEdit;
    Label8: TLabel;
    ListBoxSpeedLimitList: TListBox;
    APOPMENU_AddAllToPunishList: TMenuItem;
    cbDefenceCC: TCheckBox;
    Label23: TLabel;
    ListBoxIPAreaFilter: TListBox;
    PopupMenu_IPAreaFilter: TPopupMenu;
    MenuItem_IPAreaAdd: TMenuItem;
    MenuItem_IPAreaDel: TMenuItem;
    MenuItem_IPAreaDelAll: TMenuItem;
    MenuItem_IPAreaMod: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    cbCheckDoMotaebo: TCheckBox;
    cbDenyPresend: TCheckBox;
    GroupBox2: TGroupBox;
    ListViewCurHWIDList: TListView;
    ListBoxBlockHWIDList: TListBox;
    Label37: TLabel;
    PopupMenu_BlockHWIDList: TPopupMenu;
    MenuItem_BlockHWIDList_Add: TMenuItem;
    MenuItem_BlockHWIDList_Del: TMenuItem;
    MenuItem_BlockHWIDList_DelAll: TMenuItem;
    PopupMenu_CurHWIDList: TPopupMenu;
    MenuItem_CurHWIDList_Flush: TMenuItem;
    MenuItem_CurHWIDList_CopyHWID: TMenuItem;
    MenuItem_CurHWIDList_AddToBlockList: TMenuItem;
    MenuItem_CurHWIDList_AllAddToBlockList: TMenuItem;
    cbProcClientCount: TCheckBox;
    seMaxClientCount: TSpinEdit;
    Label38: TLabel;
    EditHWIDList: TEdit;
    btnHWIDList: TButton;
    edOverClientCntMsg: TEdit;
    Label39: TLabel;
    Label25: TLabel;
    edHWIDBlockedMsg: TEdit;
    Label40: TLabel;
    speAttackNextSpellCompensate: TSpinEdit;
    Label41: TLabel;
    speSpellNextAttackCompensate: TSpinEdit;
    cbItemSpeedCompensate: TCheckBox;
    Label42: TLabel;
    procedure speAttackIntervalChange(Sender: TObject);
    procedure cbMoveIntervalClick(Sender: TObject);
    procedure cbxMagicListChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure etSpeedHackSendBackMsgChange(Sender: TObject);
    procedure ListBoxAbuseFilterTextClick(Sender: TObject);
    procedure ListBoxAbuseFilterTextDblClick(Sender: TObject);
    procedure btnAbuseAddClick(Sender: TObject);
    procedure btnAbuseDelClick(Sender: TObject);
    procedure btnAbuseModClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActiveListPopupMenuPopup(Sender: TObject);
    procedure TempBlockListPopupMenuPopup(Sender: TObject);
    procedure BlockListPopupMenuPopup(Sender: TObject);
    procedure APOPMENU_REFLISTClick(Sender: TObject);
    procedure APOPMENU_SORTClick(Sender: TObject);
    procedure APOPMENU_ADDTEMPLISTClick(Sender: TObject);
    procedure APOPMENU_BLOCKLISTClick(Sender: TObject);
    procedure APOPMENU_KICKClick(Sender: TObject);
    procedure TPOPMENU_REFLISTClick(Sender: TObject);
    procedure TPOPMENU_SORTClick(Sender: TObject);
    procedure TPOPMENU_ADDClick(Sender: TObject);
    procedure TPOPMENU_AddtoBLOCKLISTClick(Sender: TObject);
    procedure TPOPMENU_DELETEClick(Sender: TObject);
    procedure BPOPMENU_REFLISTClick(Sender: TObject);
    procedure BPOPMENU_SORTClick(Sender: TObject);
    procedure BPOPMENU_ADDClick(Sender: TObject);
    procedure BPOPMENU_ADDTEMPLISTClick(Sender: TObject);
    procedure BPOPMENU_DELETEClick(Sender: TObject);
    procedure APOPMENU_AllToTempBLOCKLISTClick(Sender: TObject);
    procedure TPOPMENU_ALLTOBLOCKLISTClick(Sender: TObject);
    procedure TPOPMENU_DELETE_ALLClick(Sender: TObject);
    procedure BPOPMENU_ALLTOTEMPLISTClick(Sender: TObject);
    procedure BPOPMENU_DELETE_ALLClick(Sender: TObject);
    procedure APOPMENU_AllToBLOCKLISTClick(Sender: TObject);
    procedure APOPMENU_AllNullNameToBLOCKLISTClick(Sender: TObject);
    procedure MemoCmdFilterChange(Sender: TObject);
    procedure PopupMenuSpeedLimitPopup(Sender: TObject);
    procedure MenuItem_SpeedLimitPunish_RenewClick(Sender: TObject);
    procedure MenuItem_SpeedLimitPunish_AddClick(Sender: TObject);
    procedure MenuItem_SpeedLimitPunish_DelClick(Sender: TObject);
    procedure MenuItem_SpeedLimitPunish_DelAllClick(Sender: TObject);
    procedure TrackBarAttackSpdChange(Sender: TObject);
    procedure spePunishIntervalRateChange(Sender: TObject);
    procedure rdDisConnectClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure APOPMENU_AddToPunishListClick(Sender: TObject);
    procedure APOPMENU_AddAllToPunishListClick(Sender: TObject);
    procedure PopupMenu_IPAreaFilterPopup(Sender: TObject);
    procedure MenuItem_IPAreaAddClick(Sender: TObject);
    procedure MenuItem_IPAreaDelClick(Sender: TObject);
    procedure MenuItem_IPAreaDelAllClick(Sender: TObject);
    procedure MenuItem_IPAreaModClick(Sender: TObject);
    procedure ListBoxIPAreaFilterDblClick(Sender: TObject);
    procedure PopupMenu_BlockHWIDListPopup(Sender: TObject);
    procedure PopupMenu_CurHWIDListPopup(Sender: TObject);
    procedure MenuItem_CurHWIDList_FlushClick(Sender: TObject);
    procedure MenuItem_CurHWIDList_CopyHWIDClick(Sender: TObject);
    procedure MenuItem_CurHWIDList_AddToBlockListClick(Sender: TObject);
    procedure MenuItem_CurHWIDList_AllAddToBlockListClick(Sender: TObject);
    procedure MenuItem_BlockHWIDList_AddClick(Sender: TObject);
    procedure MenuItem_BlockHWIDList_DelClick(Sender: TObject);
    procedure MenuItem_BlockHWIDList_DelAllClick(Sender: TObject);
    procedure btnHWIDListClick(Sender: TObject);
  public
    m_ShowOpen: Boolean;
    m_nDefItemSpeed: Integer;
    m_nDefHitSpeedRate: Integer;
    m_nDefMagSpeedRate: Integer;
    m_nDefMoveSpeedRate: Integer;
  end;

var
  frmPacketRule: TfrmPacketRule;

implementation

uses
  AcceptExWorkedThread, ClientSession, TableDef, IOCPTypeDef, ConfigManager,
  AppMain, Protocol, Punishment, ChatCmdFilter, FuncForComm,
  AbusiveFilter, Filter, Misc, Grobal2, LogManager, SHSocket, MD5;

{$R *.dfm}

procedure TfrmPacketRule.spePunishIntervalRateChange(Sender: TObject);
begin
  if not m_ShowOpen then
    Exit;
  try
    g_pConfig.m_nPunishIntervalRate := StrToFloat(spePunishIntervalRate.Text);
    if g_pConfig.m_nPunishIntervalRate <= 0.10 then
    begin
      g_pConfig.m_nPunishIntervalRate := 0.10;
      spePunishIntervalRate.Text := FloatToStr(g_pConfig.m_nPunishIntervalRate);
    end;
  except
  end;
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.speAttackIntervalChange(Sender: TObject);
var
  nMagID: Integer;
begin
  if not m_ShowOpen then
    Exit;
  with g_pConfig, (Sender as TSpinEdit) do
  begin
    case Tag of
      0: InterlockedExchange(m_nMoveInterval, Value);
      1: InterlockedExchange(m_nAttackInterval, Value);
      2: InterlockedExchange(m_nTurnInterval, Value);
      3: InterlockedExchange(m_nButchInterval, Value);
      4: InterlockedExchange(m_nSitDownInterval, Value);
      5:
        begin
          nMagID := Integer(cbxMagicList.Items.Objects[cbxMagicList.ItemIndex]);
          InterlockedExchange(MAIGIC_DELAY_TIME_LIST[nMagID], Value);
        end;
      6: InterlockedExchange(m_nMaxItemSpeed, Value);
      7: InterlockedExchange(m_nMaxItemSpeedRate, Value);

      8: InterlockedExchange(m_nMoveNextAttackCompensate, Value);
      9: InterlockedExchange(m_nMoveNextSpellCompensate, Value);
      10: InterlockedExchange(m_nAttackNextMoveCompensate, Value);
      18: InterlockedExchange(m_nAttackNextSpellCompensate, Value);
      11: InterlockedExchange(m_nSpellNextMoveCompensate, Value);
      19: InterlockedExchange(m_nSpellNextAttackCompensate, Value);

      12: InterlockedExchange(m_nPunishBaseInterval, Value);
      13: InterlockedExchange(m_nEatInterval, Value);
      14: InterlockedExchange(m_nPickupInterval, Value);
      15: InterlockedExchange(m_nPunishMoveInterval, Value);
      16: InterlockedExchange(m_nPunishAttackInterval, Value);
      17: InterlockedExchange(m_nPunishSpellInterval, Value);

      20: InterlockedExchange(m_nMaxConnectOfIP, Value);
      21: InterlockedExchange(m_nClientTimeOutTime, Value * 1000);
      22: InterlockedExchange(m_nNomClientPacketSize, Value);
      23: InterlockedExchange(m_nMaxClientPacketSize, Value);
      24: InterlockedExchange(m_nMaxClientPacketCount, Value);
      25: InterlockedExchange(m_nMaxClientCount, Value);

      30: InterlockedExchange(m_nChatInterval, Value);
      31: InterlockedExchange(m_nSpaceMoveNextPickupInterval, Value);

    end;
    btnSave.Enabled := True;
  end;
end;

procedure TfrmPacketRule.cbMoveIntervalClick(Sender: TObject);
begin
  with g_pConfig, (Sender as TCheckBox) do
  begin
    case Tag of
      100: InterlockedExchange(Integer(m_fMoveInterval), Integer(Checked));
      101: InterlockedExchange(Integer(m_fAttackInterval), Integer(Checked));
      102: InterlockedExchange(Integer(m_fTurnInterval), Integer(Checked));
      103: InterlockedExchange(Integer(m_fButchInterval), Integer(Checked));
      104: InterlockedExchange(Integer(m_fSitDownInterval), Integer(Checked));
      105: InterlockedExchange(Integer(m_fSpellInterval), Integer(Checked));
      106: InterlockedExchange(Integer(m_fOverSpeedSendBack), Integer(Checked));
      107: InterlockedExchange(Integer(m_fEatInterval), Integer(Checked));
      108: InterlockedExchange(Integer(m_fPickupInterval), Integer(Checked));
      109: InterlockedExchange(Integer(m_fKickOverSpeed), Integer(Checked));

      110:
        begin
          InterlockedExchange(Integer(m_fOpenClientSpeedRate), Integer(Checked));
          TrackBarAttackSpd.Enabled := m_fOpenClientSpeedRate;
          TrackBarSpellSpd.Enabled := m_fOpenClientSpeedRate;
          TrackBarMoveSpd.Enabled := m_fOpenClientSpeedRate;
          Label28.Enabled := m_fOpenClientSpeedRate;
          Label29.Enabled := m_fOpenClientSpeedRate;
          Label30.Enabled := m_fOpenClientSpeedRate;
          Label31.Enabled := m_fOpenClientSpeedRate;
          Label32.Enabled := m_fOpenClientSpeedRate;
          Label33.Enabled := m_fOpenClientSpeedRate;
        end;
      111: if Checked then
        begin
          TrackBarAttackSpdChange(TrackBarAttackSpd);
          TrackBarAttackSpdChange(TrackBarSpellSpd);
          TrackBarAttackSpdChange(TrackBarMoveSpd);
        end;
      112: InterlockedExchange(Integer(m_fDoMotaeboSpeedCheck), Integer(Checked));
      113: InterlockedExchange(Integer(m_fDenyPresend), Integer(Checked));
      114: InterlockedExchange(Integer(m_fItemSpeedCompensate), Integer(Checked));

      120: InterlockedExchange(Integer(m_fCheckNullSession), Integer(Checked));
      121: InterlockedExchange(Integer(m_fKickOverPacketSize), Integer(Checked));
      122: InterlockedExchange(Integer(m_fDefenceCCPacket), Integer(Checked));
      123: InterlockedExchange(Integer(m_fProcClientHWID), Integer(Checked));

      130: InterlockedExchange(Integer(m_fChatInterval), Integer(Checked));
      131: InterlockedExchange(Integer(m_fChatFilter), Integer(Checked));
      132: InterlockedExchange(Integer(m_fSpaceMoveNextPickupInterval), Integer(Checked));
      133: InterlockedExchange(Integer(m_fChatCmdFilter), Integer(Checked));

      140: InterlockedExchange(Integer(m_fClientShowHintNewType), Integer(Checked));
    end;
  end;
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.cbxMagicListChange(Sender: TObject);
var
  nMagID: Integer;
begin
  with g_pConfig, (Sender as TComboBox) do
  begin
    case Tag of
      200:
        begin
          nMagID := Integer(Items.Objects[ItemIndex]);
          speSpellInterval.Value := MAIGIC_DELAY_TIME_LIST[nMagID];
        end;
      201:
        begin
          m_tSpeedHackWarnMethod := TOverSpeedMsgMethod(ItemIndex);
        end;
      202:
        begin
          case ItemIndex of
            0: Hint := '玩家将以正常上面设置的速度值进行游戏,虽然看到的自己速度非常快,但是没有实际效果';
            1: Hint := '网关将丢掉加速的封包,只处理正常速度的封包,玩家会卡屏,封加速效果中等';
            2: Hint := '服务器将不处理加速的封包,玩家游戏中将会卡屏,比较严格';
            3: Hint := '停顿处理加速，建议使用';
          end;
          m_tOverSpeedPunishMethod := TPunishMethod(ItemIndex);
        end;
      203:
        begin
          m_tChatFilterMethod := TChatFilterMethod(ItemIndex);
        end;
    end;
  end;
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.TPOPMENU_DELETE_ALLClick(Sender: TObject);
begin
  ListBoxTempList.Items.Clear;
  g_TempBlockIPList.Clear;
end;

procedure TfrmPacketRule.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPacketRule.btnHWIDListClick(Sender: TObject);
var
  s, szDir: string;
  szFolder: WideString;
begin
  szDir := g_pConfig.m_szBlockHWIDFileName;
  if FileCtrl.SelectDirectory('选择文件机器吗黑名单文件（BlockHWID.txt）', szFolder, szDir) then
  begin
    g_pConfig.m_szBlockHWIDFileName := szDir;
    EditHWIDList.Text := szDir;
  end;
end;

procedure TfrmPacketRule.btnSaveClick(Sender: TObject);
var
  i: Integer;
begin
  btnSave.Enabled := False;

  g_pConfig.SaveConfig(1);

  g_ChatCmdFilterList.Clear;
  for i := 0 to MemoCmdFilter.Lines.Count - 1 do
  begin
    if MemoCmdFilter.Lines[i] = '' then
      Continue;
    g_ChatCmdFilterList.Add(MemoCmdFilter.Lines[i]);
  end;
  g_ChatCmdFilterList.SaveToFile(_STR_CHAT_CMD_FILTER_FILE);

  g_AbuseList.Clear;
  for i := 0 to ListBoxAbuseFilterText.Items.Count - 1 do
  begin
    if ListBoxAbuseFilterText.Items.Strings[i] = '' then
      Continue;
    g_AbuseList.Add(ListBoxAbuseFilterText.Items.Strings[i]);
  end;
  g_AbuseList.SaveToFile(_STR_CHAT_FILTER_FILE);

  g_PunishList.SaveToFile(_STR_PUNISH_USER_FILE);

  SaveBlockIPList();
  SaveBlockIPAreaList();

  if m_nDefItemSpeed <> g_pConfig.m_nMaxItemSpeed then
  begin
    SetTimer(g_hMainWnd, _IDM_TIMER_BROADCAST_USER_ITEM_SPEED, 10, Pointer(@OnTimerProc));
  end;

  SetTimer(g_hMainWnd, _IDM_TIMER_BROADCAST_CLIENT_ACTION_SPEED, 10, Pointer(@OnTimerProc));

  g_HWIDFilter.SaveDenyList();
end;

procedure TfrmPacketRule.etSpeedHackSendBackMsgChange(Sender: TObject);
begin
  if not m_ShowOpen then
    Exit;
  with g_pConfig, (Sender as TEdit) do
  begin
    case Tag of
      0: m_szOverSpeedSendBack := Text;
      1: m_szChatFilterReplace := Text;
      2: m_szPacketDecryptFailed := Text;
      5: m_szOverClientCntMsg := Text;
      6: m_szHWIDBlockedMsg := Text;
    end;
  end;
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.BPOPMENU_ALLTOTEMPLISTClick(Sender: TObject);
var
  i, nIPaddr: Integer;
  szIPaddr: string;
begin
  if (ListBoxBlockList.Items.Count > 0) then
  begin
    for i := 0 to ListBoxBlockList.Items.Count - 1 do
    begin
      szIPaddr := ListBoxBlockList.Items.Strings[i];
      if ListBoxTempList.Items.IndexOf(szIPaddr) < 0 then
      begin
        ListBoxTempList.Items.AddObject(szIPaddr, ListBoxBlockList.Items.Objects[i]);
        g_TempBlockIPList.AddObject(szIPaddr, ListBoxBlockList.Items.Objects[i]);
      end;
    end;
    ListBoxBlockList.Clear;
    g_BlockIPList.Clear;
  end;
end;

procedure TfrmPacketRule.APOPMENU_REFLISTClick(Sender: TObject);
var
  i, n: Integer;
  UserObj: TSessionObj;
begin
  if not g_fServiceStarted then
    Exit;
  ListBoxActiveList.Clear;

  for n := 0 to USER_ARRAY_COUNT - 1 do
  begin
    UserObj := g_UserList[n];
    if (UserObj <> nil) and (UserObj.m_tLastGameSvr <> nil) and
      (UserObj.m_tLastGameSvr.Active) and not UserObj.m_fKickFlag then
    begin
      ListBoxActiveList.Items.AddObject(
        Trim(UserObj.m_szChrName + UserObj.m_pUserOBJ.pszIPAddr),
        TObject(UserObj));
    end;
  end;
end;

procedure TfrmPacketRule.APOPMENU_AllToBLOCKLISTClick(Sender: TObject);
var
  fExists: Boolean;
  i, ii: Integer;
  szChrName, szIPaddr: string;
  UserObj: TSessionObj;
begin
  if (ListBoxActiveList.Items.Count > 0) then
  begin
    if Application.MessageBox(
      PChar('是否确认将此所有的IP连接加入永久过滤列表中？'#13#10'加入过滤列表后，列表中IP建立的所有连接将被强行中断。'),
      PChar('确认信息'),
      MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
      Exit;
    for i := 0 to ListBoxActiveList.Items.Count - 1 do
    begin
      szIPaddr := ListBoxActiveList.Items.Strings[i];
      szIPaddr := Trim(GetValidStr3(szIPaddr, szChrName, [' ']));
      if (szIPaddr = '') or (szIPaddr = Char(15)) then
        szIPaddr := szChrName;
      UserObj := TSessionObj(ListBoxActiveList.Items.Objects[i]);
      if (UserObj <> nil) and (UserObj.m_tLastGameSvr <> nil) and (UserObj.m_tLastGameSvr.Active) then
      begin
        fExists := False;
        for ii := 0 to ListBoxBlockList.Items.Count - 1 do
        begin
          if Integer(ListBoxBlockList.Items.Objects[ii]) = UserObj.m_pUserOBJ.nIPaddr then
          begin
            fExists := True;
            Break;
          end;
        end;
        if not fExists then
        begin
          ListBoxBlockList.Items.AddObject(szIPaddr, TObject(UserObj.m_pUserOBJ.nIPaddr));
          g_BlockIPList.AddObject(szIPaddr, TObject(UserObj.m_pUserOBJ.nIPaddr));
        end;
        Misc.CloseIPConnect(UserObj.m_pUserOBJ.nIPaddr);
      end;
    end;
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmPacketRule.APOPMENU_AddToPunishListClick(Sender: TObject);
var
  n: Integer;
  szChrName: string;
  UserObj: TSessionObj;
begin
  if (ListBoxActiveList.ItemIndex >= 0) and (ListBoxActiveList.ItemIndex < ListBoxActiveList.Items.Count) then
  begin
    UserObj := TSessionObj(ListBoxActiveList.Items.Objects[ListBoxActiveList.ItemIndex]);
    if (UserObj <> nil) and (UserObj.m_tLastGameSvr <> nil) and (UserObj.m_tLastGameSvr.Active) then
    begin
      szChrName := UserObj.m_szTrimChrName;
      if szChrName <> '' then
      begin
        if Application.MessageBox(PChar(Format('是否确认将 %s 加入限速列表？', [szChrName])), '确认信息',
          MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
          Exit;
        n := g_PunishList.IndexOf(szChrName);
        if n >= 0 then
        begin
          MessageBox(0, PChar(szChrName + ' 已存在于列表中...'), '提示', MB_OK + MB_ICONINFORMATION);
          Exit;
        end;
        ListBoxSpeedLimitList.Items.AddObject(szChrName, TObject(UserObj));
        g_PunishList.AddObject(szChrName, TObject(UserObj));
        UserObj.m_fSpeedLimit := True;
        g_PunishList.SaveToFile(_STR_PUNISH_USER_FILE);
      end;
    end;
  end;
end;

procedure TfrmPacketRule.ListBoxAbuseFilterTextClick(Sender: TObject);
begin
  if (ListBoxAbuseFilterText.ItemIndex >= 0) and (ListBoxAbuseFilterText.ItemIndex < ListBoxAbuseFilterText.Items.Count) then
  begin
    btnAbuseDel.Enabled := True;
    btnAbuseMod.Enabled := True;
  end;
end;

procedure TfrmPacketRule.ListBoxAbuseFilterTextDblClick(Sender: TObject);
begin
  btnAbuseModClick(Sender);
end;

procedure TfrmPacketRule.ListBoxIPAreaFilterDblClick(Sender: TObject);
begin
  MenuItem_IPAreaModClick(nil);
end;

procedure TfrmPacketRule.MemoCmdFilterChange(Sender: TObject);
begin
  if not m_ShowOpen then
    Exit;
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.MenuItem_SpeedLimitPunish_RenewClick(Sender: TObject);
var
  i: Integer;
begin
  ListBoxSpeedLimitList.Clear;
  for i := 0 to g_PunishList.Count - 1 do
  begin
    ListBoxSpeedLimitList.Items.AddObject(g_PunishList[i], g_PunishList.Objects[i]);
  end;
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.MenuItem_BlockHWIDList_AddClick(Sender: TObject);
var
  szHWID: string;
begin
  with ListBoxBlockHWIDList do
  begin
    szHWID := '';
    if not InputQuery('增加', '请注意输入格式为32个16进制字节码', szHWID) then
      Exit;
    if Length(szHWID) <> 32 then
      Exit;
    if ListBoxBlockHWIDList.Items.IndexOf(szHWID) < 0 then
      ListBoxBlockHWIDList.Items.Add(szHWID);
    if g_HWIDFilter.AddDeny(MD5UnPrint(szHWID)) >= 0 then
      btnSave.Enabled := True;
  end;
end;

procedure TfrmPacketRule.MenuItem_BlockHWIDList_DelAllClick(Sender: TObject);
var
  i: Integer;
  szHWID: string;
begin
  with ListBoxBlockHWIDList do
  begin
    ListBoxBlockHWIDList.Clear;
    g_HWIDFilter.ClearDeny();
    btnSave.Enabled := True;
  end;
end;

procedure TfrmPacketRule.MenuItem_BlockHWIDList_DelClick(Sender: TObject);
var
  szHWID: string;
begin
  with ListBoxBlockHWIDList do
  begin
    if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
    begin

      szHWID := Items[ItemIndex];
      if szHWID = '' then
        Exit;
      ListBoxBlockHWIDList.Items.Delete(ItemIndex);
      if g_HWIDFilter.DelDeny(MD5UnPrint(szHWID)) >= 0 then
        btnSave.Enabled := True;
    end;
  end;
end;

procedure TfrmPacketRule.MenuItem_CurHWIDList_AddToBlockListClick(Sender: TObject);
var
  szHWID: string;
  i: Integer;
  UserObj: TSessionObj;
  xHWID: MD5.MD5Digest;
begin
  if (ListViewCurHWIDList.ItemIndex >= 0) and (ListViewCurHWIDList.ItemIndex < ListViewCurHWIDList.Items.Count) then
  begin
    szHWID := ListViewCurHWIDList.Items.Item[ListViewCurHWIDList.ItemIndex].Caption;

    if Application.MessageBox(
      PChar('是否确认将' + szHWID + '加入黑名单中？'#13#10 +
      '加入黑名单后，符合此识别码的连接将被强行中断。'),
      PChar('确认信息'),
      MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
      Exit;

    if ListBoxBlockHWIDList.Items.IndexOf(szHWID) < 0 then
      ListBoxBlockHWIDList.Items.Add(szHWID);
    xHWID := MD5UnPrint(szHWID);
    if g_HWIDFilter.AddDeny(xHWID) >= 0 then
      btnSave.Enabled := True;

    for i := 0 to USER_ARRAY_COUNT - 1 do
    begin
      UserObj := g_UserList[i];
      if (UserObj <> nil) and (UserObj.m_tLastGameSvr <> nil) and (UserObj.m_tLastGameSvr.Active) and not UserObj.m_fKickFlag then
      begin
        if MD5Match(UserObj.m_xHWID, xHWID) then
          SHSocket.FreeSocket(UserObj.m_pUserOBJ._SendObj.Socket);
      end;
    end;
    ListViewCurHWIDList.Items.Delete(ListViewCurHWIDList.ItemIndex);
  end;
end;

procedure TfrmPacketRule.MenuItem_CurHWIDList_AllAddToBlockListClick(Sender: TObject);
var
  i: Integer;
  szHWID: string;
  UserObj: TSessionObj;
begin
  if (ListViewCurHWIDList.Items.Count > 0) then
  begin
    if Application.MessageBox(
      PChar('是否确认将所有识别码加入黑名单中？'#13#10 +
      '加入黑名单后，所有当前在线玩家将被强行中断！！！'),
      PChar('确认信息'),
      MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
      Exit;
    for i := 0 to ListViewCurHWIDList.Items.Count - 1 do
    begin
      szHWID := ListViewCurHWIDList.Items.Item[i].Caption;
      if ListBoxBlockHWIDList.Items.IndexOf(szHWID) < 0 then
        ListBoxBlockHWIDList.Items.Add(szHWID);
      if g_HWIDFilter.AddDeny(MD5UnPrint(szHWID)) >= 0 then
        btnSave.Enabled := True;
    end;
    for i := 0 to USER_ARRAY_COUNT - 1 do
    begin
      UserObj := g_UserList[i];
      if (UserObj <> nil) and (UserObj.m_tLastGameSvr <> nil) and (UserObj.m_tLastGameSvr.Active) and not UserObj.m_fKickFlag then
      begin
        SHSocket.FreeSocket(UserObj.m_pUserOBJ._SendObj.Socket);
      end;
    end;
    ListViewCurHWIDList.Clear;
  end;
end;

procedure TfrmPacketRule.MenuItem_CurHWIDList_CopyHWIDClick(Sender: TObject);
var
  szHWID: string;
  i: Integer;
begin
  if (ListViewCurHWIDList.ItemIndex >= 0) and (ListViewCurHWIDList.ItemIndex < ListViewCurHWIDList.Items.Count) then
  begin
    szHWID := ListViewCurHWIDList.Items.Item[ListViewCurHWIDList.ItemIndex].Caption;
    if szHWID <> '' then
      Clipboard.AsText := szHWID;
  end;
end;

procedure TfrmPacketRule.MenuItem_CurHWIDList_FlushClick(Sender: TObject);
var
  n: Integer;
  UserObj: TSessionObj;
  ListItem: TListItem;
begin
  ListViewCurHWIDList.Items.BeginUpdate;
  ListViewCurHWIDList.Items.Clear;
  for n := 0 to USER_ARRAY_COUNT - 1 do
  begin
    UserObj := g_UserList[n];
    if (UserObj <> nil) and (UserObj.m_tLastGameSvr <> nil) and (UserObj.m_tLastGameSvr.Active) and not UserObj.m_fKickFlag then
    begin
      if not MD5Match(g_MD5EmptyDigest, UserObj.m_xHWID) then
      begin
        ListItem := ListViewCurHWIDList.Items.Add;
        ListItem.Caption := MD5.MD5Print(UserObj.m_xHWID);
        ListItem.SubItems.Add(UserObj.m_szTrimChrName);
        ListItem.SubItems.Add(IntToStr(g_HWIDFilter.GetItemCount(UserObj.m_xHWID)));
      end;
    end;
  end;
  ListViewCurHWIDList.Items.EndUpdate;
end;

procedure TfrmPacketRule.MenuItem_IPAreaAddClick(Sender: TObject);
var
  i: Integer;
  dwIPLow, dwIPHigh, dwtmp: DWORD;
  szIPArea: string;
  szIPLow, szIPHigh: string;
  pIPArea: pTIPArea;
begin
  szIPArea := '';
  if not InputQuery('IP段过滤', '输入一个由小到大的IP范围，中间用"-"号间隔', szIPArea) then
    Exit;
  if szIPArea = '' then
    Exit;
  if Pos('-', szIPArea) = 0 then
  begin
    MessageBox(0, '输入格式错误，正确格式如下：192.168.1.1-192.168.1.255', '错误', MB_OK + MB_ICONERROR);
    Exit;
  end;
  szIPHigh := GetValidStr3(szIPArea, szIPLow, ['-']);

  dwIPLow := Misc.ReverseIP(inet_addr(PChar(szIPLow)));
  dwIPHigh := Misc.ReverseIP(inet_addr(PChar(szIPHigh)));
  if (dwIPLow = INADDR_NONE) then
  begin
    MessageBox(0, '输入的低位IP格式错误', '错误', MB_OK + MB_ICONERROR);
    Exit;
  end;
  if (dwIPHigh = INADDR_NONE) then
  begin
    MessageBox(0, '输入的高位IP格式错误', '错误', MB_OK + MB_ICONERROR);
    Exit;
  end;

  if dwIPLow > dwIPHigh then
  begin
    dwtmp := dwIPLow;
    dwIPLow := dwIPHigh;
    dwIPHigh := dwtmp;
  end;

  New(pIPArea);
  pIPArea.Low := dwIPLow;
  pIPArea.High := dwIPHigh;
  for i := 0 to g_BlockIPAreaList.Count - 1 do
  begin
    if PInt64(pIPArea)^ = PInt64(ListBoxIPAreaFilter.Items.Objects[i])^ then
    begin
      MessageBox(0, '输入的IP范围已经存在于列表中！', '提示', MB_OK + MB_ICONWARNING);
      Dispose(pIPArea);
      Exit;
    end;
  end;

  ListBoxIPAreaFilter.Items.AddObject(szIPArea, TObject(pIPArea));
  g_BlockIPAreaList.AddObject(szIPArea, TObject(pIPArea));
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.MenuItem_IPAreaDelAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to g_BlockIPAreaList.Count - 1 do
  begin
    if g_BlockIPAreaList.Objects[i] <> nil then
      Dispose(PInt64(g_BlockIPAreaList.Objects[i]));
  end;
  ListBoxIPAreaFilter.Items.Clear;
  g_BlockIPAreaList.Clear;
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.MenuItem_IPAreaDelClick(Sender: TObject);
var
  i: Integer;
begin
  with ListBoxIPAreaFilter do
  begin
    if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
    begin
      if (ItemIndex < g_BlockIPAreaList.Count) and
        (PInt64(g_BlockIPAreaList.Objects[ItemIndex])^ = PInt64(Items.Objects[ItemIndex])^) then
      begin
        g_BlockIPAreaList.Delete(ItemIndex);
        Dispose(PInt64(g_BlockIPAreaList.Objects[ItemIndex]));
      end
      else
      begin
        for i := 0 to g_BlockIPAreaList.Count - 1 do
        begin
          if PInt64(g_BlockIPAreaList.Objects[i])^ = PInt64(Items.Objects[ItemIndex])^ then
          begin
            g_BlockIPAreaList.Delete(i);
            Dispose(PInt64(g_BlockIPAreaList.Objects[i]));
            Break;
          end;
        end;
      end;
      Items.Delete(ItemIndex);
      btnSave.Enabled := True;
    end;
  end;
end;

procedure TfrmPacketRule.MenuItem_IPAreaModClick(Sender: TObject);
var
  i: Integer;
  dwIPLow, dwIPHigh, dwtmp: DWORD;
  szIPArea: string;
  szIPLow, szIPHigh: string;
  IPArea: pTIPArea;
begin
  with ListBoxIPAreaFilter do
  begin
    if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
    begin

      szIPArea := Items[ItemIndex];
      if not InputQuery('IP段过滤修改', '请注意输入格式(192.168.1.1-192.168.1.255)', szIPArea) then
        Exit;
      if szIPArea = '' then
        Exit;
      if Pos('-', szIPArea) = 0 then
      begin
        MessageBox(0, '输入格式错误，正确格式如下：192.168.1.1-192.168.1.255', '错误', MB_OK + MB_ICONERROR);
        Exit;
      end;
      szIPHigh := GetValidStr3(szIPArea, szIPLow, ['-']);

      dwIPLow := Misc.ReverseIP(inet_addr(PChar(szIPLow)));
      dwIPHigh := Misc.ReverseIP(inet_addr(PChar(szIPHigh)));
      if (dwIPLow = INADDR_NONE) then
      begin
        MessageBox(0, '输入的低位IP格式错误', '错误', MB_OK + MB_ICONERROR);
        Exit;
      end;
      if (dwIPHigh = INADDR_NONE) then
      begin
        MessageBox(0, '输入的高位IP格式错误', '错误', MB_OK + MB_ICONERROR);
        Exit;
      end;

      if dwIPLow > dwIPHigh then
      begin
        dwtmp := dwIPLow;
        dwIPLow := dwIPHigh;
        dwIPHigh := dwtmp;
      end;

      if (ItemIndex < g_BlockIPAreaList.Count) and
        (PInt64(g_BlockIPAreaList.Objects[ItemIndex])^ = PInt64(Items.Objects[ItemIndex])^) then
      begin
        Items[ItemIndex] := szIPArea;
        g_BlockIPAreaList[ItemIndex] := szIPArea;
        pTIPArea(g_BlockIPAreaList.Objects[ItemIndex])^.Low := dwIPLow;
        pTIPArea(g_BlockIPAreaList.Objects[ItemIndex])^.High := dwIPHigh;
      end
      else
      begin
        for i := 0 to g_BlockIPAreaList.Count - 1 do
        begin
          if PInt64(g_BlockIPAreaList.Objects[i])^ = PInt64(Items.Objects[ItemIndex])^ then
          begin
            Items[ItemIndex] := szIPArea;
            g_BlockIPAreaList[i] := szIPArea;
            pTIPArea(g_BlockIPAreaList.Objects[i])^.Low := dwIPLow;
            pTIPArea(g_BlockIPAreaList.Objects[i])^.High := dwIPHigh;
            Break;
          end;
        end;
      end;
      btnSave.Enabled := True;
    end;
  end;
end;

procedure TfrmPacketRule.MenuItem_SpeedLimitPunish_AddClick(Sender: TObject);
var
  i, n: Integer;
  szChrName: string;
  UserObj: TSessionObj;
begin
  szChrName := '';
  if not InputQuery('限制速度玩家', '请输入一个新玩家名字: ', szChrName) then
    Exit;
  i := g_PunishList.IndexOf(szChrName);
  if i >= 0 then
  begin
    MessageBox(0, '该玩家名字已存在于列表中...', '提示', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  for n := 0 to USER_ARRAY_COUNT - 1 do
  begin
    UserObj := g_UserList[n];
    if (UserObj <> nil) and (UserObj.m_tLastGameSvr <> nil) and (UserObj.m_tLastGameSvr.Active) then
    begin
      if CompareText(szChrName, UserObj.m_szTrimChrName) = 0 then
      begin
        ListBoxSpeedLimitList.Items.AddObject(szChrName, TObject(UserObj));
        g_PunishList.AddObject(szChrName, TObject(UserObj));
        UserObj.m_fSpeedLimit := True;
        Exit;
      end;
    end;
  end;

  ListBoxSpeedLimitList.Items.AddObject(szChrName, nil);
  g_PunishList.AddObject(szChrName, nil);
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.MenuItem_SpeedLimitPunish_DelClick(Sender: TObject);
var
  i: Integer;
  szChrName: string;
  UserObj: TSessionObj;
begin
  if (ListBoxSpeedLimitList.ItemIndex >= 0) and (ListBoxSpeedLimitList.ItemIndex < ListBoxSpeedLimitList.Items.Count) then
  begin
    szChrName := ListBoxSpeedLimitList.Items.Strings[ListBoxSpeedLimitList.ItemIndex];
    ListBoxSpeedLimitList.Items.Delete(ListBoxSpeedLimitList.ItemIndex);

    i := g_PunishList.IndexOf(szChrName);
    if i >= 0 then
    begin
      UserObj := TSessionObj(g_PunishList.Objects[i]);
      if UserObj <> nil then
        UserObj.m_fSpeedLimit := False;
      g_PunishList.Delete(i);
      btnSave.Enabled := True;
    end;
  end;
end;

procedure TfrmPacketRule.MenuItem_SpeedLimitPunish_DelAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to g_PunishList.Count - 1 do
    if g_PunishList.Objects[i] <> nil then
      TSessionObj(g_PunishList.Objects[i]).m_fSpeedLimit := False;
  ListBoxSpeedLimitList.Items.Clear;
  g_PunishList.Clear;
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.APOPMENU_AllToTempBLOCKLISTClick(Sender: TObject);
var
  fExists: Boolean;
  i, ii: Integer;
  UserObj: TSessionObj;
  szChrName, szIPaddr: string;
begin
  if (0 < ListBoxActiveList.Items.Count) then
  begin
    if Application.MessageBox(
      PChar('是否确认将此所有的IP连接加入动态过滤列表中？'#13#10'加入过滤列表后，列表中IP建立的所有连接将被强行中断。'),
      PChar('确认信息'),
      MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
      Exit;
    for i := 0 to ListBoxActiveList.Items.Count - 1 do
    begin
      szIPaddr := ListBoxActiveList.Items.Strings[i];
      szIPaddr := Trim(GetValidStr3(szIPaddr, szChrName, [' ']));
      if (szIPaddr = '') or (szIPaddr = Char(15)) then
        szIPaddr := szChrName;
      UserObj := TSessionObj(ListBoxActiveList.Items.Objects[i]);
      if (UserObj <> nil) and (UserObj.m_tLastGameSvr <> nil) and (UserObj.m_tLastGameSvr.Active) then
      begin
        fExists := False;
        for ii := 0 to ListBoxBlockList.Items.Count - 1 do
        begin
          if Integer(ListBoxBlockList.Items.Objects[ii]) = UserObj.m_pUserOBJ.nIPaddr then
          begin
            fExists := True;
            Break;
          end;
        end;
        if not fExists then
        begin
          ListBoxTempList.Items.AddObject(szIPaddr, TObject(UserObj.m_pUserOBJ.nIPaddr));
          g_TempBlockIPList.AddObject(szIPaddr, TObject(UserObj.m_pUserOBJ.nIPaddr));
        end;
        Misc.CloseIPConnect(UserObj.m_pUserOBJ.nIPaddr);
      end;
    end;
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmPacketRule.TPOPMENU_ALLTOBLOCKLISTClick(Sender: TObject);
var
  i: Integer;
  szIPaddr: string;
begin
  if (ListBoxTempList.Items.Count > 0) then
  begin
    for i := 0 to ListBoxTempList.Items.Count - 1 do
    begin
      szIPaddr := ListBoxTempList.Items.Strings[i];
      if ListBoxBlockList.Items.IndexOf(szIPaddr) < 0 then
      begin
        ListBoxBlockList.Items.AddObject(szIPaddr, ListBoxTempList.Items.Objects[i]);
        g_BlockIPList.AddObject(szIPaddr, ListBoxTempList.Items.Objects[i]);
      end;
    end;
    ListBoxTempList.Items.Clear;
    g_TempBlockIPList.Clear;
  end;
end;

procedure TfrmPacketRule.APOPMENU_AllNullNameToBLOCKLISTClick(Sender: TObject);
var
  i, nIPaddr: Integer;
  szChrName, szIPaddr: string;
begin
  if (0 < ListBoxActiveList.Items.Count) then
  begin
    if Application.MessageBox(
      PChar('是否确认将此所有的空名字IP连接加入动态过滤列表中？'#13#10'加入过滤列表后，列表中IP建立的所有连接将被强行中断。'),
      PChar('确认信息'),
      MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
      Exit;
    for i := 0 to ListBoxActiveList.Items.Count - 1 do
    begin
      szIPaddr := ListBoxActiveList.Items.Strings[i];
      szIPaddr := Trim(GetValidStr3(szIPaddr, szChrName, [' ']));
      if ((szIPaddr = '') or (szIPaddr = Char(15))) and (szChrName <> '') then
      begin
        nIPaddr := inet_addr(PChar(szChrName));
        if nIPaddr <> INADDR_NONE then
        begin
          if ListBoxTempList.Items.IndexOf(szChrName) < 0 then
          begin
            ListBoxTempList.Items.AddObject(szChrName, TObject(nIPaddr));
            g_TempBlockIPList.AddObject(szChrName, TObject(nIPaddr));
          end;
          CloseIPConnect(nIPaddr);
        end;
      end;
    end;
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmPacketRule.PopupMenuSpeedLimitPopup(Sender: TObject);
var
  boCheck: Boolean;
begin
  boCheck := ListBoxSpeedLimitList.Items.Count > 0;
  MenuItem_SpeedLimitPunish_DelAll.Enabled := boCheck;
  boCheck := (ListBoxSpeedLimitList.ItemIndex >= 0) and (ListBoxSpeedLimitList.ItemIndex < ListBoxSpeedLimitList.Items.Count);
  MenuItem_SpeedLimitPunish_Del.Enabled := boCheck;
end;

procedure TfrmPacketRule.PopupMenu_BlockHWIDListPopup(Sender: TObject);
begin
  MenuItem_BlockHWIDList_DelAll.Enabled := ListBoxBlockHWIDList.Items.Count > 0;
  MenuItem_BlockHWIDList_Del.Enabled := (ListBoxBlockHWIDList.ItemIndex >= 0) and (ListBoxBlockHWIDList.ItemIndex < ListBoxBlockHWIDList.Items.Count);
end;

procedure TfrmPacketRule.PopupMenu_CurHWIDListPopup(Sender: TObject);
var
  boCheck: Boolean;
begin
  MenuItem_CurHWIDList_CopyHWID.Enabled := ListViewCurHWIDList.Items.Count > 0;
  MenuItem_CurHWIDList_AllAddToBlockList.Enabled := ListViewCurHWIDList.Items.Count > 0;
  boCheck := (ListViewCurHWIDList.ItemIndex >= 0) and (ListViewCurHWIDList.ItemIndex < ListViewCurHWIDList.Items.Count);
  MenuItem_CurHWIDList_CopyHWID.Enabled := boCheck;
  MenuItem_CurHWIDList_AddToBlockList.Enabled := boCheck;
end;

procedure TfrmPacketRule.PopupMenu_IPAreaFilterPopup(Sender: TObject);
var
  boCheck: Boolean;
begin
  MenuItem_IPAreaDelAll.Enabled := ListBoxIPAreaFilter.Items.Count > 0;
  MenuItem_IPAreaDel.Enabled := (ListBoxIPAreaFilter.ItemIndex >= 0) and (ListBoxIPAreaFilter.ItemIndex < ListBoxIPAreaFilter.Items.Count);
  MenuItem_IPAreaMod.Enabled := MenuItem_IPAreaDel.Enabled;
end;

procedure TfrmPacketRule.rdDisConnectClick(Sender: TObject);
var
  tLastBlockMethod: TBlockIPMethod;
begin
  tLastBlockMethod := g_pConfig.m_tBlockIPMethod;
  if Sender = rdDisConnect then
  begin
    if rdDisConnect.Checked then
      g_pConfig.m_tBlockIPMethod := mDisconnect;
  end
  else if Sender = rdAddBlockList then
  begin
    if rdAddBlockList.Checked then
      g_pConfig.m_tBlockIPMethod := mBlockList;
  end
  else if Sender = rdAddTempList then
  begin
    if rdAddTempList.Checked then
      g_pConfig.m_tBlockIPMethod := mBlock;
  end;
  if tLastBlockMethod <> g_pConfig.m_tBlockIPMethod then
    btnSave.Enabled := True;
end;

procedure TfrmPacketRule.btnAbuseAddClick(Sender: TObject);
var
  sInputText: string;
begin
  if not InputQuery('增加过滤文字', '请输入新的文字:', sInputText) then
    Exit;
  if sInputText = '' then
  begin
    Application.MessageBox('输入的字符不能为空！', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  if ListBoxAbuseFilterText.Items.IndexOf(sInputText) >= 0 then
  begin
    Application.MessageBox('输入的字符已经存在！', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  ListBoxAbuseFilterText.Items.Add(sInputText);
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.btnAbuseDelClick(Sender: TObject);
var
  nSelectIndex: Integer;
begin
  nSelectIndex := ListBoxAbuseFilterText.ItemIndex;
  if (nSelectIndex >= 0) and (nSelectIndex < ListBoxAbuseFilterText.Items.Count) then
  begin
    ListBoxAbuseFilterText.Items.Delete(nSelectIndex);
    btnSave.Enabled := True;
  end;
  if nSelectIndex >= ListBoxAbuseFilterText.Items.Count then
    ListBoxAbuseFilterText.ItemIndex := nSelectIndex - 1
  else
    ListBoxAbuseFilterText.ItemIndex := nSelectIndex;
  if ListBoxAbuseFilterText.ItemIndex < 0 then
  begin
    btnAbuseDel.Enabled := False;
    btnAbuseMod.Enabled := False;
  end;
end;

procedure TfrmPacketRule.btnAbuseModClick(Sender: TObject);
var
  sInputText: string;
begin
  if (ListBoxAbuseFilterText.ItemIndex >= 0) and (ListBoxAbuseFilterText.ItemIndex < ListBoxAbuseFilterText.Items.Count) then
  begin
    sInputText := ListBoxAbuseFilterText.Items[ListBoxAbuseFilterText.ItemIndex];
    if not InputQuery('增加过滤文字', '请输入新的文字:', sInputText) then
      Exit;
  end;
  if sInputText = '' then
  begin
    Application.MessageBox('输入的字符不能为空！', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  ListBoxAbuseFilterText.Items[ListBoxAbuseFilterText.ItemIndex] := sInputText;
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.FormCreate(Sender: TObject);
begin
  m_ShowOpen := False;
  ListBoxActiveList.Clear;
  ListBoxTempList.Clear;
  ListBoxBlockList.Clear;

  Label35.Visible := False;
  etPacketDecryptErrMsg.Visible := False;
  Label36.Visible := False;
  etCDVersionErrMsg.Visible := False;

end;

procedure TfrmPacketRule.BPOPMENU_DELETE_ALLClick(Sender: TObject);
begin
  ListBoxBlockList.Items.Clear;
  g_BlockIPList.Clear;
end;

procedure TfrmPacketRule.ActiveListPopupMenuPopup(Sender: TObject);
var
  boCheck: Boolean;
begin
  APOPMENU_SORT.Enabled := ListBoxActiveList.Items.Count > 0;
  boCheck := (ListBoxActiveList.ItemIndex >= 0) and (ListBoxActiveList.ItemIndex < ListBoxActiveList.Items.Count);
  APOPMENU_ADDTEMPLIST.Enabled := boCheck;
  APOPMENU_BLOCKLIST.Enabled := boCheck;
  APOPMENU_KICK.Enabled := boCheck;
  APOPMENU_AddToPunishList.Enabled := boCheck;
  APOPMENU_AllToBLOCKLIST.Enabled := boCheck;
  APOPMENU_AddAllToPunishList.Enabled := boCheck;
  APOPMENU_AllToTempBLOCKLIST.Enabled := boCheck;
  APOPMENU_AllNullNameToBLOCKLIST.Enabled := boCheck;
end;

procedure TfrmPacketRule.TempBlockListPopupMenuPopup(Sender: TObject);
var
  boCheck: Boolean;
begin
  TPOPMENU_SORT.Enabled := ListBoxTempList.Items.Count > 0;
  TPOPMENU_DELETE_ALL.Enabled := ListBoxTempList.Items.Count > 0;
  boCheck := (ListBoxTempList.ItemIndex >= 0) and (ListBoxTempList.ItemIndex < ListBoxTempList.Items.Count);
  TPOPMENU_AddtoBLOCKLIST.Enabled := boCheck;
  TPOPMENU_DELETE.Enabled := boCheck;
  TPOPMENU_ALLTOBLOCKLIST.Enabled := True;
end;

procedure TfrmPacketRule.BlockListPopupMenuPopup(Sender: TObject);
var
  boCheck: Boolean;
begin
  BPOPMENU_SORT.Enabled := ListBoxBlockList.Items.Count > 0;
  BPOPMENU_DELETE_ALL.Enabled := ListBoxBlockList.Items.Count > 0;
  boCheck := (ListBoxBlockList.ItemIndex >= 0) and (ListBoxBlockList.ItemIndex < ListBoxBlockList.Items.Count);
  BPOPMENU_ADDTEMPLIST.Enabled := boCheck;
  BPOPMENU_DELETE.Enabled := boCheck;
  BPOPMENU_ALLTOTEMPLIST.Enabled := boCheck;
end;

procedure TfrmPacketRule.APOPMENU_SORTClick(Sender: TObject);
begin
  ListBoxActiveList.Sorted := True;
end;

procedure TfrmPacketRule.APOPMENU_AddAllToPunishListClick(Sender: TObject);
var
  i, n, nCnt: Integer;
  szChrName: string;
  UserObj: TSessionObj;
begin
  if Application.MessageBox(PChar(Format('是否确认将所有在线的%d位玩家加入到限速列表？',
    [ListBoxActiveList.Items.Count])), '确认信息',
    MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
    Exit;
  nCnt := 0;
  for i := 0 to ListBoxActiveList.Items.Count - 1 do
  begin
    UserObj := TSessionObj(ListBoxActiveList.Items.Objects[i]);
    if (UserObj <> nil) and (UserObj.m_tLastGameSvr <> nil) and (UserObj.m_tLastGameSvr.Active) then
    begin
      szChrName := UserObj.m_szTrimChrName;
      if szChrName <> '' then
      begin
        n := g_PunishList.IndexOf(szChrName);
        if n >= 0 then
          Continue;
        ListBoxSpeedLimitList.Items.AddObject(UserObj.m_szChrName, TObject(UserObj));
        g_PunishList.AddObject(UserObj.m_szTrimChrName, TObject(UserObj));
        UserObj.m_fSpeedLimit := True;
        btnSave.Enabled := True;
        Inc(nCnt);
      end;
    end;
  end;
  if nCnt > 0 then
    g_PunishList.SaveToFile(_STR_PUNISH_USER_FILE);
end;

procedure TfrmPacketRule.APOPMENU_ADDTEMPLISTClick(Sender: TObject);
var
  fExists: Boolean;
  i, nIPaddr: Integer;
  szChrName, szIPaddr: string;
begin
  if (ListBoxActiveList.ItemIndex >= 0) and (ListBoxActiveList.ItemIndex < ListBoxActiveList.Items.Count) then
  begin
    szIPaddr := ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex];
    szIPaddr := Trim(GetValidStr3(szIPaddr, szChrName, [' ']));
    if (szIPaddr = '') or (szIPaddr = Char(15)) then
      szIPaddr := szChrName;
    if Application.MessageBox(PChar('是否确认将此IP: ' + szIPaddr + ' 加入动态过滤列表中？'#13#10'加入过滤列表后，此IP建立的所有连接将被强行中断。'), PChar('确认信息'),
      MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
      Exit;
    nIPaddr := inet_addr(PChar(szIPaddr));
    if nIPaddr <> INADDR_NONE then
    begin
      fExists := False;
      for i := 0 to ListBoxTempList.Items.Count - 1 do
      begin
        if Integer(ListBoxTempList.Items.Objects[i]) = nIPaddr then
        begin
          fExists := True;
          Break;
        end;
      end;
      if not fExists then
      begin
        ListBoxTempList.Items.AddObject(szIPaddr, TObject(nIPaddr));
        g_TempBlockIPList.AddObject(szIPaddr, TObject(nIPaddr));
      end;
      Misc.CloseIPConnect(nIPaddr);
    end;
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmPacketRule.APOPMENU_BLOCKLISTClick(Sender: TObject);
var
  fExists: Boolean;
  i, nIPaddr: Integer;
  szChrName, szIPaddr: string;
begin
  if (ListBoxActiveList.ItemIndex >= 0) and (ListBoxActiveList.ItemIndex < ListBoxActiveList.Items.Count) then
  begin
    szIPaddr := ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex];
    szIPaddr := Trim(GetValidStr3(szIPaddr, szChrName, [' ']));
    if (szIPaddr = '') or (szIPaddr = Char(15)) then
      szIPaddr := szChrName;
    if Application.MessageBox(PChar('是否确认将此IP: ' + szIPaddr + ' 加入永久过滤列表中？'#13#10'加入过滤列表后，此IP建立的所有连接将被强行中断。'),
      PChar('确认信息'), MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
      Exit;
    nIPaddr := inet_addr(PChar(szIPaddr));
    if nIPaddr <> INADDR_NONE then
    begin
      fExists := False;
      for i := 0 to ListBoxBlockList.Items.Count - 1 do
      begin
        if Integer(ListBoxBlockList.Items.Objects[i]) = nIPaddr then
        begin
          fExists := True;
          Break;
        end;
      end;
      if not fExists then
      begin
        ListBoxBlockList.Items.AddObject(szIPaddr, TObject(nIPaddr));
        g_BlockIPList.AddObject(szIPaddr, TObject(nIPaddr));
      end;
      Misc.CloseIPConnect(nIPaddr);
    end;
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmPacketRule.APOPMENU_KICKClick(Sender: TObject);
var
  UserObj: TSessionObj;
begin
  if (ListBoxActiveList.ItemIndex >= 0) and (ListBoxActiveList.ItemIndex < ListBoxActiveList.Items.Count) then
  begin
    if Application.MessageBox(PChar('是否确认将 ' + ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex] + ' 的连接断开？'), PChar('确认信息'), MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
      Exit;
    UserObj := TSessionObj(ListBoxActiveList.Items.Objects[ListBoxActiveList.ItemIndex]);
    if (UserObj <> nil) and (UserObj.m_tLastGameSvr <> nil) and (UserObj.m_tLastGameSvr.Active) and not UserObj.m_fKickFlag then
    begin
      if UserObj.m_fHandleLogin >= 2 then
      begin
        UserObj.SendDefMessage(SM_OUTOFCONNECTION, UserObj.m_nSvrObject, 0, 0, 0, '');
        UserObj.m_fKickFlag := True;
      end
      else
        SHSocket.FreeSocket(UserObj.m_pUserOBJ._SendObj.Socket);
    end;
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmPacketRule.TPOPMENU_REFLISTClick(Sender: TObject);
var
  i: Integer;
begin
  ListBoxTempList.Clear;
  for i := 0 to g_TempBlockIPList.Count - 1 do
    ListBoxTempList.Items.AddObject(g_TempBlockIPList.Strings[i], g_TempBlockIPList.Objects[i]);
end;

procedure TfrmPacketRule.TPOPMENU_SORTClick(Sender: TObject);
begin
  ListBoxTempList.Sorted := True;
end;

procedure TfrmPacketRule.TrackBarAttackSpdChange(Sender: TObject);
var
  i, nSpeed: Integer;
begin
  if not m_ShowOpen then
    Exit;
  with g_pConfig, (Sender as TTrackBar) do
  begin
    if Tag = 0 then
    begin
      InterlockedExchange(m_nClientAttackSpeedRate, Position);
      nSpeed := _Max(300, 900 - m_nClientAttackSpeedRate * 20);
      Label31.Caption := IntToStr(m_nClientAttackSpeedRate) + ' 建议值:' + IntToStr(nSpeed);
      if cbSyncSpeedRate.Checked then
      begin
        m_nAttackInterval := nSpeed;
        speAttackInterval.Value := m_nAttackInterval;
        speAttackInterval.Update;
        m_nSitDownInterval := _Max(150, 450 - m_nClientAttackSpeedRate * 10);
        speSitDownInterval.Value := m_nSitDownInterval;
        speSitDownInterval.Update;
      end;
    end
    else if Tag = 1 then
    begin
      InterlockedExchange(m_nClientSpellSpeedRate, Position);
      nSpeed := _MIN(400, m_nClientSpellSpeedRate * 20);
      Label32.Caption := IntToStr(m_nClientSpellSpeedRate) + ' 建议值:' + IntToStr(nSpeed);
      if cbSyncSpeedRate.Checked then
      begin
        for i := Low(MAIGIC_DELAY_TIME_LIST) + 1 to High(MAIGIC_DELAY_TIME_LIST) do
        begin
          if MAIGIC_NAME_LIST[i] <> '' then
          begin
            MAIGIC_DELAY_TIME_LIST[i] := _Max(400, MAIGIC_DELAY_TIME_LIST_DEF[i] - m_nClientSpellSpeedRate * 20);
          end;
        end;
        if (cbxMagicList.Items.Count > 0) and (cbxMagicList.ItemIndex >= 0) then
        begin
          i := Integer(cbxMagicList.Items.Objects[cbxMagicList.ItemIndex]);
          speSpellInterval.Value := MAIGIC_DELAY_TIME_LIST[i];
          speSpellInterval.Update;
        end;
      end;
    end
    else if Tag = 2 then
    begin
      InterlockedExchange(m_nClientMoveSpeedRate, Position);
      nSpeed := _Max(50, (95 - m_nClientMoveSpeedRate div 2)) * 6;
      Label33.Caption := IntToStr(m_nClientMoveSpeedRate) + ' 建议值:' + IntToStr(nSpeed);
      if cbSyncSpeedRate.Checked then
      begin
        m_nMoveInterval := nSpeed;
        speMoveInterval.Value := m_nMoveInterval;
        speMoveInterval.Update;
      end;
    end;
  end;
  btnSave.Enabled := True;
end;

procedure TfrmPacketRule.TPOPMENU_ADDClick(Sender: TObject);
var
  nIPaddr: Integer;
  szIPaddr: string;
begin
  szIPaddr := '';
  if not InputQuery('永久IP过滤', '请输入一个新的IP地址: ', szIPaddr) then
    Exit;
  nIPaddr := inet_addr(PChar(szIPaddr));
  if nIPaddr <> INADDR_NONE then
  begin
    ListBoxTempList.Items.AddObject(szIPaddr, TObject(nIPaddr));
    g_TempBlockIPList.AddObject(szIPaddr, TObject(nIPaddr));
  end
  else
    Application.MessageBox('输入的地址格式错误！', '错误信息', MB_OK + MB_ICONERROR);
end;

procedure TfrmPacketRule.TPOPMENU_AddtoBLOCKLISTClick(Sender: TObject);
var
  szIPaddr: string;
  i: Integer;
begin
  if (ListBoxTempList.ItemIndex >= 0) and (ListBoxTempList.ItemIndex < ListBoxTempList.Items.Count) then
  begin
    szIPaddr := ListBoxTempList.Items.Strings[ListBoxTempList.ItemIndex];

    if (ListBoxTempList.ItemIndex < g_TempBlockIPList.Count) and (g_TempBlockIPList[ListBoxTempList.ItemIndex] = szIPaddr) then
    begin
      g_TempBlockIPList.Delete(ListBoxTempList.ItemIndex);
    end
    else
    begin
      for i := 0 to g_TempBlockIPList.Count - 1 do
      begin
        if g_TempBlockIPList.Strings[i] = szIPaddr then
        begin
          g_TempBlockIPList.Delete(i);
          Break;
        end;
      end;
    end;
    ListBoxBlockList.Items.AddObject(szIPaddr, ListBoxTempList.Items.Objects[ListBoxTempList.ItemIndex]);
    g_BlockIPList.AddObject(szIPaddr, ListBoxTempList.Items.Objects[ListBoxTempList.ItemIndex]);
    ListBoxTempList.Items.Delete(ListBoxTempList.ItemIndex);
  end;
end;

procedure TfrmPacketRule.TPOPMENU_DELETEClick(Sender: TObject);
var
  szIPaddr: string;
  i: Integer;
begin
  if (ListBoxTempList.ItemIndex >= 0) and (ListBoxTempList.ItemIndex < ListBoxTempList.Items.Count) then
  begin
    szIPaddr := ListBoxTempList.Items.Strings[ListBoxTempList.ItemIndex];
    if (ListBoxTempList.ItemIndex < g_TempBlockIPList.Count) and (g_TempBlockIPList[ListBoxTempList.ItemIndex] = szIPaddr) then
    begin
      g_TempBlockIPList.Delete(ListBoxTempList.ItemIndex);
      ListBoxTempList.Items.Delete(ListBoxTempList.ItemIndex);
    end;
    for i := 0 to g_TempBlockIPList.Count - 1 do
    begin
      if g_TempBlockIPList.Strings[i] = szIPaddr then
      begin
        g_TempBlockIPList.Delete(i);
        ListBoxTempList.Items.Delete(ListBoxTempList.ItemIndex);
        Break;
      end;
    end;
  end;
end;

procedure TfrmPacketRule.BPOPMENU_REFLISTClick(Sender: TObject);
var
  i: Integer;
begin
  ListBoxBlockList.Clear;
  for i := 0 to g_BlockIPList.Count - 1 do
    ListBoxBlockList.Items.AddObject(g_BlockIPList[i], g_BlockIPList.Objects[i]);
end;

procedure TfrmPacketRule.BPOPMENU_SORTClick(Sender: TObject);
begin
  ListBoxBlockList.Sorted := True;
end;

procedure TfrmPacketRule.BPOPMENU_ADDClick(Sender: TObject);
var
  nIPaddr: Integer;
  szIPaddr: string;
begin
  szIPaddr := '';
  if not InputQuery('永久IP过滤', '请输入一个新的IP地址: ', szIPaddr) then
    Exit;
  nIPaddr := inet_addr(PChar(szIPaddr));
  if nIPaddr <> INADDR_NONE then
  begin
    ListBoxBlockList.Items.AddObject(szIPaddr, TObject(nIPaddr));
    g_BlockIPList.AddObject(szIPaddr, TObject(nIPaddr));
  end
  else
    Application.MessageBox('输入的地址格式错误！', '错误信息', MB_OK + MB_ICONERROR);
end;

procedure TfrmPacketRule.BPOPMENU_ADDTEMPLISTClick(Sender: TObject);
var
  szIPaddr: string;
  i: Integer;
begin
  if (ListBoxBlockList.ItemIndex >= 0) and (ListBoxBlockList.ItemIndex < ListBoxBlockList.Items.Count) then
  begin
    szIPaddr := ListBoxBlockList.Items.Strings[ListBoxBlockList.ItemIndex];

    if (ListBoxBlockList.ItemIndex < g_BlockIPList.Count) and (g_BlockIPList[ListBoxBlockList.ItemIndex] = szIPaddr) then
    begin
      g_BlockIPList.Delete(ListBoxBlockList.ItemIndex);
    end
    else
    begin
      for i := 0 to g_BlockIPList.Count - 1 do
      begin
        if g_BlockIPList.Strings[i] = szIPaddr then
        begin
          g_BlockIPList.Delete(i);
          Break;
        end;
      end;
    end;
    ListBoxTempList.Items.AddObject(szIPaddr, ListBoxBlockList.Items.Objects[ListBoxBlockList.ItemIndex]);
    g_TempBlockIPList.AddObject(szIPaddr, ListBoxBlockList.Items.Objects[ListBoxBlockList.ItemIndex]);
    ListBoxBlockList.Items.Delete(ListBoxBlockList.ItemIndex);
  end;
end;

procedure TfrmPacketRule.BPOPMENU_DELETEClick(Sender: TObject);
var
  szIPaddr: string;
  i: Integer;
begin
  if (ListBoxBlockList.ItemIndex >= 0) and (ListBoxBlockList.ItemIndex < ListBoxBlockList.Items.Count) then
  begin
    szIPaddr := ListBoxBlockList.Items.Strings[ListBoxBlockList.ItemIndex];
    if (ListBoxBlockList.ItemIndex < g_BlockIPList.Count) and (g_BlockIPList[ListBoxBlockList.ItemIndex] = szIPaddr) then
    begin
      g_BlockIPList.Delete(ListBoxBlockList.ItemIndex);
    end
    else
    begin
      for i := 0 to g_BlockIPList.Count - 1 do
      begin
        if g_BlockIPList.Strings[i] = szIPaddr then
        begin
          g_BlockIPList.Delete(i);
          Break;
        end;
      end;
    end;
    ListBoxBlockList.Items.Delete(ListBoxBlockList.ItemIndex);
  end;
end;

end.
