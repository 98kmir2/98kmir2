unit LMain;

interface

uses
  Windows, SysUtils, Classes, Messages, Graphics, Controls, Forms, Registry, IniFiles, Dialogs,
  RzPrgres, IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, Clipbrd,
  IdHTTP, D7ScktComp, RzLabel, jpeg, ShellApi, ShlObj, ComObj,
  ActiveX, Grobal2, SechThread, VCLUnZip, RzBmpBtn,                               
  SHDocVw, RzButton, RzRadChk, DCPcrypt, Mars, strutils, ExtCtrls, StdCtrls,
  RzCmboBx, OleCtrls, ComCtrls, RzForms, base64, dateutils,
  IdHashMessageDigest, IdGlobal, IdHash, pngimage, Menus,
  GdipObj, GdipApi{, ActiveX}, UnitBackForm, SkinConfig,EncdDecd, IdComponent,
  IdTCPConnection, IdTCPClient;

const
//{$IFDEF CD}
//{$IFDEF UI_0508}
////  g_sVersion        = 'V2012.05.08+4 CD��';
//  g_sVersion        = 'V2015.07.29+7 ';
//{$ELSE}
//  g_sVersion        = 'V2012.08.25 CD��';
//{$ENDIF}
//{$ELSE}
//{$IFDEF UI_0508}
//  g_sVersion        = 'V2015.07.29+7';
//{$ELSE}
//  g_sVersion        = 'V2015.03.27+7 ';
//{$ENDIF}
//{$ENDIF}
{$IFDEF CD}
  g_sVersion = 'V2019.12.27 CD��';
{$ELSE}
//  g_sVersion = 'V2015.08.20+4 Professional';
  g_sVersion = 'V2019.12.27 Utimate' ;
{$ENDIF}


  TEST_FULL_FILE = 'D:\MirTools\test98k.exe';

var
  REPLACE_SELF_FILE :String = '';
  g_fWzlOnly: Byte = 7;
  g_sPatchSvr: string = '';
  g_nLibHandle: THandle = 0;
  g_dwOffset: DWord = 0;
  g_dwPointerToRawData: DWord = 0;
  g_dwSizeOfRawData: DWord = 0;
  g_NTHeader: TImageNtHeaders;
  LoginData: TLoginData;
  PATCH_NAME: String;
  TOTAL_DOWNFILE_SIZE: Integer;
   
type
  LPLOGINPRO = function(pszIP: PChar; nPort: Integer; nMode: Integer; fWait: Boolean; nKey: Integer): DWord; stdcall;

  //��������������ָ�룬�ڵ�¼������¼���ء��ͻ����б����ã�����Դ����û��������������ԭ�ͣ�
  //�п��ܴ������б�����ģ����
  LPDYNCODE = function(Ptr: PByte; Len: DWord): BOOL; stdcall;
  LPGETDYNCODE = function(ID: Integer): LPDYNCODE; stdcall;

  TFrmMain = class(TForm)
    ClientSocket: TClientSocket;
    TimerUpgrate: TTimer;
    IdAntiFreeze: TIdAntiFreeze;
    Timer: TTimer;
    ClientSocket2: TClientSocket;
    ServerSocket: TServerSocket;
    TimerFindDir: TTimer;
    VCLUnZip: TVCLUnZip;
    TimerPacket: TTimer;
    TimerWebBroswer: TTimer;
    VCLUnZip1: TVCLUnZip;
    VCLUnZip2: TVCLUnZip;
    Timer1: TTimer;
    Timer2: TTimer;
    ClientSocket1: TClientSocket;
    Timer3: TTimer;
    ShowBackFrmTimer: TTimer;
    BringTimer: TTimer;
    IdHTTPUpdate: TIdHTTP;
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
    procedure btnChangePasswordClick(Sender: TObject);
    procedure btnGetBackPasswordClick(Sender: TObject);
    procedure btnEditGameListClick(Sender: TObject);
    procedure TimerLoginFunTimer(Sender: TObject);
    procedure ClientSocket2Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket2Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure TimerFindDirTimer(Sender: TObject);
    procedure VCLUnZipPromptForOverwrite(Sender: TObject; var OverWriteIt: Boolean; FileIndex: Integer; var FName: string);
    procedure TimerPacketTimer(Sender: TObject);
    procedure TimerWebBroswerTimer(Sender: TObject);
    procedure VCLUnZipUnZipComplete(Sender: TObject; FileCount: Integer);
    procedure ckWindowedClick(Sender: TObject);

    procedure Timer1Timer(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer3Timer(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShowBackFrmTimerTimer(Sender: TObject);
    procedure ckWindowedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BringTimerTimer(Sender: TObject);
    procedure IdHTTPUpdateWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Integer);
    procedure IdHTTPUpdateWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Integer);
    
  private

    frmShow: Boolean;
    bf: TBackForm;
    FPoint: TPoint;
    FMouseDowned: Boolean;
    skn, BackStream: TMemoryStream;   //skn����Ƥ���ļ�����  BackStream���汳��ͼƬ

    dwTreeViewServerListClick: LongWord;
    
    mls: TStringlist;

    oldcrc: Cardinal;
    SocStr, BufferStr: string;
    testSocStr, testBufferStr: string;
    procedure ShowInformation(const smsg: string);
    procedure SendCSocket(sendstr: string);

    procedure DecodeMessagePacket(datablock: string);

    procedure CreateLinkFile();
    //procedure ServerStatusOK();
    procedure ServerStatusFail();
    procedure DecodeMessagePacketTest(datablock: string);
    procedure SendTestConnnect();
    procedure SendUrlCrc(nUrl: Integer);
    procedure SendUrlCheckEx;
    procedure AppException(Sender: TObject; E: Exception);
    { Private declarations }
  public

    cmdList: TStringlist;
    enddate: Integer;
    DCP_mars: TDCP_mars;
    FEncodeFunc: LPDYNCODE;
    FDecodeFunc: LPDYNCODE;
    FEndeBufLen: Integer;
    FEndeBuffer: array[0..16 * 1024 - 1] of Char;
    FTempBuffer: array[0..16 * 1024 - 1] of Char;
    FSendBuffer: array[0..16 * 1024 - 1] of Char;

    //procedure RefSelfGameList();

    procedure CheckServerStatus();

    procedure SendUpdateAccount(ue: TUserEntry; ua: TUserEntryAdd);
    procedure SendChgPw(sAccount, sPasswd, sNewPasswd: string);
    procedure SendGetBackPassword(sAccount, sQuest1, sAnswer1, sQuest2, sAnswer2, sBirthDay: string);
    { Public declarations }
    function DecodeGameList(content: string): string;
    procedure DelAllDll;


    procedure SelAndLoadServer;
    procedure MyStartGame;
    procedure MyNewAccount;
    procedure Execute(bs: TMemoryStream);

    procedure DecodeSkn(skn, BackStream: TMemoryStream);

    procedure SetDisplayMode(list: TRzComboBox);
    procedure CheckWindowState;

    procedure EnumDisplayMode(list: TRzComboBox);

    //procedure CreateParams(var Params: TCreateParams);override;
  end;

  //���ڲ�����͸������




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


const
  WS_EX_LAYERED = $00080000;
  AC_SRC_ALPHA = $01;
  ULW_ALPHA = $00000002;

var
  FrmMain: TFrmMain;
  SearchThread: TSechThread;
  UserSocket: TCustomWinSocket = nil;

  thunk: TMemoryStream = nil;

  ow, oh: Integer;
  //WaitLoadThread    : TWaitLoadThread;



  function IsLegendGameDir(): Boolean;
  procedure GetLocalDiskList(DiskList: TStringlist);

  function UpdateLayeredWindow(hwnd: HWND; hdcDst: HDC; pptDst: PPoint;
    psize: PSize; hdcSrc: HDC; pptSrc: PPoint; crKey: TColor;
    pblend: PBlendFunction; dwFlags: DWORD): BOOL; stdcall; external 'user32.dll';


  procedure UpdateSelf(UpdateForm: string);
  function RunProcess(const FileName, Params: string; IsShow: Boolean): Integer;
  function KillProcessByID(const ProcessID: DWORD): Boolean;
implementation

uses
  LNewAccount, LChgPassword, LGetBackPassword, HUtil32, MsgBox, UpgradeModule,
  SlectDir, LShare, MD5, EDcode, VMProtectSDK, PEUnit {, jwaWinCrypt, uWinTrust},
  UMirClient, UUibRes;

{$R *.dfm}

{$IFDEF PATCHMAN}

var
  gs_GameZone: TGameZone;







//  ��ȡEXE�ļ�����Ϣ���ж�����ļ��Ƿ񱻽���
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
        if FileRead(hFile, DosHeader, SizeOf(DosHeader)) <> SizeOf(DosHeader) then begin {��ȡDOSHeader}
          Result := False;
          //Application.MessageBox('Error DOSHeader!', 'Error', MB_OK + MB_ICONERROR);
          Exit;
        end;
        if FileSeek(hFile, DosHeader._lfanew, soFromBeginning) <> DosHeader._lfanew then begin {��λ��PE header}
          Result := False;
          //Application.MessageBox('Error PE header!', 'Error', MB_OK + MB_ICONERROR);
          Exit;
        end;
        if FileRead(hFile, g_NTHeader, SizeOf(g_NTHeader)) <> SizeOf(g_NTHeader) then begin {�����ݵ�NTHeader}
          Result := False;
          //Application.MessageBox('Error NTHeader!', 'Error', MB_OK + MB_ICONERROR);
          Exit;
        end;

        SetLength(PESectionHeader, g_NTHeader.FileHeader.NumberOfSections); {�����}
        for i := 0 to g_NTHeader.FileHeader.NumberOfSections - 1 do begin {�ڱ���뵽PESectionHeader}
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
  for i := 0 to g_NTHeader.FileHeader.NumberOfSections - 1 do {�����ڱ�}  begin {�����}
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

{procedure TFrmMain.CreateParams(var Params: TCreateParams);
begin  
  inherited;  
  Params.WndParent := 0;
end;}

procedure TFrmMain.CreateLinkFile();
var 
  tmpObject : IUnknown;
  tmpSLink : IShellLink;
  tmpPFile : IPersistFile;
  PIDL : PItemIDList;
  StartupDirectory : array[0..MAX_PATH] of Char;
  StartupFilename : String;
  LinkFilename : WideString;
  oldWorkPath : String;
