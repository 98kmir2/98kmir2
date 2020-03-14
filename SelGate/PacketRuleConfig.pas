unit PacketRuleConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin, Menus, WinSock2, HUtil32, ExtCtrls, Mask;

type
  TfrmPacketRule = class(TForm)
    pcProcessPack: TPageControl;
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
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Label23: TLabel;
    ListBoxIPAreaFilter: TListBox;
    PopupMenu_IPAreaFilter: TPopupMenu;
    MenuItem_IPAreaAdd: TMenuItem;
    MenuItem_IPAreaDel: TMenuItem;
    MenuItem_IPAreaDelAll: TMenuItem;
    MenuItem_IPAreaMod: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    GroupBox1: TGroupBox;
    Label12: TLabel;
    Label14: TLabel;
    etMaxConnectOfIP: TSpinEdit;
    etClientTimeOutTime: TSpinEdit;
    cbDefenceCC: TCheckBox;
    cbCheckNullConnect: TCheckBox;
    GroupBoxNullConnect: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    etMaxClientMsgCount: TSpinEdit;
    etNomClientPacketSize: TSpinEdit;
    GroupBox7: TGroupBox;
    rdAddBlockList: TRadioButton;
    rdAddTempList: TRadioButton;
    rdDisConnect: TRadioButton;
    cbKickOverPacketSize: TCheckBox;
    btnChrNameFilterMod: TButton;
    btnChrNameFilterAdd: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    cbDenyNullChar: TCheckBox;
    cbDenySpecChar: TCheckBox;
    cbDenyHellenicChars: TCheckBox;
    cbDenyRussiaChar: TCheckBox;
    cbDenyAnsiChar: TCheckBox;
    TabSheet4: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cbDenySpecNO1: TCheckBox;
    cbDenySpecNO2: TCheckBox;
    cbDenySpecNO3: TCheckBox;
    cbDenySpecNO4: TCheckBox;
    cbDenySBCChar: TCheckBox;
    TabSheet5: TTabSheet;
    Label15: TLabel;
    Label16: TLabel;
    cbDenykanjiChar: TCheckBox;
    cbDenyTabs: TCheckBox;
    btnChrNameFilterDel: TButton;
    ListBoxChrNameFilter: TListBox;
    cbAllowGetBackChr: TCheckBox;
    Bevel1: TBevel;
    cbNewChrNameFilter: TCheckBox;
    cbAllowDeleteChr: TCheckBox;
    procedure btnSaveClick(Sender: TObject);
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
    procedure MemoCmdFilterChange(Sender: TObject);
    procedure rdDisConnectClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure PopupMenu_IPAreaFilterPopup(Sender: TObject);
    procedure MenuItem_IPAreaAddClick(Sender: TObject);
    procedure MenuItem_IPAreaDelClick(Sender: TObject);
    procedure MenuItem_IPAreaDelAllClick(Sender: TObject);
    procedure MenuItem_IPAreaModClick(Sender: TObject);
    procedure ListBoxIPAreaFilterDblClick(Sender: TObject);

    procedure etMaxConnectOfIPChange(Sender: TObject);

  public
    m_ShowOpen: Boolean;
  end;

var
  frmPacketRule: TfrmPacketRule;

implementation

uses
  AcceptExWorkedThread, ClientSession, IOCPTypeDef, ConfigManager,
  AppMain, Protocol, FuncForComm,
  IPAddrFilter, Misc, Grobal2, LogManager, SHSocket;

{$R *.dfm}

procedure TfrmPacketRule.TPOPMENU_DELETE_ALLClick(Sender: TObject);
begin
  ListBoxTempList.Items.Clear;
  g_TempBlockIPList.Clear;
end;

procedure TfrmPacketRule.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPacketRule.btnSaveClick(Sender: TObject);
var
  i: Integer;
begin
  btnSave.Enabled := False;

  g_pConfig.SaveConfig(1);

  SaveBlockIPList();
  SaveBlockIPAreaList();
end;


procedure TfrmPacketRule.etMaxConnectOfIPChange(Sender: TObject);
begin
  if not m_ShowOpen then
    Exit;
  with g_pConfig, (Sender as TSpinEdit) do
  begin
    case Tag of
      20: InterlockedExchange(m_nMaxConnectOfIP, Value);
      21: InterlockedExchange(m_nClientTimeOutTime, Value * 1000);
      22: InterlockedExchange(m_nNomClientPacketSize, Value);
      24: InterlockedExchange(m_nMaxClientPacketCount, Value);
    end;
    btnSave.Enabled := True;
  end;
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
        Trim(UserObj.m_pUserOBJ.pszIPAddr),
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
    APOPMENU_REFLISTClick(self);
  end;
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
      DisPose(pIPArea);
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
      DisPose(PInt64(g_BlockIPAreaList.Objects[i]));
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
        DisPose(PInt64(g_BlockIPAreaList.Objects[ItemIndex]));
      end
      else
      begin
        for i := 0 to g_BlockIPAreaList.Count - 1 do
        begin
          if PInt64(g_BlockIPAreaList.Objects[i])^ = PInt64(Items.Objects[ItemIndex])^ then
          begin
            g_BlockIPAreaList.Delete(i);
            DisPose(PInt64(g_BlockIPAreaList.Objects[i]));
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
    APOPMENU_REFLISTClick(self);
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

procedure TfrmPacketRule.FormCreate(Sender: TObject);
begin
  m_ShowOpen := False;
  ListBoxActiveList.Clear;
  ListBoxTempList.Clear;
  ListBoxBlockList.Clear;
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
  APOPMENU_AllToBLOCKLIST.Enabled := boCheck;
  APOPMENU_AllToTempBLOCKLIST.Enabled := boCheck;
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
    APOPMENU_REFLISTClick(self);
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
    APOPMENU_REFLISTClick(self);
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
    APOPMENU_REFLISTClick(self);
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
