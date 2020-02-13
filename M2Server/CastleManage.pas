unit CastleManage;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, ComCtrls, StdCtrls, Spin;

type
  TfrmCastleManage = class(TForm)
    GroupBox1: TGroupBox;
    ListViewCastle: TListView;
    GroupBox2: TGroupBox;
    PageControlCastle: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    EditOwenGuildName: TEdit;
    GroupBox4: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditCastleName: TEdit;
    EditCastleGuild: TEdit;
    EditCastleHome: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    EditTotalGold: TSpinEdit;
    EditTodayIncome: TSpinEdit;
    Label7: TLabel;
    EditTechLevel: TSpinEdit;
    Label8: TLabel;
    EditPower: TSpinEdit;
    TabSheet3: TTabSheet;
    GroupBox5: TGroupBox;
    ListViewGuard: TListView;
    ButtonRefresh: TButton;
    Label9: TLabel;
    EditCastleHomeX: TEdit;
    Label10: TLabel;
    EditCastleHuang: TEdit;
    Label11: TLabel;
    EditCastleMiDao: TEdit;
    TabSheet4: TTabSheet;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    EditCastleHomeY: TEdit;
    ListViewWar: TListView;
    ButtonCastleSave: TButton;
    ButtonAdd: TButton;
    ButtonMod: TButton;
    ButtonDel: TButton;
    btnStartWarNow: TButton;
    btnStopWarNow: TButton;
    EditStatus: TEdit;
    Label12: TLabel;
    procedure ListViewCastleClick(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure EditCastleNameChange(Sender: TObject);
    procedure ButtonCastleSaveClick(Sender: TObject);
    procedure ButtonModClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListViewWarClick(Sender: TObject);
    procedure btnStartWarNowClick(Sender: TObject);
    procedure btnStopWarNowClick(Sender: TObject);
  private
    procedure RefCastleList;
    procedure RefCastleInfo;
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmCastleManage: TfrmCastleManage;

implementation

uses Castle, M2Share, CastleAttackEdit, Guild, svMain;

{$R *.dfm}
var
  CurCastle: TUserCastle;
  boRefing: Boolean;
  { TfrmCastleManage }

procedure TfrmCastleManage.Open;
begin
  RefCastleList();
  ShowModal;
end;

procedure TfrmCastleManage.RefCastleInfo;
var
  i, ii: Integer;
  ListItem: TListItem;
  ObjUnit: pTObjUnit;
  AttackerInfo: pTAttackerInfo;
begin
  if CurCastle = nil then
    Exit;
  boRefing := True;

  if CurCastle.m_boUnderWar then
  begin
    EditStatus.Text := '攻城中...';
    btnStartWarNow.Enabled := False;
    btnStopWarNow.Enabled := True;
  end
  else
  begin
    EditStatus.Text := '停战中...';
    btnStartWarNow.Enabled := True;
    btnStopWarNow.Enabled := False;
  end;

  if CurCastle.m_MasterGuild = nil then
    EditOwenGuildName.Text := ''
  else
    EditOwenGuildName.Text := CurCastle.m_MasterGuild.sGuildName;
  EditTotalGold.Value := CurCastle.m_nTotalGold;
  EditTodayIncome.Value := CurCastle.m_nTodayIncome;
  EditTechLevel.Value := CurCastle.m_nTechLevel;
  EditPower.Value := CurCastle.m_nPower;
  EditCastleName.Text := CurCastle.m_sName;
  EditCastleHome.Text := CurCastle.m_sHomeMap;
  EditCastleGuild.Text := CurCastle.m_sOwnGuild;
  EditCastleHuang.Text := CurCastle.m_sPalaceMap;
  EditCastleMiDao.Text := CurCastle.m_sSecretMap;
  UpDown1.Position := CurCastle.m_nPalaceDoorX;
  UpDown2.Position := CurCastle.m_nPalaceDoorY;
  ListViewWar.Clear;
  if CurCastle.m_AttackWarList.Count > 0 then
  begin
    for i := 0 to CurCastle.m_AttackWarList.Count - 1 do
    begin
      AttackerInfo := pTAttackerInfo(CurCastle.m_AttackWarList.Values[CurCastle.m_AttackWarList.keys[i]]);
      ListItem := ListViewWar.Items.Add;
      ListItem.Caption := IntToStr(i);
      ListItem.SubItems.Add(AttackerInfo.sGuildName);
      ListItem.SubItems.Add(DateToStr(AttackerInfo.AttackDate));
    end;
  end;

  ListViewGuard.Clear;
  ListItem := ListViewGuard.Items.Add;
  ListItem.Caption := '0';
  if CurCastle.m_MainDoor.BaseObject <> nil then
  begin
    ListItem.SubItems.Add(CurCastle.m_MainDoor.BaseObject.m_sCharName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_MainDoor.BaseObject.m_nCurrX, CurCastle.m_MainDoor.BaseObject.m_nCurrY]));
    ListItem.SubItems.Add(Format('%d/%d', [CurCastle.m_MainDoor.BaseObject.m_WAbil.HP, CurCastle.m_MainDoor.BaseObject.m_WAbil.MaxHP]));
    if CurCastle.m_MainDoor.BaseObject.m_boDeath then
      ListItem.SubItems.Add('损坏')
    else if (CurCastle.m_DoorStatus <> nil) and CurCastle.m_DoorStatus.boOpened then
      ListItem.SubItems.Add('开启')
    else
      ListItem.SubItems.Add('关闭');
  end
  else
  begin
    ListItem.SubItems.Add(CurCastle.m_MainDoor.sName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_MainDoor.nX, CurCastle.m_MainDoor.nY]));
    ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
  end;

  ListItem := ListViewGuard.Items.Add;
  ListItem.Caption := '1';
  if CurCastle.m_LeftWall.BaseObject <> nil then
  begin
    ListItem.SubItems.Add(CurCastle.m_LeftWall.BaseObject.m_sCharName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_LeftWall.BaseObject.m_nCurrX, CurCastle.m_LeftWall.BaseObject.m_nCurrY]));
    ListItem.SubItems.Add(Format('%d/%d', [CurCastle.m_LeftWall.BaseObject.m_WAbil.HP, CurCastle.m_LeftWall.BaseObject.m_WAbil.MaxHP]));
  end
  else
  begin
    ListItem.SubItems.Add(CurCastle.m_LeftWall.sName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_LeftWall.nX, CurCastle.m_LeftWall.nY]));
    ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
  end;

  ListItem := ListViewGuard.Items.Add;
  ListItem.Caption := '2';
  if CurCastle.m_CenterWall.BaseObject <> nil then
  begin
    ListItem.SubItems.Add(CurCastle.m_CenterWall.BaseObject.m_sCharName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_CenterWall.BaseObject.m_nCurrX, CurCastle.m_CenterWall.BaseObject.m_nCurrY]));
    ListItem.SubItems.Add(Format('%d/%d', [CurCastle.m_CenterWall.BaseObject.m_WAbil.HP, CurCastle.m_CenterWall.BaseObject.m_WAbil.MaxHP]));
  end
  else
  begin
    ListItem.SubItems.Add(CurCastle.m_CenterWall.sName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_CenterWall.nX, CurCastle.m_CenterWall.nY]));
    ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
  end;

  ListItem := ListViewGuard.Items.Add;
  ListItem.Caption := '3';
  if CurCastle.m_RightWall.BaseObject <> nil then
  begin
    ListItem.SubItems.Add(CurCastle.m_RightWall.BaseObject.m_sCharName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_RightWall.BaseObject.m_nCurrX, CurCastle.m_RightWall.BaseObject.m_nCurrY]));
    ListItem.SubItems.Add(Format('%d/%d', [CurCastle.m_RightWall.BaseObject.m_WAbil.HP, CurCastle.m_RightWall.BaseObject.m_WAbil.MaxHP]));
  end
  else
  begin
    ListItem.SubItems.Add(CurCastle.m_RightWall.sName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_RightWall.nX, CurCastle.m_RightWall.nY]));
    ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
  end;
  for i := Low(CurCastle.m_Archer) to High(CurCastle.m_Archer) do
  begin
    ObjUnit := @CurCastle.m_Archer[i];
    ListItem := ListViewGuard.Items.Add;
    ListItem.Caption := IntToStr(i + 4);
    if ObjUnit.BaseObject <> nil then
    begin
      ListItem.SubItems.Add(ObjUnit.BaseObject.m_sCharName);
      ListItem.SubItems.Add(Format('%d:%d', [ObjUnit.BaseObject.m_nCurrX, ObjUnit.BaseObject.m_nCurrY]));
      ListItem.SubItems.Add(Format('%d/%d', [ObjUnit.BaseObject.m_WAbil.HP, ObjUnit.BaseObject.m_WAbil.MaxHP]));
    end
    else
    begin
      ListItem.SubItems.Add(ObjUnit.sName);
      ListItem.SubItems.Add(Format('%d:%d', [ObjUnit.nX, ObjUnit.nY]));
      ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
    end;
  end;
  for ii := Low(CurCastle.m_Guard) to High(CurCastle.m_Guard) do
  begin
    ObjUnit := @CurCastle.m_Guard[ii];
    ListItem := ListViewGuard.Items.Add;
    ListItem.Caption := IntToStr(ii + 4); //Correct By Blue
    if ObjUnit.BaseObject <> nil then
    begin
      ListItem.SubItems.Add(ObjUnit.BaseObject.m_sCharName);
      ListItem.SubItems.Add(Format('%d:%d', [ObjUnit.BaseObject.m_nCurrX, ObjUnit.BaseObject.m_nCurrY]));
      ListItem.SubItems.Add(Format('%d/%d', [ObjUnit.BaseObject.m_WAbil.HP, ObjUnit.BaseObject.m_WAbil.MaxHP]));
    end
    else
    begin
      ListItem.SubItems.Add(ObjUnit.sName);
      ListItem.SubItems.Add(Format('%d:%d', [ObjUnit.nX, ObjUnit.nY]));
      ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
    end;
  end;
  boRefing := False;
  ButtonCastleSave.Enabled := False;
