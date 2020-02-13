unit RunDB;

interface

uses
  Windows, SysUtils, Grobal2, WinSock, MudUtil;

procedure DBSOcketThread(ThreadInfo: pTThreadInfo); stdcall;
function DBSocketConnected(): Boolean;
function GetDBSockMsg(nQueryID: Integer; {var wSeries: word;} var nIdent: Integer; var nRecog: Integer; var sStr: string; dwTimeOut: LongWord; btLoadRcd: byte): Boolean;
function MakeHumRcdFromLocal(var HumanRcd: THumDataInfo): Boolean;
function LoadHumRcdFromDB(sAccount, sCharName, sStr: string; var HumanRcd: THumDataInfo; {var HerosInfo: THerosInfo;} nCertCode: Integer): Boolean;

function LoadHerosFromDB(sAccount, sCharName, sStr: string; var HerosInfo: THerosInfo; nCertCode: Integer): Boolean;

function SaveHumRcdToDB(sAccount, sCharName: string; nSessionID: Integer; {var} HumanRcd: THumDataInfo; var nHeroFlag: Integer): Boolean;
function SaveRcd(sAccount, sCharName: string; nSessionID: Integer; {var} HumanRcd: THumDataInfo; var nHeroFlag: Integer): Boolean;
function LoadRcd(sAccount, sCharName, sStr: string; nCertCode: Integer; var HumanRcd: THumDataInfo {; var HerosInfo: THerosInfo}): Boolean;
procedure SendDBSockMsg(nQueryID: Integer; sMsg: string; rep: Boolean = False);
function GetQueryID(Config: pTConfig): Integer;
function QueryLevelRank(nType, nPage: Integer; sCharName: string; var LR: string {THumanLevelRanks}; var HLR: string {THeroLevelRanks}): Integer;
function SendDBRegInfo(): Boolean;

implementation

uses M2Share, svMain, HUtil32, EDcode{$IF USEWLSDK = 1}, WinlicenseSDK{$ELSEIF USEWLSDK = 2}, SELicenseSDK, SESDK{$IFEND};

procedure DBSocketRead(Config: pTConfig);
var
  dwReceiveTimeTick: LongWord;
  nReceiveTime: Integer;
  sRecvText: string;
  nRecvLen: Integer;
  nRet: Integer;
begin
  if Config.DBSocket = INVALID_SOCKET then
    Exit;

  dwReceiveTimeTick := GetTickCount();
  nRet := ioctlsocket(Config.DBSocket, FIONREAD, nRecvLen);
  if (nRet = SOCKET_ERROR) or (nRecvLen = 0) then
  begin
    // nRet := WSAGetLastError;
    Config.DBSocket := INVALID_SOCKET;
    Sleep(100);
    Config.boDBSocketConnected := False;
    Exit;
  end;
  SetLength(sRecvText, nRecvLen);
  nRecvLen := recv(Config.DBSocket, Pointer(sRecvText)^, nRecvLen, 0);
  SetLength(sRecvText, nRecvLen);

  Inc(Config.nDBSocketRecvIncLen, nRecvLen);
  if (nRecvLen <> SOCKET_ERROR) and (nRecvLen > 0) then
  begin
    if nRecvLen > Config.nDBSocketRecvMaxLen then
      Config.nDBSocketRecvMaxLen := nRecvLen;
    EnterCriticalSection(UserDBSection);
    try
      Config.sDBSocketRecvText := Config.sDBSocketRecvText + sRecvText;
      if not Config.boDBSocketWorking then
      begin
        Config.sDBSocketRecvText := '';
      end;
    finally
      LeaveCriticalSection(UserDBSection);
    end;
  end;

  Inc(Config.nDBSocketRecvCount);
  nReceiveTime := GetTickCount - dwReceiveTimeTick;
  if Config.nDBReceiveMaxTime < nReceiveTime then
    Config.nDBReceiveMaxTime := nReceiveTime;
end;

procedure DBSocketProcess(Config: pTConfig; ThreadInfo: pTThreadInfo);
var
  s: TSocket;
  Name: sockaddr_in;
  HostEnt: PHostEnt;
  argp: Longint;
  readfds: TFDSet;
  timeout: TTimeVal;
  nRet: Integer;
  boRecvData: BOOL;
  nRunTime: Integer;
  dwRunTick: LongWord;
