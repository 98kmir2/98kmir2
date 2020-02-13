unit ObjMon2;

interface

uses
  Windows, Classes, SysUtils, Grobal2, ObjBase, ObjMon;

type
  TDoorState = (dsOpen, dsClose, dsBroken);

  TStickMonster = class(TAnimalObject)
    nComeOutValue: Integer;
    nAttackRange: Integer;
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; virtual;
    function SearchAttackTarget: Boolean; virtual;
    procedure FindAttackTarget; virtual;
    procedure VisbleActors; virtual;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
  end;

  TSandWorm = class(TStickMonster)
  private
  public
    constructor Create(); override;
    function AttackTarget(): Boolean; override;
  end;

  TBeeQueen = class(TAnimalObject)
    BBList: TList;
  private
    procedure MakeChildBee;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
  end;

  TCentipedeKingMonster = class(TStickMonster)
    m_dwAttickTick: LongWord;
  private
    function sub_4A5B0C: Boolean;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; override;
    procedure FindAttackTarget; override;
    procedure Run; override;
  end;

  TBigHeartMonster = class(TAnimalObject)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; virtual;
    procedure Run; override;
  end;

  TSpiderHouseMonster = class(TAnimalObject)
    BBList: TList;
  private
    procedure GenBB;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
  end;

  TExplosionSpider = class(TATMonster)
    MakeTime: LongWord;
  private
    procedure DoSelfExplosion;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function AttackTarget(): Boolean; override;
  end;

  TGuardUnit = class(TAnimalObject)
    m_nX550: Integer;
    m_nY554: Integer;
    m_nDirection: Integer;
  public
    function IsProperTarget(BaseObject: TBaseObject; MagFire: Boolean = False): Boolean; override; //FFF4
    procedure Struck(hiter: TBaseObject); override; //FFEC
  end;

  TArcherGuard = class(TGuardUnit)
  private
    procedure sub_4A6B30(TargeTBaseObject: TBaseObject);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TArcherGuard2 = class(TGuardUnit)
  private
    procedure sub_4A6B30(TargeTBaseObject: TBaseObject);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TArcherMaster = class(TATMonster)
  private
    procedure ShotArrow(targ: TBaseObject);
  public
    constructor Create;
    function AttackTarget: Boolean; override;
    procedure Run; override;
  end;

  TArcherPolice = class(TArcherGuard)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;

  TCastleDoor = class(TGuardUnit)
    dw560: LongWord; //0x560
    m_boOpened: Boolean; //0x564
  private
    procedure ActiveDoorWall(dstate: TDoorState {nFlag: Integer});
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Die; override;
    procedure Run; override;
    procedure Initialize(); override;
    procedure CloseDoor;
    procedure OpenDoor;
    procedure RefStatus;
  end;

  TWallStructure = class(TGuardUnit)
    dw560: LongWord;
    boSetMapFlaged: Boolean;
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Die; override;
    procedure Run; override;
    procedure RefStatus;
  end;

  TSoccerBall = class(TAnimalObject)
    n550: Integer;
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Struck(hiter: TBaseObject); override; //FFEC
    procedure Run; override;
  end;

  TBamTreeMonster = class(TAnimalObject)
    m_nStruckCount: Integer;
    m_nHealth: Integer;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Struck(hiter: TBaseObject); override;
    procedure Run; override;
    procedure StruckDamage(Attacker: TBaseObject; nDamage: Integer; nMagIdx: Integer); override;
  end;

  TEvilMir = class(TAnimalObject)
    m_dwSpellTick: LongWord;
    //m_boSlaves: Boolean;
  private
    procedure FlameCircle(nDir: Integer);
    procedure massthunder();
    // procedure CallSlaves();                
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
    //procedure Die; override;
  end;

  //var
    {g_DragonSearchPath        : array[0..41, 0..1] of Integer = (
      (0, -5), (1, -5), (-1, -4), (0, -4),
      (1, -4), (2, -4), (-2, -3), (-1, -3),
      (0, -3), (1, -3), (2, -3), (-3, -2),
      (-2, -2), (-1, -3), (0, -2), (1, -2),
      (2, -2), (-3, -1), (-2, -1), (-1, -1),
      (0, -1), (1, -1), (2, -1), (-3, 0),
      (-2, 0), (-1, 0), (0, 0), (1, 0),
      (2, 0), (3, 0), (-2, 1), (-1, 1),
      (0, 1), (1, 1), (2, 1), (3, 1),
      (-1, 2), (0, 2), (1, 2), (2, 2),
      (0, 3), (1, 3)
      ); }

implementation

uses M2Share, HUtil32, Castle, Guild;

{ TSandWorm }

constructor TSandWorm.Create; //004A51C0
begin
  inherited;
  m_btRaceServer := 127;
  m_boAnimal := False;
  nComeOutValue := 3;
  nAttackRange := 3;
end;

function TSandWorm.AttackTarget: Boolean;
var
  nPwr: Integer;
  WAbil: pTAbility;
  //btDir                     : byte;
