unit uTeaSet;
{@abstract(Pascal/Delphi implementation of TEA - Tiny Encryption Algorithm
           Algorithms: TEA, XTEA, BlockTEA, XXTEA)
@author(Nikolai Shokhirev <nikolai@shokhirev.com> <nikolai@u.arizona.edu>)
@created(April 04, 2004)
modified: May 05, 2004
modified: February 17, 2006 - corrected XTeaEncrypt/XTeaDecrypt
Thanks to Pedro Gimeno Fortea <parigalo@formauri.es>
last modified: February 7, 2007 - added the MIT license.
©Nikolai V. Shokhirev, 2004-2007

LICENSE
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
}

interface

uses
  math, SysUtils, Classes;

const
  Delta                     : LongWord = $9E3779B9;
  Lim32                     : Integer = 2147483648; // MaxInt32 +1
type
  TByte4 = array[0..3] of Byte; //   32-bit =   4-byte
  TLong2 = array[0..1] of LongWord; //   64-bit =   8-byte
  TByte8 = array[0..7] of Byte; //   64-bit =   8-byte
  TTeaKey = array[0..3] of LongWord; //  128-bit =  16-byte
  TLong2x2 = array[0..1] of TLong2; //  128-bit =  16-byte
  TByte16 = array[0..15] of Byte; //  128-bit =  16-byte
  TTeaData = array of LongWord; // n*32-bit = n*4-byte
  TLong2Data = array of TLong2; // n*64-bit = n*8-byte

// Algorithm: David Wheeler & Roger Needham, Cambridge University Computer Lab
// TEA:       http://www.cl.cam.ac.uk/ftp/papers/djw-rmn/djw-rmn-tea.html (1994)
procedure TeaEncrypt(var data: TLong2; const key: TTeaKey);
procedure TeaDecrypt(var data: TLong2; const key: TTeaKey);

// Algorithm: David Wheeler & Roger Needham, Cambridge University Computer Lab
// Block XTEA: http://www.cl.cam.ac.uk/ftp/users/djw3/xtea.ps (1997)
procedure XTeaEncrypt(var data: TLong2; const key: TTeaKey; N: LongWord = 32);
procedure XTeaDecrypt(var data: TLong2; const key: TTeaKey; N: LongWord = 32);

// Algorithm: David Wheeler & Roger Needham, Cambridge University Computer Lab
// Block TEA: http://www.cl.cam.ac.uk/ftp/users/djw3/xtea.ps (1997)
procedure BlockTeaEncrypt(data: TTeaData; const key: TTeaKey);
procedure BlockTeaDecrypt(data: TTeaData; const key: TTeaKey);

// Algorithm: David Wheeler & Roger Needham, Cambridge University Computer Lab
// XXTEA:     http://www.cl.cam.ac.uk/ftp/users/djw3/xxtea.ps (1998)
procedure XXTeaEncrypt(data: TTeaData; const key: TTeaKey);
procedure XXTeaDecrypt(data: TTeaData; const key: TTeaKey);

// comparison of TTeaKey type variables
function SameKey(const key1, key2: TTeaKey): boolean;
// random key generation
procedure RandKey(var key: TTeaKey);

// key := 0
procedure ClearKey(var key: TTeaKey);
// data := 0
procedure ClearData(var data: TTeaData);
// data2 := 0
procedure ClearLong2Data(var data2: TLong2Data);

// XXTeaEncrypt encryption of RandomKey with Masterkey into data[0..3]
procedure EncryptKey(const RandomKey: TTeaKey; var data: TTeaData;
  const MasterKey: TTeaKey);
// XXTeaDecrypt decryption of data[0..3] with Masterkey into RandomKey
procedure DecryptKey(var RandomKey: TTeaKey; const data: TTeaData;
  const MasterKey: TTeaKey);

// random Long2 generation
procedure RandLong2(var dat: TLong2);
// inc(Long2)
procedure IncLong2(var dat: TLong2);
// dec(Long2)
procedure DecLong2(var dat: TLong2);
// dat := 0
procedure ClearLong2(var dat: TLong2);
// result = dat1 XOR dat2
function XORLong2(dat1, dat2: TLong2): TLong2;

