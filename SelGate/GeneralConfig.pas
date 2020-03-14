unit GeneralConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, StdCtrls, ComCtrls;

type
  TfrmGeneralConfig = class(TForm)
    btnSave: TButton;
    Label1: TLabel;
    EditTitle: TEdit;
    labShowLogLevel: TLabel;
    TrackBarLogLevel: TTrackBar;
    GroupBox1: TGroupBox;
    LabelServerIPaddr: TLabel;
    LabelServerPort: TLabel;
    LabelGatePort: TLabel;
    Label2: TLabel;
    EditServerIPaddr: TEdit;
    EditServerPort: TEdit;
    EditGatePort: TEdit;
    speGateIdx: TSpinEdit;
    speGateCount: TSpinEdit;
    procedure speGateCountChange(Sender: TObject);
    procedure speGateIdxChange(Sender: TObject);
    procedure EditServerIPaddrChange(Sender: TObject);
    procedure EditTitleChange(Sender: TObject);
    procedure TrackBarLogLevelChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    m_Showed: Boolean;
  end;

var
  frmGeneralConfig: TfrmGeneralConfig;

implementation

{$R *.dfm}

uses
  HUtil32, Protocol, ConfigManager, WinSock2;

procedure TfrmGeneralConfig.btnSaveClick(Sender: TObject);
begin
  g_pConfig.SaveConfig(0);
  Close;
end;

procedure TfrmGeneralConfig.EditServerIPaddrChange(Sender: TObject);
var
  nIndex: Integer;
  nGatePort: Integer;
  nServerPort: Integer;
  szServerIPaddr: string;
begin
  if not m_Showed then
    Exit;
  nIndex := speGateIdx.Value;
  if not (nIndex in [Low(g_pConfig.m_xGameGateList)..High(g_pConfig.m_xGameGateList)]) then
    Exit;

  szServerIPaddr := Trim(EditServerIPaddr.Text);
  if inet_addr(PChar(szServerIPaddr)) <> INADDR_NONE then
  begin
    g_pConfig.m_xGameGateList[nIndex].sServerAdress := szServerIPaddr;
  end;

  nServerPort := Str_ToInt(Trim(EditServerPort.Text), -1);
  if (nServerPort > 0) and (nServerPort < 65536) then
  begin
    g_pConfig.m_xGameGateList[nIndex].nServerPort := nServerPort;
  end;

  nGatePort := Str_ToInt(Trim(EditGatePort.Text), -1);
  if (nGatePort > 0) and (nGatePort < 65536) then
  begin
    g_pConfig.m_xGameGateList[nIndex].nGatePort := nGatePort;
  end;
end;

procedure TfrmGeneralConfig.EditTitleChange(Sender: TObject);
begin
  if not m_Showed then
    Exit;
  g_pConfig.m_szTitle := EditTitle.Text;
end;

procedure TfrmGeneralConfig.FormCreate(Sender: TObject);
begin
  m_Showed := False;
end;

procedure TfrmGeneralConfig.speGateCountChange(Sender: TObject);
begin
  if not m_Showed then
    Exit;
  with Sender as TSpinEdit do
  begin
    g_pConfig.m_nGateCount := Value;
    if speGateIdx.Value > Value then
      speGateIdx.Value := Value;
  end;
end;

procedure TfrmGeneralConfig.speGateIdxChange(Sender: TObject);
var
  nIndex: Integer;
begin
  if not m_Showed then
    Exit;
  m_Showed := False;
  try
    if speGateIdx.Value > speGateCount.Value then
      speGateIdx.Value := speGateCount.Value;
    nIndex := speGateIdx.Value;
    if nIndex in [Low(g_pConfig.m_xGameGateList)..High(g_pConfig.m_xGameGateList)] then
    begin
      EditServerIPaddr.Text := g_pConfig.m_xGameGateList[nIndex].sServerAdress;
      EditServerPort.Text := IntToStr(g_pConfig.m_xGameGateList[nIndex].nServerPort);
      EditGatePort.Text := IntToStr(g_pConfig.m_xGameGateList[nIndex].nGatePort);
    end;
  finally
    m_Showed := True;
  end;
end;

procedure TfrmGeneralConfig.TrackBarLogLevelChange(Sender: TObject);
begin
  InterLockedExchange(g_pConfig.m_nShowLogLevel, TrackBarLogLevel.Position);
  labShowLogLevel.Caption := format('显示日志等级: %d', [g_pConfig.m_nShowLogLevel]);
end;

end.
