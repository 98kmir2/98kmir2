unit WIL;

interface

uses
  Windows, Classes, Graphics, SysUtils, HashList, DXDraws, DXClass, Dialogs, GList,
  DirectX, DIB, wmUtil, HUtil32, VCLUnZip;

var
  g_boUseDIBSurface: Boolean = False;
  g_boWilNoCache: Boolean = False;
  g_CacheSize: LongWord;
  g_UnZip: TVCLUnZip;

const
  g_dwLoadSurfaceTime = 60 * 1000;
  g_dwLoadSurfaceTime4 = g_dwLoadSurfaceTime * 3;

  Int64_r: Int64 = $00FF000000FF0000;
  Int64_g: Int64 = $0000FF000000FF00;
  Int64_b: Int64 = $000000FF000000FF;

  Mask64_r: Int64 = $0000F8000000F800;
  Mask64_g: Int64 = $000007E0000007E0;
  Mask64_b: Int64 = $0000001F0000001F;

  //123456
  g_WZLHeaderData: array[0..63] of Byte = (
    $77, $77, $77, $2E, $73, $68, $61, $6E, $64, $61, $67, $61, $6D, $65, $73,
    $2E, $63, $6F, $6D, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00
    );

  g_PalData: array[0..1023] of Byte = (
    $00, $00, $00, $00, $00, $00, $80, $FF, $00, $80, $00, $FF, $00, $80, $80,
    $FF, $80, $00, $00, $FF, $80, $00, $80, $FF, $80, $80, $00, $FF, $C0, $C0,
    $C0, $FF, $97, $80, $55, $FF, $C8, $B9, $9D, $FF, $73, $73, $7B, $FF, $29,
    $29, $2D, $FF, $52, $52, $5A, $FF, $5A, $5A, $63, $FF, $39, $39, $42, $FF,
    $18, $18, $1D, $FF, $10, $10, $18, $FF, $18, $18, $29, $FF, $08, $08, $10,
    $FF, $71, $79, $F2, $FF, $5F, $67, $E1, $FF, $5A, $5A, $FF, $FF, $31, $31,
    $FF, $FF, $52, $5A, $D6, $FF, $00, $10, $94, $FF, $18, $29, $94, $FF, $00,
    $08, $39, $FF, $00, $10, $73, $FF, $00, $18, $B5, $FF, $52, $63, $BD, $FF,
    $10, $18, $42, $FF, $99, $AA, $FF, $FF, $00, $10, $5A, $FF, $29, $39, $73,
    $FF, $31, $4A, $A5, $FF, $73, $7B, $94, $FF, $31, $52, $BD, $FF, $10, $21,
    $52, $FF, $18, $31, $7B, $FF, $10, $18, $2D, $FF, $31, $4A, $8C, $FF, $00,
    $29, $94, $FF, $00, $31, $BD, $FF, $52, $73, $C6, $FF, $18, $31, $6B, $FF,
    $42, $6B, $C6, $FF, $00, $4A, $CE, $FF, $39, $63, $A5, $FF, $18, $31, $5A,
    $FF, $00, $10, $2A, $FF, $00, $08, $15, $FF, $00, $18, $3A, $FF, $00, $00,
    $08, $FF, $00, $00, $29, $FF, $00, $00, $4A, $FF, $00, $00, $9D, $FF, $00,
    $00, $DC, $FF, $00, $00, $DE, $FF, $00, $00, $FB, $FF, $52, $73, $9C, $FF,
    $4A, $6B, $94, $FF, $29, $4A, $73, $FF, $18, $31, $52, $FF, $18, $4A, $8C,
    $FF, $11, $44, $88, $FF, $00, $21, $4A, $FF, $10, $18, $21, $FF, $5A, $94,
    $D6, $FF, $21, $6B, $C6, $FF, $00, $6B, $EF, $FF, $00, $77, $FF, $FF, $84,
    $94, $A5, $FF, $21, $31, $42, $FF, $08, $10, $18, $FF, $08, $18, $29, $FF,
    $00, $10, $21, $FF, $18, $29, $39, $FF, $39, $63, $8C, $FF, $10, $29, $42,
    $FF, $18, $42, $6B, $FF, $18, $4A, $7B, $FF, $00, $4A, $94, $FF, $7B, $84,
    $8C, $FF, $5A, $63, $6B, $FF, $39, $42, $4A, $FF, $18, $21, $29, $FF, $29,
    $39, $46, $FF, $94, $A5, $B5, $FF, $5A, $6B, $7B, $FF, $94, $B1, $CE, $FF,
    $73, $8C, $A5, $FF, $5A, $73, $8C, $FF, $73, $94, $B5, $FF, $73, $A5, $D6,
    $FF, $4A, $A5, $EF, $FF, $8C, $C6, $EF, $FF, $42, $63, $7B, $FF, $39, $56,
    $6B, $FF, $5A, $94, $BD, $FF, $00, $39, $63, $FF, $AD, $C6, $D6, $FF, $29,
    $42, $52, $FF, $18, $63, $94, $FF, $AD, $D6, $EF, $FF, $63, $8C, $A5, $FF,
    $4A, $5A, $63, $FF, $7B, $A5, $BD, $FF, $18, $42, $5A, $FF, $31, $8C, $BD,
    $FF, $29, $31, $35, $FF, $63, $84, $94, $FF, $4A, $6B, $7B, $FF, $5A, $8C,
    $A5, $FF, $29, $4A, $5A, $FF, $39, $7B, $9C, $FF, $10, $31, $42, $FF, $21,
    $AD, $EF, $FF, $00, $10, $18, $FF, $00, $21, $29, $FF, $00, $6B, $9C, $FF,
    $5A, $84, $94, $FF, $18, $42, $52, $FF, $29, $5A, $6B, $FF, $21, $63, $7B,
    $FF, $21, $7B, $9C, $FF, $00, $A5, $DE, $FF, $39, $52, $5A, $FF, $10, $29,
    $31, $FF, $7B, $BD, $CE, $FF, $39, $5A, $63, $FF, $4A, $84, $94, $FF, $29,
    $A5, $C6, $FF, $18, $9C, $10, $FF, $4A, $8C, $42, $FF, $42, $8C, $31, $FF,
    $29, $94, $10, $FF, $10, $18, $08, $FF, $18, $18, $08, $FF, $10, $29, $08,
    $FF, $29, $42, $18, $FF, $AD, $B5, $A5, $FF, $73, $73, $6B, $FF, $29, $29,
    $18, $FF, $4A, $42, $18, $FF, $4A, $42, $31, $FF, $DE, $C6, $63, $FF, $FF,
    $DD, $44, $FF, $EF, $D6, $8C, $FF, $39, $6B, $73, $FF, $39, $DE, $F7, $FF,
    $8C, $EF, $F7, $FF, $00, $E7, $F7, $FF, $5A, $6B, $6B, $FF, $A5, $8C, $5A,
    $FF, $EF, $B5, $39, $FF, $CE, $9C, $4A, $FF, $B5, $84, $31, $FF, $6B, $52,
    $31, $FF, $D6, $DE, $DE, $FF, $B5, $BD, $BD, $FF, $84, $8C, $8C, $FF, $DE,
    $F7, $F7, $FF, $18, $08, $00, $FF, $39, $18, $08, $FF, $29, $10, $08, $FF,
    $00, $18, $08, $FF, $00, $29, $08, $FF, $A5, $52, $00, $FF, $DE, $7B, $00,
    $FF, $4A, $29, $10, $FF, $6B, $39, $10, $FF, $8C, $52, $10, $FF, $A5, $5A,
    $21, $FF, $5A, $31, $10, $FF, $84, $42, $10, $FF, $84, $52, $31, $FF, $31,
    $21, $18, $FF, $7B, $5A, $4A, $FF, $A5, $6B, $52, $FF, $63, $39, $29, $FF,
    $DE, $4A, $10, $FF, $21, $29, $29, $FF, $39, $4A, $4A, $FF, $18, $29, $29,
    $FF, $29, $4A, $4A, $FF, $42, $7B, $7B, $FF, $4A, $9C, $9C, $FF, $29, $5A,
    $5A, $FF, $14, $42, $42, $FF, $00, $39, $39, $FF, $00, $59, $59, $FF, $2C,
    $35, $CA, $FF, $21, $73, $6B, $FF, $00, $31, $29, $FF, $10, $39, $31, $FF,
    $18, $39, $31, $FF, $00, $4A, $42, $FF, $18, $63, $52, $FF, $29, $73, $5A,
    $FF, $18, $4A, $31, $FF, $00, $21, $18, $FF, $00, $31, $18, $FF, $10, $39,
    $18, $FF, $4A, $84, $63, $FF, $4A, $BD, $6B, $FF, $4A, $B5, $63, $FF, $4A,
    $BD, $63, $FF, $4A, $9C, $5A, $FF, $39, $8C, $4A, $FF, $4A, $C6, $63, $FF,
    $4A, $D6, $63, $FF, $4A, $84, $52, $FF, $29, $73, $31, $FF, $5A, $C6, $63,
    $FF, $4A, $BD, $52, $FF, $00, $FF, $10, $FF, $18, $29, $18, $FF, $4A, $88,
    $4A, $FF, $4A, $E7, $4A, $FF, $00, $5A, $00, $FF, $00, $88, $00, $FF, $00,
    $94, $00, $FF, $00, $DE, $00, $FF, $00, $EE, $00, $FF, $00, $FB, $00, $FF,
    $94, $5A, $4A, $FF, $B5, $73, $63, $FF, $D6, $8C, $7B, $FF, $D6, $7B, $6B,
    $FF, $FF, $88, $77, $FF, $CE, $C6, $C6, $FF, $9C, $94, $94, $FF, $C6, $94,
    $9C, $FF, $39, $31, $31, $FF, $84, $18, $29, $FF, $84, $00, $18, $FF, $52,
    $42, $4A, $FF, $7B, $42, $52, $FF, $73, $5A, $63, $FF, $F7, $B5, $CE, $FF,
    $9C, $7B, $8C, $FF, $CC, $22, $77, $FF, $FF, $AA, $DD, $FF, $2A, $B4, $F0,
    $FF, $9F, $00, $DF, $FF, $B3, $17, $E3, $FF, $F0, $FB, $FF, $FF, $A4, $A0,
    $A0, $FF, $80, $80, $80, $FF, $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00,
    $FF, $FF, $FF, $FF, $00, $00, $FF, $FF, $00, $FF, $FF, $FF, $FF, $00, $FF,
    $FF, $FF, $FF, $FF
    );

