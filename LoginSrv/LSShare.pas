unit LSShare;

interface
uses
  Windows, Messages, Classes, SysUtils, SyncObjs, MudUtil, IniFiles, Grobal2, sdk;
const
  DEBUG = 0;
  IDFILEMODE = 0; //文件模式
  IDDBMODE = 1; //数据库模式
  IDMODE = IDFILEMODE;

type
  TGateNet = record
    sIPaddr: string;
    nPort: Integer;
    boEnable: Boolean;
  end;
  TGateRoute = record
    sServerName: string;
    sTitle: string;
    sRemoteAddr: string;
    sPublicAddr: string;
    nSelIdx: Integer;
    Gate: array[0..9] of TGateNet;
  end;
  TConfig = packed record
    IniConf: TIniFile;
    boRemoteClose: Boolean;
    sDBServer: string[30];
    nDBSPort: Integer;
    sFeeServer: string[30];
    nFeePort: Integer;
    sLogServer: string[30];
    nLogPort: Integer;
    sGateAddr: string[30];
    nGatePort: Integer;
    sServerAddr: string[30];
    nServerPort: Integer;
    sMonAddr: string[30];
    nMonPort: Integer;
    sGateIPaddr: string[30];
    sIdDir: string[50];
    sWebLogDir: string[50];
    sFeedIDList: string[50];
    sFeedIPList: string[50];
    sCountLogDir: string[50];
    sChrLogDir: string[50];
    boTestServer: Boolean;
    boEnableMakingID: Boolean;
    boGetbackPassword: Boolean;
    boDynamicIPMode: Boolean;
    boAutoClear: Boolean;
    dwAutoClearTime: LongWord;
    nReadyServers: Integer;
    boAllowChangePassword: Boolean;

    GateCriticalSection: TRTLCriticalSection;
    GateList: TList;
    SessionList: TGList;
    ServerNameList: TStringList;
    AccountCostList: TQuickList;
    IPaddrCostList: TQuickList;
    boShowDetailMsg: Boolean;
    dwProcessGateTick: LongWord;
    dwProcessGateTime: LongWord;
    nRouteCount: Integer;
    GateRoute: array[0..59] of TGateRoute;
    dwAddNewUserTick: LongWord;
    dwChgPassWordTick: LongWord;
    dwUpdateUserInfoTick: LongWord;
    GetBackPasswordTick: LongWord;
    nLockIdTick: Integer;
    sSQLHost: string;
    sSQLDatabase: string;
    sSQLUserName: string;
    sSQLPassword: string;
    sSQLString: string;
    CLPort: Integer;
    CLPwd: Integer;
    CLOpen: Boolean;
  end;
  pTConfig = ^TConfig;

resourcestring
  sVersion = '更新日期: 2019-11-6';
  sPrograme = '程序制作: ';
  sOwen = '98KM2';
  sWebSite = '程序网站: http://www.98km2.com';
  SBBsSite = '程序论坛: http://bbs.98km2.com';

function CheckAccountName(sName: string): Boolean;
function GetSessionID(): Integer;
procedure SaveGateConfig(Config: pTConfig);
function GetGatePublicAddr(Config: pTConfig; sGateIP: string): string;
function GenSpaceString(sStr: string; nSpaceCOunt: Integer): string;
procedure MainOutMessage(sMsg: string);
procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);

var
  g_Config: TConfig = (
    boRemoteClose: False;
    sDBServer: '127.0.0.1';
    nDBSPort: 16300;
    sFeeServer: '127.0.0.1';
    nFeePort: 16301;
    sLogServer: '127.0.0.1';
    nLogPort: 16301;
    sGateAddr: '0.0.0.0';
    nGatePort: 5500;
    sServerAddr: '0.0.0.0';
    nServerPort: 5600;
    sMonAddr: '0.0.0.0';
    nMonPort: 3000;
    sGateIPaddr: '0.0.0.0';

    sIdDir: '.\DB\'; //0x00470D04
    sWebLogDir: '.\Share\'; //0x00470D08
    sFeedIDList: '.\FeedIDList.txt'; //0x00470D0C
    sFeedIPList: '.\FeedIPList.txt'; //0x00470D10
    sCountLogDir: '.\CountLog\'; //0x00470D14
    sChrLogDir: '.\ChrLog\';
    boTestServer: true;
    boEnableMakingID: true;
    boGetbackPassword: true;
    boDynamicIPMode: False;
    boAutoClear: False;
    dwAutoClearTime: 3000;
    nReadyServers: 0;
    boAllowChangePassword: true;
    boShowDetailMsg: False;
    dwAddNewUserTick: 5000;
    dwChgPassWordTick: 5000;
    dwUpdateUserInfoTick: 5000;
    GetBackPasswordTick: 5000;
    nLockIdTick: 60 * 1000;
    sSQLHost: '(LOCAL)';
    sSQLDatabase: '98KDB';
    sSQLUserName: '98KM2';
    sSQLPassword: '123456';
    CLPort: 3009;
    CLPwd: 12345;
    CLOpen: False;
    );

  FilterIPList: TStringList;
  ReviceMsgList: TList;
  StringList_0: TStringList; //0x0047538C
  nOnlineCountMin: Integer; //0x00475390
  nOnlineCountMax: Integer; //0x00475394
  nMemoHeigh: Integer; //0x00475398
  g_OutMessageCS: TRTLCriticalSection;
  g_MainMsgList: TStringList; //0x0047539C
  CS_DB: TCriticalSection; //0x004753A0
  n4753A4: Integer; //0x004753A4
  n4753A8: Integer; //0x004753A8
  n4753B0: Integer; //0x004753B0
  n47328C: Integer;
  nSessionIdx: Integer; //0x00473294
  g_n472A6C: Integer;
  g_n472A70: Integer;
  g_n472A74: Integer;
  g_boDataDBReady: Boolean; //0x00472A78
  bo470D20: Boolean;

  nVersionDate: Integer = 20011006;

  ServerAddr: array[0..99] of string[15];

  g_dwGameCenterHandle: THandle;
  g_boCloseLoginGate: Boolean = False;
  g_nCloseLoginGateTime: Integer = 8;