// Conversion routine  Key <- string
procedure StrToKey(const s: string; var key: TTeaKey);
// Conversion routine  string <- Key
function KeyToStr(const key: TTeaKey): string;

// Conversion routine  Long2 <- string
procedure StrToLong2(const s: string; var dat: TLong2);
// Conversion routine  string <- Long2
function Long2ToStr(const dat: TLong2): string;

// Conversion routine  Long2Data <- string
procedure StrToLong2Data(const s: string; var dat: TLong2Data; ExtraDim: Integer);
// Conversion routine  string <- Long2Data
function Long2DataToStr(const dat: TLong2Data): string;

// Conversion routine  Data <- string
procedure StrToData(const s: string; var data: TTeaData);
// Conversion routine  string <- Data
procedure DataToStr(var s: string; const data: TTeaData);

// data <- File
procedure LoadLong2Data(const FileName: string; var data2: TLong2Data; var aFileSize: Int64; ExtraDim: Integer);

procedure PCharToLong2Data(buffer: PChar; Len: Int64; var data2: TLong2Data; ExtraDim: Integer);

// File <- data
procedure SaveLong2Data(const FileName: string; const data2: TLong2Data; const aFileSize: Int64);

procedure Long2DataToPChar(buffer: PChar; var Len: Integer; const data2: TLong2Data; const aFileSize: Int64);

// Clear and delete file
function WipeFile(const FileName: string): boolean;

// reads a file of longword
procedure ReadData(const FileName: string; var data: TTeaData);
// writes a file of longword
procedure WriteData(const FileName: string; const data: TTeaData);

implementation

procedure TeaEncrypt(var data: TLong2; const key: TTeaKey);
var
  y, z, sum                 : LongWord;
  a                         : Byte;
begin
  y := data[0];
  z := data[1];
  sum := 0;
  for a := 0 to 31 do
  begin
{ c code:
      sum += delta;
      y += (z << 4)+key[0] ^ z+sum ^ (z >> 5)+key[1];
      z += (y << 4)+key[2] ^ y+sum ^ (y >> 5)+key[3];
}
    inc(sum, Delta);
    inc(y, ((z shl 4) + key[0]) xor (z + sum) xor ((z shr 5) + key[1]));
    inc(z, ((y shl 4) + key[2]) xor (y + sum) xor ((y shr 5) + key[3]));
  end;
  data[0] := y;
  data[1] := z
end;

procedure TeaDecrypt(var data: TLong2; const key: TTeaKey);
var
  y, z, sum                 : LongWord;
  a                         : Byte;
begin
  y := data[0];
  z := data[1];
  sum := Delta shl 5;
  for a := 0 to 31 do
  begin
{ c code:
      z -= (y << 4)+key[2] ^ y+sum ^ (y >> 5)+key[3];
      y -= (z << 4)+key[0] ^ z+sum ^ (z >> 5)+key[1];
      sum -= delta;
}
    Dec(z, ((y shl 4) + key[2]) xor (y + sum) xor ((y shr 5) + key[3]));
    Dec(y, ((z shl 4) + key[0]) xor (z + sum) xor ((z shr 5) + key[1]));
    Dec(sum, Delta);
  end;
  data[0] := y;
  data[1] := z
end;

procedure XTeaEncrypt(var data: TLong2; const key: TTeaKey; N: LongWord = 32);
var
  y, z, sum, limit          : LongWord;
begin
  y := data[0];
  z := data[1];
  sum := 0;
  limit := Delta * N;
  while sum <> limit do
  begin
{ c code:
      y += (z << 4 ^ z >> 5) + z ^ sum + key[sum&3];
      sum += delta;
      z += (y << 4 ^ y >> 5) + y ^ sum + key[sum>>11 & 3];
}
//    inc(y,((z shl 4) xor (z shr 5)) xor (sum+key[sum and 3]));
    inc(y, (((z shl 4) xor (z shr 5)) + z) xor (sum + key[sum and 3]));
    inc(sum, Delta);
