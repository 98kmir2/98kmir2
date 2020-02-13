unit DBShare;

interface

uses
  Windows, Messages, Classes, SysUtils, IniFiles, Grobal2, MudUtil,
  D7ScktComp, SDK, tlhelp32, PsAPI, CnHashTable, GList;

type
  TGateInfo = record
    boUsed: Boolean;
    Socket: TCustomWinSocket;
    sText: string;
    UserList: TList;
    nGateID: Integer;
    sRemoteAddr: string;
    nRemotePort: Integer;
    sLocalAddr: string;
    nLocalPort: Integer;
    dwConnectTick: LongWord;
  end;
  pTGateInfo = ^TGateInfo;

  TUserInfo = record
    sAccount: string; //0x00
    sUserIPaddr: string; //0x04
    sGateIPaddr: string; //0x08
    sConnID: string; //0x0C
    nSessionID: Integer; //0x10
    Socket: TCustomWinSocket; //0x14
    sProcessMsg: string; //0x18
    boChrSelected: Boolean; //0x1C
    boChrQueryed: Boolean; //0x20
    dwChrTick: LongWord; //0x28
    nSelGateID: ShortInt; //0X2C
  end;
  pTUserInfo = ^TUserInfo;

procedure LoadConfig();
procedure SaveConfig();
function LoadIPTable(): Boolean;
procedure LoadGateID();
function GetGateID(sIPaddr: string): Integer;
function GetCodeMsgSize(X: Double): Integer;
function CheckChrName(sChrName: string): Boolean;
function InClearMakeIndexList(nIndex: Integer): Boolean;
procedure MainOutMessage(sMsg: string);
function CheckServerIP(sIP: string): Boolean;
procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);

resourcestring
  sGameCenter = 'GameCenter.exe';
  sM2server = 'M2Server.exe';
  sIPlocalDLL = 'IPLocal.dll';
  sPlugOfScript = 'mPlugOfScript.dll';
  sPlugOfEngine = 'mPlugOfEngine.dll';
  sSystemModule = 'mSystemModule.dll';
  sPlugOfAccess = 'mPlugOfAccess.dll';

