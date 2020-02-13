unit ObjectHeroMon;

interface

uses
  Windows, Classes, SysUtils, Grobal2, ObjBase;

type
  THeroObjectMon = class(TAnimalObject)
    m_boNextDir: Boolean;
    m_btDirection2: ShortInt;
    m_btDirection3: ShortInt;

    m_boLAT: Boolean;
    m_boDupMode: Boolean;
    m_boRunReady: Boolean;
    m_btMagPassTh: byte;
    m_dwThinkTick: LongWord;
    m_dwSpellTick: LongWord;
    m_dwMagStickTick: LongWord;
    m_dwStartWalkTick: LongWord;
    m_nLongAttackCount: Integer;
  private
    function Think(): Boolean;
    procedure TrainingSkill(Magic: pTUserMagic);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run(); override;
    procedure OnCancelTarget();
    function AttackTarget(): Boolean; virtual;
    function __Wiza__HeroAttackTarget(): Boolean;
    function __Warr__HeroAttackTarget(): Boolean;
    function __Taos__HeroAttackTarget(): Boolean;
  end;

implementation

uses UsrEngn, M2Share, Event, Magic, Envir, HUtil32, EDcode;

constructor THeroObjectMon.Create();
begin
  inherited;
  m_boNextDir := False;
  m_btDirection2 := -1;
  m_btDirection3 := -1;

  m_boWantRefMsg := False;
  m_boFixedHideMode := False;
  m_boDupMode := False;
  m_boRunReady := False;
  m_btMagPassTh := 0;
  m_dwSpellTick := GetTickCount();
  m_dwStartWalkTick := GetTickCount();
  m_dwThinkTick := GetTickCount();
  m_nViewRangeX := 9;
  m_nViewRangeY := m_nViewRangeX - 1;
  m_nRunTime := 100;
  m_dwSearchTime := 1200;
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := RC_HERO;
  m_dwMagStickTick := 0;
  m_nCurMagId := 0;
end;

destructor THeroObjectMon.Destroy();
begin
  inherited;
end;

procedure THeroObjectMon.OnCancelTarget();
begin
  if m_TargetCret <> nil then
    Exit;
  m_boNextDir := False;
  m_btDirection2 := -1;
  m_btDirection3 := -1;
end;

procedure THeroObjectMon.Run();
var
  nX, nY, nDist: Integer;
  Buffer: array[0..255] of Byte;
