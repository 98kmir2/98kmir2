unit HGE;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** Delphi conversion by Erik van Bilsen
*)

interface

{.$DEFINE DX8}
{.$DEFINE HGE_DX9}
{.$RANGECHECKS OFF}

{$WARNINGS OFF}
{$HINTS OFF}

uses
  Classes, Windows, {$IFDEF DX8}DirectXGraphics{$ELSE}Direct3D9{$ENDIF}, Bass, OpenJpeg, Graphics,
{$IFDEF DX8}D3DX81mo, {$ELSE}D3DX9, {$ENDIF}
  Forms;

(****************************************************************************
 * HGE.h
 ****************************************************************************)

const
  HGE_VERSION       = $160;
  IRad              = 1 / 360;
  TwoPI             = 2 * 3.14159265358;
  ID_SYSMENU_DEFRATE = 40001;

  SCREENWIDTH       : Integer = 800;
  SCREENHEIGHT      : Integer = 600;
  g_Windowed        : Boolean = False;

var
  g_boVertexCanLock : Boolean = False;
  //g_boD3DCanDraw    : Boolean = False;
  g_ClientWidth     : Integer = 800; //= SCREENWIDTH;
  g_ClientHeight    : Integer = 600; // = SCREENHEIGHT;

type
{$IFDEF DX8}
  TD3DCaps = TD3DCaps8;
  IDirect3DTexture = IDirect3DTexture8;
  IDirect3D = IDirect3D8;
  IDirect3DDevice = IDirect3DDevice8;
  IDirect3DVertexBuffer = IDirect3DVertexBuffer8;
  IDirect3DIndexBuffer = IDirect3DIndexBuffer8;
  IDirect3DSurface = IDirect3DSurface8;
  TD3DAdapterIdentifier = TD3DAdapterIdentifier8;
  TD3DViewport = TD3DViewport8;
  IDirect3DBaseTexture = IDirect3DBaseTexture8;
{$ELSE}
  TD3DCaps = TD3DCaps9;
  IDirect3DTexture = IDirect3DTexture9;
  IDirect3D = IDirect3D9;
  IDirect3DDevice = IDirect3DDevice9;
  IDirect3DVertexBuffer = IDirect3DVertexBuffer9;
  IDirect3DIndexBuffer = IDirect3DIndexBuffer9;
  IDirect3DSurface = IDirect3DSurface9;
  TD3DAdapterIdentifier = TD3DAdapterIdentifier9;
  TD3DViewport = TD3DViewport9;
  IDirect3DBaseTexture = IDirect3DBaseTexture9;
{$ENDIF}

  ITexture = interface
    ['{9D5C8783-956C-42E1-9307-CAD03DEC1E7A}']
    function GetPixel(X, Y: Integer): LongInt;
    procedure SetPixel(X, Y: Integer; Value: LongInt);
    function GetHandle: IDirect3DTexture;
    function GetName: string;
    procedure SetName(Value: string);
    function GetPatternWidth: Integer;
    procedure SetPatternWidth(Value: Integer);
    function GetPatternHeight: Integer;
    procedure SetPatternHeight(Value: Integer);
    function GetPatternCount: Integer;
    function GetTagID: Integer;
    procedure SetTagID(Value: Integer);
{$IFDEF DYNTEX}
    function GetIsDynTex: Boolean;
{$ENDIF}
    procedure SetHandle(const Value: IDirect3DTexture);
    function GetWidth(const Original: Boolean = False): Integer;
    function GetHeight(const Original: Boolean = False): Integer;
    function Lock(const ReadOnly: Boolean = True; const Left: Integer = 0;
      const Top: Integer = 0; const Width: Integer = 0;
      const Height: Integer = 0): PLongword; overload;
    function Lock(out Rect: TD3DLockedRect; const ReadOnly: Boolean = True; const Left: Integer = 0;
      const Top: Integer = 0; const Width: Integer = 0;
      const Height: Integer = 0): PLongword; overload;
    procedure Unlock;
    property Name: string read GetName write SetName;
    property PatternWidth: Integer read GetPatternWidth write SetPatternWidth;
    property PatternHeight: Integer read GetPatternHeight write SetPatternHeight;
    property Width: Integer read GetPatternWidth write SetPatternWidth;
    property Height: Integer read GetPatternHeight write SetPatternHeight;
    property PatternCount: Integer read GetPatternCount;
    property Handle: IDirect3DTexture read GetHandle write SetHandle;
    property TagID: Integer read GetTagID write SetTagID;
{$IFDEF DYNTEX}
    property IsDynTex: Boolean read GetIsDynTex;
{$ENDIF}
    property Pixels[X, Y: Integer]: LongInt read GetPixel write SetPixel;
  end;

type
  IChannel = interface
    ['{32549D16-44B1-4912-A7FE-025BCFFFB950}']
    function GetHandle: HChannel;

    procedure SetPanning(const Pan: Integer);
    procedure SetVolume(const Volume: Integer);
    procedure SetPitch(const Pitch: Single);
    procedure Pause;
    procedure Resume;
    procedure Stop;
    function IsPlaying: Boolean;
    function IsSliding: Boolean;
    function GetLength: Single;
    function GetPos: Single;
    procedure SetPos(const Seconds: Single);
    procedure SlideTo(const Time: Single; const Volume: Integer;
      const Pan: Integer = -101; const Pitch: Single = -1);

    property Handle: HChannel read GetHandle;
  end;

type
  IEffect = interface
    ['{526AD139-7C58-4692-AF7E-84206531CEC2}']
    function GetHandle: HSample;

    function Play: IChannel;
    function PlayEx(const Volume: Integer = 100; const Pan: Integer = 0;
      const Pitch: Single = 1.0; const Loop: Boolean = False): IChannel;

    property Handle: HSample read GetHandle;
  end;

type
  IMusic = interface
    ['{15A0ADA4-DF3D-4821-B06E-5F72208709EA}']
    function GetHandle: HMusic;

    function Play(const Loop: Boolean; const Volume: Integer = 100;
      const Order: Integer = -1; const Row: Integer = -1): IChannel;
    function GetAmplification: Integer;
    function GetLength: Integer;
    procedure SetPos(const Order, Row: Integer);
    function GetPos(out Order, Row: Integer): Boolean;
    procedure SetInstrVolume(const Instr, Volume: Integer);
    function GetInstrVolume(const Instr: Integer): Integer;
    procedure SetChannelVolume(const Channel, Volume: Integer);
    function GetChannelVolume(const Channel: Integer): Integer;

    property Handle: HMusic read GetHandle;
  end;

type
  ITarget = interface
    ['{16FB54D6-6682-4496-82F0-4B4617FDF2D0}']
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetTex: ITexture;
    function GetTexture: ITexture;

    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property Tex: ITexture read GetTex;
  end;

type
  IStream = interface
    ['{589A2704-27A7-4E18-B0EA-8F00E1E3A349}']
    function GetHandle: HStream;

    function Play(const Loop: Boolean; const Volume: Integer = 100): IChannel;

    property Handle: HStream read GetHandle;
  end;

type
  IResource = interface
    ['{BAA2A47B-87B1-4D26-A8EF-AE49E3B2BC6F}']
    function GetHandle: Pointer;
    function GetSize: Longword;

    property Handle: Pointer read GetHandle;
    property Size: Longword read GetSize;
  end;

  (*
  ** Common math constants
  *)
const
  M_PI              = 3.14159265358979323846;
  M_PI_2            = 1.57079632679489661923;
  M_PI_4            = 0.785398163397448309616;
  M_1_PI            = 0.318309886183790671538;
  M_2_PI            = 0.636619772367581343076;

  (*
  ** Hardware color macros
  *)
function ARGB(const A, R, G, B: Byte): Longword;
inline;
function GetA(const Color: Longword): Byte;
inline;
function GetR(const Color: Longword): Byte;
inline;
function GetG(const Color: Longword): Byte;
inline;
function GetB(const Color: Longword): Byte;
inline;
function SetA(const Color: Longword; const A: Byte): Longword;
inline;
function SetR(const Color: Longword; const A: Byte): Longword;
inline;
function SetG(const Color: Longword; const A: Byte): Longword;
inline;
function SetB(const Color: Longword; const A: Byte): Longword;
inline;

(*
** HGE Blending constants
*)
const
  BLEND_COLORADD    = 1;
  BLEND_COLORMUL    = 0;
  BLEND_ALPHABLEND  = 2;
  BLEND_ALPHAADD    = 0;
  BLEND_ZWRITE      = 4;
  BLEND_NOZWRITE    = 0;

  BLEND_DEFAULT     = BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE;
  BLEND_DEFAULT_Z   = BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_ZWRITE;

  Blend_Add         = 100;
  Blend_SrcAlpha    = 101;
  Blend_SrcAlphaAdd = 102;
  Blend_SrcColor    = 103;
  BLEND_SrcColorAdd = 104;
  Blend_Invert      = 105;
  Blend_SrcBright   = 106;
  Blend_Multiply    = 107;
  Blend_InvMultiply = 108;
  Blend_MultiplyAlpha = 109;
  Blend_InvMultiplyAlpha = 110;
  Blend_DestBright  = 111;
  Blend_InvSrcBright = 112;
  Blend_InvDestBright = 113;
  Blend_Bright      = 114;
  Blend_BrightAdd   = 115;
  Blend_GrayScale   = 116;
  Blend_Light       = 117;
  Blend_LightAdd    = 118;
  Blend_Add2X       = 119;
  Blend_OneColor    = 120;
  Blend_XOR         = 121;
  Blend_Anti        = 122;

  {*
  ** HGE System state constants
  *}
type
  THGEBoolState = (
    HGE_WINDOWED = 12, // bool    run in window?    (default: false)
    HGE_ZBUFFER = 13, // bool    use z-buffer?    (default: false)
    HGE_TEXTUREFILTER = 28, // bool    texture filtering?  (default: true)

    HGE_USESOUND = 18, // bool    use BASS for sound?  (default: true)

    HGE_DONTSUSPEND = 24, // bool    focus lost:suspend?  (default: false)
    HGE_HIDEMOUSE = 25, // bool    hide system cursor?  (default: true)
    HGE_SHOWSPLASH = 27, // bool		 hide system cursor?	(default: true)
    HGE_ACTIVE = 29,
    HGE_NOBORDER = 30, //是否有边框
    HGEBOOLSTATE_FORCE_DWORD = $7FFFFFFF
    );

type
  THGEFuncState = (
    HGE_FRAMEFUNC = 1, // bool*()  frame function    (default: NULL) (you MUST set this)
    HGE_RENDERFUNC = 2, // bool*()  render function    (default: NULL)
    HGE_FOCUSLOSTFUNC = 3, // bool*()  focus lost function  (default: NULL)
    HGE_FOCUSGAINFUNC = 4, // bool*()  focus gain function  (default: NULL)
    HGE_GFXRESTOREFUNC = 5, // bool*()	 exit function		(default: NULL)
    HGE_EXITFUNC = 6, // bool*()  exit function    (default: NULL)
    HGE_RESIZE = 7,
    HGE_IMGCACHEFUNC = 8,
    HGE_MOUNTEVENT = 9,
    HGEFUNCSTATE_FORCE_DWORD = $7FFFFFFF
    );

type
  THGEHWndState = (
    HGE_HWND = 26, // int    window handle: read only
    HGE_HWNDPARENT = 27, // int    parent win handle  (default: 0)

    HGEHWNDSTATE_FORCE_DWORD = $7FFFFFFF
    );

type
  THGEIntState = (
    HGE_SCREENWIDTH = 9, // int    screen width    (default: 800)
    HGE_SCREENHEIGHT = 10, // int    screen height    (default: 600)
    HGE_SCREENBPP = 11, // int    screen bitdepth    (default: 32) (desktop bpp in windowed mode)

    HGE_SAMPLERATE = 19, // int    sample rate      (default: 44100)
    HGE_FXVOLUME = 20, // int    global fx volume  (default: 100)
    HGE_MUSVOLUME = 21, // int    global music volume  (default: 100)

    HGE_FPS = 23, // int    fixed fps      (default: HGEFPS_UNLIMITED)

    HGE_WINDOWSTATE = 31,

    HGEINTSTATE_FORCE_DWORD = $7FFFFFF
    );

type
  THGEStringState = (
    HGE_ICON = 7, // char*  icon resource    (default: NULL)
    HGE_TITLE = 8, // char*  window title    (default: "HGE")

    HGE_INIFILE = 15, // char*  ini file      (default: NULL) (meaning no file)
    HGE_LOGFILE = 16, // char*  log file      (default: NULL) (meaning no file)

    HGESTRINGSTATE_FORCE_DWORD = $7FFFFFFF
    );

  (*
  ** Callback protoype used by HGE
  *)
type
  THGECallback = function: Boolean;
  THGEEventCallback = procedure(p: Pointer; X, Y: Single);
  THGESysCommandCallBack = procedure(hWnd: hWnd; wParam: wParam; lParam: lParam);
  (*
  ** HGE_FPS system state special constants
  *)
const
  HGEFPS_UNLIMITED  = 0;
  HGEFPS_VSYNC      = -1;

  (*
  ** HGE Primitive type constants
  *)
const
  D3DFVF_HGEVERTEX  = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;
  VERTEX_BUFFER_SIZE = 4000;

  HGEPRIM_LINES     = 2;
  HGEPRIM_TRIPLES   = 3;
  HGEPRIM_QUADS     = 4;

  HGEPRIM_LINES_BUFFER_SIZE = VERTEX_BUFFER_SIZE div HGEPRIM_LINES;
  HGEPRIM_TRIPLES_BUFFER_SIZE = VERTEX_BUFFER_SIZE div HGEPRIM_TRIPLES;
  HGEPRIM_QUADS_BUFFER_SIZE = VERTEX_BUFFER_SIZE div HGEPRIM_QUADS;

  (*
  ** HGE Vertex structure
  *)
type
  THGEVertex = record
    X, Y: Single; // screen position
    Z: Single; // Z-buffer depth 0..1
    Col: Longword; // color
    TX, TY: Single; // texture coordinates
  end;
  PHGEVertex = ^THGEVertex;
  THGEVertexArray = array[0..MaxInt div 32 - 1] of THGEVertex;
  PHGEVertexArray = ^THGEVertexArray;

  (*
  ** HGE Triple structure
  *)
type
  THGETriple = record
    V: array[0..2] of THGEVertex;
    Tex: ITexture;
    Blend: Integer;
  end;
  PHGETriple = ^THGETriple;

  (*
  ** HGE Quad structure
  *)
type
  THGEQuad = record
    V: array[0..3] of THGEVertex;
    Tex: ITexture;
    Blend: Integer;
  end;
  PHGEQuad = ^THGEQuad;

  (*
  ** HGE Input Event structure
  *)
type
  pTHGEInputEvent = ^THGEInputEvent;
  THGEInputEvent = record
    EventType: Integer; // event type
    Key: Integer; // key code
    Flags: Integer; // event flags
    Chr: Integer; // character code
    Wheel: Integer; // wheel shift
    X: Single; // mouse cursor x-coordinate
    Y: Single; // mouse cursor y-coordinate
  end;

  (*
  ** HGE Input Event type constants
  *)
const
  INPUT_KEYDOWN     = 1;
  INPUT_KEYUP       = 2;
  INPUT_MBUTTONDOWN = 3;
  INPUT_MBUTTONUP   = 4;
  INPUT_MOUSEMOVE   = 5;
  INPUT_MOUSEWHEEL  = 6;

  INPUT_CHAR        = 7;
  INPUT_IME_CHAR    = 8;

  (*
  ** HGE Input Event flags
  *)
const
  HGEINP_SHIFT      = 1;
  HGEINP_CTRL       = 2;
  HGEINP_ALT        = 4;
  HGEINP_CAPSLOCK   = 8;
  HGEINP_SCROLLLOCK = 16;
  HGEINP_NUMLOCK    = 32;
  HGEINP_REPEAT     = 64;

