unit ObjMon3;

interface

uses
  Windows, Classes, Grobal2, StrUtils, ObjBase, ObjMon, ObjMon2;

type

  TRonObject = class(TMonster)
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure AroundAttack;
    procedure Run; override;
  end;

  TMinorNumaObject = class(TATMonster)
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TSandMobObject = class(TStickMonster)
  private
    m_dwAppearStart: LongWord;

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TRockManObject = class(TATMonster)
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TMagicMonObject = class(TMonster)
  private
    procedure LightingAttack(nDir: Integer);
  public
    m_boUseMagic: Boolean;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TBoneKingMonster = class(TMonster)
  private
    m_nDangerLevel: Integer;
    m_SlaveObjectList: TList; //0x55C

    procedure MagicAttack(nDir: Integer);
    procedure CallSlave;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override; //0FFED
    procedure Run; override;
  end;

  TPercentMonster = class(TAnimalObject)
    n54C: Integer;
    m_dwThinkTick: LongWord;
    bo554: Boolean;
    m_boDupMode: Boolean;
  private
    function Think: Boolean;
    //    function MakeClone(sMonName:String;OldMon:TBaseObject):TBaseObject;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    function AttackTarget(): Boolean; virtual;
    procedure Run; override;
  end;

  TMagicMonster = class(TAnimalObject)
    n54C: Integer;
    m_dwThinkTick: LongWord;
    m_dwSpellTick: LongWord;
    bo554: Boolean;
    m_boDupMode: Boolean;
  private
    function Think: Boolean;
    //    function MakeClone(sMonName:String;OldMon:TBaseObject):TBaseObject;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    function AttackTarget(): Boolean; virtual;
    procedure Run; override;
  end;

  TFireBallMonster = class(TMagicMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TFireMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TFrostTiger = class(TMonster)
    m_dwSpellTick: LongWord;
    m_dwLastWalkTick: LongWord;
  private
    procedure FrostAttack();
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TGreenMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TRedMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TKhazard = class(TMonster)
    m_dwDragTick: LongWord;
  private
    procedure Drag();
  public
    function AttackTarget(): Boolean; override;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TRunAway = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TTeleMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TDefendMonster = class(TMonster)
  private
  public
    callguardrun: Boolean;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TMinotaurKing = class(TMonster)
  private
    procedure RedCircle(nDir: Integer);
  public
    MassAttackMode: Boolean;
    MassAttackCount: byte;
    NextTarget: TBaseObject;
    nextx, nexty: Integer;
    boMoving: Boolean;
    constructor Create(); override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TMinoGuard = class(TMonster)
  private
    procedure MagicAttack(nDir: Integer);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TNodeMonster = class(TAnimalObject)
    hitcount: Integer;
  private
    procedure search();
    procedure castshield(BaseObject: TBaseObject);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TOmaKing = class(TAnimalObject)
  private
    function AttackTarget(): Boolean;
    procedure RepulseCircle();
    procedure BlueCircle();
  public
    ldistx: Integer;
    ldisty: Integer;
    m_dwSpellTick: LongWord;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TDragonStatue = class(TAnimalObject)
  private
    procedure FireBang();
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  {THolyDeva = class(TMonster)
    m_dwThinkTick: LongWord;
    m_boSpawned: Boolean;
  private
    procedure MagicAttack();
    procedure FindTarget();
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;}

  TYimoogi = class(TMonster)
    m_boActive: Boolean; //if this is true then someone hit it and it's on the offence if not it's on the defence
    m_dwSpellTick: LongWord;
    m_dwPoisonTick: LongWord;
    m_dwThinkTick: LongWord;
    m_counterpart: TBaseObject;
    m_boDied: Boolean;
  private
    procedure MagicAttack();
    procedure PoisonAttack();
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TYimoogiMaster = class(TYimoogi)
  private
    function FindYimoogi(sName: string): TBaseObject;
    procedure CallGuard;
  public
    m_dwLastRecall: LongWord;
    m_dwCloneSpawn: LongWord;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function GetFrontPosition(var nX: Integer; var nY: Integer): Boolean; override;
    procedure CloneDied();
  end;

  TBlackFox = class(TMonster)
    m_boUseMagic: Boolean;
  private
    procedure ThrustAttack(nDir: Integer);
  public
    constructor Create(); override;
    destructor Destroy; override;
    function MagCanHitTarget(nX, nY: Integer; TargeTBaseObject: TBaseObject): Boolean; override;
    procedure Run; override;
  end;

  ////
  TFoxWarrior = class(TATMonster)
    CrazyKingMode: Boolean;
    CriticalMode: Boolean;
    crazytime: LongWord;
    oldhittime: Integer;
    oldwalktime: Integer;
  private
  public
    constructor Create;
    procedure Initialize; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure Run; override;
    function AttackTarget: Boolean; override;
  end;

  TFoxWizard = class(TATMonster)
  private
    WarpTime: LongWord;
  public
    constructor Create;
    procedure Initialize; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure RangeAttack(targ: TBaseObject);
    procedure Run; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    function AttackTarget: Boolean; override;
  end;

  TFoxTaoist = class(TATMonster)
  private
    BoRecallComplete: Boolean;
  public
    constructor Create;
    procedure Initialize; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure RangeAttack(targ: TBaseObject);
    procedure RangeAttack2(targ: TBaseObject);
    procedure Run; override;
    function AttackTarget: Boolean; override;
  end;

  TPushedMon = class(TATMonster)
  private
    DeathCount: Integer;
  public
    AttackWide: Integer;
    constructor Create;
    procedure Initialize; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure Run; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Struck(hiter: TBaseObject); override;
    function AttackTarget: Boolean; override;
  end;

  TFoxPillar = class(TATMonster)
    RunDone: Boolean;
  private
  protected
    function AttackTarget: Boolean; override;
    function FindTarget: Boolean;
  public
    constructor Create;
    procedure RangeAttack(targ: TBaseObject);
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
  end;

  TFoxBead = class(TATMonster)
  public
    RunDone: Boolean;
    TargetTime: LongWord;
    RangeAttackTime: LongWord;
    OldTargetCret: TBaseObject;
    OrgNextHitTime: Integer;
    sectick: LongWord;
    constructor Create;
    procedure Run; override;
    function AttackTarget: Boolean; override;
    function FindTarget: Boolean;
    procedure RangeAttack(targ: TBaseObject);
    procedure RangeAttack2(targ: TBaseObject);
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure Die; override;
  end;

implementation

uses
  UsrEngn, M2Share, Envir, Event, HUtil32, Castle, Guild, SysUtils;

constructor TRonObject.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TRonObject.Destroy;
begin
  inherited;
end;

procedure TRonObject.AroundAttack;
var
  xTargetList: TList;
  BaseObject: TBaseObject;
  wHitMode: Word;
  i: Integer;
begin
  wHitMode := 0;
  GetAttackDir(m_TargetCret, m_btDirection);

  xTargetList := TList.Create;
  GetMapBaseObjects(m_PEnvir, m_nCurrX, m_nCurrY, 1, xTargetList);

  if (xTargetList.Count > 0) then
  begin
    for i := xTargetList.Count - 1 downto 0 do
    begin
      BaseObject := TBaseObject(xTargetList.Items[i]);

      if (BaseObject <> nil) then
      begin
        _Attack(wHitMode, BaseObject); //CM_HIT

        //xTargetList.Delete(i);
      end;
    end;
  end;
  xTargetList.Free;

  SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TRonObject.Run;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;

    if (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) < 6) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 6) and
      (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
    begin

      m_dwHitTick := GetTickCount();
      AroundAttack;
    end;
  end;

  inherited;
end;

constructor TMinorNumaObject.Create;
begin
  inherited;
end;

destructor TMinorNumaObject.Destroy;
begin
  inherited;
end;

procedure TMinorNumaObject.Run;
begin
  if (not m_boDeath) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;

  inherited;
end;

constructor TSandMobObject.Create;
begin
  inherited;
  //m_boHideMode := TRUE;
  nComeOutValue := 8;
end;

destructor TSandMobObject.Destroy;
begin
  inherited;
end;

procedure TSandMobObject.Run;
begin
  if (not m_boDeath) and (not m_boGhost) then
  begin
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
    begin
      m_dwWalkTick := GetTickCount;

      if (m_boFixedHideMode) then
      begin
        if (((m_WAbil.HP > (m_WAbil.MaxHP / 20)) and SearchAttackTarget())) then
          m_dwAppearStart := GetTickCount;
      end
      else
      begin
        if ((m_WAbil.HP > 0) and (m_WAbil.HP < (m_WAbil.MaxHP / 20)) and (GetTickCount - m_dwAppearStart > 3000)) then
          VisbleActors()
        else if (m_TargetCret <> nil) then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 15) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 15) then
          begin
            VisbleActors();
            Exit;
          end;
        end;

        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
          SearchTarget();

        if (not m_boFixedHideMode) then
        begin
          if (AttackTarget) then
            inherited;
        end;
      end;
    end;
  end;

  inherited;
end;

constructor TRockManObject.Create;
begin
  inherited;
  //m_dwSearchTick := 2500 + Random(1500);
  //m_dwSearchTime := GetTickCount();
  m_boHideMode := True;
end;

destructor TRockManObject.Destroy;
begin
  inherited;
end;

procedure TRockManObject.Run;
begin
  {if (not m_fIsDead) and (not m_fIsGhost) then begin
  if (m_fHideMode) then begin
   if (CheckComeOut(8)) then
    ComeOut;

   m_dwWalkTime := GetTickCount + 1000;
  end else begin
   if ((GetTickCount - m_dwSearchEnemyTime > 8000) or ((GetTickCount - m_dwSearchEnemyTime > 1000) and (m_pTargetObject=nil))) then begin
    m_dwSearchEnemyTime := GetTickCount;
    MonsterNormalAttack;

    if (m_pTargetObject=nil) then
     ComeDown;
   end;
  end;
 end;}

  inherited;
end;

{ TMagicMonObject }

constructor TMagicMonObject.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boUseMagic := False;
end;

destructor TMagicMonObject.Destroy;
begin

  inherited;
end;

procedure TMagicMonObject.LightingAttack(nDir: Integer);
begin

end;

procedure TMagicMonObject.Run;
var
  nAttackDir: Integer;
  nX, nY: Integer;
begin
  if (not m_boDeath) and
    (not m_boGhost) and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin

    //ÑªÁ¿µÍÓÚÒ»°ëÊ±¿ªÊ¼ÓÃÄ§·¨¹¥»÷
    if m_WAbil.HP < m_WAbil.MaxHP div 2 then
      m_boUseMagic := True
    else
      m_boUseMagic := False;

    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
    if m_Master = nil then
      Exit;

    nX := abs(m_nCurrX - m_Master.m_nCurrX);
    nY := abs(m_nCurrY - m_Master.m_nCurrY);

    if (nX <= 5) and (nY <= 5) then
    begin
      if m_boUseMagic or ((nX = 5) or (nY = 5)) then
      begin
        if (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
        begin
          m_dwHitTick := GetTickCount();
          nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_Master.m_nCurrX, m_Master.m_nCurrY);
          LightingAttack(nAttackDir);
        end;
      end;
    end;
  end;
  inherited Run;
end;

{ TBoneKingMonster }

constructor TBoneKingMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_nViewRangeX := 8;
  m_nViewRangeY := m_nViewRangeX;
  m_btDirection := 5;
  m_nDangerLevel := 5;
  m_SlaveObjectList := TList.Create;
end;

destructor TBoneKingMonster.Destroy;
begin
  m_SlaveObjectList.Free;
  inherited;
end;

procedure TBoneKingMonster.MagicAttack(nDir: Integer);
var
  target: TBaseObject;
  magpwr: Integer;
  WAbil: pTAbility;
begin
  if m_TargetCret = nil then
    Exit;
  target := m_TargetCret;
  SendRefMsg(RM_FLYAXE, nDir, m_nCurrX, m_nCurrY, Integer(target), '');

  {hit first target}
  if IsProperTarget(target) then
  begin
    if Random(10) >= target.m_nantiMagic then
    begin
      WAbil := @m_WAbil;
      magpwr := (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));

      target.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 0, 0, '', 600);
    end;
  end;
end;

procedure TBoneKingMonster.CallSlave;
const
  sMonName: array[0..2] of string = ('BoneCaptain', 'BoneArcher', 'BoneSpearman');
var
  i: Integer;
  nC: Integer;
  n10, n14: Integer;
  BaseObject: TBaseObject;
begin
  nC := Random(6) + 6;
  GetFrontPosition(n10, n14);

  if m_SlaveObjectList.Count <= 30 then //gotta make sure he has room for extra slaves before he raises his staff lol
    SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(self), ''); //make him raise his staff

  for i := 1 to nC do
  begin
    if m_SlaveObjectList.Count >= 30 then
      Break;
    BaseObject := UserEngine.RegenMonsterByName(m_sMapName, n10, n14, sMonName[Random(3)]);
    if BaseObject <> nil then
    begin
      m_SlaveObjectList.Add(BaseObject);
    end;
  end; // for