begin
  Result := False;
  if m_TargetCret = nil then
    Exit;

  if (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 2) then
  begin
  //if GetAttackDir(m_TargetCret, btDir) or GetLongAttackDir(m_TargetCret, btDir) then begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();

      m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);

      WAbil := @m_WAbil;
      nPwr := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
      MagicManager.MagBigExplosion(self, nPwr, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 2, 0);

      SendAttackMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY);

    end;
    Result := True;
    Exit;
  end;
  if m_TargetCret.m_PEnvir = m_PEnvir then
    SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
  else
    DelTargetCreat();
end;

{ TStickMonster }

constructor TStickMonster.Create; //004A51C0
begin
  inherited;
  m_nViewRangeX := 7;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := Random(1500) + 2500;
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 85;
  m_boFixedHideMode := True;
  m_boStickMode := True;
  m_boAnimal := True;
  nComeOutValue := 4;
  nAttackRange := 4;
end;

destructor TStickMonster.Destroy; //004A5290
begin
  inherited;
end;

function TStickMonster.AttackTarget: Boolean;
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
      Attack(m_TargetCret, btDir);
    end;
    Result := True;
    Exit;
  end;
  if m_TargetCret.m_PEnvir = m_PEnvir then
    SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
  else
    DelTargetCreat();
end;

procedure TStickMonster.FindAttackTarget();
begin
  m_boFixedHideMode := False;
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TStickMonster.VisbleActors(); //004A53E4
var
  i: Integer;
resourcestring
  sExceptionMsg = '[Exception] TStickMonster::VisbleActors Dispose';
begin
  SendRefMsg(RM_DIGDOWN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  try
    for i := 0 to m_VisibleActors.Count - 1 do
      Dispose(pTVisibleBaseObject(m_VisibleActors[i]));
    m_VisibleActors.Clear;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
  m_boFixedHideMode := True;
end;

function TStickMonster.SearchAttackTarget(): Boolean; //004A53E4
var
  i: Integer;
  BaseObject: TBaseObject;
begin
  Result := False;
  for i := 0 to m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if BaseObject.m_boDeath then
      Continue;
    if IsProperTarget(BaseObject) then
    begin
      if not BaseObject.m_boHideMode or m_boCoolEye then
      begin
        if (abs(m_nCurrX - BaseObject.m_nCurrX) < nComeOutValue) and (abs(m_nCurrY - BaseObject.m_nCurrY) < nComeOutValue) then
        begin
          //FindAttackTarget();
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

function TStickMonster.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);
end;

procedure TStickMonster.Run; //004A5614
var
  bo05: Boolean;
begin
  if not m_boGhost and not m_boDeath and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed then
    begin
      m_dwWalkTick := GetTickCount();
      if m_boFixedHideMode then
      begin
        if SearchAttackTarget() then
          FindAttackTarget;
      end
      else
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
          SearchTarget();
        bo05 := False;
        if m_TargetCret <> nil then
        begin
          if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > nAttackRange) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > nAttackRange) then
            bo05 := True;
        end
        else
          bo05 := True;
        if bo05 then
          VisbleActors()
        else if AttackTarget then
        begin
          inherited;
          Exit;
        end;
      end;
    end;
  end;
  inherited;
end;

{ TSoccerBall }

constructor TSoccerBall.Create;
begin
  inherited;
  m_boAnimal := False;
  m_boSuperMan := True;
  n550 := 0;
  m_nTargetX := -1;
end;

destructor TSoccerBall.Destroy;
begin

  inherited;
end;

procedure TSoccerBall.Run;
var
  n08, n0C: Integer;
begin
  if n550 > 0 then
  begin
    if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 1, n08, n0C) then
    begin
      if m_PEnvir.CanWalk(n08, n0C, False) then
      begin
        case m_btDirection of
          0: m_btDirection := 4;
          1: m_btDirection := 7;
          2: m_btDirection := 6;
          3: m_btDirection := 5;
          4: m_btDirection := 0;
          5: m_btDirection := 3;
          6: m_btDirection := 2;
          7: m_btDirection := 1;
        end;
        m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, n550,
          m_nTargetX, m_nTargetY)
      end;
    end;
  end
  else
    m_nTargetX := -1;
  if m_nTargetX <> -1 then
  begin
    GotoTargetXY();
    if (m_nTargetX = m_nCurrX) and (m_nTargetY = m_nCurrY) then
      n550 := 0;
  end;
  inherited;
end;

procedure TSoccerBall.Struck(hiter: TBaseObject);
begin
  if hiter = nil then
    Exit;
  m_btDirection := hiter.m_btDirection;
  n550 := Random(4) + (n550 + 4);
  n550 := _MIN(20, n550);
  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, n550, m_nTargetX,
    m_nTargetY);
end;

{ TBeeQueen }

constructor TBeeQueen.Create; //004A5750
begin
  inherited;
  m_nViewRangeX := 9;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := Random(1500) + 2500;
  m_dwSearchTick := GetTickCount();
  m_boStickMode := True;
  BBList := TList.Create;
end;

destructor TBeeQueen.Destroy; //004A57F0
begin
  BBList.Free;
  inherited;
end;

procedure TBeeQueen.MakeChildBee;
begin
  if BBList.Count >= 15 then
    Exit;
  SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  SendDelayMsg(self, RM_ZEN_BEE, 0, 0, 0, 0, '', 500);
end;

function TBeeQueen.Operate(ProcessMsg: pTProcessMessage): Boolean;
var
  BB: TBaseObject;
