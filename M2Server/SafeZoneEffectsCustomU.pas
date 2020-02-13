unit SafeZoneEffectsCustomU;

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, Grobal2, Dialogs,sysUtils,
  Spin, ComCtrls;

type
  TftmSafeZoneEffectsCustom = class(TForm)
    BtnAdd: TButton;
    btnDel: TButton;
    btnSave: TButton;
    lbl: TLabel;
    EdtEffectsTypeID: TSpinEdit;
    lbl1: TLabel;
    comboEffectFileIndex: TComboBox;
    lbl2: TLabel;
    EdtEffectsStartOffSet: TSpinEdit;
    EdtEffectsCountOffSet: TSpinEdit;
    lbl3: TLabel;
    chkEffectsBlendDraw: TCheckBox;
    lbl4: TLabel;
    EdtEffectsSpeed: TSpinEdit;
    lvSafeZoneEffectsCustom: TListView;
    lbl5: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure lvSafeZoneEffectsCustomClick(Sender: TObject);
  private
    { Private declarations }
    procedure setButton();
  public
    procedure Open();
    { Public declarations }
  end;

var
  ftmSafeZoneEffectsCustom: TftmSafeZoneEffectsCustom;

implementation

uses M2Share;

{$R *.dfm}
var bChanged:Boolean;

procedure TftmSafeZoneEffectsCustom.setButton();
begin
 btnDel.Enabled := (lvSafeZoneEffectsCustom.Items.Count > 0);
 btnSave.Enabled := bChanged;
end;

procedure TftmSafeZoneEffectsCustom.Open;
begin
  ShowModal();
end;


procedure TftmSafeZoneEffectsCustom.btnSaveClick(Sender: TObject);
var
  sFileName: String;
  i: Integer;
  LoadList: TStringList;
  ListItem: TListItem; 
begin
  sFileName := g_Config.sEnvirDir + 'StartPointCustom.txt';
  LoadList := TStringList.Create;
  for i := 0 to lvSafeZoneEffectsCustom.Items.Count - 1 do
  begin
    ListItem := lvSafeZoneEffectsCustom.Items.item[i];
    LoadList.Add(ListItem.Caption + #9 +
      ListItem.SubItems.Strings[0] + #9 +
      ListItem.SubItems.Strings[2] + #9 +
      ListItem.SubItems.Strings[3] + #9 +
      ListItem.SubItems.Strings[4] + #9 +
      ListItem.SubItems.Strings[5]);
  end;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;

  LoadStartPointCustom();
  //ShowMessage('文件已经成功保存到'+sFileName);
  bChanged := False;
  setButton;
end;

procedure TftmSafeZoneEffectsCustom.FormCreate(Sender: TObject);
var
  i: Integer;
  ListItem: TListItem;
  P: pTStartPointCustom;
begin
  bChanged := False;
  comboEffectFileIndex.Clear;
  for i := 0 to g_FileCustomList_Server.count -1 do
  begin
    comboEffectFileIndex.Items.Add(g_FileCustomList_Server.Strings[i]);
  end;
  comboEffectFileIndex.ItemIndex := 0;

  for i := 0 to g_StartPointCustomList_Server.Count -1 do
  begin
    P := g_StartPointCustomList_Server.Items[i];
    ListItem := lvSafeZoneEffectsCustom.Items.Add;
    ListItem.Caption := IntToStr(P^.nEffectsType);
    ListItem.SubItems.Add(IntToStr(P^.nEffectsFileIndex));
    ListItem.SubItems.Add(comboEffectFileIndex.Items[P^.nEffectsFileIndex]);
    ListItem.SubItems.Add(IntToStr(P^.nEffectsStartOffset));
    ListItem.SubItems.Add(IntToStr(P^.nEffectsCountOffset));
    if P^.bEffectsBlendDraw then
    begin
      ListItem.SubItems.Add('1');
    end
    else
    begin
      ListItem.SubItems.Add('0');
    end;
    ListItem.SubItems.Add(IntToStr(P^.nEffectsSpeed));
  end;
  setButton;
end;