end;

procedure TBoneKingMonster.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
  HitMagAttackTarget(TargeTBaseObject, 0, nPower, True);
end;

procedure TBoneKingMonster.Run;
var
  i: Integer;
  BaseObject: TBaseObject;
  nAttackDir: Integer;
begin
  if (not m_boGhost) and
    (not m_boDeath) and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) and
    (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then
  begin

    if (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) >= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) >= 2) and
      (Integer(GetTickCount - m_dwHitTick) > 2200) then
    begin
      if MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret) then
      begin //make sure the 'line' in wich magic will go isnt blocked
        m_dwHitTick := GetTickCount();
        nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        MagicAttack(nAttackDir);
      end;
    end;

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

    for i := m_SlaveObjectList.Count - 1 downto 0 do
    begin
      BaseObject := TBaseObject(m_SlaveObjectList.Items[i]);
      if BaseObject.m_boDeath or BaseObject.m_boGhost then
        m_SlaveObjectList.Delete(i);
    end; // for
  end;
  inherited;
end;

constructor TPercentMonster.Create;
begin
  inherited;
  m_boDupMode := False;
  bo554 := False;
  m_dwThinkTick := GetTickCount();
  m_nViewRangeX := 5;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := 3000 + Random(2000);
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 80;
end;

destructor TPercentMonster.Destroy;
begin
  inherited;
end;

function TPercentMonster.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);

end;

function TPercentMonster.Think(): Boolean; //004A8E54
var
  nOldX, nOldY: Integer;
begin
  Result := False;
  if (GetTickCount - m_dwThinkTick) > 3 * 1000 then
  begin
    m_dwThinkTick := GetTickCount();
    if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then
      m_boDupMode := True;
    if not IsProperTarget {FFFF4}(m_TargetCret) then
      m_TargetCret := nil;
  end; //004A8ED2
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

function TPercentMonster.AttackTarget(): Boolean; //004A8F34
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
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
      begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY); {0FFF0h}
      end
      else
      begin
        DelTargetCreat(); {0FFF1h}
      end;
    end;
  end;
end;

procedure TPercentMonster.Run; //004A9020
var
  nX, nY: Integer;
