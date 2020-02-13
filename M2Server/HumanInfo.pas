unit HumanInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ObjBase, StdCtrls, Spin, ComCtrls, ExtCtrls, Grids;

type
  TfrmHumanInfo = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditName: TEdit;
    EditMap: TEdit;
    EditXY: TEdit;
    EditAccount: TEdit;
    EditIPaddr: TEdit;
    EditLogonTime: TEdit;
    EditLogonLong: TEdit;
    GroupBox2: TGroupBox;
    Label12: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    EditLevel: TSpinEdit;
    EditGold: TSpinEdit;
    EditPKPoint: TSpinEdit;
    EditExp: TSpinEdit;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Timer: TTimer;
    GroupBox4: TGroupBox;
    CheckBoxMonitor: TCheckBox;
    GroupBox6: TGroupBox;
    CheckBoxGameMaster: TCheckBox;
    CheckBoxSuperMan: TCheckBox;
    CheckBoxObserver: TCheckBox;
    ButtonKick: TButton;
    GroupBox7: TGroupBox;
    GridUserItem: TStringGrid;
    GroupBox8: TGroupBox;
    GridBagItem: TStringGrid;
    GroupBox10: TGroupBox;
    GridStorageItem: TStringGrid;
    EditHumanStatus: TEdit;
    ButtonSave: TButton;
    Label21: TLabel;
    Label29: TLabel;
    Label28: TLabel;
    Label27: TLabel;
    Label26: TLabel;
    Label19: TLabel;
    EditGamePoint: TSpinEdit;
    EditGameGold: TSpinEdit;
    EditEditBonusPointUsed: TSpinEdit;
    EditCreditPoint: TSpinEdit;
    EditBonusPoint: TSpinEdit;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    EditAC: TEdit;
    EditMAC: TEdit;
    EditDC: TEdit;
    EditMC: TEdit;
    EditSC: TEdit;
    EditHP: TEdit;
    EditMP: TEdit;
    EditHeroName: TEdit;
    Label20: TLabel;
    EditIPLocal: TEdit;
    Label22: TLabel;
    EditLevelShow: TEdit;
    Label23: TLabel;
    EditMaxExpShow: TEdit;
    Label24: TLabel;
    btnRefresh: TButton;
    procedure TimerTimer(Sender: TObject);
    procedure CheckBoxMonitorClick(Sender: TObject);
    procedure ButtonKickClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    procedure RefHumanInfo();
    { Private declarations }
  public
    PlayObject: TPlayObject;
    //PlayObject: TBaseObject;
    procedure Open();
    { Public declarations }
  end;

var
  frmHumanInfo: TfrmHumanInfo;

implementation

uses UsrEngn, M2Share, Grobal2;

{$R *.dfm}
var
  boRefHuman: Boolean = False;
  { TfrmHumanInfo }

