unit NpcCustomU;

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, Grobal2, Dialogs,sysUtils,
  Spin, ComCtrls;

type
  TftmNpcCustom = class(TForm)
    BtnAdd: TButton;
    btnDel: TButton;
    btnSave: TButton;
    lbl: TLabel;
    EdtNpcCode: TSpinEdit;
    lbl1: TLabel;
    comboResourceFileIndex: TComboBox;
    lbl4: TLabel;
    EdtPlaySpeed: TSpinEdit;
    lbl5: TLabel;
    ComboNPCDir: TComboBox;
    grp1: TGroupBox;
    lstNpcCode: TListBox;
    grp2: TGroupBox;
    lvNpcCustom: TListView;
    grp3: TGroupBox;
    lvFilterNpcCustom: TListView;
    grp4: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl6: TLabel;
    EdtStandStartOffset: TSpinEdit;
    EdtStandPlayCount: TSpinEdit;
    chkStandUseEffect: TCheckBox;
    EdtStandEffectStartOffset: TSpinEdit;
    grp5: TGroupBox;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    ChkHitUseEffect: TCheckBox;
    EdtHitStartOffset: TSpinEdit;
    EdtHitEffectStartOffset: TSpinEdit;
    EdtHitPlayCount: TSpinEdit;
    btnUpdate: TButton;
    grp6: TGroupBox;
    btnBatchUpdate: TButton;
    chkBatchUpdateResource: TCheckBox;
    lbl10: TLabel;
    comboResourceFileIndexBatch: TComboBox;
    chkBatchUpdatePlaySpeed: TCheckBox;
    lbl11: TLabel;
    comboPlaySpeedBatch: TSpinEdit;
    chkBatchUpdateStandEffect: TCheckBox;
    lbl12: TLabel;
    comboStandEffect: TComboBox;
    chkBatchUpdateHitEffect: TCheckBox;
    lbl13: TLabel;
    comboHitEffect: TComboBox;
    chkBatchUpdateStandCount: TCheckBox;
    lbl14: TLabel;
    EdtStandPlayCountBatch: TSpinEdit;
    chkBatchUpdateHitCount: TCheckBox;
    lbl15: TLabel;
    EdtHitPlayCountBatch: TSpinEdit;
    grp7: TGroupBox;
    btnAutoFill: TButton;
    lbl16: TLabel;
    EdtStandBlankCount: TSpinEdit;
    lbl17: TLabel;
    EdtStandEffectBlankCount: TSpinEdit;
    lbl18: TLabel;
    EdtHitBlankCount: TSpinEdit;
    lbl19: TLabel;
    EdtHitEffectBlankCount: TSpinEdit;
    lbl20: TLabel;
    comboBaseDir: TComboBox;
    btnBatchAdd: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure lstNpcCodeClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure lvFilterNpcCustomClick(Sender: TObject);
    procedure btnBatchUpdateClick(Sender: TObject);
    procedure chkBatchUpdateResourceClick(Sender: TObject);
    procedure chkBatchUpdatePlaySpeedClick(Sender: TObject);
    procedure chkBatchUpdateStandEffectClick(Sender: TObject);
    procedure chkBatchUpdateHitEffectClick(Sender: TObject);
    procedure chkBatchUpdateStandCountClick(Sender: TObject);
    procedure chkBatchUpdateHitCountClick(Sender: TObject);
    procedure btnBatchAddClick(Sender: TObject);
    procedure btnAutoFillClick(Sender: TObject);
  private
    { Private declarations }
    procedure setButton();
    procedure reloadFilter(sNpcCode: String);
    function findNodeByNpc(selNpcCode: string; selNpcDir: String): TListItem;
  public
    procedure Open();
    { Public declarations }
  end;

var
  ftmNpcCustom: TftmNpcCustom;

implementation

uses M2Share;

{$R *.dfm}
var bChanged:Boolean;