begin
  if not m_boRunReady then
  begin
    if GetTickCount - m_dwStartWalkTick > 980 then
    begin
      m_boRunReady := True;
      SendRefMsg(RM_TURN, m_btDirection, m_nCurrX, m_nCurrY, 0, GetShowName);
      SendRefMsg(RM_HEROLOGIN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    end;
    Exit;
  end;
  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin
    //if m_TargetCret = m_Master then m_TargetCret := nil;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTargetHero();
    end;

    if (m_Master <> nil) and (m_Master.m_PEnvir <> nil) and
      ((m_PEnvir = nil) or
      (m_Master.m_PEnvir <> m_PEnvir) //or
      {(abs(m_nCurrX - m_Master.m_nCurrX) > 20) or}
      {(abs(m_nCurrY - m_Master.m_nCurrY) > 20)}) then
    begin
      if m_Master.m_boHeroSearchTag then
        m_Master.m_boHeroSearchTag := False;
      //m_Master.GetBackPositionEx(nX, nY);
      m_Master.GetFrontPosition(nX, nY);
      SpaceMove(m_Master.m_PEnvir.m_sMapFileName, nX, nY, 1);
      m_LockTarget := nil;
      m_TargetCret := nil;
      inherited;
      Exit;
    end;

    if (m_Master <> nil) and m_Master.m_boSlaveRelax then
    begin
      inherited;
      Exit;
    end;
    if Think() then
    begin
      inherited;
      Exit;
    end;
    if (m_Master = nil) or not m_Master.m_boSlaveRelax then
    begin
      if AttackTarget then
      begin
        inherited;
        Exit;
      end;
    end;
    if m_boWalkWaitLocked and ((GetTickCount - m_dwWalkWaitTick) > 300) then
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
      if m_TargetCret = nil then
      begin
        m_nTargetX := -1;
        OnCancelTarget();
      end;
      if (m_Master <> nil) then
      begin
        if m_TargetCret = nil then
        begin
          m_Master.GetBackPositionEx(nX, nY, False);
          if (abs(m_nCurrX - nX) > 1) or (abs(m_nCurrY - nY) > 1) then
          begin
            if (abs(m_nCurrX - m_Master.m_nCurrX) > 2) or (abs(m_nCurrY - m_Master.m_nCurrY) > 2) then
            begin
              m_nTargetX := nX;
              m_nTargetY := nY;
            end
            else
            begin
              m_nTargetX := nX + Random(3) - 1;
              m_nTargetY := nY + Random(3) - 1;
            end;
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
        nDist := 20;
        if (m_PEnvir <> m_Master.m_PEnvir) or ((not m_Master.m_boSlaveRelax) and ((abs(m_nCurrX - m_Master.m_nCurrX) > nDist) or (abs(m_nCurrY - m_Master.m_nCurrY) > nDist))) then
        begin
          nX := m_nTargetX;
          nY := m_nTargetY;
          if m_Master.m_boSlaveRelax then
            m_Master.GetBackPositionEx(nX, nY, False);
          SpaceMove(m_Master.m_PEnvir.m_sMapFileName, nX, nY, 1);
        end;
        //if not m_Master.m_boSlaveRelax and ((m_PEnvir <> m_Master.m_PEnvir) or (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then
        //  SpaceMove(m_Master.m_PEnvir.m_sMapFileName, m_nTargetX, m_nTargetY, 1);
      end;
      if m_nTargetX <> -1 then
      begin
        if (abs(m_nCurrX - m_nTargetX) > 1) or (abs(m_nCurrY - m_nTargetY) > 1) then
        begin
          if g_Config.boHeroEvade then
          begin
            if m_btDirection3 > -1 then
            begin
              if not RuntoTargetXY(m_btDirection3, False) then
                GotoTargetXY();
              m_btDirection3 := -1;
            end
            else if m_btDirection2 > -1 then
            begin
              if not RuntoTargetXY(m_btDirection2, False) then
                GotoTargetXY();
              if m_boNextDir then
              begin
                m_boNextDir := False;
                m_btDirection3 := (m_btDirection2 + 1) mod 8;
              end;
              m_btDirection2 := -1;
            end
            else if not RuntoTargetXY(GetNextDirection(m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY), False) then
              GotoTargetXY();
          end
          else
          begin
            if not RuntoTargetXY(GetNextDirection(m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY), False) then
              GotoTargetXY();
          end;
        end
        else
          GotoTargetXY();
      end;
    end;
  end;
  inherited;
end;

function THeroObjectMon.Think(): Boolean;
var
  nOldX, nOldY: Integer;
begin
  Result := False;
  if (GetTickCount - m_dwThinkTick) > 3 * 1000 then
  begin
    m_dwThinkTick := GetTickCount();
    if not InSafeZone() and (m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2) then
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

procedure THeroObjectMon.TrainingSkill(Magic: pTUserMagic);
var
  nc: Integer;
begin
  if (Magic <> nil) and (Magic.btLevel < Magic.MagicInfo.btTrainLv) then
  begin
    if Magic.MagicInfo.btClass = 0 then
      nc := m_Abil.Level
    else
      nc := m_nInPowerLevel;
    if Magic.MagicInfo.TrainLevel[Magic.btLevel] <= nc then
    begin
      TrainSkill(Magic, Random(3) + 1);
      if not CheckMagicLevelup(Magic) then
        SendDelayMsg(self, RM_MAGIC_LVEXP, Magic.MagicInfo.btClass, Magic.MagicInfo.wMagicId, Magic.btLevel, Magic.nTranPoint, '', 1000);
    end;
  end;
end;

function THeroObjectMon.__Warr__HeroAttackTarget(): Boolean;
var
  btDir, btMasterDir: byte;
  boTrainOk: Boolean;
  i, ii, nX, nY, nRange: Integer;
  nHitMode, nMapRangeCount: Integer;
  nc, nD, nDir, nSpellPoint: Integer;
  nNX, nNY, nTX, nTY: Integer;
  UserMagic: pTUserMagic;
  dwAttackTime: LongWord;
  nOldDC, nAbsX, nAbsY: Integer;
label
  LabelDoSpell, LabelStartAttack, LabelNormo, LabLongAttack, LabLongAttack2;
begin
  Result := False;
  m_boLAT := False;
  nHitMode := 0;
  UserMagic := nil;

  if g_Config.boCalcHeroHitSpeed then
    dwAttackTime := _MAX(350, Integer(m_nNextHitTime) - (_MIN(g_Config.nHeroHitSpeedMax, m_nHitSpeed) * g_Config.ClientConf.btItemSpeed div 2))
  else
    dwAttackTime := m_nNextHitTime;

  if m_TargetCret <> nil then
  begin
    if (m_MagicArr[0][56] <> nil) and ((GetTickCount - m_dwLatestPursueHitTick) > (g_Config.nHeroFireSwordTime + 5000)) and (GetLongAttackDirX(m_TargetCret, btDir)) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then
      begin
        m_dwLatestPursueHitTick := GetTickCount();
        m_dwHitTick := GetTickCount();
        nHitMode := 13;
        m_boPursueHitSkill := True;
        m_boLAT := True;
        goto LabelStartAttack;
      end;
    end;

    nD := _MAX(3, Random(10));
    if (m_MagicArr[0][66] <> nil) and (m_MagicArr[0][66].btKey = 0) and (GetTickCount - m_dwLatestHeroLongHitTick > 4 * 1000) and
      (((m_WAbil.Level > m_TargetCret.m_WAbil.Level) and GetLongAttackDirX(m_TargetCret, btDir)) or
      ((m_WAbil.Level <= m_TargetCret.m_WAbil.Level) and GetLongAttackDir(m_TargetCret, btDir))) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then
      begin
        //Inc(m_nLongAttackCount);
        m_dwLatestHeroLongHitTick := GetTickCount();
        m_dwHitTick := GetTickCount();
        if m_WAbil.Level > m_TargetCret.m_WAbil.Level then
        begin
          m_btSquareHit := 2;
          nHitMode := 12;
        end
        else
        begin
          m_btSquareHit := 1;
          nHitMode := 12;
        end;
        m_boLAT := True;
        goto LabelStartAttack;
      end;
    end
    else if (m_MagicArr[0][SKILL_ERGUM] <> nil) and (m_MagicArr[0][SKILL_ERGUM].btKey = 0) and (m_nLongAttackCount <= nD) and GetLongAttackDir(m_TargetCret, btDir) then
    begin
      if (m_nLongAttackCount > 1) and (nD >= 5) then
      begin
        //
        nRange := -9;
        goto LabLongAttack;
      end;
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then
      begin
        Inc(m_nLongAttackCount);
        m_dwHitTick := GetTickCount();
        nHitMode := 4;
        m_boUseThrusting := True;
        m_boLAT := True;
        goto LabelStartAttack;
      end;
    end
    else
    begin
      nRange := Round((m_WAbil.HP * 100) / m_WAbil.MaxHP / 2);
      LabLongAttack:
      m_nLongAttackCount := 0;
      if (m_MagicArr[0][SKILL_ERGUM] <> nil) and (m_MagicArr[0][SKILL_ERGUM].btKey = 0) and (Random(nRange + 20) = 0) or (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 2) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 2) then
      begin
        if GetLongAttackDir(m_TargetCret, btDir) then
        begin
          // nD := 999;
          nTX := -1;
          nDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          if Random(2) = 0 then
            nDir := (nDir + 1) mod 8
          else
            nDir := (nDir + 7) mod 8;
          if (m_TargetCret.m_PEnvir <> nil) and m_TargetCret.m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, nDir, 2, nNX, nNY) then
          begin
            if ((m_nCurrX <> nNX) or (m_nCurrY <> nNY)) and (abs(m_nCurrX - nNX) mod 2 = 0) and (abs(m_nCurrY - nNY) mod 2 = 0) then
            begin
              nTX := nNX;
              nTY := nNY;
            end;
          end;
          if nTX <> -1 then
          begin
            if (m_TargetCret.m_nCurrX <> nTX) or (m_TargetCret.m_nCurrY <> nTY) then
            begin
              if (abs(nTX - m_TargetCret.m_nCurrX) > 1) or (abs(nTY - m_TargetCret.m_nCurrY) > 1) then
              begin
                if m_PEnvir.CanWalk(nTX, nTY, False) then
                  SetTargetXY(nTX, nTY)
                else
                begin
                  goto LabLongAttack2;
                end;
              end;
            end;
          end;
        end
        else
        begin
          LabLongAttack2:
          nD := 999;
          nTX := -1;
          for ii := 0 to 8 - 1 do
          begin
            if (m_TargetCret.m_PEnvir <> nil) and m_TargetCret.m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, ii, 2, nNX, nNY) then
            begin
              {if ((m_nCurrX <> nNX) or (m_nCurrY <> nNY)) and (abs(m_nCurrX - nNX) mod 2 = 0) and (abs(m_nCurrY - nNY) mod 2 = 0) then begin
                nTX := nNX;
                nTY := nNY;
                Break;
              end;}
              nc := abs(m_nCurrX - nNX) + abs(m_nCurrY - nNY);
              if nc < nD then
              begin
                nD := nc;
                nTX := nNX;
                nTY := nNY;
              end;
            end;
          end;
          if nTX <> -1 then
          begin
            if (m_TargetCret.m_nCurrX <> nTX) or (m_TargetCret.m_nCurrY <> nTY) then
            begin
              if (abs(nTX - m_TargetCret.m_nCurrX) > 1) or (abs(nTY - m_TargetCret.m_nCurrY) > 1) then
              begin
                if m_PEnvir.CanWalk(nTX, nTY, False) then
                  SetTargetXY(nTX, nTY)
                else
                begin
                  nOldDC := 0;
                  while nOldDC <= 15 do
                  begin
                    nTX := m_TargetCret.m_nCurrX + (Random(3) - 1) * 2;
                    nTY := m_TargetCret.m_nCurrY + (Random(3) - 1) * 2;
                    if (m_TargetCret.m_nCurrX <> nTX) or (m_TargetCret.m_nCurrY <> nTY) then
                    begin
                      if (abs(nTX - m_TargetCret.m_nCurrX) > 1) or (abs(nTY - m_TargetCret.m_nCurrY) > 1) then
                      begin
                        if m_PEnvir.CanWalk(nTX, nTY, False) then
                        begin
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
      end
      else
      begin
        if (m_MagicArr[0][75] <> nil) and (m_nMagShieldHP <= 0) then
        begin
          if GetTickCount - m_dwUnionHitShieldTick > 10 * 1000 then
          begin
            m_dwUnionHitShieldTick := GetTickCount;
            Result := HeroDoSpell(m_MagicArr[0][75], m_TargetCret, boTrainOk);
            Exit;
          end;
        end;
        if GetAttackDir(m_TargetCret, btDir) then
        begin
          if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then
          begin
            m_dwHitTick := GetTickCount();
            UserMagic := m_MagicArr[0][SKILL_MOOTEBO]; //TPlayObject(self).GetMagicInfo(SKILL_MOOTEBO);
            if (UserMagic <> nil) and (m_WAbil.Level > m_TargetCret.m_WAbil.Level) and not m_TargetCret.m_boStickMode then
            begin
              if (GetTickCount - m_dwDoMotaeboTick) > (6 * 1000 + Random(5 * 1000)) then
              begin
                m_dwDoMotaeboTick := GetTickCount();
                m_btDirection := btDir;
                nSpellPoint := TPlayObject(self).GetSpellPoint(UserMagic);
                if m_WAbil.MP >= nSpellPoint then
                begin
                  if nSpellPoint > 0 then
                  begin
                    TPlayObject(self).DamageSpell(nSpellPoint);
                    TPlayObject(self).HealthSpellChanged();
                  end;
                  if TPlayObject(self).DoMotaebo(m_btDirection, UserMagic.btLevel) then
                  begin
                    TrainingSkill(UserMagic);
                    m_dwTargetFocusTick := GetTickCount();
                    m_dwHitTick := GetTickCount() + dwAttackTime;
                    Result := True;
                    Exit;
                  end;
                end;
              end;
            end;

            if (m_MagicArr[0][56] <> nil) and ((GetTickCount - m_dwLatestPursueHitTick) > g_Config.nHeroFireSwordTime) then
            begin
              m_dwLatestPursueHitTick := GetTickCount();
              nHitMode := 13;
              m_boPursueHitSkill := True;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][43] <> nil) and ((GetTickCount - m_dwLatestTwinHitTick) > 15 * 1000) then
            begin
              m_dwLatestTwinHitTick := GetTickCount();
              nHitMode := 9;
              m_boTwinHitSkill := True;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][SKILL_FIRESWORD] <> nil) and ((GetTickCount - m_dwLatestFireHitTick) > g_Config.nHeroFireSwordTime) then
            begin
              m_dwLatestFireHitTick := GetTickCount();
              nHitMode := 7;
              m_boFireHitSkill := True;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][66] <> nil) and ((GetTickCount - m_dwLatestHeroLongHitTick) > 6000) and TargetInSwordLongAttackRangeX() then
            begin
              m_dwLatestHeroLongHitTick := GetTickCount();
              nHitMode := 12;
              if (m_WAbil.Level > m_TargetCret.m_WAbil.Level) then
                m_btSquareHit := 2
              else
                m_btSquareHit := 1;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][66] <> nil) and ((GetTickCount - m_dwLatestHeroLongHitTick) > 8000) then
            begin
              m_dwLatestHeroLongHitTick := GetTickCount();
              nHitMode := 12;
              if (m_WAbil.Level > m_TargetCret.m_WAbil.Level) then
                m_btSquareHit := 2
              else
                m_btSquareHit := 1;
              goto LabelStartAttack;
            end;

            if (m_MagicArr[0][SKILL_ERGUM] {m_MagicErgumSkill} <> nil) and TargetInSwordLongAttackRange then
            begin
              nHitMode := 4;
              m_boUseThrusting := True;
              goto LabelStartAttack;
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

            if GetTickCount - m_dwMagStickTick > (8 * 1000 + Random(8 * 1000)) then
            begin
              m_dwMagStickTick := GetTickCount();
              UserMagic := m_MagicArr[0][41]; //TPlayObject(self).GetMagicInfo(41);
              if (GetTagXYRangeCount(1, 3, 1) > 3) and (UserMagic <> nil) then
              begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(UserMagic, m_TargetCret, boTrainOk);
                Exit;
              end;
            end;

            LabelStartAttack:
            m_dwTargetFocusTick := GetTickCount();
            if nHitMode in [0, 3, 4, 5, 7, 9, 12, 13] then
            begin
              m_dwHitTick := GetTickCount();
              if m_boLAT then
                AttackDir(nil, nHitMode, btDir)
              else
                AttackDir(m_TargetCret, nHitMode, btDir);
            end;
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
              nMapRangeCount := GetTagXYRangeCount(0, 1);
              if nMapRangeCount > 3 then
              begin
                UserMagic := m_MagicArr[0][71]; //TPlayObject(self).GetMagicInfo(71);
                if not (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_Abil.Level + 8 < m_Abil.Level) and (UserMagic <> nil) then
                  goto LabelDoSpell;
              end;
              if (nMapRangeCount > 2) then
                UserMagic := m_MagicArr[0][39]; //TPlayObject(self).GetMagicInfo(39);
              if UserMagic <> nil then
                goto LabelDoSpell;

              LabelDoSpell:
              if UserMagic <> nil then
              begin
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

