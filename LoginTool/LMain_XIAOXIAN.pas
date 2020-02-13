unit LMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Registry, IniFiles, Dialogs,
  RzPrgres, IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, Clipbrd,
  IdHTTP, D7ScktComp, RzLabel, jpeg, ShellApi, ShlObj, ComObj,
  ActiveX, Grobal2, SechThread, VCLUnZip, RzBmpBtn,
  SHDocVw, RzButton, RzRadChk, DCPcrypt, Mars, strutils, ExtCtrls, StdCtrls,
  RzCmboBx, OleCtrls, ComCtrls, RzForms, base64, dateutils,
  IdHashMessageDigest, IdGlobal, IdHash;

const
//{$IFDEF CD}
//{$IFDEF UI_0508}
////  g_sVersion        = 'V2012.05.08+4 CD版';
//  g_sVersion        = 'V2015.07.29+7 ';
//{$ELSE}
//  g_sVersion        = 'V2012.08.25 CD版';
//{$ENDIF}
//{$ELSE}
//{$IFDEF UI_0508}
//  g_sVersion        = 'V2015.07.29+7';
//{$ELSE}
//  g_sVersion        = 'V2015.03.27+7 ';
//{$ENDIF}
//{$ENDIF}
{$IFDEF CD}
  g_sVersion = 'V2015.08.22+4 CD版';
{$ELSE}
  g_sVersion = 'V2015.08.20+4 Professional';
{$ENDIF}
  g_CreateShortcut = True;

var
  g_fWzlOnly: Byte = 7;
  g_sPatchSvr: string = '';
  g_nLibHandle: THandle = 0;
  g_dwOffset: DWord = 0;
  g_dwPointerToRawData: DWord = 0;
  g_dwSizeOfRawData: DWord = 0;
  g_NTHeader: TImageNtHeaders;

