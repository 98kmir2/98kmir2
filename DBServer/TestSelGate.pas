unit TestSelGate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, HUtil32;

type
  TfrmTestSelGate = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditSelGate: TEdit;
    Label2: TLabel;
    EditGameGate: TEdit;
    ButtonTest: TButton;
    Button1: TButton;
    Label3: TLabel;
    EditServerIdx: TEdit;
    Label4: TLabel;
    procedure ButtonTestClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTestSelGate: TfrmTestSelGate;

implementation

uses UsrSoc, RouteManage;

{$R *.dfm}

procedure TfrmTestSelGate.ButtonTestClick(Sender: TObject);
var
  sSelGateIPaddr: string;
  sGameGateIPaddr: string;
  nIdx, nGameGatePort: Integer;
begin
  nIdx := Str_ToInt(Trim(EditServerIdx.Text), 0);
  sSelGateIPaddr := Trim(EditSelGate.Text);
  sGameGateIPaddr := FrmUserSoc.GateRouteIP(nIdx, sSelGateIPaddr, nGameGatePort);
  if sGameGateIPaddr = '' then
  begin
    EditGameGate.Text := '无此网关设置';
    Exit;
  end;
  EditGameGate.Text := Format('%s:%d', [sGameGateIPaddr, nGameGatePort]);
end;

procedure TfrmTestSelGate.Button1Click(Sender: TObject);
begin
  frmRouteManage.Open;
end;

end.