begin
  if ProcessMsg.wIdent = RM_ZEN_BEE then
  begin
    BB := UserEngine.RegenMonsterByName(m_PEnvir.m_sMapFileName, m_nCurrX, m_nCurrY,
      g_Config.sBee);
    if BB <> nil then
    begin
      BB.SetTargetCreat(m_TargetCret);
      BBList.Add(BB);
    end;
  end;
  Result := inherited Operate(ProcessMsg);
end;

procedure TBeeQueen.Run;
var
  i: Integer;
  BB: TBaseObject;
begin
  if not m_boGhost and
    not m_boDeath and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed then
    begin
      m_dwWalkTick := GetTickCount();
      if Integer(GetTickCount - m_dwHitTick) >= m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        SearchTarget();
        if m_TargetCret <> nil then
          MakeChildBee();
      end;
      for i := BBList.Count - 1 downto 0 do
      begin
        BB := TBaseObject(BBList.Items[i]);
        if BB.m_boDeath or (BB.m_boGhost) then
          BBList.Delete(i);
      end;
    end;
  end;
  inherited;
end;

{ TCentipedeKingMonster }

constructor TCentipedeKingMonster.Create; //004A5A8C
begin
  inherited;
  m_nViewRangeX := 6;
  m_nViewRangeY := m_nViewRangeX;
  nComeOutValue := 4;
  nAttackRange := 6;
  m_boAnimal := False;
  m_dwAttickTick := GetTickCount();
end;

destructor TCentipedeKingMonster.Destroy;
begin

  inherited;
end;

function TCentipedeKingMonster.sub_4A5B0C: Boolean;
var
  i: Integer;
  BaseObject: TBaseObject;
begin
  Result := False;
  for i := 0 to m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if BaseObject.m_boDeath then
      Continue;
    if IsProperTarget(BaseObject) then
    begin
      if (abs(m_nCurrX - BaseObject.m_nCurrX) <= m_nViewRangeX) and (abs(m_nCurrY - BaseObject.m_nCurrY) <= m_nViewRangeY) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

function TCentipedeKingMonster.AttackTarget: Boolean; //004A5BC0
var
  WAbil: pTAbility;
  nPower, i: Integer;
  BaseObject: TBaseObject;
begin
  Result := False;
  if not sub_4A5B0C then
  begin
    Exit;
  end;
  if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
  begin
    m_dwHitTick := GetTickCount();
    SendAttackMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY);
    WAbil := @m_WAbil;
    nPower := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) +
      LoWord(WAbil.DC));
    for i := 0 to m_VisibleActors.Count - 1 do
    begin
      BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
      if BaseObject.m_boDeath then
        Continue;
      if IsProperTarget(BaseObject) then
      begin
        if (abs(m_nCurrX - BaseObject.m_nCurrX) < nAttackRange) and (abs(m_nCurrY - BaseObject.m_nCurrY) < nAttackRange) then
        begin
          m_dwTargetFocusTick := GetTickCount();
          SendDelayMsg(self, RM_DELAYMAGIC, 2, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), nPower, Integer(BaseObject), '', 600);
          if Random(4) = 0 then
          begin
            if Random(3) <> 0 then
              BaseObject.MakePosion(nil, 0, POISON_DECHEALTH, 60, 3)
            else
              BaseObject.MakePosion(nil, 0, POISON_STONE, 5, 0);
            m_TargetCret := BaseObject;
          end;
        end;
      end;
    end;
  end;
  Result := True;
end;

procedure TCentipedeKingMonster.FindAttackTarget;
begin
  inherited;
  m_WAbil.HP := m_WAbil.MaxHP;
end;

procedure TCentipedeKingMonster.Run;
var
  i: Integer;
  BaseObject: TBaseObject;
begin
  if not m_boGhost and
    not m_boDeath and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed then
    begin
      m_dwWalkTick := GetTickCount();
      if m_boFixedHideMode then
      begin
        if (GetTickCount - m_dwAttickTick) > 10000 then
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
                if (abs(m_nCurrX - BaseObject.m_nCurrX) < nComeOutValue) and (abs(m_nCurrY - BaseObject.m_nCurrY) < nComeOutValue) then
                begin
                  FindAttackTarget();
                  m_dwAttickTick := GetTickCount();
                  Break;
                end;
              end;
            end;
          end;
        end; //004A5F86
      end
      else
      begin
        if (GetTickCount - m_dwAttickTick) > 3000 then
        begin
          if AttackTarget() then
          begin
            inherited;
            Exit;
          end;
          if (GetTickCount - m_dwAttickTick) > 10000 then
          begin
            VisbleActors();
            m_dwAttickTick := GetTickCount();
          end;
        end;
      end;
    end;
  end;
  inherited;
end;

{ TBigHeartMonster }

constructor TBigHeartMonster.Create; //004A5F94
begin
  inherited;
  m_nViewRangeX := 16;
  m_nViewRangeY := m_nViewRangeX;
  m_boAnimal := False;
end;

destructor TBigHeartMonster.Destroy;
begin
  inherited;
end;

function TBigHeartMonster.AttackTarget(): Boolean; //004A5FEC
var
  i: Integer;
  BaseObject: TBaseObject;
  nPower: Integer;
  WAbil: pTAbility;
