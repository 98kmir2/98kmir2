unit ObjMon;

interface
uses
  Windows, Classes, Grobal2, ObjBase, SysUtils, Envir;
type
  TMonster = class(TAnimalObject)
    m_dwThinkTick: LongWord;
    m_boDupMode: Boolean;
    m_boApproach: Boolean;
  private
    function Think: Boolean;
    function MakeClone(sMonName: string; OldMon: TBaseObject): TBaseObject;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    function AttackTarget(): Boolean; virtual;
    procedure Run; override;
    function MagMakeFireCross(BaseObject: TBaseObject; nDamage, nHTime, nX, nY, ETTPYE: Integer): Integer;
    procedure HitMagAttackTarget_RandomMove(TargeTBaseObject: TBaseObject; nHitPower, nMagPower: Integer; boFlag: Boolean);
    procedure HitMagAttackTarget_ChrPush(TargeTBaseObject: TBaseObject; nHitPower, nMagPower: Integer; boFlag: Boolean);
    procedure HitMagAttackTarget_WideAttack(TargeTBaseObject: TBaseObject; nHitPower, nMagPower: Integer; boFlag: Boolean);
  end;

{$IF VER_PATHMAP = 1}
  TMissionMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;
  TMissionMonsterEx = class(TMonster)
  public
    m_nMoveStep: Integer;
    m_WayPoint: TPath;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function WalkTo(btDir: byte; boFlag: Boolean): Boolean; override;
  end;
{$IFEND}

  TChickenDeer = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TPanda = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TATMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TMon38_5 = class(TATMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function AttackTarget(): Boolean; override;
    procedure SpitAttack2(btDir: byte);
  end;

  TMon38_8 = class(TATMonster)
    m_dwSpellTick: LongWord;
  private
    procedure ShotArrow(targ: TBaseObject);
  public
    constructor Create;
    function AttackTarget: Boolean; override;
    procedure Run; override;
  end;

  TMon38_10 = class(TATMonster)
  public
    constructor Create;
    function AttackTarget: Boolean; override;
    procedure Run; override;
  end;

  TMon38_11 = class(TATMonster)
    m_dwSpellTick: LongWord;
  public
    constructor Create;
    function AttackTarget: Boolean; override;
    procedure Run; override;
    procedure SpitAttack2(btDir: byte);
  end;

  THeroMonster = class(TATMonster)
    m_dwCheckStutasTick: LongWord;
    m_dwMag41Tick: LongWord;
    m_SetUseMagic: TMonUseMagic;
    m_nLongAttackCount: Integer;
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; override;
    procedure Run(); override;
  end;

  TPlayMonster = class(TATMonster)
    m_dwCheckStutasTick: LongWord;
    m_dwMag41Tick: LongWord;
    m_SetUseMagic: TMonUseMagic;
    m_nLongAttackCount: Integer;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; override;
    procedure Run(); override;
  end;

  TFireKnightMonster = class(TATMonster)
  private
    function FireBurnAttack(bt05: byte): TBaseObject;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget: Boolean; override;
  end;

  TSlowATMonster = class(TATMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;
  TScorpion = class(TATMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;
  TSpitSpider = class(TATMonster)
    m_boUsePoison: Boolean;
  private
    procedure SpitAttack(btDir: byte);
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; override;
  end;
  THighRiskSpider = class(TSpitSpider)
  private

  public
    constructor Create(); override;
    destructor Destroy; override;
  end;

  TBigPoisionSpider = class(TSpitSpider)
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;

  TGasAttackMonster = class(TATMonster)
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget: Boolean; override;
    function sub_4A9C78(bt05: byte): TBaseObject; virtual;
  end;

  TCowMonster = class(TATMonster)
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;

  TMagCowMonster = class(TATMonster)
  private
    procedure sub_4A9F6C(btDir: byte);
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget: Boolean; override;
  end;

  TCowKingMonster = class(TATMonster)
    m_dwRunTickMon: LongWord;
    m_boDanger: Boolean;
    m_boCrazy: Boolean;
    m_nDangerLevel: Integer;
    m_dwDangerTick: LongWord;
    m_dwCrazyTick: LongWord;
    m_nPreNextHitTime: LongWord;
    m_nPreWalkSpeed: LongWord;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure Initialize(); override;
  end;

  THongMoMonster = class(TATMonster)
    m_dwRunTickMon: LongWord;
    m_boDanger: Boolean;
    m_boCrazy: Boolean;
    m_nDangerLevel: Integer;
    m_dwDangerTick: LongWord;
    m_dwCrazyTick: LongWord;
    m_nPreNextHitTime: LongWord;
    m_nPreWalkSpeed: LongWord;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure Initialize(); override;
  end;

  TElectronicScolpionMon = class(TMonster)
    m_boUseMagic: Boolean;
  private
    procedure LightingAttack(nDir: Integer);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TCrystalSpider = class(TElectronicScolpionMon)
  private
    m_boUseMagic: Boolean;
    procedure LightingAttack(nDir: Integer);
  public
    function AttackTarget(): Boolean; override; //FFEB
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TLightingZombi = class(TMonster)
  private
    procedure LightingAttack(nDir: Integer);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TLightingCowKing = class(TMonster)
  private
    procedure LightingAttack(nDir: Integer);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TSkeletonKingMon = class(TMonster)
  private
    procedure LightingAttack(nDir: Integer);
    procedure FlayAxeAttack(nDir: Integer);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TEldKingMon = class(TMonster)
    m_dwGroupParalysisTick: LongWord;
  private
    // procedure PoisonAttack(nDir: Integer; boPoison: Boolean);      
    procedure GroupParalysisAttack(nDir: Integer);
    procedure CharPushAttack();
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TSpiderKingMon = class(TATMonster)
    m_dwGroupParalysisTick: LongWord;
  private
    procedure GroupParalysisAttack(nDir: Integer);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function AttackTarget(): Boolean; override;
  end;

  TDigOutZombi = class(TMonster)
  private
    procedure sub_4AA8DC;

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;
  TZilKinZombi = class(TATMonster)
    dw558: LongWord;
    nZilKillCount: Integer;
    dw560: LongWord;
  private

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Die; override;
    procedure Run; override;
  end;

  TWhiteSkeleton = class(TATMonster)
    m_boIsFirst: Boolean;
    m_btAttackSkillCount: byte;
    m_btAttackSkillPointCount: byte;
  private
    procedure RecalcAbilitysEx;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; override;
    procedure RecalcAbilitys(boAction: Boolean = False); override;
    procedure Run; override;
  end;

  TScultureMonster = class(TMonster)
  private
    procedure MeltStone; //
    procedure MeltStoneAll;

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;
  TScultureKingMonster = class(TMonster)
    m_nDangerLevel: Integer;
    m_SlaveObjectList: TList; //0x55C
  private
    procedure MeltStone;
    procedure CallSlave;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure Run; override;
  end;

  TGasMothMonster = class(TGasAttackMonster) //楔蛾
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function sub_4A9C78(bt05: byte): TBaseObject; override; //FFEA
  end;

  TGasDungMonster = class(TGasAttackMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;

  TElfMonster = class(TMonster)
    boIsFirst: Boolean; //0x558
  private
    procedure AppearNow;
    procedure ResetElfMon;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure RecalcAbilitys(boAction: Boolean = False); override;
    procedure Run; override;
  end;

  TElfWarriorMonster = class(TSpitSpider)
    n55C: Integer;
    boIsFirst: Boolean; //0x560
    dwDigDownTick: LongWord; //0x564
  private
    procedure SpitAttack2(btDir: byte);
    procedure AppearNow;
    procedure ResetElfMon;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure RecalcAbilitys(boAction: Boolean = False); override;
    procedure Run; override;
    function AttackTarget: Boolean; override;
  end;

  TBloodKingMonster = class(TMonster)
    m_nDangerLevel: Integer;
    m_SlaveObjectList: TList;
    m_dwRecallAbilTick: LongWord;
  private
    //m_boUseMagic: Boolean;
    //procedure MeltStone;
    procedure CallSlave;
    //procedure LightingAttack(nDir: Integer);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure Run(); override;
  end;

  TEidolonMonster = class(TATMonster) //angel
    m_boIsFirst: Boolean;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; override;
    procedure MagicAttack(Target: TBaseObject); virtual;
    procedure Run; override;
    procedure RecalcAbilitys(boAction: Boolean = False); override;
  end;

  TSnowMonster = class(TATMonster)
    m_boSmiteHit: Boolean;
    m_dwSpellTick: LongWord;
    m_dwSpellTick2: LongWord;
    UserMagic_44: TUserMagic;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; override;
    procedure MagicAttack(Target: TBaseObject); virtual;
    function PoisonAttack(Target: TBaseObject): Boolean;
    procedure Run; override;
  end;

  TDoubleCriticalMonster = class(TATMonster)
    m_n7A0: Integer;
  public
    constructor Create(); override; //0x0050ACB4
    destructor Destroy; override;
    procedure Run; override; //0x0050AD00
    procedure Attack(Target: TBaseObject; nDir: Integer); override; //0x0050AE74
  end;

  TDDevil = class(TMonster)
    m_dwSpellTick: LongWord;
    m_boUseMagic: Boolean;
  private
    procedure LightingAttack(nDir: Integer);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TRedThunderZuma = class(TScultureMonster)
    m_dwSpellTick: LongWord;
  private
    procedure MagicAttack();
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TStoneMonster = class(TMonster)
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TTiger = class(TMonster)
    m_dwSpellTick: LongWord;
    m_dwLastWalkTick: LongWord;
  private
    procedure MagAttack();
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure Run; override;
  end;

  TDragon = class(TATMonster)
    m_dwSpellTick: LongWord;
  private
    procedure FlameCircle(nDir: Integer);
    procedure MassThunder();
  public
    constructor Create;
    function AttackTarget: Boolean; override;
    procedure Run; override;
  end;

  TRebelCommandMonster = class(TATMonster)
  public
    m_dwSpellTick: LongWord;
    constructor Create(); override;
    function AttackTarget(): Boolean; override;
  end;

implementation

uses UsrEngn, M2Share, Event, Magic, HUtil32, EDcode;

constructor TPlayMonster.Create();
begin
  inherited;
  m_boWantRefMsg := False;
  m_boDupMode := False;
  m_dwThinkTick := GetTickCount();
  m_dwCheckStutasTick := GetTickCount();
  m_nViewRangeX := 7;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 300;
  m_dwSearchTime := 2000 + Random(2000);
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := RC_HERO;
  m_dwMag41Tick := 0;
  m_nCurMagId := 0;
{$IF VER_ClientType_45}
  m_wClientType := 46;
{$IFEND VER_ClientType_45}
  //m_boUseShootLighten := False;
end;

destructor TPlayMonster.Destroy();
begin
  inherited;
end;

function TPlayMonster.AttackTarget(): Boolean;

  function TakeOnItem(nType: Integer; sItemName: string): Boolean;
  var
    UserItem: TUserItem;
  begin
    Result := False;

    if UserEngine.CopyToUserItemFromName(sItemName, @UserItem) then
    begin
      if nType = 1 then
        m_UseItems[U_ARMRINGL] := UserItem
      else
        m_UseItems[U_BUJUK] := UserItem;
      Result := True;
    end;
  end;

  function Taos_SetUseMagicFirst(): pTUserMagic;
  var
    nAmuletIdx: Integer;
    UserMagic: pTUserMagic;
  begin
    Result := nil;
    UserMagic := nil;
    m_SetUseMagic := t_Norm;
    //if g_Config.nRegCheckCode < 0 then Exit;
    if g_Config.boHeroNeedAmulet then
    begin
      if CheckAmulet(TPlayObject(self), 1, 1, nAmuletIdx) then
      begin
        if UserEngine.GetStdItem(m_UseItems[nAmuletIdx].wIndex) <> nil then
        begin
          if m_SetUseMagic = t_Norm then
          begin
            UserMagic := m_MagicArr[0][30]; //TPlayObject(self).GetMagicInfo(30);
            if UserMagic = nil then
              UserMagic := m_MagicArr[0][17]; //TPlayObject(self).GetMagicInfo(17);
            if (UserMagic <> nil) and (m_SlaveList.Count <= 0) then
              m_SetUseMagic := t_MobSlave;
          end;
          if m_SetUseMagic = t_MobSlave then
            Result := UserMagic;
        end;
      end
      else
        TakeOnItem(1, '护身符(大)');
    end
    else
    begin
      if m_SetUseMagic = t_Norm then
      begin
        UserMagic := m_MagicArr[0][30]; //TPlayObject(self).GetMagicInfo(30);
        if UserMagic = nil then
          UserMagic := m_MagicArr[0][17]; //TPlayObject(self).GetMagicInfo(17);
        if (UserMagic <> nil) and (m_SlaveList.Count <= 0) then
          m_SetUseMagic := t_MobSlave;
      end;
      if m_SetUseMagic = t_MobSlave then
        Result := UserMagic;
    end;
  end;

  function Taos_SetUseMagic(): pTUserMagic;
  var
    i, nAmuletIdx: Integer;
    UserMagic: pTUserMagic;
    boReadMagic: Boolean;
    StdItem: pTStdItem;
  label
    sLabel;
  begin
    Result := nil;
    m_SetUseMagic := t_Norm;

    if (m_TargetCret = nil) then
    begin
      if m_Master <> nil then
      begin
        if (m_Master.m_wStatusTimeArr[POISON_DECHEALTH] <> 0) or
          (m_Master.m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0) or
          (m_Master.m_wStatusTimeArr[POISON_STONE] <> 0) then
        begin
          m_SetUseMagic := t_UNAMYOUNSUL;
        end;
      end;
      if (m_SetUseMagic = t_Norm) then
      begin
        if (m_wStatusTimeArr[POISON_DECHEALTH] <> 0) or
          (m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0) or
          (m_wStatusTimeArr[POISON_STONE] <> 0) then
        begin
          m_SetUseMagic := t_UNAMYOUNSULSELF;
        end;
      end;
    end;
    if (m_SetUseMagic = t_Norm) and (m_Master <> nil) then
    begin
      if (Round(m_Master.m_WAbil.HP / m_Master.m_WAbil.MaxHP * 100) <= 60) and (m_SetUseMagic <> t_AddHP_M) then
        m_SetUseMagic := t_AddHP_M;
    end;

    if (m_SetUseMagic = t_Norm) then
    begin
      if g_Config.boHeroNeedAmulet then
      begin
        if CheckAmulet(TPlayObject(self), 1, 1, nAmuletIdx) then
        begin
          if (m_Master <> nil) and (m_Master.m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) and (m_SetUseMagic <> t_Defence_m) then
            m_SetUseMagic := t_Defence_m;
          if (m_Master <> nil) and (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_m_m) and (m_Master.m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then
            m_SetUseMagic := t_Defence_m_m;
          if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_s) and (m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) then
            m_SetUseMagic := t_Defence_s;
          if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_s_m) and (m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then
            m_SetUseMagic := t_Defence_s_m;
          if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_SCDouble) and (m_wStatusArrValue[2] <= 0) then
            m_SetUseMagic := t_SCDouble;
        end
        else
          TakeOnItem(1, '护身符(大)');
      end
      else
      begin
        if (m_Master <> nil) and (m_Master.m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) and (m_SetUseMagic <> t_Defence_m) then
          m_SetUseMagic := t_Defence_m;
        if (m_Master <> nil) and (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_m_m) and (m_Master.m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then
          m_SetUseMagic := t_Defence_m_m;
        if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_s) and (m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) then
          m_SetUseMagic := t_Defence_s;
        if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_s_m) and (m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then
          m_SetUseMagic := t_Defence_s_m;
        if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_SCDouble) and (m_wStatusArrValue[2] <= 0) then
          m_SetUseMagic := t_SCDouble;
      end;

    end;

    if (m_SetUseMagic = t_Norm) then
    begin
      if g_Config.boHeroNeedAmulet then
      begin
        if CheckAmulet(TPlayObject(self), 1, 2, nAmuletIdx) then
        begin
          StdItem := UserEngine.GetStdItem(m_UseItems[nAmuletIdx].wIndex);
          if (m_TargetCret <> nil) and (StdItem <> nil) then
          begin
            if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] <= 0) and (StdItem.Shape = 1) then
            begin
              m_SetUseMagic := t_Poison_0;
            end;
            if (m_SetUseMagic = t_Norm) and (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] <= 0) and (StdItem.Shape = 2) then
            begin
              m_SetUseMagic := t_Poison_1;
            end;
          end;
        end
        else
          TakeOnItem(2, '灰色药粉(大量)');
      end
      else
      begin
        if (m_TargetCret <> nil) then
        begin
          if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] <= 0) then
          begin
            m_btUseAmulet := 1;
            m_SetUseMagic := t_Poison_0;
          end;
          if (m_SetUseMagic = t_Norm) and (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] <= 0) then
          begin
            m_btUseAmulet := 2;
            m_SetUseMagic := t_Poison_1;
          end;
        end;
      end;
    end;
    if m_SetUseMagic = t_Norm then
      m_SetUseMagic := t_Attack;
    boReadMagic := False;
    for i := 0 to m_MagicList.Count - 1 do
    begin
      UserMagic := m_MagicList.Items[i];
      case m_SetUseMagic of
        t_UNAMYOUNSUL, t_UNAMYOUNSULSELF: boReadMagic := (UserMagic.wMagIdx = 34);
        t_AddHP_M, t_AddHP_S: boReadMagic := (UserMagic.wMagIdx = 2);
        t_Defence_m_m, t_Defence_s_m: boReadMagic := (UserMagic.wMagIdx = 14);
        t_Defence_m, t_Defence_s: boReadMagic := (UserMagic.wMagIdx = 15);
        t_Attack: boReadMagic := ((UserMagic.wMagIdx = 13) and (m_TargetCret <> nil) {and MagCanHitTarget(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret)});
        t_Poison_0, t_Poison_1:
          begin
            if GetTagXYRangeCount(0, 1) > 2 then
              boReadMagic := (UserMagic.wMagIdx = 38)
            else
              boReadMagic := (UserMagic.wMagIdx = 6);
          end;
        t_SCDouble:
          begin
            boReadMagic := (UserMagic.wMagIdx = 50);
          end;
      end;
      if boReadMagic then
      begin
        Result := UserMagic;
        Break;
      end;
    end;
  end;

  function MonGetMagicInfo(): pTUserMagic;
  begin
    Result := m_MagicArr[0][m_nCurMagId]; //TPlayObject(self).GetMagicInfo(m_nCurMagId);
  end;

  procedure Warr_SetUseMagic(UserMagic: pTUserMagic);
  var
    boTrainOk: Boolean;
    btDir: byte;
    nHitMode: Integer;
    nMapRangeCount: Integer;
  label
    lEXIT, lNext, lAttack;
  begin
    m_nCurMagId := 25;
    if GetLongAttackDir(m_TargetCret, btDir) and (m_nLongAttackCount <= _MAX(1, Random(5))) then
    begin
      Inc(m_nLongAttackCount);
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        m_nCurMagId := 12;
        goto lAttack;
      end;
    end
    else
    begin
      m_nLongAttackCount := 0;
      if (Random(18) <= 1) then
      begin
        if (m_TargetCret.m_PEnvir = m_PEnvir) then
          SetTargetXY(m_TargetCret.m_nCurrX + ((Random(3) - 1) * 2), m_TargetCret.m_nCurrY + ((Random(3) - 1) * 2))
        else
          DelTargetCreat();
      end
      else if GetAttackDir(m_TargetCret, btDir) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          if g_Config.boHeroDoMotaebo then
          begin
            if (GetTickCount - m_dwDoMotaeboTick) > 6 * 1000 then
            begin
              if (m_WAbil.Level > m_TargetCret.m_WAbil.Level) and not m_TargetCret.m_boStickMode then
              begin
                m_dwDoMotaeboTick := GetTickCount();
                m_btDirection := btDir;
                TPlayObject(self).DoMotaebo(m_btDirection, UserMagic.btLevel);
                goto lEXIT;
              end;
            end;
          end;
          if Integer(GetTickCount - m_dwMag41Tick) > 10 * 1000 then
          begin
            m_dwMag41Tick := GetTickCount();
            if GetTagXYRangeCount(1, 3) > 2 then
            begin
              m_nCurMagId := 41;
              UserMagic := MonGetMagicInfo();
              if UserMagic <> nil then
                Result := TPlayObject(self).DoSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret, boTrainOk);
              goto lEXIT;
            end;
          end;
          m_nCurMagId := g_Config.nHeroMainSkill;
          m_boUseThrusting := True;
          if Random(10) = 0 then
          begin
            m_nCurMagId := 7;
            m_boPowerHit := True;
          end;
          if (GetTickCount - m_dwLatestFireHitTick) > g_Config.nHeroFireSwordTime then
          begin
            m_dwLatestFireHitTick := GetTickCount();
            m_nCurMagId := 26;
            m_boFireHitSkill := True;
          end;
          lAttack:
          case m_nCurMagId of
            7: nHitMode := 3; //攻杀剑术
            12: nHitMode := 4; //刺杀剑术
            25: nHitMode := 5; //半月弯刀
            26: nHitMode := 7; //烈火剑法
          else
            nHitMode := 0;
          end;
          if nHitMode in [0, 3, 4, 5, 7] then AttackDir(m_TargetCret, nHitMode, btDir);
          lEXIT:
          BreakHolySeizeMode();
        end;
        Result := True;
      end
      else
      begin
        if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 3) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 3)) then
        begin
          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
          begin
            m_dwHitTick := GetTickCount();
            m_dwTargetFocusTick := GetTickCount();
            nMapRangeCount := GetTagXYRangeCount(0, 1);
            if nMapRangeCount > 3 then
            begin
              if not (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_Abil.Level + 8 < m_Abil.Level) then
              begin
                m_nCurMagId := 71;
                goto lNext;
              end;
            end;
            if nMapRangeCount > 2 then
              m_nCurMagId := 39;
            lNext:
            UserMagic := MonGetMagicInfo();
            if UserMagic <> nil then
              Result := TPlayObject(self).DoSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret, boTrainOk);
            BreakHolySeizeMode();
          end;
        end;
        if m_TargetCret.m_PEnvir = m_PEnvir then
          SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
        else
          DelTargetCreat();
      end;
    end;
  end;

  procedure AutoDoSpell_Wizard(UserMagic: pTUserMagic);
  var
    boTrainOk: Boolean;
    btDir: byte;
    nX, nY: Integer;
    nNX, nNY: Integer;
    nTX, nTY, nAbsX, nAbsY: Integer;
  label
    LabelBackUp, LabelDoSpell;
  begin
    if m_TargetCret <> nil then
    begin
      nAbsX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
      nAbsY := abs(m_nCurrY - m_TargetCret.m_nCurrY);
      if (nAbsX > 2) or (nAbsY > 2) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          if Random(10) = 0 then
            goto LabelBackUp;
          if m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] <= 0 then
          begin
            m_nCurMagId := 31;
            goto LabelDoSpell;
          end;

          if m_MagicArr[0][10] <> nil then
          begin
            btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
            if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then
            begin
              m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 8, nTX, nTY);
              if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) >= 3 then
              begin
                m_nCurMagId := 10;
                goto LabelDoSpell;
              end;
            end;
          end;

          if GetTagXYRangeCount(0, 1) > 1 then
          begin
            if Random(10) > 4 then
              m_nCurMagId := 33
            else
              m_nCurMagId := 47;
          end
          else
          begin
            if Random(10) >= 4 then
              m_nCurMagId := 11
            else
              m_nCurMagId := 45;
            if (m_TargetCret.m_Abil.Level < 50) and (m_TargetCret.m_Abil.Level + 10 < m_Abil.Level) and (m_TargetCret.m_btLifeAttrib = LA_UNDEAD) then
              m_nCurMagId := 32;
            if (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_btJob = 0) and (Random(10) > 6) and (m_TargetCret.m_Abil.Level + 5 < m_Abil.Level) then
              m_nCurMagId := 44;
          end;
          LabelDoSpell:
          UserMagic := MonGetMagicInfo();
          if UserMagic <> nil then
            Result := TPlayObject(self).DoSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret, boTrainOk)
          else
            SetUseNormAttack();
          BreakHolySeizeMode();
          if (m_TargetCret <> nil) and (m_TargetCret.m_PEnvir <> nil) and (m_PEnvir <> nil) and (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(m_nCurrX - m_TargetCret.m_nCurrX) >= 5) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) >= 5)) then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          else
            DelTargetCreat();
        end;
      end
      else
      begin
        if (nAbsX <= 1) and (nAbsY <= 1) and (Random(3) = 0) then
        begin
          if (m_TargetCret.m_Abil.Level < m_Abil.Level) and (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
          begin
            m_dwHitTick := GetTickCount();
            m_dwTargetFocusTick := GetTickCount();
            if Random(3) = 0 then
              m_nCurMagId := 24
            else
              m_nCurMagId := 8;
            goto LabelDoSpell;
          end;
        end
        else if (Random(8) > 5) and (Round(m_Abil.HP / m_Abil.MaxHP * 100) > 30) then
        begin
          if (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
          begin
            m_dwHitTick := GetTickCount();
            m_dwTargetFocusTick := GetTickCount();
            m_nCurMagId := 24;
            goto LabelDoSpell;
          end;
        end
        else
        begin
          LabelBackUp:
          if Random(10) = 0 then
            GetBackPosition(nX, nY)
          else
            GetBackPositionEx(nX, nY);
          if (m_Master <> nil) then
          begin
            if ((m_TargetCret.m_PEnvir = m_PEnvir) and (nAbsX < 10) and (nAbsY < 10)) then
              SetTargetXY(nX, nY)
            else
              DelTargetCreat();
          end
          else
          begin
            if (m_TargetCret.m_PEnvir = m_PEnvir) then
              SetTargetXY(nX, nY)
            else
              DelTargetCreat();
          end;
        end;
      end;
    end;
  end;

  procedure AutoDoSpell_Taos(UserMagic: pTUserMagic);
  var
    boTrainOk: Boolean;
    nX, nY: Integer;
    nCurrX, nCurrY: Integer;
    TargetCret: TBaseObject;
    borunaway: Boolean;
  label
    LabelBackUp;
  begin
    borunaway := False;
    case m_SetUseMagic of
      t_AddHP_M, t_Defence_m, t_Defence_m_m, t_UNAMYOUNSUL:
        begin
          if m_Master <> nil then
          begin
            nCurrX := m_Master.m_nCurrX;
            nCurrY := m_Master.m_nCurrY;
            TargetCret := m_Master;
          end;
          borunaway := (m_TargetCret <> nil);
        end;
      t_UNAMYOUNSULSELF, t_AddHP_S, t_Defence_s, t_Defence_s_m, t_MobSlave, t_SCDouble:
        begin
          nCurrX := m_nCurrX;
          nCurrY := m_nCurrY;
          TargetCret := self;
          borunaway := (m_TargetCret <> nil);
        end;
      t_Attack, t_Poison_0, t_Poison_1:
        begin
          if m_TargetCret <> nil then
          begin
            nCurrX := m_TargetCret.m_nCurrX;
            nCurrY := m_TargetCret.m_nCurrY;
            TargetCret := m_TargetCret;
            borunaway := True;
          end;
        end;
    end;
    if not borunaway then
    begin
      if Integer(GetTickCount - m_dwHitTick) > (m_nNextHitTime * 2) then
      begin
        m_dwHitTick := GetTickCount();
        Result := TPlayObject(self).DoSpell(UserMagic, nCurrX, nCurrY, TargetCret, boTrainOk);
        BreakHolySeizeMode();
        if m_TargetCret <> nil then
        begin
          if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 4) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 4)) then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          else
            DelTargetCreat();
        end;
      end;
    end
    else
    begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 2) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 2) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          if Random(12) = 0 then
            goto LabelBackUp;
          Result := TPlayObject(self).DoSpell(UserMagic, nCurrX, nCurrY, TargetCret, boTrainOk);
          if m_SetUseMagic = t_Poison_0 then
            if g_Config.boHeroNeedAmulet then
              TakeOnItem(2, '黄色药粉(大量)')
            else
              ; //m_btUseAmulet := 2;
          if m_SetUseMagic = t_Poison_1 then
            if g_Config.boHeroNeedAmulet then
              TakeOnItem(2, '灰色药粉(大量)')
            else
              ; //m_btUseAmulet := 1;
          BreakHolySeizeMode();
          if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 3) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 3)) then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          else
            DelTargetCreat();
        end;
      end
      else
      begin
        if (m_TargetCret.m_Abil.Level < m_Abil.Level) and ((abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 1) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 1)) then
        begin
          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
          begin
            m_dwHitTick := GetTickCount();
            m_dwTargetFocusTick := GetTickCount();
            m_nCurMagId := 48;
            UserMagic := MonGetMagicInfo();
            if UserMagic <> nil then
              Result := TPlayObject(self).DoSpell(UserMagic, nCurrX, nCurrY, TargetCret, boTrainOk);
            BreakHolySeizeMode();
            if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 4) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 4)) then
              SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
            else
              DelTargetCreat();
          end;
        end
        else
        begin
          LabelBackUp:
          if Random(10) = 0 then
            GetBackPosition(nX, nY)
          else
            GetBackPositionEx(nX, nY);
          if m_Master <> nil then
          begin
            if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(nX - m_Master.m_nCurrX) < 10) and (abs(nY - m_Master.m_nCurrY) < 10)) then
              SetTargetXY(nX, nY)
            else
              DelTargetCreat();
          end
          else
          begin
            if (m_TargetCret.m_PEnvir = m_PEnvir) then
              SetTargetXY(nX, nY)
            else
              DelTargetCreat();
          end;
        end;
      end;
    end;
  end;