procedure TfrmHumanInfo.FormCreate(Sender: TObject);
begin
  GridUserItem.Cells[0, 0] := '装备位置';
  GridUserItem.Cells[1, 0] := '装备名称';
  GridUserItem.Cells[2, 0] := '系列号';
  GridUserItem.Cells[3, 0] := '持久';
  GridUserItem.Cells[4, 0] := '攻';
  GridUserItem.Cells[5, 0] := '魔';
  GridUserItem.Cells[6, 0] := '道';
  GridUserItem.Cells[7, 0] := '防';
  GridUserItem.Cells[8, 0] := '魔防';
  GridUserItem.Cells[9, 0] := '附加属性';

  GridUserItem.Cells[0, 1] := '衣服';
  GridUserItem.Cells[0, 2] := '武器';
  GridUserItem.Cells[0, 3] := '照明物';
  GridUserItem.Cells[0, 4] := '项链';
  GridUserItem.Cells[0, 5] := '头盔';
  GridUserItem.Cells[0, 6] := '左手镯';
  GridUserItem.Cells[0, 7] := '右手镯';
  GridUserItem.Cells[0, 8] := '左戒指';
  GridUserItem.Cells[0, 9] := '右戒指';
  GridUserItem.Cells[0, 10] := '靴子';
  GridUserItem.Cells[0, 11] := '腰带';
  GridUserItem.Cells[0, 12] := '宝石';
  GridUserItem.Cells[0, 13] := '道符';

  GridBagItem.Cells[0, 0] := '序号';
  GridBagItem.Cells[1, 0] := '装备名称';
  GridBagItem.Cells[2, 0] := '系列号';
  GridBagItem.Cells[3, 0] := '持久';
  GridBagItem.Cells[4, 0] := '攻';
  GridBagItem.Cells[5, 0] := '魔';
  GridBagItem.Cells[6, 0] := '道';
  GridBagItem.Cells[7, 0] := '防';
  GridBagItem.Cells[8, 0] := '魔防';
  GridBagItem.Cells[9, 0] := '附加属性';

  GridStorageItem.Cells[0, 0] := '序号';
  GridStorageItem.Cells[1, 0] := '装备名称';
  GridStorageItem.Cells[2, 0] := '系列号';
  GridStorageItem.Cells[3, 0] := '持久';
  GridStorageItem.Cells[4, 0] := '攻';
  GridStorageItem.Cells[5, 0] := '魔';
  GridStorageItem.Cells[6, 0] := '道';
  GridStorageItem.Cells[7, 0] := '防';
  GridStorageItem.Cells[8, 0] := '魔防';
  GridStorageItem.Cells[9, 0] := '附加属性';

end;

procedure TfrmHumanInfo.Open;
begin
  RefHumanInfo();
  ButtonKick.Enabled := True;
  Timer.Enabled := True;
  ShowModal;
  CheckBoxMonitor.Checked := False;
  Timer.Enabled := False;
end;

procedure TfrmHumanInfo.RefHumanInfo;
var
  i: Integer;
  nTotleUsePoint: Integer;
  StdItem: pTStdItem;
  item: TStdItem;
  UserItem: pTUserItem;
