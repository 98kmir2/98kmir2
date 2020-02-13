unit uWinTrust;

interface

uses
  Windows,
  SysUtils,
  VMProtectSDK;

const
  //Kostanten f¨¹r die dwUnionChoice in WINTRUST_DATA
  WTD_CHOICE_FILE           = 1;
  WTD_CHOICE_CATALOG        = 2;

  //Konstanten f¨¹r dwStateAction
  WTD_STATEACTION_IGNORE    = 0;
  WTD_STATEACTION_VERIFY    = 1;
  WTD_STATEACTION_CLOSE     = 2;

  //UI Konstanten f¨¹r WINTRUST_DATA
  WTD_UI_NONE               = 2;        //kein UI anzeigen

  //Konstanten zur Pr¨¹fung auf zur¨¹ckgezogene Zertifikate
  WTD_REVOKE_NONE           = 0;        // keine zus&auml;tzliche Pr¨¹fun

  //Konstanten f¨¹r TrustProvider
  WTD_SAFER_FLAG            = 256;      // f¨¹r Winxp Sp2 ben&ouml;tigt

  //Wintrust Action GUID&acute;s
  WINTRUST_ACTION_GENERIC_VERIFY_V2: TGUID = '{00AAC56B-CD44-11d0-8CC2-00C04FC295EE}';

type

  CATALOG_INFO = record
    cbStruct: DWORD;                    // = sizeof(WINTRUST_CATALOG_INFO)
    sCatalogFile: array[0..MAX_PATH] of WCHAR; // Dateiname incl. Pfad zur CAT Datei
  end;
  PCATALOG_INFO = ^CATALOG_INFO;

  WINTRUST_CATALOG_INFO = record
    cbStruct: DWORD;                    // = sizeof(WINTRUST_CATALOG_INFO)
    dwCatalogVersion: DWORD;            // optional
    pcwszCatalogFilePath: LPCWSTR;      // ben&ouml;tigt, Dateiname incl. Pfad zur CAT Datei
    pcwszMemberTag: LPCWSTR;            // ben&ouml;tigt, tag zum Mitglied im Katalog
    pcwszMemberFilePath: LPCWSTR;       // ben&ouml;tigt, Dateiname incl. Pfad
    hMemberFile: THANDLE;               // optional
  end;
  PWINTRUST_CATALOG_INFO = ^WINTRUST_CATALOG_INFO;

  WINTRUST_FILE_INFO = record
    cbStruct: DWORD;                    // = sizeof(WINTRUST_FILE_INFO)
    pcwszFilePath: LPCWSTR;             // ben&ouml;tigt, Dateiname incl. Pfad
    pgKnownSubject: PGUID;              // optional
    hFile: THANDLE;                     // optional
  end;
  PWINTRUST_FILE_INFO = ^WINTRUST_FILE_INFO;

  WINTRUST_DATA = packed record
    cbStruct: DWORD;                    // = sizeof(WINTRUST_DATA)
    pPolicyCallbackData: pointer;       // optional - auf 0 setzen
    pSIPClientData: pointer;            // optional - auf 0 setzen
    dwUIChoice: DWORD;                  // ben&ouml;tigt, UI auswahl
    fdwRevocationChecks: DWORD;         // ben&ouml;tigt, auf zur¨¹ckgezogene Zertifikate pr¨¹fen (online ben.)
    dwUnionChoice: DWORD;               // ben&ouml;tigt, welche Datenstruktur soll verwendet werden
    pWTDINFO: pointer;                  // Pointer zu einer der Wintrust_X_Info Strukturen
    pFake: pointer;                     //Fake Pointer - n&ouml;tig damit der Speicer wieder freigegeben wird
    pFake1: pointer;                    //Fake Pointer - n&ouml;tig damit der Speicer wieder freigegeben wird
    pFake2: pointer;                    //Fake Pointer - n&ouml;tig damit der Speicer wieder freigegeben wird
    pFake3: pointer;                    //Fake Pointer - n&ouml;tig damit der Speicer wieder freigegeben wird
    dwStateAction: DWORD;
    hWVTStateData: THANDLE;
    pwszURLReference: PWChar;
    dwProvFlags: DWORD;
    dwUIContext: DWORD;

  end;
  PWINTRUST_DATA = ^WINTRUST_DATA;

  //Handle und Pointer auf KatalogAdminKontext
  HCatAdmin = THANDLE;
  PHCatAdmin = ^HCatAdmin;

