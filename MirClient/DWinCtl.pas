unit DWinCtl;

interface

uses
  Windows, Classes, Graphics, SysUtils, Controls, DXDraws, DXClass, StdCtrls, Messages,
  Forms, DirectX, DIB, Grids, wmUtil, HUtil32, WIL, cliUtil;

const
  LineSpace = 2;

  LineSpace2 = 8;

  DECALW = 6;
  DECALH = 4;

type
  TDBtnState = (tnor, tdown, tmove, tdisable);
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
  //TMouseWheelEvent = procedure(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean) of object;
  TOnTextChanged = procedure(Sender: TObject; sText: string) of object;

  TDControl = class(TCustomControl)
  private
    bMouseMove: Boolean;
    FIsManager: Boolean;
    FPageActive: Boolean;
    FDisableTransparent: Boolean;
    FCaption: string;
    FDParent: TDControl;
    FEnableFocus: Boolean;
    FOnDirectPaint: TOnDirectPaint;
    FOnDirectPaint2: TOnDirectPaint;
    FOnKeyPress: TOnKeyPress;
    FOnKeyDown: TOnKeyDown;
    FOnMouseMove: TOnMouseMove;
    FOnMouseDown: TOnMouseDown;
    FOnMouseUp: TOnMouseUp;

    FOnMouseEnter: TOnClick;
    FOnMouseLeave: TOnClick;
    FOnRightMouseDown: TOnMouseDown;

    FOnDblClick: TNotifyEvent;
    FOnClick: TOnClickEx;
    FOnInRealArea: TOnInRealArea;
    FOnBackgroundClick: TOnClick;

    FIsMouseEnter: Boolean;

    //FOnMouseWheel: TMouseWheelEvent;
    procedure SetCaption(Str: string);
    //procedure CMMouseWheel(var Message: TCMMouseWheel); message CM_MOUSEWHEEL;
  protected
    FVisible: Boolean;
  public
    ReloadTex: Boolean;
    ImageSurface: TDirectDrawSurface;
    Background: Boolean;
    DControls: TList;
    WLib: TWMImages;
    ULib: TUIBImages;
    FaceIndex: Integer;
    FaceName: string;

    FRightClick: Boolean;
    WantReturn: Boolean;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Loaded; override;
    function SurfaceX(X: Integer): Integer;
    function SurfaceY(Y: Integer): Integer;
    function LocalX(X: Integer): Integer;
    function LocalY(Y: Integer): Integer;
    procedure AddChild(dcon: TDControl);
    procedure ChangeChildOrder(dcon: TDControl);
    function InRange(X, Y: Integer; Shift: TShiftState): Boolean;
    function KeyPress(var Key: Char): Boolean; virtual;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; virtual;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; virtual;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; virtual;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; virtual;
    function DblClick(X, Y: Integer): Boolean; virtual;
    function Click(X, Y: Integer): Boolean; virtual;
    function CanFocusMsg: Boolean;
    procedure AdjustPos(X, Y: Integer); overload;
    procedure AdjustPos(X, Y, W, H: Integer); overload;
    procedure SetImgIndex(Lib: TWMImages; Index: Integer); overload;
    procedure SetImgIndex(Lib: TWMImages; Index, X, Y: Integer); overload;

    procedure SetImgName(Lib: TUIBImages; F: string);
    procedure DirectPaint(dsurface: TDirectDrawSurface); virtual;
    //function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; virtual;
    property PageActive: Boolean read FPageActive write FPageActive;
  published
    property OnDirectPaint: TOnDirectPaint read FOnDirectPaint write FOnDirectPaint;
    property OnDirectPaint2: TOnDirectPaint read FOnDirectPaint2 write FOnDirectPaint2;
    property OnKeyPress: TOnKeyPress read FOnKeyPress write FOnKeyPress;
    property OnKeyDown: TOnKeyDown read FOnKeyDown write FOnKeyDown;
    property OnMouseMove: TOnMouseMove read FOnMouseMove write FOnMouseMove;
    property OnMouseDown: TOnMouseDown read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TOnMouseUp read FOnMouseUp write FOnMouseUp;

    //   放开MouseMove  Leave和enter事件   2019-12-21
    property OnMouseEnter: TOnClick read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TOnClick read FOnMouseLeave write FOnMouseLeave;
    Property OnRightMouseDown: TOnMouseDown read FOnRightMouseDown write FOnRightMouseDown;

    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnInRealArea: TOnInRealArea read FOnInRealArea write FOnInRealArea;
    property OnBackgroundClick: TOnClick read FOnBackgroundClick write FOnBackgroundClick;
    //property OnMouseWheel: TMouseWheelEvent read FOnMouseWheel write FOnMouseWheel;
    property DisableTransparent: Boolean read FDisableTransparent write FDisableTransparent;

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
    FFloating: Boolean;
    CaptionEx: string;
    btnState: TDBtnState;
    Downed: Boolean;
    Arrived: Boolean;
    SpotX, SpotY: Integer;
    Clicked: Boolean;
    ClickInv: LongWord;
    constructor Create(aowner: TComponent); override;
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
    FArrived: Boolean;
    FChecked: Boolean;
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
  public
    Downed: Boolean;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    property Checked: Boolean read FChecked write FChecked;
    property Arrived: Boolean read FArrived write FArrived;
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
    FFrameSize: byte;
    FFrameColor: TColor;
    FFrameHotColor: TColor;
    procedure SetTransparent(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetFrameVisible(Value: Boolean);
    procedure SetFrameHot(Value: Boolean);
    procedure SetFrameSize(Value: byte);
    procedure SetFrameColor(Value: TColor);
    procedure SetFrameHotColor(Value: TColor);
  protected
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Transparent: Boolean read FTransparent write SetTransparent default True;
    property FrameVisible: Boolean read FFrameVisible write SetFrameVisible default True;
    property FrameHot: Boolean read FFrameHot write SetFrameHot default False;
    property FrameSize: byte read FFrameSize write SetFrameSize default 1;
    property FrameColor: TColor read FFrameColor write SetFrameColor default $00406F77;
    property FrameHotColor: TColor read FFrameHotColor write SetFrameHotColor default $00599AA8;
  public
    Downed: Boolean;
    //OnEnterKey: procedure of object;
    //OntTabKey: procedure of object;
    procedure OnDefaultEnterKey;
    procedure OnDefaultTabKey;
    constructor Create(aowner: TComponent); override;
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
    constructor Create(aowner: TComponent; nTmpList: TStrings);
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
    constructor Create(aowner: TComponent; nTmpList: TStrings);
  end;

  TDComboBox = class;
  TDxCustomListBox = class(TDCustomControl)
  private
    FItems: TStrings;
    FBackColor: TColor;
    FSelectionColor: TColor;
    FParentComboBox: TDComboBox;
    function GetItemSelected: Integer;
    procedure SetItems(Value: TStrings);
    procedure SetBackColor(Value: TColor);
    procedure SetSelectionColor(Value: TColor);
    procedure SetItemSelected(Value: Integer);
  public
    ChangingHero: Boolean;
    FSelected: Integer;
    FOnChangeSelect: procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
    FOnMouseMoveSelect: procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
    property Items: TStrings read FItems write SetItems;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clSilver;
    property ItemSelected: Integer read GetItemSelected write SetItemSelected;
    property ParentComboBox: TDComboBox read FParentComboBox write FParentComboBox;

    //procedure ChangeSelect(ChangeSelect: Integer);
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    constructor Create(aowner: TComponent); override;
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
    FSelClickStart: Boolean;
    FSelClickEnd: Boolean;
    FCurPos: Integer;
    FClickX: Integer;
    FSelStart: Integer;
    FSelEnd: Integer;
    FStartTextX: Integer;

    FSelTextStart: Integer;
    FSelTextEnd: Integer;

    FMaxLength: Integer;
    FShowCaretTick: LongWord;
    FShowCaret: Boolean;
    FNomberOnly: Boolean;
    FSecondChineseChar: Boolean;
    FPasswordChar: Char;
    FOnTextChanged: TOnTextChanged;

    FOnFoucused: TNotifyEvent;
    FOnEntered: TNotifyEvent;

    procedure SetSelStart(Value: Integer);
    procedure SetSelEnd(Value: Integer);
    procedure SetMaxLength(Value: Integer);
    procedure SetPasswordChar(Value: Char);
    procedure SetNomberOnly(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure SetIsHotKey(Value: Boolean);
    procedure SetHotKey(Value: Cardinal);
    procedure SetAtom(Value: Word);
    procedure SetSelLength(Value: Integer);
    function ReadSelLength(): Integer;
  protected
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property NomberOnly: Boolean read FNomberOnly write SetNomberOnly default False;
    property IsHotKey: Boolean read FIsHotKey write SetIsHotKey default False;
    property Atom: Word read FAtom write SetAtom default 0;
    property HotKey: Cardinal read FHotKey write SetHotKey default 0;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property PasswordChar: Char read FPasswordChar write SetPasswordChar default #0;

    procedure DoFoucused; virtual;
    procedure DoEntered; virtual;
  public
    DxHint: TDxHint;
    m_InputHint: string;
    FMiniCaret: byte;
    FCaretColor: TColor;
    procedure ShowCaret();
    procedure SetFocus(); override;
    procedure ChangeCurPos(nPos: Integer; boLast: Boolean = False);
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    function KeyPress(var Key: Char): Boolean; override;
    function KeyPressEx(var Key: Char): Boolean;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    function SetOfHotKey(HotKey: Cardinal): Word;
    property Text: string read FCaption write SetCaption;
    property SelStart: Integer read FSelStart write SetSelStart;
    property SelEnd: Integer read FSelEnd write SetSelEnd;
    property SelLength: Integer read ReadSelLength write SetSelLength;
    property OnTextChanged: TOnTextChanged read FOnTextChanged write FOnTextChanged;
    property OnFoucused: TNotifyEvent read FOnFoucused write FOnFoucused;
    property OnEntered: TNotifyEvent read FOnEntered write FOnEntered;
    ///
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
    property OnFoucused;
    property OnEntered;
  end;

  TDComboBox = class(TDxCustomEdit)
  private
    FDropDownList: TDListBox;
  protected
    //
  public
    constructor Create(aowner: TComponent); override;
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
    tButton: TMouseButton;
    cx, cy: Integer;
    Col, Row: Integer;
    constructor Create(aowner: TComponent); override;
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
  protected
    procedure SetVisible(flag: Boolean);
  public
    //FloatingEx: Boolean;
    FMoveRange: Boolean;
    SpotX, SpotY: Integer;
    DialogResult: TModalResult;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Show;
    function ShowModal: Integer;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Floating: Boolean read FFloating write FFloating;
  end;

  TDWinManager = class({TDControl} TComponent)
  private
  public
    DWinList: TList;
    constructor Create(aowner: TComponent); override;
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
    DialogResult: TModalResult;
    FOnClick: TOnClickEx;
    SlotLen: Integer;
    RLeft: Integer;
    RTop: Integer;
    Position: Integer;
    outHeight: Integer;
    Max: Integer;
    Reverse: Boolean;
    LeftToRight: Boolean;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Show;
    function ShowModal: Integer;
    procedure UpdatePos(pos: Integer; force: Boolean = False);
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Floating: Boolean read FFloating write FFloating;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property FBoxMoveTop: Integer read SlotLen write SlotLen;
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
  MouseCaptureControl: TDControl; //mouse message
  FocusedControl: TDControl; //Key message
  LastMenuControl: TDxEdit = nil;
  MainWinHandle: Integer;
  ModalDWindow: TDControl;
  g_MainHWnd: HWnd;

implementation

uses ClMain, MShare, ClFunc, FState;

procedure Register;
begin
  RegisterComponents('MirGame', [TDWinManager, TDControl, TDButton, TDCheckBox, TDxEdit, TDListBox, TDComboBox, TDGrid, TDWindow, TDMoveButton]);
end;

procedure SetDFocus(dcon: TDControl);
begin
  FocusedControl := dcon;
  if dcon is TDxCustomEdit then
  begin
    with TDxCustomEdit(dcon) do
    begin
      ShowCaret();
      //ChangeCurPos(Length(Caption) - FCurPos);
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

constructor TDControl.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  DParent := nil;
  inherited Visible := False;
  FEnableFocus := False;
  Background := False;
  FIsManager := False;
  bMouseMove := False;
  FOnDirectPaint := nil;
  FOnDirectPaint2 := nil;
  FOnKeyPress := nil;
  FOnKeyDown := nil;
  FOnMouseMove := nil;
  FOnMouseDown := nil;
  FOnMouseUp := nil;
  FOnInRealArea := nil;
  //FOnMouseWheel := nil;
  DControls := TList.Create;
  FDParent := nil;

  Width := 80;
  Height := 24;
  FCaption := '';
  FVisible := True;
  WLib := nil;
  ULib := nil;
  ImageSurface := nil;
  FaceIndex := 0;
  FaceName := '';
  PageActive := False;
  FRightClick := False;
  //FClickTick := GetTickCount;
  ReloadTex := False;

  FDisableTransparent := False;
  FIsMouseEnter := False;
end;

destructor TDControl.Destroy;
begin
  DControls.Free;
  inherited Destroy;
end;

procedure TDControl.SetCaption(Str: string);
begin
  FCaption := Str;
  if FCaption = '' then
  begin
    if self is TDxCustomEdit then
    begin
      TDxCustomEdit(self).SelStart := -1;
      TDxCustomEdit(self).SelEnd := -1;
    end;
  end;
  if csDesigning in ComponentState then
  begin
    Refresh;
  end;
end;

procedure TDControl.AdjustPos(X, Y: Integer);
begin
  Top := Y;
  Left := X;
  //PTop := Top;
end;

procedure TDControl.AdjustPos(X, Y, W, H: Integer);
begin
  Left := X;
  Top := Y;
  Width := W;
  Height := H;
  //PTop := Top;
end;

procedure TDControl.Paint;
begin
  if csDesigning in ComponentState then
  begin
    if self is TDWindow then
    begin
      with Canvas do
      begin
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
    end
    else
    begin
      with Canvas do
      begin
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
  i: Integer;
  dcon: TDControl;
begin
  if not (csDesigning in ComponentState) then
  begin
    if Parent <> nil then
    begin
      for i := 0 to TControl(Parent).ComponentCount - 1 do
      begin
        if TControl(Parent).Components[i] is TDControl then
        begin
          dcon := TDControl(TControl(Parent).Components[i]);
          if dcon.DParent = self then
          begin
            AddChild(dcon);
          end;
        end;
      end;
    end;
  end;
end;

function TDControl.SurfaceX(X: Integer): Integer;
var
  d: TDControl;
begin
  d := self;
  while True do
  begin
    if d.DParent = nil then
      Break;
    X := X + d.DParent.Left;
    d := d.DParent;
  end;
  Result := X;
end;

function TDControl.SurfaceY(Y: Integer): Integer;
var
  d: TDControl;
begin
  d := self;
  while True do
  begin
    if d.DParent = nil then
      Break;
    Y := Y + d.DParent.Top;
    d := d.DParent;
  end;
  Result := Y;
end;

function TDControl.LocalX(X: Integer): Integer;
var
  d: TDControl;
begin
  d := self;
  while True do
  begin
    if d.DParent = nil then
      Break;
    X := X - d.DParent.Left;
    d := d.DParent;
  end;
  Result := X;
end;

function TDControl.LocalY(Y: Integer): Integer;
var
  d: TDControl;
begin
  d := self;
  while True do
  begin
    if d.DParent = nil then
      Break;
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
  i: Integer;
begin
  if not (dcon is TDWindow) then
    Exit;
  if TDWindow(dcon).Floating then
  begin
    for i := 0 to DControls.count - 1 do
    begin
      if dcon = DControls[i] then
      begin
        DControls.Delete(i);
        Break;
      end;
    end;
    DControls.Add(dcon);
  end;
end;

function TDControl.InRange(X, Y: Integer; Shift: TShiftState): Boolean;
var
  boInRange: Boolean;
  d: TDirectDrawSurface;
begin
  if (X >= Left) and (X < (Left + Width)) and (Y >= Top) and (Y < (Top + Height))
    and (((ssRight in Shift) and FRightClick) or not (ssRight in Shift)) then
  begin
    boInRange := True;
    if Assigned(FOnInRealArea) then
      FOnInRealArea(self, X - Left, Y - Top, boInRange)
    else if not FDisableTransparent then
    begin
      if ImageSurface <> nil then
      begin
        if ImageSurface.Pixels[X - Left, Y - Top] <= 0 then
          boInRange := False;
      end
      else if WLib <> nil then
      begin
        d := WLib.Images[FaceIndex];
        if d <> nil then
        begin
          if d.Pixels[X - Left, Y - Top] <= 0 then
            boInRange := False;
        end;
      end
      else if ULib <> nil then
      begin
        d := ULib.Images[FaceName];
        if d <> nil then
        begin
          if d.Pixels[X - Left, Y - Top] <= 0 then
            boInRange := False;
        end;
      end;
    end;
    Result := boInRange;
  end
  else
    Result := False;
end;

function TDControl.KeyPress(var Key: Char): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Background then
    Exit;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).KeyPress(Key) then
      begin
        Result := True;
        Exit;
      end;
  if (FocusedControl = self) then
  begin
    if Assigned(FOnKeyPress) then
      FOnKeyPress(self, Key);
    Result := True;
  end;
end;

function TDControl.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Background then
    Exit;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).KeyDown(Key, Shift) then
      begin
        Result := True;
        Exit;
      end;
  if (FocusedControl = self) then
  begin
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