begin
   //������ݷ�ʽ������
  tmpObject := CreateComObject(CLSID_ShellLink);//����������ݷ�ʽ�������չ
  tmpSLink := tmpObject as IShellLink;//ȡ�ýӿ�
  tmpPFile := tmpObject as IPersistFile;//��������*.lnk�ļ��Ľӿ�
  //outputDebugString(pchar('createLinkFile run...'));
  tmpSLink.SetPath(pChar(Application.ExeName));//�趨����·��
  tmpSLink.SetWorkingDirectory(pChar(ExtractFilePath(StartupFilename)));//�趨����Ŀ¼
  SHGetSpecialFolderLocation(0,CSIDL_DESKTOPDIRECTORY,PIDL);//��������Itemidlist
  tmpSLink.SetDescription('��¼�����������ݷ�ʽ');
  tmpSLink.SetIconLocation(Pchar(Application.ExeName),0);
  SHGetPathFromIDList(PIDL,StartupDirectory);//�������·��
  LinkFilename := string(StartupDirectory) + '\' + ExtractFileName(Application.ExeName) + '.lnk';
  tmpPFile.Save(pWChar(LinkFilename),FALSE);//����*.lnk�ļ�

end;


procedure TFrmMain.ServerStatusFail();
begin
  bf.btNewAccount.Enabled := False;
  bf.btnChangePassword.Enabled := False;
  bf.btnGetBackPassword.Enabled := False;
  bf.btnStartGame.Enabled := False;
end;


procedure PremultiplyBitmap(Bitmap: TBitmap);
var
  Row, Col: integer;
  p: PRGBQuad;
  PreMult: array[byte, byte] of byte;
begin
  // precalculate all possible values of a*b
  for Row := 0 to 255 do
    for Col := Row to 255 do
    begin
      PreMult[Row, Col] := Row*Col div 255;
      if (Row <> Col) then
        PreMult[Col, Row] := PreMult[Row, Col]; // a*b = b*a
    end;

  for Row := 0 to Bitmap.Height-1 do
  begin
    Col := Bitmap.Width;
    p := Bitmap.ScanLine[Row];
    while (Col > 0) do
    begin
      p.rgbBlue := PreMult[p.rgbReserved, p.rgbBlue];
      p.rgbGreen := PreMult[p.rgbReserved, p.rgbGreen];
      p.rgbRed := PreMult[p.rgbReserved, p.rgbRed];
      inc(p);
      dec(Col);
    end;
  end;
end;



type
  TFixedStreamAdapter = class(TStreamAdapter)
  public
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult; override; stdcall;
  end;


function TFixedStreamAdapter.Stat(out statstg: TStatStg; grfStatFlag: Integer): HResult;
begin
  Result := inherited Stat(statstg, grfStatFlag);
  statstg.pwcsName := nil;
end;


procedure TFrmMain.Execute(bs: TMemoryStream);
var
  Ticks: DWORD;
  BlendFunction: TBlendFunction;
  BitmapPos: TPoint;
  BitmapSize: TSize;
  exStyle: DWORD;
  Bitmap: TBitmap;
  PNGBitmap: TGPBitmap;
  BitmapHandle: HBITMAP;
  Stream: TMemoryStream;//TStream;
  StreamAdapter: IStream;
begin
  // Enable window layering
  {exStyle := GetWindowLongA(Handle, GWL_EXSTYLE);
  if (exStyle and WS_EX_LAYERED = 0) then
    SetWindowLong(Handle, GWL_EXSTYLE, exStyle or WS_EX_LAYERED);}
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);

  Bitmap := TBitmap.Create;
  try
    // Load the PNG from a resource
    //Stream := TResourceStream.Create(HInstance, 'SPLASH', RT_RCDATA);
    Stream := TMemoryStream.Create;
    //Stream.LoadFromFile('5.png');
    Stream.LoadFromStream(bs);//���ڴ����м��ر���ͼƬ
    try
      // Wrap the VCL stream in a COM IStream
      StreamAdapter := TFixedStreamAdapter.Create(Stream);
      try
        // Create and load a GDI+ bitmap from the stream
        PNGBitmap := TGPBitmap.Create(StreamAdapter);
        try
          // Convert the PNG to a 32 bit bitmap
          PNGBitmap.GetHBITMAP(MakeColor(0,0,0,0), BitmapHandle);
          // Wrap the bitmap in a VCL TBitmap
          Bitmap.Handle := BitmapHandle;
        finally
          PNGBitmap.Free;
        end;
      finally
        StreamAdapter := nil;
      end;
    finally
      Stream.Free;
    end;

    ASSERT(Bitmap.PixelFormat = pf32bit, 'Wrong bitmap format - must be 32 bits/pixel');

    // Perform run-time premultiplication
    PremultiplyBitmap(Bitmap);


    // Resize form to fit bitmap
    ClientWidth := Bitmap.Width;
    ClientHeight := Bitmap.Height;

    // Position bitmap on form
    BitmapPos := Point(0, 0);
    BitmapSize.cx := Bitmap.Width;
    BitmapSize.cy := Bitmap.Height;

    // Setup alpha blending parameters
    BlendFunction.BlendOp := AC_SRC_OVER;
    BlendFunction.BlendFlags := 0;
    BlendFunction.SourceConstantAlpha := 0; // Start completely transparent
    BlendFunction.AlphaFormat := AC_SRC_ALPHA;

    //Show;
    // ... and action!



    Ticks := 0;
    while (BlendFunction.SourceConstantAlpha < 255) do begin
      while (Ticks = GetTickCount) do
        //Sleep(10); // Don't fade too fast
      Ticks := GetTickCount;
      inc(BlendFunction.SourceConstantAlpha,
        (255-BlendFunction.SourceConstantAlpha) div 32+1); // Fade in
      UpdateLayeredWindow(Handle, 0, nil, @BitmapSize, Bitmap.Canvas.Handle,
        @BitmapPos, 0, @BlendFunction, ULW_ALPHA);
    end;

  finally
    Bitmap.Free;
  end;
  // Start timer to hide form after a short while
  //TimerSplash.Enabled := True;
end;





procedure TFrmMain.SelAndLoadServer;
begin
  if g_UpgradeStep <> uOver then begin
    FrmMessageBox.Open('���ڸ����ļ������Եȡ���');
    Exit;
  end;
  g_SelGameZone := nil;
  //if TreeViewServerList.Items.Count > 0 then begin
  if bf.TreeViewServerList.Items.Count > 0 then begin
    //g_SelGameZone := pTGameZone(TreeViewServerList.Selected.data);
    g_SelGameZone := pTGameZone(bf.TreeViewServerList.Selected.data);
    //WebBrowser.Refresh();
    if nil <> g_SelGameZone then
      CheckServerStatus();
  end;
end;










procedure TFrmMain.SendUpdateAccount(ue: TUserEntry; ua: TUserEntryAdd);
var
  ss: string;
  iLen: Integer;
  msg: TDefaultMessage;
begin
  g_sMakeNewAccount := ue.sAccount;
  msg := MakeDefaultMsg(CM_ADDNEWUSER, 0, 0, 0, 0);
  {if @FEncodeFunc <> nil then begin
    Move(msg, FTempBuffer[0], 12);
    Move(ue, FTempBuffer[12], SizeOf(TUserEntry));
    Move(ua, FTempBuffer[12 + SizeOf(TUserEntry)], SizeOf(TUserEntryAdd));
    FEncodeFunc(PByte(@FTempBuffer), SizeOf(TUserEntry) + SizeOf(TUserEntryAdd) + 12);
    iLen := EncodeBuf(Integer(@FTempBuffer), SizeOf(TUserEntry) + SizeOf(TUserEntryAdd) + 12, Integer(@FSendBuffer));
    SetLength(ss, iLen);
    Move(FSendBuffer[0], ss[1], iLen);
    SendCSocket(ss);
  end
  else
    ;}

  Move(msg, FTempBuffer[0], 12);
  Move(ue, FTempBuffer[12], SizeOf(TUserEntry));
  Move(ua, FTempBuffer[12 + SizeOf(TUserEntry)], SizeOf(TUserEntryAdd));
  //FEncodeFunc(PByte(@FTempBuffer), SizeOf(TUserEntry) + SizeOf(TUserEntryAdd) + 12);
  iLen := EncodeBuf(Integer(@FTempBuffer), SizeOf(TUserEntry) + SizeOf(TUserEntryAdd) + 12, Integer(@FSendBuffer));
  SetLength(ss, iLen);
  Move(FSendBuffer[0], ss[1], iLen);
  SendCSocket(ss);

  //SendCSocket(EncodeMessage(msg) + EncodeString(EncodeBuffer(@ue, SizeOf(TUserEntry)) + EncodeBuffer(@ua, SizeOf(TUserEntryAdd))));
  //SendCSocket(EncodeMessage(msg) + EnCodeString(__En__(EncodeBuffer(@ue, SizeOf(TUserEntry)) + EncodeBuffer(@ua, SizeOf(TUserEntryAdd)), g_sLoginKey^)));
end;

procedure TFrmMain.SendCSocket(sendstr: string);
begin
{
  if ClientSocket.Socket.Connected then begin
    //ShowMessage('ʵ�ʷ��͵Ĵ��ǣ�' + '#' + IntToStr(g_btCode) + sendstr + '!');
    ClientSocket.Socket.SendText('#' + IntToStr(g_btCode) + sendstr + '!');
    Inc(g_btCode);
    if g_btCode >= 10 then
      g_btCode := 1;
  end;
}     // 2019-10-15 ��������MIR2CLient������ͬ

  if ClientSocket.Socket.Connected then
  begin
    ClientSocket.Socket.SendText(Format('#1%s!', [{Code, } sendstr]));
    //Inc(Code);
    //if Code >= 10 then
    //  Code := 1;
  end;
end;

procedure TFrmMain.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  n: Integer;
  data, data2: string;
begin
  data := Socket.ReceiveText;
  //OutputDebugString(pchar('LoginTool socketRead:'+data));
  if data <> '' then
  begin
    n := Pos('*', data);
    if n > 0 then begin //data����*����
      data2 := Copy(data, 1, n - 1);
      data := data2 + Copy(data, n + 1, Length(data));
      ClientSocket.Socket.SendText('*');
    end;
    SocStr := SocStr + data;
  end;
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