procedure TftmNpcCustom.setButton();
begin
  btnDel.Enabled := (lvFilterNpcCustom.Items.Count > 0);
  btnUpdate.Enabled := (lvFilterNpcCustom.Items.Count > 0);
  btnSave.Enabled := bChanged;
  btnBatchUpdate.Enabled := (lvFilterNpcCustom.Items.Count > 0);
  btnAutoFill.Enabled := (lvFilterNpcCustom.Items.Count > 0);
  chkBatchUpdateResource.Enabled := btnBatchUpdate.Enabled;
  comboResourceFileIndexBatch.Enabled := chkBatchUpdateResource.Enabled and chkBatchUpdateResource.Checked;
  chkBatchUpdatePlaySpeed.Enabled := btnBatchUpdate.Enabled;
  comboPlaySpeedBatch.Enabled := chkBatchUpdatePlaySpeed.Enabled and chkBatchUpdatePlaySpeed.Checked;
  chkBatchUpdateStandEffect.Enabled := btnBatchUpdate.Enabled;
  comboStandEffect.Enabled := chkBatchUpdateStandEffect.Enabled and chkBatchUpdateStandEffect.Checked;
  chkBatchUpdateHitEffect.Enabled := btnBatchUpdate.Enabled;
  comboHitEffect.Enabled := chkBatchUpdateHitEffect.Enabled and chkBatchUpdateHitEffect.Checked;
  chkBatchUpdateStandCount.Enabled := btnBatchUpdate.Enabled;
  EdtStandPlayCountBatch.Enabled := chkBatchUpdateStandCount.Enabled and chkBatchUpdateStandCount.Checked;
  chkBatchUpdateHitCount.Enabled := btnBatchUpdate.Enabled;
  EdtHitPlayCountBatch.Enabled := chkBatchUpdateHitCount.Enabled and chkBatchUpdateHitCount.Checked;
end;

procedure TftmNpcCustom.Open;
begin
  ShowModal();
end;


procedure TftmNpcCustom.btnSaveClick(Sender: TObject);
var
  sFileName: String;
  i: Integer;
  LoadList: TStringList;
  ListItem: TListItem;

  sNpcCode: String;
  sNpcDir: String;
  sResFileIndex: String;
  sStandStartOffset: String;
  sStandUseEffect: String;
  sStandEffectStartOffset: String;
  sStandPlayCount: String;
  sHitStartOffset: String;
  sHitUseEffect: String;
  sHitEffectStartOffset: String;
  sHitPlayCount: String;
  sPlaySpeed: String;
  sLine: String;
begin
  sFileName := g_Config.sEnvirDir + 'NpcCustom.txt';
  LoadList := TStringList.Create;
  for i := 0 to lvNpcCustom.Items.Count - 1 do
  begin
    ListItem := lvNpcCustom.Items.item[i];
    sLine := '';
    sNpcCode := ListItem.Caption + #9;
    sLine := sLine + sNpcCode;
    sNpcDir := ListItem.SubItems.Strings[2] + #9;
    sLine := sLine + sNpcDir;
    sResFileIndex := ListItem.SubItems.Strings[0] + #9;
    sLine := sLine + sResFileIndex;
    sStandStartOffset := ListItem.SubItems.Strings[4] + #9;
    sLine := sLine + sStandStartOffset;
    sStandUseEffect := ListItem.SubItems.Strings[5] + #9;
    sLine := sLine + sStandUseEffect;
    sStandEffectStartOffset := ListItem.SubItems.Strings[6] + #9;
    sLine := sLine + sStandEffectStartOffset;
    sStandPlayCount := ListItem.SubItems.Strings[7] + #9;
    sLine := sLine + sStandPlayCount;
    sHitStartOffset := ListItem.SubItems.Strings[8] + #9;
    sLine := sLine + sHitStartOffset;
    sHitUseEffect := ListItem.SubItems.Strings[9] + #9;
    sLine := sLine + sHitUseEffect;
    sHitEffectStartOffset := ListItem.SubItems.Strings[10] + #9;
    sLine := sLine + sHitEffectStartOffset;
    sHitPlayCount := ListItem.SubItems.Strings[11] + #9;
    sLine := sLine + sHitPlayCount;
    sPlaySpeed := ListItem.SubItems.Strings[3];
    sLine := sLine + sPlaySpeed;
    LoadList.Add(sLine);
  end;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;

  LoadNpcCustom();
  //ShowMessage('文件已经成功保存到'+sFileName);
  bChanged := False;
  setButton;