implementation

function CheckAccountName(sName: string): Boolean;
var
  I: Integer;
  nLen: Integer;
begin
  Result := False;
  if sName = '' then
    Exit;
  Result := true;
  nLen := Length(sName);
  I := 1;
  while (true) do
  begin
    if I > nLen then
      Break;
    if (sName[I] < '0') or (sName[I] > 'z') then
    begin
      Result := False;
      if (sName[I] >= #$B0) and (sName[I] <= #$C8) then
      begin
        Inc(I);
        if I <= nLen then
          if (sName[I] >= #$A1) and (sName[I] <= #$FE) then
            Result := true;
      end;
      if not Result then
        Break;
    end;
    Inc(I);
  end;
end;

function GetSessionID(): Integer;
begin
  Inc(nSessionIdx);
  if nSessionIdx >= High(Integer) then
    nSessionIdx := 2;
  Result := nSessionIdx;
end;

procedure SaveGateConfig(Config: pTConfig);
var
  SaveList: TStringList;
  I, n8: Integer;
  s10, sC: string;
begin
  SaveList := TStringList.Create;
  SaveList.Add(';No space allowed');
  SaveList.Add(GenSpaceString(';Server', 15) + GenSpaceString('Title', 15) + GenSpaceString('Remote', 17) + GenSpaceString('Public', 17) + 'Gate...');
  for I := 0 to Config.nRouteCount - 1 do
  begin
    sC := GenSpaceString(Config.GateRoute[I].sServerName, 15) + GenSpaceString(Config.GateRoute[I].sTitle, 15) + GenSpaceString(Config.GateRoute[I].sRemoteAddr, 17) + GenSpaceString(Config.GateRoute[I].sPublicAddr, 17);
    n8 := 0;
    while (true) do
    begin
      s10 := Config.GateRoute[I].Gate[n8].sIPaddr;
      if s10 = '' then
        Break;
      if not Config.GateRoute[I].Gate[n8].boEnable then
        s10 := '*' + s10;
      s10 := s10 + ':' + IntToStr(Config.GateRoute[I].Gate[n8].nPort);
      sC := sC + GenSpaceString(s10, 17);
      Inc(n8);
      if n8 >= 10 then
        Break;
    end;
    SaveList.Add(sC);
  end;
  SaveList.SaveToFile('.\!addrtable.txt');
  SaveList.Free;
end;

function GetGatePublicAddr(Config: pTConfig; sGateIP: string): string;
var
  I: Integer;
begin
  Result := sGateIP;
  for I := 0 to Config.nRouteCount - 1 do
  begin
    if Config.GateRoute[I].sRemoteAddr = sGateIP then
    begin
      Result := Config.GateRoute[I].sPublicAddr;
      Break;
    end;
  end;
end;

function GenSpaceString(sStr: string; nSpaceCOunt: Integer): string;
var
  I: Integer;
begin
  Result := sStr + ' ';
  for I := 1 to nSpaceCOunt - Length(sStr) do
  begin
    Result := Result + ' ';
  end;
end;

procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(Word(tLoginSrv), wIdent);
  SendData.cbData := Length(sSendMsg) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSendMsg));
  SendMessage(g_dwGameCenterHandle, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

procedure MainOutMessage(sMsg: string);
begin
  EnterCriticalSection(g_OutMessageCS);
  try
    g_MainMsgList.Add(sMsg)
  finally
    LeaveCriticalSection(g_OutMessageCS);
  end;
end;

initialization
  ReviceMsgList := TList.Create;
  InitializeCriticalSection(g_OutMessageCS);
  g_MainMsgList := TStringList.Create;

finalization
  g_MainMsgList.Free;
  DeleteCriticalSection(g_OutMessageCS);
  ReviceMsgList.Free;

end.
