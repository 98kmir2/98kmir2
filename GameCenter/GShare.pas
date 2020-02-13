unit GShare;

interface

uses
  Windows, Messages, Classes, SysUtils, INIFiles;

type
  TProgram = record
    boGetStart: Boolean;
    boReStart: Boolean; //程序异常停止，是否重新启动
    btStartStatus: Byte; //0,1,2,3 未启动，正在启动，已启动,正在关闭
    sProgramFile: string[50];
    sDirectory: string[100];
    ProcessInfo: TProcessInformation;
    ProcessHandle: THandle;
    MainFormHandle: THandle;
    nMainFormX: Integer;
    nMainFormY: Integer;
    IsShowError: Boolean;
  end;
  pTProgram = ^TProgram;

procedure LoadConfig();
function RunProgram(var ProgramInfo: TProgram; sHandle: string; dwWaitTime: LongWord): LongWord;
function StopProgram(var ProgramInfo: TProgram; dwWaitTime: LongWord): Integer;
procedure SendProgramMsg(DesForm: THandle; wIdent: Word; sSendMsg: string);
function ExtractRes(ResType, ResName, ResNewName: string): Boolean;

var
  g_boMultiSvrSet: Boolean = False;
  g_boMainServer: Boolean = True;

  g_sMirDir: string = '';
  g_sEnvirDir: string = '';
  g_sSetupFile: string = '';

  g_sServerAddr: string = '0.0.0.0';
  g_nServerPort: Integer = 6350;
  g_SessionList: TStringList;

  g_sGameFile: string = '.\GameList.txt';
  g_sNoticeUrl: string = 'http://www.98km2.com';
  g_nClientForm: Integer = -1;

  g_nFormIdx: Integer;
  g_IniConf: TIniFile;
  g_sButtonStartGame: string = '启动游戏服务器(&S)';
  g_sButtonStopGame: string = '停止游戏服务器(&T)';
  g_sButtonStopStartGame: string = '中止启动游戏服务器(&T)';
  g_sButtonStopStopGame: string = '中止停止游戏服务器(&T)';
  //g_sInfo1                  : string = 'PAI=MQMLZQqOPcaHPC=]MqA>LQqQTPAWRaIMNaMNPRaLXPAQP@AISaMOLPmTX@@yPRA=PPi]TPuGPBADO@E=NA=OLCaMPPQhQ`yuNA<{XPMKL@@yQq=uO@i?TP]LLq=uOp@yVPy<VC\';
  //g_sInfo2                  : string = 'PADxZQMMKRmTOsQIP@=mOaE?LOqRLPQXRaE]O`m?LQ]JXOqEPA@yKAYORPiLLAAaOq<yUQYLVPuLPBQDPCAmXA=OKCaOPPQXQaEiNa=lLPaNLPQYPcA=WpmNPPuTLbAWP@AAR<';

  g_sConfFile: string = '.\Config.ini';
  g_sGameDirectory: string = 'D:\MirServer\';
  g_sHeroDBName: string = 'HeroDB';
  g_sGameName: string = '热血传奇';
  g_sGameName1: string = '热血传奇 - ';
  g_sAllIPaddr: string = '0.0.0.0';
  g_sLocalIPaddr: string = '127.0.0.1';
  g_sExtIPaddr: string = '192.168.1.5';
  g_boDynamicIPMode: Boolean = False;
  g_nLimitOnlineUser: Integer = 3000; //服务器最高上线人数

  g_sDBServer_ProgramFile: string = 'DBServer.exe';
  g_sDBServer_Directory: string = 'DBServer\';
  g_boDBServer_GetStart: Boolean = True;
  g_sDBServer_ConfigFile: string = 'dbsrc.ini';
  g_sDBServer_Config_ServerAddr: string = '127.0.0.1';
  g_nDBServer_Config_ServerPort: Integer = 6000;
  g_sDBServer_Config_GateAddr: string = '127.0.0.1';
  g_nDBServer_Config_GatePort: Integer = 5100;
  g_sDBServer_Config_IDSAddr: string = '127.0.0.1';
  g_nDBServer_Config_IDSPort: Integer = 5600;

  g_sDBServer_Config_RegKey: string = '0123456789';
  g_sDBServer_Config_RegServerAddr: string = '127.0.0.1';
  g_nDBServer_Config_RegServerPort: Integer = 63300;
  g_nDBServer_Config_Interval: Integer = 1000;
  g_nDBServer_Config_Level1: Integer = 1;
  g_nDBServer_Config_Level2: Integer = 7;
  g_nDBServer_Config_Level3: Integer = 14;
  g_nDBServer_Config_Day1: Integer = 7;
  g_nDBServer_Config_Day2: Integer = 62;
  g_nDBServer_Config_Day3: Integer = 124;
  g_nDBServer_Config_Month1: Integer = 0;
  g_nDBServer_Config_Month2: Integer = 0;
  g_nDBServer_Config_Month3: Integer = 0;

  g_sDBServer_Config_Dir: string = 'FDB\';
  g_sDBServer_Config_IdDir: string = 'FDB\';
  g_sDBServer_Config_HumDir: string = 'FDB\';
  g_sDBServer_Config_FeeDir: string = 'FDB\';
  g_sDBServer_Config_BackupDir: string = 'Backup\';
  g_sDBServer_Config_ConnectDir: string = 'Connection\';
  g_sDBServer_Config_LogDir: string = 'Log\';

  g_sDBServer_Config_MapFile: string = 'D:\MirServer\Mir200\Envir\MapInfo.txt';
  g_boDBServer_Config_ViewHackMsg: Boolean = False;
  g_sDBServer_AddrTableFile: string = '!addrtable.txt';
  g_sDBServer_ServerinfoFile: string = '!serverinfo.txt';
  g_nDBServer_MainFormX: Integer = 0;
  g_nDBServer_MainFormY: Integer = 326;
  g_boDBServer_DisableAutoGame: Boolean = False;

  g_sLoginServer_ProgramFile: string = 'LoginSrv.exe';
  g_sLoginServer_Directory: string = 'LoginSrv\';
  g_sLoginServer_ConfigFile: string = 'Logsrv.ini';
  g_boLoginServer_GetStart: Boolean = True;
  g_sLoginServer_GateAddr: string = '127.0.0.1';
  g_nLoginServer_GatePort: Integer = 5500;
  g_sLoginServer_ServerAddr: string = '127.0.0.1';
  g_nLoginServer_ServerPort: Integer = 5600;
  g_nLoginServer_ListenPort: Integer = 3000;

  g_sLoginServer_ReadyServers: Integer = 0;
  g_sLoginServer_EnableMakingID: Boolean = True;
  g_sLoginServer_EnableTrial: Boolean = False;
  g_sLoginServer_TestServer: Boolean = True;

  g_sLoginServer_IdDir: string = 'IDDB\';
  g_sLoginServer_FeedIDList: string = 'FeedIDList.txt';
  g_sLoginServer_FeedIPList: string = 'FeedIPList.txt';
  g_sLoginServer_CountLogDir: string = 'CountLog\';
  g_sLoginServer_WebLogDir: string = 'GameWFolder\';

  g_sLoginServer_AddrTableFile: string = '!addrtable.txt';
  g_sLoginServer_ServeraddrFile: string = '!serveraddr.txt';
  g_sLoginServerUserLimitFile: string = '!UserLimit.txt';
  g_sLoginServerFeedIDListFile: string = 'FeedIDList.txt';
  g_sLoginServerFeedIPListFile: string = 'FeedIPList.txt';
  g_nLoginServer_MainFormX: Integer = 253;
  g_nLoginServer_MainFormY: Integer = 0;
  g_nLoginServer_RouteList: TList;

  g_sLogServer_ProgramFile: string = 'LogDataServer.exe';
  g_sLogServer_Directory: string = 'LogServer\';
  g_boLogServer_GetStart: Boolean = True;
  g_sLogServer_ConfigFile: string = 'LogData.ini';
  g_sLogServer_BaseDir: string = 'BaseDir\';
  g_sLogServer_ServerAddr: string = '127.0.0.1';
  g_nLogServer_Port: Integer = 10000;
  g_nLogServer_MainFormX: Integer = 253;
  g_nLogServer_MainFormY: Integer = 239;

  g_sMirServer_ProgramFile: string = 'M2Server.exe';
  g_sMirServer_Directory: string = 'Mir200\';
  g_boMirServer_GetStart: Boolean = True;
  g_sMirServer_ConfigFile: string = '!setup.txt';
  g_sMirServer_AbuseFile: string = '!abuse.txt';
  g_sMirServer_RunAddrFile: string = '!runaddr.txt';
  g_sMirServer_ServerTableFile: string = '!servertable.txt';

  g_sMirServer_RegKey: string = '0123456789';
  g_sMirServer_Config_RegServerAddr: string = '127.0.0.1';
  g_nMirServer_Config_RegServerPort: Integer = 63000;

  g_nMirServer_ServerNumber: Integer = 0;
  g_nMirServer_ServerIndex: Integer = 0;
  g_boMirServer_VentureServer: Boolean = False;
  g_boMirServer_TestServer: Boolean = True;
  g_nMirServer_TestLevel: Integer = 1;
  g_nMirServer_TestGold: Integer = 0;
  g_boMirServer_ServiceMode: Boolean = False;
  g_boMirServer_NonPKServer: Boolean = False;
  g_sMirServer_MsgSrvAddr: string = '127.0.0.1';
  g_nMirServer_MsgSrvPort: Integer = 4900;
  g_sMirServer_GateAddr: string = '127.0.0.1';
  g_nMirServer_GatePort: Integer = 5000;

  g_sMirServer_BaseDir: string = 'Share\';
  g_sMirServer_GuildDir: string = 'GuildBase\Guilds\';
  g_sMirServer_GuildFile: string = 'GuildBase\Guildlist.txt';
  g_sMirServer_VentureDir: string = 'ShareV\';
  g_sMirServer_ConLogDir: string = 'ConLog\';
  g_sMirServer_LogDir: string = 'Log\';
  g_sMirServer_CastleDir: string = 'Castle\';
  g_sMirServer_EnvirDir: string = 'Envir\';
  g_sMirServer_MapDir: string = 'Map\';
  g_sMirServer_NoticeDir: string = 'Notice\';
  g_nMirServer_MainFormX: Integer = 560;
  g_nMirServer_MainFormY: Integer = 0;

  g_sLoginGate_ProgramFile: string = 'LoginGate.exe';
  g_sLoginGate_Directory: string = 'LoginGate\';
  g_boLoginGate_GetStart: Boolean = True;
  g_sLoginGate_ConfigFile: string = 'Config.ini';
  g_sLoginGate_ServerAddr: string = '127.0.0.1';
  g_nLoginGate_ServerPort: Integer = 5500;
  g_sLoginGate_GateAddr: string = '0.0.0.0';
  g_nLoginGate_GateCount: Integer = 1;
  g_nLoginGate_GatePort1: Integer = 7000;
  g_nLoginGate_GatePort2: Integer = 7001;
  g_nLoginGate_GatePort3: Integer = 7002;
  g_nLoginGate_GatePort4: Integer = 7003;
  g_nLoginGate_GatePort5: Integer = 7004;
  g_nLoginGate_GatePort6: Integer = 7005;
  g_nLoginGate_GatePort7: Integer = 7006;
  g_nLoginGate_GatePort8: Integer = 7007;

  g_nLoginGate_ShowLogLevel: Integer = 3;
  g_nLoginGate_MaxConnOfIPaddr: Integer = 20;
  g_nLoginGate_BlockMethod: Integer = 0;
  g_nLoginGate_KeepConnectTimeOut: Integer = 60000;
  g_nLoginGate_MainFormX: Integer = 0;
  g_nLoginGate_MainFormY: Integer = 0;

  g_sSelGate_ProgramFile: string = 'SelGate.exe';
  g_sSelGate_Directory: string = 'SelGate\';
  g_boSelGate_GetStart: Boolean = True;
  g_sSelGate_ConfigFile: string = 'Config.ini';
  g_sSelGate_ServerAddr: string = '127.0.0.1';
  g_nSelGate_ServerPort: Integer = 5100;

  g_nSeLGate_GateCount: Integer = 1;
  g_sSelGate_GateAddr: string = '0.0.0.0';
  g_nSeLGate_GatePort1: Integer = 7100;
  g_nSeLGate_GatePort2: Integer = 7101;
  g_nSeLGate_GatePort3: Integer = 7102;
  g_nSeLGate_GatePort4: Integer = 7103;
  g_nSeLGate_GatePort5: Integer = 7104;
  g_nSeLGate_GatePort6: Integer = 7105;
  g_nSeLGate_GatePort7: Integer = 7106;
  g_nSeLGate_GatePort8: Integer = 7107;

  g_nSelGate_ShowLogLevel: Integer = 3;
  g_nSelGate_MaxConnOfIPaddr: Integer = 20;
  g_nSelGate_BlockMethod: Integer = 0;
  g_nSelGate_KeepConnectTimeOut: Integer = 60000;
  g_nSelGate_MainFormX: Integer = 0;
  g_nSelGate_MainFormY: Integer = 163;

  g_sRunGate_ProgramFile: string = 'RunGate.exe';
  g_sRunGate_RegKey: string = 'ABCDEFGHIJKL';
  g_sRunGate_Directory: string = 'RunGate\';
  g_boRunGate_GetStart: Boolean = True;
  g_sRunGate_ConfigFile: string = 'Config.ini';
  g_nRunGate_Count: Integer = 3;
  g_sRunGate_ServerAddr: string = '127.0.0.1';
  g_nRunGate_ServerPort: Integer = 5000;
  g_sRunGate_GateAddr: string = '0.0.0.0';
  g_nRunGate_GatePort: Integer = 7210;
  g_sRunGate1_GateAddr: string = '0.0.0.0';
  g_nRunGate1_GatePort: Integer = 7310;
  g_sRunGate2_GateAddr: string = '0.0.0.0';
  g_nRunGate2_GatePort: Integer = 7410;
  g_sRunGate3_GateAddr: string = '0.0.0.0';
  g_nRunGate3_GatePort: Integer = 7510;
  g_sRunGate4_GateAddr: string = '0.0.0.0';
  g_nRunGate4_GatePort: Integer = 7610;
  g_sRunGate5_GateAddr: string = '0.0.0.0';
  g_nRunGate5_GatePort: Integer = 7710;
  g_sRunGate6_GateAddr: string = '0.0.0.0';
  g_nRunGate6_GatePort: Integer = 7810;
  g_sRunGate7_GateAddr: string = '0.0.0.0';
  g_nRunGate7_GatePort: Integer = 7910;
  g_sRunGate_Config_RegServerAddr: string = '127.0.0.1';
  g_nRunGate_Config_RegServerPort: Integer = 63200;

  DBServer: TProgram;
  LoginServer: TProgram;
  LogServer: TProgram;
  MirServer: TProgram;
  RunGate: TProgram;
  SelGate: TProgram;
  LoginGate: TProgram;
  g_dwStopTick: LongWord;
  g_dwStopTimeOut: LongWord = 10000;
  g_boShowDebugTab: Boolean = True;
  g_dwM2CheckCodeAddr: LongWord;
  g_dwDBCheckCodeAddr: LongWord;

  g_boLoginGateSleep: Boolean = True;
  g_nLoginGateSleep: Integer = 0;

