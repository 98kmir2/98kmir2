{*************************************************************************}
{ TAdvStringGrid spin editor                                              }
{ for Delphi & C++Builder                                                 }
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

unit asgspin;
                                             
{$I TMSDEFS.INC}

interface

uses Windows, Classes, StdCtrls, ExtCtrls, Controls, Messages, SysUtils,
  Forms, Graphics, Menus, Buttons, dialogs, Mask, AdvXPVS;

{$R ASGSPIN.RES}

type
  TNumGlyphs = Buttons.TNumGlyphs;

  TAdvTimerSpeedButton = class;

{ TAsgSpinButton }

  TSpinDirection = (spVertical,spHorizontal);

  TAsgSpinButton = class (TWinControl)
  private
    FUpButton: TAdvTimerSpeedButton;
    FDownButton: TAdvTimerSpeedButton;
    FFocusedButton: TAdvTimerSpeedButton;
    FFocusControl: TWinControl;
    FOnUpClick: TNotifyEvent;
    FOnDownClick: TNotifyEvent;
    FDirection: TSpinDirection;
    FIsWinXP: Boolean;
    //FHasUpRes,FHasDownRes:boolean;
    function CreateButton: TAdvTimerSpeedButton;
    function GetUpGlyph: TBitmap;
    function GetDownGlyph: TBitmap;
    procedure SetUpGlyph(Value: TBitmap);
    procedure SetDownGlyph(Value: TBitmap);
    function GetUpNumGlyphs: TNumGlyphs;
    function GetDownNumGlyphs: TNumGlyphs;
    procedure SetUpNumGlyphs(Value: TNumGlyphs);
    procedure SetDownNumGlyphs(Value: TNumGlyphs);
    procedure BtnClick(Sender: TObject);
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetFocusBtn (Btn: TAdvTimerSpeedButton);
    procedure SetDirection(const Value: TSpinDirection);
    {$IFDEF DELPHI4_LVL}
    procedure AdjustSize (var W, H: Integer); reintroduce;
    {$ELSE}
    procedure AdjustSize (var W, H: Integer);
    {$ENDIF}
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure SetIsWinXP(const Value: Boolean);
  protected
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property IsWinXP: Boolean read FIsWinXP write SetIsWinXP;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property Align;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property Constraints;
    {$ENDIF}
    property Ctl3D;
    property Direction: TSpinDirection read fDirection write SetDirection;
    property DownGlyph: TBitmap read GetDownGlyph write SetDownGlyph;
    property DownNumGlyphs: TNumGlyphs read GetDownNumGlyphs write SetDownNumGlyphs default 1;
    property DragCursor;
    {$IFDEF DELPHI4_LVL}
    property DragKind;
    {$ENDIF}
    property DragMode;
    property Enabled;
    property FocusControl: TWinControl read FFocusControl write FFocusControl;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UpGlyph: TBitmap read GetUpGlyph write SetUpGlyph;
    property UpNumGlyphs: TNumGlyphs read GetUpNumGlyphs write SetUpNumGlyphs default 1;
    property Visible;
    property OnDownClick: TNotifyEvent read FOnDownClick write FOnDownClick;
    property OnDragDrop;
    property OnDragOver;
    {$IFDEF DELPHI4_LVL}
    property OnEndDock;
    {$ENDIF}
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$IFDEF DELPHI4_LVL}
    property OnStartDock;
    {$ENDIF}
    property OnStartDrag;
    property OnUpClick: TNotifyEvent read FOnUpClick write FOnUpClick;
  end;

