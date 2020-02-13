unit EditRcd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Grobal2, ComCtrls, StdCtrls, Spin, LocalDB, Dialogs;

type
  TfrmEditRcd = class(TForm)
    PageControl: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EditLevel: TSpinEdit;
    EditGold: TSpinEdit;
    EditGameGold: TSpinEdit;
    EditGamePoint: TSpinEdit;
    Label16: TLabel;
    EditCreditPoint: TSpinEdit;
    Label10: TLabel;
    EditPayPoint: TSpinEdit;
    Label17: TLabel;
    EditPKPoint: TSpinEdit;
    Label18: TLabel;
    EditContribution: TSpinEdit;
    GroupBox3: TGroupBox;
    ListViewMagic: TListView;
    GroupBox4: TGroupBox;
    ListViewUserItem: TListView;
    GroupBox5: TGroupBox;
    ListViewStorage: TListView;
    ButtonSaveData: TButton;
    ButtonExportData: TButton;
    ButtonImportData: TButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    CheckBoxIsMaster: TCheckBox;
    EditMasterName: TEdit;
    EditDearName: TEdit;
    EditPassword: TEdit;
    EditAccount: TEdit;
    EditChrName: TEdit;
    EditIdx: TEdit;
    Label11: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditHomeX: TSpinEdit;
    EditHomeY: TSpinEdit;
    EditHomeMap: TEdit;
    EditCurX: TSpinEdit;
    EditCurY: TSpinEdit;
    EditCurMap: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    EditHeroName: TEdit;
    Label19: TLabel;
    Label20: TLabel;
    EditHeroMasterName: TEdit;
    Label21: TLabel;
    spGender: TSpinEdit;
    spJob: TSpinEdit;
    Label22: TLabel;
    procedure ButtonExportDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditPasswordChange(Sender: TObject);
  private
    m_boOpened: Boolean;
    procedure RefShow();
    procedure RefShowRcd();
    procedure RefShowMagic();
    procedure RefShowUserItem();
    procedure RefShowStorage();
    procedure ProcessSaveRcdToFile();
    procedure ProcessLoadRcdformFile();
    procedure ProcessSaveRcd();
    { Private declarations }
  public
    m_ChrRcd: THumDataInfo;
    m_nIdx: Integer;
    procedure Open();
    { Public declarations }
  end;

var
  frmEditRcd: TfrmEditRcd;

implementation

uses{$IFDEF SQLDB}HumDB_SQL{$ELSE}HumDB{$ENDIF}, DBShare;

{$R *.dfm}

{ TfrmEditRcd }

procedure TfrmEditRcd.FormCreate(Sender: TObject);
begin
  //
end;

procedure TfrmEditRcd.RefShowRcd;
begin
  spGender.Value := m_ChrRcd.Data.btSex;
  spJob.Value := m_ChrRcd.Data.btJob;
  EditHeroName.Text := m_ChrRcd.Data.sHeroName;
  EditHeroMasterName.Text := m_ChrRcd.Data.sHeroMasterName;
  EditChrName.Text := m_ChrRcd.Data.sChrName;
  EditAccount.Text := m_ChrRcd.Data.sAccount;
  EditPassword.Text := m_ChrRcd.Data.sStoragePwd;
  EditDearName.Text := m_ChrRcd.Data.sDearName;
  EditMasterName.Text := m_ChrRcd.Data.sMasterName;
  CheckBoxIsMaster.Checked := m_ChrRcd.Data.boMaster;

  EditCurMap.Text := m_ChrRcd.Data.sCurMap;
  EditCurX.Value := m_ChrRcd.Data.wCurX;
  EditCurY.Value := m_ChrRcd.Data.wCurY;

  EditHomeMap.Text := m_ChrRcd.Data.sHomeMap;
  EditHomeX.Value := m_ChrRcd.Data.wHomeX;
  EditHomeY.Value := m_ChrRcd.Data.wHomeY;

  EditLevel.Value := m_ChrRcd.Data.Abil.Level;
  EditGold.Value := m_ChrRcd.Data.nGold;
  EditGameGold.Value := m_ChrRcd.Data.nGameGold;
  EditGamePoint.Value := m_ChrRcd.Data.nGamePoint;
  EditPayPoint.Value := m_ChrRcd.Data.nPayMentPoint;
  EditCreditPoint.Value := m_ChrRcd.Data.btCreditPoint;
  EditPKPoint.Value := m_ChrRcd.Data.nPKPoint;
