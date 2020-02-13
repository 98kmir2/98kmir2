unit UsrEngn;

interface
uses
  Windows, Classes, SysUtils, StrUtils, Forms, ObjBase, ObjNpc, Envir, Grobal2, {$IF USEHASHLIST = 1}CnHashTable, {$IFEND}
  MudUtil, FrnEngn, IniFiles, ObjectHero, ObjectHeroMon, Guild, HashList;

type
  TUserEngine = class
    m_LoadPlaySection: TRTLCriticalSection;
    m_LoadPlayList: TStringList;
    m_SavePlaySection: TRTLCriticalSection;
    m_SavePlayList: TList;
    m_PlayObjectList: TStringList;
    m_OtherUserNameList: TStringList;
    m_PlayObjectFreeList: TList;
    dwShowOnlineTick: LongWord;
    dwSendOnlineHumTime: LongWord;
    dwProcessMapDoorTick: LongWord;
    dwProcessEffectsTick: LongWord;
    dwProcessMissionsTime: LongWord;
    dwRegenMonstersTick: LongWord;
    m_dwProcessLoadPlayTick: LongWord;
    m_dwProcessSavePlayTick: LongWord;
    m_nCurrMonGen: Integer;
    m_nMonGenListPosition: Integer;
    m_nMonGenCertListPosition: Integer;
    m_nProcHumIDx: Integer;
    nProcessHumanLoopTime: Integer;
    nMerchantPosition: Integer;
    m_nHeroPosition: Integer;
    m_nEscortPosition: Integer;
    nNpcPosition: Integer;
    StdItemList: TList;
    TitleList: TList;
    MonsterList: {$IF USEHASHLIST = 1}TCnHashTableSmall{$ELSE}TList{$IFEND};
    MonSpAbilList: TCnHashTableSmall;
    m_MonGenList: TList;
    //m_MonFreeList: TList;
    m_MagicList: TList;
    m_AdminList: TGList;
    m_MerchantList: TGList;
    m_HeroProcList: TList;
    m_EscortProcList: TList;

    QuestNPCList: TList;
    m_ChangeServerList: TList;
    m_MagicEventList: TList;
    m_MagicEventCloseList: TList;
    nMonsterCount: Integer;
    nMonsterProcessPostion: Integer;
    //nMonsterProcessCount: Integer;
    dwProcessMonstersTick: LongWord;
    dwProcessMerchantTimeMin: Integer;
    dwProcessMerchantTimeMax: Integer;
    dwProcessHeroTimeMin: Integer;
    dwProcessHeroTimeMax: Integer;
    dwProcessNpcTimeMin: LongWord;
    dwProcessNpcTimeMax: LongWord;
    m_NewHumanList: TList;
    m_ListOfGateIdx: TList;
    m_ListOfSocket: TList;
    m_MagicListPre: TList;
    m_MapEffectList: TList;
  private
    procedure ProcessHumans();
    procedure ProcessMonsters();
    procedure ProcessMerchants();
    procedure ProcessHero();
    procedure ProcessEscort;
    procedure ProcessNpcs();
    // procedure ProcessMissions();                 
    procedure ProcessEvents();
    procedure ProcessMapDoor();
    procedure ProcessEffects();
    procedure NPCinitialize;
    procedure MerchantInitialize;

    function EffectTarget(x, y: Integer; Envir: TEnvirnoment): Boolean;
    function EffectSearchTarget(x, y: Integer; Envir: TEnvirnoment): TBaseObject;
    function RegenMonsters(MonGen: pTMonGenInfo; nCount: Integer): Boolean;
    // function GetGenMonCount(MonGen: pTMonGenInfo): Integer;       
    function AddBaseObject(sMapName: string; nX, nY: Integer; nMonRace: Integer; sMonName: string): TBaseObject;
    function CreateHero(sCharName: string; MasterObj: TPlayObject; btHeroType: byte): TBaseObject;
    procedure KickOnlineUser(sChrName: string);
    procedure AddToHumanFreeList(PlayObject: TPlayObject);
    procedure GetHumData(PlayObject: TBaseObject; {var} HumanRcd: THumDataInfo);
    function GetHomeInfo(var nX: Integer; var nY: Integer): string;
    function GetRandHomeX(PlayObject: TPlayObject): Integer;
    function GetRandHomeY(PlayObject: TPlayObject): Integer;
    procedure MonInitialize(BaseObject: TBaseObject; sMonName: string);
    function GetOnlineHumCount(): Integer;
    //function GetOnlineHeroCount(): Integer;
    //function GetTotalHeroCount(): Integer;

    function GetLoadPlayCount(): Integer;
    function GetOfflinePlayCount(): Integer;
    function GetOfflinePlayCountCS(): Integer;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Initialize();
    procedure ClearItemList(); virtual;

    function GetUserCount(): Integer;

    function MonGetRandomItems(Mon, ItemOfCreat: TBaseObject): Integer;
    procedure SwitchMagicList();
    procedure Run(); //dynamic;
    procedure PrcocessData();
    procedure Execute;

    function MonGetAbility(Mon: TBaseObject): Integer;
    function MonGetRandomUseItems(Mon: TBaseObject): Integer;

    function RegenMonsterByName(sMAP: string; nX, nY: Integer; sMonName: string): TBaseObject;
    function RegenHero(sMonName: string; Master: TPlayObject; btHeroType: byte): TBaseObject;
    function RegenEscort(sMAP: string; sMonName: string; PlayObject: TPlayObject): TBaseObject;
    function GetEscort(sCharName: string): TBaseObject;

    function GetTitle(nItemIdx: Integer): pTStdItem; overload;
    function GetTitle(sItemName: string): pTStdItem; overload;
    function GetTitleIdx(sItemName: string): Integer;

    function GetStdItem(nItemIdx: Integer): pTStdItem; overload;
    function GetStdItem(sItemName: string): pTStdItem; overload;
    function GetStdItemWeight(nItemIdx: Integer; TakeBackCnt: Integer = 1): Integer;
    function GetStdItemName(nItemIdx: Integer): string;
    function GetStdItemIdx(sItemName: string): Integer;
    function FindOtherServerUser(sName: string; var nServerIndex: Integer): Boolean;
    procedure CryCry(wIdent: Word; pMap: TEnvirnoment; nX, nY, nWide: Integer; btFColor, btBColor: byte; sMsg: string; sec: Integer = 0);
    procedure ProcessUserMessage(PlayObject: TPlayObject; DefMsg: pTDefaultMessage; Buff: PChar);
    function GetMonRace(sMonName: string): Integer;

    function GetPlayObject(sName: string): TPlayObject;
    function GetPlayObjectNotGhost(sName: string): TPlayObject;
    function GetPlayObjectCS_Name(sName: string): TPlayObject;
    function GetPlayObjectCS_IDName(sName, sID: string; var boOffLine: Boolean): TPlayObject;
    procedure KickPlayer(sName: string);

    function GetHeroObject(sName: string): THeroObject;
    function GetHeroObjectCS(sName: string): THeroObject;
    function GetHeroObjectCS_IdName(sID, sName: string): THeroObject;

    function FindMerchant(Merchant: TObject): TMerchant;
    function FindNPC(GuildOfficial: TObject): TGuildOfficial;
    function CopyToUserItemFromName(sItemName: string; item: pTUserItem): Boolean;
    function GetMapOfRangeHumanCount(Envir: TEnvirnoment; nX, nY, nRange: Integer): Integer;
    function GetHumPermission(sUserName: string; var sIPaddr: string; var btPermission: byte): Boolean;
    procedure AddUserOpenInfo(UserOpenInfo: pTUserOpenInfo);
    procedure AddUserSaveInfo(UserSaveInfo: pTUserSaveInfo);
    procedure RandomUpgradeItem(item: pTUserItem);
    procedure RandomRefineItem(item: pTUserItem; var RandomAddValue: TRandomAddValue);
    function TreasureIdentify(item: pTUserItem): Integer;
    function SecretProperty(item: pTUserItem; level: byte): Integer;

    procedure GetUnknowItemValue(item: pTUserItem);
    function OpenDoor(Envir: TEnvirnoment; nX, nY: Integer): Boolean;
    function CloseDoor(Envir: TEnvirnoment; Door: pTDoorInfo): Boolean;
    procedure SendDoorStatus(Envir: TEnvirnoment; nX, nY: Integer; wIdent, wX: Word; nDoorX, nDoorY, nA: Integer; sStr: string);
    function FindMagic(sMagicName: string): pTMagic; overload;
    function FindMagic(nMagIdx: Integer; btClass: byte; boIshero: Boolean = False): pTMagic; overload;
    procedure AddMerchant(Merchant: TMerchant);
    procedure AddHero(Hero: THeroObject);
    function GetMerchantList(Envir: TEnvirnoment; nX, nY, nRange: Integer; TmpList: TList): Integer;
    function GetNpcList(Envir: TEnvirnoment; nX, nY, nRange: Integer; TmpList: TList): Integer;
    procedure ReloadMerchantList();
    procedure ReloadNpcList();
    procedure HumanExpire(sAccount: string);
    function GetMapMonster(Envir: TEnvirnoment; List: TList; const boSlave: Boolean = False): Integer;
    function GetMapRangeMonster(Envir: TEnvirnoment; nX, nY, nRange: Integer; List: TList): Integer;
    function GetMapHuman(sMapName: string): Integer;
    function IsSameGuildOnMap(sMapName: string): Boolean;
    function GetMapHumanCount(MapEnvir: TEnvirnoment): Integer;
    function GetMapRageHuman(Envir: TEnvirnoment; nRageX, nRageY, nRage: Integer; List: TList): Integer;
    procedure SendBroadCastMsg(sMsg: string; MsgType: TMsgType; MsgColor: TMsgColor = c_Red; fc: Integer = -1; bc: Integer = -1; sec: Integer = 0);
    procedure SendScrollMsg(sMsg: string; MsgType: TMsgType; MsgColor: TMsgColor = c_Red; fc: Integer = -1; bc: Integer = -1; sec: Integer = 0);

    procedure SendBroadCastMsgExt(sMsg: string; MsgType: TMsgType);
    procedure SendBroadCastMsgExt2(sMsg: string; MsgType: TMsgType);
    //procedure AddGoldChangeInfo(GoldChangeInfo: pTGoldChangeInfo);
    procedure ClearMonSayMsg();
    procedure SendQuestMsg(sQuestName: string);
    procedure DemoRun(); dynamic;
    procedure ClearMerchantData();
    property MonsterCount: Integer read nMonsterCount;
    property OnlinePlayObject: Integer read GetOnlineHumCount;
    //property OnlineHeroObject: Integer read GetOnlineHeroCount;
    //property TotalHeroObject: Integer read GetTotalHeroCount;
    property PlayObjectCount: Integer read GetUserCount;
    property LoadPlayCount: Integer read GetLoadPlayCount;
    property OfflinePlayCount: Integer read GetOfflinePlayCount;
    property OfflinePlayCountCS: Integer read GetOfflinePlayCountCS;
    function MakeNewHuman(UserOpenInfo: pTUserOpenInfo {; getHeros: Boolean = False}): TPlayObject;
    //function MakeNewHero(Master: TPlayObject): TBaseObject;
    procedure SaveHumanRcd(PlayObject: TPlayObject; sHeroName: string = ''; sJob: string = ''; sSex: string = ''; HeroEx: Boolean = False);

    function AddSwitchData(psui: pTSwitchDataInfo): Boolean;
    function GetSwitchData(sChrName: string; nCode: Integer): pTSwitchDataInfo;
    function WriteSwitchData(psui: pTSwitchDataInfo): string;
    function SendSwitchData(PlayObject: TPlayObject; nServerIndex: Integer): Boolean;
    procedure SendChangeServer(PlayObject: TPlayObject; nServerIndex: Integer);
    procedure DelSwitchData(SwitchData: pTSwitchDataInfo);
    procedure MakeSwitchData(var SwitchData: TSwitchDataInfo; PlayObject: TPlayObject);
    procedure LoadSwitchData(SwitchData: pTSwitchDataInfo; PlayObject: TPlayObject);
    procedure CheckSwitchServerTimeOut;

    procedure GuildMemberReGetRankName(Guild: TGuild);
    procedure GetISMChangeServerReceive(flName: string);
    procedure OtherServerUserLogon(sNum: Integer; uname: string);
    procedure OtherServerUserLogout(sNum: Integer; uname: string);
    procedure SendInterMsg(Ident, svidx: Integer; msgstr: string);

    function LoadMonSpAbil(): Boolean;
  end;

function GetZenTime(dwTime: LongWord): LongWord;

var
  g_dwEngineTick: LongWord;
  g_dwEngineRunTime: LongWord;

implementation

uses IdSrvClient, ObjMon, M2Share, EDcode, ObjGuard, ObjAxeMon, StartPointManage,
  ObjMon2, ObjMon3, ObjMon5, Event, InterMsgClient, InterServerMsg, ObjRobot, HUtil32, svMain, Castle
{$IF USEWLSDK = 1}, WinlicenseSDK{$ELSEIF USEWLSDK = 2}, SELicenseSDK, SESDK{$IFEND};

var
  nEngRemoteRun: Integer = -1;



constructor TUserEngine.Create();
begin
  InitializeCriticalSection(m_LoadPlaySection);
  InitializeCriticalSection(m_SavePlaySection);
  m_OtherUserNameList := TStringList.Create;
  m_LoadPlayList := TStringList.Create;
  m_SavePlayList := TList.Create;
  m_PlayObjectList := TStringList.Create;
  m_PlayObjectFreeList := TList.Create;
  dwShowOnlineTick := GetTickCount;
  dwSendOnlineHumTime := GetTickCount;
  dwProcessMapDoorTick := GetTickCount;
  dwProcessEffectsTick := GetTickCount;
  dwProcessMissionsTime := GetTickCount;
  dwProcessMonstersTick := GetTickCount;
  dwRegenMonstersTick := GetTickCount;
  m_dwProcessLoadPlayTick := GetTickCount;
  m_dwProcessSavePlayTick := GetTickCount;
  m_nCurrMonGen := 0;
  m_nMonGenListPosition := 0;
  m_nMonGenCertListPosition := 0;
  m_nProcHumIDx := 0;
  nProcessHumanLoopTime := 0;
  nMerchantPosition := 0;
  m_nHeroPosition := 0;
  m_nEscortPosition := 0;
  nNpcPosition := 0;
  StdItemList := TList.Create;
  TitleList := TList.Create;
  MonsterList := {$IF USEHASHLIST = 1}TCnHashTableSmall.Create{$ELSE}TList.Create{$IFEND};
  MonSpAbilList := TCnHashTableSmall.Create;
  m_MonGenList := TList.Create;
  // m_MonFreeList := TList.Create;
  m_MagicList := TList.Create;
  m_AdminList := TGList.Create;
  m_MerchantList := TGList.Create;
  m_HeroProcList := TList.Create;
  m_EscortProcList := TList.Create;
  QuestNPCList := TList.Create;
  m_ChangeServerList := TList.Create;
  m_MagicEventList := TList.Create;
  m_MagicEventCloseList := TList.Create;
  dwProcessMerchantTimeMin := 0;
  dwProcessMerchantTimeMax := 0;
  dwProcessHeroTimeMin := 0;
  dwProcessHeroTimeMax := 0;
  dwProcessNpcTimeMin := 0;
  dwProcessNpcTimeMax := 0;
  m_NewHumanList := TList.Create;
  m_ListOfGateIdx := TList.Create;
  m_ListOfSocket := TList.Create;
  m_MagicListPre := TList.Create;
  m_MapEffectList := TList.Create;
end;

destructor TUserEngine.Destroy;
var
  i: Integer;
  ii: Integer;
  MonInfo: pTMonInfo;
  MonGenInfo: pTMonGenInfo;
  MagicEvent: pTMagicEvent;
  TmpList: TList;
  Mon: TEscortMon;
begin
  for i := 0 to m_LoadPlayList.Count - 1 do
    Dispose(pTUserOpenInfo(m_LoadPlayList.Objects[i]));
  m_LoadPlayList.Free;

  for i := 0 to m_SavePlayList.Count - 1 do
    Dispose(pTUserSaveInfo(m_SavePlayList[i]));
  m_SavePlayList.Free;

  for i := 0 to m_PlayObjectList.Count - 1 do
    TPlayObject(m_PlayObjectList.Objects[i]).Free;
  m_PlayObjectList.Free;

  for i := 0 to m_PlayObjectFreeList.Count - 1 do
    TPlayObject(m_PlayObjectFreeList.Items[i]).Free;
  m_PlayObjectFreeList.Free;

  for i := 0 to StdItemList.Count - 1 do
    Dispose(pTStdItem(StdItemList.Items[i]));
  StdItemList.Free;
  
  TitleList.Clear;
  TitleList.Free;

  for i := 0 to MonsterList.Count - 1 do
  begin
{$IF USEHASHLIST = 1}
    MonInfo := pTMonInfo(MonsterList.GetValues(MonsterList.Keys[i]));
{$ELSE}
    MonInfo := pTMonInfo(MonsterList[i]);
{$IFEND}
    if MonInfo.ItemList <> nil then
    begin
      for ii := 0 to MonInfo.ItemList.Count - 1 do
        Dispose(pTMonItemInfo(MonInfo.ItemList.Items[ii]));
      MonInfo.ItemList.Free;
    end;
    Dispose(MonInfo);
  end;
  MonsterList.Free;

  for i := 0 to MonSpAbilList.Count - 1 do
  begin
    Dispose(pTMonSpAbil(MonSpAbilList.GetValues(MonSpAbilList.Keys[i])));
  end;
  MonSpAbilList.Free;

  for i := 0 to m_MonGenList.Count - 1 do
  begin
    MonGenInfo := m_MonGenList.Items[i];
    for ii := 0 to MonGenInfo.CertList.Count - 1 do
      TBaseObject(MonGenInfo.CertList.Items[ii]).Free;
    MonGenInfo.CertList.Free;
    Dispose(MonGenInfo);
  end;
  m_MonGenList.Free;

  {for i := 0 to m_MonFreeList.Count - 1 do
    TBaseObject(m_MonFreeList.Items[i]).Free;
  m_MonFreeList.Free;}

  for i := 0 to m_MagicList.Count - 1 do
    Dispose(pTMagic(m_MagicList.Items[i]));
  m_MagicList.Free;

  for i := 0 to m_AdminList.Count - 1 do
    Dispose(pTAdminInfo(m_AdminList.Items[i]));
  m_AdminList.Free;

  for i := 0 to m_MerchantList.Count - 1 do
    TMerchant(m_MerchantList.Items[i]).Free;
  m_MerchantList.Free;

  for i := 0 to m_HeroProcList.Count - 1 do
    THeroObject(m_HeroProcList.Items[i]).Free;
  m_HeroProcList.Free;

  for i := 0 to m_EscortProcList.Count - 1 do
  begin
    Mon := TEscortMon(m_EscortProcList[i]);
    Mon.Free;
  end;
  m_EscortProcList.Free;

  for i := 0 to QuestNPCList.Count - 1 do
    TNormNpc(QuestNPCList.Items[i]).Free;
  QuestNPCList.Free;

  for i := 0 to m_ChangeServerList.Count - 1 do
    Dispose(pTSwitchDataInfo(m_ChangeServerList.Items[i]));
  m_ChangeServerList.Free;

  for i := 0 to m_MagicEventList.Count - 1 do
  begin
    MagicEvent := m_MagicEventList.Items[i];
    if MagicEvent.BaseObjectList <> nil then
      MagicEvent.BaseObjectList.Free;
    Dispose(MagicEvent);
  end;
  m_MagicEventList.Free;

  for i := 0 to m_MagicEventCloseList.Count - 1 do
    TEvent(m_MagicEventCloseList[i]).Free;
  m_MagicEventCloseList.Free;

  m_NewHumanList.Free;
  m_ListOfGateIdx.Free;
  m_ListOfSocket.Free;

  for i := 0 to m_MagicListPre.Count - 1 do
  begin
    TmpList := TList(m_MagicListPre.Items[i]);
    for ii := 0 to TmpList.Count - 1 do
      Dispose(pTMagic(TmpList.Items[ii]));
    TmpList.Free;
  end;
  m_MagicListPre.Free;
  
  m_MapEffectList.Free;
  m_OtherUserNameList.Free;
  DeleteCriticalSection(m_LoadPlaySection);
  DeleteCriticalSection(m_SavePlaySection);
  inherited;
end;

procedure TUserEngine.Initialize;
var
  i: Integer;
  MonGen: pTMonGenInfo;
begin
  MerchantInitialize();
  NPCinitialize();
  for i := 0 to m_MonGenList.Count - 1 do
  begin
    MonGen := m_MonGenList.Items[i];
    if MonGen <> nil then
      MonGen.nRace := GetMonRace(MonGen.sMonName);
  end;
end;

function TUserEngine.GetMonRace(sMonName: string): Integer;
var
  MonInfo: pTMonInfo;
begin
  Result := -1;
{$IF USEHASHLIST = 1}
  MonInfo := pTMonInfo(MonsterList.GetValues(sMonName));
  if MonInfo <> nil then
    Result := MonInfo.btRace;
{$ELSE}
  for i := 0 to MonsterList.Count - 1 do
  begin
    MonInfo := MonsterList.Items[i];
    if CompareText(MonInfo.sName, sMonName) = 0 then
    begin
      Result := MonInfo.btRace;
      Break;
    end;
  end;
{$IFEND}
end;

procedure TUserEngine.MerchantInitialize;
var
  i: Integer;
  Merchant: TMerchant;
  sCaption: string;
begin
  sCaption := FrmMain.Caption;
  m_MerchantList.Lock;
  try
    for i := m_MerchantList.Count - 1 downto 0 do
    begin
      Merchant := TMerchant(m_MerchantList.Items[i]);
      Merchant.m_PEnvir := g_MapManager.FindMap(Merchant.m_sMapName);
      if Merchant.m_PEnvir <> nil then
      begin
        Merchant.OnEnvirnomentChanged();
        Merchant.Initialize;
        if Merchant.m_boErrorOnInit and (not Merchant.m_boIsHide) then
        begin
          MainOutMessageAPI('交易NPC初始化失败...' + Merchant.m_sCharName + ' ' + Merchant.m_sMapName + '(' + IntToStr(Merchant.m_nCurrX) + ':' + IntToStr(Merchant.m_nCurrY) + ')');
          m_MerchantList.Delete(i);
          Merchant.Free;
        end
        else
        begin
          Merchant.LoadNpcScript();
          Merchant.LoadNPCData();
        end;
      end
      else
      begin
        MainOutMessageAPI(Merchant.m_sCharName + ' 交易NPC初始化失败(m.PEnvir=nil)');
        m_MerchantList.Delete(i);
        Merchant.Free;
      end;
      FrmMain.Caption := sCaption + Format('[正在初始交易NPC(%d/%d)]', [m_MerchantList.Count, m_MerchantList.Count - i]);
    end;
  finally
    m_MerchantList.UnLock;
  end;
  if m_MerchantList.Count > 0 then
    MainOutMessageAPI(Format('初始化 %d个交易NPC...', [m_MerchantList.Count]));
  FrmMain.Caption := sCaption;
end;

procedure TUserEngine.NPCinitialize;
var
  i: Integer;
  NormNpc: TNormNpc;
  sCaption: string;
begin
  sCaption := FrmMain.Caption;
  for i := QuestNPCList.Count - 1 downto 0 do
  begin
    NormNpc := TNormNpc(QuestNPCList.Items[i]);
    NormNpc.m_PEnvir := g_MapManager.FindMap(NormNpc.m_sMapName);
    if NormNpc.m_PEnvir <> nil then
    begin
      NormNpc.OnEnvirnomentChanged();
      NormNpc.Initialize;
      if NormNpc.m_boErrorOnInit and (not NormNpc.m_boIsHide) then
      begin
        MainOutMessageAPI(NormNpc.m_sCharName + ' 管理NPC初始化失败... ');
        QuestNPCList.Delete(i);
        NormNpc.Free;
      end
      else
        NormNpc.LoadNpcScript();
    end
    else
    begin
      MainOutMessageAPI(NormNpc.m_sCharName + ' 管理NPC初始化失败... (npc.PEnvir=nil)');
      QuestNPCList.Delete(i);
      NormNpc.Free;
    end;
    FrmMain.Caption := sCaption + Format('[正在初始管理NPC(%d/%d)]', [QuestNPCList.Count, QuestNPCList.Count - i]);
  end;
  if QuestNPCList.Count > 0 then
    MainOutMessageAPI(Format('初始化 %d个管理NPC...', [QuestNPCList.Count]));
end;

function TUserEngine.GetOfflinePlayCount(): Integer;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := 0;
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if PlayObject.m_boOffLineFlag then
      Inc(Result);
  end;
end;

function TUserEngine.GetOfflinePlayCountCS(): Integer;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := 0;
  EnterCriticalSection(ProcessHumanCriticalSection); //0618
  try
    for i := 0 to m_PlayObjectList.Count - 1 do
    begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
      if PlayObject.m_boOffLineFlag then
        Inc(Result);
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TUserEngine.GetLoadPlayCount: Integer;
begin
  Result := m_LoadPlayList.Count;
