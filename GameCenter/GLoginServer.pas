unit GLoginServer;

interface

uses
  Classes, Controls, Forms,
  Grids, ComCtrls;

type
  TfrmLoginServerConfig = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GridGateRoute: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmLoginServerConfig: TfrmLoginServerConfig;

implementation

{$R *.dfm}

procedure TfrmLoginServerConfig.FormCreate(Sender: TObject);
begin
  GridGateRoute.Cells[0, 0] := '����������';
  GridGateRoute.Cells[1, 0] := '·�ɱ�ʶ';
  GridGateRoute.Cells[2, 0] := '��¼������IP';
  GridGateRoute.Cells[3, 0] := '��¼������IP';
  GridGateRoute.Cells[4, 0] := '��ɫ����';
  GridGateRoute.Cells[5, 0] := '�˿�';
end;

procedure TfrmLoginServerConfig.Open;
begin
  ShowModal;
end;

end.