end;

procedure TfrmEditRcd.Open;
begin
  RefShow();
  Caption := Format('编辑人物数据 [%s]', [m_ChrRcd.Data.sChrName]);
  PageControl.ActivePageIndex := 0;
  ShowModal;
end;

procedure TfrmEditRcd.RefShow;
begin
  m_boOpened := False;
  RefShowRcd();
  RefShowMagic();
  RefShowUserItem();
  RefShowStorage();
  m_boOpened := True;
end;

procedure TfrmEditRcd.RefShowMagic;
var
  i: Integer;
  ListItem: TListItem;
  Magic: pTMagic;
  MagicInfo: pTHumMagicInfo;
begin
  ListViewMagic.Clear;
  for i := Low(m_ChrRcd.Data.Magic) to High(m_ChrRcd.Data.Magic) do
  begin
    MagicInfo := @m_ChrRcd.Data.Magic[i];
    if MagicInfo.wMagIdx = 0 then
      Break;
    //Magic := LocalDBE.FindMagic(MagicInfo.wMagIdx, MagicInfo.btClass);
    //if Magic <> nil then begin
    ListItem := ListViewMagic.Items.Add;
    ListItem.Caption := IntToStr(i);
    ListItem.SubItems.Add(IntToStr(MagicInfo.wMagIdx));
    Magic := LocalDBE.FindMagic(MagicInfo.wMagIdx, MagicInfo.btClass);
    if Magic <> nil then
      ListItem.SubItems.Add(Magic.sMagicName)
    else
      ListItem.SubItems.Add('Magic.DB 未定义该技能');
    ListItem.SubItems.Add(IntToStr(MagicInfo.btLevel));
    ListItem.SubItems.Add(IntToStr(MagicInfo.nTranPoint));
    ListItem.SubItems.Add(IntToStr(MagicInfo.btKey));
    //end;
  end;
end;

procedure TfrmEditRcd.RefShowUserItem;
var
  i: Integer;
  ListItem: TListItem;
  UserItem: pTUserItem;
resourcestring
  sItemValue = '%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d';
begin
  ListViewUserItem.Clear;

  for i := Low(m_ChrRcd.Data.HumItems) to High(m_ChrRcd.Data.HumItems) do
  begin
    UserItem := @m_ChrRcd.Data.HumItems[i];
    ListItem := ListViewUserItem.Items.Add;
    ListItem.Caption := IntToStr(i);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(IntToStr(UserItem.wIndex));
    ListItem.SubItems.Add(LocalDBE.GetStdItemName(UserItem.wIndex));
    ListItem.SubItems.Add(Format('%d/%d', [UserItem.Dura, UserItem.DuraMax]));
    ListItem.SubItems.Add(Format(sItemValue, [
      UserItem.btValue[0],
        UserItem.btValue[1],
        UserItem.btValue[2],
        UserItem.btValue[3],
        UserItem.btValue[4],
        UserItem.btValue[5],
        UserItem.btValue[6],
        UserItem.btValue[7],
        UserItem.btValue[8],
        UserItem.btValue[9],
        UserItem.btValue[10],
        UserItem.btValue[11],
        UserItem.btValue[12],
        UserItem.btValue[13]]));
  end;

  {for i := Low(m_ChrRcd.Data.HumAddItems) to High(m_ChrRcd.Data.HumAddItems) do begin
    UserItem := @m_ChrRcd.Data.HumAddItems[i];
    ListItem := ListViewUserItem.Items.Add;
    ListItem.Caption := IntToStr(i);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(IntToStr(UserItem.wIndex));
    ListItem.SubItems.Add(LocalDBE.GetStdItemName(UserItem.wIndex));
    ListItem.SubItems.Add(Format('%d/%d', [UserItem.Dura, UserItem.DuraMax]));
    ListItem.SubItems.Add(Format(sItemValue, [
      UserItem.btValue[0],
        UserItem.btValue[1],
        UserItem.btValue[2],
        UserItem.btValue[3],
        UserItem.btValue[4],
        UserItem.btValue[5],
        UserItem.btValue[6],
        UserItem.btValue[7],
        UserItem.btValue[8],
        UserItem.btValue[9],
        UserItem.btValue[10],
        UserItem.btValue[11],
        UserItem.btValue[12],
        UserItem.btValue[13]
        ]));
  end;}
