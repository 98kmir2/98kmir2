unit ViewList;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, bDiaLogs, ComCtrls, StdCtrls, Grids,
  Spin, Grobal2, Buttons, Menus, TLHelp32, IniFiles,dialogs,HashList;

type
  TfrmViewList = class(TForm)
    PageControlGameManageList: TPageControl;
    TabSheet20: TTabSheet;
    PageControlGameManage: TPageControl;
    TabSheet22: TTabSheet;
    TabSheet23: TTabSheet;
    TabSheet24: TTabSheet;
    TabSheet25: TTabSheet;
    GroupBox12: TGroupBox;
    ListBoxAdminList: TListBox;
    GroupBox15: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    LabelAdminIPaddr: TLabel;
    EditAdminName: TEdit;
    EditAdminPremission: TSpinEdit;
    ButtonAdminListAdd: TButton;
    ButtonAdminListChange: TButton;
    ButtonAdminListDel: TButton;
    EditAdminIPaddr: TEdit;
    GroupBox5: TGroupBox;
    ListBoxDisableMoveMap: TListBox;
    GroupBox6: TGroupBox;
    ListBoxMapList: TListBox;
    ButtonDisableMoveMapAdd: TButton;
    ButtonDisableMoveMapDelete: TButton;
    ButtonDisableMoveMapAddAll: TButton;
    ButtonDisableMoveMapDeleteAll: TButton;
    ButtonDisableMoveMapSave: TButton;
    GridItemBindAccount: TStringGrid;
    GroupBox16: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ButtonItemBindAcountMod: TButton;
    EditItemBindAccountItemIdx: TSpinEdit;
    EditItemBindAccountItemMakeIdx: TSpinEdit;
    EditItemBindAccountItemName: TEdit;
    ButtonItemBindAcountAdd: TButton;
    ButtonItemBindAcountRef: TButton;
    ButtonItemBindAcountDel: TButton;
    EditItemBindAccountName: TEdit;
    ButtonAdminLitsSave: TButton;
    GroupBox8: TGroupBox;
    ListBoxGameLogList: TListBox;
    GroupBox9: TGroupBox;
    ListBoxLogItemList: TListBox;
    ButtonGameLogAdd: TButton;
    ButtonGameLogDel: TButton;
    ButtonGameLogAddAll: TButton;
    ButtonGameLogDelAll: TButton;
    ButtonGameLogSave: TButton;
    TabSheet3: TTabSheet;
    GridItemBindCharName: TStringGrid;
    GroupBox17: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ButtonItemBindCharNameMod: TButton;
    EditItemBindCharNameItemIdx: TSpinEdit;
    EditItemBindCharNameItemMakeIdx: TSpinEdit;
    EditItemBindCharNameItemName: TEdit;
    ButtonItemBindCharNameAdd: TButton;
    ButtonItemBindCharNameRef: TButton;
    ButtonItemBindCharNameDel: TButton;
    EditItemBindCharNameName: TEdit;
    TabSheet5: TTabSheet;
    GridItemBindIPaddr: TStringGrid;
    GroupBox18: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    ButtonItemBindIPaddrMod: TButton;
    EditItemBindIPaddrItemIdx: TSpinEdit;
    EditItemBindIPaddrItemMakeIdx: TSpinEdit;
    EditItemBindIPaddrItemName: TEdit;
    ButtonItemBindIPaddrAdd: TButton;
    ButtonItemBindIPaddrRef: TButton;
    ButtonItemBindIPaddrDel: TButton;
    EditItemBindIPaddrName: TEdit;
    TabSheet6: TTabSheet;
    GroupBox13: TGroupBox;
    ListBoxNoClearMonList: TListBox;
    GroupBox14: TGroupBox;
    ListBoxMonList: TListBox;
    ButtonNoClearMonAdd: TButton;
    ButtonNoClearMonDel: TButton;
    ButtonNoClearMonAddAll: TButton;
    ButtonNoClearMonDelAll: TButton;
    ButtonNoClearMonSave: TButton;
    TabSheetMonDrop: TTabSheet;
    GroupBox7: TGroupBox;
    Label29: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label22: TLabel;
    ButtonMonDropLimitSave: TButton;
    EditDropCount: TSpinEdit;
    EditCountLimit: TSpinEdit;
    EditNoDropCount: TSpinEdit;
    EditItemName: TEdit;
    ButtonMonDropLimitAdd: TButton;
    ButtonMonDropLimitRef: TButton;
    ButtonMonDropLimitDel: TButton;
    EditClearTime: TSpinEdit;
    StringGridMonDropLimit: TStringGrid;
    TabSheet8: TTabSheet;
    GroupBox19: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    ButtonItemNameMod: TButton;
    EditItemNameIdx: TSpinEdit;
    EditItemNameMakeIndex: TSpinEdit;
    EditItemNameOldName: TEdit;
    ButtonItemNameAdd: TButton;
    ButtonItemNameRef: TButton;
    ButtonItemNameDel: TButton;
    EditItemNameNewName: TEdit;
    GridItemNameList: TStringGrid;
    TabSheet7: TTabSheet;
    GroupBox2: TGroupBox;
    ListBoxServerItemList: TListBox;
    GroupBox4: TGroupBox;
    ListBoxLimitItemList: TListBox;
    GroupBox11: TGroupBox;
    EditLimitItemName: TEdit;
    Label24: TLabel;
    EditLimitItemIndex: TEdit;
    Label25: TLabel;
    GroupBoxLimitItem: TGroupBox;
    CheckBoxAllowMake: TCheckBox;
    CheckBoxDisableMake: TCheckBox;
    CheckBoxDisableDrop: TCheckBox;
    CheckBoxDisableDeal: TCheckBox;
    CheckBoxDisableUpgrade: TCheckBox;
    CheckBoxDisableStorage: TCheckBox;
    CheckBoxDispearOnLogon: TCheckBox;
    CheckBoxDisableTakeOff: TCheckBox;
    CheckBoxAllowSellOff: TCheckBox;
    CheckBoxDisableSell: TCheckBox;
    ButtonItemLimitAdd: TButton;
    ButtonItemLimitDelete: TButton;
    ButtonItemLimitSave: TButton;
    ButtonItemLimitChange: TButton;
    ButtonItemLimitAddAll: TButton;
    ButtonItemLimitDeleteAll: TButton;
    CheckBoxDisableRepair: TCheckBox;
    BitBtnSelectAll: TBitBtn;
    BitBtnUnSelectAll: TBitBtn;
    PopupMenuFindItemName: TPopupMenu;
    PopupMenu_FINDITEMBYNAME: TMenuItem;
    CheckBoxDieDropWithOutFail: TCheckBox;
    CheckBoxAbleDropInSafeZone: TCheckBox;
    CheckBoxNoScatter: TCheckBox;
    TabSheetOther: TTabSheet;
    PageControl1: TPageControl;
    TabSheetQueryValeFilter: TTabSheet;
    GroupBox1: TGroupBox;
    ListBoxQueryValueFilter: TListBox;
    GroupBoxGuildRankNameFilter: TGroupBox;
    ListBoxGuildRankNameFilter: TListBox;
    CheckBoxDisallowHeroUse: TCheckBox;
    ChkMonDropItem: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBoxDisablePSell: TCheckBox;
    CheckBoxDUse: TCheckBox;
    ChkPickItem: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBoxdCustomName: TCheckBox;
    ButtonQVFilterAdd: TButton;
    ButtonQVFilterDel: TButton;
    ButtonQVFilterMod: TButton;
    ButtonQVFilterSave: TButton;
    ButtonGuildRankNameFilterAdd: TButton;
    ButtonGuildRankNameFilterDel: TButton;
    ButtonGuildRankNameFilterMob: TButton;
    ButtonGuildRankNameFilterSave: TButton;
    TabSheet2: TTabSheet;
    GroupBox3: TGroupBox;
    ListBoxItemList: TListBox;
    GroupBox10: TGroupBox;
    ListBoxPetPickUpItemList: TListBox;
    ButtonPetPickUpItemAdd: TButton;
    ButtonPetPickUpItemDel: TButton;
    ButtonPetPickUpItemAddAll: TButton;
    ButtonPetPickUpItemDelAll: TButton;
    ButtonPetPickUpItemSave: TButton;
    TabSheet4: TTabSheet;
    GroupBox20: TGroupBox;
    ListBoxUpgradeItemList: TListBox;
    GroupBox21: TGroupBox;
    ListBoxItemListAll: TListBox;
    ButtonUpgradeItemAdd: TButton;
    ButtonUpgradeItemDel: TButton;
    ButtonUpgradeItemAddAll: TButton;
    ButtonUpgradeItemDelAll: TButton;
    ButtonUpgradeItemSave: TButton;
    TabSheet9: TTabSheet;
    GroupBoxUserCmd: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    ListBoxUserCmd: TListBox;
    EditUserCmd: TEdit;
    SpinEditUserCmd: TSpinEdit;
    ButtonUserCmdAdd: TButton;
    ButtonUserCmdDel: TButton;
    ButtonUserCmdSav: TButton;
    Label23: TLabel;
    TabSheet10: TTabSheet;
    GroupBox23: TGroupBox;
    ListBoxShopItemList: TListBox;
    btnShopItemDel: TButton;
    btnReloadShopItemList: TButton;
    btnShopItemSave: TButton;
    btnShopItemAdd: TButton;
    EditShopItemName: TEdit;
    EditShopItemPrice: TSpinEdit;
    EditShopItemDetail: TEdit;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    SpinEditShopItemIdx1: TSpinEdit;
    Label35: TLabel;
    SpinEditShopItemIdx2: TSpinEdit;
    Label36: TLabel;
    SpinEditShopItemIdx3: TSpinEdit;
    Label37: TLabel;
    ListViewShopItemList: TListView;
    Label38: TLabel;
    TabSheet11: TTabSheet;
    ListViewSuite: TListView;
    GroupBox24: TGroupBox;
    EditSuiteMaxHP: TSpinEdit;
    Label41: TLabel;
    EditSuiteMaxMP: TSpinEdit;
    Label42: TLabel;
    EditSubMCRate: TSpinEdit;
    EditSubDCRate: TSpinEdit;
    Label43: TLabel;
    Label44: TLabel;
    EditSubSCRate: TSpinEdit;
    Label45: TLabel;
    EditSubACRate: TSpinEdit;
    Label46: TLabel;
    Label47: TLabel;
    EditSubMACRate: TSpinEdit;
    EditSuiteEffectMsg: TEdit;
    Label40: TLabel;
    btnSuiteItemAdd: TButton;
    btnSuiteItemDel: TButton;
    btnSuiteItemSave: TButton;
    btnReloadSuiteItem: TButton;
    btnSuiteMob: TButton;
    GroupBox25: TGroupBox;
    CheckBoxParalysis: TCheckBox;
    CheckBoxMagicShield: TCheckBox;
    CheckBoxTeleport: TCheckBox;
    CheckBoxRevival: TCheckBox;
    CheckBoxMuscleRing: TCheckBox;
    CheckBoxUnParalysis: TCheckBox;
    CheckBoxUnAllParalysis: TCheckBox;
    CheckBoxUnRevival: TCheckBox;
    CheckBoxUnMagicShield: TCheckBox;
    CheckBoxRecallSuite: TCheckBox;
    Edit1: TEdit;
    Label48: TLabel;
    Label49: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label50: TLabel;
    Label51: TLabel;
    Edit4: TEdit;
    Label52: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label53: TLabel;
    Label54: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Label56: TLabel;
    Label57: TLabel;
    Edit9: TEdit;
    Edit10: TEdit;
    Label58: TLabel;
    Label59: TLabel;
    Edit11: TEdit;
    Edit12: TEdit;
    Label60: TLabel;
    Edit13: TEdit;
    Label61: TLabel;
    CheckBoxFastTrain: TCheckBox;
    CheckBoxNoDropItem: TCheckBox;
    EditSuiteHitPoint: TSpinEdit;
    Label39: TLabel;
    Label62: TLabel;
    EditSuiteSPDPoint: TSpinEdit;
    EditSuiteAntiMagic: TSpinEdit;
    Label63: TLabel;
    EditSuileAntiPoison: TSpinEdit;
    Label64: TLabel;
    Label65: TLabel;
    EditSuitePoisonRecover: TSpinEdit;
    EditSuiteHPRecover: TSpinEdit;
    Label66: TLabel;
    EditSuiteMPRecover: TSpinEdit;
    Label67: TLabel;
    CheckBoxNoDropUseItem: TCheckBox;
    CheckBoxProbeNecklace: TCheckBox;
    CheckBoxHongMoSuite: TCheckBox;
    CheckBoxHideMode: TCheckBox;
    GroupBox26: TGroupBox;
    ComboBoxSaleItemBind: TComboBox;
    Label55: TLabel;
    rbYb: TRadioButton;
    rbGd: TRadioButton;
    SpinEdit1: TSpinEdit;
    Label68: TLabel;
    SpinEdit2: TSpinEdit;
    Label69: TLabel;
    Label70: TLabel;
    SpinEdit3: TSpinEdit;
    Label71: TLabel;
    SpinEdit4: TSpinEdit;
    Label72: TLabel;
    SpinEdit5: TSpinEdit;
    Label73: TLabel;
    SpinEdit6: TSpinEdit;
    Label74: TLabel;
    SpinEdit7: TSpinEdit;
    SpinEdit8: TSpinEdit;
    SpinEdit9: TSpinEdit;
    SpinEdit10: TSpinEdit;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    CheckBox1: TCheckBox;
    Label78: TLabel;
    EditReNewNameColor1: TSpinEdit;
    LabelReNewNameColor1: TLabel;
    Label80: TLabel;
    EditReNewNameColor2: TSpinEdit;
    LabelReNewNameColor2: TLabel;
    cbPresendItem: TCheckBox;
    cmbItemType: TComboBox;
    tabSheetStartPointCustom: TTabSheet;
    lvStartPointCustom: TListView;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonDisableMoveMapAddClick(Sender: TObject);
    procedure ButtonDisableMoveMapDeleteClick(Sender: TObject);
    procedure ButtonDisableMoveMapAddAllClick(Sender: TObject);
    procedure ButtonDisableMoveMapSaveClick(Sender: TObject);
    procedure ButtonDisableMoveMapDeleteAllClick(Sender: TObject);
    procedure ListBoxMapListClick(Sender: TObject);
    procedure ListBoxDisableMoveMapClick(Sender: TObject);
    procedure ButtonMonDropLimitRefClick(Sender: TObject);
    procedure StringGridMonDropLimitClick(Sender: TObject);
    procedure EditDropCountChange(Sender: TObject);
    procedure EditCountLimitChange(Sender: TObject);
    procedure EditNoDropCountChange(Sender: TObject);
    procedure ButtonMonDropLimitSaveClick(Sender: TObject);
    procedure ListBoxGameLogListClick(Sender: TObject);
    procedure ListBoxLogItemListClick(Sender: TObject);
    procedure ButtonGameLogAddClick(Sender: TObject);
    procedure ButtonGameLogDelClick(Sender: TObject);
    procedure ButtonGameLogAddAllClick(Sender: TObject);
    procedure ButtonGameLogDelAllClick(Sender: TObject);
    procedure ButtonGameLogSaveClick(Sender: TObject);
    procedure ButtonNoClearMonAddClick(Sender: TObject);
    procedure ButtonNoClearMonDelClick(Sender: TObject);
    procedure ButtonNoClearMonAddAllClick(Sender: TObject);
    procedure ButtonNoClearMonDelAllClick(Sender: TObject);
    procedure ButtonNoClearMonSaveClick(Sender: TObject);
    procedure ListBoxNoClearMonListClick(Sender: TObject);
    procedure ListBoxMonListClick(Sender: TObject);
    procedure ButtonAdminLitsSaveClick(Sender: TObject);
    procedure ListBoxAdminListClick(Sender: TObject);
    procedure ButtonAdminListChangeClick(Sender: TObject);
    procedure ButtonAdminListAddClick(Sender: TObject);
    procedure ButtonAdminListDelClick(Sender: TObject);
    procedure ButtonMonDropLimitAddClick(Sender: TObject);
    procedure ButtonMonDropLimitDelClick(Sender: TObject);
    procedure GridItemBindAccountClick(Sender: TObject);
    procedure EditItemBindAccountItemIdxChange(Sender: TObject);
    procedure EditItemBindAccountItemMakeIdxChange(Sender: TObject);
    procedure ButtonItemBindAcountModClick(Sender: TObject);
    procedure EditItemBindAccountNameChange(Sender: TObject);
    procedure ButtonItemBindAcountRefClick(Sender: TObject);
    procedure ButtonItemBindAcountAddClick(Sender: TObject);
    procedure ButtonItemBindAcountDelClick(Sender: TObject);
    procedure GridItemBindCharNameClick(Sender: TObject);
    procedure EditItemBindCharNameItemIdxChange(Sender: TObject);
    procedure EditItemBindCharNameItemMakeIdxChange(Sender: TObject);
    procedure EditItemBindCharNameNameChange(Sender: TObject);
    procedure ButtonItemBindCharNameAddClick(Sender: TObject);
    procedure ButtonItemBindCharNameModClick(Sender: TObject);
    procedure ButtonItemBindCharNameDelClick(Sender: TObject);
    procedure ButtonItemBindCharNameRefClick(Sender: TObject);
    procedure GridItemBindIPaddrClick(Sender: TObject);
    procedure EditItemBindIPaddrItemIdxChange(Sender: TObject);
    procedure EditItemBindIPaddrItemMakeIdxChange(Sender: TObject);
    procedure EditItemBindIPaddrNameChange(Sender: TObject);
    procedure ButtonItemBindIPaddrAddClick(Sender: TObject);
    procedure ButtonItemBindIPaddrModClick(Sender: TObject);
    procedure ButtonItemBindIPaddrDelClick(Sender: TObject);
    procedure ButtonItemBindIPaddrRefClick(Sender: TObject);
    procedure EditItemNameIdxChange(Sender: TObject);
    procedure EditItemNameMakeIndexChange(Sender: TObject);
    procedure EditItemNameNewNameChange(Sender: TObject);
    procedure ButtonItemNameAddClick(Sender: TObject);
    procedure ButtonItemNameModClick(Sender: TObject);
    procedure ButtonItemNameDelClick(Sender: TObject);
    procedure GridItemNameListClick(Sender: TObject);
    procedure ButtonItemNameRefClick(Sender: TObject);
    procedure EditClearTimeChange(Sender: TObject);
    procedure ButtonItemLimitAddClick(Sender: TObject);
    procedure ButtonItemLimitDeleteClick(Sender: TObject);
    procedure ButtonItemLimitSaveClick(Sender: TObject);
    procedure ListBoxLimitItemListClick(Sender: TObject);
    procedure ListBoxServerItemListClick(Sender: TObject);
    procedure ButtonItemLimitChangeClick(Sender: TObject);
    procedure CheckBoxAllowMakeClick(Sender: TObject);
    procedure ButtonItemLimitAddAllClick(Sender: TObject);
    procedure ButtonItemLimitDeleteAllClick(Sender: TObject);
    procedure BitBtnSelectAllClick(Sender: TObject);
    procedure BitBtnUnSelectAllClick(Sender: TObject);
    procedure ListBoxServerItemListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PopupMenu_FINDITEMBYNAMEClick(Sender: TObject);
    procedure ButtonQVFilterAddClick(Sender: TObject);
    procedure ButtonQVFilterDelClick(Sender: TObject);
    procedure ListBoxQueryValueFilterClick(Sender: TObject);
    procedure ButtonQVFilterModClick(Sender: TObject);
    procedure ListBoxQueryValueFilterDblClick(Sender: TObject);
    procedure ButtonGuildRankNameFilterDelClick(Sender: TObject);
    procedure ButtonGuildRankNameFilterMobClick(Sender: TObject);
    procedure ButtonGuildRankNameFilterSaveClick(Sender: TObject);
    procedure ListBoxGuildRankNameFilterDblClick(Sender: TObject);
    procedure ListBoxGuildRankNameFilterClick(Sender: TObject);
    procedure ListBoxUserCmdClick(Sender: TObject);
    procedure ButtonUserCmdAddClick(Sender: TObject);
    procedure ButtonUserCmdDelClick(Sender: TObject);
    procedure ButtonUserCmdSavClick(Sender: TObject);
    procedure ListBoxPetPickUpItemListClick(Sender: TObject);
    procedure ListBoxItemListClick(Sender: TObject);
    procedure ButtonPetPickUpItemAddClick(Sender: TObject);
    procedure ButtonPetPickUpItemDelClick(Sender: TObject);
    procedure ButtonPetPickUpItemAddAllClick(Sender: TObject);
    procedure ButtonPetPickUpItemDelAllClick(Sender: TObject);
    procedure ButtonPetPickUpItemSaveClick(Sender: TObject);
    procedure ListBoxUpgradeItemListClick(Sender: TObject);
    procedure ListBoxItemListAllClick(Sender: TObject);
    procedure ButtonUpgradeItemAddClick(Sender: TObject);
    procedure ButtonUpgradeItemDelClick(Sender: TObject);
    procedure ButtonUpgradeItemAddAllClick(Sender: TObject);
    procedure ButtonUpgradeItemDelAllClick(Sender: TObject);
    procedure ButtonUpgradeItemSaveClick(Sender: TObject);
    procedure ListBoxShopItemListClick(Sender: TObject);
    procedure ListViewShopItemListClick(Sender: TObject);
    procedure btnShopItemAddClick(Sender: TObject);
    procedure btnShopItemDelClick(Sender: TObject);
    procedure btnShopItemSaveClick(Sender: TObject);
    procedure btnReloadShopItemListClick(Sender: TObject);
    procedure btnSuiteItemAddClick(Sender: TObject);
    procedure btnSuiteItemDelClick(Sender: TObject);
    procedure btnSuiteItemSaveClick(Sender: TObject);
    procedure btnReloadSuiteItemClick(Sender: TObject);
    procedure ListViewSuiteClick(Sender: TObject);
    procedure btnSuiteMobClick(Sender: TObject);
    procedure ListViewSuiteChange(Sender: TObject; item: TListItem;
      Change: TItemChange);
    procedure ComboBoxSaleItemBindChange(Sender: TObject);
    procedure rbYbClick(Sender: TObject);
    procedure EditReNewNameColor1Change(Sender: TObject);
    procedure EditReNewNameColor2Change(Sender: TObject);
    procedure cbPresendItemClick(Sender: TObject);
  private
    boOpened: Boolean;
    boModValued: Boolean;
    SelLimitItem: pTItemLimit;
    g_SuiteItems: pTSuiteItems;
    //g_ListItemSuite: TListItem;
    procedure ModValue();
    procedure uModValue();
    procedure RefMonDropLimit();
    procedure RefAdminList();
    procedure RefUserCmdList();
    procedure RefNoClearMonList();
    procedure RefItemBindAccount();
    procedure RefSaleItemList();
    procedure RefSuitItemList();
    procedure RefShopItemList();
    procedure RefItemLimit();
    procedure RefItemBindCharName();
    procedure RefItemBindIPaddr();
    procedure RefItemCustomNameList();
    procedure LimitSelectAll(boCheck: Boolean);
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmViewList: TfrmViewList;

