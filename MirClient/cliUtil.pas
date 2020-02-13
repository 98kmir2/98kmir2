unit cliUtil;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, WIL, Grobal2, StdCtrls, DirectX, DIB, HUtil32, mmSystem,
  wmUtil;

const
  Mask64_1: Int64 = $07E007E007E007E0;
  Mask64_2: Int64 = $001F001F001F001F;
  Mask64_3: Int64 = $F800F800F800F800;
  Mask64_4: Int64 = $0100010001000100;
  Mix_i64Mask: Int64 = $F7DEF7DEF7DEF7DE;

  //Mix_Mask_SSE              : array[0..15] of Byte = ($DE, $F7, $DE, $F7, $DE, $F7, $DE, $F7, $DE, $F7, $DE, $F7, $DE, $F7, $DE, $F7);

  g_alphaArr: array[0..15] of Byte = (1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0);

  {USEASM_VERSION            = True;
  MAXGRADE                  = 64;
  DIVUNIT                   = 4;}

{var
  ADD64                     : array[0..15] of Byte = ($40, $00, $40, $00, $40, $00, $40, $00, $40, $00, $40, $00, $40, $00, $40, $00);
  MASKRED                   : array[0..15] of Byte = ($00, $F8, $00, $F8, $00, $F8, $00, $F8, $00, $F8, $00, $F8, $00, $F8, $00, $F8);
  MASKGREEN                 : array[0..15] of Byte = ($E0, $07, $E0, $07, $E0, $07, $E0, $07, $E0, $07, $E0, $07, $E0, $07, $E0, $07);
  MASKBLUE                  : array[0..15] of Byte = ($1F, $00, $1F, $00, $1F, $00, $1F, $00, $1F, $00, $1F, $00, $1F, $00, $1F, $00);}

type
  TNearestIndexHeader = record
    Title: string[30];
    IndexCount: Integer;
    desc: array[0..10] of Byte;
  end;

  TColorTable = array[0..255, 0..255] of Byte;
  PTColorTable = ^TColorTable;

function HasMMX: Boolean;
//procedure LoadC16BitPalette();
procedure BuildRealRGB(ctable: TRGBQuads);
procedure BuildColorLevels(ctable: TRGBQuads);
procedure BuildNearestIndex(ctable: TRGBQuads);
function LoadNearestIndex(flname: string): Boolean;
procedure SaveNearestIndex(flname: string);
{$IF VIEWFOG}
function LoadNearestIndex_16(flname: string): Boolean;
procedure BuildNearestIndex_16(ctable: TRGBQuads);
procedure SaveNearestIndex_16(flname: string);
{$IFEND VIEWFOG}
procedure DrawFog(sSuf: TDirectDrawSurface; fogmask: PByte; fogwidth: Integer);
procedure DrawFog_MMX(sSuf: TDirectDrawSurface; fogmask: PByte; fogwidth: Integer);
procedure FogCopy(PSource: PByte; ssx, ssy, swidth, sheight: Integer; PDest: PByte; ddx, ddy, dwidth, dheight, maxfog: Integer);
procedure MakeDark(sSuf: TDirectDrawSurface; DarkLevel: Integer);
procedure DrawBlend(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; BlendMode: Integer);

procedure DrawBlend_Mix(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);
procedure DrawBlend_Mix_MMX_16(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);
//procedure DrawBlend_Mix_fast(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);
procedure DrawBlend_Mix_Level_MMX(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);
procedure DrawBlend_Mix_Level_SSE(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);

//procedure DrawBlend_Anti_08(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);
procedure DrawBlend_Anti_MMX_16(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);
procedure DrawBlend_Anti_MMX_08(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);

//procedure DrawBlend_Anti_16_NOR(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);

procedure DrawBlend_RealColor {Optimization DrawBlendEx}(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);

procedure SpriteCopy(DestX, DestY: Integer; SourX, SourY: Integer; Size: TPoint; Sour, Dest: TDirectDrawSurface);
procedure MMXBlt(sSuf, dSuf: TDirectDrawSurface);
procedure DrawEffect(X, Y, Width, Height: Integer; sSuf: TDirectDrawSurface; eff: TColorEffect);
procedure DrawLine(Surface: TDirectDrawSurface);
procedure fast_memcpy(src, dst: PByte; len: Integer); stdcall;
procedure BuildPal_8to16(Pal: TRGBQuads);

type
  Ttab1 = array[0..$05FFF] of Byte;
  PTtab1 = ^Ttab1;
  Ttab2 = array[0..$FFFFF] of Byte;
  PTtab2 = ^Ttab2;
  Ttab3 = array[0..65535] of Word;
  PTtab3 = ^Ttab3;
  Ttab4 = array[0..30, 0..65535] of Word;
  PTtab4 = ^Ttab4;

  tagRGBQUAD_W = packed record
    rgbBlue: Word;
    rgbGreen: Word;
    rgbRed: Word;
    rgbReserved: Word;
  end;
  TRGBQuad_W = tagRGBQUAD_W;

  TDarkTab = array[0..$00020000 - 1] of tagRGBQUAD_W;
  pTDarkTab = ^TDarkTab;

  TC16BitPalette = array[0..65535] of Byte;
  PTC16BitPalette = ^TC16BitPalette;

var
  g_boLoadMainPal: Boolean = False;
  g_MainPalette: TRGBQuads;
  DarkLevel: Integer;
  Color256real: array[0..255, 0..255] of Byte;
  pal_8to16: array[0..255] of Word; //1020

implementation

uses MShare, ClMain;

var
  //RgbIndexTable             : array[0..MAXGRADE - 1, 0..MAXGRADE - 1, 0..MAXGRADE - 1] of Byte;
  Color256Mix: array[0..255, 0..255] of Byte;
  Color256Anti: array[0..255, 0..255] of Byte;
  //Color256real              : array[0..255, 0..255] of byte;
  HeavyDarkColorLevel: array[0..255, 0..255] of Byte;
  LightDarkColorLevel: array[0..255, 0..255] of Byte;
  DengunColorLevel: array[0..255, 0..255] of Byte;
  g_pGrayScaleLevel_16: PTtab3; //array[0..$1FFFF] of Word;
  g_pBrightColorLevel_16: PTtab3; //array[0..$1FFFF] of Word;
  g_pRedishColorLevel_16: PTtab3; //array[0..$1FFFF] of Word;
  g_pGreenColorLevel_16: PTtab3; //array[0..$1FFFF] of Word;
  g_pBlueColorLevel_16: PTtab3; //array[0..$1FFFF] of Word;
  g_pYellowColorLevel_16: PTtab3; //array[0..$1FFFF] of Word;
  g_pFuchsiaColorLevel_16: PTtab3; //array[0..$1FFFF] of Word;

  g_pDarkColorLevel_16: PTtab3;
  g_pBlackColorLevel_16: PTtab3;
  g_pWhiteColorLevel_16: PTtab3;
  g_pHDarkColorLevel_16: PTtab3;

  g_HeavyDarkColorLevel_16: PTtab4;
  g_LightDarkColorLevel_16: PTtab4;
  g_DengunColorLevel_16: PTtab4;

const
  CACHEBLOCK = $400;

procedure fast_memcpy(src, dst: PByte; len: Integer); stdcall;
asm
  push esi
  push edi
  push ebx

  mov esi, [src]               // source array
  mov edi, [dst]               // destination array
  mov ecx, [len]               // number of QWORDS (8 bytes) assumes len / CACHEBLOCK is an integer
  shr ecx, 3

  lea esi, [esi+ecx*8]       // end of source
  lea edi, [edi+ecx*8]       // end of destination
  neg ecx                    // use a negative offset as a combo pointer-and-loop-counter

{@mainloop:
  mov eax, CACHEBLOCK / 16   // note: .prefetchloop is unrolled 2X
  add ecx, CACHEBLOCK        // move up to end of block

@prefetchloop:
  mov ebx, [esi+ecx*8-64]    // read one address in this cache line...
  mov ebx, [esi+ecx*8-128]   // ... and one in the previous line
  sub ecx, 16                // 16 QWORDS = 2 64-byte cache lines
  dec eax
  jnz @prefetchloop

  mov eax, CACHEBLOCK / 8}

@writeloop:
  prefetchnta [esi+ecx*8 + 512] // fetch ahead by 512 bytes

  movq mm0, qword [esi+ecx*8]
  movq mm1, qword [esi+ecx*8+8]
  movq mm2, qword [esi+ecx*8+16]
  movq mm3, qword [esi+ecx*8+24]
  movq mm4, qword [esi+ecx*8+32]
  movq mm5, qword [esi+ecx*8+40]
  movq mm6, qword [esi+ecx*8+48]
  movq mm7, qword [esi+ecx*8+56]

  movntq qword [edi+ecx*8], mm0
  movntq qword [edi+ecx*8+8], mm1
  movntq qword [edi+ecx*8+16], mm2
  movntq qword [edi+ecx*8+24], mm3
  movntq qword [edi+ecx*8+32], mm4
  movntq qword [edi+ecx*8+40], mm5
  movntq qword [edi+ecx*8+48], mm6
  movntq qword [edi+ecx*8+56], mm7

  add ecx, 8
  //dec eax
  jnz @writeloop

  //or ecx, ecx // assumes integer number of cacheblocks
  //jnz @mainloop

  sfence // flush write buffer
  emms

  pop ebx
  pop edi
  pop esi
end;

(*
typedef struct {
    unsigned int eax;
    unsigned int ebx;
    unsigned int ecx;
    unsigned int edx;
} cpuid_regs_t;

static int check_opt_flag(void)
{
    cpuid_regs_t regs;

#define CPUID   ".byte 0x0f, 0xa2; "
    asm(CPUID
            : "=a" (regs.eax), "=b" (regs.ebx), "=c" (regs.ecx), "=d" (regs.edx)
            : "0" (1));

    if (regs.edx & 0x4000000)
        return (DEF_OPT_FLAG_SSE2);
    if (regs.edx & 0x2000000)
        return (DEF_OPT_FLAG_SSE);
    if (regs.edx & 0x800000)
        return (DEF_OPT_FLAG_MMX);
    return (DEF_OPT_FLAG_NONE);
}
*)

function HasMMX: Boolean;
var
  n: Byte;
begin
  asm
      mov   eax, 1
      db $0F,$A2               /// CPUID
      test  edx, 00800000H
      mov   n, 1
      jnz   @@Found
      mov   n, 0
   @@Found:
  end;
  if n = 1 then
    Result := True
  else
    Result := False;
end;

procedure BuildNearestIndex(ctable: TRGBQuads);
var
  MinDif, ColDif: Integer;
  MatchColor: Byte;
  pal0, pal1, pal2: TRGBQuad;

  procedure BuildMix;
  var
    i, j, n: Integer;
  begin
    for i := 0 to 255 do
    begin
      pal0 := ctable[i];
      for j := 0 to 255 do
      begin
        pal1 := ctable[j];
        pal1.rgbRed := pal0.rgbRed div 2 + pal1.rgbRed div 2;
        pal1.rgbGreen := pal0.rgbGreen div 2 + pal1.rgbGreen div 2;
        pal1.rgbBlue := pal0.rgbBlue div 2 + pal1.rgbBlue div 2;
        MinDif := 768;
        MatchColor := 0;
        for n := 0 to 255 do
        begin
          pal2 := ctable[n];
          ColDif := abs(pal2.rgbRed - pal1.rgbRed) + abs(pal2.rgbGreen - pal1.rgbGreen) + abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then
          begin
            MinDif := ColDif;
            MatchColor := n;
          end;
        end;
        Color256Mix[i, j] := MatchColor;
      end;
    end;
  end;

  procedure BuildAnti;
  var
    i, j, n: Integer;
  begin
    for i := 0 to 255 do
    begin
      pal0 := ctable[i];
      for j := 0 to 255 do
      begin
        pal1 := ctable[j];
        // ever := _MAX(pal0.rgbRed, pal0.rgbGreen);
        // ever := _MAX(ever, pal0.rgbBlue);
        pal1.rgbRed := _MIN(255, Round(pal0.rgbRed + (255 - pal0.rgbRed) / 255 * pal1.rgbRed));
        pal1.rgbGreen := _MIN(255, Round(pal0.rgbGreen + (255 - pal0.rgbGreen) / 255 * pal1.rgbGreen));
        pal1.rgbBlue := _MIN(255, Round(pal0.rgbBlue + (255 - pal0.rgbBlue) / 255 * pal1.rgbBlue));
        MinDif := 768;
        MatchColor := 0;
        for n := 0 to 255 do
        begin
          pal2 := ctable[n];
          ColDif := abs(pal2.rgbRed - pal1.rgbRed) + abs(pal2.rgbGreen - pal1.rgbGreen) + abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then
          begin
            MinDif := ColDif;
            MatchColor := n;
          end;
        end;
        Color256Anti[i, j] := MatchColor;
      end;
    end;
  end;

  procedure BuildColorLevels2;
  var
    n, i, j, rr, gg, bb: Integer;
  begin
    for n := 0 to 30 do
    begin
      for i := 0 to 255 do
      begin
        pal1 := ctable[i];
        rr := _MIN(Round(pal1.rgbRed * (n + 1) / 31) - 5, 255); //(n + (n-1)*3) / 121);
        gg := _MIN(Round(pal1.rgbGreen * (n + 1) / 31) - 5, 255); //(n + (n-1)*3) / 121);
        bb := _MIN(Round(pal1.rgbBlue * (n + 1) / 31) - 5, 255); //(n + (n-1)*3) / 121);
        pal1.rgbRed := _MAX(0, rr);
        pal1.rgbGreen := _MAX(0, gg);
        pal1.rgbBlue := _MAX(0, bb);
        MinDif := 768;
        MatchColor := 0;
        for j := 0 to 255 do
        begin
          pal2 := ctable[j];
          ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
            abs(pal2.rgbGreen - pal1.rgbGreen) +
            abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then
          begin
            MinDif := ColDif;
            MatchColor := j;
          end;
        end;
        HeavyDarkColorLevel[n, i] := MatchColor;
      end;
    end;
    for n := 0 to 30 do
    begin
      for i := 0 to 255 do
      begin
        pal1 := ctable[i];
        pal1.rgbRed := _MIN(Round(pal1.rgbRed * (n * 3 + 47) / 140), 255);
        pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * (n * 3 + 47) / 140), 255);
        pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * (n * 3 + 47) / 140), 255);
        MinDif := 768;
        MatchColor := 0;
        for j := 0 to 255 do
        begin
          pal2 := ctable[j];
          ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
            abs(pal2.rgbGreen - pal1.rgbGreen) +
            abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then
          begin
            MinDif := ColDif;
            MatchColor := j;
          end;
        end;
        LightDarkColorLevel[n, i] := MatchColor;
      end;
    end;
    for n := 0 to 30 do
    begin
      for i := 0 to 255 do
      begin
        pal1 := ctable[i];
        pal1.rgbRed := _MIN(Round(pal1.rgbRed * (n * 3 + 120) / 214), 255);
        pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * (n * 3 + 120) / 214), 255);
        pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * (n * 3 + 120) / 214), 255);
        MinDif := 768;
        MatchColor := 0;
        for j := 0 to 255 do
        begin
          pal2 := ctable[j];
          ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
            abs(pal2.rgbGreen - pal1.rgbGreen) +
            abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then
          begin
            MinDif := ColDif;
            MatchColor := j;
          end;
        end;
        DengunColorLevel[n, i] := MatchColor;
      end;
    end;

    {for i := 0 to 255 do begin
      HeavyDarkColorLevel[0, i] := HeavyDarkColorLevel[1, i];
      LightDarkColorLevel[0, i] := LightDarkColorLevel[1, i];
      DengunColorLevel[0, i] := DengunColorLevel[1, i];
    end;}
    for n := 31 to 255 do
      for i := 0 to 255 do
      begin
        HeavyDarkColorLevel[n, i] := HeavyDarkColorLevel[30, i];
        LightDarkColorLevel[n, i] := LightDarkColorLevel[30, i];
        DengunColorLevel[n, i] := DengunColorLevel[30, i];
      end;

  end;