var
  UserMagic: pTUserMagic;
begin
  Result := False;
  UserMagic := nil;
  case m_btJob of
    0:
      begin
        if m_TargetCret <> nil then
        begin
          m_nCurMagId := 25;
          UserMagic := MonGetMagicInfo();
          if UserMagic <> nil then
            Warr_SetUseMagic(UserMagic)
          else
            SetUseNormAttack();
        end;
      end;
    1:
      begin
        AutoDoSpell_Wizard(UserMagic);
      end;
    2:
      begin
        UserMagic := Taos_SetUseMagicFirst();
        if UserMagic = nil then
          UserMagic := Taos_SetUseMagic();
        if UserMagic <> nil then
          AutoDoSpell_Taos(UserMagic)
        else if m_TargetCret <> nil then
          SetUseNormAttack();
      end;
  end;
end;

procedure TPlayMonster.Run();

{procedure SearchTarget_Ex();
begin
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) then begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
end; }

var
  nX, nY: Integer;
begin
  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Think() then
    begin
      //SearchTarget_Ex();
      inherited;
      Exit;
    end;
    if m_boWalkWaitLocked and ((GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait) then
      m_boWalkWaitLocked := False;

    if not m_boWalkWaitLocked and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
    begin
      m_dwWalkTick := GetTickCount();
      Inc(m_nWalkCount);
      if m_nWalkCount > m_nWalkStep then
      begin
        m_nWalkCount := 0;
        m_boWalkWaitLocked := True;
        m_dwWalkWaitTick := GetTickCount();
      end;

      if AttackTarget() then
      begin
        //SearchTarget_Ex();
        inherited;
        Exit;
      end;

      if m_Master <> nil then
      begin
        if m_TargetCret = nil then
        begin
          m_Master.GetBackPositionEx(nX, nY);
          if (abs(m_nCurrX - nX) > 1) or (abs(m_nCurrY - nY) > 1) then
          begin
            m_nTargetX := nX + Random(3) - 1;
            m_nTargetY := nY + Random(3) - 1;
            if (abs(m_nCurrX - m_nTargetX) <= 2) and (abs(m_nCurrY - m_nTargetY) <= 2) then
            begin
              if m_PEnvir.GetMovingObject(m_nTargetX, m_nTargetX, True) <> nil then
              begin
                m_nTargetX := m_nCurrX;
                m_nTargetY := m_nCurrY;
              end
            end;
          end;
        end;
        if (not m_Master.m_boSlaveRelax) and ((m_PEnvir <> m_Master.m_PEnvir) or (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then
        begin
          if m_Master.m_PEnvir <> nil then
            SpaceMove(m_Master.m_PEnvir.m_sMapFileName, m_nTargetX, m_nTargetY, 1);
        end;
      end;
      if (m_Master <> nil) and m_Master.m_boSlaveRelax then
      begin
        inherited;
        Exit;
      end;
      if m_nTargetX <> -1 then
      begin
        if (abs(m_nCurrX - m_nTargetX) > 1) or (abs(m_nCurrY - m_nTargetY) > 1) then
        begin
          if not RuntoTargetXY(GetNextDirection(m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY), False) then
            GotoTargetXY();
        end
        else
          GotoTargetXY();
      end
      else if m_TargetCret = nil then
        Wondering();
    end;
  end;
  //SearchTarget_Ex();
  inherited;
end;

constructor THeroMonster.Create();
begin
  inherited;
  m_boWantRefMsg := False;
  m_boDupMode := False;
  m_dwThinkTick := GetTickCount();
  m_dwCheckStutasTick := GetTickCount();
  m_nViewRangeX := 8;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 300;
  m_dwSearchTime := 2000 + Random(2000);
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := RC_HERO;
  m_dwMag41Tick := 0;
  m_nCurMagId := 0;
{$IF VER_ClientType_45}
  m_wClientType := 46;
{$IFEND VER_ClientType_45}
end;

destructor THeroMonster.Destroy();
begin
  inherited;
end;

function THeroMonster.AttackTarget(): Boolean;

  function TakeOnItem(nType: Integer; sItemName: string): Boolean;
  var
    UserItem: TUserItem;
  begin
    Result := False;

    if UserEngine.CopyToUserItemFromName(sItemName, @UserItem) then
    begin
      if nType = 1 then
        m_UseItems[U_ARMRINGL] := UserItem
      else
        m_UseItems[U_BUJUK] := UserItem;
      Result := True;
    end;
  end;

  function Taos_SetUseMagicFirst(): pTUserMagic;
  var
    nAmuletIdx: Integer;
    UserMagic: pTUserMagic;
  begin
    Result := nil;
    UserMagic := nil;
    m_SetUseMagic := t_Norm;
    //if g_Config.nRegCheckCode < 0 then Exit;
    if g_Config.boAllowBodyMakeSlave and (m_Master <> nil) {and (TPlayObject(m_Master).m_btHeroMakeSlave <> 0)} then
    begin
      if g_Config.boHeroNeedAmulet then
      begin
        if CheckAmulet(TPlayObject(self), 1, 1, nAmuletIdx) then
        begin
          if UserEngine.GetStdItem(m_UseItems[nAmuletIdx].wIndex) <> nil then
          begin
            if m_SetUseMagic = t_Norm then
            begin
              UserMagic := m_MagicArr[0][30]; //TPlayObject(self).GetMagicInfo(30);
              if UserMagic = nil then
                UserMagic := m_MagicArr[0][17]; //TPlayObject(self).GetMagicInfo(17);
              if (UserMagic <> nil) and (m_SlaveList.Count <= 0) then
                m_SetUseMagic := t_MobSlave;
            end;
            if m_SetUseMagic = t_MobSlave then
              Result := UserMagic;
          end;
        end
        else
          TakeOnItem(1, '护身符(大)');
      end
      else
      begin
        if m_SetUseMagic = t_Norm then
        begin
          UserMagic := m_MagicArr[0][30]; //TPlayObject(self).GetMagicInfo(30);
          if UserMagic = nil then
            UserMagic := m_MagicArr[0][17]; //TPlayObject(self).GetMagicInfo(17);
          if (UserMagic <> nil) and (m_SlaveList.Count <= 0) then
            m_SetUseMagic := t_MobSlave;
        end;
        if m_SetUseMagic = t_MobSlave then
          Result := UserMagic;
      end;
    end;
  end;

  function Taos_SetUseMagic(): pTUserMagic;
  var
    i, nAmuletIdx: Integer;
    UserMagic: pTUserMagic;
    boReadMagic: Boolean;
    StdItem: pTStdItem;
  label
    sLabel;
  begin
    Result := nil;
    m_SetUseMagic := t_Norm;

    if (m_TargetCret = nil) then
    begin
      if m_Master <> nil then
      begin
        if (m_Master.m_wStatusTimeArr[POISON_DECHEALTH] <> 0) or
          (m_Master.m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0) or
          (m_Master.m_wStatusTimeArr[POISON_STONE] <> 0) then
        begin
          m_SetUseMagic := t_UNAMYOUNSUL;
        end;
      end;
      if (m_SetUseMagic = t_Norm) then
      begin
        if (m_wStatusTimeArr[POISON_DECHEALTH] <> 0) or
          (m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0) or
          (m_wStatusTimeArr[POISON_STONE] <> 0) then
        begin
          m_SetUseMagic := t_UNAMYOUNSULSELF;
        end;
      end;
    end;
    if (m_SetUseMagic = t_Norm) and (Round(m_Master.m_WAbil.HP / m_Master.m_WAbil.MaxHP * 100) <= 60) and (m_SetUseMagic <> t_AddHP_M) then
      m_SetUseMagic := t_AddHP_M;

    if (m_SetUseMagic = t_Norm) then
    begin
      if g_Config.boHeroNeedAmulet then
      begin
        if CheckAmulet(TPlayObject(self), 1, 1, nAmuletIdx) then
        begin
          if (m_Master.m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) and (m_SetUseMagic <> t_Defence_m) then
            m_SetUseMagic := t_Defence_m;
          if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_m_m) and (m_Master.m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then
            m_SetUseMagic := t_Defence_m_m;
          if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_s) and (m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) then
            m_SetUseMagic := t_Defence_s;
          if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_s_m) and (m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then
            m_SetUseMagic := t_Defence_s_m;
          if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_SCDouble) and (m_wStatusArrValue[2] <= 0) then
            m_SetUseMagic := t_SCDouble;
        end
        else
          TakeOnItem(1, '护身符(大)');
      end
      else
      begin
        if (m_Master.m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) and (m_SetUseMagic <> t_Defence_m) then
          m_SetUseMagic := t_Defence_m;
        if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_m_m) and (m_Master.m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then
          m_SetUseMagic := t_Defence_m_m;
        if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_s) and (m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) then
          m_SetUseMagic := t_Defence_s;
        if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_Defence_s_m) and (m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then
          m_SetUseMagic := t_Defence_s_m;
        if (m_SetUseMagic = t_Norm) and (m_SetUseMagic <> t_SCDouble) and (m_wStatusArrValue[2] <= 0) then
          m_SetUseMagic := t_SCDouble;
      end;
    end;
    if (m_SetUseMagic = t_Norm) then
    begin
      if g_Config.boHeroNeedAmulet then
      begin
        if CheckAmulet(TPlayObject(self), 1, 2, nAmuletIdx) then
        begin
          StdItem := UserEngine.GetStdItem(m_UseItems[nAmuletIdx].wIndex);
          if (m_TargetCret <> nil) and (StdItem <> nil) then
          begin
            if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] <= 0) and (StdItem.Shape = 1) then
              m_SetUseMagic := t_Poison_0;
            if (m_SetUseMagic = t_Norm) and (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] <= 0) and (StdItem.Shape = 2) then
              m_SetUseMagic := t_Poison_1;
          end;
        end
        else
          TakeOnItem(2, '灰色药粉(大量)');
      end
      else
      begin
        if (m_TargetCret <> nil) then
        begin
          if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] <= 0) then
          begin
            m_btUseAmulet := 1;
            m_SetUseMagic := t_Poison_0;
          end;
          if (m_SetUseMagic = t_Norm) and (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] <= 0) then
          begin
            m_btUseAmulet := 2;
            m_SetUseMagic := t_Poison_1;
          end;
        end;
      end;
    end;
    if (m_SetUseMagic = t_Norm) then
      m_SetUseMagic := t_Attack;
    boReadMagic := False;
    for i := 0 to m_MagicList.Count - 1 do
    begin
      UserMagic := m_MagicList.Items[i];
      case m_SetUseMagic of
        t_UNAMYOUNSUL, t_UNAMYOUNSULSELF: boReadMagic := (UserMagic.wMagIdx = 34);
        t_AddHP_M, t_AddHP_S: boReadMagic := (UserMagic.wMagIdx = 2);
        t_Defence_m_m, t_Defence_s_m: boReadMagic := (UserMagic.wMagIdx = 14);
        t_Defence_m, t_Defence_s: boReadMagic := (UserMagic.wMagIdx = 15);
        t_Attack: boReadMagic := ((UserMagic.wMagIdx = 13) and (m_TargetCret <> nil) {and MagCanHitTarget(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret)});
        t_Poison_0, t_Poison_1:
          begin
            if GetTagXYRangeCount(0, 1) > 2 then
              boReadMagic := (UserMagic.wMagIdx = 38)
            else
              boReadMagic := (UserMagic.wMagIdx = 6);
          end;
        t_SCDouble:
          begin
            boReadMagic := (UserMagic.wMagIdx = 50);
          end;
      end;
      if boReadMagic then
      begin
        Result := UserMagic;
        Break;
      end;
    end;
  end;

  function MonGetMagicInfo(): pTUserMagic;
  begin
    Result := m_MagicArr[0][m_nCurMagId]; //TPlayObject(self).GetMagicInfo(m_nCurMagId);
  end;

  procedure Warr_SetUseMagic(UserMagic: pTUserMagic);
  var
    boTrainOk: Boolean;
    btDir: byte;
    nHitMode, nMapRangeCount: Integer;
  label
    LabelExit, LabelDoSpell, LabelStartAttack;
  begin
    Result := False;
    nHitMode := 0;

    if (m_MagicArr[0][12] <> nil) and GetLongAttackDir(m_TargetCret, btDir) and (m_nLongAttackCount <= _MAX(1, Random(5))) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        Inc(m_nLongAttackCount);
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        nHitMode := 4;
        m_boUseThrusting := True;
        //goto LabelStartAttack;
        //if nHitMode in [0, 3, 4, 5, 7] then
        AttackDir(nil, nHitMode, btDir);
        BreakHolySeizeMode();
        Exit;
      end;
    end;
    m_nLongAttackCount := 0;
    if m_boLongAttack or (Random(12) <= 1) then
    begin
      if (m_TargetCret.m_PEnvir = m_PEnvir) then
        SetTargetXY(m_TargetCret.m_nCurrX + ((Random(3) - 1) * 2), m_TargetCret.m_nCurrY + ((Random(3) - 1) * 2))
      else
        DelTargetCreat();
    end
    else
    begin
      if GetAttackDir(m_TargetCret, btDir) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          m_nCurMagId := SKILL_MOOTEBO;
          UserMagic := MonGetMagicInfo();
          if (UserMagic <> nil) and (m_WAbil.Level > m_TargetCret.m_WAbil.Level) and not m_TargetCret.m_boStickMode then
          begin
            if (GetTickCount - m_dwDoMotaeboTick) > (6 * 1000 + Random(5 * 1000)) then
            begin
              m_dwDoMotaeboTick := GetTickCount();
              m_btDirection := btDir;
              Result := TPlayObject(self).DoMotaebo(m_btDirection, UserMagic.btLevel);
              goto LabelExit;
            end;
          end;

          if Integer(GetTickCount - m_dwMag41Tick) > (8 * 1000 + Random(8 * 1000)) then
          begin
            m_dwMag41Tick := GetTickCount();
            m_nCurMagId := 41;
            UserMagic := MonGetMagicInfo();
            if (UserMagic <> nil) and (GetTagXYRangeCount(1, 3) > 2) then
            begin
              Result := TPlayObject(self).DoSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret, boTrainOk);
              goto LabelExit;
            end;
          end;

          if (m_MagicArr[0][SKILL_YEDO] {m_MagicPowerHitSkill} <> nil) and (m_UseItems[U_WEAPON].Dura > 0) and (Random(9) = 0) then
          begin
            nHitMode := 3;
            m_boPowerHit := True;
            goto LabelStartAttack;
          end;

          if (m_MagicArr[0][SKILL_BANWOL] {m_MagicBanwolSkill} <> nil) and (m_Abil.MP >= 3) and TargetInSwordWideAttackRange then
          begin
            nHitMode := 5;
            goto LabelStartAttack;
          end;

          if (m_MagicArr[0][SKILL_ERGUM] {m_MagicErgumSkill} <> nil) and TargetInSwordLongAttackRange then
          begin
            nHitMode := 4;
            m_boUseThrusting := True;
            goto LabelStartAttack;
          end;

          if (m_MagicArr[0][SKILL_FIRESWORD] {m_MagicFireSwordSkill} <> nil) and ((GetTickCount - m_dwLatestFireHitTick) > g_Config.nHeroFireSwordTime) then
          begin
            m_dwLatestFireHitTick := GetTickCount();
            nHitMode := 7;
            m_boFireHitSkill := True;
            goto LabelStartAttack;
          end;

          LabelStartAttack:
          if nHitMode in [0, 3, 4, 5, 7] then
            AttackDir(m_TargetCret, nHitMode, btDir);
          LabelExit:
          BreakHolySeizeMode();
        end;
        Result := True;
      end
      else
      begin
        if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 3) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 3)) then
        begin
          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
          begin
            m_dwHitTick := GetTickCount();
            m_dwTargetFocusTick := GetTickCount();
            nMapRangeCount := GetTagXYRangeCount(0, 1);
            if nMapRangeCount > 3 then
            begin
              if not (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_Abil.Level + 8 < m_Abil.Level) then
              begin
                m_nCurMagId := 71;
                UserMagic := MonGetMagicInfo();
                goto LabelDoSpell;
              end;
            end;
            if nMapRangeCount > 2 then
              m_nCurMagId := 39;
            UserMagic := MonGetMagicInfo();
            LabelDoSpell:
            if UserMagic <> nil then
              Result := TPlayObject(self).DoSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret, boTrainOk);
            BreakHolySeizeMode();
          end;
        end;
        if m_TargetCret.m_PEnvir = m_PEnvir then
          SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
        else
          DelTargetCreat();
      end;
    end;
  end;

  procedure AutoDoSpell_Wizard(UserMagic: pTUserMagic);
  var
    boTrainOk: Boolean;
    btDir: byte;
    nX, nY: Integer;
    nNX, nNY: Integer;
    nTX, nTY, nAbsX, nAbsY: Integer;
  label
    LabelBackUp, LabelDoSpell;
  begin
    if m_TargetCret <> nil then
    begin
      nAbsX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
      nAbsY := abs(m_nCurrY - m_TargetCret.m_nCurrY);
      if (nAbsX > 2) or (nAbsY > 2) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          if Random(10) = 0 then
            goto LabelBackUp;
          if m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] <= 0 then
          begin
            m_nCurMagId := 31;
            goto LabelDoSpell;
          end;
          if m_MagicArr[0][10] <> nil then
          begin
            btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
            if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then
            begin
              m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 8, nTX, nTY);
              if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) >= 3 then
              begin
                m_nCurMagId := 10;
                goto LabelDoSpell;
              end;
            end;
          end;
          if GetTagXYRangeCount(0, 1) > 1 then
          begin
            if Random(10) > 4 then
              m_nCurMagId := 33
            else
              m_nCurMagId := 47;
          end
          else
          begin
            if Random(10) >= 4 then
              m_nCurMagId := 11
            else
              m_nCurMagId := 45;
            if (m_TargetCret.m_Abil.Level < 50) and (m_TargetCret.m_Abil.Level + 10 < m_Abil.Level) and (m_TargetCret.m_btLifeAttrib = LA_UNDEAD) then
              m_nCurMagId := 32;
            if (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_btJob = 0) and (Random(10) > 6) and (m_TargetCret.m_Abil.Level + 5 < m_Abil.Level) then
              m_nCurMagId := 44;
          end;
          LabelDoSpell:
          UserMagic := MonGetMagicInfo();
          if UserMagic <> nil then
            Result := TPlayObject(self).DoSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret, boTrainOk)
          else
            SetUseNormAttack();
          BreakHolySeizeMode();
        end;
      end
      else
      begin
        if (nAbsX <= 1) and (nAbsY <= 1) and (Random(3) = 0) then
        begin
          if (m_TargetCret.m_Abil.Level < m_Abil.Level) and (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
          begin
            m_dwHitTick := GetTickCount();
            m_dwTargetFocusTick := GetTickCount();
            if Random(3) = 0 then
              m_nCurMagId := 24
            else
              m_nCurMagId := 8;
            goto LabelDoSpell;
          end;
        end
        else if (Random(3) = 0) and (Round(m_Abil.HP / m_Abil.MaxHP * 100) > 30) then
        begin
          if (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
          begin
            m_dwHitTick := GetTickCount();
            m_dwTargetFocusTick := GetTickCount();
            m_nCurMagId := 24;
            goto LabelDoSpell;
          end;
        end
        else
        begin
          LabelBackUp:
          if Random(10) = 0 then
            GetBackPosition(nX, nY)
          else
            GetBackPositionEx(nX, nY);
          if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(nX - m_Master.m_nCurrX) < 10) and (abs(nY - m_Master.m_nCurrY) < 10)) then
            SetTargetXY(nX, nY)
          else
            DelTargetCreat();
        end;
      end;
    end;
  end;

  procedure AutoDoSpell_Taos(UserMagic: pTUserMagic);
  var
    boTrainOk: Boolean;
    nX, nY: Integer;
    nCurrX, nCurrY: Integer;
    TargetCret: TBaseObject;
    borunaway: Boolean;
  label
    LabelBackUp;
  begin
    borunaway := False;
    case m_SetUseMagic of
      t_AddHP_M, t_Defence_m, t_Defence_m_m, t_UNAMYOUNSUL:
        begin
          if m_Master <> nil then
          begin
            nCurrX := m_Master.m_nCurrX;
            nCurrY := m_Master.m_nCurrY;
            TargetCret := m_Master;
          end;
          borunaway := (m_TargetCret <> nil);
        end;
      t_UNAMYOUNSULSELF, t_AddHP_S, t_Defence_s, t_Defence_s_m, t_MobSlave, t_SCDouble:
        begin
          nCurrX := m_nCurrX;
          nCurrY := m_nCurrY;
          TargetCret := self;
          borunaway := (m_TargetCret <> nil);
        end;
      t_Attack, t_Poison_0, t_Poison_1:
        begin
          if m_TargetCret <> nil then
          begin
            nCurrX := m_TargetCret.m_nCurrX;
            nCurrY := m_TargetCret.m_nCurrY;
            TargetCret := m_TargetCret;
            borunaway := True;
          end;
        end;
    end;
    if not borunaway then
    begin
      if Integer(GetTickCount - m_dwHitTick) > (m_nNextHitTime * 2) then
      begin
        m_dwHitTick := GetTickCount();
        Result := TPlayObject(self).DoSpell(UserMagic, nCurrX, nCurrY, TargetCret, boTrainOk);
        BreakHolySeizeMode();
      end;
    end
    else
    begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 2) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 2) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          if Random(12) = 0 then
            goto LabelBackUp;
          Result := TPlayObject(self).DoSpell(UserMagic, nCurrX, nCurrY, TargetCret, boTrainOk);
          if m_SetUseMagic = t_Poison_0 then
            TakeOnItem(2, '黄色药粉(大量)');
          if m_SetUseMagic = t_Poison_1 then
            TakeOnItem(2, '灰色药粉(大量)');
          BreakHolySeizeMode();
        end;
      end
      else
      begin
        if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 1) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 1)) and (m_TargetCret.m_Abil.Level < m_Abil.Level) then
        begin
          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
          begin
            m_dwHitTick := GetTickCount();
            m_dwTargetFocusTick := GetTickCount();
            m_nCurMagId := 48;
            UserMagic := MonGetMagicInfo();
            if UserMagic <> nil then
              Result := TPlayObject(self).DoSpell(UserMagic, nCurrX, nCurrY, TargetCret, boTrainOk);
            BreakHolySeizeMode();
          end;
        end
        else
        begin
          LabelBackUp:
          if Random(10) = 0 then
            GetBackPosition(nX, nY)
          else
            GetBackPositionEx(nX, nY);
          if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(nX - m_Master.m_nCurrX) < 10) and (abs(nY - m_Master.m_nCurrY) < 10)) then
          begin
            SetTargetXY(nX, nY);
          end
          else
            DelTargetCreat();
        end;
      end;
    end;
  end;