function THeroObjectMon.__Wiza__HeroAttackTarget(): Boolean;
var
  i, nCount: Integer;
  boTrainOk, boWarr, bola: Boolean;
  btDir: byte;
  nTag, nX, nY, nAbsX, nAbsY: Integer;
  nNX, nNY, nTX, nTY, nOldDC: Integer;
  dwAttackTime: LongWord;
label
  DDDD, LabelMagPass;
begin
  Result := False;
  boTrainOk := False;
  if m_Abil.Level >= 7 then
  begin
    if m_TargetCret <> nil then
    begin
      nAbsX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
      nAbsY := abs(m_nCurrY - m_TargetCret.m_nCurrY);

      bola := False;
      boWarr := False;
      if (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_btJob = 0) and ((m_TargetCret.m_MagicArr[0][12] <> nil)) then
      begin
        boWarr := True;
        if m_TargetCret.GetLongAttackDir(self, btDir) then
          bola := True;
      end;

      if {(m_WAbil.MP > 0) and}((nAbsX > 1) or (nAbsY > 1)) and (not boWarr or not bola) then
      begin
        if (nAbsX <= g_Config.nMagicAttackRage) and (nAbsY <= g_Config.nMagicAttackRage) then
        begin
          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
          begin
            m_dwHitTick := GetTickCount();
            if (m_MagicArr[0][75] <> nil) and (m_nMagShieldHP <= 0) then
            begin
              if GetTickCount - m_dwUnionHitShieldTick > 15 * 1000 then
              begin
                m_dwUnionHitShieldTick := GetTickCount;
                Result := HeroDoSpell(m_MagicArr[0][75], m_TargetCret, boTrainOk);
                Exit;
              end;
            end;

            if m_boStrike and (m_dwCloneDispearTick = 0) and (m_MagicArr[0][74] <> nil) then
            begin
              if GetTickCount - m_dwCloneSelfTick > g_Config.dwCloneSelfTime then
              begin
                m_dwCloneSelfTick := GetTickCount();
                nCount := 0;
                for i := m_SlaveList.Count - 1 downto 0 do
                begin
                  if TBaseObject(m_SlaveList.Items[i]).m_btRaceServer = RC_HERO then
                    Inc(nCount);
                end;
                if nCount < g_Config.nBodyCount then
                begin
                  m_dwTargetFocusTick := GetTickCount();
                  Result := HeroDoSpell(m_MagicArr[0][74], self, boTrainOk);
                  m_boStrike := False;
                  Exit;
                end;
              end;
            end;

            if (m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] <= 0) and (m_MagicArr[0][31] <> nil) then
            begin
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][31], self, boTrainOk);
              Exit;
            end;

            if (m_MagicArr[0][22] <> nil) then
            begin
              if (GetTagXYRangeCount(1, 6) >= 20) then
              begin
                if m_PEnvir.GetEvent(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY) = nil then
                begin
                  m_dwTargetFocusTick := GetTickCount();
                  Result := HeroDoSpell(m_MagicArr[0][22], m_TargetCret, boTrainOk);
                  Exit;
                end;
              end;
            end;

            if m_btMagPassTh > 0 then
            begin
              Dec(m_btMagPassTh);
              if m_MagicArr[0][10] <> nil then
              begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then
                begin
                  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 8, nTX, nTY);
                  if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) > 0 then
                  begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := HeroDoSpell(m_MagicArr[0][10], m_TargetCret, boTrainOk);
                    Exit;
                  end;
                end;
              end;
              if m_MagicArr[0][9] <> nil then
              begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then
                begin
                  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 5, nTX, nTY);
                  if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) > 0 then
                  begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := HeroDoSpell(m_MagicArr[0][9], m_TargetCret, boTrainOk);
                    Exit;
                  end;
                end;
              end;
            end;

            nTag := GetTagXYRangeCount(0, 1, 1);
            if nTag <= 1 then
            begin
              //ReGetMagID:
              if (m_TargetCret.m_Abil.Level < 50) and (m_TargetCret.m_Abil.Level + 10 < m_Abil.Level) and (m_TargetCret.m_btLifeAttrib = LA_UNDEAD) and (m_MagicArr[0][32] <> nil) then
              begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][32], m_TargetCret, boTrainOk);
                Exit;
              end;
              if (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_btJob = 0) and (Random(nAbsX + nAbsX) <= 2) and (m_TargetCret.m_Abil.Level + 3 < m_Abil.Level) and (m_MagicArr[0][44] <> nil) then
              begin
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
              if (m_nCurMagId > 0) and (m_MagicArr[0][m_nCurMagId] <> nil) then
              begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][m_nCurMagId], m_TargetCret, boTrainOk);
                Exit;
              end;
            end;

            if nTag < 5 then
            begin
              if m_MagicArr[0][10] <> nil then
              begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then
                begin
                  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 8, nTX, nTY);
                  if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) > 2 then
                  begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := HeroDoSpell(m_MagicArr[0][10], m_TargetCret, boTrainOk);
                    if m_btMagPassTh > 0 then
                      m_btMagPassTh := 0;
                    Exit;
                  end;
                end;
              end;
              if m_MagicArr[0][9] <> nil then
              begin
                btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nNX, nNY) then
                begin
                  m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 5, nTX, nTY);
                  if CheckMagPassThrough(nNX, nNY, nTX, nTY, btDir) > 1 then
                  begin
                    m_dwTargetFocusTick := GetTickCount();
                    Result := HeroDoSpell(m_MagicArr[0][9], m_TargetCret, boTrainOk);
                    if m_btMagPassTh > 0 then
                      m_btMagPassTh := 0;
                    Exit;
                  end;
                end;
              end;
            end;

            m_nCurMagId := 0;
            if Random(6) > 1 then
            begin
              if Random(5) > 1 then
              begin
                if (m_MagicArr[0][58] <> nil) then
                  m_nCurMagId := 58
                else if (m_MagicArr[0][33] <> nil) then
                  m_nCurMagId := 33;
              end
              else if (m_MagicArr[0][33] <> nil) then
                m_nCurMagId := 33;
            end
            else if (m_MagicArr[0][47] <> nil) then
              m_nCurMagId := 47;
            if (m_nCurMagId <= 0) and (m_MagicArr[0][23] <> nil) then
              m_nCurMagId := 23;
            if (m_nCurMagId > 0) and (m_MagicArr[0][m_nCurMagId] <> nil) then
            begin
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][m_nCurMagId], m_TargetCret, boTrainOk);
              Exit;
            end;

            //goto ReGetMagID;
            if (m_TargetCret.m_Abil.Level < 50) and (m_TargetCret.m_Abil.Level + 10 < m_Abil.Level) and (m_TargetCret.m_btLifeAttrib = LA_UNDEAD) and (m_MagicArr[0][32] <> nil) then
            begin
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][32], m_TargetCret, boTrainOk);
              Exit;
            end;
            //寒冰掌
            if (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_btJob = 0) and (nAbsX <= 4) and (nAbsY <= 4) and (m_TargetCret.m_Abil.Level + 3 < m_Abil.Level) and (m_MagicArr[0][44] <> nil) and (m_MagicArr[0][44].btKey = 0) and (Random(3) = 0) then
            begin
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][44], m_TargetCret, boTrainOk);
              Exit;
            end;

            m_nCurMagId := 0; //单攻...
            if m_MagicArr[0][11] <> nil then
              m_nCurMagId := 11
            else if m_MagicArr[0][5] <> nil then
              m_nCurMagId := 5
            else if m_MagicArr[0][1] <> nil then
              m_nCurMagId := 1;
            if (Random(6) > 3) and (m_MagicArr[0][45] <> nil) then
              m_nCurMagId := 45;
            if (m_nCurMagId > 0) and (m_MagicArr[0][m_nCurMagId] <> nil) then
            begin
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][m_nCurMagId], m_TargetCret, boTrainOk);
              Exit;
            end;
          end
          else
          begin
            if (m_btDirection3 > -1) and g_Config.boHeroEvade and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
            begin
              if m_nTargetX < 0 then
                SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
              //m_dwWalkTick := 0;
              Result := False;
              Exit;
            end;
            m_nTargetX := -1;
            OnCancelTarget();
          end;
        end
        else
        begin //0619
          if (m_TargetCret.m_PEnvir = m_PEnvir) then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          else
            DelTargetCreat();
        end;
      end
      else
      begin
        if (nAbsX > g_Config.nMagicAttackRage) or (nAbsY > g_Config.nMagicAttackRage) then
        begin
          if (m_TargetCret.m_PEnvir = m_PEnvir) then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          else
            DelTargetCreat();
          Exit;
        end;

        if (nAbsX <= 1) and (nAbsY <= 1) and not bola then
        begin
          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
          begin
            m_dwHitTick := GetTickCount();
            nTag := GetTagXYRangeCount(1, 1, 1);
            if (nTag >= 4) then
            begin
              if (Random(12) = 0) and (m_MagicArr[0][24] <> nil) then
              begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][24], m_TargetCret, boTrainOk);
                Exit;
              end;

              DDDD: //强攻...
              m_nCurMagId := 0; //群
              if Random(6) > 1 then
              begin
                if Random(5) > 1 then
                begin
                  if (m_MagicArr[0][58] <> nil) then
                    m_nCurMagId := 58
                  else if (m_MagicArr[0][33] <> nil) then
                    m_nCurMagId := 33;
                end
                else if (m_MagicArr[0][33] <> nil) then
                  m_nCurMagId := 33;
              end
              else if (m_MagicArr[0][47] <> nil) then
                m_nCurMagId := 47;
              if (m_nCurMagId <= 0) and (m_MagicArr[0][23] <> nil) then
                m_nCurMagId := 23;
              if (m_nCurMagId > 0) and (m_MagicArr[0][m_nCurMagId] <> nil) then
              begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][m_nCurMagId], m_TargetCret, boTrainOk);
                Exit;
              end;
              m_nCurMagId := 0; //单
              if m_MagicArr[0][11] <> nil then
                m_nCurMagId := 11
              else if m_MagicArr[0][5] <> nil then
                m_nCurMagId := 5
              else if m_MagicArr[0][1] <> nil then
                m_nCurMagId := 1;
              if (Random(6) > 3) and (m_MagicArr[0][45] <> nil) then
                m_nCurMagId := 45;
              if (m_nCurMagId > 0) and (m_MagicArr[0][m_nCurMagId] <> nil) then
              begin
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][m_nCurMagId], m_TargetCret, boTrainOk);
                Exit;
              end;
            end;
            if (m_MagicArr[0][8] <> nil) and (m_Abil.Level > m_TargetCret.m_Abil.Level) then
            begin
              if m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO] then
                nCount := 1
              else
                nCount := 2 + Random(2);
              if nTag >= nCount then
              begin //抗拒比较少使用
                m_dwTargetFocusTick := GetTickCount();
                Result := HeroDoSpell(m_MagicArr[0][8], m_TargetCret, boTrainOk);
                if Result then
                  Inc(m_btMagPassTh, 1 + Random(2));
                Exit;
              end;
            end;
          end;
        end;

        if (m_TargetCret.m_PEnvir = m_PEnvir) then
        begin
          m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);

          if g_Config.boHeroEvade then
          begin
            if not m_boNextDir and (boWarr or ((nAbsX = 0) or (nAbsY = 0) {or (nAbsX = nAbsY)})) then
            begin
              Inc(m_btDirection, 2);
              m_boNextDir := True;
            end
            else
            begin
              Inc(m_btDirection);
              //if bola then
              //  m_boNextDir := True;
            end;
            if m_btDirection > 7 then
              m_btDirection := m_btDirection mod 8;

            GetBackPosition(nX, nY);
            nTag := 0;
            while (True) do
            begin
              if m_PEnvir.CanWalk(nX, nY, False) then
                Break;
              Inc(m_btDirection);
              if m_btDirection > 7 then
                m_btDirection := m_btDirection mod 8;
              GetBackPosition(nX, nY);
              Inc(nTag);
              m_boNextDir := False;
              if nTag > 7 then
                Break;
            end;

            if m_PEnvir.CanWalk(nX, nY, False) then
            begin
              GetBackPosition2(nTX, nTY);
              if m_PEnvir.CanWalk(nTX, nTY, False) then
              begin //run away...
                m_btDirection2 := (m_btDirection + 4) mod 8;
                nX := nTX;
                nY := nTY;
              end;
            end
            else if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
            begin //强攻...
              m_dwHitTick := GetTickCount();
              nTag := 1;
              goto DDDD;
            end;
            if (m_btDirection3 > -1) and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
            begin
              //SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
              //m_dwWalkTick := 0;
              Result := False;
              Exit;
            end;

          end
          else
          begin
            GetBackPosition(nX, nY);
            nTag := 0;
            while (True) do
            begin
              if m_PEnvir.CanWalk(nX, nY, False) then
                Break;
              Inc(m_btDirection);
              if m_btDirection > 7 then
                m_btDirection := m_btDirection mod 8;
              GetBackPosition(nX, nY);
              Inc(nTag);
              if nTag > 7 then
                Break;
            end;
            if m_PEnvir.CanWalk(nX, nY, False) then
            begin
              GetBackPosition2(nTX, nTY);
              if m_PEnvir.CanWalk(nTX, nTY, False) then
              begin //run away...
                nX := nTX;
                nY := nTY;
              end;
            end
            else if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
            begin //强攻...
              m_dwHitTick := GetTickCount();
              nTag := 1;
              goto DDDD;
            end;
          end;

          if m_Master <> nil then
          begin
            if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(nX - m_Master.m_nCurrX) < 13) and (abs(nY - m_Master.m_nCurrY) < 13)) then
              SetTargetXY(nX, nY)
            else
              DelTargetCreat();
          end
          else if m_TargetCret <> nil then
          begin
            if (m_TargetCret.m_PEnvir = m_PEnvir) then
              SetTargetXY(nX, nY)
            else
              DelTargetCreat();
          end;
        end
        else
          DelTargetCreat();
      end;
    end;
  end
  else if m_TargetCret <> nil then
  begin
    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if g_Config.boCalcHeroHitSpeed then
        dwAttackTime := _MAX(350, Integer(m_nNextHitTime) - (_MIN(g_Config.nHeroHitSpeedMax, m_nHitSpeed) * g_Config.ClientConf.btItemSpeed div 2))
      else
        dwAttackTime := m_nNextHitTime;
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, btDir);
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else if m_TargetCret.m_PEnvir = m_PEnvir then
      SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
    else
      DelTargetCreat();
  end;