end;

procedure TfrmCastleManage.RefCastleList;
var
  i: Integer;
  UserCastle: TUserCastle;
  ListItem: TListItem;
begin
  g_CastleManager.Lock;
  try
    for i := 0 to g_CastleManager.m_CastleList.Count - 1 do
    begin
      UserCastle := TUserCastle(g_CastleManager.m_CastleList.Items[i]);
      ListItem := ListViewCastle.Items.Add;
      ListItem.Caption := IntToStr(i);
      ListItem.SubItems.AddObject(UserCastle.m_sConfigDir, UserCastle);
      ListItem.SubItems.Add(UserCastle.m_sName)
    end;
  finally
    g_CastleManager.UnLock;
  end;
end;

procedure TfrmCastleManage.ListViewCastleClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  ListItem := ListViewCastle.Selected;
  if ListItem = nil then
    Exit;
  CurCastle := TUserCastle(ListItem.SubItems.Objects[0]);
  ButtonAdd.Enabled := CurCastle <> nil;
  RefCastleInfo();
end;

procedure TfrmCastleManage.ButtonRefreshClick(Sender: TObject);
begin
  RefCastleInfo();
end;

procedure TfrmCastleManage.EditCastleNameChange(Sender: TObject);
begin
  if CurCastle <> nil then
    ButtonCastleSave.Enabled := True;