end;

function TUserEngine.GetOnlineHumCount: Integer;
begin
  Result := m_PlayObjectList.Count;
end;

function TUserEngine.GetUserCount: Integer;
begin
  Result := m_PlayObjectList.Count;
end;

{function TUserEngine.GetOnlineHeroCount: Integer;
var
  i                         : Integer;
begin
  Result := 0;
  m_HeroProcList.Lock;
  try
    Result := m_HeroProcList.Count;
    for i := 0 to m_HeroProcList.Count - 1 do
      if THeroObject(m_HeroProcList.Items[i]).m_boGhost then
        Dec(Result);
  finally
    m_HeroProcList.UnLock;
  end;
end;

function TUserEngine.GetTotalHeroCount(): Integer;
begin
  m_HeroProcList.Lock;
  try
    Result := m_HeroProcList.Count;
  finally
    m_HeroProcList.UnLock;
  end;
end;}

function TUserEngine.MakeNewHuman(UserOpenInfo: pTUserOpenInfo {; getHeros: Boolean}): TPlayObject;
var
  PlayObject: TPlayObject;
  Abil: pTAbility;
  Envir: TEnvirnoment;
  nC, nCheckCode: Integer;
  SwitchDataInfo: pTSwitchDataInfo;
  Castle: TUserCastle;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::MakeNewHuman Code:%d';
  sChangeServerFail1 = 'chg-server-fail-1 [%d] -> [%d] [%s]';
  sChangeServerFail2 = 'chg-server-fail-2 [%d] -> [%d] [%s]';
  sChangeServerFail3 = 'chg-server-fail-3 [%d] -> [%d] [%s]';
  sChangeServerFail4 = 'chg-server-fail-4 [%d] -> [%d] [%s]';
  sErrorEnvirIsNil = '[Error] PlayObject.PEnvir = nil';
label
  ReGetMap;
begin
  Result := nil;
  nCheckCode := 0;
  try
    nCheckCode := 1;
    PlayObject := TPlayObject.Create;
    if not g_Config.boVentureServer then
    begin
      nCheckCode := 2;
      SwitchDataInfo := GetSwitchData(UserOpenInfo.LoadUser.sCharName, UserOpenInfo.LoadUser.nSessionID);
    end
    else
      SwitchDataInfo := nil;
    if SwitchDataInfo = nil then
    begin
      nCheckCode := 3;
      GetHumData(PlayObject, UserOpenInfo.HumanRcd);
      PlayObject.m_btRaceServer := RC_PLAYOBJECT;

      {if getHeros then begin
        //New(PlayObject.m_Heros);
        boGetHeros := False;
        for i := Low(UserOpenInfo.HerosInfo) to High(UserOpenInfo.HerosInfo) do begin
          if UserOpenInfo.HerosInfo[i].ChrName <> '' then begin
            boGetHeros := True;
            Break;
          end;
        end;
        if boGetHeros then begin
          PlayObject.m_boGetHeros := True;
          PlayObject.m_Heros := UserOpenInfo.HerosInfo;
        end;
      end;}

      nCheckCode := 4;
      if PlayObject.m_sHomeMap = '' then
      begin
        ReGetMap:
        PlayObject.m_sHomeMap := GetHomeInfo(PlayObject.m_nHomeX, PlayObject.m_nHomeY);
        PlayObject.m_sMapName := PlayObject.m_sHomeMap;
        PlayObject.m_nCurrX := GetRandHomeX(PlayObject);
        PlayObject.m_nCurrY := GetRandHomeY(PlayObject);
        nCheckCode := 5;
        if PlayObject.m_Abil.level = 0 then
        begin
          Abil := @PlayObject.m_Abil;
          Abil.level := 1;
          Abil.AC := 0;
          Abil.MAC := 0;
          Abil.DC := MakeLong(1, 4);
          Abil.MC := MakeLong(1, 2);
          Abil.SC := MakeLong(1, 2);
          Abil.MP := 15;
          Abil.HP := 15;
          Abil.MaxHP := 15;
          Abil.MaxMP := 15;
          Abil.Exp := 0;
          Abil.MaxExp := 100;
          Abil.Weight := 0;
          Abil.MaxWeight := 30;
          PlayObject.m_boNewHuman := True;
        end;
      end;
      nCheckCode := 51;
      Envir := g_MapManager.GetMapInfo(g_nServerIndex, PlayObject.m_sMapName);
      nCheckCode := 6;
      if (Envir <> nil) and Envir.m_MapFlag.boFIGHT3Zone then
      begin
        if (PlayObject.m_Abil.HP = 0) and (PlayObject.m_nFightZoneDieCount < 3) then
        begin
          PlayObject.m_Abil.HP := PlayObject.m_Abil.MaxHP;
          PlayObject.m_Abil.MP := PlayObject.m_Abil.MaxMP;
          PlayObject.m_boDieInFight3Zone := True;
        end
        else
          PlayObject.m_nFightZoneDieCount := 0;
      end;
      nCheckCode := 7;
      PlayObject.m_MyGuild := g_GuildManager.MemberOfGuild(PlayObject.m_sCharName);
      nCheckCode := 8;
      Castle := g_CastleManager.InCastleWarArea(Envir, PlayObject.m_nCurrX, PlayObject.m_nCurrY, PlayObject.m_nCastleEnvirListIdx);
      if (Envir <> nil) and (Castle <> nil) and ((Castle.m_MapPalace = Envir) or Castle.m_boUnderWar) then
      begin
        if g_CastleManager.IsCastleMember(PlayObject) = nil then
        begin
          if Castle.m_MapPalace = Envir then
          begin
            PlayObject.m_sMapName := PlayObject.m_sHomeMap;
            PlayObject.m_nCurrX := PlayObject.m_nHomeX - 2 + Random(5);
            PlayObject.m_nCurrY := PlayObject.m_nHomeY - 2 + Random(5);
          end;
        end
        else
        begin
          if Castle.m_MapPalace = Envir then
          begin
            PlayObject.m_sMapName := Castle.GetMapName();
            PlayObject.m_nCurrX := Castle.GetHomeX;
            PlayObject.m_nCurrY := Castle.GetHomeY;
          end;
        end;
      end;
      nCheckCode := 9;
      if (PlayObject.m_btNewHuman <= 1) and (PlayObject.m_Abil.level >= 1) then
        PlayObject.m_btNewHuman := 2;
      if g_MapManager.FindMap(PlayObject.m_sMapName) = nil then
        PlayObject.m_Abil.HP := 0;
      nCheckCode := 10;
      if PlayObject.m_Abil.HP = 0 then
      begin
        PlayObject.ClearStatusTime();
        if PlayObject.PKLevel < 2 then
        begin
          Castle := g_CastleManager.IsCastleMember(PlayObject);
          if (Castle <> nil) and Castle.m_boUnderWar then
          begin
            PlayObject.m_sMapName := Castle.m_sHomeMap;
            PlayObject.m_nCurrX := Castle.GetHomeX;
            PlayObject.m_nCurrY := Castle.GetHomeY;
          end
          else
          begin
            PlayObject.m_sMapName := PlayObject.m_sHomeMap;
            PlayObject.m_nCurrX := PlayObject.m_nHomeX - 2 + Random(5);
            PlayObject.m_nCurrY := PlayObject.m_nHomeY - 2 + Random(5);
          end;
        end
        else
        begin
          PlayObject.m_sMapName := g_Config.sRedDieHomeMap;
          PlayObject.m_nCurrX := Random(13) + g_Config.nRedDieHomeX;
          PlayObject.m_nCurrY := Random(13) + g_Config.nRedDieHomeY;
        end;
        PlayObject.m_Abil.HP := 14;
      end;
      nCheckCode := 11;
      PlayObject.AbilCopyToWAbil();
      nCheckCode := 12;
      Envir := g_MapManager.GetMapInfo(g_nServerIndex, PlayObject.m_sMapName);
      if Envir = nil then
      begin
        nCheckCode := 13;
        SaveHumanRcd(PlayObject);
        PlayObject.m_nSessionID := UserOpenInfo.LoadUser.nSessionID;
        PlayObject.m_nSocket := UserOpenInfo.LoadUser.nSocket;
        PlayObject.m_nGateIdx := UserOpenInfo.LoadUser.nGateIdx;
        PlayObject.m_nGSocketIdx := UserOpenInfo.LoadUser.nGSocketIdx;
        PlayObject.m_WAbil := PlayObject.m_Abil;
        PlayObject.m_nServerIndex := g_MapManager.GetMapOfServerIndex(PlayObject.m_sMapName);
        if PlayObject.m_Abil.HP <> 14 then
          MainOutMessageAPI(Format(sChangeServerFail1, [g_nServerIndex, PlayObject.m_nServerIndex, PlayObject.m_sMapName]));
        SendSwitchData(PlayObject, PlayObject.m_nServerIndex);
        SendChangeServer(PlayObject, PlayObject.m_nServerIndex);
        PlayObject.Free;
        Exit;
      end;
      nCheckCode := 14;
      nC := 0;
      while (True) do
      begin
        if Envir.CanWalk(PlayObject.m_nCurrX, PlayObject.m_nCurrY, True) then
          Break;
        PlayObject.m_nCurrX := PlayObject.m_nCurrX - 3 + Random(6);
        PlayObject.m_nCurrY := PlayObject.m_nCurrY - 3 + Random(6);
        Inc(nC);
        if nC >= 5 then
          Break;
      end;
      nCheckCode := 15;
      if not Envir.CanWalk(PlayObject.m_nCurrX, PlayObject.m_nCurrY, True) then
      begin
        PlayObject.m_sMapName := g_Config.sHomeMap;
        Envir := g_MapManager.FindMap(g_Config.sHomeMap);
        PlayObject.m_nCurrX := g_Config.nHomeX;
        PlayObject.m_nCurrY := g_Config.nHomeY;
      end;
      nCheckCode := 16;
      PlayObject.m_PEnvir := Envir;
      PlayObject.OnEnvirnomentChanged();
      if PlayObject.m_PEnvir = nil then
      begin
        MainOutMessageAPI(sErrorEnvirIsNil);
        goto ReGetMap;
      end
      else
        PlayObject.m_boReadyRun := False;
    end
    else
    begin
      nCheckCode := 21;
      GetHumData(PlayObject, UserOpenInfo.HumanRcd);
      PlayObject.m_btRaceServer := RC_PLAYOBJECT;
      //PlayObject.m_sMapName := SwitchDataInfo.sMAP;
      //PlayObject.m_nCurrX := SwitchDataInfo.wX;
      //PlayObject.m_nCurrY := SwitchDataInfo.wY;
      nCheckCode := 22;
      PlayObject.m_Abil := SwitchDataInfo.Abil;
      PlayObject.AbilCopyToWAbil();
      nCheckCode := 23;
      LoadSwitchData(SwitchDataInfo, PlayObject);
      nCheckCode := 24;
      DelSwitchData(SwitchDataInfo);
      nCheckCode := 25;
      Envir := g_MapManager.GetMapInfo(g_nServerIndex, PlayObject.m_sMapName);
      nCheckCode := 26;
      if Envir = nil then
      begin
        MainOutMessageAPI(Format(sChangeServerFail3, [g_nServerIndex, PlayObject.m_nServerIndex, PlayObject.m_sMapName]));
        PlayObject.m_sMapName := g_Config.sHomeMap;
        // Envir := g_MapManager.FindMap(g_Config.sHomeMap);
        PlayObject.m_nCurrX := g_Config.nHomeX;
        PlayObject.m_nCurrY := g_Config.nHomeY;
      end
      else
      begin
        nCheckCode := 27;
        nC := 0;
        while (True) do
        begin
          if Envir.CanWalk(PlayObject.m_nCurrX, PlayObject.m_nCurrY, True) then
            Break;
          PlayObject.m_nCurrX := PlayObject.m_nCurrX - 3 + Random(6);
          PlayObject.m_nCurrY := PlayObject.m_nCurrY - 3 + Random(6);
          Inc(nC);
          if nC >= 5 then
            Break;
        end;
        nCheckCode := 28;
        if not Envir.CanWalk(PlayObject.m_nCurrX, PlayObject.m_nCurrY, True) then
        begin
          MainOutMessageAPI(Format(sChangeServerFail4, [g_nServerIndex, PlayObject.m_nServerIndex, PlayObject.m_sMapName]));
          PlayObject.m_sMapName := g_Config.sHomeMap;
          Envir := g_MapManager.FindMap(g_Config.sHomeMap);
          PlayObject.m_nCurrX := g_Config.nHomeX;
          PlayObject.m_nCurrY := g_Config.nHomeY;
        end;
        nCheckCode := 29;
        PlayObject.m_PEnvir := Envir;
        PlayObject.OnEnvirnomentChanged();
        nCheckCode := 30;
      end;
      if PlayObject.m_PEnvir = nil then
      begin
        MainOutMessageAPI(sErrorEnvirIsNil);
        goto ReGetMap;
      end
      else
      begin
        PlayObject.m_boReadyRun := False;
        PlayObject.m_boSendNotice := True;
        PlayObject.m_boSendImageFileCustom := True;
        PlayObject.m_boSendSafeZoneEffectCustom := True;
        PlayObject.m_boSendNpcCustom := True;
        PlayObject.m_boLoginNoticeOK := True;
      end;
    end;
    nCheckCode := 17;
    PlayObject.m_sUserID := UserOpenInfo.LoadUser.sAccount;
    if UserOpenInfo.LoadUser.sIPaddr = g_sAutoLogin then
      PlayObject.m_sIPaddr := '127.0.0.1'
    else
      PlayObject.m_sIPaddr := UserOpenInfo.LoadUser.sIPaddr;
    nCheckCode := 18;
{$IF EXPIPLOCAL=1}
    PlayObject.m_sIPLocal := GetIPLocal(PlayObject.m_sIPaddr);
{$ELSE}
    PlayObject.m_sIPLocal := PlayObject.m_sIPaddr;
{$IFEND}
    nCheckCode := 19;
    PlayObject.m_nSocket := UserOpenInfo.LoadUser.nSocket;
    PlayObject.m_nGSocketIdx := UserOpenInfo.LoadUser.nGSocketIdx;
    PlayObject.m_nGateIdx := UserOpenInfo.LoadUser.nGateIdx;
    PlayObject.m_nSessionID := UserOpenInfo.LoadUser.nSessionID;
    PlayObject.m_nPayMent := UserOpenInfo.LoadUser.nPayMent;
    PlayObject.m_nPayMode := UserOpenInfo.LoadUser.nPayMode;
    PlayObject.m_dwLoadTick := UserOpenInfo.LoadUser.dwNewUserTick;
    PlayObject.m_nSoftVersionDate := UserOpenInfo.LoadUser.nSoftVersionDate;
{$IF VER_ClientType_45}
    PlayObject.m_nSoftVersionDateEx := GetExVersionNO(UserOpenInfo.LoadUser.nSoftVersionDate, PlayObject.m_nSoftVersionDate);
{$IFEND VER_ClientType_45}

    PlayObject.m_xHWID := UserOpenInfo.LoadUser.xHWID;

    Result := PlayObject;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [nCheckCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

procedure TUserEngine.ProcessHumans;

  function IsLogined(sChrName: string; tOpen: TUserOpenType): Boolean;
  var
    i: Integer;
    PlayObject: TPlayObject;
    HeroObject: THeroObject;
  begin
    //tHumDat  tHeroDat tResume tLvRank tLoadFail
    Result := False;
    if tOpen in [tHumDat, tHeroDat, tResume, tHumDat2] then
    begin
      for i := 0 to m_PlayObjectList.Count - 1 do
      begin
{$IF V_TEST = 1}
{$I '..\Common\Macros\VMPB.inc'}
        if i > 10 then
          Break;
        PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
        if (PlayObject <> nil) and (CompareText(PlayObject.m_sCharName, sChrName) = 0) then
        begin
          if tOpen = tResume then
          begin //挂机后继续登陆
            if not PlayObject.m_boOffLineFlag then
              Result := True;
          end
          else if tOpen in [tHumDat, tHeroDat] then //正常登陆
            Result := True;
          Exit;
        end;
{$I '..\Common\Macros\VMPE.inc'}
{$ELSE}
        PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
        if (PlayObject <> nil) and (CompareText(PlayObject.m_sCharName, sChrName) = 0) then
        begin
          if tOpen = tResume then
          begin //挂机后继续登陆
            if not PlayObject.m_boOffLineFlag then
              Result := True;
          end
          else if tOpen in [tHumDat, tHeroDat] then //正常登陆
            Result := True;
          Exit;
        end;
{$IFEND V_TEST}
      end;

      //m_HeroProcList.Lock;
      //try
      for i := 0 to m_HeroProcList.Count - 1 do
      begin
        HeroObject := m_HeroProcList[i];
        if (HeroObject <> nil) and not HeroObject.m_boGhost and (CompareText(HeroObject.m_sCharName, sChrName) = 0) then
        begin
          Result := True;
          Exit;
        end;
      end;
      //finally
      //  m_HeroProcList.UnLock;
      //end;

      if FrontEngine.InSaveRcdList(sChrName) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

var
  i, nIdx, nCHECK: Integer;
  dwUsrRotTime: LongWord;
  dwCheckTime: LongWord;
  dwCurTick: LongWord;
  boCheckTimeLimit: Boolean;
  PlayObject: TPlayObject;
  UserOpenInfo: pTUserOpenInfo;
  UserSaveInfo: pTUserSaveInfo;
  sUser, LineNoticeMsg: string;
resourcestring
  sExceptionMsg1 = '[Exception] TUserEngine::ProcessHumans -> Ready, Save, Load... Code:=%d';
  sExceptionMsg2 = '[Exception] TUserEngine::ProcessHumans ClosePlayer.Delete - Free';
  sExceptionMsg3 = '[Exception] TUserEngine::ProcessHumans ClosePlayer.Delete';
  sExceptionMsg4 = '[Exception] TUserEngine::ProcessHumans RunNotice';
  sExceptionMsg5 = '[Exception] TUserEngine::ProcessHumans Human.Operate Code: %d';
  sExceptionMsg6 = '[Exception] TUserEngine::ProcessHumans Human.Finalize Code: %d';
  sExceptionMsg7 = '[Exception] TUserEngine::ProcessHumans RunSocket.CloseUser Code: %d';
  sExceptionMsg8 = '[Exception] TUserEngine::ProcessHumans';
begin
  nCHECK := 0;

  {if m_PlayObjectList.Count = 0 then
    v_cTick := GetTickCount;
  if (m_PlayObjectList.Count >= 1500) and (v_cTick <> 0) then begin
    MainOutMessageAPI(IntToStr(GetTickCount - v_cTick));
    v_cTick := 0;
  end;}

  dwCheckTime := GetTickCount();
  if (GetTickCount - m_dwProcessLoadPlayTick) > 200 then
  begin
    m_dwProcessLoadPlayTick := GetTickCount();
    try
      EnterCriticalSection(m_LoadPlaySection);
      try
        nCHECK := 1;
        for i := 0 to m_LoadPlayList.Count - 1 do
        begin
          sUser := m_LoadPlayList.Strings[i];
          UserOpenInfo := pTUserOpenInfo(m_LoadPlayList.Objects[i]);
          if not FrontEngine.IsFull and not IsLogined(sUser, UserOpenInfo.LoadType) then
          begin
            case UserOpenInfo.LoadType of
              tHumDat2:
                begin
                  nCHECK := 2;
                  PlayObject := MakeNewHuman(UserOpenInfo);
                  nCHECK := 3;
                  if PlayObject <> nil then
                  begin
                    nCHECK := 4;
                    PlayObject.m_boSendNotice := True;
                    PlayObject.m_boSendImageFileCustom := True;
                    PlayObject.m_boSendSafeZoneEffectCustom := True;
                    PlayObject.m_boSendNpcCustom := True;
                    PlayObject.m_boLoginNoticeOK := True;
                    PlayObject.m_dwRunTick := 0;
                    PlayObject.m_dwSearchTick := 0;
                    PlayObject.m_boReadyRun := False;
                    PlayObject.m_boOffLineFlag := True;
                    //PlayObject.m_boSearch := True;
                    PlayObject.m_nSessionID := UserOpenInfo.LoadUser.nSessionID;
                    PlayObject.m_nSocket := UserOpenInfo.LoadUser.nSocket;
                    PlayObject.m_nGateIdx := UserOpenInfo.LoadUser.nGateIdx;
                    PlayObject.m_nGSocketIdx := UserOpenInfo.LoadUser.nGSocketIdx;

                    PlayObject.MoveToHomeRandom;
{$IF VER_ClientType_45}
                    PlayObject.m_wClientType := 46;
{$IFEND VER_ClientType_45}
                    m_PlayObjectList.AddObject(sUser, PlayObject);
                    SendInterMsg(ISM_USERLOGON, g_nServerIndex, PlayObject.m_sCharName);
                  end;
                end;
              tHumDat:
                begin
                  PlayObject := MakeNewHuman(UserOpenInfo);
                  if PlayObject <> nil then
                  begin
{$IF V_TEST = 1}
{$I '..\Common\Macros\VMPB.inc'}
                    if m_PlayObjectList.Count <= 10 then
                    begin
                      m_PlayObjectList.AddObject(sUser, PlayObject);
                      SendInterMsg(ISM_USERLOGON, g_nServerIndex, PlayObject.m_sCharName);
                      m_NewHumanList.Add(PlayObject);
                    end;
{$I '..\Common\Macros\VMPE.inc'}
{$ELSE}
                    m_PlayObjectList.AddObject(sUser, PlayObject);
                    SendInterMsg(ISM_USERLOGON, g_nServerIndex, PlayObject.m_sCharName);
                    m_NewHumanList.Add(PlayObject);
{$IFEND V_TEST}

                  end;
                end;
              tHeroDat:
                begin
                  PlayObject := GetPlayObjectNotGhost(UserOpenInfo.LoadUser.sMasterName);
                  if PlayObject <> nil then
                  begin
                    if PlayObject.m_HeroRcd = nil then
                      New(PlayObject.m_HeroRcd);
                    PlayObject.m_HeroRcd^ := UserOpenInfo.HumanRcd;
                    PlayObject.m_boLoadHeroRcd := True;
                  end;
                end;
              tLvRank:
                begin
                  PlayObject := GetPlayObjectNotGhost(UserOpenInfo.LoadUser.sCharName);
                  if PlayObject <> nil then
                  begin
                    PlayObject.m_boQueryRankOK := True;
                    PlayObject.m_nLvRankType := UserOpenInfo.LoadUser.nLRType;
                    PlayObject.m_nLvRankResult := UserOpenInfo.LoadUser.nLRResult;
                    PlayObject.m_sSendRankData := UserOpenInfo.RankData;
                  end;
                end;
              tSendMyHeros:
                begin
                  PlayObject := GetPlayObjectNotGhost(UserOpenInfo.LoadUser.sCharName);
                  if PlayObject <> nil then
                  begin
                    PlayObject.m_boGetHeros := True;
                    Move(UserOpenInfo.HumanRcd, PlayObject.m_Heros, SizeOf(THerosInfo));
                    //PlayObject.m_Heros := UserOpenInfo.HerosInfo;
                    PlayObject.m_boSendHeros := True;
                    //PlayObject.SendMsg(PlayObject, RM_SENDHEROS, 0, 0, 0, 0, '');
                  end;
                end;
              tResume:
                begin
                  PlayObject := GetPlayObjectNotGhost(UserOpenInfo.LoadUser.sCharName);
                  if PlayObject <> nil then
                  begin
                    PlayObject.m_boOffLineLogin := True;
                    PlayObject.m_boSendNotice := False;
                    PlayObject.m_boSendImageFileCustom := False;
                    PlayObject.m_boSendSafeZoneEffectCustom := False;
                    PlayObject.m_boSendNpcCustom := False;
                    PlayObject.m_boLoginNoticeOK := False;
                    PlayObject.m_dwRunTick := 0;
                    PlayObject.m_dwSearchTick := 0;
                    PlayObject.m_boReadyRun := False;
                    PlayObject.m_boOffLineFlag := False;
                    PlayObject.m_boOffLinePlay := False;
                    PlayObject.m_nSessionID := UserOpenInfo.LoadUser.nSessionID;
                    PlayObject.m_nSocket := UserOpenInfo.LoadUser.nSocket;
                    PlayObject.m_nGateIdx := UserOpenInfo.LoadUser.nGateIdx;
                    PlayObject.m_nGSocketIdx := UserOpenInfo.LoadUser.nGSocketIdx;
                    m_NewHumanList.Add(PlayObject);
                  end;
                end;
              tLoadFail:
                begin //Load hero rcd fail...
                  PlayObject := GetPlayObjectNotGhost(UserOpenInfo.LoadUser.sMasterName);
                  if PlayObject <> nil then
                  begin
                    PlayObject.m_boLoadRcdFail := True;
                  end;
                end;
            end;
          end
          else
          begin
            nCHECK := 5;
            KickOnlineUser(sUser);
            UserOpenInfo := pTUserOpenInfo(m_LoadPlayList.Objects[i]);
            if UserOpenInfo.LoadUser.nSocket <> -1 then
            begin
              m_ListOfGateIdx.Add(Pointer(UserOpenInfo.LoadUser.nGateIdx));
              m_ListOfSocket.Add(Pointer(UserOpenInfo.LoadUser.nSocket));
            end;
          end;
          Dispose(pTUserOpenInfo(m_LoadPlayList.Objects[i]));
        end;
        m_LoadPlayList.Clear;
      finally
        LeaveCriticalSection(m_LoadPlaySection);
      end;

      nCHECK := 15;
      for i := 0 to m_NewHumanList.Count - 1 do
      begin
        PlayObject := TPlayObject(m_NewHumanList.Items[i]);
        if (PlayObject.m_nSocket <> -1) then
          RunSocket.SetGateUserList(PlayObject.m_nGateIdx, PlayObject.m_nSocket, PlayObject);
      end;
      m_NewHumanList.Clear;

      nCHECK := 18;
      for i := 0 to m_ListOfGateIdx.Count - 1 do
      begin
        //MainOutMessageAPI('m_ListOfGateIdx');
        RunSocket.CloseUser(Integer(m_ListOfGateIdx.Items[i]), Integer(m_ListOfSocket.Items[i]));
      end;

      m_ListOfGateIdx.Clear;
      m_ListOfSocket.Clear;
    except
      on E: Exception do
      begin
        MainOutMessageAPI(Format(sExceptionMsg1, [nCHECK]));
        MainOutMessageAPI(E.Message);
      end;
    end;

  end;

  if (GetTickCount - m_dwProcessSavePlayTick) > 200 then
  begin
    m_dwProcessSavePlayTick := GetTickCount();
    nCHECK := 101;
    try
      EnterCriticalSection(m_SavePlaySection);
      try
        for i := 0 to m_SavePlayList.Count - 1 do
        begin
          UserSaveInfo := pTUserSaveInfo(m_SavePlayList[i]); //? FrontEngine.IsFull
          if UserSaveInfo.bNewHero then
          begin
            PlayObject := GetPlayObjectNotGhost(UserSaveInfo.sChrName);
            if PlayObject <> nil then
            begin
              PlayObject.m_nNewHeroOK := UserSaveInfo.HeroFlag;
              PlayObject.m_boNewHero := True;
            end;
          end
          else
          begin
            PlayObject := GetPlayObjectNotGhost(UserSaveInfo.sChrName);
            if PlayObject <> nil then
              PlayObject.m_boRcdSaved := True;
          end;
          Dispose(pTUserSaveInfo(m_SavePlayList[i]));
        end;
        m_SavePlayList.Clear;
      finally
        LeaveCriticalSection(m_SavePlaySection);
      end;
    except
      on E: Exception do
      begin
        MainOutMessageAPI(Format(sExceptionMsg1, [nCHECK]));
        MainOutMessageAPI(E.Message);
      end;
    end;
  end;

  try
    for i := 0 to m_PlayObjectFreeList.Count - 1 do
    begin
      PlayObject := TPlayObject(m_PlayObjectFreeList[i]);
      if (GetTickCount - PlayObject.m_dwGhostTick) > g_Config.dwHumanFreeDelayTime {5 * 60 * 1000} then
      begin
        try
          TPlayObject(m_PlayObjectFreeList[i]).Free;
        except
          MainOutMessageAPI(sExceptionMsg2);
        end;
        m_PlayObjectFreeList.Delete(i);
        Break;
      end
      else
      begin
        if PlayObject.m_boSwitchData and PlayObject.m_boRcdSaved then
        begin
          if SendSwitchData(PlayObject, PlayObject.m_nServerIndex) or (PlayObject.m_nWriteChgDataErrCount > 20) then
          begin
            PlayObject.m_boSwitchData := False;
            PlayObject.m_boSwitchDataOK := False;
            PlayObject.m_boSwitchDataNeedDelay := True;
            PlayObject.m_dwChgDataWritedTick := GetTickCount();
          end
          else
            Inc(PlayObject.m_nWriteChgDataErrCount);
        end;
        if PlayObject.m_boSwitchDataNeedDelay and (PlayObject.m_boSwitchDataOK or ((GetTickCount - PlayObject.m_dwChgDataWritedTick) > 10 * 1000)) then
        begin
          PlayObject.ClearAllSlaves;
          PlayObject.m_boSwitchDataNeedDelay := False;
          SendChangeServer(PlayObject, PlayObject.m_nServerIndex);
        end;
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg3);
  end;

  boCheckTimeLimit := False;
  try
    dwCurTick := GetTickCount();
{$IF V_TEST = 1}
    nIdx := 0;
{$ELSE}
    nIdx := m_nProcHumIDx;
{$IFEND V_TEST}
    while True do
    begin
      if m_PlayObjectList.Count <= nIdx then
        Break;
      PlayObject := TPlayObject(m_PlayObjectList.Objects[nIdx]);
      if dwCurTick - PlayObject.m_dwRunTick > PlayObject.m_nRunTime then
      begin
        PlayObject.m_dwRunTick := dwCurTick;
        if not PlayObject.m_boGhost then
        begin
          if not PlayObject.m_boLoginNoticeOK then
          begin
{$IF CATEXCEPTION = TRYEXCEPTION}
            try
{$IFEND}
              PlayObject.RunNotice();
              PlayObject.RunSendImageFileCustom();
              PlayObject.RunSendSafeZoneEffectCustom();
              PlayObject.RunSendNpcCustom();
{$IF CATEXCEPTION = TRYEXCEPTION}
            except
              MainOutMessageAPI(sExceptionMsg4);
            end;
{$IFEND}
          end
          else
          begin
            //try           //0710
            if not PlayObject.m_boReadyRun then
            begin
              nCHECK := 22;
              PlayObject.m_boReadyRun := True;
              PlayObject.m_dwRunTick := 0;
              PlayObject.m_dwSearchTick := 0;
              if PlayObject.m_boOffLineLogin then
              begin
                PlayObject.UserResumeLogon
              end
              else
              begin
                PlayObject.UserLogon;
              end;
            end
            else
            begin
              //if not PlayObject.m_boOffLineFlag or PlayObject.m_boOffLinePlay or g_Config.DeathWalking then begin //080118
              if not PlayObject.m_boOffLineFlag or PlayObject.m_boOffLinePlay {or PlayObject.m_boSearch} then
              begin
                {if PlayObject.m_boSearch then begin
                  PlayObject.m_boSearch := False;
                  PlayObject.m_dwSearchTime := 0;
                end;}
                if (GetTickCount - PlayObject.m_dwSearchTick) > PlayObject.m_dwSearchTime then
                begin
                  PlayObject.m_dwSearchTick := GetTickCount();
                  PlayObject.SearchViewRange;
                  PlayObject.GameTimeChanged;
                end;
              end;

              if not PlayObject.m_boOffLineFlag then
              begin
                if (GetTickCount() - PlayObject.m_dwShowLineNoticeTick) > g_Config.dwShowLineNoticeTime then
                begin
                  PlayObject.m_dwShowLineNoticeTick := GetTickCount();
                  if LineNoticeList.Count > PlayObject.m_nShowLineNoticeIdx then
                  begin
                    if g_ManageNPC <> nil then
                      LineNoticeMsg := g_ManageNPC.GetLineVariableText(PlayObject, LineNoticeList.Strings[PlayObject.m_nShowLineNoticeIdx])
                    else
                      LineNoticeMsg := LineNoticeList.Strings[PlayObject.m_nShowLineNoticeIdx];
                    case LineNoticeMsg[1] of
                      'R': PlayObject.SysMsg(Copy(LineNoticeMsg, 2, Length(LineNoticeMsg) - 1), c_Red, t_Notice);
                      'G': PlayObject.SysMsg(Copy(LineNoticeMsg, 2, Length(LineNoticeMsg) - 1), c_Green, t_Notice);
                      'B': PlayObject.SysMsg(Copy(LineNoticeMsg, 2, Length(LineNoticeMsg) - 1), c_Blue, t_Notice);
                    else
                      PlayObject.SysMsg(LineNoticeMsg, TMsgColor(g_Config.nLineNoticeColor) {c_Blue}, t_Notice);
                    end;
                  end;
                  Inc(PlayObject.m_nShowLineNoticeIdx);
                  if (LineNoticeList.Count <= PlayObject.m_nShowLineNoticeIdx) then
                    PlayObject.m_nShowLineNoticeIdx := 0;
                end;

              end;

              PlayObject.Run();
              nCHECK := 29;
              if not FrontEngine.IsFull2 and ((GetTickCount - PlayObject.m_dwSaveRcdTick) > g_Config.dwSaveHumanRcdTime) then
              begin
                PlayObject.m_dwSaveRcdTick := GetTickCount();
                nCHECK := 30;
                PlayObject.DealCancelA();
                SaveHumanRcd(PlayObject);
              end;
            end;
            {except
              on E: Exception do begin
                MainOutMessageAPI(Format(sExceptionMsg5, [nCHECK]));
                MainOutMessageAPI(E.Message);
              end;
            end;}
          end;
        end
        else
        begin
          try
            if nIdx < m_PlayObjectList.Count then
              m_PlayObjectList.Delete(nIdx);
            PlayObject.Disappear();
          except
            on E: Exception do
            begin
              MainOutMessageAPI(Format(sExceptionMsg6, [nCHECK]));
              MainOutMessageAPI(E.Message);
            end;
          end;

          try
            AddToHumanFreeList(PlayObject);
            PlayObject.DealCancelA();
            SaveHumanRcd(PlayObject);
            //if g_Config.boUseCustomData and (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then
            //  PlayObject.SaveHumanCustomData();
            //MainOutMessageAPI('m_boGhost:' + IntToStr(PlayObject.m_nGateIdx) + ' ' + IntToStr(PlayObject.m_nSocket));
            RunSocket.CloseUser(PlayObject.m_nGateIdx, PlayObject.m_nSocket);
          except
            MainOutMessageAPI(Format(sExceptionMsg7, [nCHECK]));
          end;
          SendInterMsg(ISM_USERLOGOUT, g_nServerIndex, PlayObject.m_sCharName);
          Continue;
        end;
      end;
{$IF V_TEST = 1}
      Inc(nIdx);
      if nIdx > 10 then
        Break;
{$ELSE}
      Inc(nIdx);
      if (GetTickCount - dwCheckTime) > g_dwHumLimit then
      begin
        boCheckTimeLimit := True;
        m_nProcHumIDx := nIdx;
        Break;
      end;
{$IFEND V_TEST}
    end;
    if not boCheckTimeLimit then
      m_nProcHumIDx := 0;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(sExceptionMsg8);
      MainOutMessageAPI(E.Message);
    end;
  end;

  Inc(nProcessHumanLoopTime);
  g_nProcessHumanLoopTime := nProcessHumanLoopTime;

  if m_nProcHumIDx = 0 then
  begin
    nProcessHumanLoopTime := 0;
    g_nProcessHumanLoopTime := nProcessHumanLoopTime;
    dwUsrRotTime := GetTickCount - g_dwUsrRotCountTick;
    dwUsrRotCountMin := dwUsrRotTime;
    g_dwUsrRotCountTick := GetTickCount();
    if dwUsrRotCountMax < dwUsrRotTime then
      dwUsrRotCountMax := dwUsrRotTime;
  end;

  g_nHumCountMin := GetTickCount - dwCheckTime;
  if g_nHumCountMax < g_nHumCountMin then
    g_nHumCountMax := g_nHumCountMin;
