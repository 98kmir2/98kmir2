unit ObjMon5;

interface

uses
  Windows, Classes, Grobal2, ObjBase, SysUtils, Envir;

type
  TEscortMon = class(TAnimalObject)
    m_sMName: string[14];
    m_dwThinkTick: LongWord;
    m_dwUnderFireHintTick: LongWord;
    m_boDupMode: Boolean;
    m_boEnterAnotherMap: Boolean;
  private
    function Think: Boolean;
    procedure KillFunc();
    procedure Run2;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    procedure Die(); override;
  end;

implementation

uses UsrEngn, M2Share, Event, Magic, HUtil32, EDcode;

{TEscortMon}

constructor TEscortMon.Create;
begin
  inherited;
  m_boDupMode := False;
  m_boEnterAnotherMap := False;
  m_dwThinkTick := GetTickCount();
  m_nViewRangeX := 10;
  m_nViewRangeY := m_nViewRangeX;
  m_nRunTime := 250;
  m_dwSearchTime := 3000 + Random(2000);
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := RC_Escort;
  m_boNoAttackMode := True;
  m_sMName := '';
  //
end;

destructor TEscortMon.Destroy;
begin
  inherited;
end;

function TEscortMon.Think(): Boolean;
var
  nOldX, nOldY: Integer;
begin
  Result := False;
  if (GetTickCount - m_dwThinkTick) > 3 * 1000 then
  begin
    m_dwThinkTick := GetTickCount();
    if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then
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

procedure TEscortMon.Run2();
var
  i: Integer;
  boChg, boNeedRecalc: Boolean;
  nAddPoint: Integer;
  dwC: LongWord;
  ProcessMsg: TProcessMessage;
  nCheckCode: Integer;
  dwRunTick: LongWord;
resourcestring
  sExceptionMsg0 = '[Exception] TEscortMon::Run ProcessMsg Ident:%d';
  sExceptionMsg1 = '[Exception] TEscortMon::Run 1';
  sExceptionMsg2 = '[Exception] TEscortMon::Run 2';
  sExceptionMsg3 = '[Exception] TEscortMon::Run 3 Code:%d';
  sExceptionMsg4 = '[Exception] TEscortMon::Run 4 Code:%d';
  sExceptionMsg5 = '[Exception] TEscortMon::Run 5';
  sExceptionMsg6 = '[Exception] TEscortMon::Run 6';
  sExceptionMsg7 = '[Exception] TEscortMon::Run 7';
  sExceptionMsg8 = '[Exception] TEscortMon::Run 8';
