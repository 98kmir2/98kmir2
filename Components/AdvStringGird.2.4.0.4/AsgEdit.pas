{*********************************************************************}
{ TEditBtn &  TAsgUnitEditBtn component for TAdvStringGrid            }
{ for Delphi & C++Builder                                             }
{ version 1.3                                                         }
{                                                                     }
{ written by TMS Software                                             }
{            copyright © 1998-2002                                    }
{            Email : info@tmssoftware.com                             }
{            Web : http://www.tmssoftware.com                         }
{                                                                     }
{ The source code is given as is. The author is not responsible       }
{ for any possible damage done due to the use of this code.           }
{ The component can be freely used in any application. The source     }
{ code remains property of the author and may not be distributed      }
{ freely as such.                                                     }
{*********************************************************************}

unit ASGEdit;

{$I TMSDEFS.INC}

interface

uses Windows, Classes, StdCtrls, ExtCtrls, Controls, Messages, SysUtils,
     Graphics, Buttons, Forms, AdvXPVS;

const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}

type

  TNumGlyphs = Buttons.TNumGlyphs;

  TAdvSpeedButton = class(TSpeedButton)
  private
    FIsWinXP: Boolean;
    FFlat: Boolean;
    FHot: Boolean;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  protected
    procedure Paint; override;
  public
    property Hot: Boolean read FHot write FHot;
  published
    property IsWinXP: Boolean read FIsWinXP write FIsWinXP;
    property Flat: Boolean read FFlat write FFlat;
  end;


{ TAsgEditButton }

  TAsgEditButton = class (TWinControl)
  private
    FButton: TAdvSpeedButton;
    FFocusControl: TWinControl;
    FOnClick: TNotifyEvent;
    FFlat: Boolean;
    function CreateButton: TAdvSpeedButton;
    function GetGlyph: TBitmap;
    procedure SetGlyph(Value: TBitmap);
    function GetNumGlyphs: TNumGlyphs;
    procedure SetNumGlyphs(Value: TNumGlyphs);
    procedure SetCaption(value:string);
    function GetCaption:string;
    procedure BtnClick(Sender: TObject);
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    {$IFDEF DELPHI4_LVL}
    procedure AdjustSize (var W, H: Integer); reintroduce;
    {$ELSE}
    procedure AdjustSize (var W, H: Integer);
    {$ENDIF}
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure SetFlat(const Value: Boolean);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property Align;
    property Ctl3D;
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property ButtonCaption:string read GetCaption write SetCaption;
    property NumGlyphs: TNumGlyphs read GetNumGlyphs write SetNumGlyphs default 1;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FocusControl: TWinControl read FFocusControl write FFocusControl;
    property Flat: Boolean read FFlat write SetFlat;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$IFDEF WIN32}
    property OnStartDrag;
    {$ENDIF}
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

{ TAsgEditBtn }

  TAsgEditBtn = class(TCustomEdit)
  private
    FUnitSize : integer;
    FRightAlign:boolean;
    FButton: TAsgEditButton;
    FEditorEnabled: Boolean;
    FOnClickBtn:TNotifyEvent;
    FButtonWidth: Integer;
    FIsWinXP: Boolean;
    //FGlyph: TBitmap;
    function GetMinHeight: Integer;
    procedure SetEditRect;
    procedure SetGlyph(value:tBitmap);
    function GetGlyph:TBitmap;
    procedure SetCaption(value:string);
    function GetCaption:string;
    procedure SetRightAlign(value : boolean);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;
    procedure WMPaste(var Message: TWMPaste);   message WM_PASTE;
    procedure WMCut(var Message: TWMCut);   message WM_CUT;
    procedure WMPaint(var Msg: TWMPAINT); message WM_PAINT;
    procedure WMChar(var Message: TWMChar); message WM_CHAR;
    procedure SetButtonWidth(const Value: Integer);
    procedure SetIsWinXP(const Value: Boolean);
  protected
    procedure BtnClick(Sender: TObject); virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Button: TAsgEditButton read FButton;
  published
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property EditorEnabled: Boolean read FEditorEnabled write FEditorEnabled default True;
    property Enabled;
    property Font;
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property IsWinXP: Boolean read FIsWinXP write SetIsWinXP;
    property ButtonCaption:string read GetCaption write SetCaption;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RightAlign:boolean read FRightAlign write SetRightAlign;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property Height;
    property Width;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    {$IFDEF WIN32}
    property OnStartDrag;
    {$ENDIF}
    property OnClickBtn: TNotifyEvent read FOnClickBtn write FOnClickBtn;
  end;

  TAsgUnitEditBtn = class(TAsgEditBtn)
  private
    fUnitID:string;
    fUnits:tstringlist;
    procedure SetUnitSize(value: Integer);
    function GetUnitSize: Integer;
    procedure SetUnits(value:tstringlist);
    procedure SetUnitID(value:string);
    procedure WMPaint(var Msg: TWMPAINT); message WM_PAINT;
    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
  protected
    procedure BtnClick (Sender: TObject); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Units:tstringlist read fUnits write SetUnits;
    property UnitID:string read fUnitID write SetUnitID;
    property UnitSpace:integer read GetUnitSize write SetUnitSize;
  end;