{ TAsgSpinEdit }

  TAsgSpinType = (sptNormal,sptFloat,sptDate,sptTime);

  TAsgSpinEdit = class(TCustomMaskEdit)
  private
    FMinValue: LongInt;
    FMaxValue: LongInt;
    FMinFloatValue: double;
    FMaxFloatValue: double;
    FMinDateValue: tdatetime;
    FMaxDateValue: tdatetime;
    FDateValue: tdatetime;
    FTimeValue: tdatetime;
    FIncrement: LongInt;
    FIncrementFloat : double;
    FButton: TAsgSpinButton;
    FEditorEnabled: Boolean;
    FDirection: TSpinDirection;
    FSpinType:TAsgSpinType;
    FPrecision: integer;
    FReturnIsTab: boolean;
    FIsWinXP: Boolean;
    {$IFDEF DELPHI3_LVL}
    FSpinFlat : Boolean;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    FSpinTransparent : Boolean;
    {$ENDIF}
    function GetMinHeight: Integer;
    function GetValue: LongInt;
    function CheckValue (NewValue: LongInt): LongInt;
    procedure SetValue (NewValue: LongInt);
    function GetFloatValue: double;
    function CheckFloatValue (NewValue: double): double;
    function CheckDateValue (NewValue: tdatetime): tdatetime;
    procedure SetFloatValue (NewValue: double);
    procedure SetEditRect;
    procedure SetEditorEnabled(NewValue:boolean);
    procedure SetDirection(const Value: TSpinDirection);
    procedure SetPrecision(const Value: integer);
    procedure SetSpinType(const Value: TAsgSpinType);
    function GetTimeValue: tdatetime;
    procedure SetTimeValue(const Value: tdatetime);
    function GetDateValue: tdatetime;
    procedure SetDateValue(const Value: tdatetime);
    {$IFDEF DELPHI3_LVL}
    procedure SetSpinFlat(const Value : boolean);
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    procedure SetSpinTransparent(const value : boolean);
    {$ENDIF}
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;
    procedure WMPaste(var Message: TWMPaste);   message WM_PASTE;
    procedure WMCut(var Message: TWMCut);   message WM_CUT;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure SetIsWinXP(const Value: Boolean);
  protected
    {$IFDEF DELPHI3_LVL}
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    {$ENDIF}
    function IsValidChar(var Key: Char): Boolean; virtual;
    procedure UpClick (Sender: TObject); virtual;
    procedure DownClick (Sender: TObject); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    property IsWinXP: Boolean read FIsWinXP write SetIsWinXP;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Button: TAsgSpinButton read FButton;
  published
    property Direction : TSpinDirection read fDirection write SetDirection;
    property ReturnIsTab: boolean read fReturnIsTab write fReturnIsTab;
    property Precision: integer read fPrecision write SetPrecision;
    property SpinType: TAsgSpinType read fSpinType write SetSpinType;
    property Value: LongInt read GetValue write SetValue;
    property FloatValue: double read GetFloatValue write SetFloatValue;
    property TimeValue: tdatetime read GetTimeValue write SetTimeValue;
    property DateValue: tdatetime read GetDateValue write SetDateValue;
    {$IFDEF DELPHI3_LVL}
    property SpinFlat : boolean read fSpinFlat write SetSpinFlat;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    property SpinTransparent : boolean read fSpinTransparent write SetSpinTransparent;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    {$ENDIF}
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property Color;
    {$IFDEF DELPHI4_LVL}
    property Constraints;
    {$ENDIF}
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property EditorEnabled: Boolean read FEditorEnabled write SetEditorEnabled default True;
    property Enabled;
    property Font;
    property Increment: LongInt read FIncrement write FIncrement default 1;
    property IncrementFloat: double read FIncrementFloat write FIncrementFloat;
    property MaxLength;
    property MaxValue: LongInt read FMaxValue write FMaxValue;
    property MinValue: LongInt read FMinValue write FMinValue;
    property MinFloatValue: double read fMinFloatValue write fMinFloatValue;
    property MaxFloatValue: double read fMaxFloatValue write fMaxFloatValue;
    property MinDateValue: tdatetime read fMinDateValue write fMinDateValue;
    property MaxDateValue: tdatetime read fMaxDateValue write fMaxDateValue;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
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
    property OnStartDrag;
  end;

  TAdvMaskSpinEdit = class(TAsgSpinEdit)
  published
    property EditMask;
  end;


