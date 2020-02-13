unit wmUtil;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, DIB, DXDraws, DXClass;

type

  TWMImageHeader = {packed } record //56
    Title: string[43];
    ImageCount: Integer;
    ColorCount: Integer;
    PaletteSize: Integer;
    VerFlag: Integer;
  end;

  {TWMImageHeader = record
    Title: string[40];        //'WEMADE Entertainment inc.'
    ImageCount: integer;
    ColorCount: integer;
    PaletteSize: integer;
  end;}

  PTWMImageHeader = ^TWMImageHeader;

  TWMImageInfo = record
    nWidth: SmallInt;
    nHeight: SmallInt;
    px: SmallInt;
    py: SmallInt;
    bits: PByte;
  end;
  PTWMImageInfo = ^TWMImageInfo;

  TWMIndexHeader = record
    Title: string[40];
    IndexCount: Integer;
    VerFlag: Integer;
  end;
  PTWMIndexHeader = ^TWMIndexHeader;

  TWMIndexInfo = record
    Position: Integer;
    Size: Integer;
  end;
  PTWMIndexInfo = ^TWMIndexInfo;

  TDxImage = record
    LoadStep: Byte; //[+00]
    bitCount: Byte; //[+01] 1=256, 3=16bit, 8, 16, 32
    FixSize: Boolean; //[+02] 01
    dwOB: DWORD;
    nHandle: THandle;

    nW: SmallInt;
    nH: SmallInt;
    nPx: SmallInt;
    nPy: SmallInt;
    Surface: TDirectDrawSurface;
    dwLatestTime: LongWord;
  end;
  PTDxImage = ^TDxImage;

  TImageMan = record
    p1: Pointer;
    p2: Pointer;
    Surface: Pointer;
    dwLatestTime: LongWord;
  end;
  PTImageMan = ^TImageMan;

function WidthBytes(w: Integer): Integer;
function PaletteFromBmpInfo(bmpInfo: PBitmapInfo): HPalette;
function MakeBmp(w, h: Integer; bits: Pointer; pal: TRGBQuads): TBitmap;
procedure DrawBits(Canvas: TCanvas; XDest, YDest: Integer; PSource: PByte; Width, Height: Integer);

implementation

function WidthBytes(w: Integer): Integer;
begin
  Result := (((w * 8) + 31) div 32) * 4;
end;

function PaletteFromBmpInfo(bmpInfo: PBitmapInfo): HPalette;
var
  PalSize, n: Integer;
  Palette: PLogPalette;
begin
  //Allocate Memory for Palette
  PalSize := SizeOf(TLogPalette) + (256 * SizeOf(TPaletteEntry));
  Palette := AllocMem(PalSize);
  //Fill in structure
  with Palette^ do
  begin
    palVersion := $300;
    palNumEntries := 256;
    for n := 0 to 255 do
    begin
      palPalEntry[n].peRed := bmpInfo^.bmiColors[n].rgbRed;
      palPalEntry[n].peGreen := bmpInfo^.bmiColors[n].rgbGreen;
      palPalEntry[n].peBlue := bmpInfo^.bmiColors[n].rgbBlue;
      palPalEntry[n].peFlags := 0;
    end;
  end;
  Result := CreatePalette(Palette^);
  FreeMem(Palette, PalSize);
end;

procedure CreateDIB256(var Bmp: TBitmap; bmpInfo: PBitmapInfo; bits: PByte);
var
  DC, MemDc: hdc;
  OldPal: HPalette;
begin
  DC := 0;
  MemDc := 0;
  //First Release Handle and Palette from BMP
  DeleteObject(Bmp.ReleaseHandle);
  DeleteObject(Bmp.ReleasePalette);

  try
    DC := GetDC(0);
    try
      MemDc := CreateCompatibleDC(DC);
      DeleteObject(SelectObject(MemDc, CreateCompatibleBitmap(DC, 1, 1)));

      Bmp.Palette := PaletteFromBmpInfo(bmpInfo);
      OldPal := SelectPalette(MemDc, Bmp.Palette, False);
      RealizePalette(MemDc);
      try
        Bmp.Handle := CreateDIBitmap(MemDc, bmpInfo^.bmiHeader, CBM_INIT, Pointer(bits), bmpInfo^, DIB_RGB_COLORS);
      finally
        if OldPal <> 0 then
          SelectPalette(MemDc, OldPal, True);
      end;
    finally
      if MemDc <> 0 then
        DeleteDC(MemDc);
    end;
  finally
    if DC <> 0 then
      ReleaseDC(0, DC);
  end;
  if Bmp.Handle = 0 then
    Exception.Create('CreateDIBitmap failed');
end;

function MakeBmp(w, h: Integer; bits: Pointer; pal: TRGBQuads): TBitmap;
var
  i: Integer;
  bmpInfo: PBitmapInfo;
  HeaderSize: Integer;
  Bmp: TBitmap;
begin
  HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
  GetMem(bmpInfo, HeaderSize);
  for i := 0 to 255 do
    bmpInfo.bmiColors[i] := pal[i];
  with bmpInfo^.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := w;
    biHeight := h;
    biPlanes := 1;
    biBitCount := 8;
    biCompression := BI_RGB;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
  Bmp := TBitmap.Create;
  CreateDIB256(Bmp, bmpInfo, bits);
  FreeMem(bmpInfo);
  Result := Bmp;
end;

procedure DrawBits(Canvas: TCanvas; XDest, YDest: Integer; PSource: PByte; Width, Height: Integer);
var
  HeaderSize: Integer;
  bmpInfo: PBitmapInfo;
begin
  if PSource = nil then
    Exit;
  HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
  bmpInfo := AllocMem(HeaderSize);
  if bmpInfo = nil then
    raise Exception.Create('TNoryImg: Failed to allocate a DIB');
  with bmpInfo^.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := Width;
    biHeight := -Height;
    biPlanes := 1;
    biBitCount := 8;
    biCompression := BI_RGB;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
  SetDIBitsToDevice(Canvas.Handle, XDest, YDest, Width, Height, 0, 0, 0, Height, PSource, bmpInfo^, DIB_RGB_COLORS);
  FreeMem(bmpInfo, HeaderSize);
end;

end.
