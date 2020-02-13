{***************************************************************************}
{ TBaseGrid component                                                       }
{ for Delphi & C++Builder                                                   }
{ version 2.4.x.x                                                           }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 1996-2003                                          }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

unit BaseGrid;

{$I TMSDEFS.INC}

{$IFDEF DELPHI5_LVL}
{$DEFINE TMSUNICODE}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids
  {$IFDEF TMSCODESITE}
  , CSIntf
  {$ENDIF}
  ;

type
  TBaseGrid = class;

  TVAlignment = (vtaTop,vtaCenter,vtaBottom);

  TColumnCalcType = (acNONE,acSUM,acAVG,acCOUNT,acMIN,acMAX);

  TEditorType = (edNormal,edSpinEdit,edComboEdit,edComboList,edEditBtn,edCheckBox,
    edDateEdit,edDateEditUpDown,edTimeEdit,edButton,edDataCheckBox,edNumeric,
    edPositiveNumeric,edFloat,edCapital,edMixedCase,edPassword,edUnitEditBtn,
    edLowerCase,edUpperCase,edFloatSpinEdit,edTimeSpinEdit,edDateSpinEdit,
    edNumericEditBtn,edFloatEditBtn,edCustom,edRichEdit
    {$IFDEF TMSUNICODE}
    , edUniEdit,edUniComboEdit,edUniComboList
    {$ENDIF}
    );

  { TCellProperties }

  TCellProperties = class(TPersistent)
  private
    FOwnerGrid: TBaseGrid;
    FOwnerCol: Integer;
    FOwnerRow: Integer;
    FObject: TObject;
    FGraphicObject: TObject;
    FBrushStyle: TBrushStyle;
    FBrushColor: TColor;
    FFontSize: Integer;
    FFontColor: TColor;
    FFontStyle: TFontStyles;
    FCellSpanY: integer;
    FCellSpanX: integer;
    FBorderWidth: Integer;
    FBorderColor: TColor;
    FAlignment: TAlignment;
    FVAlignment: TVAlignment;
    FPaintID: Integer;
    FWordWrap: Boolean;
    FIsBaseCell: Boolean;
    FCalcType: TColumnCalcType;
    FCalcObject: TObject;
    FNodeLevel: Integer;
    FEditor: TEditorType;
    FFontName: string;
    FReadOnly: Boolean;
    FControl: TControl;
    procedure SetBrushColor(const Value: TColor);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetVAlignment(const Value: TVAlignment);
    procedure SetWordWrap(const Value: Boolean);
    function GetBaseCell(c, r: Integer): TPoint;
  protected
    property BaseCell[c,r: Integer]: TPoint read GetBaseCell;
    property PaintID: Integer read FPaintID write FPaintID;
    property GraphicObject: TObject read FGraphicObject write FGraphicObject;
  public
    property CalcType: TColumnCalcType read FCalcType write FCalcType;
    property CalcObject: TObject read FCalcObject write FCalcObject;
    constructor Create(AOwner: TBaseGrid; ACol, ARow:integer);
    procedure Assign(Source: TPersistent); override;
  published
    property IsBaseCell: Boolean read FIsBaseCell write FIsBaseCell;
    property CellSpanX: Integer read FCellSpanX write FCellSpanX;
    property CellSpanY: Integer read FCellSpanY write FCellSpany;
    property OwnerCol: Integer read FOwnerCol write FOwnerCol;
    property OwnerRow: Integer read FOwnerRow write FOwnerRow;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property BorderColor: TColor read FBorderColor write FBorderColor;
    property BorderWidth: integer read FBorderWidth write FBorderWidth;
    property BrushColor: TColor read FBrushColor write SetBrushColor;
    property BrushStyle: TBrushStyle read FBrushStyle write FBrushStyle;
    property CellObject: TObject read FObject write FObject;
    property FontColor: TColor read FFontColor write FFontColor;
    property FontName: string read FFontName write FFontName;
    property FontSize: Integer read FFontSize write FFontSize;
    property FontStyle: TFontStyles read FFontStyle write FFontStyle;
    property Editor: TEditorType read FEditor write FEditor;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property VAlignment: TVAlignment read FValignment write SetVAlignment;
    property WordWrap: Boolean read FWordWrap write SetWordWrap;
    property NodeLevel: Integer read FNodeLevel write FNodeLevel;
    property Control: TControl read FControl write FControl;
  end;

  TGetDisplTextEvent = procedure(Sender: TObject; ACol,ARow: Integer; var Value: string) of object;

  TBaseGrid = class(TStringGrid)
  private
    { Private declarations }
    FDefaultDrawing: Boolean;
    FGridLineWidth: Integer;
    FGridLineColor: TColor;
    FPaintID: Integer;
    FCustomSelect: Boolean;
    FOnGetDisplText: TGetDisplTextEvent;
    FHideLastRow: Boolean;
    FNormalRowCount: Integer;
    function GetDefaultDrawing: boolean;
    procedure SetDefaultDrawing(const Value: boolean);
    function GetGridLineWidth: integer;
    procedure SetGridLineWidth(const Value: integer);
    procedure SetGridLineColor(const Value: TColor);
    procedure SetObjectEx(c, r: integer; const Value: TObject);
    function GetObjectEx(c, r: integer): TObject;
    function GetCellProperties(c, r: integer): TCellProperties;
    procedure SetCellProperties(c, r: integer; const Value: TCellProperties);
    function GetCellEx(c, r: integer): String;
    procedure SetCellEx(c, r: integer; const Value: String);
    function GetGraphicObjectEx(c, r: Integer): TObject;
    procedure SetGraphicObjectEx(c, r: Integer; const Value: TObject);
    procedure RepaintFixedMergedCols;
    procedure RepaintFixedMergedRows;
    function GetGridObject(c, r: Integer): TObject;
    procedure SetGridObject(c, r: Integer; const Value: TObject);
    function GetGridCell(c, r: Integer): string;
    procedure SetGridCell(c, r: Integer; const Value: string);
  protected
    { Protected declarations }
    {$IFNDEF DELPHI6_LVL}
    procedure SetGridOrientation(RightToLeftOrientation: Boolean);
    {$ENDIF}    
    procedure CopyRows(ARow1, ARow2: Integer);
    procedure CopyCols(ACol1, ACol2: Integer);
    procedure NilRow(ARow: Integer);
    procedure NilCol(ACol: Integer);
    procedure NilCell(ACol,ARow: Integer);
    procedure SelectBaseCell;
    function IsFixed(ACol, ARow: Integer): Boolean; virtual;
    function IsSelected(ACol, ARow: Integer): Boolean;
    function NodeIndent(ARow: Integer): Integer; virtual;
    function HasNodes: Boolean; virtual;
    function FixedColsWidth: Integer;
    function FixedRowsHeight: Integer;
    procedure TopLeftChanged; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    procedure DrawGridCell(Canvas: TCanvas; ACol, ARow:longint; ARect:TRect; AState:TGridDrawState); virtual;
    function HasCellProperties(ACol, ARow:integer): Boolean;
    procedure ClearProps;
    procedure ClearPropCell(ACol,ARow: Integer);
    procedure ClearPropRow(ARow: Integer);
    procedure ClearPropRect(ACol1,ARow1,ACol2,ARow2: Integer);
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    {$IFDEF DELPHI4_LVL}
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    {$ENDIF}
    procedure Paint; override;
    procedure FloatFooterUpdate; virtual;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
    function GetEditText(ACol, ARow: Longint): string; override;
    procedure GetVisualProperties(ACol,ARow: Integer; var AState: TGridDrawState; Print, Select, Remap: Boolean;
      ABrush: TBrush; AFont: TFont; var HA: TAlignment; var VA: TVAlignment; var WW: Boolean); virtual;
    function IsBaseCellEx(ACol,ARow: Integer;var MCol,MRow: Integer): Boolean;
    function GetCellRect(c, r: Integer): TRect;
    property PaintID: Integer read FPaintID;
    property CustomSelect: Boolean read FCustomSelect write FCustomSelect;
    property CellProperties[c,r: Integer]: TCellProperties read GetCellProperties write SetCellProperties;
    //property RowProperties[r:integer]: TCellProperties read GetRowProperties write SetRowProperties;
    //property ColumnProperties[c:integer]: TCellProperties read GetColProperties write SetColProperties;
    property HideLastRow: Boolean read FHideLastRow write FHideLastRow;
    property NormalRowCount: Integer read FNormalRowCount write FNormalRowCount;
    property GridObjects[c,r: Integer]: TObject read GetGridObject write SetGridObject;
    procedure GetDisplText(c,r: Integer; var Value: string); virtual;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    function CellRect(c,r:Integer): TRect;
    function CellSize(c,r: Integer): TPoint;
    function IsBaseCell(ACol,ARow: Integer): Boolean;
    function IsMergedCell(ACol,ARow: Integer): Boolean;
    function IsXMergedCell(ACol,ARow: Integer): Boolean;
    function IsYMergedCell(ACol,ARow: Integer): Boolean;
    function BaseCell(ACol,ARow: Integer): TPoint;
    function FullCell(c,r: Integer): TRect;
    function CellSpan(ACol,ARow: Integer): TPoint;
    function CellExt(ACol,ARow: Integer): TPoint;
    function MinRowSpan(ARow: Integer): Integer;
    function MaxRowSpan(ARow: Integer): Integer;
    function RowSpanIdentical(ARow1,ARow2: Integer): Boolean;
    function ColSpanIdentical(ACol1,ACol2: Integer): Boolean;
    procedure MergeCells(c,r,spanx,spany: Integer); virtual;
    procedure SplitCells(c,r: Integer); virtual;
    procedure RepaintCell(c,r: Integer);
    property Objects[c,r: Integer]: TObject read GetObjectEx write SetObjectEx;
    property GraphicObjects[c,r: Integer]: TObject read GetGraphicObjectEx write SetGraphicObjectEx;
    property Cells[c,r: Integer]: String read GetCellEx write SetCellEx;
    property GridCells[c,r: Integer]: string read GetGridCell write SetGridCell;
  published
    { Published declarations }
    property DefaultDrawing: Boolean read GetDefaultDrawing write SetDefaultDrawing;
    property GridLineWidth: Integer read GetGridLineWidth write SetGridLineWidth;
    property GridLineColor: TColor read fGridLineColor write SetGridLineColor;
    property OnGetDisplText: TGetDisplTextEvent read FOnGetDisplText write FOnGetDisplText;
  end;



