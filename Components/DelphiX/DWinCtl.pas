unit DWinCtl;

interface

uses
  Windows, Classes, Graphics, SysUtils, Controls, DXDraws, DXClass, StdCtrls,
  Forms, DirectX, DIB, Grids, wmUtil, WIL, cliUtil;

const
  LineSpace                 = 2;
  LineSpace2                = 5;
  SWH800                    = 0;
  SWH1024                   = 1;
  SWH                       = SWH1024;

{$IF SWH = SWH800}
  SCREENWIDTH               = 800;
  SCREENHEIGHT              = 600;
{$ELSEIF SWH = SWH1024}
  SCREENWIDTH               = 1024;
  SCREENHEIGHT              = 768;
{$IFEND}

  WINLEFT                   = 60;
  WINTOP                    = 60;
  WINRIGHT                  = SCREENWIDTH - 60;
  BOTTOMEDGE                = SCREENHEIGHT - 30;

  DECALW                    = 6;
  DECALH                    = 4;

type
  TClickSound = (csNone, csStone, csGlass, csNorm);
  TDControl = class;
  TOnDirectPaint = procedure(Sender: TObject; dsurface: TDirectDrawSurface) of object;
  TOnKeyPress = procedure(Sender: TObject; var Key: Char) of object;
  TOnKeyDown = procedure(Sender: TObject; var Key: Word; Shift: TShiftState) of object;
  TOnMouseMove = procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
  TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TOnClick = procedure(Sender: TObject) of object;
  TOnClickEx = procedure(Sender: TObject; X, Y: Integer) of object;
  TOnInRealArea = procedure(Sender: TObject; X, Y: Integer; var IsRealArea: Boolean) of object;
  TOnGridSelect = procedure(Sender: TObject; ACol, ARow: Integer; Shift: TShiftState) of object;
  TOnGridPaint = procedure(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface) of object;
  TOnClickSound = procedure(Sender: TObject; Clicksound: TClickSound) of object;

  TDControl = class(TCustomControl)
  private
    FPageActive: Boolean;
    FCaption: string;
    FDParent: TDControl;
    FEnableFocus: Boolean;
    FOnDirectPaint: TOnDirectPaint;
    FOnKeyPress: TOnKeyPress;
    FOnKeyDown: TOnKeyDown;
    FOnMouseMove: TOnMouseMove;
    FOnMouseDown: TOnMouseDown;
    FOnMouseUp: TOnMouseUp;
    FOnDblClick: TNotifyEvent;
    FOnClick: TOnClickEx;
    FOnInRealArea: TOnInRealArea;
    FOnBackgroundClick: TOnClick;
    procedure SetCaption(Str: string);
  protected
    FVisible: Boolean;
  public
    Background: Boolean;
    DControls: TList;
    WLib: TWMImages;
    FaceIndex: Integer;
    WantReturn: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Loaded; override;
    function SurfaceX(X: Integer): Integer;
    function SurfaceY(Y: Integer): Integer;
    function LocalX(X: Integer): Integer;
    function LocalY(Y: Integer): Integer;
    procedure AddChild(dcon: TDControl);
    procedure ChangeChildOrder(dcon: TDControl);
    function InRange(X, Y: Integer): Boolean;
    function KeyPress(var Key: Char): Boolean; dynamic;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; dynamic;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
    function DblClick(X, Y: Integer): Boolean; dynamic;
    function Click(X, Y: Integer): Boolean; dynamic;
    function CanFocusMsg: Boolean;
    procedure SetImgIndex(Lib: TWMImages; Index: Integer);
    procedure SetImgIndexName(Lib: TWMImages; Index: Integer; const F: string = '');
    procedure DirectPaint(dsurface: TDirectDrawSurface); dynamic;
    property PageActive: Boolean read FPageActive write FPageActive;
  published
    property OnDirectPaint: TOnDirectPaint read FOnDirectPaint write FOnDirectPaint;
    property OnKeyPress: TOnKeyPress read FOnKeyPress write FOnKeyPress;
    property OnKeyDown: TOnKeyDown read FOnKeyDown write FOnKeyDown;
    property OnMouseMove: TOnMouseMove read FOnMouseMove write FOnMouseMove;
    property OnMouseDown: TOnMouseDown read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TOnMouseUp read FOnMouseUp write FOnMouseUp;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnInRealArea: TOnInRealArea read FOnInRealArea write FOnInRealArea;
    property OnBackgroundClick: TOnClick read FOnBackgroundClick write FOnBackgroundClick;
    property Caption: string read FCaption write SetCaption;
    property DParent: TDControl read FDParent write FDParent;
    property Visible: Boolean read FVisible write FVisible;
    property EnableFocus: Boolean read FEnableFocus write FEnableFocus;
    property Color;
    property Font;
    property Hint;
    property ShowHint;
    property Align;
  end;

  TDButton = class(TDControl)
  private
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
  public
    Downed: Boolean;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDCheckBox = class(TDControl)
  private
    FChecked: Boolean;
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
  public
    Downed: Boolean;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    property Checked: Boolean read FChecked write FChecked;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDCustomControl = class(TDControl)
  private
    FEnabled: Boolean;
    FTransparent: Boolean;
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
    FFrameVisible: Boolean;
    FFrameHot: Boolean;
    FFrameSize: Byte;
    FFrameColor: TColor;
    FFrameHotColor: TColor;
    procedure SetTransparent(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetFrameVisible(Value: Boolean);
    procedure SetFrameHot(Value: Boolean);
    procedure SetFrameSize(Value: Byte);
    procedure SetFrameColor(Value: TColor);
    procedure SetFrameHotColor(Value: TColor);
  protected
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Transparent: Boolean read FTransparent write SetTransparent default True;
    property FrameVisible: Boolean read FFrameVisible write SetFrameVisible default True;
    property FrameHot: Boolean read FFrameHot write SetFrameHot default False;
    property FrameSize: Byte read FFrameSize write SetFrameSize default 1;
    property FrameColor: TColor read FFrameColor write SetFrameColor default $00406F77;
    property FrameHotColor: TColor read FFrameHotColor write SetFrameHotColor default $00599AA8;
  public
    Downed: Boolean;
    //OnEnterKey: procedure of object;
    //OntTabKey: procedure of object;
    procedure OnDefaultEnterKey;
    procedure OnDefaultTabKey;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDxScrollBarBar = class(TDCustomControl)
  protected
    StartPosY, TotH, hAuteur, dify: Integer;
    Selected: Boolean;
    TmpList: TStrings;
  public
    ModPos: Integer;
    procedure AJust_H;
    function GetPos: Integer;
    procedure MoveBar(nposy: Integer);
    procedure MoveModPos(nMove: Integer);
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    constructor Create(AOwner: TComponent; nTmpList: TStrings);
  end;

  TDxScrollBarUp = class(TDCustomControl)
  protected
    Selected: Boolean;
  public
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
  end;

  TDxScrollBarDown = class(TDxScrollBarUp)
  public
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
  end;

  TDxScrollBar = class(TDCustomControl)
  protected
    TotH: Integer;
    BUp: TDxScrollBarUp;
    BDown: TDxScrollBarDown;
    Bar: TDxScrollBarBar;
  public
    function GetPos: Integer;
    procedure MoveModPos(nMove: Integer);
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    constructor Create(AOwner: TComponent; nTmpList: TStrings);
  end;

  TDComboBox = class;
  TDxCustomListBox = class(TDCustomControl)
  private
    FItems: TStrings;
    FSelected: Integer;
    FBackColor: TColor;
    FSelectionColor: TColor;
    FParentComboBox: TDComboBox;
    function GetItemSelected: Integer;
    procedure SetItems(Value: TStrings);
    procedure SetBackColor(Value: TColor);
    procedure SetSelectionColor(Value: TColor);
    procedure SetItemSelected(Value: Integer);
  public
    OnChangeSelect: procedure(ChangeSelect: Integer) of object;
    property Items: TStrings read FItems write SetItems;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clSilver;
    property ItemSelected: Integer read GetItemSelected write SetItemSelected;
    property ParentComboBox: TDComboBox read FParentComboBox write FParentComboBox;

    procedure ChangeSelect(ChangeSelect: Integer);
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
  end;

  TDxHint = class(TDCustomControl)
  private
    FItems: TStrings;
    FBackColor: TColor;
    FSelectionColor: TColor;
    FParentControl: TDControl;
    function GetItemSelected: Integer;
    procedure SetItems(Value: TStrings);
    procedure SetBackColor(Value: TColor);
    procedure SetSelectionColor(Value: TColor);
    procedure SetItemSelected(Value: Integer);
  public
    FSelected: Integer;
    FOnChangeSelect: procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
    FOnMouseMoveSelect: procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
    property Items: TStrings read FItems write SetItems;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clSilver;
    property ItemSelected: Integer read GetItemSelected write SetItemSelected;
    property ParentControl: TDControl read FParentControl write FParentControl;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
  end;

  TDListBox = class(TDxCustomListBox)
  published
    property Enabled;
    property Transparent;
    property BackColor;
    property SelectionColor;
    property FrameVisible;
    property FrameHot;
    property FrameSize;
    property FrameColor;
    property FrameHotColor;
    property ParentComboBox;
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TAlignment = (taCenter, taLeftJustify {, taRightJustify});

  TDxCustomEdit = class(TDCustomControl)
  private
    FAtom: Word;
    FHotKey: Cardinal;
    FIsHotKey: Boolean;
    FAlignment: TAlignment;
    FClick: Boolean;
    FCurPos: Integer;
    FClickX: Integer;
    FStartTextX: Integer;
    FMaxLength: Integer;
    FShowCaretTick: LongWord;
    FShowCaret: Boolean;
    FNomberOnly: Boolean;
    FSecondChineseChar: Boolean;
    FPasswordChar: Char;
    procedure SetMaxLength(Value: Integer);
    procedure SetPasswordChar(Value: Char);
    procedure SetNomberOnly(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure SetIsHotKey(Value: Boolean);
    procedure SetHotKey(Value: Cardinal);
    procedure SetAtom(Value: Word);
  protected
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property NomberOnly: Boolean read FNomberOnly write SetNomberOnly default False;
    property IsHotKey: Boolean read FIsHotKey write SetIsHotKey default False;
    property Atom: Word read FAtom write SetAtom default 0;
    property HotKey: Cardinal read FHotKey write SetHotKey default 0;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property PasswordChar: Char read FPasswordChar write SetPasswordChar default #0;
  public
    procedure ShowCaret();
    procedure ChangeCurPos(nPos: Integer);
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    //function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    function KeyPress(var Key: Char): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    function SetOfHotKey(HotKey: Cardinal): Word;
    //procedure RemoveHotKey();
  end;

  TDxEdit = class(TDxCustomEdit)
  published
    property Alignment;
    property IsHotKey;
    property HotKey;
    property Enabled;
    property MaxLength;
    property NomberOnly;
    property Transparent;
    property PasswordChar;
    property FrameVisible;
    property FrameHot;
    property FrameSize;
    property FrameColor;
    property FrameHotColor;
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDComboBox = class(TDxCustomEdit)
  private
    FDropDownList: TDListBox;
  protected
    //
  public
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    //function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  published
    property Enabled;
    property MaxLength;
    property NomberOnly;
    property Transparent;
    property PasswordChar;
    property FrameVisible;
    property FrameHot;
    property FrameSize;
    property FrameColor;
    property FrameHotColor;
    property DropDownList: TDListBox read FDropDownList write FDropDownList;
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDGrid = class(TDControl)
  private
    FColCount, FRowCount: Integer;
    FColWidth, FRowHeight: Integer;
    FViewTopLine: Integer;
    SelectCell: TPoint;
    DownPos: TPoint;
    FOnGridSelect: TOnGridSelect;
    FOnGridMouseMove: TOnGridSelect;
    FOnGridPaint: TOnGridPaint;
    function GetColRow(X, Y: Integer; var ACol, ARow: Integer): Boolean;
  public
    cx, cy: Integer;
    Col, Row: Integer;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function Click(X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
  published
    property ColCount: Integer read FColCount write FColCount;
    property RowCount: Integer read FRowCount write FRowCount;
    property ColWidth: Integer read FColWidth write FColWidth;
    property RowHeight: Integer read FRowHeight write FRowHeight;
    property ViewTopLine: Integer read FViewTopLine write FViewTopLine;
    property OnGridSelect: TOnGridSelect read FOnGridSelect write FOnGridSelect;
    property OnGridMouseMove: TOnGridSelect read FOnGridMouseMove write FOnGridMouseMove;
    property OnGridPaint: TOnGridPaint read FOnGridPaint write FOnGridPaint;
  end;

  TDWindow = class(TDButton)
  private
    FFloating: Boolean;
    SpotX, SpotY: Integer;
  protected
    procedure SetVisible(flag: Boolean);
  public
    DialogResult: TModalResult;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure show;
    function ShowModal: Integer;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Floating: Boolean read FFloating write FFloating;
  end;

  TDWinManager = class(TComponent)
  private
  public
    DWinList: TList; //list of TDControl;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddDControl(dcon: TDControl; Visible: Boolean);
    procedure DelDControl(dcon: TDControl);
    procedure ClearAll;

    function KeyPress(var Key: Char): Boolean;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function DblClick(X, Y: Integer): Boolean;
    function Click(X, Y: Integer): Boolean;
    procedure DirectPaint(dsurface: TDirectDrawSurface);
  end;

TDMoveButton = class(TDButton)
  private
    FFloating: Boolean;
    SpotX, SpotY: Integer;
  protected
    procedure SetVisible(flag: Boolean);
  public
    iMisc: array[0..1] of Integer;
    sMisc: string;
    sMisc2: string;
    DialogResult: TModalResult;
    FOnClick: TOnClickEx;
    Boxmovetop: Integer;
    ttt: string;
    RLeft: Integer;
    RTop: Integer;
    outidx: Integer;
    outHeight: Integer;
    listcont: Integer;
    MoveHeight: Integer;
    Reverse: Boolean;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Show;
    function ShowModal: Integer;
    procedure exitHeightout;
    procedure UpHeightout;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Floating: Boolean read FFloating write FFloating;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property FBoxmovetop: Integer read Boxmovetop write Boxmovetop;
    property TypeRLeft: Integer read RLeft write RLeft;
    property TypeRTop: Integer read RTop write RTop;
    property TReverse: Boolean read Reverse write Reverse;
  end;

procedure Register;
procedure SetDFocus(dcon: TDControl);
procedure ReleaseDFocus;
procedure SetDCapture(dcon: TDControl);
procedure ReleaseDCapture;

var
  MouseCaptureControl       : TDControl; //mouse message
  FocusedControl            : TDControl; //Key message
  MainWinHandle             : Integer;
  ModalDWindow              : TDControl;
  g_MainHWnd                : HWND;

implementation

//uses ClMain;

procedure Register;
begin
  RegisterComponents('MirGame', [TDWinManager, TDControl, TDButton, TDCheckBox, TDxEdit, TDListBox, TDComboBox, TDGrid, TDWindow, TDMoveButton, TDxHint]);
end;

procedure SetDFocus(dcon: TDControl);
begin
  FocusedControl := dcon;
  if dcon is TDxCustomEdit then begin
    with TDxCustomEdit(dcon) do begin
      ShowCaret();
      ChangeCurPos(Length(Caption) - FCurPos);
    end;
  end;
end;

procedure ReleaseDFocus;
begin
  FocusedControl := nil;
end;

procedure SetDCapture(dcon: TDControl);
begin
  SetCapture(MainWinHandle);
  MouseCaptureControl := dcon;
end;

procedure ReleaseDCapture;
begin
  ReleaseCapture;
  MouseCaptureControl := nil;
end;

{----------------------------- TDControl -------------------------------}

constructor TDControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DParent := nil;
  inherited Visible := False;
  FEnableFocus := False;
  Background := False;

  FOnDirectPaint := nil;
  FOnKeyPress := nil;
  FOnKeyDown := nil;
  FOnMouseMove := nil;
  FOnMouseDown := nil;
  FOnMouseUp := nil;
  FOnInRealArea := nil;
  DControls := TList.Create;
  FDParent := nil;

  Width := 80;
  Height := 24;
  FCaption := '';
  FVisible := True;
  WLib := nil;
  FaceIndex := 0;
  PageActive := False;
  //FClickTick := GetTickCount;
end;

destructor TDControl.Destroy;
begin
  DControls.Free;
  inherited Destroy;
end;

procedure TDControl.SetCaption(Str: string);
begin
  FCaption := Str;
  if csDesigning in ComponentState then begin
    Refresh;
  end;
end;

procedure TDControl.Paint;
begin
  if csDesigning in ComponentState then begin
    if self is TDWindow then begin
      with Canvas do begin
        Pen.Color := clNavy;
        MoveTo(0, 0);
        LineTo(Width - 1, 0);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, 0);
        LineTo(Width - 1, Height - 1);
        MoveTo(Width - 1, 0);
        LineTo(0, Height - 1);
        TextOut((Width - TextWidth(Caption)) div 2, (Height - TextHeight(Caption)) div 2, Caption);
      end;
    end else begin
      with Canvas do begin
        Pen.Color := clNavy;
        MoveTo(0, 0);
        LineTo(Width - 1, 0);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, 0);
        TextOut((Width - TextWidth(Caption)) div 2, (Height - TextHeight(Caption)) div 2, Caption);
      end;
    end;
  end;
end;

procedure TDControl.Loaded;
var
  i                         : Integer;
  dcon                      : TDControl;
begin
  if not (csDesigning in ComponentState) then begin
    if Parent <> nil then
      for i := 0 to TControl(Parent).ComponentCount - 1 do begin
        if TControl(Parent).Components[i] is TDControl then begin
          dcon := TDControl(TControl(Parent).Components[i]);
          if dcon.DParent = self then begin
            AddChild(dcon);
          end;
        end;
      end;
  end;
end;

function TDControl.SurfaceX(X: Integer): Integer;
var
  d                         : TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then Break;
    X := X + d.DParent.Left;
    d := d.DParent;
  end;
  Result := X;
end;

function TDControl.SurfaceY(Y: Integer): Integer;
var
  d                         : TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then Break;
    Y := Y + d.DParent.Top;
    d := d.DParent;
  end;
  Result := Y;
end;

function TDControl.LocalX(X: Integer): Integer;
var
  d                         : TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then Break;
    X := X - d.DParent.Left;
    d := d.DParent;
  end;
  Result := X;
end;

function TDControl.LocalY(Y: Integer): Integer;
var
  d                         : TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then Break;
    Y := Y - d.DParent.Top;
    d := d.DParent;
  end;
  Result := Y;
end;

procedure TDControl.AddChild(dcon: TDControl);
begin
  DControls.Add(Pointer(dcon));
end;

procedure TDControl.ChangeChildOrder(dcon: TDControl);
var
  i                         : Integer;
begin
  if not (dcon is TDWindow) then Exit;
  if TDWindow(dcon).Floating then begin
    for i := 0 to DControls.count - 1 do begin
      if dcon = DControls[i] then begin
        DControls.Delete(i);
        Break;
      end;
    end;
    DControls.Add(dcon);
  end;
end;

function TDControl.InRange(X, Y: Integer): Boolean;
var
  InRange                   : Boolean;
  d                         : TDirectDrawSurface;
begin
  if (X >= Left) and (X < (Left + Width)) and (Y >= Top) and (Y < (Top + Height)) then begin
    InRange := True;
    if Assigned(FOnInRealArea) then
      FOnInRealArea(self, X - Left, Y - Top, InRange)
    else if WLib <> nil then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        if d.Pixels[X - Left, Y - Top] <= 0 then
          InRange := False;
    end;
    Result := InRange;
  end else
    Result := False;
end;

function TDControl.KeyPress(var Key: Char): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if Background then Exit;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).KeyPress(Key) then begin
        Result := True;
        Exit;
      end;
  if (FocusedControl = self) then begin
    if Assigned(FOnKeyPress) then
      FOnKeyPress(self, Key);
    Result := True;
  end;