//    inc(z,((y shl 4) xor (y shr 5)) xor (sum+key[(sum shr 11) and 3]));
    inc(z, (((y shl 4) xor (y shr 5)) + y) xor (sum + key[(sum shr 11) and 3]));
  end;
  data[0] := y;
  data[1] := z
end;

procedure XTeaDecrypt(var data: TLong2; const key: TTeaKey; N: LongWord = 32);
var
  y, z, sum                 : LongWord;
begin
  y := data[0];
  z := data[1];
  sum := Delta * N;
  while sum <> 0 do
  begin
{ c code:
      z -= (y << 4 ^ y >> 5) + y ^ sum + key[sum>>11 & 3];
      sum -= delta;
      y -= (z << 4 ^ z >> 5) + z ^ sum + key[sum&3];
}
//    dec(z,((y shl 4) xor (y shr 5)) xor (sum+key[(sum shr 11) and 3]));
    Dec(z, (((y shl 4) xor (y shr 5)) + y) xor (sum + key[(sum shr 11) and 3]));
    Dec(sum, Delta);
//    dec(y,((z shl 4) xor (z shr 5)) xor (sum+key[sum and 3]));
    Dec(y, (((z shl 4) xor (z shr 5)) + z) xor (sum + key[sum and 3]));
  end;
  data[0] := y;
  data[1] := z
end;

procedure BlockTeaEncrypt(data: TTeaData; const key: TTeaKey);
var
  z, y, sum, e, p           : LongWord;
  q, N                      : Integer;

  function mx: LongWord;
  begin
    result := (((z shl 4) xor (z shr 5)) + z) xor (key[(p and 3) xor e] + sum);
  end;

begin
  N := Length(data);
  q := 6 + 52 div N;
  z := data[N - 1];
  sum := 0;
  repeat
    inc(sum, Delta);
    e := (sum shr 2) and 3;
    for p := 0 to N - 1 do
    begin
      y := data[p];
      inc(y, mx);
      data[p] := y;
      z := y;
    end;
    Dec(q);
  until q = 0;
end;

procedure BlockTeaDecrypt(data: TTeaData; const key: TTeaKey);
var
  z, y, sum, e, p, q        : LongWord;
  N                         : Integer;

  function mx: LongWord;
  begin
    result := (((z shl 4) xor (z shr 5)) + z) xor (key[(p and 3) xor e] + sum);
  end;

begin
  N := Length(data);
  q := 6 + 52 div N;
  sum := q * Delta;
  while sum <> 0 do
  begin
    e := (sum shr 2) and 3;
    for p := N - 1 downto 1 do
    begin
      z := data[p - 1];
      y := data[p];
      Dec(y, mx);
      data[p] := y;
    end;
    z := data[N - 1];
    y := data[0];
    Dec(y, mx);
    data[0] := y;
    Dec(sum, Delta);
  end;
end;

procedure XXTeaEncrypt(data: TTeaData; const key: TTeaKey);
var
  z, y, x, sum, e, p        : LongWord;
  q, N                      : Integer;

  function mx: LongWord;
  begin
    result := (((z shr 5) xor (y shl 2)) + ((y shr 3) xor (z shl 4))) xor ((sum xor y) + (key[(p and 3) xor e] xor z));
  end;

begin
  N := Length(data);
  q := 6 + 52 div N;
  z := data[N - 1];
  y := data[0];
  sum := 0;
  repeat
    inc(sum, Delta);
    e := (sum shr 2) and 3;
    for p := 0 to N - 2 do
    begin
      y := data[p + 1];
      x := data[p];
      inc(x, mx);
      data[p] := x;
      z := x;
    end;
    y := data[0];
    x := data[N - 1];
    inc(x, mx);
    data[N - 1] := x;
    z := x;
    Dec(q);
  until q = 0;
end;