implementation

{ TBaseGrid }

constructor TBaseGrid.Create(AOwner: TComponent);
begin
  inherited;
  GridLineWidth := 1;
  GridLineColor := clSilver;
  DefaultDrawing := False;
  Options := Options + [goDrawFocusSelected];
  CustomSelect := True;
  FHideLastRow := False;
end;

destructor TBaseGrid.Destroy;
begin
  ClearProps;
  inherited;
end;

procedure TBaseGrid.Paint;
begin
  inherited;
  inc(FPaintID);
end;

procedure TBaseGrid.DrawGridCell(Canvas:TCanvas; ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
begin
  DrawText(Canvas.Handle,PChar(Cells[ACol,ARow]),Length(Cells[ACol,ARow]),ARect,DT_CENTER or DT_VCENTER or DT_SINGLELINE);
end;

procedure TBaseGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  hrgn: THandle;
  CrL,CrT: Integer;
  OutofBounds: Boolean;
  MCol,MRow: Integer;
  HA: TAlignment;
  VA: TVAlignment;
  WW: Boolean;
  GLW: Integer;
begin
  hrgn := 0;

  // Leave drawing of the last row to the floating last fixed row
  if (ARow = RowCount - 1) and FHideLastRow then
  begin
    Canvas.Brush.Color := Color;
    Canvas.Pen.Color := Color;
    Canvas.Rectangle(ARect.Left,ARect.Top, ARect.Right ,ARect.Bottom);
    Exit;
  end;

  // Redirect painting to base cell
  if not IsBaseCellEx(ACol,ARow,MCol,MRow) then
  begin
    if (CellProperties[MCol,MRow].PaintID <> FPaintID) then
    begin
      CellProperties[MCol,MRow].PaintID := FPaintID;
      DrawCell(MCol,MRow,ARect,AState);
    end;
    Exit;
  end;

  if IsFixed(ACol,ARow) then
    AState := AState + [gdFixed] - [gdSelected];

  ARect := CellRect(ACol,ARow);

  CrL := 0;
  CrT := 0;

  if (ACol >= FixedCols) then
    CrL := FixedColsWidth;

  if (ARow >= FixedRows) then
    CrT := FixedRowsHeight;

  OutOfBounds := ((ACol >= FixedCols) and (FixedCols > 0) and (ARect.Left < CrL)) or
                 ((ARow >= FixedRows) and (FixedRows > 0) and (ARect.Top < CrT));

  if OutOfBounds then
  begin
    hrgn := CreateRectRgn(CrL, CrT, Width,Height);
    SelectClipRgn(Canvas.Handle, hrgn);
  end;

  Canvas.Pen.Width := 1;
  Canvas.Font.Assign(Font);

  GetVisualProperties(ACol,ARow,AState,False,True,True,Canvas.Brush,Canvas.Font,HA,VA,WW);
  Canvas.Pen.Color := Canvas.Brush.Color;
  Canvas.Rectangle(ARect.Left,ARect.Top, ARect.Right ,ARect.Bottom);

  if gdFixed in AState then
  begin
    Canvas.Pen.Color := clgray;
    Canvas.Pen.Width := 1;
    GLW := 1;
  end
  else
  begin
    if FGridLineWidth > 0 then
      Canvas.Pen.Color := GridLineColor;
    Canvas.Pen.Width := FGridLineWidth;
    GLW := (FGridLineWidth + 1) shr 1;
  end;

  if (ACol = 0) and (ARow >= FixedRows) then
  begin
    ARect.Left := ARect.Left + NodeIndent(ARow);
  end;

  if not ((MCol = 0) and HasNodes) then
  if ((goHorzLine in Options) and not (gdFixed in AState)) or
     ((goFixedHorzLine in Options) and (gdFixed in AState)) then
  begin
    Canvas.MoveTo(ARect.Left - GLW + 1,ARect.Bottom - GLW);
    Canvas.LineTo(ARect.Right - GLW + 1,ARect.Bottom - GLW);
  end;

  if ((goVertLine in Options) and not (gdFixed in AState)) or
     ((goFixedVertLine in Options) and (gdFixed in AState)) then
  begin
    Canvas.MoveTo(ARect.Right - GLW ,ARect.Bottom - GLW);
    Canvas.LineTo(ARect.Right - GLW  ,ARect.Top - GLW);
  end;

  if gdFixed in AState then
    Inflaterect(ARect,-1,-1)
  else
    Inflaterect(ARect,-FGridLineWidth,-FGridLineWidth);

  DrawGridCell(Canvas,ACol,ARow,ARect,AState);

  // DrawText(Canvas.Handle,PChar(Cells[ACol,ARow]),Length(Cells[ACol,ARow]),ARect,DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOCLIP);

  if OutOfBounds then
  begin
    SelectClipRgn(Canvas.Handle, 0);
    DeleteObject(hrgn);
  end;
end;

function TBaseGrid.GetDefaultDrawing: boolean;
begin
  Result := FDefaultDrawing;
end;

function TBaseGrid.GetGridLineWidth: integer;
begin
  Result := FGridLineWidth;
end;

procedure TBaseGrid.SetObjectEx(c, r: integer; const Value: TObject);
var
  EC: Boolean;
begin
  EC := Cells[c,r] = '';
  if EC then
    Cells[c,r] := ' ';

  if not Assigned(inherited Objects[c,r]) then
    inherited Objects[c,r] := TCellProperties.Create(self,c,r);

  TCellProperties(inherited Objects[c,r]).CellObject := Value;

  if EC then
    Cells[c,r] := '';
end;

function TBaseGrid.GetObjectEx(c, r: integer): TObject;
begin
  if Assigned(inherited Objects[c,r]) then
    Result := TCellProperties(inherited Objects[c,r]).CellObject
  else
    Result := nil;
end;

procedure TBaseGrid.SetDefaultDrawing(const Value: boolean);
begin
  inherited DefaultDrawing := false;
  FDefaultDrawing := value;
end;

procedure TBaseGrid.SetGridLineColor(const Value: TColor);
begin
  FGridLineColor := Value;
  Invalidate;
end;

procedure TBaseGrid.SetGridLineWidth(const Value: integer);
begin
  FGridLineWidth := value;
  inherited GridLineWidth := 0;
  Invalidate;
end;

function TBaseGrid.GetCellRect(c,r: integer): TRect;
var
  i,x,y: Integer;
  ARect,tlr: TRect;
begin
  x := 0;
  y := 0;

  for i := 1 to c do x := x + ColWidths[i - 1];
  for i := 1 to r do y := y + RowHeights[i - 1];

  // absolute rectangle of cell

  ARect := Rect(x,y,x + ColWidths[c],y + RowHeights[r]);

  x := 0;
  y := 0;

  if c >= FixedCols then
    for i := 1 to LeftCol do
      x := x + ColWidths[i - 1];

  if r >= FixedRows then
    for i := 1 to TopRow do
      y := y + RowHeights[i - 1];

  OffsetRect(ARect, -x, -y);

  tlr := inherited CellRect(LeftCol,TopRow);

  if c < FixedCols then
    tlr.Left := 0;

  if r < FixedRows then
    tlr.Top := 0;

  OffsetRect(ARect,tlr.Left,tlr.Top);

  Result := ARect;
end;

function TBaseGrid.CellRect(c,r: integer): TRect;
var
  r1,r2: TRect;
  BC: TPoint;

begin
  if HasCellProperties(c,r) then
    if (CellProperties[c,r].CellSpanX <> -1) or (CellProperties[c,r].CellSpanY <> -1) then
    begin
      BC := CellProperties[c,r].BaseCell[c,r];
      r1 := GetCellRect(BC.X,BC.Y);
      r2 := GetCellRect(BC.X + CellProperties[BC.X,BC.Y].CellSpanX,BC.Y + CellProperties[BC.X,BC.Y].CellSpanY);

      UnionRect(r1, r1, r2);
      Result := r1;
    end
    else
      Result := GetCellRect(c,r)
  else
  Result := GetCellRect(c,r);
end;

function TBaseGrid.CellSize(c,r: Integer): TPoint;
var
  r1,r2: TRect;
  BC: TPoint;
begin
  if HasCellProperties(c,r) then
    if (CellProperties[c,r].CellSpanX <> -1) or (CellProperties[c,r].CellSpanY <> -1) then
    begin
      BC := CellProperties[c,r].BaseCell[c,r];
      r1 := GetCellRect(BC.X,BC.Y);
      r2 := GetCellRect(BC.X + CellProperties[BC.X,BC.Y].CellSpanX,BC.Y + CellProperties[BC.X,BC.Y].CellSpanY);

      UnionRect(r1, r1, r2);
    end
    else
      r1 := GetCellRect(c,r)
  else
    r1 := GetCellRect(c,r);

  Result := Point(r1.Right-r1.Left,r1.Bottom - r1.Top);
end;

function TBaseGrid.CellSpan(ACol,ARow: Integer): TPoint;
var
  BC: TPoint;
begin
  Result := Point(0,0);
  if HasCellProperties(ACol,ARow) then
    if (CellProperties[ACol,ARow].CellSpanX <> -1) and (CellProperties[ACol,ARow].CellSpanY <> -1) then
    begin
      BC := CellProperties[ACol,ARow].BaseCell[ACol,ARow];
      Result := Point(CellProperties[BC.X,BC.Y].CellSpanX,CellProperties[BC.X,BC.Y].CellSpanY);
    end;
end;

function TBaseGrid.CellExt(ACol,ARow: Integer): TPoint;
var
  BC: TPoint;
begin
  Result := Point(0,0);
  if HasCellProperties(ACol,ARow) then
    if (CellProperties[ACol,ARow].CellSpanX <> -1) and (CellProperties[ACol,ARow].CellSpanY <> -1) then
    begin
      BC := CellProperties[ACol,ARow].BaseCell[ACol,ARow];
      Result := Point(BC.X - ACol + CellProperties[BC.X,BC.Y].CellSpanX,
                      BC.Y - ARow + CellProperties[BC.X,BC.Y].CellSpanY);
    end;
end;


function TBaseGrid.IsMergedCell(ACol,ARow: Integer): Boolean;
begin
  Result := False;
  if HasCellProperties(ACol,ARow) then
    Result := (CellProperties[ACol,ARow].CellSpanX > 0) or (CellProperties[ACol,ARow].CellSpanY > 0);
end;

function TBaseGrid.IsXMergedCell(ACol, ARow: Integer): Boolean;
var
  BC: TPoint;
begin
  Result := False;
  if HasCellProperties(ACol,ARow) then
  begin
    BC := CellProperties[ACol,ARow].BaseCell[ACol,ARow];
    Result := (CellProperties[BC.X,BC.Y].CellSpanX > 0);
  end;
end;

function TBaseGrid.IsYMergedCell(ACol, ARow: Integer): Boolean;
var
  BC: TPoint;
begin
  Result := False;
  if HasCellProperties(ACol,ARow) then
  begin
    BC := CellProperties[ACol,ARow].BaseCell[ACol,ARow];
    Result := (CellProperties[BC.X,BC.Y].CellSpanY > 0);
  end;
end;

function TBaseGrid.GetCellProperties(c, r: integer): TCellProperties;
begin
  if not Assigned(inherited Objects[c,r]) then
    inherited Objects[c,r] := TCellProperties.Create(Self,c,r);

  Result := TCellProperties(inherited Objects[c,r]);
end;

procedure TBaseGrid.MergeCells(c, r, spanx, spany: Integer);
var
  i,j: Integer;
begin
  for i := c to c + spanx - 1 do
    for j := r to r + spany - 1 do
    begin
      CellProperties[i,j].IsBaseCell := (i = c) and (j = r);

      if CellProperties[i,j].IsBaseCell then
      begin
        CellProperties[i,j].CellSpanX := SpanX - 1;
        CellProperties[i,j].CellSpanY := SpanY - 1;
      end
      else
      begin
        CellProperties[i,j].CellSpanX := i - c;
        CellProperties[i,j].CellSpanY := j - r;
      end;
    end;

  for i := c to c + spanx - 1 do
    for j := r to r + spany - 1 do
    begin
      RepaintCell(i,j);
    end;
end;

procedure TBaseGrid.SetCellProperties(c, r: integer; const Value: TCellProperties);
begin

  if Assigned(inherited Objects[c,r]) then
      TCellProperties(inherited Objects[c,r]).Free;

  inherited Objects[c,r] := Value
end;

procedure TBaseGrid.SplitCells(c, r: integer);
var
  i,j: integer;
  spanx,spany: integer;
  bc: TPoint;
begin
  bc := CellProperties[c,r].BaseCell[c,r];

  c := bc.X;
  r := bc.Y;

  SpanX := CellProperties[c,r].CellSpanX;
  SpanY := CellProperties[c,r].CellSpanY;

  for i := c to c + spanx do
    for j := r to r + spany do
    begin
      CellProperties[i,j].IsBaseCell := True;
      CellProperties[i,j].CellSpanX := -1;
      CellProperties[i,j].CellSpanY := -1;
   end;
  for i := c to c + spanx do
    for j := r to r + spany do
      RepaintCell(i,j);
end;

function TBaseGrid.HasCellProperties(ACol, ARow: integer): boolean;
begin
  Result := Assigned(inherited Objects[ACol,ARow]);
end;

function TBaseGrid.GetCellEx(c, r: integer): String;
var
  BC: TPoint;
begin

  if HasCellProperties(c,r) then
    BC := CellProperties[c,r].BaseCell[c,r]
  else
    BC := Point(c,r);

  Result := inherited Cells[BC.X,BC.Y];

  if BC.Y < NormalRowCount then
    GetDisplText(BC.X,BC.Y,Result);
end;

procedure TBaseGrid.SetCellEx(c, r: integer; const Value: String);
var
  BC: TPoint;
begin

  if HasCellProperties(c,r) then
  begin
    BC := CellProperties[c,r].BaseCell[c,r];
    inherited Cells[BC.X,BC.Y] := Value;
    if Assigned(Parent) then
      RepaintCell(c,r);
  end
  else

    inherited Cells[c,r] := Value;

  if HideLastRow and (r = RowCount - 1) then
    FloatFooterUpdate;

end;

function TBaseGrid.SelectCell(ACol, ARow: Integer): Boolean;
begin
  RepaintCell(Col,Row);
  Result := inherited SelectCell(Acol, ARow);
  RepaintCell(ACol,ARow);
end;

procedure TBaseGrid.RepaintCell(c, r: integer);
var
  ARect: TRect;
begin
  ARect := CellRect(c,r);
  InvalidateRect(Handle,@arect,true);
end;

function TBaseGrid.IsSelected(ACol, ARow: Integer): Boolean;
var
  sr: TRect;
  BC: TPoint;
begin
  sr.Left := Selection.Left;
  sr.Right := Selection.Right;
  sr.Top := Selection.Top;
  sr.Bottom := Selection.Bottom;

  Result := (ACol >= sr.Left) and (ACol <= sr.Right) and (ARow <= sr.Bottom) and (ARow >= sr.Top);

  if Result then Exit;

  if HasCellProperties(ACol,ARow) then
  begin
   if (CellProperties[ACol,ARow].CellSpanX <> 0) or (CellProperties[ACol,ARow].CellSpanY <> 0) then
     begin
       BC := CellProperties[ACol,ARow].BaseCell[ACol,ARow];

       with CellProperties[BC.X,BC.Y] do
       Result := (Col >= BC.X) and (Col <= BC.X + CellSpanX) and
                 (Row >= BC.Y) and (Row <= BC.Y + CellSpanY);
     end
   end;
end;

procedure TBaseGrid.KeyDown(var Key: Word; Shift: TShiftState);
var
  BC: TPoint;
begin
  if HasCellProperties(Col,Row) then
    BC := CellProperties[Col,Row].BaseCell[Col,Row];

  case Key of
  VK_LEFT:
    begin
      if HasCellProperties(Col,Row) then
      with CellProperties[BC.X,BC.Y] do
      begin
        if (Col > BC.X) and (Col > FixedCols) and (BC.X > 0) then
          Col := BC.X - CellSpanX;
      end;
    end;
  VK_RIGHT:
    begin
      if HasCellProperties(Col,Row) then
      with CellProperties[BC.X,BC.Y] do
      begin
        if (Col <= BC.X + CellSpanX) and (Col < ColCount - 1) and
           (BC.X < ColCount -1) then
          Col := BC.X + CellSpanX;
      end;
    end;
  VK_UP:
    begin
      if HasCellProperties(Col,Row) then
      with CellProperties[BC.X,BC.Y] do
      begin
        if (Row > BC.Y) and (Row > FixedRows) and (BC.Y > 0) then
          Row := BC.Y - 1;
      end;
    end;
  VK_DOWN:
    begin
      if HasCellProperties(Col,Row) then
      with CellProperties[BC.X,BC.Y] do
      begin
        if (Row <= BC.Y + CellSpanY) and (Row < RowCount - 1) and
            (BC.Y < RowCount - 1) then
          Row := BC.Y + CellSpanY;
      end;
    end;
  VK_NEXT:
    begin
      if (TopRow + VisibleRowCount - FixedRows = RowCount - 1) and
         FHideLastRow and (RowCount > 1) then
        Row := RowCount - 2;
    end;

  end;

  inherited;

  SelectBaseCell;
end;

function TBaseGrid.GetEditText(ACol, ARow: Integer): string;
begin
  Result := inherited GetEditText(ACol,ARow);
end;

procedure TBaseGrid.SetEditText(ACol, ARow: Integer; const Value: string);
begin
  inherited SetEditText(ACol,ARow,Value);
end;

function TBaseGrid.BaseCell(ACol,ARow: Integer): TPoint;
begin
  if HasCellProperties(ACol,ARow) then
    with CellProperties[ACol,ARow] do
    begin
      Result := BaseCell[ACol,ARow];
    end
  else
    Result := Point(ACol,ARow);
end;

function TBaseGrid.IsBaseCellEx(ACol, ARow: Integer;var MCol,MRow: Integer): Boolean;
var
  BC: TPoint;
begin
  Result := True;
  MCol := ACol;
  MRow := ARow;

  if HasCellProperties(ACol,ARow) then
    with CellProperties[ACol,ARow] do
    begin
       Result := IsBaseCell;

       if not Result then
       begin
         BC := BaseCell[ACol,ARow];
         MCol := BC.X;
         MRow := BC.Y;
       end;
    end;
end;

function TBaseGrid.IsBaseCell(ACol, ARow: Integer): Boolean;
begin
  Result := True;
  if HasCellProperties(ACol,ARow) then
    Result := CellProperties[ACol,ARow].IsBaseCell;
end;


function TBaseGrid.NodeIndent(ARow: Integer): Integer;
begin
  Result := 0;
end;

procedure TBaseGrid.GetVisualProperties(ACol, ARow: Integer;
  var AState: TGridDrawState; Print, Select, Remap: Boolean; ABrush: TBrush; AFont: TFont;
  var HA: TAlignment; var VA: TVAlignment; var WW: Boolean);
begin

end;

function TBaseGrid.GetGraphicObjectEx(c, r: Integer): TObject;
begin
  if Assigned(inherited Objects[c,r]) then
    Result := TCellProperties(inherited Objects[c,r]).GraphicObject
  else
    Result := nil;
end;

procedure TBaseGrid.SetGraphicObjectEx(c, r: Integer;
  const Value: TObject);
var
  EC: Boolean;
begin
  EC := Cells[c,r] = '';
  if EC then
    Cells[c,r] := ' ';

  if not Assigned(inherited Objects[c,r]) then
    inherited Objects[c,r] := TCellProperties.Create(Self,c,r);

  TCellProperties(inherited Objects[c,r]).GraphicObject := Value;

  if EC then
    Cells[c,r] := '';
end;

function TBaseGrid.FullCell(c, r: Integer): TRect;
var
  pt: TPoint;
begin
  pt := BaseCell(c,r);

  Result.Left := pt.X;
  Result.Top := pt.Y;

  pt := CellSpan(c,r);
  Result.Right := Result.Left + pt.X;
  Result.Bottom := Result.Top + pt.Y;
end;

{$IFDEF DELPHI4_LVL}
function TBaseGrid.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift,MousePos);

  if (Row - TopRow >= VisibleRowCount - FixedRows ) and
     (Row < RowCount - 1) and FHideLastRow then
    TopRow := TopRow + 1;

  SelectBaseCell;