end;

procedure TfrmCastleManage.ButtonCastleSaveClick(Sender: TObject);
var
  sName, sHomeMap, sOwnGuild, sPalaceMap, sSecretMap: string;
  nPalaceDoorX, nPalaceDoorY: Integer;
begin
  if CurCastle = nil then
    Exit;
  sName := Trim(EditCastleName.Text);
  sHomeMap := Trim(EditCastleHome.Text);
  sOwnGuild := Trim(EditCastleGuild.Text);
  sPalaceMap := Trim(EditCastleHuang.Text);
  sSecretMap := Trim(EditCastleMiDao.Text);
  nPalaceDoorX := UpDown1.Position;
  nPalaceDoorY := UpDown2.Position;
  if sName = '' then
  begin
    Application.MessageBox('城堡名称设置错误！', '错误信息', MB_ICONERROR + MB_OK);
    EditCastleName.SetFocus;
    Exit;
  end;
  if sHomeMap = '' then
  begin
    Application.MessageBox('回城地图设置错误！', '错误信息', MB_ICONERROR + MB_OK);
    EditCastleHome.SetFocus;
    Exit;
  end;
  if sPalaceMap = '' then
  begin
    Application.MessageBox('皇宫地图设置错误！', '错误信息', MB_ICONERROR + MB_OK);
    EditCastleHuang.SetFocus;
    Exit;
  end;
  if sSecretMap = '' then
  begin
    Application.MessageBox('密道地图设置错误！', '错误信息', MB_ICONERROR + MB_OK);
    EditCastleMiDao.SetFocus;
    Exit;
  end;
  if nPalaceDoorX <= 0 then
  begin
    Application.MessageBox('回城坐标X设置错误！', '错误信息', MB_ICONERROR + MB_OK);
    Exit;
  end;
  if nPalaceDoorY <= 0 then
  begin
    Application.MessageBox('回城坐标Y设置错误！', '错误信息', MB_ICONERROR + MB_OK);
    Exit;
  end;
  CurCastle.m_sName := sName;
  CurCastle.m_sHomeMap := sHomeMap;
  CurCastle.m_sOwnGuild := sOwnGuild;
  CurCastle.m_sPalaceMap := sPalaceMap;
  CurCastle.m_sSecretMap := sSecretMap;
  CurCastle.m_nPalaceDoorX := nPalaceDoorX;
  CurCastle.m_nPalaceDoorY := nPalaceDoorY;
  ButtonCastleSave.Enabled := False;