implementation

uses M2Share, UsrEngn, Envir, HUtil32, LocalDB, svMain, VMProtectSDK;

{$R *.dfm}

{ TfrmViewList }

procedure TfrmViewList.ModValue;
begin
  boModValued := True;
  ButtonDisableMoveMapSave.Enabled := True;
  ButtonGameLogSave.Enabled := True;
  ButtonNoClearMonSave.Enabled := True;
  ButtonItemLimitSave.Enabled := True;
  ButtonQVFilterSave.Enabled := True;
  ButtonGuildRankNameFilterSave.Enabled := True;
  ButtonPetPickUpItemSave.Enabled := True;
  ButtonUpgradeItemSave.Enabled := True;
end;

procedure TfrmViewList.uModValue;
begin
  boModValued := False;
  ButtonDisableMoveMapSave.Enabled := False;
  ButtonGameLogSave.Enabled := False;
  ButtonNoClearMonSave.Enabled := False;
  ButtonItemLimitSave.Enabled := False;
  ButtonItemLimitChange.Enabled := False;
  ButtonQVFilterSave.Enabled := False;
  ButtonGuildRankNameFilterSave.Enabled := False;
  ButtonPetPickUpItemSave.Enabled := False;
  ButtonUpgradeItemSave.Enabled := False;
end;

procedure TfrmViewList.Open;
var
  i: Integer;
  StdItem: pTStdItem;
  sDlls: string;
  bHook: Boolean;
  mHandle: THandle;
  FModuleEntry32: TModuleEntry32;
  Envir: TEnvirnoment;
begin
  boOpened := False;
  uModValue();
  SelLimitItem := nil;
  ListBoxServerItemList.Items.Clear;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to UserEngine.StdItemList.Count - 1 do
    begin
      StdItem := UserEngine.StdItemList.Items[i];
      ListBoxServerItemList.Items.AddObject(StdItem.Name, TObject(i));
      ListBoxShopItemList.Items.AddObject(StdItem.Name, TObject(StdItem.looks));
    end;
    ListBoxLogItemList.Items.Text := ListBoxServerItemList.Items.Text;
    ListBoxItemList.Items.Text := ListBoxServerItemList.Items.Text;
    //ListBoxShopItemList.Items.Text := ListBoxServerItemList.Items.Text;
    ListBoxItemListAll.Items.Text := ListBoxServerItemList.Items.Text;
    ListBoxLogItemList.Items.AddObject(g_sHumanDieEvent, TObject(nil));
    ListBoxLogItemList.Items.AddObject(sSTRING_GOLDNAME, TObject(nil));
    ListBoxLogItemList.Items.AddObject(g_Config.sGameGoldName, TObject(nil));
    ListBoxLogItemList.Items.AddObject(g_Config.sGamePointName, TObject(nil));
    ListBoxItemList.Items.AddObject(sSTRING_GOLDNAME, TObject(nil));
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;

  for i := 0 to g_MapManager.Count - 1 do
  begin
{$IF USEHASHLIST = 1}
    //Envir := TEnvirnoment(g_MapManager.Objects[i]);
    Envir := TEnvirnoment(g_MapManager.Values[g_MapManager.Keys[i]]);
{$ELSE}
    Envir := TEnvirnoment(g_MapManager[i]);
{$IFEND}
    ListBoxMapList.Items.Add(Envir.m_sMapFileName);
  end;

  g_GameLogItemNameList.Lock;
  try
    for i := 0 to g_GameLogItemNameList.Count - 1 do
    begin
      ListBoxGameLogList.Items.Add(g_GameLogItemNameList.Strings[i]);
    end;
  finally
    g_GameLogItemNameList.UnLock;
  end;

  g_PetPickItemList.Lock;
  try
    for i := 0 to g_PetPickItemList.Count - 1 do
    begin
      ListBoxPetPickUpItemList.Items.Add(g_PetPickItemList.Strings[i]);
    end;
  finally
    g_PetPickItemList.UnLock;
  end;

  g_UpgradeItemList.Lock;
  try
    for i := 0 to g_UpgradeItemList.Count - 1 do
    begin
      ListBoxUpgradeItemList.Items.Add(g_UpgradeItemList.Strings[i]);
    end;
  finally
    g_UpgradeItemList.UnLock;
  end;

  g_GuildRankNameFilterList.Lock;
  try
    for i := 0 to g_GuildRankNameFilterList.Count - 1 do
    begin
      ListBoxGuildRankNameFilter.Items.Add(g_GuildRankNameFilterList.Strings[i]);
    end;
  finally
    g_GuildRankNameFilterList.UnLock;
  end;

  g_DisableMoveMapList.Lock;
  try
    for i := 0 to g_DisableMoveMapList.Count - 1 do
    begin
      ListBoxDisableMoveMap.Items.Add(g_DisableMoveMapList.Strings[i]);
    end;
  finally
    g_DisableMoveMapList.UnLock;
  end;

{$IF USEWLSDK = 1}
{$I '..\Common\Macros\PROTECT_START.inc'}
{$ELSEIF USEWLSDK = 2}
{$I '..\Common\Macros\PROTECT_START.inc'}
{$IFEND USEWLSDK}
  bHook := False;
  sDlls := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('IPLocal.dll mPlugOfScript.dll mPlugOfEngine.dll mSystemModule.dll mPlugOfAccess.dll');
  mHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, GetCurrentProcessId);
  if mHandle <> 0 then
  begin
    FModuleEntry32.dwSize := SizeOf(TModuleEntry32);
    if Module32First(mHandle, FModuleEntry32) then
    begin
      while Module32Next(mHandle, FModuleEntry32) do
      begin
        if LowerCase(Trim(ExtractFilePath(FModuleEntry32.szExePath))) = LowerCase(ExtractFilePath(ParamStr(0))) then
        begin
          if Pos(LowerCase(ExtractFileName(FModuleEntry32.szModule)), LowerCase(sDlls)) <= 0 then
          begin
            bHook := True;
            Break;
          end;
        end;
      end;
    end;
    CloseHandle(mHandle);
  end;
  if not bHook then
  begin
    RefItemLimit();
    RefItemBindAccount();
    RefItemBindCharName();
    RefItemBindIPaddr();
    RefMonDropLimit();
    RefUserCmdList();
    RefAdminList();
    RefNoClearMonList();
    RefItemCustomNameList();
    RefSaleItemList();
    RefSuitItemList();
    RefShopItemList();
  end;
{$IF USEWLSDK = 1}
{$I '..\Common\Macros\PROTECT_END.inc'}
{$ELSEIF USEWLSDK = 2}
{$I '..\Common\Macros\PROTECT_END.inc'}
{$IFEND USEWLSDK}
  boOpened := True;
  PageControlGameManageList.ActivePageIndex := 0;
  PageControlGameManage.ActivePageIndex := 0;
  PageControl1.ActivePageIndex := 0;
  ShowModal;
end;

procedure TfrmViewList.RefSaleItemList();

begin



end;

procedure TfrmViewList.RefShopItemList();
var
  i: Integer;
  ListItem: TListItem;
  pShopItem: pTShopItem;
begin
  EditShopItemName.Text := '';
  EditShopItemPrice.Value := 1;
 
  btnShopItemDel.Enabled := False;
  btnShopItemAdd.Enabled := False;
  g_ShopItemList.Lock;
  try
    for i := 0 to g_ShopItemList.Count - 1 do
    begin
      pShopItem := g_ShopItemList.Items[i];
      ListItem := ListViewShopItemList.Items.Add;
      ListItem.Caption := IntToStr(pShopItem^.btClass);
      ListItem.SubItems.Add(pShopItem^.sItemName);
      ListItem.SubItems.Add(IntToStr(pShopItem^.wLooks));
      ListItem.SubItems.Add(IntToStr(pShopItem^.wPrice));
      ListItem.SubItems.Add(IntToStr(pShopItem^.wShape1));
      ListItem.SubItems.Add(IntToStr(pShopItem^.wShape2));
      ListItem.SubItems.Add(pShopItem^.sExplain);
    end;
  finally
    g_ShopItemList.UnLock;
  end;
  ComboBoxSaleItemBind.ItemIndex := _MAX(0, _MIN(2, g_Config.nShopItemBind));
  if g_Config.btSellType = 0 then
  begin
    rbYb.Checked := True
  end
  else
  begin
    rbGd.Checked := True;
  end;

  cbPresendItem.Checked := g_Config.boPresendItem;
end;

procedure TfrmViewList.RefSuitItemList();
var
  i, ii: Integer;
  ListItem: TListItem;
  sLineText: string;
  SuiteItems: pTSuiteItems;
begin
  btnSuiteItemDel.Enabled := False;
  btnSuiteMob.Enabled := False;
  ListViewSuite.Clear;
  for i := 0 to g_SuiteItemsList.Count - 1 do
  begin
    SuiteItems := g_SuiteItemsList.Items[i];
    ListItem := ListViewSuite.Items.Add;
    ListItem.Caption := IntToStr(i);
    ListItem.SubItems.Add(SuiteItems.sDesc);

    sLineText := '';
    for ii := Low(TSuiteNames) to High(TSuiteNames) do
      sLineText := sLineText + SuiteItems.asSuiteName[ii] + ',';
    ListItem.SubItems.Add(sLineText);

    sLineText := '';
    for ii := Low(TSuitSubRate) to High(TSuitSubRate) do
      sLineText := sLineText + IntToStr(SuiteItems.aSuitSubRate[ii]) + ',';
    ListItem.SubItems.AddObject(sLineText, TObject(SuiteItems));

  end;
end;

procedure TfrmViewList.FormCreate(Sender: TObject);
var
    ListItem: TListItem;
    i, nPrice: Integer;
    sFileName: string;
    sLineText: string;
    sItemClass: string;
    sItemName: string;
    s1, s2, s3: string;
    sItemPrice: string;
    sItemDes: string;
    ShopItem: pTShopItem;

begin
  ComboBoxSaleItemBind.Items.Add('未设置');
  ComboBoxSaleItemBind.Items.Add('绑定角色');
  ComboBoxSaleItemBind.Items.Add('绑定帐号');

  GridItemBindAccount.Cells[0, 0] := '物品名称';
  GridItemBindAccount.Cells[1, 0] := '物品IDX';
  GridItemBindAccount.Cells[2, 0] := '物品系列号';
  GridItemBindAccount.Cells[3, 0] := '绑定帐号';

  GridItemBindCharName.Cells[0, 0] := '物品名称';
  GridItemBindCharName.Cells[1, 0] := '物品IDX';
  GridItemBindCharName.Cells[2, 0] := '物品系列号';
  GridItemBindCharName.Cells[3, 0] := '绑定人物';

  GridItemBindIPaddr.Cells[0, 0] := '物品名称';
  GridItemBindIPaddr.Cells[1, 0] := '物品IDX';
  GridItemBindIPaddr.Cells[2, 0] := '物品系列号';
  GridItemBindIPaddr.Cells[3, 0] := '绑定IP';

  StringGridMonDropLimit.Cells[0, 0] := '物品名称';
  StringGridMonDropLimit.Cells[1, 0] := '爆数量';
  StringGridMonDropLimit.Cells[2, 0] := '限制数量';
  StringGridMonDropLimit.Cells[3, 0] := '未爆数量';
  StringGridMonDropLimit.Cells[4, 0] := '清零时间';

  GridItemNameList.Cells[0, 0] := '原始名称';
  GridItemNameList.Cells[1, 0] := '物品编号';
  GridItemNameList.Cells[2, 0] := '自定义名称';

  TabSheetMonDrop.TabVisible := True;
  ButtonDisableMoveMapAdd.Enabled := False;
  ButtonDisableMoveMapDelete.Enabled := False;
  ButtonGameLogAdd.Enabled := False;
  ButtonGameLogDel.Enabled := False;
  ButtonNoClearMonAdd.Enabled := False;
  ButtonNoClearMonDel.Enabled := False;
  ButtonItemLimitAdd.Enabled := False;
  ButtonItemLimitDelete.Enabled := False;
  ButtonPetPickUpItemAdd.Enabled := False;
  ButtonPetPickUpItemDel.Enabled := False;
  ButtonUpgradeItemDel.Enabled := False;
  ButtonUpgradeItemAdd.Enabled := False;

{$IF SoftVersion = VERDEMO}
  Caption := '查看列表信息[演示版本，所有设置调整有效，但不能保存]';
{$IFEND}