type
  TLibType = (ltLoadBmp, ltLoadMemory, ltLoadMunual, ltUseCache);

  TWZLHeader = packed record
    Title: array[0..$30 - 1 - 4] of char;
    ImageCount: Integer;
  end;
  PTWZLHeader = ^TWZLHeader;

  TWZLInfo = packed record
    ColorFlag: Byte; //00 3 5
    FixSize: Boolean; //01
    Reserve0: Byte; //02
    Reserve1: Byte; //03
    Width: SmallInt; //04 位图宽度
    Height: SmallInt; //06 位图高度
    Px: SmallInt; //08
    Py: SmallInt; //0A
    Size: Integer; //0C
  end;
  PTWZLInfo = ^TWZLInfo;

  PBitmapFileHeader = ^TBitmapFileHeader;
  tagBITMAPFILEHEADER = packed record
    bfType: Word; // 位图文件的类型，必须为bm
    bfSize: DWORD; // 位图文件的大小，以字节为单位
    bfReserved1: Word; // 位图文件保留字，必须为0
    bfReserved2: Word; // 位图文件保留字，必须为0
    bfOffBits: DWORD; // 位图数据的起始位置，以相对于位图
  end;
  TBitmapFileHeader = tagBITMAPFILEHEADER;
  BITMAPFILEHEADER = tagBITMAPFILEHEADER;

  PBitmapInfoHeader = ^TBitmapInfoHeader;
  tagBITMAPINFOHEADER = packed record
    biSize: DWORD; // 本结构所占用字节数
    biWidth: Longint; // 位图的宽度，以像素为单位
    biHeight: Longint; // 位图的高度，以像素为单位
    biPlanes: Word; // 目标设备的级别，必须为1
    biBitCount: Word; // 每个像素所需的位数，必须是1(双色)，4(16色)，8(256色)或24(真彩色)之一
    biCompression: DWORD; // 位图压缩类型，必须是 0(不压缩)，1(bi_rle8压缩类型)或2(bi_rle4压缩类型)之一
    biSizeImage: DWORD; // 位图的大小，以字节为单位
    biXPelsPerMeter: Longint; // 位图水平分辨率，每米像素数
    biYPelsPerMeter: Longint; // 位图Y分辨率，每米像素数
    biClrUsed: DWORD;
    biClrImportant: DWORD;
  end;
  TBitmapInfoHeader = tagBITMAPINFOHEADER;
  BITMAPINFOHEADER = tagBITMAPINFOHEADER;

  TBmpImage = record
    Bmp: TBitmap;
    dwLatestTime: LongWord;
  end;
  pTBmpImage = ^TBmpImage;

  TBmpImageArr = array[0..MaxListSize div 4] of TBmpImage;
  TDxImageArr = array[0..MaxListSize div 4] of TDxImage;
  PTBmpImageArr = ^TBmpImageArr;
  PTDxImageArr = ^TDxImageArr;

  TWisHeader = packed record
    nTitle: Integer; //04 $41534957 = WISA
    VerFlag: Integer; //01
    Reserve1: Integer; //00
    DateTime: TDateTime;
    Reserve2: Integer;
    Reserve3: Integer;
    CopyRight: string[20];
    aTemp1: array[1..107] of char;
    nIndexsEncrypt: Integer; //0XA0
    nHeaderLen: Integer; //0XA4
    nImageCount: Integer; //0XA8
    nIndexsData: Integer; //0XAC
    nColorCount: Integer;
    aTemp2: array[1..$200 - $AC - $04] of char;
  end;
  PTWisHeader = ^TWisHeader;

  TWisIndex = record
    Offset: Integer;
    Length: Integer;
    temp3: Integer;
  end;
  PTWisIndex = ^TWisIndex;
  TWisIndexs = array of TWisIndex;

  TImgInfo = packed record
    bPack: Byte; //0X00
    bEncrypt: Byte; //0X01
    bt2: Byte; //0X02
    bt3: Byte; //0X03
    wW: SmallInt; //0X04
    wh: SmallInt; //0X06
    wPx: SmallInt; //0X08
    wPy: SmallInt; //0X0A
  end;
  PTImgInfo = ^TImgInfo;

  TFFileStream = class(TStream)
  private
    FFileName: string;
    FSize: Integer;
    FPosition: Integer;
    FMemory: Pointer;
    FFileHandle: THandle;
    FMappingHandle: THandle;
  public
    function Read(var Buffer; count: Longint): Longint; override;
    function GetSize(): Int64; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    constructor Create(const AFileName: string);
    property FileName: string read FFileName;
  end;

  TWis = class
  public
    m_Header: TWisHeader;
    m_Handle: THandle; //204
    m_Debug: Integer; //208
    m_FileName: string; //20c
    m_CreateFlag: Byte; //20c
    m_Indexs: TWisIndexs;
    constructor Create();
    function Opened(): Boolean;
    function IsValidIdx(nIdx: Integer): Boolean;
    function WCloseFile(): Boolean;
    function Closed(): Boolean;
    function Initialize(sFile: string; flag: Integer): Boolean;
    function CreateFile(sFile: string; flag: Byte): Boolean;
    function LoadHeader(sFile: string; flag: Boolean): Boolean;
    function ProcHeaderData(): Boolean;
    function LoadImageData(nIdx: Integer; var buf: PChar; var hLen: Integer): Boolean;
    function Seek(const Offset: Int64): Boolean;
    function Read(var buf; Size: DWORD): Boolean;
  end;

  TDXImages = class(TComponent)
  private
    F16BIT: Boolean;
    FFileName: string;
    FLibType: TLibType;
    FDxDraw: TDXDraw;
    FDDraw: TDirectDraw;
    procedure FSetDxDraw(fdd: TDXDraw);
  protected
    //m_lsDib: TDIB;
  public
    FImageCount: Integer;
    FFileNameEx: string;
    m_ImgArr: PTDxImageArr;
    //m_MainPalette: TRGBQuads;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
  published
    property DDraw: TDirectDraw read FDDraw write FDDraw;
    property FileName: string read FFileName write FFileName;
    property ImageCount: Integer read FImageCount;
  end;

  TWMImages = class(TDXImages)
  private
    FMaxMemorySize: Integer;
    FAppr: Word;
    FImageType: Word;
    //  function GetFileSize(const sFile: string; const Offset, DefSize: Integer): Integer;  私有成员函数未调用  2019-10-07 18:01:33
    // procedure LoadIndex(IdxFile: string);                           私有成员函数未调用  2019-10-07 18:01:33
    //function Get16BitRGB(bRGB: byte): Integer;
    //function Get24BitRGB(bRGB: byte): Integer;
    procedure LoadDxImage(Position: Integer; pdximg: PTDxImage; bAnti: Boolean = False);
    procedure LoadDxImage_Wis(Position: Integer; pdximg: PTDxImage; bAnti: Boolean = False);
    procedure LoadDxImage_Wzl(Position, nIndex: Integer; pdximg: PTDxImage);

    function LoadDxImage_Header(Position: Integer; var pt: TPoint): Boolean;
    function LoadDxImage_Wis_Header(Position: Integer; var pt: TPoint): Boolean;

    function FGetImageSurface(Index: Integer): TDirectDrawSurface;
    // function BlendAnti(idx: Integer): Boolean;         私有成员函数未调用  2019-10-07 18:01:33
  public
    m_fQueryIndex: Boolean;
    m_fQueryImgCnt: Boolean;
    m_PatchIdx: Integer;
    m_Wis: TWis;
    m_BmpArr: PTBmpImageArr;
    m_IndexList: TList;
    m_FileStream: TFileStream;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    procedure ClearCache;
    //procedure LoadPalette;
    function GetCachedDxImage(Index: Integer): PTDxImage;
    function GetCachedImage(Index: Integer; var Px, Py: Integer): TDirectDrawSurface;
    function GetCachedSurface(Index: Integer): TDirectDrawSurface;
    function GetImageSize(Index: Integer; var pt: TPoint): Boolean; overload;
    property Images[Index: Integer]: TDirectDrawSurface read FGetImageSurface;
  published
    property DXDraw: TDXDraw read FDxDraw write FSetDxDraw;
    property LibType: TLibType read FLibType write FLibType;
    property MaxMemorySize: Integer read FMaxMemorySize write FMaxMemorySize;
    property Appr: Word read FAppr write FAppr;
  end;

  TUIBImages = class(TDXImages)
  private
    FSearchPath: string;
    FSearchFileExt: string;
    FSearchSubDir: Boolean;
    procedure UiLoadDxImage(pdximg: PTDxImage; fhandle: THandle {sFileName: string});
    function FUiGetImageSurface(F: string): TDirectDrawSurface;
  public
    m_FileList: THStringList;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    procedure ClearCache;
    function UiGetCachedSurface(F: string): PTDxImage;
    property Images[F: string]: TDirectDrawSurface read FUiGetImageSurface;
    procedure AddUibFileList(sFile: string);
    procedure GetUibFileList(Path, ext: string);
    procedure RecurSearchFile(Path, FileType: string);
  published
    property SearchPath: string read FSearchPath write FSearchPath;
    property SearchFileExt: string read FSearchFileExt write FSearchFileExt;
    property SearchSubDir: Boolean read FSearchSubDir write FSearchSubDir default False;
    property DXDraw: TDXDraw read FDxDraw write FSetDxDraw;
    property LibType: TLibType read FLibType write FLibType default ltUseCache;
  end;

  TImageManager = class
  public
    m_CheckTick: LongWord;
    m_ImagesMemory: Integer;
    m_ImagesList: TList;
    constructor Create();
  end;

var
  g_WZLHeader: TWZLHeader;
  g_ImageManager: TImageManager;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads; AllowPalette256: Boolean): TPaletteEntries;
procedure TrainBuffer(p: PChar; Len: Integer); register;

implementation

uses ClMain, MShare, cliUtil, PatchUnit;

constructor TImageManager.Create();
begin
  inherited Create();
  m_ImagesMemory := 0;
  m_ImagesList := TList.Create;
end;

procedure memcpy_sse2(const src: Pointer; dest: Pointer; const size_t: LongWord);
asm
      pushad
      shr ecx, 7;      //divide by 128 (8 * 128bit registers)

    @loop_copy:
      prefetchnta 128[eax]; //SSE2 prefetch
      prefetchnta 160[eax];
      prefetchnta 192[eax];
      prefetchnta 224[eax];
 
      movdqa xmm0, 0[eax]; //move data from src to registers
      movdqa xmm1, 16[eax];
      movdqa xmm2, 32[eax];
      movdqa xmm3, 48[eax];
      movdqa xmm4, 64[eax];
      movdqa xmm5, 80[eax];
      movdqa xmm6, 96[eax];
      movdqa xmm7, 112[eax];
 
      movntdq 0[edx], xmm0; //move data from registers to dest
      movntdq 16[edx], xmm1;
      movntdq 32[edx], xmm2;
      movntdq 48[edx], xmm3;
      movntdq 64[edx], xmm4;
      movntdq 80[edx], xmm5;
      movntdq 96[edx], xmm6;
      movntdq 112[edx], xmm7;
 
      add eax, 128;
      add edx, 128;
      dec ecx;
 
      jnz @loop_copy; //loop please
      popad