begin
  if not m_boGhost and
    not m_boDeath and
    not m_boFixedHideMode and
    not m_boStoneMode and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Think then
    begin
      inherited;
      Exit;
    end;
    if m_boWalkWaitLocked then
    begin
      if (GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait then
      begin
        m_boWalkWaitLocked := False;
      end;
    end;
    if not m_boWalkWaitLocked and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
    begin
      m_dwWalkTick := GetTickCount();
      Inc(m_nWalkCount);
      if m_nWalkCount > m_nWalkStep then
      begin
        m_nWalkCount := 0;
        m_boWalkWaitLocked := True;
        m_dwWalkWaitTick := GetTickCount();
      end; //004A9151
      if not m_boRunAwayMode then
      begin
        if not m_boNoAttackMode then
        begin
          if m_TargetCret <> nil then
          begin
            if AttackTarget {FFEB} then
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
            end; //004A91D3
          end;
        end; //004A91D3  if not bo2C0 then begin
        if m_Master <> nil then
        begin
          if m_TargetCret = nil then
          begin
            m_Master.GetBackPosition(nX, nY);
            if (abs(m_nTargetX - nX) > 1) or (abs(m_nTargetY - nY {nX}) > 1) then
            begin //004A922D
              m_nTargetX := nX;
              m_nTargetY := nY;
              if (abs(m_nCurrX - nX) <= 2) and (abs(m_nCurrY - nY) <= 2) then
              begin
                if m_PEnvir.GetMovingObject(nX, nY, True) <> nil then
                begin
                  m_nTargetX := m_nCurrX;
                  m_nTargetY := m_nCurrY;
                end //004A92A5
              end;
            end; //004A92A5
          end; //004A92A5 if m_TargetCret = nil then begin
          if (not m_Master.m_boSlaveRelax) and
            ((m_PEnvir <> m_Master.m_PEnvir) or
            (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or
            (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then
          begin
            //  sysmsg('recalling to my master',c_red,t_hint);
            SpaceMove(m_Master.m_PEnvir.m_sMapFileName, m_nTargetX, m_nTargetY, 1);
          end; // 004A937E
        end; // 004A937E if m_Master <> nil then begin
      end
      else
      begin //004A9344
        if (m_dwRunAwayTime > 0) and ((GetTickCount - m_dwRunAwayStart) > m_dwRunAwayTime) then
        begin
          m_boRunAwayMode := False;
          m_dwRunAwayTime := 0;
        end;
      end; //004A937E
      if (m_Master <> nil) and m_Master.m_boSlaveRelax then
      begin
        inherited;
        Exit;
      end; //004A93A6
      if m_nTargetX <> -1 then
      begin
        GotoTargetXY(); //004A93B5 0FFEF
      end
      else
      begin
        if m_TargetCret = nil then
          Wondering(); // FFEE   //Jacky
      end; //004A93D8
    end;
  end; //004A93D8

  inherited;
end;

constructor TMagicMonster.Create; //004A8B74
begin
  inherited;
  m_boDupMode := False;
  bo554 := False;
  m_dwThinkTick := GetTickCount();
  m_nViewRangeX := 8;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := 3000 + Random(2000);
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 215;
end;

destructor TMagicMonster.Destroy; //004A8C24
begin
  inherited;
end;

function TMagicMonster.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);

end;

function TMagicMonster.Think(): Boolean; //004A8E54
var
  nOldX, nOldY: Integer;
begin
  Result := False;
  if (GetTickCount - m_dwThinkTick) > 3 * 1000 then
  begin
    m_dwThinkTick := GetTickCount();
    if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then
      m_boDupMode := True;
    if not IsProperTarget {FFFF4}(m_TargetCret) then
      m_TargetCret := nil;
  end; //004A8ED2
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

function TMagicMonster.AttackTarget(): Boolean; //004A8F34
var
  bt06: byte;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if m_TargetCret = m_Master then
    begin //nicky
      m_TargetCret := nil;
    end
    else
    begin
      if GetAttackDir(m_TargetCret, bt06) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          // Attack(m_TargetCret,bt06);  //FFED
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
end;

procedure TMagicMonster.Run; //004A9020
var
  nX, nY: Integer;
begin
  if not m_boGhost and
    not m_boDeath and
    not m_boFixedHideMode and
    not m_boStoneMode and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Think then
    begin
      inherited;
      Exit;
    end;
    if m_boWalkWaitLocked then
    begin
      if (GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait then
      begin
        m_boWalkWaitLocked := False;
      end;
    end;
    if not m_boWalkWaitLocked and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
    begin
      m_dwWalkTick := GetTickCount();
      Inc(m_nWalkCount);
      if m_nWalkCount > m_nWalkStep then
      begin
        m_nWalkCount := 0;
        m_boWalkWaitLocked := True;
        m_dwWalkWaitTick := GetTickCount();
      end; //004A9151
      if not m_boRunAwayMode then
      begin
        if not m_boNoAttackMode then
        begin
          if m_TargetCret <> nil then
          begin
            if AttackTarget {FFEB} then
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
            end; //004A91D3
          end;
        end; //004A91D3  if not bo2C0 then begin
        if m_Master <> nil then
        begin
          if m_TargetCret = nil then
          begin
            m_Master.GetBackPosition(nX, nY);
            if (abs(m_nTargetX - nX) > 1) or (abs(m_nTargetY - nY {nX}) > 1) then
            begin //004A922D
              m_nTargetX := nX;
              m_nTargetY := nY;
              if (abs(m_nCurrX - nX) <= 2) and (abs(m_nCurrY - nY) <= 2) then
              begin
                if m_PEnvir.GetMovingObject(nX, nY, True) <> nil then
                begin
                  m_nTargetX := m_nCurrX;
                  m_nTargetY := m_nCurrY;
                end //004A92A5
              end;
            end; //004A92A5
          end; //004A92A5 if m_TargetCret = nil then begin
          if (not m_Master.m_boSlaveRelax) and
            ((m_PEnvir <> m_Master.m_PEnvir) or
            (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or
            (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then
          begin
            //  sysmsg('recalling to my master',c_red,t_hint);
            SpaceMove(m_Master.m_PEnvir.m_sMapFileName, m_nTargetX, m_nTargetY, 1);
          end; // 004A937E
        end; // 004A937E if m_Master <> nil then begin
      end
      else
      begin //004A9344
        if (m_dwRunAwayTime > 0) and ((GetTickCount - m_dwRunAwayStart) > m_dwRunAwayTime) then
        begin
          m_boRunAwayMode := False;
          m_dwRunAwayTime := 0;
        end;
      end; //004A937E
      if (m_Master <> nil) and m_Master.m_boSlaveRelax then
      begin
        inherited;
        Exit;
      end; //004A93A6
      if m_nTargetX <> -1 then
      begin
        GotoTargetXY(); //004A93B5 0FFEF
      end
      else
      begin
        if m_TargetCret = nil then
          Wondering(); // FFEE   //Jacky
      end; //004A93D8
    end;
  end; //004A93D8

  inherited;

end;
{ end }

{TFireballMonster}

constructor TFireBallMonster.Create; //004A9690
begin
  inherited;
  m_dwSpellTick := GetTickCount();
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TFireBallMonster.Destroy;
begin
  inherited;
end;

procedure TFireBallMonster.Run;
var
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  if not m_boDeath and
    not bo554 and
    not m_boGhost then
  begin
    if m_TargetCret <> nil then
    begin
      if self.MagCanHitTarget(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret) then
      begin
        if self.IsProperTarget(m_TargetCret) then
        begin
          if (abs(m_nTargetX - m_nCurrX) <= 8) and (abs(m_nTargetY - m_nCurrY) <= 8) then
          begin
            nPower := Random(Abs(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1) + LoWord(m_WAbil.MC);
            if nPower > 0 then
            begin
              BaseObject := GetPoseCreate();
              if (BaseObject <> nil) and
                IsProperTarget(BaseObject) and
                (m_nantiMagic >= 0) then
              begin
                nPower := BaseObject.GetMagStruckDamage(self, nPower);
                if nPower > 0 then
                begin
                  if Integer((GetTickCount - m_dwSpellTick)) > self.m_nNextHitTime then
                  begin
                    m_dwSpellTick := GetTickCount();
                    self.SendRefMsg(RM_SPELL, 48, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 48, '');
                    self.SendRefMsg(RM_MAGICFIRE, 0,
                      MakeWord(2, 48),
                      MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY),
                      Integer(m_TargetCret),
                      '');
                    BaseObject.StruckDamage(self, nPower, 0);
                    self.SendDelayMsg(TBaseObject(RM_STRUCK), RM_DELAYMAGIC, 2, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), nPower, Integer(m_TargetCret), '', 600);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
      BreakHolySeizeMode();
    end
    else
      m_TargetCret := nil;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

constructor TFireMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TFireMonster.Destroy;
begin

  inherited;
end;

procedure TFireMonster.Run; //004A9720
var
  FireBurnEvent: TFireBurnEvent;
  nX, nY, nDamage, nTime: Integer;
begin
  if not m_boDeath and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    // do sqaure around boss
    nTime := 20;
    nDamage := 10;
    nX := m_nCurrX;
    nY := m_nCurrY;

    if m_PEnvir.GetEvent(nX, nY - 1) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(self, nX, nY - 1, ET_FIRE, nTime * 1000, nDamage, 0);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //0492CFC   x //
    if m_PEnvir.GetEvent(nX, nY - 2) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(self, nX, nY - 2, ET_FIRE, nTime * 1000, nDamage, 0);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //0492CFC   x

    if m_PEnvir.GetEvent(nX - 1, nY) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(self, nX - 1, nY, ET_FIRE, nTime * 1000, nDamage, 0);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //0492D4D //
    if m_PEnvir.GetEvent(nX - 2, nY) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(self, nX - 2, nY, ET_FIRE, nTime * 1000, nDamage, 0);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //0492D4D

    if m_PEnvir.GetEvent(nX, nY) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(self, nX, nY, ET_FIRE, nTime * 1000, nDamage, 0);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //00492D9C

    if m_PEnvir.GetEvent(nX + 1, nY) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(self, nX + 1, nY, ET_FIRE, nTime * 1000, nDamage, 0);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //00492DED
    if m_PEnvir.GetEvent(nX + 2, nY) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(self, nX + 2, nY, ET_FIRE, nTime * 1000, nDamage, 0);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //00492DED

    if m_PEnvir.GetEvent(nX, nY + 1) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(self, nX, nY + 1, ET_FIRE, nTime * 1000, nDamage, 0);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //00492E3E
    if m_PEnvir.GetEvent(nX, nY + 2) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(self, nX, nY + 2, ET_FIRE, nTime * 1000, nDamage, 0);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //00492E3E

    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

{ TFrostTigerMonster }

constructor TFrostTiger.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_dwSpellTick := GetTickCount();
  m_dwLastWalkTick := GetTickCount();
  m_boApproach := False;
end;

destructor TFrostTiger.Destroy;
begin
  inherited;
end;

procedure TFrostTiger.Run; //004A9720
begin
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin

    if m_TargetCret = nil then
    begin //if theres no target stay transparent

      if not m_boHideMode then
      begin
        if (GetTickCount - m_dwLastWalkTick > 2000) then
        begin
          m_dwLastWalkTick := GetTickCount();
          MagicManager.MagMakePrivateTransparent(self, 180);
          SendRefMsg(RM_DIGDOWN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
        end;
      end
      else
        m_dwLastWalkTick := GetTickCount();
    end
    else
    begin
      //there is a target so take of transparency
      if not m_TargetCret.m_boDeath then
      begin
        if m_boHideMode then
        begin
          m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] := 1;
          SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
        end;
      end
      else
        m_TargetCret := nil;
      if m_TargetCret <> nil then //blue
        if (Integer(GetTickCount - m_dwLastWalkTick) > m_nWalkSpeed) then
        begin //check if we should walk closer or not and do it :p
          m_dwLastWalkTick := GetTickCount();
          m_nTargetX := m_TargetCret.m_nCurrX;
          m_nTargetY := m_TargetCret.m_nCurrY;
          GotoTargetXY();
        end;
    end;

    if ((GetTickCount - m_dwSpellTick) > 3000) and (m_TargetCret <> nil) then
    begin
      if (abs(m_TargetCret.m_nCurrX - m_nCurrX) >= 2) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) >= 2) then
      begin
        m_dwSpellTick := GetTickCount();
        FrostAttack();
      end;
    end;

    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget(); //blue
    end;
  end;
  inherited;
end;

procedure TFrostTiger.FrostAttack();
var
  target: TBaseObject;
  magpwr: Integer;
  WAbil: pTAbility;
begin
  if m_TargetCret = nil then
    Exit;
  target := m_TargetCret;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(target), '');

  if IsProperTarget(target) then
  begin
    if Random(10) >= target.m_nantiMagic then
    begin
      WAbil := @m_WAbil;
      magpwr := (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
      target.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 0, 0, '', 600);
      if (Random(15) <= 3) and (Random(target.m_btAntiPoison) = 0) then
        target.MakePosion(nil, 0, POISON_FREEZE, (2 * 3), 0);
      if (Random(40) <= 3) and (Random(target.m_btAntiPoison) = 0) then
      begin
        target.MakePosion(nil, 0, POISON_SHOCKED, 5, 0);
        target.MakePosion(nil, 0, POISON_STONE, 5, 0);
      end;
    end;
  end;
end;

{ TGreenMonster }

constructor TGreenMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TGreenMonster.Destroy;
begin

  inherited;
end;

procedure TGreenMonster.Run; //004A9720
begin
  if not m_boDeath and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if m_TargetCret <> nil then
    begin
      m_nTargetX := m_TargetCret.m_nCurrX;
      m_nTargetY := m_TargetCret.m_nCurrY;
      if (abs(m_nTargetX - m_nCurrX) = 1) and (abs(m_nTargetY - m_nCurrY) = 1) then
      begin
        if (Random(m_TargetCret.m_btAntiPoison + 7) <= 6) and (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) then
        begin
          m_TargetCret.MakePosion(nil, 0, POISON_DECHEALTH, 30, 1);
        end;
      end;
    end;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

{ TRedMonster }

constructor TRedMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TRedMonster.Destroy;
begin

  inherited;
end;

procedure TRedMonster.Run; //004A9720
begin
  if not m_boDeath and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if m_TargetCret <> nil then
    begin
      m_nTargetX := m_TargetCret.m_nCurrX;
      m_nTargetY := m_TargetCret.m_nCurrY;
      if (abs(m_nTargetX - m_nCurrX) = 1) and (abs(m_nTargetY - m_nCurrY) = 1) then
      begin
        if (Random(m_TargetCret.m_btAntiPoison + 7) <= 6) and (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) then
        begin
          m_TargetCret.MakePosion(nil, 0, POISON_DAMAGEARMOR, 30, 1);
        end;
      end;
    end;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

{ khazard }

constructor TKhazard.Create; //004A9690
begin
  inherited;
  m_dwThinkTick := GetTickCount();
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TKhazard.Destroy;
begin
  inherited;
end;

procedure TKhazard.Run; //004A9720
var
  time1: Integer;
begin
  if not m_boGhost and
    not m_boDeath and
    not m_boFixedHideMode and
    not m_boStoneMode and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    time1 := Random(3);
    if m_TargetCret <> nil then
    begin

      //attack code
      if IsProperTarget(m_TargetCret) then
      begin
        m_nTargetX := m_TargetCret.m_nCurrX;
        m_nTargetY := m_TargetCret.m_nCurrY;
        if (abs(m_nTargetX - m_nCurrX) = 2) or (abs(m_nTargetY - m_nCurrY) = 2) then
        begin
          if (GetTickCount - m_dwThinkTick) > 1000 then
          begin //do drag back on random
            m_dwThinkTick := GetTickCount();
            if time1 < 1 then
              Drag();
          end
          else
            AttackTarget();
        end;
      end;
    end;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

procedure TKhazard.Drag();
var
  nX, nY: Integer;
  nAttackDir: Integer;
begin
  nAttackDir := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_nCurrX, m_nCurrY); //technicaly this is the dir the target would be facing if he was hitting us
  GetFrontPosition(nX, nY);
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');

  m_TargetCret.CharPushed(nAttackDir, 1);
  if (Random(2) = 0) and (Random(m_TargetCret.m_btAntiPoison + 7) <= 6) then
  begin
    m_TargetCret.MakePosion(nil, 0, POISON_DECHEALTH, 35, 2);
    Exit;
  end;
end;

function TKhazard.AttackTarget(): Boolean; //004A8F34
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
        if (Random(1) = 0) and (Random(m_TargetCret.m_btAntiPoison + 7) <= 6) then
        begin
          m_TargetCret.MakePosion(nil, 0, POISON_DECHEALTH, 35, 2);
          Exit;
        end;
      end;
      Result := True;
    end;
  end;
end;

{ end }

{ runaway }

constructor TRunAway.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TRunAway.Destroy;
begin

  inherited;
end;

procedure TRunAway.Run; //004A9720
var
  time1, nX, nY: Integer;
  borunaway: Boolean;
begin
  if not m_boDeath and not m_boGhost then
  begin
    if m_TargetCret <> nil then
    begin
      m_nTargetX := m_TargetCret.m_nCurrX;
      m_nTargetY := m_TargetCret.m_nCurrY;
      if (m_WAbil.HP <= Round(m_WAbil.MaxHP div 2)) and (borunaway = False) then
      begin //if health less then 1/2
        GetFrontPosition(nX, nY);
        SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
        SpaceMove(m_sMapName, nX - 2, nY - 2, 0); //move backwards 3 spaces
        borunaway := True;
      end
      else
      begin
        if m_WAbil.HP >= Round(m_WAbil.MaxHP div 2) then
        begin
          borunaway := False;
        end;
      end;
      if borunaway then
      begin
        if Integer(GetTickCount - time1) > 5000 then
        begin
          if (abs(m_nTargetX - m_nCurrX) = 1) and (abs(m_nTargetY - m_nCurrY) = 1) then
          begin
            WalkTo(Random(4), True);
          end
          else
          begin
            WalkTo(Random(7), True);
          end;
        end ;
        {
        else
        begin
          time1 := GetTickCount();
        end;
        }
      end;
    end;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;
{ end }

{ Tele mob }

constructor TTeleMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TTeleMonster.Destroy;
begin
  inherited;
end;

procedure TTeleMonster.Run; //004A9720
begin
  if not m_boDeath and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    //if it finds a target tele to him!
    if m_TargetCret <> nil then
    begin
      if (abs(m_nCurrX - m_nTargetX) > 5) or
        (abs(m_nCurrY - m_nTargetY) > 5) then
      begin
        // if 5 spaces away teleport to the enemy!
        SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
        SpaceMove(m_TargetCret.m_sMapName, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 0);
      end;
    end;
    //end
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;
{ end }

{ Defend Monster }

constructor TDefendMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TDefendMonster.Destroy;
begin
  inherited;
end;

procedure TDefendMonster.Run;
begin
  inherited;
end;

{Minotaur King}

constructor TMinotaurKing.Create; //004AA4B4
begin
  inherited;
  nextx := 0;
  nexty := 0;
  boMoving := False;
  MassAttackMode := False;
  MassAttackCount := 0;
  NextTarget := nil;
  m_boApproach := False; //stops mtk from going towards players
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TMinotaurKing.Destroy;
begin
  inherited;
end;

function TMinotaurKing.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  if (ProcessMsg.wIdent = RM_MAGSTRUCK) and (not MassAttackMode) then
  begin
    //they used magic now pwn them with redcircle!!!!!!
    MassAttackMode := True;
    MassAttackCount := 0;
  end;
  Result := inherited Operate(ProcessMsg);
end;

procedure TMinotaurKing.RedCircle(nDir: Integer);
var
  i: Integer;
  magpwr: Integer;
  WAbil: pTAbility;
  BaseObject: TBaseObject;
  target: TBaseObject;
begin
  //target selected
  m_btDirection := nDir;
  { get first target }
  if NextTarget <> nil then
  begin
    target := NextTarget;
    NextTarget := nil;
  end
  else
  begin
    target := m_TargetCret;
  end;
  {do spell effect}
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(target), '');

  {do hit radius around target}
  for i := 0 to target.m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(target.m_VisibleActors.Items[i]).BaseObject);
    if (abs(target.m_nCurrX - BaseObject.m_nCurrX) <= 3) and (abs(target.m_nCurrY - BaseObject.m_nCurrY) <= 3) then
    begin
      //if in 3 radious range get hit
      if BaseObject <> nil then
      begin
        if (BaseObject.m_PEnvir = self.m_PEnvir) and IsProperTarget(BaseObject) then
        begin
          if Random(3) = 0 then
            NextTarget := BaseObject;
          if Random(10) >= BaseObject.m_nantiMagic then
          begin
            WAbil := @m_WAbil;
            magpwr := (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
            BaseObject.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 0, 0, '', 600);
          end;
        end;
      end;
    end;
  end;
end;

procedure TMinotaurKing.Run; //004AA604
var
  nAttackDir: Integer;
  distx, disty, distx2, disty2: Integer;
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

    //walk code (only make him to towards a target if it's just at the edge of our view range
    if (m_TargetCret <> nil) then
    begin
      distx := abs(m_nCurrX - m_TargetCret.m_nCurrX);
      disty := abs(m_nCurrY - m_TargetCret.m_nCurrY);
      if (nextx = 0) and (nexty = 0) then
      begin
        nextx := m_TargetCret.m_nCurrX;
        nexty := m_TargetCret.m_nCurrY;
      end;
    end;
    if boMoving then
    begin //if moving is true check if we havent reached our destination
      if ((m_nCurrX = nextx) and (m_nCurrY = nexty)) then
      begin
        boMoving := False;
        nextx := 0;
        nexty := 0;
      end;
      distx2 := abs(m_nCurrX - nextx);
      disty2 := abs(m_nCurrY - nexty);
      if (distx2 < 2) and (disty2 < 2) and (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, self, nextx, nexty, False) <= 0) then
      begin //if we reached our destination, should add a code to check if there's nobody else there later
        boMoving := False;
        nextx := 0;
        nexty := 0;
      end;
    end;
    if ((m_TargetCret = nil) or ((distx > 7) or (disty > 7))) and (nextx <> 0) and (nexty <> 0) then
      boMoving := True;

    if boMoving then
    begin
      if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
      begin //check if we should walk closer or not and do it :p
        m_dwWalkTick := GetTickCount();
        m_nTargetX := nextx;
        m_nTargetY := nexty;
        GotoTargetXY();
      end;
    end;

    {attack them at distance}
    if (m_TargetCret <> nil) and
      (_MAX(distx, disty) > 1) and
      (Integer(GetTickCount - m_dwHitTick) > 1200) and
      (not MassAttackMode) then
    begin
      nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      m_dwHitTick := GetTickCount();
      RedCircle(nAttackDir);
    end;

    {Actual magic attack if hes hit by magic}
    if (Integer(GetTickCount - m_dwHitTick) > 1200) and (m_TargetCret <> nil) then
    begin
      if (MassAttackMode) then
      begin
        if (MassAttackCount <= 5) then
        begin
          m_dwHitTick := GetTickCount();
          Inc(MassAttackCount);
          nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          RedCircle(nAttackDir);
        end
        else
        begin
          MassAttackCount := 0;
          MassAttackMode := False;
        end;
      end;
    end;
  end;
  inherited;