implementation

{ TAsgEditButton }

constructor TAsgEditButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] +
    [csFramed, csOpaque];
  FButton := CreateButton;
  Glyph := nil;
  Width := 20;
  Height := 25;
end;

function TAsgEditButton.CreateButton: TAdvSpeedButton;
begin
 Result := TAdvSpeedButton.Create(Self);
 Result.OnClick := BtnClick;
 Result.OnMouseUp := BtnMouseDown;
 Result.Visible := True;
 Result.Enabled := True;
 Result.Parent := Self;
 Result.Caption := '';
end;

procedure TAsgEditButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then
    FFocusControl := nil;
end;

procedure TAsgEditButton.AdjustSize (var W: Integer; var H: Integer);
begin
  if (FButton = nil) or (csLoading in ComponentState) then Exit;
  if W < 15 then W := 15;
  FButton.SetBounds (0, 0, W, H);
end;

procedure TAsgEditButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TAsgEditButton.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;
  { check for minimum size }
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds(Left, Top, W, H);
  Message.Result := 0;
end;

procedure TAsgEditButton.BtnMouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if (Sender=FButton) then FOnClick(Self);

    if (FFocusControl <> nil) and FFocusControl.TabStop and
        FFocusControl.CanFocus and (GetFocus <> FFocusControl.Handle) then
      FFocusControl.SetFocus
    else if TabStop and (GetFocus <> Handle) and CanFocus then
      SetFocus;
  end;
end;

procedure TAsgEditButton.BtnClick(Sender: TObject);
begin
end;

procedure TAsgEditButton.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
end;

function TAsgEditButton.GetGlyph: TBitmap;
begin
  Result := FButton.Glyph;
end;

procedure TAsgEditButton.SetGlyph(Value: TBitmap);
begin
  FButton.Glyph := Value;
end;

procedure TAsgEditButton.SetCaption(value:string);
begin
  FButton.Caption := Value;
end;

function TAsgEditButton.GetCaption:string;
begin
  Result := FButton.Caption;
end;

function TAsgEditButton.GetNumGlyphs: TNumGlyphs;
begin
  Result := FButton.NumGlyphs;
end;

procedure TAsgEditButton.SetNumGlyphs(Value: TNumGlyphs);
begin
 FButton.NumGlyphs := Value;
end;

{ TSpinEdit }

constructor TAsgEditBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButton := TAsgEditButton.Create (Self);
  FButton.Width := 18;
  FButton.Height := 18;
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.FocusControl := Self;
  FButton.OnClick := BtnClick;
  Text := '0';
  ControlStyle := ControlStyle - [csSetCaption];
  FEditorEnabled := True;
  FRightAlign := False;
  FUnitSize:=0;
end;

destructor TAsgEditBtn.Destroy;
begin
  FButton := nil;
  inherited Destroy;
end;

procedure TAsgEditBtn.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if FRightAlign then
    Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN or ES_RIGHT
  else
    Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TAsgEditBtn.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;

procedure TAsgEditBtn.SetGlyph(value:TBitmap);
begin
  FButton.Glyph := Value;
end;

