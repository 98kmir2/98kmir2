unit EDcode;

interface

uses
  Windows, SysUtils, Grobal2;

function EncodeMessage(sMsg: TDefaultMessage): string;
function DecodeMessage(Str: string): TDefaultMessage;
function EncodeString(Str: string): string;
function DecodeString(Str: string): string;
function EncodeBuffer(buf: PChar; bufsize: Integer): string;
function EncodeBuffer2(buf: PChar; bufsize: Integer): string;
procedure DecodeBuffer(src: string; buf: PChar; bufsize: Integer);
procedure DecodeBuffer2(src: string; buf: PChar; bufsize: Integer);
procedure Decode6BitBuf(sSource: PChar; pBuf: PChar; nSrcLen, nBufLen: Integer);
procedure Encode6BitBuf(pSrc, PDest: PChar; nSrcLen, nDestLen: Integer);
procedure Decode8BitBuf(sSource: PChar; pBuf: PChar; nSrcLen, nBufLen: Integer);
procedure Encode8BitBuf(pSrc, PDest: PChar; nSrcLen, nDestLen: Integer);
function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage;
function EncodeBuf(buf, len, DstBuf: Integer): Integer;
function DeCodeBuf(buf, len, DstBuf: Integer): Integer;

implementation

uses
  HUtil32;

function EncodeBuf(buf, len, DstBuf: Integer): Integer;
var
  no, i: Integer;
  temp, remainder, c, bySeed, byBase: Byte;
  RPos: Integer;
begin
  if (len = 0) or (PChar(buf) = nil) then
  begin
    Result := 0;
    Exit;
  end;

  no := 2;
  remainder := 0;
  RPos := DstBuf;

  bySeed := $AC;
  byBase := $3C;

  for i := 0 to len - 1 do
  begin
    c := pByte(buf)^ xor bySeed;
    Inc(buf);
    if no = 6 then
    begin
      PChar(DstBuf)^ := Chr((c and $3F) + byBase);
      Inc(DstBuf);
      remainder := remainder or ((c shr 2) and $30);
      PChar(DstBuf)^ := Chr(remainder + byBase);
      Inc(DstBuf);
      remainder := 0;
    end
    else
    begin
      temp := c shr 2;
      PChar(DstBuf)^ := Chr(((temp and $3C) or (c and $3)) + byBase);
      Inc(DstBuf);
      remainder := (remainder shl 2) or (temp and $3);
    end;
    no := no mod 6 + 2;
  end;
  if no <> 2 then
  begin
    PChar(DstBuf)^ := Chr(remainder + byBase);
    Inc(DstBuf);
  end;
  Result := DstBuf - RPos;
  PChar(DstBuf)^ := #0;
end;

function DeCodeBuf(buf, len, DstBuf: Integer): Integer;
var
  nCycles, nBytesLeft, i, CurCycleBegin: Integer;
  temp, remainder, c, bySeed, byBase: Byte;
  RPos: Integer;
begin
  if (len = 0) or (PChar(buf) = nil) then
  begin
    Result := 0;
    Exit;
  end;

  RPos := DstBuf;
  nCycles := len div 4;
  nBytesLeft := len mod 4;

  bySeed := $AC;
  byBase := $3C;

  for i := 0 to nCycles - 1 do
  begin
    CurCycleBegin := i * 4;
    remainder := pByte(buf + CurCycleBegin + 3)^ - byBase;
    temp := pByte(buf + CurCycleBegin)^ - byBase;
    c := ((temp shl 2) and $F0) or (remainder and $0C) or (temp and $3);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
    temp := pByte(buf + CurCycleBegin + 1)^ - byBase;
    c := ((temp shl 2) and $F0) or ((remainder shl 2) and $0C) or (temp and $3);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
    temp := pByte(buf + CurCycleBegin + 2)^ - byBase;
    c := temp or ((remainder shl 2) and $C0);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
  end;
  if nBytesLeft = 2 then
  begin
    remainder := pByte(buf + len - 1)^ - byBase;
    temp := pByte(buf + len - 2)^ - byBase;
    c := ((temp shl 2) and $F0) or ((remainder shl 2) and $0C) or (temp and $3);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
  end
  else if nBytesLeft = 3 then
  begin
    remainder := pByte(buf + len - 1)^ - byBase;
    temp := pByte(buf + len - 3)^ - byBase;
    c := ((temp shl 2) and $F0) or (remainder and $0C) or (temp and $3);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
    temp := pByte(buf + len - 2)^ - byBase;
    c := ((temp shl 2) and $F0) or ((remainder shl 2) and $0C) or (temp and $3);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
  end;
  Result := DstBuf - RPos;
  PChar(DstBuf)^ := #0;
