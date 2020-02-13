unit WIL;

interface

uses
  Windows, Classes, Graphics, SysUtils, DXDraws, DXClass, Dialogs,
  DirectX, DIB, wmUtil;

var
  g_boUseDIBSurface         : Boolean = False;
  g_boWilNoCache            : Boolean = False;

type
  TLibType = (ltLoadBmp, ltLoadMemory, ltLoadMunual, ltUseCache);

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

  TWMImages = class(TComponent)
  private
    FFileName: string;
    FImageCount: Integer;
    FLibType: TLibType;
    FDxDraw: TDXDraw;
    FDDraw: TDirectDraw;
    FMaxMemorySize: Integer;
    btVersion: byte;
    procedure LoadAllData;
    procedure LoadIndex(IdxFile: string);
    procedure LoadDxImage(position: Integer; pdximg: PTDxImage; const F: string = '');
    procedure LoadBmpImage(position: Integer; pbmpimg: pTBmpImage);
    procedure FreeOldMemorys;
    function FGetImageSurface(Index: Integer): TDirectDrawSurface;
    function FGetImageNameSurface(Index: Integer; const F: string = ''): TDirectDrawSurface;
    procedure FSetDxDraw(fdd: TDXDraw);
    procedure FreeOldBmps;
    function FGetImageBitmap(Index: Integer): TBitmap;
  protected
    m_lsDib: TDIB;
    m_dwMemChecktTick: LongWord;
  public
    m_ImgArr: PTDxImageArr;
    m_BmpArr: PTBmpImageArr;
    m_IndexList: TList;
    m_FileStream: TFileStream;
    m_MainPalette: TRGBQuads;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    procedure ClearCache;
    procedure LoadPalette;
    procedure FreeBitmap(Index: Integer);
    function GetCachedImage(Index: Integer; var px, py: Integer): TDirectDrawSurface;
    function GetCachedSurface(Index: Integer; const F: string = ''): TDirectDrawSurface;
    function GetCachedBitmap(Index: Integer): TBitmap;
    property Images[Index: Integer]: TDirectDrawSurface read FGetImageSurface;
    property ImagesName[Index: Integer; const F: string = '']: TDirectDrawSurface read FGetImageNameSurface;
    property Bitmaps[Index: Integer]: TBitmap read FGetImageBitmap;
    property DDraw: TDirectDraw read FDDraw write FDDraw;
  published
    property FileName: string read FFileName write FFileName;
    property ImageCount: Integer read FImageCount;
    property DXDraw: TDXDraw read FDxDraw write FSetDxDraw;
    property LibType: TLibType read FLibType write FLibType;
    property MaxMemorySize: Integer read FMaxMemorySize write FMaxMemorySize;
  end;

  TUIBImages = class(TComponent)
  private
    FSearchPath: string;
    FSearchFileExt: string;
    FSearchSubDir: Boolean;
    FImageCount: Integer;
    FLibType: TLibType;
    FDxDraw: TDXDraw;
    FDDraw: TDirectDraw;
    procedure LoadDxImage(pdximg: PTDxImage; sFileName: string);
    procedure FreeTempMemorys;
    function FGetImageSurface(F: string): TDirectDrawSurface;
    procedure FSetDxDraw(fdd: TDXDraw);
  protected
    m_lsDib: TDIB;
    m_dwMemChecktTick: LongWord;
  public
    m_ImgArr: PTDxImageArr;
    m_FileList: TStringList;
    m_MainPalette: TRGBQuads;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    procedure ClearCache;
    function GetCachedImage(F: string; var px, py: Integer): TDirectDrawSurface;
    function GetCachedSurface(F: string): TDirectDrawSurface;
    property Images[F: string]: TDirectDrawSurface read FGetImageSurface;
    property DDraw: TDirectDraw read FDDraw write FDDraw;
  published
    property SearchPath: string read FSearchPath write FSearchPath;
    property SearchFileExt: string read FSearchFileExt write FSearchFileExt;
    property SearchSubDir: Boolean read FSearchSubDir write FSearchSubDir default False;
    property ImageCount: Integer read FImageCount;
    property DXDraw: TDXDraw read FDxDraw write FSetDxDraw;
    property LibType: TLibType read FLibType write FLibType default ltUseCache;
  end;