end;

function TBaseGrid.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift,MousePos);
  SelectBaseCell;
end;
{$ENDIF}

procedure TBaseGrid.SelectBaseCell;
var
  BC: TPoint;
begin
  if HasCellProperties(Col,Row) then
  begin
    BC := CellProperties[Col,Row].BaseCell[Col,Row];
    Col := BC.X;
    Row := BC.Y;
  end;
end;

function TBaseGrid.FixedColsWidth: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to FixedCols do
    Result := Result + ColWidths[i - 1];
end;

function TBaseGrid.FixedRowsHeight: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to FixedRows do
    Result := Result + RowHeights[i - 1];
end;

procedure TBaseGrid.RepaintFixedMergedCols;
var
  i,j: Integer;
begin
  if FixedRows = 0 then
    Exit;

  for i := LeftCol to LeftCol + VisibleColCount do
    for j := 1 to FixedRows do
      if IsMergedCell(i, j - 1) then
        RepaintCell(i, j - 1);
end;

procedure TBaseGrid.RepaintFixedMergedRows;
var
  i,j: Integer;
begin
  if FixedCols = 0 then
    Exit;

  for i := TopRow to TopRow + VisibleRowCount do
    for j := 1 to FixedCols do
      if IsMergedCell(j - 1,i) then
        RepaintCell(j - 1,i);
