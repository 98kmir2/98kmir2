(*******************************************************************************
                       EXTEND UNIT DXDRAWS FROM DELPHIX PACK

 *  Copyright (c) 2004-2008 Jaro Benes
 *  All Rights Reserved
 *  Version 1.08
 *  D2D Hardware module
 *  web site: www.micrel.cz/Dx
 *  e-mail: delphix_d2d@micrel.cz

 * Enhanced by User137

 * DISCLAIMER:
   This software is provided "as is" and is without warranty of any kind.
   The author of this software does not warrant, guarantee or make any
   representations regarding the use or results of use of this software
   in terms of reliability, accuracy or fitness for purpose. You assume
   the entire risk of direct or indirect, consequential or inconsequential
   results from the correct or incorrect usage of this software even if the
   author has been informed of the possibilities of such damage. Neither
   the author nor anybody connected to this software in any way can assume
   any responsibility.

   Tested in Delphi 4, 5, 6, 7 and Delphi 2005/2006/2007

 * FEATURES:
   a) Implement Hardware acceleration for critical function like DrawAlpha {Blend},
      DrawSub and DrawAdd for both way DXIMAGELIST and DIRECTDRAWSURFACE with rotation too.
   b) Automatic adjustement for texture size different 2^n.
   c) Minimum current source code change, all accelerated code added into:
      DXDraw.BeginScene;
      //code here
      DXDraw.EndScene;
   d) DelphiX facade continues using still.

 * HOW TO USE
   a) Design code like as DelphiX and drawing routine put into
      DXDraw.BeginScene;
      //code here
      DXDraw.EndScene;
   b) setup options in code or property for turn-on acceleration like:
      DXDraw.Finalize; {done DXDraw}
      If HardwareSwitch Then
      {hardware}
      Begin
        if NOT (doDirectX7Mode in DXDraw.Options) then
          DXDraw.Options := DXDraw.Options + [doDirectX7Mode];
        if NOT (doHardware in DXDraw.Options) then
          DXDraw.Options := DXDraw.Options + [doHardware];
        if NOT (do3D in DXDraw.Options) then
          DXDraw.Options := DXDraw.Options + [do3D];
        if doSystemMemory in DXDraw.Options then
          DXDraw.Options := DXDraw.Options - [doSystemMemory];
      End
      Else
      {software}
      Begin
        if doDirectX7Mode in DXDraw.Options then
          DXDraw.Options := DXDraw.Options - [doDirectX7Mode];
        if do3D in DXDraw.Options then
          DXDraw.Options := DXDraw.Options - [do3D];
        if doHardware in DXDraw.Options then
          DXDraw.Options := DXDraw.Options - [doHardware];
        if NOT (doSystemMemory in DXDraw.Options) then
          DXDraw.Options := DXDraw.Options + [doSystemMemory];
      End;
      {to fullscreen}
      if doFullScreen in DXDraw.Options then
      begin
        RestoreWindow;
        DXDraw.Cursor := crDefault;
        BorderStyle := bsSingle;
        DXDraw.Options := DXDraw.Options - [doFullScreen];
        DXDraw.Options := DXDraw.Options + [doFlip];
      end else
      begin
        StoreWindow;
        DXDraw.Cursor := crNone;
        BorderStyle := bsNone;
        DXDraw.Options := DXDraw.Options + [doFullScreen];
        DXDraw.Options := DXDraw.Options - [doFlip];
      end;
      DXDraw1.Initialize; {up DXDraw now}

 * NOTE Main form has to declare like:
      TForm1 = class(TDXForm)

 * KNOWN BUGS OR RESTRICTION:
   1/ Cannot be use DirectDrawSurface other from DXDraw.Surface in HW mode.
   2/ New functions was not tested for two and more DXDraws on form. Sorry.

 ******************************************************************************)
unit DXDraws;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
{$IFDEF DXTextureImage_UseZLIB}ZLIB, {$ENDIF}
  DXClass, DIB,
{$IFDEF StandardDX}
  DirectDraw, DirectSound,
{$IFDEF DX7}
{$IFDEF D3DRM}Direct3DRM, {$ENDIF}Direct3D;
{$ENDIF}
{$IFDEF DX9}
Direct3D9, Direct3D, D3DX9, {Direct3D8,} DX7toDX8;
{$ENDIF}
{$ELSE}
  DirectX;
{$ENDIF}

const
  maxTexBlock = 2048; {maximum textures}
  maxVideoBlockSize = 2048; {maximum size block of one texture}
  {This conditional is for force set square texture when use it alphachannel from DIB32}
{$DEFINE FORCE_SQUARE}
  DXTextureImageGroupType_Normal = 0; // Normal group
  DXTextureImageGroupType_Mipmap = 1; // Mipmap group

  Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ"at  0123456789<>=()-''!_+\/{}^&%.=$#胖?*';
  PowerAlphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`1234567890-=~!@#$%^&*()_+[];'',./\{}:"<>?|┊?';
  ccDefaultSpecular = $FFFFFFFF;

  ZeroRect: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

  //var
    //g_ddsd                    : TDDSurfaceDesc;

type

  {  TRenderType  }

  TRenderType = (rtDraw, rtBlend, rtAdd, rtSub);

  {  TRenderMirrorFlip  }

  TRenderMirrorFlip = (rmfMirror, rmfFlip);
  TRenderMirrorFlipSet = set of TRenderMirrorFlip;

  {  EDirectDrawError  }

  EDirectDrawError = class(EDirectXError);
  EDirectDrawPaletteError = class(EDirectDrawError);
  EDirectDrawClipperError = class(EDirectDrawError);
  EDirectDrawSurfaceError = class(EDirectDrawError);

  {  TDirectDraw  }

  TDirectDrawClipper = class;
  TDirectDrawPalette = class;
  TDirectDrawSurface = class;

  TDirectDraw = class(TDirectX)
  private
    FIDDraw: IDirectDraw;
    FIDDraw4: IDirectDraw4;
    FIDDraw7: IDirectDraw7;
    FDriverCaps: TDDCaps;
    FHELCaps: TDDCaps;
    FClippers: TList;
    FPalettes: TList;
    //FSurfaces: TList;
    function GetClipper(Index: Integer): TDirectDrawClipper;
    function GetClipperCount: Integer;
    function GetDisplayMode: TDDSurfaceDesc;
    function GetIDDraw: IDirectDraw;
    function GetIDDraw4: IDirectDraw4;
    function GetIDDraw7: IDirectDraw7;
    function GetIDraw: IDirectDraw;
    function GetIDraw4: IDirectDraw4;
    function GetIDraw7: IDirectDraw7;
    function GetPalette(Index: Integer): TDirectDrawPalette;
    function GetPaletteCount: Integer;
    //function GetSurface(Index: Integer): TDirectDrawSurface;
    //function GetSurfaceCount: Integer;
  public
    constructor Create(GUID: PGUID);
    constructor CreateEx(GUID: PGUID; DirectX7Mode: Boolean);
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    property ClipperCount: Integer read GetClipperCount;
    property Clippers[Index: Integer]: TDirectDrawClipper read GetClipper;
    property DisplayMode: TDDSurfaceDesc read GetDisplayMode;
    property DriverCaps: TDDCaps read FDriverCaps;
    property HELCaps: TDDCaps read FHELCaps;
    property IDDraw: IDirectDraw read GetIDDraw;
    property IDDraw4: IDirectDraw4 read GetIDDraw4;
    property IDDraw7: IDirectDraw7 read GetIDDraw7;
    property IDraw: IDirectDraw read GetIDraw;
    property IDraw4: IDirectDraw4 read GetIDraw4;
    property IDraw7: IDirectDraw7 read GetIDraw7;
    property PaletteCount: Integer read GetPaletteCount;
    property Palettes[Index: Integer]: TDirectDrawPalette read GetPalette;
    //property SurfaceCount: Integer read GetSurfaceCount;
    //property Surfaces[Index: Integer]: TDirectDrawSurface read GetSurface;
  end;

  {  TDirectDrawClipper  }

  TDirectDrawClipper = class(TDirectX)
  private
    FDDraw: TDirectDraw;
    FIDDClipper: IDirectDrawClipper;
    function GetIDDClipper: IDirectDrawClipper;
    function GetIClipper: IDirectDrawClipper;
    procedure SetHandle(Value: THandle);
    procedure SetIDDClipper(Value: IDirectDrawClipper);
    property Handle: THandle write SetHandle;
  public
    constructor Create(ADirectDraw: TDirectDraw);
    destructor Destroy; override;
    procedure SetClipRects(const Rects: array of TRect);
    property DDraw: TDirectDraw read FDDraw;
    property IClipper: IDirectDrawClipper read GetIClipper;
    property IDDClipper: IDirectDrawClipper read GetIDDClipper write SetIDDClipper;
  end;

  {  TDirectDrawPalette  }

  TDirectDrawPalette = class(TDirectX)
  private
    FDDraw: TDirectDraw;
    FIDDPalette: IDirectDrawPalette;
    function GetEntry(Index: Integer): TPaletteEntry;
    function GetIDDPalette: IDirectDrawPalette;
    function GetIPalette: IDirectDrawPalette;
    procedure SetEntry(Index: Integer; Value: TPaletteEntry);
    procedure SetIDDPalette(Value: IDirectDrawPalette);
  public
    constructor Create(ADirectDraw: TDirectDraw);
    destructor Destroy; override;
    function CreatePalette(Caps: DWORD; const Entries): Boolean;
    function GetEntries(StartIndex, NumEntries: Integer; var Entries): Boolean;
    procedure LoadFromDIB(DIB: TDIB);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    function SetEntries(StartIndex, NumEntries: Integer; const Entries): Boolean;
    property DDraw: TDirectDraw read FDDraw;
    property Entries[Index: Integer]: TPaletteEntry read GetEntry write SetEntry;
    property IDDPalette: IDirectDrawPalette read GetIDDPalette write SetIDDPalette;
    property IPalette: IDirectDrawPalette read GetIPalette;
  end;

  {  TDirectDrawSurfaceCanvas  }

  TDirectDrawSurfaceCanvas = class(TCanvas)
  private
    FDC: HDC;
    FSurface: TDirectDrawSurface;
  protected
    procedure CreateHandle; override;
  public
    constructor Create(ASurface: TDirectDrawSurface);
    destructor Destroy; override;
    procedure Release;
    function TextExtentA(const Text: string): TSize;

    function TextHeight(const Text: string; Bold: Boolean; FontSize: Integer = 9): Integer;
    function TextWidth(const Text: string; Bold: Boolean; FontSize: Integer = 9): Integer;
    procedure TextOutA(X, Y: Integer; const Text: string; IsTransparent: Boolean = True);
  end;

  {  TDirectDrawSurface  }

  TDirectDrawSurface = class(TDirectX)
  private
    //FAnti: Boolean;
    FCanvas: TDirectDrawSurfaceCanvas;
    FHasClipper: Boolean;
    FDDraw: TDirectDraw;
    FIDDSurface: IDirectDrawSurface;
    FIDDSurface4: IDirectDrawSurface4;
    FIDDSurface7: IDirectDrawSurface7;
    FSystemMemory: Boolean;
    FStretchDrawClipper: IDirectDrawClipper;
    FSurfaceDesc: TDDSurfaceDesc;
    FGammaControl: IDirectDrawGammaControl;
    FLockSurfaceDesc: TDDSurfaceDesc;
    //FLockCount: Integer;
    FIsLocked: Boolean;
    FModified: Boolean;
    FCaption: TCaption;
    function GetBitCount: Integer;
    function GetCanvas: TDirectDrawSurfaceCanvas;
    function GetClientRect: TRect;
    function GetHeight: Integer;
    function GetIDDSurface: IDirectDrawSurface;
    function GetIDDSurface4: IDirectDrawSurface4;
    function GetIDDSurface7: IDirectDrawSurface7;
    function GetISurface: IDirectDrawSurface;
    function GetISurface4: IDirectDrawSurface4;
    function GetISurface7: IDirectDrawSurface7;
    function GetPixel(X, Y: Integer): Longint;
    function GetWidth: Integer;
    procedure SetClipper(Value: TDirectDrawClipper);
    procedure SetColorKey(Flags: DWORD; const Value: TDDColorKey);
    procedure SetIDDSurface(Value: IDirectDrawSurface);
    procedure SetIDDSurface4(Value: IDirectDrawSurface4);
    procedure SetIDDSurface7(Value: IDirectDrawSurface7);
    procedure SetPalette(Value: TDirectDrawPalette);
    procedure SetPixel(X, Y: Integer; Value: Longint);
    procedure SetTransparentColor(Col: Longint);
    {support RGB routines}
    procedure LoadRGB(Color: cardinal; var R, G, B: Byte);
    function SaveRGB(const R, G, B: Byte): cardinal;
    {asm routine for direct surface by pixel}
    {no clipping}
    function GetPixel16(X, Y: Integer): Integer; register;
    function GetPixel24(X, Y: Integer): Integer; register;
    function GetPixel32(X, Y: Integer): Integer; register;
    function GetPixel8(X, Y: Integer): Integer; register;
    procedure PutPixel16(X, Y, Color: Integer); register;
    procedure PutPixel24(X, Y, Color: Integer); register;
    procedure PutPixel32(X, Y, Color: Integer); register;
    procedure PutPixel8(X, Y, Color: Integer); register;
    {routines calls asm pixel routine}
    function Peek(X, Y: Integer): Longint;
    procedure Poke(X, Y: Integer; const Value: Longint);
  public
    FAnti: Boolean;
    constructor Create(ADirectDraw: TDirectDraw);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(Dest: TPersistent); override;
    function Blt(const DestRect, SrcRect: TRect; Flags: DWORD;
      const DF: TDDBltFX; Source: TDirectDrawSurface): Boolean;
    function BltFast(X, Y: Integer; const SrcRect: TRect;
      Flags: DWORD; Source: TDirectDrawSurface): Boolean;
    function ColorMatch(Col: TColor): Integer;
{$IFDEF DelphiX_Spt4}
    function CreateSurface(SurfaceDesc: TDDSurfaceDesc): Boolean; overload;
    function CreateSurface(SurfaceDesc: TDDSurfaceDesc2): Boolean; overload;
{$ELSE}
    function CreateSurface(SurfaceDesc: TDDSurfaceDesc): Boolean;
{$ENDIF}

    procedure MirrorFlip(Value: TRenderMirrorFlipSet);

{$IFDEF DelphiX_Spt4}
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean = True); overload;
    procedure Draw(X, Y: Integer; Source: TDirectDrawSurface; Transparent: Boolean = True); overload;
    procedure StretchDraw(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean = True); overload;
    procedure StretchDraw(const DestRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean = True); overload;
{$ELSE}
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean);
    procedure StretchDraw(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean);
{$ENDIF}
    procedure DrawAdd(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawAlpha(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Alpha: Integer);
    procedure DrawSub(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});

    procedure DrawAddCol(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Color, Alpha: Integer);
    procedure DrawAlphaCol(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Color, Alpha: Integer);
    procedure DrawSubCol(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Color, Alpha: Integer);

    {Rotate}
    procedure DrawRotate(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single);
    procedure DrawRotateAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single;
      Alpha: Integer);
    procedure DrawRotateSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});

    procedure DrawRotateAddCol(X, Y, Width, Height: Integer;
      const SrcRect: TRect; Source: TDirectDrawSurface; CenterX,
      CenterY: Double; Transparent: Boolean; Angle: single; Color: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateAlphaCol(X, Y, Width, Height: Integer;
      const SrcRect: TRect; Source: TDirectDrawSurface; CenterX,
      CenterY: Double; Transparent: Boolean; Angle: single; Color: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateCol(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double;
      Transparent: Boolean; Angle: single; Color: Integer);
    procedure DrawRotateSubCol(X, Y, Width, Height: Integer;
      const SrcRect: TRect; Source: TDirectDrawSurface; CenterX,
      CenterY: Double; Transparent: Boolean; Angle: single; Color: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {WaveX}
    procedure DrawWaveX(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer);
    procedure DrawWaveXAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveXAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveXSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {WaveY}
    procedure DrawWaveY(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer);
    procedure DrawWaveYAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveYAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveYSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {Poke function}
    procedure PokeLine(X1, Y1, X2, Y2: Integer; Color: cardinal);
    procedure PokeLinePolar(X, Y: Integer; Angle, Length: extended;
      Color: cardinal);
    procedure PokeBox(xs, ys, xd, yd: Integer; Color: cardinal);
    procedure PokeBlendPixel(const X, Y: Integer; aColor: cardinal;
      Alpha: Byte);
    procedure PokeWuLine(X1, Y1, X2, Y2, aColor: Integer);
    procedure Noise(Oblast: TRect; Density: Byte);
    procedure Blur;
    procedure DoRotate(cent1, cent2, Angle: Integer; coord1, coord2: Real;
      Color: word);
    procedure PokeCircle(X, Y, Radius, Color: Integer);
    procedure PokeEllipse(exc, eyc, ea, eb, Angle, Color: Integer);
    procedure PokeFilledEllipse(exc, eyc, ea, eb, Color: Integer);
    procedure PokeVLine(X, Y1, Y2: Integer; Color: cardinal);
    {Fill}
    procedure Fill(DevColor: Longint);
    procedure FillRect(const Rect: TRect; DevColor: Longint);
    procedure FillRectAdd(const DestRect: TRect; Color: TColor; Alpha: Byte{$IFDEF DelphiX_Spt4} = 128{$ENDIF});
    procedure FillRectAlpha(const DestRect: TRect; Color: TColor; Alpha: Integer);
    procedure FillRectSub(const DestRect: TRect; Color: TColor; Alpha: Byte{$IFDEF DelphiX_Spt4} = 128{$ENDIF});
    {Load}
    procedure LoadFromDIB(DIB: TDIB);
    procedure LoadFromDIBRect(DIB: TDIB; AWidth, AHeight: Integer; const SrcRect: TRect);
    procedure LoadFromGraphic(Graphic: TGraphic);
    procedure LoadFromGraphicRect(Graphic: TGraphic; AWidth, AHeight: Integer; const SrcRect: TRect);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
{$IFDEF DelphiX_Spt4}
    function Lock(const Rect: TRect; var SurfaceDesc: TDDSurfaceDesc): Boolean; overload;
    function Lock(var SurfaceDesc: TDDSurfaceDesc): Boolean; overload;
    function Lock: Boolean; overload;
{$ELSE}
    function LockSurface: Boolean;
    function Lock(const Rect: TRect; var SurfaceDesc: TDDSurfaceDesc): Boolean;
{$ENDIF}
    procedure UnLock;
    function Restore: Boolean;
    property IsLocked: Boolean read FIsLocked;
    function SetSize(AWidth, AHeight: Integer): Boolean;
    //function SetSize2(AWidth, AHeight: Integer): Boolean;
    property Modified: Boolean read FModified write FModified;
    property BitCount: Integer read GetBitCount;
    property Canvas: TDirectDrawSurfaceCanvas read GetCanvas;
    property ClientRect: TRect read GetClientRect;
    property Clipper: TDirectDrawClipper write SetClipper;
    property ColorKey[Flags: DWORD]: TDDColorKey write SetColorKey;
    property DDraw: TDirectDraw read FDDraw;
    property GammaControl: IDirectDrawGammaControl read FGammaControl;
    property Height: Integer read GetHeight;
    property IDDSurface: IDirectDrawSurface read GetIDDSurface write SetIDDSurface;
    property IDDSurface4: IDirectDrawSurface4 read GetIDDSurface4 write SetIDDSurface4;
    property IDDSurface7: IDirectDrawSurface7 read GetIDDSurface7 write SetIDDSurface7;
    property ISurface: IDirectDrawSurface read GetISurface;
    property ISurface4: IDirectDrawSurface4 read GetISurface4;
    property ISurface7: IDirectDrawSurface7 read GetISurface7;
    property Palette: TDirectDrawPalette write SetPalette;
    property Pixels[X, Y: Integer]: Longint read GetPixel write SetPixel;
    property Pixel[X, Y: Integer]: Longint read Peek write Poke;
    property SurfaceDesc: TDDSurfaceDesc read FSurfaceDesc;
    property SystemMemory: Boolean read FSystemMemory write FSystemMemory;
    property TransparentColor: Longint write SetTransparentColor;
    property Width: Integer read GetWidth;
    property Caption: TCaption read FCaption write FCaption;
    //property Anti: Boolean read FAnti write FAnti;
  end;

  {  TDXDrawDisplay  }

  TCustomDXDraw = class;

  TDXDrawDisplayMode = class(TCollectionItem)
  private
    FSurfaceDesc: TDDSurfaceDesc;
    function GetBitCount: Integer;
    function GetHeight: Integer;
    function GetWidth: Integer;
  public
    property BitCount: Integer read GetBitCount;
    property Height: Integer read GetHeight;
    property SurfaceDesc: TDDSurfaceDesc read FSurfaceDesc;
    property Width: Integer read GetWidth;
  end;

  TDXDrawDisplay = class(TPersistent)
  private
    FBitCount: Integer;
    FDXDraw: TCustomDXDraw;
    FHeight: Integer;
    FModes: TCollection;
    FWidth: Integer;
    FFixedBitCount: Boolean;
    FFixedRatio: Boolean;
    FFixedSize: Boolean;
    function GetCount: Integer;
    function GetMode: TDXDrawDisplayMode;
    function GetMode2(Index: Integer): TDXDrawDisplayMode;
    procedure LoadDisplayModes;
    procedure SetBitCount(Value: Integer);
    procedure SetHeight(Value: Integer);
    procedure SetWidth(Value: Integer);
    function SetSize(AWidth, AHeight, ABitCount: Integer): Boolean;
    function DynSetSize(AWidth, AHeight, ABitCount: Integer): Boolean;
  public
    constructor Create(ADXDraw: TCustomDXDraw);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function IndexOf(Width, Height, BitCount: Integer): Integer;
    property Count: Integer read GetCount;
    property Mode: TDXDrawDisplayMode read GetMode;
    property Modes[Index: Integer]: TDXDrawDisplayMode read GetMode2; default;
  published
    property BitCount: Integer read FBitCount write SetBitCount default 16;
    property FixedBitCount: Boolean read FFixedBitCount write FFixedBitCount;
    property FixedRatio: Boolean read FFixedRatio write FFixedRatio;
    property FixedSize: Boolean read FFixedSize write FFixedSize;
    property Height: Integer read FHeight write SetHeight default 480;
    property Width: Integer read FWidth write SetWidth default 640;
  end;

  TDirectDrawDisplay = TDXDrawDisplay;
  TDirectDrawDisplayMode = TDXDrawDisplayMode;

  {  EDXDrawError  }

  EDXDrawError = class(Exception);

  { TD2D HW acceleration}

  TD2D = class;

  {  TTracerCollection  }

  TTraces = class;

  {  TCustomDXDraw  }

  TD2DTextureFilter = (D2D_POINT, D2D_LINEAR, D2D_FLATCUBIC, D2D_GAUSSIANCUBIC, D2D_ANISOTROPIC);

  TDXDrawOption = (doFullScreen, doNoWindowChange, doAllowReboot, doWaitVBlank,
    doAllowPalette256, doSystemMemory, doStretch, doCenter, doFlip,
    do3D, doDirectX7Mode, doRetainedMode, doHardware, doSelectDriver, doZBuffer);

  TDXDrawOptions = set of TDXDrawOption;

  TDXDrawNotifyType = (dxntDestroying, dxntInitializing, dxntInitialize, dxntInitializeSurface,
    dxntFinalize, dxntFinalizeSurface, dxntRestore, dxntSetSurfaceSize);

  TDXDrawNotifyEvent = procedure(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType) of object;

  TD2DTextures = class;
  TOnUpdateTextures = procedure(const Sender: TD2DTextures; var Changed: Boolean) of object;

  TPictureCollectionItem = class;

  TCustomDXDraw = class(TCustomControl)
  private
    FAutoInitialize: Boolean;
    FAutoSize: Boolean;
    FCalledDoInitialize: Boolean;
    FCalledDoInitializeSurface: Boolean;
    FForm: TCustomForm;
    FNotifyEventList: TList;
    FInitialized: Boolean;
    FInitialized2: Boolean;
    FInternalInitialized: Boolean;
    FUpdating: Boolean;
    FSubClass: TControlSubClass;
    FNowOptions: TDXDrawOptions;
    FOptions: TDXDrawOptions;
    FOnFinalize: TNotifyEvent;
    FOnWindowMove: TNotifyEvent;
    FOnFinalizeSurface: TNotifyEvent;
    FOnInitialize: TNotifyEvent;
    FOnInitializeSurface: TNotifyEvent;
    FOnInitializing: TNotifyEvent;
    FOnRestoreSurface: TNotifyEvent;
    FOffNotifyRestore: Integer;
    { DirectDraw }
    FDXDrawDriver: TObject;
    FDriver: PGUID;
    FDriverGUID: TGUID;
    FDDraw: TDirectDraw;
    FDisplay: TDXDrawDisplay;
    FClipper: TDirectDrawClipper;
    FPalette: TDirectDrawPalette;
    FPrimary: TDirectDrawSurface;
    FSurface: TDirectDrawSurface;
    FSurfaceWidth: Integer;
    FSurfaceHeight: Integer;
    { Direct3D }
    FD3D: IDirect3D;
    FD3D2: IDirect3D2;
    FD3D3: IDirect3D3;
    FD3D7: IDirect3D7;
    FD3DDevice: IDirect3DDevice;
    FD3DDevice2: IDirect3DDevice2;
    FD3DDevice3: IDirect3DDevice3;
    FD3DDevice7: IDirect3DDevice7;
{$IFDEF D3DRM}
    FD3DRM: IDirect3DRM;
    FD3DRM2: IDirect3DRM2;
    FD3DRM3: IDirect3DRM3;
    FD3DRMDevice: IDirect3DRMDevice;
    FD3DRMDevice2: IDirect3DRMDevice2;
    FD3DRMDevice3: IDirect3DRMDevice3;
    FCamera: IDirect3DRMFrame;
    FScene: IDirect3DRMFrame;
    FViewport: IDirect3DRMViewport;
{$ENDIF}
    FZBuffer: TDirectDrawSurface;
    FD2D: TD2D;
    FOnUpdateTextures: TOnUpdateTextures;
    FTraces: TTraces;
    FOnRender: TNotifyEvent;
    procedure FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);
    function GetCanDraw: Boolean;
    function GetCanPaletteAnimation: Boolean;
    function GetSurfaceHeight: Integer;
    function GetSurfaceWidth: Integer;
    procedure NotifyEventList(NotifyType: TDXDrawNotifyType);
    procedure SetColorTable(const ColorTable: TRGBQuads);
    procedure SetCooperativeLevel;
    procedure SetDisplay(Value: TDXDrawDisplay);
    procedure SetDriver(Value: PGUID);
    procedure SetOptions(Value: TDXDrawOptions);
    procedure SetSurfaceHeight(Value: Integer);
    procedure SetSurfaceWidth(Value: Integer);
    function TryRestore: Boolean;
    procedure WMCreate(var Message: TMessage); message WM_CREATE;
    // function Fade2Black(colorfrom: Integer): Longint;         私有成员函数未调用   2019-10-07 18:01:33
    function Fade2Color(colorfrom, colorto: Integer): Longint;
    // function Fade2White(colorfrom: Integer): Longint;         私有成员函数未调用   2019-10-07 18:01:33
    function Grey2Fade(shadefrom, shadeto: Integer): Integer;
    procedure SetTraces(const Value: TTraces);
  protected
    procedure DoWindowMove; virtual;
    procedure DoFinalize; virtual;
    procedure DoFinalizeSurface; virtual;
    procedure DoInitialize; virtual;
    procedure DoInitializeSurface; virtual;
    procedure DoInitializing; virtual;
    procedure DoRestoreSurface; virtual;
    procedure Loaded; override;
    procedure Paint; override;
    function PaletteChanged(Foreground: Boolean): Boolean; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetAutoSize(Value: Boolean);
{$IFDEF D6UP} override;
{$ENDIF}
    property OnUpdateTextures: TOnUpdateTextures read FOnUpdateTextures write FOnUpdateTextures;
    property OnRender: TNotifyEvent read FOnRender write FOnRender;
  public
    ColorTable: TRGBQuads;
    DefColorTable: TRGBQuads;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    procedure Finalize;
    procedure Flip;
    procedure Initialize;
    procedure Render(LagCount: Integer{$IFDEF DelphiX_Spt4} = 0{$ENDIF});
    procedure Restore;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
    procedure BeginScene;
    procedure EndScene;
    procedure TextureFilter(Grade: TD2DTextureFilter);
    procedure AntialiasFilter(Grade: TD3DAntialiasMode);
    procedure MirrorFlip(Value: TRenderMirrorFlipSet);
    procedure ClearStack;
    procedure UpdateTextures;
    {grab images}
    procedure PasteImage(sdib: TDIB; X, Y: Integer);
    procedure GrabImage(iX, iY, iWidth, iHeight: Integer; ddib: TDIB);
    {fades}
    function Black2Screen(oldcolor: Integer): Longint;
    function Fade2Screen(oldcolor, newcolour: Integer): Longint;
    function White2Screen(oldcolor: Integer): Longint;
    function FadeGrey2Screen(oldcolor, newcolour: Longint): Longint;
    procedure UpdatePalette;
    procedure RegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
    procedure UnRegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
    property AutoInitialize: Boolean read FAutoInitialize write FAutoInitialize;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
{$IFDEF D3DRM}property Camera: IDirect3DRMFrame read FCamera;
{$ENDIF}
    property CanDraw: Boolean read GetCanDraw;
    property CanPaletteAnimation: Boolean read GetCanPaletteAnimation;
    property Clipper: TDirectDrawClipper read FClipper;
    property Color;
    property D3D: IDirect3D read FD3D;
    property D3D2: IDirect3D2 read FD3D2;
    property D3D3: IDirect3D3 read FD3D3;
    property D3D7: IDirect3D7 read FD3D7;
    property D3DDevice: IDirect3DDevice read FD3DDevice;
    property D3DDevice2: IDirect3DDevice2 read FD3DDevice2;
    property D3DDevice3: IDirect3DDevice3 read FD3DDevice3;
    property D3DDevice7: IDirect3DDevice7 read FD3DDevice7;
{$IFDEF D3DRM}
    property D3DRM: IDirect3DRM read FD3DRM;
    property D3DRM2: IDirect3DRM2 read FD3DRM2;
    property D3DRM3: IDirect3DRM3 read FD3DRM3;
    property D3DRMDevice: IDirect3DRMDevice read FD3DRMDevice;
    property D3DRMDevice2: IDirect3DRMDevice2 read FD3DRMDevice2;
    property D3DRMDevice3: IDirect3DRMDevice3 read FD3DRMDevice3;
{$ENDIF}
    property DDraw: TDirectDraw read FDDraw;
    property Display: TDXDrawDisplay read FDisplay write SetDisplay;
    property Driver: PGUID read FDriver write SetDriver;
    property Initialized: Boolean read FInitialized;
    property NowOptions: TDXDrawOptions read FNowOptions;
    property OnFinalize: TNotifyEvent read FOnFinalize write FOnFinalize;
    property OnWindowMove: TNotifyEvent read FOnWindowMove write FOnWindowMove;
    property OnFinalizeSurface: TNotifyEvent read FOnFinalizeSurface write FOnFinalizeSurface;
    property OnInitialize: TNotifyEvent read FOnInitialize write FOnInitialize;
    property OnInitializeSurface: TNotifyEvent read FOnInitializeSurface write FOnInitializeSurface;
    property OnInitializing: TNotifyEvent read FOnInitializing write FOnInitializing;
    property OnRestoreSurface: TNotifyEvent read FOnRestoreSurface write FOnRestoreSurface;
    property Options: TDXDrawOptions read FOptions write SetOptions;
    property Palette: TDirectDrawPalette read FPalette;
    property Primary: TDirectDrawSurface read FPrimary;
{$IFDEF D3DRM}property Scene: IDirect3DRMFrame read FScene;
{$ENDIF}
    property Surface: TDirectDrawSurface read FSurface;
    property SurfaceHeight: Integer read GetSurfaceHeight write SetSurfaceHeight default 480;
    property SurfaceWidth: Integer read GetSurfaceWidth write SetSurfaceWidth default 640;
{$IFDEF D3DRM}property Viewport: IDirect3DRMViewport read FViewport;
{$ENDIF}
    property ZBuffer: TDirectDrawSurface read FZBuffer;
    property D2D1: TD2D read FD2D; {public object is here}
    property Traces: TTraces read FTraces write SetTraces;
  end;

  {  TDXDraw  }

  TDXDraw = class(TCustomDXDraw)
  published
    property AutoInitialize;
    property AutoSize;
    property Color;
    property Display;
    property Options;
    property SurfaceHeight;
    property SurfaceWidth;
    property OnFinalize;
    property OnFinalizeSurface;
    property OnInitialize;
    property OnInitializeSurface;
    property OnInitializing;
    property OnRestoreSurface;
    property OnUpdateTextures;
    property OnRender;

    property Align;
{$IFDEF DelphiX_Spt4}property Anchors;
{$ENDIF}
{$IFDEF DelphiX_Spt4}property Constraints;
{$ENDIF}
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Traces;
    property Visible;
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
{$IFDEF VER9UP}
    property OnMouseWheel;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
{$ENDIF}
{$IFDEF DelphiX_Spt4}property OnResize;
{$ENDIF}
    property OnStartDrag;
  end;

  {  EDX3DError  }

  EDX3DError = class(Exception);

  {  DxTracer  }

  EDXTracerError = class(Exception);
  EDXBlitError = class(Exception);

  TTracePointsType = (tptDot, tptLine, tptCircle, tptCurve);

  TBlitMoveEvent = procedure(Sender: TObject; LagCount: Integer; var MoveIt: Boolean) of object;
  TWaveType = (wtWaveNone, wtWaveX, wtWaveY);
  TBlitRec = packed record
    FCollisioned: Boolean;
    FMoved: Boolean;
    FVisible: Boolean;
    FX: Double;
    FY: Double;
    FZ: Integer;
    FWidth: Integer;
    FHeight: Integer;
    //--
    FAnimCount: Integer;
    FAnimLooped: Boolean;
    FAnimPos: Double;
    FAnimSpeed: Double;
    FAnimStart: Integer;
    //FTile: Boolean;
    FAngle: single;
    FAlpha: Integer;
    FCenterX: Double;
    FCenterY: Double;
    FScale: Double;
    FBlendMode: TRenderType;
    FAmplitude: Integer;
    FAmpLength: Integer;
    FPhase: Integer;
    FWaveType: TWaveType;
    FSpeedX, FSpeedY: single;
    FGravityX, FGravityY: single;
    FEnergy: single;
    FBlurImage: Boolean;
    FMirror: Boolean;
    FFlip: Boolean;
    FTextureFilter: TD2DTextureFilter;
  end;
  TBlurImageProp = packed record
    eActive: Boolean;
    eX, eY: Integer;
    ePatternIndex: Integer; {when animated or 0 always}
    eAngle: single; //angle can be saved too
    eBlendMode: TRenderType; //blend mode
    eIntensity: Byte; {intensity of Blur/Add/Sub}
  end;

  TPath = packed record
    X, Y, Z: single;
    StayOn: Integer; {in milisecond}
    Reserved: string[28]; {for future use}
    Tag: Integer;
  end;
  TPathArr = array{$IFDEF DelphiX_Delphi3} [0..0]{$ENDIF} of TPath;
{$IFDEF DelphiX_Delphi3}
  PPathArr = ^TPathArr;
{$ENDIF}
  TBlit = class;

  TOnRender = procedure(Sender: TBlit) of object;

  TBlurImageArr = array[0..7] of TBlurImageProp;
  TBlit = class(TPersistent)
  private
    FPathArr: {$IFNDEF DelphiX_Delphi3}TPathArr{$ELSE}PPathArr{$ENDIF};
{$IFDEF DelphiX_Delphi3}
    FPathLen: Integer;
{$ENDIF}
    FParent: TBlit;
    FBlitRec: TBlitRec;
    FBlurImageArr: TBlurImageArr;
    FActive: Boolean;
    //--
    FImage: TPictureCollectionItem;
    FOnMove: TBlitMoveEvent;
    FOnDraw: TNotifyEvent;
    FOnCollision: TNotifyEvent;
    FOnGetImage: TNotifyEvent;
    FEngine: TCustomDXDraw;
    FMovingRepeatly: Boolean;
    FBustrofedon: Boolean;
    FOnRender: TOnRender;
    function GetWorldX: Double;
    function GetWorldY: Double;
    function GetDrawImageIndex: Integer;
    function GetAlpha: Byte;
    function GetAmpLength: Integer;
    function GetAmplitude: Integer;
    function GetAngle: single;
    function GetAnimCount: Integer;
    function GetAnimLooped: Boolean;
    function GetAnimPos: Double;
    function GetAnimSpeed: Double;
    function GetAnimStart: Integer;
    function GetBlendMode: TRenderType;
    function GetBlurImage: Boolean;
    function GetCenterX: Double;
    function GetCenterY: Double;
    function GetCollisioned: Boolean;
    function GetEnergy: single;
    function GetFlip: Boolean;
    function GetGravityX: single;
    function GetGravityY: single;
    function GetHeight: Integer;
    function GetMirror: Boolean;
    function GetMoved: Boolean;
    function GetPhase: Integer;
    function GetScale: Double;
    function GetSpeedX: single;
    function GetSpeedY: single;
    function GetVisible: Boolean;
    function GetWaveType: TWaveType;
    function GetWidth: Integer;
    function GetX: Double;
    function GetY: Double;
    function GetZ: Integer;
    procedure SetAlpha(const Value: Byte);
    procedure SetAmpLength(const Value: Integer);
    procedure SetAmplitude(const Value: Integer);
    procedure SetAngle(const Value: single);
    procedure SetAnimCount(const Value: Integer);
    procedure SetAnimLooped(const Value: Boolean);
    procedure SetAnimPos(const Value: Double);
    procedure SetAnimSpeed(const Value: Double);
    procedure SetAnimStart(const Value: Integer);
    procedure SetBlendMode(const Value: TRenderType);
    procedure SetBlurImage(const Value: Boolean);
    procedure SetCenterX(const Value: Double);
    procedure SetCenterY(const Value: Double);
    procedure SetCollisioned(const Value: Boolean);
    procedure SetEnergy(const Value: single);
    procedure SetFlip(const Value: Boolean);
    procedure SetGravityX(const Value: single);
    procedure SetGravityY(const Value: single);
    procedure SetHeight(const Value: Integer);
    procedure SetMirror(const Value: Boolean);
    procedure SetMoved(const Value: Boolean);
    procedure SetPhase(const Value: Integer);
    procedure SetScale(const Value: Double);
    procedure SetSpeedX(const Value: single);
    procedure SetSpeedY(const Value: single);
    procedure SetVisible(const Value: Boolean);
    procedure SetWaveType(const Value: TWaveType);
    procedure SetWidth(const Value: Integer);
    procedure SetX(const Value: Double);
    procedure SetY(const Value: Double);
    procedure SetZ(const Value: Integer);
    function StoreAngle: Boolean;
    function StoreAnimPos: Boolean;
    function StoreAnimSpeed: Boolean;
    function StoreCenterX: Boolean;
    function StoreCenterY: Boolean;
    function StoreEnergy: Boolean;
    function StoreGravityX: Boolean;
    function StoreGravityY: Boolean;
    function StoreScale: Boolean;
    function StoreSpeedX: Boolean;
    function StoreSpeedY: Boolean;
    function GetBoundsRect: TRect;
    function GetClientRect: TRect;
    function GetPath(Index: Integer): TPath;
    procedure SetPath(Index: Integer; const Value: TPath);
    procedure ReadPaths(Stream: TStream);
    procedure WritePaths(Stream: TStream);
    function GetMovingRepeatly: Boolean;
    procedure SetMovingRepeatly(const Value: Boolean);
    function GetBustrofedon: Boolean;
    procedure SetBustrofedon(const Value: Boolean);
    function GetTextureFilter: TD2DTextureFilter;
    procedure SetTextureFilter(const Value: TD2DTextureFilter);
  protected
    procedure DoDraw; virtual;
    procedure DoMove(LagCount: Integer);
    function DoCollision: TBlit; virtual;
    procedure DoGetImage; virtual;
    procedure DefineProperties(Filer: TFiler); override;
  public
    FCurrentPosition, FCurrentTime: Integer;
    FCurrentDirection: Boolean;
    constructor Create(AParent: TObject); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Engine: TCustomDXDraw read FEngine write FEngine;
    property Parent: TBlit read FParent;
    property WorldX: Double read GetWorldX;
    property WorldY: Double read GetWorldY;
    procedure ReAnimate(MoveCount: Integer); virtual;
    property Image: TPictureCollectionItem read FImage write FImage;
    property BoundsRect: TRect read GetBoundsRect;
    property ClientRect: TRect read GetClientRect;
    procedure SetPathLen(Len: Integer);
    function IsPathEmpty: Boolean;
    function GetPathCount: Integer;
    function GetBlitAt(X, Y: Integer): TBlit;
    property Path[Index: Integer]: TPath read GetPath write SetPath; default;
  published
    property Active: Boolean read FActive write FActive default False;
    //--
    property Collisioned: Boolean read GetCollisioned write SetCollisioned default True;
    property Moved: Boolean read GetMoved write SetMoved default True;
    property Visible: Boolean read GetVisible write SetVisible default True;
    property X: Double read GetX write SetX;
    property Y: Double read GetY write SetY;
    property Z: Integer read GetZ write SetZ;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property MovingRepeatly: Boolean read GetMovingRepeatly write SetMovingRepeatly default True;
    property Bustrofedon: Boolean read GetBustrofedon write SetBustrofedon default False;
    //--
    property AnimCount: Integer read GetAnimCount write SetAnimCount default 0;
    property AnimLooped: Boolean read GetAnimLooped write SetAnimLooped default False;
    property AnimPos: Double read GetAnimPos write SetAnimPos stored StoreAnimPos;
    property AnimSpeed: Double read GetAnimSpeed write SetAnimSpeed stored StoreAnimSpeed;
    property AnimStart: Integer read GetAnimStart write SetAnimStart default 0;
    property Angle: single read GetAngle write SetAngle stored StoreAngle;
    property Alpha: Byte read GetAlpha write SetAlpha default $FF;
    property CenterX: Double read GetCenterX write SetCenterX stored StoreCenterX;
    property CenterY: Double read GetCenterY write SetCenterY stored StoreCenterY;
    property Scale: Double read GetScale write SetScale stored StoreScale;
    property BlendMode: TRenderType read GetBlendMode write SetBlendMode default rtDraw;
    property Amplitude: Integer read GetAmplitude write SetAmplitude default 0;
    property AmpLength: Integer read GetAmpLength write SetAmpLength default 0;
    property Phase: Integer read GetPhase write SetPhase default 0;
    property WaveType: TWaveType read GetWaveType write SetWaveType default wtWaveNone;
    property SpeedX: single read GetSpeedX write SetSpeedX stored StoreSpeedX;
    property SpeedY: single read GetSpeedY write SetSpeedY stored StoreSpeedY;
    property GravityX: single read GetGravityX write SetGravityX stored StoreGravityX;
    property GravityY: single read GetGravityY write SetGravityY stored StoreGravityY;
    property Energy: single read GetEnergy write SetEnergy stored StoreEnergy;
    property BlurImage: Boolean read GetBlurImage write SetBlurImage default False;
    property Mirror: Boolean read GetMirror write SetMirror default False;
    property Flip: Boolean read GetFlip write SetFlip default False;
    property TextureFilter: TD2DTextureFilter read GetTextureFilter write SetTextureFilter default D2D_POINT;

    property OnGetImage: TNotifyEvent read FOnGetImage write FOnGetImage;
    property OnMove: TBlitMoveEvent read FOnMove write FOnMove;
    property OnDraw: TNotifyEvent read FOnDraw write FOnDraw;
    property OnCollision: TNotifyEvent read FOnCollision write FOnCollision;
    property OnRender: TOnRender read FOnRender write FOnRender;
  end;

  TTrace = class(THashCollectionItem)
  private
    FActualized: Boolean;
    FTag: Integer;
    FBlit: TBlit;
    function GetTraces: TTraces;
    function GetOnCollision: TNotifyEvent;
    function GetOnDraw: TNotifyEvent;
    function GetOnGetImage: TNotifyEvent;
    function GetOnMove: TBlitMoveEvent;
    procedure SetOnCollision(const Value: TNotifyEvent);
    procedure SetOnDraw(const Value: TNotifyEvent);
    procedure SetOnGetImage(const Value: TNotifyEvent);
    procedure SetOnMove(const Value: TBlitMoveEvent);
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    function GetOnRender: TOnRender;
    procedure SetOnRender(const Value: TOnRender);
  protected
    function GetDisplayName: string; override;
    procedure SetDisplayName(const Value: string); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Render(const LagCount: Integer);
    function IsActualized: Boolean;
    procedure Assign(Source: TPersistent); override;
    property Traces: TTraces read GetTraces;
    function Clone(NewName: string; OffsetX: Integer{$IFDEF DelphiX_Spt4} = 0{$ENDIF}; OffsetY: Integer{$IFDEF DelphiX_Spt4} = 0{$ENDIF}; Angle: single{$IFDEF DelphiX_Spt4} = 0{$ENDIF}): TTrace;
  published
    property Active: Boolean read GetActive write SetActive;
    property Tag: Integer read FTag write FTag;
    property Blit: TBlit read FBlit write FBlit;
    {events}
    property OnGetImage: TNotifyEvent read GetOnGetImage write SetOnGetImage;
    property OnMove: TBlitMoveEvent read GetOnMove write SetOnMove;
    property OnDraw: TNotifyEvent read GetOnDraw write SetOnDraw;
    property OnCollision: TNotifyEvent read GetOnCollision write SetOnCollision;
    property OnRender: TOnRender read GetOnRender write SetOnRender;
  end;

  TTraces = class(THashCollection)
  private
    FOwner: TPersistent;
    function GetItem(Index: Integer): TTrace;
    procedure SetItem(Index: Integer; Value: TTrace);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TComponent);
    function Add: TTrace;
    function Find(const Name: string): TTrace;
{$IFDEF DelphiX_Spt4}
    function Insert(Index: Integer): TTrace;
{$ENDIF}
    procedure Update(Item: TCollectionItem); override;
    property Items[Index: Integer]: TTrace read GetItem write SetItem;
    destructor Destroy; override;
  end;

{$IFDEF DX3D_deprecated}

  {  TCustomDX3D  }

  TDX3DOption = (toRetainedMode, toSystemMemory, toHardware, toSelectDriver, toZBuffer);

  TDX3DOptions = set of TDX3DOption;

  TCustomDX3D = class(TComponent)
  private
    FAutoSize: Boolean;
{$IFDEF D3DRM}FCamera: IDirect3DRMFrame;
{$ENDIF}
    FD3D: IDirect3D;
    FD3D2: IDirect3D2;
    FD3D3: IDirect3D3;
    FD3D7: IDirect3D7;
    FD3DDevice: IDirect3DDevice;
    FD3DDevice2: IDirect3DDevice2;
    FD3DDevice3: IDirect3DDevice3;
    FD3DDevice7: IDirect3DDevice7;
{$IFDEF D3DRM}
    FD3DRM: IDirect3DRM;
    FD3DRM2: IDirect3DRM2;
    FD3DRM3: IDirect3DRM3;
    FD3DRMDevice: IDirect3DRMDevice;
    FD3DRMDevice2: IDirect3DRMDevice2;
    FD3DRMDevice3: IDirect3DRMDevice3;
{$ENDIF}
    FDXDraw: TCustomDXDraw;
    FInitFlag: Boolean;
    FInitialized: Boolean;
    FNowOptions: TDX3DOptions;
    FOnFinalize: TNotifyEvent;
    FOnInitialize: TNotifyEvent;
    FOptions: TDX3DOptions;
{$IFDEF D3DRM}FScene: IDirect3DRMFrame;
{$ENDIF}
    FSurface: TDirectDrawSurface;
    FSurfaceHeight: Integer;
    FSurfaceWidth: Integer;
{$IFDEF D3DRM}FViewport: IDirect3DRMViewport;
{$ENDIF}
    FZBuffer: TDirectDrawSurface;
    procedure Finalize;
    procedure Initialize;
    procedure DXDrawNotifyEvent(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType);
    function GetCanDraw: Boolean;
    function GetSurfaceHeight: Integer;
    function GetSurfaceWidth: Integer;
    procedure SetAutoSize(Value: Boolean);
    procedure SetDXDraw(Value: TCustomDXDraw);
    procedure SetOptions(Value: TDX3DOptions); virtual; {TridenT}
    procedure SetSurfaceHeight(Value: Integer);
    procedure SetSurfaceWidth(Value: Integer);
  protected
    procedure DoFinalize; virtual;
    procedure DoInitialize; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Render;
    procedure SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
{$IFDEF D3DRM}property Camera: IDirect3DRMFrame read FCamera;
{$ENDIF}
    property CanDraw: Boolean read GetCanDraw;
    property D3D: IDirect3D read FD3D;
    property D3D2: IDirect3D2 read FD3D2;
    property D3D3: IDirect3D3 read FD3D3;
    property D3D7: IDirect3D7 read FD3D7;
    property D3DDevice: IDirect3DDevice read FD3DDevice;
    property D3DDevice2: IDirect3DDevice2 read FD3DDevice2;
    property D3DDevice3: IDirect3DDevice3 read FD3DDevice3;
    property D3DDevice7: IDirect3DDevice7 read FD3DDevice7;
{$IFDEF D3DRM}
    property D3DRM: IDirect3DRM read FD3DRM;
    property D3DRM2: IDirect3DRM2 read FD3DRM2;
    property D3DRM3: IDirect3DRM3 read FD3DRM3;
    property D3DRMDevice: IDirect3DRMDevice read FD3DRMDevice;
    property D3DRMDevice2: IDirect3DRMDevice2 read FD3DRMDevice2;
    property D3DRMDevice3: IDirect3DRMDevice3 read FD3DRMDevice3;
{$ENDIF}
    property DXDraw: TCustomDXDraw read FDXDraw write SetDXDraw;
    property Initialized: Boolean read FInitialized;
    property NowOptions: TDX3DOptions read FNowOptions;
    property OnFinalize: TNotifyEvent read FOnFinalize write FOnFinalize;
    property OnInitialize: TNotifyEvent read FOnInitialize write FOnInitialize;
    property Options: TDX3DOptions read FOptions write SetOptions;
{$IFDEF D3DRM}property Scene: IDirect3DRMFrame read FScene;
{$ENDIF}
    property Surface: TDirectDrawSurface read FSurface;
    property SurfaceHeight: Integer read GetSurfaceHeight write SetSurfaceHeight default 480;
    property SurfaceWidth: Integer read GetSurfaceWidth write SetSurfaceWidth default 640;
{$IFDEF D3DRM}property Viewport: IDirect3DRMViewport read FViewport;
{$ENDIF}
    property ZBuffer: TDirectDrawSurface read FZBuffer;
  end;

  {  TDX3D  }

  TDX3D = class(TCustomDX3D)
  published
    property AutoSize;
    property DXDraw;
    property Options;
    property SurfaceHeight;
    property SurfaceWidth;
    property OnFinalize;
    property OnInitialize;
  end;
{$ENDIF}

  {  EDirect3DTextureError  }

  EDirect3DTextureError = class(Exception);

  {  TDirect3DTexture  }

  TDirect3DTexture = class
  private
    FBitCount: DWORD;
    FDXDraw: TComponent;
    FEnumFormatFlag: Boolean;
    FFormat: TDDSurfaceDesc;
    FGraphic: TGraphic;
    FHandle: TD3DTextureHandle;
    FPaletteEntries: TPaletteEntries;
    FSurface: TDirectDrawSurface;
    FTexture: IDirect3DTexture;
    FTransparentColor: TColor;
    procedure Clear;
    procedure DXDrawNotifyEvent(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType);
    function GetHandle: TD3DTextureHandle;
    function GetSurface: TDirectDrawSurface;
    function GetTexture: IDirect3DTexture;
    procedure SetTransparentColor(Value: TColor);
  public
    constructor Create(Graphic: TGraphic; DXDraw: TComponent);
    destructor Destroy; override;
    procedure Restore;
    property Handle: TD3DTextureHandle read GetHandle;
    property Surface: TDirectDrawSurface read GetSurface;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor;
    property Texture: IDirect3DTexture read GetTexture;
  end;

  { EDXTextureImageError }

  EDXTextureImageError = class(Exception);

  { channel structure }

  TDXTextureImageChannel = record
    Mask: DWORD;
    BitCount: Integer;

    {  Internal use  }
    _Mask2: DWORD;
    _rshift: Integer;
    _lshift: Integer;
    _BitCount2: Integer;
  end;

  TDXTextureImage_PaletteEntries = array[0..255] of TPaletteEntry;

  TDXTextureImageType = (
    DXTextureImageType_PaletteIndexedColor,
    DXTextureImageType_RGBColor
    );

  TDXTextureImageFileCompressType = (
    DXTextureImageFileCompressType_None,
    DXTextureImageFileCompressType_ZLIB
    );

  {forward}

  TDXTextureImage = class;

  { TDXTextureImageLoadFunc }

  TDXTextureImageLoadFunc = procedure(Stream: TStream; Image: TDXTextureImage);

  { TDXTextureImageProgressEvent }

  TDXTextureImageProgressEvent = procedure(Sender: TObject; Progress, ProgressCount: Integer) of object;

  { TDXTextureImage }

  TDXTextureImage = class
  private
    FOwner: TDXTextureImage;
    FFileCompressType: TDXTextureImageFileCompressType;
    FOnSaveProgress: TDXTextureImageProgressEvent;
    FSubImage: TList;
    FImageType: TDXTextureImageType;
    FWidth: Integer;
    FHeight: Integer;
    FPBits: Pointer;
    FBitCount: Integer;
    FPackedPixelOrder: Boolean;
    FWidthBytes: Integer;
    FNextLine: Integer;
    FSize: Integer;
    FTopPBits: Pointer;
    FTransparent: Boolean;
    FTransparentColor: DWORD;
    FImageGroupType: DWORD;
    FImageID: DWORD;
    FImageName: string;
    FAutoFreeImage: Boolean;
    procedure ClearImage;
    function GetPixel(X, Y: Integer): DWORD;
    procedure SetPixel(X, Y: Integer; c: DWORD);
    function GetScanLine(Y: Integer): Pointer;
    function GetSubGroupImageCount(GroupTypeID: DWORD): Integer;
    function GetSubGroupImage(GroupTypeID: DWORD; Index: Integer): TDXTextureImage;
    function GetSubImageCount: Integer;
    function GetSubImage(Index: Integer): TDXTextureImage;
  protected
    procedure DoSaveProgress(Progress, ProgressCount: Integer); virtual;
  public
    idx_index: TDXTextureImageChannel;
    idx_alpha: TDXTextureImageChannel;
    idx_palette: TDXTextureImage_PaletteEntries;
    rgb_red: TDXTextureImageChannel;
    rgb_green: TDXTextureImageChannel;
    rgb_blue: TDXTextureImageChannel;
    rgb_alpha: TDXTextureImageChannel;
    constructor Create;
    constructor CreateSub(AOwner: TDXTextureImage);
    destructor Destroy; override;
    procedure Assign(Source: TDXTextureImage);
    procedure Clear;
    procedure SetImage(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes, NextLine: Integer;
      PBits, TopPBits: Pointer; Size: Integer; AutoFree: Boolean);
    procedure SetSize(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes: Integer);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    function EncodeColor(R, G, B, A: Byte): DWORD;
    function PaletteIndex(R, G, B: Byte): DWORD;
    class procedure RegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
    class procedure UnRegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
    property BitCount: Integer read FBitCount;
    property PackedPixelOrder: Boolean read FPackedPixelOrder write FPackedPixelOrder;
    property Height: Integer read FHeight;
    property ImageType: TDXTextureImageType read FImageType;
    property ImageGroupType: DWORD read FImageGroupType write FImageGroupType;
    property ImageID: DWORD read FImageID write FImageID;
    property ImageName: string read FImageName write FImageName;
    property NextLine: Integer read FNextLine;
    property PBits: Pointer read FPBits;
    property Pixels[X, Y: Integer]: DWORD read GetPixel write SetPixel;
    property ScanLine[Y: Integer]: Pointer read GetScanLine;
    property Size: Integer read FSize;
    property SubGroupImageCount[GroupTypeID: DWORD]: Integer read GetSubGroupImageCount;
    property SubGroupImages[GroupTypeID: DWORD; Index: Integer]: TDXTextureImage read GetSubGroupImage;
    property SubImageCount: Integer read GetSubImageCount;
    property SubImages[Index: Integer]: TDXTextureImage read GetSubImage;
    property TopPBits: Pointer read FTopPBits;
    property Transparent: Boolean read FTransparent write FTransparent;
    property TransparentColor: DWORD read FTransparentColor write FTransparentColor;
    property Width: Integer read FWidth;
    property WidthBytes: Integer read FWidthBytes;
    property FileCompressType: TDXTextureImageFileCompressType read FFileCompressType write FFileCompressType;
    property OnSaveProgress: TDXTextureImageProgressEvent read FOnSaveProgress write FOnSaveProgress;
  end;

  {  TDirect3DTexture2  }

  TDirect3DTexture2 = class
  private
    FDXDraw: TCustomDXDraw;
    FSrcImage: TObject;
    FImage: TDXTextureImage;
    FImage2: TDXTextureImage;
    FAutoFreeGraphic: Boolean;
    FSurface: TDirectDrawSurface;
    FTextureFormat: TDDSurfaceDesc2;
    FMipmap: Boolean;
    FTransparent: Boolean;
    FTransparentColor: TColorRef;
    FUseMipmap: Boolean;
    FUseColorKey: Boolean;
    FOnRestoreSurface: TNotifyEvent;
    FNeedLoadTexture: Boolean;
    FEnumTextureFormatFlag: Boolean;
    FD3DDevDesc: TD3DDeviceDesc;
    procedure DXDrawNotifyEvent(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType);
    procedure SetDXDraw(ADXDraw: TCustomDXDraw);
    procedure LoadSubTexture(Dest: IDirectDrawSurface4; SrcImage: TDXTextureImage);
    procedure SetColorKey;
    procedure SetDIB(DIB: TDIB);
    function GetIsMipmap: Boolean;
    function GetSurface: TDirectDrawSurface;
    function GetTransparent: Boolean;
    procedure SetTransparent(Value: Boolean);
    procedure SetTransparentColor(Value: TColorRef);
  protected
    procedure DoRestoreSurface; virtual;
  public
    constructor Create(ADXDraw: TCustomDXDraw; Graphic: TObject; AutoFreeGraphic: Boolean);
    constructor CreateFromFile(ADXDraw: TCustomDXDraw; const FileName: string);
    constructor CreateVideoTexture(ADXDraw: TCustomDXDraw);
    destructor Destroy; override;
    procedure Finalize;
    procedure Load;
    procedure Initialize;
    property IsMipmap: Boolean read GetIsMipmap;
    property Surface: TDirectDrawSurface read GetSurface;
    property TextureFormat: TDDSurfaceDesc2 read FTextureFormat write FTextureFormat;
    property Transparent: Boolean read GetTransparent write SetTransparent;
    property TransparentColor: TColorRef read FTransparentColor write SetTransparentColor;
    property OnRestoreSurface: TNotifyEvent read FOnRestoreSurface write FOnRestoreSurface;
  end;

  {  EDXTBaseError  }

  EDXTBaseError = class(Exception);

  {  parameters for DXT generator  }

  TDXTImageChannel = (rgbNone, rgbRed, rgbGreen, rgbBlue, rgbAlpha, yuvY);
  TDXTImageChannels = set of TDXTImageChannel;

  TDXTImageChannelInfo = packed record
    Image: TDXTextureImage;
    BitCount: Integer;
  end;

  TDXTImageFormat = packed record
    ImageType: TDXTextureImageType;
    Width: Integer;
    Height: Integer;
    Bits: Pointer;
    BitCount: Integer;
    WidthBytes: Integer;
    {transparent}
    Transparent: Boolean;
    TransparentColor: TColorRef;
    {texture channels}
    idx_index: TDXTextureImageChannel;
    idx_alpha: TDXTextureImageChannel;
    idx_palette: TDXTextureImage_PaletteEntries;
    rgb_red: TDXTextureImageChannel;
    rgb_green: TDXTextureImageChannel;
    rgb_blue: TDXTextureImageChannel;
    rgb_alpha: TDXTextureImageChannel;
    {compress level}
    Compress: TDXTextureImageFileCompressType;
    MipmapCount: Integer;
    Name: string;
  end;

  {  TDXTBase  }

  {Note JB.}
  {Class for DXT generation files, primary use for load bitmap 32 with alphachannel}
  {recoded and class created by JB.}
  TDXTBase = class
  private
    FHasChannels: TDXTImageChannels;
    FHasChannelImages: array[TDXTImageChannel] of TDXTImageChannelInfo;
    FChannelChangeTable: array[TDXTImageChannel] of TDXTImageChannel;
    FHasImageList: TList;
    FParamsFormat: TDXTImageFormat;
    FStrImageFileName: string;
    FDIB: TDIB;
    function GetCompression: TDXTextureImageFileCompressType;
    function GetHeight: Integer;
    function GetMipmap: Integer;
    function GetTransparentColor: TColorRef;
    function GetWidth: Integer;
    procedure SetCompression(const Value: TDXTextureImageFileCompressType);
    procedure SetHeight(const Value: Integer);
    procedure SetMipmap(const Value: Integer);
    procedure SetTransparentColor(const Value: TColorRef);
    procedure SetWidth(const Value: Integer);
    procedure SetTransparentColorIndexed(const Value: TColorRef);
    function GetTexture: TDXTextureImage;
    procedure Resize(Image: TDXTextureImage; NewWidth, NewHeight: Integer;
      FilterTypeResample: TFilterTypeResample);
    procedure EvaluateChannels(const CheckChannelUsed: TDXTImageChannels;
      const CheckChannelChanged, CheckBitCountForChannel: string);
    function GetPicture: TDXTextureImage;
  protected
    procedure CalcOutputBitFormat;
    procedure BuildImage(Image: TDXTextureImage);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetChannelR(T: TDIB);
    procedure SetChannelG(T: TDIB);
    procedure SetChannelB(T: TDIB);
    procedure SetChannelA(T: TDIB);
    procedure LoadChannelAFromFile(const FileName: string);
    procedure SetChannelY(T: TDIB);
    procedure SetChannelRGB(T: TDIB);
    procedure LoadChannelRGBFromFile(const FileName: string);
    procedure SetChannelRGBA(T: TDIB);
    procedure LoadChannelRGBAFromFile(const FileName: string);
    property TransparentColor: TColorRef read GetTransparentColor write SetTransparentColor;
    property TransparentColorIndexed: TColorRef read GetTransparentColor write SetTransparentColorIndexed;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Compression: TDXTextureImageFileCompressType read GetCompression write SetCompression;
    property Mipmap: Integer read GetMipmap write SetMipmap;
    property Texture: TDXTextureImage read GetTexture;
  end;

{$IFDEF D3DRM}
  {  EDirect3DRMUserVisualError  }

  EDirect3DRMUserVisualError = class(Exception);

  {  TDirect3DRMUserVisual  }

  TDirect3DRMUserVisual = class
  private
    FUserVisual: IDirect3DRMUserVisual;
  protected
    function DoRender(Reason: TD3DRMUserVisualReason;
      D3DRMDev: IDirect3DRMDevice; D3DRMView: IDirect3DRMViewport): HRESULT; virtual;
  public
    constructor Create(D3DRM: IDirect3DRM);
    destructor Destroy; override;
    property UserVisual: IDirect3DRMUserVisual read FUserVisual;
  end;
{$ENDIF}

  {  EPictureCollectionError  }

  EPictureCollectionError = class(Exception);

  {  TPictureCollectionItem  }

  TPictureCollection = class;

  TPictureCollectionItem = class(THashCollectionItem)
  private
    FPicture: TPicture;
    FInitialized: Boolean;
    FPatternHeight: Integer;
    FPatternWidth: Integer;
    FPatterns: TCollection;
    FSkipHeight: Integer;
    FSkipWidth: Integer;
    FSurfaceList: TList;
    FSystemMemory: Boolean;
    FTransparent: Boolean;
    FTransparentColor: TColor;
    procedure ClearSurface;
    procedure Finalize;
    procedure Initialize;
    function GetHeight: Integer;
    function GetPictureCollection: TPictureCollection;
    function GetPatternRect(Index: Integer): TRect;
    function GetPatternSurface(Index: Integer): TDirectDrawSurface;
    function GetPatternCount: Integer;
    function GetWidth: Integer;
    procedure SetPicture(Value: TPicture);
    procedure SetTransparentColor(Value: TColor);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Draw(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer);
    //	Modifier par MKost d'Uk@Team tous droit r閟erv?				*)
    //	22:02 04/11/2005								*)
    //	Ajout?:									*)
    // Dans TPictureCollectionItem								*)
    // procedure DrawFlipH(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer); *)
    //      -Effectue un flip Horizontale de l'image					*)
    // procedure DrawFlipHV(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer);*)
    //      -Effectue un flip Oblique de l'image						*)
    // procedure DrawFlipV(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer); *)
    //      -Effectue un flip Verticale de l'image						*)
    procedure DrawFlipH(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer);
    procedure DrawFlipHV(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer);
    procedure DrawFlipV(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer);
    procedure StretchDraw(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer);
    procedure DrawAdd(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawAddCol(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawAlpha(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawAlphaCol(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawSub(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawSubCol(Dest: TDirectDrawSurface; const DestRect: TRect;
      PatternIndex, Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {Rotate}
    procedure DrawRotate(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single);
    procedure DrawRotateAdd(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateAddCol(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateAlphaCol(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateSub(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateSubCol(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {WaveX}
    procedure DrawWaveX(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer);
    procedure DrawWaveXAdd(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveXAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveXSub(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {WaveY}
    procedure DrawWaveY(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer);
    procedure DrawWaveYAdd(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveYAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveYSub(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {SpecialDraw}
    procedure DrawCol(Dest: TDirectDrawSurface; const DestRect, SourceRect: TRect;
      PatternIndex: Integer; Faded: Boolean; RenderType: TRenderType; Color,
      Specular: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure Restore;
    property Height: Integer read GetHeight;
    property Initialized: Boolean read FInitialized;
    property PictureCollection: TPictureCollection read GetPictureCollection;
    property PatternCount: Integer read GetPatternCount;
    property PatternRects[Index: Integer]: TRect read GetPatternRect;
    property PatternSurfaces[Index: Integer]: TDirectDrawSurface read GetPatternSurface;
    property Width: Integer read GetWidth;
  published
    property PatternHeight: Integer read FPatternHeight write FPatternHeight;
    property PatternWidth: Integer read FPatternWidth write FPatternWidth;
    property Picture: TPicture read FPicture write SetPicture;
    property SkipHeight: Integer read FSkipHeight write FSkipHeight default 0;
    property SkipWidth: Integer read FSkipWidth write FSkipWidth default 0;
    property SystemMemory: Boolean read FSystemMemory write FSystemMemory;
    property Transparent: Boolean read FTransparent write FTransparent;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor;
  end;

  {  TPictureCollection  }

  TPictureCollection = class(THashCollection)
  private
    FDXDraw: TCustomDXDraw;
    FOwner: TPersistent;
    function GetItem(Index: Integer): TPictureCollectionItem;
    procedure ReadColorTable(Stream: TStream);
    procedure WriteColorTable(Stream: TStream);
    function Initialized: Boolean;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function GetOwner: TPersistent; override;
  public
    ColorTable: TRGBQuads;
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
    function Find(const Name: string): TPictureCollectionItem;
    procedure Finalize;
    procedure Initialize(DXDraw: TCustomDXDraw);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure MakeColorTable;
    procedure Restore;
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    property DXDraw: TCustomDXDraw read FDXDraw;
    property Items[Index: Integer]: TPictureCollectionItem read GetItem; default;
  end;

  {  TCustomDXImageList  }

  TCustomDXImageList = class(TComponent)
  private
    FDXDraw: TCustomDXDraw;
    FItems: TPictureCollection;
    procedure DXDrawNotifyEvent(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType);
    procedure SetDXDraw(Value: TCustomDXDraw);
    procedure SetItems(Value: TPictureCollection);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;
    property DXDraw: TCustomDXDraw read FDXDraw write SetDXDraw;
    property Items: TPictureCollection read FItems write SetItems;
  end;

  {  TDXImageList  }

  TDXImageList = class(TCustomDXImageList)
  published
    property DXDraw;
    property Items;
  end;

  {  EDirectDrawOverlayError  }

  EDirectDrawOverlayError = class(Exception);

  {  TDirectDrawOverlay  }

  TDirectDrawOverlay = class
  private
    FDDraw: TDirectDraw;
    FTargetSurface: TDirectDrawSurface;
    FDDraw2: TDirectDraw;
    FTargetSurface2: TDirectDrawSurface;
    FSurface: TDirectDrawSurface;
    FBackSurface: TDirectDrawSurface;
    FOverlayColorKey: TColor;
    FOverlayRect: TRect;
    FVisible: Boolean;
    procedure SetOverlayColorKey(Value: TColor);
    procedure SetOverlayRect(const Value: TRect);
    procedure SetVisible(Value: Boolean);
  public
    constructor Create(DDraw: TDirectDraw; TargetSurface: TDirectDrawSurface);
    constructor CreateWindowed(WindowHandle: HWND);
    destructor Destroy; override;
    procedure Finalize;
    procedure Initialize(const SurfaceDesc: TDDSurfaceDesc);
    procedure Flip;
    property OverlayColorKey: TColor read FOverlayColorKey write SetOverlayColorKey;
    property OverlayRect: TRect read FOverlayRect write SetOverlayRect;
    property Surface: TDirectDrawSurface read FSurface;
    property BackSurface: TDirectDrawSurface read FBackSurface;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  {
   Modified by Michael Wilson 2/05/2001
   - re-added redundant assignment to Offset
   Modified by Marcus Knight 19/12/2000
   - replaces all referaces to 'pos' with 'AnsiPos' <- faster
   - replaces all referaces to 'uppercase' with 'Ansiuppercase' <- faster
   - Now only uppercases outside the loop
   - Fixed the non-virtual contructor
   - renamed & moved Offset to private(fOffSet), and added the property OffSet
   - Commented out the redundant assignment to Offset<- not needed, as Offset is now a readonly property
   - Added the Notification method to catch when the image list is destroyed
   - removed DXclasses from used list
  }

  TDXFont = class(TComponent)
  private
    FDXImageList: TDXImageList;
    FFont: string;
    FFontIndex: Integer;
    FOffset: Integer; // renamed from Offset -> fOffset
    procedure SetFont(const Value: string);
    procedure SetFontIndex(const Value: Integer);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override; // added
  public
    constructor Create(AOwner: TComponent); override; // Modified
    destructor Destroy; override;
    procedure TextOut(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string);
    property Offset: Integer read FOffset write FOffset; // added
  published
    property Font: string read FFont write SetFont;
    property FontIndex: Integer read FFontIndex write SetFontIndex;
    property DXImageList: TDXImageList read FDXImageList write FDXImageList;
  end;

  (*******************************************************************************
   * Unit Name: DXPowerFont.pas
   * Information: Writed By Ramin.S.Zaghi (Based On Wilson's DXFont Unit)
   * Last Changes: Dec 25 2000;
   * Unit Information:
   *     This unit includes a VCL-Component for DelphiX. This component draws the
   *     Character-Strings on a TDirectDrawSurface. This component helps the
   *     progarmmers to using custom fonts and printing texts easily such as
   *     TCanvas.TextOut function...
   * Includes:
   * 1. TDXPowerFontTextOutEffect ==> The kinds of drawing effects.
   *    - teNormal: Uses the Draw function. (Normal output)
   *    - teRotat: Uses the DrawRotate function. (Rotates each character)
   *    - teAlphaBlend: Uses DrawAlpha function. (Blends each character)
   *    - teWaveX: Uses DrawWaveX function. (Adds a Wave effect to the each character)
   *
   * 2. TDXPowerFontTextOutType ==> The kinds of each caracter.
   *    - ttUpperCase: Uppers all characters automaticaly.
   *    - ttLowerCase: Lowers all characters automaticaly.
   *    - ttNormal: Uses all characters with out any converting.
   *
   * 3. TDXPowerFontEffectsParameters ==> Includes the parameters for adding effects to the characters.
   *    - (CenterX, CenterY): The rotating center point.
   *    - (Width, Height): The new size of each character.
   *    - Angle: The angle of rotate.
   *    - AlphaValue: The value of Alpha-Chanel.
   *    - WAmplitude: The Amplitude of Wave function. (See The Help Of DelphiX)
   *    - WLenght: The Lenght Of Wave function. (See The Help Of DelphiX)
   *    - WPhase: The Phase Of Wave function. (See The Help Of DelphiX)
   *
   * 4. TDXPowerFontBeforeTextOutEvent ==> This is an event that occures before
   *    drawing texts on to TDirectDrawSurface object.
   *    - Sender: Retrieves the event caller object.
   *    - Text: Retrieves the text sended text for drawing.
   *      (NOTE: The changes will have effect)
   *    - DoTextOut: The False value means that the TextOut function must be stopped.
   *      (NOTE: The changes will have effect)
   *
   * 5. TDXPowerFontAfterTextOutEvent ==> This is an event that occures after
   *    drawing texts on to TDirectDrawSurface object.
   *    - Sender: Retrieves the event caller object.
   *    - Text: Retrieves the text sended text for drawing.
   *      (NOTE: The changes will not have any effects)
   *
   * 6. TDXPowerFont ==> I sthe main class of PowerFont VCL-Component.
   *    - property Font: string; The name of custom-font's image in the TDXImageList items.
   *    - property FontIndex: Integer; The index of custom-font's image in the TDXImageList items.
   *    - property DXImageList: TDXImageList; The TDXImageList that includes the image of custom-fonts.
   *    - property UseEnterChar: Boolean; When the value of this property is True, The component caculates Enter character.
   *    - property EnterCharacter: String;
   *==>   Note that TDXPowerFont calculates tow kinds of enter character:
   *==>   E1. The Enter character that draws the characters after it self in a new line and after last drawed character, ONLY.
   *==>   E2. The Enter character that draws the characters after it self in a new line such as #13#10 enter code in delphi.
   *==>   Imporatant::
   *==>       (E1) TDXPowerFont uses the first caracter of EnterCharacter string as the first enter caracter (Default value is '|').
   *==>       (E2) and uses the second character as the scond enter caracter (Default value is '<')
   *    - property BeforeTextOut: TDXPowerFontBeforeTextOutEvent; See TDXPowerFontBeforeTextOutEvent.
   *    - property AfterTextOut: TDXPowerFontAfterTextOutEvent; See TDXPowerFontAfterTextOutEvent.
   *    - property Alphabets: string; TDXPowerFont uses this character-string for retrieving the pattern number of each character.
   *    - property TextOutType: TDXPowerFontTextOutType; See TDXPowerFontTextOutType.
   *    - property TextOutEffect: TDXPowerFontTextOutEffect; See TDXPowerFontTextOutEffect.
   *    - property EffectsParameters: TDXPowerFontEffectsParameters; See TDXPowerFontEffectsParameters.
   *
   *    - function TextOut(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
   *      This function draws/prints the given text on the given TDirectDrawSurface.
   *      - DirectDrawSurface: The surface for drawing text (character-string).
   *      - (X , Y): The first point of outputed text. (Such as X,Y parameters in TCanvas.TextOut function)
   *      - Text: The text for printing.
   *      Return values: This function returns False when an error occured or...
   *    - function TextOutFast(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
   *      This function works such as TextOut function but,
   *      with out calculating any Parameters/Effects/Enter-Characters/etc...
   *      This function calculates the TextOutType, ONLY.
   *
   * Ramin.S.Zaghi (ramin_zaghi@yahoo.com)
   * (Based on wilson's code for TDXFont VCL-Component/Add-On)
   * (wilson@no2games.com)
   *
   * For more information visit:
   *  www.no2games.com
   *  turbo.gamedev.net
   ******************************************************************************)

   { DXPowerFont types }

  TDXPowerFontTextOutEffect = (teNormal, teRotat, teAlphaBlend, teWaveX);
  TDXPowerFontTextOutType = (ttUpperCase, ttLowerCase, ttNormal);
  TDXPowerFontBeforeTextOutEvent = procedure(Sender: TObject; var Text: string; var DoTextOut: Boolean) of object;
  TDXPowerFontAfterTextOutEvent = procedure(Sender: TObject; Text: string) of object;

  { TDXPowerFontEffectsParameters }

  TDXPowerFontEffectsParameters = class(TPersistent)
  private
    FCenterX: Integer;
    FCenterY: Integer;
    FHeight: Integer;
    FWidth: Integer;
    FAngle: Integer;
    FAlphaValue: Integer;
    FWPhase: Integer;
    FWAmplitude: Integer;
    FWLenght: Integer;
    procedure SetAngle(const Value: Integer);
    procedure SetCenterX(const Value: Integer);
    procedure SetCenterY(const Value: Integer);
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    procedure SetAlphaValue(const Value: Integer);
    procedure SetWAmplitude(const Value: Integer);
    procedure SetWLenght(const Value: Integer);
    procedure SetWPhase(const Value: Integer);
  published
    property CenterX: Integer read FCenterX write SetCenterX;
    property CenterY: Integer read FCenterY write SetCenterY;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property Angle: Integer read FAngle write SetAngle;
    property AlphaValue: Integer read FAlphaValue write SetAlphaValue;
    property WAmplitude: Integer read FWAmplitude write SetWAmplitude;
    property WLenght: Integer read FWLenght write SetWLenght;
    property WPhase: Integer read FWPhase write SetWPhase;
  end;

  { TDXPowerFont }

  TDXPowerFont = class(TComponent)
  private
    FDXImageList: TDXImageList;
    FFont: string;
    FFontIndex: Integer;
    FUseEnterChar: Boolean;
    FEnterCharacter: string;
    FAfterTextOut: TDXPowerFontAfterTextOutEvent;
    FBeforeTextOut: TDXPowerFontBeforeTextOutEvent;
    FAlphabets: string;
    FTextOutType: TDXPowerFontTextOutType;
    FTextOutEffect: TDXPowerFontTextOutEffect;
    FEffectsParameters: TDXPowerFontEffectsParameters;
    procedure SetFont(const Value: string);
    procedure SetFontIndex(const Value: Integer);
    procedure SetUseEnterChar(const Value: Boolean);
    procedure SetEnterCharacter(const Value: string);
    procedure SetAlphabets(const Value: string);
    procedure SetTextOutType(const Value: TDXPowerFontTextOutType);
    procedure SetTextOutEffect(const Value: TDXPowerFontTextOutEffect);
    procedure SetEffectsParameters(const Value: TDXPowerFontEffectsParameters);
  published
    property Font: string read FFont write SetFont;
    property FontIndex: Integer read FFontIndex write SetFontIndex;
    property DXImageList: TDXImageList read FDXImageList write FDXImageList;
    property UseEnterChar: Boolean read FUseEnterChar write SetUseEnterChar;
    property EnterCharacter: string read FEnterCharacter write SetEnterCharacter;
    property BeforeTextOut: TDXPowerFontBeforeTextOutEvent read FBeforeTextOut write FBeforeTextOut;
    property AfterTextOut: TDXPowerFontAfterTextOutEvent read FAfterTextOut write FAfterTextOut;
    property Alphabets: string read FAlphabets write SetAlphabets;
    property TextOutType: TDXPowerFontTextOutType read FTextOutType write SetTextOutType;
    property TextOutEffect: TDXPowerFontTextOutEffect read FTextOutEffect write SetTextOutEffect;
    property EffectsParameters: TDXPowerFontEffectsParameters read FEffectsParameters write SetEffectsParameters;
  public
    Offset: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function TextOut(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
    function TextOutFast(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
  end;

  {D2D unit for pure HW support
  *  Copyright (c) 2004-2008 Jaro Benes
  *  All Rights Reserved
  *  Version 1.08
  *  D2D Hardware module - interface part
  *  web site: www.micrel.cz/Dx
  *  e-mail: delphix_d2d@micrel.cz
  }

   {supported texture vertex as substitute type from DirectX}

   {TD2D4Vertex - used with D2DTexturedOn}

  TD2D4Vertex = array[0..3] of TD3DTLVERTEX;

  {TD2DTextures - texture storage used with Direct3D}
  TTextureRec = packed record
    VDIB: TDIB;
    D2DTexture: TDirect3DTexture2;
    FloatX1, FloatY1, FloatX2, FloatY2: Double; //uschov vyrez
    Name: string{$IFDEF DelphiX_Delphi3} [255]{$ENDIF}; //jmeno obrazku pro snadne dohledani
    Width, Height: Integer;
    AlphaChannel: Boolean; //.06c
  end;
  PTextureRec = ^TTextureRec;
  TTextureArr = array{$IFDEF DelphiX_Delphi3} [0..0]{$ENDIF} of TTextureRec;
{$IFDEF DelphiX_Delphi3}
  PTextureArr = ^TTextureArr;
  EMaxTexturesError = class(Exception);
{$ENDIF}
  TD2DTextures = class
  private
    FDDraw: TCustomDXDraw;
{$IFDEF DelphiX_Delphi3}
    TexLen: Integer;
    Texture: PTextureArr;
{$ELSE}
    Texture: TTextureArr;
{$ENDIF}
    function GetD2DMaxTextures: Integer;
    procedure SetD2DMaxTextures(const Value: Integer);
    procedure D2DPruneTextures;
    procedure D2DPruneAllTextures;
    procedure SizeAdjust(var DIB: TDIB; var FloatX1, FloatY1, FloatX2,
      FloatY2: Double);
    // procedure D2DFreeTextures;                  私有成员函数未调用  2019-10-07 18:01:33
    function SetTransparentColor(dds: TDirectDrawSurface; PixelColor: Integer;
      Transparent: Boolean): Integer;
    function GetTexLayoutByName(Name: string): TDIB;
  public
    constructor Create(DDraw: TCustomDXDraw);
    destructor Destroy; override;
    function Find(byName: string): Integer;
    function GetTextureByName(const byName: string): TDirect3DTexture2;
    function GetTextureByIndex(const byIndex: Integer): TDirect3DTexture2;
    function GetTextureNameByIndex(const byIndex: Integer): string;
    function Count: Integer;
    {functions support loading image or DDS}
{$IFDEF DelphiX_Spt4}
    function CanFindTexture(aImage: TPictureCollectionItem): Boolean; overload;
    function CanFindTexture(const TexName: string): Boolean; overload;
    function CanFindTexture(const Color: Longint): Boolean; overload;
    function LoadTextures(aImage: TPictureCollectionItem): Boolean; overload;
    function LoadTextures(dds: TDirectDrawSurface; Transparent: Boolean; asTexName: string): Boolean; overload;
    function LoadTextures(dds: TDirectDrawSurface; Transparent: Boolean; TransparentColor: Integer; asTexName: string): Boolean; overload;
    function LoadTextures(Color: Integer): Boolean; overload;
{$ELSE}
    function CanFindTexture(aImage: TPictureCollectionItem): Boolean;
    function CanFindTexture2(const TexName: string): Boolean;
    function CanFindTexture3(const Color: Longint): Boolean;
    function LoadTextures(aImage: TPictureCollectionItem): Boolean;
    function LoadTextures2(dds: TDirectDrawSurface; Transparent: Boolean; asTexName: string): Boolean;
    function LoadTextures3(dds: TDirectDrawSurface; Transparent: Boolean; TransparentColor: Integer; asTexName: string): Boolean;
    function LoadTextures4(Color: Integer): Boolean;
{$ENDIF}
    property TexLayoutByName[Name: string]: TDIB read GetTexLayoutByName;
  published
    property D2DMaxTextures: Integer read GetD2DMaxTextures write SetD2DMaxTextures;
  end;

  {Main component for HW support}

  TD2D = class
  private
    FDDraw: TCustomDXDraw;
    FCanUseD2D: Boolean;
    FBitCount: Integer;
    FMirrorFlipSet: TRenderMirrorFlipSet;
    FD2DTextureFilter: TD2DTextureFilter;
    FD2DAntialiasFilter: TD3DAntialiasMode;
    FVertex: TD2D4Vertex;
    FD2DTexture: TD2DTextures;
    FDIB: TDIB;
    FD3DDevDesc7: TD3DDeviceDesc7;
    FInitialized: Boolean;
    {ukazuje pocet textur}
    procedure D2DUpdateTextures;

    procedure SetCanUseD2D(const Value: Boolean);
    function GetCanUseD2D: Boolean;
    {create the component}
    constructor Create(DDraw: TCustomDXDraw);
    procedure SetD2DTextureFilter(const Value: TD2DTextureFilter);
    procedure SetD2DAntialiasFilter(const Value: TD3DAntialiasMode);
    procedure D2DEffectSolid;
    procedure D2DEffectAdd;
    procedure D2DEffectSub;
    procedure D2DEffectBlend; // used with alpha

    {verticies}
    procedure InitVertex;
    function D2DWhite: Integer;
    procedure D2DColoredVertex(c: Integer);
    function D2DAlphaVertex(Alpha: Integer): Integer;
    procedure D2DSpecularVertex(c: Integer);
    procedure D2DColAlpha(c, Alpha: Integer);
    // procedure D2DCol4Alpha(C1, C2, C3, C4, Alpha: Integer);    私有成员函数未调用   2019-10-07 18:01:33
    {Fade used with Add and Sub}
    function D2DFade(Alpha: Integer): Integer;
    procedure D2DFadeColored(c, Alpha: Integer);
    // procedure D2DFade4Colored(C1, C2, C3, C4, Alpha: Integer); 私有成员函数未调用   2019-10-07 18:01:33

    procedure RenderQuad;
    //  procedure RenderTri;                                      私有成员函数未调用   2019-10-07 18:01:33

    procedure D2DRect(R: TRect);
    procedure D2DTU(T: TTextureRec);
    {low lever version texturing for DDS}
    function D2DTexturedOnDDSTex(dds: TDirectDrawSurface; SubPatternRect: TRect;
      Transparent: Boolean): Integer;
    {texturing}
    function D2DTexturedOn(Image: TPictureCollectionItem; Pattern: Integer; SubPatternRect: TRect; RenderType: TRenderType): Boolean;
    function D2DTexturedOnDDS(dds: TDirectDrawSurface; SubPatternRect: TRect; Transparent: Boolean): Boolean;
    function D2DTexturedOnRect(Rect: TRect; Color: Integer): Boolean;

    {low level for rotate mesh}
    procedure D2DRotate(X, Y, W, H: Integer; Px, Py: Double; Angle: single);
    {low lever routine for mesh mapping}
    // procedure D2DMeshMapToRect(R: TRect);          私有成员函数未调用   2019-10-07 18:01:33
    function D2DMeshMapToWave(dds: TDirectDrawSurface; Transparent: Boolean;
      TransparentColor: Integer; X, Y, iWidth, iHeight, PatternIndex: Integer;
      PatternRect: TRect;
      amp, Len, ph, Alpha: Integer;
      Effect: TRenderType; DoY: Boolean{$IFDEF DelphiX_Spt4} = False{$ENDIF}): Boolean;
    property D2DTextures: TD2DTextures read FD2DTexture;
  public
    {destruction textures and supported objects here}
    destructor Destroy; override;
    {use before starting rendering}
    procedure BeginScene;
    {use after all images have been rendered}
    procedure EndScene;
    {set directly of texture filter}
    property TextureFilter: TD2DTextureFilter write SetD2DTextureFilter;
    property AntialiasFilter: TD3DAntialiasMode write SetD2DAntialiasFilter;
    {indicate using of this object}
    property CanUseD2D: Boolean read GetCanUseD2D write SetCanUseD2D;

    {set property mirror-flip}
    property MirrorFlip: TRenderMirrorFlipSet read FMirrorFlipSet write FMirrorFlipSet;

    {initialize surface}
    function D2DInitializeSurface: Boolean;

    {Render routines}
    function D2DRender(Image: TPictureCollectionItem; R: TRect;
      Pattern: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    function D2DRenderDDS(Source: TDirectDrawSurface; R: TRect; Transparent: Boolean;
      Pattern: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    function D2DRenderCol(Image: TPictureCollectionItem; R: TRect;
      Pattern, Color: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
    function D2DRenderColDDS(Source: TDirectDrawSurface; R: TRect;
      Transparent: Boolean; Pattern, Color: Integer; RenderType:
      TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    function D2DRenderDrawDDSXY(Source: TDirectDrawSurface; X, Y: Integer;
      Transparent: Boolean; Pattern: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
{$IFDEF DelphiX_Spt4} overload;
    function D2DRenderDrawDDSXY(Source: TDirectDrawSurface; X, Y: Integer;
      SrcRect: TRect; Transparent: Boolean; Pattern: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean; overload;
{$ENDIF}
    function D2DRenderDrawXY(Image: TPictureCollectionItem; X, Y: Integer;
      Pattern: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    {Rotate}
    function D2DRenderRotate(Image: TPictureCollectionItem; RotX, RotY,
      PictWidth, PictHeight, PatternIndex: Integer; RenderType: TRenderType;
      CenterX, CenterY: Double; Angle: single; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
    function D2DRenderRotateDDS(Image: TDirectDrawSurface; RotX, RotY,
      PictWidth, PictHeight: Integer; RenderType: TRenderType;
      CenterX, CenterY: Double; Angle: single; Alpha: Byte;
      Transparent: Boolean): Boolean;

    function D2DRenderRotateModeCol(Image: TPictureCollectionItem; RenderType: TRenderType; RotX, RotY,
      PictWidth, PictHeight, PatternIndex: Integer; CenterX, CenterY: Double;
      Angle: single; Color: Integer; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
    function D2DRenderRotateModeColDDS(Image: TDirectDrawSurface;
      RotX, RotY, PictWidth, PictHeight: Integer; RenderType: TRenderType;
      CenterX, CenterY: Double; Angle: single; Color: Integer; Alpha: Byte;
      Transparent: Boolean): Boolean;

    {WaveX}
    function D2DRenderWaveX(Image: TPictureCollectionItem; X, Y, Width, Height,
      PatternIndex: Integer; RenderType: TRenderType; Transparent: Boolean;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
    function D2DRenderWaveXDDS(Source: TDirectDrawSurface; X, Y, Width,
      Height: Integer; RenderType: TRenderType; Transparent: Boolean;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    {WaveY}
    function D2DRenderWaveY(Image: TPictureCollectionItem; X, Y, Width, Height,
      PatternIndex: Integer; RenderType: TRenderType; Transparent: Boolean;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
    function D2DRenderWaveYDDS(Source: TDirectDrawSurface; X, Y, Width,
      Height: Integer; RenderType: TRenderType; Transparent: Boolean;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    {Rect}
    function D2DRenderFillRect(Rect: TRect; RGBColor: Longint;
      RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    {addmod}
    function D2DRenderColoredPartition(Image: TPictureCollectionItem; DestRect: TRect; PatternIndex,
      Color, Specular: Integer; Faded: Boolean;
      SourceRect: TRect;
      RenderType: TRenderType;
      Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
  end;

  { Support functions for texturing }
function dxtMakeChannel(Mask: DWORD; indexed: Boolean): TDXTextureImageChannel;
function dxtEncodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;
function dxtDecodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;

{ Single support routine for convert DIB32 to DXT in one line }
procedure dib2dxt(DIBImage: TDIB; out DXTImage: TDXTextureImage);

{ One line call drawing with attributes }
{$IFDEF VER4UP}
procedure DXDraw_Draw(DXDraw: TCustomDXDraw; Image: TPictureCollectionItem;
  Rect: TRect; Pattern: Integer; TextureFilter: TD2DTextureFilter = D2D_POINT;
  MirrorFlip: TRenderMirrorFlipSet = [];
  BlendMode: TRenderType = rtDraw; Angle: single = 0; Alpha: Byte = 255;
  CenterX: Double = 0.5; CenterY: Double = 0.5;
  Scale: single = 1.0);
{$IFDEF VER9UP}inline;
{$ENDIF}
procedure DXDraw_Paint(DXDraw: TCustomDXDraw; Image: TPictureCollectionItem;
  Rect: TRect; Pattern: Integer; var BlurImageArr: TBlurImageArr; BlurImage: Boolean = False;
  TextureFilter: TD2DTextureFilter = D2D_POINT;
  MirrorFlip: TRenderMirrorFlipSet = [];
  BlendMode: TRenderType = rtDraw;
  Angle: single = 0;
  Alpha: Byte = 255;
  CenterX: Double = 0.5; CenterY: Double = 0.5);
{$IFDEF VER9UP}inline;
{$ENDIF}
procedure DXDraw_Render(DXDraw: TCustomDXDraw; Image: TPictureCollectionItem;
  Rect: TRect; Pattern: Integer; var BlurImageArr: TBlurImageArr; BlurImage: Boolean = False;
  TextureFilter: TD2DTextureFilter = D2D_POINT;
  MirrorFlip: TRenderMirrorFlipSet = [];
  BlendMode: TRenderType = rtDraw;
  Angle: single = 0;
  Alpha: Byte = 255;
  CenterX: Double = 0.5; CenterY: Double = 0.5;
  Scale: single = 1.0;
  WaveType: TWaveType = wtWaveNone;
  Amplitude: Integer = 0; AmpLength: Integer = 0; Phase: Integer = 0);
{$IFDEF VER9UP}inline;
{$ENDIF}
{$ELSE}
procedure DXDraw_Draw(DXDraw: TCustomDXDraw; Image: TPictureCollectionItem;
  Rect: TRect; Pattern: Integer; TextureFilter: TD2DTextureFilter;
  MirrorFlip: TRenderMirrorFlipSet;
  BlendMode: TRenderType; Angle: single; Alpha: Byte;
  CenterX: Double; CenterY: Double;
  Scale: single);
procedure DXDraw_Paint(DXDraw: TCustomDXDraw; Image: TPictureCollectionItem;
  Rect: TRect; Pattern: Integer; var BlurImageArr: TBlurImageArr; BlurImage: Boolean;
  TextureFilter: TD2DTextureFilter;
  MirrorFlip: TRenderMirrorFlipSet;
  BlendMode: TRenderType;
  Angle: single;
  Alpha: Byte;
  CenterX: Double; CenterY: Double);
procedure DXDraw_Render(DXDraw: TCustomDXDraw; Image: TPictureCollectionItem;
  Rect: TRect; Pattern: Integer; var BlurImageArr: TBlurImageArr; BlurImage: Boolean;
  TextureFilter: TD2DTextureFilter;
  MirrorFlip: TRenderMirrorFlipSet;
  BlendMode: TRenderType;
  Angle: single;
  Alpha: Byte;
  CenterX: Double; CenterY: Double;
  Scale: single;
  WaveType: TWaveType;
  Amplitude: Integer; AmpLength: Integer; Phase: Integer);
{$ENDIF}

//function TDirectDrawSurface_CreateEx(ADirectDraw: TDirectDraw; AWidth, AHeight: Integer; bSystemMemory: Boolean): TDirectDrawSurface;

implementation

uses DXConsts, DXRender, D3DUtils, ClFunc;

function DXDirectDrawEnumerate(lpCallback: TDDEnumCallbackA;
  lpContext: Pointer): HRESULT;
type
  TDirectDrawEnumerate = function(lpCallback: TDDEnumCallbackA;
    lpContext: Pointer): HRESULT; stdcall;
begin
  Result := TDirectDrawEnumerate(DXLoadLibrary('DDraw.dll', 'DirectDrawEnumerateA'))
    (lpCallback, lpContext);
end;

var
  DirectDrawDrivers: TDirectXDrivers;
  D2D: TD2D = nil; {for internal use only, }
  RenderError: Boolean = False;

function EnumDirectDrawDrivers: TDirectXDrivers;

  function DDENUMCALLBACK(lpGuid: PGUID; lpstrDescription: LPCSTR;
    lpstrModule: LPCSTR; lpContext: Pointer): BOOL; stdcall;
  begin
    Result := True;
    with TDirectXDriver.Create(TDirectXDrivers(lpContext)) do
    begin
      GUID := lpGuid;
      Description := lpstrDescription;
      DriverName := lpstrModule;
    end;
  end;

begin
  if DirectDrawDrivers = nil then
  begin
    DirectDrawDrivers := TDirectXDrivers.Create;
    try
      DXDirectDrawEnumerate(@DDENUMCALLBACK, DirectDrawDrivers);
    except
      DirectDrawDrivers.Free;
      raise;
    end;
  end;

  Result := DirectDrawDrivers;
end;

function ClipRect(var DestRect: TRect; const DestRect2: TRect): Boolean;
begin
  with DestRect do
  begin
    Left := Max(Left, DestRect2.Left);
    Right := Min(Right, DestRect2.Right);
    Top := Max(Top, DestRect2.Top);
    Bottom := Min(Bottom, DestRect2.Bottom);

    Result := (Left < Right) and (Top < Bottom);
  end;
end;

function ClipRect2(var DestRect, SrcRect: TRect; const DestRect2, SrcRect2: TRect): Boolean;
begin
  if DestRect.Left < DestRect2.Left then
  begin
    SrcRect.Left := SrcRect.Left + (DestRect2.Left - DestRect.Left);
    DestRect.Left := DestRect2.Left;
  end;

  if DestRect.Top < DestRect2.Top then
  begin
    SrcRect.Top := SrcRect.Top + (DestRect2.Top - DestRect.Top);
    DestRect.Top := DestRect2.Top;
  end;

  if SrcRect.Left < SrcRect2.Left then
  begin
    DestRect.Left := DestRect.Left + (SrcRect2.Left - SrcRect.Left);
    SrcRect.Left := SrcRect2.Left;
  end;

  if SrcRect.Top < SrcRect2.Top then
  begin
    DestRect.Top := DestRect.Top + (SrcRect2.Top - SrcRect.Top);
    SrcRect.Top := SrcRect2.Top;
  end;

  if DestRect.Right > DestRect2.Right then
  begin
    SrcRect.Right := SrcRect.Right - (DestRect.Right - DestRect2.Right);
    DestRect.Right := DestRect2.Right;
  end;

  if DestRect.Bottom > DestRect2.Bottom then
  begin
    SrcRect.Bottom := SrcRect.Bottom - (DestRect.Bottom - DestRect2.Bottom);
    DestRect.Bottom := DestRect2.Bottom;
  end;

  if SrcRect.Right > SrcRect2.Right then
  begin
    DestRect.Right := DestRect.Right - (SrcRect.Right - SrcRect2.Right);
    SrcRect.Right := SrcRect2.Right;
  end;

  if SrcRect.Bottom > SrcRect2.Bottom then
  begin
    DestRect.Bottom := DestRect.Bottom - (SrcRect.Bottom - SrcRect2.Bottom);
    SrcRect.Bottom := SrcRect2.Bottom;
  end;

  Result := (DestRect.Left < DestRect.Right) and (DestRect.Top < DestRect.Bottom) and
    (SrcRect.Left < SrcRect.Right) and (SrcRect.Top < SrcRect.Bottom);
end;

{  TDirectDraw  }

constructor TDirectDraw.Create(GUID: PGUID);
begin
  CreateEx(GUID, True);
end;

constructor TDirectDraw.CreateEx(GUID: PGUID; DirectX7Mode: Boolean);
type
  TDirectDrawCreate = function(lpGuid: PGUID; out lplpDD: IDirectDraw;
    pUnkOuter: IUnknown): HRESULT; stdcall;

  TDirectDrawCreateEx = function(lpGuid: PGUID; out lplpDD: IDirectDraw7; const iid: TGUID;
    pUnkOuter: IUnknown): HRESULT; stdcall;
begin
  inherited Create;
  FClippers := TList.Create;
  FPalettes := TList.Create;
  //FSurfaces := TList.Create;

  if DirectX7Mode then
  begin
    { DirectX 7 }
    if TDirectDrawCreateEx(DXLoadLibrary('DDraw.dll', 'DirectDrawCreateEx'))(GUID, FIDDraw7, IID_IDirectDraw7, nil) <> DD_OK then
      raise EDirectDrawError.CreateFmt(SCannotInitialized, [SDirectDraw]);
    try
      FIDDraw := FIDDraw7 as IDirectDraw;
      FIDDraw4 := FIDDraw7 as IDirectDraw4;
    except
      raise EDirectDrawError.Create(SSinceDirectX7);
    end;
  end
  else
  begin
    if TDirectDrawCreate(DXLoadLibrary('DDraw.dll', 'DirectDrawCreate'))(GUID, FIDDraw, nil) <> DD_OK then
      raise EDirectDrawError.CreateFmt(SCannotInitialized, [SDirectDraw]);
    try
      FIDDraw4 := FIDDraw as IDirectDraw4;
    except
      raise EDirectDrawError.Create(SSinceDirectX6);
    end;
  end;

  FDriverCaps.dwSize := SizeOf(FDriverCaps);
  FHELCaps.dwSize := SizeOf(FHELCaps);
  FIDDraw.GetCaps(@FDriverCaps, @FHELCaps);
end;

destructor TDirectDraw.Destroy;
begin
  //while SurfaceCount > 0 do
  //  Surfaces[SurfaceCount - 1].Free;

  while PaletteCount > 0 do
    Palettes[PaletteCount - 1].Free;

  while ClipperCount > 0 do
    Clippers[ClipperCount - 1].Free;

  //FSurfaces.Free;
  FPalettes.Free;
  FClippers.Free;
  inherited Destroy;
end;

class function TDirectDraw.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectDrawDrivers;
end;

function TDirectDraw.GetClipper(Index: Integer): TDirectDrawClipper;
begin
  Result := FClippers[Index];
end;

function TDirectDraw.GetClipperCount: Integer;
begin
  Result := FClippers.Count;
end;

function TDirectDraw.GetDisplayMode: TDDSurfaceDesc;
begin
  Result.dwSize := SizeOf(Result);
  DXResult := IDraw.GetDisplayMode(Result);
  if DXResult <> DD_OK then
    FillChar(Result, SizeOf(Result), 0);
end;

function TDirectDraw.GetIDDraw: IDirectDraw;
begin
  if Self <> nil then
    Result := FIDDraw
  else
    Result := nil;
end;

function TDirectDraw.GetIDDraw4: IDirectDraw4;
begin
  if Self <> nil then
    Result := FIDDraw4
  else
    Result := nil;
end;

function TDirectDraw.GetIDDraw7: IDirectDraw7;
begin
  if Self <> nil then
    Result := FIDDraw7
  else
    Result := nil;
end;

function TDirectDraw.GetIDraw: IDirectDraw;
begin
  Result := IDDraw;
  if Result = nil then
    raise EDirectDrawError.CreateFmt(SNotMade, ['IDirectDraw']);
end;

function TDirectDraw.GetIDraw4: IDirectDraw4;
begin
  Result := IDDraw4;
  if Result = nil then
    raise EDirectDrawError.CreateFmt(SNotMade, ['IDirectDraw4']);
end;

function TDirectDraw.GetIDraw7: IDirectDraw7;
begin
  Result := IDDraw7;
  if Result = nil then
    raise EDirectDrawError.CreateFmt(SNotMade, ['IDirectDraw7']);
end;

function TDirectDraw.GetPalette(Index: Integer): TDirectDrawPalette;
begin
  Result := FPalettes[Index];
end;

function TDirectDraw.GetPaletteCount: Integer;
begin
  Result := FPalettes.Count;
end;

{function TDirectDraw.GetSurface(Index: Integer): TDirectDrawSurface;
begin
  Result := FSurfaces[Index];
end;

function TDirectDraw.GetSurfaceCount: Integer;
begin
  Result := FSurfaces.Count;
end;}

{  TDirectDrawPalette  }

constructor TDirectDrawPalette.Create(ADirectDraw: TDirectDraw);
begin
  inherited Create;
  FDDraw := ADirectDraw;
  FDDraw.FPalettes.Add(Self);
end;

destructor TDirectDrawPalette.Destroy;
begin
  FDDraw.FPalettes.Remove(Self);
  inherited Destroy;
end;

function TDirectDrawPalette.CreatePalette(Caps: DWORD; const Entries): Boolean;
var
  TempPalette: IDirectDrawPalette;
begin
  IDDPalette := nil;

  FDDraw.DXResult := FDDraw.IDraw.CreatePalette(Caps, @Entries, TempPalette, nil);
  FDXResult := FDDraw.DXResult;
  Result := FDDraw.DXResult = DD_OK;
  if Result then
    IDDPalette := TempPalette;
end;

procedure TDirectDrawPalette.LoadFromDIB(DIB: TDIB);
var
  Entries: TPaletteEntries;
begin
  Entries := RGBQuadsToPaletteEntries(DIB.ColorTable);
  CreatePalette(DDPCAPS_8BIT, Entries);
end;

procedure TDirectDrawPalette.LoadFromFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TDirectDrawPalette.LoadFromStream(Stream: TStream);
var
  DIB: TDIB;
begin
  DIB := TDIB.Create;
  try
    DIB.LoadFromStream(Stream);
    if DIB.Size > 0 then
      LoadFromDIB(DIB);
  finally
    DIB.Free;
  end;
end;

function TDirectDrawPalette.GetEntries(StartIndex, NumEntries: Integer;
  var Entries): Boolean;
begin
  if IDDPalette <> nil then
  begin
    DXResult := IPalette.GetEntries(0, StartIndex, NumEntries, @Entries);
    Result := DXResult = DD_OK;
  end
  else
    Result := False;
end;

function TDirectDrawPalette.GetEntry(Index: Integer): TPaletteEntry;
begin
  GetEntries(Index, 1, Result);
end;

function TDirectDrawPalette.GetIDDPalette: IDirectDrawPalette;
begin
  if Self <> nil then
    Result := FIDDPalette
  else
    Result := nil;
end;

function TDirectDrawPalette.GetIPalette: IDirectDrawPalette;
begin
  Result := IDDPalette;
  if Result = nil then
    raise EDirectDrawPaletteError.CreateFmt(SNotMade, ['IDirectDrawPalette']);
end;

function TDirectDrawPalette.SetEntries(StartIndex, NumEntries: Integer;
  const Entries): Boolean;
begin
  if IDDPalette <> nil then
  begin
    DXResult := IPalette.SetEntries(0, StartIndex, NumEntries, @Entries);
    Result := DXResult = DD_OK;
  end
  else
    Result := False;
end;

procedure TDirectDrawPalette.SetEntry(Index: Integer; Value: TPaletteEntry);
begin
  SetEntries(Index, 1, Value);
end;

procedure TDirectDrawPalette.SetIDDPalette(Value: IDirectDrawPalette);
begin
  if FIDDPalette = Value then
    Exit;
  FIDDPalette := Value;
end;

{  TDirectDrawClipper  }

constructor TDirectDrawClipper.Create(ADirectDraw: TDirectDraw);
begin
  inherited Create;
  FDDraw := ADirectDraw;
  FDDraw.FClippers.Add(Self);

  FDDraw.DXResult := FDDraw.IDraw.CreateClipper(0, FIDDClipper, nil);
  if FDDraw.DXResult <> DD_OK then
    raise EDirectDrawClipperError.CreateFmt(SCannotMade, [SDirectDrawClipper]);
end;

destructor TDirectDrawClipper.Destroy;
begin
  FDDraw.FClippers.Remove(Self);
  inherited Destroy;
end;

function TDirectDrawClipper.GetIDDClipper: IDirectDrawClipper;
begin
  if Self <> nil then
    Result := FIDDClipper
  else
    Result := nil;
end;

function TDirectDrawClipper.GetIClipper: IDirectDrawClipper;
begin
  Result := IDDClipper;
  if Result = nil then
    raise EDirectDrawClipperError.CreateFmt(SNotMade, ['IDirectDrawClipper']);
end;

procedure TDirectDrawClipper.SetClipRects(const Rects: array of TRect);
type
  PArrayRect = ^TArrayRect;
  TArrayRect = array[0..0] of TRect;
var
  RgnData: PRgnData;
  i: Integer;
  BoundsRect: TRect;
begin
  BoundsRect := Rect(MaxInt, MaxInt, -MaxInt, -MaxInt);
  for i := Low(Rects) to High(Rects) do
  begin
    with BoundsRect do
    begin
      Left := Min(Rects[i].Left, Left);
      Right := Max(Rects[i].Right, Right);
      Top := Min(Rects[i].Top, Top);
      Bottom := Max(Rects[i].Bottom, Bottom);
    end;
  end;

  GetMem(RgnData, SizeOf(TRgnDataHeader) + SizeOf(TRect) * (High(Rects) - Low(Rects) + 1));
  try
    with RgnData^.rdh do
    begin
      dwSize := SizeOf(TRgnDataHeader);
      iType := RDH_RECTANGLES;
      nCount := High(Rects) - Low(Rects) + 1;
      nRgnSize := nCount * SizeOf(TRect);
      rcBound := BoundsRect;
    end;
    for i := Low(Rects) to High(Rects) do
      PArrayRect(@RgnData^.Buffer)^[i - Low(Rects)] := Rects[i];
    DXResult := IClipper.SetClipList(RgnData, 0);
  finally
    FreeMem(RgnData);
  end;
end;

procedure TDirectDrawClipper.SetHandle(Value: THandle);
begin
  DXResult := IClipper.SetHWnd(0, Value);
end;

procedure TDirectDrawClipper.SetIDDClipper(Value: IDirectDrawClipper);
begin
  if FIDDClipper = Value then
    Exit;
  FIDDClipper := Value;
end;

{  TDirectDrawSurfaceCanvas  }

constructor TDirectDrawSurfaceCanvas.Create(ASurface: TDirectDrawSurface);
begin
  inherited Create;
  FSurface := ASurface;
end;

destructor TDirectDrawSurfaceCanvas.Destroy;
begin
  Release;
  FSurface.FCanvas := nil;
  inherited Destroy;
end;

procedure TDirectDrawSurfaceCanvas.CreateHandle;
begin
  FSurface.DXResult := FSurface.ISurface.GetDC(FDC);
  if FSurface.DXResult = DD_OK then
    Handle := FDC;
end;

procedure TDirectDrawSurfaceCanvas.Release;
begin
  if (FSurface.IDDSurface <> nil) and (FDC <> 0) then
  begin
    Handle := 0;
    FSurface.IDDSurface.ReleaseDC(FDC);
    FDC := 0;
  end;
end;

procedure TDirectDrawSurfaceCanvas.TextOutA(X, Y: Integer; const Text: string; IsTransparent: Boolean);
begin
 //  OutputDebugString(pchar(Text));
  ClFunc.DxBoldTextOut(FSurface, X, Y, FSurface.Canvas.Font.Color, clBlack, Text, 0, IsTransparent);
end;

function TDirectDrawSurfaceCanvas.TextExtentA(const Text: string): TSize;
var
  DestTopHDC: HDC;
  OrigiFont: HFONT;
begin
  Result.cX := 0;
  Result.cY := 0;
  DestTopHDC := Windows.GetDC(0);
  if DestTopHDC = 0 then
    Exit;
  try
    OrigiFont := SelectObject(DestTopHDC, FSurface.Canvas.Font.Handle);
    Windows.GetTextExtentPoint32(DestTopHDC, PChar(Text), Length(Text), Result);
    SelectObject(DestTopHDC, OrigiFont);
  finally
    ReleaseDC(0, DestTopHDC);
  end;
end;

function TDirectDrawSurfaceCanvas.TextWidth(const Text: string; Bold: Boolean; FontSize: Integer): Integer;
begin
  if (FontSize = 9) and not Bold then
  begin
    Result := Length(Text) * 6;
  end
  else
  begin
    Result := Self.TextExtentA(Text).cX;
  end;
end;

function TDirectDrawSurfaceCanvas.TextHeight(const Text: string; Bold: Boolean; FontSize: Integer): Integer;
begin
  if (FontSize = 9) and not Bold then
  begin
    Result := 12;
  end
  else
  begin
    Result := Self.TextExtentA(Text).cY;
  end;
end;

{  TDirectDrawSurface  }

constructor TDirectDrawSurface.Create(ADirectDraw: TDirectDraw { AWidth, AHeight: Integer; bSystemMemory: Boolean});
begin
  inherited Create;
  FDDraw := ADirectDraw;
  //FDDraw.FSurfaces.Add(Self);
  FAnti := False;
end;

{function TDirectDrawSurface_CreateEx(ADirectDraw: TDirectDraw; AWidth, AHeight: Integer; bSystemMemory: Boolean): TDirectDrawSurface;
begin
  Result := TDirectDrawSurface.Create(ADirectDraw);
  Result.m_boBlend := False;
  if bSystemMemory then begin
    if not Result.SetSize(AWidth, AHeight) then
      Result := nil;
  end else begin
    Result.SystemMemory := True;
    Result.SetSize(AWidth, AHeight);
  end;
end;}

destructor TDirectDrawSurface.Destroy;
begin
  FCanvas.Free;
  IDDSurface := nil;
  //FDDraw.FSurfaces.Remove(Self);
  inherited Destroy;
end;

function TDirectDrawSurface.GetIDDSurface: IDirectDrawSurface;
begin
  if Self <> nil then
    Result := FIDDSurface
  else
    Result := nil;
end;

function TDirectDrawSurface.GetIDDSurface4: IDirectDrawSurface4;
begin
  if Self <> nil then
    Result := FIDDSurface4
  else
    Result := nil;
end;

function TDirectDrawSurface.GetIDDSurface7: IDirectDrawSurface7;
begin
  if Self <> nil then
    Result := FIDDSurface7
  else
    Result := nil;
end;

function TDirectDrawSurface.GetISurface: IDirectDrawSurface;
begin
  Result := IDDSurface;
  if Result = nil then
    raise EDirectDrawSurfaceError.CreateFmt(SNotMade, ['IDirectDrawSurface']);
end;

function TDirectDrawSurface.GetISurface4: IDirectDrawSurface4;
begin
  Result := IDDSurface4;
  if Result = nil then
    raise EDirectDrawSurfaceError.CreateFmt(SNotMade, ['IDirectDrawSurface4']);
end;

function TDirectDrawSurface.GetISurface7: IDirectDrawSurface7;
begin
  Result := IDDSurface7;
  if Result = nil then
    raise EDirectDrawSurfaceError.CreateFmt(SNotMade, ['IDirectDrawSurface7']);
end;

procedure TDirectDrawSurface.SetIDDSurface(Value: IDirectDrawSurface);
var
  Clipper: IDirectDrawClipper;
begin
  //if Value = nil then Exit;    //1010
  if Value as IDirectDrawSurface = FIDDSurface then
    Exit;

  FIDDSurface := nil;
  FIDDSurface4 := nil;
  FIDDSurface7 := nil;

  FStretchDrawClipper := nil;
  FGammaControl := nil;
  FHasClipper := False;
  //FLockCount := 0;
  FIsLocked := False;
  FillChar(FSurfaceDesc, SizeOf(FSurfaceDesc), 0);

  if Value <> nil then
  begin
    FIDDSurface := Value as IDirectDrawSurface;
    FIDDSurface4 := Value as IDirectDrawSurface4;
    if FDDraw.FIDDraw7 <> nil then
      FIDDSurface7 := Value as IDirectDrawSurface7;

    FHasClipper := (FIDDSurface.GetClipper(Clipper) = DD_OK) and (Clipper <> nil);

    FSurfaceDesc.dwSize := SizeOf(FSurfaceDesc);
    FIDDSurface.GetSurfaceDesc(FSurfaceDesc);

    if FDDraw.DriverCaps.dwCaps2 and DDCAPS2_PRIMARYGAMMA <> 0 then
      FIDDSurface.QueryInterface(IID_IDirectDrawGammaControl, FGammaControl);
  end;
end;

procedure TDirectDrawSurface.SetIDDSurface4(Value: IDirectDrawSurface4);
begin
  if Value = nil then
    SetIDDSurface(nil)
  else
    SetIDDSurface(Value as IDirectDrawSurface);
end;

procedure TDirectDrawSurface.SetIDDSurface7(Value: IDirectDrawSurface7);
begin
  if Value = nil then
    SetIDDSurface(nil)
  else
    SetIDDSurface(Value as IDirectDrawSurface);
end;

procedure TDirectDrawSurface.Assign(Source: TPersistent);
var
  TempSurface: IDirectDrawSurface;
begin
  if Source = nil then
    IDDSurface := nil
  else if Source is TGraphic then
    LoadFromGraphic(TGraphic(Source))
  else if Source is TPicture then
    LoadFromGraphic(TPicture(Source).Graphic)
  else if Source is TDirectDrawSurface then
  begin
    if TDirectDrawSurface(Source).IDDSurface = nil then
      IDDSurface := nil
    else
    begin
      FDDraw.DXResult := FDDraw.IDraw.DuplicateSurface(TDirectDrawSurface(Source).IDDSurface,
        TempSurface);
      if FDDraw.DXResult = 0 then
      begin
        IDDSurface := TempSurface;
      end;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TDirectDrawSurface.AssignTo(Dest: TPersistent);
begin
  if Dest is TDIB then
  begin
    try
      if BitCount >= 24 then {please accept the Alphachannel too}
        TDIB(Dest).SetSize(Width, Height, BitCount)
      else
        TDIB(Dest).SetSize(Width, Height, 24);
      TDIB(Dest).Canvas.CopyRect(Rect(0, 0, TDIB(Dest).Width, TDIB(Dest).Height), Canvas, ClientRect);
    finally
      Canvas.Release;
    end
  end
  else
    inherited AssignTo(Dest);
end;

function TDirectDrawSurface.Blt(const DestRect, SrcRect: TRect; Flags: DWORD;
  const DF: TDDBltFX; Source: TDirectDrawSurface): Boolean;
begin
  if IDDSurface <> nil then
  begin
    if Source <> nil then
      DXResult := ISurface.Blt(@DestRect, Source.IDDSurface, @SrcRect, DWORD(Flags), @DF)
    else
      DXResult := ISurface.Blt(@DestRect, nil, @SrcRect, DWORD(Flags), @DF); //1010
    Result := DXResult = DD_OK;
  end
  else
    Result := False;
end;

function TDirectDrawSurface.BltFast(X, Y: Integer; const SrcRect: TRect;
  Flags: DWORD; Source: TDirectDrawSurface): Boolean;
begin
  if IDDSurface <> nil then
  begin
    if Source <> nil then
      DXResult := ISurface.BltFast(X, Y, Source.IDDSurface, @SrcRect, DWORD(Flags))
    else
      DXResult := ISurface.BltFast(X, Y, nil, @SrcRect, DWORD(Flags)); //1010
    Result := DXResult = DD_OK;
  end
  else
    Result := False;
end;

function TDirectDrawSurface.ColorMatch(Col: TColor): Integer;
var
  DIB: TDIB;
  i, oldc: Integer;
begin
  if IDDSurface <> nil then
  begin
    oldc := Pixels[0, 0];

    DIB := TDIB.Create;
    try
      i := ColorToRGB(Col);
      DIB.SetSize(1, 1, 8);
      DIB.ColorTable[0] := RGBQuad(GetRValue(i), GetGValue(i), GetBValue(i));
      DIB.UpdatePalette;
      DIB.Pixels[0, 0] := 0;

      with Canvas do
      try
        Draw(0, 0, DIB);
      finally
        Release;
      end;
    finally
      DIB.Free;
    end;
    Result := Pixels[0, 0];
    Pixels[0, 0] := oldc;
  end
  else
    Result := 0;
end;

function TDirectDrawSurface.CreateSurface(SurfaceDesc: TDDSurfaceDesc): Boolean;
var
  TempSurface: IDirectDrawSurface;
begin
  IDDSurface := nil;

  FDDraw.DXResult := FDDraw.IDraw.CreateSurface(SurfaceDesc, TempSurface, nil);
  FDXResult := FDDraw.DXResult;
  Result := FDDraw.DXResult = DD_OK;
  if Result then
  begin
    IDDSurface := TempSurface;
    TransparentColor := 0;
  end;
end;

{$IFDEF DelphiX_Spt4}

function TDirectDrawSurface.CreateSurface(SurfaceDesc: TDDSurfaceDesc2): Boolean;
var
  TempSurface4: IDirectDrawSurface4;
begin
  IDDSurface := nil;
  FDDraw.DXResult := FDDraw.IDraw4.CreateSurface(SurfaceDesc, TempSurface4, nil);
  FDXResult := FDDraw.DXResult;
  Result := FDDraw.DXResult = DD_OK;
  if Result then
  begin
    IDDSurface4 := TempSurface4;
    TransparentColor := 0;
  end;
end;
{$ENDIF}

var
  g_DF: TDDBltFX;
  g_DBltEx: TDDBltFX;

procedure TDirectDrawSurface.Draw(X, Y: Integer; SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean);
const
  BltFastFlags: array[Boolean] of Integer = (DDBLTFAST_NOCOLORKEY or DDBLTFAST_WAIT, DDBLTFAST_SRCCOLORKEY or DDBLTFAST_WAIT);
  BltFlags: array[Boolean] of Integer = (DDBLT_WAIT, DDBLT_KEYSRC or DDBLT_WAIT);
var
  DestRect: TRect;
  //DF                        : TDDBltFX;     //1010
  Clipper: IDirectDrawClipper;
  i: Integer;
begin
  if Source <> nil then
  begin
    if (X > Width) or (Y > Height) then Exit;

{$IFDEF DrawHWAcc}
    if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
    begin
{$IFDEF DelphiX_Delphi3}
      D2D.D2DRenderDDS(Source, Bounds(X, Y, SrcRect.Right - SrcRect.Left, SrcRect.Bottom - SrcRect.Top), Transparent, 0, rtDraw, $FF);
{$ELSE}
      D2D.D2DRenderDrawDDSXY(Source, X, Y, SrcRect, Transparent, 0, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
{$ENDIF}
      Exit;
    end;
{$ENDIF DrawHWAcc}

    if (SrcRect.Left > SrcRect.Right) or (SrcRect.Top > SrcRect.Bottom) then
    begin
      {  Mirror  }
      if ((X + Abs(SrcRect.Left - SrcRect.Right)) <= 0) or ((Y + Abs(SrcRect.Top - SrcRect.Bottom)) <= 0) then
        Exit;

      //g_DF.dwSize := SizeOf(g_DF);
      g_DF.dwDDFX := 0;

      if SrcRect.Left > SrcRect.Right then
      begin
        i := SrcRect.Left;
        SrcRect.Left := SrcRect.Right;
        SrcRect.Right := i;
        g_DF.dwDDFX := g_DF.dwDDFX or DDBLTFX_MIRRORLEFTRIGHT;
      end;

      if SrcRect.Top > SrcRect.Bottom then
      begin
        i := SrcRect.Top;
        SrcRect.Top := SrcRect.Bottom;
        SrcRect.Bottom := i;
        g_DF.dwDDFX := g_DF.dwDDFX or DDBLTFX_MIRRORUPDOWN;
      end;

      with SrcRect do
        DestRect := Bounds(X, Y, Right - Left, Bottom - Top);

      if ClipRect2(DestRect, SrcRect, ClientRect, Source.ClientRect) then
      begin
        if g_DF.dwDDFX and DDBLTFX_MIRRORLEFTRIGHT <> 0 then
        begin
          i := SrcRect.Left;
          SrcRect.Left := Source.Width - SrcRect.Right;
          SrcRect.Right := Source.Width - i;
        end;

        if g_DF.dwDDFX and DDBLTFX_MIRRORUPDOWN <> 0 then
        begin
          i := SrcRect.Top;
          SrcRect.Top := Source.Height - SrcRect.Bottom;
          SrcRect.Bottom := Source.Height - i;
        end;

        Blt(DestRect, SrcRect, BltFlags[Transparent] or DDBLT_DDFX, g_DF, Source);
      end;
    end
    else
    begin
      with SrcRect do
        DestRect := Bounds(X, Y, Right - Left, Bottom - Top);

      if ClipRect2(DestRect, SrcRect, ClientRect, Source.ClientRect) then
      begin
        if FHasClipper then
        begin
          //g_DF.dwSize := SizeOf(g_DF);
          g_DF.dwDDFX := 0;
          Blt(DestRect, SrcRect, BltFlags[Transparent], g_DF, Source);
        end
        else
        begin
          BltFast(DestRect.Left, DestRect.Top, SrcRect, BltFastFlags[Transparent], Source);
          if DXResult = DDERR_BLTFASTCANTCLIP then
          begin
            ISurface.GetClipper(Clipper);
            if Clipper <> nil then
              FHasClipper := True;

            //g_DF.dwSize := SizeOf(g_DF);
            g_DF.dwDDFX := 0;
            Blt(DestRect, SrcRect, BltFlags[Transparent], g_DF, Source);
          end;
        end;
      end;
    end;
  end;
end;

{$IFDEF DelphiX_Spt4}

procedure TDirectDrawSurface.Draw(X, Y: Integer; Source: TDirectDrawSurface; Transparent: Boolean);
const
  BltFastFlags: array[Boolean] of Integer = (DDBLTFAST_NOCOLORKEY or DDBLTFAST_WAIT, DDBLTFAST_SRCCOLORKEY or DDBLTFAST_WAIT);
  BltFlags: array[Boolean] of Integer = (DDBLT_WAIT, DDBLT_KEYSRC or DDBLT_WAIT);
var
  DestRect, SrcRect: TRect;
  DF: TDDBltFX;
  Clipper: IDirectDrawClipper;
begin
  if Source <> nil then
  begin
    SrcRect := Source.ClientRect;
    DestRect := Bounds(X, Y, Source.Width, Source.Height);
{$IFDEF DrawHWAcc}
    if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
    begin
      D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      Exit;
    end;
{$ENDIF DrawHWAcc}
    if ClipRect2(DestRect, SrcRect, ClientRect, Source.ClientRect) then
    begin
      if FHasClipper then
      begin
        DF.dwSize := SizeOf(DF);
        DF.dwDDFX := 0;
        Blt(DestRect, SrcRect, BltFlags[Transparent], DF, Source);
      end
      else
      begin
        BltFast(DestRect.Left, DestRect.Top, SrcRect, BltFastFlags[Transparent], Source);
        if DXResult = DDERR_BLTFASTCANTCLIP then
        begin
          ISurface.GetClipper(Clipper);
          if Clipper <> nil then
            FHasClipper := True;

          DF.dwSize := SizeOf(DF);
          DF.dwDDFX := 0;
          Blt(DestRect, SrcRect, BltFlags[Transparent], DF, Source);
        end;
      end;
    end;
  end;
end;
{$ENDIF}

procedure TDirectDrawSurface.StretchDraw(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean);
const
  BltFlags: array[Boolean] of Integer =
  (DDBLT_WAIT, DDBLT_KEYSRC or DDBLT_WAIT);
var
  DF: TDDBltFX;
  OldClipper: IDirectDrawClipper;
  Clipper: TDirectDrawClipper;
begin
  if Source <> nil then
  begin
    if (DestRect.Bottom <= DestRect.Top) or (DestRect.Right <= DestRect.Left) then
      Exit;
    if (SrcRect.Bottom <= SrcRect.Top) or (SrcRect.Right <= SrcRect.Left) then
      Exit;
{$IFDEF DrawHWAcc}
    if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
    begin
      D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      Exit;
    end;
{$ENDIF DrawHWAcc}
    if FHasClipper then
    begin
      DF.dwSize := SizeOf(DF);
      DF.dwDDFX := 0;
      Blt(DestRect, SrcRect, BltFlags[Transparent], DF, Source);
    end
    else
    begin
      if FStretchDrawClipper = nil then
      begin
        Clipper := TDirectDrawClipper.Create(DDraw);
        try
          Clipper.SetClipRects([ClientRect]);
          FStretchDrawClipper := Clipper.IClipper;
        finally
          Clipper.Free;
        end;
      end;

      ISurface.GetClipper(OldClipper);
      ISurface.SetClipper(FStretchDrawClipper);
      DF.dwSize := SizeOf(DF);
      DF.dwDDFX := 0;
      Blt(DestRect, SrcRect, BltFlags[Transparent], DF, Source);
      ISurface.SetClipper(nil);
    end;
  end;
end;

{$IFDEF DelphiX_Spt4}

procedure TDirectDrawSurface.StretchDraw(const DestRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean);
const
  BltFlags: array[Boolean] of Integer =

  (DDBLT_WAIT, DDBLT_KEYSRC or DDBLT_WAIT);
var
  DF: TDDBltFX;
  OldClipper: IDirectDrawClipper;
  Clipper: TDirectDrawClipper;
  SrcRect: TRect;
begin
  if Source <> nil then
  begin
    if (DestRect.Bottom <= DestRect.Top) or (DestRect.Right <= DestRect.Left) then
      Exit;
    SrcRect := Source.ClientRect;

    if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
    begin
      D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      Exit;
    end;

    if ISurface.GetClipper(OldClipper) = DD_OK then
    begin
      DF.dwSize := SizeOf(DF);
      DF.dwDDFX := 0;
      Blt(DestRect, SrcRect, BltFlags[Transparent], DF, Source);
    end
    else
    begin
      if FStretchDrawClipper = nil then
      begin
        Clipper := TDirectDrawClipper.Create(DDraw);
        try
          Clipper.SetClipRects([ClientRect]);
          FStretchDrawClipper := Clipper.IClipper;
        finally
          Clipper.Free;
        end;
      end;

      ISurface.SetClipper(FStretchDrawClipper);
      try
        DF.dwSize := SizeOf(DF);
        DF.dwDDFX := 0;
        Blt(DestRect, SrcRect, BltFlags[Transparent], DF, Source);
      finally
        ISurface.SetClipper(nil);
      end;
    end;
  end;
end;
{$ENDIF}

procedure TDirectDrawSurface.DrawAdd(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Alpha <= 0 then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtAdd, Alpha);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else if Alpha >= 255 then
          begin
            Blend := DXR_BLEND_ONE1_ADD_ONE2;
          end
          else
          begin
            Blend := DXR_BLEND_SRCALPHA1_ADD_ONE2;
          end;

          dxrCopyRectBlend(DestSurface, SrcSurface,
            DestRect, SrcRect, Blend, Alpha, Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawAlpha(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Alpha <= 0 then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtBlend, Alpha);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else if Alpha >= 255 then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else
          begin
            Blend := DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2;
          end;

          dxrCopyRectBlend(DestSurface, SrcSurface,
            DestRect, SrcRect, Blend, Alpha, Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawSub(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Alpha <= 0 then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtSub, Alpha);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else if Alpha >= 255 then
          begin
            Blend := DXR_BLEND_ONE2_SUB_ONE1;
          end
          else
          begin
            Blend := DXR_BLEND_ONE2_SUB_SRCALPHA1;
          end;

          dxrCopyRectBlend(DestSurface, SrcSurface,
            DestRect, SrcRect, Blend, Alpha, Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawAlphaCol(const DestRect, SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Alpha <= 0 then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderColDDS(Source, DestRect, Transparent, 0, Color, rtBlend, Alpha);
    Exit;
  end;

  // If no hardware acceleration, falls back to non-color DrawAlpha
  Self.DrawAlpha(DestRect, SrcRect, Source, Transparent, Alpha);
end;

procedure TDirectDrawSurface.DrawSubCol(const DestRect, SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Alpha <= 0 then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderColDDS(Source, DestRect, Transparent, 0, Color, rtSub, Alpha);
    Exit;
  end;

  // If no hardware acceleration, falls back to non-color DrawSub
  Self.DrawSub(DestRect, SrcRect, Source, Transparent, Alpha);
end;

procedure TDirectDrawSurface.DrawAddCol(const DestRect, SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Alpha <= 0 then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderColDDS(Source, DestRect, Transparent, 0, Color, rtAdd, Alpha);
    Exit;
  end;

  // If no hardware acceleration, falls back to non-color DrawAdd
  Self.DrawAdd(DestRect, SrcRect, Source, Transparent, Alpha);

end;

procedure TDirectDrawSurface.DrawRotate(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderRotateDDS(Source, X, Y, Width, Height, rtDraw, CenterX, CenterY, Angle, $FF, Transparent);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, Round(Angle), DXR_BLEND_ONE1, 0,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawRotateAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then
    Exit;

  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderRotateDDS(Source, X, Y, Width, Height, rtAdd, CenterX, CenterY, Angle, Alpha, Transparent);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else if Alpha >= 255 then
          begin
            Blend := DXR_BLEND_ONE1_ADD_ONE2;
          end
          else
          begin
            Blend := DXR_BLEND_SRCALPHA1_ADD_ONE2;
          end;

          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, Round(Angle), Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawRotateAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then
    Exit;

  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderRotateDDS(Source, X, Y, Width, Height, rtBlend, CenterX, CenterY, Angle, Alpha, Transparent);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else if Alpha >= 255 then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else
          begin
            Blend := DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2;
          end;

          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, Round(Angle), Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawRotateSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then
    Exit;

  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderRotateDDS(Source, X, Y, Width, Height, rtSub, CenterX, CenterY, Angle, Alpha, Transparent);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else if Alpha >= 255 then
          begin
            Blend := DXR_BLEND_ONE2_SUB_ONE1;
          end
          else
          begin
            Blend := DXR_BLEND_ONE2_SUB_SRCALPHA1;
          end;

          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, Round(Angle), Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawRotateCol(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single; Color: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderRotateModeColDDS(Source, X, Y, Width, Height, rtDraw, CenterX, CenterY, Angle, Color, $FF, Transparent);
    Exit;
  end;

  // If no hardware acceleration, falls back to non-color, moded DrawRotate
  Self.DrawRotate(X, Y, Width, Height, SrcRect, Source, CenterX, CenterY, Transparent, Angle);
end;

procedure TDirectDrawSurface.DrawRotateAlphaCol(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderRotateModeColDDS(Source, X, Y, Width, Height, rtBlend, CenterX, CenterY, Angle, Color, Alpha, Transparent);
    Exit;
  end;

  // If no hardware acceleration, falls back to non-color, moded DrawRotate
  Self.DrawRotateAlpha(X, Y, Width, Height, SrcRect, Source, CenterX, CenterY, Transparent, Angle, Alpha);
end;

procedure TDirectDrawSurface.DrawRotateAddCol(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderRotateModeColDDS(Source, X, Y, Width, Height, rtAdd, CenterX, CenterY, Angle, Color, Alpha, Transparent);
    Exit;
  end;

  // If no hardware acceleration, falls back to non-color, moded DrawRotate
  Self.DrawRotateAdd(X, Y, Width, Height, SrcRect, Source, CenterX, CenterY, Transparent, Angle, Alpha);
end;

procedure TDirectDrawSurface.DrawRotateSubCol(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderRotateModeColDDS(Source, X, Y, Width, Height, rtSub, CenterX, CenterY, Angle, Color, Alpha, Transparent);
    Exit;
  end;

  // If no hardware acceleration, falls back to non-color, moded DrawRotate
  Self.DrawRotateSub(X, Y, Width, Height, SrcRect, Source, CenterX, CenterY, Transparent, Angle, Alpha);
end;

//waves

procedure TDirectDrawSurface.DrawWaveX(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderWaveXDDS(Source, X, Y, Width, Height, rtDraw, Transparent, amp, Len, ph{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          dxrDrawWaveXBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, amp, Len, ph, DXR_BLEND_ONE1, 0,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawWaveXAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph, Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then
    Exit;

  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderWaveXDDS(Source, X, Y, Width, Height, rtAdd, Transparent, amp, Len, ph, Alpha);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else if Alpha >= 255 then
          begin
            Blend := DXR_BLEND_ONE1_ADD_ONE2;
          end
          else
          begin
            Blend := DXR_BLEND_SRCALPHA1_ADD_ONE2;
          end;

          dxrDrawWaveXBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, amp, Len, ph, Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawWaveXAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph, Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then
    Exit;

  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderWaveXDDS(Source, X, Y, Width, Height, rtBlend, Transparent, amp, Len, ph, Alpha);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else if Alpha >= 255 then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else
          begin
            Blend := DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2;
          end;

          dxrDrawWaveXBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, amp, Len, ph, Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawWaveXSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph, Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then
    Exit;

  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderWaveXDDS(Source, X, Y, Width, Height, rtSub, Transparent, amp, Len, ph, Alpha);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end
          else if Alpha >= 255 then
          begin
            Blend := DXR_BLEND_ONE2_SUB_ONE1;
          end
          else
          begin
            Blend := DXR_BLEND_ONE2_SUB_SRCALPHA1;
          end;

          dxrDrawWaveXBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, amp, Len, ph, Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawWaveYSub(X, Y, Width, Height: Integer;
  const SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean; amp,
  Len, ph, Alpha: Integer);
begin
  if Alpha <= 0 then
    Exit;

  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderWaveYDDS(Source, X, Y, Width, Height, rtSub, Transparent, amp, Len, ph, Alpha);
    Exit;
  end;
end;

procedure TDirectDrawSurface.DrawWaveY(X, Y, Width, Height: Integer;
  const SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean; amp,
  Len, ph: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderWaveYDDS(Source, X, Y, Width, Height, rtDraw, Transparent, amp, Len, ph{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
    Exit;
  end;
end;

procedure TDirectDrawSurface.DrawWaveYAdd(X, Y, Width, Height: Integer;
  const SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean; amp,
  Len, ph, Alpha: Integer);
begin
  if Alpha <= 0 then
    Exit;

  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderWaveYDDS(Source, X, Y, Width, Height, rtAdd, Transparent, amp, Len, ph, Alpha);
    Exit;
  end;
end;

procedure TDirectDrawSurface.DrawWaveYAlpha(X, Y, Width, Height: Integer;
  const SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean; amp,
  Len, ph, Alpha: Integer);
begin
  if Alpha <= 0 then
    Exit;

  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if (Width = 0) or (Height = 0) then
    Exit;
  if Source = nil then
    Exit;
  if (Source.Width = 0) or (Source.Height = 0) then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderWaveYDDS(Source, X, Y, Width, Height, rtBlend, Transparent, amp, Len, ph, Alpha);
    Exit;
  end;
end;

procedure TDirectDrawSurface.Fill(DevColor: Longint);
//var
  //DBltEx                    : TDDBltFX;
begin
  //DBltEx.dwSize := SizeOf(DBltEx);
  g_DBltEx.dwFillColor := DevColor;
  Blt(TRect(nil^), TRect(nil^), DDBLT_COLORFILL or DDBLT_WAIT, g_DBltEx, nil);
end;

procedure TDirectDrawSurface.FillRect(const Rect: TRect; DevColor: Longint);
var
  DBltEx: TDDBltFX;
  DestRect: TRect;
begin
  DBltEx.dwSize := SizeOf(DBltEx);
  DBltEx.dwFillColor := DevColor;
  DestRect := Rect;
  if ClipRect(DestRect, ClientRect) then
    Blt(DestRect, TRect(nil^), DDBLT_COLORFILL or DDBLT_WAIT, DBltEx, nil);
end;

procedure TDirectDrawSurface.FillRectAdd(const DestRect: TRect; Color: TColor; Alpha: Byte);
var
  DestSurface: TDXR_Surface;
begin
  if Color and $FFFFFF = 0 then
    Exit;
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if SurfaceDesc.ddpfPixelFormat.dwFlags and (DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8) <> 0 then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderFillRect(DestRect, ColorToRGB(Color), rtAdd, Alpha);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      dxrFillRectColorBlend(DestSurface, DestRect, DXR_BLEND_ONE1_ADD_ONE2, ColorToRGB(Color));
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.FillRectAlpha(const DestRect: TRect; Color: TColor;
  Alpha: Integer);
var
  DestSurface: TDXR_Surface;
begin
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if SurfaceDesc.ddpfPixelFormat.dwFlags and (DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8) <> 0 then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderFillRect(DestRect, ColorToRGB(Color), rtBlend, Alpha);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      dxrFillRectColorBlend(DestSurface, DestRect, DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2, ColorToRGB(Color) or (Byte(Alpha) shl 24));
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.FillRectSub(const DestRect: TRect; Color: TColor; Alpha: Byte);
var
  DestSurface: TDXR_Surface;
begin
  if Color and $FFFFFF = 0 then
    Exit;
  if (Self.Width = 0) or (Self.Height = 0) then
    Exit;
  if SurfaceDesc.ddpfPixelFormat.dwFlags and (DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8) <> 0 then
    Exit;

  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
  begin
    D2D.D2DRenderFillRect(DestRect, ColorToRGB(Color), rtSub, Alpha);
    Exit;
  end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      dxrFillRectColorBlend(DestSurface, DestRect, DXR_BLEND_ONE2_SUB_ONE1, ColorToRGB(Color));
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

function TDirectDrawSurface.GetBitCount: Integer;
begin
  Result := SurfaceDesc.ddpfPixelFormat.dwRGBBitCount;
end;

function TDirectDrawSurface.GetCanvas: TDirectDrawSurfaceCanvas;
begin
  if FCanvas = nil then
    FCanvas := TDirectDrawSurfaceCanvas.Create(Self);
  Result := FCanvas;
end;

function TDirectDrawSurface.GetClientRect: TRect;
begin
  Result := Rect(0, 0, Width, Height);
end;

function TDirectDrawSurface.GetHeight: Integer;
begin
  Result := SurfaceDesc.dwHeight
end;

type
  PRGB = ^TRGB;
  TRGB = packed record
    R, G, B: Byte;
  end;

function TDirectDrawSurface.GetPixel(X, Y: Integer): Longint;
var
  ddsd: TDDSurfaceDesc;
begin
  Result := 0;
  if (IDDSurface <> nil) and (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
    if Lock(PRect(nil)^, ddsd) then
    begin
      try
        case ddsd.ddpfPixelFormat.dwRGBBitCount of
          1: Result := Integer(PByte(Integer(ddsd.lpSurface) +
              Y * ddsd.lPitch + (X shr 3))^ and (1 shl (X and 7)) <> 0);
          4:
            begin
              if X and 1 = 0 then
                Result := PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + (X shr 1))^ shr 4
              else
                Result := PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + (X shr 1))^ and $0F;
            end;
          8: Result := PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X)^;
          16: Result := PWord(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 2)^;
          24: with PRGB(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 3)^ do
              Result := R or (G shl 8) or (B shl 16);
          32: Result := PInteger(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 4)^;
        end;
      finally
        UnLock;
      end;
    end;
end;

function TDirectDrawSurface.GetWidth: Integer;
begin
  Result := SurfaceDesc.dwWidth;
end;

procedure TDirectDrawSurface.LoadFromDIB(DIB: TDIB);
begin
  LoadFromGraphic(DIB);
end;

procedure TDirectDrawSurface.LoadFromDIBRect(DIB: TDIB; AWidth, AHeight: Integer; const SrcRect: TRect);
begin
  LoadFromGraphicRect(DIB, AWidth, AHeight, SrcRect);
end;

procedure TDirectDrawSurface.LoadFromGraphic(Graphic: TGraphic);
begin
  LoadFromGraphicRect(Graphic, 0, 0, Bounds(0, 0, Graphic.Width, Graphic.Height));
end;

procedure TDirectDrawSurface.LoadFromGraphicRect(Graphic: TGraphic; AWidth, AHeight: Integer; const SrcRect: TRect);
var
  Temp: TDIB;
begin
  if AWidth = 0 then
    AWidth := SrcRect.Right - SrcRect.Left;
  if AHeight = 0 then
    AHeight := SrcRect.Bottom - SrcRect.Top;

  SetSize(AWidth, AHeight);

  with SrcRect do
    if Graphic is TDIB then
    begin
      with Canvas do
      try
        StretchBlt(Handle, 0, 0, AWidth, AHeight, TDIB(Graphic).Canvas.Handle,
          Left, Top, Right - Left, Bottom - Top, SRCCOPY);
      finally
        Release;
      end;
    end
    else if (Right - Left = AWidth) and (Bottom - Top = AHeight) then
    begin
      with Canvas do
      try
        Draw(-Left, -Top, Graphic);
      finally
        Release;
      end;
    end
    else
    begin
      Temp := TDIB.Create;
      try
        Temp.SetSize(Right - Left, Bottom - Top, 24);
        Temp.Canvas.Draw(-Left, -Top, Graphic);

        with Canvas do
        try
          StretchDraw(Bounds(0, 0, AWidth, AHeight), Temp);
        finally
          Release;
        end;
      finally
        Temp.Free;
      end;
    end;
end;

procedure TDirectDrawSurface.LoadFromFile(const FileName: string);
var
  Picture: TPicture;
begin
  Picture := TPicture.Create;
  try
    Picture.LoadFromFile(FileName);
    LoadFromGraphic(Picture.Graphic);
  finally
    Picture.Free;
  end;
end;

procedure TDirectDrawSurface.LoadFromStream(Stream: TStream);
var
  DIB: TDIB;
begin
  DIB := TDIB.Create;
  try
    DIB.LoadFromStream(Stream);
    if DIB.Size > 0 then
      LoadFromGraphic(DIB);
  finally
    DIB.Free;
  end;
end;

function TDirectDrawSurface.Lock(const Rect: TRect; var SurfaceDesc: TDDSurfaceDesc): Boolean;
begin
  Result := False;
  if IDDSurface = nil then
    Exit;
  if FIsLocked then
    Exit; //blue
  //if FLockCount > 0 then Exit;
  //FIsLocked := False;
  SurfaceDesc.dwSize := SizeOf(SurfaceDesc);
  FLockSurfaceDesc.dwSize := SizeOf(FLockSurfaceDesc);
  if (@Rect <> nil) and ((Rect.Left <> 0) or (Rect.Top <> 0) or (Rect.Right <> Width) or (Rect.Bottom <> Height)) then
    DXResult := ISurface.Lock(@Rect, FLockSurfaceDesc, DDLOCK_WAIT, 0)
  else
    DXResult := ISurface.Lock(nil, FLockSurfaceDesc, DDLOCK_WAIT, 0);
  if DXResult <> DD_OK then
    Exit;

  //Inc(FLockCount);
  SurfaceDesc := FLockSurfaceDesc;
  FIsLocked := True;
  Result := True;
end;

{$IFDEF DelphiX_Spt4}

function TDirectDrawSurface.Lock(var SurfaceDesc: TDDSurfaceDesc): Boolean;
begin
  Result := False;
  //FIsLocked := False;                   //
  if IDDSurface = nil then
    Exit;
  if FIsLocked then
    Exit;
  //if FLockCount <= 0 then begin
  SurfaceDesc.dwSize := SizeOf(SurfaceDesc); //blue
  FLockSurfaceDesc.dwSize := SizeOf(FLockSurfaceDesc);
  DXResult := ISurface.Lock(nil, FLockSurfaceDesc, DDLOCK_WAIT, 0);
  if DXResult <> DD_OK then
    Exit;
  //end;

  //Inc(FLockCount);
  SurfaceDesc := FLockSurfaceDesc;
  FIsLocked := True;
  Result := True;
end;

function TDirectDrawSurface.Lock: Boolean;
var
  SurfaceDesc: TDDSurfaceDesc;
begin
  Result := Lock(SurfaceDesc);
end;

{$ELSE}

function TDirectDrawSurface.LockSurface: Boolean;
var
  SurfaceDesc: TDDSurfaceDesc;
  R: TRect;
begin
  Result := Lock(R, SurfaceDesc);
end;
{$ENDIF}

procedure TDirectDrawSurface.UnLock;
begin
  if IDDSurface = nil then
    Exit; //
  if not FIsLocked then
    Exit;

  //if FLockCount > 0 then begin
  //Dec(FLockCount);
  //if FLockCount = 0 then begin
  DXResult := ISurface.UnLock(FLockSurfaceDesc.lpSurface);
  FIsLocked := False;
  //end;
  //end;
end;

function TDirectDrawSurface.Restore: Boolean;
begin
  if IDDSurface <> nil then
  begin
    DXResult := ISurface._Restore;
    Result := DXResult = DD_OK;
  end
  else
    Result := False;
end;

procedure TDirectDrawSurface.SetClipper(Value: TDirectDrawClipper);
begin
  if IDDSurface <> nil then
    DXResult := ISurface.SetClipper(Value.IDDClipper);
  FHasClipper := (Value <> nil) and (DXResult = DD_OK);
end;

procedure TDirectDrawSurface.SetColorKey(Flags: DWORD; const Value: TDDColorKey);
begin
  if IDDSurface <> nil then
    DXResult := ISurface.SetColorKey(Flags, @Value);
end;

procedure TDirectDrawSurface.SetPalette(Value: TDirectDrawPalette);
begin
  if IDDSurface <> nil then
    DXResult := ISurface.SetPalette(Value.IDDPalette);
end;

procedure TDirectDrawSurface.SetPixel(X, Y: Integer; Value: Longint);
var
  ddsd: TDDSurfaceDesc;
  P: PByte;
begin
  if (IDDSurface <> nil) and (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
    if Lock(PRect(nil)^, ddsd) then
    begin
      try
        case ddsd.ddpfPixelFormat.dwRGBBitCount of
          1:
            begin
              P := PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + (X shr 3));
              if Value = 0 then
                P^ := P^ and (not (1 shl (7 - (X and 7))))
              else
                P^ := P^ or (1 shl (7 - (X and 7)));
            end;
          4:
            begin
              P := PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + (X shr 1));
              if X and 1 = 0 then
                P^ := (P^ and $0F) or (Value shl 4)
              else
                P^ := (P^ and $F0) or (Value and $0F);
            end;
          8: PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X)^ := Value;
          16: PWord(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 2)^ := Value;
          24: with PRGB(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 3)^ do
            begin
              R := Byte(Value);
              G := Byte(Value shr 8);
              B := Byte(Value shr 16);
            end;
          32: PInteger(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 4)^ := Value;
        end;
      finally
        UnLock;
      end;
    end;
end;

function TDirectDrawSurface.SetSize(AWidth, AHeight: Integer): Boolean;
var
  ddsd: TDDSurfaceDesc;
begin
  if (AWidth <= 0) or (AHeight <= 0) then
  begin
    Result := False;
    IDDSurface := nil;
    Exit;
  end;

  with ddsd do
  begin
    dwHeight := AHeight;
    dwWidth := AWidth;
    if not FSystemMemory then
      FSystemMemory := True;
    dwSize := SizeOf(ddsd);
    dwFlags := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT;
    ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN or DDSCAPS_SYSTEMMEMORY;
    Result := FDDraw.IDraw.CreateSurface(ddsd, FIDDSurface, nil) = DD_OK;
    if Result then
    begin
      Move(ddsd, FSurfaceDesc, SizeOf(TDDSurfaceDesc));
      TransparentColor := 0;
    end
    else
      IDDSurface := nil;
  end;
end;

(*function TDirectDrawSurface.SetSize(AWidth, AHeight: Integer): Boolean;
var
  ddsd                      : TDDSurfaceDesc;
begin
  if (AWidth <= 0) or (AHeight <= 0) then begin
    IDDSurface := nil;
    Exit;
  end;

  with ddsd do begin
    FillChar(ddsd, SizeOf(ddsd), 0);
    dwSize := SizeOf(ddsd);
    dwFlags := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT;
    ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN;
    if FSystemMemory then
      ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY;
    dwHeight := AHeight;
    dwWidth := AWidth;
  end;

  if CreateSurface(ddsd) then Exit;

  {  When the Surface cannot be made,  making is attempted to the system memory.  }
  if ddsd.ddsCaps.dwCaps and DDSCAPS_SYSTEMMEMORY = 0 then begin
    ddsd.ddsCaps.dwCaps := (ddsd.ddsCaps.dwCaps and (not DDSCAPS_VIDEOMEMORY)) or DDSCAPS_SYSTEMMEMORY;
    if CreateSurface(ddsd) then begin
      FSystemMemory := True;
      Exit;
    end;
  end;

  raise EDirectDrawSurfaceError.CreateFmt(SCannotMade, [SDirectDrawSurface]);
end;

function TDirectDrawSurface.SetSize(AWidth, AHeight: Integer): Boolean;
var
  g_ddsd                    : TDDSurfaceDesc;
begin
  if (AWidth <= 0) or (AHeight <= 0) then begin
    Result := False;
    IDDSurface := nil;                  //1010
    Exit;
  end;

  with g_ddsd do begin
    //{
    g_ddsd.dwSize := SizeOf(g_ddsd);
    g_ddsd.dwFlags := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT;
    g_ddsd.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN or DDSCAPS_SYSTEMMEMORY;
    //}

    dwHeight := AHeight;
    dwWidth := AWidth;
    FSystemMemory := True;
    Result := FDDraw.IDraw.CreateSurface(g_ddsd, FIDDSurface, nil) = DD_OK;
    if Result then begin
      FSurfaceDesc.dwSize := SizeOf(FSurfaceDesc);
      FSurfaceDesc := g_ddsd;
      TransparentColor := 0;
    end else
      IDDSurface := nil;
  end;
end;*)

procedure TDirectDrawSurface.SetTransparentColor(Col: Longint);
var
  ddck: TDDColorKey;
begin
  ddck.dwColorSpaceLowValue := Col;
  ddck.dwColorSpaceHighValue := Col;
  ColorKey[DDCKEY_SRCBLT] := ddck;
end;

{additional pixel routines like turbopixels}

procedure TDirectDrawSurface.PutPixel8(X, Y, Color: Integer); assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   color = ? }
asm
  push esi                              // must maintain esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface// set to surface
  add esi,edx                           // add x
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.dwwidth]  // eax = pitch
  mul ecx                               // eax = pitch * y
  add esi,eax                           // esi = pixel offset
  mov ecx, color
  mov ds:[esi],cl                       // set pixel (lo byte of ecx)
  pop esi                               // restore esi
  //ret                                   // return
end;

procedure TDirectDrawSurface.PutPixel16(X, Y, Color: Integer); assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   color = ? }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  shl edx,1
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov ecx, color
  mov ds:[esi],cx
  pop esi
  //ret
end;

procedure TDirectDrawSurface.PutPixel24(X, Y, Color: Integer); assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   color = ? }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  imul edx,3
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov eax,ds:[esi]
  and eax,$FF000000
  mov ecx, color
  or  ecx,eax
  mov ds:[esi+1],ecx
  pop esi
  //ret
end;

procedure TDirectDrawSurface.PutPixel32(X, Y, Color: Integer); assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   color = ? }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  shl edx,2
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov ecx, color
  mov ds:[esi],ecx
  pop esi
  //ret
end;

procedure TDirectDrawSurface.Poke(X, Y: Integer; const Value: Longint);
begin
  if (X < 0) or (X > (Width - 1)) or
    (Y < 0) or (Y > (Height - 1)) or not FIsLocked then
    Exit;
  case BitCount of
    8: PutPixel8(X, Y, Value);
    16: PutPixel16(X, Y, Value);
    24: PutPixel24(X, Y, Value);
    32: PutPixel32(X, Y, Value);
  end;
end;

function TDirectDrawSurface.GetPixel8(X, Y: Integer): Integer; assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   result = eax }
asm
  push esi                              // myst maintain esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface        // set to surface
  add esi,edx                           // add x
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]         // eax = pitch
  mul ecx                               // eax = pitch * y
  add esi,eax                           // esi = pixel offset
  mov eax,ds:[esi]                      // eax = color
  and eax,$FF                           // map into 8bit
  pop esi                               // restore esi
  //ret                                   // return
end;

function TDirectDrawSurface.GetPixel16(X, Y: Integer): Integer; assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   result = eax }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  shl edx,1
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov eax,ds:[esi]
  and eax,$FFFF                         // map into 16bit
  pop esi
  //ret
end;

function TDirectDrawSurface.GetPixel24(X, Y: Integer): Integer; assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   result = eax }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  imul edx,3
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov eax,ds:[esi]
  and eax,$FFFFFF                       // map into 24bit
  pop esi
  //ret
end;

function TDirectDrawSurface.GetPixel32(X, Y: Integer): Integer; assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   result = eax }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  shl edx,2
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov eax,ds:[esi]
  pop esi
  //ret
end;

function TDirectDrawSurface.Peek(X, Y: Integer): Longint;
begin
  Result := 0;
  if (X < 0) or (X > (Width - 1)) or
    (Y < 0) or (Y > (Height - 1)) or not FIsLocked then
    Exit;
  case BitCount of
    8: Result := GetPixel8(X, Y);
    16: Result := GetPixel16(X, Y);
    24: Result := GetPixel24(X, Y);
    32: Result := GetPixel32(X, Y);
  end;
end;

procedure TDirectDrawSurface.PokeLine(X1, Y1, X2, Y2: Integer; Color: cardinal);
var
  i, deltax, deltay, numpixels,
    d, dinc1, dinc2,
    X, xinc1, xinc2,
    Y, yinc1, yinc2: Integer;
begin
  if not FIsLocked then
{$IFDEF DelphiX_Spt4}Lock{$ELSE}LockSurface{$ENDIF}; //force lock the surface
  { Calculate deltax and deltay for initialisation }
  deltax := Abs(X2 - X1);
  deltay := Abs(Y2 - Y1);

  { Initialise all vars based on which is the independent variable }
  if deltax >= deltay then
  begin
    { x is independent variable }
    numpixels := deltax + 1;
    d := (2 * deltay) - deltax;

    dinc1 := deltay shl 1;
    dinc2 := (deltay - deltax) shl 1;
    xinc1 := 1;
    xinc2 := 1;
    yinc1 := 0;
    yinc2 := 1;
  end
  else
  begin
    { y is independent variable }
    numpixels := deltay + 1;
    d := (2 * deltax) - deltay;
    dinc1 := deltax shl 1;
    dinc2 := (deltax - deltay) shl 1;
    xinc1 := 0;
    xinc2 := 1;
    yinc1 := 1;
    yinc2 := 1;
  end;
  { Make sure x and y move in the right directions }
  if X1 > X2 then
  begin
    xinc1 := -xinc1;
    xinc2 := -xinc2;
  end;
  if Y1 > Y2 then
  begin
    yinc1 := -yinc1;
    yinc2 := -yinc2;
  end;
  X := X1;
  Y := Y1;
  { Draw the pixels }
  for i := 1 to numpixels do
  begin
    if (X > 0) and (X < (Width - 1)) and (Y > 0) and (Y < (Height - 1)) then
      Pixel[X, Y] := Color;
    if d < 0 then
    begin
      Inc(d, dinc1);
      Inc(X, xinc1);
      Inc(Y, yinc1);
    end
    else
    begin
      Inc(d, dinc2);
      Inc(X, xinc2);
      Inc(Y, yinc2);
    end;
  end;
end;

procedure TDirectDrawSurface.PokeLinePolar(X, Y: Integer; Angle, Length: extended; Color: cardinal);
var
  xp, yp: Integer;
begin
  xp := Round(Sin(Angle * Pi / 180) * Length) + X;
  yp := Round(Cos(Angle * Pi / 180) * Length) + Y;
  PokeLine(X, Y, xp, yp, Color);
end;

procedure TDirectDrawSurface.PokeBox(xs, ys, xd, yd: Integer; Color: cardinal);
begin
  PokeLine(xs, ys, xd, ys, Color);
  PokeLine(xs, ys, xs, yd, Color);
  PokeLine(xd, ys, xd, yd, Color);
  PokeLine(xs, yd, xd, yd, Color);
end;

procedure TDirectDrawSurface.PokeBlendPixel(const X, Y: Integer; aColor: cardinal; Alpha: Byte);
var
  cr, cg, cb: Byte;
  ar, ag, ab: Byte;
begin
  LoadRGB(aColor, ar, ag, ab);
  LoadRGB(Pixel[X, Y], cr, cg, cb);
  Pixel[X, Y] := SaveRGB((Alpha * (ar - cr) shr 8) + cr, // R alpha
    (Alpha * (ag - cg) shr 8) + cg, // G alpha
    (Alpha * (ab - cb) shr 8) + cb); // B alpha
end;

function Conv24to16(Color: Integer): word; register;
asm
  mov ecx,eax
  shl eax,24
  shr eax,27
  shl eax,11
  mov edx,ecx
  shl edx,16
  shr edx,26
  shl edx,5
  or eax,edx
  mov edx,ecx
  shl edx,8
  shr edx,27
  or eax,edx
end;

procedure TDirectDrawSurface.PokeWuLine(X1, Y1, X2, Y2, aColor: Integer);
var
  deltax, deltay, Loop, Start, Finish: Integer;
  Dx, Dy, DyDx: single; // fractional parts
  Color16: DWORD;
begin
  deltax := Abs(X2 - X1); // Calculate DeltaX and DeltaY for initialization
  deltay := Abs(Y2 - Y1);
  if (deltax = 0) or (deltay = 0) then
  begin // straight lines
    PokeLine(X1, Y1, X2, Y2, aColor);
    Exit;
  end;
  if BitCount = 16 then
    Color16 := Conv24to16(aColor)
  else
    Color16 := aColor;
  if deltax > deltay then {// horizontal or vertical}
  begin
    { determine rise and run }
    if Y2 > Y1 then
      DyDx := -(deltay / deltax)
    else
      DyDx := deltay / deltax;
    if X2 < X1 then
    begin
      Start := X2; // right to left
      Finish := X1;
      Dy := Y2;
    end
    else
    begin
      Start := X1; // left to right
      Finish := X2;
      Dy := Y1;
      DyDx := -DyDx; // inverse slope
    end;
    for Loop := Start to Finish do
    begin
      PokeBlendPixel(Loop, Trunc(Dy), Color16, Trunc((1 - Frac(Dy)) * 255));
      PokeBlendPixel(Loop, Trunc(Dy) + 1, Color16, Trunc(Frac(Dy) * 255));
      Dy := Dy + DyDx; // next point
    end;
  end
  else
  begin
    { determine rise and run }
    if X2 > X1 then
      DyDx := -(deltax / deltay)
    else
      DyDx := deltax / deltay;
    if Y2 < Y1 then
    begin
      Start := Y2; // right to left
      Finish := Y1;
      Dx := X2;
    end
    else
    begin
      Start := Y1; // left to right
      Finish := Y2;
      Dx := X1;
      DyDx := -DyDx; // inverse slope
    end;
    for Loop := Start to Finish do
    begin
      PokeBlendPixel(Trunc(Dx), Loop, Color16, Trunc((1 - Frac(Dx)) * 255));
      PokeBlendPixel(Trunc(Dx), Loop, Color16, Trunc(Frac(Dx) * 255));
      Dx := Dx + DyDx; // next point
    end;
  end;
end;

procedure TDirectDrawSurface.Noise(Oblast: TRect; Density: Byte);
var
  Dx, Dy: Integer;
  Dens: Byte;
begin
  {noise}
  case Density of
    0..2: Dens := 3;
    255: Dens := 254;
  else
    Dens := Density;
  end;
  if Dens >= Oblast.Right then
    Dens := Oblast.Right div 3;
  Dy := Oblast.Top;
  while Dy <= Oblast.Bottom do
  begin
    Dx := Oblast.Left;
    while Dx <= Oblast.Right do
    begin
      Inc(Dx, Random(Dens));
      if Dx <= Oblast.Right then
        Pixel[Dx, Dy] := not Pixel[Dx, Dy];
    end;
    Inc(Dy);
  end;
end;

function Conv16to24(Color: word): Integer; register;
asm
 xor edx,edx
 mov dx,ax

 mov eax,edx
 shl eax,27
 shr eax,8

 mov ecx,edx
 shr ecx,5
 shl ecx,26
 shr ecx,16
 or eax,ecx

 mov ecx,edx
 shr ecx,11
 shl ecx,27
 shr ecx,24
 or eax,ecx
end;

procedure GetRGB(Color: cardinal; var R, G, B: Byte);
{$IFDEF VER9UP}inline;
{$ENDIF}
begin
  R := Color;
  G := Color shr 8;
  B := Color shr 16;
end;

procedure TDirectDrawSurface.LoadRGB(Color: cardinal; var R, G, B: Byte);
var
  grB: Byte;
begin
  grB := 1;
  if FLockSurfaceDesc.ddpfPixelFormat.dwGBitMask = 2016 then
    grB := 0; // 565
  case BitCount of
    15, 16:
      begin
        R := (Color shr (11 - grB)) shl 3;
        if grB = 0 then
          G := ((Color and 2016) shr 5) shl 2
        else
          G := ((Color and 992) shr 5) shl 3;
        B := (Color and 31) shl 3;
      end;
  else
    GetRGB(Color, R, G, B);
  end;
end;

function TDirectDrawSurface.SaveRGB(const R, G, B: Byte): cardinal;
begin
  case BitCount of
    15, 16:
      begin
        Result := Conv24to16(RGB(R, G, B));
      end;
  else
    Result := RGB(R, G, B);
  end;
end;

procedure TDirectDrawSurface.Blur;
var
  X, Y, tr, tg, tb: Integer;
  R, G, B: Byte;
begin
  for Y := 1 to GetHeight - 1 do
    for X := 1 to GetWidth - 1 do
    begin
      LoadRGB(Peek(X, Y), R, G, B);
      tr := R;
      tg := G;
      tb := B;
      LoadRGB(Peek(X, Y + 1), R, G, B);
      Inc(tr, R);
      Inc(tg, G);
      Inc(tb, B);
      LoadRGB(Peek(X, Y - 1), R, G, B);
      Inc(tr, R);
      Inc(tg, G);
      Inc(tb, B);
      LoadRGB(Peek(X - 1, Y), R, G, B);
      Inc(tr, R);
      Inc(tg, G);
      Inc(tb, B);
      LoadRGB(Peek(X + 1, Y), R, G, B);
      Inc(tr, R);
      Inc(tg, G);
      Inc(tb, B);
      tr := tr shr 2;
      tg := tg shr 2;
      tb := tb shr 2;
      Poke(X, Y, SaveRGB(tr, tg, tb));
    end;
end;

procedure TDirectDrawSurface.PokeCircle(X, Y, Radius, Color: Integer);
var
  A, af, B, bf, c,
    target, r2: Integer;
begin
  target := 0;
  A := Radius;
  B := 0;
  r2 := Sqr(Radius);

  while A >= B do
  begin
    B := Round(Sqrt(r2 - Sqr(A)));
    c := target;
    target := B;
    B := c;
    while B < target do
    begin
      af := (120 * A) div 100;
      bf := (120 * B) div 100;
      Pixel[X + af, Y + B] := Color;
      Pixel[X + bf, Y + A] := Color;
      Pixel[X - af, Y + B] := Color;
      Pixel[X - bf, Y + A] := Color;
      Pixel[X - af, Y - B] := Color;
      Pixel[X - bf, Y - A] := Color;
      Pixel[X + af, Y - B] := Color;
      Pixel[X + bf, Y - A] := Color;
      B := B + 1;
    end;
    A := A - 1;
  end;
end;

function RGBToBGR(Color: cardinal): cardinal;
begin
  Result := (LoByte(LoWord(Color)) shr 3 shl 11) or // Red
    (HiByte((Color)) shr 2 shl 5) or // Green
    (LoByte(HiWord(Color)) shr 3); // Blue
end;

procedure TDirectDrawSurface.PokeVLine(X, Y1, Y2: Integer; Color: cardinal);
var
  Y: Integer;
  NColor: cardinal;
  R, G, B: Byte;
begin
  if Y1 < 0 then
    Y1 := 0;
  if Y2 >= Height then
    Y2 := Height - 1;
  GetRGB(Color, R, G, B);
  NColor := RGBToBGR(RGB(R, G, B));
  for Y := Y1 to Y2 do
  begin
    Pixel[X, Y] := NColor;
  end;
end;

procedure TDirectDrawSurface.PokeFilledEllipse(exc, eyc, ea, eb, Color: Integer);
var
  X, Y: Integer;
  aa, aa2, bb, bb2, d, Dx, Dy: Longint;
begin
  X := 0;
  Y := eb;
  aa := Longint(ea) * ea;
  aa2 := 2 * aa;
  bb := Longint(eb) * eb;
  bb2 := 2 * bb;
  d := bb - aa * eb + aa div 4;
  Dx := 0;
  Dy := aa2 * eb;
  PokeVLine(exc, eyc - Y, eyc + Y, Color);
  while (Dx < Dy) do
  begin
    if (d > 0) then
    begin
      Dec(Y);
      Dec(Dy, aa2);
      Dec(d, Dy);
    end;
    Inc(X);
    Inc(Dx, bb2);
    Inc(d, bb + Dx);
    PokeVLine(exc - X, eyc - Y, eyc + Y, Color);
    PokeVLine(exc + X, eyc - Y, eyc + Y, Color);
  end;
  Inc(d, (3 * (aa - bb) div 2 - (Dx + Dy)) div 2);
  while (Y >= 0) do
  begin
    if (d < 0) then
    begin
      Inc(X);
      Inc(Dx, bb2);
      Inc(d, bb + Dx);
      PokeVLine(exc - X, eyc - Y, eyc + Y, Color);
      PokeVLine(exc + X, eyc - Y, eyc + Y, Color);
    end;
    Dec(Y);
    Dec(Dy, aa2);
    Inc(d, aa - Dy);
  end;
end;

procedure TDirectDrawSurface.DoRotate(cent1, cent2, Angle: Integer; coord1, coord2: Real; Color: word);
var
  coord1t, coord2t: Real;
  C1, C2: Integer;
begin
  coord1t := coord1 - cent1;
  coord2t := coord2 - cent2;
  coord1 := coord1t * Cos(Angle * Pi / 180) - coord2t * Sin(Angle * Pi / 180);
  coord2 := coord1t * Sin(Angle * Pi / 180) + coord2t * Cos(Angle * Pi / 180);
  coord1 := coord1 + cent1;
  coord2 := coord2 + cent2;
  C1 := Round(coord1);
  C2 := Round(coord2);
  Pixel[C1, C2] := Color;
end;

procedure TDirectDrawSurface.PokeEllipse(exc, eyc, ea, eb, Angle, Color: Integer);
var
  elx, ely: Integer;
  aa, aa2, bb, bb2, d, Dx, Dy: Longint;
  X, Y: Real;
begin
  elx := 0;
  ely := eb;
  aa := Longint(ea) * ea;
  aa2 := 2 * aa;
  bb := Longint(eb) * eb;
  bb2 := 2 * bb;
  d := bb - aa * eb + aa div 4;
  Dx := 0;
  Dy := aa2 * eb;
  X := exc;
  Y := eyc - ely;
  DoRotate(exc, eyc, Angle, X, Y, Color);
  X := exc;
  Y := eyc + ely;
  DoRotate(exc, eyc, Angle, X, Y, Color);
  X := exc - ea;
  Y := eyc;
  DoRotate(exc, eyc, Angle, X, Y, Color);
  X := exc + ea;
  Y := eyc;
  DoRotate(exc, eyc, Angle, X, Y, Color);
  while (Dx < Dy) do
  begin
    if (d > 0) then
    begin
      Dec(ely);
      Dec(Dy, aa2);
      Dec(d, Dy);
    end;
    Inc(elx);
    Inc(Dx, bb2);
    Inc(d, bb + Dx);
    X := exc + elx;
    Y := eyc + ely;
    DoRotate(exc, eyc, Angle, X, Y, Color);
    X := exc - elx;
    Y := eyc + ely;
    DoRotate(exc, eyc, Angle, X, Y, Color);
    X := exc + elx;
    Y := eyc - ely;
    DoRotate(exc, eyc, Angle, X, Y, Color);
    X := exc - elx;
    Y := eyc - ely;
    DoRotate(exc, eyc, Angle, X, Y, Color);
  end;
  Inc(d, (3 * (aa - bb) div 2 - (Dx + Dy)) div 2);
  while (ely > 0) do
  begin
    if (d < 0) then
    begin
      Inc(elx);
      Inc(Dx, bb2);
      Inc(d, bb + Dx);
    end;
    Dec(ely);
    Dec(Dy, aa2);
    Inc(d, aa - Dy);
    X := exc + elx;
    Y := eyc + ely;
    DoRotate(exc, eyc, Angle, X, Y, Color);
    X := exc - elx;
    Y := eyc + ely;
    DoRotate(exc, eyc, Angle, X, Y, Color);
    X := exc + elx;
    Y := eyc - ely;
    DoRotate(exc, eyc, Angle, X, Y, Color);
    X := exc - elx;
    Y := eyc - ely;
    DoRotate(exc, eyc, Angle, X, Y, Color);
  end;
end;

procedure TDirectDrawSurface.MirrorFlip(Value: TRenderMirrorFlipSet);
begin
  if Assigned(D2D) and D2D.CanUseD2D and (D2D.FDDraw.Surface = Self) then
    D2D.MirrorFlip := Value;
end;

{  TDXDrawDisplayMode  }

function TDXDrawDisplayMode.GetBitCount: Integer;
begin
  Result := FSurfaceDesc.ddpfPixelFormat.dwRGBBitCount;
end;

function TDXDrawDisplayMode.GetHeight: Integer;
begin
  Result := FSurfaceDesc.dwHeight;
end;

function TDXDrawDisplayMode.GetWidth: Integer;
begin
  Result := FSurfaceDesc.dwWidth;
end;

{  TDXDrawDisplay  }

constructor TDXDrawDisplay.Create(ADXDraw: TCustomDXDraw);
begin
  inherited Create;
  FDXDraw := ADXDraw;
  FModes := TCollection.Create(TDXDrawDisplayMode);
  FWidth := 640;
  FHeight := 480;
  FBitCount := 16;
  FFixedBitCount := True; //True;
  FFixedRatio := True;
  FFixedSize := False; //False;
end;

destructor TDXDrawDisplay.Destroy;
begin
  FModes.Free;
  inherited Destroy;
end;

procedure TDXDrawDisplay.Assign(Source: TPersistent);
begin
  if Source is TDXDrawDisplay then
  begin
    if Source <> Self then
    begin
      FBitCount := TDXDrawDisplay(Source).BitCount;
      FHeight := TDXDrawDisplay(Source).Height;
      FWidth := TDXDrawDisplay(Source).Width;

      FFixedBitCount := TDXDrawDisplay(Source).FFixedBitCount;
      FFixedRatio := TDXDrawDisplay(Source).FFixedRatio;
      FFixedSize := TDXDrawDisplay(Source).FFixedSize;
    end;
  end
  else
    inherited Assign(Source);
end;

function TDXDrawDisplay.GetCount: Integer;
begin
  if FModes.Count = 0 then
    LoadDisplayModes;
  Result := FModes.Count;
end;

function TDXDrawDisplay.GetMode: TDXDrawDisplayMode;
var
  i: Integer;
  ddsd: TDDSurfaceDesc;
begin
  Result := nil;
  if FDXDraw.DDraw <> nil then
  begin
    ddsd := FDXDraw.DDraw.DisplayMode;
    with ddsd do
      i := IndexOf(dwWidth, dwHeight, ddpfPixelFormat.dwRGBBitCount);
    if i <> -1 then
      Result := Modes[i];
  end;
  if Result = nil then
    raise EDirectDrawError.Create(SDisplayModeCannotAcquired);
end;

function TDXDrawDisplay.GetMode2(Index: Integer): TDXDrawDisplayMode;
begin
  if FModes.Count = 0 then
    LoadDisplayModes;
  Result := TDXDrawDisplayMode(FModes.Items[Index]);
end;

function TDXDrawDisplay.IndexOf(Width, Height, BitCount: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if (Modes[i].Width = Width) and (Modes[i].Height = Height) and (Modes[i].BitCount = BitCount) then
    begin
      Result := i;
      Exit;
    end;
end;

procedure TDXDrawDisplay.LoadDisplayModes;

  function EnumDisplayModesProc(const lpTDDSurfaceDesc: TDDSurfaceDesc;
    lpContext: Pointer): HRESULT; stdcall;
  begin
    with TDXDrawDisplayMode.Create(TCollection(lpContext)) do
      FSurfaceDesc := lpTDDSurfaceDesc;
    Result := DDENUMRET_OK;
  end;

  function Compare(Item1, Item2: TDXDrawDisplayMode): Integer;
  begin
    if Item1.Width <> Item2.Width then
      Result := Item1.Width - Item2.Width
    else if Item1.Height <> Item2.Height then
      Result := Item1.Height - Item2.Height
    else
      Result := Item1.BitCount - Item2.BitCount;
  end;

var
  DDraw: TDirectDraw;
  TempList: TList;
  i: Integer;
begin
  FModes.Clear;

  if FDXDraw.DDraw <> nil then
  begin
    FDXDraw.DDraw.DXResult := FDXDraw.DDraw.IDraw.EnumDisplayModes(0, PDDSurfaceDesc(nil),
      FModes, @EnumDisplayModesProc);
  end
  else
  begin
    DDraw := TDirectDraw.Create(PGUID(FDXDraw.FDriver));
    try
      DDraw.IDraw.EnumDisplayModes(0, PDDSurfaceDesc(nil), FModes, @EnumDisplayModesProc);
    finally
      DDraw.Free;
    end;
  end;

  TempList := TList.Create;
  try
    for i := 0 to FModes.Count - 1 do
      TempList.Add(FModes.Items[i]);
    TempList.Sort(@Compare);

    for i := FModes.Count - 1 downto 0 do
      TDXDrawDisplayMode(TempList[i]).Index := i;
  finally
    TempList.Free;
  end;
end;

function TDXDrawDisplay.SetSize(AWidth, AHeight, ABitCount: Integer): Boolean;
begin
  Result := False;
  if FDXDraw.DDraw <> nil then
  begin
    FDXDraw.DDraw.DXResult := FDXDraw.DDraw.IDraw.SetDisplayMode(AWidth, AHeight, ABitCount);
    Result := FDXDraw.DDraw.DXResult = DD_OK;

    if Result then
    begin
      FWidth := AWidth;
      FHeight := AHeight;
      FBitCount := ABitCount;
    end;
  end;
end;

function TDXDrawDisplay.DynSetSize(AWidth, AHeight, ABitCount: Integer): Boolean;

  function TestBitCount(BitCount, ABitCount: Integer): Boolean;
  begin
    if (BitCount > 8) and (ABitCount > 8) then
    begin
      Result := True;
    end
    else
    begin
      Result := BitCount >= ABitCount;
    end;
  end;

  function SetSize2(Ratio: Boolean): Boolean;
  var
    DWidth, DHeight, DBitCount, i: Integer;
    Flag: Boolean;
  begin
    Result := False;

    DWidth := MaxInt;
    DHeight := MaxInt;
    DBitCount := ABitCount;

    Flag := False;
    for i := 0 to Count - 1 do
      with Modes[i] do
      begin
        if ((DWidth >= Width) and (DHeight >= Width) and
          ((not Ratio) or (Width / Height = AWidth / AHeight)) and
          ((FFixedSize and (Width = AWidth) and (Height = Height)) or
          ((not FFixedSize) and (Width >= AWidth) and (Height >= AHeight))) and

          ((FFixedBitCount and (BitCount = ABitCount)) or
          ((not FFixedBitCount) and TestBitCount(BitCount, ABitCount)))) then
        begin
          DWidth := Width;
          DHeight := Height;
          DBitCount := BitCount;
          Flag := True;
        end;
      end;

    if Flag then
    begin
      if (DBitCount <> ABitCount) then
      begin
        if IndexOf(DWidth, DHeight, ABitCount) <> -1 then
          DBitCount := ABitCount;
      end;

      Result := SetSize(DWidth, DHeight, DBitCount);
    end;
  end;

begin
  Result := False;

  if (AWidth <= 0) or (AHeight <= 0) or (not (ABitCount in [8, 16, 24, 32])) then
    Exit;

  {  The change is attempted by the size of default.  }
  if SetSize(AWidth, AHeight, ABitCount) then
  begin
    Result := True;
    Exit;
  end;

  {  The change is attempted by the screen ratio fixation.  }
  if FFixedRatio then
    if SetSize2(True) then
    begin
      Result := True;
      Exit;
    end;

  {  The change is unconditionally attempted.  }
  if SetSize2(False) then
  begin
    Result := True;
    Exit;
  end;
end;

procedure TDXDrawDisplay.SetBitCount(Value: Integer);
begin
  if not (Value in [8, 16, 24, 32]) then
    raise EDirectDrawError.Create(SInvalidDisplayBitCount);
  FBitCount := Value;
end;

procedure TDXDrawDisplay.SetHeight(Value: Integer);
begin
  FHeight := Max(Value, 0);
end;

procedure TDXDrawDisplay.SetWidth(Value: Integer);
begin
  FWidth := Max(Value, 0);
end;

{  TCustomDXDraw  }

function BPPToDDBD(BPP: DWORD): DWORD;
begin
  case BPP of
    1: Result := DDBD_1;
    2: Result := DDBD_2;
    4: Result := DDBD_4;
    8: Result := DDBD_8;
    16: Result := DDBD_16;
    24: Result := DDBD_24;
    32: Result := DDBD_32;
  else
    Result := 0;
  end;
end;

procedure FreeZBufferSurface(Surface: TDirectDrawSurface; var ZBuffer: TDirectDrawSurface);
begin
  if ZBuffer <> nil then
  begin
    if (Surface.IDDSurface <> nil) and (ZBuffer.IDDSurface <> nil) then
      Surface.ISurface.DeleteAttachedSurface(0, ZBuffer.IDDSurface);
    ZBuffer.Free;
    ZBuffer := nil;
  end;
end;

type
  TInitializeDirect3DOption = (idoSelectDriver, idoOptimizeDisplayMode,
    idoHardware, idoRetainedMode, idoZBuffer);

  TInitializeDirect3DOptions = set of TInitializeDirect3DOption;

procedure Direct3DInitializing(Options: TInitializeDirect3DOptions;
  var BitCount: Integer; var Driver: PGUID; var DriverGUID: TGUID);
type
  PDirect3DInitializingRecord = ^TDirect3DInitializingRecord;
  TDirect3DInitializingRecord = record
    Options: TInitializeDirect3DOptions;
    Driver: ^PGUID;
    DriverGUID: PGUID;
    BitCount: Integer;

    Flag: Boolean;
    DriverCaps: TDDCaps;
    HELCaps: TDDCaps;
    HWDeviceDesc: TD3DDeviceDesc;
    HELDeviceDesc: TD3DDeviceDesc;
    DeviceDesc: TD3DDeviceDesc;

    D3DFlag: Boolean;
    HWDeviceDesc2: TD3DDeviceDesc;
    HELDeviceDesc2: TD3DDeviceDesc;
    DeviceDesc2: TD3DDeviceDesc;
  end;

  function EnumDeviceCallBack(const lpGuid: TGUID; lpDeviceDescription, lpDeviceName: PChar;
    const lpD3DHWDeviceDesc, lpD3DHELDeviceDesc: TD3DDeviceDesc;
    rec: PDirect3DInitializingRecord): HRESULT; stdcall;

    procedure UseThisDevice;
    begin
      rec.D3DFlag := True;
      rec.HWDeviceDesc2 := lpD3DHWDeviceDesc;
      rec.HELDeviceDesc2 := lpD3DHELDeviceDesc;
      rec.DeviceDesc2 := lpD3DHWDeviceDesc;
    end;

  begin
    Result := D3DENUMRET_OK;

    if lpD3DHWDeviceDesc.dcmColorModel = 0 then
      Exit;

    if idoOptimizeDisplayMode in rec.Options then
    begin
      if (lpD3DHWDeviceDesc.dwDeviceRenderBitDepth and (DDBD_16 or DDBD_24 or DDBD_32)) = 0 then
        Exit;
    end
    else
    begin
      if (lpD3DHWDeviceDesc.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount)) = 0 then
        Exit;
    end;

    UseThisDevice;
  end;

  function EnumDirectDrawDriverCallback(lpGuid: PGUID; lpDriverDescription: LPSTR;
    lpDriverName: LPSTR; rec: PDirect3DInitializingRecord): HRESULT; stdcall;
  var
    DDraw: TDirectDraw;
    Direct3D: IDirect3D;
    Direct3D7: IDirect3D7;

    function CountBitMask(i: DWORD; const Bits: array of DWORD): DWORD;
    var
      j: Integer;
    begin
      Result := 0;

      for j := Low(Bits) to High(Bits) do
      begin
        if i and Bits[j] <> 0 then
          Inc(Result);
      end;
    end;

    function CompareCountBitMask(i, i2: DWORD; const Bits: array of DWORD): Integer;
    var
      j, j2: DWORD;
    begin
      j := CountBitMask(i, Bits);
      j2 := CountBitMask(i2, Bits);

      if j < j2 then
        Result := -1
      else if i > j2 then
        Result := 1
      else
        Result := 0;
    end;

    function CountBit(i: DWORD): DWORD;
    var
      j: Integer;
    begin
      Result := 0;

      for j := 0 to 31 do
        if i and (1 shl j) <> 0 then
          Inc(Result);
    end;

    function CompareCountBit(i, i2: DWORD): Integer;
    begin
      Result := CountBit(i) - CountBit(i2);
      if Result < 0 then
        Result := -1;
      if Result > 0 then
        Result := 1;
    end;

    function FindDevice: Boolean;
    begin
      {  The Direct3D driver is examined.  }
      rec.D3DFlag := False;
      Direct3D.EnumDevices(@EnumDeviceCallBack, rec);
      Result := rec.D3DFlag;

      if not Result then
        Exit;

      {  Comparison of DirectDraw driver.  }
      if not rec.Flag then
      begin
        rec.HWDeviceDesc := rec.HWDeviceDesc2;
        rec.HELDeviceDesc := rec.HELDeviceDesc2;
        rec.DeviceDesc := rec.DeviceDesc2;
        rec.Flag := True;
      end
      else
      begin
        {  Comparison of hardware. (One with large number of functions to support is chosen.  }
        Result := False;

        if DDraw.DriverCaps.dwVidMemTotal < rec.DriverCaps.dwVidMemTotal then
          Exit;

        if CompareCountBitMask(DDraw.DriverCaps.ddsCaps.dwCaps, rec.DriverCaps.ddsCaps.dwCaps, [DDSCAPS_TEXTURE, DDSCAPS_ZBUFFER, DDSCAPS_MIPMAP]) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwMiscCaps, rec.HWDeviceDesc2.dpcLineCaps.dwMiscCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwRasterCaps, rec.HWDeviceDesc2.dpcLineCaps.dwRasterCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwAlphaCmpCaps, rec.HWDeviceDesc2.dpcLineCaps.dwAlphaCmpCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwSrcBlendCaps, rec.HWDeviceDesc2.dpcLineCaps.dwSrcBlendCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwDestBlendCaps, rec.HWDeviceDesc2.dpcLineCaps.dwDestBlendCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwShadeCaps, rec.HWDeviceDesc2.dpcLineCaps.dwShadeCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureFilterCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureFilterCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureBlendCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureBlendCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureAddressCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureAddressCaps) < 0 then
          Exit;

        Result := True;
      end;
    end;

  begin
    Result := DDENUMRET_OK;

    DDraw := TDirectDraw.Create(lpGuid);
    try
      if (DDraw.DriverCaps.dwCaps and DDCAPS_3D <> 0) and
        (DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_TEXTURE <> 0) then
      begin
        if DDraw.IDDraw7 <> nil then
          Direct3D7 := DDraw.IDraw7 as IDirect3D7
        else
          Direct3D := DDraw.IDraw as IDirect3D;
        try
          if FindDevice then
          begin
            rec.DriverCaps := DDraw.DriverCaps;
            rec.HELCaps := DDraw.HELCaps;

            if lpGuid = nil then
              rec.Driver := nil
            else
            begin
              rec.DriverGUID^ := lpGuid^;
              rec.Driver^ := @rec.DriverGUID;
            end;
          end;
        finally
          Direct3D := nil;
          Direct3D7 := nil;
        end;
      end;
    finally
      DDraw.Free;
    end;
  end;

var
  rec: TDirect3DInitializingRecord;
  DDraw: TDirectDraw;
begin
  FillChar(rec, SizeOf(rec), 0);
  rec.BitCount := BitCount;
  rec.Options := Options;

  {  Driver selection   }
  if idoSelectDriver in Options then
  begin
    rec.Flag := False;
    rec.Options := Options;
    rec.Driver := @Driver;
    rec.DriverGUID := @DriverGUID;
    DXDirectDrawEnumerate(@EnumDirectDrawDriverCallback, @rec)
  end
  else
  begin
    DDraw := TDirectDraw.Create(Driver);
    try
      rec.DriverCaps := DDraw.DriverCaps;
      rec.HELCaps := DDraw.HELCaps;

      rec.D3DFlag := False;
      (DDraw.IDraw as IDirect3D).EnumDevices(@EnumDeviceCallBack, @rec);
      if rec.D3DFlag then
        rec.DeviceDesc := rec.DeviceDesc2;
    finally
      DDraw.Free;
    end;
    rec.Flag := True;
  end;

  {  Display mode optimization  }
  if rec.Flag and (idoOptimizeDisplayMode in Options) then
  begin
    if (rec.DeviceDesc.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount)) = 0 then
    begin
      if rec.DeviceDesc.dwDeviceRenderBitDepth and DDBD_16 <> 0 then
        rec.BitCount := 16
      else if rec.DeviceDesc.dwDeviceRenderBitDepth and DDBD_24 <> 0 then
        rec.BitCount := 24
      else if rec.DeviceDesc.dwDeviceRenderBitDepth and DDBD_32 <> 0 then
        rec.BitCount := 32;
    end;
  end;

  BitCount := rec.BitCount;
end;

procedure Direct3DInitializing_DXDraw(Options: TInitializeDirect3DOptions;
  DXDraw: TCustomDXDraw);
var
  BitCount: Integer;
  Driver: PGUID;
  DriverGUID: TGUID;
begin
  BitCount := DXDraw.Display.BitCount;
  Driver := DXDraw.Driver;
  Direct3DInitializing(Options, BitCount, Driver, DriverGUID);
  DXDraw.Driver := Driver;
  DXDraw.Display.BitCount := BitCount;
end;

procedure InitializeDirect3D(Surface: TDirectDrawSurface;
  var ZBuffer: TDirectDrawSurface;
  out D3D: IDirect3D;
  out D3D2: IDirect3D2;
  out D3D3: IDirect3D3;
  out D3DDevice: IDirect3DDevice;
  out D3DDevice2: IDirect3DDevice2;
  out D3DDevice3: IDirect3DDevice3;
{$IFDEF D3DRM}
  var D3DRM: IDirect3DRM;
  var D3DRM2: IDirect3DRM2;
  var D3DRM3: IDirect3DRM3;
  out D3DRMDevice: IDirect3DRMDevice;
  out D3DRMDevice2: IDirect3DRMDevice2;
  out D3DRMDevice3: IDirect3DRMDevice3;
  out Viewport: IDirect3DRMViewport;
  var Scene: IDirect3DRMFrame;
  var Camera: IDirect3DRMFrame;
{$ENDIF}
  var NowOptions: TInitializeDirect3DOptions);
type
  TInitializeDirect3DRecord = record
    Flag: Boolean;
    BitCount: Integer;
    HWDeviceDesc: TD3DDeviceDesc;
    HELDeviceDesc: TD3DDeviceDesc;
    DeviceDesc: TD3DDeviceDesc;
    Hardware: Boolean;
    Options: TInitializeDirect3DOptions;
    GUID: TGUID;
    SupportHardware: Boolean;
  end;

  function CreateZBufferSurface(Surface: TDirectDrawSurface; var ZBuffer: TDirectDrawSurface;
    const DeviceDesc: TD3DDeviceDesc; Hardware: Boolean): Boolean;
  const
    MemPosition: array[Boolean] of Integer = (DDSCAPS_SYSTEMMEMORY, DDSCAPS_VIDEOMEMORY);
  var
    ZBufferBitDepth: Integer;
    ddsd: TDDSurfaceDesc;
  begin
    Result := False;
    FreeZBufferSurface(Surface, ZBuffer);

    if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_16 <> 0 then
      ZBufferBitDepth := 16
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_24 <> 0 then
      ZBufferBitDepth := 24
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_32 <> 0 then
      ZBufferBitDepth := 32
    else
      ZBufferBitDepth := 0;

    if ZBufferBitDepth <> 0 then
    begin
      with ddsd do
      begin
        dwSize := SizeOf(ddsd);
        Surface.ISurface.GetSurfaceDesc(ddsd);
        dwFlags := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT or DDSD_ZBUFFERBITDEPTH;
        ddsCaps.dwCaps := DDSCAPS_ZBUFFER or MemPosition[Hardware];
        dwHeight := Surface.Height;
        dwWidth := Surface.Width;
        dwZBufferBitDepth := ZBufferBitDepth;
      end;

      ZBuffer := TDirectDrawSurface.Create(Surface.DDraw);
      if ZBuffer.CreateSurface(ddsd) then
      begin
        if Surface.ISurface.AddAttachedSurface(ZBuffer.ISurface) <> DD_OK then
        begin
          ZBuffer.Free;
          ZBuffer := nil;
          Exit;
        end;
        Result := True;
      end
      else
      begin
        ZBuffer.Free;
        ZBuffer := nil;
        Exit;
      end;
    end;
  end;

  function EnumDeviceCallBack(const lpGuid: TGUID; lpDeviceDescription, lpDeviceName: PChar;
    const lpD3DHWDeviceDesc, lpD3DHELDeviceDesc: TD3DDeviceDesc;
    lpUserArg: Pointer): HRESULT; stdcall;
  var
    dev: ^TD3DDeviceDesc;
    Hardware: Boolean;
    rec: ^TInitializeDirect3DRecord;

    procedure UseThisDevice;
    begin
      rec.Flag := True;
      rec.GUID := lpGuid;
      rec.HWDeviceDesc := lpD3DHWDeviceDesc;
      rec.HELDeviceDesc := lpD3DHELDeviceDesc;
      rec.DeviceDesc := dev^;
      rec.Hardware := Hardware;
    end;

  begin
    Result := D3DENUMRET_OK;
    rec := lpUserArg;

    Hardware := lpD3DHWDeviceDesc.dcmColorModel <> 0;
    if Hardware then
      dev := @lpD3DHWDeviceDesc
    else
      dev := @lpD3DHELDeviceDesc;

    if (Hardware) and (not rec.SupportHardware) then
      Exit;
    if dev.dcmColorModel <> D3DCOLOR_RGB then
      Exit;
    if CompareMem(@lpGuid, @IID_IDirect3DRefDevice, SizeOf(TGUID)) then
      Exit;

    {  Bit depth test.  }
    if (dev.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount)) = 0 then
      Exit;

    if Hardware then
    begin
      {  Hardware  }
      UseThisDevice;
    end
    else
    begin
      {  Software  }
      if not rec.Hardware then
        UseThisDevice;
    end;
  end;

var
  Hardware: Boolean;
  SupportHardware: Boolean;
  D3DDeviceGUID: TGUID;
  Options: TInitializeDirect3DOptions;

  procedure InitDevice;
  var
    rec: TInitializeDirect3DRecord;
  begin
    {  Device search  }
    rec.Flag := False;
    rec.BitCount := Surface.BitCount;
    rec.Hardware := False;
    rec.Options := Options;
    rec.SupportHardware := SupportHardware;

    D3D3.EnumDevices(@EnumDeviceCallBack, @rec);
    if not rec.Flag then
      raise EDXDrawError.Create(S3DDeviceNotFound);

    Hardware := rec.Hardware;
    D3DDeviceGUID := rec.GUID;

    if Hardware then
      NowOptions := NowOptions + [idoHardware];

    {  Z buffer making  }
    NowOptions := NowOptions - [idoZBuffer];
    if idoZBuffer in Options then
    begin
      if CreateZBufferSurface(Surface, ZBuffer, rec.DeviceDesc, Hardware) then
        NowOptions := NowOptions + [idoZBuffer];
    end;
  end;
{$IFDEF D3DRM}
type
  TDirect3DRMCreate = function(out lplpDirect3DRM: IDirect3DRM): HRESULT; stdcall;
{$ENDIF}
begin
  try
    Options := NowOptions;
    NowOptions := [];

    D3D3 := Surface.DDraw.IDraw as IDirect3D3;
    D3D2 := D3D3 as IDirect3D2;
    D3D := D3D3 as IDirect3D;

    {  Whether hardware can be used is tested.  }
    SupportHardware := (Surface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_VIDEOMEMORY <> 0) and
      (idoHardware in Options) and (Surface.DDraw.DriverCaps.dwCaps and DDCAPS_3D <> 0);

    if Surface.DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_TEXTURE = 0 then
      SupportHardware := False;

    {  Direct3D  }
    InitDevice;

    if D3D3.CreateDevice(D3DDeviceGUID, Surface.ISurface4, D3DDevice3, nil) <> D3D_OK then
    begin
      SupportHardware := False;
      InitDevice;
      if D3D3.CreateDevice(D3DDeviceGUID, Surface.ISurface4, D3DDevice3, nil) <> D3D_OK then
        raise EDXDrawError.CreateFmt(SCannotMade, ['IDirect3DDevice3']);
    end;

    if SupportHardware then
      NowOptions := NowOptions + [idoHardware];

    D3DDevice2 := D3DDevice3 as IDirect3DDevice2;
    D3DDevice := D3DDevice3 as IDirect3DDevice;

    with D3DDevice3 do
    begin
      SetRenderState(TD3DRenderStateType(D3DRENDERSTATE_DITHERENABLE), 1);
      SetRenderState(TD3DRenderStateType(D3DRENDERSTATE_ZENABLE), Ord(ZBuffer <> nil));
      SetRenderState(TD3DRenderStateType(D3DRENDERSTATE_ZWRITEENABLE), Ord(ZBuffer <> nil));
    end;

    {  Direct3D Retained Mode}
    if idoRetainedMode in Options then
    begin
      NowOptions := NowOptions + [idoRetainedMode];
{$IFDEF D3DRM}
      if D3DRM = nil then
      begin
        if TDirect3DRMCreate(DXLoadLibrary('D3DRM.dll', 'Direct3DRMCreate'))(D3DRM) <> D3DRM_OK then
          raise EDXDrawError.CreateFmt(SCannotInitialized, [SDirect3DRM]);
        D3DRM2 := D3DRM as IDirect3DRM2;
        D3DRM3 := D3DRM as IDirect3DRM3;
      end;

      if D3DRM3.CreateDeviceFromD3D(D3D2, D3DDevice2, D3DRMDevice3) <> D3DRM_OK then
        raise EDXDrawError.CreateFmt(SCannotMade, ['IDirect3DRMDevice2']);

      D3DRMDevice3.SetBufferCount(2);
      D3DRMDevice := D3DRMDevice3 as IDirect3DRMDevice;
      D3DRMDevice2 := D3DRMDevice3 as IDirect3DRMDevice2;

      {  Rendering state setting  }
      D3DRMDevice.SetQuality(D3DRMLIGHT_ON or D3DRMFILL_SOLID or D3DRMSHADE_GOURAUD);
      D3DRMDevice.SetTextureQuality(D3DRMTEXTURE_NEAREST);
      D3DRMDevice.SetDither(True);

      if Surface.BitCount = 8 then
      begin
        D3DRMDevice.SetShades(8);
        D3DRM.SetDefaultTextureColors(64);
        D3DRM.SetDefaultTextureShades(32);
      end
      else
      begin
        D3DRM.SetDefaultTextureColors(64);
        D3DRM.SetDefaultTextureShades(32);
      end;

      {  Frame making  }
      if Scene = nil then
      begin
        D3DRM.CreateFrame(nil, Scene);
        D3DRM.CreateFrame(Scene, Camera);
        Camera.SetPosition(Camera, 0, 0, 0);
      end;

      {  Viewport making  }
      D3DRM.CreateViewport(D3DRMDevice, Camera, 0, 0,
        Surface.Width, Surface.Height, Viewport);
      Viewport.SetBack(5000.0);
{$ENDIF}
    end;
  except
    FreeZBufferSurface(Surface, ZBuffer);
    D3D := nil;
    D3D2 := nil;
    D3D3 := nil;
    D3DDevice := nil;
    D3DDevice2 := nil;
    D3DDevice3 := nil;
{$IFDEF D3DRM}
    D3DRM := nil;
    D3DRM2 := nil;
    D3DRMDevice := nil;
    D3DRMDevice2 := nil;
    Viewport := nil;
    Scene := nil;
    Camera := nil;
{$ENDIF}
    raise;
  end;
end;

procedure InitializeDirect3D7(Surface: TDirectDrawSurface;
  var ZBuffer: TDirectDrawSurface;
  out D3D7: IDirect3D7;
  out D3DDevice7: IDirect3DDevice7;
  var NowOptions: TInitializeDirect3DOptions);
type
  TInitializeDirect3DRecord = record
    Flag: Boolean;
    BitCount: Integer;
    DeviceDesc: TD3DDeviceDesc7;
    Hardware: Boolean;
    Options: TInitializeDirect3DOptions;
    SupportHardware: Boolean;
  end;

  function CreateZBufferSurface(Surface: TDirectDrawSurface; var ZBuffer: TDirectDrawSurface;
    const DeviceDesc: TD3DDeviceDesc7; Hardware: Boolean): Boolean;
  const
    MemPosition: array[Boolean] of Integer = (DDSCAPS_SYSTEMMEMORY, DDSCAPS_VIDEOMEMORY);
  var
    ZBufferBitDepth: Integer;
    ddsd: TDDSurfaceDesc;
  begin
    Result := False;
    FreeZBufferSurface(Surface, ZBuffer);

    if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_16 <> 0 then
      ZBufferBitDepth := 16
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_24 <> 0 then
      ZBufferBitDepth := 24
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_32 <> 0 then
      ZBufferBitDepth := 32
    else
      ZBufferBitDepth := 0;

    if ZBufferBitDepth <> 0 then
    begin
      with ddsd do
      begin
        dwSize := SizeOf(ddsd);
        Surface.ISurface.GetSurfaceDesc(ddsd);
        dwFlags := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT or DDSD_ZBUFFERBITDEPTH;
        ddsCaps.dwCaps := DDSCAPS_ZBUFFER or MemPosition[Hardware];
        dwHeight := Surface.Height;
        dwWidth := Surface.Width;
        dwZBufferBitDepth := ZBufferBitDepth;
      end;

      ZBuffer := TDirectDrawSurface.Create(Surface.DDraw);
      if ZBuffer.CreateSurface(ddsd) then
      begin
        if Surface.ISurface.AddAttachedSurface(ZBuffer.ISurface) <> DD_OK then
        begin
          ZBuffer.Free;
          ZBuffer := nil;
          Exit;
        end;
        Result := True;
      end
      else
      begin
        ZBuffer.Free;
        ZBuffer := nil;
        Exit;
      end;
    end;
  end;

  function EnumDeviceCallBack(lpDeviceDescription, lpDeviceName: PChar;
    const lpTD3DDeviceDesc: TD3DDeviceDesc7; lpUserArg: Pointer): HRESULT; stdcall;
  var
    Hardware: Boolean;
    rec: ^TInitializeDirect3DRecord;

    procedure UseThisDevice;
    begin
      rec.Flag := True;
      rec.DeviceDesc := lpTD3DDeviceDesc;
      rec.Hardware := Hardware;
    end;

  begin
    Result := D3DENUMRET_OK;
    rec := lpUserArg;

    Hardware := lpTD3DDeviceDesc.dwDevCaps and D3DDEVCAPS_HWRASTERIZATION <> 0;

    if Hardware and (not rec.SupportHardware) then
      Exit;
    if CompareMem(@lpTD3DDeviceDesc.deviceGUID, @IID_IDirect3DRefDevice, SizeOf(TGUID)) then
      Exit;

    {  Bit depth test.  }
    if (lpTD3DDeviceDesc.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount)) = 0 then
      Exit;

    if Hardware then
    begin
      {  Hardware  }
      UseThisDevice;
    end
    else
    begin
      {  Software  }
      if not rec.Hardware then
        UseThisDevice;
    end;
  end;

var
  Hardware: Boolean;
  SupportHardware: Boolean;
  D3DDeviceGUID: TGUID;
  Options: TInitializeDirect3DOptions;

  procedure InitDevice;
  var
    rec: TInitializeDirect3DRecord;
  begin
    {  Device search  }
    rec.Flag := False;
    rec.BitCount := Surface.BitCount;
    rec.Hardware := False;
    rec.Options := Options;
    rec.SupportHardware := SupportHardware;

    D3D7.EnumDevices(@EnumDeviceCallBack, @rec);
    if not rec.Flag then
      raise EDXDrawError.Create(S3DDeviceNotFound);

    Hardware := rec.Hardware;
    D3DDeviceGUID := rec.DeviceDesc.deviceGUID;

    if Hardware then
      NowOptions := NowOptions + [idoHardware];

    {  Z buffer making  }
    NowOptions := NowOptions - [idoZBuffer];
    if idoZBuffer in Options then
    begin
      if CreateZBufferSurface(Surface, ZBuffer, rec.DeviceDesc, Hardware) then
        NowOptions := NowOptions + [idoZBuffer];
    end;
  end;

begin

  try
    Options := NowOptions - [idoRetainedMode];
    NowOptions := [];

    D3D7 := Surface.DDraw.IDraw7 as IDirect3D7;

    {  Whether hardware can be used is tested.  }
    SupportHardware := (Surface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_VIDEOMEMORY <> 0) and
      (idoHardware in Options) and (Surface.DDraw.DriverCaps.dwCaps and DDCAPS_3D <> 0);

    if Surface.DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_TEXTURE = 0 then
      SupportHardware := False;

    {  Direct3D  }
    InitDevice;

    if D3D7.CreateDevice(D3DDeviceGUID, Surface.ISurface7, D3DDevice7) <> D3D_OK then
    begin
      SupportHardware := False;
      InitDevice;
      if D3D7.CreateDevice(D3DDeviceGUID, Surface.ISurface7, D3DDevice7) <> D3D_OK then
        raise EDXDrawError.CreateFmt(SCannotMade, ['IDirect3DDevice7']);
    end;

    if SupportHardware then
      NowOptions := NowOptions + [idoHardware];
  except
    FreeZBufferSurface(Surface, ZBuffer);
    D3D7 := nil;
    D3DDevice7 := nil;
    raise;
  end;
end;

type

  {  TDXDrawDriver  }

  TDXDrawDriver = class
  private
    FDXDraw: TCustomDXDraw;
    constructor Create(ADXDraw: TCustomDXDraw); virtual;
    destructor Destroy; override;
    procedure Finalize; virtual;
    procedure Flip; virtual; abstract;
    procedure Initialize; virtual; abstract;
    procedure Initialize3D;
    function SetSize(AWidth, AHeight: Integer): Boolean; virtual;
    function Restore: Boolean;
  end;

  TDXDrawDriverBlt = class(TDXDrawDriver)
  private
    procedure Flip; override;
    procedure Initialize; override;
    procedure InitializeSurface;
    function SetSize(AWidth, AHeight: Integer): Boolean; override;
  end;

  TDXDrawDriverFlip = class(TDXDrawDriver)
  private
    procedure Flip; override;
    procedure Initialize; override;
  end;

procedure TCustomDXDraw.MirrorFlip(Value: TRenderMirrorFlipSet);
begin
  if (do3D in Options) and Assigned(FD2D) then
    FD2D.MirrorFlip := Value;
end;

{  TDXDrawDriver  }

constructor TDXDrawDriver.Create(ADXDraw: TCustomDXDraw);
var
  AOptions: TInitializeDirect3DOptions;
begin
  inherited Create;
  FDXDraw := ADXDraw;

  {  Driver selection and Display mode optimizationn }
  if FDXDraw.FOptions * [doFullScreen, doSystemMemory, do3D, doHardware] = [doFullScreen, do3D, doHardware] then
  begin
    AOptions := [];
    with FDXDraw do
    begin
      if doSelectDriver in Options then
        AOptions := AOptions + [idoSelectDriver];
      if not FDXDraw.Display.FixedBitCount then
        AOptions := AOptions + [idoOptimizeDisplayMode];

      if doHardware in Options then
        AOptions := AOptions + [idoHardware];
      if doRetainedMode in Options then
        AOptions := AOptions + [idoRetainedMode];
      if doZBuffer in Options then
        AOptions := AOptions + [idoZBuffer];
    end;

    Direct3DInitializing_DXDraw(AOptions, FDXDraw);
  end;

  if FDXDraw.Options * [doFullScreen, doHardware, doSystemMemory] = [doFullScreen, doHardware] then
    FDXDraw.FDDraw := TDirectDraw.CreateEx(PGUID(FDXDraw.FDriver), doDirectX7Mode in FDXDraw.Options)
  else
    FDXDraw.FDDraw := TDirectDraw.CreateEx(nil, doDirectX7Mode in FDXDraw.Options);
end;

procedure TDXDrawDriver.Initialize3D;
const
  DXDrawOptions3D = [doHardware, doRetainedMode, doSelectDriver, doZBuffer];
var
  AOptions: TInitializeDirect3DOptions;
begin
  AOptions := [];
  with FDXDraw do
  begin
    if doHardware in FOptions then
      AOptions := AOptions + [idoHardware];
    if doRetainedMode in FNowOptions then
      AOptions := AOptions + [idoRetainedMode];
    if doSelectDriver in FOptions then
      AOptions := AOptions + [idoSelectDriver];
    if doZBuffer in FOptions then
      AOptions := AOptions + [idoZBuffer];

    if doDirectX7Mode in FOptions then
    begin
      InitializeDirect3D7(FSurface, FZBuffer, FD3D7, FD3DDevice7, AOptions);
    end
    else
    begin
      InitializeDirect3D(FSurface, FZBuffer, FD3D, FD3D2, FD3D3, FD3DDevice, FD3DDevice2, FD3DDevice3,
{$IFDEF D3DRM}
        FD3DRM, FD3DRM2, FD3DRM3, FD3DRMDevice, FD3DRMDevice2, FD3DRMDevice3, FViewport, FScene, FCamera,
{$ENDIF}
        AOptions);
    end;

    FNowOptions := FNowOptions - DXDrawOptions3D;
    if idoHardware in AOptions then
      FNowOptions := FNowOptions + [doHardware];
    if idoRetainedMode in AOptions then
      FNowOptions := FNowOptions + [doRetainedMode];
    if idoSelectDriver in AOptions then
      FNowOptions := FNowOptions + [doSelectDriver];
    if idoZBuffer in AOptions then
      FNowOptions := FNowOptions + [doZBuffer];
  end;
end;

destructor TDXDrawDriver.Destroy;
begin
  Finalize;
  FDXDraw.FDDraw.Free;
  inherited Destroy;
end;

procedure TDXDrawDriver.Finalize;
begin
  with FDXDraw do
  begin
{$IFDEF D3DRM}
    FViewport := nil;
    FCamera := nil;
    FScene := nil;

    FD3DRMDevice := nil;
    FD3DRMDevice2 := nil;
    FD3DRMDevice3 := nil;
    FD3DRM3 := nil;
    FD3DRM2 := nil;
    FD3DRM := nil;
{$ENDIF}
    FD3DDevice := nil;
    FD3DDevice2 := nil;
    FD3DDevice3 := nil;
    FD3DDevice7 := nil;
    FD3D := nil;
    FD3D2 := nil;
    FD3D3 := nil;
    FD3D7 := nil;

    FreeZBufferSurface(FSurface, FZBuffer);

    FClipper.Free;
    FClipper := nil;
    FPalette.Free;
    FPalette := nil;
    FSurface.Free;
    FSurface := nil;
    FPrimary.Free;
    FPrimary := nil;

  end;
end;

function TDXDrawDriver.Restore: Boolean;
begin
  Result := FDXDraw.FPrimary.Restore and FDXDraw.FSurface.Restore;
  if Result then
  begin
    FDXDraw.FPrimary.Fill(0);
    FDXDraw.FSurface.Fill(0);
  end;
end;

function TDXDrawDriver.SetSize(AWidth, AHeight: Integer): Boolean;
begin
  Result := False;
end;

{  TDXDrawDriverBlt  }

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads;
  AllowPalette256: Boolean): TPaletteEntries;
var
  Entries: TPaletteEntries;
  dc: THandle;
  i: Integer;
begin
  Result := RGBQuadsToPaletteEntries(RGBQuads);

  if not AllowPalette256 then
  begin
    dc := GetDC(0);
    try
      GetSystemPaletteEntries(dc, 0, 256, Entries);
    finally
      ReleaseDC(0, dc);
    end;

    for i := 0 to 9 do
      Result[i] := Entries[i];

    for i := 256 - 10 to 255 do
      Result[i] := Entries[i];
  end;

  for i := 0 to 255 do
    Result[i].peFlags := D3DPAL_READONLY;
end;

procedure TDXDrawDriverBlt.Flip;
var
  pt: TPoint;
  Dest: TRect;
  DF: TDDBltFX;
begin
  pt := FDXDraw.ClientToScreen(Point(0, 0));

  if doStretch in FDXDraw.NowOptions then
  begin
    Dest := Bounds(pt.X, pt.Y, FDXDraw.Width, FDXDraw.Height);
  end
  else
  begin
    if doCenter in FDXDraw.NowOptions then
    begin
      Inc(pt.X, (FDXDraw.Width - FDXDraw.FSurface.Width) div 2);
      Inc(pt.Y, (FDXDraw.Height - FDXDraw.FSurface.Height) div 2);
    end;

    Dest := Bounds(pt.X, pt.Y, FDXDraw.FSurface.Width, FDXDraw.FSurface.Height);
  end;

  if doWaitVBlank in FDXDraw.NowOptions then
    FDXDraw.FDDraw.DXResult := FDXDraw.FDDraw.IDraw.WaitForVerticalBlank(DDWAITVB_BLOCKBEGIN, 0);

  DF.dwSize := SizeOf(DF);
  DF.dwDDFX := 0;

  FDXDraw.FPrimary.Blt(Dest, FDXDraw.FSurface.ClientRect, DDBLT_WAIT, DF, FDXDraw.FSurface);
end;

procedure TDXDrawDriverBlt.Initialize;
const
  PrimaryDesc: TDDSurfaceDesc = (
    dwSize: SizeOf(PrimaryDesc);
    dwFlags: DDSD_CAPS;
    ddsCaps: (dwCaps: DDSCAPS_PRIMARYSURFACE)
    );
var
  Entries: TPaletteEntries;
  PaletteCaps: Integer;
begin
  {  Surface making  }
  FDXDraw.FPrimary := TDirectDrawSurface.Create(FDXDraw.FDDraw);
  if not FDXDraw.FPrimary.CreateSurface(PrimaryDesc) then
    raise EDXDrawError.CreateFmt(SCannotMade, [SDirectDrawPrimarySurface]);

  FDXDraw.FSurface := TDirectDrawSurface.Create(FDXDraw.FDDraw);

  {  Clipper making  }
  FDXDraw.FClipper := TDirectDrawClipper.Create(FDXDraw.FDDraw);
  FDXDraw.FClipper.Handle := FDXDraw.Handle;
  FDXDraw.FPrimary.Clipper := FDXDraw.FClipper;

  {  Palette making  }
  PaletteCaps := DDPCAPS_8BIT or DDPCAPS_INITIALIZE;
  if doAllowPalette256 in FDXDraw.NowOptions then
    PaletteCaps := PaletteCaps or DDPCAPS_ALLOW256;

  FDXDraw.FPalette := TDirectDrawPalette.Create(FDXDraw.FDDraw);
  Entries := TDXDrawRGBQuadsToPaletteEntries(FDXDraw.ColorTable,
    doAllowPalette256 in FDXDraw.NowOptions);
  FDXDraw.FPalette.CreatePalette(PaletteCaps, Entries);

  FDXDraw.FPrimary.Palette := FDXDraw.Palette;

  InitializeSurface;
end;

procedure TDXDrawDriverBlt.InitializeSurface;
var
  ddsd: TDDSurfaceDesc;
begin
  FDXDraw.FSurface.IDDSurface := nil;

  {  Surface making  }
  FDXDraw.FNowOptions := FDXDraw.FNowOptions - [doSystemMemory];

  FillChar(ddsd, SizeOf(ddsd), 0);
  with ddsd do
  begin
    dwSize := SizeOf(ddsd);
    dwFlags := DDSD_WIDTH or DDSD_HEIGHT or DDSD_CAPS;
    dwWidth := Max(FDXDraw.FSurfaceWidth, 1);
    dwHeight := Max(FDXDraw.FSurfaceHeight, 1);
    ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN;
    if doSystemMemory in FDXDraw.Options then
      ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY;
    if do3D in FDXDraw.FNowOptions then
      ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_3DDEVICE;
  end;

  if not FDXDraw.FSurface.CreateSurface(ddsd) then
  begin
    ddsd.ddsCaps.dwCaps := ddsd.ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY;
    if not FDXDraw.FSurface.CreateSurface(ddsd) then
      raise EDXDrawError.CreateFmt(SCannotMade, [SDirectDrawSurface]);
  end;

  if FDXDraw.FSurface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_VIDEOMEMORY = 0 then
    FDXDraw.FNowOptions := FDXDraw.FNowOptions + [doSystemMemory];

  FDXDraw.FSurface.Palette := FDXDraw.Palette;
  FDXDraw.FSurface.Fill(0);

  if do3D in FDXDraw.FNowOptions then
    Initialize3D;
end;

function TDXDrawDriverBlt.SetSize(AWidth, AHeight: Integer): Boolean;
begin
  Result := True;

  FDXDraw.FSurfaceWidth := Max(AWidth, 1);
  FDXDraw.FSurfaceHeight := Max(AHeight, 1);

  Inc(FDXDraw.FOffNotifyRestore);
  try
    FDXDraw.NotifyEventList(dxntFinalizeSurface);

    if FDXDraw.FCalledDoInitializeSurface then
    begin
      FDXDraw.FCalledDoInitializeSurface := False;
      FDXDraw.DoFinalizeSurface;
    end;

    InitializeSurface;

    FDXDraw.NotifyEventList(dxntInitializeSurface);
    FDXDraw.FCalledDoInitializeSurface := True;
    FDXDraw.DoInitializeSurface;
  finally
    Dec(FDXDraw.FOffNotifyRestore);
  end;
end;

{  TDXDrawDriverFlip  }

procedure TDXDrawDriverFlip.Flip;
begin
  if (FDXDraw.FForm <> nil) and (FDXDraw.FForm.Active) then
    FDXDraw.FPrimary.DXResult := FDXDraw.FPrimary.ISurface.Flip(nil, DDFLIP_WAIT)
  else
    FDXDraw.FPrimary.DXResult := 0;
end;

procedure TDXDrawDriverFlip.Initialize;
const
  DefPrimaryDesc: TDDSurfaceDesc = (
    dwSize: SizeOf(DefPrimaryDesc);
    dwFlags: DDSD_CAPS or DDSD_BACKBUFFERCOUNT;
    dwBackBufferCount: 1;
    ddsCaps: (dwCaps: DDSCAPS_PRIMARYSURFACE or DDSCAPS_FLIP or DDSCAPS_COMPLEX)
    );
  BackBufferCaps: TDDSCaps = (dwCaps: DDSCAPS_BACKBUFFER);
var
  PrimaryDesc: TDDSurfaceDesc;
  PaletteCaps: Integer;
  Entries: TPaletteEntries;
  DDSurface: IDirectDrawSurface;
begin
  {  Surface making  }
  PrimaryDesc := DefPrimaryDesc;

  if do3D in FDXDraw.FNowOptions then
    PrimaryDesc.ddsCaps.dwCaps := PrimaryDesc.ddsCaps.dwCaps or DDSCAPS_3DDEVICE;

  FDXDraw.FPrimary := TDirectDrawSurface.Create(FDXDraw.FDDraw);
  if not FDXDraw.FPrimary.CreateSurface(PrimaryDesc) then
    raise EDXDrawError.CreateFmt(SCannotMade, [SDirectDrawPrimarySurface]);

  FDXDraw.FSurface := TDirectDrawSurface.Create(FDXDraw.FDDraw);
  if FDXDraw.FPrimary.ISurface.GetAttachedSurface(BackBufferCaps, DDSurface) = DD_OK then
    FDXDraw.FSurface.IDDSurface := DDSurface;

  FDXDraw.FNowOptions := FDXDraw.FNowOptions - [doSystemMemory];
  if FDXDraw.FSurface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_SYSTEMMEMORY <> 0 then
    FDXDraw.FNowOptions := FDXDraw.FNowOptions + [doSystemMemory];

  {  Clipper making of dummy  }
  FDXDraw.FClipper := TDirectDrawClipper.Create(FDXDraw.FDDraw);

  {  Palette making  }
  PaletteCaps := DDPCAPS_8BIT;
  if doAllowPalette256 in FDXDraw.Options then
    PaletteCaps := PaletteCaps or DDPCAPS_ALLOW256;

  FDXDraw.FPalette := TDirectDrawPalette.Create(FDXDraw.FDDraw);
  Entries := TDXDrawRGBQuadsToPaletteEntries(FDXDraw.ColorTable,
    doAllowPalette256 in FDXDraw.NowOptions);
  FDXDraw.FPalette.CreatePalette(PaletteCaps, Entries);

  FDXDraw.FPrimary.Palette := FDXDraw.Palette;
  FDXDraw.FSurface.Palette := FDXDraw.Palette;

  if do3D in FDXDraw.FNowOptions then
    Initialize3D;

end;

constructor TCustomDXDraw.Create(AOwner: TComponent);
var
  Entries: TPaletteEntries;
  dc: THandle;
begin
  FNotifyEventList := TList.Create;
  inherited Create(AOwner);
  FAutoInitialize := True;
  FInitialized2 := False;
  FDXDrawDriver := nil;
  FDisplay := TDXDrawDisplay.Create(Self);

  Options := [doAllowReboot, doWaitVBlank, doCenter, doDirectX7Mode, do3D, doHardware, doSelectDriver];

  FAutoSize := True;

  dc := GetDC(0);
  try
    GetSystemPaletteEntries(dc, 0, 256, Entries);
  finally
    ReleaseDC(0, dc);
  end;

  ColorTable := PaletteEntriesToRGBQuads(Entries);
  DefColorTable := ColorTable;

  Width := 100;
  Height := 100;
  ParentColor := False;
  Color := clBlack; //clBtnFace; // FIX

  FD2D := TD2D.Create(Self);
  D2D := FD2D; {as loopback}
  FTraces := TTraces.Create(Self);
end;

destructor TCustomDXDraw.Destroy;
begin
  Finalize;
  NotifyEventList(dxntDestroying);
  FDisplay.Free;
  FSubClass.Free;
  FSubClass := nil;
  FNotifyEventList.Free;
  FD2D.Free;
  FD2D := nil;
  D2D := nil;
  FTraces.Free;
  inherited Destroy;
end;

class function TCustomDXDraw.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectDrawDrivers;
end;

type
  PDXDrawNotifyEvent = ^TDXDrawNotifyEvent;

procedure TCustomDXDraw.RegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
var
  Event: PDXDrawNotifyEvent;
begin
  UnRegisterNotifyEvent(NotifyEvent);

  New(Event);
  Event^ := NotifyEvent;
  FNotifyEventList.Add(Event);

  NotifyEvent(Self, dxntSetSurfaceSize);

  if Initialized then
  begin
    NotifyEvent(Self, dxntInitialize);
    if FCalledDoInitializeSurface then
      NotifyEvent(Self, dxntInitializeSurface);
    if FOffNotifyRestore = 0 then
      NotifyEvent(Self, dxntRestore);
  end;
end;

procedure TCustomDXDraw.UnRegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
var
  Event: PDXDrawNotifyEvent;
  i: Integer;
begin
  for i := 0 to FNotifyEventList.Count - 1 do
  begin
    Event := FNotifyEventList[i];
    if (TMethod(Event^).Code = TMethod(NotifyEvent).Code) and
      (TMethod(Event^).Data = TMethod(NotifyEvent).Data) then
    begin
      FreeMem(Event);
      FNotifyEventList.Delete(i);

      if FCalledDoInitializeSurface then
        NotifyEvent(Self, dxntFinalizeSurface);
      if Initialized then
        NotifyEvent(Self, dxntFinalize);

      Break;
    end;
  end;
end;

procedure TCustomDXDraw.NotifyEventList(NotifyType: TDXDrawNotifyType);
var
  i: Integer;
begin
  for i := FNotifyEventList.Count - 1 downto 0 do
    PDXDrawNotifyEvent(FNotifyEventList[i])^(Self, NotifyType);
end;

procedure TCustomDXDraw.FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);

  procedure FlipToGDISurface;
  begin
    if Initialized and (FNowOptions * [doFullScreen, doFlip] = [doFullScreen, doFlip]) then
      DDraw.IDraw.FlipToGDISurface;
  end;

begin
  case Message.Msg of
    WM_WINDOWPOSCHANGED:
      begin
        if TWMWindowPosChanged(Message).WindowPos^.Flags and SWP_SHOWWINDOW <> 0 then
        begin
          DefWindowProc(Message);
          if AutoInitialize and (not FInitialized2) then
            Initialize;
          Exit;
        end;
      end;
    WM_ACTIVATE:
      begin
        if TWMActivate(Message).Active = WA_INACTIVE then
          FlipToGDISurface;
      end;
    WM_INITMENU: FlipToGDISurface;
    WM_DESTROY: Finalize;
    //WM_MOVING: DoWindowMove;
  end;
  DefWindowProc(Message);
end;

procedure TCustomDXDraw.DoFinalize;
begin
  if Assigned(FOnFinalize) then
    FOnFinalize(Self);
end;

procedure TCustomDXDraw.DoWindowMove;
begin
  if Assigned(FOnWindowMove) then
    FOnWindowMove(Self);
end;

procedure TCustomDXDraw.DoFinalizeSurface;
begin
  if Assigned(FOnFinalizeSurface) then
    FOnFinalizeSurface(Self);
end;

procedure TCustomDXDraw.DoInitialize;
begin
  if Assigned(FOnInitialize) then
    FOnInitialize(Self);
end;

procedure TCustomDXDraw.DoInitializeSurface;
begin
  {.06 added for better initialization}
  if Assigned(FD2D) then
    RenderError := FD2D.D2DInitializeSurface;

  if Assigned(FOnInitializeSurface) then
    FOnInitializeSurface(Self);
end;

procedure TCustomDXDraw.DoInitializing;
begin
  if Assigned(FOnInitializing) then
    FOnInitializing(Self);
end;

procedure TCustomDXDraw.DoRestoreSurface;
begin
  if Assigned(FOnRestoreSurface) then
    FOnRestoreSurface(Self);
end;

procedure TCustomDXDraw.Finalize;
begin
  if FInternalInitialized then
  begin

    FSurfaceWidth := SurfaceWidth;
    FSurfaceHeight := SurfaceHeight;

    FDisplay.FModes.Clear;

    FUpdating := True;
    try
      try
        try
          if FCalledDoInitializeSurface then
          begin
            FCalledDoInitializeSurface := False;
            DoFinalizeSurface;
          end;
        finally
          NotifyEventList(dxntFinalizeSurface);
        end;
      finally
        try
          if FCalledDoInitialize then
          begin
            FCalledDoInitialize := False;
            DoFinalize;
          end;
        finally
          NotifyEventList(dxntFinalize);
        end;
      end;
    finally
      FUpdating := False;
      FInternalInitialized := False;
      FInitialized := False;

      SetOptions(FOptions);
      if FDXDrawDriver <> nil then
        FDXDrawDriver.Free;
      FDXDrawDriver := nil;
      FUpdating := False;
    end;
  end;
  if Assigned(FD2D) then
    FD2D.Free;
  FD2D := nil;
  D2D := nil
end;

procedure TCustomDXDraw.Flip;
begin
  if Initialized and (not FUpdating) then
  begin
    if TryRestore and (not RenderError) then
      TDXDrawDriver(FDXDrawDriver).Flip;
  end;
  RenderError := False;
end;

function TCustomDXDraw.GetCanDraw: Boolean;
begin
  //Result := Initialized and (not FUpdating) and (Surface.IDDSurface <> nil) and TryRestore;
  Result := False;
  if Initialized and (not FUpdating) and (Surface.IDDSurface <> nil) and (Primary.IDDSurface <> nil) then
  begin
    if (Primary.ISurface.IsLost = DDERR_SURFACELOST) or (Surface.ISurface.IsLost = DDERR_SURFACELOST) then
    begin
      if Assigned(FD2D) and Assigned(FD2D.FD2DTexture) then
        FD2D.FD2DTexture.D2DPruneAllTextures; //<-Add Mr.Kawasaki
      Restore;
      Result := (Primary.ISurface.IsLost = DD_OK) and (Surface.ISurface.IsLost = DD_OK);
    end
    else
      Result := True;
  end;

  {if Initialized and (not FUpdating) and (Primary.IDDSurface <> nil) then begin
    if (Primary.ISurface.IsLost = DDERR_SURFACELOST) or (Surface.ISurface.IsLost = DDERR_SURFACELOST) then begin
      if Assigned(FD2D) and Assigned(FD2D.FD2DTexture) then FD2D.FD2DTexture.D2DPruneAllTextures; //<-Add Mr.Kawasaki
      Restore;
      Result := (Primary.ISurface.IsLost = DD_OK) and (Surface.ISurface.IsLost = DD_OK);
    end else
      Result := True;
  end;}

end;

function TCustomDXDraw.GetCanPaletteAnimation: Boolean;
begin
  Result := Initialized and (not FUpdating) and (doFullScreen in FNowOptions)
    and (DDraw.DisplayMode.ddpfPixelFormat.dwRGBBitCount <= 8);
end;

function TCustomDXDraw.GetSurfaceHeight: Integer;
begin
  if Surface.IDDSurface <> nil then
    Result := Surface.Height
  else
    Result := FSurfaceHeight;
end;

function TCustomDXDraw.GetSurfaceWidth: Integer;
begin
  if Surface.IDDSurface <> nil then
    Result := Surface.Width
  else
    Result := FSurfaceWidth;
end;

procedure TCustomDXDraw.Loaded;
begin
  inherited Loaded;

  if AutoSize then
  begin
    FSurfaceWidth := Width;
    FSurfaceHeight := Height;
  end;

  NotifyEventList(dxntSetSurfaceSize);

  if FAutoInitialize and (not (csDesigning in ComponentState)) then
  begin
    if {(not (doFullScreen in FOptions)) or }(FSubClass = nil) then
      Initialize;
  end;
end;

procedure TCustomDXDraw.Initialize;
begin
  FInitialized2 := True;

  Finalize;

  if FForm = nil then
    raise EDXDrawError.Create(SNoForm);

  try
    DoInitializing;

    {  Initialization.  }
    FUpdating := True;
    try
      FInternalInitialized := True;

      NotifyEventList(dxntInitializing);

      {  DirectDraw initialization.  }
      //if FDXDrawDriver = nil then begin
      if doFlip in FNowOptions then
        FDXDrawDriver := TDXDrawDriverFlip.Create(Self)
      else
        FDXDrawDriver := TDXDrawDriverBlt.Create(Self);
      //end;

      try
        {  Window handle setting.  }
        SetCooperativeLevel;

        {  Set display mode.  }
        if doFullScreen in FNowOptions then
        begin
          if not Display.DynSetSize(Display.Width, Display.Height, Display.BitCount) then
            raise EDXDrawError.CreateFmt(SDisplaymodeChange, [Display.Width, Display.Height, Display.BitCount]);
        end;

        {  Resource initialization.  }
        if AutoSize then
        begin
          FSurfaceWidth := Width;
          FSurfaceHeight := Height;
        end;
      finally
        TDXDrawDriver(FDXDrawDriver).Initialize;
      end;
    finally
      FUpdating := False;
    end;
  except
    Finalize;
    raise;
  end;

  FInitialized := True;

  Inc(FOffNotifyRestore);
  try
    NotifyEventList(dxntSetSurfaceSize);
    NotifyEventList(dxntInitialize);
    FCalledDoInitialize := True;
    DoInitialize;

    NotifyEventList(dxntInitializeSurface);
    FCalledDoInitializeSurface := True;
    DoInitializeSurface;
  finally
    Dec(FOffNotifyRestore);
  end;

  if not Assigned(FD2D) then
  begin
    FD2D := TD2D.Create(Self);
    D2D := FD2D; {as loopback}
  end;

  Restore;
end;

procedure TCustomDXDraw.Paint;
var
  Old: TDXDrawOptions;
  W, H: Integer;
  s: string;
begin
  inherited Paint;
  if (csDesigning in ComponentState) then
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Style := psDash;
    Canvas.Rectangle(0, 0, Width, Height);

    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Color := clGray;
    Canvas.MoveTo(0, 0);
    Canvas.LineTo(Width, Height);

    Canvas.MoveTo(0, Height);
    Canvas.LineTo(Width, 0);

    s := Format('(%s)', [ClassName]);

    W := Canvas.TextWidth(s);
    H := Canvas.TextHeight(s);

    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := clBtnFace;
    Canvas.TextOut(Width div 2 - W div 2, Height div 2 - H div 2, s);
  end
  else
  begin
    Old := FNowOptions;
    try
      FNowOptions := FNowOptions - [doWaitVBlank];
      Flip;
    finally
      FNowOptions := Old;
    end;
    if (Parent <> nil) and (Initialized) and (Surface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_VIDEOMEMORY <> 0) then
      Parent.Invalidate;
  end;
end;

function TCustomDXDraw.PaletteChanged(Foreground: Boolean): Boolean;
begin
  if Foreground then
  begin
    Restore;
    Result := True;
  end
  else
    Result := False;
end;

procedure TCustomDXDraw.Render(LagCount: Integer{$IFDEF DelphiX_Spt4} = 0{$ENDIF});
var
  i: Integer;
begin
{$IFDEF D3DRM}
  if FInitialized and (do3D in FNowOptions) and (doRetainedMode in FNowOptions) then
  begin
    asm FInit end;
    FViewport.Clear;
    FViewport.Render(FScene);
    FD3DRMDevice.Update;
    asm FInit end;
  end;
{$ENDIF}
  {traces}
  if FTraces.Count > 0 then
    for i := 0 to FTraces.Count - 1 do
      if FTraces.Items[i].Active then
        FTraces.Items[i].Render(LagCount);
  {own rendering event}
  if Assigned(FOnRender) then
    FOnRender(Self);
end;

procedure TCustomDXDraw.Restore;
begin
  if Initialized and (not FUpdating) then
  begin
    FUpdating := True;
    try
      if TDXDrawDriver(FDXDrawDriver).Restore then
      begin
        Primary.Palette := Palette;
        Surface.Palette := Palette;

        SetColorTable(DefColorTable);
        NotifyEventList(dxntRestore);
        DoRestoreSurface;
        SetColorTable(ColorTable);
      end;
    finally
      FUpdating := False;
    end;
  end;
end;

procedure TCustomDXDraw.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    if FAutoSize then
      SetSize(Width, Height);
  end;
end;

procedure TCustomDXDraw.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if FAutoSize and (not FUpdating) then
    SetSize(AWidth, AHeight);
end;

procedure TCustomDXDraw.BeginScene;
begin
  if (do3D in Options) and Assigned(FD2D) then
    FD2D.BeginScene
end;

procedure TCustomDXDraw.EndScene;
begin
  if (do3D in Options) and Assigned(FD2D) then
    FD2D.EndScene
end;

procedure TCustomDXDraw.ClearStack;
begin
  if (do3D in Options) and Assigned(FD2D) then
    FD2D.D2DTextures.D2DPruneAllTextures;
end;

procedure TCustomDXDraw.UpdateTextures;
var
  Changed: Boolean;
begin
  if (do3D in Options) and Assigned(FD2D) then
  begin
    if Assigned(FOnUpdateTextures) then
    begin
      Changed := False;
      FOnUpdateTextures(FD2D.FD2DTexture, Changed);
      if Changed then
        FD2D.D2DUpdateTextures;
    end
  end;
end;

procedure TCustomDXDraw.TextureFilter(Grade: TD2DTextureFilter);
begin
  if (do3D in Options) and Assigned(FD2D) then
    FD2D.TextureFilter := Grade;
end;

procedure TCustomDXDraw.AntialiasFilter(Grade: TD3DAntialiasMode);
begin
  if (do3D in Options) and Assigned(FD2D) then
    FD2D.AntialiasFilter := Grade;
end;

// ***** fade effects
// do not use in dxtimer cycle

function TCustomDXDraw.Fade2Color(colorfrom, colorto: Longint): Longint;
var
  i, r1, r2, g1, g2, b1, b2: Integer;
begin
  r1 := GetRValue(colorfrom);
  r2 := GetRValue(colorto);
  g1 := GetGValue(colorfrom);
  g2 := GetGValue(colorto);
  b1 := GetBValue(colorfrom);
  b2 := GetBValue(colorto);
  if r1 < r2 then
  begin
    for i := r1 to r2 do
    begin
      Surface.Fill(RGB(i, g1, b1));
      Flip;
    end;
  end
  else
  begin
    for i := r1 downto r2 do
    begin
      Surface.Fill(RGB(i, g1, b1));
      Flip;
    end;
  end;

  if g1 < g2 then
  begin
    for i := g1 to g2 do
    begin
      Surface.Fill(RGB(r2, i, b1));
      Flip;
    end;
  end
  else
  begin
    for i := g1 downto g2 do
    begin
      Surface.Fill(RGB(r2, i, b1));
      Flip;
    end;
  end;
  if b1 < b2 then
  begin
    for i := b1 to b2 do
    begin
      Surface.Fill(RGB(r2, g2, i));
      Flip;
    end;
  end
  else
  begin
    for i := b1 downto b2 do
    begin
      Surface.Fill(RGB(r2, g2, i));
      Flip;
    end;
  end;
  Result := colorto;
end;
{
function TCustomDXDraw.Fade2Black(colorfrom: Longint): Longint;
var
  i, R, G, B: Integer;
begin
  R := GetRValue(colorfrom);
  G := GetGValue(colorfrom);
  B := GetBValue(colorfrom);
  for i := R downto 0 do
  begin
    Surface.Fill(RGB(i, G, B));
    Flip;
  end;
  for i := G downto 0 do
  begin
    Surface.Fill(RGB(0, i, B));
    Flip;
  end;
  for i := G downto 0 do
  begin
    Surface.Fill(RGB(0, 0, i));
    Flip;
  end;
  Result := 0;
end;
 }
 {
function TCustomDXDraw.Fade2White(colorfrom: Longint): Longint;
var
  i, R, G, B: Integer;
begin
  R := GetRValue(colorfrom);
  G := GetGValue(colorfrom);
  B := GetBValue(colorfrom);
  for i := R to 255 do
  begin
    Surface.Fill(RGB(i, G, B));
    Flip;
  end;
  for i := G to 255 do
  begin
    Surface.Fill(RGB(255, i, B));
    Flip;
  end;
  for i := B to 255 do
  begin
    Surface.Fill(RGB(255, 255, i));
    Flip;
  end;
  Result := RGB(255, 255, 255);
end;
 }
function TCustomDXDraw.Grey2Fade(shadefrom, shadeto: Integer): Integer;
var
  i: Integer;
begin
  if shadefrom < shadeto then
  begin
    for i := shadefrom to shadeto do
    begin
      Surface.Fill(RGB(i, i, i));
      Flip;
    end;
  end
  else
  begin
    for i := shadefrom downto shadeto do
    begin
      Surface.Fill(RGB(i, i, i));
      Flip;
    end;
  end;
  Result := shadeto;
end;

function TCustomDXDraw.FadeGrey2Screen(oldcolor, newcolour: Longint): Longint;
begin
  Result := Grey2Fade(oldcolor, newcolour);
end;

function TCustomDXDraw.Fade2Screen(oldcolor, newcolour: Longint): Longint;
begin
  Result := Fade2Color(oldcolor, newcolour);
end;

function TCustomDXDraw.White2Screen(oldcolor: Integer): Longint;
begin
  Result := Fade2Color(oldcolor, RGB(255, 255, 255));
end;

function TCustomDXDraw.Black2Screen(oldcolor: Integer): Longint;
begin
  Result := Fade2Color(oldcolor, RGB(0, 0, 0));
end;

procedure TCustomDXDraw.GrabImage(iX, iY, iWidth, iHeight: Integer; ddib: TDIB);
var
  ts, td: TRect;
begin
  ddib.SetSize(iWidth, iHeight, 24);
  ts.Left := iX;
  ts.Top := iY;
  ts.Right := iX + iWidth - 1;
  ts.Bottom := iY + iHeight - 1;
  td.Left := 0;
  td.Top := 0;
  td.Right := iWidth;
  td.Bottom := iHeight;
  with Surface.Canvas do
  begin
    ddib.Canvas.CopyRect(td, Surface.Canvas, ts);
    Release;
  end;
end;

procedure TCustomDXDraw.PasteImage(sdib: TDIB; X, Y: Integer);
var
  ts, td: TRect;
  W, H: Integer;
begin
  W := sdib.Width - 1;
  H := sdib.Height - 1;
  ts.Left := 0;
  ts.Top := 0;
  ts.Right := W;
  ts.Bottom := H;
  td.Left := X;
  td.Top := Y;
  td.Right := X + W;
  td.Bottom := Y + H;
  with Surface.Canvas do
  begin
    CopyRect(td, sdib.Canvas, ts);
    Release;
  end;
end;

// *****

procedure TCustomDXDraw.SetColorTable(const ColorTable: TRGBQuads);
var
  Entries: TPaletteEntries;
begin
  if Initialized and (Palette <> nil) then
  begin
    Entries := TDXDrawRGBQuadsToPaletteEntries(ColorTable,
      doAllowPalette256 in FNowOptions);
    Palette.SetEntries(0, 256, Entries);
  end;
end;

procedure TCustomDXDraw.SetCooperativeLevel;
var
  Flags: Integer;
  Control: TWinControl;
begin
  Control := FForm;
  if Control = nil then
    Control := Self;

  if doFullScreen in FNowOptions then
  begin
    Flags := DDSCL_FULLSCREEN or DDSCL_EXCLUSIVE or DDSCL_ALLOWMODEX{$IFDEF DXDOUBLEPRECISION} or DDSCL_FPUPRESERVE{$ENDIF};
    if doNoWindowChange in FNowOptions then
      Flags := Flags or DDSCL_NOWINDOWCHANGES;
    if doAllowReboot in FNowOptions then
      Flags := Flags or DDSCL_ALLOWREBOOT;
  end
  else
    Flags := DDSCL_NORMAL{$IFDEF DXDOUBLEPRECISION} or DDSCL_FPUPRESERVE{$ENDIF};

  DDraw.DXResult := DDraw.IDraw.SetCooperativeLevel(Control.Handle, Flags);
end;

procedure TCustomDXDraw.SetDisplay(Value: TDXDrawDisplay);
begin
  FDisplay.Assign(Value);
end;

procedure TCustomDXDraw.SetDriver(Value: PGUID);
begin
  if not IsBadHugeReadPtr(Value, SizeOf(TGUID)) then
  begin
    FDriverGUID := Value^;
    FDriver := @FDriverGUID;
  end
  else
    FDriver := Value;
end;

procedure TCustomDXDraw.SetOptions(Value: TDXDrawOptions);
const
  InitOptions = [doDirectX7Mode, doFullScreen, doNoWindowChange, doAllowReboot,
    doAllowPalette256, doSystemMemory, doFlip, do3D,
    doRetainedMode, doHardware, doSelectDriver, doZBuffer];
var
  OldOptions: TDXDrawOptions;
begin
  FOptions := Value;

  if Initialized then
  begin
    OldOptions := FNowOptions;
    FNowOptions := FNowOptions * InitOptions + (FOptions - InitOptions);

    if not (do3D in FNowOptions) then
      FNowOptions := FNowOptions - [doHardware, doRetainedMode, doSelectDriver, doZBuffer];
  end
  else
  begin
    FNowOptions := FOptions;

    if not (doFullScreen in FNowOptions) then
      FNowOptions := FNowOptions - [doNoWindowChange, doAllowReboot, doAllowPalette256, doFlip];

    if not (do3D in FNowOptions) then
      FNowOptions := FNowOptions - [doDirectX7Mode, doRetainedMode, doHardware, doSelectDriver, doZBuffer];

    if doSystemMemory in FNowOptions then
      FNowOptions := FNowOptions - [doFlip];

    if doDirectX7Mode in FNowOptions then
      FNowOptions := FNowOptions - [doRetainedMode];

    FNowOptions := FNowOptions - [doHardware];
  end;
end;

procedure TCustomDXDraw.SetParent(AParent: TWinControl);
var
  Control: TWinControl;
begin
  inherited SetParent(AParent);

  FForm := nil;
  FSubClass.Free;
  FSubClass := nil;

  if not (csDesigning in ComponentState) then
  begin
    Control := Parent;
    while (Control <> nil) and (not (Control is TCustomForm)) do
      Control := Control.Parent;
    if Control <> nil then
    begin
      FForm := TCustomForm(Control);
      FSubClass := TControlSubClass.Create(Control, FormWndProc);
    end;
  end;
end;

procedure TCustomDXDraw.SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
begin
  if ((ASurfaceWidth <> SurfaceWidth) or (ASurfaceHeight <> SurfaceHeight)) and (not FUpdating) then
  begin
    if Initialized then
    begin
      try
        if not TDXDrawDriver(FDXDrawDriver).SetSize(ASurfaceWidth, ASurfaceHeight) then
          Exit;
      except
        Finalize;
        raise;
      end;
    end
    else
    begin
      FSurfaceWidth := ASurfaceWidth;
      FSurfaceHeight := ASurfaceHeight;
    end;

    NotifyEventList(dxntSetSurfaceSize);
  end;
end;

procedure TCustomDXDraw.SetSurfaceHeight(Value: Integer);
begin
  if ComponentState * [csReading, csLoading] = [] then
    SetSize(SurfaceWidth, Value)
  else
    FSurfaceHeight := Value;
end;

procedure TCustomDXDraw.SetSurfaceWidth(Value: Integer);
begin
  if ComponentState * [csReading, csLoading] = [] then
    SetSize(Value, SurfaceHeight)
  else
    FSurfaceWidth := Value;
end;

function TCustomDXDraw.TryRestore: Boolean;
begin
  Result := False;

  if Initialized and (not FUpdating) and (Surface.IDDSurface <> nil) and (Primary.IDDSurface <> nil) then
  begin //blue
    if (Primary.ISurface.IsLost = DDERR_SURFACELOST) or
      (Surface.ISurface.IsLost = DDERR_SURFACELOST) then
    begin
      if Assigned(FD2D) and Assigned(FD2D.FD2DTexture) then
        FD2D.FD2DTexture.D2DPruneAllTextures; //<-Add Mr.Kawasaki
      Restore;
      Result := (Primary.ISurface.IsLost = DD_OK) and (Surface.ISurface.IsLost = DD_OK);
    end
    else
      Result := True;
  end;
end;

procedure TCustomDXDraw.SetTraces(const Value: TTraces);
begin
  FTraces.Assign(Value);
end;

procedure TCustomDXDraw.UpdatePalette;
begin
  if Initialized and (doWaitVBlank in FNowOptions) then
  begin
    if FDDraw.FDriverCaps.dwPalCaps and DDPCAPS_VSYNC = 0 then
      FDDraw.IDraw.WaitForVerticalBlank(DDWAITVB_BLOCKBEGIN, 0);
  end;

  SetColorTable(ColorTable);
end;

procedure TCustomDXDraw.WMCreate(var Message: TMessage);
begin
  inherited;
  if Initialized and (not FUpdating) then
  begin
    if Clipper <> nil then
      Clipper.Handle := Handle;
    SetCooperativeLevel;
  end;
end;

{$IFDEF DX3D_deprecated}

{  TCustomDX3D  }

constructor TCustomDX3D.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Options := [toHardware, toRetainedMode, toSelectDriver];
  FSurfaceWidth := 320;
  FSurfaceHeight := 240;
end;

destructor TCustomDX3D.Destroy;
begin
  DXDraw := nil;
  inherited Destroy;
end;

procedure TCustomDX3D.DoFinalize;
begin
  if Assigned(FOnFinalize) then
    FOnFinalize(Self);
end;

procedure TCustomDX3D.DoInitialize;
begin
  if Assigned(FOnInitialize) then
    FOnInitialize(Self);
end;

procedure TCustomDX3D.Finalize;
begin
  if FInitialized then
  begin
    try
      if FInitFlag then
      begin
        FInitFlag := False;
        DoFinalize;
      end;
    finally
      FInitialized := False;

      SetOptions(FOptions);
{$IFDEF D3DRM}
      FViewport := nil;
      FCamera := nil;
      FScene := nil;

      FD3DRMDevice := nil;
      FD3DRMDevice2 := nil;
      FD3DRMDevice3 := nil;
{$ENDIF}
      FD3DDevice := nil;
      FD3DDevice2 := nil;
      FD3DDevice3 := nil;
      FD3DDevice7 := nil;
      FD3D := nil;
      FD3D2 := nil;
      FD3D3 := nil;
      FD3D7 := nil;

      FreeZBufferSurface(FSurface, FZBuffer);

      FSurface.Free;
      FSurface := nil;
{$IFDEF D3DRM}
      FD3DRM3 := nil;
      FD3DRM2 := nil;
      FD3DRM := nil;
{$ENDIF}
    end;
  end;
end;

procedure TCustomDX3D.Initialize;
var
  ddsd: TDDSurfaceDesc;
  AOptions: TInitializeDirect3DOptions;
begin
  Finalize;
  try
    FInitialized := True;

    {  Make surface.  }
    FillChar(ddsd, SizeOf(ddsd), 0);
    ddsd.dwSize := SizeOf(ddsd);
    ddsd.dwFlags := DDSD_WIDTH or DDSD_HEIGHT or DDSD_CAPS;
    ddsd.dwWidth := Max(FSurfaceWidth, 1);
    ddsd.dwHeight := Max(FSurfaceHeight, 1);
    ddsd.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN or DDSCAPS_3DDEVICE;
    if toSystemMemory in FNowOptions then
      ddsd.ddsCaps.dwCaps := ddsd.ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY
    else
      ddsd.ddsCaps.dwCaps := ddsd.ddsCaps.dwCaps or DDSCAPS_VIDEOMEMORY;

    FSurface := TDirectDrawSurface.Create(FDXDraw.DDraw);
    if not FSurface.CreateSurface(ddsd) then
    begin
      ddsd.ddsCaps.dwCaps := ddsd.ddsCaps.dwCaps and (not DDSCAPS_VIDEOMEMORY) or DDSCAPS_SYSTEMMEMORY;
      if not FSurface.CreateSurface(ddsd) then
        raise EDX3DError.CreateFmt(SCannotMade, [SDirectDrawSurface]);
    end;

    AOptions := [];

    if toHardware in FNowOptions then
      AOptions := AOptions + [idoHardware];
    if toRetainedMode in FNowOptions then
      AOptions := AOptions + [idoRetainedMode];
    if toSelectDriver in FNowOptions then
      AOptions := AOptions + [idoSelectDriver];
    if toZBuffer in FNowOptions then
      AOptions := AOptions + [idoZBuffer];

    if doDirectX7Mode in FDXDraw.NowOptions then
    begin
      InitializeDirect3D7(FSurface, FZBuffer, FD3D7, FD3DDevice7, AOptions);
    end
    else
    begin
      InitializeDirect3D(FSurface, FZBuffer, FD3D, FD3D2, FD3D3, FD3DDevice, FD3DDevice2, FD3DDevice3,
{$IFDEF D3DRM}FD3DRM, FD3DRM2, FD3DRM3, FD3DRMDevice, FD3DRMDevice2, FD3DRMDevice3, FViewport, FScene, FCamera, {$ENDIF}
        AOptions);
    end;

    FNowOptions := [];

    if idoHardware in AOptions then
      FNowOptions := FNowOptions + [toHardware];
    if idoRetainedMode in AOptions then
      FNowOptions := FNowOptions + [toRetainedMode];
    if idoSelectDriver in AOptions then
      FNowOptions := FNowOptions + [toSelectDriver];
    if idoZBuffer in AOptions then
      FNowOptions := FNowOptions + [toZBuffer];
  except
    Finalize;
    raise;
  end;

  FInitFlag := True;
  DoInitialize;
end;

procedure TCustomDX3D.Render;
begin
{$IFDEF D3DRM}
  if FInitialized and (toRetainedMode in FNowOptions) then
  begin
    asm FInit end;
    FViewport.Clear;
    FViewport.Render(FScene);
    FD3DRMDevice.Update;
    asm FInit end;
  end;
{$ENDIF}
end;

function TCustomDX3D.GetCanDraw: Boolean;
begin
  Result := Initialized and (Surface.IDDSurface <> nil) and
    (Surface.ISurface.IsLost = DD_OK);
end;

function TCustomDX3D.GetSurfaceHeight: Integer;
begin
  if FSurface.IDDSurface <> nil then
    Result := FSurface.Height
  else
    Result := FSurfaceHeight;
end;

function TCustomDX3D.GetSurfaceWidth: Integer;
begin
  if FSurface.IDDSurface <> nil then
    Result := FSurface.Width
  else
    Result := FSurfaceWidth;
end;

procedure TCustomDX3D.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    if FAutoSize and (DXDraw <> nil) then
      SetSize(DXDraw.SurfaceWidth, DXDraw.SurfaceHeight);
  end;
end;

procedure TCustomDX3D.SetOptions(Value: TDX3DOptions);
const
  DX3DOptions = [toRetainedMode, toSystemMemory, toHardware, toSelectDriver, toZBuffer];
  InitOptions = [toSystemMemory, toHardware, toSelectDriver, toZBuffer];
var
  OldOptions: TDX3DOptions;
begin
  FOptions := Value;

  if Initialized then
  begin
    OldOptions := FNowOptions;
    FNowOptions := FNowOptions * InitOptions + FOptions * (DX3DOptions - InitOptions);
  end
  else
  begin
    FNowOptions := FOptions;

    if (FDXDraw <> nil) and (doDirectX7Mode in FDXDraw.FNowOptions) then
      FNowOptions := FNowOptions - [toRetainedMode];
  end;
end;

procedure TCustomDX3D.SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
begin
  if (ASurfaceWidth <> SurfaceWidth) or (ASurfaceHeight <> SurfaceHeight) then
  begin
    FSurfaceWidth := ASurfaceWidth;
    FSurfaceHeight := ASurfaceHeight;

    if Initialized then
      Initialize;
  end;
end;

procedure TCustomDX3D.SetSurfaceHeight(Value: Integer);
begin
  if ComponentState * [csReading, csLoading] = [] then
    SetSize(SurfaceWidth, Value)
  else
    FSurfaceHeight := Value;
end;

procedure TCustomDX3D.SetSurfaceWidth(Value: Integer);
begin
  if ComponentState * [csReading, csLoading] = [] then
    SetSize(Value, SurfaceHeight)
  else
    FSurfaceWidth := Value;
end;

procedure TCustomDX3D.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDXDraw = AComponent) then
    DXDraw := nil;
end;

procedure TCustomDX3D.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
var
  AOptions: TInitializeDirect3DOptions;
begin
  case NotifyType of
    dxntDestroying:
      begin
        DXDraw := nil;
      end;
    dxntInitializing:
      begin
        if (FDXDraw.FOptions * [do3D, doFullScreen] = [doFullScreen])
          and (FOptions * [toSystemMemory, toSelectDriver] = [toSelectDriver]) then
        begin
          AOptions := [];
          with FDXDraw do
          begin
            if doHardware in Options then
              AOptions := AOptions + [idoHardware];
            if doRetainedMode in Options then
              AOptions := AOptions + [idoRetainedMode];
            if doSelectDriver in Options then
              AOptions := AOptions + [idoSelectDriver];
            if doZBuffer in Options then
              AOptions := AOptions + [idoZBuffer];
          end;

          Direct3DInitializing_DXDraw(AOptions, FDXDraw);
        end;
      end;
    dxntInitialize:
      begin
        Initialize;
      end;
    dxntFinalize:
      begin
        Finalize;
      end;
    dxntRestore:
      begin
        FSurface.Restore;
        if FZBuffer <> nil then
          FZBuffer.Restore;
        FSurface.Palette := FDXDraw.Palette;
      end;
    dxntSetSurfaceSize:
      begin
        if AutoSize then
          SetSize(Sender.SurfaceWidth, Sender.SurfaceHeight);
      end;
  end;
end;

procedure TCustomDX3D.SetDXDraw(Value: TCustomDXDraw);
begin
  if FDXDraw <> Value then
  begin
    if FDXDraw <> nil then
      FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);

    FDXDraw := Value;

    if FDXDraw <> nil then
      FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
  end;
end;

{$ENDIF}

{  TDirect3DTexture  }

constructor TDirect3DTexture.Create(Graphic: TGraphic; DXDraw: TComponent);
var
  i: Integer;
begin
  inherited Create;
  FDXDraw := DXDraw;
  FGraphic := Graphic;

  {  The palette is acquired.  }
  i := GetPaletteEntries(FGraphic.Palette, 0, 256, FPaletteEntries);
  case i of
    1..2: FBitCount := 1;
    3..16: FBitCount := 4;
    17..256: FBitCount := 8;
  else
    FBitCount := 24;
  end;

  if FDXDraw is TCustomDXDraw then
  begin
    with (FDXDraw as TCustomDXDraw) do
    begin
      if (not Initialized) or (not (do3D in NowOptions)) then
        raise EDirect3DTextureError.CreateFmt(SNotMade, [FDXDraw.ClassName]);
    end;
    FSurface := TDirectDrawSurface.Create((FDXDraw as TCustomDXDraw).Surface.DDraw);
    (FDXDraw as TCustomDXDraw).RegisterNotifyEvent(DXDrawNotifyEvent);
  end
  else
{$IFDEF DX3D_deprecated}if FDXDraw is TCustomDX3D then
    begin
      with (FDXDraw as TDX3D) do
      begin
        if not Initialized then
          raise EDirect3DTextureError.CreateFmt(SNotMade, [FDXDraw.ClassName]);
      end;

      FSurface := TDirectDrawSurface.Create((FDXDraw as TCustomDX3D).Surface.DDraw);
      (FDXDraw as TCustomDX3D).FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
    end
    else
{$ENDIF}
      raise EDirect3DTextureError.CreateFmt(SNotSupported, [FDXDraw.ClassName]);
end;

destructor TDirect3DTexture.Destroy;
begin
  if FDXDraw is TCustomDXDraw then
  begin
    (FDXDraw as TCustomDXDraw).UnRegisterNotifyEvent(DXDrawNotifyEvent);
  end
{$IFDEF DX3D_deprecated}
  else if FDXDraw is TCustomDX3D then
  begin
    (FDXDraw as TCustomDX3D).FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);
  end
{$ENDIF};
  Clear;
  FSurface.Free;
  inherited Destroy;
end;

procedure TDirect3DTexture.Clear;
begin
  FHandle := 0;
  FTexture := nil;
  FSurface.IDDSurface := nil;
end;

function TDirect3DTexture.GetHandle: TD3DTextureHandle;
begin
  if FTexture = nil then
    Restore;
  Result := FHandle;
end;

function TDirect3DTexture.GetSurface: TDirectDrawSurface;
begin
  if FTexture = nil then
    Restore;
  Result := FSurface;
end;

function TDirect3DTexture.GetTexture: IDirect3DTexture;
begin
  if FTexture = nil then
    Restore;
  Result := FTexture;
end;

procedure TDirect3DTexture.SetTransparentColor(Value: TColor);
begin
  if FTransparentColor <> Value then
  begin
    FTransparentColor := Value;

    if FSurface <> nil then
      FSurface.TransparentColor := FSurface.ColorMatch(Value);
  end;
end;

procedure TDirect3DTexture.Restore;

  function EnumTextureFormatCallback(const ddsd: TDDSurfaceDesc;
    lParam: Pointer): HRESULT; stdcall;
  var
    tex: TDirect3DTexture;

    procedure UseThisFormat;
    begin
      tex.FFormat := ddsd;
      tex.FEnumFormatFlag := True;
    end;

  begin
    Result := DDENUMRET_OK;
    tex := lParam;

    if ddsd.ddpfPixelFormat.dwFlags and (DDPF_ALPHA or DDPF_ALPHAPIXELS) <> 0 then
      Exit;

    if not tex.FEnumFormatFlag then
    begin
      {  When called first,  this format is unconditionally selected.  }
      UseThisFormat;
    end
    else
    begin
      if (tex.FBitCount <= 8) and (ddsd.ddpfPixelFormat.dwRGBBitCount >= tex.FBitCount) and
        (ddsd.ddpfPixelFormat.dwRGBBitCount >= 8) and
        (ddsd.ddpfPixelFormat.dwFlags and DDPF_RGB <> 0) then
      begin
        if tex.FFormat.ddpfPixelFormat.dwRGBBitCount > ddsd.ddpfPixelFormat.dwRGBBitCount then
          UseThisFormat;
      end
      else
      begin
        if (tex.FFormat.ddpfPixelFormat.dwRGBBitCount > ddsd.ddpfPixelFormat.dwRGBBitCount) and
          (ddsd.ddpfPixelFormat.dwRGBBitCount > 8) and
          (ddsd.ddpfPixelFormat.dwFlags and DDPF_RGB <> 0) then
          UseThisFormat;
      end;
    end;
  end;

  function GetBitCount(i: Integer): Integer;
  var
    j: Integer;
  begin
    for j := 32 downto 1 do
      if (1 shl j) and i <> 0 then
      begin
        Result := j;
        if 1 shl j <> i then
          Dec(Result);
        Exit;
      end;
    Result := 0;
  end;

  function CreateHalftonePalette(R, G, B: Integer): TPaletteEntries;
  var
    i: Integer;
  begin
    for i := 0 to 255 do
      with Result[i] do
      begin
        peRed := ((i shr (G + B - 1)) and (1 shl R - 1)) * 255 div (1 shl R - 1);
        peGreen := ((i shr (B - 1)) and (1 shl G - 1)) * 255 div (1 shl G - 1);
        peBlue := ((i shr 0) and (1 shl B - 1)) * 255 div (1 shl B - 1);
        peFlags := 0;
      end;
  end;

var
  ddsd: TDDSurfaceDesc;
  Palette: TDirectDrawPalette;
  PaletteCaps: Integer;
  TempSurface: TDirectDrawSurface;
  Width2, Height2: Integer;
  D3DDevice: IDirect3DDevice;
  Hardware: Boolean;
  DDraw: TDirectDraw;
begin
  Clear;
  try
    DDraw := nil;
    Hardware := False;
    if FDXDraw is TCustomDXDraw then
    begin
      DDraw := (FDXDraw as TCustomDXDraw).DDraw;
      D3DDevice := (FDXDraw as TCustomDXDraw).D3DDevice;
      Hardware := doHardware in (FDXDraw as TCustomDXDraw).NowOptions;
    end
{$IFDEF DX3D_deprecated}
    else if FDXDraw is TCustomDX3D then
    begin
      DDraw := (FDXDraw as TCustomDX3D).Surface.DDraw;
      D3DDevice := (FDXDraw as TCustomDX3D).D3DDevice;
      Hardware := toHardware in (FDXDraw as TCustomDX3D).NowOptions;
    end
{$ENDIF};

    if (DDraw = nil) or (D3DDevice = nil) then
      Exit;

    {  The size of texture is arranged in the size of the square of two.  }
    Width2 := Max(1 shl GetBitCount(FGraphic.Width), 1);
    Height2 := Max(1 shl GetBitCount(FGraphic.Height), 1);

    {  Selection of format of texture.  }
    FEnumFormatFlag := False;
    D3DDevice.EnumTextureFormats(@EnumTextureFormatCallback, Self);

    TempSurface := TDirectDrawSurface.Create(FSurface.DDraw);
    try
      {  Make source surface.  }
      with ddsd do
      begin
        dwSize := SizeOf(ddsd);
        dwFlags := DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH or DDSD_PIXELFORMAT;
        ddsCaps.dwCaps := DDSCAPS_TEXTURE or DDSCAPS_SYSTEMMEMORY;
        dwWidth := Width2;
        dwHeight := Height2;
        ddpfPixelFormat := FFormat.ddpfPixelFormat;
      end;

      if not TempSurface.CreateSurface(ddsd) then
        raise EDirect3DTextureError.CreateFmt(SCannotMade, [STexture]);

      {  Make surface.  }
      with ddsd do
      begin
        dwSize := SizeOf(ddsd);
        dwFlags := DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH or DDSD_PIXELFORMAT;
        if Hardware then
          ddsCaps.dwCaps := DDSCAPS_TEXTURE or DDSCAPS_VIDEOMEMORY
        else
          ddsCaps.dwCaps := DDSCAPS_TEXTURE or DDSCAPS_SYSTEMMEMORY;
        ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_ALLOCONLOAD;
        dwWidth := Width2;
        dwHeight := Height2;
        ddpfPixelFormat := FFormat.ddpfPixelFormat;
      end;

      if not FSurface.CreateSurface(ddsd) then
        raise EDirect3DTextureError.CreateFmt(SCannotMade, [STexture]);

      {  Make palette.  }
      if ddsd.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED8 <> 0 then
      begin
        PaletteCaps := DDPCAPS_8BIT or DDPCAPS_ALLOW256;
        if FBitCount = 24 then
          CreateHalftonePalette(3, 3, 2);
      end
      else if ddsd.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED4 <> 0 then
      begin
        PaletteCaps := DDPCAPS_4BIT;
        if FBitCount = 24 then
          CreateHalftonePalette(1, 2, 1);
      end
      else if ddsd.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED1 <> 0 then
      begin
        PaletteCaps := DDPCAPS_1BIT;
        if FBitCount = 24 then
        begin
          FPaletteEntries[0] := RGBQuadToPaletteEntry(RGBQuad(0, 0, 0));
          FPaletteEntries[1] := RGBQuadToPaletteEntry(RGBQuad(255, 255, 255));
        end;
      end
      else
        PaletteCaps := 0;

      if PaletteCaps <> 0 then
      begin
        Palette := TDirectDrawPalette.Create(DDraw);
        try
          Palette.CreatePalette(PaletteCaps, FPaletteEntries);
          TempSurface.Palette := Palette;
          FSurface.Palette := Palette;
        finally
          Palette.Free;
        end;
      end;

      {  The image is loaded into source surface.  }
      with TempSurface.Canvas do
      begin
        StretchDraw(TempSurface.ClientRect, FGraphic);
        Release;
      end;

      {  Source surface is loaded into surface.  }
      FTexture := FSurface.ISurface as IDirect3DTexture;
      FTexture.Load(TempSurface.ISurface as IDirect3DTexture);
    finally
      TempSurface.Free;
    end;

    if FTexture.GetHandle(D3DDevice, FHandle) <> D3D_OK then
      raise EDirect3DTextureError.CreateFmt(SCannotMade, [STexture]);

    FSurface.TransparentColor := FSurface.ColorMatch(FTransparentColor);
  except
    Clear;
    raise;
  end;
end;

procedure TDirect3DTexture.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
begin
  case NotifyType of
    dxntInitializeSurface:
      begin
        Restore;
      end;
    dxntRestore:
      begin
        Restore;
      end;
  end;
end;

{  TDirect3DTexture2  }

constructor TDirect3DTexture2.Create(ADXDraw: TCustomDXDraw; Graphic: TObject;
  AutoFreeGraphic: Boolean);
begin
  inherited Create;
  FSrcImage := Graphic;
  FAutoFreeGraphic := AutoFreeGraphic;
  FNeedLoadTexture := True;

  if FSrcImage is TDXTextureImage then
    FImage := TDXTextureImage(FSrcImage)
  else if FSrcImage is TDIB then
    SetDIB(TDIB(FSrcImage))
  else if FSrcImage is TGraphic then
  begin
    FSrcImage := TDIB.Create;
    try
      TDIB(FSrcImage).Assign(TGraphic(Graphic));
      SetDIB(TDIB(FSrcImage));
    finally
      if FAutoFreeGraphic then
        Graphic.Free;
      FAutoFreeGraphic := True;
    end;
  end
  else if FSrcImage is TPicture then
  begin
    FSrcImage := TDIB.Create;
    try
      TDIB(FSrcImage).Assign(TPicture(Graphic).Graphic);
      SetDIB(TDIB(FSrcImage));
    finally
      if FAutoFreeGraphic then
        Graphic.Free;
      FAutoFreeGraphic := True;
    end;
  end
  else
    raise Exception.CreateFmt(SCannotLoadGraphic, [Graphic.ClassName]);

  FMipmap := FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap] > 0;

  FTransparent := FImage.Transparent;
  case FImage.ImageType of
    DXTextureImageType_PaletteIndexedColor:
      begin
        FTransparentColor := PaletteIndex(dxtDecodeChannel(FImage.idx_index, FImage.TransparentColor));
      end;
    DXTextureImageType_RGBColor:
      begin
        FTransparentColor := RGB(dxtDecodeChannel(FImage.rgb_red, FImage.TransparentColor),
          dxtDecodeChannel(FImage.rgb_green, FImage.TransparentColor),
          dxtDecodeChannel(FImage.rgb_blue, FImage.TransparentColor));
      end;
  end;

  SetDXDraw(ADXDraw);
end;

constructor TDirect3DTexture2.CreateFromFile(ADXDraw: TCustomDXDraw; const FileName: string);
var
  Image: TObject;
begin
  Image := nil;
  try
    {  TDXTextureImage  }
    Image := TDXTextureImage.Create;
    try
      TDXTextureImage(Image).LoadFromFile(FileName);
    except
      Image.Free;
      Image := nil;
    end;

    {  TDIB  }
    if Image = nil then
    begin
      Image := TDIB.Create;
      try
        TDIB(Image).LoadFromFile(FileName);
      except
        Image.Free;
        Image := nil;
      end;
    end;

    {  TPicture  }
    if Image = nil then
    begin
      Image := TPicture.Create;
      try
        TPicture(Image).LoadFromFile(FileName);
      except
        Image.Free;
        Image := nil;
        raise;
      end;
    end;
  except
    Image.Free;
    raise;
  end;

  Create(ADXDraw, Image, True);
end;

constructor TDirect3DTexture2.CreateVideoTexture(ADXDraw: TCustomDXDraw);
begin
  inherited Create;
  SetDXDraw(ADXDraw);
end;

destructor TDirect3DTexture2.Destroy;
begin
  Finalize;

  SetDXDraw(nil);

  if FAutoFreeGraphic then
    FSrcImage.Free;
  FImage2.Free;
  inherited Destroy;
end;

procedure TDirect3DTexture2.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
begin
  case NotifyType of
    dxntDestroying:
      begin
        SetDXDraw(nil);
      end;
    dxntInitializeSurface:
      begin
        Initialize;
      end;
    dxntFinalizeSurface:
      begin
        Finalize;
      end;
    dxntRestore:
      begin
        Load;
      end;
  end;
end;

procedure TDirect3DTexture2.SetDXDraw(ADXDraw: TCustomDXDraw);
begin
  if FDXDraw <> ADXDraw then
  begin
    if FDXDraw <> nil then
      FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);

    FDXDraw := ADXDraw;

    if FDXDraw <> nil then
      FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
  end;
end;

procedure TDirect3DTexture2.DoRestoreSurface;
begin
  if Assigned(FOnRestoreSurface) then
    FOnRestoreSurface(Self);
end;

procedure TDirect3DTexture2.SetDIB(DIB: TDIB);
var
  i: Integer;
begin
  if FImage2 = nil then
    FImage2 := TDXTextureImage.Create;

  if DIB.BitCount <= 8 then
  begin
    FImage2.SetImage(DXTextureImageType_PaletteIndexedColor, DIB.Width, DIB.Height, DIB.BitCount,
      DIB.WidthBytes, DIB.NextLine, DIB.PBits, DIB.TopPBits, DIB.Size, False);

    FImage2.idx_index := dxtMakeChannel((1 shl DIB.BitCount) - 1, True);
    for i := 0 to 255 do
      FImage2.idx_palette[i] := RGBQuadToPaletteEntry(DIB.ColorTable[i]);
  end
  else
  begin
    FImage2.SetImage(DXTextureImageType_RGBColor, DIB.Width, DIB.Height, DIB.BitCount,
      DIB.WidthBytes, DIB.NextLine, DIB.PBits, DIB.TopPBits, DIB.Size, False);

    FImage2.rgb_red := dxtMakeChannel(DIB.NowPixelFormat.RBitMask, False);
    FImage2.rgb_green := dxtMakeChannel(DIB.NowPixelFormat.GBitMask, False);
    FImage2.rgb_blue := dxtMakeChannel(DIB.NowPixelFormat.BBitMask, False);

    i := DIB.NowPixelFormat.RBitCount + DIB.NowPixelFormat.GBitCount + DIB.NowPixelFormat.BBitCount;
    if i < DIB.BitCount then
      FImage2.rgb_alpha := dxtMakeChannel(((1 shl (DIB.BitCount - i)) - 1) shl i, False);
  end;

  FImage := FImage2;
end;

function TDirect3DTexture2.GetIsMipmap: Boolean;
begin
  if FSurface <> nil then
    Result := FUseMipmap
  else
    Result := FMipmap;
end;

function TDirect3DTexture2.GetSurface: TDirectDrawSurface;
begin
  Result := FSurface;
  if (Result <> nil) and FNeedLoadTexture then
    Load;
end;

function TDirect3DTexture2.GetTransparent: Boolean;
begin
  if FSurface <> nil then
    Result := FUseColorKey
  else
    Result := FTransparent;
end;

procedure TDirect3DTexture2.SetTransparent(Value: Boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    if FSurface <> nil then
      SetColorKey;
  end;
end;

procedure TDirect3DTexture2.SetTransparentColor(Value: TColorRef);
begin
  if FTransparentColor <> Value then
  begin
    FTransparentColor := Value;
    if (FSurface <> nil) and FTransparent then
      SetColorKey;
  end;
end;

procedure TDirect3DTexture2.Finalize;
begin
  FSurface.Free;
  FSurface := nil;

  FUseColorKey := False;
  FUseMipmap := False;
  FNeedLoadTexture := False;
end;

const
  DDPF_PALETTEINDEXED = DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8;

procedure TDirect3DTexture2.Initialize;

  function GetBitCount(i: Integer): Integer;
  begin
    Result := 31;
    while (i >= 0) and (((1 shl Result) and i) = 0) do
      Dec(Result);
  end;

  function GetMaskBitCount(B: Integer): Integer;
  var
    i: Integer;
  begin
    i := 0;
    while (i < 31) and (((1 shl i) and B) = 0) do
      Inc(i);

    Result := 0;
    while ((1 shl i) and B) <> 0 do
    begin
      Inc(i);
      Inc(Result);
    end;
  end;

  function GetPaletteBitCount(const ddpfPixelFormat: TDDPixelFormat): Integer;
  begin
    if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED8 <> 0 then
      Result := 8
    else if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED4 <> 0 then
      Result := 4
    else if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED2 <> 0 then
      Result := 2
    else if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED1 <> 0 then
      Result := 1
    else
      Result := 0;
  end;

  function EnumTextureFormatCallback(const lpDDPixFmt: TDDPixelFormat;
    lParam: Pointer): HRESULT; stdcall;
  var
    tex: TDirect3DTexture2;

    procedure UseThisFormat;
    begin
      tex.FTextureFormat.ddpfPixelFormat := lpDDPixFmt;
      tex.FEnumTextureFormatFlag := True;
    end;

  var
    rgb_red, rgb_green, rgb_blue, rgb_alpha, idx_index: Integer;
    sum1, sum2: Integer;
  begin
    Result := DDENUMRET_OK;
    tex := lParam;

    {  Form acquisition of source image  }
    rgb_red := 0;
    rgb_green := 0;
    rgb_blue := 0;
    rgb_alpha := 0;
    idx_index := 0;

    case tex.FImage.ImageType of
      DXTextureImageType_RGBColor:
        begin
          {  RGB Color  }
          rgb_red := tex.FImage.rgb_red.BitCount;
          rgb_green := tex.FImage.rgb_green.BitCount;
          rgb_blue := tex.FImage.rgb_blue.BitCount;
          rgb_alpha := tex.FImage.rgb_alpha.BitCount;
          idx_index := 8;
        end;
      DXTextureImageType_PaletteIndexedColor:
        begin
          {  Index Color  }
          rgb_red := 8;
          rgb_green := 8;
          rgb_blue := 8;
          rgb_alpha := tex.FImage.idx_alpha.BitCount;
          idx_index := tex.FImage.idx_index.BitCount;
        end;
    end;

    {  The texture examines whether this pixel format can be used.  }
    if lpDDPixFmt.dwFlags and DDPF_RGB = 0 then
      Exit;

    case tex.FImage.ImageType of
      DXTextureImageType_RGBColor:
        begin
          if lpDDPixFmt.dwFlags and DDPF_PALETTEINDEXED <> 0 then
            Exit;
        end;
      DXTextureImageType_PaletteIndexedColor:
        begin
          if (lpDDPixFmt.dwFlags and DDPF_PALETTEINDEXED <> 0) and
            (GetPaletteBitCount(lpDDPixFmt) < idx_index) then
            Exit;
        end;
    end;

    {  The pixel format which can be used is selected carefully.  }
    if tex.FEnumTextureFormatFlag then
    begin
      if lpDDPixFmt.dwFlags and DDPF_PALETTEINDEXED <> 0 then
      begin
        {  Bit count check  }
        if Abs(Integer(lpDDPixFmt.dwRGBBitCount) - idx_index) >
          Abs(Integer(tex.FTextureFormat.ddpfPixelFormat.dwRGBBitCount) - idx_index) then
          Exit;

        {  Alpha channel check  }
        if rgb_alpha > 0 then
          Exit;
      end
      else if lpDDPixFmt.dwFlags and DDPF_RGB <> 0 then
      begin
          {  The alpha channel is indispensable.  }
        if (rgb_alpha > 0) and (tex.FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_ALPHAPIXELS = 0) and
          (lpDDPixFmt.dwFlags and DDPF_ALPHAPIXELS <> 0) then
        begin
          UseThisFormat;
          Exit;
        end;

          {  Alpha channel check  }
        if (rgb_alpha > 0) and (tex.FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_ALPHAPIXELS <> 0) and
          (lpDDPixFmt.dwFlags and DDPF_ALPHAPIXELS = 0) then
        begin
          Exit;
        end;

          {  Bit count check  }
        if tex.FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED = 0 then
        begin
          sum1 := Sqr(GetMaskBitCount(lpDDPixFmt.dwRBitMask) - rgb_red) +
            Sqr(GetMaskBitCount(lpDDPixFmt.dwGBitMask) - rgb_green) +
            Sqr(GetMaskBitCount(lpDDPixFmt.dwBBitMask) - rgb_blue) +
            Sqr(GetMaskBitCount(lpDDPixFmt.dwRGBAlphaBitMask) - rgb_alpha);

          sum2 := Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwRBitMask) - rgb_red) +
            Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwGBitMask) - rgb_green) +
            Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwBBitMask) - rgb_blue) +
            Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwRGBAlphaBitMask) - rgb_alpha);

          if sum1 > sum2 then
            Exit;
        end;
      end;
    end;

    UseThisFormat;
  end;

var
  Width, Height: Integer;
  PaletteCaps: DWORD;
  Palette: IDirectDrawPalette;
  TempD3DDevDesc: TD3DDeviceDesc;
  D3DDevDesc7: TD3DDeviceDesc7;
  TempSurface: IDirectDrawSurface4;
begin
  Finalize;
  try
    if FDXDraw.D3DDevice7 <> nil then
    begin
      FDXDraw.D3DDevice7.GetCaps(D3DDevDesc7);
      FD3DDevDesc.dpcLineCaps.dwTextureCaps := D3DDevDesc7.dpcLineCaps.dwTextureCaps;
      FD3DDevDesc.dpcTriCaps.dwTextureCaps := D3DDevDesc7.dpcTriCaps.dwTextureCaps;
      FD3DDevDesc.dwMinTextureWidth := D3DDevDesc7.dwMinTextureWidth;
      FD3DDevDesc.dwMaxTextureWidth := D3DDevDesc7.dwMaxTextureWidth;
    end
    else
    begin
      FD3DDevDesc.dwSize := SizeOf(FD3DDevDesc);
      TempD3DDevDesc.dwSize := SizeOf(TempD3DDevDesc);
      FDXDraw.D3DDevice3.GetCaps(FD3DDevDesc, TempD3DDevDesc);
    end;

    if FImage <> nil then
    begin
      {  Size adjustment of texture  }
      if FD3DDevDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_POW2 <> 0 then
      begin
        {  The size of the texture is only Sqr(n).  }
        Width := Max(1 shl GetBitCount(FImage.Width), 1);
        Height := Max(1 shl GetBitCount(FImage.Height), 1);
      end
      else
      begin
        Width := FImage.Width;
        Height := FImage.Height;
      end;

      if FD3DDevDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_SQUAREONLY <> 0 then
      begin
        {  The size of the texture is only a square.  }
        if Width < Height then
          Width := Height;
        Height := Width;
      end;

      if FD3DDevDesc.dwMinTextureWidth > 0 then
        Width := Max(Width, FD3DDevDesc.dwMinTextureWidth);

      if FD3DDevDesc.dwMaxTextureWidth > 0 then
        Width := Min(Width, FD3DDevDesc.dwMaxTextureWidth);

      if FD3DDevDesc.dwMinTextureHeight > 0 then
        Height := Max(Height, FD3DDevDesc.dwMinTextureHeight);

      if FD3DDevDesc.dwMaxTextureHeight > 0 then
        Height := Min(Height, FD3DDevDesc.dwMaxTextureHeight);

      {  Pixel format selection  }
      FEnumTextureFormatFlag := False;
      if FDXDraw.D3DDevice7 <> nil then
        FDXDraw.D3DDevice7.EnumTextureFormats(@EnumTextureFormatCallback, Self)
      else
        FDXDraw.D3DDevice3.EnumTextureFormats(@EnumTextureFormatCallback, Self);

      if not FEnumTextureFormatFlag then
        raise EDirect3DTextureError.CreateFmt(SCannotInitialized, [STexture]);

      {  Is Mipmap surface used ?  }
      FUseMipmap := FMipmap and (FTextureFormat.ddpfPixelFormat.dwRGBBitCount > 8) and
        (FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap] > 0) and (FDXDraw.DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_MIPMAP <> 0);

      {  Surface form setting  }
      with FTextureFormat do
      begin
        dwSize := SizeOf(FTextureFormat);
        dwFlags := DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH or DDSD_PIXELFORMAT;
        ddsCaps.dwCaps := DDSCAPS_TEXTURE;
        ddsCaps.dwCaps2 := 0;
        dwWidth := Width;
        dwHeight := Height;

        if doHardware in FDXDraw.NowOptions then
          ddsCaps.dwCaps2 := ddsCaps.dwCaps2 or DDSCAPS2_TEXTUREMANAGE
        else
          ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY;

        if FUseMipmap then
        begin
          dwFlags := dwFlags or DDSD_MIPMAPCOUNT;
          ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_MIPMAP or DDSCAPS_COMPLEX;
          dwMipMapCount := FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap];
        end;
      end;
    end;

    FSurface := TDirectDrawSurface.Create(FDXDraw.DDraw);
    FSurface.DDraw.DXResult := FSurface.DDraw.IDraw4.CreateSurface(FTextureFormat, TempSurface, nil);
    if FSurface.DDraw.DXResult <> DD_OK then
      raise EDirect3DTextureError.CreateFmt(SCannotInitialized, [STexture]);
    FSurface.IDDSurface4 := TempSurface;

    {  Palette making  }
    if (FImage <> nil) and (FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED <> 0) then
    begin
      if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED8 <> 0 then
        PaletteCaps := DDPCAPS_8BIT or DDPCAPS_ALLOW256
      else if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED4 <> 0 then
        PaletteCaps := DDPCAPS_4BIT
      else if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED2 <> 0 then
        PaletteCaps := DDPCAPS_2BIT
      else if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED1 <> 0 then
        PaletteCaps := DDPCAPS_1BIT
      else
        PaletteCaps := 0;

      if PaletteCaps <> 0 then
      begin
        if FDXDraw.DDraw.IDraw.CreatePalette(PaletteCaps, @FImage.idx_palette, Palette, nil) <> 0 then
          Exit;

        FSurface.ISurface.SetPalette(Palette);
      end;
    end;

    FNeedLoadTexture := True;
  except
    Finalize;
    raise;
  end;
end;

procedure TDirect3DTexture2.Load;
const
  MipmapCaps: TDDSCaps2 = (dwCaps: DDSCAPS_TEXTURE or DDSCAPS_MIPMAP);
var
  CurSurface, NextSurface: IDirectDrawSurface4;
  Index: Integer;
  SrcImage: TDXTextureImage;
begin
  if FSurface = nil then
    Initialize;

  FNeedLoadTexture := False;
  if FSurface.ISurface.IsLost = DDERR_SURFACELOST then
    FSurface.Restore;

  {  Color key setting.  }
  SetColorKey;

  {  Image loading into surface.  }
  if FImage <> nil then
  begin
    if FSrcImage is TDIB then
      SetDIB(TDIB(FSrcImage));

    CurSurface := FSurface.ISurface4;
    Index := 0;
    while CurSurface <> nil do
    begin
      SrcImage := FImage;
      if Index > 0 then
      begin
        if Index - 1 >= FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap] then
          Break;
        SrcImage := FImage.SubGroupImages[DXTextureImageGroupType_Mipmap, Index - 1];
      end;

      LoadSubTexture(CurSurface, SrcImage);

      if CurSurface.GetAttachedSurface(MipmapCaps, NextSurface) = 0 then
        CurSurface := NextSurface
      else
        CurSurface := nil;

      Inc(Index);
    end;
  end
  else
    DoRestoreSurface;
end;

procedure TDirect3DTexture2.SetColorKey;
var
  ck: TDDColorKey;
begin
  FUseColorKey := False;

  if (FSurface <> nil) and FTransparent and (FD3DDevDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_TRANSPARENCY <> 0) then
  begin
    FillChar(ck, SizeOf(ck), 0);
    if FSurface.SurfaceDesc.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED <> 0 then
    begin
      if FTransparentColor shr 24 = $01 then
      begin
        {  Palette index  }
        ck.dwColorSpaceLowValue := FTransparentColor and $FF;
      end
      else if FImage <> nil then
      begin
          {  RGB value  }
        ck.dwColorSpaceLowValue := FImage.PaletteIndex(GetRValue(FTransparentColor), GetGValue(FTransparentColor), GetBValue(FTransparentColor));
      end
      else
        Exit;
    end
    else
    begin
      if (FImage <> nil) and (FImage.ImageType = DXTextureImageType_PaletteIndexedColor) and (FTransparentColor shr 24 = $01) then
      begin
        {  Palette index  }
        ck.dwColorSpaceLowValue :=
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwRBitMask, False), FImage.idx_palette[FTransparentColor and $FF].peRed) or
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwGBitMask, False), FImage.idx_palette[FTransparentColor and $FF].peGreen) or
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwBBitMask, False), FImage.idx_palette[FTransparentColor and $FF].peBlue);
      end
      else if FTransparentColor shr 24 = $00 then
      begin
          {  RGB value  }
        ck.dwColorSpaceLowValue :=
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwRBitMask, False), GetRValue(FTransparentColor)) or
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwGBitMask, False), GetGValue(FTransparentColor)) or
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwBBitMask, False), GetBValue(FTransparentColor));
      end
      else
        Exit;
    end;

    ck.dwColorSpaceHighValue := ck.dwColorSpaceLowValue;
    FSurface.ISurface.SetColorKey(DDCKEY_SRCBLT, @ck);

    FUseColorKey := True;
  end;
end;

procedure TDirect3DTexture2.LoadSubTexture(Dest: IDirectDrawSurface4; SrcImage: TDXTextureImage);
const
  Mask1: array[0..7] of DWORD = (1, 2, 4, 8, 16, 32, 64, 128);
  Mask2: array[0..3] of DWORD = (3, 12, 48, 192);
  Mask4: array[0..1] of DWORD = ($0F, $F0);
  Shift1: array[0..7] of DWORD = (0, 1, 2, 3, 4, 5, 6, 7);
  Shift2: array[0..3] of DWORD = (0, 2, 4, 6);
  Shift4: array[0..1] of DWORD = (0, 4);

  procedure SetPixel(const ddsd: TDDSurfaceDesc2; X, Y: Integer; c: DWORD);
  begin
    case ddsd.ddpfPixelFormat.dwRGBBitCount of
      1: PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X div 8)^ :=
        (PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X div 8)^ and (not Mask1[X mod 8])) or (c shl Shift1[X mod 8]);
      2: PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X div 4)^ :=
        (PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X div 4)^ and (not Mask2[X mod 4])) or (c shl Shift2[X mod 4]);
      4: PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X div 2)^ :=
        (PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X div 2)^ and (not Mask4[X mod 2])) or (c shl Shift4[X mod 2]);
      8: PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X)^ := c;
      16: PWord(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X * 2)^ := c;
      24:
        begin
          PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X * 3)^ := c shr 0;
          PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X * 3 + 1)^ := c shr 8;
          PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X * 3 + 2)^ := c shr 16;
        end;
      32: PDWORD(Integer(ddsd.lpSurface) + ddsd.lPitch * Y + X * 4)^ := c;
    end;
  end;

  procedure LoadTexture_IndexToIndex;
  var
    ddsd: TDDSurfaceDesc2;
    X, Y: Integer;
  begin
    ddsd.dwSize := SizeOf(ddsd);
    if Dest.Lock(nil, ddsd, DDLOCK_WAIT, 0) = 0 then
    begin
      try
        if (SrcImage.idx_index.Mask = DWORD(1 shl ddsd.ddpfPixelFormat.dwRGBBitCount) - 1) and (SrcImage.idx_alpha.Mask = 0) and
          (SrcImage.BitCount = Integer(ddsd.ddpfPixelFormat.dwRGBBitCount)) and (not SrcImage.PackedPixelOrder) then
        begin
          for Y := 0 to ddsd.dwHeight - 1 do
            Move(SrcImage.ScanLine[Y]^, Pointer(Integer(ddsd.lpSurface) + ddsd.lPitch * Y)^, (Integer(ddsd.dwWidth) * SrcImage.BitCount + 7) div 8);
        end
        else
        begin
          for Y := 0 to ddsd.dwHeight - 1 do
          begin
            for X := 0 to ddsd.dwWidth - 1 do
              SetPixel(ddsd, X, Y, dxtDecodeChannel(SrcImage.idx_index, SrcImage.Pixels[X, Y]));
          end;
        end;
      finally
        Dest.UnLock(ddsd.lpSurface);
      end;
    end;
  end;

  procedure LoadTexture_IndexToRGB;
  var
    ddsd: TDDSurfaceDesc2;
    X, Y: Integer;
    c, cIdx, cA: DWORD;
    dest_red_fmt, dest_green_fmt, dest_blue_fmt, dest_alpha_fmt: TDXTextureImageChannel;
  begin
    ddsd.dwSize := SizeOf(ddsd);
    if Dest.Lock(nil, ddsd, DDLOCK_WAIT, 0) = 0 then
    begin
      try
        dest_red_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRBitMask, False);
        dest_green_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwGBitMask, False);
        dest_blue_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwBBitMask, False);
        dest_alpha_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRGBAlphaBitMask, False);

        if SrcImage.idx_alpha.Mask <> 0 then
        begin
          for Y := 0 to ddsd.dwHeight - 1 do
            for X := 0 to ddsd.dwWidth - 1 do
            begin
              c := SrcImage.Pixels[X, Y];
              cIdx := dxtDecodeChannel(SrcImage.idx_index, c);

              c := dxtEncodeChannel(dest_red_fmt, SrcImage.idx_palette[cIdx].peRed) or
                dxtEncodeChannel(dest_green_fmt, SrcImage.idx_palette[cIdx].peGreen) or
                dxtEncodeChannel(dest_blue_fmt, SrcImage.idx_palette[cIdx].peBlue) or
                dxtEncodeChannel(dest_alpha_fmt, dxtDecodeChannel(SrcImage.idx_alpha, c));

              SetPixel(ddsd, X, Y, c);
            end;
        end
        else
        begin
          cA := dxtEncodeChannel(dest_alpha_fmt, 255);

          for Y := 0 to ddsd.dwHeight - 1 do
            for X := 0 to ddsd.dwWidth - 1 do
            begin
              c := SrcImage.Pixels[X, Y];
              cIdx := dxtDecodeChannel(SrcImage.idx_index, c);

              c := dxtEncodeChannel(dest_red_fmt, SrcImage.idx_palette[cIdx].peRed) or
                dxtEncodeChannel(dest_green_fmt, SrcImage.idx_palette[cIdx].peGreen) or
                dxtEncodeChannel(dest_blue_fmt, SrcImage.idx_palette[cIdx].peBlue) or cA;

              SetPixel(ddsd, X, Y, c);
            end;
        end;
      finally
        Dest.UnLock(ddsd.lpSurface);
      end;
    end;
  end;

  procedure LoadTexture_RGBToRGB;
  var
    ddsd: TDDSurfaceDesc2;
    X, Y: Integer;
    c, cA: DWORD;
    dest_red_fmt, dest_green_fmt, dest_blue_fmt, dest_alpha_fmt: TDXTextureImageChannel;
  begin
    ddsd.dwSize := SizeOf(ddsd);
    if Dest.Lock(nil, ddsd, DDLOCK_WAIT, 0) = 0 then
    begin
      try
        dest_red_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRBitMask, False);
        dest_green_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwGBitMask, False);
        dest_blue_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwBBitMask, False);
        dest_alpha_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRGBAlphaBitMask, False);

        if (dest_red_fmt.Mask = SrcImage.rgb_red.Mask) and (dest_green_fmt.Mask = SrcImage.rgb_green.Mask) and
          (dest_blue_fmt.Mask = SrcImage.rgb_blue.Mask) and (dest_alpha_fmt.Mask = SrcImage.rgb_alpha.Mask) and
          (Integer(ddsd.ddpfPixelFormat.dwRGBBitCount) = SrcImage.BitCount) and (not SrcImage.PackedPixelOrder) then
        begin
          for Y := 0 to ddsd.dwHeight - 1 do
            Move(SrcImage.ScanLine[Y]^, Pointer(Integer(ddsd.lpSurface) + ddsd.lPitch * Y)^, (Integer(ddsd.dwWidth) * SrcImage.BitCount + 7) div 8);
        end
        else if SrcImage.rgb_alpha.Mask <> 0 then
        begin
          for Y := 0 to ddsd.dwHeight - 1 do
            for X := 0 to ddsd.dwWidth - 1 do
            begin
              c := SrcImage.Pixels[X, Y];

              c := dxtEncodeChannel(dest_red_fmt, dxtDecodeChannel(SrcImage.rgb_red, c)) or
                dxtEncodeChannel(dest_green_fmt, dxtDecodeChannel(SrcImage.rgb_green, c)) or
                dxtEncodeChannel(dest_blue_fmt, dxtDecodeChannel(SrcImage.rgb_blue, c)) or
                dxtEncodeChannel(dest_alpha_fmt, dxtDecodeChannel(SrcImage.rgb_alpha, c));

              SetPixel(ddsd, X, Y, c);
            end;
        end
        else
        begin
          cA := dxtEncodeChannel(dest_alpha_fmt, 255);

          for Y := 0 to ddsd.dwHeight - 1 do
            for X := 0 to ddsd.dwWidth - 1 do
            begin
              c := SrcImage.Pixels[X, Y];

              c := dxtEncodeChannel(dest_red_fmt, dxtDecodeChannel(SrcImage.rgb_red, c)) or
                dxtEncodeChannel(dest_green_fmt, dxtDecodeChannel(SrcImage.rgb_green, c)) or
                dxtEncodeChannel(dest_blue_fmt, dxtDecodeChannel(SrcImage.rgb_blue, c)) or cA;

              SetPixel(ddsd, X, Y, c);
            end;
        end;
      finally
        Dest.UnLock(ddsd.lpSurface);
      end;
    end;
  end;

var
  SurfaceDesc: TDDSurfaceDesc2;
begin
  SurfaceDesc.dwSize := SizeOf(SurfaceDesc);
  Dest.GetSurfaceDesc(SurfaceDesc);

  if SurfaceDesc.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED <> 0 then
  begin
    case SrcImage.ImageType of
      DXTextureImageType_PaletteIndexedColor: LoadTexture_IndexToIndex;
      DXTextureImageType_RGBColor: ;
    end;
  end
  else if SurfaceDesc.ddpfPixelFormat.dwFlags and DDPF_RGB <> 0 then
  begin
    case SrcImage.ImageType of
      DXTextureImageType_PaletteIndexedColor: LoadTexture_IndexToRGB;
      DXTextureImageType_RGBColor: LoadTexture_RGBToRGB;
    end;
  end;
end;

{ Support function }

function GetWidthBytes(Width, BitCount: Integer): Integer;
begin
  Result := (((Width * BitCount) + 31) div 32) * 4;
end;

function dxtEncodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;
begin
  Result := ((c shl Channel._rshift) shr Channel._lshift) and Channel.Mask;
end;

function dxtDecodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;
begin
  Result := ((c and Channel.Mask) shr Channel._rshift) shl Channel._lshift;
  Result := Result or (Result shr Channel._BitCount2);
end;

function dxtMakeChannel(Mask: DWORD; indexed: Boolean): TDXTextureImageChannel;

  function GetMaskBitCount(B: Integer): Integer;
  var
    i: Integer;
  begin
    i := 0;
    while (i < 31) and (((1 shl i) and B) = 0) do
      Inc(i);

    Result := 0;
    while ((1 shl i) and B) <> 0 do
    begin
      Inc(i);
      Inc(Result);
    end;
  end;

  function GetBitCount2(B: Integer): Integer;
  begin
    Result := 0;
    while (Result < 31) and (((1 shl Result) and B) = 0) do
      Inc(Result);
  end;

begin
  Result.BitCount := GetMaskBitCount(Mask);
  Result.Mask := Mask;

  if indexed then
  begin
    Result._rshift := GetBitCount2(Mask);
    Result._lshift := 0;
    Result._Mask2 := 1 shl Result.BitCount - 1;
    Result._BitCount2 := 0;
  end
  else
  begin
    Result._rshift := GetBitCount2(Mask) - (8 - Result.BitCount);
    if Result._rshift < 0 then
    begin
      Result._lshift := -Result._rshift;
      Result._rshift := 0;
    end
    else
      Result._lshift := 0;
    Result._Mask2 := (1 shl Result.BitCount - 1) shl (8 - Result.BitCount);
    Result._BitCount2 := 8 - Result.BitCount;
  end;
end;

{  TDXTextureImage  }

var
  _DXTextureImageLoadFuncList: TList;

procedure DXTextureImage_LoadDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage); forward;
procedure DXTextureImage_LoadBitmapFunc(Stream: TStream; Image: TDXTextureImage); forward;

function DXTextureImageLoadFuncList: TList;
begin
  if _DXTextureImageLoadFuncList = nil then
  begin
    _DXTextureImageLoadFuncList := TList.Create;
    _DXTextureImageLoadFuncList.Add(@DXTextureImage_LoadDXTextureImageFunc);
    _DXTextureImageLoadFuncList.Add(@DXTextureImage_LoadBitmapFunc);
  end;
  Result := _DXTextureImageLoadFuncList;
end;

class procedure TDXTextureImage.RegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
begin
  if DXTextureImageLoadFuncList.IndexOf(@LoadFunc) = -1 then
    DXTextureImageLoadFuncList.Add(@LoadFunc);
end;

class procedure TDXTextureImage.UnRegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
begin
  DXTextureImageLoadFuncList.Remove(@LoadFunc);
end;

constructor TDXTextureImage.Create;
begin
  inherited Create;
  FSubImage := TList.Create;
end;

constructor TDXTextureImage.CreateSub(AOwner: TDXTextureImage);
begin
  Create;

  FOwner := AOwner;
  try
    FOwner.FSubImage.Add(Self);
  except
    FOwner := nil;
    raise;
  end;
end;

destructor TDXTextureImage.Destroy;
begin
  Clear;
  FSubImage.Free;
  if FOwner <> nil then
    FOwner.FSubImage.Remove(Self);
  inherited Destroy;
end;

procedure TDXTextureImage.DoSaveProgress(Progress, ProgressCount: Integer);
begin
  if Assigned(FOnSaveProgress) then
    FOnSaveProgress(Self, Progress, ProgressCount);
end;

procedure TDXTextureImage.Assign(Source: TDXTextureImage);
var
  Y: Integer;
begin
  SetSize(Source.ImageType, Source.Width, Source.Height, Source.BitCount, Source.WidthBytes);

  idx_index := Source.idx_index;
  idx_alpha := Source.idx_alpha;
  idx_palette := Source.idx_palette;

  rgb_red := Source.rgb_red;
  rgb_green := Source.rgb_green;
  rgb_blue := Source.rgb_blue;
  rgb_alpha := Source.rgb_alpha;

  for Y := 0 to Height - 1 do
    Move(Source.ScanLine[Y]^, ScanLine[Y]^, WidthBytes);

  Transparent := Source.Transparent;
  TransparentColor := Source.TransparentColor;
  ImageGroupType := Source.ImageGroupType;
  ImageID := Source.ImageID;
  ImageName := Source.ImageName;
end;

procedure TDXTextureImage.ClearImage;
begin
  if FAutoFreeImage then
    FreeMem(FPBits);

  FImageType := DXTextureImageType_PaletteIndexedColor;
  FWidth := 0;
  FHeight := 0;
  FBitCount := 0;
  FWidthBytes := 0;
  FNextLine := 0;
  FSize := 0;
  FPBits := nil;
  FTopPBits := nil;
  FAutoFreeImage := False;
end;

procedure TDXTextureImage.Clear;
begin
  ClearImage;

  while SubImageCount > 0 do
    SubImages[SubImageCount - 1].Free;

  FImageGroupType := 0;
  FImageID := 0;
  FImageName := '';

  FTransparent := False;
  FTransparentColor := 0;

  FillChar(idx_index, SizeOf(idx_index), 0);
  FillChar(idx_alpha, SizeOf(idx_alpha), 0);
  FillChar(idx_palette, SizeOf(idx_palette), 0);
  FillChar(rgb_red, SizeOf(rgb_red), 0);
  FillChar(rgb_green, SizeOf(rgb_green), 0);
  FillChar(rgb_blue, SizeOf(rgb_blue), 0);
  FillChar(rgb_alpha, SizeOf(rgb_alpha), 0);
end;

procedure TDXTextureImage.SetImage(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes, NextLine: Integer;
  PBits, TopPBits: Pointer; Size: Integer; AutoFree: Boolean);
begin
  ClearImage;

  FAutoFreeImage := AutoFree;
  FImageType := ImageType;
  FWidth := Width;
  FHeight := Height;
  FBitCount := BitCount;
  FWidthBytes := WidthBytes;
  FNextLine := NextLine;
  FSize := Size;
  FPBits := PBits;
  FTopPBits := TopPBits;
end;

procedure TDXTextureImage.SetSize(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes: Integer);
var
  APBits: Pointer;
begin
  ClearImage;

  if WidthBytes = 0 then
    WidthBytes := GetWidthBytes(Width, BitCount);

  GetMem(APBits, WidthBytes * Height);
  SetImage(ImageType, Width, Height, BitCount, WidthBytes,
    WidthBytes, APBits, APBits, WidthBytes * Height, True);
end;

function TDXTextureImage.GetScanLine(Y: Integer): Pointer;
begin
  Result := Pointer(Integer(FTopPBits) + FNextLine * Y);
end;

function TDXTextureImage.GetSubGroupImageCount(GroupTypeID: DWORD): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to SubImageCount - 1 do
    if SubImages[i].ImageGroupType = GroupTypeID then
      Inc(Result);
end;

function TDXTextureImage.GetSubGroupImage(GroupTypeID: DWORD; Index: Integer): TDXTextureImage;
var
  i, j: Integer;
begin
  j := 0;
  for i := 0 to SubImageCount - 1 do
    if SubImages[i].ImageGroupType = GroupTypeID then
    begin
      if j = Index then
      begin
        Result := SubImages[i];
        Exit;
      end;

      Inc(j);
    end;

  Result := nil;
  SubImages[-1];
end;

function TDXTextureImage.GetSubImageCount: Integer;
begin
  Result := FSubImage.Count;
end;

function TDXTextureImage.GetSubImage(Index: Integer): TDXTextureImage;
begin
  Result := FSubImage[Index];
end;

function TDXTextureImage.EncodeColor(R, G, B, A: Byte): DWORD;
begin
  if ImageType = DXTextureImageType_PaletteIndexedColor then
  begin
    Result := dxtEncodeChannel(idx_index, PaletteIndex(R, G, B)) or
      dxtEncodeChannel(idx_alpha, A);
  end
  else
  begin
    Result := dxtEncodeChannel(rgb_red, R) or
      dxtEncodeChannel(rgb_green, G) or
      dxtEncodeChannel(rgb_blue, B) or
      dxtEncodeChannel(rgb_alpha, A);
  end;
end;

function TDXTextureImage.PaletteIndex(R, G, B: Byte): DWORD;
var
  i, d, d2: Integer;
begin
  Result := 0;
  if ImageType = DXTextureImageType_PaletteIndexedColor then
  begin
    d := MaxInt;
    for i := 0 to (1 shl idx_index.BitCount) - 1 do
      with idx_palette[i] do
      begin
        d2 := Abs((peRed - R)) * Abs((peRed - R)) + Abs((peGreen - G)) * Abs((peGreen - G)) + Abs((peBlue - B)) * Abs((peBlue - B));
        if d > d2 then
        begin
          d := d2;
          Result := i;
        end;
      end;
  end;
end;

const
  Mask1: array[0..7] of DWORD = (1, 2, 4, 8, 16, 32, 64, 128);
  Mask2: array[0..3] of DWORD = (3, 12, 48, 192);
  Mask4: array[0..1] of DWORD = ($0F, $F0);

  Shift1: array[0..7] of DWORD = (0, 1, 2, 3, 4, 5, 6, 7);
  Shift2: array[0..3] of DWORD = (0, 2, 4, 6);
  Shift4: array[0..1] of DWORD = (0, 4);

type
  PByte3 = ^TByte3;
  TByte3 = array[0..2] of Byte;

function TDXTextureImage.GetPixel(X, Y: Integer): DWORD;
begin
  Result := 0;
  if (X >= 0) and (X < FWidth) and (Y >= 0) and (Y < FHeight) then
  begin
    case FBitCount of
      1:
        begin
          if FPackedPixelOrder then
            Result := (PByte(Integer(FTopPBits) + FNextLine * Y + X shr 3)^ and Mask1[7 - X and 7]) shr Shift1[7 - X and 7]
          else
            Result := (PByte(Integer(FTopPBits) + FNextLine * Y + X shr 3)^ and Mask1[X and 7]) shr Shift1[X and 7];
        end;
      2:
        begin
          if FPackedPixelOrder then
            Result := (PByte(Integer(FTopPBits) + FNextLine * Y + X shr 2)^ and Mask2[3 - X and 3]) shr Shift2[3 - X and 3]
          else
            Result := (PByte(Integer(FTopPBits) + FNextLine * Y + X shr 2)^ and Mask2[X and 3]) shr Shift2[X and 3];
        end;
      4:
        begin
          if FPackedPixelOrder then
            Result := (PByte(Integer(FTopPBits) + FNextLine * Y + X shr 1)^ and Mask4[1 - X and 1]) shr Shift4[1 - X and 1]
          else
            Result := (PByte(Integer(FTopPBits) + FNextLine * Y + X shr 1)^ and Mask4[X and 1]) shr Shift4[X and 1];
        end;
      8: Result := PByte(Integer(FTopPBits) + FNextLine * Y + X)^;
      16: Result := PWord(Integer(FTopPBits) + FNextLine * Y + X * 2)^;
      24: PByte3(@Result)^ := PByte3(Integer(FTopPBits) + FNextLine * Y + X * 3)^;
      32: Result := PDWORD(Integer(FTopPBits) + FNextLine * Y + X * 4)^;
    end;
  end;
end;

procedure TDXTextureImage.SetPixel(X, Y: Integer; c: DWORD);
var
  P: PByte;
begin
  if (X >= 0) and (X < FWidth) and (Y >= 0) and (Y < FHeight) then
  begin
    case FBitCount of
      1:
        begin
          P := Pointer(Integer(FTopPBits) + FNextLine * Y + X shr 3);
          if FPackedPixelOrder then
            P^ := (P^ and (not Mask1[7 - X and 7])) or ((c and 1) shl Shift1[7 - X and 7])
          else
            P^ := (P^ and (not Mask1[X and 7])) or ((c and 1) shl Shift1[X and 7]);
        end;
      2:
        begin
          P := Pointer(Integer(FTopPBits) + FNextLine * Y + X shr 2);
          if FPackedPixelOrder then
            P^ := (P^ and (not Mask2[3 - X and 3])) or ((c and 3) shl Shift2[3 - X and 3])
          else
            P^ := (P^ and (not Mask2[X and 3])) or ((c and 3) shl Shift2[X and 3]);
        end;
      4:
        begin
          P := Pointer(Integer(FTopPBits) + FNextLine * Y + X shr 1);
          if FPackedPixelOrder then
            P^ := (P^ and (not Mask4[1 - X and 1])) or ((c and 7) shl Shift4[1 - X and 1])
          else
            P^ := (P^ and (not Mask4[X and 1])) or ((c and 7) shl Shift4[X and 1]);
        end;
      8: PByte(Integer(FTopPBits) + FNextLine * Y + X)^ := c;
      16: PWord(Integer(FTopPBits) + FNextLine * Y + X * 2)^ := c;
      24: PByte3(Integer(FTopPBits) + FNextLine * Y + X * 3)^ := PByte3(@c)^;
      32: PDWORD(Integer(FTopPBits) + FNextLine * Y + X * 4)^ := c;
    end;
  end;
end;

procedure TDXTextureImage.LoadFromFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TDXTextureImage.LoadFromStream(Stream: TStream);
var
  i, P: Integer;
begin
  Clear;

  P := Stream.Position;
  for i := 0 to DXTextureImageLoadFuncList.Count - 1 do
  begin
    Stream.Position := P;
    try
      TDXTextureImageLoadFunc(DXTextureImageLoadFuncList[i])(Stream, Self);
      Exit;
    except
      Clear;
    end;
  end;

  raise EDXTextureImageError.Create(SNotSupportGraphicFile);
end;

procedure TDXTextureImage.SaveToFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure DXTextureImage_SaveDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage); forward;

procedure TDXTextureImage.SaveToStream(Stream: TStream);
begin
  DXTextureImage_SaveDXTextureImageFunc(Stream, Self);
end;

{  DXTextureImage_LoadDXTextureImageFunc  }

const
  DXTextureImageFile_Type = 'dxt:';
  DXTextureImageFile_Version = $100;

  DXTextureImageCompress_None = 0;
  DXTextureImageCompress_ZLIB = 1; // ZLIB enabled

  DXTextureImageFileCategoryType_Image = $100;

  DXTextureImageFileBlockID_EndFile = 0;
  DXTextureImageFileBlockID_EndGroup = 1;
  DXTextureImageFileBlockID_StartGroup = 2;
  DXTextureImageFileBlockID_Image_Format = DXTextureImageFileCategoryType_Image + 1;
  DXTextureImageFileBlockID_Image_PixelData = DXTextureImageFileCategoryType_Image + 2;
  DXTextureImageFileBlockID_Image_GroupInfo = DXTextureImageFileCategoryType_Image + 3;
  DXTextureImageFileBlockID_Image_Name = DXTextureImageFileCategoryType_Image + 4;
  DXTextureImageFileBlockID_Image_TransparentColor = DXTextureImageFileCategoryType_Image + 5;

type
  TDXTextureImageFileHeader = packed record
    FileType: array[0..4] of Char;
    ver: DWORD;
  end;

  TDXTextureImageFileBlockHeader = packed record
    ID: DWORD;
    Size: Integer;
  end;

  TDXTextureImageFileBlockHeader_StartGroup = packed record
    CategoryType: DWORD;
  end;

  TDXTextureImageHeader_Image_Format = packed record
    ImageType: TDXTextureImageType;
    Width: DWORD;
    Height: DWORD;
    BitCount: DWORD;
    WidthBytes: DWORD;
  end;

  TDXTextureImageHeader_Image_Format_Index = packed record
    idx_index_Mask: DWORD;
    idx_alpha_Mask: DWORD;
    idx_palette: array[0..255] of TPaletteEntry;
  end;

  TDXTextureImageHeader_Image_Format_RGB = packed record
    rgb_red_Mask: DWORD;
    rgb_green_Mask: DWORD;
    rgb_blue_Mask: DWORD;
    rgb_alpha_Mask: DWORD;
  end;

  TDXTextureImageHeader_Image_GroupInfo = packed record
    ImageGroupType: DWORD;
    ImageID: DWORD;
  end;

  TDXTextureImageHeader_Image_PixelData = packed record
    Compress: DWORD;
  end;

  TDXTextureImageHeader_Image_TransparentColor = packed record
    Transparent: Boolean;
    TransparentColor: DWORD;
  end;

procedure DXTextureImage_LoadDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage);

  procedure ReadGroup_Image(Image: TDXTextureImage);
  var
    i: Integer;
    BlockHeader: TDXTextureImageFileBlockHeader;
    NextPos: Integer;
    SubImage: TDXTextureImage;
    Header_StartGroup: TDXTextureImageFileBlockHeader_StartGroup;
    Header_Image_Format: TDXTextureImageHeader_Image_Format;
    Header_Image_Format_Index: TDXTextureImageHeader_Image_Format_Index;
    Header_Image_Format_RGB: TDXTextureImageHeader_Image_Format_RGB;
    Header_Image_GroupInfo: TDXTextureImageHeader_Image_GroupInfo;
    Header_Image_TransparentColor: TDXTextureImageHeader_Image_TransparentColor;
    Header_Image_PixelData: TDXTextureImageHeader_Image_PixelData;
    ImageName: string;
  {$IFDEF DXTextureImage_UseZLIB}
    Decompression: TDecompressionStream;
  {$ENDIF}
  begin
    while True do
    begin
      Stream.ReadBuffer(BlockHeader, SizeOf(BlockHeader));
      NextPos := Stream.Position + BlockHeader.Size;

      case BlockHeader.ID of
        DXTextureImageFileBlockID_EndGroup:
          begin
            {  End of group  }
            Break;
          end;
        DXTextureImageFileBlockID_StartGroup:
          begin
            {  Beginning of group  }
            Stream.ReadBuffer(Header_StartGroup, SizeOf(Header_StartGroup));
            case Header_StartGroup.CategoryType of
              DXTextureImageFileCategoryType_Image:
                begin
                  {  Image group  }
                  SubImage := TDXTextureImage.CreateSub(Image);
                  try
                    ReadGroup_Image(SubImage);
                  except
                    SubImage.Free;
                    raise;
                  end;
                end;
            end;
          end;
        DXTextureImageFileBlockID_Image_Format:
          begin
            {  Image information reading (size etc.)  }
            Stream.ReadBuffer(Header_Image_Format, SizeOf(Header_Image_Format));

            if (Header_Image_Format.ImageType <> DXTextureImageType_PaletteIndexedColor) and
              (Header_Image_Format.ImageType <> DXTextureImageType_RGBColor) then
              raise EDXTextureImageError.Create(SInvalidDXTFile);

            Image.SetSize(Header_Image_Format.ImageType, Header_Image_Format.Width, Header_Image_Format.Height,
              Header_Image_Format.BitCount, Header_Image_Format.WidthBytes);

            if Header_Image_Format.ImageType = DXTextureImageType_PaletteIndexedColor then
            begin
              {  INDEX IMAGE  }
              Stream.ReadBuffer(Header_Image_Format_Index, SizeOf(Header_Image_Format_Index));

              Image.idx_index := dxtMakeChannel(Header_Image_Format_Index.idx_index_Mask, True);
              Image.idx_alpha := dxtMakeChannel(Header_Image_Format_Index.idx_alpha_Mask, False);

              for i := 0 to 255 do
                Image.idx_palette[i] := Header_Image_Format_Index.idx_palette[i];
            end
            else if Header_Image_Format.ImageType = DXTextureImageType_RGBColor then
            begin
              {  RGB IMAGE  }
              Stream.ReadBuffer(Header_Image_Format_RGB, SizeOf(Header_Image_Format_RGB));

              Image.rgb_red := dxtMakeChannel(Header_Image_Format_RGB.rgb_red_Mask, False);
              Image.rgb_green := dxtMakeChannel(Header_Image_Format_RGB.rgb_green_Mask, False);
              Image.rgb_blue := dxtMakeChannel(Header_Image_Format_RGB.rgb_blue_Mask, False);
              Image.rgb_alpha := dxtMakeChannel(Header_Image_Format_RGB.rgb_alpha_Mask, False);
            end;
          end;
        DXTextureImageFileBlockID_Image_Name:
          begin
            {  Name reading  }
            SetLength(ImageName, BlockHeader.Size);
            Stream.ReadBuffer(ImageName[1], BlockHeader.Size);

            Image.ImageName := ImageName;
          end;
        DXTextureImageFileBlockID_Image_GroupInfo:
          begin
            {  Image group information reading  }
            Stream.ReadBuffer(Header_Image_GroupInfo, SizeOf(Header_Image_GroupInfo));

            Image.ImageGroupType := Header_Image_GroupInfo.ImageGroupType;
            Image.ImageID := Header_Image_GroupInfo.ImageID;
          end;
        DXTextureImageFileBlockID_Image_TransparentColor:
          begin
            {  Transparent color information reading  }
            Stream.ReadBuffer(Header_Image_TransparentColor, SizeOf(Header_Image_TransparentColor));

            Image.Transparent := Header_Image_TransparentColor.Transparent;
            Image.TransparentColor := Header_Image_TransparentColor.TransparentColor;
          end;
        DXTextureImageFileBlockID_Image_PixelData:
          begin
            {  Pixel data reading  }
            Stream.ReadBuffer(Header_Image_PixelData, SizeOf(Header_Image_PixelData));

            case Header_Image_PixelData.Compress of
              DXTextureImageCompress_None:
                begin
                  {  NO compress  }
                  for i := 0 to Image.Height - 1 do
                    Stream.ReadBuffer(Image.ScanLine[i]^, Header_Image_Format.WidthBytes);
                end;
{$IFDEF DXTextureImage_UseZLIB}
              DXTextureImageCompress_ZLIB:
                begin
                  {  ZLIB compress enabled  }
                  Decompression := TDecompressionStream.Create(Stream);
                  try
                    for i := 0 to Image.Height - 1 do
                      Decompression.ReadBuffer(Image.ScanLine[i]^, Header_Image_Format.WidthBytes);
                  finally
                    Decompression.Free;
                  end;
                end;
{$ENDIF}
            else
              raise EDXTextureImageError.CreateFmt('Decompression error (%d)', [Header_Image_PixelData.Compress]);
            end;
          end;

      end;

      Stream.Seek(NextPos, soFromBeginning);
    end;
  end;

var
  FileHeader: TDXTextureImageFileHeader;
  BlockHeader: TDXTextureImageFileBlockHeader;
  Header_StartGroup: TDXTextureImageFileBlockHeader_StartGroup;
  NextPos: Integer;
begin
  {  File header reading  }
  Stream.ReadBuffer(FileHeader, SizeOf(FileHeader));

  if FileHeader.FileType <> DXTextureImageFile_Type then
    raise EDXTextureImageError.Create(SInvalidDXTFile);
  if FileHeader.ver <> DXTextureImageFile_Version then
    raise EDXTextureImageError.Create(SInvalidDXTFile);

  while True do
  begin
    Stream.ReadBuffer(BlockHeader, SizeOf(BlockHeader));
    NextPos := Stream.Position + BlockHeader.Size;

    case BlockHeader.ID of
      DXTextureImageFileBlockID_EndFile:
        begin
          {  End of file  }
          Break;
        end;
      DXTextureImageFileBlockID_StartGroup:
        begin
          {  Beginning of group  }
          Stream.ReadBuffer(Header_StartGroup, SizeOf(Header_StartGroup));
          case Header_StartGroup.CategoryType of
            DXTextureImageFileCategoryType_Image: ReadGroup_Image(Image);
          end;
        end;
    end;

    Stream.Seek(NextPos, soFromBeginning);
  end;
end;

type
  PDXTextureImageFileBlockHeaderWriter_BlockInfo = ^TDXTextureImageFileBlockHeaderWriter_BlockInfo;
  TDXTextureImageFileBlockHeaderWriter_BlockInfo = record
    BlockID: DWORD;
    StreamPos: Integer;
  end;

  TDXTextureImageFileBlockHeaderWriter = class
  private
    FStream: TStream;
    FList: TList;
  public
    constructor Create(Stream: TStream);
    destructor Destroy; override;
    procedure StartBlock(BlockID: DWORD);
    procedure EndBlock;
    procedure WriteBlock(BlockID: DWORD);
    procedure StartGroup(CategoryType: DWORD);
    procedure EndGroup;
  end;

constructor TDXTextureImageFileBlockHeaderWriter.Create(Stream: TStream);
begin
  inherited Create;
  FStream := Stream;
  FList := TList.Create;
end;

destructor TDXTextureImageFileBlockHeaderWriter.Destroy;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    Dispose(PDXTextureImageFileBlockHeaderWriter_BlockInfo(FList[i]));
  FList.Free;
  inherited Destroy;
end;

procedure TDXTextureImageFileBlockHeaderWriter.StartBlock(BlockID: DWORD);
var
  BlockInfo: PDXTextureImageFileBlockHeaderWriter_BlockInfo;
  BlockHeader: TDXTextureImageFileBlockHeader;
begin
  New(BlockInfo);
  BlockInfo.BlockID := BlockID;
  BlockInfo.StreamPos := FStream.Position;
  FList.Add(BlockInfo);

  BlockHeader.ID := BlockID;
  BlockHeader.Size := 0;
  FStream.WriteBuffer(BlockHeader, SizeOf(BlockHeader));
end;

procedure TDXTextureImageFileBlockHeaderWriter.EndBlock;
var
  BlockHeader: TDXTextureImageFileBlockHeader;
  BlockInfo: PDXTextureImageFileBlockHeaderWriter_BlockInfo;
  CurStreamPos: Integer;
begin
  CurStreamPos := FStream.Position;
  try
    BlockInfo := FList[FList.Count - 1];

    FStream.Position := BlockInfo.StreamPos;
    BlockHeader.ID := BlockInfo.BlockID;
    BlockHeader.Size := CurStreamPos - (BlockInfo.StreamPos + SizeOf(TDXTextureImageFileBlockHeader));
    FStream.WriteBuffer(BlockHeader, SizeOf(BlockHeader));
  finally
    FStream.Position := CurStreamPos;

    Dispose(FList[FList.Count - 1]);
    FList.Count := FList.Count - 1;
  end;
end;

procedure TDXTextureImageFileBlockHeaderWriter.WriteBlock(BlockID: DWORD);
var
  BlockHeader: TDXTextureImageFileBlockHeader;
begin
  BlockHeader.ID := BlockID;
  BlockHeader.Size := 0;
  FStream.WriteBuffer(BlockHeader, SizeOf(BlockHeader));
end;

procedure TDXTextureImageFileBlockHeaderWriter.StartGroup(CategoryType: DWORD);
var
  Header_StartGroup: TDXTextureImageFileBlockHeader_StartGroup;
begin
  StartBlock(DXTextureImageFileBlockID_StartGroup);

  Header_StartGroup.CategoryType := CategoryType;
  FStream.WriteBuffer(Header_StartGroup, SizeOf(Header_StartGroup));
end;

procedure TDXTextureImageFileBlockHeaderWriter.EndGroup;
begin
  WriteBlock(DXTextureImageFileBlockID_EndGroup);
  EndBlock;
end;

procedure DXTextureImage_SaveDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage);
var
  Progress: Integer;
  ProgressCount: Integer;
  BlockHeaderWriter: TDXTextureImageFileBlockHeaderWriter;

  function CalcProgressCount(Image: TDXTextureImage): Integer;
  var
    i: Integer;
  begin
    Result := Image.WidthBytes * Image.Height;
    for i := 0 to Image.SubImageCount - 1 do
      Inc(Result, CalcProgressCount(Image.SubImages[i]));
  end;

  procedure AddProgress(Count: Integer);
  begin
    Inc(Progress, Count);
    Image.DoSaveProgress(Progress, ProgressCount);
  end;

  procedure WriteGroup_Image(Image: TDXTextureImage);
  var
    i: Integer;
    Header_Image_Format: TDXTextureImageHeader_Image_Format;
    Header_Image_Format_Index: TDXTextureImageHeader_Image_Format_Index;
    Header_Image_Format_RGB: TDXTextureImageHeader_Image_Format_RGB;
    Header_Image_GroupInfo: TDXTextureImageHeader_Image_GroupInfo;
    Header_Image_TransparentColor: TDXTextureImageHeader_Image_TransparentColor;
    Header_Image_PixelData: TDXTextureImageHeader_Image_PixelData;
  {$IFDEF DXTextureImage_UseZLIB}
    Compression: TCompressionStream;
  {$ENDIF}
  begin
    BlockHeaderWriter.StartGroup(DXTextureImageFileCategoryType_Image);
    try
      {  Image format writing  }
      if Image.Size > 0 then
      begin
        Header_Image_Format.ImageType := Image.ImageType;
        Header_Image_Format.Width := Image.Width;
        Header_Image_Format.Height := Image.Height;
        Header_Image_Format.BitCount := Image.BitCount;
        Header_Image_Format.WidthBytes := Image.WidthBytes;

        BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_Format);
        try
          Stream.WriteBuffer(Header_Image_Format, SizeOf(Header_Image_Format));

          case Image.ImageType of
            DXTextureImageType_PaletteIndexedColor:
              begin
                {  INDEX IMAGE  }
                Header_Image_Format_Index.idx_index_Mask := Image.idx_index.Mask;
                Header_Image_Format_Index.idx_alpha_Mask := Image.idx_alpha.Mask;
                for i := 0 to 255 do
                  Header_Image_Format_Index.idx_palette[i] := Image.idx_palette[i];

                Stream.WriteBuffer(Header_Image_Format_Index, SizeOf(Header_Image_Format_Index));
              end;
            DXTextureImageType_RGBColor:
              begin
                {  RGB IMAGE  }
                Header_Image_Format_RGB.rgb_red_Mask := Image.rgb_red.Mask;
                Header_Image_Format_RGB.rgb_green_Mask := Image.rgb_green.Mask;
                Header_Image_Format_RGB.rgb_blue_Mask := Image.rgb_blue.Mask;
                Header_Image_Format_RGB.rgb_alpha_Mask := Image.rgb_alpha.Mask;

                Stream.WriteBuffer(Header_Image_Format_RGB, SizeOf(Header_Image_Format_RGB));
              end;
          end;
        finally
          BlockHeaderWriter.EndBlock;
        end;
      end;

      {  Image group information writing  }
      BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_GroupInfo);
      try
        Header_Image_GroupInfo.ImageGroupType := Image.ImageGroupType;
        Header_Image_GroupInfo.ImageID := Image.ImageID;

        Stream.WriteBuffer(Header_Image_GroupInfo, SizeOf(Header_Image_GroupInfo));
      finally
        BlockHeaderWriter.EndBlock;
      end;

      {  Name writing  }
      BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_Name);
      try
        Stream.WriteBuffer(Image.ImageName[1], Length(Image.ImageName));
      finally
        BlockHeaderWriter.EndBlock;
      end;

      {  Transparent color writing  }
      BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_TransparentColor);
      try
        Header_Image_TransparentColor.Transparent := Image.Transparent;
        Header_Image_TransparentColor.TransparentColor := Image.TransparentColor;

        Stream.WriteBuffer(Header_Image_TransparentColor, SizeOf(Header_Image_TransparentColor));
      finally
        BlockHeaderWriter.EndBlock;
      end;

      {  Pixel data writing  }
      if Image.Size > 0 then
      begin
        {  Writing start  }
        BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_PixelData);
        try
          {  Scan compress type  }
          case Image.FileCompressType of
            DXTextureImageFileCompressType_None:
              begin
                Header_Image_PixelData.Compress := DXTextureImageCompress_None;
              end;
{$IFDEF DXTextureImage_UseZLIB}
            DXTextureImageFileCompressType_ZLIB:
              begin
                Header_Image_PixelData.Compress := DXTextureImageCompress_ZLIB;
              end;
{$ENDIF}
          else
            Header_Image_PixelData.Compress := DXTextureImageCompress_None;
          end;

          Stream.WriteBuffer(Header_Image_PixelData, SizeOf(Header_Image_PixelData));

          case Header_Image_PixelData.Compress of
            DXTextureImageCompress_None:
              begin
                for i := 0 to Image.Height - 1 do
                begin
                  Stream.WriteBuffer(Image.ScanLine[i]^, Image.WidthBytes);
                  AddProgress(Image.WidthBytes);
                end;
              end;
{$IFDEF DXTextureImage_UseZLIB}
            DXTextureImageCompress_ZLIB:
              begin
                Compression := TCompressionStream.Create(clMax, Stream);
                try
                  for i := 0 to Image.Height - 1 do
                  begin
                    Compression.WriteBuffer(Image.ScanLine[i]^, Image.WidthBytes);
                    AddProgress(Image.WidthBytes);
                  end;
                finally
                  Compression.Free;
                end;
              end;
{$ENDIF}
          end;
        finally
          BlockHeaderWriter.EndBlock;
        end;
      end;

      {  Sub-image writing  }
      for i := 0 to Image.SubImageCount - 1 do
        WriteGroup_Image(Image.SubImages[i]);
    finally
      BlockHeaderWriter.EndGroup;
    end;
  end;

var
  FileHeader: TDXTextureImageFileHeader;
begin
  Progress := 0;
  ProgressCount := CalcProgressCount(Image);

  {  File header writing  }
  FileHeader.FileType := DXTextureImageFile_Type;
  FileHeader.ver := DXTextureImageFile_Version;
  Stream.WriteBuffer(FileHeader, SizeOf(FileHeader));

  {  Image writing  }
  BlockHeaderWriter := TDXTextureImageFileBlockHeaderWriter.Create(Stream);
  try
    {  Image writing  }
    WriteGroup_Image(Image);

    {  End of file  }
    BlockHeaderWriter.WriteBlock(DXTextureImageFileBlockID_EndFile);
  finally
    BlockHeaderWriter.Free;
  end;
end;

{  DXTextureImage_LoadBitmapFunc  }

procedure DXTextureImage_LoadBitmapFunc(Stream: TStream; Image: TDXTextureImage);
type
  TDIBPixelFormat = packed record
    RBitMask, GBitMask, BBitMask: DWORD;
  end;
var
  TopDown: Boolean;
  bf: TBitmapFileHeader;
  BI: TBitmapInfoHeader;

  procedure DecodeRGB;
  var
    Y: Integer;
  begin
    for Y := 0 to Image.Height - 1 do
    begin
      if TopDown then
        Stream.ReadBuffer(Image.ScanLine[Y]^, Image.WidthBytes)
      else
        Stream.ReadBuffer(Image.ScanLine[Image.Height - Y - 1]^, Image.WidthBytes);
    end;
  end;

  procedure DecodeRLE4;
  var
    SrcDataP: Pointer;
    b1, b2, c: Byte;
    Dest, Src, P: PByte;
    X, Y, i: Integer;
  begin
    GetMem(SrcDataP, BI.biSizeImage);
    try
      Stream.ReadBuffer(SrcDataP^, BI.biSizeImage);

      Dest := Image.TopPBits;
      Src := SrcDataP;
      X := 0;
      Y := 0;

      while True do
      begin
        b1 := Src^;
        Inc(Src);
        b2 := Src^;
        Inc(Src);

        if b1 = 0 then
        begin
          case b2 of
            0:
              begin {  End of line  }
                X := 0;
                Inc(Y);
                Dest := Image.ScanLine[Y];
              end;
            1: Break; {  End of bitmap  }
            2:
              begin {  Difference of coordinates  }
                Inc(X, b1);
                Inc(Y, b2);
                Inc(Src, 2);
                Dest := Image.ScanLine[Y];
              end;
          else
            {  Absolute mode  }
            c := 0;
            for i := 0 to b2 - 1 do
            begin
              if i and 1 = 0 then
              begin
                c := Src^;
                Inc(Src);
              end
              else
              begin
                c := c shl 4;
              end;

              P := Pointer(Integer(Dest) + X shr 1);
              if X and 1 = 0 then
                P^ := (P^ and $0F) or (c and $F0)
              else
                P^ := (P^ and $F0) or ((c and $F0) shr 4);

              Inc(X);
            end;
          end;
        end
        else
        begin
          {  Encoding mode  }
          for i := 0 to b1 - 1 do
          begin
            P := Pointer(Integer(Dest) + X shr 1);
            if X and 1 = 0 then
              P^ := (P^ and $0F) or (b2 and $F0)
            else
              P^ := (P^ and $F0) or ((b2 and $F0) shr 4);

            Inc(X);

            // Swap nibble
            b2 := (b2 shr 4) or (b2 shl 4);
          end;
        end;

        {  Word arrangement  }
        Inc(Src, Longint(Src) and 1);
      end;
    finally
      FreeMem(SrcDataP);
    end;
  end;

  procedure DecodeRLE8;
  var
    SrcDataP: Pointer;
    b1, b2: Byte;
    Dest, Src: PByte;
    X, Y: Integer;
  begin
    GetMem(SrcDataP, BI.biSizeImage);
    try
      Stream.ReadBuffer(SrcDataP^, BI.biSizeImage);

      Dest := Image.TopPBits;
      Src := SrcDataP;
      X := 0;
      Y := 0;

      while True do
      begin
        b1 := Src^;
        Inc(Src);
        b2 := Src^;
        Inc(Src);

        if b1 = 0 then
        begin
          case b2 of
            0:
              begin {  End of line  }
                X := 0;
                Inc(Y);
                Dest := Pointer(Longint(Image.TopPBits) + Y * Image.NextLine + X);
              end;
            1: Break; {  End of bitmap  }
            2:
              begin {  Difference of coordinates  }
                Inc(X, b1);
                Inc(Y, b2);
                Inc(Src, 2);
                Dest := Pointer(Longint(Image.TopPBits) + Y * Image.NextLine + X);
              end;
          else
            {  Absolute mode  }
            Move(Src^, Dest^, b2);
            Inc(Dest, b2);
            Inc(Src, b2);
          end;
        end
        else
        begin
          {  Encoding mode  }
          FillChar(Dest^, b1, b2);
          Inc(Dest, b1);
        end;

        {  Word arrangement  }
        Inc(Src, Longint(Src) and 1);
      end;
    finally
      FreeMem(SrcDataP);
    end;
  end;

var
  BC: TBitmapCoreHeader;
  RGBTriples: array[0..255] of TRGBTriple;
  RGBQuads: array[0..255] of TRGBQuad;
  i, PalCount, j: Integer;
  OS2: Boolean;
  PixelFormat: TDIBPixelFormat;
begin
  {  File header reading  }
  i := Stream.Read(bf, SizeOf(TBitmapFileHeader));
  if i = 0 then
    Exit;
  if i <> SizeOf(TBitmapFileHeader) then
    raise EDXTextureImageError.Create(SInvalidDIB);

  {  Is the head 'BM'?  }
  if bf.bfType <> Ord('B') + Ord('M') * $100 then
    raise EDXTextureImageError.Create(SInvalidDIB);

  {  Reading of size of header  }
  i := Stream.Read(BI.biSize, 4);
  if i <> 4 then
    raise EDXTextureImageError.Create(SInvalidDIB);

  {  Kind check of DIB  }
  OS2 := False;

  case BI.biSize of
    SizeOf(TBitmapCoreHeader):
      begin
        {  OS/2 type  }
        Stream.ReadBuffer(Pointer(Integer(@BC) + 4)^, SizeOf(TBitmapCoreHeader) - 4);

        FillChar(BI, SizeOf(BI), 0);
        with BI do
        begin
          biClrUsed := 0;
          biCompression := BI_RGB;
          biBitCount := BC.bcBitCount;
          biHeight := BC.bcHeight;
          biWidth := BC.bcWidth;
        end;

        OS2 := True;
      end;
    SizeOf(TBitmapInfoHeader):
      begin
        {  Windows type  }
        Stream.ReadBuffer(Pointer(Integer(@BI) + 4)^, SizeOf(TBitmapInfoHeader) - 4);
      end;
  else
    raise EDXTextureImageError.Create(SInvalidDIB);
  end;

  {  Bit mask reading  }
  if BI.biCompression = BI_BITFIELDS then
  begin
    Stream.ReadBuffer(PixelFormat, SizeOf(PixelFormat));
  end
  else
  begin
    if BI.biBitCount = 16 then
    begin
      PixelFormat.RBitMask := $7C00;
      PixelFormat.GBitMask := $03E0;
      PixelFormat.BBitMask := $001F;
    end
    else if (BI.biBitCount = 24) or (BI.biBitCount = 32) then
    begin
      PixelFormat.RBitMask := $00FF0000;
      PixelFormat.GBitMask := $0300FF00;
      PixelFormat.BBitMask := $000000FF;
    end;
  end;

  {  DIB making  }
  if BI.biHeight < 0 then
  begin
    BI.biHeight := -BI.biHeight;
    TopDown := True;
  end
  else
    TopDown := False;

  if BI.biBitCount in [1, 4, 8] then
  begin
    Image.SetSize(DXTextureImageType_PaletteIndexedColor, BI.biWidth, BI.biHeight, BI.biBitCount,
      (((BI.biWidth * BI.biBitCount) + 31) div 32) * 4);

    Image.idx_index := dxtMakeChannel(1 shl BI.biBitCount - 1, True);
    Image.PackedPixelOrder := True;
  end
  else
  begin
    Image.SetSize(DXTextureImageType_RGBColor, BI.biWidth, BI.biHeight, BI.biBitCount,
      (((BI.biWidth * BI.biBitCount) + 31) div 32) * 4);

    Image.rgb_red := dxtMakeChannel(PixelFormat.RBitMask, False);
    Image.rgb_green := dxtMakeChannel(PixelFormat.GBitMask, False);
    Image.rgb_blue := dxtMakeChannel(PixelFormat.BBitMask, False);

    j := Image.rgb_red.BitCount + Image.rgb_green.BitCount + Image.rgb_blue.BitCount;
    if j < BI.biBitCount then
      Image.rgb_alpha := dxtMakeChannel((1 shl (BI.biBitCount - j) - 1) shl j, False);

    Image.PackedPixelOrder := False;
  end;

  {  palette reading  }
  PalCount := BI.biClrUsed;
  if (PalCount = 0) and (BI.biBitCount <= 8) then
    PalCount := 1 shl BI.biBitCount;
  if PalCount > 256 then
    PalCount := 256;

  if OS2 then
  begin
    {  OS/2 type  }
    Stream.ReadBuffer(RGBTriples, SizeOf(TRGBTriple) * PalCount);
    for i := 0 to PalCount - 1 do
    begin
      Image.idx_palette[i].peRed := RGBTriples[i].rgbtRed;
      Image.idx_palette[i].peGreen := RGBTriples[i].rgbtGreen;
      Image.idx_palette[i].peBlue := RGBTriples[i].rgbtBlue;
    end;
  end
  else
  begin
    {  Windows type  }
    Stream.ReadBuffer(RGBQuads, SizeOf(TRGBQuad) * PalCount);
    for i := 0 to PalCount - 1 do
    begin
      Image.idx_palette[i].peRed := RGBQuads[i].rgbRed;
      Image.idx_palette[i].peGreen := RGBQuads[i].rgbGreen;
      Image.idx_palette[i].peBlue := RGBQuads[i].rgbBlue;
    end;
  end;

  {  Pixel data reading  }
  case BI.biCompression of
    BI_RGB: DecodeRGB;
    BI_BITFIELDS: DecodeRGB;
    BI_RLE4: DecodeRLE4;
    BI_RLE8: DecodeRLE8;
  else
    raise EDXTextureImageError.Create(SInvalidDIB);
  end;
end;

{ TDXTBase }

//Note by JB.
//This class is supplement of original Hori's code.
//For use alphablend you can have a bitmap 32 bit RGBA
//when isn't alphachannel present, it works like RGB 24bit

//functions required actualized DIB source for works with alphachannel

function TDXTBase.GetCompression: TDXTextureImageFileCompressType;
begin
  Result := FParamsFormat.Compress;
end;

procedure TDXTBase.SetCompression(const Value: TDXTextureImageFileCompressType);
begin
  FParamsFormat.Compress := Value;
end;

function TDXTBase.GetWidth: Integer;
begin
  Result := FParamsFormat.Width;
end;

procedure TDXTBase.SetWidth(const Value: Integer);
begin
  FParamsFormat.Width := Value;
end;

function TDXTBase.GetMipmap: Integer;
begin
  Result := FParamsFormat.MipmapCount;
end;

procedure TDXTBase.SetMipmap(const Value: Integer);
begin
  if Value = -1 then
    FParamsFormat.MipmapCount := MaxInt
  else
    FParamsFormat.MipmapCount := Value;
end;

function TDXTBase.GetTransparentColor: TColorRef;
begin
  Result := FParamsFormat.TransparentColor;
end;

procedure TDXTBase.SetTransparentColor(const Value: TColorRef);
begin
  FParamsFormat.Transparent := True;
  FParamsFormat.TransparentColor := RGB(Value shr 16, Value shr 8, Value);
end;

procedure TDXTBase.SetTransparentColorIndexed(const Value: TColorRef);
begin
  FParamsFormat.TransparentColor := PaletteIndex(Value);
end;

function TDXTBase.GetHeight: Integer;
begin
  Result := FParamsFormat.Height;
end;

procedure TDXTBase.SetHeight(const Value: Integer);
begin
  FParamsFormat.Height := Value;
end;

procedure TDXTBase.SetChannelY(T: TDIB);
begin

end;

procedure TDXTBase.LoadChannelRGBFromFile(const FileName: string);
begin
  FStrImageFileName := FileName;
  try
    EvaluateChannels([rgbRed, rgbGreen, rgbBlue], '', '');
  finally
    FStrImageFileName := '';
  end;
end;

procedure TDXTBase.LoadChannelAFromFile(const FileName: string);
begin
  FStrImageFileName := FileName;
  try
    EvaluateChannels([rgbAlpha], '', '');
  finally
    FStrImageFileName := '';
  end;
end;

constructor TDXTBase.Create;
var
  Channel: TDXTImageChannel;
begin
  FillChar(FParamsFormat, SizeOf(FParamsFormat), 0);
  FParamsFormat.Compress := DXTextureImageFileCompressType_None;
  FHasImageList := TList.Create;
  for Channel := Low(Channel) to High(Channel) do
    FChannelChangeTable[Channel] := Channel;
  FChannelChangeTable[rgbAlpha] := yuvY;
  FDIB := nil;
  FStrImageFileName := '';
end;

procedure TDXTBase.SetChannelRGBA(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbRed, rgbGreen, rgbBlue, rgbAlpha], '', '');
  finally
    FDIB := nil;
  end;
end;

procedure TDXTBase.BuildImage(Image: TDXTextureImage);
type
  TOutputImageChannelInfo2 = record
    Image: TDXTextureImage;
    Channels: TDXTImageChannels;
  end;
var
  cr, cg, cb: Byte;

  function GetChannelVal(const Channel: TDXTextureImageChannel; SrcChannel: TDXTImageChannel): DWORD;
  begin
    case SrcChannel of
      rgbRed: Result := dxtEncodeChannel(Channel, cr);
      rgbGreen: Result := dxtEncodeChannel(Channel, cg);
      rgbBlue: Result := dxtEncodeChannel(Channel, cb);
      yuvY: Result := dxtEncodeChannel(Channel, (cr * 306 + cg * 602 + cb * 116) div 1024);
    else
      Result := 0;
    end;
  end;

var
  HasImageChannelList: array[0..Ord(High(TDXTImageChannel)) + 1] of TOutputImageChannelInfo2;
  HasImageChannelListCount: Integer;
  X, Y, i: Integer;
  c, C2, C3: DWORD;
  Channel: TDXTImageChannel;
  Flag: Boolean;

  SrcImage: TDXTextureImage;
  UseChannels: TDXTImageChannels;
begin
  HasImageChannelListCount := 0;
  for Channel := Low(Channel) to High(Channel) do
    if Channel in FHasChannels then
    begin
      Flag := False;
      for i := 0 to HasImageChannelListCount - 1 do
        if HasImageChannelList[i].Image = FHasChannelImages[Channel].Image then
        begin
          HasImageChannelList[i].Channels := HasImageChannelList[i].Channels + [Channel];
          Flag := True;
          Break;
        end;
      if not Flag then
      begin
        HasImageChannelList[HasImageChannelListCount].Image := FHasChannelImages[Channel].Image;
        HasImageChannelList[HasImageChannelListCount].Channels := [Channel];
        Inc(HasImageChannelListCount);
      end;
    end;

  cr := 0;
  cg := 0;
  cb := 0;

  if Image.ImageType = DXTextureImageType_PaletteIndexedColor then
  begin
    {  Index color  }
    for Y := 0 to Image.Height - 1 do
      for X := 0 to Image.Width - 1 do
      begin
        c := 0;

        for i := 0 to HasImageChannelListCount - 1 do
        begin
          SrcImage := HasImageChannelList[i].Image;
          UseChannels := HasImageChannelList[i].Channels;

          case SrcImage.ImageType of
            DXTextureImageType_PaletteIndexedColor:
              begin
                C2 := SrcImage.Pixels[X, Y];
                C3 := dxtDecodeChannel(SrcImage.idx_index, C2);

                if rgbRed in UseChannels then
                  c := c or dxtEncodeChannel(Image.idx_index, C3);

                cr := SrcImage.idx_palette[C3].peRed;
                cg := SrcImage.idx_palette[C3].peGreen;
                cb := SrcImage.idx_palette[C3].peBlue;
              end;
            DXTextureImageType_RGBColor:
              begin
                C2 := SrcImage.Pixels[X, Y];

                cr := dxtDecodeChannel(SrcImage.rgb_red, C2);
                cg := dxtDecodeChannel(SrcImage.rgb_green, C2);
                cb := dxtDecodeChannel(SrcImage.rgb_blue, C2);
              end;
          end;

          if rgbAlpha in UseChannels then
            c := c or GetChannelVal(Image.idx_alpha, FChannelChangeTable[rgbAlpha]);
        end;

        Image.Pixels[X, Y] := c;
      end;
  end
  else if Image.ImageType = DXTextureImageType_RGBColor then
  begin
      {  RGB color  }
    for Y := 0 to Image.Height - 1 do
      for X := 0 to Image.Width - 1 do
      begin
        c := 0;

        for i := 0 to HasImageChannelListCount - 1 do
        begin
          SrcImage := HasImageChannelList[i].Image;
          UseChannels := HasImageChannelList[i].Channels;

          case SrcImage.ImageType of
            DXTextureImageType_PaletteIndexedColor:
              begin
                C2 := SrcImage.Pixels[X, Y];
                C3 := dxtDecodeChannel(SrcImage.idx_index, C2);

                cr := SrcImage.idx_palette[C3].peRed;
                cg := SrcImage.idx_palette[C3].peGreen;
                cb := SrcImage.idx_palette[C3].peBlue;
              end;
            DXTextureImageType_RGBColor:
              begin
                C2 := SrcImage.Pixels[X, Y];

                cr := dxtDecodeChannel(SrcImage.rgb_red, C2);
                cg := dxtDecodeChannel(SrcImage.rgb_green, C2);
                cb := dxtDecodeChannel(SrcImage.rgb_blue, C2);
              end;
          end;

          if rgbRed in UseChannels then
            c := c or GetChannelVal(Image.rgb_red, FChannelChangeTable[rgbRed]);
          if rgbGreen in UseChannels then
            c := c or GetChannelVal(Image.rgb_green, FChannelChangeTable[rgbGreen]);
          if rgbBlue in UseChannels then
            c := c or GetChannelVal(Image.rgb_blue, FChannelChangeTable[rgbBlue]);
          if rgbAlpha in UseChannels then
            c := c or GetChannelVal(Image.rgb_alpha, FChannelChangeTable[rgbAlpha]);
        end;

        Image.Pixels[X, Y] := c;
      end;
  end;
end;

procedure TDXTBase.SetChannelR(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbRed], '', '');
  finally
    FDIB := nil;
  end;
end;

function GetBitCount(B: Integer): Integer;
begin
  Result := 32;
  while (Result > 0) and (((1 shl (Result - 1)) and B) = 0) do
    Dec(Result);
end;

procedure TDXTBase.CalcOutputBitFormat;
var
  BitCount: DWORD;
  NewWidth, NewHeight, i, j: Integer;
  Channel: TDXTImageChannel;
begin
  {  Size calculation  }
  NewWidth := 1 shl GetBitCount(TDXTextureImage(FHasImageList[0]).Width);
  NewHeight := 1 shl GetBitCount(TDXTextureImage(FHasImageList[0]).Height);
  NewWidth := Max(NewWidth, NewHeight);
  NewHeight := NewWidth;
  if Abs(FParamsFormat.Width - NewWidth) > Abs(FParamsFormat.Width - NewWidth div 2) then
    NewWidth := NewWidth div 2;
  if Abs(FParamsFormat.Height - NewHeight) > Abs(FParamsFormat.Height - NewHeight div 2) then
    NewHeight := NewHeight div 2;

  if FParamsFormat.Width = 0 then
    FParamsFormat.Width := NewWidth;
  if FParamsFormat.Height = 0 then
    FParamsFormat.Height := NewHeight;

  {  Other several calculation  }
  i := Min(FParamsFormat.Width, FParamsFormat.Height);
  j := 0;
  while i > 1 do
  begin
    i := i div 2;
    Inc(j);
  end;

  FParamsFormat.MipmapCount := Min(j, FParamsFormat.MipmapCount);

  {  Output type calculation  }
  if (FHasChannelImages[rgbRed].Image = FHasChannelImages[rgbGreen].Image) and
    (FHasChannelImages[rgbRed].Image = FHasChannelImages[rgbBlue].Image) and
    (FHasChannelImages[rgbRed].Image <> nil) and (FHasChannelImages[rgbRed].Image.ImageType = DXTextureImageType_PaletteIndexedColor) and

  (FHasChannelImages[rgbRed].BitCount = 8) and
    (FHasChannelImages[rgbGreen].BitCount = 8) and
    (FHasChannelImages[rgbBlue].BitCount = 8) and

  (FChannelChangeTable[rgbRed] = rgbRed) and
    (FChannelChangeTable[rgbGreen] = rgbGreen) and
    (FChannelChangeTable[rgbBlue] = rgbBlue) and

  (FParamsFormat.Width = FHasChannelImages[rgbRed].Image.Width) and
    (FParamsFormat.Height = FHasChannelImages[rgbRed].Image.Height) and

  (FParamsFormat.MipmapCount = 0) then
  begin
    FParamsFormat.ImageType := DXTextureImageType_PaletteIndexedColor;
  end
  else
    FParamsFormat.ImageType := DXTextureImageType_RGBColor;

  {  Bit several calculations  }
  FParamsFormat.BitCount := 0;

  for Channel := Low(TDXTImageChannel) to High(TDXTImageChannel) do
    if (FHasChannelImages[Channel].Image <> nil) and (FHasChannelImages[Channel].Image.ImageType = DXTextureImageType_PaletteIndexedColor) then
    begin
      FParamsFormat.idx_palette := FHasChannelImages[Channel].Image.idx_palette;
      Break;
    end;

  if FParamsFormat.ImageType = DXTextureImageType_PaletteIndexedColor then
  begin
    {  Index channel }
    if rgbRed in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbRed].BitCount;
      FParamsFormat.idx_index := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, True);
      Inc(FParamsFormat.BitCount, BitCount);
    end;

    {  Alpha channel  }
    if rgbAlpha in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbAlpha].BitCount;
      FParamsFormat.idx_alpha := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, False);
      Inc(FParamsFormat.BitCount, BitCount);
    end;
  end
  else
  begin
    {  B channel }
    if rgbBlue in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbBlue].BitCount;
      FParamsFormat.rgb_blue := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, False);
      Inc(FParamsFormat.BitCount, BitCount);
    end;

    {  G channel }
    if rgbGreen in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbGreen].BitCount;
      FParamsFormat.rgb_green := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, False);
      Inc(FParamsFormat.BitCount, BitCount);
    end;

    {  R channel }
    if rgbRed in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbRed].BitCount;
      FParamsFormat.rgb_red := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, False);
      Inc(FParamsFormat.BitCount, BitCount);
    end;

    {  Alpha channel }
    if rgbAlpha in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbAlpha].BitCount;
      FParamsFormat.rgb_alpha := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, False);
      Inc(FParamsFormat.BitCount, BitCount);
    end;
  end;

  {  As for the number of bits only either of 1, 2, 4, 8, 16, 24, 32  }
  if FParamsFormat.BitCount in [3] then
    FParamsFormat.BitCount := 4
  else if FParamsFormat.BitCount in [5..7] then
    FParamsFormat.BitCount := 8
  else if FParamsFormat.BitCount in [9..15] then
    FParamsFormat.BitCount := 16
  else if FParamsFormat.BitCount in [17..23] then
    FParamsFormat.BitCount := 24
  else if FParamsFormat.BitCount in [25..31] then
    FParamsFormat.BitCount := 32;

  {  Transparent color  }
  if (FParamsFormat.ImageType = DXTextureImageType_RGBColor) and (FParamsFormat.TransparentColor shr 24 = $01) then
  begin
    FParamsFormat.TransparentColor := RGB(FParamsFormat.idx_palette[Byte(FParamsFormat.TransparentColor)].peRed,
      FParamsFormat.idx_palette[Byte(FParamsFormat.TransparentColor)].peGreen,
      FParamsFormat.idx_palette[Byte(FParamsFormat.TransparentColor)].peBlue);
  end;
end;

procedure TDXTBase.LoadChannelRGBAFromFile(const FileName: string);
begin
  FStrImageFileName := FileName;
  try
    EvaluateChannels([rgbRed, rgbGreen, rgbBlue, rgbAlpha], '', '');
  finally
    FStrImageFileName := '';
  end;
end;

procedure TDXTBase.SetChannelB(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbBlue], '', '');
  finally
    FDIB := nil;
  end;
end;

procedure TDXTBase.SetChannelRGB(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbRed, rgbGreen, rgbBlue], '', '');
  finally
    FDIB := nil;
  end;
end;

procedure TDXTBase.SetChannelA(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbAlpha], '', '');
  finally
    FDIB := nil;
  end;
end;

procedure TDXTBase.SetChannelG(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbGreen], '', '');
  finally
    FDIB := nil;
  end;
end;

destructor TDXTBase.Destroy;
var
  i: Integer;
begin
  for i := 0 to FHasImageList.Count - 1 do
    TDXTextureImage(FHasImageList[i]).Free;
  FHasImageList.Free;
  inherited Destroy;
end;

function TDXTBase.GetPicture: TDXTextureImage;
var
  MemoryStream: TMemoryStream;
begin
  Result := TDXTextureImage.Create;
  try
    if (FStrImageFileName <> '') and FileExists(FStrImageFileName) then
    begin
      Result.LoadFromFile(FStrImageFileName);
      Result.FImageName := ExtractFileName(FStrImageFileName);
    end
    else if Assigned(FDIB) then
    begin
      MemoryStream := TMemoryStream.Create;
      try
        FDIB.SaveToStream(MemoryStream);
        MemoryStream.Position := 0; //reading from 0
        Result.LoadFromStream(MemoryStream);
      finally
        MemoryStream.Free;
      end;
      Result.FImageName := Format('DIB%x', [Integer(Result)]); //supplement name
    end;
  except
    on E: Exception do
    begin
      EDXTBaseError.Create(E.Message);
    end;
  end
end;

procedure TDXTBase.Resize(Image: TDXTextureImage; NewWidth, NewHeight: Integer;
  FilterTypeResample: TFilterTypeResample);
//resize used for Mipmap
var
  DIB: TDIB;
  X, Y: Integer;
  c: DWORD;
  MemoryStream: TMemoryStream;
begin
  {  Exit when no resize  }
  if (Image.Width = NewWidth) and (Image.Height = NewHeight) then
    Exit;
  {  Supplement for image resizing  }
  //raise EDXTBaseError.Create('Invalid image size for texture.');
  {  No image at start  }
  DIB := TDIB.Create; //DIB accept
  try
    DIB.SetSize(Image.Width, Image.Height, Image.BitCount);
    {  of type  }
    for Y := 0 to Image.Height - 1 do
      for X := 0 to Image.Width - 1 do
      begin
        if Image.ImageType = DXTextureImageType_PaletteIndexedColor then
        begin
          c := dxtDecodeChannel(Image.idx_index, Image.Pixels[X, Y]);
          DIB.Pixels[X, Y] := (Image.idx_palette[c].peRed shl 16) or
            (Image.idx_palette[c].peGreen shl 8) or
            Image.idx_palette[c].peBlue;
        end
        else
        begin
          c := Image.Pixels[X, Y];
          DIB.Pixels[X, Y] := (dxtDecodeChannel(Image.rgb_red, c) shl 16) or
            (dxtDecodeChannel(Image.rgb_green, c) shl 8) or
            dxtDecodeChannel(Image.rgb_blue, c);
        end;
      end;

    {  Resize for 24 bitcount deep }
    Image.SetSize(DXTextureImageType_RGBColor, Width, Height, Image.BitCount, 0);

    Image.rgb_red := dxtMakeChannel($FF0000, False);
    Image.rgb_green := dxtMakeChannel($00FF00, False);
    Image.rgb_blue := dxtMakeChannel($0000FF, False);
    Image.rgb_alpha := dxtMakeChannel(0, False);

    {  Resample routine DIB based there  }
    DIB.DoResample(Width, Height, FilterTypeResample);

    {Image returned through stream}
    Image.ClearImage;
    MemoryStream := TMemoryStream.Create;
    try
      DIB.SaveToStream(MemoryStream);
      MemoryStream.Position := 0; //from first byte
      Image.LoadFromStream(MemoryStream);
    finally
      MemoryStream.Free;
    end;
  finally
    DIB.Free;
  end;
end;

procedure TDXTBase.EvaluateChannels
  (const CheckChannelUsed: TDXTImageChannels;
  const CheckChannelChanged, CheckBitCountForChannel: string);
var
  j: Integer;
  Channel: TDXTImageChannel;
  ChannelBitCount: array[TDXTImageChannel] of Integer;
  ChannelParamName: TDXTImageChannels;
  Image: TDXTextureImage;
  Q: TDXTImageChannel;
begin
  FillChar(ChannelBitCount, SizeOf(ChannelBitCount), 0);
  ChannelParamName := [];
  {  The channel which you use acquisition  }
  j := 0;
  for Q := rgbRed to rgbAlpha do
  begin
    if Q in CheckChannelUsed then
    begin
      Inc(j);
      Channel := Q;
      if not (Channel in FHasChannels) then
      begin
        if CheckBitCountForChannel <> '' then
          ChannelBitCount[Channel] := StrToInt(Copy(CheckBitCountForChannel, j, 1))
        else
          ChannelBitCount[Channel] := 8; {poke default value}
        if ChannelBitCount[Channel] <> 0 then
          ChannelParamName := ChannelParamName + [Channel];

        if CheckChannelChanged <> '' then
        begin
          case UpCase(CheckChannelChanged[j]) of
            'R': FChannelChangeTable[Channel] := rgbRed;
            'G': FChannelChangeTable[Channel] := rgbGreen;
            'B': FChannelChangeTable[Channel] := rgbBlue;
            'Y': FChannelChangeTable[Channel] := yuvY;
            'N': FChannelChangeTable[Channel] := rgbNone;
          else
            raise EDXTBaseError.CreateFmt('Invalid channel type(%s)', [CheckChannelChanged[j]]);
          end;
        end;
      end;
    end;
  end;
  {  Processing of each  }
  if ChannelParamName <> [] then
  begin
    {  Picture load  }
    Image := nil;
    {pokud je image uz nahrany tj. stejneho jmena, pokracuj dale}
    for j := 0 to FHasImageList.Count - 1 do
      if AnsiCompareFileName(TDXTextureImage(FHasImageList[j]).ImageName, FStrImageFileName) = 0 then
      begin
        Image := FHasImageList[j];
        Break;
      end;
    {obrazek neexistuje, musi se dotahnout bud z proudu, souboru nebo odjinut}
    if Image = nil then
    begin
      try
        Image := GetPicture;
      except
        if Assigned(Image) then
        begin
{$IFNDEF DelphiX_Spt5}
          Image.Free;
          Image := nil;
{$ELSE}
          FreeAndNil(Image);
{$ENDIF}
        end;
        raise;
      end;
      FHasImageList.Add(Image);
    end;

    {  Each channel processing  }
    for Channel := Low(Channel) to High(Channel) do
      if Channel in ChannelParamName then
      begin
        if ChannelBitCount[Channel] >= 0 then
          FHasChannelImages[Channel].BitCount := ChannelBitCount[Channel]
        else
        begin
          case Image.ImageType of
            DXTextureImageType_PaletteIndexedColor:
              begin
                case Channel of
                  rgbRed: FHasChannelImages[Channel].BitCount := 8;
                  rgbGreen: FHasChannelImages[Channel].BitCount := 8;
                  rgbBlue: FHasChannelImages[Channel].BitCount := 8;
                  rgbAlpha: FHasChannelImages[Channel].BitCount := 8;
                end;
              end;
            DXTextureImageType_RGBColor:
              begin
                case Channel of
                  rgbRed: FHasChannelImages[Channel].BitCount := Image.rgb_red.BitCount;
                  rgbGreen: FHasChannelImages[Channel].BitCount := Image.rgb_green.BitCount;
                  rgbBlue: FHasChannelImages[Channel].BitCount := Image.rgb_blue.BitCount;
                  rgbAlpha: FHasChannelImages[Channel].BitCount := 8;
                end;
              end;
          end;
        end;
        if FHasChannelImages[Channel].BitCount = 0 then
          Continue;
        FHasChannels := FHasChannels + [Channel];
        FHasChannelImages[Channel].Image := Image;
      end;
  end;
end;

function TDXTBase.GetTexture: TDXTextureImage;
var
  i, j: Integer;
  SubImage: TDXTextureImage;
  CurWidth, CurHeight: Integer;
begin
  Result := nil;
  if FHasImageList.Count = 0 then
    raise EDXTBaseError.Create('No image found');

  {  Output format calculation  }
  CalcOutputBitFormat;
  Result := TDXTextureImage.Create;
  try
    Result.SetSize(FParamsFormat.ImageType, FParamsFormat.Width, FParamsFormat.Height, FParamsFormat.BitCount, 0);

    Result.idx_index := FParamsFormat.idx_index;
    Result.idx_alpha := FParamsFormat.idx_alpha;
    Result.idx_palette := FParamsFormat.idx_palette;

    Result.rgb_red := FParamsFormat.rgb_red;
    Result.rgb_green := FParamsFormat.rgb_green;
    Result.rgb_blue := FParamsFormat.rgb_blue;
    Result.rgb_alpha := FParamsFormat.rgb_alpha;

    Result.ImageName := FParamsFormat.Name;

    Result.Transparent := FParamsFormat.Transparent;
    if FParamsFormat.TransparentColor shr 24 = $01 then
      Result.TransparentColor := dxtEncodeChannel(Result.idx_index, PaletteIndex(Byte(FParamsFormat.TransparentColor)))
    else
      Result.TransparentColor := Result.EncodeColor(GetRValue(FParamsFormat.TransparentColor), GetGValue(FParamsFormat.TransparentColor), GetBValue(FParamsFormat.TransparentColor), 0);

    BuildImage(Result);

    if FParamsFormat.ImageType = DXTextureImageType_RGBColor then
    begin
      BuildImage(Result);
      {  Picture information store here  }
      CurWidth := FParamsFormat.Width;
      CurHeight := FParamsFormat.Height;
      for i := 0 to FParamsFormat.MipmapCount - 1 do
      begin
        CurWidth := CurWidth div 2;
        CurHeight := CurHeight div 2;
        if (CurWidth <= 0) or (CurHeight <= 0) then
          Break;
        {  Resize calc here }
        for j := 0 to FHasImageList.Count - 1 do
          Resize(FHasImageList[j], CurWidth, CurHeight, ftrTriangle);

        SubImage := TDXTextureImage.CreateSub(Result);
        SubImage.SetSize(FParamsFormat.ImageType, CurWidth, CurHeight, FParamsFormat.BitCount, 0);

        SubImage.idx_index := FParamsFormat.idx_index;
        SubImage.idx_alpha := FParamsFormat.idx_alpha;
        SubImage.idx_palette := FParamsFormat.idx_palette;

        SubImage.rgb_red := FParamsFormat.rgb_red;
        SubImage.rgb_green := FParamsFormat.rgb_green;
        SubImage.rgb_blue := FParamsFormat.rgb_blue;
        SubImage.rgb_alpha := FParamsFormat.rgb_alpha;

        SubImage.ImageGroupType := DXTextureImageGroupType_Normal;
        SubImage.ImageID := i;
        SubImage.ImageName := Format('%s - mimap #%d', [Result.ImageName, i + 1]);

        BuildImage(SubImage);
      end;
    end;
    Result.FileCompressType := FParamsFormat.Compress;
  except
    on E: Exception do
    begin
{$IFNDEF DelphiX_Spt5}
      Result.Free;
      Result := nil;
{$ELSE}
      FreeAndNil(Result);
{$ENDIF}
      raise EDXTBaseError.Create(E.Message);
    end;
  end;
end;

{ DIB2DTX }

procedure dib2dxt(DIBImage: TDIB; out DXTImage: TDXTextureImage);
var
  TexImage: TDXTBase;
  DIB: TDIB;
begin
  TexImage := TDXTBase.Create;
  try
    //TexImage.Compression := DXTextureImageFileCompressType_ZLIB;
    //TexImage.Mipmap := 4;
    try
      TexImage.SetChannelRGB(DIBImage);
      if DIBImage.HasAlphaChannel then
      begin
        DIB := DIBImage.AlphaChannel;
        TexImage.SetChannelA(DIB);
      end;

      DXTImage := TexImage.Texture;
    except
      if Assigned(DXTImage) then
        DXTImage.Free;
      DXTImage := nil;
    end;
  finally
    TexImage.Free;
  end
end;

{$IFDEF D3DRM}
{  TDirect3DRMUserVisual  }

procedure TDirect3DRMUserVisual_D3DRMOBJECTCALLBACK(lpD3DRMobj: IDirect3DRMObject;
  lpArg: Pointer); cdecl;
begin
  TDirect3DRMUserVisual(lpArg).Free;
end;

function TDirect3DRMUserVisual_D3DRMUSERVISUALCALLBACK(lpD3DRMUV: IDirect3DRMUserVisual;
  lpArg: Pointer; lpD3DRMUVreason: TD3DRMUserVisualReason;
  lpD3DRMDev: IDirect3DRMDevice; lpD3DRMview: IDirect3DRMViewport): Integer; cdecl;
begin
  Result := TDirect3DRMUserVisual(lpArg).DoRender(lpD3DRMUVreason, lpD3DRMDev, lpD3DRMview);
end;

constructor TDirect3DRMUserVisual.Create(D3DRM: IDirect3DRM);
begin
  inherited Create;

  if D3DRM.CreateUserVisual(@TDirect3DRMUserVisual_D3DRMUSERVISUALCALLBACK,
    Self, FUserVisual) <> D3DRM_OK then
    raise EDirect3DRMUserVisualError.CreateFmt(SCannotMade, ['IDirect3DRMUserVisual']);

  FUserVisual.AddDestroyCallback(@TDirect3DRMUserVisual_D3DRMOBJECTCALLBACK, Self);
end;

destructor TDirect3DRMUserVisual.Destroy;
begin
  if FUserVisual <> nil then
    FUserVisual.DeleteDestroyCallback(@TDirect3DRMUserVisual_D3DRMOBJECTCALLBACK, Self);
  FUserVisual := nil;
  inherited Destroy;
end;

function TDirect3DRMUserVisual.DoRender(Reason: TD3DRMUserVisualReason;
  D3DRMDev: IDirect3DRMDevice; D3DRMView: IDirect3DRMViewport): HRESULT;
begin
  Result := 0;
end;
{$ENDIF}

{  TPictureCollectionItem  }

const
  SurfaceDivWidth = maxVideoBlockSize;
  SurfaceDivHeight = maxVideoBlockSize;

type
  TPictureCollectionItemPattern = class(TCollectionItem)
  private
    FRect: TRect;
    FSurface: TDirectDrawSurface;
  end;

constructor TPictureCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPicture := TPicture.Create;
  FPatterns := TCollection.Create(TPictureCollectionItemPattern);
  FSurfaceList := TList.Create;
  FTransparent := True;
end;

destructor TPictureCollectionItem.Destroy;
begin
  Finalize;
  FPicture.Free;
  FPatterns.Free;
  FSurfaceList.Free;
  inherited Destroy;
end;

procedure TPictureCollectionItem.Assign(Source: TPersistent);
var
  PrevInitialized: Boolean;
begin
  if Source is TPictureCollectionItem then
  begin
    PrevInitialized := Initialized;
    Finalize;

    FPatternHeight := TPictureCollectionItem(Source).FPatternHeight;
    FPatternWidth := TPictureCollectionItem(Source).FPatternWidth;
    FSkipHeight := TPictureCollectionItem(Source).FSkipHeight;
    FSkipWidth := TPictureCollectionItem(Source).FSkipWidth;
    FSystemMemory := TPictureCollectionItem(Source).FSystemMemory;
    FTransparent := TPictureCollectionItem(Source).FTransparent;
    FTransparentColor := TPictureCollectionItem(Source).FTransparentColor;

    FPicture.Assign(TPictureCollectionItem(Source).FPicture);

    if PrevInitialized then
      Restore;
  end
  else
    inherited Assign(Source);
end;

procedure TPictureCollectionItem.ClearSurface;
var
  i: Integer;
begin
  FPatterns.Clear;
  for i := 0 to FSurfaceList.Count - 1 do
    TDirectDrawSurface(FSurfaceList[i]).Free;
  FSurfaceList.Clear;
end;

function TPictureCollectionItem.GetHeight: Integer;
begin
  Result := FPatternHeight;
  if (Result <= 0) then
    Result := FPicture.Height;
end;

function TPictureCollectionItem.GetPictureCollection: TPictureCollection;
begin
  Result := Collection as TPictureCollection;
end;

function TPictureCollectionItem.GetPatternRect(Index: Integer): TRect;
begin
  if (Index >= 0) and (Index < FPatterns.Count) then
    Result := TPictureCollectionItemPattern(FPatterns.Items[Index]).FRect
  else
    Result := Rect(0, 0, 0, 0);
end;

function TPictureCollectionItem.GetPatternSurface(Index: Integer): TDirectDrawSurface;
begin
  if (Index >= 0) and (Index < FPatterns.Count) then
    Result := TPictureCollectionItemPattern(FPatterns.Items[Index]).FSurface
  else
    Result := nil;
end;

function TPictureCollectionItem.GetPatternCount: Integer;
var
  XCount, YCount: Integer;
begin
  if FSurfaceList.Count = 0 then
  begin
    if PatternWidth = 0 then
      PatternWidth := FPicture.Width; //prevent division by zero
    XCount := FPicture.Width div (PatternWidth + SkipWidth);
    if FPicture.Width - XCount * (PatternWidth + SkipWidth) = PatternWidth then
      Inc(XCount);
    if PatternHeight = 0 then
      PatternHeight := FPicture.Height; //prevent division by zero
    YCount := FPicture.Height div (PatternHeight + SkipHeight);
    if FPicture.Height - YCount * (PatternHeight + SkipHeight) = PatternHeight then
      Inc(YCount);
    Result := XCount * YCount;
  end
  else
    Result := FPatterns.Count;
end;

function TPictureCollectionItem.GetWidth: Integer;
begin
  Result := FPatternWidth;
  if (Result <= 0) then
    Result := FPicture.Width;
end;

procedure TPictureCollectionItem.Draw(Dest: TDirectDrawSurface; X, Y,
  PatternIndex: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
{$IFDEF DrawHWAcc}
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRender(Self, Bounds(X, Y, Width, Height), PatternIndex, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      end
      else
{$ENDIF DrawHWAcc}
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.Draw(X, Y, FRect, FSurface, Transparent);
  end;
end;

procedure TPictureCollectionItem.DrawFlipHV(Dest: TDirectDrawSurface; X, Y,
  PatternIndex: Integer);
var
  flrc: TRect;
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
    begin
      flrc.Left := FRect.Right;
      flrc.Right := FRect.Left;
      flrc.Top := FPicture.Height - FRect.Top;
      flrc.Bottom := FPicture.Height - FRect.Bottom;
      Dest.Draw(X, Y, flrc, FSurface, Transparent);
    end;
end;

procedure TPictureCollectionItem.DrawFlipH(Dest: TDirectDrawSurface; X, Y,
  PatternIndex: Integer);
var
  flrc: TRect;
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
    begin
      flrc.Left := FPicture.Width - FRect.Left;
      flrc.Right := FPicture.Width - FRect.Right;
      flrc.Top := FRect.Top;
      flrc.Bottom := FRect.Bottom;
      Dest.Draw(X, Y, flrc, FSurface, Transparent);
    end;
end;

procedure TPictureCollectionItem.DrawFlipV(Dest: TDirectDrawSurface; X, Y,
  PatternIndex: Integer);
var
  flrc: TRect;
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
    begin
      flrc.Left := FRect.Left;
      flrc.Right := FRect.Right;
      flrc.Top := FPicture.Height - FRect.Top;
      flrc.Bottom := FPicture.Height - FRect.Bottom;
      Dest.Draw(X, Y, flrc, FSurface, Transparent);
    end;
end;

procedure TPictureCollectionItem.StretchDraw(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
{$IFDEF DrawHWAcc}
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRender(Self, DestRect, PatternIndex, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF})
      end
      else
{$ENDIF DrawHWAcc}
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.StretchDraw(DestRect, FRect, FSurface, Transparent);
  end;
end;

procedure TPictureCollectionItem.DrawAdd(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRender(Self, DestRect, PatternIndex, rtAdd, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawAdd(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawAddCol(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Color: Integer; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderCol(Self, DestRect, PatternIndex, Color, rtAdd, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawAdd(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawAlpha(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRender(Self, DestRect, PatternIndex, rtBlend, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawAlpha(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawSub(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRender(Self, DestRect, PatternIndex, rtSub, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawSub(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawSubCol(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Color: Integer; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderCol(Self, DestRect, PatternIndex, Color, rtSub, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawSub(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotate(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle: single);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.FD2D.FDDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        //X,Y................ Center of rotation
        //Width,Height....... Picture
        //PatternIndex....... Piece of picture
        //CenterX,CenterY ... Center of rotation on picture
        //Angle.............. Angle of rotation
        FDXDraw.FD2D.D2DRenderRotate(Self, X, Y, Width, Height, PatternIndex, rtDraw, CenterX, CenterY, Angle{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotate(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle);
  end;
end;

procedure TPictureCollectionItem.DrawRotateAdd(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle: single; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderRotate(Self, X, Y, Width, Height, PatternIndex, rtAdd, CenterX, CenterY, Angle, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateAdd(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle: single; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderRotate(Self, X, Y, Width, Height, PatternIndex, rtBlend, CenterX, CenterY, Angle, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateAlpha(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateSub(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle: single; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderRotate(Self, X, Y, Width, Height, PatternIndex, rtSub, CenterX, CenterY, Angle, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateSub(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveX(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderWaveX(Self, X, Y, Width, Height, PatternIndex, rtDraw,
          Transparent, amp, Len, ph{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawWaveX(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph);
  end;
end;

procedure TPictureCollectionItem.DrawWaveXAdd(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderWaveX(Self, X, Y, Width, Height, PatternIndex, rtAdd,
          Transparent, amp, Len, ph, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawWaveXAdd(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveXAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderWaveX(Self, X, Y, Width, Height, PatternIndex, rtBlend,
          Transparent, amp, Len, ph, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawWaveXAlpha(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveXSub(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderWaveX(Self, X, Y, Width, Height, PatternIndex, rtSub,
          Transparent, amp, Len, ph, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawWaveXSub(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveYSub(Dest: TDirectDrawSurface; X, Y,
  Width, Height, PatternIndex, amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderWaveY(Self, X, Y, Width, Height, PatternIndex, rtSub,
          Transparent, amp, Len, ph, Alpha);
      end
        {there is not software version}
  end;
end;

procedure TPictureCollectionItem.DrawWaveY(Dest: TDirectDrawSurface; X, Y,
  Width, Height, PatternIndex, amp, Len, ph: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderWaveY(Self, X, Y, Width, Height, PatternIndex, rtDraw,
          Transparent, amp, Len, ph{$IFDEF DelphiX_Spt3}, $FF{$ENDIF});
      end
  end;
end;

procedure TPictureCollectionItem.DrawWaveYAdd(Dest: TDirectDrawSurface; X, Y,
  Width, Height, PatternIndex, amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderWaveY(Self, X, Y, Width, Height, PatternIndex, rtAdd,
          Transparent, amp, Len, ph, Alpha);
      end
  end;
end;

procedure TPictureCollectionItem.DrawWaveYAlpha(Dest: TDirectDrawSurface; X, Y,
  Width, Height, PatternIndex, amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderWaveY(Self, X, Y, Width, Height, PatternIndex, rtBlend,
          Transparent, amp, Len, ph, Alpha);
      end
  end;
end;

procedure TPictureCollectionItem.Finalize;
begin
  if FInitialized then
  begin
    FInitialized := False;
    ClearSurface;
  end;
end;

procedure TPictureCollectionItem.Initialize;
begin
  Finalize;
  FInitialized := PictureCollection.Initialized;
end;

procedure TPictureCollectionItem.Restore;

  function AddSurface(const SrcRect: TRect): TDirectDrawSurface;
  begin
    Result := TDirectDrawSurface.Create(PictureCollection.DXDraw.DDraw);
    FSurfaceList.Add(Result);

    Result.SystemMemory := FSystemMemory;
    Result.LoadFromGraphicRect(FPicture.Graphic, 0, 0, SrcRect);
    Result.TransparentColor := Result.ColorMatch(FTransparentColor);
  end;

var
  X, Y, X2, Y2: Integer;
  BlockWidth, BlockHeight, BlockXCount, BlockYCount: Integer;
  Width2, Height2: Integer;
begin
  if FPicture.Graphic = nil then
    Exit;

  if not FInitialized then
  begin
    if PictureCollection.Initialized then
      Initialize;
    if not FInitialized then
      Exit;
  end;

  ClearSurface;

  Width2 := Width + SkipWidth;
  Height2 := Height + SkipHeight;

  if (Width = FPicture.Width) and (Height = FPicture.Height) then
  begin
    {  There is no necessity of division because the number of patterns is one.   }
    with TPictureCollectionItemPattern.Create(FPatterns) do
    begin
      FRect := Bounds(0, 0, FPicture.Width, FPicture.Height);
      FSurface := AddSurface(Bounds(0, 0, FPicture.Width, FPicture.Height));
    end;
  end
  else if FSystemMemory then
  begin
    {  Load to a system memory.  }
    AddSurface(Bounds(0, 0, FPicture.Width, FPicture.Height));

    for Y := 0 to (FPicture.Height + SkipHeight) div Height2 - 1 do
      for X := 0 to (FPicture.Width + SkipWidth) div Width2 - 1 do
        with TPictureCollectionItemPattern.Create(FPatterns) do
        begin
          FRect := Bounds(X * Width2, Y * Height2, Width, Height);
          FSurface := TDirectDrawSurface(FSurfaceList[0]);
        end;
  end
  else
  begin
    {  Load to a video memory with dividing the image.   }
    BlockWidth := Min(((SurfaceDivWidth + Width2 - 1) div Width2) * Width2,
      (FPicture.Width + SkipWidth) div Width2 * Width2);
    BlockHeight := Min(((SurfaceDivHeight + Height2 - 1) div Height2) * Height2,
      (FPicture.Height + SkipHeight) div Height2 * Height2);

    if (BlockWidth = 0) or (BlockHeight = 0) then
      Exit;

    BlockXCount := (FPicture.Width + BlockWidth - 1) div BlockWidth;
    BlockYCount := (FPicture.Height + BlockHeight - 1) div BlockHeight;

    for Y := 0 to BlockYCount - 1 do
      for X := 0 to BlockXCount - 1 do
      begin
        X2 := Min(BlockWidth, Max(FPicture.Width - X * BlockWidth, 0));
        if X2 = 0 then
          X2 := BlockWidth;

        Y2 := Min(BlockHeight, Max(FPicture.Height - Y * BlockHeight, 0));
        if Y2 = 0 then
          Y2 := BlockHeight;

        AddSurface(Bounds(X * BlockWidth, Y * BlockHeight, X2, Y2));
      end;

    for Y := 0 to (FPicture.Height + SkipHeight) div Height2 - 1 do
      for X := 0 to (FPicture.Width + SkipWidth) div Width2 - 1 do
      begin
        X2 := X * Width2;
        Y2 := Y * Height2;
        with TPictureCollectionItemPattern.Create(FPatterns) do
        begin
          FRect := Bounds(X2 - (X2 div BlockWidth * BlockWidth), Y2 - (Y2 div BlockHeight * BlockHeight), Width, Height);
          FSurface := TDirectDrawSurface(FSurfaceList[(X2 div BlockWidth) + ((Y2 div BlockHeight) * BlockXCount)]);
        end;
      end;
  end;
  {Code added for better compatibility}
  {When is any picture changed, then all textures cleared and list have to reloaded}
  with PictureCollection do
    if (do3D in FDXDraw.Options) then
      if Assigned(FDXDraw.FD2D) then
        FDXDraw.FD2D.D2DTextures.D2DPruneAllTextures;
end;

procedure TPictureCollectionItem.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TPictureCollectionItem.SetTransparentColor(Value: TColor);
var
  i: Integer;
  Surface: TDirectDrawSurface;
begin
  if Value <> FTransparentColor then
  begin
    FTransparentColor := Value;
    for i := 0 to FSurfaceList.Count - 1 do
    begin
      try
        Surface := TDirectDrawSurface(FSurfaceList[i]);
        Surface.TransparentColor := Surface.ColorMatch(FTransparentColor);
      except
      end;
    end;
  end;
end;

procedure TPictureCollectionItem.DrawAlphaCol(Dest: TDirectDrawSurface;
  const DestRect: TRect; PatternIndex, Color, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderCol(Self, DestRect, PatternIndex, Color, rtBlend, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawAlpha(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateAddCol(Dest: TDirectDrawSurface;
  X, Y, Width, Height, PatternIndex: Integer; CenterX, CenterY: Double;
  Angle: single; Color, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderRotateModeCol(Self, rtAdd, X, Y, Width,
          Height, PatternIndex, CenterX, CenterY, Angle, Color, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateAdd(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateAlphaCol(Dest: TDirectDrawSurface;
  X, Y, Width, Height, PatternIndex: Integer; CenterX, CenterY: Double;
  Angle: single; Color, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderRotateModeCol(Self, rtBlend, X, Y, Width,
          Height, PatternIndex, CenterX, CenterY, Angle, Color, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateAlpha(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateSubCol(Dest: TDirectDrawSurface;
  X, Y, Width, Height, PatternIndex: Integer; CenterX, CenterY: Double;
  Angle: single; Color, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderRotateModeCol(Self, rtSub, X, Y, Width,
          Height, PatternIndex, CenterX, CenterY, Angle, Color, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateSub(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawCol(Dest: TDirectDrawSurface;
  const DestRect, SourceRect: TRect; PatternIndex: Integer; Faded: Boolean;
  RenderType: TRenderType; Color, Specular: Integer; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) and (FDXDraw.FD2D.FDDraw.FSurface = Dest) then
      begin
        FDXDraw.FD2D.D2DRenderColoredPartition(Self, DestRect, PatternIndex,
          Color, Specular, Faded, SourceRect, RenderType,
          Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawAlpha(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

{  TPictureCollection  }

constructor TPictureCollection.Create(AOwner: TPersistent);
begin
  inherited Create(TPictureCollectionItem);
  FOwner := AOwner;
end;

destructor TPictureCollection.Destroy;
begin
  Finalize;
  inherited Destroy;
end;

function TPictureCollection.GetItem(Index: Integer): TPictureCollectionItem;
begin
  Result := TPictureCollectionItem(inherited Items[Index]);
end;

function TPictureCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TPictureCollection.Find(const Name: string): TPictureCollectionItem;
var
  i: Integer;
begin
  i := IndexOf(Name);
  if i = -1 then
    raise EPictureCollectionError.CreateFmt(SImageNotFound, [Name]);
  Result := Items[i];
end;

procedure TPictureCollection.Finalize;
var
  i: Integer;
begin
  try
    for i := 0 to Count - 1 do
      Items[i].Finalize;
  finally
    FDXDraw := nil;
  end;
end;

procedure TPictureCollection.Initialize(DXDraw: TCustomDXDraw);
var
  i: Integer;
begin
  Finalize;
  FDXDraw := DXDraw;

  if not Initialized then
    raise EPictureCollectionError.CreateFmt(SCannotInitialized, [ClassName]);

  for i := 0 to Count - 1 do
    Items[i].Initialize;
end;

function TPictureCollection.Initialized: Boolean;
begin
  Result := (FDXDraw <> nil) and (FDXDraw.Initialized);
end;

procedure TPictureCollection.Restore;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Restore;
end;

procedure TPictureCollection.MakeColorTable;
var
  UseColorTable: array[0..255] of Boolean;
  PaletteCount: Integer;

  procedure SetColor(Index: Integer; Col: TRGBQuad);
  begin
    UseColorTable[Index] := True;
    ColorTable[Index] := Col;
    Inc(PaletteCount);
  end;

  procedure AddColor(Col: TRGBQuad);
  var
    i: Integer;
  begin
    for i := 0 to 255 do
      if UseColorTable[i] then
        if DWORD(ColorTable[i]) = DWORD(Col) then
          Exit;
    for i := 0 to 255 do
      if not UseColorTable[i] then
      begin
        SetColor(i, Col);
        Exit;
      end;
  end;

  procedure AddDIB(DIB: TDIB);
  var
    i: Integer;
  begin
    if DIB.BitCount > 8 then
      Exit;

    for i := 0 to 255 do
      AddColor(DIB.ColorTable[i]);
  end;

  procedure AddGraphic(Graphic: TGraphic);
  var
    i, n: Integer;
    PaletteEntries: TPaletteEntries;
  begin
    if Graphic.Palette <> 0 then
    begin
      n := GetPaletteEntries(Graphic.Palette, 0, 256, PaletteEntries);
      for i := 0 to n - 1 do
        AddColor(PaletteEntryToRGBQuad(PaletteEntries[i]));
    end;
  end;

var
  i: Integer;
begin
  FillChar(UseColorTable, SizeOf(UseColorTable), 0);
  FillChar(ColorTable, SizeOf(ColorTable), 0);

  PaletteCount := 0;

  {  The system color is included.  }
  SetColor(0, RGBQuad(0, 0, 0));
  SetColor(1, RGBQuad(128, 0, 0));
  SetColor(2, RGBQuad(0, 128, 0));
  SetColor(3, RGBQuad(128, 128, 0));
  SetColor(4, RGBQuad(0, 0, 128));
  SetColor(5, RGBQuad(128, 0, 128));
  SetColor(6, RGBQuad(0, 128, 128));
  SetColor(7, RGBQuad(192, 192, 192));

  SetColor(248, RGBQuad(128, 128, 128));
  SetColor(249, RGBQuad(255, 0, 0));
  SetColor(250, RGBQuad(0, 255, 0));
  SetColor(251, RGBQuad(255, 255, 0));
  SetColor(252, RGBQuad(0, 0, 255));
  SetColor(253, RGBQuad(255, 0, 255));
  SetColor(254, RGBQuad(0, 255, 255));
  SetColor(255, RGBQuad(255, 255, 255));

  for i := 0 to Count - 1 do
    if Items[i].Picture.Graphic <> nil then
    begin
      if Items[i].Picture.Graphic is TDIB then
        AddDIB(TDIB(Items[i].Picture.Graphic))
      else
        AddGraphic(Items[i].Picture.Graphic);
      if PaletteCount = 256 then
        Break;
    end;
end;

procedure TPictureCollection.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('ColorTable', ReadColorTable, WriteColorTable, True);
end;

type
  TPictureCollectionComponent = class(TComponent)
  private
    FList: TPictureCollection;
  published
    property List: TPictureCollection read FList write FList;
  end;

procedure TPictureCollection.LoadFromFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TPictureCollection.LoadFromStream(Stream: TStream);
var
  Component: TPictureCollectionComponent;
begin
  Clear;
  Component := TPictureCollectionComponent.Create(nil);
  try
    Component.FList := Self;
    Stream.ReadComponentRes(Component);

    if Initialized then
    begin
      Initialize(FDXDraw);
      Restore;
    end;
  finally
    Component.Free;
  end;
end;

procedure TPictureCollection.SaveToFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TPictureCollection.SaveToStream(Stream: TStream);
var
  Component: TPictureCollectionComponent;
begin
  Component := TPictureCollectionComponent.Create(nil);
  try
    Component.FList := Self;
    Stream.WriteComponentRes('DelphiXPictureCollection', Component);
  finally
    Component.Free;
  end;
end;

procedure TPictureCollection.ReadColorTable(Stream: TStream);
begin
  Stream.ReadBuffer(ColorTable, SizeOf(ColorTable));
end;

procedure TPictureCollection.WriteColorTable(Stream: TStream);
begin
  Stream.WriteBuffer(ColorTable, SizeOf(ColorTable));
end;

{  TCustomDXImageList  }

constructor TCustomDXImageList.Create(AOnwer: TComponent);
begin
  inherited Create(AOnwer);
  FItems := TPictureCollection.Create(Self);
end;

destructor TCustomDXImageList.Destroy;
begin
  DXDraw := nil;
  FItems.Free;
  inherited Destroy;
end;

procedure TCustomDXImageList.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (DXDraw = AComponent) then
    DXDraw := nil;
end;

procedure TCustomDXImageList.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
begin
  case NotifyType of
    dxntDestroying: DXDraw := nil;
    dxntInitialize: FItems.Initialize(Sender);
    dxntFinalize: FItems.Finalize;
    dxntRestore: FItems.Restore;
  end;
end;

procedure TCustomDXImageList.SetDXDraw(Value: TCustomDXDraw);
begin
  if FDXDraw <> nil then
    FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);

  FDXDraw := Value;

  if FDXDraw <> nil then
    FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
end;

procedure TCustomDXImageList.SetItems(Value: TPictureCollection);
begin
  FItems.Assign(Value);
end;

{  TDirectDrawOverlay  }

constructor TDirectDrawOverlay.Create(DDraw: TDirectDraw; TargetSurface: TDirectDrawSurface);
begin
  inherited Create;
  FDDraw := DDraw;
  FTargetSurface := TargetSurface;
  FVisible := True;
end;

constructor TDirectDrawOverlay.CreateWindowed(WindowHandle: HWND);
const
  PrimaryDesc: TDDSurfaceDesc = (
    dwSize: SizeOf(PrimaryDesc);
    dwFlags: DDSD_CAPS;
    ddsCaps: (dwCaps: DDSCAPS_PRIMARYSURFACE)
    );
begin
  FDDraw2 := TDirectDraw.CreateEx(nil, False);
  if FDDraw2.IDraw.SetCooperativeLevel(WindowHandle, DDSCL_NORMAL) <> DD_OK then
    raise EDirectDrawOverlayError.CreateFmt(SCannotInitialized, [SOverlay]);

  FTargetSurface2 := TDirectDrawSurface.Create(FDDraw2);
  if not FTargetSurface2.CreateSurface(PrimaryDesc) then
    raise EDirectDrawOverlayError.CreateFmt(SCannotInitialized, [SOverlay]);

  Create(FDDraw2, FTargetSurface2);
end;

destructor TDirectDrawOverlay.Destroy;
begin
  Finalize;
  FTargetSurface2.Free;
  FDDraw2.Free;
  inherited Destroy;
end;

procedure TDirectDrawOverlay.Finalize;
begin
  FBackSurface.Free;
  FBackSurface := nil;
  FSurface.Free;
  FSurface := nil;
end;

procedure TDirectDrawOverlay.Initialize(const SurfaceDesc: TDDSurfaceDesc);
const
  BackBufferCaps: TDDSCaps = (dwCaps: DDSCAPS_BACKBUFFER);
var
  DDSurface: IDirectDrawSurface;
begin
  Finalize;
  try
    FSurface := TDirectDrawSurface.Create(FDDraw);
    if not FSurface.CreateSurface(SurfaceDesc) then
      raise EDirectDrawOverlayError.CreateFmt(SCannotInitialized, [SOverlay]);

    FBackSurface := TDirectDrawSurface.Create(FDDraw);

    if SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_FLIP <> 0 then
    begin
      if FSurface.ISurface.GetAttachedSurface(BackBufferCaps, DDSurface) = DD_OK then
        FBackSurface.IDDSurface := DDSurface;
    end
    else
      FBackSurface.IDDSurface := FSurface.IDDSurface;

    if FVisible then
      SetOverlayRect(FOverlayRect)
    else
      FSurface.ISurface.UpdateOverlay(PRect(nil), FTargetSurface.ISurface, PRect(nil), DDOVER_HIDE, PDDOverlayFX(nil));
  except
    Finalize;
    raise;
  end;
end;

procedure TDirectDrawOverlay.Flip;
begin
  if FSurface = nil then
    Exit;

  if FSurface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_FLIP <> 0 then
    FSurface.ISurface.Flip(nil, DDFLIP_WAIT);
end;

procedure TDirectDrawOverlay.SetOverlayColorKey(Value: TColor);
begin
  FOverlayColorKey := Value;
  if FSurface <> nil then
    SetOverlayRect(FOverlayRect);
end;

procedure TDirectDrawOverlay.SetOverlayRect(const Value: TRect);
var
  DestRect, SrcRect: TRect;
  XScaleRatio, YScaleRatio: Integer;
  OverlayFX: TDDOverlayFX;
  OverlayFlags: DWORD;
begin
  FOverlayRect := Value;
  if (FSurface <> nil) and FVisible then
  begin
    DestRect := FOverlayRect;
    SrcRect.Left := 0;
    SrcRect.Top := 0;
    SrcRect.Right := FSurface.SurfaceDesc.dwWidth;
    SrcRect.Bottom := FSurface.SurfaceDesc.dwHeight;

    OverlayFlags := DDOVER_SHOW;

    FillChar(OverlayFX, SizeOf(OverlayFX), 0);
    OverlayFX.dwSize := SizeOf(OverlayFX);

    {  Scale rate limitation  }
    XScaleRatio := (DestRect.Right - DestRect.Left) * 1000 div (SrcRect.Right - SrcRect.Left);
    YScaleRatio := (DestRect.Bottom - DestRect.Top) * 1000 div (SrcRect.Bottom - SrcRect.Top);

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH <> 0) and
      (FDDraw.DriverCaps.dwMinOverlayStretch <> 0) and (XScaleRatio < Integer(FDDraw.DriverCaps.dwMinOverlayStretch)) then
    begin
      DestRect.Right := DestRect.Left + (Integer(FSurface.SurfaceDesc.dwWidth) * (Integer(FDDraw.DriverCaps.dwMinOverlayStretch) + 1)) div 1000;
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH <> 0) and
      (FDDraw.DriverCaps.dwMaxOverlayStretch <> 0) and (XScaleRatio > Integer(FDDraw.DriverCaps.dwMaxOverlayStretch)) then
    begin
      DestRect.Right := DestRect.Left + (Integer(FSurface.SurfaceDesc.dwWidth) * (Integer(FDDraw.DriverCaps.dwMaxOverlayStretch) + 999)) div 1000;
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH <> 0) and
      (FDDraw.DriverCaps.dwMinOverlayStretch <> 0) and (YScaleRatio < Integer(FDDraw.DriverCaps.dwMinOverlayStretch)) then
    begin
      DestRect.Bottom := DestRect.Top + (Integer(FSurface.SurfaceDesc.dwHeight) * (Integer(FDDraw.DriverCaps.dwMinOverlayStretch) + 1)) div 1000;
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH <> 0) and
      (FDDraw.DriverCaps.dwMaxOverlayStretch <> 0) and (YScaleRatio > Integer(FDDraw.DriverCaps.dwMaxOverlayStretch)) then
    begin
      DestRect.Bottom := DestRect.Top + (Integer(FSurface.SurfaceDesc.dwHeight) * (Integer(FDDraw.DriverCaps.dwMaxOverlayStretch) + 999)) div 1000;
    end;

    {  Clipping at forwarding destination  }
    XScaleRatio := (DestRect.Right - DestRect.Left) * 1000 div (SrcRect.Right - SrcRect.Left);
    YScaleRatio := (DestRect.Bottom - DestRect.Top) * 1000 div (SrcRect.Bottom - SrcRect.Top);

    if DestRect.Top < 0 then
    begin
      SrcRect.Top := -DestRect.Top * 1000 div YScaleRatio;
      DestRect.Top := 0;
    end;

    if DestRect.Left < 0 then
    begin
      SrcRect.Left := -DestRect.Left * 1000 div XScaleRatio;
      DestRect.Left := 0;
    end;

    if DestRect.Right > Integer(FTargetSurface.SurfaceDesc.dwWidth) then
    begin
      SrcRect.Right := Integer(FSurface.SurfaceDesc.dwWidth) - ((DestRect.Right - Integer(FTargetSurface.SurfaceDesc.dwWidth)) * 1000 div XScaleRatio);
      DestRect.Right := FTargetSurface.SurfaceDesc.dwWidth;
    end;

    if DestRect.Bottom > Integer(FTargetSurface.SurfaceDesc.dwHeight) then
    begin
      SrcRect.Bottom := Integer(FSurface.SurfaceDesc.dwHeight) - ((DestRect.Bottom - Integer(FTargetSurface.SurfaceDesc.dwHeight)) * 1000 div YScaleRatio);
      DestRect.Bottom := FTargetSurface.SurfaceDesc.dwHeight;
    end;

    {  Forwarding former arrangement  }
    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNBOUNDARYSRC <> 0) and (FDDraw.DriverCaps.dwAlignBoundarySrc <> 0) then
    begin
      SrcRect.Left := (SrcRect.Left + Integer(FDDraw.DriverCaps.dwAlignBoundarySrc) div 2) div
        Integer(FDDraw.DriverCaps.dwAlignBoundarySrc) * Integer(FDDraw.DriverCaps.dwAlignBoundarySrc);
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNSIZESRC <> 0) and (FDDraw.DriverCaps.dwAlignSizeSrc <> 0) then
    begin
      SrcRect.Right := SrcRect.Left + (SrcRect.Right - SrcRect.Left + Integer(FDDraw.DriverCaps.dwAlignSizeSrc) div 2) div
        Integer(FDDraw.DriverCaps.dwAlignSizeSrc) * Integer(FDDraw.DriverCaps.dwAlignSizeSrc);
    end;

    {  Forwarding destination arrangement  }
    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNBOUNDARYDEST <> 0) and (FDDraw.DriverCaps.dwAlignBoundaryDest <> 0) then
    begin
      DestRect.Left := (DestRect.Left + Integer(FDDraw.DriverCaps.dwAlignBoundaryDest) div 2) div
        Integer(FDDraw.DriverCaps.dwAlignBoundaryDest) * Integer(FDDraw.DriverCaps.dwAlignBoundaryDest);
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNSIZEDEST <> 0) and (FDDraw.DriverCaps.dwAlignSizeDest <> 0) then
    begin
      DestRect.Right := DestRect.Left + (DestRect.Right - DestRect.Left) div
        Integer(FDDraw.DriverCaps.dwAlignSizeDest) * Integer(FDDraw.DriverCaps.dwAlignSizeDest);
    end;

    {  Color key setting  }
    if FDDraw.DriverCaps.dwCKeyCaps and DDCKEYCAPS_DESTOVERLAY <> 0 then
    begin
      OverlayFX.dckDestColorkey.dwColorSpaceLowValue := FTargetSurface.ColorMatch(FOverlayColorKey);
      OverlayFX.dckDestColorkey.dwColorSpaceHighValue := OverlayFX.dckDestColorkey.dwColorSpaceLowValue;

      OverlayFlags := OverlayFlags or (DDOVER_KEYDESTOVERRIDE or DDOVER_DDFX);
    end;

    FSurface.ISurface.UpdateOverlay(@SrcRect, FTargetSurface.ISurface, @DestRect, OverlayFlags, @OverlayFX);
  end;
end;

procedure TDirectDrawOverlay.SetVisible(Value: Boolean);
begin
  FVisible := False;
  if FSurface <> nil then
  begin
    if FVisible then
      SetOverlayRect(FOverlayRect)
    else
      FSurface.ISurface.UpdateOverlay(PRect(nil), FTargetSurface.ISurface, PRect(nil), DDOVER_HIDE, PDDOverlayFX(nil));
  end;
end;

{ TDXFont }

constructor TDXFont.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDXFont.Destroy;
begin
  inherited Destroy;
end;

procedure TDXFont.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDXImageList) then
  begin
    FDXImageList := nil;
  end;
end; {Notification}

procedure TDXFont.SetFont(const Value: string);
begin
  FFont := Value;
  if Assigned(FDXImageList) then
  begin
    FFontIndex := FDXImageList.Items.IndexOf(FFont); { find font once }
    FOffset := FDXImageList.Items[FFontIndex].PatternWidth;
  end;
end;

procedure TDXFont.SetFontIndex(const Value: Integer);
begin
  FFontIndex := Value;
  if Assigned(FDXImageList) then
  begin
    FFont := FDXImageList.Items[FFontIndex].Name;
    FOffset := FDXImageList.Items[FFontIndex].PatternWidth;
  end;
end;

procedure TDXFont.TextOut(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string);
var
  Loop, letter: Integer;
  UpperText: string;
begin
  if not Assigned(FDXImageList) then
    Exit;
  Offset := FDXImageList.Items[FFontIndex].PatternWidth;
  UpperText := AnsiUpperCase(Text);
  for Loop := 1 to Length(UpperText) do
  begin
    letter := AnsiPos(UpperText[Loop], Alphabet) - 1;
    if letter < 0 then
      letter := 30;
    FDXImageList.Items[FFontIndex].Draw(DirectDrawSurface, X + Offset * Loop, Y, letter);
  end; { loop }
end;

{ TDXPowerFontEffectsParameters }

procedure TDXPowerFontEffectsParameters.SetAlphaValue(
  const Value: Integer);
begin
  FAlphaValue := Value;
end;

procedure TDXPowerFontEffectsParameters.SetAngle(const Value: Integer);
begin
  FAngle := Value;
end;

procedure TDXPowerFontEffectsParameters.SetCenterX(const Value: Integer);
begin
  FCenterX := Value;
end;

procedure TDXPowerFontEffectsParameters.SetCenterY(const Value: Integer);
begin
  FCenterY := Value;
end;

procedure TDXPowerFontEffectsParameters.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TDXPowerFontEffectsParameters.SetWAmplitude(
  const Value: Integer);
begin
  FWAmplitude := Value;
end;

procedure TDXPowerFontEffectsParameters.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

procedure TDXPowerFontEffectsParameters.SetWLenght(const Value: Integer);
begin
  FWLenght := Value;
end;

procedure TDXPowerFontEffectsParameters.SetWPhase(const Value: Integer);
begin
  FWPhase := Value;
end;

{ TDXPowerFont }

constructor TDXPowerFont.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUseEnterChar := True;
  FEnterCharacter := '|<';
  FAlphabets := PowerAlphabet;
  FTextOutType := ttNormal;
  FTextOutEffect := teNormal;
  FEffectsParameters := TDXPowerFontEffectsParameters.Create;
end;

destructor TDXPowerFont.Destroy;
begin
  inherited Destroy;
end;

procedure TDXPowerFont.SetAlphabets(const Value: string);
begin
  if FDXImageList <> nil then
    if Length(Value) > FDXImageList.Items[FFontIndex].PatternCount - 1 then
      Exit;
  FAlphabets := Value;
end;

procedure TDXPowerFont.SetEnterCharacter(const Value: string);
begin
  if Length(Value) >= 2 then
    Exit;
  FEnterCharacter := Value;
end;

procedure TDXPowerFont.SetFont(const Value: string);
begin
  FFont := Value;
  if FDXImageList <> nil then
  begin
    FFontIndex := FDXImageList.Items.IndexOf(FFont); // Find font once...
    Offset := FDXImageList.Items[FFontIndex].PatternWidth;

    FEffectsParameters.Width := FDXImageList.Items[FFontIndex].PatternWidth;
    FEffectsParameters.Height := FDXImageList.Items[FFontIndex].PatternHeight;
  end;
end;

procedure TDXPowerFont.SetFontIndex(const Value: Integer);
begin
  FFontIndex := Value;
  if FDXImageList <> nil then
  begin
    FFont := FDXImageList.Items[FFontIndex].Name;
    Offset := FDXImageList.Items[FFontIndex].PatternWidth;

    FEffectsParameters.Width := FDXImageList.Items[FFontIndex].PatternWidth;
    FEffectsParameters.Height := FDXImageList.Items[FFontIndex].PatternHeight;
  end;
end;

procedure TDXPowerFont.SetEffectsParameters(const Value: TDXPowerFontEffectsParameters);
begin
  FEffectsParameters := Value;
end;

procedure TDXPowerFont.SetTextOutEffect(const Value: TDXPowerFontTextOutEffect);
begin
  FTextOutEffect := Value;
end;

procedure TDXPowerFont.SetTextOutType(const Value: TDXPowerFontTextOutType);
begin
  FTextOutType := Value;
end;

procedure TDXPowerFont.SetUseEnterChar(const Value: Boolean);
begin
  FUseEnterChar := Value;
end;

function TDXPowerFont.TextOutFast(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
var
  Loop, letter: Integer;
  txt: string;
begin
  Result := False;
  if FDXImageList = nil then
    Exit;
  // modified
  case FTextOutType of
    ttNormal: txt := Text;
    ttUpperCase: txt := AnsiUpperCase(Text);
    ttLowerCase: txt := AnsiLowerCase(Text);
  end;
  Offset := FDXImageList.Items[FFontIndex].PatternWidth;
  Loop := 1;
  while (Loop <= Length(Text)) do
  begin
    letter := AnsiPos(txt[Loop], FAlphabets); // modified
    if (letter > 0) and (letter < FDXImageList.Items[FFontIndex].PatternCount - 1) then
      FDXImageList.Items[FFontIndex].Draw(DirectDrawSurface, X + (Offset * Loop), Y, letter - 1);
    Inc(Loop);
  end;
  Result := True;
end;

function TDXPowerFont.TextOut(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
var
  Loop, letter: Integer;
  FCalculatedEnters, EnterHeghit, XLoop: Integer;
  DoTextOut: Boolean;
  txt: string;
  Rect: TRect;
begin
  Result := False;
  if FDXImageList = nil then
    Exit;
  txt := Text;
  DoTextOut := True;
  if Assigned(FBeforeTextOut) then
    FBeforeTextOut(Self, txt, DoTextOut);
  if not DoTextOut then
    Exit;
  // modified
  case FTextOutType of
    ttNormal: txt := Text;
    ttUpperCase: txt := AnsiUpperCase(Text);
    ttLowerCase: txt := AnsiLowerCase(Text);
  end;
  Offset := FDXImageList.Items[FFontIndex].PatternWidth;
  FCalculatedEnters := 0;
  EnterHeghit := FDXImageList.Items[FFontIndex].PatternHeight;
  XLoop := 0;
  Loop := 1;
  while (Loop <= Length(txt)) do
  begin
    if FUseEnterChar then
    begin
      if txt[Loop] = FEnterCharacter[1] then
      begin
        Inc(FCalculatedEnters);
        Inc(Loop);
      end;
      if txt[Loop] = FEnterCharacter[2] then
      begin
        Inc(FCalculatedEnters);
        XLoop := 0; {-FCalculatedEnters;}
        Inc(Loop);
      end;
    end;
    letter := AnsiPos(txt[Loop], FAlphabets); // modified

    if (letter > 0) and (letter < FDXImageList.Items[FFontIndex].PatternCount - 1) then
      case FTextOutEffect of
        teNormal: FDXImageList.Items[FFontIndex].Draw(DirectDrawSurface, X + (Offset * XLoop), Y + (FCalculatedEnters * EnterHeghit), letter - 1);
        teRotat: FDXImageList.Items[FFontIndex].DrawRotate(DirectDrawSurface, X + (Offset * XLoop), Y + (FCalculatedEnters * EnterHeghit), FEffectsParameters.Width, FEffectsParameters.Height, letter - 1, FEffectsParameters.CenterX, FEffectsParameters.CenterY, FEffectsParameters.Angle);
        teAlphaBlend:
          begin
            Rect.Left := X + (Offset * XLoop);
            Rect.Top := Y + (FCalculatedEnters * EnterHeghit);
            Rect.Right := Rect.Left + FEffectsParameters.Width;
            Rect.Bottom := Rect.Top + FEffectsParameters.Height;

            FDXImageList.Items[FFontIndex].DrawAlpha(DirectDrawSurface, Rect, letter - 1, FEffectsParameters.AlphaValue);
          end;
        teWaveX: FDXImageList.Items[FFontIndex].DrawWaveX(DirectDrawSurface, X + (Offset * XLoop), Y + (FCalculatedEnters * EnterHeghit), FEffectsParameters.Width, FEffectsParameters.Height, letter - 1, FEffectsParameters.WAmplitude, FEffectsParameters.WLenght, FEffectsParameters.WPhase);
      end;
    Inc(Loop);
    Inc(XLoop);
  end;
  if Assigned(FAfterTextOut) then
    FAfterTextOut(Self, txt);
  Result := True;
end;

//---------------------------------------------------------------------------
{
Main code supported hardware acceleration by videoadapteur
 *  Copyright (c) 2004-2006 Jaro Benes
 *  All Rights Reserved
 *  Version 1.07
 *  D2D Hardware module - main implementation part
 *  web site: www.micrel.cz/Dx
 *  e-mail: delphix_d2d@micrel.cz
}

constructor TD2DTextures.Create(DDraw: TCustomDXDraw);
begin
  //inherited;
  FDDraw := DDraw; //reload DDraw
{$IFNDEF DelphiX_Delphi3}
  SetLength(Texture, 0);
{$ELSE}
  TexLen := 0;
  Texture := nil;
{$ENDIF}
end;

destructor TD2DTextures.Destroy;
var
  i: Integer;
begin
  if Assigned(Texture) then
{$IFDEF DelphiX_Spt4}
    for i := Low(Texture) to High(Texture) do
    begin
      Texture[i].D2DTexture.Free;
      if Assigned(Texture[i].VDIB) then
        Texture[i].VDIB.Free;
    end;
{$ELSE}
    for i := 0 to TexLen - 1 do
    begin
      Texture[i].D2DTexture.Free;
      if Assigned(Texture[i].VDIB) then
        Texture[i].VDIB.Free;
    end;
{$ENDIF}
  inherited;
end;

function TD2DTextures.GetD2DMaxTextures: Integer;
begin
  Result := {$IFNDEF DelphiX_Delphi3}Length(Texture){$ELSE}TexLen{$ENDIF};
end;

procedure TD2DTextures.SetD2DMaxTextures(const Value: Integer);
begin
  if Value > 0 then
{$IFNDEF DelphiX_Delphi3}
    SetLength(Texture, Value)
{$ELSE}
    Inc(TexLen);
  if Texture = nil then
    Texture := AllocMem(SizeOf(TTextureRec))
  else
  begin
    {alokuj pamet}
    ReAllocMem(Texture, TexLen * SizeOf(TTextureRec));
  end;
{$ENDIF}
end;

function TD2DTextures.Find(byName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  if Texture <> nil then
{$IFNDEF DelphiX_Delphi3}
    if Length(Texture) > 0 then
      for i := Low(Texture) to High(Texture) do
        if AnsiUpperCase(Texture[i].Name) = AnsiUpperCase(byName) then
        begin
          Result := i;
          Exit;
        end;
{$ELSE}
    if TexLen > 0 then
      for i := 0 to TexLen - 1 do
        if AnsiUpperCase(Texture[i].Name) = AnsiUpperCase(byName) then
        begin
          Result := i;
          Exit;
        end;
{$ENDIF}
end;

function TD2DTextures.GetTextureByName(const byName: string): TDirect3DTexture2;
begin
  Result := nil;
  if Assigned(Texture) then
    Result := Texture[Find(byName)].D2DTexture;
end;

function TD2DTextures.GetTextureByIndex(const byIndex: Integer): TDirect3DTexture2;
begin
  Result := nil;
{$IFDEF DelphiX_Spt4}
  if Assigned(Texture) and (byIndex in [0..High(Texture)]) then
    Result := Texture[byIndex].D2DTexture;
{$ELSE}
  if Assigned(Texture) and (byIndex >= 0) and (byIndex <= (TexLen - 1)) then
    Result := Texture[byIndex].D2DTexture;
{$ENDIF}
end;

function TD2DTextures.GetTextureNameByIndex(const byIndex: Integer): string;
begin
  Result := '';
{$IFDEF DelphiX_Spt4}
  if Assigned(Texture) and (byIndex in [0..High(Texture)]) then
    Result := Texture[byIndex].Name;
{$ELSE}
  if Assigned(Texture) and (byIndex >= 0) and (byIndex <= (TexLen - 1)) then
    Result := Texture[byIndex].Name;
{$ENDIF}
end;

function TD2DTextures.Count: Integer;
begin
  Result := 0;
  if Assigned(Texture) then
{$IFDEF DelphiX_Spt4}
    Result := High(Texture) + 1;
{$ELSE}
    Result := TexLen;
{$ENDIF}
end;

procedure TD2DTextures.D2DPruneAllTextures;
var
  i: Integer;
begin
{$IFNDEF DelphiX_Delphi3}
  for i := Low(Texture) to High(Texture) do
{$ELSE}
  for i := 0 to TexLen - 1 do
{$ENDIF}begin
    Texture[i].D2DTexture.Free;
    if Assigned(Texture[i].VDIB) then
      Texture[i].VDIB.Free;
  end;
{$IFNDEF DelphiX_Delphi3}
  SetLength(Texture, 0);
{$ELSE}
  TexLen := 0;
{$ENDIF}
end;
{
procedure TD2DTextures.D2DFreeTextures;
var
  i: Integer;
begin
$IFNDEF DelphiX_Delphi3
  for i := Low(Texture) to High(Texture) do
$ELSE
  for i := 0 to TexLen - 1 do
$ENDIF
  begin
    Texture[i].D2DTexture.Free;
    if Assigned(Texture[i].VDIB) then
      Texture[i].VDIB.Free;
  end;
$IFDEF DelphiX_Delphi3
  FreeMem(Texture, TexLen * SizeOf(TTextureRec));
  Texture := nil;
$ENDIF
end;
}
procedure TD2DTextures.D2DPruneTextures;
begin
  if {$IFNDEF DelphiX_Delphi3}Length(Texture){$ELSE}TexLen{$ENDIF} > maxTexBlock then
  begin
    D2DPruneAllTextures
  end;
end;

procedure TD2DTextures.SizeAdjust(var DIB: TDIB; var FloatX1, FloatY1, FloatX2, FloatY2: Double);
var
  X, Y: Integer;
  tempDIB: TDIB;
begin {auto-adjust size n^2 for accelerator compatibility}
  X := 1;
  repeat
    X := X * 2;
  until DIB.Width <= X;
  Y := 1;
  repeat
    Y := Y * 2
  until DIB.Height <= Y;
{$IFDEF FORCE_SQUARE}
  X := Max(X, Y);
  Y := X;
{$ENDIF}
  if (X = DIB.Width) and (Y = DIB.Height) then
  begin
    if DIB.BitCount = 32 then
      Exit; {do not touch}
    {code for correction a DIB.BitCount to 24 bit only}
    tempDIB := TDIB.Create;
    try
      tempDIB.SetSize(X, Y, 24);
      tempDIB.Canvas.Draw(0, 0, DIB);
      DIB.Assign(tempDIB);
    finally
      tempDIB.Free;
    end;
    Exit;
  end;
  tempDIB := TDIB.Create;
  try
    if DIB.BitCount = 32 then
    begin
      tempDIB.SetSize(X, Y, 32);
      tempDIB.Canvas.Brush.Color := clBlack;
      tempDIB.Canvas.FillRect(Bounds(0, 0, X, Y));
      tempDIB.Canvas.Draw(0, 0, DIB);
      //      if DIB.HasAlphaChannel then
      //        tempDIB.AssignAlphaChannel(DIB);
    end
    else
    begin
      tempDIB.SetSize(X, Y, 24 {DIB.BitCount}); {bad value for some 16}
      tempDIB.Canvas.Brush.Color := clBlack;
      tempDIB.Canvas.FillRect(Bounds(0, 0, X, Y));
      tempDIB.Canvas.Draw(0, 0, DIB);
    end;
    FloatX2 := (1 / tempDIB.Width) * DIB.Width;
    FloatY2 := (1 / tempDIB.Height) * DIB.Height;
    DIB.Assign(tempDIB);
  finally
    tempDIB.Free;
  end
end;

function TD2DTextures.CanFindTexture(aImage: TPictureCollectionItem): Boolean;
var
  i: Integer;
begin
  Result := True;
{$IFNDEF DelphiX_Delphi3}
  if Length(Texture) > 0 then
{$ELSE}
  if TexLen > 0 then
{$ENDIF}
    for i := 0 to D2DMaxTextures - 1 do
      if Texture[i].Name = aImage.Name then
        Exit;
  Result := False;
end;

function TD2DTextures.LoadTextures(aImage: TPictureCollectionItem): Boolean;
var
  //DIB: TDIB;
  T: TDXTextureImage;
begin
  Result := True;
  try
    D2DPruneTextures; {up to maxTexBlock textures only}
    D2DMaxTextures := D2DMaxTextures + 1;
    if aImage.Name = '' then // FIX: OPTIMIZED
      aImage.Name := aImage.GetNamePath; {this name is supplement name, when wasn't aImage.Name fill}
    Texture[D2DMaxTextures - 1].VDIB := TDIB.Create;
    //try
    with Texture[D2DMaxTextures - 1] do
    begin
      VDIB.Assign(aImage.Picture.Graphic);
      VDIB.Transparent := aImage.Transparent;
      FloatX1 := 0;
      FloatY1 := 0;
      FloatX2 := 1;
      FloatY2 := 1;
      SizeAdjust(VDIB, FloatX1, FloatY1, FloatX2, FloatY2);
      Name := aImage.Name;
      Width := VDIB.Width;
      Height := VDIB.Height;
      if VDIB.HasAlphaChannel then
      begin
        dib2dxt(VDIB, T);
        T.ImageName := aImage.Name;
        T.Transparent := aImage.Transparent;
        D2DTexture := TDirect3DTexture2.Create(FDDraw, T, False);
        D2DTexture.Transparent := aImage.Transparent;
        AlphaChannel := True;
        T.Free;
      end
      else
      begin
        D2DTexture := TDirect3DTexture2.Create(FDDraw, VDIB, False);
        D2DTexture.TransparentColor := DWORD(aImage.TransparentColor);
        D2DTexture.Surface.TransparentColor := DWORD(aImage.TransparentColor);
        D2DTexture.Transparent := aImage.Transparent;
        AlphaChannel := False;
      end;
    end;
    //finally
    //  DIB.Free;
    //end;
  except
    D2DMaxTextures := D2DMaxTextures - 1;
    Result := False;
  end;
end;

{$IFDEF DelphiX_Spt4}

function TD2DTextures.CanFindTexture(const TexName: string): Boolean;
{$ELSE}

function TD2DTextures.CanFindTexture2(const TexName: string): Boolean;
{$ENDIF}
var
  i: Integer;
begin
  Result := True;
{$IFDEF DelphiX_Spt4}
  if Length(Texture) > 0 then
{$ELSE}
  if TexLen > 0 then
{$ENDIF}
    for i := 0 to D2DMaxTextures - 1 do
      if Texture[i].Name = TexName then
        Exit;
  Result := False;
end;

function TD2DTextures.SetTransparentColor(dds: TDirectDrawSurface; PixelColor: Integer; Transparent: Boolean): Integer;
{Give a speculative transparent color value from DDS}
var
  ddck: TDDColorKey;
  CLL: Integer;
begin
  Result := 0;
  if dds.IDDSurface <> nil then
    if dds.ISurface.GetColorKey(DDCKEY_SRCBLT, ddck) = DD_OK then
      Result := ddck.dwColorSpaceLowValue;
  CLL := PixelColor; {have to pick up color from 0,0 pix of DIB}
  if Transparent then {and must be transparent}
    if (CLL <> Result) then {when different}
      Result := CLL; {use our TransparentColor}
end;
{$IFDEF DelphiX_Spt4}

function TD2DTextures.LoadTextures(dds: TDirectDrawSurface; Transparent: Boolean; asTexName: string): Boolean;
{$ELSE}

function TD2DTextures.LoadTextures2(dds: TDirectDrawSurface; Transparent: Boolean; asTexName: string): Boolean;
{$ENDIF}
var
  Col: Integer;
  T: PTextureRec;
begin
  Result := True;
  T := nil;
  try
    if dds.Modified then
    begin
      {search existing texture and return the pointer}
      T := Addr(Texture[Find(asTexName)]);
    end
    else
    begin
      D2DPruneTextures; {up to maxTexBlock textures only}
      {next to new space}
      D2DMaxTextures := D2DMaxTextures + 1;
      {is new place}
      T := Addr(Texture[D2DMaxTextures - 1]);
      {set name}
      T.Name := asTexName;
      {and create video-dib object for store the picture periodically changed}
      T.VDIB := TDIB.Create;
      //T.VDIB.PixelFormat := MakeDIBPixelFormat(8, 8, 8);
    end;
    {the dds assigned here}
    T.VDIB.Assign(dds);
    {with full adjustation}
    T.FloatX1 := 0;
    T.FloatY1 := 0;
    T.FloatX2 := 1;
    T.FloatY2 := 1;
    SizeAdjust(T.VDIB, T.FloatX1, T.FloatY1, T.FloatX2, T.FloatY2);
    {and store 'changed' values of size here}
    T.Width := T.VDIB.Width;
    T.Height := T.VDIB.Height;
    {and it have to set by dds as transparent, when it set up}
    T.VDIB.Transparent := Transparent;
    {get up transparent color}
    Col := SetTransparentColor(dds, T.VDIB.Pixels[0, 0], Transparent);
    //T.VDIB.SaveToFile('c:\test2.dib'); {for debug}
    if dds.Modified then
      T.D2DTexture.Load {for minimize time only load as videotexture}
    else
      T.D2DTexture := TDirect3DTexture2.Create(FDDraw, T.VDIB, False); {create it}
    {don't forget set transparent values on texture!}
    T.D2DTexture.TransparentColor := Col;
    T.D2DTexture.Surface.TransparentColor := Col;
    T.D2DTexture.Transparent := Transparent;
  except
    {eh, sorry, when is not the dds modified, roll back and release last the VDIB}
    if not dds.Modified then
      if T <> nil then
      begin
        if Assigned(T.VDIB) then
{$IFNDEF DelphiX_Delphi5}begin
          T.VDIB.Free;
          T.VDIB := nil;
        end;
{$ELSE}
          FreeAndNil(T.VDIB);
{$ENDIF}
        if Assigned(T.D2DTexture) then
{$IFNDEF DelphiX_Delphi5}begin
          T.D2DTexture.Free;
          T.D2DTexture := nil;
        end;
{$ELSE}
          FreeAndNil(T.D2DTexture);
{$ENDIF}

        D2DMaxTextures := D2DMaxTextures - 1; //go back
      end;
    Result := False;
  end;
  dds.Modified := False; {this flag turn off always}
end;
{$IFDEF DelphiX_Spt4}

function TD2DTextures.LoadTextures(dds: TDirectDrawSurface; Transparent: Boolean;
  TransparentColor: Integer; asTexName: string): Boolean;
{$ELSE}

function TD2DTextures.LoadTextures3(dds: TDirectDrawSurface; Transparent: Boolean;
  TransparentColor: Integer; asTexName: string): Boolean;
{$ENDIF}

  function getDDSTransparentColor(DIB: TDIB; dds: TDirectDrawSurface): Integer;
  var
    CLL: Integer;
    ddck: TDDColorKey;
  begin
    Result := 0;
    if dds.IDDSurface <> nil then
      if dds.ISurface.GetColorKey(DDCKEY_SRCBLT, ddck) = DD_OK then
        Result := ddck.dwColorSpaceLowValue;
    CLL := TransparentColor;
    if (CLL = -1) or (cardinal(CLL) <> DIB.Pixels[0, 0]) then //when is DDS
      CLL := DIB.Pixels[0, 0]; //have to pick up color from 0,0 pix of DIB
    if Transparent then //and must be transparent
      if CLL <> Result then //when different
        Result := CLL; //use TransparentColor
  end;
var
  //  DIB: TDIB;
  Col: Integer;
  T: TDXTextureImage;
begin
  Result := True;
  try
    D2DPruneTextures; {up to maxTexBlock textures only}
    D2DMaxTextures := D2DMaxTextures + 1;
    Texture[D2DMaxTextures - 1].Name := asTexName;
    Texture[D2DMaxTextures - 1].VDIB := TDIB.Create;
    //    try
    with Texture[D2DMaxTextures - 1] do
    begin
      VDIB.Assign(dds);
      FloatX1 := 0;
      FloatY1 := 0;
      FloatX2 := 1;
      FloatY2 := 1;
      SizeAdjust(VDIB, FloatX1, FloatY1, FloatX2, FloatY2);
      Width := VDIB.Width;
      Height := VDIB.Height;
      VDIB.Transparent := Transparent;
      if VDIB.HasAlphaChannel then
      begin
        dib2dxt(VDIB, T);
        T.ImageName := asTexName;
        T.Transparent := Transparent;
        D2DTexture := TDirect3DTexture2.Create(FDDraw, T, False);
        D2DTexture.Transparent := Transparent;
        AlphaChannel := True;
        T.Free;
      end
      else
      begin
        Col := getDDSTransparentColor(VDIB, dds);
        D2DTexture := TDirect3DTexture2.Create(FDDraw, VDIB, False);
        D2DTexture.TransparentColor := Col;
        D2DTexture.Surface.TransparentColor := Col;
        D2DTexture.Transparent := Transparent;
      end;
    end
      //    finally
      //      DIB.Free;
      //    end;
  except
    D2DMaxTextures := D2DMaxTextures - 1;
    Result := False;
  end;
end;

{$IFDEF DelphiX_Spt4}

function TD2DTextures.CanFindTexture(const Color: Longint): Boolean;
{$ELSE}

function TD2DTextures.CanFindTexture3(const Color: Longint): Boolean;
{$ENDIF}
var
  i: Integer;
begin
  Result := True;
{$IFNDEF DelphiX_Delphi3}
  if Length(Texture) > 0 then
{$ELSE}
  if TexLen > 0 then
{$ENDIF}
    for i := 0 to D2DMaxTextures - 1 do
      if Texture[i].Name = '$' + IntToStr(Color) then
        Exit;
  Result := False;
end;

{$IFDEF DelphiX_Spt4}

function TD2DTextures.LoadTextures(Color: Longint): Boolean;
{$ELSE}

function TD2DTextures.LoadTextures4(Color: Longint): Boolean;
{$ENDIF}
var
  s: string;
  //DIB: TDIB;
begin
  Result := True;
  try
    D2DPruneTextures; {up to maxTexBlock textures only}
    D2DMaxTextures := D2DMaxTextures + 1;
    s := '$' + IntToStr(Color); {this name is supplement name}
    Texture[D2DMaxTextures - 1].VDIB := TDIB.Create;
    //try
    with Texture[D2DMaxTextures - 1] do
    begin
      VDIB.SetSize(16, 16, 24); {16x16 good size}
      VDIB.Canvas.Brush.Color := Color;
      VDIB.Canvas.FillRect(Bounds(0, 0, 16, 16));

      FloatX1 := 0;
      FloatY1 := 0;
      FloatX2 := 1;
      FloatY2 := 1;
      Name := s;
      D2DTexture := TDirect3DTexture2.Create(FDDraw, VDIB, False);
      D2DTexture.Transparent := False; //cannot be transparent
    end;
    //finally
    //  DIB.Free;
    //end;
  except
    D2DMaxTextures := D2DMaxTextures - 1;
    Result := False;
  end;
end;

function TD2DTextures.GetTexLayoutByName(Name: string): TDIB;
var
  i: Integer;
begin
  Result := nil;
  i := Find(Name);
{$IFDEF VER4UP}
  if (i >= Low(Texture)) and (i <= High(Texture)) then
{$ELSE}
  if i <> -1 then
{$ENDIF}
    Result := Texture[i].VDIB
end;

//---------------------------------------------------------------------------

constructor TD2D.Create(DDraw: TCustomDXDraw);
begin
  inherited Create;
  //after inheritance
  FDDraw := DDraw;
  FD2DTextureFilter := D2D_POINT {D2D_LINEAR};
  InitVertex;
  {internal allocation of texture}
  CanUseD2D := (do3D in FDDraw.Options)
    and (doDirectX7Mode in FDDraw.Options)
    and (doHardware in FDDraw.Options);
  FDIB := TDIB.Create;
  FInitialized := False;
end;

destructor TD2D.Destroy;
begin
  {freeing texture and stop using it}
  CanUseD2D := False;
  if Assigned(FD2DTexture) then
  begin
    FD2DTexture.Free; {add 29.5.2005 Takanori Kawasaki}
    FD2DTexture := nil;
  end;
  FDIB.Free;
  inherited Destroy;
end;

procedure TD2D.InitVertex;
var
  i: Integer;
begin
  FillChar(FVertex, SizeOf(FVertex), 0);
  for i := 0 to 3 do
  begin
    FVertex[i].Specular := D3DRGB(1.0, 1.0, 1.0);
    FVertex[i].rhw := 1.0;
  end;
end;

//---------------------------------------------------------------------------

procedure TD2D.BeginScene();
begin
  asm
    FINIT
  end;
  FDDraw.D3DDevice7.BeginScene();
  FDDraw.D3DDevice7.Clear(0, nil, D3DCLEAR_TARGET, 0, 0, 0);
end;

//---------------------------------------------------------------------------

procedure TD2D.EndScene();
begin
  FDDraw.D3DDevice7.EndScene();
  asm
    FINIT
  end;
end;

function TD2D.D2DTexturedOn(Image: TPictureCollectionItem; Pattern: Integer; SubPatternRect: TRect; RenderType: TRenderType): Boolean;
var
  i: Integer;
  SrcX, SrcY, diffX: Double;
  R: TRect;
  Q: TTextureRec;
begin
  Result := False;
  FDDraw.D3DDevice7.SetTexture(0, nil);
  if not FD2DTexture.CanFindTexture(Image) then {when no texture in list try load it}
    if not FD2DTexture.LoadTextures(Image) then {loading is here}
      Exit; {on error occurr out}
  i := FD2DTexture.Find(Image.Name);
  if i = -1 then
    Exit;
  {set pattern as texture}
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MAGFILTER, DWord(Ord(FD2DTextureFilter)+1));
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MINFILTER, DWord(Ord(FD2DTextureFilter)+1));
  try
    FDDraw.D3DDevice7.SetTexture(0, FD2DTexture.Texture[i].D2DTexture.Surface.IDDSurface7);
  except
    RenderError := True;
    FD2DTexture.D2DPruneAllTextures;
    Image.Restore;
    SetD2DTextureFilter(D2D_LINEAR);
    Exit;
  end;
  {set transparent part}
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, Ord(FD2DTexture.Texture[i].D2DTexture.Transparent));
  //except for Draw when alphachannel exists
  //change for blend drawing but save transparent area still
  if FD2DTexture.Texture[i].AlphaChannel then
    {when is Draw selected then}
    if RenderType = rtDraw then
    begin
      D2DEffectBlend;
      D2DAlphaVertex($FF);
    end;
  {pokud je obrazek rozdeleny, nastav oka site}
  if (Image.PatternHeight <> 0) or (Image.PatternWidth <> 0) then
  begin
    {vezmi rect jenom dilku}
    R := Image.PatternRects[Pattern];
    SrcX := 1 / FD2DTexture.Texture[i].Width;
    SrcY := 1 / FD2DTexture.Texture[i].Height;
    //namapovani vertexu na texturu
    FD2DTexture.Texture[i].FloatX1 := SrcX * R.Left;
    FD2DTexture.Texture[i].FloatY1 := SrcY * R.Top;
    {for meshed subimage contain one image only can be problem there}
    diffX := 0.5;
    if Image.PatternCount = 1 then
      diffX := 0;
    FD2DTexture.Texture[i].FloatX2 := SrcX * (R.Right - diffX);
    FD2DTexture.Texture[i].FloatY2 := SrcY * (R.Bottom - diffX);
    if not (
      (SubPatternRect.Left = Image.PatternRects[Pattern].Left) and
      (SubPatternRect.Top = Image.PatternRects[Pattern].Top) and
      (SubPatternRect.Right = Image.PatternRects[Pattern].Right) and
      (SubPatternRect.Bottom = Image.PatternRects[Pattern].Bottom)) then
    begin
      {remaping subtexture via subpattern}
      Q.FloatX1 := SrcX * SubPatternRect.Left;
      Q.FloatY1 := SrcY * SubPatternRect.Top;
      Q.FloatX2 := SrcX * (SubPatternRect.Right - diffX);
      Q.FloatY2 := SrcY * (SubPatternRect.Bottom - diffX);
      D2DTU(Q); {with mirroring/flipping}
      Result := True;
      Exit;
    end;
  end; {jinak celeho obrazku}
  {  X1,Y1             X2,Y1
  0  +-----------------+  1
     |                 |
     |                 |
     |                 |
     |                 |
  2  +-----------------+  3
     X1,Y2             X2,Y2  }
  D2DTU(FD2DTexture.Texture[i]);
  Result := True;
end;

function TD2D.D2DTexturedOnDDSTex(dds: TDirectDrawSurface; SubPatternRect: TRect; Transparent: Boolean): Integer;
{special version of map for TDirectDrawSurface only}
{set up transparent color from this surface}
var
  TexName: string;
begin
  Result := -1;
  {pokud je seznam prazdny, nahrej texturu}
  if dds.Caption <> '' then
    TexName := dds.Caption
  else
    TexName := IntToStr(Integer(dds));
  if not FD2DTexture.{$IFDEF DelphiX_Spt4}CanFindTexture{$ELSE}CanFindTexture2{$ENDIF}(TexName) then
  begin
    {when texture doesn't exists, has to the Modified flag turn off}
    if dds.Modified then
      dds.Modified := not dds.Modified;
    if not FD2DTexture.{$IFDEF DelphiX_Spt4}LoadTextures{$ELSE}LoadTextures2{$ENDIF}(dds, Transparent, TexName) then
      Exit; {nepovede-li se to, pak ven}
  end
  else if dds.Modified then
  begin {when modifying, load texture allways}
    if not FD2DTexture.{$IFDEF DelphiX_Spt4}LoadTextures{$ELSE}LoadTextures2{$ENDIF}(dds, Transparent, TexName) then
      Exit; {nepovede-li se to, pak ven}
  end;
  Result := FD2DTexture.Find(TexName);
end;

function IsNotZero(Z: TRect): Boolean;
begin
  Result := ((Z.Right - Z.Left) > 0) and ((Z.Bottom - Z.Top) > 0)
end;

function TD2D.D2DTexturedOnDDS(dds: TDirectDrawSurface; SubPatternRect: TRect; Transparent: Boolean): Boolean;
var
  i: Integer;
  SrcX, SrcY: Double;
begin
  Result := False;
  FDDraw.D3DDevice7.SetTexture(0, nil);
  {call a low level routine for load DDS texture}
  i := D2DTexturedOnDDSTex(dds, SubPatternRect, Transparent);
  if i = -1 then
    Exit;
  {set pattern as texture}
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MAGFILTER, DWord(Ord(FD2DTextureFilter)+1));
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MINFILTER, DWord(Ord(FD2DTextureFilter)+1));
  try
    RenderError := FDDraw.D3DDevice7.SetTexture(0, FD2DTexture.Texture[i].D2DTexture.Surface.IDDSurface7) <> DD_OK;
  except
    RenderError := True;
    FD2DTexture.D2DPruneAllTextures;
    Exit;
  end;
  {set transparent area}
  RenderError := FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, Ord(FD2DTexture.Texture[i].D2DTexture.Transparent)) <> DD_OK;
  if IsNotZero(SubPatternRect) then
  begin
    // Set Texture Coordinates
    SrcX := 1 / FD2DTexture.Texture[i].D2DTexture.FImage.Width;
    SrcY := 1 / FD2DTexture.Texture[i].D2DTexture.FImage.Height;
    //namapovani vertexu na texturu
    FD2DTexture.Texture[i].FloatX1 := SrcX * SubPatternRect.Left;
    FD2DTexture.Texture[i].FloatY1 := SrcY * SubPatternRect.Top;
    FD2DTexture.Texture[i].FloatX2 := SrcX * (SubPatternRect.Right - 0.5 { - 1}); //by Speeeder
    FD2DTexture.Texture[i].FloatY2 := SrcY * (SubPatternRect.Bottom - 0.5 { - 1}); //by Speeeder
  end;
  D2DTU(FD2DTexture.Texture[i]);
  Result := True;
end;

//---------------------------------------------------------------------------

procedure TD2D.SetCanUseD2D(const Value: Boolean);
begin
  case Value of
    False: {prestava se uzivat}
      if Assigned(FD2DTexture) and (Value <> FCanUseD2D) then
      begin
        FInitialized := False;
      end;
    True:
      if Value <> FCanUseD2D then
      begin
        FD2DTexture := TD2DTextures.Create(FDDraw);
        TextureFilter := D2D_LINEAR;
      end
  end;
  FCanUseD2D := Value;
end;

function TD2D.GetCanUseD2D: Boolean;
begin
  {Mode has to do3D, doDirectX7Mode and doHardware}
  if (do3D in FDDraw.Options)
    and (doDirectX7Mode in FDDraw.Options)
    and (doHardware in FDDraw.Options) then
  begin
    if not FCanUseD2D then
      CanUseD2D := True;
  end
  else if not (do3D in FDDraw.Options)
    or not (doDirectX7Mode in FDDraw.Options)
    or not (doHardware in FDDraw.Options) then
    if FCanUseD2D then
      FCanUseD2D := False; // CanUseD2D -> FCanUseD2D
  FBitCount := FDDraw.Surface.SurfaceDesc.ddpfPixelFormat.dwRGBBitCount;
  {supported 16 or 32 bitcount deepth only}
  if not (FBitCount in [16, 32]) then
    FCanUseD2D := False;

  if not FInitialized then
    if FCanUseD2D and Assigned(FDDraw.D3DDevice7) then
    begin
      FDDraw.D3DDevice7.GetCaps(FD3DDevDesc7);
      FInitialized := True;
    end;

  Result := FCanUseD2D;
end;

procedure TD2D.SetD2DTextureFilter(const Value: TD2DTextureFilter);
begin
  FD2DTextureFilter := Value;
  if (do3D in FDDraw.Options) and Assigned(FDDraw.D3DDevice7) then
  begin
    FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MAGFILTER, DWORD(Ord(FD2DTextureFilter) + 1));
    FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MINFILTER, DWORD(Ord(FD2DTextureFilter) + 1));
  end;
end;

procedure TD2D.SetD2DAntialiasFilter(const Value: TD3DAntialiasMode);
begin
  FD2DAntialiasFilter := Value;
  if (do3D in FDDraw.Options) and Assigned(FDDraw.D3DDevice7) then
  begin
    FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ANTIALIAS, Ord(Value));
  end;
end;

procedure TD2D.D2DRect(R: TRect);
begin
  FVertex[0].sx := R.Left - 0.5;
  FVertex[0].sy := R.Top - 0.5;
  FVertex[1].sx := R.Right - 0.5;
  FVertex[1].sy := R.Top - 0.5;
  FVertex[2].sx := R.Left - 0.5;
  FVertex[2].sy := R.Bottom - 0.5;
  FVertex[3].sx := R.Right - 0.5;
  FVertex[3].sy := R.Bottom - 0.5;
end;

procedure TD2D.D2DTU(T: TTextureRec);
begin
  if FMirrorFlipSet = [rmfMirror] then
  begin
    {  X1,Y1             X2,Y1
    0  +-----------------+  1
       |                 |
       |                 |
       |                 |
       |                 |
    2  +-----------------+  3
       X1,Y2             X2,Y2  }
    FVertex[1].tu := T.FloatX1;
    FVertex[1].tv := T.FloatY1;
    FVertex[0].tu := T.FloatX2;
    FVertex[0].tv := T.FloatY1;
    FVertex[3].tu := T.FloatX1;
    FVertex[3].tv := T.FloatY2;
    FVertex[2].tu := T.FloatX2;
    FVertex[2].tv := T.FloatY2;
  end
  else if FMirrorFlipSet = [rmfFlip] then
  begin
    {  X1,Y1             X2,Y1
    0  +-----------------+  1
       |                 |
       |                 |
       |                 |
       |                 |
    2  +-----------------+  3
       X1,Y2             X2,Y2  }
    FVertex[2].tu := T.FloatX1;
    FVertex[2].tv := T.FloatY1;
    FVertex[3].tu := T.FloatX2;
    FVertex[3].tv := T.FloatY1;
    FVertex[0].tu := T.FloatX1;
    FVertex[0].tv := T.FloatY2;
    FVertex[1].tu := T.FloatX2;
    FVertex[1].tv := T.FloatY2;
  end
  else if FMirrorFlipSet = [rmfMirror, rmfFlip] then
  begin
    {  X1,Y1             X2,Y1
    0  +-----------------+  1
       |                 |
       |                 |
       |                 |
       |                 |
    2  +-----------------+  3
       X1,Y2             X2,Y2  }
    FVertex[3].tu := T.FloatX1;
    FVertex[3].tv := T.FloatY1;
    FVertex[2].tu := T.FloatX2;
    FVertex[2].tv := T.FloatY1;
    FVertex[1].tu := T.FloatX1;
    FVertex[1].tv := T.FloatY2;
    FVertex[0].tu := T.FloatX2;
    FVertex[0].tv := T.FloatY2;
  end
  else
  begin
    {  X1,Y1             X2,Y1
    0  +-----------------+  1
       |                 |
       |                 |
       |                 |
       |                 |
    2  +-----------------+  3
       X1,Y2             X2,Y2  }
    FVertex[0].tu := T.FloatX1;
    FVertex[0].tv := T.FloatY1;
    FVertex[1].tu := T.FloatX2;
    FVertex[1].tv := T.FloatY1;
    FVertex[2].tu := T.FloatX1;
    FVertex[2].tv := T.FloatY2;
    FVertex[3].tu := T.FloatX2;
    FVertex[3].tv := T.FloatY2;
  end;
end;

{Final public routines}

function TD2D.D2DRender(Image: TPictureCollectionItem; R: TRect;
  Pattern: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  case RenderType of
    rtDraw:
      begin
        D2DEffectSolid;
        D2DWhite;
      end;
    rtBlend:
      begin
        D2DEffectBlend;
        D2DAlphaVertex(Alpha);
      end;
    rtAdd:
      begin
        D2DEffectAdd;
        D2DFade(Alpha);
      end;
    rtSub:
      begin
        D2DEffectSub;
        D2DFade(Alpha);
      end;
  end;
  Result := D2DTexturedOn(Image, Pattern, Image.PatternRects[Pattern], RenderType);
  D2DRect(R);
  RenderQuad;
end;

function TD2D.D2DRenderDDS(Source: TDirectDrawSurface; R: TRect;
  Transparent: Boolean; Pattern: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  case RenderType of
    rtDraw:
      begin
        D2DEffectSolid;
        D2DWhite;
      end;
    rtBlend:
      begin
        D2DEffectBlend;
        D2DAlphaVertex(Alpha);
      end;
    rtAdd:
      begin
        D2DEffectAdd;
        D2DFade(Alpha);
      end;
    rtSub:
      begin
        D2DEffectSub;
        D2DFade(Alpha);
      end;
  end;
  Result := D2DTexturedOnDDS(Source, ZeroRect, Transparent);
  D2DRect(R);
  RenderQuad;
end;

function TD2D.D2DRenderCol(Image: TPictureCollectionItem; R: TRect;
  Pattern, Color: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  case RenderType of
    rtDraw:
      begin
        D2DEffectSolid;
        D2DColoredVertex(Color);
      end;
    rtBlend:
      begin
        D2DEffectBlend;
        D2DColAlpha(Color, Alpha);
      end;
    rtAdd:
      begin
        D2DEffectAdd;
        D2DFadeColored(Color, Alpha);
      end;
    rtSub:
      begin
        D2DEffectSub;
        D2DFadeColored(Color, Alpha);
      end;
  end;
  Result := D2DTexturedOn(Image, Pattern, Image.PatternRects[Pattern], RenderType);
  D2DRect(R);
  RenderQuad;
end;

function TD2D.D2DRenderColDDS(Source: TDirectDrawSurface; R: TRect;
  Transparent: Boolean; Pattern, Color: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {Add}
  case RenderType of
    rtDraw:
      begin
        D2DEffectSolid;
        D2DColoredVertex(Color);
      end;
    rtBlend:
      begin
        D2DEffectBlend;
        D2DColAlpha(Color, Alpha);
      end;
    rtAdd:
      begin
        D2DEffectAdd;
        D2DFadeColored(Color, Alpha);
      end;
    rtSub:
      begin
        D2DEffectSub;
        D2DFadeColored(Color, Alpha);
      end;
  end;
  Result := D2DTexturedOnDDS(Source, ZeroRect, Transparent);
  D2DRect(R);
  RenderQuad;
end;

function TD2D.D2DRenderDrawXY(Image: TPictureCollectionItem; X, Y: Integer;
  Pattern: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
var
  PWidth, PHeight: Integer;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {Draw}
  case RenderType of
    rtDraw:
      begin
        D2DEffectSolid;
        D2DWhite;
      end;
    rtBlend:
      begin
        D2DEffectBlend;
        D2DAlphaVertex(Alpha);
      end;
    rtAdd:
      begin
        D2DEffectAdd;
        D2DFade(Alpha);
      end;
    rtSub:
      begin
        D2DEffectSub;
        D2DFade(Alpha);
      end;
  end;
  Result := D2DTexturedOn(Image, Pattern, Image.PatternRects[Pattern], RenderType);
  PWidth := Image.PatternWidth;
  if PWidth = 0 then
    PWidth := Image.Width;
  PHeight := Image.PatternHeight;
  if PHeight = 0 then
    PHeight := Image.Height;
  D2DRect(Bounds(X, Y, PWidth, PHeight));
  RenderQuad;
end;

function TD2D.D2DRenderDrawDDSXY(Source: TDirectDrawSurface; X, Y: Integer;
  Transparent: Boolean; Pattern: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {Draw}
  case RenderType of
    rtDraw:
      begin
        D2DEffectSolid;
        D2DWhite;
      end;
    rtBlend:
      begin
        D2DEffectBlend;
        D2DAlphaVertex(Alpha);
      end;
    rtAdd:
      begin
        D2DEffectAdd;
        D2DFade(Alpha);
      end;
    rtSub:
      begin
        D2DEffectSub;
        D2DFade(Alpha);
      end;
  end;
  Result := D2DTexturedOnDDS(Source, ZeroRect, Transparent);
  D2DRect(Bounds(X, Y, Source.Width, Source.Height));
  RenderQuad;
end;

{$IFDEF DelphiX_Spt4}

function TD2D.D2DRenderDrawDDSXY(Source: TDirectDrawSurface; X, Y: Integer;
  SrcRect: TRect; Transparent: Boolean; Pattern: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {Draw}
  case RenderType of
    rtDraw:
      begin
        D2DEffectSolid;
        D2DWhite;
      end;
    rtBlend:
      begin
        D2DEffectBlend;
        D2DAlphaVertex(Alpha);
      end;
    rtAdd:
      begin
        D2DEffectAdd;
        D2DFade(Alpha);
      end;
    rtSub:
      begin
        D2DEffectSub;
        D2DFade(Alpha);
      end;
  end;
  Result := D2DTexturedOnDDS(Source, SrcRect, Transparent);
  D2DRect(Bounds(X, Y, SrcRect.Right - SrcRect.Left, SrcRect.Bottom - SrcRect.Top));
  RenderQuad;
end;
{$ENDIF}

{Rotate functions}

procedure TD2D.D2DRotate(X, Y, W, H: Integer; Px, Py: Double; Angle: single);

  procedure SinCosS(const Theta: single; var Sin, Cos: single); register;
    // EAX contains address of Sin
    // EDX contains address of Cos
    // Theta is passed over the stack
  asm
    FLD  Theta
    FSINCOS
    FSTP DWORD PTR [EDX]    // cosine
    FSTP DWORD PTR [EAX]    // sine
  end;
const
  PI256 = 2 * Pi / 256;
var
  X1, Y1, up, s_angle, c_angle, s_up, c_up: single;
begin
  Angle := Angle * PI256;
  up := Angle + Pi / 2;
  X1 := W * Px;
  Y1 := H * Py;
  SinCosS(Angle, s_angle, c_angle);
  SinCosS(up, s_up, c_up);
  FVertex[0].sx := X - X1 * c_angle - Y1 * c_up;
  FVertex[0].sy := Y - X1 * s_angle - Y1 * s_up;
  FVertex[1].sx := FVertex[0].sx + W * c_angle;
  FVertex[1].sy := FVertex[0].sy + W * s_angle;
  FVertex[2].sx := FVertex[0].sx + H * c_up;
  FVertex[2].sy := FVertex[0].sy + H * s_up;
  FVertex[3].sx := FVertex[2].sx + W * c_angle;
  FVertex[3].sy := FVertex[2].sy + W * s_angle;
end;

function TD2D.D2DRenderRotate(Image: TPictureCollectionItem; RotX, RotY,
  PictWidth, PictHeight, PatternIndex: Integer; RenderType: TRenderType;
  CenterX, CenterY: Double;
  Angle: single; Alpha: Byte): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {set of effect}
  case RenderType of
    rtDraw:
      begin
        D2DEffectSolid;
        D2DWhite;
      end;
    rtBlend:
      begin
        D2DEffectBlend;
        D2DAlphaVertex(Alpha);
      end;
    rtAdd:
      begin
        D2DEffectAdd;
        D2DFade(Alpha);
      end;
    rtSub:
      begin
        D2DEffectSub;
        D2DFade(Alpha);
      end;
  end;
  {load textures and map it}
  Result := D2DTexturedOn(Image, PatternIndex, Image.PatternRects[PatternIndex], RenderType);
  {do rotate mesh}
  D2DRotate(RotX, RotY, PictWidth, PictHeight, CenterX, CenterY, Angle);
  {render it}
  RenderQuad;
end;

function TD2D.D2DRenderRotateDDS(Image: TDirectDrawSurface; RotX, RotY,
  PictWidth, PictHeight: Integer; RenderType: TRenderType;
  CenterX, CenterY: Double; Angle: single; Alpha: Byte;
  Transparent: Boolean): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {set of effect}
  case RenderType of
    rtDraw:
      begin
        D2DEffectSolid;
        D2DWhite;
      end;
    rtBlend:
      begin
        D2DEffectBlend;
        D2DAlphaVertex(Alpha);
      end;
    rtAdd:
      begin
        D2DEffectAdd;
        D2DFade(Alpha);
      end;
    rtSub:
      begin
        D2DEffectSub;
        D2DFade(Alpha);
      end;
  end;
  {load textures and map it}
  Result := D2DTexturedOnDDS(Image, ZeroRect, Transparent);
  {do rotate mesh}
  D2DRotate(RotX, RotY, PictWidth, PictHeight, CenterX, CenterY, Angle);
  {render it}
  RenderQuad;
end;

{------------------------------------------------------------------------------}
{created 31.1.2005 JB.}
{replacement original Hori's functionality}
{24.4.2006 create WaveY as supplement like WaveX functions}
{14.5.2006 added functionality for tile drawing through PatternIndex}

function TD2D.D2DMeshMapToWave(dds: TDirectDrawSurface; Transparent: Boolean;
  TransparentColor: Integer; X, Y, iWidth, iHeight, PatternIndex: Integer;
  PatternRect: TRect;
  amp, Len, ph, Alpha: Integer; Effect: TRenderType; DoY: Boolean): Boolean;

  function D2DTexturedOn(dds: TDirectDrawSurface; Transparent: Boolean; var TexNo: Integer): Boolean;
    {special version of mapping for TDirectDrawSurface only}
    {set up transparent color from this surface}
  var
    i: Integer;
    TexName: string;
  begin
    Result := False;
    TexNo := -1;
    FDDraw.D3DDevice7.SetTexture(0, nil);
    {pokud je seznam prazdny, nahrej texturu}
    if dds.Caption <> '' then
      TexName := dds.Caption
    else
      TexName := IntToStr(Integer(dds));
    if not FD2DTexture.{$IFDEF DelphiX_Spt4}CanFindTexture{$ELSE}CanFindTexture2{$ENDIF}(TexName) then
      {nepovede-li se to, pak ven}
      if not FD2DTexture.{$IFDEF DelphiX_Spt4}LoadTextures{$ELSE}LoadTextures3{$ENDIF}(dds, Transparent, TransparentColor, TexName) then
        Exit;
    i := FD2DTexture.Find(TexName);
    if i = -1 then
      Exit;
    TexNo := i;
    {set pattern as texture}
//    FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MAGFILTER, DWord(Ord(FD2DTextureFilter)+1));
//    FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MINFILTER, DWord(Ord(FD2DTextureFilter)+1));
    try
      FDDraw.D3DDevice7.SetTexture(0, FD2DTexture.Texture[i].D2DTexture.Surface.IDDSurface7);
    except
      RenderError := True;
      FD2DTexture.D2DPruneAllTextures;
      Exit;
    end;
    {set transparent area}
    FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, Ord(FD2DTexture.Texture[i].D2DTexture.Transparent));
    Result := True;
  end;
type
  TVertexArray = array{$IFDEF DelphiX_Delphi3} [0..0]{$ENDIF} of TD3DTLVERTEX;
{$IFDEF DelphiX_Delphi3}
  PVertexArray = ^TVertexArray;
{$ENDIF}
var
  SVertex: {$IFNDEF DelphiX_Delphi3}TVertexArray{$ELSE}PVertexArray{$ENDIF};
  i, maxVertex, maxPix, VStepVx, TexNo, Width, Height: Integer;
  VStep, VStepTo, d, Z, FX1, FX2, FY1, FY2, sx, sy, X1, Y1, X2, Y2: extended;
  R: TRect;
  clr: DWORD;
begin
  Result := False;
  //zde uschovano maximum [0..1] po adjustaci textury, ktera nemela nektery rozmer 2^n
  //FD2DTexture.Texture[I].FloatX2;
  //FD2DTexture.Texture[I].FloatY2;
  //napr. pokud byl rozmer 0.7 pak je nutno prepocitat tento interval [0..0.7] na height
  if not D2DTexturedOn(dds, Transparent, TexNo) then
    Exit;
  {musi se prenastavit velikost pokud je PatternIndex <> -1}
  Width := iWidth;
  Height := iHeight;
  {remove into local variabled for multi-picture adjustation}
  FX1 := FD2DTexture.Texture[TexNo].FloatX1;
  FX2 := FD2DTexture.Texture[TexNo].FloatX2;
  FY1 := FD2DTexture.Texture[TexNo].FloatY1;
  FY2 := FD2DTexture.Texture[TexNo].FloatY2;
  {when pattertindex selected, get real value of subtexture}
  if (PatternIndex <> -1) {and (PatternRect <> ZeroRect)} then
  begin
    R := PatternRect;
    Width := R.Right - R.Left;
    Height := R.Bottom - R.Top;
    {scale unit of full new width and height}
    sx := 1 / FD2DTexture.Texture[TexNo].Width;
    sy := 1 / FD2DTexture.Texture[TexNo].Height;
    {remap there}
    FX1 := R.Left * sx;
    FX2 := R.Right * sx;
    FY1 := R.Top * sy;
    FY2 := R.Bottom * sy;
  end;
  //nastavuje se tolik vertexu, kolik je potreba
  //speculative set up of rows for better look how needed
  if not DoY then
  begin
    maxVertex := 2 * Trunc(Height / Len * 8);
    if (maxVertex mod 2) > 0 then {top to limits}
      Inc(maxVertex, 2);
    if (maxVertex div 2) > Height then {correct to Height}
      maxVertex := 2 * Height;
  end
  else
  begin
    maxVertex := 2 * Trunc(Width / Len * 8);
    if (maxVertex mod 2) > 0 then {top to limits}
      Inc(maxVertex, 2);
    if (maxVertex div 2) > Width then {correct to Width}
      maxVertex := 2 * Width;
  end;

  //pocet pixlu mezi ploskami
  if not DoY then
  begin
    repeat
      if (Height mod (maxVertex div 2)) <> 0 then
        Inc(maxVertex, 2);
      maxPix := Height div (maxVertex div 2);
    until (Height mod (maxVertex div 2)) = 0;
    //krok k nastaveni vertexu
    VStep := (FY2 - FY1) / (maxVertex div 2);
  end
  else
  begin
    repeat
      if (Width mod (maxVertex div 2)) <> 0 then
        Inc(maxVertex, 2);
      maxPix := Width div (maxVertex div 2);
    until (Width mod (maxVertex div 2)) = 0;
    //krok k nastaveni vertexu
    VStep := (FX2 - FX1) / (maxVertex div 2);
  end;
  //prostor
{$IFNDEF DelphiX_Delphi3}
  SetLength(SVertex, maxVertex);
{$ELSE}
  SVertex := AllocMem(maxVertex * SizeOf(TD3DTLVERTEX));
  try
{$ENDIF}
    //inicializace
    VStepVx := 0;
    VStepTo := 0;
    d := ph / (128 / Pi); {shift wave}
    Z := (Len / 2) / Pi; {wave length to radians}
    case Effect of //effect cumulate to one param and four line of code
      rtDraw: clr := RGBA_MAKE($FF, $FF, $FF, $FF);
      rtBlend: clr := RGBA_MAKE($FF, $FF, $FF, Alpha);
      rtAdd: clr := D3DRGB(Alpha * 1 / 255, Alpha * 1 / 255, Alpha * 1 / 255);
      rtSub: clr := D3DRGB(Alpha / 255, Alpha / 255, Alpha / 255);
    end;
    {vlastni nastaveni vertexu v pasu vertexu}
    for i := 0 to maxVertex - 1 do
    begin
      SVertex[i].Specular := D3DRGB(1.0, 1.0, 1.0);
      SVertex[i].rhw := 1.0;
      SVertex[i].Color := clr;
      if not DoY then
        case (i + 1) mod 2 of //triangle driver
          1:
            begin
              if i <> 0 then
                Inc(VStepVx, maxPix);
              SVertex[i].sx := X + Trunc(amp * Sin((Y + VStepVx) / Z + d)) - 0.5; //levy
              SVertex[i].sy := Y + VStepVx - 0.5;
              if FMirrorFlipSet = [rmfMirror] then
              begin
                X1 := FX2;
                if i <> 0 then
                  VStepTo := VStepTo + VStep;
                Y1 := FY1 + VStepTo;
              end
              else if FMirrorFlipSet = [rmfFlip] then
              begin
                X1 := FX1;
                Y1 := FY2 - VStepTo;
              end
              else if FMirrorFlipSet = [rmfMirror, rmfFlip] then
              begin
                X1 := FX2;
                Y1 := FY2 - VStepTo;
              end
              else
              begin
                X1 := FX1;
                if i <> 0 then
                  VStepTo := VStepTo + VStep;
                Y1 := FY1 + VStepTo;
              end;
              SVertex[i].tu := X1;
              SVertex[i].tv := Y1;
            end;
          0:
            begin
              SVertex[i].sx := X + Width + Trunc(amp * Sin((Y + VStepVx) / Z + d)) - 1; //pravy
              SVertex[i].sy := Y + VStepVx;
              if FMirrorFlipSet = [rmfMirror] then
              begin
                X2 := FX1;
                Y2 := FY1 + VStepTo;
              end
              else if FMirrorFlipSet = [rmfFlip] then
              begin
                X2 := FX2;
                Y2 := FY2 - VStepTo;
                if i <> 0 then
                  VStepTo := VStepTo + VStep;
              end
              else if FMirrorFlipSet = [rmfMirror, rmfFlip] then
              begin
                X2 := FX1;
                Y2 := FY2 - VStepTo;
                if i <> 0 then
                  VStepTo := VStepTo + VStep;
              end
              else
              begin
                X2 := FX2;
                Y2 := FY1 + VStepTo;
              end;
              SVertex[i].tu := X2;
              SVertex[i].tv := Y2;
            end;
        end {case}
      else
        case (i + 1) mod 2 of //triangle driver
          0:
            begin
              if i <> 0 then
                Inc(VStepVx, maxPix);
              SVertex[i].sy := Y + Trunc(amp * Sin((X + VStepVx) / Z + d)) - 0.5; //hore
              SVertex[i].sx := X + VStepVx - 0.5;
              if FMirrorFlipSet = [rmfMirror] then
              begin
                Y1 := FY1;
                if i <> 0 then
                  VStepTo := VStepTo + VStep;
                X1 := FX2 - VStepTo;
              end
              else if FMirrorFlipSet = [rmfFlip] then
              begin
                Y1 := FY2;
                if i <> 0 then
                  VStepTo := VStepTo + VStep;
                X1 := FX1 + VStepTo;
              end
              else if FMirrorFlipSet = [rmfMirror, rmfFlip] then
              begin
                Y1 := FY2;
                if i <> 0 then
                  VStepTo := VStepTo + VStep;
                X1 := FX2 - VStepTo;
              end
              else
              begin
                Y1 := FY1;
                if i <> 0 then
                  VStepTo := VStepTo + VStep;
                X1 := FX1 + VStepTo;
              end;
              SVertex[i].tu := X1;
              SVertex[i].tv := Y1;
            end;
          1:
            begin
              SVertex[i].sy := Y + Height + Trunc(amp * Sin((X + VStepVx) / Z + d)) - 1; //dole
              SVertex[i].sx := X + VStepVx;
              if FMirrorFlipSet = [rmfMirror] then
              begin
                Y2 := FY2;
                X2 := FX2 - VStepTo;
              end
              else if FMirrorFlipSet = [rmfFlip] then
              begin
                Y2 := FY1;
                X2 := FX1 + VStepTo;
              end
              else if FMirrorFlipSet = [rmfMirror, rmfFlip] then
              begin
                Y2 := FY1;
                X2 := FX2 - VStepTo;
              end
              else
              begin
                Y2 := FY2;
                X2 := FX1 + VStepTo;
              end;
              SVertex[i].tu := X2;
              SVertex[i].tv := Y2;
            end;
        end;
    end;
    {set of effect}
    with FDDraw.D3DDevice7 do
    begin
      case Effect of
        rtDraw: D2DEffectSolid;
        rtBlend: D2DEffectBlend;
        rtAdd: D2DEffectAdd;
        rtSub: D2DEffectSub;
      end;
      {kreslime hned zde}//render now and here
      Result := DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, SVertex[0], maxVertex, D3DDP_WAIT) = DD_OK;
      //zpet hodnoty
      InitVertex;
      FMirrorFlipSet := []; {only for one operation, back to normal position}
      SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 0);
    end;
{$IFDEF DelphiX_Delphi3}
  finally
    FreeMem(SVertex, maxVertex * SizeOf(TD3DTLVERTEX));
  end;
{$ENDIF}
end;

function TD2D.D2DRenderWaveX(Image: TPictureCollectionItem; X, Y, Width,
  Height, PatternIndex: Integer; RenderType: TRenderType; Transparent: Boolean;
  amp, Len, ph, Alpha: Integer): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {load textures and map, do make wave mesh and render it}
  Result := D2DMeshMapToWave(Image.PatternSurfaces[PatternIndex], Transparent,
    Image.FTransparentColor, X, Y, Width, Height, PatternIndex,
    Image.PatternRects[PatternIndex],
    amp, Len, ph, Alpha, RenderType{$IFDEF DelphiX_Delphi3}, False{$ENDIF});
end;

function TD2D.D2DRenderWaveXDDS(Source: TDirectDrawSurface; X, Y, Width,
  Height: Integer; RenderType: TRenderType; Transparent: Boolean; amp, Len, ph, Alpha: Integer): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {load textures and map, do make wave mesh and render it}
  Result := D2DMeshMapToWave(Source, Transparent, -1, X, Y, Width, Height, -1,
    ZeroRect,
    amp, Len, ph, Alpha, RenderType{$IFDEF DelphiX_Delphi3}, False{$ENDIF});
end;

function TD2D.D2DRenderWaveY(Image: TPictureCollectionItem; X, Y, Width,
  Height, PatternIndex: Integer; RenderType: TRenderType; Transparent: Boolean;
  amp, Len, ph, Alpha: Integer): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {load textures and map, do make wave mesh and render it}
  Result := D2DMeshMapToWave(Image.PatternSurfaces[PatternIndex], Transparent,
    Image.FTransparentColor, X, Y, Width, Height, PatternIndex,
    Image.PatternRects[PatternIndex],
    amp, Len, ph, Alpha, RenderType, True);
end;

function TD2D.D2DRenderWaveYDDS(Source: TDirectDrawSurface; X, Y, Width,
  Height: Integer; RenderType: TRenderType; Transparent: Boolean;
  amp, Len, ph, Alpha: Integer): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {load textures and map, do make wave mesh and render it}
  Result := D2DMeshMapToWave(Source, Transparent, -1, X, Y, Width, Height, -1,
    ZeroRect,
    amp, Len, ph, Alpha, RenderType, True);
end;

function TD2D.D2DTexturedOnRect(Rect: TRect; Color: Longint): Boolean;
var
  i: Integer;
begin
  Result := False;
  FDDraw.D3DDevice7.SetTexture(0, nil);
  if not FD2DTexture.{$IFDEF DelphiX_Spt4}CanFindTexture{$ELSE}CanFindTexture3{$ENDIF}(Color) then {when no texture in list try load it}
    if not FD2DTexture.{$IFDEF DelphiX_Spt4}LoadTextures{$ELSE}LoadTextures4{$ENDIF}(Color) then
      Exit; {on error occurr go out}
  i := FD2DTexture.Find('$' + IntToStr(Color)); //simply .. but stupid
  if i = -1 then
    Exit;
  {set pattern as texture}
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MAGFILTER, DWord(Ord(FD2DTextureFilter)+1));
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MINFILTER, DWord(Ord(FD2DTextureFilter)+1));
  try
    FDDraw.D3DDevice7.SetTexture(0, FD2DTexture.Texture[i].D2DTexture.Surface.IDDSurface7);
  except
    RenderError := True;
    FD2DTexture.D2DPruneAllTextures;
    Exit;
  end;
  {set transparent part}
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, 0); //no transparency

  D2DTU(FD2DTexture.Texture[i]);
  Result := True;
end;

function TD2D.D2DRenderColoredPartition(Image: TPictureCollectionItem;
  DestRect: TRect;
  PatternIndex, Color, Specular: Integer;
  Faded: Boolean;
  SourceRect: TRect;
  RenderType: TRenderType;
  Alpha: Byte): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {set of effect}
  case RenderType of
    rtDraw: D2DEffectSolid;
    rtBlend: D2DEffectBlend;
    rtAdd: D2DEffectAdd;
    rtSub: D2DEffectSub;
  end;
  if Faded then
    D2DFade(Alpha);

  D2DColoredVertex(Color);
  if Specular <> Round(D3DRGB(1.0, 1.0, 1.0)) then
    D2DSpecularVertex(Specular);
  {load textures and map it}
  Result := D2DTexturedOn(Image, PatternIndex, SourceRect, RenderType);

  D2DRect(DestRect);
  {render it}
  RenderQuad;
end;

function TD2D.D2DRenderFillRect(Rect: TRect; RGBColor: Longint;
  RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  case RenderType of
    rtDraw:
      begin
        D2DEffectSolid;
        D2DColoredVertex(RGBColor);
      end;
    rtBlend:
      begin
        D2DEffectBlend;
        D2DAlphaVertex(Alpha);
      end;
    rtAdd:
      begin
        D2DEffectAdd;
        D2DFade(Alpha);
      end;
    rtSub:
      begin
        D2DEffectSub;
        D2DFade(Alpha);
      end;
  end;
  Result := D2DTexturedOnRect(Rect, RGBColor);
  D2DRect(Rect);
  RenderQuad;
end;

function TD2D.D2DRenderRotateModeCol(Image: TPictureCollectionItem;
  RenderType: TRenderType;
  RotX, RotY, PictWidth, PictHeight, PatternIndex: Integer; CenterX,
  CenterY: Double; Angle: single; Color: Integer; Alpha: Byte): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {set of effect}
  case RenderType of
    rtDraw: D2DEffectSolid;
    rtAdd: D2DEffectAdd;
    rtSub: D2DEffectSub;
    rtBlend: D2DEffectBlend;
  end;
  D2DFadeColored(Color, Alpha);
  {load textures and map it}
  Result := D2DTexturedOn(Image, PatternIndex, Image.PatternRects[PatternIndex], RenderType);
  {do rotate mesh}
  D2DRotate(RotX, RotY, PictWidth, PictHeight, CenterX, CenterY, Angle);
  {render it}
  RenderQuad;
end;

function TD2D.D2DRenderRotateModeColDDS(Image: TDirectDrawSurface;
  RotX, RotY, PictWidth, PictHeight: Integer; RenderType: TRenderType;
  CenterX, CenterY: Double; Angle: single; Color: Integer; Alpha: Byte;
  Transparent: Boolean): Boolean;
begin
  Result := False;
  if not CanUseD2D then
    Exit;
  {set of effect}
  case RenderType of
    rtDraw: D2DEffectSolid;
    rtAdd: D2DEffectAdd;
    rtSub: D2DEffectSub;
    rtBlend: D2DEffectBlend;
  end;
  D2DFadeColored(Color, Alpha);
  {load textures and map it}
  Result := D2DTexturedOnDDS(Image, ZeroRect, Transparent);
  {do rotate mesh}
  D2DRotate(RotX, RotY, PictWidth, PictHeight, CenterX, CenterY, Angle);
  {render it}
  RenderQuad;
end;

procedure TD2D.D2DEffectSolid;
begin
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 0);
  //FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_FILLMODE, Integer(D3DFILL_SOLID));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, Integer(True));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_ONE));
end;

procedure TD2D.D2DEffectBlend;
begin
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 1);
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_SRCALPHA));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_DESTBLEND, Integer(D3DBLEND_INVSRCALPHA));
  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_ALPHAOP, Ord(D3DTOP_SELECTARG1));
  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_CURRENT);
  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_ALPHAOP, Integer(D3DTOP_MODULATE));
end;

procedure TD2D.D2DEffectAdd;
begin
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 1);
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_ONE));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_DESTBLEND, Integer(D3DBLEND_ONE));
  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_ALPHAOP, Ord(D3DTOP_SELECTARG1));
  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_CURRENT);
  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_ALPHAOP, Integer(D3DTOP_MODULATE));
end;

procedure TD2D.D2DEffectSub;
begin
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 1);
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_ZERO));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_DESTBLEND, Integer(D3DBLEND_INVSRCCOLOR));
  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_ALPHAOP, Ord(D3DTOP_SELECTARG1));
  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_CURRENT);
  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_ALPHAOP, Integer(D3DTOP_MODULATE));
end;

function TD2D.D2DAlphaVertex(Alpha: Integer): Integer;
begin
  Result := RGBA_MAKE($FF, $FF, $FF, Alpha);
  FVertex[0].Color := Result;
  FVertex[1].Color := Result;
  FVertex[2].Color := Result;
  FVertex[3].Color := Result;
end;

procedure TD2D.D2DColoredVertex(c: Integer);
begin
  c := D3DRGB(c and $FF / 255, (c shr 8) and $FF / 255, (c shr 16) and $FF / 255);
  FVertex[0].Color := c;
  FVertex[1].Color := c;
  FVertex[2].Color := c;
  FVertex[3].Color := c;
end;

procedure TD2D.D2DColAlpha(c, Alpha: Integer);
begin
  c := D3DRGBA(c and $FF / 255, (c shr 8) and $FF / 255, (c shr 16) and $FF / 255, Alpha / 255);
  FVertex[0].Color := c;
  FVertex[1].Color := c;
  FVertex[2].Color := c;
  FVertex[3].Color := c;
end;

procedure TD2D.D2DSpecularVertex(c: Integer);
begin
  c := D3DRGB(c and $FF / 255, (c shr 8) and $FF / 255, (c shr 16) and $FF / 255);
  FVertex[0].Specular := c;
  FVertex[1].Specular := c;
  FVertex[2].Specular := c;
  FVertex[3].Specular := c;
end;
{
procedure TD2D.D2DCol4Alpha(C1, C2, C3, C4, Alpha: Integer);
begin
  FVertex[0].Color := D3DRGBA(C1 and $FF / 255, (C1 shr 8) and $FF / 255,
    (C1 shr 16) and $FF / 255, Alpha / 255);
  FVertex[1].Color := D3DRGBA(C2 and $FF / 255, (C2 shr 8) and $FF / 255,
    (C2 shr 16) and $FF / 255, Alpha / 255);
  FVertex[2].Color := D3DRGBA(C3 and $FF / 255, (C3 shr 8) and $FF / 255,
    (C3 shr 16) and $FF / 255, Alpha / 255);
  FVertex[3].Color := D3DRGBA(C4 and $FF / 255, (C4 shr 8) and $FF / 255,
    (C4 shr 16) and $FF / 255, Alpha / 255);
end;
}
function TD2D.D2DWhite: Integer;
begin
  Result := RGB_MAKE($FF, $FF, $FF);
  FVertex[0].Color := Result;
  FVertex[1].Color := Result;
  FVertex[2].Color := Result;
  FVertex[3].Color := Result;
end;

function TD2D.D2DFade(Alpha: Integer): Integer;
begin
  Result := RGB_MAKE(Alpha, Alpha, Alpha);
  FVertex[0].Color := Result;
  FVertex[1].Color := Result;
  FVertex[2].Color := Result;
  FVertex[3].Color := Result;
end;

procedure TD2D.D2DFadeColored(c, Alpha: Integer);
var
  mult: single;
begin
  mult := Alpha / 65025; //Alpha/255/255;
  c := D3DRGB((c and $FF) * mult, ((c shr 8) and $FF) * mult, ((c shr 16) and $FF) * mult);
  FVertex[0].Color := c;
  FVertex[1].Color := c;
  FVertex[2].Color := c;
  FVertex[3].Color := c;
end;
{
procedure TD2D.D2DFade4Colored(C1, C2, C3, C4, Alpha: Integer);
var
  mult: single;
begin
  mult := Alpha / 65025; //Alpha/255/255;
  FVertex[0].Color := D3DRGB((C1 and $FF) * mult, ((C1 shr 8) and $FF) * mult,
    ((C1 shr 16) and $FF) * mult);
  FVertex[1].Color := D3DRGB((C2 and $FF) * mult, ((C2 shr 8) and $FF) * mult,
    ((C2 shr 16) and $FF) * mult);
  FVertex[2].Color := D3DRGB((C3 and $FF) * mult, ((C3 shr 8) and $FF) * mult,
    ((C3 shr 16) and $FF) * mult);
  FVertex[3].Color := D3DRGB((C4 and $FF) * mult, ((C4 shr 8) and $FF) * mult,
    ((C4 shr 16) and $FF) * mult);
end;
}
procedure TD2D.RenderQuad;
begin
  RenderError := FDDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, FVertex, 4, D3DDP_WAIT) <> DD_OK;
  InitVertex;
  FMirrorFlipSet := []; {only for one operation, back to normal position}
  {restore device status}
  FDDraw.D3DDevice7.SetTextureStageState(1, D3DTSS_COLOROP, Ord(D3DTOP_DISABLE));
  FDDraw.D3DDevice7.SetTextureStageState(1, D3DTSS_ALPHAOP, Ord(D3DTOP_DISABLE));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 0);
end;
{
procedure TD2D.RenderTri;
begin
  RenderError := FDDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, FVertex, 3, D3DDP_WAIT) <> DD_OK;
  InitVertex;
  FMirrorFlipSet := [];       //only for one operation, back to normal position
  //restore device status
  FDDraw.D3DDevice7.SetTextureStageState(1, D3DTSS_COLOROP, Ord(D3DTOP_DISABLE));
  FDDraw.D3DDevice7.SetTextureStageState(1, D3DTSS_ALPHAOP, Ord(D3DTOP_DISABLE));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 0);
end;
}
{
procedure TD2D.D2DMeshMapToRect(R: TRect);
begin
  FVertex[0].sx := R.Left - 0.5;
  FVertex[0].sy := R.Top - 0.5;
  FVertex[1].sx := R.Right - 0.5;
  FVertex[1].sy := R.Top - 0.5;
  FVertex[2].sx := R.Left - 0.5;
  FVertex[2].sy := R.Bottom - 0.5;
  FVertex[3].sx := R.Right - 0.5;
  FVertex[3].sy := R.Bottom - 0.5;
end;
 }
function TD2D.D2DInitializeSurface: Boolean;
begin
  Result := False;
  if Assigned(FDDraw.D3DDevice7) then
    Result := FDDraw.D3DDevice7.SetRenderTarget(FDDraw.Surface.IDDSurface7, 0) = DD_OK;
end;

procedure TD2D.D2DUpdateTextures;
var
  i: Integer;
begin
{$IFNDEF DelphiX_Delphi3}
  for i := Low(FD2DTexture.Texture) to High(FD2DTexture.Texture) do
{$ELSE}
  for i := 0 to FD2DTexture.TexLen - 1 do
{$ENDIF}begin
    FD2DTexture.Texture[i].Width := FD2DTexture.Texture[i].D2DTexture.Surface.Width;
    FD2DTexture.Texture[i].Height := FD2DTexture.Texture[i].D2DTexture.Surface.Height;
    //    FD2DTexture.Texture[I].AlphaChannel := ?
  end;
end;

{  TTrace  }

constructor TTrace.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FBlit := TBlit.Create(Self);
  FBlit.FEngine := TCustomDXDraw(Traces.FOwner);
end;

destructor TTrace.Destroy;
begin
  FBlit.Free;
  inherited Destroy;
end;

function TTrace.GetDisplayName: string;
begin
  Result := inherited GetDisplayName
end;

procedure TTrace.SetDisplayName(const Value: string);
begin
  if (Value <> '') and (AnsiCompareText(Value, GetDisplayName) <> 0) and
    (Collection is TTraces) and (TTraces(Collection).IndexOf(Value) >= 0) then
    raise Exception.Create(Format('Item duplicate name "%s" error', [Value]));
  inherited SetDisplayName(Value);
end;

function TTrace.GetTraces: TTraces;
begin
  if Collection is TTraces then
    Result := TTraces(Collection)
  else
    Result := nil;
end;

procedure TTrace.Render(const LagCount: Integer);
begin
  FBlit.DoMove(LagCount);
  FBlit.DoCollision;
  FBlit.DoDraw;
  if Assigned(FBlit.FOnRender) then
    FBlit.FOnRender(FBlit);
end;

function TTrace.IsActualized: Boolean;
begin
  Result := FActualized;
end;

procedure TTrace.Assign(Source: TPersistent);
begin
  if Source is TTrace then
  begin
    //FTracePoints.Assign(TTrace(Source).FTracePoints);
    FBlit.Assign(TTrace(Source).FBlit);
    FTag := TTrace(Source).FTag;
  end
  else
    inherited Assign(Source);
end;

function TTrace.GetActive: Boolean;
begin
  Result := FBlit.FActive;
end;

procedure TTrace.SetActive(const Value: Boolean);
begin
  FBlit.FActive := Value;
end;

function TTrace.GetOnCollision: TNotifyEvent;
begin
  Result := FBlit.FOnCollision;
end;

procedure TTrace.SetOnCollision(const Value: TNotifyEvent);
begin
  FBlit.FOnCollision := Value;
end;

function TTrace.GetOnGetImage: TNotifyEvent;
begin
  Result := FBlit.FOnGetImage;
end;

procedure TTrace.SetOnGetImage(const Value: TNotifyEvent);
begin
  FBlit.FOnGetImage := Value;
end;

function TTrace.GetOnDraw: TNotifyEvent;
begin
  Result := FBlit.FOnDraw;
end;

procedure TTrace.SetOnDraw(const Value: TNotifyEvent);
begin
  FBlit.FOnDraw := Value;
end;

function TTrace.GetOnMove: TBlitMoveEvent;
begin
  Result := FBlit.FOnMove;
end;

procedure TTrace.SetOnMove(const Value: TBlitMoveEvent);
begin
  FBlit.FOnMove := Value;
end;

function TTrace.Clone(NewName: string; OffsetX, OffsetY: Integer;
  Angle: single): TTrace;
var
  NewItem: TTrace;
  i: Integer;
begin
  NewItem := GetTraces.Add;
  NewItem.Assign(Self);
  NewItem.Name := NewName;
  for i := 0 to NewItem.Blit.GetPathCount - 1 do
  begin
    NewItem.Blit.FPathArr[i].X := NewItem.Blit.FPathArr[i].X + OffsetX;
    NewItem.Blit.FPathArr[i].Y := NewItem.Blit.FPathArr[i].Y + OffsetY;
  end;
  Result := NewItem
end;

function TTrace.GetOnRender: TOnRender;
begin
  Result := FBlit.FOnRender;
end;

procedure TTrace.SetOnRender(const Value: TOnRender);
begin
  FBlit.FOnRender := Value;
end;

{  TTraces  }

constructor TTraces.Create(AOwner: TComponent);
begin
  inherited Create(TTrace);
  FOwner := AOwner;
end;

destructor TTraces.Destroy;
begin
  inherited Destroy;
end;

function TTraces.Add: TTrace;
begin
  Result := TTrace(inherited Add);
end;

function TTraces.Find(const Name: string): TTrace;
var
  i: Integer;
begin
  i := IndexOf(Name);
  if i = -1 then
    raise EDXTracerError.CreateFmt('Tracer item named %s not found', [Name]);
  Result := Items[i];
end;

function TTraces.GetItem(Index: Integer): TTrace;
begin
  Result := TTrace(inherited GetItem(Index));
end;

procedure TTraces.SetItem(Index: Integer;
  Value: TTrace);
begin
  inherited SetItem(Index, Value);
end;

procedure TTraces.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;
{$IFDEF DelphiX_Spt4}

function TTraces.Insert(Index: Integer): TTrace;
begin
  Result := TTrace(inherited Insert(Index));
end;
{$ENDIF}

function TTraces.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

{  TBlit  }

function TBlit.GetWorldX: Double;
begin
  if Parent <> nil then
    Result := Parent.WorldX + FBlitRec.FX
  else
    Result := FBlitRec.FX;
end;

function TBlit.GetWorldY: Double;
begin
  if Parent <> nil then
    Result := Parent.WorldY + FBlitRec.FY
  else
    Result := FBlitRec.FY;
end;

procedure TBlit.DoMove(LagCount: Integer);
var
  MoveIt: Boolean;
begin
  if not FBlitRec.FMoved then
    Exit;
  if Assigned(FOnMove) then
  begin
    MoveIt := True; {if nothing then reanimate will force}
    FOnMove(Self, LagCount, MoveIt); {when returned MoveIt = true still that do not move}
    if MoveIt then
      ReAnimate(LagCount); //for reanimation
  end
  else
  begin
    ReAnimate(LagCount);
  end;
  {there is moving to next foot of the path}
  if Active then
    if GetPathCount > 0 then
    begin
      Dec(FCurrentTime, LagCount);
      if FCurrentTime < 0 then
      begin
        if FBustrofedon then
        begin
          case FCurrentDirection of
            True:
              begin
                Inc(FCurrentPosition); //go forward
                if FCurrentPosition = (GetPathCount - 1) then
                  FCurrentDirection := not FCurrentDirection //change direction
              end;
            False:
              begin
                Dec(FCurrentPosition); //go backward
                if FCurrentPosition = 0 then
                  FCurrentDirection := not FCurrentDirection //change direction
              end;
          end;
        end
        else if FCurrentPosition < (GetPathCount - 1) then
        begin
          Inc(FCurrentPosition) //go forward only
        end
        else if FMovingRepeatly then
          FCurrentPosition := 0; {return to start}
        {get actual new value for showing time}
        {must be pick-up there, after change of the current position}
        FCurrentTime := Path[FCurrentPosition].StayOn; {cas mezi pohyby}
      end;
      X := Path[FCurrentPosition].X;
      Y := Path[FCurrentPosition].Y;
    end;
  {}
end;

function TBlit.GetDrawImageIndex: Integer;
begin
  Result := FBlitRec.FAnimStart + Trunc(FBlitRec.FAnimPos);
end;

procedure TBlit.DoDraw;
var
  f: TRenderMirrorFlipSet;
  R: TRect;
begin
  with FBlitRec do
  begin
    if not FVisible then
      Exit;
    if FImage = nil then
      DoGetImage;
    if FImage = nil then
      Exit;
    {owner draw called here}
    if Assigned(FOnDraw) then
      FOnDraw(Self)
    else
    {when is not owner draw then go here} begin
      f := [];
      if FMirror then
        f := f + [rmfMirror];
      if FFlip then
        f := f + [rmfFlip];
      R := Bounds(Round(FX), Round(FY), FImage.Width, FImage.Height);
      DXDraw_Render(FEngine, FImage, R,
        GetDrawImageIndex, FBlurImageArr, FBlurImage, FTextureFilter, f, FBlendMode, FAngle,
        FAlpha, FCenterX, FCenterY, FScale, FWaveType, FAmplitude, FAmpLength, FPhase);
    end;
  end
end;

function Mod2f(i: Double; i2: Integer): Double;
begin
  if i2 = 0 then
    Result := i
  else
  begin
    Result := i - Round(i / i2) * i2;
    if Result < 0 then
      Result := i2 + Result;
  end;
end;

procedure TBlit.ReAnimate(MoveCount: Integer);
var
  i: Integer;
begin
  with FBlitRec do
  begin
    FAnimPos := FAnimPos + FAnimSpeed * MoveCount;

    if FAnimLooped then
    begin
      if FAnimCount > 0 then
        FAnimPos := Mod2f(FAnimPos, FAnimCount)
      else
        FAnimPos := 0;
    end
    else
    begin
      if Round(FAnimPos) >= FAnimCount then
      begin
        FAnimPos := FAnimCount - 1;
        FAnimSpeed := 0;
      end;
      if FAnimPos < 0 then
      begin
        FAnimPos := 0;
        FAnimSpeed := 0;
      end;
    end;
    {incerease or decrease speed}
    if (FEnergy <> 0) then
    begin
      FSpeedX := FSpeedX + FSpeedX * FEnergy;
      FSpeedY := FSpeedY + FSpeedY * FEnergy;
    end;
    {adjust with speed}
    if (FSpeedX > 0) or (FSpeedY > 0) then
    begin
      FX := FX + FSpeedX * MoveCount;
      FY := FY + FSpeedY * MoveCount;
    end;
    {and gravity aplicable}
    if (FGravityX > 0) or (FGravityY > 0) then
    begin
      FX := FX + FGravityX * MoveCount;
      FY := FY + FGravityY * MoveCount;
    end;
    if FBlurImage then
    begin
      {ale jen jsou-li jine souradnice}
      if (FBlurImageArr[High(FBlurImageArr)].eX <> Round(WorldX)) or
      (FBlurImageArr[High(FBlurImageArr)].eY <> Round(WorldY)) then
      begin
        for i := Low(FBlurImageArr) + 1 to High(FBlurImageArr) do
        begin
          FBlurImageArr[i - 1] := FBlurImageArr[i];
          {adjust the blur intensity}
          FBlurImageArr[i - 1].eIntensity := Round(FAlpha / (High(FBlurImageArr) + 1)) * (i - 1);
        end;
        with FBlurImageArr[High(FBlurImageArr)] do
        begin
          eX := Round(WorldX);
          eY := Round(WorldY);
          ePatternIndex := GetDrawImageIndex;
          eIntensity := Round(FAlpha / (High(FBlurImageArr) + 1)) * High(FBlurImageArr);
          eBlendMode := FBlendMode;
          eActive := True;
        end;
      end;
    end;
  end;
end;

function TBlit.DoCollision: TBlit;
var
  i, maxzaxis: Integer;
begin
  Result := nil;
  if not FBlitRec.FCollisioned then
    Exit;
  if Assigned(FOnCollision) then
    FOnCollision(Self)
  else
  begin
    {over z axis}
    maxzaxis := 0;
    for i := 0 to FEngine.Traces.Count - 1 do
      maxzaxis := Max(maxzaxis, FEngine.Traces.Items[i].FBlit.Z);
    {for all items}
    for i := 0 to FEngine.Traces.Count - 1 do
      {no self item}
      if FEngine.Traces.Items[i].FBlit <> Self then
        {through engine}
        with FEngine.Traces.Items[i] do
          {test overlap}
          if OverlapRect(Bounds(Round(FBlit.WorldX), Round(FBlit.WorldY),
            FBlit.Width, FBlit.Height), Bounds(Round(WorldX), Round(WorldY), Width, Height)) then
          begin
            {if any, then return first blit}
            Result := FBlit;
            {and go out}
            Break;
          end;
  end;
end;

procedure TBlit.DoGetImage;
begin
  {init image when object come from form}
  if FImage = nil then
    if Assigned(FOnGetImage) then
    begin
      FOnGetImage(Self);
      if FImage = nil then
        raise EDXBlitError.Create('Undefined image file!');
      FBlitRec.FWidth := FImage.Width;
      FBlitRec.FHeight := FImage.Height;
    end;
end;

constructor TBlit.Create(AParent: TObject);
begin
  inherited Create;
  FParent := nil;
  if AParent is TBlit then
    FParent := TBlit(AParent);
  FillChar(FBlitRec, SizeOf(FBlitRec), 0);
  with FBlitRec do
  begin
    FCollisioned := True; {can be collisioned}
    FMoved := True; {can be moved}
    FVisible := True; {can be rendered}
    FAnimCount := 0;
    FAnimLooped := False;
    FAnimPos := 0;
    FAnimSpeed := 0;
    FAnimStart := 0;
    FAngle := 0;
    FAlpha := $FF;
    FCenterX := 0.5;
    FCenterY := 0.5;
    FScale := 1;
    FBlendMode := rtDraw;
    FAmplitude := 0;
    FAmpLength := 0;
    FPhase := 0;
    FWaveType := wtWaveNone;
    FSpeedX := 0;
    FSpeedY := 0;
    FGravityX := 0;
    FGravityY := 0;
    FEnergy := 0;
    FBlurImage := False;
    FMirror := False;
    FFlip := False;
  end;
  FillChar(FBlurImageArr, SizeOf(FBlitRec), 0);
  FActive := True; {active on}
  FMovingRepeatly := True;
  {super private}
  FCurrentTime := 0;
  FCurrentPosition := 0;
  FCurrentDirection := True;
end;

destructor TBlit.Destroy;
begin
{$IFNDEF DelphiX_Delphi3}
  SetLength(FPathArr, 0);
{$ELSE}
  SetPathLen(0);
{$ENDIF}
  inherited;
end;

function TBlit.GetMoved: Boolean;
begin
  Result := FBlitRec.FMoved;
end;

procedure TBlit.SetMoved(const Value: Boolean);
begin
  FBlitRec.FMoved := Value;
end;

function TBlit.GetWaveType: TWaveType;
begin
  Result := FBlitRec.FWaveType;
end;

procedure TBlit.SetWaveType(const Value: TWaveType);
begin
  FBlitRec.FWaveType := Value;
end;

function TBlit.GetAmplitude: Integer;
begin
  Result := FBlitRec.FAmplitude;
end;

procedure TBlit.SetAmplitude(const Value: Integer);
begin
  FBlitRec.FAmplitude := Value;
end;

function TBlit.GetAnimStart: Integer;
begin
  Result := FBlitRec.FAnimStart;
end;

procedure TBlit.SetAnimStart(const Value: Integer);
begin
  FBlitRec.FAnimStart := Value;
end;

function TBlit.GetAmpLength: Integer;
begin
  Result := FBlitRec.FAmpLength;
end;

procedure TBlit.SetAmpLength(const Value: Integer);
begin
  FBlitRec.FAmpLength := Value;
end;

function TBlit.GetWidth: Integer;
begin
  Result := FBlitRec.FWidth;
end;

procedure TBlit.SetWidth(const Value: Integer);
begin
  FBlitRec.FWidth := Value;
end;

function TBlit.GetGravityX: single;
begin
  Result := FBlitRec.FGravityX;
end;

procedure TBlit.SetGravityX(const Value: single);
begin
  FBlitRec.FGravityX := Value;
end;

function TBlit.StoreGravityX: Boolean;
begin
  Result := FBlitRec.FGravityX <> 1.0;
end;

function TBlit.GetPhase: Integer;
begin
  Result := FBlitRec.FPhase;
end;

procedure TBlit.SetPhase(const Value: Integer);
begin
  FBlitRec.FPhase := Value;
end;

function TBlit.GetAnimPos: Double;
begin
  Result := FBlitRec.FAnimPos;
end;

procedure TBlit.SetAnimPos(const Value: Double);
begin
  FBlitRec.FAnimPos := Value;
end;

function TBlit.StoreAnimPos: Boolean;
begin
  Result := FBlitRec.FAnimPos <> 0;
end;

function TBlit.GetFlip: Boolean;
begin
  Result := FBlitRec.FFlip;
end;

procedure TBlit.SetFlip(const Value: Boolean);
begin
  FBlitRec.FFlip := Value;
end;

function TBlit.GetGravityY: single;
begin
  Result := FBlitRec.FGravityY;
end;

procedure TBlit.SetGravityY(const Value: single);
begin
  FBlitRec.FGravityY := Value;
end;

function TBlit.StoreGravityY: Boolean;
begin
  Result := FBlitRec.FGravityY <> 1.0;
end;

function TBlit.GetSpeedX: single;
begin
  Result := FBlitRec.FSpeedX;
end;

procedure TBlit.SetSpeedX(const Value: single);
begin
  FBlitRec.FSpeedX := Value;
end;

function TBlit.StoreSpeedX: Boolean;
begin
  Result := FBlitRec.FSpeedX <> 0;
end;

function TBlit.GetSpeedY: single;
begin
  Result := FBlitRec.FSpeedY;
end;

procedure TBlit.SetSpeedY(const Value: single);
begin
  FBlitRec.FSpeedY := Value;
end;

function TBlit.StoreSpeedY: Boolean;
begin
  Result := FBlitRec.FSpeedY <> 0;
end;

function TBlit.GetCenterX: Double;
begin
  Result := FBlitRec.FCenterX;
end;

procedure TBlit.SetCenterX(const Value: Double);
begin
  FBlitRec.FCenterX := Value;
end;

function TBlit.StoreCenterX: Boolean;
begin
  Result := FBlitRec.FCenterX <> 0.5;
end;

function TBlit.GetAngle: single;
begin
  Result := FBlitRec.FAngle;
end;

procedure TBlit.SetAngle(const Value: single);
begin
  FBlitRec.FAngle := Value;
end;

function TBlit.StoreAngle: Boolean;
begin
  Result := FBlitRec.FAngle <> 0;
end;

function TBlit.GetBlurImage: Boolean;
begin
  Result := FBlitRec.FBlurImage;
end;

procedure TBlit.SetBlurImage(const Value: Boolean);
begin
  FBlitRec.FBlurImage := Value;
end;

function TBlit.GetCenterY: Double;
begin
  Result := FBlitRec.FCenterY;
end;

procedure TBlit.SetCenterY(const Value: Double);
begin
  FBlitRec.FCenterY := Value;
end;

function TBlit.StoreCenterY: Boolean;
begin
  Result := FBlitRec.FCenterY <> 0.5;
end;

function TBlit.GetBlendMode: TRenderType;
begin
  Result := FBlitRec.FBlendMode;
end;

procedure TBlit.SetBlendMode(const Value: TRenderType);
begin
  FBlitRec.FBlendMode := Value;
end;

function TBlit.GetAnimSpeed: Double;
begin
  Result := FBlitRec.FAnimSpeed;
end;

procedure TBlit.SetAnimSpeed(const Value: Double);
begin
  FBlitRec.FAnimSpeed := Value;
end;

function TBlit.StoreAnimSpeed: Boolean;
begin
  Result := FBlitRec.FAnimSpeed <> 0;
end;

function TBlit.GetZ: Integer;
begin
  Result := FBlitRec.FZ;
end;

procedure TBlit.SetZ(const Value: Integer);
begin
  FBlitRec.FZ := Value;
end;

function TBlit.GetMirror: Boolean;
begin
  Result := FBlitRec.FMirror;
end;

procedure TBlit.SetMirror(const Value: Boolean);
begin
  FBlitRec.FMirror := Value;
end;

function TBlit.GetX: Double;
begin
  Result := FBlitRec.FX;
end;

procedure TBlit.SetX(const Value: Double);
begin
  FBlitRec.FX := Value;
end;

function TBlit.GetVisible: Boolean;
begin
  Result := FBlitRec.FVisible;
end;

procedure TBlit.SetVisible(const Value: Boolean);
begin
  FBlitRec.FVisible := Value;
end;

function TBlit.GetY: Double;
begin
  Result := FBlitRec.FY;
end;

procedure TBlit.SetY(const Value: Double);
begin
  FBlitRec.FY := Value;
end;

function TBlit.GetAlpha: Byte;
begin
  Result := FBlitRec.FAlpha;
end;

procedure TBlit.SetAlpha(const Value: Byte);
begin
  FBlitRec.FAlpha := Value;
end;

function TBlit.GetEnergy: single;
begin
  Result := FBlitRec.FEnergy;
end;

procedure TBlit.SetEnergy(const Value: single);
begin
  FBlitRec.FEnergy := Value;
end;

function TBlit.StoreEnergy: Boolean;
begin
  Result := FBlitRec.FEnergy <> 0;
end;

function TBlit.GetCollisioned: Boolean;
begin
  Result := FBlitRec.FCollisioned;
end;

procedure TBlit.SetCollisioned(const Value: Boolean);
begin
  FBlitRec.FCollisioned := Value;
end;

function TBlit.GetAnimLooped: Boolean;
begin
  Result := FBlitRec.FAnimLooped;
end;

procedure TBlit.SetAnimLooped(const Value: Boolean);
begin
  FBlitRec.FAnimLooped := Value;
end;

function TBlit.GetHeight: Integer;
begin
  Result := FBlitRec.FHeight;
end;

procedure TBlit.SetHeight(const Value: Integer);
begin
  FBlitRec.FHeight := Value;
end;

function TBlit.GetScale: Double;
begin
  Result := FBlitRec.FScale;
end;

procedure TBlit.SetScale(const Value: Double);
begin
  FBlitRec.FScale := Value;
end;

function TBlit.StoreScale: Boolean;
begin
  Result := FBlitRec.FScale <> 1.0;
end;

function TBlit.GetAnimCount: Integer;
begin
  Result := FBlitRec.FAnimCount;
end;

procedure TBlit.SetAnimCount(const Value: Integer);
begin
  FBlitRec.FAnimCount := Value;
end;

function TBlit.GetTextureFilter: TD2DTextureFilter;
begin
  Result := FBlitRec.FTextureFilter;
end;

procedure TBlit.SetTextureFilter(const Value: TD2DTextureFilter);
begin
  FBlitRec.FTextureFilter := Value;
end;

function TBlit.GetBoundsRect: TRect;
begin
  Result := Bounds(Round(WorldX), Round(WorldY), Width, Height);
end;

function TBlit.GetClientRect: TRect;
begin
  Result := Bounds(0, 0, Width, Height);
end;

function TBlit.GetBlitAt(X, Y: Integer): TBlit;

  procedure BlitAt(X, Y: Double; Blit: TBlit);
  var
    i: Integer;
    X2, Y2: Double;
  begin
    if Blit.Visible and PointInRect(Point(Round(X), Round(Y)),
      Bounds(Round(Blit.X), Round(Blit.Y), Blit.Width, Blit.Width)) then
    begin
      if (Result = nil) or (Blit.Z > Result.Z) then
        Result := Blit; {uniquelly - where will be store last blit}
    end;

    X2 := X - Blit.X;
    Y2 := Y - Blit.Y;
    for i := 0 to Blit.Engine.FTraces.Count - 1 do
      BlitAt(X2, Y2, Blit.Engine.FTraces.Items[i].FBlit);
  end;

var
  i: Integer;
  X2, Y2: Double;
begin
  Result := nil;

  X2 := X - Self.X;
  Y2 := Y - Self.Y;
  for i := 0 to Engine.FTraces.Count - 1 do
    BlitAt(X2, Y2, Engine.FTraces.Items[i].FBlit);
end;

procedure TBlit.SetPathLen(Len: Integer);
var
  i, L: Integer;
begin
{$IFDEF DelphiX_Spt4}
  if Length(FPathArr) <> Len then
{$ELSE}
  if FPathLen <> Len then
{$ENDIF}begin
    L := Len;
    if Len <= 0 then
      L := 0;
{$IFNDEF DelphiX_Delphi3}
    SetLength(FPathArr, L);
    for i := Low(FPathArr) to High(FPathArr) do
    begin
      FillChar(FPathArr[i], SizeOf(FPathArr), 0);
      FPathArr[i].StayOn := 25;
    end;
{$ELSE}
    FPathLen := L;
    if FPathArr = nil then
      FPathArr := AllocMem(FPathLen * SizeOf(TPath))
    else
      {alokuj pamet}
      ReAllocMem(FPathArr, FPathLen * SizeOf(TPath));
    if Assigned(FPathArr) then
    begin
      FillChar(FPathArr^, FPathLen * SizeOf(TPath), 0);
      for i := 0 to FPathLen do
        FPathArr[i].StayOn := 25;
    end
{$ENDIF}
  end;
end;

function TBlit.IsPathEmpty: Boolean;
begin
{$IFDEF DelphiX_Delphi3}
  Result := FPathLen = 0;
{$ELSE}
  Result := Length(FPathArr) = 0;
{$ENDIF}
end;

function TBlit.GetPathCount: Integer;
begin
{$IFDEF DelphiX_Delphi3}
  Result := FPathLen;
{$ELSE}
  Result := Length(FPathArr);
{$ENDIF}
end;

function TBlit.GetPath(Index: Integer): TPath;
begin
{$IFDEF DelphiX_Spt4}
  if (Index >= Low(FPathArr)) and (Index <= High(FPathArr)) then
{$ELSE}
  if (Index >= 0) and (Index < FPathLen) then
{$ENDIF}
    Result := FPathArr[Index]
  else
    raise Exception.Create('Bad path index!');
end;

procedure TBlit.SetPath(Index: Integer; const Value: TPath);
begin
{$IFDEF DelphiX_Spt4}
  if (Index >= Low(FPathArr)) and (Index <= High(FPathArr)) then
{$ELSE}
  if (Index >= 0) and (Index < FPathLen) then
{$ENDIF}
    FPathArr[Index] := Value
  else
    raise Exception.Create('Bad path index!');
end;

procedure TBlit.ReadPaths(Stream: TStream);
var
  PathLen: Integer;
begin
  {nacti delku}
  Stream.ReadBuffer(PathLen, SizeOf(PathLen));
  SetPathLen(PathLen);
  Stream.ReadBuffer(FPathArr[0], PathLen * SizeOf(TPath));
end;

procedure TBlit.WritePaths(Stream: TStream);
var
  PathLen: Integer;
begin
  PathLen := GetPathCount;
  Stream.WriteBuffer(PathLen, SizeOf(PathLen));
  Stream.WriteBuffer(FPathArr[0], PathLen * SizeOf(TPath));
end;

procedure TBlit.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Paths', ReadPaths, WritePaths, not IsPathEmpty);
end;

procedure TBlit.Assign(Source: TPersistent);
var
  i: Integer;
begin
  if Source is TBlit then
  begin
{$IFDEF DelphiX_Spt4}
    i := Length(TBlit(Source).FPathArr);
{$ELSE}
    i := FPathLen;
{$ENDIF}
    SetPathLen(i);
    if i > 0 then
      Move(TBlit(Source).FPathArr[0], FPathArr[0], i * SizeOf(TPath));
    FBlitRec := TBlit(Source).FBlitRec;
    FillChar(FBlurImageArr, SizeOf(FBlurImageArr), 0);
    FActive := TBlit(Source).FActive;
    FMovingRepeatly := TBlit(Source).FMovingRepeatly;
    FImage := nil;
    FOnMove := TBlit(Source).FOnMove;
    FOnDraw := TBlit(Source).FOnDraw;
    FOnCollision := TBlit(Source).FOnCollision;
    FOnGetImage := TBlit(Source).FOnGetImage;
    FEngine := TBlit(Source).FEngine;
  end
  else
    inherited Assign(Source);
end;

function TBlit.GetMovingRepeatly: Boolean;
begin
  Result := FMovingRepeatly;
end;

procedure TBlit.SetMovingRepeatly(const Value: Boolean);
begin
  FMovingRepeatly := Value;
end;

function TBlit.GetBustrofedon: Boolean;
begin
  Result := FBustrofedon;
end;

procedure TBlit.SetBustrofedon(const Value: Boolean);
begin
  FBustrofedon := Value;
end;

{  utility draw  }

procedure DXDraw_Draw(DXDraw: TCustomDXDraw; Image: TPictureCollectionItem;
  Rect: TRect; Pattern: Integer; TextureFilter: TD2DTextureFilter;
  MirrorFlip: TRenderMirrorFlipSet;
  BlendMode: TRenderType; Angle: single; Alpha: Byte;
  CenterX: Double; CenterY: Double;
  Scale: single);
{$IFDEF VER9UP}inline;
{$ENDIF}
var
  //  r: TRect;
  Width, Height: Integer;
begin
  if not Assigned(DXDraw.Surface) then
    Exit;
  if not Assigned(Image) then
    Exit;
  if Scale <> 1.0 then
  begin
    Width := Round(Scale * Image.Width);
    Height := Round(Scale * Image.Height);
  end
  else
  begin
    Width := Image.Width;
    Height := Image.Height;
  end;
  //r := Bounds(X, Y, width, height);
  DXDraw.TextureFilter(TextureFilter);
  DXDraw.MirrorFlip(MirrorFlip);
  case BlendMode of
    rtDraw:
      begin
        if Angle = 0 then
          Image.StretchDraw(DXDraw.Surface, Rect, Pattern)
        else
          Image.DrawRotate(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
            (Rect.Top + Rect.Bottom) div 2,
            Width, Height, Pattern, CenterX, CenterY, Angle);
      end;
    rtBlend:
      begin
        if Angle = 0 then
          Image.DrawAlpha(DXDraw.Surface, Rect, Pattern, Alpha)
        else
          Image.DrawRotateAlpha(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
            (Rect.Top + Rect.Bottom) div 2,
            Width, Height, Pattern, CenterX, CenterY, Angle, Alpha);
      end;
    rtAdd:
      begin
        if Angle = 0 then
          Image.DrawAdd(DXDraw.Surface, Rect, Pattern, Alpha)
        else
          Image.DrawRotateAdd(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
            (Rect.Top + Rect.Bottom) div 2,
            Width, Height, Pattern, CenterX, CenterY, Angle, Alpha);
      end;
    rtSub:
      begin
        if Angle = 0 then
          Image.DrawSub(DXDraw.Surface, Rect, Pattern, Alpha)
        else
          Image.DrawRotateSub(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
            (Rect.Top + Rect.Bottom) div 2,
            Width, Height, Pattern, CenterX, CenterY, Angle, Alpha);
      end;
  end; {case}
end;

procedure DXDraw_Paint(DXDraw: TCustomDXDraw; Image: TPictureCollectionItem;
  Rect: TRect; Pattern: Integer; var BlurImageArr: TBlurImageArr; BlurImage: Boolean;
  TextureFilter: TD2DTextureFilter;
  MirrorFlip: TRenderMirrorFlipSet;
  BlendMode: TRenderType;
  Angle: single;
  Alpha: Byte;
  CenterX: Double; CenterY: Double);
{$IFDEF VER9UP}inline;
{$ENDIF}
var
  rr: TRect;
  i, Width, Height: Integer;
begin
  if not Assigned(DXDraw.Surface) then
    Exit;
  if not Assigned(Image) then
    Exit;
  Width := Image.Width;
  Height := Image.Height;
  //rr := Bounds(X, Y, width, height);
  //DXDraw.MirrorFlip(MirrorFlip);
  DXDraw.TextureFilter(TextureFilter);
  case BlendMode of
    rtDraw:
      begin
        if BlurImage then
        begin
          for i := Low(BlurImageArr) to High(BlurImageArr) do
            if BlurImageArr[i].eActive then
            begin
              DXDraw.MirrorFlip(MirrorFlip);
              rr := Bounds(BlurImageArr[i].eX, BlurImageArr[i].eY, Width, Height);
              if Angle = 0 then
                Image.DrawAlpha(DXDraw.Surface, rr, BlurImageArr[i].ePatternIndex, BlurImageArr[i].eIntensity)
              else
                Image.DrawRotateAlpha(DXDraw.Surface, (rr.Left + rr.Right) div 2,
                  (rr.Top + rr.Bottom) div 2,
                  Width, Height, BlurImageArr[i].ePatternIndex, CenterX, CenterY, BlurImageArr[i].eAngle, BlurImageArr[i].eIntensity);
              if BlurImageArr[i].eIntensity > 0 then
                Dec(BlurImageArr[i].eIntensity)
              else
                FillChar(BlurImageArr[i], SizeOf(BlurImageArr[i]), 0);
            end;
        end;
        DXDraw.MirrorFlip(MirrorFlip);
        if Angle = 0 then
          Image.StretchDraw(DXDraw.Surface, Rect, Pattern)
        else
          Image.DrawRotate(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
            (Rect.Top + Rect.Bottom) div 2,
            Width, Height, Pattern, CenterX, CenterY, Angle);
      end;
    rtBlend:
      begin
        if BlurImage then
        begin
          for i := Low(BlurImageArr) to High(BlurImageArr) do
            if BlurImageArr[i].eActive then
            begin
              DXDraw.MirrorFlip(MirrorFlip);
              rr := Bounds(BlurImageArr[i].eX, BlurImageArr[i].eY, Width, Height);
              if Angle = 0 then
                Image.DrawAlpha(DXDraw.Surface, rr, Pattern, BlurImageArr[i].eIntensity)
              else
                Image.DrawRotateAlpha(DXDraw.Surface, (rr.Left + rr.Right) div 2,
                  (rr.Top + rr.Bottom) div 2,
                  Width, Height, Pattern, CenterX, CenterY, BlurImageArr[i].eAngle, BlurImageArr[i].eIntensity);
              if BlurImageArr[i].eIntensity > 0 then
                Dec(BlurImageArr[i].eIntensity)
              else
                FillChar(BlurImageArr[i], SizeOf(BlurImageArr[i]), 0);
            end;
        end;
        DXDraw.MirrorFlip(MirrorFlip);
        if Angle = 0 then
          Image.DrawAlpha(DXDraw.Surface, Rect, Pattern, Alpha)
        else
          Image.DrawRotateAlpha(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
            (Rect.Top + Rect.Bottom) div 2,
            Width, Height, Pattern, CenterX, CenterY, Angle, Alpha);
      end;
    rtAdd:
      begin
        if BlurImage then
        begin
          for i := Low(BlurImageArr) to High(BlurImageArr) do
            if BlurImageArr[i].eActive then
            begin
              DXDraw.MirrorFlip(MirrorFlip);
              rr := Bounds(BlurImageArr[i].eX, BlurImageArr[i].eY, Width, Height);
              if Angle = 0 then
                Image.DrawAdd(DXDraw.Surface, rr, Pattern, BlurImageArr[i].eIntensity)
              else
                Image.DrawRotateAdd(DXDraw.Surface, (rr.Left + rr.Right) div 2,
                  (rr.Top + rr.Bottom) div 2,
                  Width, Height, Pattern, CenterX, CenterY, BlurImageArr[i].eAngle, BlurImageArr[i].eIntensity);
              if BlurImageArr[i].eIntensity > 0 then
                Dec(BlurImageArr[i].eIntensity)
              else
                FillChar(BlurImageArr[i], SizeOf(BlurImageArr[i]), 0);
            end;
        end;
        DXDraw.MirrorFlip(MirrorFlip);
        if Angle = 0 then
          Image.DrawAdd(DXDraw.Surface, Rect, Pattern, Alpha)
        else
          Image.DrawRotateAdd(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
            (Rect.Top + Rect.Bottom) div 2,
            Width, Height, Pattern, CenterX, CenterY, Angle, Alpha);
      end;
    rtSub:
      begin
        if BlurImage then
        begin
          for i := Low(BlurImageArr) to High(BlurImageArr) do
            if BlurImageArr[i].eActive then
            begin
              DXDraw.MirrorFlip(MirrorFlip);
              rr := Bounds(BlurImageArr[i].eX, BlurImageArr[i].eY, Width, Height);
              if Angle = 0 then
                Image.DrawSub(DXDraw.Surface, rr, Pattern, BlurImageArr[i].eIntensity)
              else
                Image.DrawRotateSub(DXDraw.Surface, (rr.Left + rr.Right) div 2,
                  (rr.Top + rr.Bottom) div 2,
                  Width, Height, Pattern, CenterX, CenterY, BlurImageArr[i].eAngle, BlurImageArr[i].eIntensity);
              if BlurImageArr[i].eIntensity > 0 then
                Dec(BlurImageArr[i].eIntensity)
              else
                FillChar(BlurImageArr[i], SizeOf(BlurImageArr[i]), 0);
            end;
        end;
        DXDraw.MirrorFlip(MirrorFlip);
        if Angle = 0 then
          Image.DrawSub(DXDraw.Surface, Rect, Pattern, Alpha)
        else
          Image.DrawRotateSub(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
            (Rect.Top + Rect.Bottom) div 2,
            Width, Height, Pattern, CenterX, CenterY, Angle, Alpha);
      end;
  end; {case}
end;

procedure DXDraw_Render(DXDraw: TCustomDXDraw; Image: TPictureCollectionItem;
  Rect: TRect; Pattern: Integer; var BlurImageArr: TBlurImageArr; BlurImage: Boolean;
  TextureFilter: TD2DTextureFilter; MirrorFlip: TRenderMirrorFlipSet;
  BlendMode: TRenderType;
  Angle: single;
  Alpha: Byte;
  CenterX: Double; CenterY: Double;
  Scale: single;
  WaveType: TWaveType;
  Amplitude: Integer; AmpLength: Integer; Phase: Integer);
{$IFDEF VER9UP}inline;
{$ENDIF}
var
  rr: TRect;
  i, Width, Height: Integer;
begin
  if not Assigned(DXDraw.Surface) then
    Exit;
  if not Assigned(Image) then
    Exit;
  if Scale <> 1.0 then
  begin
    Width := Round(Scale * Image.Width);
    Height := Round(Scale * Image.Height);
  end
  else
  begin
    Width := Image.Width;
    Height := Image.Height;
  end;
  //r := Bounds(X, Y, width, height);
  DXDraw.TextureFilter(TextureFilter);
  DXDraw.MirrorFlip(MirrorFlip);
  case BlendMode of
    rtDraw:
      begin
        case WaveType of
          wtWaveNone:
            begin
              if BlurImage then
              begin
                for i := Low(BlurImageArr) to High(BlurImageArr) do
                  if BlurImageArr[i].eActive then
                  begin
                    DXDraw.MirrorFlip(MirrorFlip);
                    rr := Bounds(BlurImageArr[i].eX, BlurImageArr[i].eY, Round(Scale * Width), Round(Scale * Height));
                    if Angle = 0 then
                      Image.DrawAlpha(DXDraw.Surface, rr, BlurImageArr[i].ePatternIndex, BlurImageArr[i].eIntensity)
                    else
                      Image.DrawRotateAlpha(DXDraw.Surface, (rr.Left + rr.Right) div 2,
                        (rr.Top + rr.Bottom) div 2,
                        Width, Height, BlurImageArr[i].ePatternIndex, CenterX, CenterY, BlurImageArr[i].eAngle, BlurImageArr[i].eIntensity);
                    if BlurImageArr[i].eIntensity > 0 then
                      Dec(BlurImageArr[i].eIntensity)
                    else
                      FillChar(BlurImageArr[i], SizeOf(BlurImageArr[i]), 0);
                  end;
              end;
              DXDraw.MirrorFlip(MirrorFlip);
              if Angle = 0 then
                Image.StretchDraw(DXDraw.Surface, Rect, Pattern)
              else
                Image.DrawRotate(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
                  (Rect.Top + Rect.Bottom) div 2,
                  Width, Height, Pattern, CenterX, CenterY, Angle);
            end;
          wtWaveX: Image.DrawWaveX(DXDraw.Surface, Round(Rect.Left), Round(Rect.Top), Width, Height, Pattern, Amplitude, AmpLength, Phase);
          wtWaveY: Image.DrawWaveY(DXDraw.Surface, Round(Rect.Left), Round(Rect.Top), Width, Height, Pattern, Amplitude, AmpLength, Phase);
        end;
      end;
    rtBlend:
      begin
        case WaveType of
          wtWaveNone:
            begin
              if BlurImage then
              begin
                for i := Low(BlurImageArr) to High(BlurImageArr) do
                  if BlurImageArr[i].eActive then
                  begin
                    DXDraw.MirrorFlip(MirrorFlip);
                    rr := Bounds(BlurImageArr[i].eX, BlurImageArr[i].eY, Round(Scale * Width), Round(Scale * Height));
                    if Angle = 0 then
                      Image.DrawAlpha(DXDraw.Surface, rr, Pattern, BlurImageArr[i].eIntensity)
                    else
                      Image.DrawRotateAlpha(DXDraw.Surface, (rr.Left + rr.Right) div 2,
                        (rr.Top + rr.Bottom) div 2,
                        Width, Height, Pattern, CenterX, CenterY, BlurImageArr[i].eAngle, BlurImageArr[i].eIntensity);
                    if BlurImageArr[i].eIntensity > 0 then
                      Dec(BlurImageArr[i].eIntensity)
                    else
                      FillChar(BlurImageArr[i], SizeOf(BlurImageArr[i]), 0);
                  end;
              end;
              DXDraw.MirrorFlip(MirrorFlip);
              if Angle = 0 then
                Image.DrawAlpha(DXDraw.Surface, Rect, Pattern, Alpha)
              else
                Image.DrawRotateAlpha(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
                  (Rect.Top + Rect.Bottom) div 2,
                  Width, Height, Pattern, CenterX, CenterY, Angle, Alpha);
            end;
          wtWaveX: Image.DrawWaveXAlpha(DXDraw.Surface, Round(Rect.Left), Round(Rect.Top), Width, Height, Pattern, Amplitude, AmpLength, Phase, Alpha);
          wtWaveY: Image.DrawWaveYAlpha(DXDraw.Surface, Round(Rect.Top), Round(Rect.Top), Width, Height, Pattern, Amplitude, AmpLength, Phase, Alpha);
        end;
      end;
    rtAdd:
      begin
        case WaveType of
          wtWaveNone:
            begin
              if BlurImage then
              begin
                for i := Low(BlurImageArr) to High(BlurImageArr) do
                  if BlurImageArr[i].eActive then
                  begin
                    DXDraw.MirrorFlip(MirrorFlip);
                    rr := Bounds(BlurImageArr[i].eX, BlurImageArr[i].eY, Round(Scale * Width), Round(Scale * Height));
                    if Angle = 0 then
                      Image.DrawAdd(DXDraw.Surface, rr, Pattern, BlurImageArr[i].eIntensity)
                    else
                      Image.DrawRotateAdd(DXDraw.Surface, (rr.Left + rr.Right) div 2,
                        (rr.Top + rr.Bottom) div 2,
                        Width, Height, Pattern, CenterX, CenterY, BlurImageArr[i].eAngle, BlurImageArr[i].eIntensity);
                    if BlurImageArr[i].eIntensity > 0 then
                      Dec(BlurImageArr[i].eIntensity)
                    else
                      FillChar(BlurImageArr[i], SizeOf(BlurImageArr[i]), 0);
                  end;
              end;
              DXDraw.MirrorFlip(MirrorFlip);
              if Angle = 0 then
                Image.DrawAdd(DXDraw.Surface, Rect, Pattern, Alpha)
              else
                Image.DrawRotateAdd(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
                  (Rect.Top + Rect.Bottom) div 2,
                  Width, Height, Pattern, CenterX, CenterY, Angle, Alpha);
            end;
          wtWaveX: Image.DrawWaveXAdd(DXDraw.Surface, Round(Rect.Left), Round(Rect.Top), Width, Height, Pattern, Amplitude, AmpLength, Phase, Alpha);
          wtWaveY: Image.DrawWaveYAdd(DXDraw.Surface, Round(Rect.Top), Round(Rect.Top), Width, Height, Pattern, Amplitude, AmpLength, Phase, Alpha);
        end;
      end;
    rtSub:
      begin
        case WaveType of
          wtWaveNone:
            begin
              if BlurImage then
              begin
                for i := Low(BlurImageArr) to High(BlurImageArr) do
                  if BlurImageArr[i].eActive then
                  begin
                    DXDraw.MirrorFlip(MirrorFlip);
                    rr := Bounds(BlurImageArr[i].eX, BlurImageArr[i].eY, Round(Scale * Width), Round(Scale * Height));
                    if Angle = 0 then
                      Image.DrawSub(DXDraw.Surface, rr, Pattern, BlurImageArr[i].eIntensity)
                    else
                      Image.DrawRotateSub(DXDraw.Surface, (rr.Left + rr.Right) div 2,
                        (rr.Top + rr.Bottom) div 2,
                        Width, Height, Pattern, CenterX, CenterY, BlurImageArr[i].eAngle, BlurImageArr[i].eIntensity);
                    if BlurImageArr[i].eIntensity > 0 then
                      Dec(BlurImageArr[i].eIntensity)
                    else
                      FillChar(BlurImageArr[i], SizeOf(BlurImageArr[i]), 0);
                  end;
              end;
              DXDraw.MirrorFlip(MirrorFlip);
              if Angle = 0 then
                Image.DrawSub(DXDraw.Surface, Rect, Pattern, Alpha)
              else
                Image.DrawRotateSub(DXDraw.Surface, (Rect.Left + Rect.Right) div 2,
                  (Rect.Top + Rect.Bottom) div 2,
                  Width, Height, Pattern, CenterX, CenterY, Angle, Alpha);
            end;
          wtWaveX: Image.DrawWaveXSub(DXDraw.Surface, Round(Rect.Left), Round(Rect.Top), Width, Height, Pattern, Amplitude, AmpLength, Phase, Alpha);
          wtWaveY: Image.DrawWaveYSub(DXDraw.Surface, Round(Rect.Top), Round(Rect.Top), Width, Height, Pattern, Amplitude, AmpLength, Phase, Alpha);
        end;
      end;
  end; {case}
end;

initialization
  g_DF.dwSize := SizeOf(g_DF);
  g_DF.dwDDFX := 0;
  g_DBltEx.dwSize := SizeOf(g_DBltEx);
  _DXTextureImageLoadFuncList := TList.Create;
  //TDXTextureImage.RegisterLoadFunc(DXTextureImage_LoadDXTextureImageFunc); //delete Mr.Kawasaki
  TDXTextureImage.RegisterLoadFunc(DXTextureImage_LoadBitmapFunc);

  //g_ddsd.dwSize := SizeOf(g_ddsd);
  //g_ddsd.dwFlags := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT;
  //g_ddsd.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN {or DDSCAPS_3DDEVICE} or DDSCAPS_SYSTEMMEMORY;
  //DDSCAPS_3DDEVICE DDSCAPS_VIDEOMEMORY

finalization
  //TDXTextureImage.UnRegisterLoadFunc(DXTextureImage_LoadDXTextureImageFunc); //delete Mr.Kawasaki
  TDXTextureImage.UnRegisterLoadFunc(DXTextureImage_LoadBitmapFunc);
  _DXTextureImageLoadFuncList.Free;
  { driver free }
  DirectDrawDrivers.Free;

end.