end;

procedure TfrmCastleManage.ButtonModClick(Sender: TObject);
begin
  if ListViewWar.ItemIndex >= 0 then
  begin
    FormCastleAttackEdit := TFormCastleAttackEdit.Create(Owner);
    FormCastleAttackEdit.Top := Top + 20;
    FormCastleAttackEdit.Left := Left;
    FormCastleAttackEdit.Open(pTAttackerInfo(CurCastle.m_AttackWarList.Values[CurCastle.m_AttackWarList.keys[ListViewWar.ItemIndex]]), True);
    FormCastleAttackEdit.Free;
    RefCastleInfo;
    ButtonMod.Enabled := False;
    ButtonDel.Enabled := False;
  end;
end;

procedure TfrmCastleManage.btnStartWarNowClick(Sender: TObject);
var
  b: Boolean;
  i: Integer;
  Year, Month, Day: Word;
  wYear, wMonth, wDay: Word;
  AttackerInfo: pTAttackerInfo;
begin
  b := False;
  if (CurCastle = nil) or CurCastle.m_boUnderWar or (CurCastle.m_btForceStartWar <> 0) then
    Exit;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    g_CastleManager.Lock;
    try
      for i := CurCastle.m_AttackWarList.Count - 1 downto 0 do
      begin
        AttackerInfo := pTAttackerInfo(CurCastle.m_AttackWarList.GetValues(CurCastle.m_AttackWarList.keys[i]));
        DecodeDate(Now, Year, Month, Day);
        DecodeDate(AttackerInfo.AttackDate, wYear, wMonth, wDay);
        if (Year = wYear) and (Month = wMonth) and (Day = wDay) then
        begin
          b := True;
          Break;
        end;
      end;
      if b then
      begin
        CurCastle.m_btForceStartWar := 1;
        btnStartWarNow.Enabled := False;
        l_dwRunTimeTick := 0;
      end;
    finally
      g_CastleManager.UnLock;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
  if not b then
    Application.MessageBox(PChar('当天没有参加攻城的行会，不能开始攻城！' + #13 +
      '请使用[攻城申请]进行申请编辑！'), '错误', MB_ICONERROR + MB_OK);
end;

procedure TfrmCastleManage.btnStopWarNowClick(Sender: TObject);
begin
  if (CurCastle = nil) or not CurCastle.m_boUnderWar or (CurCastle.m_btForceStartWar <> 0) then
    Exit;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    g_CastleManager.Lock;
    try
      CurCastle.m_btForceStartWar := 2;
      btnStopWarNow.Enabled := False;
      l_dwRunTimeTick := 0;
    finally
      g_CastleManager.UnLock;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TfrmCastleManage.ButtonAddClick(Sender: TObject);

  function IsInAttackList(AddingInfo: pTAttackerInfo): Boolean;
  var
    i: Integer;
    AttackerInfo: pTAttackerInfo;
    wYear, wMonth, wDay: Word;
    sYear, sMonth, sDay: Word;
  begin
    Result := False;
    for i := 0 to CurCastle.m_AttackWarList.Count - 1 do
    begin
      AttackerInfo := pTAttackerInfo(CurCastle.m_AttackWarList.Values[CurCastle.m_AttackWarList.keys[i]]);
      if (CompareText(AddingInfo^.sGuildName, AttackerInfo^.sGuildName) = 0) or (AddingInfo^.Guild = AttackerInfo^.Guild) then
      begin
        DecodeDate(AddingInfo^.AttackDate, wYear, wMonth, wDay);
        DecodeDate(AttackerInfo^.AttackDate, sYear, sMonth, sDay);
        if (wYear = sYear) and (wMonth = wMonth) and (wDay = sDay) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;