end;

procedure TrainBuffer(p: PChar; Len: Integer); assembler;
asm
  cmp edx, 00000000
  jle @Exit
  push ebx
  mov cl, dl

@Loop:
  mov bl, byte ptr [eax]
  xor cl, $AA
  inc cl
  ror cl, 1
  xor bl, cl
  mov byte ptr [eax], bl
  inc eax
  dec edx
  test edx, edx
  jne @Loop
  pop ebx

@Exit:
  //ret
end;

procedure WisUppackData(src: PByte; ScrLen: Integer; dest: PByte; DestLen: Integer);
var
  i, dlen, cpl: Integer;
  bt: Byte;
begin
  if ScrLen > 0 then
  begin
    cpl := 0;
    while cpl < ScrLen do
    begin
      if PByte(src)^ = 0 then
      begin
        Inc(PByte(src));
        dlen := PByte(src)^;
        Inc(PByte(src));
        Move(src^, dest^, dlen);
        Inc(src, dlen);
        Inc(dest, dlen);
        Inc(dlen, SizeOf(Word));
        Inc(cpl, dlen);
      end
      else
      begin
        dlen := PByte(src)^;
        Inc(PByte(src));
        bt := PByte(src)^;
        Inc(PByte(src));
        if dlen = 1 then
        begin
          PByte(dest)^ := bt;
          Inc(PByte(dest));
        end
        else
        begin
          for i := 0 to dlen - 1 do
          begin
            PByte(dest)^ := bt;
            Inc(PByte(dest));
          end;
        end;
        Inc(cpl, 2);
      end;
    end;
  end;
end;

function WisUppackData2(src: PByte; ScrLen: Integer; var dest: PByte; var DestLen: Integer): Boolean;
type
  TWisPackData = packed record
    flag: DWORD; //00
    datalen: Integer; //04
    tmp1: DWORD; //08
    tmp2: DWORD; //0c
    data: Pointer; //10
  end;
  PTWisPackData = ^TWisPackData;

var
  i: Integer;
  pDest: DWORD;
  DStart, DEnd: DWORD;
  wLen: DWORD;
  wDat: Word;
  pw: PTWisPackData;
label
  Loop;