end;

procedure TUserEngine.ProcessMerchants;
var
  dwRunTick, dwCurrTick: LongWord;
  i: Integer;
  MerchantNPC: TMerchant;
  boProcessLimit: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::ProcessMerchants';
begin
  dwRunTick := GetTickCount();
  boProcessLimit := False;
  try
    dwCurrTick := GetTickCount();
    m_MerchantList.Lock;
    try
      for i := nMerchantPosition to m_MerchantList.Count - 1 do
      begin
        MerchantNPC := m_MerchantList.Items[i];
        if not MerchantNPC.m_boGhost then
        begin
          if dwCurrTick - MerchantNPC.m_dwRunTick > MerchantNPC.m_nRunTime then
          begin
            MerchantNPC.m_dwRunTick := dwCurrTick;
            if (GetTickCount - MerchantNPC.m_dwSearchTick) > MerchantNPC.m_dwSearchTime then
            begin
              MerchantNPC.m_dwSearchTick := GetTickCount();
              MerchantNPC.SearchViewRange();
            end;
            MerchantNPC.Run;
          end;
        end
        else if (GetTickCount - MerchantNPC.m_dwGhostTick) > 60 * 1000 then
        begin
          MerchantNPC.Free;
          m_MerchantList.Delete(i);
          Break;
        end;
        if (GetTickCount - dwRunTick) > g_dwNpcLimit then
        begin
          nMerchantPosition := i;
          boProcessLimit := True;
          Break;
        end;
      end;
    finally
      m_MerchantList.UnLock;
    end;
    if not boProcessLimit then
      nMerchantPosition := 0;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(sExceptionMsg);
      MainOutMessageAPI(E.Message);
    end;
  end;
  dwProcessMerchantTimeMin := GetTickCount - dwRunTick;
  if dwProcessMerchantTimeMin > dwProcessMerchantTimeMax then
    dwProcessMerchantTimeMax := dwProcessMerchantTimeMin;
  if dwProcessNpcTimeMin > dwProcessNpcTimeMax then
    dwProcessNpcTimeMax := dwProcessNpcTimeMin;
end;

procedure TUserEngine.ProcessHero;
var
  i, code: Integer;
  dwRunTick, dwCurrTick: LongWord;
  Hero: THeroObject; //TAnimalObject; //TPlayObject;
  boProcessLimit: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::ProcessHeros %d';
begin
  code := 0;
  try
    code := 1;
    dwRunTick := GetTickCount();
    boProcessLimit := False;
    //m_HeroProcList.Lock;
    //try
    dwCurrTick := dwRunTick;
    for i := m_nHeroPosition to m_HeroProcList.Count - 1 do
    begin
      code := 2;
      Hero := m_HeroProcList.Items[i];
      code := 3;
      if not Hero.m_boGhost then
      begin
        if dwCurrTick - Hero.m_dwRunTick > Hero.m_nRunTime then
        begin
          Hero.m_dwRunTick := dwCurrTick;
          code := 4;
          if (GetTickCount - Hero.m_dwSearchTick) > Hero.m_dwSearchTime then
          begin
            Hero.m_dwSearchTick := GetTickCount();
            if not Hero.m_boDeath then
            begin
              Hero.SearchViewRange();
            end
            else
            begin
              Hero.SearchViewRange_Death();
            end;
          end;
          code := 5;
          Hero.Run();
          code := 6;
          if Hero.HeroCanSaveRcd then
          begin
            if {not FrontEngine.IsFull2 and}((GetTickCount - Hero.m_dwHeroSaveRcdTick) > _MAX(15 * 60 * 1000, g_Config.dwSaveHumanRcdTime)) then
            begin
              Hero.m_dwHeroSaveRcdTick := GetTickCount();
              SaveHumanRcd(TPlayObject(Hero));
            end;
          end;
        end;
      end
      else
      begin
        code := 7;
        if Hero.HeroCanSaveRcd then
        begin
          Hero.m_boHeroSaveRcd := True;
          SaveHumanRcd(TPlayObject(Hero));
        end;
        if (GetTickCount - Hero.m_dwGhostTick) > 5 * 60 * 1000 then
        begin
          code := 8;
          m_HeroProcList.Delete(i);
          Hero.Free;
          Break;
        end;
      end;
      code := 9;
      if (GetTickCount - dwRunTick) > 28 then
      begin //0824
        boProcessLimit := True;
        m_nHeroPosition := i;
        Break;
      end;
    end;
    //finally
    //  m_HeroProcList.UnLock;
    //end;
    if not boProcessLimit then
      m_nHeroPosition := 0;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [code]));
      MainOutMessageAPI(E.Message);
    end;
  end;
  dwProcessHeroTimeMin := GetTickCount - dwRunTick;
  if dwProcessHeroTimeMin > dwProcessHeroTimeMax then
    dwProcessHeroTimeMax := dwProcessHeroTimeMin;
end;

procedure TUserEngine.ProcessEscort;
var
  i, code: Integer;
  dwRunTick, dwCurrTick: LongWord;
  Escort: TEscortMon;
  boProcessLimit: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::ProcessEscorts %d';
begin
  code := 0;
  try
    code := 1;
    dwRunTick := GetTickCount();
    boProcessLimit := False;
    dwCurrTick := dwRunTick;
    for i := m_nEscortPosition to m_EscortProcList.Count - 1 do
    begin
      code := 2;
      Escort := m_EscortProcList.Items[i];
      //Escort := TEscortMon(m_EscortProcList.GetValues(m_EscortProcList.Keys[i]));
      code := 3;
      if not Escort.m_boGhost then
      begin
        if dwCurrTick - Escort.m_dwRunTick > Escort.m_nRunTime then
        begin
          Escort.m_dwRunTick := dwCurrTick;
          code := 4;
          if (GetTickCount - Escort.m_dwSearchTick) > Escort.m_dwSearchTime then
          begin
            Escort.m_dwSearchTick := GetTickCount();
            if not Escort.m_boDeath then
            begin
              Escort.SearchViewRange();
            end
            else
            begin
              Escort.SearchViewRange_Death();
            end;
          end;
          code := 5;
          Escort.Run();
        end;
      end
      else
      begin
        code := 7;
        if (GetTickCount - Escort.m_dwGhostTick) > 5 * 60 * 1000 then
        begin
          code := 8;
          //m_EscortProcList.Delete(m_EscortProcList.Keys[i]);
          m_EscortProcList.Delete(i);
          Escort.Free;
          Break;
        end;
      end;
      code := 9;
      if (GetTickCount - dwRunTick) > 28 then
      begin //0824
        boProcessLimit := True;
        m_nEscortPosition := i;
        Break;
      end;
    end;
    if not boProcessLimit then
      m_nEscortPosition := 0;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [code]));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;
{
procedure TUserEngine.ProcessMissions;
begin

end;
}
function GetZenTime(dwTime: LongWord): LongWord;
var
  d10: Double;
begin
  if dwTime < 30 * 60 * 1000 then
  begin
    d10 := (UserEngine.GetUserCount - g_Config.nUserFull) / _MAX(1, g_Config.nZenFastStep);
    if d10 > 0 then
    begin
      if d10 > 6 then
        d10 := 6;
      Result := dwTime - Round((dwTime / 10) * d10)
    end
    else
      Result := dwTime;
  end
  else
    Result := dwTime;
end;

procedure TUserEngine.ProcessMonsters;
var
  i: Integer;
  dwCurrentTick: LongWord;
  dwRunTick: LongWord;
  dwMonProcTick: LongWord;
  MonGen: pTMonGenInfo;
  nGenCount: Integer;
  nGenModCount: Integer;
  boProcessLimit: Boolean;
  boRegened: Boolean;
  boCanCreate: Boolean;
  nProcessPosition: Integer;
  Monster: TAnimalObject;
  Map: TEnvirnoment;
  nCheckCode: Integer;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::ProcessMonsters %d';