begin
  dwRunTick := GetTickCount();

  while GetMessage(@ProcessMsg) do
    Operate(@ProcessMsg);

  try
    if m_boSuperMan then
    begin
      m_WAbil.HP := m_WAbil.MaxHP;
      m_WAbil.MP := m_WAbil.MaxMP;
    end;
    dwC := (GetTickCount - m_dwHPMPTick) div 20;
    m_dwHPMPTick := GetTickCount();
    Inc(m_nHealthTick, dwC);
    Inc(m_nSpellTick, dwC);

    if not m_boDeath then
    begin
      if (m_WAbil.HP > 0) and (m_WAbil.HP < m_WAbil.MaxHP) and (m_nHealthTick >= g_Config.nHealthFillTime_MON) then
      begin
        if g_Config.nHealthFillBasic_MON = 0 then
          nAddPoint := (m_WAbil.MaxHP) + 1
        else
          nAddPoint := (m_WAbil.MaxHP div g_Config.nHealthFillBasic_MON) + 1;
          
        if (m_WAbil.HP + nAddPoint) < m_WAbil.MaxHP then
          Inc(m_WAbil.HP, nAddPoint)
        else
          m_WAbil.HP := m_WAbil.MaxHP;
        HealthSpellChanged;
      end;
      if (m_WAbil.MP < m_WAbil.MaxMP) and (m_nSpellTick >= g_Config.nSpellFillTime_MON) then
      begin
        if g_Config.nSpellFillBasic_MON = 0 then
          nAddPoint := (m_WAbil.MaxMP) + 1
        else
          nAddPoint := (m_WAbil.MaxMP div g_Config.nSpellFillBasic_MON) + 1;

        if (m_WAbil.MP + nAddPoint) < m_WAbil.MaxMP then
          Inc(m_WAbil.MP, nAddPoint)
        else
          m_WAbil.MP := m_WAbil.MaxMP;
        HealthSpellChanged;
      end;

      if m_WAbil.HP = 0 then
      begin
        Die();
      end;


     if m_nHealthTick >= g_Config.nHealthFillTime_MON then
        m_nHealthTick := 0;
      if m_nSpellTick >= g_Config.nSpellFillTime_MON then
        m_nSpellTick := 0;
    end
    else
    begin
      if (GetTickCount - m_dwDeathTick > 5000) then
        MakeGhost();
    end;

    if (GetTickCount > m_dwMasterRoyaltyTick) then
    begin
      if m_Master <> nil then
      begin
        m_Master.SysMsg(Format('45分钟内内未将%s运送到指定地点，押运任务失败！', [m_sFCharName]), c_Red, t_Hint);
        m_Master := nil;
      end;
      m_sMName := '';
      MakeGhost();
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(sExceptionMsg1);
      MainOutMessageAPI(E.Message);
    end;
  end;

  try
    if (m_TargetCret <> nil) then
    begin
      if ((GetTickCount - m_dwTargetFocusTick) > 30 * 1000) or m_TargetCret.m_boDeath or m_TargetCret.m_boGhost or (m_TargetCret.m_PEnvir <> m_PEnvir) or (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 15) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 15) then
        m_TargetCret := nil;
    end;
    if (m_LastHiter <> nil) then
    begin
      if ((GetTickCount() - m_LastHiterTick) > 30 * 1000) or m_LastHiter.m_boDeath or m_LastHiter.m_boGhost then
        m_LastHiter := nil;
    end;
    if (m_ExpHitter <> nil) then
    begin
      if ((GetTickCount() - m_ExpHitterTick) > 6 * 1000) or m_ExpHitter.m_boDeath or m_ExpHitter.m_boGhost then
        m_ExpHitter := nil;
    end;

    nCheckCode := 300;
    if m_Master <> nil then
    begin
      if m_Master.m_boGhost then
      begin
        //if GetTickCount - m_Master.m_dwGhostTick > 500 then begin
        //
        //MakeGhost;
        m_Master := nil;
        //end;
      end;
    end;

    if m_boHolySeize {and ((GetTickCount() - m_dwHolySeizeTick) > m_dwHolySeizeInterval)} then
      BreakHolySeizeMode();
    if m_boCrazyMode {and ((GetTickCount() - m_dwCrazyModeTick) > m_dwCrazyModeInterval)} then
      BreakCrazyMode();
    if m_boShowHP and ((GetTickCount() - m_dwShowHPTick) > m_dwShowHPInterval) then
      BreakOpenHealth();
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg3, [nCheckCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;

  try
    if (GetTickCount - m_dwVerifyTick) > 30 * 1000 then
    begin
      m_dwVerifyTick := GetTickCount();
      //if not m_boDenyRefStatus then
      m_PEnvir.VerifyMapTime(m_nCurrX, m_nCurrY, self);
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg4, [45]));
      MainOutMessageAPI(E.Message);
    end;
  end;

  try
    if not m_boDeath then
    begin //0901
      boChg := False;
      boNeedRecalc := False;
      for i := Low(m_dwStatusArrTick) to High(m_dwStatusArrTick) do
      begin
        if (m_wStatusTimeArr[i] > 0) and (m_wStatusTimeArr[i] < g_MaxStatusTime) then
        begin
          if (GetTickCount() - m_dwStatusArrTick[i]) > 1000 then
          begin
            Dec(m_wStatusTimeArr[i]);
            Inc(m_dwStatusArrTick[i], 1000);
            if (m_wStatusTimeArr[i] = 0) then
            begin
              boChg := True;
              case i of
                STATE_TRANSPARENT: m_boHideMode := False;
                STATE_DEFENCEUP:
                  begin
                    boNeedRecalc := True;
                    m_DefenceRate := 0;
                  end;
                STATE_MAGDEFENCEUP:
                  begin
                    boNeedRecalc := True;
                    m_MagDefenceRate := 0;
                  end;
                POISON_FREEZE:
                  begin
                    if m_nNonFrzWalkSpeed > 0 then
                      m_nWalkSpeed := m_nNonFrzWalkSpeed;
                    if m_nNonFrzNextHitTime > 0 then
                      m_nNextHitTime := m_nNonFrzNextHitTime;
                  end;
                POISON_DONTMOVE:
                  begin
                    m_boTDBeffect := False;
                  end;
                STATE_BUBBLEDEFENCEUP: m_boAbilMagBubbleDefence := False;
                POISON_STONE:
                  begin
                    m_boFastParalysis := False;
                    if m_btMedusaEyeAttack > 0 then
                    begin
                      m_btMedusaEyeAttack := 0;
                      //if m_btRaceServer in [RC_PLAYOBJECT, RC_HERO] then SysMsg('美杜莎之诅咒消失', c_Green, t_Hint);
                    end;
                  end;
              end;
            end;
          end;
        end;
      end;

      for i := Low(m_wStatusArrValue) to High(m_wStatusArrValue) do
      begin
        if m_wStatusArrValue {218} [i] > 0 then
        begin
          if GetTickCount() > m_dwStatusArrTimeOutTick {220} [i] then
          begin
            m_wStatusArrValue[i] := 0;
            boNeedRecalc := True;
            case i of
              2: m_dwDoubleScTick := GetTickCount;
            end;
          end;
        end;
      end;

      for i := Low(m_wStatusArrValue2) to High(m_wStatusArrValue2) do
      begin
        if m_wStatusArrValue2[i] > 0 then
        begin
          if GetTickCount() > m_dwStatusArrTimeOutTick2[i] then
          begin
            m_wStatusArrValue2[i] := 0;
            boNeedRecalc := True;
          end;
        end;
      end;

      if boChg then
      begin
        m_nCharStatus := GetCharStatus();
        StatusChanged();
      end;
      if boNeedRecalc then
      begin
        RecalcAbilitys();
        if m_WAbil.HP > m_WAbil.MaxHP then
        begin
          m_WAbil.HP := m_WAbil.MaxHP;
          HealthSpellChanged;
        end;
        if m_WAbil.MP > m_WAbil.MaxMP then
        begin
          m_WAbil.MP := m_WAbil.MaxMP;
          HealthSpellChanged;
        end;
        SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
        SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg5);
  end;

  try
    if not m_boDeath then
    begin
      boNeedRecalc := False;
      for i := Low(m_wPowerRateTick) to High(m_wPowerRateTick) do
      begin
        if (m_wPowerRate[i] > 0) and (GetTickCount() > m_wPowerRateTick[i]) then
        begin
          m_wPowerRate[i] := 0;
          m_sStatuName := '';
        end;
      end;
      if boNeedRecalc then
      begin
        RecalcAbilitys();
        SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
        RefShowName();
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg5);
  end;

  try
    if not m_boDeath then
    begin //0901
      if (GetTickCount - m_dwPoisoningTick) > g_Config.dwPosionDecHealthTime {2500} then
      begin
        m_dwPoisoningTick := GetTickCount();
        if m_wStatusTimeArr[POISON_DECHEALTH] > 0 then
        begin
          if m_boAnimal then
            Dec(m_nMeatQuality, 1000);
          DamageHealth(m_btGreenPoisoningPoint + 1, False);
          m_nHealthTick := 0;
          m_nSpellTick := 0;
          HealthSpellChanged();
        end;
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg6);
  end;
  g_nBaseObjTimeMin := GetTickCount - dwRunTick;
  if g_nBaseObjTimeMax < g_nBaseObjTimeMin then
    g_nBaseObjTimeMax := g_nBaseObjTimeMin;
