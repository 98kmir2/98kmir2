unit ObjectHuman;

interface

uses
  Windows, Classes, SysUtils, Grobal2, ObjBase;

type
  THeroObject = class(TPlayObject)
    m_boLAT: Boolean;
    m_boNorAttack: Boolean;
    m_boDupMode: Boolean;
    m_boRunReady: Boolean;
    m_btMagPassTh: byte;
    m_dwThinkTick: LongWord;
    m_dwMag41Tick: LongWord;
    m_dwSpellTick: LongWord;

    m_dwJointHitTick: LongWord;
    m_dwStartWalkTick: LongWord;
    m_nLongAttackCount: Integer;
    m_dwSpaceMoveTick: LongWord;
    m_nLatestAmuounsulIdx1: Integer;
    m_nLatestAmuounsulIdx2: Integer;
    m_nLatestFireChamIdx: Integer;
    m_sTargetCret: TBaseObject;
    m_nLastSSkillID: Integer;
  private
    function Think(): Boolean;
    function Sidestep(): Boolean;
    function ProperTarget(): Boolean;
    procedure TrainingSkill(Magic: pTUserMagic);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run(); override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    function AttackTarget(): Boolean; virtual;
    procedure ResetJointAttackEnergy();
    //function GetAdvPosition(var nX, nY: Integer): Boolean;
    function RuntoTargetXY(btDir: byte; boFlag: Boolean): Boolean; override;
    function __Wiza__HeroAttackTarget(): Boolean;
    function __Warr__HeroAttackTarget(): Boolean;
    function __Taos__HeroAttackTarget(): Boolean;
  end;

implementation

uses UsrEngn, M2Share, Event, Magic, Envir, HUtil32, EDcode;

constructor THeroObject.Create();
begin
  inherited;
  m_boFixedHideMode := False;
  m_boObMode := True;
  //m_boRunNext := False;
  m_boNorAttack := False;
  m_boDupMode := False;
  m_boRunReady := False;
  m_btMagPassTh := 0;
  m_dwSpellTick := GetTickCount();
  m_dwStartWalkTick := GetTickCount();
  m_dwThinkTick := GetTickCount();
  m_nViewRange := 8;
  m_nRunTime := 120;                    //0824
  m_dwSearchTime := 1500;
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := RC_HERO;
  m_dwMag41Tick := 0;
  m_nCurMagId := 0;
  m_dwSearchEnemyTick := 0;
  m_nLatestAmuounsulIdx1 := -1;
  m_nLatestAmuounsulIdx2 := -1;
  m_nLatestFireChamIdx := -1;
  m_sTargetCret := nil;
  m_nLastSSkillID := 0;
end;

destructor THeroObject.Destroy();
begin
  inherited;
end;

function THeroObject.Sidestep(): Boolean;
begin
  Result := IsHero and
    TPlayObject(m_Master).m_boHeroSidestep and
    (Round(m_WAbil.HP / m_WAbil.MaxHP * 100) <= TPlayObject(m_Master).m_nHeroSidestepHP);
end;

function THeroObject.ProperTarget(): Boolean;
begin
  Result := True;
  if (m_TargetCret <> nil) and IsHero and TPlayObject(m_Master).m_boHeroTargetFilter then begin
    if (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) or not m_TargetCret.IsHero then
      Result := False;
  end;
end;

procedure THeroObject.ResetJointAttackEnergy();
begin
{$IF DEBUGTEST = 1}
  m_boJointAttackReady := False;
  m_nJointAttackEnergy := 100;
  if m_Master <> nil then TPlayObject(m_Master).SendDefMessage(SM_HEROPOWERUP, 0, 0, 200, 0, '');
{$ELSE}
  m_boJointAttackReady := False;
  m_nJointAttackEnergy := 0;
  if m_Master <> nil then TPlayObject(m_Master).SendDefMessage(SM_HEROPOWERUP, 0, 0, 200, 0, '');
{$IFEND}
end;

function THeroObject.RuntoTargetXY(btDir: byte; boFlag: Boolean): Boolean;
var
  dwTick                    : DWord;
  n24, nOldX, nOldY         : Integer;
  boInSafeZone              : Boolean;
resourcestring
  sExceptionMsg             = '[Exception] TBaseObject::RuntoTargetXY';
begin
  Result := False;
  if (m_nCurrX = m_nTargetX) and (m_nCurrY = m_nTargetY) then begin
    Exit;
  end;
  try
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    m_btDirection := btDir;
    case btDir of
      DR_UP {0}: begin
          if (m_nCurrY > 1) and
            m_PEnvir.CanWalk(m_nCurrX, m_nCurrY - 1, m_boInSafeZone {, Self}) and
            m_PEnvir.CanWalk(m_nCurrX, m_nCurrY - 2, m_boInSafeZone {, Self}) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, self, m_nCurrX, m_nCurrY - 2, m_boInSafeZone) > 0) then begin
            Dec(m_nCurrY, 2);
          end;
        end;
      DR_UPRIGHT {1}: begin
          if (m_nCurrX < m_PEnvir.m_MapHeader.wWidth - 2) and
            (m_nCurrY > 1) and
            m_PEnvir.CanWalk(m_nCurrX + 1, m_nCurrY - 1, m_boInSafeZone {, Self}) and
            m_PEnvir.CanWalk(m_nCurrX + 2, m_nCurrY - 2, m_boInSafeZone {, Self}) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, self, m_nCurrX + 2, m_nCurrY - 2, m_boInSafeZone) > 0) then begin
            Inc(m_nCurrX, 2);
            Dec(m_nCurrY, 2);
          end;
        end;
      DR_RIGHT {2}: begin
          if (m_nCurrX < m_PEnvir.m_MapHeader.wWidth - 2) and
            m_PEnvir.CanWalk(m_nCurrX + 1, m_nCurrY, m_boInSafeZone {, Self}) and
            m_PEnvir.CanWalk(m_nCurrX + 2, m_nCurrY, m_boInSafeZone {, Self}) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, self, m_nCurrX + 2, m_nCurrY, m_boInSafeZone) > 0) then begin
            Inc(m_nCurrX, 2);
          end;
        end;
      DR_DOWNRIGHT {3}: begin
          if (m_nCurrX < m_PEnvir.m_MapHeader.wWidth - 2) and
            (m_nCurrY < m_PEnvir.m_MapHeader.wHeight - 2) and
            m_PEnvir.CanWalk(m_nCurrX + 1, m_nCurrY + 1, m_boInSafeZone {, Self}) and
            m_PEnvir.CanWalk(m_nCurrX + 2, m_nCurrY + 2, m_boInSafeZone {, Self}) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, self, m_nCurrX + 2, m_nCurrY + 2, m_boInSafeZone) > 0) then begin
            Inc(m_nCurrX, 2);
            Inc(m_nCurrY, 2);
          end;
        end;
      DR_DOWN {4}: begin
          if (m_nCurrY < m_PEnvir.m_MapHeader.wHeight - 2) and
            m_PEnvir.CanWalk(m_nCurrX, m_nCurrY + 1, m_boInSafeZone {, Self}) and
            m_PEnvir.CanWalk(m_nCurrX, m_nCurrY + 2, m_boInSafeZone {, Self}) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, self, m_nCurrX, m_nCurrY + 2, m_boInSafeZone) > 0) then begin
            Inc(m_nCurrY, 2);
          end;
        end;
      DR_DOWNLEFT {5}: begin
          if (m_nCurrX > 1) and
            (m_nCurrY < m_PEnvir.m_MapHeader.wHeight - 2) and
            m_PEnvir.CanWalk(m_nCurrX - 1, m_nCurrY + 1, m_boInSafeZone {, Self}) and
            m_PEnvir.CanWalk(m_nCurrX - 2, m_nCurrY + 2, m_boInSafeZone {, Self}) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, self, m_nCurrX - 2, m_nCurrY + 2, m_boInSafeZone) > 0) then begin
            Dec(m_nCurrX, 2);
            Inc(m_nCurrY, 2);
          end;
        end;
      DR_LEFT {6}: begin
          if (m_nCurrX > 1) and
            m_PEnvir.CanWalk(m_nCurrX - 1, m_nCurrY, m_boInSafeZone {, Self}) and
            m_PEnvir.CanWalk(m_nCurrX - 2, m_nCurrY, m_boInSafeZone {, Self}) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, self, m_nCurrX - 2, m_nCurrY, m_boInSafeZone) > 0) then begin
            Dec(m_nCurrX, 2);
          end;
        end;
      DR_UPLEFT {7}: begin
          if (m_nCurrX > 1) and
            (m_nCurrY > 1) and
            m_PEnvir.CanWalk(m_nCurrX - 1, m_nCurrY - 1, m_boInSafeZone {, Self}) and
            m_PEnvir.CanWalk(m_nCurrX - 2, m_nCurrY - 2, m_boInSafeZone {, Self}) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, self, m_nCurrX - 2, m_nCurrY - 2, m_boInSafeZone) > 0) then begin
            Dec(m_nCurrX, 2);
            Dec(m_nCurrY, 2);
          end;
        end;
    end;
    if (m_nCurrX <> nOldX) or (m_nCurrY <> nOldY) then begin
      if Walk(RM_RUN) then begin
        if (m_btRaceServer = RC_HERO) then begin
          dwTick := GetTickCount;
          if IsHero and (TPlayObject(self).m_btReadySeriesSkill = 2) then
            TPlayObject(self).m_dwHitTick := dwTick
          else begin
            n24 := dwTick - m_dwHitTick - m_nNextHitTime;
            if n24 <= 0 then begin
              case m_btJob of           //m_nNextHitTime
                0: m_dwHitTick := dwTick + n24 + g_Config.nWarrCmpInvTime;
                1: m_dwHitTick := dwTick + n24 + g_Config.nWizaCmpInvTime;
                2: m_dwHitTick := dwTick + n24 + g_Config.nTaosCmpInvTime;
              end;
            end;
          end;
        end;
        Result := True;
      end else begin
        m_nCurrX := nOldX;
        m_nCurrY := nOldY;
        m_PEnvir.MoveToMovingObject(nOldX, nOldY, self, m_nCurrX, m_nCurrX, m_boInSafeZone);
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

procedure THeroObject.Run();
var
  bX                        : Boolean;
  nX, nY, nDist             : Integer;
begin
  if not m_boRunReady then begin
    if GetTickCount - m_dwStartWalkTick > 1150 then
      m_boRunReady := True;
    Exit;
  end;

  if (m_sTargetCret <> nil) then begin
    if ((GetTickCount - m_dwTargetFocusTick) > 30 * 1000) or m_sTargetCret.m_boDeath or m_sTargetCret.m_boGhost or (m_sTargetCret.m_PEnvir <> m_PEnvir) or (abs(m_sTargetCret.m_nCurrX - m_nCurrX) > 15) or (abs(m_sTargetCret.m_nCurrY - m_nCurrY) > 15) then
      m_sTargetCret := nil;
  end;

  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then begin

    if (m_btReadySeriesSkill in [0, 2]) and (m_nInPowerLevel > 0) then begin
      if (GetTickCount - m_dwReadySeriesSkillTick > g_Config.nSeriesSkillReleaseInvTime) then begin
        m_dwReadySeriesSkillTick := GetTickCount;
        SerieSkillReady();
      end;
    end;

    if (m_LockTarget <> nil) and IsHero and (not m_LockTarget.m_boSuperMode) then begin
      if (m_Master.m_btHeroRelax <> 0) or not IsProperTarget(m_LockTarget) then begin
        m_nTargetX := -1;
        m_LockTarget := nil;
      end;
    end;

    if (m_LockTarget <> nil) and ((m_btJob = 0) or (g_Config.boHeroLockTarget and (m_btJob in [1, 2]))) then begin
      if m_TargetCret <> m_LockTarget then begin
        m_TargetCret := m_LockTarget;
        {if IsHero then begin
          THeroObject(Self).m_RoundPoint.X := (m_Master.m_nCurrX + m_TargetCret.m_nCurrX) div 2;
          THeroObject(Self).m_RoundPoint.Y := (m_Master.m_nCurrY + m_TargetCret.m_nCurrY) div 2;
        end;}
      end;
    end;

    if (m_Master <> nil) and (m_Master.m_btHeroRelax = 0) then begin
      if
        //((GetTickCount - m_dwSearchEnemyTick) > 6000) or
      ((m_TargetCret = nil) and (GetTickCount - m_dwSearchEnemyTick > 1000)) then begin
        m_dwSearchEnemyTick := GetTickCount();
        SearchTargetHero();
      end;
    end;

    if (m_Master <> nil) and (m_Master.m_PEnvir <> nil) and ((m_PEnvir = nil) or (m_Master.m_PEnvir <> m_PEnvir)) then begin
      if GetTickCount - m_dwSpaceMoveTick > 1000 then begin
        m_dwSpaceMoveTick := GetTickCount;
        if (m_Master.m_btHeroRelax <> 2) or not InSafeZone() then begin
          if m_Master.m_boHeroSearchTag then begin
            m_Master.m_boHeroSearchTag := False;
            TAnimalObject(self).m_nTargetX2 := -1;
            TAnimalObject(self).m_nTargetY2 := -1;
          end;
          m_Master.GetFrontPosition(nX, nY);
          SpaceMove(m_Master.m_PEnvir.m_sMapFileName, nX, nY, 1);
          m_LockTarget := nil;
          m_TargetCret := nil;
          inherited;
          Exit;
        end;
      end;
    end;

    if Think() then begin
      inherited;
      Exit;
    end;
    if (m_Master <> nil) and (m_Master.m_btHeroRelax = 2) then begin
      inherited;
      Exit;
    end;
    if (m_Master = nil) or (m_Master.m_btHeroRelax = 0) then begin
      if AttackTarget then begin
        inherited;
        Exit;
      end;
    end;

    if {m_boRunNext or} Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed then begin
      m_dwWalkTick := GetTickCount();
      //m_boRunNext := False;
      if m_TargetCret = nil then begin
        m_nTargetX := -1;
      end;
      if (m_Master <> nil) then begin
        if m_TargetCret = nil then begin
          if m_Master.m_boHeroSearchTag and (m_Master.m_btHeroRelax = 0) then begin
            m_nTargetX := m_nTargetX2;
            m_nTargetY := m_nTargetY2;
          end;
          bX := False;
          if g_Config.boAllowHeroPickUpItem then
            bX := MonPickItem();
          if not bX then begin
            if (not m_Master.m_boHeroSearchTag and (m_TargetCret = nil)) or (m_Master.m_btHeroRelax = 1) then begin

              m_Master.GetBackPositionEx(nX, nY, False);
              if (abs(m_nCurrX - nX) > 1) or (abs(m_nCurrY - nY) > 1) then begin
                if (abs(m_nCurrX - m_Master.m_nCurrX) > 2) or (abs(m_nCurrY - m_Master.m_nCurrY) > 2) then begin
                  m_nTargetX := nX;
                  m_nTargetY := nY;
                end else begin
                  m_nTargetX := nX + Random(3) - 1;
                  m_nTargetY := nY + Random(3) - 1;
                end;
                if (abs(m_nCurrX - m_nTargetX) <= 2) and (abs(m_nCurrY - m_nTargetY) <= 2) then begin
                  if m_PEnvir.GetMovingObject(m_nTargetX, m_nTargetX, True) <> nil then begin
                    m_nTargetX := m_nCurrX;
                    m_nTargetY := m_nCurrY;
                  end
                end;
              end;

            end;
          end;
        end;
        if m_Master.m_boHeroSearchTag then
          nDist := 30
        else
          nDist := 20;
        if (m_PEnvir <> m_Master.m_PEnvir) or ((m_Master.m_btHeroRelax <> 2) and ((abs(m_nCurrX - m_Master.m_nCurrX) > nDist) or (abs(m_nCurrY - m_Master.m_nCurrY) > nDist))) then begin
          if m_Master.m_boHeroSearchTag then begin
            m_Master.m_boHeroSearchTag := False;
            TAnimalObject(self).m_nTargetX2 := -1;
            TAnimalObject(self).m_nTargetY2 := -1;
          end;
          nX := m_nTargetX;
          nY := m_nTargetY;
          if m_Master.m_btHeroRelax = 2 then
            m_Master.GetBackPositionEx(nX, nY, False);
          SpaceMove(m_Master.m_PEnvir.m_sMapFileName, nX, nY, 1);
        end;
      end;
      if m_nTargetX <> -1 then begin
        if (abs(m_nCurrX - m_nTargetX) > 1) or (abs(m_nCurrY - m_nTargetY) > 1) then begin
          if not RuntoTargetXY(GetNextDirection(m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY), False) then
            GotoTargetXY();
        end else
          GotoTargetXY();
      end;

    end;
  end;
  inherited Run;