end;

function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage;
begin
  Result.Recog := nRecog;
  Result.Ident := wIdent;
  Result.Param := wParam;
  Result.Tag := wTag;
  Result.Series := wSeries;
end;

procedure Encode6BitBuf(pSrc, PDest: PChar; nSrcLen, nDestLen: Integer);
var
  i, nRestCount, nDestPos: Integer;
  btMade, btCh, btRest: Byte;
begin
  nRestCount := 0;
  btRest := 0;
  nDestPos := 0;
  for i := 0 to nSrcLen - 1 do
  begin
    if nDestPos >= nDestLen then
      Break;
    btCh := Byte(pSrc[i]);
    btMade := Byte((btRest or (btCh shr (2 + nRestCount))) and $3F);
    btRest := Byte(((btCh shl (8 - (2 + nRestCount))) shr 2) and $3F);
    Inc(nRestCount, 2);
    if nRestCount < 6 then
    begin
      PDest[nDestPos] := Char(btMade + $3C);
      Inc(nDestPos);
    end
    else
    begin
      if nDestPos < nDestLen - 1 then
      begin
        PDest[nDestPos] := Char(btMade + $3C);
        PDest[nDestPos + 1] := Char(btRest + $3C);
        Inc(nDestPos, 2);
      end
      else
      begin
        PDest[nDestPos] := Char(btMade + $3C);
        Inc(nDestPos);
      end;
      nRestCount := 0;
      btRest := 0;
    end;
  end;
  if nRestCount > 0 then
  begin
    PDest[nDestPos] := Char(btRest + $3C);
    Inc(nDestPos);
  end;
  PDest[nDestPos] := #0;
end;

procedure Decode6BitBuf(sSource: PChar; pBuf: PChar; nSrcLen, nBufLen: Integer);
const
  Masks: array[2..6] of Byte = ($FC, $F8, $F0, $E0, $C0);
var
  i, {nLen,} nBitPos, nMadeBit, nBufPos: Integer;
  btCh, btTmp, btByte: Byte;
begin
  nBitPos := 2;
  nMadeBit := 0;
  nBufPos := 0;
  btTmp := 0;
  btCh := 0;
  for i := 0 to nSrcLen - 1 do
  begin
    if Integer(sSource[i]) - $3C >= 0 then
      btCh := Byte(sSource[i]) - $3C
    else
    begin
      nBufPos := 0;
      Break;
    end;
    if nBufPos >= nBufLen then
      Break;
    if (nMadeBit + 6) >= 8 then
    begin
      btByte := Byte(btTmp or ((btCh and $3F) shr (6 - nBitPos)));
      pBuf[nBufPos] := Char(btByte);
      Inc(nBufPos);
      nMadeBit := 0;
      if nBitPos < 6 then
        Inc(nBitPos, 2)
      else
      begin
        nBitPos := 2;
        Continue;
      end;
    end;
    btTmp := Byte(Byte(btCh shl nBitPos) and Masks[nBitPos]);
    Inc(nMadeBit, 8 - nBitPos);
  end;
  pBuf[nBufPos] := #0;
end;

function DecodeMessage(Str: string): TDefaultMessage;
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
  Msg: TDefaultMessage;
begin
  if Str = '' then
  begin
    FillChar(Msg, SizeOf(Msg), 0);
    Result := Msg;
    Exit;
  end;
  DeCodeBuf(Integer(PChar(Str)), Length(Str), Integer(@EncBuf));
  Move(EncBuf, Msg, SizeOf(TDefaultMessage));
  Result := Msg;
end;

function DecodeString(Str: string): string;
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
begin
  if Str = '' then
  begin
    Result := '';
    Exit;
  end;
  DeCodeBuf(Integer(PChar(Str)), Length(Str), Integer(@EncBuf));
  Result := StrPas(EncBuf);
end;

procedure DecodeBuffer(src: string; buf: PChar; bufsize: Integer);
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
begin
  if src = '' then
  begin
    Exit;
  end;
  DeCodeBuf(Integer(PChar(src)), Length(src), Integer(@EncBuf));
  Move(EncBuf, buf^, bufsize);
end;

procedure DecodeBuffer2(src: string; buf: PChar; bufsize: Integer);
var
  EncBuf: array[0..BUFFERSIZE * 2 - 1] of Char;