begin
  Result := False;
  if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
  begin
    m_dwHitTick := GetTickCount();
    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    WAbil := @m_WAbil;
    nPower := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) +
      LoWord(WAbil.DC));
    for i := 0 to m_VisibleActors.Count - 1 do
    begin
      BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
      if BaseObject.m_boDeath then
        Continue;
      if IsProperTarget(BaseObject) then
      begin
        if (abs(m_nCurrX - BaseObject.m_nCurrX) <= m_nViewRangeX) and (abs(m_nCurrY - BaseObject.m_nCurrY) <= m_nViewRangeY) then
        begin
          SendDelayMsg(self, RM_DELAYMAGIC, 1, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), nPower, Integer(BaseObject), '', 200);
          SendRefMsg(RM_NORMALEFFECT, 0, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 1 {type}, '');
        end;
      end;
    end;
    Result := True;
  end;
end;

procedure TBigHeartMonster.Run;
begin
  if not m_boGhost and
    not m_boDeath and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if m_VisibleActors.Count > 0 then
      AttackTarget();
  end;
  inherited;
end;

{ TSpiderHouseMonster }

constructor TSpiderHouseMonster.Create; //004A61D0
begin
  inherited;
  m_nViewRangeX := 9;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := Random(1500) + 2500;
  m_dwSearchTick := 0;
  m_boStickMode := True;
  BBList := TList.Create;
end;

destructor TSpiderHouseMonster.Destroy;
//004A6270
begin
  BBList.Free;
  inherited;
end;

procedure TSpiderHouseMonster.GenBB; //004A62B0
begin
  if BBList.Count < 15 then
  begin
    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    SendDelayMsg(self, RM_ZEN_BEE, 0, 0, 0, 0, '', 500);
  end;

end;

function TSpiderHouseMonster.Operate(ProcessMsg: pTProcessMessage): Boolean;
var
  BB: TBaseObject;
  n08, n0C: Integer;
begin
  if ProcessMsg.wIdent = RM_ZEN_BEE then
  begin
    n08 := m_nCurrX;
    n0C := m_nCurrY + 1;
    if m_PEnvir.CanWalk(n08, n0C, True) then
    begin
      BB := UserEngine.RegenMonsterByName(m_PEnvir.m_sMapFileName, n08, n0C, g_Config.sSpider);
      if BB <> nil then
      begin
        BB.SetTargetCreat(m_TargetCret);
        BBList.Add(BB);
      end;
    end;
  end;
  Result := inherited Operate(ProcessMsg);
end;

procedure TSpiderHouseMonster.Run;
var
  i: Integer;
  BB: TBaseObject;
begin
  if not m_boGhost and
    not m_boDeath and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed then
    begin
      m_dwWalkTick := GetTickCount();
      if Integer(GetTickCount - m_dwHitTick) >= m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        SearchTarget();
        if m_TargetCret <> nil then
          GenBB();
      end;
      for i := BBList.Count - 1 downto 0 do
      begin
        BB := TBaseObject(BBList.Items[i]);
        if BB.m_boDeath or (BB.m_boGhost) then
          BBList.Delete(i);

      end; // for
    end;

  end;
  inherited;
end;

{ TExplosionSpider }

constructor TExplosionSpider.Create;
begin
  inherited;
  m_nViewRangeX := 6;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := Random(1500) + 2500;
  m_dwSearchTick := 0;
  MakeTime := GetTickCount();
end;

destructor TExplosionSpider.Destroy;
begin
  inherited;
end;

procedure TExplosionSpider.DoSelfExplosion;
var
  WAbil: pTAbility;
  i, nPower, n10: Integer;
  BaseObject: TBaseObject;
begin
  m_WAbil.HP := 0;
  WAbil := @m_WAbil;
  nPower := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) +
    LoWord(WAbil.DC));
  for i := 0 to m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if BaseObject.m_boDeath then
      Continue;
    if IsProperTarget(BaseObject) then
    begin
      if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 1) and (abs(m_nCurrY - BaseObject.m_nCurrY) <= 1) then
      begin
        n10 := 0;
        Inc(n10, BaseObject.GetHitStruckDamage(self, nPower div 2));
        Inc(n10, BaseObject.GetMagStruckDamage(self, nPower div 2));
        if n10 > 0 then
        begin
          BaseObject.StruckDamage(self, n10, 0);
          BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, n10, BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP, Integer(self), '', 700);
        end;
      end;
    end;
  end;
end;

function TExplosionSpider.AttackTarget: Boolean;
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
      DoSelfExplosion();
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
      DelTargetCreat();
    end;
  end;
end;

procedure TExplosionSpider.Run;
begin
  if not m_boDeath and not m_boGhost then
  begin
    if (GetTickCount - MakeTime) > 60 * 1000 then
    begin
      MakeTime := GetTickCount();
      DoSelfExplosion();
    end;
  end;
  inherited;
end;

{ TGuardUnit }

procedure TGuardUnit.Struck(hiter: TBaseObject);
begin
  inherited;
  if m_Castle <> nil then
  begin
    m_boStruck := True;
    m_dw2B4Tick := GetTickCount();
  end;
end;

