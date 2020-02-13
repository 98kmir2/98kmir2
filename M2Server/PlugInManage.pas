unit PlugInManage;

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, Grobal2;

type
  TftmPlugInManage = class(TForm)
    ListBoxPlugin: TListBox;
    ButtonPluginConfig: TButton;
    btnUnLoad: TButton;
    btnClose: TButton;
    procedure ListBoxPluginDblClick(Sender: TObject);
    procedure ButtonPluginConfigClick(Sender: TObject);
    procedure ListBoxPluginClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    function CheckPluginConfig(): TPlugConfig;
    procedure RefPlugin();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  ftmPlugInManage: TftmPlugInManage;

implementation

uses M2Share;

{$R *.dfm}

function TftmPlugInManage.CheckPluginConfig(): TPlugConfig;
var
  PlugInfo: pTPlugInfo;
resourcestring
  sConfig = 'Config';
begin
  Result := nil;
  if (ListBoxPlugin.ItemIndex >= 0) and (ListBoxPlugin.ItemIndex < ListBoxPlugin.Items.Count) then
  begin
    PlugInfo := pTPlugInfo(ListBoxPlugin.Items.Objects[ListBoxPlugin.ItemIndex]);
    Result := GetProcAddress(PlugInfo.Module, PChar(sConfig));
  end;
end;

procedure TftmPlugInManage.Open;
begin
  RefPlugin();
  ShowModal();
end;

procedure TftmPlugInManage.RefPlugin;
var
  i: Integer;
begin
  ListBoxPlugin.Clear;
  for i := 0 to PlugInEngine.PlugList.Count - 1 do
    ListBoxPlugin.Items.AddObject(PlugInEngine.PlugList.Strings[i], PlugInEngine.PlugList.Objects[i]);
end;

procedure TftmPlugInManage.ListBoxPluginDblClick(Sender: TObject);
begin
  ButtonPluginConfigClick(Sender);
end;

procedure TftmPlugInManage.ButtonPluginConfigClick(Sender: TObject);
resourcestring
  sNoConfigMsg = '该插件没有配置信息！';
  sInformation = '提示信息';
var
  PFunc: TPlugConfig;
begin
  PFunc := CheckPluginConfig();
  if @PFunc <> nil then
    PFunc()
  else
    Application.MessageBox(PChar(sNoConfigMsg), PChar(sInformation), MB_ICONINFORMATION + MB_OK);
end;

procedure TftmPlugInManage.ListBoxPluginClick(Sender: TObject);
var
  PFunc: TPlugConfig;
begin
  PFunc := CheckPluginConfig();
  ButtonPluginConfig.Enabled := (@PFunc <> nil);
end;

procedure TftmPlugInManage.btnCloseClick(Sender: TObject);
begin
  Close();
end;

end.
