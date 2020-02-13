unit RouteEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBShare, StdCtrls, Grobal2;
type
  TfrmRouteEdit = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditSelGate: TEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    EditGateIPaddr1: TEdit;
    EditGateIPaddr2: TEdit;
    Label3: TLabel;
    EditGatePort1: TEdit;
    EditGatePort2: TEdit;
    Label4: TLabel;
    EditGateIPaddr3: TEdit;
    EditGatePort3: TEdit;
    Label5: TLabel;
    EditGateIPaddr4: TEdit;
    EditGatePort4: TEdit;
    Label6: TLabel;
    EditGateIPaddr5: TEdit;
    EditGatePort5: TEdit;
    Label7: TLabel;
    EditGateIPaddr6: TEdit;
    EditGatePort6: TEdit;
    Label8: TLabel;
    EditGateIPaddr7: TEdit;
    EditGatePort7: TEdit;
    Label9: TLabel;
    EditGateIPaddr8: TEdit;
    EditGatePort8: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Label10: TLabel;
    EditServerIdx: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    procedure ButtonOKClick(Sender: TObject);
  private
    m_EditOK: Boolean;
    procedure RefShowRoute();
    function ProcessRouteOK(): Boolean;
    { Private declarations }
  public
    m_RouteInfo: TRouteInfo;
    function Open(): TRouteInfo;
    { Public declarations }
  end;

var
  frmRouteEdit: TfrmRouteEdit;

implementation

uses HUtil32;

{$R *.dfm}

{ TfrmRouteEdit }

function TfrmRouteEdit.Open(): TRouteInfo;
begin
  m_EditOK := False;
  RefShowRoute();
  ShowModal;
  if m_EditOK then
    Result := m_RouteInfo
  else
    Result.nGateCount := -1;
end;

procedure TfrmRouteEdit.RefShowRoute;
begin
  EditServerIdx.Text := IntToStr(m_RouteInfo.nServerIdx);

  EditSelGate.Text := m_RouteInfo.sSelGateIP;

  EditGateIPaddr1.Text := m_RouteInfo.sGameGateIP[0];
  EditGatePort1.Text := IntToStr(m_RouteInfo.nGameGatePort[0]);

  EditGateIPaddr2.Text := m_RouteInfo.sGameGateIP[1];
  EditGatePort2.Text := IntToStr(m_RouteInfo.nGameGatePort[1]);

  EditGateIPaddr3.Text := m_RouteInfo.sGameGateIP[2];
  EditGatePort3.Text := IntToStr(m_RouteInfo.nGameGatePort[2]);

  EditGateIPaddr4.Text := m_RouteInfo.sGameGateIP[3];
  EditGatePort4.Text := IntToStr(m_RouteInfo.nGameGatePort[3]);

  EditGateIPaddr5.Text := m_RouteInfo.sGameGateIP[4];
  EditGatePort5.Text := IntToStr(m_RouteInfo.nGameGatePort[4]);

  EditGateIPaddr6.Text := m_RouteInfo.sGameGateIP[5];
  EditGatePort6.Text := IntToStr(m_RouteInfo.nGameGatePort[5]);

  EditGateIPaddr7.Text := m_RouteInfo.sGameGateIP[6];
  EditGatePort7.Text := IntToStr(m_RouteInfo.nGameGatePort[6]);

  EditGateIPaddr8.Text := m_RouteInfo.sGameGateIP[7];
  EditGatePort8.Text := IntToStr(m_RouteInfo.nGameGatePort[7]);
end;

procedure TfrmRouteEdit.ButtonOKClick(Sender: TObject);
begin
  if Sender = ButtonOK then
  begin
    if ProcessRouteOK() then
    begin
      m_EditOK := True;
      Close;
    end;
  end
  else if Sender = ButtonCancel then
    Close();
end;

function TfrmRouteEdit.ProcessRouteOK(): Boolean;
var
  sGameGateIP: string;
  nGameGatePort: Integer;