end;

{LEFT & RIGHT GUARDS}

constructor TMinoGuard.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_dwHitTick := GetTickCount();
end;

destructor TMinoGuard.Destroy;
begin
  inherited;
end;

procedure TMinoGuard.MagicAttack(nDir: Integer);
var
  target: TBaseObject;
  magpwr: Integer;
  WAbil: pTAbility;
begin
  if m_TargetCret <> nil then
    target := m_TargetCret;

  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(target), '');

  {Hit first Target}
  if IsProperTarget(target) then
  begin
    if Random(10) >= target.m_nantiMagic then
    begin
      WAbil := @m_WAbil;
      magpwr := (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
      target.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 0, 0, '', 600);
    end;
  end;
end;

procedure TMinoGuard.Run; //004A9720
var
  nAttackDir: Integer;
begin
  if not m_boDeath and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin

    if (m_TargetCret <> nil) and
      ((abs(m_nCurrX - m_TargetCret.m_nCurrX) >= 2) or
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) >= 2)) and
      (Integer(GetTickCount - m_dwHitTick) > 2200) then
    begin
      if (MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret)) or (m_btRaceImg <> 70) then
      begin //make sure the 'line' in wich magic will go isnt blocked
        m_dwHitTick := GetTickCount();
        nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        MagicAttack(nAttackDir);
      end;
    end;

    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

constructor TNodeMonster.Create;
begin
  inherited;
  m_boAnimal := False;
end;

destructor TNodeMonster.Destroy;
begin
  inherited;
end;

procedure TNodeMonster.Run; //004A617C
var
  Buffer: array[0..255] of Byte;
begin
  if (not m_boDeath) and (not m_boGhost) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 18000) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      search();
    end;
    if Integer(GetTickCount - m_dwWalkTick) > (m_nWalkSpeed) then
    begin
      m_dwWalkTick := GetTickCount();
      SendRefMsg(RM_TURN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    end;
  end;
  inherited;
end;

procedure TNodeMonster.search(); //find all the 'allies' (aka other mobs) nearby
var
  xTargetList: TList;
  BaseObject: TBaseObject;
  i: Integer;
begin
  xTargetList := TList.Create;
  GetMapBaseObjects(m_PEnvir, m_nCurrX, m_nCurrY, 12, xTargetList);
  if (xTargetList.Count > 0) then
  begin
    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    for i := xTargetList.Count - 1 downto 0 do
    begin
      BaseObject := TBaseObject(xTargetList.Items[i]);
      if (BaseObject <> nil) then
      begin
        if not (BaseObject.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) then
          castshield(BaseObject)
      end;
    end;
  end;
  xTargetList.Free;
end;

procedure TNodeMonster.castshield(BaseObject: TBaseObject); //give our friend his shield
var
  nSec: Integer;
begin
  nSec := 20; //set it to 20 seconds 'shield' since the search is only done every 18seconds this means the shield lasts forever technicaly (provided mob stays in range)
  if m_btRaceImg = 75 then
  begin //red one: give dc
    BaseObject.AttPowerUp(m_WAbil.MC, nSec)
  end
  else
  begin //blue one: give ac+amc
    BaseObject.DefenceUp(nSec, 0);
    BaseObject.MagDefenceUp(nSec, 0);
  end;
end;

constructor TOmaKing.Create;
begin
  inherited;
  ldistx := 0;
  ldisty := 0;
  m_dwSearchTime := Random(1500) + 1500;
  m_dwSpellTick := GetTickCount();
  m_boAnimal := False;
end;

destructor TOmaKing.Destroy;
begin
  inherited;
end;

procedure TOmaKing.Run; //004AA604
var
  distx, disty: Integer;
  nDir: Integer;
begin
  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    //walk codes next (since ok doesnt go near players like other mobs do this is hopefully a correct code)
    if (m_TargetCret <> nil) then
    begin
      if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
      begin //check if we should walk closer or not and do it :p
        m_dwWalkTick := GetTickCount();
        distx := abs(m_nCurrX - m_TargetCret.m_nCurrX);
        disty := abs(m_nCurrY - m_TargetCret.m_nCurrY);
        GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        if (distx > ldistx) or (disty > ldisty) or (distx > 5) or (disty > 5) then
        begin //if the last distance from us is further then the current (aka if they running)
          if ((distx > 2) or (disty > 2)) and ((distx < 12) and (disty < 12)) then
          begin //restrict the maximum pursuit distance to 12 coords away
            //WalkTo(nDir,False);
            m_nTargetX := m_TargetCret.m_nCurrX;
            m_nTargetY := m_TargetCret.m_nCurrY;
            GotoTargetXY;
            ldistx := abs(m_nCurrX - m_TargetCret.m_nCurrX);
            ldisty := abs(m_nCurrY - m_TargetCret.m_nCurrY);
            inherited;
            Exit;
          end;
        end;

        ldistx := distx;
        ldisty := disty;
      end;
    end;
    //regular attack code
    if (m_TargetCret <> nil) and (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) and
      (Integer(GetTickCount - m_dwSpellTick) > m_nNextHitTime) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) and
      ((abs(m_nCurrY - m_TargetCret.m_nCurrY) + abs(m_nCurrX - m_TargetCret.m_nCurrX)) <= 3) then
    begin
      m_dwHitTick := GetTickCount();
      if (Random(8) = 0) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 1) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 1) then
      begin //10% chance he just attacks)
        AttackTarget(); //no point trying to hit something that isnt close enough :p
        if (Random(10) = 0) then
          m_TargetCret.MakePosion(nil, 0, POISON_STONE, 5, 0);
      end
      else //does repulse
        RepulseCircle();
    end;

    //magic attack code
    if (m_TargetCret <> nil) then
    begin
      nDir := Round(m_WAbil.HP * 8 * 1000 / m_WAbil.MaxHP);
      if (Integer(GetTickCount - m_dwSpellTick) > (m_nNextHitTime + nDir)) then
      begin
        m_dwSpellTick := GetTickCount();
        BlueCircle();
      end;
    end;

    //search for targets nearbye
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

procedure TOmaKing.BlueCircle();
var
  i: Integer;
  magpwr: Integer;
  WAbil: pTAbility;
  BaseObject: TBaseObject;
  //Target                    : TBaseObject;
  nDir: Integer;
begin
  if m_TargetCret = nil then
    Exit;
  //target selected
  //Target := m_TargetCret;
  nDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
  m_btDirection := nDir;
  {do spell effect}
  SendRefMsg(RM_LIGHTING, nDir, m_nCurrX, m_nCurrY, Integer(self), '');

  for i := 0 to m_TargetCret.m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_TargetCret.m_VisibleActors.Items[i]).BaseObject);
    if BaseObject <> nil then
    begin
      if (abs(m_TargetCret.m_nCurrX - BaseObject.m_nCurrX) <= 8) and (abs(m_TargetCret.m_nCurrY - BaseObject.m_nCurrY) <= 8) then
      begin
        if (BaseObject.m_PEnvir = self.m_PEnvir) and IsProperTarget(BaseObject) then
        begin
          if Random(10) >= BaseObject.m_nantiMagic then
          begin
            WAbil := @m_WAbil;
            magpwr := (BaseObject.m_WAbil.MaxHP * LoWord(WAbil.MC)) div 100;
            BaseObject.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
            if (Random(3) <> 0) and (BaseObject.m_wStatusTimeArr[POISON_STONE] = 0) then
              BaseObject.MakePosion(nil, 0, POISON_STONE, 5 + Random(3), 0);
          end;
        end;
      end;
    end;
  end;
end;

procedure TOmaKing.RepulseCircle();
var
  i: Integer;
  BaseObject: TBaseObject;
  nDir: byte;
  push: Integer;
begin
  if m_TargetCret = nil then
    Exit;
  {do spell effect}

  nDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
  m_btDirection := nDir;
  SendAttackMsg(RM_HIT, nDir, m_nCurrX, m_nCurrY);

  {do repule radius around 'ourself'}
  for i := 0 to m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if BaseObject <> nil then
    begin
      if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 2) and
        (abs(m_nCurrY - BaseObject.m_nCurrY) <= 2)
        and ((abs(m_nCurrY - m_TargetCret.m_nCurrY) + abs(m_nCurrX - m_TargetCret.m_nCurrX)) <= 3) then
      begin
        if (BaseObject.m_PEnvir = self.m_PEnvir) and IsProperTarget(BaseObject) then
        begin
          if Random(10) >= BaseObject.m_nantiMagic then
          begin
            push := 1 + Random(3);
            nDir := GetNextDirection(m_nCurrX, m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
            BaseObject.CharPushed(nDir, push);
          end;
        end;
      end;
    end;
  end;
end;

function TOmaKing.AttackTarget(): Boolean; //004A8F34
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
      end;
      Result := True;
    end;
  end;
end;

constructor TDragonStatue.Create;
begin
  m_nViewRangeX := 15;
  m_nViewRangeY := m_nViewRangeX;
  inherited;
  m_boAnimal := False;
end;

destructor TDragonStatue.Destroy;
begin
  inherited;
end;

procedure TDragonStatue.Run;
begin
  if (not m_boDeath) and (not m_boGhost) then
  begin
    //doing firebang thing
    if (m_TargetCret <> nil) and (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 12) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 12) then
    begin
      m_dwHitTick := GetTickCount();
      FireBang();
    end;
    //search for targets nearbye(rather then using official search this thing has wider range :p)
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

procedure TDragonStatue.FireBang();
var
  i: Integer;
  magpwr: Integer;
  WAbil: pTAbility;
  BaseObject: TBaseObject;
  target: TBaseObject;