function TGuardUnit.IsProperTarget(BaseObject: TBaseObject; MagFire: Boolean): Boolean; //004A6890
begin
  Result := False;
  if BaseObject = nil then
    Exit;
  if m_Castle <> nil then
  begin
    if m_LastHiter = BaseObject then
      Result := True;
    if (m_btRaceServer = 109) and (BaseObject.m_btRaceServer = 108) then
      Result := True;
    if BaseObject.m_boStruck then
    begin
      if (GetTickCount - BaseObject.m_dw2B4Tick) < 2 * 60 * 1000 then
        Result := True
      else
        BaseObject.m_boStruck := False;
      if BaseObject.m_Castle <> nil then
      begin
        BaseObject.m_boStruck := False;
        Result := False;
      end;
    end;
    if TUserCastle(m_Castle).m_boUnderWar then
      Result := True;
    if TUserCastle(m_Castle).m_MasterGuild <> nil then
    begin
      if BaseObject.m_Master = nil then
      begin
        if (TUserCastle(m_Castle).m_MasterGuild = BaseObject.m_MyGuild) or (TUserCastle(m_Castle).m_MasterGuild.IsAllyGuild(TGuild(BaseObject.m_MyGuild))) then
        begin
          if m_LastHiter <> BaseObject then
            Result := False;
        end;
      end
      else
      begin
        if (TUserCastle(m_Castle).m_MasterGuild = BaseObject.m_Master.m_MyGuild) or (TUserCastle(m_Castle).m_MasterGuild.IsAllyGuild(TGuild(BaseObject.m_Master.m_MyGuild))) then
        begin
          if (m_LastHiter <> BaseObject.m_Master) and (m_LastHiter <> BaseObject) then
            Result := False;
        end;
      end;
    end;
    if BaseObject.m_boAdminMode or BaseObject.m_boStoneMode or BaseObject.m_boSuperMode or
      ((BaseObject.m_btRaceServer >= 10) and (BaseObject.m_btRaceServer < 50)) or
      (BaseObject = self) or (BaseObject.m_Castle = m_Castle) then
    begin
      Result := False;
    end;
    if (BaseObject.m_btRaceServer = 108) and (m_btRaceServer <> 109) then
      Result := False;
    Exit;
  end;
  if m_LastHiter = BaseObject then
    Result := True;
  if (BaseObject.m_TargetCret <> nil) and (BaseObject.m_TargetCret.m_btRaceServer = 112) then
    Result := True;
  if (BaseObject.PKLevel >= 2) or (BaseObject.m_btRaceServer = 98) then
    Result := True;
  if (m_btRaceServer = 109) and (BaseObject.m_btRaceServer = 108) then
    Result := True;
  if BaseObject.m_boAdminMode or BaseObject.m_boStoneMode or BaseObject.m_boSuperMode or (BaseObject = self) then
    Result := False;
  if (BaseObject.m_btRaceServer = 108) and (m_btRaceServer <> 109) then
    Result := False;
end;

{ TArcherGuard }

constructor TArcherGuard.Create;
begin
  inherited;
  m_nViewRangeX := 12;
  m_nViewRangeY := m_nViewRangeX;
  m_boWantRefMsg := True;
  m_Castle := nil;
  m_nDirection := -1;
  m_btRaceServer := 112;
end;

destructor TArcherGuard.Destroy;
begin
  inherited;
end;