end;

procedure TEscortMon.Run;
var
  nX, nY: Integer;
begin
  if (m_TargetCret <> nil) and (m_TargetCret.m_boDeath or m_TargetCret.m_boGhost or ((m_TargetCret.m_PEnvir <> nil) and (m_PEnvir <> nil) and (m_TargetCret.m_PEnvir <> m_PEnvir)) or (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 15) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 15)) then
    m_TargetCret := nil;

  if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_PURPLE] = 0) then
  begin

    if Think then
    begin
      Run2(); //inherited Run;
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

      if (m_Master <> nil) and not m_Master.m_boGhost then
      begin
        if (m_PEnvir = m_Master.m_PEnvir) and (abs(m_nCurrX - m_Master.m_nCurrX) <= 11) and (abs(m_nCurrY - m_Master.m_nCurrY) <= 11) then
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
        end
        else
        begin
          //m_boEnterAnotherMap
          {if m_boEnterAnotherMap then begin
            if m_Master.m_Escort.GetRecallXY(m_Master.m_Escort.m_nCurrX, m_Master.m_Escort.m_nCurrY, 3, nX, nY) then begin
              m_Master.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
              m_Master.SpaceMove(PlayObject.m_Escort.m_sMapName, nX, nY, 0);
            end;
          end;}
          Run2(); //inherited;
          Exit;
        end;
      end;

      if (m_nTargetX <> -1) and (m_Master <> nil) then
      begin //blue
        GotoTargetXY();
      end;
    end;
  end;
  Run2(); //inherited Run;
