unit ImageFileCustomU;

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, Grobal2, Dialogs,sysUtils,strUtils;

type
  TftmImageFileCustom = class(TForm)
    ListBoxImageFileCustom: TListBox;
    BtnAdd: TButton;
    btnDel: TButton;
    btnSave: TButton;
    edtFileName: TEdit;
    btnSelect: TButton;
    dlgOpen: TOpenDialog;
    lbl: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
    { Private declarations }
    procedure setButton();
  public
    procedure Open();
    { Public declarations }
  end;

var
  ftmImageFileCustom: TftmImageFileCustom;

implementation

uses M2Share;

{$R *.dfm}
var bChanged:Boolean;
procedure TFtmImageFileCustom.setButton();
begin
 btnDel.Enabled := (ListBoxImageFileCustom.Count > 0);
 btnSave.Enabled := bChanged;
end;

procedure TftmImageFileCustom.Open;
begin
  ShowModal();
end;


procedure TftmImageFileCustom.btnSaveClick(Sender: TObject);
var
  sFileName: String;
  i: Integer;
begin
  sFileName := g_Config.sEnvirDir + 'ImageFileListCustom.txt';
  ListBoxImageFileCustom.Items.SaveToFile(sFileName);
  g_FileCustomList_Server.Clear;
  for i:= 0 to ListBoxImageFileCustom.Items.Count -1 do
  begin
    g_FileCustomList_Server.Add(ListBoxImageFileCustom.Items[i]);
  end;
  //ShowMessage('文件已经成功保存到'+sFileName);
  bChanged := False;
  setButton;
end;

procedure TftmImageFileCustom.FormCreate(Sender: TObject);
var i:Integer;
begin
  bChanged := False;
  ListBoxImageFileCustom.Clear;
  for i := 0 to g_FileCustomList_Server.count -1 do
  begin
    ListBoxImageFileCustom.Items.Add(g_FileCustomList_Server.Strings[i]);
  end;
  setButton;
end;

procedure TftmImageFileCustom.btnSelectClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    edtFileName.Text := ExtractFileName(dlgOpen.FileName);
  end;
end;

procedure TftmImageFileCustom.BtnAddClick(Sender: TObject);
var i:Integer;
    bFound:boolean;
begin
  if EdtFileName.Text <> '' then
  begin
    bFound := False;
    for i :=0 to ListBoxImageFileCustom.Count -1 do
    begin
      if UpperCase(edtFileName.Text) = UpperCase(ListBoxImageFileCustom.Items[i]) then
      begin
        bFound := True;
        ListBoxImageFileCustom.Selected[i] := True;
        break;
      end;
    end;

    if bFound then
    begin
      ShowMessage('该文件名已经存在文件列表中，不允许重复增加');
      exit;
    end
    else
    begin
      if (rightStr(UpperCase(edtFileName.Text),4) <> '.WZL') and (rightStr(UpperCase(edtFileName.Text),4) <> '.WIL') then
      begin
        ShowMessage('暂只支持WZL或WIL格式的资源文件!');
        exit;
      end;
      bChanged := True;
      ListBoxImageFileCustom.Items.Add(EdtFileName.Text);
    end;
  end;
  setButton;
end;

procedure TftmImageFileCustom.btnDelClick(Sender: TObject);
var i:Integer;
begin
  if ListBoxImageFileCustom.Items.Count = 0 then
  begin
    ShowMessage('请先选中文件列表的内容，再点删除');
    exit;
  end;

  ListBoxImageFileCustom.DeleteSelected;
  bChanged := True;
  setButton;
end;

end.