end;

function THeroObject.Think(): Boolean;
var
  nOldX, nOldY              : Integer;
begin
  Result := False;
  if (GetTickCount - m_dwThinkTick) > 3 * 1000 then begin
    m_dwThinkTick := GetTickCount();
    if not InSafeZone() and (m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2) then
      m_boDupMode := True;
    if not IsProperTarget(m_TargetCret) then
      m_TargetCret := nil;
  end;
  if m_boDupMode then begin
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    WalkTo(Random(8), False);
    if (nOldX <> m_nCurrX) or (nOldY <> m_nCurrY) then begin
      m_boDupMode := False;
      Result := True;
    end;
  end;
end;

procedure THeroObject.TrainingSkill(Magic: pTUserMagic);
var
  nc                        : Integer;
begin
  if (Magic <> nil) and (Magic.btLevel < Magic.MagicInfo.btTrainLv) then begin
    if Magic.MagicInfo.btClass = 0 then
      nc := m_Abil.Level
    else
      nc := m_nInPowerLevel;
    if Magic.MagicInfo.TrainLevel[Magic.btLevel] <= nc then begin
      TrainSkill(Magic, Random(3) + 1);
      if not CheckMagicLevelup(Magic) then
        SendDelayMsg(self, RM_MAGIC_LVEXP, Magic.MagicInfo.btClass, Magic.MagicInfo.wMagicId, Magic.btLevel, Magic.nTranPoint, '', 1000);
    end;
  end;
end;

//最近的非刺杀位置