procedure TArcherGuard.sub_4A6B30(TargeTBaseObject: TBaseObject); //004A6B30
var
  nPower: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
  WAbil := @m_WAbil;
  nPower := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  if nPower > 0 then
    nPower := TargeTBaseObject.GetHitStruckDamage(self, nPower);
  if nPower > 0 then
  begin
    TargeTBaseObject.SetLastHiter(self);
    TargeTBaseObject.m_ExpHitter := nil;
    TargeTBaseObject.StruckDamage(self, nPower, 0);
    TargeTBaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, nPower,
      TargeTBaseObject.m_WAbil.HP, TargeTBaseObject.m_WAbil.MaxHP,
      Integer(self),
      '',
      _MAX(abs(m_nCurrX - TargeTBaseObject.m_nCurrX), abs(m_nCurrY - TargeTBaseObject.m_nCurrY)) * 50 + 600);
  end;
  SendRefMsg(RM_FLYAXE, m_btDirection, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');
end;

procedure TArcherGuard.Run;
var
  i: Integer;
  nAbs: Integer;
  nRage: Integer;
  BaseObject: TBaseObject;
  TargeTBaseObject: TBaseObject;
begin
  nRage := 9999;
  TargeTBaseObject := nil;
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed then
    begin
      m_dwWalkTick := GetTickCount();
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
        SetTargetCreat(TargeTBaseObject)
      else
        DelTargetCreat();
    end;
    if m_TargetCret <> nil then
    begin
      if Integer(GetTickCount - m_dwHitTick) >= m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        sub_4A6B30(m_TargetCret);
      end;
    end
    else if (m_nDirection >= 0) and (m_btDirection <> m_nDirection) then
      TurnTo(m_nDirection);
  end;
  inherited;
end;

{ TArcherPolice }

constructor TArcherPolice.Create; //004A6E14
begin
  inherited;
  m_btRaceServer := 20;
end;

destructor TArcherPolice.Destroy;
begin
  inherited;
end;

{ TCastleDoor }

constructor TCastleDoor.Create; //004A6E60
begin
  inherited;
  m_boAnimal := False;
  m_boStickMode := True;
  m_boOpened := False;
  m_btAntiPoison := 200;
end;

destructor TCastleDoor.Destroy;
begin
  inherited;
end;

procedure TCastleDoor.ActiveDoorWall(dstate: TDoorState {nFlag: Integer}); //0=open 1=close 2=die
var
  boCanWalk: Boolean;
begin
  m_PEnvir.GetMarkMovement(m_nCurrX, m_nCurrY - 2, True);
  m_PEnvir.GetMarkMovement(m_nCurrX + 1, m_nCurrY - 1, True);
  m_PEnvir.GetMarkMovement(m_nCurrX + 1, m_nCurrY - 2, True);
  if dstate = dsClose then
    boCanWalk := False
  else
    boCanWalk := True;
  m_PEnvir.GetMarkMovement(m_nCurrX, m_nCurrY, boCanWalk);
  m_PEnvir.GetMarkMovement(m_nCurrX, m_nCurrY - 1, boCanWalk);
  m_PEnvir.GetMarkMovement(m_nCurrX, m_nCurrY - 2, boCanWalk);
  m_PEnvir.GetMarkMovement(m_nCurrX + 1, m_nCurrY - 1, boCanWalk);
  m_PEnvir.GetMarkMovement(m_nCurrX + 1, m_nCurrY - 2, boCanWalk);
  m_PEnvir.GetMarkMovement(m_nCurrX - 1, m_nCurrY, boCanWalk);
  m_PEnvir.GetMarkMovement(m_nCurrX - 2, m_nCurrY, boCanWalk);
  m_PEnvir.GetMarkMovement(m_nCurrX - 1, m_nCurrY - 1, boCanWalk);
  m_PEnvir.GetMarkMovement(m_nCurrX - 1, m_nCurrY + 1, boCanWalk);
  if dstate = dsOpen then
  begin
    m_PEnvir.GetMarkMovement(m_nCurrX, m_nCurrY - 2, False);
    m_PEnvir.GetMarkMovement(m_nCurrX + 1, m_nCurrY - 1, False);
    m_PEnvir.GetMarkMovement(m_nCurrX + 1, m_nCurrY - 2, False);
  end;
end;

procedure TCastleDoor.OpenDoor;
begin
  if m_boDeath then
    Exit;
  m_btDirection := 7;
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  m_boOpened := True;
  m_boStoneMode := True;
  ActiveDoorWall(dsOpen);
  m_boHoldPlace := False;
end;

procedure TCastleDoor.CloseDoor;
begin
  if m_boDeath then
    Exit;
  m_btDirection := 3 - Round(m_WAbil.HP / m_WAbil.MaxHP * 3.0);
  if (m_btDirection - 3) >= 0 then
    m_btDirection := 0;
  SendRefMsg(RM_DIGDOWN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  m_boOpened := False;
  m_boStoneMode := False;
  ActiveDoorWall(dsClose);
  m_boHoldPlace := True;
end;

procedure TCastleDoor.Die;
begin
  inherited;
  dw560 := GetTickCount();
  ActiveDoorWall(dsBroken);
end;

procedure TCastleDoor.Run;
var
  n08: Integer;
  Buffer: array[0..255] of Byte;
begin
  if m_boDeath and (m_Castle <> nil) then
    m_dwDeathTick := GetTickCount()
  else
    m_nHealthTick := 0;
  if not m_boOpened then
  begin
    n08 := 3 - Round(m_WAbil.HP / m_WAbil.MaxHP * 3.0);
    if (m_btDirection <> n08) and (n08 < 3) then
    begin
      m_btDirection := n08;
      SendRefMsg(RM_TURN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    end;
  end;
  inherited;
end;

procedure TCastleDoor.RefStatus;
var
  n08: Integer;
begin
  n08 := 3 - Round(m_WAbil.HP / m_WAbil.MaxHP * 3.0);
  if (n08 - 3) >= 0 then
    n08 := 0;
  m_btDirection := n08;
  SendRefMsg(RM_ALIVE, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TCastleDoor.Initialize;
begin
  inherited;
end;

{ TWallStructure }

constructor TWallStructure.Create;
begin
  inherited;
  m_boAnimal := False;
  m_boStickMode := True;
  boSetMapFlaged := False;
  m_btAntiPoison := 200;
end;

destructor TWallStructure.Destroy;
begin
  inherited;
end;

procedure TWallStructure.Initialize;
begin
  m_btDirection := 0;
  inherited;
end;

procedure TWallStructure.RefStatus;
var
  n08: Integer;
begin
  if m_WAbil.HP > 0 then
    n08 := 3 - Round(m_WAbil.HP / m_WAbil.MaxHP * 3.0)
  else
    n08 := 4;
  if n08 >= 5 then
    n08 := 0;
  m_btDirection := n08;
  SendRefMsg(RM_ALIVE, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TWallStructure.Die;
begin
  inherited;
  dw560 := GetTickCount();
end;

procedure TWallStructure.Run;
var
  n08: Integer;
begin
  if m_boDeath then
  begin
    m_dwDeathTick := GetTickCount();
    if boSetMapFlaged then
    begin
      m_PEnvir.GetMarkMovement(m_nCurrX, m_nCurrY, True);
      boSetMapFlaged := False;
    end;
  end
  else
  begin
    m_nHealthTick := 0;
    if not boSetMapFlaged then
    begin
      m_PEnvir.GetMarkMovement(m_nCurrX, m_nCurrY, False);
      boSetMapFlaged := True;
    end;
  end;
  if m_WAbil.HP > 0 then
    n08 := 3 - Round(m_WAbil.HP / m_WAbil.MaxHP * 3.0)
  else
    n08 := 4;
  if (m_btDirection <> n08) and (n08 < 5) then
  begin
    m_btDirection := n08;
    SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  end;
  inherited;
end;

constructor TArcherGuard2.Create;
begin
  inherited;
  m_nViewRangeX := 12;
  m_nViewRangeY := m_nViewRangeX;
  m_boWantRefMsg := True;
  m_Castle := nil;
  m_nDirection := -1;
  m_btRaceServer := 109;
end;

destructor TArcherGuard2.Destroy;
begin
  inherited;
end;

procedure TArcherGuard2.sub_4A6B30(TargeTBaseObject: TBaseObject); //004A6B30
var
  nPower: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
  WAbil := @m_WAbil;
  nPower := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  if nPower > 0 then
    nPower := TargeTBaseObject.GetHitStruckDamage(self, nPower);
  if nPower > 0 then
  begin
    TargeTBaseObject.SetLastHiter(self);
    TargeTBaseObject.m_ExpHitter := nil;
    TargeTBaseObject.StruckDamage(self, nPower, 0);
    TargeTBaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, nPower,
      TargeTBaseObject.m_WAbil.HP, TargeTBaseObject.m_WAbil.MaxHP,
      Integer(self),
      '',
      _MAX(abs(m_nCurrX - TargeTBaseObject.m_nCurrX), abs(m_nCurrY - TargeTBaseObject.m_nCurrY)) * 50 + 600);
  end;
  SendRefMsg(RM_FLYAXE, m_btDirection, m_nCurrX, m_nCurrY, Integer(TargeTBaseObject), '');
end;

procedure TArcherGuard2.Run;
var
  i: Integer;
  nAbs: Integer;
  nRage: Integer;
  BaseObject: TBaseObject;
  TargeTBaseObject: TBaseObject;
begin
  nRage := 9999;
  TargeTBaseObject := nil;
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed then
    begin
      m_dwWalkTick := GetTickCount();
      for i := 0 to m_VisibleActors.Count - 1 do
      begin
        BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
        if BaseObject.m_boDeath then
          Continue;
        if IsProperTarget(BaseObject) then
        begin
          //if BaseObject.m_btRaceServer = RC_MISSION then begin
          nAbs := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
          if nAbs < nRage then
          begin
            nRage := nAbs;
            TargeTBaseObject := BaseObject;
          end;
        end;
      end;
      if TargeTBaseObject <> nil then
        SetTargetCreat(TargeTBaseObject)
      else
        DelTargetCreat();
    end;
    if m_TargetCret <> nil then
    begin
      if Integer(GetTickCount - m_dwHitTick) >= m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        sub_4A6B30(m_TargetCret);
      end;
    end
    else if (m_nDirection >= 0) and (m_btDirection <> m_nDirection) then
      TurnTo(m_nDirection);
  end;
  inherited;
end;

{--------------------------------------------------------------}

constructor TArcherMaster.Create;
begin
  inherited Create;
  m_nViewRangeX := 12;
  m_nViewRangeY := 12;
end;

procedure TArcherMaster.ShotArrow(targ: TBaseObject);
var
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
    end;
    SendRefMsg(RM_FLYAXE, m_btDirection, m_nCurrX, m_nCurrY, Integer(targ), '');
  end;
end;

function TArcherMaster.AttackTarget: Boolean;
begin
  if GetCurrentTime - m_dwHitTick > m_nNextHitTime then
  begin
    m_dwHitTick := GetCurrentTime;
    ShotArrow(m_TargetCret);
  end;
  Result := True;
end;

procedure TArcherMaster.Run;
var
  i, dis, d: Integer;
  cret, nearcret: TBaseObject;
  nx, ny: Integer;
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
            if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 1, nx, ny) then
            begin
              m_nTargetX := nx;
              m_nTargetY := ny;
              GotoTargetXY;
            end;
          end;
        end;
    end;
  end;
  inherited Run;
end;

{ TBamTreeMonster }

constructor TBamTreeMonster.Create;
begin
  inherited;
  m_boAnimal := False;
  m_nStruckCount := 0;
  m_nHealth := 0;
end;

destructor TBamTreeMonster.Destroy;
begin

  inherited;
end;

procedure TBamTreeMonster.Struck(hiter: TBaseObject);
begin
  inherited;
  Inc(m_nStruckCount);
end;

procedure TBamTreeMonster.Run;
begin
  if m_nHealth = 0 then
  begin
    m_nHealth := m_WAbil.MaxHP;
  end
  else
  begin
    m_WAbil.HP := m_WAbil.MaxHP;
    if m_nStruckCount >= m_nHealth then
      m_WAbil.HP := 0;
  end;

  inherited;
end;

procedure TBamTreeMonster.StruckDamage(Attacker: TBaseObject; nDamage: Integer; nMagIdx: Integer);
begin
  inherited StruckDamage(Attacker, 0, 0);
end;

{evilmir}

constructor TEvilMir.Create;
begin
  inherited;
  m_dwSpellTick := GetTickCount();
  m_boAnimal := False;
  //m_boSlaves := False;
  //dwEMDied := 0; //this tells former pets that they should go :p
  m_nViewRangeX := 16;
  m_nViewRangeY := m_nViewRangeX;
end;

destructor TEvilMir.Destroy;
begin
  //m_SlaveObjectList.Free;
  inherited;
end;

procedure TEvilMir.Run;
var
  nDir: byte;
begin
  {if m_boDeath and m_boSlaves then begin
    m_boSlaves := False;
    nEMdrops := 0; //reset all the drops/hitcount on parts
    nEMHitCount := 0;
    dwEMDied := GetTickCount(); //tell our slaves that their master has passed away
    Inc(nEMKills)
  end;}
  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    {if m_boSlaves = False then begin //if we dont have slaves already make them
      m_boSlaves := True;
      CallSlaves();
    end;}
    //basicaly casting his normal fireball/firebang spell every 3.5seconds
    if (m_TargetCret <> nil) and (Integer(GetTickCount - m_dwHitTick) > 3500) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 12) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 12) then
    begin
      m_dwHitTick := GetTickCount();
      nDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      FlameCircle(nDir);
    end;

    if (m_TargetCret <> nil) and (Integer(GetTickCount - m_dwSpellTick) > 30000) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 12) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 12) then
    begin
      massthunder;
    end;

    //search for targets nearby
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;
{
procedure TEvilMir.CallSlaves();
const
  sMonName: array[0..2] of string = ('1', '2', '3'); //basicaly by adding to this you can make new 'slaves' that drop better
begin
  for i := Low(g_DragonSearchPath) to High(g_DragonSearchPath) do begin
    if (g_DragonSearchPath[i, 0] = 0) and (g_DragonSearchPath[i, 1] = 0) then Continue;
    BaseObject := UserEngine.RegenMonsterByName(m_PEnvir.m_sMapFileName, m_nCurrX + g_DragonSearchPath[i, 0], m_nCurrY + g_DragonSearchPath[i, 1], sMonName[_MIN(nEMKills, Length(sMonName))]);
  end;
end;
}
procedure TEvilMir.FlameCircle(nDir: Integer);
var
  nPwr: Integer;
  WAbil: pTAbility;
