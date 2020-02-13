unit SESDK;

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses
  Windows;

const
  SE_STATUS_INIT = 0;
  SE_STATUS_NORMAL = 1;

  SESDKDLL = 'SESDKDummy.DLL';

function SECheckProtection(): LongBool; stdcall; external SESDKDLL name 'SECheckProtection';
function SEDecodeStringA(pStr: PAnsiChar): PAnsiChar; stdcall; external SESDKDLL name 'SEDecodeStringA';
function SEDecodeStringW(pStr: PWideChar): PWideChar; stdcall; external SESDKDLL name 'SEDecodeStringW';
procedure SEFreeString(pStr: Pointer); stdcall; external SESDKDLL name 'SEFreeString';
function SEGetAppStatus(): Integer; stdcall; external SESDKDLL name 'SEGetAppStatus';
procedure SEGetProtectionDate(pDate: PSYSTEMTIME); stdcall; external SESDKDLL name 'SEGetProtectionDate';

implementation

end.