{function THeroObject.GetAdvPosition(var nX, nY: Integer): Boolean;
var
  boTagWarr                 : Boolean;
  Envir                     : TEnvirnoment;
begin
  Result := False;
  boTagWarr := (m_btJob <> 0) and (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_btJob = 0);
  if not boTagWarr then begin
    GetBackPositionEx(nX, nY);
    Exit;
  end;
  nX := m_nCurrX;
  nY := m_nCurrY;
  Envir := m_PEnvir;
  if m_TargetCret <> nil then m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
  //Randomize;
  case m_btDirection of
    DR_UP: begin
        if Random(2) = 0 then begin
          Inc(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then Dec(nY);
          Inc(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Dec(nX);
        end else begin
          Inc(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then Dec(nY);
          Dec(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nX);
        end;
        if not Envir.CanWalk(nX, nY, False) then begin
          nY := m_nCurrY + 2;
        end;
      end;
    DR_DOWN: begin
        if Random(2) = 0 then begin
          Dec(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nY);
          Inc(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Dec(nX);
        end
        else begin
          Dec(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nY);
          Dec(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nX);
        end;
        if not Envir.CanWalk(nX, nY, False) then begin
          nY := m_nCurrY - 2;
        end;
      end;
    DR_LEFT: begin
        if Random(2) = 0 then begin
          Inc(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Dec(nX);
          Inc(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then Dec(nY);
        end
        else begin
          Inc(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Dec(nX);
          Dec(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nY);
        end;
        if not Envir.CanWalk(nX, nY, False) then begin
          nX := m_nCurrX + 2;
        end;
      end;
    DR_RIGHT: begin
        if Random(2) = 0 then begin
          Dec(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nX);
          Inc(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then Dec(nY);
        end
        else begin
          Dec(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nX);
          Dec(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nY);
        end;
        if not Envir.CanWalk(nX, nY, False) then begin
          nX := m_nCurrX - 2;
        end;
      end;
    DR_UPLEFT: begin
        if Random(2) = 0 then begin
          Inc(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Dec(nX);
        end
        else begin
          Inc(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then
            Dec(nY);
        end;
        if not Envir.CanWalk(nX, nY, False) then begin
          nX := m_nCurrX + 2;
          nY := m_nCurrY + 2;
        end;
      end;
    DR_UPRIGHT: begin
        if Random(2) = 0 then begin
          Inc(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then
            Dec(nY);
        end
        else begin
          Dec(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then
            Inc(nX);
        end;
        if not Envir.CanWalk(nX, nY, False) then begin
          nX := m_nCurrX - 2;
          nY := m_nCurrY + 2;
        end;
      end;
    DR_DOWNLEFT: begin
        if Random(2) = 0 then begin
          Inc(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Dec(nX);
        end
        else begin
          Dec(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nY);
        end;
        if not Envir.CanWalk(nX, nY, False) then begin
          nX := m_nCurrX + 2;
          nY := m_nCurrY - 2;
        end;
      end;
    DR_DOWNRIGHT: begin
        if Random(2) = 0 then begin
          Dec(nX, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nX);
        end
        else begin
          Dec(nY, 2);
          if not Envir.CanWalk(nX, nY, False) then Inc(nY);
        end;
        if not Envir.CanWalk(nX, nY, False) then begin
          nX := m_nCurrX - 2;
          nY := m_nCurrY - 2;
        end;
      end;
  end;
end;}

function THeroObject.__Warr__HeroAttackTarget(): Boolean;
var
  btDir, btMasterDir        : byte;
  boTrainOk, boChg          : Boolean;
  i, ii, nX, nY, nRange     : Integer;
  nHitMode, nMapRangeCount  : Integer;
  nc, nD, nDir, nSpellPoint : Integer;
  nNX, nNY, nTX, nTY        : Integer;
  UserMagic                 : pTUserMagic;
  dwTick, dwAttackTime      : LongWord;
  nTick, nOldDC, nAbsX, nAbsY: Integer;
  wMagicId                  : Word;
  sskilltick                : LongWord;
label
  LabelDoSpell, LabelStartAttack, LabelNormo, LabLongAttack, LabLongAttack2;
begin
  Result := False;
  m_boLAT := False;
  nHitMode := 0;
  UserMagic := nil;
  if g_nCheckLicense^ < 0 then Exit;
  if g_Config.boCalcHeroHitSpeed then
    dwAttackTime := _MAX(350, m_nNextHitTime - (m_nHitSpeed * g_Config.ClientConf.btItemSpeed div 2))
  else
    dwAttackTime := m_nNextHitTime;

  if m_TargetCret <> nil then begin
    if (m_nCurrX = m_TargetCret.m_nCurrX) and (m_nCurrY = m_TargetCret.m_nCurrY) then begin
      nTick := 0;
      while True do begin
        if WalkTo(m_btDirection, False) then
          Exit;
        Inc(m_btDirection);
        m_btDirection := m_btDirection mod 8;
        Inc(nTick);
        if nTick > 8 then Break;
      end;
    end;
    if Sidestep() then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) then begin
        GetBackPositionEx(nX, nY);
        if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(nX - m_Master.m_nCurrX) < 12) and (abs(nY - m_Master.m_nCurrY) < 12)) then
          SetTargetXY(nX, nY)
        else
          DelTargetCreat();
      end;
      Exit;
    end;

    // ========= series skill =========
    if ProperTarget() then begin
      if (m_nInPowerLevel > 0) and
        (m_nInPowerPoint > 20) and
        (m_btReadySeriesSkill = 1) and
        (m_btSeriesSkillSetpMax in [1..3]) then begin

        m_btReadySeriesSkill := 2;      //fired ...
        m_dwReadySeriesSkillTick := GetTickCount;

        m_dwLatestRushHitTick := 0;
        m_dwLatestSmiteTick := 0;
        m_dwLatestSmiteLongTick := 0;
        m_dwLatestSmiteWideTick := 0;

        m_btSeriesSkillSetpCur := 0;
        m_nLastSSkillID := 0;
      end;

      if (m_btReadySeriesSkill = 2) and (m_btSeriesSkillSetpCur < m_btSeriesSkillSetpMax) then begin
        wMagicId := m_SeriesSkillArr2[m_btSeriesSkillSetpCur].wMagicId;
        UserMagic := m_MagicArr[0][wMagicId];
        if (UserMagic <> nil) then begin

          sskilltick := 800;
          case m_nLastSSkillID of
            101: sskilltick := 15 * 56;
            102: sskilltick := 10 * 72 + 100;
            103: sskilltick := 10 * 78 + 100;
          end;

          case wMagicId of
            100: begin
                if GetAttackDir(m_TargetCret, btDir) or GetLongAttackDir(m_TargetCret, btDir) then begin
                  if Integer(GetTickCount - m_dwHitTick) > sskilltick then begin
                    m_dwHitTick := GetTickCount();
                    m_btDirection := btDir;
                    nSpellPoint := GetSpellPoint(UserMagic);
                    if m_nInPowerPoint >= nSpellPoint then begin
                      if nSpellPoint > 0 then begin
                        Dec(m_nInPowerPoint, nSpellPoint);
                        TPlayObject(self).InternalPowerPointChanged(True);
                      end;
                      if DoMotaeboEx(m_btDirection, _MIN(5, UserMagic.btLevel)) then begin
                        if UserMagic.btLevel < MagicMaxTrainLevel(UserMagic) then begin
                          if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] <= m_nInPowerLevel then begin
                            TrainSkill(UserMagic, Random(3) + 1);
                            if not CheckMagicLevelup(UserMagic) then begin
                              SendDelayMsg(self,
                                RM_MAGIC_LVEXP,
                                0,
                                UserMagic.MagicInfo.wMagicId,
                                UserMagic.btLevel,
                                UserMagic.nTranPoint,
                                '', 1000);
                            end;
                          end;
                        end;
                      end;
                      m_dwWalkTick := GetTickCount();
                      m_dwSpellTick := GetTickCount() + 800;
                      m_dwHeroSetTargetTick := GetTickCount + 300;
                      m_nLastSSkillID := wMagicId;
                      if (m_btSeriesSkillSetpCur = 0) and (m_LockTarget = nil) then
                        m_LockTarget := m_TargetCret;
                      Inc(m_btSeriesSkillSetpCur);
                      if m_btSeriesSkillSetpCur >= m_btSeriesSkillSetpMax then begin
                        m_btReadySeriesSkill := 0;
                        m_nLastSSkillID := 0;
                      end;
                      Result := True;
                      Exit;
                    end;
                  end else begin
                    m_dwWalkTick := GetTickCount();
                    m_dwSpellTick := GetTickCount() + 800;
                    m_dwHeroSetTargetTick := GetTickCount + 300;
                    m_nTargetX := -1;
                    Exit;
                  end;
                end else begin
                  if m_TargetCret.m_PEnvir = m_PEnvir then
                    SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
                  else
                    DelTargetCreat();
                  Exit;
                end;
              end;
            101: begin
                if GetAttackDir(m_TargetCret, btDir) then begin
                  if Integer(GetTickCount - m_dwHitTick) > sskilltick then begin
                    m_dwHitTick := GetTickCount();
                    if AllowSmiteSkill() then begin
                      nSpellPoint := GetSpellPoint(UserMagic);
                      if m_nInPowerPoint >= nSpellPoint then begin
                        if nSpellPoint > 0 then begin
                          Dec(m_nInPowerPoint, nSpellPoint);
                          TPlayObject(self).InternalPowerPointChanged(True);
                        end;
                        m_nLastSSkillID := wMagicId;
                        if (m_btSeriesSkillSetpCur = 0) and (m_LockTarget = nil) then
                          m_LockTarget := m_TargetCret;
                        Inc(m_btSeriesSkillSetpCur);
                        if m_btSeriesSkillSetpCur >= m_btSeriesSkillSetpMax then begin
                          m_btReadySeriesSkill := 0;
                          m_nLastSSkillID := 0;
                        end;
                        nHitMode := 20;
                        m_dwWalkTick := GetTickCount();
                        m_dwSpellTick := GetTickCount() + 800;
                        m_dwHeroSetTargetTick := GetTickCount + 300;
                        goto LabelStartAttack;
                      end;
                    end;
                  end else begin
                    m_dwWalkTick := GetTickCount();
                    m_dwSpellTick := GetTickCount() + 800;
                    m_dwHeroSetTargetTick := GetTickCount + 300;
                    m_nTargetX := -1;
                    Exit;
                  end;
                end else begin
                  if m_TargetCret.m_PEnvir = m_PEnvir then
                    SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
                  else
                    DelTargetCreat();
                  Exit;
                end;
              end;
            102: begin
                if (GetLongAttackDir(m_TargetCret, btDir) or GetAttackDir(m_TargetCret, btDir)) then begin
                  if Integer(GetTickCount - m_dwHitTick) > sskilltick then begin
                    m_dwHitTick := GetTickCount();
                    if AllowSmiteLongSkill() then begin
                      nSpellPoint := GetSpellPoint(UserMagic);
                      if m_nInPowerPoint >= nSpellPoint then begin
                        if nSpellPoint > 0 then begin
                          Dec(m_nInPowerPoint, nSpellPoint);
                          TPlayObject(self).InternalPowerPointChanged(True);
                        end;
                        m_nLastSSkillID := wMagicId;
                        if (m_btSeriesSkillSetpCur = 0) and (m_LockTarget = nil) then
                          m_LockTarget := m_TargetCret;
                        Inc(m_btSeriesSkillSetpCur);
                        if m_btSeriesSkillSetpCur >= m_btSeriesSkillSetpMax then begin
                          m_btReadySeriesSkill := 0;
                          m_nLastSSkillID := 0;
                        end;
                        nHitMode := 21;
                        //m_boLAT := True;
                        m_dwWalkTick := GetTickCount();
                        m_dwSpellTick := GetTickCount() + 800;
                        m_dwHeroSetTargetTick := GetTickCount + 300;
                        goto LabelStartAttack;
                      end;
                    end;
                  end else begin
                    m_dwWalkTick := GetTickCount();
                    m_dwSpellTick := GetTickCount() + 800;
                    m_dwHeroSetTargetTick := GetTickCount + 300;
                    m_nTargetX := -1;
                    Exit;
                  end;
                end else begin
                  if m_TargetCret.m_PEnvir = m_PEnvir then
                    SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
                  else
                    DelTargetCreat();
                  Exit;
                end;
              end;
            103: begin
                if GetAttackDir(m_TargetCret, btDir) then begin
                  if Integer(GetTickCount - m_dwHitTick) > sskilltick then begin
                    m_dwHitTick := GetTickCount();
                    if AllowSmiteWideSkill() then begin
                      nSpellPoint := GetSpellPoint(UserMagic);
                      if m_nInPowerPoint >= nSpellPoint then begin
                        if nSpellPoint > 0 then begin
                          Dec(m_nInPowerPoint, nSpellPoint);
                          TPlayObject(self).InternalPowerPointChanged(True);
                        end;
                        m_nLastSSkillID := wMagicId;
                        if (m_btSeriesSkillSetpCur = 0) and (m_LockTarget = nil) then
                          m_LockTarget := m_TargetCret;
                        Inc(m_btSeriesSkillSetpCur);
                        if m_btSeriesSkillSetpCur >= m_btSeriesSkillSetpMax then begin
                          m_btReadySeriesSkill := 0;
                          m_nLastSSkillID := 0;
                        end;
                        nHitMode := 22;
                        m_dwWalkTick := GetTickCount();
                        m_dwSpellTick := GetTickCount() + 800;
                        m_dwHeroSetTargetTick := GetTickCount + 300;
                        goto LabelStartAttack;
                      end;
                    end;
                  end else begin
                    m_dwWalkTick := GetTickCount();
                    m_dwSpellTick := GetTickCount() + 800;
                    m_dwHeroSetTargetTick := GetTickCount + 300;
                    m_nTargetX := -1;
                    Exit;
                  end;
                end else begin
                  if m_TargetCret.m_PEnvir = m_PEnvir then
                    SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
                  else
                    DelTargetCreat();
                  Exit;
                end;
              end;

          end;
        end;
      end;
    end;

    if m_btReadySeriesSkill = 2 then begin
      {if m_boRushhitSkill and ((GetTickCount - m_dwLatestRushHitTick) > 10 * 1000) then begin //080118
        m_boRushhitSkill := False;
        m_btReadySeriesSkill := 0;
      end;}
      if m_boSmiteSkill and ((GetTickCount - m_dwLatestSmiteTick) > 10 * 1000) then begin //080118
        m_boSmiteSkill := False;
        m_btReadySeriesSkill := 0;
        m_nLastSSkillID := 0;
      end;
      if m_boSmiteLongSkill and ((GetTickCount - m_dwLatestSmiteLongTick) > 10 * 1000) then begin //080118
        m_boSmiteLongSkill := False;
        m_btReadySeriesSkill := 0;
        m_nLastSSkillID := 0;
      end;
      if m_boSmiteWideSkill and ((GetTickCount - m_dwLatestSmiteWideTick) > 10 * 1000) then begin //080118
        m_boSmiteWideSkill := False;
        m_btReadySeriesSkill := 0;
        m_nLastSSkillID := 0;
      end;
    end;

    if g_Config.boAllowJointAttack and m_boJointAttackReady and IsHero then begin
      if not m_Master.m_boGhost and not m_Master.m_boDeath and not m_Master.m_boFixedHideMode and not m_Master.m_boStoneMode and (m_Master.m_wStatusTimeArr[POISON_STONE] = 0) and (m_Master.m_wStatusTimeArr[POISON_PURPLE] = 0) then begin
        if (m_TargetCret = m_Master.m_TargetCret) then begin
          //if TPlayObject(m_Master).CanNextAction() then begin
          if GetTickCount - m_dwJointHitTick > 200 then begin
            m_dwJointHitTick := GetTickCount();
            //Skill 60
            if (m_MagicArr[0][60] <> nil) and (m_Master.m_btJob = 0) then begin
              nSpellPoint := TPlayObject(self).GetSpellPoint(m_MagicArr[0][60]);
              if (m_WAbil.MP >= nSpellPoint) and (m_Master.m_WAbil.MP >= nSpellPoint) then begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_btDirection = btDir then begin
                  if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then begin
                    m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 6, nTX, nTY);
                    if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) > 0 then begin

                      btMasterDir := GetNextDirection(m_Master.m_nCurrX, m_Master.m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                      if m_Master.m_btDirection = btMasterDir then begin
                        if m_PEnvir.GetNextPosition(m_Master.m_nCurrX, m_Master.m_nCurrY, btMasterDir, 1, nNX, nNY) then begin
                          m_Master.m_PEnvir.GetNextPosition(m_Master.m_nCurrX, m_Master.m_nCurrY, btMasterDir, 6, nTX, nTY);
                          if m_Master.CheckMagPassThrough(nNX, nNY, nTX, nTY, btMasterDir) > 0 then begin
                            if g_nRegStatus^ = 1 then begin
                              ResetJointAttackEnergy;
                              if not g_bIsHookDll^ then begin
                                SendRefMsg(RM_JOINTATTACK, m_MagicArr[0][60].wMagIdx, m_nCurrX, m_nCurrY, m_btDirection, '');
                                m_Master.SendRefMsg(RM_JOINTATTACK, m_MagicArr[0][60].wMagIdx, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master.m_btDirection, '');
                                TPlayObject(self).DoMag60(m_MagicArr[0][60], btDir, m_TargetCret);
                                TPlayObject(m_Master).DoMag60(m_MagicArr[0][60], btMasterDir, m_TargetCret);
                              end;
                              TrainingSkill(m_MagicArr[0][60]);
                              TrainingSkill(m_MagicArr[1][60]);
                              if nSpellPoint > 0 then begin
                                DamageSpell(nSpellPoint);
                                HealthSpellChanged();
                                m_Master.DamageSpell(nSpellPoint);
                                m_Master.HealthSpellChanged();
                              end;
                              m_dwTargetFocusTick := GetTickCount();
                              m_dwHitTick := GetTickCount();
                              Result := True;
                            end;
                            Exit;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
            if (m_MagicArr[0][61] <> nil) and (m_Master.m_btJob = 2) then begin
              if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 3) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 3) and (abs(m_Master.m_nCurrX - m_TargetCret.m_nCurrX) <= 9) and (abs(m_Master.m_nCurrY - m_TargetCret.m_nCurrY) <= 9) then begin
                if g_nRegStatus^ = 1 then begin
                  ResetJointAttackEnergy;
                  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                  if not g_bIsHookDll^ then begin
                    TPlayObject(m_Master).SendRefMsg(RM_SPELL, 573, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 51, 'R');
                    TPlayObject(self).SendRefMsg(RM_JOINTATTACK, 62, m_nCurrX, m_nCurrY, m_btDirection, '');
                  end;
                  MagicManager.Mag61(TPlayObject(self), m_MagicArr[0][61], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                  TPlayObject(m_Master).SendRefMsg(RM_MAGICFIRE, 0, 15623, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                  TrainingSkill(m_MagicArr[0][61]);
                  TrainingSkill(m_MagicArr[1][61]);
                  m_dwHitTick := GetTickCount();
                  Result := True;
                end;
                Exit;
              end;
            end;
            if (m_MagicArr[0][62] <> nil) and (m_Master.m_btJob = 1) then begin
              if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 3) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 3) and (abs(m_Master.m_nCurrX - m_TargetCret.m_nCurrX) <= 9) and (abs(m_Master.m_nCurrY - m_TargetCret.m_nCurrY) <= 9) then begin
                if g_nRegStatus^ = 1 then begin
                  ResetJointAttackEnergy;
                  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                  nOldDC := m_Abil.DC;
                  m_Abil.DC := _MIN(High(Word), (m_Abil.DC + m_Master.m_Abil.MC * _MIN(1, m_MagicArr[0][62].btLevel)));
                  TPlayObject(m_Master).SendRefMsg(RM_SPELL, 572, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 52, 'R');
                  SendRefMsg(RM_JOINTATTACK, 61, m_nCurrX, m_nCurrY, m_btDirection, '');
                  MagicManager.Mag62(TPlayObject(self), m_MagicArr[0][62], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                  TPlayObject(m_Master).SendRefMsg(RM_MAGICFIRE, 0, 15879, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                  m_Abil.DC := nOldDC;
                  TrainingSkill(m_MagicArr[0][62]);
                  TrainingSkill(m_MagicArr[1][62]);
                  m_dwHitTick := GetTickCount();
                  Result := True;
                end;
                Exit;
              end;
            end;
          end;
        end;
      end;
    end;
    //end;

    if (m_MagicArr[0][56] <> nil) and (m_MagicArr[0][56].btKey = 0) and ((GetTickCount - m_dwLatestPursueHitTick) > (g_Config.nHeroFireSwordTime + 5000)) and (GetLongAttackDirX(m_TargetCret, btDir)) then begin
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then begin
        m_dwLatestPursueHitTick := GetTickCount();
        m_dwHitTick := GetTickCount();
        nHitMode := 13;
        m_boPursueHitSkill := True;
        m_boLAT := True;
        goto LabelStartAttack;
      end;
    end;

    //warr
    if (m_MagicArr[0][114] <> nil) and (m_MagicArr[0][114].btKey = 0) and GetLongAttackDirX(m_TargetCret, btDir) and (GetTickCount - m_dwLatestSmiteWideTick2 > g_Config.nSmiteWideHitSkillInvTime) then begin
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then begin
        m_dwLatestSmiteWideTick2 := GetTickCount;
        m_dwHitTick := GetTickCount();
        m_dwWalkTick := GetTickCount();
        nHitMode := 23;
        m_boSmiteWideSkill2 := True;
        m_boLAT := True;
        goto LabelStartAttack;
      end;
    end;

    if (m_MagicArr[0][113] <> nil) and (m_MagicArr[0][113].btKey = 0) and GetLongAttackDirX(m_TargetCret, btDir) and (GetTickCount - m_dwLatestSmiteLongTick2 > 15 * 1000) then begin
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then begin
        m_dwLatestSmiteLongTick2 := GetTickCount;
        m_dwHitTick := GetTickCount();
        nHitMode := 24;
        m_boSmiteLongSkill2 := True;
        m_boLAT := True;
        goto LabelStartAttack;
      end;
    end;

    nD := _MAX(3, Random(10));
    if (m_MagicArr[0][66] <> nil) and (m_MagicArr[0][66].btKey = 0) and (GetTickCount - m_dwLatestHeroLongHitTick > 4 * 1000) and
      (((m_WAbil.Level > m_TargetCret.m_WAbil.Level) and GetLongAttackDirX(m_TargetCret, btDir)) or
      ((m_WAbil.Level <= m_TargetCret.m_WAbil.Level) and GetLongAttackDir(m_TargetCret, btDir))) then begin
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then begin
        //Inc(m_nLongAttackCount);
        m_dwLatestHeroLongHitTick := GetTickCount();
        m_dwHitTick := GetTickCount();
        if m_WAbil.Level > m_TargetCret.m_WAbil.Level then begin
          m_btSquareHit := 2;
          nHitMode := 12;
        end else begin
          m_btSquareHit := 1;
          nHitMode := 12;
        end;
        m_boLAT := True;
        goto LabelStartAttack;
      end;
    end else if (m_MagicArr[0][SKILL_ERGUM] <> nil) and (m_MagicArr[0][SKILL_ERGUM].btKey = 0) and (m_nLongAttackCount <= nD) and GetLongAttackDir(m_TargetCret, btDir) then begin
      if (m_nLongAttackCount > 1) and (nD >= 5) then begin
        //
        nRange := -9;
        goto LabLongAttack;
      end;
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then begin
        Inc(m_nLongAttackCount);
        m_dwHitTick := GetTickCount();
        nHitMode := 4;
        m_boUseThrusting := True;
        m_boLAT := True;
        goto LabelStartAttack;
      end;
    end else begin
      nRange := Round((m_WAbil.HP * 100) / m_WAbil.MaxHP / 2);
      LabLongAttack:
      m_nLongAttackCount := 0;
      if (m_MagicArr[0][SKILL_ERGUM] <> nil) and (m_MagicArr[0][SKILL_ERGUM].btKey = 0) and (Random(nRange + 32) = 0) or (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 2) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 2) then begin
        if GetLongAttackDir(m_TargetCret, btDir) then begin
          nD := 999;
          nTX := -1;
          nDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          if Random(2) = 0 then
            nDir := (nDir + 1) mod 8
          else
            nDir := (nDir + 7) mod 8;
          if (m_TargetCret.m_PEnvir <> nil) and m_TargetCret.m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, nDir, 2, nNX, nNY) then begin
            if ((m_nCurrX <> nNX) or (m_nCurrY <> nNY)) and (abs(m_nCurrX - nNX) mod 2 = 0) and (abs(m_nCurrY - nNY) mod 2 = 0) then begin
              nTX := nNX;
              nTY := nNY;
            end;
          end;
          if nTX <> -1 then begin
            if (m_TargetCret.m_nCurrX <> nTX) or (m_TargetCret.m_nCurrY <> nTY) then begin
              if (abs(nTX - m_TargetCret.m_nCurrX) > 1) or (abs(nTY - m_TargetCret.m_nCurrY) > 1) then begin
                if m_PEnvir.CanWalk(nTX, nTY, False) then
                  SetTargetXY(nTX, nTY)
                else begin
                  goto LabLongAttack2;
                end;
              end;
            end;
          end;
        end else begin
          LabLongAttack2:
          nD := 999;
          nTX := -1;
          for ii := 0 to 8 - 1 do begin
            if (m_TargetCret.m_PEnvir <> nil) and m_TargetCret.m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, ii, 2, nNX, nNY) then begin
              {if ((m_nCurrX <> nNX) or (m_nCurrY <> nNY)) and (abs(m_nCurrX - nNX) mod 2 = 0) and (abs(m_nCurrY - nNY) mod 2 = 0) then begin
                nTX := nNX;
                nTY := nNY;
                Break;
              end;}
              nc := abs(m_nCurrX - nNX) + abs(m_nCurrY - nNY);
              if nc < nD then begin
                nD := nc;
                nTX := nNX;
                nTY := nNY;
              end;
            end;
          end;
          if nTX <> -1 then begin
            if (m_TargetCret.m_nCurrX <> nTX) or (m_TargetCret.m_nCurrY <> nTY) then begin
              if (abs(nTX - m_TargetCret.m_nCurrX) > 1) or (abs(nTY - m_TargetCret.m_nCurrY) > 1) then begin
                if m_PEnvir.CanWalk(nTX, nTY, False) then
                  SetTargetXY(nTX, nTY)
                else begin
                  nOldDC := 0;
                  while nOldDC <= 15 do begin
                    nTX := m_TargetCret.m_nCurrX + (Random(3) - 1) * 2;
                    nTY := m_TargetCret.m_nCurrY + (Random(3) - 1) * 2;
                    if (m_TargetCret.m_nCurrX <> nTX) or (m_TargetCret.m_nCurrY <> nTY) then begin
                      if (abs(nTX - m_TargetCret.m_nCurrX) > 1) or (abs(nTY - m_TargetCret.m_nCurrY) > 1) then begin
                        if m_PEnvir.CanWalk(nTX, nTY, False) then begin
                          //m_boLockLongAttack := True;
                          SetTargetXY(nTX, nTY);
                          Break;
                        end;
                      end;
                    end;
                    Inc(nOldDC);
                  end;
                end;
              end;
            end;
          end;
        end;
      end else begin
        if (m_MagicArr[0][75] <> nil) and (m_MagicArr[0][75].btKey = 0) and (m_nMagShieldHP <= 0) then begin
          if GetTickCount - m_dwUnionHitShieldTick > 10 * 1000 then begin
            m_dwUnionHitShieldTick := GetTickCount;
            Result := HeroDoSpell(m_MagicArr[0][75], m_TargetCret, boTrainOk);
            Exit;
          end;
        end;
        if GetAttackDir(m_TargetCret, btDir) then begin
          if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then begin
            m_dwHitTick := GetTickCount();
            //warr
            if (m_MagicArr[0][114] <> nil) and (m_MagicArr[0][114].btKey = 0) and (GetTickCount - m_dwLatestSmiteWideTick2 > g_Config.nSmiteWideHitSkillInvTime) then begin
              m_dwLatestSmiteWideTick2 := GetTickCount;
              m_dwWalkTick := GetTickCount();
              nHitMode := 23;
              m_boSmiteWideSkill2 := True;
              m_boLAT := True;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][113] <> nil) and (m_MagicArr[0][113].btKey = 0) then begin
              if GetTickCount - m_dwLatestSmiteLongTick2 > 15 * 1000 then begin
                m_dwLatestSmiteLongTick2 := GetTickCount;
                nHitMode := 24;
                m_boSmiteLongSkill2 := True;
                goto LabelStartAttack;
              end;
            end;

            UserMagic := m_MagicArr[0][SKILL_MOOTEBO]; //TPlayObject(self).GetMagicInfo(SKILL_MOOTEBO);
            if (UserMagic <> nil) and (UserMagic.btKey = 0) and (m_WAbil.Level > m_TargetCret.m_WAbil.Level) and not m_TargetCret.m_boStickMode then begin
              if (GetTickCount - m_dwDoMotaeboTick) > (6 * 1000 + Random(5 * 1000)) then begin
                m_dwDoMotaeboTick := GetTickCount();
                m_btDirection := btDir;
                nSpellPoint := TPlayObject(self).GetSpellPoint(UserMagic);
                if m_WAbil.MP >= nSpellPoint then begin
                  if nSpellPoint > 0 then begin
                    TPlayObject(self).DamageSpell(nSpellPoint);
                    TPlayObject(self).HealthSpellChanged();
                  end;
                  if TPlayObject(self).DoMotaebo(m_btDirection, UserMagic.btLevel) then begin
                    TrainingSkill(UserMagic);
                    m_dwTargetFocusTick := GetTickCount();
                    dwTick := GetTickCount;
                    nTick := dwTick - m_dwHitTick - dwAttackTime;
                    if nTick < 0 then m_dwHitTick := dwTick + nTick + g_Config.nWarrCmpInvTime + 90;
                    Result := True;
                    Exit;
                  end;
                end;
              end;
            end;

            if (m_MagicArr[0][56] <> nil) and (m_MagicArr[0][56].btKey = 0) and ((GetTickCount - m_dwLatestPursueHitTick) > g_Config.nHeroFireSwordTime) then begin
              m_dwLatestPursueHitTick := GetTickCount();
              nHitMode := 13;
              m_boPursueHitSkill := True;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][43] <> nil) and (m_MagicArr[0][43].btKey = 0) and ((GetTickCount - m_dwLatestTwinHitTick) > 15 * 1000) then begin
              m_dwLatestTwinHitTick := GetTickCount();
              nHitMode := 9;
              m_boTwinHitSkill := True;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][SKILL_FIRESWORD] <> nil) and (m_MagicArr[0][SKILL_FIRESWORD].btKey = 0) and ((GetTickCount - m_dwLatestFireHitTick) > g_Config.nHeroFireSwordTime) then begin
              m_dwLatestFireHitTick := GetTickCount();
              nHitMode := 7;
              m_boFireHitSkill := True;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][66] <> nil) and (m_MagicArr[0][66].btKey = 0) and ((GetTickCount - m_dwLatestHeroLongHitTick) > 6000) and TargetInSwordLongAttackRangeX() then begin
              m_dwLatestHeroLongHitTick := GetTickCount();
              nHitMode := 12;
              if (m_WAbil.Level > m_TargetCret.m_WAbil.Level) then
                m_btSquareHit := 2
              else
                m_btSquareHit := 1;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][66] <> nil) and (m_MagicArr[0][66].btKey = 0) and ((GetTickCount - m_dwLatestHeroLongHitTick) > 8000) then begin
              m_dwLatestHeroLongHitTick := GetTickCount();
              nHitMode := 12;
              if (m_WAbil.Level > m_TargetCret.m_WAbil.Level) then
                m_btSquareHit := 2
              else
                m_btSquareHit := 1;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][SKILL_ERGUM] <> nil) and (m_MagicArr[0][SKILL_ERGUM].btKey = 0) and TargetInSwordLongAttackRange then begin
              nHitMode := 4;
              m_boUseThrusting := True;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][SKILL_YEDO] <> nil) and (m_MagicArr[0][SKILL_YEDO].btKey = 0) and (m_UseItems[U_WEAPON].Dura > 0) and (Random(9) = 0) then begin
              nHitMode := 3;
              m_boPowerHit := True;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][SKILL_BANWOL] <> nil) and (m_MagicArr[0][SKILL_BANWOL].btKey = 0) and (m_Abil.MP >= 3) and TargetInSwordWideAttackRange then begin
              nHitMode := 5;
              goto LabelStartAttack;
            end;

            if GetTickCount - m_dwMag41Tick > (8 * 1000 + Random(8 * 1000)) then begin
              m_dwMag41Tick := GetTickCount();
              UserMagic := m_MagicArr[0][41]; //TPlayObject(self).GetMagicInfo(41);
              if (UserMagic <> nil) and (UserMagic.btKey = 0) and (GetTagXYRangeCount(1, 3, 1) > 3) then begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(UserMagic, m_TargetCret, boTrainOk);
                Exit;
              end;
            end;

            LabelStartAttack:
            m_dwTargetFocusTick := GetTickCount();
            if nHitMode in [0, 3, 4, 5, 7, 9, 12, 13, 20..24] then begin
              m_dwHitTick := GetTickCount();
              if m_boLAT then
                AttackDir(nil, nHitMode, btDir)
              else
                AttackDir(m_TargetCret, nHitMode, btDir);
              Result := True;
            end;
          end;
          Result := True;
        end else begin
          if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 3) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 3)) then begin
            if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
              m_dwHitTick := GetTickCount();
              nMapRangeCount := GetTagXYRangeCount(0, 1);
              if nMapRangeCount > 3 then begin
                UserMagic := m_MagicArr[0][71]; //TPlayObject(self).GetMagicInfo(71);
                if not (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_Abil.Level + 8 < m_Abil.Level) and (UserMagic <> nil) and (UserMagic.btKey = 0) then
                  goto LabelDoSpell;
              end;
              if (nMapRangeCount > 2) then
                UserMagic := m_MagicArr[0][39]; //TPlayObject(self).GetMagicInfo(39);
              if UserMagic <> nil then
                goto LabelDoSpell;

              LabelDoSpell:
              if (UserMagic <> nil) and (UserMagic.btKey = 0) then begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(UserMagic, m_TargetCret, boTrainOk);
                Exit;
              end;
            end;
          end;
          if m_TargetCret.m_PEnvir = m_PEnvir then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          else
            DelTargetCreat();
        end;
      end;
    end;
  end;