var
  hLibWintrust              : THANDLE;

  //dynamische Dll Aufrufe - keine Statische einbindung m&ouml;glich
  CryptCATAdminAcquireContext: function(PHCatAdmin: PHCatAdmin; pgSubsystem: PGUID; dwFlags: DWORD): BOOL; stdcall;
  CryptCATAdminReleaseContext: function(HCatAdmin: HCatAdmin; dwFlags: DWORD): BOOL; stdcall;
  CryptCATAdminCalcHashFromFileHandle: function(hFile: THANDLE; pHashSize: PDWORD; pbHash: PByteArray; dwFlags: DWORD): BOOL; stdcall;
  CryptCATAdminEnumCatalogFromHash: function(HCatAdmin: HCatAdmin; pbHash: PByteArray; pHashSize: DWORD; dwFlags: DWORD; phPrevCatInfo: PHandle): THANDLE; stdcall;
  CryptCATCatalogInfoFromContext: function(hCatInfo: THANDLE; psCatInfo: PCATALOG_INFO; dwFlags: DWORD): BOOL; stdcall;
  CryptCATAdminReleaseCatalogContext: function(HCatAdmin: HCatAdmin; hCatInfo: THANDLE; dwFlags: DWORD): BOOL; stdcall;
  WinVerifyTrust            : function(hwnd: THANDLE; pgActionID: PGUID; pWintrustData: PWINTRUST_DATA): Longint; stdcall;

  //function CheckFileTrust(const sFilename: string): Boolean;

implementation
{-----------------------------------------------------------------------------
Funcktion: CheckFileTrust
Date: 02-Mrz-2005
Arguments: const sFilename: string
Result: Boolean
Description: Pr¨¹ft ob die angegebene Datei Trusted ist
-----------------------------------------------------------------------------}

