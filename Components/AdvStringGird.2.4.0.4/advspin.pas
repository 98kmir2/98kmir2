{*************************************************************************}
{ TADVSPINEDIT component                                                  }
{ for Delphi & C++Builder                                                 }
{ version 1.3                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright © 1996-2002                                         }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit AdvSpin;

{$I TMSDEFS.INC}

interface

uses
  Windows, Classes, StdCtrls, ExtCtrls, Controls, Messages, SysUtils,
  Forms, Graphics, Menus, Buttons, Mask, ASXPVS;

{$R ADVSPIN.RES}

type
  TNumGlyphs = Buttons.TNumGlyphs;

  TAdvTimerSpeedButton = class;

  TWinCtrl = class(TWinControl);

{ TAdvSpinButton }

  TSpinDirection = (spVertical,spHorizontal);

  TLabelPosition = (lpLeftTop,lpLeftCenter,lpLeftBottom,lpTopLeft,lpBottomLeft,
                    lpLeftTopLeft,lpLeftCenterLeft,lpLeftBottomLeft,lpTopCenter,
                    lpBottomCenter);

  TAdvSpinButton = class (TWinControl)
  private
    FUpButton: TAdvTimerSpeedButton;
    FDownButton: TAdvTimerSpeedButton;
    FFocusedButton: TAdvTimerSpeedButton;
    FFocusControl: TWinControl;
    FOnUpClick: TNotifyEvent;
    FOnDownClick: TNotifyEvent;
    FDirection: TSpinDirection;
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
  protected

    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property Align;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property DragKind;
    property Constraints;
    property OnStartDock;
    property OnEndDock;
    {$ENDIF}
    property Ctl3D;
    property Direction: TSpinDirection read fDirection write SetDirection;
    property DownGlyph: TBitmap read GetDownGlyph write SetDownGlyph;
    property DownNumGlyphs: TNumGlyphs read GetDownNumGlyphs write SetDownNumGlyphs default 1;
    property DragCursor;
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
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDrag;
    property OnUpClick: TNotifyEvent read FOnUpClick write FOnUpClick;
  end;

{ TAdvSpinEdit }

  TAdvSpinType = (sptNormal,sptFloat,sptDate,sptTime,sptHex);

  TAdvSpinEdit = class(TCustomMaskEdit)
  private
    FFlat: Boolean;
    FFlatLineColor: TColor;
    FLabel: TLabel;
    FLabelFont: TFont;
    FLabelPosition: TLabelPosition;
    FLabelMargin: Integer;
    FLabelTransparent: boolean;
    FMinValue: LongInt;
    FMaxValue: LongInt;
    FMinFloatValue: Double;
    FMaxFloatValue: Double;
    FMinDateValue: TDateTime;
    FMaxDateValue: TDateTime;
    FDateValue: TDateTime;
    FTimeValue: TDateTime;
    FHexValue: Longint;
    FIncrement: LongInt;
    FIncrementFloat : Double;
    FIncrementPage: Longint;
    FIncrementFloatPage: Double;
    FIncrementSmart: boolean;
    FButton: TAdvSpinButton;
    FEditorEnabled: Boolean;
    FDirection: TSpinDirection;
    FSpinType:TAdvSpinType;
    FPrecision: integer;
    FReturnIsTab: boolean;
    FNormalColor: TColor;
    FUSDates: Boolean;
    {$IFDEF DELPHI3_LVL}
    FSpinFlat : Boolean;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    FSpinTransparent : Boolean;
    {$ENDIF}
    FTransparent: Boolean;
    FAutoFocus: boolean;
    FIncrementHours: Integer;
    FIncrementMinutes: Integer;
    FShowSeconds: Boolean;
    FSigned: Boolean;
    FLabelAlwaysEnabled: Boolean;
    function GetMinHeight: Integer;
    function GetValue: LongInt;
    function CheckValue (NewValue: LongInt): LongInt;
    procedure SetValue (NewValue: LongInt);
    function GetFloatValue: double;
    function CheckFloatValue (NewValue: double): double;
    function CheckDateValue (NewValue: TDateTime): TDateTime;
    procedure SetFloatValue (NewValue: double);
    procedure SetEditRect;
    procedure SetEditorEnabled(NewValue:boolean);
    procedure SetDirection(const Value: TSpinDirection);
    procedure SetPrecision(const Value: integer);
    procedure SetSpinType(const Value: TAdvSpinType);
    function GetTimeValue: TDateTime;
    procedure SetTimeValue(const Value: TDateTime);
    function GetDateValue: TDateTime;
    procedure SetDateValue(const Value: TDateTime);
    function GetHexValue: integer;
    procedure SetHexValue(const Value: integer);
    {$IFDEF DELPHI3_LVL}
    procedure SetSpinFlat(const Value : boolean);
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    procedure SetSpinTransparent(const value : boolean);
    {$ENDIF}
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CNCtlColorEdit(var Message: TWMCtlColorEdit); message CN_CTLCOLOREDIT;
    procedure CNCtlColorStatic(var Message: TWMCtlColorStatic); message CN_CTLCOLORSTATIC;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;    
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;    
    procedure WMPaste(var Message: TWMPaste); message WM_PASTE;
    procedure WMCut(var Message: TWMCut); message WM_CUT;
    procedure WMChar(var Msg:TWMKey); message WM_CHAR;    
    procedure WMPaint(var Msg:TWMPaint); message WM_PAINT;
    function GetLabelCaption: string;
    procedure SetLabelCaption(const Value: string);
    procedure SetLabelMargin(const Value: integer);
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure SetLabelTransparent(const Value: boolean);
    function GetVisible: boolean;
    procedure SetVisible(const Value: boolean);
    procedure LabelFontChange(Sender: TObject);
    procedure SetLabelFont(const Value: TFont);
    procedure SetTransparent(const Value: Boolean);
    procedure SetFlat(const Value: Boolean);
    procedure SetFlatRect(const Value: Boolean);
    procedure SetFlatLineColor(const Value: TColor);
    procedure SetShowSeconds(const Value: Boolean);
    procedure SetLabelAlwaysEnabled(const Value: Boolean);
    function GetEnabledEx: Boolean;
    procedure SetEnabledEx(const Value: Boolean);
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
    procedure UpdateLabel;
    function CreateLabel:TLabel;
    procedure PaintEdit;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Button: TAdvSpinButton read FButton;
    procedure IncSmart;
    procedure DecSmart;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property AutoFocus: boolean read FAutoFocus write FAutoFocus;
    property Direction : TSpinDirection read fDirection write SetDirection;
    property ReturnIsTab: boolean read FReturnIsTab write FReturnIsTab;
    property Precision: integer read FPrecision write SetPrecision;
    property SpinType: TAdvSpinType read fSpinType write SetSpinType;
    property Value: LongInt read GetValue write SetValue;
    property FloatValue: double read GetFloatValue write SetFloatValue;
    property TimeValue: TDateTime read GetTimeValue write SetTimeValue;
    property DateValue: TDateTime read GetDateValue write SetDateValue;
    property HexValue: integer read GetHexValue write SetHexValue;
    property Flat: Boolean read FFlat write SetFlat;
    property FlatLineColor: TColor read FFlatLineColor write SetFlatLineColor;
    {$IFDEF DELPHI3_LVL}
    property SpinFlat : boolean read fSpinFlat write SetSpinFlat;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    property SpinTransparent : boolean read fSpinTransparent write SetSpinTransparent;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property Constraints;
    {$ENDIF}
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property EditorEnabled: Boolean read FEditorEnabled write SetEditorEnabled default True;
    property Enabled: Boolean read GetEnabledEx write SetEnabledEx;
    property Font;
    property Increment: LongInt read FIncrement write FIncrement default 1;
    property IncrementFloat: double read FIncrementFloat write FIncrementFloat;
    property IncrementPage: Longint read FIncrementPage write FIncrementPage;
    property IncrementFloatPage: double read FIncrementFloatPage write FIncrementFloatPage;
    property IncrementSmart: boolean read FIncrementSmart write FIncrementSmart;
    property IncrementMinutes: Integer read FIncrementMinutes write FIncrementMinutes;
    property IncrementHours: Integer read FIncrementHours write FIncrementHours;
    property LabelAlwaysEnabled: Boolean read FLabelAlwaysEnabled write SetLabelAlwaysEnabled;    
    property LabelCaption:string read GetLabelCaption write SetLabelCaption;
    property LabelPosition:TLabelPosition read fLabelPosition write SetLabelPosition;
    property LabelMargin: Integer read fLabelMargin write SetLabelMargin;
    property LabelTransparent:boolean read fLabelTransparent write SetLabelTransparent;
    property LabelFont:TFont read fLabelFont write SetLabelFont;
    property MaxLength;
    property MaxValue: LongInt read FMaxValue write FMaxValue;
    property MinValue: LongInt read FMinValue write FMinValue;
    property MinFloatValue: double read fMinFloatValue write fMinFloatValue;
    property MaxFloatValue: double read fMaxFloatValue write fMaxFloatValue;
    property MinDateValue: TDateTime read fMinDateValue write fMinDateValue;
    property MaxDateValue: TDateTime read fMaxDateValue write fMaxDateValue;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property Signed: Boolean read FSigned write FSigned;
    property ShowHint;
    property ShowSeconds: Boolean read FShowSeconds write SetShowSeconds;
    property TabOrder;
    property TabStop;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property Visible:boolean read GetVisible write SetVisible;
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

  TAdvMaskSpinEdit = class(TAdvSpinEdit)
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
    function DoVisualStyles: Boolean;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property TimeBtnState: TTimeBtnState read FTimeBtnState write FTimeBtnState;
    property ButtonDirection: TButtonDirection read FButtonDirection write FButtonDirection;

  end;

