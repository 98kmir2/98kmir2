unit uFrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin, IniFiles,MShare,Grobal2;

type
  TFrmLogin = class(TForm)
    grp1: TGroupBox;
    lvServer: TListView;
    lbl1: TLabel;
    edtName: TEdit;
    Label1: TLabel;
    edtAddr: TEdit;
    lbl2: TLabel;
    sePort: TSpinEdit;
    btnAddServer: TButton;
    btnDelServer: TButton;
    chkFullScreen: TCheckBox;
    lbl3: TLabel;
    cbbScreenMode: TComboBox;
    btnRun: TButton;
    btnSave: TButton;
    procedure btnRunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddServerClick(Sender: TObject);
    procedure btnDelServerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveClick(Sender: TObject);
    procedure cbbScreenModeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure EnumDisplayMode(list: TComboBox);
    procedure SetDisplayMode(list: TComboBox);
    procedure saveConfig(bShowMsg: Boolean);

  end;

  function ShowFrmLogin: Boolean;

implementation

var MyIni: TiniFile;
{$R *.dfm}

function ShowFrmLogin: Boolean;
var
  FrmLogin: TFrmLogin;
begin
  FrmLogin := TFrmLogin.Create(nil);
  try
    Result := FrmLogin.ShowModal = mrOk;
  finally
    FrmLogin.Free;
  end;
end;

procedure TFrmLogin.SetDisplayMode(list: TComboBox);
var
  PDM: PDevMode;
begin
  PDM := PDevMode(list.Items.Objects[list.ItemIndex]);
  MyIni.WriteInteger('Config', 'ScreenWidth', PDM.dmPelsWidth);
  MyIni.WriteInteger('Config', 'ScreenHeight', PDM.dmPelsHeight);
end;

procedure TFrmLogin.EnumDisplayMode(list: TComboBox);
var
  i: Integer;
  sTemp: String;
  DevMode: TDevMode;//显示模式
  PDM: PDevMode;
begin
  list.Items.Clear;
  i := 0;
  while EnumDisplaySettingsA(nil, i, DevMode) do
  begin
    with DevMode do begin
      if (dmPelsWidth >= 800) and (dmBitsPerPel >= 24) and (dmPelsWidth <= MAX_SCREEN_PELS_WIDTH) and (dmPelsHeight <= MAX_SCREEN_PELS_HEIGHT) then
      begin
        sTemp := Format('%d X %d', [dmPelsWidth, dmPelsHeight, dmBitsPerPel]);
        if (Pos(sTemp, list.Items.Text) = 0)  then
        begin
          New(PDM);
          PDM^ := DevMode;
          list.Items.AddObject(sTemp, TObject(PDM));
        end;
      end;
    end;
    Inc(i);
  end;
end;

procedure TFrmLogin.btnRunClick(Sender: TObject);
var
  PDM: PDevMode;
begin
  saveConfig(False);
  if lvServer.Selected <> nil then
  begin
    TEST_MODE_SERVER := lvServer.Selected.SubItems[0];
    TEST_MODE_PORT := StrToInt(lvServer.Selected.SubItems[1]);
    g_boFullScreen := chkFullScreen.Checked;
    PDM := PDevMode(cbbScreenMode.Items.Objects[cbbScreenMode.ItemIndex]);
    SCREENWIDTH := PDM.dmPelsWidth;
    SCREENHEIGHT := PDM.dmPelsHeight;
    g_Windowed :=  not chkFullScreen.Checked;
  end
  else
  begin
    ShowMessage('请选择一条服务器记录，才能进入游戏');
    exit;
  end;
  ModalResult := mrOK;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
var
  sTemp: String;
  i: Integer;
  iServerCount: Integer;
  TItem: TListItem;
begin
  iServerCount := 0;

  Try
    MyIni := TIniFile.Create(ExtractFilePath(Application.ExeName)+'98K_TestMode.ini');
  except
    MyIni.Free;
    MyIni := Nil;
  end;

  EnumDisplayMode(cbbScreenMode);  
  chkFullScreen.Checked := MyIni.ReadBool('Config', 'FullScreenMode', False);
  sTemp := Format('%d X %d', [MyIni.ReadInteger('Config','ScreenWidth',800), MyIni.ReadInteger('Config','ScreenHeight',600)]);
  for i := 0 to cbbScreenMode.Items.Count -1 do
  begin
    if cbbScreenMode.Items[i] = sTemp then
    begin
       cbbScreenMode.ItemIndex := i;
       Break;
    end;
  end;
  SetDisplayMode(cbbScreenMode); 

  iServerCount := MyIni.ReadInteger('Config', 'ServerCount', 0);

  for i := 0 to iServerCount - 1 do
  begin
    TItem := lvServer.Items.Add;
    TItem.Caption := MyIni.ReadString('Server'+IntToStr(i), 'Name','');
    TItem.SubItems.Add(MyIni.ReadString('Server'+IntToStr(i), 'Address',''));
    TItem.SubItems.Add(MyIni.ReadString('Server'+IntToStr(i), 'Port',''));
  end;
end;

procedure TFrmLogin.btnAddServerClick(Sender: TObject);
 var TItem: TListItem;
begin
  TItem := lvServer.Items.Add;
  TItem.Caption := edtName.Text;
  TItem.SubItems.Add(edtAddr.Text);
  TItem.SubItems.Add(sePort.Text);
end;

procedure TFrmLogin.btnDelServerClick(Sender: TObject);
begin
  if lvServer.Items.Count > 0 then lvServer.DeleteSelected;
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if MyIni <> nil then MyIni.Free;
end;

procedure TFrmLogin.saveConfig(bShowMsg: Boolean);
var
  I: Integer;
begin
  MyIni.WriteBool('Config', 'FullScreenMode', chkFullScreen.Checked);
  //写服务器列表
  for I := 0 to lvServer.Items.Count - 1 do
  begin
     MyIni.writeString('Server'+IntToStr(I), 'Name', lvServer.Items[I].Caption);
     MyIni.writeString('Server'+IntToStr(I), 'Address', lvServer.Items[I].SubItems[0]);
     MyIni.writeInteger('Server'+IntToStr(I), 'Port', StrtoInt(lvServer.Items[I].SubItems[1]));
  end;
  MyIni.WriteInteger('Config','ServerCount',lvServer.Items.Count);
  if bShowMsg then ShowMessage('保存完成,' + ExtractFilePath(Application.ExeName) + '98K_TestMode.ini');
end;

procedure TFrmLogin.btnSaveClick(Sender: TObject);
begin
  saveConfig(True);
end;

procedure TFrmLogin.cbbScreenModeChange(Sender: TObject);
begin
  SetDisplayMode(cbbScreenMode);
end;

end.