begin
  Result := False;
  dest := nil;
  DestLen := 0;
  pw := PTWisPackData(src);
  if src <> nil then
  begin
    if ScrLen >= 16 then
    begin
      if pw.flag = $FFEEFFEE then
      begin
        ReAllocMem(dest, pw.datalen);
        FillChar(dest^, pw.datalen, #0);

        pDest := DWORD(dest);

        DStart := Integer(PChar(pw) + $10);

        DEnd := Integer(PChar(pw) + ScrLen);
        try
          while DStart < DEnd do
          begin
            wLen := PWord(DStart)^;
            if wLen = 0 then
            begin
              Inc(PWord(DStart));
              wLen := PWord(DStart)^ * 2;
              Inc(PWord(DStart));
              //wLen := wLen + wLen;
              if pw.datalen < wLen + DestLen then
                wLen := pw.datalen - DestLen;
              if wLen <> 0 then
              begin
                Move(PByte(DStart)^, PByte(pDest)^, wLen);
                Inc(DStart, wLen);
                Inc(pDest, wLen);
                Inc(DestLen, wLen);
              end;
            end
            else
            begin
              if wLen > 0 then
              begin
                Inc(PWord(DStart));
                wDat := PWord(DStart)^;
                Inc(PWord(DStart));
                i := 0;
                while (i < wLen) and (DestLen < pw.datalen) do
                begin
                  PWord(pDest)^ := wDat;
                  Inc(PWord(pDest));
                  Inc(DestLen, SizeOf(Word));
                  Inc(i);
                end;
              end
              else
                Inc(PByte(DStart));
            end;
          end;
          ReAllocMem(dest, DestLen);
          Result := True;
        except
          FreeMem(dest);
          dest := nil;
          DestLen := 0;
        end;
      end;
    end;
  end;
end;

constructor TWis.Create();
begin
  inherited Create();
  FillChar(m_Header, SizeOf(m_Header), 0);
  m_Handle := 0;
  m_Debug := 0;
  m_FileName := '';
  m_CreateFlag := 0;
  m_Indexs := nil;
end;

function TWis.WCloseFile(): Boolean;
begin
  if m_Handle <> 0 then
  begin
    Result := CloseHandle(m_Handle);
    if Result then
      m_Handle := 0;
  end
  else
    Result := True;
end;

function TWis.Opened(): Boolean;
begin
  Result := m_Handle <> 0;
  if not Result then
    m_Debug := $000003F4;
end;

function TWis.IsValidIdx(nIdx: Integer): Boolean;
begin
  Result := (nIdx >= 0) and (nIdx < m_Header.nImageCount);
  if not Result then
    m_Debug := $000003F1;
end;

function TWis.LoadImageData(nIdx: Integer; var buf: PChar; var hLen: Integer): Boolean;
var
  wh: TWisIndex;
begin
  Result := False;
  if Opened() and IsValidIdx(nIdx) then
  begin
    wh := m_Indexs[nIdx];
    hLen := wh.Length;
    if hLen > 0 then
    begin
      if Seek(wh.Offset) then
      begin
        GetMem(buf, wh.Length);
        if Read(buf^, hLen) then
          Result := True
        else
        begin
          FreeMem(buf);
          buf := nil;
        end;
      end;
    end
    else
      buf := nil;
  end;
end;

function TWis.Closed(): Boolean;
var
  bClosed: Boolean;
begin
  bClosed := m_Handle = 0;
  if not bClosed then
  begin
    if WCloseFile() then
    begin
      m_FileName := '';
      FillChar(m_Header, SizeOf(m_Header), 0);
      m_Indexs := nil;
    end;
  end;
  Result := bClosed;
end;

function TWis.Seek(const Offset: Int64): Boolean;
begin
  Result := SetFilePointer(m_Handle, Offset, 0, 0) <> INVALID_HANDLE_VALUE;
end;

function TWis.Read(var buf; Size: DWORD): Boolean;
var
  BytesRead: DWORD;
begin
  if not ReadFile(m_Handle, buf, Size, BytesRead, nil) or (BytesRead <> Size) then
    Result := False
  else
    Result := True;
  if not Result then
    m_Debug := $000003ED
end;

function TWis.ProcHeaderData(): Boolean;
var
  ph: PChar;
  LenOfIdxs: Integer;
begin
  Result := False;
  if Seek(0) then
  begin
    if Read(m_Header, SizeOf(m_Header)) then
    begin
      ph := @m_Header;
      TrainBuffer(@ph[4], SizeOf(m_Header) - 4);
      if (m_Header.nImageCount > 0) and Seek(m_Header.nIndexsData) then
      begin
        SetLength(m_Indexs, m_Header.nImageCount);
        LenOfIdxs := SizeOf(TWisIndex) * m_Header.nImageCount;
        if Read(m_Indexs[0], LenOfIdxs) then
        begin
          if m_Header.nIndexsEncrypt <> 0 then
            TrainBuffer(@m_Indexs[0], LenOfIdxs);
          Result := True;
        end;
      end;
    end;
  end;
end;

function TWis.CreateFile(sFile: string; flag: Byte): Boolean;
const
  dwDesiredAccessFlags: array[0..2] of DWORD = (GENERIC_READ, GENERIC_READ or GENERIC_WRITE, GENERIC_READ or GENERIC_WRITE);
  dwShareModeFlags: array[0..2] of DWORD = (FILE_SHARE_READ, DWORD(0) {FILE_SHARE_WRITE}, DWORD(0));
  dwCreationDispositionFlags: array[0..2] of DWORD = (OPEN_EXISTING, OPEN_EXISTING, CREATE_ALWAYS);
var
  bFlag: Boolean;
  Handle: THandle;
begin
  bFlag := m_Handle = 0;
  if not bFlag then
    m_Debug := $000003E9
  else
  begin //not Handled
    Handle := Windows.CreateFile(PChar(sFile),
      dwDesiredAccessFlags[flag],
      dwShareModeFlags[flag],
      nil,
      dwCreationDispositionFlags[flag],
      FILE_ATTRIBUTE_NORMAL,
      0);
    m_Handle := Handle;
    bFlag := Handle <> INVALID_HANDLE_VALUE;
    if bFlag then
    begin
      m_FileName := sFile;
      m_CreateFlag := flag;
    end
    else
    begin
      if flag = 2 then
        m_Debug := $000003EA
      else
        m_Debug := $000003EB;
    end;
  end;
  Result := bFlag;
end;

function TWis.LoadHeader(sFile: string; flag: Boolean): Boolean;
const
  CreateWisFileFlags: array[Boolean] of Byte = (1, 0);
begin
  Result := False;
  if Self.CreateFile(sFile, 0 {read only} {CreateWisFileFlags[flag]}) then
  begin
    if ProcHeaderData() then
      Result := True;
  end;
end;

function TWis.Initialize(sFile: string; flag: Integer): Boolean;
begin
  Result := False;
  m_Debug := 0;
  if Closed() then
  begin
    case flag of
      2: ;
      1: Result := LoadHeader(sFile, False);
      0: Result := LoadHeader(sFile, True);
    end;
  end;
end;

function CurrentIsValidDir(SearchRec: TSearchRec): Integer;
begin
  if ((SearchRec.Attr <> 16) and
    (SearchRec.Name <> '.') and
    (SearchRec.Name <> '..')) then
    Result := 0
  else if ((SearchRec.Attr = 16) and
    (SearchRec.Name <> '.') and
    (SearchRec.Name <> '..')) then
    Result := 1
  else
    Result := 2;
end;

constructor TFFileStream.Create(const AFileName: string);
var
  FileSizeHigh: LongWord;
begin
  FFileHandle := CreateFile(PChar(AFileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if FFileHandle = INVALID_HANDLE_VALUE then
    raise Exception.Create('Error when open file');

  FSize := GetFileSize(FFileHandle, @FileSizeHigh);
  if FSize = INVALID_FILE_SIZE then
    raise Exception.Create('Error when get file size');

  FMappingHandle := CreateFileMapping(FFileHandle, nil, PAGE_READONLY, 0, 0, nil);
  if FMappingHandle = 0 then
    raise Exception.Create('Error when mapping file');

  FMemory := MapViewOfFile(FMappingHandle, FILE_MAP_READ, 0, 0, 0);
  if FMemory = nil then
    raise Exception.Create('Error when map view of file');

end;

function TFFileStream.Read(var Buffer; count: Longint): Longint;
begin
  if (FPosition >= 0) and (count >= 0) then
  begin
    Result := FSize - FPosition;
    if Result > 0 then
    begin
      if Result > count then
        Result := count;
      //Move(Pointer(Longint(FMemory) + FPosition)^, Buffer, Result);
      CopyMemory(Pointer(@Buffer), Pointer(Longint(FMemory) + FPosition), Result);
      Inc(FPosition, Result);
      Exit;
    end;
  end;
  Result := 0;
end;

function TFFileStream.GetSize(): Int64;
begin
  Result := FSize;
end;

function TFFileStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  case Ord(Origin) of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: Inc(FPosition, Offset);
    soFromEnd: FPosition := FSize + Offset;
  end;
  Result := FPosition;
end;

constructor TDXImages.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  F16BIT := False;
  FFileName := '';
  FFileNameEx := '';
  FLibType := ltUseCache;
  FImageCount := 0;
  FDDraw := nil;
  FDxDraw := nil;
  m_ImgArr := nil;
end;

destructor TDXImages.Destroy;
begin
  inherited Destroy;
end;

procedure TDXImages.FSetDxDraw(fdd: TDXDraw);
begin
  FDxDraw := fdd;
end;

{TWMImages}

constructor TWMImages.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  m_fQueryIndex := False;
  m_fQueryImgCnt := False;
  FMaxMemorySize := 1024 * 1000;
  FAppr := 0;
  FImageType := 0;
  m_FileStream := nil;
  m_BmpArr := nil;
  m_Wis := nil;
  m_IndexList := TList.Create;
end;

destructor TWMImages.Destroy;
begin
  if m_Wis <> nil then
    FreeAndNil(m_Wis);
  FreeAndNil(m_IndexList);
  if m_FileStream <> nil then
    FreeAndNil(m_FileStream);
  inherited Destroy;
end;

procedure TWMImages.Initialize;
var
  sWisFile, sWzlFile: string;
  IdxFile: string;
  Header: TWMImageHeader;
  IndexHeader: TWMIndexHeader;
  WZLHeader: TWZLHeader;
  WZXHeader: TWZLHeader;
  i, nValue: Integer;
  fhandle: THandle;
  pValue: PInteger;
begin
  try
    if not (csDesigning in ComponentState) then
    begin
      if FFileName = '' then
      begin
        raise Exception.Create('FileName not assigned..');
        Exit;
      end;
      if {(LibType <> ltLoadBmp) and}(FDDraw = nil) then
      begin
        raise Exception.Create('DDraw not assigned..');
        Exit;
      end;

    //123456
      FFileNameEx := ExtractFileName(FFileName);
      FFileNameEx := ChangeFileExt(FFileNameEx, '');

      g_PatchClientManager.m_xWMImageList.AddObject(FFileNameEx, Self);
      g_PatchClientManager.AssignedWMImages(FFileNameEx, Self);

      sWisFile := ChangeFileExt(FFileName, '.wis');
      sWzlFile := ChangeFileExt(FFileName, '.wzl');

      if FileExists(sWisFile) and (g_fWZLFirst and 1 <> 0) then
      begin
        m_Wis := TWis.Create;
        if not m_Wis.Initialize(sWisFile, 0) then
        begin
          FreeAndNil(m_Wis);
          Exit;
        end;
        FImageType := 1;
        F16BIT := m_Wis.m_Header.nColorCount = 65536;
        FImageCount := m_Wis.m_Header.nImageCount;
        m_ImgArr := AllocMem(SizeOf(TDxImage) * FImageCount);
      end
      else if FileExists(FFileName) and (g_fWZLFirst and 2 <> 0) then
      begin

        if m_FileStream = nil then
          m_FileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);

        m_FileStream.Read(Header, SizeOf(TWMImageHeader));
        if Header.VerFlag = 0 then
          m_FileStream.Seek(-4, soFromCurrent);

        F16BIT := Header.ColorCount = 65536;

        IdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) +'.WIX';
        fhandle := FileOpen(IdxFile, fmOpenRead or fmShareDenyNone);
        if fhandle <> INVALID_HANDLE_VALUE then           //> 0 then
        begin
          FileRead(fhandle, IndexHeader, SizeOf(TWMIndexHeader) - 4);

          if (UpperCase(PChar(@IndexHeader)[0]) = 'M') and (UpperCase(PChar(@IndexHeader)[4]) = 'F') then
          begin
            FileSeek(fhandle, 5, 0);
            FileRead(fhandle, IndexHeader, SizeOf(TWMIndexHeader) - 4);
          end;

          FImageCount := Header.ImageCount;
          if FImageCount > IndexHeader.IndexCount then
            FImageCount := IndexHeader.IndexCount;

          if FImageCount > 0 then
          begin
            m_ImgArr := AllocMem(SizeOf(TDxImage) * FImageCount);
            GetMem(pValue, 4 * FImageCount);
            FileRead(fhandle, pValue^, 4 * FImageCount);
            for i := 0 to FImageCount - 1 do
            begin
              nValue := PInteger(Integer(pValue) + 4 * i)^;
              m_IndexList.Add(Pointer(nValue));
            end;
            FreeMem(pValue);
          end;
          FileClose(fhandle);
        end;
        FImageType := 2;
      end
      else if (g_fWZLFirst and 4 <> 0) then
      begin
      //123456
        IdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.wzx';
        if not FileExists(sWzlFile) then
        begin
          fhandle := FileCreate(sWzlFile);
          FileWrite(fhandle, g_WZLHeaderData, SizeOf(g_WZLHeaderData));
          FileClose(fhandle);
        end;
        if not FileExists(IdxFile) then
        begin
          fhandle := FileCreate(IdxFile);
          FileWrite(fhandle, g_WZLHeader, SizeOf(g_WZLHeader));
          FileClose(fhandle);
        end;

        if FileExists(sWzlFile) then
        begin
          if FileExists(IdxFile) then
          begin
            m_IndexList.Clear;
            FileSetAttr(sWzlFile, 0);
            FileSetAttr(IdxFile, 0);
            m_FileStream := TFileStream.Create(sWzlFile, fmOpenReadWrite or fmShareDenyNone);
            m_FileStream.Read(WZLHeader, SizeOf(WZLHeader));

            FImageCount := 0;
            fhandle := FileOpen(IdxFile, fmOpenReadWrite or fmShareDenyNone);
            if fhandle <> INVALID_HANDLE_VALUE then
            begin
              FileRead(fhandle, WZXHeader, SizeOf(WZXHeader));
              if (WZLHeader.ImageCount = WZXHeader.ImageCount) and (WZLHeader.ImageCount > 0) then
              begin
                FImageCount := WZLHeader.ImageCount;
                m_ImgArr := AllocMem(SizeOf(TDxImage) * FImageCount);

                pValue := AllocMem(4 * WZLHeader.ImageCount);
                FileRead(fhandle, pValue^, 4 * WZLHeader.ImageCount);
                for i := 0 to WZLHeader.ImageCount - 1 do
                begin
                  nValue := PInteger(Integer(pValue) + 4 * i)^;
                  m_IndexList.Add(Pointer(nValue));
                end;
                FreeMem(pValue);
              end;
              FileClose(fhandle);
            end;
            FImageType := 3;
          end;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      DebugOutStr('TWMImages::Initialize  ' + E.Message);
    end;
  end;
end;

procedure TWMImages.Finalize;
var
  i: Integer;
begin
  for i := 0 to FImageCount - 1 do
  begin
    if m_ImgArr[i].Surface <> nil then
    begin
      m_ImgArr[i].Surface.Free;
      m_ImgArr[i].Surface := nil;
    end;
  end;
  if m_FileStream <> nil then
    FreeAndNil(m_FileStream);
  FreeMem(m_ImgArr);
  m_ImgArr := nil;
end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads; AllowPalette256: Boolean): TPaletteEntries;
var
  Entries: TPaletteEntries;
  DC: THandle;
  i: Integer;
begin
  Result := RGBQuadsToPaletteEntries(RGBQuads);
  if not AllowPalette256 then
  begin
    DC := GetDC(0);
    GetSystemPaletteEntries(DC, 0, 256, Entries);
    ReleaseDC(0, DC);
    for i := 0 to 9 do
      Result[i] := Entries[i];
    for i := 256 - 10 to 255 do
      Result[i] := Entries[i];
  end;
  for i := 0 to 255 do
    Result[i].peFlags := D3DPAL_READONLY;
end;

{procedure TWMImages.LoadPalette();
var
  Entries                   : TPaletteEntries;
begin
  m_FileStream.Seek(SizeOf(TWMImageHeader) - 4, 0);
  //m_FileStream.Read(m_MainPalette, SizeOf(TRGBQuad) * 256);
  m_FileStream.Read(g_MainPalette, SizeOf(TRGBQuad) * 256);
  g_boLoadMainPal := True;

  //m_lsDib.ColorTable := m_MainPalette;
  //m_lsDib.UpdatePalette;
end;}
{
function TWMImages.GetFileSize(const sFile: string; const Offset, DefSize: Integer): Integer;
var
  Sc: TSearchRec;
begin
  if FindFirst(sFile, faAnyFile, Sc) = 0 then
    Result := (Sc.Size - Offset) div DefSize
  else
    Result := 0;
  if Result < 0 then
    Result := 0;
  SysUtils.FindClose(Sc);
end;
 }
 {
procedure TWMImages.LoadIndex(IdxFile: string);
var
  fhandle: THandle;
  i, Value: Integer;
  Header: TWMIndexHeader;
  pValue: PInteger;
begin
  m_IndexList.Clear;
  if FileExists(IdxFile) then
  begin
    fhandle := FileOpen(IdxFile, fmOpenRead or fmShareDenyNone); //
    if fhandle > 0 then
    begin
      FileRead(fhandle, Header, SizeOf(TWMIndexHeader) - 4);

      if (UpperCase(PChar(@Header)[0]) = 'M') and (UpperCase(PChar(@Header)[4]) = 'F') then
      begin
        FileSeek(fhandle, 5, 0);
        FileRead(fhandle, Header, SizeOf(TWMIndexHeader) - 4);
      end;

      GetMem(pValue, 4 * Header.IndexCount);
      FileRead(fhandle, pValue^, 4 * Header.IndexCount);
      for i := 0 to Header.IndexCount - 1 do
      begin
        Value := PInteger(Integer(pValue) + 4 * i)^;
        m_IndexList.Add(Pointer(Value));
      end;
      FreeMem(pValue); //Memory Leak
      FileClose(fhandle);
    end;
  end;
end;
 }
