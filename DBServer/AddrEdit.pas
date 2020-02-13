unit AddrEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Spin, Buttons, ExtCtrls, Grids;
type
  TFrmEditAddr = class(TForm)
    AddrGrid: TStringGrid;
    Panel1: TPanel;
    BtnApplyAndClose: TButton;
    ERowCount: TSpinEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnApplyAndCloseClick(Sender: TObject);
    procedure Open();
    procedure ERowCountChange(Sender: TObject);
  private
    procedure sub_4A6864();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmEditAddr: TFrmEditAddr;

implementation

uses HUtil32, DBShare, DBSMain;

{$R *.DFM}

procedure TFrmEditAddr.FormCreate(Sender: TObject);
begin
  ERowCount.Value := 20;
  AddrGrid.Cells[00, 0] := '服务器编号';
  AddrGrid.Cells[01, 0] := '角色网关地址';
  AddrGrid.Cells[02, 0] := '游戏网关1';
  AddrGrid.Cells[03, 0] := '端口1';
  AddrGrid.Cells[04, 0] := '游戏网关2';
  AddrGrid.Cells[05, 0] := '端口2';
  AddrGrid.Cells[06, 0] := '游戏网关3';
  AddrGrid.Cells[07, 0] := '端口3';
  AddrGrid.Cells[08, 0] := '游戏网关4';
  AddrGrid.Cells[09, 0] := '端口4';
  AddrGrid.Cells[10, 0] := '游戏网关5';
  AddrGrid.Cells[11, 0] := '端口5';
  AddrGrid.Cells[12, 0] := '游戏网关6';
  AddrGrid.Cells[13, 0] := '端口6';
  AddrGrid.Cells[14, 0] := '游戏网关7';
  AddrGrid.Cells[15, 0] := '端口7';
  AddrGrid.Cells[16, 0] := '游戏网关8';
  AddrGrid.Cells[17, 0] := '端口8';

  AddrGrid.Cells[18, 0] := '游戏网关9';
  AddrGrid.Cells[19, 0] := '端口9';
  AddrGrid.Cells[20, 0] := '游戏网关10';
  AddrGrid.Cells[21, 0] := '端口10';
  AddrGrid.Cells[22, 0] := '游戏网关11';
  AddrGrid.Cells[23, 0] := '端口11';
  AddrGrid.Cells[24, 0] := '游戏网关12';
  AddrGrid.Cells[25, 0] := '端口12';
  AddrGrid.Cells[26, 0] := '游戏网关13';
  AddrGrid.Cells[27, 0] := '端口13';
  AddrGrid.Cells[28, 0] := '游戏网关14';
  AddrGrid.Cells[29, 0] := '端口14';
  AddrGrid.Cells[30, 0] := '游戏网关15';
  AddrGrid.Cells[31, 0] := '端口15';
  AddrGrid.Cells[32, 0] := '游戏网关16';
  AddrGrid.Cells[33, 0] := '端口16';
end;

procedure TFrmEditAddr.BtnApplyAndCloseClick(Sender: TObject);
var
  i, ii: Integer;
  SaveList: TStringList;
  s14: string;
begin
  SaveList := TStringList.Create;
  for i := 1 to AddrGrid.RowCount - 1 do
  begin
    s14 := Trim(AddrGrid.Cells[0, i]);
    if s14 <> '' then
    begin
      s14 := s14 + ' ';
      for ii := 1 to AddrGrid.ColCount - 1 do
        s14 := s14 + Trim(AddrGrid.Cells[ii, i]) + ' ';
    end;
    if Trim(s14) <> '' then
      SaveList.Add(Trim(s14));
  end;
  SaveList.SaveToFile(sGateConfFileName);
  Close;
  FrmDBSrv.BtnReloadAddrClick(Sender);
end;

procedure TFrmEditAddr.sub_4A6864();
var
  i, ii: Integer;
begin
  for i := 1 to AddrGrid.RowCount - 1 do
  begin
    for ii := 0 to AddrGrid.ColCount - 1 do
      AddrGrid.Cells[ii, i] := '';
  end;
end;

procedure TFrmEditAddr.Open();
var
  LoadList: TStringList;
  i, n18, n1C: Integer;
  sStr: string;
  sStr1: string;
begin
  sub_4A6864();
  LoadList := TStringList.Create;
  try
    LoadList.LoadFromFile(sGateConfFileName);
  except
  end;
  n1C := 1;
  for i := 0 to LoadList.Count - 1 do
  begin
    sStr := Trim(LoadList.Strings[i]);
    if (sStr <> '') and (sStr[1] <> ';') then
    begin
      sStr := GetValidStr3(sStr, sStr1, [#32, #9]);
      AddrGrid.Cells[0, n1C] := sStr1;
      n18 := 0;
      while (True) do
      begin
        if sStr <> '' then
        begin
          sStr := GetValidStr3(sStr, sStr1, [#32, #9]);
          AddrGrid.Cells[n18 * 2 + 1, n1C] := sStr1;
          sStr := GetValidStr3(sStr, sStr1, [#32, #9]);
          AddrGrid.Cells[n18 * 2 + 2, n1C] := sStr1;
          Inc(n18);
          if n18 <= 9 + 8 then
            Continue;
        end;
        Inc(n1C);
        if AddrGrid.RowCount <= n1C then
          AddrGrid.RowCount := AddrGrid.RowCount + 1;
        Break;
      end;
    end;
  end;
  LoadList.Free;
  ShowModal;
end;

procedure TFrmEditAddr.ERowCountChange(Sender: TObject);
begin
  if ERowCount.Value < 1 then
    ERowCount.Value := 1;
  AddrGrid.RowCount := ERowCount.Value + 1;
end;

end.