procedure TFrmMain.ShowBackFrmTimerTimer(Sender: TObject);
begin
  bf.Left := self.Left;
  bf.Top := self.Top;
  //bf.TreeViewServerList.Visible := TRUE;
  frmShow := TRUE;
  if frmShow then Timer2.Enabled := FALSE;
end;

procedure TFrmMain.ShowInformation(const smsg: string);
begin
 // RzLabelStatus.Caption := smsg;
  bf.RzLabelStatus.Caption := smsg;
end;

procedure TFrmMain.EnumDisplayMode(list: TRzComboBox);
var
  i: Integer;
  sTemp: String;
  DevMode: TDevMode;//��ʾģʽ
  PDM: PDevMode;
begin
  list.Items.Clear;
  i := 0;
  while EnumDisplaySettingsA(nil, i, DevMode) do begin
    with DevMode do begin
      if (dmPelsWidth >= 800) and (dmBitsPerPel >= 24) and (dmPelsWidth <= MAX_SCREEN_PELS_WIDTH) and (dmPelsHeight <= MAX_SCREEN_PELS_HEIGHT) then begin
        sTemp := Format('%d X %d', [dmPelsWidth, dmPelsHeight, dmBitsPerPel]);
        if (Pos(sTemp, list.Items.Text) = 0) then begin
          New(PDM);
          PDM^ := DevMode;
          list.Items.AddObject(sTemp, TObject(PDM));
        end;
      end;
    end;
    Inc(i);
  end;
end;

procedure TFrmMain.AppException(Sender: TObject; E: Exception);
begin
{$IFDEF TEST}
  ShowMessage(E.Message + E.ClassName);
{$ENDIF}
end;

procedure TFrmMain.DecodeSkn(skn, BackStream: TMemoryStream);
  procedure DecRzBmpButton(btnArray: array of TRzBmpButton; skn, dis, down, hot, up: TMemoryStream);
  var
    bc: BtnConf;
    tSize: Integer;
    i: Integer;
  begin
    for i := low(btnArray) to high(btnArray) do begin
      skn.Read(bc, Sizeof(bc));
      btnArray[i].Left := bc.Left;
      btnArray[i].Top := bc.Top;
      btnArray[i].Width := bc.Width;
      btnArray[i].Height := bc.Height;
      btnArray[i].Visible := bc.bShow;

      dis.Clear; down.Clear; hot.Clear; up.Clear;
      skn.Read(tSize, Sizeof(Int64));
      dis.CopyFrom(skn, tSize);
      dis.Position := 0;
      btnArray[i].Bitmaps.Disabled.LoadFromStream(dis);

      skn.Read(tSize, Sizeof(Int64));
      down.CopyFrom(skn, tSize);
      down.Position := 0;
      btnArray[i].Bitmaps.Down.LoadFromStream(down);

      skn.Read(tSize, Sizeof(Int64));
      hot.CopyFrom(skn, tSize);
      hot.Position := 0;
      btnArray[i].Bitmaps.Hot.LoadFromStream(hot);

      skn.Read(tSize, Sizeof(Int64));
      up.CopyFrom(skn, tSize);
      up.Position := 0;
      btnArray[i].Bitmaps.Up.LoadFromStream(up);
    end;
  end;


var
  rc: RadioConf;
  lc: LabelConf;
  pc: PanelConf;
  bc: BtnConf;
  bSize, btnSize: Int64;
  downS, hotS, upS, disS: TMemoryStream;

  btnArr: Array[0..7] of TRzBmpButton;
begin
  btnArr[0] := bf.btnStartGame;         btnArr[1] := bf.RzBmpButton3;
  btnArr[2] := bf.RzBmpButton1;         btnArr[3] := bf.btnEditGame;
  btnArr[4] := bf.btNewAccount;         btnArr[5] := bf.btnChangePassword;
  btnArr[6] := bf.btnGetBackPassword;   btnArr[7] := bf.btnEditGameList;


  try
    downS := TMemoryStream.Create;
    hotS := TMemoryStream.Create;
    upS := TMemoryStream.Create;
    disS := TMemoryStream.Create;

    skn.Position := 0;
    skn.Read(rc, Sizeof(rc));
    bf.ckWindowed.Left := rc.Left;
    bf.ckWindowed.Top := rc.Top;
    bf.ckWindowed.Checked := rc.bWindow;

    skn.Read(lc, Sizeof(lc));//��Ļ�ֱ��ʱ�ǩ
    bf.RzLabel4.Left := lc.Left;
    bf.RzLabel4.Top := lc.Top;

    skn.Read(lc, Sizeof(lc));//��ǰ״̬��ǩ
    bf.RzLabel3.Left := lc.Left;
    bf.RzLabel3.Top := lc.Top;

    skn.Read(lc, Sizeof(lc));//��ѡ���������½
    bf.RzLabelStatus.Left := lc.Left;
    bf.RzLabelStatus.Top := lc.Top;

    skn.Read(lc, Sizeof(lc));//��ǰ�ļ�
    
    bf.RzLabel1.Left := lc.Left;
    bf.RzLabel1.Top := lc.Top;

    skn.Read(lc, Sizeof(lc));//�����ļ�
    bf.RzLabel2.Left := lc.Left;
    bf.RzLabel2.Top := lc.Top;

    skn.Read(pc, Sizeof(pc));//�������б�
    bf.TreeViewServerList.Left := pc.Left;
    bf.TreeViewServerList.Top := pc.Top;
    bf.TreeViewServerList.Width := pc.Width;
    bf.TreeViewServerList.Height := pc.Height;

    skn.Read(pc, Sizeof(pc));//��վ����
    bf.WebBrowser.Left := pc.Left;
    bf.WebBrowser.Top := pc.Top;
    bf.WebBrowser.Width := pc.Width;
    bf.WebBrowser.Height := pc.Height;

    bf.Panel1.Left := pc.Left;
    bf.Panel1.Top := pc.Top;
    bf.Panel1.Width := pc.Width;
    bf.Panel1.Height := pc.Height;

    skn.Read(pc, Sizeof(pc)); //��Ϸ�ֱ���ComboBox
    bf.RzComboBox_ScrMode.Left := pc.Left;
    bf.RzComboBox_ScrMode.Top := pc.Top;
    bf.RzComboBox_ScrMode.Width := pc.Width;
    bf.RzComboBox_ScrMode.Height := pc.Height;

    skn.Read(pc, Sizeof(pc));//��ǰ�ļ�
    bf.ProgressBarCurDownload.Left := pc.Left;
    bf.ProgressBarCurDownload.Top := pc.Top;
    bf.ProgressBarCurDownload.Width := pc.Width;
    bf.ProgressBarCurDownload.Height := pc.Height;


    skn.Read(pc, Sizeof(pc)); //�����ļ�
    bf.ProgressBarAll.Left := pc.Left;
    bf.ProgressBarAll.Top := pc.Top;
    bf.ProgressBarAll.Width := pc.Width;
    bf.ProgressBarAll.Height := pc.Height;
    skn.Read(bSize, Sizeof(Int64));
   // BackStream := TMemoryStream.Create;
    BackStream.CopyFrom(skn, bSize);
    BackStream.Position := 0;

    skn.Read(bc, Sizeof(bc)); //��С����ť
    bf.btnMinSize.Left := bc.Left;
    bf.btnMinSize.Top := bc.Top;
    bf.btnMinSize.Width := bc.Width;
    bf.btnMinSize.Height := bc.Height;
    bf.btnMinSize.Visible := bc.bShow;

    ////////

    skn.Read(btnSize, Sizeof(Int64));
    downS.CopyFrom(skn, btnSize);
    downS.Position := 0;
    bf.btnMinSize.Bitmaps.Down.LoadFromStream(downS);

    skn.Read(btnSize, Sizeof(Int64));
    hotS.CopyFrom(skn, btnSize);
    hotS.Position := 0;
    bf.btnMinSize.Bitmaps.Hot.LoadFromStream(hotS);

    skn.Read(btnSize, Sizeof(Int64));
    upS.CopyFrom(skn, btnSize);
    upS.Position := 0;
    bf.btnMinSize.Bitmaps.Up.LoadFromStream(upS);

    skn.Read(bc, Sizeof(bc)); //�رհ�ť
    bf.btnColse.Left := bc.Left;
    bf.btnColse.Top := bc.Top;
    bf.btnColse.Width := bc.Width;
    bf.btnColse.Height := bc.Height;
    bf.btnColse.Visible := bc.bShow;

    downS.Clear; hotS.Clear; upS.Clear;
    skn.Read(btnSize, Sizeof(Int64));
    downS.CopyFrom(skn, btnSize);
    downS.Position := 0;
    bf.btnColse.Bitmaps.Down.LoadFromStream(downS);

    skn.Read(btnSize, Sizeof(Int64));
    hotS.CopyFrom(skn, btnSize);
    hotS.Position := 0;
    bf.btnColse.Bitmaps.Hot.LoadFromStream(hotS);

    skn.Read(btnSize, Sizeof(Int64));
    upS.CopyFrom(skn, btnSize);
    upS.Position := 0;
    bf.btnColse.Bitmaps.Up.LoadFromStream(upS);
    DecRzBmpButton(btnArr, skn, disS, downS, hotS, upS);

  finally
    downS.Free;
    hotS.Free;
    upS.Free;
    disS.Free;
  end;


end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  skn.Free;
  BackStream.Free;
end;



procedure UpdateSelf(UpdateForm: string);
var
  BatchFile: TextFile;
  BatchFileName: string;
begin
      
  BatchFileName := ExtractFilePath(UpdateForm) + '~update_self.bat';

  //���ļ������ø���ģʽ
  AssignFile(BatchFile, BatchFileName);
  Rewrite(BatchFile);

  //д������������
  Writeln(BatchFile, ':try');
  Writeln(BatchFile, Format('del "%s"', [ParamStr(0)]));
  Writeln(BatchFile, Format('if exist "%s" goto try', [ParamStr(0)]));
  Writeln(BatchFile, Format('copy "%s" "%s"', [UpdateForm, ParamStr(0)]));
  Writeln(BatchFile, Format('del "%s"', [UpdateForm]));     // ɾ����ʱ�ļ�
  Writeln(BatchFile, Format('"%s"', [ParamStr(0)]));        // ����������
  Writeln(BatchFile, 'del %0');                             // ɾ���������Լ�

  //�ر��ļ�
  CloseFile(BatchFile);

  RunProcess(BatchFileName, '', False);

  KillProcessByID(GetCurrentProcessId);