end;

procedure TftmNpcCustom.FormCreate(Sender: TObject);
var
  i: Integer;
  ListItem: TListItem;
  P: pTNpcCustom;
  sLastNpcCode: String;
begin
  bChanged := False;
  comboResourceFileIndex.Clear;
  comboResourceFileIndexBatch.Clear;
  for i := 0 to g_FileCustomList_Server.count -1 do
  begin
    comboResourceFileIndex.Items.Add(g_FileCustomList_Server.Strings[i]);
    comboResourceFileIndexBatch.Items.Add(g_FileCustomList_Server.Strings[i]);
  end;
  comboResourceFileIndex.ItemIndex := 0;
  comboResourceFileIndexBatch.ItemIndex := 0;


  sLastNpcCode := '';
  lstNpcCode.Clear;
  for i := 0 to g_NPCCustomList_Server.Count -1 do
  begin
    P := g_NPCCustomList_Server.Items[i];

    if sLastNpcCode <> IntToStr(P^.nNpcCode) then
    begin
      lstNpcCode.items.add(IntToStr(P^.nNpcCode));
      sLastNpcCode := IntToStr(P^.nNpcCode);
    end;

    ListItem := lvNpcCustom.Items.Add;
    ListItem.Caption := IntToStr(P^.nNpcCode);
    ListItem.SubItems.Add(IntToStr(P^.nResFileIndex));
    ListItem.SubItems.Add(comboResourceFileIndex.Items[P^.nResFileIndex]);
    ListItem.SubItems.Add(IntToStr(P^.nNpcDir));
    ListItem.SubItems.Add(IntToStr(P^.nPlaySpeed));

    ListItem.SubItems.Add(IntToStr(P^.nStandStartOffset));
    if P^.bStandUseEffect then
    begin
      ListItem.SubItems.Add('1');
    end
    else
    begin
      ListItem.SubItems.Add('0');
    end;
    ListItem.SubItems.Add(IntToStr(P^.nStandEffectStartOffset));
    ListItem.SubItems.Add(IntToStr(P^.nStandPlayCount));

    ListItem.SubItems.Add(IntToStr(P^.nHitStartOffset));
    if P^.bHitUseEffect then
    begin
      ListItem.SubItems.Add('1');
    end
    else
    begin
      ListItem.SubItems.Add('0');
    end;
    ListItem.SubItems.Add(IntToStr(P^.nHitEffectStartOffset));
    ListItem.SubItems.Add(IntToStr(P^.nHitPlayCount));

  end;
  setButton;
end;

procedure TftmNpcCustom.BtnAddClick(Sender: TObject);
var
  i: Integer;
  bFound: boolean;
  ListItem: TListItem;
  sSameNpcCode,sSameNpcDir: String;