begin
  nCheckCode := 0;
  dwRunTick := GetTickCount();
  try //0406
    boProcessLimit := False;
    dwCurrentTick := GetTickCount();
    MonGen := nil;
    if (GetTickCount - dwRegenMonstersTick) > g_Config.dwRegenMonstersTime then
    begin
      dwRegenMonstersTick := GetTickCount();

      nCheckCode := 1;
      if m_nCurrMonGen < m_MonGenList.Count then
        MonGen := m_MonGenList.Items[m_nCurrMonGen]
      else if m_MonGenList.Count > 0 then
        MonGen := m_MonGenList.Items[0];

      if m_nCurrMonGen < m_MonGenList.Count - 1 then
        Inc(m_nCurrMonGen)
      else
        m_nCurrMonGen := 0;

      if (MonGen <> nil) and (MonGen.sMonName <> '') and not g_Config.boVentureServer then
      begin
        nCheckCode := 2;
        if (MonGen.dwStartTick = 0) or (LongWord(GetTickCount - MonGen.dwStartTick) > GetZenTime(MonGen.dwZenTime)) then
        begin
          nCheckCode := 3;
          //nGenCount := GetGenMonCount(MonGen);

          nGenCount := MonGen.nActiveCount;

          boRegened := True;

          nGenModCount := Round(MonGen.nCount / g_Config.nMonGenRate * 10);

          if nGenModCount > nGenCount then
          begin
            nCheckCode := 4;
            boCanCreate := True;
            Map := g_MapManager.FindMap(MonGen.sMapName);
            if (Map = nil) or (Map.m_MapFlag.boNoManNoMon and (Map.HumCount <= 0)) then
              boCanCreate := False;
            if boCanCreate then
            begin
              nCheckCode := 5;
              boRegened := RegenMonsters(MonGen, nGenModCount - nGenCount);
            end;
          end;

          nCheckCode := 6;
          if boRegened then
          begin
            MonGen.dwStartTick := GetTickCount();
            g_sMonGenInfo1 := Format('%s/%d/%d (%d/%d)', [MonGen.sMonName, m_nCurrMonGen, m_MonGenList.Count, nGenCount, nGenModCount]);
            //MonGen.sMonName + '/' + IntToStr(m_nCurrMonGen) + '/' + IntToStr(m_MonGenList.Count);
          end;
        end;
      end;
    end;

    g_nMonGenTime := GetTickCount - dwCurrentTick;
    if g_nMonGenTime > g_nMonGenTimeMin then
      g_nMonGenTimeMin := g_nMonGenTime;
    if g_nMonGenTime > g_nMonGenTimeMax then
      g_nMonGenTimeMax := g_nMonGenTime;

    nCheckCode := 7;
    dwMonProcTick := GetTickCount();
    for i := m_nMonGenListPosition to m_MonGenList.Count - 1 do
    begin

      MonGen := m_MonGenList.Items[i];
      nCheckCode := 8;
      if m_nMonGenCertListPosition < MonGen.CertList.Count then
        nProcessPosition := m_nMonGenCertListPosition
      else
        nProcessPosition := 0;

      m_nMonGenCertListPosition := 0;
      while (True) do
      begin
        if nProcessPosition >= MonGen.CertList.Count then
          Break;

        Monster := MonGen.CertList.Items[nProcessPosition];

        if not Monster.m_boGhost then
        begin
          if dwCurrentTick - Monster.m_dwRunTick > Monster.m_nRunTime then
          begin
            Monster.m_dwRunTick := dwRunTick;
{$IF PROCESSMONSTMODE = OLDMONSTERMODE}
            if not Monster.m_boDeath then
            begin
              if (dwCurrentTick - Monster.m_dwSearchTick) > Monster.m_dwSearchTime then
              begin
                Monster.m_dwSearchTick := GetTickCount();
                nCheckCode := 9;
                Monster.SearchViewRange();
              end;
            end;
            Monster.Run;
{$ELSE}
            if Monster.m_boDeath and Monster.m_boCanReAlive and Monster.m_boInvisible and (Monster.m_pMonGen <> nil) then
            begin
              if LongWord(GetTickCount - Monster.m_dwReAliveTick) > GetZenTime(Monster.m_pMonGen.dwZenTime) then
              begin
                if Monster.ReAliveEx(Monster.m_pMonGen) then
                begin
                  Monster.m_dwReAliveTick := GetTickCount;
                end;
              end;
            end;

            nCheckCode := 10;
            if not Monster.m_boIsVisibleActive and (Monster.m_nProcessRunCount < g_Config.nProcessMonsterInterval) then
              Inc(Monster.m_nProcessRunCount)
            else
            begin
              //if not Monster.m_boDeath then begin    //ItemClear ...
              if (dwCurrentTick - Monster.m_dwSearchTick) > Monster.m_dwSearchTime then
              begin
                Monster.m_dwSearchTick := GetTickCount();
                nCheckCode := 9;
                if not Monster.m_boDeath then
                begin
                  Monster.SearchViewRange();
                end
                else
                begin
                  Monster.SearchViewRange_Death();
                end;
              end;
              //end;

              Monster.m_nProcessRunCount := 0;
              nCheckCode := 11;
              try
                Monster.Run;
              except
                on E: Exception do
                begin
                  MainOutMessageAPI(Format(sExceptionMsg, [nCheckCode]) + ' Race:' + IntToStr(Monster.m_btRaceServer));
                  MainOutMessageAPI(E.Message);
                end;
              end;
            end;
{$IFEND}
            //Inc(nMonsterProcessCount);
          end;
          Inc(nMonsterProcessPostion);
        end
        else
        begin
          if (GetTickCount - Monster.m_dwGhostTick) > 5 * 60 * 1000 then
          begin
            nCheckCode := 17;
            MonGen.CertList.Delete(nProcessPosition);
            Monster.Free;
            {race := Monster.m_btRaceServer;
            try
              Monster.Free;
            except
              on E: Exception do begin
                MainOutMessageAPI(Format(sExceptionMsg, [nCheckCode]) + ' Race(Ghost):' + IntToStr(race));
                MainOutMessageAPI(E.Message);
              end;
            end;}
            Continue;
          end;
        end;
        Inc(nProcessPosition);
        if (GetTickCount - dwMonProcTick) > g_dwMonLimit then
        begin
          nCheckCode := 18;
          g_sMonGenInfo2 := Format('%s/%d/%d', [Monster.m_sCharName, i, nProcessPosition]); //Monster.m_sCharName + '/' + IntToStr(i) + '/' + IntToStr(nProcessPosition);
          boProcessLimit := True;
          m_nMonGenCertListPosition := nProcessPosition;
          Break;
        end;
      end;
      if boProcessLimit then Break;
    end;
    if m_MonGenList.Count <= i then
    begin
      m_nMonGenListPosition := 0;
      nMonsterCount := nMonsterProcessPostion;
      nMonsterProcessPostion := 0;
    end;
    if not boProcessLimit then
      m_nMonGenListPosition := 0
    else
      m_nMonGenListPosition := i;
    g_nMonProcTime := GetTickCount - dwMonProcTick;
    if g_nMonProcTime > g_nMonProcTimeMin then
      g_nMonProcTimeMin := g_nMonProcTime;
    if g_nMonProcTime > g_nMonProcTimeMax then
      g_nMonProcTimeMax := g_nMonProcTime;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [nCheckCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;
  g_nMonTimeMin := GetTickCount - dwRunTick;
  if g_nMonTimeMax < g_nMonTimeMin then g_nMonTimeMax := g_nMonTimeMin;
end;
{
function TUserEngine.GetGenMonCount(MonGen: pTMonGenInfo): Integer;
var
  i: Integer;
  nCount: Integer;
  BaseObject: TBaseObject;
begin
  nCount := 0;
  for i := 0 to MonGen.CertList.Count - 1 do
  begin
    BaseObject := TBaseObject(MonGen.CertList.Items[i]);
    if not BaseObject.m_boDeath and not BaseObject.m_boGhost then
      Inc(nCount);
  end;
  Result := nCount;
end;
 }
procedure TUserEngine.ProcessNpcs;
var
  dwRunTick, dwCurrTick: LongWord;
  i: Integer;
  NPC: TNormNpc;
  boProcessLimit: Boolean;
begin
  dwRunTick := GetTickCount();
  boProcessLimit := False;
  try
    dwCurrTick := GetTickCount();
    for i := nNpcPosition to QuestNPCList.Count - 1 do
    begin
      NPC := QuestNPCList.Items[i];
      if not NPC.m_boGhost then
      begin
        if dwCurrTick - NPC.m_dwRunTick > NPC.m_nRunTime then
        begin
          NPC.m_dwRunTick := dwCurrTick;
          if (GetTickCount - NPC.m_dwSearchTick) > NPC.m_dwSearchTime then
          begin
            NPC.m_dwSearchTick := GetTickCount();
            NPC.SearchViewRange();
          end;
          NPC.Run;
        end;
      end
      else if (GetTickCount - NPC.m_dwGhostTick) > 60 * 1000 then
      begin
        NPC.Free;
        QuestNPCList.Delete(i);
        Break;
      end;
      if (GetTickCount - dwRunTick) > g_dwNpcLimit then
      begin
        nNpcPosition := i;
        boProcessLimit := True;
        Break;
      end;
    end;
    if not boProcessLimit then
      nNpcPosition := 0;
  except
    on E: Exception do
    begin
      MainOutMessageAPI('[Exceptioin] TUserEngine.ProcessNpcs');
      MainOutMessageAPI(E.Message);
    end;
  end;
  dwProcessNpcTimeMin := GetTickCount - dwRunTick;
  if dwProcessNpcTimeMin > dwProcessNpcTimeMax then
    dwProcessNpcTimeMax := dwProcessNpcTimeMin;
end;

function TUserEngine.RegenMonsterByName(sMAP: string; nX, nY: Integer; sMonName: string): TBaseObject;
var
  nRace: Integer;
  BaseObject: TBaseObject;
  n18: Integer;
  MonGen: pTMonGenInfo;
begin
  nRace := GetMonRace(sMonName);
  BaseObject := AddBaseObject(sMAP, nX, nY, nRace, sMonName);
  if BaseObject <> nil then
  begin
    n18 := m_MonGenList.Count - 1; //??????????
    if n18 < 0 then
      n18 := 0;
    MonGen := m_MonGenList.Items[n18];
    MonGen.CertList.Add(BaseObject);
    BaseObject.m_PEnvir.AddObjectCount(BaseObject);
    BaseObject.m_boAddToMaped := True;
    BaseObject.m_boDelFormMaped := False;
  end;
  Result := BaseObject;
end;

function TUserEngine.RegenHero(sMonName: string; Master: TPlayObject; btHeroType: byte): TBaseObject;
var
  BaseObject: TBaseObject;
  MonGen: pTMonGenInfo;
  nCount: Integer;
begin
  BaseObject := CreateHero(sMonName, Master, btHeroType);
  if BaseObject <> nil then
  begin
    if btHeroType = 1 then
      AddHero(BaseObject as THeroObject)
    else
    begin
      nCount := m_MonGenList.Count - 1;
      if nCount < 0 then
        nCount := 0;
      MonGen := m_MonGenList.Items[nCount];
      MonGen.CertList.Add(BaseObject);
    end;
    BaseObject.m_PEnvir.AddObjectCount(BaseObject);
    BaseObject.m_boAddToMaped := True;
    BaseObject.m_boDelFormMaped := False;
  end;
  Result := BaseObject;
end;

function TUserEngine.GetEscort(sCharName: string): TBaseObject;
var
  i: Integer;
  Mon: TEscortMon;
begin
  //Result := TBaseObject(m_EscortProcList.GetValues(sCharName));
  //if (Result <> nil) and Result.m_boGhost then
  //  Result := nil;
  Result := nil;
  for i := 0 to m_EscortProcList.Count - 1 do
  begin
    Mon := TEscortMon(m_EscortProcList[i]);
    if not Mon.m_boGhost and (CompareText(sCharName, Mon.m_sMName) = 0) then
    begin
      Result := Mon;
      Break;
    end;
  end;
end;

function TUserEngine.RegenEscort(sMAP: string; sMonName: string; PlayObject: TPlayObject): TBaseObject;
var
  ok: Boolean;
  nRace: Integer;
  BaseObject: TBaseObject;
  nX, nY: Integer;
begin
  Result := nil;
  if PlayObject.m_PEnvir = nil then
    Exit;
  ok := False;
  for nX := PlayObject.m_nCurrX - 1 to PlayObject.m_nCurrX + 1 do
  begin
    for nY := PlayObject.m_nCurrY - 1 to PlayObject.m_nCurrY + 1 do
    begin
      if PlayObject.m_PEnvir.CanWalk(nX, nY, True) then
      begin
        ok := True;
        Break;
      end;
    end;
    if ok then
      Break;
  end;
  if not ok then
    Exit;
  nRace := GetMonRace(sMonName);
  BaseObject := AddBaseObject(sMAP, nX, nY, nRace, sMonName);
  if (BaseObject <> nil) and (BaseObject is TEscortMon) then
  begin
    with BaseObject as TEscortMon do
    begin
      m_sMName := PlayObject.m_sCharName;
      m_EscortProcList.Add({PlayObject.m_sCharName,} BaseObject);
      m_PEnvir.AddObjectCount(BaseObject);
      m_boAddToMaped := True;
      m_boDelFormMaped := False;
    end;
  end;
  Result := BaseObject;
end;

procedure TUserEngine.Run;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::Run';
  sOnLineUserCount = '在线数: %d(%d)';
begin
  //CalceTime := GetTickCount;
  try
    if (GetTickCount() - dwShowOnlineTick) > g_Config.dwConsoleShowUserCountTime then
    begin
      dwShowOnlineTick := GetTickCount();
      NoticeManager.LoadingNotice;
      MainOutMessageAPI(Format(sOnLineUserCount, [GetUserCount, GetUserCount - OfflinePlayCountCS]));
      g_CastleManager.Save;
    end;
    if (GetTickCount() - dwSendOnlineHumTime) > 10 * 1000 then
    begin
      dwSendOnlineHumTime := GetTickCount();
      FrmIDSoc.SendOnlineHumCountMsg(GetOnlineHumCount);
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(sExceptionMsg);
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

function TUserEngine.GetTitle(nItemIdx: Integer): pTStdItem;
begin
  Result := nil;
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (TitleList.Count > nItemIdx) then
  begin
    if pTStdItem(TitleList.Items[nItemIdx]).Name <> '' then
      Result := TitleList.Items[nItemIdx];
  end;
end;

function TUserEngine.GetTitle(sItemName: string): pTStdItem;
var
  i: Integer;
  StdItem: pTStdItem;
begin
  Result := nil;
  if sItemName = '' then
    Exit;
  for i := 0 to TitleList.Count - 1 do
  begin
    StdItem := TitleList.Items[i];
    if CompareText(StdItem.Name, sItemName) = 0 then
    begin
      Result := StdItem;
      Break;
    end;
  end;
end;

function TUserEngine.GetTitleIdx(sItemName: string): Integer;
var
  i: Integer;
  StdItem: pTStdItem;
begin
  Result := -1;
  if sItemName = '' then
    Exit;
  for i := 0 to TitleList.Count - 1 do
  begin
    StdItem := TitleList.Items[i];
    if CompareText(StdItem.Name, sItemName) = 0 then
    begin
      Result := i + 1;
      Break;
    end;
  end;
end;

function TUserEngine.GetStdItem(nItemIdx: Integer): pTStdItem;
begin
  Result := nil;
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then
  begin
    if pTStdItem(StdItemList.Items[nItemIdx]).Name <> '' then
      Result := StdItemList.Items[nItemIdx];
  end;
end;

function TUserEngine.GetStdItem(sItemName: string): pTStdItem;
var
  i: Integer;
  StdItem: pTStdItem;
begin
  Result := nil;
  if sItemName = '' then
    Exit;
  for i := 0 to StdItemList.Count - 1 do
  begin
    StdItem := StdItemList.Items[i];
    if CompareText(StdItem.Name, sItemName) = 0 then
    begin
      Result := StdItem;
      Break;
    end;
  end;
end;

function TUserEngine.GetStdItemWeight(nItemIdx: Integer; TakeBackCnt: Integer): Integer;
var
  StdItem: pTStdItem;
begin
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then
  begin
    StdItem := StdItemList.Items[nItemIdx];
    if StdItem.Overlap = 1 then
      Result := StdItem.Weight + StdItem.Weight * (TakeBackCnt div 10)
    else if StdItem.Overlap >= 2 then
      Result := StdItem.Weight * TakeBackCnt
    else
      Result := StdItem.Weight;
  end
  else
    Result := 0;
end;

function TUserEngine.GetStdItemName(nItemIdx: Integer): string; //004AC1AC
begin
  Result := '';
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then
  begin
    Result := pTStdItem(StdItemList.Items[nItemIdx]).Name;
  end
  else
    Result := '';
end;

function TUserEngine.FindOtherServerUser(sName: string; var nServerIndex: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to m_OtherUserNameList.Count - 1 do
  begin
    if CompareText(m_OtherUserNameList[i], sName) = 0 then
    begin
      nServerIndex := Integer(m_OtherUserNameList.Objects[i]);
      Result := True;
      Break;
    end;
  end;
end;

procedure TUserEngine.CryCry(wIdent: Word; pMap: TEnvirnoment; nX, nY, nWide: Integer; btFColor, btBColor: byte; sMsg: string; sec: Integer);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boGhost and
      (PlayObject.m_PEnvir = pMap) and
      (PlayObject.m_boBanShout) and
      not PlayObject.m_boOffLineFlag and
      (abs(PlayObject.m_nCurrX - nX) < nWide) and
      (abs(PlayObject.m_nCurrY - nY) < nWide) then
    begin
      PlayObject.SendMsg(nil, wIdent, 0, btFColor, btBColor, sec, sMsg);
      //BaseObject.SendMsg(BaseObject, RM_GUILDMESSAGE, 0, g_Config.btGuildMsgFColor, g_Config.btGuildMsgBColor, 0, sMsg);
    end;
  end;
end;

procedure TUserEngine.DemoRun;
begin
  Run();
end;

function TUserEngine.MonGetAbility(Mon: TBaseObject): Integer;
var
  b: Boolean;
  i: Integer;
  sFileName, sLine: string;
  Monster: pTMonInfo;
  UseItemsList: TIniFile;
  SkellList: TStringList;
begin
  UseItemsList := nil;
  try
{$IF USEHASHLIST = 1}
    Monster := pTMonInfo(MonsterList.GetValues(Mon.m_sCharName));
    if Monster <> nil then
    begin
      sFileName := g_Config.sEnvirDir + 'MonUseItems\' + Mon.m_sCharName + '.txt';
      if FileExists(sFileName) then
        UseItemsList := TIniFile.Create(sFileName);
    end;
{$ELSE}
    for i := 0 to MonsterList.Count - 1 do
    begin
      Monster := MonsterList.Items[i];
      if CompareText(Monster.sName, Mon.m_sCharName) = 0 then
      begin
        sFileName := g_Config.sEnvirDir + 'MonUseItems\' + Mon.m_sCharName + '.txt';
        if FileExists(sFileName) then
          UseItemsList := TIniFile.Create(sFileName);
        Break;
      end;
    end;
{$IFEND}
    if UseItemsList <> nil then
    begin
      Mon.m_btJob := UseItemsList.ReadInteger('Info', 'Job', 0);
      Mon.m_btGender := UseItemsList.ReadInteger('Info', 'Gender', 0);
      Mon.m_btHair := UseItemsList.ReadInteger('Info', 'Hair', 0);
      if Mon.m_btHair > 1 then
        Mon.m_btHair := 1;

      if UseItemsList.ReadInteger('Info', 'Butch', -1) < 0 then
        UseItemsList.WriteBool('Info', 'Butch', False);
      Mon.m_boAnimal := UseItemsList.ReadBool('Info', 'Butch', False);
      Mon.m_boExplore := Mon.m_boAnimal;

      if UseItemsList.ReadInteger('Info', 'BodyLeathery', -1) < 0 then
        UseItemsList.WriteInteger('Info', 'BodyLeathery', 200);
      Mon.m_nBodyLeathery := UseItemsList.ReadInteger('Info', 'BodyLeathery', 200);
      Mon.m_nPerBodyLeathery := Mon.m_nBodyLeathery;

      if UseItemsList.ReadInteger('Info', 'DropUseItem', -1) < 0 then
        UseItemsList.WriteBool('Info', 'DropUseItem', Mon.m_boNoDropUseItemEx);
      Mon.m_boNoDropUseItemEx := not UseItemsList.ReadBool('Info', 'DropUseItem', Mon.m_boNoDropUseItemEx);
      //Mon.m_boNoDropItemEx := Mon.m_boNoDropUseItemEx;

      if UseItemsList.ReadInteger('Info', 'DropUseItemRate', -1) < 0 then
        UseItemsList.WriteInteger('Info', 'DropUseItemRate', Mon.m_nDropUseItemRate);
      Mon.m_nDropUseItemRate := UseItemsList.ReadInteger('Info', 'DropUseItemRate', Mon.m_nDropUseItemRate);

      if UseItemsList.ReadInteger('Info', 'UseAllSkillByJob', -1) < 0 then
        UseItemsList.WriteBool('Info', 'UseAllSkillByJob', False);

      b := UseItemsList.ReadBool('Info', 'UseAllSkillByJob', False);
      if b then
        Mon.ReadAllBook();

      sLine := UseItemsList.ReadString('Info', 'UseSkill', '');
      if sLine <> '' then
      begin
        SkellList := TStringList.Create;
        SkellList.Text := AnsiReplaceText(sLine, ',', #13);
        for i := 0 to SkellList.Count - 1 do
        begin
          sLine := Trim(SkellList.Strings[i]);
          Mon.AddSkillByName(sLine, 3);
        end;
        SkellList.Free;
      end;

      if Mon.m_fHeroMon then
      begin
        for i := 0 to 3 do
          Mon.AddSkillByName(g_JobofSeriesSkill[Mon.m_btJob][i], 5);
        for i := 0 to 3 do
          TPlayObject(Mon).ClientSetSeriesSkill2(i, 1);
      end;

      UseItemsList.Free;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI('[Exception] TUserEngine.MonGetAbility' + #13#10 + E.Message);
    end;
  end;
  Result := 1;
end;

function TUserEngine.MonGetRandomUseItems(Mon: TBaseObject): Integer;
var
  i: Integer;
  sFileName,iName: string;
  UserItem: TUserItem;
  StdItem: pTStdItem;
  Monster: pTMonInfo;
  UseItemsList: TIniFile;
begin
  UseItemsList := nil;
  try
{$IF USEHASHLIST = 1}
    Monster := pTMonInfo(MonsterList.GetValues(Mon.m_sCharName));
    if Monster <> nil then
    begin
      sFileName := g_Config.sEnvirDir + 'MonUseItems\' + Mon.m_sCharName + '.txt';
      if FileExists(sFileName) then
        UseItemsList := TIniFile.Create(sFileName);
    end;
{$ELSE}
    for i := 0 to MonsterList.Count - 1 do
    begin
      Monster := MonsterList.Items[i];
      if CompareText(Monster.sName, Mon.m_sCharName) = 0 then
      begin
        sFileName := g_Config.sEnvirDir + 'MonUseItems\' + Mon.m_sCharName + '.txt';
        if FileExists(sFileName) then
          UseItemsList := TIniFile.Create(sFileName);
        Break;
      end;
    end;
{$IFEND}
    if UseItemsList <> nil then
    begin

      for i := Low(THumanUseItems) to High(THumanUseItems) do
      begin
        iName := UseItemsList.ReadString('UseItems', 'UseItems' + IntToStr(i), '');
        if iName <> '' then
        begin
          if CopyToUserItemFromName(iName, @UserItem) then
          begin
            UserItem.Dura := Round((UserItem.DuraMax / 100) * (20 + Random(80)));
            StdItem := GetStdItem(UserItem.wIndex);
            if Random(g_Config.nMonRandomAddValue) = 0 then
              RandomUpgradeItem(@UserItem);
            if StdItem.StdMode in [15..24, 26] then
            begin
              if StdItem.Shape in [130..132] then
                GetUnknowItemValue(@UserItem);
            end;

            SetGatherExpItem(StdItem, @UserItem);

            Mon.m_UseItems[i] := UserItem;
          end;
        end;
      end;

      UseItemsList.Free;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI('[Exception] TUserEngine.MonGetRandomUseItems' + #13#10 + E.Message);
    end;
  end;
  Result := 1;
end;

function TUserEngine.MonGetRandomItems(Mon, ItemOfCreat: TBaseObject): Integer;
var
  i, n, nn,  nRate: Integer;
  ItemList: TList;
  iName: string;
  MonItem: pTMonItemInfo;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  Monster: pTMonInfo;
  boGetRate: Boolean;
begin
  if Mon = nil then
    Exit;

  if Mon.m_boGetRandomItems then
    Exit;

  ItemList := nil;
{$IF USEHASHLIST = 1}
  Monster := pTMonInfo(MonsterList.GetValues(Mon.m_sCharName));
  if Monster <> nil then
  begin
    ItemList := Monster.ItemList;
  end;
{$ELSE}
  for i := 0 to MonsterList.Count - 1 do
  begin
    Monster := MonsterList.Items[i];
    if CompareText(Monster.sName, Mon.m_sCharName) = 0 then
    begin
      ItemList := Monster.ItemList;
      Break;
    end;
  end;
{$IFEND}

  Mon.m_boGetRandomItems := True;

  if (ItemList <> nil) and (ItemList.Count > 0) then
  begin
    nRate := 0;
    if (ItemOfCreat <> nil) and ((ItemOfCreat.m_btRaceServer = RC_PLAYOBJECT) or ItemOfCreat.IsHero) and (TPlayObject(ItemOfCreat).m_nTagDropPlus > 0) then
    begin
      nRate := TPlayObject(ItemOfCreat).m_nTagDropPlus;
    end;

    //Mon.m_nGold := 0;
    for i := 0 to ItemList.Count - 1 do
    begin
      MonItem := pTMonItemInfo(ItemList[i]);
      iName := MonItem.ItemName;
      if (MonItem.MaxPoint = 88888888) then
      begin
        if (Mon.m_btRaceServer <> RC_HERO) and Mon.m_boExplore and not MonItem.IsGold {(CompareText(iName, sSTRING_GOLDNAME) <> 0)} then
        begin
          New(UserItem);
          if CopyToUserItemFromName(iName, UserItem) then
          begin
            UserItem.Dura := Round((UserItem.DuraMax / 100) * (20 + Random(80)));
            StdItem := GetStdItem(UserItem.wIndex);
            if Random(g_Config.nMonRandomAddValue {10}) = 0 then
              RandomUpgradeItem(UserItem);
            if StdItem.StdMode in [15..24, 26] then
            begin
              if StdItem.Shape in [130..132] then
                GetUnknowItemValue(UserItem);
            end;
            SetGatherExpItem(StdItem, UserItem);
            if StdItem.Overlap >= 1 then
              UserItem.Dura := 1;
            Mon.m_StorageItemList.Add(UserItem)
          end
          else
            Dispose(UserItem);
        end;
        Continue;
      end;

      boGetRate := False;
      nn := Random(MonItem.MaxPoint);
      if nRate > 0 then
      begin
        n := Round(MonItem.SelPoint * nRate / 100);
        if (MonItem.SelPoint + n) >= nn then
          boGetRate := True;
      end
      else
      begin
        if MonItem.SelPoint >= nn then
          boGetRate := True;
      end;

      if boGetRate then
      begin
        if MonItem.IsGold then
          Mon.m_nGold := Mon.m_nGold + (MonItem.Count div 2) + Random(MonItem.Count)
        else
        begin
          iName := MonItem.ItemName;
          New(UserItem);
          if CopyToUserItemFromName(iName, UserItem) then
          begin
            UserItem.Dura := Round((UserItem.DuraMax / 100) * (20 + Random(80)));
            StdItem := GetStdItem(UserItem.wIndex);
            if Random(g_Config.nMonRandomAddValue {10}) = 0 then
              RandomUpgradeItem(UserItem);
            if StdItem.StdMode in [15..24, 26] then
            begin
              if StdItem.Shape in [130..132] then
                GetUnknowItemValue(UserItem);
            end;
            SetGatherExpItem(StdItem, UserItem);
            Mon.m_ItemList.Add(UserItem)
          end
          else
            Dispose(UserItem);
        end;
      end;
    end;
  end;
  Result := 1;
end;

procedure TUserEngine.RandomUpgradeItem(item: pTUserItem);
var
  StdItem: pTStdItem;
begin
  StdItem := GetStdItem(item.wIndex);
  if StdItem = nil then
    Exit;
  case StdItem.StdMode of
    5, 6: ItemUnit.RandomUpgradeWeapon(item);
    10..13: ItemUnit.RandomUpgradeDress(item);
    19: ItemUnit.RandomUpgrade19(item);
    20, 21, 24: ItemUnit.RandomUpgrade202124(item);
    26: ItemUnit.RandomUpgrade26(item);
    22: ItemUnit.RandomUpgrade22(item);
    23: ItemUnit.RandomUpgrade23(item);
    15..18: ItemUnit.RandomUpgradeHelMet(item);
  end;
end;

procedure TUserEngine.RandomRefineItem(item: pTUserItem; var RandomAddValue: TRandomAddValue);
var
  StdItem: pTStdItem;
begin
  StdItem := GetStdItem(item.wIndex);
  if StdItem = nil then
    Exit;
  case StdItem.StdMode of
    5, 6: ItemUnit.RandomRefineWeapon(item, RandomAddValue);
    10..13: ItemUnit.RandomRefineDress(item, RandomAddValue);
    19: ItemUnit.RandomRefine19(item, RandomAddValue);
    20, 21, 24: ItemUnit.RandomRefine202124(item, RandomAddValue);
    26: ItemUnit.RandomRefine26(item, RandomAddValue);
    22: ItemUnit.RandomRefine22(item, RandomAddValue);
    23: ItemUnit.RandomRefine23(item, RandomAddValue);
    15..18: ItemUnit.RandomRefineHelMet(item, RandomAddValue);
  end;
end;

function TUserEngine.SecretProperty(item: pTUserItem; level: byte): Integer;
var
  StdItem: pTStdItem;
begin
  Result := 0;
  StdItem := GetStdItem(item.wIndex);
  if StdItem = nil then
    Exit;
  case StdItem.StdMode of
    5, 6: Result := ItemUnit.SecretProperty_Weapon(item, level);
    10..13, 15..24, 26..30, 51..54, 62..64: Result := ItemUnit.SecretProperty_Wearing(item, StdItem.StdMode, level);
  end;
end;

function TUserEngine.TreasureIdentify(item: pTUserItem): Integer;
var
  StdItem: pTStdItem;
begin
  Result := 0;
  StdItem := GetStdItem(item.wIndex);
  if StdItem = nil then
    Exit;
  case StdItem.StdMode of
    5, 6: Result := ItemUnit.TreasureIdentify_Weapon(item);
    10..13, 15..24, 26..30, 51..54, 62..64: Result := ItemUnit.TreasureIdentify_Wearing(item, StdItem.StdMode);
  end;
end;

procedure TUserEngine.GetUnknowItemValue(item: pTUserItem);
var
  StdItem: pTStdItem;
begin
  StdItem := GetStdItem(item.wIndex);
  if StdItem = nil then
    Exit;
  case StdItem.StdMode of
    15..18: ItemUnit.UnknowHelmet(item);
    22, 23: ItemUnit.UnknowRing(item);
    24, 26: ItemUnit.UnknowNecklace(item);
  end;
end;

function TUserEngine.CopyToUserItemFromName(sItemName: string; item: pTUserItem): Boolean;
var
  i: Integer;
  StdItem: pTStdItem;
begin
  Result := False;
  if sItemName <> '' then
  begin
    for i := 0 to StdItemList.Count - 1 do
    begin
      StdItem := StdItemList.Items[i];
      if CompareText(StdItem.Name, sItemName) = 0 then
      begin
        FillChar(item^, SizeOf(TUserItem), #0);
        item.wIndex := i + 1;
        item.MakeIndex := GetItemNumber();
        item.Dura := StdItem.DuraMax;
        item.DuraMax := StdItem.DuraMax;
        SetGatherExpItem(StdItem, item);
        Result := True;
        Break;
      end;
    end;
  end;
end;

procedure TUserEngine.ProcessUserMessage(PlayObject: TPlayObject; DefMsg: pTDefaultMessage; Buff: PChar);
var
  sMsg: string;

  x, y: Integer;
  A: byte;
  Key, sSendBuf: string;
  p: PChar;
  len: Integer;
  msg: TDefaultMessage;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::ProcessUserMessage.';
begin
  if (DefMsg = nil) or PlayObject.m_boOffLineFlag then
    Exit;
  try
    if Buff = nil then
      sMsg := ''
    else
      sMsg := StrPas(Buff);

    if gdeny then
    begin
      Exit;
    end;

    if ((DefMsg.Ident >= 9000) and (DefMsg.Ident <= 11332)) and
      (DefMsg.Ident <> RM_TWNHIT) and
      (DefMsg.Ident <> RM_SUQHIT) and
      (DefMsg.Ident <> RM_43) and
      (DefMsg.Ident <> RM_60) and
      (DefMsg.Ident <> RM_61) and
      (DefMsg.Ident <> RM_62) and
      (DefMsg.Ident <> RM_WHISPER) and
      (DefMsg.Ident <> CM_SPEEDHACKUSER) and
      (DefMsg.Ident <> CM_HEROSIDESTEP) and
      (DefMsg.Ident <> CM_CANCELMISSION) and
      (DefMsg.Ident <> CM_HEROSERIESSKILLCONFIG) then
    begin

      //MainOutMessageAPI(IntToStr(DefMsg.Ident));

      PlayObject.m_boKickFlag := True;
      Exit;
    end;

    //MainOutMessageAPI(IntToStr(DefMsg.Ident));

    {if ((DefMsg.Ident = CM_SITDOWN) then begin
      //MainOutMessageAPI(IntToStr(DefMsg.Ident));
      PlayObject.m_boKickFlag := True;
      Exit;
    end;}

    case DefMsg.Ident of
      CM_SPELL:
        begin
          if g_Config.boSpellSendUpdateMsg then
          begin
            PlayObject.SendUpdateMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog),
              HiWord(DefMsg.Recog),
              MakeLong(DefMsg.Param, DefMsg.Series),
              '');
          end
          else
          begin
            PlayObject.SendMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog),
              HiWord(DefMsg.Recog),
              MakeLong(DefMsg.Param, DefMsg.Series),
              '');
          end;
        end;

      CM_QUERYUSERNAME: PlayObject.SendMsg(PlayObject, DefMsg.Ident, 0, DefMsg.Recog, DefMsg.Param {x}, DefMsg.Tag {y}, '');

      CM_DROPITEM,
        CM_HERODROPITEM,
        CM_TAKEONITEM,
        CM_TAKEOFFITEM,
        CM_HEROTAKEONITEM,
        CM_HEROTAKEOFFITEM,
        CM_PLAYERADDITEMTOHERO,
        CM_HEROADDITEMTOPLAYER,
        CM_MERCHANTDLGSELECT,
        CM_MERCHANTQUERYSELLPRICE,
        CM_MERCHANTQUERYEXCHGBOOK,
        CM_USERSELLITEM,
        CM_SENDSELLITEMLIST,
        CM_ExchangeBook,
        CM_USERBUYITEM,
        CM_USERGETDETAILITEM,
        CM_CREATEGROUP,
        CM_ADDGROUPMEMBER,
        CM_DELGROUPMEMBER,
        CM_USERREPAIRITEM,
        CM_MERCHANTQUERYREPAIRCOST,
        CM_DEALTRY,
        CM_DEALADDITEM,
        CM_DEALDELITEM,
        CM_USERSTORAGEITEM,
        CM_USERSTORAGEITEMVIEW,
        CM_USERTAKEBACKSTORAGEITEM,
        CM_USERTAKEBACKSTORAGEITEMVIEW,
        CM_USERMAKEDRUGITEM,
        CM_GUILDADDMEMBER,
        CM_GUILDDELMEMBER,
        CM_GUILDUPDATENOTICE,
        CM_GUILDUPDATERANKINFO,
        CM_SELLOFF,
        CM_GETSALEDETAILITEM,
        CM_BUYSELLOFFITEM,
        CM_MARKET_LIST,
        CM_MARKET_SELL,
        CM_MARKET_BUY,
        CM_MARKET_CANCEL,
        CM_MARKET_GETPAY,
        CM_MARKET_CLOSE,
        CM_ITEMSUMCOUNT,
        CM_DISMANTLEITEM,
        CM_QUERYBINDITEM,
        CM_HEROCHANGING:
        begin
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            DecodeString(sMsg));
        end;
      CM_PASSWORD,
        CM_CHGPASSWORD,
        CM_SETPASSWORD:
        begin
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Param,
            DefMsg.Recog,
            DefMsg.Series,
            DefMsg.Tag,
            DecodeString(sMsg));
        end;
      CM_ADJUST_BONUS:
        begin
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            sMsg);
        end;
      CM_HORSERUN,
        CM_TURN,
        CM_WALK,
        CM_SITDOWN,
        CM_RUN,
        CM_HIT,
        CM_HEAVYHIT,
        CM_BIGHIT,
        CM_POWERHIT,
        CM_LONGHIT,
        CM_CRSHIT,
        CM_TWNHIT,
        CM_WIDEHIT,
        CM_FIREHIT, CM_HERO_LONGHIT2,
        CM_SQUHIT,
        CM_PURSUEHIT,
        CM_SMITEHIT,
        CM_SMITELONGHIT,
        CM_SMITELONGHIT2,
        CM_SMITELONGHIT3,
        CM_SMITEWIDEHIT,
        CM_SMITEWIDEHIT2: if DefMsg.Tag in [0..7] then
        begin
          if g_Config.boActionSendActionMsg then
          begin
            PlayObject.SendActionMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog), {x}
              HiWord(DefMsg.Recog), {y}
              0,
              '');
          end
          else
          begin
            PlayObject.SendMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog), {x}
              HiWord(DefMsg.Recog), {y}
              0,
              '');
          end;
        end;
      CM_SAY: PlayObject.SendMsg(PlayObject, CM_SAY, 0, 0, 0, 0, DecodeString(sMsg));
      CM_RECALLHERO:
        begin
          if not g_Config.boRecallHeroCtrl then
            PlayObject.SendMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Series,
              DefMsg.Recog,
              DefMsg.Param,
              DefMsg.Tag,
              '')
          else if sMsg <> '' then
          begin
            sSendBuf := DecodeString(sMsg);
            Key := IntToStr(Integer(PlayObject)) + '+' + PlayObject.m_sCharName + IntToStr(LoByte(DefMsg.Param));
            len := Length(sSendBuf);
            y := 1;
            p := @sSendBuf[1];
            for x := 0 to len - 1 do
            begin
              A := (Ord(p[x]) and $0F) xor (Ord(Key[y]) and $0F);
              p[x] := Char((Ord(p[x]) and $F0) + A);
              Inc(y);
              if y >= Length(Key) then
                y := 1;
            end;
            msg := DecodeMessage(sSendBuf);
            if (msg.Ident = CM_RECALLHERO) and (msg.Recog = Integer(PlayObject)) then
              PlayObject.SendMsg(PlayObject,
                msg.Ident,
                msg.Series,
                msg.Recog,
                msg.Param,
                msg.Tag,
                '');

          end;
        end;
      CM_UNRECALLHERO:
        begin
          if not g_Config.boRecallHeroCtrl then
            PlayObject.SendMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Series,
              DefMsg.Recog,
              DefMsg.Param,
              DefMsg.Tag,
              '')
          else if sMsg <> '' then
          begin
            sSendBuf := DecodeString(sMsg);
            Key := IntToStr(Integer(PlayObject)) + '-' + PlayObject.m_sCharName + IntToStr(HiByte(DefMsg.Series));
            len := Length(sSendBuf);
            y := 1;
            p := @sSendBuf[1];
            for x := 0 to len - 1 do
            begin
              A := (Ord(p[x]) and $0F) xor (Ord(Key[y]) and $0F);
              p[x] := Char((Ord(p[x]) and $F0) + A);
              Inc(y);
              if y >= Length(Key) then
                y := 1;
            end;
            msg := DecodeMessage(sSendBuf);
            if (msg.Ident = CM_UNRECALLHERO) and (msg.Recog = Integer(PlayObject)) then
              PlayObject.SendMsg(PlayObject,
                msg.Ident,
                msg.Series,
                msg.Recog,
                msg.Param,
                msg.Tag,
                '');

          end;
        end;

    else
      begin
        PlayObject.SendMsg(PlayObject,
          DefMsg.Ident,
          DefMsg.Series,
          DefMsg.Recog,
          DefMsg.Param,
          DefMsg.Tag,
          sMsg);
      end;
    end;
    if PlayObject.m_boReadyRun then
    begin
      case DefMsg.Ident of
        CM_TURN,
          CM_WALK,
          CM_SITDOWN,
          CM_RUN,
          CM_HIT,
          CM_HEAVYHIT,
          CM_BIGHIT,
          CM_POWERHIT,
          CM_LONGHIT,
          CM_WIDEHIT,
          CM_FIREHIT, CM_HERO_LONGHIT2,
          CM_CRSHIT,
          CM_TWNHIT,
          CM_SQUHIT,
          CM_PURSUEHIT,
          CM_SMITEHIT,
          CM_SMITELONGHIT,
          CM_SMITELONGHIT2,
          CM_SMITELONGHIT3,
          CM_SMITEWIDEHIT,
          CM_SMITEWIDEHIT2:
          begin
            Dec(PlayObject.m_dwRunTick, 100);
          end;
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

