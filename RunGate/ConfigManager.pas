unit ConfigManager;

interface

uses
  Windows, Messages, SysUtils, IniFiles,
  SyncObj, Protocol;

type
  TGameGateList = record
    sServerAdress: string[15];
    nServerPort: Integer;
    nGatePort: Integer;
  end;
  PTGameGateList = ^TGameGateList;

  TConfigMgr = class(TSyncObj) //Speed Lower then var record
    m_xIni: TIniFile;
    m_szTitle: string;
    m_fAddLog: LongBool;
    m_nShowLogLevel: Integer;
    m_nGateCount: Integer;
    m_xGameGateList: array[1..32] of TGameGateList;

    m_fCheckNullSession: LongBool;
    m_fOverSpeedSendBack: LongBool;
    m_fDefenceCCPacket: LongBool;
    m_fKickOverSpeed: LongBool;
    m_fDenyPresend: LongBool;
    m_fItemSpeedCompensate: LongBool;

    m_fDoMotaeboSpeedCheck: LongBool;
    m_fKickOverPacketSize: LongBool;
    m_nMaxConnectOfIP: Integer;
    m_nMaxClientCount: Integer;

    m_nClientTimeOutTime: Integer;
    m_nNomClientPacketSize: Integer;
    m_nMaxClientPacketSize: Integer;
    m_nMaxClientPacketCount: Integer;

    m_szCMDSpaceMove: string;
    m_szOverClientCntMsg: string;
    m_szHWIDBlockedMsg: string;
    m_szChatFilterReplace: string;
    m_szOverSpeedSendBack: string;
    m_szPacketDecryptFailed: string;
    m_szBlockHWIDFileName: string;

    m_fChatFilter: LongBool;
    m_fChatInterval: LongBool;
    m_fChatCmdFilter: LongBool;

    m_fTurnInterval: LongBool;
    m_fMoveInterval: LongBool;
    m_fSpellInterval: LongBool;
    m_fAttackInterval: LongBool;
    m_fButchInterval: LongBool;
    m_fSitDownInterval: LongBool;
    m_fSpaceMoveNextPickupInterval: LongBool;
    m_fPickupInterval: LongBool;
    m_fEatInterval: LongBool;

    m_fProcClientHWID: LongBool;

    m_nChatInterval: Integer;
    m_nTurnInterval: Integer;
    m_nMoveInterval: Integer;
    m_nSpellNextInterval: Integer;
    m_nAttackInterval: Integer;
    m_nButchInterval: Integer;
    m_nSitDownInterval: Integer;
    m_nPickupInterval: Integer;
    m_nEatInterval: Integer;
    m_nMoveNextSpellCompensate: Integer;
    m_nMoveNextAttackCompensate: Integer;

    m_nAttackNextMoveCompensate: Integer;
    m_nAttackNextSpellCompensate: Integer;
    m_nSpellNextMoveCompensate: Integer;
    m_nSpellNextAttackCompensate: Integer;

    m_nSpaceMoveNextPickupInterval: Integer;
    m_nPunishBaseInterval: Integer;
    m_nPunishIntervalRate: Double;
    m_nPunishMoveInterval: Integer;
    m_nPunishSpellInterval: Integer;
    m_nPunishAttackInterval: Integer;
    m_nMaxItemSpeed: Integer;
    m_nMaxItemSpeedRate: Integer;

    m_fClientShowHintNewType: LongBool;
    m_fOpenClientSpeedRate: LongBool;
    m_fSyncClientSpeed: LongBool;
    m_nClientMoveSpeedRate: Integer;
    m_nClientSpellSpeedRate: Integer;
    m_nClientAttackSpeedRate: Integer;

    m_tOverSpeedPunishMethod: TPunishMethod;
    m_tBlockIPMethod: TBlockIPMethod;
    m_tChatFilterMethod: TChatFilterMethod;
    m_tSpeedHackWarnMethod: TOverSpeedMsgMethod;
  public
    constructor Create(szFileName: string);
    destructor Destroy; override;
    function ReadString(const Section, Ident, Default: string): string;
    function ReadInteger(const Section, Ident: string; const Default: Integer): Integer;
    function ReadBool(const Section, Ident: string; const Default: Boolean): Boolean;
    function ReadFloat(const Section, Ident: string; const Default: Double): Double;
    procedure LoadConfig();
    procedure SaveConfig(nType: Integer);
  end;