var
  UserMagic: pTUserMagic;
begin
  Result := False;
  UserMagic := nil;
  case m_btJob of
    0:
      begin
        if m_TargetCret <> nil then
        begin
          m_nCurMagId := 25;
          UserMagic := MonGetMagicInfo();
          if UserMagic <> nil then
            Warr_SetUseMagic(UserMagic)
          else
            SetUseNormAttack();
        end;
      end;
    1:
      begin
        //UserMagic := Wizard_SetUseMagic();
        //if UserMagic = nil then begin
        //  m_nCurMagId := 11;
        //  UserMagic := MonGetMagicInfo();
        //end;
        //if UserMagic <> nil then
        AutoDoSpell_Wizard(UserMagic);
        //else if m_TargetCret <> nil then
        //SetUseNormAttack();
      end;
    2:
      begin
        UserMagic := Taos_SetUseMagicFirst();
        if UserMagic = nil then
          UserMagic := Taos_SetUseMagic();
        if UserMagic <> nil then
          AutoDoSpell_Taos(UserMagic)
        else if m_TargetCret <> nil then
          SetUseNormAttack();
      end;
  end;
end;

procedure THeroMonster.Run();
var
  nX, nY: Integer;
begin
  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Think() then
    begin
      inherited;
      Exit;
    end;

    if m_boWalkWaitLocked and ((GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait) then
      m_boWalkWaitLocked := False;
    if not m_boWalkWaitLocked and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
    begin
      m_dwWalkTick := GetTickCount();
      Inc(m_nWalkCount);
      if m_nWalkCount > m_nWalkStep then
      begin
        m_nWalkCount := 0;
        m_boWalkWaitLocked := True;
        m_dwWalkWaitTick := GetTickCount();
      end;
      if (m_Master <> nil) and not m_Master.m_boSlaveRelax then
      begin
        if AttackTarget then
        begin
          inherited;
          Exit;
        end;
      end;
      if m_Master <> nil then
      begin
        if m_TargetCret = nil then
        begin
          m_Master.GetBackPositionEx(nX, nY);
          if (abs(m_nCurrX - nX) > 1) or (abs(m_nCurrY - nY) > 1) then
          begin
            m_nTargetX := nX + Random(3) - 1;
            m_nTargetY := nY + Random(3) - 1;
            if (abs(m_nCurrX - m_nTargetX) <= 2) and (abs(m_nCurrY - m_nTargetY) <= 2) then
            begin
              if m_PEnvir.GetMovingObject(m_nTargetX, m_nTargetX, True) <> nil then
              begin
                m_nTargetX := m_nCurrX;
                m_nTargetY := m_nCurrY;
              end
            end;
          end;
        end;
        if (not m_Master.m_boSlaveRelax) and ((m_PEnvir <> m_Master.m_PEnvir) or (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then
          if m_Master.m_PEnvir <> nil then
            SpaceMove(m_Master.m_PEnvir.m_sMapFileName, m_nTargetX, m_nTargetY, 1);
      end;
      if (m_Master <> nil) and m_Master.m_boSlaveRelax then
      begin
        inherited;
        Exit;
      end;
      //if (m_Master <> nil) and (m_TargetCret = nil) then MonPickItem();
      if m_nTargetX <> -1 then
      begin
        if (abs(m_nCurrX - m_nTargetX) > 1) or (abs(m_nCurrY - m_nTargetY) > 1) then
        begin
          if not RuntoTargetXY(GetNextDirection(m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY), False) then
            GotoTargetXY();
        end
        else
          GotoTargetXY();
      end
      else if m_TargetCret = nil then
        Wondering();
    end;
  end;
  inherited;
end;

{ TMonster }

constructor TMonster.Create;
begin
  inherited;
  m_boDupMode := False;
  m_dwThinkTick := GetTickCount();
  m_nViewRangeX := 5;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := 3000 + Random(2000);
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 80;
  m_boApproach := True;
end;

destructor TMonster.Destroy;
begin
  inherited;
end;

function TMonster.MakeClone(sMonName: string; OldMon: TBaseObject): TBaseObject;
var
  ElfMon: TBaseObject;
begin
  Result := nil;
  ElfMon := UserEngine.RegenMonsterByName(m_PEnvir.m_sMapFileName, m_nCurrX, m_nCurrY, sMonName);
  if ElfMon <> nil then
  begin
    ElfMon.m_Master := OldMon.m_Master;
    ElfMon.m_dwMasterRoyaltyTick := OldMon.m_dwMasterRoyaltyTick;
    ElfMon.m_btSlaveMakeLevel := OldMon.m_btSlaveMakeLevel;
    ElfMon.m_btSlaveExpLevel := OldMon.m_btSlaveExpLevel;
    ElfMon.RecalcAbilitys;
    ElfMon.RefNameColor;
    if OldMon.m_Master <> nil then
      OldMon.m_Master.m_SlaveList.Add(ElfMon);
    ElfMon.m_WAbil := OldMon.m_WAbil;
    ElfMon.m_wStatusTimeArr := OldMon.m_wStatusTimeArr;
    ElfMon.m_TargetCret := OldMon.m_TargetCret;
    ElfMon.m_dwTargetFocusTick := OldMon.m_dwTargetFocusTick;
    ElfMon.m_LastHiter := OldMon.m_LastHiter;
    ElfMon.m_LastHiterTick := OldMon.m_LastHiterTick;
    ElfMon.m_btDirection := OldMon.m_btDirection;
    Result := ElfMon;
  end;
end;

function TMonster.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);
end;

function TMonster.Think(): Boolean;
var
  nOldX, nOldY: Integer;
begin
  Result := False;
  if (GetTickCount - m_dwThinkTick) > 3 * 1000 then
  begin
    m_dwThinkTick := GetTickCount();
    if not m_boStickMode and (m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2) then
      m_boDupMode := True;
    if not IsProperTarget(m_TargetCret) then
      m_TargetCret := nil;
  end;
  if m_boDupMode then
  begin
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    WalkTo(Random(8), False);
    if (nOldX <> m_nCurrX) or (nOldY <> m_nCurrY) then
    begin
      m_boDupMode := False;
      Result := True;
    end;
  end;
end;

function TMonster.AttackTarget(): Boolean; //004A8F34
var
  bt06: byte;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if GetAttackDir(m_TargetCret, bt06) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, bt06);
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
      else
        DelTargetCreat();
    end;
  end;
end;

procedure TMonster.Run;
var
  nX, nY: Integer;
begin
  if (m_TargetCret <> nil) and (m_TargetCret.m_boDeath or m_TargetCret.m_boGhost or ((m_TargetCret.m_PEnvir <> nil) and (m_PEnvir <> nil) and (m_TargetCret.m_PEnvir <> m_PEnvir)) or (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 15) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 15)) then
    m_TargetCret := nil;

  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin

    if (m_btRaceServer <> RC_MISSION) then
    begin
      if Think then
      begin
        inherited Run;
        Exit;
      end;
    end;

    if m_boWalkWaitLocked and ((GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait) then
      m_boWalkWaitLocked := False;

    if not m_boWalkWaitLocked and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
    begin
      m_dwWalkTick := GetTickCount();
      Inc(m_nWalkCount);
      if m_nWalkCount > m_nWalkStep then
      begin
        m_nWalkCount := 0;
        m_boWalkWaitLocked := True;
        m_dwWalkWaitTick := GetTickCount();
      end;
      if not m_boRunAwayMode then
      begin
        if not m_boNoAttackMode then
        begin
          if m_TargetCret <> nil then
          begin
            if AttackTarget then
            begin
              inherited;
              Exit;
            end;
          end
          else
          begin
            m_nTargetX := -1;
            if m_boMission then
            begin
              m_nTargetX := m_nMissionX;
              m_nTargetY := m_nMissionY;
            end;
          end;
        end;
        if m_Master <> nil then
        begin
          if m_TargetCret = nil then
          begin
            m_Master.GetBackPosition(nX, nY);
            if (abs(m_nTargetX - nX) > 1) or (abs(m_nTargetY - nY) > 1) then
            begin
              m_nTargetX := nX;
              m_nTargetY := nY;
              if (abs(m_nCurrX - nX) <= 2) and (abs(m_nCurrY - nY) <= 2) then
              begin
                if m_PEnvir.GetMovingObject(nX, nY, True) <> nil then
                begin
                  m_nTargetX := m_nCurrX;
                  m_nTargetY := m_nCurrY;
                end
              end;
            end;
          end;
          if (not m_Master.m_boSlaveRelax) and ((m_PEnvir <> m_Master.m_PEnvir) or (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then
            if m_Master.m_PEnvir <> nil then
              SpaceMove(m_Master.m_PEnvir.m_sMapFileName, m_nTargetX, m_nTargetY, 1);
        end;
      end
      else
      begin
        if (m_dwRunAwayTime > 0) and ((GetTickCount - m_dwRunAwayStart) > m_dwRunAwayTime) then
        begin
          m_boRunAwayMode := False;
          m_dwRunAwayTime := 0;
        end;
      end;
      if (m_Master <> nil) and m_Master.m_boSlaveRelax then
      begin
        inherited;
        Exit;
      end;
      if (m_Master <> nil) and (m_Master.m_btRaceServer = RC_HERO) then
      begin
        if (m_Master.m_Master <> nil) and (m_Master.m_Master.m_boSlaveRelax) then
        begin
          inherited;
          Exit;
        end;
      end;
      if (m_nTargetX <> -1) and ((m_boApproach) or (m_Master <> nil)) then
      begin //blue
        if (m_btRaceServer = RC_HERO) and ((abs(m_nCurrX - m_nTargetX) > 1) or (abs(m_nCurrY - m_nTargetY) > 1)) then
          RuntoTargetXY(GetNextDirection(m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY), False)
        else
          GotoTargetXY();
      end
      else if m_TargetCret = nil then
        Wondering();
    end;
  end;
  inherited Run;
end;

{$IF VER_PATHMAP = 1}
{TMissionMonster}

constructor TMissionMonster.Create;
begin
  inherited;
  m_nViewRangeX := 5;
  m_nViewRangeY := m_nViewRangeX;
  m_boNoAttackMode := True;
end;

destructor TMissionMonster.Destroy;
begin
  inherited;
end;

procedure TMissionMonster.Run;
begin
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed then
    begin
      //m_dwWalkTick := GetTickCount();
      m_nTargetX := -1;
      if m_boMission then
      begin
        m_nTargetX := m_nMissionX;
        m_nTargetY := m_nMissionY;
      end;
    end;
  end;
  inherited;
end;

{TMissionMonsterEx}

constructor TMissionMonsterEx.Create;
begin
  inherited;
  m_nViewRangeX := 5;
  m_nViewRangeY := m_nViewRangeX;
  m_boNoAttackMode := True;
  m_nMoveStep := 1;
  m_WayPoint := nil;
end;

destructor TMissionMonsterEx.Destroy;
begin
  inherited;
end;

procedure TMissionMonsterEx.Run;
begin
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed then
    begin
      m_nTargetX := -1;
      if m_boMission then
      begin
        if (m_nCurrX = m_nMissionX) and (m_nCurrY = m_nMissionY) then
        begin
          MakeGhost;
          inherited;
          Exit;
        end;
        if m_WayPoint <> nil then
        begin
          if m_nMoveStep <= High(m_WayPoint) then
          begin
            m_nTargetX := m_WayPoint[m_nMoveStep].X;
            m_nTargetY := m_WayPoint[m_nMoveStep].Y;
          end;
        end
        else
        begin
          m_nTargetX := m_nMissionX;
          m_nTargetY := m_nMissionY;
        end;
      end;
    end;
  end;
  inherited;
end;

function TMissionMonsterEx.WalkTo(btDir: byte; boFlag: Boolean): Boolean;
var
  nC, nOX, nOY, nNX, nNY, n20, n24: Integer;
  boTagOK: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TMissionMonsterEx::WalkTo Code:%d';
begin
  Result := False;
  nC := 0;
  if m_boHolySeize or (m_PEnvir = nil) then
    Exit;
  try
    nOX := m_nCurrX;
    nOY := m_nCurrY;
    m_btDirection := btDir;
    nNX := 0;
    nNY := 0;
    case btDir of
      DR_UP:
        begin
          nNX := m_nCurrX;
          nNY := m_nCurrY - 1;
        end;
      DR_UPRIGHT:
        begin
          nNX := m_nCurrX + 1;
          nNY := m_nCurrY - 1;
        end;
      DR_RIGHT:
        begin
          nNX := m_nCurrX + 1;
          nNY := m_nCurrY;
        end;
      DR_DOWNRIGHT:
        begin
          nNX := m_nCurrX + 1;
          nNY := m_nCurrY + 1;
        end;
      DR_DOWN:
        begin
          nNX := m_nCurrX;
          nNY := m_nCurrY + 1;
        end;
      DR_DOWNLEFT:
        begin
          nNX := m_nCurrX - 1;
          nNY := m_nCurrY + 1;
        end;
      DR_LEFT:
        begin
          nNX := m_nCurrX - 1;
          nNY := m_nCurrY;
        end;
      DR_UPLEFT:
        begin
          nNX := m_nCurrX - 1;
          nNY := m_nCurrY - 1;
        end;
    end;
    nC := 1;
    if (nNX >= 0) and ((m_PEnvir.m_MapHeader.wWidth - 1) >= nNX) and (nNY >= 0) and ((m_PEnvir.m_MapHeader.wHeight - 1) >= nNY) then
    begin
      boTagOK := True;
      nC := 2;
      if m_boSafeWalk and not m_PEnvir.CanSafeWalk(nNX, nNY) then
        boTagOK := False;
      nC := 3;
      if m_Master <> nil then
      begin
        m_Master.m_PEnvir.GetNextPosition(m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master.m_btDirection, 1, n20, n24);
        if (nNX = n20) and (nNY = n24) then
          boTagOK := False;
      end;
      nC := 4;
      if boTagOK then
      begin
        if m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, self, nNX, nNY, True) > 0 then
        begin
          m_nCurrX := nNX;
          m_nCurrY := nNY;
        end;
      end;
    end;
    nC := 5;
    if (m_nCurrX <> nOX) or (m_nCurrY <> nOY) then
    begin
      nC := 6;
      if Walk(RM_WALK) then
      begin
        nC := 7;
        if m_boTransparent and m_boHideMode then
          m_wStatusTimeArr[STATE_TRANSPARENT] := 1;

        if m_WayPoint <> nil then
        begin
          //
          Inc(m_nMoveStep);
        end;

        Result := True;
      end
      else
      begin
        nC := 8;
        if m_PEnvir.DeleteFromMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, self) = 1 then
        begin //0628
          m_nCurrX := nOX;
          m_nCurrY := nOY;
          m_PEnvir.AddToMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, self);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [nC]));
      MainOutMessageAPI(E.Message);
      KickException();
    end;
  end;