var
  g_WMainImages             : TWMImages;
  
function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads; AllowPalette256: Boolean): TPaletteEntries;

procedure Register;

implementation

//uses MShare;

procedure Register;
begin
  RegisterComponents('MirGame', [TWMImages, TUIBImages]);
end;

constructor TWMImages.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FFileName := '';
  FLibType := ltLoadBmp;
  FImageCount := 0;
  FMaxMemorySize := 1024 * 1000; //1M
  FDDraw := nil;
  FDxDraw := nil;
  m_FileStream := nil;
  m_ImgArr := nil;
  m_BmpArr := nil;
  m_IndexList := TList.Create;
  m_lsDib := TDIB.Create;
  m_lsDib.BitCount := 8;
  m_dwMemChecktTick := GetTickCount;
  btVersion := 0;
end;

destructor TWMImages.Destroy;
begin
  m_IndexList.Free;
  if m_FileStream <> nil then m_FileStream.Free;
  m_lsDib.Free;
  inherited Destroy;
end;

procedure TWMImages.Initialize;
var
  IdxFile                   : string;
  Header                    : TWMImageHeader;
begin
  if not (csDesigning in ComponentState) then begin
    if FFileName = '' then begin
      raise Exception.Create('FileName not assigned..');
      Exit;
    end;
    if (LibType <> ltLoadBmp) and (FDDraw = nil) then begin
      raise Exception.Create('DDraw not assigned..');
      Exit;
    end;
    if FileExists(FFileName) then begin
      if m_FileStream = nil then
        m_FileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
      m_FileStream.Read(Header, SizeOf(TWMImageHeader));
      if Header.VerFlag = 0 then begin
        btVersion := 1;
        m_FileStream.Seek(-4, soFromCurrent);
      end;
      FImageCount := Header.ImageCount;
      if LibType = ltLoadBmp then begin
        m_BmpArr := AllocMem(SizeOf(TBmpImage) * FImageCount);
        if m_BmpArr = nil then raise Exception.Create(Self.Name + ' BmpArr = nil');
      end else begin
        m_ImgArr := AllocMem(SizeOf(TDxImage) * FImageCount);
        if m_ImgArr = nil then raise Exception.Create(Self.Name + ' ImgArr = nil');
      end;
      //IdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WIX';
      LoadPalette();
      if LibType = ltLoadMemory then
        LoadAllData()
      else
        LoadIndex(IdxFile);
    end;
  end;
end;

procedure TWMImages.Finalize;
var
  i                         : Integer;
begin
  for i := 0 to FImageCount - 1 do begin
    if m_ImgArr[i].Surface <> nil then begin
      m_ImgArr[i].Surface.Free;
      m_ImgArr[i].Surface := nil;
    end;
  end;
  if m_FileStream <> nil then begin
    m_FileStream.Free;
    m_FileStream := nil;
  end;
end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads; AllowPalette256: Boolean): TPaletteEntries;
var
  Entries                   : TPaletteEntries;
  DC                        : THandle;
  i                         : Integer;
begin
  Result := RGBQuadsToPaletteEntries(RGBQuads);
  if not AllowPalette256 then begin
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

procedure TWMImages.LoadAllData;
var
  i                         : Integer;
  imgi                      : TWMImageInfo;
  DIB                       : TDIB;
  dximg                     : TDxImage;
begin
  DIB := TDIB.Create;
  for i := 0 to FImageCount - 1 do begin
    if btVersion <> 0 then
      m_FileStream.Read(imgi, SizeOf(TWMImageInfo) - 4)
    else
      m_FileStream.Read(imgi, SizeOf(TWMImageInfo));

    DIB.Width := imgi.nWidth;
    DIB.Height := imgi.nHeight;
    DIB.ColorTable := m_MainPalette;
    DIB.UpdatePalette;
    m_FileStream.Read(DIB.PBits^, imgi.nWidth * imgi.nHeight);

    dximg.nPx := imgi.px;
    dximg.nPy := imgi.py;
    dximg.Surface := TDirectDrawSurface.Create(FDDraw);
    dximg.Surface.SystemMemory := True;
    dximg.Surface.SetSize(imgi.nWidth, imgi.nHeight);
    dximg.Surface.Canvas.Draw(0, 0, DIB);
    dximg.Surface.Canvas.Release;
    DIB.Clear;

    dximg.Surface.TransparentColor := 0;
    m_ImgArr[i] := dximg;
  end;
  DIB.Free;