begin
    bFound := False;
    for i := 0 to lvNpcCustom.items.Count - 1 do
    begin
      if (lvNpcCustom.Items[i].Caption = inttostr(EdtNpcCode.value)) and (lvNpcCustom.Items[i].SubItems[2] = inttostr(ComboNPCDir.ItemIndex))  then
      begin
        sSameNpcCode := inttostr(EdtNpcCode.value);
        sSameNpcDir := inttostr(ComboNPCDir.ItemIndex);
        bFound := True;
        break;
      end;
    end;

    if bFound then
    begin
      ShowMessage('NPC代码:' + sSameNpcCode + ',并同NPC方向' + sSameNpcDir + ',已经存在列表中,不允许重复增加');
      exit;
    end;


    ListItem := lvNpcCustom.Items.Add;
    ListItem.Caption := IntToStr(EdtNpcCode.Value);
    ListItem.SubItems.Add(IntToStr(comboResourceFileIndex.ItemIndex));
    ListItem.SubItems.Add(comboResourceFileIndex.Items[comboResourceFileIndex.ItemIndex]);
    ListItem.SubItems.Add(IntToStr(ComboNPCDir.ItemIndex));
    ListItem.SubItems.Add(IntToStr(EdtPlaySpeed.Value));

    ListItem.SubItems.Add(IntToStr(EdtStandStartOffset.value));
    if chkStandUseEffect.Checked then
    begin
      ListItem.SubItems.Add('1');
    end
    else
    begin
      ListItem.SubItems.Add('0');
    end;
    ListItem.SubItems.Add(IntToStr(EdtStandEffectStartOffset.value));
    ListItem.SubItems.Add(IntToStr(EdtStandPlayCount.value));

    ListItem.SubItems.Add(IntToStr(EdtHitStartOffset.value));
    if chkHitUseEffect.Checked then
    begin
      ListItem.SubItems.Add('1');
    end
    else
    begin
      ListItem.SubItems.Add('0');
    end;
    ListItem.SubItems.Add(IntToStr(EdtHitEffectStartOffset.value));
    ListItem.SubItems.Add(IntToStr(EdtHitPlayCount.value));

    bFound := False;
    for i:= 0 to lstNpcCode.Items.Count -1 do
    begin
      if lstNpcCode.Items[i] = IntToStr(EdtNpcCode.Value) then
      begin
        bFound := True;
        break;
      end;
    end;

    if not bFound then
    begin
     lstNpcCode.Items.Add(IntToStr(EdtNpcCode.Value));
     lstNpcCode.ItemIndex := lstNpcCode.items.Count -1; 
     reloadFilter(IntToStr(EdtNpcCode.Value));
    end;
        
  bChanged := True;
  setButton;   
end;

procedure TftmNpcCustom.btnDelClick(Sender: TObject);
var
  i: Integer;
  selNpcCode: String;
  selNpcDir: String;
begin

  if (lvFilterNpcCustom.SelCount = 0) then
  begin
    ShowMessage('请先选中筛选列表中的内容，再点删除');
    exit;
  end;

  if (lvFilterNpcCustom.SelCount > 1) then
  begin
    ShowMessage('只支持单行删除功能');
    exit;
  end;

  selNpcCode := lvFilterNpcCustom.Selected.Caption;
  selNpcDir :=  lvFilterNpcCustom.Selected.SubItems[2];

  lvFilterNpcCustom.DeleteSelected;

  for i := lvNpcCustom.Items.Count -1 downto 0 do
  begin
    if (lvNpcCustom.Items[i].Caption = selNpcCode) and (lvNpcCustom.Items[i].SubItems[2] = selNpcDir) then
    begin
      lvNpcCustom.Items[i].Delete;
      break;
    end;
  end;

  if lvFilterNpcCustom.Items.Count = 0 then
  begin
    for i := lstNpcCode.Items.count-1 downto 0 do
    begin
      if lstNpcCode.Items[i] = selNpcCode then
      begin
        lstNpcCode.Items.Delete(i);
        break;
      end;
    end;
  end;
  
  bChanged := True;
  setButton;
end;

procedure TftmNpcCustom.reloadFilter(sNpcCode: String);
var
  i: Integer;
  ListItem: TListItem;
begin
  if lstNpcCode.Items.Count > 0 then
  begin
    lvFilterNpcCustom.Items.Clear;
    for i := 0 to lvNpcCustom.Items.Count -1 do
    begin
      if lvNpcCustom.Items[i].Caption = sNpcCode then
      begin
        ListItem := lvFilterNpcCustom.Items.Add;
        ListItem.Assign(lvNpcCustom.Items[i]);
      end;
    end;
  end;
  setButton;
end;

procedure TftmNpcCustom.lstNpcCodeClick(Sender: TObject);
var
  i: Integer;