end;

{$IFEND}
{ TChickenDeer }

constructor TChickenDeer.Create;
begin
  inherited;
  m_nViewRangeX := 5;
  m_nViewRangeY := m_nViewRangeX;
end;

destructor TChickenDeer.Destroy;
begin
  inherited;
end;

procedure TChickenDeer.Run;
var
  i: Integer;
  nC, n10, n14: Integer;
  BaseObject1C, BaseObject: TBaseObject;
begin
  n10 := 9999;
  BaseObject := nil;
  BaseObject1C := nil;
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed then
    begin
      for i := 0 to m_VisibleActors.Count - 1 do
      begin
        BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
        if BaseObject.m_boDeath then
          Continue;
        if IsProperTarget(BaseObject) then
        begin
          if not BaseObject.m_boHideMode or m_boCoolEye then
          begin
            nC := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
            if nC < n10 then
            begin
              n10 := nC;
              BaseObject1C := BaseObject;
            end;
          end;
        end;
      end;
      if BaseObject1C <> nil then
      begin
        m_boRunAwayMode := True;
        m_TargetCret := BaseObject1C;
      end
      else
      begin
        m_boRunAwayMode := False;
        m_TargetCret := nil;
      end;
    end;
    if m_boRunAwayMode and
      (m_TargetCret <> nil) and
      (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then
    begin
      if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 6) and (abs(m_nCurrX - BaseObject.m_nCurrX) <= 6) then
      begin
        n14 := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
      end;
    end;
  end;
  inherited;
end;

{TPanda }

constructor TPanda.Create;
begin
  inherited;
  m_boAdminMode := True;
  m_boNoAttackMode := True;
  m_nViewRangeX := 10;
  m_nViewRangeY := m_nViewRangeX;
end;

destructor TPanda.Destroy;
begin
  inherited;
end;

procedure TPanda.Run;
begin
  if Random(30) = 0 then
    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  inherited;
end;

{ TATMonster }

constructor TATMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TATMonster.Destroy;
begin
  inherited;
end;

procedure TATMonster.Run;
begin
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited Run;
end;

{ ------------  }

constructor TMon38_5.Create;
begin
  inherited;
  m_nViewRangeX := 12;
  m_nViewRangeY := m_nViewRangeX;
end;

destructor TMon38_5.Destroy;
begin
  inherited;
end;

procedure TMon38_5.Run;
begin
  inherited;

end;

procedure TMon38_5.SpitAttack2(btDir: byte);
var
  WAbil: pTAbility;
  nC, n1C: Integer;
  nX, nY: Integer;
  BaseObject: TBaseObject;
begin
  m_btDirection := btDir;
  WAbil := @m_WAbil;
  n1C := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  if n1C <= 0 then
    Exit;
  SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');

  nC := 1;
  while (True) do
  begin
    if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, nC, nX, nY) then
    begin
      BaseObject := m_PEnvir.GetMovingObject(nX, nY, True);
      if (BaseObject <> nil) and
        (BaseObject <> self) and
        (IsProperTarget(BaseObject)) and
        (Random(BaseObject.m_btSpeedPoint) < m_btHitPoint) then
      begin

        n1C := BaseObject.GetMagStruckDamage(self, n1C);
        if n1C > 0 then
        begin
          BaseObject.StruckDamage(self, n1C, 0);
          BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, n1C, m_WAbil.HP, m_WAbil.MaxHP, Integer(self), '', 300);
        end;

      end;
    end;
    Inc(nC);
    if nC >= 4 + 3 then
      Break;
  end;
end;

function TMon38_5.AttackTarget: Boolean;
var
  btDir: byte;
begin
  Result := False;
  if (m_TargetCret = nil) or (m_TargetCret.m_boDeath) or (m_TargetCret.m_boGhost) then
    Exit;

  if TargetInSpitRange(m_TargetCret, btDir) or GetLongAttackDir_Dis(m_TargetCret, btDir, 3 + 3) then
  begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();
      SpitAttack2(btDir);
      BreakHolySeizeMode();
    end;
    Result := True;
    Exit;
  end;
  if m_TargetCret.m_PEnvir = m_PEnvir then
    SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
  else
    DelTargetCreat();
end;

{--------------------------------------------------------------}

constructor TMon38_10.Create;
begin
  inherited;
end;

procedure TMon38_10.Run;
begin
  inherited Run;
end;

function TMon38_10.AttackTarget(): Boolean;
var
  bt06: byte;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if GetAttackDir(m_TargetCret, bt06) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, bt06);

        if Random(6) = 0 then
        begin
          m_TargetCret.SendRefMsg(RM_STRUCKEFFECTEX, 0, 50, 0, 0, '');
          m_TargetCret.MagPossessedUp(STATE_15, 0, 12 + Random(10));
        end;

        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
      else
        DelTargetCreat();
    end;
  end;
end;

{--------------------------------------------------------------}

constructor TMon38_11.Create;
begin
  inherited;
  m_nViewRangeX := 8;
  m_nViewRangeY := m_nViewRangeX;
  m_dwSpellTick := GetTickCount();
end;

procedure TMon38_11.Run;
begin
  inherited Run;
end;

procedure TMon38_11.SpitAttack2(btDir: byte);
var
  WAbil: pTAbility;
  nC, n1C: Integer;
  nX, nY: Integer;
  BaseObject: TBaseObject;
begin
  m_btDirection := btDir;
  WAbil := @m_WAbil;
  n1C := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  n1C := n1C * 3;

  nC := 1;
  while (True) do
  begin
    if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, nC, nX, nY) then
    begin
      BaseObject := m_PEnvir.GetMovingObject(nX, nY, True);
      if (BaseObject <> nil) and
        (BaseObject <> self) and
        (IsProperTarget(BaseObject)) and
        (Random(BaseObject.m_btSpeedPoint) < m_btHitPoint) then
      begin

        n1C := BaseObject.GetMagStruckDamage(self, n1C);
        if n1C > 0 then
        begin
          BaseObject.StruckDamage(self, n1C, 0);
          BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, n1C, m_WAbil.HP, m_WAbil.MaxHP, Integer(self), '', 300);
        end;

      end;
    end;
    Inc(nC);
    if nC >= 5 then
      Break;
  end;
end;

function TMon38_11.AttackTarget(): Boolean;
var
  nPower: Integer;
  bt06: byte;
  WAbil: pTAbility;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if m_wAppr = 3711 then
    begin
      if GetAttackDir(m_TargetCret, bt06) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();

          if (Random(4) = 0) or ((Random(2) = 0) and ((m_WAbil.HP / m_WAbil.MaxHP * 100) < 40)) then
          begin
            nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));
            nPower := nPower * 2;
            m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
            m_TargetCret.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, nPower, m_TargetCret.m_WAbil.HP, m_TargetCret.m_WAbil.MaxHP, Integer(self), '', 200);
            SwordWideAttack2(nPower);
            SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
          end
          else
            Attack(m_TargetCret, bt06);

          BreakHolySeizeMode();
        end;
        Result := True;
      end
      else
      begin
        if m_TargetCret.m_PEnvir = m_PEnvir then
          SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
        else
          DelTargetCreat();
      end;
    end
    else if m_wAppr = 3712 then
    begin
      if ((m_WAbil.HP / m_WAbil.MaxHP * 100) < 65) and (Random(3) = 0) and GetSUQAttack() then
      begin
        WAbil := @m_WAbil;
        nPower := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
        nPower := Round(nPower * 1.9);
        SUQAttack(nPower);
        //SendRefMsg(RM_LIGHTING, 2, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
        m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        SendRefMsg(RM_LIGHTING_1, m_btDirection, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
        Result := True;
      end
      else if GetSelfRangeCount(3) > 0 then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();

          if (Random(5) = 0) or ((Random(3) = 0) and ((m_WAbil.HP / m_WAbil.MaxHP * 100) < 75)) then
          begin
            WAbil := @m_WAbil;
            nPower := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
            nPower := Round(nPower * 1.5);
            MagicManager.MagBigExplosion(self, nPower, m_nCurrX, m_nCurrY, 3, 0);

            m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
            SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
          end
          else
          begin
            WAbil := @m_WAbil;
            nPower := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
            MagicManager.MagBigExplosion(self, nPower, m_nCurrX, m_nCurrY, 3, 0);

            m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
            SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
          end;

          BreakHolySeizeMode();
        end;
        Result := True;
      end
      else
      begin
        if m_TargetCret.m_PEnvir = m_PEnvir then
          SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
        else
          DelTargetCreat();
      end;
    end
    else if m_wAppr = 3713 then
    begin
      if (GetTickCount - m_dwSpellTick > (10 + Random(10)) * 1000) and (GetSelfRangeCount(6) > 0) then
      begin
        m_dwSpellTick := GetTickCount;
        WAbil := @m_WAbil;
        nPower := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC)) * 4;

        m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        MagicManager.MagBigExplosion(self, nPower, m_nCurrX, m_nCurrY, 6, 0);

        SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
        BreakHolySeizeMode();
        Result := True;
      end
      else if (Random(2) = 0) and (TargetInSpitRange(m_TargetCret, bt06) or GetLongAttackDir_Dis(m_TargetCret, bt06, 4)) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          SpitAttack2(bt06);
          SendRefMsg(RM_LIGHTING_1, m_btDirection, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
          BreakHolySeizeMode();
        end;
        Result := True;
      end
      else if GetAttackDir(m_TargetCret, bt06) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();

          nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));
          nPower := nPower * 2;

          m_TargetCret.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, nPower, m_TargetCret.m_WAbil.HP, m_TargetCret.m_WAbil.MaxHP, Integer(self), '', 200);
          SwordWideAttack2(nPower);

          m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
          BreakHolySeizeMode();
        end;                                                                       
        Result := True;
      end
      else
      begin
        if m_TargetCret.m_PEnvir = m_PEnvir then
          SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
        else
          DelTargetCreat();
      end;
    end;
  end;
end;

{--------------------------------------------------------------}

constructor TMon38_8.Create;
begin
  inherited Create;
  m_nViewRangeX := 12;
  m_nViewRangeY := 12;
end;

procedure TMon38_8.ShotArrow(targ: TBaseObject);
var
  btEffect: byte;
  nPower: Integer;
  WAbil: pTAbility;
begin
  if targ = nil then
    Exit;
  if not ((abs(m_nCurrX - targ.m_nCurrX) <= m_nViewRangeX) and (abs(m_nCurrY - targ.m_nCurrY) <= m_nViewRangeY)) then
    Exit;

  if (not targ.m_boDeath) and IsProperTarget(targ) then
  begin
    m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, targ.m_nCurrX, targ.m_nCurrY);

    WAbil := @m_WAbil;
    nPower := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
    if nPower > 0 then
    begin
      nPower := targ.GetHitStruckDamage(self, nPower);
    end;

    if nPower > 0 then
    begin
      targ.SetLastHiter(self);
      targ.m_ExpHitter := nil;
      targ.StruckDamage(self, nPower, 0);
      targ.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, nPower,
        targ.m_WAbil.HP, targ.m_WAbil.MaxHP,
        Integer(self),
        '',
        600 + _MAX(abs(m_nCurrX - targ.m_nCurrX), abs(m_nCurrY - targ.m_nCurrY)) * 50);

      targ.MakePosion(nil, 0, POISON_DECHEALTH, (nPower div 6) + Random(12), 1);

    end;
    ////SendRefMsg(RM_FLYAXE, m_btDirection, m_nCurrX, m_nCurrY, Integer(targ), ''); ////////////
    btEffect := 67;
    SendRefMsg(RM_SPELL, btEffect, MakeLong(targ.m_nCurrX, targ.m_nCurrY), nPower, 67, '');
    MagicManager.MagBigExplosion(self, nPower, targ.m_nCurrX, targ.m_nCurrY, 3, 67);
    SendRefMsg(RM_MAGICFIRE, 3, MakeWord(1, btEffect), MakeLong(targ.m_nCurrX, targ.m_nCurrY), Integer(targ), '');
  end;
end;

function TMon38_8.AttackTarget: Boolean;
begin
  if GetCurrentTime - m_dwHitTick > m_nNextHitTime then
  begin
    m_dwHitTick := GetCurrentTime;
    ShotArrow(m_TargetCret);
  end;
  Result := True;
end;

procedure TMon38_8.Run;
var
  i, dis, d, nDamage: Integer;
  cret, nearcret: TBaseObject;
  nX, nY: Integer;
  WAbil: pTAbility;
begin
  dis := 9999;
  nearcret := nil;
  if IsMoveAble then
  begin
    if GetTickCount - m_dwSearchEnemyTick > 5000 then
    begin
      m_dwSearchEnemyTick := GetTickCount;
      for i := 0 to m_VisibleActors.Count - 1 do
      begin
        cret := pTVisibleBaseObject(m_VisibleActors[i]).BaseObject;
        if (not cret.m_boDeath) and (IsProperTarget(cret)) and (not cret.m_boHideMode or m_boFixedHideMode) then
        begin
          d := abs(m_nCurrX - cret.m_nCurrX) + abs(m_nCurrY - cret.m_nCurrY);
          if d < dis then
          begin
            dis := d;
            nearcret := cret;
          end;
        end;
      end;
      if nearcret <> nil then
        SetTargetCreat(nearcret);
    end;

    if (m_WAbil.HP / m_WAbil.MaxHP * 100) < 80 then
    begin
      if GetTickCount - m_dwSpellTick > 2200 then
      begin
        m_dwSpellTick := GetTickCount;
        WAbil := @m_WAbil;
        nDamage := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC)) * 2;
        SendDelayMsg(self, RM_MAGHEALING, 0, nDamage, 0, 0, '', 800);
        SendRefMsg(RM_SPELL, 2, MakeLong(m_nCurrX, m_nCurrY), nDamage, 2, '');
        SendRefMsg(RM_MAGICFIRE, 3, MakeWord(2, 2), MakeLong(self.m_nCurrX, self.m_nCurrY), Integer(self), '');
        inherited Run;
        Exit;
      end;
    end;

    AttackTarget;

    if GetCurrentTime - m_dwWalkTick > m_nWalkSpeed then
    begin
      if m_TargetCret <> nil then
        if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 4) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 4) then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) then
          begin
            if Random(3) = 0 then
            begin
              GetBackPosition(m_nTargetX, m_nTargetY);
              if m_nTargetX <> -1 then
              begin
                GotoTargetXY;
              end;
            end;
          end;
        end
        else if (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 5) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 5) then
        begin
          if Random(2) = 0 then
          begin
            m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
            if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 1, nX, nY) then
            begin
              m_nTargetX := nX;
              m_nTargetY := nY;
              GotoTargetXY;
            end;
          end;
        end;
    end;
  end;
  inherited Run;
end;

{ TSlowATMonster }

constructor TSlowATMonster.Create;
begin
  inherited;
end;

destructor TSlowATMonster.Destroy;
begin
  inherited;
end;

{ TScorpion }

constructor TScorpion.Create;
begin
  inherited;
  m_boAnimal := True;
end;

destructor TScorpion.Destroy;
begin
  inherited;
end;

{ TSpitSpider }

constructor TSpitSpider.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boAnimal := True;
  m_boUsePoison := True;
end;

destructor TSpitSpider.Destroy;
begin

  inherited;
end;

procedure TSpitSpider.SpitAttack(btDir: byte);
var
  WAbil: pTAbility;
  nC, n10, n14, n18, n1C: Integer;
  BaseObject: TBaseObject;
begin
  m_btDirection := btDir;
  WAbil := @m_WAbil;
  n1C := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  if n1C <= 0 then
    Exit;
  SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  nC := 0;

  while (nC < 5) do
  begin
    n10 := 0;
    while (n10 < 5) do
    begin
      if g_Config.SpitMap[btDir, nC, n10] = 1 then
      begin
        n14 := m_nCurrX - 2 + n10;
        n18 := m_nCurrY - 2 + nC;
        BaseObject := m_PEnvir.GetMovingObject(n14, n18, True);
        if (BaseObject <> nil) and
          (BaseObject <> self) and
          (IsProperTarget(BaseObject)) and
          (Random(BaseObject.m_btSpeedPoint) < m_btHitPoint) then
        begin
          n1C := BaseObject.GetMagStruckDamage(self, n1C);
          if n1C > 0 then
          begin
            BaseObject.StruckDamage(self, n1C, 0);
            BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, n1C, m_WAbil.HP, m_WAbil.MaxHP, Integer(self), '', 300);
            if m_boUsePoison then
            begin
              if (Random(m_btAntiPoison + 20) = 0) then
                BaseObject.MakePosion(nil, 0, POISON_DECHEALTH, 30, 1);
            end;
          end;
        end;
      end;
      Inc(n10);
    end;
    Inc(nC);
  end;
end;

function TSpitSpider.AttackTarget: Boolean;
var
  btDir: byte;
begin
  Result := False;
  if m_TargetCret = nil then
    Exit;
  if TargetInSpitRange(m_TargetCret, btDir) then
  begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();
      SpitAttack(btDir);
      BreakHolySeizeMode();
    end;
    Result := True;
    Exit;
  end;
  if m_TargetCret.m_PEnvir = m_PEnvir then
    SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
  else
    DelTargetCreat();
end;

{ THighRiskSpider }

constructor THighRiskSpider.Create;
begin
  inherited;
  m_boAnimal := False;
  m_boUsePoison := False;
end;

destructor THighRiskSpider.Destroy;
begin
  inherited;
end;

{ TBigPoisionSpider }

constructor TBigPoisionSpider.Create;
begin
  inherited;
  m_boAnimal := False;
  m_boUsePoison := True;
end;

destructor TBigPoisionSpider.Destroy;
begin
  inherited;
end;

{ TGasAttackMonster }

constructor TGasAttackMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boAnimal := True;
end;

destructor TGasAttackMonster.Destroy;
begin
  inherited;
end;

function TGasAttackMonster.sub_4A9C78(bt05: byte): TBaseObject;
var
  WAbil: pTAbility;
  n10: Integer;
  BaseObject: TBaseObject;
begin
  Result := nil;
  m_btDirection := bt05;
  WAbil := @m_WAbil;
  n10 := Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC);
  if n10 > 0 then
  begin
    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    BaseObject := GetPoseCreate();
    if (BaseObject <> nil) and
      IsProperTarget(BaseObject) and
      (Random(BaseObject.m_btSpeedPoint) < m_btHitPoint) then
    begin
      n10 := BaseObject.GetMagStruckDamage(self, n10);
      if n10 > 0 then
      begin
        BaseObject.StruckDamage(self, n10, 0);
        BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, n10, BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP, Integer(self), '', 300);
        if Random(BaseObject.m_btAntiPoison + 20) = 0 then
          BaseObject.MakePosion(nil, 0, POISON_STONE, 5, 0);
        Result := BaseObject;
      end;
    end;
  end;
end;

function TGasAttackMonster.AttackTarget(): Boolean; //004A9DD4
var
  btDir: byte;
begin
  Result := False;
  if m_TargetCret = nil then
    Exit;
  if GetAttackDir(m_TargetCret, btDir) then
  begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();
      sub_4A9C78(btDir);
      BreakHolySeizeMode();
    end;
    Result := True;
  end
  else
  begin
    if m_TargetCret.m_PEnvir = m_PEnvir then
    begin
      SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
    end
    else
    begin
      DelTargetCreat();
    end;
  end;
end;

{ TCowMonster }

constructor TCowMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TCowMonster.Destroy;
begin
  inherited;
end;

{ TMagCowMonster }

constructor TMagCowMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TMagCowMonster.Destroy;
begin
  inherited;
end;

procedure TMagCowMonster.sub_4A9F6C(btDir: byte);
var
  WAbil: pTAbility;
  n10: Integer;
  BaseObject: TBaseObject;