implementation

const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}

function PosFrom(sub,s:string;n: Integer): Integer;
begin
  Delete(s,1,n);
  Result := Pos(sub,s);
  if Result > 0 then Result := Result + n;
end;

function IncYear(d: TDateTime;n: Integer): TDateTime;
var
  da,mo,ye:word;
begin
  DecodeDate(d,ye,mo,da);
  ye := ye + n;
  Result := Encodedate(ye,mo,da);
end;

{$IFNDEF DELPHI3_LVL}
function IncMonth(const Date: TDateTime; NumberOfMonths: Integer): TDateTime;
var
  Year, Month, Day: Word;
  NewMonth: Integer;

begin
  DecodeDate(Date,Year,Month,Day);

  NewMonth := Month;

  NewMonth := NewMonth + NumberOfMonths;

  while (NewMonth > 12) do
  begin
   NewMonth := NewMonth - 12;
   Year := Year + 1;
  end;

  while (NewMonth < 0) do
  begin
   NewMonth := NewMonth + 12;
   Year := Year - 1;
  end;

  Month := NewMonth;

  Result := EncodeDate(Year, Month, Day);

end;
{$ENDIF}

{returns value from 0..255 of 2char hex string}
function HexVal(s:string): Integer;
var
  i,j: Integer;
begin
  if length(s)=1 then
   begin
    i:=ord(upcase(s[1]))-ord('0');
    if (i>10) then i:=10+i-(ord('A')-ord('0'));
    result:=i;
   end
  else
   begin
    i:=ord(upcase(s[1]))-ord('0');
    if (i>10) then i:=10+i-(ord('A')-ord('0'));
    j:=ord(upcase(s[2]))-ord('0');
    if (j>10) then j:=10+j-(ord('A')-ord('0'));
    result:=i*16+j;
   end;
end;


{ TAdvSpinButton }

constructor TAdvSpinButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] +
    [csFramed, csOpaque];

  FUpButton := CreateButton;
  FDownButton := CreateButton;
  UpGlyph := nil;
  DownGlyph := nil;

  FUpButton.ButtonDirection := bdUp;
  FDownButton.ButtonDirection := bdDown;

  Width := 15;
  Height := 25;
  FFocusedButton := FUpButton;
end;

