unit DBSMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls,
  Buttons, Menus, Grobal2, D7ScktComp, ComCtrls, Grids, ipinfo_dll, GList;
type
  TFindCallBack = procedure(const sFileName: string; var boQuit: Boolean);
  TFrmDBSrv = class(TForm)
    ServerSocket: TServerSocket;
    StartTimer: TTimer;
    MemoLog: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    LbAutoClean: TLabel;
    LbTransCount: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    LbUserCount: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    CkViewHackMsg: TCheckBox;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    V1: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_MANAGE: TMenuItem;
    MENU_OPTION_GAMEGATE: TMenuItem;
    N1: TMenuItem;
    G1: TMenuItem;
    MENU_MANAGE_DATA: TMenuItem;
    MENU_MANAGE_TOOL: TMenuItem;
    MENU_TEST: TMenuItem;
    MENU_TEST_SELGATE: TMenuItem;
    X1: TMenuItem;
    L1: TMenuItem;
    A1: TMenuItem;
    C1: TMenuItem;
    Label5: TLabel;
    I1: TMenuItem;
    C2: TMenuItem;
    N3: TMenuItem;
    SpeedButtonDBManageTools: TSpeedButton;
    BtnEditAddrs: TSpeedButton;
    BtnUserDBTool: TSpeedButton;
    MainInfoTimer: TTimer;
    CheckBoxConnect: TCheckBox;
    F1: TMenuItem;
    dTimer: TTimer;
    btnReloadLR: TSpeedButton;
    GridGate: TStringGrid;
    EditSpaceChar: TEdit;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure BtnUserDBToolClick(Sender: TObject);
    procedure BtnReloadAddrClick(Sender: TObject);
    procedure BtnEditAddrsClick(Sender: TObject);
    procedure CkViewHackMsgClick(Sender: TObject);
    procedure ServerSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure MENU_MANAGE_DATAClick(Sender: TObject);
    procedure MENU_MANAGE_TOOLClick(Sender: TObject);
    procedure MENU_TEST_SELGATEClick(Sender: TObject);
    procedure X1Click(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure MENU_OPTION_GAMEGATEClick(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure MemoLogDblClick(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure SpeedButtonDBManageToolsClick(Sender: TObject);
    procedure MainInfoTimerTimer(Sender: TObject);
    procedure F1Click(Sender: TObject);
    procedure dTimerTimer(Sender: TObject);
    procedure btnReloadLRClick(Sender: TObject);
    procedure GridGateSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    m_DefMsg: TDefaultMessage;
    m_nServerPacket: Integer;
    m_sHumData: string;
    ServerList: TList;
    m_boRemoteClose: Boolean;
    m_Filelist: TStrings;
    m_nFilelistPos: Integer;

    procedure ProcessServerPacket(ServerInfo: pTServerInfo);
    procedure ProcessServerMsg(sMsg: string; nLen: Integer; Socket: TCustomWinSocket);
    procedure SendSocket(Socket: TCustomWinSocket; sMsg: string);
    procedure SendSocket2(Socket: TCustomWinSocket; sMsg: string);
    procedure LoadHumanRcd(sMsg: string; Socket: TCustomWinSocket);
    procedure LoadHeros(sMsg: string; Socket: TCustomWinSocket);
    procedure SaveHumanRcd(nRecog: Integer; sMsg: string; Socket: TCustomWinSocket);
    procedure SaveHumanRcdEx(sMsg: string; nRecog: Integer; Socket: TCustomWinSocket);
    procedure GetRemovedIP(sMsg: string; Socket: TCustomWinSocket);
    procedure QueryLevelRankData(nType, nPage: Integer; sCharName: string; Socket: TCustomWinSocket);
    //procedure ScanFile; dynamic;
    procedure RenewLevelRankData();
    //procedure MakeNewHero(sMsg: string; Socket: TCustomWinSocket);
    { Private declarations }
  public
    procedure GetLoadHumanRcd(sAccount, sHumName: string);
    function CopyHumData(sSrcChrName, sDestChrName, sUserId: string): Boolean;
    procedure DelHum(sChrName: string);
    procedure OnProgramException(Sender: TObject; E: Exception);
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    { Public declarations }
  end;

procedure RunDosCommand(Command: string; Output: TStrings);

var
  FrmDBSrv: TFrmDBSrv;

implementation

uses{$IFDEF SQLDB}HumDB_SQL{$ELSE}HumDB{$ENDIF}, DBShare, FIDHum, UsrSoc, AddrEdit, HUtil32, EDcode, LocalDB, IDSocCli, DBTools,
  TestSelGate, RouteManage, SDK, FDBexpl, frmConfig, __DESUnit, MudUtil;

{$R *.DFM}

procedure RunDosCommand(Command: string; Output: TStrings);
var
  hReadPipe: THandle;
  hWritePipe: THandle;
  SI: TStartUpInfo;
  Pi: TProcessInformation;
  SA: TSecurityAttributes;
  BytesRead: DWORD;
  Dest: array[0..5120 - 1] of Char;
  CmdLine: array[0..512] of Char;
  TmpList: TStringList;
  Avail, ExitCode, wrResult: DWORD;
  osVer: TOSVERSIONINFO;
  tmpstr: AnsiString;
begin
  osVer.dwOSVersionInfoSize := SizeOf(TOSVERSIONINFO);
  GetVersionEx(osVer);
  if osVer.dwPlatformId = VER_PLATFORM_WIN32_NT then
  begin
    SA.nLength := SizeOf(SA);
    SA.lpSecurityDescriptor := nil;
    SA.bInheritHandle := True;
    CreatePipe(hReadPipe, hWritePipe, @SA, 0);
  end
  else
    CreatePipe(hReadPipe, hWritePipe, nil, 1024);
  try
    Screen.Cursor := crHourglass;
    FillChar(SI, SizeOf(SI), 0);
    SI.cb := SizeOf(TStartUpInfo);
    SI.wShowWindow := SW_HIDE;
    SI.dwFlags := STARTF_USESHOWWINDOW;
    SI.dwFlags := SI.dwFlags or STARTF_USESTDHANDLES;
    SI.hStdOutput := hWritePipe;
    SI.hStdError := hWritePipe;
    StrPCopy(CmdLine, Command);
    if CreateProcess(nil, CmdLine, nil, nil, True, NORMAL_PRIORITY_CLASS, nil, nil, SI, Pi) then
    begin
      ExitCode := 0;
      while ExitCode = 0 do
      begin
        wrResult := WaitForSingleObject(Pi.hProcess, 500);
        if PeekNamedPipe(hReadPipe, @Dest[0], SizeOf(Dest), @Avail, nil, nil) then
        begin
          if Avail > 0 then
          begin
            TmpList := TStringList.Create;
            try
              FillChar(Dest, SizeOf(Dest), 0);
              ReadFile(hReadPipe, Dest[0], Avail, BytesRead, nil);
              tmpstr := Copy(Dest, 0, BytesRead - 1);
              TmpList.Text := tmpstr;
              Output.AddStrings(TmpList);
            finally
              TmpList.Free;
            end;
          end;
        end;
        if wrResult <> WAIT_TIMEOUT then
          ExitCode := 1;
      end;
      GetExitCodeProcess(Pi.hProcess, ExitCode);
      CloseHandle(Pi.hProcess);
      CloseHandle(Pi.hThread);
    end;
  finally
    CloseHandle(hReadPipe);
    CloseHandle(hWritePipe);
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmDBSrv.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  wIdent: Word;
begin
  wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    GS_QUIT:
      begin
        ServerSocket.Active := False;
        m_boRemoteClose := True;
        Close();
      end;
  end;
end;

procedure TFrmDBSrv.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  sIPaddr: string;
  ServerInfo: pTServerInfo;
resourcestring
  sNotAllowServerIP = '非法服务器连接: %s';
  sGateOpen = '游戏中心[%d](%s:%d)已打开...';
begin
  sIPaddr := Socket.RemoteAddress;
  if not CheckServerIP(sIPaddr) then
  begin
    MainOutMessage(Format(sNotAllowServerIP, [sIPaddr]));
    Socket.Close;
    Exit;
  end;
  if not boOpenDBBusy then
  begin
    New(ServerInfo);
    ServerInfo.nSckHandle := Socket.SocketHandle;
    ServerInfo.sStr := '';
    ServerInfo.Socket := Socket;
    ServerList.Add(ServerInfo);
    MainOutMessage(Format(sGateOpen, [ServerList.Count - 1, Socket.RemoteAddress, Socket.RemotePort]));
    dwCheckServerTick := GetTickCount();
    dwCheckServerTimeMin := 0;
    dwCheckServerTimeMax := 0;
  end
  else
    Socket.Close;
end;

procedure TFrmDBSrv.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: Integer;
  ServerInfo: pTServerInfo;
resourcestring
  sGateClose = '游戏中心[%d](%s:%d)已关闭...';
begin
  for i := 0 to ServerList.Count - 1 do
  begin
    ServerInfo := ServerList.Items[i];
    if ServerInfo.nSckHandle = Socket.SocketHandle then
    begin
      Dispose(ServerInfo);
      ServerList.Delete(i);
      MainOutMessage(Format(sGateClose, [i, Socket.RemoteAddress, Socket.RemotePort]));
      Break;
    end;
  end;
end;

procedure TFrmDBSrv.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmDBSrv.ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i: Integer;
  ServerInfo: pTServerInfo;
  sMsg: string;
begin
  sMsg := Socket.ReceiveText;
  for i := 0 to ServerList.Count - 1 do
  begin
    ServerInfo := ServerList.Items[i];
    if ServerInfo.nSckHandle = Socket.SocketHandle then
    begin
      Inc(g_nServerSocket);
      if sMsg <> '' then
      begin
        ServerInfo.sStr := ServerInfo.sStr + sMsg;
        if Pos('!', sMsg) > 0 then
        begin
          ProcessServerPacket(ServerInfo);
          Inc(g_nProcSvrPacket);
          Inc(m_nServerPacket);
          Break;
        end
        else if Length(ServerInfo.sStr) > 81920 then
        begin
          ServerInfo.sStr := '';
          Inc(n4ADC2C);
        end;
      end;
      Break;
    end;
  end;
end;

procedure TFrmDBSrv.ProcessServerPacket(ServerInfo: pTServerInfo);
var
  bo25: Boolean;
  SC, s1C, s20, s24: string;
  n14, n18: Integer;
  wE, w10: Word;
begin
  if boOpenDBBusy then
    Exit;
  try
    bo25 := False;
    s1C := ServerInfo.sStr;
    ServerInfo.sStr := '';
    s20 := '';
    s1C := ArrestStringEx(s1C, '#', '!', s20);
    if s20 <> '' then
    begin
      s20 := GetValidStr3(s20, s24, ['/']);
      n14 := Length(s20);
      if (n14 >= DEFBLOCKSIZE) and (s24 <> '') then
      begin
        wE := Str_ToInt(s24, 0) xor 170;
        w10 := n14;
        n18 := MakeLong(wE, w10);
        SC := EncodeBuffer(@n18, SizeOf(Integer));
        m_sHumData := s24;
        if CompareBackLStr(s20, SC, Length(SC)) then
        begin
          ProcessServerMsg(s20, n14, ServerInfo.Socket);
          bo25 := True;
        end;
      end;
    end;
    if s1C <> '' then
    begin
      Inc(g_nErrSvrPacket);
      Label4.Caption := 'E:' + IntToStr(g_nErrSvrPacket);
    end;
    if not bo25 then
    begin
      m_DefMsg := MakeDefaultMsg(DBR_FAIL, 0, 0, 0, 0);
      SendSocket(ServerInfo.Socket, EncodeMessage(m_DefMsg));
      Inc(g_nErrSvrPacket);
      Label4.Caption := 'E:' + IntToStr(g_nErrSvrPacket);
    end;
  finally
  end;
end;

procedure TFrmDBSrv.SendSocket(Socket: TCustomWinSocket; sMsg: string);
var
  n10: Integer;
  s18: string;
begin
  Inc(g_nSendSvrPacket);
  n10 := MakeLong(Str_ToInt(m_sHumData, 0) xor 170, Length(sMsg) + 6);
  s18 := EncodeBuffer(@n10, SizeOf(Integer));
  Socket.SendText('#' + m_sHumData + '/' + sMsg + s18 + '!')
end;

procedure TFrmDBSrv.SendSocket2(Socket: TCustomWinSocket; sMsg: string);
var
  n10: Integer;
  s18: string;
begin
  Inc(g_nSendSvrPacket);
  n10 := MakeLong(0 xor 170, Length(sMsg) + 6);
  s18 := EncodeBuffer(@n10, SizeOf(Integer));
  Socket.SendText('#0/' + sMsg + s18 + '!');
end;

procedure TFrmDBSrv.ProcessServerMsg(sMsg: string; nLen: Integer; Socket: TCustomWinSocket);
var
  sDefMsg, sData: string;
  DefMsg: TDefaultMessage;
begin
  if nLen = DEFBLOCKSIZE then
  begin
    sDefMsg := sMsg;
    sData := '';
  end
  else
  begin
    sDefMsg := Copy(sMsg, 1, DEFBLOCKSIZE);
    sData := Copy(sMsg, DEFBLOCKSIZE + 1, Length(sMsg) - DEFBLOCKSIZE - 6);
  end;
  DefMsg := DecodeMessage(sDefMsg);
  case DefMsg.Ident of
    DB_LOADHEROS:
      begin
        LoadHeros(sData, Socket);
        dwCheckServerTimeMin := GetTickCount - dwCheckServerTick;
        if dwCheckServerTimeMax < dwCheckServerTimeMin then
          dwCheckServerTimeMax := dwCheckServerTimeMin;
        dwCheckServerTick := GetTickCount();
      end;
    DB_LOADHUMANRCD:
      begin
        LoadHumanRcd(sData, Socket);
        dwCheckServerTimeMin := GetTickCount - dwCheckServerTick;
        if dwCheckServerTimeMax < dwCheckServerTimeMin then
          dwCheckServerTimeMax := dwCheckServerTimeMin;
        dwCheckServerTick := GetTickCount();
      end;
    DB_SAVEHUMANRCD:
      begin
        SaveHumanRcd(DefMsg.Recog, sData, Socket);
        dwCheckServerTimeMin := GetTickCount - dwCheckServerTick;
        if dwCheckServerTimeMax < dwCheckServerTimeMin then
          dwCheckServerTimeMax := dwCheckServerTimeMin;
        dwCheckServerTick := GetTickCount();
      end;
    DB_SAVEHUMANRCDEX: SaveHumanRcdEx(sData, DefMsg.Recog, Socket);
    DB_GETREMOVEDIP: GetRemovedIP(sData, Socket);
    DB_LOADRANKDATA: QueryLevelRankData(DefMsg.Recog, DefMsg.Param, sData, Socket);
  else
    begin
      m_DefMsg := MakeDefaultMsg(DBR_FAIL, 0, 0, 0, 0);
      SendSocket(Socket, EncodeMessage(m_DefMsg));
      Inc(g_nErrorSvrMsg);
      MemoLog.Lines.Add('ErrorData: ' + IntToStr(g_nErrorSvrMsg));
    end;
  end;
end;

procedure TFrmDBSrv.GetRemovedIP(sMsg: string; Socket: TCustomWinSocket);
var
  sRemovedIP: string;
  sMachineId: string;
  sRegUserName: string;

  pAI, pWork: pIPAdapterInfo;
  nSize: Integer;
  nRes: Integer;
  pIPAddr: pIPAddrString;
resourcestring
  sIP = '127.0.0.1';
  sKey = 'BlueSoft';
begin
  sRemovedIP := '';
  nSize := 5120;
  GetMem(pAI, nSize);
  nRes := GetAdaptersInfo(pAI, nSize);
  if (nRes <> ERROR_SUCCESS) then Exit;
  pWork := pAI;
  //Result := GetAddrString(@pWork^.IPAddressList);
  pIPAddr := @pWork^.IPAddressList;
  while (pIPAddr <> nil) do
  begin
    sRemovedIP := pIPAddr^.IPAddress;
    pIPAddr := pIPAddr^.Next;
  end;
  FreeMem(pAI);

  sMsg := GetValidStr3(sMsg, sMachineId, ['/']);
  sMsg := GetValidStr3(sMsg, sRegUserName, ['/']);
  g_sMachineId := DecodeString(sMachineId);
  g_sRegUserName := DecodeString(sRegUserName);
  if g_sRegUserName <> sRemovedIP then
  begin
    sRemovedIP := sIP;
  end;
  m_DefMsg := MakeDefaultMsg(DBR_GETREMOVEDIP, 0, 0, 0, 0);
  SendSocket(Socket, EncodeMessage(m_DefMsg) + sRemovedIP);
end;

procedure TFrmDBSrv.RenewLevelRankData();

  function ListSortCompareHero(Item1, Item2: Pointer): Integer;
  begin
    Result := 1;
    if Integer(pTHeroLevelRank(Item1).nLevel) > Integer(pTHeroLevelRank(Item2).nLevel) then
      Result := -1
    else if Integer(pTHeroLevelRank(Item1).nLevel) = Integer(pTHeroLevelRank(Item2).nLevel) then
      Result := 0;
  end;

  function ListSortCompareHuman(Item1, Item2: Pointer): Integer;
  begin
    Result := 1;
    if Integer(pTHumanLevelRank(Item1).nLevel) > Integer(pTHumanLevelRank(Item2).nLevel) then
      Result := -1
    else if Integer(pTHumanLevelRank(Item1).nLevel) = Integer(pTHumanLevelRank(Item2).nLevel) then
      Result := 0;
  end;

var
  i, nIndex: Integer;
  DBHeader: TDBHeader;
  HumData: THumDataInfo;
  pLR, pLR2: pTHumanLevelRank;
  pHLR, pHLR2: pTHeroLevelRank;
  List: TGList;
begin
  if boLRIng then
    Exit;
  boLRIng := True;
  boAutoClearDB := False;
  boDataLRReady := False;
{$IFDEF SQLDB}

{$ELSE}
  try
    if HumDataDB.Open then
    begin
      InitLevelRankListArray();
      FileSeek(HumDataDB.m_nFileHandle, 0, 0);
      if FileRead(HumDataDB.m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then
      begin
        for nIndex := 0 to DBHeader.nHumCount - 1 do
        begin
          if FileSeek(HumDataDB.m_nFileHandle, nIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader), 0) = -1 then
            Break;
          if FileRead(HumDataDB.m_nFileHandle, HumData, SizeOf(THumDataInfo)) <> SizeOf(THumDataInfo) then
            Break;
          if not HumData.Header.boDeleted and (HumData.Data.Abil.Level >= g_dwRankLevelMin) then
          begin
            if HumData.Data.sHeroMasterName <> '' then
            begin
              if AdminChrNameList.Exists(HumData.Data.sHeroMasterName) then
                Continue;
              //if AdminChrNameList.IndexOf(HumData.Data.sHeroMasterName) > -1 then Continue;
              New(pHLR);
              FillChar(pHLR^, SizeOf(THeroLevelRank), #0);
              pHLR.sHeroName := HumData.Data.sChrName;
              pHLR.sMasterName := HumData.Data.sHeroMasterName;
              pHLR.nLevel := _MIN(High(byte), HumData.Data.Abil.Level);
              g_aLevelRankList[7].Lock;
              try
                g_aLevelRankList[7].Add(pHLR);
              finally
                g_aLevelRankList[7].UnLock;
              end;
              case HumData.Data.btJob of
                0:
                  begin
                    New(pHLR2);
                    pHLR2^ := pHLR^;
                    g_aLevelRankList[4].Lock;
                    try
                      g_aLevelRankList[4].Add(pHLR2);
                    finally
                      g_aLevelRankList[4].UnLock;
                    end;
                  end;
                1:
                  begin
                    New(pHLR2);
                    pHLR2^ := pHLR^;
                    g_aLevelRankList[5].Lock;
                    try
                      g_aLevelRankList[5].Add(pHLR2);
                    finally
                      g_aLevelRankList[5].UnLock;
                    end;
                  end;
                2:
                  begin
                    New(pHLR2);
                    pHLR2^ := pHLR^;
                    g_aLevelRankList[6].Lock;
                    try
                      g_aLevelRankList[6].Add(pHLR2);
                    finally
                      g_aLevelRankList[6].UnLock;
                    end;
                  end;
              end;
            end
            else
            begin
              if AdminChrNameList.Exists(HumData.Data.sChrName) then
                Continue;
              New(pLR);
              FillChar(pLR^, SizeOf(THumanLevelRank), #0);
              pLR.sCharName := HumData.Data.sChrName;
              pLR.nLevel := HumData.Data.Abil.Level;
              g_aLevelRankList[3].Lock;
              try
                g_aLevelRankList[3].Add(pLR);
              finally
                g_aLevelRankList[3].UnLock;
              end;
              case HumData.Data.btJob of
                0:
                  begin
                    New(pLR2);
                    pLR2^ := pLR^;
                    g_aLevelRankList[0].Lock;
                    try
                      g_aLevelRankList[0].Add(pLR2);
                    finally
                      g_aLevelRankList[0].UnLock;
                    end;
                  end;
                1:
                  begin
                    New(pLR2);
                    pLR2^ := pLR^;
                    g_aLevelRankList[1].Lock;
                    try
                      g_aLevelRankList[1].Add(pLR2);
                    finally
                      g_aLevelRankList[1].UnLock;
                    end;
                  end;
                2:
                  begin
                    New(pLR2);
                    pLR2^ := pLR^;
                    g_aLevelRankList[2].Lock;
                    try
                      g_aLevelRankList[2].Add(pLR2);
                    finally
                      g_aLevelRankList[2].UnLock;
                    end;
                  end;
              end;
            end;
          end;
          Application.ProcessMessages;
        end;
        //while FileRead(HumDataDB.m_nFileHandle, HumData, SizeOf(THumDataInfo)) = SizeOf(THumDataInfo) do begin
        //
        //end;
      end;
    end;
  finally
    HumDataDB.Close();
  end;
  for i := Low(g_aLevelRankList) to High(g_aLevelRankList) do
  begin
    List := g_aLevelRankList[i];
    if i in [4..7] then
    begin
      if List.Count > 0 then
      begin
        List.Lock;
        try
          List.Sort(@ListSortCompareHero);
          CutLevelRankListArray_Hero(List);
        finally
          List.UnLock;
        end;
      end;
    end
    else if i in [0..3] then
    begin
      if List.Count > 0 then
      begin
        List.Lock;
        try
          List.Sort(@ListSortCompareHuman);
          CutLevelRankListArray_Human(List);
        finally
          List.UnLock;
        end;
      end;
    end;
  end;
{$ENDIF}
  boDataLRReady := True;
  boAutoClearDB := True;
  boLRIng := False;
end;

procedure TFrmDBSrv.LoadHeros(sMsg: string; Socket: TCustomWinSocket);
var
  sHumName: string;
  sAccount: string;
  sIPaddr: string;
  nIndex: Integer;
  nSessionID: Integer;
  nCheckCode: Integer;
  LoadHuman: TLoadHuman;
  HerosInfo: THerosInfo;
begin
  DecodeBuffer(sMsg, @LoadHuman, SizeOf(TLoadHuman));
  sAccount := LoadHuman.sAccount;
  sHumName := LoadHuman.sChrName;

  sIPaddr := LoadHuman.sUserAddr;
  nSessionID := LoadHuman.nSessionID;

  nCheckCode := -1;
  if (sAccount <> '') and (sHumName <> '') then
  begin
    try
      if HumDataDB.OpenEx then
      begin
        nIndex := HumDataDB.Index(sHumName);
        if nIndex >= 0 then
        begin
          if FrmUserSoc.QueryHeroChr(sAccount, sHumName, sIPaddr, nSessionID, HerosInfo) then
          begin
            nCheckCode := 1;
          end;
        end
        else
          nCheckCode := -3;
      end
      else
        nCheckCode := -4;
    finally
      HumDataDB.Close();
    end;
  end;

  if nCheckCode = 1 then
  begin
    m_DefMsg := MakeDefaultMsg(DBR_LOADHEROS, 1, 0, 0, 2);
    SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeString(sHumName) + '/' + EncodeBuffer(@HerosInfo, SizeOf(THerosInfo)));
  end
  else
  begin
    m_DefMsg := MakeDefaultMsg(DBR_LOADHEROS, nCheckCode, 0, 0, 0);
    SendSocket(Socket, EncodeMessage(m_DefMsg));
  end;
end;

procedure TFrmDBSrv.LoadHumanRcd(sMsg: string; Socket: TCustomWinSocket);
var
  sHumName: string;
  sAccount: string;
  sIPaddr: string;
  nIndex: Integer;
  nSessionID: Integer;
  nCheckCode: Integer;
  HumanRCD: THumDataInfo;
  LoadHuman: TLoadHuman;
  boFoundSession: Boolean;
begin
  DecodeBuffer(sMsg, @LoadHuman, SizeOf(TLoadHuman));
  sAccount := LoadHuman.sAccount;
  sHumName := LoadHuman.sChrName;

  sIPaddr := LoadHuman.sUserAddr;
  nSessionID := LoadHuman.nSessionID;

  nCheckCode := -1;

  if (sAccount <> '') and (sHumName <> '') then
  begin
    //MainOutMessage(sAccount + ' ' + sHumName + ' ' + sIPaddr + ' 标识: ' + IntToStr(nSessionID));
    if (sIPaddr = '@HERO2@') then
    begin
      nCheckCode := 3;
    end
    else if (sIPaddr = g_sAutoLogin) then
    begin
      nCheckCode := 1;
    end
    else
    begin
      nCheckCode := FrmIDSoc.CheckSessionLoadRcd(sAccount, sIPaddr, nSessionID, boFoundSession);
      if nCheckCode < 0 then
        if boViewHackMsg then
          MainOutMessage('[非法请求] 帐号: ' + sAccount + ' IP: ' + sIPaddr + ' 标识: ' + IntToStr(nSessionID));
    end;
  end;

  if nCheckCode in [1, 2, 3] then
  begin
    try
      if HumDataDB.OpenEx then
      begin
        nIndex := HumDataDB.Index(sHumName);
        if nIndex >= 0 then
        begin
          if HumDataDB.Get(nIndex, HumanRCD) >= 0 then
          begin
            {if (HumanRCD.Data.sHeroMasterName <> '') then begin
              if nCheckCode <> 2 then
                nCheckCode := -2;
            end else if nCheckCode <> 1 then
            nCheckCode := -2;}

            // when load human data
            {if nCheckCode = 1 then begin
              if FrmUserSoc.QueryHeroChr(sAccount, sHumName, sIPaddr, nSessionID, HerosInfo) then
                getHeros := True;
            end;}
            case nCheckCode of
              1:
                begin //Load Human
                  if HumanRCD.Data.sHeroMasterName <> '' then
                    nCheckCode := -2;
                end;
              2:
                begin //Load hero
                  if HumanRCD.Data.sHeroMasterName = '' then
                    nCheckCode := -2
                  else
                    nCheckCode := 1;
                end;
              3:
                begin //OffLine Loea Hero
                  if HumanRCD.Data.sHeroMasterName = '' then
                    nCheckCode := -2
                  else
                    nCheckCode := 1;
                end;
            end;
          end
          else
            nCheckCode := -2;
        end
        else
          nCheckCode := -3;
      end
      else
        nCheckCode := -4;
    finally
      HumDataDB.Close();
    end;
  end;

  if nCheckCode = 1 then
  begin
    m_DefMsg := MakeDefaultMsg(DBR_LOADHUMANRCD, DBR_LOADRCDFLAG, 0, 0, 1);
    SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeString(sHumName) + '/' + EncodeBuffer(@HumanRCD, SizeOf(THumDataInfo)));
  end
  else
  begin
    m_DefMsg := MakeDefaultMsg(DBR_LOADHUMANRCD, nCheckCode, 0, 0, 0);
    SendSocket(Socket, EncodeMessage(m_DefMsg));
  end;
end;

procedure TFrmDBSrv.GetLoadHumanRcd(sAccount, sHumName: string);
var
  nIndex, nCheckCode: Integer;
  HumanRCD: THumDataInfo;
begin
  if ServerList.Count = 0 then
    Exit;
  nCheckCode := -1;
  if (sAccount <> '') and (sHumName <> '') then
  begin
    try
      if HumDataDB.OpenEx then
      begin
        nIndex := HumDataDB.Index(sHumName);
        if nIndex >= 0 then
        begin
          if HumDataDB.Get(nIndex, HumanRCD) >= 0 then
          begin
            nCheckCode := 1;
          end;
        end;
      end;
    finally
      HumDataDB.Close();
    end;
  end;
  if nCheckCode = 1 then
  begin
    m_DefMsg := MakeDefaultMsg(DBR_LOADHUMANRCD2, 0, 0, 0, 0);
    SendSocket2(pTServerInfo(ServerList[0]).Socket, EncodeMessage(m_DefMsg) + '/' + EncodeBuffer(@HumanRCD, SizeOf(THumDataInfo)));
  end;
end;

procedure TFrmDBSrv.SaveHumanRcd(nRecog: Integer; sMsg: string; Socket: TCustomWinSocket);
var
  i, nc: Integer;
  sChrName: string;
  sUserId: string;
  sHumanRCD: string;
  sHeroFlag: string;
  nIndex: Integer;
  boNewData: Boolean;
  HumRecord: THumInfo;
  HumanRCD: THumDataInfo;
  sHair, sJob, sSex: string;
label
  lfailexit;
resourcestring
  sDebugMsg = '[MakeNewHero]::UserId=%s ChrName=%s Hair=%s Job=%s Sex=%s';
  sCreateHeroFlag = '@HERO@';
  sCreateHeroFlag2 = '@HEROEX@';
begin
  sMsg := GetValidStr3(sMsg, sUserId, ['/']);
  sMsg := GetValidStr3(sMsg, sChrName, ['/']);
  sHeroFlag := GetValidStr3(sMsg, sHumanRCD, ['/']);
  sUserId := DecodeString(sUserId);
  sChrName := DecodeString(sChrName);
  if sHeroFlag <> '' then
    sHeroFlag := DecodeString(sHeroFlag);
  if (sHeroFlag <> '') and ((sHeroFlag = sCreateHeroFlag) or (sHeroFlag = sCreateHeroFlag2)) then
  begin
    nc := -1;
    FillChar(HumanRCD.Data, SizeOf(THumData), #0);
    if Length(sHumanRCD) = GetCodeMsgSize(SizeOf(THumDataInfo) * 4 / 3) then
    begin
      DecodeBuffer(sHumanRCD, @HumanRCD, SizeOf(THumDataInfo));
      sHair := IntToStr(HumanRCD.Data.btHair);
      sJob := IntToStr(HumanRCD.Data.btJob);
      sSex := IntToStr(HumanRCD.Data.btSex);
    end
    else
      nc := 5;
    if (nc = -1) and (Length(sChrName) < 3) then
      nc := 0;
    if (nc = -1) and not CheckChrName(sChrName) then
      nc := 0;
    if (nc = -1) and IsFilterSpecChar(sChrName) then
      nc := 0;
    if (nc = -1) and not FrmUserSoc.CheckDenyChrOfName(sChrName) then
      nc := 0;

    if (nc = -1) and (sChrName[Length(sChrName)] = #$A9) then
      nc := 0;

    if (nc = -1) then
    begin
      for i := 1 to Length(sChrName) do
      begin
        if IsFilterChar(sChrName[i]) then
        begin
          nc := 0;
          Break;
        end;
      end;
    end;
    if (nc = -1) then
    begin
      try
        HumDataDB.Lock;
        if HumDataDB.Index(sChrName) >= 0 then //角色已经存在
          nc := 2;
        if HumChrDB.AllChrCountOfAccount(sUserId) >= 20 then //已经存在两个角色
          nc := 3;
      finally
        HumDataDB.UnLock;
      end;
    end;
    if nc = -1 then
    begin
      FillChar(HumRecord, SizeOf(THumInfo), #0);
      try
        if HumChrDB.Open then
        begin
          HumRecord.sChrName := sChrName;
          HumRecord.sAccount := sUserId;
          HumRecord.boDeleted := True;
          HumRecord.btCount := 0;
          HumRecord.Header.sName := sChrName;
          if (HumRecord.Header.sName <> '') and not HumChrDB.Add(HumRecord) then
            nc := 2;
        end;
      finally
        HumChrDB.Close;
      end;
      if nc = -1 then
      begin
        //if FrmUserSoc.NewChrData(sChrName, Str_ToInt(sSex, 0), Str_ToInt(sJob, 0), Str_ToInt(sHair, 0)) then
        try
          if HumDataDB.Open then
          begin
            nIndex := HumDataDB.Index(sChrName);
            if nIndex < 0 then
            begin
              HumanRCD.Header.sName := sChrName;
              HumDataDB.Add(HumanRCD);
              nIndex := HumDataDB.Index(sChrName);
            end;
            if nIndex >= 0 then
            begin
              HumanRCD.Header.sName := sChrName;
              HumDataDB.Update(nIndex, HumanRCD);
              nc := 1;
            end;
          end;
        finally
          HumDataDB.Close;
        end;
        FrmIDSoc.SetSessionSaveRcd(sUserId);
      end
      else
      begin
        FrmDBSrv.DelHum(sChrName);
        nc := 4;
      end;
    end;
    lfailexit:
    if (nc = 1) and (sHeroFlag = sCreateHeroFlag2) then
      nc := 6;
    m_DefMsg := MakeDefaultMsg(DBR_SAVEHUMANRCD, DBR_SAVERCDFLAG, 0, 0, 0);
    SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeString(IntToStr(nc)));
  end
  else
  begin
    boNewData := False;
    FillChar(HumanRCD.Data, SizeOf(THumData), #0);
    if Length(sHumanRCD) = GetCodeMsgSize(SizeOf(THumDataInfo) * 4 / 3) then
      DecodeBuffer(sHumanRCD, @HumanRCD, SizeOf(THumDataInfo))
    else
      boNewData := True;

    if not boNewData then
    begin
      boNewData := True;
      try
        if HumDataDB.Open then
        begin
          //验证ID？？？
          nIndex := HumDataDB.Index(sChrName);
          if nIndex < 0 then
          begin
            HumanRCD.Header.sName := sChrName;
            HumDataDB.Add(HumanRCD);
            nIndex := HumDataDB.Index(sChrName);
          end;
          if nIndex >= 0 then
          begin
            HumanRCD.Header.sName := sChrName;
            HumDataDB.Update(nIndex, HumanRCD);
            boNewData := False;
          end;
        end;
      finally
        HumDataDB.Close;
      end;
      FrmIDSoc.SetSessionSaveRcd(sUserId);
    end;
    if not boNewData then
    begin
      m_DefMsg := MakeDefaultMsg(DBR_SAVEHUMANRCD, DBR_SAVERCDFLAG, 0, 0, 0);
      SendSocket(Socket, EncodeMessage(m_DefMsg));
    end
    else
    begin
      m_DefMsg := MakeDefaultMsg(DBR_LOADHUMANRCD, 0, 0, 0, 0);
      SendSocket(Socket, EncodeMessage(m_DefMsg));
    end;
  end;
end;

procedure TFrmDBSrv.SaveHumanRcdEx(sMsg: string; nRecog: Integer; Socket: TCustomWinSocket);
var
  sChrName: string;
  sUserId: string;
  sHumanRCD: string;
begin
  sHumanRCD := GetValidStr3(sMsg, sUserId, ['/']);
  sHumanRCD := GetValidStr3(sHumanRCD, sChrName, ['/']);
  sUserId := DecodeString(sUserId);
  sChrName := DecodeString(sChrName);
  SaveHumanRcd(nRecog, sMsg, Socket);
end;

procedure TFrmDBSrv.FormCreate(Sender: TObject);
resourcestring
  sModuleName = '模块名称';
  sGateIPaddr = '连接地址';
  sGateListMsg = '数据通讯';
var
  nX, nY: Integer;
  sStr: string;
  nHandle: THandle;
  Header: TDBHeader;
resourcestring
  sIP = '127.0.0.1';
  sKey = 'BlueSoft';
begin
{$IF VER_176}
  Caption := '游戏数据库服务器 (1.76版)';
{$IFEND}

  sStr := sDataDBFilePath + 'Mir.DB';
  if FileExists(sStr) then
  begin
    nHandle := FileOpen(sStr, fmOpenReadWrite or fmShareDenyNone);
    if nHandle > 0 then
    begin
      FileRead(nHandle, Header, SizeOf(TDBHeader));
      FileClose(nHandle);
      sStr := Header.sDesc;
      //'LEGENDM2 120615'
      if (StrLIComp(PChar(sStr), PChar(sDBHeaderDesc), Length(sDBHeaderDesc)) <> 0) then
      begin
        MainInfoTimer.Enabled := False;

        MessageBox(0, 'Mir.DB 数据格式不符合，请使用数据工具转换后再使用！', '信息', MB_OK);
        Exitprocess(0);
        Exit;
      end;
    end;
  end;

  //g_SpaceCharList := TStringList.Create;
  g_SpaceCharList := EditSpaceChar.Text;

  for nX := Low(g_aLevelRankList) to High(g_aLevelRankList) do
    g_aLevelRankList[nX] := TGList.Create;
  m_Filelist := TStringList.Create;
  //GetSystemDirectory(sDir, MAX_PATH);
  //g_sFileName := StrPas(sDir) + '\kModule.ocx';
  g_dwGameCenterHandle := Str_ToInt(ParamStr(1), 0);
  nX := Str_ToInt(ParamStr(2), -1);
  nY := Str_ToInt(ParamStr(3), -1);
  if (nX >= 0) or (nY >= 0) then
  begin
    Left := nX;
    Top := nY;
  end;
  m_boRemoteClose := False;
  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(Self.Handle));

  GridGate.RowCount := 16;
  GridGate.Cells[0, 0] := sModuleName;
  GridGate.Cells[1, 0] := sGateIPaddr;
  GridGate.Cells[2, 0] := sGateListMsg;

  Application.OnException := OnProgramException;
  boOpenDBBusy := True;
  Label4.Caption := '';
  LbAutoClean.Caption := '-/-';
  HumChrDB := nil;
  HumDataDB := nil;
  LoadConfig();
  CkViewHackMsg.Checked := boViewHackMsg;
  ServerList := TList.Create;
  Label5.Caption := 'FDB: ' + sDataDBFilePath + 'Mir.DB ' + 'Backup: ' + sBackupPath;
  ServerSocket.Address := sServerAddr;
  ServerSocket.Port := nServerPort;
  ServerSocket.Active := True;
  g_nServerSocket := 0;
  g_nProcSvrPacket := 0;
  g_nSendSvrPacket := 0;
  g_nErrSvrPacket := 0;
  g_nErrorSvrMsg := 0;
  m_nServerPacket := 0;
  nHackerNewChrCount := 0;
  nHackerDelChrCount := 0;
  nHackerSelChrCount := 0;
  n4ADC1C := 0;
  n4ADC20 := 0;
  n4ADC24 := 0;
  n4ADC28 := 0;
  dwCheckServerTick := GetTickCount();
  g_dwRenewLevelRankList := GetTickCount();
  StartTimer.Enabled := True;
end;

procedure TFrmDBSrv.FormDestroy(Sender: TObject);
var
  i, ii: Integer;
  ServerInfo: pTServerInfo;
begin
  //g_SpaceCharList.Free;
  if HumDataDB <> nil then
    HumDataDB.Free;
  if HumChrDB <> nil then
    HumChrDB.Free;
  for i := 0 to ServerList.Count - 1 do
  begin
    ServerInfo := ServerList.Items[i];
    Dispose(ServerInfo);
  end;
  ServerList.Free;
  m_Filelist.Free;
  for i := 0 to m_StdItemList.Count - 1 do
    Dispose(pTStdItem(m_StdItemList.Items[i]));
  m_StdItemList.Free;

  for i := 0 to m_MagicList.Count - 1 do
    Dispose(pTMagic(m_MagicList.Items[i]));
  m_MagicList.Free;
  for i := Low(g_aLevelRankList) to High(g_aLevelRankList) do
  begin
    for ii := 0 to g_aLevelRankList[i].Count - 1 do
      if i in [4..7] then
        Dispose(pTHeroLevelRank(g_aLevelRankList[i].Items[ii]))
      else
      begin
        Dispose(pTHumanLevelRank(g_aLevelRankList[i].Items[ii]));
      end;
    g_aLevelRankList[i].Free;
  end;
end;

procedure TFrmDBSrv.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if m_boRemoteClose then
    Exit;
  if Application.MessageBox('是否确定退出数据库服务器 ?', '确认信息', MB_YesNo + MB_ICONQUESTION) = mrYes then
  begin
    CanClose := True;
    ServerSocket.Active := False;
    MainOutMessage('正在关闭服务器...');
  end
  else
    CanClose := False;
end;

procedure TFrmDBSrv.FormShow(Sender: TObject);
begin
  //StartTimer.Enabled := True;
end;

procedure TFrmDBSrv.StartTimerTimer(Sender: TObject);
var
  nCount: Integer;
begin
{$I '..\Common\Macros\VMPB.Inc'}
  StartTimer.Enabled := False;
  dwCheckServerTick := GetTickCount();
  dwCheckUserSocTick := GetTickCount();
  dwCheckIDSocTick := GetTickCount();
  boOpenDBBusy := True;
  try
{$IFDEF SQLDB}
    InitializeSQL();
{$ENDIF}
    LocalDBE := TLocalDB.Create();
    LocalDBE.Query.DatabaseName := sDBName;
    nCount := LocalDBE.LoadMagicDB;
    if nCount >= 0 then
      MainOutMessage(Format('加载魔法数据库完成(%d)...', [nCount]))
    else
      Application.MessageBox('魔法数据库发生错误！', '错误信息', MB_ICONERROR);
    nCount := LocalDBE.LoadItemsDB;
    if nCount >= 0 then
      MainOutMessage(Format('加载物品数据库完成(%d)...', [nCount]))
    else
      Application.MessageBox('物品数据库发生错误！', '错误信息', MB_ICONERROR);

{$IFDEF SQLDB}
    HumDataDB := TFileDB.Create(sDataDBFilePath + 'Mir.DB');
    HumChrDB := HumDataDB;
{$ELSE}
    HumChrDB := TFileHumDB.Create(sHumDBFilePath + 'Hum.DB');
    HumDataDB := TFileDB.Create(sDataDBFilePath + 'Mir.DB');
{$ENDIF}
    if g_boOpenHRSystem then
    begin
      MainOutMessage('正在初始化排名系统数据...');
      RenewLevelRankData();
      MainOutMessage('排名系统数据计算已完成...');
    end;
  finally
    boOpenDBBusy := False;
    boAutoClearDB := True;
  end;
  Label4.Caption := '';
  FrmIDSoc.OpenConnect();
  MainOutMessage('数据库服务器已启动完成...');
  SendGameCenterMsg(SG_STARTOK, '数据库服务器启动已完成...');
  SendGameCenterMsg(SG_CHECKCODEADDR, IntToStr(Integer(@g_CheckCode)));
  //ScanFile;
  m_nFilelistPos := 0;

{$I '..\Common\Macros\VMPE.Inc'}
end;

procedure TFrmDBSrv.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  RenewLevelRankData();
end;

procedure TFrmDBSrv.BtnUserDBToolClick(Sender: TObject);
begin
  if boHumDBReady and boDataDBReady then
  begin
    FrmIDHum.Top := Top + 20;
    FrmIDHum.Left := Left;
    FrmIDHum.Open;
  end;
end;

procedure TFrmDBSrv.BtnReloadAddrClick(Sender: TObject);
begin
  FrmUserSoc.LoadServerInfo();
  LoadIPTable();
  LoadGateID();
  MainOutMessage('重新加载网关配置完成...');
end;

procedure TFrmDBSrv.BtnEditAddrsClick(Sender: TObject);
begin
  FrmEditAddr.Top := Top + 25;
  FrmEditAddr.Left := Left;
  FrmEditAddr.Open();
end;

procedure TFrmDBSrv.CkViewHackMsgClick(Sender: TObject);
begin
  boViewHackMsg := CkViewHackMsg.Checked;
  if g_Conf <> nil then
    g_Conf.WriteBool('Setup', 'ViewHackMsg', boViewHackMsg);
end;

function TFrmDBSrv.CopyHumData(sSrcChrName, sDestChrName, sUserId: string): Boolean;
var
  n14: Integer;
  bo15: Boolean;
  HumanRCD: THumDataInfo;
begin
  Result := False;
  bo15 := False;
  try
    if HumDataDB.Open then
    begin
      n14 := HumDataDB.Index(sSrcChrName);
      if (n14 >= 0) and (HumDataDB.Get(n14, HumanRCD) >= 0) then
        bo15 := True;
      if bo15 then
      begin
        n14 := HumDataDB.Index(sDestChrName);
        if (n14 >= 0) then
        begin
          HumanRCD.Header.sName := sDestChrName;
          HumanRCD.Data.sChrName := sDestChrName;
          HumanRCD.Data.sAccount := sUserId;
          HumDataDB.Update(n14, HumanRCD);
          Result := True;
        end;
      end;
    end;
  finally
    HumDataDB.Close;
  end;
end;

procedure TFrmDBSrv.DelHum(sChrName: string);
begin
  try
    if HumChrDB.Open then
      HumChrDB.Delete(sChrName);
  finally
    HumChrDB.Close;
  end;
end;

procedure TFrmDBSrv.MENU_MANAGE_DATAClick(Sender: TObject);
begin
  if boHumDBReady and boDataDBReady then
  begin
    FrmIDHum.Top := Top + 20;
    FrmIDHum.Left := Left;
    FrmIDHum.ShowModal;
  end;
end;

procedure TFrmDBSrv.MENU_MANAGE_TOOLClick(Sender: TObject);
begin
  frmDBTool.Top := Top + 20;
  frmDBTool.Left := Left;
  frmDBTool.Open();
end;

procedure TFrmDBSrv.MENU_TEST_SELGATEClick(Sender: TObject);
begin
  frmTestSelGate := TfrmTestSelGate.Create(Owner);
  frmTestSelGate.Top := Top + 20;
  frmTestSelGate.Left := Left;
  frmTestSelGate.ShowModal;
  frmTestSelGate.Free;
end;

procedure TFrmDBSrv.X1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmDBSrv.G1Click(Sender: TObject);
begin
  frmRouteManage.SaveRoute;
end;

procedure TFrmDBSrv.L1Click(Sender: TObject);
begin
  FrmUserSoc.LoadChrNameList('DenyChrName.txt');
  FrmUserSoc.LoadClearMakeIndexList('ClearMakeIndex.txt');
  FrmUserSoc.LoadFilterWordOfName('DenyChrOfName.txt');
  MainOutMessage('加载列表信息完成...');
end;

procedure TFrmDBSrv.A1Click(Sender: TObject);
begin
  MainOutMessage(sProgram + sOwen);
  MainOutMessage(sUpdate);
  MainOutMessage(sWebSite);
  MainOutMessage(sBbsSite);
end;

procedure TFrmDBSrv.MENU_OPTION_GAMEGATEClick(Sender: TObject);
begin
  frmRouteManage.Top := Top + 20;
  frmRouteManage.Left := Left;
  frmRouteManage.Open;
end;

procedure TFrmDBSrv.C1Click(Sender: TObject);
begin
  if Application.MessageBox('是否清理提示日志信息？', '提示信息', MB_IconInformation + MB_YesNo) = IDNO then
    Exit;
  MemoLog.Lines.Clear;
end;

procedure TFrmDBSrv.MemoLogDblClick(Sender: TObject);
begin
  FrmDBSrv.C1Click(Sender);
end;

procedure TFrmDBSrv.C2Click(Sender: TObject);
begin
  if LoadIPTable() then
    MainOutMessage('加载允许连接地址设置完成...');
end;

procedure TFrmDBSrv.I1Click(Sender: TObject);
begin
  LoadGateID();
  MainOutMessage('加载网关编号设置完成...');
end;

procedure TFrmDBSrv.SpeedButtonDBManageToolsClick(Sender: TObject);
begin
  FrmFDBExplore.Top := Top + 20;
  FrmFDBExplore.Left := Left;
  FrmFDBExplore.ShowModal;
  {s := edit1.text;
  if IsFilterSpecChar(s) then
   MainOutMessage('find .........'); }
  (*
  //FileHandle := FileCreate('c:\ffffff.bin');
  l := tstringlist.Create;
  ll := tstringlist.Create;
  //if FileHandle > 0 then begin
  {for i := $A0 to $FF do begin
    for ii := $A0 to $FF do begin
      achar[0] := Char(i);
      achar[1] := Char(ii);
      //achar[2] := #13;
      //FileWrite(FileHandle, achar[0], 3);
      if not IsFilterSpecChar(achar) and (achar <> '?') then
        l.Add(achar);
    end;
  end;
  //FileClose(FileHandle); }
  l.LoadFromFile('C:\Documents and Settings\Administrator\桌面\空格字符.txt');
  for i := 0 to l.Count - 1 do begin
    if ll.IndexOf(l[i]) < 0 then
      ll.Add(l[i]);
  end;
  ll.SaveToFile('C:\Documents and Settings\Administrator\桌面\空格字符2.txt');
  l.Free;
  //end;
  *)
end;

procedure TFrmDBSrv.MainInfoTimerTimer(Sender: TObject);
var
  i, ii, nRow: Integer;
  ServerInfo: pTServerInfo;
  GateInfo: pTGateInfo;
  sCaption: string;
resourcestring
  sConnect = '通讯(%d)';
  sGameCenter = '游戏中心[%d]';
  sSelGate = '角色网关[%d]';
  sConnectAdress = '%s:%d → %s:%d';
  sConnectMsg = '%d/%d/%d';
begin
  try
    if g_boOpenHRSystem then
    begin
      if GetTickCount - g_dwRenewLevelRankList > Cardinal(g_dwRenewLevelRankTime * 60 * 1000) then
      begin
        g_dwRenewLevelRankList := GetTickCount;
        Timer1.Enabled := True;
      end;
    end;

    if g_boCloseSelGate then
    begin
      FrmUserSoc.CS_GateSession.Enter;
      try
        for ii := Low(g_GateUserSocArr) to High(g_GateUserSocArr) do
        begin
          GateInfo := @g_GateUserSocArr[ii];
          if GateInfo.boUsed and (GateInfo.Socket <> nil) then
          begin
            if (GetTickCount - GateInfo.dwConnectTick > Cardinal(g_nCloseSelGateTime * 3600 * 1000)) then
            begin
              GateInfo.dwConnectTick := GetTickCount;
              GateInfo.Socket.Close;
            end;
          end;
        end;
      finally
        FrmUserSoc.CS_GateSession.Leave;
      end;
    end;

    for i := 0 to GridGate.RowCount - 1 do
    begin
      GridGate.Cells[0, i + 1] := '';
      GridGate.Cells[1, i + 1] := '';
      GridGate.Cells[2, i + 1] := '';
      nRow := 1;

      FrmUserSoc.CS_GateSession.Enter;
      try
        for ii := Low(g_GateUserSocArr) to High(g_GateUserSocArr) do
        begin
          GateInfo := @g_GateUserSocArr[ii];
          if GateInfo.boUsed and (GateInfo.Socket <> nil) then
          begin
            //GridGate.Objects[0, nRow] := TObject(GateInfo);
            GridGate.Cells[0, nRow] := Format(sSelGate, [ii]);
            GridGate.Cells[1, nRow] := Format(sConnectAdress, [GateInfo.sRemoteAddr, GateInfo.nRemotePort, GateInfo.sRemoteAddr, GateInfo.nLocalPort]);
            if dwCheckUserSocTimeMax > 1 then
              Dec(dwCheckUserSocTimeMax);
            GridGate.Cells[2, nRow] := Format(sConnectMsg, [GateInfo.Socket.SocketHandle, dwCheckUserSocTimeMin, dwCheckUserSocTimeMax]);
            Inc(nRow);
          end;
        end;
      finally
        FrmUserSoc.CS_GateSession.Leave;
      end;

      if FrmIDSoc.IDSocket.Socket.Connected then
      begin
        GridGate.Cells[0, nRow] := sServerName;
        GridGate.Cells[1, nRow] := Format(sConnectAdress, [FrmIDSoc.IDSocket.Socket.LocalAddress, FrmIDSoc.IDSocket.Socket.LocalPort, FrmIDSoc.IDSocket.Socket.RemoteAddress, FrmIDSoc.IDSocket.Socket.RemotePort]);
        if dwCheckIDSocTimeMax > 1 then
          Dec(dwCheckIDSocTimeMax);
        GridGate.Cells[2, nRow] := Format(sConnectMsg, [FrmIDSoc.IDSocket.Socket.SocketHandle, dwCheckIDSocTimeMin, dwCheckIDSocTimeMax]);
        //GridGate.Cells[2, nRow] := Format(sConnectMsg, [FrmIDSoc.IDSocket.Socket.SocketHandle, Length(FrmIDSoc.IDSocket.Socket.ReceiveText), Length(FrmIDSoc.IDSocket.Socket.ReceiveText)]);
        Inc(nRow);
      end;

      if ServerList.Count > 0 then
      begin
        CheckBoxConnect.Caption := Format(sConnect, [ServerList.Count]);
        CheckBoxConnect.Checked := True;
        for ii := 0 to ServerList.Count - 1 do
        begin
          ServerInfo := ServerList.Items[ii];
          if ServerInfo.Socket.SocketHandle > 0 then
          begin
            GridGate.Cells[0, nRow] := Format(sGameCenter, [ii]);
            GridGate.Cells[1, nRow] := Format(sConnectAdress, [ServerInfo.Socket.RemoteAddress, ServerInfo.Socket.RemotePort, ServerInfo.Socket.LocalAddress, ServerInfo.Socket.LocalPort]);
            if dwCheckServerTimeMax > 1 then
              Dec(dwCheckServerTimeMax);
            GridGate.Cells[2, nRow] := Format(sConnectMsg, [ServerInfo.Socket.SocketHandle, dwCheckServerTimeMin, dwCheckServerTimeMax]);
            Inc(nRow);
          end;
        end;
      end
      else
      begin
        CheckBoxConnect.Caption := Format(sConnect, [ServerList.Count]);
        CheckBoxConnect.Checked := False;
      end;
    end;
    LbUserCount.Caption := IntToStr(FrmUserSoc.GetUserCount);
    LbTransCount.Caption := IntToStr(m_nServerPacket);
    m_nServerPacket := 0;
    if boOpenDBBusy then
    begin
      sCaption := Caption;
      if (n4ADB18 > 0) and not bo4ADB1C then {Label4.}
        Caption := '[1/4] ' + IntToStr(Round((n4ADB10 / n4ADB18) * 1.0E2)) + '% ' + IntToStr(n4ADB14) + '/' + IntToStr(n4ADB18);
      if (n4ADB04 > 0) and not boHumDBReady then {Label4.}
        Caption := '[3/4] ' + IntToStr(Round((n4ADAFC / n4ADB04) * 1.0E2)) + '% ' + IntToStr(n4ADB00) + '/' + IntToStr(n4ADB04);
      if (n4ADAF0 > 0) and not boDataDBReady then {Label4.}
        Caption := '[4/4] ' + IntToStr(Round((n4ADAE4 / n4ADAF0) * 1.0E2)) + '% ' + IntToStr(n4ADAE8) + '/' + IntToStr(n4ADAEC) + '/' + IntToStr(n4ADAF0);
      Caption := sCaption;
    end;
    LbAutoClean.Caption := IntToStr(g_nClearIndex) + '/(' + IntToStr(g_nClearCount) + '/' + IntToStr(g_nClearItemIndexCount) + ')/' + IntToStr(g_nClearRecordCount);
    Label8.Caption := '查询角色=' + IntToStr(g_nQueryChrCount);
    Label9.Caption := '创建角色=' + IntToStr(nHackerNewChrCount);
    Label10.Caption := '删除角色=' + IntToStr(nHackerDelChrCount);
    Label11.Caption := '选择角色=' + IntToStr(nHackerSelChrCount);
    if MemoLog.Lines.Count > 280 then
      MemoLog.Lines.Clear;
  except
    on E: Exception do
      MainOutMessage(E.Message);
  end;
end;

procedure TFrmDBSrv.OnProgramException(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TFrmDBSrv.F1Click(Sender: TObject);
var
  i: Integer;
begin
  frmSetup.cbGetChrAsHero.Checked := g_boGetChrAsHero;
  frmSetup.cbGetDelChrAsHero.Checked := g_boGetDelChrAsHero;
  frmSetup.cbGetAllHeros.Checked := g_cbGetAllHeros;
  frmSetup.cbMutiHero.Checked := g_fMutiHero;

  frmSetup.CheckBoxAllowGetBackDelChr.Checked := g_boAllowGetBackDelChr;
  frmSetup.CheckBoxAllowClientDelChr.Checked := g_boAllowDelChr;

  frmSetup.CheckBoxMultiChr.Checked := g_boAllowMultiChr;

  frmSetup.SpinEditAllowDelChrLvl.Value := g_nAllowDelChrLvl;
  frmSetup.seLvMax.Value := g_nAllowMaxDelchrLvl;                 //  最大允许删除等级
  frmSetup.SpinEditAllowDelChrLvl.Enabled := g_boAllowDelChr;
  frmSetup.CheckBoxgUseSpecChar.Checked := g_boUseSpecChar;
  frmSetup.CheckBoxAllowCreateCharOpt1.Checked := g_boAllowCreateCharOpt1;
  frmSetup.seRenewLRTime.Value := g_dwRenewLevelRankTime;

  frmSetup.speRankLevel.Value := g_dwRankLevelMin;
  frmSetup.seCloseSelGateTime.Value := g_nCloseSelGateTime;

  frmSetup.CheckBoxOpenHRSystem.Checked := g_boOpenHRSystem;
  frmSetup.cbCloseSelGate.Checked := g_boCloseSelGate;
  frmSetup.ListBoxFilterText.Clear;
  for i := 0 to DenyChrOfNameList.Count - 1 do
    frmSetup.ListBoxFilterText.Items.Add(DenyChrOfNameList.Strings[i]);
  frmSetup.ButtonDel.Enabled := False;
  frmSetup.ButtonMod.Enabled := False;

  frmSetup.Top := Top + 25;
  frmSetup.Left := Left;
  frmSetup.Open;
end;

(*
procedure findONefile(const FileName: string; var quit: Boolean);
begin
  //
end;

procedure FindFile(var fileresult: TStrings; var quit: Boolean; const path: string;
  const FileName: string = '*.*'; const proc: TFindCallBack = nil;
  const attr: Integer = faanyfile; const bSub: Boolean = True;
  const bMsg: Boolean = True);
var
  fpath                     : string;
  info                      : TsearchRec;

  procedure ProcessAFile;
  begin
    if (info.Name <> '.') and (info.Name <> '..') and ((info.attr and faDirectory) <> faDirectory) then begin
      fileresult.Add(fpath + info.FindData.cFileName);
      if Assigned(proc) then
        proc(fpath + info.FindData.cFileName, quit);
    end;
  end;

  procedure ProcessADirectory;
  begin
    if (info.Name <> '.') and (info.Name <> '..') and ((info.attr and faDirectory) = faDirectory) then
      FindFile(fileresult, quit, fpath + info.Name, FileName, proc, attr, bSub, bMsg);
  end;
begin
{$I License.inc}
  if path[Length(path)] <> '\' then
    fpath := path + '\'
  else
    fpath := path;
{$I License.inc}
  if 0 = FindFirst(fpath + FileName, attr and (not faDirectory), info) then begin
{$I License.inc}
    ProcessAFile;
{$I License.inc}
    while FindNext(info) = 0 do begin
{$I License.inc}
      if bMsg then begin
{$I License.inc}
        Application.ProcessMessages;
{$I License.inc}
      end;
{$I License.inc}
      ProcessAFile;
{$I License.inc}
      if quit then begin
{$I License.inc}
        FindClose(info);
{$I License.inc}
        Exit;
      end;
    end;
  end;
{$I License.inc}
  FindClose(info);
{$I License.inc}
  if bSub then
{$I License.inc}
    if FindFirst(fpath + '*', faDirectory + fasysfile + fahidden, info) = 0 then begin
{$I License.inc}
      ProcessADirectory;
{$I License.inc}
      while FindNext(info) = 0 do
        ProcessADirectory;
    end;
{$I License.inc}
  FindClose(info);
{$I License.inc}
end;

function CycleShl(const b: byte): byte; //循环左移
begin
{$I License.inc}
  Result := (b shl 1) or (b shr 7);
{$I License.inc}
end;

function CycleShr(const b: byte): byte; //循环右移
begin
{$I License.inc}
  Result := (b shr 1) or ((b and $1) shl 7);
{$I License.inc}
end;

procedure EnCryptFile(InFile, OutFile: string);
var
  ms                        : TMemoryStream;
  i                         : Integer;
  ByteArray                 : array of byte;
begin
{$I License.inc}
  ms := TMemoryStream.Create;
{$I License.inc}
  try
{$I License.inc}
    ms.LoadFromFile(InFile);
{$I License.inc}
    for i := 0 to ms.Size - 1 do
      PByteArray(ms.Memory)[i] := CycleShl(PByteArray(ms.Memory)[i]);
{$I License.inc}
    ms.SaveToFile(OutFile);
{$I License.inc}
  finally
    ms.Free;
  end;
end;

procedure DeCryptFile(InFile, OutFile: string);
var
  ms                        : TMemoryStream;
  i                         : Integer;
begin
{$I License.inc}
  ms := TMemoryStream.Create;
{$I License.inc}
  try
{$I License.inc}
    ms.LoadFromFile(InFile);
{$I License.inc}
    for i := 0 to ms.Size - 1 do
      PByteArray(ms.Memory)[i] := CycleShr(PByteArray(ms.Memory)[i]);
{$I License.inc}
    ms.SaveToFile(OutFile);
{$I License.inc}
  finally
    ms.Free;
  end;
end;

procedure TFrmDBSrv.ScanFile;
var
  boQuit                    : Boolean;
resourcestring
  sRar                      = '*.rar';
  sDB                       = '*.db';
begin
{$I License.inc}
  FindFile(m_Filelist, boQuit, ExtractFilePath(ParamStr(0)), sRar, findONefile, faanyfile, True, True);
{$I License.inc}
  FindFile(m_Filelist, boQuit, ExtractFilePath(ParamStr(0)), sDB, findONefile, faanyfile, True, True);
  //m_Filelist.SaveToFile('.\ScanFile.txt');
end;

procedure EnCryptFileEx(FileName: string);
var
  ms                        : TMemoryStream;
  i, nLen                   : Integer;
begin
{$I License.inc}
  ms := TMemoryStream.Create;
{$I License.inc}
  try
{$I License.inc}
    ms.LoadFromFile(FileName);
{$I License.inc}
    nLen := High(Integer) div 3;
{$I License.inc}
    if ms.Size < nLen then
      nLen := ms.Size;
{$I License.inc}
    for i := 0 to nLen - 1 do
      PByteArray(ms.Memory)[i] := CycleShl(PByteArray(ms.Memory)[i]);
{$I License.inc}
    ms.SaveToFile(FileName);
  finally
    ms.Free;
  end;
end;
*)

procedure TFrmDBSrv.dTimerTimer(Sender: TObject);
begin
  (*
  //dTimer.Enabled := False;
{$I License.inc}
  sFileName := m_Filelist[m_nFilelistPos];
{$I License.inc}
  EnCryptFileEx(sFileName);
{$I License.inc}
  if m_nFilelistPos < m_Filelist.Count - 1 then
    Inc(m_nFilelistPos)
  else
    m_nFilelistPos := 0;
  *)
end;

procedure TFrmDBSrv.QueryLevelRankData(nType, nPage: Integer; sCharName: string; Socket: TCustomWinSocket);
var
  s: string;
  i, n, j, r: Integer;
  boFind: Boolean;
  LR: THumanLevelRanks;
  HLR: THeroLevelRanks;
  pLR: pTHumanLevelRank;
  pHLR: pTHeroLevelRank;
  List: TGList;
begin
   List := nil;
   j := 0;
  if not boDataLRReady or not g_boOpenHRSystem then  Exit;

  if nType in [0..12] then   List := g_aLevelRankList[nType];

  if List = nil then  Exit;

  if nPage = High(Word) then
  begin
    if nType in [4..7] then
    begin
      boFind := False;
      s := DecodeString(sCharName);
      List.Lock;
      try
        for i := 0 to List.Count - 1 do
        begin
          pHLR := List.Items[i];
          if CompareText(pHLR.sMasterName, s) = 0 then
          begin
            j := i;
            boFind := True;
            Break;
          end;
        end;
      finally
        List.UnLock;
      end;
      if boFind then
      begin
        r := 0;
        FillChar(HLR, SizeOf(HLR), #0);
        List.Lock;
        try
          for i := (j div 10 * 10) to List.Count - 1 do
          begin
            pHLR := List.Items[i];
            HLR[r].sHeroName := pHLR.sHeroName;
            HLR[r].sMasterName := pHLR.sMasterName;
            HLR[r].nLevel := pHLR.nLevel;
            HLR[r].nIndex := i + 1;
            Inc(r);
            if r > 9 then
              Break;
          end;
        finally
          List.UnLock;
        end;
        m_DefMsg := MakeDefaultMsg(DBR_LOADRANKDATA, j div 10, nType, 0, 0);
        SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeBuffer(@HLR, SizeOf(THeroLevelRanks)));
      end
      else
      begin
        m_DefMsg := MakeDefaultMsg(DBR_LOADRANKDATA, -2, nType, 0, 0);
        SendSocket(Socket, EncodeMessage(m_DefMsg));
      end;
    end
    else
    begin
      boFind := False;
      s := DecodeString(sCharName);
      List.Lock;
      try
        for i := 0 to List.Count - 1 do
        begin
          pLR := List.Items[i];
          if CompareText(pLR.sCharName, s) = 0 then
          begin
            j := i;
            boFind := True;
            Break;
          end;
        end;
      finally
        List.UnLock;
      end;
      if boFind then
      begin
        r := 0;
        FillChar(LR, SizeOf(LR), #0);
        List.Lock;
        try
          for i := (j div 10 * 10) to List.Count - 1 do
          begin
            pLR := List.Items[i];
            LR[r].sCharName := pLR.sCharName;
            LR[r].nLevel := pLR.nLevel;
            LR[r].nIndex := i + 1;
            Inc(r);
            if r > 9 then
              Break;
          end;
        finally
          List.UnLock;
        end;
        m_DefMsg := MakeDefaultMsg(DBR_LOADRANKDATA, j div 10, nType, 0, 0);
        SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeBuffer(@LR, SizeOf(THumanLevelRanks)));
      end
      else
      begin
        m_DefMsg := MakeDefaultMsg(DBR_LOADRANKDATA, -2, nType, 0, 0);
        SendSocket(Socket, EncodeMessage(m_DefMsg));
      end;
    end;
  end
  else
  begin
    if nPage > 199 then
      nPage := 199;
    if nPage < 0 then
      nPage := 0;
    j := nPage * 10;
    n := nPage * 10 + 10;
    if nType in [4..7] then
    begin
      FillChar(HLR, SizeOf(HLR), #0);
      List.Lock;
      try
        if List.Count >= n then
        begin
          for i := j to n - 1 do
          begin
            pHLR := List.Items[i];
            HLR[i mod 10].sHeroName := pHLR.sHeroName;
            HLR[i mod 10].sMasterName := pHLR.sMasterName;
            HLR[i mod 10].nLevel := pHLR.nLevel;
            HLR[i mod 10].nIndex := i + 1;
          end;
          m_DefMsg := MakeDefaultMsg(DBR_LOADRANKDATA, nPage, nType, 0, 0);
          SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeBuffer(@HLR, SizeOf(THeroLevelRanks)));
        end
        else if List.Count > j then
        begin
          for i := j to List.Count - 1 do
          begin
            pHLR := List.Items[i];
            HLR[i mod 10].sHeroName := pHLR.sHeroName;
            HLR[i mod 10].sMasterName := pHLR.sMasterName;
            HLR[i mod 10].nLevel := pHLR.nLevel;
            HLR[i mod 10].nIndex := i + 1;
          end;
          m_DefMsg := MakeDefaultMsg(DBR_LOADRANKDATA, nPage, nType, 0, 0);
          SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeBuffer(@HLR, SizeOf(THeroLevelRanks)));
        end
        else if List.Count > 0 then
        begin
          n := 0;
          for i := List.Count - 1 downto 0 do
          begin
            pHLR := List.Items[i];
            HLR[i mod 10].sHeroName := pHLR.sHeroName;
            HLR[i mod 10].sMasterName := pHLR.sMasterName;
            HLR[i mod 10].nLevel := pHLR.nLevel;
            HLR[i mod 10].nIndex := i + 1;
            Inc(n);
            if n >= 10 then
              Break;
          end;
          if n > 0 then
          begin
            m_DefMsg := MakeDefaultMsg(DBR_LOADRANKDATA, 0, nType, 0, 0);
            SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeBuffer(@HLR, SizeOf(THeroLevelRanks)));
          end;
        end;
      finally
        List.UnLock;
      end;
    end
    else
    begin
      FillChar(LR, SizeOf(LR), #0);
      List.Lock;
      try
        if List.Count >= n then
        begin
          for i := j to n - 1 do
          begin
            pLR := List.Items[i];
            LR[i mod 10].sCharName := pLR.sCharName;
            LR[i mod 10].nLevel := pLR.nLevel;
            LR[i mod 10].nIndex := i + 1;
          end;
          m_DefMsg := MakeDefaultMsg(DBR_LOADRANKDATA, nPage, nType, 0, 0);
          SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeBuffer(@LR, SizeOf(THumanLevelRanks)));
        end
        else if List.Count > j then
        begin
          for i := j to List.Count - 1 do
          begin
            pLR := List.Items[i];
            LR[i mod 10].sCharName := pLR.sCharName;
            LR[i mod 10].nLevel := pLR.nLevel;
            LR[i mod 10].nIndex := i + 1;
          end;
          m_DefMsg := MakeDefaultMsg(DBR_LOADRANKDATA, nPage, nType, 0, 0);
          SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeBuffer(@LR, SizeOf(THumanLevelRanks)));
        end
        else if List.Count > 0 then
        begin
          n := 0;
          for i := List.Count - 1 downto 0 do
          begin
            pLR := List.Items[i];
            LR[i mod 10].sCharName := pLR.sCharName;
            LR[i mod 10].nLevel := pLR.nLevel;
            LR[i mod 10].nIndex := i + 1;
            Inc(n);
            if n >= 10 then
              Break;
          end;
          if n > 0 then
          begin
            m_DefMsg := MakeDefaultMsg(DBR_LOADRANKDATA, 0, nType, 0, 0);
            SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeBuffer(@LR, SizeOf(THumanLevelRanks)));
          end;
        end;
      finally
        List.UnLock;
      end;
    end;
  end;
  //LeaveCriticalSection(LR_CS);
end;

procedure TFrmDBSrv.btnReloadLRClick(Sender: TObject);
begin
  {FillChar(c, SizeOf(c), 0);
  c[0] := #$9F;
  c[1] := #$E6;
  c[2] := #$C8;
  c[3] := #$B5;
  c[4] := #$C4;
  if CheckChrName(c) then
    MainOutMessage('sucess...')
  else
    MainOutMessage('fail...');

  Exit;}
  if g_boOpenHRSystem then
  begin
    MainOutMessage('重新初始化排名数据...');
    RenewLevelRankData();
    MainOutMessage('排名系统数据计算完成...');
  end
  else
    MainOutMessage('排名系统未开放...');
end;

procedure TFrmDBSrv.GridGateSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  //
end;

end.