end;

function THeroObject.__Wiza__HeroAttackTarget(): Boolean;
var
  i, nCount, nPower         : Integer;
  boTrainOk                 : Boolean;
  btDir                     : byte;
  nTag, nX, nY, nAbsX, nAbsY: Integer;
  nNX, nNY, nTX, nTY, nOldDC: Integer;
  dwAttackTime              : LongWord;
  wMagicId                  : Word;
  UserMagic                 : pTUserMagic;
  sskilltick                : LongWord;
label
  DDDD, FFFF, labLoop, LabelMagPass;
begin
  Result := False;
  boTrainOk := False;

  if (m_btReadySeriesSkill <> 2) and (Integer(GetTickCount - m_dwSpellTick) > m_nNextHitTime) then begin
    m_dwSpellTick := GetTickCount();
    if (m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] <= 0) and (m_MagicArr[0][31] <> nil) and (m_MagicArr[0][31].btKey = 0) and (m_Master <> nil) and (m_Master.m_btHeroMakeSlave = 4) then begin
      m_dwTargetFocusTick := GetTickCount();
      m_dwHitTick := GetTickCount();
      Result := HeroDoSpell(m_MagicArr[0][31], self, boTrainOk);
      Exit;
    end;
  end;

  if m_Abil.Level >= 7 then begin
    if m_TargetCret <> nil then begin

      if Sidestep() then begin
        if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) then begin
          //GetAdvPosition(nX, nY);
          GetBackPositionEx(nX, nY);
          if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(nX - m_Master.m_nCurrX) < 12) and (abs(nY - m_Master.m_nCurrY) < 12)) then
            SetTargetXY(nX, nY)
          else
            DelTargetCreat();
        end;
        Exit;
      end;

      // ========= series skill =========
      if ProperTarget() then begin
        if (m_nInPowerLevel > 0) and
          (m_nInPowerPoint > 20) and
          (m_btReadySeriesSkill = 1) and
          (m_btSeriesSkillSetpMax in [1..3]) then begin

          m_btReadySeriesSkill := 2;    //fired ...
          m_dwReadySeriesSkillTick := GetTickCount;

          m_sTargetCret := m_TargetCret;
          m_btSeriesSkillSetpCur := 0;
          m_nLastSSkillID := 0;
        end;

        if (m_btReadySeriesSkill = 2) and (m_sTargetCret <> nil) and not m_sTargetCret.m_boDeath and (m_btSeriesSkillSetpCur < m_btSeriesSkillSetpMax) then begin

          wMagicId := m_SeriesSkillArr2[m_btSeriesSkillSetpCur].wMagicId;
          UserMagic := m_MagicArr[0][wMagicId];
          if (UserMagic <> nil) then begin
            case wMagicId of
              104..107: begin
                  nAbsX := abs(m_nCurrX - m_sTargetCret.m_nCurrX);
                  nAbsY := abs(m_nCurrY - m_sTargetCret.m_nCurrY);
                  if (nAbsX <= g_Config.nMagicAttackRage) and (nAbsY <= g_Config.nMagicAttackRage) then begin

                    sskilltick := 700;
                    case m_nLastSSkillID of
                      104: sskilltick := 06 * 92 - 040;
                      105: sskilltick := 10 * 88 - 030;
                      106: sskilltick := 08 * 88 - 040;
                      107: sskilltick := 13 * 72 - 080;
                    end;
                    if Integer(GetTickCount - m_dwHitTick) > sskilltick then begin
                      m_dwHitTick := GetTickCount();
                      m_dwTargetFocusTick := GetTickCount();
                      m_dwWalkTick := GetTickCount() + 300;
                      m_dwSpellTick := GetTickCount() + 800;
                      m_dwHeroSetTargetTick := GetTickCount + 300;
                      m_dwCloneSelfTick := GetTickCount - g_Config.dwCloneSelfTime + 2000;
                      Result := HeroDoSpell(UserMagic, m_sTargetCret, boTrainOk);
                      Inc(m_btSeriesSkillSetpCur);
                      m_nLastSSkillID := wMagicId;
                      if (m_btSeriesSkillSetpCur >= m_btSeriesSkillSetpMax) or (m_sTargetCret = nil) or m_sTargetCret.m_boDeath then begin
                        m_btReadySeriesSkill := 0;
                        m_nLastSSkillID := 0;
                        m_dwHitTick := GetTickCount() + 200;
                      end;
                      Exit;
                    end else begin
                      m_dwTargetFocusTick := GetTickCount();
                      m_dwWalkTick := GetTickCount() + 300;
                      m_dwSpellTick := GetTickCount() + 800;
                      m_dwHeroSetTargetTick := GetTickCount + 300;
                      m_dwCloneSelfTick := GetTickCount - g_Config.dwCloneSelfTime + 2000;
                      m_nTargetX := -1;
                      Exit;
                    end;
                  end else begin
                    if (m_btSeriesSkillSetpCur > 0) and (m_sTargetCret <> nil) then begin
                      m_btReadySeriesSkill := 0;
                      m_nLastSSkillID := 0;
                    end;
                    if m_sTargetCret.m_PEnvir = m_PEnvir then
                      SetTargetXY(m_sTargetCret.m_nCurrX, m_sTargetCret.m_nCurrY);
                  end;
                end;
            end;
          end;
        end;
      end;

      if g_Config.boAllowJointAttack and m_boJointAttackReady and IsHero then begin
        if not m_Master.m_boGhost and not m_Master.m_boDeath and not m_Master.m_boFixedHideMode and not m_Master.m_boStoneMode and (m_Master.m_wStatusTimeArr[POISON_STONE] = 0) and (m_Master.m_wStatusTimeArr[POISON_PURPLE] = 0) then begin
          if (m_TargetCret = m_Master.m_TargetCret) then begin
            if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= g_Config.nMagicAttackRage) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= g_Config.nMagicAttackRage) and
              (abs(m_Master.m_nCurrX - m_TargetCret.m_nCurrX) <= g_Config.nMagicAttackRage) and (abs(m_Master.m_nCurrY - m_TargetCret.m_nCurrY) <= g_Config.nMagicAttackRage) then begin
              //if TPlayObject(m_Master).CanNextAction() then begin
              if GetTickCount - m_dwJointHitTick > 200 then begin
                m_dwJointHitTick := GetTickCount();
                case m_Master.m_btJob of
                  0: if (m_MagicArr[0][62] <> nil) then begin
                      if (abs(m_Master.m_nCurrX - m_TargetCret.m_nCurrX) <= 3) and (abs(m_Master.m_nCurrY - m_TargetCret.m_nCurrY) <= 3) then begin
                        ResetJointAttackEnergy;
                        m_Master.m_btDirection := GetNextDirection(m_Master.m_nCurrX, m_Master.m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                        nOldDC := m_Master.m_Abil.DC;
                        m_Master.m_Abil.DC := _MIN(High(Word), (m_Master.m_Abil.DC + m_Abil.MC * _MIN(1, m_MagicArr[0][62].btLevel)));
                        if not g_bIsHookDll^ then begin
                          TPlayObject(self).SendRefMsg(RM_SPELL, 572, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 52, '');
                          m_Master.SendRefMsg(RM_JOINTATTACK, 61, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master.m_btDirection, '');
                          MagicManager.Mag62(TPlayObject(m_Master), m_MagicArr[0][62], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                          TPlayObject(self).SendRefMsg(RM_MAGICFIRE, 0, 15879, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                        end;
                        m_Master.m_Abil.DC := nOldDC;
                        TrainingSkill(m_MagicArr[0][62]);
                        TrainingSkill(m_MagicArr[1][62]);
                        m_dwTargetFocusTick := GetTickCount();
                        m_dwHitTick := GetTickCount();
                        Result := True;
                        Exit;
                      end;
                    end;
                  1: if m_MagicArr[0][65] <> nil then begin
                      ResetJointAttackEnergy;
                      TPlayObject(m_Master).SendRefMsg(RM_SPELL, 574, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 55, 'R');
                      TPlayObject(self).SendRefMsg(RM_SPELL, 574, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 55, '');
                      MagicManager.Mag65(TPlayObject(m_Master), m_MagicArr[0][65], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                      Result := MagicManager.Mag65(TPlayObject(self), m_MagicArr[0][65], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                      TPlayObject(m_Master).SendRefMsg(RM_MAGICFIRE, 0, 16647, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                      TPlayObject(self).SendRefMsg(RM_MAGICFIRE, 0, 16647, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                      if Result {and (m_MagicArr[0][65].btLevel < 3)} then begin
                        TrainingSkill(m_MagicArr[0][65]);
                        TrainingSkill(m_MagicArr[1][65]);
                      end;
                      m_dwTargetFocusTick := GetTickCount();
                      m_dwHitTick := GetTickCount();
                      Exit;
                    end;
                  2: if m_MagicArr[0][64] <> nil then begin
                      ResetJointAttackEnergy;
                      TPlayObject(m_Master).SendRefMsg(RM_SPELL, 576, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 54, 'R');
                      TPlayObject(self).SendRefMsg(RM_SPELL, 320, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 54, '');
                      MagicManager.Mag64(TPlayObject(m_Master), m_MagicArr[0][64], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                      Result := MagicManager.Mag64(TPlayObject(self), m_MagicArr[0][64], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                      TPlayObject(m_Master).SendRefMsg(RM_MAGICFIRE, 0, 16391, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                      TPlayObject(self).SendRefMsg(RM_MAGICFIRE, 0, 16391, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                      if Result {and (m_MagicArr[0][64].btLevel < 3)} then begin
                        TrainingSkill(m_MagicArr[0][64]);
                        TrainingSkill(m_MagicArr[1][64]);
                      end;
                      m_dwTargetFocusTick := GetTickCount();
                      m_dwHitTick := GetTickCount();
                      Exit;
                    end;
                end;
              end;
            end;
          end;
        end;
      end;
      //end;

      nAbsX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
      nAbsY := abs(m_nCurrY - m_TargetCret.m_nCurrY);

      //wizard
      if (m_MagicArr[0][114] <> nil) and (m_MagicArr[0][114].btKey = 0) and (nAbsX < 8) and (nAbsY < 8) and (GetTickCount - m_dwLatestSmiteWideTick2 > g_Config.nSmiteWideHitSkillInvTime) then begin
        if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then begin
          m_dwLatestSmiteWideTick2 := GetTickCount;
          m_dwHitTick := GetTickCount();
          m_dwWalkTick := GetTickCount();
          btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          m_boSmiteWideSkill2 := True;
          m_dwTargetFocusTick := GetTickCount();
          AttackDir(m_TargetCret, 23, btDir);
          Result := True;
          Exit;
        end;
      end;

      if ((nAbsX > 2) or (nAbsY > 2) {or (Random(12) = 0)}) then begin
        if (nAbsX <= g_Config.nMagicAttackRage) and (nAbsY <= g_Config.nMagicAttackRage) then begin

          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
            m_dwHitTick := GetTickCount();
            if (m_MagicArr[0][75] <> nil) and (m_MagicArr[0][75].btKey = 0) and (m_nMagShieldHP <= 0) then begin
              if GetTickCount - m_dwUnionHitShieldTick > 15 * 1000 then begin
                m_dwUnionHitShieldTick := GetTickCount;
                Result := HeroDoSpell(m_MagicArr[0][75], m_TargetCret, boTrainOk);
                Exit;
              end;
            end;

            if m_boStrike and IsHero and (m_MagicArr[0][74] <> nil) and (m_MagicArr[0][74].btKey = 0) then begin
              if GetTickCount - m_dwCloneSelfTick > g_Config.dwCloneSelfTime then begin
                m_dwCloneSelfTick := GetTickCount();
                nCount := 0;
                for i := m_SlaveList.Count - 1 downto 0 do begin
                  if TBaseObject(m_SlaveList.Items[i]).m_btRaceServer = RC_HERO then
                    Inc(nCount);
                end;
                if nCount < g_Config.nBodyCount then begin
                  m_dwTargetFocusTick := GetTickCount();
                  Result := HeroDoSpell(m_MagicArr[0][74], self, boTrainOk);
                  m_boStrike := False;
                  Exit;
                end;
              end;
            end;

            if (m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] <= 0) and (m_MagicArr[0][31] <> nil) and (m_MagicArr[0][31].btKey = 0) and (m_Master <> nil) and (m_Master.m_btHeroMakeSlave = 4) then begin
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][31], self, boTrainOk);
              Exit;
            end;

            if (m_MagicArr[0][22] <> nil) and (m_MagicArr[0][22].btKey = 0) then begin
              if (m_Master <> nil) and m_Master.m_boHeroSearchTag then begin
                if (GetTagXYRangeCount(1, 6) >= 10) then begin
                  nTX := m_nTargetX2 + Random(2 * 6 + 1) - 6;
                  nTY := m_nTargetY2 + Random(2 * 6 + 1) - 6;
                  if m_PEnvir.GetEvent(nTX, nTY) = nil then begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := TPlayObject(self).DoSpell(m_MagicArr[0][22], nTX, nTY, self, boTrainOk);
                    Exit;
                  end;
                end;
              end;
              if (GetTagXYRangeCount(1, 6) >= 18) then begin
                if m_PEnvir.GetEvent(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY) = nil then begin
                  m_dwTargetFocusTick := GetTickCount();
                  Result := HeroDoSpell(m_MagicArr[0][22], m_TargetCret, boTrainOk);
                  Exit;
                end;
              end;
            end;

            if m_btMagPassTh > 0 then begin
              Dec(m_btMagPassTh);
              if (m_MagicArr[0][10] <> nil) and (m_MagicArr[0][10].btKey = 0) then begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then begin
                  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 8, nTX, nTY);
                  if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) > 0 then begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := HeroDoSpell(m_MagicArr[0][10], m_TargetCret, boTrainOk);
                    Exit;
                  end;
                end;
              end;
              if (m_MagicArr[0][9] <> nil) and (m_MagicArr[0][9].btKey = 0) then begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then begin
                  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 5, nTX, nTY);
                  if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) > 0 then begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := HeroDoSpell(m_MagicArr[0][9], m_TargetCret, boTrainOk);
                    Exit;
                  end;
                end;
              end;
            end;

            nTag := GetTagXYRangeCount(0, 1, 1);
            if nTag <= 1 then begin
              //ReGetMagID:

              if (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and
                (m_MagicArr[0][10] <> nil) and
                (m_MagicArr[0][10].btKey = 0) and
                (Random(10) > 2) then begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then begin
                  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 8, nTX, nTY);
                  if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) >= 1 then begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := HeroDoSpell(m_MagicArr[0][10], m_TargetCret, boTrainOk);
                    if m_btMagPassTh > 0 then m_btMagPassTh := 0;
                    Exit;
                  end;
                end;
              end;

              if (m_TargetCret.m_Abil.Level < 50) and (m_TargetCret.m_Abil.Level + 10 < m_Abil.Level) and (m_TargetCret.m_btLifeAttrib = LA_UNDEAD) and (m_MagicArr[0][32] <> nil) and (m_MagicArr[0][32].btKey = 0) then begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][32], m_TargetCret, boTrainOk);
                Exit;
              end;
              if (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_btJob = 0) and (Random(nAbsX + nAbsX) <= 2) and (m_TargetCret.m_Abil.Level + 3 < m_Abil.Level) and (m_MagicArr[0][44] <> nil) and (m_MagicArr[0][44].btKey = 0) then begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][44], m_TargetCret, boTrainOk);
                Exit;
              end;
              m_nCurMagId := 0;
              if m_MagicArr[0][11] <> nil then
                m_nCurMagId := 11
              else if m_MagicArr[0][5] <> nil then
                m_nCurMagId := 5
              else if m_MagicArr[0][1] <> nil then
                m_nCurMagId := 1;
              if (Random(6) > 3) and (m_MagicArr[0][45] <> nil) then
                m_nCurMagId := 45;
              if (m_nCurMagId > 0) and (m_MagicArr[0][m_nCurMagId] <> nil) and (m_MagicArr[0][m_nCurMagId].btKey = 0) then begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][m_nCurMagId], m_TargetCret, boTrainOk);
                Exit;
              end;
            end;

            if nTag < 5 then begin
              if (m_MagicArr[0][10] <> nil) and (m_MagicArr[0][10].btKey = 0) then begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then begin
                  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 8, nTX, nTY);
                  if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) > 2 then begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := HeroDoSpell(m_MagicArr[0][10], m_TargetCret, boTrainOk);
                    if m_btMagPassTh > 0 then m_btMagPassTh := 0;
                    Exit;
                  end;
                end;
              end;
              if (m_MagicArr[0][9] <> nil) and (m_MagicArr[0][9].btKey = 0) then begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then begin
                  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 5, nTX, nTY);
                  if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) > 1 then begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := HeroDoSpell(m_MagicArr[0][9], m_TargetCret, boTrainOk);
                    if m_btMagPassTh > 0 then m_btMagPassTh := 0;
                    Exit;
                  end;
                end;
              end;
            end;

            m_nCurMagId := 0;           //群攻...
            if Random(6) > 1 then begin
              if Random(5) > 1 then begin
                if (m_MagicArr[0][58] <> nil) then
                  m_nCurMagId := 58
                else if (m_MagicArr[0][33] <> nil) then
                  m_nCurMagId := 33;
              end else if (m_MagicArr[0][33] <> nil) then
                m_nCurMagId := 33;
            end else if (m_MagicArr[0][47] <> nil) then
              m_nCurMagId := 47;
            if (m_nCurMagId <= 0) and (m_MagicArr[0][23] <> nil) then
              m_nCurMagId := 23;
            if (m_nCurMagId > 0) and (m_MagicArr[0][m_nCurMagId] <> nil) and (m_MagicArr[0][m_nCurMagId].btKey = 0) then begin
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][m_nCurMagId], m_TargetCret, boTrainOk);
              Exit;
            end;

            //goto ReGetMagID;
            if (m_TargetCret.m_Abil.Level < 50) and (m_TargetCret.m_Abil.Level + 10 < m_Abil.Level) and (m_TargetCret.m_btLifeAttrib = LA_UNDEAD) and (m_MagicArr[0][32] <> nil) and (m_MagicArr[0][32].btKey = 0) then begin
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][32], m_TargetCret, boTrainOk);
              Exit;
            end;
            //寒冰掌
            if (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_btJob = 0) and (nAbsX <= 4) and (nAbsY <= 4) and (m_TargetCret.m_Abil.Level + 3 < m_Abil.Level) and (m_MagicArr[0][44] <> nil) and (m_MagicArr[0][44].btKey = 0) and (Random(3) = 0) then begin
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][44], m_TargetCret, boTrainOk);
              Exit;
            end;

            m_nCurMagId := 0;           //单攻...
            if m_MagicArr[0][11] <> nil then
              m_nCurMagId := 11
            else if m_MagicArr[0][5] <> nil then
              m_nCurMagId := 5
            else if m_MagicArr[0][1] <> nil then
              m_nCurMagId := 1;
            if (Random(6) > 3) and (m_MagicArr[0][45] <> nil) then
              m_nCurMagId := 45;
            if (m_nCurMagId > 0) and (m_MagicArr[0][m_nCurMagId] <> nil) and (m_MagicArr[0][m_nCurMagId].btKey = 0) then begin
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][m_nCurMagId], m_TargetCret, boTrainOk);
              Exit;
            end;
          end else
            m_nTargetX := -1;
        end else begin                  //0619
          if (m_TargetCret.m_PEnvir = m_PEnvir) then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          else
            DelTargetCreat();
        end;
      end else begin
        //检测目标威胁性....
        if m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO] then begin
          //if m_TargetCret.m_WAbil.HP <= 600 then begin
          case m_TargetCret.m_btJob of
            0: begin                    //战士
                nPower := m_TargetCret.GetAttackPower(LoWord(m_TargetCret.m_WAbil.DC), SmallInt((HiWord(m_TargetCret.m_WAbil.DC) - LoWord(m_TargetCret.m_WAbil.DC))));
                nPower := GetHitStruckDamage(m_TargetCret, nPower);
                if (nPower = 0) or ((nPower < 9) and (m_WAbil.HP div 120 > nPower)) then begin
                  //SysMsg(format('%d %d', [m_WAbil.HP div 50, nPower]), c_Purple, t_Hint);
                  if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
                    m_dwHitTick := GetTickCount();
                    goto FFFF;
                  end;
                  Result := True;
                  Exit;
                end;
              end;
          end;
          //end;
        end else begin
          nPower := m_TargetCret.GetAttackPower(LoWord(m_TargetCret.m_WAbil.DC), SmallInt((HiWord(m_TargetCret.m_WAbil.DC) - LoWord(m_TargetCret.m_WAbil.DC))));
          nPower := GetHitStruckDamage(m_TargetCret, nPower);
          if (nPower = 0) or ((nPower < 9) and (m_WAbil.HP div 100 > nPower)) then begin
            //SysMsg(format('%d %d', [m_WAbil.HP div 35, nPower]), c_Purple, t_Hint);
            if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
              m_dwHitTick := GetTickCount();
              goto DDDD;
            end;
            Result := True;
            Exit;
          end;
        end;

        if (nAbsX <= 1) and (nAbsY <= 1) then begin
          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
            m_dwHitTick := GetTickCount();

            nTag := GetSelfRangeCount();
            if (nTag >= 4) then begin
              if (Random(12) = 0) and (m_MagicArr[0][24] <> nil) and (m_MagicArr[0][24].btKey = 0) then begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][24], m_TargetCret, boTrainOk);
                Exit;
              end;

              FFFF:                     //强攻...
              if (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and
                (m_MagicArr[0][10] <> nil) and
                (m_MagicArr[0][10].btKey = 0) and
                (Random(10) > 2) then begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then begin
                  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 8, nTX, nTY);
                  if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) >= 1 then begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := HeroDoSpell(m_MagicArr[0][10], m_TargetCret, boTrainOk);
                    if m_btMagPassTh > 0 then m_btMagPassTh := 0;
                    Exit;
                  end;
                end;
              end;

              DDDD:                     //强攻...
              m_nCurMagId := 0;         //群
              if Random(6) > 1 then begin
                if (m_MagicArr[0][58] <> nil) and (Random(5) > 1) then begin
                  m_nCurMagId := 58;
                end else if (m_MagicArr[0][33] <> nil) then
                  m_nCurMagId := 33;
              end else if (m_MagicArr[0][47] <> nil) then
                m_nCurMagId := 47;
              if (m_nCurMagId <= 0) and (m_MagicArr[0][23] <> nil) then
                m_nCurMagId := 23;
              if (m_nCurMagId > 0) and (m_MagicArr[0][m_nCurMagId] <> nil) and (m_MagicArr[0][m_nCurMagId].btKey = 0) then begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][m_nCurMagId], m_TargetCret, boTrainOk);
                Exit;
              end;
              m_nCurMagId := 0;         //单
              if m_MagicArr[0][11] <> nil then
                m_nCurMagId := 11
              else if m_MagicArr[0][5] <> nil then
                m_nCurMagId := 5
              else if m_MagicArr[0][1] <> nil then
                m_nCurMagId := 1;
              if (Random(6) > 3) and (m_MagicArr[0][45] <> nil) then
                m_nCurMagId := 45;
              if (m_nCurMagId > 0) and (m_MagicArr[0][m_nCurMagId] <> nil) and (m_MagicArr[0][m_nCurMagId].btKey = 0) then begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][m_nCurMagId], m_TargetCret, boTrainOk);
                Exit;
              end;
            end;
            if (m_MagicArr[0][8] <> nil) and (m_MagicArr[0][8].btKey = 0) and (m_Abil.Level > m_TargetCret.m_Abil.Level) then begin
              if m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO] then
                nCount := 1
              else
                nCount := 2 + Random(2);
              if nTag >= nCount then begin //抗拒比较少使用
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][8], m_TargetCret, boTrainOk);
                if Result then Inc(m_btMagPassTh, 1 + Random(2));
                Exit;
              end;
            end;
          end;
        end;

        if (m_TargetCret.m_PEnvir = m_PEnvir) then begin
          m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          GetBackPosition(nX, nY);
          nTag := 0;
          while (True) do begin
            if m_PEnvir.CanWalk(nX, nY, False) then Break;
            Inc(m_btDirection);
            m_btDirection := m_btDirection mod 8;
            GetBackPosition(nX, nY);
            Inc(nTag);
            if nTag > 8 then Break;
          end;
          if m_PEnvir.CanWalk(nX, nY, False) then begin
            GetBackPosition2(nTX, nTY);
            if m_PEnvir.CanWalk(nTX, nTY, False) then begin //run away...
              nX := nTX;
              nY := nTY;
            end;
          end else if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin //强攻...
            m_dwHitTick := GetTickCount();
            nTag := 1;
            goto DDDD;
          end;
          //labLoop2:
          if ((abs(nX - m_Master.m_nCurrX) < 10) and (abs(nY - m_Master.m_nCurrY) < 10)) then begin
            SetTargetXY(nX, nY);
          end else
            DelTargetCreat();
        end else
          DelTargetCreat();
      end;
    end;
  end else if m_TargetCret <> nil then begin
    if GetAttackDir(m_TargetCret, btDir) then begin
      if g_Config.boCalcHeroHitSpeed then
        dwAttackTime := _MAX(350, Integer(m_nNextHitTime) - (m_nHitSpeed * g_Config.ClientConf.btItemSpeed div 2))
      else
        dwAttackTime := m_nNextHitTime;
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, btDir);
        BreakHolySeizeMode();
      end;
      Result := True;
    end else if m_TargetCret.m_PEnvir = m_PEnvir then
      SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
    else
      DelTargetCreat();
  end;
