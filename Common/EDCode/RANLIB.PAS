unit RANLIB;

interface

{$LINK motrot.obj}
{$LINK mother32.obj}
{$LINK ranrot32.obj}

{declare external functions:}
procedure XRandomInit(seed: Integer); cdecl; external;
function XRandom(): Double; cdecl; external;
function XIRandom(Min: Integer; Max: Integer): Integer; cdecl; external;

procedure WRandomInit(seed: Integer); cdecl; external;
function WRandom(): Double; cdecl; external;
function WIRandom(Min: Integer; Max: Integer): Integer; cdecl; external;

procedure MRandomInit(seed: Integer); cdecl; external;
function MRandom(): Double; cdecl; external;

implementation

end.