{ TAdvTimerSpeedButton }

  TTimeBtnState = set of (tbFocusRect, tbAllowTimer);

  TButtonDirection = (bdLeft,bdRight,bdUp,bdDown);

  TAdvTimerSpeedButton = class(TSpeedButton)
  private
    FRepeatTimer: TTimer;
    FTimeBtnState: TTimeBtnState;
    FButtonDirection:TButtonDirection;
    FIsWinXP: Boolean;
    FHasMouse: Boolean;
    procedure TimerExpired(Sender: TObject);
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    property IsWinXP: Boolean read FIsWinXP write FIsWinXP;
  public
    destructor Destroy; override;
    property TimeBtnState: TTimeBtnState read FTimeBtnState write FTimeBtnState;
    property ButtonDirection: TButtonDirection read FButtonDirection write FButtonDirection;
  end;

implementation

const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}

function PosFrom(sub,s:string;n:integer):integer;
begin
  Delete(s,1,n);
  Result := Pos(sub,s);
  if Result > 0 then
    Result := Result + n;
end;

function IncYear(d:tdatetime;n:integer):tdatetime;
var
  da,mo,ye:word;
begin
  DecodeDate(d,ye,mo,da);
  ye := ye + n;
  Result := EncodeDate(ye,mo,da);
end;

{$IFNDEF DELPHI3_LVL}
function IncMonth(d:tdatetime;n:integer):tdatetime;
var
  da,mo,ye:word;
  nmo:integer;
begin
  DecodeDate(d,ye,mo,da);
  nmo := mo;

  nmo := nmo + n;

  while nmo < 1 do
  begin
    nmo := nmo + 12;
    ye := ye - 1;
  end;

  while nmo>12 do
  begin
    nmo := nmo - 12;
    ye := ye + 1;
  end;

  mo := nmo;

  result := EncodeDate(ye,mo,da);
end;
{$ENDIF}

{ TAsgSpinButton }

constructor TAsgSpinButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] +
    [csFramed, csOpaque];

  FUpButton := CreateButton;
  FDownButton := CreateButton;
  UpGlyph := nil;
  DownGlyph := nil;

  FUpButton.ButtonDirection:=bdUp;
  FDownButton.ButtonDirection:=bdDown;

  Width := 15;
  Height := 25;
  FFocusedButton := FUpButton;
end;

destructor TAsgSpinButton.Destroy;
begin
  inherited;
end;

function TAsgSpinButton.CreateButton: TAdvTimerSpeedButton;
begin
  Result := TAdvTimerSpeedButton.Create(Self);
  Result.OnClick := BtnClick;
  Result.OnMouseDown := BtnMouseDown;
  Result.Visible := True;
  Result.Enabled := True;
  Result.TimeBtnState := [tbAllowTimer];
  Result.Parent := Self;
end;

procedure TAsgSpinButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then
    FFocusControl := nil;
end;

procedure TAsgSpinButton.AdjustSize (var W, H: Integer);
begin
  if (FUpButton = nil) or (csLoading in ComponentState) then Exit;
  if FDirection = spVertical then
   begin
    if W < 15 then W := 15;
    FUpButton.SetBounds (0, 0, W, H div 2);
    FDownButton.SetBounds (0, FUpButton.Height - 1, W, H - FUpButton.Height + 1);
   end
  else
   begin
    if W < 20 then W := 20;
    FDownButton.SetBounds (0, 0, W div 2, H );
    FUpButton.SetBounds ((W div 2)+1, 0 , W div 2, H );
   end;
end;

procedure TAsgSpinButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TAsgSpinButton.WMSize(var Message: TWMSize);
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

procedure TAsgSpinButton.WMSetFocus(var Message: TWMSetFocus);
begin
  FFocusedButton.TimeBtnState := FFocusedButton.TimeBtnState + [tbFocusRect];
  FFocusedButton.Invalidate;
end;

procedure TAsgSpinButton.WMKillFocus(var Message: TWMKillFocus);
begin
  FFocusedButton.TimeBtnState := FFocusedButton.TimeBtnState - [tbFocusRect];
  FFocusedButton.Invalidate;
end;