end;

procedure TWMImages.LoadPalette();
var
  Entries                   : TPaletteEntries;
begin
  if btVersion <> 0 then
    m_FileStream.Seek(SizeOf(TWMImageHeader) - 4, 0)
  else
    m_FileStream.Seek(SizeOf(TWMImageHeader), 0);
  m_FileStream.Read(m_MainPalette, SizeOf(TRGBQuad) * 256);
end;

procedure TWMImages.LoadIndex(IdxFile: string);
var
  fhandle, i, Value         : Integer;
  Header                    : TWMIndexHeader;
  pValue                    : PInteger;
begin
  m_IndexList.Clear;
  if FileExists(IdxFile) then begin
    fhandle := FileOpen(IdxFile, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      if btVersion <> 0 then
        FileRead(fhandle, Header, SizeOf(TWMIndexHeader) - 4)
      else
        FileRead(fhandle, Header, SizeOf(TWMIndexHeader));
      GetMem(pValue, 4 * Header.IndexCount);
      FileRead(fhandle, pValue^, 4 * Header.IndexCount);
      for i := 0 to Header.IndexCount - 1 do begin
        Value := PInteger(Integer(pValue) + 4 * i)^;
        m_IndexList.Add(Pointer(Value));
      end;
      FreeMem(pValue);
      FileClose(fhandle);
    end;
  end;
end;

{----------------- Private Variables ---------------------}

function TWMImages.FGetImageSurface(Index: Integer): TDirectDrawSurface;
begin
  Result := nil;
  if LibType = ltUseCache then begin
    Result := GetCachedSurface(Index);
  end else if LibType = ltLoadMemory then begin
    if (Index >= 0) and (Index < ImageCount) then
      Result := m_ImgArr[Index].Surface;
  end;
end;

function TWMImages.FGetImageNameSurface(Index: Integer; const F: string = ''): TDirectDrawSurface;
begin
  Result := nil;
  if F <> '' then begin
    if LibType = ltUseCache then
      Result := GetCachedSurface(Index, F)
    else if LibType = ltLoadMemory then begin
      if (Index >= 0) and (Index < ImageCount) then
        Result := m_ImgArr[Index].Surface;
    end;
  end;
  if Result <> nil then Exit;
  if LibType = ltUseCache then
    Result := GetCachedSurface(Index)
  else if LibType = ltLoadMemory then begin
    if (Index >= 0) and (Index < ImageCount) then
      Result := m_ImgArr[Index].Surface;
  end;
end;

function TWMImages.FGetImageBitmap(Index: Integer): TBitmap;
begin
  Result := nil;
  if LibType <> ltLoadBmp then Exit;
  Result := GetCachedBitmap(Index);
end;

procedure TWMImages.FSetDxDraw(fdd: TDXDraw);
begin
  FDxDraw := fdd;
end;

procedure TWMImages.LoadDxImage(position: Integer; pdximg: PTDxImage; const F: string = '');
var
  fhandle                   : Integer;
  mStream                   : TMemoryStream;
  imgInfo                   : TWMImageInfo;
  ddsd                      : TDDSurfaceDesc;
  SBits, pSrc, DBits        : PByte;
  n, slen, dlen             : Integer;
  nErrorCode                : Integer;
  bmpHead                   : TBitmapFileHeader;
  bmpInfo                   : TBitmapInfoHeader;
begin
  if F <> '' then begin
    fhandle := FileOpen(F, fmOpenRead);
    FileRead(fhandle, bmpHead, SizeOf(TBitmapFileHeader));
    FileRead(fhandle, bmpInfo, SizeOf(TBitmapInfoHeader));
    imgInfo.nWidth := bmpInfo.biWidth;
    imgInfo.nHeight := bmpInfo.biHeight;
    imgInfo.px := 0;
    imgInfo.py := 0;
    m_lsDib.Clear;
    m_lsDib.Width := imgInfo.nWidth;
    m_lsDib.Height := imgInfo.nHeight;
    m_lsDib.ColorTable := m_MainPalette;
    m_lsDib.UpdatePalette;
    DBits := m_lsDib.PBits;
    FileSeek(fhandle, bmpHead.bfOffBits, 0);
    FileRead(fhandle, DBits^, imgInfo.nWidth * imgInfo.nHeight);
    pdximg.nPx := imgInfo.px;
    pdximg.nPy := imgInfo.py;
    pdximg.Surface := TDirectDrawSurface.Create(FDDraw);
    pdximg.Surface.SystemMemory := True;
    pdximg.Surface.SetSize(imgInfo.nWidth, imgInfo.nHeight);
    pdximg.Surface.Canvas.Draw(0, 0, m_lsDib);
    pdximg.Surface.Canvas.Release;
    pdximg.Surface.TransparentColor := 0;
    FileClose(fhandle);
    Exit;
  end;
  m_FileStream.Seek(position, 0);
  if btVersion <> 0 then
    m_FileStream.Read(imgInfo, SizeOf(TWMImageInfo) - 4)
  else
    m_FileStream.Read(imgInfo, SizeOf(TWMImageInfo));
  if g_boUseDIBSurface then begin
    m_lsDib.Clear;
    m_lsDib.Width := imgInfo.nWidth;
    m_lsDib.Height := imgInfo.nHeight;
    m_lsDib.ColorTable := m_MainPalette;
    m_lsDib.UpdatePalette;
    DBits := m_lsDib.PBits;
    m_FileStream.Read(DBits^, imgInfo.nWidth * imgInfo.nHeight);
    pdximg.nPx := imgInfo.px;
    pdximg.nPy := imgInfo.py;
    pdximg.Surface := TDirectDrawSurface.Create(FDDraw);
    pdximg.Surface.SystemMemory := True;
    pdximg.Surface.SetSize(imgInfo.nWidth, imgInfo.nHeight);
    pdximg.Surface.Canvas.Draw(0, 0, m_lsDib);
    pdximg.Surface.Canvas.Release;
    pdximg.Surface.TransparentColor := 0;
  end else begin
    slen := WidthBytes(imgInfo.nWidth);
    GetMem(pSrc, slen * imgInfo.nHeight);
    SBits := pSrc;
    m_FileStream.Read(pSrc^, slen * imgInfo.nHeight);
    try
      pdximg.Surface := TDirectDrawSurface.Create(FDDraw);
      pdximg.Surface.SystemMemory := True;
      pdximg.Surface.SetSize(slen, imgInfo.nHeight);
      pdximg.nPx := imgInfo.px;
      pdximg.nPy := imgInfo.py;
      ddsd.dwSize := SizeOf(ddsd);
      pdximg.Surface.Lock(TRect(nil^), ddsd);
      DBits := ddsd.lpSurface;
      for n := imgInfo.nHeight - 1 downto 0 do begin
        SBits := PByte(Integer(pSrc) + slen * n);
        Move(SBits^, DBits^, slen);
        Inc(Integer(DBits), ddsd.lPitch);
      end;
      pdximg.Surface.TransparentColor := 0;
    finally
      pdximg.Surface.Unlock();
      FreeMem(pSrc);
    end;
  end;
end;

procedure TWMImages.LoadBmpImage(position: Integer; pbmpimg: pTBmpImage);
var
  imgInfo                   : TWMImageInfo;
  ddsd                      : TDDSurfaceDesc;
  DBits                     : PByte;
  n, slen, dlen             : Integer;
begin
  m_FileStream.Seek(position, 0);
  m_FileStream.Read(imgInfo, SizeOf(TWMImageInfo) - 4);

  m_lsDib.Width := imgInfo.nWidth;
  m_lsDib.Height := imgInfo.nHeight;
  m_lsDib.ColorTable := m_MainPalette;
  m_lsDib.UpdatePalette;
  DBits := m_lsDib.PBits;
  m_FileStream.Read(DBits^, imgInfo.nWidth * imgInfo.nHeight);

  pbmpimg.Bmp := TBitmap.Create;
  pbmpimg.Bmp.Width := m_lsDib.Width;
  pbmpimg.Bmp.Height := m_lsDib.Height;
  pbmpimg.Bmp.Canvas.Draw(0, 0, m_lsDib);
  m_lsDib.Clear;
end;

procedure TWMImages.ClearCache;
var
  i                         : Integer;
begin
  for i := 0 to ImageCount - 1 do begin
    if m_ImgArr[i].Surface <> nil then begin
      m_ImgArr[i].Surface.Free;
      m_ImgArr[i].Surface := nil;
    end;
  end;
end;

{--------------- BMP functions ----------------}

procedure TWMImages.FreeOldBmps;
var
  i, n, ntime, limit        : Integer;
begin
  n := -1;
  ntime := 0;
  for i := 0 to ImageCount - 1 do begin
    if m_BmpArr[i].Bmp <> nil then begin
      if GetTickCount - m_BmpArr[i].dwLatestTime > 8 * 60 * 1000 then begin
        m_BmpArr[i].Bmp.Free;
        m_BmpArr[i].Bmp := nil;
      end else if GetTickCount - m_BmpArr[i].dwLatestTime > ntime then begin
        ntime := GetTickCount - m_BmpArr[i].dwLatestTime;
        n := i;
      end;
    end;
  end;
end;

procedure TWMImages.FreeBitmap(Index: Integer);
begin
  if (Index >= 0) and (Index < ImageCount) then begin
    if m_BmpArr[Index].Bmp <> nil then begin
      m_BmpArr[Index].Bmp.FreeImage;
      m_BmpArr[Index].Bmp.Free;
      m_BmpArr[Index].Bmp := nil;
    end;
  end;
end;

procedure TWMImages.FreeOldMemorys;
var
  i                         : Integer;
begin
  for i := 0 to ImageCount - 1 do begin
    if m_ImgArr[i].Surface <> nil then begin
      if GetTickCount - m_ImgArr[i].dwLatestTime > 10 * 60 * 1000 then begin
        m_ImgArr[i].Surface.Free;
        m_ImgArr[i].Surface := nil;
      end;
    end;
  end;
end;

function TWMImages.GetCachedSurface(Index: Integer; const F: string = ''): TDirectDrawSurface;
begin
  Result := nil;
  if (Index < 0) or (Index >= ImageCount) then Exit;
  if GetTickCount - m_dwMemChecktTick > 20 * 1000 then begin //CPU usage Test
    m_dwMemChecktTick := GetTickCount;
    FreeOldMemorys;
  end;
  if (F <> '') then begin
    if m_ImgArr[Index].Surface = nil then begin
      if Index < m_IndexList.count then begin
        LoadDxImage(Integer(m_IndexList[Index]), @m_ImgArr[Index], F);
        m_ImgArr[Index].dwLatestTime := GetTickCount;
        Result := m_ImgArr[Index].Surface;
      end;
    end else begin
      m_ImgArr[Index].dwLatestTime := GetTickCount;
      Result := m_ImgArr[Index].Surface;
    end;
  end;
  if Result <> nil then Exit;
  if m_ImgArr[Index].Surface = nil then begin
    if Index < m_IndexList.count then begin
      LoadDxImage(Integer(m_IndexList[Index]), @m_ImgArr[Index], F);
      m_ImgArr[Index].dwLatestTime := GetTickCount;
      Result := m_ImgArr[Index].Surface;
    end;
  end else begin
    m_ImgArr[Index].dwLatestTime := GetTickCount;
    Result := m_ImgArr[Index].Surface;
  end;
end;

function TWMImages.GetCachedImage(Index: Integer; var px, py: Integer): TDirectDrawSurface;
var
  position                  : Integer;
  nErrCode                  : Integer;
begin
  Result := nil;
  nErrCode := 0;
  try
    if (Index < 0) or (Index >= ImageCount) then Exit;
    if GetTickCount - m_dwMemChecktTick > 20 * 1000 then begin
      m_dwMemChecktTick := GetTickCount;
      FreeOldMemorys;
    end;
    nErrCode := 1;
    if m_ImgArr[Index].Surface = nil then begin
      if Index < m_IndexList.count then begin
        position := Integer(m_IndexList[Index]);
        LoadDxImage(position, @m_ImgArr[Index]);
        m_ImgArr[Index].dwLatestTime := GetTickCount;
        px := m_ImgArr[Index].nPx;
        py := m_ImgArr[Index].nPy;
        Result := m_ImgArr[Index].Surface;
      end;
    end else begin
      m_ImgArr[Index].dwLatestTime := GetTickCount;
      px := m_ImgArr[Index].nPx;
      py := m_ImgArr[Index].nPy;
      Result := m_ImgArr[Index].Surface;
    end;
  except
  end;
end;

function TWMImages.GetCachedBitmap(Index: Integer): TBitmap;
var
  position                  : Integer;
begin
  Result := nil;
  if (Index < 0) or (Index >= ImageCount) then Exit;
  if m_BmpArr[Index].Bmp = nil then begin
    if Index < m_IndexList.count then begin
      position := Integer(m_IndexList[Index]);
      LoadBmpImage(position, @m_BmpArr[Index]);
      m_BmpArr[Index].dwLatestTime := GetTickCount;
      Result := m_BmpArr[Index].Bmp;
      FreeOldBmps;
    end;
  end else begin
    m_BmpArr[Index].dwLatestTime := GetTickCount;
    Result := m_BmpArr[Index].Bmp;
  end;
end;

constructor TUIBImages.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FSearchPath := '';
  FSearchFileExt := '*.uib';
  FSearchSubDir := False;
  FLibType := ltUseCache;
  FImageCount := 0;
  FDDraw := nil;
  FDxDraw := nil;
  m_ImgArr := nil;
  m_FileList := TStringList.Create;
  m_lsDib := TDIB.Create;
  m_lsDib.BitCount := 8;
  m_dwMemChecktTick := GetTickCount;
end;

destructor TUIBImages.Destroy;
begin
  m_FileList.Free;
  m_lsDib.Free;
  inherited Destroy;
end;

procedure TUIBImages.Initialize;
var
  IdxFile                   : string;
begin
  if not (csDesigning in ComponentState) then begin
    FSearchPath := ExtractFilePath(ParamStr(0)) + FSearchPath;
    if (LibType <> ltLoadBmp) and (FDDraw = nil) then begin
      raise Exception.Create('[UIBImages DDraw not assigned...');
      Exit;
    end;
    if DirectoryExists(FSearchPath) then begin
      ////
      if SearchSubDir then
        //RecurSearchFile(FSearchPath, FSearchFileExt, m_FileList)
      else
        //GetUibFileList(FSearchPath, FSearchFileExt, m_FileList);
      FImageCount := m_FileList.count;
      m_ImgArr := AllocMem(SizeOf(TDxImage) * FImageCount);
      if m_ImgArr = nil then
        raise Exception.Create(Self.Name + 'AllocMem ImgArr = nil');
      m_MainPalette := g_WMainImages.m_MainPalette;
    end;
  end;
end;

procedure TUIBImages.Finalize;
begin
  ClearCache();
end;

procedure TUIBImages.ClearCache;
var
  i                         : Integer;
begin
  for i := 0 to ImageCount - 1 do begin
    if m_ImgArr[i].Surface <> nil then begin
      m_ImgArr[i].Surface.Free;
      m_ImgArr[i].Surface := nil;
    end;
  end;
end;

procedure TUIBImages.LoadDxImage(pdximg: PTDxImage; sFileName: string);
var
  fhandle                   : Integer;
  mStream                   : TMemoryStream;
  imgInfo                   : TWMImageInfo;
  ddsd                      : TDDSurfaceDesc;
  SBits, pSrc, DBits        : PByte;
  n, slen, dlen             : Integer;
  nErrorCode                : Integer;
  bmpHead                   : TBitmapFileHeader;
  bmpInfo                   : TBitmapInfoHeader;
begin
  if (sFileName <> '') and FileExists(sFileName) then begin
    fhandle := FileOpen(sFileName, fmOpenRead);
    FileRead(fhandle, bmpHead, SizeOf(TBitmapFileHeader));
    FileRead(fhandle, bmpInfo, SizeOf(TBitmapInfoHeader));
    imgInfo.nWidth := bmpInfo.biWidth;
    imgInfo.nHeight := bmpInfo.biHeight;
    imgInfo.px := 0;
    imgInfo.py := 0;
    m_lsDib.Clear;
    m_lsDib.Width := imgInfo.nWidth;
    m_lsDib.Height := imgInfo.nHeight;
    //g_WMainImages.m_MainPalette
    m_lsDib.ColorTable := m_MainPalette;
    m_lsDib.UpdatePalette;
    DBits := m_lsDib.PBits;
    FileSeek(fhandle, bmpHead.bfOffBits, 0);
    FileRead(fhandle, DBits^, imgInfo.nWidth * imgInfo.nHeight);
    pdximg.nPx := imgInfo.px;
    pdximg.nPy := imgInfo.py;
    pdximg.Surface := TDirectDrawSurface.Create(FDDraw);
    pdximg.Surface.SystemMemory := True;
    pdximg.Surface.SetSize(imgInfo.nWidth, imgInfo.nHeight);
    pdximg.Surface.Canvas.Draw(0, 0, m_lsDib);
    pdximg.Surface.Canvas.Release;
    pdximg.Surface.TransparentColor := 0;
    FileClose(fhandle);
  end;
end;

procedure TUIBImages.FreeTempMemorys;
var
  i                         : Integer;
begin
  for i := 0 to ImageCount - 1 do begin
    if m_ImgArr[i].Surface <> nil then begin
      if GetTickCount - m_ImgArr[i].dwLatestTime > 10 * 60 * 1000 then begin
        m_ImgArr[i].Surface.Free;
        m_ImgArr[i].Surface := nil;
      end;
    end;
  end;
end;

function TUIBImages.FGetImageSurface(F: string): TDirectDrawSurface;
begin
  Result := nil;
  if LibType = ltUseCache then
    Result := GetCachedSurface(F);
end;

procedure TUIBImages.FSetDxDraw(fdd: TDXDraw);
begin
  FDxDraw := fdd;
end;

function TUIBImages.GetCachedImage(F: string; var px, py: Integer): TDirectDrawSurface;
var
  Idx                       : Integer;
begin
  Result := nil;
  try
    Idx := m_FileList.IndexOf(ExtractFileName(F));
    if Idx < 0 then Exit;
    if GetTickCount - m_dwMemChecktTick > 20 * 1000 then begin
      m_dwMemChecktTick := GetTickCount;
      FreeTempMemorys;
    end;
    if m_ImgArr[Idx].Surface = nil then begin
      LoadDxImage(@m_ImgArr[Idx], F);
      m_ImgArr[Idx].dwLatestTime := GetTickCount;
      px := m_ImgArr[Idx].nPx;
      py := m_ImgArr[Idx].nPy;
      Result := m_ImgArr[Idx].Surface;
    end else begin
      m_ImgArr[Idx].dwLatestTime := GetTickCount;
      px := m_ImgArr[Idx].nPx;
      py := m_ImgArr[Idx].nPy;
      Result := m_ImgArr[Idx].Surface;
    end;
  except
  end;
end;

function TUIBImages.GetCachedSurface(F: string): TDirectDrawSurface;
var
  Idx                       : Integer;
begin
  Result := nil;
  Idx := m_FileList.IndexOf(ExtractFileName(F));
  if Idx < 0 then Exit;
  if GetTickCount - m_dwMemChecktTick > 20 * 1000 then begin
    m_dwMemChecktTick := GetTickCount;
    FreeTempMemorys;
  end;
  if m_ImgArr[Idx].Surface = nil then begin
    LoadDxImage(@m_ImgArr[Idx], F);
    m_ImgArr[Idx].dwLatestTime := GetTickCount;
    Result := m_ImgArr[Idx].Surface;
  end else begin
    m_ImgArr[Idx].dwLatestTime := GetTickCount;
    Result := m_ImgArr[Idx].Surface;
  end;
end;

end.