begin
  if (PlayObject = nil) then
    Exit;

  if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
  begin
    TabSheet1.Caption := '人物信息';
    GroupBox6.Visible := True;
    EditLogonTime.Text := DateTimeToStr(PlayObject.m_dLogonTime);
    EditLogonLong.Text := IntToStr((GetTickCount - PlayObject.m_dwLogonTick) div (60 * 1000)) + ' 分钟';
    Label20.Caption := '英雄名字';
    EditHeroName.Text := PlayObject.m_sHeroName;
    CheckBoxGameMaster.Enabled := True;
    CheckBoxSuperMan.Enabled := True;
    CheckBoxObserver.Enabled := True;
    CheckBoxGameMaster.Checked := PlayObject.m_boAdminMode;
    CheckBoxSuperMan.Checked := PlayObject.m_boSuperMan;
    CheckBoxObserver.Checked := PlayObject.m_boObMode;

    EditIPaddr.Text := PlayObject.m_sIPaddr;
{$IF EXPIPLOCAL=1}
    EditIPLocal.Text := GetIPLocal(PlayObject.m_sIPaddr);
{$ELSE}
    EditIPLocal.Text := PlayObject.m_sIPLocal;
{$IFEND}
  end
  else
  begin
    TabSheet1.Caption := '英雄信息';
    GroupBox6.Visible := False;
    CheckBoxGameMaster.Enabled := False;
    CheckBoxSuperMan.Enabled := False;
    CheckBoxObserver.Enabled := False;
    Label20.Caption := '英雄主人';
    EditHeroName.Text := PlayObject.m_sHeroMasterName;
    EditIPaddr.Text := TPlayObject(PlayObject.m_Master).m_sIPaddr;
{$IF EXPIPLOCAL=1}
    EditIPLocal.Text := GetIPLocal(TPlayObject(PlayObject.m_Master).m_sIPaddr);
{$ELSE}
    EditIPLocal.Text := TPlayObject(PlayObject.m_Master).m_sIPLocal;
{$IFEND}
  end;
  EditName.Text := PlayObject.m_sCharName;
  EditMap.Text := PlayObject.m_sMapName + '(' + PlayObject.m_PEnvir.m_sMapDesc + ')';
  EditXY.Text := IntToStr(PlayObject.m_nCurrX) + ':' + IntToStr(PlayObject.m_nCurrY);
  EditAccount.Text := PlayObject.m_sUserID;
  EditLevel.Value := PlayObject.m_Abil.Level;
  EditGold.Value := PlayObject.m_nGold;
  EditPKPoint.Value := PlayObject.m_nPkPoint;
  EditExp.Value := PlayObject.m_Abil.Exp;
  EditAC.Text := IntToStr(LoWord(PlayObject.m_WAbil.AC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.AC));
  EditMAC.Text := IntToStr(LoWord(PlayObject.m_WAbil.MAC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.MAC));
  EditDC.Text := IntToStr(LoWord(PlayObject.m_WAbil.DC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.DC));
  EditMC.Text := IntToStr(LoWord(PlayObject.m_WAbil.MC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.MC));
  EditSC.Text := IntToStr(LoWord(PlayObject.m_WAbil.SC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.SC));
  EditHP.Text := IntToStr(PlayObject.m_WAbil.HP) + '/' + IntToStr(PlayObject.m_WAbil.MaxHP);
  EditMP.Text := IntToStr(PlayObject.m_WAbil.MP) + '/' + IntToStr(PlayObject.m_WAbil.MaxMP);
  EditLevelShow.Text := IntToStr(PlayObject.m_WAbil.Level);
  EditMaxExpShow.Text := IntToStr(PlayObject.m_WAbil.MaxExp);

  EditGameGold.Value := PlayObject.m_nGameGold;
  EditGamePoint.Value := PlayObject.m_nGamePoint;
  EditCreditPoint.Value := PlayObject.m_btCreditPoint;
  EditBonusPoint.Value := PlayObject.m_nBonusPoint;

  nTotleUsePoint := PlayObject.m_BonusAbil.DC +
    PlayObject.m_BonusAbil.MC +
    PlayObject.m_BonusAbil.SC +
    PlayObject.m_BonusAbil.AC +
    PlayObject.m_BonusAbil.MAC +
    PlayObject.m_BonusAbil.HP +
    PlayObject.m_BonusAbil.MP +
    PlayObject.m_BonusAbil.HIT +
    PlayObject.m_BonusAbil.Speed +
    PlayObject.m_BonusAbil.X2;
  EditEditBonusPointUsed.Value := nTotleUsePoint;

  if PlayObject.m_boDeath then
    EditHumanStatus.Text := '死亡状态'
  else if PlayObject.m_boGhost then
  begin
    EditHumanStatus.Text := '已经下线';
    PlayObject := nil;
    Exit;
  end
  else
    EditHumanStatus.Text := '当前在线';

  for i := Low(PlayObject.m_UseItems) to High(PlayObject.m_UseItems) do
  begin
    UserItem := @PlayObject.m_UseItems[i];
    if UserItem <> nil then
    begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem = nil then
      begin
        GridUserItem.Cells[1, i + 1] := '';
        GridUserItem.Cells[2, i + 1] := '';
        GridUserItem.Cells[3, i + 1] := '';
        GridUserItem.Cells[4, i + 1] := '';
        GridUserItem.Cells[5, i + 1] := '';
        GridUserItem.Cells[6, i + 1] := '';
        GridUserItem.Cells[7, i + 1] := '';
        GridUserItem.Cells[8, i + 1] := '';
        GridUserItem.Cells[9, i + 1] := '';
        Continue;
      end;
      item := StdItem^;
      ItemUnit.GetItemAddValue(UserItem, item);
      GridUserItem.Cells[1, i + 1] := item.Name;
      GridUserItem.Cells[2, i + 1] := IntToStr(UserItem.MakeIndex);
      GridUserItem.Cells[3, i + 1] := Format('%d/%d', [UserItem.Dura, UserItem.DuraMax]);
      GridUserItem.Cells[4, i + 1] := Format('%d/%d', [LoWord(item.DC), HiWord(item.DC)]);
      GridUserItem.Cells[5, i + 1] := Format('%d/%d', [LoWord(item.MC), HiWord(item.MC)]);
      GridUserItem.Cells[6, i + 1] := Format('%d/%d', [LoWord(item.SC), HiWord(item.SC)]);
      GridUserItem.Cells[7, i + 1] := Format('%d/%d', [LoWord(item.AC), HiWord(item.AC)]);
      GridUserItem.Cells[8, i + 1] := Format('%d/%d', [LoWord(item.MAC), HiWord(item.MAC)]);
      GridUserItem.Cells[9, i + 1] := Format('%d/%d/%d/%d/%d/%d/%d', [UserItem.btValue[0], UserItem.btValue[1], UserItem.btValue[2], UserItem.btValue[3], UserItem.btValue[4], UserItem.btValue[5], UserItem.btValue[6]]);
    end;
  end;



  if PlayObject.m_ItemList.Count <= 0 then
    GridBagItem.RowCount := 2
  else
    GridBagItem.RowCount := PlayObject.m_ItemList.Count + 1;

  if PlayObject.m_ItemList.Count <= 0 then
  begin
    GridBagItem.Cells[1, 1] := '';
    GridBagItem.Cells[2, 1] := '';
    GridBagItem.Cells[3, 1] := '';
    GridBagItem.Cells[4, 1] := '';
    GridBagItem.Cells[5, 1] := '';
    GridBagItem.Cells[6, 1] := '';
    GridBagItem.Cells[7, 1] := '';
    GridBagItem.Cells[8, 1] := '';
    GridBagItem.Cells[9, 1] := '';
  end;
      
  for i := 0 to PlayObject.m_ItemList.Count - 1 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem <> nil then
    begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem = nil then
      begin
        GridBagItem.Cells[1, i + 1] := '';
        GridBagItem.Cells[2, i + 1] := '';
        GridBagItem.Cells[3, i + 1] := '';
        GridBagItem.Cells[4, i + 1] := '';
        GridBagItem.Cells[5, i + 1] := '';
        GridBagItem.Cells[6, i + 1] := '';
        GridBagItem.Cells[7, i + 1] := '';
        GridBagItem.Cells[8, i + 1] := '';
        GridBagItem.Cells[9, i + 1] := '';
        Continue;
      end;
      item := StdItem^;
      ItemUnit.GetItemAddValue(UserItem, item);
      GridBagItem.Cells[0, i + 1] := IntToStr(i);
      GridBagItem.Cells[1, i + 1] := item.Name;
      GridBagItem.Cells[2, i + 1] := IntToStr(UserItem.MakeIndex);
      GridBagItem.Cells[3, i + 1] := Format('%d/%d', [UserItem.Dura, UserItem.DuraMax]);
      GridBagItem.Cells[4, i + 1] := Format('%d/%d', [LoWord(item.DC), HiWord(item.DC)]);
      GridBagItem.Cells[5, i + 1] := Format('%d/%d', [LoWord(item.MC), HiWord(item.MC)]);
      GridBagItem.Cells[6, i + 1] := Format('%d/%d', [LoWord(item.SC), HiWord(item.SC)]);
      GridBagItem.Cells[7, i + 1] := Format('%d/%d', [LoWord(item.AC), HiWord(item.AC)]);
      GridBagItem.Cells[8, i + 1] := Format('%d/%d', [LoWord(item.MAC), HiWord(item.MAC)]);
      GridBagItem.Cells[9, i + 1] := Format('%d/%d/%d/%d/%d/%d/%d', [UserItem.btValue[0], UserItem.btValue[1], UserItem.btValue[2], UserItem.btValue[3], UserItem.btValue[4], UserItem.btValue[5], UserItem.btValue[6]]);
    end;
  end;

  if PlayObject.m_StorageItemList.Count <= 0 then
    GridStorageItem.RowCount := 2
  else
    GridStorageItem.RowCount := PlayObject.m_StorageItemList.Count + 1;

  if PlayObject.m_StorageItemList.Count <= 0 then
  begin
    GridStorageItem.Cells[1, 1] := '';
    GridStorageItem.Cells[2, 1] := '';
    GridStorageItem.Cells[3, 1] := '';
    GridStorageItem.Cells[4, 1] := '';
    GridStorageItem.Cells[5, 1] := '';
    GridStorageItem.Cells[6, 1] := '';
    GridStorageItem.Cells[7, 1] := '';
    GridStorageItem.Cells[8, 1] := '';
    GridStorageItem.Cells[9, 1] := '';
  end;

  for i := 0 to PlayObject.m_StorageItemList.Count - 1 do
  begin
    UserItem := PlayObject.m_StorageItemList.Items[i];
    if UserItem <> nil then
    begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem = nil then
      begin
        GridStorageItem.Cells[1, i + 1] := '';
        GridStorageItem.Cells[2, i + 1] := '';
        GridStorageItem.Cells[3, i + 1] := '';
        GridStorageItem.Cells[4, i + 1] := '';
        GridStorageItem.Cells[5, i + 1] := '';
        GridStorageItem.Cells[6, i + 1] := '';
        GridStorageItem.Cells[7, i + 1] := '';
        GridStorageItem.Cells[8, i + 1] := '';
        GridStorageItem.Cells[9, i + 1] := '';
        Continue;
      end;
      item := StdItem^;
      ItemUnit.GetItemAddValue(UserItem, item);
      GridStorageItem.Cells[0, i + 1] := IntToStr(i);
      GridStorageItem.Cells[1, i + 1] := item.Name;
      GridStorageItem.Cells[2, i + 1] := IntToStr(UserItem.MakeIndex);
      GridStorageItem.Cells[3, i + 1] := Format('%d/%d', [UserItem.Dura, UserItem.DuraMax]);
      GridStorageItem.Cells[4, i + 1] := Format('%d/%d', [LoWord(item.DC), HiWord(item.DC)]);
      GridStorageItem.Cells[5, i + 1] := Format('%d/%d', [LoWord(item.MC), HiWord(item.MC)]);
      GridStorageItem.Cells[6, i + 1] := Format('%d/%d', [LoWord(item.SC), HiWord(item.SC)]);
      GridStorageItem.Cells[7, i + 1] := Format('%d/%d', [LoWord(item.AC), HiWord(item.AC)]);
      GridStorageItem.Cells[8, i + 1] := Format('%d/%d', [LoWord(item.MAC), HiWord(item.MAC)]);
      GridStorageItem.Cells[9, i + 1] := Format('%d/%d/%d/%d/%d/%d/%d', [UserItem.btValue[0], UserItem.btValue[1], UserItem.btValue[2], UserItem.btValue[3], UserItem.btValue[4], UserItem.btValue[5], UserItem.btValue[6]]);
    end;
  end;