end;

procedure TfrmEditRcd.RefShowStorage;
var
  i: Integer;
  ListItem: TListItem;
  UserItem: pTUserItem;
begin
  ListViewStorage.Clear;

  for i := Low(m_ChrRcd.Data.StorageItems) to High(m_ChrRcd.Data.StorageItems) do
  begin
    UserItem := @m_ChrRcd.Data.StorageItems[i];
    if UserItem.wIndex = 0 then
      Continue;
    ListItem := ListViewStorage.Items.Add;
    ListItem.Caption := IntToStr(i);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(IntToStr(UserItem.wIndex));
    ListItem.SubItems.Add(LocalDBE.GetStdItemName(UserItem.wIndex));
    ListItem.SubItems.Add(Format('%d/%d', [UserItem.Dura, UserItem.DuraMax]));
    ListItem.SubItems.Add(Format('%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d', [
      UserItem.btValue[0],
        UserItem.btValue[1],
        UserItem.btValue[2],
        UserItem.btValue[3],
        UserItem.btValue[4],
        UserItem.btValue[5],
        UserItem.btValue[6],
        UserItem.btValue[7],
        UserItem.btValue[8],
        UserItem.btValue[9],
        UserItem.btValue[10],
        UserItem.btValue[11],
        UserItem.btValue[12],
        UserItem.btValue[13]
        ]));
  end;
end;

procedure TfrmEditRcd.ButtonExportDataClick(Sender: TObject);
begin
  if Sender = ButtonExportData then
    ProcessSaveRcdToFile()
  else if Sender = ButtonImportData then
    ProcessLoadRcdformFile()
  else if Sender = ButtonSaveData then
    ProcessSaveRcd();
end;

procedure TfrmEditRcd.ProcessSaveRcdToFile;
var
  sSaveFileName: string;
  nFileHandle: Integer;