function TAdvSpinButton.CreateButton: TAdvTimerSpeedButton;
begin
  Result := TAdvTimerSpeedButton.Create (Self);
  Result.OnClick := BtnClick;
  Result.OnMouseDown := BtnMouseDown;
  Result.Visible := True;
  Result.Enabled := True;
  Result.TimeBtnState := [tbAllowTimer];
  Result.Parent := Self;
end;

procedure TAdvSpinButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then
    FFocusControl := nil;
end;

procedure TAdvSpinButton.AdjustSize (var W, H: Integer);
begin
  if (FUpButton = nil) or (csLoading in ComponentState) then Exit;
  if fDirection = spVertical then
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

procedure TAdvSpinButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TAdvSpinButton.WMSize(var Message: TWMSize);
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

procedure TAdvSpinButton.WMSetFocus(var Message: TWMSetFocus);
begin
  FFocusedButton.TimeBtnState := FFocusedButton.TimeBtnState + [tbFocusRect];
  FFocusedButton.Invalidate;
end;

procedure TAdvSpinButton.WMKillFocus(var Message: TWMKillFocus);
begin
  FFocusedButton.TimeBtnState := FFocusedButton.TimeBtnState - [tbFocusRect];
  FFocusedButton.Invalidate;
end;

procedure TAdvSpinButton.KeyDown(var Key: Word; Shift: TShiftState);
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