begin
  reloadFilter(lstNpcCode.items[lstNpcCode.itemIndex]);
end;

procedure TftmNpcCustom.btnUpdateClick(Sender: TObject);
var
  i: Integer;
  selNpcCode: String;
  selNpcDir: String;
begin
  if (lvFilterNpcCustom.SelCount = 0) then
  begin
    ShowMessage('请先选中筛选列表中的内容，再点修改');
    exit;
  end;

  selNpcCode := lvFilterNpcCustom.Selected.Caption;
  selNpcDir :=  lvFilterNpcCustom.Selected.SubItems[2];

  for i := 0 to lvFilterNpcCustom.Items.Count -1 do
  begin
    if (lvFilterNpcCustom.Items[i].Caption = selNpcCode) and (lvFilterNpcCustom.Items[i].SubItems[2] = selNpcDir) then
    begin
      lvFilterNpcCustom.Items[i].SubItems[0] := IntToStr(comboResourceFileIndex.ItemIndex);
      lvFilterNpcCustom.Items[i].SubItems[1] := comboResourceFileIndex.Items[comboResourceFileIndex.ItemIndex];
      lvFilterNpcCustom.Items[i].SubItems[3] := IntToStr(EdtPlaySpeed.Value);


      lvFilterNpcCustom.Items[i].SubItems[4] := IntToStr(EdtStandStartOffset.Value);
      if chkStandUseEffect.Checked then
      begin
        lvFilterNpcCustom.Items[i].SubItems[5] := '1';
      end
      else
      begin
        lvFilterNpcCustom.Items[i].SubItems[5] := '0';
      end;
      lvFilterNpcCustom.Items[i].SubItems[6] := IntToStr(EdtStandEffectStartOffset.Value);
      lvFilterNpcCustom.Items[i].SubItems[7] := IntToStr(EdtStandPlayCount.Value);


      lvFilterNpcCustom.Items[i].SubItems[8] := IntToStr(EdtHitStartOffset.Value);
      if chkHitUseEffect.Checked then
      begin
        lvFilterNpcCustom.Items[i].SubItems[9] := '1';
      end
      else
      begin
        lvFilterNpcCustom.Items[i].SubItems[9] := '0';
      end;
      lvFilterNpcCustom.Items[i].SubItems[10] := IntToStr(EdtHitEffectStartOffset.Value);
      lvFilterNpcCustom.Items[i].SubItems[11] := IntToStr(EdtHitPlayCount.Value);
      break;
    end;
  end;

  for i := 0 to lvNpcCustom.Items.Count -1 do
  begin
    if (lvNpcCustom.Items[i].Caption = selNpcCode) and (lvNpcCustom.Items[i].SubItems[2] = selNpcDir) then
    begin
      lvNpcCustom.Items[i].SubItems[0] := IntToStr(comboResourceFileIndex.ItemIndex);
      lvNpcCustom.Items[i].SubItems[1] := comboResourceFileIndex.Items[comboResourceFileIndex.ItemIndex];
      lvNpcCustom.Items[i].SubItems[3] := IntToStr(EdtPlaySpeed.Value);


      lvNpcCustom.Items[i].SubItems[4] := IntToStr(EdtStandStartOffset.Value);
      if chkStandUseEffect.Checked then
      begin
        lvNpcCustom.Items[i].SubItems[5] := '1';
      end
      else
      begin
        lvNpcCustom.Items[i].SubItems[5] := '0';
      end;
      lvNpcCustom.Items[i].SubItems[6] := IntToStr(EdtStandEffectStartOffset.Value);
      lvNpcCustom.Items[i].SubItems[7] := IntToStr(EdtStandPlayCount.Value);


      lvNpcCustom.Items[i].SubItems[8] := IntToStr(EdtHitStartOffset.Value);
      if chkHitUseEffect.Checked then
      begin
        lvNpcCustom.Items[i].SubItems[9] := '1';
      end
      else
      begin
        lvNpcCustom.Items[i].SubItems[9] := '0';
      end;
      lvNpcCustom.Items[i].SubItems[10] := IntToStr(EdtHitEffectStartOffset.Value);
      lvNpcCustom.Items[i].SubItems[11] := IntToStr(EdtHitPlayCount.Value);
      break;
    end;
  end;
  bChanged := True;
  setButton;