var
  s: string;
  i: Integer;
  INFO: pTAttackerInfo;
  AttackerInfo: pTAttackerInfo;
  Guild: TGuild;
  boAddAll: Boolean;
begin
  New(INFO);
  FormCastleAttackEdit := TFormCastleAttackEdit.Create(Owner);
  FormCastleAttackEdit.Top := Top + 20;
  FormCastleAttackEdit.Left := Left;
  for i := 0 to g_GuildManager.GuildList.Count - 1 do
  begin
    s := g_GuildManager.GuildList.keys[i];
    //Guild := TGuild(g_GuildManager.GuildList.Items[i]);
    FormCastleAttackEdit.ListBoxGuildList.Items.Add(s);
  end;
  boAddAll := FormCastleAttackEdit.Open(INFO, False);
  FormCastleAttackEdit.Free;
  if boAddAll then
  begin
    for i := CurCastle.m_AttackWarList.Count - 1 downto 0 do
    begin
      AttackerInfo := pTAttackerInfo(CurCastle.m_AttackWarList.Values[CurCastle.m_AttackWarList.keys[i]]);
      Dispose(AttackerInfo);
    end;
    CurCastle.m_AttackWarList.Clear;

    for i := 0 to g_GuildManager.GuildList.Count - 1 do
    begin
      //Guild := TGuild(g_GuildManager.GuildList.Items[i]);
      Guild := TGuild(g_GuildManager.GuildList.Values[g_GuildManager.GuildList.keys[i]]);
      if not CurCastle.m_AttackWarList.Exists(Guild.sGuildName) then
      begin
        New(AttackerInfo);
        AttackerInfo^.sGuildName := Guild.sGuildName;
        AttackerInfo^.Guild := Guild;
        AttackerInfo^.AttackDate := INFO.AttackDate;
        //CurCastle.m_AttackWarList.Add(AttackerInfo);
        CurCastle.m_AttackWarList.Put(Guild.sGuildName, TObject(AttackerInfo));
      end;
    end;
    Dispose(INFO);
    RefCastleInfo;
  end
  else if INFO.Guild <> nil then
  begin
    if CurCastle <> nil then
    begin
      if IsInAttackList(INFO) then
      begin
        Application.MessageBox('输入的行会名称已经在攻城列表中。', '警告', MB_ICONWARNING + MB_OK);
        Dispose(INFO);
        Exit;
      end;
      //CurCastle.m_AttackWarList.Add(INFO);
      if not CurCastle.m_AttackWarList.Exists(INFO.sGuildName) then
        CurCastle.m_AttackWarList.Put(INFO.sGuildName, TObject(INFO))
      else
        Dispose(INFO);
      RefCastleInfo;
    end;
  end
  else
    //Application.MessageBox('输入的行会不存在！', '错误', MB_ICONERROR + MB_OK);
end;

procedure TfrmCastleManage.ButtonDelClick(Sender: TObject);
var
  INFO: pTAttackerInfo;
begin
  if ListViewWar.ItemIndex >= 0 then
  begin
    if Application.MessageBox('是否确认删除选择的攻城信息？', '提示信息', MB_ICONINFORMATION + MB_YESNO) = ID_NO then
      Exit;
    //INFO := pTAttackerInfo(CurCastle.m_AttackWarList.Items[ListViewWar.ItemIndex]);
    INFO := pTAttackerInfo(CurCastle.m_AttackWarList.Values[CurCastle.m_AttackWarList.keys[ListViewWar.ItemIndex]]);
    Dispose(INFO);
    CurCastle.m_AttackWarList.Delete(CurCastle.m_AttackWarList.keys[ListViewWar.ItemIndex]);
    RefCastleInfo;
    ButtonDel.Enabled := False;
    ButtonMod.Enabled := False;
  end;
end;

procedure TfrmCastleManage.FormCreate(Sender: TObject);
begin
  PageControlCastle.ActivePageIndex := 0;
end;

procedure TfrmCastleManage.ListViewWarClick(Sender: TObject);
begin
  if ListViewWar.ItemIndex >= 0 then
  begin
    ButtonMod.Enabled := True;
    ButtonDel.Enabled := True;
  end;
end;

end.