begin
  s := INVALID_SOCKET;
  if Config.DBSocket <> INVALID_SOCKET then
    s := Config.DBSocket;
  dwRunTick := GetTickCount();
  ThreadInfo.dwRunTick := dwRunTick;
  boRecvData := False;
  while True do
  begin
    if ThreadInfo.boTerminaled then
      Break;
    if not boRecvData then
      Sleep(1)
    else
      Sleep(0);
    boRecvData := False;
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
    if (Config.DBSocket = INVALID_SOCKET) or (s = INVALID_SOCKET) then
    begin
      if Config.DBSocket <> INVALID_SOCKET then
      begin
        Config.DBSocket := INVALID_SOCKET;
        Sleep(100);
        ThreadInfo.nRunFlag := 126;
        Config.boDBSocketConnected := False;
      end;
      if s <> INVALID_SOCKET then
      begin
        closesocket(s);
        s := INVALID_SOCKET;
      end;
      if Config.sDBAddr = '' then
        Continue;

      s := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
      if s = INVALID_SOCKET then
        Continue;

      ThreadInfo.nRunFlag := 127;

      HostEnt := gethostbyname(PChar(@Config.sDBAddr[1]));
      if HostEnt = nil then
        Continue;

      PInteger(@Name.sin_addr.S_addr)^ := PInteger(HostEnt.h_addr^)^;
      Name.sin_family := HostEnt.h_addrtype;
      Name.sin_port := htons(Config.nDBPort);
      Name.sin_family := PF_INET;

      ThreadInfo.nRunFlag := 128;
      if Connect(s, Name, SizeOf(Name)) = SOCKET_ERROR then
      begin
       // nRet := WSAGetLastError;

        closesocket(s);
        s := INVALID_SOCKET;
        Continue;
      end;

      argp := 1;
      if ioctlsocket(s, FIONBIO, argp) = SOCKET_ERROR then
      begin
        closesocket(s);
        s := INVALID_SOCKET;
        Continue;
      end;
      ThreadInfo.nRunFlag := 129;
      Config.DBSocket := s;
      if not Config.boDBSocketConnected then
        Config.boDBSocketConnected := True;
    end;
    readfds.fd_count := 1;
    readfds.fd_array[0] := s;
    timeout.tv_sec := 0;
    timeout.tv_usec := 20;
    ThreadInfo.nRunFlag := 130;
    nRet := select(0, @readfds, nil, nil, @timeout);
    if nRet = SOCKET_ERROR then
    begin
      ThreadInfo.nRunFlag := 131;
      nRet := WSAGetLastError;
      if nRet = WSAEWOULDBLOCK then
      begin
        Sleep(10);
        Continue;
      end;
      ThreadInfo.nRunFlag := 132;
      nRet := WSAGetLastError;
      Config.nDBSocketWSAErrCode := nRet - WSABASEERR;
      Inc(Config.nDBSocketErrorCount);
      Config.DBSocket := INVALID_SOCKET;
      Sleep(100);
      Config.boDBSocketConnected := False;
      closesocket(s);
      s := INVALID_SOCKET;
      Continue;
    end;
    boRecvData := True;
    ThreadInfo.nRunFlag := 133;
    while True do
    begin
      if nRet <= 0 then
        Break;
      DBSocketRead(Config);
      Dec(nRet);
    end;
  end;
  if Config.DBSocket <> INVALID_SOCKET then
  begin
    Config.DBSocket := INVALID_SOCKET;
    Config.boDBSocketConnected := False;
  end;
  if s <> INVALID_SOCKET then
  begin
    closesocket(s);
  end;
end;

procedure DBSOcketThread(ThreadInfo: pTThreadInfo); stdcall;
var
  nErrorCount: Integer;
resourcestring
  sExceptionMsg = '[Exception] DBSocketThread ErrorCount = %d';