begin
  //target selected
  target := m_TargetCret;
  {do spell effect}
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(target), '');

  for i := 0 to target.m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(target.m_VisibleActors.Items[i]).BaseObject);
    if (abs(target.m_nCurrX - BaseObject.m_nCurrX) <= 1) and (abs(target.m_nCurrY - BaseObject.m_nCurrY) <= 1) then
    begin

      if BaseObject <> nil then
      begin
        if (BaseObject.m_PEnvir = self.m_PEnvir) and IsProperTarget(BaseObject) then
        begin
          if Random(10) >= BaseObject.m_nantiMagic then
          begin
            WAbil := @m_WAbil;
            magpwr := (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
            BaseObject.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
          end;
        end;
      end;
    end;
  end;
end;

{ yimoogi}

constructor TYimoogi.Create;
begin
  m_boFixedHideMode := True;
  inherited;
  m_boAnimal := False;
  m_dwSearchTime := 3000 + Random(2000);
  m_dwSearchTick := GetTickCount();
  m_dwThinkTick := GetTickCount();
  m_dwSpellTick := GetTickCount();
  m_dwPoisonTick := GetTickCount();
  m_nViewRangeX := 15;
  m_nViewRangeY := m_nViewRangeX;
  m_boApproach := False;
  m_boActive := False;
  m_boNoAttackMode := True;
  m_boDied := False;
end;

destructor TYimoogi.Destroy;
begin
  inherited;
  if m_counterpart <> nil then
  begin
    if (m_counterpart is TYimoogi) or (m_counterpart is TYimoogiMaster) then
    begin
      TYimoogi(m_counterpart).m_counterpart := nil;
    end;
  end;
end;

procedure TYimoogi.Run; //004AA604
var
  dist: Integer;
begin
  if not m_boGhost and
    not m_boDeath and
    not m_boFixedHideMode and
    not m_boStoneMode and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if m_TargetCret <> nil then
      m_boActive := True;
    if m_boActive then
    begin //if we are on active mode then we go hunting
      if (GetTickCount - m_dwThinkTick) > 5000 then
      begin
        m_dwThinkTick := GetTickCount();
        SearchTarget;
        if m_TargetCret = nil then //if we hunted and there's still no target then go inactive
          m_boActive := False;
      end;
    end;
    if m_TargetCret <> nil then
    begin //if we have a target we walk, we kill it
      {walking part}
      dist := _MAX(abs(m_nCurrX - m_TargetCret.m_nCurrX), abs(m_nCurrY - m_TargetCret.m_nCurrY));
      if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
      begin //check if we should walk closer or not and do it
        m_dwWalkTick := GetTickCount();
        if dist > 13 then
        begin
          m_nTargetX := m_TargetCret.m_nCurrX;
          m_nTargetY := m_TargetCret.m_nCurrY;
          GotoTargetXY;
        end;
      end;
      m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      {regular attack part}
      if (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) and (dist <= 1) then
      begin
        //m_dwHitTick:=GetTickCount();
        AttackTarget();
      end;
      {ranged attack part}
      if (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime * 2) and (dist > 1) then
      begin
        m_dwHitTick := GetTickCount();
        MagicAttack();
      end;
      {red poison part}//random between 4 and 10 seconds
      if (Integer(GetTickCount - m_dwPoisonTick) > (Random(6) + 4) * 1000) then
      begin
        m_dwPoisonTick := GetTickCount();
        m_dwHitTick := GetTickCount();
        PoisonAttack;
        if (m_counterpart <> nil) and (m_counterpart is TYimoogi) then
        begin
          TYimoogi(m_counterpart).m_dwPoisonTick := GetTickCount();
        end;
      end;
    end;
  end
  else
  begin
    if m_boDied = False then
    begin
      m_boDied := True;
      if (m_counterpart <> nil) and (m_counterpart is TYimoogiMaster) then
      begin
        TYimoogiMaster(m_counterpart).CloneDied;
      end
      else if (m_counterpart <> nil) and (m_counterpart is TYimoogi) then
      begin
        TYimoogiMaster(self).CallGuard;
      end;
    end;
  end;
  if m_WAbil.HP = 0 then
  begin
    if m_counterpart <> nil then
    begin
      if (m_counterpart is TYimoogi) or (m_counterpart is TYimoogiMaster) then
      begin
        TYimoogi(m_counterpart).m_counterpart := nil;
        m_counterpart := nil;
      end;
    end;
  end;
  inherited;
end;

procedure TYimoogi.MagicAttack();
var
  magpwr: Integer;
  WAbil: pTAbility;
begin
  SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  if IsProperTarget(m_TargetCret) then
  begin
    if Random(10) >= m_TargetCret.m_nantiMagic then
    begin
      WAbil := @m_WAbil;
      magpwr := (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
      m_TargetCret.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 0, 0, '', 600);
      m_TargetCret.SendDelayMsg(m_TargetCret, RM_NORMALEFFECT, 0, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 14 {type}, '', 1000);
    end;
  end;
end;

procedure TYimoogi.PoisonAttack();
var
  xTargetList: TList;
  BaseObject: TBaseObject;
  i: Integer;
begin
  xTargetList := TList.Create;
  GetMapBaseObjects(m_PEnvir, m_nCurrX, m_nCurrY, 15, xTargetList);
  if (xTargetList.Count > 0) then
  begin
    SendRefMsg(RM_FLYAXE, m_btDirection, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
    for i := xTargetList.Count - 1 downto 0 do
    begin
      BaseObject := TBaseObject(xTargetList.Items[i]);

      if (BaseObject <> nil) then
      begin
        if IsProperTarget(BaseObject) then
        begin
          if Random(BaseObject.m_btAntiPoison + 5) <= 6 then
            BaseObject.SendDelayMsg(self, RM_POISON, POISON_DAMAGEARMOR, 20, Integer(self), 3, '', 1000);
        end;
        //xTargetList.Delete(i);
      end;
    end;
  end;
  xTargetList.Free;
end;

constructor TYimoogiMaster.Create;
begin
  inherited;
  m_dwLastRecall := GetTickCount();
  m_dwCloneSpawn := 0;
end;

destructor TYimoogiMaster.Destroy;
begin
  inherited;
  m_dwLastRecall := GetTickCount();
end;

procedure TYimoogiMaster.Run;
var
  dist: Integer;
  nX, nY: Integer;
begin
  if not m_boGhost and
    not m_boDeath and
    not m_boFixedHideMode and
    (m_TargetCret <> nil) then
  begin
    if (m_dwCloneSpawn <> 0) and (GetTickCount - m_dwCloneSpawn > 500) then
    begin
      GetFrontPosition(nX, nY);
      m_counterpart := UserEngine.RegenMonsterByName(m_PEnvir.m_sMapFileName, nX, nY, m_sFCharName + '1');
      m_dwCloneSpawn := 0;
      if (m_counterpart <> nil) and (m_counterpart is TYimoogi) then
      begin
        TYimoogi(m_counterpart).m_counterpart := self;
        m_counterpart.m_TargetCret := m_TargetCret;
      end
      else
        //something wrong here cant spawn second yimoogi
    end;
    if (m_counterpart = nil) and (GetTickCount - m_dwLastRecall > 2000) then
    begin
      m_dwLastRecall := GetTickCount();
      //find the fake yimoogi on this map or spawn a new one
      m_counterpart := FindYimoogi(m_sFCharName + '1');
      if m_counterpart = nil then
      begin //didnt find one on map so we're spawning one instead
        SendRefMsg(RM_LIGHTING, m_btDirection, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
        m_dwCloneSpawn := GetTickCount;
      end;
    end;
  end;
  if not m_boGhost and
    not m_boDeath and
    not m_boFixedHideMode and
    not m_boStoneMode and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if m_TargetCret <> nil then
    begin
      if m_counterpart <> nil then
      begin
        dist := _MAX(abs(m_nCurrX - m_counterpart.m_nCurrX), abs(m_nCurrY - m_counterpart.m_nCurrY));
        GetFrontPosition(nX, nY);
        if (dist > 12) and (GetTickCount - m_dwLastRecall > 1000) then
        begin
          m_dwLastRecall := GetTickCount();
          //somehow tell our other half that it needs to come to us
          m_counterpart.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
          m_counterpart.SpaceMove(m_sMapName, nX, nY, 0);
        end;
      end;
    end;
  end;
  inherited;
end;

function TYimoogiMaster.FindYimoogi(sName: string): TBaseObject;
var
  MonList: TList;
  i: Integer;
  BaseObject: TBaseObject;
begin
  Result := nil;
  MonList := TList.Create;
  UserEngine.GetMapMonster(m_PEnvir, MonList);
  for i := 0 to MonList.Count - 1 do
  begin
    BaseObject := TBaseObject(MonList.Items[i]);
    if BaseObject.m_sCharName = sName then
    begin
      Result := BaseObject;
      Break;
    end;
  end;
  MonList.Free;
end;

function TYimoogiMaster.GetFrontPosition(var nX: Integer; var nY: Integer): Boolean;
var
  Envir: TEnvirnoment;
begin
  Envir := m_PEnvir;
  nX := m_nCurrX;
  nY := m_nCurrY;
  case m_btDirection of //
    DR_UP:
      begin
        if nY > 0 then
          Dec(nY, 2);
      end;
    DR_UPRIGHT:
      begin
        if (nX < (Envir.m_MapHeader.wWidth - 2)) and (nY > 0) then
        begin
          Inc(nX, 2);
          Dec(nY, 2);
        end;
      end;
    DR_RIGHT:
      begin
        if nX < (Envir.m_MapHeader.wWidth - 2) then
          Inc(nX, 2);
      end;
    DR_DOWNRIGHT:
      begin
        if (nX < (Envir.m_MapHeader.wWidth - 2)) and (nY < (Envir.m_MapHeader.wHeight - 2)) then
        begin
          Inc(nX, 2);
          Inc(nY, 2);
        end;
      end;
    DR_DOWN:
      begin
        if nY < (Envir.m_MapHeader.wHeight - 2) then
          Inc(nY, 2);
      end;
    DR_DOWNLEFT:
      begin
        if (nX > 0) and (nY < (Envir.m_MapHeader.wHeight - 2)) then
        begin
          Dec(nX, 2);
          Inc(nY, 2);
        end;
      end;
    DR_LEFT:
      begin
        if nX > 0 then
          Dec(nX, 2);
      end;
    DR_UPLEFT:
      begin
        if (nX > 0) and (nY > 0) then
        begin
          Dec(nX, 2);
          Dec(nY, 2);
        end;
      end;
  end;
  Result := True;
end;

procedure TYimoogiMaster.CallGuard;
const
  sMonName: string = 'GuardianViper';
var
  n10, n14: Integer;
begin
  GetFrontPosition(n10, n14);
  UserEngine.RegenMonsterByName(m_sMapName, n10, n14, sMonName);
  GetBackPosition(n10, n14);
  UserEngine.RegenMonsterByName(m_sMapName, n10, n14, sMonName);
end;

procedure TYimoogiMaster.CloneDied();
begin
  CallGuard;
  m_TargetCret := nil;
  m_boActive := False;
  m_dwLastRecall := GetTickCount() + 2000;
  SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
  MapRandomMove(m_sMapName, 0);
end;

{ TBlackFox }

constructor TBlackFox.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boUseMagic := False;
  m_boApproach := False;
end;

destructor TBlackFox.Destroy;
begin
  inherited;
end;

function TBlackFox.MagCanHitTarget(nX, nY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  n14, n18, n19, n1C, n20: Integer;
begin
  Result := False;
  if TargeTBaseObject = nil then  Exit;

  if m_PEnvir = nil then  Exit;

  n20 := abs(nX - TargeTBaseObject.m_nCurrX) + abs(nY - TargeTBaseObject.m_nCurrY);
  n14 := 0;
  n18 := GetNextDirection(nX, nY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
  while (n14 < 13) do
  begin
    n19 := GetNextDirection(nX, nY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
    if n18 <> n19 then
      Break;
    if m_PEnvir.GetNextPosition(nX, nY, n18, 1, nX, nY) and m_PEnvir.IsValidCell(nX, nY) then
    begin
      if (nX = TargeTBaseObject.m_nCurrX) and (nY = TargeTBaseObject.m_nCurrY) then
      begin
        Result := True;
        Break;
      end
      else
      begin
        n1C := abs(nX - TargeTBaseObject.m_nCurrX) + abs(nY - TargeTBaseObject.m_nCurrY);
        if n1C > n20 then
        begin
          Result := True;
          Break;
        end;
      end;
    end
    else
    begin
      Break;
    end;
    Inc(n14);
  end;
end;

procedure TBlackFox.ThrustAttack(nDir: Integer);
var
  WAbil: pTAbility;
  nSX, nSY, nTX, nTY, nPwr: Integer;

begin
  m_btDirection := nDir;
  if m_PEnvir = nil then
    Exit;
  if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, nDir, 1, nSX, nSY) then
  begin
    m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, nDir, 3, nTX, nTY);
    WAbil := @m_WAbil;
    nPwr := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
    MagPassThroughMagic(nSX, nSY, nTX, nTY, nDir, nPwr, 0, True);
  end;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
end;

procedure TBlackFox.Run;
var
  nAttackDir,distx, disty: Integer;
  nX, nY: Integer;
begin
  if not m_boGhost and
    not m_boDeath and
    not m_boFixedHideMode and
    not m_boStoneMode and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
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
    if m_TargetCret <> nil then
    begin
      //walking
      if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
      begin //check if we should walk closer or not and do it :p
        distx := abs(m_nCurrX - m_TargetCret.m_nCurrX);
        disty := abs(m_nCurrY - m_TargetCret.m_nCurrY);
        GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        if (((distx > 2) or (disty > 2)) and ((distx < 12) and (disty < 12))) or (MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret) = False) then
        begin //restrict the maximum pursuit distance to 12 coords away
          m_dwWalkTick := GetTickCount();
          m_nTargetX := m_TargetCret.m_nCurrX;
          m_nTargetY := m_TargetCret.m_nCurrY;
          GotoTargetXY;
          //          WalkTo(nDir,False);
        end;
      end;
      nX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
      nY := abs(m_nCurrY - m_TargetCret.m_nCurrY);
      if MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret) then
      begin //make sure the 'line' in wich magic will go isnt blocked
        if (nX <= 3) and (nY <= 3) then
        begin
          if m_boUseMagic or ((nX = 2) or (nY = 2)) or ((nX = 3) or (nY = 3)) then
          begin
            if (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
            begin
              m_dwHitTick := GetTickCount();
              nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
              ThrustAttack(nAttackDir);
            end;
          end;
        end;
      end;
    end;
  end;
  inherited Run;
end;

{---------------------------------------------------------------------------}

constructor TFoxWarrior.Create;
begin
  inherited Create;
  m_dwSearchTime := 2500 + LongWord(Random(1500));
  CrazyKingMode := False;
  CriticalMode := False;
end;

procedure TFoxWarrior.Initialize;
begin
  crazytime := GetTickCount;
  oldhittime := m_nNextHitTime;
  oldwalktime := m_nWalkSpeed;
  m_nViewRangeX := 7;
  m_nViewRangeY := 7;
  inherited Initialize;
end;

procedure TFoxWarrior.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  i, k, mx, my: Integer;
  cret: TBaseObject;
  pwr: Integer;
begin
  m_btDirection := nDir;
  with m_WAbil do
    pwr := GetAttackPower(LoWord(DC), SmallInt(HiWord(DC) - LoWord(DC)));

  if pwr <= 0 then
    Exit;

  if CriticalMode then
  begin
    pwr := pwr * 2;
    SendRefMsg(RM_LIGHTING, m_btDirection, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');
  end
  else
  begin
    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');
  end;

  for i := 0 to 4 do
    for k := 0 to 4 do
    begin
      if g_Config.SpitMap[m_btDirection, i, k] = 1 then
      begin
        mx := m_nCurrX - 2 + k;
        my := m_nCurrY - 2 + i;
        cret := TBaseObject(m_PEnvir.GetMovingObject(mx, my, True));
        if (cret <> nil) and (cret <> self) then
        begin
          if IsProperTarget(cret) then
          begin
            if Random(cret.m_btSpeedPoint) < m_btHitPoint then
            begin
              cret.StruckDamage(self, pwr, 0);
              cret.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, pwr {wparam},
                cret.m_WAbil.HP {lparam1}, cret.m_WAbil.MaxHP {lparam2}, Longint(self) {hiter}, '',
                500);
            end;
          end;
        end;
      end;
    end;
end;

procedure TFoxWarrior.Run;
begin
  if not m_boDeath and not m_boGhost then
  begin
    if CrazyKingMode then
    begin
      if GetTickCount - crazytime < 60 * 1000 then
      begin
        m_nNextHitTime := oldhittime * 2 div 5;
        m_nWalkSpeed := oldwalktime * 1 div 2;
      end
      else
      begin
        CrazyKingMode := False;
        m_nNextHitTime := oldhittime;
        m_nWalkSpeed := oldwalktime;
      end;
    end
    else
    begin
      if m_WAbil.HP < m_WAbil.MaxHP div 4 then
      begin
        CrazyKingMode := True;
        crazytime := GetTickCount;
      end;
    end;
  end;
  inherited Run;
end;

function TFoxWarrior.AttackTarget: Boolean;
var
  targdir: byte;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if TargetInSpitRange(m_TargetCret, targdir) then
    begin
      if GetCurrentTime - m_dwHitTick > m_nNextHitTime then
      begin
        m_dwHitTick := GetCurrentTime;
        m_dwTargetFocusTick := GetTickCount;
        if Random(100) < 30 then
          CriticalMode := True
        else
          CriticalMode := False;
        Attack(m_TargetCret, targdir);
        BreakHolySeizeMode;
      end;
      Result := True;
    end
    else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
      else
        DelTargetCreat;
    end;
  end;
end;

{---------------------------------------------------------------------------}

constructor TFoxWizard.Create;
begin
  inherited Create;
  m_dwSearchTime := 2500 + LongWord(Random(1500));
end;

procedure TFoxWizard.Initialize;
begin
  WarpTime := GetTickCount;
  m_nViewRangeX := 7;
  m_nViewRangeY := 7;
  inherited Initialize;
end;

procedure TFoxWizard.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  i: Integer;
  rlist: TList;
  cret: TBaseObject;
  pwr: Integer;
  btEffect: byte;
begin
  if TargeTBaseObject = nil then
    Exit;

  with m_WAbil do
    pwr := GetAttackPower(LoWord(DC), SmallInt(HiWord(DC) - LoWord(DC)));

  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
  if m_wAppr = 356 then
  begin
    btEffect := 1;
    SendRefMsg(RM_SPELL, btEffect, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), pwr, 5, '');
    SendRefMsg(RM_MAGICFIRE, 3, MakeWord(1, btEffect), MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), Integer(TargeTBaseObject), '');
  end
  else if m_wAppr = 813 then
  begin
    btEffect := 3;
    SendRefMsg(RM_SPELL, btEffect, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), pwr, 5, '');
    SendRefMsg(RM_MAGICFIRE, 3, MakeWord(1, btEffect), MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), Integer(TargeTBaseObject), '');
  end
  else
    SendRefMsg(RM_LIGHTING, m_btDirection, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');

  if pwr <= 0 then
    Exit;

  rlist := TList.Create;
  m_PEnvir.GetBaseObjects(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY, False, rlist);
  for i := 0 to rlist.Count - 1 do
  begin
    cret := TBaseObject(rlist[i]);
    if IsProperTarget(cret) then
    begin
      SetTargetCreat(cret);
      cret.SendDelayMsg(self, RM_MAGSTRUCK, 0, pwr, 0, 0, '', 600);
    end;
  end;
  rlist.Free;

end;

procedure TFoxWizard.RangeAttack(targ: TBaseObject);
var
  i, pwr, dam: Integer;
  list: TList;
  cret: TBaseObject;
  btEffect: byte;
begin
  if targ = nil then
    Exit;

  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, targ.m_nCurrX, targ.m_nCurrY);

  if m_wAppr = 356 then
  begin
    with m_WAbil do
      pwr := LoWord(MC) + Random(Abs(HiWord(MC) - LoWord(MC)) + 1);
    btEffect := 21;
    SendRefMsg(RM_SPELL, btEffect + 255 * 12, MakeLong(targ.m_nCurrX, targ.m_nCurrY), pwr, 23, '');
    SendRefMsg(RM_MAGICFIRE, 12, MakeWord(2, btEffect), MakeLong(targ.m_nCurrX, targ.m_nCurrY), Integer(targ), '');
  end
  else if m_wAppr = 813 then
  begin
    with m_WAbil do
      pwr := LoWord(MC) + Random(Abs(HiWord(MC) - LoWord(MC)) + 1);
    btEffect := 45;
    SendRefMsg(RM_SPELL, btEffect + 255 * 12, MakeLong(targ.m_nCurrX, targ.m_nCurrY), pwr, 23, '');
    SendRefMsg(RM_MAGICFIRE, 12, MakeWord(2, btEffect), MakeLong(targ.m_nCurrX, targ.m_nCurrY), Integer(targ), '');
  end
  else
  begin
    with m_WAbil do
      pwr := LoWord(DC) + Random(Abs(HiWord(DC) - LoWord(DC)) + 1) + 30;
    SendRefMsg(RM_LIGHTING_1, m_btDirection, m_nCurrX, m_nCurrY, Integer(targ), '');
  end;

  list := TList.Create;
  m_PEnvir.GetRangeBaseObject(targ.m_nCurrX, targ.m_nCurrY, 1, True, list);
  for i := 0 to list.Count - 1 do
  begin
    cret := TBaseObject(list[i]);
    if IsProperTarget(cret) then
    begin
      dam := cret.GetMagStruckDamage(self, pwr);
      if dam > 0 then
      begin
        cret.StruckDamage(self, dam, 0);
        cret.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, dam {wparam},
          cret.m_WAbil.HP {lparam1}, cret.m_WAbil.MaxHP {lparam2}, Longint(self) {hiter}, '', 800);

        cret.m_boDragonFireSkill := True;
        SendDelayMsg(self, RM_DELAYMAGIC, 2, MakeLong(cret.m_nCurrX, cret.m_nCurrY), dam div 2, Integer(cret), '', 600);
      end;
    end;
  end;
  list.Free;