end;

procedure TBaseGrid.TopLeftChanged;
begin
  inherited;
  RepaintFixedMergedRows;
  RepaintFixedMergedCols;
end;


function TBaseGrid.IsFixed(ACol, ARow: Integer): Boolean;
begin
  Result := False;
end;

procedure TBaseGrid.CopyCols(ACol1, ACol2: Integer);
begin
  Cols[ACol1] := Cols[ACol2];
end;

procedure TBaseGrid.CopyRows(ARow1, ARow2: Integer);
var
  i: Integer;
begin
  for i := 1 to ColCount do
  begin
    Cells[i - 1,ARow1] := Cells[i - 1,ARow2];
    inherited Objects[i - 1,ARow1] := inherited Objects[i - 1,ARow2];
  end;
end;

procedure TBaseGrid.NilCol(ACol: Integer);
var
  i: Integer;
begin
  for i := 1 to RowCount do
  begin
    inherited Objects[ACol,i - 1] := nil;
    Cells[ACol,i - 1] := '';
  end;
end;

procedure TBaseGrid.NilRow(ARow: Integer);
var
  i: Integer;
begin
  for i := 1 to ColCount do
  begin
    inherited Objects[i - 1,ARow] := nil;
    Cells[i - 1,ARow] := '';
  end;