procedure TAsgSpinButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_UP:
      begin
        SetFocusBtn (FUpButton);
        FUpButton.Click;
      end;
    VK_DOWN:
      begin
        SetFocusBtn (FDownButton);
        FDownButton.Click;
      end;
    VK_SPACE:
      FFocusedButton.Click;
  end;
end;

procedure TAsgSpinButton.BtnMouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    SetFocusBtn (TAdvTimerSpeedButton (Sender));
    if (FFocusControl <> nil) and FFocusControl.TabStop and
        FFocusControl.CanFocus and (GetFocus <> FFocusControl.Handle) then
      FFocusControl.SetFocus
    else if TabStop and (GetFocus <> Handle) and CanFocus then
      SetFocus;
  end;
end;

procedure TAsgSpinButton.BtnClick(Sender: TObject);
begin
  if Sender = FUpButton then
  begin
    if Assigned(FOnUpClick) then FOnUpClick(Self);
  end
  else
    if Assigned(FOnDownClick) then FOnDownClick(Self);
end;

procedure TAsgSpinButton.SetDirection(const Value:TSpinDirection);
begin
  if value <> FDirection then
  begin
    FDirection := Value;
    RecreateWnd;
    if fdirection = spVertical then
    begin
      Width := 15;
      FUpButton.FButtonDirection := bdUp;
      FDownButton.FButtonDirection := bdDown;
    end
    else
    begin
      Width := 20;
      FUpButton.FButtonDirection:=bdRight;
      FDownButton.FButtonDirection:=bdLeft;
    end;
  end;
end;

procedure TAsgSpinButton.SetFocusBtn (Btn: TAdvTimerSpeedButton);
begin
  if TabStop and CanFocus and  (Btn <> FFocusedButton) then
  begin
    FFocusedButton.TimeBtnState := FFocusedButton.TimeBtnState - [tbFocusRect];
    FFocusedButton := Btn;
    if (GetFocus = Handle) then
    begin
      FFocusedButton.TimeBtnState := FFocusedButton.TimeBtnState + [tbFocusRect];
      Invalidate;
    end;
  end;
end;

procedure TAsgSpinButton.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TAsgSpinButton.Loaded;
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

function TAsgSpinButton.GetUpGlyph: TBitmap;
begin
  Result := FUpButton.Glyph;
end;

procedure TAsgSpinButton.SetUpGlyph(Value: TBitmap);
begin
  if Value <> nil then
  begin
    FUpButton.Glyph := Value
  end
  else
  begin
    FUpButton.Glyph.LoadFromResourceName(hinstance,'AsgSpinUp');
    FUpButton.NumGlyphs := 1;
    FUpButton.Invalidate;
  end;
end;

function TAsgSpinButton.GetUpNumGlyphs: TNumGlyphs;
begin
  Result := FUpButton.NumGlyphs;
end;

procedure TAsgSpinButton.SetUpNumGlyphs(Value: TNumGlyphs);
begin
  FUpButton.NumGlyphs := Value;
end;

function TAsgSpinButton.GetDownGlyph: TBitmap;
begin
  Result := FDownButton.Glyph;
end;

procedure TAsgSpinButton.SetDownGlyph(Value: TBitmap);
begin
  if Value <> nil then
    FDownButton.Glyph := Value
  else
  begin
    FDownButton.Glyph.LoadFromResourceName(HInstance, 'AsgSpinDown');
    FUpButton.NumGlyphs := 1;
    FDownButton.Invalidate;
  end;
end;

function TAsgSpinButton.GetDownNumGlyphs: TNumGlyphs;
begin
  Result := FDownButton.NumGlyphs;
end;

procedure TAsgSpinButton.SetDownNumGlyphs(Value: TNumGlyphs);
begin
  FDownButton.NumGlyphs := Value;
end;

procedure TAsgSpinButton.SetIsWinXP(const Value: Boolean);
begin
  FIsWinXP := Value;
  FDownButton.IsWinXP := FIsWinXP;
  FFocusedButton.IsWinXP := FIsWinXP;
end;

{ TAsgSpinEdit }