end;

procedure TFoxWizard.Run;
begin
  if IsMoveAble then
  begin
    if GetCurrentTime - m_dwWalkTick > m_nWalkSpeed then
    begin
      if m_TargetCret <> nil then
      begin
        if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 5) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 5) then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) then
          begin
            if Random(3) = 0 then
            begin
              GetBackPosition(m_nTargetX, m_nTargetY);
            end;
          end
          else
          begin
            GetBackPosition(m_nTargetX, m_nTargetY);
          end;
        end;
      end;
    end;
  end;

  inherited Run;
end;

function TFoxWizard.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  case ProcessMsg.wIdent of
    RM_STRUCKEFFECT:
      begin
        if Integer(ProcessMsg.BaseObject) = RM_STRUCK then
        begin
          if Random(100) < 30 then
          begin
            if (GetTickCount - WarpTime > 2000) and (not m_boDeath) then
            begin
              WarpTime := GetTickCount;
              SendRefMsg(RM_NORMALEFFECT, 0, m_nCurrX, m_nCurrY, NE_FOX_MOVEHIDE, '');
              RandomSpaceMoveInRange(2, 4, 4);
              SendRefMsg(RM_NORMALEFFECT, 0, m_nCurrX, m_nCurrY, NE_FOX_MOVESHOW, '');
            end;
          end;
        end;
      end;
  end;
  inherited Operate(ProcessMsg);
end;

function TFoxWizard.AttackTarget: Boolean;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if GetCurrentTime - m_dwHitTick > m_nNextHitTime then
    begin
      m_dwHitTick := GetCurrentTime;
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 7) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 7) then
      begin
        if Random(10) > 7 then
        begin
          RangeAttack(m_TargetCret);
          Result := True;
        end
        else
        begin
          Attack(m_TargetCret, m_btDirection);
          Result := True;
        end;
      end
      else
      begin
        if m_TargetCret.m_PEnvir = m_PEnvir then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then
          begin
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          end;
        end
        else
        begin
          DelTargetCreat; //<!!ÁÖÀÇ> m_TargetCret := nil·Î ¹Ù²ñ
        end;
      end;
    end;
  end;
end;

{---------------------------------------------------------------------------}

constructor TFoxTaoist.Create;
begin
  inherited Create;
  m_dwSearchTime := 2500 + LongWord(Random(1500));
end;

procedure TFoxTaoist.Initialize;
begin
  BoRecallComplete := False;
  m_nViewRangeX := 7;
  m_nViewRangeY := 7;

  inherited Initialize;
end;

procedure TFoxTaoist.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  pwr: Integer;
begin
  m_btDirection := nDir;
  with m_WAbil do
    pwr := GetAttackPower(LoWord(DC), SmallInt(HiWord(DC) - LoWord(DC)));

  if pwr <= 0 then
    Exit;

  SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');

  if IsProperTarget(TargeTBaseObject) then
  begin
    TargeTBaseObject.StruckDamage(self, pwr, 0);
    TargeTBaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, pwr {wparam},
      TargeTBaseObject.m_WAbil.HP {lparam1}, TargeTBaseObject.m_WAbil.MaxHP {lparam2}, Longint(self) {hiter}, '',
      500);
  end;
end;

procedure TFoxTaoist.RangeAttack(targ: TBaseObject);
var
  pwr: Integer;
  sec, SkillLevel: Integer;
begin
  if targ = nil then  Exit;

  sec := 60;
  pwr := 70;
  SkillLevel := 3;
  MagMakeCurseArea(targ.m_nCurrX, targ.m_nCurrY, 2, sec, pwr, SkillLevel, False);

  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, targ.m_nCurrX, targ.m_nCurrY);
  SendRefMsg(RM_LIGHTING_1, m_btDirection, m_nCurrX, m_nCurrY, Integer(targ), '');
end;

procedure TFoxTaoist.RangeAttack2(targ: TBaseObject);
var
  i, pwr, dam: Integer;
  list: TList;
  cret: TBaseObject;
begin
  if (targ = nil) or (m_PEnvir = nil) then
    Exit;

  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, targ.m_nCurrX, targ.m_nCurrY);
  SendRefMsg(RM_LIGHTING, m_btDirection, m_nCurrX, m_nCurrY, Integer(targ), '');

  //if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 1, sx, sy) then begin
  //  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 9, TX, TY);

  with m_WAbil do
    pwr := LoWord(DC) + Random(Abs(HiWord(DC) - LoWord(DC)) + 1);

  list := TList.Create;
  m_PEnvir.GetRangeBaseObject(targ.m_nCurrX, targ.m_nCurrY, 2, True, list);
  for i := 0 to list.Count - 1 do
  begin
    cret := TBaseObject(list[i]);
    if IsProperTarget(cret) then
    begin
      dam := cret.GetMagStruckDamage(self, pwr);
      if dam > 0 then
      begin
        cret.StruckDamage(self, dam, 0);
        cret.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, dam {wparam},
          cret.m_WAbil.HP {lparam1}, cret.m_WAbil.MaxHP {lparam2}, Longint(self) {hiter}, '', 800);
      end;
    end;
  end;
  list.Free;
  //end;
end;

procedure TFoxTaoist.Run;
var
  cret: TBaseObject;
  recallmob1, recallmob2: string;