function TWMImages.FGetImageSurface(Index: Integer): TDirectDrawSurface;
begin
  Result := GetCachedSurface(Index);
end;
{
function TWMImages.BlendAnti(idx: Integer): Boolean;
begin
  Result := False;
  Exit;
end;
}
function GetImageBuffLen(pdximg: PTDxImage): Integer;
var
  nWidth: Integer;
begin
  if pdximg.FixSize then
  begin
    if pdximg.bitCount = 5 then
      nWidth := pdximg.nW * 2
    else
    begin
      nWidth := (pdximg.nW * 2 + 3) div 4 * 4;
    end;
  end
  else
  begin
    if pdximg.bitCount = 5 then
      nWidth := pdximg.nW
    else
    begin
      nWidth := (pdximg.nW + 3) div 4 * 4;
    end;
  end;
  Result := nWidth * pdximg.nH;
end;

procedure TWMImages.LoadDxImage_Wzl(Position, nIndex: Integer; pdximg: PTDxImage);
var
  WZLInfo: TWZLInfo;
  SBits, DBits: PLongWord;
  pSrc: PByte;
  i, n, slen, dlen, mlen: Integer;
  Len2: Integer;
  Buf2: Pointer;
  lzip: Boolean;

  ddsd: TDDSurfaceDesc;
begin
  lzip := True;
  Buf2 := nil;
  if (pdximg.nW = 0) and (pdximg.nH = 0) then
  begin
    if (m_FileStream.Seek(Position, soFromBeginning) = Position) and
      (m_FileStream.Read(WZLInfo, SizeOf(TWZLInfo)) = SizeOf(TWZLInfo)) then
    begin

      pdximg.nW := WZLInfo.Width;
      pdximg.nH := WZLInfo.Height;
      pdximg.nPx := WZLInfo.Px;
      pdximg.nPy := WZLInfo.Py;

      pdximg.LoadStep := 0;
      pdximg.bitCount := WZLInfo.ColorFlag;
      pdximg.FixSize := WZLInfo.FixSize;
      pdximg.dwOB := WZLInfo.Size;

      //12345
      if (WZLInfo.Width < 0) or (WZLInfo.Height < 0) then
      begin
        pdximg.nW := 0;
        pdximg.nH := 0;
        Exit;
      end;
      if not (WZLInfo.ColorFlag in [3, 5]) then
      begin
        pdximg.nW := 0;
        pdximg.nH := 0;
        Exit;
      end;

    end
    else
    begin
      pdximg.nW := 0;
      pdximg.nH := 0;
      Exit;
    end;

    if (pdximg.dwOB = 0) and ((pdximg.nW = 0) or (pdximg.nH = 0)) then
    begin
      //DebugOutStr(Format('0  %s: %d   %d/%d  %d/%d ', [Self.FFileName, nIndex, pdximg.nW, pdximg.nH, pdximg.nPx, pdximg.nPy]));
      pdximg.nW := 0;
      pdximg.nH := 0;
      Exit;
    end;
  end
  else
  begin
    if m_FileStream.Seek(Position + SizeOf(TWZLInfo), soFromBeginning) <> Position + SizeOf(TWZLInfo) then
    begin
      pdximg.nW := 0;
      pdximg.nH := 0;
      Exit;
    end;
  end;

  if pdximg.bitCount = 5 then
  begin
    slen := (pdximg.nW * 2 + 3) div 4 * 4;
    dlen := slen div 2;
  end
  else
  begin
    slen := (pdximg.nW + 3) div 4 * 4;
    dlen := slen;
  end;

  mlen := slen * pdximg.nH;

  if (mlen = 0) then
  begin
    //DebugOutStr(Format('1  %s: %d   %d/%d  %d/%d ', [Self.FFileName, nIndex, pdximg.nW, pdximg.nH, pdximg.nPx, pdximg.nPy]));
    pdximg.nW := 0;
    pdximg.nH := 0;
    Exit;
  end;

  if pdximg.dwOB = 0 then
  begin
    pdximg.dwOB := mlen;
    lzip := False;
  end;

  if pdximg.dwOB = 0 then
  begin
    pdximg.nW := 0;
    pdximg.nH := 0;
    Exit;
  end;

  if (pdximg.nW < 0) or (pdximg.nH < 0) then
  begin
    pdximg.nW := 0;
    pdximg.nH := 0;
    Exit;
  end;

  if not (pdximg.bitCount in [3, 5]) then
  begin
    pdximg.nW := 0;
    pdximg.nH := 0;
    Exit;
  end;

  if pdximg.dwOB > 1024 * 1024 * 2 then
  begin
    pdximg.nW := 0;
    pdximg.nH := 0;
    Exit;
  end;

  pdximg.Surface := TDirectDrawSurface.Create(FDDraw);
  if Assigned(pdximg.Surface) then
  begin
    pdximg.Surface.SetSize(dlen, pdximg.nH);
    pdximg.Surface.Lock(ddsd);
    DBits := ddsd.lpSurface;
    try
      if DBits <> nil then
      begin
        GetMem(SBits, pdximg.dwOB {mlen});
        try
          if m_FileStream.Read(SBits^, pdximg.dwOB {mlen}) = pdximg.dwOB {mlen} then
          begin
            if not lzip then
            begin
              Buf2 := SBits;
              if pdximg.bitCount = 5 then
              begin
                for n := pdximg.nH - 1 downto 0 do
                begin
                  pSrc := PByte(Integer(Buf2) + n * slen);
                  Move(pSrc^, DBits^, pdximg.nW * 2);
                  Inc(Integer(DBits), ddsd.lPitch);

                  {for i := 0 to pdximg.nW - 1 do begin
                    //if i >= pdximg.nW then
                    //  PWord(DBits)^ := 00 //g_pTab_16To16^[00]
                    //else
                    PWord(DBits)^ := PWord(pSrc)^; //g_pTab_16To16^[PWord(pSrc)^];
                    Inc(PWord(DBits));
                    Inc(PWord(pSrc));
                  end;
                  Inc(Integer(DBits), ddsd.lPitch - pdximg.nW * 2);}
                end;
              end
              else
              begin
                for n := pdximg.nH - 1 downto 0 do
                begin
                  pSrc := Pointer(Integer(Buf2) + n * slen);
                  for i := 0 to dlen - 1 do
                  begin
                    if i >= pdximg.nW then
                      PWord(DBits)^ := pal_8to16[00]
                    else
                      PWord(DBits)^ := pal_8to16[PByte(pSrc)^];
                    Inc(PWord(DBits));
                    Inc(PByte(pSrc));
                  end;
                  //Inc(Integer(DBits), ddsd.lPitch - pdximg.nW * 2);
                end;
              end;
            end
            else
            begin
              g_UnZip.ZLibDecompressBuffer(SBits, pdximg.dwOB, Buf2, Len2, 0, False);
              //zlib125.DecompressBuf(SBits, pdximg.dwOB, 0, Buf2, Len2);
              try
                // if (Len2 = mlen) and (Buf2 <> nil) then
                // 修复盛大hair5.wzl 4800 素材无法读取   2019-12-12
                if (Len2 >= mlen) and (Buf2 <> nil) then
                begin
                  if pdximg.bitCount = 5 then
                  begin
                    for n := pdximg.nH - 1 downto 0 do
                    begin
                      pSrc := PByte(Integer(Buf2) + n * slen);
                      Move(pSrc^, DBits^, pdximg.nW * 2);
                      Inc(Integer(DBits), ddsd.lPitch);

                      {for i := 0 to pdximg.nW - 1 do begin
                        //if i >= pdximg.nW then
                        //  PWord(DBits)^ := 00 //g_pTab_16To16^[00]
                        //else
                        PWord(DBits)^ := PWord(pSrc)^; //g_pTab_16To16^[PWord(pSrc)^];
                        Inc(PWord(DBits));
                        Inc(PWord(pSrc));
                      end;
                      Inc(Integer(DBits), ddsd.lPitch - pdximg.nW * 2);}
                    end;
                  end
                  else
                  begin
                    for n := pdximg.nH - 1 downto 0 do
                    begin
                      pSrc := Pointer(Integer(Buf2) + n * slen);
                      for i := 0 to dlen - 1 do
                      begin
                        if i >= pdximg.nW then
                          PWord(DBits)^ := pal_8to16[00]
                        else
                          PWord(DBits)^ := pal_8to16[PByte(pSrc)^];
                        Inc(PWord(DBits));
                        Inc(PByte(pSrc));
                      end;
                      //Inc(Integer(DBits), ddsd.lPitch - pdximg.nW * 2);
                    end;
                  end;
                end;
              finally
                if Buf2 <> nil then
                  FreeMem(Buf2);
              end;
            end;
          end;
        finally
          FreeMem(SBits);
        end;
      end;
    finally
      pdximg.Surface.UnLock();
    end;
  end;

end;

procedure TWMImages.LoadDxImage(Position: Integer; pdximg: PTDxImage; bAnti: Boolean);
var
  imgInfo: TWMImageInfo;
  ddsd: TDDSurfaceDesc;
  SBits, pSrc, DBits: PByte;
  i, n, slen, dlen, mlen: Integer;
label
  labNotDIB;
const
  m_int64: Int64 = $000000000000FFFF;
