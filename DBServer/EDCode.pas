unit EDcode;

interface

uses
  Windows, SysUtils, Grobal2;
//function EncodeMessage(sMsg: TDefaultMessage): string; stdcall external PlugInName;
//function DecodeMessage(Str: string): TDefaultMessage; stdcall external PlugInName;
//function EncodeString(Str: string): string; stdcall external PlugInName;
//function DecodeString(Str: string): string; stdcall external PlugInName;
//function EncodeBuffer(buf: PChar; bufsize: Integer): string; stdcall external PlugInName;
//procedure DecodeBuffer(Src: string; buf: PChar; bufsize: Integer); stdcall external PlugInName;
//function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage; stdcall external PlugInName;

function EncodeMessage(sMsg: TDefaultMessage): string;
function DecodeMessage(Str: string): TDefaultMessage;
function EncodeString(Str: string): string;
function DecodeString(Str: string): string;
function EncodeBuffer(Buf: PChar; bufsize: Integer): string;
procedure DecodeBuffer(Src: string; Buf: PChar; bufsize: Integer);
procedure Decode6BitBuf(sSource: PChar; pBuf: PChar; nSrcLen, nBufLen: Integer);
procedure Encode6BitBuf(pSrc, pDest: PChar; nSrcLen, nDestLen: Integer);
function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage;

implementation

function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage;
begin
  Result.Recog := nRecog;
  Result.Ident := wIdent;
  Result.Param := wParam;
  Result.Tag := wTag;
  Result.Series := wSeries;
end;

procedure Encode6BitBuf(pSrc, pDest: PChar; nSrcLen, nDestLen: Integer);
var
  i, nRestCount, nDestPos   : Integer;
  btMade, btCh, btRest      : Byte;
begin
  nRestCount := 0;
  btRest := 0;
  nDestPos := 0;
  for i := 0 to nSrcLen - 1 do begin
    if nDestPos >= nDestLen then Break;
    btCh := Byte(pSrc[i]);
    btMade := Byte((btRest or (btCh shr (2 + nRestCount))) and $3F);
    btRest := Byte(((btCh shl (8 - (2 + nRestCount))) shr 2) and $3F);
    Inc(nRestCount, 2);
    if nRestCount < 6 then begin
      pDest[nDestPos] := Char(btMade + $3C);
      Inc(nDestPos);
    end else begin
      if nDestPos < nDestLen - 1 then begin
        pDest[nDestPos] := Char(btMade + $3C);
        pDest[nDestPos + 1] := Char(btRest + $3C);
        Inc(nDestPos, 2);
      end else begin
        pDest[nDestPos] := Char(btMade + $3C);
        Inc(nDestPos);
      end;
      nRestCount := 0;
      btRest := 0;
    end;
  end;
  if nRestCount > 0 then begin
    pDest[nDestPos] := Char(btRest + $3C);
    Inc(nDestPos);
  end;
  pDest[nDestPos] := #0;
end;

procedure Decode6BitBuf(sSource: PChar; pBuf: PChar; nSrcLen, nBufLen: Integer);
const
  Masks                     : array[2..6] of Byte = ($FC, $F8, $F0, $E0, $C0);
var
  i, {nLen,} nBitPos, nMadeBit, nBufPos: Integer;
  btCh, btTmp, btByte       : Byte;
begin
  nBitPos := 2;
  nMadeBit := 0;
  nBufPos := 0;
  btTmp := 0;
  for i := 0 to nSrcLen - 1 do begin
    if Integer(sSource[i]) - $3C >= 0 then
      btCh := Byte(sSource[i]) - $3C
    else begin
      nBufPos := 0;
      Break;
    end;
    if nBufPos >= nBufLen then Break;
    if (nMadeBit + 6) >= 8 then begin
      btByte := Byte(btTmp or ((btCh and $3F) shr (6 - nBitPos)));
      pBuf[nBufPos] := Char(btByte);
      Inc(nBufPos);
      nMadeBit := 0;
      if nBitPos < 6 then Inc(nBitPos, 2)
      else begin
        nBitPos := 2;
        Continue;
      end;
    end;
    btTmp := Byte(Byte(btCh shl nBitPos) and Masks[nBitPos]); // #### ##--
    Inc(nMadeBit, 8 - nBitPos);
  end;
  pBuf[nBufPos] := #0;
end;

function DecodeMessage(Str: string): TDefaultMessage;
var
  EncBuf                    : array[0..BUFFERSIZE - 1] of Char;
  Msg                       : TDefaultMessage;
begin
  Decode6BitBuf(PChar(Str), @EncBuf, Length(Str), SizeOf(EncBuf));
  Move(EncBuf, Msg, SizeOf(TDefaultMessage));
  Result := Msg;
end;

function DecodeString(Str: string): string;
var
  EncBuf                    : array[0..BUFFERSIZE - 1] of Char;
begin
  Decode6BitBuf(PChar(Str), @EncBuf, Length(Str), SizeOf(EncBuf));
  Result := StrPas(EncBuf);
end;

procedure DecodeBuffer(Src: string; Buf: PChar; bufsize: Integer);
var
  EncBuf                    : array[0..BUFFERSIZE - 1] of Char;
begin
  Decode6BitBuf(PChar(Src), @EncBuf, Length(Src), SizeOf(EncBuf));
  Move(EncBuf, Buf^, bufsize);
end;

function EncodeMessage(sMsg: TDefaultMessage): string;
var
  EncBuf, TempBuf           : array[0..BUFFERSIZE - 1] of Char;
begin
  Move(sMsg, TempBuf, SizeOf(TDefaultMessage));
  Encode6BitBuf(@TempBuf, @EncBuf, SizeOf(TDefaultMessage), SizeOf(EncBuf));
  Result := StrPas(EncBuf);
end;

function EncodeString(Str: string): string;
var
  EncBuf                    : array[0..BUFFERSIZE - 1] of Char;
begin
  Encode6BitBuf(PChar(Str), @EncBuf, Length(Str), SizeOf(EncBuf));
  Result := StrPas(EncBuf);
end;

function EncodeBuffer(Buf: PChar; bufsize: Integer): string;
var
  EncBuf, TempBuf           : array[0..BUFFERSIZE - 1] of Char;
begin
  if bufsize < BUFFERSIZE then begin
    Move(Buf^, TempBuf, bufsize);
    Encode6BitBuf(@TempBuf, @EncBuf, bufsize, SizeOf(EncBuf));
    Result := StrPas(EncBuf);
  end else Result := '';
end;

end.