{$IF VEROWNER = WL}
  EditAdminIPaddr.Visible := True;
  LabelAdminIPaddr.Visible := True;
{$ELSE}
  EditAdminIPaddr.Visible := False;
  LabelAdminIPaddr.Visible := False;
{$IFEND}

  ListViewShopItemList.Clear;
  for i := 0 to g_ShopItemList.Count -1 do
  begin
    ShopItem := g_ShopItemList.items[i];
    ListItem := ListViewShopItemList.Items.Add;
    ListItem.Caption := IntToStr(ShopItem.btClass);
    ListItem.SubItems.Add(shopItem.sItemName);
    ListItem.SubItems.Add(IntToStr(shopItem.wLooks));
    ListItem.SubItems.Add(IntToStr(shopItem.wPrice));
    ListItem.SubItems.Add(IntToStr(shopItem.wShape1));
    ListItem.SubItems.Add(IntToStr(shopItem.wShape2));
    ListItem.SubItems.Add(IntToStr(shopItem.wPresent));
    ListItem.SubItems.Add(IntToStr(shopItem.wMarketType));
    ListItem.SubItems.Add(shopItem.sExplain);
  end;
  RefItemLimit;
end;

procedure TfrmViewList.ButtonDisableMoveMapAddClick(Sender: TObject);
var
  i: Integer;
begin
  if ListBoxMapList.ItemIndex >= 0 then
  begin
    for i := 0 to ListBoxDisableMoveMap.Items.Count - 1 do
    begin
      if ListBoxDisableMoveMap.Items.Strings[i] =
        ListBoxMapList.Items.Strings[ListBoxMapList.ItemIndex] then
      begin
        Application.MessageBox('此地图已在列表中', '错误信息', MB_OK +
          MB_ICONERROR);
        Exit;
      end;
    end;
    ListBoxDisableMoveMap.Items.Add(ListBoxMapList.Items.Strings[ListBoxMapList.ItemIndex]);
    ModValue();
  end;
end;

procedure TfrmViewList.ButtonDisableMoveMapDeleteClick(Sender: TObject);
begin
  if ListBoxDisableMoveMap.ItemIndex >= 0 then
  begin
    ListBoxDisableMoveMap.Items.Delete(ListBoxDisableMoveMap.ItemIndex);
    ModValue();
  end;
  if ListBoxDisableMoveMap.ItemIndex < 0 then
    ButtonDisableMoveMapDelete.Enabled := False;
end;

procedure TfrmViewList.ButtonDisableMoveMapAddAllClick(Sender: TObject);
var
  i: Integer;
begin
  ListBoxDisableMoveMap.Items.Clear;
  for i := 0 to ListBoxMapList.Items.Count - 1 do
  begin
    ListBoxDisableMoveMap.Items.Add(ListBoxMapList.Items.Strings[i]);
  end;
  ModValue();
end;

procedure TfrmViewList.ButtonDisableMoveMapSaveClick(Sender: TObject);
var
  i: Integer;
begin
  g_DisableMoveMapList.Lock;
  try
    g_DisableMoveMapList.Clear;
    for i := 0 to ListBoxDisableMoveMap.Items.Count - 1 do
    begin
      g_DisableMoveMapList.Add(ListBoxDisableMoveMap.Items.Strings[i])
    end;
  finally
    g_DisableMoveMapList.UnLock;
  end;
  SaveDisableMoveMap();
  uModValue();
end;

procedure TfrmViewList.ButtonDisableMoveMapDeleteAllClick(Sender: TObject);
begin
  ListBoxDisableMoveMap.Items.Clear;
  ButtonDisableMoveMapDelete.Enabled := False;
  ModValue();
end;

procedure TfrmViewList.ListBoxMapListClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxMapList.ItemIndex >= 0 then
    ButtonDisableMoveMapAdd.Enabled := True;
end;

procedure TfrmViewList.ListBoxDisableMoveMapClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxDisableMoveMap.ItemIndex >= 0 then
    ButtonDisableMoveMapDelete.Enabled := True;
end;

procedure TfrmViewList.RefMonDropLimit;
var
  i: Integer;
  MonDrop: pTMonDrop;
begin
  g_MonDropLimitLIst.Lock;
  try
    StringGridMonDropLimit.RowCount := g_MonDropLimitLIst.Count + 1;
    if StringGridMonDropLimit.RowCount > 1 then
      StringGridMonDropLimit.FixedRows := 1;

    for i := 0 to g_MonDropLimitLIst.Count - 1 do
    begin
      MonDrop := pTMonDrop(g_MonDropLimitLIst.Objects[i]);
      StringGridMonDropLimit.Cells[0, i + 1] := MonDrop.sItemName;
      StringGridMonDropLimit.Cells[1, i + 1] := IntToStr(MonDrop.nDropCount);
      StringGridMonDropLimit.Cells[2, i + 1] := IntToStr(MonDrop.nCountLimit);
      StringGridMonDropLimit.Cells[3, i + 1] := IntToStr(MonDrop.nNoDropCount);
      StringGridMonDropLimit.Cells[4, i + 1] := IntToStr(MonDrop.ClearTime);
    end;
  finally
    g_MonDropLimitLIst.UnLock;
  end;
end;

procedure TfrmViewList.ButtonMonDropLimitRefClick(Sender: TObject);
begin
  RefMonDropLimit();
end;

procedure TfrmViewList.StringGridMonDropLimitClick(Sender: TObject);
var
  nItemIndex: Integer;
  MonDrop: pTMonDrop;
begin
  nItemIndex := StringGridMonDropLimit.Row - 1;
  if nItemIndex < 0 then
    Exit;

  g_MonDropLimitLIst.Lock;
  try
    if nItemIndex >= g_MonDropLimitLIst.Count then
      Exit;
    MonDrop := pTMonDrop(g_MonDropLimitLIst.Objects[nItemIndex]);
    EditItemName.Text := MonDrop.sItemName;
    EditDropCount.Value := MonDrop.nDropCount;
    EditCountLimit.Value := MonDrop.nCountLimit;
    EditNoDropCount.Value := MonDrop.nNoDropCount;
  finally
    g_MonDropLimitLIst.UnLock;
  end;
end;

procedure TfrmViewList.EditDropCountChange(Sender: TObject);
begin
  if EditDropCount.Text = '' then
  begin
    EditDropCount.Text := '0';
    Exit;
  end;

end;

procedure TfrmViewList.EditCountLimitChange(Sender: TObject);
begin
  if EditCountLimit.Text = '' then
  begin
    EditCountLimit.Text := '0';
    Exit;
  end;
end;

procedure TfrmViewList.EditNoDropCountChange(Sender: TObject);
begin
  if EditNoDropCount.Text = '' then
  begin
    EditNoDropCount.Text := '0';
    Exit;
  end;
end;

procedure TfrmViewList.EditReNewNameColor1Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor1.Value;
  LabelReNewNameColor1.Color := GetRGB(btColor);
end;

procedure TfrmViewList.EditReNewNameColor2Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor2.Value;
  LabelReNewNameColor2.Color := GetRGB(btColor);
end;

procedure TfrmViewList.ButtonMonDropLimitSaveClick(Sender: TObject);
var
  sItemName: string;
  nNoDropCount: Integer;
  nDropCount: Integer;
  nDropLimit: Integer;
  nSelIndex: Integer;
  nCLearTime: Integer;
  MonDrop: pTMonDrop;
begin
  sItemName := Trim(EditItemName.Text);
  nDropCount := EditDropCount.Value;
  nDropLimit := EditCountLimit.Value;
  nNoDropCount := EditNoDropCount.Value;
  nCLearTime := EditClearTime.Value;

  nSelIndex := StringGridMonDropLimit.Row - 1;
  if nSelIndex < 0 then
    Exit;
  g_MonDropLimitLIst.Lock;
  try
    if nSelIndex >= g_MonDropLimitLIst.Count then
      Exit;
    MonDrop := pTMonDrop(g_MonDropLimitLIst.Objects[nSelIndex]);
    MonDrop.sItemName := sItemName;
    MonDrop.nDropCount := nDropCount;
    MonDrop.nNoDropCount := nNoDropCount;
    MonDrop.nCountLimit := nDropLimit;
    MonDrop.ClearTime := nCLearTime;
  finally
    g_MonDropLimitLIst.UnLock;
  end;
  SaveMonDropLimitList();
  RefMonDropLimit();
end;

procedure TfrmViewList.ButtonMonDropLimitAddClick(Sender: TObject);
var
  i: Integer;
  sItemName: string;
  nNoDropCount: Integer;
  nDropCount: Integer;
  nDropLimit: Integer;
  nCLearTime: Integer;
  MonDrop: pTMonDrop;