begin
  m_btDirection := btDir;
  WAbil := @m_WAbil;
  n10 := Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC);
  if n10 > 0 then
  begin
    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    BaseObject := GetPoseCreate();
    if (BaseObject <> nil) and
      IsProperTarget(BaseObject) and
      (m_nantiMagic >= 0) then
    begin
      n10 := BaseObject.GetMagStruckDamage(self, n10);
      if n10 > 0 then
      begin
        BaseObject.StruckDamage(self, n10, 0);
        BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, n10, BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP, Integer(self), '', 300);
      end;
    end;
  end;
end;

function TMagCowMonster.AttackTarget: Boolean;
var
  btDir: byte;
begin
  Result := False;
  if m_TargetCret = nil then
    Exit;
  if GetAttackDir(m_TargetCret, btDir) then
  begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();
      sub_4A9F6C(btDir);
      BreakHolySeizeMode();
    end;
    Result := True;
  end
  else
  begin
    if m_TargetCret.m_PEnvir = m_PEnvir then
      SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
    else
      DelTargetCreat();
  end;
end;

{ TCowKingMonster }

constructor TCowKingMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_dwRunTickMon := GetTickCount();
  m_boCowKingMon := True;
  m_nDangerLevel := 0;
  m_boDanger := False;
  m_boCrazy := False;
end;

destructor TCowKingMonster.Destroy;
begin
  inherited;
end;

procedure TCowKingMonster.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
  HitMagAttackTarget(TargeTBaseObject, nPower div 2, nPower div 2, True);
end;

procedure TCowKingMonster.Initialize;
begin
  m_nPreNextHitTime := m_nNextHitTime;
  m_nPreWalkSpeed := m_nWalkSpeed;
  inherited;
end;

procedure TCowKingMonster.Run;
var
  n8, nC, n10: Integer;
begin
  if (not m_boDeath) and (not m_boGhost) and ((GetTickCount - m_dwRunTickMon) > 30 * 1000) then
  begin
    m_dwRunTickMon := GetTickCount();
    if (m_TargetCret <> nil) then
    begin
      m_TargetCret.GetBackPosition(n8, nC);
      if m_PEnvir.CanWalk(n8, nC, False) then
      begin
        SpaceMove(m_PEnvir.m_sMapFileName, n8, nC, 0);
        Exit;
      end;
      MapRandomMove(m_PEnvir.m_sMapFileName, 0);
      Exit;
    end;
    n10 := m_nDangerLevel;

    m_nDangerLevel := 7 - m_WAbil.HP div _MAX(1, (m_WAbil.MaxHP div 7));
    if (m_nDangerLevel >= 2) and (m_nDangerLevel <> n10) then
    begin
      m_boDanger := True;
      m_dwDangerTick := GetTickCount();
    end;
    if m_boDanger then
    begin
      if (GetTickCount - m_dwDangerTick) < 8000 then
        m_nNextHitTime := 10000
      else
      begin
        m_boDanger := False;
        m_boCrazy := True;
        m_dwCrazyTick := GetTickCount();
      end;
    end;
    if m_boCrazy then
    begin
      if (GetTickCount - m_dwCrazyTick) < 8000 then
      begin
        m_nNextHitTime := 500;
        m_nWalkSpeed := 400;
      end
      else
      begin
        m_boCrazy := False;
        m_nNextHitTime := m_nPreNextHitTime;
        m_nWalkSpeed := m_nPreWalkSpeed;
      end;
    end;
  end;
  inherited;
end;

{ THongMoMonster }

constructor THongMoMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_dwRunTickMon := GetTickCount();
  m_boCowKingMon := True;
  m_nDangerLevel := 0;
  m_boDanger := False;
  m_boCrazy := False;
end;

destructor THongMoMonster.Destroy;
begin
  inherited;
end;

procedure THongMoMonster.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
  if m_boCrazy then
  begin
    if m_nDangerLevel >= 60 then
    begin
      HitMagAttackTarget_WideAttack(TargeTBaseObject, nPower div 2, nPower div 2, True);
      SendRefMsg(RM_LIGHTING, 2, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');
    end
    else if m_nDangerLevel >= 30 then
    begin
      HitMagAttackTarget_WideAttack(TargeTBaseObject, nPower, nPower div 2, True);
      SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');
    end;
  end
  else
    HitMagAttackTarget(TargeTBaseObject, nPower div 2, nPower div 2, True);
end;

procedure THongMoMonster.Initialize;
begin
  m_nPreNextHitTime := m_nNextHitTime;
  m_nPreWalkSpeed := m_nWalkSpeed;
  inherited;
end;

procedure THongMoMonster.Run;
var
  n10: Integer;
begin
  if (not m_boDeath) and (not m_boGhost) and ((GetTickCount - m_dwRunTickMon) > 5 * 1000) then
  begin
    m_dwRunTickMon := GetTickCount();
    n10 := m_nDangerLevel;
    m_nDangerLevel := 100 - m_WAbil.HP div _MAX(1, (m_WAbil.MaxHP div 100));
    if (m_nDangerLevel <> n10) then
    begin
      if (m_nDangerLevel >= 60) then
      begin
        m_boDanger := True;
        m_dwDangerTick := GetTickCount();
      end
      else if (m_nDangerLevel >= 30) then
      begin
        m_boDanger := True;
        m_dwDangerTick := GetTickCount();
      end;
    end;
    if m_boDanger then
    begin
      if (GetTickCount - m_dwDangerTick) > 5 * 1000 then
      begin
        m_boDanger := False;
        m_boCrazy := True;
        m_dwCrazyTick := GetTickCount();
      end;
    end;
    if m_boCrazy then
    begin
      if (GetTickCount - m_dwCrazyTick) < 10 * 1000 then
      begin
        if m_nDangerLevel >= 60 then
        begin
          m_nNextHitTime := 500;
          m_nWalkSpeed := 400;
        end
        else if m_nDangerLevel >= 30 then
        begin
          m_nNextHitTime := 700;
          m_nWalkSpeed := 600;
        end;
      end
      else
      begin
        m_boCrazy := False;
        m_nNextHitTime := m_nPreNextHitTime;
        m_nWalkSpeed := m_nPreWalkSpeed;
      end;
    end;
  end;
  inherited;
end;

{ TLightingZombi }

constructor TLightingZombi.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TLightingZombi.Destroy;
begin
  inherited;
end;

procedure TLightingZombi.LightingAttack(nDir: Integer);
var
  nSX, nSY, nTX, nTY, nPwr: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := nDir;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, nDir, 1, nSX, nSY) then
  begin
    m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, nDir, 9, nTX, nTY);
    WAbil := @m_WAbil;
    nPwr := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
    MagPassThroughMagic(nSX, nSY, nTX, nTY, nDir, nPwr, 0, True);
  end;
  BreakHolySeizeMode();
end;

procedure TLightingZombi.Run;
var
 nAttackDir: Integer;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) and ((GetTickCount - m_dwSearchEnemyTick) > 8000) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) and
      (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 4) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 4) then
    begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and
        (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) and
        (Random(3) <> 0) then
      begin
        inherited;
        Exit;
      end;
      GetBackPosition(m_nTargetX, m_nTargetY);
    end;
    if (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) < 6) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 6) and
      (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
    begin

      m_dwHitTick := GetTickCount();
      nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      LightingAttack(nAttackDir);
    end;
  end;
  inherited;
end;

{ TLightingCowKing }

constructor TLightingCowKing.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TLightingCowKing.Destroy;
begin
  inherited;
end;

procedure TLightingCowKing.LightingAttack(nDir: Integer);
var
  nPwr: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := nDir;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  WAbil := @m_WAbil;
  nPwr := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  MagicManager.MagBigExplosion(self, nPwr, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 1, 0);
  BreakHolySeizeMode();
end;

procedure TLightingCowKing.Run;
var
  nAttackDir: Integer;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) and ((GetTickCount - m_dwSearchEnemyTick) > 2000) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) and (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 4) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 4) then
    begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) {and (Random(3) <> 0)} then
      begin
        inherited;
        Exit;
      end;
      //GetBackPosition(m_nTargetX, m_nTargetY);
    end;
    if (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) < 9) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 1) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 9) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 1) and
      (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
    begin
      m_dwHitTick := GetTickCount();
      nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      LightingAttack(nAttackDir);
    end;
  end;
  inherited;
end;

{ TSkeletonKingMon }

constructor TSkeletonKingMon.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TSkeletonKingMon.Destroy;
begin
  inherited;
end;

procedure TSkeletonKingMon.LightingAttack(nDir: Integer);
var
  nPwr: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := nDir;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  WAbil := @m_WAbil;
  nPwr := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  SendDelayMsg(self, RM_DELAYMAGIC, 3, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), nPwr, Integer(m_TargetCret), '', 300);
  if Random(m_TargetCret.m_btAntiPoison + 7) <= 6 then
    m_TargetCret.MakePosion(nil, 0, POISON_STONE, 3 + Random(3), 0);
  BreakHolySeizeMode();
end;

procedure TSkeletonKingMon.FlayAxeAttack(nDir: Integer);
var
  nPwr: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := nDir;
  SendRefMsg(RM_FLYAXE, m_btDirection, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  WAbil := @m_WAbil;
  nPwr := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  SendDelayMsg(self, RM_DELAYMAGIC, 3, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), nPwr, Integer(m_TargetCret), '', 600);
  BreakHolySeizeMode();
end;

procedure TSkeletonKingMon.Run;
var
  nAttackDir: Integer;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) and ((GetTickCount - m_dwSearchEnemyTick) > 2000) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) and (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 4) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 4) then
    begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) {and (Random(3) <> 0)} then
      begin
        inherited;
        Exit;
      end;
      //GetBackPosition(m_nTargetX, m_nTargetY);
    end;
    if (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) < 9) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 1) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 9) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 1) and
      (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
    begin
      m_dwHitTick := GetTickCount();
      nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      if ((m_WAbil.HP / m_WAbil.MaxHP * 100) < 45) and (Random(3) = 0) or (Random(15) = 0) then
      begin
        LightingAttack(nAttackDir);
      end
      else
        FlayAxeAttack(nAttackDir);
    end;
  end;
  inherited;
end;

{ TEldKingMon }

constructor TEldKingMon.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_dwGroupParalysisTick := GetTickCount;
end;

destructor TEldKingMon.Destroy;
begin
  inherited;
end;
{
procedure TEldKingMon.PoisonAttack(nDir: Integer; boPoison: Boolean);
var
  nPwr: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := nDir;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  WAbil := @m_WAbil;
  nPwr := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  SendDelayMsg(self, RM_DELAYMAGIC, 3, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), nPwr, Integer(m_TargetCret), '', 300);
  if boPoison and (Random(m_TargetCret.m_btAntiPoison + 7) <= 6) then
    m_TargetCret.MakePosion(nil, 0, POISON_STONE, 3 + Random(3), 0);
  BreakHolySeizeMode();
end;
}
procedure TEldKingMon.GroupParalysisAttack(nDir: Integer);
var
  i, n: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nTime: Integer;
  magpwr: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := nDir;
  BaseObjectList := TList.Create;
  nTime := 5 + Random(3);
  GetMapBaseObjects(m_PEnvir, m_nCurrX, m_nCurrY, 7, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (self = BaseObject) then
      Continue;
    if IsProperTarget(BaseObject) then
    begin
      WAbil := @m_WAbil;
      magpwr := (BaseObject.m_WAbil.MaxHP * LoWord(WAbil.MC)) div 100;
      BaseObject.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
      if (not BaseObject.m_boUnParalysis) and (BaseObject.m_wStatusTimeArr[POISON_STONE] = 0) then
      begin
        BaseObject.MakePosion(nil, 0, POISON_STONE, nTime, 0);
        Inc(n);
      end;
    end;
    if n > 30 then
      Break;
  end;
  BaseObjectList.Free;
  if n > 0 then
    SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
end;

procedure TEldKingMon.CharPushAttack();
var
  i: Integer;
  BaseObject: TBaseObject;
  nDir: byte;
  push: Integer;
begin
  {do spell effect}

  nDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
  m_btDirection := nDir;
  SendAttackMsg(RM_HIT, nDir, m_nCurrX, m_nCurrY);

  {do repule radius around 'ourself'}
  for i := 0 to m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 2) and (abs(m_nCurrY - BaseObject.m_nCurrY) <= 2)
      and ((abs(m_nCurrY - m_TargetCret.m_nCurrY) + abs(m_nCurrX - m_TargetCret.m_nCurrX)) <= 3) then
    begin
      if BaseObject <> nil then
      begin
        if IsProperTarget(BaseObject) then
        begin
          if Random(10) >= BaseObject.m_nantiMagic then
          begin
            push := 1 + Random(3);
            nDir := GetNextDirection(m_nCurrX, m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
            BaseObject.CharPushed(nDir, push);
            BaseObject.DMSkillFix();
          end;
        end;
      end;
    end;
  end;
end;

procedure TEldKingMon.Run;

  procedure EldKingMonSearchTarget;
  var
    BaseObject, BaseObject18: TBaseObject;
    i, nC, n10: Integer;
  begin
    BaseObject18 := nil;
    n10 := 999;
    for i := 0 to m_VisibleActors.Count - 1 do
    begin
      BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
      if (BaseObject <> nil) and not BaseObject.m_boDeath and not BaseObject.m_boGhost then
      begin
        if IsProperTarget(BaseObject) and (not BaseObject.m_boHideMode or m_boCoolEye) then
        begin
          nC := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
          if nC < n10 then
          begin
            n10 := nC;
            BaseObject18 := BaseObject;
          end;
        end;
      end;
    end;
    if (BaseObject18 <> nil) and (BaseObject18.m_wStatusTimeArr[POISON_STONE] = 0) then
      SetTargetCreat(BaseObject18);
  end;
var
  n08, nAttackDir: Integer;
begin
  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) and
      (m_TargetCret <> nil) and
      (m_TargetCret.m_wStatusTimeArr[POISON_STONE] = 0) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) then
    begin
      n08 := Round(m_WAbil.HP * 7 / m_WAbil.MaxHP) + 1;
      if Random(n08) <= 3 then
        CharPushAttack();
      inherited;
      Exit;
    end;

    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      m_dwHitTick := GetTickCount();
      if (m_TargetCret <> nil) and //(m_TargetCret.m_wStatusTimeArr[POISON_STONE] = 0) and
        (abs(m_nCurrX - m_TargetCret.m_nCurrX) < 12) and
        (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 12) then
      begin
        n08 := Round(m_WAbil.HP * 40 / m_WAbil.MaxHP) + 1;
        n08 := Random(n08) + 15;
        if (GetTickCount - m_dwGroupParalysisTick > (n08 * 1000)) or (Random(15) = 0) then
        begin
          m_dwGroupParalysisTick := GetTickCount();
          nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          GroupParalysisAttack(nAttackDir);
        end;
      end;
    end;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      EldKingMonSearchTarget();
    end;
  end;
  if (m_TargetCret <> nil) and (m_TargetCret.m_wStatusTimeArr[POISON_STONE] = 0) then
    inherited;
end;

{ TDigOutZombi }

constructor TDigOutZombi.Create; //004AA848
begin
  inherited;
  m_nViewRangeX := 7;
  m_nViewRangeY := m_nViewRangeX;
  m_dwSearchTime := Random(1500) + 2500;
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 95;
  m_boFixedHideMode := True;
end;

destructor TDigOutZombi.Destroy;
begin

  inherited;
end;

procedure TDigOutZombi.sub_4AA8DC;
var
  Event: TEvent;
begin
  Event := TEvent.Create(m_PEnvir, m_nCurrX, m_nCurrY, ET_DIGOUTZOMBI, 5 * 60 * 1000, True);
  g_EventManager.AddEvent(Event);
  m_boFixedHideMode := False;
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, Integer(Event), '');
end;

procedure TDigOutZombi.Run; //004AA95C
var
  i: Integer;
  BaseObject: TBaseObject;
begin
  if (not m_boGhost) and (not m_boDeath) and (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
  begin
    if m_boFixedHideMode then
    begin
      for i := 0 to m_VisibleActors.Count - 1 do
      begin
        BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
        if BaseObject.m_boDeath then
          Continue;
        if IsProperTarget(BaseObject) then
        begin
          if not BaseObject.m_boHideMode or m_boCoolEye then
          begin
            if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 3) and (abs(m_nCurrY -
              BaseObject.m_nCurrY) <= 3) then
            begin
              sub_4AA8DC();
              m_dwWalkTick := GetTickCount + 1000;
              Break;
            end;
          end;
        end;
      end; // for
    end
    else
    begin //004AB0C7
      if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
        (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
      begin
        m_dwSearchEnemyTick := GetTickCount();
        SearchTarget();
      end;
    end;
  end;
  inherited;
end;

{ TZilKinZombi }

constructor TZilKinZombi.Create;
begin
  inherited;
  m_nViewRangeX := 6;
  m_nViewRangeY := m_nViewRangeX;
  m_dwSearchTime := Random(1500) + 2500;
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 96;
  nZilKillCount := 0;
  if Random(3) = 0 then
  begin
    nZilKillCount := Random(3) + 1;
  end;
end;

destructor TZilKinZombi.Destroy;
begin
  inherited;

end;

procedure TZilKinZombi.Die;
begin
  inherited;
  if nZilKillCount > 0 then
  begin
    dw558 := GetTickCount();
    dw560 := (Random(20) + 4) * 1000;
  end;
  Dec(nZilKillCount);
end;

procedure TZilKinZombi.Run; //004AABE4
begin
  if m_boDeath and
    (not m_boGhost) and
    (nZilKillCount >= 0) and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) and
    (m_VisibleActors.Count > 0) and
    ((GetTickCount - dw558) >= dw560) then
  begin
    m_Abil.MaxHP := m_Abil.MaxHP shr 1;
    m_dwFightExp := m_dwFightExp div 2;
    m_dwFightIPExp := m_dwFightIPExp div 2;
    m_Abil.HP := m_Abil.MaxHP;
    m_WAbil.HP := m_Abil.MaxHP;
    ReAlive();
    m_dwWalkTick := GetTickCount + 1000
  end;
  inherited;
end;

{ TWhiteSkeleton }

constructor TWhiteSkeleton.Create; //00004AACCC
begin
  inherited;
  m_boIsFirst := True;
  m_boFixedHideMode := True;
  m_btRaceServer := 100;
  m_nViewRangeX := 6;
  m_nViewRangeY := m_nViewRangeX;
end;

destructor TWhiteSkeleton.Destroy;
begin
  inherited;
end;

procedure TWhiteSkeleton.RecalcAbilitys; //004AAD38
begin
  inherited;
  RecalcAbilitysEx();
end;

procedure TWhiteSkeleton.Run;
begin
  if m_boIsFirst then
  begin
    m_boIsFirst := False;
    m_btDirection := 5;
    m_boFixedHideMode := False;
    SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  end;
  inherited Run;
end;

function TWhiteSkeleton.AttackTarget(): Boolean; //004A8F34
var
  btDir: byte;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();

        if m_btRaceImg in [91..93] then
        begin
          if Random(99 - m_btRaceImg) = 0 then
          begin
            m_boPowerHit := True;
            m_nHitPlus := DEFHIT + (m_btRaceImg - 90) * 3;
            AttackDir(m_TargetCret, 3, btDir);
            SendAttackMsg(RM_SPELL2, m_btDirection, m_nCurrX, m_nCurrY);
          end
          else
            Attack(m_TargetCret, btDir);
        end
        else
          Attack(m_TargetCret, btDir);
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
      else
        DelTargetCreat();
    end;
  end;
end;

procedure TWhiteSkeleton.RecalcAbilitysEx;
var
  ldc, hdc: Integer;
begin
  if (g_Config.nBoneFammDcEx > 0) and (m_Master <> nil) then
  begin
    ldc := Round(LoWord(m_Master.m_WAbil.SC) / 100 * g_Config.nBoneFammDcEx);
    hdc := Round(HiWord(m_Master.m_WAbil.SC) / 100 * g_Config.nBoneFammDcEx);
    if ldc > hdc then
    begin
      m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC) + hdc, HiWord(m_WAbil.DC) + ldc);
    end
    else
    begin
      m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC) + ldc, HiWord(m_WAbil.DC) + hdc);
    end;
  end;

  m_nNextHitTime := _MAX(350, 3000 - m_btSlaveMakeLevel * 600);
  m_nWalkSpeed := _MAX(350, 1200 - m_btSlaveMakeLevel * 250);
  m_dwWalkTick := GetTickCount + 2000;
  m_nNonFrzWalkSpeed := m_nWalkSpeed;
  m_nNonFrzNextHitTime := m_nNextHitTime;
end;

{ TScultureMonster }

constructor TScultureMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_nViewRangeX := 7;
  m_nViewRangeY := m_nViewRangeX;
  m_boStoneMode := True;
  m_nCharStatusEx := STATE_STONE_MODE;
end;

destructor TScultureMonster.Destroy;
begin

  inherited;
end;

procedure TScultureMonster.MeltStone;
begin
  m_nCharStatusEx := 0;
  m_nCharStatus := GetCharStatus();
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  m_boStoneMode := False;
end;

procedure TScultureMonster.MeltStoneAll;
var
  i: Integer;
  List10: TList;
  BaseObject: TBaseObject;
begin
  MeltStone();
  List10 := TList.Create;
  GetMapBaseObjects(m_PEnvir, m_nCurrX, m_nCurrY, 7, List10);
  for i := 0 to List10.Count - 1 do
  begin
    BaseObject := TBaseObject(List10.Items[i]);
    if BaseObject.m_boStoneMode then
    begin
      if BaseObject is TScultureMonster then
      begin
        TScultureMonster(BaseObject).MeltStone
      end;
    end;
  end; // for
  List10.Free;
end;

procedure TScultureMonster.Run; //004AAF98
var
  i: Integer;
  BaseObject: TBaseObject;