type
  LPLOGINPRO = function(pszIP: PChar; nPort: Integer; nMode: Integer; fWait: Boolean; nKey: Integer): DWord; stdcall;

  LPDYNCODE = function(Ptr: PByte; Len: DWord): BOOL; stdcall;
  LPGETDYNCODE = function(ID: Integer): LPDYNCODE; stdcall;

  TFrmMain = class(TForm)
    ClientSocket: TClientSocket;
    TimerUpgrate: TTimer;
    ImageMain: TImage;
    IdAntiFreeze: TIdAntiFreeze;
    btNewAccount: TRzBmpButton;
    btnStartGame: TRzBmpButton;
    btnChangePassword: TRzBmpButton;
    btnGetBackPassword: TRzBmpButton;
    btnColse: TRzBmpButton;
    btnMinSize: TRzBmpButton;
    btnEditGameList: TRzBmpButton;
    btnEditGame: TRzBmpButton;
    RzBmpButton1: TRzBmpButton;
    RzFormShape1: TRzFormShape;
    TreeViewServerList: TTreeView;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabelStatus: TRzLabel;
    ProgressBarCurDownload: TRzProgressBar;
    ProgressBarAll: TRzProgressBar;
    Timer: TTimer;
    ClientSocket2: TClientSocket;
    ServerSocket: TServerSocket;
    TimerFindDir: TTimer;
    VCLUnZip: TVCLUnZip;
    TimerPacket: TTimer;
    Image1: TImage;
    RzFormShape2: TRzFormShape;
    RzLabel4: TRzLabel;
    WebBrowser: TWebBrowser;
    ckWindowed: TRzCheckBox;
    TimerWebBroswer: TTimer;
    VCLUnZip1: TVCLUnZip;
    RzComboBox_ScrMode: TRzComboBox;
    RzLabel5: TRzLabel;
    rbRoute1: TRzRadioButton;
    rbRoute2: TRzRadioButton;
    VCLUnZip2: TVCLUnZip;
    Timer1: TTimer;
    WebBrowser2: TWebBrowser;
    Timer2: TTimer;
    ClientSocket1: TClientSocket;
    Timer3: TTimer;
    Label1: TLabel;
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketLookup(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure TimerUpgrateTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btNewAccountClick(Sender: TObject);
    procedure btnStartGameClick(Sender: TObject);
    procedure btnChangePasswordClick(Sender: TObject);
    procedure btnGetBackPasswordClick(Sender: TObject);
    procedure RzBmpButton3Click(Sender: TObject);
    procedure btnColseClick(Sender: TObject);
    procedure btnMinSizeClick(Sender: TObject);
    procedure btnEditGameListClick(Sender: TObject);
    procedure btnEditGameClick(Sender: TObject);
    procedure RzBmpButton1Click(Sender: TObject);
    procedure TreeViewServerListClick(Sender: TObject);
    procedure TimerLoginFunTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ClientSocket2Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket2Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure TimerFindDirTimer(Sender: TObject);
    procedure WebBrowserDownloadComplete(Sender: TObject);
    procedure VCLUnZipPromptForOverwrite(Sender: TObject; var OverWriteIt: Boolean; FileIndex: Integer; var FName: string);
    procedure TimerPacketTimer(Sender: TObject);
    procedure TimerWebBroswerTimer(Sender: TObject);
    procedure VCLUnZipUnZipComplete(Sender: TObject; FileCount: Integer);
    procedure RzComboBox_ScrModeChange(Sender: TObject);
    procedure ckWindowedClick(Sender: TObject);

    procedure Timer1Timer(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer3Timer(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
  private

    mls: TStringlist;
    cmdList: TStringlist;
    oldcrc: Cardinal;
    SocStr, BufferStr: string;
    testSocStr, testBufferStr: string;
    procedure ShowInformation(const smsg: string);
    procedure SendCSocket(sendstr: string);
    procedure CheckServerStatus();
    procedure DecodeMessagePacket(datablock: string);
{$IF g_CreateShortcut}
    function CreateShortcut(const CmdLine, Args, WorkDir, LinkFile: string): IPersistFile;
    procedure CreateShortcuts();
{$IFEND g_CreateShortcut}
    //procedure ServerStatusOK();
    procedure ServerStatusFail();
    procedure DecodeMessagePacketTest(datablock: string);
    procedure SendTestConnnect();
    procedure SendUrlCrc(nUrl: Integer);
    procedure SendUrlCheckEx;
    procedure AppException(Sender: TObject; E: Exception);
    { Private declarations }
  public
    enddate: Integer;
    DCP_mars: TDCP_mars;
    FEncodeFunc: LPDYNCODE;
    FDecodeFunc: LPDYNCODE;
    FEndeBufLen: Integer;
    FEndeBuffer: array[0..16 * 1024 - 1] of Char;
    FTempBuffer: array[0..16 * 1024 - 1] of Char;
    FSendBuffer: array[0..16 * 1024 - 1] of Char;

    //procedure RefSelfGameList();
    procedure SendUpdateAccount(ue: TUserEntry; ua: TUserEntryAdd);
    procedure SendChgPw(sAccount, sPasswd, sNewPasswd: string);
    procedure SendGetBackPassword(sAccount, sQuest1, sAnswer1, sQuest2, sAnswer2, sBirthDay: string);
    { Public declarations }
    function DecodeGameList(content: string): string;
    procedure DelAllDll;
  end;

type
  TMyThread = class(TThread)
  protected
    procedure Execute; override;
  end;

type
  TTongJiThread = class(TThread)
  protected
    procedure Execute; override;
  end;
const
  g_Debugflname = '.\!debug.txt';

var
  FrmMain: TFrmMain;
  SearchThread: TSechThread;
  UserSocket: TCustomWinSocket = nil;
  dwTreeViewServerListClick: LongWord;
  thunk: TMemoryStream = nil;

  //WaitLoadThread    : TWaitLoadThread;

function IsLegendGameDir(): Boolean;
procedure GetLocalDiskList(DiskList: TStringlist);

implementation

uses
  LNewAccount, LChgPassword, LGetBackPassword, HUtil32, MsgBox, UpgradeModule,
  SlectDir, LShare, MD5, EDcode, VMProtectSDK, PEUnit {, jwaWinCrypt, uWinTrust},
  UMirClient, UUibRes;

{$R *.dfm}

{$IFDEF PATCHMAN}

var
  gs_GameZone: TGameZone;

function LoadPeInfo(AFile: string): Boolean;
var
  hFile: Integer;
  DosHeader: TImageDosHeader;
  PESectionHeader: array of TImageSectionHeader;
  i, j: Integer;
  szSectionName: array[0..7] of Char;
  fGetSection: Boolean;
begin
  Result := True;
{$I '..\Common\Macros\VMPB.inc'}
  hFile := FileOpen(AFile, FmOpenRead or fmShareDenyNone);
  if hFile > 0 then begin
    try
      try
        if FileRead(hFile, DosHeader, SizeOf(DosHeader)) <> SizeOf(DosHeader) then begin {读取DOSHeader}
          Result := False;
          //Application.MessageBox('Error DOSHeader!', 'Error', MB_OK + MB_ICONERROR);
          Exit;
        end;
        if FileSeek(hFile, DosHeader._lfanew, soFromBeginning) <> DosHeader._lfanew then begin {定位到PE header}
          Result := False;
          //Application.MessageBox('Error PE header!', 'Error', MB_OK + MB_ICONERROR);
          Exit;
        end;
        if FileRead(hFile, g_NTHeader, SizeOf(g_NTHeader)) <> SizeOf(g_NTHeader) then begin {读数据到NTHeader}
          Result := False;
          //Application.MessageBox('Error NTHeader!', 'Error', MB_OK + MB_ICONERROR);
          Exit;
        end;

        SetLength(PESectionHeader, g_NTHeader.FileHeader.NumberOfSections); {块表数}
        for i := 0 to g_NTHeader.FileHeader.NumberOfSections - 1 do begin {节表读入到PESectionHeader}
          if FileRead(hFile, PESectionHeader[i], SizeOf(TImageSectionHeader)) <> SizeOf(TImageSectionHeader) then begin
            Result := False;
            //Application.MessageBox('Error PESectionHeader!', 'Error', MB_OK + MB_ICONERROR);
            Exit;
          end;
        end;

      except
        Result := False;
        //Application.MessageBox('Error reading PE file!', 'Error', MB_OK + MB_ICONERROR);
        Exit;
      end;
    finally
      FileClose(hFile);
    end;
  end else begin
    Result := False;
    Exit;
  end;

  if (g_NTHeader.Signature <> IMAGE_NT_SIGNATURE) then begin
    //Application.MessageBox('Not A Win32 Executable File!', 'Error', MB_OK + MB_ICONERROR);
    Result := False;
    Exit;
  end;

  if not Result then
    Exit;

  fGetSection := False;
  for i := 0 to g_NTHeader.FileHeader.NumberOfSections - 1 do {遍历节表}  begin {块表名}
    if (StrPas(@PESectionHeader[i].Name[0]) = 'UPX5') then begin
      g_dwPointerToRawData := PESectionHeader[i].PointerToRawData;
      g_dwSizeOfRawData := PESectionHeader[i].SizeOfRawData;
      fGetSection := True;
      Break;
    end;
  end;

  if not fGetSection then
    Result := False;
{$I '..\Common\Macros\VMPE.inc'}
end;

function ExtractPath(szFileName: string; const pBuff: Pointer; const nSize: Integer): Boolean;
var
  ms: TMemoryStream;
  boChanged: Boolean;
  attr: Integer;
begin
{$I '..\Common\Macros\VMPB.inc'}
  ms := TMemoryStream.Create();
  ms.WriteBuffer(pBuff^, nSize);
  if FileExists(szFileName) then begin
    boChanged := False;
    attr := FileGetAttr(szFileName);
    if attr and faReadOnly = faReadOnly then begin
      attr := attr xor faReadOnly;
      boChanged := True;
    end;
    if attr and faSysFile = faSysFile then begin
      attr := attr xor faSysFile;
      boChanged := True;
    end;
    if attr and faHidden = faHidden then begin
      attr := attr xor faHidden;
      boChanged := True;
    end;
    if boChanged then
      FileSetAttr(szFileName, attr);
  end else begin

  end;
  ms.SaveToFile(szFileName);
  Result := True;
  ms.Free;
{$I '..\Common\Macros\VMPE.inc'}
end;

function MyExecBat(pszCmd: PChar): LongWord;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  ret: LongWord;
begin
{$I '..\Common\Macros\VMPB.inc'}
  Result := 0;
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW; //
  StartupInfo.wShowWindow := SW_HIDE; //visiable;

  if CreateProcess(nil, pszCmd, nil, nil, False, CREATE_NO_WINDOW, nil, nil, StartupInfo, ProcessInfo) then begin
    WaitForSingleObject(ProcessInfo.hProcess, 300);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;
{$ENDIF}

procedure GetLocalDiskList(DiskList: TStringlist);
var
  i, nDType: Integer;
  sDisk: string;
begin
  if DiskList = nil then Exit;
  for i := 65 to 90 do begin
    sDisk := Chr(i) + ':\';
    nDType := GetDriveType(PChar(sDisk));
    if nDType = DRIVE_FIXED then
      DiskList.Add(sDisk);
  end;
end;

function IsLegendGameDir(): Boolean;
begin
  Result := False;
  if DirectoryExists('Data') and
    DirectoryExists('map') and
    DirectoryExists('wav') and
    (FileExists(('.\Data\Prguse2.wil')) or FileExists(('.\Data\Prguse2.wzl'))) then
    Result := True;
end;

procedure TFrmMain.ServerStatusFail();
begin
  btNewAccount.Enabled := False;
  btnChangePassword.Enabled := False;
  btnGetBackPassword.Enabled := False;
  btnStartGame.Enabled := False;

  //btnEditGameList.Enabled := false;
end;

procedure TFrmMain.SendUpdateAccount(ue: TUserEntry; ua: TUserEntryAdd);
var
  ss: string;
  iLen: Integer;
  msg: TDefaultMessage;
begin
  g_sMakeNewAccount := ue.sAccount;
  msg := MakeDefaultMsg(CM_ADDNEWUSER, 0, 0, 0, 0);
  if @FEncodeFunc <> nil then begin
    Move(msg, FTempBuffer[0], 12);
    Move(ue, FTempBuffer[12], SizeOf(TUserEntry));
    Move(ua, FTempBuffer[12 + SizeOf(TUserEntry)], SizeOf(TUserEntryAdd));
    FEncodeFunc(PByte(@FTempBuffer), SizeOf(TUserEntry) + SizeOf(TUserEntryAdd) + 12);
    iLen := EncodeBuf(Integer(@FTempBuffer), SizeOf(TUserEntry) + SizeOf(TUserEntryAdd) + 12, Integer(@FSendBuffer));
    SetLength(ss, iLen);
    Move(FSendBuffer[0], ss[1], iLen);
    SendCSocket(ss);
  end else
    ; //SendCSocket(EncodeMessage(msg) + EncodeString(EncodeBuffer(@ue, SizeOf(TUserEntry)) + EncodeBuffer(@ua, SizeOf(TUserEntryAdd))));
  //SendCSocket(EncodeMessage(msg) + EnCodeString(__En__(EncodeBuffer(@ue, SizeOf(TUserEntry)) + EncodeBuffer(@ua, SizeOf(TUserEntryAdd)), g_sLoginKey^)));
end;

procedure TFrmMain.SendCSocket(sendstr: string);
begin
  if ClientSocket.Socket.Connected then begin
    ClientSocket.Socket.SendText('#' + IntToStr(g_btCode) + sendstr + '!');
    Inc(g_btCode);
    if g_btCode >= 10 then
      g_btCode := 1;
  end;
end;

procedure TFrmMain.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  n: Integer;
  data, data2: string;
begin
  data := Socket.ReceiveText;
  if data = '' then Exit;
  n := Pos('*', data);
  if n > 0 then begin
    data2 := Copy(data, 1, n - 1);
    data := data2 + Copy(data, n + 1, Length(data));
    ClientSocket.Socket.SendText('*');
  end;
  SocStr := SocStr + data;
end;

procedure WaitAndPass(msec: LongWord);
var
  Start: LongWord;
begin
  Start := GetTickCount;
  while GetTickCount - Start < msec do
    Application.ProcessMessages;
end;

function GetUrlCrc(pszurl: PChar; Len: Integer): Cardinal; stdcall
var s: string;
  initdata: Cardinal;
begin
{$I '..\Common\Macros\VMPB.inc'}
  s := Copy(pszurl, 0, len);
  s := LowerCase(s);
  s := MD5Print(MD5String(s));
  initdata := $876545AB;
  Result := CRC32(Pointer(s), Length(s) * SizeOf(Char), initdata);

{$I '..\Common\Macros\VMPE.inc'}
end;

procedure TFrmMain.ShowInformation(const smsg: string);
begin
  RzLabelStatus.Caption := smsg;
end;


procedure TFrmMain.AppException(Sender: TObject; E: Exception);
begin
{$IFDEF TEST}
  ShowMessage(E.Message + E.ClassName);
{$ENDIF}
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  n, nn, j, fhandle: Integer;
  ms: TMemoryStream;
  RcHeader: TRcHeader;
  //S                         : IStrings;
  Cipher: TDCP_cipher;
  Jpg: TJpegImage;
  PN: PInteger;
  cfg: TLoginToolConfig;
  cmds: TCliCmdLines;
  buffer, buffer2: Pointer;
  nSize, offset: Integer;
  aaa: array of TCItemRule;
  i, ii: Integer;
  fn: string;

  sLine, sRoute1, sRoute2: string;

  sTemp: string;
  DevMode: TDevMode;
  PDM: PDevMode;

  {sFilename                 : string;
  aByteHash                 : array[0..255] of Byte;
  iByteCount                : Integer;

  boFileTrust               : Boolean;
  hCatAdminContext          : HCatAdmin;
  WTrustData                : WINTRUST_DATA;
  WTDCatalogInfo            : WINTRUST_CATALOG_INFO;
  WTDFileInfo               : WINTRUST_FILE_INFO;
  CatalogInfo               : CATALOG_INFO;

  hFile                     : THandle;
  hCatalogContext           : THandle;

  swFilename                : WideString;
  swMemberTag               : WideString;

  ilRet                     : LongInt;
  X                         : Integer;}
  decode: TMemoryStream;
  strenddate: string;

  temp1, temp2, temp3: string;
  msg: TDefaultMessage;
  t: Cardinal;
begin

/// 2015 02 28
///
///
//OutputDebugStringA('123');;
//temp1 := 'Kx\q>@bTuGsIxdC`lpTrpb?i_rAnp^PxsaPg`^KxomR\``?atoGlmntpoo<l_rQmlaVc`^TpppLrlpTrpb?i_sWns^PtsaPg`^Kxom?\toGlmntpoo<l_rQmlaVc`^TpppLrb`Yka`Pg`bJ';
////temp1 := DecodeString(temp1)   ;
////ShowMessage(temp1);
////
// msg := DecodeMessage(temp1);
// t := msg.UID;
// ShowMessage(IntToStr(t));
// temp1 := 'http://vip.xw180.com:88/LoginTool/zyh168.txt|http://www.xw180.com/LoginTool/zyh168.txt|20150806';
// t :=GetUrlCrc(Pchar(temp1),Length(temp1));
//     ShowMessage(IntToStr(t));



  Label1.Caption := VMProtectDecryptStringA('www.legendm2.com');
  MainOutInforProc := ShowInformation;
  Application.OnException := AppException;

  DCP_mars := TDCP_mars.Create(nil);

  cmdList := TStringlist.Create;
{$I '..\Common\Macros\VMPBU.inc'}
  {boFileTrust := False;

  sFilename := ParamStr(0);

  //String in Widestring wandeln
  swFilename := sFilename;

  ZeroMemory(@CatalogInfo, SizeOf(CatalogInfo));
  ZeroMemory(@WTDFileInfo, SizeOf(WTDFileInfo));
  ZeroMemory(@WTDCatalogInfo, SizeOf(WTDCatalogInfo));
  ZeroMemory(@WTrustData, SizeOf(WTrustData));

  try
    //Catalog Admin Kontext &ouml;ffnen und falls nicht m&ouml;glich Prozedur verlassen
    if CryptCATAdminAcquireContext(@hCatAdminContext, nil, 0) = False then
      Exit;

    //Filehandle auf die zu prüfende Datei holen
    hFile := CreateFile(PChar(string(sFilename)), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

    //Wenn das Handle nicht erhalten wurde Prozedur verlassen
    if hFile = INVALID_HANDLE_VALUE then Exit;

    //iaBytescount nach gr&ouml;&szlig;e des Arrays setzen
    iByteCount := SizeOf(aByteHash);

    //ByteArray mit Hash füllen lassen und die Gr&ouml;&szlig;e in iByteCount bekommen
    CryptCATAdminCalcHashFromFileHandle(hFile, @iByteCount, @aByteHash, 0);

    // MemberTag brechnen (vom ByteArray auf HEX)
    for X := 0 to iByteCount - 1 do begin
      swMemberTag := swMemberTag + IntToHex(aByteHash[X], 2);
    end;

    //FileHandle schlie&szlig;en - wird nicht mehr gebraucht
    CloseHandle(hFile);

    //Erste Prüfung erfolgt mit WINTRUST_DATA.dwUnionChoice := WTD_CHOICE_CATALOG;
    //also muss WINTRUST_CATALOG_INFO gefüllt werden
    //
    //Handle auf den Katalog Kontext holen
    hCatalogContext := CryptCATAdminEnumCatalogFromHash(hCatAdminContext, @aByteHash, iByteCount, 0, nil);

    //Wenn das Handle 0 ist muss die Prüfung mit der
    //WINTRUST_DATA.dwUnionChoice := WTD_CHOICE_FILE; Struktur durchgeführt werden
    if hCatalogContext = 0 then begin
      //CatalogContext = 0 also
      //
      //WINTRUST_FILE_INFO Struktur initialisieren und füllen
      WTDFileInfo.cbStruct := SizeOf(WTDFileInfo);
      WTDFileInfo.pcwszFilePath := PWideChar(swFilename);
      WTDFileInfo.pgKnownSubject := nil;
      WTDFileInfo.hFile := 0;

      //WINTRUST_DATA Struktur initialisieren und füllen
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
      //CATALOG_INFO Struktur füllen
      CryptCATCatalogInfoFromContext(hCatalogContext, @CatalogInfo, 0);

      //WINTRUST_CATALOG_INFO Struktur initialisieren und füllen
      WTDCatalogInfo.cbStruct := SizeOf(WTDCatalogInfo);
      WTDCatalogInfo.pcwszCatalogFilePath := CatalogInfo.sCatalogFile;
      WTDCatalogInfo.pcwszMemberFilePath := PWideChar(swFilename);
      WTDCatalogInfo.pcwszMemberTag := PWideChar(swMemberTag);

      //WINTRUST_DATA Struktur initialisieren und füllen
      WTrustData.cbStruct := SizeOf(WTrustData);
      WTrustData.dwUnionChoice := WTD_CHOICE_CATALOG; //WINTRUST_CATALOG_INFO Struktur w&auml;hlen
      WTrustData.pWTDINFO := @WTDCatalogInfo; //Pointer zu WINTRUST_CATALOG_INFO
      WTrustData.dwUIChoice := WTD_UI_NONE;
      WTrustData.fdwRevocationChecks := WTD_REVOKE_NONE;
      WTrustData.pPolicyCallbackData := nil;
      WTrustData.pSIPClientData := nil;
      WTrustData.dwStateAction := WTD_STATEACTION_VERIFY;
      WTrustData.dwProvFlags := 0;      //WTD_SAFER_FLAG; //UI bei XP SP2 unterbinden
      WTrustData.hWVTStateData := 0;
      WTrustData.pwszURLReference := nil;
    end;

    //WinVerifyTrust aufrufen um die Prüfung durchzuführen
    ilRet := WinVerifyTrust(INVALID_HANDLE_VALUE, @WINTRUST_ACTION_GENERIC_VERIFY_V2, @WTrustData);

    //Wenn Erg. 0 ist dann ist das File Trusted - alle anderen Werte sind Fehlercodes
    boFileTrust := ilRet = 0;

    // 释放
    WTrustData.dwStateAction := WTD_STATEACTION_CLOSE;
    WinVerifyTrust(INVALID_HANDLE_VALUE,
      @WINTRUST_ACTION_GENERIC_VERIFY_V2,
      @WTrustData);
  finally
    if hCatAdminContext > 0 then begin
      if hCatalogContext > 0 then       //Handle zum Catalogfile schlie&szlig;en
        CryptCATAdminReleaseCatalogContext(hCatAdminContext, hCatalogContext, 0);

      //Catalog Admin Kontext schlie&szlig;en
      CryptCATAdminReleaseContext(hCatAdminContext, 0);
    end;
  end;

  if not boFileTrust then begin
    ClientSocket.Free;
    TimerUpgrate.Free;
    ImageMain.Free;
    btNewAccount.Free;
    btnStartGame.Free;
    btnChangePassword.Free;
    btnGetBackPassword.Free;
    btnColse.Free;
    btnMinSize.Free;
    btnEditGameList.Free;
    btnEditGame.Free;
    TreeViewServerList.Free;
    RzLabel1.Free;
    RzLabel2.Free;
    RzLabel3.Free;
    RzLabelStatus.Free;
    ProgressBarCurDownload.Free;
    ProgressBarAll.Free;
    Timer.Free;
    ClientSocket2.Free;
    ServerSocket.Free;
    TimerFindDir.Free;
    VCLUnZip.Free;
    TimerPacket.Free;
    RzLabel4.Free;
    WebBrowser.Free;
    ckWindowed.Free;
    TimerWebBroswer.Free;
    VCLUnZip1.Free;
    RzComboBox_ScrMode.Free;
    rbRoute1.Free;
    rbRoute2.Free;
    self.Free;
    ExitProcess(0);
    Exit;
  end;}

  try
    Jpg := TJpegImage.Create;
    try
      g_bLoginKey^ := False;
      g_sLoginTool := ParamStr(0);
      g_sLoginTool_Bin := ChangeFileExt(ParamStr(0), '.bin');
      g_sOldWorkDir := ExtractFilePath(ParamStr(0));
      g_sWorkDir := g_sOldWorkDir;
     // OutputDebugString(PChar('a:' + g_sWorkDir));
      sTemp := ExtractFileName(ParamStr(0));
      {sTemp := ChangeFileExt(sTemp, '.bin');

      if not FileExists(g_sOldWorkDir + sTemp) then begin
        MessageBox(0, PChar('文件不存在：' + #13 + g_sOldWorkDir + sTemp), '信息提示', MB_ICONQUESTION + MB_OK);
        ExitProcess(0);
        Exit;
      end;}

      FillChar(RcHeader, SizeOf(TRcHeader), #0);
{$IFDEF TEST}
      fhandle := FileOpen('.\bbbb.exe', FmOpenRead or fmShareDenyNone);
//      fhandle := FileOpen('D:\work\LegendOfMir2\Release\GenerateLoginTool\legendm2.exe', FmOpenRead or fmShareDenyNone);
{$ELSE}
      fhandle := FileOpen(g_sOldWorkDir + sTemp, FmOpenRead or fmShareDenyNone);
{$ENDIF }
      i := 0;
      while fhandle = 0 do begin
        //fhandle := FileOpen(ParamStr(0), FmOpenRead or fmShareDenyNone);
        fhandle := FileOpen(g_sOldWorkDir + sTemp, FmOpenRead or fmShareDenyNone);
        if fhandle > 0 then
          Break;
        Sleep(10);
        Inc(i);
        if i > 10 then
          Break;
      end;

      if fhandle > 0 then begin
        FileSeek(fhandle, -4, 2);
        New(PN);
        FileRead(fhandle, PN^, 4);
        GetMem(buffer, PN^);
        FileSeek(fhandle, -(4 + PN^), 2);
        FileRead(fhandle, buffer^, PN^);
        FileClose(fhandle);

        VCLUnZip1.ZLibDecompressBuffer(buffer, PN^, buffer2, nSize);
        Dispose(PN);

        Move(PChar(PChar(buffer2) + nSize - SizeOf(TRcHeader))^, RcHeader, SizeOf(TRcHeader));

        FillChar(g_pRcHeader^, SizeOf(TRcHeader), #0);
{$IFDEF FREE}
        DCP_mars.InitStr(VMProtectDecryptStringA('blue free'));
{$ELSE}
        DCP_mars.InitStr(VMProtectDecryptStringA('blue'));
{$ENDIF}

        DCP_mars.Decrypt(RcHeader, g_pRcHeader^, SizeOf(TRcHeader));

        DCP_mars.InitStr(VMProtectDecryptStringA('Purple'));
        g_pRcHeader^.sPathAdress[3] := DCP_mars.EncryptString(VMProtectDecryptStringA('B585F03430A40F200A'));
        //DCP_mars.InitStr(VMProtectDecryptStringA('sSiteUrl'));
        //g_sSiteUrl^ := DCP_mars.DecryptString(g_pRcHeader^.sSiteUrl);
        DCP_mars.InitStr(VMProtectDecryptStringA('sWebSite'));
        g_sWebUrl^ := DCP_mars.DecryptString(g_pRcHeader.sWebSite);

        DCP_mars.InitStr(VMProtectDecryptStringA('sFileName'));
        Application.Title := DCP_mars.DecryptString(g_pRcHeader.sFilename);

        DCP_mars.InitStr(VMProtectDecryptStringA('sLuiName2'));
        strenddate := DCP_mars.DecryptString(g_pRcHeader.sLuiName2);
//        g_pRcHeader.sSiteUrl

//        TMyThread.Create(False);
     //   TTongJiThread.Create(False);

     //   WebBrowser2.Navigate(VMProtectDecryptStringA('http://tj.ay57.com'));


        New(PN);
        try
          Move(PChar(PChar(buffer2) + nSize - (4 + SizeOf(TRcHeader)))^, PN^, SizeOf(Integer));

          Move(PChar(PChar(buffer2) + nSize - (SizeOf(TLoginToolConfig) + PN^ + 4 + SizeOf(TRcHeader)))^, cfg, SizeOf(TLoginToolConfig));

          if cfg.FileName <> '' then begin
            Application.Title := cfg.FileName;
          end; //123456
          g_fWzlOnly := cfg.Config8;
          if cfg.Config3 <> '' then begin
            g_sPatchSvr := cfg.Config3;
            rbRoute1.Visible := True;
            rbRoute2.Visible := True;

            sLine := cfg.Config7;
            sLine := GetValidStr3(sLine, sRoute1, [',']);
            sLine := GetValidStr3(sLine, sRoute2, [',']);
            if sRoute1 <> '' then
              rbRoute1.Caption := sRoute1;
            if sRoute2 <> '' then
              rbRoute2.Caption := sRoute2;
          end else begin
            rbRoute1.Visible := False;
            rbRoute2.Visible := False;
          end;

          nn := nSize - (SizeOf(TCliCmdLines) + SizeOf(TLoginToolConfig) + PN^ + 4 + SizeOf(TRcHeader));
          Move(PChar(PChar(buffer2) + nn)^, cmds, SizeOf(TCliCmdLines));
          for n := Low(TCliCmdLines) to High(TCliCmdLines) do begin
            if cmds[n] <> '' then
              cmdList.Add(cmds[n]);
          end;

          ms := TMemoryStream.Create();
          try
            ms.SetSize(PN^);
            Move(PChar(PChar(buffer2) + nSize - (PN^ + 4 + SizeOf(TRcHeader)))^, ms.Memory^, PN^);
            Jpg.LoadFromStream(ms);
            ImageMain.Picture.Assign(Jpg);
          finally
            ms.Free;
          end;

          nn := nSize - (SizeOf(TCliCmdLines) + SizeOf(TLoginToolConfig) + PN^ + 4 + SizeOf(TRcHeader));
          j := nn div SizeOf(TCItemRule);

          SetLength(aaa, j);
          Move(PChar(PChar(buffer2))^, PChar(@aaa[0])^, nn);
          mls := TStringlist.Create;
          //fn := '.\Data\lsDefaultItemFilter.txt';
          for ii := 0 to j - 1 do begin
            mls.Add(Format('%s,%d,%d,%d,%d', [aaa[ii].Name, aaa[ii].ntype, Byte(aaa[ii].rare), Byte(aaa[ii].pick), Byte(aaa[ii].show)]));
          end;
        finally
          Dispose(PN);
        end;
        FreeMem(buffer);
        FreeMem(buffer2);
      end else begin
        MessageBox(0, '登陆器配置文件不正确！', '信息提示', MB_ICONQUESTION + MB_OK);
        ExitProcess(0);
        Exit;
      end;
    finally
      Jpg.Free;
    end;
  except
  end;

  RzComboBox_ScrMode.Items.Clear;
  i := 0;
  while EnumDisplaySettingsA(nil, i, DevMode) do begin
    with DevMode do begin
      if (dmPelsWidth >= 800) and (dmBitsPerPel >= 24) then begin
        sTemp := Format('%d X %d', [dmPelsWidth, dmPelsHeight, dmBitsPerPel]);
        if (Pos(sTemp, RzComboBox_ScrMode.Items.Text) = 0) then begin
          New(PDM);
          PDM^ := DevMode;
          RzComboBox_ScrMode.Items.AddObject(sTemp, TObject(PDM));
        end;
      end;
    end;
    Inc(i);
  end;

{$I '..\Common\Macros\VMPE.inc'}

  RzLabel4.Caption := VMProtectDecryptStringA(g_sVersion);

  ckWindowed.Visible := True;
  WebBrowser.Hide;
  ServerStatusFail;
{$IF g_CreateShortcut}
  CreateShortcuts();
{$IFEND g_CreateShortcut}
  TimerUpgrate.Enabled := True;
end;

procedure TFrmMain.CheckServerStatus;
var
  ptrLoginPro: LPLOGINPRO;
  szFireWallAddress: string;
  szPlugLibFileName: string;
  dwStart: LongWord;
begin
  try
    if g_SelGameZone = nil then
      Exit;

    if GetTickCount - dwTreeViewServerListClick > 600 then begin
      dwTreeViewServerListClick := GetTickCount;
    end else
      Exit;

    if ClientSocket.Active then begin
      if (ClientSocket.Address = g_SelGameZone.sGameIPaddr) and (ClientSocket.Port = g_SelGameZone.nGameIPPort) then
        Exit;
    end;

{$I '..\Common\Macros\VMPB.inc'}
    if g_nLibHandle = 0 then begin
      szPlugLibFileName := g_sOldWorkDir + VMProtectDecryptStringA('LoginDLL.dll');
      if FileExists(szPlugLibFileName) then begin
        g_nLibHandle := LoadLibrary(PChar(szPlugLibFileName));
      end;
    end;
    if g_nLibHandle > 32 then begin
      ptrLoginPro := GetProcAddress(g_nLibHandle, PChar(VMProtectDecryptStringA('LoginPro')));
      if @ptrLoginPro <> nil then begin
        szFireWallAddress := g_SelGameZone.szFireWallAddress;
        RzLabelStatus.Font.Color := $0094D5F8;
        RzLabelStatus.Caption := '正在验证,稍等片刻...';
        ptrLoginPro(PChar(szFireWallAddress), g_SelGameZone.nFireWallPort, g_SelGameZone.nFireWallMode, True, g_SelGameZone.nFireWallKey);
      end;
      //FreeLibrary(g_nLibHandle);
    end;
{$I '..\Common\Macros\VMPE.inc'}

    ClientSocket.Active := False;
    ClientSocket.Host := '';
    while True do begin
      if not ClientSocket.Socket.Connected then begin
        if g_SelGameZone.sGameIPaddr <> '' then begin

          ClientSocket.Address := g_SelGameZone.sGameIPaddr;
          ClientSocket.Port := g_SelGameZone.nGameIPPort;
{$IFDEF TEST}
//          ClientSocket.Address := '192.168.1.199';
//           ClientSocket.Port := 7000;
{$ENDIF }

        end else begin
          ClientSocket.Host := g_SelGameZone.sGameDomain;
          ClientSocket.Port := g_SelGameZone.nGameIPPort;
        end;
        RzLabelStatus.Font.Color := $0094D5F8;
        RzLabelStatus.Caption := '正在开始测试服务器状态...';
        ClientSocket.Active := True;
        Break;
      end;
      Application.ProcessMessages;
      if Application.Terminated then
        Break;
    end;
  except
    ClientSocket.Close;
  end;
end;

procedure TFrmMain.ckWindowedClick(Sender: TObject);
begin
  if not IsLegendGameDir then begin
    if DirectoryExists(g_sWorkDir) then
      ChDir(g_sWorkDir);
  end;
  g_mirIni.WriteBool('Setup', 'FullScreen', not ckWindowed.Checked);
end;

{procedure SetNodeBoldState(Node: TTreeNode; Value: Boolean);
var
  TVItem                    : TTVItem;
begin
  if not Assigned(Node) then Exit;
  with TVItem do
  begin
    mask := TVIF_STATE or TVIF_HANDLE;
    hItem := Node.ItemId;
    stateMask := TVIS_BOLD;
    if Value then
      State := TVIS_BOLD
    else
      State := 0;
    TreeView_SetItem(Node.Handle, TVItem);
  end;
end;}

{procedure TFrmMain.RefSelfGameList();
var
  i                         : Integer;
  GameZone                  : pTGameZone;
  ANode, RNode              : TTreeNode;
  boFind                    : Boolean;
begin
  RNode := nil;
  TreeViewServerList.Items.Clear;
  if g_GameList.Count <= 0 then Exit;
  for i := 0 to g_GameList.Count - 1 do begin
    GameZone := pTGameZone(g_GameList.Objects[i]);
    if RNode = nil then begin
      RNode := TreeViewServerList.Items.AddObjectFirst(nil, g_GameList.Strings[i], nil);
      TreeViewServerList.Items.AddChildObject(RNode, GameZone.sGameName, GameZone);
      Continue;
    end;
    if TreeViewServerList.Items.Count > 0 then begin
      ANode := TreeViewServerList.Items.Item[0];
      boFind := False;
      while ANode <> nil do begin
        if (ANode.Level = 0) then begin
          if (ANode.Text = g_GameList.Strings[i]) then begin
            boFind := True;
            Break;
          end;
        end;
        ANode := ANode.GetNext;
      end;
      if boFind then begin
        TreeViewServerList.Items.AddChildObject(ANode, GameZone.sGameName, GameZone);
      end else begin
        RNode := TreeViewServerList.Items.AddObjectFirst(nil, g_GameList.Strings[i], nil);
        TreeViewServerList.Items.AddChildObject(RNode, GameZone.sGameName, GameZone);
      end;
    end;
  end;
  if TreeViewServerList.Items.Item[0] <> nil then
    TreeViewServerList.Items.Item[0].Expand(True);
end;}

procedure TFrmMain.TimerUpgrateTimer(Sender: TObject);
var
  //lStream                   : TStream;
  ts: TStringlist;
  i, c, w, h, b: Integer;
  sDownFileName: string;
  sLineText, sFileMD5, sDownSite: string;
  sFilename, sCheckFileName: string;
  IdHTTP1, IdHTTP2, IdHTTPGetUpgInfo: TIdHTTP;
  //sList                     : TStringList;
  MyReg, tMyReg: TRegIniFile;
  PathReg: TRegistry;
  dw, tid: LongWord;

  GameZone: pTGameZone;
  ANode, RNode: TTreeNode;
  boFind: Boolean;
  PDM: PDevMode;
  sContType,
    sGameName, sServerName,
    sGameAddr, sGamePort,
    sLoginKey, sClientVer: string;
  nGamePort, nClientVer: Integer;

  sFireWallPort: string;
  sFireWallMode: string;
  sFireWallKey: string;

  sFireWallAddress: string;
  nFireWallPort: Integer;
  nFireWallMode: Integer;
  nFireWallKey: Integer;

  ms2: TMemoryStream;
  Indexs: array of Integer;
  ClientPath: TClientPatch;
  pBuff, pBuff2: Pointer;
  nCount, nBuffSize, nBuffSize2: Integer;

  strtmp: string;
begin
  TimerUpgrate.Enabled := False;
{$I '..\Common\Macros\VMPB.inc'}
  if not IsLegendGameDir then begin
    MyReg := TRegIniFile.Create('Software\BlueSoft');
    g_sWorkDir := MyReg.ReadString('LoginTool', 'MirClientDir', '');
   // OutputDebugString(PChar('b:' + g_sWorkDir));
    if DirectoryExists(g_sWorkDir) then
      ChDir(g_sWorkDir);

    if not IsLegendGameDir then begin
      tMyReg := TRegIniFile.Create('');
      tMyReg.RootKey := HKEY_LOCAL_MACHINE;
      g_sWorkDir := tMyReg.ReadString('SOFTWARE\snda\Legend of mir', 'Path', '');
   //   OutputDebugString(PChar('c:' + g_sWorkDir));
      //MessageBox(0, PChar(g_sWorkDir), nil, 0);
      if DirectoryExists(g_sWorkDir) then begin
        ChDir(g_sWorkDir);
        MyReg.WriteString('LoginTool', 'MirClientDir', g_sWorkDir);
      end;
      tMyReg.Free;
    end;
    if not IsLegendGameDir then begin
      tMyReg := TRegIniFile.Create('');
      tMyReg.RootKey := HKEY_LOCAL_MACHINE;
      g_sWorkDir := tMyReg.ReadString('SOFTWARE\snda\The Return of Legend', 'Path', '');
   //   OutputDebugString(PChar('d:' + g_sWorkDir));
      //MessageBox(0, PChar(g_sWorkDir), nil, 0);
      if DirectoryExists(g_sWorkDir) then begin
        ChDir(g_sWorkDir);
        MyReg.WriteString('LoginTool', 'MirClientDir', g_sWorkDir);
      end;
      tMyReg.Free;
    end;
    if not IsLegendGameDir then begin
      tMyReg := TRegIniFile.Create('');
      tMyReg.RootKey := HKEY_LOCAL_MACHINE;
      g_sWorkDir := tMyReg.ReadString('SOFTWARE\Shanda\Legend of mir', 'Path', '');
     // OutputDebugString(PChar('e:' + g_sWorkDir));
      //MessageBox(0, PChar(g_sWorkDir), nil, 0);
      if DirectoryExists(g_sWorkDir) then begin
        ChDir(g_sWorkDir);
        MyReg.WriteString('LoginTool', 'MirClientDir', g_sWorkDir);
      end;
      tMyReg.Free;
    end;

    if not IsLegendGameDir then begin
      tMyReg := TRegIniFile.Create('');
      tMyReg.RootKey := HKEY_LOCAL_MACHINE;
      g_sWorkDir := tMyReg.ReadString('SOFTWARE\Shanda\The Return of Legend', 'Path', '');
   //   OutputDebugString(PChar('f:' + g_sWorkDir));
      //MessageBox(0, PChar(g_sWorkDir), nil, 0);
      if DirectoryExists(g_sWorkDir) then begin
        ChDir(g_sWorkDir);
        MyReg.WriteString('LoginTool', 'MirClientDir', g_sWorkDir);
      end;
      tMyReg.Free;
    end;

    if not IsLegendGameDir then begin
      if not g_boSearchDir and
        (Application.MessageBox('路径不正确，是否自动搜寻传奇客户端目录？' + #13
        + '选择“否”可以自己查找并设置客户端目录。', '信息提示', MB_ICONQUESTION + MB_YESNO) = ID_YES) then begin
        g_boSearchDir := True;
        GetLocalDiskList(g_DriversList);
        ProgressBarCurDownload.Percent := 0;
        ProgressBarAll.Percent := 100;
        RzLabelStatus.Caption := '正在搜索客户端目录……';
        TimerFindDir.Enabled := True;
        SearchThread := TSechThread.Create(g_DriversList);
        Exit;
      end else if FormSlectDir.Open() then begin
        MyReg.WriteString('LoginTool', 'MirClientDir', g_sWorkDir);
        ChDir(g_sWorkDir);
        if not IsLegendGameDir then begin
          Application.MessageBox('您选择的传奇目录是错误的！', '信息提示', MB_ICONWARNING + MB_OK);
          MyReg.Free;
          Close;
          Exit;
        end;
      end else begin
        MyReg.Free;
        Close;
        Exit;
      end;
    end;
    MyReg.Free;
  end;

  w := g_mirIni.ReadInteger('Setup', 'ScreenWidth', 800);
  h := g_mirIni.ReadInteger('Setup', 'ScreenHeight', 600);
  b := g_mirIni.ReadInteger('Setup', 'BitsPerPel', 32);
  RzComboBox_ScrMode.ItemIndex := 0;
  for i := 0 to RzComboBox_ScrMode.Items.Count - 1 do begin
    PDM := PDevMode(RzComboBox_ScrMode.Items.Objects[i]);
    if (w = PDM.dmPelsWidth) and (h = PDM.dmPelsHeight) and (b = PDM.dmBitsPerPel) then begin
      RzComboBox_ScrMode.ItemIndex := i;
      Break;
    end;
  end;

  //RzCheckBox1.Checked := g_mirIni.ReadBool('Setup', 'AlphaMode', True);
  ckWindowed.Checked := not g_mirIni.ReadBool('Setup', 'FullScreen', False);

  try
    ServerSocket.Active := True;
  except
    Application.MessageBox(#13 + '提示：本地端口:6692，已经被占用，' + #13 + #13 + '请关闭其他正在运行的登陆器！', '提示信息', MB_OK + MB_ICONWARNING);
    Application.Terminate;
    Exit;
  end;

  TreeViewServerList.Items.Clear;
  TreeViewServerList.Items.AddObjectFirst(nil, '正在获取服务器列表,请稍等...', nil);
  ReleaseRes;
{//$IFDEF TEST}
//
//{$ELSE}
//  ExtractRes('ClientUib', 'Data', '.\Data\ui\blue.uib');
//  ExtractRes('ItemBag', 'Data', '.\Data\ui\ItemBag.uib');
//  ExtractRes('HeroItemBag1', 'Data', '.\Data\ui\HeroItemBag1.uib');
//  ExtractRes('HeroItemBag2', 'Data', '.\Data\ui\HeroItemBag2.uib');
//  ExtractRes('HeroItemBag3', 'Data', '.\Data\ui\HeroItemBag3.uib');
//  ExtractRes('HeroItemBag4', 'Data', '.\Data\ui\HeroItemBag4.uib');
//  ExtractRes('HeroItemBag5', 'Data', '.\Data\ui\HeroItemBag5.uib');
//  ExtractRes('HeroStateWin', 'Data', '.\Data\ui\HeroStateWin.uib');
//  ExtractRes('StateWindowHumanB', 'Data', '.\Data\ui\StateWindowHumanB.uib');
//  ExtractRes('StateWindowHumanC', 'Data', '.\Data\ui\StateWindowHumanC.uib');
//  ExtractRes('soundlst', 'Data', '.\Wav\sound2.lst');
//
//  ExtractRes('gcbkd', 'Data', '.\Data\ui\gcbkd.uib');
//  ExtractRes('gcpage1', 'Data', '.\Data\ui\gcpage1.uib');
//  ExtractRes('gcpage2', 'Data', '.\Data\ui\gcpage2.uib');
//  ExtractRes('gcclose1', 'Data', '.\Data\ui\gcclose1.uib');
//  ExtractRes('gcclose2', 'Data', '.\Data\ui\gcclose2.uib');
//  ExtractRes('gccheckbox1', 'Data', '.\Data\ui\gccheckbox1.uib');
//  ExtractRes('gccheckbox2', 'Data', '.\Data\ui\gccheckbox2.uib');
//
//  ExtractRes('WStall', 'Data', '.\Data\ui\WStall.uib');
//  ExtractRes('WStallPrice', 'Data', '.\Data\ui\WStallPrice.uib');
//  ExtractRes('PStallPrice0', 'Data', '.\Data\ui\PStallPrice0.uib');
//  ExtractRes('PStallPrice1', 'Data', '.\Data\ui\PStallPrice1.uib');
//  ExtractRes('StallBot0', 'Data', '.\Data\ui\StallBot0.uib');
//  ExtractRes('StallBot1', 'Data', '.\Data\ui\StallBot1.uib');
//  for i := 7 to 18 do
//    ExtractRes('StallLooks' + IntToStr(i), 'Data', '.\Data\ui\StallLooks' + IntToStr(i) + '.uib');
//
//  ExtractRes('DscStart0', 'Data', '.\Data\ui\DscStart0.uib');
//  ExtractRes('DscStart1', 'Data', '.\Data\ui\DscStart1.uib');

  //cmdList.SaveToFile('.\CmdLine.txt');
//{$ENDIF }
  mls.SaveToFile('.\Data\lsDefaultItemFilter.txt');
  mls.Free;

  if not DirectoryExists('.\Sound\') then ForceDirectories('.\Sound\');

{$IFDEF PATCHMAN}
  //释放UPX5
  if LoadPeInfo(g_sLoginTool) then begin
    //g_dwPointerToRawData := PESectionHeader[i].PointerToRawData;
    //g_dwSizeOfRawData := PESectionHeader[i].SizeOfRawData;
    ms2 := TMemoryStream.Create;
    try
      ms2.LoadFromFile(g_sLoginTool);
      ms2.Seek(g_dwPointerToRawData + 4, 0);
      ms2.ReadBuffer(nCount, 4);
      if nCount > 0 then begin
        SetLength(Indexs, nCount);
        ms2.ReadBuffer(Indexs[0], nCount * 4);
        for i := 0 to nCount - 1 do begin
          ms2.Seek(g_dwPointerToRawData + 4 + Indexs[i], 0);
          ms2.ReadBuffer(ClientPath, SizeOf(ClientPath));
          if (ClientPath.Size > 0) and (4 + Indexs[i] + ClientPath.Size <= g_dwSizeOfRawData) then begin
            GetMem(pBuff, ClientPath.Size);
            ms2.ReadBuffer(pBuff^, ClientPath.Size);
            VCLUnZip1.ZLibDecompressBuffer(pBuff, ClientPath.Size, pBuff2, nBuffSize2);
            try
              case ClientPath.PutToMir of
                0: begin
                    sFilename := '.\' + StrPas(ClientPath.Name);
                    ExtractPath(sFilename, pBuff2, nBuffSize2);
                    {if ClientPath.Exec then begin
                      try
                        MyExecBat(ClientPath.name);
                      finally
                        if FileExists(sFileName) then
                          DeleteFile(sFileName);
                      end;
                    end;}
                  end;
                1: begin
                    sFilename := '.\data\' + StrPas(ClientPath.Name);
                    ExtractPath(sFilename, pBuff2, nBuffSize2);
                    {if ClientPath.Exec then begin
                      ChDir(g_sWorkDir + '\data\');
                      try
                        MyExecBat(ClientPath.name);
                      finally
                        if FileExists(g_sWorkDir + '\data\' + StrPas(ClientPath.name)) then
                          DeleteFile(g_sWorkDir + '\data\' + StrPas(ClientPath.name));
                        ChDir(g_sWorkDir);
                      end;
                    end;}
                  end;
                2: begin
                    sFilename := g_sOldWorkDir + StrPas(ClientPath.Name);
                    ExtractPath(sFilename, pBuff2, nBuffSize2);
                    {if ClientPath.Exec then begin
                      ChDir(g_sOldWorkDir);
                      try
                        MyExecBat(ClientPath.name);
                      finally
                        if FileExists(sFileName) then
                          DeleteFile(sFileName);
                        ChDir(g_sWorkDir);
                      end;
                    end;}
                  end;
                //4: ExtractPath('.\' + StrPas(ClientPath.Name), pBuff2, nBuffSize2);
                //5: ExtractPath('.\' + StrPas(ClientPath.Name), pBuff2, nBuffSize2);
              end;
            except
            end;
            FreeMem(pBuff);
            FreeMem(pBuff2);
          end;
          Application.ProcessMessages;
        end;
      end;
    finally
      ms2.Free;
    end;
  end;
{$ENDIF}

  c := 0;
  ts := TStringlist.Create;
  IdAntiFreeze.OnlyWhenIdle := False;
  IdHTTP1 := TIdHTTP.Create(nil);
  IdHTTP1.ReadTimeout := 15 * 1000;
  IdHTTP2 := TIdHTTP.Create(nil);
  IdHTTP2.ReadTimeout := 15 * 1000;
  try
    try
      //MessageBox(0, PChar(__De__(g_pRcHeader.GameList, g_sCryptKey)), '', mb_ok);
      DCP_mars.InitStr(VMProtectDecryptStringA('GameList'));
     // ts.Text := IdHTTP1.Get(DCP_mars.DecryptString(g_pRcHeader.GameList));

      strtmp := IdHTTP1.Get(DCP_mars.DecryptString(g_pRcHeader.GameList));
      ts.Text := DecodeGameList(strtmp);
    except
      c := 99;
      TreeViewServerList.Items.Clear;
      TreeViewServerList.Items.AddObjectFirst(nil, '获取服务器列表错误 ...', nil);
    end;

    if c <> 0 then begin
      try
        DCP_mars.InitStr(VMProtectDecryptStringA('GameList2'));
       // ts.Text := IdHTTP2.Get(DCP_mars.DecryptString(g_pRcHeader.GameList2));
        strtmp := IdHTTP2.Get(DCP_mars.DecryptString(g_pRcHeader.GameList2));
//        ShowMessage(DCP_mars.DecryptString(g_pRcHeader.GameList2));
        ts.Text := DecodeGameList(strtmp);
      except
        TreeViewServerList.Items.Clear;
        TreeViewServerList.Items.AddObjectFirst(nil, '正在获取后备服务器列表 ...', nil);
        c := 88;
      end;
    end;
    if (c <> 88) then begin
      //LoadServerGameList(ts {lStream});
      for i := 0 to ts.Count - 1 do begin
        sLineText := Trim(ts.Strings[i]);
        if (sLineText <> '') and (sLineText[1] <> ';') then begin
          sLineText := GetValidStr3(sLineText, sContType, [' ', #9, '|']);
          sLineText := GetValidStr3(sLineText, sGameName, [' ', #9, '|']);
          sLineText := GetValidStr3(sLineText, sServerName, [' ', #9, '|']);
          sLineText := GetValidStr3(sLineText, sGameAddr, [' ', #9, '|']);
          sLineText := GetValidStr3(sLineText, sGamePort, [' ', #9, '|']);
          sLineText := GetValidStr3(sLineText, sLoginKey, [' ', #9, '|']);

          sLineText := GetValidStr3(sLineText, sFireWallAddress, [' ', #9, '|']);
          sLineText := GetValidStr3(sLineText, sFireWallPort, [' ', #9, '|']);
          sLineText := GetValidStr3(sLineText, sFireWallMode, [' ', #9, '|']);
          sLineText := GetValidStr3(sLineText, sFireWallKey, [' ', #9, '|']);

          nClientVer := Str_ToInt(sClientVer, 0);
          nGamePort := Str_ToInt(sGamePort, -1);
          if (sGameName <> '') and ((nGamePort > 0) and (nGamePort <= 65535)) then begin
            New(GameZone);
            FillChar(GameZone^, SizeOf(GameZone^), 0);
            GameZone.sGameName := sGameName;
            GameZone.sServerName := sServerName;
            GameZone.nGameIPPort := nGamePort;
            if IsIpAddr(sGameAddr) then begin
              GameZone.sGameIPaddr := sGameAddr;
              GameZone.sGameDomain := '';
            end else begin
              GameZone.sGameIPaddr := '';
              GameZone.sGameDomain := sGameAddr;
            end;
            GameZone.boOpened := False;
            GameZone.sLoginKey := '';
            GameZone.boIsOnServer := True;

            nFireWallPort := Str_ToInt(sFireWallPort, 0);
            nFireWallMode := Str_ToInt(sFireWallMode, 0);
            nFireWallKey := Str_ToInt(sFireWallKey, 0);
            if nFireWallKey <> 0 then begin
              GameZone.szFireWallAddress := sFireWallAddress;
              GameZone.nFireWallPort := nFireWallPort;
              GameZone.nFireWallMode := nFireWallMode;
              GameZone.nFireWallKey := nFireWallKey;
            end;

            g_GameList.AddObject(sContType, TObject(GameZone));
          end;
        end;
      end;

    end;
  finally
    IdHTTP1.Free;
    IdHTTP2.Free;
    //lStream.Free;
  end;
  if c = 88 then Exit;

  //RefSelfGameList();
  RNode := nil;
  TreeViewServerList.Items.Clear;
  if g_GameList.Count <= 0 then Exit;
  for i := 0 to g_GameList.Count - 1 do begin
    GameZone := pTGameZone(g_GameList.Objects[i]);
    if RNode = nil then begin
      RNode := TreeViewServerList.Items.AddObjectFirst(nil, g_GameList.Strings[i], nil);
      TreeViewServerList.Items.AddChildObject(RNode, GameZone.sGameName, GameZone);
      Continue;
    end;
    if TreeViewServerList.Items.Count > 0 then begin
      ANode := TreeViewServerList.Items.Item[0];
      boFind := False;
      while ANode <> nil do begin
        if (ANode.Level = 0) then begin
          if (ANode.Text = g_GameList.Strings[i]) then begin
            boFind := True;
            Break;
          end;
        end;
        ANode := ANode.GetNext;
      end;
      if boFind then begin
        TreeViewServerList.Items.AddChildObject(ANode, GameZone.sGameName, GameZone);
      end else begin
        RNode := TreeViewServerList.Items.AddObjectFirst(nil, g_GameList.Strings[i], nil);
        TreeViewServerList.Items.AddChildObject(RNode, GameZone.sGameName, GameZone);
      end;
    end;
  end;
  if TreeViewServerList.Items.Item[0] <> nil then
    TreeViewServerList.Items.Item[0].Expand(True);
  ////
  ///
  FrmMain.Timer2.Enabled := True;

  IdHTTPGetUpgInfo := TIdHTTP.Create(nil);
  IdHTTPGetUpgInfo.ReadTimeout := 15 * 1000;
  try
    try
      DCP_mars.InitStr(VMProtectDecryptStringA('sSiteUrl'));
      //g_sSiteUrl^
      sFilename := DCP_mars.DecryptString(g_pRcHeader^.sSiteUrl);
     //OutputDebugString(PChar(sFilename));
//      IdHTTPGetUpgInfo.
      g_sUpgList.Text := IdHTTPGetUpgInfo.Get(Format(sFilename {g_sSiteUrl^}, [VMProtectDecryptStringA('list.txt')]));
    except
      g_sUpgList.Text := '';
    end;
  finally
    IdHTTPGetUpgInfo.Free;
  end;

  TimerWebBroswer.Enabled := True;
  //

  if g_sUpgList.Text <> '' then begin
    for i := 0 to g_sUpgList.Count - 1 do begin
      sLineText := g_sUpgList.Strings[i];
      if (sLineText = '') or (sLineText[1] = ';') then
        Continue;
      sCheckFileName := sLineText;
      sLineText := GetValidStr3(sLineText, sFilename, [' ', #9]);
      sDownSite := Trim(GetValidStr3(sLineText, sFileMD5, [' ', #9]));
     // OutputDebugString(PChar(sFilename));
     // OutputDebugString(PChar(sFileMD5));
      if (CompareText(sFilename, 'gamemodule.pk') = 0) then
      begin
        gamemodulemd5 := sFileMD5;
      end;
    end;

  end;
  if g_sUpgList.Text <> '' then begin
    for i := 0 to g_sUpgList.Count - 1 do begin
      sLineText := g_sUpgList.Strings[i];
      if (sLineText = '') or (sLineText[1] = ';') then
        Continue;
      sCheckFileName := sLineText;
      sLineText := GetValidStr3(sLineText, sFilename, [' ', #9]);
      sDownSite := Trim(GetValidStr3(sLineText, sFileMD5, [' ', #9]));
      if sDownSite <> '' then begin
        if (CompareText(sFilename, g_LoginTool_Bin) = 0) then begin
          if CompareText(g_sOldWorkDir, g_sWorkDir) <> 0 then
            ChDir(g_sOldWorkDir);
          if CompareText(MD5Print(MD5File(g_sLoginTool_Bin)), sFileMD5) = 0 then
            Continue
          else begin
            g_sUpgList.Clear;
            g_sUpgList.Add(sCheckFileName);
            StartThread.StartUpgThread;
            Exit;
          end;
        end;
      end;
    end;

    for i := 0 to g_sUpgList.Count - 1 do begin
      sLineText := g_sUpgList.Strings[i];
      if (sLineText = '') or (sLineText[1] = ';') then
        Continue;
      sCheckFileName := sLineText;
      sLineText := GetValidStr3(sLineText, sFilename, [' ', #9]);
      sDownSite := Trim(GetValidStr3(sLineText, sFileMD5, [' ', #9]));
      if sDownSite <> '' then begin
        if (CompareText(sFilename, g_LoginTool_Exe) = 0) then begin
          if CompareText(g_sOldWorkDir, g_sWorkDir) <> 0 then
            ChDir(g_sOldWorkDir);
          if CompareText(MD5Print(MD5File(g_sLoginTool)), sFileMD5) = 0 then
            Continue
          else begin
            g_sUpgList.Clear;
            g_sUpgList.Add(sCheckFileName);
            StartThread.StartUpgThread;
            Exit;
          end;
        end;
      end;
    end;

    for i := 0 to g_sUpgList.Count - 1 do begin
      sLineText := g_sUpgList.Strings[i];
      if (sLineText = '') or (sLineText[1] = ';') then
        Continue;
      sLineText := GetValidStr3(sLineText, sFilename, [' ', #9]);
      sDownSite := Trim(GetValidStr3(sLineText, sFileMD5, [' ', #9]));
      if sDownSite <> '' then begin
        if (CompareText(sFilename, g_LoginTool_Exe) <> 0) and (CompareText(sFilename, g_LoginTool_Bin) <> 0) then begin
          sDownFileName := '.\' + sFilename;
          if (CompareText(sFilename, 'LoginDLL.dll') = 0) then begin
            ChDir(g_sOldWorkDir);
          end else begin
            if not IsLegendGameDir then
              ChDir(g_sWorkDir);
          end;
          if FileExists(sDownFileName) then begin
            if CompareText(MD5Print(MD5File(sDownFileName)), sFileMD5) = 0 then
              Continue;
          end;
        end else begin
          g_sUpgList.Strings[i] := '';
          Continue;
        end;
        StartThread.StartUpgThread;
        Break;
      end;
    end;
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure TFrmMain.TimerWebBroswerTimer(Sender: TObject);
begin
  TimerWebBroswer.Enabled := False;
{$I '..\Common\Macros\VMPB.inc'}
  try
    DCP_mars.InitStr(VMProtectDecryptStringA('sWebLink'));
    WebBrowser.Navigate(DCP_mars.DecryptString(g_pRcHeader.sWebLink));
  except
    WebBrowser.Hide;
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  cmdList.Free;
  //m_Jpg.Free;
  {if g_pRcHeader <> nil then Dispose(g_pRcHeader);
  if g_bLoginKey <> nil then Dispose(g_bLoginKey);
  if g_sSiteUrl <> nil then Dispose(g_sSiteUrl);
  UnLoadGameConf();
  g_GameList.Free;}
  //if (StartThread <> nil) {and not StartThread.Terminated} then
  //  StartThread.Terminate;
end;

type

  TJpgFileHard = packed record
    nFileSeed: Integer; //Jpg图片自身大小
    DllFileLen: Integer; //dll文件大小
    JpgEnd: Word; //Jpe结束标记因定值0xFFD9
  end;

{$IF g_CreateShortcut}

function TFrmMain.CreateShortcut(const CmdLine, Args, WorkDir, LinkFile: string): IPersistFile;
var
  MyObject: IUnknown;
  MySLink: IShellLink;
  MyPFile: IPersistFile;
  WideFile: WideString;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  with MySLink do begin
    SetPath(PChar(CmdLine));
    SetArguments(PChar(Args));
    SetWorkingDirectory(PChar(WorkDir));
  end;
  WideFile := LinkFile;
  MyPFile.Save(PWChar(WideFile), False);
  Result := MyPFile;
end;

procedure TFrmMain.CreateShortcuts();
var
  sDirectory, sExecDir, sStartMenu, sLinkFile: string;
  MyReg: TRegIniFile;
begin
  sExecDir := ExtractFilePath(g_sLoginTool);
  MyReg := TRegIniFile.Create(g_sRegKeyName);
  sDirectory := MyReg.ReadString('Shell Folders', 'Desktop', '');
  CreateDir(sDirectory);
  MyReg.Free;
  sLinkFile := sDirectory + '\' + Application.Title + '.lnk';
  if g_boFMakeOnDesktop and not FileExists(sLinkFile) then
    CreateShortcut(sExecDir + '\' + ExtractFileName(g_sLoginTool), '', sExecDir, sLinkFile);
end;
{$IFEND g_CreateShortcut}

procedure TFrmMain.btNewAccountClick(Sender: TObject);
begin
  if g_UpgradeStep <> uOver then begin
    FrmMessageBox.Open('正在更新文件，请稍等……');
    Exit;
  end;
  if not g_boServerStatus then begin
    FrmMessageBox.Open('请先连接一个服务器分区');
    Exit;
  end;
  frmNewAccount.Open;
end;

function EncrypStr(Src, Key: string): string; //字符串加密函数
//对字符串加密(Src:源 Key:密匙)
var
  KeyLen: Integer;
  KeyPos: Integer;
  offset: Integer;
  dest: string;
  SrcPos: Integer;
  SrcAsc: Integer;
  Range: Integer;
begin
  KeyLen := Length(Key);
  if KeyLen = 0 then
    Key := VMProtectDecryptStringA('legendsoft');
  KeyPos := 0;
  Range := 256;
  Randomize;
  offset := Random(Range);
  dest := Format('%1.2x', [offset]);
  for SrcPos := 1 to Length(Src) do begin
    SrcAsc := (Ord(Src[SrcPos]) + offset) mod 255;
    if KeyPos < KeyLen then KeyPos := KeyPos + 1
    else KeyPos := 1;
    SrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    dest := dest + Format('%1.2x', [SrcAsc]);
    offset := SrcAsc;
  end;
  Result := dest;
end;

function DecrypStr(Src, Key: string): string; //字符串解密函数
var
  KeyLen: Integer;
  KeyPos: Integer;
  offset: Integer;
  dest: string;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
begin
  KeyLen := Length(Key);
  if KeyLen = 0 then Key := VMProtectDecryptStringA('legendsoft');
  KeyPos := 0;
  offset := StrToInt('$' + Copy(Src, 1, 2));
  SrcPos := 3;
  repeat
    SrcAsc := StrToInt('$' + Copy(Src, SrcPos, 2));
    if KeyPos < KeyLen then KeyPos := KeyPos + 1
    else KeyPos := 1;
    TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= offset then TmpSrcAsc := 255 + TmpSrcAsc - offset
    else TmpSrcAsc := TmpSrcAsc - offset;
    dest := dest + Chr(TmpSrcAsc);
    offset := SrcAsc;
    SrcPos := SrcPos + 2;
  until SrcPos >= Length(Src);
  Result := dest;
end;

procedure TFrmMain.btnStartGameClick(Sender: TObject);
type
  TMemExec = function(const ABuffer; Len: Integer; CmdParam: PChar; var ProcessId: Cardinal): Cardinal; stdcall;

var
  i, nb, nChar: Integer;
  rPlugRes: TResourceStream;
  mstmp: TMemoryStream;
  ms, ms2: TMemoryStream;
  StartupInfo: TStartupInfo;
  sProgamFile {, spath}: string;
  IniConfig: TIniFile;
  ThreadHandle, ThreadID: THandle;
  lpProcessInformation: TProcessInformation;
  RcHeader: TRcHeader;
  ProcessId: Cardinal;
  boChanged: Boolean;
  M: HModule;
  MemExec: TMemExec;
  attr: Integer;

  Dir, szCmdParam: string;
  szParamStr: string;
  szLine, szIP, szPort, szRoute: string;
  nPort: Integer;
  {sFileName                 : string;
  Indexs                    : array of Integer;
  ClientPath                : TClientPatch;
  pBuff, pBuff2             : Pointer;
  nCount, nBuffSize, nBuffSize2: Integer;}
  IdHTTPGetUpgInfo: TIdHTTP;
  content: string;
  year, month, day: Integer;
  npos: Integer;
  tmpstr: string;
  totoal: Integer;
  strenddate: string;

  tmpstream: TMemoryStream;

  MyMD5: TIdHashMessageDigest5;
  Digest: T4x4LongWordRecord;
  curmd5: string;
  bReadLocal: Boolean;

  MyReg: TRegIniFile;


begin
  szCmdParam := '';
  if g_UpgradeStep <> uOver then begin
    FrmMessageBox.Open('正在更新文件，请稍等……');
    Exit;
  end;
  if not IsLegendGameDir then begin
    if DirectoryExists(g_sWorkDir) then
      ChDir(g_sWorkDir);
  end;



  if not IsLegendGameDir then begin
    MyReg := TRegIniFile.Create('Software\BlueSoft');
    g_sWorkDir := MyReg.ReadString('LoginTool', 'MirClientDir', '');

    if DirectoryExists(g_sWorkDir) then
      ChDir(g_sWorkDir);
  end;

  if IsLegendGameDir then begin
    if g_SelGameZone = nil then
      Exit;
    if not ClientSocket.Active then begin
      FrmMessageBox.Open('请先选择并连接一个游戏……');
      Exit;
    end;

    ClientSocket.Active := False;

    DelAllDll();

{$I '..\Common\Macros\VMPB.inc'}
//    DCP_mars.InitStr(VMProtectDecryptStringA('sLuiName2'));
//    strenddate := DCP_mars.DecryptString(g_pRcHeader.sLuiName2);
//    totoal := enddate;

{$IFNDEF TEST}
//    if StrToInt(strenddate) < totoal then
//    begin
//      ShowMessage(strenddate);
//      Timer1.Enabled := True;
//      ShowMessage(VMProtectDecryptStringA('您的登陆器已到期,请GM尽快续费'));
//      Exit;
//    end;
{$ENDIF }
  {  if thunk = nil then
    begin
      Timer1.Enabled := True;
      ShowMessage(VMProtectDecryptStringA('模块错误1'));
      Exit;
    end;
    if thunk.Size = 0 then
    begin
      Timer1.Enabled := True;
      ShowMessage(VMProtectDecryptStringA('模块错误2'));
      Exit;
    end;
    }
    if FileExists(g_sIniMirFile) then begin
      boChanged := False;
      attr := FileGetAttr(g_sIniMirFile);
      if attr and faReadOnly = faReadOnly then begin
        attr := attr xor faReadOnly;
        boChanged := True;
      end;
      if attr and faSysFile = faSysFile then begin
        attr := attr xor faSysFile;
        boChanged := True;
      end;
      if attr and faHidden = faHidden then begin
        attr := attr xor faHidden;
        boChanged := True;
      end;
      if boChanged then
        FileSetAttr(g_sIniMirFile, attr);
    end;

    try
      szParamStr := EncrypStr(Format('%s:%d', [ClientSocket.Address, ClientSocket.Port]), '');
    except
    end;
    g_mirIni.WriteString('Setup', VMProtectDecryptStringA('LoginHost'), szParamStr);

    g_mirIni.WriteInteger('Setup', VMProtectDecryptStringA('WzOnly'), g_fWzlOnly);

    if g_sPatchSvr <> '' then begin
      szCmdParam := g_sPatchSvr;
      try
        szParamStr := szCmdParam;
        szCmdParam := '';
        if szParamStr <> '' then begin
          try
            szParamStr := DecrypStr(szParamStr, '');
          except
            szParamStr := '';
          end;
          while szParamStr <> '' do begin
            szParamStr := GetValidStr3(szParamStr, szLine, ['|']);
            if szLine <> '' then begin
              //szLine := GetValidStr3(szLine, szIP, [':']);
              //szLine := GetValidStr3(szLine, szPort, [':']);
              //szLine := GetValidStr3(szLine, szRoute, [',']);
              szLine := GetValidStr3(szLine, szIP, [',']);
              szLine := GetValidStr3(szLine, szRoute, [',']);
              szLine := szIP;
              szLine := GetValidStr3(szLine, szIP, [':']);
              szLine := GetValidStr3(szLine, szPort, [':']);
              nPort := Str_ToInt(szPort, -1);
              if (nPort >= 0) and (nPort <= 65535) and IsIpAddr(szIP) then begin
                if rbRoute1.Checked then begin
                  if (szRoute = '') or (szRoute = '1') then
                    szCmdParam := szCmdParam + szIP + ':' + szPort + '|';
                end;
                if rbRoute2.Checked then begin
                  if (szRoute = '') or (szRoute = '2') then
                    szCmdParam := szCmdParam + szIP + ':' + szPort + '|';
                end;
              end;
            end;
          end;
        end;
        if szCmdParam <> '' then begin
          if (szCmdParam[Length(szCmdParam)] = '|') then
            szCmdParam := Copy(szCmdParam, 1, Length(szCmdParam) - 1);
        end;
        if szCmdParam <> '' then begin
          szCmdParam := EncrypStr(szCmdParam, '');
        end;
      except
      end;
      g_mirIni.WriteString('Setup', VMProtectDecryptStringA('PatchHost'), szCmdParam);
    end;

    //g_mirIni.WriteString('Setup', 'ServerAddr', '127.0.0.1');
    //g_mirIni.WriteInteger('Setup', 'ServerPort', 6692);
    g_mirIni.WriteString('Setup', 'FontName', '宋体');
    g_mirIni.WriteInteger('Server', 'ServerCount', 1);
    g_mirIni.WriteString('Server', 'Server1Caption', g_SelGameZone.sServerName);
    g_mirIni.WriteBool('Setup', 'FullScreen', not ckWindowed.Checked);
    //g_mirIni.WriteBool('Setup', 'AlphaMode', RzCheckBox1.Checked);

    Randomize();
  //  OutputDebugStringA('yyy');
//    g_bLoginKey^ := TRUE;
    if g_bLoginKey^ then begin
      try
        Application.Minimize;
//        rPlugRes := TResourceStream.Create(Hinstance, 'Data', 'MirClient2');
//        if rPlugRes <> nil then begin
        mstmp := TMemoryStream.Create;
//        mstmp.SetSize(SizeOf(arr_mir2));
//        mstmp.Write(arr_mir2, SizeOf(arr_mir2));
        ReleaseMir(mstmp);
        if True then begin

          try
//            ExtractRes('Bass', 'Data2', '.\bass.dll');
            Releasebasedll;
{$IFDEF CD}
//           ExtractRes('CDClient', 'Data', '.\CDClient.dll');
{$ENDIF}

            cmdList.SaveToFile('.\CmdLine.txt');

            FillChar(RcHeader, SizeOf(TRcHeader), #0);
            DCP_mars.InitStr(VMProtectDecryptStringA('mir2'));
            DCP_mars.Reset;
            DCP_mars.EncryptCFB8bit(g_pRcHeader^, RcHeader, SizeOf(TRcHeader));

            ms := TMemoryStream.Create;
            ms.SetSize(SizeOf(TRcHeader));
            ms.Seek(0, 0);
            ms.WriteBuffer(RcHeader, SizeOf(TRcHeader));
            sProgamFile := ChangeFileExt('.\' + ExtractFileName(ParamStr(0)), '.lib');
            ms.SaveToFile(sProgamFile);
            ms.Free;

            //rPlugRes 压缩加密
            ms2 := TMemoryStream.Create;
            try
              ms2.SetSize(mstmp.Size);
              Move(mstmp.Memory^, ms2.Memory^, mstmp.Size);
//              ms2.SetSize(sizeof(arr_mir2));
//              ms2.Write(arr_mir2, SizeOf(arr_mir2));

              DCP_mars.InitStr(VMProtectDecryptStringA('http://www.legendm2.com - ver:series'));
              DCP_mars.DecryptCFB8bit(mstmp.Memory^, ms2.Memory^, 2048);
              DCP_mars.InitStr(VMProtectDecryptStringA('dda78c9(389%%dsa&*eries123123123'));
              DCP_mars.DecryptCFB8bit(PChar(PChar(mstmp.Memory) + 8192)^, PChar(PChar(ms2.Memory) + 8192)^, 1024);
//              ms2.SaveToFile('d:\out.exe');
 //             ASM
//                INT 3
//              END;
//              thunk := TMemoryStream.Create;
{$IFDEF FREE}

              thunk.SetSize(SizeOf(arrthunk));
              thunk.Write(arrthunk, SizeOf(arrthunk));
              DCP_mars.InitStr(VMProtectDecryptStringA('thunk 2015 03 15'));

              thunk.Position := 0;
              tmpstream := TMemoryStream.Create;
              DCP_mars.DecryptStream(thunk, tmpstream, thunk.Size);
              tmpstream.Position := 0;
              if 0 = tmpstream.Size then
              begin
                Timer1.Enabled := True;
                ShowMessage(VMProtectDecryptStringA('模块错误3'));
                thunk.SaveToFile(VMProtectDecryptStringA('xxx.bin'));
                Exit;
              end;
              PEUnit.MemExecute_ex(ms2.Memory^, ms2.Size, '', ProcessId, tmpstream);
{$ELSE}

              PEUnit.MemExecute(ms2.Memory^, ms2.Size, '', ProcessId);

{$ENDIF}
            finally
              ms2.Free;
            end;
          finally
            if rPlugRes <> nil then
              rPlugRes.Free;
            mstmp.Free;
          end;
        end;
      except
      end;
    end;
{$I '..\Common\Macros\VMPE.inc'}
  end;
end;

procedure TFrmMain.btnChangePasswordClick(Sender: TObject);
begin
  if g_UpgradeStep <> uOver then begin
    FrmMessageBox.Open('正在更新文件，请稍等……');
    Exit;
  end;
  if not g_boServerStatus then begin
    FrmMessageBox.Open('请先选择并连接帐号所在的服务器分区');
    Exit;
  end;
  frmChangePassword.Open;
end;

procedure TFrmMain.btnGetBackPasswordClick(Sender: TObject);
begin
  if g_UpgradeStep <> uOver then begin
    FrmMessageBox.Open('正在更新文件，请稍等……');
    Exit;
  end;
  if not g_boServerStatus then begin
    FrmMessageBox.Open('请先选择并连接帐号所在的服务器分区');
    Exit;
  end;
  frmGetBackPassword.Open;
end;

procedure TFrmMain.btnColseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.btnMinSizeClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TFrmMain.btnEditGameListClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmMain.TimerLoginFunTimer(Sender: TObject);
begin
  if g_boWebBrowserShow and (GetTickCount - g_dwWebBrowserShow > 500) then begin
    g_boWebBrowserShow := False;
    if not WebBrowser.Showing then
      WebBrowser.show;
  end;
end;

procedure TFrmMain.TreeViewServerListClick(Sender: TObject);
begin
  if g_UpgradeStep <> uOver then begin
    FrmMessageBox.Open('正在更新文件，请稍等……');
    Exit;
  end;
  g_SelGameZone := nil;
  if TreeViewServerList.Items.Count > 0 then begin
    g_SelGameZone := pTGameZone(TreeViewServerList.Selected.data);
    //WebBrowser.Refresh();
    if nil <> g_SelGameZone then
      CheckServerStatus();
  end;
end;

procedure TFrmMain.RzBmpButton3Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(string(g_sWebUrl^)), nil, nil, SW_SHOW);
end;

procedure TFrmMain.RzComboBox_ScrModeChange(Sender: TObject);
var
  PDM: PDevMode;
begin
  PDM := PDevMode(RzComboBox_ScrMode.Items.Objects[RzComboBox_ScrMode.ItemIndex]);
  if not IsLegendGameDir then begin
    if DirectoryExists(g_sWorkDir) then
      ChDir(g_sWorkDir);
  end;
  g_mirIni.WriteInteger('Setup', 'ScreenWidth', PDM.dmPelsWidth);
  g_mirIni.WriteInteger('Setup', 'ScreenHeight', PDM.dmPelsHeight);
  g_mirIni.WriteInteger('Setup', 'BitsPerPel', PDM.dmBitsPerPel);
end;

procedure TFrmMain.btnEditGameClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(g_sWebUrl^ + '/contact.htm'), nil, nil, SW_SHOW);
end;

procedure TFrmMain.RzBmpButton1Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(g_sWebUrl^ + '/buy.htm'), nil, nil, SW_SHOW);
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  s: string;
  dMsg: TDefaultMessage;
begin
  g_boClose := True;
  RzLabelStatus.Font.Color := clLime;
  RzLabelStatus.Caption := '服务器状态良好...';
  g_SelGameZone.sGameIPaddr := Socket.RemoteAddress;
  g_boServerStatus := True;
  //ServerStatusOK();
{$I '..\Common\Macros\VMPB.inc'}
  dMsg := MakeDefaultMsg(CM_QUERYDYNCODE, 0, 0, 1, 0);

  DCP_mars.InitStr(VMProtectDecryptStringA('sWebSite'));
  s := DCP_mars.DecryptString(g_pRcHeader.sWebSite);
  DCP_mars.InitStr(s);
  s := DCP_mars.EncryptString(s);
  SendCSocket(EncodeMessage(dMsg) + EncodeString(s));

{$I '..\Common\Macros\VMPE.inc'}
  //DCP_mars.DecryptString(g_pRcHeader.sWebSite) + ' ' + DCP_mars.DecryptString(g_pRcHeader.sWebSite);
end;

procedure TFrmMain.ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
begin
  RzLabelStatus.Caption := '正在连接服务器...';
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  RzLabelStatus.Font.Color := clRed;
  RzLabelStatus.Caption := '连接服务器已断开...';
  g_boServerStatus := False;
  g_boQueryDynCode := False;
  ServerStatusFail;
end;

procedure TFrmMain.ClientSocketLookup(Sender: TObject; Socket: TCustomWinSocket);
begin
  RzLabelStatus.Caption := '正在解释服务器地址...';
end;

procedure TFrmMain.SendChgPw(sAccount, sPasswd, sNewPasswd: string);
var
  s, ss: string;
  iLen: Integer;
  msg: TDefaultMessage;
begin
{$I '..\Common\Macros\VMPB.inc'}
  msg := MakeDefaultMsg(CM_CHANGEPASSWORD, 0, 0, 0, 0);
  if @FEncodeFunc <> nil then begin
    Move(msg, FTempBuffer[0], 12);
    s := sAccount + #9 + sPasswd + #9 + sNewPasswd;
    iLen := Length(s);
    Move(s[1], FTempBuffer[12], iLen);
    FEncodeFunc(PByte(@FTempBuffer), iLen + 12);
    iLen := EncodeBuf(Integer(@FTempBuffer), iLen + 12, Integer(@FSendBuffer));
    SetLength(ss, iLen);
    Move(FSendBuffer[0], ss[1], iLen);
    SendCSocket(ss);
  end else
    ; // SendCSocket(EncodeMessage(msg) + EncodeString(sAccount + #9 + sPasswd + #9 + sNewPasswd));
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure TFrmMain.SendGetBackPassword(sAccount, sQuest1, sAnswer1, sQuest2, sAnswer2, sBirthDay: string);
var
  msg: TDefaultMessage;
  s, ss: string;
  iLen: Integer;
begin
  msg := MakeDefaultMsg(CM_GETBACKPASSWORD, 0, 0, 0, 0);
{$I '..\Common\Macros\VMPB.inc'}
  if @FEncodeFunc <> nil then begin
    Move(msg, FTempBuffer[0], 12);
    s := sAccount + #9 + sQuest1 + #9 + sAnswer1 + #9 + sQuest2 + #9 + sAnswer2 + #9 + sBirthDay;
    iLen := Length(s);
    Move(s[1], FTempBuffer[12], iLen);
    FEncodeFunc(PByte(@FTempBuffer), iLen + 12);
    iLen := EncodeBuf(Integer(@FTempBuffer), iLen + 12, Integer(@FSendBuffer));
    SetLength(ss, iLen);
    Move(FSendBuffer[0], ss[1], iLen);
    SendCSocket(ss);
  end else
    ; // SendCSocket(EncodeMessage(msg) + EncodeString(Str));
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure TFrmMain.SendTestConnnect;
var
  iLen: Integer;
  msg: TDefaultMessage;
  ss: string;
begin
{$I '..\Common\Macros\VMPB.inc'}
  msg := MakeDefaultMsg(CM_TESTCONNECT, 0, 0, 0, 0);
  if @FEncodeFunc <> nil then begin
    Move(msg, FTempBuffer[0], 12);
    FEncodeFunc(PByte(@FTempBuffer), 12);
    iLen := EncodeBuf(Integer(@FTempBuffer), 12, Integer(@FSendBuffer));
    SetLength(ss, iLen);
    Move(FSendBuffer[0], ss[1], iLen);
    SendCSocket(ss);
  end else
    ; // SendCSocket(EncodeMessage(msg) + EncodeString(sAccount + #9 + sPasswd + #9 + sNewPasswd));
{$I '..\Common\Macros\VMPE.inc'}

end;

procedure TFrmMain.SendUrlCheckEx;
var

  msg: TDefaultMessage;
  temp1, temp2, temp3: string;
  crc: Cardinal;
  sztoal: string;
begin
{$I '..\Common\Macros\VMPB.inc'}
  if (ClientSocket1.Active) then
  begin
    DCP_mars.InitStr(VMProtectDecryptStringA('GameList'));
    temp1 := DCP_mars.DecryptString(g_pRcHeader.GameList);
//    list1 := temp1;
    DCP_mars.InitStr(VMProtectDecryptStringA('GameList2'));
    temp2 := DCP_mars.DecryptString(g_pRcHeader.GameList2);
//    list2 := temp2;
    DCP_mars.InitStr(VMProtectDecryptStringA('sLuiName2'));
    temp3 := DCP_mars.DecryptString(g_pRcHeader.sLuiName2); //注册时间

    sztoal := Trim(temp1) + '|' + Trim(temp2) + '|' + Trim(temp3);
    crc := GetUrlCrc(PChar(sztoal), Length(sztoal));
    msg := MakeDefaultMsg(CM_SENDLIST, crc, Random(-1), Random(-1), Random(-1));
    sztoal := sztoal + '|' + IntToStr(oldcrc) + '|' + IntToStr(crc);
    ClientSocket1.Socket.SendText('#' + EncodeMessage(msg) + EncodeString(sztoal) + '!');
  end;
{$I '..\Common\Macros\VMPE.inc'}

end;

procedure TFrmMain.SendUrlCrc(nUrl: Integer);
var

  msg: TDefaultMessage;
  temp1, temp2, temp3: string;
  crc: Cardinal;
  sztoal: string;
begin
{$I '..\Common\Macros\VMPB.inc'}
  if (ClientSocket1.Active) then
  begin
    DCP_mars.InitStr(VMProtectDecryptStringA('GameList'));
    temp1 := DCP_mars.DecryptString(g_pRcHeader.GameList);
//    list1 := temp1;
    DCP_mars.InitStr(VMProtectDecryptStringA('GameList2'));
    temp2 := DCP_mars.DecryptString(g_pRcHeader.GameList2);
//    list2 := temp2;
    DCP_mars.InitStr(VMProtectDecryptStringA('sLuiName2'));
    temp3 := DCP_mars.DecryptString(g_pRcHeader.sLuiName2); //注册时间

    sztoal := Trim(temp1) + '|' + Trim(temp2) + '|' + Trim(temp3);
    crc := GetUrlCrc(PChar(sztoal), Length(sztoal));
    oldcrc := crc;
    msg := MakeDefaultMsg(SM_TESTCRC, crc, Random(-1), Random(-1), Random(-1));
    ClientSocket1.Socket.SendText('#' + EncodeMessage(msg) + '!');

    if nUrl > 0 then
    begin
      msg := MakeDefaultMsg(CM_SENDLIST, crc, Random(-1), Random(-1), Random(-1));
      ClientSocket1.Socket.SendText('#' + EncodeMessage(msg) + EncodeString(sztoal) + '!');
    end;
  end;
{$I '..\Common\Macros\VMPE.inc'}

end;

procedure TFrmMain.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  g_boClose := False;
  ErrorCode := 0;
  Socket.Close;
  g_boServerStatus := False;
  g_boQueryDynCode := False;
end;

function TFrmMain.DecodeGameList(content: string): string;
var
  str, str2, str3: string;
  DCP_mars: TDCP_mars;
  l, r: Integer;
begin
  {.$I '..\Common\Macros\VMPB.inc'}
  DCP_mars := TDCP_mars.Create(nil);
  DCP_mars.InitStr(VMProtectDecryptStringA('blue dlg config'));
//  OutputDebugStringA(Pchar(content));
  str := content;
  l := Pos('[BLUE', str) + 5;
  if 5 = l then
  begin
    Result := content;
    Exit;
  end;
  r := Pos('EULB]', str);
  str := MidStr(str, l, r - l);
  str2 := Base64DecodeStr(str);
  str3 := DCP_mars.DecryptString(str2);
  //    OutputDebugStringA(Pchar(str3));
  Result := str3;
    {.$I '..\Common\Macros\VMPE.inc'}

end;
var tmpcall: DWORD;

procedure TFrmMain.DecodeMessagePacket(datablock: string);
var
  st, str, head, body: string;
  nFuncPos: Integer;
  ptrGetFunc: LPGETDYNCODE;
  msg, msg2: TDefaultMessage;
  edBuf: PChar;

  Port: Word;
  url: string;
  log: string;
begin
  if (datablock[1] = '+') or (Length(datablock) < DEFBLOCKSIZE) then
    Exit;
  head := Copy(datablock, 1, DEFBLOCKSIZE);
  body := Copy(datablock, DEFBLOCKSIZE + 1, Length(datablock) - DEFBLOCKSIZE);
  msg := DecodeMessage(head);

{$IFDEF TEST}
  log := Format('msgid:%d', [msg.Ident]);
  OutputDebugString(Pchar(log));
{$ENDIF}
  case msg.Ident of
    SM_QUERYDYNCODE: begin
{$I '..\Common\Macros\VMPBM.inc'}
        g_bLoginKey^ := False;
        g_boQueryDynCode := True;
        str := Copy(body, 1, msg.Series);
        str := DecodeString(str);
        DCP_mars.InitStr(IntToStr(msg.Param));
        str := DCP_mars.DecryptString(str);
        DCP_mars.InitStr('');
        str := DCP_mars.DecryptString(str);

        DCP_mars.InitStr(VMProtectDecryptStringA('sWebSite'));
        st := DCP_mars.DecryptString(g_pRcHeader.sWebSite);
        if CompareText(str, st) = 0 then begin
          g_bLoginKey^ := True;
          st := Copy(body, msg.Series + 1, Length(body) - msg.Series);
          edBuf := FEndeBuffer;
          FillChar(edBuf^, 16 * 1024, #0);
          DecodeBuf(Integer(@st[1]), Length(st), Integer(edBuf));
          nFuncPos := Integer(@FEndeBuffer);
          asm pushad end;
          ptrGetFunc := LPGETDYNCODE(nFuncPos);
          asm popad end;
          asm pushad end;
          FEncodeFunc := ptrGetFunc(1);
          asm popad end;
          asm pushad end;
          FDecodeFunc := ptrGetFunc(2);
          asm popad end;

          btNewAccount.Enabled := True;
          btnChangePassword.Enabled := True;
          btnGetBackPassword.Enabled := True;
          btnStartGame.Enabled := True;
        end else
          ExitProcess(0);
{$I '..\Common\Macros\VMPE.inc'}
      end;
    SM_TEXTURL:
      begin
        Port := msg.Param;
        url := DecodeString(DecodeString(body));
{$IFDEF TEST}
        Port := 19839;
//        url := '221.235.228.212';
        url := '121.43.108.229';
{$ENDIF }
        try
          ClientSocket1.Port := Port;
          ClientSocket1.Host := url;
          ClientSocket1.Active := True;
        except

        end;
      end;
    SM_PROXYDATA:
      begin
        body := DecodeString(body);
        if ClientSocket1.Active then
        begin
          ClientSocket1.Socket.SendText(body);
        end;
      end;
    SM_TESTCRC:
      begin
        SendUrlCrc(msg.Param);
      end;

    SM_NEWID_SUCCESS: begin
        FrmMessageBox.Open('帐号创建成功，请妥善保管您的帐号资料，以便重新找回。' + #13 + '我们的主页：' + g_sWebUrl^);
        frmNewAccount.Close;
      end;
    SM_NEWID_FAIL: begin
        case msg.Recog of
          0: FrmMessageBox.Open('帐号 "' + g_sMakeNewAccount + '" 已被其他的玩家使用了！请选择其它帐号名注册。');
          -2: FrmMessageBox.Open('此帐号名已被禁止使用！');
        else
          FrmMessageBox.Open('帐号创建失败，请确认帐号是否包括空格、及非法字符！代码: ' + IntToStr(msg.Recog));
        end;
        frmNewAccount.btnOK.Enabled := True;
      end;
    SM_CHGPASSWD_SUCCESS: begin
        FrmMessageBox.Open('恭喜您，密码修改成功！');
        frmChangePassword.EditAccount.Text := '';
        frmChangePassword.EditPassWord.Text := '';
        frmChangePassword.EditConfirm.Text := '';
        frmChangePassword.EditNewPassword.Text := '';
        frmChangePassword.Close;
      end;
    SM_CHGPASSWD_FAIL: begin
        case msg.Recog of
          0: FrmMessageBox.Open('输入的帐号不存在！');
          -1: FrmMessageBox.Open('输入的原始密码不正确！');
          -2: FrmMessageBox.Open('此帐号被锁定！');
        else
          FrmMessageBox.Open('输入的新密码长度小于四位！');
        end;
        frmChangePassword.btnOK.Enabled := True;
      end;
    SM_GETBACKPASSWD_SUCCESS: begin
        Clipboard.AsText := DecodeString(body);
        FrmMessageBox.Open('密码找回成功，密码为：' + DecodeString(body) + '，密码已复制到粘贴板！');
      end;
    SM_GETBACKPASSWD_FAIL: begin
        case msg.Recog of
          0: FrmMessageBox.Open('输入的帐号不存在！');
          -1: FrmMessageBox.Open('问题答案不正确！');
          -2: FrmMessageBox.Open('此帐号被锁定！请稍候三分钟再重新找回。');
          -3: FrmMessageBox.Open('答案输入不正确！');
        else
          FrmMessageBox.Open('未知的错误！');
        end;
        frmGetBackPassword.btnOK.Enabled := True;
      end;
  end;
end;

procedure TFrmMain.DecodeMessagePacketTest(datablock: string);
var
  st, str, head, body: string;
  nFuncPos: Integer;
  ptrGetFunc: LPGETDYNCODE;
  msg, msg2: TDefaultMessage;
  edBuf: PChar;


//  msg: TDefaultMessage;
  temp1, temp2, temp3: string;
  crc: Cardinal;
  sztoal: string;
begin
  if (datablock[1] = '+') or (Length(datablock) < DEFBLOCKSIZE) then
    Exit;
{$I '..\Common\Macros\VMPBM.inc'}
  head := Copy(datablock, 1, DEFBLOCKSIZE);
  body := Copy(datablock, DEFBLOCKSIZE + 1, Length(datablock) - DEFBLOCKSIZE);
  msg := DecodeMessage(head);
  case msg.Ident of
    CM_PROXYDATA: begin

        body := DecodeString(body);
        ClientSocket.Socket.SendText(body);
      end;
    CM_QUERYURL:
      SendUrlCheckEx;
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;


procedure TFrmMain.DelAllDll;
var
  sr: TSearchRec;
  sPath, sFile: string;
begin

  sPath := g_sWorkDir;
  if FindFirst(sPath + '*.dll', faAnyFile, sr) = 0 then
  begin
    repeat
      sFile := Trim(sr.Name);
      if sFile = '.' then Continue;
      if sFile = '..' then Continue;
      if SameText(sFile, 'LoginDLL.dll') then Continue;
      sFile := sPath + sr.Name;
      if (sr.Attr and faDirectory) <> 0 then
        DeleteDir(sFile, True)
      else if (sr.Attr and faAnyFile) = sr.Attr then begin
        SysUtils.DeleteFile(sFile); //删除文件
      end;
    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;
end;

procedure ReStartFile();
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  {.$I '..\Common\Macros\VMPB.inc'}
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  CreateProcess(nil,
    PChar(Application.ExeName), { pointer to command line string }
    nil, { pointer to process security attributes }
    nil, { pointer to thread security attributes }
    False, { handle inheritance flag }
    NORMAL_PRIORITY_CLASS,
    nil, { pointer to new environment block }
    nil, { pointer to current directory name, PChar}
    StartupInfo, { pointer to STARTUPINFO }
    ProcessInfo); { pointer to PROCESS_INF }
  {.$I '..\Common\Macros\VMPE.inc'}
end;

procedure TFrmMain.TimerTimer(Sender: TObject);
var
  s: string;
  ProcessInfo: TProcessInformation;
  StartupInfo: TStartupInfo;
begin
  if g_UpgradeStep <> uDownLoadUpgrade then begin
    s := GetStatusText;
    if s <> '' then RzLabelStatus.Caption := s;
  end;
  case g_UpgradeStep of
    uDownLoadUpgrade: begin
        RzLabelStatus.Caption := Format('%s %dK/%dK', [sRealDownLoadFile, nWorkCountCur div 1024, nWorkCountMax div 1024]);
        ProgressBarCurDownload.Percent := nWorkCountCur * 100 div _MAX(1, nWorkCountMax);
        ProgressBarAll.Percent := (nDownFileIdx + 1) * 100 div _MAX(1, DownList.Count);
      end;
    uNoNewSoft: begin
        Timer.Enabled := False;
        g_UpgradeStep := uOver;
        FrmMessageBox.Open(GetStatusText);
      end;
    uOver: begin
        Timer.Enabled := False;
        ProgressBarCurDownload.Percent := 100;
        ProgressBarAll.Percent := 100;
        if WaitForSingleObject(StartThread.Handle, 1000) = WAIT_FAILED then
          StartThread.Suspend;
        RzLabelStatus.Caption := GetStatusText;
        //FrmMessageBox.Open(GetStatusText);
        if g_boRestart and (g_UpgradeStep = uOver) then begin
          ReStartFile();
          ExitProcess(0);
          //Close();
          //Sleep(1000);
          //WinExec(PChar(g_sLoginTool), SW_SHOW);
        end;
      end;
  end;
end;

procedure TFrmMain.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
     // 发送连接数据
  SendTestConnnect();

end;

procedure TFrmMain.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);

var
  n: Integer;
  data, data2: string;
begin
  data := Socket.ReceiveText;
  if data = '' then Exit;
  n := Pos('*', data);
  if n > 0 then begin
    data2 := Copy(data, 1, n - 1);
    data := data2 + Copy(data, n + 1, Length(data));
    ClientSocket.Socket.SendText('*');
  end;
  testSocStr := testSocStr + data;
  Timer3.Enabled := True;
end;

procedure TFrmMain.ClientSocket2Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFrmMain.ClientSocket2Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if UserSocket <> nil then
    UserSocket.SendText(Socket.ReceiveText);
end;

procedure TFrmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  UserSocket := Socket;
  if g_SelGameZone <> nil then begin
    ClientSocket2.Address := g_SelGameZone.sGameIPaddr;
    ClientSocket2.Port := g_SelGameZone.nGameIPPort;
    ClientSocket2.Active := True;
  end;
end;

procedure TFrmMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  UserSocket := nil;
  ClientSocket2.Active := False;
  ClientSocket2.Close;
end;

procedure TFrmMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFrmMain.ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i: Integer;
  sReviceMsg: string;
begin
  sReviceMsg := Socket.ReceiveText;

  i := 0;
  while not ClientSocket2.Socket.Connected do begin
    Inc(i);
    Application.ProcessMessages;
    if Application.Terminated then Break;
    Sleep(1);
    if i > 1200 then
      Break;
  end;

  if ClientSocket2.Socket.Connected then begin
    ClientSocket2.Socket.SendText(sReviceMsg);
  end;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  ExitProcess(0);
end;

procedure TFrmMain.Timer3Timer(Sender: TObject);
var
  str, data: string;
  Len, i, n: Integer;
begin
  testBufferStr := testBufferStr + testSocStr;
  testSocStr := '';
  if testBufferStr <> '' then begin
    while Length(testBufferStr) >= 2 do begin
      if Pos('!', testBufferStr) <= 0 then Break;
      testBufferStr := ArrestStringEx(testBufferStr, '#', '!', data);
      if data <> '' then
        DecodeMessagePacketTest(data)
      else if Pos('!', testBufferStr) = 0 then
        Break;
    end;
  end;
  if testBufferStr = '' then
    Timer3.Enabled := False;

end;

procedure TFrmMain.TimerFindDirTimer(Sender: TObject);
begin
  ProgressBarCurDownload.Percent := ProgressBarCurDownload.Percent + 1;
  if ProgressBarCurDownload.Percent >= 100 then
    ProgressBarCurDownload.Percent := 0;
  if g_boSecCheck and not g_boSecFinded then begin
    TimerFindDir.Enabled := False;
    MessageBox(Handle, PChar('传奇目录未找到！'), '警告', MB_ICONWARNING + MB_OK);
    Close;
  end;
end;

procedure TFrmMain.WebBrowserDownloadComplete(Sender: TObject);
begin
  g_boWebBrowserShow := True;
  g_dwWebBrowserShow := GetTickCount;
end;

procedure TFrmMain.VCLUnZipPromptForOverwrite(Sender: TObject;
  var OverWriteIt: Boolean; FileIndex: Integer; var FName: string);
begin
  OverWriteIt := True;
end;

procedure TFrmMain.VCLUnZipUnZipComplete(Sender: TObject; FileCount: Integer);
begin
  SetStatusText('解包完成 ……');
end;

procedure TFrmMain.TimerPacketTimer(Sender: TObject);
var
  str, data: string;
  Len, i, n: Integer;
begin
  BufferStr := BufferStr + SocStr;
  SocStr := '';
  if BufferStr <> '' then begin
    while Length(BufferStr) >= 2 do begin
      if Pos('!', BufferStr) <= 0 then Break;
      BufferStr := ArrestStringEx(BufferStr, '#', '!', data);
      if data <> '' then
        DecodeMessagePacket(data)
      else if Pos('!', BufferStr) = 0 then
        Break;
    end;
  end;
end;

{ TDwonNetThread }

{procedure TFrmMain.WebBrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  WebDoc                    : HTMLDocument;
  WebBody                   : HTMLBody;
begin
  WebDoc := WebBrowser.Document as HTMLDocument;
  WebBody := WebDoc.body as HTMLBody;
  //WebBody.insertAdjacentHTML('BeforeEnd', '<span style="border:1px solid #000000; position:absolute; overflow:hidden;" > ');

  WebBody.insertAdjacentHTML('BeforeEnd', '<span style="border:1px solid #000000; position:absolute; overflow:hidden;" >');
  WebBody.insertAdjacentHTML('BeforeEnd', '</span>');
  //WebBody.insertAdjacentHTML('BeforeEnd', '<span style="color:red; font-bold:bold"><b>英雄、英雄合击使用教程</b></span>');
  if Assigned(WebBrowser.Document) then begin
    WebBrowser.OleObject.Document.body.Scroll := 'no';
  end;
end;}

{ TMyThread }

{ TMyThread }

procedure TMyThread.Execute;
var IdHTTPGetUpgInfo: TIdHTTP;
  content: string;
  year, month, day: Integer;
  npos: Integer;
  tmpstr: string;
  time1: int64;
  time2: tdatetime;
begin
  inherited;
  IdHTTPGetUpgInfo := TIdHTTP.Create(nil);
  IdHTTPGetUpgInfo.ReadTimeout := 15 * 1000;
  try
    try
      content := IdHTTPGetUpgInfo.Get(VMProtectDecryptStringA('http://open.baidu.com/special/time/'));
      npos := Pos(('baidu_time('), content);

      if npos > 0 then
      begin
        tmpstr := MidStr(content, npos + 11, 20);
        tmpstr := LeftStr(tmpstr, Pos(')', tmpstr) - 1);
        time1 := StrToInt64(tmpstr);
        time1 := (time1 div 1000) + 60 * 60 * 8;
        time2 := UnixToDateTime(time1);
        year := YearOf(time2);
        month := MonthOf(time2);
        day := DayOf(time2);
        FrmMain.enddate := year * 10000 + month * 100 + day;
      end;
    except
    end;
  finally
    IdHTTPGetUpgInfo.Free;
  end;

end;

{ TTongJiThread }

procedure TTongJiThread.Execute;
begin
  inherited;
  try
    try
   //  OutputDebugStringA('4444');
    //  FrmMain.WebBrowser3.Navigate(VMProtectDecryptStringA('http://tj.ay57.com'));
     // OutputDebugStringA('123');
    except
    end;
  finally
  end;

end;

end.