end;

procedure TEscortMon.KillFunc();
var
  CSObject: TBaseObject;
resourcestring
  sExceptionMsg = '[Exception] TEscortMon::KillFunc';
begin
  if (g_MapEventNPC <> nil) and (m_PEnvir <> nil) then
  begin
    if m_ExpHitter <> nil then
      CSObject := GetMainPlayer(m_ExpHitter)
    else if m_LastHiter <> nil then
      CSObject := GetMainPlayer(m_LastHiter);

    if (CSObject <> nil) and (CSObject.m_btRaceServer = RC_PLAYOBJECT) and (CSObject <> m_Master) then
    begin
      if (m_Master <> nil) and not m_Master.m_boDeath and not m_Master.m_boGhost then
        CSObject.m_Robber := m_Master
      else
        CSObject.m_Robber := nil;
      try
        g_MapEventNPC.GotoLable(TPlayObject(CSObject), '@Plunder_' + m_sCharName, False);
      finally
        CSObject.m_Robber := nil;
      end;
    end;
  end;
end;

procedure TEscortMon.Die();
var
  CSObject: TBaseObject;
resourcestring
  sExceptionMsg1 = '[Exception] TEscortMon::Die - GainExp';
  sExceptionMsg3 = '[Exception] TEscortMon::Die - Die';
