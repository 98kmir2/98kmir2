unit RouteManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmRouteManage = class(TForm)
    GroupBox1: TGroupBox;
    ListViewRoute: TListView;
    ButtonEdit: TButton;
    ButtonDelete: TButton;
    ButtonOK: TButton;
    ButtonAddRoute: TButton;
    Label1: TLabel;
    procedure ButtonDeleteClick(Sender: TObject);
  private
    procedure RefShowRoute();
    procedure ProcessListViewDelete();
    procedure ProcessListViewSelect();
    procedure ProcessAddRoute();
    procedure ProcessEditRoute();
    { Private declarations }
  public
    procedure Open;
    procedure SaveRoute();
    { Public declarations }
  end;

var
  frmRouteManage: TfrmRouteManage;

implementation

uses DBShare, RouteEdit, DBSMain, Grobal2;

{$R *.dfm}

{ TfrmRouteManage }

procedure TfrmRouteManage.Open;
begin
  RefShowRoute();
  ShowModal;
end;

procedure TfrmRouteManage.RefShowRoute;
var
  i, ii: Integer;
  ListItem: TListItem;
  RouteInfo: pTRouteInfo;
  sGameGate: string;
begin
  ListViewRoute.Clear;
  ButtonEdit.Enabled := False;
  ButtonDelete.Enabled := False;
  for i := Low(g_RouteInfo) to High(g_RouteInfo) do
  begin
    RouteInfo := @g_RouteInfo[i];
    if RouteInfo.nGateCount = 0 then
      Break;
    sGameGate := '';
    ListItem := ListViewRoute.Items.Add;
    ListItem.Data := RouteInfo;
    ListItem.Caption := IntToStr(RouteInfo.nServerIdx);
    ListItem.SubItems.Add(RouteInfo.sSelGateIP);
    ListItem.SubItems.Add(IntToStr(RouteInfo.nGateCount));
    for ii := 0 to RouteInfo.nGateCount - 1 do
      sGameGate := Format('%s %s:%d ', [sGameGate, RouteInfo.sGameGateIP[ii], RouteInfo.nGameGatePort[ii]]);
    ListItem.SubItems.Add(sGameGate);
  end;
end;

procedure TfrmRouteManage.ButtonDeleteClick(Sender: TObject);
begin
  if Sender = ButtonDelete then
    ProcessListViewDelete()
  else if Sender = ListViewRoute then
    ProcessListViewSelect()
  else if Sender = ButtonAddRoute then
    ProcessAddRoute()
  else if Sender = ButtonEdit then
    ProcessEditRoute()
  else if Sender = ButtonOK then
  begin
    SaveRoute();
    FrmDBSrv.BtnReloadAddrClick(Sender);
  end;
end;

procedure TfrmRouteManage.ProcessListViewSelect;
var
  ListItem: TListItem;
begin
  ListItem := ListViewRoute.Selected;
  if ListItem = nil then
    Exit;
  ButtonEdit.Enabled := True;
  ButtonDelete.Enabled := True;
end;

procedure TfrmRouteManage.ProcessListViewDelete;
var
  ii: Integer;
  ListItem: TListItem;
  RouteInfo: pTRouteInfo;
begin
  ListItem := ListViewRoute.Selected;
  if ListItem = nil then
    Exit;
  RouteInfo := ListItem.Data;
  RouteInfo.nGateCount := 0;
  RouteInfo.sSelGateIP := '';

  for ii := Low(RouteInfo.sGameGateIP) to High(RouteInfo.sGameGateIP) do
  begin
    RouteInfo.sGameGateIP[ii] := '';
    RouteInfo.nGameGatePort[ii] := 0;
  end;
  RefShowRoute();

end;

procedure TfrmRouteManage.ProcessAddRoute;
var
  RouteInfo: pTRouteInfo;
  nNulIdx: Integer;
  AddRoute: TRouteInfo;
begin
  nNulIdx := ListViewRoute.Items.Count;
  if nNulIdx >= 20 then
  begin
    MessageBox(Handle, '路由条数已经达到指定数量,不能再增加路由。', '提示信息', MB_OK + MB_IconInformation);
    Exit;
  end;
  RouteInfo := @g_RouteInfo[nNulIdx];
  frmRouteEdit.m_RouteInfo := RouteInfo^;
  frmRouteEdit.Caption := '增加网关路由';
  AddRoute := frmRouteEdit.Open;
  if AddRoute.nGateCount >= 1 then
    RouteInfo^ := AddRoute;
  RefShowRoute();
end;

procedure TfrmRouteManage.ProcessEditRoute;
var
  ListItem: TListItem;
  RouteInfo: pTRouteInfo;
  EditRoute: TRouteInfo;
begin
  ListItem := ListViewRoute.Selected;
  if ListItem = nil then
    Exit;
  RouteInfo := ListItem.Data;
  frmRouteEdit.m_RouteInfo := RouteInfo^;
  frmRouteEdit.Caption := '编辑网关路由';
  EditRoute := frmRouteEdit.Open;
  if EditRoute.nGateCount >= 1 then
    RouteInfo^ := EditRoute;
  RefShowRoute();
end;

procedure TfrmRouteManage.SaveRoute;
var
  i, ii: Integer;
  LoadList: TStringList;
  RouteInfo: pTRouteInfo;
  Str: string;
begin
  //MainOutMessage('正在加载网关设置...');
  LoadList := nil;
  try

    LoadList := TStringList.Create;
    for i := Low(g_RouteInfo) to High(g_RouteInfo) do
    begin
      RouteInfo := @g_RouteInfo[i];
      if RouteInfo.nGateCount = 0 then
        Break;
      Str := IntToStr(RouteInfo.nServerIdx) + ' ' + RouteInfo.sSelGateIP;
      for ii := 0 to RouteInfo.nGateCount - 1 do
        Str := Str + '  ' + RouteInfo.sGameGateIP[ii] + '  ' + IntToStr(RouteInfo.nGameGatePort[ii]);
      LoadList.Add(Trim(Str));
    end;
    LoadList.SaveToFile(sGateConfFileName);
  finally
    LoadList.Free;
    Close;
    MainOutMessage('网关路由设置保存完成...');
  end;
end;

end.