end;

procedure TBaseGrid.NilCell(ACol, ARow: Integer);
begin
  Cells[ACol,ARow] := '';
  inherited Objects[ACol,ARow] := nil;
end;


function TBaseGrid.HasNodes: Boolean;
begin
  Result := False;
end;

// gets the smallest row span for a given row
function TBaseGrid.MinRowSpan(ARow: Integer): Integer;
var
  c,ms,ns: Integer;
begin
  ms := RowCount;
  for c := 1 to ColCount do
  begin
    ns := CellSpan(c - 1,ARow).Y;
    if (ns > 0) and (ns < ms) then
      ms := ns;
  end;
  Result := ms;
end;

function TBaseGrid.MaxRowSpan(ARow: Integer): Integer;
var
  c,ms,ns: Integer;
begin
  ms := 0;
  for c := 1 to ColCount do
  begin
    ns := CellSpan(c - 1,ARow).Y;
    if (ns > ms) then
      ms := ns;
  end;
  Result := ms;
end;


function TBaseGrid.RowSpanIdentical(ARow1,ARow2: Integer): Boolean;
var
  c: Integer;
  IsMerged: Boolean;
begin
  Result := True;
  IsMerged := False;
  for c := 1 to ColCount do
  begin
    if (CellSpan(c - 1,ARow1).Y > 0) and
       (CellSpan(c - 1,ARow2).Y > 0) then
    begin
      IsMerged := True;
      if (BaseCell(c - 1,ARow1).Y <> BaseCell(c - 1,ARow2).Y) then
      begin
        Result := False;
        Break;
      end;
    end;
  end;

  Result := Result and IsMerged;