end;

function TDControl.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if Background then Exit;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).KeyDown(Key, Shift) then begin
        Result := True;
        Exit;
      end;
  if (FocusedControl = self) then begin
    if Assigned(FOnKeyDown) then
      FOnKeyDown(self, Key, Shift);
    Result := True;
  end;
end;

function TDControl.CanFocusMsg: Boolean;
begin
  if (MouseCaptureControl = nil) or ((MouseCaptureControl <> nil) and ((MouseCaptureControl = self) or (MouseCaptureControl = DParent))) then
    Result := True
  else
    Result := False;
end;

function TDControl.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).MouseMove(Shift, X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;

  if (MouseCaptureControl <> nil) then begin
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnMouseMove) then
        FOnMouseMove(self, Shift, X, Y);
      Result := True;
    end;
    Exit;
  end;

  if Background then Exit;
  if InRange(X, Y) then begin
    if Assigned(FOnMouseMove) then
      FOnMouseMove(self, Shift, X, Y);
    Result := True;
  end;
end;

function TDControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).MouseDown(Button, Shift, X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
  if Background then begin
    if Assigned(FOnBackgroundClick) then begin
      WantReturn := False;
      FOnBackgroundClick(self);
      if WantReturn then Result := True;
    end;
    ReleaseDFocus;
    Exit;
  end;
  if CanFocusMsg then begin
    if InRange(X, Y) or (MouseCaptureControl = self) then begin
      if Assigned(FOnMouseDown) then
        FOnMouseDown(self, Button, Shift, X, Y);
      if EnableFocus then begin
        SetDFocus(self);
      end;
      Result := True;
    end;
  end;
end;

function TDControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).MouseUp(Button, Shift, X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;

  if (MouseCaptureControl <> nil) then begin //MouseCapture
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnMouseUp) then
        FOnMouseUp(self, Button, Shift, X, Y);
      Result := True;
    end;
    Exit;
  end;

  if Background then Exit;
  if InRange(X, Y) then begin
    if Assigned(FOnMouseUp) then
      FOnMouseUp(self, Button, Shift, X, Y);
    Result := True;
  end;