end;

function THeroObject.__Taos__HeroAttackTarget(): Boolean;
var
  boTrainOk                 : Boolean;
  btDir                     : byte;
  i, ii, n, nX, nY, nTX, nTY, nTag, nAmuletIdx: Integer;
  UserMagic                 : pTUserMagic;
  dwAttackTime, sskilltick  : LongWord;
  StdItem                   : pTStdItem;
  nAbsX, nAbsY, nPower      : Integer;
  wMagicId                  : Word;
label
  labWidAttack {, NorAttack};

  function AutoChagnePoison(nType: Integer): Boolean;
  begin
    Result := True;
    case nType of
      1: if not AutoTakeOnItem(U_ARMRINGL, '黄色药粉(大量)') and not AutoTakeOnItem(U_ARMRINGL, '黄色药粉(中量)') and not AutoTakeOnItem(U_ARMRINGL, '黄色药粉(少量)') then begin
          if GetTickCount - m_dwHintMsgTick > 30 * 1000 then begin
            m_dwHintMsgTick := GetTickCount();
            SysMsg('包裹或身上没有黄色药粉！', c_Purple, t_Hint);
          end;
        end else Result := False;
      2: if not AutoTakeOnItem(U_ARMRINGL, '灰色药粉(大量)') and not AutoTakeOnItem(U_ARMRINGL, '灰色药粉(中量)') and not AutoTakeOnItem(U_ARMRINGL, '灰色药粉(少量)') then begin
          if GetTickCount - m_dwHintMsgTick > 30 * 1000 then begin
            m_dwHintMsgTick := GetTickCount();
            SysMsg('包裹或身上没有灰色药粉！', c_Purple, t_Hint);
          end;
        end else Result := False;
    end;
  end;