{procedure TDControl.CMMouseWheel(var Message: TCMMouseWheel);
begin
  with Message do
  begin
    Result := 0;
    if DoMouseWheel(ShiftState, WheelDelta, SmallPointToPoint(Pos)) then
      Message.Result := 1
    else if Parent <> nil then
      with TMessage(Message) do
        Result := Parent.Perform(CM_MOUSEWHEEL, WParam, LParam);
  end;
end;

function TDControl.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
var
  IsNeg                     : Boolean;
  i                         : Integer;
begin
  Result := False;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then begin
      TDControl(DControls[i]).OnMouseWheel(Self, Shift, WheelDelta, MousePos, Result);
      if Result then begin
        Result := True;
        Exit;
      end;
    end;

  if (MouseCaptureControl <> nil) then begin
    if (MouseCaptureControl = Self) then begin
      if Assigned(FOnMouseWheel) then
        FOnMouseWheel(Self, Shift, WheelDelta, MousePos, Result);
      Result := True;
    end;
    Exit;
  end;

  if Background then Exit;
  if InRange(MousePos.X, MousePos.Y, Shift) then begin
    if Assigned(FOnMouseWheel) then
      FOnMouseWheel(Self, Shift, WheelDelta, MousePos, Result);
    Result := True;
  end;

end;}

function TDControl.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
  dc: TDControl;
begin
  Result := False;

  for i := DControls.count - 1 downto 0 do
  begin
    dc := TDControl(DControls[i]);
    if dc.Visible then
    begin
      if (ssRight in Shift) and not dc.FRightClick then
        Continue;
      if dc.MouseMove(Shift, X - Left, Y - Top) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  if (MouseCaptureControl <> nil) then
  begin
    if (MouseCaptureControl = self) then
    begin
      if (ssRight in Shift) and not FRightClick then
        Exit;

      if not bMouseMove and Assigned(FOnMouseMove) then
        FOnMouseMove(self, Shift, X, Y);
      Result := True;
    end;
    Exit;
  end;

  if Background then Exit;

  if InRange(X, Y, Shift) then
  begin
    if not bMouseMove then
    begin
      if not FIsMouseEnter then
      begin
        FIsMouseEnter := True;
        if Assigned(FOnMouseEnter) then
          FOnMouseEnter(Self);
      end;

      if Assigned(FOnMouseMove) then
        FOnMouseMove(self, Shift, X, Y);
    end;

    Result := True;
  end
  else if FIsMouseEnter then
  begin
    FIsMouseEnter := False;
    if Assigned(FOnMouseLeave) then
      FOnMouseLeave(Self);
  end;
end;

function TDControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
  dc: TDControl;
begin
  Result := False;

  if  Button  =  mbRight then
  begin
    if Assigned(FOnRightMouseDown) then
    begin
      FOnRightMouseDown(Self, Button , Shift, X, Y);
      Exit;
    end;
  end;

  for i := DControls.count - 1 downto 0 do
  begin
    dc := TDControl(DControls[i]);
    if dc.Visible then
    begin

      if dc.MouseDown(Button, Shift, X - Left, Y - Top) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;


  if Background then
  begin
    if Assigned(FOnBackgroundClick) then
    begin
      WantReturn := False;
      FOnBackgroundClick(self);
      if WantReturn then
        Result := True;
    end;
    ReleaseDFocus;
    Exit;
  end;

  if CanFocusMsg then
  begin
    if InRange(X, Y, Shift) or (MouseCaptureControl = self) then
    begin
      if (Button = mbRight) and not FRightClick then Exit;

      if Assigned(FOnMouseDown) then
        FOnMouseDown(self, Button, Shift, X, Y);
      if EnableFocus then
      begin
        if (self is TDxHint) and (TDxHint(self).ParentControl <> nil) then
        begin
          SetDFocus(TDxHint(self).ParentControl);
        end
        else
          SetDFocus(self);
      end;
      Result := True;
    end;
  end;
end;

function TDControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
  dc: TDControl;
begin
  Result := False;
  for i := DControls.count - 1 downto 0 do
  begin
    dc := TDControl(DControls[i]);
    if dc.Visible then
    begin
      ///////
      if (dc is TDxHint) then
        dc.Visible := False;
      if (Button = mbRight) and not dc.FRightClick then
        Continue;
      if dc.MouseUp(Button, Shift, X - Left, Y - Top) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  if (MouseCaptureControl <> nil) then
  begin //MouseCapture
    if (MouseCaptureControl = self) then
    begin

      //if (ssRight in Shift) and not FRightClick then Exit;
      if (Button = mbRight) and not FRightClick then
        Exit;

      if Assigned(FOnMouseUp) then
        FOnMouseUp(self, Button, Shift, X, Y);
      Result := True;
    end;
    Exit;
  end;

  if Background then Exit;

  if InRange(X, Y, Shift) then
  begin
    if Assigned(FOnMouseUp) then
      FOnMouseUp(self, Button, Shift, X, Y);
    Result := True;
  end;
end;

function TDControl.DblClick(X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then
  begin //MouseCapture
    if (MouseCaptureControl = self) then
    begin
      if Assigned(FOnDblClick) then
        FOnDblClick(self);
      Result := True;
    end;
    Exit;
  end;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).DblClick(X - Left, Y - Top) then
      begin
        Result := True;
        Exit;
      end;
  if Background then
    Exit;
  if InRange(X, Y, [ssDouble]) then
  begin
    if Assigned(FOnDblClick) then
      FOnDblClick(self);
    Result := True;
  end;