end;

function THeroObjectMon.__Taos__HeroAttackTarget(): Boolean;
var
  boTrainOk, boWarr, bola: Boolean;
  btDir: byte;
  i, ii, nX, nY, nTag, nTX, nTY, nAmuletIdx: Integer;
  UserMagic: pTUserMagic;
  dwAttackTime: LongWord;
  StdItem: pTStdItem;
  nAbsX, nAbsY: Integer;
label
  labWidAttack, NorAttack;

  function AutoChagnePoison(nType: Integer): Boolean;
  begin
    Result := True;
    case nType of
      1: if not AutoTakeOnItem(U_ARMRINGL, '黄色药粉(大量)', False) and not AutoTakeOnItem(U_ARMRINGL, '黄色药粉(中量)', False) and not AutoTakeOnItem(U_ARMRINGL, '黄色药粉(小量)', False) then
        begin
          //if GetTickCount - m_dwHintMsgTick > 30 * 1000 then begin
          //  m_dwHintMsgTick := GetTickCount();
          //  SysMsg('包裹或身上没有黄色药粉！', c_Purple, t_Hint);
          //end;
        end
        else
          Result := False;
      2: if not AutoTakeOnItem(U_ARMRINGL, '灰色药粉(大量)', False) and not AutoTakeOnItem(U_ARMRINGL, '灰色药粉(中量)', False) and not AutoTakeOnItem(U_ARMRINGL, '灰色药粉(小量)', False) then
        begin
          //if GetTickCount - m_dwHintMsgTick > 30 * 1000 then begin
          //  m_dwHintMsgTick := GetTickCount();
          //  SysMsg('包裹或身上没有灰色药粉！', c_Purple, t_Hint);
          //end;
        end
        else
          Result := False;
    end;
  end;
