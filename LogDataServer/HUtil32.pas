unit HUtil32;

//============================================
// Latest Update date : 1998 1
// Add/Update Function and procedure :
// 		CaptureString
//       Str_PCopy          	(4/29)
//			Str_PCopyEx			 	(5/2)
//			memset					(6/3)
//       SpliteBitmap         (9/3)
//       ArrestString         (10/27)  {name changed}
//       IsStringNumber       (98'1/1)
//			GetDirList				(98'12/9)
//       GetFileDate          (98'12/9)
//       CatchString          (99'2/4)
//       DivString            (99'2/4)
//       DivTailString        (99'2/4)
//       SPos                 (99'2/9)
//============================================

interface

uses
  Classes, SysUtils, StrUtils, WinTypes, WinProcs, Graphics, Messages, Dialogs;

type
  Str4096 = array[0..4096] of Char;
  Str256 = array[0..256] of Char;
  TyNameTable = record
    Name: string;
    varl: LongInt;
  end;

  TLRect = record
    Left, Top, Right, Bottom: LongInt;
  end;

const
  MAXDEFCOLOR = 16;
  ColorNames: array[1..MAXDEFCOLOR] of TyNameTable =
  (
    (Name: 'BLACK'; varl: clBlack),
    (Name: 'BROWN'; varl: clMaroon),
    (Name: 'MARGENTA'; varl: clFuchsia),
    (Name: 'GREEN'; varl: clGreen),
    (Name: 'LTGREEN'; varl: clOlive),
    (Name: 'BLUE'; varl: clNavy),
    (Name: 'LTBLUE'; varl: clBlue),
    (Name: 'PURPLE'; varl: clPurple),
    (Name: 'CYAN'; varl: clTeal),
    (Name: 'LTCYAN'; varl: clAqua),
    (Name: 'GRAY'; varl: clGray),
    (Name: 'LTGRAY'; varl: clSilver),
    (Name: 'YELLOW'; varl: clYellow),
    (Name: 'LIME'; varl: clLime),
    (Name: 'WHITE'; varl: clWhite),
    (Name: 'RED'; varl: clRed)
    );

  MAXLISTMARKER = 3;
  LiMarkerNames: array[1..MAXLISTMARKER] of TyNameTable =
  (
    (Name: 'DISC'; varl: 0),
    (Name: 'CIRCLE'; varl: 1),
    (Name: 'SQUARE'; varl: 2)
    );

  MAXPREDEFINE = 3;
  PreDefineNames: array[1..MAXPREDEFINE] of TyNameTable =
  (
    (Name: 'LEFT'; varl: 0),
    (Name: 'RIGHT'; varl: 1),
    (Name: 'CENTER'; varl: 2)
    );

function CountGarbage(paper: TCanvas; Src: PChar; TargWidth: LongInt): Integer;
{garbage}
{[ArrestString]
    Result = Remain string,
    RsltStr = captured string
}
function ArrestString(Source, SearchAfter, ArrestBefore: string;
  const DropTags: array of string; var RsltStr: string): string;
{*}
function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var
  ArrestStr: string): string;
function CaptureString(Source: string; var rdstr: string): string;
procedure ClearWindow(aCanvas: TCanvas; aLeft, aTop, aRight, aBottom: LongInt;
  aColor: TColor);
function CombineDirFile(SrcDir, TargName: string): string;
{*}
function CompareLStr(Src, targ: string; compn: Integer): Boolean;
function CompareBackLStr(Src, targ: string; compn: Integer): Boolean;
function CompareBuffer(p1, p2: Pbyte; Len: Integer): Boolean;
function CreateMask(Src: PChar; TargPos: Integer): string;
procedure DrawTileImage(Canv: TCanvas; Rect: TRect; TileImage: TBitmap);
procedure DrawingGhost(Rc: TRect);
function ExtractFileNameOnly(const fname: string): string;
function FloatToString(F: real): string;
function FloatToStrFixFmt(fVal: Double; prec, digit: Integer): string;
function FileSize(const fname: string): LongInt;
{*}
function FileCopy(Source, Dest: string): Boolean;
function FileCopyEx(Source, Dest: string): Boolean;
function GetSpaceCount(str: string): LongInt;
function RemoveSpace(str: string): string;
function GetFirstWord(str: string; var sWord: string; var FrontSpace: LongInt):
  string;
function GetDefColorByName(str: string): TColor;
function GetULMarkerType(str: string): LongInt;
{*}
function GetValidStr3(str: string; var Dest: string; const Divider: array of
  Char): string;
function GetValidStr4(str: string; var Dest: string; const Divider: array of
  Char): string;
function GetValidStrVal(str: string; var Dest: string; const Divider: array of
  Char): string;
function GetValidStrCap(str: string; var Dest: string; const Divider: array of
  Char): string;
function GetStrToCoords(str: string): TRect;
function GetDefines(str: string): LongInt;
function GetValueFromMask(Src: PChar; Mask: string): string;
procedure GetDirList(path: string; fllist: TStringList);
function GetFileDate(FileName: string): Integer; //DOS format file date..
function HexToIntEx(shap_str: string): LongInt;
function HexToInt(str: string): LongInt;
function IntToStrFill(num, Len: Integer; fill: Char): string;
function IsInB(Src: string; Pos: Integer; targ: string): Boolean;
function IsInRect(x, y: Integer; Rect: TRect): Boolean;
function IsEnglish(ch: Char): Boolean;
function IsEngNumeric(ch: Char): Boolean;
function IsFloatNumeric(str: string): Boolean;
function IsUniformStr(Src: string; ch: Char): Boolean;
function IsStringNumber(str: string): Boolean;
function KillFirstSpace(var str: string): LongInt;
procedure KillGabageSpace(var str: string);
function LRect(l, t, r, b: LongInt): TLRect;
procedure MemPCopy(Dest: PChar; Src: string);
procedure MemCpy(Dest, Src: PChar; Count: LongInt); {PChar type}
procedure memcpy2(TargAddr, SrcAddr: LongInt; Count: Integer); {Longint type}
procedure memset(Buffer: PChar; FillChar: Char; Count: Integer);
procedure PCharSet(P: PChar; n: Integer; ch: Char);
function ReplaceChar(Src: string; srcchr, repchr: Char): string;
function Str_ToDate(str: string): TDateTime;
function Str_ToTime(str: string): TDateTime;
function Str_ToInt(str: string; Def: LongInt): LongInt;
function Str_ToFloat(str: string): real;
function SkipStr(Src: string; const Skips: array of Char): string;
procedure ShlStr(Source: PChar; Count: Integer);
procedure ShrStr(Source: PChar; Count: Integer);
procedure Str256PCopy(Dest: PChar; const Src: string);
function _StrPas(Dest: PChar): string;
function Str_PCopy(Dest: PChar; Src: string): Integer;
function Str_PCopyEx(Dest: PChar; const Src: string; buflen: LongInt): Integer;
procedure SpliteBitmap(DC: hdc; x, y: Integer; bitmap: TBitmap; transcolor:
  TColor);
procedure TiledImage(Canv: TCanvas; Rect: TLRect; TileImage: TBitmap);
function Trim_R(const str: string): string;
function IsEqualFont(SrcFont, TarFont: TFont): Boolean;
function CutHalfCode(str: string): string;
function ConvertToShortName(Canvas: TCanvas; Source: string; WantWidth:
  Integer): string;
{*}
function CatchString(Source: string; cap: Char; var catched: string): string;
function DivString(Source: string; cap: Char; var sel: string): string;
function DivTailString(Source: string; cap: Char; var sel: string): string;
function SPos(substr, str: string): Integer;
function NumCopy(str: string): Integer;
function GetMonDay: string;
function BoolToStr(boo: Boolean): string;
function IntToSex(INT: Integer): string;
function IntToJob(INT: Integer): string;
function IntToStr2(INT: Integer): string;
function BoolToCStr(boo: Boolean): string;
function BoolToIntStr(boo: Boolean): string;
function TagCount(Source: string; Tag: Char): Integer;
function _MIN(n1, n2: Integer): Integer;
function _MAX(n1, n2: Integer): Integer;
function _MAX1(n1, n2: Integer): Integer;
function CalcFileCRC(FileName: string): Integer;
function CalcBufferCRC(Buffer: PChar; nSize: Integer): Integer;
function IsIPaddr(IP: string): Boolean;
function GetDayCount(MaxDate, MinDate: TDateTime): Integer;
function GetCodeMsgSize(x: Double): Integer;
implementation