end;

function TDControl.DblClick(X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then begin //MouseCapture
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnDblClick) then
        FOnDblClick(self);
      Result := True;
    end;
    Exit;
  end;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).DblClick(X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
  if Background then Exit;
  if InRange(X, Y) then begin
    if Assigned(FOnDblClick) then
      FOnDblClick(self);
    Result := True;
  end;
end;

function TDControl.Click(X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then begin //MouseCapture
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnClick) then begin
        FOnClick(self, X, Y);
      end;
      Result := True;
    end;
    Exit;
  end;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).Click(X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
  if Background then Exit;
  if InRange(X, Y) then begin
    if Assigned(FOnClick) then begin
      FOnClick(self, X, Y);
    end;
    Result := True;
  end;
end;

procedure TDControl.SetImgIndex(Lib: TWMImages; Index: Integer);
var
  d                         : TDirectDrawSurface;
begin
  if Lib <> nil then begin
    d := Lib.Images[Index];
    WLib := Lib;
    FaceIndex := Index;
    if d <> nil then begin
      Width := d.Width;
      Height := d.Height;
    end;
  end;
end;

procedure TDControl.SetImgIndexName(Lib: TWMImages; Index: Integer; const F: string = '');
var
  d                         : TDirectDrawSurface;
begin
  if Lib <> nil then begin
    d := Lib.ImagesName[Index, F];
    if d = nil then
      d := Lib.Images[Index];
    WLib := Lib;
    FaceIndex := Index;
    if d <> nil then begin
      Width := d.Width;
      Height := d.Height;
    end;
  end;
end;

procedure TDControl.DirectPaint(dsurface: TDirectDrawSurface);
var
  i                         : Integer;
  d                         : TDirectDrawSurface;
begin
  if Assigned(FOnDirectPaint) then
    FOnDirectPaint(self, dsurface)
  else if WLib <> nil then begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
  end;
  for i := 0 to DControls.count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
end;

{--------------------- TDButton --------------------------}

constructor TDButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Downed := False;
  FOnClick := nil;
  FEnableFocus := True;
  FClickSound := csNone;
end;

function TDButton.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if (not Background) and (not Result) then begin
    Result := inherited MouseMove(Shift, X, Y);
    if MouseCaptureControl = self then
      if InRange(X, Y) then
        Downed := True
      else
        Downed := False;
  end;
end;

function TDButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      Downed := True;
      SetDCapture(self);
    end;
    Result := True;
  end;
end;

function TDButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y) then begin
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := False;
    Result := True;
    Exit;
  end else begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

{--------------------- TDCheckBox --------------------------}

constructor TDCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Checked := False;
  Downed := False;
  FOnClick := nil;
  FEnableFocus := True;
  FClickSound := csNone;
end;

function TDCheckBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if (not Background) and (not Result) then begin
    Result := inherited MouseMove(Shift, X, Y);
    if MouseCaptureControl = self then
      if InRange(X, Y) then
        Downed := True
      else
        Downed := False;
  end;
end;

function TDCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      Downed := True;
      SetDCapture(self);
    end;
    Result := True;
  end;
end;

function TDCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y) then begin
        Checked := not Checked;
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := False;
    Result := True;
    Exit;
  end else begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

{--------------------- TDCustomControl --------------------------}

constructor TDCustomControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Downed := False;
  FOnClick := nil;
  FEnableFocus := True;
  FClickSound := csNone;
  FTransparent := True;
  FEnabled := True;
  FFrameVisible := True;
  FFrameHot := False;
  FFrameSize := 1;
  FFrameColor := $00406F77;
  FFrameHotColor := $00599AA8;
end;

procedure TDCustomControl.SetTransparent(Value: Boolean);
begin
  if FTransparent <> Value then
    FTransparent := Value;
end;

procedure TDCustomControl.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
    FEnabled := Value;
end;

procedure TDCustomControl.SetFrameVisible(Value: Boolean);
begin
  if FFrameVisible <> Value then
    FFrameVisible := Value;
end;

procedure TDCustomControl.SetFrameHot(Value: Boolean);
begin
  if FFrameHot <> Value then
    FFrameHot := Value;
end;

procedure TDCustomControl.SetFrameSize(Value: Byte);
begin
  if FFrameSize <> Value then
    FFrameSize := Value;
