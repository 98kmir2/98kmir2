unit frmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, RzPanel, RzDlgBtn, ComCtrls;

type
  TfrmSetup = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label7: TLabel;
    ListBoxFilterText: TListBox;
    ButtonAdd: TButton;
    ButtonMod: TButton;
    ButtonDel: TButton;
    CheckBoxAllowGetBackDelChr: TCheckBox;
    CheckBoxgUseSpecChar: TCheckBox;
    CheckBoxAllowClientDelChr: TCheckBox;
    SpinEditAllowDelChrLvl: TSpinEdit;
    Label1: TLabel;
    CheckBoxAllowCreateCharOpt1: TCheckBox;
    CheckBoxOpenHRSystem: TCheckBox;
    CheckBoxMultiChr: TCheckBox;
    seRenewLRTime: TSpinEdit;
    speRankLevel: TSpinEdit;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    cbGetChrAsHero: TCheckBox;
    cbGetDelChrAsHero: TCheckBox;
    btnGSave: TButton;
    cbGetAllHeros: TCheckBox;
    cbMutiHero: TCheckBox;
    TabSheet4: TTabSheet;
    cbCloseSelGate: TCheckBox;
    seCloseSelGateTime: TSpinEdit;
    seLvMax: TSpinEdit;
    procedure SpinEditAllowDelChrLvlChange(Sender: TObject);
    procedure CheckBoxAllowGetBackDelChrClick(Sender: TObject);
    procedure CheckBoxAllowClientDelChrClick(Sender: TObject);
    procedure CheckBoxgUseSpecCharClick(Sender: TObject);
    procedure btnGSaveClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonModClick(Sender: TObject);
    procedure ListBoxFilterTextClick(Sender: TObject);
    procedure ListBoxFilterTextDblClick(Sender: TObject);
    procedure CheckBoxAllowCreateCharOpt1Click(Sender: TObject);
    procedure seRenewLRTimeChange(Sender: TObject);
    procedure CheckBoxOpenHRSystemClick(Sender: TObject);
    procedure seLvMaxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure MobValue;
    procedure UnMobValue;
    procedure Open;
  end;

var
  frmSetup: TfrmSetup;
implementation

uses DBShare;

{$R *.dfm}

procedure TfrmSetup.Open;
begin
  PageControl1.ActivePageIndex := 0;
  UnMobValue;
  ShowModal;
end;

procedure TfrmSetup.MobValue;
begin
  btnGSave.Enabled := True;
end;

procedure TfrmSetup.UnMobValue;
begin
  btnGSave.Enabled := False;
end;

procedure TfrmSetup.SpinEditAllowDelChrLvlChange(Sender: TObject);
begin
  if not  btnGSave.Enabled then btnGSave.Enabled := True;
  g_nAllowDelChrLvl := SpinEditAllowDelChrLvl.Value;
  if g_nAllowDelChrLvl > High(Word) then
  begin
    g_nAllowDelChrLvl := High(Word);
    SpinEditAllowDelChrLvl.Value := g_nAllowDelChrLvl;
  end;
  {
  if g_nAllowDelChrLvl < 1 then
  begin
    g_nAllowDelChrLvl := 1;
    SpinEditAllowDelChrLvl.Value := g_nAllowDelChrLvl;
  end;
  }
  MobValue();
end;

procedure TfrmSetup.CheckBoxAllowGetBackDelChrClick(Sender: TObject);
begin
  if Sender = CheckBoxAllowGetBackDelChr then
    g_boAllowGetBackDelChr := CheckBoxAllowGetBackDelChr.Checked
  else if Sender = cbGetChrAsHero then
    g_boGetChrAsHero := cbGetChrAsHero.Checked
  else if Sender = cbGetDelChrAsHero then
    g_boGetDelChrAsHero := cbGetDelChrAsHero.Checked
  else if Sender = cbGetAllHeros then
    g_cbGetAllHeros := cbGetAllHeros.Checked
  else if Sender = cbMutiHero then
    g_fMutiHero := cbMutiHero.Checked;

  MobValue();
end;

procedure TfrmSetup.CheckBoxAllowClientDelChrClick(Sender: TObject);
begin
  if CheckBoxMultiChr = Sender then
  begin
    g_boAllowMultiChr := CheckBoxMultiChr.Checked;
  end
  else
  begin
    g_boAllowDelChr := CheckBoxAllowClientDelChr.Checked;
    SpinEditAllowDelChrLvl.Enabled := g_boAllowDelChr;
  end;
  MobValue();
end;

procedure TfrmSetup.CheckBoxgUseSpecCharClick(Sender: TObject);
begin
  g_boUseSpecChar := CheckBoxgUseSpecChar.Checked;
  MobValue();
end;

procedure TfrmSetup.btnGSaveClick(Sender: TObject);
var
  i: Integer;