var
  g_pConfig: TConfigMgr;

implementation

uses
  TableDef, AcceptExWorkedThread, ClientSession;

constructor TConfigMgr.Create(szFileName: string);
var
  i: Integer;
begin
  inherited Create;
  m_xIni := TIniFile.Create(szFileName);
  m_szTitle := '游戏网关';
  m_fAddLog := False;
  m_nShowLogLevel := 3;

  m_nGateCount := 1;
  for i := Low(m_xGameGateList) to High(m_xGameGateList) do
  begin
    m_xGameGateList[i].sServerAdress := '127.0.0.1';
    m_xGameGateList[i].nServerPort := 5000;
    m_xGameGateList[i].nGatePort := 7200 + i - 1;
  end;

  m_fCheckNullSession := True;
  m_fOverSpeedSendBack := False;
  m_fDefenceCCPacket := False;
  m_fKickOverSpeed := False;
  m_fDenyPresend := False;
  m_fItemSpeedCompensate := False;

  m_fDoMotaeboSpeedCheck := True;
  m_fKickOverPacketSize := True;
  m_tBlockIPMethod := mDisconnect;
  m_nNomClientPacketSize := 400;
  m_nMaxClientPacketSize := 10240;
  m_nMaxConnectOfIP := 50;
  m_nMaxClientCount := 50;
  m_nClientTimeOutTime := 15 * 1000;
  m_nMaxClientPacketCount := 15;

  m_szOverSpeedSendBack := '[提示]：请爱护游戏环境，关闭加速外挂重新登陆！';
  m_szCMDSpaceMove := 'Move';
  m_szPacketDecryptFailed := '[警告]：游戏连接被断开，请重新登陆！原因：使用非法外挂，客户端不配套，开启的客户端数量过多。';
  m_szOverClientCntMsg := '开启游戏过多，链接被断开！';
  m_szHWIDBlockedMsg := '机器码已被封，链接被断开！';
  m_szChatFilterReplace := '说话内容被屏蔽';

  m_szBlockHWIDFileName := ExtractFilePath(ParamStr(0)) + 'BlockHWID.txt';

  m_fChatCmdFilter := False;
  m_fChatFilter := True;
  m_fChatInterval := True;
  m_fTurnInterval := True;
  m_fMoveInterval := True;
  m_fSpellInterval := True;
  m_fAttackInterval := True;
  m_fButchInterval := True;
  m_fSitDownInterval := True;
  m_fSpaceMoveNextPickupInterval := True;
  m_fPickupInterval := True;
  m_fEatInterval := True;
  m_fProcClientHWID := False;

  m_nChatInterval := 800;
  m_nTurnInterval := 350;
  m_nMoveInterval := 570;
  m_nAttackInterval := 900;
  m_nButchInterval := 450;
  m_nSitDownInterval := 450;
  m_nPickupInterval := 330;
  m_nEatInterval := 330;

  m_nMoveNextSpellCompensate := 100;
  m_nMoveNextAttackCompensate := 250;

  m_nAttackNextMoveCompensate := 200;
  m_nAttackNextSpellCompensate := 200;
  m_nSpellNextMoveCompensate := 200;
  m_nSpellNextAttackCompensate := 200;

  m_nSpaceMoveNextPickupInterval := 600;

  m_nPunishBaseInterval := 20;
  m_nPunishIntervalRate := 1.00;
  m_tOverSpeedPunishMethod := ptDelaySend;

  m_nPunishMoveInterval := 150;
  m_nPunishSpellInterval := 150;
  m_nPunishAttackInterval := 150;

  m_tChatFilterMethod := ctReplaceAll;
  m_tSpeedHackWarnMethod := ptSysmsg;

  m_nMaxItemSpeed := 6;
  m_nMaxItemSpeedRate := 60;

  m_fClientShowHintNewType := True;
  m_fOpenClientSpeedRate := False;
  m_fSyncClientSpeed := False;

  m_nClientMoveSpeedRate := 0;
  m_nClientSpellSpeedRate := 0;
  m_nClientAttackSpeedRate := 0;

  {//if MAX_GAME_USER = 0 then begin
  if m_xIni.ReadInteger('Integer', 'MaxUser', -1) <= 500 then
    m_xIni.WriteInteger('Integer', 'MaxUser', 2500);
  MAX_GAME_USER := m_xIni.ReadInteger('Integer', 'MaxUser', 2500);
  MAX_LOGIN_USER := MAX_GAME_USER + 48;
  USER_ARRAY_COUNT := MAX_GAME_USER + 48;
  //end;
  SetLength(g_UserList, USER_ARRAY_COUNT);}
