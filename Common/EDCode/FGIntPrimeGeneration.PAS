unit FGIntPrimeGeneration;

interface

uses Windows, SysUtils, Controls, FGInt;

procedure PrimeSearch(var GInt: TFGInt);

implementation

{$H+}

// Does an incremental search for primes starting from GInt,
// when one is found, it is stored in GInt

procedure PrimeSearch(var GInt: TFGInt);
var
  temp, two                 : TFGInt;
  ok                        : Boolean;
begin
  if (GInt.Number[1] mod 2) = 0 then GInt.Number[1] := GInt.Number[1] + 1;
  Base10StringToFGInt('2', two);
  ok := false;
  while not ok do begin
    FGIntAdd(GInt, two, temp);
    FGIntCopy(temp, GInt);
    FGIntPrimeTest(GInt, 4, ok);
  end;
  FGIntDestroy(two);
end;

end.