begin
  DeCodeBuf(Integer(PChar(src)), Length(src), Integer(@EncBuf));
  Move(EncBuf, buf^, bufsize);
end;

function EncodeMessage(sMsg: TDefaultMessage): string;
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
begin
  EncodeBuf(Integer(@sMsg), SizeOf(TDefaultMessage), Integer(@EncBuf));
  Result := StrPas(EncBuf);
end;

function EncodeString(Str: string): string;
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
begin
  if Str = '' then
  begin
    Result := '';
    Exit;
  end;

  EncodeBuf(Integer(PChar(Str)), Length(Str), Integer(@EncBuf));
  Result := StrPas(EncBuf);
end;

function EncodeBuffer(buf: PChar; bufsize: Integer): string;
var
  EncBuf, TempBuf: array[0..BUFFERSIZE - 1] of Char;
begin
  Result := '';

  if (buf = nil) or (bufsize = 0) then Exit;

  if bufsize < BUFFERSIZE then
  begin
    Move(buf^, TempBuf, bufsize);
    EncodeBuf(Integer(@TempBuf), bufsize, Integer(@EncBuf));
    Result := StrPas(EncBuf);
  end;
end;

function EncodeBuffer2(buf: PChar; bufsize: Integer): string;
var
  EncBuf, TempBuf: array[0..BUFFERSIZE * 2 - 1] of Char;
begin
  Result := '';
  if (buf = nil) or (bufsize = 0) then Exit;

  if bufsize < BUFFERSIZE * 2 then
  begin
    Move(buf^, TempBuf, bufsize);
    EncodeBuf(Integer(@TempBuf), bufsize, Integer(@EncBuf));
    Result := StrPas(EncBuf);
  end;
end;

procedure Encode8BitBuf(pSrc, PDest: PChar; nSrcLen, nDestLen: Integer);
var
  i, nRestCount, nDestPos: Integer;
  btMade, btCh, btRest: Byte;
begin
  nRestCount := 0;
  btRest := 0;
  nDestPos := 0;
  for i := 0 to nSrcLen - 1 do
  begin
    if nDestPos >= nDestLen then
      Break;
    btCh := Byte(pSrc[i]);
    btMade := Byte((btRest or (btCh shr (2 + nRestCount))) and $3F);
    btRest := Byte(((btCh shl (8 - (2 + nRestCount))) shr 2) and $3F);
    Inc(nRestCount, 2);
    if nRestCount < 6 then
    begin
      PDest[nDestPos] := Char(btMade + $23);
      Inc(nDestPos, 1);
    end
    else
    begin
      if nDestPos < nDestLen - 1 then
      begin
        PDest[nDestPos] := Char(btMade + $23);
        PDest[nDestPos + 1] := Char(btRest + $23);
        Inc(nDestPos, 2);
      end
      else
      begin
        PDest[nDestPos] := Char(btMade + $23);
        Inc(nDestPos, 1);
      end;
      nRestCount := 0;
      btRest := 0;
    end;
  end;
  if nRestCount > 0 then
  begin
    PDest[nDestPos] := Char(btRest + $23);
    Inc(nDestPos, 1);
  end;
  PDest[nDestPos] := #0;
end;

procedure Decode8BitBuf(sSource: PChar; pBuf: PChar; nSrcLen, nBufLen: Integer);
const
  Masks: array[2..6] of Byte = ($FC, $F8, $F0, $E0, $C0);
var
  i, nBitPos, nMadeBit, nBufPos: Integer;
  btCh, btTmp, btByte: Byte;
begin
  nBitPos := 2;
  nMadeBit := 0;
  nBufPos := 0;
  btTmp := 0;
  btCh := 0;
  for i := 0 to nSrcLen - 1 do
  begin
    if Integer(sSource[i]) - $23 >= 0 then
      btCh := Byte(sSource[i]) - $23
    else
    begin
      nBufPos := 0;
      Break;
    end;
    if nBufPos >= nBufLen then
      Break;
    if (nMadeBit + 6) >= 8 then
    begin
      btByte := Byte(btTmp or ((btCh and $3F) shr (6 - nBitPos)));
      pBuf[nBufPos] := Char(btByte);
      Inc(nBufPos, 1);
      nMadeBit := 0;
      if nBitPos < 6 then
        Inc(nBitPos, 2)
      else
      begin
        nBitPos := 2;
        Continue;
      end;
    end;
    btTmp := Byte(Byte(btCh shl nBitPos) and Masks[nBitPos]);
    Inc(nMadeBit, 8 - nBitPos);
  end;
  pBuf[nBufPos] := #0;
end;

end.