end;

destructor TConfigMgr.Destroy;
begin
  m_xIni.Free;
  inherited;
end;

function TConfigMgr.ReadString(const Section, Ident, Default: string): string;
var
  szLoadStr: string;
begin
  Result := Default;
  szLoadStr := m_xIni.ReadString(Section, Ident, '');
  if szLoadStr = '' then
    m_xIni.WriteString(Section, Ident, Default)
  else
    Result := szLoadStr;
end;

function TConfigMgr.ReadInteger(const Section, Ident: string; const Default: Integer): Integer;
var
  szLoadInt: Integer;
begin
  Result := Default;
  szLoadInt := m_xIni.ReadInteger(Section, Ident, -200000000);
  if szLoadInt <= -200000000 then
    m_xIni.WriteInteger(Section, Ident, Default)
  else
    Result := szLoadInt;
end;

function TConfigMgr.ReadBool(const Section, Ident: string; const Default: Boolean): Boolean;
var
  szLoadInt: Integer;
begin
  Result := Default;
  szLoadInt := m_xIni.ReadInteger(Section, Ident, -1);
  if szLoadInt < 0 then
    m_xIni.WriteBool(Section, Ident, Default)
  else
    Result := szLoadInt <> 0;
end;

function TConfigMgr.ReadFloat(const Section, Ident: string; const Default: Double): Double;
var
  szLoadDW: Double;
begin
  Result := Default;
  if m_xIni.ReadFloat(Section, Ident, 0) < 0.10 then
    m_xIni.WriteFloat(Section, Ident, Default)
  else
    Result := m_xIni.ReadFloat(Section, Ident, Default);
end;

procedure TConfigMgr.LoadConfig();
var
  i: Integer;