begin
  BuildMix;
  BuildAnti;
  BuildColorLevels2;
end;

procedure BuildColorLevels(ctable: TRGBQuads);
var
{$IF MIR2EX}
  i, j, k, l, n: Integer;
  r, g, b: Integer;

  function MatchColor(): Word;
  begin
    if r > 255 then
      r := 255;
    if g > 255 then
      g := 255;
    if b > 255 then
      b := 255;
    Result := ((r shl $08) and $F800) or ((g shl $03) and $07E0) or ((b shr $03) and $001F);
  end;

{$ELSE}
  n, i, j, MinDif, ColDif, ii: Integer;
  pal1, pal2: TRGBQuad;
  MatchColor: Byte;
{$IFEND MIR2EX}
begin
{$IF MIR2EX}
  for i := 0 to (65536 - 1) do
  begin
    j := (i and $0000F800) shr $08; //edi
    k := (i and $000007E0) shr $03; //[ebp-10]
    l := (i and $0000001F) shl $03; //[ebp-14]

    n := (j + k + l) div 3; //esi

    r := Round(j * 0.75);
    g := Round(k * 0.75);
    b := Round(l * 0.75);
    g_pDarkColorLevel_16[i] := MatchColor();

    r := Round(j * 1.30);
    g := Round(k * 1.30);
    b := Round(l * 1.30);
    g_pBrightColorLevel_16[i] := MatchColor();

    r := n;
    g := n;
    b := n;
    g_pGrayScaleLevel_16[i] := MatchColor();

    r := Round(n * 0.60);
    g := r;
    b := r;
    g_pBlackColorLevel_16[i] := MatchColor();

    r := Round(n * 1.60);
    g := r;
    b := r;
    g_pWhiteColorLevel_16[i] := MatchColor();

    r := Round(n * 0.40);
    g := r;
    b := r;
    g_pHDarkColorLevel_16[i] := MatchColor();

    r := n;
    g := 0;
    b := 0;
    g_pRedishColorLevel_16[i] := MatchColor();

    r := 0;
    g := n;
    b := 0;
    g_pGreenColorLevel_16[i] := MatchColor();

    r := 0;
    g := 0;
    b := n;
    g_pBlueColorLevel_16[i] := MatchColor();

    r := n;
    g := n;
    b := 0;
    g_pYellowColorLevel_16[i] := MatchColor();

    r := n;
    g := 0;
    b := n;
    g_pFuchsiaColorLevel_16[i] := MatchColor();

  end;
{$ELSE}
  BrightColorLevel[0] := 0;
  for i := 1 to 255 do
  begin
    pal1 := ctable[i];
    pal1.rgbRed := _MIN(Round(pal1.rgbRed * 1.3), 255);
    pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * 1.3), 255);
    pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * 1.3), 255);
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do
    begin
      pal2 := ctable[j];
      ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
        abs(pal2.rgbGreen - pal1.rgbGreen) +
        abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then
      begin
        MinDif := ColDif;
        MatchColor := j;
      end;
    end;
    BrightColorLevel[i] := MatchColor;
  end;

  DarkColorLevel[0] := 0;
  for i := 1 to 255 do
  begin
    pal1 := ctable[i];
    pal1.rgbRed := _MIN(Round(pal1.rgbRed * 0.7), 255);
    pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * 0.7), 255);
    pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * 0.7), 255);
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do
    begin
      pal2 := ctable[j];
      ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
        abs(pal2.rgbGreen - pal1.rgbGreen) +
        abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then
      begin
        MinDif := ColDif;
        MatchColor := j;
      end;
    end;
    DarkColorLevel[i] := MatchColor;
  end;

  GrayScaleLevel[0] := 0;
  for i := 1 to 255 do
  begin
    pal1 := ctable[i];
    n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := n; //Round(pal1.rgbRed * (n*3+25) / 118);
    pal1.rgbGreen := n; //Round(pal1.rgbGreen * (n*3+25) / 118);
    pal1.rgbBlue := n; //Round(pal1.rgbBlue * (n*3+25) / 118);
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do
    begin
      pal2 := ctable[j];
      ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
        abs(pal2.rgbGreen - pal1.rgbGreen) +
        abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then
      begin
        MinDif := ColDif;
        MatchColor := j;
      end;
    end;
    GrayScaleLevel[i] := MatchColor;
  end;

  BlackColorLevel[0] := 0;
  for i := 1 to 255 do
  begin
    pal1 := ctable[i];
    n := Round((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3 * 0.6);
    pal1.rgbRed := n; //_MAX(8, Round(pal1.rgbRed * 0.7));
    pal1.rgbGreen := n; //_MAX(8, Round(pal1.rgbGreen * 0.7));
    pal1.rgbBlue := n; //_MAX(8, Round(pal1.rgbBlue * 0.7));
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do
    begin
      pal2 := ctable[j];
      ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
        abs(pal2.rgbGreen - pal1.rgbGreen) +
        abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then
      begin
        MinDif := ColDif;
        MatchColor := j;
      end;
    end;
    BlackColorLevel[i] := MatchColor;
  end;

  WhiteColorLevel[0] := 0;
  for i := 1 to 255 do
  begin
    pal1 := ctable[i];
    n := _MIN(Round((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3 * 1.6), 255);
    pal1.rgbRed := n; //_MAX(8, Round(pal1.rgbRed * 0.7));
    pal1.rgbGreen := n; //_MAX(8, Round(pal1.rgbGreen * 0.7));
    pal1.rgbBlue := n; //_MAX(8, Round(pal1.rgbBlue * 0.7));
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do
    begin
      pal2 := ctable[j];
      ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
        abs(pal2.rgbGreen - pal1.rgbGreen) +
        abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then
      begin
        MinDif := ColDif;
        MatchColor := j;
      end;
    end;
    WhiteColorLevel[i] := MatchColor;
  end;

  RedishColorLevel[0] := 0;
  for i := 1 to 255 do
  begin
    pal1 := ctable[i];
    n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := n;
    pal1.rgbGreen := 0;
    pal1.rgbBlue := 0;
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do
    begin
      pal2 := ctable[j];
      ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
        abs(pal2.rgbGreen - pal1.rgbGreen) +
        abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then
      begin
        MinDif := ColDif;
        MatchColor := j;
      end;
    end;
    RedishColorLevel[i] := MatchColor;
  end;

  GreenColorLevel[0] := 0;
  for i := 1 to 255 do
  begin
    pal1 := ctable[i];
    n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := 0;
    pal1.rgbGreen := n;
    pal1.rgbBlue := 0;
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do
    begin
      pal2 := ctable[j];
      ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
        abs(pal2.rgbGreen - pal1.rgbGreen) +
        abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then
      begin
        MinDif := ColDif;
        MatchColor := j;
      end;
    end;
    GreenColorLevel[i] := MatchColor;
  end;

  YellowColorLevel[0] := 0;
  for i := 1 to 255 do
  begin
    pal1 := ctable[i];
    n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := n;
    pal1.rgbGreen := n;
    pal1.rgbBlue := 0;
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do
    begin
      pal2 := ctable[j];
      ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
        abs(pal2.rgbGreen - pal1.rgbGreen) +
        abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then
      begin
        MinDif := ColDif;
        MatchColor := j;
      end;
    end;
    YellowColorLevel[i] := MatchColor;
  end;

  BlueColorLevel[0] := 0;
  for i := 1 to 255 do
  begin
    pal1 := ctable[i];
    n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := 0;
    pal1.rgbGreen := 0;
    pal1.rgbBlue := n;
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do
    begin
      pal2 := ctable[j];
      ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
        abs(pal2.rgbGreen - pal1.rgbGreen) +
        abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then
      begin
        MinDif := ColDif;
        MatchColor := j;
      end;
    end;
    BlueColorLevel[i] := MatchColor;
  end;

  FuchsiaColorLevel[0] := 0;
  for i := 1 to 255 do
  begin
    pal1 := ctable[i];
    n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
    pal1.rgbRed := n;
    pal1.rgbGreen := 0;
    pal1.rgbBlue := n;
    MinDif := 768;
    MatchColor := 0;
    for j := 1 to 255 do
    begin
      pal2 := ctable[j];
      ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
        abs(pal2.rgbGreen - pal1.rgbGreen) +
        abs(pal2.rgbBlue - pal1.rgbBlue);
      if ColDif < MinDif then
      begin
        MinDif := ColDif;
        MatchColor := j;
      end;
    end;
    FuchsiaColorLevel[i] := MatchColor;
  end;
{$IFEND MIR2EX}
end;

procedure SaveNearestIndex(flname: string);
var
  nih: TNearestIndexHeader;
  fhandle: Integer;
begin
  nih.Title := 'WEMADE Entertainment Inc.';
  nih.IndexCount := SizeOf(Color256Mix);
  if FileExists(flname) then
  begin
    fhandle := FileOpen(flname, fmOpenWrite or fmShareDenyNone);
  end
  else
    fhandle := FileCreate(flname);
  if fhandle > 0 then
  begin
    FileWrite(fhandle, nih, SizeOf(TNearestIndexHeader));
    FileWrite(fhandle, Color256Mix, SizeOf(Color256Mix));
    FileWrite(fhandle, Color256Anti, SizeOf(Color256Anti));
    FileWrite(fhandle, HeavyDarkColorLevel, SizeOf(HeavyDarkColorLevel));
    FileWrite(fhandle, LightDarkColorLevel, SizeOf(LightDarkColorLevel));
    FileWrite(fhandle, DengunColorLevel, SizeOf(DengunColorLevel));
    FileClose(fhandle);
  end;
end;

function LoadNearestIndex(flname: string): Boolean;
var
  nih: TNearestIndexHeader;
  fhandle, rsize: Integer;
begin
  Result := False;
  if FileExists(flname) then
  begin
    fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then
    begin
      FileRead(fhandle, nih, SizeOf(TNearestIndexHeader));
      if nih.IndexCount = SizeOf(Color256Mix) then
      begin
        Result := True;
        rsize := 256 * 256;
        if rsize <> FileRead(fhandle, Color256Mix, SizeOf(Color256Mix)) then
          Result := False;
        if rsize <> FileRead(fhandle, Color256Anti, SizeOf(Color256Anti)) then
          Result := False;
        if rsize <> FileRead(fhandle, HeavyDarkColorLevel, SizeOf(HeavyDarkColorLevel)) then
          Result := False;
        if rsize <> FileRead(fhandle, LightDarkColorLevel, SizeOf(LightDarkColorLevel)) then
          Result := False;
        if rsize <> FileRead(fhandle, DengunColorLevel, SizeOf(DengunColorLevel)) then
          Result := False;
      end;
      FileClose(fhandle);
    end;
  end;
end;
{$IF VIEWFOG}

function LoadNearestIndex_16(flname: string): Boolean;
var
  nih: TNearestIndexHeader;
  fhandle, rsize: Integer;
begin
  Result := False;
  if FileExists(flname) then
  begin
    fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then
    begin
      FileRead(fhandle, nih, SizeOf(TNearestIndexHeader));
      if nih.IndexCount = SizeOf(Ttab4) then
      begin
        Result := True;
        rsize := SizeOf(Ttab4);
        if rsize <> FileRead(fhandle, g_HeavyDarkColorLevel_16^, SizeOf(Ttab4)) then
          Result := False;
        if rsize <> FileRead(fhandle, g_LightDarkColorLevel_16^, SizeOf(Ttab4)) then
          Result := False;
        if rsize <> FileRead(fhandle, g_DengunColorLevel_16^, SizeOf(Ttab4)) then
          Result := False;
      end;
      FileClose(fhandle);
    end;
  end;
end;

procedure SaveNearestIndex_16(flname: string);
var
  nih: TNearestIndexHeader;
  fhandle: Integer;
begin
  nih.Title := 'LEGEND Entertainment Inc.';
  nih.IndexCount := SizeOf(Ttab4);
  if FileExists(flname) then
  begin
    fhandle := FileOpen(flname, fmOpenWrite or fmShareDenyNone);
  end
  else
    fhandle := FileCreate(flname);
  if fhandle > 0 then
  begin
    FileWrite(fhandle, nih, SizeOf(TNearestIndexHeader));
    //FileWrite(fhandle, Color256Mix, SizeOf(Color256Mix));
    //FileWrite(fhandle, Color256Anti, SizeOf(Color256Anti));
    FileWrite(fhandle, g_HeavyDarkColorLevel_16^, SizeOf(Ttab4));
    FileWrite(fhandle, g_LightDarkColorLevel_16^, SizeOf(Ttab4));
    FileWrite(fhandle, g_DengunColorLevel_16^, SizeOf(Ttab4));
    FileClose(fhandle);
  end;
end;

procedure BuildNearestIndex_16(ctable: TRGBQuads);
var
  i, j, k, l, ii: Integer;
  r, g, b: Integer;

  function MatchColor(): Word;
  begin
    if r > 255 then
      r := 255;
    if g > 255 then
      g := 255;
    if b > 255 then
      b := 255;
    Result := ((r shl $08) and $F800) or ((g shl $03) and $07E0) or ((b shr $03) and $001F);
  end;

  function MatchColor2(): Word;
  begin
    if r < 000 then
      r := 000;
    if g < 000 then
      g := 000;
    if b < 000 then
      b := 000;

    if r > 255 then
      r := 255;
    if g > 255 then
      g := 255;
    if b > 255 then
      b := 255;

    Result := ((r shl $08) and $F800) or ((g shl $03) and $07E0) or ((b shr $03) and $001F);
  end;

begin
  for ii := 0 to 30 do
  begin
    for i := 0 to (65536 - 1) do
    begin
      j := (i and $0000F800) shr $08;
      k := (i and $000007E0) shr $03;
      l := (i and $0000001F) shl $03;

      r := Round(j * (ii + 1) / 31) - 5;
      g := Round(k * (ii + 1) / 31) - 5;
      b := Round(l * (ii + 1) / 31) - 5;
      g_HeavyDarkColorLevel_16[ii, i] := MatchColor2;

      r := Round(j * (ii * 3 + 47) / 140);
      g := Round(k * (ii * 3 + 47) / 140);
      b := Round(l * (ii * 3 + 47) / 140);
      g_LightDarkColorLevel_16[ii, i] := MatchColor2;

      r := Round(j * (ii * 3 + 120) / 214);
      g := Round(k * (ii * 3 + 120) / 214);
      b := Round(l * (ii * 3 + 120) / 214);
      g_DengunColorLevel_16[ii, i] := MatchColor2;
    end;
  end;
end;
{$IFEND VIEWFOG}

procedure FogCopy_SSE(PSource: PByte; ssx, ssy, swidth, sheight: Integer; PDest: PByte; ddx, ddy, dwidth, dheight, maxfog: Integer);
var
  Row, srclen, srcheight, spitch, dpitch, remain: Integer;
begin
  if (PSource = nil) or (PDest = nil) then Exit;
  
  spitch := swidth;
  dpitch := dwidth;
  if ddx < 0 then
  begin
    ssx := ssx - ddx;
    swidth := swidth + ddx;
    ddx := 0;
  end;
  if ddy < 0 then
  begin
    ssy := ssy - ddy;
    sheight := sheight + ddy;
    ddy := 0;
  end;

  srclen := _MIN(swidth, dwidth - ddx);
  srcheight := _MIN(sheight, dheight - ddy);
  if (srclen <= 0) or (srcheight <= 0) then
    Exit;

  remain := srclen mod 16;
  begin
    asm
         pushad
         mov   row, 0
      @@NextRow:
         mov   eax, row
         cmp   eax, srcheight
         jae   @@Finish

         mov   esi, psource
         mov   eax, ssy
         add   eax, row
         mov   ebx, spitch
         imul  eax, ebx
         add   eax, ssx
         add   esi, eax          //sptr

         mov   edi, pdest
         mov   eax, ddy
         add   eax, row
         mov   ebx, dpitch
         imul  eax, ebx
         add   eax, ddx
         add   edi, eax          //dptr

         mov   ebx, srclen

      @@FogNext:
         cmp ebx, 00000000
         jbe @@FogNext_Min
         cmp ebx, $0010
         jb  @@FogNext_Min
         db  $66 movups xmm0, dqword ptr [esi]
         db  $66 movups xmm1, dqword ptr [edi]
         db  $66 paddd mm1, mm0
         db  $66 movups dqword ptr [edi], xmm1
         sub ebx, $0010
         add esi, $0010
         add edi, $0010
         jmp @@FogNext

      @@FogNext_Min:
         mov   ebx, remain

      @@FogNext_R:
         cmp   ebx, 0
         jbe   @@FinOne
         mov   al, byte ptr [esi]
         mov   dl, byte ptr [edi]
         add   dl, al
         mov   [edi].byte, dl
         dec   ebx
         inc   esi
         inc   edi
         jmp   @@FogNext_R

      @@FinOne:
         inc   row
         jmp   @@NextRow

      @@Finish:
         emms
         popad
    end;
  end;
end;

procedure FogCopy(PSource: PByte; ssx, ssy, swidth, sheight: Integer; PDest: PByte; ddx, ddy, dwidth, dheight, maxfog: Integer);
var
  Row, srclen, srcheight, spitch, dpitch, remain: Integer;
begin
  if SSE_AVAILABLE then
  begin
    FogCopy_SSE(PSource, ssx, ssy, swidth, sheight, PDest, ddx, ddy, dwidth, dheight, maxfog);
    Exit;
  end;
  if (PSource = nil) or (PDest = nil) then
    Exit;
  spitch := swidth;
  dpitch := dwidth;
  if ddx < 0 then
  begin
    ssx := ssx - ddx;
    swidth := swidth + ddx;
    ddx := 0;
  end;
  if ddy < 0 then
  begin
    ssy := ssy - ddy;
    sheight := sheight + ddy;
    ddy := 0;
  end;

  srclen := _MIN(swidth, dwidth - ddx);
  srcheight := _MIN(sheight, dheight - ddy);
  if (srclen <= 0) or (srcheight <= 0) then
    Exit;
  remain := srclen mod 8;
  begin
    asm
         pushad
         mov   row, 0
      @@NextRow:
         mov   eax, row
         cmp   eax, srcheight
         jae   @@Finish

         mov   esi, psource
         mov   eax, ssy
         add   eax, row
         mov   ebx, spitch
         imul  eax, ebx
         add   eax, ssx
         add   esi, eax          //sptr

         mov   edi, pdest
         mov   eax, ddy
         add   eax, row
         mov   ebx, dpitch
         imul  eax, ebx
         add   eax, ddx
         add   edi, eax          //dptr

         mov   ebx, srclen

      @@FogNext:
         cmp   ebx, 0
         jbe   @@FogNext_Min      //@@FinOne
         cmp   ebx, 8
         jb    @@FogNext_Min

         db $0F,$6F,$06           /// movq  mm0, [esi]
         db $0F,$6F,$0F           /// movq  mm1, [edi]
         db $0F,$FE,$C8           /// paddd mm1, mm0
         db $0F,$7F,$0F           /// movq [edi], mm1

         sub   ebx, 8
         add   esi, 8
         add   edi, 8
         jmp   @@FogNext

      @@FogNext_Min:
         mov   ebx, remain

      @@FogNext_R:
         cmp   ebx, 0
         jbe   @@FinOne
         mov   al, byte ptr [esi]
         mov   dl, byte ptr [edi]
         add   dl, al
         mov   [edi].byte, dl
         dec   ebx
         inc   esi
         inc   edi
         jmp   @@FogNext_R

      @@FinOne:
         inc   row
         jmp   @@NextRow

      @@Finish:
         db $0F,$77               // emms
         popad
    end;
  end;
end;

procedure DrawFog(sSuf: TDirectDrawSurface; fogmask: PByte; fogwidth: Integer);
var
  Row: Integer;
  ddsd: TDDSurfaceDesc;
  srclen, srcheight: Integer;
  lPitch: Integer;
  PSource, pColorLevel: PByte;
begin
  if sSuf.Width > SCREENWIDTH + 100 then
    Exit;
  case DarkLevel of
    1: pColorLevel := PByte(g_HeavyDarkColorLevel_16);
    2: pColorLevel := PByte(g_LightDarkColorLevel_16);
    3: pColorLevel := PByte(g_DengunColorLevel_16);
  else
    Exit;
  end;

  try
    sSuf.Lock(ddsd);
    srclen := _MIN(sSuf.Width, fogwidth);
    srcheight := sSuf.Height;
    lPitch := ddsd.lPitch; //- sSuf.Width * 2;
    PSource := ddsd.lpSurface;
    //mPtr := @pal_8to16;

    asm
            pushad
            mov   row, 0
         @@NextRow:
            mov   ebx, row
            //mov   eax, srcheight
            cmp   ebx, srcheight          //copy finish ...
            jge   @@exit

            mov   esi, psource      //esi = ddsd.lpSurface;
            mov   eax, lpitch
            //mov   ebx, row
            imul  eax, row
            add   esi, eax

            mov   edi, fogmask      //edi = fogmask
            mov   eax, fogwidth
            //mov   ebx, row
            imul  eax, row
            add   edi, eax

            mov   ecx, srclen
            mov   edx, pColorLevel

         @@NextByte:
            cmp   ecx, 0
            jle   @@Finish

            movzx eax, byte ptr [edi]
            cmp eax, 30
            jle @next
            mov eax, 30
@next:
            imul  eax, 65536 * 2           //SizeOf(word)
            movzx ebx, [esi].word
            imul  ebx, 2                   //SizeOf(Word)
            add   eax, ebx
            mov   ax,  [edx+eax].word
            mov   [esi].word, ax

            dec   ecx
            add   esi, $0002
            inc   edi
            jmp   @@NextByte

         @@Finish:
            inc   row
            jmp   @@NextRow

         @@exit:
            db $0F,$77               // emms
            popad
    end;
  finally
    sSuf.UnLock();
  end;
end;

function MakeDarkPixels(DarkLevel: Integer; Pixel: Word): Word;
var
  r, g, b: Byte;
begin
  r := Round((30 - DarkLevel) * (32 / 30));
  g := Round((30 - DarkLevel) * (32 / 15));
  b := Round((30 - DarkLevel) * (32 / 30));

  asm
      pushad

      xor edx, edx
      mov dl, r
      shl edx, $10

      xor ecx, ecx
      mov cl, g
      shl ecx, $08
      or edx, ecx

      xor ecx, ecx
      mov cl, b
      or edx, ecx

      movd  mm0, edx

      movzx eax, Pixel
      mov ebx, eax
      mov edi, eax
      and ebx, $0000F800
      and edi, $000007E0
      and eax, $0000001F
      shl ebx, $05
      shl edi, $03
      or eax, ebx
      or eax, edi
      movd  mm1, eax

      psubusb  mm1, mm0
      movd  eax, mm1
      mov ebx, eax
      mov edi, eax
      and ebx, $001F0000
      and edi, $00003F00
      and eax, $0000001F
      shr ebx, $05
      shr edi, $03
      or eax, edi
      or eax, ebx
      mov result, ax
      emms
      popad
  end;
end;

procedure DrawFog_MMX2(sSuf: TDirectDrawSurface; fogmask: PByte; fogwidth: Integer);
var
  Row: Integer;
  ddsd: TDDSurfaceDesc;
  srclen, srcheight: Integer;
  lPitch: Integer;
  PSource, pColorLevel: PByte;
const
  i64Mask_1: Int64 = $00000000000000FF;
  i64Mask_2: Int64 = $000000000000F800;
  i64Mask_3: Int64 = $00000000000007E0;
  i64Mask_4: Int64 = $000000000000001F;
begin
  if sSuf.Width > SCREENWIDTH + 100 then
    Exit;
  case DarkLevel of
    1: pColorLevel := @HeavyDarkColorLevel;
    2: pColorLevel := @LightDarkColorLevel;
    3: pColorLevel := @DengunColorLevel;
  else
    Exit;
  end;

  try
    sSuf.Lock({TRect(nil^),} ddsd);
    srclen := _MIN(sSuf.Width, fogwidth);
    //pSrc := @src;
    srcheight := sSuf.Height;
    lPitch := ddsd.lPitch;
    PSource := ddsd.lpSurface;
    //mPtr := @pal_8to16;

    asm
            pushad
            mov   row, 0
         @@NextRow:
            mov   ebx, row
            mov   eax, srcheight
            cmp   ebx, eax
            jae   @@DrawFogFin

            mov   esi, psource      //esi = ddsd.lpSurface;
            mov   eax, lpitch
            mov   ebx, row
            imul  eax, ebx
            add   esi, eax

            mov   edi, fogmask      //edi = fogmask
            mov   eax, fogwidth
            mov   ebx, row
            imul  eax, ebx
            add   edi, eax

            mov   ecx, srclen
            mov   edx, pColorLevel

         @@NextByte:
            cmp   ecx, 0
            jbe   @@Finish

            movzx eax, byte ptr [edi]

            push edx
            mov dx, word ptr [esi]
            call MakeDarkPixels
            mov word ptr [esi], ax
            pop edx

            dec ecx
            add esi, 00000002
            inc edi
            jmp @@NextByte

         @@Finish:
            inc   row
            jmp   @@NextRow

         @@DrawFogFin:
            db $0F,$77               /// emms
            popad
    end;
  finally
    sSuf.UnLock();
  end;
end;

procedure DrawFog_MMX(sSuf: TDirectDrawSurface; fogmask: PByte; fogwidth: Integer);
var
  Row: Integer;
  ddsd: TDDSurfaceDesc;
  srclen, srcheight: Integer;
  lPitch: Integer;
  PSource, pColorLevel: PByte;
const
  i64Mask_8: Int64 = $00000000000000FF;

  i64Mask_r: Int64 = $000000000000F800;
  i64Mask_g: Int64 = $00000000000007E0;
  i64Mask_b: Int64 = $000000000000001F;
begin
  if sSuf.Width > SCREENWIDTH + 100 then
    Exit;
  case DarkLevel of
    1: pColorLevel := @HeavyDarkColorLevel;
    2: pColorLevel := @LightDarkColorLevel;
    3: pColorLevel := @DengunColorLevel;
  else
    Exit;
  end;

  try
    sSuf.Lock({TRect(nil^),} ddsd);
    srclen := _MIN(sSuf.Width, fogwidth);
    //pSrc := @src;
    srcheight := sSuf.Height;
    lPitch := ddsd.lPitch;
    PSource := ddsd.lpSurface;
    //mPtr := @pal_8to16;

    asm
            pushad
            mov   row, 0
         @@NextRow:
            mov   ebx, row
            mov   eax, srcheight
            cmp   ebx, eax
            jae   @@DrawFogFin

            mov   esi, psource      //esi = ddsd.lpSurface;
            mov   eax, lpitch
            mov   ebx, row
            imul  eax, ebx
            add   esi, eax

            mov   edi, fogmask      //edi = fogmask
            mov   eax, fogwidth
            mov   ebx, row
            imul  eax, ebx
            add   edi, eax

            mov   ecx, srclen
            mov   edx, pColorLevel

         @@NextByte:
            cmp   ecx, 0
            jbe   @@Finish

            movd  mm5, dword ptr [edi]
            pand  mm5, i64Mask_8
            pslld mm5, 08

            movd  mm0, dword ptr [esi]
            movq  mm2, mm0
            pand  mm2, i64Mask_r
            psrld mm2, $08
            paddd  mm2, mm5
            movd  eax, mm2

            movd  mm2, dword ptr [eax+edx]
            pand  mm2, i64Mask_8
            movq  mm3, mm0
            pand  mm3, i64Mask_g
            psrld mm3, $03
            paddd  mm3, mm5
            movd  eax, mm3

            movd  mm3, dword ptr [eax+edx]
            pand  mm3, i64Mask_8
            movq  mm4, mm0
            pand  mm4, i64Mask_b
            pslld mm4, $03
            paddd  mm4, mm5
            movd  eax, mm4

            movd  mm4, dword ptr [eax+edx]
            pand  mm4, i64Mask_8

            pslld mm2, $08
            pand  mm2, i64Mask_r
            pslld mm3, $03
            pand  mm3, i64Mask_g
            psrld mm4, $03
            pand  mm4, i64Mask_b
            por  mm2, mm3
            por  mm2, mm4
            movd  eax, mm2

            mov word ptr [esi], ax
            dec ecx
            add esi, 00000002
            inc edi
            jmp @@NextByte

         @@Finish:
            inc   row
            jmp   @@NextRow

         @@DrawFogFin:
            db $0F,$77               /// emms
            popad
    end;
  finally
    sSuf.UnLock();
  end;
end;

procedure MakeDark(sSuf: TDirectDrawSurface; DarkLevel: Integer);
var
  ddsd: TDDSurfaceDesc;
  srclen, destLen, srcheight: Integer;
  PSource: PByte;
  r, g, b: Byte;
begin
  //exit;
  if not DarkLevel in [1..30] then
    Exit;
{$IF MIR2EX}
  if (sSuf.Width <= 0) or (sSuf.Height <= 0) then
    Exit;

  //frmMain.DXDraw.BeginScene;
  sSuf.Lock(ddsd);
  try
    r := Round((30 - DarkLevel) * (32 / 30));
    g := Round((30 - DarkLevel) * (32 / 15));
    b := Round((30 - DarkLevel) * (32 / 30));

    srclen := sSuf.Width; //08
    srcheight := sSuf.Height; //10

    PSource := ddsd.lpSurface; //0C
    destLen := ddsd.lPitch - srclen * 2; //14
    asm
      push esi
      push edi
      push ebx
      xor edx, edx
      mov dl, r
      shl edx, $10
      xor ecx, ecx
      mov cl, g
      shl ecx, $08
      or edx, ecx
      xor ecx, ecx
      mov cl, b
      or edx, ecx
      movd  mm0, edx
      mov ecx, srclen
      mov esi, PSource
      mov edx, srcheight

@loop:
      movzx eax, word ptr [esi]
      mov ebx, eax
      mov edi, eax
      and ebx, $0000F800
      and edi, $000007E0
      and eax, $0000001F
      shl ebx, $05
      shl edi, $03
      or eax, ebx
      or eax, edi
      movd  mm1, eax
      psubusb  mm1, mm0
      movd  eax, mm1
      mov ebx, eax
      mov edi, eax
      and ebx, $001F0000
      and edi, $00003F00
      and eax, $0000001F
      shr ebx, $05
      shr edi, $03
      or eax, edi
      or eax, ebx
      mov word ptr [esi], ax
      add esi, $00000002
      dec ecx
      jne @loop
      mov ecx, srclen
      add esi, destLen
      dec edx
      jne @loop
      db $0F, $77;
      //asm db $0F, $77 end;
      pop ebx
      pop edi
      pop esi
    end;
  finally
    sSuf.UnLock();
  end;
  //frmMain.DXDraw.EndScene;
{$ELSE}
  if sSuf.Width > SCREENWIDTH + 100 then
    Exit;
  try
    sSuf.Lock({TRect(nil^),} ddsd);

    srclen := sSuf.Width;
    srcheight := sSuf.Height;

    pSrc := @src;
    pColorLevel := @HeavyDarkColorLevel;
    lPitch := ddsd.lPitch;
    PSource := ddsd.lpSurface;

    asm
            pushad
            mov   row, 0           //line
         @@NextRow:
            mov   ebx, row
            mov   eax, srcheight
            cmp   ebx, eax
            jae   @@DrawFogFin

            mov   esi, psource      //sptr
            mov   eax, lpitch
            mov   ebx, row
            imul  eax, ebx
            add   esi, eax

            mov   eax, srclen
            mov   scount, eax
         @@FogNext:
            mov   edx, pSrc     //pSrc = array[0..7]
            mov   ebx, scount
            cmp   ebx, 0
            jbe   @@Finish
            cmp   ebx, 8
            jb    @@FogSmall

            db $0F,$6F,$06           /// movq  mm0, [esi]       //8官捞飘 佬澜 sptr
            db $0F,$7F,$02           /// movq  [edx], mm0
            mov   count, 8

          @@LevelChange:
            mov   eax, darklevel
            imul  eax, 256
            movzx ebx, [edx].byte   //8官捞飘 弓澜栏肺 佬篮 单捞磐
            add   eax, ebx
            mov   ebx, pColorLevel
            mov   al, [ebx+eax].byte
            mov   [edx].byte, al

         @@Skip1:
            dec   count
            inc   edx
            inc   edi
            cmp   count, 0
            ja    @@LevelChange
            sub   edx, 8

            db $0F,$6F,$02           /// movq  mm0, [edx]
            db $0F,$7F,$06           /// movq  [esi], mm0
         @@Skip_8Byte:
            sub   scount, 8
            add   esi, 8
            jmp   @@FogNext

         @@FogSmall:
            mov   eax, darklevel
            imul  eax, 256
            movzx ebx, [edx].byte
            add   eax, ebx
            mov   ebx, pColorLevel
            mov   al, [ebx+eax].byte
            mov   [esi].byte, al

         @@Skip2:
            inc   edi
            inc   esi
            dec   scount
            jmp   @@FogNext

         @@Finish:
            inc   row
            jmp   @@NextRow

         @@DrawFogFin:
            db $0F,$77
            popad
    end;
  finally
    sSuf.UnLock({ddsd.lpSurface});
  end;
{$IFEND}
end;

procedure MMXBlt(sSuf, dSuf: TDirectDrawSurface);
var
  M, aHeight, aWidth, spitch, dpitch: Integer;
  sDdsd, dDdsd: TDDSurfaceDesc;
  sptr, dptr: PByte;
begin
  try
    sDdsd.dwSize := SizeOf(sDdsd);
    sSuf.Lock({TRect(nil^),} sDdsd);
    dDdsd.dwSize := SizeOf(dDdsd);
    dSuf.Lock({TRect(nil^),} dDdsd);
    aHeight := sSuf.Height - 1;
    aWidth := sSuf.Width - 1;
    spitch := sDdsd.lPitch;
    dpitch := dDdsd.lPitch;
    sptr := sDdsd.lpSurface; //esi
    dptr := dDdsd.lpSurface; //edi
    M := -1; //height
    asm
         pushad
       @@NextLine:
         inc   m
         mov   eax, m
         cmp   eax, aheight
         jae   @@End
         //sptr
         mov   esi, sptr
         mov   ebx, spitch
         imul  eax, ebx
         add   esi, eax
         //dptr
         mov   eax, m
         mov   edi, dptr
         mov   ebx, dpitch
         imul  eax, ebx
         add   edi, eax

         xor   eax, eax
       @@CopyNext:
         cmp   eax, awidth
         jae   @@NextLine

         db $0F,$6F,$04,$06       /// movq  mm0, [esi+eax]
         db $0F,$7F,$04,$07       /// movq  [edi+eax], mm0

         add   eax, 8
         jmp   @@CopyNext

       @@End:
         db $0F,$77               /// emms
         popad
    end;
  finally
    sSuf.UnLock({sddsd.lpSurface});
    dSuf.UnLock({dddsd.lpSurface});
  end;
end;

procedure DrawBlend(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; BlendMode: Integer);
begin
  if sSuf = nil then
    Exit;
  if BlendMode = 0 then
  begin
    DrawBlend_Mix(dSuf, X, Y, sSuf, 0, 0, sSuf.Width, sSuf.Height, BlendMode);
  end
  else
  begin
    if SSE_AVAILABLE then
      DrawBlend_Anti_MMX_16(dSuf, X, Y, sSuf, 0, 0, sSuf.Width, sSuf.Height, BlendMode)
    else //cpu...
      DrawBlend_Anti_MMX_08(dSuf, X, Y, sSuf, 0, 0, sSuf.Width, sSuf.Height, BlendMode);
  end;
end;

procedure DrawBlend_Mix(//BltAlphaFast_MMX
  dSuf: TDirectDrawSurface; //eax
  X, //edx
  Y: Integer; //ecx
  sSuf: TDirectDrawSurface; //[ebp+$1C]
  sSufLeft, //[ebp+$18]
  sSufTop, //[ebp+$14]
  sSufWidth, //[ebp+$10]
  sSufHeight, //[ebp+$0C]
  BlendMode: Integer); //[ebp+$08]
var
  SrcLeft, SrcTop: Integer;
  SrcWidth, SrcBottom: Integer;
  srclen, destLen: Integer;
  sDdsd, dDdsd: TDDSurfaceDesc;
  sptr, dptr: PByte;
  i, iRemainder, iWidth: Integer;
  //tick                      : LongWord;
  i64Mask: Int64;
begin
  if SSE_AVAILABLE then
  begin
    DrawBlend_Mix_MMX_16(dSuf, X, Y, sSuf, sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode);
    Exit;
  end;

  if (dSuf = nil) or (sSuf = nil) then
    Exit;

  if X >= dSuf.Width then
    Exit;
  if Y >= dSuf.Height then
    Exit;

  if X < 0 then
  begin
    SrcLeft := -X;
    SrcWidth := sSufWidth + X;
    X := 0;
  end
  else
  begin
    SrcLeft := sSufLeft;
    SrcWidth := sSufWidth;
  end;

  if Y < 0 then
  begin
    SrcTop := -Y;
    SrcBottom := sSufHeight;
    Y := 0;
  end
  else
  begin
    SrcTop := sSufTop;
    SrcBottom := sSufHeight;
  end;

  if SrcLeft + SrcWidth > sSuf.Width then
    SrcWidth := sSuf.Width - SrcLeft;

  if SrcTop + SrcBottom > sSuf.Height then
    SrcBottom := sSuf.Height - SrcTop;

  if X + SrcWidth > dSuf.Width then
    SrcWidth := dSuf.Width - X;

  if Y + SrcBottom > dSuf.Height then
    SrcBottom := dSuf.Height - Y;

  if (SrcWidth <= 0) or (SrcBottom <= 0) or (SrcLeft >= sSuf.Width) or (SrcTop >= sSuf.Height) then
    Exit;

  //if sSuf.Lock(sDdsd) and dSuf.Lock(dDdsd) then try
  sSuf.Lock(sDdsd);
  dSuf.Lock(dDdsd);
  try
    sptr := PByte(Integer(sDdsd.lpSurface) + sDdsd.lPitch * SrcTop + SrcLeft * 2);
    dptr := PByte(Integer(dDdsd.lpSurface) + dDdsd.lPitch * Y + X * 2);
    srclen := sDdsd.lPitch - SrcWidth * 2;
    destLen := dDdsd.lPitch - SrcWidth * 2;
    //tick := TimeGetTime;

    iRemainder := SrcWidth mod 4;
    iWidth := (SrcWidth - iRemainder) div 4;

    i64Mask := $F7DEF7DEF7DEF7DE;
    repeat
      // Reset the width.
      i := iWidth;
      asm
        push		ecx
        mov			ecx, i
        cmp			ecx, 0
        jz			@skip565

        push		edi
        push		esi
        mov			edi, dptr
        mov			esi, sptr
        pxor		mm4, mm4                           // Create black as the color key.
        movq		mm5, i64Mask                       // Load the auxiliary mask into an mmx register.

@do_blend565:
        cmp			dword ptr [esi], 0                 // Skip these four pixels if they are all black.
        jnz			@not_black565
        cmp			dword ptr [esi+4], 0
        jnz			@not_black565
        jmp			@next565

@not_black565:
        // Alpha blend four target and source pixels.

        movq		mm6, [edi]				// Load the original target pixel.
        movq		mm7, [esi]				// Load the original source pixel.
        movq		mm0, mm6				  // Copy the target pixel.
        movq		mm1, mm7			   	// Copy the source pixel.
        pand		mm0, mm5			   	// Clear each bottom-most target bit.
        pand		mm1, mm5				  // Clear each bottom-most source bit.
        psrlq		mm0, 1				   	// Divide the target by 2.
        pcmpeqw		mm7, mm4				// Create a color key mask.
        psrlq		mm1, 1				   	// Divide the source by 2.
        paddw		mm0, mm1				  // Add the target and the source.
        pand		mm6, mm7			   	// Keep old target where color key applies.
        pandn		mm7, mm0			   	// Keep new target where no color key applies.
        por			mm7, mm6			   	// Combine source and new target.
        movq		[edi], mm7				// Write back the new target.

@next565:
        add			edi, $08
        add			esi, $08

        dec			ecx
        jnz			@do_blend565

        mov			dptr, edi
        mov			sptr, esi
        pop			esi
        pop			edi

        emms

@skip565:
        pop			ecx
      end;

      for i := 0 to iRemainder - 1 do
      begin
        if (PWord(sptr)^ <> 0) then
          PWord(dptr)^ := (((PWord(dptr)^ and $F7DE) shr 1) + ((PWord(sptr)^ and $F7DE) shr 1));
        Inc(PWord(dptr));
        Inc(PWord(sptr));
      end;

      // Proceed to the next line.
      Inc(dptr, destLen);
      Inc(sptr, srclen);
      dec(SrcBottom);
    until (SrcBottom = 0);

    (*
        iWidth := SrcWidth div 4;           //(SrcWidth - iRemainder) div 4;
        iRemainder := SrcWidth mod 4;
        asm
          pushad
          mov edx, SrcBottom
          mov eax, $F7DEF7DE
          pxor  mm1, mm1
          movd  mm1, eax
          movq  mm3, mm1
          psllq mm1, $20
          por  mm1, mm3
          pxor  mm2, mm2
          mov esi, sptr
          mov edi, dptr
          mov ecx, iWidth

    @nextline:
          test ecx, ecx
          je @handleoddwidth

    @nextwidth:
          {movq  mm6, qword ptr [esi]
          movq  mm7, qword ptr [edi]
          movq  mm5, mm6
          packsswb  mm5, mm2
          movd  eax, mm5
          test eax, eax
          je @procnextpixels}

          cmp			dword ptr [esi], 0                 // Skip these four pixels if they are all black.
       jnz			@notblack
       cmp			dword ptr [esi+4], 0
       jnz			@notblack
       jmp			@procnextpixels

    @notblack:
          movq  mm6, qword ptr [esi]
          movq  mm7, qword ptr [edi]

          movq  mm3, mm6
          pcmpeqw  mm6, mm2
          movq  mm4, mm7
          pand  mm4, mm6
          por  mm3, mm4
          pand  mm3, mm1
          psrlw mm3, $01
          pand  mm7, mm1
          psrlw mm7, $01
          paddw  mm3, mm7
          movq  qword ptr [edi], mm3

    @procnextpixels:
          add esi, $0008
          add edi, $0008
          dec ecx
          jne @nextwidth

    @handleoddwidth:
          mov eax, iRemainder
          test eax, eax
          je @procnextline
          mov ecx, eax

    @nextoddwidth:
          xor eax, eax
          mov ax, word ptr [esi]
          test eax, eax
          je @procnextpixel

          and eax, $F7DE
          shr eax, $1
          mov bx, word ptr [edi]
          and ebx, $F7DE
          shr ebx, $1
          add ebx, eax
          mov word ptr [edi], bx

    @procnextpixel:
          add esi, $0002
          add edi, $0002
          dec ecx
          jne @nextoddwidth

    @procnextline:
          mov ecx, iWidth
          add esi, srclen
          add edi, destLen
          dec edx
          jne @nextline

          db $0F,$77
          popad
        end; *)

        {iRemainder := SrcWidth mod 4;
        iWidth := SrcWidth - iRemainder;
        asm
                pushad
                mov edx, SrcBottom
                mov eax, $F7DEF7DE
                pxor  mm1, mm1
                movd  mm1, eax
                movq  mm3, mm1
                psllq mm1, $20
                por  mm1, mm3
                pxor  mm2, mm2
                mov esi, sptr
                mov edi, dptr
                mov ecx, iWidth

    @Loop:
                mov eax, SrcWidth
                cmp eax, $00000004
                jl @SmallBlock

    @CopySource:
                movq  mm6, qword ptr [esi]
                movq  mm7, qword ptr [edi]
                movq  mm5, mm6
                packsswb  mm5, mm2
                movd  eax, mm5
                test eax, eax
                je @ContinueCopySource

                movq  mm3, mm6
                pcmpeqw  mm6, mm2
                movq  mm4, mm7
                pand  mm4, mm6
                por  mm3, mm4
                pand  mm3, mm1
                psrlw mm3, $01
                pand  mm7, mm1
                psrlw mm7, $01
                paddw  mm3, mm7
                movq  qword ptr [edi], mm3

    @ContinueCopySource:
                add esi, $00000008
                add edi, $00000008
                sub ecx, $00000004
                jne @CopySource

    @SmallBlock:
                mov eax, iRemainder
                test eax, eax
                je @ExitCopySource
                mov ecx, eax

    @LoopSmall:
                xor eax, eax
                mov ax, word ptr [esi]
                test eax, eax
                je @ContinueSmallCopy
                and eax, $0000F7DE
                shr eax, $1
                mov bx, word ptr [edi]
                and ebx, $0000F7DE
                shr ebx, $1
                add ebx, eax
                mov word ptr [edi], bx

    @ContinueSmallCopy:
                add esi, $00000002
                add edi, $00000002
                dec ecx
                jne @LoopSmall

    @ExitCopySource:
                mov ecx, iWidth
                add esi, srclen
                add edi, destLen
                dec edx
                jne @Loop
                db $0F,$77
                popad
        end;}

        //DScreen.AddChatBoardString(IntToStr(TimeGetTime - tick), clWhite, clBlack);
  finally
    sSuf.UnLock();
    dSuf.UnLock();
  end;
end;

procedure DrawBlend_Mix_Level_MMX(//BltAlphaFast
  dSuf: TDirectDrawSurface; //eax
  X, //edx
  Y: Integer; //ecx
  sSuf: TDirectDrawSurface; //[ebp+$1C]
  sSufLeft, //[ebp+$18]
  sSufTop, //[ebp+$14]
  sSufWidth, //[ebp+$10]
  sSufHeight, //[ebp+$0C]
  BlendMode: Integer); //[ebp+$08]

var
  SrcLeft, SrcTop: Integer;
  SrcWidth, SrcBottom: Integer;
  srclen, destLen: Integer;
  sDdsd, dDdsd: TDDSurfaceDesc;
  sptr, dptr, pmix: PByte;
  cr, cg, cb, lw, hw, bRGB: Byte;
  M, n, l, i, j, k, sbit, dbit: Integer;
  pal1, pal2: Pointer;
  bOddWidth: Boolean;
  tick: LongWord;

  sTemp, dTemp: Word;
  red, green, blue: Byte;
  sb, db, sg, dg, sr, dr: Byte;

  //Alpha64                   : Int64;
begin
  if (dSuf = nil) or (sSuf = nil) then
    Exit;

  if BlendMode >= 256 then
  begin
    dSuf.Draw(X, Y, sSuf.ClientRect, sSuf, True);
    Exit;
  end
  else if BlendMode <= 0 then
    Exit;

  if X >= dSuf.Width then
    Exit;
  if Y >= dSuf.Height then
    Exit;

  if X < 0 then
  begin
    SrcLeft := -X;
    SrcWidth := sSufWidth + X;
    X := 0;
  end
  else
  begin
    SrcLeft := sSufLeft;
    SrcWidth := sSufWidth;
  end;

  if Y < 0 then
  begin
    SrcTop := -Y;
    SrcBottom := sSufHeight;
    Y := 0;
  end
  else
  begin
    SrcTop := sSufTop;
    SrcBottom := sSufHeight;
  end;

  if SrcLeft + SrcWidth > sSuf.Width then
    SrcWidth := sSuf.Width - SrcLeft;

  if SrcTop + SrcBottom > sSuf.Height then
    SrcBottom := sSuf.Height - SrcTop;

  if X + SrcWidth > dSuf.Width then
    SrcWidth := dSuf.Width - X;

  if Y + SrcBottom > dSuf.Height then
    SrcBottom := dSuf.Height - Y;

  if (SrcWidth <= 0) or (SrcBottom <= 0) or (SrcLeft >= sSuf.Width) or (SrcTop >= sSuf.Height) then
    Exit;

  //if sSuf.Lock(sDdsd) and dSuf.Lock(dDdsd) then try
  sSuf.Lock(sDdsd);
  dSuf.Lock(dDdsd);
  try
    sptr := PByte(Integer(sDdsd.lpSurface) + sDdsd.lPitch * SrcTop + SrcLeft * 2);
    dptr := PByte(Integer(dDdsd.lpSurface) + dDdsd.lPitch * Y + X * 2);
    srclen := sDdsd.lPitch - SrcWidth * 2;
    destLen := dDdsd.lPitch - SrcWidth * 2;
    //tick := TimeGetTime;

    asm
      movd       mm5,   BlendMode
      punpcklwd  mm5,   mm5
      punpckldq  mm5,   mm5
    end;

    k := SrcBottom;
    if k > 0 then
    begin
      repeat
        n := SrcWidth div 4;
        l := SrcWidth mod 4;
        asm
          push esi
          push edi
          mov edi, dptr
          mov esi, sptr
          mov ecx, n
          cmp ecx, 00000000
          je @next_2

@loop_8:
          cmp dword ptr [esi], 00000000
          jne @start_8
          cmp dword ptr [esi+$04], 00000000
          je @nextline_8

@start_8:
          movq  mm6, qword ptr [edi]
          movq  mm7, qword ptr [esi]
          movq mm0, mm6
          psrlw mm0, $0B
          movq mm1, mm7
          psrlw mm1, $0B
          psubw mm1, mm0
          pmullw mm1, mm5
          psraw mm1, $08
          paddw mm1, mm0
          psllw mm1, $0B
          movq mm2, mm6
          psllw mm2, $05
          psrlw mm2, $0A
          movq mm3, mm7
          psllw mm3, $05
          psrlw mm3, $0A
          psubw mm3, mm2
          pmullw mm3, mm5
          psraw mm3, $08
          paddw mm3, mm2
          psllw mm3, $05
          movq mm4, mm6
          psllw mm4, $0B
          psrlw mm4, $0B
          movq mm2, mm7
          psllw mm2, $0B
          psrlw mm2, $0B
          psubw mm2, mm4
          pmullw mm2, mm5
          psraw mm2, $08
          paddw mm2, mm4
          por mm1, mm3
          por mm1, mm2
          pxor mm0, mm0
          pcmpeqw mm0, mm7
          pand mm6, mm0
          pandn mm0, mm1
          por mm6, mm0
          movq qword ptr [edi], mm6

@nextline_8:
          add edi, $08
          add esi, $08
          dec ecx
          jne @loop_8
@next_2:
          mov dptr, edi
          mov sptr, esi
          emms
          pop edi
          pop esi
        end;

        if l > 0 then
        begin
          repeat
            sTemp := PWord(sptr)^; // 源点颜色值,16位--WORD类型,(lpSour和lpDest都是BYTE*)
            if (sTemp <> 0) then
            begin // 不是colorkey
              dTemp := PWord(dptr)^; // 目标点
              sb := sTemp and $1F; // 蓝色分量
              db := dTemp and $1F;
              sg := (sTemp shr 5) and $3F; // 绿色分量
              dg := (dTemp shr 5) and $3F;
              sr := (sTemp shr 11) and $1F; // 红色分量
              dr := (dTemp shr 11) and $1F;

              blue := (BlendMode * (sb - db) shr 8) + db; // 按照改进公式2运算三个分量
              green := (BlendMode * (sg - dg) shr 8) + dg;
              red := (BlendMode * (sr - dr) shr 8) + dr;

              PWord(dptr)^ := blue or (green shl 5) or (red shl 11); // 565格式生成结果并赋给目标点
            end;
            Inc(PWord(dptr));
            Inc(PWord(sptr));

            dec(l);
          until (l = 0);
        end;

        Inc(dptr, destLen);
        Inc(sptr, srclen);

        dec(k);
      until (k = 0);
    end;

  finally
    //DScreen.AddChatBoardString(IntToStr(TimeGetTime - tick), clWhite, clBlack);

    sSuf.UnLock();
    dSuf.UnLock();
  end;
end;

procedure DrawBlend_Mix_Level_SSE(//BltAlphaFast
  dSuf: TDirectDrawSurface; //eax
  X, //edx
  Y: Integer; //ecx
  sSuf: TDirectDrawSurface; //[ebp+$1C]
  sSufLeft, //[ebp+$18]
  sSufTop, //[ebp+$14]
  sSufWidth, //[ebp+$10]
  sSufHeight, //[ebp+$0C]
  BlendMode: Integer); //[ebp+$08]

var
  SrcLeft, SrcTop: Integer;
  SrcWidth, SrcBottom: Integer;
  srclen, destLen: Integer;
  sDdsd, dDdsd: TDDSurfaceDesc;
  sptr, dptr, pmix: PByte;
  cr, cg, cb, lw, hw, bRGB: Byte;
  M, n, l, i, j, k, sbit, dbit: Integer;
  pal1, pal2: Pointer;
  bOddWidth: Boolean;
  tick: LongWord;

  sTemp, dTemp: Word;
  red, green, blue: Byte;
  sb, db, sg, dg, sr, dr: Byte;

  Alpha64: Int64;
begin
  if (dSuf = nil) or (sSuf = nil) then
    Exit;

  if BlendMode >= 256 then
  begin
    dSuf.Draw(X, Y, sSuf.ClientRect, sSuf, True);
    Exit;
  end
  else if BlendMode <= 0 then
    Exit;

  if X >= dSuf.Width then
    Exit;
  if Y >= dSuf.Height then
    Exit;

  if X < 0 then
  begin
    SrcLeft := -X;
    SrcWidth := sSufWidth + X;
    X := 0;
  end
  else
  begin
    SrcLeft := sSufLeft;
    SrcWidth := sSufWidth;
  end;

  if Y < 0 then
  begin
    SrcTop := -Y;
    SrcBottom := sSufHeight;
    Y := 0;
  end
  else
  begin
    SrcTop := sSufTop;
    SrcBottom := sSufHeight;
  end;

  if SrcLeft + SrcWidth > sSuf.Width then
    SrcWidth := sSuf.Width - SrcLeft;

  if SrcTop + SrcBottom > sSuf.Height then
    SrcBottom := sSuf.Height - SrcTop;

  if X + SrcWidth > dSuf.Width then
    SrcWidth := dSuf.Width - X;

  if Y + SrcBottom > dSuf.Height then
    SrcBottom := dSuf.Height - Y;

  if (SrcWidth <= 0) or (SrcBottom <= 0) or (SrcLeft >= sSuf.Width) or (SrcTop >= sSuf.Height) then
    Exit;

  //if sSuf.Lock(sDdsd) and dSuf.Lock(dDdsd) then try
  sSuf.Lock(sDdsd);
  dSuf.Lock(dDdsd);
  try
    sptr := PByte(Integer(sDdsd.lpSurface) + sDdsd.lPitch * SrcTop + SrcLeft * 2);
    dptr := PByte(Integer(dDdsd.lpSurface) + dDdsd.lPitch * Y + X * 2);
    srclen := sDdsd.lPitch - SrcWidth * 2;
    destLen := dDdsd.lPitch - SrcWidth * 2;
    //tick := TimeGetTime;

    Alpha64 := BlendMode;

    asm
      movq       xmm4,   qword ptr [Alpha64]         // ALPHA值放入mm2
      punpcklwd  xmm4,   xmm4          // mm5 -> 0000 0000 00aa 00aa
      punpckldq  xmm4,   xmm4          // mm5 - 00aa 00aa 00aa 00aa,生成alpha的64位扩展
      movdqa     xmm5,   xmm4
      pslldq     xmm5,   $08          // mm5 - 00aa 00aa 00aa 00aa 0000 0000 0000 0000     8x8=64位
      por        xmm5,   xmm4         // mm4 - 0000 0000 0000 0000 00aa 00aa 00aa 00aa

      movd       mm5,   BlendMode
      punpcklwd  mm5,   mm5
      punpckldq  mm5,   mm5
    end;

    k := SrcBottom;
    if k > 0 then
    begin
      repeat
        M := SrcWidth div 8;
        n := (SrcWidth mod 8) div 4;
        l := SrcWidth mod 4;
        asm
          push esi
          push edi
          mov edi, dptr
          mov esi, sptr
          mov ecx, M
          cmp ecx, 00000000
          je @next_8
@loop_16:
          cmp dword ptr [esi], 00000000
          jne @start_16
          cmp dword ptr [esi+$04], 00000000
          jne @start_16
          cmp dword ptr [esi+$08], 00000000
          jne @start_16
          cmp dword ptr [esi+$0C], 00000000
          je @nextline_16

@start_16:
          //movdqu xmm6, oword ptr [edi]
          db $F3
          db $0F
          db $6F
          db $37

          // movdqu xmm7, oword ptr [esi]
          db $F3
          db $0F
          db $6F
          db $3E

          //movdqa xmm0, xmm6
          db $66
          db $0F
          db $6F
          db $C6

          psrlw xmm0, $0B
          movdqa xmm1, xmm7
          psrlw xmm1, $0B
          psubw xmm1, xmm0
          pmullw xmm1, xmm5
          psraw xmm1, $08
          paddw xmm1, xmm0
          psllw xmm1, $0B
          movdqa xmm2, xmm6
          psllw xmm2, $05
          psrlw xmm2, $0A
          movdqa xmm3, xmm7
          psllw xmm3, $05
          psrlw xmm3, $0A
          psubw xmm3, xmm2
          pmullw xmm3, xmm5
          psraw xmm3, $08
          paddw xmm3, xmm2
          psllw xmm3, $05
          movdqa xmm4, xmm6
          psllw xmm4, $0B
          psrlw xmm4, $0B
          movdqa xmm2, xmm7
          psllw xmm2, $0B
          psrlw xmm2, $0B
          psubw xmm2, xmm4
          pmullw xmm2, xmm5
          psraw xmm2, $08
          paddw xmm2, xmm4
          por xmm1, xmm3
          por xmm1, xmm2
          pxor xmm0, xmm0
          pcmpeqw xmm0, xmm7
          pand xmm6, xmm0
          pandn xmm0, xmm1
          por xmm6, xmm0

          //movdqu oword ptr [edi], xmm6
          db $F3
          db $0F
          db $7F
          db $37

@nextline_16:
          add edi, $10
          add esi, $10
          dec ecx
          jne @loop_16

@next_8:
          mov ecx, n
          cmp ecx, 00000000
          je @next_2

@loop_8:
          cmp dword ptr [esi], 00000000
          jne @start_8
          cmp dword ptr [esi+$04], 00000000
          je @nextline_8

@start_8:
          movq  mm6, qword ptr [edi]
          movq  mm7, qword ptr [esi]
          movq mm0, mm6
          psrlw mm0, $0B
          movq mm1, mm7
          psrlw mm1, $0B
          psubw mm1, mm0
          pmullw mm1, mm5
          psraw mm1, $08
          paddw mm1, mm0
          psllw mm1, $0B
          movq mm2, mm6
          psllw mm2, $05
          psrlw mm2, $0A
          movq mm3, mm7
          psllw mm3, $05
          psrlw mm3, $0A
          psubw mm3, mm2
          pmullw mm3, mm5
          psraw mm3, $08
          paddw mm3, mm2
          psllw mm3, $05
          movq mm4, mm6
          psllw mm4, $0B
          psrlw mm4, $0B
          movq mm2, mm7
          psllw mm2, $0B
          psrlw mm2, $0B
          psubw mm2, mm4
          pmullw mm2, mm5
          psraw mm2, $08
          paddw mm2, mm4
          por mm1, mm3
          por mm1, mm2
          pxor mm0, mm0
          pcmpeqw mm0, mm7
          pand mm6, mm0
          pandn mm0, mm1
          por mm6, mm0
          movq qword ptr [edi], mm6

@nextline_8:
          add edi, $08
          add esi, $08
          dec ecx
          jne @loop_8
@next_2:
          mov dptr, edi
          mov sptr, esi
          emms
          pop edi
          pop esi
        end;

        if l > 0 then
        begin
          repeat
            sTemp := PWord(sptr)^; // 源点颜色值,16位--WORD类型,(lpSour和lpDest都是BYTE*)
            if (sTemp <> 0) then
            begin // 不是colorkey
              dTemp := PWord(dptr)^; // 目标点
              sb := sTemp and $1F; // 蓝色分量
              db := dTemp and $1F;
              sg := (sTemp shr 5) and $3F; // 绿色分量
              dg := (dTemp shr 5) and $3F;
              sr := (sTemp shr 11) and $1F; // 红色分量
              dr := (dTemp shr 11) and $1F;

              blue := (BlendMode * (sb - db) shr 8) + db; // 按照改进公式2运算三个分量
              green := (BlendMode * (sg - dg) shr 8) + dg;
              red := (BlendMode * (sr - dr) shr 8) + dr;

              PWord(dptr)^ := blue or (green shl 5) or (red shl 11); // 565格式生成结果并赋给目标点
            end;
            Inc(PWord(dptr));
            Inc(PWord(sptr));

            dec(l);
          until (l = 0);
        end;

        Inc(dptr, destLen);
        Inc(sptr, srclen);

        dec(k);
      until (k = 0);
    end;

  finally
    //DScreen.AddChatBoardString(IntToStr(TimeGetTime - tick), clWhite, clBlack);
    sSuf.UnLock();
    dSuf.UnLock();
  end;
end;

{procedure DrawBlend_Mix_fast(           //BltAlphaFast
  dSuf: TDirectDrawSurface;             //eax
  X,                                    //edx
  Y: Integer;                           //ecx
  sSuf: TDirectDrawSurface;             //[ebp+$1C]
  sSufLeft,                             //[ebp+$18]
  sSufTop,                              //[ebp+$14]
  sSufWidth,                            //[ebp+$10]
  sSufHeight,                           //[ebp+$0C]
  BlendMode: Integer);                  //[ebp+$08]
var
  SrcLeft, SrcTop           : Integer;
  SrcWidth, SrcBottom       : Integer;
  srclen, destLen           : Integer;
  sDdsd, dDdsd              : TDDSurfaceDesc;
  sptr, dptr, pmix          : PByte;
  cr, cg, cb, lw, hw, bRGB  : Byte;
  n, M, l, i, sbit, dbit    : Integer;
  pal1, pal2                : Pointer;
  bOddWidth                 : Boolean;
  //tick                      : LongWord;
begin
  if (dSuf = nil) or (sSuf = nil) then Exit;

  if X >= dSuf.Width then Exit;
  if Y >= dSuf.Height then Exit;

  if X < 0 then begin
    SrcLeft := -X;
    SrcWidth := sSufWidth + X;
    X := 0;
  end else begin
    SrcLeft := sSufLeft;
    SrcWidth := sSufWidth;
  end;

  if Y < 0 then begin
    SrcTop := -Y;
    SrcBottom := sSufHeight;
    Y := 0;
  end else begin
    SrcTop := sSufTop;
    SrcBottom := sSufHeight;
  end;

  if SrcLeft + SrcWidth > sSuf.Width then
    SrcWidth := sSuf.Width - SrcLeft;

  if SrcTop + SrcBottom > sSuf.Height then
    SrcBottom := sSuf.Height - SrcTop;

  if X + SrcWidth > dSuf.Width then
    SrcWidth := dSuf.Width - X;

  if Y + SrcBottom > dSuf.Height then
    SrcBottom := dSuf.Height - Y;

  if (SrcWidth <= 0) or (SrcBottom <= 0) or (SrcLeft >= sSuf.Width) or (SrcTop >= sSuf.Height) then Exit;

  //if sSuf.Lock(sDdsd) and dSuf.Lock(dDdsd) then try
  sSuf.Lock(sDdsd);
  dSuf.Lock(dDdsd);
  try
    sptr := PByte(Integer(sDdsd.lpSurface) + sDdsd.lPitch * SrcTop + SrcLeft * 2);
    dptr := PByte(Integer(dDdsd.lpSurface) + dDdsd.lPitch * Y + X * 2);
    srclen := sDdsd.lPitch - SrcWidth * 2;
    destLen := dDdsd.lPitch - SrcWidth * 2;

    // If the width is odd ...
    if (SrcWidth and $01) = 1 then begin
      bOddWidth := True;
      SrcWidth := (SrcWidth - 1) div 2;
    end else begin
      bOddWidth := False;
      SrcWidth := SrcWidth div 2;
    end;

    //tick := timeGetTime;
    for i := 0 to SrcBottom - 1 do begin
      for n := 0 to SrcWidth - 1 do begin
        sbit := PInteger(sptr)^;        //ecx
        dbit := PInteger(dptr)^;
        if sbit <> 0 then begin
          // If the first source is black ...
          if sbit shr 16 = 0 then sbit := sbit or (dbit and $FFFF0000);

          // If the second source is black ...
          if sbit and $FFFF = 0 then sbit := sbit or (dbit and $FFFF);

          // Calculate the destination pixels.
          //PInteger(dptr)^ := ((sbit and $F7DEF7DE) shr 1) + ((dbit and $F7DEF7DE) shr 1);

          //混合后的颜色=( ( D-S ) * Alpha ) >> 5 + S
          PInteger(dptr)^ := Round((dbit - sbit) * 0.5) shr 5 + sbit;

          //PInteger(dptr)^ := ((sbit and $F7DEF7DE) shr 1) + ((dbit and $F7DEF7DE) shr 1);
        end;
        Inc(PInteger(sptr));
        Inc(PInteger(dptr));
      end;
      if bOddWidth then begin
        if PWord(sptr)^ <> 0 then begin
          // Write the destination pixel.
          PWord(dptr)^ := ((PWord(sptr)^ and $F7DE) shr 1) + ((PWord(dptr)^ and $F7DE) shr 1);
        end;
        Inc(PWord(sptr));
        Inc(PWord(dptr));
      end;
      Inc(sptr, srclen);
      Inc(dptr, destLen);
    end;
  finally
    sSuf.UnLock();
    dSuf.UnLock();
  end;
end;}

procedure DrawBlend_Mix_MMX_16(
  dSuf: TDirectDrawSurface; //eax
  X, //edx
  Y: Integer; //ecx
  sSuf: TDirectDrawSurface; //[ebp+$1C]
  sSufLeft, //[ebp+$18]
  sSufTop, //[ebp+$14]
  sSufWidth, //[ebp+$10]
  sSufHeight, //[ebp+$0C]
  BlendMode: Integer); //[ebp+$08]
var
  SrcLeft, SrcTop: Integer;
  SrcWidth: Integer;
  SrcBottom: Integer;
  srclen, destLen: Integer;
  sDdsd, dDdsd: TDDSurfaceDesc;
  sptr, dptr: PByte;
  n, M, l: Integer;
begin
  if (dSuf = nil) or (sSuf = nil) then
    Exit;

  if X >= dSuf.Width then
    Exit;
  if Y >= dSuf.Height then
    Exit;

  if X < 0 then
  begin
    SrcLeft := -X;
    SrcWidth := sSufWidth + X;
    X := 0;
  end
  else
  begin
    SrcLeft := sSufLeft;
    SrcWidth := sSufWidth;
  end;

  if Y < 0 then
  begin
    SrcTop := -Y;
    SrcBottom := sSufHeight + Y; //
    Y := 0;
  end
  else
  begin
    SrcTop := sSufTop;
    SrcBottom := sSufHeight;
  end;

  if SrcLeft + SrcWidth > sSuf.Width then
    SrcWidth := sSuf.Width - SrcLeft;

  if SrcTop + SrcBottom > sSuf.Height then
    SrcBottom := sSuf.Height - SrcTop;

  if X + SrcWidth > dSuf.Width then
    SrcWidth := dSuf.Width - X;

  if Y + SrcBottom > dSuf.Height then
    SrcBottom := dSuf.Height - Y;

  if (SrcWidth <= 0) or (SrcBottom <= 0) or (SrcLeft >= sSuf.Width) or (SrcTop >= sSuf.Height) then
    Exit;

  //if sSuf.Lock(sDdsd) and dSuf.Lock(dDdsd) then try
  sSuf.Lock(sDdsd);
  dSuf.Lock(dDdsd);
  try
    sptr := PByte(Integer(sDdsd.lpSurface) + sDdsd.lPitch * SrcTop + SrcLeft * 2); //18
    dptr := PByte(Integer(dDdsd.lpSurface) + dDdsd.lPitch * Y + X * 2); //14
    srclen := sDdsd.lPitch - SrcWidth * 2; //28
    destLen := dDdsd.lPitch - SrcWidth * 2; //2c

    l := SrcWidth div 8;
    n := (SrcWidth mod 8) div 4;
    M := SrcWidth mod 4;

    asm
      pushad
      mov ebx, SrcBottom
      cmp  ebx, 0
      je @exit

      movq xmm7, qword ptr Mix_i64Mask
      movq xmm6, qword ptr Mix_i64Mask
      pslldq xmm7, $08
      por xmm7, xmm6
      movq mm7, qword ptr Mix_i64Mask

      mov   edi, dptr
      mov   esi, sptr

@loop:
      mov ecx, l
      cmp ecx, 00000000
      je @cp8

@loop16:
      //movdqu xmm1, oword ptr [edi]
      db $F3
      db $0F
      db $6F
      db $0F

      //movdqu xmm2, oword ptr [esi]
      db $F3
      db $0F
      db $6F
      db $16

      // movdqa xmm3, xmm1
      db $66
      db $0F
      db $6F
      db $D9

      // movdqa xmm4, xmm2
      db $66
      db $0F
      db $6F
      db $E2

      pand xmm3, xmm7
      psrlw xmm3, 01
      pand xmm4, xmm7
      psrlw xmm4, 01
      paddw xmm3, xmm4
      pxor xmm0, xmm0
      pcmpeqw xmm0, xmm2
      pand xmm1, xmm0
      pandn xmm0, xmm3
      por xmm1, xmm0

      // movdqu oword ptr [edi], xmm1
      db $F3
      db $0F
      db $7F
      db $0F

      add edi, $0010
      add esi, $0010
      dec ecx
      jne @loop16

@cp8:
      mov ecx, n
      cmp ecx, 00000000
      je @cp2

@loop8:
      movq  mm1, qword ptr [edi]        // Load the original target pixel.
      movq  mm2, qword ptr [esi]        // Load the original source pixel.
      movq  mm3, mm1                    // Copy the target pixel.
      movq  mm4, mm2                    // Copy the source pixel.
      pand  mm3, mm7                    // Clear each bottom-most target bit.
      psrlw mm3, 01                     // Divide the target by 2.
      pand  mm4, mm7                    // Clear each bottom-most source bit.
      psrlw mm4, 01                     // Divide the source by 2.
      paddw  mm3, mm4                   // Add the target and the source.
      pxor  mm0, mm0                    // Create black as the color key.
      pcmpeqw  mm0, mm2                 // Create a color key mask.
      pand  mm1, mm0
      pandn  mm0, mm3
      por  mm1, mm0
      movq  qword ptr [edi], mm1
      add edi, $00000008
      add esi, $00000008
      dec ecx
      jne @loop8

@cp2:
      mov ecx, m
      cmp ecx, 00000000
      je @con

@loop2:
      xor eax, eax
      mov ax, word ptr [esi]
      test eax, eax
      je @con2
      and eax, $0F7DE
      shr eax, 1
      mov dx, word ptr [edi]
      and edx, $0F7DE
      shr edx, 1
      add edx, eax
      mov word ptr [edi], dx

@con2:
      add esi, 00000002
      add edi, 00000002
      dec ecx
      jne @loop2

@con:
      add esi, srclen
      add edi, destLen
      dec ebx
      jne @loop

@exit:
      emms
      popad
    end;
  finally
    sSuf.UnLock();
    dSuf.UnLock();
  end;
end;

{procedure DrawBlend_Anti_08(
  dSuf: TDirectDrawSurface;             //eax
  X,                                    //edx
  Y: Integer;                           //ecx
  sSuf: TDirectDrawSurface;             //[ebp+$1C]
  sSufLeft,                             //[ebp+$18]
  sSufTop,                              //[ebp+$14]
  sSufWidth,                            //[ebp+$10]
  sSufHeight,                           //[ebp+$0C]
  BlendMode: Integer);                  //[ebp+$08]
var
  SrcLeft, SrcTop           : Integer;
  SrcWidth, SrcBottom       : Integer;
  srclen, destLen           : Integer;
  sDdsd, dDdsd              : TDDSurfaceDesc;
  sptr, dptr, pmix          : PByte;
  cr, cg, cb, lw, hw, bRGB  : Byte;
  n, M, l, i, bit           : Integer;
  pal1, pal2                : Pointer;
begin
  if (dSuf = nil) or (sSuf = nil) then Exit;

  if X >= dSuf.Width then Exit;
  if Y >= dSuf.Height then Exit;

  if X < 0 then begin
    SrcLeft := -X;
    SrcWidth := sSufWidth + X;
    X := 0;
  end else begin
    SrcLeft := sSufLeft;
    SrcWidth := sSufWidth;
  end;

  if Y < 0 then begin
    SrcTop := -Y;
    SrcBottom := sSufHeight;
    Y := 0;
  end else begin
    SrcTop := sSufTop;
    SrcBottom := sSufHeight;
  end;

  if SrcLeft + SrcWidth > sSuf.Width then
    SrcWidth := sSuf.Width - SrcLeft;

  if SrcTop + SrcBottom > sSuf.Height then
    SrcBottom := sSuf.Height - SrcTop;

  if X + SrcWidth > dSuf.Width then
    SrcWidth := dSuf.Width - X;

  if Y + SrcBottom > dSuf.Height then
    SrcBottom := dSuf.Height - Y;

  if (SrcWidth <= 0) or (SrcBottom <= 0) or (SrcLeft >= sSuf.Width) or (SrcTop >= sSuf.Height) then Exit;

  if sSuf.Lock(sDdsd) and dSuf.Lock(dDdsd) then try
    //try
      //sSuf.Lock(sDdsd);
      //dSuf.Lock(dDdsd);

    sptr := PByte(Integer(sDdsd.lpSurface) + sDdsd.lPitch * SrcTop + SrcLeft);
    dptr := PByte(Integer(dDdsd.lpSurface) + dDdsd.lPitch * Y + X * 2);
    srclen := sDdsd.lPitch - SrcWidth;
    destLen := dDdsd.lPitch - SrcWidth * 2;

    asm
      push esi
      push edi
      push ebx
      mov ebx, SrcBottom
      mov ecx, SrcWidth
      mov edx, g_pBlendTable
      mov esi, sptr
      mov edi, dptr

@loop:
      //movzx eax, byte ptr [esi]
      //test eax, eax
      cmp byte ptr [esi], 00
      je @next
      movzx eax, byte ptr [esi]
      shl eax, $10
      mov ax, word ptr [edi]
      mov ax, word ptr [edx+2*eax]
      mov word ptr [edi], ax
@next:
      inc esi
      add edi, 0002
      dec ecx
      jne @loop
      dec ebx
      je @exit
      mov ecx, SrcWidth
      add esi, srclen
      add edi, destLen
      jmp @loop

@exit:
      pop ebx
      pop edi
      pop esi
    end;
  finally
    sSuf.UnLock();
    dSuf.UnLock();
  end;
end; }

{procedure DrawBlend_Anti_16_NOR(
  dSuf: TDirectDrawSurface;             //eax
  X,                                    //edx
  Y: Integer;                           //ecx
  sSuf: TDirectDrawSurface;             //[ebp+$1C]
  sSufLeft,                             //[ebp+$18]
  sSufTop,                              //[ebp+$14]
  sSufWidth,                            //[ebp+$10]
  sSufHeight,                           //[ebp+$0C]
  BlendMode: Integer);                  //[ebp+$08]
var
  SrcLeft, SrcTop           : Integer;
  SrcWidth, SrcBottom       : Integer;
  srclen, destLen           : Integer;
  sDdsd, dDdsd              : TDDSurfaceDesc;
  sptr, dptr, pmix          : PByte;
  cr, cg, cb, lw, hw, bRGB  : Byte;
  iWidth, iRemainder, n, M, l, i, bit: Integer;
  pal1, pal2                : Pointer;
begin
  if (dSuf = nil) or (sSuf = nil) then Exit;

  if X >= dSuf.Width then Exit;
  if Y >= dSuf.Height then Exit;

  if X < 0 then begin
    SrcLeft := -X;
    SrcWidth := sSufWidth + X;
    X := 0;
  end else begin
    SrcLeft := sSufLeft;
    SrcWidth := sSufWidth;
  end;

  if Y < 0 then begin
    SrcTop := -Y;
    SrcBottom := sSufHeight;
    Y := 0;
  end else begin
    SrcTop := sSufTop;
    SrcBottom := sSufHeight;
  end;

  if SrcLeft + SrcWidth > sSuf.Width then
    SrcWidth := sSuf.Width - SrcLeft;

  if SrcTop + SrcBottom > sSuf.Height then
    SrcBottom := sSuf.Height - SrcTop;

  if X + SrcWidth > dSuf.Width then
    SrcWidth := dSuf.Width - X;

  if Y + SrcBottom > dSuf.Height then
    SrcBottom := dSuf.Height - Y;

  if (SrcWidth <= 0) or (SrcBottom <= 0) or (SrcLeft >= sSuf.Width) or (SrcTop >= sSuf.Height) then Exit;

  //if sSuf.Lock(sDdsd) and dSuf.Lock(dDdsd) then try
  sSuf.Lock(sDdsd);
  dSuf.Lock(dDdsd);
  try
    sptr := PByte(Integer(sDdsd.lpSurface) + sDdsd.lPitch * SrcTop + SrcLeft * 2);
    dptr := PByte(Integer(dDdsd.lpSurface) + dDdsd.lPitch * Y + X * 2);
    srclen := sDdsd.lPitch - SrcWidth * 2;
    destLen := dDdsd.lPitch - SrcWidth * 2;
    asm
                push esi
                push edi
                push ebx
                mov ecx, SrcWidth
                mov edx, g_BlendTab1

@loop:
                mov esi, sptr
                movzx esi, word ptr [esi]
                test esi, esi
                je @continue

                push ecx
                mov edi, dptr
                movzx edi, word ptr [edi]
                mov ecx, esi
                and ecx, $0000F800
                shr ecx, $04
                mov eax, edi
                shr eax, $0A
                or ecx, eax
                mov bx, word ptr [edx+2*ecx]
                mov ecx, esi
                and ecx, $000007E0
                shl ecx, 1
                mov eax, edi
                and eax, $000007E0
                shr eax, $05
                or ecx, eax
                mov ax, word ptr [edx+2*ecx+$00002000]
                or bx, ax
                mov ecx, esi
                and ecx, $0000001F
                shl ecx, $07
                mov eax, edi
                and eax, $0000001F
                shl eax, 1
                or ecx, eax
                mov ax, word ptr [edx+2*ecx+$00004000]
                or bx, ax
                mov eax, dword ptr [ebp-$0C]
                mov word ptr [eax], bx
                pop ecx

@continue:
                add sptr, $00000002
                add dptr, $00000002
                dec ecx
                jne @loop
                dec SrcBottom
                je @exit
                mov ecx, SrcWidth
                mov eax, srclen
                add sptr, eax
                mov eax, destlen
                add dptr, eax
                jmp @loop

@exit:
                pop ebx
                pop edi
                pop esi
    end;
  finally
    sSuf.UnLock();
    dSuf.UnLock();
  end;
end;}

procedure DrawBlend_Anti_MMX_08(
  dSuf: TDirectDrawSurface; //eax
  X, //edx
  Y: Integer; //ecx
  sSuf: TDirectDrawSurface; //[ebp+$1C]
  sSufLeft, //[ebp+$18]
  sSufTop, //[ebp+$14]
  sSufWidth, //[ebp+$10]
  sSufHeight, //[ebp+$0C]
  BlendMode: Integer); //[ebp+$08]
var
  SrcLeft, SrcTop: Integer;
  SrcWidth, SrcBottom: Integer;
  srclen, destLen: Integer;
  sDdsd, dDdsd: TDDSurfaceDesc;
  sptr, dptr: PByte;
  iWidth, iRemainder: Integer;
begin
  if (dSuf = nil) or (sSuf = nil) then  Exit;

  if X >= dSuf.Width then  Exit;

  if Y >= dSuf.Height then  Exit;

  if X < 0 then
  begin
    SrcLeft := -X;
    SrcWidth := sSufWidth + X;
    X := 0;
  end
  else
  begin
    SrcLeft := sSufLeft;
    SrcWidth := sSufWidth;
  end;

  if Y < 0 then
  begin
    SrcTop := -Y;
    SrcBottom := sSufHeight;
    Y := 0;
  end
  else
  begin
    SrcTop := sSufTop;
    SrcBottom := sSufHeight;
  end;

  if SrcLeft + SrcWidth > sSuf.Width then
    SrcWidth := sSuf.Width - SrcLeft;

  if SrcTop + SrcBottom > sSuf.Height then
    SrcBottom := sSuf.Height - SrcTop;

  if X + SrcWidth > dSuf.Width then
    SrcWidth := dSuf.Width - X;

  if Y + SrcBottom > dSuf.Height then
    SrcBottom := dSuf.Height - Y;

  if (SrcWidth <= 0) or (SrcBottom <= 0) or (SrcLeft >= sSuf.Width) or (SrcTop >= sSuf.Height) then
    Exit;

  //if sSuf.Lock(sDdsd) and dSuf.Lock(dDdsd) then try
  sSuf.Lock(sDdsd);
  dSuf.Lock(dDdsd);
  try
    sptr := PByte(Integer(sDdsd.lpSurface) + sDdsd.lPitch * SrcTop + SrcLeft * 2);
    dptr := PByte(Integer(dDdsd.lpSurface) + dDdsd.lPitch * Y + X * 2);
    srclen := sDdsd.lPitch - SrcWidth * 2;
    destLen := dDdsd.lPitch - SrcWidth * 2;

    iWidth := SrcWidth div 4;
    iRemainder := SrcWidth mod 4;
    //asm version
    asm
      pushad
      mov edx, SrcBottom
      mov ecx, iWidth
      mov esi, sptr
      mov edi, dptr
      movq  mm6, Mask64_1
      movq  mm7, Mask64_2

@doblend:
      mov ecx, iWidth
      test ecx, ecx
      je @ProcRemainder

@loop8:
      movq  mm0, qword ptr [esi]
      movq  mm1, qword ptr [edi]

      movq  mm5, Mask64_3                  //: Int64 = $F800F800F800F800;
      movq  mm2, mm0
      pand  mm2, mm5
      psrlw mm2, $08
      movq  mm3, mm1
      pand  mm3, mm5
      psrlw mm3, $08
      movq  mm4, Mask64_4
      psubw  mm4, mm2
      pmullw  mm4, mm3
      psrlw mm4, $08
      paddusb  mm2, mm4
      psllw mm2, $08
      pand  mm2, mm5
      movq  mm3, mm0
      pand  mm3, mm6
      psrlw mm3, $03
      movq  mm4, mm1
      pand  mm4, mm6
      psrlw mm4, $03
      movq  mm5, Mask64_4
      psubw  mm5, mm3
      pmullw  mm5, mm4
      psrlw mm5, $08
      paddusb  mm3, mm5
      psllw mm3, $03
      pand  mm3, mm6
      por  mm2, mm3
      pand  mm0, mm7
      psllw mm0, $03
      pand  mm1, mm7
      psllw mm1, $03
      movq  mm3, Mask64_4
      psubw  mm3, mm0
      pmullw  mm3, mm1
      psrlw mm3, $08
      paddusb  mm0, mm3
      psrlw mm0, $03
      pand  mm0, mm7
      por  mm2, mm0

      movq  qword ptr [edi], mm2
      add esi, $0008
      add edi, $0008
      dec ecx
      jne @loop8

@ProcRemainder:
      mov ecx, iRemainder
      test ecx, ecx
      je @ProcNextLine
@loop2:
      movzx eax, word ptr [esi]
      test eax, eax
      je @next2
      movd  mm0, eax
      movzx eax, word ptr [edi]
      movd  mm1, eax

      movq  mm5, Mask64_3                  //: Int64 = $F800F800F800F800;
      movq  mm2, mm0
      pand  mm2, mm5
      psrlw mm2, $08
      movq  mm3, mm1
      pand  mm3, mm5
      psrlw mm3, $08
      movq  mm4, Mask64_4
      psubw  mm4, mm2
      pmullw  mm4, mm3
      psrlw mm4, $08
      paddusb  mm2, mm4
      psllw mm2, $08
      pand  mm2, mm5
      movq  mm3, mm0
      pand  mm3, mm6
      psrlw mm3, $03
      movq  mm4, mm1
      pand  mm4, mm6
      psrlw mm4, $03
      movq  mm5, Mask64_4
      psubw  mm5, mm3
      pmullw  mm5, mm4
      psrlw mm5, $08
      paddusb  mm3, mm5
      psllw mm3, $03
      pand  mm3, mm6
      por  mm2, mm3
      pand  mm0, mm7
      psllw mm0, $03
      pand  mm1, mm7
      psllw mm1, $03
      movq  mm3, Mask64_4
      psubw  mm3, mm0
      pmullw  mm3, mm1
      psrlw mm3, $08
      paddusb  mm0, mm3
      psrlw mm0, $03
      pand  mm0, mm7
      por  mm2, mm0
      movd  eax, mm2
      mov word ptr [edi], ax
@next2:
      add esi, $0002
      add edi, $0002
      dec ecx
      jne @loop2

@ProcNextLine:
      dec edx
      je @exit
      add esi, srclen
      add edi, destlen
      jmp @doblend

@exit:
      emms
      popad
    end;
  finally
    sSuf.UnLock();
    dSuf.UnLock();
  end;
end;

procedure DrawBlend_Anti_MMX_16(
  dSuf: TDirectDrawSurface; //eax
  X, //edx
  Y: Integer; //ecx
  sSuf: TDirectDrawSurface; //[ebp+$1C]
  sSufLeft, //[ebp+$18]
  sSufTop, //[ebp+$14]
  sSufWidth, //[ebp+$10]
  sSufHeight, //[ebp+$0C]
  BlendMode: Integer); //[ebp+$08]
var
  SrcLeft, SrcTop: Integer;
  SrcWidth, SrcBottom: Integer;
  srclen, destLen: Integer;
  sDdsd, dDdsd: TDDSurfaceDesc;
  sptr, dptr: PByte;
  n, M, l: Integer;
begin
  if (dSuf = nil) or (sSuf = nil) then Exit;

  if X >= dSuf.Width then Exit;

  if Y >= dSuf.Height then Exit;

  if X < 0 then
  begin
    SrcLeft := -X;
    SrcWidth := sSufWidth + X;
    X := 0;
  end
  else
  begin
    SrcLeft := sSufLeft;
    SrcWidth := sSufWidth;
  end;

  if Y < 0 then
  begin
    SrcTop := -Y;
    SrcBottom := sSufHeight;
    Y := 0;
  end
  else
  begin
    SrcTop := sSufTop;
    SrcBottom := sSufHeight;
  end;

  if SrcLeft + SrcWidth > sSuf.Width then
    SrcWidth := sSuf.Width - SrcLeft;
  if SrcTop + SrcBottom > sSuf.Height then
    SrcBottom := sSuf.Height - SrcTop;
  if X + SrcWidth > dSuf.Width then
    SrcWidth := dSuf.Width - X;
  if Y + SrcBottom > dSuf.Height then
    SrcBottom := dSuf.Height - Y;

  if (SrcWidth <= 0) or (SrcBottom <= 0) or (SrcLeft >= sSuf.Width) or (SrcTop >= sSuf.Height) then
    Exit;

  //if sSuf.Lock(sDdsd) and dSuf.Lock(dDdsd) then try
  sSuf.Lock(sDdsd);
  dSuf.Lock(dDdsd);
  try
    sptr := PByte(Integer(sDdsd.lpSurface) + sDdsd.lPitch * SrcTop + SrcLeft * 2);
    dptr := PByte(Integer(dDdsd.lpSurface) + dDdsd.lPitch * Y + X * 2);
    srclen := sDdsd.lPitch - SrcWidth * 2;
    destLen := dDdsd.lPitch - SrcWidth * 2;
    n := SrcWidth div 8;
    M := (SrcWidth mod 8) div 4;
    l := SrcWidth mod 4;
    asm
          pushad
          xor ecx, ecx

          // movdqu xmm4, oword ptr g_alphaArr

          lea ecx, g_alphaArr
          //movdqu xmm4, oword ptr [ecx]
          db $F3
          db $0F
          db $6F
          db $21

          mov esi, sptr
          mov edi, dptr
          mov edx, SrcBottom
@Loop:
          mov ecx, n
          test ecx, ecx
          je @MidBlock
@LoopLarge:
          // movdqu xmm6, oword ptr [esi]
          db $F3
          db $0F
          db $6F
          db $36

          // movdqa xmm7, xmm6
          db $66
          db $0F
          db $6F
          db $FE

          pxor xmm3, xmm3
          packsswb xmm7, xmm3
          packsswb xmm7, xmm3
          movd eax, xmm7
          test eax, eax
          je @NextLargeBlock

          // movdqu xmm7, oword ptr [edi]
          db $F3
          db $0F
          db $6F
          db $3F

          {$I Render_Anti_SSE.inc}
          // movdqu oword ptr [edi], xmm2
          db $F3
          db $0F
          db $7F
          db $17
          
@NextLargeBlock:
          add esi, $10
          add edi, $10
          dec ecx
          jne @LoopLarge

@MidBlock:
          mov ecx, m
          test ecx, ecx
          je @SmallBlock
@LoopMid:
          pxor xmm6, xmm6
          movq xmm6, qword ptr [esi]
          movq xmm7, xmm6
          pxor xmm3, xmm3
          packsswb xmm7, xmm3
          packsswb xmm7, xmm3
          movd eax, xmm7
          test eax, eax
          je @NextMidBlock
          movq xmm7, qword ptr [edi]
          {$I Render_Anti_SSE.inc}
          movq [edi], xmm2
@NextMidBlock:
          add esi, $8
          add edi, $8
          dec ecx
          jne @LoopMid

@SmallBlock:
          mov ecx, L
          test ecx, ecx
          je @Next
@LoopSmall:
          movzx eax, word ptr [esi]
          test eax, eax
          je @NextSmallBlock

          movd xmm6, eax
          movzx eax, word ptr [edi]
          movd xmm7, eax
          {$I Render_Anti_SSE.inc}
          movd eax, xmm2
          mov [edi], ax
@NextSmallBlock:
          add esi, $2
          add edi, $2
          dec ecx
          jne @LoopSmall
@Next:
          dec edx
          je @Exit
          add esi, srclen
          add edi, destlen
          jmp @Loop
@Exit:
          emms
          popad
    end;
  finally
    sSuf.UnLock();
    dSuf.UnLock();
  end;
end;

procedure DrawBlend_RealColor(
  dSuf: TDirectDrawSurface; //eax
  X, //edx
  Y: Integer; //ecx
  sSuf: TDirectDrawSurface; //[ebp+$1C]
  sSufLeft, //[ebp+$18]
  sSufTop, //[ebp+$14]
  sSufWidth, //[ebp+$10]
  sSufHeight, //[ebp+$0C]
  BlendMode: Integer); //[ebp+$08]
var
  SrcLeft, SrcTop: Integer;
  SrcWidth, SrcBottom: Integer;
  srclen, destLen: Integer;
  sDdsd, dDdsd: TDDSurfaceDesc;
  sptr, dptr, pmix: PByte;
begin
  if X >= dSuf.Width then
    Exit;
  if Y >= dSuf.Height then
    Exit;

  if X < 0 then
  begin
    SrcLeft := -X;
    SrcWidth := sSufWidth + X;
    X := 0;
  end
  else
  begin
    SrcLeft := sSufLeft;
    SrcWidth := sSufWidth;
  end;

  if Y < 0 then
  begin
    SrcTop := -Y;
    SrcBottom := sSufHeight;
    Y := 0;
  end
  else
  begin
    SrcTop := sSufTop;
    SrcBottom := sSufHeight;
  end;

  if SrcLeft + SrcWidth > sSuf.Width then
    SrcWidth := sSuf.Width - SrcLeft;

  if SrcTop + SrcBottom > sSuf.Height then
    SrcBottom := sSuf.Height - SrcTop;

  if X + SrcWidth > dSuf.Width then
    SrcWidth := dSuf.Width - X;

  if Y + SrcBottom > dSuf.Height then
    SrcBottom := dSuf.Height - Y;

  if (SrcWidth <= 0) or (SrcBottom <= 0) or (SrcLeft >= sSuf.Width) or (SrcTop >= sSuf.Height) then
    Exit;

  pmix := @Color256real[0, 0];

  //if sSuf.Lock(sDdsd) and dSuf.Lock(dDdsd) then try
  sSuf.Lock(sDdsd);
  dSuf.Lock(dDdsd);
  try
    sptr := PByte(Integer(sDdsd.lpSurface) + sDdsd.lPitch * SrcTop + SrcLeft);
    dptr := PByte(Integer(dDdsd.lpSurface) + dDdsd.lPitch * Y + X);
    srclen := sDdsd.lPitch - SrcWidth;
    destLen := dDdsd.lPitch - SrcWidth;

    asm
      push esi
      push edi
      push ebx
      mov ebx, SrcBottom
      mov ecx, SrcWidth
      mov edx, pmix
      mov esi, sptr
      mov edi, dptr
      xor eax, eax
@loop:
      cmp byte ptr [esi], 00
      je @next
      mov ah, byte ptr [esi]
      mov al, byte ptr [edi]
      mov al, byte ptr [eax+edx]
      mov byte ptr [edi], al
@next:
      inc esi
      inc edi
      dec ecx
      jnz @loop
      dec ebx
      je @exit
      mov ecx, SrcWidth
      add esi, srclen
      add edi, destLen
      jmp @loop
@exit:
      pop ebx
      pop edi
      pop esi
    end;
  finally
    sSuf.UnLock();
    dSuf.UnLock();
  end;
end;

procedure SpriteCopy(DestX, DestY: Integer; SourX, SourY: Integer; Size: TPoint; Sour, Dest: TDirectDrawSurface);
const
  TRANSPARENCY_VALUE = 0;
var
  sDdsd, dDdsd: TDDSurfaceDesc;
  pSour, PDest, pmask: PByte;
  Transparency: array[1..8] of Byte;
begin
  FillChar(Transparency, 8, TRANSPARENCY_VALUE);

  sDdsd.dwSize := SizeOf(TDDSurfaceDesc);
  Sour.Lock({TRect(nil^),} sDdsd);
  dDdsd.dwSize := SizeOf(TDDSurfaceDesc);
  Dest.Lock({TRect(nil^),} dDdsd);

  pSour := PByte(DWord(sDdsd.lpSurface) + Byte(SourY * sDdsd.lPitch + SourX));
  PDest := PByte(DWord(dDdsd.lpSurface) + Byte(DestY * dDdsd.lPitch + DestX));
  pmask := Pointer(@Transparency);

  asm
         pushad
         push  esi
         push  edi

         mov   esi, pMask
         db $0F,$6F,$26       /// movq  mm4, [esi]
                              //  mm4
         mov   esi, pSour
         mov   edi, pDest

         mov   ecx, Size.Y

   @@LOOP_Y:

         push  ecx

         mov   ecx, Size.X
         shr   ecx, 3         // 悼矫俊 8俺狼 痢阑 楷魂窍骨肺


   @@LOOP_X:

         db $0F,$6F,$07       /// movq  mm0, [edi]
                              //  mm0 篮 Destination
         db $0F,$6F,$0E       /// movq  mm1, [esi]
                              //  mm1 篮 Source
         db $0F,$6F,$D1       /// movq  mm2, mm1
                              //  mm2 俊 Source 单捞磐甫 汗荤
         db $0F,$74,$D4       /// pcmpeqb mm2, mm4
                              //  mm2 俊 捧疙祸俊 蝶弗 付胶农甫 积己
         db $0F,$6F,$DA       /// movq  mm3, mm2
                              //  mm3 俊 付胶农甫 窍唱 歹 汗荤
         db $0F,$DF,$D1       /// pandn mm2, mm1
                              //  Source 胶橇扼捞飘 何盒父阑 巢辫
         db $0F,$DB,$D8       /// pand  mm3, mm0
                              //  Destination 狼 盎脚瞪 何盒父 力芭
         db $0F,$EB,$D3       /// por   mm2, mm3
                              //  Source 客 Destination 阑 搬钦
         db $0F,$7F,$17       /// movq  [edi], mm2
                              //  Destination 俊 搬苞甫 靖

         add   esi, 8
                              //  茄锅俊 8 bytes 甫 悼矫俊 贸府沁栏骨肺
         add   edi, 8

         loop  @@LOOP_X

         add   esi, sddsd.lPitch
         sub   esi, Size.X
         add   edi, dddsd.lPitch
         sub   edi, Size.X

         pop   ecx
         loop  @@LOOP_Y

         db $0F,$77              /// emms

         pop   edi
         pop   esi
         pushad

  end;

  Sour.UnLock({SourDesc.lpSurface});
  Dest.UnLock({DestDesc.lpSurface});

end;

procedure DrawEffect(X, Y, Width, Height: Integer; sSuf: TDirectDrawSurface; eff: TColorEffect);
var
  srclen: Integer;
  sDdsd: TDDSurfaceDesc;
  sptr, peff: PByte;
begin
  if eff = ceNone then Exit;
  peff := nil;
{$IF not MIR2EX}
  case eff of
    ceGrayScale: peff := @GrayScaleLevel;
    ceBright: peff := @BrightColorLevel;
    ceDark: peff := @DarkColorLevel;
    ceBlack: peff := @BlackColorLevel;
    ceWhite: peff := @WhiteColorLevel;
    ceRed: peff := @RedishColorLevel;
    ceGreen: peff := @GreenColorLevel;
    ceBlue: peff := @BlueColorLevel;
    ceYellow: peff := @YellowColorLevel;
    ceFuchsia: peff := @FuchsiaColorLevel;
  end;
  if peff = nil then
    Exit;

  //if sSuf.Lock(sDdsd) then try
  sSuf.Lock(sDdsd);
  try
    srclen := Width;
    for i := 0 to Height - 1 do
    begin
      sptr := PByte(Integer(sDdsd.lpSurface) + (Y + i) * sDdsd.lPitch + X);
      asm
        pushad
        mov   scount, 0
        mov   esi, sptr
        lea   edi, source

     @@CopySource:
        mov   ebx, scount
        cmp   ebx, srclen
        jae   @@EndSourceCopy
        db $0F,$6F,$04,$1E       // movq  mm0, [esi+ebx]
        db $0F,$7F,$07           // movq  [edi], mm0
        mov   ebx, 0

     @@Loop8:
        cmp   ebx, 8
        jz    @@EndLoop8
        movzx eax, [edi+ebx].byte
        mov   edx, peff
        movzx eax, [edx+eax].byte
        mov   [edi+ebx], al
        inc   ebx
        jmp   @@Loop8

     @@EndLoop8:
        mov   ebx, scount
        db $0F,$6F,$07           // movq  mm0, [edi]
        db $0F,$7F,$04,$1E       // movq  [esi+ebx], mm0
        add   edi, 8
        add   scount, 8
        jmp   @@CopySource

     @@EndSourceCopy:
        db $0F,$77        // emms
        popad
      end;
    end;
  finally
    sSuf.UnLock();
  end;
{$ELSE}
  case eff of
    ceGrayScale: peff := PByte(g_pGrayScaleLevel_16);
    ceBright: peff := PByte(g_pBrightColorLevel_16);
    ceRed: peff := PByte(g_pRedishColorLevel_16);
    ceGreen: peff := PByte(g_pGreenColorLevel_16);
    ceBlue: peff := PByte(g_pBlueColorLevel_16);
    ceYellow: peff := PByte(g_pYellowColorLevel_16);
    ceFuchsia: peff := PByte(g_pFuchsiaColorLevel_16);

    ceDark: peff := PByte(g_pDarkColorLevel_16);
    ceBlack: peff := PByte(g_pBlackColorLevel_16);
    ceWihte: peff := PByte(g_pWhiteColorLevel_16);
    cepurple: peff := PByte(g_pHDarkColorLevel_16);

  end;
  if peff = nil then
    Exit;
  if X < 0 then
  begin
    Inc(Width, X);
    X := 0;
  end;
  if Y < 0 then
  begin
    Inc(Height, Y);
    Y := 0;
  end;
  if sSuf.Width < Width then
    Width := sSuf.Width - X;
  if sSuf.Height < Height then
    Height := sSuf.Height - Y;
  if (Width <= 0) or (Height <= 0) then
    Exit;

  sSuf.Lock(sDdsd);
  try
    sptr := PByte(Integer(sDdsd.lpSurface) + Y * sDdsd.lPitch + X * 2);
    srclen := sDdsd.lPitch - Width * 2;
    asm
        push esi
        push edi
        push ebx
        mov edx, Height
        mov ecx, Width
        mov esi, sptr
        mov edi, peff
        mov ebx, srclen

@loop:
        movzx eax, word ptr [esi]
        mov ax, word ptr [edi+2*eax]
        mov word ptr [esi], ax
        add esi, $0002
        dec ecx
        jne @loop
        add esi, ebx
        mov ecx, Width
        dec edx
        jne @loop
        pop ebx
        pop edi
        pop esi
    end;
  finally
    sSuf.UnLock();
  end;
{$IFEND MIR2EX}
end;

procedure DrawLine(Surface: TDirectDrawSurface);
var
  nX, nY: Integer;
begin
  for nX := 0 to Surface.Width - 1 do
    Surface.Pixels[nX, 0] := 255;
  for nY := 0 to Surface.Height - 1 do
    Surface.Pixels[0, nY] := 255;
end;

procedure DrawRectLine(Surface: TDirectDrawSurface; Rect: TRect);
var
  nX, nY: Integer;
begin
  for nX := Rect.Left to Rect.Right - 1 do
    Surface.Pixels[nX, 0] := 255;
  for nY := 0 to Surface.Height - 1 do
    Surface.Pixels[0, nY] := 255;
end;

procedure BuildRealRGB(ctable: TRGBQuads);
var
  MinDif, ColDif: Integer;
  MatchColor: Byte;
  pal0, pal1, pal2: TRGBQuad;
  i, j, n: Integer;
begin
  for i := 0 to 255 do
  begin
    pal0 := ctable[i];
    for j := 0 to 255 do
    begin
      pal1 := ctable[j];
      pal1.rgbRed := pal0.rgbRed;
      pal1.rgbGreen := pal0.rgbGreen;
      pal1.rgbBlue := pal0.rgbBlue;
      MinDif := 1;
      MatchColor := 0;
      for n := 0 to 255 do
      begin
        pal2 := ctable[n];
        ColDif := abs(pal2.rgbRed - pal1.rgbRed) +
          abs(pal2.rgbGreen - pal1.rgbGreen) +
          abs(pal2.rgbBlue - pal1.rgbBlue);
        if ColDif < MinDif then
        begin
          MinDif := ColDif;
          MatchColor := n;
        end;
      end;
      Color256real[i, j] := MatchColor;
    end;
  end;
  //@Color256realEx := @Color256real;
  //C16BitPalette
  //Move(Color256real, Color256realEx, SizeOf(Color256realEx));
end;

const
  LOAD_PAL_STREAM = True;

{procedure BuildAntiTable_16bit();
var
  bt                        : Byte;
  n04, n08, n0c             : Integer;
  p                         : Pointer;
begin
  GetMem(g_pBlendTable, $02000000);
  bt := 0;
  p := @g_WisPal;                       //1024
  asm
    pushad
@loop:
    mov eax, p
    mov eax, dword ptr [eax]

    mov esi, eax
    and esi, $00FF0000
    shr esi, $10

    mov edx, eax
    and edx, $0000FF00
    shr edx, $08
    mov n08, edx

    and eax, $000000FF
    mov n0c, eax
    xor eax, eax

@loop2:
    mov edx, eax
    and dx, $F800
    movzx edx, dx
    shr edx, $08
    mov ecx, eax
    and cx, $07E0
    movzx ecx, cx
    shr ecx, $03                             :0047AB4D A1080F5900              mov eax, dword ptr [00590F08]

    mov ebx, eax
    and bx, $001F
    movzx ebx, bx
    shl ebx, $03
    mov edi, $00000100
    sub edi, esi
    imul edi, edx
    shr edi, $08
    add edi, esi
    mov edx, edi
    cmp edx, $000000FF
    jbe @next
    mov edx, $000000FF

@next:
    mov edi, $00000100
    sub edi, n08
    imul edi, ecx
    shr edi, $08
    add edi, n08
    mov ecx, edi
    cmp ecx, $000000FF
    jbe @next2
    mov ecx, $000000FF

@next2:
    mov edi, $00000100
    sub edi, n0c
    imul edi, ebx
    shr edi, $08
    add edi, n0c
    mov ebx, edi
    cmp ebx, $000000FF
    jbe @next3
    mov ebx, $000000FF

@next3:
    shl edx, $08
    and dx, $F800
    shl ecx, $03
    and cx, $07E0
    or dx, cx
    shr ebx, $03
    and bx, $001F
    or dx, bx
    xor ecx, ecx
    mov cl, bt
    shl ecx, $0E
    mov ebx, g_pBlendTable
    //mov ebx, dword ptr [ebx]
    lea ecx, dword ptr [ebx+8*ecx]
    movzx ebx, ax
    mov word ptr [ecx+2*ebx], dx
    inc eax
    test ax, ax
    jne @loop2

    inc bt
    add p, $00000004
    cmp bt, 00
    jne @loop
    popad
  end;

end;}

procedure BuildPal_8to16(Pal: TRGBQuads);
var
  i: Integer;
begin
  for i := Low(Byte) to High(Byte) do
  begin
    pal_8to16[i] :=
      (((Integer(Pal[i]) and $00FF0000) shr $08) and $F800) or
      (((Integer(Pal[i]) and $0000FF00) shr $05) and $07E0) or
      (((Integer(Pal[i]) and $000000FF) shr $03) and $001F);
  end;
end;

(*
procedure LoadC16BitPalette();
var
  i, n, n04, n08, n0c       : Integer;
  p                         : Pointer;
  rs                        : TResourceStream;
  ms                        : TMemoryStream;
  fhandle                   : Integer;
const
  flname                    = '.\npal.dat';
begin
  try
{$I '..\Common\Macros\VMPBM.inc'}
    rs := TResourceStream.Create(Hinstance, 'ResData', 'npal');
    if rs <> nil then begin
      ms := TMemoryStream.Create;
      ms.LoadFromStream(rs);
      ms.Seek(0, 0);
      //ms.ReadBuffer(g_pC16BitPalette^, SizeOf(TC16BitPalette));
      //ms.ReadBuffer(pal_8to16, SizeOf(pal_8to16));    //1020
      //ms.ReadBuffer(g_BlendTab1^, SizeOf(Ttab1));    //1020
      //ms.ReadBuffer(g_WisPal, SizeOf(TRGBQuad) * 256);
      ms.Free;
      rs.Free;
    end;
    //BuildAntiTable_16bit();
{$I '..\Common\Macros\VMPE.inc'}
  except
  end;
end; *)

initialization
  New(g_pGrayScaleLevel_16);
  New(g_pBrightColorLevel_16);
  New(g_pRedishColorLevel_16);
  New(g_pGreenColorLevel_16);
  New(g_pBlueColorLevel_16);
  New(g_pYellowColorLevel_16);
  New(g_pFuchsiaColorLevel_16);
  New(g_pDarkColorLevel_16);
  New(g_pBlackColorLevel_16);
  New(g_pWhiteColorLevel_16);
  New(g_pHDarkColorLevel_16);
{$IF VIEWFOG}
  New(g_HeavyDarkColorLevel_16);
  New(g_LightDarkColorLevel_16);
  New(g_DengunColorLevel_16);
{$IFEND VIEWFOG}
  //New(g_pC16BitPalette);
  //New(g_BlendTab1);

finalization
  Dispose(g_pGrayScaleLevel_16);
  Dispose(g_pBrightColorLevel_16);
  Dispose(g_pRedishColorLevel_16);
  Dispose(g_pGreenColorLevel_16);
  Dispose(g_pBlueColorLevel_16);
  Dispose(g_pYellowColorLevel_16);
  Dispose(g_pFuchsiaColorLevel_16);
  Dispose(g_pDarkColorLevel_16);
  Dispose(g_pBlackColorLevel_16);
  Dispose(g_pWhiteColorLevel_16);
  Dispose(g_pHDarkColorLevel_16);
{$IF VIEWFOG}
  Dispose(g_HeavyDarkColorLevel_16);
  Dispose(g_LightDarkColorLevel_16);
  Dispose(g_DengunColorLevel_16);
{$IFEND VIEWFOG}

  //Dispose(g_pC16BitPalette);
  //Dispose(g_BlendTab1);

end.
