unit ObjAxeMon;

interface
uses
  Windows, Classes, Grobal2, ObjBase, ObjMon;
type
  TDualAxeMonster = class(TMonster)
    m_nAttackCount: Integer;
    m_nAttackMax: Integer;
  private
    procedure FlyAxeAttack(Target: TBaseObject);
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; override;
    procedure Run; override;
  end;

  TThornDarkMonster = class(TDualAxeMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;

  TArcherMonster = class(TDualAxeMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;

implementation

uses M2Share, HUtil32;

{ TDualAxeMonster }

procedure TDualAxeMonster.FlyAxeAttack(Target: TBaseObject);
var
  WAbil: pTAbility;
  nDamage: Integer;
begin
  if m_PEnvir.CanFly(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY) then
  begin
    m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
    WAbil := @m_WAbil;
    nDamage := (Random(Abs(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
    if nDamage > 0 then
      nDamage := Target.GetHitStruckDamage(self, nDamage);
    if nDamage > 0 then
    begin
      Target.StruckDamage(Self, nDamage, 0);
      Target.SendDelayMsg(TBaseObject(RM_STRUCK), RM_STRUCKEFFECT, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(self), '', _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end;
    SendRefMsg(RM_FLYAXE, m_btDirection, m_nCurrX, m_nCurrY, Integer(Target), '');
  end;
end;

function TDualAxeMonster.AttackTarget: Boolean;
begin
  Result := False;
  if m_TargetCret = nil then
    Exit;
  if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
  begin
    m_dwHitTick := GetTickCount();
    if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 7) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 7) then
    begin
      if (m_nAttackMax - 1) > m_nAttackCount then
      begin
        Inc(m_nAttackCount);
        m_dwTargetFocusTick := GetTickCount();
        FlyAxeAttack(m_TargetCret);
      end
      else if Random(3) = 0 then
        m_nAttackCount := 0;
      Result := True;
      Exit;
    end;
    if m_TargetCret.m_PEnvir = m_PEnvir then
    begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 13) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 13) then
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
    end
    else
      DelTargetCreat();
  end;
end;

constructor TDualAxeMonster.Create;
begin
  inherited;
  m_nViewRangeX := 5;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := 3000;
  m_nAttackCount := 0;
  m_nAttackMax := 8;
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 87;
end;

destructor TDualAxeMonster.Destroy;
begin
  inherited;
end;

procedure TDualAxeMonster.Run;
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
    if (GetTickCount - m_dwSearchEnemyTick) >= 5000 then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      for i := 0 to m_VisibleActors.Count - 1 do
      begin
        BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
        if BaseObject.m_boDeath then
          Continue;
        if IsProperTarget(BaseObject) then
        begin
          if not BaseObject.m_boHideMode or m_boCoolEye then
          begin
            nAbs := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
            if nAbs < nRage then
            begin
              nRage := nAbs;
              TargeTBaseObject := BaseObject;
            end;
          end;
        end;
      end;
      if TargeTBaseObject <> nil then
        SetTargetCreat(TargeTBaseObject);
    end;
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) and (m_TargetCret <> nil) then
    begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 4) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 4) then
      begin
        if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) then
        begin
          if Random(5) = 0 then
            GetBackPosition(m_nTargetX, m_nTargetY);
        end
        else
          GetBackPosition(m_nTargetX, m_nTargetY);
      end;
    end;
  end;
  inherited;
end;

{ TThornDarkMonster }

constructor TThornDarkMonster.Create; //00459EE4
begin
  inherited;
  m_nAttackMax := 3;
  m_btRaceServer := 93;
end;

destructor TThornDarkMonster.Destroy;
begin
  inherited;
end;

{ TArcherMonster }

constructor TArcherMonster.Create;
begin
  inherited;
  m_nAttackMax := 6;
  m_btRaceServer := 104;
end;

destructor TArcherMonster.Destroy;
begin
  inherited;
end;

end.