procedure TAdvSpinButton.BtnMouseDown (Sender: TObject; Button: TMouseButton;
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

procedure TAdvSpinButton.BtnClick(Sender: TObject);
begin
  if Sender = FUpButton then
  begin
    if Assigned(FOnUpClick) then FOnUpClick(Self);
  end
  else
    if Assigned(FOnDownClick) then FOnDownClick(Self);
end;

procedure TAdvSpinButton.SetDirection(const Value:TSpinDirection);
begin
 if (value<>fDirection) then
  begin
   fDirection:=value;
   recreatewnd;
   if fdirection=spVertical then
     begin
       width:=15;
       fUpButton.FButtonDirection:=bdUp;
       fDownButton.FButtonDirection:=bdDown;
     end
   else
     begin
      width:=20;
      fUpButton.FButtonDirection:=bdRight;
      fDownButton.FButtonDirection:=bdLeft;
     end;
  end;
end;

procedure TAdvSpinButton.SetFocusBtn (Btn: TAdvTimerSpeedButton);
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

procedure TAdvSpinButton.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TAdvSpinButton.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then inherited SetBounds (Left, Top, W, H);
end;

function TAdvSpinButton.GetUpGlyph: TBitmap;
begin
  Result := FUpButton.Glyph;
end;

procedure TAdvSpinButton.SetUpGlyph(Value: TBitmap);
begin
  if Value <> nil then
    FUpButton.Glyph := Value
  else
  begin
    FUpButton.Glyph.Handle := LoadBitmap(HInstance, 'AdvSpinUp');
    FUpButton.NumGlyphs := 1;
    FUpButton.Invalidate;
  end;
end;

function TAdvSpinButton.GetUpNumGlyphs: TNumGlyphs;
begin
  Result := FUpButton.NumGlyphs;
end;

procedure TAdvSpinButton.SetUpNumGlyphs(Value: TNumGlyphs);
begin
  FUpButton.NumGlyphs := Value;
end;

function TAdvSpinButton.GetDownGlyph: TBitmap;
begin
  Result := FDownButton.Glyph;
end;

procedure TAdvSpinButton.SetDownGlyph(Value: TBitmap);
begin
  if Value <> nil then
    FDownButton.Glyph := Value
  else
  begin
    FDownButton.Glyph.Handle := LoadBitmap(HInstance, 'AdvSpinDown');
    FUpButton.NumGlyphs := 1;
    FDownButton.Invalidate;
  end;
end;

function TAdvSpinButton.GetDownNumGlyphs: TNumGlyphs;
begin
  Result := FDownButton.NumGlyphs;
end;

procedure TAdvSpinButton.SetDownNumGlyphs(Value: TNumGlyphs);
begin
  FDownButton.NumGlyphs := Value;
end;


{ TAdvSpinEdit }

constructor TAdvSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButton := TAdvSpinButton.Create (Self);
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
  FIncrementPage := 10;
  FIncrementFloat := 0.1;
  FIncrementFloatPage := 1.0;
  FIncrementMinutes := 1;
  FIncrementHours := 1;
  FEditorEnabled := True;
  FMinFloatValue := 0;
  FMinValue := 0;
  FMaxFloatValue := 100;
  FMaxValue := 100;
  FShowSeconds := True;

  FLabel := nil;
  FLabelMargin := 4;
  FLabelFont := TFont.Create;
  FLabelFont.OnChange := LabelFontChange;
end;

destructor TAdvSpinEdit.Destroy;
begin
  FButton := nil;
  if FLabel <> nil then
    FLabel.Free;
  FLabelFont.Free;
  inherited Destroy;
end;

procedure TAdvSpinEdit.Loaded;
begin
  inherited;
  FNormalColor := Color;

  case FSpinType of
  sptDate:self.Text := DateToStr(FDateValue);
  sptTime:
    begin
      if FShowSeconds then
        self.Text := FormatDateTime('h'+TimeSeparator+'nn'+TimeSeparator+'ss',FTimeValue)
      else
        self.Text := FormatDateTime('h'+TimeSeparator+'nn',FTimeValue)
    end;
  sptHex:self.Text := '0x'+inttohex(FHexValue,0);
  end;

  SetSpinType(fSpinType);

  FFlat := not FFlat;
  SetFlat(not fFlat);

//  Height := FLoadedHeight;
  SetBounds(Left,Top,Width,Height);


  FUSDates := Pos('y',Uppercase(ShortDateFormat)) < Pos('d',Uppercase(ShortDateFormat));

  if Assigned(FLabel) and not Enabled then
    if not FLabelAlwaysEnabled then
      FLabel.Enabled := False;
  
end;

{$IFDEF DELPHI3_LVL}
procedure TAdvSpinEdit.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;
{$ENDIF}

procedure TAdvSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  ss,sl: Integer;
  oldval: String;
begin
  ss := SelStart;
  sl := SelLength;

  oldval := self.Text;

  case key of
  vk_up:if not (FIncrementSmart and (sl=0) and (fSpinType in [sptFloat,sptNormal])) then UpClick (Self) else IncSmart;
  vk_down:if not (FIncrementSmart and (sl=0) and (fSpinType in [sptFloat,sptNormal])) then DownClick(self) else DecSmart;
  vk_next:if not (FIncrementSmart and (sl=0)) then
           case fSpinType of
           sptNormal: Value := Value - FIncrementPage;
           sptFloat:  FloatValue := FloatValue - FIncrementFloatPage;
           end
         else
           DecSmart;

  vk_prior:if not (FIncrementSmart and (sl=0)) then
           case fSpinType of
           sptNormal: Value := Value + FIncrementPage;
           sptFloat:  FloatValue := FloatValue + FIncrementFloatPage;
           end
          else IncSmart;

  vk_delete:if not fEditorEnabled or ((fSpinType=sptHex) and (selstart<2)) then key:=0;
  vk_return:if FReturnIsTab then
            begin
             key:=vk_tab;
             postmessage(self.handle,wm_keydown,VK_TAB,0);
            end;
  end;

  if key in [vk_up,vk_down,vk_next,vk_prior,vk_delete,vk_return] then
  begin
    SelStart := ss;
    SelLength := sl;
  end;

  if oldval <> self.Text then
    Modified := True;

  inherited KeyDown(Key, Shift);
end;

procedure TAdvSpinEdit.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
    MessageBeep(0);
  end;
  if Key <> #0 then
    inherited KeyPress(Key);
end;

function TAdvSpinEdit.IsValidChar(var Key: Char): Boolean;
var
  dp: Integer;
begin
  Result := (Key in [DecimalSeparator, ThousandSeparator, TimeSeparator, DateSeparator,'+', '-', '0'..'9']) or
    ((Key < #32) and (Key <> Chr(VK_RETURN)));

  if (key = TimeSeparator) and (FSpinType <> sptTime) and
    not ((TimeSeparator in [DecimalSeparator,ThousandSeparator]) and (FSpinType = sptFloat)) then
    Result := False;

  if (key = DateSeparator) and (FSpinType <> sptDate) and
    not ((DateSeparator in [DecimalSeparator,ThousandSeparator]) and (FSpinType = sptFloat)) then
    Result := False;

  if (FSpinType = sptFloat) and not (key in [chr(vk_escape),chr(vk_return),chr(vk_back)]) then
  begin
    if (key = ThousandSeparator) then
      key := DecimalSeparator;

    if (key = DecimalSeparator) and ((Pos(DecimalSeparator,self.Text)>0) or (FPrecision = 0)) then
      Result := False;
      
    dp := Pos(DecimalSeparator,self.Text);
    
    if (FPrecision > 0) and (dp > 0) and (selstart >= dp) and (sellength = 0) then
    begin
      if (Length(self.Text) >= dp + FPrecision) then
        Result := False;
    end;
  end;

  if FSpinType = sptTime then
  begin
    if (key = TimeSeparator) and (Pos(TimeSeparator,self.Text) > 0) then
      Result := False;
  end;

  if FSpinType = sptHex then
  begin
     Result:=((Key in ['0'..'9','a'..'f','A'..'F']) or
             ((Key < #32) and (Key <> Chr(VK_RETURN)))) and (selstart>=2);
     if result and (key=char(vk_back)) and (selstart=2) then result:=false;
  end;

  if not FEditorEnabled and Result and ((Key >= #32) or
      (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE))) then
    Result := False;
end;

procedure TAdvSpinEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TAdvSpinEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;

procedure TAdvSpinEdit.SetDirection(const value: TSpinDirection);
begin
  if Value <> FDirection then
  begin
    FDirection := Value;
    FButton.Direction := Value;
    // force organisation update
    self.Width := self.Width + 1;
    self.Width := self.Width - 1;
  end;
end;

procedure TAdvSpinEdit.SetEditorEnabled(NewValue:boolean);
begin
  FEditorEnabled := NewValue;
end;

procedure TAdvSpinEdit.SetEditRect;
var
  Loc: TRect;
  Dist : integer;
begin
  if BorderStyle = bsNone then
    Dist := 2
  else
    Dist := 0;

  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := ClientWidth - FButton.Width - 2 - Dist;
  Loc.Top := Dist;
  Loc.Left := Dist;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));  {debug}
end;

procedure TAdvSpinEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft,ATop,AWidth,AHeight);
  if flabel<>nil then UpdateLabel;
end;


procedure TAdvSpinEdit.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
  Dist: Integer;

begin
  inherited;
  if BorderStyle=bsNone then Dist:=1 else Dist:=5;
  MinHeight := GetMinHeight;
    { text edit bug: if size to less than minheight, then edit ctrl does
      not display the text }
  if Height < MinHeight then
    Height := MinHeight
  else if FButton <> nil then
  begin
    if NewStyleControls and Ctl3D then
      FButton.SetBounds(Width - FButton.Width - dist, 0, FButton.Width, Height - dist)
    else
      FButton.SetBounds (Width - FButton.Width, 1, FButton.Width, Height - 3);
    SetEditRect;
  end;
end;

function TAdvSpinEdit.GetMinHeight: Integer;
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
  if BorderStyle=bsSingle then
   Result := Metrics.tmHeight + I div 4 + GetSystemMetrics(SM_CYBORDER) * 4 + 2
  else
   Result := Metrics.tmHeight + (I div 4) +  2;
end;

procedure TAdvSpinEdit.UpClick (Sender: TObject);
var
  ss,sl: Integer;
  oldval: string;
begin
  ss := SelStart;
  sl := SelLength;

  oldval := self.Text;

  if ReadOnly then MessageBeep(0)
  else
    case FSpinType of
    sptNormal:
      if FIncrementSmart then
        IncSmart
      else
        Value := Value + FIncrement;
    sptFloat:
      if FIncrementSmart then
        IncSmart
      else
        FloatValue := FloatValue + FIncrementFloat;
    sptTime:
      begin
        if SelStart >= Pos(TimeSeparator,Text) then
        begin
          if (selstart >= PosFrom(TimeSeparator,text,Pos(TimeSeparator,text))) and ShowSeconds then
            TimeValue := TimeValue + EncodeTime(0,0,1,0)
          else
            TimeValue := TimeValue + EncodeTime(0,FIncrementMinutes,0,0);
        end
        else
        begin
          if IncrementHours = 0 then
            TimeValue := TimeValue + EncodeTime(0,FIncrementMinutes,0,0)
          else
            TimeValue := TimeValue + EncodeTime(FIncrementHours,0,0,0);
        end;
      end;
    sptDate:
      begin
        if FUSDates then
        begin
          if SelStart >= Pos(DateSeparator,Text) then
          begin
            if SelStart >= PosFrom(DateSeparator,text,pos(DateSeparator,text)) then
              DateValue := DateValue + 1
            else
              DateValue := IncMonth(DateValue,1);
          end
          else
            DateValue := IncYear(DateValue,1);
        end
        else
        begin
          if SelStart >= Pos(DateSeparator,Text) then
          begin
            if SelStart >= PosFrom(DateSeparator,text,pos(DateSeparator,text)) then
              DateValue := IncYear(DateValue,1)
            else
              DateValue := IncMonth(DateValue,1);
          end
          else
            DateValue := DateValue + 1;
        end;
      end;
    sptHex:
      begin
        HexValue := HexValue + FIncrement;
      end;
    end;

  if oldval <> self.Text then
    Modified := True;

  SelStart := ss;
  SelLength := sl;
end;

procedure TAdvSpinEdit.DownClick (Sender: TObject);
var
  ss,sl: Integer;
  oldval: string;
begin
  ss := SelStart;
  sl := SelLength;

  oldval := self.Text;

  if ReadOnly then MessageBeep(0)
  else
    case FSpinType of
    sptNormal:
      if FIncrementSmart then
        DecSmart
      else
        Value := Value - FIncrement;
    sptFloat:
      if FIncrementSmart then
        DecSmart
      else
        FloatValue := FloatValue - FIncrementFloat;
    sptTime:
      begin
        if SelStart >= Pos(TimeSeparator,text) then
        begin
          if (selstart >= PosFrom(TimeSeparator,text,pos(TimeSeparator,text))) and ShowSeconds then
          begin
            if TimeValue >= EncodeTime(0,0,1,0) then
              TimeValue := TimeValue - EncodeTime(0,0,1,0)
          end
          else
          begin
            if TimeValue >= EncodeTime(0,FIncrementMinutes,0,0) then
              TimeValue := TimeValue - EncodeTime(0,FIncrementMinutes,0,0);
          end;
        end
        else
        begin
          if FIncrementHours = 0 then
          begin
            if TimeValue >= EncodeTime(0,FIncrementMinutes,0,0) then
              TimeValue := TimeValue - encodetime(0,FIncrementMinutes,0,0)
          end
          else
          begin
            if TimeValue >= EncodeTime(FIncrementHours,0,0,0) then
              TimeValue := TimeValue - encodetime(FIncrementHours,0,0,0);
          end;
        end;
      end;
    sptDate:
      begin
        if FUSDates then
        begin
          if Selstart >= Pos(DateSeparator,Text) then
          begin
            if SelStart >= PosFrom(DateSeparator,text,pos(DateSeparator,text)) then
              DateValue := DateValue - 1
            else
              DateValue := IncMonth(DateValue,-1);
          end
          else
            DateValue := IncYear(DateValue, - 1);
        end
        else
        begin
          if Selstart >= Pos(DateSeparator,Text) then
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
    sptHex:
      begin
        HexValue := HexValue - FIncrement;
      end;

    end;

  if oldval <> self.Text then
    Modified := True;

  SelStart := ss;
  SelLength := sl;
end;

procedure TAdvSpinEdit.WMPaste(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TAdvSpinEdit.WMCut(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TAdvSpinEdit.CMExit(var Message: TCMExit);
begin
  inherited;
  case fSpinType of
  sptNormal:if CheckValue (Value) <> Value then SetValue (Value);
  sptFloat:if CheckFloatValue (FloatValue) <> FloatValue then SetFloatValue (FloatValue);
  sptTime:if CheckDateValue (TimeValue) <> TimeValue then SetTimeValue(TimeValue);
  sptDate:if CheckDateValue (DateValue) <> DateValue then SetDateValue(DateValue);
  sptHex:HexValue:= CheckValue(HexValue);
  end;
end;

function TAdvSpinEdit.GetValue: LongInt;
begin
  try
    Result := StrToInt (Text);
  except
    Result := FMinValue;
  end;
end;

function TAdvSpinEdit.CheckFloatValue (NewValue: Double): Double;
begin
  Result := NewValue;
  if not (csLoading in ComponentState) then
  begin
    if (FMaxFloatValue <> FMinFloatValue) then
    begin
      if NewValue < FMinFloatValue then
        Result := FMinFloatValue
      else if NewValue > FMaxFloatValue then
        Result := FMaxFloatValue;
    end;
  end;
end;

function TAdvSpinEdit.GetFloatValue: Double;
begin
  try
    Result := StrToFloat (Text);
  except
    Result := FMinValue;
  end;
end;

procedure TAdvSpinEdit.SetFloatValue (NewValue: Double);
begin
  if FPrecision < 0 then
    Text := FloatToStrF (CheckFloatValue (NewValue), ffGeneral,4,4)
  else
    if FPrecision = 0 then
     Text := FloatToStr (CheckFloatValue (NewValue))
    else
     Text := FloatToStrF (CheckFloatValue (NewValue),ffFixed,15,FPrecision);
end;

procedure TAdvSpinEdit.SetValue (NewValue: LongInt);
begin
  Text := IntToStr (CheckValue (NewValue));
  if not FEditorEnabled then SelectAll;
end;

function TAdvSpinEdit.CheckValue (NewValue: LongInt): LongInt;
begin
  Result := NewValue;
  if not (csLoading in ComponentState) then
  begin
    if (FMaxValue <> FMinValue) then
    begin
      if NewValue < FMinValue then
        Result := FMinValue
      else if NewValue > FMaxValue then
        Result := FMaxValue;
    end;
  end;
end;

function TAdvSpinEdit.CheckDateValue (NewValue: TDateTime): TDateTime;
begin
  Result := NewValue;
  if not (csLoading in ComponentState) then
  begin
    if (FMaxDateValue <> FMinDateValue) then
    begin
      if NewValue < FMinDateValue then
        Result := FMinDateValue
      else if NewValue > FMaxDateValue then
        Result := FMaxDateValue;
    end;
  end;
end;


procedure TAdvSpinEdit.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and (not (csLButtonDown in ControlState) or not FeditorEnabled) then
    SelectAll;
  inherited;
end;

{$IFDEF DELPHI3_LVL}
procedure TAdvSpinEdit.SetSpinFlat(const value: boolean);
begin
  FButton.FUpButton.Flat := Value;
  FButton.FDownButton.Flat := Value;
  FSpinFlat := value;
end;
{$ENDIF}

{$IFDEF DELPHI4_LVL}
procedure TAdvSpinEdit.SetSpinTransparent(const value: boolean);
begin
  FButton.FUpButton.Transparent := Value;
  FButton.FDownButton.Transparent := Value;
  Fspintransparent:=value;
  Width := Width + 1;
  Width := Width - 1;
end;
{$ENDIF}

procedure TAdvSpinEdit.SetPrecision(const Value: integer);
begin
  FPrecision := Value;
  if FSpinType = sptFloat then
    FloatValue := GetFloatValue;
end;

procedure TAdvSpinEdit.SetSpinType(const Value: TAdvSpinType);
begin
  if FSpinType <> value then
    FSpinType := Value;
    
  if not (csLoading in ComponentState) then
  case fSpinType of
  sptFloat:floatvalue := GetFloatValue;
  sptNormal:self.value := GetValue;
  sptTime:self.TimeValue := GetTimeValue;
  sptDate:self.DateValue := GetDateValue;
  sptHex:self.HexValue := GetHexValue;
  end;
end;

function TAdvSpinEdit.GetTimeValue: TDateTime;
begin

  try
    if not FShowSeconds then
      Result := Int(FTimeValue) + StrToTime(Text+TimeSeparator+'00')
    else
      Result := Int(FTimeValue) + StrToTime(Text);
  except
    Result := 0;
  end;
end;

procedure TAdvSpinEdit.SetTimeValue(const Value: TDateTime);
var
  ss: Integer;
begin
  FTimeValue := Value;
  if (csLoading in ComponentState) then
    Exit;

  ss := SelStart;

  if FShowSeconds then
    Text := FormatDateTime('h'+TimeSeparator+'nn'+TimeSeparator+'ss',Value)
  else
    Text := FormatDateTime('h'+TimeSeparator+'nn',Value);

  Selstart := ss;
end;

function TAdvSpinEdit.GetDateValue: TDateTime;
begin
  if (Text = '0') or (Text = '') then
    Result := Now
  else
   try
     Result := Frac(FDateValue) + StrToDate(Text);
   except
     Result := FMinDateValue;
   end;
end;

procedure TAdvSpinEdit.SetDateValue(const Value: TDateTime);
var
  ss: Integer;
begin
  FDateValue := Value;
  if (csLoading in ComponentState) then
    Exit;
  FDateValue := CheckDateValue(value);
  ss := SelStart;
  text := DateToStr(fdateValue);
  SelStart := ss;
end;

function TAdvSpinEdit.GetHexValue: integer;
var
 s:string;
 r: Integer;
begin
 s:=self.text;
 delete(s,1,2);
 r:=0;
 while (length(s)>=2) do
  begin
   r:=r*256+HexVal(copy(s,1,2));
   delete(s,1,2);
  end;
 if (length(s)=1) then
  begin
   r:=r*16+HexVal(s);
  end;
 result:=r;
end;

procedure TAdvSpinEdit.SetHexValue(const Value: integer);
begin
 fHexValue:=value;
 if (csLoading in ComponentState) then exit;
 text:='0x'+IntToHex(value,0);
end;

function Exp10(n: Integer): Integer;
var
 i: Integer;
begin
 result:=1;
 for i:=1 to n do result:=result*10;
end;

function Div10(n: Integer):double;
var
 i: Integer;
begin
 result:=1;
 for i:=1 to n do result:=result/10;
end;

procedure TAdvSpinEdit.DecSmart;
var
 ss,sp: Integer;
 incd: Integer;
 incf:double;
begin
 ss:=Length(Text)-SelStart;
 sp:=Length(Text)-Pos(decimalseparator,self.Text);

 if (SelStart=0) or ((pos('-',Text)>0) and (SelStart=1)) then
   begin
    case fSpinType of
    sptNormal: Value := Value - Increment;
    sptFloat:  FloatValue := FloatValue - IncrementFloat;
    end;
    Exit;
   end;

 if (sp=Length(Text)) then sp:=-1;

 if (sp<=ss) then
  begin
   incd:=Exp10(ss-sp-1);
   case fSpinType of
   sptNormal: Value := Value - incd;
   sptFloat:  FloatValue := FloatValue - incd;
   end;
 end
 else
  begin
   incf:=Div10(sp-ss);
   case fSpinType of
   sptFloat:  FloatValue := FloatValue - incf;
   end;
  end;
end;

procedure TAdvSpinEdit.IncSmart;
var
 ss,sp: Integer;
 incd: Integer;
 incf:double;
begin
 ss:=Length(Text)-SelStart;
 sp:=Length(Text)-Pos(decimalseparator,self.Text);

 if (SelStart=0) or ((pos('-',Text)>0) and (SelStart=1)) then
   begin
    case fSpinType of
    sptNormal: Value := Value + Increment;
    sptFloat:  FloatValue := FloatValue + IncrementFloat;
    end;
    Exit;
   end;

 if (sp=Length(Text)) then sp:=-1;

 if (sp<=ss)  then
  begin
   incd:=Exp10(ss-sp-1);
   case fSpinType of
   sptNormal: Value := Value + incd;
   sptFloat:  FloatValue := FloatValue + incd;
   end;
 end
 else
  begin
   incf:=Div10(sp-ss);
   case fSpinType of
   sptFloat:  FloatValue := FloatValue + incf;
   end;
  end;

end;

procedure TAdvSpinEdit.UpdateLabel;
begin
 fLabel.transparent:=flabeltransparent;
 case fLabelPosition of
 lpLeftTop:begin
            flabel.top:=self.top;
            flabel.left:=self.left-flabel.canvas.textwidth(flabel.caption)-fLabelMargin;
           end;
 lpLeftCenter:begin
               flabel.top:=self.top+((self.height-flabel.height) shr 1);
               flabel.left:=self.left-flabel.canvas.textwidth(flabel.caption)-flabelMargin;
              end;
 lpLeftBottom:begin
               flabel.top:=self.top+self.height-flabel.height;
               flabel.left:=self.left-flabel.canvas.textwidth(flabel.caption)-fLabelMargin;
              end;
 lpTopLeft:begin
             flabel.top:=self.top-flabel.height-fLabelMargin;
             flabel.left:=self.left;
           end;
 lpTopCenter:begin
               FLabel.Top := self.top-FLabel.height-FLabelMargin;
               FLabeL.Left := self.Left + ((self.Width-FLabel.width) shr 1);
             end;

 lpBottomLeft:begin
               flabel.top:=self.top+self.height+fLabelMargin;
               flabel.left:=self.left;
              end;
 lpBottomCenter:begin
                 FLabel.top := self.top+self.height+FLabelMargin;
                 FLabeL.Left := self.Left + ((self.Width-FLabel.width) shr 1);
                end;

 lpLeftTopLeft:begin
                flabel.top:=self.top;
                flabel.left:=self.left-fLabelMargin;
               end;
 lpLeftCenterLeft:begin
                  flabel.top:=self.top+((self.height-flabel.height) shr 1);
                  flabel.left:=self.left-flabelMargin;
                  end;
 lpLeftBottomLeft:begin
                   flabel.top:=self.top+self.height-flabel.height;
                   flabel.left:=self.left-fLabelMargin;
                  end;
 end;
 fLabel.Font.Assign(fLabelFont);
end;

function TAdvSpinEdit.CreateLabel: TLabel;
begin
  Result := Tlabel.Create(self);
  Result.Parent := Parent;
  Result.FocusControl := Self;
  Result.Font.Assign(Font);
end;

function TAdvSpinEdit.GetLabelCaption: string;
begin
  if FLabel <> nil then
    Result := FLabel.Caption
  else
    Result := '';
end;

procedure TAdvSpinEdit.SetLabelCaption(const Value: string);
begin
  if FLabel = nil then
    FLabel := CreateLabel;

  FLabel.Caption := Value;
  UpdateLabel;
end;

procedure TAdvSpinEdit.SetLabelMargin(const Value: integer);
begin
  FLabelMargin := Value;
  if FLabel <> nil then
    UpdateLabel;
end;

procedure TAdvSpinEdit.SetLabelPosition(const Value: TLabelPosition);
begin
  FLabelPosition := Value;
  if FLabel <> nil then
    UpdateLabel;
end;

procedure TAdvSpinEdit.SetLabelTransparent(const Value: boolean);
begin
  FLabeltransparent := Value;
  if FLabel <> nil then
    UpdateLabel;
end;

function TAdvSpinEdit.GetVisible: boolean;
begin
  Result := inherited Visible;
end;

procedure TAdvSpinEdit.SetVisible(const Value: boolean);
begin
  inherited Visible := Value;
  if (FLabel <> nil) then
    FLabel.Visible := value;
end;

procedure TAdvSpinEdit.LabelFontChange(Sender: TObject);
begin
  if (FLabel <> nil) then
    UpdateLabel;
end;

procedure TAdvSpinEdit.SetLabelFont(const Value: TFont);
begin
  FLabelFont.Assign(Value);
end;

procedure TAdvSpinEdit.CNCtlColorEdit(var Message: TWMCtlColorEdit);
begin
  inherited;
  if FTransparent then
    SetBkMode(Message.ChildDC, Windows.TRANSPARENT);
end;

procedure TAdvSpinEdit.CNCtlColorStatic(var Message: TWMCtlColorStatic);
begin
  inherited;
  if FTransparent then
    SetBkMode(Message.ChildDC, Windows.TRANSPARENT);
end;

procedure TAdvSpinEdit.CNCommand(var Message: TWMCommand);
begin
  if (Message.NotifyCode = EN_CHANGE) then
    if FTransparent then Invalidate;
  inherited;
end;

procedure TAdvSpinEdit.CMFontChanged(var Message: TMessage);
begin
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then
    if FLabel<>nil then
      FLabel.Font.Assign(self.font);
  inherited;
  SetFlatRect(fFlat);
end;


procedure TAdvSpinEdit.WMPaint(var Msg:TWMPaint);
begin
  inherited;
  PaintEdit;
end;

procedure TAdvSpinEdit.PaintEdit;
var
 DC: HDC;
 oldpen: HPen;
 loc: TRect;
 voffset: Integer;
begin

 if FFlat then
  begin
   DC := GetDC(Handle);
   voffset := 1;

   oldpen := SelectObject(dc,CreatePen( PS_SOLID,1,ColorToRGB(fFlatLineColor)));
   SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
   MovetoEx(dc,loc.left,self.height-vOffset,nil);
   LineTo(dc,loc.right,self.height-vOffset);
   DeleteObject(selectobject(dc,oldpen));

   ReleaseDC(Handle,DC);
  end;

 {
 if (FCaretPos.x <> -1) and (FCaretPos.y <> -1) then
  begin
   DC := GetDC(Handle);
   Rectangle(dc,fCaretPos.x,fCaretPos.y,fCaretPos.x+1,fCaretPos.y-Font.Height);
   ReleaseDC(Handle,DC);
  end;
 }
end;

procedure TAdvSpinEdit.WMEraseBkGnd(var Message: TWMEraseBkGnd);
var
  DC: HDC;
  i: integer;
  p: TPoint;
begin
  if FTransparent then
  begin
    if Assigned(Parent) then
    begin
      DC := Message.DC;
      i := SaveDC(DC);
      p := ClientOrigin;
      Windows.ScreenToClient(Parent.Handle, p);
      p.x := -p.x;
      p.y := -p.y;
      MoveWindowOrg(DC, p.x, p.y);
      SendMessage(Parent.Handle, WM_ERASEBKGND, Longint(DC), 0);
      TWinCtrl(Parent).PaintControls(DC, nil);
      RestoreDC(DC, i);
    end;
  end
  else
    inherited;
end;

procedure TAdvSpinEdit.SetTransparent(const Value: Boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    Invalidate;
  end;
end;

procedure TAdvSpinEdit.SetFlatRect(const Value: Boolean);
var
  loc:TRect;
begin
  if value then
  begin
    loc.left := 2;
    loc.top := 4;
    loc.right := ClientRect.Right - 2 - FButton.Width - 2;
    loc.bottom := ClientRect.Bottom - 4;
  end
  else
  begin
    loc.left := 0;
    loc.top := 0;
    loc.right := Clientrect.Right - FButton.Width - 2;
    loc.bottom := Clientrect.Bottom;
  end;
  SendMessage(self.handle,EM_SETRECTNP,0,longint(@loc));
end;

procedure TAdvSpinEdit.SetFlat(const value: boolean);
//var
// OldColor:TColor;
begin
  if (csLoading in ComponentState) then
  begin
    FFlat := Value;
    Exit;
  end;

  if FFlat<>value then
  begin
    FFlat := Value;
    if FFlat then
    begin
      FNormalColor := Color;
      Borderstyle := bsNone;
      SetFlatRect(True);
    end
    else
    begin
      Color := FNormalColor;
      Borderstyle := bsSingle;
      SetFlatRect(false);
    end;
    Invalidate;
  end;
end;


procedure TAdvSpinEdit.SetFlatLineColor(const Value: TColor);
begin
  FFlatLineColor := Value;
  Invalidate;
end;

procedure TAdvSpinEdit.CMMouseEnter(var Msg: TMessage);
begin
  inherited;
  if FAutoFocus then
    SetFocus;
end;

procedure TAdvSpinEdit.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
end;

procedure TAdvSpinEdit.WMChar(var Msg: TWMKey);
var
  key: Char;
  s:string;
  OldSS,OldSL: integer;
begin
  if (Msg.CharCode = Ord('+')) then
    Msg.CharCode := 0;

  if (Msg.CharCode = Ord('-')) then
  begin
    Msg.CharCode := 0;
    s := Text;

    OldSS := SelStart;
    OldSL := SelLength;

    if Signed then
    begin
      if pos('-',s)=1 then
      begin
        Delete(s,1,1);
        Dec(OldSS);
      end
      else
      begin
        s := '-'  + s;
        inc(OldSS);
      end;
    end;
    Text := s;

    SelStart := OldSS;
    SelLength := OldSL;
  end;


  if Msg.CharCode = VK_RETURN then
  begin
    key := #13;
    if Assigned(OnKeyPress) then
      OnKeyPress(Self,key);
    Msg.CharCode := 0;
    Exit;
  end;
  inherited;
end;

procedure TAdvSpinEdit.SetShowSeconds(const Value: Boolean);
var
  TV: TDateTime;
begin
  if SpinType = sptTime then
  begin
    TV := FTimeValue;
    FShowSeconds := Value;
    SetTimeValue(TV);
  end;
end;

procedure TAdvSpinEdit.SetLabelAlwaysEnabled(const Value: Boolean);
begin
  FLabelAlwaysEnabled := Value;
  if FLabel <> nil then
    if Value then
      FLabel.Enabled := True;
  Invalidate;
end;

function TAdvSpinEdit.GetEnabledEx: Boolean;
begin
  Result := inherited Enabled;
end;

procedure TAdvSpinEdit.SetEnabledEx(const Value: Boolean);
var
  OldValue: Boolean;
begin
  OldValue := inherited Enabled;

  inherited Enabled := Value;

  if (csLoading in ComponentState) or
     (csDesigning in ComponentState) then
    Exit;

  if OldValue <> Value then
  begin
    if Assigned(FLabel) then
      if not FLabelAlwaysEnabled then
        FLabel.Enabled := Value;
  end;
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
 invalidaterect(parent.handle,nil,true);
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

  if DoVisualStyles then
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
    bdLeft:DrawFrameControl(Canvas.Handle,r,DFC_SCROLL,DFCS_SCROLLLEFT or flags[fState=bsDown] {$IFDEF DELPHI3_LVL}or flats[flat]{$ENDIF});
    bdRight:DrawFrameControl(Canvas.Handle,r,DFC_SCROLL,DFCS_SCROLLRIGHT or flags[fState=bsDown] {$IFDEF DELPHI3_LVL}or flats[flat]{$ENDIF});
    bdUp,bdDown:inherited Paint;
    end;
  end;
end;

constructor TAdvTimerSpeedButton.Create(AOwner: TComponent);
var
  dwVersion:Dword;
  dwWindowsMajorVersion,dwWindowsMinorVersion:Dword;
begin
  inherited;

  dwVersion := GetVersion;
  dwWindowsMajorVersion :=  DWORD(LOBYTE(LOWORD(dwVersion)));
  dwWindowsMinorVersion :=  DWORD(HIBYTE(LOWORD(dwVersion)));

  FIsWinXP := (dwWindowsMajorVersion > 5) OR
    ((dwWindowsMajorVersion = 5) AND (dwWindowsMinorVersion >= 1));

  FHasMouse := False;
end;

function TAdvTimerSpeedButton.DoVisualStyles: Boolean;
begin
  if FIsWinXP then
    Result := IsThemeActive
  else
    Result := False;
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