end;

procedure TfrmHumanInfo.TimerTimer(Sender: TObject);
begin
  if PlayObject = nil then
    Exit;
  if PlayObject.m_boGhost then
  begin
    EditHumanStatus.Text := '已经下线';
    PlayObject := nil;
    Exit;
  end;
  if boRefHuman then
    RefHumanInfo();
end;

procedure TfrmHumanInfo.CheckBoxMonitorClick(Sender: TObject);
begin
  boRefHuman := CheckBoxMonitor.Checked;
  ButtonSave.Enabled := not boRefHuman;
end;

procedure TfrmHumanInfo.ButtonKickClick(Sender: TObject);
begin
  if PlayObject = nil then
    Exit;
  if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
    PlayObject.m_boEmergencyClose := True
  else if PlayObject.IsHero then
  begin
    TPlayObject(PlayObject.m_Master).m_dwRecallHeroTick := GetTickCount();
    TPlayObject(PlayObject.m_Master).SendDefMessage(SM_HEROSTATEDISPEAR, 0, 0, 0, 0, '');
    PlayObject.SendRefMsg(RM_HEROLOGOUT, 0, PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0, '');
    TPlayObject(PlayObject.m_Master).SysMsg(sHeroDisConnectMsg, c_Green, t_Hint);
    TPlayObject(PlayObject.m_Master).m_HeroObject := nil;
    PlayObject.MakeGhost();
  end;
  ButtonKick.Enabled := False;