begin
  nErrorCount := 0;
  while True do
  begin
    try
      DBSocketProcess(ThreadInfo.Config, ThreadInfo);
      Break;
    except
      Inc(nErrorCount);
      if nErrorCount > 10 then
        Break;
      MainOutMessageAPI(Format(sExceptionMsg, [nErrorCount]));
    end;
  end;
  ExitThread(0);
end;

function DBSocketConnected(): Boolean;
begin
{$IF DBSOCKETMODE = TIMERENGINE}
  Result := FrmMain.DBSocket.Socket.Connected;
{$ELSE}
  Result := g_Config.boDBSocketConnected;
{$IFEND}
end;

var
  g_btSleep: byte = 0;

function GetDBSockMsg(nQueryID: Integer; var nIdent: Integer; var nRecog: Integer; var sStr: string; dwTimeOut: LongWord; btLoadRcd: byte): Boolean;
var
  boLoadDBOK: Boolean;
  dwTimeOutTick: LongWord;
  s24, s28, s2C, sCheckFlag, sDefMsg, s38: string;
  nLen, nCertify, nEndPos: Integer;
  nCheckCode: Integer;
  DefMsg: TDefaultMessage;
resourcestring
  sLoadDBTimeOut = '[RunDB] 读取人物数据超时..';
  sSaveDBTimeOut = '[RunDB] 保存人物数据超时..';
begin
  boLoadDBOK := False;
  Result := False;
  dwTimeOutTick := GetTickCount();

  s24 := '';
  while (True) do
  begin
    if (GetTickCount - dwTimeOutTick) > dwTimeOut then
      Break;

    EnterCriticalSection(UserDBSection);
    try
      s24 := s24 + g_Config.sDBSocketRecvText;
      g_Config.sDBSocketRecvText := '';
    finally
      LeaveCriticalSection(UserDBSection);
    end;

    nEndPos := Pos('!', s24);
    if nEndPos > 0 then
    begin
      s28 := '';
      s24 := ArrestStringEx(s24, '#', '!', s28);
      if s28 <> '' then
      begin
        s28 := GetValidStr3(s28, s2C, ['/']);
        nCertify := Str_ToInt(s2C, 0);

        if nCertify = 0 then
        begin
          Sleep(0);
          Continue;
        end;

        nLen := Length(s28);
        if (nLen >= SizeOf(TDefaultMessage)) and (nCertify = nQueryID) then
        begin
          nCheckCode := MakeLong(nCertify xor $AA, nLen);
          sCheckFlag := EncodeBuffer(@nCheckCode, SizeOf(Integer));
          if CompareBackLStr(s28, sCheckFlag, Length(sCheckFlag)) then
          begin
            if nLen = DEFBLOCKSIZE then
            begin
              sDefMsg := s28;
              s38 := '';
            end
            else
            begin
              sDefMsg := Copy(s28, 1, DEFBLOCKSIZE);
              s38 := Copy(s28, DEFBLOCKSIZE + 1, Length(s28) - DEFBLOCKSIZE - 6);
            end;
            DefMsg := DecodeMessage(sDefMsg);
            nIdent := DefMsg.Ident;
            nRecog := DefMsg.Recog;
            //wSeries := DefMsg.Series;
            sStr := s38;
            boLoadDBOK := True;
            Result := True;
            Break;
          end
          else
          begin
            Inc(g_Config.nLoadDBErrorCount);
            Break;
          end;
        end
        else
        begin
          Inc(g_Config.nLoadDBErrorCount);
          Break;
        end;
      end;
      //Sleep(0);   //Exchange thread -- CPU
    end
    else
    begin
      {Inc(g_btSleep);
      if g_btSleep >= 5 then
        g_btSleep := 0;
      Sleep(Byte(g_btSleep <> 0));}
      Sleep(1);
    end;

    {
    直接 Sleep(0);  上3500人不黑
    }

    {
    end else          //1000 黑
      Sleep(1);
    }

    {
    g_boSleep := not g_boSleep;   //1800
    Sleep(byte(g_boSleep));
    }
  end;
  {while (True) do begin
    if (GetTickCount - dwTimeOutTick) > dwTimeOut then
      Break;
    s24 := '';
    EnterCriticalSection(UserDBSection);
    try
      if Pos('!', g_Config.sDBSocketRecvText) > 0 then begin
        s24 := g_Config.sDBSocketRecvText;
        g_Config.sDBSocketRecvText := '';
      end;
    finally
      LeaveCriticalSection(UserDBSection);
    end;
    if s24 <> '' then begin
      s28 := '';
      s24 := ArrestStringEx(s24, '#', '!', s28);
      if s28 <> '' then begin
        s28 := GetValidStr3(s28, s2C, ['/']);
        nLen := Length(s28);
        nCertify := Str_ToInt(s2C, 0);
        if (nLen >= SizeOf(TDefaultMessage)) and (nCertify = nQueryID) then begin
          nCheckCode := MakeLong(nCertify xor $AA, nLen);
          sCheckFlag := EncodeBuffer(@nCheckCode, SizeOf(Integer));
          if CompareBackLStr(s28, sCheckFlag, Length(sCheckFlag)) then begin
            if nLen = DEFBLOCKSIZE then begin
              sDefMsg := s28;
              s38 := '';
            end else begin
              sDefMsg := Copy(s28, 1, DEFBLOCKSIZE);
              s38 := Copy(s28, DEFBLOCKSIZE + 1, Length(s28) - DEFBLOCKSIZE - 6);
            end;
            DefMsg := DecodeMessage(sDefMsg);
            nIdent := DefMsg.Ident;
            nRecog := DefMsg.Recog;
            //wSeries := DefMsg.Series;
            sStr := s38;
            boLoadDBOK := True;
            Result := True;
            Break;
          end else begin
            Inc(g_Config.nLoadDBErrorCount);
            Break;
          end;
        end else begin
          Inc(g_Config.nLoadDBErrorCount);
          Break;
        end;
      end;
    end else
      Sleep(1);
  end;}
  if not boLoadDBOK then
  begin
    if btLoadRcd = 1 then
      MainOutMessageAPI(sLoadDBTimeOut)
    else if btLoadRcd = 0 then
      MainOutMessageAPI(sSaveDBTimeOut);
  end;
  if (GetTickCount - dwTimeOutTick) > dwRunDBTimeMax then
    dwRunDBTimeMax := GetTickCount - dwTimeOutTick;
  g_Config.boDBSocketWorking := False;