begin
  if (pdximg.nW = 0) and (pdximg.nH = 0) then
  begin
    if (m_FileStream.Seek(Position, soFromBeginning) = Position) and
      (m_FileStream.Read(imgInfo, SizeOf(TWMImageInfo) - 4) = SizeOf(TWMImageInfo) - 4) then
    begin
      pdximg.nW := imgInfo.nWidth;
      pdximg.nH := imgInfo.nHeight;
      pdximg.nPx := imgInfo.Px;
      pdximg.nPy := imgInfo.Py;
    end
    else
    begin
      Exit;
    end;
  end
  else
  begin
    if m_FileStream.Seek(Position + SizeOf(TWMImageInfo) - 4, soFromBeginning) <> Position + SizeOf(TWMImageInfo) - 4 then
      Exit;
  end;

  if F16BIT then
  begin
    slen := ((pdximg.nW * 2 + 3) div 4) * 4;
    dlen := slen div 2;
  end
  else
  begin
    slen := ((pdximg.nW + 3) div 4) * 4;
    dlen := slen;
  end;
  mlen := slen * pdximg.nH;

  if mlen = 0 then
  begin
    Exit;
  end;

  GetMem(pSrc, mlen);
  m_FileStream.Read(pSrc^, mlen);
  try
    pdximg.Surface := TDirectDrawSurface.Create(FDDraw);
    if bAnti then
      pdximg.Surface.FAnti := True;
    pdximg.Surface.SetSize(dlen {slen}, pdximg.nH);
    pdximg.Surface.Lock(ddsd);
    try
      DBits := ddsd.lpSurface;
      if F16BIT then
      begin
{$IF MIR2EX}
        for n := pdximg.nH - 1 downto 0 do
        begin
          SBits := PByte(Integer(pSrc) + slen * n);
          Move(SBits^, DBits^, slen);
          Inc(Integer(DBits), ddsd.lPitch);
        end;
{$ELSE}
        for n := pdximg.nH - 1 downto 0 do
        begin //16bit -> 8bit
          SBits := PByte(Integer(pSrc) + slen * n);
          for i := 0 to pdximg.nW - 1 do
          begin
            PByte(DBits)^ := g_pC16BitPalette^[PWord(SBits)^];
            Inc(PByte(DBits));
            Inc(PWord(SBits));
          end;
          Inc(Integer(DBits), ddsd.lPitch - pdximg.nW);
        end;
{$IFEND MIR2EX}
      end
      else
      begin
{$IF MIR2EX}
        if bAnti then
        begin
          for n := pdximg.nH - 1 downto 0 do
          begin
            SBits := PByte(Integer(pSrc) + slen * n);
            Move(SBits^, DBits^, slen);
            Inc(Integer(DBits), ddsd.lPitch);
          end;
        end
        else
        begin
          //asm Version

          {pPalette := @g_MainPalette;
          for n := pdximg.nH - 1 downto 0 do begin //8 -> 16
            SBits := PByte(Integer(pSrc) + slen * n);
            DBits := PByte(Integer(ddsd.lpSurface) + ((pdximg.nH - 1) - n) * ddsd.lPitch);
            asm
              pushad
              mov esi, SBits
              mov edi, DBits
              mov edx, pPalette
              mov ebx, slen
              pxor  mm7, mm7

@Loopcp:
              cmp ebx, 00000000
              jle @end

              movzx eax, byte ptr [esi]
              movd  mm0, dword ptr [edx+4*eax]
              movzx eax, byte ptr [esi + 1]
              movd  mm1, dword ptr [edx+4*eax]

              punpckldq  mm0, mm1
              movq  mm2, mm0

              pand  mm2, qword ptr Int64_r
              psrld mm2, $10
              movq  mm3, mm0
              pand  mm3, qword ptr Int64_g
              psrld mm3, $08
              movq  mm4, mm0
              pand  mm4, qword ptr Int64_b

              pslld mm2, $08
              pand  mm2, qword ptr Mask64_r
              pslld mm3, $03
              pand  mm3, qword ptr Mask64_g
              psrld mm4, $03
              pand  mm4, qword ptr Mask64_b
              por  mm2, mm3
              por  mm2, mm4
              movq  mm3, mm2
              punpckhbw  mm3, mm7
              packuswb  mm3, mm7
              pslld mm3, $10
              por  mm2, mm3

              movd  dword ptr [edi], mm2

              sub ebx, $00000002
              add esi, $00000002
              add edi, $00000004
              jmp @Loopcp
            @end:
              popad
            end;
          end;
          asm
            emms
          end;}

          for n := pdximg.nH - 1 downto 0 do
          begin //8 -> 16
            SBits := PByte(Integer(pSrc) + slen * n);
            for i := 0 to pdximg.nW - 1 do
            begin
              PWord(DBits)^ := pal_8to16[PByte(SBits)^];
              Inc(PWord(DBits));
              Inc(PByte(SBits));
            end;
            Inc(Integer(DBits), ddsd.lPitch - pdximg.nW * 2);
          end;

          //SSE
          {ptable := @pal_8to16;
          i4 := pdximg.nW div 8;
          ir := pdximg.nW mod 8;

          for n := pdximg.nH - 1 downto 0 do begin //8 -> 16
            SBits := PByte(Integer(pSrc) + slen * n);
            DBits := PByte(Integer(ddsd.lpSurface) + ((pdximg.nH - 1) - n) * ddsd.lPitch);
            asm
                pushad
                mov   esi,  SBits
                mov   edi,  DBits
                mov   ecx,  ptable
                mov   edx,  i4
                cmp   edx,  00
                jle   @cp2

              @loop8:
                movzx ebx,  byte [esi + 1]
                movzx eax,  word [ecx + 2 * ebx]
                shl   eax,  $10
                movzx ebx,  byte [esi]
                or    ax,   word [ecx + 2 * ebx]
                movd  xmm0,  eax                      //xmm0  0000 0000 0000 0000 0000 0000 0022 0011

                movzx ebx,  byte [esi + 3]
                movzx eax,  word [ecx + 2 * ebx]
                shl   eax,  $10
                movzx ebx,  byte [esi + 2]
                or    ax,   word [ecx + 2 * ebx]
                movd  xmm1,  eax

                punpckldq  xmm0, xmm1                 //xmm0  0000 0000 0000 0000 0044 0033 0022 0011

                ////
                movzx ebx,  byte [esi + 1 + 4]
                movzx eax,  word [ecx + 2 * ebx]
                shl   eax,  $10
                movzx ebx,  byte [esi + 4]
                or    ax,   word [ecx + 2 * ebx]
                movd  xmm2,  eax

                movzx ebx,  byte [esi + 3 + 4]
                movzx eax,  word [ecx + 2 * ebx]
                shl   eax,  $10
                movzx ebx,  byte [esi + 2 + 4]
                or    ax,   word [ecx + 2 * ebx]
                movd  xmm3,  eax

                punpckldq  xmm2, xmm3
                pslldq     xmm2, $08

                por        xmm0, xmm2

                movdqu oword [edi], xmm0
                add   edi,  $10
                add   esi,  $08
                dec   edx
                jne   @loop8

              @cp2:
                mov   edx,  ir
                cmp   edx,  00
                jle   @end

              @loop2:
                movzx ebx,  byte [esi]
                mov ax,  word [ecx + 2 * ebx]
                mov   word [edi], ax
                add   edi,  $02
                inc   esi
                dec   edx
                jne   @loop2
              @end:
                popad
            end;
          end;
          asm
            emms;
          end;}

          //MMX
          {ptable := @pal_8to16;
          i4 := pdximg.nW div 4;
          ir := pdximg.nW mod 4;

          for n := pdximg.nH - 1 downto 0 do begin //8 -> 16
            SBits := PByte(Integer(pSrc) + slen * n);
            DBits := PByte(Integer(ddsd.lpSurface) + ((pdximg.nH - 1) - n) * ddsd.lPitch);
            asm
                pushad
                mov   esi,  SBits
                mov   edi,  DBits
                mov   ecx,  ptable
                mov   edx,  i4
                cmp   edx,  00
                jle   @cp2

              @loop8:
                movzx ebx,  byte [esi + 1]
                movzx eax,  word [ecx + 2 * ebx]
                shl   eax,  $10
                movzx ebx,  byte [esi]
                or    ax,   word [ecx + 2 * ebx]
                movd  mm0,  eax

                movzx ebx,  byte [esi + 3]
                movzx eax,  word [ecx + 2 * ebx]
                shl   eax,  $10
                movzx ebx,  byte [esi + 2]
                or    ax,   word [ecx + 2 * ebx]
                movd  mm1,  eax

                psllq mm1,  $20
                por   mm1,  mm0
                movq  qword [edi], mm1
                //punpckldq  mm0, mm1
                //movq  qword [edi], mm0
                add   edi,  $08
                add   esi,  $04
                dec   edx
                jne   @loop8

              @cp2:
                mov   edx,  ir
                cmp   edx,  00
                jle   @end

              @loop2:
                movzx ebx,  byte [esi]
                mov ax,  word [ecx + 2 * ebx]
                mov   word [edi], ax
                add   edi,  $02
                inc   esi
                dec   edx
                jne   @loop2
              @end:
                emms
                popad
            end;
          end;}

        end;
{$ELSE}
        for n := pdximg.nH - 1 downto 0 do
        begin
          SBits := PByte(Integer(pSrc) + slen * n);
          Move(SBits^, DBits^, slen);
          Inc(Integer(DBits), ddsd.lPitch);
        end;
{$IFEND MIR2EX}
      end;
    finally
      pdximg.Surface.UnLock();
    end;
  finally
    FreeMem(pSrc);
  end;
  //end;
end;

function TWMImages.LoadDxImage_Header(Position: Integer; var pt: TPoint): Boolean;
var
  imgInfo: TWMImageInfo;
begin
  m_FileStream.Seek(Position, soFromBeginning);
  m_FileStream.Read(imgInfo, SizeOf(TWMImageInfo) - 4);
  pt.X := imgInfo.nWidth;
  pt.Y := imgInfo.nHeight;
  Result := True;
end;

function TWMImages.LoadDxImage_Wis_Header(Position: Integer; var pt: TPoint): Boolean;
var
  pbuf: PChar;
  pimg: PTImgInfo;
  hLen: Integer;
begin
  Result := False;
  pbuf := nil;
  if m_Wis.LoadImageData(Position, pbuf, hLen) then
  begin
    try
      if hLen < 12 then
      begin
        if pbuf <> nil then
        begin
          FreeMem(pbuf);
          pbuf := nil;
        end;
        Exit;
      end;
      pimg := PTImgInfo(pbuf);
      if (pimg.bPack in [0..3]) and (pimg.bEncrypt in [0..1]) then
      begin
        pt.X := pimg.wW;
        pt.Y := pimg.wh;
        Result := True;
      end;
    finally
      if pbuf <> nil then
      begin
        FreeMem(pbuf);
        pbuf := nil;
      end;
    end;
  end;
end;

procedure TWMImages.LoadDxImage_Wis(Position: Integer; pdximg: PTDxImage; bAnti: Boolean);
var
  pbuf: PChar;
  ddsd: TDDSurfaceDesc;
  SBits, pSrc, DBits: PByte;
  i, n, hLen, mlen: Integer;
  pimg: PTImgInfo;
