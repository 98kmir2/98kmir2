unit SELicenseSDK;

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses
  Windows;

type

  sSELicenseUserInfoA = record
    UserID: array[0..255] of AnsiChar;
    Remarks: array[0..1023] of AnsiChar;
    LicenseDate: SYSTEMTIME;
  end;

  sSELicenseUserInfoW = record
    UserID: array[0..255] of WideChar;
    Remarks: array[0..1023] of WideChar;
    LicenseDate: SYSTEMTIME;
  end;

  sSELicenseTrialInfo = record
    NumDays: Integer;
    NumExec: Integer;
    ExpDate: SYSTEMTIME;
    CountryId: Integer;
    ExecTime: Integer;
    TotalExecTime: Integer;
  end;

  sSELicenseHashInfo = record
    Hash: array[0..15] of Char;
  end;

const

  SE_ERR_SUCCESS = 0;
  SE_ERR_INTERNAL_ERROR = 1;
  SE_ERR_TOOL_DETECTION = 2;
  SE_ERR_CHECKSUM_FAILED = 3;
  SE_ERR_VIRTUALIZATION_FOUND = 4;
  SE_ERR_LICENSE_NOT_FOUND = 5;
  SE_ERR_LICENSE_CORRUPTED = 6;
  SE_ERR_LICENSE_FILE_MISMATCH = 7;
  SE_ERR_LICENSE_HARDWARE_ID_MISMATCH = 8;

  SE_ERR_LICENSE_DAYS_EXPIRED = 9;
  SE_ERR_LICENSE_EXEC_EXPIRED = 10;
  SE_ERR_LICENSE_DATE_EXPIRED = 11;
  SE_ERR_LICENSE_COUNTRY_ID_MISMATCH = 12;
  SE_ERR_LICENSE_NO_MORE_EXEC_TIME = 13;
  SE_ERR_LICENSE_NO_MORE_TOTALEXEC_TIME = 14;
  SE_ERR_LICENSE_BANNED = 15;
  SE_ERR_SERVER_ERROR = 16;

  SE_STATUS_INIT = 0;
  SE_STATUS_NORMAL = 1;

  SELicenseDLL = 'SESDKDummy.DLL';


function SEGetNumExecUsed(): Integer; stdcall; external SELicenseDLL name 'SEGetNumExecUsed';
function SEGetNumExecLeft(): Integer; stdcall; external SELicenseDLL name 'SEGetNumExecLeft';
function SESetNumExecUsed(Num: Integer): Integer; stdcall; external SELicenseDLL name 'SESetNumExecUsed';

function SEGetExecTimeUsed(): Integer; stdcall; external SELicenseDLL name 'SEGetExecTimeUsed';
function SEGetExecTimeLeft(): Integer; stdcall; external SELicenseDLL name 'SEGetExecTimeLeft';
function SESetExecTime(Num: Integer): Integer; stdcall; external SELicenseDLL name 'SESetExecTime';

function SEGetTotalExecTimeUsed(): Integer; stdcall; external SELicenseDLL name 'SEGetTotalExecTimeUsed';
function SEGetTotalExecTimeLeft(): Integer; stdcall; external SELicenseDLL name 'SEGetTotalExecTimeLeft';
function SESetTotalExecTime(Num: Integer): Integer; stdcall; external SELicenseDLL name 'SESetTotalExecTime';

function SEGetNumDaysUsed(): Integer; stdcall; external SELicenseDLL name 'SEGetNumDaysUsed';
function SEGetNumDaysLeft(): Integer; stdcall; external SELicenseDLL name 'SEGetNumDaysLeft';

function SECheckHardwareID(): Integer; stdcall; external SELicenseDLL name 'SECheckHardwareID';
function SECheckExpDate(): Integer; stdcall; external SELicenseDLL name 'SECheckExpDate';
function SECheckExecTime(): Integer; stdcall; external SELicenseDLL name 'SECheckExecTime';
function SECheckCountryID(): Integer; stdcall; external SELicenseDLL name 'SECheckCountryID';

function SEGetLicenseUserInfoA(var UserInfo: sSELicenseUserInfoA): Integer; stdcall; external SELicenseDLL name 'SEGetLicenseUserInfoA';
function SEGetLicenseUserInfoW(var UserInfo: sSELicenseUserInfoW): Integer; stdcall; external SELicenseDLL name 'SEGetLicenseUserInfoW';
function SEGetLicenseTrialInfo(var TrialInfo: sSELicenseTrialInfo): Integer; stdcall; external SELicenseDLL name 'SEGetLicenseTrialInfo';
function SEGetHardwareIDA(pBuf: PAnsiChar; MaxChars: Integer): Integer; stdcall; external SELicenseDLL name 'SEGetHardwareIDA';
function SEGetHardwareIDW(pBuf: PWideChar; MaxWChars: Integer): Integer; stdcall; external SELicenseDLL name 'SEGetHardwareIDW';
function SECheckLicenseFileA(pLicenseFileName: PAnsiChar): Integer; stdcall; external SELicenseDLL name 'SECheckLicenseFileA';
function SECheckLicenseFileW(pLicenseFileName: PWideChar): Integer; stdcall; external SELicenseDLL name 'SECheckLicenseFileW';
function SECheckLicenseFileEx(pLicenseFile: PChar; Size: Integer): Integer; stdcall; external SELicenseDLL name 'SECheckLicenseFileEx';
function SEGetLicenseHash(pLicenseHash: PChar): Integer; stdcall; external SELicenseDLL name 'SEGetLicenseHash';

procedure SENotifyLicenseBanned(); stdcall; external SELicenseDLL name 'SENotifyLicenseBanned';

function SEResetTrial(): Integer; stdcall; external SELicenseDLL name 'SEResetTrial';

implementation

end.
