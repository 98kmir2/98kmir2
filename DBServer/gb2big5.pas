unit gb2big5;

interface

function GBtoBIG5(value: string): string;
function BIG5toGB(value: string): string;

implementation

var
  BIG5Order                 : array[0..14757] of Word;
  GBOrder                   : array[0..8177] of Word;

function GBOffset(value: string): integer;
begin
  if length(value) >= 2 then
    Result := (Ord(value[1]) - 161) * 94 + (Ord(value[2]) - 161)
  else
    Result := -1;
end;

function BIG5Offset(value: string): integer;
begin
  if length(value) >= 2 then begin
    if (Ord(value[2]) >= 64) and (Ord(value[2]) <= 126) then
      Result := (Ord(value[1]) - 161) * 157 + (Ord(value[2]) - 64);
    if (Ord(value[2]) >= 161) and (Ord(value[2]) <= 254) then
      Result := (Ord(value[1]) - 161) * 157 + 63 + (Ord(value[2]) - 161);
  end
  else
    Result := -1;
end;

function WordToString(value: Word): string;
begin
  Result := Chr(Hi(value)) + Chr(Lo(value));
end;

function isBIG5(value: string): Boolean;
begin
  if (length(value) >= 2) then begin
    if (value[1] < #161) then
      Result := false
    else
      if ((value[2] >= #64) and (value[2] <= #126)) or ((value[2] >= #161) and (value[2] <= #254)) then
        Result := true
      else
        Result := false;
  end
  else
    Result := false;
end;

function isGB(value: string): Boolean;
begin
  if (length(value) >= 2) then begin
    if (value[1] <= #161) and (value[1] >= #247) then
      Result := false
    else
      if (value[2] <= #161) and (value[2] >= #254) then
        Result := false
      else
        Result := true;
  end
  else
    Result := true;
end;

function GBtoBIG5(value: string): string;
var
  leng, idx                 : integer;
  tmpStr                    : string[2];
  Offset                    : integer;
  output                    : string;
begin
  output := '';
  leng := length(value);
  idx := 1;
  while idx <= leng do begin
    tmpStr := value[idx] + value[idx + 1];
    if isGB(tmpStr) then begin
      Offset := GBOffset(tmpStr);
      if (Offset >= 0) and (Offset <= 8177) then begin
        output := output + WordToString(GBOrder[Offset]);
        inc(idx);
      end
      else
        output := output + value[idx];
    end
    else
      output := output + value[idx];

    inc(idx, 1);
  end;
  Result := output;
end;

function BIG5toGB(value: string): string;
var
  leng, idx                 : integer;
  tmpStr                    : string[2];
  output                    : string;
  Offset                    : integer;
begin
  output := '';
  leng := length(value);
  idx := 1;
  while idx <= leng do begin
    tmpStr := value[idx] + value[idx + 1];
    if isBIG5(tmpStr) then begin
      Offset := BIG5Offset(tmpStr);
      if (Offset >= 0) and (Offset <= 14757) then begin
        output := output + WordToString(BIG5Order[Offset]);
        inc(idx);
      end
      else
        output := output + value[idx];
    end
    else
      output := output + value[idx];

    inc(idx);
  end;
  Result := output;
end;

end.