type
  IHGE = interface
    ['{14AD0876-19A5-4B13-B2D8-46ECE1E336BA}']
    function System_Initiate: Boolean;
    procedure System_Shutdown;
    function System_Start: Boolean;
    function System_GetErrorMessage: string;
    procedure System_Log(const S: string); overload;
    procedure System_Log(const Format: string; const Args: array of const); overload;
    function System_Launch(const Url: string): Boolean;
    procedure System_Snapshot(const Filename: string);
    procedure System_SetState(const State: THGEBoolState; const Value: Boolean); overload;
    procedure System_SetState(const State: THGEFuncState; const Value: THGECallback); overload;
    procedure System_SetState(const State: THGEFuncState; const Value: THGEEventCallback); overload;
    procedure System_SetState(const State: THGEHWndState; const Value: hWnd); overload;
    procedure System_SetState(const State: THGEIntState; const Value: Integer); overload;
    procedure System_SetState(const State: THGEStringState; const Value: string); overload;
    function System_GetState(const State: THGEBoolState): Boolean; overload;
    function System_GetState(const State: THGEFuncState): THGECallback; overload;
    function System_GetState(const State: THGEHWndState): hWnd; overload;
    function System_GetState(const State: THGEIntState): Integer; overload;
    function System_GetState(const State: THGEStringState): string; overload;

    function Resource_Load(const Filename: string; const Size: PLongword = nil): IResource; overload;
    function Resource_Load(const Filename: string; const List: TStringList): Integer; overload;

    { NOTE: ZIP passwords are not supported in Delphi version }
    function Resource_AttachPack(const Filename: string): Boolean;
    procedure Resource_RemovePack(const Filename: string);
    procedure Resource_RemoveAllPacks;
    function Resource_MakePath(const Filename: string = ''): string;
    function Resource_EnumFiles(const Wildcard: string = ''): string;
    function Resource_EnumFolders(const Wildcard: string = ''): string;

    procedure Ini_SetInt(const Section, Name: string; const Value: Integer);
    function Ini_GetInt(const Section, Name: string; const DefVal: Integer = 0): Integer;
    procedure Ini_SetFloat(const Section, Name: string; const Value: Single);
    function Ini_GetFloat(const Section, Name: string; const DefVal: Single): Single;
    procedure Ini_SetString(const Section, Name, Value: string);
    function Ini_GetString(const Section, Name, DefVal: string): string;

    procedure Random_Seed(const Seed: Integer = 0);
    function Random_Int(const Min, Max: Integer): Integer;
    function Random_Float(const Min, Max: Single): Single;

    function Timer_GetTime: Single;
    function Timer_GetDelta: Single;
    function Timer_GetFPS: Integer;

    function Flash_Load(const Filename: string; const Size: PLongword): TMemoryStream;

    function Effect_Load(const Data: Pointer; const Size: Longword): IEffect; overload;
    function Effect_Load(const Filename: string): IEffect; overload;
    function Effect_Play(const Eff: IEffect): IChannel;
    function Effect_PlayEx(const Eff: IEffect; const Volume: Integer = 100;
      const Pan: Integer = 0; const Pitch: Single = 1.0; const Loop: Boolean = False): IChannel;

    function Music_Load(const Filename: string): IMusic; overload;
    function Music_Load(const Data: Pointer; const Size: Longword): IMusic; overload;
    function Music_Play(const Mus: IMusic; const Loop: Boolean;
      const Volume: Integer = 100; const Order: Integer = -1;
      const Row: Integer = -1): IChannel;
    procedure Music_SetAmplification(const Music: IMusic; const Ampl: Integer);
    function Music_GetAmplification(const Music: IMusic): Integer;
    function Music_GetLength(const Music: IMusic): Integer;
    procedure Music_SetPos(const Music: IMusic; const Order, Row: Integer);
    function Music_GetPos(const Music: IMusic; out Order, Row: Integer): Boolean;
    procedure Music_SetInstrVolume(const Music: IMusic; const Instr,
      Volume: Integer);
    function Music_GetInstrVolume(const Music: IMusic;
      const Instr: Integer): Integer;
    procedure Music_SetChannelVolume(const Music: IMusic; const Channel,
      Volume: Integer);
    function Music_GetChannelVolume(const Music: IMusic;
      const Channel: Integer): Integer;

    function Stream_Load(const Filename: string): IStream; overload;
    function Stream_Load(const Data: Pointer; const Size: Longword): IStream; overload;
    function Stream_Play(const Stream: IStream; const Loop: Boolean;
      const Volume: Integer = 100): IChannel;

    procedure Channel_SetPanning(const Chn: IChannel; const Pan: Integer);
    procedure Channel_SetVolume(const Chn: IChannel; const Volume: Integer);
    procedure Channel_SetPitch(const Chn: IChannel; const Pitch: Single);
    procedure Channel_Pause(const Chn: IChannel);
    procedure Channel_Resume(const Chn: IChannel);
    procedure Channel_Stop(const Chn: IChannel);
    procedure Channel_PauseAll;
    procedure Channel_ResumeAll;
    procedure Channel_StopAll;
    function Channel_IsPlaying(const Chn: IChannel): Boolean;
    function Channel_GetLength(const Chn: IChannel): Single;
    function Channel_GetPos(const Chn: IChannel): Single;
    procedure Channel_SetPos(const Chn: IChannel; const Seconds: Single);
    procedure Channel_SlideTo(const Channel: IChannel; const Time: Single;
      const Volume: Integer; const Pan: Integer = -101; const Pitch: Single = -1);
    function Channel_IsSliding(const Channel: IChannel): Boolean;

    procedure Input_GetMousePos(out X, Y: Single);
    procedure Input_SetMousePos(const X, Y: Single);
    function Input_GetMouseWheel: Integer;
    function Input_IsMouseOver: Boolean;
    function INPUT_KEYDOWN(const Key: Integer): Boolean;
    function INPUT_KEYUP(const Key: Integer): Boolean;
    function Input_GetKeyState(const Key: Integer): Boolean;
    function Input_GetKeyName(const Key: Integer): string;
    function Input_GetKey: Integer;
    function Input_GetChar: Integer;
    function Input_GetEvent(out Event: THGEInputEvent): Boolean;

    function Gfx_BeginScene(const Target: ITarget = nil): Boolean;
    procedure Gfx_EndScene;
    procedure Gfx_Clear(const Color: Longword);
    procedure Gfx_RenderLine(const X1, Y1, X2, Y2: Single;
      const Color: Longword = $FFFFFFFF; const Z: Single = 0.5);
    procedure Gfx_RenderTriple(const Triple: THGETriple);
    procedure Gfx_RenderQuad(const Quad: THGEQuad);

    procedure Gfx_RenderCircle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderTriangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderEllipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderArc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderLine2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
    procedure Gfx_RenderQuadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderPolygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderSquareSchedule(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);

    function Gfx_StartBatch(const PrimType: Integer; const Tex: ITexture;
      const Blend: Integer; out MaxPrim: Integer): PHGEVertexArray;
    procedure Gfx_FinishBatch(const NPrim: Integer);
    procedure Gfx_SetClipping(X: Integer = 0; Y: Integer = 0;
      W: Integer = 0; H: Integer = 0);
    procedure Gfx_SetTransform(const X: Single = 0; const Y: Single = 0;
      const DX: Single = 0; const DY: Single = 0; const Rot: Single = 0;
      const HScale: Single = 0; const VScale: Single = 0);

    function Target_Create(const Width, Height: Integer; const ZBuffer: Boolean): ITarget;
    function Target_GetTexture(const Target: ITarget): ITexture;

    function Texture_Create({$IFDEF DYNTEX}IsDynTex: Boolean; {$ENDIF}const Width, Height: Integer; Format: TD3DFormat = D3DFMT_A8R8G8B8): ITexture;

    function Texture_Load(const Data: Pointer; const Size: Longword;
      const Mipmap: Boolean = False; const ColorKey: LongInt = 0): ITexture; overload;
    function Texture_Load(const Filename: string;
      const Mipmap: Boolean = False; const ColorKey: LongInt = 0): ITexture; overload;
    function Texture_GetWidth(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_GetHeight(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_Lock(const Tex: ITexture; const ReadOnly: Boolean = True;
      const Left: Integer = 0; const Top: Integer = 0; const Width: Integer = 0;
      const Height: Integer = 0): PLongword;
    procedure Texture_Unlock(const Tex: ITexture);

    { Extensions }
    function Texture_Load(const ImageData: Pointer; const ImageSize: Longword;
      const AlphaData: Pointer; const AlphaSize: Longword;
      const Mipmap: Boolean = False): ITexture; overload;
    function Texture_Load(const ImageFilename, AlphaFilename: string;
      const Mipmap: Boolean = False): ITexture; overload;

    //2008 Nov additional
    procedure Point(X, Y: Single; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
    procedure Line2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
    procedure SetGamma(Red, Green, Blue, Brightness, Contrast: Byte);
    procedure Line(X1, Y1, X2, Y2: Single; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
    procedure Circle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Circle(X, Y, Radius: Single; Width: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Ellipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Arc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Arc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; Width: Integer; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Triangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Quadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Quadrangle(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Rectangle(X, Y, Width, Height: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Rectangle(X, Y, Width, Height: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Polygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Polygon(Points: array of TPoint; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure LineH(X1, X2, Y: Integer; Red, Green, Blue: Byte; Width: Integer = 1);
    procedure LineV(X, Y1, Y2: Integer; Red, Green, Blue: Byte; Width: Integer = 1);
    procedure RectangleEx(X1, Y1, X2, Y2: Integer; Solid: Boolean;
      BorderWidth: Integer; Red, Green, Blue: Integer);
    procedure LineTo(X, Y: Single; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
    procedure MoveTo(X, Y: Single);

    procedure SetSystemCommandFunc(Proc: THGESysCommandCallBack);
    function GetLastHgeError: string;
    {$IF CUSTOMUI_SAVE}
    procedure Texture_SaveToFile(SrcTexture: IDirect3DBaseTexture; const Filename: string);
    {$IFEND}
    function GetActive: Boolean;
    property Active: Boolean read GetActive;

    procedure SetIntTest(I: Integer);
    function GetIntTest: Integer;
    property IntTest: Integer read GetIntTest write SetIntTest;
{$IFDEF DYNTEX}
    function GetSuportsDynamicTextures: Boolean;
    property SuportsDynamicTextures: Boolean read GetSuportsDynamicTextures;
{$ENDIF}
    function IsCompressedTextureFormatOk(TextureFormat: TD3DFormat; AdapterFormat: TD3DFormat): Boolean;

    function GetD3DDevice: IDirect3DDevice;
    property D3DDevice: IDirect3DDevice read GetD3DDevice;
  end;

function HGECreate(const Ver: Integer): IHGE;

(*
** HGE Virtual-key codes
*)
const
  HGEK_LBUTTON      = $01;
  HGEK_RBUTTON      = $02;
  HGEK_MBUTTON      = $04;

  HGEK_ESCAPE       = $1B;
  HGEK_BACKSPACE    = $08;
  HGEK_TAB          = $09;
  HGEK_ENTER        = $0D;
  HGEK_SPACE        = $20;

  HGEK_SHIFT        = $10;
  HGEK_CTRL         = $11;
  HGEK_ALT          = $12;

  HGEK_LWIN         = $5B;
  HGEK_RWIN         = $5C;
  HGEK_APPS         = $5D;

  HGEK_PAUSE        = $13;
  HGEK_CAPSLOCK     = $14;
  HGEK_NUMLOCK      = $90;
  HGEK_SCROLLLOCK   = $91;

  HGEK_PGUP         = $21;
  HGEK_PGDN         = $22;
  HGEK_HOME         = $24;
  HGEK_END          = $23;
  HGEK_INSERT       = $2D;
  HGEK_DELETE       = $2E;

  HGEK_LEFT         = $25;
  HGEK_UP           = $26;
  HGEK_RIGHT        = $27;
  HGEK_DOWN         = $28;

  HGEK_0            = $30;
  HGEK_1            = $31;
  HGEK_2            = $32;
  HGEK_3            = $33;
  HGEK_4            = $34;
  HGEK_5            = $35;
  HGEK_6            = $36;
  HGEK_7            = $37;
  HGEK_8            = $38;
  HGEK_9            = $39;

  HGEK_A            = $41;
  HGEK_B            = $42;
  HGEK_C            = $43;
  HGEK_D            = $44;
  HGEK_E            = $45;
  HGEK_F            = $46;
  HGEK_G            = $47;
  HGEK_H            = $48;
  HGEK_I            = $49;
  HGEK_J            = $4A;
  HGEK_K            = $4B;
  HGEK_L            = $4C;
  HGEK_M            = $4D;
  HGEK_N            = $4E;
  HGEK_O            = $4F;
  HGEK_P            = $50;
  HGEK_Q            = $51;
  HGEK_R            = $52;
  HGEK_S            = $53;
  HGEK_T            = $54;
  HGEK_U            = $55;
  HGEK_V            = $56;
  HGEK_W            = $57;
  HGEK_X            = $58;
  HGEK_Y            = $59;
  HGEK_Z            = $5A;

  HGEK_GRAVE        = $C0;
  HGEK_MINUS        = $BD;
  HGEK_EQUALS       = $BB;
  HGEK_BACKSLASH    = $DC;
  HGEK_LBRACKET     = $DB;
  HGEK_RBRACKET     = $DD;
  HGEK_SEMICOLON    = $BA;
  HGEK_APOSTROPHE   = $DE;
  HGEK_COMMA        = $BC;
  HGEK_PERIOD       = $BE;
  HGEK_SLASH        = $BF;

  HGEK_NUMPAD0      = $60;
  HGEK_NUMPAD1      = $61;
  HGEK_NUMPAD2      = $62;
  HGEK_NUMPAD3      = $63;
  HGEK_NUMPAD4      = $64;
  HGEK_NUMPAD5      = $65;
  HGEK_NUMPAD6      = $66;
  HGEK_NUMPAD7      = $67;
  HGEK_NUMPAD8      = $68;
  HGEK_NUMPAD9      = $69;

  HGEK_MULTIPLY     = $6A;
  HGEK_DIVIDE       = $6F;
  HGEK_ADD          = $6B;
  HGEK_SUBTRACT     = $6D;
  HGEK_DECIMAL      = $6E;

  HGEK_F1           = $70;
  HGEK_F2           = $71;
  HGEK_F3           = $72;
  HGEK_F4           = $73;
  HGEK_F5           = $74;
  HGEK_F6           = $75;
  HGEK_F7           = $76;
  HGEK_F8           = $77;
  HGEK_F9           = $78;
  HGEK_F10          = $79;
  HGEK_F11          = $7A;
  HGEK_F12          = $7B;

type
  TSysFont = class
  private
    FFont: ID3DXFont;
    FHGE: IHGE;
    FName: string;
    FSize: Integer;
    FStyle: TFontStyles;
    FRed: Byte;
    FBlue: Byte;
    FGreen: Byte;
    FAlpha: Byte;
    FColor: Cardinal;
    FCanvas: TCanvas;
    FTheFont: TFont;
{$IFDEF DX9}
    FTextSprite: ID3DXSprite;
{$ENDIF}
    procedure SetColor(const Value: Cardinal);
  public
    constructor Create;
    destructor Destroy; override;
    function CreateFont(FontName: string; Size: Integer; Style: TFontStyles): Boolean; overload;
    function CreateFont(const Font: TFont): Boolean; overload;
    function TextHeight(const Text: string): Integer;
    function TextWidth(const Text: string): Integer;
    procedure BeginFont;
    procedure EndFont;
    procedure Init;
    procedure UnInit;
    procedure PrintInvert(XPos, YPos: Integer; sString: string);
    procedure Print(XPos, YPos: Integer; sString: string; R, G, B, A: Byte); overload;
    procedure Print(XPos, YPos: Integer; sString: string); overload;
    procedure Print(Pos: TPoint; sString: string); overload;
    property Color: Cardinal read FColor write SetColor;
    property Red: Byte read FRed write FRed;
    property Blue: Byte read FBlue write FBlue;
    property Green: Byte read FGreen write FGreen;
    property Alpha: Byte read FAlpha write FAlpha;
  end;

  TResource = class(TInterfacedObject, IResource)
  private
    FHandle: Pointer;
    FSize: Longword;
  protected
    { IResource }
    function GetHandle: Pointer;
    function GetSize: Longword;
  public
    constructor Create(const AHandle: Pointer; const ASize: Longword);
    destructor Destroy; override;
  end;

implementation

uses
  Messages, Math, MMSystem, ShellAPI, SysUtils, Types, ZLib, ZipUtils,
  UnZip, PackLib;

const
  CRLF              = #13#10;

  (****************************************************************************
   * HGE.h - Macro implementations
   ****************************************************************************)

function timeGetTime: DWORD; inline;
begin
  Result := GetTickCount();
end;

function ARGB(const A, R, G, B: Byte): Longword; inline;
inline;
begin
  Result := (A shl 24) or (R shl 16) or (G shl 8) or B;
end;

function GetA(const Color: Longword): Byte; inline;
inline;
begin
  Result := Color shr 24;
end;

function GetR(const Color: Longword): Byte; inline;
inline;
begin
  Result := (Color shr 16) and $FF;
end;

function GetG(const Color: Longword): Byte; inline;
inline;
begin
  Result := (Color shr 8) and $FF;
end;

function GetB(const Color: Longword): Byte; inline;
inline;
begin
  Result := Color and $FF;
end;

function SetA(const Color: Longword; const A: Byte): Longword; inline;
inline;
begin
  Result := (Color and $00FFFFFF) or (A shl 24);
end;

function SetR(const Color: Longword; const A: Byte): Longword; inline;
inline;
begin
  Result := (Color and $FF00FFFF) or (A shl 16);
end;

function SetG(const Color: Longword; const A: Byte): Longword; inline;
inline;
begin
  Result := (Color and $FFFF00FF) or (A shl 8);
end;

function SetB(const Color: Longword; const A: Byte): Longword; inline;
inline;
begin
  Result := (Color and $FFFFFF00) or A;
end;

(****************************************************************************
 * HGE_Impl.h
 ****************************************************************************)

{.$DEFINE DEMO}

type
  PResourceList = ^TResourceList;
  TResourceList = record
    Filename: string;
    // Password: String; // NOTE: ZIP passwords are not supported in Delphi version
    Next: PResourceList;
    Lib: TObject;
  end;

type
  PInputEventList = ^TInputEventList;
  TInputEventList = record
    Event: THGEInputEvent;
    Next: PInputEventList;
  end;

{$IFDEF DEMO}
procedure DInit; forward;
procedure DDone; forward;
function DFrame: Boolean; forward;
{$ENDIF}

(*
** HGE Interface implementation
*)
type
  THGEImpl = class(TInterfacedObject, IHGE)
  private
    FLastErrorStr: string;
    procedure FreeTimeoutResource;
  protected
    { IHGE }
    function System_Initiate: Boolean;
    procedure System_Shutdown;
    function System_Start: Boolean;
    function System_GetErrorMessage: string;
    procedure System_Log(const S: string); overload;
    procedure System_Log(const Format: string; const Args: array of const); overload;
    function System_Launch(const Url: string): Boolean;
    procedure System_Snapshot(const Filename: string);
    procedure System_SetState(const State: THGEBoolState; const Value: Boolean); overload;
    procedure System_SetState(const State: THGEFuncState; const Value: THGECallback); overload;
    procedure System_SetState(const State: THGEFuncState; const Value: THGEEventCallback); overload;
    procedure System_SetState(const State: THGEHWndState; const Value: hWnd); overload;
    procedure System_SetState(const State: THGEIntState; const Value: Integer); overload;
    procedure System_SetState(const State: THGEStringState; const Value: string); overload;
    function System_GetState(const State: THGEBoolState): Boolean; overload;
    function System_GetState(const State: THGEFuncState): THGECallback; overload;
    function System_GetState(const State: THGEHWndState): hWnd; overload;
    function System_GetState(const State: THGEIntState): Integer; overload;
    function System_GetState(const State: THGEStringState): string; overload;

    function Resource_Load(const Filename: string; const Size: PLongword = nil): IResource; overload;
    function Resource_Load(const Filename: string; const List: TStringList): Integer; overload;

    function Resource_AttachPack(const Filename: string): Boolean;
    procedure Resource_RemovePack(const Filename: string);
    procedure Resource_RemoveAllPacks;
    function Resource_MakePath(const Filename: string = ''): string;
    function Resource_EnumFiles(const Wildcard: string = ''): string;
    function Resource_EnumFolders(const Wildcard: string = ''): string;

    procedure Ini_SetInt(const Section, Name: string; const Value: Integer);
    function Ini_GetInt(const Section, Name: string; const DefVal: Integer = 0): Integer;
    procedure Ini_SetFloat(const Section, Name: string; const Value: Single);
    function Ini_GetFloat(const Section, Name: string; const DefVal: Single): Single;
    procedure Ini_SetString(const Section, Name, Value: string);
    function Ini_GetString(const Section, Name, DefVal: string): string;

    procedure Random_Seed(const Seed: Integer = 0);
    function Random_Int(const Min, Max: Integer): Integer;
    function Random_Float(const Min, Max: Single): Single;

    function Timer_GetTime: Single;
    function Timer_GetDelta: Single;
    function Timer_GetFPS: Integer;

    function Flash_Load(const Filename: string; const Size: PLongword): TMemoryStream;

    function Effect_Load(const Data: Pointer; const Size: Longword): IEffect; overload;
    function Effect_Load(const Filename: string): IEffect; overload;
    function Effect_Play(const Eff: IEffect): IChannel;
    function Effect_PlayEx(const Eff: IEffect; const Volume: Integer = 100;
      const Pan: Integer = 0; const Pitch: Single = 1.0; const Loop: Boolean = False): IChannel;

    function Music_Load(const Filename: string): IMusic; overload;
    function Music_Load(const Data: Pointer; const Size: Longword): IMusic; overload;
    function Music_Play(const Mus: IMusic; const Loop: Boolean;
      const Volume: Integer = 100; const Order: Integer = -1;
      const Row: Integer = -1): IChannel;
    procedure Music_SetAmplification(const Music: IMusic; const Ampl: Integer);
    function Music_GetAmplification(const Music: IMusic): Integer;
    function Music_GetLength(const Music: IMusic): Integer;
    procedure Music_SetPos(const Music: IMusic; const Order, Row: Integer);
    function Music_GetPos(const Music: IMusic; out Order, Row: Integer): Boolean;
    procedure Music_SetInstrVolume(const Music: IMusic; const Instr,
      Volume: Integer);
    function Music_GetInstrVolume(const Music: IMusic;
      const Instr: Integer): Integer;
    procedure Music_SetChannelVolume(const Music: IMusic; const Channel,
      Volume: Integer);
    function Music_GetChannelVolume(const Music: IMusic;
      const Channel: Integer): Integer;

    function Stream_Load(const Filename: string): IStream; overload;
    function Stream_Load(const Data: Pointer; const Size: Longword): IStream; overload;
    function Stream_Load(const Resource: IResource; const Size: Longword): IStream; overload;
    function Stream_Play(const Stream: IStream; const Loop: Boolean;
      const Volume: Integer = 100): IChannel;

    procedure Channel_SetPanning(const Chn: IChannel; const Pan: Integer);
    procedure Channel_SetVolume(const Chn: IChannel; const Volume: Integer);
    procedure Channel_SetPitch(const Chn: IChannel; const Pitch: Single);
    procedure Channel_Pause(const Chn: IChannel);
    procedure Channel_Resume(const Chn: IChannel);
    procedure Channel_Stop(const Chn: IChannel);
    procedure Channel_PauseAll;
    procedure Channel_ResumeAll;
    procedure Channel_StopAll;
    function Channel_IsPlaying(const Chn: IChannel): Boolean;
    function Channel_GetLength(const Chn: IChannel): Single;
    function Channel_GetPos(const Chn: IChannel): Single;
    procedure Channel_SetPos(const Chn: IChannel; const Seconds: Single);
    procedure Channel_SlideTo(const Channel: IChannel; const Time: Single;
      const Volume: Integer; const Pan: Integer = -101; const Pitch: Single = -1);
    function Channel_IsSliding(const Channel: IChannel): Boolean;

    procedure Input_GetMousePos(out X, Y: Single);
    procedure Input_SetMousePos(const X, Y: Single);
    function Input_GetMouseWheel: Integer;
    function Input_IsMouseOver: Boolean;
    function INPUT_KEYDOWN(const Key: Integer): Boolean;
    function INPUT_KEYUP(const Key: Integer): Boolean;
    function Input_GetKeyState(const Key: Integer): Boolean;
    function Input_GetKeyName(const Key: Integer): string;
    function Input_GetKey: Integer;
    function Input_GetChar: Integer;
    function Input_GetEvent(out Event: THGEInputEvent): Boolean;

    function Gfx_BeginScene(const Target: ITarget = nil): Boolean;
    procedure Gfx_EndScene;
    procedure Gfx_Clear(const Color: Longword);
    procedure Gfx_RenderLine(const X1, Y1, X2, Y2: Single;
      const Color: Longword = $FFFFFFFF; const Z: Single = 0.5);
    procedure Gfx_RenderTriple(const Triple: THGETriple);
    procedure Gfx_RenderQuad(const Quad: THGEQuad);

    procedure Gfx_RenderCircle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderTriangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderEllipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderArc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderLine2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
    procedure Gfx_RenderQuadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderPolygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderSquareSchedule(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);

    function Gfx_StartBatch(const PrimType: Integer; const Tex: ITexture;
      const Blend: Integer; out MaxPrim: Integer): PHGEVertexArray;
    procedure Gfx_FinishBatch(const NPrim: Integer);
    procedure Gfx_SetClipping(X: Integer = 0; Y: Integer = 0;
      W: Integer = 0; H: Integer = 0);
    procedure Gfx_SetTransform(const X: Single = 0; const Y: Single = 0;
      const DX: Single = 0; const DY: Single = 0; const Rot: Single = 0;
      const HScale: Single = 0; const VScale: Single = 0);

    function Target_Create(const Width, Height: Integer; const ZBuffer: Boolean): ITarget;
    function Target_GetTexture(const Target: ITarget): ITexture;

    function Texture_Create({$IFDEF DYNTEX}IsDynTex: Boolean; {$ENDIF}const Width, Height: Integer; Format: TD3DFormat = D3DFMT_A8R8G8B8): ITexture;
    function Texture_Load(const Data: Pointer; const Size: Longword;
      const Mipmap: Boolean = False; const ColorKey: LongInt = 0): ITexture; overload;
    function Texture_Load(const Filename: string;
      const Mipmap: Boolean = False; const ColorKey: LongInt = 0): ITexture; overload;
    function Texture_GetWidth(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_GetHeight(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_Lock(const Tex: ITexture; const ReadOnly: Boolean = True;
      const Left: Integer = 0; const Top: Integer = 0; const Width: Integer = 0;
      const Height: Integer = 0): PLongword;
    procedure Texture_Unlock(const Tex: ITexture);

    { Extensions }
    function Texture_Load(const ImageData: Pointer; const ImageSize: Longword;
      const AlphaData: Pointer; const AlphaSize: Longword;
      const Mipmap: Boolean = False): ITexture; overload;
    function Texture_Load(const ImageFilename, AlphaFilename: string;
      const Mipmap: Boolean = False): ITexture; overload;
    //2008 Nov
    procedure SetGamma(Red, Green, Blue, Brightness, Contrast: Byte);
    procedure Point(X, Y: Single; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
    procedure Line(X1, Y1, X2, Y2: Single; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
    procedure Line2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
    procedure Circle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean;
      BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Circle(X, Y, Radius: Single; Width: Integer; Color: Cardinal;
      Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Ellipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean;
      BlendMode: Integer = BLEND_DEFAULT);
    procedure Arc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal;
      DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Arc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal;
      Width: Integer; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Triangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal;
      Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Quadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single;
      Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Quadrangle(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color: Cardinal;
      Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Rectangle(X, Y, Width, Height: Single; Color: Cardinal; Filled: Boolean;
      BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Rectangle(X, Y, Width, Height: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean;
      BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Polygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal;
      Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Polygon(Points: array of TPoint; Color: Cardinal; Filled: Boolean;
      BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure LineH(X1, X2, Y: Integer; Red, Green, Blue: Byte; Width: Integer = 1);
    procedure LineV(X, Y1, Y2: Integer; Red, Green, Blue: Byte; Width: Integer = 1);
    procedure RectangleEx(X1, Y1, X2, Y2: Integer; Solid: Boolean;
      BorderWidth: Integer; Red, Green, Blue: Integer);
    procedure LineTo(X, Y: Single; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
    procedure MoveTo(X, Y: Single);
    procedure SetSystemCommandFunc(Proc: THGESysCommandCallBack);
    function GetLastHgeError: string;
    {$IF CUSTOMUI_SAVE}
    procedure Texture_SaveToFile(SrcTexture: IDirect3DBaseTexture; const Filename: string);
    {$IFEND}
  private
    //////// Implementation ////////
    Vertices: array[0..1000 + 4] of THGEVertex; //1234

    FInstance: THandle;
    FWnd: hWnd;
    FActive: Boolean;
    FError: string;
    FAppPath: string;
    FFormatSettings: TFormatSettings;
    procedure CopyVertices(pVertices: PByte; numVertices: Integer);
    procedure FocusChange(const Act: Boolean);
    procedure PostError(const Error: string);
    class function InterfaceGet: THGEImpl;
  private
    // Extensions
    function Texture_LoadJPEG2000(const Data: Pointer; const Size: Longword;
      const Mipmap: Boolean; const Format: TOPJ_CodecFormat): ITexture;
  private
    // System States
    FProcFrameFunc: THGECallback;
    FProcRenderFunc: THGECallback;
    FProcImgCacheFunc: THGECallback;
    FProcFocusLostFunc: THGECallback;
    FProcFocusGainFunc: THGECallback;
    FProcGfxRestoreFunc: THGECallback;
    FProcExitFunc: THGECallback;
    FProcResize: THGECallback;
    FProcEvent: THGEEventCallback;
    FSystemCommandFunc: THGESysCommandCallBack;
    FIcon: string;
    FWinTitle: string;
    FScreenWidth: Integer;
    FScreenHeight: Integer;
    FScreenBPP: Integer;
    FWindowed: Boolean;
    FWindowState: Integer;
    FNoBorder: Boolean;
    FZBuffer: Boolean;
    FTextureFilter: Boolean;
    FIniFile: string;
    FLogFile: string;
    FUseSound: Boolean;
    FSampleRate: Integer;
    FFXVolume: Integer;
    FMusVolume: Integer;
    FHGEFPS: Integer;
    FHideMouse: Boolean;
    FDontSuspend: Boolean;
    FWndParent: hWnd;
{$IFDEF DEMO}
    FDMO: Boolean;
{$ENDIF}
  private
    // Graphics

    FVertexLockCnt: Integer; //333
    FHasProcDeviceLost: Boolean;
    
{$IFDEF DYNTEX}
    FSuportsDynamicTextures: Boolean;
{$ENDIF}

    FD3DPP: PD3DPresentParameters;
    FD3DPPW: TD3DPresentParameters;
    FRectW: TRect;
    FStyleW: Longword;
    FD3DPPFS: TD3DPresentParameters;
    FRectFS: TRect;
    FStyleFS: Longword;
    FD3D: IDirect3D;
    FD3DDevice: IDirect3DDevice;
    FVB: IDirect3DVertexBuffer;
    FIB: IDirect3DIndexBuffer;
    FScreenSurf: IDirect3DSurface;
    FScreenDepth: IDirect3DSurface;

    FTargets: TList;
    FCurTarget: ITarget;

    FMatView: TD3DXMatrix;
    FMatProj: TD3DXMatrix;
    FVertArray: PHGEVertexArray;
    FPrim: Integer;
    FCurPrimType: Integer;
    FCurBlendMode: Integer;
    FCurTexture: ITexture;
    function GfxInit: Boolean;
    function GfxReInit: Boolean;
    procedure GfxDone;
    function GfxRestore: Boolean;
    procedure AdjustWindow;
    procedure Resize(const Width, Height: Integer);
    function InitLost: Boolean;
    procedure RenderBatch(const EndScene: Boolean = False);
    function FormatId(const Fmt: TD3DFormat): Integer;
    procedure SetBlendMode(const Blend: Integer);
    procedure SetProjectionMatrix(const Width, Height: Integer);
  private
    // Audio
    FBass: THandle;
    FSilent: Boolean;
    function SoundInit: Boolean;
    procedure SoundDone;
    procedure SetMusVolume(const Vol: Integer);
    procedure SetFXVolume(const Vol: Integer);
  private
    // Input
    FVKey: Integer;
    FChar: Integer;
    FZPos: Integer;
    FXPos: Single;
    FYPos: Single;
    FMouseOver: Boolean;
    FCaptured: Boolean;
    FKeyz: array[0..255] of Byte;
    FQueue: PInputEventList;
    procedure UpdateMouse;
    procedure InputInit;
    procedure ClearQueue;
    procedure BuildEvent(EventType, Key, Scan, Flags, X, Y: Integer);
  private
    // Resource
    FTmpFilename: string;
    FRes: PResourceList;
    FSearch: TSearchRec;
  private
    // Timer
    FTime: Single;
    FDeltaTime: Single;
    FFixedDelta: Longword;
    FFPS: Integer;
    FT0, FT0FPS, FDT: Longword;
    FCFPS: Integer;
    FMX, FMY: Single;
  private
    constructor Create;
  public
    FIntTest: Integer;
    destructor Destroy; override;

    function GetActive: Boolean;
    property Active: Boolean read FActive;

    procedure SetIntTest(I: Integer);
    function GetIntTest: Integer;
    property IntTest: Integer read GetIntTest write SetIntTest;

{$IFDEF DYNTEX}
    function GetSuportsDynamicTextures: Boolean;
    property SuportsDynamicTextures: Boolean read GetSuportsDynamicTextures;
{$ENDIF}

    function IsCompressedTextureFormatOk(TextureFormat: TD3DFormat; AdapterFormat: TD3DFormat): Boolean;

    function GetD3DDevice: IDirect3DDevice;
    property D3DDevice: IDirect3DDevice read GetD3DDevice;
  end;

var
  PHGE              : THGEImpl = nil;

type
  IInternalChannel = interface(IChannel)
    ['{F7EFCB72-56E5-4FED-A89A-4B1D0AEE794D}']
    procedure SetHandle(const Value: HChannel);
  end;

type
  IInternalTarget = interface(ITarget)
    ['{579FDCE5-3D0C-403F-9B58-44117B226A26}']
    function GetDepth: IDirect3DSurface;

    procedure Restore;
    procedure Lost;

    property Depth: IDirect3DSurface read GetDepth;
  end;

type
  IInternalStream = interface(IStream)
    ['{37BFE886-0402-4CB7-B2A1-46D1C2ED0D82}']
    function GetData: IResource;

    property Data: IResource read GetData;
  end;

type
  TTexture = class(TInterfacedObject, ITexture)
  private
    FName: string;
    FTagID: Integer;
{$IFDEF DYNTEX}
    FIsDynTex: Boolean;
{$ENDIF}
    FPatternWidth: Integer;
    FPatternHeight: Integer;
    FPatternCount: Integer;
    FHandle: IDirect3DTexture;
    FOriginalWidth: Integer;
    FOriginalHeight: Integer;
  protected
    { ITexture }
    function GetName: string;
    procedure SetName(Value: string);
    function GetPatternWidth: Integer;
    procedure SetPatternWidth(Value: Integer);
    function GetPatternHeight: Integer;
    procedure SetPatternHeight(Value: Integer);
    function GetPatternCount: Integer;
    function GetHandle: IDirect3DTexture;
    procedure SetHandle(const Value: IDirect3DTexture);
    function GetTagID: Integer;
    procedure SetTagID(Value: Integer);
{$IFDEF DYNTEX}
    function GetIsDynTex: Boolean;
{$ENDIF}
    function GetWidth(const Original: Boolean = False): Integer;
    function GetHeight(const Original: Boolean = False): Integer;
    function Lock(const ReadOnly: Boolean = True; const Left: Integer = 0;
      const Top: Integer = 0; const Width: Integer = 0;
      const Height: Integer = 0): PLongword; overload;
    function Lock(out Rect: TD3DLockedRect; const ReadOnly: Boolean = True; const Left: Integer = 0;
      const Top: Integer = 0; const Width: Integer = 0;
      const Height: Integer = 0): PLongword; overload;
    procedure Unlock;
    function GetPixel(X, Y: Integer): LongInt;
    procedure SetPixel(X, Y: Integer; Value: LongInt);
  public
    constructor Create(const AHandle: IDirect3DTexture;
      const AOriginalWidth, AOriginalHeight: Integer{$IFDEF DYNTEX}; boDynTex: Boolean{$ENDIF});
    //destructor Destroy; override;
    property Name: string read GetName write SetName;
    property PatternWidth: Integer read GetPatternWidth write SetPatternWidth;
    property PatternHeight: Integer read GetPatternHeight write SetPatternHeight;
    property PatternCount: Integer read GetPatternCount;
    property TagID: Integer read GetTagID write SetTagID;
{$IFDEF DYNTEX}
    property IsDynTex: Boolean read GetIsDynTex;
{$ENDIF}
  end;

type
  TChannel = class(TInterfacedObject, IChannel, IInternalChannel)
  private
    FHandle: HChannel;
  protected
    { IChannel }
    function GetHandle: HChannel;
    procedure SetPanning(const Pan: Integer);
    procedure SetVolume(const Volume: Integer);
    procedure SetPitch(const Pitch: Single);
    procedure Pause;
    procedure Resume;
    procedure Stop;
    function IsPlaying: Boolean;
    function IsSliding: Boolean;
    function GetLength: Single;
    function GetPos: Single;
    procedure SetPos(const Seconds: Single);
    procedure SlideTo(const Time: Single; const Volume: Integer;
      const Pan: Integer = -101; const Pitch: Single = -1);

    { IInternalChannel }
    procedure SetHandle(const Value: HChannel);
  public
    constructor Create(const AHandle: HChannel);
    destructor Destroy; override;
  end;

type
  TEffect = class(TInterfacedObject, IEffect)
  private
    FHandle: HSample;
    FChannel: IInternalChannel;
  protected
    { IEffect }
    function GetHandle: HSample;
    function Play: IChannel;
    function PlayEx(const Volume: Integer = 100; const Pan: Integer = 0;
      const Pitch: Single = 1.0; const Loop: Boolean = False): IChannel;
  public
    constructor Create(const AHandle: HSample);
    destructor Destroy; override;
  end;

type
  TMusic = class(TChannel, IMusic, IChannel)
  private
    function MusicGetLength: Integer;
    procedure MusicSetPos(const Order, Row: Integer);
    function MusicGetPos(out Order, Row: Integer): Boolean;
  protected
    { IMusic }
    function Play(const Loop: Boolean; const Volume: Integer = 100;
      const Order: Integer = -1; const Row: Integer = -1): IChannel;
    function GetAmplification: Integer;
    function IMusic.GetLength = MusicGetLength;
    procedure IMusic.SetPos = MusicSetPos;
    function IMusic.GetPos = MusicGetPos;
    procedure SetInstrVolume(const Instr, Volume: Integer);
    function GetInstrVolume(const Instr: Integer): Integer;
    procedure SetChannelVolume(const Channel, Volume: Integer);
    function GetChannelVolume(const Channel: Integer): Integer;
  public
    destructor Destroy; override;
  end;

type
  TTarget = class(TInterfacedObject, ITarget, IInternalTarget)
  private
    FWidth: Integer;
    FHeight: Integer;
    FTex: ITexture;
    FDepth: IDirect3DSurface;
  protected
    { ITarget }
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetTex: ITexture;
    function GetTexture: ITexture;
    { IInternalTarget }
    function GetDepth: IDirect3DSurface;
    procedure Restore;
    procedure Lost;
  public
    constructor Create(const AWidth, AHeight: Integer; const ATex: ITexture;
      const ADepth: IDirect3DSurface);
    destructor Destroy; override;
  end;

type
  TStream = class(TChannel, IStream, IInternalStream, IChannel)
  private
    FData: IResource;
  protected
    { IStream }
    function Play(const Loop: Boolean; const Volume: Integer = 100): IChannel;
    { IInternalStream }
    function GetData: IResource;
  public
    constructor Create(const AHandle: HStream; const AData: IResource);
    destructor Destroy; override;
  end;

  {TSysFont}

constructor TSysFont.Create;
begin
  inherited;
  FTheFont := nil;
  FCanvas := nil;
  FHGE := HGECreate(HGE_VERSION);
{$IFDEF DX9}
  //D3DXCreateSprite(THGEImpl(FHGE).FD3DDevice, FTextSprite);
  D3DXCreateSprite(PHGE.FD3DDevice, FTextSprite);
{$ENDIF}
end;

procedure TSysFont.Init;
begin
  if FCanvas = nil then begin
    FCanvas := TCanvas.Create;
    FCanvas.Handle := GetWindowDC(PHGE.System_GetState(HGE_HWND));
  end;

  FTheFont := TFont.Create;
  FTheFont.Name := FName;
  FTheFont.Size := FSize;
  FTheFont.Style := FStyle;

{$IFDEF DX8}
  D3DXCreateFont(PHGE.FD3DDevice, FTheFont.Handle, FFont);
{$ELSE}
  D3DXCreateFont(PHGE.FD3DDevice,
    12,
    0, FW_DONTCARE {FW_BOLD}, 1, False, DEFAULT_CHARSET,
    OUT_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE,
    PChar(FName), FFont);
{$ENDIF}
end;

procedure TSysFont.UnInit;
begin
  if Assigned(FFont) then FFont := nil;
end;

function TSysFont.CreateFont(FontName: string; Size: Integer; Style: TFontStyles): Boolean;
begin
  FName := FontName;
  FSize := Size;
  FStyle := Style;
  FRed := 255;
  FGreen := 255;
  FBlue := 255;
  FAlpha := 255;
  Result := True;
  UnInit;
  Init;
end;

function TSysFont.CreateFont(const Font: TFont): Boolean;
begin
  if not Assigned(Font) then
    raise Exception.Create('CreateFont() had unassigned Font param.');
  Result := CreateFont(Font.Name, Font.Size, Font.Style);
end;

procedure TSysFont.SetColor(const Value: Cardinal);
begin
  FColor := Value;
  Red := SetR(FColor, FRed);
  Blue := SetB(FColor, FBlue);
  Green := SetG(FColor, FGreen);
  Alpha := SetA(FColor, FAlpha);
end;

procedure TSysFont.BeginFont;
begin
  if not Assigned(FFont) then Exit;
{$IFDEF DX8}
  FFont._Begin;
{$ELSE}
  if FTextSprite <> nil then begin
    FTextSprite._Begin(D3DXSPRITE_ALPHABLEND or D3DXSPRITE_SORT_TEXTURE or D3DXSPRITE_DONOTMODIFY_RENDERSTATE {D3DXSPRITE_DONOTSAVESTATE});
  end;
{$ENDIF}
end;

procedure TSysFont.EndFont;
begin
  if not Assigned(FFont) then Exit;
{$IFDEF DX8}
  FFont._End;
{$ELSE}
  if FTextSprite <> nil then
    FTextSprite._End;
{$ENDIF}
end;

procedure TSysFont.Print(XPos, YPos: Integer; sString: string; R, G, B, A: Byte);
var
  Rect              : TRect;
begin
  if not Assigned(FFont) then Exit;
  Rect.Left := XPos;
  Rect.Top := YPos;
  Rect.Bottom := 0;
  Rect.Right := 0;
{$IFDEF DX9}
  if Assigned(FTextSprite) then
    FFont.DrawTextA(FTextSprite, PChar(sString), -1, @Rect, DT_NOCLIP, D3dColor_RGBA(R, G, B, A));
{$ELSE}
  FFont.DrawTextA(PChar(sString), -1, Rect, DT_NOCLIP, D3dColor_RGBA(R, G, B, A));
{$ENDIF}
end;

procedure TSysFont.Print(XPos, YPos: Integer; sString: string);
begin
  Print(XPos, YPos, sString, FRed, FGreen, FBlue, FAlpha);
end;

procedure TSysFont.Print(Pos: TPoint; sString: string);
begin
  Print(Pos.X, Pos.Y, sString);
end;

procedure TSysFont.PrintInvert(XPos, YPos: Integer; sString: string);
begin
  Print(XPos, YPos, sString, (255 - FRed), (255 - FGreen), (255 - FBlue), FAlpha);
end;

destructor TSysFont.Destroy;
begin
  UnInit;
  if FTheFont <> nil then FTheFont.Free;
  if FCanvas <> nil then FCanvas.Free;
  inherited Destroy;
end;

function TSysFont.TextHeight(const Text: string): Integer;
begin
  FCanvas.Font := FTheFont;
  Result := FCanvas.TextHeight(Text);
end;

function TSysFont.TextWidth(const Text: string): Integer;
begin
  FCanvas.Font := FTheFont;
  Result := FCanvas.TextWidth(Text);
end;

{ TTexture }

constructor TTexture.Create(const AHandle: IDirect3DTexture;
  const AOriginalWidth, AOriginalHeight: Integer{$IFDEF DYNTEX}; boDynTex: Boolean{$ENDIF});
begin
  inherited Create;
  FHandle := AHandle;
  FOriginalWidth := AOriginalWidth;
  FOriginalHeight := AOriginalHeight;
  FTagID := 0;
{$IFDEF DYNTEX}
  FIsDynTex := boDynTex;
{$ENDIF}
end;

function TTexture.GetName: string;
begin
  Result := FName;
end;

procedure TTexture.SetName(Value: string);
begin
  FName := Value;
end;

function TTexture.GetPatternWidth: Integer;
begin
  if FPatternWidth = 0 then begin
    FPatternWidth := GetWidth(True);
  end;
  Result := FPatternWidth;
end;

procedure TTexture.SetPatternWidth(Value: Integer);
begin
  FPatternWidth := Value;
end;

function TTexture.GetPatternHeight: Integer;
begin
  if FPatternHeight = 0 then begin
    FPatternHeight := GetHeight(True);
  end;
  Result := FPatternHeight;
end;

procedure TTexture.SetPatternHeight(Value: Integer);
begin
  FPatternHeight := Value;
end;

function TTexture.GetTagID: Integer;
begin
  Result := FTagID;
end;

procedure TTexture.SetTagID(Value: Integer);
begin
  FTagID := Value;
end;

{$IFDEF DYNTEX}

function TTexture.GetIsDynTex: Boolean;
begin
  Result := FIsDynTex;
end;
{$ENDIF}

function TTexture.GetPatternCount: Integer;
var
  RowCount, ColCount: Integer;
begin
  ColCount := Self.GetWidth(True) div FPatternWidth;
  RowCount := Self.GetHeight(True) div FPatternHeight;
  if Self.FPatternCount < 0 then Self.FPatternCount := 0;
  //Make drawrect point to last rectangle if it is higher
  //if Self.FPatternCount > RowCount * ColCount then
  Result := RowCount * ColCount;
end;

function TTexture.GetHandle: IDirect3DTexture;
begin
  Result := FHandle;
end;

function TTexture.GetHeight(const Original: Boolean): Integer;
var
  Desc              : TD3DSurfaceDesc;
begin
  if FHandle = nil then begin
    Result := FOriginalHeight;
    Exit;
  end;
  if (Original) then
    Result := FOriginalHeight
  else if (Succeeded(FHandle.GetLevelDesc(0, Desc))) then begin
    Result := Desc.Height;
    if Result = 0 then begin
      Result := FOriginalHeight;
    end;
  end else
    Result := FOriginalHeight; //0;
end;

function TTexture.GetWidth(const Original: Boolean): Integer;
var
  Desc              : TD3DSurfaceDesc;
begin
  if FHandle = nil then begin
    Result := FOriginalWidth;
    Exit;
  end;
  if (Original) then
    Result := FOriginalWidth
  else if (Succeeded(FHandle.GetLevelDesc(0, Desc))) then begin
    Result := Desc.Width;
    if Result = 0 then
      Result := FOriginalWidth;
  end else
    Result := FOriginalWidth; //0;
end;

function TTexture.Lock(const ReadOnly: Boolean; const Left, Top, Width,
  Height: Integer): PLongword;
var
  Desc              : TD3DSurfaceDesc;
  Rect              : TD3DLockedRect;
  Region            : TRect;
  PRec              : PRect;
  Flags             : Integer;
begin
  Result := nil;
  FHandle.GetLevelDesc(0, Desc);
  if (Desc.Format <> D3DFMT_A8R8G8B8) and (Desc.Format <> D3DFMT_X8R8G8B8) and
    (Desc.Format <> D3DFMT_A1R5G5B5) and (Desc.Format <> D3DFMT_X1R5G5B5) then
    Exit;

  if (Width <> 0) and (Height <> 0) then begin
    Region.Left := Left;
    Region.Top := Top;
    Region.Right := Left + Width;
    Region.Bottom := Top + Height;
    PRec := @Region;
  end else
    PRec := nil;

  if (ReadOnly) then
    Flags := D3DLOCK_READONLY
  else
    Flags := 0;

  if (Failed(FHandle.LockRect(0, Rect, PRec, Flags))) then
    PHGE.PostError('Can''t lock texture')
  else
    Result := Rect.pBits;
end;

function TTexture.Lock(out Rect: TD3DLockedRect; const ReadOnly: Boolean = True; const Left: Integer = 0;
  const Top: Integer = 0; const Width: Integer = 0;
  const Height: Integer = 0): PLongword;
var
  Desc              : TD3DSurfaceDesc;
  //Rect                      : TD3DLockedRect;
  Region            : TRect;
  PRec              : PRect;
  Flags             : Integer;
begin
  Result := nil;
  FHandle.GetLevelDesc(0, Desc);
  if (Desc.Format <> D3DFMT_A8R8G8B8) and (Desc.Format <> D3DFMT_X8R8G8B8) and
    (Desc.Format <> D3DFMT_A1R5G5B5) and (Desc.Format <> D3DFMT_X1R5G5B5) then
    Exit;

  if (Width <> 0) and (Height <> 0) then begin
    Region.Left := Left;
    Region.Top := Top;
    Region.Right := Left + Width;
    Region.Bottom := Top + Height;
    PRec := @Region;
  end else
    PRec := nil;

  if (ReadOnly) then
    Flags := D3DLOCK_READONLY
  else
    Flags := 0;

  if (Failed(FHandle.LockRect(0, Rect, PRec, Flags))) then
    PHGE.PostError('Can''t lock texture')
  else
    Result := Rect.pBits;
end;

procedure TTexture.SetHandle(const Value: IDirect3DTexture);
begin
  FHandle := Value;
end;

procedure TTexture.Unlock;
begin
  FHandle.UnlockRect(0);
end;

function TTexture.GetPixel(X, Y: Integer): LongInt;
var
  Region            : TRect;
  PRec              : PRect;
  Flags             : Integer;
  Desc              : TD3DSurfaceDesc;
  Rect              : TD3DLockedRect;
  c                 : DWORD;
begin
  Result := 0;
  if Succeeded(FHandle.GetLevelDesc(0, Desc)) then begin
    if (X >= 0) and (X < Desc.Width) and (Y >= 0) and (Y < Desc.Height) then begin
      if (Desc.Format = D3DFMT_A8R8G8B8) or (Desc.Format = D3DFMT_X8R8G8B8) then begin
        PRec := nil;
        Flags := 0;
        if Succeeded(FHandle.LockRect(0, Rect, PRec, Flags)) then begin
          try
            Result := PLongint(LongInt(Rect.pBits) + Y * Rect.Pitch + X * 4)^;
          finally
            Unlock;
          end;
        end;
      end else if (Desc.Format = D3DFMT_A1R5G5B5) or (Desc.Format = D3DFMT_X1R5G5B5) then begin
        PRec := nil;
        Flags := 0;
        if Succeeded(FHandle.LockRect(0, Rect, PRec, Flags)) then begin
          try
            Result := PWord(LongInt(Rect.pBits) + Y * Rect.Pitch + X * 2)^;
          finally
            Unlock;
          end;
        end;
      end;
    end;
  end;
end;

procedure TTexture.SetPixel(X, Y: Integer; Value: LongInt);
var
  Region            : TRect;
  PRec              : PRect;
  Flags             : Integer;
  Desc              : TD3DSurfaceDesc;
  Rect              : TD3DLockedRect;
  c                 : DWORD;
begin
  if Succeeded(FHandle.GetLevelDesc(0, Desc)) then begin
    if (X >= 0) and (X < Desc.Width) and (Y >= 0) and (Y < Desc.Height) then begin
      PRec := nil;
      Flags := 0;
      if (Desc.Format = D3DFMT_A8R8G8B8) or (Desc.Format = D3DFMT_X8R8G8B8) then begin
        if Succeeded(FHandle.LockRect(0, Rect, PRec, Flags)) then begin
          try
            PLongint(LongInt(Rect.pBits) + Y * Rect.Pitch + X * 4)^ := Value;
          finally
            Unlock;
          end;
        end;
      end else if (Desc.Format = D3DFMT_A1R5G5B5) or (Desc.Format = D3DFMT_X1R5G5B5) then begin
        if Succeeded(FHandle.LockRect(0, Rect, PRec, Flags)) then begin
          try
            PWord(LongInt(Rect.pBits) + Y * Rect.Pitch + X * 2)^ := Value;
          finally
            Unlock;
          end;
        end;
      end;
    end;
  end;
end;

{ TChannel }

constructor TChannel.Create(const AHandle: HChannel);
begin
  inherited Create;
  FHandle := AHandle;
end;

destructor TChannel.Destroy;
begin
  FHandle := 0;
  inherited;
end;

function TChannel.GetHandle: HChannel;
begin
  Result := FHandle;
end;

function TChannel.GetLength: Single;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_ChannelBytes2Seconds(FHandle, BASS_ChannelGetLength(FHandle{$IF BASSVERSION = $204}, 0{$IFEND}))
  else
    Result := -1;
end;

function TChannel.GetPos: Single;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_ChannelBytes2Seconds(FHandle, BASS_ChannelGetPosition(FHandle{$IF BASSVERSION = $204}, 0{$IFEND}))
  else
    Result := -1;
end;

function TChannel.IsPlaying: Boolean;
begin
  if (PHGE.FBass <> 0) then
    Result := (BASS_ChannelIsActive(FHandle) = BASS_ACTIVE_PLAYING)
  else
    Result := False;
end;

function TChannel.IsSliding: Boolean;
begin
  if (PHGE.FBass <> 0) then
{$IF BASSVERSION = $204}
    Result := BASS_ChannelIsSliding(FHandle, 0)
{$ELSE}
    Result := (BASS_ChannelIsSliding(FHandle) <> 0)
{$IFEND}
  else
    Result := False;
end;

procedure TChannel.Pause;
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelPause(FHandle);
end;

procedure TChannel.Resume;
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelPlay(FHandle, False);
end;

procedure TChannel.SetHandle(const Value: HChannel);
begin
  FHandle := Value;
end;

procedure TChannel.SetPanning(const Pan: Integer);
begin
  if (PHGE.FBass <> 0) then begin
    BASS_ChannelSetAttributes(FHandle, -1, -1, Pan);
  end;
end;

procedure TChannel.SetPitch(const Pitch: Single);
var
  Info              : BASS_CHANNELINFO;
begin
  if (PHGE.FBass <> 0) then begin
    BASS_ChannelGetInfo(FHandle, Info);
    BASS_ChannelSetAttributes(FHandle, Trunc(Pitch * Info.freq), -1, -101);
  end;
end;

procedure TChannel.SetPos(const Seconds: Single);
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelSetPosition(FHandle, BASS_ChannelSeconds2Bytes(FHandle, Seconds));
end;

procedure TChannel.SetVolume(const Volume: Integer);
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelSetAttributes(FHandle, -1, Volume, -101);
end;

procedure TChannel.SlideTo(const Time: Single; const Volume, Pan: Integer;
  const Pitch: Single);
var
  freq              : Integer;
  Info              : BASS_CHANNELINFO;
begin
  if (PHGE.FBass <> 0) then begin
    BASS_ChannelGetInfo(FHandle, Info);
    if (Pitch = -1) then
      freq := -1
    else
      freq := Trunc(Pitch * Info.freq);
    BASS_ChannelSlideAttributes(FHandle, freq, Volume, Pan, Trunc(Time * 1000));
  end;
end;

procedure TChannel.Stop;
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelStop(FHandle);
end;

{ TEffect }

constructor TEffect.Create(const AHandle: HSample);
begin
  inherited Create;
  FHandle := AHandle;
  FChannel := TChannel.Create(0);
end;

destructor TEffect.Destroy;
begin
  if (PHGE.FBass <> 0) then
    BASS_SampleFree(FHandle);
  FHandle := 0;
  inherited;
end;

function TEffect.GetHandle: HSample;
begin
  Result := FHandle;
end;

function TEffect.Play: IChannel;
begin
  if (PHGE.FBass <> 0) then begin
    FChannel.SetHandle(BASS_SampleGetChannel(FHandle, False));
    BASS_ChannelPlay(FChannel.Handle, True);
    Result := FChannel;
  end else
    Result := nil;
end;

function TEffect.PlayEx(const Volume, Pan: Integer; const Pitch: Single;
  const Loop: Boolean): IChannel;
var
  Info              : BASS_SAMPLE;
  HC                : HChannel;
begin
  if (PHGE.FBass <> 0) then begin
    BASS_SampleGetInfo(FHandle, Info);
    HC := BASS_SampleGetChannel(FHandle, False);
    FChannel.SetHandle(HC);
    BASS_ChannelSetAttributes(HC, Trunc(Pitch * Info.freq), Volume, Pan);
    Info.Flags := Info.Flags and (not BASS_SAMPLE_LOOP);
    if (Loop) then
      Info.Flags := Info.Flags or BASS_SAMPLE_LOOP;
    BASS_ChannelSetFlags(HC, Info.Flags);
    BASS_ChannelPlay(HC, True);
    Result := FChannel;
  end else
    Result := nil;
end;

{ TMusic }

destructor TMusic.Destroy;
begin
  if (PHGE.FBass <> 0) then
    BASS_MusicFree(FHandle);
  inherited;
end;

function TMusic.GetAmplification: Integer;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_MusicGetAttribute(FHandle, BASS_MUSIC_ATTRIB_AMPLIFY)
  else
    Result := -1;
end;

function TMusic.GetChannelVolume(const Channel: Integer): Integer;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_MusicGetAttribute(FHandle, BASS_MUSIC_ATTRIB_VOL_CHAN + Channel)
  else
    Result := -1;
end;

function TMusic.GetInstrVolume(const Instr: Integer): Integer;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_MusicGetAttribute(FHandle, BASS_MUSIC_ATTRIB_VOL_INST + Instr)
  else
    Result := -1;
end;

function TMusic.MusicGetLength: Integer;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_MusicGetOrders(FHandle)
  else
    Result := -1;
end;

function TMusic.MusicGetPos(out Order, Row: Integer): Boolean;
var
  Pos               : Integer;
begin
  Result := False;
  if (PHGE.FBass <> 0) then begin
    Pos := BASS_MusicGetOrderPosition(FHandle);
    if (Pos <> -1) then begin
      Order := LOWORD(Pos);
      Row := HIWORD(Pos);
      Result := True;
    end;
  end;
end;

procedure TMusic.MusicSetPos(const Order, Row: Integer);
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelSetPosition(FHandle, MAKEMUSICPOS(Order, Row));
end;

function TMusic.Play(const Loop: Boolean; const Volume: Integer = 100;
  const Order: Integer = -1; const Row: Integer = -1): IChannel;
var
  Info              : BASS_CHANNELINFO;
  Pos, O, R         : Integer;
begin
  if (PHGE.FBass <> 0) then begin
    Pos := BASS_MusicGetOrderPosition(FHandle);
    if (Order = -1) then
      O := LOWORD(Pos)
    else
      O := Order;
    if (Row = -1) then
      R := HIWORD(Pos)
    else
      R := Row;
    BASS_ChannelSetPosition(FHandle, MAKEMUSICPOS(O, R));

    BASS_ChannelGetInfo(FHandle, Info);
    BASS_ChannelSetAttributes(FHandle, Info.freq, Volume, 0);

    Info.Flags := Info.Flags and (not BASS_SAMPLE_LOOP);
    if (Loop) then
      Info.Flags := Info.Flags or BASS_SAMPLE_LOOP;

    BASS_ChannelSetFlags(FHandle, Info.Flags);
    BASS_ChannelPlay(FHandle, False);
    Result := Self;
  end else
    Result := nil;
end;

procedure TMusic.SetChannelVolume(const Channel, Volume: Integer);
begin
  if (PHGE.FBass <> 0) then
    BASS_MusicSetAttribute(FHandle, BASS_MUSIC_ATTRIB_VOL_CHAN + Channel, Volume);
end;

procedure TMusic.SetInstrVolume(const Instr, Volume: Integer);
begin
  if (PHGE.FBass <> 0) then
    BASS_MusicSetAttribute(FHandle, BASS_MUSIC_ATTRIB_VOL_INST + Instr, Volume);
end;

{ TTarget }

constructor TTarget.Create(const AWidth, AHeight: Integer; const ATex: ITexture;
  const ADepth: IDirect3DSurface);
begin
  inherited Create;
  FWidth := AWidth;
  FHeight := AHeight;
  FTex := ATex;
  FDepth := ADepth;
  PHGE.FTargets.Add(Self);
end;

destructor TTarget.Destroy;
begin
  PHGE.FTargets.Remove(Self);
  inherited;
end;

function TTarget.GetDepth: IDirect3DSurface;
begin
  Result := FDepth;
end;

function TTarget.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TTarget.GetTex: ITexture;
begin
  Result := FTex;
end;

function TTarget.GetTexture: ITexture;
begin
  Result := FTex;
end;

function TTarget.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TTarget.Lost;
var
  DXTexture         : IDirect3DTexture;
begin
  if Assigned(FTex) then begin
    D3DXCreateTexture(PHGE.FD3DDevice, FWidth, FHeight, 1,
      D3DUSAGE_RENDERTARGET, PHGE.FD3DPP.BackBufferFormat, D3DPOOL_DEFAULT,
      DXTexture);
    FTex.Handle := DXTexture;
  end;
  if Assigned(FDepth) then
    PHGE.FD3DDevice.CreateDepthStencilSurface(FWidth, FHeight,
      D3DFMT_D16, D3DMULTISAMPLE_NONE, {$IFDEF DX8}FDepth{$ELSE}0, False, FDepth, nil{$ENDIF});
end;

procedure TTarget.Restore;
begin
  FTex.Handle := nil;
{$IFDEF DYNTEX}
  //if FTex.IsDynTex then
  //  FTex := nil;                          //1234
{$ENDIF}
  FDepth := nil;
end;

{ TStream }

constructor TStream.Create(const AHandle: HStream; const AData: IResource);
begin
  inherited Create(AHandle);
  FData := AData;
end;

destructor TStream.Destroy;
begin
  if (PHGE.FBass <> 0) then
    BASS_StreamFree(FHandle);
  inherited;
end;

function TStream.GetData: IResource;
begin
  Result := FData;
end;

function TStream.Play(const Loop: Boolean; const Volume: Integer): IChannel;
var
  Info              : BASS_CHANNELINFO;
begin
  if (PHGE.FBass <> 0) then begin
    BASS_ChannelGetInfo(FHandle, Info);
    BASS_ChannelSetAttributes(FHandle, Info.freq, Volume, 0);
    Info.Flags := Info.Flags and (not BASS_SAMPLE_LOOP);
    if (Loop) then
      Info.Flags := Info.Flags or BASS_SAMPLE_LOOP;
    BASS_ChannelSetFlags(FHandle, Info.Flags);
    BASS_ChannelPlay(FHandle, True);
    Result := Self;
  end else
    Result := nil;
end;

{ TResource }

constructor TResource.Create(const AHandle: Pointer; const ASize: Longword);
begin
  inherited Create;
  FHandle := AHandle;
  FSize := ASize;
end;

destructor TResource.Destroy;
begin
  FreeMem(FHandle);
  inherited;
end;

function TResource.GetHandle: Pointer;
begin
  Result := FHandle;
end;

function TResource.GetSize: Longword;
begin
  Result := FSize;
end;

(****************************************************************************
 * System.cpp, Graphics.cpp, Random.cpp, Sound.cpp, Timer.cpp, Input.cpp,
 * Resource.cpp
 ****************************************************************************)

const
  KeyNames          : array[0..255] of string = (
    '?',
    'Left Mouse Button', 'Right Mouse Button', '?', 'Middle Mouse Button',
    '?', '?', '?', 'Backspace', 'Tab', '?', '?', '?', 'Enter', '?', '?',
    'Shift', 'Ctrl', 'Alt', 'Pause', 'Caps Lock', '?', '?', '?', '?', '?', '?',
    'Escape', '?', '?', '?', '?',
    'Space', 'Page Up', 'Page Down', 'End', 'Home',
    'Left Arrow', 'Up Arrow', 'Right Arrow', 'Down Arrow',
    '?', '?', '?', '?', 'Insert', 'Delete', '?',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '?', '?', '?', '?', '?', '?', '?',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'Left Win', 'Right Win', 'Application', '?', '?',
    'NumPad 0', 'NumPad 1', 'NumPad 2', 'NumPad 3', 'NumPad 4',
    'NumPad 5', 'NumPad 6', 'NumPad 7', 'NumPad 8', 'NumPad 9',
    'Multiply', 'Add', '?', 'Subtract', 'Decimal', 'Divide',
    'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    'Num Lock', 'Scroll Lock',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    'Semicolon', 'Equals', 'Comma', 'Minus', 'Period', 'Slash', 'Grave',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?',
    'Left bracket', 'Backslash', 'Right bracket', 'Apostrophe',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?');

var
  GSeed             : Longword = 0;

function LoWordInt(const N: Longword): Integer;
inline;
begin
  Result := Smallint(LOWORD(N));
end;

function HiWordInt(const N: Longword): Integer;
inline;
begin
  Result := Smallint(HIWORD(N));
end;

const
  WINDOW_CLASS_NAME = 'HGE__WNDCLASS';

function WindowProc(HWindow: hWnd; Msg, wParam, lParam: LongInt): LongInt; stdcall;
var
  bActivating       : Boolean;
  W, H              : Integer;
  p                 : WINDOWPLACEMENT;
begin
  case Msg of
    WM_CREATE: begin
        Result := 0;
        Exit;
      end;
    {WM_PAINT: begin
        if Assigned(PHGE.FProcFrameFunc) then
          PHGE.FProcFrameFunc;
        if Assigned(PHGE.FProcRenderFunc) then
          PHGE.FProcRenderFunc;

        //if Assigned(PHGE.FProcFrameFunc) then
        //  PHGE.FProcFrameFunc;
      end;}
    WM_PAINT: if Assigned(PHGE.FD3D) and Assigned(PHGE.FProcRenderFunc) {and PHGE.FWindowed} then begin
        with PHGE do begin
          if (FActive or FDontSuspend) then begin
            //repeat
            FDT := timeGetTime - FT0;
            //until (FDT >= 1);

            if (FDT >= FFixedDelta) then begin
              FDeltaTime := FDT / 1000.0;

              if (FDeltaTime > 0.2) then begin
                if (FFixedDelta <> 0) then
                  FDeltaTime := FFixedDelta / 1000.0
                else
                  FDeltaTime := 0.01;
              end;
              FTime := FTime + FDeltaTime;

              FT0 := timeGetTime;
              if (FT0 - FT0FPS <= 1000) then
                Inc(FCFPS)
              else begin
                FFPS := FCFPS;
                FCFPS := 0;
                FT0FPS := FT0;
              end;

              try
                if Assigned(FProcFrameFunc) then
                  FProcFrameFunc;

                if Assigned(FProcRenderFunc) then
                  FProcRenderFunc;
              except
                on E: Exception do
                  System_Log(E.Message);
              end;
            end else begin
              if (FFixedDelta <> 0) then begin
                if Assigned(FProcImgCacheFunc) and (FDT + 1 < FFixedDelta) then
                //if Assigned(FProcImgCacheFunc) then begin
                  FProcImgCacheFunc;
                Sleep(1);
                Result := 0;
                Exit;
              end;
            end;
          end else begin
            Sleep(1);
            Result := 0;
            Exit;
          end;
        end;
      end;
    WM_DESTROY: begin
        PostQuitMessage(0);
        Result := 0;
        Exit;
      end;
    WM_ACTIVATEAPP: begin //1234
        if Assigned(PHGE.FD3D) and (PHGE.FActive <> (wParam = 1)) then
          PHGE.FocusChange(wParam = 1);
        Result := 0;
        Exit;
      end;
    {WM_ACTIVATE: begin
        // tricky: we should catch WA_ACTIVE and WA_CLICKACTIVE,
        // but only if HIWORD(wParam) (fMinimized) == FALSE (0)
        bActivating := (LOWORD(wParam) <> WA_INACTIVE) and (HIWORD(wParam) = 0);
        if Assigned(PHGE.FD3D) and (PHGE.FActive <> bActivating) then
          PHGE.FocusChange(bActivating);
        Result := 0;
        Exit;
      end;}
    WM_SETCURSOR: begin
        if (PHGE.FActive or (PHGE.FWndParent <> 0)) and (LOWORD(lParam) = HTCLIENT) and (PHGE.FHideMouse) then
          SetCursor(0)
        else if LOWORD(lParam) = HTCLIENT then
          SetCursor(Screen.cursors[Screen.Cursor])
        else begin
          case LOWORD(lParam) of
            HTLEFT, HTRIGHT: SetCursor(LoadCursor(0, IDC_SIZEWE));
            HTTOP, HTBOTTOM: SetCursor(LoadCursor(0, IDC_SIZENS));
            HTTOPLEFT, HTBOTTOMRIGHT: SetCursor(LoadCursor(0, IDC_SIZENWSE));
            HTTOPRIGHT, HTBOTTOMLEFT: SetCursor(LoadCursor(0, IDC_SIZENESW));
          else
            SetCursor(LoadCursor(0, IDC_ARROW));
          end;
        end;
        Result := 0;
        Exit;
      end;
    WM_IME_CHAR: begin
        PHGE.BuildEvent(INPUT_IME_CHAR, wParam, 0, 0, 0, 0);
        Result := 0;
        Exit;
      end;

    WM_CHAR: begin
        PHGE.BuildEvent(INPUT_CHAR, wParam, 0, 0, 0, 0);
        Result := 0;
        Exit;
      end;

    WM_SYSKEYDOWN: begin
        if (wParam = VK_F4) then begin
          if Assigned(PHGE.FProcExitFunc) then begin
            if (PHGE.FProcExitFunc) then
              Result := DefWindowProc(HWindow, Msg, wParam, lParam)
            else
              Result := 0;
          end else
            Result := DefWindowProc(HWindow, Msg, wParam, lParam);
          //end else if (wParam = VK_RETURN) then begin
          //  PHGE.System_SetState(HGE_WINDOWED, not PHGE.System_GetState(HGE_WINDOWED));
          //  Result := 0;
        end else begin
          if ((lParam and $4000000) <> 0) then
            PHGE.BuildEvent(INPUT_KEYDOWN, wParam, HIWORD(lParam) and $FF, HGEINP_REPEAT, -1, -1)
          else
            PHGE.BuildEvent(INPUT_KEYDOWN, wParam, HIWORD(lParam) and $FF, 0, -1, -1);
          Result := 0;
        end;
        Exit;
      end;
    WM_KEYDOWN: begin
        if ((lParam and $4000000) <> 0) then
          PHGE.BuildEvent(INPUT_KEYDOWN, wParam, HIWORD(lParam) and $FF, HGEINP_REPEAT, -1, -1)
        else
          PHGE.BuildEvent(INPUT_KEYDOWN, wParam, HIWORD(lParam) and $FF, 0, -1, -1);
        Result := 0;
        Exit;
      end;
    WM_SYSKEYUP: begin
        PHGE.BuildEvent(INPUT_KEYUP, wParam, HIWORD(lParam) and $FF, 0, -1, -1);
        Result := 0;
        Exit;
      end;
    WM_KEYUP: begin
        PHGE.BuildEvent(INPUT_KEYUP, wParam, HIWORD(lParam) and $FF, 0, -1, -1);
        Result := 0;
        Exit;
      end;
    WM_LBUTTONDOWN: begin
        SetFocus(HWindow);
        PHGE.BuildEvent(INPUT_MBUTTONDOWN, HGEK_LBUTTON, 0, 0, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_MBUTTONDOWN: begin
        SetFocus(HWindow);
        PHGE.BuildEvent(INPUT_MBUTTONDOWN, HGEK_MBUTTON, 0, 0, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_RBUTTONDOWN: begin
        SetFocus(HWindow);
        PHGE.BuildEvent(INPUT_MBUTTONDOWN, HGEK_RBUTTON, 0, 0, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_LBUTTONDBLCLK: begin
        PHGE.BuildEvent(INPUT_MBUTTONDOWN, HGEK_LBUTTON, 0, HGEINP_REPEAT, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_MBUTTONDBLCLK: begin
        PHGE.BuildEvent(INPUT_MBUTTONDOWN, HGEK_MBUTTON, 0, HGEINP_REPEAT, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_RBUTTONDBLCLK: begin
        PHGE.BuildEvent(INPUT_MBUTTONDOWN, HGEK_RBUTTON, 0, HGEINP_REPEAT, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_LBUTTONUP: begin
        PHGE.BuildEvent(INPUT_MBUTTONUP, HGEK_LBUTTON, 0, 0, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_MBUTTONUP: begin
        PHGE.BuildEvent(INPUT_MBUTTONUP, HGEK_MBUTTON, 0, 0, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_RBUTTONUP: begin
        PHGE.BuildEvent(INPUT_MBUTTONUP, HGEK_RBUTTON, 0, 0, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_MOUSEMOVE: begin
        PHGE.BuildEvent(INPUT_MOUSEMOVE, 0, 0, 0, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_MOUSEWHEEL: begin
        PHGE.BuildEvent(INPUT_MOUSEWHEEL, Smallint(HIWORD(wParam)) div 120, 0, 0, LoWordInt(lParam), HiWordInt(lParam));
        Result := 0;
        Exit;
      end;
    WM_SIZE: begin
        if Assigned(PHGE.FD3D) and (wParam = SIZE_RESTORED) then
          PHGE.Resize(LOWORD(lParam), HIWORD(lParam));
        {if (wParam = SIZE_RESTORED) or (wParam = SIZE_MAXIMIZED) then
          PHGE.Resize(LOWORD(lParam), HIWORD(lParam));
        if wParam < 3 then PHGE.FWindowState := wParam;}
      end;
    {WM_GETMINMAXINFO: begin
        PMinMaxInfo(lParam).ptMinTrackSize.X := 320;
        PMinMaxInfo(lParam).ptMinTrackSize.Y := 240;
      end;
    WM_WINDOWPOSCHANGING: begin
        if (g_ClientWidth <> PHGE.FD3DPPW.BackBufferWidth) or (g_ClientHeight <> PHGE.FD3DPPW.BackBufferHeight) then begin
          //if PWINDOWPOS(lParam)^.X < 0 then PWINDOWPOS(lParam)^.X := 0;  //1111
          //if PWINDOWPOS(lParam)^.Y < 0 then PWINDOWPOS(lParam)^.Y := 0;
        end;
      end;}
    WM_SYSCOMMAND: begin
        if (wParam = SC_CLOSE) then begin
          if Assigned(PHGE.FProcExitFunc) then begin
            if (PHGE.FProcExitFunc) then begin
              PHGE.FActive := False;
              Result := DefWindowProc(HWindow, Msg, wParam, lParam);
              Exit;
            end else begin
              Result := 0;
              Exit;
            end;
          end else begin
            PHGE.FActive := False;
            Result := DefWindowProc(HWindow, Msg, wParam, lParam);
            Exit;
          end;
          {end else if (wParam = ID_SYSMENU_DEFRATE) and PHGE.FWindowed then begin //恢复默认分辨率，前提是窗口模式
            GetWindowPlacement(HWindow, @p);
            if PHGE.System_GetState(HGE_NOBORDER) then begin
              W := SCREENWIDTH;
              H := SCREENHEIGHT;
            end else begin
              W := SCREENWIDTH + GetSystemMetrics(SM_CXSIZEFRAME) * 2;
              H := SCREENHEIGHT + GetSystemMetrics(SM_CYSIZEFRAME) * 2 + GetSystemMetrics(SM_CYCAPTION);
            end;
            SetWindowPos(HWindow, 0, (GetSystemMetrics(SM_CXSCREEN) - W) div 2, (GetSystemMetrics(SM_CYSCREEN) - H) div 2, W, H, SWP_NOZORDER + SWP_NOACTIVATE);
          end else if wParam = SC_MINIMIZE then begin
            Result := DefWindowProc(HWindow, Msg, wParam, lParam);
            PHGE.FActive := False;        //1111
            Exit;}
        end else if wParam = SC_RESTORE then begin
          PHGE.FActive := True;
          Result := DefWindowProc(HWindow, Msg, wParam, lParam);
          Exit;
        end;
        //else if Assigned(PHGE.FSystemCommandFunc) then
        //  PHGE.FSystemCommandFunc(HWindow, wParam, lParam); //添加一个入口
      end;
  end;
  Result := DefWindowProc(HWindow, Msg, wParam, lParam);
end;

function HGECreate(const Ver: Integer): IHGE;
begin
  if (Ver = HGE_VERSION) then
    Result := THGEImpl.InterfaceGet
  else
    Result := nil;
end;

{ THGEImpl }

procedure THGEImpl.AdjustWindow;
var
  Rc                : PRect;
  Style             : Longword;
begin
  if (FWindowed) then begin
    Rc := @FRectW;
    Style := FStyleW;
  end else begin
    Rc := @FRectFS;
    Style := FStyleFS;
  end;
  SetWindowLong(FWnd, GWL_STYLE, Style);

  Style := GetWindowLong(FWnd, GWL_EXSTYLE);
  if (FWindowed) then begin
    SetWindowLong(FWnd, GWL_EXSTYLE, Style and (not WS_EX_TOPMOST));
    SetWindowPos(FWnd, HWND_NOTOPMOST {HWND_TOP}, Rc.Left, Rc.Top,
      Rc.Right - Rc.Left, Rc.Bottom - Rc.Top, SWP_FRAMECHANGED);
    //Resize(g_ClientWidth, g_ClientWidth);
  end else begin
    SetWindowLong(FWnd, GWL_EXSTYLE, Style or WS_EX_TOPMOST);
    SetWindowPos(FWnd, HWND_TOPMOST, Rc.Left, Rc.Top,
      Rc.Right - Rc.Left, Rc.Bottom - Rc.Top, SWP_FRAMECHANGED);
    Resize(FD3DPPW.BackBufferWidth, FD3DPPW.BackBufferHeight);
  end;
end;

procedure THGEImpl.BuildEvent(EventType, Key, Scan, Flags, X, Y: Integer);
var
  Last, EPtr        : PInputEventList;
  KBState           : TKeyboardState;
  Pt                : TPoint;
begin
  New(EPtr);
  EPtr.Event.EventType := EventType;
  EPtr.Event.Chr := 0;
  Pt.X := X;
  Pt.Y := Y;

  GetKeyboardState(KBState);

  if (EventType = HGE.INPUT_KEYDOWN) then begin
    if ((Flags and HGEINP_REPEAT) = 0) then
      FKeyz[Key] := FKeyz[Key] or 1;
    ToAscii(Key, Scan, KBState, @EPtr.Event.Chr, 0);
  end;

  if (EventType = HGE.INPUT_KEYUP) then begin
    FKeyz[Key] := FKeyz[Key] or 2;
    ToAscii(Key, Scan, KBState, @EPtr.Event.Chr, 0);
  end;

  if (EventType = INPUT_MOUSEWHEEL) then begin
    EPtr.Event.Key := 0;
    EPtr.Event.Wheel := Key;
    ScreenToClient(FWnd, Pt);
  end else begin
    EPtr.Event.Key := Key;
    EPtr.Event.Wheel := 0;
  end;

  if (EventType = INPUT_MBUTTONDOWN) then begin
    FKeyz[Key] := FKeyz[Key] or 1;
    SetCapture(FWnd);
    //FCaptured := True;
  end;
  if (EventType = INPUT_MBUTTONUP) then begin
    FKeyz[Key] := FKeyz[Key] or 2;
    ReleaseCapture;
    Input_SetMousePos(FXPos, FYPos);
    Pt.X := Trunc(FXPos);
    Pt.Y := Trunc(FYPos);
    FCaptured := False;
  end;

  if ((KBState[VK_SHIFT] and $80) <> 0) then
    Flags := Flags or HGEINP_SHIFT;
  if ((KBState[VK_CONTROL] and $80) <> 0) then
    Flags := Flags or HGEINP_CTRL;
  if ((KBState[VK_MENU] and $80) <> 0) then
    Flags := Flags or HGEINP_ALT;
  if ((KBState[VK_CAPITAL] and $1) <> 0) then
    Flags := Flags or HGEINP_CAPSLOCK;
  if ((KBState[VK_SCROLL] and $1) <> 0) then
    Flags := Flags or HGEINP_SCROLLLOCK;
  if ((KBState[VK_NUMLOCK] and $1) <> 0) then
    Flags := Flags or HGEINP_NUMLOCK;

  EPtr.Event.Flags := Flags;

  if (Pt.X = -1) then begin
    EPtr.Event.X := FXPos;
    EPtr.Event.Y := FYPos;
  end else begin
    if (Pt.X < 0) then
      Pt.X := 0;
    if (Pt.Y < 0) then
      Pt.Y := 0;
    if (Pt.X >= FScreenWidth) then
      Pt.X := FScreenWidth - 1;
    if (Pt.Y >= FScreenHeight) then
      Pt.Y := FScreenHeight - 1;

    EPtr.Event.X := Pt.X;
    EPtr.Event.Y := Pt.Y;
  end;

  EPtr.Next := nil;

  if (FQueue = nil) then
    FQueue := EPtr
  else begin
    Last := FQueue;
    while Assigned(Last.Next) do
      Last := Last.Next;
    Last.Next := EPtr;
  end;

  if (EPtr.Event.EventType = HGE.INPUT_KEYDOWN) or (EPtr.Event.EventType = INPUT_MBUTTONDOWN) then begin
    FVKey := EPtr.Event.Key;
    FChar := EPtr.Event.Chr;
  end else if (EPtr.Event.EventType = INPUT_MOUSEMOVE) then begin
    FXPos := EPtr.Event.X;
    FYPos := EPtr.Event.Y;
  end else if (EPtr.Event.EventType = INPUT_MOUSEWHEEL) then begin
    Inc(FZPos, EPtr.Event.Wheel);
  end else if (EPtr.Event.EventType = INPUT_CHAR) then begin
    EPtr.Event.Chr := Key;
  end else if (EPtr.Event.EventType = INPUT_IME_CHAR) then begin
    EPtr.Event.Chr := Key;
  end;

  if Assigned(FProcEvent) then
    FProcEvent(@EPtr.Event, FXPos, FYPos);
end;

function THGEImpl.Channel_GetLength(const Chn: IChannel): Single;
begin
  Result := Chn.GetLength;
end;

function THGEImpl.Channel_GetPos(const Chn: IChannel): Single;
begin
  Result := Chn.GetPos;
end;

function THGEImpl.Channel_IsPlaying(const Chn: IChannel): Boolean;
begin
  Result := Chn.IsPlaying;
end;

function THGEImpl.Channel_IsSliding(const Channel: IChannel): Boolean;
begin
  Result := Channel.IsSliding;
end;

procedure THGEImpl.Channel_Pause(const Chn: IChannel);
begin
  Chn.Pause;
end;

procedure THGEImpl.Channel_PauseAll;
begin
  if (FBass <> 0) then
    BASS_Pause;
end;

procedure THGEImpl.Channel_Resume(const Chn: IChannel);
begin
  Chn.Resume;
end;

procedure THGEImpl.Channel_ResumeAll;
begin
  if (FBass <> 0) then
    BASS_Start;
end;

procedure THGEImpl.Channel_SetPanning(const Chn: IChannel; const Pan: Integer);
begin
  Chn.SetPanning(Pan);
end;

procedure THGEImpl.Channel_SetPitch(const Chn: IChannel; const Pitch: Single);
begin
  Chn.SetPitch(Pitch);
end;

procedure THGEImpl.Channel_SetPos(const Chn: IChannel; const Seconds: Single);
begin
  Chn.SetPos(Seconds);
end;

procedure THGEImpl.Channel_SetVolume(const Chn: IChannel;
  const Volume: Integer);
begin
  Chn.SetVolume(Volume);
end;

procedure THGEImpl.Channel_SlideTo(const Channel: IChannel; const Time: Single;
  const Volume, Pan: Integer; const Pitch: Single);
begin
  Channel.SlideTo(Time, Volume, Pan, Pitch);
end;

procedure THGEImpl.Channel_Stop(const Chn: IChannel);
begin
  Chn.Stop;
end;

procedure THGEImpl.Channel_StopAll;
begin
  if (FBass <> 0) then begin
    BASS_Stop;
    BASS_Start;
  end;
end;

procedure THGEImpl.ClearQueue;
var
  NextEPtr, EPtr    : PInputEventList;
begin
  FillChar(FKeyz, SizeOf(FKeyz), 0);
  EPtr := FQueue;
  while Assigned(EPtr) do begin
    NextEPtr := EPtr.Next;
    Dispose(EPtr);
    EPtr := NextEPtr;
  end;

  FQueue := nil;
  FVKey := 0;
  FChar := 0;
  FZPos := 0;
end;

constructor THGEImpl.Create;
var
  p                 : array[0..MAX_PATH] of char;
begin
  inherited;
  FLastErrorStr := '';
  FInstance := GetModuleHandle(nil);
  FActive := False;
  FHasProcDeviceLost := False;
  FVertexLockCnt := 0;
  FHGEFPS := HGEFPS_UNLIMITED;
  FWinTitle := 'HGE';
  FScreenWidth := 800;
  FScreenHeight := 600;
  FScreenBPP := 32;
  FTextureFilter := True;
  FUseSound := True;
  FSampleRate := 44100;
  FFXVolume := 100;
  FMusVolume := 100;
  FHideMouse := True;
  GetModuleFileName(FInstance, p, MAX_PATH);
  FAppPath := ExtractFilePath(p);
  FSearch.FindHandle := INVALID_HANDLE_VALUE;
  FTargets := TList.Create;
  GetLocaleFormatSettings(GetThreadLocale, FFormatSettings);
  FFormatSettings.DecimalSeparator := '.';
  FFormatSettings.ThousandSeparator := ',';
{$IFDEF DEMO}
  FDMO := True;
{$ENDIF}
end;

destructor THGEImpl.Destroy;
begin
  if (FWnd <> 0) then begin
    System_Shutdown;
    Resource_RemoveAllPacks;
    PHGE := nil;
  end;
  FTargets.Free;

  inherited;
end;

function THGEImpl.Effect_Load(const Data: Pointer; const Size: Longword): IEffect;
var
  Length, Samples   : Longword;
  HS                : HSample;
  HStrm             : HStream;
  Info              : BASS_CHANNELINFO;
  Buffer            : Pointer;
begin
  if (FBass <> 0) then begin
    if (FSilent) then begin
      Result := nil;
      Exit;
    end;

    HS := BASS_SampleLoad(True, Data, 0, Size, 4, BASS_SAMPLE_OVER_VOL);
    if (HS = 0) then begin
      HStrm := BASS_StreamCreateFile(True, Data, 0, Size, BASS_STREAM_DECODE);
      if (HStrm <> 0) then begin
        Length := BASS_ChannelGetLength(HStrm);
        BASS_ChannelGetInfo(HStrm, &info);
        Samples := Length;
        if (Info.chans < 2) then
          Samples := Samples shr 1;
        if ((Info.Flags and BASS_SAMPLE_8BITS) = 0) then
          Samples := Samples shr 1;
        Buffer := BASS_SampleCreate(Samples, Info.freq, 2, 4, Info.Flags or BASS_SAMPLE_OVER_VOL);
        if (Buffer = nil) then begin
          BASS_StreamFree(HStrm);
          PostError('Can''t create sound effect: Not enough memory');
        end else begin
          BASS_ChannelGetData(HStrm, Buffer, Length);
          HS := BASS_SampleCreateDone;
          BASS_StreamFree(HStrm);
          if (HS = 0) then
            PostError('Can''t create sound effect');
        end;
      end;
    end;
    Result := TEffect.Create(HS);
  end else
    Result := nil;
end;

function THGEImpl.Effect_Load(const Filename: string): IEffect;
var
  Data              : IResource;
  Size              : Integer;
begin
  Data := Resource_Load(Filename, @Size);
  if (Data = nil) then begin
    Result := nil;
  end else begin
    Result := Effect_Load(Data.Handle, Size);
    Data := nil;
  end;
end;

function THGEImpl.Effect_Play(const Eff: IEffect): IChannel;
begin
  Result := Eff.Play;
end;

function THGEImpl.Effect_PlayEx(const Eff: IEffect; const Volume, Pan: Integer;
  const Pitch: Single; const Loop: Boolean): IChannel;
begin
  Result := Eff.PlayEx(Volume, Pan, Pitch, Loop);
end;

procedure THGEImpl.FocusChange(const Act: Boolean);
begin
  FActive := Act;
  if (FActive) then begin
    if Assigned(FProcFocusGainFunc) then
      FProcFocusGainFunc;
  end else begin
    if Assigned(FProcFocusLostFunc) then
      FProcFocusLostFunc;
  end;
end;

function THGEImpl.FormatId(const Fmt: TD3DFormat): Integer;
begin
  case Fmt of
    D3DFMT_R5G6B5:
      Result := 1;
    D3DFMT_X1R5G5B5:
      Result := 2;
    D3DFMT_A1R5G5B5:
      Result := 3;
    D3DFMT_X8R8G8B8:
      Result := 4;
    D3DFMT_A8R8G8B8:
      Result := 5;
  else
    Result := 0;
  end;
end;

procedure THGEImpl.FreeTimeoutResource;
var
  ResItem           : PResourceList;
begin
  ResItem := FRes;
  while ResItem <> nil do begin
    if ResItem.Lib <> nil then
      TResLib(ResItem.Lib).FreeTimeoutResource;
    ResItem := ResItem.Next;
  end;
end;

procedure THGEImpl.SetIntTest(I: Integer);
begin
  if FIntTest <> I then
    FIntTest := I;
end;

function THGEImpl.GetIntTest: Integer;
begin
  Result := FIntTest;
end;

{$IFDEF DYNTEX}

function THGEImpl.GetSuportsDynamicTextures: Boolean;
begin
  Result := FSuportsDynamicTextures;
end;
{$ENDIF}

function THGEImpl.GetD3DDevice: IDirect3DDevice;
begin
  Result := FD3DDevice;
end;

function THGEImpl.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure THGEImpl.GfxDone;
begin
  FScreenSurf := nil;
  FScreenDepth := nil;

  FTargets.Clear;

  if Assigned(FIB) then begin
    FD3DDevice.SetIndices(nil{$IFDEF DX8}, 0{$ENDIF});
    FIB := nil;
  end;

  if Assigned(FVB) and (FD3DDevice <> nil) then begin
    if Assigned(FVertArray) then begin
      FVB.Unlock;
      FVertArray := nil;
    end;
    FD3DDevice.SetStreamSource(0, nil, {$IFDEF DX9}0, {$ENDIF}SizeOf(THGEVertex));
    FVB := nil;
  end;

  FD3DDevice := nil;
  FD3D := nil;
end;

function THGEImpl.IsCompressedTextureFormatOk(TextureFormat: TD3DFormat; AdapterFormat: TD3DFormat): Boolean;
var
  hr                : HRESULT;
begin
  FD3D.CheckDeviceFormat(D3DADAPTER_DEFAULT,
    D3DDEVTYPE_HAL,
    AdapterFormat,
    0,
    D3DRTYPE_TEXTURE,
    TextureFormat);

  Result := Succeeded(hr);
end;

function THGEImpl.GfxInit: Boolean;
const
  Formats           : array[0..5] of string = ('UNKNOWN', 'R5G6B5', 'X1R5G5B5', 'A1R5G5B5', 'X8R8G8B8', 'A8R8G8B8');
var
  AdID              : TD3DAdapterIdentifier;
  Mode              : TD3DDisplayMode;
  Format            : TD3DFormat;
  NModes, I         : Integer;
  hRet              : HRESULT;
  vp, QualityLevels : DWORD;
  D3DCaps           : TD3DCaps;
begin
  Result := False;
  Format := D3DFMT_UNKNOWN;

  // Init D3D

{$IFDEF DX8}
  FD3D := Direct3DCreate8(D3D_SDK_VERSION); // 120 or D3D_SDK_VERSION
{$ELSE}
  FD3D := Direct3DCreate9(D3D_SDK_VERSION);
{$ENDIF}
  if (FD3D = nil) then begin
    PostError('Can''t create D3D interface');
    Exit;
  end;

  // Get adapter info
{$IFDEF DX8}
  FD3D.GetAdapterIdentifier(D3DADAPTER_DEFAULT, D3DENUM_NO_WHQL_LEVEL, AdID);
{$ELSE}
  FD3D.GetAdapterIdentifier(D3DADAPTER_DEFAULT, 0 {D3DENUM_WHQL_LEVEL}, AdID);
{$ENDIF}

  //D8:GetAdapterIdentifier(D3DADAPTER_DEFAULT, D3DENUM_NO_WHQL_LEVEL , &identifier)＝
  //D9:GetAdapterIdentifier(D3DADAPTER_DEFAULT,0 ,&identifier)

  //D8:GetAdapterIdentifier(D3DADAPTER_DEFAULT, 0 , &identifier)＝
  //D9:GetAdapterIdentifier(D3DADAPTER_DEFAULT,D3DENUM_WHQL_LEVEL ,&identifier)

  System_Log('D3D Driver: %s', [AdID.Driver]);
  System_Log('Description: %s', [AdID.Description]);
  //System_Log('WHQLLevel: %d', [AdID.WHQLLevel]);
  System_Log('Version: %d.%d.%d.%d', [HIWORD(AdID.DriverVersionLowPart), LOWORD(AdID.DriverVersionLowPart), HIWORD(AdID.DriverVersionHighPart), LOWORD(AdID.DriverVersionHighPart)]);

  // Set up Windowed presentation parameters

  if (Failed(FD3D.GetAdapterDisplayMode(D3DADAPTER_DEFAULT, Mode))) or (Mode.Format = D3DFMT_UNKNOWN) then begin
    PostError('Can''t determine desktop video mode');
    if (FWindowed) then
      Exit;
  end;

  ZeroMemory(@FD3DPPW, SizeOf(FD3DPPW));

  FD3DPPW.BackBufferWidth := FScreenWidth;
  FD3DPPW.BackBufferHeight := FScreenHeight;
  FD3DPPW.BackBufferFormat := Mode.Format;
  FD3DPPW.BackBufferCount := 1;
{$IFDEF DX9}
  FD3DPPW.MultiSampleQuality := 0;
{$ENDIF}
  FD3DPPW.MultiSampleType := D3DMULTISAMPLE_NONE;
  FD3DPPW.hDeviceWindow := FWnd;
  FD3DPPW.Windowed := True;

  if (FHGEFPS = HGEFPS_VSYNC) then begin
{$IFDEF DX8}
    FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY_VSYNC
{$ELSE}
    FD3DPPW.SwapEffect := D3DSWAPEFFECT_DISCARD;
    FD3DPPW.PresentationInterval := D3DPRESENT_INTERVAL_ONE
{$ENDIF}
  end else begin
{$IFDEF DX8}
    FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY;
{$ELSE}
    FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY;
    FD3DPPW.FullScreen_RefreshRateInHz := D3DPRESENT_RATE_DEFAULT;
    FD3DPPW.PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
{$ENDIF}
  end;

  if (FZBuffer) then begin
    FD3DPPW.EnableAutoDepthStencil := True;
    FD3DPPW.AutoDepthStencilFormat := D3DFMT_D16;
  end;

  // Set up Full Screen presentation parameters

  NModes := FD3D.GetAdapterModeCount(D3DADAPTER_DEFAULT{$IFDEF DX9}, Mode.Format{$ENDIF});
  for I := 0 to NModes - 1 do begin
    FD3D.EnumAdapterModes(D3DADAPTER_DEFAULT, {$IFDEF DX9}Mode.Format, {$ENDIF}I, Mode);

    //System_Log('%d %d %d [%d %d]', [i, Mode.Width, Mode.Height, FScreenWidth, FScreenHeight]);

    if (Integer(Mode.Width) <> FScreenWidth) or (Integer(Mode.Height) <> FScreenHeight) then
      Continue;

    if (FScreenBPP = 16) and (FormatId(Mode.Format) > FormatId(D3DFMT_A1R5G5B5)) then
      Continue;

    if (FormatId(Mode.Format) > FormatId(Format)) then
      Format := Mode.Format;
  end;

  if (Format = D3DFMT_UNKNOWN) then begin
    PostError('Can''t find appropriate full screen video mode');
    if (not FWindowed) then
      Exit;
  end;

  ZeroMemory(@FD3DPPFS, SizeOf(FD3DPPFS));

  FD3DPPFS.BackBufferWidth := FScreenWidth;
  FD3DPPFS.BackBufferHeight := FScreenHeight;
  FD3DPPFS.BackBufferFormat := Format;
  FD3DPPFS.BackBufferCount := 1;
  FD3DPPFS.MultiSampleType := D3DMULTISAMPLE_NONE;
  FD3DPPFS.hDeviceWindow := FWnd;
  FD3DPPFS.Windowed := False;

  FD3DPPFS.SwapEffect := D3DSWAPEFFECT_FLIP;
  FD3DPPFS.FullScreen_RefreshRateInHz := D3DPRESENT_RATE_DEFAULT;

  if (FHGEFPS = HGEFPS_VSYNC) then
{$IFDEF DX8}
    FD3DPPFS.FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_ONE
{$ELSE}
    FD3DPPFS.PresentationInterval := D3DPRESENT_INTERVAL_ONE
{$ENDIF}
  else begin
{$IFDEF DX8}
    FD3DPPFS.FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
{$ELSE}
    FD3DPPFS.FullScreen_RefreshRateInHz := D3DPRESENT_RATE_DEFAULT;
    FD3DPPFS.PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
{$ENDIF}
  end;

  if (FZBuffer) then begin
    FD3DPPFS.EnableAutoDepthStencil := True;
    FD3DPPFS.AutoDepthStencilFormat := D3DFMT_D16;
  end;

  if (FWindowed) then
    FD3DPP := @FD3DPPW
  else
    FD3DPP := @FD3DPPFS;

  if (FormatId(FD3DPP.BackBufferFormat) < 4) then
    FScreenBPP := 16
  else
    FScreenBPP := 32;

  // Create D3D Device
{$IFDEF DX8}
  hRet := FD3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, FWnd, D3DCREATE_SOFTWARE_VERTEXPROCESSING, FD3DPP^, FD3DDevice);
{$ELSE}
  hRet := FD3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, FWnd, D3DCREATE_SOFTWARE_VERTEXPROCESSING, FD3DPP, FD3DDevice);
{$ENDIF}
  if Failed(hRet) then begin
    PostError('Can''t create D3D device');
    Exit;
  end;

  //FD3DDevice.SetDialogBoxMode(True);

  AdjustWindow;
  System_Log('Mode: %d x %d x %s',
    [FScreenWidth, FScreenHeight, Formats[FormatId(Format)]]);

  System_Log('Available texture memory: %dM',
    [FD3DDevice.GetAvailableTextureMem div 1048576]);

{$IFDEF DYNTEX}
  //D3DCAPS2_DYNAMICTEXTURES
  FSuportsDynamicTextures := False;
  if not Failed(FD3DDevice.GetDeviceCaps(D3DCaps)) then begin
    if (D3DCaps.Caps2 and D3DCAPS2_DYNAMICTEXTURES) = D3DCAPS2_DYNAMICTEXTURES then begin
      FSuportsDynamicTextures := True;
      System_Log('Suports dynamic textures.');
    end;
  end;
{$ENDIF}

  {if (D3DPTEXTURECAPS_POW2 and D3DCaps.TextureCaps <> 0) then
    System_Log('Pow2 TexDimensions Are Required');

  //System_Log('texture compressed suported: ' + BoolToStr(IsCompressedTextureFormatOk(FD3DPPW.BackBufferFormat, Format), True));

  System_Log('D3DFMT_DXT1 Suported: ' + BoolToStr(Succeeded(FD3D.CheckDeviceFormat(D3DCaps.AdapterOrdinal,
    D3DCaps.DeviceType,
    FD3DPPW.BackBufferFormat,
    0,
    D3DRTYPE_TEXTURE,
    D3DFMT_DXT1)), True));
  System_Log('D3DFMT_DXT2 Suported: ' + BoolToStr(Succeeded(FD3D.CheckDeviceFormat(D3DCaps.AdapterOrdinal,
    D3DCaps.DeviceType,
    FD3DPPW.BackBufferFormat,
    0,
    D3DRTYPE_TEXTURE,
    D3DFMT_DXT2)), True));
  System_Log('D3DFMT_DXT3 Suported: ' + BoolToStr(Succeeded(FD3D.CheckDeviceFormat(D3DCaps.AdapterOrdinal,
    D3DCaps.DeviceType,
    FD3DPPW.BackBufferFormat,
    0,
    D3DRTYPE_TEXTURE,
    D3DFMT_DXT3)), True));
  System_Log('D3DFMT_DXT4 Suported: ' + BoolToStr(Succeeded(FD3D.CheckDeviceFormat(D3DCaps.AdapterOrdinal,
    D3DCaps.DeviceType,
    FD3DPPW.BackBufferFormat,
    0,
    D3DRTYPE_TEXTURE,
    D3DFMT_DXT4)), True));
  System_Log('D3DFMT_DXT5 Suported: ' + BoolToStr(Succeeded(FD3D.CheckDeviceFormat(D3DCaps.AdapterOrdinal,
    D3DCaps.DeviceType,
    FD3DPPW.BackBufferFormat,
    0,
    D3DRTYPE_TEXTURE,
    D3DFMT_DXT5)), True));}

  // Create vertex batch buffer

  FVertArray := nil;

  // Init all stuff that can be lost

  SetProjectionMatrix(FScreenWidth, FScreenHeight);
  D3DXMatrixIdentity(FMatView);

  Vertices[0].TX := 0;
  Vertices[0].TY := 0;
  Vertices[1].TX := 1;
  Vertices[1].TY := 0;
  Vertices[2].TX := 1;
  Vertices[2].TY := 1;
  Vertices[3].TX := 0;
  Vertices[3].TY := 1;

  if (not InitLost) then
    Exit;

  Gfx_Clear(0);

  Result := True;
end;

function THGEImpl.GfxReInit(): Boolean;
begin
	FRectW.left := GetSystemMetrics(SM_CXSCREEN) div 2 - FScreenWidth div 2;
	FRectW.top := GetSystemMetrics(SM_CYSCREEN) div 2 - FScreenHeight div 2;
	FRectW.right := FRectW.left + FScreenWidth;
	FRectW.bottom := FRectW.top + FScreenHeight;

	FRectFS.right := FScreenWidth;
	FRectFS.bottom := FScreenHeight;

	AdjustWindowRect(FRectW, FStyleW, False);

	FD3DPPW.BackBufferWidth := FScreenWidth;
	FD3DPPW.BackBufferHeight := FScreenHeight;

	FD3DPPFS.BackBufferWidth := FScreenWidth;
	FD3DPPFS.BackBufferHeight := FScreenHeight;

  if (FWindowed) then
    FD3DPP := @FD3DPPW
  else
    FD3DPP := @FD3DPPFS;

	AdjustWindow();

	SetProjectionMatrix(FScreenWidth, FScreenHeight);
	GfxRestore();

	Result := True;
end;

function THGEImpl.GfxRestore: Boolean;
var
  I                 : Integer;
  Target            : IInternalTarget;
begin
  //  if(FD3DDevice.TestCooperativeLevel <> D3DERR_DEVICELOST) then
  //    Exit;

  Result := False;
  if (FD3DDevice = nil) then
    Exit;

  if FScreenSurf <> nil then FScreenSurf := nil;
  if FScreenDepth <> nil then FScreenDepth := nil;

  try
    for I := 0 to FTargets.Count - 1 do begin
      Target := TTarget(FTargets[I]); //111
      Target.Restore;
    end;
  except
  end;

  if Assigned(FIB) then begin
    FD3DDevice.SetIndices(nil{$IFDEF DX8}, 0{$ENDIF});
    FIB := nil;
  end;

  if Assigned(FVB) then begin
    FD3DDevice.SetStreamSource(0, nil, {$IFDEF DX9}0, {$ENDIF}SizeOf(THGEVertex));
    FVB := nil;
  end;

  if Failed(FD3DDevice.Reset(FD3DPP^)) then //333
   ;// Exit;
    
  if (not InitLost) then
    Exit;

  if Assigned(FProcGfxRestoreFunc) then
    Result := FProcGfxRestoreFunc
  else
    Result := True;
end;

function THGEImpl.Gfx_BeginScene(const Target: ITarget): Boolean;
var
  Surf, Depth               : IDirect3DSurface;
  hr                        : HRESULT;
begin
  Result := False;

  hr := FD3DDevice.TestCooperativeLevel;
  if (hr = D3DERR_DEVICELOST) then
    Exit;

  if (hr = D3DERR_DEVICENOTRESET) then begin
    if (not GfxRestore) then begin
      Sleep(1); //555
      Exit;
    end;
  end;

  if Assigned(FVertArray) then begin
    PostError('Gfx_BeginScene: Scene is already being rendered');
    Exit;
  end;

  if (Target <> FCurTarget) then begin
    if Assigned(Target) then begin
      Target.Tex.Handle.GetSurfaceLevel(0, Surf);
      Depth := (Target as IInternalTarget).Depth;
    end else begin
      Surf := FScreenSurf;
      Depth := FScreenDepth;
    end;

    if (Failed(FD3DDevice.SetRenderTarget({$IFDEF DX8}Surf, Depth{$ELSE}0, Surf{$ENDIF}))) then begin
      PostError('Gfx_BeginScene: Can''t set render target');
      Exit;
    end;

    if Assigned(Target) then begin
      Surf := nil;
      if Assigned((Target as IInternalTarget).Depth) then
        FD3DDevice.SetRenderState(D3DRS_ZENABLE, D3DZB_TRUE)
      else
        FD3DDevice.SetRenderState(D3DRS_ZENABLE, D3DZB_FALSE);
      SetProjectionMatrix(Target.Width, Target.Height);
    end else begin
      if (FZBuffer) then
        FD3DDevice.SetRenderState(D3DRS_ZENABLE, D3DZB_TRUE)
      else
        FD3DDevice.SetRenderState(D3DRS_ZENABLE, D3DZB_FALSE);
      SetProjectionMatrix(FScreenWidth, FScreenHeight);
    end;

    FD3DDevice.SetTransform(D3DTS_PROJECTION, FMatProj);
    D3DXMatrixIdentity(FMatView);
    FD3DDevice.SetTransform(D3DTS_VIEW, FMatView);

    FCurTarget := Target;
  end;

  if FD3DDevice.BeginScene = D3D_OK then begin
    Inc(FVertexLockCnt);
    FVB.Lock(0, 0, {$IFDEF DX8}PByte{$ELSE}Pointer{$ENDIF}(FVertArray), 0);
    FCurPrimType := 0;
    Result := True;
  end;

  //FD3DDevice.BeginScene;
  //FVB.Lock(0, 0, {$IFDEF DX8}PByte{$ELSE}Pointer{$ENDIF}(FVertArray), 0);
  //Result := True;
end;

procedure THGEImpl.Gfx_Clear(const Color: Longword);
begin
  if Assigned(FCurTarget) then begin
    if Assigned((FCurTarget as IInternalTarget).Depth) then
      FD3DDevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, Color, 1.0, 0)
    else
      FD3DDevice.Clear(0, nil, D3DCLEAR_TARGET, Color, 1.0, 0);
  end else begin
    if (FZBuffer) then
      FD3DDevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, Color, 1.0, 0)
    else
      FD3DDevice.Clear(0, nil, D3DCLEAR_TARGET, Color, 1.0, 0);
  end;
end;

(*
procedure THGEImpl.Gfx_EndScene;
begin
  RenderBatch(True);
  FD3DDevice.EndScene;
  if (FCurTarget = nil) then
    FD3DDevice.Present(nil, nil, 0, nil);
end;
*)

procedure THGEImpl.Gfx_EndScene;
begin
  RenderBatch(True);
  FD3DDevice.EndScene;
  if (FVertexLockCnt > 0) then
    Dec(FVertexLockCnt);
  if FVertexLockCnt = 0 then begin //333
    if (FCurTarget = nil) then begin
      FD3DDevice.Present(nil, nil, FD3DPPW.hDeviceWindow, nil);
    end;
  end;
end;

procedure THGEImpl.Gfx_FinishBatch(const NPrim: Integer);
begin
  FPrim := NPrim;
end;

procedure THGEImpl.Gfx_RenderLine(const X1, Y1, X2, Y2: Single;
  const Color: Longword; const Z: Single);
var
  I                 : Integer;
begin
  if Assigned(FVertArray) then begin
    if (FCurPrimType <> HGEPRIM_LINES)
      or (FPrim >= HGEPRIM_LINES_BUFFER_SIZE)
      or (FCurTexture <> nil) or (FCurBlendMode <> BLEND_DEFAULT) then begin
      RenderBatch;
      FCurPrimType := HGEPRIM_LINES;
      if (FCurBlendMode <> BLEND_DEFAULT) then
        SetBlendMode(BLEND_DEFAULT);
      if (FCurTexture <> nil) then begin
        FD3DDevice.SetTexture(0, nil);
        FCurTexture := nil;
      end;
    end;

    I := FPrim * HGEPRIM_LINES;
    FVertArray[I].X := X1;
    FVertArray[I + 1].X := X2;
    FVertArray[I].Y := Y1;
    FVertArray[I + 1].Y := Y2;
    FVertArray[I].Z := Z;
    FVertArray[I + 1].Z := Z;
    FVertArray[I].Col := Color;
    FVertArray[I + 1].Col := Color;
    FVertArray[I].TX := 0;
    FVertArray[I + 1].TX := 0;
    FVertArray[I].TY := 0;
    FVertArray[I + 1].TY := 0;

    Inc(FPrim);
  end;
end;

procedure THGEImpl.Gfx_RenderQuad(const Quad: THGEQuad);
begin
  if Assigned(FVertArray) then begin
    if (FCurPrimType <> HGEPRIM_QUADS)
      or (FPrim >= HGEPRIM_QUADS_BUFFER_SIZE)
      or (FCurTexture <> Quad.Tex)
      or (FCurBlendMode <> Quad.Blend) then begin
      RenderBatch;
      FCurPrimType := HGEPRIM_QUADS;

      if (FCurBlendMode <> Quad.Blend) then
        SetBlendMode(Quad.Blend);

      if (Quad.Tex <> FCurTexture) then begin
        if Assigned(Quad.Tex) then
          FD3DDevice.SetTexture(0, Quad.Tex.Handle)
        else
          FD3DDevice.SetTexture(0, nil);
        FCurTexture := Quad.Tex;
      end;
    end;

    Move(Quad.V, FVertArray[FPrim * HGEPRIM_QUADS], SizeOf(THGEVertex) * HGEPRIM_QUADS);
    Inc(FPrim);
  end;
end;

procedure THGEImpl.Gfx_RenderTriple(const Triple: THGETriple);
begin
  if Assigned(FVertArray) then begin
    if (FCurPrimType <> HGEPRIM_TRIPLES)
      or (FPrim >= HGEPRIM_TRIPLES_BUFFER_SIZE)
      or (FCurTexture <> Triple.Tex)
      or (FCurBlendMode <> Triple.Blend) then begin
      RenderBatch;
      FCurPrimType := HGEPRIM_TRIPLES;
      if (FCurBlendMode <> Triple.Blend) then
        SetBlendMode(Triple.Blend);
      if (Triple.Tex <> FCurTexture) then begin
        if Assigned(Triple.Tex) then
          FD3DDevice.SetTexture(0, Triple.Tex.Handle)
        else
          FD3DDevice.SetTexture(0, nil);
        FCurTexture := Triple.Tex;
      end;
    end;

    Move(Triple.V, FVertArray[FPrim * HGEPRIM_TRIPLES],
      SizeOf(THGEVertex) * HGEPRIM_TRIPLES);
    Inc(FPrim);
  end;
end;

procedure THGEImpl.Gfx_RenderCircle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  Max, I            : Integer;
  Ic, IInc          : Single;
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    if Radius > 1000 then Radius := 1000;
    Max := Round(Radius);
    IInc := 1 / Max;
    Ic := 0;

    FVertArray[0].X := X;
    FVertArray[0].Y := Y;
    FVertArray[0].Col := Color;
    for I := 1 to Max + 1 do begin
      FVertArray[I].X := X + Radius * Cos(Ic * TwoPI);
      FVertArray[I].Y := Y + Radius * Sin(Ic * TwoPI);
      FVertArray[I].Col := Color;
      Ic := Ic + IInc;
    end;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;
    if not Filled then begin
      FVertArray[0].X := FVertArray[Max + 1].X;
      FVertArray[0].Y := FVertArray[Max + 1].Y;
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, Max + 1);
    end
    else begin
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderTriangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    FVertArray[0].X := X1;
    FVertArray[0].Y := Y1;
    FVertArray[0].Col := Color;
    FVertArray[1].X := X2;
    FVertArray[1].Y := Y2;
    FVertArray[1].Col := Color;
    FVertArray[2].X := X3;
    FVertArray[2].Y := Y3;
    FVertArray[2].Col := Color;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if Filled then begin
      CopyVertices(@FVertArray^, 3);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLELIST, 0, 1);
    end
    else begin
      FVertArray[3].X := X1;
      FVertArray[3].Y := Y1;
      FVertArray[3].Col := Color;
      CopyVertices(@FVertArray^, 4);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, 3);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderEllipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  Max, I            : Integer;
  Ic, IInc          : Single;
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    if R1 > 1000 then
      R1 := 1000;
    Max := Round(R1);
    IInc := 1 / Max;
    Ic := 0;

    FVertArray[0].X := X;
    FVertArray[0].Y := Y;
    FVertArray[0].Col := Color;
    for I := 1 to Max + 1 do begin
      FVertArray[I].X := X + R1 * Cos(Ic * TwoPI);
      FVertArray[I].Y := Y + R2 * Sin(Ic * TwoPI);
      FVertArray[I].Col := Color;
      Ic := Ic + IInc;
    end;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if not Filled then begin
      FVertArray[0].X := FVertArray[Max + 1].X;
      FVertArray[0].Y := FVertArray[Max + 1].Y;
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, Max + 1);
    end
    else begin
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderArc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer);
var
  Max, I            : Integer;
  Ic, IInc          : Single;
begin
  if Assigned(FVertArray) then begin
    if Radius > 1000 then
      Radius := 1000;

    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    Max := Round(Radius);
    IInc := 1 / Max;
    IInc := IInc * (EndRadius - StartRadius) * IRad;
    Ic := StartRadius * IRad;

    FVertArray[0].X := X;
    FVertArray[0].Y := Y;
    FVertArray[0].Col := Color;
    for I := 1 to Max + 1 do begin
      FVertArray[I].X := X + Radius * Cos(Ic * TwoPI);
      FVertArray[I].Y := Y + Radius * Sin(Ic * TwoPI);
      FVertArray[I].Col := Color;
      Ic := Ic + IInc;
    end;

    if DrawStartEnd then
      I := 0
    else
      I := 1;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if not Filled then begin
      FVertArray[0].X := FVertArray[Max + 1].X;
      FVertArray[0].Y := FVertArray[Max + 1].Y;
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, I, Max + (1 - I));
    end
    else begin
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderLine2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    FVertArray[0].X := X1;
    FVertArray[0].Y := Y1;
    FVertArray[0].Col := Color1;
    FVertArray[1].X := X2;
    FVertArray[1].Y := Y2;
    FVertArray[1].Col := Color2;
    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;
    CopyVertices(@FVertArray^, 2);
    FD3DDevice.DrawPrimitive(D3DPT_LINELIST, 0, 1);
  end;
end;

procedure THGEImpl.Gfx_RenderQuadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    FVertArray[0].X := X1;
    FVertArray[0].Y := Y1;
    FVertArray[0].Col := Color1;
    FVertArray[1].X := X2;
    FVertArray[1].Y := Y2;
    FVertArray[1].Col := Color2;
    FVertArray[2].X := X3;
    FVertArray[2].Y := Y3;
    FVertArray[2].Col := Color3;
    FVertArray[3].X := X4;
    FVertArray[3].Y := Y4;
    FVertArray[3].Col := Color4;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if Filled then begin
      CopyVertices(@FVertArray^, 4);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, 2);
    end
    else begin
      FVertArray[4].X := X1;
      FVertArray[4].Y := Y1;
      FVertArray[4].Col := Color1;
      CopyVertices(@FVertArray^, 5);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, 4);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderPolygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  I                 : Integer;
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    for I := 0 to NumPoints - 1 do begin
      FVertArray[I].X := Points[I].X;
      FVertArray[I].Y := Points[I].Y;
      FVertArray[I].Col := Color;
    end;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;
    if Filled then begin
      CopyVertices(@FVertArray^, NumPoints);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, NumPoints - 2);
    end
    else begin
      FVertArray[NumPoints].X := Points[0].X;
      FVertArray[NumPoints].Y := Points[0].Y;
      FVertArray[NumPoints].Col := Color;
      CopyVertices(@FVertArray^, NumPoints + 1);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, NumPoints);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderSquareSchedule(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
var
  I                 : Integer;
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_TRIPLES;
    SetBlendMode(BlendMode);

    for I := 0 to NumPoints - 1 do begin
      FVertArray[I].X := Points[I].X;
      FVertArray[I].Y := Points[I].Y;
      FVertArray[I].Col := Color;
    end;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    CopyVertices(@FVertArray^, NumPoints);
    FD3DDevice.DrawPrimitive(D3DPT_TRIANGLELIST, 0, NumPoints div 3);
  end;
end;

procedure THGEImpl.Gfx_SetClipping(X, Y, W, H: Integer);
var
  vp                : TD3DViewport;
  ScrWidth, ScrHeight: Integer;
  Tmp               : TD3DXMatrix;
begin
  if (X > SCREENWIDTH) or (Y > SCREENHEIGHT) then Exit; //1111

  if (FCurTarget = nil) then begin
    ScrWidth := PHGE.System_GetState(HGE_SCREENWIDTH);
    ScrHeight := PHGE.System_GetState(HGE_SCREENHEIGHT);
  end else begin
    ScrWidth := Texture_GetWidth(FCurTarget.Tex);
    ScrHeight := Texture_GetHeight(FCurTarget.Tex);
  end;

  if (W = 0) then begin
    vp.X := 0;
    vp.Y := 0;
    vp.Width := ScrWidth;
    vp.Height := ScrHeight;
  end else begin
    if (X < 0) then begin
      Inc(W, X);
      X := 0;
    end;
    if (Y < 0) then begin
      Inc(H, Y);
      Y := 0;
    end;

    if (X + W > ScrWidth) then
      W := ScrWidth - X;
    if (Y + H > ScrHeight) then
      H := ScrHeight - Y;

    vp.X := X;
    vp.Y := Y;
    vp.Width := W;
    vp.Height := H;
  end;

  vp.MinZ := 0.0;
  vp.MaxZ := 1.0;

  RenderBatch;
  FD3DDevice.SetViewport(vp);

  D3DXMatrixScaling(FMatProj, 1.0, -1.0, 1.0);
  D3DXMatrixTranslation(Tmp, -0.5, +0.5, 0.0);
  D3DXMatrixMultiply(FMatProj, FMatProj, Tmp);
  D3DXMatrixOrthoOffCenterLH(Tmp, vp.X, vp.X + vp.Width, -(vp.Y + vp.Height),
    -vp.Y, vp.MinZ, vp.MaxZ);
  D3DXMatrixMultiply(FMatProj, FMatProj, Tmp);
  FD3DDevice.SetTransform(D3DTS_PROJECTION, FMatProj);
end;

procedure THGEImpl.Gfx_SetTransform(const X, Y, DX, DY, Rot, HScale,
  VScale: Single);
var
  Tmp               : TD3DXMatrix;
begin
  if (VScale = 0.0) then
    D3DXMatrixIdentity(FMatView)
  else begin
    D3DXMatrixTranslation(FMatView, -X, -Y, 0.0);
    D3DXMatrixScaling(Tmp, HScale, VScale, 1.0);
    D3DXMatrixMultiply(FMatView, FMatView, Tmp);
    D3DXMatrixRotationZ(Tmp, -Rot);
    D3DXMatrixMultiply(FMatView, FMatView, Tmp);
    D3DXMatrixTranslation(Tmp, X + DX, Y + DY, 0.0);
    D3DXMatrixMultiply(FMatView, FMatView, Tmp);
  end;

  RenderBatch;
  FD3DDevice.SetTransform(D3DTS_VIEW, FMatView);
end;

function THGEImpl.Gfx_StartBatch(const PrimType: Integer; const Tex: ITexture;
  const Blend: Integer; out MaxPrim: Integer): PHGEVertexArray;
begin
  if Assigned(FVertArray) then begin
    RenderBatch;

    FCurPrimType := PrimType;
    if (FCurBlendMode <> Blend) then
      SetBlendMode(Blend);
    if (Tex <> FCurTexture) then begin
      if Assigned(Tex) then
        FD3DDevice.SetTexture(0, Tex.Handle)
      else
        FD3DDevice.SetTexture(0, nil);
      FCurTexture := Tex;
    end;

    MaxPrim := VERTEX_BUFFER_SIZE div PrimType;
    Result := FVertArray;
  end else
    Result := nil;
end;

function THGEImpl.InitLost: Boolean;
var
  Target            : IInternalTarget;
  PIndices          : PWord;
  N                 : Word;
  I                 : Integer;
  hr                : HRESULT;
begin
  Result := False;

  // Store render target

  if FScreenSurf <> nil then FScreenSurf := nil;
  if FScreenDepth <> nil then FScreenDepth := nil;

  FD3DDevice.GetRenderTarget({$IFDEF DX9}0, {$ENDIF}FScreenSurf);
  FD3DDevice.GetDepthStencilSurface(FScreenDepth);

  try
    for I := 0 to FTargets.Count - 1 do begin
      Target := TTarget(FTargets[I]); //111
      Target.Lost;
    end;
  except
  end;

  // Create Vertex buffer
  FVB := nil;
  if (Failed(FD3DDevice.CreateVertexBuffer(VERTEX_BUFFER_SIZE * SizeOf(THGEVertex),
    D3DUSAGE_DYNAMIC or D3DUSAGE_WRITEONLY,     //333
    D3DFVF_HGEVERTEX,
    D3DPOOL_DEFAULT,
    FVB{$IFDEF DX9}, 0{$ENDIF}))) then begin
    PostError('Can''t create D3D vertex buffer');
    Exit;
  end;

{$IFDEF DX8}
  FD3DDevice.SetVertexShader(D3DFVF_HGEVERTEX);
  FD3DDevice.SetStreamSource(0, FVB, SizeOf(THGEVertex));
{$ELSE}
  FD3DDevice.SetVertexShader(nil);
  FD3DDevice.SetFVF(D3DFVF_HGEVERTEX);
  FD3DDevice.SetStreamSource(0, FVB, 0, SizeOf(THGEVertex));
{$ENDIF}

  // Create and setup Index buffer
  FIB := nil;
  if (Failed(FD3DDevice.CreateIndexBuffer(VERTEX_BUFFER_SIZE * 6 div 4 * SizeOf(Word),
    D3DUSAGE_WRITEONLY,
    D3DFMT_INDEX16,
    D3DPOOL_DEFAULT,
    FIB{$IFDEF DX9}, nil{$ENDIF}))) then begin
    PostError('Can''t create D3D index buffer');
    Exit;
  end;

  N := 0;
  if (Failed(FIB.Lock(0, 0, {$IFDEF DX8}PByte{$ELSE}Pointer{$ENDIF}(PIndices), 0))) then begin
    PostError('Can''t lock D3D index buffer');
    Exit;
  end;

  for I := 0 to (VERTEX_BUFFER_SIZE div 4) - 1 do begin
    PIndices^ := N;
    Inc(PIndices);
    PIndices^ := N + 1;
    Inc(PIndices);
    PIndices^ := N + 2;
    Inc(PIndices);

    PIndices^ := N + 2;
    Inc(PIndices);
    PIndices^ := N + 3;
    Inc(PIndices);
    PIndices^ := N;
    Inc(PIndices);
    Inc(N, 4);
  end;

  FIB.Unlock;
  FD3DDevice.SetIndices(FIB{$IFDEF DX8}, 0{$ENDIF});

  // Set common render states

  //FD3DDevice.SetRenderState(D3DRS_LASTPIXEL, Integer(False));
  FD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
  FD3DDevice.SetRenderState(D3DRS_LIGHTING, 0);

  FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, 1);
  FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
  FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);

  FD3DDevice.SetRenderState(D3DRS_ALPHATESTENABLE, 1);
  FD3DDevice.SetRenderState(D3DRS_ALPHAREF, 1);
  FD3DDevice.SetRenderState(D3DRS_ALPHAFUNC, D3DCMP_GREATEREQUAL);

  FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
  FD3DDevice.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
  FD3DDevice.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

  FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
  FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
  FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

{$IFDEF DX8}
  FD3DDevice.SetTextureStageState(0, D3DTSS_MIPFILTER, D3DTEXF_POINT);
{$ELSE}
  FD3DDevice.SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_POINT);
{$ENDIF}

  if (FTextureFilter) then begin
{$IFDEF DX8}
    FD3DDevice.SetTextureStageState(0, D3DTSS_MAGFILTER, D3DTEXF_LINEAR);
    FD3DDevice.SetTextureStageState(0, D3DTSS_MINFILTER, D3DTEXF_LINEAR);
{$ELSE}
    FD3DDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
    FD3DDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
{$ENDIF}
  end else begin
{$IFDEF DX8}
    FD3DDevice.SetTextureStageState(0, D3DTSS_MAGFILTER, D3DTEXF_POINT);
    FD3DDevice.SetTextureStageState(0, D3DTSS_MINFILTER, D3DTEXF_POINT);
{$ELSE}
    FD3DDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_POINT);
    FD3DDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_POINT);
{$ENDIF}
  end;

  FPrim := 0;
  FCurPrimType := HGEPRIM_QUADS;
  FCurBlendMode := BLEND_DEFAULT;
	if (not FZBuffer)	then //111
		FD3DDevice.SetRenderState(D3DRS_ZWRITEENABLE, LongWord(FALSE));
    
  FCurTexture := nil;

  FD3DDevice.SetTransform(D3DTS_VIEW, FMatView);
  FD3DDevice.SetTransform(D3DTS_PROJECTION, FMatProj);

  Result := True;
end;

function THGEImpl.Ini_GetFloat(const Section, Name: string;
  const DefVal: Single): Single;
var
  Buf               : array[0..255] of char;
begin
  Result := DefVal;
  if (FIniFile <> '') then
    if (GetPrivateProfileString(PChar(Section), PChar(Name), '', Buf, 255, PChar(FIniFile)) <> 0) then
      Result := StrToFloatDef(Buf, DefVal, FFormatSettings);
end;

function THGEImpl.Ini_GetInt(const Section, Name: string;
  const DefVal: Integer): Integer;
var
  Buf               : array[0..255] of char;
begin
  Result := DefVal;
  if (FIniFile <> '') then
    if (GetPrivateProfileString(PChar(Section), PChar(Name), '', Buf, 255, PChar(FIniFile)) <> 0) then
      Result := StrToIntDef(Buf, DefVal);
end;

function THGEImpl.Ini_GetString(const Section, Name, DefVal: string): string;
var
  Buf               : array[0..255] of char;
begin
  Result := DefVal;
  if (FIniFile <> '') then
    if (GetPrivateProfileString(PChar(Section), PChar(Name), '', Buf, 255, PChar(FIniFile)) <> 0) then
      Result := Buf;
end;

procedure THGEImpl.Ini_SetFloat(const Section, Name: string;
  const Value: Single);
begin
  if (FIniFile <> '') then
    WritePrivateProfileString(PChar(Section), PChar(Name),
      PChar(FloatToStrF(Value, ffGeneral, 7, 0, FFormatSettings)), PChar(FIniFile));
end;

procedure THGEImpl.Ini_SetInt(const Section, Name: string;
  const Value: Integer);
begin
  if (FIniFile <> '') then
    WritePrivateProfileString(PChar(Section), PChar(Name),
      PChar(IntToStr(Value)), PChar(FIniFile));
end;

procedure THGEImpl.Ini_SetString(const Section, Name, Value: string);
begin
  if (FIniFile <> '') then
    WritePrivateProfileString(PChar(Section), PChar(Name),
      PChar(Value), PChar(FIniFile));
end;

procedure THGEImpl.InputInit;
var
  p                 : TPoint;
begin
  GetCursorPos(p);
  ScreenToClient(FWnd, p);
  FXPos := p.X;
  FYPos := p.Y;
  FillChar(FKeyz, SizeOf(FKeyz), 0);
end;

function THGEImpl.Input_GetChar: Integer;
begin
  Result := FChar;
end;

function THGEImpl.Input_GetEvent(out Event: THGEInputEvent): Boolean;
var
  EPtr              : PInputEventList;
begin
  if Assigned(FQueue) then begin
    EPtr := FQueue;
    Event := EPtr.Event;
    FQueue := EPtr.Next;
    Dispose(EPtr);
    Result := True;
  end else
    Result := False;
end;

function THGEImpl.Input_GetKey: Integer;
begin
  Result := FVKey;
end;

function THGEImpl.Input_GetKeyName(const Key: Integer): string;
begin
  Result := KeyNames[Key];
end;

function THGEImpl.Input_GetKeyState(const Key: Integer): Boolean;
begin
  Result := ((GetAsyncKeyState(Key) and $8000) <> 0)
end;

procedure THGEImpl.Input_GetMousePos(out X, Y: Single);
begin
  X := FXPos;
  Y := FYPos;
end;

function THGEImpl.Input_GetMouseWheel: Integer;
begin
  Result := FZPos;
end;

function THGEImpl.Input_IsMouseOver: Boolean;
begin
  Result := FMouseOver;
end;

function THGEImpl.INPUT_KEYDOWN(const Key: Integer): Boolean;
begin
  Result := ((FKeyz[Key] and 1) <> 0);
end;

function THGEImpl.INPUT_KEYUP(const Key: Integer): Boolean;
begin
  Result := ((FKeyz[Key] and 2) <> 0);
end;

procedure THGEImpl.Input_SetMousePos(const X, Y: Single);
var
  Pt                : TPoint;
begin
  Pt.X := Trunc(X);
  Pt.Y := Trunc(Y);
  ClientToScreen(FWnd, Pt);
  SetCursorPos(Pt.X, Pt.Y);
end;

class function THGEImpl.InterfaceGet: THGEImpl;
begin
  if (PHGE = nil) then
    PHGE := THGEImpl.Create;
  Result := PHGE;
end;

function THGEImpl.Flash_Load(const Filename: string; const Size: PLongword): TMemoryStream;
var
  ResItem           : PResourceList;
  Name              : string;
  I                 : Integer;
  FPackName, PName  : string;
begin
  Result := nil;
  if (Filename = '') then Exit;
  ResItem := FRes;
  if (not (Filename[1] in ['\', '/', ':', '.'])) then begin
    // Load from pack
    Name := UpperCase(Filename);
    for I := 1 to Length(Name) do
      if (Name[I] = '/') then Name[I] := '\';
    //取得文件名的开始目录，也就是包文件
    FPackName := System.Copy(Name, 1, Pos('\', Name) - 1) + '.PCK';
    //查找是否有这个包
    while Assigned(ResItem) do begin
      PName := ExtractFileName(ResItem.Filename);
      if CompareText(FPackName, PName) = 0 then Break;
      ResItem := ResItem.Next;
    end;
    //if ResItem=nil then ResItem:=FRes;

    while Assigned(ResItem) do begin
      if ResItem.Lib <> nil then begin
        Result := TResLib(ResItem.Lib).Stream_Load(Name, Size);
        if Result <> nil then Exit;
      end;
      ResItem := ResItem.Next;
    end;
  end;
end;

function THGEImpl.Music_Load(const Filename: string): IMusic;
var
  Data              : IResource;
  Size              : Integer;
begin
  Data := Resource_Load(Filename, @Size);
  if (Data = nil) then
    Result := nil
  else begin
    Result := Music_Load(Data.Handle, Size);
    Data := nil;
  end;
end;

function THGEImpl.Music_GetAmplification(const Music: IMusic): Integer;
begin
  Result := Music.GetAmplification;
end;

function THGEImpl.Music_GetChannelVolume(const Music: IMusic;
  const Channel: Integer): Integer;
begin
  Result := Music.GetChannelVolume(Channel);
end;

function THGEImpl.Music_GetInstrVolume(const Music: IMusic;
  const Instr: Integer): Integer;
begin
  Result := Music.GetInstrVolume(Instr);
end;

function THGEImpl.Music_GetLength(const Music: IMusic): Integer;
begin
  Result := Music.GetLength;
end;

function THGEImpl.Music_GetPos(const Music: IMusic; out Order, Row: Integer): Boolean;
begin
  Result := Music.GetPos(Order, Row);
end;

function THGEImpl.Music_Load(const Data: Pointer; const Size: Longword): IMusic;
var
  Handle            : HMusic;
begin
  if (FBass <> 0) then begin
    Handle := BASS_MusicLoad(True, Data, 0, Size, BASS_MUSIC_PRESCAN
      or BASS_MUSIC_POSRESETEX or BASS_MUSIC_RAMP, 0);
    if (Handle = 0) then begin
      Result := nil;
      PostError('Can''t load music');
    end else
      Result := TMusic.Create(Handle);
  end else
    Result := nil;
end;

function THGEImpl.Music_Play(const Mus: IMusic; const Loop: Boolean;
  const Volume: Integer = 100; const Order: Integer = -1;
  const Row: Integer = -1): IChannel;
begin
  Result := Mus.Play(Loop, Volume, Order, Row);
end;

procedure THGEImpl.Music_SetAmplification(const Music: IMusic;
  const Ampl: Integer);
begin

end;

procedure THGEImpl.Music_SetChannelVolume(const Music: IMusic; const Channel,
  Volume: Integer);
begin
  Music.SetChannelVolume(Channel, Volume);
end;

procedure THGEImpl.Music_SetInstrVolume(const Music: IMusic; const Instr,
  Volume: Integer);
begin
  Music.SetInstrVolume(Instr, Volume);
end;

procedure THGEImpl.Music_SetPos(const Music: IMusic; const Order, Row: Integer);
begin
  Music.SetPos(Order, Row);
end;

procedure THGEImpl.PostError(const Error: string);
begin
  FLastErrorStr := Error;
  System_Log(Error);
  FError := Error;
end;

function THGEImpl.Random_Float(const Min, Max: Single): Single;
begin
  GSeed := 214013 * GSeed + 2531011;
  //return min+g_seed*(1.0f/4294967295.0f)*(max-min);
  Result := Min + (GSeed shr 16) * (1.0 / 65535.0) * (Max - Min);
end;

function THGEImpl.Random_Int(const Min, Max: Integer): Integer;
begin
  GSeed := 214013 * GSeed + 2531011;
  Result := Min + Integer((GSeed xor GSeed shr 15) mod Cardinal(Max - Min + 1));
end;

procedure THGEImpl.Random_Seed(const Seed: Integer);
begin
  if (Seed = 0) then
    GSeed := timeGetTime
  else
    GSeed := Seed;
end;

procedure THGEImpl.RenderBatch(const EndScene: Boolean);
begin
  if Assigned(FVertArray) then begin
    FVB.Unlock;
    if (FPrim <> 0) then begin
      case FCurPrimType of
        HGEPRIM_QUADS:
          FD3DDevice.DrawIndexedPrimitive(D3DPT_TRIANGLELIST, 0, {$IFDEF DX9}0, {$ENDIF}FPrim shl 2, 0, FPrim shl 1);
        HGEPRIM_TRIPLES:
          FD3DDevice.DrawPrimitive(D3DPT_TRIANGLELIST, 0, FPrim);
        HGEPRIM_LINES:
          FD3DDevice.DrawPrimitive(D3DPT_LINELIST, 0, FPrim);
      end;

      FPrim := 0;
    end;

    if (EndScene) then
      FVertArray := nil
    else
      FVB.Lock(0, 0, {$IFDEF DX8}PByte{$ELSE}Pointer{$ENDIF}(FVertArray), 0);
  end;
end;

procedure THGEImpl.Resize(const Width, Height: Integer);
begin
  if Width <> 0 then begin
    g_ClientWidth := Width;
  end;
  if Height <> 0 then begin
    g_ClientHeight := Height;
  end;
  if (FWndParent <> 0) then begin
    //    if Assigned(FProcFocusLostFunc) then
    //      FProcFocusLostFunc;

    FD3DPPW.BackBufferWidth := Width;
    FD3DPPW.BackBufferHeight := Height;
    FScreenWidth := Width;
    FScreenHeight := Height;

    SetProjectionMatrix(FScreenWidth, FScreenHeight);
    GfxRestore;

    //    if Assigned(FProcFocusGainFunc) then
    //      FProcFocusGainFunc;
  end;
  if Assigned(FProcResize) then FProcResize;
end;

function THGEImpl.Resource_AttachPack(const Filename: string): Boolean;
var
  Name              : string;
  ResItem           : PResourceList;
  Zip               : unzFile;
begin
  Result := False;
  ResItem := FRes;

  Name := UpperCase(Resource_MakePath(Filename));
  while Assigned(ResItem) do begin
    if CompareText(Name, ResItem.Filename) = 0 then
      Exit;
    ResItem := ResItem.Next;
  end;

  Zip := unzOpen(PChar(Name));
  if (Zip = nil) then
    Exit;
  unzClose(Zip);

  New(ResItem);
  ResItem.Filename := Name;
  ResItem.Next := FRes;
  FRes := ResItem;
  Result := True;

end;

//修改为装载自定义的包

{function THGEImpl.Resource_AttachPack(const Filename: string): Boolean;
var
  Name                      : string;
  ResItem                   : PResourceList;
begin
  Result := False;
  ResItem := FRes;
  Name := UpperCase(Resource_MakePath(Filename));

  while Assigned(ResItem) do begin
    if (Name = ResItem.Filename) then
      Exit;
    ResItem := ResItem.Next;
  end;

  New(ResItem);
  ResItem.Filename := Name;
  ResItem.Next := FRes;
  try
    ResItem.Lib := TResLib.Create(Filename);
  except
    ResItem.Lib := nil;
  end;
  FRes := ResItem;
  Result := True;
end;}

function THGEImpl.Resource_EnumFiles(const Wildcard: string): string;
begin
  Result := '';
  if (Wildcard <> '') then begin
    FindClose(FSearch);
    if (FindFirst(Resource_MakePath(Wildcard), faAnyFile, FSearch) <> 0) then
      Exit;
    if ((FSearch.Attr and faDirectory) = 0) then
      Result := FSearch.Name
    else
      Result := Resource_EnumFiles;
  end else begin
    if (FSearch.FindHandle = INVALID_HANDLE_VALUE) then
      Exit;
    while True do begin
      if (FindNext(FSearch) <> 0) then begin
        FindClose(FSearch);
        Exit;
      end;
      if ((FSearch.Attr and faDirectory) = 0) then begin
        Result := FSearch.Name;
        Exit;
      end;
    end;
  end;
end;

function THGEImpl.Resource_EnumFolders(const Wildcard: string): string;
begin
  Result := '';
  if (Wildcard <> '') then begin
    FindClose(FSearch);
    if (FindFirst(Resource_MakePath(Wildcard), faAnyFile, FSearch) <> 0) then
      Exit;
    if ((FSearch.Attr and faDirectory) <> 0) and (FSearch.Name[1] <> '.') then
      Result := FSearch.Name
    else
      Result := Resource_EnumFolders;
  end else begin
    if (FSearch.FindHandle = INVALID_HANDLE_VALUE) then
      Exit;
    while True do begin
      if (FindNext(FSearch) <> 0) then begin
        FindClose(FSearch);
        Exit;
      end;
      if ((FSearch.Attr and faDirectory) <> 0) and (FSearch.Name[1] <> '.') then begin
        Result := FSearch.Name;
        Exit;
      end;
    end;
  end;
end;

function THGEImpl.Resource_Load(const Filename: string;
  const Size: PLongword): IResource;
const
  ResErr            = 'Can''t load resource %d: %s';
var
  Data              : Pointer;
  ResItem           : PResourceList;
  Name, ZipName     : string;
  PZipName          : array[0..MAX_PATH] of char;
  Zip               : unzFile;
  FileInfo          : unz_file_info;
  Done, I           : Integer;
  F                 : THandle;
  BytesRead         : Cardinal;
begin
  Result := nil;
  Data := nil;
  if (Filename = '') then
    Exit;
  ResItem := FRes;

  if (not (Filename[1] in ['\', '/', ':', '.'])) then begin
    // Load from pack
    Name := UpperCase(Filename);
    for I := 1 to Length(Name) do
      if (Name[I] = '/') then
        Name[I] := '\';

    while Assigned(ResItem) do begin
      Zip := unzOpen(PChar(ResItem.Filename));
      Done := unzGoToFirstFile(Zip);
      while (Done = UNZ_OK) do begin
        unzGetCurrentFileInfo(Zip, @FileInfo, PZipName, MAX_PATH, nil, 0, nil, 0);
        ZipName := UpperCase(PZipName);
        for I := 1 to Length(ZipName) do
          if (ZipName[I] = '/') then
            ZipName[I] := '\';
        if (Name = ZipName) then begin
          if (unzOpenCurrentFile(Zip) <> UNZ_OK) then begin
            unzClose(Zip);
            PostError(Format(ResErr, [0, Filename]));
            Exit;
          end;

          try
            GetMem(Data, FileInfo.uncompressed_size);
          except
            unzCloseCurrentFile(Zip);
            unzClose(Zip);
            PostError(Format(ResErr, [1, Filename]));
            Exit;
          end;

          if (unzReadCurrentFile(Zip, Data, FileInfo.uncompressed_size) < 0) then begin
            unzCloseCurrentFile(Zip);
            unzClose(Zip);
            FreeMem(Data);
            PostError(Format(ResErr, [2, Filename]));
            Exit;
          end;
          Result := TResource.Create(Data, FileInfo.uncompressed_size);
          unzCloseCurrentFile(Zip);
          unzClose(Zip);
          if Assigned(Size) then
            Size^ := FileInfo.uncompressed_size;
          Exit;
        end;

        Done := unzGoToNextFile(Zip);
      end;

      unzClose(Zip);
      ResItem := ResItem.Next;
    end;
  end;

  // Load from file
  F := CreateFile(PChar(Filename), GENERIC_READ,
    FILE_SHARE_READ, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL or FILE_FLAG_RANDOM_ACCESS, 0);
  if (F = INVALID_HANDLE_VALUE) then begin
    //PostError(Format(ResErr, [3, Filename]));
    Exit;
  end;

  Result := nil;
  FileInfo.uncompressed_size := GetFileSize(F, nil);
  try
    GetMem(Data, FileInfo.uncompressed_size);
  except
    CloseHandle(F);
    PostError(Format(ResErr, [4, Filename]));
    Exit;
  end;

  if (not ReadFile(F, Data^, FileInfo.uncompressed_size, BytesRead, nil)) then begin
    CloseHandle(F);
    FreeMem(Data);
    PostError(Format(ResErr, [5, Filename]));
    Exit;
  end;

  Result := TResource.Create(Data, BytesRead);
  CloseHandle(F);
  if Assigned(Size) then
    Size^ := BytesRead;
end;

function THGEImpl.Resource_Load(const Filename: string;
  const List: TStringList): Integer;
const
  ResErr            = 'Can''t load resource %d: %s';
var
  ResItem           : PResourceList;
  Name, ZipName     : string;
  PZipName          : array[0..MAX_PATH] of char;
  Zip               : unzFile;
  FileInfo          : unz_file_info;
  Done, I           : Integer;
  F                 : THandle;
  BytesRead         : Cardinal;
begin
  Result := 0;
  if (Filename = '') then
    Exit;
  ResItem := FRes;

  Name := UpperCase(Resource_MakePath(Filename));
  while Assigned(ResItem) do begin
    if (Name = ResItem.Filename) then begin
      Zip := unzOpen(PChar(ResItem.Filename));
      Done := unzGoToFirstFile(Zip);
      while (Done = UNZ_OK) do begin
        unzGetCurrentFileInfo(Zip, @FileInfo, PZipName, MAX_PATH, nil, 0, nil, 0);
        ZipName := UpperCase(PZipName);
        if ZipName <> '' then begin
          List.Add(ZipName);
          Inc(Result);
        end;
        Done := unzGoToNextFile(Zip);
      end;
      unzClose(Zip);
      Exit;
    end;
    ResItem := ResItem.Next;
  end;
end;

{function THGEImpl.Resource_Load(const Filename: string; const Size: PLongword): IResource;
const
  ResErr                    = '装载资源失败: %s';
var
  Data                      : Pointer;
  ResItem                   : PResourceList;
  Name                      : string;
  I                         : Integer;
  F                         : THandle;
  BytesRead                 : Cardinal;
  FPackName, PName          : string;
  FileInfo                  : unz_file_info;
begin
  Result := nil;
  if (Filename = '') then
    Exit;
  ResItem := FRes;

  if (not (Filename[1] in ['\', '/', ':', '.'])) then begin
    // Load from pack
    Name := UpperCase(Filename);
    for I := 1 to Length(Name) do
      if (Name[I] = '/') then
        Name[I] := '\';
    //取得文件名的开始目录，也就是包文件
    FPackName := System.Copy(Name, 1, Pos('\', Name) - 1) + '.PCK';
    //查找是否有这个包
    while Assigned(ResItem) do begin
      PName := extractfilename(ResItem.Filename);
      if FPackName = PName then break;
      ResItem := ResItem.Next;
    end;
    //if ResItem=nil then ResItem:=FRes;

    while Assigned(ResItem) do begin
      if ResItem.Lib <> nil then begin
        Result := TResLib(ResItem.Lib).Resource_Load(Name, Size);
        if Result <> nil then Exit;
      end;
      ResItem := ResItem.Next;
    end;
  end;

  // Load from file
  F := CreateFile(PChar(Filename), GENERIC_READ,
    FILE_SHARE_READ, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL or FILE_FLAG_RANDOM_ACCESS, 0);
  if (F = INVALID_HANDLE_VALUE) then begin
    PostError(Format(ResErr, [Filename]));
    Exit;
  end;

  Result := nil;
  FileInfo.uncompressed_size := GetFileSize(F, nil);
  try
    GetMem(Data, FileInfo.uncompressed_size);
  except
    CloseHandle(F);
    PostError(Format(ResErr, [Filename]));
    Exit;
  end;

  if (not ReadFile(F, Data^, FileInfo.uncompressed_size, BytesRead, nil)) then begin
    CloseHandle(F);
    FreeMem(Data);
    PostError(Format(ResErr, [Filename]));
    Exit;
  end;

  Result := TResource.Create(Data, BytesRead);
  CloseHandle(F);
  if Assigned(Size) then
    Size^ := BytesRead;
end;}

function THGEImpl.Resource_MakePath(const Filename: string = ''): string;
var
  I                 : Integer;
begin
  if (Filename = '') then
    FTmpFilename := FAppPath
  else if (Filename[1] in ['\', '/', ':', '.']) then
    FTmpFilename := Filename
  else
    FTmpFilename := FAppPath + Filename;

  for I := 1 to Length(FTmpFilename) do
    if (FTmpFilename[I] = '/') then
      FTmpFilename[I] := '\';

  Result := FTmpFilename;
end;

procedure THGEImpl.Resource_RemoveAllPacks;
var
  ResItem, ResNextItem: PResourceList;
begin
  ResItem := FRes;
  while Assigned(ResItem) do begin
    ResNextItem := ResItem.Next;
    if ResItem.Lib <> nil then ResItem.Lib.Free;
    Dispose(ResItem);
    ResItem := ResNextItem;
  end;
  FRes := nil;
end;

procedure THGEImpl.Resource_RemovePack(const Filename: string);
var
  Name              : string;
  ResItem, ResPrev  : PResourceList;
begin
  ResItem := FRes;
  ResPrev := nil;
  Name := UpperCase(Resource_MakePath(Filename));

  while Assigned(ResItem) do begin
    if (Name = ResItem.Filename) then begin
      if Assigned(ResPrev) then
        ResPrev.Next := ResItem.Next
      else
        FRes := ResItem.Next;
      if ResItem.Lib <> nil then ResItem.Lib.Free;
      Dispose(ResItem);
      Break;
    end;
    ResPrev := ResItem;
    ResItem := ResItem.Next;
  end;
end;

procedure THGEImpl.SetBlendMode(const Blend: Integer);
begin
  {if ((Blend and BLEND_ALPHABLEND) <> (FCurBlendMode and BLEND_ALPHABLEND)) then begin
    if ((Blend and BLEND_ALPHABLEND) <> 0) then
      FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA)
    else
      FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
  end;

  if ((Blend and BLEND_ZWRITE) <> (FCurBlendMode and BLEND_ZWRITE)) then begin
    if ((Blend and BLEND_ZWRITE) <> 0) then
      FD3DDevice.SetRenderState(D3DRS_ZWRITEENABLE, 1)
    else
      FD3DDevice.SetRenderState(D3DRS_ZWRITEENABLE, 0);
  end;

  if ((Blend and BLEND_COLORADD) <> (FCurBlendMode and BLEND_COLORADD)) then begin
    if ((Blend and BLEND_COLORADD) <> 0) then
      FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_ADD)
    else
      FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
  end;

  FCurBlendMode := Blend;

  Exit;}

  if FCurBlendMode = Blend then
    Exit;

  FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
  case Blend of
    BLEND_DEFAULT: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
      end;
    BLEND_COLORADD: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
        FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_ADD);
      end;
    Blend_Add: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
      end;
    Blend_SrcAlphaAdd: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
      end;
    Blend_SrcColor: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
      end;
    BLEND_SrcColorAdd: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
      end;
    Blend_Invert: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ZERO);
      end;
    Blend_SrcBright: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCCOLOR);
      end;
    Blend_Multiply: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCCOLOR);
      end;
    Blend_InvMultiply: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
      end;
    Blend_MultiplyAlpha: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCALPHA);
      end;
    Blend_InvMultiplyAlpha: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
      end;
    Blend_DestBright: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_DESTCOLOR);
      end;
    Blend_InvSrcBright: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVSRCCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
      end;
    Blend_InvDestBright: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVDESTCOLOR);
      end;
    Blend_Bright: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
        FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
      end;
    Blend_BrightAdd: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
        FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE4X);
      end;
    Blend_GrayScale: begin
        FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, Integer(False));
        FD3DDevice.SetRenderState(D3DRS_TEXTUREFACTOR, Integer((ARGB(255, 255, 155, 155))));
        FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_DOTPRODUCT3);
        FD3DDevice.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_TFACTOR);
      end;
    Blend_Light: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
        FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
      end;
    Blend_LightAdd: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
        FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE4X);
      end;
    Blend_Add2X: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
        FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
      end;
    Blend_OneColor: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
        FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, 25);
        FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
      end;
    Blend_XOR: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
      end;
    Blend_Anti: begin
        FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
        FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
      end;
  end;

  FCurBlendMode := Blend;
end;

procedure THGEImpl.SetFXVolume(const Vol: Integer);
begin
  if (FBass <> 0) then
    BASS_SetConfig(BASS_CONFIG_GVOL_SAMPLE, Vol);
end;

procedure THGEImpl.SetMusVolume(const Vol: Integer);
begin
  if (FBass <> 0) then
    BASS_SetConfig(BASS_CONFIG_GVOL_MUSIC, Vol);
end;

procedure THGEImpl.SetProjectionMatrix(const Width, Height: Integer);
var
  Tmp               : TD3DXMatrix;
begin
  D3DXMatrixScaling(FMatProj, 1.0, -1.0, 1.0);
  D3DXMatrixTranslation(Tmp, -0.5, Height + 0.5, 0.0);
  D3DXMatrixMultiply(FMatProj, FMatProj, Tmp);
  D3DXMatrixOrthoOffCenterLH(Tmp, 0, Width, 0, Height, 0.0, 1.0);
  D3DXMatrixMultiply(FMatProj, FMatProj, Tmp);
end;

procedure THGEImpl.SetSystemCommandFunc(Proc: THGESysCommandCallBack);
begin
  FSystemCommandFunc := Proc;
end;

function THGEImpl.GetLastHgeError: string;
begin
  Result := FLastErrorStr;
end;

procedure THGEImpl.SoundDone;
begin
  if (FBass <> 0) then begin
    BASS_Stop;
    BASS_Free;
    FinalizeBassDLL;
    FBass := 0;
  end;
end;

function THGEImpl.SoundInit: Boolean;
begin
  if (not FUseSound) or (FBass <> 0) then begin
    Result := True;
    Exit;
  end;
  Result := False;

  if (InitializeBassDLL) then
    FBass := GetBassDLLHandle
  else
    FBass := 0;

  if (FBass = 0) then begin
    PostError('Can''t load BASS.DLL');
    //MessageBox(0, 'BASS.DLL  不存在或装载错误', 'Err', MB_OK);
    Exit;
  end;

  if (HIWORD(BASS_GetVersion) <> BASSVERSION) then begin
    PostError('Incorrect BASS.DLL version');
    //MessageBox(0, 'BASS.DLL  版本错误！', 'Err', MB_OK);
    Exit;
  end;

  FSilent := False;
  if (not BASS_Init(-1, FSampleRate, 0, FWnd, nil)) then begin
    System_Log('BASS Init failed, using no sound');
    BASS_Init(0, FSampleRate, 0, FWnd, nil);
    FSilent := True;
  end else begin
    System_Log('Sound Device: %s', [BASS_GetDeviceDescription(1)]);
    System_Log('Sample rate: %d', [FSampleRate]);
  end;

  SetFXVolume(FFXVolume);
  SetMusVolume(FMusVolume);

  Result := True;
end;

function THGEImpl.Stream_Load(const Filename: string): IStream;
var
  Data              : IResource;
  Size              : Integer;
begin
  Data := Resource_Load(Filename, @Size);
  if (Data = nil) then
    Result := nil
  else begin
    Result := Stream_Load(Data, Size);
  end;
end;

function THGEImpl.Stream_Load(const Data: Pointer; const Size: Longword): IStream;
var
  Handle            : HStream;
begin
  if (FBass <> 0) then begin
    if (FSilent) then begin
      Result := nil;
      Exit;
    end;

    Handle := BASS_StreamCreateFile(True, Data, 0, Size, 0);
    if (Handle = 0) then begin
      PostError('Can''t load stream');
      Result := nil;
      Exit;
    end;
    Result := TStream.Create(Handle, nil);
  end else
    Result := nil;
end;

function THGEImpl.Stream_Load(const Resource: IResource; const Size: Longword): IStream;
var
  Handle            : HStream;
begin
  if (FBass <> 0) then begin
    if (FSilent) then begin
      Result := nil;
      Exit;
    end;

    Handle := BASS_StreamCreateFile(True, Resource.Handle, 0, Size, 0);
    if (Handle = 0) then begin
      PostError('Can''t load stream');
      Result := nil;
      Exit;
    end;
    Result := TStream.Create(Handle, Resource);
  end else
    Result := nil;
end;

function THGEImpl.Stream_Play(const Stream: IStream; const Loop: Boolean;
  const Volume: Integer): IChannel;
begin
  Result := Stream.Play(Loop, Volume);
end;

function THGEImpl.System_GetErrorMessage: string;
begin
  Result := FError;
end;

function THGEImpl.System_GetState(const State: THGEStringState): string;
begin
  case State of
    HGE_ICON:
      Result := FIcon;
    HGE_TITLE:
      Result := FWinTitle;
    HGE_INIFILE:
      Result := FIniFile;
    HGE_LOGFILE:
      Result := FLogFile;
  else
    Result := '';
  end;
end;

function THGEImpl.System_GetState(const State: THGEIntState): Integer;
begin
  case State of
    HGE_SCREENWIDTH:
      Result := FScreenWidth;
    HGE_SCREENHEIGHT:
      Result := FScreenHeight;
    HGE_SCREENBPP:
      Result := FScreenBPP;
    HGE_SAMPLERATE:
      Result := FSampleRate;
    HGE_FXVOLUME:
      Result := FFXVolume;
    HGE_MUSVOLUME:
      Result := FMusVolume;
    HGE_FPS:
      Result := FHGEFPS;
    HGE_WINDOWSTATE:
      Result := FWindowState;
  else
    Result := 0;
  end;
end;

function THGEImpl.System_GetState(const State: THGEFuncState): THGECallback;
begin
  case State of
    HGE_FRAMEFUNC:
      Result := FProcFrameFunc;
    HGE_RENDERFUNC:
      Result := FProcRenderFunc;
    HGE_FOCUSLOSTFUNC:
      Result := FProcFocusLostFunc;
    HGE_FOCUSGAINFUNC:
      Result := FProcFocusGainFunc;
    HGE_EXITFUNC:
      Result := FProcExitFunc;
    HGE_RESIZE:
      Result := FProcResize;
    HGE_IMGCACHEFUNC:
      Result := FProcImgCacheFunc;
  else
    Result := nil;
  end;
end;

function THGEImpl.System_GetState(const State: THGEBoolState): Boolean;
begin
  case State of
    HGE_WINDOWED:
      Result := FWindowed;
    HGE_ZBUFFER:
      Result := FZBuffer;
    HGE_TEXTUREFILTER:
      Result := FTextureFilter;
    HGE_USESOUND:
      Result := FUseSound;
    HGE_DONTSUSPEND:
      Result := FDontSuspend;
    HGE_HIDEMOUSE:
      Result := FHideMouse;
    HGE_NOBORDER:
      Result := FNoBorder;
    HGE_ACTIVE:
      Result := Windows.GetFocus = FWnd;
{$IFDEF DEMO}
    HGE_SHOWSPLASH:
      Result := FDMO;
{$ENDIF}
  else
    Result := False;
  end;
end;

function THGEImpl.System_GetState(const State: THGEHWndState): hWnd;
begin
  case State of
    HGE_HWND:
      Result := FWnd;
    HGE_HWNDPARENT:
      Result := FWndParent;
  else
    Result := 0;
  end;
end;

function THGEImpl.System_Initiate: Boolean;
var
  OSVer             : TOSVersionInfo;
  TM                : TSystemTime;
  MemSt             : TMemoryStatus;
  WinClass          : TWndClass;
  Width, Height     : Integer;
{$IFDEF DEMO}
  Func, RFunc       : THGECallback;
  HWndTmp           : hWnd;
{$ENDIF}
  //HMainMenu                 : HMENU;
  boRt              : Boolean;
begin
  Result := False;
  // Log system info

  //System_Log('System Started...');
  //System_Log('================================================================================');

  //System_Log('HGE version: %x.%x', [HGE_VERSION shr 8, HGE_VERSION and $FF]);
  GetLocalTime(TM);
  System_Log('DateTime: %02d.%02d.%d, %02d:%02d:%02d', [TM.wDay, TM.wMonth, TM.wYear, TM.wHour, TM.wMinute, TM.wSecond]);

  //System_Log('Application: %s', [FWinTitle]);
  OSVer.dwOSVersionInfoSize := SizeOf(OSVer);
  GetVersionEx(OSVer);
  //System_Log('OS: Windows %d.%d.%d', [OSVer.dwMajorVersion, OSVer.dwMinorVersion, OSVer.dwBuildNumber]);

  GlobalMemoryStatus(MemSt);
  System_Log('Memory: %dM total, %dM free', [MemSt.dwTotalPhys div 1048576, MemSt.dwAvailPhys div 1048576]);

  // Register window class

  FillChar(WinClass, SizeOf(WinClass), 0);
  WinClass.Style := CS_DBLCLKS or CS_OWNDC or CS_HREDRAW or CS_VREDRAW;
  WinClass.lpfnWndProc := @WindowProc;
  WinClass.hInstance := FInstance;
  WinClass.hCursor := LoadCursor(0, IDC_ARROW);
  WinClass.hbrBackground := HBrush(GetStockObject(BLACK_BRUSH));
  WinClass.lpszClassName := WINDOW_CLASS_NAME;
  if (FIcon <> '') then
    WinClass.hIcon := LoadIcon(FInstance, PChar(FIcon))
  else
    WinClass.hIcon := LoadIcon(0, IDI_APPLICATION);

  if (RegisterClass(WinClass) = 0) then begin
    PostError('Can''t register window class');
    Exit;
  end;

  // Create window
  {if FNoBorder then begin
    Width := FScreenWidth + GetSystemMetrics(SM_CXFIXEDFRAME) * 2;
    Height := FScreenHeight + GetSystemMetrics(SM_CYFIXEDFRAME) * 2;
    FStyleW := WS_POPUP or WS_VISIBLE or WS_SIZEBOX; //or WS_OVERLAPPED or WS_SYSMENU or WS_MINIMIZEBOX;
  end else begin
    Width := FScreenWidth + GetSystemMetrics(SM_CXFIXEDFRAME) * 2;
    Height := FScreenHeight + GetSystemMetrics(SM_CYFIXEDFRAME) * 2 + GetSystemMetrics(SM_CYCAPTION);
    FStyleW := WS_POPUP or WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX or WS_VISIBLE; //WS_OVERLAPPED | WS_SYSMENU | WS_MINIMIZEBOX;
  end;}

  FStyleW :=	WS_POPUP or WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX or WS_VISIBLE;

  FRectW.Left := GetSystemMetrics(SM_CXSCREEN) div 2 - FScreenWidth div 2;
  FRectW.Top := GetSystemMetrics(SM_CYSCREEN) div 2 - FScreenHeight div 2;
  FRectW.Right := FRectW.Left + FScreenWidth;
  FRectW.Bottom := FRectW.Top + FScreenHeight;

  	// Fix for styled windows in Windows versions newer than XP     //444
	AdjustWindowRect(FRectW, FStyleW, false);

  FRectFS.Left := 0;
  FRectFS.Top := 0;
  FRectFS.Right := FScreenWidth;
  FRectFS.Bottom := FScreenHeight;
  FStyleFS := WS_POPUP or WS_VISIBLE;

  if (FWndParent <> 0) then begin
    FRectW.Left := 0;
    FRectW.Top := 0;
    FRectW.Right := FScreenWidth;
    FRectW.Bottom := FScreenHeight;
    FStyleW := WS_CHILD or WS_VISIBLE;
    FWindowed := True;
  end;

  //System_Log('%d %d %d %d', [FRectW.Left, FRectW.Top, FRectW.Right - FRectW.Left, FRectW.Bottom - FRectW.Top]);

  if (FWindowed) then
    FWnd := CreateWindowEx(0, WINDOW_CLASS_NAME, PChar(FWinTitle), FStyleW,
      FRectW.Left, FRectW.Top, FRectW.Right - FRectW.Left,
      FRectW.Bottom - FRectW.Top, FWndParent, 0, FInstance, nil)
  else
    FWnd := CreateWindowEx(WS_EX_TOPMOST, WINDOW_CLASS_NAME, PChar(FWinTitle),
      FStyleFS, 0, 0, 0, 0, 0, 0, FInstance, nil);
      
  if (FWnd = 0) then begin
    PostError('Can''t create window');
    Exit;
  end;

  {HMainMenu := GetSystemMenu(FWnd, False);
  if HMainMenu <> 0 then begin
    InsertMenu(HMainMenu, 0, MF_BYPOSITION, ID_SYSMENU_DEFRATE, '恢复默认分辨率');
    InsertMenu(HMainMenu, 1, MF_BYPOSITION + MF_SEPARATOR, 0, '-');
  end;}

  ShowWindow(FWnd, SW_SHOW);

  // Init subsystems

  TimeBeginPeriod(1);
  Random_Seed;
  InputInit;
  if (not GfxInit) then begin
    System_Shutdown;
    Exit;
  end;
  if (not SoundInit) then begin
    //System_Shutdown;
    Exit;
  end;

  //System_Log('System Initiated');

  FTime := 0.0;
  FT0 := timeGetTime;
  FT0FPS := FT0;
  FDT := 0;
  FCFPS := 0;
  FFPS := 0;

  // Show splash

{$IFDEF DEMO}
  if (FDMO) then begin // Commercial version magic
    //Sleep(0 {200});
    Func := System_GetState(HGE_FRAMEFUNC);
    RFunc := System_GetState(HGE_RENDERFUNC);
    HWndTmp := FWndParent;
    FWndParent := 0;
    System_SetState(HGE_FRAMEFUNC, DFrame);
    System_SetState(HGE_RENDERFUNC, THGECallback(nil));
    DInit;
    boRt := System_Start;
    DDone;
    FWndParent := HWndTmp;
    System_SetState(HGE_FRAMEFUNC, Func);
    System_SetState(HGE_RENDERFUNC, RFunc);
    if not boRt then
      Exit;
  end;
{$ENDIF}

  // Done

  Result := True;
end;

function THGEImpl.System_Launch(const Url: string): Boolean;
begin
  if (ShellExecute(FWnd, nil, PChar(Url), nil, nil, SW_SHOWMAXIMIZED) > 32) then
    Result := True
  else
    Result := False;
end;

procedure THGEImpl.System_Log(const S: string);
begin
  System_Log(S, []);
end;

procedure THGEImpl.System_Log(const Format: string; const Args: array of const);
var
  fChanged          : Boolean;
  Attr              : Integer;
  HF                : THandle;
  S                 : string;
  BytesWritten      : Cardinal;
begin
  if (FLogFile = '') then
    Exit;

  if FileExists(FLogFile) then begin
    fChanged := False;
    Attr := FileGetAttr(FLogFile);
    if Attr and faReadOnly = faReadOnly then begin
      Attr := Attr xor faReadOnly;
      fChanged := True;
    end;
    if Attr and faSysFile = faSysFile then begin
      Attr := Attr xor faSysFile;
      fChanged := True;
    end;
    if Attr and faHidden = faHidden then begin
      Attr := Attr xor faHidden;
      fChanged := True;
    end;
    if fChanged then
      FileSetAttr(FLogFile, Attr);
  end;

  HF := CreateFile(PChar(FLogFile), GENERIC_WRITE, FILE_SHARE_READ, nil,
    OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if (HF = 0) then
    Exit;

  try
    SetFilePointer(HF, 0, nil, FILE_END);
    S := SysUtils.Format(Format, Args) + CRLF;
    WriteFile(HF, S[1], Length(S), BytesWritten, nil);
  finally
    CloseHandle(HF);
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEStringState;
  const Value: string);
var
  fChanged          : Boolean;
  Attr              : Integer;
  HF                : THandle;
begin
  case State of
    HGE_ICON: begin
        FIcon := Value;
        if (FWnd <> 0) then
          SetClassLong(FWnd, GCL_HICON, LoadIcon(FInstance, PChar(FIcon)));
      end;
    HGE_TITLE: begin
        FWinTitle := Value;
        if (FWnd <> 0) then
          SetWindowText(FWnd, PChar(FWinTitle));
      end;
    HGE_INIFILE:
      if (Value <> '') then
        FIniFile := Resource_MakePath(Value)
      else
        FIniFile := '';
    HGE_LOGFILE:
      if (Value <> '') then begin
        FLogFile := Resource_MakePath(Value);

        if FileExists(FLogFile) then begin
          fChanged := False;
          Attr := FileGetAttr(FLogFile);
          if Attr and faReadOnly = faReadOnly then begin
            Attr := Attr xor faReadOnly;
            fChanged := True;
          end;
          if Attr and faSysFile = faSysFile then begin
            Attr := Attr xor faSysFile;
            fChanged := True;
          end;
          if Attr and faHidden = faHidden then begin
            Attr := Attr xor faHidden;
            fChanged := True;
          end;
          if fChanged then
            FileSetAttr(FLogFile, Attr);
        end;

        HF := CreateFile(PChar(FLogFile), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
        if (HF <> INVALID_HANDLE_VALUE) then begin
          if (GetFileSize(HF, nil) > 4 * 1024 * 1024) then begin
            CloseHandle(HF);
            HF := CreateFile(PChar(FLogFile), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
          end;
        end;

        if (HF = INVALID_HANDLE_VALUE) then
          FLogFile := ''
        else
          CloseHandle(HF);

      end else
        FLogFile := '';
  end;
end;

type
  TWindowState = (wsNormal, wsMinimized, wsMaximized);

procedure THGEImpl.System_SetState(const State: THGEIntState;
  const Value: Integer);
const
  ShowCommands      : array[TWindowState] of Integer = (SW_SHOWNORMAL, SW_MINIMIZE, SW_SHOWMAXIMIZED);
begin
  case State of
    HGE_SCREENWIDTH:
      if (FD3DDevice = nil) then
        FScreenWidth := Value
			else if (FScreenWidth <> Value) then begin
				FScreenWidth := Value;
				GfxReInit();
      end;  
    HGE_SCREENHEIGHT:
      if (FD3DDevice = nil) then
        FScreenHeight := Value
			else if (FScreenHeight <> Value) then begin
				FScreenHeight := Value;
				GfxReInit();
      end;  
    HGE_SCREENBPP:
      if (FD3DDevice = nil) then
        FScreenBPP := Value;
    HGE_SAMPLERATE:
      if (FBass = 0) then
        FSampleRate := Value;
    HGE_FXVOLUME: begin
        FFXVolume := Value;
        SetFXVolume(FFXVolume);
      end;
    HGE_MUSVOLUME: begin
        FMusVolume := Value;
        SetMusVolume(FMusVolume);
      end;
    HGE_FPS: begin
        if Assigned(FVertArray) then
          Exit;
        if Assigned(FD3DDevice) then begin
          if (((FHGEFPS >= 0) and (Value < 0)) or ((FHGEFPS < 0) and (Value >= 0))) then begin
            if (Value = HGEFPS_VSYNC) then begin
{$IFDEF DX8}
              FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY_VSYNC;
              FD3DPPFS.FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_ONE;
{$ELSE}
              FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY;
              FD3DPPFS.PresentationInterval := D3DPRESENT_INTERVAL_ONE;
{$ENDIF}
            end else begin
              FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY;
{$IFDEF DX8}
              FD3DPPFS.FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
{$ELSE}
              FD3DPPFS.PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
{$ENDIF}
            end;
            //            if Assigned(FProcFocusLostFunc) then
            //              FProcFocusLostFunc;
            GfxRestore();
            //            if Assigned(FProcFocusGainFunc) then
            //              FProcFocusGainFunc;
          end;
        end;
        FHGEFPS := Value;
        if (FHGEFPS > 0) then
          FFixedDelta := 1000 div Value
        else
          FFixedDelta := 0;
      end;
    HGE_WINDOWSTATE: begin //设置窗口显示模式
        if FWindowed and (FWindowState <> Value) and (Value < 3) then begin
          ShowWindow(FWnd, ShowCommands[TWindowState(Value)]);
          FWindowState := Value;
        end;
      end;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEBoolState;
  const Value: Boolean);
begin
  case State of
    HGE_WINDOWED: begin
        if (Assigned(FVertArray) or (FWndParent <> 0)) then
          Exit;
        if (Assigned(FD3DDevice) and (FWindowed <> Value)) then begin
          if (FD3DPPW.BackBufferFormat = D3DFMT_UNKNOWN)
            or (FD3DPPFS.BackBufferFormat = D3DFMT_UNKNOWN) then
            Exit;

          if (FWindowed) then
            GetWindowRect(FWnd, FRectW);
          FWindowed := Value;
          if (FWindowed) then
            FD3DPP := @FD3DPPW
          else
            FD3DPP := @FD3DPPFS;

          if (FormatId(FD3DPPW.BackBufferFormat) < 4) then
            FScreenBPP := 16
          else
            FScreenBPP := 32;

          GfxRestore;
          AdjustWindow;
        end else
          FWindowed := Value;
      end;
    HGE_ZBUFFER:
      if (FD3DDevice = nil) then
        FZBuffer := Value;
    HGE_TEXTUREFILTER: begin
        FTextureFilter := Value;
        if Assigned(FD3DDevice) then begin
          RenderBatch;
          if (FTextureFilter) then begin
{$IFDEF DX8}
            FD3DDevice.SetTextureStageState(0, D3DTSS_MAGFILTER, D3DTEXF_LINEAR);
            FD3DDevice.SetTextureStageState(0, D3DTSS_MINFILTER, D3DTEXF_LINEAR);
{$ELSE}
            FD3DDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
            FD3DDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
{$ENDIF}
          end else begin
{$IFDEF DX8}
            FD3DDevice.SetTextureStageState(0, D3DTSS_MAGFILTER, D3DTEXF_POINT);
            FD3DDevice.SetTextureStageState(0, D3DTSS_MINFILTER, D3DTEXF_POINT);
{$ELSE}
            FD3DDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_POINT);
            FD3DDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_POINT);
{$ENDIF}
          end;
        end;
      end;
    HGE_USESOUND: begin
        if (FUseSound <> Value) then begin
          FUseSound := Value;
          if FUseSound and (FWnd <> 0) then
            SoundInit();
          if (not FUseSound) and (FWnd <> 0) then
            SoundDone();
        end;
      end;
    HGE_HIDEMOUSE:
      FHideMouse := Value;
    HGE_DONTSUSPEND:
      FDontSuspend := Value;
    HGE_NOBORDER:
      FNoBorder := Value;
{$IFDEF DEMO}
    HGE_SHOWSPLASH:
      FDMO := Value;
{$ENDIF}
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEFuncState;
  const Value: THGECallback);
begin
  case State of
    HGE_FRAMEFUNC:
      FProcFrameFunc := Value;
    HGE_RENDERFUNC:
      FProcRenderFunc := Value;
    HGE_FOCUSLOSTFUNC:
      FProcFocusLostFunc := Value;
    HGE_FOCUSGAINFUNC:
      FProcFocusGainFunc := Value;
    HGE_GFXRESTOREFUNC:
      FProcGfxRestoreFunc := Value;
    HGE_EXITFUNC:
      FProcExitFunc := Value;
    HGE_RESIZE:
      FProcResize := Value;
    HGE_IMGCACHEFUNC:
      FProcImgCacheFunc := Value;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEFuncState;
  const Value: THGEEventCallback);
begin
  case State of
    HGE_MOUNTEVENT:
      FProcEvent := Value;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEHWndState;
  const Value: hWnd);
begin
  case State of
    HGE_HWNDPARENT:
      if (FWnd = 0) then
        FWndParent := Value;
  end;
end;

procedure THGEImpl.System_Shutdown;
begin
  //System_Log(CRLF + 'Finishing...');
  timeEndPeriod(1);
  ClearQueue;
  SoundDone;
  GfxDone;
  if (FWnd <> 0) then begin
    //ShowWindow(hwnd, SW_HIDE);
    //SetWindowLong(hwnd, GWL_EXSTYLE, GetWindowLong(hwnd, GWL_EXSTYLE) | WS_EX_TOOLWINDOW);
    //ShowWindow(hwnd, SW_SHOW);
    DestroyWindow(FWnd);
    FWnd := 0;
  end;
  if (FInstance <> 0) then
    UnregisterClass(WINDOW_CLASS_NAME, FInstance);

  //System_Log('The End');
  //System_Log('================================================================================' + CRLF);
  System_Log(CRLF + CRLF);
end;

procedure THGEImpl.System_Snapshot(const Filename: string);
var
  Surf              : IDirect3DSurface;
  ShotName          : string;
  I                 : Integer;
  //LR                        : TD3DLockedRect;
begin
  if (Filename = '') then begin
    I := 0;
    ShotName := Resource_EnumFiles('Shot???.bmp');
    while (ShotName <> '') do begin
      Inc(I);
      ShotName := Resource_EnumFiles;
    end;
    ShotName := Resource_MakePath(Format('Shot%3d.bmp', [I]));
  end else
    ShotName := Filename;

  if Assigned(FD3DDevice) then begin
    if Succeeded(FD3DDevice.GetBackBuffer({$IFDEF DX9}0, {$ENDIF}0, D3DBACKBUFFER_TYPE_MONO, Surf)) then begin
      D3DXSaveSurfaceToFile(PChar(ShotName), D3DXIFF_BMP, Surf, nil, nil);
    end;
  end;
end;

{$IF CUSTOMUI_SAVE}
procedure THGEImpl.Texture_SaveToFile(SrcTexture: IDirect3DBaseTexture; const Filename: string);
begin
  if SrcTexture <> nil then begin
    if Failed(D3DXSaveTextureToFile(PChar(Filename), D3DXIFF_BMP, SrcTexture, nil)) then
      PostError('HGE::Texture_SaveToFile Fail');
  end;
end;
{$IFEND}

function THGEImpl.System_Start: Boolean;
var
  Msg               : TMsg;
begin
  Result := False;
  if (FWnd = 0) then begin
    PostError('System_Start: System_Initiate wasn''t called');
    Exit;
  end;

  if (not Assigned(FProcFrameFunc)) then begin
    PostError('System_Start: No frame function defined');
    Exit;
  end;

  FActive := True;

  // MAIN LOOP
  while True do begin

    // Process window messages if not in "child mode"
    // (if in "child mode" the parent application will do this for us)
    if (FWndParent = 0) then begin
      if (PeekMessage(Msg, 0, 0, 0, PM_REMOVE)) then begin
        if (Msg.Message = WM_QUIT) then begin
          ClearQueue;
          FActive := False;
          Exit;
        end;
        //TranslateMessage(Msg);          //ime 1109
        DispatchMessage(Msg);
        //Sleep(1);                       //2345  Lower FPS
        Continue;
      end;
    end;

    // Check if mouse is over HGE window for Input_IsMouseOver

    //UpdateMouse();       无需

    // If HGE window is focused or we have the "don't suspend" state - process the main loop

    //g_boRender := False;
    if (FActive or FDontSuspend) then begin
      // Ensure we have at least 1ms time step
      // to not confuse user's code with 0
      //repeat
      FDT := timeGetTime - FT0;
      //until (FDT >= 1);

      // If we reached the time for the next frame
      // or we just run in unlimited FPS mode, then
      // do the stuff
      if (FDT >= FFixedDelta) then begin
        // fDeltaTime = time step in seconds returned by Timer_GetDelta
        FDeltaTime := FDT / 1000.0;

        // Cap too large time steps usually caused by lost focus to avoid jerks
        if (FDeltaTime > 0.2) then begin
          if (FFixedDelta <> 0) then
            FDeltaTime := FFixedDelta / 1000.0
          else
            FDeltaTime := 0.01;
        end;
        // Update time counter returned Timer_GetTime
        FTime := FTime + FDeltaTime;

        // Store current time for the next frame
        // and count FPS
        FT0 := timeGetTime;
        if (FT0 - FT0FPS <= 1000) then
          Inc(FCFPS)
        else begin
          FFPS := FCFPS;
          FCFPS := 0;
          FT0FPS := FT0;
        end;

        // Do user's stuff
        try
          if (FProcFrameFunc) then
            Break;

          if Assigned(FProcRenderFunc) then
            FProcRenderFunc;
        except
          on E: Exception do
            PHGE.System_Log(E.Message);
        end;

        // If if "child mode" - return after processing single frame
        if (FWndParent <> 0) then
          Break;

        // Clean up input events that were generated by
        // WindowProc and weren't handled by user's code
        ClearQueue;

        // If we use VSYNC - we could afford a little
        // sleep to lower CPU usage
        //        if (not FWindowed) and (FHGEFPS = HGEFPS_VSYNC) then
        //          Sleep(1);
      end else begin
        //if ((FFixedDelta <> 0) and (FDT + 3 < FFixedDelta)) then
        //  Sleep(1);

        if (FFixedDelta <> 0) then begin //1111
          if Assigned(FProcImgCacheFunc) and (FDT + 1 < FFixedDelta) then
            FProcImgCacheFunc;
          Sleep(1);
        end;
      end;
    end else
      // If main loop is suspended - just sleep a bit
      // (though not too much to allow instant window
      // redraw if requested by OS)
      Sleep(1);
  end;
  ClearQueue;
  FActive := False;
  Result := True;
end;

function THGEImpl.Target_Create(const Width, Height: Integer;
  const ZBuffer: Boolean): ITarget;
var
  Tex               : ITexture;
  DXTexture         : IDirect3DTexture;
  Depth             : IDirect3DSurface;
  Desc              : TD3DSurfaceDesc;
begin
  Result := nil;

  if (Failed(D3DXCreateTexture(FD3DDevice, Width, Height, 1, D3DUSAGE_RENDERTARGET,
    FD3DPP.BackBufferFormat, D3DPOOL_DEFAULT, DXTexture))) then begin
    PostError('Can''t create render target texture');
    Exit;
  end;

  Tex := TTexture.Create(DXTexture, Width, Height{$IFDEF DYNTEX}, FSuportsDynamicTextures{$ENDIF});

  DXTexture.GetLevelDesc(0, Desc);

  if (ZBuffer) then begin
    if (Failed(FD3DDevice.CreateDepthStencilSurface(Desc.Width, Desc.Height,
      D3DFMT_D16, D3DMULTISAMPLE_NONE, {$IFDEF DX8}Depth{$ELSE}0, False, Depth, nil{$ENDIF}))) then begin
      PostError('Can''t create render target depth buffer');
      //Tex := nil;                       //1234
      Exit;
    end;
  end else
    Depth := nil;

  Result := TTarget.Create(Desc.Width, Desc.Height, Tex, Depth);
end;

function THGEImpl.Target_GetTexture(const Target: ITarget): ITexture;
begin
  if Assigned(Target) then
    Result := Target.Tex
  else
    Result := nil;
end;

function THGEImpl.Texture_Create({$IFDEF DYNTEX}IsDynTex: Boolean; {$ENDIF}const Width, Height: Integer; Format: TD3DFormat = D3DFMT_A8R8G8B8): ITexture;
var
  PTex              : IDirect3DTexture;
const
  szStr             = 'Can''t create texture 1';
begin
{$IFDEF DYNTEX}
  if FSuportsDynamicTextures and IsDynTex then begin
    if (Failed(D3DXCreateTexture(FD3DDevice, Width, Height,
      1, // Mip levels
      D3DUSAGE_DYNAMIC, // Usage
      Format, // Format
      D3DPOOL_DEFAULT, // Memory pool
      PTex))) then begin
      PostError(szStr);
      Result := nil;
    end else begin
      Result := TTexture.Create(PTex, Width, Height, IsDynTex);
    end;
    Exit;
  end;
{$ENDIF}

  if (Failed(D3DXCreateTexture(FD3DDevice, Width, Height,
    1, // Mip levels
    0, // Usage          0 - D3DUSAGE_DYNAMIC   //0523
    Format, // Format
    D3DPOOL_MANAGED, // Memory pool    1 - 0
    PTex))) then begin
    PostError(szStr);
    Result := nil;
  end else begin
    Result := TTexture.Create(PTex, Width, Height{$IFDEF DYNTEX}, False{$ENDIF});
  end;
end;

function THGEImpl.Texture_GetHeight(const Tex: ITexture;
  const Original: Boolean): Integer;
begin
  Result := Tex.GetHeight(Original);
end;

function THGEImpl.Texture_GetWidth(const Tex: ITexture;
  const Original: Boolean): Integer;
begin
  Result := Tex.GetWidth(Original);
end;

function THGEImpl.Texture_LoadJPEG2000(const Data: Pointer;
  const Size: Longword; const Mipmap: Boolean;
  const Format: TOPJ_CodecFormat): ITexture;
var
  Params            : TOPJ_DParameters;
  Info              : POPJ_DInfo;
  CIO               : POPJ_CIO;
  Image             : POPJ_Image;
  I, MipmapLevels, X, Y: Integer;
  PTex              : IDirect3DTexture;
  LR                : TD3DLockedRect;
  SD                : TD3DSurfaceDesc;
  SR, SG, SB        : PByte;
  D1, D2            : PCardinal;
begin
  Result := nil;

  opj_set_default_decoder_parameters(Params);
  Info := opj_create_decompress(Format);
  if (Info = nil) then begin
    PostError('Cannot load JPEG2000 image');
    Exit;
  end;

  CIO := nil;
  Image := nil;
  try
    CIO := opj_cio_open(Info, Data, Size);
    if (CIO = nil) then begin
      PostError('Cannot load JPEG2000 image');
      Exit;
    end;
    opj_setup_decoder(Info, Params);

    Image := opj_decode(Info, CIO);
    if (Image = nil) then begin
      PostError('Cannot load JPEG2000 image');
      Exit;
    end;

    { Only support RGB, 8 bits/channel images }
    if (Image.NumComps <> 3) or (Image.ColorSpace <> ClrSpcSRGB) or (Image.Comps[0].PRec <> 8) then begin
      PostError('Unsupported  JPEG2000 image');
      Exit;
    end;

    { Don't support subsampled images and signed images }
    for I := 0 to 2 do
      if (Image.Comps[I].DX <> 1) or (Image.Comps[I].DY <> 1)
        or (Image.Comps[I].Sgnd = 1) then begin
        PostError('Unsupported  JPEG2000 image');
        Exit;
      end;

    { Create texture }
    if (Mipmap) then
      MipmapLevels := 0
    else
      MipmapLevels := 1;

    //D3DUSAGE_DYNAMIC
    if (Failed(D3DXCreateTexture(FD3DDevice, Image.X1, Image.Y1, MipmapLevels, 0,
      D3DFMT_A8R8G8B8, D3DPOOL_MANAGED, PTex))) then begin
      PostError('Can''t create texture 2');
      Exit;
    end;

    if (Failed(PTex.GetLevelDesc(0, SD))) then begin
      PostError('Can''t retrieve texture description');
      Exit;
    end;

    if (Failed(PTex.LockRect(0, LR, nil, 0))) then begin
      PostError('Can''t lock texture');
      Exit;
    end;

    try
      { Copy image to texture }
      D1 := LR.pBits;
      for Y := 0 to Image.Y1 - 1 do begin
        SR := @Image.Comps[0].Data[Y * Image.X1];
        SG := @Image.Comps[1].Data[Y * Image.X1];
        SB := @Image.Comps[2].Data[Y * Image.X1];
        D2 := D1;
        for X := 0 to Image.X1 - 1 do begin
          D2^ := $FF000000 or SB^ or (SG^ shl 8) or (SR^ shl 16);
          Inc(SR, 4);
          Inc(SG, 4);
          Inc(SB, 4);
          Inc(D2);
        end;
        Inc(PByte(D1), LR.Pitch);
      end;
    finally
      PTex.UnlockRect(0);
    end;

    { Create mipmap levels if specified }
    if (Mipmap) then
      D3DXFilterTexture(PTex, nil, 0, D3DX_DEFAULT);

    Result := TTexture.Create(PTex, SD.Width, SD.Height{$IFDEF DYNTEX}, FSuportsDynamicTextures{$ENDIF});
  finally
    opj_image_destroy(Image);
    opj_destroy_decompress(Info);
    opj_cio_close(CIO);
  end;
end;

function THGEImpl.Texture_Load(const Filename: string;
  const Mipmap: Boolean; const ColorKey: LongInt): ITexture;
var
  Data              : IResource;
  Size              : Longword;
begin
  Data := Resource_Load(Filename, @Size);
  if (Data = nil) then
    Result := nil
  else begin
    Result := Texture_Load(Data.Handle, Size, Mipmap, ColorKey);
    Data := nil;
  end;
end;

function THGEImpl.Texture_Load(const Data: Pointer; const Size: Longword;
  const Mipmap: Boolean; const ColorKey: LongInt): ITexture;
var
  Fmt1, Fmt2        : TD3DFormat;
  PTex              : IDirect3DTexture;
  Info              : TD3DXImageInfo;
  MipmapLevels      : Integer;
begin
  Result := nil;
  { Check for JPEG2000 file (check for JP2 or J2K header).
    Use JPEG2000 extension to load this texture. }
  if (PLongword(Data)^ = $51FF4FFF) then begin
    Result := Texture_LoadJPEG2000(Data, Size, Mipmap, CodecJ2K);
    Exit;
  end else if (PInt64(Data)^ = $2020506A0C000000) then begin
    Result := Texture_LoadJPEG2000(Data, Size, Mipmap, CodecJP2);
    Exit;
  end;

  if (PLongword(Data)^ = $20534444) then begin // Compressed DDS format magic number
    Fmt1 := D3DFMT_UNKNOWN;
    Fmt2 := D3DFMT_A8R8G8B8;
  end else begin
    Fmt1 := D3DFMT_A8R8G8B8;
    Fmt2 := D3DFMT_UNKNOWN;
  end;

  if (Mipmap) then
    MipmapLevels := 0
  else
    MipmapLevels := 1;

  //D3DX_DEFAULT_NONPOW2
  //D3DUSAGE_DYNAMIC
  if (Failed(D3DXCreateTextureFromFileInMemoryEx(FD3DDevice, Data, Size,
    D3DX_DEFAULT, D3DX_DEFAULT,
    MipmapLevels, // Mip levels
    0, // Usage
    Fmt1, // Format
    D3DPOOL_MANAGED, // Memory pool
    D3DX_FILTER_NONE, // Filter
    D3DX_DEFAULT, // Mip filter
    ColorKey, // Color key     1111
    @Info, nil, PTex))) then begin
    if (Failed(D3DXCreateTextureFromFileInMemoryEx(FD3DDevice, Data, Size,
      D3DX_DEFAULT, D3DX_DEFAULT,
      MipmapLevels, // Mip levels
      0, // Usage
      Fmt2, // Format
      D3DPOOL_MANAGED, // Memory pool    //D3DPOOL_SYSTEMMEM
      D3DX_FILTER_NONE, // Filter
      D3DX_DEFAULT, // Mip filter
      ColorKey, // Color key      1111
      @Info, nil, PTex))) then begin
      PostError('Can''t create texture 3');
      Exit;
    end;
  end;
  Result := TTexture.Create(PTex, Info.Width, Info.Height{$IFDEF DYNTEX}, False{$ENDIF});
end;

function THGEImpl.Texture_Load(const ImageData: Pointer;
  const ImageSize: Longword; const AlphaData: Pointer;
  const AlphaSize: Longword; const Mipmap: Boolean): ITexture;
var
  ImageTexture, AlphaTexture: ITexture;
  A1, A2, I1, I2    : PLongword;
  AlphaMask         : Longword;
  AlphaShift, I, ImageWidth, ImageHeight, AlphaWidth, AlphaHeight: Integer;
  Width, Height, X, Y: Integer;
begin
  Result := nil;
  ImageTexture := Texture_Load(ImageData, ImageSize, False);
  if (ImageTexture = nil) then
    Exit;

  AlphaTexture := Texture_Load(AlphaData, AlphaSize, False);
  if (AlphaTexture = nil) then
    Exit;

  ImageWidth := ImageTexture.GetWidth;
  ImageHeight := ImageTexture.GetHeight;
  AlphaWidth := AlphaTexture.GetWidth;
  AlphaHeight := AlphaTexture.GetHeight;
  Width := Min(ImageWidth, AlphaWidth);
  Height := Min(ImageHeight, AlphaHeight);

  { Check if AlphaTexture has a valid alpha channel. If so, use alpha channel
    for masking. If not, use green channel for masking (it's assumed that the
    alpha image contains a greyscale mask image). }
  AlphaMask := $0000FF00;
  AlphaShift := 16;
  A1 := AlphaTexture.Lock;
  try
    for I := 0 to AlphaWidth * AlphaHeight - 1 do begin
      if ((A1^ and $FF000000) <> $FF000000) then begin
        AlphaMask := $FF000000;
        AlphaShift := 0;
        Break;
      end;
      Inc(A1);
    end;
  finally
    AlphaTexture.Unlock;
  end;

  { Apply alpha information in AlphaTexture to alpha channel in ImageTexture }
  I1 := ImageTexture.Lock(False);
  try
    A1 := AlphaTexture.Lock(True);
    try
      for Y := 0 to Height - 1 do begin
        A2 := A1;
        I2 := I1;
        for X := 0 to Width - 1 do begin
          I2^ := (I2^ and $00FFFFFF) or ((A2^ and AlphaMask) shl AlphaShift);
          Inc(A2);
          Inc(I2);
        end;
        Inc(A1, AlphaWidth);
        Inc(I1, ImageWidth);
      end;
    finally
      AlphaTexture.Unlock;
    end;
  finally
    ImageTexture.Unlock;
  end;

  Result := ImageTexture;
  AlphaTexture := nil;
end;

function THGEImpl.Texture_Load(const ImageFilename, AlphaFilename: string;
  const Mipmap: Boolean): ITexture;
var
  ImageData, AlphaData: IResource;
  ImageSize, AlphaSize: Longword;
begin
  Result := nil;

  ImageData := Resource_Load(ImageFilename, @ImageSize);
  if (ImageData = nil) then
    Exit;

  AlphaData := Resource_Load(AlphaFilename, @AlphaSize);
  if (AlphaData = nil) then
    Exit;

  Result := Texture_Load(ImageData.Handle, ImageSize,
    AlphaData.Handle, AlphaSize, Mipmap);
  ImageData := nil;
  AlphaData := nil;
end;

function THGEImpl.Texture_Lock(const Tex: ITexture; const ReadOnly: Boolean;
  const Left, Top, Width, Height: Integer): PLongword;
begin
  Result := Tex.Lock(ReadOnly, Left, Top, Width, Height);
end;

procedure THGEImpl.Texture_Unlock(const Tex: ITexture);
begin
  Tex.Unlock;
end;

function THGEImpl.Timer_GetDelta: Single;
begin
  Result := FDeltaTime;
end;

function THGEImpl.Timer_GetFPS: Integer;
begin
  Result := FFPS;
end;

function THGEImpl.Timer_GetTime: Single;
begin
  Result := FTime;
end;

procedure THGEImpl.UpdateMouse;
var
  p                 : TPoint;
  R                 : TRect;
begin
  GetCursorPos(p);
  GetClientRect(FWnd, R);
  MapWindowPoints(FWnd, 0, R, 2);
  if (FCaptured or (PtInRect(R, p) and (WindowFromPoint(p) = FWnd))) then begin
    FMouseOver := True;
  end else
    FMouseOver := False;
end;

procedure THGEImpl.CopyVertices(pVertices: PByte; numVertices: Integer);
var
  pVB               : {$IFDEF DX8}PByte{$ELSE}Pointer{$ENDIF};
begin
  FD3DDevice.SetVertexShader({$IFDEF DX8}D3DFVF_HGEVERTEX{$ELSE}nil{$ENDIF});
  FVB.Lock(0, SizeOf(THGEVertex) * numVertices, pVB, D3DLOCK_DISCARD);
  Move(pVertices^, pVB^, SizeOf(THGEVertex) * numVertices);
  FVB.Unlock;
  FD3DDevice.SetStreamSource(0, FVB, {$IFDEF DX9}0, {$ENDIF}SizeOf(THGEVertex));
end;

procedure THGEImpl.SetGamma(Red, Green, Blue, Brightness, Contrast: Byte);
var
  FGammaRamp        : TD3DGammaRamp;
  k                 : Single;
  k2, I             : Integer;
begin
  for I := 0 to 255 do begin
    FGammaRamp.Red[I] := I * (Red + 1);
    FGammaRamp.Green[I] := I * (Green + 1);
    FGammaRamp.Blue[I] := I * (Blue + 1);
  end;

  with FGammaRamp do begin
    k := (Contrast / 128) - 1;
    if (k < 1) then
      for I := 0 to 255 do begin
        if (Red[I] > 32767.5) then
          Red[I] := Min(Round(Red[I] + (Red[I] - 32767.5) * k), 65535)
        else Red[I] := Max(Round(Red[I] - (32767.5 - Red[I]) * k), 0);
        if (Green[I] > 32767.5) then
          Green[I] := Min(Round(Green[I] + (Green[I] - 32767.5) * k), 65535)
        else Green[I] := Max(Round(Green[I] - (32767.5 - Green[I]) * k), 0);
        if (Blue[I] > 32767.5) then
          Blue[I] := Min(Round(Blue[I] + (Blue[I] - 32767.5) * k), 65535)
        else Blue[I] := Max(Round(Blue[I] - (32767.5 - Blue[I]) * k), 0);
      end else
      for I := 0 to 255 do begin
        if (Red[I] > 32767.5) then
          Red[I] := Max(Round(Red[I] - (Red[I] - 32767.5) * k), 32768)
        else Red[I] := Min(Round(Red[I] + (32767.5 - Red[I]) * k), 32768);
        if (Green[I] > 32767.5) then
          Green[I] := Max(Round(Green[I] - (Green[I] - 32767.5) * k), 32768)
        else Green[I] := Min(Round(Green[I] + (32767.5 - Green[I]) * k), 32768);
        if (Blue[I] > 32767.5) then
          Blue[I] := Max(Round(Blue[I] - (Blue[I] - 32767.5) * k), 32768)
        else Blue[I] := Min(Round(Blue[I] + (32767.5 - Blue[I]) * k), 32768);
      end;

    k2 := Round(((Brightness / 128) - 1) * 65535);
    if (k2 < 0) then
      for I := 0 to 255 do begin
        Red[I] := Max(Red[I] + k2, 0);
        Green[I] := Max(Green[I] + k2, 0);
        Blue[I] := Max(Blue[I] + k2, 0);
      end
    else
      for I := 0 to 255 do begin
        Red[I] := Min(Red[I] + k2, 65535);
        Green[I] := Min(Green[I] + k2, 65535);
        Blue[I] := Min(Blue[I] + k2, 65535);
      end;
  end;
  FD3DDevice.SetGammaRamp({$IFDEF DX9}0, {$ENDIF}0, FGammaRamp);
end;

procedure THGEImpl.Point(X, Y: Single; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
begin
  Vertices[0].X := X;
  Vertices[0].Y := Y;
  Vertices[0].Col := Color;
  RenderBatch;
  FCurPrimType := HGEPRIM_LINES;
  SetBlendMode(BlendMode);
  if (FCurTexture <> nil) then begin
    FD3DDevice.SetTexture(0, nil);
    FCurTexture := nil;
  end;
  CopyVertices(@Vertices, 1);
  FD3DDevice.DrawPrimitive(D3DPT_POINTLIST, 0, 1);
end;

procedure THGEImpl.Line(X1, Y1, X2, Y2: Single; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
begin
  Vertices[0].X := X1;
  Vertices[0].Y := Y1;
  Vertices[0].Col := Color;
  Vertices[1].X := X2;
  Vertices[1].Y := Y2;
  Vertices[1].Col := Color;
  RenderBatch;
  FCurPrimType := HGEPRIM_LINES;
  SetBlendMode(BlendMode);
  if (FCurTexture <> nil) then begin
    FD3DDevice.SetTexture(0, nil);
    FCurTexture := nil;
  end;
  CopyVertices(@Vertices, 2);
  FD3DDevice.DrawPrimitive(D3DPT_LINELIST, 0, 1);
end;

procedure THGEImpl.Line2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
begin
  Vertices[0].X := X1;
  Vertices[0].Y := Y1;
  Vertices[0].Col := Color1;
  Vertices[1].X := X2;
  Vertices[1].Y := Y2;
  Vertices[1].Col := Color2;
  RenderBatch;
  FCurPrimType := HGEPRIM_LINES;
  SetBlendMode(BlendMode);
  if (FCurTexture <> nil) then begin
    FD3DDevice.SetTexture(0, nil);
    FCurTexture := nil;
  end;
  CopyVertices(@Vertices, 2);
  FD3DDevice.DrawPrimitive(D3DPT_LINELIST, 0, 1);
end;

procedure THGEImpl.Circle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
var
  Max, I            : Integer;
  Ic, IInc          : Single;
begin
  if Radius > 1000 then Radius := 1000;
  Max := Round(Radius);
  IInc := 1 / Max;
  Ic := 0;
  Vertices[0].X := X;
  Vertices[0].Y := Y;
  Vertices[0].Col := Color;
  for I := 1 to Max + 1 do begin
    Vertices[I].X := X + Radius * Cos(Ic * TwoPI);
    Vertices[I].Y := Y + Radius * Sin(Ic * TwoPI);
    Vertices[I].Col := Color;
    Ic := Ic + IInc;
  end;

  RenderBatch;
  FCurPrimType := HGEPRIM_LINES;
  SetBlendMode(BlendMode);
  if (FCurTexture <> nil) then begin
    FD3DDevice.SetTexture(0, nil);
    FCurTexture := nil;
  end;
  if not Filled then begin
    Vertices[0].X := Vertices[Max + 1].X;
    Vertices[0].Y := Vertices[Max + 1].Y;
    CopyVertices(@Vertices, Max + 2);
    FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, Max + 1);
  end
  else begin
    CopyVertices(@Vertices, Max + 2);
    FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
  end;

end;

procedure THGEImpl.Ellipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
var
  Max, I            : Integer;
  Ic, IInc          : Single;
begin
  if R1 > 1000 then R1 := 1000;
  Max := Round(R1);
  IInc := 1 / Max;
  Ic := 0;
  Vertices[0].X := X;
  Vertices[0].Y := Y;
  Vertices[0].Col := Color;
  for I := 1 to Max + 1 do begin
    Vertices[I].X := X + R1 * Cos(Ic * TwoPI);
    Vertices[I].Y := Y + R2 * Sin(Ic * TwoPI);
    Vertices[I].Col := Color;
    Ic := Ic + IInc;
  end;

  RenderBatch;
  FCurPrimType := HGEPRIM_LINES;
  SetBlendMode(BlendMode);
  if (FCurTexture <> nil) then begin
    FD3DDevice.SetTexture(0, nil);
    FCurTexture := nil;
  end;

  if not Filled then begin
    Vertices[0].X := Vertices[Max + 1].X;
    Vertices[0].Y := Vertices[Max + 1].Y;
    CopyVertices(@Vertices, Max + 2);
    FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, Max + 1);
  end
  else begin
    CopyVertices(@Vertices, Max + 2);
    FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
  end;

end;

procedure THGEImpl.Circle(X, Y, Radius: Single; Width: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
var
  I                 : Integer;
begin
  if Filled then
    Circle(X, Y, Radius + Width, Color, Filled, BlendMode)
  else
    for I := 0 to 3 * (Width - 1) do
      Circle(X, Y, Radius + I * 0.3, Color, Filled, BlendMode);
end;

procedure THGEImpl.Arc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal;
  DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
var
  Max, I            : Integer;
  Ic, IInc          : Single;
begin
  if Radius > 1000 then Radius := 1000;
  Max := Round(Radius);
  IInc := 1 / Max;
  IInc := IInc * (EndRadius - StartRadius) * IRad;
  Ic := StartRadius * IRad;

  Vertices[0].X := X;
  Vertices[0].Y := Y;
  Vertices[0].Col := Color;
  for I := 1 to Max + 1 do begin
    Vertices[I].X := X + Radius * Cos(Ic * TwoPI);
    Vertices[I].Y := Y + Radius * Sin(Ic * TwoPI);
    Vertices[I].Col := Color;
    Ic := Ic + IInc;
  end;

  if DrawStartEnd then I := 0 else I := 1;

  RenderBatch;
  FCurPrimType := HGEPRIM_LINES;
  SetBlendMode(BlendMode);

  if (FCurTexture <> nil) then begin
    FD3DDevice.SetTexture(0, nil);
    FCurTexture := nil;
  end;

  if not Filled then begin
    Vertices[0].X := Vertices[Max + 1].X;
    Vertices[0].Y := Vertices[Max + 1].Y;
    CopyVertices(@Vertices, Max + 2);
    FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, I, Max + (1 - I));
  end
  else begin
    CopyVertices(@Vertices, Max + 2);
    FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
  end;
end;

procedure THGEImpl.Arc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal;
  Width: Integer; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
var
  I                 : Integer;
begin
  if Filled then
    Arc(X, Y, Radius + Width, StartRadius, EndRadius, Color, DrawStartEnd, Filled, BlendMode)
  else
    for I := 0 to 4 * (Width - 1) do
      Arc(X, Y, Radius + I * 0.15, StartRadius, EndRadius, Color, DrawStartEnd, Filled, BlendMode);
end;

procedure THGEImpl.Triangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
begin
  Vertices[0].X := X1;
  Vertices[0].Y := Y1;
  Vertices[0].Col := Color;
  Vertices[1].X := X2;
  Vertices[1].Y := Y2;
  Vertices[1].Col := Color;
  Vertices[2].X := X3;
  Vertices[2].Y := Y3;
  Vertices[2].Col := Color;

  RenderBatch;
  FCurPrimType := HGEPRIM_LINES;
  SetBlendMode(BlendMode);
  if (FCurTexture <> nil) then begin
    FD3DDevice.SetTexture(0, nil);
    FCurTexture := nil;
  end;

  if Filled then begin
    CopyVertices(@Vertices, 3);
    FD3DDevice.DrawPrimitive(D3DPT_TRIANGLELIST, 0, 1);
  end
  else begin
    Vertices[3].X := X1;
    Vertices[3].Y := Y1;
    Vertices[3].Col := Color;
    CopyVertices(@Vertices, 4);
    FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, 3);
  end;
end;

procedure THGEImpl.Quadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single;
  Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
begin
  Vertices[0].X := X1;
  Vertices[0].Y := Y1;
  Vertices[0].Col := Color1;
  Vertices[1].X := X2;
  Vertices[1].Y := Y2;
  Vertices[1].Col := Color2;
  Vertices[2].X := X3;
  Vertices[2].Y := Y3;
  Vertices[2].Col := Color3;
  Vertices[3].X := X4;
  Vertices[3].Y := Y4;
  Vertices[3].Col := Color4;

  RenderBatch;
  FCurPrimType := HGEPRIM_LINES;
  SetBlendMode(BlendMode);
  if (FCurTexture <> nil) then begin
    FD3DDevice.SetTexture(0, nil);
    FCurTexture := nil;
  end;

  if Filled then begin
    CopyVertices(@Vertices, 4);
    FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, 2);
  end
  else begin
    Vertices[4].X := X1;
    Vertices[4].Y := Y1;
    Vertices[4].Col := Color1;
    CopyVertices(@Vertices, 5);
    FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, 4);
  end;
end;

procedure THGEImpl.Quadrangle(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color: Cardinal;
  Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
begin
  Quadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4, Color, Color, Color, Color, Filled, BlendMode);
end;

procedure THGEImpl.Rectangle(X, Y, Width, Height: Single; Color: Cardinal; Filled: Boolean;
  BlendMode: Integer = BLEND_DEFAULT);
begin
  Quadrangle4Color(X, Y, X + Width, Y, X + Width, Y + Height,
    X, Y + Height, Color, Color, Color, Color, Filled, BlendMode);
end;

procedure THGEImpl.Rectangle(X, Y, Width, Height: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean;
  BlendMode: Integer = BLEND_DEFAULT);
begin
  Quadrangle4Color(X, Y, X + Width, Y, X + Width, Y + Height,
    X, Y + Height, Color1, Color2, Color3, Color4, Filled, BlendMode);
end;

procedure THGEImpl.Polygon(Points: array of TPoint; NumPoints: Integer;
  Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
var
  I                 : Integer;
begin
  for I := 0 to NumPoints - 1 do begin
    Vertices[I].X := Points[I].X;
    Vertices[I].Y := Points[I].Y;
    Vertices[I].Col := Color;
  end;

  RenderBatch;
  FCurPrimType := HGEPRIM_LINES;
  SetBlendMode(BlendMode);

  if (FCurTexture <> nil) then begin
    FD3DDevice.SetTexture(0, nil);
    FCurTexture := nil;
  end;
  if Filled then begin
    CopyVertices(@Vertices, NumPoints);
    FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, NumPoints - 2);
  end
  else begin
    Vertices[NumPoints].X := Points[0].X;
    Vertices[NumPoints].Y := Points[0].Y;
    Vertices[NumPoints].Col := Color;
    CopyVertices(@Vertices, NumPoints + 1);
    FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, NumPoints);
  end;
end;

procedure THGEImpl.Polygon(Points: array of TPoint; Color: Cardinal; Filled: Boolean;
  BlendMode: Integer = BLEND_DEFAULT);
begin
  Polygon(Points, High(Points) + 1, Color, Filled, BlendMode);
end;

procedure THGEImpl.LineH(X1, X2, Y: Integer; Red, Green, Blue: Byte; Width: Integer = 1);
var
  Rect              : TRect;
begin
  Rect.Left := X1;
  Rect.Top := Y;
  Rect.Right := X2;
  Rect.Bottom := Y + Width;
  FD3DDevice.Clear(1, @Rect, D3DCLEAR_TARGET,
    D3dColor_RGBA(Red, Green, Blue, 255), 1.0, 0);
end;

procedure THGEImpl.LineV(X, Y1, Y2: Integer; Red, Green, Blue: Byte; Width: Integer = 1);
var
  Rect              : TRect;
begin
  Rect.Left := X;
  Rect.Top := Y1;
  Rect.Right := X + Width;
  Rect.Bottom := Y2;
  FD3DDevice.Clear(1, @Rect, D3DCLEAR_TARGET,
    D3dColor_RGBA(Red, Green, Blue, 255), 1.0, 0);
end;

procedure THGEImpl.RectangleEx(X1, Y1, X2, Y2: Integer; Solid: Boolean;
  BorderWidth: Integer; Red, Green, Blue: Integer);
var
  Rect, Rect2       : TRect;
begin
  Rect.Left := X1;
  Rect.Right := X2 + 1;
  Rect.Top := Y1;
  Rect.Bottom := Y2 + 1;

  if Solid = True then
    FD3DDevice.Clear(1, @Rect, D3DCLEAR_TARGET,
      D3dColor_RGBA(Red, Green, Blue, 255), 1.0, 0);
  if BorderWidth > 0 then begin
    Rect.Left := Rect.Left - BorderWidth;
    Rect.Right := Rect.Right + BorderWidth;
    Rect.Top := Rect.Top - BorderWidth;
    Rect.Bottom := Rect.Bottom + BorderWidth;
    BorderWidth := -BorderWidth;
  end;
  // Draw top and left
  SetRect(Rect2, Rect.Left, Rect.Top, Rect.Right, Rect.Top - BorderWidth);
  FD3DDevice.Clear(1, @Rect2, D3DCLEAR_TARGET,
    D3dColor_RGBA(Red, Green, Blue, 255), 1.0, 0);
  SetRect(Rect2, Rect.Left, Rect.Top, Rect.Left - BorderWidth, Rect.Bottom);
  FD3DDevice.Clear(1, @Rect2, D3DCLEAR_TARGET,
    D3dColor_RGBA(Red, Green, Blue, 255), 1.0, 0);
  // Draw bottom and right
  SetRect(Rect2, Rect.Left, Rect.Bottom + BorderWidth, Rect.Right, Rect.Bottom);
  FD3DDevice.Clear(1, @Rect2, D3DCLEAR_TARGET,
    D3dColor_RGBA(Red, Green, Blue, 255), 1.0, 0);
  SetRect(Rect2, Rect.Right + BorderWidth, Rect.Top, Rect.Right, Rect.Bottom);
  FD3DDevice.Clear(1, @Rect2, D3DCLEAR_TARGET,
    D3dColor_RGBA(Red, Green, Blue, 255), 1.0, 0);
end;

procedure THGEImpl.LineTo(X, Y: Single; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
begin
  Line(FMX, FMY, X, Y, Color, BlendMode);
  FMX := X;
  FMY := Y;
end;

procedure THGEImpl.MoveTo(X, Y: Single);
begin
  FMX := X;
  FMY := Y;
end;

(****************************************************************************
 * Demo.cpp
 ****************************************************************************)

{$IFDEF DEMO}
var
  DQuad             : THGEQuad;
  DTime             : Single;
  DFont             : TSysFont;

procedure DInit;
var
  I, X, Y, W, H     : Integer;
begin
  DFont := TSysFont.Create;
  DFont.CreateFont('黑体', 145, [fsBold]);

  X := PHGE.System_GetState(HGE_SCREENWIDTH) div 2;
  Y := PHGE.System_GetState(HGE_SCREENHEIGHT) div 2;

  W := DFont.TextWidth('abcdef') div 2;
  H := DFont.TextHeight('abcdef') div 2;

  DQuad.V[0].X := X - W;
  DQuad.V[0].Y := Y - H;

  DTime := 0.0;
end;

procedure DDone;
begin
  DQuad.Tex := nil;
  DFont.Free;
end;

function DFrame: Boolean;
var
  Alpha             : Byte;
  Col               : Longword;
const
  T                 = 3;
begin
  DTime := DTime + PHGE.Timer_GetDelta;

  if (DTime < 0.25 * T) then
    Alpha := Trunc((DTime * 4 / T) * $FF)
  else if (DTime < 1.0 * T) then
    Alpha := $FF
  else if (DTime < 1.25 * T) then
    Alpha := Trunc((1.0 * T - (DTime - 1.0 * T) * 4 / T) * $FF)
  else begin
    Result := True;
    Exit;
  end;

  {Col := $FFFFFF or (Alpha shl 24);
  DQuad.V[0].Col := Col;
  DQuad.V[1].Col := Col;
  DQuad.V[2].Col := Col;
  DQuad.V[3].Col := Col;}

  PHGE.Gfx_BeginScene;
  PHGE.Gfx_Clear($FFFFFFFF);
  DFont.BeginFont;
  DFont.Print(Round(DQuad.V[0].X) + 0, Round(DQuad.V[0].Y) + 1, 'LEGEND', 245, 15, 15, Alpha);
  DFont.Print(Round(DQuad.V[0].X) + 2, Round(DQuad.V[0].Y) + 1, 'LEGEND', 245, 15, 15, Alpha);
  DFont.Print(Round(DQuad.V[0].X) + 1, Round(DQuad.V[0].Y) + 0, 'LEGEND', 245, 15, 15, Alpha);
  DFont.Print(Round(DQuad.V[0].X) + 1, Round(DQuad.V[0].Y) + 2, 'LEGEND', 245, 15, 15, Alpha);
  DFont.EndFont;
  PHGE.Gfx_EndScene;

  Result := False;
end;
{$ENDIF}

end.