begin
  sItemName := Trim(EditItemName.Text);
  nDropCount := EditDropCount.Value;
  nDropLimit := EditCountLimit.Value;
  nNoDropCount := EditNoDropCount.Value;
  nCLearTime := EditClearTime.Value;

  g_MonDropLimitLIst.Lock;
  try
    for i := 0 to g_MonDropLimitLIst.Count - 1 do
    begin
      MonDrop := pTMonDrop(g_MonDropLimitLIst.Objects[i]);
      if CompareText(MonDrop.sItemName, sItemName) = 0 then
      begin
        Application.MessageBox('输入的物品名已经在列表中', '提示信息',
          MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    New(MonDrop);
    MonDrop.sItemName := sItemName;
    MonDrop.nDropCount := nDropCount;
    MonDrop.nNoDropCount := nNoDropCount;
    MonDrop.nCountLimit := nDropLimit;
    MonDrop.ClearTime := nCLearTime;
    g_MonDropLimitLIst.AddObject(sItemName, TObject(MonDrop));
  finally
    g_MonDropLimitLIst.UnLock;
  end;
  SaveMonDropLimitList();
  RefMonDropLimit();
end;

procedure TfrmViewList.ButtonMonDropLimitDelClick(Sender: TObject);
var
  nSelIndex: Integer;
  MonDrop: pTMonDrop;
begin

  nSelIndex := StringGridMonDropLimit.Row - 1;
  if nSelIndex < 0 then
    Exit;
  g_MonDropLimitLIst.Lock;
  try
    if nSelIndex >= g_MonDropLimitLIst.Count then
      Exit;
    MonDrop := pTMonDrop(g_MonDropLimitLIst.Objects[nSelIndex]);
    Dispose(MonDrop);
    g_MonDropLimitLIst.Delete(nSelIndex);
  finally
    g_MonDropLimitLIst.UnLock;
  end;
  SaveMonDropLimitList();
  RefMonDropLimit();
end;

procedure TfrmViewList.ListBoxGameLogListClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxGameLogList.ItemIndex >= 0 then
    ButtonGameLogDel.Enabled := True;
end;

procedure TfrmViewList.ListBoxLogItemListClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxLogItemList.ItemIndex >= 0 then
    ButtonGameLogAdd.Enabled := True;
end;

procedure TfrmViewList.ButtonGameLogAddClick(Sender: TObject);
var
  i: Integer;
begin
  if ListBoxLogItemList.ItemIndex >= 0 then
  begin
    for i := 0 to ListBoxGameLogList.Items.Count - 1 do
    begin
      if ListBoxGameLogList.Items.Strings[i] =
        ListBoxLogItemList.Items.Strings[ListBoxLogItemList.ItemIndex] then
      begin
        Application.MessageBox('此物品已在列表中', '错误信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    ListBoxGameLogList.Items.Add(ListBoxLogItemList.Items.Strings[ListBoxLogItemList.ItemIndex]);
    ModValue();
  end;
end;

procedure TfrmViewList.ButtonGameLogDelClick(Sender: TObject);
begin
  if ListBoxGameLogList.ItemIndex >= 0 then
  begin
    ListBoxGameLogList.Items.Delete(ListBoxGameLogList.ItemIndex);
    ModValue();
  end;
  if ListBoxGameLogList.ItemIndex < 0 then
    ButtonGameLogDel.Enabled := False;
end;

procedure TfrmViewList.ButtonGameLogAddAllClick(Sender: TObject);
var
  i: Integer;
begin
  ListBoxGameLogList.Items.Clear;
  for i := 0 to ListBoxLogItemList.Items.Count - 1 do
  begin
    ListBoxGameLogList.Items.Add(ListBoxLogItemList.Items.Strings[i]);
  end;
  ModValue();
end;

procedure TfrmViewList.ButtonGameLogDelAllClick(Sender: TObject);
begin
  ListBoxGameLogList.Items.Clear;
  ButtonGameLogDel.Enabled := False;
  ModValue();
end;

procedure TfrmViewList.ButtonGameLogSaveClick(Sender: TObject);
var
  i: Integer;
begin
  g_GameLogItemNameList.Lock;
  try
    g_GameLogItemNameList.Clear;
    for i := 0 to ListBoxGameLogList.Items.Count - 1 do
    begin
      g_GameLogItemNameList.Add(ListBoxGameLogList.Items.Strings[i])
    end;
  finally
    g_GameLogItemNameList.UnLock;
  end;
  uModValue();
{$IF SoftVersion <> VERDEMO}
  SaveGameLogItemNameList();
{$IFEND}
  if
    Application.MessageBox('此设置必须重新加载物品数据库才能生效，是否重新加载？', '确认信息', MB_YESNO + MB_ICONQUESTION) = mrYes then
  begin
    FrmDB.LoadItemsDB();
  end;
end;

procedure TfrmViewList.RefAdminList();
var
  i: Integer;
  AdminInfo: pTAdminInfo;
begin
  ListBoxAdminList.Clear;
  EditAdminName.Text := '';
  EditAdminIPaddr.Text := '';
  EditAdminPremission.Value := 0;
  ButtonAdminListChange.Enabled := False;
  ButtonAdminListDel.Enabled := False;
  UserEngine.m_AdminList.Lock;
  try
    for i := 0 to UserEngine.m_AdminList.Count - 1 do
    begin
      AdminInfo := pTAdminInfo(UserEngine.m_AdminList.Items[i]);
{$IF VEROWNER = WL}
      ListBoxAdminList.Items.Add(AdminInfo.sChrName + ' - ' + IntToStr(AdminInfo.nLv) + ' - ' + AdminInfo.sIPaddr)
{$ELSE}
      ListBoxAdminList.Items.Add(AdminInfo.sChrName + ' - ' + IntToStr(AdminInfo.nLv))
{$IFEND}
    end;
  finally
    UserEngine.m_AdminList.UnLock;
  end;
end;

procedure TfrmViewList.RefNoClearMonList;
var
  i: Integer;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to UserEngine.MonsterList.Count - 1 do
    begin
{$IF USEHASHLIST = 1}
      ListBoxMonList.Items.Add(UserEngine.MonsterList.Keys[i]);
{$ELSE}
      MonInfo := pTMonInfo(UserEngine.MonsterList[i]);
      ListBoxMonList.Items.Add(MonInfo.sName);
{$IFEND}
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;

  g_NoClearMonList.Lock;
  try
    for i := 0 to g_NoClearMonList.Count - 1 do
    begin
      ListBoxNoClearMonList.Items.Add(g_NoClearMonList.Strings[i]);
    end;
  finally
    g_NoClearMonList.UnLock;
  end;
end;

procedure TfrmViewList.ButtonNoClearMonAddClick(Sender: TObject);
var
  i: Integer;
begin
  if ListBoxMonList.ItemIndex >= 0 then
  begin
    for i := 0 to ListBoxNoClearMonList.Items.Count - 1 do
    begin
      if ListBoxNoClearMonList.Items.Strings[i] = ListBoxMonList.Items.Strings[ListBoxMonList.ItemIndex] then
      begin
        Application.MessageBox('此物品已在列表中', '错误信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    ListBoxNoClearMonList.Items.Add(ListBoxMonList.Items.Strings[ListBoxMonList.ItemIndex]);
    ModValue();
  end;
end;

procedure TfrmViewList.ButtonNoClearMonDelClick(Sender: TObject);
begin
  if ListBoxNoClearMonList.ItemIndex >= 0 then
  begin
    ListBoxNoClearMonList.Items.Delete(ListBoxNoClearMonList.ItemIndex);
    ModValue();
  end;
  if ListBoxNoClearMonList.ItemIndex < 0 then
    ButtonNoClearMonDel.Enabled := False;
end;

procedure TfrmViewList.ButtonNoClearMonAddAllClick(Sender: TObject);
var
  i: Integer;
begin
  ListBoxNoClearMonList.Items.Clear;
  for i := 0 to ListBoxMonList.Items.Count - 1 do
  begin
    ListBoxNoClearMonList.Items.Add(ListBoxMonList.Items.Strings[i]);
  end;
  ModValue();
end;

procedure TfrmViewList.ButtonNoClearMonDelAllClick(Sender: TObject);
begin
  ListBoxNoClearMonList.Items.Clear;
  ButtonNoClearMonDel.Enabled := False;
  ModValue();
end;

procedure TfrmViewList.ButtonNoClearMonSaveClick(Sender: TObject);
var
  i: Integer;
begin
  g_NoClearMonList.Lock;
  try
    g_NoClearMonList.Clear;
    for i := 0 to ListBoxNoClearMonList.Items.Count - 1 do
    begin
      g_NoClearMonList.Add(ListBoxNoClearMonList.Items.Strings[i]);
    end;
  finally
    g_NoClearMonList.UnLock;
  end;
  SaveNoClearMonList();
  uModValue();
end;

procedure TfrmViewList.ListBoxNoClearMonListClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxNoClearMonList.ItemIndex >= 0 then
    ButtonNoClearMonDel.Enabled := True;
end;

procedure TfrmViewList.ListBoxMonListClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxMonList.ItemIndex >= 0 then
    ButtonNoClearMonAdd.Enabled := True;
end;

procedure TfrmViewList.ButtonAdminLitsSaveClick(Sender: TObject);
begin
  SaveAdminList();
  ButtonAdminLitsSave.Enabled := False;
end;

procedure TfrmViewList.ListBoxAdminListClick(Sender: TObject);
var
  nIndex: Integer;
  AdminInfo: pTAdminInfo;
begin
  nIndex := ListBoxAdminList.ItemIndex;
  UserEngine.m_AdminList.Lock;
  try
    if (nIndex < 0) and (nIndex >= UserEngine.m_AdminList.Count) then
      Exit;
    ButtonAdminListChange.Enabled := True;
    ButtonAdminListDel.Enabled := True;
    AdminInfo := UserEngine.m_AdminList.Items[nIndex];
    EditAdminName.Text := AdminInfo.sChrName;
    EditAdminIPaddr.Text := AdminInfo.sIPaddr;
    EditAdminPremission.Value := AdminInfo.nLv;
  finally
    UserEngine.m_AdminList.UnLock;
  end;
end;

procedure TfrmViewList.ButtonAdminListAddClick(Sender: TObject);
var
  i: Integer;
  sAdminName: string;
  sAdminIPaddr: string;
  nAdminPerMission: Integer;
  AdminInfo: pTAdminInfo;
begin
  sAdminName := Trim(EditAdminName.Text);
  sAdminIPaddr := Trim(EditAdminIPaddr.Text);
  nAdminPerMission := EditAdminPremission.Value;
  if (nAdminPerMission < 1) or (sAdminName = '') or not (nAdminPerMission in [0..10]) then
  begin
    Application.MessageBox('输入不正确', '提示信息', MB_OK + MB_ICONERROR);
    EditAdminName.SetFocus;
    Exit;
  end;
{$IF VEROWNER = WL}
  if (sAdminIPaddr = '') then
  begin
    Application.MessageBox('登录IP输入不正确', '提示信息', MB_OK + MB_ICONERROR);
    EditAdminIPaddr.SetFocus;
    Exit;
  end;
{$IFEND}

  UserEngine.m_AdminList.Lock;
  try
    for i := 0 to UserEngine.m_AdminList.Count - 1 do
    begin
      if CompareText(pTAdminInfo(UserEngine.m_AdminList.Items[i]).sChrName, sAdminName) = 0 then
      begin
        Application.MessageBox('输入的角色名已经在GM列表中', '提示信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    New(AdminInfo);
    AdminInfo.nLv := nAdminPerMission;
    AdminInfo.sChrName := sAdminName;
    AdminInfo.sIPaddr := sAdminIPaddr;
    UserEngine.m_AdminList.Add(AdminInfo);
  finally
    UserEngine.m_AdminList.UnLock;
  end;
  RefAdminList();
  ButtonAdminLitsSave.Enabled := True;
end;

procedure TfrmViewList.ButtonAdminListChangeClick(Sender: TObject);
var
  nIndex: Integer;
  sAdminName: string;
  sAdminIPaddr: string;
  nAdminPerMission: Integer;
  AdminInfo: pTAdminInfo;
begin
  nIndex := ListBoxAdminList.ItemIndex;
  if nIndex < 0 then
    Exit;

  sAdminName := Trim(EditAdminName.Text);
  sAdminIPaddr := Trim(EditAdminIPaddr.Text);
  nAdminPerMission := EditAdminPremission.Value;
  if (nAdminPerMission < 1) or (sAdminName = '') or not (nAdminPerMission in [0..10]) then
  begin
    Application.MessageBox('输入不正确', '提示信息', MB_OK + MB_ICONERROR);
    EditAdminName.SetFocus;
    Exit;
  end;
{$IF VEROWNER = WL}
  if (sAdminIPaddr = '') then
  begin
    Application.MessageBox('登录IP输入不正确', '提示信息', MB_OK +
      MB_ICONERROR);
    EditAdminIPaddr.SetFocus;
    Exit;
  end;
{$IFEND}
  UserEngine.m_AdminList.Lock;
  try
    if (nIndex < 0) and (nIndex >= UserEngine.m_AdminList.Count) then
      Exit;
    AdminInfo := UserEngine.m_AdminList.Items[nIndex];
    AdminInfo.sChrName := sAdminName;
    AdminInfo.nLv := nAdminPerMission;
    AdminInfo.sIPaddr := sAdminIPaddr;
  finally
    UserEngine.m_AdminList.UnLock;
  end;
  RefAdminList();
  ButtonAdminLitsSave.Enabled := True;
end;

procedure TfrmViewList.ButtonAdminListDelClick(Sender: TObject);
var
  nIndex: Integer;
begin
  nIndex := ListBoxAdminList.ItemIndex;
  if nIndex < 0 then
    Exit;
  UserEngine.m_AdminList.Lock;
  try
    if (nIndex < 0) and (nIndex >= UserEngine.m_AdminList.Count) then
      Exit;
    Dispose(pTAdminInfo(UserEngine.m_AdminList.Items[nIndex]));
    UserEngine.m_AdminList.Delete(nIndex);
  finally
    UserEngine.m_AdminList.UnLock;
  end;
  RefAdminList();
  ButtonAdminLitsSave.Enabled := True;
end;

procedure TfrmViewList.RefItemBindAccount;
var
  i: Integer;
  ItemBind: pTItemBind;
begin
  GridItemBindAccount.RowCount := 2;
  GridItemBindAccount.Cells[0, 1] := '';
  GridItemBindAccount.Cells[1, 1] := '';
  GridItemBindAccount.Cells[2, 1] := '';
  GridItemBindAccount.Cells[3, 1] := '';
  ButtonItemBindAcountMod.Enabled := False;
  ButtonItemBindAcountDel.Enabled := False;

  g_ItemBindAccount.Lock;
  try
    GridItemBindAccount.RowCount := g_ItemBindAccount.Count + 1;
    for i := 0 to g_ItemBindAccount.Count - 1 do
    begin
      ItemBind := g_ItemBindAccount.Items[i];
      if ItemBind <> nil then
      begin
        GridItemBindAccount.Cells[0, i + 1] :=
          UserEngine.GetStdItemName(ItemBind.nItemIdx);
        GridItemBindAccount.Cells[1, i + 1] := IntToStr(ItemBind.nItemIdx);
        GridItemBindAccount.Cells[2, i + 1] := IntToStr(ItemBind.nMakeIdex);
        GridItemBindAccount.Cells[3, i + 1] := ItemBind.sBindName;
      end;
    end;
  finally
    g_ItemBindAccount.UnLock;
  end;
end;

procedure TfrmViewList.RefItemLimit();
var
  i: Integer;
  nItemLimit: pTItemLimit;
begin
  g_ItemLimitList.Lock;
  try
    ListBoxLimitItemList.Clear;
    for i := 0 to g_ItemLimitList.Count - 1 do
    begin
      nItemLimit := g_ItemLimitList.Items[i];
      ListBoxLimitItemList.Items.AddObject(IntToStr(nItemLimit.nItemInedx) + '  ' + nItemLimit.sItemName, TObject(nItemLimit));
    end;
  finally
    g_ItemLimitList.UnLock;
  end;
end;

procedure TfrmViewList.GridItemBindAccountClick(Sender: TObject);
var
  nIndex: Integer;
  ItemBind: pTItemBind;
begin

  nIndex := GridItemBindAccount.Row - 1;
  if nIndex < 0 then
    Exit;

  g_ItemBindAccount.Lock;
  try
    if nIndex >= g_ItemBindAccount.Count then
      Exit;
    ItemBind := pTItemBind(g_ItemBindAccount.Items[nIndex]);
    EditItemBindAccountItemName.Text :=
      UserEngine.GetStdItemName(ItemBind.nItemIdx);
    EditItemBindAccountItemIdx.Value := ItemBind.nItemIdx;
    EditItemBindAccountItemMakeIdx.Value := ItemBind.nMakeIdex;
    EditItemBindAccountName.Text := ItemBind.sBindName;
  finally
    g_ItemBindAccount.UnLock;
  end;
  ButtonItemBindAcountDel.Enabled := True;
end;

procedure TfrmViewList.EditItemBindAccountItemIdxChange(Sender: TObject);
begin
  if EditItemBindAccountItemIdx.Text = '' then
  begin
    EditItemBindAccountItemIdx.Text := '0';
    Exit;
  end;
  EditItemBindAccountItemName.Text :=
    UserEngine.GetStdItemName(EditItemBindAccountItemIdx.Value);
  ButtonItemBindAcountMod.Enabled := True;
end;

procedure TfrmViewList.EditItemBindAccountItemMakeIdxChange(
  Sender: TObject);
begin
  if EditItemBindAccountItemIdx.Text = '' then
  begin
    EditItemBindAccountItemIdx.Text := '0';
    Exit;
  end;
  ButtonItemBindAcountMod.Enabled := True;
end;

procedure TfrmViewList.EditItemBindAccountNameChange(Sender: TObject);
begin
  ButtonItemBindAcountMod.Enabled := True;
end;

procedure TfrmViewList.ButtonItemBindAcountModClick(Sender: TObject);
var
  nSelIndex: Integer;
  nMakeIdex: Integer;
  nItemIdx: Integer;
  sBindName: string;
  ItemBind: pTItemBind;
begin
  nItemIdx := EditItemBindAccountItemIdx.Value;
  nMakeIdex := EditItemBindAccountItemMakeIdx.Value;
  sBindName := Trim(EditItemBindAccountName.Text);
  nSelIndex := GridItemBindAccount.Row - 1;
  if nSelIndex < 0 then
    Exit;
  g_ItemBindAccount.Lock;
  try
    if nSelIndex >= g_ItemBindAccount.Count then
      Exit;
    ItemBind := g_ItemBindAccount.Items[nSelIndex];
    ItemBind.nItemIdx := nItemIdx;
    ItemBind.nMakeIdex := nMakeIdex;
    ItemBind.sBindName := sBindName;
  finally
    g_ItemBindAccount.UnLock;
  end;
  SaveItemBindAccount();
  RefItemBindAccount();
end;

procedure TfrmViewList.ButtonItemBindAcountRefClick(Sender: TObject);
begin
  RefItemBindAccount();
end;

procedure TfrmViewList.ButtonItemBindAcountAddClick(Sender: TObject);
var
  i: Integer;
  nMakeIdex: Integer;
  nItemIdx: Integer;
  sBindName: string;
  ItemBind: pTItemBind;
begin
  nItemIdx := EditItemBindAccountItemIdx.Value;
  nMakeIdex := EditItemBindAccountItemMakeIdx.Value;
  sBindName := Trim(EditItemBindAccountName.Text);

  if (nItemIdx <= 0) or (nMakeIdex < 0) or (sBindName = '') then
  begin
    Application.MessageBox('输入的信息不正确', '提示信息', MB_OK +
      MB_ICONERROR);
    Exit;
  end;

  g_ItemBindAccount.Lock;
  try
    for i := 0 to g_ItemBindAccount.Count - 1 do
    begin
      ItemBind := g_ItemBindAccount.Items[i];
      if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then
      begin
        Application.MessageBox('此物品已经绑定到其他的帐号了', '提示信息',
          MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    New(ItemBind);
    ItemBind.nItemIdx := nItemIdx;
    ItemBind.nMakeIdex := nMakeIdex;
    ItemBind.sBindName := sBindName;
    g_ItemBindAccount.Insert(0, ItemBind);
  finally
    g_ItemBindAccount.UnLock;
  end;
  SaveItemBindAccount();
  RefItemBindAccount();
end;

procedure TfrmViewList.ButtonItemBindAcountDelClick(Sender: TObject);
var
  ItemBind: pTItemBind;
  nSelIndex: Integer;
begin

  nSelIndex := GridItemBindAccount.Row - 1;
  if nSelIndex < 0 then
    Exit;
  g_ItemBindAccount.Lock;
  try
    if nSelIndex >= g_ItemBindAccount.Count then
      Exit;
    ItemBind := g_ItemBindAccount.Items[nSelIndex];
    Dispose(ItemBind);
    g_ItemBindAccount.Delete(nSelIndex);
  finally
    g_ItemBindAccount.UnLock;
  end;
  SaveItemBindAccount();
  RefItemBindAccount();
end;

procedure TfrmViewList.RefItemBindCharName;
var
  i: Integer;
  ItemBind: pTItemBind;
begin
  GridItemBindCharName.RowCount := 2;
  GridItemBindCharName.Cells[0, 1] := '';
  GridItemBindCharName.Cells[1, 1] := '';
  GridItemBindCharName.Cells[2, 1] := '';
  GridItemBindCharName.Cells[3, 1] := '';
  ButtonItemBindCharNameMod.Enabled := False;
  ButtonItemBindCharNameDel.Enabled := False;
  g_ItemBindCharName.Lock;
  try
    GridItemBindCharName.RowCount := g_ItemBindCharName.Count + 1;
    for i := 0 to g_ItemBindCharName.Count - 1 do
    begin
      ItemBind := g_ItemBindCharName.Items[i];
      if ItemBind <> nil then
      begin
        GridItemBindCharName.Cells[0, i + 1] := UserEngine.GetStdItemName(ItemBind.nItemIdx);
        GridItemBindCharName.Cells[1, i + 1] := IntToStr(ItemBind.nItemIdx);
        GridItemBindCharName.Cells[2, i + 1] := IntToStr(ItemBind.nMakeIdex);
        GridItemBindCharName.Cells[3, i + 1] := ItemBind.sBindName;
      end;
    end;
  finally
    g_ItemBindCharName.UnLock;
  end;
end;

procedure TfrmViewList.GridItemBindCharNameClick(Sender: TObject);
var
  nIndex: Integer;
  ItemBind: pTItemBind;
begin

  nIndex := GridItemBindCharName.Row - 1;
  if nIndex < 0 then
    Exit;

  g_ItemBindCharName.Lock;
  try
    if nIndex >= g_ItemBindCharName.Count then
      Exit;
    ItemBind := pTItemBind(g_ItemBindCharName.Items[nIndex]);
    EditItemBindCharNameItemName.Text :=
      UserEngine.GetStdItemName(ItemBind.nItemIdx);
    EditItemBindCharNameItemIdx.Value := ItemBind.nItemIdx;
    EditItemBindCharNameItemMakeIdx.Value := ItemBind.nMakeIdex;
    EditItemBindCharNameName.Text := ItemBind.sBindName;
  finally
    g_ItemBindCharName.UnLock;
  end;
  ButtonItemBindCharNameDel.Enabled := True;
end;

procedure TfrmViewList.EditItemBindCharNameItemIdxChange(Sender: TObject);
begin
  if EditItemBindCharNameItemIdx.Text = '' then
  begin
    EditItemBindCharNameItemIdx.Text := '0';
    Exit;
  end;
  EditItemBindCharNameItemName.Text :=
    UserEngine.GetStdItemName(EditItemBindCharNameItemIdx.Value);
  ButtonItemBindCharNameMod.Enabled := True;
end;

procedure TfrmViewList.EditItemBindCharNameItemMakeIdxChange(
  Sender: TObject);
begin
  if EditItemBindCharNameItemMakeIdx.Text = '' then
  begin
    EditItemBindCharNameItemMakeIdx.Text := '0';
    Exit;
  end;
  ButtonItemBindCharNameMod.Enabled := True;
end;

procedure TfrmViewList.EditItemBindCharNameNameChange(Sender: TObject);
begin
  ButtonItemBindCharNameMod.Enabled := True;
end;

procedure TfrmViewList.ButtonItemBindCharNameAddClick(Sender: TObject);
var
  i: Integer;
  nMakeIdex: Integer;
  nItemIdx: Integer;
  sBindName: string;
  ItemBind: pTItemBind;
begin
  nItemIdx := EditItemBindCharNameItemIdx.Value;
  nMakeIdex := EditItemBindCharNameItemMakeIdx.Value;
  sBindName := Trim(EditItemBindCharNameName.Text);

  if (nItemIdx <= 0) or (nMakeIdex < 0) or (sBindName = '') then
  begin
    Application.MessageBox('输入的信息不正确', '提示信息', MB_OK + MB_ICONERROR);
    Exit;
  end;

  g_ItemBindCharName.Lock;
  try
    for i := 0 to g_ItemBindCharName.Count - 1 do
    begin
      ItemBind := g_ItemBindCharName.Items[i];
      if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then
      begin
        Application.MessageBox('此物品已经绑定到其他的角色上了', '提示信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    New(ItemBind);
    ItemBind.nItemIdx := nItemIdx;
    ItemBind.nMakeIdex := nMakeIdex;
    ItemBind.sBindName := sBindName;
    g_ItemBindCharName.Insert(0, ItemBind);
  finally
    g_ItemBindCharName.UnLock;
  end;
  SaveItemBindCharName();
  RefItemBindCharName();
end;

procedure TfrmViewList.ButtonItemBindCharNameModClick(Sender: TObject);
var
  nSelIndex: Integer;
  nMakeIdex: Integer;
  nItemIdx: Integer;
  sBindName: string;
  ItemBind: pTItemBind;
begin

  nItemIdx := EditItemBindCharNameItemIdx.Value;
  nMakeIdex := EditItemBindCharNameItemMakeIdx.Value;
  sBindName := Trim(EditItemBindCharNameName.Text);
  nSelIndex := GridItemBindCharName.Row - 1;
  if nSelIndex < 0 then
    Exit;

  g_ItemBindCharName.Lock;
  try
    if nSelIndex >= g_ItemBindCharName.Count then
      Exit;
    ItemBind := g_ItemBindCharName.Items[nSelIndex];
    ItemBind.nItemIdx := nItemIdx;
    ItemBind.nMakeIdex := nMakeIdex;
    ItemBind.sBindName := sBindName;
  finally
    g_ItemBindCharName.UnLock;
  end;

  SaveItemBindCharName();
  RefItemBindCharName();

end;

procedure TfrmViewList.ButtonItemBindCharNameDelClick(Sender: TObject);
var
  ItemBind: pTItemBind;
  nSelIndex: Integer;
begin

  nSelIndex := GridItemBindCharName.Row - 1;
  if nSelIndex < 0 then
    Exit;
  g_ItemBindCharName.Lock;
  try
    if nSelIndex >= g_ItemBindCharName.Count then
      Exit;
    ItemBind := g_ItemBindCharName.Items[nSelIndex];
    Dispose(ItemBind);
    g_ItemBindCharName.Delete(nSelIndex);
  finally
    g_ItemBindCharName.UnLock;
  end;
  SaveItemBindCharName();
  RefItemBindCharName();
end;

procedure TfrmViewList.ButtonItemBindCharNameRefClick(Sender: TObject);
begin
  RefItemBindCharName();
end;

procedure TfrmViewList.RefItemBindIPaddr;
var
  i: Integer;
  ItemBind: pTItemBind;
begin
  GridItemBindIPaddr.RowCount := 2;
  GridItemBindIPaddr.Cells[0, 1] := '';
  GridItemBindIPaddr.Cells[1, 1] := '';
  GridItemBindIPaddr.Cells[2, 1] := '';
  GridItemBindIPaddr.Cells[3, 1] := '';
  ButtonItemBindIPaddrMod.Enabled := False;
  ButtonItemBindIPaddrDel.Enabled := False;
  g_ItemBindIPaddr.Lock;
  try
    GridItemBindIPaddr.RowCount := g_ItemBindIPaddr.Count + 1;
    for i := 0 to g_ItemBindIPaddr.Count - 1 do
    begin
      ItemBind := g_ItemBindIPaddr.Items[i];
      if ItemBind <> nil then
      begin
        GridItemBindIPaddr.Cells[0, i + 1] :=
          UserEngine.GetStdItemName(ItemBind.nItemIdx);
        GridItemBindIPaddr.Cells[1, i + 1] := IntToStr(ItemBind.nItemIdx);
        GridItemBindIPaddr.Cells[2, i + 1] := IntToStr(ItemBind.nMakeIdex);
        GridItemBindIPaddr.Cells[3, i + 1] := ItemBind.sBindName;
      end;
    end;
  finally
    g_ItemBindIPaddr.UnLock;
  end;
end;

procedure TfrmViewList.GridItemBindIPaddrClick(Sender: TObject);
var
  nIndex: Integer;
  ItemBind: pTItemBind;
begin

  nIndex := GridItemBindIPaddr.Row - 1;
  if nIndex < 0 then
    Exit;

  g_ItemBindIPaddr.Lock;
  try
    if nIndex >= g_ItemBindIPaddr.Count then
      Exit;
    ItemBind := pTItemBind(g_ItemBindIPaddr.Items[nIndex]);
    EditItemBindIPaddrItemName.Text :=
      UserEngine.GetStdItemName(ItemBind.nItemIdx);
    EditItemBindIPaddrItemIdx.Value := ItemBind.nItemIdx;
    EditItemBindIPaddrItemMakeIdx.Value := ItemBind.nMakeIdex;
    EditItemBindIPaddrName.Text := ItemBind.sBindName;
  finally
    g_ItemBindIPaddr.UnLock;
  end;
  ButtonItemBindIPaddrDel.Enabled := True;
end;

procedure TfrmViewList.EditItemBindIPaddrItemIdxChange(Sender: TObject);
begin
  if EditItemBindIPaddrItemIdx.Text = '' then
  begin
    EditItemBindIPaddrItemIdx.Text := '0';
    Exit;
  end;
  EditItemBindIPaddrItemName.Text :=
    UserEngine.GetStdItemName(EditItemBindIPaddrItemIdx.Value);
  ButtonItemBindIPaddrMod.Enabled := True;
end;

procedure TfrmViewList.EditItemBindIPaddrItemMakeIdxChange(
  Sender: TObject);
begin
  if EditItemBindIPaddrItemMakeIdx.Text = '' then
  begin
    EditItemBindIPaddrItemMakeIdx.Text := '0';
    Exit;
  end;
  ButtonItemBindIPaddrMod.Enabled := True;
end;

procedure TfrmViewList.EditItemBindIPaddrNameChange(Sender: TObject);
begin
  ButtonItemBindIPaddrMod.Enabled := True;
end;

procedure TfrmViewList.ButtonItemBindIPaddrAddClick(Sender: TObject);
var
  i: Integer;
  nMakeIdex: Integer;
  nItemIdx: Integer;
  sBindName: string;
  ItemBind: pTItemBind;
begin
  nItemIdx := EditItemBindIPaddrItemIdx.Value;
  nMakeIdex := EditItemBindIPaddrItemMakeIdx.Value;
  sBindName := Trim(EditItemBindIPaddrName.Text);

  if not IsIPaddr(sBindName) then
  begin
    Application.MessageBox('IP地址格式输入不正确', '提示信息', MB_OK +
      MB_ICONERROR);
    EditItemBindIPaddrName.SetFocus;
    Exit;
  end;

  if (nItemIdx <= 0) or (nMakeIdex < 0) then
  begin
    Application.MessageBox('输入的信息不正确', '提示信息', MB_OK +
      MB_ICONERROR);
    Exit;
  end;

  g_ItemBindIPaddr.Lock;
  try
    for i := 0 to g_ItemBindIPaddr.Count - 1 do
    begin
      ItemBind := g_ItemBindIPaddr.Items[i];
      if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then
      begin
        Application.MessageBox('此物品已经绑定到其他的IP地址上了',
          '提示信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    New(ItemBind);
    ItemBind.nItemIdx := nItemIdx;
    ItemBind.nMakeIdex := nMakeIdex;
    ItemBind.sBindName := sBindName;
    g_ItemBindIPaddr.Insert(0, ItemBind);
  finally
    g_ItemBindIPaddr.UnLock;
  end;
  SaveItemBindIPaddr();
  RefItemBindIPaddr();
end;

procedure TfrmViewList.ButtonItemBindIPaddrModClick(Sender: TObject);
var
  nSelIndex: Integer;
  nMakeIdex: Integer;
  nItemIdx: Integer;
  sBindName: string;
  ItemBind: pTItemBind;
begin

  nItemIdx := EditItemBindIPaddrItemIdx.Value;
  nMakeIdex := EditItemBindIPaddrItemMakeIdx.Value;
  sBindName := Trim(EditItemBindIPaddrName.Text);
  if not IsIPaddr(sBindName) then
  begin
    Application.MessageBox('IP地址格式输入不正确', '提示信息', MB_OK +
      MB_ICONERROR);
    EditItemBindIPaddrName.SetFocus;
    Exit;
  end;
  nSelIndex := GridItemBindIPaddr.Row - 1;
  if nSelIndex < 0 then
    Exit;

  g_ItemBindIPaddr.Lock;
  try
    if nSelIndex >= g_ItemBindIPaddr.Count then
      Exit;
    ItemBind := g_ItemBindIPaddr.Items[nSelIndex];
    ItemBind.nItemIdx := nItemIdx;
    ItemBind.nMakeIdex := nMakeIdex;
    ItemBind.sBindName := sBindName;
  finally
    g_ItemBindIPaddr.UnLock;
  end;
  SaveItemBindIPaddr();
  RefItemBindIPaddr();
end;

procedure TfrmViewList.ButtonItemBindIPaddrDelClick(Sender: TObject);
var
  ItemBind: pTItemBind;
  nSelIndex: Integer;
begin

  nSelIndex := GridItemBindIPaddr.Row - 1;
  if nSelIndex < 0 then
    Exit;
  g_ItemBindIPaddr.Lock;
  try
    if nSelIndex >= g_ItemBindIPaddr.Count then
      Exit;
    ItemBind := g_ItemBindIPaddr.Items[nSelIndex];
    Dispose(ItemBind);
    g_ItemBindIPaddr.Delete(nSelIndex);
  finally
    g_ItemBindIPaddr.UnLock;
  end;
  SaveItemBindIPaddr();
  RefItemBindIPaddr();
end;

procedure TfrmViewList.ButtonItemBindIPaddrRefClick(Sender: TObject);
begin
  RefItemBindIPaddr();
end;

procedure TfrmViewList.RefItemCustomNameList;
var
  i: Integer;
  ItemName: pTItemName;
begin
  //  GridItemNameList.RowCount:=2;
  GridItemNameList.Cells[0, 1] := '';
  GridItemNameList.Cells[1, 1] := '';
  GridItemNameList.Cells[2, 1] := '';

  ButtonItemNameMod.Enabled := False;
  ButtonItemNameDel.Enabled := False;
  ItemUnit.m_ItemNameList.Lock;
  try
    GridItemNameList.RowCount := ItemUnit.m_ItemNameList.Count + 1;
    for i := 0 to ItemUnit.m_ItemNameList.Count - 1 do
    begin
      ItemName := ItemUnit.m_ItemNameList.Items[i];
      if ItemName <> nil then
      begin
        GridItemNameList.Cells[0, i + 1] :=
          UserEngine.GetStdItemName(ItemName.nItemIndex);
        GridItemNameList.Cells[1, i + 1] := IntToStr(ItemName.nMakeIndex);
        GridItemNameList.Cells[2, i + 1] := ItemName.sItemName;
      end;
    end;
  finally
    ItemUnit.m_ItemNameList.UnLock;
  end;
end;

procedure TfrmViewList.GridItemNameListClick(Sender: TObject);
var
  nIndex: Integer;
  ItemName: pTItemName;
begin

  nIndex := GridItemNameList.Row - 1;
  if nIndex < 0 then
    Exit;

  ItemUnit.m_ItemNameList.Lock;
  try
    if nIndex >= ItemUnit.m_ItemNameList.Count then
      Exit;
    ItemName := pTItemName(ItemUnit.m_ItemNameList.Items[nIndex]);
    EditItemNameOldName.Text := UserEngine.GetStdItemName(ItemName.nItemIndex);
    EditItemNameIdx.Value := ItemName.nItemIndex;
    EditItemNameMakeIndex.Value := ItemName.nMakeIndex;
    EditItemNameNewName.Text := ItemName.sItemName;
  finally
    ItemUnit.m_ItemNameList.UnLock;
  end;
  ButtonItemNameDel.Enabled := True;
end;

procedure TfrmViewList.EditItemNameIdxChange(Sender: TObject);
begin
  EditItemNameOldName.Text := UserEngine.GetStdItemName(EditItemNameIdx.Value);
  ButtonItemNameMod.Enabled := True;
end;

procedure TfrmViewList.EditItemNameMakeIndexChange(Sender: TObject);
begin
  ButtonItemNameMod.Enabled := True;
end;

procedure TfrmViewList.EditItemNameNewNameChange(Sender: TObject);
begin
  ButtonItemNameMod.Enabled := True;
end;

procedure TfrmViewList.ButtonItemNameAddClick(Sender: TObject);
var
  i: Integer;
  nMakeIdex: Integer;
  nItemIdx: Integer;
  sNewName: string;
  ItemName: pTItemName;
begin
  nItemIdx := EditItemNameIdx.Value;
  nMakeIdex := EditItemNameMakeIndex.Value;
  sNewName := Trim(EditItemNameNewName.Text);

  if (nItemIdx <= 0) or (nMakeIdex < 0) or (sNewName = '') then
  begin
    Application.MessageBox('输入的信息不正确', '提示信息', MB_OK +
      MB_ICONERROR);
    Exit;
  end;

  ItemUnit.m_ItemNameList.Lock;
  try
    for i := 0 to ItemUnit.m_ItemNameList.Count - 1 do
    begin
      ItemName := ItemUnit.m_ItemNameList.Items[i];
      if (ItemName.nItemIndex = nItemIdx) and (ItemName.nMakeIndex = nMakeIdex) then
      begin
        Application.MessageBox('此物品已经自定义过名称了', '提示信息',
          MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    New(ItemName);
    ItemName.nItemIndex := nItemIdx;
    ItemName.nMakeIndex := nMakeIdex;
    ItemName.sItemName := sNewName;
    ItemUnit.m_ItemNameList.Insert(0, ItemName);
  finally
    ItemUnit.m_ItemNameList.UnLock;
  end;
  ItemUnit.SaveCustomItemName();
  RefItemCustomNameList();
end;

procedure TfrmViewList.ButtonItemNameModClick(Sender: TObject);
var
  nSelIndex: Integer;
  nMakeIdex: Integer;
  nItemIdx: Integer;
  sNewName: string;
  ItemName: pTItemName;
begin
  nItemIdx := EditItemNameIdx.Value;
  nMakeIdex := EditItemNameMakeIndex.Value;
  sNewName := Trim(EditItemNameNewName.Text);
  nSelIndex := GridItemNameList.Row - 1;
  if nSelIndex < 0 then
    Exit;
  ItemUnit.m_ItemNameList.Lock;
  try
    if nSelIndex >= ItemUnit.m_ItemNameList.Count then
      Exit;
    ItemName := ItemUnit.m_ItemNameList.Items[nSelIndex];
    ItemName.nItemIndex := nItemIdx;
    ItemName.nMakeIndex := nMakeIdex;
    ItemName.sItemName := sNewName;
  finally
    ItemUnit.m_ItemNameList.UnLock;
  end;
  ItemUnit.SaveCustomItemName();
  RefItemCustomNameList();
end;

procedure TfrmViewList.ButtonItemNameDelClick(Sender: TObject);
var
  ItemName: pTItemName;
  nSelIndex: Integer;
begin

  nSelIndex := GridItemNameList.Row - 1;
  if nSelIndex < 0 then
    Exit;
  ItemUnit.m_ItemNameList.Lock;
  try
    if nSelIndex >= ItemUnit.m_ItemNameList.Count then
      Exit;
    ItemName := ItemUnit.m_ItemNameList.Items[nSelIndex];
    Dispose(ItemName);
    ItemUnit.m_ItemNameList.Delete(nSelIndex);
  finally
    ItemUnit.m_ItemNameList.UnLock;
  end;
  ItemUnit.SaveCustomItemName();
  RefItemCustomNameList();
end;

procedure TfrmViewList.ButtonItemNameRefClick(Sender: TObject);
begin
  RefItemCustomNameList();
end;

procedure TfrmViewList.EditClearTimeChange(Sender: TObject);
begin
  if EditClearTime.Text = '' then
  begin
    EditClearTime.Text := '0';
    Exit;
  end;
end;

procedure TfrmViewList.ButtonItemLimitAddClick(Sender: TObject);
var
  i: Integer;
  sItemName: string;
  nLimitItem: pTItemLimit;
begin
  if ListBoxServerItemList.ItemIndex >= 0 then
  begin
    sItemName := ListBoxServerItemList.Items.Strings[ListBoxServerItemList.ItemIndex];
    for i := 0 to ListBoxLimitItemList.Items.Count - 1 do
    begin
      nLimitItem := pTItemLimit(ListBoxLimitItemList.Items.Objects[i]);
      if nLimitItem.sItemName = sItemName then
      begin
        Application.MessageBox(PChar('物品：' + sItemName + ' 已在列表中！'), '错误信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    g_ItemLimitList.Lock;
    try
      New(nLimitItem);
      nLimitItem.sItemName := ListBoxServerItemList.Items.Strings[ListBoxServerItemList.ItemIndex];
      nLimitItem.nItemInedx := ListBoxServerItemList.ItemIndex;
      nLimitItem.boAllowMake := CheckBoxAllowMake.Checked;
      nLimitItem.boDisableMake := CheckBoxDisableMake.Checked;
      nLimitItem.boDisableTakeOff := CheckBoxDisableTakeOff.Checked;
      nLimitItem.boAllowSellOff := CheckBoxAllowSellOff.Checked;
      nLimitItem.boDisableSell := CheckBoxDisableSell.Checked;
      nLimitItem.boDisableDeal := CheckBoxDisableDeal.Checked;
      nLimitItem.boDisableDrop := CheckBoxDisableDrop.Checked;
      nLimitItem.boDisableStorage := CheckBoxDisableStorage.Checked;
      nLimitItem.boDispearOnLogon := CheckBoxDispearOnLogon.Checked;
      nLimitItem.boDisableUpgrade := CheckBoxDisableUpgrade.Checked;
      nLimitItem.boDisableRepair := CheckBoxDisableRepair.Checked;
      nLimitItem.boDropWithoutFail := CheckBoxDieDropWithOutFail.Checked;
      nLimitItem.boAbleDropInSafeZone := CheckBoxAbleDropInSafeZone.Checked;
      nLimitItem.boDisCustomName := CheckBoxdCustomName.Checked;
      nLimitItem.boDisallowHeroUse := CheckBoxDisallowHeroUse.Checked;
      nLimitItem.boDisallowPSell := CheckBoxDisablePSell.Checked;
      nLimitItem.boNoScatter := CheckBoxNoScatter.Checked;
      nLimitItem.bodTakeOn := CheckBoxDUse.Checked;
      nLimitItem.boMonDropItem := ChkMonDropItem.checked;
      nLimitItem.boPickItem := ChkPickItem.checked;
      g_ItemLimitList.Add(nLimitItem);
      RefItemLimit();
      ModValue();
    finally
      g_ItemLimitList.UnLock;
    end;
  end;
end;

procedure TfrmViewList.ButtonItemLimitDeleteClick(Sender: TObject);
var
  i: Integer;
begin
  if SelLimitItem = nil then
    Exit;
  g_ItemLimitList.Lock;
  try
    for i := 0 to g_ItemLimitList.Count - 1 do
    begin
      if SelLimitItem = g_ItemLimitList.Items[i] then
      begin
        Dispose(SelLimitItem);
        SelLimitItem := nil;
        g_ItemLimitList.Delete(i);
        RefItemLimit();
        Break;
      end;
    end;
    ModValue();
  finally
    g_ItemLimitList.UnLock;
  end;
end;

procedure TfrmViewList.ButtonItemLimitSaveClick(Sender: TObject);
begin
  ButtonItemLimitChangeClick(Sender);
  SaveItemLimitList();
  uModValue();
end;

procedure TfrmViewList.ListBoxLimitItemListClick(Sender: TObject);
var
  nSelIndex: Integer;
begin
  if not boOpened then
    Exit;
  uModValue();
  if ListBoxLimitItemList.ItemIndex >= 0 then
  begin
    ButtonItemLimitDelete.Enabled := True;
    ButtonItemLimitChange.Enabled := True;
  end;
  nSelIndex := ListBoxLimitItemList.ItemIndex;
  if nSelIndex >= 0 then
  begin
    SelLimitItem := pTItemLimit(ListBoxLimitItemList.Items.Objects[nSelIndex]);
    EditLimitItemName.Text := SelLimitItem.sItemName;
    EditLimitItemIndex.Text := IntToStr(SelLimitItem.nItemInedx);
    CheckBoxAllowMake.Checked := SelLimitItem.boAllowMake;
    CheckBoxDisableMake.Checked := SelLimitItem.boDisableMake;
    CheckBoxDisableTakeOff.Checked := SelLimitItem.boDisableTakeOff;
    CheckBoxAllowSellOff.Checked := SelLimitItem.boAllowSellOff;
    CheckBoxDisableSell.Checked := SelLimitItem.boDisableSell;
    CheckBoxDisableDeal.Checked := SelLimitItem.boDisableDeal;
    CheckBoxDisableDrop.Checked := SelLimitItem.boDisableDrop;
    CheckBoxDisableStorage.Checked := SelLimitItem.boDisableStorage;
    CheckBoxDispearOnLogon.Checked := SelLimitItem.boDispearOnLogon;
    CheckBoxDisableUpgrade.Checked := SelLimitItem.boDisableUpgrade;
    CheckBoxDisableRepair.Checked := SelLimitItem.boDisableRepair;
    CheckBoxDieDropWithOutFail.Checked := SelLimitItem.boDropWithoutFail;
    CheckBoxAbleDropInSafeZone.Checked := SelLimitItem.boAbleDropInSafeZone;
    CheckBoxdCustomName.Checked := SelLimitItem.boDisCustomName;
    CheckBoxDisallowHeroUse.Checked := SelLimitItem.boDisallowHeroUse;
    CheckBoxDisablePSell.Checked := SelLimitItem.boDisallowPSell;
    CheckBoxNoScatter.Checked := SelLimitItem.boNoScatter;
    CheckBoxDUse.Checked := SelLimitItem.bodTakeOn;
    ChkMonDropItem.Checked := SelLimitItem.boMonDropItem;
    ChkPickItem.Checked := SelLimitItem.boPickItem;
  end;
end;

procedure TfrmViewList.ListBoxServerItemListClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = ListBoxServerItemList then
  begin
    if ListBoxServerItemList.ItemIndex >= 0 then
      ButtonItemLimitAdd.Enabled := True;
  end;
end;

procedure TfrmViewList.ButtonItemLimitChangeClick(Sender: TObject);
begin
  if SelLimitItem = nil then
    Exit;
  SelLimitItem.sItemName := Trim(EditLimitItemName.Text);
  SelLimitItem.nItemInedx := StrToInt(Trim(EditLimitItemIndex.Text));
  SelLimitItem.boAllowMake := CheckBoxAllowMake.Checked;
  SelLimitItem.boDisableMake := CheckBoxDisableMake.Checked;
  SelLimitItem.boDisableTakeOff := CheckBoxDisableTakeOff.Checked;
  SelLimitItem.boAllowSellOff := CheckBoxAllowSellOff.Checked;
  SelLimitItem.boDisableSell := CheckBoxDisableSell.Checked;
  SelLimitItem.boDisableDeal := CheckBoxDisableDeal.Checked;
  SelLimitItem.boDisableDrop := CheckBoxDisableDrop.Checked;
  SelLimitItem.boDisableStorage := CheckBoxDisableStorage.Checked;
  SelLimitItem.boDispearOnLogon := CheckBoxDispearOnLogon.Checked;
  SelLimitItem.boDisableUpgrade := CheckBoxDisableUpgrade.Checked;
  SelLimitItem.boDisableRepair := CheckBoxDisableRepair.Checked;
  SelLimitItem.boDropWithoutFail := CheckBoxDieDropWithOutFail.Checked;
  SelLimitItem.boAbleDropInSafeZone := CheckBoxAbleDropInSafeZone.Checked;
  SelLimitItem.boDisCustomName := CheckBoxdCustomName.Checked;
  SelLimitItem.boDisallowHeroUse := CheckBoxDisallowHeroUse.Checked;
  SelLimitItem.boDisallowPSell := CheckBoxDisablePSell.Checked;
  SelLimitItem.boNoScatter := CheckBoxNoScatter.Checked;
  SelLimitItem.bodTakeOn := CheckBoxDUse.Checked;
  SelLimitItem.boMonDropItem := ChkMonDropItem.Checked;
  SelLimitItem.boPickItem := ChkPickItem.Checked;
  RefItemLimit();
  ModValue();
  ButtonItemLimitChange.Enabled := False;
end;

procedure TfrmViewList.CheckBoxAllowMakeClick(Sender: TObject);
begin
  ModValue();
end;

procedure TfrmViewList.ButtonItemLimitAddAllClick(Sender: TObject);
var
  i: Integer;
  nLimitItem: pTItemLimit;
begin
  g_ItemLimitList.Lock;
  try
    g_ItemLimitList.Clear;
    for i := 0 to ListBoxServerItemList.Items.Count - 1 do
    begin
      New(nLimitItem);
      nLimitItem.sItemName := ListBoxServerItemList.Items.Strings[i];
      nLimitItem.nItemInedx := i;
      nLimitItem.boAllowMake := CheckBoxAllowMake.Checked;
      nLimitItem.boDisableMake := CheckBoxDisableMake.Checked;
      nLimitItem.boDisableTakeOff := CheckBoxDisableTakeOff.Checked;
      nLimitItem.boAllowSellOff := CheckBoxAllowSellOff.Checked;
      nLimitItem.boDisableSell := CheckBoxDisableSell.Checked;
      nLimitItem.boDisableDeal := CheckBoxDisableDeal.Checked;
      nLimitItem.boDisableDrop := CheckBoxDisableDrop.Checked;
      nLimitItem.boDisableStorage := CheckBoxDisableStorage.Checked;
      nLimitItem.boDispearOnLogon := CheckBoxDispearOnLogon.Checked;
      nLimitItem.boDisableUpgrade := CheckBoxDisableUpgrade.Checked;
      nLimitItem.boDisableRepair := CheckBoxDisableRepair.Checked;
      nLimitItem.boDropWithoutFail := CheckBoxDieDropWithOutFail.Checked;
      nLimitItem.boAbleDropInSafeZone := CheckBoxAbleDropInSafeZone.Checked;
      nLimitItem.boDisCustomName := CheckBoxdCustomName.Checked;
      nLimitItem.boDisallowHeroUse := CheckBoxDisallowHeroUse.Checked;
      nLimitItem.boDisallowPSell := CheckBoxDisablePSell.Checked;
      nLimitItem.boNoScatter := CheckBoxNoScatter.Checked;
      nLimitItem.bodTakeOn := CheckBoxDUse.Checked;
      nLimitItem.boMonDropItem := ChkMonDropItem.Checked;
      nLimitItem.boPickItem := ChkPickItem.Checked;
      g_ItemLimitList.Add(nLimitItem);
    end;
    RefItemLimit();
    ModValue();
  finally
    g_ItemLimitList.UnLock;
  end;
end;

procedure TfrmViewList.ButtonItemLimitDeleteAllClick(Sender: TObject);
begin
  g_ItemLimitList.Lock;
  try
    ListBoxLimitItemList.Items.Clear;
    g_ItemLimitList.Clear;
    ModValue();
    ButtonItemLimitDelete.Enabled := False;
  finally
    g_ItemLimitList.UnLock;
  end;
end;

procedure TfrmViewList.LimitSelectAll(boCheck: Boolean);
begin
  CheckBoxAllowMake.Checked := boCheck;
  CheckBoxDisableMake.Checked := boCheck;
  CheckBoxDisableTakeOff.Checked := boCheck;
  CheckBoxAllowSellOff.Checked := boCheck;
  CheckBoxDisableSell.Checked := boCheck;
  CheckBoxDisableDeal.Checked := boCheck;
  CheckBoxDisableDrop.Checked := boCheck;
  CheckBoxDisableStorage.Checked := boCheck;
  CheckBoxDispearOnLogon.Checked := boCheck;
  CheckBoxDisableUpgrade.Checked := boCheck;
  CheckBoxDisableRepair.Checked := boCheck;
  CheckBoxDieDropWithOutFail.Checked := boCheck;
  CheckBoxAbleDropInSafeZone.Checked := boCheck;
  CheckBoxdCustomName.Checked := boCheck;
  CheckBoxDisallowHeroUse.Checked := boCheck;
  CheckBoxDisablePSell.Checked := boCheck;
  CheckBoxNoScatter.Checked := boCheck;
  ChkMonDropItem.Checked := boCheck;
  ChkPickItem.Checked := boCheck;
end;

procedure TfrmViewList.BitBtnSelectAllClick(Sender: TObject);
begin
  LimitSelectAll(True);
end;

procedure TfrmViewList.BitBtnUnSelectAllClick(Sender: TObject);
begin
  LimitSelectAll(False);
end;

procedure TfrmViewList.ListBoxServerItemListKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = $46) and (Shift = [ssCtrl]) then
    PopupMenu_FINDITEMBYNAMEClick(Sender);
end;

procedure TfrmViewList.PopupMenu_FINDITEMBYNAMEClick(Sender: TObject);
var
  i: Integer;
  sInputText: string;
  SC: string;
begin
  try
    if not BLUE_InputQuery('查找物品', '请输入您要查找的物品名字:', sInputText) then
      Exit;
    if sInputText = '' then
    begin
      Application.MessageBox('请输入物品名字', '错误信息', MB_OK + MB_ICONWARNING);
      Exit;
    end;
    for i := 0 to ListBoxServerItemList.Count - 1 do
    begin
      SC := ListBoxServerItemList.Items.Strings[i];
      if CompareText(SC, sInputText) = 0 then
      begin
        ListBoxServerItemList.ItemIndex := i;
        ListBoxServerItemListClick(Sender);
        Break;
      end;
    end;
  except
    MainOutMessageAPI('[Exception] ViewList::FindItemByItemName ItemName:' + sInputText);
  end;
end;

procedure TfrmViewList.rbYbClick(Sender: TObject);
begin
  if rbYb.Checked then
    g_Config.btSellType := 0
  else if rbGd.Checked then
    g_Config.btSellType := 1;
  Config.WriteInteger('Setup', 'btSellType', g_Config.btSellType);
end;

procedure TfrmViewList.ButtonQVFilterAddClick(Sender: TObject);
var
  sInputText: string;
begin
  if not BLUE_InputQuery('增加过滤字符', '请输入新的字符:', sInputText) then
    Exit;
  if sInputText = '' then
  begin
    Application.MessageBox('请输入正确的文本', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  if Sender = ButtonQVFilterAdd then
    ListBoxQueryValueFilter.Items.Add(sInputText)
  else if Sender = ButtonGuildRankNameFilterAdd then
    ListBoxGuildRankNameFilter.Items.Add(sInputText);
  ModValue();
end;

procedure TfrmViewList.ButtonQVFilterDelClick(Sender: TObject);
var
  nSelectIndex: Integer;
begin
  nSelectIndex := ListBoxQueryValueFilter.ItemIndex;
  if (nSelectIndex >= 0) and (nSelectIndex < ListBoxQueryValueFilter.Items.Count) then
  begin
    ListBoxQueryValueFilter.Items.Delete(nSelectIndex);
  end;
  if nSelectIndex >= ListBoxQueryValueFilter.Items.Count then
    ListBoxQueryValueFilter.ItemIndex := nSelectIndex - 1
  else
    ListBoxQueryValueFilter.ItemIndex := nSelectIndex;
  if ListBoxQueryValueFilter.ItemIndex < 0 then
  begin
    ButtonQVFilterDel.Enabled := False;
    ButtonQVFilterMod.Enabled := False;
  end;
  ModValue();
end;

procedure TfrmViewList.ListBoxQueryValueFilterClick(Sender: TObject);
begin
  if (ListBoxQueryValueFilter.ItemIndex >= 0) and
    (ListBoxQueryValueFilter.ItemIndex < ListBoxQueryValueFilter.Items.Count) then
  begin
    ButtonQVFilterDel.Enabled := True;
    ButtonQVFilterMod.Enabled := True;
  end;
end;

procedure TfrmViewList.ButtonQVFilterModClick(Sender: TObject);
var
  sInputText: string;
begin
  if (ListBoxQueryValueFilter.ItemIndex >= 0) and (ListBoxQueryValueFilter.ItemIndex < ListBoxQueryValueFilter.Items.Count) then
  begin
    sInputText := ListBoxQueryValueFilter.Items[ListBoxQueryValueFilter.ItemIndex];
    if not BLUE_InputQuery('修改过滤字符', '请输入新的字符:', sInputText) then
      Exit;
  end;
  if sInputText = '' then
  begin
    Application.MessageBox('请输入正确的字符', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  ListBoxQueryValueFilter.Items[ListBoxQueryValueFilter.ItemIndex] := sInputText;
  ModValue();
end;

procedure TfrmViewList.ListBoxQueryValueFilterDblClick(Sender: TObject);
begin
  ButtonQVFilterModClick(Sender);
end;
{
procedure TfrmViewList.ButtonQVFilterSaveClick(Sender: TObject);
var
  i                         : Integer;
begin
  g_QueryValueFilterList.Lock;
  try
    g_QueryValueFilterList.Clear;
    for i := 0 to ListBoxQueryValueFilter.Items.Count - 1 do begin
      g_QueryValueFilterList.Add(ListBoxQueryValueFilter.Items.Strings[i]);
    end;
  finally
    g_QueryValueFilterList.UnLock;
  end;
  SaveQueryValueFilterList();
  uModValue();
end;
}

procedure TfrmViewList.ButtonGuildRankNameFilterDelClick(Sender: TObject);
var
  nSelectIndex: Integer;
begin
  nSelectIndex := ListBoxGuildRankNameFilter.ItemIndex;
  if (nSelectIndex >= 0) and (nSelectIndex < ListBoxGuildRankNameFilter.Items.Count) then
    ListBoxGuildRankNameFilter.Items.Delete(nSelectIndex);
  if nSelectIndex >= ListBoxGuildRankNameFilter.Items.Count then
    ListBoxGuildRankNameFilter.ItemIndex := nSelectIndex - 1
  else
    ListBoxGuildRankNameFilter.ItemIndex := nSelectIndex;
  if ListBoxGuildRankNameFilter.ItemIndex < 0 then
  begin
    ButtonGuildRankNameFilterDel.Enabled := False;
    ButtonGuildRankNameFilterMob.Enabled := False;
  end;
  ModValue();
end;

procedure TfrmViewList.ButtonGuildRankNameFilterMobClick(Sender: TObject);
var
  sInputText: string;
begin
  if (ListBoxGuildRankNameFilter.ItemIndex >= 0) and (ListBoxGuildRankNameFilter.ItemIndex < ListBoxGuildRankNameFilter.Items.Count) then
  begin
    sInputText := ListBoxGuildRankNameFilter.Items[ListBoxGuildRankNameFilter.ItemIndex];
    if not BLUE_InputQuery('修改过滤字符', '请输入新的字符:', sInputText) then
      Exit;
  end;
  if sInputText = '' then
  begin
    Application.MessageBox('请输入正确的字符', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  ListBoxGuildRankNameFilter.Items[ListBoxGuildRankNameFilter.ItemIndex] := sInputText;
  ModValue();
end;

procedure TfrmViewList.ButtonGuildRankNameFilterSaveClick(Sender: TObject);
var
  i: Integer;
begin
  g_GuildRankNameFilterList.Lock;
  try
    g_GuildRankNameFilterList.Clear;
    for i := 0 to ListBoxGuildRankNameFilter.Items.Count - 1 do
    begin
      g_GuildRankNameFilterList.Add(ListBoxGuildRankNameFilter.Items.Strings[i]);
    end;
  finally
    g_GuildRankNameFilterList.UnLock;
  end;
  SaveGuildRankNameFilterList();
  uModValue();
end;

procedure TfrmViewList.ListBoxGuildRankNameFilterDblClick(Sender: TObject);
begin
  ButtonGuildRankNameFilterMobClick(Sender);
end;

procedure TfrmViewList.ListBoxGuildRankNameFilterClick(Sender: TObject);
begin
  if (ListBoxGuildRankNameFilter.ItemIndex >= 0) and
    (ListBoxGuildRankNameFilter.ItemIndex < ListBoxGuildRankNameFilter.Items.Count) then
  begin
    ButtonGuildRankNameFilterDel.Enabled := True;
    ButtonGuildRankNameFilterMob.Enabled := True;
  end;
end;

procedure TfrmViewList.RefUserCmdList();
var
  i: Integer;
begin
  ListBoxUserCmd.Clear;
  EditUserCmd.Text := '';
  SpinEditUserCmd.Value := 0;
  ButtonUserCmdDel.Enabled := False;
  g_UserCmdList.Lock;
  try
    for i := 0 to g_UserCmdList.Count - 1 do
      ListBoxUserCmd.Items.AddObject(g_UserCmdList.Strings[i] + ' - ' + IntToStr(Integer(g_UserCmdList.Objects[i])), g_UserCmdList.Objects[i]);
  finally
    g_UserCmdList.UnLock;
  end;
end;

procedure TfrmViewList.ListBoxUserCmdClick(Sender: TObject);
var
  nIndex: Integer;
  sTemp, sUserCmd: string;
begin
  nIndex := ListBoxUserCmd.ItemIndex;
  if (nIndex < 0) and (nIndex >= g_UserCmdList.Count) then
    Exit;
  ButtonUserCmdDel.Enabled := True;
  sTemp := ListBoxUserCmd.Items.Strings[nIndex];
  GetValidStr3(sTemp, sUserCmd, [' ', #9]);
  EditUserCmd.Text := sUserCmd;
  SpinEditUserCmd.Value := Integer(ListBoxUserCmd.Items.Objects[nIndex]);
end;

procedure TfrmViewList.ButtonUserCmdAddClick(Sender: TObject);
var
  i, nCmdNo: Integer;
  sUserCmd: string;
begin
  sUserCmd := Trim(EditUserCmd.Text);
  nCmdNo := SpinEditUserCmd.Value;
  if sUserCmd = '' then
  begin
    Application.MessageBox('命令名称输入不正确', '提示信息', MB_OK + MB_ICONERROR);
    EditUserCmd.SetFocus;
    Exit;
  end;
  g_UserCmdList.Lock;
  try
    for i := 0 to g_UserCmdList.Count - 1 do
    begin
      if CompareText(g_UserCmdList.Strings[i], sUserCmd) = 0 then
      begin
        Application.MessageBox('输入的命令名已经在列表中', '提示信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
      if Integer(g_UserCmdList.Objects[i]) = nCmdNo then
      begin
        Application.MessageBox('输入的命令编号已经在列表中', '提示信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    g_UserCmdList.AddObject(sUserCmd, TObject(nCmdNo));
  finally
    g_UserCmdList.UnLock;
  end;
  RefUserCmdList();
  ButtonUserCmdSav.Enabled := True;
end;

procedure TfrmViewList.ButtonUserCmdDelClick(Sender: TObject);
var
  nIndex: Integer;
begin
  nIndex := ListBoxUserCmd.ItemIndex;
  if nIndex < 0 then
    Exit;
  g_UserCmdList.Lock;
  try
    if (nIndex < 0) and (nIndex >= g_UserCmdList.Count) then
      Exit;
    g_UserCmdList.Delete(nIndex);
  finally
    g_UserCmdList.UnLock;
  end;
  RefUserCmdList();
  ButtonUserCmdSav.Enabled := True;
end;

procedure TfrmViewList.ButtonUserCmdSavClick(Sender: TObject);
begin
  SaveUserCmdList();
  ButtonUserCmdSav.Enabled := False;
end;

procedure TfrmViewList.cbPresendItemClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boPresendItem := cbPresendItem.Checked;
  Config.WriteBool('Setup', 'PresendItem', g_Config.boPresendItem);
end;

procedure TfrmViewList.ListBoxPetPickUpItemListClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxPetPickUpItemList.ItemIndex >= 0 then
    ButtonPetPickUpItemDel.Enabled := True;
end;

procedure TfrmViewList.ListBoxItemListClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxItemList.ItemIndex >= 0 then
    ButtonPetPickUpItemAdd.Enabled := True;
end;

procedure TfrmViewList.ButtonPetPickUpItemAddClick(Sender: TObject);
var
  i: Integer;
begin
  if ListBoxItemList.ItemIndex >= 0 then
  begin
    for i := 0 to ListBoxPetPickUpItemList.Items.Count - 1 do
    begin
      if ListBoxPetPickUpItemList.Items.Strings[i] =
        ListBoxItemList.Items.Strings[ListBoxItemList.ItemIndex] then
      begin
        Application.MessageBox('此物品已在列表中', '错误信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    ListBoxPetPickUpItemList.Items.Add(ListBoxItemList.Items.Strings[ListBoxItemList.ItemIndex]);
    ModValue();
  end;
end;

procedure TfrmViewList.ButtonPetPickUpItemDelClick(Sender: TObject);
begin
  if ListBoxPetPickUpItemList.ItemIndex >= 0 then
  begin
    ListBoxPetPickUpItemList.Items.Delete(ListBoxPetPickUpItemList.ItemIndex);
    ModValue();
  end;
  if ListBoxPetPickUpItemList.ItemIndex < 0 then
    ButtonPetPickUpItemDel.Enabled := False;
end;

procedure TfrmViewList.ButtonPetPickUpItemAddAllClick(Sender: TObject);
var
  i: Integer;
begin
  ListBoxPetPickUpItemList.Items.Clear;
  for i := 0 to ListBoxItemList.Items.Count - 1 do
  begin
    ListBoxPetPickUpItemList.Items.Add(ListBoxItemList.Items.Strings[i]);
  end;
  ModValue();
end;

procedure TfrmViewList.ButtonPetPickUpItemDelAllClick(Sender: TObject);
begin
  ListBoxPetPickUpItemList.Items.Clear;
  ButtonPetPickUpItemDel.Enabled := False;
  ModValue();
end;

procedure TfrmViewList.ButtonPetPickUpItemSaveClick(Sender: TObject);
var
  i: Integer;
begin
  g_PetPickItemList.Lock;
  try
    g_PetPickItemList.Clear;
    for i := 0 to ListBoxPetPickUpItemList.Items.Count - 1 do
    begin
      g_PetPickItemList.Add(ListBoxPetPickUpItemList.Items.Strings[i])
    end;
  finally
    g_PetPickItemList.UnLock;
  end;
  uModValue();
  SavePetPickItemList();
  FrmDB.LoadItemsDB();
end;

procedure TfrmViewList.ListBoxUpgradeItemListClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxUpgradeItemList.ItemIndex >= 0 then
    ButtonUpgradeItemDel.Enabled := True;
end;

procedure TfrmViewList.ListBoxItemListAllClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxItemListAll.ItemIndex >= 0 then
    ButtonUpgradeItemAdd.Enabled := True;
end;

procedure TfrmViewList.ButtonUpgradeItemAddClick(Sender: TObject);
var
  i: Integer;
begin
  if ListBoxItemListAll.ItemIndex >= 0 then
  begin
    for i := 0 to ListBoxUpgradeItemList.Items.Count - 1 do
    begin
      if ListBoxUpgradeItemList.Items.Strings[i] =
        ListBoxItemListAll.Items.Strings[ListBoxItemListAll.ItemIndex] then
      begin
        Application.MessageBox('此物品已在列表中', '错误信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    ListBoxUpgradeItemList.Items.Add(ListBoxItemListAll.Items.Strings[ListBoxItemListAll.ItemIndex]);
    ModValue();
  end;
end;

procedure TfrmViewList.ButtonUpgradeItemDelClick(Sender: TObject);
var
  i, ii: Integer;
begin
  if ListBoxUpgradeItemList.SelCount > 0 then
  begin
    for ii := 0 to ListBoxUpgradeItemList.SelCount - 1 do
    begin
      i := 0;
      while True do
      begin
        if i >= ListBoxUpgradeItemList.Items.Count then
          Break;
        if ListBoxUpgradeItemList.Selected[i] then
          ListBoxUpgradeItemList.Items.Delete(i);
        Inc(i);
      end;
      ModValue();
    end;
  end;
  if ListBoxUpgradeItemList.ItemIndex < 0 then
    ButtonUpgradeItemDel.Enabled := False;
end;

procedure TfrmViewList.ButtonUpgradeItemAddAllClick(Sender: TObject);
var
  i: Integer;
begin
  ListBoxUpgradeItemList.Items.Clear;
  for i := 0 to ListBoxItemListAll.Items.Count - 1 do
  begin
    ListBoxUpgradeItemList.Items.Add(ListBoxItemListAll.Items.Strings[i]);
  end;
  ModValue();
end;

procedure TfrmViewList.ButtonUpgradeItemDelAllClick(Sender: TObject);
begin
  ListBoxUpgradeItemList.Items.Clear;
  ButtonUpgradeItemDel.Enabled := False;
  ModValue();
end;

procedure TfrmViewList.ButtonUpgradeItemSaveClick(Sender: TObject);
var
  i: Integer;
begin
  g_UpgradeItemList.Lock;
  try
    g_UpgradeItemList.Clear;
    for i := 0 to ListBoxUpgradeItemList.Items.Count - 1 do
    begin
      g_UpgradeItemList.Add(ListBoxUpgradeItemList.Items.Strings[i])
    end;
  finally
    g_UpgradeItemList.UnLock;
  end;
  uModValue();
  SaveUpgradeItemList();
end;

procedure TfrmViewList.ListBoxShopItemListClick(Sender: TObject);
var
  nIndex: Integer;
begin
  nIndex := ListBoxShopItemList.ItemIndex;
  if (nIndex < 0) or (nIndex >= ListBoxShopItemList.Count) then
    Exit;
  EditShopItemName.Text := ListBoxShopItemList.Items.Strings[nIndex];
  SpinEditShopItemIdx1.Value := Integer(ListBoxShopItemList.Items.Objects[nIndex]);
  btnShopItemAdd.Enabled := True;
end;

procedure TfrmViewList.ListViewShopItemListClick(Sender: TObject);
var
  ListItem: TListItem;
  nIndex: Integer;
begin
  nIndex := ListViewShopItemList.ItemIndex;
  if (nIndex < 0) or (nIndex >= g_ShopItemList.Count) then
    Exit;
  ListItem := ListViewShopItemList.Items.item[nIndex];
  cmbItemType.ItemIndex := StrToInt(ListItem.Caption);
  EditShopItemName.Text := ListItem.SubItems.Strings[0];
  SpinEditShopItemIdx1.Text := ListItem.SubItems.Strings[1];
  EditShopItemPrice.Text := ListItem.SubItems.Strings[2];
  SpinEditShopItemIdx2.Text := ListItem.SubItems.Strings[3];
  SpinEditShopItemIdx3.Text := ListItem.SubItems.Strings[4];
  if strToInt(ListItem.SubItems.Strings[5]) = 1 then
    cbPresendItem.Checked := True
  else
    cbPresendItem.Checked := False;

  if strToInt(ListItem.SubItems.Strings[6]) = 0 then
  begin
    rbYb.Checked := True;
    rbGd.Checked := False;
  end
  else
  begin
    rbYb.Checked := False;
    rbGd.Checked := True;
  end;

   EditShopItemDetail.Text := ListItem.SubItems.Strings[7];

  btnShopItemDel.Enabled := True;
  btnShopItemAdd.Enabled := True;
end;

procedure TfrmViewList.btnShopItemAddClick(Sender: TObject);
var
  sItemName, sItemDse: string;
  i, nItemPrice: Integer;
  ListItem: TListItem;
begin
  sItemName := Trim(EditShopItemName.Text);
  nItemPrice := EditShopItemPrice.Value;
  sItemDse := EditShopItemDetail.Text;
  if sItemName = '' then
  begin
    Application.MessageBox('物品名称输入不正确！', '提示信息', MB_OK + MB_ICONERROR);
    EditShopItemName.SetFocus;
    Exit;
  end;
  if nItemPrice <= 0 then
  begin
    Application.MessageBox('物品价格输入不正确！', '提示信息', MB_OK + MB_ICONERROR);
    EditShopItemPrice.SetFocus;
    Exit;
  end;
  if sItemDse = '' then
  begin
    Application.MessageBox('请输入物品出售描述！', '提示信息', MB_OK + MB_ICONERROR);
    EditShopItemDetail.SetFocus;
    Exit;
  end;

  if cmbItemType.ItemIndex = -1 then
  begin
    Application.MessageBox('请选择物品类别！', '提示信息', MB_OK + MB_ICONERROR);
    cmbItemType.SetFocus;
    Exit;
  end;
  for i := 0 to ListViewShopItemList.Items.Count - 1 do
  begin
    ListItem := ListViewShopItemList.Items.item[i];
    if CompareText(ListItem.SubItems.Strings[0], sItemName) = 0 then
    begin
      Application.MessageBox('输入的物品已经在列表中！', '提示信息', MB_OK + MB_ICONERROR);
      Exit;
    end;
  end;
  ListItem := ListViewShopItemList.Items.Add;
  ListItem.Caption := IntToStr(cmbItemType.ItemIndex);
  ListItem.SubItems.Add(sItemName);
  ListItem.SubItems.Add(IntToStr(SpinEditShopItemIdx1.Value));
  ListItem.SubItems.Add(IntToStr(nItemPrice));
  ListItem.SubItems.Add(IntToStr(SpinEditShopItemIdx2.Value));
  ListItem.SubItems.Add(IntToStr(SpinEditShopItemIdx3.Value));
  if cbPresendItem.Checked then
  begin
    ListItem.SubItems.Add(IntToStr(1));
  end
  else
  begin
    ListItem.SubItems.Add(IntToStr(0));
  end;

  if rbYb.Checked then
  begin
    ListItem.SubItems.Add(IntToStr(0));
  end
  else if rbGd.Checked then
  begin
    ListItem.SubItems.Add(IntToStr(1));
  end;
  ListItem.SubItems.Add(sItemDse);
  btnShopItemSave.Enabled := True;
end;

procedure TfrmViewList.btnShopItemDelClick(Sender: TObject);
var
  nIndex: Integer;
begin
  nIndex := ListViewShopItemList.ItemIndex;
  if nIndex < 0 then
    Exit;
  ListViewShopItemList.Items.Delete(nIndex);
  btnShopItemSave.Enabled := True;
end;

procedure TfrmViewList.btnShopItemSaveClick(Sender: TObject);
var
  i: Integer;
  sFileName: string;
  ListItem: TListItem;
  LoadList: TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'ShopItemList.txt';
  LoadList := TStringList.Create;
  LoadList.Add(';物品类别'#9'物品名称'#9'Item.wil序号'#9'出售价格'#9'Deco.wil序号1'#9'Deco.wil序号2'#9'允许赠送'#9'出售方式'#9'描述');
  for i := 0 to ListViewShopItemList.Items.Count - 1 do
  begin
    ListItem := ListViewShopItemList.Items.item[i];
    LoadList.Add(ListItem.Caption + #9 +
      ListItem.SubItems.Strings[0] + #9 +
      ListItem.SubItems.Strings[1] + #9 +
      ListItem.SubItems.Strings[2] + #9 +
      ListItem.SubItems.Strings[3] + #9 +
      ListItem.SubItems.Strings[4] + #9 +
      ListItem.SubItems.Strings[5] + #9 +
      ListItem.SubItems.Strings[6] + #9 +
      ListItem.SubItems.Strings[7]);
  end;
  LoadList.Sort;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;
  btnShopItemSave.Enabled := False;
  btnReloadShopItemList.Enabled := True;
end;

procedure TfrmViewList.btnReloadShopItemListClick(Sender: TObject);
var
  ListItem: TListItem;
  i, nPrice: Integer;
  sFileName: string;
  sLineText: string;
  sItemClass: string;
  sItemName: string;
  s1, s2, s3: string;
  sItemPrice: string;
  sItemDes: string;
  ShopItem: pTShopItem;
begin
  LoadShopItemList();
  btnReloadShopItemList.Enabled := False;

  ListViewShopItemList.Clear;
  for i := 0 to g_ShopItemList.Count -1 do
  begin
    ShopItem := g_ShopItemList.items[i];
    ListItem := ListViewShopItemList.Items.Add;
    ListItem.Caption := IntToStr(ShopItem.btClass);
    ListItem.SubItems.Add(shopItem.sItemName);
    ListItem.SubItems.Add(IntToStr(shopItem.wLooks));
    ListItem.SubItems.Add(IntToStr(shopItem.wPrice));
    ListItem.SubItems.Add(IntToStr(shopItem.wShape1));
    ListItem.SubItems.Add(IntToStr(shopItem.wShape2));
    ListItem.SubItems.Add(IntToStr(shopItem.wPresent));
    ListItem.SubItems.Add(IntToStr(shopItem.wMarketType));
    ListItem.SubItems.Add(shopItem.sExplain);
  end;

  Application.MessageBox('重新加载商铺物品列表完成！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmViewList.btnSuiteItemAddClick(Sender: TObject);
var
  nC: Integer;
  sItemName, sItemDesc: string;
  SuiteItems: pTSuiteItems;
begin
  sItemName := Trim(Edit1.Text) + Trim(Edit2.Text) + Trim(Edit3.Text) + Trim(Edit4.Text) + Trim(Edit5.Text) + Trim(Edit6.Text) + Trim(Edit7.Text) + Trim(Edit8.Text) + Trim(Edit9.Text) + Trim(Edit10.Text) + Trim(Edit11.Text) + Trim(Edit12.Text) + Trim(Edit13.Text);
  sItemDesc := Trim(EditSuiteEffectMsg.Text);
  if sItemName = '' then
  begin
    Application.MessageBox('套装物品名称输入不正确！', '提示信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  if sItemDesc = '' then
  begin
    Application.MessageBox('请输入套装物品生效描述！', '提示信息', MB_OK + MB_ICONERROR);
    EditSuiteEffectMsg.SetFocus;
    Exit;
  end;
  New(SuiteItems);
  FillChar(SuiteItems^, SizeOf(TSuiteItems), #0);
  SuiteItems.sDesc := sItemDesc;
  SuiteItems.asSuiteName[0] := Trim(Edit1.Text);
  SuiteItems.asSuiteName[1] := Trim(Edit2.Text);
  SuiteItems.asSuiteName[2] := Trim(Edit3.Text);
  SuiteItems.asSuiteName[3] := Trim(Edit4.Text);
  SuiteItems.asSuiteName[4] := Trim(Edit5.Text);
  SuiteItems.asSuiteName[5] := Trim(Edit6.Text);
  SuiteItems.asSuiteName[6] := Trim(Edit7.Text);
  SuiteItems.asSuiteName[7] := Trim(Edit8.Text);
  SuiteItems.asSuiteName[8] := Trim(Edit9.Text);
  SuiteItems.asSuiteName[9] := Trim(Edit10.Text);
  SuiteItems.asSuiteName[10] := Trim(Edit11.Text);
  SuiteItems.asSuiteName[11] := Trim(Edit12.Text);
  SuiteItems.asSuiteName[12] := Trim(Edit13.Text);

  SuiteItems.aSuitSubRate[0] := EditSuiteMaxHP.Value;
  SuiteItems.aSuitSubRate[1] := EditSuiteMaxMP.Value;
  SuiteItems.aSuitSubRate[2] := EditSubACRate.Value;
  SuiteItems.aSuitSubRate[3] := EditSubMACRate.Value;
  SuiteItems.aSuitSubRate[4] := EditSubDCRate.Value;
  SuiteItems.aSuitSubRate[5] := EditSubMCRate.Value;
  SuiteItems.aSuitSubRate[6] := EditSubSCRate.Value;
  SuiteItems.aSuitSubRate[7] := EditSuiteHitPoint.Value;
  SuiteItems.aSuitSubRate[8] := EditSuiteSPDPoint.Value;
  SuiteItems.aSuitSubRate[9] := EditSuiteAntiMagic.Value;
  SuiteItems.aSuitSubRate[10] := EditSuileAntiPoison.Value;
  SuiteItems.aSuitSubRate[11] := EditSuitePoisonRecover.Value;
  SuiteItems.aSuitSubRate[12] := EditSuiteHPRecover.Value;
  SuiteItems.aSuitSubRate[13] := EditSuiteMPRecover.Value;
  if CheckBoxParalysis.Checked then
    Inc(SuiteItems.aSuitSubRate[14]);
  if CheckBoxMagicShield.Checked then
    Inc(SuiteItems.aSuitSubRate[15]);
  if CheckBoxTeleport.Checked then
    Inc(SuiteItems.aSuitSubRate[16]);
  if CheckBoxRevival.Checked then
    Inc(SuiteItems.aSuitSubRate[17]);
  if CheckBoxMuscleRing.Checked then
    Inc(SuiteItems.aSuitSubRate[18]);
  if CheckBoxFastTrain.Checked then
    Inc(SuiteItems.aSuitSubRate[19]);
  if CheckBoxProbeNecklace.Checked then
    Inc(SuiteItems.aSuitSubRate[20]);
  if CheckBoxHongMoSuite.Checked then
    Inc(SuiteItems.aSuitSubRate[21]);
  if CheckBoxHideMode.Checked then
    Inc(SuiteItems.aSuitSubRate[22]);
  if CheckBoxUnParalysis.Checked then
    Inc(SuiteItems.aSuitSubRate[23]);
  if CheckBoxUnAllParalysis.Checked then
    Inc(SuiteItems.aSuitSubRate[24]);
  if CheckBoxUnRevival.Checked then
    Inc(SuiteItems.aSuitSubRate[25]);
  if CheckBoxUnMagicShield.Checked then
    Inc(SuiteItems.aSuitSubRate[26]);
  if CheckBoxRecallSuite.Checked then
    Inc(SuiteItems.aSuitSubRate[27]);
  if CheckBoxNoDropItem.Checked then
    Inc(SuiteItems.aSuitSubRate[28]);
  if CheckBoxNoDropUseItem.Checked then
    Inc(SuiteItems.aSuitSubRate[29]);

  SuiteItems.aSuitSubRate[30] := SpinEdit1.Value;
  SuiteItems.aSuitSubRate[31] := SpinEdit2.Value;
  SuiteItems.aSuitSubRate[32] := SpinEdit3.Value;
  SuiteItems.aSuitSubRate[33] := SpinEdit4.Value;
  SuiteItems.aSuitSubRate[34] := SpinEdit5.Value;
  SuiteItems.aSuitSubRate[35] := SpinEdit6.Value;
  SuiteItems.aSuitSubRate[36] := SpinEdit7.Value;
  SuiteItems.aSuitSubRate[37] := SpinEdit8.Value;
  SuiteItems.aSuitSubRate[38] := SpinEdit9.Value;
  SuiteItems.aSuitSubRate[39] := SpinEdit10.Value;

  if CheckBox1.Checked then
    SuiteItems.SendToClient := True;

  EditReNewNameColor1.Value := SuiteItems.ItemColor;
  EditReNewNameColor2.Value := SuiteItems.AbilColor;

  for nC := Low(TSuiteNames) to High(TSuiteNames) do
    if SuiteItems.asSuiteName[nC] <> '' then
      Inc(SuiteItems.nNeedCount);

  g_SuiteItemsList.Add(SuiteItems);
  RefSuitItemList();
  btnSuiteItemSave.Enabled := True;
end;

procedure TfrmViewList.btnSuiteItemDelClick(Sender: TObject);
var
  i: Integer;
begin
  if g_SuiteItems = nil then
    Exit;
  for i := g_SuiteItemsList.Count - 1 downto 0 do
  begin
    if g_SuiteItems = g_SuiteItemsList.Items[i] then
    begin
      Dispose(g_SuiteItems);
      g_SuiteItems := nil;
      g_SuiteItemsList.Delete(i);
      //g_ListItemSuite := nil;
      RefSuitItemList();
      Break;
    end;
  end;
  btnSuiteItemSave.Enabled := True;
end;

procedure TfrmViewList.btnSuiteItemSaveClick(Sender: TObject);
var
  i, ii: Integer;
  sStr, sLineText, sFileName: string;
  SuiteItems: pTSuiteItems;
  ini: TIniFile;
  //pstd                      : pTStdItem;
begin
  if g_SuiteItemsList.Count <= 0 then
    Exit;

  sFileName := g_Config.sEnvirDir + 'SuiteItemsList.txt';
  ini := TIniFile.Create(sFileName);
  for i := Low(TSuiteIndex) to High(TSuiteIndex) do
    if ini.SectionExists(IntToStr(i)) then
      ini.EraseSection(IntToStr(i));
  ini.WriteInteger('SuiteItems', 'Count', g_SuiteItemsList.Count);
  for i := 0 to g_SuiteItemsList.Count - 1 do
  begin
    SuiteItems := pTSuiteItems(g_SuiteItemsList.Items[i]);

    ini.WriteInteger(IntToStr(i), 'ItemColor', SuiteItems.ItemColor);
    ini.WriteInteger(IntToStr(i), 'AbilColor', SuiteItems.AbilColor);

    ini.WriteBool(IntToStr(i), 'ClientShow', SuiteItems.SendToClient);
    ini.WriteString(IntToStr(i), 'Hint', SuiteItems.sDesc);

    sLineText := '';
    for ii := Low(TSuiteNames) to High(TSuiteNames) do
    begin
      sStr := SuiteItems.asSuiteName[ii];
      if sStr = '' then
        sStr := 'NULL';
      sLineText := sLineText + sStr + ',';
    end;
    ini.WriteString(IntToStr(i), 'UseItems', sLineText);

    sLineText := '';
    for ii := Low(TSuitSubRate) to High(TSuitSubRate) do
      sLineText := sLineText + IntToStr(SuiteItems.aSuitSubRate[ii]) + ',';
    ini.WriteString(IntToStr(i), 'Attribute', sLineText);

  end;
  ini.Free;

  btnSuiteItemSave.Enabled := False;
  btnReloadSuiteItem.Enabled := True;
end;

procedure TfrmViewList.btnReloadSuiteItemClick(Sender: TObject);
begin
  LoadSuiteItemsList();
  FrmDB.LoadItemsDB();
  RefSuitItemList();
  btnReloadSuiteItem.Enabled := False;
  Application.MessageBox('重新加载套装物品列表完成！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmViewList.ListViewSuiteClick(Sender: TObject);

  procedure SetValue(nIdx, nVal: Integer);
  begin
    case nIdx of
      0: EditSuiteMaxHP.Value := nVal;
      1: EditSuiteMaxMP.Value := nVal;
      2: EditSubACRate.Value := nVal;
      3: EditSubMACRate.Value := nVal;
      4: EditSubDCRate.Value := nVal;
      5: EditSubMCRate.Value := nVal;
      6: EditSubSCRate.Value := nVal;
      7: EditSuiteHitPoint.Value := nVal;
      8: EditSuiteSPDPoint.Value := nVal;
      9: EditSuiteAntiMagic.Value := nVal;
      10: EditSuileAntiPoison.Value := nVal;
      11: EditSuitePoisonRecover.Value := nVal;
      12: EditSuiteHPRecover.Value := nVal;
      13: EditSuiteMPRecover.Value := nVal;
      14: CheckBoxParalysis.Checked := (nVal <> 0);
      15: CheckBoxMagicShield.Checked := (nVal <> 0);
      16: CheckBoxTeleport.Checked := (nVal <> 0);
      17: CheckBoxRevival.Checked := (nVal <> 0);
      18: CheckBoxMuscleRing.Checked := (nVal <> 0);
      19: CheckBoxFastTrain.Checked := (nVal <> 0);
      20: CheckBoxProbeNecklace.Checked := (nVal <> 0);
      21: CheckBoxHongMoSuite.Checked := (nVal <> 0);
      22: CheckBoxHideMode.Checked := (nVal <> 0);
      23: CheckBoxUnParalysis.Checked := (nVal <> 0);
      24: CheckBoxUnAllParalysis.Checked := (nVal <> 0);
      25: CheckBoxUnRevival.Checked := (nVal <> 0);
      26: CheckBoxUnMagicShield.Checked := (nVal <> 0);
      27: CheckBoxRecallSuite.Checked := (nVal <> 0);
      28: CheckBoxNoDropItem.Checked := (nVal <> 0);
      29: CheckBoxNoDropUseItem.Checked := (nVal <> 0);
      30: SpinEdit1.Value := nVal;
      31: SpinEdit2.Value := nVal;
      32: SpinEdit3.Value := nVal;
      33: SpinEdit4.Value := nVal;
      34: SpinEdit5.Value := nVal;
      35: SpinEdit6.Value := nVal;
      36: SpinEdit7.Value := nVal;
      37: SpinEdit8.Value := nVal;
      38: SpinEdit9.Value := nVal;
      39: SpinEdit10.Value := nVal;
    end;
  end;
var
  ListItem: TListItem;
  nC, nIndex: Integer;
begin
  nIndex := ListViewSuite.ItemIndex;
  if (nIndex < 0) or (nIndex >= g_SuiteItemsList.Count) then
    Exit;
  ListItem := ListViewSuite.Items.item[nIndex];
  g_SuiteItems := pTSuiteItems(ListItem.SubItems.Objects[2]);
  EditSuiteEffectMsg.Text := ListItem.SubItems.Strings[0];
  for nC := Low(TSuitSubRate) to High(TSuitSubRate) do
    SetValue(nC, g_SuiteItems.aSuitSubRate[nC]);
  Edit1.Text := g_SuiteItems.asSuiteName[0];
  Edit2.Text := g_SuiteItems.asSuiteName[1];
  Edit3.Text := g_SuiteItems.asSuiteName[2];
  Edit4.Text := g_SuiteItems.asSuiteName[3];
  Edit5.Text := g_SuiteItems.asSuiteName[4];
  Edit6.Text := g_SuiteItems.asSuiteName[5];
  Edit7.Text := g_SuiteItems.asSuiteName[6];
  Edit8.Text := g_SuiteItems.asSuiteName[7];
  Edit9.Text := g_SuiteItems.asSuiteName[8];
  Edit10.Text := g_SuiteItems.asSuiteName[9];
  Edit11.Text := g_SuiteItems.asSuiteName[10];
  Edit12.Text := g_SuiteItems.asSuiteName[11];
  Edit13.Text := g_SuiteItems.asSuiteName[12];
  CheckBox1.Checked := g_SuiteItems.SendToClient;

  EditReNewNameColor1.Value := g_SuiteItems.ItemColor;
  EditReNewNameColor2.Value := g_SuiteItems.AbilColor;

  btnSuiteItemDel.Enabled := True;
  btnSuiteMob.Enabled := True;
end;

procedure TfrmViewList.btnSuiteMobClick(Sender: TObject);
var
  nC: Integer;
  sItemName, sItemDesc: string;
begin
  if (g_SuiteItems = nil) {or (g_ListItemSuite = nil)} then
    Exit;
  sItemName := Trim(Edit1.Text) + Trim(Edit2.Text) + Trim(Edit3.Text) + Trim(Edit4.Text) + Trim(Edit5.Text) + Trim(Edit6.Text) + Trim(Edit7.Text) + Trim(Edit8.Text) + Trim(Edit9.Text) + Trim(Edit10.Text) + Trim(Edit11.Text) + Trim(Edit12.Text) + Trim(Edit13.Text);
  sItemDesc := Trim(EditSuiteEffectMsg.Text);
  if sItemName = '' then
  begin
    Application.MessageBox('套装物品名称输入不正确！', '提示信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  if sItemDesc = '' then
  begin
    Application.MessageBox('请输入套装物品生效描述！', '提示信息', MB_OK + MB_ICONERROR);
    EditSuiteEffectMsg.SetFocus;
    Exit;
  end;

  g_SuiteItems.sDesc := sItemDesc;
  g_SuiteItems.asSuiteName[0] := Trim(Edit1.Text);
  g_SuiteItems.asSuiteName[1] := Trim(Edit2.Text);
  g_SuiteItems.asSuiteName[2] := Trim(Edit3.Text);
  g_SuiteItems.asSuiteName[3] := Trim(Edit4.Text);
  g_SuiteItems.asSuiteName[4] := Trim(Edit5.Text);
  g_SuiteItems.asSuiteName[5] := Trim(Edit6.Text);
  g_SuiteItems.asSuiteName[6] := Trim(Edit7.Text);
  g_SuiteItems.asSuiteName[7] := Trim(Edit8.Text);
  g_SuiteItems.asSuiteName[8] := Trim(Edit9.Text);
  g_SuiteItems.asSuiteName[9] := Trim(Edit10.Text);
  g_SuiteItems.asSuiteName[10] := Trim(Edit11.Text);
  g_SuiteItems.asSuiteName[11] := Trim(Edit12.Text);
  g_SuiteItems.asSuiteName[12] := Trim(Edit13.Text);

  g_SuiteItems.aSuitSubRate[0] := EditSuiteMaxHP.Value;
  g_SuiteItems.aSuitSubRate[1] := EditSuiteMaxMP.Value;
  g_SuiteItems.aSuitSubRate[2] := EditSubACRate.Value;
  g_SuiteItems.aSuitSubRate[3] := EditSubMACRate.Value;
  g_SuiteItems.aSuitSubRate[4] := EditSubDCRate.Value;
  g_SuiteItems.aSuitSubRate[5] := EditSubMCRate.Value;
  g_SuiteItems.aSuitSubRate[6] := EditSubSCRate.Value;
  g_SuiteItems.aSuitSubRate[7] := EditSuiteHitPoint.Value;
  g_SuiteItems.aSuitSubRate[8] := EditSuiteSPDPoint.Value;
  g_SuiteItems.aSuitSubRate[9] := EditSuiteAntiMagic.Value;
  g_SuiteItems.aSuitSubRate[10] := EditSuileAntiPoison.Value;
  g_SuiteItems.aSuitSubRate[11] := EditSuitePoisonRecover.Value;
  g_SuiteItems.aSuitSubRate[12] := EditSuiteHPRecover.Value;
  g_SuiteItems.aSuitSubRate[13] := EditSuiteMPRecover.Value;
  if CheckBoxParalysis.Checked then
    g_SuiteItems.aSuitSubRate[14] := 1
  else
    g_SuiteItems.aSuitSubRate[14] := 0;
  if CheckBoxMagicShield.Checked then
    g_SuiteItems.aSuitSubRate[15] := 1
  else
    g_SuiteItems.aSuitSubRate[15] := 0;
  if CheckBoxTeleport.Checked then
    g_SuiteItems.aSuitSubRate[16] := 1
  else
    g_SuiteItems.aSuitSubRate[16] := 0;
  if CheckBoxRevival.Checked then
    g_SuiteItems.aSuitSubRate[17] := 1
  else
    g_SuiteItems.aSuitSubRate[17] := 0;
  if CheckBoxMuscleRing.Checked then
    g_SuiteItems.aSuitSubRate[18] := 1
  else
    g_SuiteItems.aSuitSubRate[18] := 0;
  if CheckBoxFastTrain.Checked then
    g_SuiteItems.aSuitSubRate[19] := 1
  else
    g_SuiteItems.aSuitSubRate[19] := 0;
  if CheckBoxProbeNecklace.Checked then
    g_SuiteItems.aSuitSubRate[20] := 1
  else
    g_SuiteItems.aSuitSubRate[20] := 0;
  if CheckBoxHongMoSuite.Checked then
    g_SuiteItems.aSuitSubRate[21] := 1
  else
    g_SuiteItems.aSuitSubRate[21] := 0;
  if CheckBoxHideMode.Checked then
    g_SuiteItems.aSuitSubRate[22] := 1
  else
    g_SuiteItems.aSuitSubRate[22] := 0;
  if CheckBoxUnParalysis.Checked then
    g_SuiteItems.aSuitSubRate[23] := 1
  else
    g_SuiteItems.aSuitSubRate[23] := 0;
  if CheckBoxUnAllParalysis.Checked then
    g_SuiteItems.aSuitSubRate[24] := 1
  else
    g_SuiteItems.aSuitSubRate[24] := 0;
  if CheckBoxUnRevival.Checked then
    g_SuiteItems.aSuitSubRate[25] := 1
  else
    g_SuiteItems.aSuitSubRate[25] := 0;
  if CheckBoxUnMagicShield.Checked then
    g_SuiteItems.aSuitSubRate[26] := 1
  else
    g_SuiteItems.aSuitSubRate[26] := 0;
  if CheckBoxRecallSuite.Checked then
    g_SuiteItems.aSuitSubRate[27] := 1
  else
    g_SuiteItems.aSuitSubRate[27] := 0;
  if CheckBoxNoDropItem.Checked then
    g_SuiteItems.aSuitSubRate[28] := 1
  else
    g_SuiteItems.aSuitSubRate[28] := 0;
  if CheckBoxNoDropUseItem.Checked then
    g_SuiteItems.aSuitSubRate[29] := 1
  else
    g_SuiteItems.aSuitSubRate[29] := 0;
  g_SuiteItems.aSuitSubRate[30] := SpinEdit1.Value;
  g_SuiteItems.aSuitSubRate[31] := SpinEdit2.Value;
  g_SuiteItems.aSuitSubRate[32] := SpinEdit3.Value;
  g_SuiteItems.aSuitSubRate[33] := SpinEdit4.Value;
  g_SuiteItems.aSuitSubRate[34] := SpinEdit5.Value;
  g_SuiteItems.aSuitSubRate[35] := SpinEdit6.Value;
  g_SuiteItems.aSuitSubRate[36] := SpinEdit7.Value;
  g_SuiteItems.aSuitSubRate[37] := SpinEdit8.Value;
  g_SuiteItems.aSuitSubRate[38] := SpinEdit9.Value;
  g_SuiteItems.aSuitSubRate[39] := SpinEdit10.Value;
  g_SuiteItems.SendToClient := CheckBox1.Checked;
  g_SuiteItems.ItemColor := EditReNewNameColor1.Value;
  g_SuiteItems.AbilColor := EditReNewNameColor2.Value;

  for nC := Low(TSuiteNames) to High(TSuiteNames) do
    if g_SuiteItems.asSuiteName[nC] <> '' then
      Inc(g_SuiteItems.nNeedCount);

  RefSuitItemList();
  btnSuiteMob.Enabled := False;
  btnSuiteItemSave.Enabled := True;
end;

procedure TfrmViewList.ListViewSuiteChange(Sender: TObject;
  item: TListItem; Change: TItemChange);
begin
  ListViewSuiteClick(Sender);
end;

procedure TfrmViewList.ComboBoxSaleItemBindChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nShopItemBind := ComboBoxSaleItemBind.ItemIndex;
  Config.WriteInteger('Setup', 'ShopItemBind', g_Config.nShopItemBind);
end;

end.