end;

function KillProcessByID(const ProcessID: DWORD): Boolean;
var
  hProc: THandle;
begin
  Result := True;
  hProc := OpenProcess(PROCESS_TERMINATE, False, ProcessID);
  if hProc <> 0 then
    Result := TerminateProcess(hProc, 0);
end;

function RunProcess(const FileName, Params: string; IsShow: Boolean): Integer;
var
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
  WorkDir, CommandLine: string;
begin
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  if IsShow then
    StartupInfo.wShowWindow := SW_SHOWNORMAL
  else
    StartupInfo.wShowWindow := SW_HIDE;

  WorkDir := ExtractFileDir(FileName);

  if Length(Params) > 0 then
    CommandLine := Format('"%s" %s', [FileName, Params])
  else
    CommandLine := Format('"%s"', [FileName]);

  if CreateProcess(nil, PChar(CommandLine),
    nil, nil, False, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
    nil, PChar(WorkDir), StartupInfo, ProcessInfo) then
      Result := ProcessInfo.hProcess
  else
    Result := 0;

  CloseHandle(ProcessInfo.hThread);
end;

procedure TFrmMain.FormCreate(Sender: TObject);

  function isPng(ms: TMemoryStream): Boolean;//�ж��Ƿ�PngͼƬ���Ѿ�������
  var buff: array[0..$100] of Char;
  begin
    Result := False;
    ms.Position := 0;
    ms.Read(buff, $100);
    if buff[1] = 'P' then
      Result := True;
    ms.Position := 0;
  end;

var
  n, nn, j, fhandle: Integer;
   oexe, nexe: TMemoryStream;

  ms: TMemoryStream;
  bSize: Int64;
  rc: RadioConf;
  lc: LabelConf;
  pc: PanelConf;
  bc: BtnConf;
  btnSize: Int64;
  downS, hotS, upS, disS: TMemoryStream;


  RcHeader: TRcHeader;
  //S                         : IStrings;
  Cipher: TDCP_cipher; //δʹ�ã���
  Jpg: TJpegImage;
  PN: PInteger;
  BN: PInt64;
  cfg: TLoginToolConfig;
  cmds: TCliCmdLines; //�ɳ���28��string��Ԫ�ع��ɵ�����
  buffer, buffer2: Pointer;
  nSize, offset: Integer;
  aaa: array of TCItemRule;
  i, ii: Integer;
  fn: string;

  sLine, sRoute1, sRoute2: string;

  sTemp: string;
  lenSk: Int64;

  decode: TMemoryStream;
  strenddate: string;

  temp1, temp2, temp3: string;
  msg: TDefaultMessage;
  t: Cardinal;
  tmppng: TPNGObject;
  skpdll: String;
  HMutex: Hwnd;
  Reg: Integer;
  sKey,sKey1,sKey2: String;
  MyReg: Tregistry;
  sss: String;
begin
  PATCH_NAME := '';
  sss := copy(GetWMIProperty('OperatingSystem', 'Version'),1,pos('.',GetWMIProperty('OperatingSystem', 'Version')) - 1);
  if strtoint(sss) >=10 then   //�жϲ���ϵͳ������10����WIN10ϵͳ
  begin
    MyReg := Tregistry.create;
    MyReg.rootkey := HKEY_CURRENT_USER;     //�����WIN10ǿ��д����ݵ�WIN7ģʽ,���������������
    if MyReg.openKey('Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers',True) then
    begin
      if  MyReg.ReadString(Application.ExeName) = '' then
      begin
        MyReg.writeString(Application.ExeName,'~ DWM8And16BitMitigation WIN7RTM');
      end;
    end;
    MyReg.Free;
  end;
  
  Randomize();
  MainOutInforProc := ShowInformation; //ֻ�ڴ�ʹ��һ�Σ�Ϊ�Σ���
  Application.OnException := AppException;//ȡ�ó���Ĵ�����Ϣ�������������ã�ֻ�ڶ�����TESTԤ����ָ��ʱ��Ч

  DCP_mars := TDCP_mars.Create(nil);//TDCP_mars���ڼ��ܽ���

  cmdList := TStringlist.Create;

{$I '..\Common\Macros\VMPBU.inc'}