constructor TAsgSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButton := TAsgSpinButton.Create (Self);
  FButton.Width := 15;
  FButton.Height := 17;
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.FocusControl := Self;
  FButton.OnUpClick := UpClick;
  FButton.OnDownClick := DownClick;
  Text := '0';
  ControlStyle := ControlStyle - [csSetCaption];
  FIncrement := 1;
  FEditorEnabled := True;
  FMinFloatValue:=0;
  FMinValue:=0;
  FMaxFloatValue:=100;
  FMaxValue:=100;
end;

destructor TAsgSpinEdit.Destroy;
begin
  FButton := nil;
  inherited Destroy;
end;

procedure TAsgSpinEdit.Loaded;
begin
  inherited;
  case fSpinType of
  sptDate:self.Text := DateToStr(FDateValue);
  sptTime:self.Text := TimeToStr(FTimeValue);
  end;
  SetSpinType(fSpinType);
end;

{$IFDEF DELPHI3_LVL}
procedure TAsgSpinEdit.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;
{$ENDIF}

procedure TAsgSpinEdit.WMKeyDown(var Message: TWMKeyDown);
begin

  case Message.CharCode of
  vk_up:
    begin
      UpClick (Self);
      Message.Result := 0;
      Exit;
    end;
  vk_down:
    begin
      DownClick(Self);
      Message.Result := 0;
      Exit;
    end;
  end;
  inherited;
end;

procedure TAsgSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case key of
  vk_delete:if not FEditorEnabled then Key := 0;
  vk_return:
    if FReturnIsTab then
    begin
      Key := vk_tab;
      PostMessage(self.Handle,wm_keydown,VK_TAB,0);
    end;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TAsgSpinEdit.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
    MessageBeep(0)
  end;
  if Key <> #0 then
    inherited KeyPress(Key);
end;

function TAsgSpinEdit.IsValidChar(var Key: Char): Boolean;
var
  dp: Integer;
  s: string;
begin
  Result := (Key in [DecimalSeparator,ThousandSeparator, TimeSeparator, DateSeparator,'+', '-', '0'..'9']) or
    ((Key < #32) and (Key <> Chr(VK_RETURN)));

  if (Key = TimeSeparator) and (Key <> '-') and (FSpinType <> sptTime) then
    Result := False;
  if (Key = DateSeparator) and (Key <> '-') and (FSpinType <> sptDate) then
    Result := False;

  if (FSpinType = sptFloat) and not (key in [chr(vk_escape),chr(vk_return),chr(vk_back)]) then
  begin
    if Key = ThousandSeparator then Key := DecimalSeparator;

    if (Key = DecimalSeparator) and (Pos(DecimalSeparator,Self.text)>0) then
      Result := False;

    dp := pos(decimalseparator,self.text);
    if (FPrecision > 0) and (dp > 0) and (SelStart >= dp) and (SelLength = 0) then
    begin
      if (Length(Self.Text) >= dp + FPrecision) then
        Result := False;
    end;
  end;

  if FSpinType = sptTime then
  begin
    s := Text;

    if (key = TimeSeparator) and (Pos(TimeSeparator,s) > 0) then
    begin
      Delete(s,Pos(TimeSeparator,s),1);
      if Pos(TimeSeparator,s) > 0 then
        Result := False;
    end;  
  end;

  if not FEditorEnabled and Result and ((Key >= #32) or
    (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE))) then
    Result := False;
end;

procedure TAsgSpinEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TAsgSpinEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;

procedure TAsgSpinEdit.SetDirection(const value: TSpinDirection);
begin
  if value <> FDirection then
  begin
    FDirection := Value;
    FButton.Direction := Value;
    Self.Width := Self.Width + 1;
    Self.Width := Self.Width - 1;
  end;
end;

procedure TAsgSpinEdit.SetEditorEnabled(NewValue:boolean);
begin
  FEditorEnabled:=NewValue;
end;

procedure TAsgSpinEdit.SetEditRect;
var
  Loc: TRect;
  Dist : integer;
begin
  if BorderStyle=bsNone then
    Dist:=1 else Dist:=0;

  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := ClientWidth - FButton.Width - 2-Dist;
  Loc.Top := Dist;
  Loc.Left := Dist;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));  {debug}