begin
  if m_boSuperMan or m_boSupermanItem then Exit;

  m_boDeath := True;
  m_dwDeathTick := GetTickCount();
  {if (m_Master <> nil) then begin
    m_ExpHitter := nil;
    m_LastHiter := nil;
  end;}
  m_nIncSpell := 0;
  m_nIncHealth := 0;
  m_nIncHealing := 0;

  if m_sMName <> '' then
    KillFunc();

  try
    if (m_btRaceServer <> RC_PLAYOBJECT) and (m_LastHiter <> nil) then
    begin
      if g_Config.boMonSayMsg then
        MonsterSayMsg(m_LastHiter, s_Die);
      if (m_ExpHitter <> nil) then
      begin
        CSObject := GetMainPlayer(m_ExpHitter);

        {if m_PEnvir.IsCheapStuff and (CSObject.m_btRaceServer = RC_PLAYOBJECT) then begin
          if TPlayObject(CSObject).m_GroupOwner <> nil then begin
            for i := 0 to TPlayObject(CSObject).m_GroupOwner.m_GroupMembers.Count - 1 do begin
              GroupHuman := TPlayObject(TPlayObject(CSObject).m_GroupOwner.m_GroupMembers.Objects[i]);
              if not GroupHuman.m_boDeath and
                (CSObject.m_PEnvir = GroupHuman.m_PEnvir) and
                (abs(CSObject.m_nCurrX - GroupHuman.m_nCurrX) <= 12) and
                (abs(CSObject.m_nCurrX - GroupHuman.m_nCurrX) <= 12) and
                (CSObject = GroupHuman) then begin
                boGroupQuest := False;
              end else
                boGroupQuest := True;
              QuestNPC := TMerchant(m_PEnvir.GetQuestNPC(GroupHuman, m_sCharName, '', boGroupQuest));
              if QuestNPC <> nil then
                QuestNPC.Click(GroupHuman);
            end;
          end else begin
            QuestNPC := TMerchant(m_PEnvir.GetQuestNPC(CSObject, m_sCharName, '', False));
            if QuestNPC <> nil then
              QuestNPC.Click(TPlayObject(CSObject));
          end;
        end;}

        if CSObject.m_btRaceServer = RC_PLAYOBJECT then
        begin
          {if not g_Config.boVentureServer then begin
            dwExp := CSObject.CalcGetExp(m_Abil.Level, m_dwFightExp);
            TPlayObject(CSObject).GainExp(dwExp, m_Abil.Level);
            if m_dwFightIPExp > 0 then begin
              dwExp := CSObject.CalcGetExp(m_Abil.Level, m_dwFightIPExp);
              TPlayObject(CSObject).GainExp(dwExp, m_Abil.Level, True);
            end;
          end;}
          if (m_Master <> nil) and (m_PEnvir <> nil) then
            m_Master.SysMsg(Format('你的%s在%s(%d/%d)被%s劫了，押运任务失败！', [m_sFCharName, m_PEnvir.m_sMapDesc, m_nCurrX, m_nCurrY, CSObject.m_sCharName]), c_Red, t_Hint);
        end;
        //if not (m_ExpHitter.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and (m_ExpHitter.m_Master <> nil) then
        //  m_ExpHitter.GainSlaveExp(m_Abil.Level);
      end
      else
      begin
        CSObject := GetMainPlayer(m_LastHiter);
        if CSObject.m_btRaceServer = RC_PLAYOBJECT then
        begin
          {if not g_Config.boVentureServer then begin
            dwExp := CSObject.CalcGetExp(m_Abil.Level, m_dwFightExp);
            TPlayObject(CSObject).GainExp(dwExp, m_Abil.Level);
            if m_dwFightIPExp > 0 then begin
              dwExp := CSObject.CalcGetExp(m_Abil.Level, m_dwFightIPExp);
              TPlayObject(CSObject).GainExp(dwExp, m_Abil.Level, True);
            end;
          end;}
          if (m_Master <> nil) and (m_PEnvir <> nil) then
            m_Master.SysMsg(Format('你的%s在%s(%d/%d)被%s抢劫了，押运任务失败！', [m_sFCharName, m_PEnvir.m_sMapDesc, m_nCurrX, m_nCurrY, CSObject.m_sCharName]), c_Red, t_Hint);
        end;
      end;
    end;

    //if (g_Config.boMonSayMsg) and (m_btRaceServer = RC_PLAYOBJECT) and (m_LastHiter <> nil) then
    //  m_LastHiter.MonsterSayMsg(self, s_KillHuman);

    if (m_Master <> nil) then
    begin
      m_Master := nil;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(sExceptionMsg1);
      MainOutMessageAPI(E.Message);
    end;
  end;

  try
    //减少地图上怪物计数
    if (m_Master = nil) and (not m_boDelFormMaped) then
    begin
      m_PEnvir.DelObjectCount(self);
      m_boDelFormMaped := True;
    end;
    SendRefMsg(RM_DEATH, m_btDirection, m_nCurrX, m_nCurrY, 1, '');

  except
    MainOutMessageAPI(sExceptionMsg3);
  end;
end;

end.