end;

function TDControl.Click(X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then
  begin //MouseCapture
    if (MouseCaptureControl = self) then
    begin
      if Assigned(FOnClick) then
      begin
        FOnClick(self, X, Y);
      end;
      Result := True;
    end;
    Exit;
  end;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).Click(X - Left, Y - Top) then
      begin
        Result := True;
        Exit;
      end;
  if Background then
    Exit;
  if InRange(X, Y, [ssDouble]) then
  begin
    if Assigned(FOnClick) then
    begin
      FOnClick(self, X, Y);
    end;
    Result := True;
  end;
end;

procedure TDControl.SetImgIndex(Lib: TWMImages; Index: Integer);
var
  d: TDirectDrawSurface;
begin
  WLib := Lib;
  FaceIndex := Index;
  if Lib <> nil then
  begin
    d := Lib.Images[FaceIndex];
    if d <> nil then
    begin
      Width := d.Width;
      Height := d.Height;
    end
    else if not Background then //123456
      ReloadTex := True;
  end;
end;

procedure TDControl.SetImgIndex(Lib: TWMImages; Index, X, Y: Integer);
var
  d: TDirectDrawSurface;
begin
  WLib := Lib;
  FaceIndex := Index;
  Self.Left := X;
  Self.Top := Y;
  if Lib <> nil then
  begin
    d := Lib.Images[FaceIndex];
    if d <> nil then
    begin
      Width := d.Width;
      Height := d.Height;
    end
    else if not Background then //123456
      ReloadTex := True;
  end;
end;

procedure TDControl.SetImgName(Lib: TUIBImages; F: string);
var
  d: TDirectDrawSurface;
begin
  try
    ULib := Lib;
    FaceName := F;
    if Lib <> nil then
    begin
      d := Lib.Images[F];
      if d <> nil then
      begin
        Width := d.Width;
        Height := d.Height;
      end
      else if not Background then //123456
        ; //ReloadTex := True;
    end;
  except
    on E: Exception do
    begin
      debugOutStr('TDControl.SetImgName ' + E.Message);
    end;
  end;
end;

procedure TDControl.DirectPaint(dsurface: TDirectDrawSurface);
var
  i: Integer;
  d: TDirectDrawSurface;
begin
  if Assigned(FOnDirectPaint) then
  begin
    FOnDirectPaint(self, dsurface);
    //123456
    if ReloadTex then
    begin
      if (WLib <> nil) and (FaceIndex > 0) then
      begin
        d := WLib.Images[FaceIndex];
        if d <> nil then
        begin
          ReloadTex := False;
          Width := d.Width;
          Height := d.Height;
        end;
      end;
    end;
  end
  else if WLib <> nil then
  begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    if not Background and (WLib <> nil) and (FaceIndex > 0) then
    begin
      SetImgIndex(WLib, FaceIndex);
    end;
  end
  else if ULib <> nil then
  begin
    d := ULib.Images[FaceName];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    if not Background and (ULib <> nil) and (FaceName <> '') then
    begin
      SetImgName(ULib, FaceName);
    end;
  end;
  for i := 0 to DControls.count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
  if Assigned(FOnDirectPaint2) then
    FOnDirectPaint2(self, dsurface);
end;

{--------------------- TDButton --------------------------}

constructor TDButton.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  Downed := False;
  Arrived := False;
  FFloating := False;
  FOnClick := nil;
  CaptionEx := '';
  FEnableFocus := True;
  FClickSound := csNone;
  btnState := tnor;
  ClickInv := 0;
  Clicked := True;
end;

function TDButton.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  al, at: Integer;
begin
  Result := False;
  if btnState = tdisable then
    Exit;
  btnState := tnor;

  Result := inherited MouseMove(Shift, X, Y);
  Arrived := Result;
  if (not Background) and (not Result) then
  begin
    //Result := inherited MouseMove(Shift, X, Y);
    if MouseCaptureControl = self then
      if InRange(X, Y, Shift) then
      begin
        Downed := True;
      end
      else
      begin
        Downed := False;
      end;
  end;

  if Result and FFloating and (MouseCaptureControl = self) then
  begin
    if (SpotX <> X) or (SpotY <> Y) then
    begin
      al := Left + (X - SpotX);
      at := Top + (Y - SpotY);
      Left := al;
      Top := at;
      SpotX := X;
      SpotY := Y;
      DScreen.AddChatBoardString(format(' - %d %d %d', [tag, Left, Top]), clWhite, clRed);
    end;
  end;
end;

function TDButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if btnState = tdisable then Exit;
  if inherited MouseDown(Button, Shift, X, Y) then      
  begin
    if GetTickCount - ClickInv <= 150 then
    begin
      //SetDCapture(self);
      Result := True;
      Exit;
    end;

    if (not Background) and (MouseCaptureControl = nil) then
    begin
      Downed := True;
      SetDCapture(self);
    end;
    Result := True;

    if Result then
    begin
      if Floating then
      begin
        if DParent <> nil then
          DParent.ChangeChildOrder(self);
      end;
      SpotX := X;
      SpotY := Y;
    end;
  end;
end;

function TDButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if btnState = tdisable then
    Exit;

  if inherited MouseUp(Button, Shift, X, Y) then
  begin
    if not Downed then
    begin
      Result := True;
      ClickInv := 0;
      Exit;
    end;
    ReleaseDCapture;
    if not Background then
    begin
      if InRange(X, Y, Shift) then
      begin

        if GetTickCount - ClickInv <= 150 then
        begin
          //Result := True;
          Downed := False;
          Exit;
        end;
        ClickInv := GetTickCount;
       
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;

    Downed := False;
    Result := True;
    Exit;
  end
  else
  begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

{--------------------- TDCheckBox --------------------------}

constructor TDCheckBox.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FArrived := False;
  Checked := False;
  Downed := False;
  FOnClick := nil;
  FEnableFocus := True;
  FClickSound := csNone;
end;

function TDCheckBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  FArrived := Result;
  if (not Background) and (not Result) then
  begin
    //Result := inherited MouseMove(Shift, X, Y);
    if MouseCaptureControl = self then
      if InRange(X, Y, Shift) then
        Downed := True
      else
        Downed := False;
  end;
end;

function TDCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then
  begin
    if (not Background) and (MouseCaptureControl = nil) then
    begin
      Downed := True;
      SetDCapture(self);
    end;
    Result := True;
  end;
end;

function TDCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then
  begin
    ReleaseDCapture;
    if not Background then
    begin
      if InRange(X, Y, Shift) then
      begin
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
  end
  else
  begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

{--------------------- TDCustomControl --------------------------}

constructor TDCustomControl.Create(aowner: TComponent);
begin
  inherited Create(aowner);
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

procedure TDCustomControl.SetFrameSize(Value: byte);
begin
  if FFrameSize <> Value then
    FFrameSize := Value;
end;

procedure TDCustomControl.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDCustomControl.SetFrameHotColor(Value: TColor);
begin
  if FFrameHotColor <> Value then
  begin
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
  Result := inherited MouseMove(Shift, X, Y);
  if FEnabled and not Background then
  begin
    if Result then
      SetFrameHot(True)
    else if FocusedControl <> self then
      SetFrameHot(False);
  end;
end;

function TDCustomControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then
  begin
    if FEnabled then
    begin
      if (not Background) and (MouseCaptureControl = nil) then
      begin
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
  if inherited MouseUp(Button, Shift, X, Y) then
  begin
    ReleaseDCapture;
    if FEnabled and not Background then
    begin
      if InRange(X, Y, Shift) then
      begin
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := False;
    Result := True;
    Exit;
  end
  else
  begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

{--------------------- TDxCustomEdit --------------------------}

constructor TDxCustomEdit.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  Downed := False;
  FMiniCaret := 0;
  m_InputHint := '';
  DxHint := nil;
  FCaretColor := clWhite;
  FOnClick := nil;
  FEnableFocus := True;
  FClick := False;
  FSelClickStart := False;
  FSelClickEnd := False;
  FClickX := 0;
  FSelStart := -1;
  FSelEnd := -1;
  FStartTextX := 0;
  FSelTextStart := 0;
  FSelTextEnd := 0;
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
  FRightClick := True;
  OnMouseUp := frmDlg.DxEditLoginIDMouseUp;
end;

procedure TDxCustomEdit.SetSelLength(Value: Integer);
begin
  SetSelStart(Value - 1);
  SetSelEnd(Value - 1);
end;

function TDxCustomEdit.ReadSelLength(): Integer;
begin
  Result := abs(FSelStart - FSelEnd);
end;

procedure TDxCustomEdit.DoFoucused;
begin
  if Assigned(FOnFoucused) then
    FOnFoucused(Self);
end;

procedure TDxCustomEdit.DoEntered;
begin
  if Assigned(FOnEntered) then
    FOnEntered(Self);
end;

procedure TDxCustomEdit.SetSelStart(Value: Integer);
begin
  if FSelStart <> Value then
    FSelStart := Value;
end;

procedure TDxCustomEdit.SetSelEnd(Value: Integer);
begin
  if FSelEnd <> Value then
    FSelEnd := Value;
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
  DoFoucused(); //对象聚集有可能重复触发  2019-09-30
  DoEntered();  //新增Enter事件  2019-10-04
end;

procedure TDxCustomEdit.SetFocus();
begin
  SetDFocus(self);
end;