end;

procedure TAsgSpinEdit.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
  Dist: Integer;

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
      FButton.SetBounds(Width - FButton.Width - dist, 0, FButton.Width, Height - dist)
    else FButton.SetBounds (Width - FButton.Width, 1, FButton.Width, Height - 3);
    SetEditRect;
  end;
end;

function TAsgSpinEdit.GetMinHeight: Integer;
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
  if BorderStyle = bsSingle then
    Result := Metrics.tmHeight + I div 4 + GetSystemMetrics(SM_CYBORDER) * 4 + 2
  else
    Result := Metrics.tmHeight + (I div 4) +  2;
end;

procedure TAsgSpinEdit.UpClick (Sender: TObject);
begin
  if ReadOnly then MessageBeep(0)
  else
    case fSpinType of
    sptNormal: Value := Value + FIncrement;
    sptFloat:  FloatValue := FloatValue + FIncrementFloat;
    sptTime: begin
              if selstart>=pos(TimeSeparator,text) then
                begin
                 if selstart>=posfrom(TimeSeparator,text,pos(TimeSeparator,text)) then
                  TimeValue := TimeValue + encodetime(0,0,1,0)
                 else
                  TimeValue := TimeValue + encodetime(0,1,0,0);
                end
              else
               TimeValue := TimeValue + encodetime(1,0,0,0)
             end;
    sptDate: begin
              if selstart>=pos(DateSeparator,text) then
                begin
                 if selstart>=posfrom(DateSeparator,text,pos(DateSeparator,text)) then
                  DateValue := IncYear(DateValue,1)
                 else
                  DateValue := IncMonth(DateValue,1);
                end
              else
               DateValue := DateValue + 1;
             end;
    end;

end;

procedure TAsgSpinEdit.DownClick (Sender: TObject);
var
  dt: TDateTime;

begin
  if ReadOnly then MessageBeep(0)
  else
    case fSpinType of
    sptNormal: Value := Value - FIncrement;
    sptFloat:  FloatValue := FloatValue - FIncrementFloat;
    sptTime:
      begin
        dt := TimeValue;
        dt := dt + 1;
        if SelStart >= Pos(TimeSeparator,text) then
        begin
          if SelStart >= PosFrom(TimeSeparator,Text,Pos(TimeSeparator,Text)) then
            dt := dt - EncodeTime(0,0,1,0)
          else
            dt := dt - EncodeTime(0,1,0,0);
        end
        else
          dt := dt - EncodeTime(1,0,0,0);

        if dt > 1 then
          dt := dt - 1;
        TimeValue := dt;
      end;
    sptDate:
      begin
        if SelStart >= Pos(DateSeparator,text) then
        begin
          if SelStart >= PosFrom(DateSeparator,text,pos(DateSeparator,text)) then
            DateValue := IncYear(DateValue,-1)
          else
            DateValue := IncMonth(DateValue,-1);
        end
        else
          DateValue := DateValue - 1;
      end;
    end;
end;