end;

function MakeHumRcdFromLocal(var HumanRcd: THumDataInfo): Boolean;
begin
  FillChar(HumanRcd, SizeOf(THumDataInfo), #0);
  HumanRcd.Data.Abil.Level := 30;
  Result := True;
end;

function LoadHerosFromDB(sAccount, sCharName, sStr: string; var HerosInfo: THerosInfo; nCertCode: Integer): Boolean;
var
  DefMsg: TDefaultMessage;
  LoadHuman: TLoadHuman;
  nQueryID: Integer;
  nIdent, nRecog: Integer;
  //wSeries                   : word;
  sDBMsg, sDBCharName: string;
  sRestStr, sHeros: string;
begin
  FillChar(HerosInfo, SizeOf(THerosInfo), #0);

  nQueryID := GetQueryID(@g_Config);
  DefMsg := MakeDefaultMsg(DB_LOADHEROS, 0, 0, 0, 0);
  LoadHuman.sAccount := sAccount;
  LoadHuman.sChrName := sCharName;
  LoadHuman.sUserAddr := sStr;
  LoadHuman.nSessionID := nCertCode;
  sDBMsg := EncodeMessage(DefMsg) + EncodeBuffer(@LoadHuman, SizeOf(TLoadHuman));
  SendDBSockMsg(nQueryID, sDBMsg {, True});
  if GetDBSockMsg(nQueryID, {wSeries,} nIdent, nRecog, sRestStr, 5000 - 3, 1) then
  begin
    if nIdent = DBR_LOADHEROS then
    begin
      if nRecog = 1 then
      begin
        sHeros := GetValidStr3(sRestStr, sDBMsg, ['/']);
        sDBCharName := DecodeString(sDBMsg);
        if sDBCharName = sCharName then
        begin
          //if GetCodeMsgSize(SizeOf(THerosInfo) * 4 / 3) = Length(sHeros) then begin
          DecodeBuffer(sHeros, @HerosInfo, SizeOf(THerosInfo));
          Result := True;
          //end;
        end
        else
          Result := False;
      end
      else
        Result := False;
    end
    else
      Result := False;
  end
  else
    Result := False;

  Inc(g_Config.nLoadDBCount);
end;

function LoadHumRcdFromDB(sAccount, sCharName, sStr: string; var HumanRcd: THumDataInfo; {var HerosInfo: THerosInfo;} nCertCode: Integer): Boolean;
begin
  Result := False;
  FillChar(HumanRcd, SizeOf(THumDataInfo), #0);
  //FillChar(HerosInfo, SizeOf(THerosInfo), #0);
  if LoadRcd(sAccount, sCharName, sStr, nCertCode, HumanRcd {, HerosInfo}) then
  begin
    if (HumanRcd.Data.sChrName = sCharName) and ((HumanRcd.Data.sAccount = '') or (HumanRcd.Data.sAccount = sAccount)) then
    begin
      Result := True;
    end
  end;
  Inc(g_Config.nLoadDBCount);
end;

function SaveHumRcdToDB(sAccount, sCharName: string; nSessionID: Integer; {var} HumanRcd: THumDataInfo; var nHeroFlag: Integer): Boolean;
begin
  Result := SaveRcd(sAccount, sCharName, nSessionID, HumanRcd, nHeroFlag);
  Inc(g_Config.nSaveDBCount);
end;

function SaveRcd(sAccount, sCharName: string; nSessionID: Integer; {var} HumanRcd: THumDataInfo; var nHeroFlag: Integer): Boolean;
var
  nQueryID: Integer;
  nIdent: Integer;
  nRecog: Integer;
  //wSeries                   : word;
  sRetCode: string;
begin
  nQueryID := GetQueryID(@g_Config);
  Result := False;

  if nHeroFlag = -1 then
  begin
    SendDBSockMsg(nQueryID, EncodeMessage(MakeDefaultMsg(DB_SAVEHUMANRCD, nSessionID, 0, 0, 0)) + EncodeString(sAccount) + '/' + EncodeString(sCharName) + '/' + EncodeBuffer(@HumanRcd, SizeOf(THumDataInfo)) + '/' + EncodeString('@HERO@'));
  end
  else if nHeroFlag = -3 then
  begin
    SendDBSockMsg(nQueryID, EncodeMessage(MakeDefaultMsg(DB_SAVEHUMANRCD, nSessionID, 0, 0, 0)) + EncodeString(sAccount) + '/' + EncodeString(sCharName) + '/' + EncodeBuffer(@HumanRcd, SizeOf(THumDataInfo)) + '/' + EncodeString('@HEROEX@'));
  end
  else
    SendDBSockMsg(nQueryID, EncodeMessage(MakeDefaultMsg(DB_SAVEHUMANRCD, nSessionID, 0, 0, 0)) + EncodeString(sAccount) + '/' + EncodeString(sCharName) + '/' + EncodeBuffer(@HumanRcd, SizeOf(THumDataInfo)));

  if GetDBSockMsg(nQueryID, {wSeries,} nIdent, nRecog, sRetCode, 5000 - 1, 0) then
  begin
    if sRetCode <> '' then
    begin
      sRetCode := DecodeString(sRetCode);
      nHeroFlag := StrToIntDef(sRetCode, 0);
    end;
    if (nIdent = DBR_SAVEHUMANRCD) and (nRecog = DBR_SAVERCDFLAG) then
      Result := True;
  end;
end;

function SendDBRegInfo(): Boolean;
{$IF USEWLSDK = 2}
var
  SELicenseUserInfo: sSELicenseUserInfoA;
{$IFEND USEWLSDK}
  //wSeries                   : word;
begin
  Result := False;
{$IF USEWLSDK = 1}
{$I '..\Common\Macros\VMPB.inc'}
  nQueryID := GetQueryID(@g_Config);
  if WLHardwareGetID(sMachineId) and WLHardwareCheckID(sMachineId) then
  begin
    sRegName := 'blue';
    sCompanyName := 'blue';
    sCustomData := 'blue';
    if WLRegGetStatus(nExtendedInfo) = wlIsRegistered then
      WLRegGetLicenseInfo(sRegName, sCompanyName, sCustomData);

    //if (StrPas(RegName) <> sLocalIP) or (StrPas(RegName) = '89FD97E4504A49BDC85E2C114DC7EE42') then begin

    sDBMsg := EncodeMessage(MakeDefaultMsg(DB_GETREMOVEDIP, 0, 0, 0, 0)) + EncodeString(StrPas(sMachineId)) + '/' + EncodeString(StrPas(sRegName));
    SendDBSockMsg(nQueryID, sDBMsg);
    sStr := '';
    if GetDBSockMsg(nQueryID, nIdent, nRecog, sStr, 5000 - 2, 2) then
    begin
      Result := False;
      if nIdent = DBR_GETREMOVEDIP then
      begin
        if sStr <> '' then
        begin
          Result := True;
        end;
      end
      else
        Result := False;
    end
    else
      Result := False;
  end
  else
  begin
    g_GuildManager.Free;
    g_EventManager.Free;
  end;
{$I '..\Common\Macros\VMPE.inc'}
{$ELSEIF USEWLSDK = 2}
{$I '..\Common\Macros\PROTECT_START.inc'}
  nQueryID := GetQueryID(@g_Config);

  if
{$IF V_TEST in [1, 2]}
  (SEGetHardwareIDA(sMachineId, 100) = SE_ERR_SUCCESS)
{$ELSE}
  (SEGetHardwareIDA(sMachineId, 100) = SE_ERR_SUCCESS) and (SECheckHardwareID() = SE_ERR_SUCCESS)
{$IFEND V_TEST} then
  begin
    sRegName := 'blue';
    sCompanyName := 'blue';
    sCustomData := 'blue';

    if SEGetLicenseUserInfoA(SELicenseUserInfo) = SE_ERR_SUCCESS then
    begin
      sDBMsg := EncodeMessage(MakeDefaultMsg(DB_GETREMOVEDIP, 0, 0, 0, 0)) + EncodeString(StrPas(sMachineId)) + '/' + EncodeString(StrPas(SELicenseUserInfo.UserID));
      SendDBSockMsg(nQueryID, sDBMsg);
      sStr := '';
      if GetDBSockMsg(nQueryID, {wSeries,} nIdent, nRecog, sStr, 5000 - 2, 2) then
      begin
        Result := False;
        if nIdent = DBR_GETREMOVEDIP then
        begin
          if sStr <> '' then
          begin
            Result := True;
          end;
        end
        else
          Result := False;
      end
      else
        Result := False;
    end
    else
      Result := False;
  end
  else
  begin
    g_GuildManager.Free;
    g_EventManager.Free;
  end;
{$I '..\Common\Macros\PROTECT_END.inc'}
{$IFEND}
end;

function QueryLevelRank(nType, nPage: Integer; sCharName: string; var LR: string {THumanLevelRanks}; var HLR: string {THeroLevelRanks}): Integer;
var
  DefMsg: TDefaultMessage;
  nQueryID: Integer;
  nIdent, nRecog: Integer;
  //wSeries                   : word;
  sLevelRankStr: string;
begin
  LR := '';
  HLR := '';
  Result := -3;
  nQueryID := GetQueryID(@g_Config);
  DefMsg := MakeDefaultMsg(DB_LOADRANKDATA, nType, nPage, 0, 0);
  SendDBSockMsg(nQueryID, EncodeMessage(DefMsg) + EncodeString(sCharName));
  if GetDBSockMsg(nQueryID, {wSeries,} nIdent, nRecog, sLevelRankStr, 2000, 2) then
  begin
    if nIdent = DBR_LOADRANKDATA then
    begin
      Result := nRecog;
      if nType in [4..7] then
      begin
        //if GetCodeMsgSize(SizeOf(THeroLevelRanks) * 4 / 3) = Length(sLevelRankStr) then
          //DecodeBuffer(sLevelRankStr, @HLR, SizeOf(THeroLevelRanks));
        HLR := sLevelRankStr;
      end
      else
      begin
        //if GetCodeMsgSize(SizeOf(THumanLevelRanks) * 4 / 3) = Length(sLevelRankStr) then
          //DecodeBuffer(sLevelRankStr, @LR, SizeOf(THumanLevelRanks));
        LR := sLevelRankStr;
      end;
    end;
  end;
end;

function LoadRcd(sAccount, sCharName, sStr: string; nCertCode: Integer; var HumanRcd: THumDataInfo): Boolean;
var
  DefMsg: TDefaultMessage;
  LoadHuman: TLoadHuman;
  nQueryID: Integer;
  nIdent, nRecog: Integer;
  sHumanRcdStr: string;
  sDBMsg, sDBCharName: string;
begin
  nQueryID := GetQueryID(@g_Config);
  DefMsg := MakeDefaultMsg(DB_LOADHUMANRCD, 0, 0, 0, 0);
  LoadHuman.sAccount := sAccount;
  LoadHuman.sChrName := sCharName;
  LoadHuman.sUserAddr := sStr;
  LoadHuman.nSessionID := nCertCode;
  sDBMsg := EncodeMessage(DefMsg) + EncodeBuffer(@LoadHuman, SizeOf(TLoadHuman));
  SendDBSockMsg(nQueryID, sDBMsg {, True});
  if GetDBSockMsg(nQueryID, nIdent, nRecog, sHumanRcdStr, 5000, 1) then
  begin
    if nIdent = DBR_LOADHUMANRCD then
    begin
      if nRecog = DBR_LOADRCDFLAG then
      begin
        sHumanRcdStr := GetValidStr3(sHumanRcdStr, sDBMsg, ['/']);
        sDBCharName := DecodeString(sDBMsg);
        if sDBCharName = sCharName then
        begin
          //if GetCodeMsgSize(SizeOf(THumDataInfo) * 4 / 3) = Length(sHumanRcdStr) then begin
          DecodeBuffer(sHumanRcdStr, @HumanRcd, SizeOf(THumDataInfo));
          Result := True;
          //end;
        end
        else
          Result := False;
      end
      else
        Result := False;
    end
    else
      Result := False;
  end
  else
    Result := False;
end;

(*
function LoadRcd(sAccount, sCharName, sStr: string; nCertCode: Integer; var HumanRcd: THumDataInfo{; var HerosInfo: THerosInfo}): Boolean;
var
  DefMsg                    : TDefaultMessage;
  LoadHuman                 : TLoadHuman;
  i, nQueryID               : Integer;
  nIdent, nRecog            : Integer;
  //wSeries                   : word;
  sHumanRcdStr              : string;
  sDBMsg, sDBCharName       : string;
  sRestStr, sHeros          : string;
begin
  nQueryID := GetQueryID(@g_Config);
  DefMsg := MakeDefaultMsg(DB_LOADHUMANRCD, 0, 0, 0, 0);
  LoadHuman.sAccount := sAccount;
  LoadHuman.sChrName := sCharName;
  LoadHuman.sUserAddr := sStr;
  LoadHuman.nSessionID := nCertCode;
  sDBMsg := EncodeMessage(DefMsg) + EncodeBuffer(@LoadHuman, SizeOf(TLoadHuman));
  SendDBSockMsg(nQueryID, sDBMsg {, True});
  if GetDBSockMsg(nQueryID, {wSeries,} nIdent, nRecog, sRestStr, 5000, 1) then begin
    Result := False;
    if nIdent = DBR_LOADHUMANRCD then begin
      if nRecog = DBR_LOADRCDFLAG then begin

        sRestStr := GetValidStr3(sRestStr, sDBMsg, ['/']);
        sDBCharName := DecodeString(sDBMsg);

        if wSeries = 2 then begin
          sHeros := GetValidStr3(sRestStr, sHumanRcdStr, ['/']);
          if sDBCharName = sCharName then begin
            if GetCodeMsgSize(SizeOf(THumDataInfo) * 4 / 3) = Length(sHumanRcdStr) then begin
              DecodeBuffer(sHumanRcdStr, @HumanRcd, SizeOf(THumDataInfo));
              Result := True;
            end;
            {if (GetCodeMsgSize(SizeOf(THerosInfo) * 4 / 3) = Length(sHeros)) then begin
              DecodeBuffer(sHeros, @HerosInfo, SizeOf(THerosInfo));
            end;}
          end else
            Result := False;
        end else begin
          sHumanRcdStr := sRestStr;
          if sDBCharName = sCharName then begin
            if GetCodeMsgSize(SizeOf(THumDataInfo) * 4 / 3) = Length(sHumanRcdStr) then begin
              DecodeBuffer(sHumanRcdStr, @HumanRcd, SizeOf(THumDataInfo));
              Result := True;
            end;
          end else
            Result := False;
        end;
      end else
        Result := False;
    end else
      Result := False;
  end else
    Result := False;
end;
*)

procedure SendDBSockMsg(nQueryID: Integer; sMsg: string; rep: Boolean);
var
  sSENDMSG: string;
  n, nn, nCheckCode: Integer;
  sCheckStr: string;
  Config: pTConfig;
{$IF DBSOCKETMODE <> TIMERENGINE}
  ThreadInfo: pTThreadInfo;
{$IFEND DBSOCKETMODE}
begin
  Config := @g_Config;
  if not DBSocketConnected then
    Exit;
  EnterCriticalSection(UserDBSection);
  try
    Config.sDBSocketRecvText := '';
  finally
    LeaveCriticalSection(UserDBSection);
  end;
  nCheckCode := MakeLong(nQueryID xor $AA, Length(sMsg) + 6);
  sCheckStr := EncodeBuffer(@nCheckCode, SizeOf(Integer));
  sSENDMSG := '#' + IntToStr(nQueryID) + '/' + sMsg + sCheckStr + '!';
  Config.boDBSocketWorking := True;
{$IF DBSOCKETMODE = TIMERENGINE}
  if rep then
  begin
    n := 0;
    while n < 5 do
    begin
      nn := FrmMain.DBSocket.Socket.SendText(sSENDMSG);
      if nn < 0 then
      begin
        Inc(n);
        Sleep(0);
        Continue;
      end;
      Break;
    end;
  end
  else
  begin
    FrmMain.DBSocket.Socket.SendText(sSENDMSG);
  end;
{$ELSE}
  ThreadInfo := @g_Config.DBSOcketThread;
  s := Config.DBSocket;
  boSendData := False;
  while True do
  begin
    if not boSendData then
      Sleep(1)
    else
      Sleep(0);
    boSendData := False;
    ThreadInfo.dwRunTick := GetTickCount();
    ThreadInfo.boActived := True;
    ThreadInfo.nRunFlag := 128;
    //ThreadInfo.nRunFlag := 129;
    timeout.tv_sec := 0;
    timeout.tv_usec := 20;

    writefds.fd_count := 1;
    writefds.fd_array[0] := s;

    nRet := select(0, nil, @writefds, nil, @timeout);
    if nRet = SOCKET_ERROR then
    begin
      nRet := WSAGetLastError();
      Config.nDBSocketWSAErrCode := nRet - WSABASEERR;
      Inc(Config.nDBSocketErrorCount);
      if nRet = WSAEWOULDBLOCK then
        Continue;
      if Config.DBSocket = INVALID_SOCKET then
        Break;
      Config.DBSocket := INVALID_SOCKET;
      Sleep(100);
      Config.boDBSocketConnected := False;
      Break;
    end;
    if nRet <= 0 then
      Continue;
    boSendData := True;
    nRet := send(s, sSENDMSG[1], Length(sSENDMSG), 0);
    if nRet = SOCKET_ERROR then
    begin
      Inc(Config.nDBSocketErrorCount);
      Config.nDBSocketWSAErrCode := WSAGetLastError - WSABASEERR;
      Continue;
    end;
    Inc(Config.nDBSocketSendLen, nRet);
    Break;
  end;
{$IFEND}
end;

function GetQueryID(Config: pTConfig): Integer;
begin
  Inc(Config.nDBQueryID);
  if Config.nDBQueryID > High(SmallInt) - 1 then
    Config.nDBQueryID := 1;
  Result := Config.nDBQueryID;
end;

end.