end;

function TBaseGrid.ColSpanIdentical(ACol1,ACol2: Integer): Boolean;
var
  r: Integer;
begin
  Result := True;
  for r := 1 to RowCount do
  begin
    if (CellSpan(ACol1,r - 1).X > 0) and
       (CellSpan(ACol2,r - 1).X > 0) then
    begin
      if (BaseCell(ACol1,r - 1).X <> BaseCell(ACol1,r - 1).X) then
      begin
        Result := False;
        Break;
      end;
    end
    else
      if (CellSpan(ACol1,r - 1).X <> CellSpan(ACol2,r - 1).X) then
      begin
        Result := False;
        Break;
      end;
  end;
end;


function TBaseGrid.GetGridObject(c, r: Integer): TObject;
begin
  Result := inherited Objects[c,r]
end;

procedure TBaseGrid.SetGridObject(c, r: Integer; const Value: TObject);
begin
  inherited Objects[c,r] := Value;
end;

procedure TBaseGrid.FloatFooterUpdate;
begin

end;

function TBaseGrid.GetGridCell(c, r: Integer): string;
begin
  Result := inherited Cells[c,r];
end;

procedure TBaseGrid.SetGridCell(c, r: Integer; const Value: string);
begin
  inherited Cells[c,r] := Value;