end;

procedure TDCustomControl.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then begin
    FFrameColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDCustomControl.SetFrameHotColor(Value: TColor);
begin
  if FFrameHotColor <> Value then begin
    FFrameHotColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDCustomControl.OnDefaultEnterKey;
begin
  //
end;

procedure TDCustomControl.OnDefaultTabKey;
begin
  //
end;

function TDCustomControl.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, SurfaceX(X), SurfaceY(Y));
  if FEnabled and not Background then begin
    if Result then
      SetFrameHot(True)
    else if FocusedControl <> self then
      SetFrameHot(False);
  end;
end;

function TDCustomControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, SurfaceX(X), SurfaceY(Y)) then begin
    if FEnabled then begin
      if (not Background) and (MouseCaptureControl = nil) then begin
        Downed := True;
        SetDCapture(self);
      end;
    end;
    Result := True;
  end;
end;

function TDCustomControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, SurfaceX(X), SurfaceY(Y)) then begin
    ReleaseDCapture;
    if FEnabled and not Background then begin
      if InRange(SurfaceX(X), SurfaceY(Y)) then begin
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, SurfaceX(X), SurfaceY(Y));
      end;
    end;
    Downed := False;
    Result := True;
    Exit;
  end else begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

{--------------------- TDxCustomEdit --------------------------}

constructor TDxCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Downed := False;
  FOnClick := nil;
  FEnableFocus := True;
  FClick := False;
  FClickX := 0;
  FStartTextX := 0;
  FCurPos := 0;
  FClickSound := csNone;
  FShowCaret := True;
  FNomberOnly := False;
  FIsHotKey := False;
  FHotKey := 0;
  FTransparent := True;
  FEnabled := True;
  FSecondChineseChar := False;
  FShowCaretTick := GetTickCount;
  FFrameVisible := True;
  FFrameHot := False;
  FFrameSize := 1;
  FFrameColor := $00406F77;
  FFrameHotColor := $00599AA8;
  FAlignment := taLeftJustify;
end;

procedure TDxCustomEdit.SetMaxLength(Value: Integer);
begin
  if FMaxLength <> Value then
    FMaxLength := Value;
end;

procedure TDxCustomEdit.SetPasswordChar(Value: Char);
begin
  if FPasswordChar <> Value then
    FPasswordChar := Value;
end;

procedure TDxCustomEdit.SetNomberOnly(Value: Boolean);
begin
  if FNomberOnly <> Value then
    FNomberOnly := Value;
end;

procedure TDxCustomEdit.SetIsHotKey(Value: Boolean);
begin
  if FIsHotKey <> Value then
    FIsHotKey := Value;
end;

procedure TDxCustomEdit.SetHotKey(Value: Cardinal);
begin
  if FHotKey <> Value then
    FHotKey := Value;
end;

procedure TDxCustomEdit.SetAtom(Value: Word);
begin
  if FAtom <> Value then
    FAtom := Value;
end;

procedure TDxCustomEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
    FAlignment := Value;
end;

procedure TDxCustomEdit.ShowCaret();
begin
  FShowCaret := True;
  FShowCaretTick := GetTickCount;
end;