end;

procedure TfrmHumanInfo.ButtonSaveClick(Sender: TObject);
var
  nLevel: Integer;
  nGold: Integer;
  nPKPOINT: Integer;
  nGameGold: Integer;
  nGamePoint: Integer;
  nCreditPoint: Integer;
  nBonusPoint: Integer;
  boGameMaster: Boolean;
  boObServer: Boolean;
  boSuperman: Boolean;
begin
  if PlayObject = nil then
    Exit;
  nLevel := EditLevel.Value;
  nGold := EditGold.Value;
  nPKPOINT := EditPKPoint.Value;
  nGameGold := EditGameGold.Value;
  nGamePoint := EditGamePoint.Value;
  nCreditPoint := EditCreditPoint.Value;
  nBonusPoint := EditBonusPoint.Value;
  boGameMaster := CheckBoxGameMaster.Checked;
  boObServer := CheckBoxObserver.Checked;
  boSuperman := CheckBoxSuperMan.Checked;
  if (nLevel < 0) or (nLevel > High(Word)) or (nGold < 0) or (nGold > 200000000)
    or (nPKPOINT < 0) or
    (nPKPOINT > 2000000) or (nCreditPoint < 0) or (nCreditPoint > High(byte)) or
    (nBonusPoint < 0) or (nBonusPoint > 20000000) then
  begin
    MessageBox(Handle, '输入数据不正确', '错误信息', MB_OK);
    Exit;
  end;
  PlayObject.m_Abil.Level := nLevel;
  PlayObject.m_nGold := nGold;
  PlayObject.m_nPkPoint := nPKPOINT;
  PlayObject.m_nGameGold := nGameGold;
  PlayObject.m_nGamePoint := nGamePoint;
  PlayObject.m_btCreditPoint := nCreditPoint;
  PlayObject.m_nBonusPoint := nBonusPoint;
  EditLevelShow.Text := IntToStr(PlayObject.m_WAbil.Level);
  if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
  begin
    PlayObject.m_boAdminMode := boGameMaster;
    PlayObject.m_boObMode := boObServer;
    PlayObject.m_boSuperMan := boSuperman;
    PlayObject.HasLevelUp();
    PlayObject.GoldChanged();
    PlayObject.GameGoldChanged();
    MessageBox(Handle, '人物数据已保存', '提示信息', MB_OK);
  end
  else
  begin
    PlayObject.m_Master.HeroHasLevelUp();
    PlayObject.GoldChanged();
    PlayObject.GameGoldChanged();
    MessageBox(Handle, '英雄数据已保存', '提示信息', MB_OK)
  end;
end;

procedure TfrmHumanInfo.btnRefreshClick(Sender: TObject);
begin
  if PlayObject = nil then
    Exit;
  if PlayObject.m_boGhost then
  begin
    EditHumanStatus.Text := '已经下线';
    PlayObject := nil;
    Exit;
  end;
  RefHumanInfo();
end;

end.