end;

procedure TBaseGrid.ClearPropRect(ACol1, ARow1, ACol2, ARow2: Integer);
var
  c,r: Integer;
begin
  for c := ACol1 to ACol2 do
   for r := ARow1 to ARow2 do
     if Assigned(inherited Objects[c,r]) then
     begin
       TCellProperties(inherited Objects[c,r]).Free;
       inherited Objects[c,r] := nil;
     end;
end;

procedure TBaseGrid.ClearPropRow(ARow: Integer);
begin
  ClearPropRect(0,ARow,ColCount - 1,ARow);
end;

procedure TBaseGrid.ClearPropCell(ACol, ARow: Integer);
begin
  if Assigned(inherited Objects[ACol,ARow]) then
  begin
    TCellProperties(inherited Objects[ACol,ARow]).Free;
    inherited Objects[ACol,ARow] := nil;
  end;
end;


procedure TBaseGrid.ClearProps;
begin
  ClearPropRect(0,0,ColCount - 1,RowCount - 1);
end;

{$IFNDEF DELPHI6_LVL}
procedure TBaseGrid.SetGridOrientation(RightToLeftOrientation: Boolean);
var
  Org: TPoint;
  Ext: TPoint;
begin
  if RightToLeftOrientation then
  begin
    Org := Point(ClientWidth,0);
    Ext := Point(-1,1);
    SetMapMode(Canvas.Handle, mm_Anisotropic);
    SetWindowOrgEx(Canvas.Handle, Org.X, Org.Y, nil);
    SetViewportExtEx(Canvas.Handle, ClientWidth, ClientHeight, nil);
    SetWindowExtEx(Canvas.Handle, Ext.X*ClientWidth, Ext.Y*ClientHeight, nil);
  end
  else
  begin
    Org := Point(0,0);
    Ext := Point(1,1);
    SetMapMode(Canvas.Handle, mm_Anisotropic);
    SetWindowOrgEx(Canvas.Handle, Org.X, Org.Y, nil);
    SetViewportExtEx(Canvas.Handle, ClientWidth, ClientHeight, nil);
    SetWindowExtEx(Canvas.Handle, Ext.X*ClientWidth, Ext.Y*ClientHeight, nil);
  end;
