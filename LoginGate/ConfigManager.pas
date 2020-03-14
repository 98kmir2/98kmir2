unit ConfigManager;

interface

uses
  Windows, Messages, SysUtils, IniFiles,
  SyncObj, Protocol, AcceptExWorkedThread;

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
    m_nShowLogLevel: Integer;
    m_nGateCount: Integer;
    m_xGameGateList: array[1..MAX_SERVER_COUNT] of TGameGateList;

    m_fCheckNewIDOfIP: LongBool;
    m_fCheckNullSession: LongBool;
    m_fOverSpeedSendBack: LongBool;
    m_fDefenceCCPacket: LongBool;
    m_fKickOverSpeed: LongBool;
    m_fKickOverPacketSize: LongBool;

    m_nCheckNewIDOfIP: Integer;
    m_nMaxConnectOfIP: Integer;
    m_nClientTimeOutTime: Integer;
    m_nNomClientPacketSize: Integer;
    m_nMaxClientPacketCount: Integer;

    m_tBlockIPMethod: TBlockIPMethod;
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

constructor TConfigMgr.Create(szFileName: string);
var
  i: Integer;
begin
  inherited Create;
  m_xIni := TIniFile.Create(szFileName);
  m_szTitle := '登录网关'; //原来是名称是： 角色网关，明显错误
  m_nShowLogLevel := 3;

  m_nGateCount := 1;
  for i := Low(m_xGameGateList) to High(m_xGameGateList) do
  begin
    m_xGameGateList[i].sServerAdress := '127.0.0.1';
    m_xGameGateList[i].nServerPort := 5500;
    m_xGameGateList[i].nGatePort := 7000 + i - 1;
  end;

  m_fCheckNewIDOfIP := True;
  m_fCheckNullSession := True;
  m_fOverSpeedSendBack := False;
  m_fDefenceCCPacket := False;
  m_fKickOverSpeed := False;
  m_fKickOverPacketSize := True;

  m_nNomClientPacketSize := 400;
  m_nMaxConnectOfIP := 20;
  m_nCheckNewIDOfIP := 5;
  m_nClientTimeOutTime := 60 * 1000;
  m_nMaxClientPacketCount := 2;
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
  szLoadInt := m_xIni.ReadInteger(Section, Ident, -1);
  if szLoadInt < 0 then
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

  //Integer
  m_nShowLogLevel := ReadInteger('Integer', 'ShowLogLevel', m_nShowLogLevel);
  m_nClientTimeOutTime := ReadInteger('Integer', 'ClientTimeOutTime', m_nClientTimeOutTime);
  if m_nClientTimeOutTime < 10 * 1000 then
  begin
    m_nClientTimeOutTime := 10 * 1000;
    m_xIni.WriteInteger('Integer', 'ClientTimeOutTime', m_nClientTimeOutTime);
  end;

  m_nMaxConnectOfIP := ReadInteger('Integer', 'MaxConnectOfIP', m_nMaxConnectOfIP);
  m_nCheckNewIDOfIP := ReadInteger('Integer', 'CheckNewIDOfIP', m_nCheckNewIDOfIP);
  m_nClientTimeOutTime := ReadInteger('Integer', 'ClientTimeOutTime', m_nClientTimeOutTime);
  m_nNomClientPacketSize := ReadInteger('Integer', 'NomClientPacketSize', m_nNomClientPacketSize);
  m_nMaxClientPacketCount := ReadInteger('Integer', 'MaxClientPacketCount', m_nMaxClientPacketCount);

  //Boolean
  m_fCheckNewIDOfIP := ReadBool('Switch', 'CheckNewIDOfIP', m_fCheckNewIDOfIP);
  m_fCheckNullSession := ReadBool('Switch', 'CheckNullSession', m_fCheckNullSession);
  m_fOverSpeedSendBack := ReadBool('Switch', 'OverSpeedSendBack', m_fOverSpeedSendBack);
  m_fDefenceCCPacket := ReadBool('Switch', 'DefenceCCPacket', m_fDefenceCCPacket);
  m_fKickOverSpeed := ReadBool('Switch', 'KickOverSpeed', m_fKickOverSpeed);
  m_fKickOverPacketSize := ReadBool('Switch', 'KickOverPacketSize', m_fKickOverPacketSize);

  //
  m_tBlockIPMethod := TBlockIPMethod(ReadInteger('Method', 'BlockIPMethod', Integer(m_tBlockIPMethod)));

  m_nGateCount := ReadInteger('GameGate', 'Count', m_nGateCount);
  for i := 1 to m_nGateCount do
  begin
    m_xGameGateList[i].sServerAdress := ReadString('GameGate', 'ServerAddr' + IntToStr(i), m_xGameGateList[i].sServerAdress);
    m_xGameGateList[i].nServerPort := ReadInteger('GameGate', 'ServerPort' + IntToStr(i), m_xGameGateList[i].nServerPort);
    m_xGameGateList[i].nGatePort := ReadInteger('GameGate', 'GatePort' + IntToStr(i), m_xGameGateList[i].nGatePort);
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
          //Integer
          WriteInteger('Integer', 'MaxConnectOfIP', m_nMaxConnectOfIP);
          WriteInteger('Integer', 'CheckNewIDOfIP', m_nCheckNewIDOfIP);
          WriteInteger('Integer', 'ClientTimeOutTime', m_nClientTimeOutTime);
          WriteInteger('Integer', 'NomClientPacketSize', m_nNomClientPacketSize);
          WriteInteger('Integer', 'MaxClientPacketCount', m_nMaxClientPacketCount);

          //Boolean
          WriteBool('Switch', 'CheckNewIDOfIP', m_fCheckNewIDOfIP);
          WriteBool('Switch', 'CheckNullSession', m_fCheckNullSession);
          WriteBool('Switch', 'OverSpeedSendBack', m_fOverSpeedSendBack);
          WriteBool('Switch', 'DefenceCCPacket', m_fDefenceCCPacket);
          WriteBool('Switch', 'KickOverSpeed', m_fKickOverSpeed);
          WriteBool('Switch', 'KickOverPacketSize', m_fKickOverPacketSize);
          //
          WriteInteger('Method', 'BlockIPMethod', Integer(m_tBlockIPMethod));
        end;
      2:
        begin

        end;
    end;
  end;
end;

end.