//var
//	CSUtilLock: TRTLCriticalSection;

function IsIPaddr(IP: string): Boolean;
var
  Node: array[0..3] of Integer;
  tIP: string;
  tNode: string;
  tPos: Integer;
  tLen: Integer;
begin
  Result := False;
  tIP := IP;
  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[0]) then
    exit;

  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[1]) then
    exit;

  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[2]) then
    exit;

  if not TryStrToInt(tIP, Node[3]) then
    exit;
  for tLen := Low(Node) to High(Node) do
  begin
    if (Node[tLen] < 0) or (Node[tLen] > 255) then
      exit;
  end;
  Result := True;
end;

function CalcFileCRC(FileName: string): Integer;
var
  I: Integer;
  nFileHandle: Integer;
  nFileSize, nBuffSize: Integer;
  Buffer: PChar;
  INT: ^Integer;
  nCrc: Integer;
begin
  Result := 0;
  if not FileExists(FileName) then
  begin
    exit;
  end;
  nFileHandle := FileOpen(FileName, fmOpenRead or fmShareDenyNone);
  if nFileHandle = 0 then
    exit;
  nFileSize := FileSeek(nFileHandle, 0, 2);
  nBuffSize := (nFileSize div 4) * 4;
  GetMem(Buffer, nBuffSize);
  FillChar(Buffer^, nBuffSize, 0);
  FileSeek(nFileHandle, 0, 0);
  FileRead(nFileHandle, Buffer^, nBuffSize);
  FileClose(nFileHandle);
  INT := Pointer(Buffer);
  nCrc := 0;
  Exception.Create(IntToStr(SizeOf(Integer)));
  for I := 0 to nBuffSize div 4 - 1 do
  begin
    nCrc := nCrc xor INT^;
    INT := Pointer(Integer(INT) + 4);
  end;
  FreeMem(Buffer);
  Result := nCrc;
end;

function CalcBufferCRC(Buffer: PChar; nSize: Integer): Integer;
var
  I: Integer;
  INT: ^Integer;
  nCrc: Integer;
begin
  INT := Pointer(Buffer);
  nCrc := 0;
  for I := 0 to nSize div 4 - 1 do
  begin
    nCrc := nCrc xor INT^;
    INT := Pointer(Integer(INT) + 4);
  end;
  Result := nCrc;
end;
{ capture "double quote streams" }

function CaptureString(Source: string; var rdstr: string): string;
var
  st, et, C, Len, I: Integer;
begin
  if Source = '' then
  begin
    rdstr := '';
    Result := '';
    exit;
  end;
  C := 1;
  //et := 0;
  Len := Length(Source);
  while Source[C] = ' ' do
    if C < Len then
      Inc(C)
    else
      break;

  if ((Source[C] = '"') or (Source[C] = '(')) and (C < Len) then
  begin

    st := C + 1;
    et := Len;
    for I := C + 1 to Len do
      if (Source[I] = '"') or (Source[I] = ')') then
      begin
        et := I - 1;
        break;
      end;

  end
  else
  begin
    st := C;
    et := Len;
    for I := C to Len do
      if Source[I] = ' ' then
      begin
        et := I - 1;
        break;
      end;

  end;

  rdstr := Copy(Source, st, (et - st + 1));
  if Len >= (et + 2) then
    Result := Copy(Source, et + 2, Len - (et + 1))
  else
    Result := '';

end;

function CountUglyWhiteChar(sPtr: PChar): LongInt;
var
  Cnt, Killw: LongInt;