end;

procedure TftmNpcCustom.lvFilterNpcCustomClick(Sender: TObject);
begin
  if lvFilterNpcCustom.SelCount > 0 then
  begin
    EdtNpcCode.value := StrToInt(lvFilterNpcCustom.Selected.Caption);
    comboResourceFileIndex.ItemIndex := StrToInt(lvFilterNpcCustom.Selected.SubItems[0]);
    ComboNPCDir.ItemIndex := StrToInt(lvFilterNpcCustom.Selected.SubItems[2]);
    EdtPlaySpeed.Value := StrToInt(lvFilterNpcCustom.Selected.SubItems[3]);

    EdtStandStartOffset.Value := StrToInt(lvFilterNpcCustom.Selected.SubItems[4]);
    if StrToInt(lvFilterNpcCustom.Selected.SubItems[5]) = 1 then
    begin
      chkStandUseEffect.Checked := True;
    end
    else
    begin
      chkStandUseEffect.Checked := False;
    end;
    EdtStandEffectStartOffset.Value := StrToInt(lvFilterNpcCustom.Selected.SubItems[6]);
    EdtStandPlayCount.Value := StrToInt(lvFilterNpcCustom.Selected.SubItems[7]);

    EdtHitStartOffset.Value := StrToInt(lvFilterNpcCustom.Selected.SubItems[8]);
    if StrToInt(lvFilterNpcCustom.Selected.SubItems[9]) = 1 then
    begin
      chkHitUseEffect.Checked := True;
    end
    else
    begin
      chkHitUseEffect.Checked := False;
    end;
    EdtHitEffectStartOffset.Value := StrToInt(lvFilterNpcCustom.Selected.SubItems[10]);
    EdtHitPlayCount.Value := StrToInt(lvFilterNpcCustom.Selected.SubItems[11]);
  end;
end;

function TFtmNpcCustom.findNodeByNpc(selNpcCode: string; selNpcDir: String): TListItem;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to lvNpcCustom.Items.Count -1 do
  begin
    if (lvNpcCustom.Items[i].Caption = selNpcCode) and (lvNpcCustom.Items[i].SubItems[2] = selNpcDir) then
    begin
      Result := lvNpcCustom.items[i];
      break;
    end;
  end;
end;

procedure TftmNpcCustom.btnBatchUpdateClick(Sender: TObject);
var
  i: Integer;
  selNpcCode: String;
  selNpcDir: String;
  tmpList: TListItem;