begin
  recallmob1 := 'ºüÔÂ»ÆÍÜ';
  recallmob2 := 'ºüÔÂºÖÍÜ';

  if not BoRecallComplete then
  begin
    if m_WAbil.HP <= m_WAbil.MaxHP div 2 then
    begin
      SendRefMsg(RM_LIGHTING_2, m_btDirection, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');

      cret := UserEngine.RegenMonsterByName(m_PEnvir.m_sMapFileName, m_nCurrX + 1, m_nCurrY, recallmob1);
      if cret <> nil then
      begin
        cret.SendRefMsg(RM_NORMALEFFECT, 0, cret.m_nCurrX, cret.m_nCurrY, NE_FOX_MOVESHOW, '');
        if m_TargetCret <> nil then
          cret.SetTargetCreat(m_TargetCret);
      end;

      cret := UserEngine.RegenMonsterByName(m_PEnvir.m_sMapFileName, m_nCurrX - 1, m_nCurrY, recallmob1);
      if cret <> nil then
      begin
        cret.SendRefMsg(RM_NORMALEFFECT, 0, cret.m_nCurrX, cret.m_nCurrY, NE_FOX_MOVESHOW, '');
        if m_TargetCret <> nil then
          cret.SetTargetCreat(m_TargetCret);
      end;

      cret := UserEngine.RegenMonsterByName(m_PEnvir.m_sMapFileName, m_nCurrX, m_nCurrY + 1, recallmob2);
      if cret <> nil then
      begin
        cret.SendRefMsg(RM_NORMALEFFECT, 0, cret.m_nCurrX, cret.m_nCurrY, NE_FOX_MOVESHOW, '');
        if m_TargetCret <> nil then
          cret.SetTargetCreat(m_TargetCret);
      end;

      cret := UserEngine.RegenMonsterByName(m_PEnvir.m_sMapFileName, m_nCurrX, m_nCurrY - 1, recallmob2);
      if cret <> nil then
      begin
        cret.SendRefMsg(RM_NORMALEFFECT, 0, cret.m_nCurrX, cret.m_nCurrY, NE_FOX_MOVESHOW, '');
        if m_TargetCret <> nil then
          cret.SetTargetCreat(m_TargetCret);
      end;

      BoRecallComplete := True;
    end;
  end;

  if IsMoveAble then
  begin
    if GetCurrentTime - m_dwWalkTick > m_nWalkSpeed then
    begin
      if m_TargetCret <> nil then
      begin
        if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 5) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 5) then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) then
          begin
            if Random(3) = 0 then
            begin
              GetBackPosition(m_nTargetX, m_nTargetY);
            end;
          end
          else
          begin
            GetBackPosition(m_nTargetX, m_nTargetY);
          end;
        end;
      end;
    end;
  end;

  inherited Run;
end;

function TFoxTaoist.AttackTarget: Boolean;
var
  targdir: byte;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if GetCurrentTime - m_dwHitTick > m_nNextHitTime then
    begin
      m_dwHitTick := GetCurrentTime;
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 7) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 7) then
      begin
        if (GetAttackDir(m_TargetCret, targdir)) and (Random(10) < 8) then
        begin
          m_dwTargetFocusTick := GetTickCount;
          Attack(m_TargetCret, targdir);
          Result := True;
        end
        else
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 6) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 6) then
          begin
            if Random(12) > 1 then
            begin
              RangeAttack2(m_TargetCret);
              Result := True;
            end
            else
            begin
              RangeAttack(m_TargetCret);
              Result := True;
            end;
          end
          else
          begin
            RangeAttack2(m_TargetCret);
            Result := True;
          end;
        end;
      end
      else
      begin
        if m_TargetCret.m_PEnvir = m_PEnvir then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then
          begin
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          end;
        end
        else
        begin
          DelTargetCreat;
        end;
      end;
    end;
  end;
end;

{---------------------------------------------------------------------------}

constructor TPushedMon.Create;
begin
  inherited Create;
  m_nLight := 3;
  m_dwSearchTime := 2500 + LongWord(Random(1500));
  AttackWide := 1;
end;

procedure TPushedMon.Initialize;
begin
  m_nPushedCount := 0;
  if AttackWide = 1 then
  begin
    DeathCount := 5;
  end
  else
  begin
    DeathCount := 7;
  end;

  m_nViewRangeX := 7;
  m_nViewRangeY := 7;

  inherited Initialize;
end;

procedure TPushedMon.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  i: Integer;
  wide: Integer;
  rlist: TList;
  cret: TBaseObject;
  pwr: Integer;
begin
  if TargeTBaseObject = nil then
    Exit;

  wide := AttackWide;
  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
  SendRefMsg(RM_LIGHTING, m_btDirection, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');
  with m_WAbil do
    pwr := GetAttackPower(LoWord(DC), SmallInt(HiWord(DC) - LoWord(DC)));
  if pwr <= 0 then
    Exit;

  rlist := TList.Create;
  m_PEnvir.GetRangeBaseObject(m_nCurrX, m_nCurrY, wide, False, rlist);
  for i := 0 to rlist.Count - 1 do
  begin
    cret := TBaseObject(rlist[i]);
    if IsProperTarget(cret) then
    begin
      SetTargetCreat(cret);
      cret.SendDelayMsg(self, RM_MAGSTRUCK, 0, pwr, 0, 0, '', 600);
    end;
  end;
  rlist.Free;

end;

procedure TPushedMon.Run;
begin
  if not m_boDeath then
  begin
    if m_nPushedCount >= DeathCount then
    begin
      Die;
    end;
  end;

  inherited Run;
end;

function TPushedMon.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  case ProcessMsg.wIdent of
    RM_STRUCK:
      begin
        m_WAbil.HP := m_WAbil.MaxHP;
      end;
    RM_STRUCKEFFECT:
      begin
        if Integer(ProcessMsg.BaseObject) = RM_STRUCK then
        begin
          m_WAbil.HP := m_WAbil.MaxHP;
        end;
      end;
  end;

  inherited Operate(ProcessMsg);
end;

procedure TPushedMon.Struck(hiter: TBaseObject);
begin
  m_WAbil.HP := m_WAbil.MaxHP;
end;

function TPushedMon.AttackTarget: Boolean;
var
  targdir: byte;
  targx, targy: Integer;
  flag: Boolean;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if GetCurrentTime - m_dwHitTick > m_nNextHitTime then
    begin
      m_dwHitTick := GetCurrentTime;
      if AttackWide = 1 then
      begin
        flag := (GetAttackDir(m_TargetCret, targdir));
      end
      else
      begin
        flag := (TargetInSpitRange(m_TargetCret, targdir));
      end;

      if flag then
      begin
        Attack(m_TargetCret, targdir);
      end
      else
      begin
        if m_TargetCret.m_PEnvir = m_PEnvir then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then
          begin
            targx := Random(2 * AttackWide + 1) - AttackWide;
            targy := Random(2 * AttackWide + 1) - AttackWide;
            if (targx < AttackWide) and (targy < AttackWide) then
              targx := -AttackWide;
            targx := targx + m_TargetCret.m_nCurrX;
            targy := targy + m_TargetCret.m_nCurrY;
            SetTargetXY(targx, targy);
          end;
        end
        else
        begin
          DelTargetCreat; //<!!ÁÖÀÇ> m_TargetCret := nil·Î ¹Ù²ñ
        end;
      end;
    end;
  end;
end;

{---------------------------------------------------------------------------}

constructor TFoxPillar.Create;
begin
  inherited Create;
  RunDone := False;
  m_nViewRangeX := 12;
  m_nViewRangeY := 12;
  m_nRunTime := 250;
  m_dwSearchTime := 2500 + LongWord(Random(1500));
  m_dwSearchTick := GetTickCount;
  m_boHideMode := False;
  m_boStickMode := True;
  m_boSuperman := True;
end;

function TFoxPillar.AttackTarget: Boolean;
begin
  Result := False;

  if FindTarget then
  begin
    if GetCurrentTime - m_dwHitTick > m_nNextHitTime then
    begin
      m_dwHitTick := GetCurrentTime;

      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= m_nViewRangeX) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= m_nViewRangeY) then
      begin
        if Random(5) = 0 then
        begin
          RangeAttack(m_TargetCret);
          Attack(m_TargetCret, m_btDirection);
          Result := True;
        end
        else if Random(4) < 2 then
        begin
          RangeAttack(m_TargetCret);
          Result := True;
        end
        else
        begin
          Attack(m_TargetCret, m_btDirection);
          Result := True;
        end;
      end
      else
      begin
        if m_TargetCret.m_PEnvir = m_PEnvir then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= m_nViewRangeX) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= m_nViewRangeY) then
          begin
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          end;
        end
        else
        begin
          DelTargetCreat;
        end;
      end;
    end;
  end;
end;

function TFoxPillar.FindTarget: Boolean;
var
  i: Integer;
  cret: TBaseObject;
begin
  Result := False;
  for i := 0 to m_VisibleActors.Count - 1 do
  begin
    cret := pTVisibleBaseObject(m_VisibleActors[i]).BaseObject;
    if (not cret.m_boDeath) and (cret.m_PEnvir = self.m_PEnvir) and IsProperTarget(cret) then
    begin
      if (abs(m_nCurrX - cret.m_nCurrX) <= m_nViewRangeX) and (abs(m_nCurrY - cret.m_nCurrY) <= m_nViewRangeY) then
      begin
        if (cret.m_btRaceServer = RC_PLAYOBJECT) or (cret.IsHero) then
        begin
          if m_TargetCret = nil then
          begin
            m_TargetCret := cret;
          end
          else
          begin
            if Random(2) = 0 then
              Continue;
            m_TargetCret := cret;
          end;
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TFoxPillar.RangeAttack(targ: TBaseObject);
var
  levelgap, rushdir, rushDist: Integer;
begin
  if targ = nil then
    Exit;

  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, targ.m_nCurrX, targ.m_nCurrY);
  SendRefMsg(RM_LIGHTING_1, m_btDirection, m_nCurrX, m_nCurrY, Integer(targ), '');

  rushdir := ((m_btDirection + 4) mod 8);
  rushDist := _MAX(0, _MAX(abs(m_nCurrX - targ.m_nCurrX), abs(m_nCurrY - targ.m_nCurrY)) - 3);

  if IsProperTarget(targ) then
  begin
    if not ((abs(m_nCurrX - targ.m_nCurrX) <= 2) and (abs(m_nCurrY - targ.m_nCurrY) <= 2)) then
    begin
      if (not targ.m_boDeath) and ((targ.m_btRaceServer = RC_PLAYOBJECT) or (targ.m_Master <> nil)) then
      begin
        levelgap := (targ.m_nantiMagic * 5) + HiWord(targ.m_WAbil.AC) div 2;
        if (Random(50) > levelgap) then
        begin
          if (abs(m_nCurrX - targ.m_nCurrX) <= 12) and (abs(m_nCurrY - targ.m_nCurrY) <= 12) then
          begin
            targ.SendRefMsg(RM_LOOPNORMALEFFECT, Integer(targ), 1000, 0, NE_SIDESTONE_PULL, '');
            targ.CharPushed(rushdir, rushDist, False);
          end;
        end;
      end;
    end;
  end;
end;

procedure TFoxPillar.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  i: Integer;
  wide: Integer;
  rlist: TList;
  cret: TBaseObject;
  pwr: Integer;