procedure TAsgSpinEdit.WMPaste(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TAsgSpinEdit.WMCut(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TAsgSpinEdit.CMExit(var Message: TCMExit);
begin
  inherited;
  case fSpinType of
  sptNormal:if CheckValue (Value) <> Value then SetValue (Value);
  sptFloat:if CheckFloatValue (FloatValue) <> FloatValue then SetFloatValue (FloatValue);
  sptTime:if CheckDateValue (TimeValue) <> TimeValue then SetTimeValue (TimeValue);
  sptDate:if CheckDateValue (DateValue) <> DateValue then SetDateValue (DateValue);
  end;
end;

function TAsgSpinEdit.GetValue: LongInt;
begin
  try
    Result := StrToInt (Text);
  except
    Result := FMinValue;
  end;
end;

function TAsgSpinEdit.CheckFloatValue (NewValue: Double): Double;
begin
  Result := NewValue;
  if (FMaxFloatValue <> FMinFloatValue) then
  begin
    if NewValue < FMinFloatValue then
      Result := FMinFloatValue
    else if NewValue > FMaxFloatValue then
      Result := FMaxFloatValue;
  end;
end;

function TAsgSpinEdit.GetFloatValue: Double;
begin
  try
    Result := StrToFloat (Text);
  except
    Result := FMinValue;
  end;
end;

procedure TAsgSpinEdit.SetFloatValue (NewValue: Double);
begin
  if fPrecision=0 then
   Text := FloatToStr (CheckFloatValue (NewValue))
  else
   Text := FloatToStrF (CheckFloatValue (NewValue),ffFixed,15,fPrecision);
end;

procedure TAsgSpinEdit.SetValue (NewValue: LongInt);
begin
  Text := IntToStr (CheckValue (NewValue));
  if not FEditorEnabled then SelectAll;
end;

function TAsgSpinEdit.CheckValue (NewValue: LongInt): LongInt;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue) then
  begin
    if NewValue < FMinValue then
      Result := FMinValue
    else if NewValue > FMaxValue then
      Result := FMaxValue;
  end;
end;

function TAsgSpinEdit.CheckDateValue (NewValue: tDatetime): tdatetime;
begin
  Result := NewValue;
  if (FMaxDateValue <> FMinDateValue) then
  begin
    if NewValue < FMinDateValue then
      Result := FMinDateValue
    else if NewValue > FMaxDateValue then
      Result := FMaxDateValue;
  end;
end;


procedure TAsgSpinEdit.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and (not (csLButtonDown in ControlState) or not FeditorEnabled) then
    SelectAll;
  inherited;
end;

{$IFDEF DELPHI3_LVL}
procedure TAsgSpinEdit.SetSpinFlat(const Value: Boolean);
begin
  FButton.FUpButton.Flat := Value;
  FButton.FDownButton.Flat := Value;
  FSpinFlat := Value;
end;
{$ENDIF}

{$IFDEF DELPHI4_LVL}
procedure TAsgSpinEdit.SetSpinTransparent(const Value: Boolean);
begin
  FButton.FUpButton.Transparent := Value;
  FButton.FDownButton.Transparent := Value;
  FSpinTransparent := Value;
  Self.Width := self.Width + 1;
  Self.Width := self.Width - 1;
end;
{$ENDIF}

procedure TAsgSpinEdit.SetPrecision(const Value: integer);
begin
  FPrecision := Value;
  if FSpinType = sptFloat then
    Floatvalue := GetFloatValue;
end;

procedure TAsgSpinEdit.SetSpinType(const Value: TAsgSpinType);
begin
  if FSpinType <> value then
    FSpinType := Value;

  case FSpinType of
  sptFloat:Floatvalue := GetFloatValue;
  sptNormal:self.Value := GetValue;
  sptTime:self.TimeValue := GetTimeValue;
  sptDate:self.DateValue := GetDateValue;
  end;
end;

function TAsgSpinEdit.GetTimeValue: tdatetime;
begin
 try
   Result := StrToTime(Text);
 except
   Result := 0;
 end;
end;

procedure TAsgSpinEdit.SetTimeValue(const Value: tdatetime);
var
  ss: Integer;
begin
  fTimeValue := Value;
  if (csLoading in ComponentState) then
    Exit;
  ss := SelStart;
  Text := TimeToStr(value);
  SelStart := ss;
end;

function TAsgSpinEdit.GetDateValue: tdatetime;
begin
 if (Text = '0') or (Text = '') then Result := Now
 else
   try
     Result := StrToDate(Text);
   except
     Result := FMinDateValue;
   end;
end;

procedure TAsgSpinEdit.SetDateValue(const Value: tdatetime);
var
  ss: Integer;
begin
  FDateValue := Value;
  if (csLoading in ComponentState) then
    Exit;
  FDateValue := CheckDateValue(value);
  ss := SelStart;
  Text := DateToStr(FDateValue);
  SelStart := ss;
end;

procedure TAsgSpinEdit.SetIsWinXP(const Value: Boolean);
begin
  FIsWinXP := Value;
  FButton.IsWinXP := Value;
end;

{TAdvTimerSpeedButton}

destructor TAdvTimerSpeedButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TAdvTimerSpeedButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  if tbAllowTimer in FTimeBtnState then
  begin
    if FRepeatTimer = nil then
      FRepeatTimer := TTimer.Create(Self);

    FRepeatTimer.OnTimer := TimerExpired;
    FRepeatTimer.Interval := InitRepeatPause;
    FRepeatTimer.Enabled  := True;
  end;
  invalidaterect(parent.handle,nil,true);
end;

procedure TAdvTimerSpeedButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
  InvalidateRect(Parent.handle,nil,True);
end;

procedure TAdvTimerSpeedButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := RepeatPause;
  if (FState = bsDown) and MouseCapture then
  begin
    try
      Click;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

procedure TAdvTimerSpeedButton.Paint;
const
  Flags: array[Boolean] of Integer = (0, DFCS_PUSHED);
  Flats: array[Boolean] of Integer = (0, DFCS_FLAT);
var
  R: TRect;
  HTheme: THandle;
begin
  R := GetClientRect;

  if FIsWinXP then
  begin
    htheme := OpenThemeData((Owner as TWinControl).Handle,'spin');

    case FButtonDirection of
    bdLeft:
      begin
        if FState = bsDown then
          DrawThemeBackground(htheme,Canvas.Handle,SPNP_DOWNHORZ,DNHZS_PRESSED,@r,nil)
        else
        begin
          if FHasMouse then
            DrawThemeBackground(htheme,Canvas.Handle,SPNP_DOWNHORZ,DNHZS_HOT,@r,nil)
          else
            DrawThemeBackground(htheme,Canvas.Handle,SPNP_DOWNHORZ,DNHZS_NORMAL,@r,nil);
        end;
      end;
    bdRight:
      begin
        if fState = bsDown then
          DrawThemeBackground(htheme,Canvas.Handle,SPNP_UPHORZ,UPHZS_PRESSED,@r,nil)
        else
        begin
          if FHasMouse then
            DrawThemeBackground(htheme,Canvas.Handle,SPNP_UPHORZ,UPHZS_HOT,@r,nil)
          else
            DrawThemeBackground(htheme,Canvas.Handle,SPNP_UPHORZ,UPHZS_NORMAL,@r,nil);
        end;
      end;
    bdUp:
      begin
        if fState = bsDown then
          DrawThemeBackground(htheme,Canvas.Handle,SPNP_UP,UPS_PRESSED,@r,nil)
        else
        begin
          if FHasMouse then
            DrawThemeBackground(htheme,Canvas.Handle,SPNP_UP,UPS_HOT,@r,nil)
          else
            DrawThemeBackground(htheme,Canvas.Handle,SPNP_UP,UPS_NORMAL,@r,nil);
        end;
      end;

    bdDown:
      begin
        if fState = bsDown then
          DrawThemeBackground(htheme,Canvas.Handle,SPNP_DOWN,DNS_PRESSED,@r,nil)
        else
        begin
          if FHasMouse then
            DrawThemeBackground(htheme,Canvas.Handle,SPNP_DOWN,DNS_HOT,@r,nil)
          else
            DrawThemeBackground(htheme,Canvas.Handle,SPNP_DOWN,DNS_NORMAL,@r,nil);
        end;
      end;
    end;

    CloseThemeData(htheme);
  end
  else
  begin
    case FButtonDirection of
    bdLeft:DrawFrameControl(canvas.handle,r,DFC_SCROLL,DFCS_SCROLLLEFT or flags[fState=bsDown] {$IFDEF DELPHI3_LVL}or flats[flat]{$ENDIF});
    bdRight:DrawFrameControl(canvas.handle,r,DFC_SCROLL,DFCS_SCROLLRIGHT or flags[fState=bsDown] {$IFDEF DELPHI3_LVL}or flats[flat]{$ENDIF});
    bdUp,bdDown:inherited Paint;
    end;
  end;

end;

procedure TAdvTimerSpeedButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FHasMouse := True;
  Invalidate;
end;

procedure TAdvTimerSpeedButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FHasMouse := False;
  Invalidate;
end;

end.