{function CheckFileTrust(const sFilename: string): Boolean;
var
  //Byte Array und Counter
  aByteHash                 : array[0..255] of Byte;
  iByteCount                : Integer;

  hCatAdminContext          : HCatAdmin;
  WTrustData                : WINTRUST_DATA;
  WTDCatalogInfo            : WINTRUST_CATALOG_INFO;
  WTDFileInfo               : WINTRUST_FILE_INFO;
  CatalogInfo               : CATALOG_INFO;

  hFile                     : THANDLE;
  hCatalogContext           : THANDLE;

  swFilename                : WideString;
  swMemberTag               : WideString;

  ilRet                     : Longint;
  x                         : Integer;

begin

  //Standard Result setzen
  Result := False;

  //Sicherheitsabfrage ob Datei existiert
  if FileExists(sFilename) = False then Exit;

  //String in Widestring wandeln
  swFilename := sFilename;

  ZeroMemory(@CatalogInfo, SizeOf(CatalogInfo));
  ZeroMemory(@WTDFileInfo, SizeOf(WTDFileInfo));
  ZeroMemory(@WTDCatalogInfo, SizeOf(WTDCatalogInfo));
  ZeroMemory(@WTrustData, SizeOf(WTrustData));

  //Catalog Admin Kontext &ouml;ffnen und falls nicht m&ouml;glich Prozedur verlassen
  if CryptCATAdminAcquireContext(@hCatAdminContext, nil, 0) = False then Exit;

  //Filehandle auf die zu pr¨¹fende Datei holen
  hFile := CreateFile(PChar(string(sFilename)), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  //Wenn das Handle nicht erhalten wurde Prozedur verlassen
  if hFile = INVALID_HANDLE_VALUE then Exit;

  //iaBytescount nach gr&ouml;&szlig;e des Arrays setzen
  iByteCount := SizeOf(aByteHash);

  //ByteArray mit Hash f¨¹llen lassen und die Gr&ouml;&szlig;e in iByteCount bekommen
  CryptCATAdminCalcHashFromFileHandle(hFile, @iByteCount, @aByteHash, 0);

  // MemberTag brechnen (vom ByteArray auf HEX)
  for x := 0 to iByteCount - 1 do begin
    swMemberTag := swMemberTag + IntToHex(aByteHash[x], 2);
  end;

  //FileHandle schlie&szlig;en - wird nicht mehr gebraucht
  CloseHandle(hFile);

  //Erste Pr¨¹fung erfolgt mit WINTRUST_DATA.dwUnionChoice := WTD_CHOICE_CATALOG;
  //also muss WINTRUST_CATALOG_INFO gef¨¹llt werden
  //
  //Handle auf den Katalog Kontext holen
  hCatalogContext := CryptCATAdminEnumCatalogFromHash(hCatAdminContext, @aByteHash, iByteCount, 0, nil);

  //Wenn das Handle 0 ist muss die Pr¨¹fung mit der
  //WINTRUST_DATA.dwUnionChoice := WTD_CHOICE_FILE; Struktur durchgef¨¹hrt werden
  if hCatalogContext = 0 then begin
    //CatalogContext = 0 also
    //
    //WINTRUST_FILE_INFO Struktur initialisieren und f¨¹llen
    WTDFileInfo.cbStruct := SizeOf(WTDFileInfo);
    WTDFileInfo.pcwszFilePath := PWideChar(swFilename);
    WTDFileInfo.pgKnownSubject := nil;
    WTDFileInfo.hFile := 0;

    //WINTRUST_DATA Struktur initialisieren und f¨¹llen
    WTrustData.cbStruct := SizeOf(WTrustData);
    WTrustData.dwUnionChoice := WTD_CHOICE_FILE; //WINTRUST_FILE_INFO Struktur w&auml;hlen
    WTrustData.pWTDINFO := @WTDFileInfo; //Pointer zu WINTRUST_FILE_INFO
    WTrustData.dwUIChoice := WTD_UI_NONE;
    WTrustData.fdwRevocationChecks := WTD_REVOKE_NONE;
    WTrustData.dwStateAction := WTD_STATEACTION_IGNORE;
    WTrustData.dwProvFlags := WTD_SAFER_FLAG; //UI bei XP SP2 unterbinden
    WTrustData.hWVTStateData := 0;
    WTrustData.pwszURLReference := nil;
  end
  else begin
    //CatalogContext <> 0 also CATALOG_INFO benutzen
    //
    //CATALOG_INFO Struktur f¨¹llen
    CryptCATCatalogInfoFromContext(hCatalogContext, @CatalogInfo, 0);

    //WINTRUST_CATALOG_INFO Struktur initialisieren und f¨¹llen
    WTDCatalogInfo.cbStruct := SizeOf(WTDCatalogInfo);
    WTDCatalogInfo.pcwszCatalogFilePath := CatalogInfo.sCatalogFile;
    WTDCatalogInfo.pcwszMemberFilePath := PWideChar(swFilename);
    WTDCatalogInfo.pcwszMemberTag := PWideChar(swMemberTag);

    //WINTRUST_DATA Struktur initialisieren und f¨¹llen
    WTrustData.cbStruct := SizeOf(WTrustData);
    WTrustData.dwUnionChoice := WTD_CHOICE_CATALOG; //WINTRUST_CATALOG_INFO Struktur w&auml;hlen
    WTrustData.pWTDINFO := @WTDCatalogInfo; //Pointer zu WINTRUST_CATALOG_INFO
    WTrustData.dwUIChoice := WTD_UI_NONE;
    WTrustData.fdwRevocationChecks := WTD_REVOKE_NONE;
    WTrustData.pPolicyCallbackData := nil;
    WTrustData.pSIPClientData := nil;
    WTrustData.dwStateAction := WTD_STATEACTION_VERIFY;
    WTrustData.dwProvFlags := 0;        //WTD_SAFER_FLAG; //UI bei XP SP2 unterbinden
    WTrustData.hWVTStateData := 0;
    WTrustData.pwszURLReference := nil;
  end;

  //WinVerifyTrust aufrufen um die Pr¨¹fung durchzuf¨¹hren
  ilRet := WinVerifyTrust(INVALID_HANDLE_VALUE, @WINTRUST_ACTION_GENERIC_VERIFY_V2, @WTrustData);

  //Wenn Erg. 0 ist dann ist das File Trusted - alle anderen Werte sind Fehlercodes
  if ilRet = 0 then begin
    Result := True
  end
  else
    Result := False;

  //Handle zum Catalogfile schlie&szlig;en
  CryptCATAdminReleaseCatalogContext(hCatAdminContext, hCatalogContext, 0);

  //Catalog Admin Kontext schlie&szlig;en
  CryptCATAdminReleaseContext(hCatAdminContext, 0);
end;}

initialization
{$I '..\Common\Macros\VMPB.inc'}
  //Dynamisches laden der Dll und deren Funktionen
  hLibWintrust := LoadLibrary(VMProtectDecryptStringA('wintrust.dll'));
  if hLibWintrust >= 32 then { success } begin
    CryptCATAdminAcquireContext := GetProcAddress(hLibWintrust, VMProtectDecryptStringA('CryptCATAdminAcquireContext'));
    CryptCATAdminReleaseContext := GetProcAddress(hLibWintrust, VMProtectDecryptStringA('CryptCATAdminReleaseContext'));
    CryptCATAdminCalcHashFromFileHandle := GetProcAddress(hLibWintrust, VMProtectDecryptStringA('CryptCATAdminCalcHashFromFileHandle'));
    CryptCATAdminEnumCatalogFromHash := GetProcAddress(hLibWintrust, VMProtectDecryptStringA('CryptCATAdminEnumCatalogFromHash'));
    CryptCATCatalogInfoFromContext := GetProcAddress(hLibWintrust, VMProtectDecryptStringA('CryptCATCatalogInfoFromContext'));
    CryptCATAdminReleaseCatalogContext := GetProcAddress(hLibWintrust, VMProtectDecryptStringA('CryptCATAdminReleaseCatalogContext'));
    WinVerifyTrust := GetProcAddress(hLibWintrust, VMProtectDecryptStringA('WinVerifyTrust'));
  end;
{$I '..\Common\Macros\VMPE.inc'}

finalization
  FreeLibrary(hLibWintrust);

end.

