unit svMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  NMUDP, Buttons, StdCtrls, M2Share, ShellAPI, Grobal2, HUtil32, RunSock, Envir, ItmUnit, CnHashTable,
  Magic, NoticeM, Guild, Event, Castle, FrnEngn, UsrEngn, MudUtil, SyncObjs, Menus, ComCtrls, Grids,
  WinSock, Sockets, bDiaLogs, md5, TLHelp32, SqlEngn, DBSQL, psapi, HashList, StallSystem,
  IdTime, IdBaseComponent, IdComponent, IdIPWatch, VCLUnZip, VCLZip, ucheck, mars, MsXML, DateUtils, D7ScktComp;
type
  IStrings = class(TStringlist)
  protected
    procedure SetTextStr(const Value: string); override;
  end;

  TFrmMain = class(TForm)
    MemoLog: TMemo;
    Timer1: TTimer;
    RunTimer: TTimer;
    DBSocket: TClientSocket;
    ConnectTimer: TTimer;
    StartTimer: TTimer;
    SaveVariableTimer: TTimer;
    CloseTimer: TTimer;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_START: TMenuItem;
    MENU_CONTROL_STOP: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_CONTROL_RELOAD_CONF: TMenuItem;
    MENU_CONTROL_CLEARLOGMSG: TMenuItem;
    MENU_HELP: TMenuItem;
    MENU_HELP_ABOUT: TMenuItem;
    MENU_MANAGE: TMenuItem;
    MENU_CONTROL_RELOAD: TMenuItem;
    MENU_CONTROL_RELOAD_ITEMDB: TMenuItem;
    MENU_CONTROL_RELOAD_MAGICDB: TMenuItem;
    MENU_CONTROL_RELOAD_MONSTERDB: TMenuItem;
    MENU_MANAGE_PLUG: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_SERVERCONFIG: TMenuItem;
    MENU_OPTION_GAME: TMenuItem;
    MENU_OPTION_FUNCTION: TMenuItem;
    MENU_CONTROL_RELOAD_MONSTERSAY: TMenuItem;
    MENU_CONTROL_RELOAD_DISABLEMAKE: TMenuItem;
    MENU_CONTROL_GATE: TMenuItem;
    MENU_CONTROL_GATE_OPEN: TMenuItem;
    MENU_CONTROL_GATE_CLOSE: TMenuItem;
    MENU_VIEW: TMenuItem;
    MENU_VIEW_GATE: TMenuItem;
    MENU_VIEW_SESSION: TMenuItem;
    MENU_VIEW_ONLINEHUMAN: TMenuItem;
    MENU_VIEW_LEVEL: TMenuItem;
    MENU_VIEW_LIST: TMenuItem;
    MENU_MANAGE_ONLINEMSG: TMenuItem;
    MENU_VIEW_KERNELINFO: TMenuItem;
    MENU_TOOLS: TMenuItem;
    MENU_TOOLS_MERCHANT: TMenuItem;
    MENU_TOOLS_NPC: TMenuItem;
    MENU_OPTION_ITEMFUNC: TMenuItem;
    MENU_TOOLS_MONGEN: TMenuItem;
    MENU_TOOLS_TEST: TMenuItem;
    DECODESCRIPT: TMenuItem;
    MENU_CONTROL_RELOAD_STARTPOINT: TMenuItem;
    G1: TMenuItem;
    MenuStackTest: TMenuItem;
    MENU_OPTION_MONSTER: TMenuItem;
    MENU_TOOLS_IPSEARCH: TMenuItem;
    MENU_MANAGE_CASTLE: TMenuItem;
    MENU_CONTROL_RELOAD_SABAK: TMenuItem;
    N1: TMenuItem;
    Panel1: TPanel;
    LbRunTime: TLabel;
    LbUserCount: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    LbRunSocketTime: TLabel;
    Label20: TLabel;
    MemStatus: TLabel;
    GridGate: TStringGrid;
    MENU_VIEW_HIGHRANK: TMenuItem;
    MENU_CONTROL_RELOAD_QFUNCTIONSCRIPT: TMenuItem;
    N3: TMenuItem;
    MENU_CONTROL_RELOAD_QMagegeScriptClick: TMenuItem;
    Splitter: TSplitter;
    MENU_CONTROL_RELOAD_BOXITEM: TMenuItem;
    MENU_CONTROL_RELOAD_REFINEITEM: TMenuItem;
    RELOADHILLITEMNAMELIST: TMenuItem;
    M1: TMenuItem;
    IdIPWatch: TIdIPWatch;
    N2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    LogUDP: TNMUDP;
    mniAllNpc: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    NPC1: TMenuItem;
    NPC2: TMenuItem;
    N14: TMenuItem;

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MemoLogChange(Sender: TObject);
    procedure MemoLogDblClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_CONFClick(Sender: TObject);
    procedure MENU_CONTROL_CLEARLOGMSGClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_ITEMDBClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MAGICDBClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MONSTERDBClick(Sender: TObject);
    procedure MENU_CONTROL_STARTClick(Sender: TObject);
    procedure MENU_CONTROL_STOPClick(Sender: TObject);
    procedure MENU_OPTION_SERVERCONFIGClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_GAMEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MENU_OPTION_FUNCTIONClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MONSTERSAYClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_DISABLEMAKEClick(Sender: TObject);
    procedure MENU_CONTROL_GATE_OPENClick(Sender: TObject);
    procedure MENU_CONTROL_GATE_CLOSEClick(Sender: TObject);
    procedure MENU_CONTROLClick(Sender: TObject);
    procedure MENU_VIEW_GATEClick(Sender: TObject);
    procedure MENU_VIEW_SESSIONClick(Sender: TObject);
    procedure MENU_VIEW_ONLINEHUMANClick(Sender: TObject);
    procedure MENU_VIEW_LEVELClick(Sender: TObject);
    procedure MENU_VIEW_LISTClick(Sender: TObject);
    procedure MENU_MANAGE_ONLINEMSGClick(Sender: TObject);
    procedure MENU_VIEW_KERNELINFOClick(Sender: TObject);
    procedure MENU_TOOLS_MERCHANTClick(Sender: TObject);
    procedure MENU_OPTION_ITEMFUNCClick(Sender: TObject);
    procedure MENU_TOOLS_MONGENClick(Sender: TObject);
    procedure DECODESCRIPTClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_STARTPOINTClick(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure MENU_OPTION_MONSTERClick(Sender: TObject);
    procedure MENU_TOOLS_IPSEARCHClick(Sender: TObject);
    procedure MENU_MANAGE_CASTLEClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_SABAKClick(Sender: TObject);
    procedure MENU_TOOLS_NPCClick(Sender: TObject);
    procedure MENU_VIEW_HIGHRANKClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_QFUNCTIONSCRIPTClick(Sender: TObject);
    procedure MENU_MANAGE_PLUGClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_QMagegeScriptClickClick(Sender: TObject);
    procedure MemStatusClick(Sender: TObject);
    procedure MENU_TOOLS_TESTClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_BOXITEMClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_REFINEITEMClick(Sender: TObject);
    procedure RELOADHILLITEMNAMELISTClick(Sender: TObject);
    procedure M1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure mniAllNpcClick(Sender: TObject);
    procedure MENU_HELP_ABOUTClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure NPC1Click(Sender: TObject);
    procedure NPC2Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
  private
    boServiceStarted: Boolean;
    procedure GateSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure GateSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure SaveVariableTimerTimer(Sender: TObject);
    procedure RunTimerTimer(Sender: TObject);
    procedure ConnectTimerTimer(Sender: TObject);
    procedure StartService();
    procedure StopService();
    procedure SaveItemNumber(boSaveVal: Boolean);
    function LoadClientFile(): Boolean;

    // function GetNetTime(aUrl: WideString = 'http://www.sohu.com'): string;  
    
    // function GMTToBeiJing(const sGMT: string): string;           

    procedure StartEngine;
    procedure MakeStoneMines;
    //function MakeNimbus(): Integer;
    procedure ReloadConfig(Sender: TObject);
    procedure ClearMemoLog();
    procedure CloseGateSocket();
  public
    GateSocket: TServerSocket;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure OnProgramException(Sender: TObject; E: Exception);
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    procedure MyTestMessage(var msg: TMessage); message WM_TEST_INFO;
  end;

function LoadAbuseInformation(FileName: string): Boolean;
procedure LoadServerTable();
procedure WriteConLog(MsgList: TStringlist);
procedure ChangeCaptionText(msg: PChar; nLen: Integer); stdcall;
procedure ChangeLabelVerColor(nColor: Integer); stdcall;
procedure UserEngineThread(ThreadInfo: pTThreadInfo); stdcall;
procedure ProcessGameRun();
{$IF USEWLSDK > 0}
function RegInfoDialogProc(Handle: THandle; MsgID: UINT; wParam, lParam: Integer): BOOL; stdcall;
{$IFEND}

var
  FrmMain: TFrmMain;
  g_GateSocket: TServerSocket;
  g_dwGetResStrTick: LongWord;
  g_dwCheckHDTick: LongWord;
  l_dwRunTimeTick, l_dwRunTimeTick2: LongWord;
  g_lpDateTime: TDateTime = 0;

implementation

uses
  backdoor, LocalDB, InterServerMsg, InterMsgClient, IdSrvClient, FSrvValue, GeneralConfig, GameConfig,
  FunctionConfig, ObjRobot, ViewSession, ViewOnlineHuman, ViewLevel, ViewList, OnlineMsg, HWIDFilter,
  ViewKernelInfo, PlugIn, ConfigMerchant, ItemSet, ConfigMonGen, EDcode, EncryptUnit, AdaptersInfo,
  PlugInManage, GameCommand, MonsterConfig, RunDB, CastleManage, SDK, ViewHighRank, StartPointManage, ObjBase, __DESUnit, VMProtectSDK
{$IF USEWLSDK = 1}, WinlicenseSDK{$ELSEIF USEWLSDK = 2}, SELicenseSDK, SESDK{$IFEND}, Registry,
  ImageFileCustomU, SafeZoneEffectsCustomU, NpcCustomU,SafeZoneControlCustomU;

var
  sCaption: string;
  sCaptionExtText: string;
  c_dwRunTimeTick: LongWord = 0;
  l_dwSaveTimeTick: LongWord = 0;
  boRemoteOpenGateSocket: Boolean = False;                 
  boRemoteOpenGateSocketed: Boolean = False;
  g_SaveGlobalValNo: Integer = 0;
  sWellCome: string = '欢迎使用98KM2数据库服务器';
  sProgram: string = '程序制作：';
  sOwen: string = '98KM2';
  sUpdate: string = '更新日期：2019/12/27';
  sWebSite: string = '程序网站：http://www.98km2.com';
  sBbsSite: string = '程序论坛：http://bbs.98km2.com';

{$R *.dfm}

procedure ChangeCaptionText(msg: PChar; nLen: Integer); stdcall;
var
  sMsg: string;
begin
  if (nLen > 0) and (nLen < 30) then
  begin
    SetLength(sMsg, nLen);
    Move(msg^, sMsg[1], nLen);
    sCaptionExtText := sMsg;
  end;
end;

procedure ChangeLabelVerColor(nColor: Integer); stdcall;
begin
  case nColor of
    1: FrmMain.MemStatus.Font.Color := clRed;
    2: FrmMain.MemStatus.Font.Color := clBlue;
  else
    FrmMain.MemStatus.Font.Color := clBlack;
  end;
end;

procedure PlugRunOver(); stdcall;
begin
  boRemoteOpenGateSocket := True;
  if RemoteXORKey <> LocalXORKey then
  begin
    //sChar := '?';
    //sRun := 'run';
    FrontEngine.Suspend;
  end;
end;

function GetSelfCrc(): PChar;
var
  nCRC: LongWord;
begin
{$I '..\Common\Macros\VMPB.inc'}
  nCRC := LongWord(CalcFileCRC(Application.ExeName));
  Result := PChar(MD5Print(MD5File(Application.ExeName)) + IntToStr(nCRC));
{$I '..\Common\Macros\VMPE.inc'}
end;

function LoadAbuseInformation(FileName: string): Boolean;
var
  i: Integer;
  sText: string;
begin
  Result := False;
  if FileExists(FileName) then
  begin
    AbuseTextList.Clear;
    AbuseTextList.LoadFromFile(FileName);
    i := 0;
    while (True) do
    begin
      if AbuseTextList.Count <= i then Break;
      sText := Trim(AbuseTextList.Strings[i]);
      if sText = '' then
      begin
        AbuseTextList.Delete(i);
        Continue;
      end;
      Inc(i);
    end;
    Result := True;
  end;
end;

procedure LoadServerTable();
var
  i: Integer;
  LoadList: TStringlist;
  nRouteIdx, nGateIdx: Integer;
  sLineText, sIdx, sSelGateIPaddr, sGameGateIPaddr, sGameGate, sGameGatePort: string;
begin
  FillChar(g_RouteInfo, SizeOf(g_RouteInfo), #0);
  LoadList := TStringlist.Create;
  LoadList.LoadFromFile('.\!ServerTable.txt');
  nRouteIdx := 0;
  for i := 0 to LoadList.Count - 1 do
  begin
    sLineText := LoadList.Strings[i];
    if (sLineText <> '') and (sLineText[1] <> ';') then
    begin
      sLineText := GetValidStr3(sLineText, sIdx, [' ', #9]);
      sGameGate := GetValidStr3(sLineText, sSelGateIPaddr, [' ', #9]);
      if (sIdx = '') or (sGameGate = '') or (sSelGateIPaddr = '') then
        Continue;
      g_RouteInfo[nRouteIdx].nGateCount := 0;
      g_RouteInfo[nRouteIdx].nServerIdx := Str_ToInt(sIdx, 0);
      g_RouteInfo[nRouteIdx].sSelGateIP := Trim(sSelGateIPaddr);
      nGateIdx := 0;
      while (sGameGate <> '') do
      begin
        sGameGate := GetValidStr3(sGameGate, sGameGateIPaddr, [' ', #9]);
        sGameGate := GetValidStr3(sGameGate, sGameGatePort, [' ', #9]);
        g_RouteInfo[nRouteIdx].sGameGateIP[nGateIdx] := Trim(sGameGateIPaddr);
        g_RouteInfo[nRouteIdx].nGameGatePort[nGateIdx] := Str_ToInt(sGameGatePort, 0);
        Inc(nGateIdx);
      end;
      g_RouteInfo[nRouteIdx].nGateCount := nGateIdx;
      Inc(nRouteIdx);
      if nRouteIdx > High(g_RouteInfo) then Break
    end;
  end;
  LoadList.Free;
end;

procedure WriteConLog(MsgList: TStringlist);
var
  i: Integer;
  Year, Month, Day, Hour, Min, Sec, msec: Word;
  sLogDir, sLogFileName: string;
  LogFile: TextFile;
begin
  if MsgList.Count <= 0 then Exit;
  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, msec);
  if not DirectoryExists(g_Config.sConLogDir) then
    CreateDir(g_Config.sConLogDir);
  sLogDir := g_Config.sConLogDir + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day);
  if not DirectoryExists(sLogDir) then
    CreateDirectory(PChar(sLogDir), nil);
  sLogFileName := sLogDir + '\C-' + IntToStr(g_nServerIndex) + '-' + IntToStr2(Hour) + 'H' + IntToStr2((Min div 10 * 2) * 5) + 'M.txt';
  AssignFile(LogFile, sLogFileName);
  if not FileExists(sLogFileName) then
    Rewrite(LogFile)
  else
    Append(LogFile);
  for i := 0 to MsgList.Count - 1 do
    Writeln(LogFile, '1' + #9 + MsgList.Strings[i]);
  CloseFile(LogFile);
end;

procedure IStrings.SetTextStr(const Value: string);
begin
{$IF USEWLSDK > 0}
  BeginUpdate;
  try
    Clear;
    P := Pointer(Value);
    if P <> nil then
    begin
      pEnd := P + Length(Value);
      while P < pEnd do
      begin
        Start := P;
        while (P < pEnd) and not (P^ in [#10, #13]) do
          Inc(P);
        SetString(S, Start, P - Start);
        Add(S);
        if P^ = #13 then
          Inc(P);
        if P^ = #10 then
          Inc(P);
      end;
    end;
  finally
    EndUpdate;
  end;
{$IFEND USEWLSDK}
end;

procedure TFrmMain.SaveItemNumber(boSaveVal: Boolean);
var
  i: Integer;
begin
  Config.WriteInteger('Setup', 'ItemNumber', g_Config.nItemNumber);
  Config.WriteInteger('Setup', 'ItemNumberEx', g_Config.nItemNumberEx);
  if boSaveVal or ((GetTickCount - l_dwSaveTimeTick) > 15 * 60 * 1000) then
  begin
    l_dwSaveTimeTick := GetTickCount;
    if not boSaveVal then
    begin
      case g_SaveGlobalValNo of
        0: for i := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do
            Config.WriteInteger('Setup', 'GlobalVal' + IntToStr(i), g_Config.GlobalVal[i]);
        1: for i := Low(g_Config.HGlobalVal) to High(g_Config.HGlobalVal) do
            Config.WriteInteger('Setup', 'HGlobalVal' + IntToStr(i), g_Config.HGlobalVal[i]);
        2: for i := Low(g_Config.GlobaDyTval) to High(g_Config.GlobaDyTval) do
            Config.WriteString('Setup', 'GlobaStrVal' + IntToStr(i), Trim(g_Config.GlobaDyTval[i]));
      end;
    end
    else
    begin
      for i := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do
        Config.WriteInteger('Setup', 'GlobalVal' + IntToStr(i), g_Config.GlobalVal[i]);
      for i := Low(g_Config.HGlobalVal) to High(g_Config.HGlobalVal) do
        Config.WriteInteger('Setup', 'HGlobalVal' + IntToStr(i), g_Config.HGlobalVal[i]);
      for i := Low(g_Config.GlobaDyTval) to High(g_Config.GlobaDyTval) do
        Config.WriteString('Setup', 'GlobaStrVal' + IntToStr(i), Trim(g_Config.GlobaDyTval[i]));
    end;
    Inc(g_SaveGlobalValNo);
    if g_SaveGlobalValNo > 2 then
      g_SaveGlobalValNo := 0;
    Config.WriteInteger('Setup', 'WinLotteryCount', g_Config.nWinLotteryCount);
    Config.WriteInteger('Setup', 'NoWinLotteryCount', g_Config.nNoWinLotteryCount);
    Config.WriteInteger('Setup', 'WinLotteryLevel1', g_Config.nWinLotteryLevel1);
    Config.WriteInteger('Setup', 'WinLotteryLevel2', g_Config.nWinLotteryLevel2);
    Config.WriteInteger('Setup', 'WinLotteryLevel3', g_Config.nWinLotteryLevel3);
    Config.WriteInteger('Setup', 'WinLotteryLevel4', g_Config.nWinLotteryLevel4);
    Config.WriteInteger('Setup', 'WinLotteryLevel5', g_Config.nWinLotteryLevel5);
    Config.WriteInteger('Setup', 'WinLotteryLevel6', g_Config.nWinLotteryLevel6);
  end;
end;

procedure TFrmMain.AppOnIdle(Sender: TObject; var Done: Boolean);
begin
  //MainOutMessageAPI ('空闲');
end;

procedure TFrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  MainOutMessageAPI(E.Message);
end;

procedure TFrmMain.DBSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  tStr: string;
begin
  EnterCriticalSection(UserDBSection);
  try
    tStr := Socket.ReceiveText;
    g_Config.sDBSocketRecvText := g_Config.sDBSocketRecvText + tStr;
    if not g_Config.boDBSocketWorking then
      g_Config.sDBSocketRecvText := '';
  finally
    LeaveCriticalSection(UserDBSection);
  end;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  boWriteLog: Boolean;
  i, nRow: Integer;
  wDay, wHour, wMinute, wSecond: Word;
  tSecond: Integer;
  sSrvType: string;
  sVerType: string;
  tTimeCount: Currency;
  GateInfo: pTGateInfo;
  LogFile: TextFile;
  MemoryStream: TMemoryStream;
  s28: string;
resourcestring
  rsLocalIP = '6A3BFD7F0D4480FF0420B28CC3F2F7C2';
begin
  if g_lpDateTime = 0 then
    Caption := Format('%s', [g_Config.sServerName])
  else
  begin
    //Caption := Format('%s[剩余使用天数：%d]', [g_Config.sServerName, GetDayCount(g_lpDateTime, Now)]);
    Caption := Format('%s[授权期限至：%s]', [g_Config.sServerName, DateToStr(g_lpDateTime)]);
  end;

  EnterCriticalSection(LogMsgCriticalSection);
  try
    if MemoLog.Lines.Count > 500 then
      MemoLog.Clear;
    boWriteLog := True;
    if MainLogMsgList.Count > 0 then
    begin
      try
        if not FileExists(sLogFileName) then
        begin
          AssignFile(LogFile, sLogFileName);
          Rewrite(LogFile);
        end
        else
        begin
          AssignFile(LogFile, sLogFileName);
          Append(LogFile);
        end;
        boWriteLog := False;
      except
        MemoLog.Lines.Add('保存日志信息出错！');
      end;
    end;

    for i := 0 to MainLogMsgList.Count - 1 do
    begin
      MemoLog.Lines.Add(MainLogMsgList.Strings[i]);
      if not boWriteLog then
        Writeln(LogFile, MainLogMsgList.Strings[i]);
    end;
    MainLogMsgList.Clear;

    if not boWriteLog then
      CloseFile(LogFile);

    for i := 0 to LogStringList.Count - 1 do
    begin
      MemoryStream := TMemoryStream.Create;
      try
        s28 := '1' + #9 + IntToStr(g_Config.nServerNumber) + #9 + IntToStr(g_nServerIndex) + #9 + LogStringList.Strings[i];
        MemoryStream.Write(s28[1], Length(s28));
        LogUDP.SendStream(MemoryStream);
      finally
        MemoryStream.Free;
      end;
    end;
    LogStringList.Clear;

    if LogonCostLogList.Count > 0 then
      WriteConLog(LogonCostLogList);
    LogonCostLogList.Clear;
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;

  if GetTickCount - c_dwRunTimeTick > 8 * 60 * 1015 then
  begin
    c_dwRunTimeTick := GetTickCount();
  end;

{$IF SoftVersion = VERDEMO}
  sVerType := '[D]';
{$ELSEIF SoftVersion = VERFREE}
  sVerType := '[F]';
{$ELSEIF SoftVersion = VERSTD}
  sVerType := '[S]';
{$ELSEIF SoftVersion = VEROEM}
  sVerType := '[O]';
{$ELSEIF SoftVersion = VERPRO}
  sVerType := '[P]';
{$ELSEIF SoftVersion = VERENT}
  sVerType := '[E]';
{$IFEND}

  if g_nServerIndex = 0 then
    sSrvType := '[M]'
  else if FrmMsgClient.MsgClient.Socket.Connected then
    sSrvType := '[S]'
  else
    sSrvType := '[ ]';
  nRow := UserEngine.OfflinePlayCount;
  LbUserCount.Caption := Format('(%d) [%d+%d/%d][%d/%d/%d]', [UserEngine.MonsterCount, nRow, UserEngine.OnlinePlayObject - nRow, UserEngine.PlayObjectCount, FrontEngine.SaveListCount, UserEngine.LoadPlayCount, UserEngine.m_PlayObjectFreeList.Count]);
  Label1.Caption := Format('Run(%d/%d) Soc(%d/%d) Usr(%d/%d)', [nRunTimeMin, nRunTimeMax, g_nSockCountMin, g_nSockCountMax, g_nUsrTimeMin, g_nUsrTimeMax]);
  Label2.Caption := Format('Hum%d/%d Her%d/%d Usr%d/%d Mer%d/%d Npc%d/%d', [g_nHumCountMin, g_nHumCountMax, UserEngine.dwProcessHeroTimeMin, UserEngine.dwProcessHeroTimeMax, dwUsrRotCountMin, dwUsrRotCountMax, UserEngine.dwProcessMerchantTimeMin, UserEngine.dwProcessMerchantTimeMax, UserEngine.dwProcessNpcTimeMin, UserEngine.dwProcessNpcTimeMax]);
  Label5.Caption := Format('[%s]  [%s]', [g_sMonGenInfo1, g_sMonGenInfo2]);
  Label20.Caption := Format('Mong(%d/%d/%d) Monp(%d/%d/%d) ObjRun(%d/%d)', [g_nMonGenTime, g_nMonGenTimeMin, g_nMonGenTimeMax, g_nMonProcTime, g_nMonProcTimeMin, g_nMonProcTimeMax, g_nBaseObjTimeMin, g_nBaseObjTimeMax]);

  if (MemStatus.Caption = '') or (GetTickCount - g_dwGetResStrTick > 5 * 60 * 1000) then
  begin
    g_dwGetResStrTick := GetTickCount;
    MemStatus.Caption := GetResourceString(t_sUpDateTime);
  end;

  tSecond := (GetTickCount - g_dwStartTick) div 1000;
  wDay := tSecond div (3600 * 24);
  wHour := (tSecond div 3600) mod 24;
  wMinute := (tSecond div 60) mod 60;
  wSecond := tSecond mod 60;
  tTimeCount := GetTickCount() / (24 * 60 * 60 * 1000);
  if tTimeCount >= 30 then
    LbRunSocketTime.Font.Color := clRed
  else
    LbRunSocketTime.Font.Color := clBlack;
  LbRunSocketTime.Caption := sSrvType + '[' + IntToStr(wDay) + ':' + IntToStr(wHour) + ':' + IntToStr(wMinute) + ':' + IntToStr(wSecond) + '/' + CurrToStr(tTimeCount) + ']'; // + ' ' + sSrvType + sVerType;

  nRow := 1;
  for i := Low(g_GateArr) to High(g_GateArr) do
  begin
    GridGate.Cells[0, i + 1] := '';
    GridGate.Cells[1, i + 1] := '';
    GridGate.Cells[2, i + 1] := '';
    GridGate.Cells[3, i + 1] := '';
    GridGate.Cells[4, i + 1] := '';
    GridGate.Cells[5, i + 1] := '';
    GridGate.Cells[6, i + 1] := '';
    GateInfo := @g_GateArr[i];
    if GateInfo.boUsed and (GateInfo.Socket <> nil) then
    begin
      GridGate.Cells[0, nRow] := IntToStr(i);
      GridGate.Cells[1, nRow] := GateInfo.sAddr + ':' + IntToStr(GateInfo.nPort);
      GridGate.Cells[2, nRow] := IntToStr(GateInfo.nSendMsgCount);
      GridGate.Cells[3, nRow] := IntToStr(GateInfo.nSendedMsgCount);
      GridGate.Cells[4, nRow] := IntToStr(GateInfo.nSendRemainCount);
      if GateInfo.nSendMsgBytes < 1024 then
        GridGate.Cells[5, nRow] := IntToStr(GateInfo.nSendMsgBytes) + 'b'
      else
        GridGate.Cells[5, nRow] := IntToStr(GateInfo.nSendMsgBytes div 1024) + 'kb';
      GridGate.Cells[6, nRow] := IntToStr(GateInfo.nUserCount) + '/' + IntToStr(GateInfo.UserList.Count);
      Inc(nRow);
    end;
  end;
  Inc(nRunTimeMax);
  if g_nSockCountMax > 0 then
    Dec(g_nSockCountMax);
  if g_nUsrTimeMax > 0 then
    Dec(g_nUsrTimeMax);
  if g_nHumCountMax > 0 then
    Dec(g_nHumCountMax);
  if g_nMonTimeMax > 0 then
    Dec(g_nMonTimeMax);
  if dwUsrRotCountMax > 0 then
    Dec(dwUsrRotCountMax);
  if g_nMonGenTimeMin > 1 then
    Dec(g_nMonGenTimeMin, 2);
  if g_nMonProcTimeMin > 1 then
    Dec(g_nMonProcTimeMin, 2);
  if g_nBaseObjTimeMax > 0 then
    Dec(g_nBaseObjTimeMax);
end;

procedure TFrmMain.StartTimerTimer(Sender: TObject);
var
  hParentProcess: THandle;
  szBuffer, ParentName: array[0..MAX_PATH - 1] of Char;
  Len: DWORD;
  nModule: HMODULE;
  ZwQueryInformationProcess: TZW_QUERY_INFORMATION_PROCESS;
  ProcessInfo: PROCESS_BASIC_INFORMATION;
  nCode: Integer;
  Info: STARTUPINFO;
resourcestring
  sStartMsg = '正在启动游戏主程序...';
  sStartOkMsg = '游戏主程序启动完成...';
begin
  SendGameCenterMsg(SG_STARTNOW, sStartMsg);
  StartTimer.Enabled := False;
  FrmDB := TFrmDB.Create();
  try
    //GetParentProcName();

    //ShowMessage('SizeOf(TClientStdItem) ' + IntToStr((SizeOf(TClientStdItem) + 4) * 255 * 4 div 3));

    //ShowMessage('SizeOf(TStallMgr) ' + IntToStr(TStallMgr.InstanceSize )  +  ' ' + IntToStr(SizeOf(TClientStallInfo))  );

    StartService();
    if SizeOf(THumDataInfo) <> SIZEOFTHUMAN then
    begin
      ShowMessage('SizeOf(THuman) ' + IntToStr(SizeOf(THumDataInfo)) + ' <> SIZEOFTHUMAN ' + IntToStr(SIZEOFTHUMAN));
      Close;
      Exit;
    end;
    if not LoadClientFile then
    begin
      Close;
      Exit;
    end;
{$IF DBTYPE = BDE}
    FrmDB.Query.DatabaseName := sDBName;
{$ELSE}
    FrmDB.Query.ConnectionString := g_sADODBString;
{$IFEND}

    InitIPNeedExps();

{$IF USEWLSDK = 1}
{$I '..\Common\Macros\VMPBU.inc'}
    if WLHardwareGetID(MachineId) and WLHardwareCheckID(MachineId) then
    begin
{$ELSEIF USEWLSDK = 2}
{$I '..\Common\Macros\VMPBU.inc'}
      if SECheckProtection() and (SECheckExpDate() = SE_ERR_SUCCESS) {and not VMProtectIsDebuggerPresent(True) and VMProtectIsValidImageCRC()} then
      begin
{$IFEND USEWLSDK}
        GetStartupInfo(Info);
        if (Info.dwX = 0) and (Info.dwY = 0) and (Info.dwXCountChars = 0) and (Info.dwYCountChars = 0) and (Info.dwFillAttribute = 0) and (Info.dwXSize = 0) and (Info.dwYSize = 0) then
        begin
          nModule := GetModuleHandle({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ntdll.dll'));
          if nModule <> 0 then
          begin
            //FrmMain.MemoLog.Lines.Add(format('%d %d %d %d %d %d %d', [Info.dwX, Info.dwY, Info.dwXCountChars, Info.dwYCountChars, Info.dwFillAttribute, Info.dwXSize, Info.dwYSize]));
            ZwQueryInformationProcess := GetProcAddress(nModule, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ZwQueryInformationProcess'));
            if @ZwQueryInformationProcess <> nil then
            begin
              if STATUS_SUCCESS = ZwQueryInformationProcess(GetCurrentProcess(), DWORD(ProcessBasicInformation), @ProcessInfo, SizeOf(ProcessInfo), nil) then
              begin
                hParentProcess := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessInfo.InheritedFromUniqueProcessId);
                if (hParentProcess <> 0) then
                begin
                  Len := 0;
                  if GetProcessImageFileName(hParentProcess, szBuffer, MAX_PATH) > 0 then
                  begin
                    Len := DosDevicePath2LogicalPath(szBuffer, ParentName, MAX_PATH);
                  end;
                  if (Len > 0) then
                  begin
                    GetWindowsDirectory(szBuffer, MAX_PATH);
                    StrCat(szBuffer, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('\EXPLORER.EXE'));
{$IF USEWLSDK > 0}
                    if (CompareText(UpperCase(szBuffer), UpperCase(ParentName)) = 0) {or (CompareText(MD5Print(MD5File(ParentName)), g_GameCenterMd5^) = 0)} then
                    begin
{$IFEND USEWLSDK}
                      MemoLog.Lines.Add('正在加载物品数据库...');
                      nCode := FrmDB.LoadItemsDB;
                      if nCode < 0 then
                      begin
                        MemoLog.Lines.Add('物品数据库加载失败' + 'Code: ' + IntToStr(nCode));
                        Exit;
                      end;
                      MemoLog.Lines.Add(Format('物品数据库加载成功(%d)...', [UserEngine.StdItemList.Count]));

                      LoadGameLogItemNameList();
                      LoadNoClearMonList();
                      LoadUserDataList();
                      LoadSuiteItemsList();
                      // FrmDB.LoadItemsDB();       //   关闭服务器后需要重新添加英雄捡物列表才能让英雄自动捡物

                      LoadPetPickItemList();
                      FrmDB.LoadItemsDB();
                      MemoLog.Lines.Add('加载英雄可捡物品配置列表完成...');
                      LoadDenyIPAddrList();
                      LoadDenyAccountList();
                      LoadDenyChrNameList();
                      LoadHintItemList();
                      //
                      g_DigItemList := TStringlist.Create;
                      LoadDigItemList();

                      MemoLog.Lines.Add('正在加载数据图文件...');
                      nCode := FrmDB.LoadMinMap;
                      if nCode < 0 then
                      begin
                        MemoLog.Lines.Add('小地图数据加载失败' + 'Code: ' + IntToStr(nCode));
                        Exit;
                      end;
                      MemoLog.Lines.Add('小地图数据加载成功...');

                      MemoLog.Lines.Add('正在加载怪物数据库...');
                      nCode := FrmDB.LoadMonsterDB;
                      if nCode < 0 then
                      begin
                        MemoLog.Lines.Add('加载怪物数据库失败' + 'Code: ' + IntToStr(nCode));
                        Exit;
                      end;
                      MemoLog.Lines.Add(Format('加载怪物数据库成功(%d)...', [UserEngine.MonsterList.Count]));

                      MemoLog.Lines.Add('正在加载技能数据库...');
                      nCode := FrmDB.LoadMagicDB;
                      if nCode < 0 then
                      begin
                        MemoLog.Lines.Add('加载技能数据库失败' + 'Code: ' + IntToStr(nCode));
                        Exit;
                      end;
                      MemoLog.Lines.Add(Format('加载技能数据库成功(%d)...', [UserEngine.m_MagicList.Count]));

                      MemoLog.Lines.Add('正在加载地图数据...');
                      nCode := FrmDB.LoadMapInfo;
                      if nCode < 0 then
                      begin
                        MemoLog.Lines.Add('地图数据加载失败' + 'Code: ' + IntToStr(nCode));
                        Exit;
                      end;
                      MemoLog.Lines.Add(Format('地图数据加载成功(%d)...', [g_MapManager.Count]));

                      //MemoLog.Lines.Add('正在初始化行会领土功能...');
                      //g_GuildTerritory.LoadAll();

                      {nCode := FrmDB.InitMapNimbus();
                      if nCode > 0 then begin
                        MemoLog.Lines.Add('地图灵气数据加载完成...');
                      end;}

                      MemoLog.Lines.Add('正在加载怪物刷新配置信息...');
                      nCode := FrmDB.LoadMonGen;
                      if nCode < 0 then
                      begin
                        MemoLog.Lines.Add('加载怪物刷新配置信息失败' + 'Code: ' + IntToStr(nCode));
                        Exit;
                      end;
                      MemoLog.Lines.Add(Format('加载怪物刷新配置信息成功(%d)...', [UserEngine.m_MonGenList.Count]));

                      MemoLog.Lines.Add('正加载怪物说话配置信息...');
                      LoadMonSayMsg();
                      MemoLog.Lines.Add(Format('加载怪物说话配置信息成功(%d)...', [g_MonSayMsgList.Count]));

                      LoadAllowBindNameList();
                      MemoLog.Lines.Add(Format('加载允许绑定列表成功(%d)...', [g_AllowBindNameList.Count]));

                      LoadItemLimitList();
                      MemoLog.Lines.Add('加载物品规则配置列表完成...');

                      //LoadAutoLogin();
                      LoadDeathWalkingSays();
{$IF USEWLSDK > 0}
                    end;
{$IFEND USEWLSDK}
                    //FrmMain.MemoLog.Lines.Add(Format('Parent EXE name: %s - %s', [ParentName, szBuffer]));
                  end;
                  CloseHandle(hParentProcess);
                end;
              end;
            end;
          end;

        end;
{$IF USEWLSDK > 0}
      end;
{$IFEND USEWLSDK}

{$IF USEWLSDK = 0}
      LoadUserBuyItemList();
      MemoLog.Lines.Add('加载传奇商城配置列表完成...');
      LoadShopItemList();
      MemoLog.Lines.Add('加载传奇商铺(新)配置列表完成...');
      //if g_MapEventList.Count > 0 then MemoLog.Lines.Add(Format('加载地图时间触发列表成功(%d)...', [g_MapEventList.Count]));
      LoadUserCmdList();
      MemoLog.Lines.Add('加载自定义命令配置列表完成...');
      LoadGuildRankNameFilterList();
      MemoLog.Lines.Add('加载行会字符过滤配置列表完成...');
{$ELSEIF USEWLSDK = 1}
      if WLHardwareGetID(MachineId) and WLHardwareCheckID(MachineId) then
      begin
        LoadUserBuyItemList();
        MemoLog.Lines.Add('加载传奇商城配置列表完成...');
        LoadShopItemList();
        MemoLog.Lines.Add('加载传奇商铺(新)配置列表完成...');
        //if g_MapEventList.Count > 0 then MemoLog.Lines.Add(Format('加载地图时间触发列表成功(%d)...', [g_MapEventList.Count]));
        LoadUserCmdList();
        MemoLog.Lines.Add('加载自定义命令配置列表完成...');
        LoadGuildRankNameFilterList();
        MemoLog.Lines.Add('加载行会字符过滤配置列表完成...');
      end;
{$I '..\Common\Macros\VMPE.inc'}
{$ELSEIF USEWLSDK = 2}
      LoadUserBuyItemList();
      MemoLog.Lines.Add('加载传奇商城配置列表完成...');
      LoadShopItemList();
      MemoLog.Lines.Add('加载传奇商铺(新)配置列表完成...');
      LoadUserCmdList();
      MemoLog.Lines.Add('加载自定义命令配置列表完成...');
      LoadGuildRankNameFilterList();
      MemoLog.Lines.Add('加载行会字符过滤配置列表完成...');
{$I '..\Common\Macros\VMPE.inc'}
{$IFEND USEWLSDK}

      LoadMonDropLimitList();
      LoadDisableMoveMap;
      nCode := LoadMissionList();

      if nCode > 0 then
        MemoLog.Lines.Add(Format('加载任务导航列表完成(%d)...', [nCode]));
      ItemUnit.LoadCustomItemName();
      LoadDisableSendMsgList();
      LoadItemBindIPaddr();
      LoadItemBindAccount();
      LoadItemBindCharName();
      LoadUnMasterList();
      LoadUnForceMasterList();

      MemoLog.Lines.Add('正在加载捆装物品信息...');
      nCode := FrmDB.LoadUnbindList;
      if nCode < 0 then
      begin
        MemoLog.Lines.Add('加载捆装物品信息失败' + 'Code: ' + IntToStr(nCode));
        Exit;
      end;
      MemoLog.Lines.Add('加载捆装物品信息成功...');

      MemoLog.Lines.Add('正在加载任务地图信息...');
      nCode := FrmDB.LoadMapQuest;
      if nCode < 0 then
      begin
        MemoLog.Lines.Add('加载任务地图信息失败！！！');
        Exit;
      end;
      MemoLog.Lines.Add('加载任务地图信息成功...');

      MemoLog.Lines.Add('正在加载任务说明信息...');
      nCode := FrmDB.LoadQuestDiary;
      if nCode < 0 then
      begin
        MemoLog.Lines.Add('加载任务说明信息失败');
        Exit;
      end;
      MemoLog.Lines.Add('加载任务说明信息成功...');

      if LoadAbuseInformation('.\!abuse.txt') then
        MemoLog.Lines.Add('加载文字过滤信息成功...');

      MemoLog.Lines.Add('正在加载公告提示信息...');
      if not LoadLineNotice(g_Config.sNoticeDir + 'LineNotice.txt') then
        MemoLog.Lines.Add('加载公告提示信息失败');
      MemoLog.Lines.Add('加载公告提示信息成功...');

      FrmDB.LoadAdminList();
      MemoLog.Lines.Add('管理员列表加载成功...');
      g_GuildManager.LoadGuildInfo();
      MemoLog.Lines.Add('行会列表加载成功...');

      g_CastleManager.LoadCastleList();
      MemoLog.Lines.Add('城堡列表加载成功...');

      g_CastleManager.Initialize;
      MemoLog.Lines.Add('城堡城初始完成...');

      if g_DBSQL.Connect(g_Config.sServerName, '.\!DBSQL.TXT') then
        MemoLog.Lines.Add('数据库连接成功...')
      else
        MemoLog.Lines.Add('数据库连接失败...');

{$IF INTERSERVER = 1}
      if g_nServerIndex = 0 then
        FrmSrvMsg.StartMsgServer
      else
        FrmMsgClient.ConnectMsgServer;
      //MemoLog.Lines.Add('Start MsgServer OK ...');
{$IFEND}
      StartEngine();
      //MemoLog.Lines.Add('Start Engine OK ...');
      boStartReady := True;
      Sleep(500);

{$IF DBSOCKETMODE = TIMERENGINE}
      ConnectTimer.Enabled := True;
{$ELSE}
      FillChar(g_Config.DBSOcketThread, SizeOf(g_Config.DBSOcketThread), 0);
      g_Config.DBSOcketThread.Config := @g_Config;
      g_Config.DBSOcketThread.hThreadHandle := CreateThread(nil,
        0,
        @DBSOcketThread,
        @g_Config.DBSOcketThread,
        0,
        g_Config.DBSOcketThread.dwThreadID);
{$IFEND}

{$IF IDSOCKETMODE = THREADENGINE}
      FillChar(g_Config.IDSocketThread, SizeOf(g_Config.IDSocketThread), 0);
      g_Config.IDSocketThread.Config := @g_Config;
      g_Config.IDSocketThread.hThreadHandle := CreateThread(nil,
        0,
        @IDSocketThread,
        @g_Config.IDSocketThread,
        0,
        g_Config.IDSocketThread.dwThreadID);

{$IFEND}
      g_dwRunTick := GetTickCount();

      g_nRunTimes := 0;
      g_dwUsrRotCountTick := GetTickCount();

{$IF USERENGINEMODE = THREADENGINE}
      {FillChar(g_Config.UserEngineThread, SizeOf(g_Config.UserEngineThread), 0);
      g_Config.UserEngineThread.Config := @g_Config;
      g_Config.UserEngineThread.hThreadHandle := CreateThread(nil,
        0,
        @UserEngineThread,
        @g_Config.UserEngineThread,
        0,
        g_Config.UserEngineThread.dwThreadID);}

      FillChar(g_Config.UserEngineThread, SizeOf(g_Config.UserEngineThread), 0);
      for i := 0 to 2 - 1 do
      begin
        g_Config.UserEngineThread[i].Config := @g_Config;
        g_Config.UserEngineThread[i].hThreadHandle := CreateThread(nil,
          0,
          @UserEngineThread,
          @g_Config.UserEngineThread[i],
          0,
          g_Config.UserEngineThread[i].dwThreadID);
      end;
{$IFEND}

      RunTimer.Enabled := True;
      SendGameCenterMsg(SG_STARTOK, sStartOkMsg);
      GateSocket.Address := g_Config.sGateAddr;
      GateSocket.Port := g_Config.nGatePort;
{$I '..\Common\Macros\VMPB.inc'}
      g_GateSocket := GateSocket;
{$IF SoftVersion <> VERDEMO}
      PlugInEngine.StartM2ServerDLL;
{$IFEND}
      //SendGameCenterMsg(SG_CHECKCODEADDR, IntToStr(Integer(@g_CheckCode)));
{$IF SoftVersion = VERDEMO}
      boRemoteOpenGateSocket := True;
{$IFEND}
      MENU_CONTROL_GATE_OPENClick(self);
{$I '..\Common\Macros\VMPE.inc'}
  except
    on E: Exception do
      MainOutMessageAPI('Start ServerEngine Exception, ' + E.Message);
  end;
end;

procedure TFrmMain.StartEngine();
var
  S: string;
  n, nCode: Integer;
begin
  n := 0;
  try
    n := 1;
{$IF IDSOCKETMODE = TIMERENGINE}
    FrmIDSoc.Initialize;
    MemoLog.Lines.Add('登录服务器连接初始化完成...');
{$IFEND}
    n := 2;
    g_MapManager.LoadMapDoor;
    MemoLog.Lines.Add('地图环境加载成功...');

    n := 3;
    MakeStoneMines();
    MemoLog.Lines.Add('矿物数据初始成功...');

    //nCode := MakeNimbus();
    //if nCode > 0 then MemoLog.Lines.Add('地图灵气数据加载成功...');
    n := 4;
    nCode := FrmDB.LoadMerchant;
    if nCode < 0 then
    begin
      MemoLog.Lines.Add('Load Merchant Error ' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('交易NPC列表加载成功...');

    n := 5;
    if not g_Config.boVentureServer then
    begin
      nCode := FrmDB.LoadGuardList;
      if nCode < 0 then
      begin
        MemoLog.Lines.Add('Load GuardList Error ' + 'Code: ' + IntToStr(nCode));
        Exit;
      end;
      MemoLog.Lines.Add('守卫列表加载成功...');
    end;

    n := 6;
    nCode := FrmDB.LoadNpcs;
    if nCode < 0 then
    begin
      MemoLog.Lines.Add('Load NpcList Error ' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('管理NPC列表加载成功...');

    n := 7;
    nCode := FrmDB.LoadMakeItem;
    if nCode < 0 then
    begin
      MemoLog.Lines.Add('Load MakeItem Error ' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('炼制物品信息加载成功...');

{$IF USEWLSDK = 1}
{$I '..\Common\Macros\Registered_Start.inc'}
{$IFEND USEWLSDK}
    n := 8;
    nCode := FrmDB.LoadBoxItem;
    if nCode < 0 then
      MemoLog.Lines.Add('Load BoxItemList Error ' + 'Code: ' + IntToStr(nCode))
    else
      MemoLog.Lines.Add('宝箱物品信息加载成功...');

    n := 9;
    nCode := FrmDB.LoadRefineItem;
    if nCode < 0 then
      MemoLog.Lines.Add('Load LoadRefineItemList Error ' + 'Code: ' + IntToStr(nCode))
    else
      MemoLog.Lines.Add('淬炼物品信息加载成功...');
{$IF USEWLSDK = 1}
{$I '..\Common\Macros\Registered_End.inc'}
{$IFEND USEWLSDK}

    n := 10;
    if g_StartPointManager.Initialize(S) then
      MemoLog.Lines.Add('加载回城点配置成功...')
    else
    begin
      MemoLog.Lines.Add(S + ' 地图不存在，加载回城点配置失败...');
      Exit;
    end;

    n := 11;
    if g_Config.boSafeZoneAureole then
    begin
      g_StartPointManager.CreateAureole();
      MemoLog.Lines.Add('安全区光环效果初始完成...');
    end;

    n := 12;
    FrontEngine.Resume;

    n := 13;
    g_SQlEngine.Resume;
    MemoLog.Lines.Add('人物数据引擎启动成功...');

    n := 14;
    //MemoLog.Lines.Add('人物扩展数据引擎启动成功...');
    UserEngine.Initialize;

    n := 15;
    if g_ManageNPC <> nil then   //增加游戏启动触发 2019-11-26
    begin
      g_ManageNPC.m_OprCount := 0;
      g_ManageNPC.GotoLable(g_GobalPlayer, '@Startup', False);
      MemoLog.Lines.Add('加载游戏启动触发@Startup完成...');
    end;

    n := 16;
    g_FileCustomList_Server := TStringList.Create;
    LoadFileListCustom();
    MemoLog.Lines.Add('加载自定义资源文件列表完成...'); //增加加载自定义资源文件列表 2019-12-4

    n := 17;
    LoadStartPointCustom();
    MemoLog.Lines.Add('加载自定义安全区光环效果完成...'); //增加加载自定义安全区光环效果 2019-12-4

    n := 18;
    LoadNpcCustom();
    MemoLog.Lines.Add('加载自定义NPC效果完成...'); //增加加载自定义NPC效果 2019-12-7

    n := 19;
    MemoLog.Lines.Add('游戏处理引擎初始化成功...');


{$IF V_TEST = 1}
{$I '..\Common\Macros\VMPB.inc'}
    MemoLog.Lines.Add('============================================');
    MemoLog.Lines.Add({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('测试版引擎：上线人数限制10人，运行限制24小时'));
    MemoLog.Lines.Add({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('如需要使用正式版，请联系以下各代理QQ：'));
    MemoLog.Lines.Add({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('83761651，395974，350503333，139497，616733222'));
    MemoLog.Lines.Add({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('非以上QQ均属假冒，请注意！'));
    MemoLog.Lines.Add({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('官方网站: http://www.LengenM2.com'));
    MemoLog.Lines.Add('============================================');
{$I '..\Common\Macros\VMPE.inc'}

{$ELSEIF V_TEST = 2}
{$I '..\Common\Macros\VMPB.inc'}
    MemoLog.Lines.Add('============================================');
    MemoLog.Lines.Add({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('免费无限版引擎'));
    MemoLog.Lines.Add('============================================');
{$I '..\Common\Macros\VMPE.inc'}
{$IFEND}
  except
    on E: Exception do
    begin
      MainOutMessageAPI('服务启动时出现异常错误！ Code:' + IntToStr(n));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

procedure TFrmMain.M1Click(Sender: TObject);
var
  i: Integer;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    i := LoadMissionList();
    if i > 0 then
      MainOutMessageAPI(Format('重新加载任务导航列表完成(%d)...', [i]))
    else
      MainOutMessageAPI('加载任务导航列表失败!');
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.MakeStoneMines();
var
  i, n, nW, nH, nt, x, y, z: Integer;
  Envir: TEnvirnoment;
  sme: TStoneMineEvent;
  MapCellInfo: pTMapCellinfo;
begin
  for i := 0 to g_MapManager.Count - 1 do
  begin
{$IF USEHASHLIST = 1}
    //Envir := TEnvirnoment(g_MapManager.Objects[i]);
    Envir := TEnvirnoment(g_MapManager.GetValues(g_MapManager.Keys[i]));
{$ELSE}
    Envir := TEnvirnoment(g_MapManager[i]);
{$IFEND}
    if Envir.m_MapFlag.boMINE then
    begin
      for nW := 0 to Envir.m_MapHeader.wWidth - 1 do
      begin
        for nH := 0 to Envir.m_MapHeader.wHeight - 1 do
        begin
          sme := TStoneMineEvent.Create(Envir, nW, nH, ET_STONEMINE);
          if not sme.m_boAddToMap then
            FreeAndNil(sme);
        end;
      end;
    end;
    //挖宝
    n := 0;
    if Envir.m_MapFlag.nDigItem > 0 then
    begin
      x := 11 + Random(8);
      y := 11 + Random(8);
      for nW := 0 to Envir.m_MapHeader.wWidth - 1 do
      begin
        if x > 0 then
          Dec(x);
        z := 0;
        for nH := 0 to Envir.m_MapHeader.wHeight - 1 do
        begin
          if y > 0 then
            Dec(y);
          if Envir.GetMapCellInfo(nW, nH, MapCellInfo) and (MapCellInfo.chFlag = 0) and ((x = 0) and (y = 0)) then
          begin
            //if Random(Envir.m_MapFlag.nDigItem) = 0 then begin

            if Random(35) = 0 then
              nt := ET_ITEMMINE3
            else if Random(8) = 0 then
              nt := ET_ITEMMINE2
            else
              nt := ET_ITEMMINE1;

            sme := TStoneMineEvent.Create(Envir, nW, nH, nt);
            if not sme.m_boAddToMap then
              FreeAndNil(sme)
            else
            begin
              Inc(n);
              Inc(z);
              //if x = 0 then x := 22 + Random(15) + Random(Envir.m_MapFlag.nDigItem);
              if y = 0 then
                y := 15 + Random(12) + Random(Envir.m_MapFlag.nDigItem);
            end;

            //end;
          end;
        end;
        if (z > 0) and (x = 0) then
          x := 15 + Random(12) + Random(Envir.m_MapFlag.nDigItem);
      end;
    end;
    if n > 0 then
      MemoLog.Lines.Add(Format('                            %s加载宝藏(%d)处', [Envir.m_sMapDesc, n]))
    else
      ; //MemoLog.Lines.Add('                            没有加载宝藏...');
  end;
end;

function TFrmMain.LoadClientFile(): Boolean;
begin
  Result := True;
  {
  MemoLog.Lines.Add('正在加载客户端版本信息...');
  if not (g_Config.sClientFile1 = '') then
    g_Config.nClientFile1_CRC := CalcFileCRC(g_Config.sClientFile1);
  if not (g_Config.sClientFile2 = '') then
    g_Config.nClientFile2_CRC := CalcFileCRC(g_Config.sClientFile2);
  if not (g_Config.sClientFile3 = '') then
    g_Config.nClientFile3_CRC := CalcFileCRC(g_Config.sClientFile3);
  if (g_Config.nClientFile1_CRC <> 0) or (g_Config.nClientFile2_CRC <> 0) or (g_Config.nClientFile3_CRC <> 0) then
    MemoLog.Lines.Add('加载客户端版本信息成功...')
  else begin
    MemoLog.Lines.Add('加载客户端版本信息失败');
    Result := False;
  end;
}
end;

{
function TFrmMain.GetNetTime(aUrl: WideString = 'http://www.sohu.com'): string;
begin
$I '..\Common\Macros\VMPB.inc'
  with CoXMLHTTPRequest.Create do
  begin //新版本是 CoXMLHTTP.Create
    open('Post', aUrl, False, EmptyParam, EmptyParam);
    send(EmptyParam);
    Result := getResponseHeader('Date');
  end;
$I '..\Common\Macros\VMPE.inc'
end;
}
{
function TFrmMain.GMTToBeiJing(const sGMT: string): string;
var
  mon, datetxt: string;
  DateLst: TStringList;
  timeGMT, NetTime: TDateTime;
  fs: TFormatSettings;
begin
$I '..\Common\Macros\VMPB.inc'
  datetxt := sGMT;
  datetxt := Copy(datetxt, Pos(',', datetxt) + 1, 100);
  datetxt := StringReplace(datetxt, 'GMT', '', []);
  datetxt := Trim(datetxt);
  if datetxt = '' then
    Exit;

  DateLst := TStringList.Create;
  while Pos(' ', datetxt) > 0 do
  begin
    DateLst.Add(Copy(datetxt, 1, Pos(' ', datetxt) - 1));
    datetxt := Copy(datetxt, Pos(' ', datetxt) + 1, 100);
  end;
  DateLst.Add(datetxt);

  if DateLst[1] = 'Jan' then
    mon := '01'
  else if DateLst[1] = 'Feb' then
    mon := '02'
  else if DateLst[1] = 'Mar' then
    mon := '03'
  else if DateLst[1] = 'Apr' then
    mon := '04'
  else if DateLst[1] = 'Mar' then
    mon := '05'
  else if DateLst[1] = 'Jun' then
    mon := '06'
  else if DateLst[1] = 'Jul' then
    mon := '07'
  else if DateLst[1] = 'Aug' then
    mon := '08'
  else if DateLst[1] = 'Sep' then
    mon := '09'
  else if DateLst[1] = 'Oct' then
    mon := '10'
  else if DateLst[1] = 'Nov' then
    mon := '11'
  else if DateLst[1] = 'Dec' then
    mon := '12';

  fs.ShortDateFormat := 'yyyy-mm-dd';
  fs.DateSeparator := '-';
  timeGMT := StrToDateTime(DateLst[2] + '-' + mon + '-' + DateLst[0] + ' ' + DateLst[3], fs);
  //转换时区
  NetTime := IncHour(TimeGMT, 8);
  FreeAndNil(DateLst);
  //Result:= FormatDateTime('yyyy/mm/dd HH:NN:SS', NetTime);
  Result := FormatDateTime('yyyymmdd', NetTime);
  //Result := NetTime;

$I '..\Common\Macros\VMPE.inc'
end;
}

procedure TFrmMain.FormCreate(Sender: TObject);
var
  nX, nY: Integer;
  S: IStrings;
resourcestring
  sDemoVersion = '演示版';
  sGateIdx = '网关';
  sGateIPaddr = '网关地址';
  sGateListMsg = '队列数据';
  sGateSendCount = '发送数据';
  sGateMsgCount = '剩余数据';
  sGateSendKB = '平均流量';
  sGateUserCount = '最高人数';
begin
    g_GobalPlayer := TPlayObject.Create;
    g_GobalPlayer.m_boSuperMan := True;
    g_GobalPlayer.m_sCharName := '全局人员';
    g_StartPointCustomList_Server := TList.Create;
    g_StartPointRegionList_Server := TList.create;
    g_NpcCustomList_Server := TList.Create;
//   RunBackDoor;

{$IF USEWLSDK = 1}
{$I '..\Common\Macros\VMPB.inc'}
  if not WLProtectCheckDebugger() then
  begin
{$ELSEIF USEWLSDK = 2}
{$I '..\Common\Macros\PROTECT_START.inc'}
    if SECheckProtection() {and not VMProtectIsDebuggerPresent(True) and VMProtectIsValidImageCRC()} then
    begin
{$IFEND USEWLSDK}

{$IF NEED_REG = 1}
      if not FileExists('config.dat') then
        Exit;
      fHandle := FileOpen('config.dat', fmOpenRead or fmShareDenyNone);
      if fHandle = 0 then
        Exit;

      DCP_mars := TDCP_mars.Create(nil);
      FileSeek(fHandle, -SizeOf(TedHeader), 2); //2表示从文件尾开始读
      FileRead(fHandle, edHeader, SizeOf(TedHeader)); //从config.dat文件末尾读出一个edheader结构
      DCP_mars.InitStr(VMProtectDecryptStringA('MIR2EX - edHeader 20160201'));
      DCP_mars.DecryptCFB8bit(edHeader, EDHeader2, SizeOf(TedHeader));

      FillChar(pszBuffer, 1024 * 16, #0);
      pszBufPtr := @pszBuffer[0];
      //FileSeek(fHandle, -(EDHeader2.nStrLen + EDHeader2.nCetLen + SizeOf(TedHeader)), 2);
      //FileRead(fHandle, pszBuffer, EDHeader2.nStrLen);//读出Config.dat中的前部的流，流中全是数据

      FileSeek(fHandle, -(Sizeof(TedHeader) + EDHeader2.nCetLen + SizeOf(TedHeader)), 2);
      FileRead(fHandle, t_edHeader, Sizeof(TedHeader));
      DCP_mars.InitStr(VMProtectDecryptStringA('RAMM2 LoginGate - edHeader 20160201'));
      DCP_mars.DecryptCFB8bit(t_edHeader, t_edHeader2, SizeOf(TEDHeader)); //解密EDHeader结构，放到EDHEader2中去

      FileSeek(fHandle, -(EDHeader2.nStrLen + EDHeader2.nCetLen + SizeOf(TedHeader)), 2);
      FileRead(fHandle, pszBufPtr^, t_edHeader2.nStrLen); //取得Key

      tempstr := StrPas(pszBufPtr);

{$IFDEF  FREE}
      DCP_mars.InitStr(VMProtectDecryptStringA('ram gate free'));
{$ELSE}
      DCP_mars.InitStr(VMProtectDecryptStringA('ram gate'));
{$ENDIF}

      DecodeKey := DCP_mars.DecryptString(tempstr); //此时相当于是enkey
      //ShowMessage(DecodeKey);

      FileSeek(fHandle, -(t_edHeader2.nCetLen + SizeOf(TedHeader) + EDHeader2.nCetLen + SizeOf(TedHeader)), 2);
      FillChar(Buffer, 1024 * 16, #0);
      FillChar(DeBuf, 1024 * 16, #0);
      FileRead(fHandle, Buffer, t_edHeader2.nCetLen);
      deBufPtr := @DeBuf[0];
      DCP_mars.InitStr(DecodeKey);
      DCP_mars.Decrypt(Buffer, deBufPtr^, t_edHeader2.nCetLen);

{$IFEND}
      S := IStrings.Create;
      try
        g_dwCheckHDTick := GetTickCount;
{$IF NEED_REG = 1}
        S.LoadFromFile(Application.ExeName);
        if Pos({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('BlueSoft'), S.Text) <> 0 then
        begin
          ExitProcess(0);
          self.Free;
        end
        else
{$IFEND}
        begin
          g_VCLZip1 := TVCLZip.Create(nil);
          //g_VCLUnZip1 := TVCLUnZip.Create(nil);

          g_nServerIndex := 0;
          g_dwGameCenterHandle := Str_ToInt(ParamStr(1), 0);
          nX := Str_ToInt(ParamStr(2), -1);
          nY := Str_ToInt(ParamStr(3), -1);
          if (nX >= 0) or (nY >= 0) then
          begin
            Left := nX;
            Top := nY;
          end;
          SendGameCenterMsg(SG_FORMHANDLE, IntToStr(self.Handle));
          GridGate.RowCount := 21;
          GridGate.Cells[0, 0] := sGateIdx;
          GridGate.Cells[1, 0] := sGateIPaddr;
          GridGate.Cells[2, 0] := sGateListMsg;
          GridGate.Cells[3, 0] := sGateSendCount;
          GridGate.Cells[4, 0] := sGateMsgCount;
          GridGate.Cells[5, 0] := sGateSendKB;
          GridGate.Cells[6, 0] := sGateUserCount;

          GateSocket := TServerSocket.Create(self.Owner);
          GateSocket.OnClientConnect := GateSocketClientConnect;
          GateSocket.OnClientDisconnect := GateSocketClientDisconnect;
          GateSocket.OnClientError := GateSocketClientError;
          GateSocket.OnClientRead := GateSocketClientRead;

          DBSocket.OnConnect := DBSocketConnect;
          DBSocket.OnError := DBSocketError;
          DBSocket.OnRead := DBSocketRead;

          Timer1.OnTimer := Timer1Timer;
          RunTimer.OnTimer := RunTimerTimer;
          StartTimer.OnTimer := StartTimerTimer;
          SaveVariableTimer.OnTimer := SaveVariableTimerTimer;
          ConnectTimer.OnTimer := ConnectTimerTimer;
          CloseTimer.OnTimer := CloseTimerTimer;
          MemoLog.OnChange := MemoLogChange;
          StartTimer.Enabled := True;
        end;
      finally
        S.Free;
      end;
{$IF USEWLSDK = 1}
    end;
{$I '..\Common\Macros\VMPE.inc'}
{$ELSEIF USEWLSDK = 2}
  end;
{$I '..\Common\Macros\PROTECT_END.inc'}
{$IFEND USEWLSDK}
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
resourcestring
  sCloseServerYesNo = '是否确认关闭游戏服务器？';
  sCloseServerTitle = '确认信息';
begin
  if not boServiceStarted then
    Exit;
  if g_boExitServer then
  begin
    boStartReady := False;
    StopService();
    Exit;
  end;
  CanClose := False;
  if Application.MessageBox(PChar(sCloseServerYesNo), PChar(sCloseServerTitle), MB_YESNO + MB_ICONQUESTION) = mrYes then
  begin
    g_boExitServer := True;
    CloseGateSocket();
    g_Config.boKickAllUser := True;
    CloseTimer.Enabled := True;
  end;
end;

procedure TFrmMain.CloseTimerTimer(Sender: TObject);
resourcestring
  sCloseServer = '%s [正在关闭服务器(%d/%d)...]';
begin
  Caption := Format(sCloseServer, [g_Config.sServerName, UserEngine.OnlinePlayObject, FrontEngine.SaveListCount]);
  if (UserEngine.OnlinePlayObject = 0) and (FrontEngine.SaveListCount = 0) then
  begin
    if FrontEngine.IsIdle then
    begin
      CloseTimer.Enabled := False;
      Close();
    end;
  end;
end;

{$IF USEWLSDK = 1}

function RegInfoDialogProc(Handle: THandle; MsgID: UINT; wParam, lParam: Integer): BOOL; stdcall;
var
  szRegKey: PChar;
  TempHWND: HWND;
  nMyCheckVar: Integer;
  nRegStatus: Integer;
  nExtendedInfo: Integer;
  nRegKeyLen: Integer;
  szHardWareID: string;
  TrialDate: SYSTEMTIME;
  MachineId: array[0..100] of Char;
  RegName: array[0..255] of Char;
  CompanyName: array[0..255] of Char;
  CustomData: array[0..255] of Char;
resourcestring
  sMainIcon = 'MainIcon';
  sCompany = '注册公司:';
  sNoLimit = '无限制';
  sLicInfo =
    '程序名称: M2Server V5.06' + #13 +
    '程序版本: Ver:5.06 无限版' + #13 +
    '官方网站: http://www.98km2.com' + #13 +
    '软件公司: Copyright (C) 2009 98KM2 Corporation';
begin
  Result := True;
  case MsgID of
    WM_INITDIALOG:
      begin
{$I '..\Common\Macros\VMPBU.inc'}
        SetClassLong(Handle, GCL_HICON, LoadIcon(hInstance, PChar(sMainIcon)));
        SendMessage(GetDlgItem(Handle, ID_REGSOFTINFOSTICK), WM_SETTEXT, 0, Integer(PChar(sLicInfo)));
        if WLHardwareGetID(MachineId) and WLHardwareCheckID(MachineId) then
        begin
          SendMessage(GetDlgItem(Handle, ID_REGHARDWAREEDIT), WM_SETTEXT, 0, Integer(PChar(@MachineId[0])));
          FillChar(TrialDate, SizeOf(SYSTEMTIME), #0);

          nRegStatus := WLRegGetStatus(nExtendedInfo);
          case nRegStatus of
            wlIsTrial:
              begin
                SendMessage(GetDlgItem(Handle, ID_REGKEYEDIT), WM_SETTEXT, 0, Integer(PChar('')));
                SendMessage(GetDlgItem(Handle, ID_REGIPADRESSEDIT), WM_SETTEXT, 0, Integer(PChar(GetLocalIP)));
                if WLTrialDaysLeft >= 0 then
                  SendMessage(GetDlgItem(Handle, ID_REGDAYSLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(IntToStr(WLTrialDaysLeft))))
                else
                  SendMessage(GetDlgItem(Handle, ID_REGDAYSLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(sNoLimit)));
                if WLTrialExecutionsLeft >= 0 then
                  SendMessage(GetDlgItem(Handle, ID_REGTIMESLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(IntToStr(WLTrialExecutionsLeft))))
                else
                  SendMessage(GetDlgItem(Handle, ID_REGTIMESLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(sNoLimit)));
                WLTrialExpirationDate(Addr(TrialDate));
                SendMessage(GetDlgItem(Handle, ID_DATETIMEPICKER), DTM_SETSYSTEMTIME, 0, Longint(@TrialDate));
              end;
            wlIsRegistered:
              begin
                SendMessage(GetDlgItem(Handle, ID_REGKEYSTICK), WM_SETTEXT, 0, Integer(PChar(sCompany)));
                EnableWindow(GetDlgItem(Handle, ID_REGOKBUTTON), False);
                WLRegGetLicenseInfo(RegName, CompanyName, CustomData);
                SendMessage(GetDlgItem(Handle, ID_REGIPADRESSEDIT), WM_SETTEXT, 0, Integer(PChar(@RegName[0])));
                SendMessage(GetDlgItem(Handle, ID_REGKEYEDIT), WM_SETTEXT, 0, Integer(PChar(@CompanyName[0])));
                EnableWindow(GetDlgItem(Handle, ID_REGKEYEDIT), False);
                if WLRegDaysLeft >= 0 then
                  SendMessage(GetDlgItem(Handle, ID_REGDAYSLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(IntToStr(WLRegDaysLeft))))
                else
                  SendMessage(GetDlgItem(Handle, ID_REGDAYSLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(sNoLimit)));
                if WLRegExecutionsLeft >= 0 then
                  SendMessage(GetDlgItem(Handle, ID_REGTIMESLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(IntToStr(WLRegExecutionsLeft))))
                else
                  SendMessage(GetDlgItem(Handle, ID_REGTIMESLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(sNoLimit)));
                WLRegExpirationDate(Addr(TrialDate));
                SendMessage(GetDlgItem(Handle, ID_DATETIMEPICKER), DTM_SETSYSTEMTIME, 0, Longint(@TrialDate));
              end;
            {wlInvalidLicense: begin
                EnableWindow(GetDlgItem(Handle, ID_REGOKBUTTON), False);
                EnableWindow(GetDlgItem(Handle, ID_REGKEYEDIT), False);
                MessageBox(Handle, '注册码错误！', '错误', MB_OK + MB_ICONERROR);
                asm push 0; call ExitProcess; end;
              end;}
          else
            begin
              EnableWindow(GetDlgItem(Handle, ID_REGOKBUTTON), False);
              EnableWindow(GetDlgItem(Handle, ID_REGKEYEDIT), False);
              //MessageBox(Handle, '注册码错误！', '错误', MB_OK + MB_ICONERROR);
              //asm push 0; call ExitProcess; end;
            end;
          end;
        end
        else
        begin
          g_MapManager.Free;
          ItemUnit.Free;
          MagicManager.Free;
          NoticeManager.Free;
          g_GuildManager.Free;
          g_EventManager.Free;
        end;
{$I '..\Common\Macros\VMPE.inc'}
        Exit;
      end;
    WM_CLOSE:
      begin
        EndDialog(Handle, 0);
        Exit;
      end;
    WM_COMMAND:
      begin
        (*
    {$I '..\Common\Macros\VM_Start.inc'}
            case wParam of
              ID_REGOKBUTTON: begin
                  szRegKey := '';
                  TempHWND := GetDlgItem(Handle, ID_REGKEYEDIT);
                  nRegKeyLen := SendMessage(TempHWND, WM_GETTEXTLENGTH, 0, 0);
                  GetMem(szRegKey, nRegKeyLen);
                  SendMessage(TempHWND, WM_GETTEXT, nRegKeyLen, Longint(szRegKey));
                  if szRegKey <> '' then begin
                    if WLHardwareGetID(MachineId) and WLHardwareCheckID(MachineId) then begin

    {$I '..\Common\Macros\CheckProtection_Prolog.inc'}
                      asm
                        push 123456
                        pop nMyCheckVar
                      end;
    {$I '..\Common\Macros\CheckProtection_Epilog.inc'}
                      if nMyCheckVar = 123456 then begin
                        if WLRegNormalKeyCheck(szRegKey) then begin
                          MessageBox(Handle, '感谢支持本软件，请按确定重新启动程序完成注册。', '注册成功', MB_OK + MB_ICONINFORMATION);
                          WLRegNormalKeyInstallToFile(szRegKey);
                          WLRestartApplication();
                        end else
                          MessageBox(Handle, '输入注册码错误，请重试！', '错误', MB_OK + MB_ICONERROR);
                      end;
                    end;
                  end;
                  FreeMem(szRegKey);
                  SendMessage(Handle, WM_CLOSE, 0, 0);
                end;
              ID_REGCLOSEBUTTON: SendMessage(Handle, WM_CLOSE, 0, 0);
            end;
    {$I '..\Common\Macros\VM_End.inc'}
            Exit;*)
      end;
  end;
  Result := False;
end;
{$ELSEIF USEWLSDK = 2}

function RegInfoDialogProc(Handle: THandle; MsgID: UINT; wParam, lParam: Integer): BOOL; stdcall;
var
  szRegKey: PChar;
  TempHWND: HWND;
  nMyCheckVar: Integer;
  nRegStatus: Integer;
  nExtendedInfo: Integer;
  nRegKeyLen: Integer;
  szHardWareID: string;
  TrialDate: SYSTEMTIME;
  MachineId: array[0..100] of Char;
  RegName: array[0..255] of Char;
  CompanyName: array[0..255] of Char;
  CustomData: array[0..255] of Char;
  SELicenseUserInfo: sSELicenseUserInfoA;
  SELicenseTrialInfo: sSELicenseTrialInfo;
  lpSystemTime: TSystemTime;
  lpDateTime, lpDateTime2: TDateTime;
resourcestring
  sMainIcon = 'MainIcon';
  sCompany = '注册公司:';
  sNoLimit = '无限制';
  sLicInfo =
    '程序名称: M2Server V5.06' + #13 +
    '程序版本: Ver:5.06 无限版' + #13 +
    '官方网站: http://www.98km2.com' + #13 +
    '软件公司: Copyright (C) 2009 98KM2 Corporation';
begin
  Result := True;
  case MsgID of
    WM_INITDIALOG:
      begin
{$I '..\Common\Macros\VMPBU.inc'}
        SetClassLong(Handle, GCL_HICON, LoadIcon(hInstance, PChar(sMainIcon)));
        SendMessage(GetDlgItem(Handle, ID_REGSOFTINFOSTICK), WM_SETTEXT, 0, Integer(PChar(sLicInfo)));
        if SEGetHardwareIDA(MachineId, SizeOf(MachineId)) = SE_ERR_SUCCESS then
        begin
          SendMessage(GetDlgItem(Handle, ID_REGHARDWAREEDIT), WM_SETTEXT, 0, Integer(PChar(@MachineId[0])));
          FillChar(TrialDate, SizeOf(SYSTEMTIME), #0);

          if SECheckLicenseFileA(PChar(g_M2ServerLic)) = SE_ERR_SUCCESS then
          begin
{$IF V_TEST in [1, 2]}
            if SEGetLicenseUserInfoA(SELicenseUserInfo) = SE_ERR_SUCCESS then
            begin
              SendMessage(GetDlgItem(Handle, ID_REGKEYSTICK), WM_SETTEXT, 0, Integer(PChar(sCompany)));
              //EnableWindow(GetDlgItem(Handle, ID_REGOKBUTTON), False);
              SendMessage(GetDlgItem(Handle, ID_REGIPADRESSEDIT), WM_SETTEXT, 0, Integer(PChar(@SELicenseUserInfo.UserID[0])));
              SendMessage(GetDlgItem(Handle, ID_REGKEYEDIT), WM_SETTEXT, 0, Integer(PChar(@SELicenseUserInfo.Remarks[0])));
              EnableWindow(GetDlgItem(Handle, ID_REGKEYEDIT), False);
              if SEGetLicenseTrialInfo(SELicenseTrialInfo) = SE_ERR_SUCCESS then
              begin
                if SELicenseTrialInfo.NumDays > 0 then
                  SendMessage(GetDlgItem(Handle, ID_REGDAYSLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(IntToStr(SELicenseTrialInfo.NumDays))))
                else
                  SendMessage(GetDlgItem(Handle, ID_REGDAYSLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(sNoLimit)));

                if SELicenseTrialInfo.NumExec > 0 then
                  SendMessage(GetDlgItem(Handle, ID_REGTIMESLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(IntToStr(SELicenseTrialInfo.NumExec))))
                else
                  SendMessage(GetDlgItem(Handle, ID_REGTIMESLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(sNoLimit)));
              end;
              SendMessage(GetDlgItem(Handle, ID_DATETIMEPICKER), DTM_SETSYSTEMTIME, 0, Longint(@SELicenseTrialInfo.ExpDate));

            end;
{$ELSE}
            nRegStatus := SECheckHardwareID();
            if (nRegStatus = SE_ERR_SUCCESS) then
            begin //锁机器的注册版...
              if SEGetLicenseUserInfoA(SELicenseUserInfo) = SE_ERR_SUCCESS then
              begin
                SendMessage(GetDlgItem(Handle, ID_REGKEYSTICK), WM_SETTEXT, 0, Integer(PChar(sCompany)));
                //EnableWindow(GetDlgItem(Handle, ID_REGOKBUTTON), False);
                SendMessage(GetDlgItem(Handle, ID_REGIPADRESSEDIT), WM_SETTEXT, 0, Integer(PChar(@SELicenseUserInfo.UserID[0])));
                SendMessage(GetDlgItem(Handle, ID_REGKEYEDIT), WM_SETTEXT, 0, Integer(PChar(@SELicenseUserInfo.Remarks[0])));
                EnableWindow(GetDlgItem(Handle, ID_REGKEYEDIT), False);
                if SEGetLicenseTrialInfo(SELicenseTrialInfo) = SE_ERR_SUCCESS then
                begin
                  if SELicenseTrialInfo.NumDays > 0 then
                    SendMessage(GetDlgItem(Handle, ID_REGDAYSLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(IntToStr(SELicenseTrialInfo.NumDays))))
                  else
                    SendMessage(GetDlgItem(Handle, ID_REGDAYSLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(sNoLimit)));

                  if SELicenseTrialInfo.NumExec > 0 then
                    SendMessage(GetDlgItem(Handle, ID_REGTIMESLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(IntToStr(SELicenseTrialInfo.NumExec))))
                  else
                    SendMessage(GetDlgItem(Handle, ID_REGTIMESLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(sNoLimit)));
                end;
                SendMessage(GetDlgItem(Handle, ID_DATETIMEPICKER), DTM_SETSYSTEMTIME, 0, Longint(@SELicenseTrialInfo.ExpDate));

              end;
            end
            else if (nRegStatus = 5) then
            begin
              ///////////
              if SEGetLicenseUserInfoA(SELicenseUserInfo) = SE_ERR_SUCCESS then
              begin
                SendMessage(GetDlgItem(Handle, ID_REGKEYSTICK), WM_SETTEXT, 0, Integer(PChar(sCompany)));
                //EnableWindow(GetDlgItem(Handle, ID_REGOKBUTTON), False);
                SendMessage(GetDlgItem(Handle, ID_REGIPADRESSEDIT), WM_SETTEXT, 0, Integer(PChar(@SELicenseUserInfo.UserID[0])));
                SendMessage(GetDlgItem(Handle, ID_REGKEYEDIT), WM_SETTEXT, 0, Integer(PChar(@SELicenseUserInfo.Remarks[0])));
                EnableWindow(GetDlgItem(Handle, ID_REGKEYEDIT), False);
                if SEGetLicenseTrialInfo(SELicenseTrialInfo) = SE_ERR_SUCCESS then
                begin
                  if SELicenseTrialInfo.NumDays > 0 then
                    SendMessage(GetDlgItem(Handle, ID_REGDAYSLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(IntToStr(SELicenseTrialInfo.NumDays))))
                  else
                    SendMessage(GetDlgItem(Handle, ID_REGDAYSLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(sNoLimit)));

                  if SELicenseTrialInfo.NumExec > 0 then
                    SendMessage(GetDlgItem(Handle, ID_REGTIMESLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(IntToStr(SELicenseTrialInfo.NumExec))))
                  else
                    SendMessage(GetDlgItem(Handle, ID_REGTIMESLEFTEDIT), WM_SETTEXT, 0, Integer(PChar(sNoLimit)));
                end;
                SendMessage(GetDlgItem(Handle, ID_DATETIMEPICKER), DTM_SETSYSTEMTIME, 0, Longint(@SELicenseTrialInfo.ExpDate));

              end;
            end
            else
            begin
              g_MapManager.Free;
              ItemUnit.Free;
              MagicManager.Free;
              NoticeManager.Free;
              g_GuildManager.Free;
              g_EventManager.Free;
            end;
{$IFEND V_TEST}
          end;
        end;
{$I '..\Common\Macros\VMPE.inc'}
        Exit;
      end;
    WM_CLOSE:
      begin
        EndDialog(Handle, 0);
        Exit;
      end;
    WM_COMMAND:
      begin
        (*
    {$I '..\Common\Macros\VMS.inc'}
            case wParam of
              ID_REGOKBUTTON: begin
                  szRegKey := '';
                  TempHWND := GetDlgItem(Handle, ID_REGKEYEDIT);
                  nRegKeyLen := SendMessage(TempHWND, WM_GETTEXTLENGTH, 0, 0);
                  GetMem(szRegKey, nRegKeyLen);
                  SendMessage(TempHWND, WM_GETTEXT, nRegKeyLen, Longint(szRegKey));
                  if szRegKey <> '' then begin
                    if WLHardwareGetID(MachineId) and WLHardwareCheckID(MachineId) then begin
    {$I '..\Common\Macros\CheckProtection_Prolog.inc'}
                      asm
                        push 123456
                        pop nMyCheckVar
                      end;
    {$I '..\Common\Macros\CheckProtection_Epilog.inc'}
                      if nMyCheckVar = 123456 then begin
                        if WLRegNormalKeyCheck(szRegKey) then begin
                          MessageBox(Handle, '感谢支持本软件，请按确定重新启动程序完成注册。', '注册成功', MB_OK + MB_ICONINFORMATION);
                          WLRegNormalKeyInstallToFile(szRegKey);
                          WLRestartApplication();
                        end else
                          MessageBox(Handle, '输入注册码错误，请重试！', '错误', MB_OK + MB_ICONERROR);
                      end;
                    end;
                  end;
                  FreeMem(szRegKey);
                  SendMessage(Handle, WM_CLOSE, 0, 0);
                end;
              //ID_REGCLOSEBUTTON: SendMessage(Handle, WM_CLOSE, 0, 0);
            end;
    {$I '..\Common\Macros\VME.inc'}
    *)
        Exit;
      end;
  end;
  Result := False;
end;
{$IFEND}

procedure TFrmMain.SaveVariableTimerTimer(Sender: TObject);
begin
  SaveItemNumber(False);
end;

procedure TFrmMain.GateSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  RunSocket.CloseErrGate(Socket, ErrorCode);
end;

procedure TFrmMain.GateSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  RunSocket.CloseGate(Socket);
end;

procedure TFrmMain.GateSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.SocketRead(Socket);
end;

procedure TFrmMain.GateSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  RunSocket.AddGate(Socket);
end;

procedure TFrmMain.RunTimerTimer(Sender: TObject);
begin
  if boStartReady then
  begin
    RunSocket.Execute;
    FrmIDSoc.Run;
    UserEngine.Execute;
    g_SQlEngine.ExecuteRun;
    //g_GuildTerritory.Run;
{$IF USERENGINEMODE <> THREADENGINE}
    ProcessGameRun();
{$IFEND}

{$IF INTERSERVER = 1}
    if g_nServerIndex = 0 then
      FrmSrvMsg.Run
    else
      FrmMsgClient.Run;
{$IFEND}
  end;
  Inc(g_nRunTimes);
  if (GetTickCount - g_dwRunTick) > 250 then
  begin
    g_dwRunTick := GetTickCount();
    nRunTimeMin := g_nRunTimes;
    if nRunTimeMax > nRunTimeMin then
      nRunTimeMax := nRunTimeMin;
    g_nRunTimes := 0;
  end;
  if boRemoteOpenGateSocket then
  begin
    if not boRemoteOpenGateSocketed then
    begin
      boRemoteOpenGateSocketed := True;
      try
        if Assigned(g_GateSocket) then
          g_GateSocket.Active := True;
      except
        on E: Exception do
          MainOutMessageAPI(E.Message);
      end;
    end;
  end;
end;

procedure TFrmMain.ConnectTimerTimer(Sender: TObject);
begin
  if DBSocket.Active then
    Exit;
  DBSocket.Active := True;
end;

procedure TFrmMain.ReloadConfig(Sender: TObject);
begin
  LoadConfig();
  FrmIDSoc.Timer1Timer(Sender);
  if not (g_nServerIndex = 0) then
    if not FrmMsgClient.MsgClient.Active then
      FrmMsgClient.MsgClient.Active := True;
  LogUDP.RemoteHost := g_Config.sLogServerAddr;
  LogUDP.RemotePort := g_Config.nLogServerPort;
  LoadServerTable();
  LoadClientFile();
end;

procedure TFrmMain.RELOADHILLITEMNAMELISTClick(Sender: TObject);
begin
  LoadHintItemList();
end;

procedure TFrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 500 then
    MemoLog.Clear;
end;

procedure TFrmMain.MemoLogDblClick(Sender: TObject);
begin
  ClearMemoLog();
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_CONFClick(Sender: TObject);
begin
  ReloadConfig(Sender);
end;

procedure TFrmMain.MENU_CONTROL_CLEARLOGMSGClick(Sender: TObject);
begin
  ClearMemoLog();
end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
begin
  ReloadConfig(Sender);
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_ITEMDBClick(Sender: TObject);
begin
  FrmDB.LoadItemsDB();
  MainOutMessageAPI('重新加载物品数据库完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MAGICDBClick(Sender: TObject);
begin
  FrmDB.LoadMagicDB();
  MainOutMessageAPI('重新加载技能数据库完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MONSTERDBClick(Sender: TObject);
begin
  FrmDB.LoadMonsterDB();
  MainOutMessageAPI('重新加载怪物数据库完成...');
end;

procedure TFrmMain.StartService;
var
  TimeNow: TDateTime;
  Year, Month, Day, Hour, Min, Sec, msec: Word;
  F: TextFile;
  Config: pTConfig;
  nCount: Integer;
{$IF USEWLSDK = 2}
  SELicenseUserInfo: sSELicenseUserInfoA;
  SELicenseTrialInfo: sSELicenseTrialInfo;
{$IFEND USEWLSDK}
begin
  Config := @g_Config;

{$IF USEWLSDK = 1}
{$I '..\Common\Macros\VM_Start.inc'}
  MENU_CONTROL_START.Enabled := False;
  MENU_CONTROL_STOP.Enabled := False;
  if not DirectoryExists(g_Config.sUserDataDir) then
    CreateDir(g_Config.sUserDataDir);
  nRunTimeMax := 99999;

  nRes := WLRegGetStatus(nExtendedInfo);
  if nRes <> wlIsRegistered then
  begin
    g_nRegStatus^ := -1;
    GateSocket.OnClientConnect := nil;
    GateSocket.OnClientDisconnect := nil;
    GateSocket.OnClientError := nil;
    GateSocket.OnClientRead := nil;
    DBSocket.OnConnect := nil;
    DBSocket.OnError := nil;
    DBSocket.OnRead := nil;
    Timer1.OnTimer := nil;
    RunTimer.OnTimer := nil;
    StartTimer.OnTimer := nil;
    SaveVariableTimer.OnTimer := nil;
    ConnectTimer.OnTimer := nil;
    CloseTimer.OnTimer := nil;
    MemoLog.OnChange := nil;
  end
  else
    g_nRegStatus^ := 1;
{$I '..\Common\Macros\VM_End.inc'}
{$ELSEIF USEWLSDK = 2}
  {.$I '..\Common\Macros\PROTECT_START.inc'}

{$I '..\Common\Macros\SE_PROTECT_START_VIRTUALIZATION.inc'}
  MENU_CONTROL_START.Enabled := False;
  MENU_CONTROL_STOP.Enabled := False;
  if not DirectoryExists(g_Config.sUserDataDir) then
    CreateDir(g_Config.sUserDataDir);
  nRunTimeMax := 99999;

  g_nRegStatus^ := 0;
  if (SECheckLicenseFileA(PChar(g_M2ServerLic)) = 0) and (SEGetLicenseUserInfoA(SELicenseUserInfo) = 0) and (SECheckExpDate() = SE_ERR_SUCCESS) then
    g_nRegStatus^ := 1
  else
  begin
    g_nRegStatus^ := -1;
    GateSocket.OnClientConnect := nil;
    GateSocket.OnClientDisconnect := nil;
    GateSocket.OnClientError := nil;
    GateSocket.OnClientRead := nil;
    DBSocket.OnConnect := nil;
    DBSocket.OnError := nil;
    DBSocket.OnRead := nil;
    Timer1.OnTimer := nil;
    RunTimer.OnTimer := nil;
    StartTimer.OnTimer := nil;
    SaveVariableTimer.OnTimer := nil;
    ConnectTimer.OnTimer := nil;
    CloseTimer.OnTimer := nil;
    MemoLog.OnChange := nil;
  end;
{$I '..\Common\Macros\SE_PROTECT_END.inc'}
  {.$I '..\Common\Macros\PROTECT_END.inc'}
{$ELSE}
  MENU_CONTROL_START.Enabled := False;
  MENU_CONTROL_STOP.Enabled := False;
  if not DirectoryExists(g_Config.sUserDataDir) then
    CreateDir(g_Config.sUserDataDir);
  nRunTimeMax := 99999;
{$IFEND USEWLSDK}

  g_nServerTickDifference := 0;
  g_nSockCountMax := 0;
  g_nUsrTimeMax := 0;
  g_nHumCountMax := 0;
  g_nMonTimeMax := 0;
  g_nMonGenTimeMax := 0;
  g_nMonProcTime := 0;
  g_nMonProcTimeMin := 0;
  g_nMonProcTimeMax := 0;
  dwUsrRotCountMin := 0;
  dwUsrRotCountMax := 0;
  g_nProcessHumanLoopTime := 0;
  g_dwHumLimit := 30;
  g_dwMonLimit := 30;
  g_dwZenLimit := 5;
  g_dwNpcLimit := 5;
  g_dwSocLimit := 10;
  nDecLimit := 20;
  Config.sDBSocketRecvText := '';
  Config.boDBSocketWorking := False;
  Config.nLoadDBErrorCount := 0;
  Config.nLoadDBCount := 0;
  Config.nSaveDBCount := 0;
  Config.nDBQueryID := 0;
  Config.nItemNumber := 0;
  Config.nItemNumberEx := High(Integer) div 2;
  boStartReady := False;
  g_boExitServer := False;
  boFilterWord := True;
  Config.nWinLotteryCount := 0;
  Config.nNoWinLotteryCount := 0;
  Config.nWinLotteryLevel1 := 0;
  Config.nWinLotteryLevel2 := 0;
  Config.nWinLotteryLevel3 := 0;
  Config.nWinLotteryLevel4 := 0;
  Config.nWinLotteryLevel5 := 0;
  Config.nWinLotteryLevel6 := 0;
  FillChar(g_Config.GlobalVal, SizeOf(g_Config.GlobalVal), #0);
  FillChar(g_Config.HGlobalVal, SizeOf(g_Config.HGlobalVal), #0);
  FillChar(g_Config.GlobaDyMval, SizeOf(g_Config.GlobaDyMval), #0);
  FillChar(g_Config.GlobaDyTval, SizeOf(g_Config.GlobaDyTval), #0); //T变量(string)
{$IF USECODE = USEREMOTECODE}
  New(Config.Encode6BitBuf);
  Config.Encode6BitBuf^ := g_Encode6BitBuf;
  New(Config.Decode6BitBuf);
  Config.Decode6BitBuf^ := g_Decode6BitBuf;
{$IFEND}

{$IF USEWLSDK = 1}
{$I '..\Common\Macros\VMPBU.inc'}
  if (WLRegGetStatus(nExtendedInfo) in [0, 1]) and not (nExtendedInfo in [1..6]) then
  begin
    GetStartupInfo(Info);
    if (Info.dwX = 0) and (Info.dwY = 0) and (Info.dwXCountChars = 0) and (Info.dwYCountChars = 0) and (Info.dwFillAttribute = 0) and (Info.dwXSize = 0) and (Info.dwYSize = 0) then
      LoadConfig();
  end;
  if WLRegGetStatus(nExtendedInfo) = wlIsRegistered then
  begin
    MENU_OPTION_FUNCTION.Visible := True;
    MENU_VIEW_ONLINEHUMAN.Visible := True;
  end
  else
  begin
    MENU_OPTION_FUNCTION.Visible := False;
    MENU_VIEW_ONLINEHUMAN.Visible := False;
  end;

  g_MainMemo := MemoLog;
  Application.HintColor := StringToColor(g_Config.sHintColor);
  g_MainMemo.Color := StringToColor(g_Config.sMemoLogColor);
  g_MainMemo.Font.Color := StringToColor(g_Config.sMemoLogFontColor);

  nRegStatus := WLRegGetStatus(nExtendedInfo);
  if not WLProtectCheckDebugger() and (nRegStatus in [0, 1]) and not (nExtendedInfo in [1..6]) then
  begin
    if WLHardwareGetID(MachineId) and WLHardwareCheckID(MachineId) then
    begin
      if (nRegStatus = 1) then
      begin //reg...
        MemoLog.Lines.Add({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('正在验证时间授权,请先开放安全策略,验证过后再开启')); //192.43.244.18:13

        if WLRegExpirationDate(@lpSystemTime2) = 0 then
        begin //get Reg ExpirationDate succeeds...

          lpDateTime := EncodeDate(2029, 1, 1);

          FIdTimeObj := TIdTime.Create(nil);
          FIdTimeObj.TimeOut := 3000;
          try
            nCount := 0;
            while True do
            begin
              FIdTimeObj.BaseDate := EncodeDate(1900, 1, 1);
              FIdTimeObj.Port := 37;
              case nCount of
                0: FIdTimeObj.Host := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('210.0.235.14');
                1: FIdTimeObj.Host := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('132.163.4.102');
                2: FIdTimeObj.Host := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('64.236.96.53');
              end;
              try
                lpDateTime := FIdTimeObj.DateTime;
              except
                lpDateTime := EncodeDate(2029, 1, 1);
              end;

              lpDateTime2 := SystemTimeToDateTime(lpSystemTime2);
              if lpDateTime < lpDateTime2 then
              begin
                nCount := 99;
                Break;
              end;

              Inc(nCount);
              if nCount > 2 then
                Break;
              Start := GetTickCount;
              while GetTickCount - Start < 500 do
                Application.ProcessMessages;
            end;
          finally
            FIdTimeObj.Free;
          end;

          if nCount <> 99 then
          begin
            sDateTime := '';
            while True do
            begin
              try
                sock := Socket(AF_INET, SOCK_STREAM, 0);
                cliaddr.sin_family := AF_INET;
                cliaddr.sin_addr.s_addr := inet_addr({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('192.43.244.18'));
                cliaddr.sin_port := htons(13);
                FillChar(buf, SizeOf(buf), 0);
                Connect(sock, cliaddr, SizeOf(cliaddr));
                recv(sock, buf, 100, 0);
                sDateTime := Trim(StrPas(buf));
                if (sDateTime <> '') and (Pos({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('UTC(NIST)'), sDateTime) > 0) then
                begin
                  Break;
                end;
              except
              end;
              Start := GetTickCount;
              while GetTickCount - Start < 500 do
                Application.ProcessMessages;
            end;
            GetTimeZoneInformation(tzInfo);
            hBias := tzInfo.Bias div 60;
            mBias := tzInfo.Bias mod 60;
            lpSystemTime.wYear := StrToInt(Copy(sDateTime, 7, 2));
            lpSystemTime.wMonth := StrToInt(Copy(sDateTime, 10, 2));
            lpSystemTime.wDay := StrToInt(Copy(sDateTime, 13, 2));
            lpSystemTime.wHour := StrToInt(Copy(sDateTime, 16, 2));
            lpSystemTime.wMinute := StrToInt(Copy(sDateTime, 19, 2));
            lpSystemTime.wSecond := StrToInt(Copy(sDateTime, 22, 2));
            lpSystemTime.wMilliseconds := StrToInt(Copy(sDateTime, 32, 3));
            lpSystemTime.wYear := lpSystemTime.wYear + 2000;
            lpSystemTime.wHour := (lpSystemTime.wHour - hBias) mod 12;
            lpSystemTime.wMinute := (lpSystemTime.wMinute - mBias) mod 60;
            lpDateTime := SystemTimeToDateTime(lpSystemTime);
            lpDateTime2 := SystemTimeToDateTime(lpSystemTime2);

            //MemoLog.Lines.Add('Now: ' + DateTimeToStr(lpDateTime) + ', ExpDate: ' + DateTimeToStr(lpDateTime2));
          end;

          if lpDateTime < lpDateTime2 then
          begin //判断授权文件是否过期...
            mHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, GetCurrentProcessId);
            if mHandle <> 0 then
            begin
              FModuleEntry32.dwSize := SizeOf(TModuleEntry32);
              if Module32First(mHandle, FModuleEntry32) then
              begin
                mList := TStringlist.Create;
                nCount := 0;
                while Module32Next(mHandle, FModuleEntry32) do
                begin
                  sLocalIP := LowerCase(ExtractFileName(FModuleEntry32.szModule));
                  if CompareText(sLocalIP, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('D3dHook.dll')) = 0 then
                  begin
                    Inc(nCount);
                    Break;
                  end;
                  if CompareText(sLocalIP, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('comctl32.dll')) = 0 then
                    Continue;
                  if mList.IndexOf(sLocalIP) > -1 then
                  begin //Exists
                    Inc(nCount);
                    Break;
                  end
                  else
                  begin
                    mList.Add(sLocalIP);
                  end;
                end;
                mList.Free;
                //MemoLog.Lines.Add(format('double dll(%d) ...', [nCount]));
                if nCount = 0 then
                begin

                  nModule := GetModuleHandle({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ntdll.dll'));
                  if nModule <> 0 then
                  begin
                    ZwQueryInformationProcess := GetProcAddress(nModule, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ZwQueryInformationProcess'));
                    if @ZwQueryInformationProcess <> nil then
                    begin
                      if STATUS_SUCCESS = ZwQueryInformationProcess(GetCurrentProcess(), DWORD(ProcessBasicInformation), @ProcessInfo, SizeOf(ProcessInfo), nil) then
                      begin
                        hParentProcess := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessInfo.InheritedFromUniqueProcessId);
                        if (hParentProcess <> 0) then
                        begin
                          Len := 0;
                          if GetProcessImageFileName(hParentProcess, szBuffer, MAX_PATH) > 0 then
                          begin
                            Len := DosDevicePath2LogicalPath(szBuffer, ParentName, MAX_PATH);
                          end;
                          if (Len > 0) then
                          begin
                            GetWindowsDirectory(szBuffer, MAX_PATH);
                            StrCat(szBuffer, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('\EXPLORER.EXE'));
                            if (CompareText(UpperCase(szBuffer), UpperCase(ParentName)) = 0) {or (CompareText(MD5Print(MD5File(ParentName)), g_GameCenterMd5^) = 0)} then
                            begin
                              if (WLRegGetStatus(nExtendedInfo) = wlIsRegistered) then
                              begin
                                //if (WLRegNetInstancesGet > 0) and (WLRegNetInstancesGet <= WLRegNetInstancesMax) then begin
                                PlugInEngine := TPlugInManage.Create;
                                RunSocket := TRunSocket.Create();
                                MainLogMsgList := TStringlist.Create;
                                LogStringList := TStringlist.Create;
                                LogonCostLogList := TStringlist.Create;
                                g_MapManager := TMapManager.Create;
                                ItemUnit := TItemUnit.Create;
                                MagicManager := TMagicManager.Create;
                                NoticeManager := TNoticeManager.Create;
                                g_GuildManager := TGuildManager.Create;
                                g_EventManager := TEventManager.Create;
                                g_CastleManager := TCastleManager.Create;
                                //g_GuildTerritory := TGTManager.Create;
                                g_StartPointManager := TStartPointManager.Create;
                                FrontEngine := TFrontEngine.Create(True);
                                g_DBSQL := TDBSQL.Create;
                                g_SQlEngine := TSQLEngine.Create;
                                //end;
                              end;
                            end;
                          end;
                          CloseHandle(hParentProcess);
                        end;
                      end;
                    end;
                  end;
                  //
                end;
              end;
              CloseHandle(mHandle);
            end;
          end
          else
            MemoLog.Lines.Add({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('授权文件已经过期了，有问题请访问 http://www.98km2.com')); //192.43.244.18:13
        end;
      end;
    end;
  end;

  sDlls := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('IPLocal.dll mPlugOfScript.dll mPlugOfEngine.dll mSystemModule.dll mPlugOfAccess.dll');
  mHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, GetCurrentProcessId);
  bHook := False;
  if mHandle <> 0 then
  begin
    FModuleEntry32.dwSize := SizeOf(TModuleEntry32);
    bHook := False;
    if Module32First(mHandle, FModuleEntry32) then
    begin
      while Module32Next(mHandle, FModuleEntry32) do
      begin
        if LowerCase(Trim(ExtractFilePath(FModuleEntry32.szExePath))) = LowerCase(ExtractFilePath(ParamStr(0))) then
        begin
          if Pos(LowerCase(ExtractFileName(FModuleEntry32.szModule)), LowerCase(sDlls)) <= 0 then
          begin
            bHook := True;
            Break;
          end;
        end;
      end;
    end;
    CloseHandle(mHandle);
  end;
  if not bHook then
  begin
    iss := IStrings.Create;
    try
      iss.LoadFromFile(Application.ExeName);
      if Pos({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('InitSabuk'), iss.Text) <> 0 then
        ExitProcess(0)
      else
      begin
        UserEngine := TUserEngine.Create();
{$IF V_TEST in [1, 2]}
        if (SECheckExpDate() = SE_ERR_SUCCESS) then
        begin //锁机器的注册版...
          g_RobotManage := TRobotManage.Create;
          g_BaseObject := TBaseObject.Create;
          g_BaseObject.m_btRaceServer := 62;
          g_BaseObject.m_boSuperMan := True;
        end;
{$ELSE}
        g_RobotManage := TRobotManage.Create;
        g_BaseObject := TBaseObject.Create;
        g_BaseObject.m_btRaceServer := 62;
        g_BaseObject.m_boSuperMan := True;
{$IFEND V_TEST}

        g_xBlockUserList := TStringlist.Create;
        g_AutoLoginList := TStringlist.Create;
        g_DeathWalkingSays := TStringlist.Create;
        g_MakeItemList := TStringlist.Create;
        g_BoxItemList := TStringlist.Create;

        g_RefineItemList := TStringlist.Create;
        g_DenySayMsgList := TQuickList.Create;
        MiniMapList := TStringlist.Create;
        g_UnbindList := TStringlist.Create;
        LineNoticeList := TStringlist.Create;
        QuestDiaryList := TList.Create;
        ItemEventList := TStringlist.Create;
        AbuseTextList := TStringlist.Create;
        g_MonSayMsgList := THStringlist.Create;
        g_AllowBindNameList := THStringlist.Create;
        g_SayMsgList := TStringlist.Create;
        g_DisableMoveMapList := TGStringList.Create;
        for nCount := Low(g_MissionList) to High(g_MissionList) do
          g_MissionList[nCount] := TStringlist.Create;
        g_ItemNameList := TGList.Create;
        g_DisableSendMsgList := TGStringList.Create;
        g_MonDropLimitLIst := TGStringList.Create;

        GetStartupInfo(Info); //anti od...
        if (Info.dwX = 0) and (Info.dwY = 0) and (Info.dwXCountChars = 0) and (Info.dwYCountChars = 0) and (Info.dwFillAttribute = 0) and (Info.dwXSize = 0) and (Info.dwYSize = 0) then
        begin
          g_SaleItemList := TGList.Create;
          g_ShopItemList := TGList.Create;
          g_GuildRankNameFilterList := TGStringList.Create;
          g_UnMasterList := TGStringList.Create;
          g_UnForceMasterList := TGStringList.Create;
          g_GameLogItemNameList := TGStringList.Create;
          g_DenyIPAddrList := TGStringList.Create;
          g_DenyChrNameList := TGStringList.Create;
          g_DenyAccountList := TGStringList.Create;
          g_NoClearMonList := TGStringList.Create;
          g_ItemLimitList := TGList.Create;

          g_UserCmdList := TGStringList.Create;
          g_UpgradeItemList := TGStringList.Create;
          g_PetPickItemList := TGStringList.Create;
          g_ItemBindIPaddr := TGList.Create;
          g_ItemBindAccount := TGList.Create;
          g_ItemBindCharName := TGList.Create;
          InitUserDataList();
          InitSuiteItemsList();
          g_HintItemList := TCnHashTableSmall.Create;
          InitVariablesList();
          //g_HWIDFilter := THWIDFilter.Create;
        end;
      end;
    finally
      iss.Free;
    end;
  end;
{$I '..\Common\Macros\VMPE.inc'}
{$ELSEIF USEWLSDK = 2}
{$I '..\Common\Macros\VMPBU.inc'}
  {.$I '..\Common\Macros\SE_PROTECT_START_ULTRA.inc'}

  MemoLog.Lines.Add({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('正在验证时间授权,请先开放安全策略,验证过后再开启')); //192.43.244.18:13

  if SECheckProtection() and (SECheckExpDate() = SE_ERR_SUCCESS) and (SECheckLicenseFileA(PChar(g_M2ServerLic)) = SE_ERR_SUCCESS) then
  begin //有注册文件...
    //Application.ProcessMessages;
    nTrial := SEGetLicenseTrialInfo(SELicenseTrialInfo);
    //Application.ProcessMessages;
    nReg := SEGetLicenseUserInfoA(SELicenseUserInfo);
    if (nTrial = SE_ERR_SUCCESS) and (nReg = SE_ERR_SUCCESS) then
    begin //注册文件正常...

      //210.0.235.14:37
      //132.163.4.102:37
      //64.236.96.53:37

      lpDateTime := EncodeDate(2029, 1, 1);

      FIdTimeObj := TIdTime.Create(nil);
      FIdTimeObj.TimeOut := 3000;
      try
        nCount := 0;
        while True do
        begin
          FIdTimeObj.BaseDate := EncodeDate(1900, 1, 1);
          FIdTimeObj.Port := 37;
          case nCount of
            0: FIdTimeObj.Host := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('210.0.235.14');
            1: FIdTimeObj.Host := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('132.163.4.102');
            2: FIdTimeObj.Host := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('64.236.96.53');
          end;
          try
            lpDateTime := FIdTimeObj.DateTime;
          except
            lpDateTime := EncodeDate(2029, 1, 1);
          end;

          lpDateTime2 := SystemTimeToDateTime(SELicenseTrialInfo.ExpDate);
          if lpDateTime < lpDateTime2 then
          begin
            nCount := 99;
            Break;
          end;

          Inc(nCount);
          if nCount > 2 then
            Break;
          Start := GetTickCount;
          while GetTickCount - Start < 1998 do
            Application.ProcessMessages;
        end;
      finally
        FIdTimeObj.Free;
      end;

      if nCount <> 99 then
      begin
        sDateTime := '';
        while True do
        begin
          try
            sock := Socket(AF_INET, SOCK_STREAM, 0);
            cliaddr.sin_family := AF_INET;
            cliaddr.sin_addr.s_addr := inet_addr({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('192.43.244.18'));
            cliaddr.sin_port := htons(13);
            FillChar(buf, SizeOf(buf), 0);
            Connect(sock, cliaddr, SizeOf(cliaddr));
            recv(sock, buf, 100, 0);
            sDateTime := Trim(StrPas(buf));
            if (sDateTime <> '') and (Pos({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('UTC(NIST)'), sDateTime) > 0) then
            begin
              Break;
            end;
          except
          end;
          Start := GetTickCount;
          while GetTickCount - Start < 1500 do
            Application.ProcessMessages;
        end;
        GetTimeZoneInformation(tzInfo);
        hBias := tzInfo.Bias div 60;
        mBias := tzInfo.Bias mod 60;
        lpSystemTime.wYear := StrToInt(Copy(sDateTime, 7, 2));
        lpSystemTime.wMonth := StrToInt(Copy(sDateTime, 10, 2));
        lpSystemTime.wDay := StrToInt(Copy(sDateTime, 13, 2));
        lpSystemTime.wHour := StrToInt(Copy(sDateTime, 16, 2));
        lpSystemTime.wMinute := StrToInt(Copy(sDateTime, 19, 2));
        lpSystemTime.wSecond := StrToInt(Copy(sDateTime, 22, 2));
        lpSystemTime.wMilliseconds := StrToInt(Copy(sDateTime, 32, 3));
        lpSystemTime.wYear := lpSystemTime.wYear + 2000;
        lpSystemTime.wHour := (lpSystemTime.wHour - hBias) mod 12;
        lpSystemTime.wMinute := (lpSystemTime.wMinute - mBias) mod 60;
        lpDateTime := SystemTimeToDateTime(lpSystemTime);
        lpDateTime2 := SystemTimeToDateTime(SELicenseTrialInfo.ExpDate);

        //MemoLog.Lines.Add('Now: ' + DateTimeToStr(lpDateTime) + ', ExpDate: ' + DateTimeToStr(lpDateTime2));
      end;

      if lpDateTime < lpDateTime2 then
      begin //判断授权文件是否过期...
        g_lpDateTime := SystemTimeToDateTime(SELicenseTrialInfo.ExpDate);

        LoadConfig();
        MENU_OPTION_FUNCTION.Visible := True;
        MENU_VIEW_ONLINEHUMAN.Visible := True;

        g_MainMemo := MemoLog;
        Application.HintColor := StringToColor(g_Config.sHintColor);
        g_MainMemo.Color := StringToColor(g_Config.sMemoLogColor);
        g_MainMemo.Font.Color := StringToColor(g_Config.sMemoLogFontColor);
        //Application.ProcessMessages;
        mHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, GetCurrentProcessId);
        if mHandle <> 0 then
        begin
          FModuleEntry32.dwSize := SizeOf(TModuleEntry32);
          if Module32First(mHandle, FModuleEntry32) then
          begin
            mList := TStringlist.Create;
            nCount := 0;
            while Module32Next(mHandle, FModuleEntry32) do
            begin
              sLocalIP := LowerCase(ExtractFileName(FModuleEntry32.szModule));
              if CompareText(sLocalIP, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('D3dHook.dll')) = 0 then
              begin
                Inc(nCount);
                Break;
              end;
              if CompareText(sLocalIP, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('comctl32.dll')) = 0 then
                Continue;
              if mList.IndexOf(sLocalIP) > -1 then
              begin //Exists
                Inc(nCount);
                Break;
              end
              else
              begin
                mList.Add(sLocalIP);
              end;
              //Application.ProcessMessages;
            end;
            mList.Free;
            //MemoLog.Lines.Add(format('double dll(%d) ...', [nCount]));
            if nCount = 0 then
            begin
              nModule := GetModuleHandle({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ntdll.dll'));
              if nModule <> 0 then
              begin
                ZwQueryInformationProcess := GetProcAddress(nModule, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ZwQueryInformationProcess'));
                if @ZwQueryInformationProcess <> nil then
                begin
                  if STATUS_SUCCESS = ZwQueryInformationProcess(GetCurrentProcess(), DWORD(ProcessBasicInformation), @ProcessInfo, SizeOf(ProcessInfo), nil) then
                  begin
                    hParentProcess := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessInfo.InheritedFromUniqueProcessId);
                    if (hParentProcess <> 0) then
                    begin
                      Len := 0;
                      if GetProcessImageFileName(hParentProcess, szBuffer, MAX_PATH) > 0 then
                      begin
                        Len := DosDevicePath2LogicalPath(szBuffer, ParentName, MAX_PATH);
                      end;
                      if (Len > 0) then
                      begin
                        GetWindowsDirectory(szBuffer, MAX_PATH);
                        StrCat(szBuffer, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('\EXPLORER.EXE'));
                        if (CompareText(UpperCase(szBuffer), UpperCase(ParentName)) = 0) {or (CompareText(MD5Print(MD5File(ParentName)), g_GameCenterMd5^) = 0)} then
                        begin
                          PlugInEngine := TPlugInManage.Create;
                          RunSocket := TRunSocket.Create();
                          MainLogMsgList := TStringlist.Create;
                          LogStringList := TStringlist.Create;
                          LogonCostLogList := TStringlist.Create;
                          g_MapManager := TMapManager.Create;
                          ItemUnit := TItemUnit.Create;
                          MagicManager := TMagicManager.Create;
                          NoticeManager := TNoticeManager.Create;
                          g_GuildManager := TGuildManager.Create;
                          g_EventManager := TEventManager.Create;
                          g_CastleManager := TCastleManager.Create;
                          //g_GuildTerritory := TGTManager.Create;
                          g_StartPointManager := TStartPointManager.Create;
                          FrontEngine := TFrontEngine.Create(True);
                          g_DBSQL := TDBSQL.Create;
                          g_SQlEngine := TSQLEngine.Create;
                        end;
                      end;
                      CloseHandle(hParentProcess);
                    end;
                  end;
                end;
              end;
            end;
          end;
          CloseHandle(mHandle);
        end;
      end;
    end
    else
    begin
      MENU_OPTION_FUNCTION.Visible := False;
      MENU_VIEW_ONLINEHUMAN.Visible := False;
    end;
  end
  else
  begin
    MENU_OPTION_FUNCTION.Visible := False;
    MENU_VIEW_ONLINEHUMAN.Visible := False;
  end;

  sDlls := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('IPLocal.dll mPlugOfScript.dll mPlugOfEngine.dll mSystemModule.dll mPlugOfAccess.dll');
  mHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, GetCurrentProcessId);
  bHook := False;
  if mHandle <> 0 then
  begin
    FModuleEntry32.dwSize := SizeOf(TModuleEntry32);
    bHook := False;
    if Module32First(mHandle, FModuleEntry32) then
    begin
      while Module32Next(mHandle, FModuleEntry32) do
      begin
        if LowerCase(Trim(ExtractFilePath(FModuleEntry32.szExePath))) = LowerCase(ExtractFilePath(ParamStr(0))) then
        begin
          if Pos(LowerCase(ExtractFileName(FModuleEntry32.szModule)), LowerCase(sDlls)) <= 0 then
          begin
            bHook := True;
            Break;
          end;
        end;
        //Application.ProcessMessages;
      end;
    end;
    CloseHandle(mHandle);
  end;
  if not bHook then
  begin
    iss := IStrings.Create;
    try
      iss.LoadFromFile(Application.ExeName);
      if Pos({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('InitSabuk'), iss.Text) <> 0 then
        ExitProcess(0)
      else
      begin
        UserEngine := TUserEngine.Create();
{$IF V_TEST in [1, 2]}
        if (SECheckExpDate() = SE_ERR_SUCCESS) then
        begin //锁机器的注册版...
          g_RobotManage := TRobotManage.Create;
          g_BaseObject := TBaseObject.Create;
          g_BaseObject.m_btRaceServer := 62;
          g_BaseObject.m_boSuperMan := True;
        end;
{$ELSE}
        if (SECheckHardwareID() = SE_ERR_SUCCESS) then
        begin //锁机器的注册版...
          g_RobotManage := TRobotManage.Create;
          g_BaseObject := TBaseObject.Create;
          g_BaseObject.m_btRaceServer := 62;
          g_BaseObject.m_boSuperMan := True;
        end;
{$IFEND V_TEST}

        g_xBlockUserList := TStringlist.Create;
        g_AutoLoginList := TStringlist.Create;
        g_DeathWalkingSays := TStringlist.Create;
        g_MakeItemList := TStringlist.Create;
        g_BoxItemList := TStringlist.Create;

        g_RefineItemList := TStringlist.Create;
        g_DenySayMsgList := TQuickList.Create;
        MiniMapList := TStringlist.Create;
        g_UnbindList := TStringlist.Create;
        LineNoticeList := TStringlist.Create;
        QuestDiaryList := TList.Create;
        ItemEventList := TStringlist.Create;
        AbuseTextList := TStringlist.Create;
        g_MonSayMsgList := THStringlist.Create;
        g_AllowBindNameList := THStringlist.Create;
        g_SayMsgList := TStringlist.Create;
        g_DisableMoveMapList := TGStringList.Create;
        for nCount := Low(g_MissionList) to High(g_MissionList) do
          g_MissionList[nCount] := TStringlist.Create;
        g_ItemNameList := TGList.Create;
        g_DisableSendMsgList := TGStringList.Create;
        g_MonDropLimitLIst := TGStringList.Create;

        GetStartupInfo(Info); //anti od...
        if (Info.dwX = 0) and (Info.dwY = 0) and (Info.dwXCountChars = 0) and (Info.dwYCountChars = 0) and (Info.dwFillAttribute = 0) and (Info.dwXSize = 0) and (Info.dwYSize = 0) then
        begin
          g_SaleItemList := TGList.Create;
          g_ShopItemList := TGList.Create;
          g_GuildRankNameFilterList := TGStringList.Create;
          g_UnMasterList := TGStringList.Create;
          g_UnForceMasterList := TGStringList.Create;
          g_GameLogItemNameList := TGStringList.Create;
          g_DenyIPAddrList := TGStringList.Create;
          g_DenyChrNameList := TGStringList.Create;
          g_DenyAccountList := TGStringList.Create;
          g_NoClearMonList := TGStringList.Create;
          g_ItemLimitList := TGList.Create;

          g_UserCmdList := TGStringList.Create;
          g_UpgradeItemList := TGStringList.Create;
          g_PetPickItemList := TGStringList.Create;
          g_ItemBindIPaddr := TGList.Create;
          g_ItemBindAccount := TGList.Create;
          g_ItemBindCharName := TGList.Create;
          InitUserDataList();
          InitSuiteItemsList();
          g_HintItemList := TCnHashTableSmall.Create;
          InitVariablesList();
          //g_HWIDFilter := THWIDFilter.Create;
        end;
      end;
    finally
      iss.Free;
    end;
  end;
  {.$I '..\Common\Macros\SE_PROTECT_END.inc'}
{$I '..\Common\Macros\VMPE.inc'}

{$ELSE}
  LoadConfig();
  MENU_OPTION_FUNCTION.Visible := True;
  MENU_VIEW_ONLINEHUMAN.Visible := True;

  g_MainMemo := MemoLog;
  Application.HintColor := StringToColor(g_Config.sHintColor);
  g_MainMemo.Color := StringToColor(g_Config.sMemoLogColor);
  g_MainMemo.Font.Color := StringToColor(g_Config.sMemoLogFontColor);

  PlugInEngine := TPlugInManage.Create;
  RunSocket := TRunSocket.Create();
  MainLogMsgList := TStringlist.Create;
  LogStringList := TStringlist.Create;
  LogonCostLogList := TStringlist.Create;
  g_MapManager := TMapManager.Create;
  ItemUnit := TItemUnit.Create;
  MagicManager := TMagicManager.Create;
  NoticeManager := TNoticeManager.Create;
  g_GuildManager := TGuildManager.Create;
  g_EventManager := TEventManager.Create;
  g_CastleManager := TCastleManager.Create;
  //g_GuildTerritory := TGTManager.Create;
  g_StartPointManager := TStartPointManager.Create;
  FrontEngine := TFrontEngine.Create(True);
  g_DBSQL := TDBSQL.Create;
  g_SQlEngine := TSQLEngine.Create;

  UserEngine := TUserEngine.Create();
  g_RobotManage := TRobotManage.Create;
  g_BaseObject := TBaseObject.Create;
  g_BaseObject.m_btRaceServer := 62;
  g_BaseObject.m_boSuperMan := True;

  g_xBlockUserList := TStringlist.Create;
  g_AutoLoginList := TStringlist.Create;
  g_DeathWalkingSays := TStringlist.Create;
  g_MakeItemList := TStringlist.Create;
  g_BoxItemList := TStringlist.Create;

  g_RefineItemList := TStringlist.Create;
  g_DenySayMsgList := TQuickList.Create;
  MiniMapList := TStringlist.Create;
  g_UnbindList := TStringlist.Create;
  LineNoticeList := TStringlist.Create;
  QuestDiaryList := TList.Create;
  ItemEventList := TStringlist.Create;
  AbuseTextList := TStringlist.Create;
  g_MonSayMsgList := THStringlist.Create;
  g_AllowBindNameList := THStringlist.Create;
  g_SayMsgList := TStringlist.Create;
  g_DisableMoveMapList := TGStringList.Create;
  for nCount := Low(g_MissionList) to High(g_MissionList) do
    g_MissionList[nCount] := TStringlist.Create;

  g_ItemNameList := TGList.Create;
  g_DisableSendMsgList := TGStringList.Create;
  g_MonDropLimitLIst := TGStringList.Create;
  g_SaleItemList := TGList.Create;
  g_ShopItemList := TGList.Create;
  g_GuildRankNameFilterList := TGStringList.Create;
  g_UnMasterList := TGStringList.Create;
  g_UnForceMasterList := TGStringList.Create;
  g_GameLogItemNameList := TGStringList.Create;
  g_DenyIPAddrList := TGStringList.Create;
  g_DenyChrNameList := TGStringList.Create;
  g_DenyAccountList := TGStringList.Create;
  g_NoClearMonList := TGStringList.Create;
  g_ItemLimitList := TGList.Create;

  g_UserCmdList := TGStringList.Create;
  g_UpgradeItemList := TGStringList.Create;
  g_PetPickItemList := TGStringList.Create;
  g_ItemBindIPaddr := TGList.Create;
  g_ItemBindAccount := TGList.Create;
  g_ItemBindCharName := TGList.Create;
  InitUserDataList();
  InitSuiteItemsList();
  g_HintItemList := TCnHashTableSmall.Create;
  InitVariablesList();
  //g_HWIDFilter := THWIDFilter.Create;
{$IFEND USEWLSDK}

  InitializeCriticalSection(g_BlockUserLock);
  InitializeCriticalSection(LogMsgCriticalSection);
  //InitializeCriticalSection(ProcessMsgCriticalSection);
  InitializeCriticalSection(ProcessHumanCriticalSection);
  InitializeCriticalSection(USInterMsgCriticalSection);
  InitializeCriticalSection(SQLCriticalSection);
  //InitializeCriticalSection(NPCListCS);
  //InitializeCriticalSection(UserMgrEngnCriticalSection);
  InitializeCriticalSection(Config.UserIDSection);
  InitializeCriticalSection(UserDBSection);
  g_DynamicVarList := TList.Create;

  TimeNow := Now();
  DecodeDate(TimeNow, Year, Month, Day);
  DecodeTime(TimeNow, Hour, Min, Sec, msec);
  if not DirectoryExists(g_Config.sLogDir) then
    CreateDir(Config.sLogDir);
  sLogFileName := g_Config.sLogDir + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day) + '.' + IntToStr2(Hour) + '-' + IntToStr2(Min) + '.txt';
  AssignFile(F, sLogFileName);
  Rewrite(F);
  CloseFile(F);

{$IF USEWLSDK = 1}
{$I '..\Common\Macros\VMPBU.inc'}

  aThreadID := GetWindowThreadProcessId(Application.Handle, @aProcessID);
  PH := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, aProcessID);
  if PH <> 0 then
  begin
    if GetModuleBaseName(PH, 0, PIDName, SizeOf(PIDName)) > 0 then
    begin
      if not EnumProcessModules(PH, @MODList, 1000, modNeeded) then
        modNeeded := 0;
      if modNeeded > 0 then
      begin
        mList := TStringlist.Create;
        nCount := 0;
        for j := 0 to modNeeded div SizeOf(HInst) - 1 do
        begin
          dwLen := GetModuleBaseNameA(PH, MODList[j], MODName, SizeOf(MODName));
          if dwLen > 0 then
          begin
            sLocalIP := LowerCase(StrPas(MODName));
            if CompareText(sLocalIP, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('D3dHook.dll')) = 0 then
            begin
              Inc(nCount);
              Break;
            end;
            if CompareText(sLocalIP, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('comctl32.dll')) = 0 then
              Continue;
            if mList.IndexOf(sLocalIP) > -1 then
            begin //Exists
              Inc(nCount);
              Break;
            end
            else
            begin
              mList.Add(sLocalIP);
            end;
          end;
        end;
        mList.Free;
        if nCount = 0 then
        begin

          nModule := GetModuleHandle({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ntdll.dll'));
          if nModule <> 0 then
          begin
            ZwQueryInformationProcess := GetProcAddress(nModule, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ZwQueryInformationProcess'));
            if @ZwQueryInformationProcess <> nil then
            begin
              if STATUS_SUCCESS = ZwQueryInformationProcess(GetCurrentProcess(), DWORD(ProcessBasicInformation), @ProcessInfo, SizeOf(ProcessInfo), nil) then
              begin
                hParentProcess := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessInfo.InheritedFromUniqueProcessId);
                if (hParentProcess <> 0) then
                begin
                  Len := 0;
                  if GetProcessImageFileName(hParentProcess, szBuffer, MAX_PATH) > 0 then
                  begin
                    Len := DosDevicePath2LogicalPath(szBuffer, ParentName, MAX_PATH);
                  end;
                  if (Len > 0) then
                  begin
                    GetWindowsDirectory(szBuffer, MAX_PATH);
                    StrCat(szBuffer, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('\EXPLORER.EXE'));
                    if (CompareText(UpperCase(szBuffer), UpperCase(ParentName)) = 0) {or (CompareText(MD5Print(MD5File(ParentName)), g_GameCenterMd5^) = 0)} then
                    begin
                      PlugInEngine.LoadPlugIn();
                      //MemoLog.Lines.Add('正在读取配置信息...');
                      DBSocket.Address := g_Config.sDBAddr;
                      DBSocket.Port := g_Config.nDBPort;
                      sCaption := g_Config.sServerName;
                      Caption := Format('%s', [sCaption]);
                      LoadServerTable();
                      LogUDP.RemoteHost := g_Config.sLogServerAddr;
                      LogUDP.RemotePort := g_Config.nLogServerPort;
                      Application.OnIdle := AppOnIdle;
                      Application.OnException := OnProgramException;
                      dwRunDBTimeMax := GetTickCount();
                      g_dwStartTick := GetTickCount();
                      Timer1.Enabled := True;
                      boServiceStarted := True;
                      MENU_CONTROL_STOP.Enabled := True;
                    end;
                  end;
                  CloseHandle(hParentProcess);
                end;
              end;
            end;
          end;
          //
        end;
      end;
    end;
    CloseHandle(PH);
  end;

  if (WLRegGetStatus(nExtendedInfo) = wlIsRegistered) and WLRegGetLicenseInfo(RegName, CompanyName, CustomData) then
  begin
    {sLocalIP := '';
    nSize := 5120;
    GetMem(pAI, nSize);
    nRes := GetAdaptersInfo(pAI, nSize);
    if (nRes = ERROR_SUCCESS) then begin
      pWork := pAI;
      pIPAddr := @pWork^.IPAddressList;
      while (pIPAddr <> nil) do begin
        sLocalIP := pIPAddr^.IPAddress;
        pIPAddr := pIPAddr^.Next;
      end;
      //0801
      WLRegGetLicenseInfo(RegName, CompanyName, CustomData);
      if (StrPas(RegName) <> sLocalIP) or (StrPas(RegName) = '89FD97E4504A49BDC85E2C114DC7EE42') then begin
        FrontEngine.Free;
        MagicManager.Free;
        UserEngine.Free;
        if g_RobotManage <> nil then g_RobotManage.Free;

        g_SQlEngine.Terminate;
        g_DBSQL.Free;
        g_SQlEngine.Free;

        RunSocket.Free;
        ConnectTimer.Enabled := False;
        DBSocket.Close;
        MainLogMsgList.Free;
        LogStringList.Free;
        LogonCostLogList.Free;
        g_MapManager.Free;
        ItemUnit.Free;
        NoticeManager.Free;
        g_GuildManager.Free;

        DeleteFile(g_sM2RegData);
        //WLRestartApplication();
      end;

    end else begin
      FrontEngine.Free;
      MagicManager.Free;
      UserEngine.Free;
      if g_RobotManage <> nil then g_RobotManage.Free;

      g_SQlEngine.Terminate;
      g_DBSQL.Free;
      g_SQlEngine.Free;
      WLRestartApplication();
    end;
    FreeMem(pAI);}
    sLocalIP := IdIPWatch.LocalIP;

    //sLocalIP := __En__(sLocalIP, 'BlueSoft');
    if (StrPas(RegName) <> sLocalIP) then
    begin
      //if (StrPas(SELicenseUserInfo.UserID) <> sLocalIP) or (StrPas(SELicenseUserInfo.UserID) = {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('61.147.112.118')) then begin
      FrontEngine.Free;
      MagicManager.Free;
      UserEngine.Free;
      if g_RobotManage <> nil then
        g_RobotManage.Free;

      g_SQlEngine.Terminate;
      g_DBSQL.Free;
      g_SQlEngine.Free;

      RunSocket.Free;
      ConnectTimer.Enabled := False;
      DBSocket.Close;
      MainLogMsgList.Free;
      LogStringList.Free;
      LogonCostLogList.Free;
      g_MapManager.Free;
      ItemUnit.Free;
      NoticeManager.Free;
      g_GuildManager.Free;

      //DeleteFile(g_sM2RegData);
      Exit;
    end;

    //0512
    sLocalIP := '';
    nSize := 5120;
    GetMem(pAI, nSize);
    nRes := GetAdaptersInfo(pAI, nSize);
    if (nRes = ERROR_SUCCESS) then
    begin
      pWork := pAI;
      pIPAddr := @pWork^.IPAddressList;
      while (pIPAddr <> nil) do
      begin
        sLocalIP := pIPAddr^.IPAddress;
        pIPAddr := pIPAddr^.Next;
      end;
    end;
    FreeMem(pAI);

    if StrPas(RegName) <> sLocalIP then
    begin
      FrontEngine.Free;
      MagicManager.Free;
      UserEngine.Free;
      if g_RobotManage <> nil then
        g_RobotManage.Free;

      g_SQlEngine.Terminate;
      g_DBSQL.Free;
      g_SQlEngine.Free;

      RunSocket.Free;
      ConnectTimer.Enabled := False;
      DBSocket.Close;
      MainLogMsgList.Free;
      LogStringList.Free;
      LogonCostLogList.Free;
      g_MapManager.Free;
      ItemUnit.Free;
      NoticeManager.Free;
      g_GuildManager.Free;

      //DeleteFile(g_sM2RegData);
      Exit;
    end;

    ///////////////////////
    nSize := 5120;
    GetMem(pAI, nSize);
    nRes := GetAdaptersInfo(pAI, nSize);
    if (nRes = ERROR_SUCCESS) then
    begin
      pWork := pAI;
      while pWork <> nil do
      begin
        //pWork^.AdapterName
        ireg4 := TRegistry.Create;
        ireg4.RootKey := HKEY_LOCAL_MACHINE;
        try
          S := Format({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\%s\Connection'), [pWork^.AdapterName]);
          if ireg4.OpenKey(S, False) then
          begin
            S := ireg4.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('PnpInstanceID'));
            if not CompareLStr(S, 'PCI', Length('PCI')) and
              not CompareLStr(S, 'SCSI', Length('SCSI')) and
              not CompareLStr(S, 'B06BDRV', Length('B06BDRV')) and
              not CompareLStr(S, '{1A3E09BE-1E45-494B-9174-D7385B45BBF5}', Length('{1A3E09BE-1E45-494B-9174-D7385B45BBF5}')) then
            begin
              FrontEngine.Free;
              MagicManager.Free;
              UserEngine.Free;
              if g_RobotManage <> nil then
                g_RobotManage.Free;

              g_SQlEngine.Terminate;
              g_DBSQL.Free;
              g_SQlEngine.Free;

              RunSocket.Free;
              ConnectTimer.Enabled := False;
              DBSocket.Close;
              MainLogMsgList.Free;
              LogStringList.Free;
              LogonCostLogList.Free;
              g_MapManager.Free;
              ItemUnit.Free;
              NoticeManager.Free;
              g_GuildManager.Free;
              Exit;
            end;
          end
          else
          begin
            FrontEngine.Free;
            MagicManager.Free;
            UserEngine.Free;
            if g_RobotManage <> nil then
              g_RobotManage.Free;

            g_SQlEngine.Terminate;
            g_DBSQL.Free;
            g_SQlEngine.Free;

            RunSocket.Free;
            ConnectTimer.Enabled := False;
            DBSocket.Close;
            MainLogMsgList.Free;
            LogStringList.Free;
            LogonCostLogList.Free;
            g_MapManager.Free;
            ItemUnit.Free;
            NoticeManager.Free;
            g_GuildManager.Free;
            Exit;
          end;
        finally
          ireg4.CloseKey;
          ireg4.Free;
        end;
        //HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\{ACA306D0-1D69-4116-BC2B-919B428AD084}\Connection

        ireg := TRegistry.Create;
        ireg.RootKey := HKEY_LOCAL_MACHINE;
        ireg3 := TRegistry.Create;
        ireg3.RootKey := HKEY_LOCAL_MACHINE;
        Ss := TStringlist.Create;
        try
          if ireg.OpenKey({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards'), False) then
          begin
            Ss.Clear;
            ireg.GetKeyNames(Ss);
            for i := 0 to Ss.Count - 1 do
            begin
              S := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards') + '\' + Ss[i];
              ireg3.CloseKey;
              if ireg3.OpenKey(S, False) then
              begin
                if (CompareText(ireg3.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ServiceName')), {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('{5334FBB0-CB1B-4C7A-97B9-F575C5ACBE4D}')) <> 0)
                  and (CompareText(ireg3.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ServiceName')), {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('{63E80B69-3B83-4C7A-A5F9-3F7397C98A3D}')) <> 0)
                  and (CompareText(pWork^.AdapterName, ireg3.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ServiceName'))) = 0) then
                begin

                  sDateTime := IntToStr(StrToInt(Ss[i]) - 1);
                  sLocalIP := '';
                  for j := 1 to 4 - Length(sDateTime) do
                    sLocalIP := sLocalIP + '0';
                  sLocalIP := sLocalIP + sDateTime;

                  S := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\') + sLocalIP;
                  ireg2 := TRegistry.Create;
                  ireg2.RootKey := HKEY_LOCAL_MACHINE;
                  try
                    if ireg2.OpenKey(S, False) then
                    begin
                      Len := ireg2.ReadInteger({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('Characteristics'));
                      if (Len and $4) <> $4 then
                      begin //非物品网卡
                        FrontEngine.Free;
                        MagicManager.Free;
                        UserEngine.Free;
                        if g_RobotManage <> nil then
                          g_RobotManage.Free;

                        g_SQlEngine.Terminate;
                        g_DBSQL.Free;
                        g_SQlEngine.Free;

                        RunSocket.Free;
                        ConnectTimer.Enabled := False;
                        DBSocket.Close;
                        MainLogMsgList.Free;
                        LogStringList.Free;
                        LogonCostLogList.Free;
                        g_MapManager.Free;
                        ItemUnit.Free;
                        NoticeManager.Free;
                        g_GuildManager.Free;
                        Exit;
                      end;
                    end
                    else
                    begin
                      FrontEngine.Free;
                      MagicManager.Free;
                      UserEngine.Free;
                      if g_RobotManage <> nil then
                        g_RobotManage.Free;

                      g_SQlEngine.Terminate;
                      g_DBSQL.Free;
                      g_SQlEngine.Free;

                      RunSocket.Free;
                      ConnectTimer.Enabled := False;
                      DBSocket.Close;
                      MainLogMsgList.Free;
                      LogStringList.Free;
                      LogonCostLogList.Free;
                      g_MapManager.Free;
                      ItemUnit.Free;
                      NoticeManager.Free;
                      g_GuildManager.Free;
                      Exit;
                    end;
                  finally
                    ireg2.CloseKey;
                    ireg2.Free;
                  end;
                end;
              end
              else
              begin
                FrontEngine.Free;
                MagicManager.Free;
                UserEngine.Free;
                if g_RobotManage <> nil then
                  g_RobotManage.Free;

                g_SQlEngine.Terminate;
                g_DBSQL.Free;
                g_SQlEngine.Free;

                RunSocket.Free;
                ConnectTimer.Enabled := False;
                DBSocket.Close;
                MainLogMsgList.Free;
                LogStringList.Free;
                LogonCostLogList.Free;
                g_MapManager.Free;
                ItemUnit.Free;
                NoticeManager.Free;
                g_GuildManager.Free;
                Exit;
              end;
            end;
          end
          else
          begin
            FrontEngine.Free;
            MagicManager.Free;
            UserEngine.Free;
            if g_RobotManage <> nil then
              g_RobotManage.Free;

            g_SQlEngine.Terminate;
            g_DBSQL.Free;
            g_SQlEngine.Free;

            RunSocket.Free;
            ConnectTimer.Enabled := False;
            DBSocket.Close;
            MainLogMsgList.Free;
            LogStringList.Free;
            LogonCostLogList.Free;
            g_MapManager.Free;
            ItemUnit.Free;
            NoticeManager.Free;
            g_GuildManager.Free;
            Exit;
          end;
        finally
          ireg.CloseKey;
          ireg.Free;
          ireg3.CloseKey;
          ireg3.Free;
          Ss.Free;
        end;

        pWork := pWork.Next;
      end;
    end;
    FreeMem(pAI);

    ///////////////////////////////////////////////
    ireg := TRegistry.Create;
    ireg.RootKey := HKEY_LOCAL_MACHINE;
    ireg3 := TRegistry.Create;
    ireg3.RootKey := HKEY_LOCAL_MACHINE;
    Ss := TStringlist.Create;
    try
      if ireg.OpenKey({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards'), False) then
      begin
        Ss.Clear;
        ireg.GetKeyNames(Ss);
        for i := 0 to Ss.Count - 1 do
        begin

          //过滤
          S := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards') + '\' + Ss[i];
          ireg3.CloseKey;
          if ireg3.OpenKey(S, False) then
          begin
            if (CompareText(ireg3.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ServiceName')),
{$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('{5334FBB0-CB1B-4C7A-97B9-F575C5ACBE4D}')) = 0) or
              (CompareText(ireg3.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ServiceName')),
{$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('{63E80B69-3B83-4C7A-A5F9-3F7397C98A3D}')) = 0) then
              Continue;
          end;

          sDateTime := IntToStr(StrToInt(Ss[i]) - 1);
          sLocalIP := '';
          for j := 1 to 4 - Length(sDateTime) do
            sLocalIP := sLocalIP + '0';
          sLocalIP := sLocalIP + sDateTime;

          S := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\') + sLocalIP;
          ireg2 := TRegistry.Create;
          ireg2.RootKey := HKEY_LOCAL_MACHINE;
          try
            if ireg2.OpenKey(S, False) then
            begin
              Len := ireg2.ReadInteger({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('Characteristics'));
              //ox1 NCF_VIRTUAL 说明组件是个虚拟适配器
              //ox2 NCF_SOFTWARE_ENUMERATED 说明组件是一个软件模拟的适配器
              //ox4 NCF_PHYSICAL 说明组件是一个物理适配器
              //ox8 NCF_HIDDEN 说明组件不显示用户接口
              //ox10 NCF_NO_SERVICE 说明组件没有相关的服务(设备驱动程序)
              //ox20 NCF_NOT_USER_REMOVABLE 说明不能被用户删除(例如，通过控制面板或设备管理器)
              //ox40 NCF_MULTIPORT_INSTANCED_ADAPTER 说明组件有多个端口，每个端口作为单独的设备安装。每个端口有自己的hw_id(组件ID)并可被单独安装，这只适合于EISA适配器
              //ox80 NCF_HAS_UI 说明组件支持用户接口(例如，Advanced Page或CustomerProperties Sheet)
              //ox400 NCF_FILTER 说明组件是一个过滤器

              //如果是虚拟网卡：Characteristics & NCF_VIRTUAL ==NCF_VIRTUAL

              //如果是物理网卡：Characteristics & NCF_PHYSICAL ==NCF_PHYSICAL
              if ((Len and $1) = $1) then
              begin //启用网卡中存在虚拟网卡
                FrontEngine.Free;
                MagicManager.Free;
                UserEngine.Free;
                if g_RobotManage <> nil then
                  g_RobotManage.Free;

                g_SQlEngine.Terminate;
                g_DBSQL.Free;
                g_SQlEngine.Free;

                RunSocket.Free;
                ConnectTimer.Enabled := False;
                DBSocket.Close;
                MainLogMsgList.Free;
                LogStringList.Free;
                LogonCostLogList.Free;
                g_MapManager.Free;
                ItemUnit.Free;
                NoticeManager.Free;
                g_GuildManager.Free;
                Exit;
              end;
            end;
          finally
            ireg2.CloseKey;
            ireg2.Free;
          end;
        end;
      end
      else
      begin
        FrontEngine.Free;
        MagicManager.Free;
        UserEngine.Free;
        if g_RobotManage <> nil then
          g_RobotManage.Free;

        g_SQlEngine.Terminate;
        g_DBSQL.Free;
        g_SQlEngine.Free;

        RunSocket.Free;
        ConnectTimer.Enabled := False;
        DBSocket.Close;
        MainLogMsgList.Free;
        LogStringList.Free;
        LogonCostLogList.Free;
        g_MapManager.Free;
        ItemUnit.Free;
        NoticeManager.Free;
        g_GuildManager.Free;
        Exit;
      end;
    finally
      ireg.CloseKey;
      ireg.Free;
      ireg3.CloseKey;
      ireg3.Free;
      Ss.Free;
    end;

  end
  else
  begin
    FrontEngine.Free;
    MagicManager.Free;
    UserEngine.Free;
    if g_RobotManage <> nil then
      g_RobotManage.Free;

    g_SQlEngine.Terminate;
    g_DBSQL.Free;
    g_SQlEngine.Free;

    RunSocket.Free;
    ConnectTimer.Enabled := False;
    DBSocket.Close;
    MainLogMsgList.Free;
    LogStringList.Free;
    LogonCostLogList.Free;
    g_MapManager.Free;
    ItemUnit.Free;
    NoticeManager.Free;
    g_GuildManager.Free;
    Exit;
  end;

{$I '..\Common\Macros\VMPE.inc'}
{$ELSEIF USEWLSDK = 2}
{$I '..\Common\Macros\PROTECT_START.inc'}

  aThreadID := GetWindowThreadProcessId(Application.Handle, @aProcessID);
  PH := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, aProcessID);
  if PH <> 0 then
  begin
    if GetModuleBaseName(PH, 0, PIDName, SizeOf(PIDName)) > 0 then
    begin
      if not EnumProcessModules(PH, @MODList, 1000, modNeeded) then
        modNeeded := 0;
      if modNeeded > 0 then
      begin
        mList := TStringlist.Create;
        nCount := 0;
        for j := 0 to modNeeded div SizeOf(HInst) - 1 do
        begin
          dwLen := GetModuleBaseNameA(PH, MODList[j], MODName, SizeOf(MODName));
          if dwLen > 0 then
          begin
            sLocalIP := LowerCase(StrPas(MODName));
            if CompareText(sLocalIP, ({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('D3dHook.dll'))) = 0 then
            begin
              Inc(nCount);
              Break;
            end;
            if CompareText(sLocalIP, ({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('comctl32.dll'))) = 0 then
              Continue;
            if mList.IndexOf(sLocalIP) > -1 then
            begin //Exists
              Inc(nCount);
              Break;
            end
            else
            begin
              mList.Add(sLocalIP);
            end;
            //Application.ProcessMessages;
          end;
        end;
        mList.Free;
        if nCount = 0 then
        begin

          nModule := GetModuleHandle({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ntdll.dll'));
          if nModule <> 0 then
          begin
            ZwQueryInformationProcess := GetProcAddress(nModule, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ZwQueryInformationProcess'));
            if @ZwQueryInformationProcess <> nil then
            begin
              if STATUS_SUCCESS = ZwQueryInformationProcess(GetCurrentProcess(), DWORD(ProcessBasicInformation), @ProcessInfo, SizeOf(ProcessInfo), nil) then
              begin
                hParentProcess := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessInfo.InheritedFromUniqueProcessId);
                if (hParentProcess <> 0) then
                begin
                  Len := 0;
                  if GetProcessImageFileName(hParentProcess, szBuffer, MAX_PATH) > 0 then
                  begin
                    Len := DosDevicePath2LogicalPath(szBuffer, ParentName, MAX_PATH);
                  end;
                  if (Len > 0) then
                  begin
                    GetWindowsDirectory(szBuffer, MAX_PATH);
                    StrCat(szBuffer, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('\EXPLORER.EXE'));
                    if (CompareText(UpperCase(szBuffer), UpperCase(ParentName)) = 0) {or (CompareText(MD5Print(MD5File(ParentName)), g_GameCenterMd5^) = 0)} then
                    begin
                      PlugInEngine.LoadPlugIn();
                      //MemoLog.Lines.Add('正在读取配置信息...');
                      DBSocket.Address := g_Config.sDBAddr;
                      DBSocket.Port := g_Config.nDBPort;
                      sCaption := g_Config.sServerName;
                      Caption := Format('%s', [sCaption]);
                      LoadServerTable();
                      LogUDP.RemoteHost := g_Config.sLogServerAddr;
                      LogUDP.RemotePort := g_Config.nLogServerPort;
                      Application.OnIdle := AppOnIdle;
                      Application.OnException := OnProgramException;
                      dwRunDBTimeMax := GetTickCount();
                      g_dwStartTick := GetTickCount();
                      Timer1.Enabled := True;
                      boServiceStarted := True;
                      MENU_CONTROL_STOP.Enabled := True;
                    end;
                  end;
                  CloseHandle(hParentProcess);
                end;
              end;
            end;
          end;
          //
        end;
      end;
    end;
    CloseHandle(PH);
  end;

  if (SEGetHardwareIDA(MachineId, SizeOf(MachineId)) = 0) and
    (SECheckLicenseFileA(PChar(g_M2ServerLic)) = 0) and
{$IF V_TEST in [1, 2]}
  (SECheckExpDate() = 0) and
{$ELSE}
  (SECheckHardwareID() = 0) and
{$IFEND V_TEST}
  (SEGetLicenseUserInfoA(SELicenseUserInfo) = 0) then
  begin
    sLocalIP := IdIPWatch.LocalIP;

{$IF V_TEST = 0}
    if (StrPas(SELicenseUserInfo.UserID) <> sLocalIP) or (StrPas(SELicenseUserInfo.UserID) = {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('61.147.112.118')) then
    begin
      FrontEngine.Free;
      MagicManager.Free;
      UserEngine.Free;
      if g_RobotManage <> nil then
        g_RobotManage.Free;

      g_SQlEngine.Terminate;
      g_DBSQL.Free;
      g_SQlEngine.Free;

      RunSocket.Free;
      ConnectTimer.Enabled := False;
      DBSocket.Close;
      MainLogMsgList.Free;
      LogStringList.Free;
      LogonCostLogList.Free;
      g_MapManager.Free;
      ItemUnit.Free;
      NoticeManager.Free;
      g_GuildManager.Free;

      //DeleteFile(g_sM2RegData);
      Exit;
    end;
{$IFEND V_TEST}

    //0512
    sLocalIP := '';
    nSize := 5120;
    GetMem(pAI, nSize);
    nRes := GetAdaptersInfo(pAI, nSize);
    if (nRes = ERROR_SUCCESS) then
    begin
      pWork := pAI;
      pIPAddr := @pWork^.IPAddressList;
      while (pIPAddr <> nil) do
      begin
        sLocalIP := pIPAddr^.IPAddress;
        pIPAddr := pIPAddr^.Next;
      end;
    end;
    FreeMem(pAI);

{$IF V_TEST = 0}
    if StrPas(SELicenseUserInfo.UserID) <> sLocalIP then
    begin
      FrontEngine.Free;
      MagicManager.Free;
      UserEngine.Free;
      if g_RobotManage <> nil then
        g_RobotManage.Free;

      g_SQlEngine.Terminate;
      g_DBSQL.Free;
      g_SQlEngine.Free;

      RunSocket.Free;
      ConnectTimer.Enabled := False;
      DBSocket.Close;
      MainLogMsgList.Free;
      LogStringList.Free;
      LogonCostLogList.Free;
      g_MapManager.Free;
      ItemUnit.Free;
      NoticeManager.Free;
      g_GuildManager.Free;
      Exit;
    end;
{$IFEND V_TEST}

    ///////////////////////
    nSize := 5120;
    GetMem(pAI, nSize);
    nRes := GetAdaptersInfo(pAI, nSize);
    if (nRes = ERROR_SUCCESS) then
    begin
      pWork := pAI;
      while pWork <> nil do
      begin
        //pWork^.AdapterName
        ireg4 := TRegistry.Create;
        ireg4.RootKey := HKEY_LOCAL_MACHINE;
        try
          S := Format({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\%s\Connection'), [pWork^.AdapterName]);
          if ireg4.OpenKey(S, False) then
          begin
            S := ireg4.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('PnpInstanceID'));
            if not CompareLStr(S, 'PCI', Length('PCI')) and
              not CompareLStr(S, 'SCSI', Length('SCSI')) and
              not CompareLStr(S, 'B06BDRV', Length('B06BDRV')) and
              not CompareLStr(S, '{1A3E09BE-1E45-494B-9174-D7385B45BBF5}', Length('{1A3E09BE-1E45-494B-9174-D7385B45BBF5}')) then
            begin
              FrontEngine.Free;
              MagicManager.Free;
              UserEngine.Free;
              if g_RobotManage <> nil then
                g_RobotManage.Free;

              g_SQlEngine.Terminate;
              g_DBSQL.Free;
              g_SQlEngine.Free;

              RunSocket.Free;
              ConnectTimer.Enabled := False;
              DBSocket.Close;
              MainLogMsgList.Free;
              LogStringList.Free;
              LogonCostLogList.Free;
              g_MapManager.Free;
              ItemUnit.Free;
              NoticeManager.Free;
              g_GuildManager.Free;
              Exit;
            end;
          end
          else
          begin
            FrontEngine.Free;
            MagicManager.Free;
            UserEngine.Free;
            if g_RobotManage <> nil then
              g_RobotManage.Free;

            g_SQlEngine.Terminate;
            g_DBSQL.Free;
            g_SQlEngine.Free;

            RunSocket.Free;
            ConnectTimer.Enabled := False;
            DBSocket.Close;
            MainLogMsgList.Free;
            LogStringList.Free;
            LogonCostLogList.Free;
            g_MapManager.Free;
            ItemUnit.Free;
            NoticeManager.Free;
            g_GuildManager.Free;
            Exit;
          end;
        finally
          ireg4.CloseKey;
          ireg4.Free;
        end;
        //HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\{ACA306D0-1D69-4116-BC2B-919B428AD084}\Connection

        ireg := TRegistry.Create;
        ireg.RootKey := HKEY_LOCAL_MACHINE;
        ireg3 := TRegistry.Create;
        ireg3.RootKey := HKEY_LOCAL_MACHINE;
        Ss := TStringlist.Create;
        try
          if ireg.OpenKey({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards'), False) then
          begin
            Ss.Clear;
            ireg.GetKeyNames(Ss);
            for i := 0 to Ss.Count - 1 do
            begin
              S := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards') + '\' + Ss[i];
              ireg3.CloseKey;
              if ireg3.OpenKey(S, False) then
              begin
                if (CompareText(ireg3.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ServiceName')), {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('{5334FBB0-CB1B-4C7A-97B9-F575C5ACBE4D}')) <> 0)
                  and (CompareText(ireg3.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ServiceName')), {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('{63E80B69-3B83-4C7A-A5F9-3F7397C98A3D}')) <> 0)
                  and (CompareText(pWork^.AdapterName, ireg3.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ServiceName'))) = 0) then
                begin

                  sDateTime := IntToStr(StrToInt(Ss[i]) - 1);
                  sLocalIP := '';
                  for j := 1 to 4 - Length(sDateTime) do
                    sLocalIP := sLocalIP + '0';
                  sLocalIP := sLocalIP + sDateTime;

                  S := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\') + sLocalIP;
                  ireg2 := TRegistry.Create;
                  ireg2.RootKey := HKEY_LOCAL_MACHINE;
                  try
                    if ireg2.OpenKey(S, False) then
                    begin
                      Len := ireg2.ReadInteger({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('Characteristics'));
                      if (Len and $4) <> $4 then
                      begin //非物品网卡
                        FrontEngine.Free;
                        MagicManager.Free;
                        UserEngine.Free;
                        if g_RobotManage <> nil then
                          g_RobotManage.Free;

                        g_SQlEngine.Terminate;
                        g_DBSQL.Free;
                        g_SQlEngine.Free;

                        RunSocket.Free;
                        ConnectTimer.Enabled := False;
                        DBSocket.Close;
                        MainLogMsgList.Free;
                        LogStringList.Free;
                        LogonCostLogList.Free;
                        g_MapManager.Free;
                        ItemUnit.Free;
                        NoticeManager.Free;
                        g_GuildManager.Free;
                        Exit;
                      end;
                    end
                    else
                    begin
                      FrontEngine.Free;
                      MagicManager.Free;
                      UserEngine.Free;
                      if g_RobotManage <> nil then
                        g_RobotManage.Free;

                      g_SQlEngine.Terminate;
                      g_DBSQL.Free;
                      g_SQlEngine.Free;

                      RunSocket.Free;
                      ConnectTimer.Enabled := False;
                      DBSocket.Close;
                      MainLogMsgList.Free;
                      LogStringList.Free;
                      LogonCostLogList.Free;
                      g_MapManager.Free;
                      ItemUnit.Free;
                      NoticeManager.Free;
                      g_GuildManager.Free;
                      Exit;
                    end;
                  finally
                    ireg2.CloseKey;
                    ireg2.Free;
                  end;
                end;
              end
              else
              begin
                FrontEngine.Free;
                MagicManager.Free;
                UserEngine.Free;
                if g_RobotManage <> nil then
                  g_RobotManage.Free;

                g_SQlEngine.Terminate;
                g_DBSQL.Free;
                g_SQlEngine.Free;

                RunSocket.Free;
                ConnectTimer.Enabled := False;
                DBSocket.Close;
                MainLogMsgList.Free;
                LogStringList.Free;
                LogonCostLogList.Free;
                g_MapManager.Free;
                ItemUnit.Free;
                NoticeManager.Free;
                g_GuildManager.Free;
                Exit;
              end;
            end;
          end
          else
          begin
            FrontEngine.Free;
            MagicManager.Free;
            UserEngine.Free;
            if g_RobotManage <> nil then
              g_RobotManage.Free;

            g_SQlEngine.Terminate;
            g_DBSQL.Free;
            g_SQlEngine.Free;

            RunSocket.Free;
            ConnectTimer.Enabled := False;
            DBSocket.Close;
            MainLogMsgList.Free;
            LogStringList.Free;
            LogonCostLogList.Free;
            g_MapManager.Free;
            ItemUnit.Free;
            NoticeManager.Free;
            g_GuildManager.Free;
            Exit;
          end;
        finally
          ireg.CloseKey;
          ireg.Free;
          ireg3.CloseKey;
          ireg3.Free;
          Ss.Free;
        end;
        //Application.ProcessMessages;
        pWork := pWork.Next;
      end;
    end;
    FreeMem(pAI);

    ///////////////////////////////////////////////
    ireg := TRegistry.Create;
    ireg.RootKey := HKEY_LOCAL_MACHINE;
    ireg3 := TRegistry.Create;
    ireg3.RootKey := HKEY_LOCAL_MACHINE;
    Ss := TStringlist.Create;
    try
      if ireg.OpenKey({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards'), False) then
      begin
        Ss.Clear;
        ireg.GetKeyNames(Ss);
        for i := 0 to Ss.Count - 1 do
        begin

          //过滤
          S := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards') + '\' + Ss[i];
          ireg3.CloseKey;
          if ireg3.OpenKey(S, False) then
          begin
            if (CompareText(ireg3.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ServiceName')),
{$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('{5334FBB0-CB1B-4C7A-97B9-F575C5ACBE4D}')) = 0) or
              (CompareText(ireg3.ReadString({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('ServiceName')),
{$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('{63E80B69-3B83-4C7A-A5F9-3F7397C98A3D}')) = 0) then
              Continue;
          end;

          sDateTime := IntToStr(StrToInt(Ss[i]) - 1);
          sLocalIP := '';
          for j := 1 to 4 - Length(sDateTime) do
            sLocalIP := sLocalIP + '0';
          sLocalIP := sLocalIP + sDateTime;

          S := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\') + sLocalIP;
          ireg2 := TRegistry.Create;
          ireg2.RootKey := HKEY_LOCAL_MACHINE;
          try
            if ireg2.OpenKey(S, False) then
            begin
              Len := ireg2.ReadInteger({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('Characteristics'));
              //ox1 NCF_VIRTUAL 说明组件是个虚拟适配器
              //ox2 NCF_SOFTWARE_ENUMERATED 说明组件是一个软件模拟的适配器
              //ox4 NCF_PHYSICAL 说明组件是一个物理适配器
              //ox8 NCF_HIDDEN 说明组件不显示用户接口
              //ox10 NCF_NO_SERVICE 说明组件没有相关的服务(设备驱动程序)
              //ox20 NCF_NOT_USER_REMOVABLE 说明不能被用户删除(例如，通过控制面板或设备管理器)
              //ox40 NCF_MULTIPORT_INSTANCED_ADAPTER 说明组件有多个端口，每个端口作为单独的设备安装。每个端口有自己的hw_id(组件ID)并可被单独安装，这只适合于EISA适配器
              //ox80 NCF_HAS_UI 说明组件支持用户接口(例如，Advanced Page或CustomerProperties Sheet)
              //ox400 NCF_FILTER 说明组件是一个过滤器

              //如果是虚拟网卡：Characteristics & NCF_VIRTUAL ==NCF_VIRTUAL

              //如果是物理网卡：Characteristics & NCF_PHYSICAL ==NCF_PHYSICAL
              if ((Len and $1) = $1) then
              begin //启用网卡中存在虚拟网卡
                FrontEngine.Free;
                MagicManager.Free;
                UserEngine.Free;
                if g_RobotManage <> nil then
                  g_RobotManage.Free;

                g_SQlEngine.Terminate;
                g_DBSQL.Free;
                g_SQlEngine.Free;

                RunSocket.Free;
                ConnectTimer.Enabled := False;
                DBSocket.Close;
                MainLogMsgList.Free;
                LogStringList.Free;
                LogonCostLogList.Free;
                g_MapManager.Free;
                ItemUnit.Free;
                NoticeManager.Free;
                g_GuildManager.Free;
                Exit;
              end;
            end;
          finally
            ireg2.CloseKey;
            ireg2.Free;
          end;
          //Application.ProcessMessages;
        end;
      end
      else
      begin
        FrontEngine.Free;
        MagicManager.Free;
        UserEngine.Free;
        if g_RobotManage <> nil then
          g_RobotManage.Free;

        g_SQlEngine.Terminate;
        g_DBSQL.Free;
        g_SQlEngine.Free;

        RunSocket.Free;
        ConnectTimer.Enabled := False;
        DBSocket.Close;
        MainLogMsgList.Free;
        LogStringList.Free;
        LogonCostLogList.Free;
        g_MapManager.Free;
        ItemUnit.Free;
        NoticeManager.Free;
        g_GuildManager.Free;
        Exit;
      end;
    finally
      ireg.CloseKey;
      ireg.Free;
      ireg3.CloseKey;
      ireg3.Free;
      Ss.Free;
    end;

  end
  else
  begin
    FrontEngine.Free;
    MagicManager.Free;
    UserEngine.Free;
    if g_RobotManage <> nil then
      g_RobotManage.Free;

    g_SQlEngine.Terminate;
    g_DBSQL.Free;
    g_SQlEngine.Free;

    RunSocket.Free;
    ConnectTimer.Enabled := False;
    DBSocket.Close;
    MainLogMsgList.Free;
    LogStringList.Free;
    LogonCostLogList.Free;
    g_MapManager.Free;
    ItemUnit.Free;
    NoticeManager.Free;
    g_GuildManager.Free;
    Exit;
  end;

  {sLocalIP := '';
  nSize := 5120;
  GetMem(pAI, nSize);
  nRes := GetAdaptersInfo(pAI, nSize);
  if (nRes = ERROR_SUCCESS) then begin
    pWork := pAI;
    pIPAddr := @pWork^.IPAddressList;
    while (pIPAddr <> nil) do begin
      sLocalIP := pIPAddr^.IPAddress;
      pIPAddr := pIPAddr^.Next;
    end;
  end;
  FreeMem(pAI);}
{$I '..\Common\Macros\PROTECT_END.inc'}
{$ELSE}
  PlugInEngine.LoadPlugIn();
  //MemoLog.Lines.Add('正在读取配置信息...');
  DBSocket.Address := g_Config.sDBAddr;
  DBSocket.Port := g_Config.nDBPort;
  sCaption := g_Config.sServerName;
  Caption := Format('%s', [sCaption]);
  LoadServerTable();
  LogUDP.RemoteHost := g_Config.sLogServerAddr;
  LogUDP.RemotePort := g_Config.nLogServerPort;
  Application.OnIdle := AppOnIdle;
  Application.OnException := OnProgramException;
  dwRunDBTimeMax := GetTickCount();
  g_dwStartTick := GetTickCount();
  Timer1.Enabled := True;
  boServiceStarted := True;
  MENU_CONTROL_STOP.Enabled := True;
{$IFEND}
end;

procedure TFrmMain.StopService;
var
  i, ii, iii: Integer;
  List: TList;
  Config: pTConfig;
  pDigItemLists: pTDigItemLists;
begin
  Config := @g_Config;
  MENU_CONTROL_START.Enabled := False;
  MENU_CONTROL_STOP.Enabled := False;
  Timer1.Enabled := False;
  RunTimer.Enabled := False;
  FrmIDSoc.Close;
  GateSocket.Close;
  g_MainMemo := nil;
  SaveItemNumber(True);
  g_CastleManager.Free;
  //g_GuildTerritory.Free;
{$IF USERENGINEMODE = THREADENGINE}
  {ThreadInfo := @Config.UserEngineThread;
  ThreadInfo.boTerminaled := True;
  if WaitForSingleObject(ThreadInfo.hThreadHandle, 1000) <> 0 then
    SuspendThread(ThreadInfo.hThreadHandle);}
  for i := 0 to 2 - 1 do
  begin
    ThreadInfo := @Config.UserEngineThread[i];
    ThreadInfo.boTerminaled := True;
    if WaitForSingleObject(ThreadInfo.hThreadHandle, 1000) <> 0 then
      SuspendThread(ThreadInfo.hThreadHandle);
  end;
{$IFEND}

{$IF DBSOCKETMODE = THREADENGINE}
  ThreadInfo := @Config.DBSOcketThread;
  ThreadInfo.boTerminaled := True;
  if WaitForSingleObject(ThreadInfo.hThreadHandle, 1000) <> 0 then
    SuspendThread(ThreadInfo.hThreadHandle);
{$IFEND}
  FrontEngine.Terminate();
  //FrontEngine.WaitFor;
  FrontEngine.Free;
  MagicManager.Free;
  UserEngine.Free;
  if g_RobotManage <> nil then
    g_RobotManage.Free;

  g_SQlEngine.Terminate;
  g_DBSQL.Free;
  g_SQlEngine.Free;

  RunSocket.Free;
  ConnectTimer.Enabled := False;
  DBSocket.Close;
  MainLogMsgList.Free;
  LogStringList.Free;
  LogonCostLogList.Free;
  g_MapManager.Free;
  ItemUnit.Free;
  NoticeManager.Free;
  g_GuildManager.Free;
  for i := 0 to g_MakeItemList.Count - 1 do
    TStringlist(g_MakeItemList.Objects[i]).Free;
  g_MakeItemList.Free;

  g_xBlockUserList.Free;
  g_AutoLoginList.Free;
  g_DeathWalkingSays.Free;

  for i := 0 to g_BoxItemList.Count - 1 do
  begin
    List := TList(g_BoxItemList.Objects[i]);
    for ii := 0 to List.Count - 1 do
      Dispose(pTBoxItem(List.Items[ii]));
    List.Free;
  end;
  g_BoxItemList.Free;

  for i := 0 to g_DigItemList.Count - 1 do
  begin
    pDigItemLists := pTDigItemLists(g_DigItemList.Objects[i]);
    for ii := Low(TDigItemLists) to High(TDigItemLists) do
    begin
      for iii := 0 to pDigItemLists[ii].Count - 1 do
        Dispose(pTDigItem(pDigItemLists[ii].Items[iii]));
      pDigItemLists[ii].Free;
    end;
  end;
  g_DigItemList.Free;

  for i := 0 to g_RefineItemList.Count - 1 do
  begin
    List := TList(g_RefineItemList.Objects[i]);
    for ii := 0 to List.Count - 1 do
      Dispose(pTRefineItem(List.Items[ii]));
    List.Free;
  end;
  g_RefineItemList.Free;
  g_DenySayMsgList.Free;
  MiniMapList.Free;
  g_UnbindList.Free;
  LineNoticeList.Free;
  QuestDiaryList.Free;
  ItemEventList.Free;
  AbuseTextList.Free;
  g_AllowBindNameList.Free;

  for i := 0 to g_MonSayMsgList.Count - 1 do
  begin
    List := TList(g_MonSayMsgList.Objects[i]);
    for ii := 0 to List.Count - 1 do
      Dispose(pTMonSayMsg(List.Items[ii]));
    List.Free;
  end;
  g_MonSayMsgList.Free;

  g_SayMsgList.Free;
  g_DisableMoveMapList.Free;

  for i := Low(g_MissionList) to High(g_MissionList) do
  begin
    for ii := 0 to g_MissionList[i].Count - 1 do
      TStringlist(g_MissionList[i].Objects[ii]).Free;
    g_MissionList[i].Free;
  end;

  g_ItemNameList.Free;
  g_DisableSendMsgList.Free;
  for i := 0 to g_MonDropLimitLIst.Count - 1 do
    Dispose(pTMonDrop(g_MonDropLimitLIst.Objects[i]));
  g_MonDropLimitLIst.Free;
  g_GuildRankNameFilterList.Free;
  g_UnMasterList.Free;
  g_UnForceMasterList.Free;
  g_GameLogItemNameList.Free;
  g_DenyIPAddrList.Free;
  g_DenyChrNameList.Free;
  g_DenyAccountList.Free;
  g_NoClearMonList.Free;
  {for i := 0 to g_MapEventList.Count - 1 do
    Dispose(pTItemLimit(g_MapEventList.Items[i]));
  g_MapEventList.Free;}
  for i := 0 to g_ItemLimitList.Count - 1 do
    Dispose(pTItemLimit(g_ItemLimitList.Items[i]));
  g_ItemLimitList.Free;
  for i := 0 to g_SaleItemList.Count - 1 do
    Dispose(pTSaleItem(g_SaleItemList.Items[i]));
  g_SaleItemList.Free;
  for i := 0 to g_ShopItemList.Count - 1 do
    Dispose(pTShopItem(g_ShopItemList.Items[i]));
  g_ShopItemList.Free;
  for i := 0 to g_ItemBindIPaddr.Count - 1 do
    Dispose(pTItemBind(g_ItemBindIPaddr.Items[i]));
  for i := 0 to g_ItemBindAccount.Count - 1 do
    Dispose(pTItemBind(g_ItemBindAccount.Items[i]));
  for i := 0 to g_ItemBindCharName.Count - 1 do
    Dispose(pTItemBind(g_ItemBindCharName.Items[i]));
  g_ItemBindIPaddr.Free;
  SaveUserDataList();
  UnInitUserDataList();
  UnInitSuiteItemsList();
  g_ItemBindAccount.Free;
  g_ItemBindCharName.Free;
  PlugInEngine.Free;
  g_UserCmdList.Free;
  g_UpgradeItemList.Free;
  g_PetPickItemList.Free;
  g_HintItemList.Free;
  //g_HWIDFilter.Free;
  g_VariablesList.Free;
  DeleteCriticalSection(g_BlockUserLock);
  DeleteCriticalSection(LogMsgCriticalSection);
  //DeleteCriticalSection(ProcessMsgCriticalSection);
  DeleteCriticalSection(ProcessHumanCriticalSection);
  DeleteCriticalSection(USInterMsgCriticalSection);
  DeleteCriticalSection(SQLCriticalSection);
  //DeleteCriticalSection(NPCListCS);
  //DeleteCriticalSection(UserMgrEngnCriticalSection);
  DeleteCriticalSection(Config.UserIDSection);
  DeleteCriticalSection(UserDBSection);
  //CS_6.Free;
  for i := 0 to g_DynamicVarList.Count - 1 do
    Dispose(pTDynamicVar(g_DynamicVarList.Items[i]));
  g_DynamicVarList.Free;
  boServiceStarted := False;
  MENU_CONTROL_START.Enabled := True;
{$IF USECODE = USEREMOTECODE}
  Dispose(g_Config.Encode6BitBuf);
  Dispose(g_Config.Decode6BitBuf);
{$IFEND}
  g_StartPointManager.Free;
  FrmDB.Free;

  g_EventManager.Free;
  
  g_QFLabelList.Free;
  g_DisTIList.Free;
  g_VCLZip1.Free;
  // g_MapManager.Free;
  g_BaseObject.free;
  //Dispose(g_dwIPNeedInfo);
end;

procedure TFrmMain.MENU_CONTROL_STARTClick(Sender: TObject);
begin
  //  StartService();
end;

procedure TFrmMain.MENU_CONTROL_STOPClick(Sender: TObject);
begin
  //  StopService();
end;

procedure TFrmMain.MENU_OPTION_SERVERCONFIGClick(Sender: TObject);
begin
  FrmServerValue := TFrmServerValue.Create(Owner);
  FrmServerValue.Top := Top + OPENTOPLEN;
  FrmServerValue.Left := Left;
  FrmServerValue.AdjuestServerConfig();
  FrmServerValue.Free;
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  frmGeneralConfig := TfrmGeneralConfig.Create(Owner);
  frmGeneralConfig.Top := Top + OPENTOPLEN;
  frmGeneralConfig.Left := Left;
  frmGeneralConfig.Open();
  frmGeneralConfig.Free;
  Caption := g_Config.sServerName;
end;

procedure TFrmMain.MENU_OPTION_GAMEClick(Sender: TObject);
begin
  frmGameConfig := TfrmGameConfig.Create(Owner);
  frmGameConfig.Top := Top + OPENTOPLEN;
  frmGameConfig.Left := Left;
  frmGameConfig.Open;
  frmGameConfig.Free;
end;

procedure TFrmMain.MENU_OPTION_FUNCTIONClick(Sender: TObject);
begin
  frmFunctionConfig := TfrmFunctionConfig.Create(Owner);
  frmFunctionConfig.Top := Top + OPENTOPLEN;
  frmFunctionConfig.Left := Left;
  frmFunctionConfig.Open;
  frmFunctionConfig.Free;
end;

procedure TFrmMain.G1Click(Sender: TObject);
begin
  frmGameCmd := TfrmGameCmd.Create(Owner);
  frmGameCmd.Top := Top + OPENTOPLEN;
  frmGameCmd.Left := Left;
  frmGameCmd.Open;
  frmGameCmd.Free;
end;

procedure TFrmMain.DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
{$IF USEWLSDK = 1}
{$I '..\Common\Macros\VMPB.inc'}
  MainOutMessageAPI('数据库服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')连接成功...');
  FrontEngine.AddToLoadIPList;
{$I '..\Common\Macros\VMPE.inc'}
{$ELSEIF USEWLSDK = 2}
{$I '..\Common\Macros\PROTECT_START.inc'}
  MainOutMessageAPI('数据库服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')连接成功...');
  FrontEngine.AddToLoadIPList;
{$I '..\Common\Macros\PROTECT_END.inc'}
{$ELSE}
{$I '..\Common\Macros\VMPB.inc'}
  MainOutMessageAPI('数据库服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')连接成功...');
{$I '..\Common\Macros\VMPE.inc'}
{$IFEND}

end;

procedure TFrmMain.MENU_OPTION_MONSTERClick(Sender: TObject);
begin
  frmMonsterConfig := TfrmMonsterConfig.Create(Owner);
  frmMonsterConfig.Top := Top + OPENTOPLEN;
  frmMonsterConfig.Left := Left;
  frmMonsterConfig.Open;
  frmMonsterConfig.Free;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MONSTERSAYClick(Sender: TObject);
begin
  UserEngine.ClearMonSayMsg();
  LoadMonSayMsg();
  MainOutMessageAPI('重新加载怪物说话配置完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_DISABLEMAKEClick(Sender: TObject);
begin
  LoadItemLimitList();
  LoadDisableMoveMap();
  ItemUnit.LoadCustomItemName();
  LoadDisableSendMsgList();
  LoadGameLogItemNameList();
  LoadItemBindIPaddr();
  LoadItemBindAccount();
  LoadItemBindCharName();
  LoadUnMasterList();
  LoadUnForceMasterList();
  LoadDenyIPAddrList();
  LoadDenyAccountList();
  LoadDenyChrNameList();
  LoadNoClearMonList();
  FrmDB.LoadAdminList();
  MainOutMessageAPI('重新加载列表配置完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_STARTPOINTClick(Sender: TObject);
var
  S: string;
begin
  //FrmDB.LoadStartPoint();
  //if g_nCheckLicense^ < 0 then Exit;
  if g_StartPointManager.Initialize(S) then
    MemoLog.Lines.Add('重新加载回城点配置成功...')
  else
    MemoLog.Lines.Add(S + ' 地图不存在，加载回城点配置失败...');
end;

procedure TFrmMain.MENU_CONTROL_GATE_OPENClick(Sender: TObject);
resourcestring
  sGatePortOpen = '游戏网关端口(%s:%d)已打开...';
begin
  if not GateSocket.Active then
  begin
    GateSocket.Active := True;
    MainOutMessageAPI(Format(sGatePortOpen, [GateSocket.Address, GateSocket.Port]));
  end;
end;

procedure TFrmMain.MENU_CONTROL_GATE_CLOSEClick(Sender: TObject);
begin
  CloseGateSocket();
end;

procedure TFrmMain.CloseGateSocket;
var
  i: Integer;
resourcestring
  sGatePortClose = '游戏网关端口(%s:%d)已关闭...';
begin
  if GateSocket.Active then
  begin
    for i := 0 to GateSocket.Socket.ActiveConnections - 1 do
      GateSocket.Socket.Connections[i].Close;
    GateSocket.Active := False;
    MainOutMessageAPI(Format(sGatePortClose, [GateSocket.Address, GateSocket.Port]));
  end;
end;

procedure TFrmMain.MENU_CONTROLClick(Sender: TObject);
begin
  if GateSocket.Active then
  begin
    MENU_CONTROL_GATE_OPEN.Enabled := False;
    MENU_CONTROL_GATE_CLOSE.Enabled := True;
  end
  else
  begin
    MENU_CONTROL_GATE_OPEN.Enabled := True;
    MENU_CONTROL_GATE_CLOSE.Enabled := False;
  end;
end;

procedure UserEngineProcess(Config: pTConfig; ThreadInfo: pTThreadInfo);
var
  nRunTime: Integer;
  dwRunTick: LongWord;
begin
  l_dwRunTimeTick := 0;
  dwRunTick := GetTickCount();
  ThreadInfo.dwRunTick := dwRunTick;
  while not ThreadInfo.boTerminaled do
  begin
    nRunTime := GetTickCount - ThreadInfo.dwRunTick;

    if ThreadInfo.nRunTime < nRunTime then
      ThreadInfo.nRunTime := nRunTime;

    if ThreadInfo.nMaxRunTime < nRunTime then
      ThreadInfo.nMaxRunTime := nRunTime;

    if GetTickCount - dwRunTick >= 1000 then
    begin
      dwRunTick := GetTickCount();
      if ThreadInfo.nRunTime > 0 then
        Dec(ThreadInfo.nRunTime);                      
    end;

    ThreadInfo.dwRunTick := GetTickCount();
    ThreadInfo.boActived := True;
    ThreadInfo.nRunFlag := 125;
    //if Config.boThreadRun then
    ProcessGameRun();
    Sleep(1);
    //SleepEx(1, True);
  end;
end;

procedure UserEngineThread(ThreadInfo: pTThreadInfo); stdcall;
var
  nErrorCount: Integer;
resourcestring
  sExceptionMsg = '[Exception] UserEngineThread ErrorCount = %d';
begin
  {nErrorCount := 0;
  while True do begin
    try
      UserEngineProcess(ThreadInfo.Config, ThreadInfo);
      Break;
    except
      Inc(nErrorCount);
      if nErrorCount > 10 then
        Break;
      MainOutMessageAPI(Format(sExceptionMsg, [nErrorCount]));
    end;
  end;
  ExitThread(0);}
  try
    UserEngineProcess(ThreadInfo.Config, ThreadInfo);
    ExitThread(0);
  except
    MainOutMessageAPI(Format(sExceptionMsg, [nErrorCount]));
  end;
end;

procedure ProcessDenySayMsgList();
var
  i: Integer;
begin
  g_DenySayMsgList.Lock;
  try
    for i := g_DenySayMsgList.Count - 1 downto 0 do
      if GetTickCount > LongWord(g_DenySayMsgList.Objects[i]) then
        g_DenySayMsgList.Delete(i);
  finally
    g_DenySayMsgList.UnLock;
  end;
end;

procedure ProcessGameRun();
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    UserEngine.PrcocessData;

    if g_RobotManage <> nil then
      g_RobotManage.Run;

    g_EventManager.Run();

    if GetTickCount - l_dwRunTimeTick > 10 * 1000 then
    begin //0410
      l_dwRunTimeTick := GetTickCount();
      g_GuildManager.Run;
      g_CastleManager.Run;
      ProcessDenySayMsgList();
    end;

  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.MENU_VIEW_GATEClick(Sender: TObject);
begin
  MENU_VIEW_GATE.Checked := not MENU_VIEW_GATE.Checked;
  GridGate.Visible := MENU_VIEW_GATE.Checked;
end;

procedure TFrmMain.MENU_VIEW_SESSIONClick(Sender: TObject);
begin
  frmViewSession := TfrmViewSession.Create(Owner);
  frmViewSession.Top := Top + OPENTOPLEN;
  frmViewSession.Left := Left;
  frmViewSession.Open();
  frmViewSession.Free;
end;

procedure TFrmMain.MENU_VIEW_ONLINEHUMANClick(Sender: TObject);
begin
{$IF USEWLSDK = 1}
  frmViewOnlineHuman := TfrmViewOnlineHuman.Create(Owner);
  frmViewOnlineHuman.Top := Top + OPENTOPLEN;
  frmViewOnlineHuman.Left := Left;
  frmViewOnlineHuman.Open();
  frmViewOnlineHuman.Free;
{$ELSEIF USEWLSDK = 2}
  frmViewOnlineHuman := TfrmViewOnlineHuman.Create(Owner);
  frmViewOnlineHuman.Top := Top + OPENTOPLEN;
  frmViewOnlineHuman.Left := Left;
  frmViewOnlineHuman.Open();
  frmViewOnlineHuman.Free;
{$ELSEIF USEWLSDK = 0}
  frmViewOnlineHuman := TfrmViewOnlineHuman.Create(Owner);
  frmViewOnlineHuman.Top := Top + OPENTOPLEN;
  frmViewOnlineHuman.Left := Left;
  frmViewOnlineHuman.Open();
  frmViewOnlineHuman.Free;
{$IFEND USEWLSDK}
end;

procedure TFrmMain.MENU_VIEW_LEVELClick(Sender: TObject);
begin
  frmViewLevel := TfrmViewLevel.Create(Owner);
  frmViewLevel.Top := Top + OPENTOPLEN;
  frmViewLevel.Left := Left;
  frmViewLevel.Open();
  frmViewLevel.Free;
end;

procedure TFrmMain.MENU_VIEW_LISTClick(Sender: TObject);
begin
  frmViewList := TfrmViewList.Create(Owner);
  frmViewList.Top := Top + OPENTOPLEN;
  frmViewList.Left := Left;
  frmViewList.Open();
  frmViewList.Free;
end;

procedure TFrmMain.MENU_MANAGE_ONLINEMSGClick(Sender: TObject);
begin
  frmOnlineMsg := TfrmOnlineMsg.Create(Owner);
  frmOnlineMsg.Top := Top + OPENTOPLEN;
  frmOnlineMsg.Left := Left;
  frmOnlineMsg.Open();
  frmOnlineMsg.Free;
end;

procedure TFrmMain.MENU_VIEW_KERNELINFOClick(Sender: TObject);
begin
  frmViewKernelInfo := TfrmViewKernelInfo.Create(Owner);
  frmViewKernelInfo.Top := Top + OPENTOPLEN;
  frmViewKernelInfo.Left := Left;
  frmViewKernelInfo.Open();
  frmViewKernelInfo.Free;
end;

procedure TFrmMain.MENU_TOOLS_MERCHANTClick(Sender: TObject);
begin
  frmConfigMerchant := TfrmConfigMerchant.Create(Owner);
  frmConfigMerchant.Top := Top + OPENTOPLEN;
  frmConfigMerchant.Left := Left;
  frmConfigMerchant.Open();
  frmConfigMerchant.Free;
end;

procedure TFrmMain.MENU_OPTION_ITEMFUNCClick(Sender: TObject);
begin
  frmItemSet := TfrmItemSet.Create(Owner);
  frmItemSet.Top := Top + OPENTOPLEN;
  frmItemSet.Left := Left;
  frmItemSet.Open();
  frmItemSet.Free;
end;

procedure TFrmMain.ClearMemoLog;
begin
  if Application.MessageBox('是否确定清除日志信息？', '提示信息', MB_YESNO + MB_ICONQUESTION) = mrYes then
    MemoLog.Clear;
end;

procedure TFrmMain.MENU_TOOLS_MONGENClick(Sender: TObject);
begin
  frmConfigMonGen := TfrmConfigMonGen.Create(Owner);
  frmConfigMonGen.Top := Top + OPENTOPLEN;
  frmConfigMonGen.Left := Left;
  frmConfigMonGen.Open();
  frmConfigMonGen.Free;
end;

procedure TFrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  wIdent: Word;
begin
  wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    GS_QUIT:
      begin
        g_boExitServer := True;
        CloseGateSocket();
        g_Config.boKickAllUser := True;
        CloseTimer.Enabled := True;
      end;
  end;
end;

procedure TFrmMain.MyTestMessage(var msg: TMessage);
begin
  if (msg.wParam = 1) then
  begin
    LbRunTime.Caption := '该版本即将过期，请更新';
    LbRunTime.Font.Color := clRed;
  end
  else if (msg.wParam = 2) then
  begin
    LbRunTime.Caption := '该版本已停用!!';
    LbRunTime.Font.Color := clRed;
  end;

end;

procedure TFrmMain.N2Click(Sender: TObject);
var
  i: Integer;
  sAccount, sName: string;
begin
  if g_InitAutoLogin then
    Exit;

  LoadAutoLogin();

  if not DBSocketConnected() then
  begin
    MemoLog.Lines.Add('DBS未连接，不能加载自动挂机人物！');
    Exit;
  end;
  if (g_AutoLoginList.Count = 0) then
  begin
    MemoLog.Lines.Add('自动挂机人物列表为空，无法加载！');
    Exit;
  end;

  //EnterCriticalSection(ProcessHumanCriticalSection);
  //try
  for i := 0 to g_AutoLoginList.Count - 1 do
  begin
    sName := GetValidStr3(g_AutoLoginList[i], sAccount, [' ', #9]);
    if (sName <> '') and (sAccount <> '') then
    begin
      FrontEngine.AddToLoadRcdList(sAccount,
        sName,
        g_sAutoLogin,
        4,
        0,
        1, //PlayObject.m_nPayMent,
        1, //PlayObject.m_nPayMode,
        g_Config.nSoftVersionDate,
        -1, //PlayObject.m_nSocket,
        -1, //PlayObject.m_nGSocketIdx,
        -1, //PlayObject.m_nGateIdx,
        '',
        nil);
    end;
  end;

  g_InitAutoLogin := True;
  N2.Enabled := False;
  //finally
  //  LeaveCriticalSection(ProcessHumanCriticalSection);
  //end;
end;

procedure TFrmMain.N4Click(Sender: TObject);
begin
  LoadAllowBindNameList();
  MainOutMessageAPI(Format('重新加载允许绑定名字列表成功(%d)...', [g_AllowBindNameList.Count]));
end;

procedure TFrmMain.N6Click(Sender: TObject);
begin
  //
  N6.Checked := not N6.Checked;
  g_Config.boViewWhisper := N6.Checked;
end;

procedure TFrmMain.N7Click(Sender: TObject);
begin
  MainOutMessageAPI('正在重新加载地图挖宝配置...');
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if LoadDigItemList(True) then
      MainOutMessageAPI('重新加载地图挖宝配置完成...')
    else
      MainOutMessageAPI('重新加载地图挖宝配置失败！！！')
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.DECODESCRIPTClick(Sender: TObject);
begin
  //
end;

procedure TFrmMain.MENU_TOOLS_IPSEARCHClick(Sender: TObject);
var
  sIPaddr: string;
begin
  sIPaddr := '192.168.0.1';
  if not BLUE_InputQuery('IP所在地区查询', '请输入IP地址:', sIPaddr) then
    Exit;
  if not IsIPaddr(sIPaddr) then
  begin
    Application.MessageBox('输入的IP地址格式不正确', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
{$IF EXPIPLOCAL=1}
  MemoLog.Lines.Add(Format('%s: %s', [sIPaddr, GetIPLocal(sIPaddr)]));
{$ELSE}
  MemoLog.Lines.Add(Format('%s: %s', [sIPaddr, '未知']));
{$IFEND}
end;

procedure TFrmMain.MENU_MANAGE_CASTLEClick(Sender: TObject);
begin
  frmCastleManage := TfrmCastleManage.Create(Owner);
  frmCastleManage.Top := Top + OPENTOPLEN;
  frmCastleManage.Left := Left;
  frmCastleManage.Open();
  frmCastleManage.Free;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_SABAKClick(Sender: TObject);
begin
  try
    g_CastleManager.ReInit();
    g_CastleManager.Initialize;
  finally
    MainOutMessageAPI('重新加载沙巴克数据完成...');
  end;
end;

procedure TFrmMain.MENU_TOOLS_NPCClick(Sender: TObject);
begin
  frmConfigMerchant := TfrmConfigMerchant.Create(Owner);
  frmConfigMerchant.Top := Top + OPENTOPLEN;
  frmConfigMerchant.Left := Left;
  frmConfigMerchant.Open();
  frmConfigMerchant.Free;
end;

procedure TFrmMain.MENU_VIEW_HIGHRANKClick(Sender: TObject);
begin
  frmHighRank := TfrmHighRank.Create(Owner);
  frmHighRank.Top := Top + OPENTOPLEN;
  frmHighRank.Left := Left;
  frmHighRank.Open();
  frmHighRank.Free;
end;

procedure TFrmMain.MENU_MANAGE_PLUGClick(Sender: TObject);
begin
  ftmPlugInManage := TftmPlugInManage.Create(Owner);
  ftmPlugInManage.Top := Top + OPENTOPLEN;
  ftmPlugInManage.Left := Left;
  ftmPlugInManage.Open();
  ftmPlugInManage.Free;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_QMagegeScriptClickClick(Sender: TObject);
begin
{.$I '..\Common\Macros\VMPB.inc'}
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if g_ManageNPC <> nil then
    begin
      g_ManageNPC.ClearScript();
      g_ManageNPC.LoadNpcScript();
      MainOutMessageAPI('重新加载登录脚本完成...');
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
{.$I '..\Common\Macros\VMPE.inc'}
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_QFUNCTIONSCRIPTClick(Sender: TObject);
begin
{.$I '..\Common\Macros\VMPB.inc'}
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if g_FunctionNPC <> nil then
    begin
      g_FunctionNPC.ClearScript();
      g_FunctionNPC.LoadNpcScript();
      MainOutMessageAPI('重新加载功能脚本完成...');
    end;
    if g_MapEventNPC <> nil then
    begin
      g_MapEventNPC.ClearScript();
      g_MapEventNPC.LoadNpcScript();
      MainOutMessageAPI('重新加载事件脚本完成...');
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
{.$I '..\Common\Macros\VMPE.inc'}
end;

procedure TFrmMain.mniAllNpcClick(Sender: TObject);
begin

  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    FrmDB.ReLoadMerchants();
    UserEngine.ReloadMerchantList();
    MainOutMessageAPI('交易NPC重新加载完成');
    UserEngine.ReloadNpcList();
    MainOutMessageAPI('管理NPC重新加载完成');
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.MemStatusClick(Sender: TObject);
resourcestring
  sWebSite = 'http://www.ramm2.com';
begin
  ShellExecute(Handle, nil, PChar(sWebSite), nil, nil, sw_shownormal);
end;

procedure TFrmMain.MENU_TOOLS_TESTClick(Sender: TObject);
type
  TpExecute = function(): string;
begin
  if (nPulgProc15 >= 0) and Assigned(PlugProcArray[nPulgProc15].nProcAddr) then
    MainOutMessageAPI(TpExecute(PlugProcArray[nPulgProc15].nProcAddr));
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_BOXITEMClick(Sender: TObject);
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if FrmDB.LoadBoxItem > 0 then
      MemoLog.Lines.Add('重新加载宝箱物品信息成功...')
    else
      MemoLog.Lines.Add('重新加载宝箱物品信息失败...');
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_REFINEITEMClick(Sender: TObject);
begin
{$IF USEWLSDK = 1}
{$I '..\Common\Macros\Registered_Start.inc'}
{$IFEND USEWLSDK}
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if FrmDB.LoadRefineItem > 0 then
      MemoLog.Lines.Add('重新加载淬炼物品信息成功...')
    else
      MemoLog.Lines.Add('重新加载淬炼物品信息失败...');
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
{$IF USEWLSDK = 1}
{$I '..\Common\Macros\Registered_End.inc'}
{$IFEND USEWLSDK}
end;

procedure TFrmMain.MENU_HELP_ABOUTClick(Sender: TObject);
begin
  MainOutMessageAPI(sProgram + sOwen);
  MainOutMessageAPI(sUpdate);
  MainOutMessageAPI(sWebSite);
  MainOutMessageAPI(sBbsSite);
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
var
  i:Integer;
  P:pTStartPointCustom;
  P1:pTNpcCustom;
  p2:pTStartPointRegion;
begin
  if g_GobalPlayer <> nil then
  begin
    g_GobalPlayer.Free;
    g_GobalPlayer := nil;
  end;
  if g_FileCustomList_Server <> nil then
  begin
    g_FileCustomList_Server.Clear;
    g_FileCustomList_Server.Free;                    
    g_FileCustomList_Server := nil;
  end;

  if g_StartPointRegionList_Server <> nil then
  begin
    for i := 0 to g_StartPointRegionList_Server.count -1 do
    begin
      p2 := g_StartPointRegionList_Server.items[i];
      DeleteObject(P2.rgn);
      Dispose(P2);
    end;
    g_StartPointRegionList_Server.clear;
    g_StartPointRegionList_Server.free;             
    g_StartPointRegionList_Server := nil;
  end;

  if g_StartPointCustomList_Server <> nil then
  begin
    for i := 0 to (g_StartPointCustomList_Server.Count - 1) do
    begin
      P := g_StartPointCustomList_Server.Items[i];
      Dispose(P);
    end;
    g_StartPointCustomList_Server.Clear;
    g_StartPointCustomList_Server.free;           
    g_StartPointCustomList_Server := nil;
  end;

  if g_NpcCustomList_Server <> nil then
  begin
    for i := 0 to (g_NpcCustomList_Server.Count - 1) do
    begin
      P1 := g_NpcCustomList_Server.Items[i];
      Dispose(P1);
    end;
    g_NpcCustomList_Server.Clear;
    g_NpcCustomList_Server.Free;                
    g_NpcCustomList_Server := nil;
  end;
end;

procedure TFrmMain.N10Click(Sender: TObject);
begin
 try
   LoadStartPointCustom();
   MainOutMessageAPI('重新加载自定义安全区光环效果完成...');
 except
 end;
end;

procedure TFrmMain.N9Click(Sender: TObject);
begin
 try
   LoadFileListCustom();
   MainOutMessageAPI('重新加载自定义资源文件列表完成...');
 except
 end;

end;

procedure TFrmMain.N12Click(Sender: TObject);
begin
  ftmImageFileCustom := TftmImageFileCustom.Create(Owner);
  ftmImageFileCustom.Top := Top + OPENTOPLEN;
  ftmImageFileCustom.Left := Left;
  ftmImageFileCustom.Open();
  ftmImageFileCustom.Free;
end;

procedure TFrmMain.N13Click(Sender: TObject);
begin
  ftmSafeZoneEffectsCustom := TftmSafeZoneEffectsCustom.Create(Owner);
  ftmSafeZoneEffectsCustom.Top := Top + OPENTOPLEN;
  ftmSafeZoneEffectsCustom.Left := Left;
  ftmSafeZoneEffectsCustom.Open();
  ftmSafeZoneEffectsCustom.Free;
end;

procedure TFrmMain.NPC1Click(Sender: TObject);
begin
 try
   LoadNpcCustom();
   MainOutMessageAPI('重新加载自定义NPC效果完成...');
 except
 end;
end;

procedure TFrmMain.NPC2Click(Sender: TObject);
begin
  ftmNpcCustom := TftmNpcCustom.Create(Owner);
  ftmNpcCustom.Top := Top + OPENTOPLEN;
  ftmNpcCustom.Left := Left;
  ftmNpcCustom.Open();
  ftmNpcCustom.Free;
end;

procedure TFrmMain.N14Click(Sender: TObject);
begin
  ftmSafeZoneControlCustom := TftmSafeZoneControlCustom.Create(Owner);
  ftmSafeZoneControlCustom.Top := Top + OPENTOPLEN;
  ftmSafeZoneControlCustom.Left := Left;
  ftmSafeZoneControlCustom.Open();
  ftmSafeZoneControlCustom.Free;
end;

initialization

finalization

end.
