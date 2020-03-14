unit GrobalSession;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls;

type
  TfrmGrobalSession = class(TForm)
    ButtonRefGrid: TButton;
    PanelStatus: TPanel;
    GridSession: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure ButtonRefGridClick(Sender: TObject);
  private
    procedure RefGridSession();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmGrobalSession: TfrmGrobalSession;

implementation

uses LSShare, Grobal2, LMain, HUtil32;

{$R *.dfm}

{ TfrmGrobalSession }

procedure TfrmGrobalSession.FormCreate(Sender: TObject);
begin
  GridSession.Cells[0, 0] := '���';
  GridSession.Cells[1, 0] := '��¼�ʺ�';
  GridSession.Cells[2, 0] := '��¼��ַ';
  GridSession.Cells[3, 0] := '��������';
  GridSession.Cells[4, 0] := '�ỰID';
  GridSession.Cells[5, 0] := '�Ƿ��ֵ';
end;

procedure TfrmGrobalSession.Open;
begin
  RefGridSession();
  ShowModal;
end;

procedure TfrmGrobalSession.RefGridSession;
var
  I: Integer;
  ConnInfo: pTConnInfo;
  Config: pTConfig;
begin
  Config := @g_Config;
  PanelStatus.Caption := '����ȡ������...';
  GridSession.Visible := False;
  GridSession.Cells[0, 1] := '';
  GridSession.Cells[1, 1] := '';
  GridSession.Cells[2, 1] := '';
  GridSession.Cells[3, 1] := '';
  GridSession.Cells[4, 1] := '';
  GridSession.Cells[5, 1] := '';
  Config.SessionList.Lock;
  try
    if Config.SessionList.Count <= 0 then
    begin
      GridSession.RowCount := 2;
      GridSession.FixedRows := 1;
    end
    else
      GridSession.RowCount := Config.SessionList.Count + 1;
    for I := 0 to Config.SessionList.Count - 1 do
    begin
      ConnInfo := Config.SessionList.Items[I];
      GridSession.Cells[0, I + 1] := IntToStr(I);
      GridSession.Cells[1, I + 1] := ConnInfo.sAccount;
      GridSession.Cells[2, I + 1] := ConnInfo.sIPaddr;
      GridSession.Cells[3, I + 1] := ConnInfo.sServerName;
      GridSession.Cells[4, I + 1] := IntToStr(ConnInfo.nSessionID);
      GridSession.Cells[5, I + 1] := BoolToCStr(ConnInfo.boPayCost);
    end;
  finally
    Config.SessionList.UnLock;
  end;
  GridSession.Visible := true;
end;

procedure TfrmGrobalSession.ButtonRefGridClick(Sender: TObject);
begin
  RefGridSession();
end;

end.