begin
  Result := False;
  boTrainOk := False;

  if (m_TargetCret <> nil) and Sidestep() then begin
    if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) then begin
      //GetAdvPosition(nX, nY);
      GetBackPositionEx(nX, nY);
      if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(nX - m_Master.m_nCurrX) < 12) and (abs(nY - m_Master.m_nCurrY) < 12)) then
        SetTargetXY(nX, nY)
      else
        DelTargetCreat();
    end;
    Exit;
  end;

  if (m_Abil.Level < 18)
    or (((m_MagicArr[0][4] <> nil) and (m_MagicArr[0][4].btKey = 0)) and
    m_boNorAttack and
    (m_TargetCret <> nil) and
    (m_TargetCret.m_Abil.Level + 5 < m_Abil.Level)) then begin

    if (Integer(GetTickCount - m_dwSpellTick)) > (m_nNextHitTime * 3) then begin
      m_dwSpellTick := GetTickCount();
      if (m_MagicArr[0][2] <> nil) and (m_MagicArr[0][2].btKey = 0) then begin
        if m_Master <> nil then begin
          if (abs(m_nCurrX - m_Master.m_nCurrX) <= g_Config.nMagicAttackRage)
            and (abs(m_nCurrY - m_Master.m_nCurrY) <= g_Config.nMagicAttackRage) then begin
            if (Round(m_Master.m_WAbil.HP / m_Master.m_WAbil.MaxHP * 100) <= 80) then begin
              Result := HeroDoSpell(m_MagicArr[0][2], m_Master, boTrainOk);
              m_dwHitTick := GetTickCount();
              Exit;
            end;
          end;
        end;
        if (Round(m_WAbil.HP / m_WAbil.MaxHP * 100) <= 80) then begin
          Result := HeroDoSpell(m_MagicArr[0][2], self, boTrainOk);
          m_dwHitTick := GetTickCount();
          Exit;
        end;
      end;
    end;
    //NorAttack:
    if m_TargetCret <> nil then begin
      if GetAttackDir(m_TargetCret, btDir) then begin
        if g_Config.boCalcHeroHitSpeed then
          dwAttackTime := _MAX(350, Integer(m_nNextHitTime) - (m_nHitSpeed * g_Config.ClientConf.btItemSpeed div 2))
        else
          dwAttackTime := m_nNextHitTime;
        if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          Attack(m_TargetCret, btDir);
          BreakHolySeizeMode();
          if m_boNorAttack then begin
            //if ((m_MagicArr[0][13] = nil) or (m_MagicArr[0][13].btKey <> 0)) and ((m_MagicArr[0][57] = nil) or (m_MagicArr[0][57].btKey <> 0)) then begin
            //if Random(10) > 3 then
            m_boNorAttack := False;
            //end;
          end;
        end;
        Result := True;
      end else if m_TargetCret.m_PEnvir = m_PEnvir then
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
      else
        DelTargetCreat();
    end;
  end else {if (m_Abil.Level >= 18) then} begin
    if (Integer(GetTickCount - m_dwSpellTick)) > (m_nNextHitTime * 3) then begin
      m_dwSpellTick := GetTickCount();
      if (m_Master <> nil) and (m_SlaveList.Count <= 0) then begin
        UserMagic := nil;
        if (m_MagicArr[0][55] <> nil) and (m_MagicArr[0][55].btKey = 0) then
          UserMagic := m_MagicArr[0][55]
        else if (m_MagicArr[0][30] <> nil) and (m_MagicArr[0][30].btKey = 0) then
          UserMagic := m_MagicArr[0][30]
        else if (m_MagicArr[0][17] <> nil) and (m_MagicArr[0][17].btKey = 0) then
          UserMagic := m_MagicArr[0][17];
        if (UserMagic <> nil) then begin
          Result := HeroDoSpell(UserMagic, self, boTrainOk);
          m_dwHitTick := GetTickCount();
          Exit;
        end;
      end;

      //MAGDEFENCEUP
      if (m_MagicArr[0][14] <> nil) and (m_MagicArr[0][14].btKey = 0) then begin
        if m_Master <> nil then begin
          if (m_Master.m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then begin
            Result := HeroDoSpell(m_MagicArr[0][14], m_Master, boTrainOk);
            m_dwHitTick := GetTickCount();
            Exit;
          end;
        end;
        if (m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then begin
          Result := HeroDoSpell(m_MagicArr[0][14], self, boTrainOk);
          m_dwHitTick := GetTickCount();
          Exit;
        end;
      end;
      //DEFENCEUP
      if (m_MagicArr[0][15] <> nil) and (m_MagicArr[0][15].btKey = 0) then begin
        if m_Master <> nil then begin
          if (m_Master.m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) then begin
            Result := HeroDoSpell(m_MagicArr[0][15], m_Master, boTrainOk);
            m_dwHitTick := GetTickCount();
            Exit;
          end;
        end;
        if (m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) then begin
          Result := HeroDoSpell(m_MagicArr[0][15], self, boTrainOk);
          m_dwHitTick := GetTickCount();
          Exit;
        end;
      end;
      //Healling
      if (m_MagicArr[0][2] <> nil) and (m_MagicArr[0][2].btKey = 0) then begin
        if m_Master <> nil then begin
          if (abs(m_nCurrX - m_Master.m_nCurrX) <= g_Config.nMagicAttackRage)
            and (abs(m_nCurrY - m_Master.m_nCurrY) <= g_Config.nMagicAttackRage) then begin
            if (Round(m_Master.m_WAbil.HP / m_Master.m_WAbil.MaxHP * 100) <= 80) then begin
              Result := HeroDoSpell(m_MagicArr[0][2], m_Master, boTrainOk);
              m_dwHitTick := GetTickCount();
              Exit;
            end;
          end;
        end;
        if (Round(m_WAbil.HP / m_WAbil.MaxHP * 100) <= 80) then begin
          Result := HeroDoSpell(m_MagicArr[0][2], self, boTrainOk);
          m_dwHitTick := GetTickCount();
          Exit;
        end;
        if m_SlaveList.Count > 0 then begin
          for ii := 0 to m_SlaveList.Count - 1 do begin
            if (abs(m_nCurrX - TBaseObject(m_SlaveList.Items[ii]).m_nCurrX) <= g_Config.nMagicAttackRage)
              and (abs(m_nCurrY - TBaseObject(m_SlaveList.Items[ii]).m_nCurrY) <= g_Config.nMagicAttackRage) then begin
              if (Round(TBaseObject(m_SlaveList.Items[ii]).m_WAbil.HP / TBaseObject(m_SlaveList.Items[ii]).m_WAbil.MaxHP * 100) <= 60) then begin
                Result := HeroDoSpell(m_MagicArr[0][2], TBaseObject(m_SlaveList.Items[ii]), boTrainOk);
                m_dwHitTick := GetTickCount();
                Exit;
              end;
            end;
          end;
        end;
      end;
    end;

    if m_TargetCret = nil then begin
      if Integer(GetTickCount - m_dwHitTick) > (m_nNextHitTime) then begin
        m_dwHitTick := GetTickCount();
        //UNAMYOUNSUL
        if (m_MagicArr[0][34] <> nil) and (m_MagicArr[0][34].btKey = 0) then begin
          if m_Master <> nil then begin
            if (m_Master.m_wStatusTimeArr[POISON_DECHEALTH] <> 0) or (m_Master.m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0) or (m_Master.m_wStatusTimeArr[POISON_STONE] <> 0) then begin
              Result := HeroDoSpell(m_MagicArr[0][34], m_Master, boTrainOk);
              m_dwSpellTick := GetTickCount();
              Exit;
            end;
          end;
          if (m_wStatusTimeArr[POISON_DECHEALTH] <> 0) or (m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0) or (m_wStatusTimeArr[POISON_STONE] <> 0) then begin
            Result := HeroDoSpell(m_MagicArr[0][34], self, boTrainOk);
            m_dwSpellTick := GetTickCount();
            Exit;
          end;
        end;
        //BigHealling
        if (m_MagicArr[0][29] <> nil) and (m_MagicArr[0][29].btKey = 0) then begin
          if m_Master <> nil then begin
            if (abs(m_nCurrX - m_Master.m_nCurrX) <= g_Config.nMagicAttackRage)
              and (abs(m_nCurrY - m_Master.m_nCurrY) <= g_Config.nMagicAttackRage) then begin
              if (Round(m_Master.m_WAbil.HP / m_Master.m_WAbil.MaxHP * 100) <= 80) and (Round(m_WAbil.HP / m_WAbil.MaxHP * 100) <= 80) then begin
                Result := HeroDoSpell(m_MagicArr[0][29], self, boTrainOk);
                Exit;
              end else
                //m_boBigHealling := False;
            end;
          end;
        end;
      end;
    end else begin

      // ========= series skill =========
      if ProperTarget() then begin
        if (m_nInPowerLevel > 0) and
          (m_nInPowerPoint > 20) and
          (m_btReadySeriesSkill = 1) and
          (m_btSeriesSkillSetpMax in [1..3]) then begin

          m_btReadySeriesSkill := 2;    //fired ...
          m_dwReadySeriesSkillTick := GetTickCount;

          m_sTargetCret := m_TargetCret;
          m_btSeriesSkillSetpCur := 0;
          m_nLastSSkillID := 0;
        end;

        if (m_btReadySeriesSkill = 2) and (m_sTargetCret <> nil) and not m_sTargetCret.m_boDeath and (m_btSeriesSkillSetpCur < m_btSeriesSkillSetpMax) then begin

          wMagicId := m_SeriesSkillArr2[m_btSeriesSkillSetpCur].wMagicId;
          UserMagic := m_MagicArr[0][wMagicId];
          if (UserMagic <> nil) then begin
            case wMagicId of
              108..111: begin
                  nAbsX := abs(m_nCurrX - m_sTargetCret.m_nCurrX);
                  nAbsY := abs(m_nCurrY - m_sTargetCret.m_nCurrY);
                  if (nAbsX <= g_Config.nMagicAttackRage) and (nAbsY <= g_Config.nMagicAttackRage) then begin
                    sskilltick := 700;
                    case m_nLastSSkillID of
                      108: sskilltick := 06 * 95 - 020;
                      109: sskilltick := 12 * 78 - 050;
                      110: sskilltick := 12 * 78 - 045;
                      111: sskilltick := 14 * 65 - 052;
                    end;
                    //SysMsg(format('%d %d', [m_nLastSSkillID, sskilltick]), c_Red, t_Hint);
                    if Integer(GetTickCount - m_dwHitTick) > sskilltick then begin
                      m_dwHitTick := GetTickCount();
                      m_dwTargetFocusTick := GetTickCount();
                      m_dwWalkTick := GetTickCount() + 300;
                      m_dwSpellTick := GetTickCount() + 800;
                      m_dwHeroSetTargetTick := GetTickCount + 300;
                      Result := HeroDoSpell(UserMagic, m_sTargetCret, boTrainOk);
                      m_nLastSSkillID := wMagicId;
                      Inc(m_btSeriesSkillSetpCur);
                      if (m_btSeriesSkillSetpCur >= m_btSeriesSkillSetpMax) or (m_sTargetCret = nil) or m_sTargetCret.m_boDeath then begin
                        m_btReadySeriesSkill := 0;
                        m_nLastSSkillID := 0;
                        m_dwHitTick := GetTickCount() + 200;
                      end;
                      Exit;
                    end else begin
                      m_dwTargetFocusTick := GetTickCount();
                      m_dwWalkTick := GetTickCount() + 300;
                      m_dwSpellTick := GetTickCount() + 800;
                      m_dwHeroSetTargetTick := GetTickCount + 300;
                      m_nTargetX := -1;
                      Exit;
                    end;
                  end else begin
                    if (m_btSeriesSkillSetpCur > 0) and (m_sTargetCret <> nil) then begin
                      m_btReadySeriesSkill := 0;
                      m_nLastSSkillID := 0;
                    end;
                    if m_sTargetCret.m_PEnvir = m_PEnvir then
                      SetTargetXY(m_sTargetCret.m_nCurrX, m_sTargetCret.m_nCurrY);
                  end;
                end;
            end;
          end;
        end;
      end;

      if g_Config.boAllowJointAttack and m_boJointAttackReady and IsHero then begin
        if g_nRegStatus^ = 1 then begin
          if not m_Master.m_boGhost and not m_Master.m_boDeath and not m_Master.m_boFixedHideMode and not m_Master.m_boStoneMode and (m_Master.m_wStatusTimeArr[POISON_STONE] = 0) and (m_Master.m_wStatusTimeArr[POISON_PURPLE] = 0) then begin
            if (m_TargetCret = m_Master.m_TargetCret) then begin
              if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= g_Config.nMagicAttackRage) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= g_Config.nMagicAttackRage) and
                (abs(m_Master.m_nCurrX - m_TargetCret.m_nCurrX) <= g_Config.nMagicAttackRage) and (abs(m_Master.m_nCurrY - m_TargetCret.m_nCurrY) <= g_Config.nMagicAttackRage) then begin
                //if TPlayObject(m_Master).CanNextAction() then begin
                if GetTickCount - m_dwJointHitTick > 200 then begin
                  m_dwJointHitTick := GetTickCount();
                  case m_Master.m_btJob of
                    0: if m_MagicArr[0][61] <> nil then begin
                        if (abs(m_Master.m_nCurrX - m_TargetCret.m_nCurrX) < 4) and (abs(m_Master.m_nCurrY - m_TargetCret.m_nCurrY) < 4) then begin
                          ResetJointAttackEnergy;
                          m_Master.m_btDirection := GetNextDirection(m_Master.m_nCurrX, m_Master.m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                          TPlayObject(self).SendRefMsg(RM_SPELL, 573, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 51, '');
                          TPlayObject(m_Master).SendRefMsg(RM_JOINTATTACK, 62, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master.m_btDirection, '');
                          MagicManager.Mag61(TPlayObject(m_Master), m_MagicArr[0][61], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                          TPlayObject(self).SendRefMsg(RM_MAGICFIRE, 0, 15623, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                          TrainingSkill(m_MagicArr[0][61]);
                          TrainingSkill(m_MagicArr[1][61]);
                          m_dwTargetFocusTick := GetTickCount();
                          m_dwHitTick := GetTickCount();
                          Result := True;
                          Exit;
                        end;
                      end;
                    1: if m_MagicArr[0][64] <> nil then begin
                        ResetJointAttackEnergy;
                        TPlayObject(m_Master).SendRefMsg(RM_SPELL, 320, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 54, 'R');
                        TPlayObject(self).SendRefMsg(RM_SPELL, 576, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 54, '');
                        MagicManager.Mag64(TPlayObject(m_Master), m_MagicArr[0][64], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                        Result := MagicManager.Mag64(TPlayObject(self), m_MagicArr[0][64], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                        TPlayObject(m_Master).SendRefMsg(RM_MAGICFIRE, 0, 16391, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                        TPlayObject(self).SendRefMsg(RM_MAGICFIRE, 0, 16391, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                        if Result {and (m_MagicArr[0][64].btLevel < 3)} then begin
                          TrainingSkill(m_MagicArr[0][64]);
                          TrainingSkill(m_MagicArr[1][64]);
                        end;
                        m_dwTargetFocusTick := GetTickCount();
                        m_dwHitTick := GetTickCount();
                        Exit;
                      end;
                    2: if (m_MagicArr[0][63] <> nil) then begin
                        //if (m_Abil.Level >= 43) then begin
                        ResetJointAttackEnergy;
                        TPlayObject(m_Master).SendRefMsg(RM_SPELL, 575, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 53, 'R');
                        TPlayObject(self).SendRefMsg(RM_SPELL, 575, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 0, 53, '');
                        MagicManager.Mag63(TPlayObject(m_Master), m_MagicArr[0][63], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                        Result := MagicManager.Mag63(TPlayObject(self), m_MagicArr[0][63], m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
                        TPlayObject(m_Master).SendRefMsg(RM_MAGICFIRE, 0, MakeWord(m_MagicArr[0][63].MagicInfo.btEffectType, m_MagicArr[0][63].MagicInfo.btEffect), MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                        TPlayObject(self).SendRefMsg(RM_MAGICFIRE, 0, MakeWord(m_MagicArr[0][63].MagicInfo.btEffectType, m_MagicArr[0][63].MagicInfo.btEffect), MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), Integer(m_TargetCret), '');
                        if Result {and (m_MagicArr[0][63].btLevel < 3)} then begin
                          TrainingSkill(m_MagicArr[0][63]);
                          TrainingSkill(m_MagicArr[1][63]);
                        end;
                        m_dwTargetFocusTick := GetTickCount();
                        m_dwHitTick := GetTickCount();
                        Exit;
                        {end else begin
                          SysMsg('必须在43级以上才能释放合击', c_Red, t_Hint);
                          m_dwTargetFocusTick := GetTickCount();
                          m_dwHitTick := GetTickCount();
                          Exit;
                        end;}
                      end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;

      if (m_MagicArr[0][75] <> nil) and (m_MagicArr[0][75].btKey = 0) and (m_nMagShieldHP <= 0) then begin
        if GetTickCount - m_dwUnionHitShieldTick > 15 * 1000 then begin
          m_dwUnionHitShieldTick := GetTickCount;
          m_dwTargetFocusTick := GetTickCount();
          Result := HeroDoSpell(m_MagicArr[0][75], m_TargetCret, boTrainOk);
          Exit;
        end;
      end;

      nAbsX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
      nAbsY := abs(m_nCurrY - m_TargetCret.m_nCurrY);

      //taos
      if (m_MagicArr[0][114] <> nil) and (m_MagicArr[0][114].btKey = 0) and (nAbsX <= 6) and (nAbsY <= 6) and (GetTickCount - m_dwLatestSmiteWideTick2 > g_Config.nSmiteWideHitSkillInvTime) then begin
        if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then begin
          m_dwHitTick := GetTickCount();
          m_dwWalkTick := GetTickCount();
          m_dwLatestSmiteWideTick2 := GetTickCount;
          btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          m_boSmiteWideSkill2 := True;
          m_dwTargetFocusTick := GetTickCount();
          AttackDir(m_TargetCret, 23, btDir);
          Result := True;
          Exit;
        end;
      end;

      if (nAbsX > 2) or (nAbsY > 2) then begin
        if (nAbsX <= g_Config.nMagicAttackRage) and (nAbsY <= g_Config.nMagicAttackRage) then begin
          if Integer(GetTickCount - m_dwHitTick) > (m_nNextHitTime) then begin
            m_dwHitTick := GetTickCount();

            labWidAttack:
            //DoubluSC
            if (m_MagicArr[0][50] <> nil) and (m_MagicArr[0][50].btKey = 0) then begin
              if m_wStatusArrValue[2] <= 0 then begin
                if GetTickCount - m_dwDoubleScTick > 5000 then begin
                  m_dwTargetFocusTick := GetTickCount();
                  Result := HeroDoSpell(m_MagicArr[0][50], self, boTrainOk);
                  m_dwSpellTick := GetTickCount();
                  Exit;
                end;
              end;
            end;

            //DECHEALTH & DAMAGEARMOR
            if ((m_MagicArr[0][6] <> nil) and (m_MagicArr[0][6].btKey = 0)) or ((m_MagicArr[0][38] <> nil) and (m_MagicArr[0][38].btKey = 0)) then begin
              if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] <= 0) then begin
                if g_Config.boHeroNeedAmulet then begin
                  if CheckAmulet({TPlayObject(self),}1, 2, nAmuletIdx) then begin
                    StdItem := UserEngine.GetStdItem(m_UseItems[nAmuletIdx].wIndex);
                    if StdItem <> nil then begin
                      if (StdItem.Shape = 1) then begin
                        if (GetTagXYRangeCount(0, 1) > 2) then begin
                          if (m_MagicArr[0][38] <> nil) then begin
                            Result := HeroDoSpell(m_MagicArr[0][38], m_TargetCret, boTrainOk);
                            if g_Config.boTaosHeroAutoChangePoison and boTrainOk then
                              AutoChagnePoison(1);
                            m_dwTargetFocusTick := GetTickCount();
                            if Result then begin
                              m_dwSpellTick := GetTickCount();
                              Exit;
                            end;
                          end;
                        end else begin
                          if (m_MagicArr[0][6] <> nil) then begin
                            Result := HeroDoSpell(m_MagicArr[0][6], m_TargetCret, boTrainOk);
                            if g_Config.boTaosHeroAutoChangePoison and boTrainOk then
                              AutoChagnePoison(1);
                            m_dwTargetFocusTick := GetTickCount();
                            if Result then begin
                              m_dwSpellTick := GetTickCount();
                              Exit;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end else begin
                  if m_btUseAmulet = 1 then begin
                    if (GetTagXYRangeCount(0, 1) > 2) then begin
                      if (m_MagicArr[0][38] <> nil) then begin
                        Result := HeroDoSpell(m_MagicArr[0][38], m_TargetCret, boTrainOk);
                        if boTrainOk then m_btUseAmulet := 2;
                        m_dwTargetFocusTick := GetTickCount();
                        if Result then begin
                          m_dwSpellTick := GetTickCount();
                          Exit;
                        end;
                      end;
                    end else begin
                      if (m_MagicArr[0][6] <> nil) then begin
                        Result := HeroDoSpell(m_MagicArr[0][6], m_TargetCret, boTrainOk);
                        if boTrainOk then m_btUseAmulet := 2;
                        m_dwTargetFocusTick := GetTickCount();
                        if Result then begin
                          m_dwSpellTick := GetTickCount();
                          Exit;
                        end;
                      end;
                    end;
                  end;
                end;
              end;

              if (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] <= 0) then begin
                if g_Config.boHeroNeedAmulet then begin
                  if not CheckAmulet({TPlayObject(self),}1, 2, nAmuletIdx) then
                    AutoChagnePoison(1);
                  if CheckAmulet({TPlayObject(self),}1, 2, nAmuletIdx) then begin
                    StdItem := UserEngine.GetStdItem(m_UseItems[nAmuletIdx].wIndex);
                    if StdItem <> nil then begin
                      if (StdItem.Shape = 2) then begin
                        if (GetTagXYRangeCount(0, 1) > 2) then begin
                          if (m_MagicArr[0][38] <> nil) then begin
                            Result := HeroDoSpell(m_MagicArr[0][38], m_TargetCret, boTrainOk);
                            if g_Config.boTaosHeroAutoChangePoison and boTrainOk then
                              AutoChagnePoison(2);
                            m_dwTargetFocusTick := GetTickCount();
                            if Result then begin
                              m_dwSpellTick := GetTickCount();
                              Exit;
                            end;
                          end;
                        end else begin
                          if (m_MagicArr[0][6] <> nil) then begin
                            Result := HeroDoSpell(m_MagicArr[0][6], m_TargetCret, boTrainOk);
                            if g_Config.boTaosHeroAutoChangePoison and boTrainOk then
                              AutoChagnePoison(2);
                            m_dwTargetFocusTick := GetTickCount();
                            if Result then begin
                              m_dwSpellTick := GetTickCount();
                              Exit;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end else begin
                  if m_btUseAmulet = 2 then begin
                    if (GetTagXYRangeCount(0, 1) > 2) then begin
                      if (m_MagicArr[0][38] <> nil) then begin
                        Result := HeroDoSpell(m_MagicArr[0][38], m_TargetCret, boTrainOk);
                        if boTrainOk then m_btUseAmulet := 1;
                        m_dwTargetFocusTick := GetTickCount();
                        if Result then begin
                          m_dwSpellTick := GetTickCount();
                          Exit;
                        end;
                      end;
                    end else begin
                      if (m_MagicArr[0][6] <> nil) then begin
                        Result := HeroDoSpell(m_MagicArr[0][6], m_TargetCret, boTrainOk);
                        if boTrainOk then m_btUseAmulet := 1;
                        m_dwTargetFocusTick := GetTickCount();
                        if Result then begin
                          m_dwSpellTick := GetTickCount();
                          Exit;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;

            if (m_MagicArr[0][18] <> nil) and (m_MagicArr[0][18].btKey = 0) and (m_wStatusTimeArr[STATE_TRANSPARENT] <= 0) and (Random(10) = 0) then begin
              if (GetTagXYRangeCount(1, 7, 2) >= 8) then begin
                m_dwTargetFocusTick := GetTickCount();
                HeroDoSpell(m_MagicArr[0][18], self, boTrainOk);
                Result := True;
                Exit;
              end;
            end;

            if ((m_MagicArr[0][13] <> nil) and (m_MagicArr[0][13].btKey = 0)) or ((m_MagicArr[0][57] <> nil) and (m_MagicArr[0][57].btKey = 0)) then begin
              if (m_MagicArr[0][57] <> nil) and (m_MagicArr[0][57].btKey = 0) and (((Round(m_WAbil.HP / m_WAbil.MaxHP * 100) < 80) and (Random(100 - Round(m_WAbil.HP / m_WAbil.MaxHP * 100)) > 5)) or (Random(10) > 6)) then begin
                m_dwTargetFocusTick := GetTickCount();
                if m_MagicArr[0][57] <> nil then begin
                  HeroDoSpell(m_MagicArr[0][57], m_TargetCret, boTrainOk);
                  if not m_boNorAttack and ((m_MagicArr[0][4] <> nil) and (m_MagicArr[0][4].btKey = 0)) and (m_TargetCret.m_Abil.Level + 5 < m_Abil.Level) then
                    if GetAttackDir(m_TargetCret, btDir) and (Random(10) > 2) then begin
                      m_dwHitTick := 0;
                      m_boNorAttack := True;
                    end;
                  Result := True;
                  Exit;
                end;
              end;
              if (m_MagicArr[0][13] <> nil) and (m_MagicArr[0][13].btKey = 0) {and MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret)} then begin
                m_dwTargetFocusTick := GetTickCount();
                HeroDoSpell(m_MagicArr[0][13], m_TargetCret, boTrainOk);
                if not m_boNorAttack and ((m_MagicArr[0][4] <> nil) and (m_MagicArr[0][4].btKey = 0)) and (m_TargetCret.m_Abil.Level + 5 < m_Abil.Level) then
                  if GetAttackDir(m_TargetCret, btDir) and (Random(10) > 2) then begin
                    m_dwHitTick := 0;
                    m_boNorAttack := True;
                  end;
                Result := True;
                Exit;
              end;
            end;
          end else
            m_nTargetX := -1;
        end else begin
          if (m_TargetCret.m_PEnvir = m_PEnvir) then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          else
            DelTargetCreat();
        end;
      end else begin
        //检测目标威胁性....

        if m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO] then begin
          //if m_TargetCret.m_WAbil.HP <= 600 then begin
          case m_TargetCret.m_btJob of
            0: begin                    //战士
                nPower := m_TargetCret.GetAttackPower(LoWord(m_TargetCret.m_WAbil.DC), SmallInt((HiWord(m_TargetCret.m_WAbil.DC) - LoWord(m_TargetCret.m_WAbil.DC))));
                nPower := GetHitStruckDamage(m_TargetCret, nPower);
                if (nPower = 0) or ((nPower < 15) and (m_WAbil.HP div 120 > nPower)) then begin
                  //SysMsg(format('%d %d', [m_WAbil.HP div 50, nPower]), c_Purple, t_Hint);
                  if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
                    m_dwHitTick := GetTickCount();
                    goto labWidAttack;
                  end;
                  Result := True;
                  Exit;
                end;
              end;
            //end;
          end;
        end else begin
          nPower := m_TargetCret.GetAttackPower(LoWord(m_TargetCret.m_WAbil.DC), SmallInt((HiWord(m_TargetCret.m_WAbil.DC) - LoWord(m_TargetCret.m_WAbil.DC))));
          nPower := GetHitStruckDamage(m_TargetCret, nPower);
          if (nPower = 0) or ((nPower < 15) and (m_WAbil.HP div 100 > nPower)) then begin
            //SysMsg(format('%d %d', [m_WAbil.HP div 35, nPower]), c_Purple, t_Hint);
            if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
              m_dwHitTick := GetTickCount();
              goto labWidAttack;
            end;
            Result := True;
            Exit;
          end;
        end;

        if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 1) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 1)) then begin
          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
            m_dwHitTick := GetTickCount();
            //nTag := GetTagXYRangeCount(1, 1, 1);
            nTag := GetSelfRangeCount();
            if (nTag >= 5) then begin   //怪太多,强攻解围...
              goto labWidAttack;
            end;
            if (m_MagicArr[0][48] <> nil) and (m_MagicArr[0][48].btKey = 0) and (m_Abil.Level > m_TargetCret.m_Abil.Level) and ((nTag >= 2) or (m_TargetCret.m_btRaceServer = RC_PLAYOBJECT)) then begin //抗拒...
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][48], m_TargetCret, boTrainOk);
              m_dwSpellTick := GetTickCount();
              Exit;
            end;
          end;
        end;

        if (m_TargetCret.m_PEnvir = m_PEnvir) then begin
          m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);

          GetBackPosition(nX, nY);
          nTag := 0;
          while (True) do begin
            if m_PEnvir.CanWalk(nX, nY, False) then Break;
            Inc(m_btDirection);
            m_btDirection := m_btDirection mod 8;
            GetBackPosition(nX, nY);
            Inc(nTag);
            if nTag > 8 then Break;
          end;
          if m_PEnvir.CanWalk(nX, nY, False) then begin
            GetBackPosition2(nTX, nTY);
            if m_PEnvir.CanWalk(nTX, nTY, False) then begin //run away...
              nX := nTX;
              nY := nTY;
            end;
          end else if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin //强攻...
            m_dwHitTick := GetTickCount;
            goto labWidAttack;
          end;
          if ((abs(nX - m_Master.m_nCurrX) < 10) and (abs(nY - m_Master.m_nCurrY) < 10)) then begin
            SetTargetXY(nX, nY);
          end else
            DelTargetCreat();
        end else
          DelTargetCreat();
      end;
    end;
  end;