begin
  if (lvFilterNpcCustom.SelCount = 0) then
  begin
    ShowMessage('请先选中筛选列表中的内容(至少选择一条记录)，再点批量修改');
    exit;
  end;


  for i := 0 to lvFilterNpcCustom.items.Count - 1 do
  begin
    if lvFilterNpcCustom.Items[i].Selected then
    begin
      selNpcCode := lvFilterNpcCustom.Items[i].Caption;
      selNpcDir := lvFilterNpcCustom.Items[i].SubItems[2];
      tmpList := findNodeByNpc(selNpcCode,selNpcDir);
      if tmpList = nil then continue;  //如果主列表该对象为空则进入下一次循环

      if chkBatchUpdateResource.Checked then
      begin
        lvFilterNpcCustom.Items[i].SubItems[0] := IntToStr(comboResourceFileIndexBatch.ItemIndex);
        lvFilterNpcCustom.Items[i].SubItems[1] := comboResourceFileIndexBatch.Items[comboResourceFileIndexBatch.ItemIndex];
        tmpList.SubItems[0] := IntToStr(comboResourceFileIndexBatch.ItemIndex);
        tmpList.SubItems[1] := comboResourceFileIndexBatch.Items[comboResourceFileIndexBatch.ItemIndex];
      end;

      if chkBatchUpdatePlaySpeed.Checked then
      begin
        lvFilterNpcCustom.Items[i].SubItems[3] := IntToStr(comboPlaySpeedBatch.Value);
        tmpList.SubItems[3] := IntToStr(comboPlaySpeedBatch.Value);
      end;

      if chkBatchUpdateStandEffect.Checked then
      begin
        lvFilterNpcCustom.Items[i].SubItems[5] := IntToStr(comboStandEffect.ItemIndex);
        tmpList.SubItems[5] := IntToStr(comboStandEffect.ItemIndex);
      end;

      if chkBatchUpdateHitEffect.Checked then
      begin
        lvFilterNpcCustom.Items[i].SubItems[9] := IntToStr(comboHitEffect.ItemIndex);
        tmpList.SubItems[9] := IntToStr(comboHitEffect.ItemIndex);
      end;

      if chkBatchUpdateStandCount.Checked then
      begin
        lvFilterNpcCustom.Items[i].SubItems[7] := IntToStr(EdtStandPlayCountBatch.Value);
        tmpList.SubItems[7] := IntToStr(EdtStandPlayCountBatch.Value);
      end;

      if chkBatchUpdateHitCount.Checked then
      begin
        lvFilterNpcCustom.Items[i].SubItems[11] := IntToStr(EdtHitPlayCountBatch.Value);
        tmpList.SubItems[11] := IntToStr(EdtHitPlayCountBatch.Value);
      end;

    end;
  end;

  bChanged := True;
  setButton;
end;

procedure TftmNpcCustom.chkBatchUpdateResourceClick(Sender: TObject);
begin
  setButton;
end;

procedure TftmNpcCustom.chkBatchUpdatePlaySpeedClick(Sender: TObject);
begin
  setButton;
end;

procedure TftmNpcCustom.chkBatchUpdateStandEffectClick(Sender: TObject);
begin
  setButton;
end;

procedure TftmNpcCustom.chkBatchUpdateHitEffectClick(Sender: TObject);
begin
  setButton;
end;

procedure TftmNpcCustom.chkBatchUpdateStandCountClick(Sender: TObject);
begin
  setButton;
end;

procedure TftmNpcCustom.chkBatchUpdateHitCountClick(Sender: TObject);
begin
  setButton;
end;

procedure TftmNpcCustom.btnBatchAddClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to 7 do
  begin
    ComboNPCDir.ItemIndex := i;
    BtnAddClick(nil)
  end;
  reloadFilter(lstNpcCode.items[lstNpcCode.itemIndex]);
end;

procedure TftmNpcCustom.btnAutoFillClick(Sender: TObject);
var
  i: Integer;
  selNpcCode: String;
  selNpcDir: String;

  baseNpcCode: String;
  baseNpcDir: String;

  baseStandStartOffset: String;
  baseStandPlayCount: String;
  baseStandEffectStartOffset: String;
  baseStandBlankCount: String;
  baseStandEffectBlankCount: String;

  baseHitStartOffset: String;
  baseHitPlayCount: String;
  baseHitEffectStartOffset: String;
  baseHitBlankCount: String;
  baseHitEffectBlankCount: String;
  tmpList: TListItem;
  bFoundBase :boolean;