begin
  Killw := 0;
  for Cnt := (StrLen(sPtr) - 1) downto 0 do
  begin
    if sPtr[Cnt] = ' ' then
    begin
      Inc(Killw);
      {sPtr[Cnt] := #0;}
    end
    else
      break;
  end;
  Result := Killw;
end;

function CountGarbage(paper: TCanvas; Src: PChar; TargWidth: LongInt): Integer;
{garbage}
var
  gab, destWidth: Integer;
begin

  gab := CountUglyWhiteChar(Src);
  destWidth := paper.TextWidth(StrPas(Src)) - gab;
  Result := TargWidth - destWidth + (gab * paper.TextWidth(' '));

end;

function GetSpaceCount(str: string): LongInt;
var
  Cnt, Len, SpaceCount: LongInt;
begin
  SpaceCount := 0;
  Len := Length(str);
  for Cnt := 1 to Len do
    if str[Cnt] = ' ' then
      SpaceCount := SpaceCount + 1;
  Result := SpaceCount;
end;

function RemoveSpace(str: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(str) do
    if str[I] <> ' ' then
      Result := Result + str[I];
end;

function KillFirstSpace(var str: string): LongInt;
var
  Cnt, Len: LongInt;
begin
  Result := 0;
  Len := Length(str);
  for Cnt := 1 to Len do
    if str[Cnt] <> ' ' then
    begin
      str := Copy(str, Cnt, Len - Cnt + 1);
      Result := Cnt - 1;
      break;
    end;
end;

procedure KillGabageSpace(var str: string);
var
  Cnt, Len: LongInt;
begin
  Len := Length(str);
  for Cnt := Len downto 1 do
    if str[Cnt] <> ' ' then
    begin
      str := Copy(str, 1, Cnt);
      KillFirstSpace(str);
      break;
    end;
end;

function GetFirstWord(str: string; var sWord: string; var FrontSpace: LongInt):
  string;
var
  Cnt, Len, n: LongInt;
  DestBuf: Str4096;
begin
  Len := Length(str);
  if Len <= 0 then
    Result := ''
  else
  begin
    FrontSpace := 0;
    for Cnt := 1 to Len do
    begin
      if str[Cnt] = ' ' then
        Inc(FrontSpace)
      else
        break;
    end;
    n := 0;
    for Cnt := Cnt to Len do
    begin
      if str[Cnt] <> ' ' then
        DestBuf[n] := str[Cnt]
      else
      begin
        DestBuf[n] := #0;
        sWord := StrPas(DestBuf);
        Result := Copy(str, Cnt, Len - Cnt + 1);
        exit;
      end;
      Inc(n);
    end;
    DestBuf[n] := #0;
    sWord := StrPas(DestBuf);
    Result := '';
  end;
end;

function HexToIntEx(shap_str: string): LongInt;
begin
  Result := HexToInt(Copy(shap_str, 2, Length(shap_str) - 1));
end;

function HexToInt(str: string): LongInt;
var
  digit: Char;
  Count, I: Integer;
  cur, val: LongInt;
begin
  val := 0;
  Count := Length(str);
  for I := 1 to Count do
  begin
    digit := str[I];
    if (digit >= '0') and (digit <= '9') then
      cur := Ord(digit) - Ord('0')
    else if (digit >= 'A') and (digit <= 'F') then
      cur := Ord(digit) - Ord('A') + 10
    else if (digit >= 'a') and (digit <= 'f') then
      cur := Ord(digit) - Ord('a') + 10
    else
      cur := 0;
    val := val + (cur shl (4 * (Count - I)));
  end;
  Result := val;
  //   Result := (Val and $0000FF00) or ((Val shl 16) and $00FF0000) or ((Val shr 16) and $000000FF);
end;

function Str_ToInt(str: string; Def: LongInt): LongInt;
var
  v, code: LongInt;

begin
  Result := Def;
  val(str, v, code);
  if code = 0 then
    Result := v;
  {
  if str <> '' then
  begin
    if ((Word(str[1]) >= Word('0')) and (Word(str[1]) <= Word('9'))) or
      (str[1] = '+') or (str[1] = '-') then
    try
      Result := StrToInt64(str);
    except
    end;
  end;
  }
end;

function Str_ToDate(str: string): TDateTime;
begin
  if Trim(str) = '' then
    Result := Date
  else
    Result := StrToDate(str);
end;

function Str_ToTime(str: string): TDateTime;
begin
  if Trim(str) = '' then
    Result := Time
  else
    Result := StrToTime(str);
end;

function Str_ToFloat(str: string): real;
begin
  if str <> '' then
  try
    Result := StrToFloat(str);
    exit;
  except
  end;
  Result := 0;
end;

procedure DrawingGhost(Rc: TRect);
var
  DC: hdc;
begin
  DC := GetDC(0);
  DrawFocusRect(DC, Rc);
  ReleaseDC(0, DC);
end;

function ExtractFileNameOnly(const fname: string): string;
var
  extpos: Integer;
  ext, fn: string;
begin
  ext := ExtractFileExt(fname);
  fn := ExtractFileName(fname);
  if ext <> '' then
  begin
    extpos := Pos(ext, fn);
    Result := Copy(fn, 1, extpos - 1);
  end
  else
    Result := fn;
end;

function FloatToString(F: real): string;
begin
  Result := FloatToStrFixFmt(F, 5, 2);
end;

function FloatToStrFixFmt(fVal: Double; prec, digit: Integer): string;
var
  Cnt, Dest, Len, I, j: Integer;
  fstr: string;
  Buf: array[0..255] of Char;
label
  end_conv;
begin
  Cnt := 0;
  Dest := 0;
  fstr := FloatToStrF(fVal, ffGeneral, 15, 3);
  Len := Length(fstr);
  for I := 1 to Len do
  begin
    if fstr[I] = '.' then
    begin
      Buf[Dest] := '.';
      Inc(Dest);
      Cnt := 0;
      for j := I + 1 to Len do
      begin
        if Cnt < digit then
        begin
          Buf[Dest] := fstr[j];
          Inc(Dest);
        end
        else
        begin
          goto end_conv;
        end;
        Inc(Cnt);
      end;
      goto end_conv;
    end;
    if Cnt < prec then
    begin
      Buf[Dest] := fstr[I];
      Inc(Dest);
    end;
    Inc(Cnt);
  end;
  end_conv:
  Buf[Dest] := Char(0);
  Result := StrPas(Buf);
end;

function FileSize(const fname: string): LongInt;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(fname), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else
    Result := -1;
  SysUtils.FindClose(SearchRec);
end;

function FileCopy(Source, Dest: string): Boolean;
var
  fSrc, fDst, Len: Integer;
  Size: LongInt;
  Buffer: packed array[0..2047] of Byte;
begin
  Result := False; { Assume that it WONT work }
  if Source <> Dest then
  begin
    fSrc := FileOpen(Source, fmOpenRead);
    if fSrc >= 0 then
    begin
      Size := FileSeek(fSrc, 0, 2);
      FileSeek(fSrc, 0, 0);
      fDst := FileCreate(Dest);
      if fDst >= 0 then
      begin
        while Size > 0 do
        begin
          Len := FileRead(fSrc, Buffer, SizeOf(Buffer));
          FileWrite(fDst, Buffer, Len);
          Size := Size - Len;
        end;
        FileSetDate(fDst, FileGetDate(fSrc));
        FileClose(fDst);
        FileSetAttr(Dest, FileGetAttr(Source));
        Result := True;
      end;
      FileClose(fSrc);
    end;
  end;
end;

function FileCopyEx(Source, Dest: string): Boolean;
var
  fSrc, fDst, Len: Integer;
  Size: LongInt;
  Buffer: array[0..512000] of Byte;
begin
  Result := False; { Assume that it WONT work }
  if Source <> Dest then
  begin
    fSrc := FileOpen(Source, fmOpenRead or fmShareDenyNone);
    if fSrc >= 0 then
    begin
      Size := FileSeek(fSrc, 0, 2);
      FileSeek(fSrc, 0, 0);
      fDst := FileCreate(Dest);
      if fDst >= 0 then
      begin
        while Size > 0 do
        begin
          Len := FileRead(fSrc, Buffer, SizeOf(Buffer));
          FileWrite(fDst, Buffer, Len);
          Size := Size - Len;
        end;
        FileSetDate(fDst, FileGetDate(fSrc));
        FileClose(fDst);
        FileSetAttr(Dest, FileGetAttr(Source));
        Result := True;
      end;
      FileClose(fSrc);
    end;
  end;
end;

function GetDefColorByName(str: string): TColor;
var
  Cnt: Integer;
  COmpStr: string;
begin
  COmpStr := UpperCase(str);
  for Cnt := 1 to MAXDEFCOLOR do
  begin
    if COmpStr = ColorNames[Cnt].Name then
    begin
      Result := TColor(ColorNames[Cnt].varl);
      exit;
    end;
  end;
  Result := $0;
end;

function GetULMarkerType(str: string): LongInt;
var
  Cnt: Integer;
  COmpStr: string;
begin
  COmpStr := UpperCase(str);
  for Cnt := 1 to MAXLISTMARKER do
  begin
    if COmpStr = LiMarkerNames[Cnt].Name then
    begin
      Result := LiMarkerNames[Cnt].varl;
      exit;
    end;
  end;
  Result := 1;
end;

function GetDefines(str: string): LongInt;
var
  Cnt: Integer;
  COmpStr: string;
begin
  COmpStr := UpperCase(str);
  for Cnt := 1 to MAXPREDEFINE do
  begin
    if COmpStr = PreDefineNames[Cnt].Name then
    begin
      Result := PreDefineNames[Cnt].varl;
      exit;
    end;
  end;
  Result := -1;
end;

procedure ClearWindow(aCanvas: TCanvas; aLeft, aTop, aRight, aBottom: LongInt;
  aColor: TColor);
begin
  with aCanvas do
  begin
    Brush.Color := aColor;
    Pen.Color := aColor;
    Rectangle(0, 0, aRight - aLeft, aBottom - aTop);
  end;
end;

procedure DrawTileImage(Canv: TCanvas; Rect: TRect; TileImage: TBitmap);
var
  I, j, ICnt, JCnt, BmWidth, BmHeight: Integer;
begin

  BmWidth := TileImage.Width;
  BmHeight := TileImage.Height;
  ICnt := ((Rect.Right - Rect.Left) + BmWidth - 1) div BmWidth;
  JCnt := ((Rect.Bottom - Rect.Top) + BmHeight - 1) div BmHeight;

  UnrealizeObject(Canv.Handle);
  SelectPalette(Canv.Handle, TileImage.Palette, False);
  RealizePalette(Canv.Handle);

  for j := 0 to JCnt do
  begin
    for I := 0 to ICnt do
    begin

      { if (I * BmWidth) < (Rect.Right-Rect.Left) then
         BmWidth := TileImage.Width else
          BmWidth := (Rect.Right - Rect.Left) - ((I-1) * BmWidth);

       if (
       BmWidth := TileImage.Width;
       BmHeight := TileImage.Height;  }

      BitBlt(Canv.Handle,
        Rect.Left + I * BmWidth,
        Rect.Top + (j * BmHeight),
        BmWidth,
        BmHeight,
        TileImage.Canvas.Handle,
        0,
        0,
        SRCCOPY);

    end;
  end;

end;

procedure TiledImage(Canv: TCanvas; Rect: TLRect; TileImage: TBitmap);
var
  I, j, ICnt, JCnt, BmWidth, BmHeight: Integer;
  Rleft, RTop, RWidth, RHeight, BLeft, BTop: LongInt;
begin

  if assigned(TileImage) then
    if TileImage.Handle <> 0 then
    begin

      BmWidth := TileImage.Width;
      BmHeight := TileImage.Height;
      ICnt := (Rect.Right + BmWidth - 1) div BmWidth - (Rect.Left div BmWidth);
      JCnt := (Rect.Bottom + BmHeight - 1) div BmHeight - (Rect.Top div
        BmHeight);

      UnrealizeObject(Canv.Handle);
      SelectPalette(Canv.Handle, TileImage.Palette, False);
      RealizePalette(Canv.Handle);

      for j := 0 to JCnt do
      begin
        for I := 0 to ICnt do
        begin

          if I = 0 then
          begin
            BLeft := Rect.Left - ((Rect.Left div BmWidth) * BmWidth);
            Rleft := Rect.Left;
            RWidth := BmWidth;
          end
          else
          begin
            if I = ICnt then
              RWidth := Rect.Right - ((Rect.Right div BmWidth) * BmWidth)
            else
              RWidth := BmWidth;
            BLeft := 0;
            Rleft := (Rect.Left div BmWidth) + (I * BmWidth);
          end;

          if j = 0 then
          begin
            BTop := Rect.Top - ((Rect.Top div BmHeight) * BmHeight);
            RTop := Rect.Top;
            RHeight := BmHeight;
          end
          else
          begin
            if j = JCnt then
              RHeight := Rect.Bottom - ((Rect.Bottom div BmHeight) * BmHeight)
            else
              RHeight := BmHeight;
            BTop := 0;
            RTop := (Rect.Top div BmHeight) + (j * BmHeight);
          end;

          BitBlt(Canv.Handle,
            Rleft,
            RTop,
            RWidth,
            RHeight,
            TileImage.Canvas.Handle,
            BLeft,
            BTop,
            SRCCOPY);

        end;
      end;

    end;
end;

function GetValidStr3(str: string; var Dest: string; const Divider: array of
  Char): string;
const
  BUF_SIZE = 20480; //$7FFF;
var
  Buf: array[0..BUF_SIZE] of Char;
  BufCount, Count, srclen, I, ArrCount: LongInt;
  ch: Char;
label
  CATCH_DIV;
begin
  ch := #0; //Jacky
  try
    srclen := Length(str);
    BufCount := 0;
    Count := 1;

    if srclen >= BUF_SIZE - 1 then
    begin
      Result := '';
      Dest := '';
      exit;
    end;

    if str = '' then
    begin
      Dest := '';
      Result := str;
      exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(Char);

    while True do
    begin
      if Count <= srclen then
      begin
        ch := str[Count];
        for I := 0 to ArrCount - 1 do
          if ch = Divider[I] then
            goto CATCH_DIV;
      end;
      if (Count > srclen) then
      begin
        CATCH_DIV:
        if (BufCount > 0) then
        begin
          if BufCount < BUF_SIZE - 1 then
          begin
            Buf[BufCount] := #0;
            Dest := string(Buf);
            Result := Copy(str, Count + 1, srclen - Count);
          end;
          break;
        end
        else
        begin
          if (Count > srclen) then
          begin
            Dest := '';
            Result := Copy(str, Count + 2, srclen - 1);
            break;
          end;
        end;
      end
      else
      begin
        if BufCount < BUF_SIZE - 1 then
        begin
          Buf[BufCount] := ch;
          Inc(BufCount);
        end; // else
        //ShowMessage ('BUF_SIZE overflow !');
      end;
      Inc(Count);
    end;
  except
    Dest := '';
    Result := '';
  end;
end;

// ±¸ºÐ¹®ÀÚ°¡ ³ª¸ÓÁö(Result)¿¡ Æ÷ÇÔ µÈ´Ù.

function GetValidStr4(str: string; var Dest: string; const Divider: array of
  Char): string;
const
  BUF_SIZE = 18200; //$7FFF;
var
  Buf: array[0..BUF_SIZE] of Char;
  BufCount, Count, srclen, I, ArrCount: LongInt;
  ch: Char;
label
  CATCH_DIV;
begin
  ch := #0; //Jacky
  try
    //EnterCriticalSection (CSUtilLock);
    srclen := Length(str);
    BufCount := 0;
    Count := 1;

    if str = '' then
    begin
      Dest := '';
      Result := str;
      exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(Char);

    while True do
    begin
      if Count <= srclen then
      begin
        ch := str[Count];
        for I := 0 to ArrCount - 1 do
          if ch = Divider[I] then
            goto CATCH_DIV;
      end;
      if (Count > srclen) then
      begin
        CATCH_DIV:
        if (BufCount > 0) or (ch <> ' ') then
        begin
          if BufCount <= 0 then
          begin
            Buf[0] := ch;
            Buf[1] := #0;
            ch := ' ';
          end
          else
            Buf[BufCount] := #0;
          Dest := string(Buf);
          if ch <> ' ' then
            Result := Copy(str, Count, srclen - Count + 1)
              //remain divider in rest-string,
          else
            Result := Copy(str, Count + 1, srclen - Count); //exclude whitespace
          break;
        end
        else
        begin
          if (Count > srclen) then
          begin
            Dest := '';
            Result := Copy(str, Count + 2, srclen - 1);
            break;
          end;
        end;
      end
      else
      begin
        if BufCount < BUF_SIZE - 1 then
        begin
          Buf[BufCount] := ch;
          Inc(BufCount);
        end
        else
          ShowMessage('BUF_SIZE overflow !');
      end;
      Inc(Count);
    end;
  finally
    //LeaveCriticalSection (CSUtilLock);
  end;
end;

function GetValidStrVal(str: string; var Dest: string; const Divider: array of
  Char): string;
//¼ýÀÚ¸¦ ºÐ¸®ÇØ³¿ ex) 12.30mV
const
  BUF_SIZE = 15600;
var
  Buf: array[0..BUF_SIZE] of Char;
  BufCount, Count, srclen, I, ArrCount: LongInt;
  ch: Char;
  currentNumeric: Boolean;
  hexmode: Boolean;
label
  CATCH_DIV;
begin
  ch := #0; //Jacky
  try
    //EnterCriticalSection (CSUtilLock);
    hexmode := False;
    srclen := Length(str);
    BufCount := 0;
    Count := 1;
    currentNumeric := False;

    if str = '' then
    begin
      Dest := '';
      Result := str;
      exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(Char);

    while True do
    begin
      if Count <= srclen then
      begin
        ch := str[Count];
        for I := 0 to ArrCount - 1 do
          if ch = Divider[I] then
            goto CATCH_DIV;
      end;
      if not currentNumeric then
      begin
        if (Count + 1) < srclen then
        begin
          if (str[Count] = '0') and (UpCase(str[Count + 1]) = 'X') then
          begin
            Buf[BufCount] := str[Count];
            Buf[BufCount + 1] := str[Count + 1];
            Inc(BufCount, 2);
            Inc(Count, 2);
            hexmode := True;
            currentNumeric := True;
            Continue;
          end;
          if (ch = '-') and (str[Count + 1] >= '0') and (str[Count + 1] <= '9')
            then
          begin
            currentNumeric := True;
          end;
        end;
        if (ch >= '0') and (ch <= '9') then
        begin
          currentNumeric := True;
        end;
      end
      else
      begin
        if hexmode then
        begin
          if not (((ch >= '0') and (ch <= '9')) or
            ((ch >= 'A') and (ch <= 'F')) or
            ((ch >= 'a') and (ch <= 'f'))) then
          begin
            Dec(Count);
            goto CATCH_DIV;
          end;
        end
        else if ((ch < '0') or (ch > '9')) and (ch <> '.') then
        begin
          Dec(Count);
          goto CATCH_DIV;
        end;
      end;
      if (Count > srclen) then
      begin
        CATCH_DIV:
        if (BufCount > 0) then
        begin
          Buf[BufCount] := #0;
          Dest := string(Buf);
          Result := Copy(str, Count + 1, srclen - Count);
          break;
        end
        else
        begin
          if (Count > srclen) then
          begin
            Dest := '';
            Result := Copy(str, Count + 2, srclen - 1);
            break;
          end;
        end;
      end
      else
      begin
        if BufCount < BUF_SIZE - 1 then
        begin
          Buf[BufCount] := ch;
          Inc(BufCount);
        end
        else
          ShowMessage('BUF_SIZE overflow !');
      end;
      Inc(Count);
    end;
  finally
    //LeaveCriticalSection (CSUtilLock);
  end;
end;

{" " capture => CaptureString (source: string; var rdstr: string): string;
 ** Ã³À½¿¡ " ´Â Ç×»ó ¸Ç Ã³À½¿¡ ÀÖ´Ù°í °¡Á¤
}

function GetValidStrCap(str: string; var Dest: string; const Divider: array of
  Char): string;
begin
  str := TrimLeft(str);
  if str <> '' then
  begin
    if (str[1] = '"') or (str[1] = '(') then
      Result := CaptureString(str, Dest)
    else
    begin
      Result := GetValidStr3(str, Dest, Divider);
    end;
  end
  else
  begin
    Result := '';
    Dest := '';
  end;
end;

function IntToStrFill(num, Len: Integer; fill: Char): string;
var
  I: Integer;
  str: string;
begin
  Result := '';
  str := IntToStr(num);
  for I := 1 to Len - Length(str) do
    Result := Result + fill;
  Result := Result + str;
end;

function IntToStr2(INT: Integer): string;
begin
  if INT < 10 then
  begin
    Result := '0' + IntToStr(INT);
  end
  else
  begin
    Result := IntToStr(INT);
  end;
end;

function IsInB(Src: string; Pos: Integer; targ: string): Boolean;
var
  tLen, I: Integer;
begin
  Result := False;
  tLen := Length(targ);
  if Length(Src) < Pos + tLen then
    exit;
  for I := 0 to tLen - 1 do
    if UpCase(Src[Pos + I]) <> UpCase(targ[I + 1]) then
      exit;

  Result := True;
end;

function IsInRect(x, y: Integer; Rect: TRect): Boolean;
begin
  if (x >= Rect.Left) and (x <= Rect.Right) and (y >= Rect.Top) and (y <=
    Rect.Bottom) then
    Result := True
  else
    Result := False;
end;

function IsStringNumber(str: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Length(str) do
    if (Byte(str[I]) < Byte('0')) or (Byte(str[I]) > Byte('9')) then
    begin
      Result := False;
      break;
    end;
end;

{Return : remain string}

function ArrestString(Source, SearchAfter, ArrestBefore: string;
  const DropTags: array of string; var RsltStr: string): string;
const
  BUF_SIZE = $7FFF;
var
  Buf: array[0..BUF_SIZE] of Char;
  BufCount, SrcCount, srclen, {AfterLen, BeforeLen,} DropCount, I: Integer;
  ArrestNow: Boolean;
begin
  try
    //EnterCriticalSection (CSUtilLock);
    RsltStr := ''; {result string}
    srclen := Length(Source);

    if srclen > BUF_SIZE then
    begin
      Result := '';
      exit;
    end;

    BufCount := 0;
    SrcCount := 1;
    ArrestNow := False;
    DropCount := SizeOf(DropTags) div SizeOf(string);

    if (SearchAfter = '') then
      ArrestNow := True;

    //GetMem (Buf, BUF_SIZE);

    while True do
    begin
      if SrcCount > srclen then
        break;

      if not ArrestNow then
      begin
        if IsInB(Source, SrcCount, SearchAfter) then
          ArrestNow := True;
      end
      else
      begin
        Buf[BufCount] := Source[SrcCount];
        if IsInB(Source, SrcCount, ArrestBefore) or (BufCount >= BUF_SIZE - 2)
          then
        begin
          BufCount := BufCount - Length(ArrestBefore);
          Buf[BufCount + 1] := #0;
          RsltStr := string(Buf);
          BufCount := 0;
          break;
        end;

        for I := 0 to DropCount - 1 do
        begin
          if IsInB(Source, SrcCount, DropTags[I]) then
          begin
            BufCount := BufCount - Length(DropTags[I]);
            break;
          end;
        end;

        Inc(BufCount);
      end;
      Inc(SrcCount);
    end;

    if (ArrestNow) and (BufCount <> 0) then
    begin
      Buf[BufCount] := #0;
      RsltStr := string(Buf);
    end;

    Result := Copy(Source, SrcCount + 1, srclen - SrcCount);
    {result is remain string}
  finally
    //LeaveCriticalSection (CSUtilLock);
  end;
end;

function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var
  ArrestStr: string): string;
var
  BufCount, SrcCount, srclen: Integer;
  GoodData, Fin: Boolean;
  I, n: Integer;
begin
  ArrestStr := ''; {result string}
  if Source = '' then
  begin
    Result := '';
    exit;
  end;

  try
    srclen := Length(Source);
    GoodData := False;
    if srclen >= 2 then
      if Source[1] = SearchAfter then
      begin
        Source := Copy(Source, 2, srclen - 1);
        srclen := Length(Source);
        GoodData := True;
      end
      else
      begin
        n := Pos(SearchAfter, Source);
        if n > 0 then
        begin
          Source := Copy(Source, n + 1, srclen - (n));
          srclen := Length(Source);
          GoodData := True;
        end;
      end;
    Fin := False;
    if GoodData then
    begin
      n := Pos(ArrestBefore, Source);
      if n > 0 then
      begin
        ArrestStr := Copy(Source, 1, n - 1);
        Result := Copy(Source, n + 1, srclen - n);
      end
      else
      begin
        Result := SearchAfter + Source;
      end;
    end
    else
    begin
      for I := 1 to srclen do
      begin
        if Source[I] = SearchAfter then
        begin
          Result := Copy(Source, I, srclen - I + 1);
          break;
        end;
      end;
    end;
  except
    ArrestStr := '';
    Result := '';
  end;
end;

function SkipStr(Src: string; const Skips: array of Char): string;
var
  I, Len, C: Integer;
  NowSkip: Boolean;
begin
  Len := Length(Src);
  //   Count := sizeof(Skips) div sizeof (Char);

  for I := 1 to Len do
  begin
    NowSkip := False;
    for C := Low(Skips) to High(Skips) do
      if Src[I] = Skips[C] then
      begin
        NowSkip := True;
        break;
      end;
    if not NowSkip then
      break;
  end;

  Result := Copy(Src, I, Len - I + 1);

end;

function GetStrToCoords(str: string): TRect;
var
  temp: string;
begin

  str := GetValidStr3(str, temp, [',', ' ']);
  Result.Left := Str_ToInt(temp, 0);
  str := GetValidStr3(str, temp, [',', ' ']);
  Result.Top := Str_ToInt(temp, 0);
  str := GetValidStr3(str, temp, [',', ' ']);
  Result.Right := Str_ToInt(temp, 0);
  GetValidStr3(str, temp, [',', ' ']);
  Result.Bottom := Str_ToInt(temp, 0);

end;

function CombineDirFile(SrcDir, TargName: string): string;
begin
  if (SrcDir = '') or (TargName = '') then
  begin
    Result := SrcDir + TargName;
    exit;
  end;
  if SrcDir[Length(SrcDir)] = '\' then
    Result := SrcDir + TargName
  else
    Result := SrcDir + '\' + TargName;
end;

function CompareLStr(Src, targ: string; compn: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if compn <= 0 then
    exit;
  if Length(Src) < compn then
    exit;
  if Length(targ) < compn then
    exit;
  Result := True;
  for I := 1 to compn do
    if UpCase(Src[I]) <> UpCase(targ[I]) then
    begin
      Result := False;
      break;
    end;
end;

function CompareBuffer(p1, p2: Pbyte; Len: Integer): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to Len - 1 do
    if Pbyte(Integer(p1) + I)^ <> Pbyte(Integer(p2) + I)^ then
    begin
      Result := False;
      break;
    end;
end;

function CompareBackLStr(Src, targ: string; compn: Integer): Boolean;
var
  I, slen, tLen: Integer;
begin
  Result := False;
  if compn <= 0 then
    exit;
  if Length(Src) < compn then
    exit;
  if Length(targ) < compn then
    exit;
  slen := Length(Src);
  tLen := Length(targ);
  Result := True;
  for I := 0 to compn - 1 do
    if UpCase(Src[slen - I]) <> UpCase(targ[tLen - I]) then
    begin
      Result := False;
      break;
    end;
end;

function IsEnglish(ch: Char): Boolean;
begin
  Result := False;
  if ((ch >= 'A') and (ch <= 'Z')) or ((ch >= 'a') and (ch <= 'z')) then
    Result := True;
end;

function IsEngNumeric(ch: Char): Boolean;
begin
  Result := False;
  if IsEnglish(ch) or ((ch >= '0') and (ch <= '9')) then
    Result := True;
end;

function IsFloatNumeric(str: string): Boolean;
begin
  if Trim(str) = '' then
  begin
    Result := False;
    exit;
  end;
  try
    StrToFloat(str);
    Result := True;
  except
    Result := False;
  end;
end;

procedure PCharSet(P: PChar; n: Integer; ch: Char);
var
  I: Integer;
begin
  for I := 0 to n - 1 do
    (P + I)^ := ch;
end;

function ReplaceChar(Src: string; srcchr, repchr: Char): string;
var
  I, Len: Integer;
begin
  if Src <> '' then
  begin
    Len := Length(Src);
    for I := 1 to Len do
      if Src[I] = srcchr then
        Src[I] := repchr;
  end;
  Result := Src;
end;

function IsUniformStr(Src: string; ch: Char): Boolean;
var
  I, Len: Integer;
begin
  Result := True;
  if Src <> '' then
  begin
    Len := Length(Src);
    for I := 1 to Len do
      if Src[I] = ch then
      begin
        Result := False;
        break;
      end;
  end;
end;

function CreateMask(Src: PChar; TargPos: Integer): string;

  function IsNumber(Chr: Char): Boolean;
  begin
    if (Chr >= '0') and (Chr <= '9') then
      Result := True
    else
      Result := False;
  end;
var
  intFlag, Loop: Boolean;
  Cnt, IntCnt, srclen: Integer;
  ch, Ch2: Char;
begin
  intFlag := False;
  Loop := True;
  Cnt := 0;
  IntCnt := 0;
  srclen := StrLen(Src);

  while Loop do
  begin
    ch := PChar(LongInt(Src) + Cnt)^;
    case ch of
      #0:
        begin
          Result := '';
          break;
        end;
      ' ':
        begin
        end;
    else
      begin

        if not intFlag then
        begin { Now Reading char }
          if IsNumber(ch) then
          begin
            intFlag := True;
            Inc(IntCnt);
          end;
        end
        else
        begin { If, now reading integer }
          if not IsNumber(ch) then
          begin { XXE+3 }
            case UpCase(ch) of
              'E':
                begin
                  if (Cnt >= 1) and (Cnt + 2 < srclen) then
                  begin
                    ch := PChar(LongInt(Src) + Cnt - 1)^;
                    if IsNumber(ch) then
                    begin
                      ch := PChar(LongInt(Src) + Cnt + 1)^;
                      Ch2 := PChar(LongInt(Src) + Cnt + 2)^;
                      if not ((ch = '+') and (IsNumber(Ch2))) then
                      begin
                        intFlag := False;
                      end;
                    end;
                  end;
                end;
              '+':
                begin
                  if (Cnt >= 1) and (Cnt + 1 < srclen) then
                  begin
                    ch := PChar(LongInt(Src) + Cnt - 1)^;
                    Ch2 := PChar(LongInt(Src) + Cnt + 1)^;
                    if not ((UpCase(ch) = 'E') and (IsNumber(Ch2))) then
                    begin
                      intFlag := False;
                    end;
                  end;
                end;
              '.':
                begin
                  if (Cnt >= 1) and (Cnt + 1 < srclen) then
                  begin
                    ch := PChar(LongInt(Src) + Cnt - 1)^;
                    Ch2 := PChar(LongInt(Src) + Cnt + 1)^;
                    if not ((IsNumber(ch)) and (IsNumber(Ch2))) then
                    begin
                      intFlag := False;
                    end;
                  end;
                end;

            else
              intFlag := False;
            end;
          end;
        end; {end of case else}
      end; {end of Case}
    end;
    if (intFlag) and (Cnt >= TargPos) then
    begin
      Result := '%' + format('%d', [IntCnt]);
      exit;
    end;
    Inc(Cnt);
  end;
end;

function GetValueFromMask(Src: PChar; Mask: string): string;

  function Positon(str: string): Integer;
  var
    str2: string;
  begin
    str2 := Copy(str, 2, Length(str) - 1);
    Result := StrToIntDef(str2, 0);
    if Result <= 0 then
      Result := 1;
  end;

  function IsNumber(ch: Char): Boolean;
  begin
    case ch of
      '0'..'9': Result := True;
    else
      Result := False;
    end;
  end;
var
  intFlag, Loop, Sign: Boolean;
  Buf: Str256;
  BufCount, Pos, LocCount, TargLoc, srclen: Integer;
  ch, Ch2: Char;
begin
  srclen := StrLen(Src);
  LocCount := 0;
  BufCount := 0;
  Pos := 0;
  intFlag := False;
  Loop := True;
  Sign := False;

  if Mask = '' then
    Mask := '%1';
  TargLoc := Positon(Mask);

  while Loop do
  begin
    if Pos >= srclen then
      break;
    ch := PChar(Src + Pos)^;
    if not intFlag then
    begin {now reading chars}
      if LocCount < TargLoc then
      begin
        if IsNumber(ch) then
        begin
          intFlag := True;
          BufCount := 0;
          Inc(LocCount);
        end
        else
        begin
          if not Sign then
          begin {default '+'}
            if ch = '-' then
              Sign := True;
          end
          else
          begin
            if ch <> ' ' then
              Sign := False;
          end;
        end;
      end
      else
      begin
        break;
      end;
    end;
    if intFlag then
    begin {now reading numbers}
      Buf[BufCount] := ch;
      Inc(BufCount);
      if not IsNumber(ch) then
      begin
        case ch of
          'E', 'e':
            begin
              if (Pos >= 1) and (Pos + 2 < srclen) then
              begin
                ch := PChar(Src + Pos - 1)^;
                if IsNumber(ch) then
                begin
                  ch := PChar(Src + Pos + 1)^;
                  Ch2 := PChar(Src + Pos + 2)^;
                  if not ((ch = '+') or (ch = '-') and (IsNumber(Ch2))) then
                  begin
                    Dec(BufCount);
                    intFlag := False;
                  end;
                end;
              end;
            end;
          '+', '-':
            begin
              if (Pos >= 1) and (Pos + 1 < srclen) then
              begin
                ch := PChar(Src + Pos - 1)^;
                Ch2 := PChar(Src + Pos + 1)^;
                if not ((UpCase(ch) = 'E') and (IsNumber(Ch2))) then
                begin
                  Dec(BufCount);
                  intFlag := False;
                end;
              end;
            end;
          '.':
            begin
              if (Pos >= 1) and (Pos + 1 < srclen) then
              begin
                ch := PChar(Src + Pos - 1)^;
                Ch2 := PChar(Src + Pos + 1)^;
                if not ((IsNumber(ch)) and (IsNumber(Ch2))) then
                begin
                  Dec(BufCount);
                  intFlag := False;
                end;
              end;
            end;
        else
          begin
            intFlag := False;
            Dec(BufCount);
          end;
        end;
      end;
    end;
    Inc(Pos);
  end;
  if LocCount = TargLoc then
  begin
    Buf[BufCount] := #0;
    if Sign then
      Result := '-' + StrPas(Buf)
    else
      Result := StrPas(Buf);
  end
  else
    Result := '';
end;

procedure GetDirList(path: string; fllist: TStringList);
var
  SearchRec: TSearchRec;
begin
  if FindFirst(path, faAnyFile, SearchRec) = 0 then
  begin
    fllist.AddObject(SearchRec.Name, TObject(SearchRec.Time));
    while True do
    begin
      if FindNext(SearchRec) = 0 then
      begin
        fllist.AddObject(SearchRec.Name, TObject(SearchRec.Time));
      end
      else
      begin
        SysUtils.FindClose(SearchRec);
        break;
      end;
    end;
  end;
end;

function GetFileDate(FileName: string): Integer; //DOS format file date..
var
  SearchRec: TSearchRec;
begin
  Result := 0; //jacky
  if FindFirst(FileName, faAnyFile, SearchRec) = 0 then
  begin
    Result := SearchRec.Time;
    SysUtils.FindClose(SearchRec);
  end;
end;

procedure ShlStr(Source: PChar; Count: Integer);
var
  I, Len: Integer;
begin
  Len := StrLen(Source);
  while (Count > 0) do
  begin
    for I := 0 to Len - 2 do
      Source[I] := Source[I + 1];
    Source[Len - 1] := #0;

    Dec(Count);
  end;
end;

procedure ShrStr(Source: PChar; Count: Integer);
var
  I, Len: Integer;
begin
  Len := StrLen(Source);
  while (Count > 0) do
  begin
    for I := Len - 1 downto 0 do
      Source[I + 1] := Source[I];
    Source[Len + 1] := #0;

    Dec(Count);
  end;
end;

function LRect(l, t, r, b: LongInt): TLRect;
begin
  Result.Left := l;
  Result.Top := t;
  Result.Right := r;
  Result.Bottom := b;
end;

procedure MemPCopy(Dest: PChar; Src: string);
var
  I: Integer;
begin
  for I := 0 to Length(Src) - 1 do
    Dest[I] := Src[I + 1];
end;

procedure MemCpy(Dest, Src: PChar; Count: LongInt);
var
  I: LongInt;
begin
  for I := 0 to Count - 1 do
  begin
    PChar(LongInt(Dest) + I)^ := PChar(LongInt(Src) + I)^;
  end;
end;

procedure memcpy2(TargAddr, SrcAddr: LongInt; Count: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    PChar(TargAddr + I)^ := PChar(SrcAddr + I)^;
end;

procedure memset(Buffer: PChar; FillChar: Char; Count: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Buffer[I] := FillChar;
end;

procedure Str256PCopy(Dest: PChar; const Src: string);
begin
  StrPLCopy(Dest, Src, 255);
end;

function _StrPas(Dest: PChar): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(Dest) - 1 do
    if Dest[I] <> Chr(0) then
      Result := Result + Dest[I]
    else
      break;
end;

function Str_PCopy(Dest: PChar; Src: string): Integer;
var
  Len, I: Integer;
begin
  Len := Length(Src);
  for I := 1 to Len do
    Dest[I - 1] := Src[I];
  Dest[Len] := #0;
  Result := Len;
end;

function Str_PCopyEx(Dest: PChar; const Src: string; buflen: LongInt): Integer;
var
  Len, I: Integer;
begin
  Len := _MIN(Length(Src), buflen);
  for I := 1 to Len do
    Dest[I - 1] := Src[I];
  Dest[Len] := #0;
  Result := Len;
end;

function Str_Catch(Src, Dest: string; Len: Integer): string; //Result is rests..
begin

end;

function Trim_R(const str: string): string;
var
  I, Len, tr: Integer;
begin
  tr := 0;
  Len := Length(str);
  for I := Len downto 1 do
    if str[I] = ' ' then
      Inc(tr)
    else
      break;
  Result := Copy(str, 1, Len - tr);
end;

function IsEqualFont(SrcFont, TarFont: TFont): Boolean;
begin
  Result := True;
  if SrcFont.Name <> TarFont.Name then
    Result := False;
  if SrcFont.Color <> TarFont.Color then
    Result := False;
  if SrcFont.Style <> TarFont.Style then
    Result := False;
  if SrcFont.Size <> TarFont.Size then
    Result := False;
end;

function CutHalfCode(str: string): string;
var
  Pos, Len: Integer;
begin

  Result := '';
  Pos := 1;
  Len := Length(str);

  while True do
  begin

    if Pos > Len then
      break;

    if (str[Pos] > #127) then
    begin

      if ((Pos + 1) <= Len) and (str[Pos + 1] > #127) then
      begin
        Result := Result + str[Pos] + str[Pos + 1];
        Inc(Pos);
      end;

    end
    else
      Result := Result + str[Pos];

    Inc(Pos);

  end;
end;

function ConvertToShortName(Canvas: TCanvas; Source: string; WantWidth:
  Integer): string;
var
  I, Len: Integer;
  str: string;
begin
  if Length(Source) > 3 then
    if Canvas.TextWidth(Source) > WantWidth then
    begin

      Len := Length(Source);
      for I := 1 to Len do
      begin

        str := Copy(Source, 1, (Len - I));
        str := str + '..';

        if Canvas.TextWidth(str) < (WantWidth - 4) then
        begin
          Result := CutHalfCode(str);
          exit;
        end;

      end;

      Result := CutHalfCode(Copy(Source, 1, 2)) + '..';
      exit;

    end;

  Result := Source;

end;

function DuplicateBitmap(bitmap: TBitmap): HBitmap;
var
  hbmpOldSrc, hbmpOldDest, hbmpNew: HBitmap;
  hdcSrc, hdcDest: hdc;

begin
  hdcSrc := CreateCompatibleDC(0);
  hdcDest := CreateCompatibleDC(hdcSrc);

  hbmpOldSrc := SelectObject(hdcSrc, bitmap.Handle);

  hbmpNew := CreateCompatibleBitmap(hdcSrc, bitmap.Width, bitmap.Height);

  hbmpOldDest := SelectObject(hdcDest, hbmpNew);

  BitBlt(hdcDest, 0, 0, bitmap.Width, bitmap.Height, hdcSrc, 0, 0,
    SRCCOPY);

  SelectObject(hdcDest, hbmpOldDest);
  SelectObject(hdcSrc, hbmpOldSrc);

  DeleteDC(hdcDest);
  DeleteDC(hdcSrc);

  Result := hbmpNew;
end;

procedure SpliteBitmap(DC: hdc; x, y: Integer; bitmap: TBitmap; transcolor:
  TColor);
var
  hdcMixBuffer, hdcBackMask, hdcForeMask, hdcCopy: hdc;
  hOld, hbmCopy, hbmMixBuffer, hbmBackMask, hbmForeMask: HBitmap;
  oldColor: TColor;
begin

  {UnrealizeObject (DC);}
(*   SelectPalette (DC, bitmap.Palette, FALSE);
  RealizePalette (DC);
 *)

  hbmCopy := DuplicateBitmap(bitmap);
  hdcCopy := CreateCompatibleDC(DC);
  hOld := SelectObject(hdcCopy, hbmCopy);

  hdcBackMask := CreateCompatibleDC(DC);
  hdcForeMask := CreateCompatibleDC(DC);
  hdcMixBuffer := CreateCompatibleDC(DC);

  hbmBackMask := CreateBitmap(bitmap.Width, bitmap.Height, 1, 1, nil);
  hbmForeMask := CreateBitmap(bitmap.Width, bitmap.Height, 1, 1, nil);
  hbmMixBuffer := CreateCompatibleBitmap(DC, bitmap.Width, bitmap.Height);

  SelectObject(hdcBackMask, hbmBackMask);
  SelectObject(hdcForeMask, hbmForeMask);
  SelectObject(hdcMixBuffer, hbmMixBuffer);

  oldColor := SetBkColor(hdcCopy, transcolor); //clWhite);

  BitBlt(hdcForeMask, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0,
    SRCCOPY);

  SetBkColor(hdcCopy, oldColor);

  BitBlt(hdcBackMask, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0, 0,
    NOTSRCCOPY);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, DC, x, y, SRCCOPY);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0, 0,
    SRCAND);

  BitBlt(hdcCopy, 0, 0, bitmap.Width, bitmap.Height, hdcBackMask, 0, 0, SRCAND);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0,
    SRCPAINT);

  BitBlt(DC, x, y, bitmap.Width, bitmap.Height, hdcMixBuffer, 0, 0, SRCCOPY);

  {DeleteObject (hbmCopy);}
  DeleteObject(SelectObject(hdcCopy, hOld));
  DeleteObject(SelectObject(hdcForeMask, hOld));
  DeleteObject(SelectObject(hdcBackMask, hOld));
  DeleteObject(SelectObject(hdcMixBuffer, hOld));

  DeleteDC(hdcCopy);
  DeleteDC(hdcForeMask);
  DeleteDC(hdcBackMask);
  DeleteDC(hdcMixBuffer);

end;

function TagCount(Source: string; Tag: Char): Integer;
var
  I, tCount: Integer;
begin
  tCount := 0;
  for I := 1 to Length(Source) do
    if Source[I] = Tag then
      Inc(tCount);
  Result := tCount;
end;

{ "xxxxxx" => xxxxxx }

function TakeOffTag(Src: string; Tag: Char; var rstr: string): string;
var
  I, n2: Integer;
begin
  n2 := Pos(Tag, Copy(Src, 2, Length(Src)));
  rstr := Copy(Src, 2, n2 - 1);
  Result := Copy(Src, n2 + 2, Length(Src) - n2);
end;

function CatchString(Source: string; cap: Char; var catched: string): string;
var
  n: Integer;
begin
  Result := '';
  catched := '';
  if Source = '' then
    exit;
  if Length(Source) < 2 then
  begin
    Result := Source;
    exit;
  end;
  if Source[1] = cap then
  begin
    if Source[2] = cap then //##abc#
      Source := Copy(Source, 2, Length(Source));
    if TagCount(Source, cap) >= 2 then
    begin
      Result := TakeOffTag(Source, cap, catched);
    end
    else
      Result := Source;
  end
  else
  begin
    if TagCount(Source, cap) >= 2 then
    begin
      n := Pos(cap, Source);
      Source := Copy(Source, n, Length(Source));
      Result := TakeOffTag(Source, cap, catched);
    end
    else
      Result := Source;
  end;
end;

{ GetValidStr3¿Í ´Þ¸® ½Äº°ÀÚ°¡ ¿¬¼ÓÀ¸·Î ³ª¿Ã°æ¿ì Ã³¸® ¾ÈµÊ }
{ ½Äº°ÀÚ°¡ ¾øÀ» °æ¿ì, nil ¸®ÅÏ.. }

function DivString(Source: string; cap: Char; var sel: string): string;
var
  n: Integer;
begin
  if Source = '' then
  begin
    sel := '';
    Result := '';
    exit;
  end;
  n := Pos(cap, Source);
  if n > 0 then
  begin
    sel := Copy(Source, 1, n - 1);
    Result := Copy(Source, n + 1, Length(Source));
  end
  else
  begin
    sel := Source;
    Result := '';
  end;
end;

function DivTailString(Source: string; cap: Char; var sel: string): string;
var
  I, n: Integer;
begin
  if Source = '' then
  begin
    sel := '';
    Result := '';
    exit;
  end;
  n := 0;
  for I := Length(Source) downto 1 do
    if Source[I] = cap then
    begin
      n := I;
      break;
    end;
  if n > 0 then
  begin
    sel := Copy(Source, n + 1, Length(Source));
    Result := Copy(Source, 1, n - 1);
  end
  else
  begin
    sel := '';
    Result := Source;
  end;
end;

function SPos(substr, str: string): Integer;
var
  I, j, Len, slen: Integer;
  flag: Boolean;
begin
  Result := -1;
  Len := Length(str);
  slen := Length(substr);
  for I := 0 to Len - slen do
  begin
    flag := True;
    for j := 1 to slen do
    begin
      if Byte(str[I + j]) >= $B0 then
      begin
        if (j < slen) and (I + j < Len) then
        begin
          if substr[j] <> str[I + j] then
          begin
            flag := False;
            break;
          end;
          if substr[j + 1] <> str[I + j + 1] then
          begin
            flag := False;
            break;
          end;
        end
        else
          flag := False;
      end
      else if substr[j] <> str[I + j] then
      begin
        flag := False;
        break;
      end;
    end;
    if flag then
    begin
      Result := I + 1;
      break;
    end;
  end;
end;

function NumCopy(str: string): Integer;
var
  I: Integer;
  Data: string;
begin
  Data := '';
  for I := 1 to Length(str) do
  begin
    if (Word('0') <= Word(str[I])) and (Word('9') >= Word(str[I])) then
    begin
      Data := Data + str[I];
    end
    else
      break;
  end;
  Result := Str_ToInt(Data, 0);
end;

function GetMonDay: string;
var
  Year, mon, Day: Word;
  str: string;
begin
  DecodeDate(Date, Year, mon, Day);
  str := IntToStr(Year);
  if mon < 10 then
    str := str + '0' + IntToStr(mon)
  else
    str := IntToStr(mon);
  if Day < 10 then
    str := str + '0' + IntToStr(Day)
  else
    str := IntToStr(Day);
  Result := str;
end;

function BoolToStr(boo: Boolean): string;
begin
  if boo then
    Result := 'TRUE'
  else
    Result := 'FALSE';
end;

function BoolToCStr(boo: Boolean): string;
begin
  if boo then
    Result := 'ÊÇ'
  else
    Result := '·ñ';
end;

function IntToSex(INT: Integer): string;
begin
  case INT of //
    0: Result := 'ÄÐ';
    1: Result := 'Å®';
  else
    begin
      Result := '??';
    end;
  end;
end;

function IntToJob(INT: Integer): string;
begin
  case INT of //
    0: Result := 'ÎäÊ¿';
    1: Result := 'Ä§·¨Ê¦';
    2: Result := 'µÀÊ¿';
  else
    begin
      Result := '??';
    end;
  end;
end;

function BoolToIntStr(boo: Boolean): string;
begin
  if boo then
    Result := '1'
  else
    Result := '0';
end;

function _MIN(n1, n2: Integer): Integer;
begin
  if n1 < n2 then
    Result := n1
  else
    Result := n2;
end;

function _MAX(n1, n2: Integer): Integer;
begin
  if n1 > n2 then
    Result := n1
  else
    Result := n2;
end;

function _MAX1(n1, n2: Integer): Integer;
begin
  if n1 > n2 then
    Result := n1
  else
    Result := n2;
  if Result > 65535 then
    Result := 65535;
end;
//È¡µÃ¶þ¸öÈÕÆÚÖ®¼äÏà²îÌìÊý

function GetDayCount(MaxDate, MinDate: TDateTime): Integer;
var
  YearMax, MonthMax, DayMax: Word;
  YearMin, MonthMin, DayMin: Word;
begin
  Result := 0;
  if MaxDate < MinDate then
    exit;
  DecodeDate(MaxDate, YearMax, MonthMax, DayMax);
  DecodeDate(MinDate, YearMin, MonthMin, DayMin);
  Dec(YearMax, YearMin);
  YearMin := 0;
  Result := (YearMax * 12 * 30 + MonthMax * 30 + DayMax) - (YearMin * 12 * 30 +
    MonthMin * 30 + DayMin);
end;

function GetCodeMsgSize(x: Double): Integer;
begin
  if INT(x) < x then
    Result := Trunc(x) + 1
  else
    Result := Trunc(x)
end;

end.