implementation

uses
  GMain;

procedure LoadConfig();
var
  i: Integer;
  s: string;
begin
  with frmMain do
  begin
    CheckBox11.Checked := g_IniConf.ReadBool('CleanUpSet', 'GameEngine_Log', CheckBox11.Checked);
    CheckBox12.Checked := g_IniConf.ReadBool('CleanUpSet', 'GameEngineLoginLog', CheckBox12.Checked);
    CheckBox13.Checked := g_IniConf.ReadBool('CleanUpSet', 'GameEngineSabuk', CheckBox13.Checked);
    CheckBox14.Checked := g_IniConf.ReadBool('CleanUpSet', 'GameEngineGuild', CheckBox14.Checked);
    CheckBox15.Checked := g_IniConf.ReadBool('CleanUpSet', 'GameEnginePersonalMarket', CheckBox15.Checked);
    CheckBox16.Checked := g_IniConf.ReadBool('CleanUpSet', 'GameEngineMarket_Upg', CheckBox16.Checked);
    CheckBox17.Checked := g_IniConf.ReadBool('CleanUpSet', 'GameEngineMarket_Tmp', CheckBox17.Checked);
    CheckBox23.Checked := g_IniConf.ReadBool('CleanUpSet', 'GameEngineGlobal', CheckBox23.Checked);
    CheckBox18.Checked := g_IniConf.ReadBool('CleanUpSet', 'DBServer_FDB', CheckBox18.Checked);
    CheckBox19.Checked := g_IniConf.ReadBool('CleanUpSet', 'LoginSrv_IDDB', CheckBox19.Checked);
    CheckBox20.Checked := g_IniConf.ReadBool('CleanUpSet', 'LoginSrv_Chrlog', CheckBox20.Checked);
    CheckBox21.Checked := g_IniConf.ReadBool('CleanUpSet', 'LoginSrv_Countlog', CheckBox21.Checked);
    CheckBox22.Checked := g_IniConf.ReadBool('CleanUpSet', 'LogServer_Log', CheckBox22.Checked);

    for i := 0 to g_IniConf.ReadInteger('Text2CleanUp', 'Count', 0) - 1 do
    begin
      s := g_IniConf.ReadString('Text2CleanUp', format('TextFile%d', [i]), '');
      //if FileExists(s) then
      addToTextClearList(s);
    end;

    for i := 0 to g_IniConf.ReadInteger('Text2Delete', 'Count', 0) - 1 do
    begin
      s := g_IniConf.ReadString('Text2Delete', format('TextFile%d', [i]), '');
      //if FileExists(s) then
      addToTextClearList2(s);
    end;
  end;

  g_boMultiSvrSet := g_IniConf.ReadBool('GameConf', 'MultiSvrSet', g_boMultiSvrSet);
  g_boMainServer := g_IniConf.ReadBool('GameConf', 'MainServer', g_boMainServer);

  g_dwStopTimeOut := g_IniConf.ReadInteger('GameConf', 'dwStopTimeOut', g_dwStopTimeOut);
  g_boShowDebugTab := g_IniConf.ReadBool('GameConf', 'ShowDebugTab', g_boShowDebugTab);
  g_sGameDirectory := g_IniConf.ReadString('GameConf', 'GameDirectory', g_sGameDirectory);
  g_sHeroDBName := g_IniConf.ReadString('GameConf', 'HeroDBName', g_sHeroDBName);
  g_sGameName := g_IniConf.ReadString('GameConf', 'GameName', g_sGameName);
  g_sExtIPaddr := g_IniConf.ReadString('GameConf', 'ExtIPaddr', g_sExtIPaddr);
  g_boDynamicIPMode := g_IniConf.ReadBool('GameConf', 'DynamicIPMode', g_boDynamicIPMode);
  g_sDBServer_Config_RegKey := g_IniConf.ReadString('DBServer', 'RegKey', g_sDBServer_Config_RegKey);
  g_sDBServer_Config_RegServerAddr := g_IniConf.ReadString('DBServer', 'RegServerAddr', g_sDBServer_Config_RegServerAddr);
  g_nDBServer_Config_RegServerPort := g_IniConf.ReadInteger('DBServer', 'RegServerPort', g_nDBServer_Config_RegServerPort);
  g_nDBServer_MainFormX := g_IniConf.ReadInteger('DBServer', 'MainFormX', g_nDBServer_MainFormX);
  g_nDBServer_MainFormY := g_IniConf.ReadInteger('DBServer', 'MainFormY', g_nDBServer_MainFormY);
  g_nDBServer_Config_GatePort := g_IniConf.ReadInteger('DBServer', 'GatePort', g_nDBServer_Config_GatePort);
  g_nDBServer_Config_ServerPort := g_IniConf.ReadInteger('DBServer', 'ServerPort', g_nDBServer_Config_ServerPort);
  g_boDBServer_GetStart := g_IniConf.ReadBool('DBServer', 'GetStart', g_boDBServer_GetStart);

  g_sMirServer_RegKey := g_IniConf.ReadString('MirServer', 'RegKey', g_sMirServer_RegKey);
  g_sMirServer_Config_RegServerAddr := g_IniConf.ReadString('MirServer', 'RegServerAddr', g_sMirServer_Config_RegServerAddr);
  g_nMirServer_Config_RegServerPort := g_IniConf.ReadInteger('MirServer', 'RegServerPort', g_nMirServer_Config_RegServerPort);
  g_nMirServer_MainFormX := g_IniConf.ReadInteger('MirServer', 'MainFormX', g_nMirServer_MainFormX);
  g_nMirServer_MainFormY := g_IniConf.ReadInteger('MirServer', 'MainFormY', g_nMirServer_MainFormY);
  g_nMirServer_TestLevel := g_IniConf.ReadInteger('MirServer', 'TestLevel', g_nMirServer_TestLevel);
  g_nMirServer_TestGold := g_IniConf.ReadInteger('MirServer', 'TestGold', g_nMirServer_TestGold);
  g_nMirServer_GatePort := g_IniConf.ReadInteger('MirServer', 'GatePort', g_nMirServer_GatePort);
  g_nMirServer_MsgSrvPort := g_IniConf.ReadInteger('MirServer', 'MsgSrvPort', g_nMirServer_MsgSrvPort);
  g_boMirServer_GetStart := g_IniConf.ReadBool('MirServer', 'GetStart', g_boMirServer_GetStart);

  g_sRunGate_RegKey := g_IniConf.ReadString('RunGate', 'RegKey', g_sRunGate_RegKey);
  g_sRunGate_Config_RegServerAddr := g_IniConf.ReadString('RunGate', 'RegServerAddr', g_sRunGate_Config_RegServerAddr);
  g_nRunGate_Config_RegServerPort := g_IniConf.ReadInteger('RunGate', 'RegServerPort', g_nRunGate_Config_RegServerPort);

  g_nLoginGate_MainFormX := g_IniConf.ReadInteger('LoginGate', 'MainFormX', g_nLoginGate_MainFormX);
  g_nLoginGate_MainFormY := g_IniConf.ReadInteger('LoginGate', 'MainFormY', g_nLoginGate_MainFormY);
  g_boLoginGate_GetStart := g_IniConf.ReadBool('LoginGate', 'GetStart', g_boLoginGate_GetStart);
  g_nLoginGateSleep := g_IniConf.ReadInteger('LoginGate', 'SleepTick', g_nLoginGateSleep);
  g_boLoginGateSleep := g_IniConf.ReadBool('LoginGate', 'StartSleep', g_boLoginGateSleep);
  g_nLoginGate_GateCount := g_IniConf.ReadInteger('LoginGate', 'GateCount', g_nLoginGate_GateCount);
  g_nLoginGate_GatePort1 := g_IniConf.ReadInteger('LoginGate', 'GatePort', g_nLoginGate_GatePort1);
  g_nLoginGate_GatePort2 := g_IniConf.ReadInteger('LoginGate', 'GatePort2', g_nLoginGate_GatePort2);
  g_nLoginGate_GatePort3 := g_IniConf.ReadInteger('LoginGate', 'GatePort3', g_nLoginGate_GatePort3);
  g_nLoginGate_GatePort4 := g_IniConf.ReadInteger('LoginGate', 'GatePort4', g_nLoginGate_GatePort4);
  g_nLoginGate_GatePort5 := g_IniConf.ReadInteger('LoginGate', 'GatePort5', g_nLoginGate_GatePort5);
  g_nLoginGate_GatePort6 := g_IniConf.ReadInteger('LoginGate', 'GatePort6', g_nLoginGate_GatePort6);
  g_nLoginGate_GatePort7 := g_IniConf.ReadInteger('LoginGate', 'GatePort7', g_nLoginGate_GatePort7);
  g_nLoginGate_GatePort8 := g_IniConf.ReadInteger('LoginGate', 'GatePort8', g_nLoginGate_GatePort8);

  g_nSelGate_MainFormX := g_IniConf.ReadInteger('SelGate', 'MainFormX', g_nSelGate_MainFormX);
  g_nSelGate_MainFormY := g_IniConf.ReadInteger('SelGate', 'MainFormY', g_nSelGate_MainFormY);
  g_nSeLGate_GateCount := g_IniConf.ReadInteger('SelGate', 'GateCount', g_nSeLGate_GateCount);
  g_nSeLGate_GatePort1 := g_IniConf.ReadInteger('SelGate', 'GatePort', g_nSeLGate_GatePort1);
  g_nSeLGate_GatePort2 := g_IniConf.ReadInteger('SelGate', 'GatePort2', g_nSeLGate_GatePort2);
  g_nSeLGate_GatePort3 := g_IniConf.ReadInteger('SelGate', 'GatePort3', g_nSeLGate_GatePort3);
  g_nSeLGate_GatePort4 := g_IniConf.ReadInteger('SelGate', 'GatePort4', g_nSeLGate_GatePort4);
  g_nSeLGate_GatePort5 := g_IniConf.ReadInteger('SelGate', 'GatePort5', g_nSeLGate_GatePort5);
  g_nSeLGate_GatePort6 := g_IniConf.ReadInteger('SelGate', 'GatePort6', g_nSeLGate_GatePort6);
  g_nSeLGate_GatePort7 := g_IniConf.ReadInteger('SelGate', 'GatePort7', g_nSeLGate_GatePort7);
  g_nSeLGate_GatePort8 := g_IniConf.ReadInteger('SelGate', 'GatePort8', g_nSeLGate_GatePort8);
  g_boSelGate_GetStart := g_IniConf.ReadBool('SelGate', 'GetStart', g_boSelGate_GetStart);

  g_nRunGate_Count := g_IniConf.ReadInteger('RunGate', 'Count', g_nRunGate_Count);
  g_nRunGate_GatePort := g_IniConf.ReadInteger('RunGate', 'GatePort1', g_nRunGate_GatePort);
  g_nRunGate1_GatePort := g_IniConf.ReadInteger('RunGate', 'GatePort2', g_nRunGate1_GatePort);
  g_nRunGate2_GatePort := g_IniConf.ReadInteger('RunGate', 'GatePort3', g_nRunGate2_GatePort);
  g_nRunGate3_GatePort := g_IniConf.ReadInteger('RunGate', 'GatePort4', g_nRunGate3_GatePort);
  g_nRunGate4_GatePort := g_IniConf.ReadInteger('RunGate', 'GatePort5', g_nRunGate4_GatePort);
  g_nRunGate5_GatePort := g_IniConf.ReadInteger('RunGate', 'GatePort6', g_nRunGate5_GatePort);
  g_nRunGate6_GatePort := g_IniConf.ReadInteger('RunGate', 'GatePort7', g_nRunGate6_GatePort);
  g_nRunGate7_GatePort := g_IniConf.ReadInteger('RunGate', 'GatePort8', g_nRunGate7_GatePort);

  g_sDBServer_Config_GateAddr := g_sAllIPaddr;

  g_nLoginServer_MainFormX := g_IniConf.ReadInteger('LoginServer', 'MainFormX', g_nLoginServer_MainFormX);
  g_nLoginServer_MainFormY := g_IniConf.ReadInteger('LoginServer', 'MainFormY', g_nLoginServer_MainFormY);

  g_nLoginServer_GatePort := g_IniConf.ReadInteger('LoginServer', 'GatePort', g_nLoginServer_GatePort);
  g_nLoginServer_ServerPort := g_IniConf.ReadInteger('LoginServer', 'ServerPort', g_nLoginServer_ServerPort);

  g_nLoginServer_ListenPort := g_IniConf.ReadInteger('LoginServer', 'MonPort', g_nLoginServer_ListenPort);

  g_boLoginServer_GetStart := g_IniConf.ReadBool('LoginServer', 'GetStart', g_boLoginServer_GetStart);

  g_nLogServer_MainFormX := g_IniConf.ReadInteger('LogServer', 'MainFormX', g_nLogServer_MainFormX);
  g_nLogServer_MainFormY := g_IniConf.ReadInteger('LogServer', 'MainFormY', g_nLogServer_MainFormY);
  g_boLogServer_GetStart := g_IniConf.ReadBool('LogServer', 'GetStart', g_boLogServer_GetStart);
  g_nLogServer_Port := g_IniConf.ReadInteger('LogServer', 'Port', g_nLogServer_Port);