begin
  if TargeTBaseObject = nil then
    Exit;

  wide := 2;
  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
  SendRefMsg(RM_LIGHTING, m_btDirection, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');
  with m_WAbil do
    pwr := GetAttackPower(LoWord(DC), SmallInt(HiWord(DC) - LoWord(DC)));
  if pwr <= 0 then
    Exit;

  rlist := TList.Create;
  GetMapBaseObjects(m_PEnvir, m_nCurrX, m_nCurrY, wide, rlist);
  for i := 0 to rlist.Count - 1 do
  begin
    cret := TBaseObject(rlist[i]);
    if IsProperTarget(cret) then
    begin
      SetTargetCreat(cret);
      cret.SendDelayMsg(self, RM_MAGSTRUCK, 0, pwr, 0, 0, '', 600);
    end;
  end;
  rlist.Free;
end;

{---------------------------------------------------------------------------}

constructor TFoxBead.Create;
begin
  inherited Create;
  RunDone := False;
  m_nViewRangeX := 16;
  m_nViewRangeY := 16;
  m_nRunTime := 250;
  m_dwSearchTime := 1500 + LongWord(Random(1500));
  m_dwSearchTick := GetTickCount;
  m_boHideMode := False;
  m_boStickMode := True;
  m_nBodyState := 1;
  OrgNextHitTime := m_nNextHitTime;
  sectick := GetTickCount;
end;

procedure TFoxBead.Run;
begin
  if GetTickCount - sectick > 3000 then
  begin
    sectick := GetTickCount;
    if (not m_boDeath) and (not m_boGhost) then
    begin
      if (m_WAbil.HP >= m_WAbil.MaxHP * 4 div 5) then
      begin
        if m_nBodyState <> 1 then
        begin
          m_nBodyState := 1;
          m_WAbil.DC := MakeLong(_MIN(65535, LoWord(m_Abil.DC)), _MIN(65535, HiWord(m_Abil.DC)));
          m_WAbil.AC := MakeLong(_MIN(65535, LoWord(m_Abil.AC)), _MIN(65535, HiWord(m_Abil.AC)));
          m_WAbil.MAC := MakeLong(_MIN(65535, LoWord(m_Abil.MAC)), _MIN(65535, HiWord(m_Abil.MAC)));
          SendRefMsg(RM_FOXSTATE, m_btDirection, m_nCurrX, m_nCurrY, m_nBodyState, m_sFCharName);
        end;
      end
      else if (m_WAbil.HP >= m_WAbil.MaxHP * 3 div 5) then
      begin
        if m_nBodyState <> 2 then
        begin
          m_nBodyState := 2;
          m_WAbil.DC := MakeLong(_MIN(65535, LoWord(m_Abil.DC)), _MIN(65535, HiWord(m_Abil.DC) + HiWord(m_Abil.DC) div 10));
          m_WAbil.AC := MakeLong(_MIN(65535, LoWord(m_Abil.AC)), _MIN(65535, HiWord(m_Abil.AC) + HiWord(m_Abil.AC) * 2 div 10));
          m_WAbil.MAC := MakeLong(_MIN(65535, LoWord(m_Abil.MAC)), _MIN(65535, HiWord(m_Abil.MAC) + HiWord(m_Abil.MAC) * 2 div 10));
          SendRefMsg(RM_FOXSTATE, m_btDirection, m_nCurrX, m_nCurrY, m_nBodyState, m_sFCharName);
        end;
      end
      else if (m_WAbil.HP >= m_WAbil.MaxHP * 2 div 5) then
      begin
        if m_nBodyState <> 3 then
        begin
          m_nBodyState := 3;
          m_WAbil.DC := MakeLong(_MIN(65535, LoWord(m_Abil.DC)), _MIN(65535, HiWord(m_Abil.DC) + HiWord(m_Abil.DC) * 2 div 10));
          m_WAbil.AC := MakeLong(_MIN(65535, LoWord(m_Abil.AC)), _MIN(65535, HiWord(m_Abil.AC) + HiWord(m_Abil.AC) * 4 div 10));
          m_WAbil.MAC := MakeLong(_MIN(65535, LoWord(m_Abil.MAC)), _MIN(65535, HiWord(m_Abil.MAC) + HiWord(m_Abil.MAC) * 4 div 10));
          SendRefMsg(RM_FOXSTATE, m_btDirection, m_nCurrX, m_nCurrY, m_nBodyState, m_sFCharName);
        end;
      end
      else if (m_WAbil.HP >= m_WAbil.MaxHP * 1 div 5) then
      begin
        if m_nBodyState <> 4 then
        begin
          m_nBodyState := 4;
          m_WAbil.DC := MakeLong(_MIN(65535, LoWord(m_Abil.DC)), _MIN(65535, HiWord(m_Abil.DC) + HiWord(m_Abil.DC) * 3 div 10));
          m_WAbil.AC := MakeLong(_MIN(65535, LoWord(m_Abil.AC)), _MIN(65535, HiWord(m_Abil.AC) + HiWord(m_Abil.AC) * 6 div 10));
          m_WAbil.MAC := MakeLong(_MIN(65535, LoWord(m_Abil.MAC)), _MIN(65535, HiWord(m_Abil.MAC) + HiWord(m_Abil.MAC) * 4 div 10));
          SendRefMsg(RM_FOXSTATE, m_btDirection, m_nCurrX, m_nCurrY, m_nBodyState, m_sFCharName);
        end;
      end
      else
      begin
        if m_nBodyState <> 5 then
        begin
          m_nBodyState := 5;
          m_WAbil.DC := MakeLong(_MIN(65535, LoWord(m_Abil.DC)), _MIN(65535, HiWord(m_Abil.DC) + HiWord(m_Abil.DC) * 4 div 10));
          m_WAbil.AC := MakeLong(_MIN(65535, LoWord(m_Abil.AC)), _MIN(65535, HiWord(m_Abil.AC) + HiWord(m_Abil.AC) * 8 div 10));
          m_WAbil.MAC := MakeLong(_MIN(65535, LoWord(m_Abil.MAC)), _MIN(65535, HiWord(m_Abil.MAC) + HiWord(m_Abil.MAC) * 4 div 10));
          SendRefMsg(RM_FOXSTATE, m_btDirection, m_nCurrX, m_nCurrY, m_nBodyState, m_sFCharName);
        end;
      end;
    end;
  end;
  inherited Run;
end;

function TFoxBead.AttackTarget: Boolean;
var
  i, nX, nY: Integer;
  cret: TBaseObject;
  rlist: TList;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if GetCurrentTime - m_dwHitTick > m_nNextHitTime then
    begin
      m_dwHitTick := GetCurrentTime;

      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= m_nViewRangeX) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= m_nViewRangeY) then
      begin
        if Random(10) = 0 then
        begin
          SendRefMsg(RM_NORMALEFFECT, 0, m_nCurrX, m_nCurrY, NE_KINGSTONE_RECALL_1, '');

          rlist := TList.Create;
          GetMapBaseObjects(m_PEnvir, m_nCurrX, m_nCurrY, 30, rlist);
          for i := 0 to rlist.Count - 1 do
          begin
            cret := TBaseObject(rlist[i]);
            if (not cret.m_boDeath) and IsProperTarget(cret) then
            begin
              if ((cret.m_btRaceServer = RC_PLAYOBJECT) or cret.IsHero) and ((abs(m_nCurrX - cret.m_nCurrX) > 3) or (abs(m_nCurrY - cret.m_nCurrY) > 3)) then
              begin
                if Random(3) < 2 then
                begin
                  cret.SendRefMsg(RM_NORMALEFFECT, 0, cret.m_nCurrX, cret.m_nCurrY, NE_KINGSTONE_RECALL_2, '');

                  if Random(2) = 0 then
                  begin
                    nX := m_nCurrX + Random(3) + 1;
                    nY := m_nCurrY + Random(3) + 1;
                  end
                  else
                  begin
                    nX := m_nCurrX - Random(3) - 1;
                    nY := m_nCurrY - Random(3) - 1;
                  end;
                  cret.SpaceMove(m_PEnvir.m_sMapFileName, nX, nY, 2);

                  cret.SendRefMsg(RM_NORMALEFFECT, 0, cret.m_nCurrX, cret.m_nCurrY, NE_KINGSTONE_RECALL_2, '');
                end;
              end;
            end;
          end;
          rlist.Free;
          Result := True;
        end
        else if Random(100) < 40 then
        begin
          RangeAttack2(m_TargetCret);
          Result := True;
        end
        else if Random(10) < 4 then
        begin
          Attack(m_TargetCret, m_btDirection);
          Result := True;
        end
        else
        begin
          RangeAttack(m_TargetCret);
          Result := True;
        end;
        if Random(10) < 4 then
        begin
          FindTarget;
        end;
      end
      else
      begin
        if m_TargetCret.m_PEnvir = m_PEnvir then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= m_nViewRangeX) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= m_nViewRangeY) then
          begin
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          end;
        end
        else
        begin
          DelTargetCreat;
        end;
      end;

    end;
  end;

end;

function TFoxBead.FindTarget: Boolean;
var
  i: Integer;
  cret: TBaseObject;
begin
  Result := False;
  for i := 0 to m_VisibleActors.Count - 1 do
  begin
    cret := pTVisibleBaseObject(m_VisibleActors[i]).BaseObject;
    if (not cret.m_boDeath) and (cret.m_PEnvir = self.m_PEnvir) and IsProperTarget(cret) then
    begin
      if (abs(m_nCurrX - cret.m_nCurrX) <= m_nViewRangeX) and (abs(m_nCurrY - cret.m_nCurrY) <= m_nViewRangeY) then
      begin
        if (cret.m_btRaceServer = RC_PLAYOBJECT) or (cret.IsHero) then
        begin
          if m_TargetCret = nil then
          begin
            m_TargetCret := cret;
          end
          else
          begin
            if Random(100) < 50 then
              Continue;
            m_TargetCret := cret;
          end;
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TFoxBead.RangeAttack(targ: TBaseObject);
var
  i, pwr, dam: Integer;
  sx, sy, TX, TY: Integer;
  list: TList;
  cret: TBaseObject;
begin
  if targ = nil then
    Exit;

  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, targ.m_nCurrX, targ.m_nCurrY);
  SendRefMsg(RM_LIGHTING_1, m_btDirection, m_nCurrX, m_nCurrY, Integer(targ), '');
  if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 1, sx, sy) then
  begin
    m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 9, TX, TY);
    with m_WAbil do
    begin
      pwr := LoWord(DC) + _MIN(65535, Random(Abs(HiWord(DC) - LoWord(DC)) + 1));
      pwr := pwr + Random(LoWord(MC));
      pwr := pwr * 2;
    end;

    list := TList.Create;
    m_PEnvir.GetRangeBaseObject(targ.m_nCurrX, targ.m_nCurrY, 2, True, list);
    for i := 0 to list.Count - 1 do
    begin
      cret := TBaseObject(list[i]);
      if IsProperTarget(cret) then
      begin
        dam := cret.GetMagStruckDamage(self, pwr);
        if dam > 0 then
        begin
          cret.StruckDamage(self, dam, 0);
          cret.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, dam {wparam},
            cret.m_WAbil.HP {lparam1}, cret.m_WAbil.MaxHP {lparam2}, Longint(self) {hiter}, '', 800);
        end;
      end;
    end;
    list.Free;
  end;
end;

procedure TFoxBead.RangeAttack2(targ: TBaseObject);
var
  i,  pwr, dam: Integer;
  cret: TBaseObject;
  sec, SkillLevel: Integer;
begin
  if targ = nil then
    Exit;

  SendRefMsg(RM_LIGHTING_2, m_btDirection, m_nCurrX, m_nCurrY, Integer(self), '');
  with m_WAbil do
  begin
    pwr := GetAttackPower(LoWord(DC), _MIN(65535, SmallInt(HiWord(DC) - LoWord(DC))));
    pwr := pwr * 2;
  end;

  for i := 0 to m_VisibleActors.Count - 1 do
  begin
    cret := pTVisibleBaseObject(m_VisibleActors[i]).BaseObject;
    if (not cret.m_boDeath) and (cret.m_PEnvir = self.m_PEnvir) and IsProperTarget(cret) then
    begin
      if (cret.m_btRaceServer = RC_PLAYOBJECT) or (cret.m_Master <> nil) then
      begin
        if Random(10) < 2 then
        begin
          if Random(2 + cret.m_btAntiPoison) = 0 then
            cret.MakePosion(nil, 0, POISON_STONE, 5, 5);
        end
        else
        begin
          if Random(2 + cret.m_btAntiPoison) = 0 then
          begin
            sec := 60;
            pwr := 70;
            SkillLevel := 3;
            MagMakeCurseArea(targ.m_nCurrX, targ.m_nCurrY, 2, sec, pwr, SkillLevel, False);
          end;
        end;

        dam := cret.GetMagStruckDamage(self, pwr);
        if dam > 0 then
          cret.SendDelayMsg(self, RM_MAGSTRUCK, 0, dam, 0, 0, '', 1500);
        dam := cret.GetMagStruckDamage(self, pwr);
        if dam > 0 then
          cret.SendDelayMsg(self, RM_MAGSTRUCK, 0, dam, 0, 0, '', 2000);
      end;
    end;
  end;
end;

procedure TFoxBead.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  i, dam: Integer;
  wide: Integer;
  rlist: TList;
  cret: TBaseObject;
  pwr: Integer;
begin
  if TargeTBaseObject = nil then
    Exit;

  wide := 3;
  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
  SendRefMsg(RM_LIGHTING, m_btDirection, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');
  with m_WAbil do
  begin
    pwr := GetAttackPower(LoWord(DC), _MIN(65535, SmallInt(HiWord(DC) - LoWord(DC))));
    pwr := pwr + Random(LoWord(MC));
    pwr := pwr * 2;
  end;
  if pwr <= 0 then
    Exit;

  rlist := TList.Create;
  GetMapBaseObjects(m_PEnvir, m_nCurrX, m_nCurrY, wide, rlist);
  for i := 0 to rlist.Count - 1 do
  begin
    cret := TBaseObject(rlist[i]);
    if IsProperTarget(cret) then
    begin
      SetTargetCreat(cret);
      dam := cret.GetMagStruckDamage(self, pwr);
      if dam > 0 then
        cret.SendDelayMsg(self, RM_MAGSTRUCK, 0, dam, 0, 0, '', 300);
      dam := cret.GetMagStruckDamage(self, pwr);
      if dam > 0 then
        cret.SendDelayMsg(self, RM_MAGSTRUCK, 0, dam, 0, 0, '', 600);
      dam := cret.GetMagStruckDamage(self, pwr);
      if dam > 0 then
        cret.SendDelayMsg(self, RM_MAGSTRUCK, 0, dam, 0, 0, '', 900);
    end;
  end;
  rlist.Free;
end;

procedure TFoxBead.Die;
var
  k: Integer;
  list: TList;
begin
  list := TList.Create;
  UserEngine.GetMapMonster(m_PEnvir, list);
  for k := 0 to list.Count - 1 do
  begin
    if TBaseObject(list[k]).m_btRaceServer in [162..169] then
    begin
      TBaseObject(list[k]).m_boSuperman := False;
      TBaseObject(list[k]).m_WAbil.HP := 0;
    end;
  end;
  list.Free;

  inherited Die;
end;

end.
