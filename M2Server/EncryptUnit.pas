unit EncryptUnit;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
type
  TBase64 = class(TObject)
  private
    FOStream: TStream;
    FIStream: TStream;
  public
    { 输入流 }
    property IStream: TStream read FIStream write FIStream;
    { 输出流 }
    property OStream: TStream read FOStream write FOStream;
    { 编码 }
    function Encode(Str: string): string;
    { 解码 }
    function Decode(Str: string): string;
  end;

implementation

const
  SBase64                   : string =
    '23456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz~#%&*+-';
  UnBase64                  : array[0..255] of Byte =
    (128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //, //0-15
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //  //16-31
    128, 128, 128, 58, 128, 59, 60, 128, 128, 128, 61, 62, 128, 63, 128, 128,
    //32-47
    128, 128, 0, 1, 2, 3, 4, 5, 6, 7, 128, 128, 128, 128, 128, 128, //48-63
    128, 8, 9, 10, 11, 12, 13, 14, 15, 128, 16, 17, 18, 19, 20, 128, //64-79
    21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 128, 128, 128, 128, 128, //80-95
    128, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 128, 43, 44, 45, //96-111
    46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 128, 128, 128, 57, 128, //112-127
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //128-143

    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //144-159
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //160-175
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //176-191
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //192-207
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //208-223
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //224-239
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128);                               //240-255

  { TBase64 }

function TBase64.Decode(Str: string): string;
var
  j, k, Len, Position       : Integer;
  b                         : Byte;
  W, Tmp                    : Byte;     //用于阅读流的临时变量
begin
  Result := '';
  if (Str <> '') then begin
    { 初始化}
    b := 0;
    j := 0;
    k := 2;
    Len := Length(Str);
    Tmp := Ord(Str[1]);
    Position := 1;
    while (Position <= Len) and (Char(Tmp) <> '.') do begin
      if j = 0 then begin
        b := UnBase64[Tmp];
        k := 2;
      end
      else begin
        W := UnBase64[Tmp] or ((b shl k) and $C0);
        Result := Result + Chr(W);
        Inc(k, 2);
      end;
      Inc(j);
      j := j and 3;
      Inc(Position);
      Tmp := Ord(Str[Position]);
    end;
  end;
end;

function TBase64.Encode(Str: string): string;
var
  SBuffer                   : array[1..4] of Byte;
  j, k, Len, Position       : Integer;
  b                         : Byte;
  Tmp                       : Byte;     {### 用于阅读流的临时变量 ###}
begin
  Result := '';
  if (Str <> '') then begin
    { 初始化 }
    Len := Length(Str);
    Tmp := Ord(Str[1]);
    Position := 1;
    b := 0;
    j := 2;
    k := 2;
    while (Position <= Len) do begin

      begin
        b := b or ((Tmp and $C0) shr k);
        Inc(k, 2);
        SBuffer[j] := Byte(SBase64[(Tmp and $3F) + 1]);
        Inc(j);
        if j > 4 then begin
          SBuffer[1] := Byte(SBase64[b + 1]);
          b := 0;
          j := 2;
          k := 2;
          Result := Result + Chr(SBuffer[1]);
        end;
      end;
    end;

    { 平整数据到 SBuffer }
    if j <> 2 then begin
      SBuffer[j] := Ord('.');
      SBuffer[1] := Byte(SBase64[b + 1]);
      for k := 1 to j do
        Result := Result + Chr(SBuffer[k]);
    end
    else begin
      SBuffer[1] := Ord('.');
      for k := 1 to j do
        Result := Result + Chr(SBuffer[k]);
    end;

  end;
end;

end.