function TUserEngine.AddBaseObject(sMapName: string; nX, nY: Integer; nMonRace: Integer; sMonName: string): TBaseObject; //004AD56C
var
  Map: TEnvirnoment;
  Cert: TBaseObject;
  n1C, n20, n24: Integer;
  p28: Pointer;
begin
  Result := nil;
  Cert := nil;
  Map := g_MapManager.FindMap(sMapName);
  if Map = nil then
    Exit;
  case nMonRace of
    11, RC_GUARD2: Cert := TSuperGuard.Create;
    20: Cert := TArcherPolice.Create;
    51:
      begin
        Cert := TMonster.Create;
        Cert.m_boAnimal := True;
        Cert.m_nMeatQuality := Random(3500) + 3000;
        Cert.m_nBodyLeathery := 50;
      end;
    52:
      begin
        if Random(30) = 0 then
        begin
          Cert := TChickenDeer.Create;
          Cert.m_boAnimal := True;
          Cert.m_nMeatQuality := Random(20000) + 10000;
          Cert.m_nBodyLeathery := 150;
        end
        else
        begin
          Cert := TMonster.Create;
          Cert.m_boAnimal := True;
          Cert.m_nMeatQuality := Random(8000) + 8000;
          Cert.m_nBodyLeathery := 150;
        end;
      end;
    53:
      begin
        Cert := TATMonster.Create;
        Cert.m_boAnimal := True;
        Cert.m_nMeatQuality := Random(8000) + 8000;
        Cert.m_nBodyLeathery := 150;
      end;
    RC_Escort:
      begin
        Cert := TEscortMon.Create;
        Cert.m_boAnimal := True;
      end;
    55:
      begin
        Cert := TTrainer.Create;
        Cert.m_btRaceServer := 55;
      end;
    60:
      begin
        Cert := TPlayMonster.Create;
      end;
    61:
      begin
        Cert := THeroObjectMon.Create;
      end;
    62:
      begin
        Cert := THeroObject.Create;
        Cert.m_fHeroMon := True;
        Cert.m_nInPowerLevel := MAX_IPLEVEL;
      end;

    80: Cert := TMonster.Create;
    81: Cert := TATMonster.Create;
    82: Cert := TSpitSpider.Create;
    83: Cert := TSlowATMonster.Create;
    84: Cert := TScorpion.Create;
    85: Cert := TStickMonster.Create;
    86: Cert := TATMonster.Create;
    87: Cert := TDualAxeMonster.Create;
    88: Cert := TATMonster.Create;
    89: Cert := TATMonster.Create;
    90: Cert := TGasAttackMonster.Create;
    91: Cert := TMagCowMonster.Create;
    92: Cert := TCowKingMonster.Create;
    93: Cert := TThornDarkMonster.Create;
    94: Cert := TLightingZombi.Create;
    95:
      begin
        Cert := TDigOutZombi.Create;
        if Random(2) = 0 then
          Cert.m_boSafeWalk := True;
      end;
    96:
      begin
        Cert := TZilKinZombi.Create;
        if Random(4) = 0 then
          Cert.m_boSafeWalk := True;
      end;
    97:
      begin
        Cert := TCowMonster.Create;
        if Random(2) = 0 then
          Cert.m_boSafeWalk := True;
      end;
{$IF VER_PATHMAP = 1}
    98:
      begin
        {.$I '..\Common\Macros\Registered_Start.inc'}
        Cert := TMissionMonster.Create;
        {.$I '..\Common\Macros\Registered_End.inc'}
      end;
{$IFEND}
    99: Cert := TEidolonMonster.Create;
    100: Cert := TWhiteSkeleton.Create;
    101:
      begin
        Cert := TScultureMonster.Create;
        Cert.m_boSafeWalk := True;
      end;
    102: Cert := TScultureKingMonster.Create;
    103: Cert := TBeeQueen.Create;
    104: Cert := TArcherMonster.Create;
    105: Cert := TGasMothMonster.Create;
    106: Cert := TGasDungMonster.Create;
    107: Cert := TCentipedeKingMonster.Create;
{$IF VER_PATHMAP = 1}
    108:
      begin
        {.$I '..\Common\Macros\Registered_Start.inc'}
        Cert := TMissionMonsterEx.Create;
        {.$I '..\Common\Macros\Registered_End.inc'}
      end;
{$IFEND}
    109: Cert := TArcherGuard2.Create;
    110: Cert := TCastleDoor.Create;
    111: Cert := TWallStructure.Create;
    112: Cert := TArcherGuard.Create;
    113: Cert := TElfMonster.Create;
    114: Cert := TElfWarriorMonster.Create;
    115: Cert := TBigHeartMonster.Create;
    116: Cert := TSpiderHouseMonster.Create;
    117: Cert := TExplosionSpider.Create;
    118: Cert := THighRiskSpider.Create;
    119: Cert := TBigPoisionSpider.Create;
    120: Cert := TSoccerBall.Create;
    ///////////////////////////////////////
    121: Cert := THongMoMonster.Create;
    122: Cert := TLightingCowKing.Create;
    123: Cert := TSkeletonKingMon.Create;
    124: Cert := TEldKingMon.Create;
    125: Cert := TSpiderKingMon.Create;
    126: Cert := TSnowMonster.Create;
    127: Cert := TSandWorm.Create;
    128: Cert := TMon38_5.Create;
    129: Cert := TMon38_8.Create;
    130: Cert := TDoubleCriticalMonster.Create;
    131: Cert := TRonObject.Create;
    132: Cert := TSandMobObject.Create;
    133: Cert := TMagicMonObject.Create;
    134: Cert := TBoneKingMonster.Create;
    135: Cert := TBamTreeMonster.Create;
    136: Cert := TNodeMonster.Create;
    137: Cert := TOmaKing.Create;
    138: Cert := TEvilMir.Create;
    139: Cert := TDragonStatue.Create;
    140: Cert := TTiger.Create;
    141: Cert := TDragon.Create;
    142: Cert := TRebelCommandMonster.Create;
    143: Cert := TRedThunderZuma.Create;
    144: Cert := TCrystalSpider.Create;
    145: Cert := TYimoogi.Create;
    146: Cert := TYimoogiMaster.Create;
    147: Cert := TBlackFox.Create;
    148: Cert := TDDevil.Create;
    149: Cert := TTeleMonster.Create;
    150: Cert := TKhazard.Create;
    151: Cert := TGreenMonster.Create;
    152: Cert := TRedMonster.Create;
    153: Cert := TFrostTiger.Create;
    154: Cert := TFireMonster.Create;
    155: Cert := TFireBallMonster.Create;
    156: Cert := TMinoGuard.Create;
    157: Cert := TMinotaurKing.Create;
    158: Cert := TStoneMonster.Create;
    159: Cert := TMon38_10.Create;
    160: Cert := TMon38_11.Create;

    //RC_STICKBLOCK: Cert := TStickBlockMonster.Create;
    RC_FOXWARRIOR: Cert := TFoxWarrior.Create;
    RC_FOXWIZARD: Cert := TFoxWizard.Create;
    RC_FOXTAOIST: Cert := TFoxTaoist.Create;
    RC_PUSHEDMON:
      begin
        Cert := TPushedMon.Create;
        TPushedMon(Cert).AttackWide := 1;
      end;
    RC_PUSHEDMON2:
      begin
        Cert := TPushedMon.Create;
        TPushedMon(Cert).AttackWide := 2;
      end;
    RC_FOXPILLAR: Cert := TFoxPillar.Create; //柱
    RC_FOXBEAD: Cert := TFoxBead.Create; //珠
    RC_ARCHERMASTER: Cert := TArcherMaster.Create;

    170:
      begin
        Cert := TArcherMaster.Create;
        Cert.m_boStickMode := True;
      end;

    200: Cert := TElectronicScolpionMon.Create;
    207: Cert := TFireKnightMonster.Create;
    //208: Cert := TPlayMonster.Create;
    209: Cert := TBloodKingMonster.Create;
    210:
      begin
        Cert := TPanda.Create;
        Cert.m_boAnimal := True;
      end;
  end;

  if Cert <> nil then
  begin
    //61 -> 60
    MonInitialize(Cert, sMonName);

    Cert.m_PEnvir := Map;
    Cert.m_sMapName := sMapName;
    Cert.m_nCurrX := nX;
    Cert.m_nCurrY := nY;
    Cert.m_btDirection := Random(8);
    Cert.m_sCharName := sMonName;
    Cert.m_sFCharName := FilterCharName(Cert.m_sCharName);
    Cert.m_WAbil := Cert.m_Abil;
    Cert.OnEnvirnomentChanged();
    if Random(100) < Cert.m_btCoolEye then
      Cert.m_boCoolEye := True;
    //MonGetRandomItems(Cert);

    if Cert.m_btRaceServer = RC_HERO then
    begin
      MonGetAbility(Cert);
      MonGetRandomUseItems(Cert);
    end;

    Cert.Initialize();

    if Cert.m_boErrorOnInit then
    begin
      p28 := nil;
      if Cert.m_PEnvir.m_MapHeader.wWidth < 50 then
        n20 := 2
      else
        n20 := 3;
      if (Cert.m_PEnvir.m_MapHeader.wHeight < 250) then
      begin
        if (Cert.m_PEnvir.m_MapHeader.wHeight < 30) then
          n24 := 2
        else
          n24 := 20;
      end
      else
        n24 := 50;
      n1C := 0;
      while (True) do
      begin
        if not Cert.m_PEnvir.CanWalk(Cert.m_nCurrX, Cert.m_nCurrY, False) then
        begin
          if (Cert.m_PEnvir.m_MapHeader.wWidth - n24 - 1) > Cert.m_nCurrX then
            Inc(Cert.m_nCurrX, n20)
          else
          begin
            Cert.m_nCurrX := Random(Cert.m_PEnvir.m_MapHeader.wWidth div 2) + n24;
            if Cert.m_PEnvir.m_MapHeader.wHeight - n24 - 1 > Cert.m_nCurrY then
              Inc(Cert.m_nCurrY, n20)
            else
              Cert.m_nCurrY := Random(Cert.m_PEnvir.m_MapHeader.wHeight div 2) + n24;
          end;
        end
        else
        begin
          p28 := Cert.m_PEnvir.AddToMap(Cert.m_nCurrX, Cert.m_nCurrY, OS_MOVINGOBJECT, Cert);
          Break;
        end;
        Inc(n1C);
        if n1C >= 46 then
          Break;
      end;
      if p28 = nil then
      begin
        Cert.Free;
        Cert := nil;
      end;
    end;
  end;
  Result := Cert;

  if (Result <> nil) and (Result.m_btRaceServer = RC_HERO) then
    Result.RecalcAbilitys();
end;

function TUserEngine.CreateHero(sCharName: string; MasterObj: TPlayObject; btHeroType: byte): TBaseObject;

  procedure HeroInitialize(BaseObject: TBaseObject; ObjHuman: TPlayObject);
  begin
    BaseObject.m_nCharStatus := 0;
    BaseObject.m_nCharStatusEx := 0;
    BaseObject.m_sMapName := ObjHuman.m_sMapName;
    BaseObject.m_nCurrX := ObjHuman.m_nCurrX;
    BaseObject.m_nCurrY := ObjHuman.m_nCurrY;
    BaseObject.m_btDirection := ObjHuman.m_btDirection;
    BaseObject.m_btHair := ObjHuman.m_btHair;
    BaseObject.m_btGender := ObjHuman.m_btGender;
    BaseObject.m_btJob := ObjHuman.m_btJob;
    BaseObject.m_Abil.level := ObjHuman.m_Abil.level;
    BaseObject.m_Abil.HP := ObjHuman.m_Abil.HP;
    BaseObject.m_Abil.MP := ObjHuman.m_Abil.MP;
    BaseObject.m_Abil.MaxHP := ObjHuman.m_Abil.MaxHP;
    BaseObject.m_Abil.MaxMP := ObjHuman.m_Abil.MaxMP;
    BaseObject.m_sHomeMap := ObjHuman.m_sHomeMap;
    BaseObject.m_nHomeX := ObjHuman.m_nHomeX;
    BaseObject.m_nHomeY := ObjHuman.m_nHomeY;
    if btHeroType <> 1 then
      BaseObject.m_UseItems := ObjHuman.m_UseItems;
    BaseObject.m_nCharStatus := ObjHuman.m_nCharStatus;
    BaseObject.m_btSpeedPoint := 15;
    BaseObject.m_btHitPoint := ObjHuman.m_btHitPoint;
    BaseObject.m_dwWalkWait := 0;
  end;

var
  sItem: string;
  HeroObject: TBaseObject;
  nCode, nX, nY, nCount: Integer;
  HeroPointer: Pointer;
  UserItem: pTUserItem;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::CreateHero Code=%d';