begin
  if (not m_boGhost) and (not m_boDeath) and (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) and (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then
  begin
    if m_boStoneMode then
    begin
      for i := 0 to m_VisibleActors.Count - 1 do
      begin
        BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
        if BaseObject.m_boDeath then
          Continue;
        if IsProperTarget(BaseObject) then
        begin
          if not BaseObject.m_boHideMode or m_boCoolEye then
          begin
            if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 2) and (abs(m_nCurrY - BaseObject.m_nCurrY) <= 2) then
            begin
              MeltStoneAll();
              Break;
            end;
          end;
        end;
      end; // for
    end
    else
    begin //004AB0C7
      if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
        (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
      begin
        m_dwSearchEnemyTick := GetTickCount();
        SearchTarget();
      end;
    end;
  end;
  inherited;
end;

{ TScultureKingMonster }

constructor TScultureKingMonster.Create; //004AB120
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_nViewRangeX := 8;
  m_nViewRangeY := m_nViewRangeX;
  m_boStoneMode := True;
  m_nCharStatusEx := STATE_STONE_MODE;
  m_btDirection := 5;
  m_nDangerLevel := 5;
  m_SlaveObjectList := TList.Create;
end;

destructor TScultureKingMonster.Destroy; //004AB1C8
begin
  m_SlaveObjectList.Free;
  inherited;
end;

procedure TScultureKingMonster.MeltStone; //004AB208
var
  Event: TEvent;
begin
  m_nCharStatusEx := 0;
  m_nCharStatus := GetCharStatus();
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  m_boStoneMode := False;
  Event := TEvent.Create(m_PEnvir, m_nCurrX, m_nCurrY, 6, 5 * 60 * 1000, True);
  g_EventManager.AddEvent(Event);
end;

procedure TScultureKingMonster.CallSlave;
var
  i: Integer;
  nC: Integer;
  n10, n14: Integer;
  BaseObject: TBaseObject;
begin
  nC := Random(6) + 6;
  GetFrontPosition(n10, n14);
  for i := 1 to nC do
  begin
    if m_SlaveObjectList.Count >= 30 then
      Break;
    BaseObject := UserEngine.RegenMonsterByName(m_sMapName, n10, n14,
      g_Config.sZuma[Random(4)]);
    if BaseObject <> nil then
    begin
      m_SlaveObjectList.Add(BaseObject);
    end;
  end;
end;

procedure TScultureKingMonster.Attack(TargeTBaseObject: TBaseObject; nDir:
  Integer);
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
  HitMagAttackTarget(TargeTBaseObject, 0, nPower, True);
end;

procedure TScultureKingMonster.Run;
var
  i: Integer;
  BaseObject: TBaseObject;
begin
  if (not m_boGhost) and
    (not m_boDeath) and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) and
    (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then
  begin
    if m_boStoneMode then
    begin
      for i := 0 to m_VisibleActors.Count - 1 do
      begin
        BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
        if BaseObject.m_boDeath then
          Continue;
        if IsProperTarget(BaseObject) then
        begin
          if not BaseObject.m_boHideMode or m_boCoolEye then
          begin
            if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 2) and (abs(m_nCurrY - BaseObject.m_nCurrY) <= 2) then
            begin
              MeltStone();
              Break;
            end;
          end;
        end;
      end;
    end
    else
    begin
      if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
        (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
      begin
        m_dwSearchEnemyTick := GetTickCount();
        SearchTarget();
        if (m_nDangerLevel > m_WAbil.HP / m_WAbil.MaxHP * 5) and (m_nDangerLevel > 0) then
        begin
          Dec(m_nDangerLevel);
          CallSlave();
        end;
        if m_WAbil.HP = m_WAbil.MaxHP then
          m_nDangerLevel := 5;
      end;
    end;
    for i := m_SlaveObjectList.Count - 1 downto 0 do
    begin
      BaseObject := TBaseObject(m_SlaveObjectList.Items[i]);
      if BaseObject.m_boDeath or BaseObject.m_boGhost then
        m_SlaveObjectList.Delete(i);
    end;
  end;
  inherited;
end;
{ TGasMothMonster }

constructor TGasMothMonster.Create;
begin
  inherited;
  m_nViewRangeX := 7;
  m_nViewRangeY := m_nViewRangeX;
end;

destructor TGasMothMonster.Destroy;
begin
  inherited;
end;

function TGasMothMonster.sub_4A9C78(bt05: byte): TBaseObject; //004AB708
var
  BaseObject: TBaseObject;
begin
  BaseObject := inherited sub_4A9C78(bt05);
  if (BaseObject <> nil) and (Random(3) = 0) and (BaseObject.m_boHideMode) then
  begin
    BaseObject.m_wStatusTimeArr[STATE_TRANSPARENT {8 0x70}] := 1;
  end;
  Result := BaseObject;
end;

procedure TGasMothMonster.Run;
begin
  if (not m_boDeath) and
    (not m_boGhost) and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) and
    (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTargetA();
    end;
  end;
  inherited;
end;
{ TGasDungMonster }

constructor TGasDungMonster.Create;
begin
  inherited;
  m_nViewRangeX := 7;
  m_nViewRangeY := m_nViewRangeX;
end;

destructor TGasDungMonster.Destroy;
begin
  inherited;
end;

{ TElfMonster }

procedure TElfMonster.AppearNow;
begin
  boIsFirst := False;
  m_boFixedHideMode := False;
  RecalcAbilitys;
  m_dwWalkTick := m_dwWalkTick + 800;
end;

constructor TElfMonster.Create;
begin
  inherited;
  m_nViewRangeX := 6;
  m_nViewRangeY := m_nViewRangeX;
  m_boFixedHideMode := True;
  m_boNoAttackMode := True;
  boIsFirst := True;
end;

destructor TElfMonster.Destroy;
begin
  inherited;
end;

procedure TElfMonster.RecalcAbilitys;
begin
  inherited;
  ResetElfMon();
end;

procedure TElfMonster.ResetElfMon();
begin
  m_nWalkSpeed := _MAX(350, 500 - m_btSlaveMakeLevel * 50);
  m_dwWalkTick := GetTickCount + 2000;
end;

procedure TElfMonster.Run;
var
  boChangeFace: Boolean;
  ElfMon: TBaseObject;
begin
  if boIsFirst then
  begin
    boIsFirst := False;
    m_boFixedHideMode := False;
    SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    ResetElfMon();
  end;
  if m_boDeath then
  begin
    if (GetTickCount - m_dwDeathTick > 2 * 1000) then
    begin
      MakeGhost();
    end;
  end
  else
  begin
    boChangeFace := False;
    if (m_TargetCret <> nil) or ((m_Master <> nil) and ((m_Master.m_TargetCret <> nil) or (m_Master.m_LastHiter <> nil))) then
      boChangeFace := True;
    if boChangeFace then
    begin
      ElfMon := MakeClone(m_sCharName + '1', self);
      if ElfMon <> nil then
      begin
        ElfMon.m_boAutoChangeColor := m_boAutoChangeColor;
        if ElfMon is TElfWarriorMonster then
          TElfWarriorMonster(ElfMon).AppearNow;
        m_Master := nil;
        m_boDeath := True;
        m_dwDeathTick := GetTickCount;
        m_boGhost := True;
        m_dwGhostTick := GetTickCount();
        DisappearA(1);
      end;
    end;
  end;
  inherited;
end;
{ TElfWarriorMonster }

procedure TElfWarriorMonster.AppearNow; //004ABB60
begin
  boIsFirst := False;
  m_boFixedHideMode := False;
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  RecalcAbilitys;
  m_dwWalkTick := m_dwWalkTick + 800;
  dwDigDownTick := GetTickCount();
end;

constructor TElfWarriorMonster.Create;
begin
  inherited;
  m_nViewRangeX := 6;
  m_nViewRangeY := m_nViewRangeX;
  m_boFixedHideMode := True;
  boIsFirst := True;
  m_boUsePoison := False;
end;

destructor TElfWarriorMonster.Destroy;
begin
  inherited;
end;

procedure TElfWarriorMonster.RecalcAbilitys;
begin
  inherited;
  ResetElfMon();
end;

procedure TElfWarriorMonster.ResetElfMon();
var
  isElfex: Boolean;
  nDogzDcEx: Integer;
  ldc, hdc: Integer;
begin
  if m_Master <> nil then
  begin
    isElfex := ((m_wAppr = 704) or (m_wAppr = 706) or (m_wAppr = 708));
    nDogzDcEx := g_Config.nDogzDcEx;
    if isElfex and (nDogzDcEx = 0) then
      nDogzDcEx := 40;
    if nDogzDcEx > 0 then
    begin
      ldc := Round(LoWord(m_Master.m_WAbil.SC) / 100 * nDogzDcEx);
      hdc := Round(HiWord(m_Master.m_WAbil.SC) / 100 * nDogzDcEx);
      if ldc > hdc then
      begin
        m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC) + hdc, HiWord(m_WAbil.DC) + ldc);
      end
      else
      begin
        m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC) + ldc, HiWord(m_WAbil.DC) + hdc);
      end;
    end;
  end;

  m_nNextHitTime := _MAX(350, 1500 - m_btSlaveMakeLevel * 100);
  m_nWalkSpeed := _MAX(350, 500 - m_btSlaveMakeLevel * 50);
  m_dwWalkTick := GetTickCount + 2000;
  m_nNonFrzWalkSpeed := m_nWalkSpeed;
  m_nNonFrzNextHitTime := m_nNextHitTime;
end;

procedure TElfWarriorMonster.Run;
var
  boChangeFace: Boolean;
  ElfMon: TBaseObject;
  ElfName: string;
begin
  if boIsFirst then
  begin
    boIsFirst := False;
    m_boFixedHideMode := False;
    SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    ResetElfMon();
  end;
  if m_boDeath then
  begin
    if (GetTickCount - m_dwDeathTick > 2 * 1000) then
      MakeGhost();
  end
  else
  begin
    boChangeFace := True;
    if m_TargetCret <> nil then
      boChangeFace := False;
    if (m_Master <> nil) and ((m_Master.m_TargetCret <> nil) or
      (m_Master.m_LastHiter <> nil)) then
      boChangeFace := False;
    if boChangeFace then
    begin
      if (GetTickCount - dwDigDownTick) > 6 * 10 * 1000 then
      begin
        ElfMon := nil;
        ElfName := m_sCharName;
        if ElfName[Length(ElfName)] = '1' then
        begin
          ElfName := Copy(ElfName, 1, Length(ElfName) - 1);
          ElfMon := MakeClone(ElfName, self);
        end;
        if ElfMon <> nil then
        begin
          SendRefMsg(RM_DIGDOWN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
          SendRefMsg(RM_CHANGEFACE, 0, Integer(self), Integer(ElfMon), 0, '');
          ElfMon.m_boAutoChangeColor := m_boAutoChangeColor;
          if ElfMon is TElfMonster then
            TElfMonster(ElfMon).AppearNow;
          m_Master := nil;
          m_boDeath := True;
          m_dwDeathTick := GetTickCount;
          m_boGhost := True;
          m_dwGhostTick := GetTickCount();
          DisappearA(1);
        end;
      end;
    end
    else
      dwDigDownTick := GetTickCount();
  end;
  inherited;
end;

procedure TElfWarriorMonster.SpitAttack2(btDir: byte);
var
  WAbil: pTAbility;
  nC, n1C: Integer;
  nX, nY: Integer;
  BaseObject: TBaseObject;
begin
  m_btDirection := btDir;
  WAbil := @m_WAbil;
  n1C := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  if n1C <= 0 then
    Exit;
  SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');

  nC := 1;
  while (True) do
  begin
    if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, nC, nX, nY) then
    begin
      BaseObject := m_PEnvir.GetMovingObject(nX, nY, True);
      if (BaseObject <> nil) and
        (BaseObject <> self) and
        (IsProperTarget(BaseObject)) and
        (Random(BaseObject.m_btSpeedPoint) < m_btHitPoint) then
      begin

        n1C := BaseObject.GetMagStruckDamage(self, n1C);
        if n1C > 0 then
        begin
          BaseObject.StruckDamage(self, n1C, 0);
          BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, n1C, m_WAbil.HP, m_WAbil.MaxHP, Integer(self), '', 300);
        end;

      end;
    end;
    Inc(nC);
    if nC >= 4 then
      Break;
  end;
end;

function TElfWarriorMonster.AttackTarget: Boolean;
var
  btDir: byte;
begin
  Result := False;
  if m_TargetCret = nil then
    Exit;
  if ((m_wAppr <> 704) and (m_wAppr <> 706) and (m_wAppr <> 708)) then
  begin
    Result := inherited AttackTarget;
    Exit;
  end;
  if TargetInSpitRange(m_TargetCret, btDir) or GetLongAttackDir_Dis(m_TargetCret, btDir, 3) then
  begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();
      SpitAttack2(btDir);
      BreakHolySeizeMode();
    end;
    Result := True;
    Exit;
  end;
  if m_TargetCret.m_PEnvir = m_PEnvir then
    SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
  else
    DelTargetCreat();
end;

{ TElectronicScolpionMon }

constructor TElectronicScolpionMon.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boUseMagic := False;
  m_boApproach := False;
end;

destructor TElectronicScolpionMon.Destroy;
begin

  inherited;
end;

procedure TElectronicScolpionMon.LightingAttack(nDir: Integer);
var
  WAbil: pTAbility;
  nPower, nDamage: Integer;
  btGetBackHP: Integer;
begin
  m_btDirection := nDir;
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.MC), SmallInt(HiWord(WAbil.MC) - LoWord(WAbil.MC)));
  nDamage := m_TargetCret.GetMagStruckDamage(self, nPower);
  if nDamage > 0 then
  begin
    btGetBackHP := _MAX(1, LoWord(m_WAbil.MP));
    if btGetBackHP <> 0 then
      Inc(m_WAbil.HP, nDamage div btGetBackHP);
    m_TargetCret.StruckDamage(self, nDamage, 0);
    m_TargetCret.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, nDamage, m_TargetCret.m_WAbil.HP, m_TargetCret.m_WAbil.MaxHP, Integer(self), '', 200);
  end;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
end;

procedure TElectronicScolpionMon.Run;
var
  nAttackDir: Integer;
  nX, nY: Integer;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if m_WAbil.HP < m_WAbil.MaxHP div 2 then
      m_boUseMagic := True
    else
      m_boUseMagic := False;
    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
    if m_TargetCret = nil then
      Exit;

    nX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
    nY := abs(m_nCurrY - m_TargetCret.m_nCurrY);

    if (nX <= 2) and (nY <= 2) then
    begin
      if m_boUseMagic or ((nX = 2) or (nY = 2)) then
      begin
        if (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
        begin
          m_dwHitTick := GetTickCount();
          nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          LightingAttack(nAttackDir);
        end;
      end;
    end;
  end;
  inherited Run;
end;

constructor TCrystalSpider.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boUseMagic := False;
  m_boApproach := True;
end;

destructor TCrystalSpider.Destroy;
begin
  inherited;
end;

procedure TCrystalSpider.LightingAttack(nDir: Integer);
var
  WAbil: pTAbility;
  nPower, nDamage: Integer;
  btGetBackHP: Integer;
begin
  m_btDirection := nDir;
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.MC), SmallInt(HiWord(WAbil.MC) - LoWord(WAbil.MC)));
  nDamage := m_TargetCret.GetMagStruckDamage(self, nPower);
  if nDamage > 0 then
  begin
    btGetBackHP := _MAX(1, LoWord(m_WAbil.MP));
    if btGetBackHP <> 0 then
      Inc(m_WAbil.HP, nDamage div btGetBackHP);
    m_TargetCret.StruckDamage(self, nDamage, 0);
    m_TargetCret.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, nDamage, m_TargetCret.m_WAbil.HP, m_TargetCret.m_WAbil.MaxHP, Integer(self), '', 200);
  end;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
end;

procedure TCrystalSpider.Run;
var
  nAttackDir: Integer;
  nX, nY: Integer;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if m_WAbil.HP < m_WAbil.MaxHP div 2 then
      m_boUseMagic := True
    else
      m_boUseMagic := False;
    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
    if m_TargetCret = nil then
      Exit;

    nX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
    nY := abs(m_nCurrY - m_TargetCret.m_nCurrY);

    if (nX <= 2) and (nY <= 2) then
    begin
      if m_boUseMagic or ((nX = 2) or (nY = 2)) then
      begin
        if (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
        begin
          m_dwHitTick := GetTickCount();
          nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          LightingAttack(nAttackDir);
        end;
      end
      else
        AttackTarget;
    end;
  end;
  inherited Run;
end;

function TCrystalSpider.AttackTarget(): Boolean; //004A8F34
var
  btDir: byte;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, btDir); //FFED
        if (Random(m_TargetCret.m_btAntiPoison + 20) = 0) then
          m_TargetCret.MakePosion(nil, 0, POISON_DECHEALTH, 30, 1);
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
      begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY); {0FFF0h}
        //004A8FE3
      end
      else
      begin
        DelTargetCreat(); {0FFF1h}
        //004A9009
      end;
    end;
  end;
end;

{TBloodKingMonster}

constructor TBloodKingMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_nViewRangeX := 8;
  m_nViewRangeY := m_nViewRangeX;
  m_nDangerLevel := 5;
  m_SlaveObjectList := TList.Create;
  m_dwRecallAbilTick := GetTickCount();
  m_btRaceServer := 209;
end;

destructor TBloodKingMonster.Destroy;
begin
  m_SlaveObjectList.Free;
  inherited;
end;

procedure TBloodKingMonster.CallSlave;
var
  i: Integer;
  nNomber: Integer;
  nX, nY: Integer;
  BaseObject: TBaseObject;
begin
  nNomber := Random(3) + 2;
  GetFrontPosition(nX, nY);
  for i := 1 to nNomber do
  begin
    if m_SlaveObjectList.Count >= 10 then
      Break;
    BaseObject := UserEngine.RegenMonsterByName(m_sMapName, nX, nY, g_Config.sBloodMonSlave[Random(2) + 1]);
    if BaseObject <> nil then
      m_SlaveObjectList.Add(BaseObject);
  end;
end;

procedure TMonster.HitMagAttackTarget_RandomMove(TargeTBaseObject: TBaseObject; nHitPower, nMagPower: Integer; boFlag: Boolean);
var
  i, nDamage, nBackDir: Integer;
  BaseObject: TBaseObject;
  nX, nY, rX, rY: Integer;
begin
  for i := 0 to m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if (BaseObject = nil) or BaseObject.m_boDeath then
      Continue;
    if IsProperTarget(BaseObject) then
    begin
      if (abs(m_nCurrX - BaseObject.m_nCurrX) <= m_nViewRangeX) and (abs(m_nCurrY - BaseObject.m_nCurrY) <= m_nViewRangeY) then
      begin
        nDamage := 0;
        Inc(nDamage, BaseObject.GetHitStruckDamage(self, nHitPower));
        Inc(nDamage, BaseObject.GetMagStruckDamage(self, nMagPower));
        if nDamage > 0 then
        begin
          BaseObject.StruckDamage(self, nDamage, 0);
          BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK),
            RM_STRUCKEFFECT,
            nDamage,
            BaseObject.m_WAbil.HP, //  MakeLong(BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP),
            BaseObject.m_WAbil.MaxHP,
            Integer(self),
            '',
            200);
          SendDelayMsg(self, RM_DELAYMAGIC, 1, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), nDamage, Integer(BaseObject), '', 200);
          if Random(5) - 1 < 0 then
          begin
            rX := Random(14);
            if rX in [7..10] then
              rX := 11;
            rY := Random(14);
            if rY in [4..7] then
              rY := 3;
            nX := (m_nCurrX - 7) + rX;
            nY := (m_nCurrY - 7) + rY;
            if m_PEnvir.CanWalk(nX, nY, False) then
              BaseObject.SpaceMove(m_sMapName, nX, nY, 0);
          end
          else if Random(6) - 1 < 0 then
          begin
            nBackDir := GetNextDirection(m_nCurrX, m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
            BaseObject.CharPushed(nBackDir, Random(2) + 1);
            BaseObject.DMSkillFix();
          end;
          SendRefMsg(RM_NORMALEFFECT, 0, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 1, '');
        end;
      end;
    end;
  end;
end;

procedure TMonster.HitMagAttackTarget_ChrPush(TargeTBaseObject: TBaseObject; nHitPower, nMagPower: Integer; boFlag: Boolean);
var
  i: Integer;
  nDamage, nBackDir: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
begin
  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
  BaseObjectList := TList.Create;
  m_PEnvir.GetBaseObjects(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY, False, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject = nil then
      Continue;
    if IsProperTarget(BaseObject) then
    begin
      nDamage := 0;
      Inc(nDamage, BaseObject.GetHitStruckDamage(self, nHitPower));
      Inc(nDamage, BaseObject.GetMagStruckDamage(self, nMagPower));
      if nDamage > 0 then
      begin
        BaseObject.StruckDamage(self, nDamage, 0);
        BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK),
          RM_STRUCKEFFECT,
          nDamage,
          BaseObject.m_WAbil.HP, //MakeLong(BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP),
          BaseObject.m_WAbil.MaxHP,
          Integer(self),
          '',
          200);
      end;
      if Random(6) <= 1 then
      begin
        nBackDir := GetNextDirection(m_nCurrX, m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
        BaseObject.CharPushed(nBackDir, Random(2) + 2);
        BaseObject.DMSkillFix();
      end;
    end;
  end;
  BaseObjectList.Free;
  //SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TMonster.HitMagAttackTarget_WideAttack(TargeTBaseObject: TBaseObject; nHitPower, nMagPower: Integer; boFlag: Boolean);
var
  nC, n10: Integer;
  nX, nY: Integer;
  BaseObject: TBaseObject;
begin
  nC := 0;
  while (True) do
  begin
    n10 := (m_btDirection + g_Config.WideAttack[nC]) mod 8;
    if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, n10, 1, nX, nY) then
    begin
      BaseObject := m_PEnvir.GetMovingObject(nX, nY, True);
      if (nHitPower > 0) and (BaseObject <> nil) and IsProperTarget(BaseObject) then
      begin
        BaseObject.StruckDamage(self, nHitPower, 0);
        BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK),
          RM_STRUCKEFFECT,
          nHitPower,
          BaseObject.m_WAbil.HP, //MakeLong(BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP),
          BaseObject.m_WAbil.MaxHP,
          Integer(self),
          '',
          200);
      end;
    end;
    Inc(nC);
    if nC >= 3 then
      Break;
  end;
  //SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TBloodKingMonster.Run;