function TAsgEditBtn.GetGlyph:TBitmap;
begin
  Result := FButton.Glyph;
end;

procedure TAsgEditBtn.SetCaption(value:string);
begin
  FButton.ButtonCaption := Value;
end;

function TAsgEditBtn.GetCaption:string;
begin
  Result := FButton.ButtonCaption;
end;

procedure TAsgEditBtn.SetEditRect;
var
  Loc: TRect;
begin
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := ClientWidth - FButton.Width - 3 - FUnitsize;
  if self.BorderStyle=bsNone then
   begin
    Loc.Top := 2;
    Loc.Left := 2;
   end
  else
   begin
    Loc.Top := 1;
    Loc.Left := 1;
   end;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));  {debug}
end;

procedure TAsgEditBtn.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
  Dist:integer;
begin
  inherited;
  if BorderStyle = bsNone then
    Dist := 1
  else
    Dist := 5;

  MinHeight := GetMinHeight;
    { text edit bug: if size to less than minheight, then edit ctrl does
      not display the text }

  if Height < MinHeight then
    Height := MinHeight
  else if FButton <> nil then
  begin
    if NewStyleControls and Ctl3D then
      FButton.SetBounds(Width - FButton.Width - Dist, 0, FButton.Width, Height - Dist)
    else FButton.SetBounds (Width - FButton.Width, 1, FButton.Width, Height - 3);
    SetEditRect;
  end;
end;

function TAsgEditBtn.GetMinHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  I := SysMetrics.tmHeight;
  if I > Metrics.tmHeight then I := Metrics.tmHeight;
  {Result := Metrics.tmHeight + I div 4 + GetSystemMetrics(SM_CYBORDER) * 4 +2;}
  Result := Metrics.tmHeight + I div 4 {+ GetSystemMetrics(SM_CYBORDER) * 4};
end;

procedure TAsgEditBtn.BtnClick (Sender: TObject);
begin
  if Assigned(FOnClickBtn) then
    FOnClickBtn(Sender);
end;