procedure XXTeaDecrypt(data: TTeaData; const key: TTeaKey);
var
  z, y, x, sum, e, p, q     : LongWord;
  N                         : Integer;

  function mx: LongWord;
  begin
    result := (((z shr 5) xor (y shl 2)) + ((y shr 3) xor (z shl 4))) xor ((sum xor y) + (key[(p and 3) xor e] xor z));
  end;

begin
  N := Length(data);
  q := 6 + 52 div N;
  z := data[N - 1];
  y := data[0];
  sum := q * Delta;
  while sum <> 0 do
  begin
    e := (sum shr 2) and 3;
    for p := N - 1 downto 1 do
    begin
      z := data[p - 1];
      x := data[p];
      Dec(x, mx);
      data[p] := x;
      y := x;
    end;
    z := data[N - 1];
    x := data[0];
    Dec(x, mx);
    data[0] := x;
    y := x;
    Dec(sum, Delta);
  end;
end;

function SameKey(const key1, key2: TTeaKey): boolean;
var
  i                         : Integer;
begin
  result := false;
  for i := 0 to 3 do
    if key1[i] <> key2[i] then
      Exit;
  result := true;
end;

procedure RandKey(var key: TTeaKey);
var
  i                         : Integer;
begin
  for i := 0 to 3 do
    key[i] := Random(Lim32);
end;

procedure ClearKey(var key: TTeaKey);
var
  i                         : Integer;
begin
  for i := 0 to 3 do
    key[i] := 0;
end;

procedure ClearData(var data: TTeaData);
var
  i                         : Integer;
begin
  for i := 0 to Length(data) - 1 do
    data[i] := 0;
end;

procedure ClearLong2Data(var data2: TLong2Data);
var
  i                         : Integer;
begin
  for i := 0 to Length(data2) - 1 do
    ClearLong2(data2[i]);
end;

procedure EncryptKey(const RandomKey: TTeaKey; var data: TTeaData;
  const MasterKey: TTeaKey);
var
  i                         : Integer;
begin
//  SetLength(data, 4);
  for i := 0 to 3 do
    data[i] := RandomKey[i];
  XXTeaEncrypt(data, MasterKey);
end;

procedure DecryptKey(var RandomKey: TTeaKey; const data: TTeaData;
  const MasterKey: TTeaKey);
var
  i                         : Integer;
begin
//  SetLength(data, 4);
  XXTeaDecrypt(data, MasterKey);
  for i := 0 to 3 do
    RandomKey[i] := data[i];
end;

procedure RandLong2(var dat: TLong2);
var
  i                         : Integer;
begin
  for i := 0 to 1 do
    dat[i] := Random(Lim32);
end;

procedure IncLong2(var dat: TLong2);
var
  i                         : Int64;
begin
  i := Int64(dat);
  i := i + 1;
  dat := TLong2(i);
end;

procedure DecLong2(var dat: TLong2);
var
  i                         : Int64;
begin
  i := Int64(dat);
  i := i - 1;
  dat := TLong2(i);
end;

procedure ClearLong2(var dat: TLong2);
var
  i                         : Integer;
begin
  for i := 0 to 7 do
  begin
    TByte8(dat)[i] := 0;
//    TByte8(dat[1])[i] := 0;
  end;
end;

function XORLong2(dat1, dat2: TLong2): TLong2;
var
  i                         : Integer;
begin
  for i := 0 to 1 do
    result[i] := dat1[i] xor dat2[i];
end;

procedure StrToLong2(const s: string; var dat: TLong2);
var
  sa, sb                    : AnsiString;
  i, N                      : Integer;
begin
  sa := AnsiString(s);
  sb := StringOfChar(' ', 8);
  N := Min(Length(sa), 8);
  for i := 1 to N do
    sb[i] := sa[i];
  for i := 1 to 8 do
    TByte8(dat)[i - 1] := Ord(sb[i]);
  sa := '';
  sb := '';
end;

function Long2ToStr(const dat: TLong2): string;
var
  s                         : AnsiString;
  i                         : Integer;
begin
  SetLength(s, 8);
  for i := 1 to 8 do
  begin
    s[i] := Chr(TByte8(dat)[i - 1]);
  end;
  result := s;