procedure TftmSafeZoneEffectsCustom.BtnAddClick(Sender: TObject);
var
  i: Integer;
  bFound: boolean;
  ListItem: TListItem;
begin
    bFound := False;
    for i :=0 to lvSafeZoneEffectsCustom.items.Count -1 do
    begin
      if lvSafeZoneEffectsCustom.Items[i].Caption = inttostr(EdtEffectsTypeID.value) then
      begin
        bFound := True;
        break;
      end;
    end;

    if bFound then
    begin
      ShowMessage('该光环特效类型已经存在列表中，不允许重复增加');
      exit;
    end;

    if not (EdtEffectsTypeID.Value in [CUSTOM_SAFEZONE_EFFSTART_INX .. CUSTOM_SAFEZONE_EFFEND_INX]) then
    begin
      ShowMessage('非法数据!,该光环特效类型不在范围[' + inttostr(CUSTOM_SAFEZONE_EFFSTART_INX) + '..' + inttostr(CUSTOM_SAFEZONE_EFFEND_INX) + ']中');
      exit;
    end;

    if comboEffectFileIndex.ItemIndex < 0 then
    begin
      ShowMessage('特效文件索引不能为负数!');
      exit;
    end;

    if EdtEffectsStartOffSet.Value < 0 then
    begin
      ShowMessage('起始贞不能为负数!');
      exit;
    end;

    if EdtEffectsCountOffSet.Value <= 0 then
    begin
      ShowMessage('播放贞数必须大于0!');
      exit;
    end;

    if EdtEffectsSpeed.value <= 0 then
    begin
      ShowMessage('播放速度必须大于0!');
      exit;
    end;

    ListItem := lvSafeZoneEffectsCustom.Items.Add;
    ListItem.Caption := IntToStr(EdtEffectsTypeID.Value);
    ListItem.SubItems.Add(IntToStr(comboEffectFileIndex.ItemIndex));
    ListItem.SubItems.Add(comboEffectFileIndex.Items[comboEffectFileIndex.ItemIndex]);
    ListItem.SubItems.Add(IntToStr(EdtEffectsStartOffSet.Value));
    ListItem.SubItems.Add(IntToStr(EdtEffectsCountOffSet.Value));
    if chkEffectsBlendDraw.Checked then
    begin
      ListItem.SubItems.Add('1');
    end
    else
    begin
      ListItem.SubItems.Add('0');
    end;
    ListItem.SubItems.Add(IntToStr(EdtEffectsSpeed.value));

  bChanged := True;
  setButton;
end;

procedure TftmSafeZoneEffectsCustom.btnDelClick(Sender: TObject);
var i:Integer;
begin

  if lvSafeZoneEffectsCustom.SelCount = 0 then
  begin
    ShowMessage('请先选中特效光环的内容，再点删除');
    exit;
  end;

  lvSafeZoneEffectsCustom.DeleteSelected;
  bChanged := True;
  setButton;
end;

procedure TftmSafeZoneEffectsCustom.lvSafeZoneEffectsCustomClick(
  Sender: TObject);
begin
  if lvSafeZoneEffectsCustom.SelCount > 0 then
  begin
    EdtEffectsTypeID.value := StrToInt(lvSafeZoneEffectsCustom.Selected.Caption);
    comboEffectFileIndex.ItemIndex := StrToInt(lvSafeZoneEffectsCustom.Selected.SubItems[0]);
    EdtEffectsStartOffSet.Value := StrToInt(lvSafeZoneEffectsCustom.Selected.SubItems[2]);
    EdtEffectsCountOffSet.Value := StrToInt(lvSafeZoneEffectsCustom.Selected.SubItems[3]);
    if StrToInt(lvSafeZoneEffectsCustom.Selected.SubItems[4]) = 1 then
    begin
      chkEffectsBlendDraw.Checked := True;
    end
    else
    begin
      chkEffectsBlendDraw.Checked := False;
    end;
    EdtEffectsSpeed.Value := StrToInt(lvSafeZoneEffectsCustom.Selected.SubItems[5]);
  end;
end;

end.