procedure TAsgEditBtn.WMPaste(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TAsgEditBtn.WMCut(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TAsgEditBtn.CMExit(var Message: TCMExit);
begin
  inherited;
end;

procedure TAsgEditBtn.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and not (csLButtonDown in ControlState) then
    SelectAll;
  inherited;
end;

procedure TAsgEditBtn.SetRightAlign(value: boolean);
begin
  if FRightAlign <> Value then
  begin
    FRightAlign := Value;
    Recreatewnd;
  end;
end;

procedure TAsgEditBtn.WMPaint(var Msg: TWMPAINT);
var
  hdc: THandle;
begin
  inherited;
  hdc := GetDC(Handle);
  Releasedc(Handle,hdc);
end;

procedure TAsgEditBtn.KeyPress(var Key: Char);
begin
  inherited;
end;

procedure TAsgEditBtn.WMChar(var Message: TWMChar);
begin
  if not FEditorEnabled then
    Exit;
  Inherited;
end;

procedure TAsgEditBtn.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if key = VK_F4 then BtnClick(self);
end;

procedure TAsgEditBtn.SetIsWinXP(const Value: Boolean);
begin
  FIsWinXP := Value;
  FButton.FButton.IsWinXP := Value;
end;

procedure TAsgEditButton.SetFlat(const Value: Boolean);
begin
  FFlat := Value;
  FButton.Flat := FFlat;
end;

{  TAsgUnitEditBtn }
procedure  TAsgUnitEditBtn.BtnClick(Sender: TObject);
var
  popmenu: THandle;
  pt: TPoint;
  i: Integer;
begin
  pt := ClientToScreen(point(0,0));
  popmenu := CreatePopupMenu;

  for i := 1 to FUnits.Count do
    InsertMenu(popmenu,$FFFFFFFF,MF_BYPOSITION ,i,pchar(fUnits.Strings[i-1]));
  TrackPopupMenu(popmenu,TPM_LEFTALIGN or TPM_LEFTBUTTON,pt.x+ClientWidth-15,pt.y+ClientHeight,0,self.handle,nil);

  DestroyMenu(popmenu);
end;

constructor TAsgUnitEditBtn.Create(AOwner: TComponent);
begin
  inherited Create(aOwner);
  FUnitSize := 20;
  FUnits := TStringList.Create;
  FRightAlign := True;
end;

destructor TAsgUnitEditBtn.Destroy;
begin
  FUnits.Free;
  inherited Destroy;
end;

procedure  TAsgUnitEditBtn.SetUnitID(Value: string);
begin
  FUnitID := Value;
  Repaint;
end;

procedure TAsgUnitEditBtn.SetUnits(Value: TStringList);
begin
  if Assigned(Value) then
    FUnits.Assign(Value);
end;

function TAsgUnitEditBtn.GetUnitSize: Integer;
begin
  Result := FUnitSize;
end;


procedure TAsgUnitEditBtn.SetUnitSize(value: integer);
begin
  FUnitSize := Value;
  SetEditRect;
  Repaint;
end;

procedure  TAsgUnitEditBtn.WMCommand(var Message: TWMCommand);
begin
  UnitID := FUnits.Strings[message.itemID - 1];
end;

procedure  TAsgUnitEditBtn.WMPaint(var Msg: TWMPAINT);
var
  hdc: THandle;
  oldfont: THandle;
  r: TRect;
begin
  inherited;
  hdc := GetDC(Handle);
  r.Left := ClientWidth - FButton.Width - 3 - fUnitsize;
  r.Right := r.left + FUnitSize;
  r.Top := 2;
  r.Bottom := ClientHeight;
  oldfont := SelectObject(HDC,Font.Handle);
  DrawText(hdc,pchar(FUnitID),Length(FUnitID),r,DT_LEFT or DT_EDITCONTROL);
  SelectObject(hdc,oldfont);
  ReleaseDC(Handle,hdc);
end;


procedure TAsgEditBtn.SetButtonWidth(const Value: Integer);
begin
  FButtonWidth := Value;
  FButton.Width := Value;
end;

{ TAdvSpeedButton }

procedure TAdvSpeedButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  Hot := True;
  Invalidate;
end;


procedure TAdvSpeedButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  Hot := False;
  Invalidate;
end;


procedure TAdvSpeedButton.Paint;
const
  DownStyles: array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
var
  PaintRect: TRect;
  DrawFlags: Integer;
  Offset: TPoint;
  HTheme: THandle;

begin
  Canvas.Font := Self.Font;
  PaintRect := Rect(0, 0, Width, Height);

  if FIsWinXP then
  begin
    HTheme := OpenThemeData(Parent.Handle,'button');

    if FState in [bsDown, bsExclusive] then
      DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_PRESSED,@PaintRect,nil)
    else
      if Hot then
        DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_HOT,@PaintRect,nil)
      else
        DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_NORMAL,@PaintRect,nil);

    CloseThemeData(HTheme);
  end
  else
  begin
    if not FFlat then
    begin
      DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
      if FState in [bsDown, bsExclusive] then
        DrawFlags := DrawFlags or DFCS_PUSHED;
      DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
    end
    else
    begin
      DrawEdge(Canvas.Handle, PaintRect, DownStyles[FState in [bsDown, bsExclusive]],
        BF_MIDDLE or BF_RECT);
      InflateRect(PaintRect, -1, -1);
    end;
  end;

  if not (FState in [bsDown, bsExclusive]) then
  begin
    Offset.X := 0;
    Offset.Y := 0;
  end;

  if Assigned(Glyph) then
    if not Glyph.Empty then
    begin
      Glyph.Transparent := True;
      Offset.X := 0;
      Offset.Y := 0;
      if Glyph.Width < Width then
        Offset.X := (Width - Glyph.Width) shr 1;
      if Glyph.Height < Height then
        Offset.Y := (Height - Glyph.Height) shr 1;

      if FState = bsDown then
        Canvas.Draw(Offset.X + 1 ,Offset.Y + 1,Glyph)
      else
        Canvas.Draw(Offset.X ,Offset.Y,Glyph)
    end;

  SetBkMode(Canvas.Handle,Windows.TRANSPARENT);
  if FState = bsDown then
    Canvas.TextOut(3,3,Caption)
  else
    Canvas.TextOut(2,2,Caption)
end;


end.