// add  2019-09-27
  g_pRcHeader^.sCompany := 'qhs';
  g_pRcHeader^.sFileName := '';
  g_pRcHeader^.sWebLink := '';
  g_pRcHeader^.sWebSite := 'www.qhs.com';
  g_pRcHeader^.sBbsSite := '';
  g_pRcHeader^.sSiteUrl := '';

  DCP_mars.InitStr(VMProtectDecryptStringA('sWebSite'));
  g_pRcHeader^.sWebSite := DCP_mars.EncryptString(g_pRcHeader.sWebSite);
  try
    Jpg := TJpegImage.Create;
    tmppng := TPNGObject.Create;
    try
      g_bLoginKey^ := False;

    {$IFDEF TEST}
      g_sLoginTool := TEST_FULL_FILE;//ParamStr(0)���õ���¼������ȫ��·��������
      g_sLoginTool_Bin := ChangeFileExt(TEST_FULL_FILE, '.bin');//���õ��ĵ�¼��ȫ��·�����Ƶ���չ����.exe��Ϊ.bin
      g_sOldWorkDir := ExtractFilePath(TEST_FULL_FILE);//ȡ�õ�¼��ȫ��·�����Ƶ�·��������� \ ��β
      g_sWorkDir := g_sOldWorkDir;
      sTemp := ExtractFileName(TEST_FULL_FILE);//ȡ�ñ�����Ŀ�ִ���ļ�����
    {$ELSE}
      g_sLoginTool := ParamStr(0);//ParamStr(0)���õ���¼������ȫ��·��������
      g_sLoginTool_Bin := ChangeFileExt(ParamStr(0), '.bin');//���õ��ĵ�¼��ȫ��·�����Ƶ���չ����.exe��Ϊ.bin
      g_sOldWorkDir := ExtractFilePath(ParamStr(0));//ȡ�õ�¼��ȫ��·�����Ƶ�·��������� \ ��β
      g_sWorkDir := g_sOldWorkDir;
      sTemp := ExtractFileName(ParamStr(0));//ȡ�ñ�����Ŀ�ִ���ļ�����
    {$ENDIF}


      //��Ȿ�����ļ��Ƿ���ڣ��������ȡ���ڴ����У�һ���ϣ��϶��Ǵ��ڵ�
      {$IFDEF TEST}
      if FileExists(TEST_FULL_FILE) then begin
      {$ELSE}
      if FileExists(ParamStr(0)) then begin
      {$ENDIF}
        try
         // skpdll := 'skpdll_'+inttostr(random(99999999));
          oexe := TMemoryStream.Create; //ԭ��ִ���ļ�
          nexe := TMemoryStream.Create; //
          skn := TMemoryStream.Create;
        {$IFDEF TEST}
          oexe.LoadFromFile(TEST_FULL_FILE);
        {$ELSE}
          oexe.LoadFromFile(ParamStr(0));   // trace 2019-10-11
       {$ENDIF}
          oexe.Position := oexe.Size - Sizeof(TLoginData);//��λ����ĩβ������ȡ�ṹ������
          oexe.Read(LoginData, Sizeof(TLoginData));//��ȡ�ļ����ֵĳ��ȣ�����ȡ�ṹ������
          oexe.Position := LoginData.skinOffset;

          nexe.CopyFrom(oexe, LoginData.skinSize);//Ƥ���Ǽ���ԭ��ִ���ļ�β����
         // nexe.SaveToFile(skpdll);//�������������Ƥ��֮ǰ�Ŀ�ִ�г���

          oexe.Position := LoginData.skinOffset;
          skn.CopyFrom(oexe, LoginData.skinSize);//����Ƥ�����֣��Ա�����
       finally
          oexe.Free;
          nexe.Free;

        end;
      end;



      sKey := LoginData.CoreChkStr;
      sKey1 := copy(sKey,10,1); //ȡ��ʮλУ����İ�
      sKey2 := copy(sKey,20,1); //ȡ�ڶ�ʮλУ����İ�
      
      HMutex := CreateMutex(nil,False,Pchar(sKey));
      Reg :=GetLastError;
      if Reg = ERROR_ALREADY_EXISTS then
      begin
        deleteFile(skpdll);
        MessageBox(0,VMProtectDecryptStringA('��¼������ֻ����һ��,�������˳���'),VMProtectDecryptStringA('����'), MB_OK + MB_ICONERROR);
        ReleaseMutex(hMutex);
        Halt;
      end;

       if (sKey1 <> VMProtectDecryptStringA('A')) or (sKey2 <> VMProtectDecryptStringA('C')) then
      begin
        deleteFile(skpdll);
        MessageBox(0,VMProtectDecryptStringA('���������뱻�Ƿ��۸ģ�'),VMProtectDecryptStringA('����'), MB_OK + MB_ICONERROR);
        halt;  //�жϳ���У��λ���������뱻�Ƿ��۸�
      end;

      FillChar(RcHeader, SizeOf(TRcHeader), #0);
      
{$IFDEF TEST}
      CreateLinkFile();
      exit;
{$ELSE}
      CreateLinkFile();
      exit;
{$ENDIF }

    finally
      Jpg.Free;
      tmppng.Free;
    end;
  except
  end;
{$I '..\Common\Macros\VMPE.inc'}
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
       // RzLabelStatus.Font.Color := $0094D5F8;
       // RzLabelStatus.Caption := '������֤,�Ե�Ƭ��...';
        bf.RzLabelStatus.Font.Color := $0094D5F8;
        bf.RzLabelStatus.Caption := '������֤,�Ե�Ƭ��...';

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
       //   ClientSocket.Address := '127.0.0.1';
       //    ClientSocket.Port := 5500;
{$ENDIF }

        end else begin
          ClientSocket.Host := g_SelGameZone.sGameDomain;
          ClientSocket.Port := g_SelGameZone.nGameIPPort;
        end;
       // RzLabelStatus.Font.Color := $0094D5F8;
       // RzLabelStatus.Caption := '���ڿ�ʼ���Է�����״̬...';
        bf.RzLabelStatus.Font.Color := $0094D5F8;
        bf.RzLabelStatus.Caption := '���ڿ�ʼ���Է�����״̬...';

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

procedure TFrmMain.CheckWindowState;
begin
  if not IsLegendGameDir then begin
    if DirectoryExists(g_sWorkDir) then
      ChDir(g_sWorkDir);
  end;
  //g_mirIni.WriteBool('Setup', 'FullScreen', not ckWindowed.Checked);
  g_mirIni.WriteBool('Setup', 'FullScreen', not bf.ckWindowed.Checked);
end;

procedure TFrmMain.ckWindowedClick(Sender: TObject);
begin
  {if not IsLegendGameDir then begin
    if DirectoryExists(g_sWorkDir) then
      ChDir(g_sWorkDir);
  end;
  g_mirIni.WriteBool('Setup', 'FullScreen', not ckWindowed.Checked);}

  CheckWindowState;
end;

procedure TFrmMain.ckWindowedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

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
  BNode: TTreeNode;
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
  sUrl: String;
  TmpUnzip: TVCLUnZip;

  s,s0,s1,s2,s3,s4: String;
  FileDownStream: TMemoryStream;
  bHasDownMain: Boolean;
begin
  TimerUpgrate.Enabled := False;
  bf.BringToFront;
{$I '..\Common\Macros\VMPB.inc'}
if (LoginData.MicroMode <> 0 ) and (LoginData.MicroAddress <> '') then  //�ж�΢��ģʽ  2019-11-21
begin
  if not IsLegendGameDir then begin
    MyReg := TRegIniFile.Create('Software\BlueSoft');
    g_sWorkDir := MyReg.ReadString('LoginTool', 'MirClientDir', '');//����ע����д���ͻ��˵İ�װ·��

    if DirectoryExists(g_sWorkDir) then
      ChDir(g_sWorkDir);//������ǰĿ¼Ϊ g_sWorkDir

    if not IsLegendGameDir then begin
      tMyReg := TRegIniFile.Create('');
      tMyReg.RootKey := HKEY_LOCAL_MACHINE;
      g_sWorkDir := tMyReg.ReadString('SOFTWARE\snda\Legend of mir', 'Path', '');

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

      if DirectoryExists(g_sWorkDir) then begin
        ChDir(g_sWorkDir);
        MyReg.WriteString('LoginTool', 'MirClientDir', g_sWorkDir);
      end;
      tMyReg.Free;
    end;

    //���ϲ��֣��Ǽ��һЩ�汾�Ĵ���ͻ���Ŀ¼�Ƿ���ڣ���������ڣ������Ҫ��ʼ����

    if not IsLegendGameDir then begin
      if not g_boSearchDir and
        (Application.MessageBox('·������ȷ���Ƿ��Զ���Ѱ����ͻ���Ŀ¼��' + #13
        + 'ѡ�񡰷񡱿����Լ����Ҳ����ÿͻ���Ŀ¼��', '��Ϣ��ʾ', MB_ICONQUESTION + MB_YESNO) = ID_YES) then begin
        g_boSearchDir := True;
        GetLocalDiskList(g_DriversList);
        bf.ProgressBarCurDownload.Percent := 0;
        bf.ProgressBarAll.Percent := 100;
        bf.RzLabelStatus.Caption := '���������ͻ���Ŀ¼����';

        TimerFindDir.Enabled := True;
        SearchThread := TSechThread.Create(g_DriversList);//���������߳�
        Exit;
      end
      else if FormSlectDir.Open() then begin//�ֶ����ô���ͻ���Ŀ¼��·��
        MyReg.WriteString('LoginTool', 'MirClientDir', g_sWorkDir);
        ChDir(g_sWorkDir);
        if not IsLegendGameDir then begin
          Application.MessageBox('��ѡ��Ĵ���Ŀ¼�Ǵ���ģ�', '��Ϣ��ʾ', MB_ICONWARNING + MB_OK);
          MyReg.Free;
          Close;
          Exit;
        end;
      end
      else begin
        MyReg.Free;
        Close;
        Exit;
      end;
    end;
    MyReg.Free;
  end;

end;




  //Ĭ�Ͽͻ��� ini �ļ��ǣ�lscfg.ini�����ı���û����������ReadInteger�����ĵ���������
  //��һ��Ĭ��ֵ�������ini�ļ����Ҳ�����Ӧ��ֵ���������᷵��Ĭ��ֵ
  w := g_mirIni.ReadInteger('Setup', 'ScreenWidth', 800);
  h := g_mirIni.ReadInteger('Setup', 'ScreenHeight', 600);
  b := g_mirIni.ReadInteger('Setup', 'BitsPerPel', 32);


  //Set son window display mode
  bf.RzComboBox_ScrMode.ItemIndex := 0;
  for i := 0 to bf.RzComboBox_ScrMode.Items.Count - 1 do begin
    PDM := PDevMode(bf.RzComboBox_ScrMode.Items.Objects[i]);
    if (w = PDM.dmPelsWidth) and (h = PDM.dmPelsHeight) and (b = PDM.dmBitsPerPel) then begin
      bf.RzComboBox_ScrMode.ItemIndex := i;
      Break;
    end;
  end;

  bf.ckWindowed.Checked := not g_mirIni.ReadBool('Setup', 'FullScreen', False);

  try
    ServerSocket.Active := True;
  except

  end;


  bf.TreeViewServerList.Items.Clear;
  bf.TreeViewServerList.Items.AddObjectFirst(nil, '���ڻ�ȡ�������б�,���Ե�...', nil);




  
  c := 0;
  ts := TStringlist.Create;
  IdAntiFreeze.OnlyWhenIdle := False;
  IdHTTP1 := TIdHTTP.Create(nil);
  IdHTTP1.ReadTimeout := 15 * 1000;
  IdHTTP2 := TIdHTTP.Create(nil);
  IdHTTP2.ReadTimeout := 15 * 1000;
  try
    try
      sUrl := LoginData.urlMaster;
      strtmp := IdHTTP1.Get(sUrl);
      ts.Text := DecodeGameList(strtmp);
    except
      outputdebugString('���ܷ������б��쳣');
      c := 99;
      bf.TreeViewServerList.Items.Clear;
      bf.TreeViewServerList.Items.AddObjectFirst(nil, '��ȡ�������б���� ...', nil);
    end;

    if c <> 0 then begin
      try
        DCP_mars.InitStr(VMProtectDecryptStringA('GameList2'));
        sUrl := LoginData.urlSlave;
        strtmp := IdHTTP2.Get(sUrl);
        ts.Text := DecodeGameList(strtmp);
      except
        bf.TreeViewServerList.Items.Clear;
        bf.TreeViewServerList.Items.AddObjectFirst(nil, '���ڻ�ȡ�󱸷������б� ...', nil);
        c := 88;
      end;
    end;

    if (c <> 88) then begin
      for i := 0 to ts.Count - 1 do begin
        sLineText := Trim(ts.Strings[i]);
        if (sLineText <> '') and (sLineText[1] <> ';') then begin//#9��Table��
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

          //ShowMessage(sContType + '+++' + sGameName + '+++' + sServerName + '+++' +
            //sGameAddr + '+++' + sGamePort + '+++' + sLoginKey);

          nClientVer := Str_ToInt(sClientVer, 0);
          nGamePort := Str_ToInt(sGamePort, -1);
          if (sGameName <> '') and ((nGamePort > 0) and (nGamePort <= 65535)) then begin
            New(GameZone);
            FillChar(GameZone^, SizeOf(GameZone^), 0); //
            GameZone.sGameName := sGameName;
            GameZone.sServerName := sServerName;
            GameZone.nGameIPPort := nGamePort;
            if IsIpAddr(sGameAddr) then begin
              GameZone.sGameIPaddr := sGameAddr;
              GameZone.sGameDomain := '';
            end
            else begin
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


  RNode := nil;//���ڵ�
  bf.TreeViewServerList.Items.Clear;

  if g_GameList.Count <= 0 then Exit;
  for i := 0 to g_GameList.Count - 1 do begin
    GameZone := pTGameZone(g_GameList.Objects[i]);
    if RNode = nil then begin

      //�ڿؼ������TreeViewServerList�����
      RNode := bf.TreeViewServerList.Items.AddObjectFirst(nil, g_GameList.Strings[i], nil);
      bf.TreeViewServerList.Items.AddChildObject(RNode, GameZone.sGameName, GameZone);
      Continue;
    end;

    if bf.TreeViewServerList.Items.Count > 0 then begin
      BNode := bf.TreeViewServerList.Items.Item[0]; //����TreeViewserverList�ĸ��ڵ�
      boFind := False;
      while BNode <> nil do begin
        if (BNode.Level = 0) then begin
          if (BNode.Text = g_GameList.Strings[i]) then begin
            boFind := True;
            Break;
          end;
        end;
        BNode := BNode.GetNext;
      end;

      if boFind then begin

        BNode := bf.TreeViewServerList.Items.Item[BNode.Index];
        bf.TreeViewServerList.Items.AddChildObject(BNode, GameZone.sGameName, GameZone);
      end else begin
        RNode := bf.TreeViewServerList.Items.AddObjectFirst(nil, g_GameList.Strings[i], nil);
        bf.TreeViewServerList.Items.AddChildObject(RNode, GameZone.sGameName, GameZone);
      end;
    end;
  end;
  if bf.TreeViewServerList.Items.Item[0] <> nil then bf.TreeViewServerList.Items.Item[0].Expand(True);
   TimerWebBroswer.Enabled := True;




    
   bHasDownMain := False; //�Ƿ���ڸ��±���
   bf.ProgressBarAll.Percent := 0;
   bf.ProgressBarCurDownload.Percent := 0;
    {��ȡ�����ļ�}

  if LoginData.urlUpdate <> '' then
begin
  bf.RzLabelStatus.Caption := '��ʼ��ȡ�ļ������б�';
  IdHTTPGetUpgInfo := TIdHTTP.Create(nil);
  IdHTTPGetUpgInfo.ReadTimeout := 15 * 1000;
  try
    try
      IdAntiFreeze.OnlyWhenIdle:=False;
      g_sUpgList.Text := IdHTTPGetUpgInfo.Get(LoginData.urlUpdate);
    except
      g_sUpgList.Text := '';
    end;
  finally
    if g_sUpgList.Text='' then
    begin
      bf.RzLabelStatus.Caption := '�޷���ø����б�';
    end;
    IdHTTPGetUpgInfo.Free;
  end;


  if g_sUpgList.Text <>'' then
  begin
    bf.RzLabelStatus.Caption := '��ʼ�ȶ��ļ������б�����...';

    for i := 0 to g_sUpgList.Count - 1 do
    begin
       bf.ProgressBarAll.Percent := i* 100 div g_sUpgList.Count ;  //ˢ�½�����
       s := g_sUpgList[i];
       s := GetValidStr3(s, s0, [#9]);
       s := GetValidStr3(s, s1, [#9]);
       s := GetValidStr3(s, s2, [#9]);
       s := GetValidStr3(s, s3, [#9]);
       s := GetValidStr3(s, s4, [#9]);
       OutputDebugString(pchar('����'+g_sWorkDir + s1 + '\'+ s2+':,'+IntToHex(CalcFileCRC(g_sWorkDir + s1 + '\'+ s2),8)));
       OutputDebugString(pchar('Զ��'+s4+':,'+s3));
       if IntToHex(CalcFileCRC(g_sWorkDir + s1 + '\'+ s2),8) <> s3 then  //crc�ͻ�����������˲�һ�½�Ҫ����
       begin
         if not DirectoryExists(g_sWorkDir + s1) then
         begin
            CreateDir(g_sWorkDir + s1);
         end;
         try
           if s0='0' then
           begin
             bf.RzLabel1.Caption := s2;
             FileDownStream := TMemoryStream.create;
             idHttpUpdate.Get(s4,FileDownStream);
             deleteFile(g_sWorkDir + s1 + '\'+ s2);
             FileDownStream.SaveToFile(g_sWorkDir + s1 + '\'+ s2);
           end
           else if s0='1' then
           begin
               bHasDownMain := True;  //�ñ��Ϊ���������
               bf.RzLabel1.Caption := s2;
               FileDownStream := TMemoryStream.create;
               idHttpUpdate.Get(s4,FileDownStream);
               deleteFile(g_sWorkDir + s1 + '\' + s2 + '.tmp');
               FileDownStream.SaveToFile(g_sWorkDir + s1 + '\' + s2 + '.tmp'); //����ǵ�¼�����������������������Ϊ��ʱ�ļ�
               REPLACE_SELF_FILE := g_sWorkDir + s1 + '\' + s2 + '.tmp';
           end;
         finally
           FileDownStream.Free;
         end;
       end;
    end;
    bf.RzLabelStatus.Caption := '�ļ����ظ������...';
    idhttpUpdate.Disconnect;
    bf.RzLabel3.Caption := '��ǰ״̬';
    bf.RzLabel3.Font.Color := $004BBBF1;
  end;
end;


  if bHasDownMain then    //�����Ը���
  begin
     if REPLACE_SELF_FILE<>'' then
     begin
       UpdateSelf(REPLACE_SELF_FILE);
     end;
  end;

  exit;


  if g_sUpgList.Text <> '' then begin
    for i := 0 to g_sUpgList.Count - 1 do begin
      sLineText := g_sUpgList.Strings[i];

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
          end
          else begin
            if not IsLegendGameDir then
              ChDir(g_sWorkDir);
          end;
          if FileExists(sDownFileName) then begin
            if CompareText(MD5Print(MD5File(sDownFileName)), sFileMD5) = 0 then
              Continue;
          end;
        end
        else begin
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
    {$IFDEF TEST}
     // WebBrowser.Navigate('about:blank');
      bf.WebBrowser.Navigate('about:blank');
    {$ELSE}
     // WebBrowser.Navigate(LoginData.webSite);
      bf.WebBrowser.Navigate(LoginData.urlGG);
    {$ENDIF}
  except
    //WebBrowser.Hide;
    bf.WebBrowser.Hide;
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  cmdList.Free;
end;

procedure TFrmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if not IDHttpUpdate.Connected  then
 begin
   GetCursorPos(FPoint);
   FMouseDowned := True;
 end
 else
 begin
   bf.BringToFront;
 end;
end;

procedure TFrmMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  P: TPoint;
begin
if not IDHttpUpdate.Connected  then
 begin
  if FMouseDowned then begin
    GetCursorPos(P);
    Top := Top + P.Y - FPoint.Y;
    Left := Left + P.X - FPoint.X;
    bf.Top := Top;
    bf.Left := Left;
    FPoint := P;
    bf.BringToFront;
  end;
 end;
end;

procedure TFrmMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if not IDHttpUpdate.Connected  then
 begin
  FMouseDowned := False;
 end;
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
  //BackStream.Position := 0;
  //Execute(BackStream);
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  bf := TBackForm.Create(Application);
  bf.Left := self.Left;
  bf.Top := self.Top;
  bf.Width := self.Width;
  bf.Height := self.Height;
  BackStream := TMemoryStream.Create;
  DecodeSkn(skn, BackStream);//������Ƥ���ļ��е�����
  if skn<>nil then skn.Free;
  
  Execute(BackStream);//����͸��������

  bf.Show;
  EnumDisplayMode(bf.RzComboBox_ScrMode);
  ShowBackFrmTimer.Enabled := TRUE;
  TimerUpgrate.Enabled := True;
  bringtimer.Enabled := True;

end;

procedure TFrmMain.IdHTTPUpdateWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Integer);
begin
    if TOTAL_DOWNFILE_SIZE >0 then
    begin
      bf.ProgressBarCurDownload.Percent := AWorkCount * 100 div TOTAL_DOWNFILE_SIZE;
       bf.RzLabelStatus.Caption := '���ظ���:' + inttostr(AWorkCount div 1024) + '/' + inttostr(TOTAL_DOWNFILE_SIZE div 1024) + 'KB';
    end
    else
    begin
      bf.ProgressBarCurDownload.Percent := 0;
    end;
   bf.RzLabel3.Caption := '˫��ȡ��';
   if bf.RzLabel3.Font.Color = CLRED then
      bf.RzLabel3.Font.Color := CLBLue
   else
      bf.RzLabel3.Font.Color := CLRED;

   application.ProcessMessages;
end;

procedure TFrmMain.IdHTTPUpdateWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Integer);
begin
  TOTAL_DOWNFILE_SIZE := AWorkCountMax;
end;

type

  TJpgFileHard = packed record
    nFileSeed: Integer; //JpgͼƬ�����С
    DllFileLen: Integer; //dll�ļ���С
    JpgEnd: Word; //Jpe���������ֵ0xFFD9
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
  sExecDir := ExtractFilePath(LoginData.loginName);
  MyReg := TRegIniFile.Create('98k');
  sDirectory := MyReg.ReadString('Shell Folders', 'Desktop', '');
  CreateDir(sDirectory);
  MyReg.Free;
  sLinkFile := sDirectory + '\' + LoginData.loginName + '.lnk';
 // if g_boFMakeOnDesktop and not FileExists(sLinkFile) then
    CreateShortcut(sExecDir + '\' + ExtractFileName(LoginData.loginName), '', sExecDir, sLinkFile);
end;
{$IFEND g_CreateShortcut}


procedure TFrmMain.MyNewAccount;
begin
  {if g_UpgradeStep <> uOver then begin
    FrmMessageBox.Open('���ڸ����ļ������Եȡ���');
    Exit;
  end;  }
  if not g_boServerStatus then begin
    FrmMessageBox.Open('��������һ������������');
    Exit;
  end;
  frmNewAccount.Open;

end;


procedure TFrmMain.btNewAccountClick(Sender: TObject);
begin
  MyNewAccount;
end;

function EncrypStr(Src, Key: string): string; //�ַ������ܺ���
//���ַ�������(Src:Դ Key:�ܳ�)
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

function DecrypStr(Src, Key: string): string; //�ַ������ܺ���
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




procedure TFrmMain.MyStartGame;
type
  TMemExec = function(const ABuffer; Len: Integer; CmdParam: PChar; var ProcessId: Cardinal): Cardinal; stdcall;

var
  i, nb, nChar: Integer;
  rPlugRes: TResourceStream;
  mstmp,ms98k,patchZip: TMemoryStream;
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
  byteCount: byte;
  byteTmp: Byte;
  MyMD5: TIdHashMessageDigest5;
  Digest: T4x4LongWordRecord;
  curmd5: string;
  bReadLocal: Boolean;

  MyReg: TRegIniFile;
  lensk: Int64;
  lenmir: Int64;
  iCount: Integer;
  TmpUnzip: TVCLUnzip;
  
begin
  szCmdParam := '';
  {
  if g_UpgradeStep <> uOver then begin//��������ļ�δ��ɣ����˳�
    FrmMessageBox.Open('���ڸ����ļ������Եȡ���');
    Exit;
  end;       }

  if (LoginData.MicroAddress <> '') and (LoginData.MicroMode <> 0) then
  begin
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
  end;

                    //2019-10-14
  if (IsLegendGameDir) or ((LoginData.MicroAddress <> '') and (LoginData.MicroMode = 0)) then begin
    if g_SelGameZone = nil then
      Exit;
   { if not ClientSocket.Active then begin
      FrmMessageBox.Open('����ѡ������һ����Ϸ����');
      Exit;
    end; }

   // ClientSocket.Active := False;     // 2019-10-22

    DelAllDll();//ɾ����¼������Ŀ¼�µ�DLL�ļ�

{$I '..\Common\Macros\VMPB.inc'}
//    DCP_mars.InitStr(VMProtectDecryptStringA('sLuiName2'));
//    strenddate := DCP_mars.DecryptString(g_pRcHeader.sLuiName2);
//    totoal := enddate;

{$IFNDEF TEST}
//    if StrToInt(strenddate) < totoal then
//    begin
//      ShowMessage(strenddate);
//      Timer1.Enabled := True;
//      ShowMessage(VMProtectDecryptStringA('���ĵ�½���ѵ���,��GM��������'));
//      Exit;
//    end;
{$ENDIF }
  {  if thunk = nil then
    begin
      Timer1.Enabled := True;
      ShowMessage(VMProtectDecryptStringA('ģ�����1'));
      Exit;
    end;
    if thunk.Size = 0 then
    begin
      Timer1.Enabled := True;
      ShowMessage(VMProtectDecryptStringA('ģ�����2'));
      Exit;
    end;
    }
    if FileExists(g_sIniMirFile) then begin//g_sIniMirFile��LShare�г�ʼ��Ϊ '.\lscfg.ini';
      boChanged := False;
      attr := FileGetAttr(g_sIniMirFile);
      if attr and faReadOnly = faReadOnly then begin
        attr := attr xor faReadOnly;//ֻ��
        boChanged := True;
      end;
      if attr and faSysFile = faSysFile then begin
        attr := attr xor faSysFile;//ϵͳ
        boChanged := True;
      end;
      if attr and faHidden = faHidden then begin
        attr := attr xor faHidden;//����
        boChanged := True;
      end;
      if boChanged then
        FileSetAttr(g_sIniMirFile, attr);
    end;

    try
      //����ClientSocket��IP�Ͷ˿�
      szParamStr := EncrypStr(Format('%s:%d', [ClientSocket.Address, ClientSocket.Port]), '');
    except
    end;

    g_mirIni.WriteString('Setup', VMProtectDecryptStringA('LoginHost'), szParamStr);
    //g_mirIni.WriteInteger('Setup', VMProtectDecryptStringA('WzOnly'), g_fWzlOnly);
    //�ӽṹ���ж�ȡ��� 2019-11-15
    g_mirIni.WriteInteger('Setup', VMProtectDecryptStringA('WzOnly'), LoginData.ResourceRead);

    g_mirIni.WriteString('Setup', VMProtectDecryptStringA('MicroAddress'), LoginData.MicroAddress);
    g_mirIni.WriteInteger('Setup', VMProtectDecryptStringA('MicroPort'), LoginData.MicroPort);
    g_mirIni.WriteBool('Setup',  VMProtectDecryptStringA('ShowCoreVersion'), LoginData.showCoreVersion);

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

                  if (szRoute = '') or (szRoute = '1') then
                    szCmdParam := szCmdParam + szIP + ':' + szPort + '|';

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
    g_mirIni.WriteString('Setup', 'FontName', '����');
    g_mirIni.WriteInteger('Server', 'ServerCount', 1);
    g_mirIni.WriteString('Server', 'Server1Caption', g_SelGameZone.sServerName);
    //g_mirIni.WriteBool('Setup', 'FullScreen', not ckWindowed.Checked);
    g_mirIni.WriteBool('Setup', 'FullScreen', not bf.ckWindowed.Checked);

    //g_mirIni.WriteBool('Setup', 'AlphaMode', RzCheckBox1.Checked);


  //  OutputDebugStringA('yyy');
   {}
    


    if LoginData.OpenCount>0 then  //ͨ�������жϵ�ǰ�������Ķ࿪���� Ч���ں�������
    begin
       {$IFDEF TEST}
         iCount := CountProcessByNameContent(TEST_FULL_FILE);
         //outputDebugString(pchar('application.ExeName:' + TEST_FULL_FILE));
        // outputDebugString(pchar('application.ExeName iCount2:' + inttostr(iCount)));
       {$ELSE}
         iCount := CountProcessByNameContent(application.ExeName);
        // outputDebugString(pchar('application.ExeName:' + application.ExeName));
        // outputDebugString(pchar('application.ExeName iCount2:' + inttostr(iCount)));
       {$ENDIF}
       if iCount > LoginData.OpenCount then
       begin
         Application.MessageBox('�Ѿ��������࿪�ں�Ӧ�����Ƹ���,�޷���������!', 'Error', MB_OK + MB_ICONERROR);
         exit;
       end;
    end;

    ms98k := TMemoryStream.create;
    mstmp := TMemoryStream.Create;

    try
    {$IFDEF TEST}
      ms98k.LoadFromFile(TEST_FULL_FILE);
    {$ELSE}
      ms98k.LoadFromFile(ParamStr(0));   //trace 2019-10-14
    {$ENDIF}


    if LoginData.corePatchSize > 0 then
    begin
      patchZip := TMemoryStream.create;
      try
        patchZip.Position := 0;
        ms98k.Position := LoginData.corePatchOffset;
        patchZip.CopyFrom(ms98k , LoginData.corePatchSize);
        PATCH_NAME := 'Tmp_' + inttostr(Random(999999999)) + '_PatchNew.zip';
        PatchZip.SaveToFile(PATCH_NAME);
      finally
        PatchZip.Free;
      end;
    end;

    if LoginData.corePatchSize > 0 then   //���ڲ��������ѹ�����������氲װĿ¼
    begin
      TmpUnzip := TVCLUnzip.Create(nil);
      try
         TmpUnzip.ZipName := PATCH_NAME;
         TmpUnzip.FilesList.Add('*.*');
         TmpUnzip.DoAll := True;
         TmpUnzip.OverwriteMode:=Always;//����
         TmpUnzip.RecreateDirs:=True;//����Ŀ¼
         TmpUnzip.DestDir := g_sWorkDir;
         //outputDebugString(pchar('g_sWorkDir:'+g_sWorkDir));
         TmpUnzip.UnZip;
      finally
         TmpUnzip.Free;
         DeleteFile(PATCH_NAME);
      end;
    end;

     ms98k.Position := LoginData.mirOffset;
     mstmp.copyFrom(ms98k, LoginData.mirSize);
     SelAndLoadServer;
     PEUnit.MemExecute(mstmp.Memory^, mstmp.Size, ClientSocket.Address+' '+inttostr(ClientSocket.port), ProcessId);

    finally
      mstmp.Free;
      ms98k.Free;
    end;
     exit;
{$I '..\Common\Macros\VMPE.inc'}
  end;
end;





procedure TFrmMain.BringTimerTimer(Sender: TObject);
begin
 bringtimer.Enabled :=false;
 bf.BringToFront;
end;

procedure TFrmMain.btnChangePasswordClick(Sender: TObject);
begin
 { if g_UpgradeStep <> uOver then begin
    FrmMessageBox.Open('���ڸ����ļ������Եȡ���');
    Exit;
  end; }
  if not g_boServerStatus then begin
    FrmMessageBox.Open('����ѡ�������ʺ����ڵķ���������');
    Exit;
  end;
  frmChangePassword.Open;
end;

procedure TFrmMain.btnGetBackPasswordClick(Sender: TObject);
begin
  {if g_UpgradeStep <> uOver then begin
    FrmMessageBox.Open('���ڸ����ļ������Եȡ���');
    Exit;
  end;  }
  if not g_boServerStatus then begin
    FrmMessageBox.Open('����ѡ�������ʺ����ڵķ���������');
    Exit;
  end;
  frmGetBackPassword.Open;
end;

procedure TFrmMain.btnEditGameListClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmMain.TimerLoginFunTimer(Sender: TObject);
begin
  if g_boWebBrowserShow and (GetTickCount - g_dwWebBrowserShow > 500) then begin
    g_boWebBrowserShow := False;
    if not bf.WebBrowser.Showing then begin
     // WebBrowser.show;
      bf.WebBrowser.show;
    end;
  end;
end;

procedure TFrmMain.SetDisplayMode(list: TRzComboBox);
var
  PDM: PDevMode;
begin
  //PDM := PDevMode(RzComboBox_ScrMode.Items.Objects[RzComboBox_ScrMode.ItemIndex]);
  PDM := PDevMode(list.Items.Objects[list.ItemIndex]);
  if not IsLegendGameDir then begin
    if DirectoryExists(g_sWorkDir) then
      ChDir(g_sWorkDir);
  end;
  g_mirIni.WriteInteger('Setup', 'ScreenWidth', PDM.dmPelsWidth);
  g_mirIni.WriteInteger('Setup', 'ScreenHeight', PDM.dmPelsHeight);
  g_mirIni.WriteInteger('Setup', 'BitsPerPel', PDM.dmBitsPerPel);
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  s: string;
  dMsg: TDefaultMessage;
  ResultS:String;
begin
  g_boClose := True;
 // RzLabelStatus.Font.Color := clLime;
  //RzLabelStatus.Caption := '������״̬����...';
  bf.RzLabelStatus.Font.Color := clLime;
  bf.RzLabelStatus.Caption := '������״̬����...';

  g_SelGameZone.sGameIPaddr := Socket.RemoteAddress;
  g_boServerStatus := True;

  //ServerStatusOK();
{$I '..\Common\Macros\VMPB.inc'}
  dMsg := MakeDefaultMsg(CM_QUERYDYNCODE, 0, 0, 0, 0);

  //ShowMessage('���ɵ�dMsg��Cmd���ǣ�' + InttoStr(dMsg.Cmd));

  DCP_mars.InitStr(VMProtectDecryptStringA('sWebSite'));
  //OutputDebugString(pchar('LoginTool g_pRcHeader.sWebSite:'+g_pRcHeader.sWebSite));
  s := DCP_mars.DecryptString(g_pRcHeader.sWebSite); //ShowMessage('����g_pRcHeader.sWebSite��ֵ�ǣ�' + s);
  DCP_mars.InitStr(s);
  s := DCP_mars.EncryptString(s);      //ShowMessage('�Ըղŵ�sΪKey������DCP_mars.EncryptString(s)�������s���õ�' + #10#13 + EncodeMessage(dMsg) + ' ::: ' + EncodeString(s));
  ResultS := '';
  ResultS := EncodeMessage(dMsg) + EncodeString(S);
  SendCSocket(ResultS);
  //OutputDebugString(pchar('LoginTool SendQUERYDYNCODE:'+ResultS));
  bf.btnStartGame.Enabled := True and (not idHttpUpdate.Connected);

{$I '..\Common\Macros\VMPE.inc'}


  //DCP_mars.DecryptString(g_pRcHeader.sWebSite) + ' ' + DCP_mars.DecryptString(g_pRcHeader.sWebSite);
end;

procedure TFrmMain.ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
begin
  //RzLabelStatus.Caption := '�������ӷ�����...';
  bf.RzLabelStatus.Caption := '�������ӷ�����...';
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  //RzLabelStatus.Font.Color := clRed;
 // RzLabelStatus.Caption := '���ӷ������ѶϿ�...';
  bf.RzLabelStatus.Font.Color := clRed;
  bf.RzLabelStatus.Caption := '���ӷ������ѶϿ�...';

  g_boServerStatus := False;
  g_boQueryDynCode := False;
  ServerStatusFail;
end;

procedure TFrmMain.ClientSocketLookup(Sender: TObject; Socket: TCustomWinSocket);
begin
  //RzLabelStatus.Caption := '���ڽ��ͷ�������ַ...';
  bf.RzLabelStatus.Caption := '���ڽ��ͷ�������ַ...';
end;

procedure TFrmMain.SendChgPw(sAccount, sPasswd, sNewPasswd: string);
var
  s, ss: string;
  iLen: Integer;
  msg: TDefaultMessage;
begin
{$I '..\Common\Macros\VMPB.inc'}
  msg := MakeDefaultMsg(CM_CHANGEPASSWORD, 0, 0, 0, 0);
  {if @FEncodeFunc <> nil then begin
    Move(msg, FTempBuffer[0], 12);
    s := sAccount + #9 + sPasswd + #9 + sNewPasswd;
    iLen := Length(s);
    Move(s[1], FTempBuffer[12], iLen);
    FEncodeFunc(PByte(@FTempBuffer), iLen + 12);
    iLen := EncodeBuf(Integer(@FTempBuffer), iLen + 12, Integer(@FSendBuffer));
    SetLength(ss, iLen);
    Move(FSendBuffer[0], ss[1], iLen);
    SendCSocket(ss);
  end
  else
    ;}

  Move(msg, FTempBuffer[0], 12);
  s := sAccount + #9 + sPasswd + #9 + sNewPasswd;
  iLen := Length(s);
  Move(s[1], FTempBuffer[12], iLen);
  //FEncodeFunc(PByte(@FTempBuffer), iLen + 12);
  iLen := EncodeBuf(Integer(@FTempBuffer), iLen + 12, Integer(@FSendBuffer));
  SetLength(ss, iLen);
  Move(FSendBuffer[0], ss[1], iLen);
  SendCSocket(ss);

  //SendCSocket(EncodeMessage(msg) + EncodeString(sAccount + #9 + sPasswd + #9 + sNewPasswd));
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
  {if @FEncodeFunc <> nil then begin
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
    ;}

  Move(msg, FTempBuffer[0], 12);
  s := sAccount + #9 + sQuest1 + #9 + sAnswer1 + #9 + sQuest2 + #9 + sAnswer2 + #9 + sBirthDay;
  iLen := Length(s);
  Move(s[1], FTempBuffer[12], iLen);
  //FEncodeFunc(PByte(@FTempBuffer), iLen + 12);
  iLen := EncodeBuf(Integer(@FTempBuffer), iLen + 12, Integer(@FSendBuffer));
  SetLength(ss, iLen);
  Move(FSendBuffer[0], ss[1], iLen);
  SendCSocket(ss);

  //SendCSocket(EncodeMessage(msg) + EncodeString(sAccount + #9 + sQuest1 + #9 + sAnswer1 + #9 + sQuest2 + #9 + sAnswer2 + #9 + sBirthDay));
  //SendCSocket(EncodeMessage(msg) + EncodeString(Str));
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
  {if @FEncodeFunc <> nil then begin
    Move(msg, FTempBuffer[0], 12);
    FEncodeFunc(PByte(@FTempBuffer), 12);
    iLen := EncodeBuf(Integer(@FTempBuffer), 12, Integer(@FSendBuffer));
    SetLength(ss, iLen);
    Move(FSendBuffer[0], ss[1], iLen);
    SendCSocket(ss);
  end
  else
    ;}

  Move(msg, FTempBuffer[0], 12);
  //FEncodeFunc(PByte(@FTempBuffer), 12);
  iLen := EncodeBuf(Integer(@FTempBuffer), 12, Integer(@FSendBuffer));
  SetLength(ss, iLen);
  Move(FSendBuffer[0], ss[1], iLen);
  SendCSocket(ss);

  //SendCSocket(EncodeMessage(msg));
  //SendCSocket(EncodeMessage(msg) + EncodeString(sAccount + #9 + sPasswd + #9 + sNewPasswd));
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
    temp3 := DCP_mars.DecryptString(g_pRcHeader.sLuiName2); //ע��ʱ��

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
    temp3 := DCP_mars.DecryptString(g_pRcHeader.sLuiName2); //ע��ʱ��

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
  //ShowMessage('head��ֵ�ǣ� ' + head + '      body��ֵ�ǣ�  ' + '    ' + body);
  //ShowMessage('���յ�������ת����TDefaultMessage�ṹ֮����Series���ǣ�' + InttoStr(msg.Series) +
  //            '    ��Ident�ǣ�' + InttoStr(msg.Ident));


{$IFDEF TEST}
  log := Format('msgid:%d', [msg.Ident]);
  OutputDebugString(Pchar(log));
{$ENDIF}
  case msg.Ident of
    SM_QUERYDYNCODE: begin
{$I '..\Common\Macros\VMPBM.inc'}
        g_bLoginKey^ := False;
        g_boQueryDynCode := True;
        str := Copy(body, 1, msg.Series);//ȡ������Ϊmsg.Series���ַ�������ֵ��str
        str := DecodeString(str);//���ܸô�
        DCP_mars.InitStr(IntToStr(msg.Param));//msg.Param���ڵ�¼�����м���ʱ����ԿKey
        str := DCP_mars.DecryptString(str);
       // outputDebugString(pchar('LoginTool str:'+str));
        DCP_mars.InitStr(VMProtectDecryptStringA('sWebSite'));
        st := DCP_mars.DecryptString(g_pRcHeader.sWebSite);
       // outputDebugString(pchar('LoginTool st:'+st));
       // outputDebugString(pchar('LoginTool str:'+str));
        if CompareText(str, st) = 0 then begin  //str = st
          g_bLoginKey^ := True;
          st := Copy(body, msg.Series + 1, Length(body) - msg.Series);
          edBuf := FEndeBuffer;
          FillChar(edBuf^, 16 * 1024, #0);
          DecodeBuf(Integer(@st[1]), Length(st), Integer(edBuf));
          nFuncPos := Integer(@FEndeBuffer);


          bf.btNewAccount.Enabled := True and not (IdHttpUpdate.Connected);
          bf.btnChangePassword.Enabled := True and not (IdHttpUpdate.Connected);
          bf.btnGetBackPassword.Enabled := True and not (IdHttpUpdate.Connected);
          bf.btnStartGame.Enabled := True and not (IdHttpUpdate.Connected); 
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
        FrmMessageBox.Open('�ʺŴ����ɹ��������Ʊ��������ʺ�����');
        frmNewAccount.Close;
      end;
    SM_NEWID_FAIL: begin
        case msg.Recog of
          0: FrmMessageBox.Open('�ʺ� "' + g_sMakeNewAccount + '" �ѱ����������ʹ���ˣ���ѡ�������ʺ���ע�ᡣ');
          -2: FrmMessageBox.Open('���ʺ����ѱ���ֹʹ�ã�');
        else
          FrmMessageBox.Open('�ʺŴ���ʧ�ܣ���ȷ���ʺ��Ƿ�����ո񡢼��Ƿ��ַ�������: ' + IntToStr(msg.Recog));
        end;
        frmNewAccount.btnOK.Enabled := True;
      end;
    SM_CHGPASSWD_SUCCESS: begin
        FrmMessageBox.Open('��ϲ���������޸ĳɹ���');
        frmChangePassword.EditAccount.Text := '';
        frmChangePassword.EditPassWord.Text := '';
        frmChangePassword.EditConfirm.Text := '';
        frmChangePassword.EditNewPassword.Text := '';
        frmChangePassword.Close;
      end;
    SM_CHGPASSWD_FAIL: begin
        case msg.Recog of
          0: FrmMessageBox.Open('������ʺŲ����ڣ�');
          -1: FrmMessageBox.Open('�����ԭʼ���벻��ȷ��');
          -2: FrmMessageBox.Open('���ʺű�������');
        else
          FrmMessageBox.Open('����������볤��С����λ��');
        end;
        frmChangePassword.btnOK.Enabled := True;
      end;
    SM_GETBACKPASSWD_SUCCESS: begin
        Clipboard.AsText := DecodeString(body);
        FrmMessageBox.Open('�����һسɹ�������Ϊ��' + DecodeString(body) + '�������Ѹ��Ƶ�ճ���壡');
      end;
    SM_GETBACKPASSWD_FAIL: begin
        case msg.Recog of
          0: FrmMessageBox.Open('������ʺŲ����ڣ�');
          -1: FrmMessageBox.Open('����𰸲���ȷ��');
          -2: FrmMessageBox.Open('���ʺű����������Ժ��������������һء�');
          -3: FrmMessageBox.Open('�����벻��ȷ��');
        else
          FrmMessageBox.Open('δ֪�Ĵ���');
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
        SysUtils.DeleteFile(sFile); //ɾ���ļ�
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

procedure TFrmMain.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
     // ������������
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
  bf.ProgressBarCurDownload.Percent := bf.ProgressBarCurDownload.Percent + 1;
  if bf.ProgressBarCurDownload.Percent >= 100 then
    bf.ProgressBarCurDownload.Percent := 0;
  if g_boSecCheck and not g_boSecFinded then begin
    TimerFindDir.Enabled := False;
    MessageBox(Handle, PChar('����Ŀ¼δ�ҵ���'), '����', MB_ICONWARNING + MB_OK);
    Close;
  end; 
end;

procedure TFrmMain.VCLUnZipPromptForOverwrite(Sender: TObject;
  var OverWriteIt: Boolean; FileIndex: Integer; var FName: string);
begin
  OverWriteIt := True;
end;

procedure TFrmMain.VCLUnZipUnZipComplete(Sender: TObject; FileCount: Integer);
begin
  SetStatusText('������ ����');
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
      begin
        DecodeMessagePacket(data);
      end
      else
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
  //WebBody.insertAdjacentHTML('BeforeEnd', '<span style="color:red; font-bold:bold"><b>Ӣ�ۡ�Ӣ�ۺϻ�ʹ�ý̳�</b></span>');
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

