unit HGEWinCtrl;

{.$DEFINE HGE_DX8}
{.$DEFINE DARK}
{$DEFINE WSTRING}

interface

{.$RANGECHECKS OFF}
{$WARNINGS OFF}
{$HINTS OFF}

uses
  Windows, Forms, Messages, Classes, SysUtils, Controls, Graphics, PngImage, HGE,
  HGESprite, {$IFDEF HGE_DX8}DirectXGraphics{$ELSE}Direct3D9{$ENDIF},
  Imm, Clipbrd, HGEAnim, Math, FlashPlayer, StrUtils, ActiveX, InZLibEx, Grids, HGEFont, WebControl,
  Awesomium, AnimSprite, ShellAPI, Wil, HotKey;

const
  CUSTOMUI_SAVE             = False;    //{$IF CUSTOMUI_SAVE}
  CUSTOMUI_LOAD             = False;

  DARKLIGHT                 = $7F;

  INPUT_MOUSE_MOVE          = 1;
  INPUT_MOUSE_DOWN          = 2;
  INPUT_MOUSE_UP            = 3;
  INPUT_MOUSE_DBCLICK       = 4;
  INPUT_MOUSE_WHEEL         = 5;
  CN_CONTROL_MESSAGE        = WM_USER;
  CN_USER_DEFINE_MESSAGE    = WM_USER + $B00;

  //定义聊天信息中的命令类型
  SAYCMD_NONE               = 0;
  SAYCMD_Name               = 1;
  SAYCMD_URL                = 2;        //网站URL，点击它将打开一个IE浏览器
  SAYCMD_SCRIPTLABEL        = 3;        //脚本标签，点击它将发送到服务器触发脚本
  SAYCMD_CMD                = 4;        //自定义命令
  SAYCMD_PIC                = 5;
  SAYCMD_LINE               = 6;        //从当前位置开始画一条线
  SAYCMD_CMD2               = 7;        //自定义命令
var
  MaxInputProcessTick       : Integer = 0;

  AsciiFont                 : IHGEFont; //专门用来显示因英文和数字的一个字体
type
  TMouseState = (tsNone, tsDown, tsUp, tsMove, tsDisable);

  //键盘输入缓冲结构
  TagKeyBoardBuffer = record
    HWindow: HWnd;
    nMessage: UINT;                     //up/down/char
    nKey: UINT;                         //vk-code/char
    nFlag: UINT;                        //flag for window
    Shift: TShiftState;
  end;
  PTagKeyBoardBuffer = ^TagKeyBoardBuffer;

  //鼠标输入缓冲结构
  tagMouseBuffer = record
    HWindow: HWnd;
    nType: Integer;                     //move/down/up
    nMessage: UINT;                     //msg id
    nComboKey: UINT;                    //MK_CONTROL/MK_LBUTTON/MK_MBUTTON/MK_RBUTTON/MK_SHIFT
    nWheel: UINT;                       //wheel value
    Shift: TShiftState;
    case Byte of
      0: (lParam: lParam);
      1: (X: Smallint;
        Y: Smallint);                   //x
  end;
  PTagMouseBuffer = ^tagMouseBuffer;

  TRoomIcon = record
    Tex: ITexture;
    Left: Integer;
    Top: Integer;
    OffsetX: Integer;
    OffsetY: Integer;
  end;

  TGList = class(TList)
  private
    RTL: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;
  TGStringList = class(TStringList)
  private
    RTL: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;
type
  TClickSound = (csNone, csStone, csGlass, csNorm);
  TTextureMode = (tmNone, tmStretch, tmTile, tmCenter);
  THGEControl = class;
  TOnKeyPress = procedure(Sender: TObject; var Key: Char) of object;
  TOnKeyDown = procedure(Sender: TObject; var Key: word; Shift: TShiftState) of object;
  TOnKeyUp = procedure(Sender: TObject; var Key: word; Shift: TShiftState) of object;
  TOnMouseMove = procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
  TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;

  TOnMouseMoveRet = function(Sender: TObject; Shift: TShiftState; X, Y: Integer): Boolean of object;
  TOnMouseDownRet = function(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean of object;
  TOnMouseUpRet = function(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean of object;
  TOnMouseWheelRet = function(Sender: TObject; Shift: TShiftState; X, Y, Z: Integer): Boolean of object;

  TOnMouseWheel = procedure(Sender: TObject; Shift: TShiftState; X, Y, Z: Integer) of object;
  TOnClick = procedure(Sender: TObject) of object;
  TOnClickEx = procedure(Sender: TObject; X, Y: Integer) of object;
  TOnInRealArea = procedure(Sender: TObject; X, Y: Integer; var IsRealArea: Boolean) of object;
  TOnGridSelect = procedure(Sender: TObject; ACol, ARow: Integer; Shift: TShiftState) of object;
  TOnGridRender = procedure(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState) of object;
  TOnClickSound = procedure(Sender: TObject; Clicksound: TClickSound) of object;
  TOnHint = procedure(Sender: TObject) of object;
  TOnRender = procedure(Sender: TObject) of object;
  TOnMouseEnter = procedure(Sender: TObject) of object;
  TOnMouseLeave = procedure(Sender: TObject) of object;
  TOnEnter = procedure(Sender: TObject) of object;
  TOnLeave = procedure(Sender: TObject) of object;

  TOnWindowShow = procedure(boVisible: Boolean) of object;
  TOnAfterDraw = procedure(Bmp: TBitmap) of object;
  TOnChanged = procedure(Sender: TObject) of object;
  TFunc = function(): Boolean;

  TonBeginNavigation = procedure(Sender: TObject; const url: string; const frameName: WideString) of object;
  TonBeginLoading = procedure(Sender: TObject; const url: string; const frameName: WideString; statusCode: Integer; const mimeType: WideString) of object;
  TonFinishLoading = procedure(Sender: TObject) of object;
  TonCallback = procedure(Sender: TObject; const Name: string; const Args: Pointer) of object;
  TonReceiveTitle = procedure(Sender: TObject; const title: WideString; const frameName: WideString) of object;
  TonChangeTooltip = procedure(Sender: TObject; const tooltip: WideString) of object;
  TonChangeCursor = procedure(Sender: TObject; const cursor: LongWord) of object;
  TonChangeKeyboardFocus = procedure(Sender: TObject; isFocused: Boolean) of object;
  TonChangeTargetURL = procedure(Sender: TObject; const url: string) of object;

  TonNavigationAction = function(Sender: TObject; const url: WideString; const frameName: WideString; const otype: TWebNavigationType; const default_policy: TWebNavigationPolicy; const is_redirect: Boolean): TWebNavigationPolicy of object;
  TonRunJavaScriptAlert = procedure(Sender: TObject; const sframeName: WideString; const smessage: WideString) of object;
  TonRunJavaScriptConfirm = function(Sender: TObject; const sframeName: WideString; const smessage: WideString): Boolean of object;
  TonRunJavaScriptPrompt = function(Sender: TObject; const sframeName: WideString; const smessage: WideString; const default_value: WideString;
    var oResult: WideString): Boolean of object;
  TonRunBeforeUnloadConfirm = function(Sender: TObject; const sframeName: WideString; const smessage: WideString): Boolean of object;
  TonCreateWebView = procedure(Sender: TObject; const sOpenUrl: string; const creatorurl: string; gesture: Boolean) of object;

  TMHotKeyEvent = procedure(Sender: TObject; const Key: Cardinal) of object;

  PCursorRec = ^TCursorRec;
  TCursorRec = record
    Next: PCursorRec;
    Index: Integer;
    Handle: IHGEAnimation;
  end;

  THGEControl = class(TCustomControl)
  private
    FBmp: TBitmap;
    FPng: TPNGObject;
    FCaption: string;
    FDParent: THGEControl;
    FCParent: THGEControl;
    FEnableFocus: Boolean;
    FOnKeyPress: TOnKeyPress;
    FOnKeyDown: TOnKeyDown;
    FOnKeyUp: TOnKeyUp;
    FOnMouseMove: TOnMouseMove;
    FOnMouseDown: TOnMouseDown;
    FOnMouseUp: TOnMouseUp;
    FOnDblClick: TNotifyEvent;
    FOnClick: TOnClickEx;
    FOnInRealArea: TOnInRealArea;
    FOnBackgroundClick: TOnClick;
    FIsMouseIn: Boolean;
    FOnRender: TOnRender;
    FOnEnter: TOnEnter;
    FOnLeave: TOnLeave;
    FOnMouseEnter: TOnMouseEnter;
    FOnMouseLeave: TOnMouseLeave;
    FTexture: ITexture;
    FFileName: string;
    FHGE: IHGE;
    FSpr: IHGESprite;
    FAlpha: Byte;
    FLight: Byte;
    FCanInput: Boolean;
    FAutoCheckInRange: Boolean;         //自动检测不规则边框，不需要自动检测的，需要设置为False
    FCertDrawPos: Integer;              //插入点的像素位置（用于显示光标）
    FEnabled: Boolean;
    FCertHeight: Integer;
    FCertShowY: Integer;
    FOnMouseWheel: TOnMouseWheel;
    FMaskFileName: string;
    FRenderOnTop: Boolean;
    FCursor: TCursor;
    FOnRenderCompleted: TOnRender;
    FWLib: TWMImages;
    FULib: TUIBImages;
    procedure SetCaption(str: string);
    procedure SetFileName(const Value: string);
    procedure SetAlpha(const Value: Byte);
    procedure SetLight(const Value: Byte);
    procedure SetEnabled(const Value: Boolean);
    procedure SetMaskFileName(const Value: string);
    procedure SetVisible(const Value: Boolean);
  protected
    FVisible: Boolean;
{$IFDEF DARK}
    procedure Dark(bFlag: Boolean); dynamic;
{$ENDIF}
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;
    function GetNextInputControl(boForward: Boolean = True): THGEControl;
    procedure SetTexture(const Tex: ITexture); dynamic;
  public
    ClipRect: TRect;
    Background: Boolean;
    BackgroundButton: TMouseButton;

    DControls: TList;
    NomalIndex: Integer;
    HotIndex: Integer;
    FaceIndex: Integer;
    FaceName: string;
    WantReturn: Boolean;

    PTop: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Loaded; override;
    function SurfaceX(X: Integer): Integer;
    function SurfaceY(Y: Integer): Integer;
    function LocalX(X: Integer): Integer;
    function LocalY(Y: Integer): Integer;
    procedure AddChild(dcon: THGEControl);
    procedure ChangeChildOrder(dcon: THGEControl);
    procedure BringToFront;
    procedure SendToBack;
    function InRange(X, Y: Integer): Boolean;
    function AutoCheckInRange(X, Y: Integer): Boolean; virtual;
    procedure WindowMsgProce(Window: HWnd; Msg: UINT; wParam: wParam; lParam: lParam); dynamic;
    function KeyPress(var Key: Char): Boolean; dynamic;
    function KeyDown(var Key: word; Shift: TShiftState): Boolean; dynamic;
    function KeyUp(var Key: word; Shift: TShiftState): Boolean; dynamic;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
    function MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean; dynamic;
    function DblClick(X, Y: Integer): Boolean; dynamic;
    function Click(X, Y: Integer): Boolean; dynamic;
    function CanFocusMsg: Boolean;
    procedure DoRender; dynamic;
    procedure Render; dynamic;
    function IsChild(Win: THGEControl): Boolean;
    procedure SetFocus;
    procedure LoadFromIni(sec, Key: string); dynamic;
    //procedure SaveToIni;dynamic;
    procedure AlphaBlend(Value: Byte);
    procedure FadeOut;
    property Texture: ITexture read FTexture;
    property Spr: IHGESprite read FSpr;
    property MyHGE: IHGE read FHGE;
    property CanInput: Boolean read FCanInput;

    procedure SetCursor(Value: TCursor);
    function AbstractVisible: Boolean;  //是否绝对可见
    procedure DelControl(AControl: THGEControl);

    procedure AdjustPos(X, Y: Integer); overload;
    procedure AdjustPos(X, Y, W, H: Integer); overload;
    procedure SetImgIndex(Lib: TWMImages; Index: Integer); overload;
    procedure SetImgIndex(Lib: TWMImages; Index, X, Y: Integer); overload;

    procedure SetImgName(Lib: TUIBImages; F: string); overload;
    procedure SetImgName(Lib: TUIBImages; F: string; X, Y: Integer); overload;

    property WLib: TWMImages read FWLib write FWLib;
    property ULib: TUIBImages read FULib write FULib;
  published
    property OnRender: TOnRender read FOnRender write FOnRender;
    property OnRenderCompleted: TOnRender read FOnRenderCompleted write FOnRenderCompleted;
    property OnKeyPress: TOnKeyPress read FOnKeyPress write FOnKeyPress;
    property OnKeyDown: TOnKeyDown read FOnKeyDown write FOnKeyDown;
    property OnKeyUp: TOnKeyUp read FOnKeyUp write FOnKeyUp;
    property OnMouseMove: TOnMouseMove read FOnMouseMove write FOnMouseMove;
    property OnMouseDown: TOnMouseDown read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TOnMouseUp read FOnMouseUp write FOnMouseUp;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnInRealArea: TOnInRealArea read FOnInRealArea write FOnInRealArea;
    property OnBackgroundClick: TOnClick read FOnBackgroundClick write FOnBackgroundClick;
    property Caption: string read FCaption write SetCaption;

    property DParent: THGEControl read FDParent write FDParent;
    property Visible: Boolean read FVisible write SetVisible;
    property EnableFocus: Boolean read FEnableFocus write FEnableFocus;
    property FileName: string read FFileName write SetFileName;
    property MaskFileName: string read FMaskFileName write SetMaskFileName;
    property Color;
    property Font;
    property Hint;
    property ShowHint;
    property Align;
    property IsMouseIn: Boolean read FIsMouseIn write FIsMouseIn;
    property Alpha: Byte read FAlpha write SetAlpha default 255;
    property Light: Byte read FLight write SetLight default 255;
    property Taborder;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property OnMouseEnter: TOnMouseEnter read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TOnMouseLeave read FOnMouseLeave write FOnMouseLeave;
    property OnEnter: TOnEnter read FOnEnter write FOnEnter;
    property OnLeave: TOnLeave read FOnLeave write FOnLeave;
    property OnMouseWheel: TOnMouseWheel read FOnMouseWheel write FOnMouseWheel;
    property boAutoChecInRange: Boolean read FAutoCheckInRange write FAutoCheckInRange;
    property RenderOnTop: Boolean read FRenderOnTop write FRenderOnTop;
    property cursor: TCursor read FCursor write SetCursor;
    //property IniKey:string read FIniKey write fIniKey;
    property CParent: THGEControl read FCParent write FCParent;
  end;

  //静态文本输出控件，适合内容变化比较频繁的地方，如果内容基本固定，则用THGELabel
  THGEStaticText = class(THGEControl)
  private
    FFont: TSysFont;
    FNeedUpdate: Boolean;
    procedure SetCaption(Value: string);
    procedure Update;
    procedure FontChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoRender; override;
  published
    property Caption: string read FCaption write SetCaption;
    property Text: string read FCaption write SetCaption;
    property AutoSize;
  end;

  TTextLayout = (tlTop, tlCenter, tlBottom);
  THGELabel = class(THGEControl)
  private
    FCaption: string;
    FOnChange: TNotifyEvent;
    FAutoSize: Boolean;
    FLayout: TTextLayout;
    FWordWrap: Boolean;
    FWideBrush: Byte;
    FAlignment: TAlignment;
    FTransparent: Boolean;
    FOnAfterDraw: TOnAfterDraw;
    FPasswordChr: Char;
    FStress: Boolean;
    FStressColor: TColor;
    FStream: TMemoryStream;
    procedure SetPasswordChr(const Value: Char);
    procedure FontChanged(Sender: TObject);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetAutoSize(const Value: Boolean);
    procedure SetLayout(const Value: TTextLayout);
    procedure SetWordWrap(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
    procedure SetCaption(const Value: string);
    function GetShowingText: string;
    function GetSpr: IHGESprite;
    procedure SetStress(const Value: Boolean);
    procedure SetStressColor(const Value: TColor);
  protected
    FNeedRedraw: Boolean;
    procedure AdjustBounds; dynamic;
    procedure DoDrawText(ACanvas: TCanvas; var Rect: TRect; Flags: Longint); dynamic;
  public
    FrameBrushColor: Longint;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReDraw; dynamic;
    procedure DoRender; override;
    procedure LoadFromIni(sec, Key: string); override;
    property ShowingText: string read GetShowingText; //获得显示用的文字
    property Spr: IHGESprite read GetSpr;
  published
    property Caption: string read FCaption write SetCaption;
    property Text: string read FCaption write SetCaption;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property Layout: TTextLayout read FLayout write SetLayout default tlTop;
    property WordWrap: Boolean read FWordWrap write SetWordWrap;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property BorderWidth;
    property Font;
    property OnAfterDraw: TOnAfterDraw read FOnAfterDraw write FOnAfterDraw;
    property PasswordChr: Char read FPasswordChr write SetPasswordChr default #0;
    property Stress: Boolean read FStress write SetStress;
    property StressColor: TColor read FStressColor write SetStressColor;
    property WideBrush: Byte read FWideBrush write FWideBrush;
  end;

  //按钮控件
  THGEButton = class(THGEControl)
  private
{$IFDEF DEBUGUI}
    SpotX: Integer;
    SpotY: Integer;
{$ENDIF}
    FPageActive: Boolean;
    FMouseState: TMouseState;           // = (tmNone, tmDown, tmUp, tmMove, tmDisable);
    FClickInv: LongWord;
    FClickSound: TClickSound;
    FOnClickSound: TOnClickSound;
    FCancel: Boolean;
    FDefault: Boolean;
    FAllowAllUp: Boolean;
    FDowned: Boolean;
    FNeedUpdate: Boolean;
    FFlashed: Boolean;                  //是否支持闪烁
    FFlashTick: DWORD;                  //最后一次闪烁时间
    FFlashInterval: Integer;            //闪烁间隔
    FFlashState: Byte;                  //闪烁的第几帧
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure SetDowned(const Value: Boolean);
  protected
    function KeyPress(var Key: Char): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DoRender; override;
    procedure SetTexture(const Tex: ITexture); override;
    property FlashState: Byte read FFlashState;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
    property Cancel: Boolean read FCancel write FCancel;
    property Default: Boolean read FDefault write FDefault;
    property AllowAllUp: Boolean read FAllowAllUp write FAllowAllUp;
    property Downed: Boolean read FDowned write SetDowned;
    property MouseState: TMouseState read FMouseState write FMouseState;
    property Flashed: Boolean read FFlashed write FFlashed;
    property PageActive: Boolean read FPageActive write FPageActive;
    property FlashInterval: Integer read FFlashInterval write FFlashInterval;
  end;

  THGECheckBox = class(THGEButton)
  private
    FChecked: Boolean;
    procedure SetChecked(const Value: Boolean);
  protected
    procedure SetTexture(const Tex: ITexture); override;
  published
    property Checked: Boolean read FChecked write SetChecked;
    property Enabled: Boolean read FEnabled write SetEnabled;
  end;

  THGERadioButton = class(THGECheckBox)
  private
    procedure SetChecked(const Value: Boolean);
  published
    property Checked: Boolean read FChecked write SetChecked;
  end;

  //表格控件
  THGEGridCell = record
    Disabled: Boolean;
    Checked: Boolean;
  end;

  THGEGrid = class(THGEControl)
  private
    FColCount, FRowCount: Integer;
    FColWidth, FRowHeight: Integer;
    FViewTopLine: Integer;
    SelectCell: TPoint;
    MouseCell: TPoint;
    MouseDownCell: TPoint;
    DownPos: TPoint;
    FOnGridSelect: TOnGridSelect;
    FOnGridMouseMove: TOnGridSelect;
    FCellFileName: string;
    FNormCellSpr: IHGESprite;
    FHighlightCellSpr: IHGESprite;
    FDownCellSpr: IHGESprite;
    FDisableCellSpr: IHGESprite;
    FCells: array of THGEGridCell;
    FCellTex: ITexture;
    FOnGridRender: TOnGridRender;
    function GetColRow(X, Y: Integer; var ACol, ARow: Integer): Boolean;
    procedure SetCellFileName(const Value: string);
    procedure SetColCount(const Value: Integer);
    procedure SetRowCount(const Value: Integer);
    function GetCellChecked(Row, Col: Integer): Boolean;
    procedure SetCellChecked(Row, Col: Integer; const Value: Boolean);
    function GetCellDisabled(Row, Col: Integer): Boolean;
    procedure SetCellDisabled(Row, Col: Integer; const Value: Boolean);
    procedure MouseLeave; override;
  public
    CX, CY: Integer;
    Col, Row: Integer;
    dx, dy: Double;
    SelButton: TMouseButton;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function DblClick(X, Y: Integer): Boolean; override;
    function Click(X, Y: Integer): Boolean; override;
    procedure DoRender; override;
    procedure LoadFromIni(sec, Key: string); override;
    property CellChecked[Row, Col: Integer]: Boolean read GetCellChecked write SetCellChecked;
    property CellDisabled[Row, Col: Integer]: Boolean read GetCellDisabled write SetCellDisabled;
  published
    property ColCount: Integer read FColCount write SetColCount;
    property RowCount: Integer read FRowCount write SetRowCount;
    property ColWidth: Integer read FColWidth write FColWidth;
    property RowHeight: Integer read FRowHeight write FRowHeight;
    property ViewTopLine: Integer read FViewTopLine write FViewTopLine;
    property OnGridSelect: TOnGridSelect read FOnGridSelect write FOnGridSelect;
    property OnGridMouseMove: TOnGridSelect read FOnGridMouseMove write FOnGridMouseMove;
    property CellFileName: string read FCellFileName write SetCellFileName;
    property OnGridRender: TOnGridRender read FOnGridRender write FOnGridRender;
  end;

  //窗口控件
  THGEWindow = class(THGEButton)
  private
    FFloating: Boolean;
    FTextureMode: TTextureMode;
    FOnShow: TOnWindowShow;
    FLastModalWindow: THGEControl;
    procedure SetTextureMode(const Value: TTextureMode);
  protected
    procedure SetVisible(flag: Boolean);
    function KeyPress(var Key: Char): Boolean; override;
    procedure SetTexture(const Tex: ITexture); override;
  public
    SpotX, SpotY: Integer;
    DialogResult: TModalResult;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Show;
    procedure Hide;
    function ShowModal: Integer;
    procedure LoadFromIni(sec, Key: string); override;
    property TextureMode: TTextureMode read FTextureMode write SetTextureMode;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Floating: Boolean read FFloating write FFloating;
    property OnShow: TOnWindowShow read FOnShow write FOnShow;
  end;

  TScrollCode = (scLineUp, scLineDown, scPageUp, scPageDown, scPosition, scTrack, scTop, scBottom, scEndScroll);
  TScrollEvent = procedure(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer) of object;

  THGEScrollbar = class(THGEButton)     //滚动条
  private
    FPrevBtn: THGEButton;
    FNextBtn: THGEButton;
    FBar: THGEButton;
    FMinValue: Integer;
    FMaxValue: Integer;
    FPosition: Integer;
    SpotX, SpotY: Integer;
    FKind: TScrollBarKind;
    FPageSize: Integer;
    FOnScroll: TScrollEvent;
    FSmallChange: TScrollBarInc;
    boBarMouseMove: Boolean;
    FPreHint: string;
    FNextHint: string;
    FBarHint: string;
    FPrevNextMouseDownState: Integer;
    FPrevNextMouseDownTick: DWORD;
    FPrevNextAutoClickTick: DWORD;
    procedure SetBarFileName(const Value: string);
    procedure OnPrevBtnClick(Sender: TObject; X, Y: Integer);
    procedure OnPrevMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnNextMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnPrevMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnNextMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnNextBtnClick(Sender: TObject; X, Y: Integer);
    procedure OnBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnBarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SetNextBtnFileName(const Value: string);
    procedure SetPrevBtnFileName(const Value: string);
    procedure AdjuestBarpos;
    procedure SetMaxValue(const Value: Integer);
    procedure SetMinValue(const Value: Integer);
    procedure SetPosition(const Value: Integer);
    procedure SetKind(const Value: TScrollBarKind);
    procedure SetPageSize(const Value: Integer);
    function GetBarFileName: string;
    function GetNextBtnFileName: string;
    function GetPrevBtnFileName: string;
    procedure SetFileName(Value: string);
    procedure SetNextHint(const Value: string);
    procedure SetPreHint(const Value: string);
    procedure SetBarHint(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoRender; override;
    procedure Loaded; override;
    procedure LoadFromIni(sec, Key: string); override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean; override;

    property PrevBtn: THGEButton read FPrevBtn;
    property NextBtn: THGEButton read FNextBtn;
    property Bar: THGEButton read FBar;
  published
    property PrevBtnFilename: string read GetPrevBtnFileName write SetPrevBtnFileName;
    property NextBtnFilename: string read GetNextBtnFileName write SetNextBtnFileName;
    property BarFileName: string read GetBarFileName write SetBarFileName;
    property MaxValue: Integer read FMaxValue write SetMaxValue default 100;
    property MinValue: Integer read FMinValue write SetMinValue;
    property Position: Integer read FPosition write SetPosition;
    property Kind: TScrollBarKind read FKind write SetKind;
    property PageSize: Integer read FPageSize write SetPageSize default 2;
    property OnScroll: TScrollEvent read FOnScroll write FOnScroll;
    property SmallChange: TScrollBarInc read FSmallChange write FSmallChange default 1;
    property FileName: string read FFileName write SetFileName;
    property PreHint: string read FPreHint write SetPreHint;
    property NextHint: string read FNextHint write SetNextHint;
    property BarHint: string read FBarHint write SetBarHint;
  end;

  pTMenuItem = ^TMenuItem;
  TMenuItemClicked = procedure(Sender: TObject; Menu: pTMenuItem) of object;
  TMenuItem = record
    ID: Integer;                        //可以由调用者指定（但必须是未被占用的），如果被占用，则由程序自动指定一个
    sText: string;
    Enabled: Boolean;
    Checked: Boolean;
    Proc: TMenuItemClicked;
    SubMenu: pTMenuItem;
  end;

  THGEMenu = class(THGEControl)
  private
    FNeedRedraw: Boolean;
    FSelectedIdx: Integer;
    FMenuItems: array of TMenuItem;
    FParentMenu: THGEMenu;
    FSubMenu: THGEMenu;
    FParentHeight: Integer;             //用来调整显示位置，优先显示在当前位置的下方，如果显示不下，则显示在当前位置+FParentheight的上方
    FParentWidth: Integer;              //用来调整显示位置，优先显示在当前位置(X+FParentWidth,Y)处（右边），否则显示在右边界不超过X处(左边)
    FMinWidth, FMaxWidth: Integer;
    FSelectItemTop: Integer;
    function GetItemEnables(Index: Integer): Boolean;
    procedure setItemEnables(Index: Integer; const Value: Boolean);
    function GetItemChecked(Index: Integer): Boolean;
    procedure SetItemChecked(Index: Integer; const Value: Boolean);
    procedure SetMaxWidth(const Value: Integer);
    procedure SetMinWidth(const Value: Integer);
    function getCount: Integer;
    function GetMenuItems(Index: Integer): pTMenuItem;
    procedure SetVisible(const Value: Boolean);
  protected
    function KeyPress(var Key: Char): Boolean; override;
    function KeyDown(var Key: word; Shift: TShiftState): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Render; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReDraw;
    function AddItem(Item: pTMenuItem): Integer;
    function DeleteItem(Idx: Integer): Integer; overload;
    function DeleteItem(sText: string): Integer; overload;
    procedure Popup(X, Y: Integer; AParentHeight: Integer = 0);
    procedure Clear;
    property ItemChecked[Index: Integer]: Boolean read GetItemChecked write SetItemChecked;
    property ItemEnables[Index: Integer]: Boolean read GetItemEnables write setItemEnables;
    property MinWidth: Integer read FMinWidth write SetMinWidth;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth;
    property Count: Integer read getCount;
    property MenuItems[Index: Integer]: pTMenuItem read GetMenuItems;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  THGEEdit = class(THGELabel)
  private
    FIsHotKey: Boolean;
    FHotKey: Cardinal;
    FStartTextX: Integer;
    FImeChar: Boolean;
    FMaxLength: Integer;
    FCertPos: Integer;                  //插入点字符位置（在哪个字符后面）
    FCertLine: Integer;                 //插入点所在行
    FBlink: Boolean;
    FBlinkTick: DWORD;                  //上次闪动状态改变的时间
    FCursorColor: Longint;
    FCertTop: Integer;
    FSelStart, FSelEnd: Integer;
    FWantReturns: Boolean;
    FWantTabs: Boolean;
    FNumberOnly: Boolean;
    FPopMenu: THGEMenu;
    FOnHotKeyChange: TMHotKeyEvent;
    procedure SetMaxLength(const Value: Integer);
    procedure AfterDraw(Bmp: TBitmap);
    procedure SetBlink(Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure CalcCertDrawPos;
    procedure SetCertPos(const Value: Integer);
    procedure SetSelEnd(const Value: Integer);
    procedure SetSelStart(const Value: Integer);
    function GetSelLength: Integer;
    procedure SetSelLength(Value: Integer);
    function GetSelText: string;
    function GetCharPosByPixel(X: Integer): Integer;
    procedure SetHotKey(Value: Cardinal);
    procedure SetOfHotKey(HotKey: Cardinal);

    procedure InitPopMenu;
    procedure PopMenuCopy(Sender: TObject; Menu: pTMenuItem);
    procedure PopMenuCut(Sender: TObject; Menu: pTMenuItem);
    procedure PopMenuDel(Sender: TObject; Menu: pTMenuItem);
    procedure PopMenuPast(Sender: TObject; Menu: pTMenuItem);
    procedure PopMenuSelectAll(Sender: TObject; Menu: pTMenuItem);
    procedure DoDrawText(ACanvas: TCanvas; var Rect: TRect; Flags: Longint); override;
  protected
    function KeyPress(var Key: Char): Boolean; override;
    function KeyDown(var Key: word; Shift: TShiftState): Boolean; override;
    procedure Render; override;
    procedure ReDraw;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  public
    DefText: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromIni(sec, Key: string); override;
    property CertPos: Integer read FCertPos write SetCertPos;
    property SelStart: Integer read FSelStart write SetSelStart;
    property SelEnd: Integer read FSelEnd write SetSelEnd;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelText: string read GetSelText;
    property NumberOnly: Boolean read FNumberOnly write FNumberOnly;
    property CursorColor: Longint read FCursorColor write FCursorColor;
    property IsHotKey: Boolean read FIsHotKey write FIsHotKey;
    property HotKey: Cardinal read FHotKey write SetHotKey;
    property Text: string read FCaption write SetCaption;
  published
    property Caption: string read FCaption write SetCaption;
    property OnHotKeyChange: TMHotKeyEvent read FOnHotKeyChange write FOnHotKeyChange;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property Font;
  end;

  THGEMemo = class(THGEControl)         //多行文本输入框
  private
    FMakeMultiLines: Boolean;
    FScrollbar: THGEScrollbar;
    FLines: TStringList;
    FHardReturn: array of Boolean;
    FText: {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF};
    FImeStr: string;
    FCertPos: Integer;                  //插入点字符位置（在哪个字符后面）
    FCertRow, FCertCol: Integer;        //插入点所在位置X,Y（所在行的上部）
    FBlink: Boolean;
    FBlinkTick: DWORD;                  //上次闪动状态改变的时间
    FSelStart, FSelEnd: Integer;        //
    FWantReturns: Boolean;
    FWantTable: Boolean;
    FShowX: Integer;                    //左上角是第几行第几列 (单行是第几个字符，多行是第几行)
    FOnChange: TNotifyEvent;
    FMaxLength: Integer;
    FPasswordChr: Char;
    FReadOnly: Boolean;
    FSelMaskStart: TPoint;
    FSelMaskEnd: TPoint;
    FNeedRedraw: Boolean;
    FPopMenu: THGEMenu;
    FCursorColor: DWORD;
    FNumberOnly: Boolean;               //仅接受数字和.-
    FStream: TMemoryStream;
    procedure SetScrollbar(const Value: THGEScrollbar);
    procedure SetWantReturns(const Value: Boolean);
    procedure SetWantTable(const Value: Boolean);
    procedure SetText(const Value: {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF});
    procedure SetShowX(const Value: Integer); //左边显示的开始字符（当前行）
    procedure SetCertPos(const Value: Integer); //最上面一行的行号
    procedure SetSelEnd(const Value: Integer);
    procedure SetSelStart(const Value: Integer);
    function GetSelLength: Integer;
    function GetSelText: string;
    procedure SetSelText(const Value: string);
    procedure SetMaxLength(const Value: Integer);
    procedure FontChanged(Sender: TObject);
    procedure SetBlink(const Value: Boolean);
    function GetShowingText: {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF};
    procedure SetPasswordChr(const Value: Char);
    procedure MakeMultiLines;           //分解为多行
    function GetCharPosByPixel(X, Y: Integer): Integer;
    procedure SetCertCol(const Value: Integer);
    procedure SetCertRow(const Value: Integer);
    procedure PopMenuCopy(Sender: TObject; Menu: pTMenuItem);
    procedure PopMenuCut(Sender: TObject; Menu: pTMenuItem);
    procedure PopMenuDel(Sender: TObject; Menu: pTMenuItem);
    procedure PopMenuPast(Sender: TObject; Menu: pTMenuItem);
    procedure PopMenuSelectAll(Sender: TObject; Menu: pTMenuItem);
    procedure InitPopMenu;
    procedure OnScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    property ShowX: Integer read FShowX write SetShowX;
  protected
    function KeyPress(var Key: Char): Boolean; override;
    function KeyDown(var Key: word; Shift: TShiftState): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure ReDraw;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Render; override;
    procedure LoadFromIni(sec, Key: string); override;
    procedure Update;

    property Text: {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF} read FText write SetText;
    property SelStart: Integer read FSelStart write SetSelStart;
    property SelEnd: Integer read FSelEnd write SetSelEnd;
    property SelLength: Integer read GetSelLength;
    property SelText: string read GetSelText write SetSelText;
    property Blink: Boolean read FBlink write SetBlink;
    property CertPos: Integer read FCertPos write SetCertPos;
    property CertRow: Integer read FCertRow write SetCertRow;
    property CertCol: Integer read FCertCol write SetCertCol;
    property Lines: TStringList read FLines write FLines;
  published
    property BorderWidth;
    property Scrollbar: THGEScrollbar read FScrollbar write SetScrollbar;
    property WantReturns: Boolean read FWantReturns write SetWantReturns;
    property WantTable: Boolean read FWantTable write SetWantTable;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property MaxLength: Integer read FMaxLength write SetMaxLength;
    property PasswordChr: Char read FPasswordChr write SetPasswordChr;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property NumberOnly: Boolean read FNumberOnly write FNumberOnly;
  end;

  //聊天信息显示控件
  pTChatMsgItem = ^TChatMsgItem;
  TChatMsgItem = record
    sText: string;                      //内容
    FColor: TColor;                     //文字颜色
    BColor: TColor;                     //文字颜色
    FCommand: Byte;                     //关联命令
    FCommandStr: string;                //关联命令
    OffsetX: Integer;                   //开始位置X偏移，如果=0，表示需要换行
    btLineFlag: Byte;                   //0-本行未结束，1-换行，2-原始信息一行结束
    FSpr: IHGESprite;
    Height: Integer;
    sHint: string;                      //鼠标提示信息
    btFiltFlag: Byte;                   //过滤标记，用于只显示特定标记的数据。
  end;

  TSayCmdClick = procedure(Sender: TObject; Cmd: Byte; CmdStr: string; Button: TMouseButton; Shift: TShiftState) of object;

  THGERichEdit = class(THGEControl)
  private
    FShowType: Byte;
    FReDrawbar: Boolean;
    FScrollbar: THGEScrollbar;
    FOnChange: TNotifyEvent;
    FNeedRedraw: Boolean;
    FItems: TGList;
    FTopIndex: Integer;
    FNewLine: Boolean;
    FOnCommand: TSayCmdClick;
    FAutoSize: Boolean;
    FVisibleLines: Integer;
    FMouseDownItem: pTChatMsgItem;
    FMouseInItem: pTChatMsgItem;
    FFilter: Byte;
    FLabel: THGELabel;
    procedure SetScrollbar(const Value: THGEScrollbar);

    procedure OnScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure SetTopIndex(const Value: Integer);
    function getCount: Integer;
    procedure SetAutoSize(const Value: Boolean);
    procedure SetFilter(const Value: Byte);
    procedure SetVisibleLines(const Value: Integer);
  protected
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean; override;
    function GetItemAtPos(X, Y: Integer): pTChatMsgItem;
    procedure MouseLeave; override;
    procedure MouseEnter; override;
{$IFDEF DARK}
    procedure Dark(bFlag: Boolean); override;
{$ENDIF}
    function KeyDown(var Key: word; Shift: TShiftState): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoRender; override;

    procedure ReDraw;
    procedure Clear;
    function AddItem(Item: pTChatMsgItem; var ItemWidth: Integer): Integer;
    procedure DelItem(Idx: Integer);
    procedure AddLine(var OffsetX: Integer; str: string; FColor, BColor: Integer; CmdType: Byte; CmdStr: string; btfilter: Byte = $FF; ParserCmd: Boolean = True);
    procedure LoadFromIni(sec, Key: string); override;
    property TopIndex: Integer read FTopIndex write SetTopIndex;
    property Count: Integer read getCount;
    property MouseInItem: pTChatMsgItem read FMouseInItem write FMouseInItem;
    property Filter: Byte read FFilter write SetFilter;
    property NeedRedraw: Boolean read FNeedRedraw write FNeedRedraw;
    property ShowType: Byte read FShowType write FShowType;
    property ReDrawbar: Boolean read FReDrawbar write FReDrawbar;
    property MouseDownItem: pTChatMsgItem read FMouseDownItem write FMouseDownItem;

    property Items: TGList read FItems;
  published
    property Scrollbar: THGEScrollbar read FScrollbar write SetScrollbar;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnCommand: TSayCmdClick read FOnCommand write FOnCommand;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property VisibleLines: Integer read FVisibleLines write SetVisibleLines;
  end;

  THGEWebBrowser = class(THGEControl)
  private
    WebBrowser: TCWebBrowser;
    boNeedUpdate: Boolean;
    Bmp: TBitmap;
    FURL: string;
    FRenderFrames: Integer;
    procedure SetURL(const Value: string);
    function GetTransparent: Boolean;
    function GetTransparentColor: TColor;
    procedure SetTransparent(const Value: Boolean);
    procedure SetTransparentCOlor(const Value: TColor);
  protected
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Update: Boolean;
    procedure DoRender; override;
    procedure Resize; override;
    procedure LoadFromIni(sec, Key: string); override;
  published
    property url: string read FURL write SetURL;
    property Transparent: Boolean read GetTransparent write SetTransparent;
    property TransparentColor: TColor read GetTransparentColor write SetTransparentCOlor;
  end;

  PTLVColumn = ^TLVColumn;
  TLVColumn = record
    Alignment: TAlignment;
    Width: Integer;
  end;
  TLVFont = record
    FontName: string;
    FontSize: Integer;
    NormalColor: TColor;
    SelectColor: TColor;
    SelectBackColor: TColor;
    HighlightColor: TColor;
    HighlightBackColor: TColor;
    DisableColor: TColor;
    DisableBackColor: TColor;
  end;

  pTHGEListViewItem = ^THGEListViewItem;
  THGEListViewItem = record
    Enabled: Boolean;
    Checked: Boolean;
    data: array of string;
    Image: array of IHGESprite;
    PData: Pointer;
    sHint: string;
  end;

  TLVColumns = array of TLVColumn;
  THGEListView = class(THGEControl)     //ListView控件
  private
    FOnChanging: TNotifyEvent;
    FScrollbar: THGEScrollbar;
    FMultiSelect: Boolean;
    FItems: TList;
    FColumns: TLVColumns;
    FMouseItemIndex: Integer;           //鼠标指向的行号
    FItemIndex: Integer;                //当前选择的行号
    FItemHeight: Integer;               //每一行的高度
    FItemFont: TLVFont;
    FOnChange: TNotifyEvent;
    FTopIndex: Integer;
    FBoxTex: ITexture;
    FShowCount: Integer;
    FLabel: THGELabel;
    FDrawUp: Boolean;
    function GetItem(Row, Col: Integer): string;
    procedure SetItem(Row, Col: Integer; const Value: string);
    procedure SetItemIndex(const Value: Integer);
    function GetItemChecked(Index: Integer): Boolean;
    function GetItemEnabled(Index: Integer): Boolean;
    procedure SetItemChecked(Index: Integer; const Value: Boolean);
    procedure SetItemEnabled(Index: Integer; const Value: Boolean);
    procedure SetScrollbar(const Value: THGEScrollbar);
    procedure OnScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    function GetItemCount: Integer;
    procedure SetTopIndex(const Value: Integer);
    function GetItemData(Index: Integer): Pointer;
    procedure SetItemData(Index: Integer; const Value: Pointer);
    function GetColumns(Index: Integer): PTLVColumn;
    procedure SetColumns(Index: Integer; const Value: PTLVColumn);
    procedure SetShowCount(const Value: Integer);
  protected
    procedure ReDraw(Row, Col: Integer);
    function KeyDown(var Key: word; Shift: TShiftState): Boolean; override;
    function KeyUp(var Key: word; Shift: TShiftState): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean; override;
    procedure SetItemFont(const Value: TLVFont);
    procedure SetItemHeight(const Value: Integer);
    procedure SetMultiSelect(const Value: Boolean);
  public
    BoxPos1, BoxPos2: TPoint;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddColumn(AWidth: Integer; Alignment: TAlignment = taLeftJustify);
    procedure ClearColumns;
    function AddItem(Args: array of string; ItemEnabled: Boolean = True; ItemChecked: Boolean = False; sHint: string = ''; data: Pointer = nil): Integer;
    procedure DelItem(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    procedure Sort(ByIndex: Integer; boNumber: Boolean = True; boUp: Boolean = True);
    procedure ItemMove(CurIndex, NewIndex: Integer);
    procedure Clear;
    procedure DoRender; override;
    procedure LoadFromIni(sec, Key: string); override;
    property Columns[Index: Integer]: PTLVColumn read GetColumns write SetColumns;
    property Items[Row: Integer; Col: Integer]: string read GetItem write SetItem;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property ItemEnabled[Index: Integer]: Boolean read GetItemEnabled write SetItemEnabled;
    property ItemChecked[Index: Integer]: Boolean read GetItemChecked write SetItemChecked;
    property ItemCount: Integer read GetItemCount;
    property ItemData[Index: Integer]: Pointer read GetItemData write SetItemData;
    property TopIndex: Integer read FTopIndex write SetTopIndex;
    property MouseItemIndex: Integer read FMouseItemIndex;
    property BoxTex: ITexture read FBoxTex write FBoxTex;
    property IList: TList read FItems;
    property IColumns: TLVColumns read FColumns;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
    property DrawUp: Boolean read FDrawUp write FDrawUp;
  published
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property ItemFont: TLVFont read FItemFont write SetItemFont;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Scrollbar: THGEScrollbar read FScrollbar write SetScrollbar;
    property ShowCount: Integer read FShowCount write SetShowCount;
  end;

  //下拉列表
  THGEDropdownList = class(THGEControl)
  private
    FOnChanging: TNotifyEvent;
    FDropList: THGEListView;
    FLabel: THGELabel;
    FButton: THGEButton;
    FItemIndex: Integer;
    FFocused: Boolean;
    FOnChanged: TOnChanged;
    procedure SetItemIndex(const Value: Integer);
    procedure OnButtonClick(Sender: TObject; X, Y: Integer);
    procedure OnDropListClick(Sender: TObject; X, Y: Integer);
    procedure OnDropListChanging(Sender: TObject);
    function GetItemEnabled(Index: Integer): Boolean;
    procedure SetItemEnabled(Index: Integer; const Value: Boolean);
    procedure SetFocused(const Value: Boolean);
    function GetItem(Index: Integer): string;
    function GetObject(Index: Integer): Pointer;
    procedure SetItem(Index: Integer; const Value: string);
  protected
    function KeyDown(var Key: word; Shift: TShiftState): Boolean; override;
    function KeyUp(var Key: word; Shift: TShiftState): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoRender; override;
    procedure DelItem(Index: Integer);
    procedure Clear;
    procedure Resize; override;
    procedure AddItem(s: string); overload;
    procedure AddItem(s: string; data: Pointer); overload;
    procedure AddItem(s: string; data: Pointer; Hint: string); overload;

    procedure LoadFromIni(sec, Key: string); override;
    function Indexof(s: string): Integer;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property ItemEnabled[Index: Integer]: Boolean read GetItemEnabled write SetItemEnabled;
    property Focused: Boolean read FFocused write SetFocused;
    property Items[Index: Integer]: string read GetItem write SetItem;
    property Objects[Index: Integer]: Pointer read GetObject;
    property ShowLabel: THGELabel read FLabel;
    property DropList: THGEListView read FDropList;
  published
    property OnChanged: TOnChanged read FOnChanged write FOnChanged;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
  end;

  TButtonSpr = record
    Spr: array[0..4] of IHGESprite;
    Enabled: Boolean;
    Downed: Boolean;
  end;
  THGEDropdowPictureList = class(THGEControl)
  private
    FItemIndex: Integer;
    FFocused: Boolean;
    FDropDown: Boolean;
    FItemCount: Integer;
    FState: Integer;
    FMouseInIndex: Integer;
    FButtonSprs: array of TButtonSpr;
    FOnChanged: TOnChanged;
    function GetItemEnabled(Index: Integer): Boolean;
    procedure SetFocused(const Value: Boolean);
    procedure SetItemEnabled(Index: Integer; const Value: Boolean);
    procedure SetItemIndex(const Value: Integer);
    procedure SetTexture(const Tex: ITexture); override;
  protected
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoRender; override;
    procedure LoadFromIni(sec, Key: string); override;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property ItemEnabled[Index: Integer]: Boolean read GetItemEnabled write SetItemEnabled;
    property Focused: Boolean read FFocused write SetFocused;
    property ItemCount: Integer read FItemCount write FItemCount;
  published
    property OnChanged: TOnChanged read FOnChanged write FOnChanged;
  end;

  THGEListBox = class(THGEControl)
  private
    FItems: TStrings;
    FItemIndex: Integer;
    FItemHeight: Integer;
    FTopIndex: Integer;
    FStream: TMemoryStream;
    procedure SetItems(const Value: TStrings);
    procedure SetItemIndex(const Value: Integer);
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure ReDraw;
    procedure FontChanged(Sender: TObject);
    procedure SetTopIndex(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Render; override;
  published
    property Items: TStrings read FItems write SetItems;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property TopIndex: Integer read FTopIndex write SetTopIndex;
  end;

  ADWORD = array[0..1] of DWORD;
  PADWORD = ^ADWORD;

  THGEFlashPlayer = class(THGEControl)
  private
    m_pFlashPlayer: TFlashPlayer;
    m_FlashQuad: THGEQuad;
    m_Quality: Byte;
    FNeedUpdate: Boolean;
    function GetCurrentFrame: Integer;
    function GetPlaying: Boolean;
    function GetQuality: Byte;
    function GetTotalFrames: Integer;
    procedure SetCurrentFrame(const Value: Integer);
    procedure SetLoop(const Value: Boolean);
    procedure SetPlaying(const Value: Boolean);
    procedure SetQuality(const Value: Byte);
    function GetLoop: Boolean;
    procedure SetFileName(FileName: string);
    function GetTransparent: Boolean;
    procedure SetTransparent(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    function LoadFromStream(Src: TStream): Boolean;
    procedure SetLight(Value: Byte);
  protected
    procedure ExtractedAlpha;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function KeyDown(var Key: word; Shift: TShiftState): Boolean; override;
    function KeyUp(var Key: word; Shift: TShiftState): Boolean; override;
    function KeyPress(var Key: Char): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function LoadFlash: Boolean;
    procedure Pause();
    procedure Resume();
    procedure Back();
    procedure Rewind();
    procedure forward();
    function Update(): Boolean;
    procedure DoRender; override;
    procedure Render; override;
{$IFDEF DARK}
    procedure Dark(boFlag: Boolean); override;
{$ENDIF}
    procedure LoadFromIni(sec, Key: string); override;
    function InitFlashPlayer: Boolean;
    class function GetFlashVersion(): Double;
    property CurrentFrame: Integer read GetCurrentFrame write SetCurrentFrame;
    property TotalFrames: Integer read GetTotalFrames;
    property Playing: Boolean read GetPlaying write SetPlaying;
    property Transparent: Boolean read GetTransparent write SetTransparent;
  published
    property Loop: Boolean read GetLoop write SetLoop;
    property Quality: Byte read GetQuality write SetQuality;
    property FileName: string read FFileName write SetFileName;
    property Visible: Boolean read FVisible write SetVisible;
    property Light: Byte read FLight write SetLight;
  end;

  THGECombBox = class(THGEControl)

  end;

  TOnSnapshot = procedure(Sender: TObject; FileName: string) of object;

  //控件管理器
  THGEWinManager = class(TControl {TComponent})
  private
    FHGE: IHGE;
    FMX, FMY: Integer;
    FHintLabel: THGELabel;
    FHintShow: Boolean;
    FOnHint: TOnHint;
    FShowHintTick: DWORD;
    FHintDelay: DWORD;
    FHintHidePause: DWORD;
    FHintPause: DWORD;

    FOnKeyUp: TOnKeyUp;
    FOnKeyDown: TOnKeyDown;
    FOnKeyPress: TOnKeyPress;

    FOnMouseMoveRet: TOnMouseMoveRet;
    FOnMouseDownRet: TOnMouseDownRet;
    FOnMouseUpRet: TOnMouseUpRet;
    FOnMouseWheelRet: TOnMouseWheelRet;

    FOnMouseMove: TOnMouseMoveRet;
    //FOnMouseDown: TOnMouseDownRet;
    //FOnMouseUp: TOnMouseUpRet;
    //FOnMouseWheel: TOnMouseWheelRet;

    FSysFont: TSysFont;
    FOnRenderTop: TOnRender;
    FCursorList: PCursorRec;
    FCursor: IHGEAnimation;
    FCursorIndex: TCursor;
    FOnProcessLast: TNotifyEvent;
    FHintBackTex: ITexture;
    FHintBackPoint1, FHintBackPoint2: TPoint;
    FOnSnapshot: TOnSnapshot;
    procedure SetHintBackTex(const Value: ITexture);
  public
    DWinList: TList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddDControl(dcon: THGEControl; Visible: Boolean);
    procedure DelDControl(dcon: THGEControl);
    procedure ClearAll;
    procedure WindowMsgProce(Window: HWnd; Msg: UINT; wParam: wParam; lParam: lParam);
    function KeyPress(var Key: Char): Boolean;
    function KeyDown(var Key: word; Shift: TShiftState): Boolean;
    function KeyUp(var Key: word; Shift: TShiftState): Boolean;

    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseDoubleClick(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;

    function DblClick(X, Y: Integer): Boolean;
    function Click(X, Y: Integer): Boolean;
    procedure Render;
    procedure RenderTop;
    procedure SetCursor(cursor: TCursor);
    procedure LoadCursorFromIni(sec: string);
    function ProcessMouse: Boolean;
    procedure FlushHint(Sender: THGEControl); //强制刷新提示信息
    function ProcessKey: Boolean;
    function ProcessLast: Boolean;
    property MouseX: Integer read FMX;
    property MouseY: Integer read FMY;
    property HintBackTex: ITexture read FHintBackTex write SetHintBackTex;
    property HintBackPoint1: TPoint read FHintBackPoint1 write FHintBackPoint1;
    property HintBackPoint2: TPoint read FHintBackPoint2 write FHintBackPoint2;
  published
    property OnHint: TOnHint read FOnHint write FOnHint;
    property HintHidePause: DWORD read FHintHidePause write FHintHidePause;
    property HintPause: DWORD read FHintPause write FHintPause;
    property OnKeyPress: TOnKeyPress read FOnKeyPress write FOnKeyPress;
    property OnKeyDown: TOnKeyDown read FOnKeyDown write FOnKeyDown;
    property OnKeyUp: TOnKeyUp read FOnKeyUp write FOnKeyUp;
    property OnRenderTop: TOnRender read FOnRenderTop write FOnRenderTop;
    property OnProcessLast: TNotifyEvent read FOnProcessLast write FOnProcessLast;
    property OnSnapshot: TOnSnapshot read FOnSnapshot write FOnSnapshot;

    property OnMouseMoveRet: TOnMouseMoveRet read FOnMouseMoveRet write FOnMouseMoveRet;
    property OnMouseDownRet: TOnMouseDownRet read FOnMouseDownRet write FOnMouseDownRet;
    property OnMouseUpRet: TOnMouseUpRet read FOnMouseUpRet write FOnMouseUpRet;
    property OnMouseWheelRet: TOnMouseWheelRet read FOnMouseWheelRet write FOnMouseWheelRet;
  end;

  THGEIME = class
  private
    FBmp: TBitmap;
    FPng: TPNGObject;
    m_szImeName: array[0..255] of Char;
    m_pKeyBoardBuffer: TGList;
    m_DefKL: HKL;
    m_pMouseBuffer: TGList;
    m_szCompStr: array[0..1023] of Char;
    m_szCompReadStr: array[0..1023] of Char;
    m_nImeCursor: Integer;
    m_bImeSharp: Boolean;
    m_bImeSymbol: Boolean;
    m_CandList: TGStringList;
    FTex: ITexture;
    FSprImeName: IHGESprite;
    FSprWords: IHGESprite;
    FImmPosX, FImmPosY: Single;         //选字列表显示位置
    FImnPosX, FImnPosY: Single;         //输入法名字显示位置
    FImmPosX2, FImmPosY2, FimmPosH: Single; //临时存储
    FHGE: IHGE;
    FStream: TMemoryStream;
    function onWM_INPUTLANGCHANGEREQUEST: Boolean;
    function OnWM_INPUTLANGCHANGE(HWindow: HWnd; wParam: wParam; lParam: lParam): Boolean;
    function OnWM_IME_SETCONTEXT: Boolean;
    function ONWM_IME_STARTCOMPOSITION: Boolean;
    function OnWM_IME_ENDCOMPOSITION: Boolean;
    function OnWM_IME_NOTIFY(HWindow: HWnd; wParam: word): Boolean;
    function OnWM_IME_COMPOSITION(HWindow: HWnd; lParam: Longint): Boolean;
    function GetKeyBuffer(KeyProcBuffers: PTagKeyBoardBuffer): Boolean;
    function GetMouseBuffer(MouseProcBuffers: PTagMouseBuffer): Boolean;
    procedure ReDraw;
    function GetWordCount: Integer;
  protected
    FNeedRedraw: Boolean;
    function Update(WinMan: THGEWinManager): Boolean;
    procedure Render(WinMan: THGEWinManager);
  public
    constructor Create;
    destructor Destroy; override;
    function Initialize: Boolean;
    function Finalize: Boolean;
    function WindowMsgProce(HWindow: HWnd; Msg: UINT; wParam: wParam; lParam: lParam): Boolean;
    procedure AdjustImmPos(AX, AY, AHeight: Single);
    property NeedRedraw: Boolean read FNeedRedraw;
  end;

  THGEAnimPlayer = class(THGEControl)   //动画类
  private
    FFPS: Single;
    FFrames: Integer;
    FAniWidth, FAniHeight: Integer;
    FAnim: IHGEAnimation;
    FPlaying: Boolean;
    procedure SetAniHeight(const Value: Integer);
    procedure SetAniWidth(const Value: Integer);
    procedure SetFPS(const Value: Single);
    procedure SetFrames(const Value: Integer);
    procedure SetPlaying(const Value: Boolean);
  protected
    procedure SetTexture(const Tex: ITexture); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Render; override;
    procedure LoadFromIni(sec, Key: string); override;
    property Anim: IHGEAnimation read FAnim;
  published
    property FileName: string read FFileName write SetFileName;
    property AniWidth: Integer read FAniWidth write SetAniWidth;
    property AniHeight: Integer read FAniHeight write SetAniHeight;
    property FPS: Single read FFPS write SetFPS;
    property Frames: Integer read FFrames write SetFrames;
    property Playing: Boolean read FPlaying write SetPlaying;
  end;

  THGEWebBrowser2 = class;

  TWebListener = class(TWebViewListener)
  private
    FWebBrowser: THGEWebBrowser2;
  public
    constructor Create(pWeb: THGEWebBrowser2);
    destructor Destroy; override;
    procedure onBeginNavigation(const url: PAnsiChar; const urllen: Integer; const frameName: PWideChar; const frameNamelen: Integer); override;
    procedure onBeginLoading(const url: PAnsiChar; const urllen: Integer; const frameName: PWideChar; const frameNamelen: Integer; statusCode: Integer; const mimeType: PWideChar); override;
    procedure onFinishLoading(); override;
    procedure onCallback(const Name: PAnsiChar; const namelen: Integer; const Args: TJSValueList); override;
    procedure onReceiveTitle(const title: PWideChar; const titlelen: Integer; const frameName: PWideChar; const frameNamelen: Integer); override;
    procedure onChangeTooltip(const tooltip: PWideChar; const tooltiplen: Integer); override;
    procedure onChangeCursor(const cursor: PLongWord); override;
    procedure onChangeKeyboardFocus(isFocused: Boolean); override;
    procedure onChangeTargetURL(const url: PAnsiChar; const urllen: Integer); override;
    function onNavigationAction(const url: PWideChar; const urllen: Integer; const frameName: PWideChar; const frameNamelen: Integer;
      const otype: TWebNavigationType;
      const default_policy: TWebNavigationPolicy;
      const is_redirect: Boolean): TWebNavigationPolicy; override;
    procedure onRunJavaScriptAlert(const sframeName: PWideChar; const frameNamelen: Integer;
      const smessage: PWideChar; const smessagelen: Integer); override;
    function onRunJavaScriptConfirm(const sframeName: PWideChar; const frameNamelen: Integer;
      const smessage: PWideChar; const smessagelen: Integer): Boolean; override;
    function onRunJavaScriptPrompt(const sframeName: PWideChar; const frameNamelen: Integer;
      const smessage: PWideChar; const smessagelen: Integer;
      const default_value: PWideChar; const default_valuelen: Integer;
      const oResult: PWideChar; const len: PInteger): Boolean; override;
    function onRunBeforeUnloadConfirm(const sframeName: PWideChar; const frameNamelen: Integer;
      const smessage: PWideChar; const smessagelen: Integer): Boolean; override;
    procedure onCreateWebView(const sOpenUrl: PChar; const nOpenUrllen: Integer;
      const creatorurl: PChar; const creator_urllen: Integer;
      gesture: Boolean); override;

  end;

  TWcharOrChar = packed record
    boIs: Boolean;
    c: array[False..True] of Char;
    Buffer: array[0..1] of WideChar;
function GetPWChar(): PWideChar;
  end;

  THGEWebBrowser2 = class(THGEControl)
  private
    FInitiated: Boolean;
    FWebBrowser: TCWebView;
    FWebListener: TWebListener;
    WebQuad: THGEQuad;
    FURL: string;
    FOpenURL: Boolean;
    FframeName: WideString;
    Fusername: string;
    Fpassword: string;
    FTransparent: Boolean;
    FenableAsyncRendering: Boolean;
    FmaxAsyncRenderPerSec: Integer;
    FLogLevel: TLogLevel;
    FWcharOrChar: TWcharOrChar;

    FonBeginNavigation: TonBeginNavigation;
    FonBeginLoading: TonBeginLoading;
    FonFinishLoading: TonFinishLoading;
    FonCallback: TonCallback;
    FonReceiveTitle: TonReceiveTitle;
    FonChangeTooltip: TonChangeTooltip;
    FonChangeCursor: TonChangeCursor;
    FonChangeKeyboardFocus: TonChangeKeyboardFocus;
    FonChangeTargetURL: TonChangeTargetURL;
    FonNavigationAction: TonNavigationAction;
    FonRunJavaScriptAlert: TonRunJavaScriptAlert;
    FonRunJavaScriptConfirm: TonRunJavaScriptConfirm;
    FonRunJavaScriptPrompt: TonRunJavaScriptPrompt;
    FonRunBeforeUnloadConfirm: TonRunBeforeUnloadConfirm;
    FonCreateWebView: TonCreateWebView;

    procedure DoChangeURL(Value: string; Reload: Boolean);
    procedure SetURL(const Value: string);
    procedure SetReloadURL(const Value: string);
    procedure SetTransparent(const Value: Boolean);
    procedure SetLight(Value: Byte);
    procedure SetVisible(const Value: Boolean);
  protected
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean; override;
    procedure WindowMsgProce(Window: HWnd; Msg: UINT; wParam: wParam; lParam: lParam); override;
{$IFDEF DARK}
    procedure Dark(boFlag: Boolean); override;
{$ENDIF}
    function InitTexture(): Boolean;
    procedure Loaded(); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExtractedAlpha;
    procedure DoRender; override;
    procedure Resize; override;
    procedure LoadFromIni(sec, Key: string); override;
    procedure SetProperty(Name: PAnsiChar; Value: PAnsiChar); overload;
    procedure SetProperty(Name: PAnsiChar; var Value: Integer); overload;
    procedure SetProperty(Name: PAnsiChar; var Value: Double); overload;
    procedure SetProperty(Name: PAnsiChar; var Value: Boolean); overload;
    procedure SetCallback(Name: PAnsiChar);
    procedure LoadHTML(html: PAnsiChar; frameName: PWideChar);
    procedure LoadFile(sfile: PAnsiChar; frameName: PWideChar);
    procedure GoToHistoryOffset(offset: Integer);
    procedure GetContentAsText(Result: PWideChar; maxChars: Integer);
    procedure Refresh();
    procedure ExecuteJavascript(javascript: PAnsiChar; frameName: PWideChar);
    procedure Cut();
    procedure Copy();
    procedure Paste();
    procedure SelectAll();
    procedure DeselectAll();
    procedure ZoomIn();
    procedure ZoomOut();
    procedure ResetZoom();
    procedure Unfocus();
    procedure Focus();

    function Update: Boolean;
    property Initiated: Boolean read FInitiated write FInitiated;
    property CWebView: TCWebView read FWebBrowser;
  published
    property url: string read FURL write SetURL;
    property ReloadURL: string read FURL write SetReloadURL;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property frameName: WideString read FframeName write FframeName;
    property Username: string read Fusername write Fusername;
    property Password: string read Fpassword write Fpassword;
    property EnableAsyncRendering: Boolean read FenableAsyncRendering write FenableAsyncRendering;
    property MaxAsyncRenderPerSec: Integer read FmaxAsyncRenderPerSec write FmaxAsyncRenderPerSec;
    property LogLevel: TLogLevel read FLogLevel write FLogLevel;
    property Light: Byte read FLight write SetLight;

    property onBeginNavigation: TonBeginNavigation read FonBeginNavigation write FonBeginNavigation;
    property onBeginLoading: TonBeginLoading read FonBeginLoading write FonBeginLoading;
    property onFinishLoading: TonFinishLoading read FonFinishLoading write FonFinishLoading;
    property onCallback: TonCallback read FonCallback write FonCallback;
    property onReceiveTitle: TonReceiveTitle read FonReceiveTitle write FonReceiveTitle;
    property onChangeTooltip: TonChangeTooltip read FonChangeTooltip write FonChangeTooltip;
    property onChangeCursor: TonChangeCursor read FonChangeCursor write FonChangeCursor;
    property onChangeKeyboardFocus: TonChangeKeyboardFocus read FonChangeKeyboardFocus write FonChangeKeyboardFocus;
    property onChangeTargetURL: TonChangeTargetURL read FonChangeTargetURL write FonChangeTargetURL;
    property onNavigationAction: TonNavigationAction read FonNavigationAction write FonNavigationAction;
    property onRunJavaScriptAlert: TonRunJavaScriptAlert read FonRunJavaScriptAlert write FonRunJavaScriptAlert;
    property onRunJavaScriptConfirm: TonRunJavaScriptConfirm read FonRunJavaScriptConfirm write FonRunJavaScriptConfirm;
    property onRunJavaScriptPrompt: TonRunJavaScriptPrompt read FonRunJavaScriptPrompt write FonRunJavaScriptPrompt;
    property onRunBeforeUnloadConfirm: TonRunBeforeUnloadConfirm read FonRunBeforeUnloadConfirm write FonRunBeforeUnloadConfirm;
    property onCreateWebView: TonCreateWebView read FonCreateWebView write FonCreateWebView;

    property Visible: Boolean read FVisible write SetVisible;
  end;

  THGELSAnimPlayer = class(THGEControl)
  private
    FLSAnimPlayer: TLSAnimPlayer;
    FBindex: Integer;
    procedure SetFileName(const Value: string);
    procedure SetVisible(const Value: Boolean);
    function GetFileName(): string;
    function GetLoadHit(): Boolean;
    procedure SetLight(Value: Byte);
    procedure SetAlpha(Value: Byte);
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure LoadFromIni(sec, Key: string); override;
    procedure Play(Bindex: Integer = -1);
    procedure Pause();
    procedure DoRender; override;
  published
    property FileName: string read GetFileName write SetFileName;
    property Visible: Boolean read FVisible write SetVisible;
    property LoadHit: Boolean read GetLoadHit;
    property Light: Byte read FLight write SetLight;
    property Alpha: Byte read FAlpha write SetAlpha;
  end;

  THGENumber = class
  private
    FTexList: array of ITexture;
    FHGE: IHGE;
    function GetTex(Index: Integer): ITexture;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTexture(FileName: string);
    procedure Printf(X, Y, nIdx: Integer; str: string; Width: Integer = 0; nAlignment: ShortInt = 0; boDark: Boolean = False; Alpha: Byte = 255; NumCount: Byte = 12; nDir: ShortInt = 0);
    function TextWidth(nIdx, StrLen: Integer; NumCount: Byte = 12): Integer;
    function TextHeight(nIdx: Integer): Integer;
    property Tex[Index: Integer]: ITexture read GetTex;
  end;

procedure Register;
procedure SetDFocus(dcon: THGEControl);
procedure ReleaseDFocus;
procedure SetDCapture(dcon: THGEControl);
procedure ReleaseDCapture;
procedure RenderBox(Tex: ITexture; P1, P2: TPoint; X, Y, Width, Height: Integer);
procedure LoadPointFromIni(AHGE: IHGE; var P: TPoint; sec, Key: string);
procedure LoadSystemCursorHandle;

var
  MouseCaptureControl       : THGEControl; //mouse message
  MouseInControl            : THGEControl = nil;
  FocusedControl            : THGEControl; //Key message
  NeedFlushHint             : Boolean = False; //如果需要刷新提示，则设置为True
  ModalDWindow              : THGEControl;
  g_WinHGE                  : IHGE = nil;
  g_NameColor               : TColor = clYellow;
  g_TopRenderList           : TList;

function BmpToTexture(Bmp: TBitmap; MaskResource: IResource = nil; MaskSize: DWORD = 0; boTransparent: Boolean = False): ITexture;
function BmpToTextureEx(Bmp: TBitmap; boTransparent: Boolean = False): ITexture;
procedure ShowScrollText(X, Y: Integer; Spr: IHGESprite; MaxShowLen: Integer; var Tick, CurPos: Integer);
procedure Drawbar(FHGE: IHGE; X, Y, W, H: Single; Color: DWORD);

implementation

uses
  Engine, HUtil32, Share, DScreen, WindowUnit;

var
  G_PopMenu                 : THGEMenu = nil;

procedure ShowScrollText(X, Y: Integer; Spr: IHGESprite; MaxShowLen: Integer; var Tick, CurPos: Integer);
var
  I                         : Integer;
begin
  if Spr.GetWidth > MaxShowLen then begin
    g_WinHGE := HGECreate(HGE_VERSION);
    g_WinHGE.Gfx_SetClipping(X, Y, MaxShowLen, Round(Spr.GetHeight));
    Spr.Render(X - CurPos, Y);
    g_WinHGE.Gfx_SetClipping();
    I := GetTickCount - Tick;
    if I >= 10 then begin
      Inc(CurPos, I div 30);
      Tick := GetTickCount;
      if CurPos >= Spr.GetWidth then begin
        CurPos := 0;
        Inc(Tick, 3000);
      end;
    end;
  end else Spr.Render(X, Y);
end;

function BmpToTexture(Bmp: TBitmap; MaskResource: IResource = nil; MaskSize: DWORD = 0; boTransparent: Boolean = False): ITexture;
var
  Stream                    : TMemoryStream;
  //J                         : Integer;
  //data                      : PChar;
  //Res                       : IResource;
  //Size                      : Integer;
  png                       : TPNGObject;
begin
  Result := nil;
  Stream := TMemoryStream.Create;
  try
    if boTransparent then begin
      png := TPNGObject.Create;
      try
        png.Assign(Bmp);
        png.SaveToStream(Stream);
      finally
        png.Free;
      end;
    end else begin
      Bmp.SaveToStream(Stream);
    end;
    Stream.Seek(soFromBeginning, 0);
    //Size := Stream.Size;
    //GetMem(data, Size);
    //Move(Stream.Memory^, data^, Size);
    //Res := TResource.Create(data, Size);
    if MaskResource = nil then
      Result := g_WinHGE.Texture_Load(Stream.Memory, Stream.Size, False)
    else
      Result := g_WinHGE.Texture_Load(Stream.Memory, Stream.Size, MaskResource.Handle, MaskSize, False);
    //Res := nil;
  finally
    Stream.Free;
  end;
end;

function BmpToTextureEx(Bmp: TBitmap; boTransparent: Boolean = False): ITexture;
var
  Stream                    : TMemoryStream;
begin
  Result := nil;
  Stream := TMemoryStream.Create;
  try
    Bmp.SaveToStream(Stream);
    Stream.Seek(soFromBeginning, 0);
    if boTransparent then begin
      Result := g_WinHGE.Texture_Load(Stream.Memory, Stream.Size, False, $FF000000)
    end else begin
      Result := g_WinHGE.Texture_Load(Stream.Memory, Stream.Size, False);
    end;
  finally
    Stream.Free;
  end;
end;

procedure LoadPointFromIni(AHGE: IHGE; var P: TPoint; sec, Key: string);
begin
  P.X := AHGE.Ini_GetInt(sec, Key + '_Left', P.X);
  P.Y := AHGE.Ini_GetInt(sec, Key + '_Top', P.Y);
end;

function Delphi2HGEColor(Color: TColor): DWORD;
begin
  Result := ARGB($FF, GetRValue(Color), GetGValue(Color), GetBValue(Color));
end;

function GetWord(s: string; var P: Integer; boForward: Boolean = True): string;
begin
  Result := '';
  if boForward then begin               //向前找一个字
    if P >= Length(s) then Exit;
    Result := s[P + 1];
    Inc(P);
    if ((ord(s[P]) >= 128) or (s[P] = #$0D)) and (P < Length(s)) then begin
      Result := Result + s[P + 1];
      Inc(P);
    end;
  end else begin                        //向后找一个字
    if P = 0 then Exit;
    Result := s[P];
  end;
end;
//设置当前获得输入焦点的空间

procedure SetDFocus(dcon: THGEControl);
var
  HandleToSet               : HKL;
  I                         : Integer;
begin
  if (FocusedControl <> nil) then begin
    if (FocusedControl is THGEEdit) then begin
      with THGEEdit(FocusedControl) do
        FNeedRedraw := True;
    end;
  end;

  FocusedControl := dcon;
  if (dcon <> nil) and (dcon.FCanInput) then begin
    g_GE.IME.AdjustImmPos(dcon.SurfaceX(dcon.Left) + dcon.FCertDrawPos, dcon.SurfaceY(dcon.Top) + dcon.FCertShowY, dcon.FCertHeight);
    if (dcon is THGEMemo) and (THGEMemo(dcon).PasswordChr <> #0) then begin
      I := 0;
      while g_GE.IME.m_szImeName[0] <> #0 do begin
        ActivateKeyboardLayout(HKL_NEXT, 0);
        Inc(I);
        if I > 20 then Break;           //最多尝试20次
      end;
    end;
    if dcon is THGEEdit then begin
      with THGEEdit(dcon) do begin
        SetBlink(True);
      end;
    end;
  end;
  if (FocusedControl <> nil) and Assigned(FocusedControl.FOnEnter) then begin
    FocusedControl.FOnEnter(FocusedControl);
  end;
end;
//清除

procedure ReleaseDFocus;
begin
  if (FocusedControl <> nil) then begin
    if Assigned(FocusedControl.FOnLeave) then
      FocusedControl.FOnLeave(FocusedControl);
    if (FocusedControl is THGEEdit) then begin
      with THGEEdit(FocusedControl) do begin
        FNeedRedraw := True;
      end;
    end;
  end;
  FocusedControl := nil;
end;
//设置鼠标捕获控件

procedure SetDCapture(dcon: THGEControl);
begin
  if dcon = nil then begin
    ReleaseDFocus;
  end else begin
    SetCapture(g_GE.HGE.System_GetState(HGE.HGE_HWND)); //DXDraw捕获
    MouseCaptureControl := dcon;
  end;
end;
//释放鼠标捕获

procedure ReleaseDCapture;
begin
  ReleaseCapture;
  MouseCaptureControl := nil;
end;

procedure RenderBox(Tex: ITexture; P1, P2: TPoint; X, Y, Width, Height: Integer);
var
  Spr                       : IHGESprite;
  W, H                      : Single;
  I, J, K, L, M, N, P       : Integer;
begin
  if Tex = nil then Exit;
  W := Tex.GetWidth(True);
  H := Tex.GetHeight(True);
  if (P1.X > 0) and (P1.Y > 0) then begin //左上角
    Spr := THGESprite.Create(Tex, 0, 0, P1.X, P1.Y);
    Spr.Render(X, Y);
  end;
  if (P1.X > 0) and (P2.Y < H) then begin //左下角
    Spr := THGESprite.Create(Tex, 0, P2.Y, P1.X, H - P2.Y);
    Spr.Render(X, Y + Height - (H - P2.Y));
  end;
  if (P2.X < W) and (P1.Y > 0) then begin //右上角
    Spr := THGESprite.Create(Tex, P2.X, 0, W - P2.X, P1.Y);
    Spr.Render(X + Width - (W - P2.X), Y);
  end;
  if (P2.X < W) and (P2.Y < H) then begin //右下角
    Spr := THGESprite.Create(Tex, P2.X, P2.Y, W - P2.X, H - P2.Y);
    Spr.Render(X + Width - (W - P2.X), Y + Height - (H - P2.Y));
  end;
  if (P1.Y > 0) or (P2.Y < H) then begin //上边、下边
    I := Round(Width - P1.X - (W - P2.X)); //目标上边宽
    K := P2.X - P1.X;                   //纹理宽
    if K <= 0 then K := 1;
    J := X + P1.X;                      //开始绘制X
    while I > 0 do begin
      if (P1.Y > 0) then begin          //上边
        if I >= K then Spr := THGESprite.Create(Tex, P1.X, 0, K, P1.Y)
        else Spr := THGESprite.Create(Tex, P1.X, 0, I, P1.Y);
        Spr.Render(J, Y);
      end;
      if (P2.Y < H) then begin          //下边
        if I >= K then Spr := THGESprite.Create(Tex, P1.X, P2.Y, K, H - P2.Y)
        else Spr := THGESprite.Create(Tex, P1.X, P2.Y, I, H - P2.Y);
        Spr.Render(J, Y + Height - (H - P2.Y));
      end;
      Dec(I, K);
      Inc(J, K);
    end;
  end;

  if (P1.X > 0) or (P2.X < W) then begin //左边和右边
    I := Round(Height - P1.Y - (H - P2.Y)); //目标高
    K := P2.Y - P1.Y;                   //纹理高
    J := Y + P1.Y;                      //开始绘制Y
    L := Round(W - P2.X);               //右边纹理宽度
    while I > 0 do begin
      if (P1.X > 0) then begin          //左边
        if I >= K then Spr := THGESprite.Create(Tex, 0, P1.Y, P1.X, K)
        else Spr := THGESprite.Create(Tex, 0, P1.Y, P1.X, I);
        Spr.Render(X, J);
      end;
      if (P2.X < W) then begin          //右边
        if I >= K then Spr := THGESprite.Create(Tex, P2.X, P1.Y, L, K)
        else Spr := THGESprite.Create(Tex, P2.X, P1.Y, L, I);
        Spr.Render(Round(X + Width - (W - P2.X)), J);
      end;
      Dec(I, K);
      Inc(J, K);
    end;
  end;
  //中间部分
  J := Round(Height - P1.Y - (H - P2.Y)); //目标高
  K := P2.X - P1.X;                     //纹理宽
  L := P2.Y - P1.Y;                     //纹理高
  P := P1.Y;                            //目标开始Y
  while J > 0 do begin                  //行优先
    I := Round(Width - (W - K));        //目标宽
    N := P1.X;                          //目标开始X
    if J >= L then M := L else M := J;  //一行的纹理高
    while I > 0 do begin                //一行
      if I >= K then Spr := THGESprite.Create(Tex, P1.X, P1.Y, K, M)
      else Spr := THGESprite.Create(Tex, P1.X, P1.Y, I, M);
      Spr.Render(X + N, Y + P);
      Dec(I, K);
      Inc(N, K);                        //目标宽度减少，X坐标增加
    end;
    Dec(J, L);
    Inc(P, L);                          //一行完成，目标高减少，Y坐标增加
  end;
end;
{----------------------------- THGEControl -------------------------------}

constructor THGEControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBmp := TBitmap.Create;
  FPng := TPNGObject.Create;
  DParent := nil;
  FHGE := HGECreate(HGE_VERSION);
  inherited Visible := False;
  FEnableFocus := False;
  Background := False;
  Alpha := 255;
  FLight := 255;
  FOnKeyPress := nil;
  FOnKeyDown := nil;
  FOnMouseMove := nil;
  FOnMouseDown := nil;
  FOnMouseUp := nil;
  FOnInRealArea := nil;
  DControls := TList.Create;
  FDParent := nil;
  FCParent := nil;
  FSpr := nil;
  Width := 80;
  Height := 24;
  FCaption := '';
  FVisible := True;
  FTexture := nil;
  WLib := nil;
  ULib := nil;
  FaceIndex := 0;
  FaceName := '';
  FCanInput := False;
  Font.Color := clBlack;
  Font.Name := '宋体';
  Font.Size := 9;
  Canvas.Font.Assign(Font);

  FAutoCheckInRange := True;
  FEnabled := True;
  //FIniSec:='';
  //fIniKey:='';

  PTop := 0;
  ClipRect.Left := 0;
  ClipRect.Top := 0;
  ClipRect.Right := Width;
  ClipRect.Bottom := Height;
end;

destructor THGEControl.Destroy;
begin
  FBmp.Free;
  FPng.Free;
  DControls.Free;
  FHGE := nil;
  FTexture := nil;
  FSpr := nil;
  inherited Destroy;
end;

procedure THGEControl.DelControl(AControl: THGEControl);
var
  I                         : Integer;
begin
  I := DControls.Indexof(AControl);
  if I >= 0 then DControls.Delete(I);
  AControl.DParent := nil;
end;

procedure THGEControl.AdjustPos(X, Y: Integer);
begin
  Top := Y;
  Left := X;
  PTop := Top;
end;

procedure THGEControl.AdjustPos(X, Y, W, H: Integer);
begin
  Left := X;
  Top := Y;
  Width := W;
  Height := H;
  PTop := Top;
end;

procedure THGEControl.SetImgIndex(Lib: TWMImages; Index, X, Y: Integer);
var
  Tex                       : ITexture;
{$IF CUSTOMUI_SAVE}
  sFileName                 : string;
{$IFEND}
begin
{$IF CUSTOMUI_LOAD}
  //
{$IFEND}
  if Lib <> nil then begin
    WLib := Lib;
    FaceIndex := Index;
    Tex := Lib.Images[FaceIndex];
    if Tex <> nil then begin
      SetTexture(Tex);
      Left := X;
      Top := Y;
      Width := Tex.Width;
      Height := Tex.Height;
      PTop := Top;
      if ClassType = THGECheckBox then begin
        Width := Width + 3 + g_GE.Font.TextWidth(Caption);
      end;
{$IF CUSTOMUI_SAVE}
      //sFileName := ExtractFilePath(Application.ExeName);
      //if sFileName[Length(sFileName)] <> '\' then
      //  sFileName := sFileName + '\';
      //sFileName := sFileName + 'CustomUI\';
      sFileName := '.\CustomUI\';
      ForceDirectories(sFileName);
      sFileName := sFileName + Self.Name + '.bmp';
      FHGE.Texture_SaveToFile(Tex.Handle, sFileName);
{$IFEND}
    end;
  end;
end;

procedure THGEControl.SetImgIndex(Lib: TWMImages; Index: Integer);
var
  Tex                       : ITexture;
{$IF CUSTOMUI_SAVE}
  sFileName                 : string;
{$IFEND}
begin
{$IF CUSTOMUI_LOAD}
  //
{$IFEND}
  if Lib <> nil then begin
    WLib := Lib;
    FaceIndex := Index;
    Tex := Lib.Images[FaceIndex];
    if Tex <> nil then begin
      SetTexture(Tex);
      Width := Tex.Width;
      Height := Tex.Height;
{$IF CUSTOMUI_SAVE}
      //sFileName := ExtractFilePath(Application.ExeName);
      //if sFileName[Length(sFileName)] <> '\' then
      //  sFileName := sFileName + '\';
      //sFileName := sFileName + 'CustomUI\';
      sFileName := '.\CustomUI\';
      ForceDirectories(sFileName);
      sFileName := sFileName + Self.Name + '.bmp';
      FHGE.Texture_SaveToFile(Tex.Handle, sFileName);
{$IFEND}
    end;
  end;
end;

procedure THGEControl.SetImgName(Lib: TUIBImages; F: string);
var
  Tex                       : ITexture;
begin
  try
    if Lib <> nil then begin
      ULib := Lib;
      FaceName := F;
      Tex := Lib.Images[F];
      if Tex <> nil then begin
        SetTexture(Tex);
        Width := Tex.Width;
        Height := Tex.Height;
      end;
    end;
  except
    on E: Exception do begin
      debugOutStr('TDControl.SetImgName ' + E.Message);
    end;
  end;
end;

procedure THGEControl.SetImgName(Lib: TUIBImages; F: string; X, Y: Integer);
var
  Tex                       : ITexture;
begin
  try
    if Lib <> nil then begin
      ULib := Lib;
      FaceName := F;
      Tex := Lib.Images[F];
      if Tex <> nil then begin
        SetTexture(Tex);
        Left := X;
        Top := Y;
        PTop := Top;
        Width := Tex.Width;
        Height := Tex.Height;
      end;
    end;
  except
    on E: Exception do begin
      debugOutStr('TDControl.SetImgName ' + E.Message);
    end;
  end;
end;

procedure THGEControl.DoRender;
begin
  if Visible and (FSpr <> nil) then
    FSpr.Render(SurfaceX(Left), SurfaceY(Top));
end;

procedure THGEControl.FadeOut;
begin

end;

function THGEControl.GetNextInputControl(boForward: Boolean): THGEControl;
var
  I, J                      : Integer;
  A                         : THGEControl;
begin
  Result := Self;
  if DParent = nil then Exit;
  I := DParent.DControls.Indexof(Self);
  if I < 0 then Exit;
  A := nil;
  if boForward then begin
    for J := I + 1 to DParent.DControls.Count - 1 do begin
      if THGEControl(DParent.DControls[J]).FCanInput and THGEControl(DParent.DControls[J]).Enabled then begin
        A := DParent.DControls[J];
        Break;
      end;
    end;
    if A = nil then begin
      for J := 0 to I do begin
        if THGEControl(DParent.DControls[J]).FCanInput and THGEControl(DParent.DControls[J]).Enabled then begin
          A := DParent.DControls[J];
          Break;
        end;
      end;
    end;
  end else begin
    for J := I - 1 downto 0 do begin
      if THGEControl(DParent.DControls[J]).FCanInput and THGEControl(DParent.DControls[J]).Enabled then begin
        A := DParent.DControls[J];
        Break;
      end;
    end;
    if A = nil then begin
      for J := DParent.DControls.Count - 1 downto I do begin
        if THGEControl(DParent.DControls[J]).FCanInput and THGEControl(DParent.DControls[J]).Enabled then begin
          A := DParent.DControls[J];
          Break;
        end;
      end;
    end;
  end;
  if A <> FocusedControl then begin
    ReleaseDFocus;
    SetDFocus(A);
  end;
end;

procedure THGEControl.SetAlpha(const Value: Byte);
begin
  if FAlpha <> Value then begin
    FAlpha := Value;
    if FSpr <> nil then begin
      if (ModalDWindow <> nil) and IsChild(ModalDWindow) then begin
        FSpr.SetColor(ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT));
      end else begin
        FSpr.SetColor(ARGB(FAlpha, FLight, FLight, FLight));
      end;
    end;
  end;
end;

procedure THGEControl.SetCaption(str: string);
begin
  FCaption := str;
  if csDesigning in ComponentState then begin
    Refresh;
  end;
end;

procedure THGEControl.SetCursor(Value: TCursor);
begin
  if (cursor <> Value) then begin
    FCursor := Value;
    if MouseInControl = Self then MouseInControl := nil;
  end;
end;

procedure THGEControl.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  SetTexture(FTexture);
end;

procedure THGEControl.SetFileName(const Value: string);
begin
  FTexture := nil;
  FFileName := Value;
  try
    if Value <> '' then begin
      if FMaskFileName = '' then
        FTexture := FHGE.Texture_Load(Value)
      else
        FTexture := FHGE.Texture_Load(Value, FMaskFileName);
      if FTexture <> nil then begin
        SetTexture(FTexture);
        if FSpr <> nil then begin
          Width := Round(FSpr.GetWidth);
          Height := Round(FSpr.GetHeight);
        end;
      end;
    end else SetTexture(nil);
  except
    FTexture := nil;
  end;
end;

procedure THGEControl.SetFocus;
begin
  if FocusedControl <> nil then
    ReleaseDFocus;
  SetDFocus(Self);
end;

procedure THGEControl.SetLight(const Value: Byte);
begin
  if FLight <> Value then begin
    FLight := Value;
    if FSpr <> nil then begin
      if (ModalDWindow <> nil) and IsChild(ModalDWindow) then begin
        FSpr.SetColor(ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT));
      end else begin
        FSpr.SetColor(ARGB(FAlpha, FLight, FLight, FLight));
      end;
    end;
  end;
end;

procedure THGEControl.SetMaskFileName(const Value: string);
begin
  FMaskFileName := Value;
  if (FFileName <> '') and (FMaskFileName <> '') then
    SetFileName(FFileName);
end;

procedure THGEControl.SetTexture(const Tex: ITexture);
begin
  FSpr := nil;
  if Tex = nil then Exit;
  FTexture := Tex;
  FSpr := THGESprite.Create(Tex, 0, 0, Width, Height);
  if FSpr = nil then Exit;
{$IFDEF DARK}
  if (ModalDWindow <> nil) and not IsChild(ModalDWindow) then
    Dark(True);
{$ENDIF}
end;

procedure THGEControl.SetVisible(const Value: Boolean);
begin
  if FVisible = Value then Exit;
  FVisible := Value;
  if not Visible then begin
    if (MouseCaptureControl = Self) then
      ReleaseDCapture;
  end else begin                        //如果鼠标在本人身上
    MouseInControl := nil;
  end;
end;

procedure THGEControl.Paint;
begin
  if csDesigning in ComponentState then begin
    if Self is THGEWindow then begin
      with Canvas do begin
        Pen.Color := clBlack;
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
        Pen.Color := clBlack;
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

procedure THGEControl.Render;
var
  I                         : Integer;
begin
  if not Visible then Exit;

  if Assigned(FOnRender) then begin
    FOnRender(Self)
  end else begin
    DoRender;
  end;

  for I := 0 to DControls.Count - 1 do begin
    if THGEControl(DControls[I]).Visible then begin
      if not THGEControl(DControls[I]).RenderOnTop then
        THGEControl(DControls[I]).Render
      else
        g_TopRenderList.Add(DControls[I]); //添加到顶层渲染列表
    end;
  end;

  if Assigned(FOnRenderCompleted) then
    FOnRenderCompleted(Self);
end;

function HGEControlSorter(Item1, Item2: Pointer): Integer;
begin
  Result := THGEControl(Item1).Taborder - THGEControl(Item2).Taborder;
end;

procedure THGEControl.Loaded;
var
  I                         : Integer;
  dcon                      : THGEControl;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then begin
    if Parent <> nil then
      for I := 0 to TControl(Parent).ComponentCount - 1 do begin
        if TControl(Parent).Components[I] is THGEControl then begin
          dcon := THGEControl(TControl(Parent).Components[I]);
          if dcon.DParent = Self then begin
            AddChild(dcon);
          end;
        end;
      end;
  end;
  DControls.Sort(HGEControlSorter);
end;

procedure THGEControl.LoadFromIni(sec, Key: string);
var
  I                         : Integer;
begin
  cursor := FHGE.Ini_GetInt(sec, Key + '_Cursor', cursor);
  Left := FHGE.Ini_GetInt(sec, Key + '_Left', Left);
  Top := FHGE.Ini_GetInt(sec, Key + '_Top', Top);
  Hint := FHGE.Ini_GetString(sec, Key + '_Hint', Hint);
  I := Pos('\', Hint);
  while I > 0 do begin
    Hint := System.Copy(Hint, 1, I - 1) + #13#10 + System.Copy(Hint, I + 1, Length(Hint) - 1);
    I := Posex('\', Hint, I);
  end;
  Width := FHGE.Ini_GetInt(sec, Key + '_Width', Width);
  Height := FHGE.Ini_GetInt(sec, Key + '_Height', Height);
  FileName := FHGE.Ini_GetString(sec, Key + '_pic', '');
  MaskFileName := FHGE.Ini_GetString(sec, Key + '_Mask', '');
end;

{procedure THGEControl.SaveToIni;
var
  I:integer;
  D:THGEControl;
begin
  if FIniSec<>'' then begin
    FHGE.Ini_SetInt(fIniSec,FInikey+'_Left',Left);
    FHGE.Ini_SetInt(fIniSec,FInikey+'_Top',Top);
  end;
  for I := 0 to DControls.Count - 1 do begin
    THGEControl(DControls[I]).SaveToIni;
  end;
end;}

//计算绝对坐标X

function THGEControl.SurfaceX(X: Integer): Integer;
var
  d                         : THGEControl;
begin
  d := Self;
  while True do begin
    if d.DParent = nil then Break;
    X := X + d.DParent.Left;
    d := d.DParent;
  end;
  Result := X;
end;
//计算绝对坐标Y

function THGEControl.SurfaceY(Y: Integer): Integer;
var
  d                         : THGEControl;
begin
  d := Self;
  while True do begin
    if d.DParent = nil then Break;
    Y := Y + d.DParent.Top;
    d := d.DParent;
  end;
  Result := Y;
end;

//绝对坐标转换为本对象的相对坐标X

function THGEControl.LocalX(X: Integer): Integer;
var
  d                         : THGEControl;
begin
  d := Self;
  while True do begin
    if d.DParent = nil then Break;
    X := X - d.DParent.Left;
    d := d.DParent;
  end;
  Result := X;
end;
//绝对坐标转换为本对象的相对坐标Y

function THGEControl.LocalY(Y: Integer): Integer;
var
  d                         : THGEControl;
begin
  d := Self;
  while True do begin
    if d.DParent = nil then Break;
    Y := Y - d.DParent.Top;
    d := d.DParent;
  end;
  Result := Y;
end;

function THGEControl.AbstractVisible: Boolean;
var
  P                         : THGEControl;
begin
  Result := False;
  if not Visible then Exit;             //1111
  Result := True;
  P := DParent;
  while P <> nil do begin
    if not P.Visible then begin
      Result := False;
      Break;
    end;
    P := P.DParent;
  end;
end;

procedure THGEControl.AddChild(dcon: THGEControl);
begin
  DControls.Add(Pointer(dcon));
end;
//把指定的控件移动到控件列表的最后面

procedure THGEControl.ChangeChildOrder(dcon: THGEControl);
var
  I                         : Integer;
begin
  if not (dcon is THGEWindow) then Exit;
  if THGEWindow(dcon).Floating then begin
    for I := 0 to DControls.Count - 1 do begin
      if dcon = DControls[I] then begin
        DControls.Delete(I);
        Break;
      end;
    end;
    DControls.Add(dcon);
  end;
end;

function THGEControl.AutoCheckInRange(X, Y: Integer): Boolean;
var
  Tex                       : ITexture;
  Region                    : TRect;
  PRec                      : PRect;
  Flags                     : Integer;
  Desc                      : TD3DSurfaceDesc;
  Rect                      : TD3DLockedRect;
  c                         : DWORD;
begin
  Result := True;
  if FSpr = nil then Exit;
  Tex := FSpr.GetTexture;
  if Tex = nil then Exit;
  X := X - Left;
  Y := Y - Top;
  if (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then begin
    if Succeeded(Tex.Handle.GetLevelDesc(0, Desc)) then begin
      if (Desc.format = D3DFMT_A8R8G8B8) or (Desc.format = D3DFMT_X8R8G8B8) then begin
        PRec := nil;
        Flags := 0;
        if Succeeded(Tex.Handle.LockRect(0, Rect, PRec, Flags)) then begin
          try
            c := PLongint(Longint(Rect.pBits) + Y * Rect.Pitch + X * 4)^;
            if (c and $FF000000) = 0 then
              Result := False;
          finally
            Tex.UnLock;
          end;
        end;
      end;
    end;
  end;
end;
//判断一点是否在当前控件范围内

function THGEControl.InRange(X, Y: Integer): Boolean;
var
  boInrange                 : Boolean;
  Clipping                  : Boolean;
  L, T, W, H                : Integer;
  d                         : THGEControl;
begin
  if (X >= Left) and (X < Left + Width) and (Y >= Top) and (Y < Top + Height) then begin
    boInrange := True;

    Clipping := (CParent <> nil) and (CParent is THGEWindow);
    if Clipping then begin
      L := CParent.ClipRect.Left;
      T := CParent.ClipRect.Top;
      W := CParent.ClipRect.Right;
      H := CParent.ClipRect.Bottom;
      d := Self;
      while True do begin
        if (d = nil) or (d.DParent = nil) or (d.DParent = Self.CParent) then Break;
        L := L - d.DParent.Left;
        T := T - d.DParent.Top;
        d := d.DParent;
      end;
      if (X >= L) and (X < L + W) and (Y >= T) and (Y < T + H) then begin
        if Assigned(FOnInRealArea) then
          FOnInRealArea(Self, X - Left, Y - Top, boInrange)
        else if FAutoCheckInRange and (FSpr <> nil) then begin
          boInrange := AutoCheckInRange(X, Y);
        end;
        Result := boInrange;
      end else
        Result := False;
    end else begin
      if Assigned(FOnInRealArea) then
        FOnInRealArea(Self, X - Left, Y - Top, boInrange)
      else if FAutoCheckInRange and (FSpr <> nil) then begin
        boInrange := AutoCheckInRange(X, Y);
      end;
      Result := boInrange;
    end;
  end else
    Result := False;
end;

function THGEControl.IsChild(Win: THGEControl): Boolean;
begin
  Result := False;
  if (Win = nil) or (Self = Win) then Result := True
  else while Assigned(Win) do begin
      if DParent = Win then begin
        Result := True;
        Exit;
      end;
      if DParent = nil then Exit;
      Win := Win.DParent;
    end;
end;

function THGEControl.KeyPress(var Key: Char): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  if Background or not Visible then Exit;

  for I := DControls.Count - 1 downto 0 do
    if THGEControl(DControls[I]).Visible then
      if THGEControl(DControls[I]).KeyPress(Key) then begin
        Result := True;
        Exit;
      end;
  if (FocusedControl = Self) and Visible then begin
    if Assigned(FOnKeyPress) then FOnKeyPress(Self, Key);
    Result := True;
  end;
end;

function THGEControl.KeyDown(var Key: word; Shift: TShiftState): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  if Background or not Visible then Exit;
  for I := DControls.Count - 1 downto 0 do
    if THGEControl(DControls[I]).Visible then
      if THGEControl(DControls[I]).KeyDown(Key, Shift) then begin
        Result := True;
        Exit;
      end;
  if (FocusedControl = Self) then begin
    if Assigned(FOnKeyDown) then FOnKeyDown(Self, Key, Shift);
    Result := True;
  end;
end;

function THGEControl.KeyUp(var Key: word; Shift: TShiftState): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  if Background or not Visible then Exit;
  for I := DControls.Count - 1 downto 0 do begin
    if THGEControl(DControls[I]).Visible then begin
      if THGEControl(DControls[I]).KeyUp(Key, Shift) then begin
        Result := True;
        Exit;
      end;
    end;
  end;
  if (FocusedControl = Self) then begin
    if Assigned(FOnKeyUp) then FOnKeyUp(Self, Key, Shift);
    if ClassType = THGEButton then begin
      if ((Key = VK_RETURN) or (Key = VK_SPACE)) and Assigned(FOnClick) then
        FOnClick(Self, 0, 0);
    end;
    Result := True;
  end;
end;

procedure THGEControl.AlphaBlend(Value: Byte);
var
  I                         : Integer;
begin
  Alpha := Value;
  for I := DControls.Count - 1 downto 0 do begin
    if THGEControl(DControls[I]).Visible then begin
      THGEControl(DControls[I]).AlphaBlend(Value);
    end;
  end;
end;

procedure THGEControl.BringToFront;
var
  I                         : Integer;
begin
  if DParent = nil then Exit;

  for I := 0 to DParent.DControls.Count - 1 do begin
    if Self = DParent.DControls[I] then begin
      DParent.DControls.Delete(I);
      Break;
    end;
  end;
  DParent.DControls.Add(Self);
end;

procedure THGEControl.SendToBack;
var
  I                         : Integer;
begin
  if DParent = nil then Exit;

  for I := 0 to DParent.DControls.Count - 1 do begin
    if Self = DParent.DControls[I] then begin
      DParent.DControls.Delete(I);
      Break;
    end;
  end;
  DParent.DControls.Insert(0, Self);
end;

function THGEControl.CanFocusMsg: Boolean;
begin
  Result := (MouseCaptureControl = nil) or
    ((MouseCaptureControl <> nil) and
    ((MouseCaptureControl = Self) or
    (MouseCaptureControl = DParent)));
end;

procedure THGEControl.WindowMsgProce(Window: HWnd; Msg: UINT; wParam: wParam;
  lParam: lParam);
var
  I                         : Integer;
begin
  if not Visible then Exit;
  for I := DControls.Count - 1 downto 0 do
    if THGEControl(DControls[I]).Visible and THGEControl(DControls[I]).Enabled then
      THGEControl(DControls[I]).WindowMsgProce(Window, Msg, wParam, lParam);
end;

function THGEControl.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
  H                         : THGEControl;
begin
  Result := False;

  for I := DControls.Count - 1 downto 0 do begin
    H := THGEControl(DControls[I]);
    if H.Visible and H.Enabled then begin
      if H.MouseMove(Shift, X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
    end;
  end;

  if (MouseCaptureControl <> nil) then begin
    if (MouseCaptureControl = Self) then begin
      if Assigned(FOnMouseMove) then
        FOnMouseMove(Self, Shift, X, Y);
      Result := True;
    end;
    Exit;
  end;

  if not Background and InRange(X, Y) then begin
    if Assigned(FOnMouseMove) then
      FOnMouseMove(Self, Shift, X, Y);
    Result := True;
    if MouseInControl <> nil then begin
      if MouseInControl <> Self then begin
        MouseInControl.FIsMouseIn := False;
        MouseInControl.MouseLeave;
        MouseInControl := nil;
      end;
    end;
    if MouseInControl = nil then begin
      MouseInControl := Self;
      FIsMouseIn := True;
      MouseEnter;
    end;
  end else begin
    if MouseInControl = Self then begin
      FIsMouseIn := False;
      MouseLeave;
      MouseInControl := nil;
    end;
    if FIsMouseIn then begin
      FIsMouseIn := False;
      MouseLeave;
    end;
  end;
end;

function THGEControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  for I := DControls.Count - 1 downto 0 do
    if THGEControl(DControls[I]).Visible and THGEControl(DControls[I]).Enabled then
      if THGEControl(DControls[I]).MouseDown(Button, Shift, X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
  if Background then begin
    if Assigned(FOnBackgroundClick) then begin
      WantReturn := False;
      BackgroundButton := Button;
      FOnBackgroundClick(Self);
      if WantReturn then begin
        //WantReturn := False;
        Result := True;
      end;
    end;
    ReleaseDFocus;
    Exit;
  end;
  if CanFocusMsg then begin
    if InRange(X, Y) or (MouseCaptureControl = Self) then begin
      if Assigned(FOnMouseDown) then
        FOnMouseDown(Self, Button, Shift, X, Y);
      if EnableFocus then SetDFocus(Self);
      Result := True;
    end;
  end;
end;

procedure THGEControl.MouseEnter;
begin
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure THGEControl.MouseLeave;
begin
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

function THGEControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  for I := DControls.Count - 1 downto 0 do
    if THGEControl(DControls[I]).Visible and THGEControl(DControls[I]).Enabled then
      if THGEControl(DControls[I]).MouseUp(Button, Shift, X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;

  if (MouseCaptureControl <> nil) then begin //MouseCapture 捞搁 磊脚捞 快急
    if (MouseCaptureControl = Self) then begin
      ReleaseDCapture;
      if Assigned(FOnMouseUp) then
        FOnMouseUp(Self, Button, Shift, X, Y);
      Result := True;
    end;
    Exit;
  end;

  if Background then Exit;
  if InRange(X, Y) then begin
    if Assigned(FOnMouseUp) then
      FOnMouseUp(Self, Button, Shift, X, Y);
    Result := True;
  end;
end;

function THGEControl.MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  for I := DControls.Count - 1 downto 0 do begin
    if THGEControl(DControls[I]).Visible and THGEControl(DControls[I]).Enabled then begin
      if THGEControl(DControls[I]).MouseWheel(Shift, X - Left, Y - Top, Z) then begin
        Result := True;
        Exit;
      end;
    end;
  end;

  if (MouseCaptureControl <> nil) then begin //MouseCapture 捞搁 磊脚捞 快急
    if (MouseCaptureControl = Self) then begin
      if Assigned(FOnMouseWheel) then
        FOnMouseWheel(Self, Shift, X, Y, Z);
      Result := True;
    end;
    Exit;
  end;

  if Background then Exit;
  if InRange(X, Y) then begin
    if Assigned(FOnMouseWheel) then
      FOnMouseWheel(Self, Shift, X, Y, Z);
    Result := True;
  end;
end;

{$IFDEF DARK}

procedure THGEControl.Dark;
var
  I                         : Integer;
begin
  if bFlag then begin
    if FSpr <> nil then begin
      FSpr.SetColor(ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT));
    end;
    for I := DControls.Count - 1 downto 0 do begin
      if DControls[I] <> ModalDWindow then
        THGEControl(DControls[I]).Dark(True);
    end;
  end else begin
    if FSpr <> nil then begin
      FSpr.SetColor(ARGB(FAlpha, FLight, FLight, FLight));
    end;
    for I := DControls.Count - 1 downto 0 do begin
      THGEControl(DControls[I]).Dark(False);
    end;
  end;
end;
{$ENDIF}

function THGEControl.DblClick(X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then begin
    if (MouseCaptureControl = Self) then begin
      if Assigned(FOnDblClick) then
        FOnDblClick(Self);
      Result := True;
    end;
    Exit;
  end;
  for I := DControls.Count - 1 downto 0 do
    if THGEControl(DControls[I]).Visible then
      if THGEControl(DControls[I]).DblClick(X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
  if Background then Exit;
  if InRange(X, Y) then begin
    if Assigned(FOnDblClick) then
      FOnDblClick(Self);
    Result := True;
  end;
end;

function THGEControl.Click(X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then begin
    if (MouseCaptureControl = Self) then begin
      if Assigned(FOnClick) then
        FOnClick(Self, X, Y);
      Result := True;
    end;
    Exit;
  end;
  for I := DControls.Count - 1 downto 0 do
    if THGEControl(DControls[I]).Visible then
      if THGEControl(DControls[I]).Click(X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
  if Background then Exit;
  if InRange(X, Y) then begin
    if Assigned(FOnClick) then
      FOnClick(Self, X, Y);
    Result := True;
  end;
end;

{--------------------- THGEButton --------------------------}

constructor THGEButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMouseState := tsNone;
  FDowned := False;
  FOnClick := nil;
  FEnableFocus := True;
  FClickSound := csNone;
  FAllowAllUp := False;
  FNeedUpdate := False;
  cursor := crHandPoint;
  FFlashed := False;
  FPageActive := False;
  FFlashInterval := 300;
  FFlashTick := 0;
  FFlashState := 0;
  FClickInv := 0;
  FOnClickSound := frmdlg.btnClickSound;
end;

function THGEButton.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
{$IFDEF DEBUGUI}
var
  al, at                    : Integer;
{$ENDIF}
begin
  Result := False;
  if FMouseState = tsDisable then Exit;
  FMouseState := tsNone;
  Result := inherited MouseMove(Shift, X, Y);
  if Result then
    FMouseState := tsMove;
  if (not Background) and (not Result) then begin
    if MouseCaptureControl = Self then begin
      if InRange(X, Y) then begin
        FDowned := True;
      end else if not FAllowAllUp then
        FDowned := False;
    end;
  end;
{$IFDEF DEBUGUI}
  if not Background and (MouseCaptureControl = Self) and (ssCtrl in Shift) and ((SpotX <> X) or (SpotY <> Y)) then begin
    al := Left + (X - SpotX);
    at := Top + (Y - SpotY);
    if al + Width < WINLEFT then al := WINLEFT - Width;
    if al > WINRIGHT then al := WINRIGHT;
    if at + Height < WINTOP then at := WINTOP - Height;
    if at > BOTTOMEDGE then at := BOTTOMEDGE;
    Left := al;
    Top := at;
    SpotX := X;
    SpotY := Y;
    g_Screen.AddChatBoardString(format('%d %d', [Left, Top]), clRed, clWhite);
  end;
{$ENDIF}
end;

function THGEButton.KeyPress(var Key: Char): Boolean;
begin
  Result := False;
  if FMouseState = tsDisable then Exit;
  FMouseState := tsNone;
  if Visible and (ModalDWindow <> nil) and IsChild(ModalDWindow) then begin
    if (Default and (Key = #13)) or ((FocusedControl = Self) and (Key in [' ', #13])) and Assigned(FOnClick) then begin
      Result := True;
      FMouseState := tsDown;
      FOnClick(Self, 0, 0);
      Exit;
    end;
    if Cancel and (Key = #27) and Assigned(FOnClick) then begin
      Result := True;
      FMouseState := tsDown;
      FOnClick(Self, 0, 0);
      Exit;
    end;
  end;
  Result := inherited KeyPress(Key);
end;

function THGEButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if FMouseState = tsDisable then Exit;
  FMouseState := tsNone;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) and (mbLeft = Button) then begin
{$IFDEF DEBUGUI}
      SpotX := X;
      SpotY := Y;
{$ENDIF}
      if GetTickCount - FClickInv <= 150 then begin
        //SetDCapture(self);
        Result := True;
        Exit;
      end;
      FMouseState := tsDown;
      Downed := True;
      FNeedUpdate := True;
      SetDCapture(Self);
    end;
    Result := True;
  end;
end;

procedure THGEButton.MouseEnter;
begin
  inherited;
  if (ClassType <> THGEWindow) then begin
    SetTexture(FTexture);
  end;
end;

procedure THGEButton.MouseLeave;
begin
  inherited;
  if (ClassType <> THGEWindow) then begin
    SetTexture(FTexture);
  end;
end;

function THGEButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if FMouseState = tsDisable then Exit;
  FMouseState := tsNone;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    if not Downed then begin
      Result := True;
      FClickInv := 0;
      Exit;
    end;
    ReleaseDCapture;
    //if (ClassType <> THGEWindow) then SetTexture(FTexture);
    if not Background then begin
      if Enabled and (Button = mbLeft) and ((MouseInControl = nil) or (MouseInControl = Self)) then begin
        if not FAllowAllUp then
          Downed := False;
        //SetTexture(FTexture);
        if InRange(X, Y) then begin
          if GetTickCount - FClickInv <= 150 then begin
            //Result := True;
            Downed := False;
            Exit;
          end;
          FClickInv := GetTickCount;

          if Assigned(FOnClickSound) then
            FOnClickSound(Self, FClickSound);

          if ClassType = THGERadioButton then begin
            if not THGERadioButton(Self).Checked then
              THGERadioButton(Self).Checked := True
          end else if ClassType = THGECheckBox then
            THGECheckBox(Self).Checked := not THGECheckBox(Self).Checked;
          //执行Click事件
          if Assigned(FOnClick) then FOnClick(Self, X, Y);
        end;
      end;
    end;
    FMouseState := tsUp;
    Result := True;
    Exit;
  end else begin
    ReleaseDCapture;
    if not FAllowAllUp then Downed := False;
  end;
end;

procedure THGEButton.DoRender;
var
  Clipping                  : Boolean;
begin
  if Enabled and FFlashed and (Integer(GetTickCount - FFlashTick) >= FFlashInterval) then begin
    if FFlashState = 0 then
      FFlashState := 1
    else
      FFlashState := 0;
    FFlashTick := GetTickCount;
    FNeedUpdate := True;
  end;
  if FNeedUpdate then
    SetTexture(FTexture);

  Clipping := (CParent <> nil) and (CParent is THGEWindow);
  if Clipping then begin
    FHGE.Gfx_SetClipping(CParent.SurfaceX(CParent.Left + CParent.ClipRect.Left), CParent.SurfaceY(CParent.Top + CParent.ClipRect.Top), CParent.ClipRect.Right, CParent.ClipRect.Bottom);
  end;
  inherited DoRender;
  if Clipping then begin
    FHGE.Gfx_SetClipping();
  end;
end;

procedure THGEButton.SetDowned(const Value: Boolean);
begin
  FDowned := Value;
  if ClassType <> THGEWindow then FNeedUpdate := True;
end;

procedure THGEButton.SetTexture(const Tex: ITexture);
var
  I, W, H                   : Integer;
begin
  FNeedUpdate := False;
  if Tex = nil then Exit;
  FTexture := Tex;
  if not Enabled then
    I := 3
  else if THGEButton(Self).FDowned then begin
    if FFlashed and (FFlashState = 1) then
      I := 1
    else
      I := 2;
  end else if THGEButton(Self).IsMouseIn then begin
    if FFlashed and (FFlashState = 1) then
      I := 0
    else
      I := 1;
  end else begin
    if FFlashed and (FFlashState = 1) then
      I := 1
    else
      I := 0;
  end;

  H := FTexture.GetHeight(True);        // div 4;  //1111
  W := FTexture.GetWidth(True);

  //1111
  //Width := W;
  //Height := H;

  FSpr := THGESprite.Create(FTexture, 0, H * I, W, H);
  if FSpr = nil then Exit;
  FSpr.SetHotSpot(0, 0);
  FSpr.SetBlendMode(BLEND_DEFAULT);
{$IFDEF DARK}
  if (ModalDWindow <> nil) and not IsChild(ModalDWindow) then begin
    Dark(True);
  end;
{$ENDIF}
end;

{------------------------- THGEGrid --------------------------}

constructor THGEGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColCount := 6;
  FRowCount := 6;
  FColWidth := 30;                      //36;
  FRowHeight := 30;                     //32;
  FOnGridSelect := nil;
  FOnGridMouseMove := nil;
  FOnGridRender := nil;
  FNormCellSpr := nil;
  FHighlightCellSpr := nil;
  FDownCellSpr := nil;
  FDisableCellSpr := nil;
  MouseCell.X := -1;
  MouseCell.Y := -1;
  MouseDownCell.X := -1;
  MouseDownCell.Y := -1;
  dx := 0;
  dy := 0;
  SelButton := mbLeft;
end;
//根据指定的坐标获得表格的行/列

function THGEGrid.GetCellChecked(Row, Col: Integer): Boolean;
begin
  Result := False;
  if (Row >= FRowCount) or (Row < 0) then Exit;
  Result := FCells[FColCount * Row + Col].Checked;
end;

function THGEGrid.GetCellDisabled(Row, Col: Integer): Boolean;
begin
  Result := True;
  if (Row >= FRowCount) or (Row < 0) then Exit;
  Result := FCells[FColCount * Row + Col].Disabled;
end;

function THGEGrid.GetColRow(X, Y: Integer; var ACol, ARow: Integer): Boolean;
begin
  Result := False;
  ACol := -1;
  ARow := -1;
  if InRange(X, Y) then begin
    ACol := (X - Left) div FColWidth;
    ARow := (Y - Top) div FRowHeight;
    Result := True;
  end;
end;

procedure THGEGrid.LoadFromIni(sec, Key: string);
begin
  inherited LoadFromIni(sec, Key);
  ColCount := FHGE.Ini_GetInt(sec, Key + '_Cols', ColCount);
  RowCount := FHGE.Ini_GetInt(sec, Key + '_Rows', RowCount);
  FColWidth := Width div FColCount;
  FRowHeight := Height div FRowCount;
  CellFileName := FHGE.Ini_GetString(sec, Key + '_CellPic', FFileName);
end;

function THGEGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if Button in [mbLeft, mbRight] then begin
    if GetColRow(X, Y, MouseCell.X, MouseCell.Y) then begin
      SelectCell.X := MouseCell.X;
      SelectCell.Y := MouseCell.Y;
      DownPos.X := X;
      DownPos.Y := Y;
      MouseDownCell.X := MouseCell.X;
      MouseDownCell.Y := MouseCell.Y;
      SetDCapture(Self);
      Result := inherited MouseDown(Button, Shift, X, Y);
    end else begin
      MouseDownCell.X := -1;
      MouseDownCell.Y := -1;
    end;
  end;
end;

procedure THGEGrid.MouseLeave;
begin
  inherited MouseLeave;
  MouseCell.X := -1;
  MouseCell.Y := -1;
end;

function THGEGrid.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result then begin
    MouseCell.X := -1;
    MouseCell.Y := -1;
    if GetColRow(X, Y, MouseCell.X, MouseCell.Y) then begin
      if ssLeft in Shift then begin
        MouseDownCell.X := MouseCell.X;
        MouseDownCell.Y := MouseCell.Y;
      end;
      if Assigned(FOnGridMouseMove) then
        FOnGridMouseMove(Self, MouseCell.X, MouseCell.Y, Shift);
    end else begin
      MouseDownCell.X := -1;
      MouseDownCell.Y := -1;
    end;
  end;
end;

function THGEGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if GetColRow(X, Y, MouseCell.X, MouseCell.Y) then begin
    if (SelectCell.X = MouseCell.X) and (SelectCell.Y = MouseCell.Y) then begin
      Col := MouseCell.X;
      Row := MouseCell.Y;
      //if (Button = mbLeft) and Assigned(FOnGridSelect) then
      if Assigned(FOnGridSelect) then begin
        SelButton := Button;
        FOnGridSelect(Self, MouseCell.X, MouseCell.Y, Shift);
      end;
    end;
    Result := inherited MouseUp(Button, Shift, X, Y);
  end;
  MouseDownCell.X := -1;
  MouseDownCell.Y := -1;
  ReleaseDCapture;
end;

function THGEGrid.DblClick(X, Y: Integer): Boolean;
begin
  Result := False;
  if GetColRow(X, Y, MouseCell.X, MouseCell.Y) then begin
    if (SelectCell.X = MouseCell.X) and (SelectCell.Y = MouseCell.Y) then begin
      Col := MouseCell.X;
      Row := MouseCell.Y;
    end;
    Result := inherited DblClick(X, Y);
    if Result then ReleaseDCapture;

  end;
end;

procedure THGEGrid.DoRender;
var
  I, J, lx, ly              : Integer;
  rc                        : TRect;
begin
  lx := SurfaceX(Left);
  ly := SurfaceY(Top);
  for I := 0 to FRowCount - 1 do begin
    for J := 0 to FColCount - 1 do begin
      if CellDisabled[I, J] then begin
        if FDisableCellSpr <> nil then
          FDisableCellSpr.Render(lx + J * FColWidth + dx, ly + I * FRowHeight + dy);
      end else if (I = MouseDownCell.Y) and (J = MouseDownCell.X) then begin
        if FDownCellSpr <> nil then
          FDownCellSpr.Render(lx + J * FColWidth + dx, ly + I * FRowHeight + dy);
      end else if (I = MouseCell.Y) and (J = MouseCell.X) then begin
        if FHighlightCellSpr <> nil then
          FHighlightCellSpr.Render(lx + J * FColWidth + dx, ly + I * FRowHeight + dy);
      end else begin
        if FNormCellSpr <> nil then
          FNormCellSpr.Render(lx + J * FColWidth + dx, ly + I * FRowHeight + dy);
      end;
      if Assigned(FOnGridRender) then begin
        //rc:=Rect(Round(lx+J*FColWidth + dx),Round(ly+I*FRowHeight + dy),Round(lx+J*FColWidth + dx +FColWidth),Round(ly+I*FRowHeight + dy + FRowHeight));
        rc := Bounds(Round(lx + J * FColWidth + dx), Round(ly + I * FRowHeight + dy), FColWidth, FRowHeight);
        FOnGridRender(Self, J, I, rc, []);
      end;
    end;
  end;
end;

procedure THGEGrid.SetCellChecked(Row, Col: Integer; const Value: Boolean);
begin
  if (Row >= FRowCount) or (Row < 0) then Exit;
  FCells[FColCount * Row + Col].Checked := Value;
end;

procedure THGEGrid.SetCellDisabled(Row, Col: Integer; const Value: Boolean);
begin
  if (Row >= FRowCount) or (Row < 0) then Exit;
  FCells[FColCount * Row + Col].Disabled := Value;
end;

procedure THGEGrid.SetCellFileName(const Value: string);
var
  W, H                      : Integer;
begin
  FCellFileName := Value;
  FCellTex := FHGE.Texture_Load(FCellFileName);
  if FCellTex = nil then begin
    FNormCellSpr := nil;
    FHighlightCellSpr := nil;
    FDownCellSpr := nil;
    FDisableCellSpr := nil;
  end else begin
    W := FCellTex.GetWidth(True);
    H := FCellTex.GetHeight(True) div 4;
    FNormCellSpr := THGESprite.Create(FCellTex, 0, 0, W, H);
    FHighlightCellSpr := THGESprite.Create(FCellTex, 0, H, W, H);
    FDownCellSpr := THGESprite.Create(FCellTex, 0, H * 2, W, H);
    FDisableCellSpr := THGESprite.Create(FCellTex, 0, H * 3, W, H);
  end;
  if FNormCellSpr <> nil then begin
    //dx,dy要取整 否则如果配置或图片的宽高不正确，会变模糊
    dx := Round((FColWidth - FNormCellSpr.GetWidth) / 2);
    dy := Round((FRowHeight - FNormCellSpr.GetHeight) / 2);
  end else begin
    dx := 0;
    dy := 0;
  end;
end;

procedure THGEGrid.SetColCount(const Value: Integer);
begin
  FColCount := Value;
  SetLength(FCells, FColCount * FRowCount);
end;

procedure THGEGrid.SetRowCount(const Value: Integer);
begin
  FRowCount := Value;
  SetLength(FCells, FColCount * FRowCount);
end;

function THGEGrid.Click(X, Y: Integer): Boolean;
begin
  Result := False;
end;

{--------------------- THGEWindown --------------------------}

constructor THGEWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFloating := False;
  FEnableFocus := True;
  Width := 120;
  Height := 120;
  FLastModalWindow := nil;
  cursor := crDefault;
end;

procedure THGEWindow.SetTexture(const Tex: ITexture);
begin
  FNeedUpdate := False;
  FSpr := nil;
  if Tex = nil then Exit;
  FTexture := Tex;
  if not Background then begin
    Width := Tex.GetWidth(True);
    Height := Tex.GetHeight(True);
  end;
  FSpr := THGESprite.Create(FTexture, 0, 0, FTexture.GetWidth(True), FTexture.GetHeight(True));
  if FSpr = nil then Exit;
  FSpr.Render(SurfaceX(Left), SurfaceY(Top));
{$IFDEF DARK}
  if (ModalDWindow <> nil) and not IsChild(ModalDWindow) then begin
    Dark(True);
  end;
{$ENDIF}
end;

procedure THGEWindow.SetTextureMode(const Value: TTextureMode);
begin
  FTextureMode := Value;
end;

procedure THGEWindow.SetVisible(flag: Boolean);
var
  Root                      : THGEControl;
begin
  if FVisible = flag then Exit;
  FVisible := flag;
  if Floating and flag then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(Self);
  end;
  if ModalDWindow = Self then begin
    Root := Self;
    while Root.DParent <> nil do
      Root := Root.DParent;
{$IFDEF DARK}
    Root.Dark(FVisible);
{$ENDIF}
    if not Visible then begin
      if (FLastModalWindow <> nil) and FLastModalWindow.Visible then
        ModalDWindow := FLastModalWindow //恢复上一个模式窗口
      else
        ModalDWindow := nil;
      if (ModalDWindow <> nil) and ModalDWindow.Visible then begin
        Root := ModalDWindow;
        while Root.DParent <> nil do
          Root := Root.DParent;
{$IFDEF DARK}
        Root.Dark(True);
{$ENDIF}
      end;
    end;
  end;
  if not flag then begin
    if (FocusedControl <> nil) and FocusedControl.IsChild(Self) then ReleaseDFocus;
    if (MouseCaptureControl <> nil) and MouseCaptureControl.IsChild(Self) then ReleaseDCapture;
  end;
  if Assigned(FOnShow) then FOnShow(Visible);
end;

function THGEWindow.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  al, at                    : Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FFloating and (MouseCaptureControl = Self) then begin
    if (SpotX <> X) or (SpotY <> Y) then begin
      al := Left + (X - SpotX);
      at := Top + (Y - SpotY);
      if al + Width < WINLEFT then al := WINLEFT - Width;
      if al > WINRIGHT then al := WINRIGHT;
      if at + Height < WINTOP then at := WINTOP - Height;
      if at {+Height} > BOTTOMEDGE then at := BOTTOMEDGE {-Height};
      Left := al;
      Top := at;
      SpotX := X;
      SpotY := Y;
      //g_Screen.AddChatBoardString(format('%d %d', [Left, Top]), clRed, clWhite);
    end;
  end;
end;

procedure THGEWindow.Hide;
begin
  Visible := False;
  if ModalDWindow = Self then begin
    ModalDWindow := nil;
  end;
  inherited Hide;
end;

procedure THGEWindow.LoadFromIni(sec, Key: string);
begin
  inherited LoadFromIni(sec, Key);
  Floating := FHGE.Ini_GetInt(sec, Key + '_Floating', Integer(Floating)) = 1;
end;

function THGEWindow.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    if Floating then begin
      if DParent <> nil then
        DParent.ChangeChildOrder(Self);
    end else FNeedUpdate := False;
    SpotX := X;
    SpotY := Y;
  end;
end;

function THGEWindow.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
end;

procedure THGEWindow.Show;
begin
  Visible := True;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(Self);
  end;
  if EnableFocus then SetDFocus(Self);
end;

function THGEWindow.KeyPress(var Key: Char): Boolean;
var
  I                         : Integer;
begin
  {if Visible and (ModalDWindow <> nil) and (ModalDWindow = Self) then begin
    if (Default and (Key = #13)) or ((FocusedControl = Self) and (Key in [' ', #13])) and Assigned(FOnClick) then begin
      Result := True;
      FOnClick(Self, 0, 0);
      Exit;
    end;
    if Cancel and (Key = #27) and Assigned(FOnClick) then begin
      Result := True;
      FOnClick(Self, 0, 0);
      Exit;
    end;
  end;}
  Result := inherited KeyPress(Key);
end;

function THGEWindow.ShowModal: Integer;
var
  I                         : Integer;
begin
  SetDFocus(nil);
  FLastModalWindow := ModalDWindow;     //保存上一个模式窗口
  ModalDWindow := Self;
  Visible := True;
  if EnableFocus then SetDFocus(Self);

  for I := 0 to DControls.Count - 1 do begin
    if not THGEControl(DControls[I]).Visible then
      Continue;
    if THGEControl(DControls[I]).FCanInput then begin
      SetDFocus(DControls[I]);
      Break;
    end;
  end;
{$IFDEF DARK}
  Dark(False);
{$ENDIF}
  Result := 0;
end;

{--------------------- THGEWinManager --------------------------}

constructor THGEWinManager.Create(AOwner: TComponent);
var
  IMC                       : HIMC;
begin
  inherited Create(AOwner);
  DWinList := TList.Create;
  MouseCaptureControl := nil;
  FocusedControl := nil;
  FHGE := HGECreate(HGE_VERSION);
  FHintLabel := THGELabel.Create(nil);
  FHintLabel.ParentWindow := g_GE.HGE.System_GetState(HGE.HGE_HWND);
  FHintLabel.Font.Color := clBlack;     //clWhite;
  FHintLabel.Font.Name := '宋体';
  FHintLabel.Font.Size := 9;
  FHintLabel.BorderWidth := 2;          //2;
  FHintLabel.Transparent := False;
  FHintLabel.Alpha := $FF;              //$D8;
  FHintLabel.Color := {clBlack;} GetRGB(161);
  FHintLabel.AutoSize := True;
  FMX := -1;
  FMY := -1;
  FShowHintTick := 0;
  FHintHidePause := 80000;
  FHintPause := 300;
  FOnRenderTop := nil;
  FCursorList := nil;
  FCursor := nil;
  FCursorIndex := $FF;
  FOnProcessLast := nil;
  FHintBackTex := nil;
  FHintBackPoint1 := Point(3, 3);
  FHintBackPoint2 := Point(6, 7);
  //取得当前输入法
  g_GE.IME.m_DefKL := GetKeyboardLayout(0);
  g_GE.IME.m_szImeName[0] := #0;

  if (HiWord(g_GE.IME.m_DefKL) <> $0804) and (ImmIsIME(g_GE.IME.m_DefKL)) then begin
    IMC := ImmGetContext(FHGE.System_GetState(HGE_HWND));
    ImmEscape(g_GE.IME.m_DefKL, IMC, IME_ESC_IME_NAME, @g_GE.IME.m_szImeName[0]); //取得新输入法名字
  end;
end;

destructor THGEWinManager.Destroy;
var
  P                         : PCursorRec;
begin
  FHintLabel.Free;
  DWinList.Free;
  FSysFont.Free;
  P := FCursorList;
  while P <> nil do begin
    Dispose(FCursorList);
    P := P.Next;
    FCursorList := P;
  end;
  FHintBackTex := nil;
  inherited Destroy;
end;

procedure THGEWinManager.FlushHint(Sender: THGEControl);
begin
  FHintLabel.Caption := Sender.Hint;
  FShowHintTick := GetTickCount - FHintPause;
  FHintShow := False;
end;

procedure THGEWinManager.ClearAll;
begin
  DWinList.Clear;
end;

procedure THGEWinManager.AddDControl(dcon: THGEControl; Visible: Boolean);
begin
  dcon.Visible := Visible;
  DWinList.Add(dcon);
end;

procedure THGEWinManager.DelDControl(dcon: THGEControl);
var
  I                         : Integer;
begin
  for I := 0 to DWinList.Count - 1 do
    if DWinList[I] = dcon then begin
      DWinList.Delete(I);
      Break;
    end;
end;

function THGEWinManager.KeyPress(var Key: Char): Boolean;
begin
  {if Assigned(FOnKeyPress) then begin
    FOnKeyPress(Self, Key);
    if Key = #0 then begin
      Result := True;
      Exit;
    end;
  end;}

  Result := False;
  if (ModalDWindow <> nil) then begin
    if ModalDWindow.AbstractVisible then begin
      with ModalDWindow do
        Result := KeyPress(Key);
      Exit;
    end else
      ModalDWindow := nil;
    Key := #0;
    Exit;
  end;

  if FocusedControl <> nil then begin
    if FocusedControl.AbstractVisible then begin
      Result := FocusedControl.KeyPress(Key);
      if Key = #0 then begin
        Result := True;
        Exit;
      end;
    end else
      ReleaseDFocus;
  end;

  if Assigned(FOnKeyPress) then begin
    FOnKeyPress(Self, Key);
    if Key = #0 then begin
      Result := True;
      Exit;
    end;
  end;

end;

function THGEWinManager.KeyDown(var Key: word; Shift: TShiftState): Boolean;
var
  I                         : Integer;
begin
  {if Assigned(FOnKeyDown) then begin
    FOnKeyDown(Self, Key, Shift);
    if Key = 0 then begin
      Result := True;
      Exit;
    end;
  end;}
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.AbstractVisible then begin
      with ModalDWindow do
        Result := KeyDown(Key, Shift);
      Exit;
    end else
      ModalDWindow := nil;
  end;

  if FocusedControl <> nil then begin
    if FocusedControl.AbstractVisible then begin
      Result := FocusedControl.KeyDown(Key, Shift);
      if Key = 0 then begin
        Result := True;
        Exit;
      end;
    end else
      ReleaseDFocus;
    {end else for i:=0 to DWinList.Count-1 do begin
       if THGEControl(DWinList[i]).Visible then begin
         if THGEControl(DWinList[i]).KeyDown(Key,Shift) then begin
           Result := TRUE;
           break;
         end;
       end;}
  end;

  if Assigned(FOnKeyDown) then begin
    FOnKeyDown(Self, Key, Shift);
    if Key = 0 then begin
      Result := True;
      Exit;
    end;
  end;
end;

function THGEWinManager.KeyUp(var Key: word; Shift: TShiftState): Boolean;
var
  FileName, s               : string;
  I                         : Integer;
begin
  case Key of
    {VK_RETURN: begin
        if ssAlt in Shift then begin
          FHGE.System_SetState(HGE_Windowed, not FHGE.System_GetState(HGE_WINDOWED));
          Key := 0;
          Result := True;
          exit;
        end;
      end;}
    VK_PAUSE: begin
        //FileName := ExtractFilePath(Application.ExeName);
        //if FileName[Length(FileName)] <> '\' then
        //  FileName := FileName + '\';
        //FileName := FileName + 'Images\';

        FileName := '.\Images\';
        ForceDirectories(FileName);
        I := 1;
        repeat
          s := FileName + format('Legend_%.4d.BMP', [I]);
          if not FileExists(s) then Break;
          Inc(I);
        until False;
        g_WinHGE.System_Snapshot(s);
        if Assigned(FOnSnapshot) then
          FOnSnapshot(Self, s);
        Key := 0;
        Result := True;
        Exit;
      end;
  end;
  {if Assigned(FOnKeyUp) then begin
    FOnKeyUp(Self, Key, Shift);
    if Key = 0 then begin
      Result := True;
      Exit;
    end;
  end;}

  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.AbstractVisible then begin
      with ModalDWindow do
        Result := KeyUp(Key, Shift);
      Exit;
    end else
      ModalDWindow := nil;
  end;

  if FocusedControl <> nil then begin
    if FocusedControl.AbstractVisible then begin
      Result := FocusedControl.KeyUp(Key, Shift);
      if Key = 0 then begin
        Result := True;
        Exit;
      end;
    end else
      ReleaseDFocus;
  end;

  if Assigned(FOnKeyUp) then begin
    FOnKeyUp(Self, Key, Shift);
    Result := True;
    if Key = 0 then begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure THGEWinManager.LoadCursorFromIni(sec: string);
var
  I, J                      : Integer;
  P, E                      : PCursorRec;
  s, s1                     : string;
  Tex                       : ITexture;
  FPS                       : Integer;
  Count                     : Integer;
  W, H                      : Single;
  c                         : HCURSOR;
begin
  for I := crSizeAll to crDefault do begin
    s := FHGE.Ini_GetString(sec, IntToStr(I) + '_Pic', '');
    if s = '' then Continue;
    //检查是否PNG格式，如果是，则为自绘鼠标，否则为系统鼠标
    s1 := s;
    Delete(s1, 1, Length(s1) - 3);
    if UpperCase(s1) = 'PNG' then begin
      Tex := FHGE.Texture_Load(s);
      if Tex = nil then Continue;
      FPS := FHGE.Ini_GetInt(sec, IntToStr(I) + '_FPS', 1);
      Count := FHGE.Ini_GetInt(sec, IntToStr(I) + '_Frames', 1);
      New(P);
      P.Index := I;
      W := Tex.GetWidth(True) / Count;
      H := Tex.GetHeight(True);
      P.Handle := THGEAnimation.Create(Tex, Count, FPS, 0, 0, W, H);
      J := FHGE.Ini_GetInt(sec, IntToStr(I) + '_Center', 0);
      if J = 1 then
        P.Handle.SetHotSpot(W / 2, H / 2)
      else if J = 2 then
        P.Handle.SetHotSpot(W / 2, 0);
      //加到链表首
      if FCursorList = nil then begin
        FCursorList := P;
      end else begin
        P.Next := FCursorList;
        FCursorList := P;
      end;
    end else begin
      c := LoadCursorFromFile(PChar(s));
      if c <> 0 then
        Screen.Cursors[I] := c;
    end;
  end;
  SetCursor(crDefault);
end;

function THGEWinManager.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
  H, oldMI                  : THGEControl;
begin
  Result := False;
  X := Round(X * rHorRate);
  Y := Round(Y * rVerRate);
  FMX := X;
  FMY := Y;

  oldMI := MouseInControl;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseMove(Shift, LocalX(X), LocalY(Y));
      Result := True;
      if (MouseInControl <> nil) and (MouseInControl <> oldMI) then
        SetCursor(MouseInControl.cursor);
      Exit;
    end else
      ModalDWindow := nil;
  end;

  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseMove(Shift, LocalX(X), LocalY(Y));
  end else begin
    for I := 0 to DWinList.Count - 1 do begin
      H := THGEControl(DWinList[I]);
      if H.Visible then begin
        if H.MouseMove(Shift, X, Y) then begin
          Result := True;
          Break;
        end;
        if H.WantReturn then begin      //1234
          //H.WantReturn := False;
          Result := True;
          Break;
        end;
      end;
    end;
  end;

  if (MouseInControl <> nil) then begin
    if (G_PopMenu <> nil) then begin
      SetCursor(crDefault)
    end else
      SetCursor(MouseInControl.cursor);
  end;

  if not Result and Assigned(FOnMouseMoveRet) then begin
    SetCursor(crDefault);               //1111
    Result := FOnMouseMoveRet(Self, Shift, X, Y);
    if Result then
      Exit;
  end;
end;

function THGEWinManager.MouseDoubleClick(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := True;
  if Button = mbLeft then               //1111
    Self.DblClick(X, Y);
end;

function THGEWinManager.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  X := Round(X * rHorRate);
  Y := Round(Y * rVerRate);

  FHintLabel.Caption := '';

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
  end;

  if not Result then begin
    for I := 0 to DWinList.Count - 1 do begin
      if THGEControl(DWinList[I]).Visible then begin
        if THGEControl(DWinList[I]).MouseDown(Button, Shift, X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;

  if not Result and Assigned(FOnMouseDownRet) then begin
    Result := FOnMouseDownRet(Self, Button, Shift, X, Y);
    if Result then
      Exit;
  end;
end;

function THGEWinManager.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  X := Round(X * rHorRate);
  Y := Round(Y * rVerRate);

  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do begin
        if ModalDWindow.WantReturn then //1234
          ModalDWindow.WantReturn := False;
        Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      end;
      Exit;
    end else
      ModalDWindow := nil;
  end;

  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do begin
      if MouseCaptureControl.WantReturn then //1234
        MouseCaptureControl.WantReturn := False;
      Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
    end;
  end else begin
    for I := 0 to DWinList.Count - 1 do begin
      if THGEControl(DWinList[I]).Visible then begin
        if THGEControl(DWinList[I]).WantReturn then //1234
          THGEControl(DWinList[I]).WantReturn := False;
        if THGEControl(DWinList[I]).MouseUp(Button, Shift, X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
  if not Result then ReleaseCapture;

  if not Result and Assigned(FOnMouseUpRet) then begin
    Result := FOnMouseUpRet(Self, Button, Shift, X, Y);
    if Result then
      Exit;
  end;
end;

function THGEWinManager.MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean;
var
  I                         : Integer;
  P                         : TPoint;
begin
  Result := False;

  X := Round(X * rHorRate);
  Y := Round(Y * rVerRate);

  P.X := X;
  P.Y := Y;
  Windows.ScreenToClient(FHGE.System_GetState(HGE_HWND), P);
  X := P.X;
  Y := P.Y;

  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseWheel(Shift, LocalX(X), LocalY(Y), Z);
      Result := True;
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseWheel(Shift, LocalX(X), LocalY(Y), Z);
  end else begin
    for I := 0 to DWinList.Count - 1 do begin
      if THGEControl(DWinList[I]).Visible then begin
        if THGEControl(DWinList[I]).MouseWheel(Shift, X, Y, Z) then begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;

  if not Result and Assigned(FOnMouseWheelRet) then begin
    Result := FOnMouseWheelRet(Self, Shift, X, Y, Z);
    if Result then
      Exit;
  end;
end;

function THGEWinManager.ProcessKey: Boolean;
var
  AControl                  : THGEControl;
begin
  Result := False;
  AControl := MouseInControl;
  g_GE.IME.Update(Self);

  if (MouseInControl = nil) or (MouseInControl <> AControl) or NeedFlushHint then begin //指向另一个对象
    if Assigned(FOnHint) then
      FOnHint(MouseInControl)
    else begin
      if (MouseInControl = nil) or not MouseInControl.Enabled then
        FHintLabel.Caption := ''
      else begin
        FHintLabel.ShowHint := False;
        if (MouseInControl <> nil) and MouseInControl.ShowHint then
          FHintLabel.ShowHint := True;
        FHintLabel.Caption := MouseInControl.Hint;
        FHintShow := False;
        FShowHintTick := GetTickCount;
      end;
    end;
  end;
  NeedFlushHint := False;
  Result := True;
end;

function THGEWinManager.ProcessLast: Boolean;
begin
  Result := False;
  if Assigned(FOnProcessLast) then
    FOnProcessLast(Self);
end;

function THGEWinManager.ProcessMouse: Boolean;
begin
  Result := True;
  if FCursor <> nil then FCursor.Update(FHGE.Timer_GetDelta);
end;

procedure THGEWinManager.Render;
var
  I                         : Integer;
begin
  G_PopMenu := nil;
  for I := 0 to DWinList.Count - 1 do begin
    if THGEControl(DWinList[I]).Visible then begin
      THGEControl(DWinList[I]).Render;
    end;
  end;
end;

procedure THGEWinManager.RenderTop;
var
  HintBackWidth, HintBackHeight: Integer;
  I                         : Integer;
begin
  //顶层窗口渲染
  for I := 0 to g_TopRenderList.Count - 1 do
    THGEControl(g_TopRenderList[I]).Render;
  g_TopRenderList.Clear;

  //最顶层窗口的显示
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then
      ModalDWindow.Render;
  end;

  //提示信息的显示
  if FHintLabel.Spr <> nil then begin
    if (FHintHidePause = 0) or (Integer(GetTickCount - FShowHintTick) < Integer(FHintHidePause + FHintPause)) then begin
      if GetTickCount - FShowHintTick > FHintPause then begin
        if FHintBackTex = nil then begin
          HintBackWidth := 0;
          HintBackHeight := 0;
        end else begin
          HintBackWidth := FHintBackPoint1.X + (FHintBackTex.GetWidth(True) - FHintBackPoint2.X);
          HintBackHeight := FHintBackPoint1.Y + (FHintBackTex.GetHeight(True) - FHintBackPoint2.Y);
        end;
        if not FHintShow then begin
          if FHintLabel.ShowHint then begin
            FHintLabel.Left := FMX + 0; //32;
            FHintLabel.Top := FMY - 28; //32;
            if FHintLabel.Left + FHintLabel.Width + HintBackWidth > SCREENWIDTH then
              FHintLabel.Left := SCREENWIDTH - FHintLabel.Width - HintBackWidth;
            if FHintLabel.Top + FHintLabel.Height + HintBackHeight > SCREENHEIGHT then
              FHintLabel.Top := FMY - FHintLabel.Height - HintBackHeight;
          end else begin
            FHintLabel.Left := FMX + 0; //32;
            FHintLabel.Top := FMY + 28; //32;
            if FHintLabel.Left + FHintLabel.Width + HintBackWidth > SCREENWIDTH then
              FHintLabel.Left := SCREENWIDTH - FHintLabel.Width - HintBackWidth;
            if FHintLabel.Top + FHintLabel.Height + HintBackHeight > SCREENHEIGHT then
              FHintLabel.Top := FMY - FHintLabel.Height - HintBackHeight;
          end;
          FHintShow := True;
        end;
        //显示提示背景
        if FHintBackTex <> nil then
          RenderBox(FHintBackTex,
            FHintBackPoint1,
            FHintBackPoint2,
            FHintLabel.Left - FHintBackPoint1.X,
            FHintLabel.Top - FHintBackPoint1.Y,
            FHintLabel.Width + HintBackWidth,
            FHintLabel.Height + HintBackHeight);
        FHintLabel.FSpr.Render(FHintLabel.Left, FHintLabel.Top);
      end;
    end else
      FHintLabel.Caption := '';
  end;

  //输入法的显示
  g_GE.IME.Render(Self);

  if (G_PopMenu <> nil) then begin
    G_PopMenu.Render;
  end;

  if Assigned(FOnRenderTop) then
    FOnRenderTop(Self);

  //鼠标的显示
  if FHGE.System_GetState(HGE_HIDEMOUSE) and (FCursor <> nil) {and FHGE.Input_IsMouseOver } then FCursor.Render(FMX, FMY);
end;

procedure THGEWinManager.SetCursor(cursor: TCursor);
var
  P                         : PCursorRec;
begin
  if FCursorIndex = cursor then Exit;
  FCursorIndex := cursor;
  P := FCursorList;
  while (P <> nil) and (P.Index <> cursor) do
    P := P.Next;
  if (P <> nil) and (FCursor <> P.Handle) then begin
    FCursor := P.Handle;
    if FCursor <> nil then begin
      FCursor.Play;
      FHGE.System_SetState(HGE_HIDEMOUSE, True);
    end else begin
      FHGE.System_SetState(HGE_HIDEMOUSE, False);
      Screen.cursor := cursor;
    end;
  end else if P = nil then begin
    FHGE.System_SetState(HGE_HIDEMOUSE, False);
    Screen.cursor := cursor;
  end else FHGE.System_SetState(HGE_HIDEMOUSE, True);
end;

procedure THGEWinManager.SetHintBackTex(const Value: ITexture);
begin
  FHintBackTex := Value;
  if Value = nil then begin
    FHintLabel.BorderWidth := 6;
    FHintLabel.Transparent := False;
    FHintLabel.Alpha := $D8;
  end else begin
    FHintLabel.BorderWidth := 0;
    FHintLabel.Transparent := True;
    FHintLabel.Alpha := $FF;
  end;
end;

procedure THGEWinManager.WindowMsgProce(Window: HWnd; Msg: UINT; wParam: wParam;
  lParam: lParam);
begin
  if FocusedControl <> nil then begin
    if FocusedControl.Visible and FocusedControl.Enabled then
      FocusedControl.WindowMsgProce(Window, Msg, wParam, lParam);
  end;
end;

function THGEWinManager.DblClick(X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  X := Round(X * rHorRate);
  Y := Round(Y * rVerRate);
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
    for I := 0 to DWinList.Count - 1 do begin
      if THGEControl(DWinList[I]).Visible then begin
        if THGEControl(DWinList[I]).DblClick(X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function THGEWinManager.Click(X, Y: Integer): Boolean;
var
  I                         : Integer;
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
    for I := 0 to DWinList.Count - 1 do begin
      if THGEControl(DWinList[I]).Visible then begin
        if THGEControl(DWinList[I]).Click(X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

{ THGELabel }

procedure THGELabel.AdjustBounds;
const
  WordWraps                 : array[Boolean] of word = (0, DT_WORDBREAK);
var
  DC                        : HDC;
  X                         : Integer;
  Rect                      : TRect;
  AAlignment                : TAlignment;
begin
  if not (csReading in ComponentState) and FAutoSize then begin
    Rect := Bounds(0, 0, Width, Height);
    DC := GetDC(0);
    Canvas.Handle := DC;
    DoDrawText(Canvas, Rect, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[FWordWrap]);
    Canvas.Handle := 0;
    ReleaseDC(0, DC);
    X := Left;
    AAlignment := FAlignment;
    if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);
    if AAlignment = taRightJustify then Inc(X, Width - Rect.Right);
    if FStress then begin
      Rect.Right := Rect.Right + 2;
      Rect.Bottom := Rect.Bottom + 2;
    end;
    SetBounds(X, Top, Rect.Right, Rect.Bottom);
  end;
end;

constructor THGELabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Font.Color := clWhite;
  Font.OnChange := FontChanged;
  FAutoSize := False;
  FPasswordChr := #0;
  FAutoCheckInRange := False;
  FNeedRedraw := True;
  FStress := False;
  FWideBrush := 1;
  FStressColor := clRed;
  FStream := TMemoryStream.Create;
  FrameBrushColor := clBlack;
end;

destructor THGELabel.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

procedure THGELabel.DoDrawText(ACanvas: TCanvas; var Rect: TRect; Flags: Integer);
var
  Text                      : string;
  lpRect                    : TRect;
begin
  Text := GetShowingText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '')) then Text := Text + ' ';
  Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);
  ACanvas.Font.PixelsPerInch := 96;
  ACanvas.Font := Font;
  if not Enabled then begin
    OffsetRect(Rect, 1, 1);
    ACanvas.Font.Color := clBtnHighlight;
    DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    ACanvas.Font.Color := clBtnShadow;
    DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end else begin
    if FStress then begin
      ACanvas.Font.Color := FStressColor;

      lpRect := Classes.Rect(Rect.Left - 1, Rect.Top + 0, Rect.Right, Rect.Bottom);
      DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
      lpRect := Classes.Rect(Rect.Left + 1, Rect.Top + 0, Rect.Right, Rect.Bottom);
      DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
      lpRect := Classes.Rect(Rect.Left + 0, Rect.Top - 1, Rect.Right, Rect.Bottom);
      DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
      lpRect := Classes.Rect(Rect.Left + 0, Rect.Top + 1, Rect.Right, Rect.Bottom);
      DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);

      ACanvas.Font := Font;
      DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    end else
      DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end;
end;

procedure THGELabel.FontChanged(Sender: TObject);
begin
  Canvas.Font.PixelsPerInch := 96;
  Canvas.Font := Font;
  Canvas.Font.Assign(Font);
  FNeedRedraw := True;
end;

function THGELabel.GetShowingText: string;
begin
  if FPasswordChr = #0 then
    Result := FCaption
  else begin
    SetLength(Result, Length(FCaption));
    if Length(FCaption) > 0 then
      FillChar(Result[1], Length(FCaption), FPasswordChr);
  end;
end;

function THGELabel.GetSpr: IHGESprite;
begin
  if FNeedRedraw then ReDraw;
  Result := FSpr;
end;

procedure THGELabel.LoadFromIni(sec, Key: string);
begin
  BorderWidth := FHGE.Ini_GetInt(sec, Key + '_BorderWidth', BorderWidth);
  Color := FHGE.Ini_GetInt(sec, Key + '_BackColor', Color);
  Transparent := FHGE.Ini_GetInt(sec, Key + '_Transparent', Integer(FTransparent)) = 1;
  Font.Name := FHGE.Ini_GetString(sec, Key + '_FontName', Font.Name);
  Font.Size := FHGE.Ini_GetInt(sec, Key + '_FontSize', Font.Size);
  Font.Color := FHGE.Ini_GetInt(sec, Key + '_FontColor', Font.Color);
  Canvas.Font.Assign(Font);
  FAlignment := TAlignment(FHGE.Ini_GetInt(sec, Key + '_Alignment', Integer(FAlignment)));
  if FHGE.Ini_GetInt(sec, Key + '_Bold', 0) = 1 then
    Font.Style := Font.Style + [fsBold];
  FStress := FHGE.Ini_GetInt(sec, Key + '_Stress', Integer(FStress)) = 1;
  FStressColor := FHGE.Ini_GetInt(sec, Key + '_StressColor', FStressColor);
  FAutoSize := FHGE.Ini_GetInt(sec, Key + '_AutoSize', Integer(FAutoSize)) = 1;
  inherited LoadFromIni(sec, Key);
  FNeedRedraw := True;
end;

procedure THGELabel.ReDraw;
const
  Alignments                : array[TAlignment] of word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps                 : array[Boolean] of word = (0, DT_WORDBREAK);
var
  NeedUpdate                : Boolean;
  Rect, CalcRect            : TRect;
  DrawStyle                 : Longint;
  //Bmp                       : TBitmap;
  //png                       : TPNGObject;
  Size, J                   : Integer;
  data                      : Pointer;
  Res                       : IResource;
  FrameBrush                : HBRUSH;
  wSingle                   : Integer;
begin
  NeedUpdate := FNeedRedraw;
  FNeedRedraw := False;

  FSpr := nil;
  if FAutoSize then begin
    Width := 0;
    Height := 0;
  end;
  if (Length(FCaption) = 0) and FAutoSize then Exit;

  //Bmp := TBitmap.Create;
  //png := TPNGObject.Create;
  FStream.Clear;
  try
    FBmp.Width := 0;
    FBmp.Height := 0;
    FBmp.Canvas.Font.PixelsPerInch := 96;
    FBmp.Canvas.Font := Font;
    FBmp.PixelFormat := pf32bit;
    FBmp.TransparentMode := tmFixed;

    wSingle := Canvas.TextWidth('A');
    if FTransparent then begin
      if Font.Color = clBlack then
        FBmp.TransparentColor := clWhite
      else
        FBmp.TransparentColor := clBlack;
      FBmp.Canvas.brush.Style := bsClear;
      FBmp.Canvas.brush.Color := FBmp.TransparentColor;
    end else begin
      FBmp.Canvas.brush.Color := Color;
      //FBmp.Canvas.brush.Color := clRed;
      FBmp.Canvas.brush.Style := bsSolid;
    end;
    FBmp.Transparent := FTransparent;

    if FAutoSize then
      AdjustBounds;

    //mod
    if FWideBrush > 0 then
      Rect := Bounds(BorderWidth + 2, BorderWidth + 2, _MAX(Width, wSingle * Length(FCaption)) + BorderWidth, Height + BorderWidth)
    else
      Rect := Bounds(BorderWidth, BorderWidth, _MAX(Width, wSingle * Length(FCaption)) + BorderWidth, Height + BorderWidth);

    DrawStyle := DT_EXPANDTABS or WordWraps[FWordWrap] or Alignments[FAlignment];

    CalcRect := Rect;
    DoDrawText(FBmp.Canvas, CalcRect, DrawStyle or DT_CALCRECT);
    if FStress then begin
      CalcRect.Right := CalcRect.Right + 2;
      CalcRect.Bottom := CalcRect.Bottom + 2;
    end;
    if FAutoSize then begin
      FBmp.Width := CalcRect.Right + BorderWidth * 2;
      FBmp.Height := CalcRect.Bottom + BorderWidth * 2;
    end else begin
      FBmp.Width := Width;
      FBmp.Height := Height;
    end;

    if FLayout = tlBottom then
      OffsetRect(Rect, 0, Height - CalcRect.Bottom)
    else if FLayout = tlCenter then
      OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);

    if BorderWidth <> 0 then begin
      FrameBrush := CreateSolidBrush(ColorToRGB(FrameBrushColor {clBlack}));
      FrameRect(FBmp.Canvas.Handle, Classes.Rect(0, 0, FBmp.Width, FBmp.Height), FrameBrush);
      DeleteObject(FrameBrush);
    end;

    FBmp.Canvas.brush.Style := bsClear;
    DoDrawText(FBmp.Canvas, Rect, DrawStyle);

    if NeedUpdate and Assigned(FOnAfterDraw) then
      FOnAfterDraw(FBmp);

    if (FBmp.Width = 0) or (FBmp.Height = 0) then Exit;

    FPng.Assign(FBmp);
    FPng.SaveToStream(FStream);
    FStream.Seek(soFromBeginning, 0);

    FTexture := nil;
    FTexture := FHGE.Texture_Load(FStream.Memory, FStream.Size);
    if FTexture <> nil then begin
      FSpr := THGESprite.Create(FTexture, 0, 0, FBmp.Width, FBmp.Height);
      if (DParent <> nil) and (ModalDWindow <> nil) and not IsChild(ModalDWindow) then begin
        FSpr.SetColor(ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT));
      end else begin
        FSpr.SetColor(ARGB(FAlpha, FLight, FLight, FLight));
      end;
    end;
    Res := nil;
    if FAutoSize then begin
      Width := FBmp.Width;
      Height := FBmp.Height;
    end;
  finally
    //Bmp.Free;
    //png.Free;
  end;
end;

procedure THGELabel.DoRender;
begin
  if FNeedRedraw then ReDraw;
  inherited DoRender;
end;

procedure THGELabel.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    SetCaption(FCaption);
  end;
end;

procedure THGELabel.SetAutoSize(const Value: Boolean);
begin
  //if FAutoSize <> Value then begin
  FAutoSize := Value;
  //AdjustBounds;
  FNeedRedraw := True;
  //end;
end;

procedure THGELabel.SetCaption(const Value: string);
begin
  FCaption := Value;
  FNeedRedraw := True;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure THGELabel.SetLayout(const Value: TTextLayout);
begin
  FLayout := Value;
  FNeedRedraw := True;
end;

procedure THGELabel.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  FNeedRedraw := True;
end;

procedure THGELabel.SetWordWrap(const Value: Boolean);
begin
  if FWordWrap <> Value then begin
    FWordWrap := Value;
    FNeedRedraw := True;
  end;
end;

{ THGECheckBox }

procedure THGECheckBox.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then begin
    FChecked := Value;
    FNeedUpdate := True;
  end;
end;

procedure THGECheckBox.SetTexture(const Tex: ITexture);
var
  I, W, H, X                : Integer;
begin
  FNeedUpdate := False;
  if Tex = nil then Exit;
  FTexture := Tex;

  if not Enabled then
    I := 3
  else if THGEButton(Self).FDowned then begin
    if FFlashed and (FFlashState = 1) then
      I := 1
    else
      I := 2;
  end else if THGEButton(Self).IsMouseIn then begin
    if FFlashed and (FFlashState = 1) then
      I := 0
    else
      I := 1;
  end else begin
    if FFlashed and (FFlashState = 1) then
      I := 1
    else
      I := 0;
  end;

  //H := Tex.GetHeight(True) div 4;
  //W := Tex.GetWidth(True) div 2;
  //X := Integer(Checked) * W;

  //FSpr := THGESprite.Create(FTexture, 0, H * I, W, H);

  H := Tex.GetHeight(True);
  W := Tex.GetWidth(True);
  FTexture := Tex;
  FSpr := THGESprite.Create(FTexture, 0, H, W, H);
  if FSpr = nil then Exit;
  FSpr.SetHotSpot(0, 0);
  FSpr.SetBlendMode(BLEND_DEFAULT);
{$IFDEF DARK}
  if (ModalDWindow <> nil) and not IsChild(ModalDWindow) then begin
    Dark(True);
  end;
{$ENDIF}
end;

{ THGEEdit }

constructor THGEEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DefText := '';
  Width := 151;
  Height := 21;
  FAutoCheckInRange := False;
  FCertHeight := Height - 2;
  FAutoSize := False;
  FTransparent := True;
  FOnAfterDraw := AfterDraw;
  FCertDrawPos := BorderWidth + 1;
  FCanInput := True;
  FEnableFocus := True;
  FSelStart := -1;
  FSelEnd := -1;
  FWantReturns := False;
  FWantTabs := False;
  FCertLine := 0;
  FImeChar := False;
  FStartTextX := 0;
  FPopMenu := nil;
  FNumberOnly := False;
  FCursorColor := $FFFFFFFF;
  FCursor := crIBeam;
  FOnHotKeyChange := nil;
  FIsHotKey := False;
  HotKey := 0;
end;

destructor THGEEdit.Destroy;
begin
  if FPopMenu <> nil then FPopMenu.Free;
  inherited;
end;

procedure THGEEdit.AfterDraw(Bmp: TBitmap);
begin
  CalcCertDrawPos;
end;

procedure THGEEdit.CalcCertDrawPos;
var
  s                         : string;
begin
  FCertDrawPos := BorderWidth;
  s := GetShowingText;
  if FCertPos <> 0 then
    FCertDrawPos := FCertDrawPos + Canvas.TextWidth(System.Copy(s, 1, FCertPos)) + 1 - FStartTextX;
  if FCertDrawPos > Width - BorderWidth + 1 then
    FCertDrawPos := Width - BorderWidth + 1;

  FCertHeight := Canvas.TextHeight('a') + 2;
  FCertTop := SurfaceY(Top) + BorderWidth + 1;

  g_GE.IME.AdjustImmPos(SurfaceX(Left) + FCertDrawPos, FCertTop, FCertHeight);
end;

function THGEEdit.GetCharPosByPixel(X: Integer): Integer; //根据鼠标位置获得在字符串中的位置
var
  sText, s                  : string;
  I, A, offset              : Integer;
begin
  Result := 0;
  sText := GetShowingText;
  if Length(sText) = 0 then Exit;

  A := Canvas.TextWidth('a');
  X := _MAX(0, X - Left);
  X := _MIN(A * Length(sText), X);

  offset := X div A;
  case ByteType(sText, offset + 1) of
    mbSingleByte: I := offset;
    mbLeadByte: I := offset;
    mbTrailByte: begin                  //多字节字符首字节之后的字符
        if offset mod 2 = 0 then begin
          if X mod A > A div 2 then
            I := offset + 1
          else
            I := offset - 1;
        end else begin
          if X mod (A * 2) > A then
            I := offset + 1
          else
            I := offset - 1;
        end;
      end;
  end;
  Result := I;

  {
  X := X - Left;
  s := '';
  I := 1;
  while I <= Length(sText) do begin
    s := s + sText[I];
    if (sText[I] >= #128) and (I < Length(sText)) then begin
      s := s + sText[I + 1];
      Inc(I);
    end;
    if Canvas.TextWidth(s) > X then begin
      Break;
    end else begin
      Result := I;
    end;
    Inc(I);
  end;}
end;

function THGEEdit.GetSelLength: Integer;
begin
  Result := Abs(FSelStart - FSelEnd);
end;

procedure THGEEdit.SetSelLength(Value: Integer);
begin
  FStartTextX := 0;
  SetSelStart(Value - 1);
  SetSelEnd(Value - 1);
end;

function THGEEdit.GetSelText: string;
begin
  if FSelStart = -1 then
    Result := ''
  else begin
    if FSelStart < FSelEnd then
      Result := System.Copy(FCaption, FSelStart + 1, FSelEnd - FSelStart)
    else
      Result := System.Copy(FCaption, FSelEnd + 1, FSelStart - FSelEnd)
  end;
end;

procedure THGEEdit.SetHotKey(Value: Cardinal);
begin
  if FHotKey <> Value then begin
    FHotKey := Value;
    Caption := HotKeyToText(Value, True);
  end;
end;

procedure THGEEdit.SetOfHotKey(HotKey: Cardinal);
begin
  if Assigned(FOnHotKeyChange) then
    FOnHotKeyChange(Self, HotKey);
end;

function THGEEdit.KeyDown(var Key: word; Shift: TShiftState): Boolean;
var
  OldCertPos, I             : Integer;
  s, sText                  : string;
  c                         : Char;
  HWindow                   : HWnd;
  M                         : word;
  HK                        : Cardinal;
begin
  Result := False;

  if (FocusedControl <> Self) or not Enabled then Exit;

  s := FCaption;
  try
    if FIsHotKey then begin
      if Key in [VK_BACK, VK_DELETE] then begin
        if (FHotKey <> 0) then
          FHotKey := 0;
        Caption := '';
        Exit;
      end;
      if (Key = VK_TAB) or (Char(Key) in ['A'..'Z', 'a'..'z']) then begin
        M := 0;
        if ssCtrl in Shift then M := M or MOD_CONTROL;
        if ssAlt in Shift then M := M or MOD_ALT;
        if ssShift in Shift then M := M or MOD_SHIFT;
        HK := GetHotKey(M, Key);
        if (HK <> 0) and (FHotKey <> 0) then begin
          FHotKey := 0;
          Caption := '';
        end;
        if (HK <> 0) then SetOfHotKey(HK);
      end;
      Exit;
    end;

    OldCertPos := FCertPos;
    if (Char(Key) in ['0'..'9', 'A'..'Z', 'a'..'z']) then
      SetBlink(True);

    case Key of                         //处理编辑键
      VK_LEFT: begin
          if FCertPos > 0 then begin
            if FCaption[FCertPos] >= #128 then begin
              CertPos := FCertPos - 2;
            end else begin
              CertPos := FCertPos - 1;
            end;
            Result := True;
          end else Exit;
        end;
      VK_RIGHT: begin
          if FCertPos < Length(FCaption) then begin
            if FCaption[FCertPos + 1] >= #128 then
              CertPos := FCertPos + 2
            else
              CertPos := FCertPos + 1;
            Result := True;
          end else Exit;
        end;
      VK_HOME: begin
          FCertPos := 0;
          CalcCertDrawPos;
          if (ssShift in Shift) and (FSelStart <> -1) then SelEnd := FCertPos;
          Result := True;
        end;
      VK_END: begin
          FCertPos := Length(FCaption);
          CalcCertDrawPos;
          Result := True;
        end;
      VK_DELETE: begin
          //有选中文字的情况
          if GetSelLength > 0 then begin //删除选择的文字，并清除选中
            if FSelStart < FSelEnd then begin
              FCaption := System.Copy(FCaption, 1, FSelStart) + System.Copy(FCaption, FSelEnd + 1, Length(FCaption) - FSelEnd);
              CertPos := FSelStart;
            end else begin
              FCaption := System.Copy(FCaption, 1, FSelEnd) + System.Copy(FCaption, FSelStart + 1, Length(FCaption) - FSelStart);
              CertPos := FSelEnd;
            end;
            SelStart := -1;
            SelEnd := -1;               //取消选择
          end else if FCertPos < Length(FCaption) then begin
            if (FCaption[FCertPos + 1] >= #128) and ((FCertPos < Length(FCaption) - 1) and (FCaption[FCertPos + 2] >= #128)) then begin
              FCaption := System.Copy(FCaption, 1, FCertPos) + System.Copy(FCaption, FCertPos + 3, Length(FCaption) - FCertPos + 1);
              //CertPos:=FCertPos - 2;
            end else begin
              FCaption := System.Copy(FCaption, 1, FCertPos) + System.Copy(FCaption, FCertPos + 2, Length(FCaption) - FCertPos + 1);
              //CertPos:=FCertPos - 1;
            end;
          end;
          FNeedRedraw := True;
          //if Assigned(FOnChange) then FOnChange(Self);
          Result := True;
        end;
      67: if PasswordChr = #0 then begin //Ctrl+C 拷贝
          if ssCtrl in Shift then begin
            if (GetSelLength > 0) then
              Clipboard.AsText := GetSelText;
          end;
          Exit;
        end;
      86: begin                         //Ctrl+V 粘贴
          if ssCtrl in Shift then begin
            sText := Clipboard.AsText;
            for I := 1 to Length(sText) do begin
              c := sText[I];
              KeyPress(c);
            end;
          end;
          Exit;
        end;
      88: begin                         //Ctrl+X 剪切
          if ssCtrl in Shift then begin
            Key := 67;
            KeyDown(Key, Shift);
            Key := VK_DELETE;
            KeyDown(Key, []);
          end;
          Exit;
        end;
    else begin
        Result := inherited KeyDown(Key, Shift);
        Exit;
      end;
    end;
    if (ssShift in Shift) and Result then begin
      if (FSelStart = FSelEnd) then SelStart := OldCertPos;
      if (FSelStart <> -1) then SelEnd := FCertPos;
    end else if FSelStart <> -1 then begin
      SelStart := -1;
      SelEnd := -1;
    end;
  finally
    if (s <> FCaption) and Assigned(FOnChange) then FOnChange(Self);
  end;
end;

function THGEEdit.KeyPress(var Key: Char): Boolean;
var
  W                         : word;
  s                         : string;
begin
  Result := False;
  if not Enabled or FIsHotKey then Exit;

  if Assigned(FOnKeyPress) then
    FOnKeyPress(Self, Key);

  s := FCaption;
  try
    case ord(Key) of
      0: begin                          //已经在事件中处理掉了
          Result := True;
          Exit;
        end;
      1: begin
          if (Caption <> '') then begin //CTRL + A
            FSelStart := 0;
            FSelEnd := Length(Caption);
            FCertPos := FSelEnd;
          end;
        end;
      VK_BACK: begin
          //有选中文字的情况
          if GetSelLength > 0 then begin //删除选择的文字，并清除选中
            if FSelStart < FSelEnd then begin
              FCaption := System.Copy(FCaption, 1, FSelStart) + System.Copy(FCaption, FSelEnd + 1, Length(FCaption) - FSelEnd);
              CertPos := FSelStart;
            end else begin
              FCaption := System.Copy(FCaption, 1, FSelEnd) + System.Copy(FCaption, FSelStart + 1, Length(FCaption) - FSelStart);
              CertPos := FSelEnd;
            end;
            SelStart := -1;
            SelEnd := -1;               //取消选择
          end else if FCertPos > 0 then begin
            if (FCaption[FCertPos] >= #128) and ((FCertPos > 1) and (FCaption[FCertPos - 1] >= #128)) then begin
              FCaption := System.Copy(FCaption, 1, FCertPos - 2) + System.Copy(FCaption, FCertPos + 1, Length(FCaption) - FCertPos + 1);
              CertPos := FCertPos - 2;
            end else begin
              FCaption := System.Copy(FCaption, 1, FCertPos - 1) + System.Copy(FCaption, FCertPos + 1, Length(FCaption) - FCertPos + 1);
              CertPos := FCertPos - 1;
            end;
          end;
          //if Assigned(FOnChange) then FOnChange(Self);
        end;
      VK_TAB: begin
          GetNextInputControl(True);
          Result := True;
          Exit;
        end;
      VK_ESCAPE: begin
          Exit;
        end;
    else if (((Key = #13) and FWantReturns) or (Key >= #32)) and ((Length(FCaption) < FMaxLength) or (GetSelLength > 0)) then begin
      if FNumberOnly then begin         //仅限数字输入
        if not (Key in ['0'..'9', '.', '-']) then Exit;
        //检查小数点是否只有一个
        if Key = '.' then begin
          if Pos('.', FCaption) > 0 then Exit; //只允许一个小数点
        end;
        if Key = '-' then begin

        end;
      end;

      if GetSelLength > 0 then begin
        W := VK_DELETE;
        KeyDown(W, []);
      end;
      if Key > #$80 then begin
        if FImeChar then begin
          FImeChar := False;
          if Length(FCaption) < FMaxLength then begin
            Insert(Key, FCaption, FCertPos + 1);
            CertPos := FCertPos + 1;
          end else
            Beep;
        end else begin
          if Length(FCaption) + 1 < FMaxLength then begin
            FImeChar := True;
            Insert(Key, FCaption, FCertPos + 1);
            CertPos := FCertPos + 1;
          end else
            Beep;
        end;
      end else begin
        FImeChar := False;
        Insert(Key, FCaption, FCertPos + 1);
        CertPos := FCertPos + 1;
      end;

      //if Assigned(FOnChange) then FOnChange(Self);
    end;
    end;
    SetBlink(True);
    FNeedRedraw := True;
    //if Assigned(FOnChange) then FOnChange(Self);  //1111
    Result := True;
  finally
    if (s <> FCaption) and Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure THGEEdit.LoadFromIni;
begin
  inherited LoadFromIni(sec, Key);
end;

function THGEEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;

  if (FPopMenu <> nil) and FPopMenu.Visible then
    Result := FPopMenu.MouseDown(Button, Shift, SurfaceX(X), SurfaceY(Y));

  if not Result and inherited MouseDown(Button, Shift, X, Y) then begin
    if (MouseCaptureControl = nil) then begin
      SetDCapture(Self);
    end;
    if (mbLeft = Button) then begin
      if not FIsHotKey then begin
        CertPos := GetCharPosByPixel(X + FStartTextX);
        SelStart := FCertPos;
        SelEnd := FCertPos;
      end;
    end;
    FNeedRedraw := True;                //1111
    Result := True;
  end;
end;

function THGEEdit.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  LastCertPos               : Integer;
begin
  if (FPopMenu <> nil) and FPopMenu.Visible then begin
    Result := FPopMenu.MouseMove(Shift, SurfaceX(X), SurfaceY(Y));
  end else
    Result := inherited MouseMove(Shift, X, Y);
  if (MouseCaptureControl = Self) and (ssLeft in Shift) then begin
    if not FIsHotKey then begin
      LastCertPos := CertPos;
      CertPos := GetCharPosByPixel(X + FStartTextX);
      SelEnd := FCertPos;
    end;
    if LastCertPos <> CertPos then
      FNeedRedraw := True;
  end;
end;

function THGEEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if (FPopMenu <> nil) and FPopMenu.Visible then
    Result := FPopMenu.MouseUp(Button, Shift, SurfaceX(X), SurfaceY(Y));
  if not Result and inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y) then begin
        if (Button = mbLeft) and Assigned(FOnClick) then
          FOnClick(Self, X, Y)
        else if not FIsHotKey and (mbRight = Button) then begin
          InitPopMenu;
          FPopMenu.Popup(SurfaceX(X), SurfaceY(Y), 0);
        end;
      end;
    end;
    Result := True;
    Exit;
  end else begin
    ReleaseDCapture;
  end;
end;

procedure THGEEdit.DoDrawText(ACanvas: TCanvas; var Rect: TRect; Flags: Integer);
var
  Text                      : string;
  lpRect                    : TRect;
const
  AOffset                   = 4;
begin
  Text := GetShowingText;

  Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);
  ACanvas.Font.PixelsPerInch := 96;
  ACanvas.Font := Font;

  if not Enabled then begin
    {OffsetRect(Rect, 1, 1);
    ACanvas.Font.Color := clBtnHighlight;
    DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    ACanvas.Font.Color := clBtnShadow;
    DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags); }
    ACanvas.Font.Color := clBtnShadow;
    if FAlignment = taCenter then begin
      lpRect := Classes.Rect(Rect.Left - AOffset, Rect.Top, Rect.Right - AOffset, Rect.Bottom);
      DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
    end else
      DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end else begin
    if FStress then begin
      if FAlignment = taCenter then begin
        ACanvas.Font.Color := FStressColor;
        lpRect := Classes.Rect(Rect.Left - 1 - AOffset, Rect.Top + 0, Rect.Right - AOffset, Rect.Bottom);
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
        lpRect := Classes.Rect(Rect.Left + 1 - AOffset, Rect.Top + 0, Rect.Right - AOffset, Rect.Bottom);
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
        lpRect := Classes.Rect(Rect.Left + 0 - AOffset, Rect.Top - 1, Rect.Right - AOffset, Rect.Bottom);
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
        lpRect := Classes.Rect(Rect.Left + 0 - AOffset, Rect.Top + 1, Rect.Right - AOffset, Rect.Bottom);
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
        ACanvas.Font := Font;
        lpRect := Classes.Rect(Rect.Left - AOffset, Rect.Top, Rect.Right - AOffset, Rect.Bottom);
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
      end else begin
        ACanvas.Font.Color := FStressColor;
        lpRect := Classes.Rect(Rect.Left - 1, Rect.Top + 0, Rect.Right, Rect.Bottom);
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
        lpRect := Classes.Rect(Rect.Left + 1, Rect.Top + 0, Rect.Right, Rect.Bottom);
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
        lpRect := Classes.Rect(Rect.Left + 0, Rect.Top - 1, Rect.Right, Rect.Bottom);
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
        lpRect := Classes.Rect(Rect.Left + 0, Rect.Top + 1, Rect.Right, Rect.Bottom);
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
        ACanvas.Font := Font;
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
      end;

      {ACanvas.Font.Color := FStressColor;
      Windows.TextOut(ACanvas.Handle, 0, 1, PChar(Text), Length(Text));
      Windows.TextOut(ACanvas.Handle, 2, 1, PChar(Text), Length(Text));
      Windows.TextOut(ACanvas.Handle, 1, 0, PChar(Text), Length(Text));
      Windows.TextOut(ACanvas.Handle, 1, 2, PChar(Text), Length(Text));
      ACanvas.Font := Font;
      Windows.TextOut(ACanvas.Handle, 1, 1, PChar(Text), Length(Text));}

    end else begin
      if FAlignment = taCenter then begin
        lpRect := Classes.Rect(Rect.Left - AOffset, Rect.Top, Rect.Right - AOffset, Rect.Bottom);
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), lpRect, Flags);
      end else begin
        DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
      end;
    end;
  end;
end;

procedure THGEEdit.ReDraw;
const
  Alignments                : array[TAlignment] of word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps                 : array[Boolean] of word = (0, DT_WORDBREAK);
var
  NeedUpdate                : Boolean;
  Rect, CalcRect            : TRect;
  DrawStyle                 : Longint;
  //Bmp                       : TBitmap;
  //png                       : TPNGObject;
  WidthX, Size, J           : Integer;
  data                      : Pointer;
  Res                       : IResource;
  FrameBrush                : HBRUSH;
  wSingle                   : Integer;

  nStart, nEnd, SX, X, Y    : Integer;
begin
  NeedUpdate := FNeedRedraw;
  FNeedRedraw := False;

  FSpr := nil;
  if FAutoSize then begin
    Width := 0;
    Height := 0;
  end;
  if (Length(FCaption) = 0) and FAutoSize then Exit;

  //Bmp := TBitmap.Create;
  //png := TPNGObject.Create;
  try
    FStream.Clear;
    FBmp.Width := 0;
    FBmp.Height := 0;
    FBmp.Canvas.Font.PixelsPerInch := 96;
    FBmp.Canvas.Font := Font;
    FBmp.PixelFormat := pf32bit;
    FBmp.TransparentMode := tmFixed;

    wSingle := Canvas.TextWidth('A');
    if FTransparent then begin
      if Font.Color = clBlack then
        FBmp.TransparentColor := clWhite
      else
        FBmp.TransparentColor := clBlack;
      FBmp.Canvas.brush.Style := bsClear;
      FBmp.Canvas.brush.Color := FBmp.TransparentColor;
    end else begin
      FBmp.Canvas.brush.Color := Color;
      FBmp.Canvas.brush.Style := bsSolid;
    end;
    FBmp.Transparent := FTransparent;

    WidthX := Canvas.TextWidth(Copy(FCaption, 1, FCertPos));
    if WidthX + wSingle div 2 - FStartTextX > Width then
      FStartTextX := WidthX + wSingle div 2 - Width;
    if ((WidthX - FStartTextX) < 0) then
      FStartTextX := FStartTextX + (WidthX - FStartTextX);

    if FAutoSize then
      AdjustBounds;

    //mod
    if FWideBrush > 0 then
      Rect := Bounds(BorderWidth + 2, BorderWidth + 2, _MAX(Width, wSingle * Length(FCaption)) + BorderWidth, Height + BorderWidth)
    else
      Rect := Bounds(BorderWidth, BorderWidth, _MAX(Width, wSingle * Length(FCaption)) + BorderWidth, Height + BorderWidth);

    DrawStyle := DT_EXPANDTABS or WordWraps[FWordWrap] or Alignments[FAlignment];

    CalcRect := Rect;
    DoDrawText(FBmp.Canvas, CalcRect, DrawStyle or DT_CALCRECT);
    if FStress then begin
      CalcRect.Right := CalcRect.Right + 2;
      CalcRect.Bottom := CalcRect.Bottom + 2;
    end;
    if FAutoSize then begin
      FBmp.Width := CalcRect.Right + BorderWidth * 2;
      FBmp.Height := CalcRect.Bottom + BorderWidth * 2;
    end else begin
      FBmp.Width := Width;
      FBmp.Height := Height;
    end;

    if FLayout = tlBottom then
      OffsetRect(Rect, 0, Height - CalcRect.Bottom)
    else if FLayout = tlCenter then
      OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);

    if BorderWidth <> 0 then begin
      if Enabled then begin
        if FocusedControl = Self then
          FrameBrush := CreateSolidBrush(ColorToRGB($007AAFBA {clBlack}))
        else
          FrameBrush := CreateSolidBrush(ColorToRGB($00406F77 {clBlack}))
      end else
        FrameBrush := CreateSolidBrush(ColorToRGB(clGray));

      if FIsHotKey then begin
        FrameRect(FBmp.Canvas.Handle, Classes.Rect(0, 0, FBmp.Width, FBmp.Height), FrameBrush);
        if FocusedControl = Self then
          FrameRect(FBmp.Canvas.Handle, Classes.Rect(1, 1, FBmp.Width - 1, FBmp.Height - 1), FrameBrush);
      end else begin
        FrameRect(FBmp.Canvas.Handle, Classes.Rect(0, 0, FBmp.Width, FBmp.Height), FrameBrush);
      end;
      DeleteObject(FrameBrush);
    end;

    FBmp.Canvas.brush.Style := bsClear;
    OffsetRect(Rect, -FStartTextX, 0);
    DoDrawText(FBmp.Canvas, Rect, DrawStyle);

    {Bmp.Width := Width;                 //_MAX(Width, wSingle * Length(FCaption));
    Bmp.Height := Height;
    Rect := Bounds(2 - 0, 2, Width - 0, Height);
    Bmp.Canvas.brush.Style := bsClear;
    if FStress then begin
      Bmp.Canvas.Font.Color := FStressColor;
      Bmp.Canvas.TextRect(Rect, 1 - FStartTextX, 2, GetShowingText);
      Bmp.Canvas.TextRect(Rect, 3 - FStartTextX, 2, GetShowingText);
      Bmp.Canvas.TextRect(Rect, 2 - FStartTextX, 1, GetShowingText);
      Bmp.Canvas.TextRect(Rect, 2 - FStartTextX, 3, GetShowingText);
      Bmp.Canvas.Font := Font;
      Bmp.Canvas.TextRect(Rect, 2 - FStartTextX, 2, GetShowingText);
    end else
      Bmp.Canvas.TextRect(Rect, 2 - FStartTextX, 2, GetShowingText);}

    if NeedUpdate and Assigned(FOnAfterDraw) then
      FOnAfterDraw(FBmp);

    if (FBmp.Width = 0) or (FBmp.Height = 0) then Exit;

    FPng.Assign(FBmp);
    FPng.SaveToStream(FStream);
    FStream.Seek(soFromBeginning, 0);

    FTexture := nil;
    FTexture := FHGE.Texture_Load(FStream.Memory, FStream.Size);
    if FTexture <> nil then begin
      FSpr := THGESprite.Create(FTexture, 0, 0, FBmp.Width, FBmp.Height);
      if (DParent <> nil) and (ModalDWindow <> nil) and not IsChild(ModalDWindow) then begin
        FSpr.SetColor(ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT));
      end else begin
        FSpr.SetColor(ARGB(FAlpha, FLight, FLight, FLight));
      end;
    end;

    Res := nil;
    if FAutoSize then begin
      Width := FBmp.Width;
      Height := FBmp.Height;
    end;
  finally
    //Bmp.Free;
    //png.Free;
  end;
end;

procedure THGEEdit.Render;
var
  FQuad                     : THGEQuad;
  II                        : Integer;
  nStart, nEnd              : Integer;
  X, Y, SX, SY              : Integer;
  Clipping                  : Boolean;
begin
  if FNeedRedraw then
    ReDraw;

  Clipping := (CParent <> nil) and (CParent is THGEWindow);
  if Clipping then begin
    FHGE.Gfx_SetClipping(CParent.SurfaceX(CParent.Left + CParent.ClipRect.Left), CParent.SurfaceY(CParent.Top + CParent.ClipRect.Top), CParent.ClipRect.Right, CParent.ClipRect.Bottom);
  end;

  if Self = FocusedControl then begin
    if not FTransparent then
      inherited Render;                 //不透明的话，就先画文字

    //显示选中文字(在上面覆盖一层)
    if not FIsHotKey and (GetSelLength > 0) then begin
      if FSelStart < FSelEnd then begin
        nStart := FSelStart;
        nEnd := FSelEnd;
      end else begin
        nStart := FSelEnd;
        nEnd := FSelStart;
      end;

      FQuad.Tex := nil;

      SX := SurfaceX(Left);
      FCertTop := SurfaceY(Top) + BorderWidth + 1;

      X := SX + BorderWidth + Canvas.TextWidth(System.Copy(FCaption, 1, nStart)) - FStartTextX;
      if X < SX then X := SX;

      Y := SX + BorderWidth + Canvas.TextWidth(System.Copy(FCaption, 1, nEnd)) + 2 - FStartTextX;
      if Y > SX + Width then Y := SX + Width;

      if FWideBrush > 0 then begin
        if FWideBrush = 1 then
          FQuad.Blend := Blend_Add
        else
          FQuad.Blend := BLEND_DEFAULT;
        FQuad.V[0].X := X;
        FQuad.V[0].Y := FCertTop;

        FQuad.V[1].X := Y;
        FQuad.V[1].Y := FQuad.V[0].Y;

        FQuad.V[2].X := FQuad.V[1].X;
        FQuad.V[2].Y := FQuad.V[1].Y + FCertHeight;

        FQuad.V[3].X := FQuad.V[0].X;
        FQuad.V[3].Y := FQuad.V[2].Y;
      end else begin
        FQuad.Blend := BLEND_DEFAULT;
        FQuad.V[0].X := X;
        FQuad.V[0].Y := FCertTop - 1;

        FQuad.V[1].X := Y - 1;
        FQuad.V[1].Y := FQuad.V[0].Y;

        FQuad.V[2].X := FQuad.V[1].X;
        FQuad.V[2].Y := FQuad.V[1].Y + FCertHeight - 2;
        FQuad.V[3].X := FQuad.V[0].X;
        FQuad.V[3].Y := FQuad.V[2].Y;
      end;

      for II := 0 to 3 do begin
        if not FTransparent then begin
          if Color = clBlack then
            FQuad.V[II].Col := ARGB($4F, $00, $00, $FF)
          else
            FQuad.V[II].Col := ARGB($4F, $00, $00, $00); //ARGB($8F, $3F, $3F, $FF);
        end else
          FQuad.V[II].Col := ARGB($DF, $00, $00, $FF);
        FQuad.V[II].Z := 0.5;
      end;
      FQuad.V[1].TX := 1;
      FQuad.V[2].TX := 1;
      FQuad.V[2].TY := 1;
      FQuad.V[3].TY := 1;
      FHGE.Gfx_RenderQuad(FQuad);
    end;

    if FTransparent then
      inherited Render;

    //切换闪动状态
    if not FIsHotKey then begin
      if Integer(GetTickCount - FBlinkTick) > 400 then
        SetBlink(not FBlink);

      //显示光标
      if FBlink then begin
        if FWideBrush > 0 then begin
          FHGE.Gfx_RenderLine(SurfaceX(Left) + FCertDrawPos + 2,
            SurfaceY(Top) + BorderWidth + 1,
            SurfaceX(Left) + FCertDrawPos + 2,
            SurfaceY(Top) + BorderWidth + FCertHeight + 1,
            FCursorColor);
          FHGE.Gfx_RenderLine(SurfaceX(Left) + FCertDrawPos + 1,
            SurfaceY(Top) + BorderWidth + 1,
            SurfaceX(Left) + FCertDrawPos + 1,
            SurfaceY(Top) + BorderWidth + FCertHeight + 1,
            FCursorColor);
        end else begin
          X := _MAX(SurfaceX(Left) + 1, SurfaceX(Left) + FCertDrawPos);
          FHGE.Gfx_RenderLine(X,
            SurfaceY(Top) + BorderWidth - 1,
            X,
            SurfaceY(Top) + BorderWidth + FCertHeight - 1,
            FCursorColor);
        end;
      end;
    end;
  end else
    inherited;

  if (FCaption = '') and (DefText <> '') then begin
    g_GE.Font.Print(SurfaceX(Left) + 4, SurfaceY(Top) + 3, clGray, DefText);
  end;

  if Clipping then begin
    FHGE.Gfx_SetClipping();
  end;

  if (FPopMenu <> nil) and FPopMenu.Visible then begin
    if FIsHotKey then
      FPopMenu.Visible := False
    else
      G_PopMenu := FPopMenu;
  end;
end;

procedure THGEEdit.PopMenuCopy(Sender: TObject; Menu: pTMenuItem);
var
  Key                       : word;
begin
  Key := 67;
  KeyDown(Key, [ssCtrl]);
end;

procedure THGEEdit.PopMenuCut(Sender: TObject; Menu: pTMenuItem);
var
  Key                       : word;
begin
  Key := 88;
  KeyDown(Key, [ssCtrl]);
end;

procedure THGEEdit.PopMenuDel(Sender: TObject; Menu: pTMenuItem);
var
  Key                       : word;
begin
  Key := VK_DELETE;
  KeyDown(Key, []);
end;

procedure THGEEdit.PopMenuPast(Sender: TObject; Menu: pTMenuItem);
var
  Key                       : word;
begin
  Key := 86;
  KeyDown(Key, [ssCtrl]);
end;

procedure THGEEdit.PopMenuSelectAll(Sender: TObject; Menu: pTMenuItem);
var
  Key                       : Char;
begin
  Key := #1;
  KeyPress(Key);
end;

procedure THGEEdit.InitPopMenu;
var
  MenuItem                  : TMenuItem;
begin
  if FPopMenu = nil then begin
    FPopMenu := THGEMenu.Create(nil);
  end else
    FPopMenu.Clear;

  with MenuItem do begin
    ID := 0;
    sText := '剪切   Ctrl+X';
    Enabled := SelLength > 0;
    Checked := True;
    Proc := PopMenuCut;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
  with MenuItem do begin
    ID := 0;
    sText := '复制   Ctrl+C';
    Enabled := (SelLength > 0) and (PasswordChr = #0);
    Checked := False;
    Proc := PopMenuCopy;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
  with MenuItem do begin
    ID := 0;
    sText := '粘贴   Ctrl+V';
    Enabled := Length(Clipboard.AsText) > 0;
    Checked := False;
    Proc := PopMenuPast;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
  with MenuItem do begin
    ID := 0;
    sText := '删除   DEL';
    Enabled := SelLength > 0;
    Checked := False;
    Proc := PopMenuDel;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
  with MenuItem do begin
    ID := 0;
    sText := '-';
    Enabled := True;
    Checked := False;
    Proc := nil;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
  with MenuItem do begin
    ID := 0;
    sText := '全选   Ctrl+A';
    Enabled := (Length(Caption) > 0) and (Length(Caption) <> SelLength);
    Checked := False;
    Proc := PopMenuSelectAll;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
end;

procedure THGEEdit.SetBlink(Value: Boolean);
begin
  FBlink := Value;
  FBlinkTick := GetTickCount;
end;

procedure THGEEdit.SetCaption(const Value: string);
begin
  //inherited SetCaption(Value);
  FCaption := Value;
  //计算光标的位置
  Canvas.Font := Font;
  SelStart := -1;
  SelEnd := -1;
  FCertPos := Length(FCaption);
  FNeedRedraw := True;
  //if Assigned(FOnChange) then FOnChange(Self);
end;

procedure THGEEdit.SetCertPos(const Value: Integer);
begin
  FCertPos := Value;
  if FCertPos < 0 then
    FCertPos := 0
  else if FCertPos > Length(FCaption) then
    FCertPos := Length(FCaption);
  CalcCertDrawPos;
end;

procedure THGEEdit.SetMaxLength(const Value: Integer);
begin
  FMaxLength := Value;
end;

procedure THGELabel.SetPasswordChr(const Value: Char);
begin
  FPasswordChr := Value;
  FNeedRedraw := True;
end;

procedure THGELabel.SetStress(const Value: Boolean);
begin
  FStress := Value;
  FNeedRedraw := True;
end;

procedure THGELabel.SetStressColor(const Value: TColor);
begin
  FStressColor := Value;
  FNeedRedraw := True;
end;

procedure THGEEdit.SetSelEnd(const Value: Integer);
begin
  FSelEnd := Value;
end;

procedure THGEEdit.SetSelStart(const Value: Integer);
begin
  FSelStart := Value;
end;

{ THGEIME }
type
  TWndProc = function(HWindow: HWnd; Msg, wParam, lParam: Longint): Longint; stdcall;

var
  g_lpLastHgeWndProc        : Integer = 0;

function GfxEditWndProc(HWindow: HWnd; nMsg, wParam, lParam: Longint): Longint; stdcall;
var
  aMsg                      : TMsg;
begin
  if g_GE.IME.WindowMsgProce(HWindow, nMsg, wParam, lParam) then begin
    Result := 0;
    Exit;
  end;

  FillChar(aMsg, sizeof(TMsg), 0);
  aMsg.HWnd := HWindow;
  aMsg.Message := nMsg;
  aMsg.wParam := wParam;
  aMsg.lParam := lParam;
  aMsg.time := GetTickCount();
  TranslateMessage(aMsg);
  if g_lpLastHgeWndProc <> 0 then
    Result := TWndProc(g_lpLastHgeWndProc)(HWindow, nMsg, wParam, lParam)
  else Result := 1;
end;

procedure THGEIME.AdjustImmPos(AX, AY, AHeight: Single); //调整输入法的显示位置
begin
  {优先显示在需要输入的地方的下面，如果显示不下，则显示在上面
  }

  FImmPosX2 := AX;
  FImmPosY2 := AY;
  FimmPosH := AHeight;
  FImnPosY := AY + AHeight + 3;
  FImmPosX := AX + 3;
  if FSprImeName <> nil then
    FImmPosY := FImnPosY + FSprImeName.GetHeight - 2;
  if (FSprImeName = nil) or (FSprWords = nil) then Exit;

  if FImmPosX + 23 + FSprImeName.GetWidth > SCREENWIDTH then
    FImmPosX := SCREENWIDTH - FSprImeName.GetWidth - 23
  else
    FImmPosX := FImmPosX + 23;

  if FImmPosY + 14 + FSprWords.GetHeight > SCREENHEIGHT then begin
    FImnPosY := AY - FSprImeName.GetHeight - 3 - 14; //输入法信息显示位置，在输入框上面
    FImmPosY := AY - FSprImeName.GetHeight - FSprWords.GetHeight - 14 - 1; //选字列表显示在输入法上面
  end else begin
    FImnPosY := FImnPosY + 14;          //输入法信息显示位置，在输入框上面
    FImmPosY := FImmPosY + 14;          //选字列表显示在输入法上面
  end;

  FImnPosX := FImmPosX;
end;

constructor THGEIME.Create;
begin
  inherited;
  FBmp := TBitmap.Create;
  FPng := TPNGObject.Create;
  m_pKeyBoardBuffer := TGList.Create;
  m_pMouseBuffer := TGList.Create;
  m_CandList := TGStringList.Create;
  FTex := nil;
  FSprImeName := nil;
  FSprWords := nil;
  FHGE := HGECreate(HGE_VERSION);
  FStream := TMemoryStream.Create;
end;

destructor THGEIME.Destroy;
var
  I                         : Integer;
begin
  for I := 0 to m_pKeyBoardBuffer.Count - 1 do
    Dispose(PTagKeyBoardBuffer(m_pKeyBoardBuffer[I]));
  m_pKeyBoardBuffer.Free;
  for I := 0 to m_pMouseBuffer.Count - 1 do
    Dispose(PTagMouseBuffer(m_pMouseBuffer[I]));
  m_pMouseBuffer.Free;
  FTex := nil;
  FSprImeName := nil;
  FSprWords := nil;
  m_CandList.Free;
  FHGE := nil;
  FStream.Free;
  FBmp.Free;
  FPng.Free;
  inherited;
end;

function THGEIME.Finalize: Boolean;
begin
  Result := True;
end;

function THGEIME.Initialize: Boolean;
var
  nWnd                      : HWnd;
  //tmpHGE                      : IHGE;
begin
  Result := False;

  //FHGE := HGECreate(HGE_VERSION);
  nWnd := FHGE.System_GetState(HGE_HWND);
  if (nWnd = 0) then begin
    Exit;
  end;

  //安装钩子函数
  if not (g_lpLastHgeWndProc <> 0) then begin
    g_lpLastHgeWndProc := GetWindowLong(nWnd, GWL_WNDPROC);
    if g_lpLastHgeWndProc <> SetWindowLong(nWnd, GWL_WNDPROC, Longint(@GfxEditWndProc)) then begin
      Exit;
    end;
  end;
  Result := True;
end;

function THGEIME.OnWM_IME_COMPOSITION(HWindow: HWnd; lParam: Integer): Boolean;
var
  IMC                       : HIMC;
  dwSize                    : DWORD;
  str                       : array[0..MAX_PATH - 1] of UCHAR;
  I                         : Integer;
begin
  //输入改变
  IMC := ImmGetContext(HWindow);
  if (lParam and GCS_COMPSTR) = GCS_COMPSTR then begin
    dwSize := ImmGetCompositionString(IMC, GCS_COMPSTR, @m_szCompStr[0], sizeof(m_szCompStr));
    m_szCompStr[dwSize] := #0;
  end;                                  //取得szCompStr
  if (lParam and GCS_COMPREADSTR) = GCS_COMPREADSTR then begin
    dwSize := ImmGetCompositionString(IMC, GCS_COMPREADSTR, @m_szCompReadStr[0], sizeof(m_szCompReadStr));
    m_szCompReadStr[dwSize] := #0;
  end;                                  //取得szCompReadStr
  if (lParam and GCS_CURSORPOS) = GCS_CURSORPOS then begin
    m_nImeCursor := $FFFF and ImmGetCompositionString(IMC, GCS_CURSORPOS, nil, 0);
  end;                                  //取得nImeCursor

  if (lParam and GCS_RESULTSTR) = GCS_RESULTSTR then begin
    dwSize := ImmGetCompositionString(IMC, GCS_RESULTSTR, @str[0], sizeof(str)); //取得汉字输入串
    str[dwSize] := 0;
    for I := 0 to dwSize - 1 do begin
      PostMessage(HWindow, WM_CHAR, wParam(str[I]), 1); //转成WM_CHAR消息
    end;
  end;
  ImmReleaseContext(HWindow, IMC);
  FNeedRedraw := True;
  Result := True;                       //总是返回true，防止ime窗口打开
end;

function THGEIME.OnWM_IME_ENDCOMPOSITION: Boolean;
begin
  Result := True;
end;

function THGEIME.OnWM_IME_NOTIFY(HWindow: HWnd; wParam: word): Boolean;
var
  IMC                       : HIMC;
  dwSize                    : DWORD;
  dwConversion              : DWORD;
  dwSentence                : DWORD;
  pcan                      : PCandidateList;
  temp                      : array of tagCANDIDATELIST;
  I                         : Integer;
begin
  case wParam of
    IMN_SETOPENSTATUS: begin            //新输入法打开
        Result := True;
      end;
    IMN_SETCONVERSIONMODE: begin        //全角/半角，中/英文标点改变
        IMC := ImmGetContext(HWindow);
        ImmGetConversionStatus(IMC, dwConversion, dwSentence);
        if (dwConversion and IME_CMODE_FULLSHAPE) = IME_CMODE_FULLSHAPE then //取得全角标志
          m_bImeSharp := True
        else m_bImeSharp := False;
        if (dwConversion and IME_CMODE_SYMBOL) = IME_CMODE_SYMBOL then //取得中文标点标志
          m_bImeSymbol := True
        else m_bImeSymbol := False;
        ImmReleaseContext(HWindow, IMC);
      end;
    IMN_OPENCANDIDATE,                  //进入选字状态
    IMN_CHANGECANDIDATE: begin          //选字表翻页
        IMC := ImmGetContext(HWindow);
        dwSize := ImmGetCandidateList(IMC, 0, nil, 0);
        if dwSize > 0 then begin
          SetLength(temp, dwSize);
          pcan := @temp[0];
          ImmGetCandidateList(IMC, 0, pcan, dwSize);
          //得到新的选字表
          ImmReleaseContext(HWindow, IMC);
          if pcan.dwCount > 0 then begin
            m_CandList.Lock;
            try
              m_CandList.Clear;
              I := 1;
              while (I <= Integer(pcan.dwCount - pcan.dwSelection)) and (I <= Integer(pcan.dwPageSize)) do begin
                try
                  if I <> 10 then
                    m_CandList.Add(format('%d.%s', [I, PChar(PChar(pcan) + pcan.dwOffset[pcan.dwSelection + I])]))
                  else
                    m_CandList.Add(format('%d.%s', [0, PChar(PChar(pcan) + pcan.dwOffset[pcan.dwSelection + I])]));
                  I := I + 1;
                except
                  Break;
                end;
              end;
            finally
              m_CandList.UnLock;
            end;
          end;
          FNeedRedraw := True;
          SetLength(temp, 0);
        end;
      end;
    IMN_CLOSECANDIDATE: begin           //关闭选字表
        m_CandList.Lock;
        try
          m_CandList.Clear;
        finally
          m_CandList.UnLock;
        end;
        //m_szCompStr[0] := #0;
        FNeedRedraw := True;
      end;
  end;
  Result := True;                       //总是返回true，防止ime窗口打开
end;

function THGEIME.OnWM_IME_SETCONTEXT: Boolean;
begin
  Result := True;
end;

function THGEIME.ONWM_IME_STARTCOMPOSITION: Boolean;
begin
  Result := True;
end;

var
  boHandINPUTLANGCHANGE     : Boolean;

function THGEIME.OnWM_INPUTLANGCHANGE(HWindow: HWnd; wParam: wParam; lParam: lParam): Boolean;
var
  KL                        : HKL;
  IMC                       : HIMC;
  dwConversion              : DWORD;
  dwSentence                : DWORD;
  ImeFileName               : array[0..50] of Char;
  tempstr                   : string;
  I                         : Integer;
begin
  if (FocusedControl <> nil) and (FocusedControl is THGEMemo) and (THGEMemo(FocusedControl).PasswordChr <> #0) then begin
    if boHandINPUTLANGCHANGE then begin
      boHandINPUTLANGCHANGE := False;
    end else begin
      boHandINPUTLANGCHANGE := True;
      //总是禁止输入法
      if m_DefKL = $04090409 then       //微软拼音输入法：E00E0804
        KL := $04090409
      else
        KL := $08040804;                //Screen.DefaultKbLayout;
      m_szImeName[0] := #0;
      ActivateKeyboardLayout(KL, KLF_ACTIVATE);
    end;
    FNeedRedraw := True;
    Result := True;
    Exit;
  end;
  //ime改变
  KL := GetKeyboardLayout(0);
  m_szImeName[0] := #0;

  if (HiWord(KL) <> $0804) and (ImmIsIME(KL)) then begin
    IMC := ImmGetContext(HWindow);
    ImmEscape(KL, IMC, IME_ESC_IME_NAME, @m_szImeName[0]); //取得新输入法名字

    ImmGetConversionStatus(IMC, dwConversion, dwSentence);
    if (dwConversion and IME_CMODE_FULLSHAPE) = IME_CMODE_FULLSHAPE then //取得全角标志
      m_bImeSharp := True
    else
      m_bImeSharp := False;
    if (dwConversion and IME_CMODE_SYMBOL) = IME_CMODE_SYMBOL then //取得中文标点标志
      m_bImeSymbol := True
    else
      m_bImeSymbol := False;

    if m_szImeName = '' then begin      //特殊处理
      FillChar(ImeFileName, sizeof(ImeFileName), 0);
      ImmGetIMEFileName(lParam, ImeFileName, 50);
      tempstr := Trim(ImeFileName);
      FillChar(m_szImeName, sizeof(m_szImeName), 0);
      ImmGetDescription(lParam, @m_szImeName[0], 255);
      if CompareText(ImeFileName, 'WNWBIO.IME') = 0 then
        m_szImeName := '万能五笔输入法';
    end;
    ImmReleaseContext(HWindow, IMC);
  end else begin                        //英文输入
    m_szImeName[0] := #0;
  end;
  FNeedRedraw := True;
  Result := False;                      //总是返回false，因为需要窗口函数调用DefWindowProc继续处理
end;

function THGEIME.onWM_INPUTLANGCHANGEREQUEST: Boolean;
begin
  Result := False;
end;

procedure THGEIME.ReDraw;               //显示输入法的有关内容

  procedure DrawBox2(Canvas: TCanvas; L, T, W, H: Integer);
  var
    FrameBrush              : HBRUSH;
  begin
    with Canvas do begin
      //Font.Color := clBtnHighlight;
      Pen.Color := clBtnHighlight;
      brush.Color := clBlack;           //clBtnShadow;
      Rectangle(L + 1, T + 1, W - 1, H - 1);
      brush.Style := bsClear;
    end;
  end;
var
  //Bmp                       : TBitmap;
  //png                       : TPNGObject;
  W, H, I, J                : Integer;
  ImeHeight                 : Integer;
  nComStrWidth              : Integer;
  nImeNameWidth             : Integer;
begin
  FNeedRedraw := False;

  FTex := nil;
  FSprImeName := nil;
  FSprWords := nil;
  if m_szImeName[0] = #0 then Exit;

  //Bmp := TBitmap.Create;
  //png := TPNGObject.Create;
  try
    FBmp.Width := 0;
    FBmp.Height := 0;
    FBmp.Canvas.Font.Name := '宋体';
    FBmp.Canvas.Font.Size := 11;
    FBmp.Canvas.Font.Style := [fsBold];
    FBmp.Canvas.Font.Color := clWhite;
    FBmp.Transparent := True;

    nComStrWidth := FBmp.Canvas.TextWidth(m_szCompStr) + 4;
    nImeNameWidth := _MAX(140, FBmp.Canvas.TextWidth(m_szImeName));
    W := _MAX(12 + nImeNameWidth, nComStrWidth);
    ImeHeight := 4 + FBmp.Canvas.TextHeight('a');

    H := ImeHeight + ImeHeight;
    for I := 0 to m_CandList.Count - 1 do begin
      J := 4 + FBmp.Canvas.TextWidth(m_CandList[I]);
      if W < J then
        W := J;
      H := H + FBmp.Canvas.TextHeight(m_CandList[I]) + 2;
    end;
    Inc(H, 4);

    FBmp.Width := W;
    FBmp.Height := H;
    FBmp.Canvas.brush.Style := bsSolid;
    FBmp.Canvas.brush.Color := clBlack; //clBtnShadow;
    FBmp.Canvas.FillRect(Bounds(0, 0, W, H));

    //开始显示内容：显示输入法
    H := ImeHeight;
    W := nComStrWidth;

    DrawBox2(FBmp.Canvas, 0, 0, FBmp.Width, H);
    FBmp.Canvas.Font.Color := clMaroon;
    FBmp.Canvas.TextOut(2, 2, m_szImeName);

    DrawBox2(FBmp.Canvas, 0, ImeHeight - 3, FBmp.Width, H * 2);
    FBmp.Canvas.Font.Color := GetRGB(16); //clCaptionText;
    FBmp.Canvas.TextOut(2, 2 + ImeHeight, m_szCompStr);

    //画选字列表边框
    DrawBox2(FBmp.Canvas, 0, ImeHeight * 2 - 3, FBmp.Width, FBmp.Height - 1);
    FBmp.Canvas.Font.Color := $800080;
    Inc(H, H + 2);
    //显示待选字列表
    for I := 0 to m_CandList.Count - 1 do begin
      FBmp.Canvas.TextOut(2, H, m_CandList[I]);
      Inc(H, FBmp.Canvas.TextHeight(m_CandList[I]) + 2);
    end;

    //转化为PNG
    FStream.Clear;
    FPng.Assign(FBmp);
    FPng.SaveToStream(FStream);
    FStream.Seek(soFromBeginning, 0);

    FTex := FHGE.Texture_Load(FStream.Memory, FStream.Size);
    if FTex <> nil then begin
      FSprImeName := THGESprite.Create(FTex, 0, 0, FBmp.Width, ImeHeight * 2);
      FSprWords := THGESprite.Create(FTex, 0, ImeHeight * 2 - 2, FBmp.Width, FBmp.Height - ImeHeight * 2);
    end;
  finally
    //Bmp.Free;
    //png.Free;
  end;
  AdjustImmPos(FImmPosX2, FImmPosY2, FimmPosH);
end;

//显示选字列表

procedure THGEIME.Render(WinMan: THGEWinManager);
var
  bRedraw                   : Boolean;
  FQuad                     : THGEQuad;
  II                        : Integer;
  Col, Col2                 : LongWord;
begin
  if (FocusedControl = nil) or not FocusedControl.FCanInput then Exit; //非输入控件，不处理
  bRedraw := FNeedRedraw;
  FNeedRedraw := False;
  if bRedraw then ReDraw;

  Col := $BF000000 or ColorToRGB(clBtnShadow);

  //显示输入法名称和待选词列表
  if FSprImeName <> nil then begin
    FillChar(FQuad, sizeof(THGEQuad), 0);
    FQuad.Tex := nil;
    FQuad.Blend := BLEND_DEFAULT;
    FQuad.V[0].X := FImnPosX - 0;
    FQuad.V[0].Y := FImnPosY - 0;
    FQuad.V[1].X := FQuad.V[0].X + FSprImeName.GetWidth + 0;
    FQuad.V[1].Y := FQuad.V[0].Y;
    FQuad.V[2].X := FQuad.V[1].X;
    FQuad.V[2].Y := FQuad.V[1].Y + FSprImeName.GetHeight + 0;
    FQuad.V[3].X := FQuad.V[0].X;
    FQuad.V[3].Y := FQuad.V[2].Y;
    for II := 0 to 3 do begin
      FQuad.V[II].Col := Col;
      FQuad.V[II].Z := 0.5;
    end;
    FQuad.V[1].TX := 1;
    FQuad.V[2].TX := 1;
    FQuad.V[2].TY := 1;
    FQuad.V[3].TY := 1;
    FHGE.Gfx_RenderQuad(FQuad);
    FSprImeName.Render(FImnPosX, FImnPosY);
  end;

  Col := $AF000000 or ColorToRGB(clBtnShadow);
  if (FSprWords <> nil) and (m_CandList.Count > 0) then begin
    FillChar(FQuad, sizeof(THGEQuad), 0);
    FQuad.Tex := nil;
    FQuad.Blend := BLEND_DEFAULT;
    FQuad.V[0].X := FImmPosX - 0;
    FQuad.V[0].Y := FImmPosY - 0 + 1;   //1111
    FQuad.V[1].X := FQuad.V[0].X + FSprWords.GetWidth + 0;
    FQuad.V[1].Y := FQuad.V[0].Y;
    FQuad.V[2].X := FQuad.V[1].X;
    FQuad.V[2].Y := FQuad.V[1].Y + FSprWords.GetHeight + 0 - 2;
    FQuad.V[3].X := FQuad.V[0].X;
    FQuad.V[3].Y := FQuad.V[2].Y;
    for II := 0 to 3 do begin
      FQuad.V[II].Col := Col;
      FQuad.V[II].Z := 0.5;
    end;
    FQuad.V[1].TX := 1;
    FQuad.V[2].TX := 1;
    FQuad.V[2].TY := 1;
    FQuad.V[3].TY := 1;
    FHGE.Gfx_RenderQuad(FQuad);
    FSprWords.Render(FImmPosX, FImmPosY);
  end;
end;

function THGEIME.WindowMsgProce(HWindow: HWnd; Msg: UINT; wParam: wParam; lParam: lParam): Boolean;
var
  KeyBoardBuffer            : PTagKeyBoardBuffer;
  MouseBuffer               : PTagMouseBuffer;
begin
  Result := False;
  case Msg of
    WM_KEYDOWN, WM_KEYUP, WM_CHAR: begin //键盘事件
        New(KeyBoardBuffer);
        ZeroMemory(KeyBoardBuffer, sizeof(TagKeyBoardBuffer));
        KeyBoardBuffer.HWindow := HWindow;
        KeyBoardBuffer.nMessage := Msg;
        KeyBoardBuffer.nKey := wParam;
        KeyBoardBuffer.nFlag := lParam;
        if (Msg <> WM_CHAR) then
          KeyBoardBuffer.Shift := KeyDataToShiftState(lParam)
        else
          KeyBoardBuffer.Shift := [];

        m_pKeyBoardBuffer.Lock;
        try
          m_pKeyBoardBuffer.Add(KeyBoardBuffer);
          if Msg <> WM_KEYDOWN then
            Result := True;
          Exit;
        finally
          m_pKeyBoardBuffer.UnLock;
        end;
      end;

    WM_SYSKEYDOWN, WM_SYSKEYUP, WM_SYSCHAR: begin
        New(KeyBoardBuffer);
        ZeroMemory(KeyBoardBuffer, sizeof(TagKeyBoardBuffer));
        KeyBoardBuffer.HWindow := HWindow;
        KeyBoardBuffer.nMessage := Msg;
        KeyBoardBuffer.nKey := wParam;
        KeyBoardBuffer.nFlag := lParam;
        if (Msg <> WM_CHAR) then        //1111 ????
          KeyBoardBuffer.Shift := KeyDataToShiftState(lParam)
        else
          KeyBoardBuffer.Shift := [];
        m_pKeyBoardBuffer.Lock;
        try
          m_pKeyBoardBuffer.Add(KeyBoardBuffer);
          Exit;
        finally
          m_pKeyBoardBuffer.UnLock;
        end;
      end;

    WM_MOUSEMOVE,
      WM_LBUTTONDOWN,
      WM_LBUTTONDBLCLK,
      WM_RBUTTONDOWN,
      WM_RBUTTONDBLCLK,
      WM_MBUTTONDOWN,
      WM_MBUTTONDBLCLK,
      WM_LBUTTONUP,
      WM_RBUTTONUP,
      WM_MBUTTONUP,
      WM_MOUSEWHEEL: begin              //鼠标事件
        New(MouseBuffer);
        ZeroMemory(MouseBuffer, sizeof(tagMouseBuffer));
        case Msg of
          WM_MOUSEMOVE: MouseBuffer.nType := INPUT_MOUSE_MOVE;
          WM_LBUTTONDOWN,
            WM_RBUTTONDOWN,
            WM_MBUTTONDOWN: MouseBuffer.nType := INPUT_MOUSE_DOWN;
          WM_LBUTTONDBLCLK,
            WM_RBUTTONDBLCLK,
            WM_MBUTTONDBLCLK: MouseBuffer.nType := INPUT_MOUSE_DBCLICK;
          WM_LBUTTONUP,
            WM_RBUTTONUP,
            WM_MBUTTONUP: MouseBuffer.nType := INPUT_MOUSE_UP;
          WM_MOUSEWHEEL:
            MouseBuffer.nType := INPUT_MOUSE_WHEEL; //lParam是鼠标XY坐标
        end;
        MouseBuffer.HWindow := HWindow;
        MouseBuffer.nMessage := Msg;
        MouseBuffer.nComboKey := wParam;
        MouseBuffer.lParam := lParam;
        MouseBuffer.Shift := KeysToShiftState(wParam);
        m_pMouseBuffer.Lock;
        try
          m_pMouseBuffer.Add(MouseBuffer);
        finally
          m_pMouseBuffer.UnLock;
        end;
        if MouseBuffer.nType <> INPUT_MOUSE_DOWN then
          Result := True
        else
          Result := False;
      end;
    WM_INPUTLANGCHANGEREQUEST: begin
        if onWM_INPUTLANGCHANGEREQUEST then begin
          Result := True;
          Exit;
        end;
      end;
    WM_INPUTLANGCHANGE: begin
        if OnWM_INPUTLANGCHANGE(HWindow, wParam, lParam) then begin
          Result := True;
          Exit;
        end;
      end;

    WM_IME_SETCONTEXT: begin
        if OnWM_IME_SETCONTEXT then begin
          Result := True;
          Exit;
        end;
      end;
    WM_IME_STARTCOMPOSITION: begin
        if ONWM_IME_STARTCOMPOSITION then begin
          Result := True;
          Exit;
        end;
      end;
    WM_IME_ENDCOMPOSITION: begin
        if OnWM_IME_ENDCOMPOSITION then begin
          Result := True;
          Exit;
        end;
      end;
    WM_IME_NOTIFY: begin
        if OnWM_IME_NOTIFY(HWindow, wParam) then begin
          Result := True;
          Exit;
        end;
      end;
    WM_IME_COMPOSITION: begin
        if OnWM_IME_COMPOSITION(HWindow, lParam) then begin
          Result := True;
          Exit;
        end;
      end;
  end;
end;

function THGEIME.GetKeyBuffer(KeyProcBuffers: PTagKeyBoardBuffer): Boolean;
var
  I                         : Integer;
  KeyBuffers                : PTagKeyBoardBuffer;
begin
  Result := False;
  m_pKeyBoardBuffer.Lock;
  try
    I := 0;
    while m_pKeyBoardBuffer.Count > I do begin
      KeyBuffers := m_pKeyBoardBuffer.Items[I];
      m_pKeyBoardBuffer.Delete(I);
      KeyProcBuffers.HWindow := KeyBuffers.HWindow;
      KeyProcBuffers.nMessage := KeyBuffers.nMessage;
      KeyProcBuffers.nKey := KeyBuffers.nKey;
      KeyProcBuffers.nFlag := KeyBuffers.nFlag;
      KeyProcBuffers.Shift := KeyBuffers.Shift;
      Dispose(KeyBuffers);
      Result := True;
      Break;
    end;
  finally
    m_pKeyBoardBuffer.UnLock;
  end;
end;

function THGEIME.GetMouseBuffer(MouseProcBuffers: PTagMouseBuffer): Boolean;
var
  I                         : Integer;
  MouseBuffers              : PTagMouseBuffer;
begin
  Result := False;
  m_pMouseBuffer.Lock;
  try
    I := 0;
    while m_pMouseBuffer.Count > I do begin
      MouseBuffers := m_pMouseBuffer.Items[I];
      m_pMouseBuffer.Delete(I);
      MouseProcBuffers.HWindow := MouseBuffers.HWindow;
      MouseProcBuffers.nType := MouseBuffers.nType;
      MouseProcBuffers.nMessage := MouseBuffers.nMessage;
      MouseProcBuffers.nComboKey := MouseBuffers.nComboKey;
      MouseProcBuffers.nWheel := MouseBuffers.nWheel;
      MouseProcBuffers.Shift := MouseBuffers.Shift;
      MouseProcBuffers.X := MouseBuffers.X;
      MouseProcBuffers.Y := MouseBuffers.Y;
      Dispose(MouseBuffers);
      Result := True;
      Break;
    end;
  finally
    m_pMouseBuffer.UnLock;
  end;
end;

function THGEIME.GetWordCount: Integer;
begin
  Result := m_CandList.Count;
end;

function THGEIME.Update(WinMan: THGEWinManager): Boolean;
var
  KeyProcBuffers            : TagKeyBoardBuffer;
  MouseBuffers              : tagMouseBuffer;
  wMsgID                    : Integer;
  nCheckCode                : Integer;
  cKey                      : Char;
  wKey                      : word;
  Button                    : TMouseButton;
begin
  Result := False;
  try
    //循环所有消息
    wMsgID := 0;
    while GetKeyBuffer(@KeyProcBuffers) do begin
      nCheckCode := 500;
      WinMan.WindowMsgProce(KeyProcBuffers.HWindow, KeyProcBuffers.nMessage, KeyProcBuffers.nKey, KeyProcBuffers.nFlag);

      nCheckCode := 1000;
      wMsgID := KeyProcBuffers.nMessage;
      case wMsgID of
        WM_CHAR {, WM_SYSCHAR}: begin   //1111
            cKey := Char(KeyProcBuffers.nKey);
            if WinMan.KeyPress(cKey) then
              Result := True;
          end;
        WM_KEYDOWN, WM_SYSKEYDOWN: begin
            wKey := KeyProcBuffers.nKey;
            if WinMan.KeyDown(wKey, KeyProcBuffers.Shift) then
              Result := True;
          end;
        WM_KEYUP, WM_SYSKEYUP: begin
            wKey := KeyProcBuffers.nKey;
            if WinMan.KeyUp(wKey, KeyProcBuffers.Shift) then
              Result := True;
          end;
      end;
      nCheckCode := 1001;
      wMsgID := 0;
    end;
  except
    on E: Exception do begin
      //MessageBox(0, PChar(e.Message), '', 0);
    end;
  end;
  //处理鼠标
  while GetMouseBuffer(@MouseBuffers) do begin
    nCheckCode := 1500;
    WinMan.WindowMsgProce(MouseBuffers.HWindow,
      MouseBuffers.nMessage,
      MouseBuffers.nComboKey,
      MouseBuffers.lParam);
    nCheckCode := 2000;
    wMsgID := MouseBuffers.nMessage;
    case wMsgID of
      WM_LBUTTONDOWN, WM_LBUTTONUP: Button := mbLeft;
      WM_LBUTTONDBLCLK: Button := mbLeft;
      WM_MBUTTONDOWN, WM_MBUTTONUP, WM_MBUTTONDBLCLK: Button := mbMiddle;
      WM_RBUTTONDOWN, WM_RBUTTONUP, WM_RBUTTONDBLCLK: Button := mbRight;
    end;
    case MouseBuffers.nType of
      INPUT_MOUSE_MOVE: begin
          if WinMan.MouseMove(MouseBuffers.Shift, MouseBuffers.X, MouseBuffers.Y) then
            Result := True;
        end;
      INPUT_MOUSE_DOWN: begin
          if WinMan.MouseDown(Button, MouseBuffers.Shift, MouseBuffers.X, MouseBuffers.Y) then
            Result := True;
        end;
      INPUT_MOUSE_UP: begin
          if WinMan.MouseUp(Button, MouseBuffers.Shift, MouseBuffers.X, MouseBuffers.Y) then
            Result := True;
        end;
      INPUT_MOUSE_DBCLICK: begin
          if WinMan.MouseDoubleClick(Button, MouseBuffers.Shift, MouseBuffers.X, MouseBuffers.Y) then
            Result := True;
        end;
      INPUT_MOUSE_WHEEL: begin
          if WinMan.MouseWheel(MouseBuffers.Shift, MouseBuffers.X, MouseBuffers.Y, Smallint(HiWord(MouseBuffers.nComboKey))) then
            Result := True;
        end;
    end;
    nCheckCode := 2001;
  end;
end;

{ TGList }

constructor TGList.Create;
begin
  inherited;
  InitializeCriticalSection(RTL);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(RTL);
  inherited;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(RTL);
end;

procedure TGList.UnLock;
begin
  LeaveCriticalSection(RTL);
end;

{TGStringList}

constructor TGStringList.Create;
begin
  inherited;
  InitializeCriticalSection(RTL);
end;

destructor TGStringList.Destroy;
begin
  DeleteCriticalSection(RTL);
  inherited;
end;

procedure TGStringList.Lock;
begin
  EnterCriticalSection(RTL);
end;

procedure TGStringList.UnLock;
begin
  LeaveCriticalSection(RTL);
end;

{ THGEAnimPlayer }

constructor THGEAnimPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAnim := nil;
  FFPS := 20;
  FFrames := 1;
  FAniWidth := Width;
  FAniHeight := Height;
  FPlaying := False;
end;

destructor THGEAnimPlayer.Destroy;
begin
  FAnim := nil;
  inherited;
end;

procedure THGEAnimPlayer.LoadFromIni(sec, Key: string);
begin
  FAniWidth := FHGE.Ini_GetInt(sec, Key + '_Width', FAniWidth);
  FAniHeight := FHGE.Ini_GetInt(sec, Key + '_Height', FAniHeight);
  FFPS := FHGE.Ini_GetInt(sec, Key + '_FPS', Round(FFPS));
  FFrames := FHGE.Ini_GetInt(sec, Key + '_Frames', FFrames);
  inherited LoadFromIni(sec, Key);
end;

procedure THGEAnimPlayer.Render;
begin
  if FAnim <> nil then begin
    FAnim.Update(FHGE.Timer_GetDelta);
    FAnim.Render(SurfaceX(Left), SurfaceY(Top));
  end;
end;

procedure THGEAnimPlayer.SetAniHeight(const Value: Integer);
begin
  FAniHeight := Value;
  SetTexture(FTexture);
end;

procedure THGEAnimPlayer.SetAniWidth(const Value: Integer);
begin
  FAniWidth := Value;
  SetTexture(FTexture);
end;

procedure THGEAnimPlayer.SetFPS(const Value: Single);
begin
  FFPS := Value;
  if FAnim <> nil then FAnim.SetSpeed(Value);
end;

procedure THGEAnimPlayer.SetFrames(const Value: Integer);
begin
  FFrames := Value;
  SetTexture(FTexture);
end;

procedure THGEAnimPlayer.SetPlaying(const Value: Boolean);
begin
  FPlaying := Value;
  if FAnim <> nil then
    if FPlaying then
      FAnim.Play
    else
      FAnim.Stop;
end;

procedure THGEAnimPlayer.SetTexture(const Tex: ITexture);
begin
  FAnim := nil;
  if Tex <> nil then begin
    FTexture := Tex;
    FAnim := THGEAnimation.Create(Tex, FFrames, FFPS, 0, 0, FAniWidth, FAniHeight);
    FAnim.SetHotSpot(0, 0);             //FAniWidth div 2,FAniHeight div 2);
    Width := FAniWidth;
    Height := FAniHeight;
    //FAnim.SetBlendMode(BLEND_ALPHAADD);
    if FPlaying then FAnim.Play else FAnim.Stop;
  end;
end;

{ THGEMemo }

function THGEMemo.GetShowingText: {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF};
var
  s                         : string;
begin
  if FPasswordChr = #0 then
    Result := FText
  else begin
    s := FText;
    if Length(s) > 0 then
      FillChar(s[1], Length(s), FPasswordChr);
    Result := s;
  end;
end;

procedure THGEMemo.InitPopMenu;
var
  MenuItem                  : TMenuItem;
begin
  if FPopMenu = nil then begin
    FPopMenu := THGEMenu.Create(nil);
  end else
    FPopMenu.Clear;
  with MenuItem do begin
    ID := 0;
    sText := '剪切   Ctrl+X';
    Enabled := SelLength > 0;
    Checked := True;
    Proc := PopMenuCut;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
  with MenuItem do begin
    ID := 0;
    sText := '复制   Ctrl+C';
    Enabled := (SelLength > 0) and (PasswordChr = #0);
    Checked := False;
    Proc := PopMenuCopy;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
  with MenuItem do begin
    ID := 0;
    sText := '粘贴   Ctrl+V';
    Enabled := Length(Clipboard.AsText) > 0;
    Checked := False;
    Proc := PopMenuPast;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
  with MenuItem do begin
    ID := 0;
    sText := '删除   DEL';
    Enabled := SelLength > 0;
    Checked := False;
    Proc := PopMenuDel;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
  with MenuItem do begin
    ID := 0;
    sText := '-';
    Enabled := True;
    Checked := False;
    Proc := nil;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
  with MenuItem do begin
    ID := 0;
    sText := '全选   Ctrl+A';
    Enabled := (Length(FText) > 0) and (Length(FText) <> SelLength);
    Checked := False;
    Proc := PopMenuSelectAll;
    SubMenu := nil;
  end;
  FPopMenu.AddItem(@MenuItem);
end;

constructor THGEMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMakeMultiLines := True;
  FLines := TStringList.Create;
  SetLength(FHardReturn, 0);
  FWantReturns := True;
  FWantTable := True;
  FText := '';
  FSelStart := -1;
  FSelEnd := -1;
  FCertPos := 0;                        //插入点字符位置（在哪个字符后面）
  FCertRow := 0;
  FCertCol := 0;                        //插入点所在位置X,Y（所在行的上部）
  FBlink := False;
  FBlinkTick := GetTickCount;           //上次闪动状态改变的时间
  FShowX := 0;
  FCanInput := True;
  FEnableFocus := True;
  FAutoCheckInRange := False;
  FMaxLength := 0;
  Font.OnChange := FontChanged;
  FImeStr := '';                        //输入法输入的文字
  FCertShowY := 0;
  FReadOnly := False;
  FScrollbar := nil;
  FNeedRedraw := True;
  FPopMenu := nil;
  cursor := crIBeam;
  FCursorColor := $FFFFFFFF;
  FNumberOnly := False;
  FStream := TMemoryStream.Create;
end;

destructor THGEMemo.Destroy;
begin
  FLines.Free;
  if FPopMenu <> nil then FPopMenu.Free;
  FStream.Free;
  inherited;
end;

procedure THGEMemo.FontChanged(Sender: TObject);
begin
  //Canvas.Font.PixelsPerInch := 96;
  //Canvas.Font := Font;
  FNeedRedraw := True;
end;

procedure THGEMemo.Update();
begin
  Text := FLines.Text;
  FNeedRedraw := True;
end;

function THGEMemo.GetCharPosByPixel(X, Y: Integer): Integer; //根据鼠标位置计算字符位置
var
  A, I, J, W, H, offset     : Integer;
  s, Txt                    : {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF};
begin
  Result := 0;
  A := Canvas.TextWidth('a');
  Canvas.Font.PixelsPerInch := 96;
  if not FWantReturns then begin
    Txt := GetShowingText;
    if Length(Txt) = 0 then Exit;
    X := X - Left - BorderWidth;
    Y := Y - Top - BorderWidth;

    {A := Canvas.TextWidth('a');
    X := _MAX(0, X - Left - BorderWidth);
    X := _MIN(A * Length(Txt), X);
    offset := X div A;

    frmDlg.Edit_LoginID.Caption := IntToStr(offset);

    case ByteType(Txt, offset + 1) of
      mbSingleByte: I := offset;
      mbLeadByte: I := offset;
      mbTrailByte: begin                //多字节字符首字节之后的字符
          if offset mod 2 = 0 then begin
            if X mod A > A div 2 then
              I := offset + 1
            else
              I := offset - 1;
          end else begin
            if X mod (A * 2) > A then
              I := offset + 1
            else
              I := offset - 1;
          end;
        end;
    end;
    Result := offset;
    // if (Result = FShowX) and (FShowX > 0) then
     //  Dec(Result); }

    s := '';
    I := FShowX + 1;
    Result := FShowX;

    while I <= Length(Txt) do begin
      s := s + Txt[I];
      if Canvas.TextWidth(s) > X then begin
        Break;
      end else
        Result := Result + 1;
      Inc(I);
    end;
    if (Result = FShowX) and (FShowX > 0) then
      Dec(Result);

  end else begin
    X := X - Left - BorderWidth;
    Y := Y - Top - BorderWidth;
    MakeMultiLines;
    H := FShowX * (FCertHeight + 2);
    W := BorderWidth;
    //计算第几行
    for I := 0 to FLines.Count - 1 do begin
      Inc(W, FCertHeight + 2);
      if W >= H + Y then begin          //找到当前行，开始计算，列
        Txt := {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[I]);
        if Length(Txt) = 0 then Exit;
        s := '';
        J := 1;
        while J <= Length(Txt) do begin
          s := s + Txt[J];
          if Canvas.TextWidth(s) > X then begin
            Break;
          end else
            Result := Result + 1;
          Inc(J);
        end;
        Break;
      end;
      Result := Result + Length({$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[I]));
      if FHardReturn[I] then Result := Result + 2;
    end;
  end;
end;

function THGEMemo.GetSelLength: Integer;
begin
  Result := Abs(FSelStart - FSelEnd);
end;

function THGEMemo.GetSelText: string;
begin
  if FSelStart = -1 then
    Result := ''
  else begin
    if FSelStart < FSelEnd then
      Result := System.Copy(FText, FSelStart + 1, FSelEnd - FSelStart)
    else
      Result := System.Copy(FText, FSelEnd + 1, FSelStart - FSelEnd)
  end;
end;

function THGEMemo.KeyDown(var Key: word; Shift: TShiftState): Boolean;
var
  OldCertPos, I             : Integer;
  sText                     : string;
  c                         : Char;
begin
  Result := False;
  if (FocusedControl <> Self) or not Enabled then Exit;
  try
    OldCertPos := FCertPos;
    case Key of                         //处理编辑键
      VK_LEFT: begin
          if FCertPos > 0 then begin
            if (FText[FCertPos] = #$0A) and (FText[FCertPos - 1] = #$0D) then
              FCertPos := FCertPos - 2
            else
              FCertPos := FCertPos - 1;
            Result := True;
          end else Exit;
        end;
      VK_RIGHT: begin
          if FCertPos < Length(FText) then begin
            if (FText[FCertPos + 1] = #$0D) and (FText[FCertPos + 2] = #$0A) then
              FCertPos := FCertPos + 2
            else
              FCertPos := FCertPos + 1;
            Result := True;
          end else Exit;
        end;
      VK_UP: begin
          if not FWantReturns or (FCertRow = 0) then Exit;
          if Length({$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[FCertRow - 1])) <= FCertCol then begin
            FCertPos := FCertPos - FCertCol;
            if FHardReturn[FCertRow - 1] then
              Dec(FCertPos, 2);
          end else begin                //上面的那一行没有这么多字符，则移动到上面那一行的末尾（在回车符号前）
            FCertPos := FCertPos - Length({$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[FCertRow - 1]));
            if FHardReturn[FCertRow - 1] then
              Dec(FCertPos, 2);
          end;
          Result := True;
        end;
      VK_DOWN: begin
          if not FWantReturns or (FCertRow >= FLines.Count - 1) then Exit;
          if Length({$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[FCertRow + 1])) <= FCertCol then begin //下一行比当前行插入点都短，则直接跳到下一行尾
            //新位置=本行开始的位置(FCertPos - FCertCol)+本行长度+下一行的长度 +本行硬回车符号长度
            FCertPos := FCertPos - FCertCol + Length({$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[FCertRow])) + Length({$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[FCertRow + 1]));
            if FHardReturn[FCertRow] then Inc(FCertPos, 2); //当前行是硬回车，则要+2
          end else begin                //下一行比当前行位置要长，则
            FCertPos := FCertPos + Length({$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[FCertRow]));
            if FHardReturn[FCertRow] then Inc(FCertPos, 2); //当前行是硬回车，则要+2
          end;
          Result := True;
        end;
      VK_PRIOR: begin                   //向上翻页
          I := ((Height - BorderWidth * 2) div (FCertHeight + 2));
          while I > 1 do begin
            Key := VK_UP;
            KeyDown(Key, Shift);
            Dec(I);
          end;
          Result := True;
          Exit;
        end;
      VK_NEXT: begin                    //向下翻页
          I := ((Height - BorderWidth * 2) div (FCertHeight + 2));
          while I > 1 do begin
            Key := VK_DOWN;
            KeyDown(Key, Shift);
            Dec(I);
          end;
          Result := True;
          Exit;
        end;
      VK_HOME: begin
          CertPos := 0;
          if (ssShift in Shift) and (FSelStart <> -1) then SelEnd := FCertPos;
          Result := True;
        end;
      VK_END: begin
          FCertPos := Length(FText);
          Result := True;
        end;

      VK_DELETE: begin
          if FReadOnly then Exit;       //只读

          //有选中文字的情况
          if GetSelLength > 0 then begin //删除选择的文字，并清除选中
            if FSelStart < FSelEnd then begin
              Text := System.Copy(FText, 1, FSelStart) + System.Copy(FText, FSelEnd + 1, Length(FText) - FSelEnd);
              FCertPos := FSelStart;
            end else begin
              Text := System.Copy(FText, 1, FSelEnd) + System.Copy(FText, FSelStart + 1, Length(FText) - FSelStart);
              FCertPos := FSelEnd;
            end;
            SelStart := -1;
            SelEnd := -1;               //取消选择
          end else if FCertPos < Length(FText) then begin
            if (FText[FCertPos + 1] = #$0D) and (FText[FCertPos + 2] = #$0A) then
              Text := System.Copy(FText, 1, FCertPos) + System.Copy(FText, FCertPos + 3, Length(FText) - FCertPos + 1)
            else
              Text := System.Copy(FText, 1, FCertPos) + System.Copy(FText, FCertPos + 2, Length(FText) - FCertPos + 1);
          end;
          FNeedRedraw := True;
          if Assigned(FOnChange) then FOnChange(Self);
          Result := True;
          Exit;
        end;
      67: begin                         //Ctrl+C 拷贝
          if (ssCtrl in Shift) and (PasswordChr = #0) then begin
            if GetSelLength > 0 then
              Clipboard.AsText := GetSelText;
          end;
          Exit;
        end;
      86: begin                         //Ctrl+V 粘贴
          if ssCtrl in Shift then begin
            sText := Clipboard.AsText;
            for I := 1 to Length(sText) do begin
              c := sText[I];
              if FWantReturns or not (c in [#13, #10]) then
                KeyPress(c);
            end;
          end;
          Exit;
        end;
      88: begin                         //Ctrl+X 剪切
          if (ssCtrl in Shift) and (PasswordChr = #0) then begin
            Key := 67;
            KeyDown(Key, Shift);
            Key := VK_DELETE;
            KeyDown(Key, []);
          end;
          Exit;
        end;
    else begin
        Result := inherited KeyDown(Key, Shift);
        Exit;
      end;
    end;
    if (ssShift in Shift) and Result then begin
      if (FSelStart = FSelEnd) then SelStart := OldCertPos;
      if (FSelStart <> -1) then SelEnd := FCertPos;
    end else if FSelStart <> -1 then begin
      SelStart := -1;
      SelEnd := -1;
    end;
    CertPos := FCertPos;
  finally
    if Assigned(FOnKeyDown) then FOnKeyDown(Self, Key, Shift);
  end;
end;

function THGEMemo.KeyPress(var Key: Char): Boolean;
var
  W                         : word;
begin
  Result := False;
  if not Enabled then Exit;
  if Assigned(FOnKeyPress) then
    FOnKeyPress(Self, Key);
  case ord(Key) of
    0: begin                            //已经在事件中处理掉了
        Result := True;
        Exit;
      end;
    VK_BACK: if not FReadOnly then begin
        //有选中文字的情况
        if GetSelLength > 0 then begin  //删除选择的文字，并清除选中
          if FSelStart < FSelEnd then begin
            Text := System.Copy(FText, 1, FSelStart) + System.Copy(FText, FSelEnd + 1, Length(FText) - FSelEnd);
            CertPos := FSelStart;
          end else begin
            Text := System.Copy(FText, 1, FSelEnd) + System.Copy(FText, FSelStart + 1, Length(FText) - FSelStart);
            CertPos := FSelEnd;
          end;
          SelStart := -1;
          SelEnd := -1;                 //取消选择
        end else if FCertPos > 0 then begin
          if (FText[FCertPos] = #$0A) and (FText[FCertPos - 1] = #$0D) then
            Text := System.Copy(FText, 1, FCertPos - 2) + System.Copy(FText, FCertPos + 1, Length(FText) - FCertPos + 1)
          else
            Text := System.Copy(FText, 1, FCertPos - 1) + System.Copy(FText, FCertPos + 1, Length(FText) - FCertPos + 1);
          CertPos := FCertPos - 1;
        end;
      end else Exit;
    VK_TAB: begin
        GetNextInputControl(not FHGE.Input_GetKeyState(VK_SHIFT));
        Result := True;
        Exit;
      end;
    VK_ESCAPE: begin
        Exit;
      end;
  else if not FReadOnly and (((Key = #13) and FWantReturns) or (Key >= #32)) then begin
    if FNumberOnly then begin           //仅限数字输入
      if not (Key in ['0'..'9', '.', '-']) then Exit;
      //检查小数点是否只有一个
      if Key = '.' then begin
        if Pos('.', FText) > 0 then Exit; //只允许一个小数点
      end;
      if Key = '-' then begin

      end;
    end;

    //替换选择的文字
    if GetSelLength > 0 then begin
      W := VK_DELETE;
      KeyDown(W, []);
    end;

    if (FMaxLength = 0) or (Length(FText) <= FMaxLength) then begin
      if ord(Key) >= 128 then begin
        FImeStr := FImeStr + Key;
        if Length(FImeStr) = 2 then begin
          if (FMaxLength = 0) or (Length(AnsiString(FText)) <= FMaxLength - 2) then begin
            Text := System.Copy(FText, 1, FCertPos) + FImeStr + System.Copy(FText, FCertPos + 1, Length(FText));
            CertPos := FCertPos + 1;
            if Assigned(FOnChange) then FOnChange(Self);
          end;
          FImeStr := '';
        end;
      end else if ((FMaxLength = 0) or (Length(AnsiString(FText)) < FMaxLength)) then begin
        if Key = #13 then begin
          Text := System.Copy(FText, 1, FCertPos) + FImeStr + #13#10 + System.Copy(FText, FCertPos + 1, Length(FText));
          CertPos := FCertPos + 2;
        end else begin
          if Length(FImeStr) = 1 then
            FImeStr := FImeStr + Key
          else
            FImeStr := Key;
          Text := System.Copy(FText, 1, FCertPos) + FImeStr + System.Copy(FText, FCertPos + 1, Length(FText));
          CertPos := FCertPos + 1;
        end;
        FImeStr := '';
        if Assigned(FOnChange) then FOnChange(Self);
      end;
    end else
      Exit;
  end else
    Exit;
  end;
  FNeedRedraw := True;
  if Assigned(FOnChange) then FOnChange(Self);
  Result := True;
end;

procedure THGEMemo.LoadFromIni(sec, Key: string);
begin
  inherited LoadFromIni(sec, Key);
  Font.Name := FHGE.Ini_GetString(sec, Key + '_FontName', Font.Name);
  Font.Size := FHGE.Ini_GetInt(sec, Key + '_FontSize', Font.Size);
  Font.Color := FHGE.Ini_GetInt(sec, Key + '_FontColor', Font.Color);
  Canvas.Font.Assign(Font);
  FCursorColor := FHGE.Ini_GetInt(sec, Key + '_CursorColor', FCursorColor);
  //Height:=FHGE.Ini_GetInt(sec,key+'_Height',Height);
  Canvas.Font.PixelsPerInch := 96;
  Canvas.Font := Font;
  FNeedRedraw := True;
end;

procedure THGEMemo.MakeMultiLines;
var
  I, J, H, CurH, ShowH      : Integer;
  s, sLine, sTmp            : {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF};
  sWord                     : string;
begin
  Canvas.Font.PixelsPerInch := 96;
  Canvas.Font := Font;
  s := GetShowingText;
  I := 1;
  J := 1;
  sWord := '';
  sLine := '';
  FCertHeight := Canvas.TextHeight('a');
  if not FWantReturns then begin        //单行编辑器
    if FCertPos < FShowX then
      FShowX := FCertPos
    else if FCertPos > 0 then begin
      I := FCertPos;
      while I > FShowX do begin
        sWord := s[I];
        if Canvas.TextWidth(sLine) + Canvas.TextWidth(sWord) > Width then begin
          FShowX := I;
          Break;
        end else sLine := sWord + sLine;
        Dec(I);
      end;
    end else FShowX := 0;
    FCertDrawPos := BorderWidth + Canvas.TextWidth(sLine);
    FCertShowY := BorderWidth;
    g_GE.IME.AdjustImmPos(SurfaceX(Left) + FCertDrawPos, SurfaceY(Top) + FCertShowY, FCertHeight);
    Exit;
  end;

  //if FMakeMultiLines then begin
  //  FMakeMultiLines := False;
  FCertCol := 0;                        //插入点所在列，即在当前行的第几个字符之前
  FCertRow := 0;                        //插入点所在行         FCertPos 表示在整个字符串中的位置，=0表示最开始
  FLines.Clear;
  SetLength(FHardReturn, 0);
  H := FCertHeight;
  ShowH := (FCertHeight + 2) * FShowX;  //当前行之前的行显示的高度
  CurH := H;
  FSelMaskStart := Point(0, 0);
  FSelMaskEnd := Point(0, 0);
  while I <= Length(s) do begin
    sWord := s[I];
    if (s[I] = #$0D) and (I < Length(s)) and (s[I + 1] = #$0A) then begin //回车换行
      Inc(I);
      sWord := '';
    end;
    //if (fsBold in Canvas.Font.Style) then ;
    if (sWord = '') or (Canvas.TextWidth(sLine) + Canvas.TextWidth(sWord) >= Width) then begin //获得一行
      FLines.Add(sLine);
      SetLength(FHardReturn, Length(FHardReturn) + 1);
      if sWord = '' then begin
        J := I + 1;
        FHardReturn[Length(FHardReturn) - 1] := True; //硬回车
      end else begin
        J := I;                         //下一行的开始字符位置
        FHardReturn[Length(FHardReturn) - 1] := False; //软回车
      end;
      sLine := sWord;
      Inc(H, FCertHeight + 2);
    end else
      sLine := sLine + sWord;

    if I = FCertPos then begin
      FCertCol := (I - J) + 1;          //插入点位置，则计算列号
      FCertRow := FLines.Count;
      CurH := H;
    end;
    if (I = FSelStart) and (I - J + 1 >= 0) and (I - J + 1 <= Length(sLine)) then begin //选择开始，获得开始的左上角坐标
      SetLength(sTmp, I - J + 1);
      Move(sLine[1], sTmp[1], (I - J + 1) * 2);
      FSelMaskStart.X := Canvas.TextWidth(sTmp);
      FSelMaskStart.Y := H - FCertHeight;
    end;
    if (I = FSelEnd) and (I - J + 1 >= 0) and (I - J + 1 <= Length(sLine)) then begin //选择结束，获得结束位置的右上角坐标
      SetLength(sTmp, I - J + 1);
      Move(sLine[1], sTmp[1], (I - J + 1) * 2);
      FSelMaskEnd.X := Canvas.TextWidth(sTmp);
      FSelMaskEnd.Y := H - FCertHeight;
    end;
    Inc(I);
  end;

  if (Length(sLine) <> 0) or (sWord = '') then begin
    FLines.Add(sLine);
    SetLength(FHardReturn, Length(FHardReturn) + 1);
    if sWord = '' then begin
      FHardReturn[Length(FHardReturn) - 1] := True; //硬回车
    end else begin
      FHardReturn[Length(FHardReturn) - 1] := False; //软回车
    end;
  end;
  //end;

  //保证当前行可见
  if CurH - ShowH > Height then begin   //当前行在框的下面，则调整开始行，使当前行显示为最后一行
    repeat
      Inc(FShowX);
      Inc(ShowH, FCertHeight + 2);
    until CurH - ShowH <= Height;
  end else if CurH - FCertHeight < ShowH then begin //当前行在框的上面，调整开始行，使当前行为第一行
    repeat
      Dec(FShowX);
      Dec(ShowH, FCertHeight + 2);
    until CurH - FCertHeight >= ShowH;
  end;

  FCertShowY := CurH - FCertHeight - ShowH;
  if FCertRow < FLines.Count then begin
    SetLength(sLine, FCertCol);
    s := FLines[FCertRow];
    Move(s[1], sLine[1], FCertCol * 2);
    FCertDrawPos := Canvas.TextWidth(sLine);
  end else
    FCertDrawPos := 0;

  if FocusedControl = Self then
    g_GE.IME.AdjustImmPos(SurfaceX(Left) + FCertDrawPos, SurfaceY(Top) + FCertShowY, FCertHeight);
  //计算选择文字的掩模（多行模式）
  if Scrollbar <> nil then begin
    Scrollbar.FMaxValue := FLines.Count - 1;
    Scrollbar.Position := FShowX;
  end;
end;

function THGEMemo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if (FPopMenu <> nil) and FPopMenu.Visible then
    Result := FPopMenu.MouseDown(Button, Shift, SurfaceX(X), SurfaceY(Y));
  if not Result and inherited MouseDown(Button, Shift, X, Y) then begin
    if (MouseCaptureControl = nil) then begin
      SetDCapture(Self);
    end;
    if mbLeft = Button then begin
      FMakeMultiLines := True;
      CertPos := GetCharPosByPixel(X, Y);
      SelStart := FCertPos;
      SelEnd := FCertPos;
      FNeedRedraw := True;
    end;
    Result := True;
  end;
end;

function THGEMemo.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  LastCertPos               : Integer;
begin
  if (FPopMenu <> nil) and FPopMenu.Visible then begin
    Result := FPopMenu.MouseMove(Shift, SurfaceX(X), SurfaceY(Y))
  end else
    Result := inherited MouseMove(Shift, X, Y);
  if (MouseCaptureControl = Self) and (ssLeft in Shift) then begin
    LastCertPos := FCertPos;
    CertPos := GetCharPosByPixel(X, Y);
    SelEnd := FCertPos;

    //frmDlg.Edit_LoginID.Caption := IntToStr(FShowX) + ' ' + IntToStr(I);
    if LastCertPos = FCertPos then begin
      FNeedRedraw := False;
      //MakeMultiLines;
    end else
      FNeedRedraw := True;
  end;
end;

function THGEMemo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if (FPopMenu <> nil) and FPopMenu.Visible then
    Result := FPopMenu.MouseUp(Button, Shift, SurfaceX(X), SurfaceY(Y));
  if not Result and inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if InRange(X, Y) then begin
      if (Button = mbLeft) and Assigned(FOnClick) then FOnClick(Self, X, Y)
      else if mbRight = Button then begin
        InitPopMenu;
        FPopMenu.Popup(SurfaceX(X), SurfaceY(Y), 0);
      end;
    end;
    Result := True;
    Exit;
  end else begin
    ReleaseDCapture;
  end;
end;

procedure THGEMemo.OnScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  ShowLines                 : Integer;
begin
  if ScrollPos <> FShowX then begin
    //FCertPos:=Length(GetShowingText);
    ShowLines := Height div (FCertHeight + 2); //可以显示的行数(实际可能比这个多一行）
    if FShowX > ScrollPos then begin    //向上滚动，则要检查光标是否会出现在输入框下面
      FShowX := ScrollPos;
      if FCertRow - ScrollPos >= ShowLines - 1 then
        CertRow := ShowLines + ScrollPos - 1
      else
        ShowX := ScrollPos;
    end else begin
      FShowX := ScrollPos;
      if FCertRow < ScrollPos then
        CertRow := ScrollPos
      else
        ShowX := ScrollPos;
    end;

    //如果光标被移动到显示区外，则调整光标

  end;
end;

procedure THGEMemo.PopMenuCopy(Sender: TObject; Menu: pTMenuItem);
var
  Key                       : word;
begin
  Key := 67;
  KeyDown(Key, [ssCtrl]);
end;

procedure THGEMemo.PopMenuCut(Sender: TObject; Menu: pTMenuItem);
var
  Key                       : word;
begin
  Key := 88;
  KeyDown(Key, [ssCtrl]);
end;

procedure THGEMemo.PopMenuDel(Sender: TObject; Menu: pTMenuItem);
var
  Key                       : word;
begin
  Key := VK_DELETE;
  KeyDown(Key, []);
end;

procedure THGEMemo.PopMenuPast(Sender: TObject; Menu: pTMenuItem);
var
  Key                       : word;
begin
  Key := 86;
  KeyDown(Key, [ssCtrl]);
end;

procedure THGEMemo.PopMenuSelectAll(Sender: TObject; Menu: pTMenuItem);
begin
  SelStart := 0;
  SelEnd := Length(FText);
end;

procedure THGEMemo.ReDraw;              //重新绘制文字内容
begin
  FNeedRedraw := False;
  if FSpr <> nil then
    FSpr := nil;
  MakeMultiLines;
end;

(*var
  //Bmp                       : TBitmap;
  //png                       : TPNGObject;
  J, I, W, H                : Integer;
  s, sTmp                   : {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF};
begin
  FNeedRedraw := False;
  FSpr := nil;
  MakeMultiLines;

  Canvas.Font.PixelsPerInch := 96;
  Canvas.Font := Font;

  //Bmp := TBitmap.Create;
  //png := TPNGObject.Create;
  FStream.Clear;
  try
    FBmp.Width := 0;
    FBmp.Height := 0;
    FBmp.Canvas.Font.PixelsPerInch := 96;
    FBmp.Canvas.Font.Assign(Canvas.Font);
    //
    FBmp.PixelFormat := pf32bit;
    FBmp.TransparentMode := tmFixed;
    if Font.Color = clBlack then
      FBmp.TransparentColor := clWhite
    else
      FBmp.TransparentColor := clBlack;
    FBmp.Canvas.brush.Style := bsClear;
    FBmp.Canvas.brush.Color := FBmp.TransparentColor;
    FBmp.Transparent := True;
    FBmp.Width := Width;
    FBmp.Height := Height;
    FCertHeight := FBmp.Canvas.TextHeight('a'); //计算一行的高度
    //开始写字
    if not FWantReturns then begin      //这个表示是否只有一行
      s := GetShowingText;
      W := 0;
      I := FShowX + 1;
      sTmp := System.Copy(s, I, Length(FText) - I + 1);
      FBmp.Canvas.TextOut(0, 0, sTmp);
    end else begin                      //多行编辑
      //计算开始行号，要保证光标所在行必须显示
      H := BorderWidth;
      for I := FShowX to FLines.Count - 1 do begin
        FBmp.Canvas.TextOut(BorderWidth, H, FLines[I]);
        Inc(H, FCertHeight + 2);
        if H >= Height then Break;
      end;
    end;
    //FBmp.SaveToStream(FStream);
    FPng.Assign(FBmp);
    FPng.SaveToStream(FStream);
    FStream.Seek(soFromBeginning, 0);
    FTexture := nil;
    FTexture := FHGE.Texture_Load(FStream.Memory, FStream.Size, False);
    if FTexture <> nil then begin
      FSpr := THGESprite.Create(FTexture, 0, 0, FBmp.Width, FBmp.Height);
      if (ModalDWindow <> nil) and not IsChild(ModalDWindow) then begin
        FSpr.SetColor(ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT));
      end else begin
        FSpr.SetColor(ARGB(FAlpha, FLight, FLight, FLight));
      end;
    end;
  finally
    //Bmp.Free;
    //png.Free;
  end;
end;*)

procedure THGEMemo.Render;
var
  sLine                     : string;
  FQuad                     : THGEQuad;
  I, II, HH                 : Integer;
  SP, EP                    : TPoint;
  s, sTmp                   : {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF};
  lx, ly, lx2, ly2          : Integer;
  J, W, H                   : Integer;
  Clipping                  : Boolean;
begin
  if FNeedRedraw then ReDraw;

  Clipping := (CParent <> nil) and (CParent is THGEWindow);

  if Clipping then begin
    FHGE.Gfx_SetClipping(CParent.SurfaceX(CParent.Left + CParent.ClipRect.Left), CParent.SurfaceY(CParent.Top + CParent.ClipRect.Top), CParent.ClipRect.Right, CParent.ClipRect.Bottom);
    inherited Render;
    FHGE.Gfx_SetClipping();

    FHGE.Gfx_SetClipping(CParent.SurfaceX(CParent.Left + CParent.ClipRect.Left), CParent.SurfaceY(CParent.Top + CParent.ClipRect.Top), CParent.ClipRect.Right, CParent.ClipRect.Bottom);
    if BorderWidth <> 0 then begin
      FQuad.V[0].X := SurfaceX(Left) - 1;
      FQuad.V[0].Y := SurfaceY(Top) - 1;
      FQuad.V[1].X := FQuad.V[0].X + Width + 2;
      FQuad.V[1].Y := FQuad.V[0].Y;
      FQuad.V[2].X := FQuad.V[1].X;
      FQuad.V[2].Y := FQuad.V[1].Y + Height + 2;
      FQuad.V[3].X := FQuad.V[0].X;
      FQuad.V[3].Y := FQuad.V[2].Y;
      FHGE.Gfx_RenderLine(FQuad.V[0].X, FQuad.V[0].Y, FQuad.V[1].X, FQuad.V[1].Y,
        ARGB($FF, GetB($00406F77), GetG($00406F77), GetR($00406F77)));
      FHGE.Gfx_RenderLine(FQuad.V[1].X, FQuad.V[1].Y, FQuad.V[2].X, FQuad.V[2].Y,
        ARGB($FF, GetB($00406F77), GetG($00406F77), GetR($00406F77)));
      FHGE.Gfx_RenderLine(FQuad.V[2].X, FQuad.V[2].Y, FQuad.V[3].X, FQuad.V[3].Y,
        ARGB($FF, GetB($00406F77), GetG($00406F77), GetR($00406F77)));
      FHGE.Gfx_RenderLine(FQuad.V[3].X, FQuad.V[3].Y, FQuad.V[0].X, FQuad.V[0].Y - 1,
        ARGB($FF, GetB($00406F77), GetG($00406F77), GetR($00406F77)));
      FHGE.Gfx_RenderQuad(FQuad);
    end;

    FHGE.Gfx_SetClipping();
  end;

  //1111
  if not FWantReturns then begin
    if Clipping then begin
      FHGE.Gfx_SetClipping(CParent.SurfaceX(CParent.Left + CParent.ClipRect.Left), CParent.SurfaceY(CParent.Top + CParent.ClipRect.Top), CParent.ClipRect.Right, CParent.ClipRect.Bottom);
      s := GetShowingText;
      I := FShowX + 1;
      sTmp := System.Copy(s, I, Length(FText) - I + 1);
      g_GE.Font.Print(SurfaceX(Left), SurfaceY(Top), Font.Color, sTmp);
      FHGE.Gfx_SetClipping();
    end;
  end else begin
    lx := SurfaceX(Left);
    ly := SurfaceY(Top);
    W := Width;
    H := Height;
    if Clipping then begin
      lx2 := CParent.SurfaceX(CParent.Left + CParent.ClipRect.Left);
      ly2 := CParent.SurfaceY(CParent.Top + CParent.ClipRect.Top);
      if lx2 > lx then lx := lx2;
      if ly2 > ly then ly := ly2;
      Inc(lx2, CParent.ClipRect.Right);
      Inc(ly2, CParent.ClipRect.Bottom);
      if lx + Width > lx2 then W := lx2 - lx;
      if ly + Height > ly2 then H := ly2 - ly;
    end;
    FHGE.Gfx_SetClipping(lx, ly, W, H);

    H := BorderWidth;
    for I := FShowX to FLines.Count - 1 do begin
      g_GE.Font.Print(SurfaceX(Left + BorderWidth), SurfaceY(Top + H), Font.Color, FLines[I]);
      Inc(H, FCertHeight + 2);
      if H >= Height then Break;
    end;
    FHGE.Gfx_SetClipping();
  end;

  if Self = FocusedControl then begin
    //切换闪动状态
    if GetTickCount - FBlinkTick > 400 then SetBlink(not FBlink);

    lx := SurfaceX(Left);
    ly := SurfaceY(Top);
    W := Width;
    H := Height;
    if Clipping then begin
      lx2 := CParent.SurfaceX(CParent.Left + CParent.ClipRect.Left);
      ly2 := CParent.SurfaceY(CParent.Top + CParent.ClipRect.Top);
      if lx2 > lx then lx := lx2;
      if ly2 > ly then ly := ly2;
      Inc(lx2, CParent.ClipRect.Right);
      Inc(ly2, CParent.ClipRect.Bottom);
      if lx + Width > lx2 then W := lx2 - lx;
      if ly + Height > ly2 then H := ly2 - ly;
    end;
    FHGE.Gfx_SetClipping(lx, ly, W, H);

    //显示选中文字(在上面覆盖一层)
    if GetSelLength > 0 then begin
      //FHGE.Gfx_SetClipping(SurfaceX(Left), SurfaceY(Top), Width, Height);
      FQuad.Tex := nil;
      FQuad.Blend := Blend_Add;         //BLEND_DEFAULT;
      if FWantReturns then begin        //多行
        if FSelMaskStart.Y <= FSelMaskEnd.Y then begin
          SP := FSelMaskStart;
          EP := FSelMaskEnd;
        end else begin
          SP := FSelMaskEnd;
          EP := FSelMaskStart;
        end;

        I := SP.Y div (FCertHeight + 2);
        while SP.Y <= EP.Y do begin
          FQuad.V[0].X := SurfaceX(Left) + SP.X;
          FQuad.V[0].Y := SurfaceY(Top) + SP.Y - FShowX * (FCertHeight + 2);
          if SP.Y >= EP.Y then begin    //最后一行，到结束
            FQuad.V[1].X := SurfaceX(Left) + EP.X
          end else begin
            //FQuad.V[1].x := SurfaceX(Left) + Width;

            sLine := '';
            if I < FLines.Count then
              sLine := FLines[I];
            if sLine = '' then
              FQuad.V[1].X := SurfaceX(Left)
            else
              FQuad.V[1].X := SurfaceX(Left) + _MIN(Self.Canvas.TextWidth(sLine), Width);
          end;
          SP.X := 0;
          FQuad.V[1].Y := FQuad.V[0].Y;
          FQuad.V[2].X := FQuad.V[1].X;
          FQuad.V[2].Y := FQuad.V[1].Y + FCertHeight + 2;
          FQuad.V[3].X := FQuad.V[0].X;
          FQuad.V[3].Y := FQuad.V[2].Y;
          for II := 0 to 3 do begin
            FQuad.V[II].Col := ARGB($7F, $00, $00, $FF);
            FQuad.V[II].Z := 0.5;
          end;
          FQuad.V[1].TX := 1;
          FQuad.V[2].TX := 1;
          FQuad.V[2].TY := 1;
          FQuad.V[3].TY := 1;
          FHGE.Gfx_RenderQuad(FQuad);

          Inc(SP.Y, FCertHeight + 2);
          Inc(I);
        end;
      end else begin
        s := GetShowingText;
        Canvas.Font.PixelsPerInch := 96;
        FQuad.V[0].X := SurfaceX(Left) + BorderWidth + Canvas.TextWidth(System.Copy(s, 1, FSelStart)) - Canvas.TextWidth(System.Copy(s, 1, FShowX));
        FQuad.V[0].Y := SurfaceY(Top) + FCertShowY;
        FQuad.V[1].X := SurfaceX(Left) + BorderWidth + Canvas.TextWidth(System.Copy(s, 1, FSelEnd)) - Canvas.TextWidth(System.Copy(s, 1, FShowX));
        FQuad.V[1].Y := FQuad.V[0].Y;
        FQuad.V[2].X := FQuad.V[1].X;
        FQuad.V[2].Y := FQuad.V[1].Y + FCertHeight;
        FQuad.V[3].X := FQuad.V[0].X;
        FQuad.V[3].Y := FQuad.V[2].Y;
        for II := 0 to 3 do begin
          FQuad.V[II].Col := ARGB($7F, $00, $00, $FF);
          FQuad.V[II].Z := 0.5;
        end;
        FQuad.V[1].TX := 1;
        FQuad.V[2].TX := 1;
        FQuad.V[2].TY := 1;
        FQuad.V[3].TY := 1;
        FHGE.Gfx_RenderQuad(FQuad);
      end;
      //FHGE.Gfx_SetClipping(0, 0, 0, 0);
    end;

    //显示光标
    if FBlink then begin
      FHGE.Gfx_RenderLine(SurfaceX(Left) + FCertDrawPos + 2, FCertShowY + SurfaceY(Top) + BorderWidth,
        SurfaceX(Left) + FCertDrawPos + 2, SurfaceY(Top) + BorderWidth + FCertShowY + FCertHeight + 2, FCursorColor);
      FHGE.Gfx_RenderLine(SurfaceX(Left) + FCertDrawPos + 1, FCertShowY + SurfaceY(Top) + BorderWidth,
        SurfaceX(Left) + FCertDrawPos + 1, SurfaceY(Top) + BorderWidth + FCertShowY + FCertHeight + 2, FCursorColor);
    end;

    FHGE.Gfx_SetClipping(0, 0, 0, 0);
  end;

  if (FPopMenu <> nil) and FPopMenu.Visible then
    G_PopMenu := FPopMenu;
end;

procedure THGEMemo.SetBlink(const Value: Boolean);
begin
  FBlink := Value;
  FBlinkTick := GetTickCount;
end;

procedure THGEMemo.SetCertCol(const Value: Integer);
var
  I                         : Integer;
begin
  if FLines.Count = 0 then Exit;
  if FCertRow >= FLines.Count then FCertRow := FLines.Count - 1;
  FCertPos := 0;
  for I := 0 to FCertRow - 1 do begin   //当前行之前的字符数
    FCertPos := FCertPos + Length({$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[I]));
    if FHardReturn[I] then Inc(FCertPos, 2);
  end;
  if Value > Length({$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[FCertRow])) then
    FCertCol := Length({$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF}(FLines[FCertRow]))
  else
    FCertCol := Value;                  //设置当前光标位置
  CertPos := FCertPos + FCertCol;
end;

procedure THGEMemo.SetCertPos(const Value: Integer);
begin
  //计算光标的位置
  FCertPos := Value;
  if FCertPos < 0 then FCertPos := 0
  else if FCertPos > Length(FText) then FCertPos := Length(FText);
  FNeedRedraw := True;
end;

procedure THGEMemo.SetCertRow(const Value: Integer);
begin
  FCertRow := Value;
  SetCertCol(FCertCol);
end;

procedure THGEMemo.SetMaxLength(const Value: Integer);
begin
  FMaxLength := Value;
end;

procedure THGEMemo.SetPasswordChr(const Value: Char);
begin
  if FPasswordChr <> Value then begin
    FPasswordChr := Value;
    FNeedRedraw := True;
  end;
end;

procedure THGEMemo.SetScrollbar(const Value: THGEScrollbar);
begin
  FScrollbar := Value;
  if FScrollbar <> nil then begin
    FScrollbar.MaxValue := FLines.Count - 1;
    FScrollbar.Position := FShowX;
    FScrollbar.OnScroll := OnScrollBarScroll;
  end;
end;

procedure THGEMemo.SetSelEnd(const Value: Integer);
begin
  FSelEnd := Value;
  FNeedRedraw := True;
end;

procedure THGEMemo.SetSelStart(const Value: Integer);
begin
  FSelStart := Value;
  FNeedRedraw := True;
end;

procedure THGEMemo.SetSelText(const Value: string);
begin                                   //用指定文字替换选择的文字，如果没有选择的文字，则直接插入到当前位置。新文字将被选择

end;

procedure THGEMemo.SetShowX(const Value: Integer);
begin
  FShowX := Value;
  FNeedRedraw := True;
end;

procedure THGEMemo.SetText(const Value: {$IFDEF WSTRING}WideString{$ELSE}string{$ENDIF});
var
  s                         : string;
begin
  s := Value;
  if (FMaxLength = 0) or (Length(s) <= FMaxLength) then
    FText := Value
  else
    FText := System.Copy(s, 1, FMaxLength);
  FMakeMultiLines := True;

  //FCertPos := Length(FText);
  FNeedRedraw := True;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure THGEMemo.SetWantReturns(const Value: Boolean);
begin
  FWantReturns := Value;
  FNeedRedraw := True;
end;

procedure THGEMemo.SetWantTable(const Value: Boolean);
begin
  FWantTable := Value;
end;

{ THGEScrollbar }

procedure THGEScrollbar.AdjuestBarpos;
var
  PixelsCount               : Integer;
  X, Y                      : Integer;
  R                         : Double;
begin
  if Assigned(FOnScroll) then
    FOnScroll(Self, scPosition, FPosition);
  if boBarMouseMove then Exit;
  //调整各对象的位置
  case FKind of
    sbHorizontal: begin                 //横
        PixelsCount := FNextBtn.Left - FPrevBtn.Left - FPrevBtn.Width - FBar.Width;
        if (FMaxValue > FMinValue) then
          R := (1 / (FMaxValue - FMinValue)) * PixelsCount //每一格的像素数量
        else
          R := 0.0;
        X := Round(FPosition * R);
        Y := FPrevBtn.Left + FPrevBtn.Width + X;
        //当滑动条在一定范围内时，不调整
        if (FBar.Left < Y) or (FBar.Left >= Round(Y + R)) then
          FBar.Left := Y;
      end;
    sbVertical: begin                   //纵
        PixelsCount := FNextBtn.Top - FPrevBtn.Top - FPrevBtn.Height - FBar.Height;
        if (FMaxValue > FMinValue) then
          R := (1 / (FMaxValue - FMinValue)) * PixelsCount //每一格的像素数量
        else
          R := 0.0;
        X := Round(FPosition * R);
        Y := FPrevBtn.Top + FPrevBtn.Height + X;
        //当滑动条在一定范围内时，不调整
        if (FBar.Top < Y) or (FBar.Top >= Round(Y + R)) then
          FBar.Top := Y;
      end;
  end;
end;

function THGEScrollbar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  //点击空白处，则翻页
  Result := inherited MouseDown(Button, Shift, X, Y);
  if not Result then Exit;
  X := X - Left;
  Y := Y - Top;
  case FKind of
    sbHorizontal: if (X > FPrevBtn.Width) and (X < FBar.Left) then Position := FPosition - FPageSize
      else if (X > FBar.Left + FBar.Width) and (X < FNextBtn.Left) then Position := FPosition + FPageSize;
    sbVertical: if (Y > FPrevBtn.Height) and (Y < FBar.Top) then Position := FPosition - FPageSize
      else if (Y > FBar.Top + FBar.Height) and (Y < FNextBtn.Top) then Position := FPosition + FPageSize;
  end;
  if (FPrevNextMouseDownState = 0) and (Button = mbLeft) then begin
    FPrevNextMouseDownState := 3;
    FPrevNextMouseDownTick := GetTickCount;
    FPrevNextAutoClickTick := FPrevNextMouseDownTick;
  end;
  Result := True;
end;

function THGEScrollbar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
  if not Result then Exit;
  FPrevNextMouseDownState := 0;
end;

function THGEScrollbar.MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean;
begin
  Result := inherited MouseWheel(Shift, X, Y, Z);
  if not Result then Exit;
  if Z > 0 then
    FPrevBtn.Click(FPrevBtn.Left + 5, FPrevBtn.Top + 5)
  else if Z < 0 then
    FNextBtn.Click(FNextBtn.Left + 5, FNextBtn.Top + 5);
end;

constructor THGEScrollbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMaxValue := 100;
  FMinValue := 0;
  FPosition := 0;
  FKind := sbVertical;
  FPageSize := 2;
  FSmallChange := 1;
  FPrevNextMouseDownState := 0;

  FPrevBtn := THGEButton.Create(nil);
  with FPrevBtn do begin
    OnClick := OnPrevBtnClick;
    OnMouseDown := OnPrevMouseDown;
    OnMouseUp := OnPrevMouseUp;
    DParent := Self;
    Left := 0;
    Top := 0;
    Visible := True;
    Caption := 'Up';
  end;

  FNextBtn := THGEButton.Create(nil);
  with FNextBtn do begin
    OnClick := OnNextBtnClick;
    OnMouseDown := OnNextMouseDown;
    OnMouseUp := OnNextMouseUp;
    DParent := Self;
    Left := 0;
    Top := Self.Height - FNextBtn.Height;
    Visible := True;
    Caption := 'Down';
  end;

  FBar := THGEButton.Create(nil);
  with FBar do begin
    OnMouseDown := OnBarMouseDown;
    OnMouseUp := OnBarMouseUp;
    OnMouseMove := OnBarMouseMove;
    Left := 0;
    Top := FPrevBtn.Height;
    DParent := Self;
    Visible := True;
    Caption := 'Bar';
  end;
  FAutoCheckInRange := False;
  AdjuestBarpos;
end;

destructor THGEScrollbar.Destroy;
begin
  FBar.Free;
  FNextBtn.Free;
  FPrevBtn.Free;
  inherited;
end;

function THGEScrollbar.GetBarFileName: string;
begin
  Result := FBar.FileName;
end;

function THGEScrollbar.GetNextBtnFileName: string;
begin
  Result := FNextBtn.FileName;
end;

function THGEScrollbar.GetPrevBtnFileName: string;
begin
  Result := FPrevBtn.FileName;
end;

procedure THGEScrollbar.Loaded;
begin
  inherited Loaded;
  AddChild(FPrevBtn);
  AddChild(FNextBtn);
  AddChild(FBar);
  FPrevBtn.Width := 1;
  FPrevBtn.Height := 1;
  FNextBtn.Width := 1;
  FNextBtn.Height := 1;
end;

procedure THGEScrollbar.LoadFromIni(sec, Key: string);
begin
  inherited LoadFromIni(sec, Key);
  PrevBtnFilename := FHGE.Ini_GetString(sec, Key + '_Up_Pic', '');
  NextBtnFilename := FHGE.Ini_GetString(sec, Key + '_Down_Pic', '');
  BarFileName := FHGE.Ini_GetString(sec, Key + '_Bar_Pic', '');
end;

procedure THGEScrollbar.OnBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //Result := FBar.MouseDown (Button, Shift, X, Y);
  if ssLeft in Shift then begin         //调整滚动条位置，需要根据滚动条类型
    SpotX := X;
    SpotY := Y;
    boBarMouseMove := False;
  end;
end;

procedure THGEScrollbar.OnBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  len, A, B                 : Integer;
begin
  //调整滚动条的位置，同时触发消息
  if not (ssLeft in Shift) then Exit;
  boBarMouseMove := True;
  case FKind of
    sbHorizontal: if (X <> SpotX) then begin
        len := Width - FBar.Width - FNextBtn.Width;
        if (X >= FPrevBtn.Width) and (Y <= Width - FPrevBtn.Width) then begin
          if FBar.Left + X - SpotX > FPrevBtn.Left + FPrevBtn.Width then
            B := FBar.Left + X - SpotX
          else
            B := FPrevBtn.Width;
          if FBar.Left + X - SpotX < FNextBtn.Left - FBar.Width then
            B := FBar.Left + X - SpotX
          else
            B := FNextBtn.Left - FBar.Width;
          if B < FPrevBtn.Width then B := FPrevBtn.Width;

          A := Round((FMaxValue - FMinValue) * (FBar.Left + X - SpotX - FPrevBtn.Width) / (len - FPrevBtn.Width));
          SpotX := X;
          SpotY := Y;
          FBar.Left := B;
          if A <> FPosition then begin
            Position := A;
          end;
        end;
      end;
    sbVertical: begin
        len := Height - FBar.Height - FNextBtn.Height;
        if (Y >= FPrevBtn.Height) and (Y <= Height - FPrevBtn.Height) then begin
          if FBar.Top + Y - SpotY > FPrevBtn.Top + FPrevBtn.Height then
            B := FBar.Top + Y - SpotY
          else
            B := FPrevBtn.Height;
          if FBar.Top + Y - SpotY < FNextBtn.Top - FBar.Height then
            B := FBar.Top + Y - SpotY
          else
            B := FNextBtn.Top - FBar.Height;

          if B < FPrevBtn.Height then B := FPrevBtn.Height;

          A := Round((FMaxValue - FMinValue) * (FBar.Top + Y - SpotY - FPrevBtn.Height) / (len - FPrevBtn.Height));
          SpotX := X;
          SpotY := Y;
          FBar.Top := B;
          if A <> FPosition then begin
            Position := A;
          end;
        end;
      end;
  end;
end;

procedure THGEScrollbar.OnBarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  boBarMouseMove := False;
  AdjuestBarpos;
end;

procedure THGEScrollbar.OnNextBtnClick(Sender: TObject; X, Y: Integer);
begin
  Position := FPosition + FSmallChange;
end;

procedure THGEScrollbar.OnNextMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then begin
    FPrevNextMouseDownState := 2;
    FPrevNextMouseDownTick := GetTickCount;
    FPrevNextAutoClickTick := FPrevNextMouseDownTick;
  end;
end;

procedure THGEScrollbar.OnNextMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FPrevNextMouseDownState := 0;
end;

procedure THGEScrollbar.OnPrevBtnClick(Sender: TObject; X, Y: Integer);
begin
  Position := FPosition - FSmallChange;
end;

procedure THGEScrollbar.OnPrevMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then begin
    FPrevNextMouseDownState := 1;
    FPrevNextMouseDownTick := GetTickCount;
    FPrevNextAutoClickTick := FPrevNextMouseDownTick;
  end;
end;

procedure THGEScrollbar.OnPrevMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FPrevNextMouseDownState := 0;
end;

procedure THGEScrollbar.DoRender;
var
  lx, ly, lx2, ly2, W, H    : Integer;
  Clipping                  : Boolean;
begin
  if (FPrevNextMouseDownState <> 0) and (Integer(GetTickCount - FPrevNextMouseDownTick) > 250) then begin //自动点击上下翻页按钮
    if (Integer(GetTickCount - FPrevNextAutoClickTick) > 95) then begin
      if FPrevNextMouseDownState = 1 then //自动上翻
        FPrevBtn.Click(0, 0)
      else if FPrevNextMouseDownState = 2 then //自动下翻
        FNextBtn.Click(0, 0)
      else if FPrevNextMouseDownState = 3 then //点击空白处，执行翻页
        ;
      FPrevNextAutoClickTick := GetTickCount;
    end;
  end;

  if FSpr <> nil then begin
    lx := SurfaceX(Left);
    ly := SurfaceY(Top);
    W := Width;
    H := Height - 1;
    Clipping := (CParent <> nil) and (CParent is THGEWindow);
    if Clipping then begin
      lx2 := CParent.SurfaceX(CParent.Left + CParent.ClipRect.Left);
      ly2 := CParent.SurfaceY(CParent.Top + CParent.ClipRect.Top);
      if lx2 > lx then lx := lx2;
      if ly2 > ly then ly := ly2;
      Inc(lx2, CParent.ClipRect.Right);
      Inc(ly2, CParent.ClipRect.Bottom);
      if lx + W > lx2 then W := lx2 - lx;
      if ly + H > ly2 then H := ly2 - ly;
    end;
    FHGE.Gfx_SetClipping(lx, ly, W, H);
    //FSpr.SetColor($3FFFFFFF);
    FSpr.Render(SurfaceX(Left), SurfaceY(Top));
    FHGE.Gfx_SetClipping();
  end;

  //FPrevBtn.Render;
  //FBar.Render;
  //FNextBtn.Render;
end;

procedure THGEScrollbar.SetBarFileName(const Value: string);
begin
  FBar.FileName := Value;
  case FKind of
    sbHorizontal: begin
        FBar.Top := 0;
      end;
    sbVertical: begin
        FBar.Left := 0;
      end;
  end;
  AdjuestBarpos;
end;

procedure THGEScrollbar.SetBarHint(const Value: string);
begin
  FBarHint := Value;
  FBar.Hint := Value;
end;

procedure THGEScrollbar.SetFileName(Value: string);
begin
  inherited SetFileName(Value);
  AdjuestBarpos;
end;

procedure THGEScrollbar.SetKind(const Value: TScrollBarKind);
begin
  FKind := Value;
  AdjuestBarpos;
end;

procedure THGEScrollbar.SetMaxValue(const Value: Integer);
begin
  FMaxValue := Value;
  AdjuestBarpos;
end;

procedure THGEScrollbar.SetMinValue(const Value: Integer);
begin
  FMinValue := Value;
  AdjuestBarpos;
end;

procedure THGEScrollbar.SetNextBtnFileName(const Value: string);
begin
  FNextBtn.FileName := Value;
  case FKind of
    sbHorizontal: begin
        FNextBtn.Top := 0;
        FNextBtn.Left := Width - FNextBtn.Width;
      end;
    sbVertical: begin
        FNextBtn.Left := 0;
        FNextBtn.Top := Height - FNextBtn.Height;
      end;
  end;
  AdjuestBarpos;
end;

procedure THGEScrollbar.SetNextHint(const Value: string);
begin
  FNextHint := Value;
  FNextBtn.Hint := Value;
end;

procedure THGEScrollbar.SetPageSize(const Value: Integer);
begin
  FPageSize := Value;
end;

procedure THGEScrollbar.SetPosition(const Value: Integer);
begin
  FPosition := Value;
  if FPosition > FMaxValue then FPosition := FMaxValue;
  if FPosition < FMinValue then FPosition := FMinValue;
  AdjuestBarpos;
end;

procedure THGEScrollbar.SetPreHint(const Value: string);
begin
  FPreHint := Value;
  FPrevBtn.Hint := Value;
end;

procedure THGEScrollbar.SetPrevBtnFileName(const Value: string);
begin
  FPrevBtn.FileName := Value;
  AdjuestBarpos;
end;

{ THGEListBox }

constructor THGEListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TStringList.Create;
  FItemIndex := -1;
  Font.OnChange := FontChanged;
  FItemHeight := 12;
  FTopIndex := 0;
  FAutoCheckInRange := False;
  FStream := TMemoryStream.Create;
end;

destructor THGEListBox.Destroy;
begin
  FItems.Free;
  FStream.Free;
  inherited;
end;

procedure THGEListBox.FontChanged(Sender: TObject);
begin
  ReDraw;
end;

function THGEListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if (not Result) or (FItemHeight <= 0) then Exit;
  if ssLeft in Shift then begin
    I := Y div FItemHeight;
    if I < FItems.Count then begin
      FItemIndex := I;
    end;
  end;
end;

function THGEListBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
end;

procedure THGEListBox.ReDraw;           //重画列表中的内容
var
  //Bmp                       : TBitmap;
  //png                       : TPNGObject;
  H, I, J                   : Integer;
begin
  FTexture := nil;
  FSpr := nil;
  if FItems.Count = 0 then Exit;
  //Bmp := TBitmap.Create;
  //png := TPNGObject.Create;
  FStream.Clear;
  try
    FBmp.Width := 0;
    FBmp.Height := 0;
    FBmp.Canvas.Font.PixelsPerInch := 96;
    FBmp.Canvas.Font := Font;
    FBmp.PixelFormat := pf32bit;
    FBmp.TransparentMode := tmFixed;
    if Font.Color = clBlack then
      FBmp.TransparentColor := clWhite
    else
      FBmp.TransparentColor := clBlack;
    FBmp.Canvas.brush.Style := bsClear;
    FBmp.Canvas.brush.Color := FBmp.TransparentColor;
    FBmp.Transparent := True;
    FItemHeight := FBmp.Canvas.TextHeight('a');
    FBmp.Width := Width;
    FBmp.Height := Height;
    H := 0;
    for I := FTopIndex to FItems.Count - 1 do begin
      FBmp.Canvas.TextOut(1, H, FItems[I]);
      Inc(H, FItemHeight);
      if H > Height then Break;
    end;
    //转化为PNG
    FPng.Assign(FBmp);
    FPng.SaveToStream(FStream);
    FStream.Seek(soFromBeginning, 0);
    FTexture := FHGE.Texture_Load(FStream.Memory, FStream.Size, False);
    if FTexture <> nil then begin
      FSpr := THGESprite.Create(FTexture, 0, 0, FBmp.Width, FBmp.Height);
    end;
  finally
    //Bmp.Free;
    //png.Free;
  end;
end;

procedure THGEListBox.Render;
begin
  FHGE.Gfx_SetClipping(SurfaceX(Left), SurfaceY(Top), Width, Height);
  inherited Render;
  FHGE.Gfx_SetClipping(0, 0, 0, 0);
  //显示当前选择的项目
  if (FItemIndex < 0) or (FItemIndex >= FItems.Count) then Exit;
end;

procedure THGEListBox.SetItemIndex(const Value: Integer);
begin
  if (Value >= -1) and (Value < FItems.Count) then begin
    FItemIndex := Value;
    ReDraw;
  end;
end;

procedure THGEListBox.SetItems(const Value: TStrings);
begin
  FItems.Assign(Value);
  ReDraw;
end;

procedure THGEListBox.SetTopIndex(const Value: Integer);
var
  I                         : Integer;
begin
  I := Value;
  if (I < 0) then
    I := 0
  else if (I >= FItems.Count) then
    I := FItems.Count - 1;
  if I = FTopIndex then Exit;
  FTopIndex := I;
  ReDraw;
end;

{ THGERadioButton }

procedure THGERadioButton.SetChecked(const Value: Boolean);
var
  I                         : Integer;
begin
  if FChecked = Value then Exit;
  inherited SetChecked(Value);
  if FChecked and (DParent <> nil) then begin
    for I := 0 to DParent.DControls.Count - 1 do begin
      if TObject(DParent.DControls[I]).ClassType = THGERadioButton then begin
        if THGERadioButton(DParent.DControls[I]).FChecked
          and (DParent.DControls[I] <> Self) then
          THGERadioButton(DParent.DControls[I]).Checked := False;
      end;
    end;
    BringToFront;
  end;
end;

{ THGENumber }

procedure THGENumber.AddTexture(FileName: string);
var
  Tex                       : ITexture;
begin
  Tex := FHGE.Texture_Load(FileName);
  if Tex <> nil then begin
    SetLength(FTexList, Length(FTexList) + 1);
    FTexList[Length(FTexList) - 1] := Tex;
    Tex := nil;
  end;
end;

constructor THGENumber.Create;
begin
  inherited;
  SetLength(FTexList, 0);
  FHGE := HGECreate(HGE_VERSION);
end;

destructor THGENumber.Destroy;
var
  I                         : Integer;
begin
  for I := 0 to Length(FTexList) - 1 do
    FTexList[I] := nil;
  SetLength(FTexList, 0);
  inherited;
end;

function THGENumber.GetTex(Index: Integer): ITexture;
begin
  if (Index >= 0) and (Index < Length(FTexList)) then begin
    Result := FTexList[Index]
  end else Result := nil;
end;

//nDir是排版方向，0-正常，1-顺时针转90度，-1：逆时针转90度

procedure THGENumber.Printf(X, Y, nIdx: Integer; str: string; Width: Integer = 0; nAlignment: ShortInt = 0; boDark: Boolean = False; Alpha: Byte = 255; NumCount: Byte = 12; nDir: ShortInt = 0);
var
  I, W, H                   : Integer;
  Tex                       : ITexture;
  Spr                       : IHGESprite;
  B                         : Byte;
begin
  if (nIdx >= 0) and (nIdx < Length(FTexList)) then begin
    Tex := FTexList[nIdx];
    if Tex = nil then Exit;
    W := Tex.GetWidth(True) div NumCount;
    H := Round(Tex.GetHeight(True));
    if (Width > 0) then begin
      if nAlignment = 1 then            //居右
        X := X + (Width - W * Length(str))
      else if nAlignment = 2 then       //居中
        X := X + (Width - W * Length(str)) div 2;
    end;
    for I := 1 to Length(str) do begin
      case str[I] of
        '0'..'9': begin
            Spr := THGESprite.Create(Tex, (ord(str[I]) - ord('0')) * W, 0, W, H);
          end;
        '+': begin
            Spr := THGESprite.Create(Tex, 10 * W, 0, W, H);
          end;
        '-': begin
            Spr := THGESprite.Create(Tex, 11 * W, 0, W, H);
          end;
        ':': begin
            if NumCount = 12 then
              Spr := THGESprite.Create(Tex, 10 * W, 0, W, H)
            else
              Spr := THGESprite.Create(Tex, 12 * W, 0, W, H);
          end;
      else Spr := nil;
      end;
      if Spr <> nil then begin
        if boDark then B := $7F else B := $FF;
        Spr.SetColor(ARGB(Alpha, B, B, B));
        case nDir of
          -1: begin                     //往下排版
              Spr.RenderEx(X, Y, PI / 2);
              Inc(Y, W);
            end;
          0: begin                      //正常
              Spr.Render(X, Y);
              Inc(X, W);
            end;
          1: begin                      //往上排版
              Spr.RenderEx(X, Y, -PI / 2);
              Dec(Y, W);
            end;
        end;
      end else Inc(X, W);
    end;
  end;
end;

function THGENumber.TextHeight(nIdx: Integer): Integer;
begin
  if (nIdx >= 0) and (nIdx < Length(FTexList)) then begin
    Result := FTexList[nIdx].GetHeight(True);
  end else Result := 0;
end;

function THGENumber.TextWidth(nIdx, StrLen: Integer; NumCount: Byte = 12): Integer;
begin
  if (nIdx >= 0) and (nIdx < Length(FTexList)) then begin
    Result := FTexList[nIdx].GetWidth(True) * StrLen div NumCount;
  end else Result := 0;
end;

{ THGEMenu }

function THGEMenu.AddItem(Item: pTMenuItem): Integer;
var
  I, J                      : Integer;
begin
  for J := 0 to Length(FMenuItems) - 1 do begin //检查ID是否存在
    if Item.ID = FMenuItems[J].ID then begin
      Item.ID := -1;
      Break;
    end;
  end;
  I := 0;
  while Item.ID = -1 do begin
    for J := 0 to Length(FMenuItems) - 1 do begin
      if I = FMenuItems[J].ID then Break
      else Item.ID := I;
    end;
    Inc(I);
  end;
  SetLength(FMenuItems, Length(FMenuItems) + 1);
  FMenuItems[Length(FMenuItems) - 1] := Item^;
  FNeedRedraw := True;
  Result := Length(FMenuItems) - 1;
end;

procedure THGEMenu.Clear;
begin
  SetLength(FMenuItems, 0);
  FNeedRedraw := True;
end;

constructor THGEMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetLength(FMenuItems, 0);
  FSubMenu := nil;
  FParentMenu := nil;
  FParentHeight := 12;
  FParentWidth := 0;
  FSelectedIdx := -1;
  FSelectItemTop := 0;
  FAutoCheckInRange := False;
end;

function THGEMenu.DeleteItem(sText: string): Integer;
var
  I, J                      : Integer;
begin
  J := -1;
  Result := -1;
  for I := 0 to Length(FMenuItems) - 1 do begin
    if FMenuItems[I].sText = sText then begin
      J := I;
      Break;
    end;
  end;
  if J = -1 then Exit;
  while J < Length(FMenuItems) - 2 do begin
    FMenuItems[J] := FMenuItems[J + 1];
    Inc(J);
  end;
  SetLength(FMenuItems, Length(FMenuItems) - 1);
  FMinWidth := 0;
  FMaxWidth := 0;
  FNeedRedraw := True;
end;

function THGEMenu.DeleteItem(Idx: Integer): Integer;
var
  I, J                      : Integer;
begin
  J := -1;
  Result := -1;
  for I := 0 to Length(FMenuItems) - 1 do begin
    if FMenuItems[I].ID = Idx then begin
      J := I;
      Break;
    end;
  end;
  if J = -1 then Exit;
  while J < Length(FMenuItems) - 2 do begin
    FMenuItems[J] := FMenuItems[J + 1];
    Inc(J);
  end;
  SetLength(FMenuItems, Length(FMenuItems) - 1);
  FMinWidth := 0;
  FMaxWidth := 0;
  FNeedRedraw := True;
end;

destructor THGEMenu.Destroy;
begin
  if FSubMenu <> nil then FreeAndNil(FSubMenu);
  if FParentMenu <> nil then FocusedControl := FParentMenu;
  inherited;
end;

function THGEMenu.getCount: Integer;
begin
  Result := Length(FMenuItems);
end;

function THGEMenu.GetItemChecked(Index: Integer): Boolean;
begin
  Result := False;
  if (Index >= 0) and (Index < Length(FMenuItems)) then
    Result := FMenuItems[Index].Checked;
end;

function THGEMenu.GetItemEnables(Index: Integer): Boolean;
begin
  Result := False;
  if (Index >= 0) and (Index < Length(FMenuItems)) then
    Result := FMenuItems[Index].Enabled;
end;

function THGEMenu.GetMenuItems(Index: Integer): pTMenuItem;
begin
  Result := nil;
  if (Index >= 0) and (Index < Length(FMenuItems)) then
    Result := @FMenuItems[Index];
end;

function THGEMenu.KeyDown(var Key: word; Shift: TShiftState): Boolean;
begin
  Result := False;
  if (FocusedControl <> Self) or not Enabled then Exit;
  if FSubMenu <> nil then begin
    Result := FSubMenu.KeyDown(Key, Shift);
    Exit;
  end;
  case Key of
    VK_UP: begin

      end;
    VK_DOWN: begin

      end;
    VK_LEFT: begin

      end;
    VK_RIGHT: begin

      end;
    VK_ESCAPE: begin

      end;
  else begin
      Result := inherited KeyDown(Key, Shift);
      Exit;
    end;
  end;
  Result := True;
  FNeedRedraw := True;
end;

function THGEMenu.KeyPress(var Key: Char): Boolean;
begin
  Result := False;
  case ord(Key) of
    VK_EXECUTE: begin

      end;
    VK_RETURN: begin

      end;
  end;
end;

function THGEMenu.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if InRange(X, Y) then begin
      if (MouseCaptureControl = nil) then begin
        SetDCapture(Self);
      end;
      Result := True;
    end else begin
      Result := False;
      if FSubMenu <> nil then
        Result := FSubMenu.MouseDown(Button, Shift, X, Y);
    end;
  end;
  if not Result then Visible := False;
end;

function THGEMenu.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  I, H                      : Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if not Result or not InRange(X, Y) then begin
    if FSubMenu <> nil then
      Result := FSubMenu.MouseMove(Shift, X - FSubMenu.Left, Y - FSubMenu.Top);
    Exit;
  end;
  //计算位置
  H := 2;
  FSelectedIdx := -1;
  Dec(Y, Top);
  for I := 0 to Length(FMenuItems) - 1 do begin
    if FMenuItems[I].sText <> '-' then
      Inc(H, FCertHeight + 6)
    else begin
      Inc(H, 4);
      Continue;
    end;
    if (Y < H) and (Y >= H - FCertHeight - 6) then begin
      if FMenuItems[I].Enabled then begin
        FSelectedIdx := I;
        FSelectItemTop := H - FCertHeight - 6;
      end;
      Break;
    end;
  end;
end;

function THGEMenu.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  I, H                      : Integer;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
  if not Result then begin
    if FSubMenu <> nil then
      Result := FSubMenu.MouseUp(Button, Shift, X - FSubMenu.Left, Y - FSubMenu.Top);
  end;
  if not Result then begin
    Visible := False;
    Exit;
  end;
  //计算位置
  Dec(Y, Top);
  H := 2;
  for I := 0 to Length(FMenuItems) - 1 do begin
    if FMenuItems[I].sText <> '-' then
      Inc(H, FCertHeight + 6)
    else begin
      Inc(H, 4);
      Continue;
    end;
    if Y < H then begin
      if FMenuItems[I].Enabled then begin
        FSelectedIdx := I;
        FSelectItemTop := H - FCertHeight - 6;
      end else
        FSelectedIdx := -1;
      Break;
    end;
  end;
  if FSelectedIdx <> -1 then begin
    Visible := False;
    if Assigned(FMenuItems[FSelectedIdx].Proc) then
      FMenuItems[FSelectedIdx].Proc(Self, @FMenuItems[FSelectedIdx]);
  end;
end;

procedure THGEMenu.Popup(X, Y: Integer; AParentHeight: Integer = 0);
begin
  Left := X;
  Top := Y;
  FParentHeight := AParentHeight;
  FNeedRedraw := True;
  Visible := True;
  SetDCapture(Self);
  //if DParent<>nil then DParent.BringToFront
  //else
  BringToFront;
end;

procedure THGEMenu.ReDraw;
var
  //Bmp                       : TBitmap;
  //png                       : TPNGObject;
  Size, J, I, W, H          : Integer;
  data                      : Pointer;
  Res                       : IResource;
  Stream                    : TMemoryStream;
  FrameBrush                : HBRUSH;
  R                         : TRect;
  Flags                     : UINT;
begin
  FSpr := nil;
  Canvas.Font.PixelsPerInch := 96;
  Canvas.Font := Font;
  FNeedRedraw := False;
  //Bmp := TBitmap.Create;
  //png := TPNGObject.Create;
  Stream := TMemoryStream.Create;
  try
    FBmp.Width := 0;
    FBmp.Height := 0;
    FBmp.Canvas.Font.PixelsPerInch := 96;
    FBmp.Canvas.Font := Font;
    FBmp.PixelFormat := pf32bit;
    FBmp.TransparentMode := tmFixed;
    if Font.Color = clBlack then
      FBmp.TransparentColor := clWhite
    else
      FBmp.TransparentColor := clBlack;
    FBmp.Canvas.brush.Style := bsClear;
    FBmp.Canvas.brush.Color := FBmp.TransparentColor;
    FBmp.Transparent := False;
    FCertHeight := FBmp.Canvas.TextHeight('a'); //计算一行的高度
    W := 20;
    H := 3;
    //计算宽度和高度
    for I := 0 to Length(FMenuItems) - 1 do begin
      J := FBmp.Canvas.TextWidth(FMenuItems[I].sText);
      if W < J + 6 then
        W := J + 6;
      if FMenuItems[I].sText <> '-' then
        Inc(H, FCertHeight + 6)
      else begin
        Inc(H, 4)
      end;
    end;
    if (FMinWidth <> 0) then W := MAX(FMinWidth, W); //限制最小宽度
    if (FMaxWidth <> 0) then W := Min(FMaxWidth, W); //限制最大宽度，不能超过这个宽度

    Inc(W, 12 + 20);
    FBmp.Width := W;
    FBmp.Height := H;
    Width := FBmp.Width;
    Height := FBmp.Height;
    //画边框
    FrameBrush := CreateSolidBrush(ColorToRGB(clBtnShadow));
    FrameRect(FBmp.Canvas.Handle, Classes.Rect(0, 0, FBmp.Width, FBmp.Height), FrameBrush);
    DeleteObject(FrameBrush);
    //显示文字
    H := 4;
    Flags := DT_EXPANDTABS or DT_NOPREFIX;
    Flags := DrawTextBiDiModeFlags(Flags);
    for I := 0 to Length(FMenuItems) - 1 do begin
      if FMenuItems[I].sText <> '-' then begin
        R := Rect(20, H + 1, W - 2, H + FCertHeight + 1);
        if FMenuItems[I].Enabled then
          FBmp.Canvas.Font.Color := clBlack
        else
          FBmp.Canvas.Font.Color := clGrayText;
        DrawText(FBmp.Canvas.Handle, PChar(FMenuItems[I].sText), Length(FMenuItems[I].sText), R, Flags);
        //FBmp.Canvas.TextOut(2,2+H,FMenuItems[I].sText);
        Inc(H, FCertHeight + 6);
      end else begin                    //画线条
        FBmp.Canvas.Pen.Style := psSolid;
        FBmp.Canvas.Pen.Color := clGray;
        FBmp.Canvas.MoveTo(3, H - 1);
        FBmp.Canvas.LineTo(W - 3, H - 1);
        Inc(H, 4);
        //FBmp.Canvas.FillRect(Rect(2,2+H,W -2,1+H));
      end;
    end;
    FPng.Assign(FBmp);
    FPng.SaveToStream(Stream);
    Stream.Seek(soFromBeginning, 0);
    Size := Stream.Size;
    GetMem(data, Size);
    J := Stream.Read(data^, Size);
    if J <> Size then Exit;
    Res := TResource.Create(data, Size);
    FTexture := nil;
    FTexture := FHGE.Texture_Load(Res.Handle, Size, False);
    if FTexture <> nil then begin
      FSpr := THGESprite.Create(FTexture, 0, 0, FBmp.Width, FBmp.Height);
    end;
    Res := nil;
  finally
    //Bmp.Free;
    //png.Free;
    Stream.Free;
  end;
end;

procedure THGEMenu.Render;
var
  lx, ly, II                : Integer;
  FQuad                     : THGEQuad;
  bRedraw                   : Boolean;
begin
  bRedraw := FNeedRedraw;
  FNeedRedraw := False;

  if bRedraw then ReDraw;
  //计算显示位置
  if Spr = nil then Exit;

  lx := SurfaceX(Left);
  ly := SurfaceY(Top);

  if lx + Width + FParentWidth > SCREENWIDTH then
    lx := lx - Width - FParentWidth;

  if ly + Height > SCREENHEIGHT then
    ly := ly - FParentHeight - Height;

  Left := LocalX(lx);
  Top := LocalY(ly);

  Spr.Render(lx, ly);

  //显示选择项的高亮条
  if FSelectedIdx <> -1 then begin
    FQuad.V[0].X := lx + 2;
    FQuad.V[0].Y := ly + FSelectItemTop;
    FQuad.V[1].X := lx + Width - 2;
    FQuad.V[1].Y := FQuad.V[0].Y;
    FQuad.V[2].X := FQuad.V[1].X;
    FQuad.V[2].Y := FQuad.V[1].Y + FCertHeight + 5;
    FQuad.V[3].X := FQuad.V[0].X;
    FQuad.V[3].Y := FQuad.V[2].Y;
    for II := 0 to 3 do begin
      FQuad.V[II].Col := ARGB($4F, $00, $00, $00);
      FQuad.V[II].Z := 0.5;
    end;
    FQuad.V[1].TX := 1;
    FQuad.V[2].TX := 1;
    FQuad.V[2].TY := 1;
    FQuad.V[3].TY := 1;
    FQuad.Blend := BLEND_DEFAULT;
    FHGE.Gfx_RenderQuad(FQuad);
  end;
end;

procedure THGEMenu.SetItemChecked(Index: Integer; const Value: Boolean);
begin

end;

procedure THGEMenu.setItemEnables(Index: Integer; const Value: Boolean);
begin

end;

procedure THGEMenu.SetMaxWidth(const Value: Integer);
begin
  FMaxWidth := Value;
  FNeedRedraw := True;
end;

procedure THGEMenu.SetMinWidth(const Value: Integer);
begin
  FMinWidth := Value;
  FNeedRedraw := True;
end;

procedure THGEMenu.SetVisible(const Value: Boolean);
begin
  if FVisible = Value then Exit;
  FVisible := Value;
  if not FVisible then
    if MouseCaptureControl = Self then
      ReleaseDCapture;
end;

{ THGERichEdit }

procedure THGERichEdit.AddLine(var OffsetX: Integer;
  str: string;
  FColor, BColor: Integer;
  CmdType: Byte;
  CmdStr: string;
  btfilter: Byte = $FF;
  ParserCmd: Boolean = True);
var
  I, len, aline, ip, Col    : Integer;
  temp, CmdParam            : string;
  LastCmd                   : Byte;
  AWord, BWord              : string;
  scl, sHint                : string;
  boGetCmd                  : Boolean;
  AColor                    : Integer;
  ChatItem                  : pTChatMsgItem;
  AWidth                    : Integer;
  boChangeColor             : Boolean;
  ChangeColor               : Integer;

  procedure NewItem;
  var
    newLineChar             : Char;
  begin
    newLineChar := #13;
    if FShowType = 1 then
      newLineChar := '\';
    if (temp <> '') or (AWord = newLineChar) or (I >= len) then begin
      New(ChatItem);
      ChatItem.FColor := AColor;
      ChatItem.BColor := BColor;
      ChatItem.sText := temp;
      ChatItem.OffsetX := OffsetX;
      ChatItem.FCommand := LastCmd;
      ChatItem.FCommandStr := CmdStr;
      ChatItem.sHint := sHint;
      //ChatItem.btFiltFlag:=$FF;
      ChatItem.btFiltFlag := btfilter;
      if (AWord = newLineChar) then begin
        ChatItem.btLineFlag := 1;
      end else if (I >= len) and (CmdType = 0) then
        ChatItem.btLineFlag := 2
      else
        ChatItem.btLineFlag := 0;
      AddItem(ChatItem, AWidth);
      if ChatItem.btLineFlag = 0 then
        OffsetX := OffsetX + AWidth
      else
        OffsetX := 0;
      temp := '';
    end;
  end;
begin
  LastCmd := CmdType;
  boGetCmd := False;                    //CmdType<>0;
  AColor := FColor;
  if ChatItem <> nil then begin
    Dispose(ChatItem);
    ChatItem := nil;
  end;
  len := Length(str);
  temp := '';
  I := 1;
  AWord := '';
  boChangeColor := False;

  if FShowType = 1 then begin
    while I <= len do begin             //获得一行数据
      AWord := str[I];
      Inc(I);
      if Byte(AWord[1]) >= 128 then begin //获得一个字
        if I <= len then begin
          AWord := AWord + str[I];
          Inc(I);
        end;
      end;
      if (AWord = '\') and not boGetCmd then begin
        NewItem;
        Continue;
      end;

      if (AWord = '<') and ParserCmd then begin //检查是不是一个命令的开始
        if not boGetCmd then begin
          Col := AColor;
          if boChangeColor then begin
            //AColor := ChangeColor;
          end;
          NewItem;
          AColor := Col;
          CmdStr := '';
          boGetCmd := True;
        end else begin
          CmdStr := CmdStr + AWord;
        end;
        Continue;
      end;

      if boGetCmd then begin
        if (AWord = '>') then begin     //命令结束
          boGetCmd := False;
          if CmdStr <> '' then begin
            ip := Pos(' HINT=', UpperCase(CmdStr));
            if ip >= 1 then begin
              sHint := Copy(CmdStr, ip + 6, Length(CmdStr));
              Delete(CmdStr, ip, Length(CmdStr));
              ip := Pos('\', sHint);
              while ip > 0 do begin
                sHint := Copy(sHint, 1, ip - 1) + #13#10 + Copy(sHint, ip + 1, Length(sHint)); //替换换行符号
                ip := Posex('\', sHint);
              end;
            end else
              sHint := '';

            if CmdStr <> '' then begin
              if CmdStr[1] = '/' then begin //其他命令结束，恢复命令为空
                AColor := ChangeColor;
                if boChangeColor and (I > len) then begin
                  if ChatItem <> nil then
                    ChatItem.btLineFlag := 2;
                  FNewLine := True;
                end else begin
                  NewItem;              //新的对象   如果：<COLOR=-1>文字</>,则
                  LastCmd := SAYCMD_NONE;
                  AColor := FColor;
                  CmdStr := '';
                  Canvas.Font.Style := [];
                end;
                boChangeColor := False;
              end else if CompareLStr(CmdStr, 'COLOR=', 6) then begin
                temp := GetValidStr3(CmdStr, CmdStr, [' ', ',']);
                AColor := FColor;
                scl := Copy(CmdStr, 7, Length(CmdStr));
                if scl <> '' then begin
                  if CompareText('clLtGray', scl) = 0 then
                    AColor := clLtGray
                  else if CompareText('clDkGray', scl) = 0 then
                    AColor := clDkGray
                  else if scl[1] = '#' then
                    AColor := StrToInt(Copy(scl, 2, Length(scl) - 1))
                  else
                    AColor := StringToColor(scl);
                end;
                LastCmd := SAYCMD_NONE;
                CmdStr := '';
                boChangeColor := True;
                ChangeColor := AColor;

                if temp <> '' then begin
                  NewItem;
                  temp := '';
                  AColor := FColor;
                end;
              end else if CompareLStr(CmdStr, 'LABEL=', 6) then begin //一个脚本标签
                Delete(CmdStr, 1, 6);
                LastCmd := SAYCMD_SCRIPTLABEL;
                AColor := clBlue;
                Canvas.Font.Style := [fsBold];
              end else if CompareLStr(CmdStr, 'URL=', 4) then begin
                LastCmd := SAYCMD_URL;
                AColor := clBlue;
                Delete(CmdStr, 1, 4);
                Canvas.Font.Style := [fsBold];
              end else if CompareLStr(CmdStr, 'Name=', 5) then begin
                LastCmd := SAYCMD_Name;
                Delete(CmdStr, 1, 5);
                AColor := clBlue;
                temp := CmdStr;
                AddLine(OffsetX, CmdStr, AColor, 0, SAYCMD_Name, CmdStr, btfilter, False);
                LastCmd := SAYCMD_NONE;
                CmdStr := '';
                temp := '';
                AColor := FColor;
                //要加一个判断，这个是否是本行数据的最后
                if I >= len then begin
                  temp := '';
                  AWord := #13;
                  NewItem;
                end;
              end else if CompareLStr(CmdStr, 'PIC=', 4) then begin
                LastCmd := SAYCMD_PIC;
                Delete(CmdStr, 1, 4);
                ip := Pos(' LABEL=', UpperCase(CmdStr));
                temp := CmdStr;
                if ip > 0 then begin
                  CmdStr := Copy(CmdStr, ip + 7, Length(temp));
                  Delete(temp, ip, Length(temp));
                end else
                  CmdStr := '';
                NewItem;
                LastCmd := SAYCMD_NONE;
                CmdStr := '';
              end else if CompareLStr(CmdStr, 'CMD=', 4) then begin
                LastCmd := SAYCMD_CMD;
                Delete(CmdStr, 1, 4);
                temp := CmdStr;
                NewItem;
                LastCmd := SAYCMD_NONE;
                CmdStr := '';
                AColor := FColor;
              end else if CompareLStr(CmdStr, 'LINE=', 5) then begin
                LastCmd := SAYCMD_LINE;
                Delete(CmdStr, 1, 5);
                AWord := '\';
                if CmdStr <> '' then begin
                  if CompareText('clLtGray', CmdStr) = 0 then
                    AColor := clLtGray
                  else if CompareText('clDkGray', CmdStr) = 0 then
                    AColor := clDkGray
                  else if CmdStr[1] = '#' then
                    AColor := StrToInt(Copy(CmdStr, 2, Length(CmdStr) - 1))
                  else
                    AColor := StringToColor(CmdStr);
                end;
                NewItem;
                CmdStr := '';
                AColor := FColor;
                LastCmd := SAYCMD_NONE;
              end else begin
                ip := Pos('/', CmdStr);
                if ip > 0 then begin
                  CmdParam := GetValidStr3(CmdStr, CmdStr, ['/']);
                  LastCmd := SAYCMD_CMD; //SAYCMD_SCRIPTLABEL;
                  temp := CmdStr;
                  CmdStr := CmdParam;
                  AColor := clYellow;
                  NewItem;
                  AColor := FColor;
                  LastCmd := SAYCMD_NONE;
                  CmdStr := '';
                end else begin
                  AColor := FColor;
                  temp := temp + CmdStr;
                end;
              end;
            end;
          end;
        end else begin
          CmdStr := CmdStr + AWord;
        end;
        Continue;
      end;

      //普通文本或者命令的显示文字
      aline := Canvas.TextWidth(temp + AWord);
      if aline + OffsetX >= Width then begin
        BWord := AWord;
        AWord := '\';
        NewItem;
        temp := BWord;
        Continue;
      end else begin
        temp := temp + AWord;
      end;

    end;

    if temp <> '' then begin
      AWord := '';
      NewItem;
    end;
    Exit;
  end;

  while I <= len do begin               //获得一行数据
    AWord := str[I];
    Inc(I);
    if Byte(AWord[1]) >= 128 then begin //获得一个字
      if I <= len then begin
        AWord := AWord + str[I];
        Inc(I);
      end;
    end else if AWord[1] = #13 then begin
      if (I <= len) and (str[I] = #10) then begin
        AWord := #13;
        Inc(I);
      end;
    end;
    if (AWord = #13) and not boGetCmd then begin
      NewItem;
      Continue;
    end;

    if (AWord = '<') and ParserCmd then begin //检查是不是一个命令的开始
      if not boGetCmd then begin
        Col := AColor;
        if boChangeColor then begin
          //AColor := ChangeColor;
        end;
        NewItem;
        AColor := Col;
        CmdStr := '';
        boGetCmd := True;
      end else
        CmdStr := CmdStr + AWord;
      Continue;
    end;

    if boGetCmd then begin
      if (AWord = '>') then begin       //命令结束
        boGetCmd := False;
        if CmdStr <> '' then begin
          ip := Pos(' HINT=', UpperCase(CmdStr));
          if ip >= 1 then begin
            sHint := Copy(CmdStr, ip + 6, Length(CmdStr));
            Delete(CmdStr, ip, Length(CmdStr));
            ip := Pos('\', sHint);
            while ip > 0 do begin
              sHint := Copy(sHint, 1, ip - 1) + #13#10 + Copy(sHint, ip + 1, Length(sHint)); //替换换行符号
              ip := Posex('\', sHint);
            end;
          end else
            sHint := '';

          if CmdStr <> '' then begin
            if CmdStr[1] = '/' then begin //其他命令结束，恢复命令为空
              AColor := ChangeColor;
              if boChangeColor and (I > len) then begin
                if ChatItem <> nil then
                  ChatItem.btLineFlag := 2;
                FNewLine := True;
              end else begin
                NewItem;                //新的对象   如果：<COLOR=-1>文字</>,则
                LastCmd := SAYCMD_NONE;
                AColor := FColor;
                CmdStr := '';
                Canvas.Font.Style := [];
              end;
              boChangeColor := False;
            end else if CompareLStr(CmdStr, 'COLOR=', 6) then begin
              temp := GetValidStr3(CmdStr, CmdStr, [' ', ',']);
              AColor := FColor;
              scl := Copy(CmdStr, 7, Length(CmdStr));
              if scl <> '' then begin
                if CompareText('clLtGray', scl) = 0 then
                  AColor := clLtGray
                else if CompareText('clDkGray', scl) = 0 then
                  AColor := clDkGray
                else if scl[1] = '#' then
                  AColor := StrToInt(Copy(scl, 2, Length(scl) - 1))
                else
                  AColor := StringToColor(scl);
              end;
              LastCmd := SAYCMD_NONE;
              CmdStr := '';
              boChangeColor := True;
              ChangeColor := AColor;
              if temp <> '' then begin
                NewItem;
                temp := '';
                AColor := FColor;
              end;
            end else if CompareLStr(CmdStr, 'LABEL=', 6) then begin //一个脚本标签
              Delete(CmdStr, 1, 6);
              LastCmd := SAYCMD_SCRIPTLABEL;
              AColor := clBlue;
              Canvas.Font.Style := [fsBold];
            end else if CompareLStr(CmdStr, 'URL=', 4) then begin
              LastCmd := SAYCMD_URL;
              AColor := clBlue;
              Delete(CmdStr, 1, 4);
              Canvas.Font.Style := [fsBold];
            end else if CompareLStr(CmdStr, 'Name=', 5) then begin
              LastCmd := SAYCMD_Name;
              Delete(CmdStr, 1, 5);
              AColor := clBlue;
              temp := CmdStr;
              AddLine(OffsetX, CmdStr, AColor, 0, SAYCMD_Name, CmdStr, btfilter, False);
              LastCmd := SAYCMD_NONE;
              CmdStr := '';
              temp := '';
              AColor := FColor;
              if I >= len then begin
                temp := '';
                AWord := #13;
                NewItem;
              end;
            end else if CompareLStr(CmdStr, 'PIC=', 4) then begin
              LastCmd := SAYCMD_PIC;
              Delete(CmdStr, 1, 4);
              ip := Pos(' LABEL=', UpperCase(CmdStr));
              temp := CmdStr;
              if ip > 0 then begin
                CmdStr := Copy(CmdStr, ip + 7, Length(temp));
                Delete(temp, ip, Length(temp));
              end else CmdStr := '';
              NewItem;
              LastCmd := SAYCMD_NONE;
              CmdStr := '';
            end else if CompareLStr(CmdStr, 'CMD=', 4) then begin
              LastCmd := SAYCMD_CMD;
              Delete(CmdStr, 1, 4);
              temp := CmdStr;
              NewItem;
              LastCmd := SAYCMD_NONE;
              CmdStr := '';
              AColor := FColor;
            end else if CompareLStr(CmdStr, 'LINE=', 5) then begin
              LastCmd := SAYCMD_LINE;
              Delete(CmdStr, 1, 5);
              AWord := #13;
              if CmdStr <> '' then begin
                if CompareText('clLtGray', CmdStr) = 0 then
                  AColor := clLtGray
                else if CompareText('clDkGray', CmdStr) = 0 then
                  AColor := clDkGray
                else if CmdStr[1] = '#' then
                  AColor := StrToInt(Copy(CmdStr, 2, Length(CmdStr) - 1))
                else
                  AColor := StringToColor(CmdStr);
              end;
              NewItem;
              CmdStr := '';
              AColor := FColor;
              LastCmd := SAYCMD_NONE;
            end else begin
              ip := Pos('/', CmdStr);
              if ip > 0 then begin
                CmdParam := GetValidStr3(CmdStr, CmdStr, ['/']);
                LastCmd := SAYCMD_CMD;  //SAYCMD_SCRIPTLABEL;
                temp := CmdStr;
                CmdStr := CmdParam;
                AColor := clYellow;
                NewItem;
                AColor := FColor;
                LastCmd := SAYCMD_NONE;
                CmdStr := '';
              end else begin
                AColor := FColor;
                temp := temp + CmdStr;
              end;
            end;
          end;
        end;
      end else begin
        CmdStr := CmdStr + AWord;
      end;
      Continue;
    end;

    //普通文本或者命令的显示文字
    aline := Canvas.TextWidth(temp + AWord);
    if aline + OffsetX >= Width then begin
      BWord := AWord;
      AWord := #13;
      NewItem;
      temp := BWord;
      Continue;
    end else
      temp := temp + AWord;
  end;

  if temp <> '' then begin
    AWord := '';
    NewItem;
  end;
end;

function THGERichEdit.AddItem(Item: pTChatMsgItem; var ItemWidth: Integer): Integer;
var
  Wide                      : Boolean;
  //lb                        : THGELabel;
  Line                      : TList;
  ATex                      : ITexture;
begin
  FReDrawbar := True;
  if (FItems.Count = 0) or FNewLine then begin
    Line := TList.Create;
    FItems.Add(Line);
    FNewLine := False;
    if FShowType = 0 then begin
      if Count - FTopIndex > FVisibleLines then begin
        TopIndex := FTopIndex + 1;
        if Count - TopIndex < FVisibleLines then
          TopIndex := Count - FVisibleLines;
      end;
    end else begin
      TopIndex := 0;
    end;
  end else
    Line := FItems[FItems.Count - 1];

  if Item.FCommand = SAYCMD_PIC then begin //图片
    ATex := FHGE.Texture_Load(Item.sText);
    if ATex <> nil then begin
      Item.FSpr := THGESprite.Create(ATex, 0, 0, ATex.GetWidth(True), ATex.GetHeight(True));
      if Item.FSpr <> nil then begin
        ItemWidth := Round(Item.FSpr.GetWidth);
        Item.Height := Round(Item.FSpr.GetHeight);
      end else begin
        ItemWidth := 0;
        Item.Height := 0;
      end;
    end else begin
      Item.FSpr := nil;
      ItemWidth := 0;
      Item.Height := 0;
    end;
  end else if Item.FCommand = SAYCMD_LINE then begin
    Item.FSpr := nil;
    Item.Height := 3;
    ItemWidth := Width - Item.OffsetX;
  end else begin
    FLabel.Font := Font;
    FLabel.Font.Color := Item.FColor;
    FLabel.Transparent := (Item.BColor = -1);
    if not FLabel.Transparent then
      FLabel.Color := Item.BColor;
    if Item.FCommand in [SAYCMD_URL, SAYCMD_SCRIPTLABEL] then
      FLabel.Font.Style := [fsBold]
    else
      FLabel.Font.Style := [];

    FLabel.AutoSize := True;
    FLabel.Caption := Item.sText;
    Item.FSpr := FLabel.Spr;
    ItemWidth := FLabel.Width - 2;
    if Item.FSpr = nil then
      Item.Height := Canvas.TextHeight('h')
    else
      Item.Height := FLabel.Height;
  end;
  if ((Item.OffsetX + ItemWidth > Width) or ((Item.FCommand = SAYCMD_NONE) and (Item.sText = ''))) and (Item.btLineFlag = 0) then
    Item.btLineFlag := 1;
  Line.Add(Item);
  Result := FItems.Count;
  if Item.btLineFlag <> 0 then
    FNewLine := True;
  //if FAutoSize then FNeedRedraw:=True;     //防止重复整理
  if FScrollbar <> nil then begin
    FScrollbar.MaxValue := Count - 1;
  end;
end;

procedure THGERichEdit.ReDraw;
var
  I, J                      : Integer;
  Line                      : TList;
  Item                      : pTChatMsgItem;
  OffsetX                   : Integer;
  MaxH                      : Integer;
  H                         : Integer;
  NewItems                  : TGList;
  AWidth                    : Integer;
  sText                     : string;
begin
  Exit;                                 //1111

  FNeedRedraw := False;
  //重新排列
  NewItems := TGList.Create;
  NewItems.Assign(FItems);
  FItems.Clear;
  I := 0;
  sText := '';
  OffsetX := 0;
  while I < NewItems.Count do begin
    Line := NewItems[I];
    Inc(I);
    J := 0;
    while J < Line.Count do begin
      Item := Line[J];
      Inc(J);
      case Item.FCommand of
        SAYCMD_NONE: begin
            if Length(Item.sText) = 0 then
              sText := sText + #13
            else if Item.sText = '<' then
              sText := sText + '<<>'
            else if Item.sText = '>' then
              sText := sText + '<>>'
            else
              sText := sText + '<COLOR=' + IntToStr(Item.FColor) + '>' + Item.sText + '</>';
          end;
        SAYCMD_Name: sText := sText + '<Name=' + Item.sText + '>';
        SAYCMD_URL: begin
            sText := sText + '<URL=' + Item.FCommandStr;
            if Item.sHint <> '' then sText := sText + ' HINT=' + Item.sHint;
            sText := sText + '>' + Item.sText + '</>';
          end;
        SAYCMD_SCRIPTLABEL: begin
            sText := sText + '<LABEL=' + Item.FCommandStr;
            if Item.sHint <> '' then sText := sText + ' HINT=' + Item.sHint;
            sText := sText + '>' + Item.sText + '</>';
          end;
        SAYCMD_CMD: begin
            sText := sText + '<CMD=' + Item.FCommandStr;
            if Item.sHint <> '' then sText := sText + ' HINT=' + Item.sHint;
            sText := sText + '>' + Item.sText + '</>';
          end;
        SAYCMD_PIC: begin
            sText := sText + '<PIC=' + Item.sText;
            if Item.sHint <> '' then sText := sText + ' HINT=' + Item.sHint;
            sText := sText + '></>';
          end;
        SAYCMD_LINE: begin
            sText := sText + #13'<LINE=' + IntToStr(Item.FColor) + '></>';
          end;
      end;
      if (Item.btLineFlag = 2) or ((Item.FCommand = SAYCMD_NONE) and (Item.btLineFlag = 1) and (Item.sText = '')) then begin
        OffsetX := 0;
        FNewLine := True;
        if sText = '' then sText := #13;
        AddLine(OffsetX, sText, 0, 0, SAYCMD_NONE, '', 255, True);
        sText := '';
      end;
    end;
  end;
  if sText <> '' then begin
    OffsetX := 0;
    AddLine(OffsetX, sText, 0, 0, SAYCMD_NONE, '', 255, True);
  end;
  for I := 0 to NewItems.Count - 1 do begin
    Line := NewItems[I];
    for J := 0 to Line.Count - 1 do
      Dispose(pTChatMsgItem(Line[J]));
    Line.Free;
  end;
  NewItems.Free;
  //宽度调整后，重新排列
  if FAutoSize then begin
    H := 0;
    for I := 0 to FItems.Count - 1 do begin
      MaxH := 0;
      Line := FItems[I];
      for J := 0 to Line.Count - 1 do begin
        Item := Line[J];
        MaxH := Math.MAX(MaxH, Item.Height);
      end;
      Inc(H, MaxH + 2);
    end;
    Height := H;
  end;
end;

procedure THGERichEdit.Clear;
var
  I, J                      : Integer;
  Line                      : TList;
begin
  for I := 0 to FItems.Count - 1 do begin
    Line := FItems[I];
    for J := 0 to Line.Count - 1 do
      Dispose(pTChatMsgItem(Line[J]));
    Line.Free;
  end;
  FItems.Clear;
  MouseInItem := nil;
  TopIndex := 0;
end;

constructor THGERichEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowType := 0;
  FReDrawbar := False;
  FNeedRedraw := False;
  FScrollbar := nil;
  FNewLine := True;
  FItems := TGList.Create;
  FAutoCheckInRange := False;
  FAutoSize := False;
  FVisibleLines := MaxInt;
  FMouseDownItem := nil;
  FMouseInItem := nil;
  FFilter := $FF;
  FLabel := THGELabel.Create(nil);
  FLabel.ParentWindow := g_GE.HGE.System_GetState(HGE.HGE_HWND);
  FEnableFocus := True;
  Canvas.Font := Font;
end;

destructor THGERichEdit.Destroy;
var
  I, J                      : Integer;
  Line                      : TList;
begin
  Scrollbar := nil;
  for I := 0 to FItems.Count - 1 do begin
    Line := FItems[I];
    for J := 0 to Line.Count - 1 do
      Dispose(pTChatMsgItem(Line[J]));
    Line.Free;
  end;
  FLabel.Free;
  FItems.Free;
  inherited;
end;
{$IFDEF DARK}

procedure THGERichEdit.Dark(bFlag: Boolean);
var
  I, J                      : Integer;
  Line                      : TList;
  Item                      : pTChatMsgItem;
begin
  inherited Dark(bFlag);
  for I := 0 to FItems.Count - 1 do begin
    Line := FItems[I];
    for J := 0 to Line.Count - 1 do begin
      Item := Line[J];
      if Item.FSpr <> nil then begin
        if bFlag then
          Item.FSpr.SetColor(ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT))
        else
          Item.FSpr.SetColor(ARGB(FAlpha, FLight, FLight, FLight));
      end;
    end;
  end;
end;
{$ENDIF}

procedure THGERichEdit.DelItem(Idx: Integer); //删除一行
var
  Line                      : TList;
  I                         : Integer;
begin
  if (Idx >= 0) and (Idx < FItems.Count) then begin
    Line := FItems[Idx];
    for I := 0 to Line.Count - 1 do
      Dispose(pTChatMsgItem(Line[I]));
    Line.Free;
    FItems.Delete(Idx);
  end;
end;

function THGERichEdit.getCount: Integer;
var
  I                         : Integer;
  Line                      : TList;
begin
  Result := FItems.Count;
  //  for I := 0 to FItems.Count - 1 do begin
  //    Line:=FItems[I];
  //    if (Line.Count>0) and (pTChatMsgItem(Line[0]).btFiltFlag and FFilter=0) then continue;
  //    Inc(Result);
  //  end;
end;

procedure THGERichEdit.LoadFromIni(sec, Key: string);
var
  I                         : Integer;
begin
  I := Width;
  inherited LoadFromIni(sec, Key);
  if I <> Width then FNeedRedraw := True;
  Font.Name := FHGE.Ini_GetString(sec, Key + '_FontName', Font.Name);
  Font.Size := FHGE.Ini_GetInt(sec, Key + '_FontSize', Font.Size);
  Canvas.Font.Assign(Font);
  VisibleLines := FHGE.Ini_GetInt(sec, Key + '_VisibleLines', FVisibleLines);
  Color := FHGE.Ini_GetInt(sec, Key + '_Color', Color);
  Canvas.Font.PixelsPerInch := 96;
  Canvas.Font := Font;
end;

function THGERichEdit.GetItemAtPos(X, Y: Integer): pTChatMsgItem;
var
  I, J                      : Integer;
  Line                      : TList;
  Item                      : pTChatMsgItem;
  lx, ly, W, H              : Integer;
  MaxH                      : Integer;
begin
  ly := 0;
  Result := nil;
  //查找点击的对象
  for I := FTopIndex to FItems.Count - 1 do begin
    Line := FItems[I];
    if (Line.Count > 0) and (pTChatMsgItem(Line[0]).btFiltFlag and FFilter = 0) then Continue;
    MaxH := 0;
    for J := 0 to Line.Count - 1 do begin
      Item := Line[J];
      lx := Item.OffsetX;
      if Item.FSpr = nil then
        W := 0
      else
        W := Round(Item.FSpr.GetWidth);
      H := Item.Height;
      if (X >= lx) and (X <= lx + W) and (Y >= ly) and (Y <= ly + H) then begin
        Result := Item;
        Exit;
      end;
      MaxH := MAX(MaxH, Item.Height);
      if Item.btLineFlag <> 0 then
        Inc(ly, MaxH + 1);
    end;
  end;
end;

function THGERichEdit.KeyDown(var Key: word; Shift: TShiftState): Boolean;
begin
  Result := inherited KeyDown(Key, Shift);

  if not Result or (Scrollbar = nil) or ((ShowType = 1) and not Scrollbar.Visible) then Exit;

  //if ShowType = 1 then begin
  //  if (Scrollbar = nil) or not Scrollbar.Visible then Exit;
  //end;

  case Key of
    VK_UP: begin                        //上翻1行
        TopIndex := TopIndex - 1;
        Key := 0;
      end;
    VK_DOWN: begin                      //下翻1行
        TopIndex := TopIndex + 1;
        Key := 0;
      end;
    VK_PRIOR: begin
        TopIndex := TopIndex - FVisibleLines;
        Key := 0;
      end;
    VK_NEXT: begin
        TopIndex := TopIndex + FVisibleLines;
        Key := 0;
      end;
    VK_END: begin
        TopIndex := MaxInt;
        Key := 0;
      end;
    VK_HOME: begin
        TopIndex := 0;
        Key := 0;
      end;
  end;
end;

function THGERichEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (MouseCaptureControl = nil) then begin
      SetDCapture(Self);
    end;
    FMouseDownItem := GetItemAtPos(X - Left, Y - Top);
    if Assigned(FOnMouseDown) then
      FOnMouseDown(Self, Button, Shift, X, Y);
    Result := True;
  end;
end;

procedure THGERichEdit.MouseEnter;
begin
  inherited;
end;

procedure THGERichEdit.MouseLeave;
begin
  inherited MouseLeave;
  FMouseDownItem := nil;
  FMouseInItem := nil;
end;

function THGERichEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  Item                      : pTChatMsgItem;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
  ReleaseDCapture;
  if not Result then Exit;
  //查找点击的对象
  Item := GetItemAtPos(X - Left, Y - Top);
  if (Item <> nil) and Assigned(FOnCommand) then
    FOnCommand(Self, Item.FCommand, Item.FCommandStr, Button, Shift);
  FMouseDownItem := nil;
end;

function THGERichEdit.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result then begin
    FMouseInItem := GetItemAtPos(X - Left, Y - Top);
    if FMouseInItem = nil then begin
      SetCursor(crDefault);
      if Hint <> '' then begin
        Hint := '';
        NeedFlushHint := True;
      end;
    end else begin
      case FMouseInItem.FCommand of
        SAYCMD_URL, SAYCMD_SCRIPTLABEL, SAYCMD_Name, SAYCMD_CMD, SAYCMD_CMD2: if Length(FMouseInItem.FCommandStr) <> 0 then
            SetCursor(crHandPoint) else SetCursor(crDefault);
        SAYCMD_PIC: if Length(FMouseInItem.FCommandStr) <> 0 then
            SetCursor(crHandPoint) else SetCursor(crDefault);
      else
        SetCursor(crDefault);
      end;
      if Hint <> FMouseInItem.sHint then begin
        Hint := FMouseInItem.sHint;
        NeedFlushHint := True;
      end;
    end;
  end;
end;

function THGERichEdit.MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean;
begin
  Result := inherited MouseWheel(Shift, X, Y, Z);
  if not Result or (Scrollbar = nil) or ((ShowType = 1) and not Scrollbar.Visible) then Exit;
  if Z > 0 then
    TopIndex := FTopIndex - 1
  else if Z < 0 then
    TopIndex := FTopIndex + 1;
end;

procedure THGERichEdit.OnScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollPos <> FTopIndex then begin
    if FTopIndex > ScrollPos then begin //向上滚动，则要检查光标是否会出现在输入框下面
      FTopIndex := ScrollPos;
    end else begin
      FTopIndex := ScrollPos;
    end;
  end;
end;

procedure THGERichEdit.DoRender;
var
  I, J, lx, ly, my          : Integer;
  Line                      : TList;
  Item                      : pTChatMsgItem;
  MaxH                      : Integer;
  DrawScrollbar             : Boolean;
begin
  if FNeedRedraw then begin
    FNeedRedraw := False;
    ReDraw;
  end;

  DrawScrollbar := False;
  lx := SurfaceX(Left);
  ly := SurfaceY(Top);
  my := ly + Height;
  FHGE.Gfx_SetClipping(lx, ly, Width, Height);
  for I := FTopIndex to FItems.Count - 1 do begin
    Line := FItems[I];
    if (Line.Count > 0) and (pTChatMsgItem(Line[0]).btFiltFlag and FFilter = 0) then Continue;

    MaxH := 0;
    for J := 0 to Line.Count - 1 do begin
      Item := pTChatMsgItem(Line[J]);
      if Item.FSpr <> nil then begin
        if (Item.FCommand in [SAYCMD_URL, SAYCMD_SCRIPTLABEL, SAYCMD_Name, SAYCMD_CMD, SAYCMD_CMD2]) then begin
          if (Item = FMouseDownItem) then begin
            Item.FSpr.Render(lx + Item.OffsetX + 1, ly + 1);
            FHGE.Gfx_RenderLine(lx + Item.OffsetX,
              ly + 1 + Item.FSpr.GetHeight,
              lx + Item.OffsetX + 3 + Item.FSpr.GetWidth,
              ly + 1 + Item.FSpr.GetHeight,
              ARGB($FF, GetB(Item.FColor), GetG(Item.FColor), GetR(Item.FColor)));
            //ColorToRGB(-Item.FColor) or $FF000000);
          end else if (Item = FMouseInItem) then begin
            Item.FSpr.Render(lx + Item.OffsetX, ly);
            //下划线
            FHGE.Gfx_RenderLine(lx + Item.OffsetX - 1,
              ly + 0 + Item.FSpr.GetHeight,
              lx + Item.OffsetX + 2 + Item.FSpr.GetWidth,
              ly + 0 + Item.FSpr.GetHeight,
              ARGB($FF, GetB(Item.FColor), GetG(Item.FColor), GetR(Item.FColor)));
            //ColorToRGB(Item.FColor) or $FF000000);
          end else
            Item.FSpr.Render(lx + Item.OffsetX, ly);
        end else if (Item.FCommand = SAYCMD_PIC) and (Length(Item.FCommandStr) > 0) then begin
          if (Item = FMouseDownItem) then
            Item.FSpr.Render(lx + Item.OffsetX + 1, ly + 1)
          else
            Item.FSpr.Render(lx + Item.OffsetX, ly)
        end else
          Item.FSpr.Render(lx + Item.OffsetX, ly);
      end else if Item.FCommand = SAYCMD_LINE then begin
        FHGE.Gfx_RenderLine(lx + Item.OffsetX,
          ly + 0,
          lx + Width,
          ly + 0,
          ARGB($FF, GetB(Item.FColor), GetG(Item.FColor), GetR(Item.FColor)));
        //Item.FColor);
      end;
      MaxH := MAX(MaxH, Item.Height);
    end;
    Inc(ly, MaxH + 1);
    if ly > my then begin
      DrawScrollbar := True;
      Break;
    end;
  end;
  //if (FShowType = 1) and (FScrollbar <> nil) then begin
  //  FScrollbar.Visible := Drawbar;
  //end;

  FHGE.Gfx_SetClipping(0, 0, 0, 0);
end;

procedure THGERichEdit.SetAutoSize(const Value: Boolean);
begin
  FAutoSize := Value;
  if FAutoSize then FNeedRedraw := True;
end;

procedure THGERichEdit.SetFilter(const Value: Byte);
begin
  if Value = 0 then FFilter := $FF
  else FFilter := Value;
  SetScrollbar(FScrollbar);
end;

procedure THGERichEdit.SetScrollbar(const Value: THGEScrollbar);
begin
  FScrollbar := Value;
  if FScrollbar <> nil then begin
    FScrollbar.MaxValue := Count - 1;
    FScrollbar.Position := FTopIndex;
    FScrollbar.OnScroll := OnScrollBarScroll;
  end;
end;

procedure THGERichEdit.SetTopIndex(const Value: Integer);
begin
  if Value < 0 then FTopIndex := 0
  else if FTopIndex = Value then Exit;
  FTopIndex := Value;
  if Assigned(FScrollbar) then
    FScrollbar.Position := FTopIndex;
end;

procedure THGERichEdit.SetVisibleLines(const Value: Integer);
begin
  FVisibleLines := Value;
end;

{ THGEListView }

procedure THGEListView.AddColumn(AWidth: Integer; Alignment: TAlignment);
var
  I                         : Integer;
begin
  I := Length(FColumns);
  SetLength(FColumns, I + 1);
  FColumns[I].Alignment := Alignment;
  FColumns[I].Width := AWidth;
end;

function THGEListView.AddItem(Args: array of string; ItemEnabled: Boolean = True; ItemChecked: Boolean = False; sHint: string = ''; data: Pointer = nil): Integer;
var
  I, Count                  : Integer;
  Item                      : pTHGEListViewItem;
begin
  Count := Length(Args);
  if Count = 0 then Count := Length(FColumns);
  New(Item);
  SetLength(Item.data, Count);
  SetLength(Item.Image, Count);
  for I := 0 to Count - 1 do begin
    Item.data[I] := '';
    Item.Image[I] := nil;
  end;
  Item.Enabled := ItemEnabled;
  Item.Checked := ItemChecked;
  I := Length(Args);
  if I < Count then Count := I;
  Item.PData := data;
  Item.sHint := sHint;
  Result := FItems.Add(Item);
  for I := 0 to Count - 1 do begin
    Item.data[I] := Args[I];
    ReDraw(FItems.Count - 1, I);
  end;

  if FScrollbar <> nil then FScrollbar.MaxValue := MAX(0, FItems.Count - FShowCount);
end;

procedure THGEListView.Clear;
var
  I, J                      : Integer;
  Item                      : pTHGEListViewItem;
begin
  for I := 0 to FItems.Count - 1 do begin
    Item := FItems[I];
    for J := 0 to Length(Item.data) - 1 do begin
      Item.data[J] := '';
      Item.Image[J] := nil;
    end;
    SetLength(Item.data, 0);
    Item.PData := nil;
    Dispose(Item);
  end;
  FItems.Clear;
  FItemIndex := -1;
  FMouseItemIndex := -1;
  FTopIndex := 0;
  if FScrollbar <> nil then FScrollbar.MaxValue := FItems.Count;
end;

procedure THGEListView.ClearColumns;
begin
  SetLength(FColumns, 0);
end;

constructor THGEListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TList.Create;
  FMouseItemIndex := -1;
  FItemIndex := -1;
  FItemHeight := 13;
  SetLength(FColumns, 0);
  FScrollbar := nil;
  FItemFont.FontName := '宋体';
  FItemFont.FontSize := 9;
  FItemFont.NormalColor := $FFFFFFFF;
  FItemFont.SelectColor := $FFFFFF00;
  FItemFont.SelectBackColor := $FF0000FF;
  FItemFont.HighlightColor := $FFFF0000;
  FItemFont.HighlightBackColor := $FF00FF00;
  FItemFont.DisableColor := $FFAAAAAA;
  FItemFont.DisableBackColor := $FF111111;
  FAutoCheckInRange := False;
  FEnableFocus := True;
  FTopIndex := 0;
  FBoxTex := nil;
  FShowCount := 0;
  FLabel := THGELabel.Create(nil);
  FLabel.ParentWindow := g_GE.HGE.System_GetState(HGE.HGE_HWND);
  //FLabel.Name := 'THGEListView.FLabel';
end;

procedure THGEListView.DelItem(Index: Integer);
var
  Item                      : pTHGEListViewItem;
begin
  if (Index < 0) or (Index >= FItems.Count) then Exit;
  Item := pTHGEListViewItem(FItems[Index]);
  Item.PData := nil;
  Item.Image := nil;
  Dispose(Item);
  FItems.Delete(Index);
  if FScrollbar <> nil then FScrollbar.MaxValue := FItems.Count;
  FItemIndex := -1;
end;

destructor THGEListView.Destroy;
begin
  FScrollbar := nil;
  Clear;
  ClearColumns;
  FItems.Free;
  FLabel.Free;
  inherited;
end;

function THGEListView.GetColumns(Index: Integer): PTLVColumn;
begin
  if (Index >= 0) and (Index < Length(FColumns)) then
    Result := @FColumns[Index]
  else begin
    Result := nil;
  end;
end;

function THGEListView.GetItem(Row, Col: Integer): string;
var
  Item                      : pTHGEListViewItem;
begin
  Result := '';
  if (Row < 0) or (Row >= FItems.Count) or (Col < 0) then Exit;
  Item := FItems[Row];
  if (Col >= Length(Item.data)) then Exit;
  Result := Item.data[Col];
end;

function THGEListView.GetItemChecked(Index: Integer): Boolean;
begin
  Result := False;
  if (Index >= 0) and (Index < FItems.Count) then
    Result := pTHGEListViewItem(FItems[Index]).Checked;
end;

function THGEListView.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function THGEListView.GetItemData(Index: Integer): Pointer;
begin
  Result := nil;
  if (Index >= 0) and (Index < FItems.Count) then
    Result := pTHGEListViewItem(FItems[Index]).PData;
end;

function THGEListView.GetItemEnabled(Index: Integer): Boolean;
begin
  Result := False;
  if (Index >= 0) and (Index < FItems.Count) then
    Result := pTHGEListViewItem(FItems[Index]).Enabled;
end;

procedure THGEListView.ItemMove(CurIndex, NewIndex: Integer);
begin
  FItems.Move(CurIndex, NewIndex);
end;

function THGEListView.KeyDown(var Key: word; Shift: TShiftState): Boolean;
begin
  //支持光标上下键移动当前选择项、回车选择
  Result := inherited KeyDown(Key, Shift);
end;

function THGEListView.KeyUp(var Key: word; Shift: TShiftState): Boolean;
begin
  Result := inherited KeyDown(Key, Shift);
end;

procedure THGEListView.LoadFromIni(sec, Key: string);
var
  I, J, K                   : Integer;
  s                         : string;
begin
  inherited LoadFromIni(sec, Key);
  FItemHeight := FHGE.Ini_GetInt(sec, Key + '_ItemHeight', 17);
  I := 1;
  //获取列设置信息
  repeat
    J := FHGE.Ini_GetInt(sec, Key + '_ColumnWidth' + IntToStr(I), 0);
    if J <= 0 then Break;
    K := FHGE.Ini_GetInt(sec, Key + '_ColumnAlign' + IntToStr(I), 0);
    if I >= Length(FColumns) then
      AddColumn(J, TAlignment(K))
    else begin
      FColumns[I - 1].Alignment := TAlignment(K);
      FColumns[I - 1].Width := J;
    end;
    Inc(I);
  until I > 100;
  FItemFont.FontName := FHGE.Ini_GetString(sec, Key + '_FontName', FItemFont.FontName);
  FItemFont.FontSize := FHGE.Ini_GetInt(sec, Key + '_FontSize', FItemFont.FontSize);
  FItemFont.NormalColor := FHGE.Ini_GetInt(sec, Key + '_NormalColor', FItemFont.NormalColor);
  FItemFont.SelectColor := FHGE.Ini_GetInt(sec, Key + '_SelectColor', FItemFont.SelectColor);
  FItemFont.SelectBackColor := FHGE.Ini_GetInt(sec, Key + '_SelectBackColor', FItemFont.SelectBackColor);
  FItemFont.HighlightColor := FHGE.Ini_GetInt(sec, Key + '_HighlightColor', FItemFont.HighlightColor);
  FItemFont.HighlightBackColor := FHGE.Ini_GetInt(sec, Key + '_HighlightBackColor', FItemFont.HighlightBackColor);
  FItemFont.DisableColor := FHGE.Ini_GetInt(sec, Key + '_DisableColor', FItemFont.DisableColor);
  FItemFont.DisableBackColor := FHGE.Ini_GetInt(sec, Key + '_DisableBackColor', FItemFont.DisableBackColor);
  FBoxTex := FHGE.Texture_Load(FHGE.Ini_GetString(sec, Key + '_BoxPic', ''));
  LoadPointFromIni(FHGE, BoxPos1, sec, Key + '_BoxP1');
  LoadPointFromIni(FHGE, BoxPos2, sec, Key + '_BoxP2');
  FShowCount := FHGE.Ini_GetInt(sec, Key + '_ShowCount', FShowCount);
  if FItemHeight > 0 then Height := (Height div FItemHeight) * FItemHeight;
  if FShowCount = 0 then ShowCount := Height div FItemHeight;
end;

function THGEListView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    SetDCapture(Self);
    Result := True;
  end;
end;

function THGEListView.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  I := -1;
  Result := inherited MouseMove(Shift, X, Y);
  if (not Result) then begin
    if MouseCaptureControl = Self then begin
      I := (Y - Top) div FItemHeight;
    end;
  end else I := (Y - Top) div FItemHeight;
  if (I < -1) or (I >= Height div FItemHeight) then
    I := -1
  else
    I := I + FTopIndex;
  if I <> FMouseItemIndex then begin
    FMouseItemIndex := I;
    if (I < 0) or (I >= ItemCount) then
      Hint := ''
    else
      Hint := pTHGEListViewItem(FItems[I]).sHint;
    NeedFlushHint := True;
  end;
end;

function THGEListView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if InRange(X, Y) then begin
      //if Assigned (FOnClickSound) then FOnClickSound(self, FClickSound);
      if Assigned(FOnChanging) then FOnChanging(Self);
      //计算选择的行
      I := (Y - Top) div FItemHeight;
      if (I < -1) or (I >= Height div FItemHeight) then
        I := -1
      else
        I := I + FTopIndex;
      FItemIndex := I;
      if (Button = mbLeft) and Assigned(FOnClick) then FOnClick(Self, X, Y);
    end;
    Result := True;
    Exit;
  end else begin
    ReleaseDCapture;
  end;
end;

function THGEListView.MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean;
begin
  Result := inherited MouseWheel(Shift, X, Y, Z);
  if not Result then Exit;
  if Z > 0 then TopIndex := FTopIndex - 1
  else if Z < 0 then TopIndex := FTopIndex + 1;
end;

procedure THGEListView.OnScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  I                         : Integer;
begin
  if ScrollPos <> FTopIndex then begin
    if FTopIndex > ScrollPos then begin //向上滚动，则要检查光标是否会出现在输入框下面
      FTopIndex := ScrollPos;
    end else begin
      //FTopIndex:=ScrollPos;
      I := Height div FItemHeight;      //一页最多显示的行数
      if FItems.Count <= I then
        FTopIndex := 0
      else if ScrollPos > FItems.Count - I then
        FTopIndex := FItems.Count - I
      else if ScrollPos < 0 then
        FTopIndex := 0
      else
        FTopIndex := ScrollPos;
      ScrollPos := FTopIndex;
    end;
  end;
end;

procedure THGEListView.ReDraw(Row, Col: Integer);
var
  Item                      : pTHGEListViewItem;
  Tex                       : ITexture;
begin
  if Height = 0 then Height := ItemHeight * ItemCount;
  FSpr := nil;
  Item := FItems[Row];
  if (CompareLStr(Item.data[Col], '<@PIC=', 6)) then begin //这是一个图片
    Tex := FHGE.Texture_Load(Copy(Item.data[Col], 7, Length(Item.data[Col]) - 7));
    if Tex = nil then
      Item.Image[Col] := nil
    else
      Item.Image[Col] := THGESprite.Create(Tex, 0, 0, Tex.GetWidth(True), Tex.GetHeight(True));
  end else begin                        //这是一个文字
    try
      FLabel.Font := Font;
      FLabel.AutoSize := True;
      //FLabel.Width:=FColumns[Col].Width;
      //FLabel.Height:=ItemHeight;
      FLabel.Transparent := True;
      //设置文字颜色
      //1111
      //FLabel.Font.Color := clWhite;

      FLabel.Alignment := FColumns[Col].Alignment;
      FLabel.Caption := Item.data[Col];
      //FLabel.ReDraw;       //1234
      Item.Image[Col] := FLabel.Spr;
    except
      on E: Exception do begin
        debugOutStr('THGEListView.ReDraw ' + E.Message);
      end;
    end;
  end;
end;

procedure Drawbar(FHGE: IHGE; X, Y, W, H: Single; Color: DWORD);
var
  FQuad                     : THGEQuad;
  II                        : Integer;
begin
  FQuad.Tex := nil;
  FQuad.Blend := BLEND_DEFAULT;
  FQuad.V[0].X := X;
  FQuad.V[0].Y := Y;
  FQuad.V[1].X := X + W;
  FQuad.V[1].Y := FQuad.V[0].Y;
  FQuad.V[2].X := FQuad.V[1].X;
  FQuad.V[2].Y := FQuad.V[1].Y + H;
  FQuad.V[3].X := FQuad.V[0].X;
  FQuad.V[3].Y := FQuad.V[2].Y;
  for II := 0 to 3 do begin
    FQuad.V[II].Col := Color;
    FQuad.V[II].Z := 0.5;
  end;
  FQuad.V[1].TX := 1;
  FQuad.V[2].TX := 1;
  FQuad.V[2].TY := 1;
  FQuad.V[3].TY := 1;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGEListView.DoRender;
var
  I, J, HH, XX, offset      : Integer;
  Item                      : pTHGEListViewItem;
  lx, ly, AX, AY            : Integer;
  Color                     : DWORD;
  W                         : Single;
  T                         : ITexture;
  Clipping                  : Boolean;
begin
  lx := SurfaceX(Left);
  ly := SurfaceY(Top);
  offset := 0;

  Clipping := (CParent <> nil) and (CParent is THGEWindow);
  if Clipping then begin
    FHGE.Gfx_SetClipping(CParent.SurfaceX(CParent.Left + CParent.ClipRect.Left), CParent.SurfaceY(CParent.Top + CParent.ClipRect.Top), CParent.ClipRect.Right, CParent.ClipRect.Bottom);
  end;

  if WLib <> nil then begin
    T := WLib.Images[FaceIndex];
    if T <> nil then begin
      offset := 3;
      g_GE.Canvas.Draw(lx - 2, ly - 2, T);
    end;
  end;

  //画边框
  if FBoxTex <> nil then begin
    RenderBox(FBoxTex, BoxPos1, BoxPos2, lx - BoxPos1.X, ly - BoxPos1.Y,
      Width + BoxPos1.X + FBoxTex.GetWidth(True) - BoxPos2.X,
      Height + BoxPos1.Y + FBoxTex.GetHeight(True) - BoxPos2.Y);
  end;

  HH := 0;
  if FSpr <> nil then
    FSpr.Render(lx, ly);

  for I := FTopIndex to FItems.Count - 1 do begin
    Item := FItems[I];
    XX := lx;
    //画背景
    if not Item.Enabled then
      Drawbar(FHGE, XX, ly + HH + 1, Width {-2} - offset, ItemHeight, FItemFont.DisableBackColor)
    else if I = FItemIndex then
      Drawbar(FHGE, XX, ly + HH + 1, Width {-2} - offset, ItemHeight, FItemFont.SelectBackColor)
    else if I = FMouseItemIndex then
      Drawbar(FHGE, XX, ly + HH + 1, Width {-2} - offset, ItemHeight, FItemFont.HighlightBackColor);

    for J := 0 to Length(FColumns) - 1 do begin
      if J >= Length(Item.Image) then Break;

      if Item.Image[J] <> nil then begin
        if I = FItemIndex then
          Color := FItemFont.SelectColor
        else if I = FMouseItemIndex then
          Color := FItemFont.HighlightColor
        else if not Item.Enabled then
          Color := FItemFont.DisableColor
        else Color := FItemFont.NormalColor;
        Item.Image[J].SetColor(Color);
        //计算坐标
        case FColumns[J].Alignment of
          taLeftJustify: begin
              W := 0;
            end;
          taRightJustify: begin
              W := FColumns[J].Width - Item.Image[J].GetWidth;
            end;
          taCenter: begin
              W := (FColumns[J].Width - Item.Image[J].GetWidth) / 2;
            end;
        end;
        AX := Round(XX + W + 2);
        AY := Round(ly + HH + (FItemHeight - Item.Image[J].GetHeight) / 2);
        //FHGE.Gfx_SetClipping(XX + 2, ly + HH, FColumns[J].Width, FItemHeight);
        Item.Image[J].Render(AX, AY);
        //FHGE.Gfx_SetClipping();
      end;
      Inc(XX, FColumns[J].Width);
    end;
    Inc(HH, FItemHeight);
    if HH >= Height then Break;
  end;

  if Clipping then begin
    FHGE.Gfx_SetClipping();
  end;
end;

procedure THGEListView.Exchange(Index1, Index2: Integer);
begin
  FItems.Exchange(Index1, Index2);
end;

procedure THGEListView.SetColumns(Index: Integer; const Value: PTLVColumn);
begin
  if (Index >= 0) and (Index < Length(FColumns)) then begin
    FColumns[Index] := Value^;
  end;
end;

procedure THGEListView.SetItem(Row, Col: Integer; const Value: string);
var
  Item                      : pTHGEListViewItem;
begin
  if (Row < 0) or (Row >= FItems.Count) or (Col < 0) then Exit;
  Item := FItems[Row];
  if (Col >= Length(Item.data)) then Exit;
  Item.data[Col] := Value;
  ReDraw(Row, Col);
end;

procedure THGEListView.SetItemChecked(Index: Integer; const Value: Boolean);
begin
  if (Index >= 0) and (Index < FItems.Count) then
    pTHGEListViewItem(FItems[Index]).Checked := Value;
end;

procedure THGEListView.SetItemData(Index: Integer; const Value: Pointer);
begin
  pTHGEListViewItem(FItems[Index]).PData := Value;
end;

procedure THGEListView.SetItemEnabled(Index: Integer; const Value: Boolean);
begin
  if (Index >= 0) and (Index < FItems.Count) then
    pTHGEListViewItem(FItems[Index]).Enabled := Value;
end;

procedure THGEListView.SetItemFont(const Value: TLVFont);
begin
  FItemFont := Value;
end;

procedure THGEListView.SetItemHeight(const Value: Integer);
begin
  FItemHeight := Value;
end;

procedure THGEListView.SetItemIndex(const Value: Integer);
var
  I                         : Integer;
begin
  if (Value < -1) or (Value >= FItems.Count) then Exit;
  FItemIndex := Value;
  //使当前行可见
  if Value >= 0 then begin
    I := Height div FItemHeight;
    if FItemIndex < FTopIndex then
      FTopIndex := FItemIndex;
    if FItemIndex >= I + FTopIndex then
      FTopIndex := FItemIndex - I + 1;
  end;
  if FScrollbar <> nil then FScrollbar.Position := FTopIndex;
end;

procedure THGEListView.SetMultiSelect(const Value: Boolean);
begin
  FMultiSelect := Value;
end;

procedure THGEListView.SetScrollbar(const Value: THGEScrollbar);
begin
  FScrollbar := Value;
  if FScrollbar = nil then Exit;
  FScrollbar.FPosition := 0;
  FScrollbar.MaxValue := FItems.Count;
  FScrollbar.OnScroll := OnScrollBarScroll;
end;

procedure THGEListView.SetShowCount(const Value: Integer);
begin
  FShowCount := Value;
  if FScrollbar <> nil then FScrollbar.MaxValue := MAX(0, FItems.Count - FShowCount);
end;

procedure THGEListView.SetTopIndex(const Value: Integer);
var
  I                         : Integer;
begin
  I := Height div FItemHeight;          //一页最多显示的行数
  if FItems.Count <= I then
    FTopIndex := 0
  else if Value > FItems.Count - I then
    FTopIndex := FItems.Count - I
  else if Value < 0 then
    FTopIndex := 0
  else
    FTopIndex := Value;
  if FScrollbar <> nil then FScrollbar.Position := FTopIndex;
end;

{
  boNumber:要排序的是否是数字类型
  boUp:是否按升序排列
  下面三个全局变量实际上只有这个MySort使用到，这个是MySort要求的，不能转换为局部变量
}
var
  ABoNumber                 : Boolean;
  ABoUp                     : Boolean;
  AByIndex                  : Integer;

procedure THGEListView.Sort(ByIndex: Integer; boNumber: Boolean = True; boUp: Boolean = True);

  function MySort(Item1, Item2: Pointer): Integer;
  var
    P1, P2                  : pTHGEListViewItem;
  begin
    P1 := pTHGEListViewItem(Item1);
    P2 := pTHGEListViewItem(Item2);
    if ABoNumber then begin
      if ABoUp then
        Result := Str_ToInt(P1^.data[AByIndex], 0) - Str_ToInt(P2^.data[AByIndex], 0)
      else
        Result := Str_ToInt(P2^.data[AByIndex], 0) - Str_ToInt(P1^.data[AByIndex], 0);
    end else begin
      if ABoUp then
        Result := CompareStr(P1^.data[AByIndex], P2^.data[AByIndex])
      else
        Result := CompareStr(P2^.data[AByIndex], P1^.data[AByIndex]);
    end;
  end;
begin
  if ByIndex >= Length(FColumns) then Exit;
  ABoNumber := boNumber;
  ABoUp := boUp;
  AByIndex := ByIndex;
  FItems.Sort(@MySort);
end;

{ THGEFlashPlayer }

procedure THGEFlashPlayer.Back;
begin
  if (m_pFlashPlayer <> nil) then
    m_pFlashPlayer.Back();
end;

constructor THGEFlashPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_pFlashPlayer := nil;
  FillChar(m_FlashQuad, sizeof(THGEQuad), 0);
  m_Quality := 2;
  FNeedUpdate := False;
  EnableFocus := True;
end;
{$IFDEF DARK}

procedure THGEFlashPlayer.Dark(boFlag: Boolean);
begin
  if boFlag then begin
    m_FlashQuad.V[0].Col := ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT);
    m_FlashQuad.V[1].Col := ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT);
    m_FlashQuad.V[2].Col := ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT);
    m_FlashQuad.V[3].Col := ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT);
  end else
    ExtractedAlpha;
end;
{$ENDIF}

destructor THGEFlashPlayer.Destroy;
begin
  if (m_pFlashPlayer <> nil) then
    m_pFlashPlayer.Free;
  m_pFlashPlayer := nil;
  m_FlashQuad.Tex := nil;
  inherited;
end;

procedure THGEFlashPlayer.DoRender;
var
  tempx1, tempy1, tempx2, tempy2: Single;
begin
  try
    if FNeedUpdate then LoadFlash;
    Update;
    if FHGE = nil then Exit;
    tempx1 := SurfaceX(Left);
    tempy1 := SurfaceY(Top);
    tempx2 := tempx1 + Width;
    tempy2 := tempy1 + Height;
    m_FlashQuad.V[0].X := tempx1;
    m_FlashQuad.V[0].Y := tempy1;
    m_FlashQuad.V[1].X := tempx2;
    m_FlashQuad.V[1].Y := tempy1;
    m_FlashQuad.V[2].X := tempx2;
    m_FlashQuad.V[2].Y := tempy2;
    m_FlashQuad.V[3].X := tempx1;
    m_FlashQuad.V[3].Y := tempy2;
    FHGE.Gfx_RenderQuad(m_FlashQuad);
  except

  end;
end;

procedure THGEFlashPlayer.ExtractedAlpha;
begin
  m_FlashQuad.V[0].Col := ARGB(FAlpha, FLight, FLight, FLight);
  m_FlashQuad.V[1].Col := ARGB(FAlpha, FLight, FLight, FLight);
  m_FlashQuad.V[2].Col := ARGB(FAlpha, FLight, FLight, FLight);
  m_FlashQuad.V[3].Col := ARGB(FAlpha, FLight, FLight, FLight);
end;

procedure THGEFlashPlayer.Forward;
begin
  if (m_pFlashPlayer <> nil) then
    m_pFlashPlayer.Forward();
end;

function THGEFlashPlayer.GetCurrentFrame: Integer;
begin
  Result := -1;
  if (m_pFlashPlayer <> nil) then
    Result := m_pFlashPlayer.GetCurrentFrame();
end;

class function THGEFlashPlayer.GetFlashVersion: Double;
begin
  Result := TFlashPlayer.GetFlashVersion();
end;

function THGEFlashPlayer.GetLoop: Boolean;
begin
  Result := False;
  if m_pFlashPlayer <> nil then
    m_pFlashPlayer.GetLoopPlay;
end;

function THGEFlashPlayer.GetPlaying: Boolean;
begin
  Result := False;
  if (m_pFlashPlayer <> nil) then
    Result := m_pFlashPlayer.IsPlaying();
end;

function THGEFlashPlayer.GetQuality: Byte;
begin
  Result := m_Quality;
end;

function THGEFlashPlayer.GetTotalFrames: Integer;
begin
  Result := -1;
  if (m_pFlashPlayer <> nil) then
    Result := m_pFlashPlayer.GetTotalFrames();
end;

function THGEFlashPlayer.GetTransparent: Boolean;
begin
  Result := False;
  if m_pFlashPlayer <> nil then
    Result := m_pFlashPlayer.Transparent;
end;

function THGEFlashPlayer.KeyDown(var Key: word; Shift: TShiftState): Boolean;
begin
  Result := False;
  if Self = FocusedControl then begin
    if m_pFlashPlayer <> nil then
      m_pFlashPlayer.KeyDown(Key, Shift);
    Result := True;
  end;
end;

function THGEFlashPlayer.KeyPress(var Key: Char): Boolean;
begin
  Result := False;
  if Self = FocusedControl then begin
    if m_pFlashPlayer <> nil then
      m_pFlashPlayer.KeyPress(Key);
    Result := True;
  end;
end;

function THGEFlashPlayer.KeyUp(var Key: word; Shift: TShiftState): Boolean;
begin
  Result := False;
  if Self = FocusedControl then begin
    if m_pFlashPlayer <> nil then
      m_pFlashPlayer.KeyUp(Key, Shift);
    Result := True;
  end;
end;

function THGEFlashPlayer.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    if (m_pFlashPlayer <> nil) then
      m_pFlashPlayer.MouseLButtonDown(X - Left, Y - Top);
  end;
end;

function THGEFlashPlayer.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result then begin
    if (m_pFlashPlayer <> nil) then
      m_pFlashPlayer.MouseMove(X - Left, Y - Top);
  end;
end;

function THGEFlashPlayer.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
  if Result then begin
    if (m_pFlashPlayer <> nil) then
      m_pFlashPlayer.MouseLButtonUp(X - Left, Y - Top);
    if Assigned(FOnClick) then FOnClick(Self, X, Y);
  end;
end;

procedure THGEFlashPlayer.Pause;
begin
  if (m_pFlashPlayer <> nil) then
    m_pFlashPlayer.Pause();
end;

procedure THGEFlashPlayer.Render;
begin
  inherited Render;
end;

procedure THGEFlashPlayer.Resume;
begin
  if (m_pFlashPlayer <> nil) then
    m_pFlashPlayer.Unpause();
end;

procedure THGEFlashPlayer.Rewind;
begin
  if (m_pFlashPlayer <> nil) then
    m_pFlashPlayer.Rewind();
end;

procedure THGEFlashPlayer.SetCurrentFrame(const Value: Integer);
begin
  if (m_pFlashPlayer <> nil) then
    m_pFlashPlayer.GotoFrame(Value);
end;

procedure THGEFlashPlayer.SetFileName(FileName: string);
begin
  FFileName := FileName;
  if FHGE = nil then Exit;
  FNeedUpdate := True;
end;

function THGEFlashPlayer.InitFlashPlayer: Boolean;
var
  hTexture                  : ITexture;
  d                         : THGESprite;
begin
  Result := False;
  if FHGE = nil then Exit;
  // 释放数据
  m_FlashQuad.Tex := nil;
  FillChar(m_FlashQuad, sizeof(THGEQuad), 0);
  // 创建纹理
  hTexture := FHGE.Texture_Create(Width, Height);
  if (hTexture = nil) then begin
    Result := False;
    FHGE.System_Log('THGEFlashPlayer.InitFlashPlayer error:' + Name);
    Exit;
  end;
  // 获取FLASH纹理的QUAD结构
  d := THGESprite.Create(hTexture, 0, 0, Width, Height);
  m_FlashQuad := d.Quad;
  d.Free;
  ExtractedAlpha;
  // 创建FLASH播放器
  FreeAndNil(m_pFlashPlayer);
  if (m_pFlashPlayer = nil) then begin
    m_pFlashPlayer := TFlashPlayer.Create;
    if (m_pFlashPlayer = nil) then begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function THGEFlashPlayer.LoadFromStream(Src: TStream): Boolean;
begin
  Result := False;
  if not InitFlashPlayer then Exit;

  m_pFlashPlayer.LoadFromStream(Src, Width, Height, 0);
  m_pFlashPlayer.SetQuality(QUALITY_HIGH);
  m_pFlashPlayer.GotoFrame(0);
  Result := True;
end;

function THGEFlashPlayer.LoadFlash: Boolean;
var
  sAppPath                  : array[0..MAX_PATH - 1] of Char;
  I, II                     : Integer;
  Stream                    : TMemoryStream;
begin
  FNeedUpdate := False;
  Result := False;
  if not InitFlashPlayer then Exit;
  Stream := FHGE.Flash_Load(FFileName, @I);
  if Stream <> nil then begin           //从流中装载
    try
      LoadFromStream(Stream);
      Result := True;
    finally
      Stream.Free;
    end;
    Exit;
  end;
  //从磁盘或Web装载
  FillChar(sAppPath, sizeof(sAppPath), 0);
  if ((Length(FFileName) >= 3) and (FFileName[2] = ':')) or ((Length(FFileName) >= 5) and (FFileName[5] = ':')) then
    Move(FFileName[1], sAppPath[0], Length(FFileName))
  else begin
    I := 0;
    II := GetModuleFileName(GetModuleHandle(nil), sAppPath, sizeof(sAppPath));
    for I := II - 1 downto 1 do begin
      if (sAppPath[I] = '\') then Break;
      sAppPath[I] := #0;
    end;
    Move(FFileName[1], sAppPath[I + 1], Length(FFileName));
  end;

  if not CompareLStr(sAppPath, 'http://', 7) and not FileExists(sAppPath) then Exit;

  if m_pFlashPlayer.StartAnimation(sAppPath, Width, Height, 0) then begin
    m_pFlashPlayer.SetQuality(QUALITY_HIGH);
    m_pFlashPlayer.GotoFrame(0);
    Result := True;
  end;
end;

procedure THGEFlashPlayer.LoadFromIni(sec, Key: string);
begin
  inherited LoadFromIni(sec, Key);
  FileName := FHGE.Ini_GetString(sec, Key + '_URL', '');
end;

procedure THGEFlashPlayer.SetLight(Value: Byte);
begin
  inherited Light := Value;
  ExtractedAlpha;
end;

procedure THGEFlashPlayer.SetLoop(const Value: Boolean);
begin
  if (m_pFlashPlayer <> nil) then
    m_pFlashPlayer.SetLoopPlay(Value);
end;

procedure THGEFlashPlayer.SetPlaying(const Value: Boolean);
begin
  if m_pFlashPlayer = nil then Exit;
  if Value then begin
    FNeedUpdate := True;
  end else begin
    FreeAndNil(m_pFlashPlayer);
  end;
end;

procedure THGEFlashPlayer.SetQuality(const Value: Byte);
begin
  m_Quality := Value;
  if (m_pFlashPlayer <> nil) then begin
    if (Value = 0) then m_pFlashPlayer.SetQuality(QUALITY_LOW)
    else if (Value = 1) then m_pFlashPlayer.SetQuality(QUALITY_MEDIUM)
    else m_pFlashPlayer.SetQuality(QUALITY_HIGH);
  end;
end;

procedure THGEFlashPlayer.SetTransparent(const Value: Boolean);
begin
  if m_pFlashPlayer <> nil then
    m_pFlashPlayer.Transparent := Value;
end;

procedure THGEFlashPlayer.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  if not FVisible then Playing := False;
end;

function THGEFlashPlayer.Update: Boolean;

  function Update32: Boolean;
  var
    tex_w                   : Integer;
    nWidth, nHeight         : Integer;
    dwFlashs                : PADWORD;
    pixels                  : PADWORD;
    Y                       : Integer;
  begin
    Result := False;
    if FHGE = nil then Exit;
    if (m_pFlashPlayer <> nil) then begin
      m_pFlashPlayer.Update();
      if (m_pFlashPlayer.Render()) then begin
        if m_FlashQuad.Tex <> nil then
          tex_w := m_FlashQuad.Tex.GetWidth
        else
          tex_w := 0;

        nWidth := m_pFlashPlayer.GetWidth();
        nHeight := m_pFlashPlayer.GetHeight();

        dwFlashs := PADWORD(m_pFlashPlayer.GetFlashFrameBuffer());
        pixels := PADWORD(FHGE.Texture_Lock(m_FlashQuad.Tex, False));
        Y := 0;
        while Y < nHeight do begin
          CopyMemory(@pixels^[Y * tex_w], @dwFlashs^[Y * nWidth], sizeof(DWORD) * nWidth);
          Inc(Y);
        end;
        FHGE.Texture_Unlock(m_FlashQuad.Tex);
        Result := True;
      end;
    end;
  end;
var
  tex_w, tex_h              : Integer;
  target_pixels             : PLongWord;
  target_bak                : PLongWord;
  Y                         : Integer;
  X                         : Integer;
  dm                        : DWORD;
  pdm                       : PDWORD;
  transColor                : DWORD;
begin
  Result := False;
  if SCREENBPP = 32 then begin
    Result := Update32;
    Exit;
  end;
  if FHGE = nil then Exit;
  if (m_pFlashPlayer <> nil) then begin
    m_pFlashPlayer.Update();
    if (m_pFlashPlayer.Render()) then begin
      if m_FlashQuad.Tex <> nil then begin
        tex_w := m_FlashQuad.Tex.GetWidth;
        pdm := PDWORD(m_pFlashPlayer.GetFlashFrameBuffer());
        if pdm <> nil then transColor := pdm^ else transColor := 0;
        target_pixels := FHGE.Texture_Lock(m_FlashQuad.Tex, False);
        tex_w := FHGE.Texture_GetWidth(m_FlashQuad.Tex);
        tex_h := FHGE.Texture_GetHeight(m_FlashQuad.Tex);
        for Y := 0 to tex_h - 1 do begin
          for X := 0 to tex_w - 1 do begin
            target_bak := target_pixels;
            dm := pdm^;
            Inc(pdm, 1);
            Inc(target_bak, Y * tex_w + X);
            if (dm = transColor) then
              target_bak^ := 0
            else
              target_bak^ := dm or $FF000000
          end;
        end;
        FHGE.Texture_Unlock(m_FlashQuad.Tex);
      end;
      Result := True;
    end;
  end;
end;
{ THGEStaticText }

constructor THGEStaticText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNeedUpdate := True;
  FFont := nil;
  Font.OnChange := FontChanged;
end;

destructor THGEStaticText.Destroy;
begin
  if FFont <> nil then FFont.Free;
  inherited;
end;

procedure THGEStaticText.DoRender;
var
  lx, ly                    : Integer;
begin
  if FNeedUpdate then Update;

  lx := SurfaceX(Left);
  ly := SurfaceY(Top);
  FHGE.Gfx_SetClipping(lx, ly, Width, Height);
  FFont.Print(lx, ly, FCaption);
  FHGE.Gfx_SetClipping(0, 0, 0, 0);
end;

procedure THGEStaticText.FontChanged(Sender: TObject);
begin
  FNeedUpdate := True;
  if FFont = nil then FFont := TSysFont.Create;
  FFont.CreateFont(Font.Name, Font.Size, Font.Style);
  FFont.Red := GetR(Font.Color);
  FFont.Green := GetG(Font.Color);
  FFont.Blue := GetB(Font.Color);
  FFont.Alpha := FAlpha;
end;

procedure THGEStaticText.SetCaption(Value: string);
begin
  FCaption := Value;
  FNeedUpdate := True;
end;

procedure THGEStaticText.Update;
begin
  FNeedUpdate := False;
  if AutoSize then begin
    Width := FFont.TextWidth(FCaption);
    Height := FFont.TextHeight(FCaption);
  end;
end;

{ THGEWebBrowser }

constructor THGEWebBrowser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  boNeedUpdate := False;
  WebBrowser := nil;
  Bmp := TBitmap.Create;
  Bmp.Width := Width;
  Bmp.Height := Height;
  FRenderFrames := 0;
  FSpr := nil;
  FTexture := nil;
end;

destructor THGEWebBrowser.Destroy;
begin
  if Assigned(WebBrowser) then WebBrowser.Free;
  Bmp.Free;
  inherited;
end;

procedure THGEWebBrowser.DoRender;
begin
  Update;
  inherited DoRender;
end;

function THGEWebBrowser.GetTransparent: Boolean;
begin
  Result := Bmp.Transparent;
end;

function THGEWebBrowser.GetTransparentColor: TColor;
begin
  Result := Bmp.TransparentColor;
end;

procedure THGEWebBrowser.LoadFromIni(sec, Key: string);
var
  s                         : string;
begin
  inherited LoadFromIni(sec, Key);
  s := FHGE.Ini_GetString(sec, Key + '_URL', '');
  if s <> '' then url := s;
  Bmp.Transparent := FHGE.Ini_GetInt(sec, Key + '_Transparent', Integer(Bmp.Transparent)) = 1;
  Bmp.TransparentColor := FHGE.Ini_GetInt(sec, Key + '_TransparentColor', Bmp.TransparentColor);
  Alpha := FHGE.Ini_GetInt(sec, Key + '_Alpha', FAlpha);
end;

function THGEWebBrowser.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    if WebBrowser <> nil then begin
      if Button = mbLeft then
        WebBrowser.MouseLButtonDown(X - Left, Y - Top);
      SetDCapture(Self);
    end else Result := False;
  end;
end;

function THGEWebBrowser.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result then begin
    if WebBrowser <> nil then begin
      if WebBrowser.GetElementAtPos(X, Y) <> nil then
        SetCursor(crHandPoint)
      else
        SetCursor(crDefault);
      WebBrowser.MouseMove(X - Left, Y - Top);
    end else Result := False;
  end;
end;

function THGEWebBrowser.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
  if Result then begin
    if WebBrowser <> nil then begin
      if Button = mbLeft then
        WebBrowser.MouseLButtonUp(X - Left, Y - Top);
    end else Result := False;
  end;
end;

function THGEWebBrowser.MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean;
begin
  Result := inherited MouseWheel(Shift, X, Y, Z);
end;

procedure THGEWebBrowser.Resize;
begin
  inherited Resize;
  if WebBrowser <> nil then
    WebBrowser.Init(Handle, Width, Height);
  Bmp.Width := Width;
  Bmp.Height := Height;
  Bmp.Transparent := False;
  boNeedUpdate := True;
end;

procedure THGEWebBrowser.SetTransparent(const Value: Boolean);
begin
  Bmp.Transparent := Value;
end;

procedure THGEWebBrowser.SetTransparentCOlor(const Value: TColor);
begin
  Bmp.TransparentColor := Value;
end;

procedure THGEWebBrowser.SetURL(const Value: string);
begin
  FURL := Value;
  if WebBrowser <> nil then begin
    WebBrowser.url := Value;
  end;
  boNeedUpdate := True;
end;

function THGEWebBrowser.Update: Boolean;
begin
  if WebBrowser = nil then begin
    WebBrowser := TCWebBrowser.Create;
    WebBrowser.Init(FHGE.System_GetState(HGE_HWND), Width, Height);
    WebBrowser.url := FURL;
    Bmp.Width := Width;
    Bmp.Height := Height;
  end;
  if boNeedUpdate or (FRenderFrames = 0) then begin
    WebBrowser.Render();
    Bitblt(Bmp.Canvas.Handle, 0, 0, Width - 2, Height - 2, WebBrowser.Handle, 0, 0, SrcCopy);
    FTexture := BmpToTexture(Bmp, nil, 0, Bmp.Transparent);
    if FTexture <> nil then
      FSpr := THGESprite.Create(FTexture, 2, 2, FTexture.GetWidth(True), FTexture.GetHeight(True))
    else
      FSpr := nil;
    if (FSpr <> nil) and ((FAlpha < 255) or (FLight < 255)) then
      FSpr.SetColor(ARGB(FAlpha, FLight, FLight, FLight));

  end;
  Inc(FRenderFrames);
  if FRenderFrames > 5 then FRenderFrames := 0;

  boNeedUpdate := False;
  Result := True;
end;

function GetScreenBPP: Integer;
var
  DC                        : HDC;
  DevMode                   : TDevMode;
begin
  if EnumDisplaySettings(nil, 0, DevMode) then begin
    DC := GetDC(0);
    Result := GetDeviceCaps(DC, BITSPIXEL);
    if Result = 32 then
      aTrans := 'Transparent';
  end;
end;

{ THGEDropdownList }

procedure THGEDropdownList.AddItem(s: string);
begin
  FDropList.AddItem(['', s]);
end;

procedure THGEDropdownList.AddItem(s: string; data: Pointer);
begin
  if data = nil then
    FDropList.AddItem(['', s])
  else
    FDropList.AddItem(['', s], True, False, '', data);
end;

procedure THGEDropdownList.AddItem(s: string; data: Pointer; Hint: string);
begin
  if data = nil then
    FDropList.AddItem(['', s])
  else
    FDropList.AddItem(['', s], True, False, Hint, data);
end;

procedure THGEDropdownList.Clear;
begin
  FDropList.Clear;
end;

constructor THGEDropdownList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDropList := THGEListView.Create(nil);
  FLabel := THGELabel.Create(nil);
  FLabel.ParentWindow := g_GE.HGE.System_GetState(HGE.HGE_HWND);
  FLabel.FrameBrushColor := $00406F77;

  FButton := THGEButton.Create(nil);
  FDropList.AddColumn(3, taLeftJustify);
  FDropList.AddColumn(Width - 3, taLeftJustify);
  FDropList.Visible := False;
  FLabel.FCaption := '';
  //FLabel.Transparent := True;

  FLabel.Transparent := False;
  FLabel.Color := clBlack;
  FLabel.BorderWidth := 1;

  FButton.OnClick := OnButtonClick;
  FDropList.OnClick := OnDropListClick;
  FDropList.OnChanging := OnDropListChanging;

  FFocused := False;
  FButton.boAutoChecInRange := False;
end;

procedure THGEDropdownList.DelItem(Index: Integer);
begin
  FDropList.DelItem(Index);
end;

destructor THGEDropdownList.Destroy;
begin
  FDropList.Free;
  FLabel.Free;
  FButton.Free;
  inherited;
end;

function THGEDropdownList.KeyDown(var Key: word; Shift: TShiftState): Boolean;
begin
  Result := False;
end;

function THGEDropdownList.KeyUp(var Key: word; Shift: TShiftState): Boolean;
begin
  Result := False;
end;

procedure THGEDropdownList.LoadFromIni(sec, Key: string);
begin
  inherited LoadFromIni(sec, Key);
  //按钮的设置
  FButton.LoadFromIni(sec, Key + 'Button');
  FLabel.LoadFromIni(sec, Key + 'Label');
  FDropList.LoadFromIni(sec, Key + 'List');
  Resize;
end;

function THGEDropdownList.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if FDropList.Visible then begin
    Result := FDropList.MouseDown(Button, Shift, X + SurfaceX(Left) - Left, Y + SurfaceY(Top) - Top);
    if Result then begin
      Focused := True;
      Exit;
    end;
  end;
  Result := FButton.MouseDown(Button, Shift, X + SurfaceX(Left) - Left, Y + SurfaceY(Top) - Top);
  Focused := Result;
  if Assigned(FOnClick) then FOnClick(Self, X, Y);
end;

function THGEDropdownList.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if FDropList.Visible then begin
    Result := FDropList.MouseMove(Shift, X + SurfaceX(Left) - Left, Y + SurfaceY(Top) - Top);
    if Result then begin
      Exit;
    end;
  end;
  Result := FButton.MouseMove(Shift, X + SurfaceX(Left) - Left, Y + SurfaceY(Top) - Top);
end;

function THGEDropdownList.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if FDropList.Visible then begin
    Result := FDropList.MouseUp(Button, Shift, X + SurfaceX(Left) - Left, Y + SurfaceY(Top) - Top);
    if Result then begin
      Focused := False;
      Exit;
    end;
  end;
  Result := FButton.MouseUp(Button, Shift, X + SurfaceX(Left) - Left, Y + SurfaceY(Top) - Top);
  Focused := not Result;
end;

function THGEDropdownList.MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean;
begin
  Result := False;
  if not FDropList.Visible then Exit;
  Result := FDropList.MouseWheel(Shift, X + SurfaceX(Left) - Left, Y + SurfaceY(Top) - Top, Z);
end;

procedure THGEDropdownList.OnButtonClick(Sender: TObject; X, Y: Integer);
begin
  FDropList.Visible := not FDropList.Visible;
  if FDropList.Visible then begin
    //如果能显示在下面，则显示在按钮的下面
    if FDropList.Height + SurfaceY(Top) + Height > SCREENHEIGHT then begin
      FDropList.Top := SurfaceY(Top) - FDropList.Height;
    end else begin
      FDropList.Top := SurfaceY(Top) + Height;
    end;
  end;
end;

procedure THGEDropdownList.OnDropListChanging(Sender: TObject);
begin
  if (FDropList.ItemIndex >= 0) and (FDropList.ItemIndex < FDropList.ItemCount) then begin
    if FDropList.ItemEnabled[FDropList.ItemIndex] then begin
      if Assigned(FOnChanging) then FOnChanging(Self);
    end;
  end;
end;

procedure THGEDropdownList.OnDropListClick(Sender: TObject; X, Y: Integer);
begin
  if (FDropList.ItemIndex >= 0) and (FDropList.ItemIndex < FDropList.ItemCount) then begin
    if FDropList.ItemEnabled[FDropList.ItemIndex] then begin
      if FItemIndex <> FDropList.ItemIndex then begin
        FLabel.Caption := FDropList.Items[FDropList.ItemIndex, 1];
        FDropList.Visible := False;
        FItemIndex := FDropList.ItemIndex;
        if Assigned(FOnChanged) then FOnChanged(Self);
      end else begin
        FDropList.Visible := False;
        if Assigned(FOnChanging) then
          Enabled := True;
      end;
    end;
  end;
end;

procedure THGEDropdownList.DoRender;
var
  FQuad                     : THGEQuad;
  II                        : Integer;
  X, Y                      : Integer;
  Clipping                  : Boolean;
begin
  X := SurfaceX(Left);
  Y := SurfaceY(Top);

  FButton.Left := X;
  FButton.Top := Y;

  FLabel.Left := X {+ 2};
  FLabel.Top := Y + 2;

  Clipping := (CParent <> nil) and (CParent is THGEWindow);
  if Clipping then begin
    FHGE.Gfx_SetClipping(CParent.SurfaceX(CParent.Left + CParent.ClipRect.Left), CParent.SurfaceY(CParent.Top + CParent.ClipRect.Top), CParent.ClipRect.Right, CParent.ClipRect.Bottom);
  end;

  FButton.Render;
  FLabel.Render;

  if FDropList.FVisible then begin
    if FDropList.BoxTex = nil then begin
      FDropList.Left := X;
      FDropList.Top := Y + Height + 2;

      FQuad.Tex := nil;
      FQuad.Blend := BLEND_DEFAULT;
      FQuad.V[0].X := FDropList.Left - 1;
      FQuad.V[0].Y := FDropList.Top;
      FQuad.V[1].X := FDropList.Left + FDropList.Width + 1;
      FQuad.V[1].Y := FQuad.V[0].Y;
      FQuad.V[2].X := FQuad.V[1].X;
      FQuad.V[2].Y := FQuad.V[1].Y + FDropList.Height + 2;
      FQuad.V[3].X := FQuad.V[0].X;
      FQuad.V[3].Y := FQuad.V[2].Y;
      for II := 0 to 3 do begin
        FQuad.V[II].Col := ARGB($EF, $FF, $FF, $FF);
        FQuad.V[II].Z := 0.5;
      end;
      FQuad.V[1].TX := 1;
      FQuad.V[2].TX := 1;
      FQuad.V[2].TY := 1;
      FQuad.V[3].TY := 1;
      FHGE.Gfx_RenderQuad(FQuad);
    end else begin
      FDropList.Left := X + FDropList.BoxPos1.X;
      FDropList.Top := Y + Height + FDropList.BoxPos1.Y;
    end;
    FDropList.Render;
  end;
  if Clipping then begin
    FHGE.Gfx_SetClipping();
  end;
end;

function THGEDropdownList.GetItem(Index: Integer): string;
begin
  if (Index < 0) or (Index >= FDropList.ItemCount) then
    Result := ''
  else
    Result := FDropList.Items[Index, 1];
end;

function THGEDropdownList.GetObject(Index: Integer): Pointer;
begin
  if (Index < 0) or (Index >= FDropList.ItemCount) then
    Result := nil
  else
    Result := FDropList.ItemData[Index];
end;

function THGEDropdownList.GetItemEnabled(Index: Integer): Boolean;
begin
  Result := FDropList.ItemEnabled[Index];
end;

function THGEDropdownList.Indexof(s: string): Integer;
var
  I                         : Integer;
begin
  Result := -1;
  for I := 0 to FDropList.ItemCount - 1 do begin
    if CompareStr(s, FDropList.Items[I, 1]) = 0 then begin
      Result := I;
      Break;
    end;
  end;
end;

procedure THGEDropdownList.Resize;
var
  Column                    : PTLVColumn;
  X, Y                      : Integer;
begin
  X := 0;
  Y := 0;
  FButton.Left := X;
  FButton.Top := Y;
  FButton.Width := Width;
  FButton.Height := Height;

  FLabel.Left := X {+ 2};
  FLabel.Top := Y + 2;
  FLabel.Width := Width {- 4};
  FLabel.Height := Height {- 4};
  FLabel.FAutoSize := False;
  FDropList.Left := X;
  FDropList.Top := Y + Height;
  FDropList.Width := Width;
  FDropList.Height := FDropList.ItemCount * FDropList.FItemHeight;

  Column := FDropList.Columns[1];
  if Column <> nil then begin
    Column.Width := Width - 3;
  end;
  inherited Resize;
  FDropList.TopIndex := 0;
end;

procedure THGEDropdownList.SetFocused(const Value: Boolean);
begin
  if FFocused = Value then Exit;
  FFocused := Value;
  if not FFocused and FDropList.Visible then
    FDropList.Visible := False;
end;

procedure THGEDropdownList.SetItem(Index: Integer; const Value: string);
begin
  if (Index < 0) or (Index > FDropList.ItemCount) then Exit;
  FDropList.Items[Index, 1] := Value;
end;

procedure THGEDropdownList.SetItemEnabled(Index: Integer; const Value: Boolean);
begin
  FDropList.ItemEnabled[Index] := Value;
end;

procedure THGEDropdownList.SetItemIndex(const Value: Integer);
begin
  if (Value >= 0) and (Value < FDropList.ItemCount) then begin
    FItemIndex := Value;
    FLabel.Caption := FDropList.Items[FItemIndex, 1];
    FDropList.ItemIndex := Value;
  end else begin
    FItemIndex := -1;
    FLabel.Caption := '';
    FDropList.ItemIndex := -1;
  end;
end;

{ THGEDropdowPictureList }

constructor THGEDropdowPictureList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItemCount := 1;
  FItemIndex := 0;
  FState := 0;
  FMouseInIndex := -1;
end;

destructor THGEDropdowPictureList.Destroy;
begin
  SetLength(FButtonSprs, 0);
  inherited;
end;

procedure THGEDropdowPictureList.DoRender;
var
  lx, ly, I                 : Integer;
  ASpr                      : IHGESprite;
begin
  lx := SurfaceX(Left);
  ly := SurfaceY(Top);
  FSpr := FButtonSprs[FItemIndex].Spr[FState];
  if FSpr <> nil then
    FSpr.Render(lx, ly);
  if FDropDown then begin               //显示下拉按钮列表
    if ly + Height + FItemCount * Height > SCREENHEIGHT then
      ly := ly - FItemCount * Height;
    for I := 0 to FItemCount - 1 do begin
      if (I = FItemIndex) then
        ASpr := FButtonSprs[I].Spr[2]
      else if not FButtonSprs[I].Enabled then
        ASpr := FButtonSprs[I].Spr[3]
      else if (FButtonSprs[I].Downed) then
        ASpr := FButtonSprs[I].Spr[2]
      else if I = FMouseInIndex then
        ASpr := FButtonSprs[I].Spr[1]
      else
        ASpr := FButtonSprs[I].Spr[0];
      if ASpr <> nil then begin
        if (ModalDWindow <> nil) and not IsChild(ModalDWindow) then
          ASpr.SetColor(ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT))
        else
          ASpr.SetColor(ARGB(FAlpha, FLight, FLight, FLight));
        ASpr.Render(lx, ly);
      end;
      Inc(ly, Height);
    end;
  end;
end;

function THGEDropdowPictureList.GetItemEnabled(Index: Integer): Boolean;
begin
  if (FItemIndex < 0) or (FItemIndex >= Length(FButtonSprs)) then Result := False
  else Result := FButtonSprs[Index].Enabled;
end;

procedure THGEDropdowPictureList.LoadFromIni(sec, Key: string);
begin
  FItemCount := FHGE.Ini_GetInt(sec, Key + '_Count', 1);
  inherited LoadFromIni(sec, Key);
end;

function THGEDropdowPictureList.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    if (MouseCaptureControl = nil) then begin
      FState := 2;
      FMouseInIndex := -1;
      SetDCapture(Self);
    end;
  end else if FDropDown then begin
    FState := 0;
    for I := 0 to FItemCount - 1 do
      FButtonSprs[I].Downed := False;
    if FMouseInIndex <> -1 then begin
      FButtonSprs[FMouseInIndex].Downed := True;
      Result := True;
    end;
  end;
  Focused := Result;
end;

function THGEDropdowPictureList.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  lx, ly, I                 : Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result then begin
    FMouseInIndex := -1;
    if FState = 0 then FState := 1;
    Exit;
  end else if FDropDown then begin
    lx := SurfaceX(Left);
    ly := SurfaceY(Top);
    if ly + Height + FItemCount * Height > SCREENHEIGHT then
      ly := ly - FItemCount * Height;
    X := SurfaceX(X);
    Y := SurfaceY(Y);
    if (X >= lx) and (X <= lx + Width) and (Y >= ly) and (Y <= ly + Height * FItemCount) then
      for I := 0 to FItemCount - 1 do begin
        if (Y <= ly + Height) then begin
          FMouseInIndex := I;
          Result := True;
          if MouseInControl <> Self then begin
            MouseInControl := Self;
            FIsMouseIn := True;
          end;
          Break;
        end;
        Inc(ly, Height);
      end;
  end;
  FState := 0;
end;

function THGEDropdowPictureList.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  I                         : Integer;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
  if Result then begin
    FState := 1;
    FMouseInIndex := -1;
    FDropDown := not FDropDown;
  end else if FDropDown then begin
    FState := 0;
    for I := 0 to FItemCount - 1 do
      FButtonSprs[I].Downed := False;
    if (FMouseInIndex <> -1) then begin
      if FButtonSprs[FMouseInIndex].Enabled then begin
        FItemIndex := FMouseInIndex;
        FDropDown := False;
        if Assigned(FOnChanged) then FOnChanged(Self);
        FMouseInIndex := -1;
      end;
    end;
    Result := True;
    Focused := False;
  end;
end;

procedure THGEDropdowPictureList.SetFocused(const Value: Boolean);
begin
  if FFocused = Value then Exit;
  FFocused := Value;
  if not FFocused then
    FDropDown := False;
end;

procedure THGEDropdowPictureList.SetItemEnabled(Index: Integer; const Value: Boolean);
begin
  if (FItemIndex < 0) or (FItemIndex >= Length(FButtonSprs)) then Exit;
  FButtonSprs[Index].Enabled := Value;
end;

procedure THGEDropdowPictureList.SetItemIndex(const Value: Integer);
begin
  if (FItemIndex < 0) or (FItemIndex >= Length(FButtonSprs)) then Exit;
  FItemIndex := Value;
  FState := 0;
  FSpr := FButtonSprs[FItemIndex].Spr[FState];
end;

procedure THGEDropdowPictureList.SetTexture(const Tex: ITexture);
var
  I, J                      : Integer;
begin
  FSpr := nil;
  if Tex = nil then Exit;
  FTexture := Tex;
  Width := Round(Tex.GetWidth(True) / FItemCount);
  Height := Round(Tex.GetHeight(True) / 4);
  SetLength(FButtonSprs, FItemCount);
  for I := 0 to FItemCount - 1 do begin
    FButtonSprs[I].Enabled := True;
    FButtonSprs[I].Downed := False;
    for J := 0 to 3 do
      FButtonSprs[I].Spr[J] := THGESprite.Create(FTexture, I * Width, J * Height, Width, Height);
  end;
  FSpr := FButtonSprs[FItemIndex].Spr[FState];
  if FSpr = nil then Exit;
{$IFDEF DARK}
  if (ModalDWindow <> nil) and not IsChild(ModalDWindow) then
    Dark(True);
{$ENDIF}
end;

{ TWebListener }

constructor TWebListener.Create(pWeb: THGEWebBrowser2);
begin
  FWebBrowser := pWeb;
  Assert(FWebBrowser <> nil);
end;

destructor TWebListener.Destroy;
begin
  FWebBrowser := nil;
  inherited;
end;

procedure TWebListener.onBeginLoading(const url: PAnsiChar; const urllen: Integer; const frameName: PWideChar; const frameNamelen: Integer; statusCode: Integer; const mimeType: PWideChar);
begin
  if Assigned(FWebBrowser.FonBeginLoading) then
    FWebBrowser.FonBeginLoading(FWebBrowser, url, frameName, statusCode, mimeType);
end;

procedure TWebListener.onBeginNavigation(const url: PAnsiChar; const urllen: Integer; const frameName: PWideChar; const frameNamelen: Integer);
begin
  if Assigned(FWebBrowser.FonBeginNavigation) then
    FWebBrowser.FonBeginNavigation(FWebBrowser, url, frameName);
end;

procedure TWebListener.onCallback(const Name: PAnsiChar; const namelen: Integer; const Args: TJSValueList);
begin
  if Assigned(FWebBrowser.FonCallback) then
    FWebBrowser.FonCallback(FWebBrowser, Name, Args);
end;
var
  SystemCursorHandle        : array[-22..0] of HCURSOR;

procedure TWebListener.onChangeCursor(const cursor: PLongWord);
begin
  if (cursor <> nil) then begin
    if Assigned(FWebBrowser.FonChangeCursor) then
      FWebBrowser.FonChangeCursor(FWebBrowser, cursor^)
    else begin
      if cursor^ = SystemCursorHandle[crDefault] then FWebBrowser.cursor := crArrow
      else if cursor^ = SystemCursorHandle[crNone] then FWebBrowser.cursor := crNone
      else if cursor^ = SystemCursorHandle[crArrow] then FWebBrowser.cursor := crArrow
      else if cursor^ = SystemCursorHandle[crCross] then FWebBrowser.cursor := crCross
      else if cursor^ = SystemCursorHandle[crIBeam] then FWebBrowser.cursor := crIBeam
      else if cursor^ = SystemCursorHandle[crSize] then FWebBrowser.cursor := crSize
      else if cursor^ = SystemCursorHandle[crSizeNESW] then FWebBrowser.cursor := crSizeNESW
      else if cursor^ = SystemCursorHandle[crSizeNS] then FWebBrowser.cursor := crSizeNS
      else if cursor^ = SystemCursorHandle[crSizeNWSE] then FWebBrowser.cursor := crSizeNWSE
      else if cursor^ = SystemCursorHandle[crSizeWE] then FWebBrowser.cursor := crSizeWE
      else if cursor^ = SystemCursorHandle[crUpArrow] then FWebBrowser.cursor := crUpArrow
      else if cursor^ = SystemCursorHandle[crHourGlass] then FWebBrowser.cursor := crHourGlass
      else if cursor^ = SystemCursorHandle[crDrag] then FWebBrowser.cursor := crDrag
      else if cursor^ = SystemCursorHandle[crNoDrop] then FWebBrowser.cursor := crNoDrop
      else if cursor^ = SystemCursorHandle[crHSplit] then FWebBrowser.cursor := crHSplit
      else if cursor^ = SystemCursorHandle[crVSplit] then FWebBrowser.cursor := crVSplit
      else if cursor^ = SystemCursorHandle[crMultiDrag] then FWebBrowser.cursor := crMultiDrag
      else if cursor^ = SystemCursorHandle[crSQLWait] then FWebBrowser.cursor := crSQLWait
      else if cursor^ = SystemCursorHandle[crNo] then FWebBrowser.cursor := crNo
      else if cursor^ = SystemCursorHandle[crAppStart] then FWebBrowser.cursor := crAppStart
      else if cursor^ = SystemCursorHandle[crHelp] then FWebBrowser.cursor := crHelp
      else if cursor^ = SystemCursorHandle[crHandPoint] then FWebBrowser.cursor := crHandPoint
      else if cursor^ = SystemCursorHandle[crSizeAll] then FWebBrowser.cursor := crSizeAll
      else FWebBrowser.cursor := crArrow;

      {case cursor^ of
        65553:FWebBrowser.Cursor:=crArrow;
        65555:FWebBrowser.Cursor:=crIBeam;
        65557:FWebBrowser.Cursor:=crHourGlass;
        65567:FWebBrowser.Cursor:=crSizeWE;
        65581:FWebBrowser.Cursor:=crHandPoint; //32649
        else if cursor^<>0 then FWebBrowser.Cursor:=crArrow;
      end;}
    end;
  end;
end;

procedure TWebListener.onChangeKeyboardFocus(isFocused: Boolean);
begin
  if Assigned(FWebBrowser.FonChangeKeyboardFocus) then
    FWebBrowser.FonChangeKeyboardFocus(FWebBrowser, isFocused);
end;

procedure TWebListener.onChangeTargetURL(const url: PAnsiChar; const urllen: Integer);
begin
  if Assigned(FWebBrowser.FonChangeTargetURL) then
    FWebBrowser.FonChangeTargetURL(FWebBrowser, url);
end;

procedure TWebListener.onChangeTooltip(const tooltip: PWideChar; const tooltiplen: Integer);
begin
  if Assigned(FWebBrowser.FonChangeTooltip) then
    FWebBrowser.FonChangeTooltip(FWebBrowser, tooltip);
end;

procedure TWebListener.onFinishLoading;
begin
  if Assigned(FWebBrowser.FonFinishLoading) then
    FWebBrowser.FonFinishLoading(FWebBrowser);
end;

procedure TWebListener.onReceiveTitle(const title: PWideChar; const titlelen: Integer; const frameName: PWideChar; const frameNamelen: Integer);
begin
  if Assigned(FWebBrowser.FonReceiveTitle) then
    FWebBrowser.FonReceiveTitle(FWebBrowser, title, frameName);
end;

function TWebListener.onNavigationAction(const url: PWideChar; const urllen: Integer; const frameName: PWideChar;
  const frameNamelen: Integer; const otype: TWebNavigationType; const default_policy: TWebNavigationPolicy;
  const is_redirect: Boolean): TWebNavigationPolicy;
begin
  if Assigned(FWebBrowser.FonNavigationAction) then begin
    Result := FWebBrowser.FonNavigationAction(FWebBrowser, url, frameName, otype, default_policy, is_redirect);
  end else
    Result := default_policy;
end;

function TWebListener.onRunBeforeUnloadConfirm(const sframeName: PWideChar; const frameNamelen: Integer;
  const smessage: PWideChar; const smessagelen: Integer): Boolean;
begin
  if Assigned(FWebBrowser.FonRunBeforeUnloadConfirm) then begin
    Result := FWebBrowser.FonRunBeforeUnloadConfirm(FWebBrowser, sframeName, smessage);
  end else
    Result := False;
end;

procedure TWebListener.onRunJavaScriptAlert(const sframeName: PWideChar; const frameNamelen: Integer; const smessage: PWideChar;
  const smessagelen: Integer);
begin
  if Assigned(FWebBrowser.FonRunJavaScriptAlert) then
    FWebBrowser.FonRunJavaScriptAlert(FWebBrowser, sframeName, smessage);
end;

function TWebListener.onRunJavaScriptConfirm(const sframeName: PWideChar; const frameNamelen: Integer; const smessage: PWideChar;
  const smessagelen: Integer): Boolean;
begin
  if Assigned(FWebBrowser.FonRunJavaScriptConfirm) then begin
    Result := FWebBrowser.FonRunJavaScriptConfirm(FWebBrowser, sframeName, smessage);
  end else
    Result := False;
end;

function TWebListener.onRunJavaScriptPrompt(const sframeName: PWideChar; const frameNamelen: Integer; const smessage: PWideChar;
  const smessagelen: Integer; const default_value: PWideChar; const default_valuelen: Integer; const oResult: PWideChar;
  const len: PInteger): Boolean;
var
  sd                        : WideString;
  nlen                      : Integer;
begin
  Result := False;
  if Assigned(FWebBrowser.FonRunJavaScriptPrompt) then begin
    Result := FWebBrowser.FonRunJavaScriptPrompt(FWebBrowser, sframeName, smessage, default_value, sd);
    if Result then begin
      len^ := Length(sd);
      if len^ > 255 then len^ := 255;
      Move(sd[1], oResult^, Length(string(sd)));
    end else begin
      oResult[0] := #0;
      len^ := 0;
    end;
  end else begin
    oResult[0] := #0;
    len^ := 0;
  end;
end;

procedure TWebListener.onCreateWebView(const sOpenUrl: PChar; const nOpenUrllen: Integer; const creatorurl: PChar;
  const creator_urllen: Integer; gesture: Boolean);
begin
  if Assigned(FWebBrowser.FonCreateWebView) then
    FWebBrowser.FonCreateWebView(FWebBrowser, sOpenUrl, creatorurl, gesture)
  else
    ShellExecute(g_GE.HGE.System_GetState(HGE_HWND), nil, sOpenUrl, nil, nil, SW_SHOWMAXIMIZED);
end;

{ THGEWebBrowser2 }

constructor THGEWebBrowser2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInitiated := False;
  FWebBrowser := nil;
  FWebListener := nil;
  FillChar(WebQuad, sizeof(THGEQuad), 0);
  WebQuad.Tex := nil;
  FSpr := nil;
  FTexture := nil;
  FonBeginNavigation := nil;
  FonBeginLoading := nil;
  FonFinishLoading := nil;
  FonCallback := nil;
  FonReceiveTitle := nil;
  FonChangeTooltip := nil;
  FonChangeCursor := nil;
  FonChangeKeyboardFocus := nil;
  FonChangeTargetURL := nil;
  FCanInput := True;
  FEnableFocus := True;
  FWcharOrChar.boIs := False;
  FOpenURL := False;
  FTransparent := False;
  FenableAsyncRendering := True;
  FmaxAsyncRenderPerSec := 90;
  WebQuad.Blend := BLEND_DEFAULT;
end;

destructor THGEWebBrowser2.Destroy;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.Destroy;
  if Assigned(FWebListener) then
    FWebListener.Free;

  FWebBrowser := nil;
  FWebListener := nil;
  WebQuad.Tex := nil;
  FSpr := nil;
  FTexture := nil;
  inherited;
end;

procedure THGEWebBrowser2.Loaded();
var
  webCore                   : TWebCore;
begin
  inherited Loaded;
  FWebBrowser := nil;
  FWebListener := nil;
  webCore := WebCoreCreate();
  FWebBrowser := webCore.CreateWebView(Width, Height, False, FenableAsyncRendering, FmaxAsyncRenderPerSec);
  if FWebBrowser <> nil then begin
    FWebListener := TWebListener.Create(Self);
    FWebBrowser.SetListener(FWebListener);
    if InitTexture() then begin
      FInitiated := True;
      if (FURL <> '') then begin
        FOpenURL := True;
        if Visible then begin
          FWebBrowser.LoadURL(PChar(FURL), PWideChar(FframeName), PChar(Fusername), PChar(Fpassword), False);
          FWebBrowser.Focus;
          FOpenURL := False;
        end;
      end;
    end;
  end;
end;

function THGEWebBrowser2.InitTexture: Boolean;
var
  hTexture                  : ITexture;
  d                         : THGESprite;
begin
  Result := False;
  if FHGE = nil then Exit;
  // 释放数据
  WebQuad.Tex := nil;
  FillChar(WebQuad, sizeof(THGEQuad), 0);
  // 创建纹理
  hTexture := FHGE.Texture_Create(Width, Height, D3DFMT_X8R8G8B8);
  if (hTexture = nil) then begin
    Result := False;
    FHGE.System_Log('THGEWebBrowser2.InitTexture error ' + Name);
    Exit;
  end;
  // 获取Web纹理的QUAD结构
  d := THGESprite.Create(hTexture, 0, 0, Width, Height);
  WebQuad := d.Quad;
  d.Free;
  ExtractedAlpha;
  WebQuad.Blend := BLEND_DEFAULT;
  Result := True;
end;
{$IFDEF DARK}

procedure THGEWebBrowser2.Dark(boFlag: Boolean);
begin
  if boFlag then begin
    WebQuad.V[0].Col := ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT);
    WebQuad.V[1].Col := ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT);
    WebQuad.V[2].Col := ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT);
    WebQuad.V[3].Col := ARGB(FAlpha, DARKLIGHT, DARKLIGHT, DARKLIGHT);
  end else
    ExtractedAlpha;
end;
{$ENDIF}

procedure THGEWebBrowser2.ExtractedAlpha;
begin
  WebQuad.V[0].Col := ARGB(FAlpha, FLight, FLight, FLight);
  WebQuad.V[1].Col := ARGB(FAlpha, FLight, FLight, FLight);
  WebQuad.V[2].Col := ARGB(FAlpha, FLight, FLight, FLight);
  WebQuad.V[3].Col := ARGB(FAlpha, FLight, FLight, FLight);
end;

function THGEWebBrowser2.Update: Boolean;
var
  Rect                      : TD3DLockedRect;
  PRec                      : PRect;
  Flags                     : Integer;
begin
  if FWebBrowser = nil then Exit;

  if FWebBrowser.IsDirty() and (WebQuad.Tex <> nil) then begin
    PRec := nil;
    Flags := 0;
    try
      if (Failed(WebQuad.Tex.Handle.LockRect(0, Rect, PRec, Flags))) then
        FHGE.System_Log('Can''t THGEWebBrowser2.Update texture')
      else begin
        FWebBrowser.Render(PByte(Rect.pBits), Rect.Pitch, 4, 0);
      end;
    finally
      WebQuad.Tex.Handle.UnlockRect(0);
    end;
  end;
  Result := True;
end;

procedure THGEWebBrowser2.DoRender;
var
  tempx1, tempy1, tempx2, tempy2: Single;
begin
  inherited DoRender;
  if FWebBrowser <> nil then begin
    WebCoreCreate().Update();
    Update;
    try
      if FHGE = nil then Exit;
      tempx1 := SurfaceX(Left);
      tempy1 := SurfaceY(Top);
      tempx2 := tempx1 + Width;
      tempy2 := tempy1 + Height;
      WebQuad.V[0].X := tempx1;
      WebQuad.V[0].Y := tempy1;
      WebQuad.V[1].X := tempx2;
      WebQuad.V[1].Y := tempy1;
      WebQuad.V[2].X := tempx2;
      WebQuad.V[2].Y := tempy2;
      WebQuad.V[3].X := tempx1;
      WebQuad.V[3].Y := tempy2;
      FHGE.Gfx_RenderQuad(WebQuad);
    except
    end;
  end;
end;

procedure THGEWebBrowser2.SetLight(Value: Byte);
begin
  inherited Light := Value;
  ExtractedAlpha;
end;

procedure THGEWebBrowser2.Copy;
begin
  if FWebBrowser <> nil then
    FWebBrowser.Copy();
end;

procedure THGEWebBrowser2.DeselectAll;
begin
  if FWebBrowser <> nil then
    FWebBrowser.DeselectAll();
end;

procedure THGEWebBrowser2.Cut;
begin
  if FWebBrowser <> nil then
    FWebBrowser.Cut();
end;

procedure THGEWebBrowser2.ExecuteJavascript(javascript: PAnsiChar; frameName: PWideChar);
begin
  if FWebBrowser <> nil then
    FWebBrowser.ExecuteJavascript(javascript, frameName);
end;

procedure THGEWebBrowser2.Focus;
begin
  if FWebBrowser <> nil then
    FWebBrowser.Focus();
end;

procedure THGEWebBrowser2.GetContentAsText(Result: PWideChar; maxChars: Integer);
begin
  if FWebBrowser <> nil then
    FWebBrowser.GetContentAsText(Result, maxChars);
end;

procedure THGEWebBrowser2.GoToHistoryOffset(offset: Integer);
begin
  if FWebBrowser <> nil then
    FWebBrowser.GoToHistoryOffset(offset);
end;

procedure THGEWebBrowser2.Unfocus;
begin
  if FWebBrowser <> nil then
    FWebBrowser.Unfocus();
end;

procedure THGEWebBrowser2.Refresh;
begin
  if FWebBrowser <> nil then
    FWebBrowser.Refresh();
end;

procedure THGEWebBrowser2.ResetZoom;
begin
  if FWebBrowser <> nil then
    FWebBrowser.ResetZoom();
end;

procedure THGEWebBrowser2.SetProperty(Name: PAnsiChar; var Value: Boolean);
begin
  if FWebBrowser <> nil then
    FWebBrowser.SetProperty(Name, Value);
end;

procedure THGEWebBrowser2.SetProperty(Name, Value: PAnsiChar);
begin
  if FWebBrowser <> nil then
    FWebBrowser.SetProperty(Name, Value);
end;

procedure THGEWebBrowser2.SetProperty(Name: PAnsiChar; var Value: Integer);
begin
  if FWebBrowser <> nil then
    FWebBrowser.SetProperty(Name, Value);
end;

procedure THGEWebBrowser2.SetProperty(Name: PAnsiChar; var Value: Double);
begin
  if FWebBrowser <> nil then
    FWebBrowser.SetProperty(Name, Value);
end;

procedure THGEWebBrowser2.LoadFile(sfile: PAnsiChar; frameName: PWideChar);
begin
  if FWebBrowser <> nil then
    FWebBrowser.LoadFile(sfile, frameName);
end;

procedure THGEWebBrowser2.ZoomIn;
begin
  if FWebBrowser <> nil then
    FWebBrowser.ZoomIn();
end;

procedure THGEWebBrowser2.ZoomOut;
begin
  if FWebBrowser <> nil then
    FWebBrowser.ZoomOut();
end;

procedure THGEWebBrowser2.Paste;
begin
  if FWebBrowser <> nil then
    FWebBrowser.Paste();
end;

procedure THGEWebBrowser2.SelectAll;
begin
  if FWebBrowser <> nil then
    FWebBrowser.SelectAll();
end;

procedure THGEWebBrowser2.SetCallback(Name: PAnsiChar);
begin
  if FWebBrowser <> nil then
    FWebBrowser.SetCallback(Name);
end;

procedure THGEWebBrowser2.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  if FTransparent then WebQuad.Blend := BLEND_ALPHAADD
  else WebQuad.Blend := BLEND_DEFAULT;
  if FWebBrowser <> nil then
    FWebBrowser.SetTransparent(FTransparent);
end;

procedure THGEWebBrowser2.LoadHTML(html: PAnsiChar; frameName: PWideChar);
begin
  if FWebBrowser <> nil then begin
    FWebBrowser.LoadHTML(html, frameName);
    Transparent := FTransparent;
  end;
end;

procedure THGEWebBrowser2.DoChangeURL(Value: string; Reload: Boolean);
begin
  FURL := Value;
  FOpenURL := True;
  if (FWebBrowser <> nil) then begin
    if Visible then begin
      FWebBrowser.LoadURL(PChar(FURL), PWideChar(FframeName), PChar(Fusername), PChar(Fpassword), Reload);
      FWebBrowser.Focus;
      FOpenURL := False;
    end;
  end;
end;

procedure THGEWebBrowser2.SetURL(const Value: string);
begin
  DoChangeURL(Value, False);
end;

procedure THGEWebBrowser2.SetReloadURL(const Value: string);
begin
  DoChangeURL(Value, True);
end;

procedure THGEWebBrowser2.SetVisible(const Value: Boolean);
begin
  if (FVisible <> Value) and (FWebBrowser <> nil) then begin
    if Value then begin
      if FOpenURL then begin
        FWebBrowser.LoadURL(PChar(FURL), PWideChar(FframeName), PChar(Fusername), PChar(Fpassword), False);
        FOpenURL := False;
      end;
      FWebBrowser.Focus;
    end else begin
      FWebBrowser.Unfocus;
    end;
  end;
  inherited Visible := Value;
end;

procedure THGEWebBrowser2.Resize;
begin
  inherited Resize;
  if FWebBrowser <> nil then
    FWebBrowser.Resize(Width, Height);
  InitTexture();
  if FTransparent then WebQuad.Blend := BLEND_ALPHAADD
  else WebQuad.Blend := BLEND_DEFAULT;
end;

procedure THGEWebBrowser2.LoadFromIni(sec, Key: string);
var
  s                         : string;
begin
  inherited LoadFromIni(sec, Key);
  s := FHGE.Ini_GetString(sec, Key + '_URL', '');
  if s <> '' then url := s;
  Transparent := FHGE.Ini_GetInt(sec, Key + '_Transparent', Integer(Transparent)) = 1;
  Alpha := FHGE.Ini_GetInt(sec, Key + '_Alpha', FAlpha);
  Resize;
end;

function IsMsgKey(Msg: UINT): Boolean;
begin
  Result := (Msg = WM_KEYDOWN) or
    (Msg = WM_KEYUP) or
    (Msg = WM_SYSKEYDOWN) or
    (Msg = WM_SYSKEYUP) or
    (Msg = WM_CHAR) or
    (Msg = WM_SYSCHAR);
end;

{ TWcharOrChar }

function TWcharOrChar.GetPWChar: PWideChar;

begin
  MultiByteToWideChar(GetACP, 0, @c[False], 2, @Buffer[0], 1);
  Buffer[1] := #0;
  Result := @Buffer[0];
end;

procedure THGEWebBrowser2.WindowMsgProce(Window: HWnd; Msg: UINT; wParam: wParam; lParam: lParam);
var
  ww                        : WideChar;
  w2                        : TWcharOrChar;
begin
  inherited WindowMsgProce(Window, Msg, wParam, lParam);
  if (FWebBrowser <> nil) and IsMsgKey(Msg) then begin
    if Msg = WM_CHAR then begin
      if ord(wParam) <= 127 then begin
        FWebBrowser.InjectKeyboardEvent(Window, Msg, wParam, lParam);
        FWcharOrChar.boIs := False;
      end else begin
        FWcharOrChar.c[FWcharOrChar.boIs] := Char(wParam);
        FWcharOrChar.boIs := not FWcharOrChar.boIs;
        if not FWcharOrChar.boIs then
          FWebBrowser.InjectTextEvent(pwidestring(FWcharOrChar.GetPWChar));
      end;
    end else
      FWebBrowser.InjectKeyboardEvent(Window, Msg, wParam, lParam);
  end;
end;

function THGEWebBrowser2.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    if FWebBrowser <> nil then begin
      if Button = mbLeft then begin
        FWebBrowser.InjectMouseDown(mbLeft);
      end;
      SetDCapture(Self);
    end else Result := False;
  end;
end;

function THGEWebBrowser2.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result then begin
    if FWebBrowser <> nil then begin
      FWebBrowser.InjectMouseMove(X - Left, Y - Top);
    end else Result := False;
  end;
end;

function THGEWebBrowser2.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
  if Result then begin
    if FWebBrowser <> nil then begin
      if Button = mbLeft then
        FWebBrowser.InjectMouseUp(mbLeft);
    end else Result := False;
  end;
end;

function THGEWebBrowser2.MouseWheel(Shift: TShiftState; X, Y, Z: Integer): Boolean;
begin
  Result := inherited MouseWheel(Shift, X, Y, Z);
  if Result then begin
    if FWebBrowser <> nil then begin
      FWebBrowser.InjectMouseWheel(Z);
    end else Result := False;
  end;
end;

{ THGELSAnimPlayer }

constructor THGELSAnimPlayer.Create(AOwner: TComponent);
begin
  inherited;
  FLSAnimPlayer := TLSAnimPlayer.Create(Self);
  FBindex := -1;
  FLSAnimPlayer.Alpha := Alpha;
  FLSAnimPlayer.Light := Light;
end;

destructor THGELSAnimPlayer.Destroy;
begin
  FLSAnimPlayer.Free;
  inherited;
end;

procedure THGELSAnimPlayer.DoRender;
begin
  inherited;
  FLSAnimPlayer.DoMove;
  FLSAnimPlayer.DoDraw
end;

function THGELSAnimPlayer.GetFileName: string;
begin
  FLSAnimPlayer.FileName;
end;

function THGELSAnimPlayer.GetLoadHit(): Boolean;
begin
  Result := FLSAnimPlayer.GetLoadHit();
end;

procedure THGELSAnimPlayer.LoadFromIni(sec, Key: string);
begin
  inherited;
  FileName := FHGE.Ini_GetString(sec, Key + '_URL', '');
end;

function THGELSAnimPlayer.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
  if Result then
    if Assigned(FOnClick) then FOnClick(Self, X, Y);
end;

procedure THGELSAnimPlayer.Pause;
begin
  FLSAnimPlayer.Pause;
end;

procedure THGELSAnimPlayer.Play(Bindex: Integer);
begin
  FLSAnimPlayer.Play(Bindex);
  FBindex := Bindex;
end;

procedure THGELSAnimPlayer.SetFileName(const Value: string);
begin
  FLSAnimPlayer.FileName := Value;
end;

procedure THGELSAnimPlayer.SetLight(Value: Byte);
begin
  inherited Light := Value;
  FLSAnimPlayer.Light := Light;
end;

procedure THGELSAnimPlayer.SetAlpha(Value: Byte);
begin
  inherited Alpha := Value;
  FLSAnimPlayer.Alpha := Alpha;
end;

procedure THGELSAnimPlayer.SetVisible(const Value: Boolean);
begin
  inherited Visible := Value;
  if Visible then Play(FBindex)
  else Pause();
end;

procedure Register;
begin
  RegisterComponents('HGE', [THGEWinManager, THGEControl, THGELabel, THGEStaticText, THGEButton, THGECheckBox,
    THGEEdit, THGEMemo, THGEListBox, THGEDropdownList, THGEDropdowPictureList, THGERadioButton, THGECombBox,
      THGEScrollbar, THGEGrid, THGEMenu, THGEWindow, THGERichEdit, THGEListView, THGEAnimPlayer, THGEFlashPlayer, THGEWebBrowser,
      THGEWebBrowser2, THGELSAnimPlayer]);
end;

procedure LoadSystemCursorHandle;
begin
  FillChar(SystemCursorHandle, sizeof(SystemCursorHandle), 0);
  SystemCursorHandle[0] := LoadCursor(0, idc_Arrow);
  SystemCursorHandle[-1] := LoadCursor(0, idc_Arrow);
  SystemCursorHandle[-2] := LoadCursor(0, idc_Arrow);
  SystemCursorHandle[-3] := LoadCursor(0, IDC_CROSS);
  SystemCursorHandle[-4] := LoadCursor(0, IDC_IBEAM);
  SystemCursorHandle[-5] := LoadCursor(0, IDC_SIZE);
  SystemCursorHandle[-6] := LoadCursor(0, IDC_SIZENESW);
  SystemCursorHandle[-7] := LoadCursor(0, IDC_SIZENS);
  SystemCursorHandle[-8] := LoadCursor(0, IDC_SIZENWSE);
  SystemCursorHandle[-9] := LoadCursor(0, IDC_SIZEWE);
  SystemCursorHandle[-10] := LoadCursor(0, IDC_UPARROW);
  SystemCursorHandle[-11] := LoadCursor(0, IDC_WAIT);
  SystemCursorHandle[-12] := LoadCursor(0, IDC_UPARROW);
  SystemCursorHandle[-13] := LoadCursor(0, IDC_NO);
  SystemCursorHandle[-14] := LoadCursor(0, idc_Arrow);
  SystemCursorHandle[-15] := LoadCursor(0, idc_Arrow);
  SystemCursorHandle[-16] := LoadCursor(0, idc_Arrow);
  SystemCursorHandle[-17] := LoadCursor(0, IDC_WAIT);
  SystemCursorHandle[-18] := LoadCursor(0, IDC_NO);
  SystemCursorHandle[-19] := LoadCursor(0, IDC_APPSTARTING);
  SystemCursorHandle[-20] := LoadCursor(0, IDC_HELP);
  SystemCursorHandle[-21] := LoadCursor(0, IDC_HAND);
  SystemCursorHandle[-22] := LoadCursor(0, IDC_SIZE);

end;

initialization
  g_WinHGE := HGECreate(HGE_VERSION);
  g_TopRenderList := TList.Create;
  LoadSystemCursorHandle;

finalization
  g_TopRenderList.Free;
  //g_WinHGE := nil;

end.