begin
  //String
  m_szTitle := ReadString('Strings', 'Title', m_szTitle);
  m_szCMDSpaceMove := ReadString('Strings', 'CMDSpaceMove', m_szCMDSpaceMove);
  m_szOverClientCntMsg := ReadString('Strings', 'OverClientCntMsg', m_szOverClientCntMsg);
  m_szHWIDBlockedMsg := ReadString('Strings', 'HWIDBlockedMsg', m_szHWIDBlockedMsg);
  m_szChatFilterReplace := ReadString('Strings', 'ChatFilterReplace', m_szChatFilterReplace);
  m_szOverSpeedSendBack := ReadString('Strings', 'OverSpeedSendBack', m_szOverSpeedSendBack);
  m_szPacketDecryptFailed := ReadString('Strings', 'PacketDecryptFailed', m_szPacketDecryptFailed);
  m_szBlockHWIDFileName := ReadString('Strings', 'BlockHWIDFileName', m_szBlockHWIDFileName);
  //Integer
  m_fAddLog := ReadBool('Switch', 'AddLog', m_fAddLog);
  m_nShowLogLevel := ReadInteger('Integer', 'ShowLogLevel', m_nShowLogLevel);
  m_nPunishMoveInterval := ReadInteger('Integer', 'PunishMoveInterval', m_nPunishMoveInterval);
  m_nPunishSpellInterval := ReadInteger('Integer', 'PunishSpellInterval', m_nPunishSpellInterval);
  m_nPunishAttackInterval := ReadInteger('Integer', 'PunishAttackInterval', m_nPunishAttackInterval);
  m_nMaxItemSpeed := ReadInteger('Integer', 'MaxItemSpeed', m_nMaxItemSpeed);
  m_nMaxItemSpeedRate := ReadInteger('Integer', 'MaxItemSpeedRate', m_nMaxItemSpeedRate);
  m_nMaxConnectOfIP := ReadInteger('Integer', 'MaxConnectOfIP', m_nMaxConnectOfIP);
  m_nMaxClientCount := ReadInteger('Integer', 'MaxClientCount', m_nMaxClientCount);

  m_nClientTimeOutTime := ReadInteger('Integer', 'ClientTimeOutTime', m_nClientTimeOutTime);
  if m_nClientTimeOutTime < 10 * 1000 then
  begin
    m_nClientTimeOutTime := 10 * 1000;
    m_xIni.WriteInteger('Integer', 'ClientTimeOutTime', m_nClientTimeOutTime);
  end;
  m_nClientTimeOutTime := ReadInteger('Integer', 'ClientTimeOutTime', m_nClientTimeOutTime);
  m_nNomClientPacketSize := ReadInteger('Integer', 'NomClientPacketSize', m_nNomClientPacketSize);
  m_nMaxClientPacketSize := ReadInteger('Integer', 'MaxClientPacketSize', m_nMaxClientPacketSize);
  m_nMaxClientPacketCount := ReadInteger('Integer', 'MaxClientPacketCount', m_nMaxClientPacketCount);
  m_nChatInterval := ReadInteger('Integer', 'ChatInterval', m_nChatInterval);
  m_nTurnInterval := ReadInteger('Integer', 'TurnInterval', m_nTurnInterval);
  m_nMoveInterval := ReadInteger('Integer', 'MoveInterval', m_nMoveInterval);
  m_nSpellNextInterval := ReadInteger('Integer', 'SpellNextInterval', m_nSpellNextInterval);
  m_nAttackInterval := ReadInteger('Integer', 'AttackInterval', m_nAttackInterval);
  m_nButchInterval := ReadInteger('Integer', 'ButchInterval', m_nButchInterval);
  m_nSitDownInterval := ReadInteger('Integer', 'SitDownInterval', m_nSitDownInterval);
  m_nPickupInterval := ReadInteger('Integer', 'PickupInterval', m_nPickupInterval);
  m_nEatInterval := ReadInteger('Integer', 'EatInterval', m_nEatInterval);
  m_nMoveNextSpellCompensate := ReadInteger('Integer', 'MoveNextSpellCompensate', m_nMoveNextSpellCompensate);
  m_nMoveNextAttackCompensate := ReadInteger('Integer', 'MoveNextAttackCompensate', m_nMoveNextAttackCompensate);

  m_nAttackNextMoveCompensate := ReadInteger('Integer', 'AttackNextMoveCompensate', m_nAttackNextMoveCompensate);
  m_nAttackNextSpellCompensate := ReadInteger('Integer', 'AttackNextSpellCompensate', m_nAttackNextSpellCompensate);
  m_nSpellNextMoveCompensate := ReadInteger('Integer', 'SpellNextMoveCompensate', m_nSpellNextMoveCompensate);
  m_nSpellNextAttackCompensate := ReadInteger('Integer', 'SpellNextAttackCompensate', m_nSpellNextAttackCompensate);

  m_nSpaceMoveNextPickupInterval := ReadInteger('Integer', 'SpaceMoveNextPickupInterval', m_nSpaceMoveNextPickupInterval);
  m_nPunishBaseInterval := ReadInteger('Integer', 'PunishBaseInterval', m_nPunishBaseInterval);
  m_nClientMoveSpeedRate := ReadInteger('Integer', 'ClientMoveSpeedRate', m_nClientMoveSpeedRate);
  m_nClientSpellSpeedRate := ReadInteger('Integer', 'ClientSpellSpeedRate', m_nClientSpellSpeedRate);
  m_nClientAttackSpeedRate := ReadInteger('Integer', 'ClientAttackSpeedRate', m_nClientAttackSpeedRate);

  //Method
  m_tOverSpeedPunishMethod := TPunishMethod(ReadInteger('Method', 'OverSpeedPunishMethod', Integer(m_tOverSpeedPunishMethod)));
  m_tBlockIPMethod := TBlockIPMethod(ReadInteger('Method', 'BlockIPMethod', Integer(m_tBlockIPMethod)));
  m_tChatFilterMethod := TChatFilterMethod(ReadInteger('Method', 'ChatFilterMethod', Integer(m_tChatFilterMethod)));
  m_tSpeedHackWarnMethod := TOverSpeedMsgMethod(ReadInteger('Method', 'SpeedHackWarnMethod', Integer(m_tSpeedHackWarnMethod)));

  //Boolean
  m_fCheckNullSession := ReadBool('Switch', 'CheckNullSession', m_fCheckNullSession);
  m_fOverSpeedSendBack := ReadBool('Switch', 'OverSpeedSendBack', m_fOverSpeedSendBack);
  m_fDefenceCCPacket := ReadBool('Switch', 'DefenceCCPacket', m_fDefenceCCPacket);
  m_fKickOverSpeed := ReadBool('Switch', 'KickOverSpeed', m_fKickOverSpeed);
  m_fDoMotaeboSpeedCheck := ReadBool('Switch', 'DoMotaeboSpeedCheck', m_fDoMotaeboSpeedCheck);
  m_fDenyPresend := ReadBool('Switch', 'DenyPresend', m_fDenyPresend);
  m_fItemSpeedCompensate := ReadBool('Switch', 'ItemSpeedCompensate', m_fItemSpeedCompensate);

  m_fKickOverPacketSize := ReadBool('Switch', 'KickOverPacketSize', m_fKickOverPacketSize);
  m_fChatFilter := ReadBool('Switch', 'ChatFilter', m_fChatFilter);
  m_fChatInterval := ReadBool('Switch', 'ChatInterval', m_fChatInterval);
  m_fChatCmdFilter := ReadBool('Switch', 'ChatCmdFilter', m_fChatCmdFilter);
  m_fTurnInterval := ReadBool('Switch', 'TurnInterval', m_fTurnInterval);
  m_fMoveInterval := ReadBool('Switch', 'MoveInterval', m_fMoveInterval);
  m_fSpellInterval := ReadBool('Switch', 'SpellInterval', m_fSpellInterval);
  m_fAttackInterval := ReadBool('Switch', 'AttackInterval', m_fAttackInterval);
  m_fButchInterval := ReadBool('Switch', 'ButchInterval', m_fButchInterval);
  m_fSitDownInterval := ReadBool('Switch', 'SitDownInterval', m_fSitDownInterval);
  m_fSpaceMoveNextPickupInterval := ReadBool('Switch', 'SpaceMoveNextPickupInterval', m_fSpaceMoveNextPickupInterval);
  m_fPickupInterval := ReadBool('Switch', 'PickupInterval', m_fPickupInterval);
  m_fEatInterval := ReadBool('Switch', 'EatInterval', m_fEatInterval);
  m_fProcClientHWID := ReadBool('Switch', 'ProcClientCount', m_fProcClientHWID);
  m_fClientShowHintNewType := ReadBool('Switch', 'ClientShowHintNewType', m_fClientShowHintNewType);
  m_fOpenClientSpeedRate := ReadBool('Switch', 'OpenClientSpeedRate', m_fOpenClientSpeedRate);
  m_fSyncClientSpeed := ReadBool('Switch', 'SyncClientSpeed', m_fSyncClientSpeed);

  m_nPunishIntervalRate := ReadFloat('Float', 'PunishIntervalRate', m_nPunishIntervalRate);

  m_nGateCount := ReadInteger('GameGate', 'Count', m_nGateCount);
  for i := 1 to m_nGateCount do
  begin
    m_xGameGateList[i].sServerAdress := ReadString('GameGate', 'ServerAddr' + IntToStr(i), m_xGameGateList[i].sServerAdress);
    m_xGameGateList[i].nServerPort := ReadInteger('GameGate', 'ServerPort' + IntToStr(i), m_xGameGateList[i].nServerPort);
    m_xGameGateList[i].nGatePort := ReadInteger('GameGate', 'GatePort' + IntToStr(i), m_xGameGateList[i].nGatePort);
  end;

  //Magic
  for i := 1 to High(MAIGIC_DELAY_TIME_LIST) do
  begin
    if MAIGIC_NAME_LIST[i] <> '' then
    begin
      MAIGIC_DELAY_TIME_LIST[i] := ReadInteger('MagicInterval', MAIGIC_NAME_LIST[i], MAIGIC_DELAY_TIME_LIST[i]);
    end;
  end;
