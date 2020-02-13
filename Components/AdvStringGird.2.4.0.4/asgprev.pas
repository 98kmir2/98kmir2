{********************************************************************}
{ TADVPREVIEWDIALOG component                                        }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0,6.0            }
{ version 1.3                                                        }
{                                                                    }
{ written by TMS Software                                            }
{           copyright © 1998-2002                                    }
{           Email : info@tmssoftware.com                             }
{           Web : http://www.tmssoftware.com                         }
{********************************************************************}

unit asgprev;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, AdvGrid, Printers;

type
  TAdvPreviewForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Next: TButton;
    Previous: TButton;
    Button3: TButton;
    Button4: TButton;
    PreviewPaintBox: TPaintBox;
    procedure FormResize(Sender: TObject);
    procedure PreviewPaintBoxPaint(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure PreviousClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMMinMaxInfo(var Msg:TMessage); message wm_getminmaxinfo;
  public
    { Public declarations }
    Grid: TAdvStringGrid;
    PrintSelectedRows: Boolean;
    PrinterSetupDialog: Boolean;
  end;

  TAdvPreviewDialog = class(TCommonDialog)
  private
    FPreviewWidth: integer;
    FPreviewHeight: integer;
    FPreviewTop: integer;
    FPreviewLeft: integer;
    FPreviewCenter: boolean;
    FPreviewFast: boolean;
    FForm: TAdvPreviewForm;
    FGrid: TAdvStringGrid;
    FPrintSelectedRows: Boolean;
    FDlgNext: string;
    FDlgCaption: string;
    FDlgPrev: string;
    FDlgPrint: string;
    FDlgClose: string;
    FPrinterSetupDialog: Boolean;
    procedure SetPreviewWidth(value: integer);
    procedure SetPreviewHeight(value: integer);
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
  public
    constructor Create(AOwner:TComponent); override;
    function Execute: Boolean; {$IFDEF DELPHI3_LVL} override; {$ENDIF}
    property Form: TAdvPreviewForm read FForm;
  published
    property DialogCaption: string read FDlgCaption write FDlgCaption;
    property DialogPrevBtn: string read FDlgPrev write FDlgPrev;
    property DialogNextBtn: string read FDlgNext write FDlgNext;
    property DialogPrintBtn: string read FDlgPrint write FDlgPrint;
    property DialogCloseBtn: string read FDlgClose write FDlgClose; 
    property Grid: TAdvStringGrid read FGrid write FGrid;
    property PreviewFast: Boolean read FPreviewFast write FPreviewFast;
    property PreviewWidth: Integer read FPreviewWidth write SetPreviewWidth;
    property PreviewHeight: Integer read FPreviewHeight write SetPreviewHeight;
    property PreviewLeft: Integer read FPreviewLeft write FPreviewLeft;
    property PreviewTop: Integer read FPreviewTop write FPreviewTop;
    property PreviewCenter: Boolean read FPreviewCenter write FPreviewCenter;
    property PrinterSetupDialog: Boolean read FPrinterSetupDialog write FPrinterSetupDialog;
    property PrintSelectedRows: Boolean read FPrintSelectedRows write FPrintSelectedRows;

  end;


var
  AdvPreviewForm: TAdvPreviewForm;

implementation

{$R *.DFM}


{ TAdvPreviewDialog }

constructor TAdvPreviewDialog.Create(AOwner: TComponent);
begin
  inherited Create(aOwner);
  FPreviewWidth := 350;
  FPreviewHeight := 300;
  FPreviewTop := 100;
  FPreviewLeft := 100;
  FDlgCaption := 'Preview';
  FDlgNext := 'Next';
  FDlgPrev := 'Previous';
  FDlgClose := 'Close';
  FDlgPrint := 'Print';
end;

function TAdvPreviewDialog.Execute: Boolean;
begin
  If not Assigned(Grid) then
  begin
    raise Exception.Create('The dialog does not have a grid component.');
    Result := False;
    Exit;
  end;

  FForm := TAdvPreviewForm.Create(Application);
  FForm.Grid := Grid;
  FForm.Width := FPreviewWidth;
  FForm.Height := FPreviewHeight;

  if FPreviewCenter then
   FForm.Position := poScreenCenter
  else
   begin
    FForm.position := poDesigned;
    FForm.Left := FPreviewLeft;
    FForm.Top := FPreviewTop;
   end;

  FForm.Grid.PreviewPage := 1;
  FForm.Grid.FastPrint := FPreviewFast;
  FForm.Previous.Enabled := False;
  FForm.PrintSelectedRows := FPrintSelectedRows;
  FForm.PrinterSetupDialog := FPrinterSetupDialog; 

  FForm.Caption := FDlgCaption;
  FForm.Button3.Caption := FDlgPrint;
  FForm.Button4.Caption := FDlgClose;
  FForm.Previous.Caption := FDlgPrev;
  FForm.Next.Caption := FDlgNext;

  try
    Result := (FForm.ShowModal = mrOK);
    FPreviewWidth := FForm.Width;
    FPreviewHeight := FForm.Height;
    FPreviewTop := FForm.Top;
    FPreviewLeft := FForm.Left;
  finally
    FForm.Free;
  end;
end;

procedure TAdvPreviewForm.FormResize(Sender: TObject);
var
  nw,nh,rw,rh:integer;
begin
  rw := self.clientrect.right-self.clientrect.left;
  rh := self.clientrect.bottom-self.clientrect.top;
  nw := round(rw*90/100);
  nh := round((rh-panel1.height)*90/100);

  panel2.left := (rw-nw) shr 1;
  panel2.top := panel1.height+((rh-panel1.height-nh) shr 1);
  panel2.width := nw;
  panel2.height := nh;
end;

procedure TAdvPreviewForm.PreviewPaintBoxPaint(Sender: TObject);
begin
  if Assigned(Grid) then
  begin
    if PrintSelectedRows then
      Grid.PrintPreviewSelectedRows(PreviewPaintBox.Canvas, PreviewPaintBox.ClientRect)
    else
      Grid.PrintPreview(PreviewPaintBox.Canvas, PreviewPaintBox.ClientRect);
  end;

  Previous.Enabled := (Grid.PreviewPage > 1);
  Next.Enabled := (Grid.PreviewPage<Grid.PrintNrOfPages);
  if Grid.PreviewPage > Grid.PrintNrOfPages then
    Grid.PreviewPage := Grid.PrintNrOfPages;
end;

procedure TAdvPreviewForm.Button3Click(Sender: TObject);
var
  ps: TPrinterSetupDialog;
  res: Boolean;
  ori,oldori: TPrinterOrientation;

begin
  if Assigned(Grid) then
  begin
    oldori := grid.PrintSettings.Orientation;

    grid.FastPrint := False;
    grid.Previewpage := -1;
    if PrinterSetupDialog then
    begin
      ps := TPrinterSetupDialog.Create(Self);
      res := ps.Execute;

      ori := printer.Orientation;

      ps.Free;

      if not res then Exit;

      grid.PrintSettings.Orientation := ori;
    end;
    if PrintSelectedRows then
      grid.PrintSelectedRows
    else
      grid.Print;

    grid.PrintSettings.Orientation := oldori;
  end;
end;

procedure TAdvPreviewForm.Button4Click(Sender: TObject);
begin
  self.Close;
end;

procedure TAdvPreviewForm.PreviousClick(Sender: TObject);
begin
  if Grid.PreviewPage > 1 then
    Grid.PreviewPage := Grid.PreviewPage - 1;
  Previous.Enabled := (Grid.PreviewPage > 1);
  Next.Enabled := (Grid.PreviewPage<Grid.PrintNrOfPages);
  PreviewPaintbox.Invalidate;
end;

procedure TAdvPreviewForm.NextClick(Sender: TObject);
begin
  if Grid.PreviewPage < Grid.PrintNrOfPages then
    Grid.PreviewPage := Grid.PreviewPage + 1;
  Previous.Enabled := (Grid.PreviewPage>1);
  Next.Enabled := (Grid.PreviewPage < Grid.PrintNrOfPages);
  PreviewPaintbox.invalidate;
end;

procedure TAdvPreviewDialog.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FGrid) then
    FGrid := Nil;
  inherited;
end;

procedure TAdvPreviewForm.WMMinMaxInfo(var Msg: TMessage);
var
  mima: ^TMinMaxInfo;
begin
  inherited;
  mima := pointer(msg.lparam);
  mima^.ptMinTrackSize := Point(350,100);
end;

procedure TAdvPreviewDialog.SetPreviewHeight(value: integer);
begin
  if value < 100 then
    Value := 100;
  FPreviewHeight := Value;
end;

procedure TAdvPreviewDialog.SetPreviewWidth(value: integer);
begin
  if value < 350 then
    Value := 350;
  FPreviewWidth := Value;
end;

end.