end;

// Conversion routine  Long2Data <- string

procedure StrToLong2Data(const s: string; var dat: TLong2Data; ExtraDim: Integer);
var
  sa, sb                    : AnsiString;
  i, N, j                   : Integer;
  ss                        : string;
begin
  sa := AnsiString(s);
  sb := StringOfChar(' ', Length(sa) mod 8);
  sa := sa + sb;
  N := Length(sa) div 8;
  SetLength(dat, N + ExtraDim);
  SetLength(ss, 8);
  for i := 0 to N - 1 do begin
    for j := 1 to 8 do
      ss[j] := sa[j + 8 * i];
    StrToLong2(ss, dat[i]);
  end;
  sa := '';
  sb := '';
end;

// Conversion routine  string <- Long2Data

function Long2DataToStr(const dat: TLong2Data): string;
var
  s, ss                     : AnsiString;
  i                         : Integer;
begin
  ss := '';
  for i := Low(dat) to High(dat) do
  begin
    s := Long2ToStr(dat[i]);
    ss := ss + s;
  end;
  result := ss;
end;

procedure StrToKey(const s: string; var key: TTeaKey);
var
  sa, sb                    : AnsiString;
  i, N                      : Integer;
begin
  sa := AnsiString(s);
  sb := StringOfChar(' ', 16);
  N := Min(Length(sa), 16);
  for i := 1 to N do
    sb[i] := sa[i];
  for i := 1 to 16 do
    TByte16(key)[i - 1] := Ord(sb[i]);
  sa := '';
  sb := '';
end;

function KeyToStr(const key: TTeaKey): string;
var
  s                         : AnsiString;
  i                         : Integer;
begin
  SetLength(s, 16);
  for i := 1 to 16 do
  begin
    s[i] := Chr(TByte16(key)[i - 1]);
  end;
  result := s;
end;

procedure StrToData(const s: string; var data: TTeaData);
var
  sa                        : AnsiString;
  i, N, m                   : Integer;
begin
  sa := AnsiString(s);
  N := Length(sa) div 4;
  m := Length(sa) mod 4;
  if m <> 0 then begin
    inc(N);
    sa := sa + StringOfChar(' ', m);
  end;
  if N < 2 then begin
    N := 2;
    sa := sa + StringOfChar(' ', 4);
  end;
  SetLength(data, N);
  for i := 0 to N - 1 do
    for m := 0 to 3 do
      TByte4(data[i])[m] := Ord(sa[i * 4 + m + 1]);
  sa := '';
end;

procedure DataToStr(var s: string; const data: TTeaData);
var
  sa                        : AnsiString;
  i, N, m                   : Integer;
  b                         : Byte;
begin
  N := Length(data);
  SetLength(sa, N * 4);
  for i := 0 to N - 1 do
    for m := 0 to 3 do
    begin
      b := TByte4(data[i])[m];
      sa[i * 4 + m + 1] := Chr(b);
    end;
  s := Trim(sa);
  sa := '';
end;

procedure LoadLong2Data(const FileName: string; var data2: TLong2Data; var aFileSize: Int64; ExtraDim: Integer);
var
  infile                    : TFileStream;
  L, i, j, m, dim           : Integer;
  buf                       : TByte8;
begin
  L := 8;
  m := L;
  try
    infile := TFileStream.Create(FileName, fmOpenRead);
    aFileSize := infile.Size;
    dim := (aFileSize + L - 1) div L;
    SetLength(data2, dim + ExtraDim);

    for i := 0 to dim - 1 do begin
      m := infile.Read(buf, L);
      data2[i] := TLong2(buf);
    end;
  finally
    infile.Free;
  end;

  for j := m to L - 1 do
    TByte8(data2[dim - 1])[j] := $0;

  if ExtraDim > 0 then
    for i := dim to Length(data2) - 1 do
      ClearLong2(data2[i]);
end;

procedure PCharToLong2Data(buffer: PChar; Len: Int64; var data2: TLong2Data; ExtraDim: Integer);
var
  ms                        : TMemoryStream;
  L, i, j, m, dim           : Integer;
  buf                       : TByte8;