var
  i: Integer;
  WAbil: pTAbility;
  BaseObject: TBaseObject;
begin
  if (not m_boGhost) and (not m_boDeath) and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) and (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 5000) or (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
      if (m_nDangerLevel > m_WAbil.HP / m_WAbil.MaxHP * 5) and (m_nDangerLevel > 0) then
      begin
        Dec(m_nDangerLevel);
        WAbil := @m_WAbil;
        if WAbil.HP < WAbil.MaxHP div 2 then
          CallSlave();
      end;
      if m_WAbil.HP = m_WAbil.MaxHP then
        m_nDangerLevel := 5;
    end;
    for i := m_SlaveObjectList.Count - 1 downto 0 do
    begin
      BaseObject := TBaseObject(m_SlaveObjectList.Items[i]);
      if BaseObject.m_boDeath or BaseObject.m_boGhost then
        m_SlaveObjectList.Delete(i);
    end;
  end;
  inherited;
end;

procedure TBloodKingMonster.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
  if WAbil.HP < Round(WAbil.MaxHP * 5 / 9) then
    HitMagAttackTarget_RandomMove(TargeTBaseObject, nPower div 2, nPower div 8, True);
  if WAbil.HP < Round(WAbil.MaxHP * 4 / 7) then
    HitMagAttackTarget_WideAttack(TargeTBaseObject, nPower div 2, nPower div 4, True);
  if WAbil.HP < Round(WAbil.MaxHP * 3 / 5) then
    HitMagAttackTarget_ChrPush(TargeTBaseObject, nPower div 2, nPower div 2, True);
  if Random(8) > 1 then
    MagMakeFireCross(self, Round(nPower / 1.5), nPower div 8, m_nCurrX, m_nCurrY, ET_FIRE {ETTPYE});
  HitMagAttackTarget(TargeTBaseObject, 0, nPower, True);
end;

function TMonster.MagMakeFireCross(BaseObject: TBaseObject; nDamage, nHTime, nX, nY, ETTPYE: Integer): Integer;
var
  FireBurnEvent: TFireBurnEvent;
  i, ii, nRecallX, nRecallY: Integer;
begin
  case BaseObject.m_btRaceServer of
    207:
      begin
        for i := 0 to 5 - 1 do
        begin //三个火
          BaseObject.m_PEnvir.GetNextPosition(nX, nY, m_btDirection, i, nRecallX, nRecallY);
          if BaseObject.m_PEnvir.GetEvent(nRecallX, nRecallY) = nil then
          begin
            FireBurnEvent := TFireBurnEvent.Create(BaseObject, nRecallX, nRecallY, ETTPYE, 5 * 1000, nDamage, 0);
            g_EventManager.AddEvent(FireBurnEvent);
          end;
        end;
      end;
    121, 209: for i := nX - 3 to nX + 3 do
      begin
        for ii := nY - 3 to nY + 3 do
        begin
          if (i = nX) and (ii = nY) then
            Continue;
          if m_PEnvir.GetEvent(i, ii) = nil then
          begin
            FireBurnEvent := TFireBurnEvent.Create(BaseObject, i, ii, ETTPYE, nHTime * 1000, nDamage, 0);
            g_EventManager.AddEvent(FireBurnEvent);
          end;
        end;
      end;
  end;
  Result := 1;
end;

(**********TFireKnightMonster**********)

constructor TFireKnightMonster.Create;
begin
  inherited;
  m_btRaceServer := 207;
end;

destructor TFireKnightMonster.Destroy;
begin
  inherited;
end;

function TFireKnightMonster.FireBurnAttack(bt05: byte): TBaseObject;
var
  WAbil: pTAbility;
  n10: Integer;
  BaseObject: TBaseObject;
begin
  Result := nil;
  m_btDirection := bt05;
  WAbil := @m_WAbil;
  n10 := Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC);
  if n10 > 0 then
  begin
    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    BaseObject := GetPoseCreate();
    if (BaseObject <> nil) and IsProperTarget(BaseObject) and (Random(BaseObject.m_btSpeedPoint) < m_btHitPoint) then
    begin
      n10 := BaseObject.GetMagStruckDamage(self, n10);
      if n10 > 0 then
      begin
        BaseObject.StruckDamage(self, n10, 0);
        BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK),
          RM_STRUCKEFFECT,
          n10,
          BaseObject.m_WAbil.HP, //MakeLong(BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP),
          BaseObject.m_WAbil.MaxHP,
          Integer(self),
          '',
          300);
        MagMakeFireCross(self, n10, n10 {持久}, BaseObject.m_nCurrX, BaseObject.m_nCurrY, ET_FIRE);
        Result := BaseObject;
      end;
    end;
  end;
end;

function TFireKnightMonster.AttackTarget(): Boolean;
var
  btDir: byte;
begin
  Result := False;
  if m_TargetCret = nil then
    Exit;
  if GetAttackDir(m_TargetCret, btDir) then
  begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();
      FireBurnAttack(btDir);
      BreakHolySeizeMode();
    end;
    Result := True;
  end
  else
  begin
    if m_TargetCret.m_PEnvir = m_PEnvir then
      SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
    else
      DelTargetCreat();
  end;
end;

{TEidolonMonster}

constructor TEidolonMonster.Create;
begin
  inherited;
  m_boIsFirst := True;
  m_boFixedHideMode := True;
  m_nViewRangeX := 8;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := 3000;
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 99;
end;

destructor TEidolonMonster.Destroy;
begin
  inherited;
end;

procedure TEidolonMonster.RecalcAbilitys;
var
  ldc, hdc: Integer;
begin
  inherited;
  if (g_Config.nAngelDcEx > 0) and (m_Master <> nil) then
  begin
    ldc := Round(LoWord(m_Master.m_WAbil.SC) / 100 * g_Config.nAngelDcEx);
    hdc := Round(HiWord(m_Master.m_WAbil.SC) / 100 * g_Config.nAngelDcEx);
    if ldc > hdc then
    begin
      m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC) + hdc, HiWord(m_WAbil.DC) + ldc);
    end
    else
    begin
      m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC) + ldc, HiWord(m_WAbil.DC) + hdc);
    end;
  end;
end;

function TEidolonMonster.AttackTarget: Boolean;
begin
  Result := False;
  if (m_TargetCret = nil) or (m_TargetCret.m_boDeath) or (m_TargetCret.m_boGhost) then
    Exit;
  if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
  begin
    m_dwHitTick := GetTickCount();
    if IsProperTarget(m_TargetCret) then
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
      begin
        if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 7) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 7) then
        begin
          m_nTargetX := -1;
          m_dwTargetFocusTick := GetTickCount();
          MagicAttack(m_TargetCret);
          Result := True;
          Exit;
        end
        else
          //if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then
          SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end
      else
        DelTargetCreat();
    end;
  end;
end;

procedure TEidolonMonster.MagicAttack(Target: TBaseObject);
var
  btEffect: byte;
  WAbil: pTAbility;
  nLevel, nDamage: Integer;
  dis: Integer;
begin

  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
  WAbil := @m_WAbil;
  nDamage := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));

  if nDamage > 0 then
    nDamage := Target.GetHitStruckDamage(self, nDamage);

  btEffect := 100;
  nLevel := m_WAbil.Level - Target.m_WAbil.Level;

  if (nLevel > 0) and ((Random(5) = 0) or (Random(nLevel) >= (Random(120)))) then
  begin
    btEffect := 101;
    nDamage := nDamage * 2;
  end;
  if nDamage > 0 then
  begin
    dis := abs(m_nCurrX - Target.m_nCurrX) + abs(m_nCurrY - Target.m_nCurrY);
    Target.SendDelayMsg(self, RM_MAGSTRUCK, 0, nDamage, 1, 0, '', dis * 20 + 600);
    //Target.StruckDamage(nDamage);
    //Target.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(self), '', _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
  end;
  SendRefMsg(RM_SPELL, btEffect, MakeLong(Target.m_nCurrX, Target.m_nCurrY), 0, btEffect, '');
  SendRefMsg(RM_MAGICFIRE, 0, MakeWord(1, btEffect), MakeLong(Target.m_nCurrX, Target.m_nCurrY), Integer(Target), '');

end;

procedure TEidolonMonster.Run;
var
  i: Integer;
  nAbs: Integer;
  nRage: Integer;
  BaseObject: TBaseObject;
  TargeTBaseObject: TBaseObject;
begin
  if m_boIsFirst then
  begin
    m_boIsFirst := False;
    m_btDirection := 5;
    m_boFixedHideMode := False;
    SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  end;
  nRage := 9999;
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if (GetTickCount - m_dwSearchEnemyTick) >= 2500 then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      TargeTBaseObject := nil;
      for i := 0 to m_VisibleActors.Count - 1 do
      begin
        BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
        if BaseObject.m_boDeath then
          Continue;
        if IsProperTarget(BaseObject) then
        begin
          nAbs := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
          if nAbs < nRage then
          begin
            nRage := nAbs;
            TargeTBaseObject := BaseObject;
          end;
        end;
      end;
      if TargeTBaseObject <> nil then
        SetTargetCreat(TargeTBaseObject);
    end;
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) and (m_TargetCret <> nil) then
    begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 1) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 1) then
      begin
        if Random(8) = 0 then
          GetBackPosition(m_nTargetX, m_nTargetY);
      end;
    end;
  end;
  inherited;
end;

{TSnowMonster}

constructor TSnowMonster.Create;
begin
  inherited;

  UserMagic_44.MagicInfo := UserEngine.FindMagic(44, 0);
  UserMagic_44.wMagIdx := 44;
  UserMagic_44.btKey := 0;
  UserMagic_44.btLevel := 3;
  UserMagic_44.nTranPoint := 0;
  //m_MagicList.Add(UserMagic_44);

  m_boSmiteHit := False;
  m_nViewRangeX := 8;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := 3000;
  m_dwSearchTick := GetTickCount();

  m_btRaceServer := 126;
end;

destructor TSnowMonster.Destroy;
begin
  //if UserMagic_44 <> nil then Dispose(UserMagic_44);
  inherited;
end;

function TSnowMonster.AttackTarget: Boolean;
var
  btDir: byte;
  WAbil: pTAbility;
  n, m, l, nDamage: Integer;
  nPower: Integer;
begin
  Result := False;
  if (m_TargetCret = nil) or (m_TargetCret.m_boDeath) or (m_TargetCret.m_boGhost) then
    Exit;

  if m_wAppr = 250 then
  begin
    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, btDir);
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else if GetLongAttackDirX(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwSpellTick2) > Round(m_nNextHitTime * 1.5) then
      begin
        m_dwSpellTick2 := GetTickCount();
        m_btDirection := btDir;
        m_dwTargetFocusTick := GetTickCount();
        nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));
        MagicManager.MagBigExplosion(self, nPower * 2, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 2, 33);
        SendRefMsg(RM_LIGHTING, 2, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
      begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end
      else
      begin
        DelTargetCreat();
      end;
    end;
    Exit;
  end;

  if m_wAppr = 251 then
  begin
    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, btDir);
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else if GetLongAttackDirX(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_btDirection := btDir;
        m_dwTargetFocusTick := GetTickCount();
        nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));
        SwordLongAttackA(nPower * 2);
        SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
      begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end
      else
      begin
        DelTargetCreat();
      end;
    end;
    Exit;
  end;

  if m_wAppr = 255 then
  begin
    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_btDirection := btDir;
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));

        if m_boSmiteHit then
        begin
          m_boSmiteHit := False;
          MagicManager.MagElecBlizzardEx(self, Round(nPower * 2.3), 4);
          SendRefMsg(RM_LIGHTING, 2, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
          Result := True;
          Exit;
        end;

        CrsWideAttack(Round(nPower * 1.5));
        SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');

        if (not m_TargetCret.m_boUnParalysis) and (m_TargetCret.m_wStatusTimeArr[POISON_STONE] = 0) then
        begin
          if (m_WAbil.HP / m_WAbil.MaxHP * 100) < 50 then
          begin
            if GetTickCount - m_dwSpellTick2 > ((10 + Random(6)) * 1000) then
            begin
              m_dwSpellTick2 := GetTickCount;
              m_TargetCret.MakePosion(nil, 0, POISON_STONE, 5 + Random(3), 0);
              //m_TargetCret.SendRefMsg(RM_STRUCKEFFECTEX, 0, 17, 0, 0, '');
              m_boSmiteHit := True;
            end;
          end;
        end;

        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
      begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end
      else
      begin
        DelTargetCreat();
      end;
    end;
    Exit;
  end;

  if (m_wAppr = 256) or (m_wAppr = 268) or (m_wAppr = 267) then
  begin
    case m_wAppr of
      267:
        begin
          m := 4;
          n := GetSelfRangeCount(2);
          l := _MIN(7, 8 - n div 4);
        end;
      268:
        begin
          m := 8;
          n := GetSelfRangeCount(3);
          l := _MIN(7, 9 - n div 5);
        end;
      256:
        begin
          m := 12;
          n := GetSelfRangeCount(4);
          l := _MIN(6, 10 - n div 6);
        end;
    end;
    if (n > m) and (Random(l) = 0) {GetLongAttackDirX(m_TargetCret, btDir)} then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_btDirection := btDir;
        m_dwTargetFocusTick := GetTickCount();
        nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));
        case m_wAppr of
          267: MagicManager.MagElecBlizzardEx(self, Round(nPower * 2.3), 2);
          268: MagicManager.MagElecBlizzardEx(self, Round(nPower * 2.3), 3);
          256: MagicManager.MagElecBlizzardEx(self, Round(nPower * 2.3), 4);
        end;
        SendRefMsg(RM_LIGHTING, 2, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else if (Random(7) = 0) and
      ((m_WAbil.HP / m_WAbil.MaxHP * 100) < 80) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 4) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 4) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        m_dwTargetFocusTick := GetTickCount();
        nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));
        case m_wAppr of
          267: MagicManager.MagElecBlizzardEx(self, Round(nPower * 2.8), 2);
          268: MagicManager.MagElecBlizzardEx(self, Round(nPower * 2.9), 3);
          256: MagicManager.MagElecBlizzardEx(self, Round(nPower * 3.0), 4);
        end;
        //MagicManager.MagElecBlizzardEx(self, nPower * 3, 4);
        SendRefMsg(RM_LIGHTING, 2, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else if GetAttackDir(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, btDir);
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
      begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end
      else
      begin
        DelTargetCreat();
      end;
    end;
    Exit;
  end;

  if m_wAppr = 366 then
  begin
    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, btDir);
        BreakHolySeizeMode();
      end;
      Result := True;
      Exit;
    end;

    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      m_dwHitTick := GetTickCount();
      if IsProperTarget(m_TargetCret) then
      begin
        if m_TargetCret.m_PEnvir = m_PEnvir then
        begin
          if (m_WAbil.HP / m_WAbil.MaxHP * 100) < 80 then
          begin
            if GetTickCount - m_dwSpellTick > 2200 then
            begin
              m_dwSpellTick := GetTickCount;
              WAbil := @m_WAbil;
              nDamage := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC)) * 2;
              SendDelayMsg(self, RM_MAGHEALING, 0, nDamage, 0, 0, '', 800);
              SendRefMsg(RM_SPELL, 2, MakeLong(m_nCurrX, m_nCurrY), nDamage, 2, '');
              SendRefMsg(RM_MAGICFIRE, 3, MakeWord(2, 2), MakeLong(self.m_nCurrX, self.m_nCurrY), Integer(self), '');
              Result := True;
              Exit;
            end;
          end;
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 8) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 8) then
          begin
            m_nTargetX := -1;
            m_dwTargetFocusTick := GetTickCount();
            MagicAttack(m_TargetCret);
            Result := True;
            Exit;
          end
          else
            //if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 8) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 8) then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        end
        else
          DelTargetCreat();
      end;
    end;

    Exit;
  end;

  if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
  begin
    m_dwHitTick := GetTickCount();
    if IsProperTarget(m_TargetCret) then
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
      begin

        if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 8) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 8) then
        begin
          m_nTargetX := -1;
          m_dwTargetFocusTick := GetTickCount();

          case m_wAppr of
            254:
              begin
                if (m_WAbil.HP / m_WAbil.MaxHP * 100) < 70 then
                begin
                  if GetTickCount - m_dwSpellTick > 3200 then
                  begin
                    m_dwSpellTick := GetTickCount;
                    WAbil := @m_WAbil;
                    nDamage := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC)) * 2;
                    SendDelayMsg(self, RM_MAGHEALING, 0, nDamage, 0, 0, '', 800);
                    SendRefMsg(RM_SPELL, 2, MakeLong(m_nCurrX, m_nCurrY), nDamage, 2, '');
                    SendRefMsg(RM_MAGICFIRE, 3, MakeWord(2, 2), MakeLong(self.m_nCurrX, self.m_nCurrY), Integer(self), '');
                    Result := True;
                    Exit;
                  end;
                end;
              end;
          end;

          if not PoisonAttack(m_TargetCret) then
            MagicAttack(m_TargetCret);
          Result := True;
          Exit;
        end
        else
          //if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 8) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 8) then
          SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end
      else
        DelTargetCreat();
    end;
  end;
end;

function TSnowMonster.PoisonAttack(Target: TBaseObject): Boolean;
var
  btEffect: byte;
  WAbil: pTAbility;
  nDamage: Integer;
begin
  Result := False;

  case m_wAppr of
    252:
      begin
        m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
        WAbil := @m_WAbil;
        nDamage := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
        btEffect := 4;
        if (Target.m_wStatusTimeArr[POISON_DECHEALTH] = 0) and (Random(Target.m_btAntiPoison + 2) = 0) then
        begin
          Target.MakePosion(nil, 0, POISON_DECHEALTH, nDamage, 1);
          SendRefMsg(RM_SPELL, btEffect, MakeLong(Target.m_nCurrX, Target.m_nCurrY), nDamage, 6, '');
          SendRefMsg(RM_MAGICFIRE, 3, MakeWord(2, btEffect), MakeLong(Target.m_nCurrX, Target.m_nCurrY), Integer(Target), '');
          Result := True;
        end;
      end;
    253:
      begin
        m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
        WAbil := @m_WAbil;
        nDamage := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
        btEffect := 4;
        if (Target.m_wStatusTimeArr[POISON_DAMAGEARMOR] = 0) and (Random(Target.m_btAntiPoison + 2) = 0) then
        begin
          Target.MakePosion(nil, 0, POISON_DAMAGEARMOR, nDamage, 1);
          SendRefMsg(RM_SPELL, btEffect, MakeLong(Target.m_nCurrX, Target.m_nCurrY), nDamage, 6, '');
          SendRefMsg(RM_MAGICFIRE, 3, MakeWord(2, btEffect), MakeLong(Target.m_nCurrX, Target.m_nCurrY), Integer(Target), '');
          Result := True;
        end;
      end;

  end; //
end;

procedure TSnowMonster.MagicAttack(Target: TBaseObject);
var
  btEffect: byte;
  WAbil: pTAbility;
  nDamage: Integer;
  dis: Integer;
begin

  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
  WAbil := @m_WAbil;
  nDamage := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));

  if nDamage > 0 then
    nDamage := Target.GetHitStruckDamage(self, nDamage);

  if nDamage > 0 then
  begin
    case m_wAppr of
      365:
        begin //SKILL_47
          btEffect := 45;
          SendRefMsg(RM_SPELL, btEffect, MakeLong(Target.m_nCurrX, Target.m_nCurrY), nDamage, SKILL_47, '');
          MagicManager.MagBigExplosion(self, nDamage, Target.m_nCurrX, Target.m_nCurrY, 3, SKILL_47);
          SendRefMsg(RM_MAGICFIRE, 3, MakeWord(2, btEffect), MakeLong(Target.m_nCurrX, Target.m_nCurrY), Integer(Target), '');
        end;
      366:
        begin
          btEffect := 105;
          SendRefMsg(RM_SPELL, btEffect, MakeLong(Target.m_nCurrX, Target.m_nCurrY), nDamage, SKILL_47, '');
          MagicManager.MagBigExplosion(self, nDamage, Target.m_nCurrX, Target.m_nCurrY, 2, SKILL_47);
          SendRefMsg(RM_MAGICFIRE, 3, MakeWord(8, btEffect), MakeLong(Target.m_nCurrX, Target.m_nCurrY), Integer(Target), '');
        end;
      252:
        begin
          btEffect := 31;
          SendRefMsg(RM_SPELL, btEffect, MakeLong(Target.m_nCurrX, Target.m_nCurrY), nDamage, 33, '');
          MagicManager.MagBigExplosion(self, nDamage, Target.m_nCurrX, Target.m_nCurrY, 2, 33);
          SendRefMsg(RM_MAGICFIRE, 3, MakeWord(2, btEffect), MakeLong(Target.m_nCurrX, Target.m_nCurrY), Integer(Target), '');
        end;
      253:
        begin
          btEffect := 34;
          SendRefMsg(RM_SPELL, btEffect, MakeLong(Target.m_nCurrX, Target.m_nCurrY), nDamage, 45, '');
          dis := abs(m_nCurrX - Target.m_nCurrX) + abs(m_nCurrY - Target.m_nCurrY);
          Target.SendDelayMsg(self, RM_MAGSTRUCK, 0, nDamage, 1, 0, '', dis * 20 + 600);
          SendRefMsg(RM_MAGICFIRE, 3, MakeWord(14, btEffect), MakeLong(Target.m_nCurrX, Target.m_nCurrY), Integer(Target), '');
        end;
      254:
        begin
          btEffect := 39;
          SendRefMsg(RM_SPELL, btEffect, MakeLong(Target.m_nCurrX, Target.m_nCurrY), nDamage, 44, '');

          {if UserMagic_44 = nil then begin
            New(UserMagic_44);
            UserMagic_44.MagicInfo := UserEngine.FindMagic(44, 0);
            UserMagic_44.wMagIdx := 44;
            UserMagic_44.btKey := 0;
            UserMagic_44.btLevel := 3;
            UserMagic_44.nTranPoint := 0;
            m_MagicList.Add(UserMagic_44);
          end;}
          try
            //if UserMagic_44 <> nil then
            MagicManager.MagHbFireBall(TPlayObject(self), @UserMagic_44, Target.m_nCurrX, Target.m_nCurrY, UserMagic_44.MagicInfo.wMagicId, Target);

            SendRefMsg(RM_MAGICFIRE, 3, MakeWord(1, btEffect), MakeLong(Target.m_nCurrX, Target.m_nCurrY), Integer(Target), '');
          except
          end;
        end;
    end;
  end;