begin
  pbuf := nil;

  if not m_Wis.LoadImageData(Position, pbuf, hLen) then
    Exit;

  try
    if hLen < 12 then
    begin
      if pbuf <> nil then
      begin
        FreeMem(pbuf);
        pbuf := nil;
      end;
      Exit;
    end;

    pimg := PTImgInfo(pbuf);
    if (pimg.bPack in [0..3]) and (pimg.bEncrypt in [0..1]) then
    begin

      SBits := PByte(pbuf);
      pdximg.nW := pimg.wW;
      pdximg.nH := pimg.wh;
      pdximg.nPx := pimg.wPx;
      pdximg.nPy := pimg.wPy;

      Inc(SBits, SizeOf(TImgInfo)); //data offset
      if pimg.bEncrypt = 1 then
      begin //encrypt
        TrainBuffer(PChar(SBits), hLen - SizeOf(TImgInfo));
      end;

      pSrc := nil;
      try
        case pimg.bPack of
          1:
            begin //packed 1
              mlen := pimg.wW * pimg.wh;
              GetMem(pSrc, mlen);
              WisUppackData(SBits, hLen - SizeOf(TImgInfo), pSrc, mlen);
              SBits := pSrc;
            end;
          2:
            begin
              //pSrc := SBits;
            end;
          3:
            begin //packed 3 ???
              if WisUppackData2(SBits, hLen - SizeOf(TImgInfo), pSrc, mlen) then
              begin
                SBits := pSrc;
              end;
            end;
        end;

        pdximg.Surface := TDirectDrawSurface.Create(FDDraw);
        if bAnti then
          pdximg.Surface.FAnti := True;
        pdximg.Surface.SetSize(pdximg.nW, pdximg.nH);
        if pdximg.Surface.Lock(ddsd) then
        try
          DBits := ddsd.lpSurface;
{$IF MIR2EX}
          if bAnti then
          begin
            for n := 0 to pdximg.nH - 1 do
            begin
              for i := 0 to pdximg.nW - 1 do
              begin
                PByte(DBits)^ := PByte(SBits)^;
                Inc(PByte(DBits));
                Inc(PByte(SBits));
              end;
              Inc(Integer(DBits), ddsd.lPitch - pdximg.nW);
            end;
          end
          else
          begin
            if F16BIT then
            begin
              //messagebox(0, PChar(FFileName), nil, 0);
              for n := pdximg.nH - 1 downto 0 do
              begin
                Move(SBits^, DBits^, pdximg.nW * 2);
                Inc(Integer(DBits), ddsd.lPitch);
                Inc(Integer(SBits), pdximg.nW * 2);
              end;
            end
            else
            begin
              for n := 0 to pdximg.nH - 1 do
              begin
                for i := 0 to pdximg.nW - 1 do
                begin
                  PWord(DBits)^ := pal_8to16[PByte(SBits)^];
                  Inc(PWord(DBits));
                  Inc(PByte(SBits));
                end;
                Inc(Integer(DBits), ddsd.lPitch - pdximg.nW * SizeOf(Word));
              end;
            end;
          end;
{$ELSE}
          {for n := 0 to pdximg.nH - 1 do begin
            SBits := PByte(Integer(pSrc) + slen * n);
            Move(SBits^, DBits^, slen);
            Inc(Integer(DBits), ddsd.lPitch);
          end;}
          for n := 0 to pdximg.nH - 1 do
          begin
            for i := 0 to pdximg.nW - 1 do
            begin
              PByte(DBits)^ := PByte(SBits)^;
              Inc(PByte(DBits));
              Inc(PByte(SBits));
            end;
            Inc(Integer(DBits), ddsd.lPitch - pdximg.nW);
          end;
{$IFEND MIR2EX}

        finally
          pdximg.Surface.UnLock();
        end;
      finally
        if pSrc <> nil then
        begin
          FreeMem(pSrc);
          pSrc := nil;
        end;
      end;
    end;
  finally
    if pbuf <> nil then
    begin
      FreeMem(pbuf);
      pbuf := nil;
    end;
  end;
end;

procedure TWMImages.ClearCache;
var
  i: Integer;
begin
  for i := 0 to ImageCount - 1 do
  begin
    m_ImgArr[i].nH := 0;
    m_ImgArr[i].nW := 0;
    if m_ImgArr[i].Surface <> nil then
    begin
      m_ImgArr[i].Surface.Free;
      m_ImgArr[i].Surface := nil;
    end;
  end;
end;

function TWMImages.GetCachedDxImage(Index: Integer): PTDxImage;
begin
  Result := nil;
  try
    //123456
    if (ImageCount = 0) and not m_fQueryIndex then
    begin
      m_fQueryIndex := True;
      if FImageType = 3 then
        g_PatchClientManager.SendProcMsg(Self, Self.FFileName, PM_INDEX, 0);
      Exit;
    end;
    if not m_fQueryImgCnt and (ImageCount > 0) and (Index >= ImageCount) then
    begin
      m_fQueryImgCnt := True;
      if FImageType = 3 then
        g_PatchClientManager.SendProcMsg(Self, Self.FFileName, PM_INDEX, 0);
      Exit;
    end;

    if (Index >= 0) and (Index < ImageCount) then
    begin
      Result := @m_ImgArr[Index];
      Result.dwLatestTime := GetTickCount;
      if Result.Surface = nil then
      begin
        case FImageType of
          1: if Assigned(m_Wis) then
            begin
              LoadDxImage_Wis(Index, Result, False);
            end;
          2: if (Index < m_IndexList.count) and (Integer(m_IndexList[Index]) > 0) then
            begin
              LoadDxImage(Integer(m_IndexList[Index]), Result, False);
            end;
          3:
            begin
              if (Index < m_IndexList.count) and (Integer(m_IndexList[Index]) > 0) then
              begin
                LoadDxImage_Wzl(Integer(m_IndexList[Index]), Index, Result);
              end;
              //123456
              if (Result.LoadStep = 0) then
              begin
                if not Assigned(Result.Surface) then
                begin
                  Result.LoadStep := 1; //Send Image Quest...
                  g_PatchClientManager.SendProcMsg(Self, Self.FFileName, PM_DATA, Index);
                end
                else
                begin
                  Result.LoadStep := 3; //Got Local Image ...
                end;
              end
              else if Result.LoadStep = 1 then
              begin
                if Assigned(Result.Surface) then
                begin
                  Result.LoadStep := 2; //Got Remote Image ...
                end;
              end
              else
              begin
                Result.LoadStep := 3;
              end;
            end;
        end;

        if Result.Surface <> nil then
        begin
          Inc(g_ImageManager.m_ImagesMemory, Result.Surface.Width * Result.Surface.Height);
          g_ImageManager.m_ImagesList.Add(Result);
        end;
      end;
    end;
  except
    //Result := nil;
  end;
end;

{function TWMImages.GetImageSize(Index: Integer): Boolean;
var
  pt                        : TPoint;
begin
  Result := False;
  if (Index >= 0) and (Index < ImageCount) then begin
    if m_Wis <> nil then begin
      Result := LoadDxImage_Wis_Header(Index, pt);
    end else if Index < m_IndexList.count then begin
      Result := LoadDxImage_Header(Integer(m_IndexList[Index]), pt);
    end;
  end;
end;}

function TWMImages.GetImageSize(Index: Integer; var pt: TPoint): Boolean;
begin
  Result := False;
  if (Index >= 0) and (Index < ImageCount) then
  begin
    if m_Wis <> nil then
    begin
      Result := LoadDxImage_Wis_Header(Index, pt);
    end
    else if Index < m_IndexList.count then
    begin
      Result := LoadDxImage_Header(Integer(m_IndexList[Index]), pt);
    end;
  end;
end;

function TWMImages.GetCachedSurface(Index: Integer): TDirectDrawSurface;
var
  i, ii: Integer;
  PDxImage: PTDxImage;
begin
  PDxImage := GetCachedDxImage(Index);
  if PDxImage <> nil then
  begin
    Result := PDxImage.Surface;
    //123456
    if (g_dwReGetMapTitleTick = 0) then
    begin //and ((g_WTilesImages = Self) or (g_WTiles2Images = Self) or (g_WSmTilesImages = Self) or (g_WSmTiles2Images = Self))
      ii := -1;
      for i := Low(g_WTilesArr) to High(g_WTilesArr) do
      begin
        if Self = g_WTilesArr[i] then
        begin
          ii := 1;
          Break;
        end;
      end;
      if ii = -1 then
      begin
        for i := Low(g_WSmTilesArr) to High(g_WSmTilesArr) do
        begin
          if Self = g_WSmTilesArr[i] then
          begin
            ii := 1;
            Break;
          end;
        end;
      end;
      if ii = 1 then
      begin
        case PDxImage.LoadStep of
          1: if (Result = nil) then
              g_dwReGetMapTitleTick := GetTickCount;
          2: if (Result <> nil) then
              g_dwReGetMapTitleTick := GetTickCount + 500;
          3: ;
        end;
      end;
    end;
  end
  else
    Result := nil;
end;

function TWMImages.GetCachedImage(Index: Integer; var Px, Py: Integer): TDirectDrawSurface;
var
  i, ii: Integer;
  PDxImage: PTDxImage;
begin
  PDxImage := GetCachedDxImage(Index);
  if PDxImage <> nil then
  begin
    Result := PDxImage.Surface;
    Px := PDxImage.nPx;
    Py := PDxImage.nPy;
    //123456
    if (g_dwReGetMapTitleTick = 0) then
    begin //and ((g_WTilesImages = Self) or (g_WTiles2Images = Self) or (g_WSmTilesImages = Self) or (g_WSmTiles2Images = Self))
      ii := -1;
      for i := Low(g_WTilesArr) to High(g_WTilesArr) do
      begin
        if Self = g_WTilesArr[i] then
        begin
          ii := 1;
          Break;
        end;
      end;
      if ii = -1 then
      begin
        for i := Low(g_WSmTilesArr) to High(g_WSmTilesArr) do
        begin
          if Self = g_WSmTilesArr[i] then
          begin
            ii := 1;
            Break;
          end;
        end;
      end;
      if ii = 1 then
      begin
        case PDxImage.LoadStep of
          1: if (Result = nil) then
              g_dwReGetMapTitleTick := GetTickCount;
          2: if (Result <> nil) then
              g_dwReGetMapTitleTick := GetTickCount + 1200;
          3: ;
        end;
      end;
    end;
  end
  else
    Result := nil;
end;

constructor TUIBImages.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FSearchPath := '';
  FSearchFileExt := '*.uib';
  FFileName := '';
  FSearchSubDir := False;
  m_FileList := THStringList.Create;
end;

destructor TUIBImages.Destroy;
var
  i: Integer;
begin
  for i := 0 to m_FileList.count - 1 do
    FileClose(THandle(m_FileList.Objects[i]));
  m_FileList.Free;
  inherited Destroy;
end;

procedure TUIBImages.AddUibFileList(sFile: string);
begin
  {fhandle := FileOpen(sFile, fmOpenRead or fmShareDenyNone);
  if fhandle <> INVALID_HANDLE_VALUE then begin
    FFileList.AddObject(sFile, TObject(fhandle));
  end;}