procedure TDxCustomEdit.ChangeCurPos(nPos: Integer);
begin
  if nPos = 1 then begin
    if ((FCurPos + 1) <= Length(Caption)) and (Caption[FCurPos + 1] > #$80) then
      nPos := 2
  end else begin
    if ((FCurPos + 0) <= Length(Caption)) and (Caption[FCurPos + 0] > #$80) then
      nPos := -2;
  end;
  if ((FCurPos + nPos) <= Length(Caption)) then
    if ((FCurPos + nPos) >= 0) then
      FCurPos := FCurPos + nPos;
end;

function TDxCustomEdit.KeyPress(var Key: Char): Boolean;
begin
  if not FEnabled or FIsHotKey then Exit;
  if (Ord(Key) in [VK_RETURN, VK_ESCAPE]) then begin
    Result := inherited KeyPress(Key);
    Exit;
  end;
  Result := inherited KeyPress(Key);
  if Result then begin
    ShowCaret();
    case Ord(Key) of
      //VK_ESCAPE: ;
      //VK_RETURN: ;
      VK_BACK: if (FCurPos > 0) then begin
          if (FCurPos >= 2) and (Caption[FCurPos] > #$80) and (Caption[FCurPos - 1] > #$80) then begin
            Caption := Copy(Caption, 1, FCurPos - 2) + Copy(Caption, FCurPos + 1, Length(Caption));
            Dec(FCurPos, 2);
          end else begin
            Caption := Copy(Caption, 1, FCurPos - 1) + Copy(Caption, FCurPos + 1, Length(Caption));
            Dec(FCurPos);
          end;
        end;
    else begin
        if (FMaxLength <= 0) or (FMaxLength > MaxChar) then
          FMaxLength := MaxChar;
        if FNomberOnly then begin
          if (Key >= #$30) and (Key <= #$39) then begin
            FSecondChineseChar := False;
            if Length(Caption) < FMaxLength then begin
              Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
              Inc(FCurPos);
            end;
          end;
        end else begin
          if Key > #$80 then begin
            if FSecondChineseChar then begin
              FSecondChineseChar := False;
              if Length(Caption) < FMaxLength then begin
                Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                Inc(FCurPos);
              end;
            end else begin
              if Length(Caption) + 1 < FMaxLength then begin
                FSecondChineseChar := True;
                Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                Inc(FCurPos);
              end;
            end;
          end else begin
            FSecondChineseChar := False;
            if Length(Caption) < FMaxLength then begin
              Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
              Inc(FCurPos);
            end;
          end;
        end;
      end;
    end;
  end;
end;

const
  HotKeyAtomPrefix          = 'Blue_HotKey';

function TDxCustomEdit.SetOfHotKey(HotKey: Cardinal): Word;
var
  //hkr                       : PHotKeyRegistration;
  Modifiers, Key            : Word;
  Atom                      : Word;
begin
  {Result := 0;
  if HotKey = 0 then Exit;
  SeparateHotKey(HotKey, Modifiers, Key);
  if FAtom <> 0 then begin
    UnregisterHotKey(g_MainHWnd, FAtom);
    GlobalDeleteAtom(FAtom);
  end;
  Atom := GlobalAddAtom(PChar(HotKeyAtomPrefix + IntToStr(HotKey)));
  if RegisterHotKey(g_MainHWnd, Atom, Modifiers, Key) then begin
    Result := Atom;
    FAtom := Atom;
    FHotKey := HotKey;
    Caption := HotKeyToText(HotKey, True);
  end else begin
    GlobalDeleteAtom(Atom);
    FAtom := 0;
    FHotKey := 0;
  end;}
end;

{procedure TDxCustomEdit.RemoveHotKey();
begin
  if FAtom <> 0 then begin
    UnregisterHotKey(g_MainHWnd, FAtom);
    GlobalDeleteAtom(FAtom);
  end;
end;}

function TDxCustomEdit.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  M                         : Word;
  HK                        : Cardinal;
  ret, IsRegistered         : Boolean;
  tmpStr                    : string;
begin
  if not FEnabled then Exit;
  ret := inherited KeyDown(Key, Shift);
  if ret then begin
    if FIsHotKey then begin
      if Key in [VK_BACK, VK_DELETE] then begin
        if (FHotKey <> 0) and (FAtom <> 0) then begin
          IsRegistered := UnregisterHotKey(g_MainHWnd, FAtom);
          if IsRegistered then
            GlobalDeleteAtom(FAtom);
          FHotKey := 0;
          FAtom := 0;
        end;
        Caption := '';
        Exit;
      end;
      if (Key = VK_TAB) or (Char(Key) in ['A'..'Z', 'a'..'z']) then begin
        M := 0;
        if ssCtrl in Shift then M := M or MOD_CONTROL;
        if ssAlt in Shift then M := M or MOD_ALT;
        if ssShift in Shift then M := M or MOD_SHIFT;
        //HK := GetHotKey(M, Key);
        if (HK <> 0) and (FHotKey <> 0) and (FAtom <> 0) then begin
          IsRegistered := UnregisterHotKey(g_MainHWnd, FAtom);
          if IsRegistered then
            GlobalDeleteAtom(FAtom);
          FHotKey := 0;
          FAtom := 0;
          Caption := '';
        end;
        if HK <> 0 then SetOfHotKey(HK);
      end;
    end else begin
      ShowCaret();
      case Key of
        VK_RIGHT: ChangeCurPos(1);
        VK_LEFT: ChangeCurPos(-1);
        VK_DELETE: begin
            if FCurPos < Length(Caption) then begin
              if (FCurPos < Length(Caption) - 1) and (Caption[FCurPos + 1] > #$80) then
                Caption := Copy(Caption, 1, FCurPos) + Copy(Caption, FCurPos + 3, Length(Caption))
              else
                Caption := Copy(Caption, 1, FCurPos) + Copy(Caption, FCurPos + 2, Length(Caption));
            end;
          end;
        VK_HOME: ChangeCurPos(-FCurPos);
        VK_END: ChangeCurPos(Length(Caption) - FCurPos);
        //VK_RETURN: OnEnterKey;
        //VK_TAB: OntTabKey;
      end;
    end;
  end;
  Result := ret;
end;

procedure TDxCustomEdit.DirectPaint(dsurface: TDirectDrawSurface);
var
  bIsChinese                : Boolean;
  i, oSize, WidthX          : Integer;
  tmpword                   : string;
  tmpColor, OldColor, OldBColor: TColor;
  OldFont                   : TFont;
begin
  if not Visible then Exit;
  if FEnabled then begin
    if GetTickCount - FShowCaretTick > 600 then begin
      FShowCaretTick := GetTickCount;
      FShowCaret := not FShowCaret;
    end;
    if (FCurPos > Length(Caption)) then
      FCurPos := Length(Caption);
  end;
  if FPasswordChar <> #0 then begin
    tmpword := '';
    for i := 1 to Length(Caption) do
      if Caption[i] <> '*' then
        tmpword := tmpword + '*';
  end else
    tmpword := Caption;

  with dsurface.Canvas do begin
    Brush.Style := bsSolid;
    oSize := Font.Size;
    Font.Size := 9;
    if FEnabled or (self is TDComboBox) then begin
      Font.Color := clWhite;
      Brush.Color := Color;
    end else begin
      Font.Color := clGray;
      Brush.Color := clGray;
    end;
    if FEnabled and FClick then begin
      i := 1;
      bIsChinese := True;
      while (i < Length(tmpword)) and (TextWidth(Copy(tmpword, 1, i), False) < FClickX) do begin
        if tmpword[i] > #$80 then begin
          bIsChinese := True;
          Inc(i, 2);
        end else begin
          bIsChinese := False;
          Inc(i);
        end;
      end;
      if bIsChinese then begin
        if ((TextWidth(Copy(tmpword, 1, i - 1), False) +
          (TextWidth(Copy(tmpword, 1, i + 1), False) -
          TextWidth(Copy(tmpword, 1, i - 1), False)) div 2) < FClickX) then begin
          FCurPos := i + 1;
        end else begin
          FCurPos := i - 1;
        end;
      end else begin
        if ((TextWidth(Copy(tmpword, 1, i - 1), False) +
          (TextWidth(Copy(tmpword, 1, i), False) -
          TextWidth(Copy(tmpword, 1, i - 1), False)) div 2) < FClickX) then begin
          FCurPos := i;
        end else begin
          FCurPos := i - 1;
        end;
      end;
      FClick := False;
    end;
    WidthX := TextWidth(Copy(tmpword, 1, FCurPos), False);
    if WidthX + 3 - FStartTextX > Width then
      FStartTextX := WidthX + 3 - Width;
    if ((WidthX - FStartTextX) < 0) then
      FStartTextX := FStartTextX + (WidthX - FStartTextX);
    if FTransparent then begin
      SetBkMode(Handle, Windows.Transparent);
      case FAlignment of
        taCenter: TextOut((Left - FStartTextX) + ((Width - TextWidth(tmpword, False)) div 2 - 2), Top, tmpword);
        taLeftJustify: TextOut(Left - FStartTextX, Top, tmpword);
        //taRightJustify: TextOut((Left + Width - FStartTextX), Top, tmpword);
      end;
    end else begin
      if FFrameVisible then begin
        if FEnabled or (self is TDComboBox) then begin
          if FFrameHot then
            tmpColor := FFrameHotColor
          else
            tmpColor := FFrameColor;
        end else
          tmpColor := clGray;
        OldColor := Pen.Color;
        Pen.Color := tmpColor;
        Brush.Style := bsclear;
        OldBColor := Color;
        Brush.Color := tmpColor;
        Rectangle(Left - 2, Top - 2, Left + Width - 1, Top + Height - 1);
        Brush.Color := OldBColor;
        Pen.Color := OldColor;
      end;
      if FIsHotKey and FEnabled and (FocusedControl = self) then begin
        case FAlignment of
          taCenter: TextRect(Rect(Left - 2 + FFrameSize + 1, Top - 2 + FFrameSize + 1, Left + Width - 1 - FFrameSize - 1, Top + Height - 1 - FFrameSize - 1), Left - FStartTextX + ((Width - TextWidth(tmpword, False)) div 2 - 2), Top, tmpword);
          taLeftJustify: TextRect(Rect(Left - 2 + FFrameSize + 1, Top - 2 + FFrameSize + 1, Left + Width - 1 - FFrameSize - 1, Top + Height - 1 - FFrameSize - 1), Left - FStartTextX, Top, tmpword);
        //taRightJustify: TextRect(Rect(Left - 2 + FFrameSize, Top - 2 + FFrameSize, Left + Width - 1 - FFrameSize, Top + Height - 1 - FFrameSize), Left - FStartTextX + Width, Top, tmpword);
        end;
      end else begin
        case FAlignment of
          taCenter: TextRect(Rect(Left - 2 + FFrameSize, Top - 2 + FFrameSize, Left + Width - 1 - FFrameSize, Top + Height - 1 - FFrameSize), Left - FStartTextX + ((Width - TextWidth(tmpword, False)) div 2 - 2), Top, tmpword);
          taLeftJustify: TextRect(Rect(Left - 2 + FFrameSize, Top - 2 + FFrameSize, Left + Width - 1 - FFrameSize, Top + Height - 1 - FFrameSize), Left - FStartTextX, Top, tmpword);
        //taRightJustify: TextRect(Rect(Left - 2 + FFrameSize, Top - 2 + FFrameSize, Left + Width - 1 - FFrameSize, Top + Height - 1 - FFrameSize), Left - FStartTextX + Width, Top, tmpword);
        end;
      end;
      if self is TDComboBox then begin
        OldColor := Pen.Color;
        Pen.Color := tmpColor;
        Brush.Style := bsclear;
        OldBColor := Color;
        Brush.Color := tmpColor;
        Polygon([
          Point(Left + Width - DECALW * 2 + Integer(Downed), Top + (Height - DECALH) div 2 - 2 + Integer(Downed)),
            Point(Left + Width - DECALW + Integer(Downed), Top + (Height - DECALH) div 2 - 2 + Integer(Downed)),
            Point(Left + Width - DECALW - DECALW div 2 + Integer(Downed), Top + (Height - DECALH) div 2 + DECALH - 2 + Integer(Downed))
            ]);
        Brush.Color := OldBColor;
        Pen.Color := OldColor;
      end;
    end;
    if FEnabled then
      if (FocusedControl = self) then begin
        SetFrameHot(True);
        if (Length(tmpword) >= FCurPos) and (FShowCaret and not FIsHotKey) then begin
          OldColor := Pen.Color;
          Pen.Color := clWhite;
          Brush.Style := bsclear;
          Brush.Color := clRed;
          case FAlignment of
            taCenter: Rectangle(Left + WidthX - FStartTextX + ((Width - TextWidth(tmpword, False)) div 2 - 2), Top, Left + WidthX + 2 - FStartTextX + ((Width - TextWidth(tmpword, False)) div 2 - 2), Top + TextHeight('c', False));
            taLeftJustify: Rectangle(Left + WidthX - FStartTextX, Top, Left + WidthX + 2 - FStartTextX, Top + TextHeight('c', False));
            //taRightJustify: Rectangle(Left + WidthX - FStartTextX + Width, Top, Left + WidthX + 2 - FStartTextX + Width, Top + TextHeight('c'));
          end;
          Pen.Color := OldColor;
        end;
      end;
    Font.Size := oSize;
    Release;
  end;
  //inherited DirectPaint(dsurface);
end;

function TDxCustomEdit.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if FEnabled and not Background then begin
    if Result then
      SetFrameHot(True)
    else if FocusedControl <> self then
      SetFrameHot(False);
  end;
end;

function TDxCustomEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if FEnabled and not FIsHotKey then begin
      FClick := True;
      FClickX := SurfaceX(X) - Left + FStartTextX;
    end;
    Result := True;
  end;
end;

{--------------------- TDComboBox --------------------------}

constructor TDComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DropDownList := nil;
  FShowCaret := False;
  FTransparent := False;
  FEnabled := False;
  FDropDownList := nil;
end;

function TDComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      Downed := True;
      SetDCapture(self);
    end;
    if FDropDownList <> nil then
      FDropDownList.Visible := not FDropDownList.Visible;
    Result := True;
  end else if FDropDownList <> nil then begin
    if FDropDownList.Visible then
      FDropDownList.Visible := False;
  end;
end;

function TDComboBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if not Background then begin
    if Result then
      SetFrameHot(True)
    else if FocusedControl <> self then
      SetFrameHot(False);
  end;
end;

{--------------------- TDxScrollBarBar --------------------------}

constructor TDxScrollBarBar.Create(AOwner: TComponent; nTmpList: TStrings);
begin
  inherited Create(AOwner);
  Selected := False;
  dify := 0;
  ModPos := 0;
  TmpList := nTmpList;
  hAuteur := Height;
  TotH := DParent.Height;
  StartPosY := Top;
  AJust_H;
end;

procedure TDxScrollBarBar.AJust_H;
var
  tmph                      : Single;
begin
  tmph := TmpList.count * Font.Height;
  if ((tmph > TotH) and (hAuteur <> 0) and (tmph <> 0) and (TotH <> 0)) then begin
    Height := Trunc(hAuteur / (tmph / TotH));
  end else
    Height := hAuteur;
  if (Height < Width) then
    Height := Width;
end;

function TDxScrollBarBar.GetPos: Integer;
begin
  Result := ModPos;
end;

procedure TDxScrollBarBar.DirectPaint(dsurface: TDirectDrawSurface);
begin
  AJust_H;
  with dsurface.Canvas do begin
    Brush.Style := bsSolid;
    if Selected then
      Brush.Color := clGray
    else
      Brush.Color := clLtGray;
    Rectangle(SurfaceX(Left), SurfaceY(StartPosY), SurfaceX(Left + Width), SurfaceY(StartPosY + hAuteur));
    if Selected then
      Brush.Color := clLtGray
    else
      Brush.Color := clGray;
    RoundRect(SurfaceX(Left + 1), SurfaceY(Top + 1), SurfaceX(Left + Width - 1), SurfaceY(Top + Height - 1), Width div 2, Width div 2);
    Release;
  end;
  //inherited DirectPaint(dsurface);
end;

function TDxScrollBarBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited MouseDown(Button, Shift, X, Y);
  if ret then begin
    Selected := True;
    dify := Top - SurfaceY(Y);
    ret := True;
  end;
  Result := ret;
end;

function TDxScrollBarBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if (Selected) then
  begin
    MoveBar(SurfaceY(Y) + dify);
    Selected := False;
    ret := True;
  end;
  Result := ret;
end;

function TDxScrollBarBar.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited MouseMove(Shift, X, Y);
  if ret then begin //InRange
    if Selected then begin
      MoveBar(SurfaceY(Y) + dify);
      ret := True;
    end;
  end;
  Result := ret;
end;

procedure TDxScrollBarBar.MoveBar(nposy: Integer);
var
  tmph                      : Integer;
begin
  Top := nposy;
  if Top < StartPosY then
    Top := StartPosY;
  if Top > hAuteur - Height + StartPosY then
    Top := hAuteur - Height + StartPosY;
  if ((hAuteur - Height) = 0) then
    ModPos := 0
  else begin
    tmph := TmpList.count * Font.Height;
    ModPos := (Top - StartPosY) * (TotH - tmph) div (hAuteur - Height);
  end;
end;

procedure TDxScrollBarBar.MoveModPos(nMove: Integer);
begin
  ModPos := (ModPos + nMove) div Font.Height * Font.Height;
  if ((TotH - (TmpList.count * Font.Height)) = 0) then
    Top := 0
  else
    Top := StartPosY + ModPos * (hAuteur - Height) div (TotH - (TmpList.count * Font.Height));
  if Top < StartPosY then
    MoveBar(StartPosY);
  if Top > hAuteur - Height + StartPosY then
    MoveBar(hAuteur - Height + StartPosY);
end;

{------------------------- TDxScrollBarUp --------------------------}

function TDxScrollBarUp.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited MouseDown(Button, Shift, X, Y);
  if ret {and (check_click_in(X, Y)))} then begin
    Selected := True;
    ret := True;
  end;
  Result := ret;
end;

function TDxScrollBarUp.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if Selected then begin
    Selected := False;
    //if ((not ret) and (check_click_in(X, Y))) then
    //  ret := True;
  end;
  Result := ret;
end;

procedure TDxScrollBarUp.DirectPaint(dsurface: TDirectDrawSurface);
const
  DECAL                     = 3;
begin
  with dsurface.Canvas do begin
    Brush.Style := bsSolid;
    if Selected then
      Brush.Color := clGray
    else
      Brush.Color := clLtGray;
    Rectangle(Left, Top + 1, Left + Width, Top + Width + 1);
    if Selected then
      Brush.Color := clLtGray
    else
      Brush.Color := clGray;
    Polygon([Point(Left + DECAL, Top + 1 + Width - DECAL),
      Point(Left + Width - 10, Top + 1 + DECAL),
        Point(Left + Width - DECAL, Top + 1 + Width - DECAL)]);
    Release;
  end;
  //inherited DirectPaint(dsurface);
end;

{------------------------- TDxScrollBarDown --------------------------}

procedure TDxScrollBarDown.DirectPaint(dsurface: TDirectDrawSurface);
const
  DECAL                     = 3;
begin
  with dsurface.Canvas do
  begin
    Brush.Style := bsSolid;
    if (Selected) then
      Brush.Color := clGray
    else
      Brush.Color := clLtGray;
    Rectangle(Left, Top + 1, Left + Width, Top + Width + 1);
    if (Selected) then
      Brush.Color := clLtGray
    else
      Brush.Color := clGray;
    Polygon([Point(Left + DECAL, Top + 1 + DECAL),
      Point(Left + Width - 10, Top + 1 + Width - DECAL),
        Point(Left + Width - DECAL, Top + 1 + DECAL)]);
    Release;
  end;
  //inherited show(x1,y1,x2,y2,dxdraw);
end;

{------------------------- TDxScrollBar --------------------------}

constructor TDxScrollBar.Create(AOwner: TComponent; nTmpList: TStrings);
begin
  inherited Create(AOwner);
  Bar := TDxScrollBarBar.Create(AOwner, nTmpList);
  BUp := TDxScrollBarUp.Create(AOwner);
  BDown := TDxScrollBarDown.Create(AOwner);
  TotH := DParent.Height - 2;
  AddChild(Bar);
  AddChild(BUp);
  AddChild(BDown);
end;

function TDxScrollBar.GetPos: Integer; //retourne la position du debut
begin
  Result := Bar.GetPos;
end;

function TDxScrollBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := BUp.MouseUp(Button, Shift, X - Left, Y - Top);
  if ret then
    MoveModPos(Font.Height);
  if not ret then begin
    ret := BDown.MouseUp(Button, Shift, X - Left, Y - Top);
    if ret then
      MoveModPos(-Font.Height);
  end;
  if not ret then
    ret := Bar.MouseUp(Button, Shift, X - Left, Y - Top);
  //ret := inherited MouseUp(Button, Shift, X, Y);
  if ret then begin
    if Y > Bar.Top then
      MoveModPos(-TotH)
    else
      MoveModPos(TotH);
    ret := True;
  end;
  Result := ret;
end;

procedure TDxScrollBar.MoveModPos(nMove: Integer);
begin
  Bar.MoveModPos(nMove);
end;
{------------------------- TDxCustomListBox --------------------------}

constructor TDxCustomListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSelected := -1;
  FItems := TStringList.Create;
  FBackColor := clWhite;
  FSelectionColor := clSilver;
  OnChangeSelect := ChangeSelect;
  ParentComboBox := nil;
  FParentComboBox := nil;
  //DxScroll := TDxScrollBar.Create(w - 20, 0, 20, h - 2, Self, FItems, Font, h - 2);
  //add_fenetre(DxScroll);
end;

destructor TDxCustomListBox.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TDxCustomListBox.GetItemSelected: Integer;
begin
  if (FSelected > FItems.count - 1) or (FSelected < 0) then
    Result := -1
  else
    Result := FSelected;
  OnChangeSelect(FSelected);
end;

procedure TDxCustomListBox.SetItemSelected(Value: Integer);
begin
  if (Value > FItems.count - 1) or (Value < 0) then
    FSelected := -1
  else
    FSelected := Value;
  OnChangeSelect(FSelected);
end;

procedure TDxCustomListBox.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then begin
    FBackColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDxCustomListBox.SetSelectionColor(Value: TColor);
begin
  if FSelectionColor <> Value then begin
    FSelectionColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

function TDxCustomListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
end;

function TDxCustomListBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  TmpSel                    : Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if FEnabled and not Background then begin
    TmpSel := FSelected;
    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := ({DxScroll.GetPos * -1}-Top + SurfaceY(Y)) div (-Font.Height + LineSpace);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
  end;
end;

function TDxCustomListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
  TmpSel                    : Integer;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if ret then begin
    TmpSel := FSelected;
    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := ({DxScroll.GetPos * -1}-Top + SurfaceY(Y)) div (-Font.Height + LineSpace);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
    if TmpSel <> FSelected then
      OnChangeSelect(FSelected);
    if FSelected <> -1 then begin
      if ParentComboBox <> nil then
        ParentComboBox.Caption := FItems[FSelected];
      if Integer(FItems.Objects[FSelected]) > 0 then
        ParentComboBox.Tag := Integer(FItems.Objects[FSelected]);
    end;
    //MessageBox(0, PChar(FItems[FSelected]), 's', mb_ok);
    //FSelected := -1;
    Visible := False;
    ret := True;
  end;
  Result := ret;
end;

function TDxCustomListBox.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited KeyDown(Key, Shift);
  if ret then begin
    case Key of
      VK_PRIOR: begin
          ItemSelected := ItemSelected - Height div -Font.Height;
          if (ItemSelected = -1) then ItemSelected := 0;
        end;
      VK_NEXT: begin
          ItemSelected := ItemSelected + Height div -Font.Height;
          if ItemSelected = -1 then ItemSelected := FItems.count - 1;
        end;
      VK_UP: if ItemSelected - 1 > -1 then
          ItemSelected := ItemSelected - 1;
      VK_DOWN: if ItemSelected + 1 < FItems.count then
          ItemSelected := ItemSelected + 1;
    end;
    {case Key of
      VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN: if (ItemSelected <> -1) then begin
          while (((-DxScroll.GetPos + Height) div -Font.Height) <= ItemSelected) do
            DxScroll.MoveModPos(Font.Height);
          while (((-DxScroll.GetPos) div -Font.Height) > ItemSelected) do
            DxScroll.MoveModPos(-Font.Height);
        end;
    end;}
  end;
  Result := ret;
end;

procedure TDxCustomListBox.ChangeSelect(ChangeSelect: Integer);
begin
  //
end;

procedure TDxCustomListBox.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TDxCustomListBox.DirectPaint(dsurface: TDirectDrawSurface);
var
  fy, ny, {dify,} i, oSize  : Integer;
  OldColor                  : TColor;
begin
  with dsurface.Canvas do begin
    //dify := DxScroll.GetPos;
    OldColor := Font.Color;
    oSize := Font.Size;
    Font.Color := clblack;
    Font.Size := self.Font.Size;

    Brush.Style := bsSolid;
    Brush.Color := BackColor;
    Rectangle(Left, Top, Left + Width, Top + Height);
    Brush.Color := SelectionColor;
    if FSelected <> -1 then begin
      ny := Top + (-Font.Height + LineSpace) * FSelected {+ dify};
      fy := ny + (-Font.Height + LineSpace);
      if (ny < Top + Height - 1) and (fy > Top + 1) then begin
        if (fy > Top + Height - 1) then fy := Top + Height - 1;
        if (ny < Top + 1) then ny := Top + 1;
        FillRect(Rect(Left + 1, ny, Left + Width - 1, fy));
      end;
    end;
    //SetBkMode(Handle, Windows.Transparent);
    Brush.Style := bsclear;
    for i := 0 to FItems.count - 1 do
      TextOut(Left + 2, 2 + Top + (-Font.Height + LineSpace) * i {+ dify}, FItems.Strings[i]);
      //TextRect(Rect(Left, Top + 1, Left + Width, Top + Height - 1), Left + 2, 2 + Top + (-Font.Height + LineSpace) * i {+ dify}, FItems.Strings[i]);
    Font.Color := OldColor;
    Font.Size := oSize;
    Release;
  end;
  //inherited DirectPaint(dsurface);
end;

{-------------------------TDxHint--------------------------}

constructor TDxHint.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FSelected := -1;
  FItems := TStringList.Create;
  FBackColor := clWhite;
  FSelectionColor := clSilver;
  FOnChangeSelect := nil;
  FOnMouseMoveSelect := nil;
  FParentControl := nil;
end;

destructor TDxHint.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TDxHint.GetItemSelected: Integer;
begin
  if (FSelected > FItems.count - 1) or (FSelected < 0) then
    Result := -1
  else
    Result := FSelected;
end;

procedure TDxHint.SetItemSelected(Value: Integer);
begin
  if (Value > FItems.count - 1) or (Value < 0) then
    FSelected := -1
  else
    FSelected := Value;
end;

procedure TDxHint.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then begin
    FBackColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDxHint.SetSelectionColor(Value: TColor);
begin
  if FSelectionColor <> Value then begin
    FSelectionColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

function TDxHint.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
end;

function TDxHint.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  TmpSel                    : Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if FEnabled and not Background then begin

    TmpSel := FSelected;
    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y) div (-Font.Height + LineSpace2);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
    if Assigned(FOnMouseMoveSelect) then
      FOnMouseMoveSelect(self, Shift, X, Y);
  end;
end;

function TDxHint.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
  TmpSel                    : Integer;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if ret then begin
    TmpSel := FSelected;

    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y) div (-Font.Height + LineSpace2);

    if FSelected > FItems.count - 1 then
      FSelected := -1;

    if FSelected <> -1 then begin
      if FParentControl <> nil then
        FParentControl.Caption := FItems[FSelected];
      if Integer(FItems.Objects[FSelected]) > 0 then
        FParentControl.tag := Integer(FItems.Objects[FSelected]);
    end;

    if Assigned(FOnChangeSelect) then
      FOnChangeSelect(self, Button, Shift, X, Y);
    Visible := False;
    ret := True;
  end;
  Result := ret;
end;

function TDxHint.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited KeyDown(Key, Shift);
  if ret then begin
    case Key of
      VK_PRIOR: begin
          ItemSelected := ItemSelected - Height div -Font.Height;
          if (ItemSelected = -1) then ItemSelected := 0;
        end;
      VK_NEXT: begin
          ItemSelected := ItemSelected + Height div -Font.Height;
          if ItemSelected = -1 then ItemSelected := FItems.count - 1;
        end;
      VK_UP: if ItemSelected - 1 > -1 then
          ItemSelected := ItemSelected - 1;
      VK_DOWN: if ItemSelected + 1 < FItems.count then
          ItemSelected := ItemSelected + 1;
    end;
  end;
  Result := ret;
end;

procedure TDxHint.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TDxHint.DirectPaint(dsurface: TDirectDrawSurface);
var
  fy, nY, L, T, i, oSize    : Integer;
  OldColor                  : TColor;
begin

  if Assigned(FOnDirectPaint) then begin
    FOnDirectPaint(self, dsurface);
    Exit;
  end;

  //L := SurfaceX(Left);
  //T := SurfaceY(Top);
  L := (Left);
  T := (Top);
  with dsurface.Canvas do begin
    try
      OldColor := Font.Color;
      oSize := Font.Size;
      Font.Color := clBlack;
      Font.Size := self.Font.Size;
      Brush.Style := bsSolid;
      Brush.Color := BackColor;
      Rectangle(L, T, L + Width, T + Height);
      Brush.Color := SelectionColor;
      if FSelected <> -1 then begin
        nY := T + (-Font.Height + LineSpace2) * FSelected;
        fy := nY + (-Font.Height + LineSpace2);
        if (nY < T + Height - 1) and (fy > T + 1) then begin
          if (fy > T + Height - 1) then fy := T + Height - 1;
          if (nY < T + 1) then nY := T + 1;
          FillRect(Rect(L + 1, nY, L + Width - 1, fy));
        end;
      end;
      Brush.Style := bsClear;
      for i := 0 to FItems.count - 1 do begin
        TextOut(L + LineSpace2, LineSpace2 + T + (-Font.Height + LineSpace2) * i, FItems.Strings[i]);
      end;
      Font.Color := OldColor;
      Font.Size := oSize;
    finally
      Release;
    end;
  end;
end;

{------------------------- TDGrid --------------------------}

constructor TDGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColCount := 8;
  FRowCount := 5;
  FColWidth := 36;
  FRowHeight := 32;
  FOnGridSelect := nil;
  FOnGridMouseMove := nil;
  FOnGridPaint := nil;
end;

function TDGrid.GetColRow(X, Y: Integer; var ACol, ARow: Integer): Boolean;
begin
  Result := False;
  if InRange(X, Y) then begin
    ACol := (X - Left) div FColWidth;
    ARow := (Y - Top) div FRowHeight;
    Result := True;
  end;
end;

function TDGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow                : Integer;
begin
  Result := False;
  if mbLeft = Button then begin
    if GetColRow(X, Y, ACol, ARow) then begin
      SelectCell.X := ACol;
      SelectCell.Y := ARow;
      DownPos.X := X;
      DownPos.Y := Y;
      SetDCapture(self);
      Result := True;
    end;
  end;
end;

function TDGrid.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow                : Integer;
begin
  Result := False;
  if InRange(X, Y) then begin
    if GetColRow(X, Y, ACol, ARow) then begin
      if Assigned(FOnGridMouseMove) then
        FOnGridMouseMove(self, ACol, ARow, Shift);
    end;
    Result := True;
  end;
end;

function TDGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow                : Integer;
begin
  Result := False;
  if mbLeft = Button then begin
    if GetColRow(X, Y, ACol, ARow) then begin
      if (SelectCell.X = ACol) and (SelectCell.Y = ARow) then begin
        Col := ACol;
        Row := ARow;
        if Assigned(FOnGridSelect) then
          FOnGridSelect(self, ACol, ARow, Shift);
      end;
      Result := True;
    end;
    ReleaseDCapture;
  end;
end;

function TDGrid.Click(X, Y: Integer): Boolean;
var
  ACol, ARow                : Integer;
begin
  Result := False;
  {if GetColRow(X, Y, ACol, ARow) then begin
    if Assigned(FOnGridSelect) then
      FOnGridSelect(Self, ACol, ARow, []);
    Result := True;
  end;}
end;

procedure TDGrid.DirectPaint(dsurface: TDirectDrawSurface);
var
  i, j                      : Integer;
  rc                        : TRect;
begin
  if Assigned(FOnGridPaint) then
    for i := 0 to FRowCount - 1 do
      for j := 0 to FColCount - 1 do begin
        rc := Rect(Left + j * FColWidth, Top + i * FRowHeight, Left + j * (FColWidth + 1) - 1, Top + i * (FRowHeight + 1) - 1);
        if (SelectCell.Y = i) and (SelectCell.X = j) then
          FOnGridPaint(self, j, i, rc, [gdSelected], dsurface)
        else
          FOnGridPaint(self, j, i, rc, [], dsurface);
      end;
end;

{--------------------- TDWindown --------------------------}

constructor TDWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFloating := False;
  FEnableFocus := True;
  Width := 120;
  Height := 120;
end;

procedure TDWindow.SetVisible(flag: Boolean);
begin
  FVisible := flag;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
end;

function TDWindow.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  al, at                    : Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FFloating and (MouseCaptureControl = self) then begin
    if (SpotX <> X) or (SpotY <> Y) then begin
      al := Left + (X - SpotX);
      at := Top + (Y - SpotY);
      if al + Width < WINLEFT then al := WINLEFT - Width;
      if al > WINRIGHT then al := WINRIGHT;
      if at + Height < WINTOP then at := WINTOP - Height;
      if at + Height > BOTTOMEDGE then at := BOTTOMEDGE - Height;
      Left := al;
      Top := at;
      SpotX := X;
      SpotY := Y;
    end;
  end;
end;

function TDWindow.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    if Floating then begin
      if DParent <> nil then
        DParent.ChangeChildOrder(self);
    end;
    SpotX := X;
    SpotY := Y;
  end;
end;

function TDWindow.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
end;

procedure TDWindow.show;
begin
  Visible := True;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
  if EnableFocus then SetDFocus(self);
end;

function TDWindow.ShowModal: Integer;
begin
  Result := 0; //Jacky
  Visible := True;
  ModalDWindow := self;
  if EnableFocus then SetDFocus(self);
end;

{--------------------- TDWinManager --------------------------}

constructor TDWinManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DWinList := TList.Create;
  MouseCaptureControl := nil;
  FocusedControl := nil;
end;

destructor TDWinManager.Destroy;
begin
  inherited Destroy;
end;

procedure TDWinManager.ClearAll;
begin
  DWinList.Clear;
end;

procedure TDWinManager.AddDControl(dcon: TDControl; Visible: Boolean);
begin
  dcon.Visible := Visible;
  DWinList.Add(dcon);
end;

procedure TDWinManager.DelDControl(dcon: TDControl);
var
  i                         : Integer;
begin
  for i := 0 to DWinList.count - 1 do
    if DWinList[i] = dcon then begin
      DWinList.Delete(i);
      Break;
    end;
end;

function TDWinManager.KeyPress(var Key: Char): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := KeyPress(Key);
      Exit;
    end else
      ModalDWindow := nil;
    Key := #0;
  end;

  if FocusedControl <> nil then begin
    if FocusedControl.Visible then begin
      Result := FocusedControl.KeyPress(Key);
    end else
      ReleaseDFocus;
  end;
end;

function TDWinManager.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := KeyDown(Key, Shift);
      Exit;
    end else
      ModalDWindow := nil;
  end;
  if FocusedControl <> nil then begin
    if FocusedControl.Visible then
      Result := FocusedControl.KeyDown(Key, Shift)
    else
      ReleaseDFocus;
  end;
end;

function TDWinManager.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseMove(Shift, LocalX(X), LocalY(Y));
      Result := True;
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseMove(Shift, LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseMove(Shift, X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function TDWinManager.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseDown(Button, Shift, LocalX(X), LocalY(Y));
      Result := True;
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseDown(Button, Shift, LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseDown(Button, Shift, X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function TDWinManager.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := True;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseUp(Button, Shift, X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function TDWinManager.DblClick(X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := True;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := DblClick(LocalX(X), LocalY(Y));
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := DblClick(LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).DblClick(X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function TDWinManager.Click(X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := True;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := Click(LocalX(X), LocalY(Y));
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := Click(LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).Click(X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

procedure TDWinManager.DirectPaint(dsurface: TDirectDrawSurface);
var
  i                         : Integer;
begin
  //
  for i := 0 to DWinList.count - 1 do begin
    if TDControl(DWinList[i]).Visible then
      TDControl(DWinList[i]).DirectPaint(dsurface);
  end;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then
      with ModalDWindow do
        DirectPaint(dsurface);
  end;
end;

{--------------------- TDmoveButton --------------------------}

constructor TDMoveButton.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FFloating := True;
  FEnableFocus := False;
  Width := 30;
  Height := 30;
  MoveHeight := 0;
end;

procedure TDMoveButton.SetVisible(flag: Boolean);
begin
  FVisible := flag;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(Self);
  end;
end;

function TDMoveButton.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  al, at, ot, tt            : Integer;
begin
  if ssLeft in Shift then begin
    if listcont <= 0 then Exit;
    Result := inherited MouseMove(Shift, X, Y);
    if Result and FFloating and (MouseCaptureControl = Self) then begin
      if listcont <= 0 then Exit;
      if (SpotX <> X) or (SpotY <> Y) then begin

        if not Reverse then begin
          ot := Boxmovetop - Height;
          tt := Round(ot / listcont);
          MoveHeight := tt;
          al := RLeft;
          at := Top + (Y - SpotY);
          if at < RTop then at := RTop;
          if at + Height > RTop + Boxmovetop then at := RTop + Boxmovetop - Height;
          outidx := (at - RTop) div tt;
          Left := al;
          Top := at;
          SpotX := X;
          SpotY := Y;
        end else begin
          //ot := Boxmovetop;
          tt := Round(Boxmovetop / listcont);
          MoveHeight := tt;
          al := RLeft;
          at := Top + (Y - SpotY);
          if at < RTop - Boxmovetop then at := RTop - Boxmovetop;
          if at > RTop then at := RTop;
          outidx := (at - RTop) div tt;
          Left := al;
          Top := at;
          SpotX := X;
          SpotY := Y;
        end;
      end;
    end;
  end;
end;

function TDMoveButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    if Floating then begin
      if DParent <> nil then
        DParent.ChangeChildOrder(Self);
    end;
    SpotX := X;
    SpotY := Y;
  end;
end;

function TDMoveButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
end;

procedure TDMoveButton.Show;
begin
  Visible := True;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(Self);
  end;
  if EnableFocus then SetDFocus(Self);
end;

function TDMoveButton.ShowModal: Integer;
begin
  Result := 0;
  Visible := True;
  ModalDWindow := Self;
  if EnableFocus then SetDFocus(Self);
end;

procedure TDMoveButton.exitHeightout;
var
  ot, tt                    : Integer;
begin
  if listcont <= 0 then Exit;
  if not Reverse then begin
    ot := Boxmovetop - Height;
    tt := Round(ot / listcont);
    MoveHeight := tt;
    Top := Top + MoveHeight;
    if Top > RTop + Boxmovetop - Height then Top := RTop + Boxmovetop - Height;
  end else begin
    //ot := Boxmovetop- Height;
    tt := Round(Boxmovetop / listcont);
    MoveHeight := tt;
    Top := Top + MoveHeight;
    if Top > RTop then Top := RTop;
  end;

end;

procedure TDMoveButton.UpHeightout;
var
  ot, tt                    : Integer;
begin
  if listcont <= 0 then Exit;
  if not Reverse then begin
    ot := Boxmovetop - Height;
    tt := Round(ot / listcont);
    MoveHeight := tt;
    Top := Top - MoveHeight;
    if Top < RTop then Top := RTop;
  end else begin
    //ot := Boxmovetop- Height;
    tt := Round(Boxmovetop / listcont);
    MoveHeight := tt;
    Top := Top - MoveHeight;
    // if Top < RTop then Top := RTop;
    if Top < RTop - Boxmovetop then Top := RTop - Boxmovetop;
  end;
end;

end.