end;

procedure TSnowMonster.Run;
var
  i: Integer;
  nAbs: Integer;
  nRage: Integer;
  BaseObject: TBaseObject;
  TargeTBaseObject: TBaseObject;
begin
  {if m_boIsFirst then begin
    m_boIsFirst := False;
    m_btDirection := 5;
    m_boFixedHideMode := False;
    SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  end;}
  nRage := 9999;
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if (GetTickCount - m_dwSearchEnemyTick) >= 2500 then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      TargeTBaseObject := nil;
      for i := 0 to m_VisibleActors.Count - 1 do
      begin
        BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
        if BaseObject.m_boDeath then
          Continue;
        if IsProperTarget(BaseObject) then
        begin
          nAbs := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
          if nAbs < nRage then
          begin
            nRage := nAbs;
            TargeTBaseObject := BaseObject;
          end;
        end;
      end;
      if TargeTBaseObject <> nil then
        SetTargetCreat(TargeTBaseObject);
    end;
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) and (m_TargetCret <> nil) then
    begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 1) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 1) then
      begin
        if Random(5) = 0 then
          GetBackPosition(m_nTargetX, m_nTargetY);
      end;
    end;
  end;
  inherited;
end;

{ TDoubleCriticalMonster }

constructor TDoubleCriticalMonster.Create;
begin
  inherited;
  m_n7A0 := 0;
end;

destructor TDoubleCriticalMonster.Destroy;
begin
  inherited;
end;

procedure TDoubleCriticalMonster.Run;
begin
  inherited;
end;

procedure TDoubleCriticalMonster.Attack(Target: TBaseObject; nDir: Integer);
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
  Inc(m_n7A0);
  if (m_n7A0 > 5) or (Random(10) = 0) then
  begin
    m_n7A0 := 0;
    {CODE:0050AEE6                 fild    [ebp+nPower]
    CODE:0050AEE9                 mov     eax, [ebp+WAbil]
    CODE:0050AEEC                 movzx   eax, word ptr [eax+4Ah]
    CODE:0050AEF0                 mov     [ebp+var_18], eax
    CODE:0050AEF3                 fild    [ebp+var_18]
    CODE:0050AEF6                 fdiv    10
    CODE:0050AEFC                 fmulp   st(1), st
    CODE:0050AEFE                 call    @@ROUND
    CODE:0050AF03                 mov     [ebp+nPower], eax
    CODE:0050AF06                 mov     cl, [ebp+var_9]
    CODE:0050AF09                 mov     edx, [ebp+nPower]
    CODE:0050AF0C                 mov     eax, [ebp+WAbil]}
    Run;
  end
  else
    HitMagAttackTarget(Target, 0, nPower, True);
end;

{function TDoubleCriticalMonster.AttackTarget: Boolean;
var
  btDir:Byte;
begin
  Result:=False;
  if m_TargetCret = nil then exit;
  if TargetInSpitRange(m_TargetCret,btDir) then begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
      m_dwHitTick:=GetTickCount();
      m_dwTargetFocusTick:=GetTickCount();
      DoubleAttack(btDir);
      BreakHolySeizeMode();
    end;
    Result:=True;
    exit;
  end;
  if m_TargetCret.m_PEnvir = m_PEnvir then begin
    SetTargetXY(m_TargetCret.m_nCurrX,m_TargetCret.m_nCurrY);
  end else begin
    DelTargetCreat();
  end;

end;

procedure TDoubleCriticalMonster.DoubleAttack(btDir:Byte);
var
  WAbil:pTAbility;
  i,k,nX,nY,nDamage:Integer;
  BaseObject:TBaseObject;
begin
  m_btDirection:=btDir;
  WAbil:=@m_WAbil;
  nDamage:=(Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) +1) + LoWord(WAbil.DC));
  if nDamage <= 0 then exit;
  SendRefMsg(RM_HIT,m_btDirection,m_nCurrX,m_nCurrY,0,'');

  for i:=0 to 4 do begin
  for k:=0 to 4 do begin
   if (g_Config.SpitMap[btDir,i,k] = 1) then begin
    nX := m_nCurrX - 2 + k;
    nY := m_nCurrY - 2 + i;

        BaseObject:=m_PEnvir.GetMovingObject(nX,nY,True);
        if (BaseObject <> nil) and
           (BaseObject <> Self) and
           (IsProperTarget(BaseObject)) and
           (Random(BaseObject.m_btSpeedPoint) < m_btHitPoint) then begin
          nDamage:=BaseObject.GetHitStruckDamage(Self,nDamage);
          if nDamage > 0 then begin
            BaseObject.StruckDamage(nDamage);
            BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK),RM_10101,nDamage,m_WAbil.HP,m_WAbil.MaxHP,Integer(Self),'',300);
          end;
        end;
      end;

    end;
  end;
end;}

{ TDDevilMon }

constructor TDDevil.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boUseMagic := False;
  m_dwSpellTick := GetTickCount();
end;

destructor TDDevil.Destroy;
begin

  inherited;
end;

procedure TDDevil.LightingAttack(nDir: Integer);
var
  WAbil: pTAbility;
  nSX, nSY, nTX, nTY, nPwr: Integer;

begin
  m_btDirection := nDir;
  if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, nDir, 1, nSX, nSY) then
  begin
    m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, nDir, 2, nTX, nTY);
    WAbil := @m_WAbil;
    nPwr := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
    MagPassThroughMagic(nSX, nSY, nTX, nTY, nDir, nPwr, 0, True);
  end;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
end;

procedure TDDevil.Run;
var
  nAttackDir: Integer;
  nX, nY: Integer;
begin
  if (not m_boDeath) and
    (not m_boGhost) and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin

    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
    if m_TargetCret <> nil then
    begin
      nX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
      nY := abs(m_nCurrY - m_TargetCret.m_nCurrY);
      if (nX <= 2) and (nY <= 2) then
      begin
        //if m_boUseMagic or ((nX = 2) or (nY = 2)) then begin
        if (Integer(GetTickCount - m_dwSpellTick) > (m_nNextHitTime * 4)) then
        begin
          m_dwSpellTick := GetTickCount();
          nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          LightingAttack(nAttackDir);
        end;
      end;
    end;
  end;
  inherited Run;
end;

constructor TRedThunderZuma.Create; //004AAE20
begin
  m_dwSearchTime := Random(1500) + 1500;
  m_boStoneMode := True;
  m_nCharStatusEx := STATE_STONE_MODE;
  m_nViewRangeX := 12;
  m_nViewRangeY := m_nViewRangeX;
  m_dwSpellTick := GetTickCount();
  inherited;
end;

destructor TRedThunderZuma.Destroy;
begin
  inherited;
end;

procedure TRedThunderZuma.Run; //004AAF98
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if m_TargetCret <> nil then
    begin
      if (Integer(GetTickCount - m_dwSpellTick) > 2800) then
      begin
        m_dwSpellTick := GetTickCount();
        m_dwHitTick := GetTickCount();
        MagicAttack();
      end;
    end;
  end;
  inherited;
end;

procedure TRedThunderZuma.MagicAttack();
var
  WAbil: pTAbility;
  nPwr: Integer;
begin
  if IsProperTarget(m_TargetCret) then
  begin
    WAbil := @m_WAbil;
    nPwr := (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
    if nPwr > 0 then
      m_TargetCret.SendDelayMsg(self, RM_MAGSTRUCK, 0, nPwr, 1, 0, '', 600);
    SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  end;
end;

{ TStoneMonster }

constructor TStoneMonster.Create;
begin
  inherited;
  m_nViewRangeX := 6;
  m_nViewRangeY := m_nViewRangeX;
  m_boStickMode := True;
end;

destructor TStoneMonster.Destroy;
begin

  inherited;
end;

procedure TStoneMonster.Run;
var
  i, X, Y: Integer;
  nStartX, nStartY, nEndX, nEndY: Integer;
  boRecalc: Boolean;
  BaseObject: TBaseObject;
  xList: TList;
  Buffer: array[0..255] of Byte;
begin
  if (not m_boGhost) and (not m_boDeath) then
  begin
    if GetCurrentTime - m_dwWalkTick > 5000 then
    begin
      m_dwWalkTick := GetCurrentTime;

      nStartX := _MAX(0, m_nCurrX - 3);
      nEndX := _MIN(m_PEnvir.m_MapHeader.wWidth, m_nCurrX + 3);
      nStartY := _MAX(0, m_nCurrY - 3);
      nEndY := _MIN(m_PEnvir.m_MapHeader.wHeight, m_nCurrY + 3);

      xList := TList.Create;
      for X := nStartX to nEndX do
      begin
        for Y := nStartY to nEndY do
        begin

          m_PEnvir.GetBaseObjects(X, Y, True, xList);
          for i := 0 to xList.Count - 1 do
          begin
            BaseObject := TBaseObject(xList.Items[i]);
            boRecalc := False;
            if BaseObject <> nil then
            begin
              if (BaseObject.m_btRaceServer <> RC_PLAYOBJECT) and
                (BaseObject.m_Master = nil) and
                (not BaseObject.m_boGhost) and
                (not BaseObject.m_boDeath) then
              begin

                if BaseObject.m_btRaceServer = 138 {OmaThing :P} then
                begin
                  if BaseObject.m_wStatusArrValue[0] = 0 then
                  begin
                    boRecalc := True;
                    BaseObject.m_wStatusArrValue[0] := 15;
                    BaseObject.m_dwStatusArrTimeOutTick[0] := GetTickCount + 15100;
                  end;
                end
                else
                begin
                  if BaseObject.m_wStatusTimeArr[STATE_DEFENCEUP] = 0 then
                  begin
                    boRecalc := True;
                    BaseObject.m_wStatusTimeArr[STATE_DEFENCEUP] := 8;
                    BaseObject.m_dwStatusArrTick[STATE_DEFENCEUP] := GetTickCount;
                  end;
                  if BaseObject.m_wStatusTimeArr[STATE_MAGDEFENCEUP] = 0 then
                  begin
                    boRecalc := True;
                    BaseObject.m_wStatusTimeArr[STATE_MAGDEFENCEUP] := 8;
                    BaseObject.m_dwStatusArrTick[STATE_MAGDEFENCEUP] := GetTickCount;
                  end;
                end;

                if boRecalc then
                  BaseObject.RecalcAbilitys();
              end;
            end;

            if (Random(6) = 0) and boRecalc then
            begin
              SendRefMsg(RM_HIT, 0, m_nCurrX, m_nCurrY, 0, '');
            end;
          end;
        end;
      end;
      xList.Free;

      if Random(2) = 0 then
      begin
        SendRefMsg(RM_TURN, 0, m_nCurrX, m_nCurrY, 0, '');
      end;
    end;
  end;
  inherited;
end;

{ TSpiderKingMon }

constructor TSpiderKingMon.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TSpiderKingMon.Destroy;
begin
  inherited;
end;

function TSpiderKingMon.AttackTarget(): Boolean;
var
  btDir: byte;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, btDir);
        if (Random(m_TargetCret.m_btAntiPoison + 20) = 0) then
          m_TargetCret.MakePosion(nil, 0, POISON_DECHEALTH, 30, 1);
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
      begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end
      else
      begin
        DelTargetCreat();
      end;
    end;
  end;
end;

procedure TSpiderKingMon.GroupParalysisAttack(nDir: Integer);
var
  i, n: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  magpwr: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := nDir;
  BaseObjectList := TList.Create;
  GetMapBaseObjects(m_TargetCret.m_PEnvir, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (self = BaseObject) then
      Continue;
    if IsProperTarget(BaseObject) then
    begin
      WAbil := @m_WAbil;
      //magpwr := (BaseObject.m_WAbil.MaxHP * LoWord(WAbil.MC)) div 100;
      magpwr := Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC);
      BaseObject.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
      if (not BaseObject.m_boUnParalysis) and (BaseObject.m_wStatusTimeArr[POISON_STONE] = 0) then
      begin
        BaseObject.MakePosion(nil, 0, POISON_STONE, 5, 0);
        BaseObject.SendRefMsg(RM_STRUCKEFFECTEX, 0, 17, 0, 0, '');
        Inc(n);
      end;
    end;
    if n > 30 then
      Break;
  end;
  BaseObjectList.Free;
  if n > 0 then
    SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
end;

procedure TSpiderKingMon.Run;
var
  n08, nAttackDir: Integer;
begin
  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      if m_TargetCret <> nil then
      begin
        n08 := Round(m_WAbil.HP * 40 / m_WAbil.MaxHP) + 1;
        n08 := Random(n08) + 15;
        if (GetTickCount - m_dwGroupParalysisTick > (n08 * 1000)) or (Random(15) = 0) then
        begin
          m_dwGroupParalysisTick := GetTickCount();
          nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          GroupParalysisAttack(nAttackDir);
          m_dwHitTick := GetTickCount();
        end
        else
          AttackTarget();
      end;
    end;
  end;
  inherited;
end;

{ TFrostTigerMonster }

constructor TTiger.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_dwSpellTick := GetTickCount();
  m_dwLastWalkTick := GetTickCount();
  m_boApproach := False;
end;

destructor TTiger.Destroy;
begin
  inherited;
end;

procedure TTiger.Run;
var
  btDir: byte;
begin
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin

    if IsProperTarget(m_TargetCret) then
    begin
      if (Integer(GetTickCount - m_dwLastWalkTick) > m_nWalkSpeed) then
      begin //check if we should walk closer or not and do it :p
        m_dwLastWalkTick := GetTickCount();
        m_nTargetX := m_TargetCret.m_nCurrX;
        m_nTargetY := m_TargetCret.m_nCurrY;
        GotoTargetXY();
      end;
    end;

    if (m_TargetCret <> nil) then
    begin
      if TargetInSpitRange(m_TargetCret, btDir) or GetLongAttackDir_Dis(m_TargetCret, btDir, 3) then
      begin
        if ((GetTickCount - m_dwSpellTick) > 3000 + Random(8 * 1000)) then
        begin
          m_dwHitTick := GetTickCount();
          m_dwSpellTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          m_btDirection := btDir;
          MagAttack();
          BreakHolySeizeMode();
          Exit;
        end;
      end;
    end;

    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget(); //blue
    end;
  end;
  inherited Run;
end;

procedure TTiger.MagAttack();
var
  WAbil: pTAbility;
  nC,n1C, n20: Integer;
  nX, nY: Integer;
  BaseObject: TBaseObject;
begin
  if m_TargetCret = nil then
    Exit;

  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  WAbil := @m_WAbil;
  n20 := (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));

  nC := 1;
  while (True) do
  begin
    if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, nC, nX, nY) then
    begin
      BaseObject := m_PEnvir.GetMovingObject(nX, nY, True);
      if (BaseObject <> nil) and
        (BaseObject <> self) and
        (IsProperTarget(BaseObject)) and
        (Random(BaseObject.m_btSpeedPoint) < m_btHitPoint) then
      begin

        n1C := GetNextDirection(m_nCurrX, m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
        BaseObject.CharPushed(n1C, Random(4) + 2);
        BaseObject.DMSkillFix();
        n20 := BaseObject.GetMagStruckDamage(self, n20);
        if n20 > 0 then
        begin
          BaseObject.StruckDamage(self, n20, 0);
          BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, n20, m_WAbil.HP, m_WAbil.MaxHP, Integer(self), '', 300);
        end;

      end;
    end;
    Inc(nC);
    if nC >= 3 then
      Break;
  end;
end;

procedure TTiger.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
  HitMagAttackTarget(TargeTBaseObject, nPower, 0, True, 1);
end;

{TDragon}

{--------------------------------------------------------------}

constructor TDragon.Create;
begin
  inherited Create;
  m_nViewRangeX := 15;
  m_nViewRangeY := 15;
end;

procedure TDragon.FlameCircle(nDir: Integer);
var
  nPwr: Integer;
  WAbil: pTAbility;
begin
  if IsMoveAble and (m_TargetCret <> nil) then
  begin

    m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);

    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');

    WAbil := @m_WAbil;
    nPwr := (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
    MagicManager.MagBigExplosion(self, nPwr, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 2, 0);
  end;
end;

procedure TDragon.MassThunder();
var
  WAbil: pTAbility;
  magpwr: Integer;
begin
  if (m_TargetCret <> nil) then
  begin
    m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);

    SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
    WAbil := @m_WAbil;
    magpwr := (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
    MagicManager.MagBigExplosion(self, magpwr, m_nCurrX, m_nCurrY, 12, 0);
  end;
end;

function TDragon.AttackTarget: Boolean;
var
  nDir: Integer;
begin

  if (m_TargetCret <> nil) and (GetTickCount - m_dwHitTick > m_nNextHitTime) and IsProperTarget(m_TargetCret) and
    (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 12) and
    (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 12) then
  begin
    m_dwHitTick := GetTickCount();
    nDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
    FlameCircle(nDir);
  end;

  if (m_TargetCret <> nil) and (GetTickCount - m_dwSpellTick > 30 * 1000) and IsProperTarget(m_TargetCret) and
    (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 12) and
    (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 12) then
  begin
    m_dwSpellTick := GetTickCount();
    MassThunder;
  end;

  Result := True;
end;

procedure TDragon.Run;
var
  i, dis, d: Integer;
  cret, nearcret: TBaseObject;
  nX, nY: Integer;
begin
  dis := 9999;
  nearcret := nil;
  if IsMoveAble then
  begin
    if GetTickCount - m_dwSearchEnemyTick > 5000 then
    begin
      m_dwSearchEnemyTick := GetTickCount;
      for i := 0 to m_VisibleActors.Count - 1 do
      begin
        cret := pTVisibleBaseObject(m_VisibleActors[i]).BaseObject;
        if (not cret.m_boDeath) and (IsProperTarget(cret)) and (not cret.m_boHideMode or m_boFixedHideMode) then
        begin
          d := abs(m_nCurrX - cret.m_nCurrX) + abs(m_nCurrY - cret.m_nCurrY);
          if d < dis then
          begin
            dis := d;
            nearcret := cret;
          end;
        end;
      end;
      if nearcret <> nil then
        SetTargetCreat(nearcret);
    end;

    AttackTarget;

    if GetCurrentTime - m_dwWalkTick > m_nWalkSpeed then
    begin
      if m_TargetCret <> nil then

        if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 4) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 4) then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) then
          begin
            if Random(3) = 0 then
            begin
              GetBackPosition(m_nTargetX, m_nTargetY);
              if m_nTargetX <> -1 then
              begin
                GotoTargetXY;
              end;
            end;
          end;
        end
        else if (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 5) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 5) then
        begin
          if Random(2) = 0 then
          begin
            m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
            if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 1, nX, nY) then
            begin
              m_nTargetX := nX;
              m_nTargetY := nY;
              GotoTargetXY;
            end;
          end;
        end;
    end;
  end;
  inherited Run;
end;

{----------------------------------------}

constructor TRebelCommandMonster.Create;
begin
  inherited;
  m_boUnParalysis := True;
  m_boFixedHideMode := False;
  m_btRaceServer := 100;
  m_nViewRangeX := 8;
  m_nViewRangeY := m_nViewRangeX;
  m_dwSpellTick := GetTickCount;
end;

function TRebelCommandMonster.AttackTarget(): Boolean;
var
  nPower: Integer;
  btDir: byte;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin

    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        m_btDirection := btDir;

        nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));
        CrsWideAttack(nPower);
        SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');

        m_TargetCret.StruckDamage(self, nPower, SKILL_BANWOL);
        m_TargetCret.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, nPower,
          m_TargetCret.m_WAbil.HP, m_TargetCret.m_WAbil.MaxHP, Integer(self), '', 200);

        if (not m_TargetCret.m_boUnParalysis) and (Random(5) = 0) then
        begin
          m_TargetCret.MakePosion(nil, 0, POISON_STONE, 5, 0);
        end;
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
      else
        DelTargetCreat();
    end;
  end;

  if (m_TargetCret <> nil) and (GetTickCount - m_dwSpellTick > (18 * 1000 + Random(5) * 1000)) and IsProperTarget(m_TargetCret) and
    (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 8) and
    (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 8) then
  begin
    m_dwSpellTick := GetTickCount();
    nPower := GetAttackPower(LoWord(m_WAbil.MC), SmallInt((HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC))));
    SmiteWideAttack2(nPower);
    SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  end;
end;

end.