end;

procedure TUIBImages.GetUibFileList(Path, ext: string);
var
  fhandle: THandle;
  SearchRec: TSearchRec;
  sPath: string;
  PDxImage: PTDxImage;
begin

  if Copy(Path, Length(Path), 1) <> '\' then
    sPath := Path + '\'
  else
    sPath := Path;

  if FindFirst(sPath + ext, faAnyFile, SearchRec) = 0 then
  begin
    fhandle := FileOpen(sPath + SearchRec.Name, fmOpenRead or fmShareDenyNone);
    New(PDxImage);
    FillChar(PDxImage^, SizeOf(TDxImage), 0);
    PDxImage.nHandle := fhandle;
    m_FileList.AddObject(sPath + SearchRec.Name, TObject(PDxImage));
    while True do
    begin
      if FindNext(SearchRec) = 0 then
      begin
        fhandle := FileOpen(sPath + SearchRec.Name, fmOpenRead or fmShareDenyNone);
        New(PDxImage);
        FillChar(PDxImage^, SizeOf(TDxImage), 0);
        PDxImage.nHandle := fhandle;
        m_FileList.AddObject(sPath + SearchRec.Name, TObject(PDxImage));
      end
      else
      begin
        SysUtils.FindClose(SearchRec);
        Break;
      end;
    end;
  end;
end;

procedure TUIBImages.RecurSearchFile(Path, FileType: string);
var
  sr: TSearchRec;
  fhandle: THandle;
  sPath, sFile: string;
  PDxImage: PTDxImage;
begin

  if Copy(Path, Length(Path), 1) <> '\' then
    sPath := Path + '\'
  else
    sPath := Path;

  if FindFirst(sPath + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      sFile := Trim(sr.Name);
      if sFile = '.' then
        Continue;
      if sFile = '..' then
        Continue;
      sFile := sPath + sr.Name;
      if (sr.Attr and faDirectory) <> 0 then
      begin
        GetUibFileList(sFile, FileType);
      end
      else if (sr.Attr and faAnyFile) = sr.Attr then
      begin
        fhandle := FileOpen(sFile, fmOpenRead or fmShareDenyNone);
        New(PDxImage);
        FillChar(PDxImage^, SizeOf(TDxImage), 0);
        PDxImage.nHandle := fhandle;
        m_FileList.AddObject(sFile, TObject(PDxImage));
      end;
    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;
end;

procedure TUIBImages.Initialize;
begin
  if not (csDesigning in ComponentState) then
  begin
    if (LibType <> ltLoadBmp) and (FDDraw = nil) then
    begin
      raise Exception.Create('DDraw not assigned...');
      Exit;
    end;
    if DirectoryExists(FSearchPath) then
    begin
      if SearchSubDir then
        RecurSearchFile(FSearchPath, FSearchFileExt)
      else
        GetUibFileList(FSearchPath, FSearchFileExt);
      FImageCount := m_FileList.count;
    end
    else
    begin
      ForceDirectories(FSearchPath);
    end;
  end;
end;

procedure TUIBImages.ClearCache;
var
  i: Integer;
  pdi: PTDxImage;
begin
  for i := 0 to m_FileList.count - 1 do
  begin
    pdi := PTDxImage(m_FileList.Objects[i]);
    pdi.nH := 0;
    pdi.nW := 0;
    if Assigned(pdi.Surface) then
      FreeAndNil(pdi.Surface);
  end;
end;

procedure TUIBImages.Finalize;
var
  i: Integer;
  pdi: PTDxImage;
begin
  ClearCache();
  for i := 0 to m_FileList.count - 1 do
  begin
    pdi := PTDxImage(m_FileList.Objects[i]);
    Dispose(pdi);
  end;
  m_FileList.Clear;
  FImageCount := 0;
end;

procedure TUIBImages.UiLoadDxImage(pdximg: PTDxImage; fhandle: THandle {sFileName: string});
var
  imgInfo: TWMImageInfo;
  ddsd: TDDSurfaceDesc;
  SBits, pSrc, DBits: PByte;
  i, n, mlen, slen, dlen: Integer;
  bmpHead: TBitmapFileHeader;
  bmpInfo: TBitmapInfoHeader;
begin
  if (pdximg.nW = 0) and (pdximg.nH = 0) then
  begin
    FileSeek(fhandle, 0, 0);
    FileRead(fhandle, bmpHead, SizeOf(TBitmapFileHeader));
    //bmpHead.bfOffBits
    FileRead(fhandle, bmpInfo, SizeOf(TBitmapInfoHeader));
    //bmpInfo.biBitCount
    imgInfo.nWidth := bmpInfo.biWidth;
    imgInfo.nHeight := bmpInfo.biHeight;
    imgInfo.Px := 0;
    imgInfo.Py := 0;
    pdximg.nW := bmpInfo.biWidth;
    pdximg.nH := bmpInfo.biHeight;
    pdximg.nPx := 0;
    pdximg.nPy := 0;
    pdximg.bitCount := bmpInfo.biBitCount;
    pdximg.dwOB := bmpHead.bfOffBits;
  end;

  if pdximg.bitCount = 8 then
  begin
    slen := ((pdximg.nW + 3) div 4) * 4;
    mlen := slen * pdximg.nH;
    GetMem(pSrc, mlen);
    try
      FileSeek(fhandle, pdximg.dwOB, 0);
      FileRead(fhandle, pSrc^, mlen);

      pdximg.Surface := TDirectDrawSurface.Create(FDDraw);
      pdximg.Surface.SetSize(slen, pdximg.nH);
      pdximg.Surface.Lock(ddsd);
      try
        DBits := ddsd.lpSurface;
{$IF MIR2EX}
        for n := pdximg.nH - 1 downto 0 do
        begin //8 -> 16
          SBits := PByte(Integer(pSrc) + slen * n);
          for i := 0 to pdximg.nW - 1 do
          begin
            PWord(DBits)^ := pal_8to16[PByte(SBits)^];
            Inc(PWord(DBits));
            Inc(PByte(SBits));
          end;
          Inc(Integer(DBits), ddsd.lPitch - pdximg.nW * 2);
        end;
{$ELSE}
        for n := pdximg.nH - 1 downto 0 do
        begin
          SBits := PByte(Integer(pSrc) + slen * n);
          Move(SBits^, DBits^, slen);
          Inc(Integer(DBits), ddsd.lPitch);
        end;
{$IFEND MIR2EX}
      finally
        pdximg.Surface.UnLock();
      end;
    finally
      FreeMem(pSrc);
    end;
  end
  else
  begin
    //pdximg.Surface.LoadFromFile('D:\Program Files\Legend of mir\Data\ui');

    slen := ((pdximg.nW * 2 + 3) div 4) * 4;
    dlen := slen div 2;
    mlen := slen * pdximg.nH;
    GetMem(pSrc, mlen);

    try
      FileSeek(fhandle, pdximg.dwOB, 0);
      FileRead(fhandle, pSrc^, mlen);
      pdximg.Surface := TDirectDrawSurface.Create(FDDraw);
      pdximg.Surface.SetSize(dlen, pdximg.nH);
      pdximg.Surface.Lock(ddsd);
      try
        DBits := ddsd.lpSurface;
{$IF MIR2EX}
        for n := pdximg.nH - 1 downto 0 do
        begin
          SBits := PByte(Integer(pSrc) + slen * n);
          Move(SBits^, DBits^, slen);
          Inc(Integer(DBits), ddsd.lPitch);
        end;
{$ELSE}
        for n := pdximg.nH - 1 downto 0 do
        begin
          SBits := PByte(Integer(pSrc) + slen * n);
          Move(SBits^, DBits^, slen);
          Inc(Integer(DBits), ddsd.lPitch);
        end;
{$IFEND MIR2EX}
      finally
        pdximg.Surface.UnLock();
      end;
    finally
      FreeMem(pSrc);
    end;
  end;
end;

function TUIBImages.UiGetCachedSurface(F: string): PTDxImage;
var
  Index: Integer;
  fhandle: THandle;
  PDxImage: PTDxImage;
begin
  Result := nil;
  try
    Index := m_FileList.IndexOf(F);
    if Index >= 0 then
    begin
      Result := PTDxImage(m_FileList.Objects[Index]);
      if Result.nHandle <> INVALID_HANDLE_VALUE then
      begin
        Result.dwLatestTime := GetTickCount;
        if not Assigned(Result.Surface) then
        begin
          UiLoadDxImage(Result, Result.nHandle {, F});
          if Assigned(Result.Surface) then
          begin
            Result.LoadStep := 3;
            g_ImageManager.m_ImagesMemory := g_ImageManager.m_ImagesMemory + Result.Surface.Width * Result.Surface.Height;
            g_ImageManager.m_ImagesList.Add(Result);
          end
          else
          begin
            Result.nW := 0; //123456
            Result.nH := 0;
          end;
        end;
      end
      else
      begin
        if Result.LoadStep = 0 then
        begin
          if not Assigned(Result.Surface) then
          begin
            Result.LoadStep := 1;
            g_PatchClientManager.SendProcMsg(Self, F, PM_DATA, -1);
            Exit;
          end;
        end;
        if (Result.LoadStep > 0) and FileExists(F) then
        begin
          fhandle := FileOpen(F, fmOpenRead or fmShareDenyNone);
          if fhandle <> INVALID_HANDLE_VALUE then
          begin
            PTDxImage(m_FileList.Objects[Index]).nHandle := fhandle;
          end;
        end;
      end;
    end
    else
    begin
      New(PDxImage);
      FillChar(PDxImage^, SizeOf(TDxImage), 0);
      PDxImage.nHandle := INVALID_HANDLE_VALUE;
      FImageCount := m_FileList.AddObject(F, TObject(PDxImage));
    end;
  except
    Result := nil;
  end;
end;

function TUIBImages.FUiGetImageSurface(F: string): TDirectDrawSurface;
var
  PDxImage: PTDxImage;
begin
  PDxImage := UiGetCachedSurface(F);
  if (PDxImage <> nil) and (PDxImage.Surface <> nil) then
    Result := PDxImage.Surface
  else
    Result := nil;
end;

initialization
  Move(g_PalData, g_MainPalette, SizeOf(TRGBQuad) * 256);
  g_ImageManager := TImageManager.Create;
  g_UnZip := TVCLUnZip.Create(nil);
  Move(g_WZLHeaderData, g_WZLHeader, SizeOf(g_WZLHeader));

finalization
  g_ImageManager.Free;
  g_UnZip.Free;

end.