begin
  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    if nDir <= 4 then
      SendRefMsg(RM_81, nDir, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '')
    else if nDir = 5 then
      SendRefMsg(RM_82, nDir, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '')
    else if nDir >= 6 then
      SendRefMsg(RM_83, nDir, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
    WAbil := @m_WAbil;
    nPwr := {Random(nEMKills * 5) + }(Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
    MagicManager.MagBigExplosion(self, nPwr, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 2, 0);
    {for i := 0 to Target.m_VisibleActors.Count - 1 do begin
      BaseObject := TBaseObject(pTVisibleBaseObject(Target.m_VisibleActors[i]).BaseObject);
      if BaseObject <> nil then begin
        if (abs(Target.m_nCurrX - BaseObject.m_nCurrX) <= 2) and (abs(Target.m_nCurrY - BaseObject.m_nCurrY) <= 2) then begin
          if IsProperTarget(BaseObject) then begin
            if Random(10) >= BaseObject.m_nAntiMagic then begin
              WAbil := @m_WAbil;
              magpwr := Random(nEMKills * 5) + (Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
              BaseObject.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
            end;
          end;
        end;
      end;
    end;}
  end;
end;

procedure TEvilMir.massthunder();
var
  //xTargetList               : TList;
  //BaseObject                : TBaseObject;
  WAbil: pTAbility;
  magpwr: Integer;
  //i                         : Integer;
begin
  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    m_dwSpellTick := GetTickCount();
    SendAttackMsg(RM_HIT, 0, m_nCurrX, m_nCurrY);
    WAbil := @m_WAbil;
    magpwr := {Random(nEMKills * 5) + }(Random(Abs(HiWord(WAbil.MC) - LoWord(WAbil.MC)) + 1) + LoWord(WAbil.MC));
    MagicManager.MagBigExplosion(self, magpwr, m_nCurrX, m_nCurrY, 12, 0);
    {xTargetList := TList.Create;
    GetMapBaseObjects(m_PEnvir, m_nCurrX, m_nCurrY, 14, xTargetList);
    for i := xTargetList.Count - 1 downto 0 do begin
      BaseObject := TBaseObject(xTargetList.Items[i]);
      if IsProperTarget(BaseObject) then begin
        WAbil := @m_WAbil;
        magpwr := Random(nEMKills * 12) + (Random(Abs(HiWord(WAbil.sC) - LoWord(WAbil.sC)) + 1) + LoWord(WAbil.sC));
        BaseObject.SendDelayMsg(self, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
      end;
    end;
    xTargetList.Free;}
  end;
end;

function TEvilMir.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  if (ProcessMsg.wIdent = RM_POISON) then
    massthunder();
  Result := inherited Operate(ProcessMsg);
end;

{procedure TEvilMir.Die;
begin
  inherited Die;
  //m_dwDeathTick := GetTickCount + 5 * 60 * 1000;
end; }

end.