begin
  Result := False;
  FillChar(m_RouteInfo, SizeOf(m_RouteInfo), #0);

  m_RouteInfo.nServerIdx := Str_ToInt(EditServerIdx.Text, 0);

  m_RouteInfo.sSelGateIP := Trim(EditSelGate.Text);
  if not IsIPaddr(m_RouteInfo.sSelGateIP) then
  begin
    MessageBox(Handle, '角色网关输入错误。', '错误信息', MB_OK + MB_ICONERROR);
    EditSelGate.SetFocus;
    Exit;
  end;
  sGameGateIP := Trim(EditGateIPaddr1.Text);
  nGameGatePort := Str_ToInt(EditGatePort1.Text, 0);

  if not IsIPaddr(sGameGateIP) then
  begin
    MessageBox(Handle, '游戏网关一输入错误。', '错误信息', MB_OK + MB_ICONERROR);
    EditGateIPaddr1.SetFocus;
    Exit;
  end;
  if nGameGatePort <= 0 then
  begin
    MessageBox(Handle, '游戏网关一输入错误。', '错误信息', MB_OK + MB_ICONERROR);
    EditGatePort1.SetFocus;
    Exit;
  end;
  m_RouteInfo.sGameGateIP[0] := sGameGateIP;
  m_RouteInfo.nGameGatePort[0] := nGameGatePort;
  m_RouteInfo.nGateCount := 1;
  Result := True;
  sGameGateIP := Trim(EditGateIPaddr2.Text);
  nGameGatePort := Str_ToInt(EditGatePort2.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[1] := sGameGateIP;
  m_RouteInfo.nGameGatePort[1] := nGameGatePort;
  m_RouteInfo.nGateCount := 2;

  sGameGateIP := Trim(EditGateIPaddr3.Text);
  nGameGatePort := Str_ToInt(EditGatePort3.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[2] := sGameGateIP;
  m_RouteInfo.nGameGatePort[2] := nGameGatePort;
  m_RouteInfo.nGateCount := 3;

  sGameGateIP := Trim(EditGateIPaddr4.Text);
  nGameGatePort := Str_ToInt(EditGatePort4.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[3] := sGameGateIP;
  m_RouteInfo.nGameGatePort[3] := nGameGatePort;
  m_RouteInfo.nGateCount := 4;

  sGameGateIP := Trim(EditGateIPaddr5.Text);
  nGameGatePort := Str_ToInt(EditGatePort5.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[4] := sGameGateIP;
  m_RouteInfo.nGameGatePort[4] := nGameGatePort;
  m_RouteInfo.nGateCount := 5;

  sGameGateIP := Trim(EditGateIPaddr6.Text);
  nGameGatePort := Str_ToInt(EditGatePort6.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[5] := sGameGateIP;
  m_RouteInfo.nGameGatePort[5] := nGameGatePort;
  m_RouteInfo.nGateCount := 6;

  sGameGateIP := Trim(EditGateIPaddr7.Text);
  nGameGatePort := Str_ToInt(EditGatePort7.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[6] := sGameGateIP;
  m_RouteInfo.nGameGatePort[6] := nGameGatePort;
  m_RouteInfo.nGateCount := 7;

  sGameGateIP := Trim(EditGateIPaddr8.Text);
  nGameGatePort := Str_ToInt(EditGatePort8.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[7] := sGameGateIP;
  m_RouteInfo.nGameGatePort[7] := nGameGatePort;
  m_RouteInfo.nGateCount := 8;

  sGameGateIP := Trim(Edit1.Text);
  nGameGatePort := Str_ToInt(Edit2.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[8] := sGameGateIP;
  m_RouteInfo.nGameGatePort[8] := nGameGatePort;
  m_RouteInfo.nGateCount := 9;

  sGameGateIP := Trim(Edit3.Text);
  nGameGatePort := Str_ToInt(Edit4.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[9] := sGameGateIP;
  m_RouteInfo.nGameGatePort[9] := nGameGatePort;
  m_RouteInfo.nGateCount := 10;

  sGameGateIP := Trim(Edit5.Text);
  nGameGatePort := Str_ToInt(Edit6.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[10] := sGameGateIP;
  m_RouteInfo.nGameGatePort[10] := nGameGatePort;
  m_RouteInfo.nGateCount := 11;

  sGameGateIP := Trim(Edit7.Text);
  nGameGatePort := Str_ToInt(Edit8.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[11] := sGameGateIP;
  m_RouteInfo.nGameGatePort[11] := nGameGatePort;
  m_RouteInfo.nGateCount := 12;

  sGameGateIP := Trim(Edit8.Text);
  nGameGatePort := Str_ToInt(Edit9.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[12] := sGameGateIP;
  m_RouteInfo.nGameGatePort[12] := nGameGatePort;
  m_RouteInfo.nGateCount := 13;

  sGameGateIP := Trim(Edit10.Text);
  nGameGatePort := Str_ToInt(Edit11.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[12] := sGameGateIP;
  m_RouteInfo.nGameGatePort[12] := nGameGatePort;
  m_RouteInfo.nGateCount := 13;

  sGameGateIP := Trim(Edit11.Text);
  nGameGatePort := Str_ToInt(Edit12.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[13] := sGameGateIP;
  m_RouteInfo.nGameGatePort[13] := nGameGatePort;
  m_RouteInfo.nGateCount := 14;

  sGameGateIP := Trim(Edit13.Text);
  nGameGatePort := Str_ToInt(Edit14.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[14] := sGameGateIP;
  m_RouteInfo.nGameGatePort[14] := nGameGatePort;
  m_RouteInfo.nGateCount := 15;

  sGameGateIP := Trim(Edit15.Text);
  nGameGatePort := Str_ToInt(Edit16.Text, 0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then
    Exit;
  m_RouteInfo.sGameGateIP[15] := sGameGateIP;
  m_RouteInfo.nGameGatePort[15] := nGameGatePort;
  m_RouteInfo.nGateCount := 16;
end;

end.