end;

function ExtractRes(ResType, ResName, ResNewName: string): Boolean;
var
  Res: TResourceStream;
begin
  try
    Res := TResourceStream.Create(Hinstance, ResName, PChar(ResType));
    try
      Res.SavetoFile(ResNewName);
      Result := True;
    finally
      Res.Free;
    end;
  except
    Result := False;
  end;
end;

function RunProgram(var ProgramInfo: TProgram; sHandle: string; dwWaitTime: LongWord): LongWord;
var
  StartupInfo: TStartupInfo;
  sCommandLine: string;
  sCurDirectory: string;
begin
  Result := 0;
  FillChar(StartupInfo, SizeOf(TStartupInfo), #0);
  GetStartupInfo(StartupInfo);
  sCommandLine := format('%s%s %s %d %d', [ProgramInfo.sDirectory, ProgramInfo.sProgramFile, sHandle, ProgramInfo.nMainFormX, ProgramInfo.nMainFormY]);
  sCurDirectory := ProgramInfo.sDirectory;
  if not CreateProcess(nil, //lpApplicationName,
    PChar(sCommandLine), //lpCommandLine,
    nil, //lpProcessAttributes,
    nil, //lpThreadAttributes,
    True, //bInheritHandles,
    0, //dwCreationFlags,
    nil, //lpEnvironment,
    PChar(sCurDirectory), //lpCurrentDirectory,
    StartupInfo, //lpStartupInfo,
    ProgramInfo.ProcessInfo) then //lpProcessInformation
    Result := GetLastError();
  Sleep(dwWaitTime);
end;

function StopProgram(var ProgramInfo: TProgram; dwWaitTime: LongWord): Integer;
var
  dwExitCode: LongWord;
begin
{$I '..\Common\Macros\VMPB.inc'}
  Result := 0;
  dwExitCode := 0;
  if TerminateProcess(ProgramInfo.ProcessHandle, dwExitCode) then
  begin
    Result := GetLastError();
  end;
  Sleep(dwWaitTime);
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure SendProgramMsg(DesForm: THandle; wIdent: Word; sSendMsg: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(0, wIdent);
  SendData.cbData := Length(sSendMsg) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSendMsg));
  SendMessage(DesForm, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

initialization
  g_IniConf := TIniFile.Create(g_sConfFile);
finalization
  g_IniConf.Free;

end.