end;
{$ENDIF}


procedure TBaseGrid.GetDisplText(c, r: Integer; var Value: string);
begin
  if Assigned(OnGetDisplText) then
    OnGetDisplText(Self,c,r,Value)
end;

{ TCellProperties }

procedure TCellProperties.Assign(Source: TPersistent);
begin
  FIsBaseCell := TCellProperties(Source).IsBaseCell;
  FCellSpanX := TCellProperties(Source).CellSpanX;
  FCellSpanY := TCellProperties(Source).CellSpanY;
  FOwnerRow := TCellProperties(Source).OwnerRow;
  FOwnerCol := TCellProperties(Source).OwnerCol;

  FAlignment := TCellProperties(Source).Alignment;
  FBorderColor := TCellProperties(Source).BorderColor;
  FBorderWidth := TCellProperties(Source).BorderWidth;
  FBrushColor := TCellProperties(Source).BrushColor;
  FBrushStyle := TCellProperties(Source).BrushStyle;
  FFontColor := TCellProperties(Source).FontColor;
  FFontStyle := TCellProperties(Source).FontStyle;
  FFontName := TCellProperties(Source).FontName;
  FFontSize := TCellProperties(Source).FontSize;
  FReadOnly := TCellProperties(Source).ReadOnly;
  FEditor := TCellProperties(Source).Editor;
  FValignment := TCellProperties(Source).VAlignment;
  WordWrap := TCellProperties(Source).WordWrap;
  NodeLevel := TCellProperties(Source).NodeLevel;

  Control := TCellProperties(Source).Control;
end;

constructor TCellProperties.Create(AOwner: TBaseGrid; ACol, ARow:integer);
begin
  inherited Create;
  FObject := nil;
  FGraphicObject := nil;
  FIsBaseCell := True;
  FCellSpanX := -1;
  FCellSpanY := -1;

  FBrushColor := clNone;
  FFontColor := clNone;

  FOwnerGrid := AOwner;
  FOwnerCol := ACol;
  FOwnerRow := ARow;
  FCalcObject := nil;
  FNodeLevel := 0;
end;

function TCellProperties.GetBaseCell(c, r: Integer): TPoint;
begin
  if IsBaseCell then
    Result := Point(c,r)
  else
  begin
    if (CellSpanX <> - 1) and (CellSpanY <> - 1) then
      Result := Point(c - CellSpanX,r - CellSpanY)
    else
      Result := Point(c,r)
  end;
end;

procedure TCellProperties.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
end;

procedure TCellProperties.SetBrushColor(const Value: TColor);
begin
  FBrushColor := Value;
  FOwnerGrid.RepaintCell(FOwnerCol, FOwnerRow);
end;

procedure TCellProperties.SetVAlignment(const Value: TVAlignment);
begin
  FValignment := Value;
  FOwnerGrid.RepaintCell(FOwnerCol, FOwnerRow);
end;

procedure TCellProperties.SetWordWrap(const Value: Boolean);
begin
  FWordWrap := Value;
  FOwnerGrid.RepaintCell(FOwnerCol, FOwnerRow);
end;



end.