end;

function THeroObject.AttackTarget(): Boolean;
var
  UserMagic                 : pTUserMagic;
begin
  Result := False;
  case m_btJob of
    0: Result := __Warr__HeroAttackTarget;
    1: Result := __Wiza__HeroAttackTarget;
    2: Result := __Taos__HeroAttackTarget;
  end;
  if Result then begin
    m_nTargetX := -1;
    m_nTargetY := -1;
  end;
end;

function THeroObject.Operate(ProcessMsg: pTProcessMessage): Boolean;
var
  OAbility                  : TOAbility;
  Ability                   : TAbility;
begin
  Result := False;
  case ProcessMsg.wIdent of
    {RM_INTERNALPOWER: if IsHero then begin
        InternalPowerPointChanged();
      end;}
    RM_SERIESSKILLARR: if IsHero then begin
        //TMessageBodyW
        TPlayObject(m_Master).m_DefMsg := MakeDefaultMsg(SM_SERIESSKILLARR, MakeLong(m_SeriesSkillArr[0], m_SeriesSkillArr[1]), m_SeriesSkillArr[2], 0, 1);
        TPlayObject(m_Master).SendSocket(@TPlayObject(m_Master).m_DefMsg, EncodeBuffer(@m_VenationInfos, SizeOf(m_VenationInfos)));
      end;
    RM_MAGIC_MAXLV: if IsHero then begin
        TPlayObject(m_Master).SendDefMessage(SM_MAGIC_MAXLV, MakeLong(ProcessMsg.nParam1, ProcessMsg.wParam), ProcessMsg.nParam2, 0, 1, '');
      end;
    RM_COUNTERITEMCHANGE: if IsHero then begin
        ServerSendItemCountChanged(ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.nParam3, ProcessMsg.sMsg);
      end;
    RM_ABILITY: begin
        if IsHero and not g_bIsHookDll^ then begin
          TPlayObject(m_Master).m_DefMsg := MakeDefaultMsg(SM_HEROABILITY, m_nGold, MakeWord(m_btJob, m_nInPowerLevel), 0, m_btCreditPoint);
          if m_Master.m_wClientType = 45 then begin
            TPlayObject(self).GetOldAbil(OAbility);
            TPlayObject(m_Master).SendSocket(@TPlayObject(m_Master).m_DefMsg, EncodeBuffer(@OAbility, SizeOf(TOAbility)));
          end else
            TPlayObject(m_Master).SendSocket(@TPlayObject(m_Master).m_DefMsg, EncodeBuffer(@TPlayObject(self).m_WAbil, SizeOf(TAbility)));
          Result := True;
        end;
      end;
    RM_SUBABILITY: if IsHero then begin
        TPlayObject(m_Master).SendDefMessage(SM_HEROSUBABILITY, MakeLong(MakeWord(m_nantiMagic, m_IPRecoverRate), MakeWord(m_AddDamage, m_DecDamage)),
          MakeWord(m_btHitPoint, m_btSpeedPoint), MakeWord(m_btAntiPoison, m_nPoisonRecover), MakeWord(m_nHealthRecover, m_nSpellRecover), '');
        Result := True;
      end;
    RM_SENDDELITEMLIST: if IsHero then begin
        TPlayObject(self).SendDelItemList(TStringList(ProcessMsg.nParam1));
        TStringList(ProcessMsg.nParam1).Free;
        Result := True;
      end;
    RM_MAGIC_LVEXP: if IsHero then begin
        TPlayObject(m_Master).SendDefMessage(SM_HEROMAGIC_LVEXP,
          MakeLong(ProcessMsg.nParam1, ProcessMsg.wParam),
          ProcessMsg.nParam2,
          LoWord(ProcessMsg.nParam3),
          HiWord(ProcessMsg.nParam3),
          '');
        Result := True;
      end;
    RM_DURACHANGE: if IsHero then begin
        TPlayObject(m_Master).SendDefMessage(SM_HERODURACHANGE,
          ProcessMsg.nParam1,
          ProcessMsg.wParam,
          LoWord(ProcessMsg.nParam2),
          HiWord(ProcessMsg.nParam2),
          '');
        Result := True;
      end;
    RM_LAMPCHANGEDURA: if IsHero then begin
        TPlayObject(m_Master).SendDefMessage(SM_HEROLAMPCHANGEDURA,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
        Result := True;
      end;
  else
    Result := inherited Operate(ProcessMsg);
  end;
end;

end.

