unit GateSet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons;
type
  TFrmGateSetting = class(TForm)
    BtnOk: TBitBtn;
    BtnClose: TBitBtn;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    CkGate1: TCheckBox;
    EdGate1: TEdit;
    CkGate2: TCheckBox;
    EdGate2: TEdit;
    CkGate3: TCheckBox;
    EdGate3: TEdit;
    CkGate4: TCheckBox;
    EdGate4: TEdit;
    CkGate5: TCheckBox;
    EdGate5: TEdit;
    CkGate6: TCheckBox;
    EdGate6: TEdit;
    CkGate7: TCheckBox;
    EdGate7: TEdit;
    CkGate8: TCheckBox;
    EdGate8: TEdit;
    CkGate9: TCheckBox;
    EdGate9: TEdit;
    CkGate10: TCheckBox;
    EdGate10: TEdit;
    GroupBox2: TGroupBox;
    EdPublicAddr: TEdit;
    Label4: TLabel;
    Label3: TLabel;
    EdPrivateAddr: TEdit;
    GroupBox3: TGroupBox;
    CbGateList: TComboBox;
    Label2: TLabel;
    Label1: TLabel;
    CbServerList: TComboBox;
    EdTitle: TEdit;
    BtnChangeTitle: TSpeedButton;
    Label19: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CbGateListChange(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnChangeTitleClick(Sender: TObject);
    procedure CbServerListChange(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
  private
    EdGate: array[0..9] of TEdit;
    CkGate: array[0..9] of TCheckBox;
    procedure RefRouteList();
    { Private declarations }
  public
    function Open(): Boolean;
    { Public declarations }
  end;

var
  FrmGateSetting: TFrmGateSetting;

implementation

uses LSShare, HUtil32;

{$R *.DFM}

procedure TFrmGateSetting.FormCreate(Sender: TObject);
begin
  EdGate[0] := EdGate1;
  EdGate[1] := EdGate2;
  EdGate[2] := EdGate3;
  EdGate[3] := EdGate4;
  EdGate[4] := EdGate5;
  EdGate[5] := EdGate6;
  EdGate[6] := EdGate7;
  EdGate[7] := EdGate8;
  EdGate[8] := EdGate9;
  EdGate[9] := EdGate10;
  CkGate[0] := CkGate1;
  CkGate[1] := CkGate2;
  CkGate[2] := CkGate3;
  CkGate[3] := CkGate4;
  CkGate[4] := CkGate5;
  CkGate[5] := CkGate6;
  CkGate[6] := CkGate7;
  CkGate[7] := CkGate8;
  CkGate[8] := CkGate9;
  CkGate[9] := CkGate10;
end;

procedure TFrmGateSetting.CbGateListChange(Sender: TObject);
var
  I: Integer;
  nGateIdx: Integer;
  nSelTitlIdx: Integer;
  nSelRouteIdx: Integer;
  nSelServerIdx: Integer;
  sTitle: string;
  sServerName: string;
  Config: pTConfig;
begin
  Config := @g_Config;
  nSelServerIdx := CbServerList.ItemIndex;
  if nSelServerIdx < 0 then
    Exit;
  sServerName := CbServerList.Items.Strings[nSelServerIdx];
  nSelTitlIdx := CbGateList.ItemIndex;
  if nSelTitlIdx < 0 then
    Exit;
  sTitle := CbGateList.Items.Strings[nSelTitlIdx];
  EdTitle.Text := sTitle;
  nSelRouteIdx := -1;
  for I := Low(Config.GateRoute) to High(Config.GateRoute) do
  begin
    if Config.GateRoute[I].sTitle = sTitle then
    begin
      nSelRouteIdx := I;
      Break;
    end;
  end;
  if nSelRouteIdx < 0 then
    Exit;

  EdPrivateAddr.Text := Config.GateRoute[nSelRouteIdx].sRemoteAddr;
  EdPublicAddr.Text := Config.GateRoute[nSelRouteIdx].sPublicAddr;
  nGateIdx := 0;
  while (true) do
  begin
    if Config.GateRoute[nSelRouteIdx].Gate[nGateIdx].sIPaddr <> '' then
    begin
      EdGate[nGateIdx].Text := Config.GateRoute[nSelRouteIdx].Gate[nGateIdx].sIPaddr + ':' + IntToStr(Config.GateRoute[nSelRouteIdx].Gate[nGateIdx].nPort);
    end
    else
      EdGate[nGateIdx].Text := '';
    CkGate[nGateIdx].Checked := Config.GateRoute[nSelRouteIdx].Gate[nGateIdx].boEnable;
    Inc(nGateIdx);
    if nGateIdx >= 10 then
      Break;
  end;
end;

procedure TFrmGateSetting.BtnOkClick(Sender: TObject);
var
  nGateIdx: Integer;
  nTitleIdx: Integer;
  nRouteIdx: Integer;
  sTitle: string;
  sIPaddr: string;
  sPort: string;
  sGateAddr: string;
  Config: pTConfig;
begin
  Config := @g_Config;
  nTitleIdx := CbGateList.ItemIndex;
  if nTitleIdx < 0 then
    Exit;
  nGateIdx := 0;
  while (true) do
  begin
    sGateAddr := Trim(EdGate[nGateIdx].Text);
    if sGateAddr <> '' then
    begin
      sPort := GetValidStr3(sGateAddr, sIPaddr, [':']);
    end;
    if (sIPaddr = '') or (Str_ToInt(sPort, 0) = 0) then
    begin
      Beep;
      Exit;
    end;
    Inc(nGateIdx);
    if nGateIdx >= 10 then
      Break;
  end;
  sTitle := CbGateList.Items.Strings[nTitleIdx];
  nRouteIdx := -1;
  nGateIdx := 0;
  while (true) do
  begin
    if Config.GateRoute[nGateIdx].sTitle = sTitle then
    begin
      nRouteIdx := nGateIdx;
      Break;
    end;
    Inc(nGateIdx);
    if nGateIdx >= 59 then
      Break;
  end;
  if nRouteIdx < 0 then
    Exit;
  Config.GateRoute[nRouteIdx].sRemoteAddr := EdPrivateAddr.Text;
  Config.GateRoute[nRouteIdx].sPublicAddr := EdPublicAddr.Text;
  nGateIdx := 0;
  while (true) do
  begin
    sPort := GetValidStr3(Trim(EdGate[nGateIdx].Text), sIPaddr, [':']);
    if sIPaddr <> '' then
    begin
      Config.GateRoute[nRouteIdx].Gate[nGateIdx].sIPaddr := sIPaddr;
      Config.GateRoute[nRouteIdx].Gate[nGateIdx].nPort := Str_ToInt(sPort, 0);
      Config.GateRoute[nRouteIdx].Gate[nGateIdx].boEnable := CkGate[nGateIdx].Checked;
    end
    else
    begin
      Config.GateRoute[nRouteIdx].Gate[nGateIdx].sIPaddr := '';
      Config.GateRoute[nRouteIdx].Gate[nGateIdx].nPort := 0;
      Config.GateRoute[nRouteIdx].Gate[nGateIdx].boEnable := False;
    end;
    Inc(nGateIdx);
    if nGateIdx >= 10 then
      Break;
  end;
  SaveGateConfig(Config);
  //Application.MessageBox('·�����ñ������', '��ʾ', MB_ICONINFORMATION + MB_OK);
end;

procedure TFrmGateSetting.BtnChangeTitleClick(Sender: TObject);
var
  nTitleIdx: Integer;
  sTitle: string;
  sEdTitle: string;
  Config: pTConfig;
begin
  Config := @g_Config;
  nTitleIdx := CbGateList.ItemIndex;
  if nTitleIdx < 0 then
    Exit;
  sEdTitle := Trim(EdTitle.Text);
  sTitle := ReplaceChar(sEdTitle, ' ', '_');
  CbGateList.Items.Strings[nTitleIdx] := sTitle;
  Config.GateRoute[nTitleIdx].sTitle := sTitle;
  CbGateList.ItemIndex := nTitleIdx;
end;

procedure TFrmGateSetting.CbServerListChange(Sender: TObject);
var
  I: Integer;
  nSelIdx: Integer;
  sServerName: string;
  Config: pTConfig;
begin
  Config := @g_Config;
  nSelIdx := CbServerList.ItemIndex;
  if nSelIdx < 0 then
    Exit;
  sServerName := CbServerList.Items.Strings[nSelIdx];
  CbGateList.Clear;
  for I := 0 to Config.nRouteCount - 1 do
  begin
    if Config.GateRoute[I].sServerName = sServerName then
      CbGateList.Items.Add(Config.GateRoute[I].sTitle);
  end;
  CbGateList.ItemIndex := 0;
  CbGateListChange(Self);
end;

procedure TFrmGateSetting.RefRouteList;
var
  I, II: Integer;
  boAdded: Boolean;
  Config: pTConfig;
begin
  Config := @g_Config;
  if Config.nRouteCount <= 0 then
    Exit;
  CbServerList.Clear;
  for I := 0 to Config.nRouteCount - 1 do
  begin
    boAdded := true;
    for II := 0 to CbServerList.Items.Count - 1 do
    begin
      if Config.GateRoute[I].sServerName = CbServerList.Items.Strings[II] then
        boAdded := False;
    end;
    if boAdded then
      CbServerList.Items.Add(Config.GateRoute[I].sServerName);
  end;
  CbServerList.ItemIndex := 0;
  CbServerListChange(Self);
end;

function TFrmGateSetting.Open(): Boolean;
begin
  RefRouteList();
  Result := False;
  if ShowModal = mrOK then
    Result := true;
end;

procedure TFrmGateSetting.BtnCloseClick(Sender: TObject);
begin
  BtnChangeTitleClick(Sender);
  BtnOkClick(Sender);
  Close;
end;

end.
