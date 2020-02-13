unit SEKeygenSDK;

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses
  Windows;

type

sSELicenseOptionsA = record
	UserID: array[0..255] of AnsiChar;
	Remarks: array[0..1023] of AnsiChar;
	LockHardwareID: LongBool;
	LockCPU: LongBool;
	LockMAC: LongBool;
	LockBIOS: LongBool;
	LockHDD: LongBool;
	HardwareID: array[0..255] of AnsiChar;
	NumDaysEn: LongBool;
	NumDays: Integer;
	NumExecEn: LongBool;
	NumExec: Integer;
	ExpDateEn: LongBool;
	ExpDate: SYSTEMTIME;
	CountryIdEn: LongBool;
	CountryId: Integer;
	ExecTimeEn: LongBool;
	ExecTime: Integer;
	TotalExecTimeEn: LongBool;
	TotalExecTime: Integer;
end;

sSELicenseOptionsW = record
	UserID: array[0..255] of WideChar;
	Remarks: array[0..1023] of WideChar;
	LockHardwareID: LongBool;
	LockCPU: LongBool;
	LockMAC: LongBool;
	LockBIOS: LongBool;
	LockHDD: LongBool;
	HardwareID: array[0..255] of WideChar;
	NumDaysEn: LongBool;
	NumDays: Integer;
	NumExecEn: LongBool;
	NumExec: Integer;
	ExpDateEn: LongBool;
	ExpDate: SYSTEMTIME;
	CountryIdEn: LongBool;
	CountryId: Integer;
	ExecTimeEn: LongBool;
	ExecTime: Integer;
	TotalExecTimeEn: LongBool;
	TotalExecTime: Integer;
end;

const

	SEKeygenDLL = 'SEKeygenSDK.DLL';


function SEGenerateKeyFileA(var Options: sSELicenseOptionsA; pOutputPath: PAnsiChar; MaxChars: Integer): LongBool; stdcall; external SEKeygenDLL name 'SEGenerateKeyFileA';
function SEGenerateKeyFileW(var Options: sSELicenseOptionsW; pOutputPath: PWideChar; MaxChars: Integer): LongBool; stdcall; external SEKeygenDLL name 'SEGenerateKeyFileW';
function SEGenerateKeyFileExA(var Options: sSELicenseOptionsA; pLicenseDat: PAnsiChar; pOutputPath: PAnsiChar; MaxChars: Integer): LongBool; stdcall; external SEKeygenDLL name 'SEGenerateKeyFileExA';
function SEGenerateKeyFileExW(var Options: sSELicenseOptionsW; pLicenseDat: PWideChar; pOutputPath: PWideChar; MaxChars: Integer): LongBool; stdcall; external SEKeygenDLL name 'SEGenerateKeyFileExW';
function SEGetMaxKeyBufferSize(): Integer; stdcall; external SEKeygenDLL name 'SEGetMaxKeyBufferSize';
function SEGenerateKeyBufferA(var Options: sSELicenseOptionsA; pKeyFileName: PAnsiChar; MaxChars: Integer; pKeyBuffer: PChar): Integer; stdcall; external SEKeygenDLL name 'SEGenerateKeyBufferA';
function SEGenerateKeyBufferW(var Options: sSELicenseOptionsW; pKeyFileName: PWideChar; MaxWChars: Integer; pKeyBuffer: PChar): Integer; stdcall; external SEKeygenDLL name 'SEGenerateKeyBufferW';
function SEGenerateKeyBufferExA(var Options: sSELicenseOptionsA; pLicenseDat: PAnsiChar; pKeyFileName: PAnsiChar; MaxChars: Integer; pKeyBuffer: PChar): Integer; stdcall; external SEKeygenDLL name 'SEGenerateKeyBufferExA';
function SEGenerateKeyBufferExW(var Options: sSELicenseOptionsW; pLicenseDat: PWideChar; pKeyFileName: PWideChar; MaxWChars: Integer; pKeyBuffer: PChar): Integer; stdcall; external SEKeygenDLL name 'SEGenerateKeyBufferExW';

implementation

end.