begin
  if (lvFilterNpcCustom.SelCount = 0) then
  begin
    ShowMessage('请先选中筛选列表中的内容(至少选择一条记录)，再点批量计算更新');
    exit;
  end;

  bFoundBase := False;
  for i := 0 to lvFilterNpcCustom.items.Count - 1 do
  begin
    if (lvFilterNpcCustom.Items[i].Caption = IntToStr(EdtNpcCode.Value)) and (lvFilterNpcCustom.Items[i].SubItems[2] = inttostr(comboBaseDir.ItemIndex)) then
    begin
      baseNpcCode := lvFilterNpcCustom.Items[i].Caption;
      baseNpcDir := lvFilterNpcCustom.Items[i].SubItems[2];
      baseStandStartOffset := lvFilterNpcCustom.Items[i].SubItems[4];
      baseStandPlayCount := lvFilterNpcCustom.Items[i].SubItems[7];
      baseStandEffectStartOffset := lvFilterNpcCustom.Items[i].SubItems[6];
      baseStandBlankCount := IntToStr(EdtStandBlankCount.Value);
      baseStandEffectBlankCount := IntToStr(EdtStandEffectBlankCount.Value);

      baseHitStartOffset := lvFilterNpcCustom.Items[i].SubItems[8];
      baseHitPlayCount := lvFilterNpcCustom.Items[i].SubItems[11];
      baseHitEffectStartOffset := lvFilterNpcCustom.Items[i].SubItems[10];
      baseHitBlankCount := IntToStr(EdtHitBlankCount.Value);
      baseHitEffectBlankCount := IntToStr(EdtHitEffectBlankCount.Value);

      bFoundBase := True;
      break;
    end;
  end;

  if not bFoundBase then
  begin
    ShowMessage('未在列表中找到基准NPC方向数据，无法进行批量计算更新.');
    exit;
  end;

  for i := 0 to lvFilterNpcCustom.items.Count - 1 do
  begin
    if lvFilterNpcCustom.Items[i].Selected then
    begin
      selNpcCode := lvFilterNpcCustom.Items[i].Caption;
      selNpcDir := lvFilterNpcCustom.Items[i].SubItems[2];
      tmpList := findNodeByNpc(selNpcCode,selNpcDir);
      if (tmpList = nil) or (selNpcDir = baseNpcDir) then continue;  //如果主列表该对象为空或为同方向本体则进入下一次循环


      lvFilterNpcCustom.Items[i].SubItems[4] := IntToStr(StrToInt(baseStandStartOffset) + i * (StrToInt(baseStandPlayCount) + StrToInt(baseStandBlankCount)));
      tmpList.SubItems[4] := IntToStr(StrToInt(baseStandStartOffset) + i * (StrToInt(baseStandPlayCount) + StrToInt(baseStandBlankCount)));

      if tmpList.SubItems[5] = '1' then
      begin
        lvFilterNpcCustom.Items[i].SubItems[6] := IntToStr(StrToInt(baseStandEffectStartOffset) + i * (StrToInt(baseStandPlayCount) + StrToInt(baseStandEffectBlankCount)));
        tmpList.SubItems[6] := IntToStr(StrToInt(baseStandEffectStartOffset) + i * (StrToInt(baseStandPlayCount) + StrToInt(baseStandEffectBlankCount)));
      end;

      lvFilterNpcCustom.Items[i].SubItems[7] := BaseStandPlayCount;
      tmpList.SubItems[7] := BaseStandPlayCount;


      lvFilterNpcCustom.Items[i].SubItems[8] := IntToStr(StrToInt(baseHitStartOffset) + i * (StrToInt(baseHitPlayCount) + StrToInt(baseHitBlankCount)));
      tmpList.SubItems[8] := IntToStr(StrToInt(baseHitStartOffset) + i * (StrToInt(baseHitPlayCount) + StrToInt(baseHitBlankCount)));

      if tmpList.SubItems[9] = '1' then
      begin
        lvFilterNpcCustom.Items[i].SubItems[10] := IntToStr(StrToInt(baseHitEffectStartOffset) + i * (StrToInt(baseHitPlayCount) + StrToInt(baseHitEffectBlankCount)));
        tmpList.SubItems[10] := IntToStr(StrToInt(baseHitEffectStartOffset) + i * (StrToInt(baseHitPlayCount) + StrToInt(baseHitEffectBlankCount)));
      end;

      lvFilterNpcCustom.Items[i].SubItems[11] := BaseHitPlayCount;
      tmpList.SubItems[11] := BaseHitPlayCount;

    end;
  end;

  bChanged := True;
  setButton;
end;

end.