end;

procedure TConfigMgr.SaveConfig(nType: Integer);
var
  i: Integer;
begin
  with m_xIni do
  begin
    case nType of
      0:
        begin
          WriteString('Strings', 'Title', m_szTitle);

          WriteBool('Switch', 'AddLog', m_fAddLog);
          WriteInteger('Integer', 'ShowLogLevel', m_nShowLogLevel);

          WriteInteger('GameGate', 'Count', m_nGateCount);
          for i := 1 to m_nGateCount do
          begin
            WriteString('GameGate', 'ServerAddr' + IntToStr(i), m_xGameGateList[i].sServerAdress);
            WriteInteger('GameGate', 'ServerPort' + IntToStr(i), m_xGameGateList[i].nServerPort);
            WriteInteger('GameGate', 'GatePort' + IntToStr(i), m_xGameGateList[i].nGatePort);
          end;
        end;
      1:
        begin
          WriteString('Strings', 'CMDSpaceMove', m_szCMDSpaceMove);
          WriteString('Strings', 'OverClientCntMsg', m_szOverClientCntMsg);
          WriteString('Strings', 'HWIDBlockedMsg', m_szHWIDBlockedMsg);

          WriteString('Strings', 'ChatFilterReplace', m_szChatFilterReplace);
          WriteString('Strings', 'OverSpeedSendBack', m_szOverSpeedSendBack);
          WriteString('Strings', 'PacketDecryptFailed', m_szPacketDecryptFailed);
          WriteString('Strings', 'BlockHWIDFileName', m_szBlockHWIDFileName);

          //Integer
          //WriteInteger('Integer', 'ShowLogLevel', m_nShowLogLevel);
          WriteInteger('Integer', 'PunishMoveInterval', m_nPunishMoveInterval);
          WriteInteger('Integer', 'PunishSpellInterval', m_nPunishSpellInterval);
          WriteInteger('Integer', 'PunishAttackInterval', m_nPunishAttackInterval);
          WriteInteger('Integer', 'MaxItemSpeed', m_nMaxItemSpeed);
          WriteInteger('Integer', 'MaxItemSpeedRate', m_nMaxItemSpeedRate);
          WriteInteger('Integer', 'MaxConnectOfIP', m_nMaxConnectOfIP);
          WriteInteger('Integer', 'MaxClientCount', m_nMaxClientCount);

          WriteInteger('Integer', 'ClientTimeOutTime', m_nClientTimeOutTime);
          WriteInteger('Integer', 'NomClientPacketSize', m_nNomClientPacketSize);
          WriteInteger('Integer', 'MaxClientPacketSize', m_nMaxClientPacketSize);
          WriteInteger('Integer', 'MaxClientPacketCount', m_nMaxClientPacketCount);
          WriteInteger('Integer', 'ChatInterval', m_nChatInterval);
          WriteInteger('Integer', 'TurnInterval', m_nTurnInterval);
          WriteInteger('Integer', 'MoveInterval', m_nMoveInterval);
          WriteInteger('Integer', 'SpellNextInterval', m_nSpellNextInterval);
          WriteInteger('Integer', 'AttackInterval', m_nAttackInterval);
          WriteInteger('Integer', 'ButchInterval', m_nButchInterval);
          WriteInteger('Integer', 'SitDownInterval', m_nSitDownInterval);
          WriteInteger('Integer', 'PickupInterval', m_nPickupInterval);
          WriteInteger('Integer', 'EatInterval', m_nEatInterval);
          WriteInteger('Integer', 'MoveNextSpellCompensate', m_nMoveNextSpellCompensate);
          WriteInteger('Integer', 'MoveNextAttackCompensate', m_nMoveNextAttackCompensate);

          WriteInteger('Integer', 'AttackNextMoveCompensate', m_nAttackNextMoveCompensate);
          WriteInteger('Integer', 'AttackNextSpellCompensate', m_nAttackNextSpellCompensate);
          WriteInteger('Integer', 'SpellNextMoveCompensate', m_nSpellNextMoveCompensate);
          WriteInteger('Integer', 'SpellNextAttackCompensate', m_nSpellNextAttackCompensate);

          WriteInteger('Integer', 'SpaceMoveNextPickupInterval', m_nSpaceMoveNextPickupInterval);
          WriteInteger('Integer', 'PunishBaseInterval', m_nPunishBaseInterval);
          WriteInteger('Integer', 'ClientMoveSpeedRate', m_nClientMoveSpeedRate);
          WriteInteger('Integer', 'ClientSpellSpeedRate', m_nClientSpellSpeedRate);
          WriteInteger('Integer', 'ClientAttackSpeedRate', m_nClientAttackSpeedRate);

          //Method
          WriteInteger('Method', 'OverSpeedPunishMethod', Integer(m_tOverSpeedPunishMethod));
          WriteInteger('Method', 'BlockIPMethod', Integer(m_tBlockIPMethod));
          WriteInteger('Method', 'ChatFilterMethod', Integer(m_tChatFilterMethod));
          WriteInteger('Method', 'SpeedHackWarnMethod', Integer(m_tSpeedHackWarnMethod));

          //Boolean
          WriteBool('Switch', 'CheckNullSession', m_fCheckNullSession);
          WriteBool('Switch', 'OverSpeedSendBack', m_fOverSpeedSendBack);
          WriteBool('Switch', 'DefenceCCPacket', m_fDefenceCCPacket);
          WriteBool('Switch', 'KickOverSpeed', m_fKickOverSpeed);
          WriteBool('Switch', 'DoMotaeboSpeedCheck', m_fDoMotaeboSpeedCheck);
          WriteBool('Switch', 'DenyPresend', m_fDenyPresend);
          WriteBool('Switch', 'ItemSpeedCompensate', m_fItemSpeedCompensate);


          WriteBool('Switch', 'KickOverPacketSize', m_fKickOverPacketSize);
          WriteBool('Switch', 'ChatFilter', m_fChatFilter);
          WriteBool('Switch', 'ChatInterval', m_fChatInterval);
          WriteBool('Switch', 'ChatCmdFilter', m_fChatCmdFilter);
          WriteBool('Switch', 'TurnInterval', m_fTurnInterval);
          WriteBool('Switch', 'MoveInterval', m_fMoveInterval);
          WriteBool('Switch', 'SpellInterval', m_fSpellInterval);
          WriteBool('Switch', 'AttackInterval', m_fAttackInterval);
          WriteBool('Switch', 'ButchInterval', m_fButchInterval);
          WriteBool('Switch', 'SitDownInterval', m_fSitDownInterval);
          WriteBool('Switch', 'SpaceMoveNextPickupInterval', m_fSpaceMoveNextPickupInterval);
          WriteBool('Switch', 'PickupInterval', m_fPickupInterval);
          WriteBool('Switch', 'EatInterval', m_fEatInterval);
          WriteBool('Switch', 'ProcClientCount', m_fProcClientHWID);

          WriteBool('Switch', 'ClientShowHintNewType', m_fClientShowHintNewType);
          WriteBool('Switch', 'OpenClientSpeedRate', m_fOpenClientSpeedRate);
          WriteBool('Switch', 'SyncClientSpeed', m_fSyncClientSpeed);

          WriteFloat('Float', 'PunishIntervalRate', m_nPunishIntervalRate);

          //Magic
          for i := 1 to High(MAIGIC_DELAY_TIME_LIST) do
          begin
            if MAIGIC_NAME_LIST[i] <> '' then
            begin
              WriteInteger('MagicInterval', MAIGIC_NAME_LIST[i], MAIGIC_DELAY_TIME_LIST[i]);
            end;
          end;
        end;
      2:
        begin

        end;
    end;
  end;
end;

end.