begin
  if g_Conf <> nil then
  begin
    g_Conf.WriteInteger('Setup', 'AllowDelChrLvl', g_nAllowDelChrLvl);
    g_Conf.WriteInteger('Setup', 'AllowMaxDelChrLvl', g_nAllowMaxDelChrLvl);
    g_Conf.WriteInteger('Setup', 'RankLevelMin', g_dwRankLevelMin);
    g_Conf.WriteInteger('Setup', 'CloseSelGateTime', g_nCloseSelGateTime);

    g_Conf.WriteInteger('Setup', 'ReInitLvRankTime', g_dwRenewLevelRankTime);
    g_Conf.WriteBool('Setup', 'AllowGetBackDelChr', g_boAllowGetBackDelChr);
    g_Conf.WriteBool('Setup', 'AllowDelChr', g_boAllowDelChr);
    g_Conf.WriteBool('Setup', 'AllowMultiChr', g_boAllowMultiChr);
    g_Conf.WriteBool('Setup', 'UseSpecChar', g_boUseSpecChar);
    g_Conf.WriteBool('Setup', 'AllowCreateCharOpt1', g_boAllowCreateCharOpt1);
    g_Conf.WriteBool('Setup', 'OpenLevelRankSys', g_boOpenHRSystem);
    g_Conf.WriteBool('Setup', 'CloseSelGate', g_boCloseSelGate);

    DenyChrOfNameList.Clear;
    for i := 0 to ListBoxFilterText.Items.Count - 1 do
      DenyChrOfNameList.Add(ListBoxFilterText.Items.Strings[i]);
    DenyChrOfNameList.SaveToFile('DenyChrOfName.txt');

    g_Conf.WriteBool('Setup', 'GetChrAsHero', g_boGetChrAsHero);
    g_Conf.WriteBool('Setup', 'GetDelChrAsHero', g_boGetDelChrAsHero);
    g_Conf.WriteBool('Setup', 'GetAllHeros', g_cbGetAllHeros);
    g_Conf.WriteBool('Setup', 'MutiHero', g_fMutiHero);

    UnMobValue();
  end;
end;

procedure TfrmSetup.ButtonAddClick(Sender: TObject);
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
  ListBoxFilterText.Items.Add(sInputText);
  MobValue();
end;

procedure TfrmSetup.ButtonDelClick(Sender: TObject);
var
  nSelectIndex: Integer;
begin
  nSelectIndex := ListBoxFilterText.ItemIndex;
  if (nSelectIndex >= 0) and (nSelectIndex < ListBoxFilterText.Items.Count) then
  begin
    ListBoxFilterText.Items.Delete(nSelectIndex);
    MobValue();
  end;
  if nSelectIndex >= ListBoxFilterText.Items.Count then
    ListBoxFilterText.ItemIndex := nSelectIndex - 1
  else
    ListBoxFilterText.ItemIndex := nSelectIndex;
  if ListBoxFilterText.ItemIndex < 0 then
  begin
    ButtonDel.Enabled := False;
    ButtonMod.Enabled := False;
  end;
end;

procedure TfrmSetup.ButtonModClick(Sender: TObject);
var
  sInputText: string;
begin
  if (ListBoxFilterText.ItemIndex >= 0) and (ListBoxFilterText.ItemIndex <
    ListBoxFilterText.Items.Count) then
  begin
    sInputText := ListBoxFilterText.Items[ListBoxFilterText.ItemIndex];
    if not InputQuery('增加过滤文字', '请输入新的文字:', sInputText) then
      Exit;
  end;
  if sInputText = '' then
  begin
    Application.MessageBox('输入的字符不能为空！', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  ListBoxFilterText.Items[ListBoxFilterText.ItemIndex] := sInputText;
  MobValue();
end;

procedure TfrmSetup.ListBoxFilterTextClick(Sender: TObject);
begin
  if (ListBoxFilterText.ItemIndex >= 0) and (ListBoxFilterText.ItemIndex < ListBoxFilterText.Items.Count) then
  begin
    ButtonDel.Enabled := True;
    ButtonMod.Enabled := True;
  end;
end;

procedure TfrmSetup.ListBoxFilterTextDblClick(Sender: TObject);
begin
  ButtonModClick(Sender);
end;

procedure TfrmSetup.CheckBoxAllowCreateCharOpt1Click(Sender: TObject);
begin
  g_boAllowCreateCharOpt1 := CheckBoxAllowCreateCharOpt1.Checked;
  MobValue();
end;

procedure TfrmSetup.seRenewLRTimeChange(Sender: TObject);
begin
  if Sender = speRankLevel then
    g_dwRankLevelMin := frmSetup.speRankLevel.Value
  else if Sender = seCloseSelGateTime then
    g_nCloseSelGateTime := seCloseSelGateTime.Value
  else
    g_dwRenewLevelRankTime := frmSetup.seRenewLRTime.Value;
  MobValue();
end;

procedure TfrmSetup.CheckBoxOpenHRSystemClick(Sender: TObject);
begin
  if cbCloseSelGate = Sender then
    g_boCloseSelGate := cbCloseSelGate.Checked
  else
    g_boOpenHRSystem := CheckBoxOpenHRSystem.Checked;
  MobValue();
end;

procedure TfrmSetup.seLvMaxChange(Sender: TObject);
begin
  try
    if not  btnGSave.Enabled then btnGSave.Enabled := True; 
    g_nAllOwMaxDelChrLvl := seLvMax.Value;
  Except
  end
end;

end.
