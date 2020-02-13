{*************************************************************************}
{ Arrow col and row move indicators support file                          }
{ for Delphi & C++Builder                                                 }
{ version 2.4                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{            copyright © 1996-2002                                        }
{            Email : info@tmssoftware.com                                 }
{            Web : http://www.tmssoftware.com                             }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit AdvObj;

{$I TMSDEFS.INC}

interface

uses
  Windows, StdCtrls, Controls, Graphics, ExtCtrls, Dialogs, Classes, Messages,
  SysUtils;

type
  TArrowDirection = (arrUp,arrDown,arrLeft,arrRight);

  TImageChangeEvent = procedure (Sender:TObject;Acol,Arow: Integer) of object;

  TArrowWindow = class(TPanel)
  private
    Dir: TArrowDirection;
    Arrow: array[0..8] of TPoint;
  public
    constructor Init(AOwner: TComponent;direction:TArrowDirection);
    procedure Loaded; override;
  protected
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TPopupButton = class(TCustomControl)
  private
    FCaption: string;
    FFlat: boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure Paint; override;
    procedure CreateWnd; override;
  published
    property Caption:string read FCaption write FCaption;
    property Flat: boolean read FFlat write FFlat;
  end;

  TIntList = class(TList)
  private
    FOnChange: TImageChangeEvent;
    FCol,FRow: Integer;
    procedure SetInteger(Index: Integer; Value: Integer);
    function GetInteger(Index: Integer):Integer;
    function GetStrValue: string;
    procedure SetStrValue(const Value: string);
  public
    constructor Create(Col,Row: Integer);
    property Items[index: Integer]: Integer read GetInteger write SetInteger; default;
    procedure Add(Value: Integer);
    procedure Insert(Index,Value: Integer);
    procedure Delete(Index: Integer);
    property StrValue: string read GetStrValue write SetStrValue;
  published
    property OnChange: TImageChangeEvent read FOnChange write FOnChange;
  end;

  TSortIndexList = class(TIntList)
  private
    function GetSortColumns(i: Integer): Integer;
    function GetSortDirections(i: Integer): Boolean;
    procedure SetSortColumns(i: Integer; const Value: Integer);
    procedure SetSortDirections(i: Integer; const Value: Boolean);
  public
    procedure AddIndex(ColumnIndex: integer; Ascending:boolean);
    function FindIndex(ColumnIndex: integer):integer;
    procedure ToggleIndex(ColumnIndex: integer);
    property SortColumns[i: Integer]: Integer read GetSortColumns write SetSortColumns;
    property SortDirections[i: Integer]: Boolean read GetSortDirections write SetSortDirections;
  end;

  TFilePicture = class(TPersistent)
  private
    FFilename: string;
    FWidth: Integer;
    FHeight: Integer;
    FPicture: TPicture;
    procedure SetFileName(const Value: string);
  public
    procedure DrawPicture(Canvas:TCanvas;r:TRect);
    procedure Assign(Source: TPersistent); override;
  published
    property Filename:string read FFileName write SetFileName;
    property Width:integer read FWidth;
    property Height:integer read FHeight;
  end;



implementation

{ TArrowWindow }

procedure TArrowWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP; // or WS_BORDER;
  end;
end;

procedure TArrowWindow.Loaded;
begin
  inherited;
end;


procedure TArrowWindow.CreateWnd;
var
  hrgn: THandle;

begin
  inherited;

  case Dir of
  arrDown:begin
         arrow[0] := point(3,0);
         arrow[1] := point(7,0);
         arrow[2] := point(7,4);
         arrow[3] := point(9,4);
         arrow[4] := point(5,8);
         arrow[5] := point(1,4);
         arrow[6] := point(3,4);
         end;
  arrUp:begin
         arrow[0] := point(5,0);
         arrow[1] := point(10,5);
         arrow[2] := point(7,5);
         arrow[3] := point(7,9);
         arrow[4] := point(3,9);
         arrow[5] := point(3,5);
         arrow[6] := point(0,5);
       end;
  arrLeft:begin
         arrow[0] := point(0,3);
         arrow[1] := point(0,7);
         arrow[2] := point(4,7);
         arrow[3] := point(4,10);
         arrow[4] := point(8,5);
         arrow[5] := point(4,0);
         arrow[6] := point(4,3);
         end;
  arrRight:begin
         arrow[0] := point(0,5);
         arrow[1] := point(4,10);
         arrow[2] := point(4,7);
         arrow[3] := point(8,7);
         arrow[4] := point(8,3);
         arrow[5] := point(4,3);
         arrow[6] := point(4,0);
         end;
  end;
  hrgn := CreatePolygonRgn(arrow,7,WINDING);
  SetWindowRgn(Handle,hrgn,True);
end;

procedure TArrowWindow.Paint;
begin
  inherited;
end;

constructor TArrowWindow.Init(AOwner: TComponent; Direction:TArrowDirection);
begin
  Dir := Direction;
  inherited Create(aOwner);
  Color := clLime;
  Parent := TWinControl(AOwner);
  Visible := False; 
end;

{ TIntList }

constructor TIntList.Create(Col,Row: Integer);
begin
  inherited Create;
  FCol := Col;
  FRow := Row;
end;

procedure TIntList.SetInteger(Index:Integer;Value:Integer);
begin
  inherited Items[Index] := Pointer(Value);
  if Assigned(OnChange) then
    OnChange(Self,FCol,FRow);
end;

function TIntList.GetInteger(Index: Integer): Integer;
begin
  Result := Integer(inherited Items[Index]);
end;

procedure TIntList.Add(Value: Integer);
begin
  inherited Add(Pointer(Value));
  if Assigned(OnChange) then
    OnChange(Self,FCol,FRow);
end;

procedure TIntList.Delete(Index: Integer);
begin
  inherited Delete(Index);
  if Assigned(OnChange) then
    OnChange(Self,FCol,FRow);
end;

function TIntList.GetStrValue: string;
var
  i: integer;
begin
  for i := 1 to Count do
    if i = 1 then
      Result:= IntToStr(Items[i - 1])
    else
      Result := Result + ',' + IntToStr(Items[i - 1]);
end;

procedure TIntList.SetStrValue(const Value: string);
var
  sl:TStringList;
  i: Integer;
begin
  sl := TStringList.Create;
  sl.CommaText := Value;
  Clear;
  for i := 1 to sl.Count do
   Add(StrToInt(sl.Strings[i - 1]));
  sl.Free;
end;

procedure TIntList.Insert(Index, Value: Integer);
begin
  inherited Insert(Index, Pointer(Value));
end;

{ TFilePicture }

procedure TFilePicture.Assign(Source: TPersistent);
begin
  FFileName := TFilePicture(Source).Filename;
  FWidth := TFilePicture(Source).Width;
  FHeight := TFilePicture(Source).Height;
end;

procedure TFilePicture.DrawPicture(Canvas: TCanvas; r: TRect);
begin
  if FFilename = '' then
    Exit;

  FPicture := TPicture.Create;
  FPicture.LoadFromFile(FFilename);
  Canvas.StretchDraw(r,FPicture.Graphic);
  FPicture.Free;
end;

procedure TFilePicture.SetFileName(const Value: string);
begin
  FFileName := Value;
  FPicture := TPicture.Create;
  FPicture.LoadFromFile(FFilename);
  FWidth := FPicture.Width;
  FHeight := FPicture.Height;
  FPicture.Free;
end;

{ TSortIndexList }

procedure TSortIndexList.AddIndex(ColumnIndex: Integer;
  Ascending: boolean);
begin
  if Ascending then
    Add(ColumnIndex)
  else
    Add(integer($80000000) or ColumnIndex);
end;

function TSortIndexList.FindIndex(ColumnIndex: integer): integer;
var
  i: Integer;
begin
  Result := -1;
  i := 0;
  while i < Count do
  begin
    if Items[i] and $7FFFFFFF = ColumnIndex then
    begin
      Result := i;
      Break;
    end;
    Inc(i);
  end;
end;

function TSortIndexList.GetSortColumns(i: Integer): Integer;
begin
  Result := Items[i] and $7FFFFFFF;
end;

function TSortIndexList.GetSortDirections(i: Integer): Boolean;
begin
  Result := (Items[i] and $80000000) = $80000000;
end;

procedure TSortIndexList.SetSortColumns(i: Integer; const Value: Integer);
begin
  Items[i] := (DWord(Value) and $7FFFFFFF) + (Items[i] and $80000000);
end;

procedure TSortIndexList.SetSortDirections(i: Integer;
  const Value: Boolean);
begin
  if Value then
    Items[i] := (Items[i] and $7FFFFFFF)
  else
    Items[i] := (DWord(Items[i]) or $80000000);
end;

procedure TSortIndexList.ToggleIndex(ColumnIndex: integer);
var
  i: Integer;
begin
  i := 0;
  while i < Count do
  begin
    if Items[i] and $7FFFFFFF = ColumnIndex then
    begin
      if Items[i] and $80000000 = $80000000 then
        Items[i] := Items[i] and $7FFFFFFF
      else
        Items[i] := Items[i] or Integer($80000000);
      Break;
    end;
    Inc(i);
  end;
end;

{ TPopupButton }

procedure TPopupButton.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := WS_POPUP or WS_BORDER or WS_DISABLED;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
  Color := clBtnFace;
end;


procedure TPopupButton.CreateWnd;
begin
  inherited;
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
end;

procedure TPopupButton.Paint;
var
  r: TRect;
begin
  r := GetClientRect;
  if not FFlat then
    Frame3D(Canvas,r,clWhite,clGray,1);
  SetBkMode(Canvas.Handle,TRANSPARENT);
  DrawTextEx(Canvas.Handle,PChar(FCaption),Length(FCaption),r,DT_CENTER or DT_END_ELLIPSIS,nil);
end;



end.