begin
  SaveDialog.filename := m_ChrRcd.Data.sChrName;
  SaveDialog.InitialDir := '.\';
  if not SaveDialog.Execute then
    Exit;
  sSaveFileName := SaveDialog.filename;

  if FileExists(sSaveFileName) then
    nFileHandle := FileOpen(sSaveFileName, fmOpenReadWrite or fmShareDenyNone)
  else
    nFileHandle := FileCreate(sSaveFileName);
  if nFileHandle <= 0 then
  begin
    MessageBox(Handle, '保存文件出现错误。', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  FileWrite(nFileHandle, m_ChrRcd, SizeOf(THumDataInfo));
  FileClose(nFileHandle);
  MessageBox(Handle, '人物数据导出成功。', '提示信息', MB_OK + MB_IconInformation);
end;

procedure TfrmEditRcd.ProcessLoadRcdformFile;
var
  sLoadFileName: string;
  nFileHandle: Integer;
  ChrRcd: THumDataInfo;
begin
  OpenDialog.filename := m_ChrRcd.Data.sChrName;
  OpenDialog.InitialDir := '.\';
  if not OpenDialog.Execute then
    Exit;
  sLoadFileName := OpenDialog.filename;

  if not FileExists(sLoadFileName) then
  begin
    MessageBox(Handle, '指定的文件未找到。', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  nFileHandle := FileOpen(sLoadFileName, fmOpenReadWrite or fmShareDenyNone);

  if nFileHandle <= 0 then
  begin
    MessageBox(Handle, '打开文件出现错误。', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  if not FileRead(nFileHandle, ChrRcd, SizeOf(THumDataInfo)) = SizeOf(THumDataInfo) then
  begin
    MessageBox(Handle, '读取文件出现错误。'#13#13'文件格式可能不正确', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  ChrRcd.Header := m_ChrRcd.Header;
  ChrRcd.Data.sChrName := m_ChrRcd.Data.sChrName;
  ChrRcd.Data.sAccount := m_ChrRcd.Data.sAccount;
  m_ChrRcd := ChrRcd;
  FileClose(nFileHandle);
  RefShow();
  MessageBox(Handle, '人物数据导入成功。', '提示信息', MB_OK + MB_IconInformation);
end;

procedure TfrmEditRcd.ProcessSaveRcd;
var
  nIdx: Integer;
  boSaveOK: Boolean;
begin
  boSaveOK := False;
  try
    if HumDataDB.Open then
    begin
      nIdx := HumDataDB.Index(m_ChrRcd.Header.sName);
      if (nIdx >= 0) then
      begin
        HumDataDB.Update(nIdx, m_ChrRcd);
        boSaveOK := True;
      end;
    end;
  finally
    HumDataDB.Close;
  end;
  if boSaveOK then
    MessageBox(Handle, '人物数据保存成功。', '提示信息', MB_OK + MB_IconInformation)
  else
    MessageBox(Handle, '人物数据保存失败。', '错误信息', MB_OK + MB_ICONEXCLAMATION);
end;

procedure TfrmEditRcd.EditPasswordChange(Sender: TObject);
begin
  if not m_boOpened then
    Exit;
  if Sender = spJob then
    m_ChrRcd.Data.btJob := spJob.Value
  else if Sender = spGender then
    m_ChrRcd.Data.btSex := spGender.Value
  else if Sender = EditHeroName then
    m_ChrRcd.Data.sHeroName := Trim(EditHeroName.Text)
  else if Sender = EditHeroMasterName then
    m_ChrRcd.Data.sHeroMasterName := Trim(EditHeroMasterName.Text)
  else if Sender = EditPassword then
  begin
    m_ChrRcd.Data.sStoragePwd := Trim(EditPassword.Text);
  end
  else if Sender = EditDearName then
  begin
    m_ChrRcd.Data.sDearName := Trim(EditDearName.Text);
  end
  else if Sender = EditMasterName then
  begin
    m_ChrRcd.Data.sMasterName := Trim(EditMasterName.Text);
  end
  else if Sender = CheckBoxIsMaster then
  begin
    m_ChrRcd.Data.boMaster := CheckBoxIsMaster.Checked;
  end
  else if Sender = EditCurMap then
  begin
    m_ChrRcd.Data.sCurMap := Trim(EditCurMap.Text);
  end
  else if Sender = EditCurX then
  begin
    m_ChrRcd.Data.wCurX := EditCurX.Value;
  end
  else if Sender = EditCurY then
  begin
    m_ChrRcd.Data.wCurY := EditCurY.Value;
  end
  else if Sender = EditHomeMap then
  begin
    m_ChrRcd.Data.sHomeMap := Trim(EditHomeMap.Text);
  end
  else if Sender = EditHomeX then
  begin
    m_ChrRcd.Data.wHomeX := EditHomeX.Value;
  end
  else if Sender = EditCurY then
  begin
    m_ChrRcd.Data.wHomeY := EditHomeY.Value;
  end
  else if Sender = EditLevel then
  begin
    m_ChrRcd.Data.Abil.Level := EditLevel.Value;
  end
  else if Sender = EditGold then
  begin
    m_ChrRcd.Data.nGold := EditGold.Value;
  end
  else if Sender = EditGameGold then
  begin
    m_ChrRcd.Data.nGameGold := EditGameGold.Value;
  end
  else if Sender = EditGamePoint then
  begin
    m_ChrRcd.Data.nGamePoint := EditGamePoint.Value;
  end
  else if Sender = EditPayPoint then
  begin
    m_ChrRcd.Data.nPayMentPoint := EditPayPoint.Value;
  end
  else if Sender = EditCreditPoint then
  begin
    m_ChrRcd.Data.btCreditPoint := EditCreditPoint.Value;
  end
  else if Sender = EditPKPoint then
  begin
    m_ChrRcd.Data.nPKPoint := EditPKPoint.Value;
  end
  else if Sender = EditContribution then
  begin
    //m_ChrRcd.Data.wContribution := EditContribution.Value;
  end
end;

end.