begin
  nCode := 0;
  try
    Result := nil;
    HeroObject := nil;
    case btHeroType of
      0:
        begin
          HeroObject := THeroMonster.Create;
          if HeroObject <> nil then
          begin
            HeroObject.m_sCharName := sCharName;
            HeroObject.m_sFCharName := FilterCharName(HeroObject.m_sCharName);
            HeroInitialize(HeroObject, MasterObj);
          end;
        end;
      1:
        begin
          nCode := 1;
          HeroObject := THeroObject.Create;
          if HeroObject <> nil then
          begin
            nCode := 101;
            if MasterObj.m_HeroRcd <> nil then
            begin
              GetHumData(HeroObject, MasterObj.m_HeroRcd^);
              Dispose(MasterObj.m_HeroRcd);
              MasterObj.m_HeroRcd := nil;
            end;
            nCode := 2;
            if HeroObject.m_Abil.level = 0 then
            begin
              HeroObject.m_Abil.level := 1;
              HeroObject.m_Abil.AC := 0;
              HeroObject.m_Abil.MAC := 0;
              HeroObject.m_Abil.DC := MakeLong(1, 2);
              HeroObject.m_Abil.MC := MakeLong(1, 2);
              HeroObject.m_Abil.SC := MakeLong(1, 2);
              HeroObject.m_Abil.MP := 15;
              HeroObject.m_Abil.HP := 15;
              HeroObject.m_Abil.MaxHP := 15;
              HeroObject.m_Abil.MaxMP := 15;
              HeroObject.m_Abil.Exp := 0;
              HeroObject.m_Abil.MaxExp := 100;
              HeroObject.m_Abil.Weight := 0;
              HeroObject.m_Abil.MaxWeight := 30;
              New(UserItem);
              if CopyToUserItemFromName(g_Config.sCandle, UserItem) then
                HeroObject.m_ItemList.Add(UserItem)
              else
                Dispose(UserItem);
              New(UserItem);
              if CopyToUserItemFromName(g_Config.sBasicDrug, UserItem) then
                HeroObject.m_ItemList.Add(UserItem)
              else
                Dispose(UserItem);
              New(UserItem);
              if CopyToUserItemFromName(g_Config.sWoodenSword, UserItem) then
                HeroObject.m_ItemList.Add(UserItem)
              else
                Dispose(UserItem);
              New(UserItem);
              if HeroObject.m_btGender = 0 then
                sItem := g_Config.sClothsMan
              else
                sItem := g_Config.sClothsWoman;
              if CopyToUserItemFromName(sItem, UserItem) then
                HeroObject.m_ItemList.Add(UserItem)
              else
                Dispose(UserItem);
            end;

            if HeroObject.m_Abil.HP <= 14 then
            begin
              HeroObject.ClearStatusTime();
              HeroObject.m_Abil.HP := 14;
            end;

          end;
        end;
      2: 
        begin
          HeroObject := THeroObject.Create;
          if HeroObject <> nil then
          begin
            HeroObject.m_sCharName := sCharName;
            HeroObject.m_sFCharName := FilterCharName(HeroObject.m_sCharName);
            HeroInitialize(HeroObject, MasterObj);
          end;
        end;
    end;

    if HeroObject <> nil then
    begin
      if HeroObject.m_Abil.HP = 0 then
        HeroObject.m_Abil.HP := 15;
      HeroObject.m_boCoolEye := True;
      HeroObject.m_sMapName := MasterObj.m_sMapName;
      nCode := 5;
      HeroObject.m_PEnvir := g_MapManager.FindMap(HeroObject.m_sMapName);
      if btHeroType = 2 then
      begin
        if not MasterObj.m_PEnvir.GetNextPosition(MasterObj.m_nCurrX, MasterObj.m_nCurrY, MasterObj.m_btDirection, 2 + Random(2), nX, nY) then
          MasterObj.GetFrontPosition(nX, nY);
      end
      else
        MasterObj.GetFrontPosition(nX, nY);
      nCode := 6;
      HeroObject.m_WAbil := HeroObject.m_Abil;
      HeroObject.m_dwWalkWait := 0;
      HeroObject.m_nWalkStep := 1;
      HeroObject.OnEnvirnomentChanged();
      case HeroObject.m_btJob of
        0:
          begin
            HeroObject.m_nNextHitTime := _MAX(200, g_Config.nHeroNextHitTime_Warr);
            HeroObject.m_nWalkSpeed := _MAX(200, g_Config.nHeroWalkSpeed_Warr);
          end;
        1:
          begin
            HeroObject.m_nNextHitTime := _MAX(200, g_Config.nHeroNextHitTime_Wizard);
            HeroObject.m_nWalkSpeed := _MAX(200, g_Config.nHeroWalkSpeed_Wizard);
          end;
        2:
          begin
            HeroObject.m_nNextHitTime := _MAX(200, g_Config.nHeroNextHitTime_Taos);
            HeroObject.m_nWalkSpeed := _MAX(200, g_Config.nHeroWalkSpeed_Taos);
          end;
      end;
      HeroObject.m_nNonFrzWalkSpeed := HeroObject.m_nWalkSpeed;
      HeroObject.m_nNonFrzNextHitTime := HeroObject.m_nNextHitTime;
      nCode := 7;
      HeroPointer := nil;
      nCount := 0;
      while (True) do
      begin
        nCode := 8;
        if HeroObject.m_PEnvir.CanWalk(nX, nY, False {True}) then
        begin
          //if btHeroType = 2 then begin
            //HeroObject.m_nCurrX := nX;
            //HeroObject.m_nCurrY := nY;
            //MasterObj.m_nFrontX := nX;
            //MasterObj.m_nFrontY := nY;
          //end else begin
          HeroObject.m_nCurrX := nX;
          HeroObject.m_nCurrY := nY;
          //end;
          nCode := 9;
          HeroPointer := HeroObject.m_PEnvir.AddToMap(HeroObject.m_nCurrX, HeroObject.m_nCurrY, OS_MOVINGOBJECT, HeroObject);
          Break;
        end
        else
        begin
          if nCount <= 8 then
          begin
            nX := Random(3) + (nX - 1);
            nY := Random(3) + (nY - 1);
          end
          else if nCount <= 30 then
          begin
            nX := Random(5) + (nX - 2);
            nY := Random(5) + (nY - 2);
          end
          else if nCount <= 50 then
          begin
            nX := Random(7) + (nX - 3);
            nY := Random(7) + (nY - 3);
          end
          else
          begin
            nX := Random(9) + (nX - 4);
            nY := Random(9) + (nY - 4);
          end;
        end;
        Inc(nCount);
        if nCount > 70 then
          Break;
      end;
      if HeroPointer = nil then
      begin
        nCode := 10;
        HeroObject.Free;
        HeroObject := nil;
      end;
    end;
    Result := HeroObject;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [nCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

function TUserEngine.RegenMonsters(MonGen: pTMonGenInfo; nCount: Integer): Boolean;
var
  dwStartTick: LongWord;
  nX: Integer;
  nY: Integer;
  i: Integer;
  Cert: TBaseObject;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::RegenMonsters';
begin
  Result := True;
  dwStartTick := GetTickCount();
  try
    if MonGen.nRace > 0 then
    begin
      if (MonGen.nMissionGenRate > 0) and (Random(100) < MonGen.nMissionGenRate) then
      begin
        nX := (MonGen.nX - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
        nY := (MonGen.nY - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
        for i := 0 to nCount - 1 do
        begin
          Cert := AddBaseObject(MonGen.sMapName, ((nX - 10) + Random(20)), ((nY - 10) + Random(20)), MonGen.nRace, MonGen.sMonName);
          if Cert <> nil then
          begin
            Cert.m_boCanReAlive := True;
            Cert.m_dwReAliveTick := GetTickCount;
            Cert.m_pMonGen := MonGen;
            Inc(MonGen.nActiveCount);
            MonGen.CertList.Add(Cert);
          end;
          if (GetTickCount - dwStartTick) > g_dwZenLimit then
          begin
            Result := False;
            Break;
          end;
        end;
      end
      else
      begin
        for i := 0 to nCount - 1 do
        begin
          nX := (MonGen.nX - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
          nY := (MonGen.nY - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
          Cert := AddBaseObject(MonGen.sMapName, nX, nY, MonGen.nRace, MonGen.sMonName);
          if Cert <> nil then
          begin
            Cert.m_boCanReAlive := True;
            Cert.m_dwReAliveTick := GetTickCount;
            Cert.m_pMonGen := MonGen;
            Inc(MonGen.nActiveCount);
            MonGen.CertList.Add(Cert);
          end;
          if (GetTickCount - dwStartTick) > g_dwZenLimit then
          begin
            Result := False;
            Break;
          end;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(sExceptionMsg);
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

function TUserEngine.GetPlayObjectNotGhost(sName: string): TPlayObject;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
{$IF V_TEST = 1}
    if i > 10 then
      Break;
{$IFEND V_TEST}
    if CompareText(m_PlayObjectList.Strings[i], sName) = 0 then
    begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
      if not PlayObject.m_boGhost then
      begin
        Result := PlayObject;
      end;
      Break;
    end;
  end;
end;

function TUserEngine.GetPlayObject(sName: string): TPlayObject;
begin
  Result := GetPlayObjectNotGhost(sName);
end;

function TUserEngine.GetPlayObjectCS_Name(sName: string): TPlayObject;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to m_PlayObjectList.Count - 1 do
    begin
{$IF V_TEST = 1}
      if i > 10 then
        Break;
{$IFEND V_TEST}
      if CompareText(m_PlayObjectList.Strings[i], sName) = 0 then
      begin
        PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
        if not PlayObject.m_boGhost then
        begin
          Result := PlayObject;
        end;
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TUserEngine.GetHeroObject(sName: string): THeroObject;
var
  i: Integer;
  HeroObject: THeroObject;
begin
  Result := nil;
  for i := 0 to m_HeroProcList.Count - 1 do
  begin
    HeroObject := m_HeroProcList.Items[i];
    if not HeroObject.m_boGhost and (CompareText(HeroObject.m_sCharName, sName) = 0) then
    begin
      Result := HeroObject;
      Break;
    end;
  end;
end;

function TUserEngine.GetHeroObjectCS(sName: string): THeroObject;
var
  i: Integer;
  HeroObject: THeroObject;
begin
  Result := nil;
  EnterCriticalSection(ProcessHumanCriticalSection); //0618
  try
    for i := 0 to m_HeroProcList.Count - 1 do
    begin
      HeroObject := m_HeroProcList.Items[i];
      if not HeroObject.m_boGhost and (CompareText(HeroObject.m_sCharName, sName) = 0) then
      begin
        Result := HeroObject;
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TUserEngine.GetHeroObjectCS_IdName(sID, sName: string): THeroObject;
var
  i: Integer;
  HeroObject: THeroObject;
begin
  Result := nil;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to m_HeroProcList.Count - 1 do
    begin
      HeroObject := m_HeroProcList.Items[i];
      if not HeroObject.m_boGhost and (CompareText(HeroObject.m_sCharName, sName) = 0) and (CompareText(HeroObject.m_sUserID, sID) = 0) then
      begin
        Result := HeroObject;
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TUserEngine.KickPlayer(sName: string);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  EnterCriticalSection(ProcessHumanCriticalSection); //0325
  try
    for i := 0 to m_PlayObjectList.Count - 1 do
    begin
{$IF V_TEST = 1}
      if i > 10 then
        Break;
{$IFEND V_TEST}
      if CompareText(m_PlayObjectList.Strings[i], sName) = 0 then
      begin
        PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
        PlayObject.m_boEmergencyClose := True;
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TUserEngine.GetPlayObjectCS_IDName(sName, sID: string; var boOffLine: Boolean): TPlayObject;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  boOffLine := False;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to m_PlayObjectList.Count - 1 do
    begin
{$IF V_TEST = 1}
      if i > 10 then
        Break;
{$IFEND V_TEST}
      if CompareText(m_PlayObjectList.Strings[i], sName) = 0 then
      begin
        PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
        if CompareText(PlayObject.m_sUserID, sID) = 0 then
        begin
          Result := PlayObject;
          boOffLine := PlayObject.m_boOffLineFlag;
          Break;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TUserEngine.FindMerchant(Merchant: TObject): TMerchant;
var
  i: Integer;
begin
  Result := nil;
  m_MerchantList.Lock;
  try
    for i := 0 to m_MerchantList.Count - 1 do
    begin
      if TObject(m_MerchantList.Items[i]) = Merchant then
      begin
        Result := TMerchant(m_MerchantList.Items[i]);
        Break;
      end;
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;

function TUserEngine.FindNPC(GuildOfficial: TObject): TGuildOfficial;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to QuestNPCList.Count - 1 do
  begin
    if TObject(QuestNPCList.Items[i]) = GuildOfficial then
    begin
      Result := TGuildOfficial(QuestNPCList.Items[i]);
      Break;
    end;
  end;
end;

function TUserEngine.GetMapOfRangeHumanCount(Envir: TEnvirnoment; nX, nY, nRange: Integer): Integer;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := 0;
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
{$IF V_TEST = 1}
    if i > 10 then
      Break;
{$IFEND V_TEST}
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boGhost and (PlayObject.m_PEnvir = Envir) then
    begin
      if (abs(PlayObject.m_nCurrX - nX) < nRange) and (abs(PlayObject.m_nCurrY - nY) < nRange) then
        Inc(Result);
    end;
  end;
end;

function TUserEngine.GetHumPermission(sUserName: string; var sIPaddr: string; var btPermission: byte): Boolean; //4AE590
var
  i: Integer;
  AdminInfo: pTAdminInfo;
begin
  Result := False;
  btPermission := g_Config.nStartPermission;
  m_AdminList.Lock;
  try
    for i := 0 to m_AdminList.Count - 1 do
    begin
      AdminInfo := m_AdminList.Items[i];
      if CompareText(AdminInfo.sChrName, sUserName) = 0 then
      begin
        btPermission := AdminInfo.nLv;
        sIPaddr := AdminInfo.sIPaddr;
        Result := True;
        Break;
      end;
    end;
  finally
    m_AdminList.UnLock;
  end;
end;

procedure TUserEngine.AddUserOpenInfo(UserOpenInfo: pTUserOpenInfo);
begin
  EnterCriticalSection(m_LoadPlaySection);
  try
    m_LoadPlayList.AddObject(UserOpenInfo.LoadUser.sCharName, TObject(UserOpenInfo));
    //m_dwProcessLoadPlayTick := 0;
  finally
    LeaveCriticalSection(m_LoadPlaySection);
  end;
end;

procedure TUserEngine.AddUserSaveInfo(UserSaveInfo: pTUserSaveInfo);
begin
  EnterCriticalSection(m_SavePlaySection);
  try
    m_SavePlayList.Add(UserSaveInfo);
  finally
    LeaveCriticalSection(m_SavePlaySection);
  end;
end;

procedure TUserEngine.KickOnlineUser(sChrName: string);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
{$IF V_TEST = 1}
    if i > 10 then
      Break;
{$IFEND V_TEST}
    if CompareText(m_PlayObjectList.Strings[i], sChrName) = 0 then
    begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
      PlayObject.m_boKickFlag := True;
      Break;
    end;
  end;
end;

function TUserEngine.WriteSwitchData(psui: pTSwitchDataInfo): string;
var
  flName: string;
  i, fHandle, CheckSum: Integer;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::WriteSwitchData';
begin
  Result := '';
  flName := '$_' + IntToStr(g_nServerIndex) + '_$_' + IntToStr(g_nShareFileNameNum) + '.shr';
  Inc(g_nShareFileNameNum);
  try
    CheckSum := 0;
    for i := 0 to SizeOf(TSwitchDataInfo) - 1 do
      CheckSum := CheckSum + pByte(Integer(psui) + i)^;
    fHandle := FileCreate(g_Config.sBaseDir + flName);
    if fHandle > 0 then
    begin
      FileWrite(fHandle, psui^, SizeOf(TSwitchDataInfo));
      FileWrite(fHandle, CheckSum, SizeOf(Integer));
      FileClose(fHandle);
      Result := flName;
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

function TUserEngine.SendSwitchData(PlayObject: TPlayObject; nServerIndex: Integer): Boolean;
var
  flName: string;
  swi: TSwitchDataInfo;
begin
  Result := False;
  MakeSwitchData(swi, PlayObject);
  flName := WriteSwitchData(@swi);
  if flName <> '' then
  begin
    PlayObject.m_sSwitchDataTempFile := flName;
    SendInterMsg(ISM_USERSERVERCHANGE, nServerIndex, flName);
    Result := True;
  end;
end;

procedure TUserEngine.SendChangeServer(PlayObject: TPlayObject; nServerIndex: Integer);
var
  sIPaddr: string;
  nPort: Integer;
resourcestring
  sMsg = '%s/%d';
begin
  if GetMultiServerAddrPort(nServerIndex, sIPaddr, nPort) then
  begin
    PlayObject.m_boReconnection := True;
    PlayObject.SendDefMessage(SM_RECONNECT, 0, 0, 0, 0, Format(sMsg, [sIPaddr, nPort]));
  end;
end;

procedure TUserEngine.SaveHumanRcd(PlayObject: TPlayObject; sHeroName: string; sJob: string; sSex: string; HeroEx: Boolean);
var
  SaveRcd: pTSaveRcd;
begin
  if sHeroName <> '' then
  begin
    New(SaveRcd);
    FillChar(SaveRcd^, SizeOf(TSaveRcd), #0);
    SaveRcd.sAccount := PlayObject.m_sUserID;
    if HeroEx then
      SaveRcd.nHeroFlag := -3
    else
      SaveRcd.nHeroFlag := -1;
    SaveRcd.sChrName := sHeroName;
    SaveRcd.sMasterName := PlayObject.m_sCharName;
    SaveRcd.HumanRcd.Data.sChrName := sHeroName;
    SaveRcd.HumanRcd.Data.sAccount := PlayObject.m_sUserID;
    SaveRcd.HumanRcd.Data.sHeroMasterName := PlayObject.m_sCharName;
    SaveRcd.HumanRcd.Data.btHair := 1 + Random(5);
    SaveRcd.HumanRcd.Data.btJob := Str_ToInt(sJob, 0);
    SaveRcd.HumanRcd.Data.btSex := Str_ToInt(sSex, 0);
    SaveRcd.HumanRcd.Data.sCurMap := PlayObject.m_sMapName;
    SaveRcd.HumanRcd.Data.wCurX := PlayObject.m_nCurrX;
    SaveRcd.HumanRcd.Data.wCurY := PlayObject.m_nCurrY;
    SaveRcd.HumanRcd.Data.btDir := PlayObject.m_btDirection;
    SaveRcd.HumanRcd.Data.sHomeMap := PlayObject.m_sHomeMap;
    SaveRcd.HumanRcd.Data.wHomeX := PlayObject.m_nHomeX;
    SaveRcd.HumanRcd.Data.wHomeY := PlayObject.m_nHomeY;
    SaveRcd.nSessionID := PlayObject.m_nSessionID;
    //SaveRcd.PlayObject := PlayObject;
    FrontEngine.AddToSaveRcdList(SaveRcd);
  end
  else
  begin
    New(SaveRcd);
    FillChar(SaveRcd^, SizeOf(TSaveRcd), #0);
    SaveRcd.sAccount := PlayObject.m_sUserID;
    SaveRcd.nHeroFlag := -2;
    SaveRcd.sChrName := PlayObject.m_sCharName;
    PlayObject.MakeSaveRcd(SaveRcd.HumanRcd);
    SaveRcd.nSessionID := PlayObject.m_nSessionID;
    //SaveRcd.PlayObject := PlayObject;
    FrontEngine.AddToSaveRcdList(SaveRcd {, True}); //0720
  end;
end;

procedure TUserEngine.AddToHumanFreeList(PlayObject: TPlayObject);
begin
  PlayObject.m_dwGhostTick := GetTickCount();
  m_PlayObjectFreeList.Add(PlayObject);
end;

procedure TUserEngine.GetHumData(PlayObject: TBaseObject; {var} HumanRcd: THumDataInfo);
var
  i: Integer;
  mIdx, mStep: Word;
  HumData: pTHumData;
  //HumAddItems               : pTHumAddItems;
  BagItems: pTBagItems;
  UserItem: pTUserItem;
  HumMagic: pTHumMagic;
  UserMagic: pTUserMagic;
  MagicInfo: pTMagic;
  StorageItems: pTStorageItems;
  sUserID: string;
begin
  HumData := @HumanRcd.Data;
  PlayObject.m_sCharName := HumData.sChrName;
  PlayObject.m_sFCharName := FilterCharName(PlayObject.m_sCharName);
  PlayObject.m_sMapName := HumData.sCurMap;
  PlayObject.m_nCurrX := HumData.wCurX;
  PlayObject.m_nCurrY := HumData.wCurY;
  PlayObject.m_btDirection := HumData.btDir;
  PlayObject.m_btHair := HumData.btHair;

  PlayObject.m_btGender := HumData.btSex;
  PlayObject.m_btJob := HumData.btJob;
  //if not (PlayObject.m_btGender in [0, 1]) then PlayObject.m_btGender := 0;
  //if not (PlayObject.m_btJob in [0..2]) then PlayObject.m_btJob := 0;

  PlayObject.m_nGold := HumData.nGold;
  (PlayObject as TPlayObject).m_dwGatherNimbus := HumData.dwGatherNimbus;

  PlayObject.m_Abil.level := HumData.Abil.level;
{$IF HIGHHP}
  PlayObject.m_Abil.HP := Dword(MakeLong(HumData.Abil.HP, HumData.Abil.AC));
  PlayObject.m_Abil.MP := Dword(MakeLong(HumData.Abil.MP, HumData.Abil.MAC));
  PlayObject.m_Abil.MaxHP := Dword(MakeLong(HumData.Abil.MaxHP, HumData.Abil.DC));
  PlayObject.m_Abil.MaxMP := Dword(MakeLong(HumData.Abil.MaxMP, HumData.Abil.MC));
{$ELSE}
  PlayObject.m_Abil.HP := HumData.Abil.HP;
  PlayObject.m_Abil.MP := HumData.Abil.MP;
  PlayObject.m_Abil.MaxHP := HumData.Abil.MaxHP;
  PlayObject.m_Abil.MaxMP := HumData.Abil.MaxMP;
{$IFEND}
  PlayObject.m_Abil.Exp := HumData.Abil.Exp;
  PlayObject.m_Abil.MaxExp := HumData.Abil.MaxExp;
  PlayObject.m_Abil.Weight := HumData.Abil.Weight;
  PlayObject.m_Abil.MaxWeight := HumData.Abil.MaxWeight;
  PlayObject.m_Abil.WearWeight := HumData.Abil.WearWeight;
  PlayObject.m_Abil.MaxWearWeight := HumData.Abil.MaxWearWeight;
  PlayObject.m_Abil.HandWeight := HumData.Abil.HandWeight;
  PlayObject.m_Abil.MaxHandWeight := HumData.Abil.MaxHandWeight;

  PlayObject.m_nGameDiamond := HumData.Abil.Diamond; //New
  PlayObject.m_nGameGird := HumData.Abil.Gird; //New
  PlayObject.m_btPostSell := HumData.btOptnYBDeal; //New

  PlayObject.m_btMedusaEyeAttack := HumData.btMedusaEyeAttack;
  PlayObject.m_wStatusTimeArr := HumData.wStatusTimeArr;
  PlayObject.m_wStatusTimeArrEx := HumData.wStatusTimeArrEx;
  PlayObject.m_boShowFashion := HumData.boShowFashion;

  PlayObject.m_btActiveTitle := HumData.btActiveTitle;
  // PlayObject.m_Titles := HumData.HumTitles;
  Move(HumData.HumTitles[0], PlayObject.m_Titles[0], Sizeof(THumTitles));
  PlayObject.m_sHomeMap := HumData.sHomeMap;
  PlayObject.m_nHomeX := HumData.wHomeX;
  PlayObject.m_nHomeY := HumData.wHomeY;

  (PlayObject as TPlayObject).m_BonusAbil := HumData.BonusAbil;
  (PlayObject as TPlayObject).m_nBonusPoint := HumData.nBonusPoint;
  PlayObject.m_btCreditPoint := HumData.btCreditPoint;
  PlayObject.m_btReLevel := HumData.btReLevel;

  PlayObject.m_sMasterName := HumData.sMasterName;
  PlayObject.m_boMaster := HumData.boMaster;
  PlayObject.m_sDearName := HumData.sDearName;

  PlayObject.m_sStoragePwd := HumData.sStoragePwd;
  if PlayObject.m_sStoragePwd <> '' then PlayObject.m_boPasswordLocked := True;

  if g_Config.boSaveKillMonExpRate then
  begin
    if (HumData.nKillMonExpRate > 0) and (HumData.dwKillMonExpRateTime > 0) then
    begin
      PlayObject.m_nKillMonExpRate := HumData.nKillMonExpRate;
      PlayObject.m_dwKillMonExpRateTime := HumData.dwKillMonExpRateTime;
    end;
  end;

  PlayObject.m_sHeroName := HumData.sHeroName;
  PlayObject.m_sHeroMasterName := HumData.sHeroMasterName;
  PlayObject.m_nGameGold := HumData.nGameGold;
  PlayObject.m_nGamePoint := HumData.nGamePoint;
  PlayObject.m_nPayMentPoint := HumData.nPayMentPoint;
  PlayObject.m_nPkPoint := HumData.nPKPOINT;
  if HumData.btAllowGroup > 0 then
    (PlayObject as TPlayObject).m_boAllowGroup := True
  else
    (PlayObject as TPlayObject).m_boAllowGroup := False;
  PlayObject.m_btClPkPoint := HumData.btClPkPoint;
  PlayObject.m_btAttatckMode := HumData.btAttatckMode;
  PlayObject.m_nIncHealth := HumData.btIncHealth;
  PlayObject.m_nIncSpell := HumData.btIncSpell;
  PlayObject.m_nIncHealing := HumData.btIncHealing;
  PlayObject.m_nFightZoneDieCount := HumData.btFightZoneDieCount;
  PlayObject.m_sUserID := HumData.sAccount;
  sUserID := PlayObject.m_sUserID;
  (PlayObject as TPlayObject).m_dwIdCRC := CRC32(Pointer(sUserID), Length(sUserID) * SizeOf(Char), 0);

  PlayObject.m_btNewHuman := HumData.btNewHuman;
  PlayObject.m_boLockLogon := HumData.boLockLogon;
  PlayObject.m_nInPowerLevel := HumData.btInPowerLevel;
  PlayObject.m_nInPowerPoint := HumData.wInPowerPoint;
  PlayObject.m_dwInPowerExp := HumData.dwInPowerExp;
  PlayObject.m_btAttribute := HumData.btAttribute;

  (PlayObject as TPlayObject).m_nHungerStatus := HumData.nHungerStatus;
  (PlayObject as TPlayObject).m_boAllowGuildReCall := HumData.boAllowGuildReCall;
  (PlayObject as TPlayObject).m_wGroupRcallTime := HumData.wGroupRcallTime;
  PlayObject.m_dBodyLuck := HumData.dBodyLuck;
  if PlayObject.m_dBodyLuck > 5 * BODYLUCKUNIT then
    PlayObject.m_dBodyLuck := 5 * BODYLUCKUNIT;
  (PlayObject as TPlayObject).m_boAllowGroupReCall := HumData.boAllowGroupReCall;
  (PlayObject as TPlayObject).m_sMarkerMap := HumData.sMarkerMap;
  (PlayObject as TPlayObject).m_wMarkerX := HumData.wMarkerX;
  (PlayObject as TPlayObject).m_wMarkerY := HumData.wMarkerY;
  (PlayObject as TPlayObject).m_QuestUnitOpen := HumData.QuestUnitOpen;
  (PlayObject as TPlayObject).m_QuestUnit := HumData.QuestUnit;
  (PlayObject as TPlayObject).m_QuestFlag := HumData.QuestFlag;

  PlayObject.m_btSPLuck := HumData.btSPLuck;
  PlayObject.m_btSPEnergy := HumData.btSPEnergy;

  //HumItems := @HumanRcd.Data.HumItems;
  for i := Low(THumanUseItems) to High(THumanUseItems) do
  begin
    if HumanRcd.Data.HumItems[i].wIndex > 0 then
      Move(HumanRcd.Data.HumItems[i], PlayObject.m_UseItems[i], SizeOf(TUserItem));
  end;
  //for i := Low(THumAddItems) to High(THumAddItems) do begin
  //  if HumanRcd.Data.HumItems[i].wIndex > 0 then
  //    Move(HumanRcd.Data.HumAddItems[i], PlayObject.m_UseItems[i], SizeOf(TUserItem));
  //end;

  BagItems := @HumanRcd.Data.BagItems;
  for i := Low(TBagItems) to High(TBagItems) do
  begin
    if BagItems[i].wIndex > 0 then
    begin
      New(UserItem);
      UserItem^ := BagItems[i];
      PlayObject.m_ItemList.Add(UserItem);
    end;
  end;

  HumMagic := @HumanRcd.Data.Magic;
  for i := Low(THumMagic) to High(THumMagic) do
  begin
    if HumMagic[i].wMagIdx <= 0 then
      Continue;
    if PlayObject.m_btRaceServer = RC_HERO then //0424
      MagicInfo := UserEngine.FindMagic(HumMagic[i].wMagIdx, HumMagic[i].btClass, True)
    else
      MagicInfo := UserEngine.FindMagic(HumMagic[i].wMagIdx, HumMagic[i].btClass);
    if MagicInfo <> nil then
    begin
      New(UserMagic);
      UserMagic.MagicInfo := MagicInfo;
      UserMagic.wMagIdx := HumMagic[i].wMagIdx;
      UserMagic.btLevel := HumMagic[i].btLevel;
      UserMagic.btKey := HumMagic[i].btKey;
      UserMagic.nTranPoint := HumMagic[i].nTranPoint;
      PlayObject.m_MagicList.Add(UserMagic);
    end;
  end;

  StorageItems := @HumanRcd.Data.StorageItems;
  for i := Low(TStorageItems) to High(TStorageItems) do
  begin
    if StorageItems[i].wIndex > 0 then
    begin
      New(UserItem);
      UserItem^ := StorageItems[i];
      PlayObject.m_StorageItemList.Add(UserItem);
    end;
  end;

  if g_Config.boUseCustomData and (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    TPlayObject(PlayObject).LoadHumanCustomData();
    {for i := Low(TStorageItemsEx) to High(TStorageItemsEx) do begin
      if CustomData.StorageItems[i].wIndex > 0 then begin
        New(UserItem);
        UserItem^ := CustomData.StorageItems[i];
        PlayObject.m_StorageItemList.Add(UserItem);
      end;
    end;}
  end;
{$IF SERIESSKILL}
  //if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) or PlayObject.IsHero then begin
  TPlayObject(PlayObject).m_SeriesSkillArr := HumData.SeriesSkillArr;
  TPlayObject(PlayObject).m_VenationInfos := HumData.VenationInfos;
  //end;
{$IFEND SERIESSKILL}
  if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    for i := 0 to MAXMISSION - 1 do
    begin
      mIdx := HumData.MissionFlag[i].idx;
      mStep := HumData.MissionFlag[i].step;
      if (mIdx > 0) and (mStep > 0) then
        TPlayObject(PlayObject).m_MissionList.AddObject(IntToStr(mIdx), TObject(mStep));
    end;
  end;
end;

function TUserEngine.GetHomeInfo(var nX, nY: Integer): string;
var
  i: Integer;
  StartPointInfo: pTStartPointInfo;
begin
  if g_StartPointManager.m_InfoList.Count > 0 then
  begin
    if g_StartPointManager.m_InfoList.Count > g_Config.nStartPointSize then
      i := Random(g_Config.nStartPointSize)
    else
      i := 0;
    StartPointInfo := g_StartPointManager.m_InfoList.Items[i];
    Result := StartPointInfo.sMapName;
    nX := StartPointInfo.nX;
    nY := StartPointInfo.nY;
  end
  else
  begin
    Result := g_Config.sHomeMap;
    nX := g_Config.nHomeX;
    nY := g_Config.nHomeY;
  end;
end;

function TUserEngine.GetRandHomeX(PlayObject: TPlayObject): Integer;
begin
  Result := Random(3) + (PlayObject.m_nHomeX - 2);
end;

function TUserEngine.GetRandHomeY(PlayObject: TPlayObject): Integer;
begin
  Result := Random(3) + (PlayObject.m_nHomeY - 2);
end;

procedure TUserEngine.MakeSwitchData(var SwitchData: TSwitchDataInfo; PlayObject: TPlayObject);
var
  i: Integer;
  BaseObject: TBaseObject;
begin
  FillChar(SwitchData, SizeOf(TSwitchDataInfo), #0);

  SwitchData.sChrName := PlayObject.m_sCharName;
  SwitchData.sMAP := PlayObject.m_sMapName;
  SwitchData.wX := PlayObject.m_nCurrX;
  SwitchData.wY := PlayObject.m_nCurrY;
{$IF VER_ClientType_45}
  SwitchData.wClitntType := PlayObject.m_wClientType;
  SwitchData.nClientTick := PlayObject.m_dwClientTick;
{$IFEND VER_ClientType_45}
  SwitchData.nClientVerNO := PlayObject.m_nClientVerNO;
  if PlayObject.m_HeroObject <> nil then
    SwitchData.boRecallHero := True;

  SwitchData.Abil := PlayObject.m_Abil;
  SwitchData.nCode := PlayObject.m_nSessionID;
  SwitchData.boBanShout := PlayObject.m_boBanShout;
  SwitchData.boHearWhisper := PlayObject.m_boHearWhisper;
  SwitchData.boBanGuildChat := PlayObject.m_boBanGuildChat;
  SwitchData.boBanGuildChat := PlayObject.m_boBanGuildChat;
  SwitchData.boAdminMode := PlayObject.m_boAdminMode;
  SwitchData.boObMode := PlayObject.m_boObMode;

  for i := 0 to PlayObject.m_BlockWhisperList.Count - 1 do
    if i <= High(SwitchData.BlockWhisperArr) - 1 then
      SwitchData.BlockWhisperArr[i] := PlayObject.m_BlockWhisperList[i];

  for i := 0 to PlayObject.m_SlaveList.Count - 1 do
  begin
    BaseObject := PlayObject.m_SlaveList[i];
    if i <= 4 then
    begin
      SwitchData.SlaveArr[i].sSalveName := BaseObject.m_sCharName;
      SwitchData.SlaveArr[i].nKillCount := BaseObject.m_nKillMonCount;
      SwitchData.SlaveArr[i].btSalveLevel := BaseObject.m_btSlaveMakeLevel;
      SwitchData.SlaveArr[i].btSlaveExpLevel := BaseObject.m_btSlaveExpLevel;
      SwitchData.SlaveArr[i].dwRoyaltySec := (BaseObject.m_dwMasterRoyaltyTick - GetTickCount) div 1000;
      SwitchData.SlaveArr[i].nHP := BaseObject.m_WAbil.HP;
      SwitchData.SlaveArr[i].nMP := BaseObject.m_WAbil.MP;
    end;
  end;

  for i := Low(PlayObject.m_wStatusArrValue) to High(PlayObject.m_wStatusArrValue) do
  begin
    if PlayObject.m_wStatusArrValue[i] > 0 then
    begin
      SwitchData.StatusValue[i] := PlayObject.m_wStatusArrValue[i];
      SwitchData.StatusTimeOut[i] := PlayObject.m_dwStatusArrTimeOutTick[i];
    end;
  end;
end;

procedure TUserEngine.LoadSwitchData(SwitchData: pTSwitchDataInfo; PlayObject: TPlayObject);
var
  i: Integer;
  SlaveInfo: pTSlaveInfo;
begin

  PlayObject.m_boBanShout := SwitchData.boBanShout;
  PlayObject.m_boHearWhisper := SwitchData.boHearWhisper;
  PlayObject.m_boBanGuildChat := SwitchData.boBanGuildChat;
  PlayObject.m_boBanGuildChat := SwitchData.boBanGuildChat;
  PlayObject.m_boAdminMode := SwitchData.boAdminMode;
  PlayObject.m_boObMode := SwitchData.boObMode;
{$IF VER_ClientType_45}
  PlayObject.m_wClientType := SwitchData.wClitntType;
  PlayObject.m_dwClientTick := SwitchData.nClientTick;
{$IFEND VER_ClientType_45}
  PlayObject.m_nClientVerNO := SwitchData.nClientVerNO;
  PlayObject.m_boChgRecallHero := SwitchData.boRecallHero;

  for i := Low(SwitchData.SlaveArr) to High(SwitchData.SlaveArr) do
    if SwitchData.SlaveArr[i].sSalveName <> '' then
    begin
      New(SlaveInfo);
      SlaveInfo^ := SwitchData.SlaveArr[i];
      if PlayObject.m_ChgSlaveList = nil then
        PlayObject.m_ChgSlaveList := TList.Create;
      PlayObject.m_ChgSlaveList.Add(SlaveInfo);
    end;

  //PlayObject.m_aSlaveArr := SwitchData.SlaveArr;

  for i := Low(SwitchData.BlockWhisperArr) to High(SwitchData.BlockWhisperArr) do
    if SwitchData.BlockWhisperArr[i] <> '' then
      PlayObject.m_BlockWhisperList.Add(SwitchData.BlockWhisperArr[i]);

  for i := Low(SwitchData.StatusValue) to High(SwitchData.StatusValue) do
  begin
    PlayObject.m_wStatusArrValue[i] := SwitchData.StatusValue[i];
    PlayObject.m_dwStatusArrTimeOutTick[i] := SwitchData.StatusTimeOut[i];
  end;
end;

function TUserEngine.FindMagic(nMagIdx: Integer; btClass: byte; boIshero: Boolean): pTMagic;
var
  i: Integer;
  Magic: pTMagic;
begin
  Result := nil;
  for i := 0 to m_MagicList.Count - 1 do
  begin
    Magic := m_MagicList.Items[i];
    if (Magic.wMagicId = nMagIdx) and (Magic.btClass = btClass) then
    begin
      if btClass = 0 then
      begin
        if boIshero then
        begin
          if CompareText(Magic.sDescr, g_sHeroName) = 0 then
          begin
            Result := Magic;
            Break;
          end;
        end
        else
        begin
          Result := Magic;
          Break;
        end;
      end
      else
      begin
        Result := Magic;
        Break;
      end;
    end;
  end;
end;

procedure TUserEngine.MonInitialize(BaseObject: TBaseObject; sMonName: string);
var
  Monster: pTMonInfo;
begin
{$IF USEHASHLIST = 1}
  Monster := pTMonInfo(MonsterList.GetValues(sMonName));
  if Monster <> nil then
  begin
{$ELSE}
    for i := 0 to MonsterList.Count - 1 do
    begin
      Monster := MonsterList.Items[i];
      if CompareText(Monster.sName, sMonName) = 0 then
      begin
{$IFEND}
        BaseObject.m_btRaceServer := Monster.btRace;
        if BaseObject.m_btRaceServer in [61, 62] then
          BaseObject.m_btRaceServer := 60;
        BaseObject.m_btRaceImg := Monster.btRaceImg;
        BaseObject.m_wAppr := Monster.wAppr;
        BaseObject.m_Abil.level := Monster.wLevel;
        BaseObject.m_btLifeAttrib := Monster.btLifeAttrib;
        BaseObject.m_boExplore := (Monster.btExplore <> 0);
        if BaseObject.m_boExplore then
        begin
          BaseObject.m_nPerBodyLeathery := 20;
          BaseObject.m_nBodyLeathery := 20;
        end;
        BaseObject.m_btCoolEye := Monster.wCoolEye;
        BaseObject.m_dwFightExp := Monster.dwExp;
        BaseObject.m_dwFightIPExp := Monster.dwIPExp;
        BaseObject.m_nInPowerLevel := Monster.wInLevel;
        if BaseObject.m_fHeroMon then
          BaseObject.m_nInPowerLevel := MAX_IPLEVEL;
        BaseObject.m_Abil.HP := Monster.wHP;
        BaseObject.m_Abil.MaxHP := Monster.wHP;
        BaseObject.m_btMonsterWeapon := LoByte(Monster.wMP);
        BaseObject.m_Abil.MP := Monster.wMP;
        BaseObject.m_nMaxDamageHealth := Monster.wMP;
        BaseObject.m_Abil.MaxMP := Monster.wMP;
        BaseObject.m_Abil.AC := MakeLong(Monster.wAC, Monster.wAC);
        BaseObject.m_Abil.MAC := MakeLong(Monster.wMAC, Monster.wMAC);
        BaseObject.m_Abil.DC := MakeLong(Monster.wDC, Monster.wMaxDC);
        BaseObject.m_Abil.MC := MakeLong(Monster.wMC, Monster.wMC);
        BaseObject.m_Abil.SC := MakeLong(Monster.wSC, Monster.wSC);
        BaseObject.m_btSpeedPoint := Monster.wSpeed;
        BaseObject.m_btHitPoint := Monster.wHitPoint;
        BaseObject.m_nWalkSpeed := Monster.wWalkSpeed;
        BaseObject.m_nWalkStep := Monster.wWalkStep;
        BaseObject.m_dwWalkWait := Monster.wWalkWait;
        BaseObject.m_nNextHitTime := Monster.wAttackSpeed;
        BaseObject.m_nNonFrzWalkSpeed := BaseObject.m_nWalkSpeed;
        BaseObject.m_nNonFrzNextHitTime := BaseObject.m_nNextHitTime;

        BaseObject.m_spMonAbil := Monster.spMonAbil;

        with BaseObject do
        begin
          if m_spMonAbil.btIgnoreTagDefence > 0 then //忽视
            m_btIgnoreTagDefence := _MIN(100, m_btIgnoreTagDefence + m_spMonAbil.btIgnoreTagDefence);

          if m_spMonAbil.btDamageAddOn > 0 then //增伤
            m_btDamageAddOn := _MIN(High(byte), m_btDamageAddOn + m_spMonAbil.btDamageAddOn);

          if m_spMonAbil.btDamageRebound > 0 then //反射
            m_btDamageRebound := _MIN(100, m_btDamageRebound + m_spMonAbil.btDamageRebound);

          if m_spMonAbil.btACDamageReduction > 0 then //物减
            m_btACDamageReduction := _MIN(100, m_btACDamageReduction + m_spMonAbil.btACDamageReduction);

          if m_spMonAbil.btMCDamageReduction > 0 then //魔减
            m_btMCDamageReduction := _MIN(100, m_btMCDamageReduction + m_spMonAbil.btMCDamageReduction);

          if m_spMonAbil.boMonParalysis then
            m_boParalysis := True;
          if m_spMonAbil.boMonUnParalysis then
            m_boUnParalysis := True;
          if m_spMonAbil.boMonUnAllParalysis then
            m_boUnAllParalysis := True;
          if m_spMonAbil.boMonUnRevival then
            m_boUnRevival := True;
          if m_spMonAbil.boMonUnMagicShield then
            m_boUnMagicShield := True;
        end;

{$IF USEHASHLIST = 1}
      end;
{$ELSE}
      Break;
    end;
  end;
{$IFEND}
end;

function TUserEngine.OpenDoor(Envir: TEnvirnoment; nX, nY: Integer): Boolean; //004AC698
var
  Door: pTDoorInfo;
begin
  Result := False;
  Door := Envir.GetDoor(nX, nY);
  if (Door <> nil) and not Door.Status.boOpened {and not Door.Status.bo01} then
  begin
    Door.Status.boOpened := True;
    Door.Status.dwOpenTick := GetTickCount();
    SendDoorStatus(Envir, nX, nY, RM_DOOROPEN, 0, nX, nY, 0, '');
    Result := True;
  end;
end;

function TUserEngine.CloseDoor(Envir: TEnvirnoment; Door: pTDoorInfo): Boolean; //004AC77B
begin
  Result := False;
  if (Door <> nil) and (Door.Status.boOpened) then
  begin
    Door.Status.boOpened := False;
    SendDoorStatus(Envir, Door.nX, Door.nY, RM_DOORCLOSE, 0, Door.nX, Door.nY, 0, '');
    Result := True;
  end;
end;

procedure TUserEngine.SendDoorStatus(Envir: TEnvirnoment; nX, nY: Integer; wIdent, wX: Word; nDoorX, nDoorY, nA: Integer; sStr: string); //004AC518
var
  i: Integer;
  n10, n14: Integer;
  n1C, n20, n24, n28: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  //pListNode                 : pTWhnode;
begin
  n1C := nX - 12;
  n24 := nX + 12;
  n20 := nY - 12;
  n28 := nY + 12;
  for n10 := n1C to n24 do
  begin
    for n14 := n20 to n28 do
    begin
      if Envir.GetMapCellInfo(n10, n14, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
      begin
        for i := 0 to MapCellInfo.ObjList.Count - 1 do
        begin
          OSObject := MapCellInfo.ObjList.Items[i];
          if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
          begin
            BaseObject := TBaseObject(OSObject.CellObj);
            if (BaseObject <> nil) and
              (not BaseObject.m_boGhost) and
              (BaseObject.m_btRaceServer = RC_PLAYOBJECT) and
              not TPlayObject(BaseObject).m_boOffLineFlag then
            begin
              BaseObject.SendMsg(BaseObject, wIdent, wX, nDoorX, nDoorY, nA, sStr);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TUserEngine.ProcessMapDoor;
var
  i: Integer;
  ii: Integer;
  Envir: TEnvirnoment;
  Door: pTDoorInfo;
begin
  for i := 0 to g_MapManager.Count - 1 do
  begin
{$IF USEHASHLIST = 1}
    //Envir := TEnvirnoment(g_MapManager.Objects[i]);
    Envir := TEnvirnoment(g_MapManager.GetValues(g_MapManager.Keys[i]));
{$ELSE}
    Envir := TEnvirnoment(g_MapManager[i]);
{$IFEND}
    for ii := 0 to Envir.m_DoorList.Count - 1 do
    begin
      Door := Envir.m_DoorList.Items[ii];
      if Door.Status.boOpened then
      begin
        if (GetTickCount - Door.Status.dwOpenTick) > 5 * 1000 then
          CloseDoor(Envir, Door);
      end;
    end;
  end;
end;

procedure TUserEngine.ProcessEffects;
var
  i, ii, n, m, x, y, c, d: Integer;
  Envir: TEnvirnoment;
begin
  for i := 0 to m_MapEffectList.Count - 1 do
  begin
    Envir := TEnvirnoment(m_MapEffectList.Items[i]);
    if Envir = nil then
      Continue;
    c := GetMapHumanCount(Envir) * 2;
    if c > 0 then
    begin
      //d := c * _MAX(1, (Envir.m_MapHeader.wWidth * Envir.m_MapHeader.wHeight div 1600));
      d := 2 * _MAX(1, (Envir.m_MapHeader.wWidth * Envir.m_MapHeader.wHeight div 2500));
      m := 0;
      for ii := 1 to d do
      begin
        x := Random(Envir.m_MapHeader.wWidth);
        y := Random(Envir.m_MapHeader.wHeight);
        n := 0;
        while (True) do
        begin
          if Envir.CanWalk(x, y, True) then
          begin
            if EffectTarget(x, y, Envir) then
              Inc(m);
            Break;
          end;
          x := Random(Envir.m_MapHeader.wWidth);
          y := Random(Envir.m_MapHeader.wHeight);
          Inc(n);
          if n >= 10 then
            Break;
        end;
        if m >= c then
          Break;
      end;
    end;
  end;
end;

procedure TUserEngine.ProcessEvents();
var
  i, ii, III: Integer;
  MagicEvent: pTMagicEvent;
  BaseObject: TBaseObject;
  Event: TEvent;
begin
  for i := m_MagicEventList.Count - 1 downto 0 do
  begin
    MagicEvent := m_MagicEventList[i];
    if MagicEvent <> nil then
    begin
      for ii := MagicEvent.BaseObjectList.Count - 1 downto 0 do
      begin
        BaseObject := TBaseObject(MagicEvent.BaseObjectList.Items[ii]);
        if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (not BaseObject.m_boHolySeize) then
          MagicEvent.BaseObjectList.Delete(ii);
      end;
      if (MagicEvent.BaseObjectList.Count <= 0) or ((GetTickCount - MagicEvent.dwStartTick) > MagicEvent.dwTime) or ((GetTickCount - MagicEvent.dwStartTick) > 180000) then
      begin
        MagicEvent.BaseObjectList.Free;
        III := 0;
        while (True) do
        begin
          if MagicEvent.Events[III] <> nil then
          begin
            TEvent(MagicEvent.Events[III]).Close();
            m_MagicEventCloseList.Add(MagicEvent.Events[III]);
          end;
          Inc(III);
          if III >= 8 then
            Break;
        end;
        Dispose(MagicEvent);
        MagicEvent := nil;
        m_MagicEventList.Delete(i);
      end;
    end;
  end;

  for i := m_MagicEventCloseList.Count - 1 downto 0 do
  begin
    Event := TEvent(m_MagicEventCloseList[i]);
    if Event.m_boClosed and (GetTickCount - Event.m_dwCloseTick > 5 * 60 * 1000) then
    begin
      m_MagicEventCloseList.Delete(i);
      Event.Free;
    end;
  end;

end;

function TUserEngine.FindMagic(sMagicName: string): pTMagic;
var
  i: Integer;
  Magic: pTMagic;
begin
  Result := nil;
  for i := 0 to m_MagicList.Count - 1 do
  begin
    Magic := m_MagicList.Items[i];
    if CompareText(Magic.sMagicName, sMagicName) = 0 then
    begin
      Result := Magic;
      Break;
    end;
  end;
end;

function TUserEngine.GetMapRangeMonster(Envir: TEnvirnoment; nX, nY, nRange: Integer; List: TList): Integer;
var
  i, ii: Integer;
  MonGen: pTMonGenInfo;
  BaseObject: TBaseObject;
begin
  Result := 0;
  if Envir = nil then
    Exit;
  for i := 0 to m_MonGenList.Count - 1 do
  begin
    MonGen := m_MonGenList.Items[i];
    if (MonGen = nil) or (MonGen.Envir <> Envir) then
      Continue;
    for ii := 0 to MonGen.CertList.Count - 1 do
    begin
      BaseObject := TBaseObject(MonGen.CertList.Items[ii]);
      if not BaseObject.m_boDeath and not BaseObject.m_boGhost and
        (BaseObject.m_PEnvir = Envir) and (abs(BaseObject.m_nCurrX - nX) <= nRange)
        and (abs(BaseObject.m_nCurrY - nY) <= nRange) then
      begin
        if List <> nil then
          List.Add(BaseObject);
        Inc(Result);
      end;
    end;
  end;
end;

procedure TUserEngine.AddMerchant(Merchant: TMerchant);
begin
  m_MerchantList.Lock;
  try
    m_MerchantList.Add(Merchant);
  finally
    m_MerchantList.UnLock;
  end;
end;

procedure TUserEngine.AddHero(Hero: THeroObject);
begin
  //m_HeroProcList.Lock;
  //try
  m_HeroProcList.Add(Hero);
  //finally
  //  m_HeroProcList.UnLock;
  //end;
end;

function TUserEngine.GetMerchantList(Envir: TEnvirnoment; nX, nY, nRange: Integer; TmpList: TList): Integer; //004ACB84
var
  i: Integer;
  Merchant: TMerchant;
begin
  m_MerchantList.Lock;
  try
    for i := 0 to m_MerchantList.Count - 1 do
    begin
      Merchant := TMerchant(m_MerchantList.Items[i]);
      if (Merchant.m_PEnvir = Envir) and
        (abs(Merchant.m_nCurrX - nX) <= nRange) and
        (abs(Merchant.m_nCurrY - nY) <= nRange) then
      begin
        TmpList.Add(Merchant);
      end;
    end;
  finally
    m_MerchantList.UnLock;
  end;
  Result := TmpList.Count
end;

function TUserEngine.GetNpcList(Envir: TEnvirnoment; nX, nY, nRange: Integer; TmpList: TList): Integer;
var
  i: Integer;
  NPC: TNormNpc;
begin
  for i := 0 to QuestNPCList.Count - 1 do
  begin
    NPC := TNormNpc(QuestNPCList.Items[i]);
    if (NPC.m_PEnvir = Envir) and
      (abs(NPC.m_nCurrX - nX) <= nRange) and
      (abs(NPC.m_nCurrY - nY) <= nRange) then
    begin
      TmpList.Add(NPC);
    end;
  end;
  Result := TmpList.Count
end;

procedure TUserEngine.ReloadMerchantList();
var
  i: Integer;
  Merchant: TMerchant;
begin
  m_MerchantList.Lock;
  try
    for i := 0 to m_MerchantList.Count - 1 do
    begin
      Merchant := TMerchant(m_MerchantList.Items[i]);
      if not Merchant.m_boGhost and not Merchant.m_boIsHide then
      begin //By Blue
        Merchant.ClearScript;
        Merchant.LoadNpcScript;
      end;
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;

procedure TUserEngine.ReloadNpcList();
var
  i: Integer;
  NPC: TNormNpc;
begin
  for i := 0 to QuestNPCList.Count - 1 do
  begin
    NPC := TNormNpc(QuestNPCList.Items[i]);
    if not NPC.m_boIsHide then
    begin //By Blue
      NPC.ClearScript;
      NPC.LoadNpcScript;
    end;
  end;
end;

function TUserEngine.GetMapMonster(Envir: TEnvirnoment; List: TList; const boSlave: Boolean = False): Integer; //004AE20C
var
  i, ii: Integer;
  MonGen: pTMonGenInfo;
  BaseObject: TBaseObject;
begin
  Result := 0;
  if Envir = nil then
    Exit;
  for i := 0 to m_MonGenList.Count - 1 do
  begin
    MonGen := m_MonGenList.Items[i];
    if MonGen = nil then
      Continue;
    for ii := 0 to MonGen.CertList.Count - 1 do
    begin
      BaseObject := TBaseObject(MonGen.CertList.Items[ii]);
      if not BaseObject.IsHero and not BaseObject.m_boDeath and not BaseObject.m_boGhost and (BaseObject.m_PEnvir = Envir) and (boSlave or (BaseObject.m_Master = nil)) then
      begin
        if List <> nil then
          List.Add(BaseObject);
        Inc(Result);
      end;
    end;
  end;
end;

procedure TUserEngine.HumanExpire(sAccount: string);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  if not g_Config.boKickExpireHuman then
    Exit;
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if CompareText(PlayObject.m_sUserID, sAccount) = 0 then
    begin
      PlayObject.m_boExpire := True;
      Break;
    end;
  end;
end;

function TUserEngine.GetMapHuman(sMapName: string): Integer;
var
  i: Integer;
  Envir: TEnvirnoment;
  PlayObject: TPlayObject;
begin
  Result := 0;
  Envir := g_MapManager.FindMap(sMapName);
  if Envir = nil then
    Exit;
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
{$IF V_TEST = 1}
    if i > 10 then
      Break;
{$IFEND V_TEST}
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boDeath and not PlayObject.m_boGhost and (PlayObject.m_PEnvir = Envir) then
      Inc(Result);
  end;
end;

function TUserEngine.IsSameGuildOnMap(sMapName: string): Boolean;
var
  i: Integer;
  Envir: TEnvirnoment;
  PlayObject: TPlayObject;
  Guild: TGuild;
begin
  Result := False;
  Envir := g_MapManager.FindMap(sMapName);
  if Envir = nil then
    Exit;
  if m_PlayObjectList.Count <= 0 then
    Exit;

  Guild := nil;
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boDeath and not PlayObject.m_boGhost and (PlayObject.m_PEnvir = Envir) then
    begin
      if PlayObject.m_MyGuild = nil then
        Exit;
      if Guild = nil then
        Guild := TGuild(PlayObject.m_MyGuild);
      if Guild <> nil then
      begin
        if Guild <> PlayObject.m_MyGuild then
          Exit;
      end;
    end;
  end;

  Result := True;
end;

function TUserEngine.GetMapHumanCount(MapEnvir: TEnvirnoment): Integer;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := 0;
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boDeath and not PlayObject.m_boGhost and (PlayObject.m_PEnvir = MapEnvir) then
      Inc(Result);
  end;
end;

function TUserEngine.GetMapRageHuman(Envir: TEnvirnoment; nRageX, nRageY, nRage: Integer; List: TList): Integer;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := 0;
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
{$IF V_TEST = 1}
{$I '..\Common\Macros\VMPBM.inc'}
    if i > 10 then
      Break;
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
{$I '..\Common\Macros\VMPE.inc'}
{$ELSE}
   // PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
{$IFEND V_TEST}
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boDeath and
      not PlayObject.m_boGhost and
      (PlayObject.m_PEnvir = Envir) and
      (abs(PlayObject.m_nCurrX - nRageX) <= nRage) and
      (abs(PlayObject.m_nCurrY - nRageY) <= nRage) then
    begin
      List.Add(PlayObject);
      Inc(Result);
    end;
  end;
end;

function TUserEngine.GetStdItemIdx(sItemName: string): Integer;
var
  i: Integer;
  StdItem: pTStdItem;
begin
  Result := -1;
  if sItemName = '' then
    Exit;
  for i := 0 to StdItemList.Count - 1 do
  begin
    StdItem := StdItemList.Items[i];
    if CompareText(StdItem.Name, sItemName) = 0 then
    begin
      Result := i + 1;
      Break;
    end;
  end;
end;

procedure TUserEngine.SendBroadCastMsgExt(sMsg: string; MsgType: TMsgType); //004AEAF0
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  EnterCriticalSection(ProcessHumanCriticalSection); //0618
  try
    for i := 0 to m_PlayObjectList.Count - 1 do
    begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
      if not PlayObject.m_boGhost and not PlayObject.m_boOffLineFlag then
        PlayObject.SysMsg(sMsg, c_Red, MsgType);
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TUserEngine.SendBroadCastMsgExt2(sMsg: string; MsgType: TMsgType); //004AEAF0
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to m_PlayObjectList.Count - 1 do
    begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
      if not PlayObject.m_boGhost and not PlayObject.m_boOffLineFlag then
        PlayObject.SysMsg(sMsg, c_Red, MsgType);
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TUserEngine.SendBroadCastMsg(sMsg: string; MsgType: TMsgType; MsgColor: TMsgColor; fc, bc, sec: Integer);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boGhost and not PlayObject.m_boOffLineFlag then
    begin
      //PlayObject.m_btMsgFColor := fc;
      //PlayObject.m_btMsgBColor := bc;
      if (fc >= 0) then
        PlayObject.SysMsg(sMsg, MsgColor, MsgType, fc, bc, sec)
      else
        PlayObject.SysMsg(sMsg, MsgColor, MsgType);
    end;
  end;
end;

procedure TUserEngine.SendScrollMsg(sMsg: string; MsgType: TMsgType; MsgColor: TMsgColor; fc, bc, sec: Integer);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boGhost and not PlayObject.m_boOffLineFlag then
    begin
      PlayObject.SendMsg(PlayObject, RM_SYSMESSAGE2, 0, fc, bc, sec, sMsg);
    end;
  end;
end;

procedure TUserEngine.Execute;
begin
{$IF USEPLUGFUNC = 1}
  if (nEngRemoteRun >= 0) and Assigned(PlugProcArray[nEngRemoteRun].nProcAddr) then
    TClassProc(PlugProcArray[nEngRemoteRun].nProcAddr)(self);
{$ELSE}
  Run();
{$IFEND USEPLUGFUNC}
end;

procedure TUserEngine.ClearMonSayMsg;
var
  i, ii: Integer;
  MonGen: pTMonGenInfo;
  MonBaseObject: TBaseObject;
begin
  for i := 0 to m_MonGenList.Count - 1 do
  begin
    MonGen := m_MonGenList.Items[i];
    for ii := 0 to MonGen.CertList.Count - 1 do
    begin
      MonBaseObject := TBaseObject(MonGen.CertList.Items[ii]);
      MonBaseObject.m_SayMsgList := nil;
    end;
  end;
end;

procedure TUserEngine.ClearItemList();
var
  i: Integer;
begin
  i := 0;
  while (True) do
  begin
    StdItemList.Exchange(Random(StdItemList.Count), StdItemList.Count - 1);
    Inc(i);
    if i >= StdItemList.Count then
      Break;
  end;
  ClearMerchantData();
end;

procedure TUserEngine.PrcocessData;
var
  dwUsrTimeTick: LongWord;
  sMsg: string;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::ProcessData(%d) - %s';
begin
  //try
  dwUsrTimeTick := GetTickCount();
  ProcessHumans();
  ProcessHero();

  if g_Config.boSendOnlineCount and (GetTickCount - g_dwSendOnlineTick > g_Config.dwSendOnlineTime) then
  begin
    g_dwSendOnlineTick := GetTickCount();
    sMsg := AnsiReplaceText(g_sSendOnlineCountMsg, '%c', IntToStr(Round(GetOnlineHumCount * (g_Config.nSendOnlineCountRate / 10))) {+ IntToStr(Random(10))});
    SendBroadCastMsg(sMsg, t_System)
  end;

  ProcessEscort();
  ProcessMonsters();
  ProcessMerchants();
  ProcessNpcs();

  if (GetTickCount() - dwProcessMissionsTime) > 1000 then
  begin
    dwProcessMissionsTime := GetTickCount();
    //ProcessMissions();
    ProcessEvents();
{$IF INTERSERVER = 1}
    CheckSwitchServerTimeOut();
{$IFEND}
  end;

  if (GetTickCount() - dwProcessMapDoorTick) > 500 then
  begin
    dwProcessMapDoorTick := GetTickCount();
    ProcessMapDoor();
  end;

  if (GetTickCount() - dwProcessEffectsTick) > 2500 then
  begin //0824
    dwProcessEffectsTick := GetTickCount();
    ProcessEffects();
  end;

  g_nUsrTimeMin := GetTickCount() - dwUsrTimeTick;
  if g_nUsrTimeMax < g_nUsrTimeMin then
    g_nUsrTimeMax := g_nUsrTimeMin;
  //except
  //  on E: Exception do MainOutMessageAPI(Format(sExceptionMsg, [CC, E.Message]));
  //end;
end;

procedure TUserEngine.SendQuestMsg(sQuestName: string);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boDeath and not PlayObject.m_boGhost and not PlayObject.m_boOffLineFlag then
      g_ManageNPC.GotoLable(PlayObject, sQuestName, False);
  end;
end;

procedure TUserEngine.SwitchMagicList();
begin
  if m_MagicList.Count > 0 then
  begin
    m_MagicListPre.Add(m_MagicList);
    m_MagicList := TList.Create;
  end;
end;

procedure TUserEngine.ClearMerchantData();
var
  i: Integer;
  Merchant: TMerchant;
begin
  m_MerchantList.Lock;
  try
    for i := 0 to m_MerchantList.Count - 1 do
    begin
      Merchant := TMerchant(m_MerchantList.Items[i]);
      Merchant.ClearData();
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;

procedure TUserEngine.GuildMemberReGetRankName(Guild: TGuild);
var
  i, n: Integer;
begin
  for i := 0 to m_PlayObjectList.Count - 1 do
  begin
    if TPlayObject(m_PlayObjectList.Objects[i]).m_MyGuild = Guild then
      Guild.GetRankName(TPlayObject(m_PlayObjectList.Objects[i]), n);
  end;
end;

function TUserEngine.AddSwitchData(psui: pTSwitchDataInfo): Boolean;
begin
  psui.dwWaitTime := GetTickCount;
  m_ChangeServerList.Add(psui);
  Result := True;
end;

procedure TUserEngine.DelSwitchData(SwitchData: pTSwitchDataInfo);
var
  i: Integer;
  SwitchDataInfo: pTSwitchDataInfo;
begin
  for i := m_ChangeServerList.Count - 1 downto 0 do
  begin
    SwitchDataInfo := m_ChangeServerList.Items[i];
    if SwitchDataInfo = SwitchData then
    begin
      Dispose(SwitchDataInfo);
      m_ChangeServerList.Delete(i);
      Break;
    end;
  end;
end;

function TUserEngine.GetSwitchData(sChrName: string; nCode: Integer): pTSwitchDataInfo;
var
  i: Integer;
  SwitchData: pTSwitchDataInfo;
begin
  Result := nil;
  for i := 0 to m_ChangeServerList.Count - 1 do
  begin
    SwitchData := m_ChangeServerList.Items[i];
    if SwitchData = nil then
      Continue;
    if (CompareText(SwitchData.sChrName, sChrName) = 0) and (SwitchData.nCode = nCode) then
    begin
      Result := SwitchData;
      Break;
    end;
  end;
end;

procedure TUserEngine.CheckSwitchServerTimeOut;
var
  i: Integer;
begin
  for i := m_ChangeServerList.Count - 1 downto 0 do
  begin
    if GetTickCount - pTSwitchDataInfo(m_ChangeServerList[i]).dwWaitTime > 30 * 1000 then
    begin
      Dispose(pTSwitchDataInfo(m_ChangeServerList[i]));
      m_ChangeServerList.Delete(i);
    end;
  end;
end;

procedure TUserEngine.SendInterMsg(Ident, svidx: Integer; msgstr: string);
begin
{$IF INTERSERVER = 1}
  EnterCriticalSection(USInterMsgCriticalSection);
  try
    if g_nServerIndex = 0 then
      FrmSrvMsg.SendServerSocket(IntToStr(Ident) + '/' + IntToStr(svidx) + '/' + msgstr)
    else
      FrmMsgClient.SendSocket(IntToStr(Ident) + '/' + IntToStr(svidx) + '/' + msgstr);
  finally
    LeaveCriticalSection(USInterMsgCriticalSection);
  end;
{$IFEND}
end;

procedure TUserEngine.GetISMChangeServerReceive(flName: string);
var
  i: Integer;
  hum: TPlayObject;
begin
  for i := 0 to m_PlayObjectFreeList.Count - 1 do
  begin
    hum := TPlayObject(m_PlayObjectFreeList[i]);
    if hum.m_sSwitchDataTempFile = flName then
    begin
      hum.m_boSwitchDataOK := True;
      Break;
    end;
  end;
end;

procedure TUserEngine.OtherServerUserLogon(sNum: Integer; uname: string);
var
  i: Integer;
  Name, apmode: string;
begin
  apmode := GetValidStr3(uname, Name, [':']);
  for i := m_OtherUserNameList.Count - 1 downto 0 do
  begin
    if CompareText(m_OtherUserNameList[i], Name) = 0 then
      m_OtherUserNameList.Delete(i);
  end;
  m_OtherUserNameList.AddObject(Name, TObject(sNum));
  //Add User To UserMgr When Other Server Login...
  //UserMgrEngine.AddUser(Name, 0, snum + 4, 0, 0, 0);
end;

procedure TUserEngine.OtherServerUserLogout(sNum: Integer; uname: string);
var
  i: Integer;
  Name, apmode: string;
begin
  apmode := GetValidStr3(uname, Name, [':']);
  for i := m_OtherUserNameList.Count - 1 downto 0 do
  begin
    if (CompareText(m_OtherUserNameList[i], Name) = 0) and (Integer(m_OtherUserNameList.Objects[i]) = sNum) then
    begin
      m_OtherUserNameList.Delete(i);
      //Add User To UserMgr When Other Server Login...
      //UserMgrEngine.DeleteUser(Name);
      Break;
    end;
  end;
end;

function TUserEngine.EffectTarget(x, y: Integer; Envir: TEnvirnoment): Boolean;
var
  Dmg, magpwr: Integer;
  i, nRANDOM: Integer;
  xTargetList: TList;
  Target, BaseObject: TBaseObject;
begin
  Result := False;
  if g_BaseObject = nil then  Exit;

  Target := EffectSearchTarget(x, y, Envir);
  if Target = nil then  Exit; //if there's nobody in the area then the spell cant do dmg or effect

  if Random(5) = 0 then
  begin //20% chance the effect gets attracted by the nearest player :p
    x := Target.m_nCurrX;
    y := Target.m_nCurrY;
  end;
  if Envir.InSafeZone(x, y) then
    Exit;
  nRANDOM := 0;
  if Envir.m_MapFlag.nThunder <> 0 then
    Inc(nRANDOM);
  if Envir.m_MapFlag.nGreatThunder <> 0 then
    Inc(nRANDOM);
  if Envir.m_MapFlag.nLava <> 0 then
    Inc(nRANDOM);
  if Envir.m_MapFlag.nSpurt <> 0 then
    Inc(nRANDOM);

  xTargetList := TList.Create;
  try
    while nRANDOM <> 0 do
    begin
      if Result then
        Break;
      if (Envir.m_MapFlag.nThunder <> 0) and (Random(nRANDOM + 1) = 0) then
      begin
        //
        Target.SendRefMsg(RM_FIREWORKS, 0, 4, x, y, '');
        Dmg := Envir.m_MapFlag.nThunder;
        Envir.GetBaseObjects(x, y, True, xTargetList);
        for i := xTargetList.Count - 1 downto 0 do
        begin
          BaseObject := TBaseObject(xTargetList.Items[i]);
          if (BaseObject <> nil) then
          begin
            if (Target = BaseObject) or Target.IsProperFriend(BaseObject) then
            begin
              magpwr := Dmg div 2 + Random(Dmg);
              g_BaseObject.m_PEnvir := Envir;
              BaseObject.SendDelayMsg(g_BaseObject, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
            end;
          end;
        end;
        Result := True;
        Break;
      end
      else if (Envir.m_MapFlag.nGreatThunder <> 0) and (Random(nRANDOM + 1) = 0) then
      begin
        Target.SendRefMsg(RM_FIREWORKS, 0, 5, x, y, '');
        Dmg := Envir.m_MapFlag.nGreatThunder;
        Envir.GetRangeBaseObject(x, y, 1, True, xTargetList);
        for i := xTargetList.Count - 1 downto 0 do
        begin
          BaseObject := TBaseObject(xTargetList.Items[i]);
          if (BaseObject <> nil) then
          begin
            if (Target = BaseObject) or Target.IsProperFriend(BaseObject) then
            begin
              magpwr := Dmg div 2 + Random(Dmg);
              g_BaseObject.m_PEnvir := Envir;
              BaseObject.SendDelayMsg(g_BaseObject, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
            end;
          end;
        end;
        Result := True;
        Break;
      end
      else if (Envir.m_MapFlag.nLava <> 0) and (Random(nRANDOM + 1) = 0) then
      begin
        Target.SendRefMsg(RM_FIREWORKS, 0, 6, x, y, '');
        Dmg := Envir.m_MapFlag.nLava;
        Envir.GetRangeBaseObject(x, y, 1, True, xTargetList);
        for i := xTargetList.Count - 1 downto 0 do
        begin
          BaseObject := TBaseObject(xTargetList.Items[i]);
          if (BaseObject <> nil) then
          begin
            if Target.IsProperFriend(BaseObject) or (Target = BaseObject) then
            begin
              magpwr := Dmg div 2 + Random(Dmg);
              g_BaseObject.m_PEnvir := Envir;
              BaseObject.SendDelayMsg(g_BaseObject, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
            end;
          end;
        end;
        Result := True;
        Break;
      end
      else if (Envir.m_MapFlag.nSpurt <> 0) and (Random(nRANDOM + 1) = 0) then
      begin
        Target.SendRefMsg(RM_FIREWORKS, 0, 7, x, y, '');
        Dmg := Envir.m_MapFlag.nSpurt;
        Envir.GetRangeBaseObject(x, y, 1, True, xTargetList);
        for i := xTargetList.Count - 1 downto 0 do
        begin
          BaseObject := TBaseObject(xTargetList.Items[i]);
          if (BaseObject <> nil) then
          begin
            if Target.IsProperFriend(BaseObject) or (Target = BaseObject) then
            begin
              magpwr := Dmg div 2 + Random(Dmg);
              g_BaseObject.


              m_PEnvir := Envir;
              BaseObject.SendDelayMsg(g_BaseObject, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
            end;
          end;
        end;
        Result := True;
        Break;
      end;

    end;
  finally
    xTargetList.Free;
  end;
end;

function TUserEngine.EffectSearchTarget(x, y: Integer; Envir: TEnvirnoment): TBaseObject;
var
  xTargetList: TList;
  dist: Integer;
  BaseObject: TBaseObject;
  nRage: Integer;
  i: Integer;
begin
  dist := 999;
  nRage := 12;

  Result := nil;
  xTargetList := TList.Create;
  Envir.GetRangeBaseObject(x, y, nRage, False, xTargetList);
  for i := 0 to xTargetList.Count - 1 do
  begin
    BaseObject := TBaseObject(xTargetList.Items[i]);
    if BaseObject.m_boDeath then
      Continue; //0701
    if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or BaseObject.IsHero then
    begin
      if abs(abs(BaseObject.m_nCurrX - x) + (abs(BaseObject.m_nCurrY - y))) < dist then
      begin
        dist := abs(abs(BaseObject.m_nCurrX - x) + (abs(BaseObject.m_nCurrY - y)));
        Result := BaseObject;
        if (BaseObject.m_nCurrX = x) and (BaseObject.m_nCurrY = y) then
        begin
          //Result := BaseObject;
          Break;
        end;
      end;
    end;
  end;
  xTargetList.Free;
end;

function TUserEngine.LoadMonSpAbil(): Boolean;
var
  i: Integer;
  sFileName, sLineText: string;
  LoadList: TStringList;
  MonSpAbil: pTMonSpAbil;

  sName: string;
  s1, s2, s3, s4, s5: string;
  s6, s7, s8, s9, s10: string;
  n1, n2, n3, n4, n5: Integer;
  n6, n7, n8, n9, n10: Integer;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'MonSpAbilList.txt';

  for i := 0 to MonSpAbilList.Count - 1 do
    Dispose(pTMonSpAbil(MonSpAbilList.GetValues(MonSpAbilList.Keys[i])));
  MonSpAbilList.Clear;

  if not FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.Add(';怪物名'#9'忽视防御(0~100)'#9'增加伤害(0~255)'#9'伤害反弹(0~100)'#9'物伤减少(0~100)'#9'魔伤减少(0~100)'#9'麻痹(0~1)'#9'防麻痹(0~1)'#9'防全毒(0~1)'#9'破复活(0~1)'#9'破护身(0~1)');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;

  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sFileName);
  for i := 0 to LoadList.Count - 1 do
  begin
    sLineText := Trim(LoadList.Strings[i]);
    if (sLineText = '') or (sLineText[1] = ';') then
      Continue;
    sLineText := GetValidStr3(sLineText, sName, [' ', ',', #9]);
    sLineText := GetValidStr3(sLineText, s1, [' ', ',', #9]);
    sLineText := GetValidStr3(sLineText, s2, [' ', ',', #9]);
    sLineText := GetValidStr3(sLineText, s3, [' ', ',', #9]);
    sLineText := GetValidStr3(sLineText, s4, [' ', ',', #9]);
    sLineText := GetValidStr3(sLineText, s5, [' ', ',', #9]);
    sLineText := GetValidStr3(sLineText, s6, [' ', ',', #9]);
    sLineText := GetValidStr3(sLineText, s7, [' ', ',', #9]);
    sLineText := GetValidStr3(sLineText, s8, [' ', ',', #9]);
    sLineText := GetValidStr3(sLineText, s9, [' ', ',', #9]);
    sLineText := GetValidStr3(sLineText, s10, [' ', ',', #9]);

    if sName <> '' then
    begin

      n1 := _MIN(100, Str_ToInt(s1, 0));
      n2 := _MIN(255, Str_ToInt(s2, 0));
      n3 := _MIN(100, Str_ToInt(s3, 0));
      n4 := _MIN(100, Str_ToInt(s4, 0));
      n5 := _MIN(100, Str_ToInt(s5, 0));
      n6 := Str_ToInt(s6, 0);
      n7 := Str_ToInt(s7, 0);
      n8 := Str_ToInt(s8, 0);
      n9 := Str_ToInt(s9, 0);
      n10 := Str_ToInt(s10, 0);

      New(MonSpAbil);
      MonSpAbil.btIgnoreTagDefence := n1;
      MonSpAbil.btDamageAddOn := n2;
      MonSpAbil.btDamageRebound := n3;
      MonSpAbil.btACDamageReduction := n4;
      MonSpAbil.btMCDamageReduction := n5;
      MonSpAbil.boMonParalysis := n6 <> 0;
      MonSpAbil.boMonUnParalysis := n7 <> 0;
      MonSpAbil.boMonUnAllParalysis := n8 <> 0;
      MonSpAbil.boMonUnRevival := n9 <> 0;
      MonSpAbil.boMonUnMagicShield := n10 <> 0;
      MonSpAbilList.Put(sName, TObject(MonSpAbil));

      //MainOutMessageAPI(sName + Format(' 1 %d %d %d %d %d', [n1, n2, n3, n4, n5]));

    end;
  end;

  LoadList.Free;
end;

initialization
  AddToProcTable(@TUserEngine.Run, 'TUserEngine.Run');
  nEngRemoteRun := AddToPulgProcTable('TUserEngine.Run');

finalization

end.