procedure TDxCustomEdit.ChangeCurPos(nPos: Integer; boLast: Boolean = False);
begin
  if Caption = '' then
    Exit;

  if boLast then
  begin
    FCurPos := Length(Caption);
    Exit;
  end;

  if nPos = 1 then
  begin //Right ->
    case ByteType(Caption, FCurPos + 1) of
      mbSingleByte: nPos := 1;
      mbLeadByte: nPos := 2; //汉字的第一个字节
      mbTrailByte: nPos := 2; //汉字的第二个字节
    end;
  end
  else
  begin //Left <-
    case ByteType(Caption, FCurPos) of
      mbSingleByte: nPos := -1;
      mbLeadByte: nPos := -2;
      mbTrailByte: nPos := -2;
    end;
  end;

  if ((FCurPos + nPos) <= Length(Caption)) then
  begin
    if ((FCurPos + nPos) >= 0) then
      FCurPos := FCurPos + nPos;
  end;

  {if nPos = 1 then begin
    if ((FCurPos + 1) <= Length(Caption)) and (Caption[FCurPos + 1] > #$80) then
      nPos := 2
  end else begin
    if ((FCurPos + 0) <= Length(Caption)) and (Caption[FCurPos + 0] > #$80) then
      nPos := -2;
  end;

  if ((FCurPos + nPos) <= Length(Caption)) then begin
    if ((FCurPos + nPos) >= 0) then
      FCurPos := FCurPos + nPos;
  end;}

  if FSelClickStart then
  begin
    FSelClickStart := False;
    FSelStart := FCurPos;
  end;
  if FSelClickEnd then
  begin
    FSelClickEnd := False;
    FSelEnd := FCurPos;
  end;
end;

function TDxCustomEdit.KeyPress(var Key: Char): Boolean;
var
  s, cStr: string;
  nlen, cpLen: Integer;
  pStart: Integer;
  pEnd: Integer;
begin
  if not FEnabled or FIsHotKey then
    Exit;
  if not self.Visible then
    Exit;
  if (self.DParent = nil) or (not self.DParent.Visible) then
    Exit;
  s := Caption;
  try
    if (Ord(Key) in [VK_RETURN, VK_ESCAPE]) then
    begin
      Result := inherited KeyPress(Key);
      Exit;
    end;
    if not FNomberOnly and IsKeyPressed(VK_CONTROL) and (Ord(Key) in [1..27]) then
    begin
      //MessageBox(0, PChar(IntToStr(Ord(Key))), '', mb_ok);
      if (Ord(Key) = 22) then
      begin //CTRL + V
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          frmDlg.EditTemp.SelectAll;
          frmDlg.EditTemp.PasteFromClipboard;
          cStr := frmDlg.EditTemp.Text;
          if cStr <> '' then
          begin
            cpLen := FMaxLength - Length(Caption) + abs(FSelStart - FSelEnd);
            FSelStart := -1;
            FSelEnd := -1;
            Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
            FCurPos := pStart;

            nlen := Length(cStr);
            if nlen < cpLen then
              cpLen := nlen;
            Caption := Copy(Caption, 1, FCurPos) + Copy(cStr, 1, cpLen) + Copy(Caption, FCurPos + 1, Length(Caption));
            Inc(FCurPos, cpLen);

          end;
        end
        else
        begin
          cpLen := FMaxLength - Length(Caption);
          if cpLen > 0 then
          begin
            frmDlg.EditTemp.SelectAll;
            frmDlg.EditTemp.PasteFromClipboard;
            cStr := frmDlg.EditTemp.Text;
            if cStr <> '' then
            begin
              nlen := Length(cStr);
              if nlen < cpLen then
                cpLen := nlen;
              Caption := Copy(Caption, 1, FCurPos) + Copy(cStr, 1, cpLen) + Copy(Caption, FCurPos + 1, Length(Caption));
              Inc(FCurPos, cpLen);
            end;
          end
          else
            Beep;
        end;
      end;

      if (Ord(Key) = 3) and (FPasswordChar = #0) and (Caption <> '') then
      begin //CTRL + C
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Copy(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then
          begin
            frmDlg.EditTemp.Text := cStr;
            frmDlg.EditTemp.SelectAll;
            frmDlg.EditTemp.CopyToClipboard;
          end;
        end;
      end;

      if (Ord(Key) = 24) and (FPasswordChar = #0) and (Caption <> '') then
      begin //CTRL + X
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Copy(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then
          begin
            frmDlg.EditTemp.Text := cStr;
            frmDlg.EditTemp.SelectAll;
            frmDlg.EditTemp.CopyToClipboard;
          end;
          FSelStart := -1;
          FSelEnd := -1;
          Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
          FCurPos := pStart;
        end;
      end;

      if (Ord(Key) = 1) and not FIsHotKey and (Caption <> '') then
      begin //CTRL + A
        FSelStart := 0;
        FSelEnd := Length(Caption);
        FCurPos := FSelEnd;
      end;

      Result := inherited KeyPress(Key);
      Exit;
    end;

    Result := inherited KeyPress(Key);
    if Result then
    begin
      ShowCaret();
      case Ord(Key) of
        VK_BACK:
          begin
            if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
            begin
              if FSelStart > FSelEnd then
              begin
                pStart := FSelEnd;
                pEnd := FSelStart;
              end;
              if FSelStart < FSelEnd then
              begin
                pStart := FSelStart;
                pEnd := FSelEnd;
              end;
              FSelStart := -1;
              FSelEnd := -1;
              Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
              FCurPos := pStart;
            end
            else
            begin
              if (FCurPos > 0) then
              begin
                nlen := 1;
                case ByteType(Caption, FCurPos) of
                  mbSingleByte: nlen := 1;
                  mbLeadByte: nlen := 2;
                  mbTrailByte: nlen := 2;
                end;
                Caption := Copy(Caption, 1, FCurPos - nlen) + Copy(Caption, FCurPos + 1, Length(Caption));
                Dec(FCurPos, nlen);

                {if (FCurPos >= 2) and (Caption[FCurPos] > #$80) and (Caption[FCurPos - 1] > #$80) then begin
                  Caption := Copy(Caption, 1, FCurPos - 2) + Copy(Caption, FCurPos + 1, Length(Caption));
                  Dec(FCurPos, 2);
                end else begin
                  Caption := Copy(Caption, 1, FCurPos - 1) + Copy(Caption, FCurPos + 1, Length(Caption));
                  Dec(FCurPos);
                end;}
              end;
            end;
          end;
      else
        begin
          if (FMaxLength <= 0) or (FMaxLength > MaxChar) then
            FMaxLength := MaxChar;
          if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
          begin
            if FSelStart > FSelEnd then
            begin
              pStart := FSelEnd;
              pEnd := FSelStart;
            end;
            if FSelStart < FSelEnd then
            begin
              pStart := FSelStart;
              pEnd := FSelEnd;
            end;
            if FNomberOnly then
            begin
              if (Key >= #$30) and (Key <= #$39) then
              begin
                FSelStart := -1;
                FSelEnd := -1;
                Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
                FCurPos := pStart;
                FSecondChineseChar := False;
                if Length(Caption) < FMaxLength then
                begin
                  Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                  Inc(FCurPos);
                end
                else
                  Beep;
              end
              else
                Beep;
            end
            else
            begin
              FSelStart := -1;
              FSelEnd := -1;
              Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
              FCurPos := pStart;
              if Key > #$80 then
              begin
                if FSecondChineseChar then
                begin
                  FSecondChineseChar := False;
                  if Length(Caption) < FMaxLength then
                  begin
                    Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                    Inc(FCurPos);
                  end
                  else
                    Beep;
                end
                else
                begin
                  if Length(Caption) + 1 < FMaxLength then
                  begin
                    FSecondChineseChar := True;
                    Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                    Inc(FCurPos);
                  end
                  else
                    Beep;
                end;
              end
              else
              begin
                FSecondChineseChar := False;
                if Length(Caption) < FMaxLength then
                begin
                  Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                  Inc(FCurPos);
                end
                else
                  Beep;
              end;
            end;
          end
          else
          begin
            if FNomberOnly then
            begin
              if (Key >= #$30) and (Key <= #$39) then
              begin
                FSelStart := -1;
                FSelEnd := -1;
                FSecondChineseChar := False;
                if Length(Caption) < FMaxLength then
                begin
                  Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                  Inc(FCurPos);
                end;
              end
              else
                Beep;
            end
            else
            begin
              FSelStart := -1;
              FSelEnd := -1;
              if Key > #$80 then
              begin
                if FSecondChineseChar then
                begin
                  FSecondChineseChar := False;
                  if Length(Caption) < FMaxLength then
                  begin
                    Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                    Inc(FCurPos);
                    FSelStart := FCurPos;
                  end
                  else
                    Beep;
                end
                else
                begin
                  if Length(Caption) + 1 < FMaxLength then
                  begin
                    FSecondChineseChar := True;
                    Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                    Inc(FCurPos);
                    FSelStart := FCurPos;
                  end
                  else
                    Beep;
                end;
              end
              else
              begin
                FSecondChineseChar := False;
                if Length(Caption) < FMaxLength then
                begin
                  Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                  Inc(FCurPos);
                  FSelStart := FCurPos;
                end
                else
                  Beep;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    if s <> Caption then
    begin
      if Assigned(FOnTextChanged) then
        FOnTextChanged(self, Caption);
    end;
  end;
end;

function TDxCustomEdit.KeyPressEx(var Key: Char): Boolean;
var
  s, cStr: string;
  nlen, cpLen: Integer;
  pStart: Integer;
  pEnd: Integer;
begin
  if not FEnabled or FIsHotKey then
    Exit;
  if not self.Visible then
    Exit;
  if (self.DParent = nil) or (not self.DParent.Visible) then
    Exit;

  s := Caption;
  try
    if not FNomberOnly and (Ord(Key) in [1..27]) then
    begin
      if (Ord(Key) = 22) then
      begin //CTRL + V
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          frmDlg.EditTemp.SelectAll;
          frmDlg.EditTemp.PasteFromClipboard;
          cStr := frmDlg.EditTemp.Text;
          if cStr <> '' then
          begin
            cpLen := FMaxLength - Length(Caption) + abs(FSelStart - FSelEnd);
            FSelStart := -1;
            FSelEnd := -1;
            Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
            FCurPos := pStart;

            nlen := Length(cStr);
            if nlen < cpLen then
              cpLen := nlen;
            Caption := Copy(Caption, 1, FCurPos) + Copy(cStr, 1, cpLen) + Copy(Caption, FCurPos + 1, Length(Caption));
            Inc(FCurPos, cpLen);
          end;
        end
        else
        begin
          cpLen := FMaxLength - Length(Caption);
          if cpLen > 0 then
          begin
            frmDlg.EditTemp.SelectAll;
            frmDlg.EditTemp.PasteFromClipboard;
            cStr := frmDlg.EditTemp.Text;
            if cStr <> '' then
            begin
              nlen := Length(cStr);
              if nlen < cpLen then
                cpLen := nlen;
              Caption := Copy(Caption, 1, FCurPos) + Copy(cStr, 1, cpLen) + Copy(Caption, FCurPos + 1, Length(Caption));
              Inc(FCurPos, cpLen);
            end;
          end
          else
            Beep;
        end;
      end;

      if (Ord(Key) = 3) and (FPasswordChar = #0) and (Caption <> '') then
      begin //CTRL + C
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Copy(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then
          begin
            frmDlg.EditTemp.Text := cStr;
            frmDlg.EditTemp.SelectAll;
            frmDlg.EditTemp.CopyToClipboard;
          end;
        end;
      end;

      if (Ord(Key) = 24) and (FPasswordChar = #0) and (Caption <> '') then
      begin //CTRL + X
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Copy(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then
          begin
            frmDlg.EditTemp.Text := cStr;
            frmDlg.EditTemp.SelectAll;
            frmDlg.EditTemp.CopyToClipboard;
          end;
          FSelStart := -1;
          FSelEnd := -1;
          Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
          FCurPos := pStart;
        end;
      end;

      if (Ord(Key) = 1) and not FIsHotKey and (Caption <> '') then
      begin //CTRL + A
        FSelStart := 0;
        FSelEnd := Length(Caption);
        FCurPos := FSelEnd;
      end;

      if (Ord(Key) = VK_BACK) and not FIsHotKey and (Caption <> '') then
      begin //CTRL + A
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          FSelStart := -1;
          FSelEnd := -1;
          Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
          FCurPos := pStart;
        end;
      end;
    end;
  finally
    if s <> Caption then
    begin
      if Assigned(FOnTextChanged) then
        FOnTextChanged(self, Caption);
    end;
  end;
end;

const
  HotKeyAtomPrefix = 'Blue_HotKey';

function TDxCustomEdit.SetOfHotKey(HotKey: Cardinal): Word;
begin
  Result := 0;
  if (HotKey <> 0) and not frmMain.IsRegisteredHotKey(HotKey) then
  begin
    if FAtom <> 0 then
    begin
      UnregisterHotKey(g_MainHWnd, FAtom);
      GlobalDeleteAtom(FAtom);
    end;
    Result := 0;
    FHotKey := HotKey;
    Caption := HotKeyToText(HotKey, True);
  end;
end;

function TDxCustomEdit.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  pStart, pEnd: Integer;
  M: Word;
  HK: Cardinal;
  ret {, IsRegistered}: Boolean;
  s: string;
begin
  if not FEnabled then
    Exit;
  s := Caption;
  try
    ret := inherited KeyDown(Key, Shift);
    if ret then
    begin
      if FIsHotKey then
      begin
        if Key in [VK_BACK, VK_DELETE] then
        begin
          if (FHotKey <> 0) then
          begin
            FHotKey := 0;
            FAtom := 0;
          end;
          Caption := '';
          Exit;
        end;
        if (Key = VK_TAB) or (Char(Key) in ['A'..'Z', 'a'..'z']) then
        begin
          M := 0;
          if ssCtrl in Shift then
            M := M or MOD_CONTROL;
          if ssAlt in Shift then
            M := M or MOD_ALT;
          if ssShift in Shift then
            M := M or MOD_SHIFT;
          HK := GetHotKey(M, Key);
          if (HK <> 0) and (FHotKey <> 0) then
          begin
            FAtom := 0;
            FHotKey := 0;
            Caption := '';
          end;
          if (HK <> 0) then
            SetOfHotKey(HK);
        end;
      end
      else
      begin

        if (Char(Key) in ['0'..'9', 'A'..'Z', 'a'..'z']) then
          ShowCaret();

        if ssShift in Shift then
        begin
          case Key of
            VK_RIGHT:
              begin
                FSelClickEnd := True;
                ChangeCurPos(1);
              end;
            VK_LEFT:
              begin
                FSelClickEnd := True;
                ChangeCurPos(-1);
              end;
            VK_HOME:
              begin
                FSelEnd := FCurPos;
                FSelStart := 0;
              end;
            VK_END:
              begin
                FSelStart := FCurPos;
                FSelEnd := Length(Text);
              end;
          end;
        end
        else
        begin
          case Key of
            VK_LEFT:
              begin
                FSelStart := -1;
                FSelEnd := -1;
                FSelClickStart := True;
                ChangeCurPos(-1);
              end;
            VK_RIGHT:
              begin
                FSelStart := -1;
                FSelEnd := -1;
                FSelClickStart := True;
                ChangeCurPos(1);
              end;
            VK_HOME:
              begin
                FSelStart := -1;
                FSelEnd := -1;
                FCurPos := 0;
                FSelClickStart := True;
              end;
            VK_END:
              begin
                FSelStart := -1;
                FSelEnd := -1;
                FCurPos := Length(Text);
                FSelClickStart := True;
              end;
            VK_DELETE:
              begin
                if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
                begin
                  if FSelStart > FSelEnd then
                  begin
                    pStart := FSelEnd;
                    pEnd := FSelStart;
                  end;
                  if FSelStart < FSelEnd then
                  begin
                    pStart := FSelStart;
                    pEnd := FSelEnd;
                  end;
                  FSelStart := -1;
                  FSelEnd := -1;
                  Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
                  FCurPos := pStart;
                end
                else
                begin
                  if FCurPos < Length(Caption) then
                  begin
                    pEnd := 1;
                    case ByteType(Caption, FCurPos + 1) of
                      mbSingleByte: pEnd := 1;
                      mbLeadByte: pEnd := 2; //汉字的第一个字节
                      mbTrailByte: pEnd := 2; //汉字的第二个字节
                    end;
                    Caption := Copy(Caption, 1, FCurPos) + Copy(Caption, FCurPos + pEnd + 1, Length(Caption));

                    {if (FCurPos < Length(Caption) - 1) and (Caption[FCurPos + 1] > #$80) then
                      Caption := Copy(Caption, 1, FCurPos) + Copy(Caption, FCurPos + 3, Length(Caption))
                    else
                      Caption := Copy(Caption, 1, FCurPos) + Copy(Caption, FCurPos + 2, Length(Caption));}
                  end;
                end;
              end;
          end;
        end;
      end;
    end;
    Result := ret;
  finally
    if s <> Caption then
    begin
      if Assigned(FOnTextChanged) then
        FOnTextChanged(self, Caption);
    end;
  end;
end;

procedure TDxCustomEdit.DirectPaint(dsurface: TDirectDrawSurface);
var
  bFocused, bIsChinese: Boolean;
  i, oCSize, WidthX,
    nl, nr, nt: Integer;
  tmpword: string[255];
  tmpColor, OldColor, OldBColor: TColor;
  ob, op, ofc, oFColor: TColor;
  OldFont: TFont;
  off, ss, se, cPos: Integer;
begin
  if not Visible then
    Exit;
  nl := SurfaceX(Left);
  //nr := SurfaceX(Left + Width);
  nt := SurfaceY(Top);

  if (FocusedControl <> self) and (DxHint <> nil) then
    DxHint.Visible := False;

  if FEnabled and not FIsHotKey then
  begin
    if GetTickCount - FShowCaretTick >= 400 then
    begin
      FShowCaretTick := GetTickCount;
      FShowCaret := not FShowCaret;
    end;
    if (FCurPos > Length(Caption)) then
      FCurPos := Length(Caption);
  end;

  if (FPasswordChar <> #0) and not FIsHotKey then
  begin
    tmpword := '';
    for i := 1 to Length(Caption) do
      if Caption[i] <> FPasswordChar then
        tmpword := tmpword + FPasswordChar;
  end
  else
    tmpword := Caption;

  op := dsurface.Canvas.Pen.Color;
  ob := dsurface.Canvas.Brush.Color;
  ofc := dsurface.Canvas.Font.Color;
  oCSize := dsurface.Canvas.Font.Size;
  with dsurface.Canvas do
  begin
    Font.Size := self.Font.Size;

    if FEnabled or (self is TDComboBox) then
    begin
      Font.Color := self.Font.Color;
      Brush.Color := self.Color;
    end
    else
    begin
      Font.Color := self.Font.Color;
      Brush.Color := clGray;
    end;

    if not FIsHotKey and FEnabled and FClick then
    begin
      FClick := False;

      if (FClickX < 0) then
        FClickX := 0;
      se := TextWidth(tmpword, False, Font.Size);
      if FClickX > se then
        FClickX := se;

      cPos := FClickX div 6;
      case ByteType(tmpword, cPos + 1) of
        mbSingleByte: FCurPos := cPos;
        mbLeadByte:
          begin //双字节字符的首字符
            FCurPos := cPos;
          end;
        mbTrailByte:
          begin //多字节字符首字节之后的字符
            if cPos mod 2 = 0 then
            begin
              if FClickX mod 6 in [3..5] then
                FCurPos := cPos + 1
              else
                FCurPos := cPos - 1;
            end
            else
            begin
              if FClickX mod 12 in [6..11] then
                FCurPos := cPos + 1
              else
                FCurPos := cPos - 1;
            end;
          end;
      end;

      if FSelClickStart then
      begin
        FSelClickStart := False;
        FSelStart := FCurPos;
      end;
      if FSelClickEnd then
      begin
        FSelClickEnd := False;
        FSelEnd := FCurPos;
      end;

    end;

    WidthX := TextWidth(Copy(tmpword, 1, FCurPos), False, Font.Size);
    if WidthX + 3 - FStartTextX > Width then
      FStartTextX := WidthX + 3 - Width;

    if ((WidthX - FStartTextX) < 0) then
      FStartTextX := FStartTextX + (WidthX - FStartTextX);

    //if FStartTextX  > 0 then FStartTextX := 0;
    
    if FTransparent then
    begin
      if FEnabled then
      begin
        Font.Color := self.Font.Color;
        case FAlignment of
          taCenter:
            begin
              TextOutA((nl - FStartTextX) + ((Width - TextWidth(tmpword, False, Font.Size)) div 2 - 2), nt, tmpword);
              Release;
            end;
          taLeftJustify:
            begin
              ss := nl - FStartTextX;
              //TextOutA(ss, nt, tmpword);
              Brush.Style := bsClear;
              TextRect(Rect(nl, nt - Integer(FMiniCaret), nl + Width - 1, nt + Height - 1), ss, nt - Integer(FMiniCaret), string(tmpword));
              Release;
            end;
        end;

        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) and (FocusedControl = self) then
        begin
          ss := TextWidth(Copy(tmpword, 1, FSelStart), False, Font.Size);
          se := TextWidth(Copy(tmpword, 1, FSelEnd), False, Font.Size);
          Brush.Style := bsClear;
          Brush.Color := clBlue; //GetRGB(4);
          Pen.Color := clBlue; //GetRGB(4);
          Font.Color := clWhite;

          if FSelStart < FSelEnd then
          begin
            TextRect(
              Rect(
              _MAX(nl - 1, nl + ss - 1 - FStartTextX),
              nt - 1 - Integer(FMiniCaret),
              _MIN(nl + self.Width + 1, nl + se + 1 - FStartTextX),
              nt + TextHeight('c', False, Font.Size) + 1 - Integer(FMiniCaret)),

              nl - FStartTextX,
              nt - Integer(FMiniCaret),
              tmpword);
          end
          else
          begin
            TextRect(
              Rect(
              _MAX(nl - 1, nl + se - 1 - FStartTextX),
              nt - 1 - Integer(FMiniCaret),
              _MIN(nl + self.Width + 1, nl + ss + 1 - FStartTextX),
              nt + TextHeight('c', False, Font.Size) + 1 - Integer(FMiniCaret)),

              nl - FStartTextX,
              nt - Integer(FMiniCaret),
              tmpword);
          end;

          Release;
        end;
      end;
    end
    else
    begin
      if FFrameVisible then
      begin
        if FEnabled or (self is TDComboBox) then
        begin
          if FFrameHot then
            tmpColor := FFrameHotColor
          else
            tmpColor := FFrameColor;
        end
        else
          tmpColor := clGray;

        Brush.Style := bsClear;
        Pen.Color := tmpColor;
        Brush.Color := tmpColor;
        Rectangle(nl - 3, nt - 3, nl + Width - 1, nt + Height - 1);
        Release;
      end;

      if FIsHotKey then
      begin
        bFocused := FocusedControl = self;
        if FEnabled then
        begin
          Brush.Style := bsClear;
          Pen.Color := clBlack;
          Brush.Color := clBlack;
          FillRect(Rect(nl + FFrameSize - 3 + Integer(bFocused), nt + FFrameSize - 3 + Integer(bFocused), nl + Width - FFrameSize - 1 - Integer(bFocused), nt + Height - FFrameSize - 1 - Integer(bFocused)));
          Release;
          if bFocused then
            Font.Color := clLime
          else
            Font.Color := self.Font.Color;
        end
        else
        begin
          Brush.Style := bsClear;
          Pen.Color := self.Color;
          Brush.Color := self.Color;
          FillRect(Rect(nl + FFrameSize - 3, nt + FFrameSize - 3, nl + Width - FFrameSize - 1, nt + Height - FFrameSize - 1));
          Release;
          Font.Color := clGray;
        end;
        case FAlignment of
          taCenter: TextOutA((nl - FStartTextX) + ((Width - TextWidth(tmpword, False, Font.Size)) div 2 - 2), nt, tmpword);
          taLeftJustify:
            begin
              TextOutA(nl - FStartTextX, nt, tmpword);
            end;
        end;
      end
      else
      begin
        Brush.Style := bsClear;
        Pen.Color := self.Color;
        Brush.Color := self.Color;
        FillRect(Rect(nl - 3 + FFrameSize, nt - 3 + FFrameSize, nl + Width - 1 - FFrameSize, nt + Height - 1 - FFrameSize));
        Release;

        if FEnabled then
        begin

          case FAlignment of
            taCenter: TextOutA(
                (nl - FStartTextX) + ((Width - TextWidth(tmpword, False, Font.Size)) div 2 - 2),
                nt - Integer(FMiniCaret) * 1,
                tmpword);
            taLeftJustify:
              begin
                ss := nl - FStartTextX;
                //TextOutA(ss, nt - Integer(FMiniCaret) * 1, tmpword);

                Brush.Style := bsClear;
                TextRect(Rect(nl, nt - Integer(FMiniCaret), nl + Width - 1, nt + Height - 1), ss, nt - Integer(FMiniCaret), tmpword);
                Release;
              end;
          end;

          if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) and (FocusedControl = self) then
          begin
            ss := TextWidth(Copy(tmpword, 1, FSelStart), False, Font.Size);
            se := TextWidth(Copy(tmpword, 1, FSelEnd), False, Font.Size);
            Brush.Style := bsClear;
            Brush.Color := clBlue; //GetRGB(4);
            Pen.Color := clBlue; //GetRGB(4);
            Font.Color := clWhite;

            if FSelStart < FSelEnd then
            begin
              TextRect(
                Rect(
                _MAX(nl - 1, nl + ss - 1 - FStartTextX),
                nt - 1 - Integer(FMiniCaret) * 1,
                _MIN(nl + self.Width + 1, nl + se + 1 - FStartTextX),
                nt + TextHeight('c', False, Font.Size) + 1 - Integer(FMiniCaret) * 1), nl - FStartTextX, nt - Integer(FMiniCaret), tmpword);

            end
            else
            begin
              TextRect(
                Rect(
                _MAX(nl - 1, nl + se - 1 - FStartTextX),
                nt - 1 - Integer(FMiniCaret) * 1,
                _MIN(nl + self.Width - 1, nl + ss + 1 - FStartTextX),
                nt + TextHeight('c', False, Font.Size) + 1 - Integer(FMiniCaret) * 1), nl - FStartTextX, nt - Integer(FMiniCaret), tmpword);

            end;

            Release;
          end;
          Font.Color := self.Font.Color;

        end
        else
        begin
          Font.Color := clGray;

          case FAlignment of
            taCenter: TextOutA(
                (nl - FStartTextX) + ((Width - TextWidth(tmpword, False, Font.Size)) div 2 - 2),
                nt - Integer(FMiniCaret) * 1,
                tmpword);
            taLeftJustify:
              begin
                ss := nl - FStartTextX;
                //TextOutA(ss, nt - Integer(FMiniCaret) * 1, tmpword);

                Brush.Style := bsClear;
                TextRect(Rect(nl, nt - Integer(FMiniCaret), nl + Width - 1, nt + Height - 1), ss, nt - Integer(FMiniCaret), tmpword);
                Release;
              end;
          end;
        end;
      end;
      if self is TDComboBox then
      begin
        Font.Color := clWhite;
        Pen.Color := tmpColor;
        Brush.Style := bsClear;
        Brush.Color := tmpColor;
        Polygon([
          Point(nl + Width - DECALW * 2 + Integer(Downed), nt + (Height - DECALH) div 2 - 2 + Integer(Downed)),
            Point(nl + Width - DECALW + Integer(Downed), nt + (Height - DECALH) div 2 - 2 + Integer(Downed)),
            Point(nl + Width - DECALW - DECALW div 2 + Integer(Downed), nt + (Height - DECALH) div 2 + DECALH - 2 + Integer(Downed))
            ]);
        Release;
      end;
    end;
    if FEnabled then
    begin
      if (FocusedControl = self) then
      begin
        //if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin

        //end else
        begin
          SetFrameHot(True);
          if (Length(tmpword) >= FCurPos) and (FShowCaret and not FIsHotKey) then
          begin
            Pen.Color := FCaretColor;
            Brush.Style := bsClear;
            Brush.Color := clRed;
            case FAlignment of
              taCenter:
                begin
                  Rectangle(nl + WidthX - FStartTextX + ((Width - TextWidth(tmpword, False, Font.Size)) div 2 - 2),
                    nt - Integer(FMiniCaret <> 0) * 1,
                    nl + WidthX + 2 - Integer(FMiniCaret <> 0) - FStartTextX + ((Width - TextWidth(tmpword, False, Font.Size)) div 2 - 2),
                    nt - Integer(FMiniCaret <> 0) * 1 + TextHeight('c', False, Font.Size));
                end;
              taLeftJustify:
                begin
                  Rectangle(nl + WidthX - FStartTextX,
                    nt - Integer(FMiniCaret) * 1 - Integer(FMiniCaret = 0),
                    nl + WidthX + 2 - FStartTextX - Integer(FMiniCaret <> 0),
                    nt - Integer(FMiniCaret) * 1 + TextHeight('c', False, Font.Size) + Integer(FMiniCaret = 0));
                end;
            end;
            Release;
          end;
        end;
      end;
    end;
{$IF NEWUUI}
    if (Text = '') and (g_SendSayList.count > 0) and (m_InputHint <> '') then
    begin
      //BoldTextOut(dsurface, 113 + 200, SCREENHEIGHT - 17, clLime, clBlack, 'CTRL+↑↓');
      Font.Color := clSilver;
      TextOutA(nl + self.Width - TextWidth(m_InputHint, False, Font.Size) - 4, nt - Integer(FMiniCaret), m_InputHint);
    end;
{$ELSE}
    if (Text = '') and {(g_SendSayList.count > 0) and}(m_InputHint <> '') then
    begin
      //BoldTextOut(dsurface, 113 + 200, SCREENHEIGHT - 17, clLime, clBlack, 'CTRL+↑↓');
      Font.Color := clGray;
      TextOutA(nl + self.Width - TextWidth(m_InputHint, False, Font.Size) - 4, nt - Integer(FMiniCaret), m_InputHint);
    end;
{$IFEND NEWUUI}
  end;
  dsurface.Canvas.Font.Size := oCSize;
  dsurface.Canvas.Pen.Color := op;
  dsurface.Canvas.Brush.Color := ob;
  dsurface.Canvas.Font.Color := ofc;

  for i := 0 to DControls.count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
end;

function TDxCustomEdit.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  FSelClickEnd := False;
  if inherited MouseMove(Shift, X, Y) then
  begin
    if [ssLeft] = Shift then
    begin
      if FEnabled and not FIsHotKey and (MouseCaptureControl = self) and (Caption <> '') then
      begin
        FClick := True;
        FSelClickEnd := True;
        FClickX := X - Left + FStartTextX;
      end;
    end
    else
    begin
      //if DxHint <> nil then
      //  DxHint.Visible := False;
    end;
    Result := True;
  end;
end;

function TDxCustomEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  FSelClickStart := False;
  if inherited MouseDown(Button, Shift, X, Y) then
  begin
    if FEnabled and not FIsHotKey and (MouseCaptureControl = self) then
    begin
      if Button = mbLeft then
      begin
        FSelEnd := -1;
        FSelStart := -1;
        FClick := True;
        FSelClickStart := True;
        FClickX := X - Left + FStartTextX;
      end;
    end
    else
    begin
      //if DxHint <> nil then
      //  DxHint.Visible := False;
    end;
    Result := True;
  end;
end;

function TDxCustomEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  FSelClickEnd := False;
  if inherited MouseUp(Button, Shift, X, Y) then
  begin
    if FEnabled and not FIsHotKey and (MouseCaptureControl = self) then
    begin
      if Button = mbLeft then
      begin
        FSelEnd := -1;
        FClick := True;
        FSelClickEnd := True;
        FClickX := X - Left + FStartTextX;
      end;
    end
    else
    begin
      //if DxHint <> nil then
      //  DxHint.Visible := False;
    end;
    Result := True;
  end;
end;

{--------------------- TDComboBox --------------------------}

constructor TDComboBox.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  DropDownList := nil;
  FShowCaret := False;
  FTransparent := False;
  FEnabled := False;
  FDropDownList := nil;
end;

function TDComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then
  begin
    if (not Background) and (MouseCaptureControl = nil) then
    begin
      Downed := True;
      SetDCapture(self);
    end;
    if (FDropDownList <> nil) and not FDropDownList.ChangingHero then
    begin
      FDropDownList.Visible := not FDropDownList.Visible;
    end;
    Result := True;
  end
  else if FDropDownList <> nil then
  begin
    if FDropDownList.Visible then
      FDropDownList.Visible := False;
  end;
end;

function TDComboBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if not Background then
  begin
    if Result then
      SetFrameHot(True)
    else if FocusedControl <> self then
      SetFrameHot(False);
  end;
end;

{--------------------- TDxScrollBarBar --------------------------}

constructor TDxScrollBarBar.Create(aowner: TComponent; nTmpList: TStrings);
begin
  inherited Create(aowner);
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
  tmph: Single;
begin
  tmph := TmpList.count * Font.Height;
  if ((tmph > TotH) and (hAuteur <> 0) and (tmph <> 0) and (TotH <> 0)) then
  begin
    Height := Trunc(hAuteur / (tmph / TotH));
  end
  else
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
  with dsurface.Canvas do
  begin
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
  ret: Boolean;
begin
  ret := inherited MouseDown(Button, Shift, X, Y);
  if ret then
  begin
    Selected := True;
    dify := Top - SurfaceY(Y);
    ret := True;
  end;
  Result := ret;
end;

function TDxScrollBarBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret: Boolean;
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
  ret: Boolean;
begin
  ret := inherited MouseMove(Shift, X, Y);
  if ret then
  begin //InRange
    if Selected then
    begin
      MoveBar(SurfaceY(Y) + dify);
      ret := True;
    end;
  end;
  Result := ret;
end;

procedure TDxScrollBarBar.MoveBar(nposy: Integer);
var
  tmph: Integer;
begin
  Top := nposy;
  if Top < StartPosY then
    Top := StartPosY;
  if Top > hAuteur - Height + StartPosY then
    Top := hAuteur - Height + StartPosY;
  if ((hAuteur - Height) = 0) then
    ModPos := 0
  else
  begin
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
  ret: Boolean;
begin
  ret := inherited MouseDown(Button, Shift, X, Y);
  if ret {and (check_click_in(X, Y)))} then
  begin
    Selected := True;
    ret := True;
  end;
  Result := ret;
end;

function TDxScrollBarUp.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret: Boolean;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if Selected then
  begin
    Selected := False;
    //if ((not ret) and (check_click_in(X, Y))) then
    //  ret := True;
  end;
  Result := ret;
end;

procedure TDxScrollBarUp.DirectPaint(dsurface: TDirectDrawSurface);
const
  DECAL = 3;
begin
  with dsurface.Canvas do
  begin
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
  DECAL = 3;
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

constructor TDxScrollBar.Create(aowner: TComponent; nTmpList: TStrings);
begin
  inherited Create(aowner);
  Bar := TDxScrollBarBar.Create(aowner, nTmpList);
  BUp := TDxScrollBarUp.Create(aowner);
  BDown := TDxScrollBarDown.Create(aowner);
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
  ret: Boolean;
begin
  ret := BUp.MouseUp(Button, Shift, X - Left, Y - Top);
  if ret then
    MoveModPos(Font.Height);
  if not ret then
  begin
    ret := BDown.MouseUp(Button, Shift, X - Left, Y - Top);
    if ret then
      MoveModPos(-Font.Height);
  end;
  if not ret then
    ret := Bar.MouseUp(Button, Shift, X - Left, Y - Top);
  //ret := inherited MouseUp(Button, Shift, X, Y);
  if ret then
  begin
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

constructor TDxCustomListBox.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FSelected := -1;
  ChangingHero := False;
  FItems := TStringList.Create;
  FBackColor := clWhite;
  FSelectionColor := clSilver;
  FOnChangeSelect := nil; //ChangeSelect;
  FOnMouseMoveSelect := nil;
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
  //if Assigned(FOnChangeSelect) then begin
  // FOnChangeSelect(Self, FSelected);
  //end;
end;

procedure TDxCustomListBox.SetItemSelected(Value: Integer);
begin
  if (Value > FItems.count - 1) or (Value < 0) then
    FSelected := -1
  else
    FSelected := Value;
  {if Assigned(FOnChangeSelect) then begin
    FOnChangeSelect(Self, FSelected);
  end;}
end;

procedure TDxCustomListBox.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDxCustomListBox.SetSelectionColor(Value: TColor);
begin
  if FSelectionColor <> Value then
  begin
    FSelectionColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

function TDxCustomListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  //DScreen.AddChatBoardString('MouseDown', clWhite, clRed);
  Result := inherited MouseDown(Button, Shift, X, Y);
end;

function TDxCustomListBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  FSelected := -1;
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FEnabled and not Background then
  begin
    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y) div (-Font.Height + LineSpace);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
    if Assigned(FOnMouseMoveSelect) then
      FOnMouseMoveSelect(self, Shift, X, Y);
  end;
end;

function TDxCustomListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret: Boolean;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if ret then
  begin
    //DScreen.AddChatBoardString('ret = true ' + IntToStr(FItems.Count), clWhite, clRed);

    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y) div (-Font.Height + LineSpace);

    if FSelected > FItems.count - 1 then
      FSelected := -1;

    if FSelected <> -1 then
    begin
      if ParentComboBox <> nil then
      begin
        if ParentComboBox.Caption <> FItems[FSelected] then
        begin
          //changed ...
          //MessageBox(0, PChar(FItems[FSelected]), 's', mb_ok);

          if Caption = 'SelectHeroList' then
          begin
            ChangingHero := True;
            frmDlg.QueryChangeHero(FItems[FSelected]);
          end
          else
            ParentComboBox.Caption := FItems[FSelected];
        end;
      end;
      if Integer(FItems.Objects[FSelected]) > 0 then
        ParentComboBox.tag := Integer(FItems.Objects[FSelected]);
    end;
    //MessageBox(0, PChar(FItems[FSelected]), 's', mb_ok);
    //FSelected := -1;

    //if TmpSel <> FSelected then begin
    if Assigned(FOnChangeSelect) then
      FOnChangeSelect(self, Button, Shift, X, Y);
    //end;
    Visible := False;
    ret := True;
  end;
  Result := ret;
end;

function TDxCustomListBox.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  ret: Boolean;
begin
  ret := inherited KeyDown(Key, Shift);
  if ret then
  begin
    case Key of
      VK_PRIOR:
        begin
          ItemSelected := ItemSelected - Height div -Font.Height;
          if (ItemSelected = -1) then
            ItemSelected := 0;
        end;
      VK_NEXT:
        begin
          ItemSelected := ItemSelected + Height div -Font.Height;
          if ItemSelected = -1 then
            ItemSelected := FItems.count - 1;
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

{procedure TDxCustomListBox.ChangeSelect(ChangeSelect: Integer);
begin
  //
end;}

procedure TDxCustomListBox.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TDxCustomListBox.DirectPaint(dsurface: TDirectDrawSurface);
var
  fy, nY, L, T, i, oSize: Integer;
  OldColor: TColor;
begin
  if Assigned(FOnDirectPaint) then
  begin
    FOnDirectPaint(self, dsurface);
    Exit;
  end;

  L := SurfaceX(Left);
  T := SurfaceY(Top);
  with dsurface.Canvas do
  begin
    try
      OldColor := Font.Color;
      oSize := Font.Size;
      Font.Color := clBlack;
      Font.Size := self.Font.Size;
      Brush.Style := bsSolid;
      Brush.Color := BackColor;
      Rectangle(L, T, L + Width, T + Height);
      Brush.Color := SelectionColor;
      if FSelected <> -1 then
      begin
        nY := T + (-Font.Height + LineSpace) * FSelected;
        fy := nY + (-Font.Height + LineSpace);
        if (nY < T + Height - 1) and (fy > T + 1) then
        begin
          if (fy > T + Height - 1) then
            fy := T + Height - 1;
          if (nY < T + 1) then
            nY := T + 1;
          FillRect(Rect(L + 1, nY, L + Width - 1, fy));
        end;
      end;
      Brush.Style := bsClear;
      for i := 0 to FItems.count - 1 do
      begin
        if FSelected = i then
        begin
          Font.Color := clWhite;
          TextOut(L + 2, 2 + T + (-Font.Height + LineSpace) * i, FItems.Strings[i]);
        end
        else
        begin
          Font.Color := clBlack;
          TextOut(L + 2, 2 + T + (-Font.Height + LineSpace) * i, FItems.Strings[i]);
        end;
      end;
      Font.Color := OldColor;
      Font.Size := oSize;
    finally
      Release;
    end;
  end;
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
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDxHint.SetSelectionColor(Value: TColor);
begin
  if FSelectionColor <> Value then
  begin
    FSelectionColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

function TDxHint.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
end;

function TDxHint.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  FSelected := -1;
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FEnabled and not Background then
  begin

    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y - LineSpace2 + 2) div (-Font.Height + LineSpace2);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
    if Assigned(FOnMouseMoveSelect) then
      FOnMouseMoveSelect(self, Shift, X, Y);
  end;
end;

function TDxHint.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  c: Char;
  ret: Boolean;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if ret then
  begin

    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y - LineSpace2 + 2) div (-Font.Height + LineSpace2);

    if FSelected > FItems.count - 1 then
      FSelected := -1;

    if (FSelected > -1) and (FSelected < FItems.count) and
      (FParentControl <> nil) and (FParentControl is TDxCustomEdit) then
    begin
      if (FItems.Objects[FSelected] <> nil) then
      begin
        Result := True;
        Exit;
      end;
      if tag = 0 then
      begin
        c := #0;
        case FSelected of
          0: c := #24; //剪切
          1: c := #3; //复制
          2: c := #22; //粘贴
          3: c := #8; //删除
          4:
            begin //全选
              TDxCustomEdit(FParentControl).SelStart := 0;
              TDxCustomEdit(FParentControl).SelEnd := Length(TDxCustomEdit(FParentControl).Caption);
              TDxCustomEdit(FParentControl).ChangeCurPos(TDxCustomEdit(FParentControl).SelEnd, True);
            end;
        end;
        if (c <> #0) then
        begin
          TDxCustomEdit(FParentControl).KeyPressEx(c);
        end;
      end
      else if tag = 1 then
      begin

      end;
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
  ret: Boolean;
begin
  ret := inherited KeyDown(Key, Shift);
  if ret then
  begin
    case Key of
      VK_PRIOR:
        begin
          ItemSelected := ItemSelected - Height div -Font.Height;
          if (ItemSelected = -1) then
            ItemSelected := 0;
        end;
      VK_NEXT:
        begin
          ItemSelected := ItemSelected + Height div -Font.Height;
          if ItemSelected = -1 then
            ItemSelected := FItems.count - 1;
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
  fy, nY, L, T, i, oSize: Integer;
  OldColor: TColor;
begin

  if Assigned(FOnDirectPaint) then
  begin
    FOnDirectPaint(self, dsurface);
    Exit;
  end;

  L := SurfaceX(Left);
  T := SurfaceY(Top);

  if tag = 0 then
  begin
    //with dsurface.Canvas do begin
    try
      OldColor := dsurface.Canvas.Font.Color;
      oSize := dsurface.Canvas.Font.Size;
      dsurface.Canvas.Font.Color := clBlack;
      dsurface.Canvas.Font.Size := self.Font.Size;
      dsurface.Canvas.Brush.Style := bsSolid;
      dsurface.Canvas.Brush.Color := BackColor;
      dsurface.Canvas.Rectangle(L, T + 1, L + Width, T + Height - 1);
      dsurface.Canvas.Brush.Style := bsClear;
      dsurface.Canvas.Brush.Color := clBlue;

      if (FSelected > -1) and (FSelected < FItems.count) then
      begin
        if (FItems.Objects[FSelected] = nil) then
        begin

          nY := T + (-dsurface.Canvas.Font.Height + LineSpace2) * FSelected;
          fy := nY + (-dsurface.Canvas.Font.Height + LineSpace2);
          if (nY < T + Height - 1) and (fy > T + 1) then
          begin
            if (fy > T + Height - 1) then
              fy := T + Height - 1;
            if (nY < T + 1) then
              nY := T + 1;
            dsurface.Canvas.FillRect(Rect(L + 2, nY + 2, L + Width - 2, fy + 5));
          end;
        end;
      end;

      dsurface.Canvas.Brush.Style := bsClear;
      for i := 0 to FItems.count - 1 do
      begin
        if (FSelected = i) and (FItems.Objects[i] = nil) then
        begin
          dsurface.Canvas.Font.Color := clWhite
        end
        else if (FItems.Objects[i] <> nil) then
          dsurface.Canvas.Font.Color := clSilver
        else
        begin
          dsurface.Canvas.Font.Color := clBlack;
        end;
        dsurface.Canvas.TextOut(L + LineSpace2, LineSpace2 + T + (-dsurface.Canvas.Font.Height + LineSpace2) * i, FItems.Strings[i]);
      end;
      dsurface.Canvas.Font.Color := OldColor;
      dsurface.Canvas.Font.Size := oSize;
    finally
      dsurface.Canvas.Release;
    end;
    Exit;
  end;

  try
    OldColor := dsurface.Canvas.Font.Color;
    oSize := dsurface.Canvas.Font.Size;
    dsurface.Canvas.Font.Color := clWhite;
    dsurface.Canvas.Font.Size := self.Font.Size;
    DrawBlend_Mix(dsurface, L, T, g_HintSurface_B, 0, 0, Width, Height, 0);
    dsurface.Canvas.Brush.Color := clHighlight;

    if (FSelected > -1) and (FSelected < FItems.count) then
    begin
      if (FItems.Objects[FSelected] = nil) then
      begin

        nY := T + (-dsurface.Canvas.Font.Height + LineSpace2) * FSelected;
        fy := nY + (-dsurface.Canvas.Font.Height + LineSpace2);
        if (nY < T + Height - 1) and (fy > T + 1) then
        begin
          if (fy > T + Height - 1) then
            fy := T + Height - 1;
          if (nY < T + 1) then
            nY := T + 1;
          dsurface.Canvas.FillRect(Rect(L, nY + 2, L + Width, fy + 5));
        end;
      end;
    end;

    dsurface.Canvas.Brush.Style := bsClear;
    for i := 0 to FItems.count - 1 do
    begin
      if (FSelected = i) and (FItems.Objects[i] = nil) then
      begin
        dsurface.Canvas.Font.Color := clWhite
      end
      else if (FItems.Objects[i] <> nil) then
        dsurface.Canvas.Font.Color := clSilver
      else
      begin
        dsurface.Canvas.Font.Color := clWhite;
      end;
      dsurface.Canvas.TextOut(L + LineSpace2, LineSpace2 + T + (-dsurface.Canvas.Font.Height + LineSpace2) * i, FItems.Strings[i]);
    end;
    dsurface.Canvas.Font.Color := OldColor;
    dsurface.Canvas.Font.Size := oSize;
  finally
    dsurface.Canvas.Release;
  end;
  //end;
end;

{------------------------- TDGrid --------------------------}

constructor TDGrid.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FColCount := 8;
  FRowCount := 5;
  FColWidth := 36;
  FRowHeight := 32;
  FOnGridSelect := nil;
  FOnGridMouseMove := nil;
  FOnGridPaint := nil;
  tButton := mbLeft;
end;

function TDGrid.GetColRow(X, Y: Integer; var ACol, ARow: Integer): Boolean;
begin
  Result := False;
  //DScreen.AddChatBoardString('TDGrid.GetColRow ...', clWhite, clRed);
  if InRange(X, Y, [ssDouble]) then
  begin
    ACol := (X - Left) div FColWidth;
    ARow := (Y - Top) div FRowHeight;
    Result := True;
  end;
end;

function TDGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow: Integer;
begin
  Result := False;
  //DScreen.AddChatBoardString('TDGrid.MouseDown ...', clWhite, clRed);
  //if mbLeft = Button then begin
  if Button in [mbLeft, mbRight] then
  begin
    if GetColRow(X, Y, ACol, ARow) then
    begin
      SelectCell.X := ACol;
      SelectCell.Y := ARow;
      DownPos.X := X;
      DownPos.Y := Y;
      //if mbLeft = Button then SetDCapture (self);
      SetDCapture(self);
      Result := True;
    end;
  end;
end;

function TDGrid.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow: Integer;
begin
  Result := False;
  //DScreen.AddChatBoardString('TDGrid.MouseMove ...', clWhite, clRed);
  if InRange(X, Y, Shift) then
  begin
    if GetColRow(X, Y, ACol, ARow) then
    begin
      if Assigned(FOnGridMouseMove) then
        FOnGridMouseMove(self, ACol, ARow, Shift);
    end;
    Result := True;
  end;
end;

function TDGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow: Integer;
begin
  Result := False;

  //DScreen.AddChatBoardString('TDGrid.MouseUp ...', clWhite, clRed);

  if Button in [mbLeft, mbRight] then
  begin
    if GetColRow(X, Y, ACol, ARow) then
    begin
      if (SelectCell.X = ACol) and (SelectCell.Y = ARow) then
      begin
        Col := ACol;
        Row := ARow;
        if Assigned(FOnGridSelect) then
        begin
          self.tButton := Button;
          FOnGridSelect(self, ACol, ARow, Shift);
        end;
      end;
      Result := True;
    end;
    ReleaseDCapture;
  end;
end;

function TDGrid.Click(X, Y: Integer): Boolean;
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
  i, j: Integer;
  rc: TRect;
begin
  if Assigned(FOnGridPaint) then
  begin
    for i := 0 to FRowCount - 1 do
    begin
      for j := 0 to FColCount - 1 do
      begin
        rc := Rect(Left + j * FColWidth, Top + i * FRowHeight, Left + j * (FColWidth + 1) - 1, Top + i * (FRowHeight + 1) - 1);
        if (SelectCell.Y = i) and (SelectCell.X = j) then
          begin
            FOnGridPaint(self, j, i, rc, [gdSelected], dsurface);
          end
        else
          FOnGridPaint(self, j, i, rc, [], dsurface);
      end;
    end;
  end;
end;

{--------------------- TDWindown --------------------------}

constructor TDWindow.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FFloating := False;
  FMoveRange := False;
  FEnableFocus := True;
  Width := 120;
  Height := 120;
end;

procedure TDWindow.SetVisible(flag: Boolean);
begin
  FVisible := flag;
  if Floating then
  begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
end;

function TDWindow.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  al, at: Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  //if not FloatingEx then exit;
  if Result and FFloating and (MouseCaptureControl = self) then
  begin
    if (SpotX <> X) or (SpotY <> Y) then
    begin
      al := Left + (X - SpotX);
      at := Top + (Y - SpotY);
      if FMoveRange then
      begin
        if al + Width < WINLEFT then
          al := WINLEFT - Width;
        if al > WINRIGHT then
          al := WINRIGHT;
        if at + Height < WINTOP then
          at := WINTOP - Height;
        if at + Height > BOTTOMEDGE then
          at := BOTTOMEDGE - Height;

        {if al < 0 then al := 0;
        if al + Width > SCREENWIDTH then al := SCREENWIDTH - Width;
        if at < 0 then at := 0;
        if at + Height > SCREENHEIGHT then at := SCREENHEIGHT - Height;}
      end;
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
  if Result then
  begin
    if Floating then
    begin
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

procedure TDWindow.Show;
begin
  Visible := True;
  if Floating then
  begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
  if EnableFocus then
    SetDFocus(self);
end;

function TDWindow.ShowModal: Integer;
begin
  Result := 0; //Jacky
  Visible := True;
  ModalDWindow := self;
  if EnableFocus then
    SetDFocus(self);
end;

{--------------------- TDWinManager --------------------------}

constructor TDWinManager.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  DWinList := TList.Create;
  //FIsManager := True;
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
  i: Integer;
begin
  for i := 0 to DWinList.count - 1 do
    if DWinList[i] = dcon then
    begin
      DWinList.Delete(i);
      Break;
    end;
end;

function TDWinManager.KeyPress(var Key: Char): Boolean;
begin
  Result := False;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        Result := KeyPress(Key);
      Exit;
    end
    else
      ModalDWindow := nil;
    Key := #0;
  end;

  if FocusedControl <> nil then
  begin
    if FocusedControl.Visible then
    begin
      Result := FocusedControl.KeyPress(Key);
    end
    else
      ReleaseDFocus;
  end;
end;

function TDWinManager.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := False;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        Result := KeyDown(Key, Shift);
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if FocusedControl <> nil then
  begin
    if FocusedControl.Visible then
      Result := FocusedControl.KeyDown(Key, Shift)
    else
      ReleaseDFocus;
  end;
end;

function TDWinManager.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        MouseMove(Shift, LocalX(X), LocalY(Y));
      Result := True;
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then
  begin
    with MouseCaptureControl do
      Result := MouseMove(Shift, LocalX(X), LocalY(Y));
  end
  else
    for i := 0 to DWinList.count - 1 do
    begin
      if TDControl(DWinList[i]).Visible then
      begin
        if TDControl(DWinList[i]).MouseMove(Shift, X, Y) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function TDWinManager.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        MouseDown(Button, Shift, LocalX(X), LocalY(Y));
      Result := True;
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then
  begin
    with MouseCaptureControl do
      Result := MouseDown(Button, Shift, LocalX(X), LocalY(Y));
  end
  else
    for i := 0 to DWinList.count - 1 do
    begin
      if TDControl(DWinList[i]).Visible then
      begin
        if TDControl(DWinList[i]).MouseDown(Button, Shift, X, Y) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function TDWinManager.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then
  begin
    with MouseCaptureControl do
      Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
  end
  else
    for i := 0 to DWinList.count - 1 do
    begin
      if TDControl(DWinList[i]).Visible then
      begin
        if TDControl(DWinList[i]).MouseUp(Button, Shift, X, Y) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function TDWinManager.DblClick(X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        Result := DblClick(LocalX(X), LocalY(Y));
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then
  begin
    with MouseCaptureControl do
      Result := DblClick(LocalX(X), LocalY(Y));
  end
  else
  begin
    for i := 0 to DWinList.count - 1 do
    begin
      if TDControl(DWinList[i]).Visible then
      begin
        if TDControl(DWinList[i]).DblClick(X, Y) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

function TDWinManager.Click(X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        Result := Click(LocalX(X), LocalY(Y));
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then
  begin
    with MouseCaptureControl do
      Result := Click(LocalX(X), LocalY(Y));
  end
  else
    for i := 0 to DWinList.count - 1 do
    begin
      if TDControl(DWinList[i]).Visible then
      begin
        if TDControl(DWinList[i]).Click(X, Y) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

procedure TDWinManager.DirectPaint(dsurface: TDirectDrawSurface);
var
  i: Integer;
begin
  for i := 0 to DWinList.count - 1 do
  begin
    if TDControl(DWinList[i]).Visible then
      TDControl(DWinList[i]).DirectPaint(dsurface);
  end;
  if ModalDWindow <> nil then
  begin
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
  LeftToRight := True;
  bMouseMove := True;
end;

procedure TDMoveButton.SetVisible(flag: Boolean);
begin
  FVisible := flag;
  if Floating then
  begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
end;

function TDMoveButton.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  n, al, at, ot: Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Max <= 0 then
    Exit;
  if ssLeft in Shift then
  begin
    if Result and FFloating and (MouseCaptureControl = self) then
    begin
      n := Position;
      try
        if Max <= 0 then
          Exit;
        if (SpotX <> X) or (SpotY <> Y) then
        begin
          if LeftToRight then
          begin
            if not Reverse then
            begin
              ot := SlotLen - Width;
              al := RTop; //RLeft;
              at := Left + (X - SpotX);
              if at < RLeft then
                at := RLeft;
              if at + Width > RLeft + SlotLen then
                at := RLeft + SlotLen - Width;
              Position := Round((at - RLeft) / (ot / Max));
              if Position < 0 then
                Position := 0;
              if Position > Max then
                Position := Max;
              Left := at;
              Top := al;
              SpotX := X;
              SpotY := Y;
            end
            else
            begin
              al := RTop; //RLeft;
              at := Left + (X - SpotX);
              if at < RLeft - SlotLen then
                at := RLeft - SlotLen;
              if at > RLeft then
                at := RLeft;
              Position := Round((at - RLeft) / (SlotLen / Max));
              if Position < 0 then
                Position := 0;
              if Position > Max then
                Position := Max;
              Left := at;
              Top := al;
              SpotX := X;
              SpotY := Y;
            end;
          end
          else
          begin
            if not Reverse then
            begin
              ot := SlotLen - Height;
              al := RLeft;
              at := Top + (Y - SpotY);
              if at < RTop then
                at := RTop;
              if at + Height > RTop + SlotLen then
                at := RTop + SlotLen - Height;
              Position := Round((at - RTop) / (ot / Max));
              if Position < 0 then
                Position := 0;
              if Position > Max then
                Position := Max;
              Left := al;
              Top := at;
              SpotX := X;
              SpotY := Y;
            end
            else
            begin
              al := RLeft;
              at := Top + (Y - SpotY);
              if at < RTop - SlotLen then
                at := RTop - SlotLen;
              if at > RTop then
                at := RTop;
              Position := Round((at - RTop) / (SlotLen / Max));
              if Position < 0 then
                Position := 0;
              if Position > Max then
                Position := Max;
              Left := al;
              Top := at;
              SpotX := X;
              SpotY := Y;
            end;
          end;

        end;
      finally
        if (n <> Position) and Assigned(FOnMouseMove) then
          FOnMouseMove(self, Shift, X, Y);
      end;
    end;
  end;
end;

procedure TDMoveButton.UpdatePos(pos: Integer; force: Boolean);
begin
  if Max <= 0 then
    Exit;
  //if not force and (Position = pos) then Exit;
  //if (pos < 0) or (pos > Max) then Exit;
  Position := pos;
  if Position < 0 then
    Position := 0;
  if Position > Max then
    Position := Max;
  if LeftToRight then
  begin
    Left := RLeft + Round((SlotLen - Width) / Max * Position);
    if Left < RLeft then
      Left := RLeft;
    if Left > RLeft + SlotLen - Width then
      Left := RLeft + SlotLen - Width;
  end
  else
  begin
    Top := RTop + Round((SlotLen - Height) / Max * Position);
    if Top < RTop then
      Top := RTop;
    if Top > RTop + SlotLen - Height then
      Top := RTop + SlotLen - Height;
  end;
end;

function TDMoveButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then
  begin
    if Floating then
    begin
      if DParent <> nil then
        DParent.ChangeChildOrder(self);
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
  if Floating then
  begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
  if EnableFocus then
    SetDFocus(self);
end;

function TDMoveButton.ShowModal: Integer;
begin
  Result := 0;
  Visible := True;
  ModalDWindow := self;
  if EnableFocus then
    SetDFocus(self);
end;

end.