var
  g_sSQLDatabase: string = '98KDB';
  g_sSQLHost: string = '127.0.0.1';
  g_sSQLUserName: string = '98KM2';
  g_sSQLPassword: string = '123456';

  sHumDBFilePath: string = '.\FDB\';
  sDataDBFilePath: string = '.\FDB\';
  sFeedPath: string = '.\FDB\';
  sBackupPath: string = '.\FDB\';
  sConnectPath: string = '.\Connects\';
  sLogPath: string = '.\Log\';
  sDBName: string = 'HeroDB';
  boShowItemName: Boolean = True;

  sWellCome: string = '欢迎使用98KM2数据库服务器';
  sProgram: string = '程序制作：';
  sOwen: string = '98KM2';
  sUpdate: string = '更新日期：2019/11/23';
  sWebSite: string = '程序网站：http://www.98km2.com';
  sBbsSite: string = '程序论坛：http://bbs.98km2.com';

  nServerPort: Integer = 6000;
  sServerAddr: string = '0.0.0.0';
  g_nGatePort: Integer = 5100;
  g_sGateAddr: string = '0.0.0.0';
  nIDServerPort: Integer = 5600;
  sIDServerAddr: string = '127.0.0.1';

  boViewHackMsg: Boolean = False;
  HumDB_CS: TRTLCriticalSection;
  //LR_CS                     : TRTLCriticalSection;

  n4ADAE4: Integer;
  n4ADAE8: Integer;
  n4ADAEC: Integer;
  n4ADAF0: Integer;
  boDataDBReady: Boolean;
  boDataLRReady: Boolean = False;
  boLRIng: Boolean = False;
  n4ADAFC: Integer;
  n4ADB00: Integer;
  n4ADB04: Integer;
  boHumDBReady: Boolean;
  g_nServerSocket: Integer;
  g_nProcSvrPacket: Integer;
  g_nSendSvrPacket: Integer;
  g_nErrSvrPacket: Integer;
  g_nErrorSvrMsg: Integer;
  boAutoClearDB: Boolean = False;
  g_nQueryChrCount: Integer;
  nHackerNewChrCount: Integer;
  nHackerDelChrCount: Integer;
  nHackerSelChrCount: Integer;
  n4ADC1C: Integer;
  n4ADC20: Integer;
  n4ADC24: Integer;
  n4ADC28: Integer;
  n4ADC2C: Integer;
  n4ADB10: Integer;
  n4ADB14: Integer;
  n4ADB18: Integer;
  n4ADBB8: Integer;
  bo4ADB1C: Boolean;

  sServerName: string = '热血传奇';
  sConfFileName: string = '.\Dbsrc.ini';
  sGateConfFileName: string = '.\!ServerInfo.txt';
  sServerIPConfFileNmae: string = '.\!AddrTable.txt';
  sGateIDConfFileName: string = '.\SelectID.txt';

  sMapFile: string;
  sAdminFile: string;
  AdminChrNameList: TCnHashTableSmall; //TStringList;
  DenyChrNameList: TStringList;
  DenyChrOfNameList: TStringList;
  ServerIPList: TStringList;
  GateIDList: TStringList;
  dwInterval: LongWord = 3000;

  nLevel1: Integer = 1;
  nLevel2: Integer = 7;
  nLevel3: Integer = 14;

  nDay1: Integer = 14; //清理未登录天数 1
  nDay2: Integer = 62; //清理未登录天数 2
  nDay3: Integer = 124; //清理未登录天数 3

  nMonth1: Integer = 0; //清理未登录月数 1
  nMonth2: Integer = 0; //清理未登录月数 2
  nMonth3: Integer = 0; //清理未登录月数 3

  g_nClearRecordCount: Integer;
  g_nClearIndex: Integer;
  g_nClearCount: Integer;
  g_nClearItemIndexCount: Integer;

  boOpenDBBusy: Boolean;
  g_dwGameCenterHandle: THandle = 0;
  g_CheckCode: TCheckCode;
  g_boDynamicIPMode: Boolean = False;
  g_ClearMakeIndex: TStringList;

  g_boGetChrAsHero: Boolean = False;
  g_boGetDelChrAsHero: Boolean = False;
  g_cbGetAllHeros: Boolean = False;
  g_fMutiHero: Boolean = True;

  g_boAllowGetBackDelChr: Boolean = True;
  g_boAllowCreateCharOpt1: Boolean = True;
  g_boOpenHRSystem: Boolean = True;
  g_boCloseSelGate: Boolean = False;
  g_boAllowDelChr: Boolean = True;
  g_boAllowMultiChr: Boolean = True;
  g_nAllowDelChrLvl: Integer = 0;
  g_nAllowMaxDelChrLvl: Integer = 65535;
  g_boUseSpecChar: Boolean = True;
  g_Conf: TIniFile;
  dwCheckServerTimeMin: LongWord;
  dwCheckServerTimeMax: LongWord;
  dwCheckServerTick: LongWord;

  dwCheckUserSocTimeMin: LongWord;
  dwCheckUserSocTimeMax: LongWord;
  dwCheckUserSocTick: LongWord;

  dwCheckIDSocTimeMin: LongWord;
  dwCheckIDSocTimeMax: LongWord;
  dwCheckIDSocTick: LongWord;
  //g_nCreateHeroRetCode      : Integer;
  g_sRemovedIP: string;
  g_sMachineId: string = '';
  g_sRegUserName: string = '';
  //g_boCmdRetInfoTick        : Boolean = False;
  //g_dwCmdRetInfoTick        : LongWord;
  //g_CmdUserInfo             : pTUserInfo;
  //g_sFileName               : string = '';
  g_RouteInfo: array[0..19] of TRouteInfo;
  g_nServerCount: Integer = 1;
  g_aLevelRankList: array[0..12] of TGList;
  g_dwRenewLevelRankList: LongWord = 0;
  g_dwRenewLevelRankTime: Integer = 60;
  g_dwRankLevelMin: Integer = 30;
  g_nCloseSelGateTime: Integer = 8;
  ChinaCode: array[0..25, 0..1] of Integer = (
    (1601, 1636),
    (1637, 1832),
    (1833, 2077),
    (2078, 2273),
    (2274, 2301),
    (2302, 2432),
    (2433, 2593),
    (2594, 2786),
    (9999, 0000),
    (2787, 3105),
    (3106, 3211),
    (3212, 3471),
    (3472, 3634),
    (3635, 3722),
    (3723, 3729),
    (3730, 3857),
    (3858, 4026),
    (4027, 4085),
    (4086, 4389),
    (4390, 4557),
    (9999, 0000),
    (9999, 0000),
    (4558, 4683),
    (4684, 4924),
    (4925, 5248),
    (5249, 5589));
  CHARFILTER: array[0..30] of Char = (
    //#$A9,
    ' ', '/', '@', '?', '''', '"', '\', '.', ',', ':', ';', '`', '~', '!', '#',
    '$', '%', '^', '&', '*', '(', ')', '-', '_', '+', '=', '|', '[', '{', ']', '}');
  g_SpaceCharList: string; //TStringList;

procedure InitLevelRankListArray();
procedure CutLevelRankListArray_Hero(List: TList);
procedure CutLevelRankListArray_Human(List: TList);

function IsFilterChar(c: Char): Boolean;
function IsFilterSpecChar(const AHzStr: string): Boolean;

implementation

uses DBSMain, HUtil32;

function IsFilterChar(c: Char): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(CHARFILTER) to High(CHARFILTER) do
    if c = CHARFILTER[i] then
    begin
      Result := True;
      Exit;
    end;
end;

function IsFilterSpecChar(const AHzStr: string): Boolean;
var
  IsChs: Boolean;
  i, J, L, HzOrd: Integer;
  ChsChar: array[0..1] of Char;
begin
  Result := False;
  L := Length(AHzStr);
  if not g_boUseSpecChar then
  begin
    i := 1;
    while L >= i do
    begin
      if (AHzStr[i] >= #$A0) and (L > i) and (AHzStr[i + 1] >= #$A0) then
      begin
        HzOrd := (Ord(AHzStr[i]) - $A0) * 100 + Ord(AHzStr[i + 1]) - $A0;
        IsChs := False;
        for J := 0 to 25 do
        begin
          if (HzOrd >= ChinaCode[J][0]) and (HzOrd <= ChinaCode[J][1]) then
          begin
            IsChs := True;
            Break;
          end;
        end;
        if not IsChs then
        begin
          Result := True;
          Exit;
        end;
        Inc(i);
      end;
      Inc(i);
    end;
    Exit;
  end;

  i := 1;
  while L >= i do
  begin
    if (AHzStr[i] >= #$A0) and (L > i) and (AHzStr[i + 1] >= #$A0) then
    begin
      HzOrd := (Ord(AHzStr[i]) - $A0) * 100 + Ord(AHzStr[i + 1]) - $A0;
      IsChs := False;
      for J := 0 to 25 do
      begin
        if (HzOrd >= ChinaCode[J][0]) and (HzOrd <= ChinaCode[J][1]) then
        begin
          IsChs := True;
          Break;
        end;
      end;
      if not IsChs then
      begin
        ChsChar[0] := AHzStr[i];
        ChsChar[1] := AHzStr[i + 1];
        if Pos(ChsChar, g_SpaceCharList) > 0 then
        begin
          Result := True;
          Exit;
        end;
      end;
      Inc(i);
    end;
    Inc(i);
  end;
end;

procedure InitLevelRankListArray();
var
  i, ii: Integer;
begin
  for i := Low(g_aLevelRankList) to High(g_aLevelRankList) do
  begin
    for ii := g_aLevelRankList[i].Count - 1 downto 0 do
    begin
      if i in [4..7] then
      begin
        Dispose(pTHeroLevelRank(g_aLevelRankList[i].Items[ii]));
      end
      else
      begin
        Dispose(pTHumanLevelRank(g_aLevelRankList[i].Items[ii]));
      end;
    end;
    g_aLevelRankList[i].Clear;
  end;
end;

procedure CutLevelRankListArray_Hero(List: TList);
var
  ii: Integer;
begin
  if List.Count > 2000 then
  begin
    for ii := List.Count - 1 downto 2000 do
    begin
      Dispose(pTHeroLevelRank(List[ii]));
      List.Delete(ii);
    end;
  end;
end;

procedure CutLevelRankListArray_Human(List: TList);
var
  ii: Integer;
begin
  if List.Count > 2000 then
  begin
    for ii := List.Count - 1 downto 2000 do
    begin
      Dispose(pTHumanLevelRank(List[ii]));
      List.Delete(ii);
    end;
  end;
end;

procedure LoadGateID();
var
  i: Integer;
  LoadList: TStringList;
  sLineText: string;
  sID: string;
  sIPaddr: string;
  nID: Integer;
begin
  GateIDList.Clear;
  if FileExists(sGateIDConfFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sGateIDConfFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      sLineText := LoadList.Strings[i];
      if (sLineText = '') or (sLineText[1] = ';') then
        Continue;
      sLineText := GetValidStr3(sLineText, sID, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sIPaddr, [' ', #9]);
      nID := Str_ToInt(sID, -1);
      if nID < 0 then
        Continue;
      GateIDList.AddObject(sIPaddr, TObject(nID))
    end;
    LoadList.Free;
  end
  else
  begin
    //LoadList := TStringList.Create;
    //LoadList.SaveToFile(sGateIDConfFileName);
    //LoadList.Free;
  end;
end;

function GetGateID(sIPaddr: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to GateIDList.Count - 1 do
  begin
    if GateIDList.Strings[i] = sIPaddr then
    begin
      Result := Integer(GateIDList.Objects[i]);
      Break;
    end;
  end;
end;

function LoadIPTable(): Boolean;
begin
  Result := True;
  if not FileExists(sServerIPConfFileNmae) then
  begin
    MainOutMessage(sServerIPConfFileNmae + ' 不存在！加载允许连接IP列表文件失败！');
    Result := False;
    Exit;
  end;

  ServerIPList.Clear;
  try
    ServerIPList.LoadFromFile(sServerIPConfFileNmae);
  except
    MainOutMessage('加载允许连接IP列表文件 ' + sServerIPConfFileNmae + ' 出错！');
    Result := False;
  end;
end;

procedure LoadConfig();
var
  LoadString: string;
begin
  if g_Conf <> nil then
  begin
    LoadString := g_Conf.ReadString('SqlConfig', 'SqlDataBase', '');
    if LoadString = '' then
      g_Conf.WriteString('SqlConfig', 'SqlDataBase', g_sSQLDatabase)
    else
      g_sSQLDatabase := LoadString;

    LoadString := g_Conf.ReadString('SqlConfig', 'SqlServerAddress', '');
    if LoadString = '' then
      g_Conf.WriteString('SqlConfig', 'SqlServerAddress', g_sSQLHost)
    else
      g_sSQLHost := LoadString;

    LoadString := g_Conf.ReadString('SqlConfig', 'SqlAccount', '');
    if LoadString = '' then
      g_Conf.WriteString('SqlConfig', 'SqlAccount', g_sSQLUserName)
    else
      g_sSQLUserName := LoadString;

    LoadString := g_Conf.ReadString('SqlConfig', 'SqlPassWord', '');
    if LoadString = '' then
      g_Conf.WriteString('SqlConfig', 'SqlPassWord', g_sSQLPassword)
    else
      g_sSQLPassword := LoadString;

    sDataDBFilePath := g_Conf.ReadString('DB', 'Dir', sDataDBFilePath);
    sHumDBFilePath := g_Conf.ReadString('DB', 'HumDir', sHumDBFilePath);
    sFeedPath := g_Conf.ReadString('DB', 'FeeDir', sFeedPath);
    sBackupPath := g_Conf.ReadString('DB', 'Backup', sBackupPath);
    sConnectPath := g_Conf.ReadString('DB', 'ConnectDir', sConnectPath);
    sLogPath := g_Conf.ReadString('DB', 'LogDir', sLogPath);

    //boAutoClearDB := g_Conf.ReadBool('DBClear', 'AutoClearDB', boAutoClearDB);
    dwInterval := g_Conf.ReadInteger('DBClear', 'Interval', dwInterval);
    nLevel1 := g_Conf.ReadInteger('DBClear', 'Level1', nLevel1);
    nLevel2 := g_Conf.ReadInteger('DBClear', 'Level2', nLevel2);
    nLevel3 := g_Conf.ReadInteger('DBClear', 'Level3', nLevel3);
    nDay1 := g_Conf.ReadInteger('DBClear', 'Day1', nDay1);
    nDay2 := g_Conf.ReadInteger('DBClear', 'Day2', nDay2);
    nDay3 := g_Conf.ReadInteger('DBClear', 'Day3', nDay3);
    nMonth1 := g_Conf.ReadInteger('DBClear', 'Month1', nMonth1);
    nMonth2 := g_Conf.ReadInteger('DBClear', 'Month2', nMonth2);
    nMonth3 := g_Conf.ReadInteger('DBClear', 'Month3', nMonth3);
    if g_Conf.ReadInteger('Setup', 'DynamicIPMode', -1) < 0 then
      g_Conf.WriteBool('Setup', 'DynamicIPMode', g_boDynamicIPMode)
    else
      g_boDynamicIPMode := g_Conf.ReadBool('Setup', 'DynamicIPMode', g_boDynamicIPMode);

    nServerPort := g_Conf.ReadInteger('Setup', 'ServerPort', nServerPort);
    sServerAddr := g_Conf.ReadString('Setup', 'ServerAddr', sServerAddr);
    g_nGatePort := g_Conf.ReadInteger('Setup', 'GatePort', g_nGatePort);
    g_sGateAddr := g_Conf.ReadString('Setup', 'GateAddr', g_sGateAddr);
    sIDServerAddr := g_Conf.ReadString('Server', 'IDSAddr', sIDServerAddr);
    nIDServerPort := g_Conf.ReadInteger('Server', 'IDSPort', nIDServerPort);
    boViewHackMsg := g_Conf.ReadBool('Setup', 'ViewHackMsg', boViewHackMsg);

    sDBName := g_Conf.ReadString('Setup', 'DBName', sDBName);
    g_boAllowGetBackDelChr := g_Conf.ReadBool('Setup', 'AllowGetBackDelChr', g_boAllowGetBackDelChr);
    g_boAllowDelChr := g_Conf.ReadBool('Setup', 'AllowDelChr', g_boAllowDelChr);
    g_boAllowMultiChr := g_Conf.ReadBool('Setup', 'AllowMultiChr', g_boAllowMultiChr);

    g_nAllowDelChrLvl := g_Conf.ReadInteger('Setup', 'AllowDelChrLvl', High(Word));
    g_nAllowMaxDelChrLvl := g_Conf.ReadInteger('Setup', 'AllowMaxDelChrLvl', High(Word));

    boShowItemName := g_Conf.ReadBool('Setup', 'ShowItemName', boShowItemName);
    g_boUseSpecChar := g_Conf.ReadBool('Setup', 'UseSpecChar', g_boUseSpecChar);
    g_boAllowCreateCharOpt1 := g_Conf.ReadBool('Setup', 'AllowCreateCharOpt1', g_boAllowCreateCharOpt1);
    g_boOpenHRSystem := g_Conf.ReadBool('Setup', 'OpenLevelRankSys', g_boOpenHRSystem);
    g_boCloseSelGate := g_Conf.ReadBool('Setup', 'CloseSelGate', g_boCloseSelGate);


    sServerName := g_Conf.ReadString('Setup', 'ServerName', sServerName);
    if g_Conf.ReadInteger('Setup', 'ServerCount', 0) < 1 then
      g_Conf.WriteInteger('Setup', 'ServerCount', g_nServerCount)
    else
      g_nServerCount := g_Conf.ReadInteger('Setup', 'ServerCount', g_nServerCount);

    if g_Conf.ReadInteger('Setup', 'ReInitLvRankTime', -1) < 0 then
      g_Conf.WriteInteger('Setup', 'ReInitLvRankTime', g_dwRenewLevelRankTime)
    else
      g_dwRenewLevelRankTime := g_Conf.ReadInteger('Setup', 'ReInitLvRankTime', g_dwRenewLevelRankTime);

    if g_Conf.ReadInteger('Setup', 'RankLevelMin', -1) < 0 then
      g_Conf.WriteInteger('Setup', 'RankLevelMin', g_dwRankLevelMin)
    else
      g_dwRankLevelMin := g_Conf.ReadInteger('Setup', 'RankLevelMin', g_dwRankLevelMin);

    if g_Conf.ReadInteger('Setup', 'CloseSelGateTime', -1) < 0 then
      g_Conf.WriteInteger('Setup', 'CloseSelGateTime', g_nCloseSelGateTime)
    else
      g_nCloseSelGateTime := g_Conf.ReadInteger('Setup', 'CloseSelGateTime', g_nCloseSelGateTime);


    if g_Conf.ReadInteger('Setup', 'GetChrAsHero', -1) < 0 then
      g_Conf.WriteBool('Setup', 'GetChrAsHero', g_boGetChrAsHero)
    else
      g_boGetChrAsHero := False; //g_Conf.ReadBool('Setup', 'GetChrAsHero', g_boGetChrAsHero);

    if g_Conf.ReadInteger('Setup', 'GetDelChrAsHero', -1) < 0 then
      g_Conf.WriteBool('Setup', 'GetDelChrAsHero', g_boGetDelChrAsHero)
    else
      g_boGetDelChrAsHero := False; //g_Conf.ReadBool('Setup', 'GetDelChrAsHero', g_boGetDelChrAsHero);

    if g_Conf.ReadInteger('Setup', 'GetAllHeros', -1) < 0 then
      g_Conf.WriteBool('Setup', 'GetAllHeros', g_cbGetAllHeros)
    else
      g_cbGetAllHeros := g_Conf.ReadBool('Setup', 'GetAllHeros', g_cbGetAllHeros);

    if g_Conf.ReadInteger('Setup', 'MutiHero', -1) < 0 then
      g_Conf.WriteBool('Setup', 'MutiHero', g_fMutiHero)
    else
      g_fMutiHero := g_Conf.ReadBool('Setup', 'MutiHero', g_fMutiHero);

  end;
  LoadIPTable();
  LoadGateID();
end;

procedure SaveConfig();
begin
  if g_Conf <> nil then
  begin
    g_Conf.WriteInteger('DBClear', 'Interval', dwInterval);
    g_Conf.WriteInteger('DBClear', 'Level1', nLevel1);
    g_Conf.WriteBool('DBClear', 'AutoClearDB', boAutoClearDB);
  end;
end;

function GetCodeMsgSize(X: Double): Integer;
begin
  if Int(X) < X then
    Result := Trunc(X) + 1
  else
    Result := Trunc(X)
end;

function CheckChrName(sChrName: string): Boolean;
var
  i, n: Integer;
  Chr: Char;
  boIsTwoByte: Boolean;
  FirstChr: Char;
begin
  Result := True;
  ///
  n := 0;
  for i := 1 to Length(sChrName) do
  begin
    case ByteType(sChrName, i) of
      mbSingleByte: Inc(n);
      mbLeadByte:
        begin
          Inc(n, 2); //汉字的第一个字节
          if i = Length(sChrName) then
          begin
            Result := False;
            Exit;
          end;
        end;
      mbTrailByte: ; //汉字的第二个字节
    end;
  end;
  if n <> Length(sChrName) then
  begin
    Result := False;
    Exit;
  end;

  boIsTwoByte := False;
  FirstChr := #0;
  for i := 1 to Length(sChrName) do
  begin
    Chr := (sChrName[i]);
    if boIsTwoByte then
    begin
      if not ((FirstChr <= #$F7) and (Chr >= #$40) and (Chr <= #$FE)) then
        if not ((FirstChr > #$F7) and (Chr >= #$40) and (Chr <= #$A0)) then
          Result := False;
      boIsTwoByte := False;
    end
    else
    begin
      if (Chr >= #$81) and (Chr <= #$FE) then
      begin
        boIsTwoByte := True;
        FirstChr := Chr;
      end
      else
      begin
        if not ((Chr >= '0' {#30}) and (Chr <= '9' {#39})) and
          not ((Chr >= 'a' {#61}) and (Chr <= 'z') {#7A}) and
          not ((Chr >= 'A' {#41}) and (Chr <= 'Z' {#5A})) then
          Result := False;
      end;
    end;
    if not Result then
      Break;
  end;
end;

function InClearMakeIndexList(nIndex: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to g_ClearMakeIndex.Count - 1 do
  begin
    if nIndex = Integer(g_ClearMakeIndex.Objects[i]) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure MainOutMessage(sMsg: string);
begin
  sMsg := '[' + TimeToStr(Now) + ']: ' + sMsg;
  FrmDBSrv.MemoLog.Lines.Add(sMsg);
end;

function CheckServerIP(sIP: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ServerIPList.Count - 1 do
  begin
    if CompareText(sIP, ServerIPList.Strings[i]) = 0 then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(Word(tDBServer), wIdent);
  SendData.cbData := Length(sSendMsg) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSendMsg));
  SendMessage(g_dwGameCenterHandle, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

initialization
  InitializeCriticalSection(HumDB_CS);
  //InitializeCriticalSection(LR_CS);
  DenyChrNameList := TStringList.Create;
  AdminChrNameList := TCnHashTableSmall.Create;
  DenyChrOfNameList := TStringList.Create;
  ServerIPList := TStringList.Create;
  GateIDList := TStringList.Create;
  g_ClearMakeIndex := TStringList.Create;
  g_Conf := TIniFile.Create(sConfFileName);

finalization
  DenyChrNameList.Free;
  DenyChrOfNameList.Free;
  ServerIPList.Free;
  GateIDList.Free;
  g_ClearMakeIndex.Free;
  AdminChrNameList.Free;
  g_Conf.Free;
  //DeleteCriticalSection(LR_CS);
  DeleteCriticalSection(HumDB_CS);

end.