begin
  Result := False;
  boTrainOk := False;
  if m_Abil.Level >= 18 then
  begin
    if (Integer(GetTickCount - m_dwSpellTick)) > (m_nNextHitTime * 3) then
    begin
      m_dwSpellTick := GetTickCount();
      if m_SlaveList.Count <= 0 then
      begin
        UserMagic := m_MagicArr[0][55];
        if UserMagic = nil then
          UserMagic := m_MagicArr[0][30];
        if UserMagic = nil then
          UserMagic := m_MagicArr[0][17];
        if (UserMagic <> nil) then
        begin
          Result := HeroDoSpell(UserMagic, self, boTrainOk);
          m_dwHitTick := GetTickCount();
          Exit;
        end;
      end;
      if (m_MagicArr[0][14] <> nil) then
      begin
        if m_Master <> nil then
        begin
          if (m_Master.m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then
          begin
            Result := HeroDoSpell(m_MagicArr[0][14], m_Master, boTrainOk);
            m_dwHitTick := GetTickCount();
            Exit;
          end;
        end;
        if (m_wStatusTimeArr[STATE_MAGDEFENCEUP] <= 0) then
        begin
          Result := HeroDoSpell(m_MagicArr[0][14], self, boTrainOk);
          m_dwHitTick := GetTickCount();
          Exit;
        end;
      end;
      if (m_MagicArr[0][15] <> nil) then
      begin
        if m_Master <> nil then
        begin
          if (m_Master.m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) then
          begin
            Result := HeroDoSpell(m_MagicArr[0][15], m_Master, boTrainOk);
            m_dwHitTick := GetTickCount();
            Exit;
          end;
        end;
        if (m_wStatusTimeArr[STATE_DEFENCEUP] <= 0) then
        begin
          Result := HeroDoSpell(m_MagicArr[0][15], self, boTrainOk);
          m_dwHitTick := GetTickCount();
          Exit;
        end;
      end;
      if (m_MagicArr[0][2] <> nil) then
      begin
        if m_Master <> nil then
        begin
          if (Round(m_Master.m_WAbil.HP / m_Master.m_WAbil.MaxHP * 100) <= 80) then
          begin
            Result := HeroDoSpell(m_MagicArr[0][2], m_Master, boTrainOk);
            m_dwHitTick := GetTickCount();
            Exit;
          end;
        end;
        if (Round(m_WAbil.HP / m_WAbil.MaxHP * 100) <= 80) then
        begin
          Result := HeroDoSpell(m_MagicArr[0][2], self, boTrainOk);
          m_dwHitTick := GetTickCount();
          Exit;
        end;
        if m_SlaveList.Count > 0 then
        begin
          for ii := 0 to m_SlaveList.Count - 1 do
          begin
            if (Round(TBaseObject(m_SlaveList.Items[ii]).m_WAbil.HP / TBaseObject(m_SlaveList.Items[ii]).m_WAbil.MaxHP * 100) <= 60) then
            begin
              Result := HeroDoSpell(m_MagicArr[0][2], TBaseObject(m_SlaveList.Items[ii]), boTrainOk);
              m_dwHitTick := GetTickCount();
              Exit;
            end;
          end;
        end;
      end;
    end;

    if m_TargetCret = nil then
    begin
      if Integer(GetTickCount - m_dwHitTick) > (m_nNextHitTime) then
      begin
        m_dwHitTick := GetTickCount();
        if (m_MagicArr[0][34] <> nil) then
        begin
          if m_Master <> nil then
          begin
            if (m_Master.m_wStatusTimeArr[POISON_DECHEALTH] <> 0) or (m_Master.m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0) or (m_Master.m_wStatusTimeArr[POISON_STONE] <> 0) then
            begin
              Result := HeroDoSpell(m_MagicArr[0][34], m_Master, boTrainOk);
              m_dwSpellTick := GetTickCount();
              Exit;
            end;
          end;
          if (m_wStatusTimeArr[POISON_DECHEALTH] <> 0) or (m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0) or (m_wStatusTimeArr[POISON_STONE] <> 0) then
          begin
            Result := HeroDoSpell(m_MagicArr[0][34], self, boTrainOk);
            m_dwSpellTick := GetTickCount();
            Exit;
          end;
        end;
        if (m_MagicArr[0][29] <> nil) then
        begin
          if m_Master <> nil then
          begin
            if (Round(m_Master.m_WAbil.HP / m_Master.m_WAbil.MaxHP * 100) <= 80) and (Round(m_WAbil.HP / m_WAbil.MaxHP * 100) <= 80) then
            begin
              //m_boBigHealling := True;
              Result := HeroDoSpell(m_MagicArr[0][29], self, boTrainOk);
              Exit;
            end
            else
              //m_boBigHealling := False;
          end;
        end;
      end;
    end
    else
    begin
      if (m_MagicArr[0][75] <> nil) and (m_nMagShieldHP <= 0) then
      begin
        if GetTickCount - m_dwUnionHitShieldTick > 15 * 1000 then
        begin
          m_dwUnionHitShieldTick := GetTickCount;
          m_dwTargetFocusTick := GetTickCount();
          Result := HeroDoSpell(m_MagicArr[0][75], m_TargetCret, boTrainOk);
          Exit;
        end;
      end;

      nAbsX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
      nAbsY := abs(m_nCurrY - m_TargetCret.m_nCurrY);

      bola := False;
      boWarr := False;
      if (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_TargetCret.m_btJob = 0) and ((m_TargetCret.m_MagicArr[0][12] <> nil)) then
      begin
        boWarr := True;
        if m_TargetCret.GetLongAttackDir(self, btDir) then
          bola := True;
      end;

      if {(m_WAbil.MP > 0) and}((nAbsX > 1) or (nAbsY > 1)) and (not boWarr or not bola) then
      begin
        if (nAbsX <= g_Config.nMagicAttackRage) and (nAbsY <= g_Config.nMagicAttackRage) then
        begin
          if Integer(GetTickCount - m_dwHitTick) > (m_nNextHitTime) then
          begin
            m_dwHitTick := GetTickCount();

            labWidAttack:
            if (m_MagicArr[0][50] <> nil) then
            begin
              if m_wStatusArrValue[2] <= 0 then
              begin
                if GetTickCount - m_dwDoubleScTick > g_Config.DoubleScInvTime * 1000 then
                begin
                  m_dwTargetFocusTick := GetTickCount();
                  Result := HeroDoSpell(m_MagicArr[0][50], self, boTrainOk);
                  m_dwSpellTick := GetTickCount();
                  Exit;
                end;
              end;
            end;
            if (m_MagicArr[0][6] <> nil) or (m_MagicArr[0][38] <> nil) then
            begin
              if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] <= 0) then
              begin
                if g_Config.boHeroNeedAmulet then
                begin
                  if not CheckAmulet(TPlayObject(self), 1, 2, nAmuletIdx) then
                    AutoChagnePoison(2);
                  if CheckAmulet(TPlayObject(self), 1, 2, nAmuletIdx) then
                  begin
                    StdItem := UserEngine.GetStdItem(m_UseItems[nAmuletIdx].wIndex);
                    if StdItem <> nil then
                    begin
                      if (StdItem.Shape = 1) then
                      begin
                        if (GetTagXYRangeCount(0, 1) > 2) then
                        begin
                          if (m_MagicArr[0][38] <> nil) then
                          begin
                            Result := HeroDoSpell(m_MagicArr[0][38], m_TargetCret, boTrainOk);
                            if g_Config.boTaosHeroAutoChangePoison and boTrainOk then
                              AutoChagnePoison(1);
                            m_dwTargetFocusTick := GetTickCount();
                            if Result then
                            begin
                              m_dwSpellTick := GetTickCount();
                              Exit;
                            end;
                          end;
                        end
                        else
                        begin
                          if (m_MagicArr[0][6] <> nil) then
                          begin
                            Result := HeroDoSpell(m_MagicArr[0][6], m_TargetCret, boTrainOk);
                            if g_Config.boTaosHeroAutoChangePoison and boTrainOk then
                              AutoChagnePoison(1);
                            m_dwTargetFocusTick := GetTickCount();
                            if Result then
                            begin
                              m_dwSpellTick := GetTickCount();
                              Exit;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end
                else
                begin
                  if m_btUseAmulet = 1 then
                  begin
                    if (GetTagXYRangeCount(0, 1) > 2) then
                    begin
                      if (m_MagicArr[0][38] <> nil) then
                      begin
                        Result := HeroDoSpell(m_MagicArr[0][38], m_TargetCret, boTrainOk);
                        if boTrainOk then
                          m_btUseAmulet := 2;
                        m_dwTargetFocusTick := GetTickCount();
                        if Result then
                        begin
                          m_dwSpellTick := GetTickCount();
                          Exit;
                        end;
                      end;
                    end
                    else
                    begin
                      if (m_MagicArr[0][6] <> nil) then
                      begin
                        Result := HeroDoSpell(m_MagicArr[0][6], m_TargetCret, boTrainOk);
                        if boTrainOk then
                          m_btUseAmulet := 2;
                        m_dwTargetFocusTick := GetTickCount();
                        if Result then
                        begin
                          m_dwSpellTick := GetTickCount();
                          Exit;
                        end;
                      end;
                    end;
                  end;
                end;
              end;

              if (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] <= 0) then
              begin
                if g_Config.boHeroNeedAmulet then
                begin
                  if not CheckAmulet(TPlayObject(self), 1, 2, nAmuletIdx) then
                    AutoChagnePoison(1);
                  if CheckAmulet(TPlayObject(self), 1, 2, nAmuletIdx) then
                  begin
                    StdItem := UserEngine.GetStdItem(m_UseItems[nAmuletIdx].wIndex);
                    if StdItem <> nil then
                    begin
                      if (StdItem.Shape = 2) then
                      begin
                        if (GetTagXYRangeCount(0, 1) > 2) then
                        begin
                          if (m_MagicArr[0][38] <> nil) then
                          begin
                            Result := HeroDoSpell(m_MagicArr[0][38], m_TargetCret, boTrainOk);
                            if g_Config.boTaosHeroAutoChangePoison and boTrainOk then
                              AutoChagnePoison(2);
                            m_dwTargetFocusTick := GetTickCount();
                            if Result then
                            begin
                              m_dwSpellTick := GetTickCount();
                              Exit;
                            end;
                          end;
                        end
                        else
                        begin
                          if (m_MagicArr[0][6] <> nil) then
                          begin
                            Result := HeroDoSpell(m_MagicArr[0][6], m_TargetCret, boTrainOk);
                            if g_Config.boTaosHeroAutoChangePoison and boTrainOk then
                              AutoChagnePoison(2);
                            m_dwTargetFocusTick := GetTickCount();
                            if Result then
                            begin
                              m_dwSpellTick := GetTickCount();
                              Exit;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end
                else
                begin
                  if m_btUseAmulet = 2 then
                  begin
                    if (GetTagXYRangeCount(0, 1) > 2) then
                    begin
                      if (m_MagicArr[0][38] <> nil) then
                      begin
                        Result := HeroDoSpell(m_MagicArr[0][38], m_TargetCret, boTrainOk);
                        if boTrainOk then
                          m_btUseAmulet := 1;
                        m_dwTargetFocusTick := GetTickCount();
                        if Result then
                        begin
                          m_dwSpellTick := GetTickCount();
                          Exit;
                        end;
                      end;
                    end
                    else
                    begin
                      if (m_MagicArr[0][6] <> nil) then
                      begin
                        Result := HeroDoSpell(m_MagicArr[0][6], m_TargetCret, boTrainOk);
                        if boTrainOk then
                          m_btUseAmulet := 1;
                        m_dwTargetFocusTick := GetTickCount();
                        if Result then
                        begin
                          m_dwSpellTick := GetTickCount();
                          Exit;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;

            if (m_MagicArr[0][18] <> nil) and (m_wStatusTimeArr[STATE_TRANSPARENT] <= 0) and (Random(10) = 0) then
            begin
              if (GetTagXYRangeCount(1, 7, 2) >= 8) then
              begin
                m_dwTargetFocusTick := GetTickCount();
                HeroDoSpell(m_MagicArr[0][18], self, boTrainOk);
                Result := True;
                Exit;
              end;
            end;
            if (m_MagicArr[0][13] <> nil) or (m_MagicArr[0][57] <> nil) then
            begin
              if (m_MagicArr[0][57] <> nil) and (((Round(m_WAbil.HP / m_WAbil.MaxHP * 100) < 80) and (Random(100 - Round(m_WAbil.HP / m_WAbil.MaxHP * 100)) > 5)) or (Random(10) > 6)) then
              begin
                m_dwTargetFocusTick := GetTickCount();
                if m_MagicArr[0][57] <> nil then
                  HeroDoSpell(m_MagicArr[0][57], m_TargetCret, boTrainOk);
                Result := True;
              end
              else if (m_MagicArr[0][13] <> nil) and MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret) then
              begin
                m_dwTargetFocusTick := GetTickCount();
                HeroDoSpell(m_MagicArr[0][13], m_TargetCret, boTrainOk);
                Result := True;
              end
              else
              begin
                if m_TargetCret.m_PEnvir = m_PEnvir then
                  SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
                else
                  DelTargetCreat();
                Result := True;
              end;
              Exit;
            end;
          end
          else
          begin
            if (m_btDirection3 > -1) and g_Config.boHeroEvade and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
            begin
              if m_nTargetX < 0 then
                SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
              //m_dwWalkTick := 0;
              Result := False;
              Exit;
            end;
            m_nTargetX := -1;
            OnCancelTarget();
          end;
        end
        else
        begin
          //if (abs(m_nCurrX - m_TargetCret.m_nCurrX) > g_Config.nMagicAttackRage) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > g_Config.nMagicAttackRage) then begin
          if (m_TargetCret.m_PEnvir = m_PEnvir) then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          else
            DelTargetCreat();
          //end;
        end;
      end
      else
      begin
        if (abs(m_nCurrX - m_TargetCret.m_nCurrX) > g_Config.nMagicAttackRage) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > g_Config.nMagicAttackRage) then
        begin
          if (m_TargetCret.m_PEnvir = m_PEnvir) then
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
          else
            DelTargetCreat();
          Exit;
        end;

        if (nAbsX <= 1) and (nAbsY <= 1) and not bola then
        begin
          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
          begin
            m_dwHitTick := GetTickCount();
            nTag := GetTagXYRangeCount(1, 1, 1);
            if (nTag >= 5) then
            begin //怪太多,强攻解围...
              goto labWidAttack;
            end;
            if (m_MagicArr[0][48] <> nil) and (m_Abil.Level > m_TargetCret.m_Abil.Level) and (nTag >= 2) then
            begin //抗拒...
              m_dwTargetFocusTick := GetTickCount();
              Result := HeroDoSpell(m_MagicArr[0][48], m_TargetCret, boTrainOk);
              m_dwSpellTick := GetTickCount();
              Exit;
            end;
          end;
        end;

        if (m_TargetCret.m_PEnvir = m_PEnvir) then
        begin
          m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          if g_Config.boHeroEvade then
          begin
            if not m_boNextDir and (boWarr or ((nAbsX = 0) or (nAbsY = 0) {or (nAbsX = nAbsY)})) then
            begin
              Inc(m_btDirection, 2);
              m_boNextDir := True;
            end
            else
            begin
              Inc(m_btDirection);
            end;
            if m_btDirection > 7 then
              m_btDirection := m_btDirection mod 8;

            GetBackPosition(nX, nY);
            nTag := 0;
            while (True) do
            begin
              if m_PEnvir.CanWalk(nX, nY, False) then
                Break;
              Inc(m_btDirection);
              if m_btDirection > 7 then
                m_btDirection := m_btDirection mod 8;
              GetBackPosition(nX, nY);
              Inc(nTag);
              m_boNextDir := False;
              if nTag > 7 then
                Break;
            end;

            if m_PEnvir.CanWalk(nX, nY, False) then
            begin
              GetBackPosition2(nTX, nTY);
              if m_PEnvir.CanWalk(nTX, nTY, False) then
              begin //run away...
                m_btDirection2 := (m_btDirection + 4) mod 8;
                nX := nTX;
                nY := nTY;
              end;
            end
            else if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
            begin //强攻...
              m_dwHitTick := GetTickCount();
              goto labWidAttack;
            end;
            if (m_btDirection3 > -1) and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
            begin
              Result := False;
              Exit;
            end;
          end
          else
          begin
            GetBackPosition(nX, nY);
            nTag := 0;
            while (True) do
            begin
              if m_PEnvir.CanWalk(nX, nY, False) then
                Break;
              Inc(m_btDirection);
              if m_btDirection > 7 then
                m_btDirection := m_btDirection mod 8;
              GetBackPosition(nX, nY);
              Inc(nTag);
              if nTag > 8 then
                Break;
            end;
            if m_PEnvir.CanWalk(nX, nY, False) then
            begin
              GetBackPosition2(nTX, nTY);
              if m_PEnvir.CanWalk(nTX, nTY, False) then
              begin //run away...
                nX := nTX;
                nY := nTY;
              end;
            end
            else if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
            begin //强攻...
              m_dwHitTick := GetTickCount;
              goto labWidAttack;
            end;
          end;

          if m_Master <> nil then
          begin
            if (m_TargetCret.m_PEnvir = m_PEnvir) and ((abs(nX - m_Master.m_nCurrX) < 10) and (abs(nY - m_Master.m_nCurrY) < 10)) then
              SetTargetXY(nX, nY)
            else
              DelTargetCreat();
          end
          else if m_TargetCret <> nil then
          begin
            if (m_TargetCret.m_PEnvir = m_PEnvir) then
              SetTargetXY(nX, nY)
            else
              DelTargetCreat();
          end;
        end
        else
          DelTargetCreat();
      end;
    end;
  end
  else if m_TargetCret <> nil then
  begin
    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if g_Config.boCalcHeroHitSpeed then
        dwAttackTime := _MAX(350, Integer(m_nNextHitTime) - (_MIN(g_Config.nHeroHitSpeedMax, m_nHitSpeed) * g_Config.ClientConf.btItemSpeed div 2))
      else
        dwAttackTime := m_nNextHitTime;
      if Integer(GetTickCount - m_dwHitTick) > dwAttackTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, btDir);
        BreakHolySeizeMode();
      end;
      Result := True;
    end
    else if m_TargetCret.m_PEnvir = m_PEnvir then
      SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY)
    else
      DelTargetCreat();
  end;
end;

function THeroObjectMon.AttackTarget(): Boolean;
begin
  Result := False;
  case m_btJob of
    0: Result := __Warr__HeroAttackTarget;
    1: Result := __Wiza__HeroAttackTarget;
    2: Result := __Taos__HeroAttackTarget;
  end;
  if Result then
  begin
    m_nTargetX := -1;
    m_nTargetY := -1;
  end;
end;

end.