begin
  L := 8;
  m := L;
  ms := TMemoryStream.Create;
  try
    ms.SetSize(Len);
    Move(buffer^, ms.Memory^, Len);
    ms.Seek(0, 0);
    dim := (Len + L - 1) div L;
    SetLength(data2, dim + ExtraDim);
    for i := 0 to dim - 1 do begin
      m := ms.Read(buf, L);
      data2[i] := TLong2(buf);
    end;
  finally
    ms.Free;
  end;

  for j := m to L - 1 do
    TByte8(data2[dim - 1])[j] := $0;

  if ExtraDim > 0 then
    for i := dim to Length(data2) - 1 do
      ClearLong2(data2[i]);
end;

procedure SaveLong2Data(const FileName: string; const data2: TLong2Data; const aFileSize: Int64);
var
  outfile                   : TFileStream;
  L, i, m, N, dim           : Integer;
  buf                       : TByte8;
begin
  L := 8;
  try
    outfile := TFileStream.Create(FileName, fmCreate);
    m := aFileSize mod L;
    if m = 0 then
      m := L;
    dim := (aFileSize + L - 1) div L;
    for i := 0 to dim - 1 do begin
      buf := TByte8(data2[i]);
      if (i = (dim - 1)) and (m <> 0) then N := m else N := L;
      outfile.Write(buf, N);
    end;
  finally
    outfile.Free;
  end;
end;

procedure Long2DataToPChar(buffer: PChar; var Len: Integer; const data2: TLong2Data; const aFileSize: Int64);
var
  L, i, m, N, dim           : Integer;
  buf                       : TByte8;
  ms                        : TMemoryStream;
begin
  L := 8;
  ms := TMemoryStream.Create;
  try
    m := aFileSize mod L;
    if m = 0 then
      m := L;
    dim := (aFileSize + L - 1) div L;
    for i := 0 to dim - 1 do begin
      buf := TByte8(data2[i]);
      if (i = (dim - 1)) and (m <> 0) then
        N := m
      else
        N := L;
      ms.Write(buf, N);
    end;
    Len := ms.Size;
    Move(ms.Memory^, buffer^, Len);
  finally
    ms.Free;
  end;
end;

function WipeFile(const FileName: string): boolean;
var
  outfile                   : TFileStream;
  L, i, m, N, dim           : Integer; // Int64;
  zero                      : TLong2;
  buf                       : TByte8;
  aFileSize                 : Int64;
begin
  L := 8;
  ClearLong2(zero);
  result := false;
  buf := TByte8(zero);
  try
    outfile := TFileStream.Create(FileName, fmOpenWrite);
    aFileSize := outfile.Size;
    m := aFileSize mod L;
    dim := (aFileSize + L - 1) div L;
    for i := 0 to dim - 1 do
    begin
      if (i = (dim - 1)) and (m <> 0) then N := m else N := L;
      outfile.Write(buf, N);
    end;
  finally
    outfile.Free;
  end;
  result := DeleteFile(FileName);
end;

procedure ReadData(const FileName: string; var data: TTeaData);
var
  i, N                      : Integer;
  ww                        : LongWord;
  wwf                       : file of LongWord;
begin
  try
    AssignFile(wwf, FileName);
    Reset(wwf);
    N := FileSize(wwf);
    SetLength(data, N);
    for i := 0 to N - 1 do
    begin
      Read(wwf, ww);
      data[i] := ww;
    end;
  finally
    CloseFile(wwf);
  end;
end;

procedure WriteData(const FileName: string; const data: TTeaData);
var
  i, N                      : Integer;
  ww                        : LongWord;
  wwf                       : file of LongWord;
begin
  try
    AssignFile(wwf, FileName);
    Rewrite(wwf);
    N := Length(data);
    for i := 0 to N - 1 do
    begin
      ww := data[i];
      Write(wwf, ww);
    end;
  finally
    CloseFile(wwf);
  end;
end;

end.

