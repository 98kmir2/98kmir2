unit Magic;

interface
uses
  Windows, Classes, Grobal2, ObjBase, SysUtils, EDCode, Math, StrUtils;
type
  TMagicManager = class
  private
  public
    constructor Create();
    destructor Destroy; override;
    function MagMakePrivateTransparent(BaseObject: TBaseObject; nHTime: Integer): Boolean;
    function IsWarrSkill(wMagIdx: Integer): Boolean;
    function MagBigHealing(PlayObject: TBaseObject; nPower, nX, nY: Integer): Boolean;
    function MagPushArround(PlayObject: TBaseObject; nPushLevel: Integer): Integer; //抗拒火环
    function MagPushArroundTaos(PlayObject: TBaseObject; nPushLevel: Integer): Integer; //气功波
    function MagTurnUndead(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY: Integer; nLevel: Integer): Boolean;
    function MagMakeHolyCurtain(BaseObject: TBaseObject; nPower: Integer; nX, nY, nmid: Integer): Integer;
    function MagMakeGroupTransparent(BaseObject: TBaseObject; nX, nY: Integer; nHTime: Integer): Boolean;
    function MagTamming(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY: Integer; nMagicLevel: Integer): Boolean;
    function MagSaceMove(BaseObject: TBaseObject; nLevel: Integer): Boolean;
    function MagPositionMove(PlayObject: TPlayObject; nX, nY, nLevel, nMagID: Integer): Boolean;
    function MagMakeFireCross(PlayObject: TPlayObject; nDamage, nHTime, nX, nY, nLevel: Integer): Integer;
    function MagBigExplosion(BaseObject: TBaseObject; nPower, nX, nY: Integer; nRage, nmid: Integer): Boolean;
    function MagBigExplosion_s(BaseObject: TBaseObject; nPower, nX, nY: Integer; nRage, nmid: Integer): Boolean;
    function MagExplosion_SS(PlayObject: TPlayObject; nPower, nTargetX, nTargetY: Integer; nRage, nmid, lv: Integer): Boolean;
    function MagBigExplosionEx(PlayObject: TPlayObject; nPower, nX, nY: Integer; nRage, nmid: Integer): Boolean;
    function MagElecBlizzard(BaseObject: TBaseObject; nPower: Integer): Boolean;
    function MagElecBlizzardEx(BaseObject: TBaseObject; nPower, nRage: Integer): Boolean;
    function MabMabe(BaseObject, TargeTBaseObject: TBaseObject; nPower, nLevel, nTargetX, nTargetY, id: Integer): Boolean;
    function MagMakeSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic; nX: Integer = -1; nY: Integer = -1): Boolean;
    function MagMakeSinSuSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic; nX: Integer = -1; nY: Integer = -1): Boolean;
    function MagMakeSnowMonSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic; nX: Integer = -1; nY: Integer = -1): Boolean;

    function MagMakeSuperSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
    function MagMakeEidolonSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
    function MagWindTebo(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
    function MagLightening(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagGroupLightening(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY, id: Integer; TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
    function MagGroupAmyounsul(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagGroupDeDing(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagGroupMb(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagGroupParalysis(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;

    function MagHbFireBall(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY, id: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagCaptureMonster(PlayObject: TPlayObject; TargeTBaseObject: TBaseObject; nLevel, nTargetX, nTargetY: Integer): Boolean;
    function MagSoulRecall(PlayObject: TPlayObject; TargeTBaseObject: TBaseObject; nLevel: Integer): Boolean;
    function DoSpell(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boTrainOk: Boolean): Boolean;
    function Mag61(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function Mag62(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function Mag63(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function Mag64(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function Mag65(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagMedusaEyes(PlayObject: TPlayObject; UserMagic: pTUserMagic; nX, nY: Integer; nmid: Integer): Boolean;

    function MagMoveXY(PlayObject: TPlayObject; nX, nY, nPower: Integer; UserMagic: pTUserMagic): Boolean;
    function MagicIceRain(PlayObject: TPlayObject; nX, nY, nPower: Integer; UserMagic: pTUserMagic): Boolean;
    function MagicDeadEye(PlayObject: TPlayObject; nX, nY, nPower: Integer; UserMagic: pTUserMagic): Boolean;
    function MagDragonRage(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;

  end;

function MPow(UserMagic: pTUserMagic): Integer;
function GetPower(nPower: Integer; UserMagic: pTUserMagic): Integer;
function GetPower13(nInt: Integer; UserMagic: pTUserMagic): Integer;
function GetRPow(wInt: Integer): Word;
function CheckAmulet(PlayObject: TPlayObject; nCount: Integer; nType: Integer; var Idx: Integer): Boolean;
function CheckAmuletEx(PlayObject: TPlayObject; nCount, nType: Integer; var Idx: Integer): Boolean;
procedure UseAmulet(PlayObject: TPlayObject; nCount: Integer; nType: Integer; var Idx: Integer);

implementation

uses HUtil32, M2Share, Event, Envir;

function MPow(UserMagic: pTUserMagic): Integer;
begin
  Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
end;

function GetPower(nPower: Integer; UserMagic: pTUserMagic): Integer;
begin
  Result := Round(nPower / (4) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
end;

function GetPower13(nInt: Integer; UserMagic: pTUserMagic): Integer;
var
  d10: Double;
  d18: Double;
begin
  d10 := nInt / 3.0;
  d18 := nInt - d10;
  Result := Round(d18 / (4) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)));
end;

function GetRPow(wInt: Integer): Word;
begin
  if HiWord(wInt) > LoWord(wInt) then
    Result := Random(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt)
  else
    Result := LoWord(wInt);
end;

function CheckAmuletEx(PlayObject: TPlayObject; nCount, nType: Integer; var Idx: Integer): Boolean;
var
  AmuletStdItem: pTStdItem;
begin
  Idx := 0;
  if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then
  begin
    AmuletStdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
    if (AmuletStdItem <> nil) and (AmuletStdItem.StdMode = 25) then
    begin
      case nType of
        1:
          begin
            if (AmuletStdItem.Shape = 5) and (Round(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then
            begin
              Idx := U_ARMRINGL;
              Result := True;
              Exit;
            end;
          end;
        2:
          begin
            if (AmuletStdItem.Shape = PlayObject.m_btUseAmulet) and (Round(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then
            begin
              Idx := U_ARMRINGL;
              Result := True;
              Exit;
            end;
          end;
      end;
    end;
  end;
  Result := False;
  Idx := 0;
  if PlayObject.m_UseItems[U_BUJUK].wIndex > 0 then
  begin
    AmuletStdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[U_BUJUK].wIndex);
    if (AmuletStdItem <> nil) and (AmuletStdItem.StdMode = 25) then
    begin
      case nType of
        1:
          begin
            if (AmuletStdItem.Shape = 5) and (Round(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then
            begin
              Idx := U_BUJUK;
              Result := True;
              Exit;
            end;
          end;
        2:
          begin
            if (AmuletStdItem.Shape = PlayObject.m_btUseAmulet) and (Round(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then
            begin
              Idx := U_BUJUK;
              Result := True;
              Exit;
            end;
          end;
      end;
    end;
  end;
end;

function CheckAmulet(PlayObject: TPlayObject; nCount: Integer; nType: Integer; var Idx: Integer): Boolean;
var
  AmuletStdItem: pTStdItem;
begin
  Idx := 0;
  if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then
  begin
    AmuletStdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
    if (AmuletStdItem <> nil) and (AmuletStdItem.StdMode = 25) then
    begin
      case nType of
        1:
          begin
            if (AmuletStdItem.Shape = 5) and (Round(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then
            begin
              Idx := U_ARMRINGL;
              Result := True;
              Exit;
            end;
          end;
        2:
          begin
            if (AmuletStdItem.Shape in [1, 2]) and (Round(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then
            begin
              Idx := U_ARMRINGL;
              Result := True;
              Exit;
            end;
          end;
      end;
    end;
  end;
  Result := False;
  Idx := 0;
  if PlayObject.m_UseItems[U_BUJUK].wIndex > 0 then
  begin
    AmuletStdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[U_BUJUK].wIndex);
    if (AmuletStdItem <> nil) and (AmuletStdItem.StdMode = 25) then
    begin
      case nType of
        1:
          begin
            if (AmuletStdItem.Shape = 5) and (Round(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then
            begin
              Idx := U_BUJUK;
              Result := True;
              Exit;
            end;
          end;
        2:
          begin
            if (AmuletStdItem.Shape in [1, 2]) and (Round(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then
            begin
              Idx := U_BUJUK;
              Result := True;
              Exit;
            end;
          end;
      end;
    end;
  end;
end;

procedure UseAmulet(PlayObject: TPlayObject; nCount: Integer; nType: Integer; var Idx: Integer);
var
  StdItem: pTStdItem;
begin
  if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) or PlayObject.IsHero then
  begin
    if PlayObject.m_UseItems[Idx].Dura > nCount * 100 then
    begin
      Dec(PlayObject.m_UseItems[Idx].Dura, nCount * 100);
      PlayObject.SendMsg(PlayObject, RM_DURACHANGE, Idx, PlayObject.m_UseItems[Idx].Dura, PlayObject.m_UseItems[Idx].DuraMax, 0, '');
    end
    else
    begin
      PlayObject.m_UseItems[Idx].Dura := 0;
      if (PCardinal(@PlayObject.m_UseItems[Idx].btValue[22])^ > 0) and (PCardinal(@PlayObject.m_UseItems[Idx].btValue[22])^ = PlayObject.m_dwIdCRC) and g_Config.boBindNoMelt then
      begin
        //if (nDura / 1.03) <> nDuraPoint then begin
        PlayObject.SendMsg(PlayObject, RM_DURACHANGE, Idx, 0, PlayObject.m_UseItems[Idx].DuraMax, 0, '');
        //SysMsg(Format('你的%s持久为0，属性失效，请及时修理', [StdItem.Name]), c_Green, t_Hint);
        //end;
      end
      else
      begin
        StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[Idx].wIndex);
        if (StdItem <> nil) and (StdItem.NeedIdentify = 1) then
          AddGameDataLogAPI('3' + #9 +
            PlayObject.m_sMapName + #9 +
            IntToStr(PlayObject.m_nCurrX) + #9 +
            IntToStr(PlayObject.m_nCurrY) + #9 +
            PlayObject.m_sCharName + #9 +
            StdItem.Name + #9 +
            IntToStr(PlayObject.m_UseItems[Idx].makeindex) + #9 +
            BoolToIntStr(PlayObject.m_btRaceServer = RC_PLAYOBJECT) + #9 +
            '0');
        PlayObject.SendDelItems(@PlayObject.m_UseItems[Idx]);
        PlayObject.m_UseItems[Idx].wIndex := 0;
      end;
    end;
  end;
end;

function TMagicManager.MagPushArround(PlayObject: TBaseObject; nPushLevel: Integer): Integer;
var
  i, nDir, levelgap, push: Integer;
  BaseObject: TBaseObject;
begin
  Result := 0;
  for i := 0 to PlayObject.m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(PlayObject.m_VisibleActors.Items[i]).BaseObject);
    if (abs(PlayObject.m_nCurrX - BaseObject.m_nCurrX) <= 1) and (abs(PlayObject.m_nCurrY - BaseObject.m_nCurrY) <= 1) then
    begin
      if (not BaseObject.m_boDeath) and (BaseObject <> PlayObject) then
      begin
        if (PlayObject.m_Abil.Level > BaseObject.m_Abil.Level) and (not BaseObject.m_boStickMode) then
        begin
          levelgap := PlayObject.m_Abil.Level - BaseObject.m_Abil.Level;
          if (Random(20) < 6 + nPushLevel * 3 + levelgap) then
          begin
            if PlayObject.IsProperTarget(BaseObject, True) then
            begin
              push := 1 + _MAX(0, nPushLevel - 1) + Random(2);
              nDir := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
              BaseObject.CharPushed(nDir, push);
              Inc(Result);
              BaseObject.DMSkillFix();
            end;
          end;
        end;
      end;
    end;
  end;

end;

function TMagicManager.MagBigHealing(PlayObject: TBaseObject; nPower, nX, nY: Integer): Boolean; //00492E50
var
  i: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nX, nY, 1, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList[i]);
    if PlayObject.IsProperFriend(BaseObject) or (PlayObject.m_btRaceServer = RC_HERO) then
    begin
      if BaseObject.m_WAbil.HP < BaseObject.m_WAbil.MaxHP then
      begin
        BaseObject.SendDelayMsg(PlayObject, RM_MAGHEALING, 0, nPower, 0, 0, '', 800);
        Result := True;
      end;
      if PlayObject.m_boAbilSeeHealGauge then
        PlayObject.SendMsg(BaseObject, RM_INSTANCEHEALGUAGE, 0, 0, 0, 0, '');
    end;
  end;
  BaseObjectList.Free;
end;

constructor TMagicManager.Create;
begin

end;

destructor TMagicManager.Destroy;
begin
  inherited;
end;

function TMagicManager.IsWarrSkill(wMagIdx: Integer): Boolean;
begin
  Result := False;
  if wMagIdx in [SKILL_ONESWORD,
    SKILL_ILKWANG,
    SKILL_YEDO,
    SKILL_ERGUM,
    SKILL_BANWOL,
    SKILL_FIRESWORD,
    SKILL_MOOTEBO,
    40, 42, 43, 56, 60..65] then
    Result := True;
end;

function TMagicManager.DoSpell(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boTrainOk: Boolean): Boolean;
var
  boTrain: Boolean;
  b, bb, boSpellFail: Boolean;
  boSpellFire: Boolean;
  n14: Integer;
  n18: Integer;
  n1C: Integer;
  nMagID, nPower: Integer;
  StdItem: pTStdItem;
  nAmuletIdx: Integer;
  sSendFalg: string;

  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;

  function GetPower(nPower: Integer): Integer;
  begin
    Result := Round(nPower / (4) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;

  function GetPower13(nInt: Integer): Integer;
  var
    d10: Double;
    d18: Double;
  begin
    d10 := nInt / 3.0;
    d18 := nInt - d10;
    Result := Round(d18 / (4) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)));
  end;

  function GetRPow(wInt: Integer): Word;
  begin
    if HiWord(wInt) > LoWord(wInt) then
      Result := Random(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt)
    else
      Result := LoWord(wInt);
  end;

  function IsNotAllowUseMag(PlayObject: TPlayObject; cMag: pTMagic): Boolean;
  var
    i: Integer;
  resourcestring
    sNotAllowUseMag = '本地图不允许使用%s';
  begin
    Result := False;
    if (PlayObject.m_PEnvir <> nil) and (PlayObject.m_PEnvir.m_MapFlag.boNotAllowUseMag) then
    begin
      if PlayObject.m_PEnvir.m_MapFlag.sNotAllowUseMag <> nil then
      begin
        for i := 0 to PlayObject.m_PEnvir.m_MapFlag.sNotAllowUseMag.Count - 1 do
        begin
          if cMag.wMagicId = Integer(PlayObject.m_PEnvir.m_MapFlag.sNotAllowUseMag[i]) then
          begin
            PlayObject.SysMsg(Format(sNotAllowUseMag, [cMag.sMagicName]), c_Purple, t_Hint);
            Result := True;
            Break;
          end;
        end;
      end;
    end;
  end;

begin
  Result := False;
  if PlayObject.m_boTDBeffect then
    Exit;
  if IsWarrSkill(UserMagic.wMagIdx) then
    Exit;
  if (abs(PlayObject.m_nCurrX - nTargetX) > g_Config.nMagicAttackRage) or (abs(PlayObject.m_nCurrY - nTargetY) > g_Config.nMagicAttackRage) then
    Exit;
  if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and IsNotAllowUseMag(PlayObject, UserMagic.MagicInfo) then
    Exit;

  if UserMagic.MagicInfo.wMagicId <> 74 then
  begin
    nPower := 0;
    if UserMagic.MagicInfo.wMagicId = SKILL_AMYOUNSUL then
    begin
      if g_Config.boHeroNeedAmulet or ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) and not PlayObject.m_boOffLinePlay) then
      begin
        if CheckAmulet(PlayObject, 1, 2, nAmuletIdx) then
        begin
          StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[nAmuletIdx].wIndex);
          if StdItem <> nil then
            nPower := StdItem.Shape;
        end;
      end
      else
        nPower := PlayObject.m_btUseAmulet;
    end;
    PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect + 255 * UserMagic.btLevel, MakeLong(nTargetX, nTargetY), nPower, UserMagic.MagicInfo.wMagicId, '');
  end;

  if (g_FunctionNPC <> nil) then
  begin
    if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
    begin
      sSendFalg := Format('@MagSelfFunc%d', [UserMagic.wMagIdx]);
      if g_QFLabelList.Exists(sSendFalg) then
      begin
        g_FunctionNPC.m_OprCount := 0;
        g_FunctionNPC.GotoLable(TPlayObject(PlayObject), sSendFalg, False);
      end;

      if (TargeTBaseObject <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) and PlayObject.IsProperTarget(TargeTBaseObject) then
      begin
        sSendFalg := Format('@MagTagFunc%d', [UserMagic.wMagIdx]);
        if g_QFLabelList.Exists(sSendFalg) then
        begin
          g_FunctionNPC.m_OprCount := 0;
          g_FunctionNPC.GotoLable(TPlayObject(TargeTBaseObject), sSendFalg, False);
        end;
      end;
    end;
  end;

  if (TargeTBaseObject <> nil) and (TargeTBaseObject.m_boDeath) then
    TargeTBaseObject := nil;
  boTrain := False;
  boSpellFail := False;
  boSpellFire := True;
  sSendFalg := '';
  case UserMagic.MagicInfo.wMagicId of
    SKILL_FIREBALL, SKILL_FIREBALL2:
      begin //火球术 大火球
        if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then
        begin
          if PlayObject.IsProperTarget(TargeTBaseObject) then
          begin
            if (TargeTBaseObject.m_nantiMagic <= Random(10)) and (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= 1) then
            begin
              with PlayObject do
                nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
              PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 600, UserMagic.MagicInfo.wMagicId);
              if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
                boTrain := True;
            end
            else
              TargeTBaseObject := nil;
          end
          else
            TargeTBaseObject := nil;
        end
        else
          TargeTBaseObject := nil;
      end;
    SKILL_HEALLING {2}:
      begin
        if TargeTBaseObject = nil then
        begin
          TargeTBaseObject := PlayObject;
          nTargetX := PlayObject.m_nCurrX;
          nTargetY := PlayObject.m_nCurrY;
        end;
        if PlayObject.IsProperFriend(TargeTBaseObject) or (PlayObject.m_btRaceServer = RC_HERO) then
        begin
          if TargeTBaseObject.m_btRaceServer <> rc_Escort then
          begin
            nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC) * 2, SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) * 2 + 1);
            if TargeTBaseObject.m_WAbil.HP < TargeTBaseObject.m_WAbil.MaxHP then
            begin
              TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGHEALING, 0, nPower, 0, 0, '', 800, UserMagic.MagicInfo.wMagicId);
              boTrain := True;
            end;
            if PlayObject.m_boAbilSeeHealGauge then
              PlayObject.SendMsg(TargeTBaseObject, RM_INSTANCEHEALGUAGE, 0, 0, 0, 0, '');
          end;
        end;
      end;
    SKILL_AMYOUNSUL {6}:
      begin //施毒术
        boSpellFail := True;
        // if TargeTBaseObject = nil then TargeTBaseObject := PlayObject.m_sTargetCret;
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          if g_Config.boHeroNeedAmulet or ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) and not PlayObject.m_boOffLinePlay) then
          begin
            if CheckAmulet(PlayObject, 1, 2, nAmuletIdx) then
            begin
              StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[nAmuletIdx].wIndex);
              if StdItem <> nil then
              begin
                UseAmulet(PlayObject, 1, 2, nAmuletIdx);
                if Random(TargeTBaseObject.m_btAntiPoison + 7) <= 6 then
                begin
                  case StdItem.Shape of
                    1:
                      begin
                        sSendFalg := '1';
                        nPower := GetPower13(40) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                        TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON,
                          POISON_DECHEALTH, nPower,
                          Integer(PlayObject), UserMagic.btLevel div 4 * 10 + Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', 1000,
                          UserMagic.MagicInfo.wMagicId);
                      end;
                    2:
                      begin
                        sSendFalg := '2';
                        nPower := GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                        TargeTBaseObject.SendDelayMsg(PlayObject,
                          RM_POISON,
                          POISON_DAMAGEARMOR,
                          nPower,
                          Integer(PlayObject),
                          UserMagic.btLevel div 4 * 10 + Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', 1000,
                          UserMagic.MagicInfo.wMagicId);
                      end;
                  end;
                  if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
                    boTrain := True;
                end;
                PlayObject.SetTargetCreat(TargeTBaseObject);
                boSpellFail := False;
              end;
            end;
          end
          else
          begin
            if Random(TargeTBaseObject.m_btAntiPoison + 7) <= 6 then
            begin
              case PlayObject.m_btUseAmulet of
                1:
                  begin
                    nPower := GetPower13(40) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                    TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DECHEALTH, nPower, Integer(PlayObject), UserMagic.btLevel div 4 * 10 + Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', 1000, UserMagic.MagicInfo.wMagicId);
                  end;
                2:
                  begin
                    nPower := GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                    TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DAMAGEARMOR, nPower, Integer(PlayObject), UserMagic.btLevel div 4 * 10 + Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', 1000, UserMagic.MagicInfo.wMagicId);
                  end;
              end;
              if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
                boTrain := True;
            end;
            PlayObject.SetTargetCreat(TargeTBaseObject);
            boSpellFail := False;
          end;
        end;
      end;
    SKILL_FIREWIND {8}:
      begin //抗拒火环
        if MagPushArround(PlayObject, _MIN(4, UserMagic.btLevel)) > 0 then
          boTrain := True;
      end;
    SKILL_FIRE {9}:
      begin //地狱火
        n1C := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, nTargetX, nTargetY);
        if PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 1, n14, n18) then
        begin
          PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 5, nTargetX, nTargetY);
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
          if PlayObject.MagPassThroughMagic(n14, n18, nTargetX, nTargetY, n1C, nPower, UserMagic.MagicInfo.wMagicId, False) > 0 then
            boTrain := True;
        end;
      end;
    SKILL_SHOOTLIGHTEN {10}:
      begin //疾光电影
        n1C := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, nTargetX, nTargetY);
        if PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 1, n14, n18) then
        begin
          PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 8, nTargetX, nTargetY);
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
          if PlayObject.MagPassThroughMagic(n14, n18, nTargetX, nTargetY, n1C, nPower, UserMagic.MagicInfo.wMagicId, True) > 0 then
            boTrain := True;
        end;
      end;
    SKILL_LIGHTENING {11}:
      begin //雷电术
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          if (Random(10) >= TargeTBaseObject.m_nantiMagic) then
          begin
            nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
            if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
              nPower := Round(nPower * 1.5);
            PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 600, UserMagic.MagicInfo.wMagicId);
            if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
              boTrain := True;
          end
          else
            TargeTBaseObject := nil
        end
        else
          TargeTBaseObject := nil;
      end;
    SKILL_FIRECHARM {13},
      SKILL_HANGMAJINBUB {14},
      SKILL_DEJIWONHO {15},
      SKILL_HOLYSHIELD {16},
      SKILL_SKELLETON {17},
      SKILL_CLOAK {18},
      SKILL_BIGCLOAK {19},
      SKILL_57 {噬血术}:
      begin
        boSpellFail := True;
        b := False;
        if g_Config.boHeroNeedAmulet or ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) and not PlayObject.m_boOffLinePlay) then
        begin
          if CheckAmulet(PlayObject, 1, 1, nAmuletIdx) then
          begin
            UseAmulet(PlayObject, 1, 1, nAmuletIdx);
            b := True;
          end;
        end
        else
          b := True;
        if b then
        begin
          case UserMagic.MagicInfo.wMagicId of
            SKILL_57 {噬血术}:
              begin
                if PlayObject.IsProperTarget(TargeTBaseObject) then
                begin
                  bb := (UserMagic.btLevel >= 4);
                  if bb or (Random(15) >= TargeTBaseObject.m_nantiMagic) then
                  begin
                    if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= 2) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= 2) then
                    begin
                      nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                      n14 := Round(nPower / 100 * g_Config.nMagSuckHpPowerRate);
                      if bb then
                        Inc(n14, 15);
                      PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 3, MakeLong(nTargetX, nTargetY), n14, Integer(TargeTBaseObject), '', 300, UserMagic.MagicInfo.wMagicId);
                      PlayObject.SendDelayMsg(PlayObject, RM_DELAYINCHEALTHSPELL, 0, Round(_MIN(PlayObject.m_WAbil.MaxHP div 3, nPower) / 100 * g_Config.nMagSuckHpRate), 0, Integer(PlayObject), '', 600);
                      if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
                        boTrain := True;
                    end;
                  end;
                end;
              end;
            SKILL_FIRECHARM {13}:
              begin
                if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then
                begin
                  if PlayObject.IsProperTarget(TargeTBaseObject) then
                  begin
                    if Random(10) >= TargeTBaseObject.m_nantiMagic then
                    begin
                      if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= 1) then
                      begin
                        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 1200, UserMagic.MagicInfo.wMagicId);
                        if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
                          boTrain := True;
                      end;
                    end;
                  end;
                end
                else
                  TargeTBaseObject := nil;
              end;
            SKILL_HANGMAJINBUB {14}:
              begin //幽灵盾
                nPower := PlayObject.GetAttackPower(GetPower13(60) + LoWord(PlayObject.m_WAbil.SC) * 10, SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                if PlayObject.MagMakeDefenceArea(nTargetX, nTargetY, 3, UserMagic.btLevel div 4 * 60 + nPower, 1, UserMagic.btLevel div 4) > 0 then
                  boTrain := True;
              end;
            SKILL_DEJIWONHO {15}:
              begin //神圣战甲术
                nPower := PlayObject.GetAttackPower(GetPower13(60) + LoWord(PlayObject.m_WAbil.SC) * 10, SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                if PlayObject.MagMakeDefenceArea(nTargetX, nTargetY, 3, UserMagic.btLevel div 4 * 60 + nPower, 0, UserMagic.btLevel div 4) > 0 then
                  boTrain := True;
              end;
            SKILL_HOLYSHIELD {16}:
              begin //捆魔咒
                if MagMakeHolyCurtain(PlayObject, GetPower13(40) + GetRPow(PlayObject.m_WAbil.SC) * 3, nTargetX, nTargetY, SKILL_HOLYSHIELD) > 0 then
                  boTrain := True;
              end;
            SKILL_SKELLETON {17}:
              begin //召唤骷髅
                if UserMagic.btLevel >= 4 then
                begin
                  if MagMakeSlave(PlayObject, UserMagic, nTargetX, nTargetY) then
                    boTrain := True;
                end
                else if MagMakeSlave(PlayObject, UserMagic) then
                begin
                  boTrain := True;
                end;
              end;
            SKILL_CLOAK {18}:
              begin //隐身术
                if MagMakePrivateTransparent(PlayObject, GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 3) then
                  boTrain := True;
              end;
            SKILL_BIGCLOAK {19}:
              begin //集体隐身术
                if MagMakeGroupTransparent(PlayObject, nTargetX, nTargetY,
                  GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 3) then
                  boTrain := True;
              end;
          end;
          boSpellFail := False;
        end;
      end;
    SKILL_TAMMING {20}:
      begin //诱惑之光
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          if TargeTBaseObject.m_btRaceServer <> rc_Escort then
          begin
            if MagTamming(PlayObject, TargeTBaseObject, nTargetX, nTargetY, _MIN(4, UserMagic.btLevel)) then
              boTrain := True;
          end;
        end;
      end;
    SKILL_SPACEMOVE {21}:
      begin //瞬息移动
        PlayObject.SendRefMsg(RM_MAGICFIRE, 0, MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY), Integer(TargeTBaseObject), '');
        boSpellFire := False;
        if MagSaceMove(PlayObject, _MIN(4, UserMagic.btLevel)) then
          boTrain := True;
      end;
    SKILL_EARTHFIRE {22}:
      begin //火墙
        if MagMakeFireCross(PlayObject, PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1), GetPower(10) + (Word(GetRPow(PlayObject.m_WAbil.MC)) shr 1), nTargetX, nTargetY, UserMagic.btLevel) > 0 then
          boTrain := True;
      end;
    SKILL_FIREBOOM {23}:
      begin //爆裂火焰
        if MagBigExplosion(PlayObject,
          PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) +
          LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC)
          - LoWord(PlayObject.m_WAbil.MC)) + 1),
          nTargetX,
          nTargetY,
          g_Config.nFireBoomRage, UserMagic.MagicInfo.wMagicId) then
          boTrain := True;
      end;
    SKILL_LIGHTFLOWER {24}:
      begin //地狱雷光
        if MagElecBlizzard(PlayObject, PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1)) then
          boTrain := True;
      end;
    SKILL_SHOWHP {28}:
      begin
        if (TargeTBaseObject <> nil) and not TargeTBaseObject.m_boShowHP then
        begin
          if Random(6) <= (_MIN(4, UserMagic.btLevel) + 3) then
          begin
            TargeTBaseObject.m_dwShowHPTick := GetTickCount();
            TargeTBaseObject.m_dwShowHPInterval := GetPower13(GetRPow(PlayObject.m_WAbil.SC) * 2 + 30) * 1000;
            TargeTBaseObject.SendDelayMsg(TargeTBaseObject, RM_DOOPENHEALTH, 0, 0, 0, 0, '', 1500);
            boTrain := True;
          end;
        end;
      end;
    SKILL_BIGHEALLING {29}:
      begin //群体治疗术
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC) * 2, SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) * 2 + 1);
        if MagBigHealing(PlayObject, nPower, nTargetX, nTargetY) then
          boTrain := True;
      end;
    SKILL_SINSU {30}:
      begin
        boSpellFail := True;
        b := False;
        if g_Config.boHeroNeedAmulet or ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) and not PlayObject.m_boOffLinePlay) then
        begin
          if CheckAmulet(PlayObject, 5, 1, nAmuletIdx) then
          begin
            UseAmulet(PlayObject, 5, 1, nAmuletIdx);
            b := True;
          end;
        end
        else
          b := True;
        if b then
        begin
          if UserMagic.btLevel >= 4 then
          begin
            if MagMakeSinSuSlave(PlayObject, UserMagic, nTargetX, nTargetY) then
              boTrain := True;
          end
          else if MagMakeSinSuSlave(PlayObject, UserMagic) then
          begin
            boTrain := True;
          end;
          boSpellFail := False;
        end;
      end;
    SKILL_SHIELD {31}:
      begin //魔法盾
        if PlayObject.MagBubbleDefenceUp(_MIN(5, UserMagic.btLevel), GetPower(GetRPow(PlayObject.m_WAbil.MC) + 15)) then
          boTrain := True;
      end;
    SKILL_KILLUNDEAD {32}:
      begin //圣言术
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          if TargeTBaseObject.m_btRaceServer <> rc_Escort then
          begin
            if MagTurnUndead(PlayObject, TargeTBaseObject, nTargetX, nTargetY, _MIN(5, UserMagic.btLevel)) then
              boTrain := True;
          end;
        end;
      end;
    SKILL_SNOWWIND {33}:
      begin //冰咆哮
        if MagBigExplosion(PlayObject,
          PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1), nTargetX, nTargetY, g_Config.nSnowWindRange, UserMagic.MagicInfo.wMagicId) then
          boTrain := True;
      end;
    SKILL_UNAMYOUNSUL {34}:
      begin //解毒术
        if TargeTBaseObject = nil then
        begin
          TargeTBaseObject := PlayObject;
          nTargetX := PlayObject.m_nCurrX;
          nTargetY := PlayObject.m_nCurrY;
        end;
        if PlayObject.IsProperFriend(TargeTBaseObject) or (PlayObject.m_btRaceServer = RC_HERO) then
        begin
          if Random(7) - (_MIN(4, UserMagic.btLevel) + 1) < 0 then
          begin
            if TargeTBaseObject.m_wStatusTimeArr[POISON_DECHEALTH] <> 0 then
            begin
              TargeTBaseObject.m_wStatusTimeArr[POISON_DECHEALTH] := 1;
              boTrain := True;
            end;
            if TargeTBaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0 then
            begin
              TargeTBaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR] := 1;
              boTrain := True;
            end;
            if TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] <> 0 then
            begin
              TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] := 1;
              boTrain := True;
            end;
            if TargeTBaseObject.m_wStatusTimeArr[POISON_FREEZE] <> 0 then
            begin
              TargeTBaseObject.m_wStatusTimeArr[POISON_FREEZE] := 1;
              boTrain := True;
            end;
            if TargeTBaseObject.m_wStatusTimeArr[POISON_SHOCKED] <> 0 then
            begin
              TargeTBaseObject.m_wStatusTimeArr[POISON_SHOCKED] := 1;
              boTrain := True;
            end;
            if TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] <> 0 then
            begin
              TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] := 1;
              boTrain := True;
            end;
            if TargeTBaseObject.m_wStatusTimeArr[POISON_DONTMOVE] <> 0 then
            begin
              TargeTBaseObject.m_wStatusTimeArr[POISON_DONTMOVE] := 1;
              //TargeTBaseObject.m_boTDBeffect := False;
              boTrain := True;
            end;
            if TargeTBaseObject.m_wStatusArrValue[6] <> 0 then
            begin
              TargeTBaseObject.m_dwStatusArrTimeOutTick[6] := 1;
              boTrain := True;
            end;
          end;
        end;
      end;
    SKILL_WINDTEBO {35}:
      if MagWindTebo(PlayObject, UserMagic) then
        boTrain := True; //冰焰
    SKILL_MABE {36}:
      begin
        with PlayObject do
          nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
        if MabMabe(PlayObject, TargeTBaseObject, nPower, _MIN(4, UserMagic.btLevel), nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId) then
          boTrain := True;
      end;
    SKILL_GROUPLIGHTENING {37 群体雷电术}:
      begin
        if MagGroupLightening(PlayObject, UserMagic, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, TargeTBaseObject, boSpellFire) then
          boTrain := True;
      end;
    SKILL_GROUPAMYOUNSUL {38 群体施毒术}:
      begin
        if MagGroupAmyounsul(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
          boTrain := True;
      end;
    SKILL_GROUPDEDING {39 地钉}:
      begin
        if GetTickCount - PlayObject.m_dwMagNailTick > g_Config.dwMagNailTick then
        begin
          PlayObject.m_dwMagNailTick := GetTickCount();
          if MagGroupDeDing(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
            boTrain := True;
        end
        else
          PlayObject.SysMsg('技能施展时间未到！', c_Red, t_Hint);
      end;
    SKILL_41:
      begin //狮子吼
        if MagGroupMb(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
          boTrain := True;
      end;
    SKILL_55:
      begin
        boSpellFail := True;
        b := False;
        if g_Config.boHeroNeedAmulet or ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) and not PlayObject.m_boOffLinePlay) then
        begin
          if CheckAmulet(PlayObject, 5, 1, nAmuletIdx) then
          begin
            UseAmulet(PlayObject, 5, 1, nAmuletIdx);
            b := True;
          end;
        end
        else
          b := True;
        if b then
        begin
          if MagMakeEidolonSlave(PlayObject, UserMagic) then
            boTrain := True;
          boSpellFail := False;
        end;
      end;
    SKILL_44:
      begin //结冰掌
        if MagHbFireBall(PlayObject, UserMagic, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, TargeTBaseObject) then
          boTrain := True;
      end;
    SKILL_45:
      begin //灭天火
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          if (Random(10) >= TargeTBaseObject.m_nantiMagic) then
          begin
            nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
            if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
              nPower := Round(nPower * 1.5);
            TargeTBaseObject.m_boDragonFireSkill := True;
            PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 600, UserMagic.MagicInfo.wMagicId);
            if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
              boTrain := True;
          end
          else
            TargeTBaseObject := nil
        end
        else
          TargeTBaseObject := nil;
      end;
    SKILL_46:
      begin //分身术
        if MagMakeSuperSlave(PlayObject, UserMagic) then
          boTrain := True;
      end;
    SKILL_47:
      begin //火龙气焰
        if MagBigExplosion(PlayObject, PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), 4), nTargetX, nTargetY, g_Config.nFireBoomRage, SKILL_47) then
          boTrain := True;
      end;
    SKILL_48:
      begin //气功波
        if MagPushArroundTaos(PlayObject, _MIN(4, UserMagic.btLevel)) > 0 then
          boTrain := True;
      end;
    SKILL_49:
      begin //净化术
        if TargeTBaseObject = nil then
        begin
          TargeTBaseObject := PlayObject;
          nTargetX := PlayObject.m_nCurrX;
          nTargetY := PlayObject.m_nCurrY;
        end;
        if PlayObject.IsProperFriend(TargeTBaseObject) or (PlayObject.m_btRaceServer = RC_HERO) then
        begin
          if Random(7) - (_MIN(4, UserMagic.btLevel) + 1) < 0 then
          begin
            if TargeTBaseObject.m_wStatusTimeArr[POISON_DECHEALTH] <> 0 then
            begin
              TargeTBaseObject.m_wStatusTimeArr[POISON_DECHEALTH] := 1;
              boTrain := True;
            end;
            if TargeTBaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0 then
            begin
              TargeTBaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR] := 1;
              boTrain := True;
            end;
            if TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] <> 0 then
            begin
              TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] := 1;
              boTrain := True;
            end;
          end;
        end;
      end;
    SKILL_50:
      begin
        if PlayObject <> nil then
        begin
          with PlayObject do
          begin

            if m_wStatusArrValue[2] = 0 then
            begin
              if GetTickCount - m_dwDoubleScTick > g_Config.DoubleScInvTime * 1000 then
              begin
                m_wStatusArrValue[2] := Round(((HiWord(PlayObject.m_WAbil.SC) - 2) / 100) * g_Config.nDoubleScRate);

                {nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                nPower := nPower div 10;
                if nPower = 0 then
                  nPower := Random(3);

                case UserMagic.btLevel of
                  0: nPower := 1 + Random(2);
                  1: nPower := Min(nPower, 2) + 3;
                  2: nPower := Min(nPower, 3) + 5;
                  3: nPower := Min(nPower, 2) + 8;
                else
                  nPower := Min(nPower, 2) + 10;
                end;}

                nPower := (UserMagic.btLevel + 1) * 3;

                {if IsHero or (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then
                  nPower := nPower * 10
                else if (PlayObject.m_btRaceServer = RC_HERO) then
                  nPower := 300;}

                m_dwStatusArrTimeOutTick[2] := GetTickCount + nPower * 1000;
                SysMsg(Format('道术瞬时提升%d，持续%d秒 ', [m_wStatusArrValue[2] + 2, nPower]), c_Cust, t_Hint, $DB, $FF);
                RecalcAbilitys();
                SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
                boTrain := True;
              end
              else
              begin
                SysMsg(Format('精神力凝聚失败，%d秒后才能释放', [(g_Config.DoubleScInvTime * 1000 + 1000 - GetTickCount + m_dwDoubleScTick) div 1000]), c_Cust, t_Hint, $38, $FF);
                boTrain := False;
              end;
            end
            else
            begin
              SysMsg('精神力凝聚失败', c_Cust, t_Hint, $38, $FF);
              boTrain := False;
            end;
          end;
        end;
      end;
    SKILL_51:
      begin //灵魂召唤术
        boTrain := True;
      end;
    SKILL_52:
      begin //诅咒术
        boTrain := True;
      end;
    SKILL_53:
      begin //灵魂召唤术
        boTrain := True;
      end;
    SKILL_54:
      begin //诅咒术
        boTrain := True;
      end;
    SKILL_58:
      begin //流星火雨
        if MagBigExplosionEx(PlayObject,
          PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
          SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1),
          nTargetX,
          nTargetY,
          1, SKILL_58) then
          boTrain := True;
      end;
    68, 78:
      begin
        MagGroupParalysis(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
        PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevel,
          MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
          MakeLong(PlayObject.m_nCurrX, PlayObject.m_nCurrY),
          Integer(PlayObject), sSendFalg);
        boTrainOk := True;
        Result := True;
        Exit;
      end;
    69:
      begin
        if UserMagic.btLevel >= 4 then
        begin
          if MagMakeSnowMonSlave(PlayObject, UserMagic, nTargetX, nTargetY) then
          begin
            boTrainOk := True;
            Result := True;
          end;
        end
        else if MagMakeSnowMonSlave(PlayObject, UserMagic) then
        begin
          boTrainOk := True;
          Result := True;
        end;
        PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevel,
          MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
          MakeLong(PlayObject.m_nCurrX, PlayObject.m_nCurrY),
          Integer(PlayObject), sSendFalg);
        Exit;
      end;
    70: boTrain := MagSoulRecall(PlayObject, TargeTBaseObject, _MIN(4, UserMagic.btLevel));
    71: boTrain := MagCaptureMonster(PlayObject, TargeTBaseObject, _MIN(4, UserMagic.btLevel), nTargetX, nTargetY);
    72:
      begin
        PlayObject.SendRefMsg(RM_MAGICFIRE, 0, MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY), Integer(TargeTBaseObject), '');
        boSpellFire := False;
        if MagPositionMove(PlayObject, nTargetX, nTargetY, _MIN(4, UserMagic.btLevel), UserMagic.MagicInfo.wMagicId) then
          boTrain := True;

      end;
    73: if PlayObject.MagBubbleDefenceUp(_MIN(4, UserMagic.btLevel), GetPower(GetRPow(PlayObject.m_WAbil.SC) + 15)) then
        boTrain := True;
    74:
      begin
        if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then
        begin
          if (GetTickCount - PlayObject.m_dwCloneSelfTick > g_Config.dwCloneSelfTime) then
          begin
            PlayObject.m_dwCloneSelfTick := GetTickCount();
            boSpellFire := False;
            if PlayObject.CloneSelf(_MIN(4, UserMagic.btLevel)) <> nil then
              boTrain := True;
          end
          else
            PlayObject.SysMsg('一定时间内不能连续使用分身术', c_Purple, t_Hint);
        end
        else
        begin
          boSpellFire := False;
          if PlayObject.CloneSelf(_MIN(4, UserMagic.btLevel)) <> nil then
            boTrain := True;
        end;
      end;
    75:
      begin
        boSpellFire := False;
        if PlayObject.MagShieldDefenceUp(_MIN(4, UserMagic.btLevel)) then
          boTrain := True;
      end;
    76:
      begin
        if MagMedusaEyes(PlayObject, UserMagic, nTargetX, nTargetY, 76) then
          boTrain := True;
      end;
    77:
      begin
        if PlayObject.MagPossessedUp(STATE_13, UserMagic.btLevel, g_Config.Skill77Time) then
        begin
          boTrainOk := True;
          Result := True;
        end;
        PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevel,
          MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
          MakeLong(PlayObject.m_nCurrX, PlayObject.m_nCurrY),
          Integer(PlayObject), sSendFalg);
        Exit;
      end;
    80:
      begin
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
          SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1) * 2;
        nPower := Round(nPower / 100 * g_Config.nMagicIceRainPowerRate);
        if MagicIceRain(PlayObject, nTargetX, nTargetY, nPower, UserMagic) then
        begin
          boTrain := True;
          //boSpellFail := False;
        end
        else
        begin
          boSpellFail := True;
          boSpellFire := False;
        end;
      end;
    81:
      begin
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.DC),
          SmallInt(HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC)) + 1) * 2;
        nPower := Round(nPower / 100 * g_Config.nPosMoveAttackPowerRate);
        if MagMoveXY(PlayObject, nTargetX, nTargetY, nPower, UserMagic) then
        begin
          boTrain := True;
          boSpellFail := False;
        end
        else
        begin
          boSpellFail := True;
          boSpellFire := False;
        end;
      end;
    82:
      begin
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),
          SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1) * 2;
        nPower := Round(nPower / 100 * g_Config.nMagicDeadEyePowerRate);
        if MagicDeadEye(PlayObject, nTargetX, nTargetY, nPower, UserMagic) then
        begin
          boTrain := True;
          //boSpellFail := False;
        end
        else
        begin
          boSpellFail := True;
          boSpellFire := False;
        end;
      end;
    118:
      begin
        if MagDragonRage(PlayObject, UserMagic) then
        begin
          PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevel,
            MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
            MakeLong(PlayObject.m_nCurrX, PlayObject.m_nCurrY),
            Integer(PlayObject), sSendFalg);
          Exit;
        end
        else
        begin
          boSpellFail := True;
          boSpellFire := False;
        end;
      end;

{$IF SERIESSKILL}
    104:
      begin //凤舞祭
        PlayObject.m_boSuperMode := True;
        PlayObject.m_dwSuperManTick := GetTickCount();
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
          nPower := Round(nPower * 1.82 / 100 * g_Config.nPowerRateOfSeriesSkill_104);
          nPower := PlayObject.GetSeriesSkillDamage(UserMagic.MagicInfo.wMagicId, nPower);
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 3, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 600, UserMagic.MagicInfo.wMagicId);
          if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
            boTrain := True;
          PlayObject.m_dwReadySeriesSkillTick := GetTickCount();
        end
        else
          TargeTBaseObject := nil;
      end;
    105:
      begin //惊雷爆
        PlayObject.m_boSuperMode := True;
        PlayObject.m_dwSuperManTick := GetTickCount();
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          //if (Random(10) >= TargeTBaseObject.m_nantiMagic) then begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
          nPower := Round(nPower * 1.98 / 100 * g_Config.nPowerRateOfSeriesSkill_105);
          nPower := PlayObject.GetSeriesSkillDamage(UserMagic.MagicInfo.wMagicId, nPower);
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 3, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 600, UserMagic.MagicInfo.wMagicId);
          if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
            boTrain := True;
          //end else TargeTBaseObject := nil
          PlayObject.m_dwReadySeriesSkillTick := GetTickCount();
        end
        else
          TargeTBaseObject := nil;
      end;
    106:
      begin //冰天雪地
        PlayObject.m_boSuperMode := True;
        PlayObject.m_dwSuperManTick := GetTickCount();
        nPower := Round(2.2 * PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1));
        nPower := Round(nPower / 100 * g_Config.nPowerRateOfSeriesSkill_106);
        nPower := PlayObject.GetSeriesSkillDamage(UserMagic.MagicInfo.wMagicId, nPower);
        if MagBigExplosion(PlayObject,
          nPower,
          nTargetX, nTargetY,
          2,
          UserMagic.MagicInfo.wMagicId) then
          boTrain := True;
        PlayObject.m_dwReadySeriesSkillTick := GetTickCount();
      end;
    107:
      begin //双龙破
        PlayObject.m_boSuperMode := True;
        PlayObject.m_dwSuperManTick := GetTickCount();
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          //if (Random(10) >= TargeTBaseObject.m_nantiMagic) then begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
          nPower := Round(nPower * 1.52 / 100 * g_Config.nPowerRateOfSeriesSkill_107);
          nPower := PlayObject.GetSeriesSkillDamage(UserMagic.MagicInfo.wMagicId, nPower);
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 3, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 900, UserMagic.MagicInfo.wMagicId);
          if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
            boTrain := True;
          //end else TargeTBaseObject := nil
        end
        else
          TargeTBaseObject := nil;
        PlayObject.m_dwReadySeriesSkillTick := GetTickCount();
      end;

    108:
      begin //虎啸诀
        PlayObject.MagTransparent(1);
        PlayObject.m_boSuperMode := True;
        PlayObject.m_dwSuperManTick := GetTickCount();
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          //if (Random(10) >= TargeTBaseObject.m_nantiMagic) then begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC - PlayObject.m_wStatusArrValue[2]) - LoWord(PlayObject.m_WAbil.SC)) + 1);
          nPower := Round(nPower * 1.62 / 100 * g_Config.nPowerRateOfSeriesSkill_108);
          nPower := PlayObject.GetSeriesSkillDamage(UserMagic.MagicInfo.wMagicId, nPower);
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 3, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 700, UserMagic.MagicInfo.wMagicId);
          if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
            boTrain := True;
          //end else TargeTBaseObject := nil
        end
        else
          TargeTBaseObject := nil;
        PlayObject.m_dwReadySeriesSkillTick := GetTickCount();
      end;
    109:
      begin //八卦掌
        PlayObject.MagTransparent(1);
        PlayObject.m_boSuperMode := True;
        PlayObject.m_dwSuperManTick := GetTickCount();
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          //if (Random(10) >= TargeTBaseObject.m_nantiMagic) then begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - PlayObject.m_wStatusArrValue[2] - LoWord(PlayObject.m_WAbil.SC)) + 1);
          nPower := Round(nPower * 1.75 / 100 * g_Config.nPowerRateOfSeriesSkill_109);
          nPower := PlayObject.GetSeriesSkillDamage(UserMagic.MagicInfo.wMagicId, nPower);
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 3, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 700, UserMagic.MagicInfo.wMagicId);
          if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
            boTrain := True;
        end
        else
          TargeTBaseObject := nil;
        PlayObject.m_dwReadySeriesSkillTick := GetTickCount();
      end;
    110:
      begin //三焰咒
        PlayObject.MagTransparent(1);
        PlayObject.m_boSuperMode := True;
        PlayObject.m_dwSuperManTick := GetTickCount();
        if PlayObject.IsProperTarget(TargeTBaseObject) then
        begin
          //if (Random(10) >= TargeTBaseObject.m_nantiMagic) then begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - PlayObject.m_wStatusArrValue[2] - LoWord(PlayObject.m_WAbil.SC)) + 1);
          nPower := Round(nPower * 1.98 / 100 * g_Config.nPowerRateOfSeriesSkill_110);
          nPower := PlayObject.GetSeriesSkillDamage(UserMagic.MagicInfo.wMagicId, nPower);
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 3, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 900, UserMagic.MagicInfo.wMagicId);
          if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
            boTrain := True;
        end
        else
          TargeTBaseObject := nil;
        PlayObject.m_dwReadySeriesSkillTick := GetTickCount();
      end;
    111:
      begin //万箭归宗
        PlayObject.MagTransparent(1);
        PlayObject.m_boSuperMode := True;
        PlayObject.m_dwSuperManTick := GetTickCount();
        nPower := Round(2.25 * PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - PlayObject.m_wStatusArrValue[2] - LoWord(PlayObject.m_WAbil.SC)) + 1));
        nPower := Round(nPower / 100 * g_Config.nPowerRateOfSeriesSkill_111);
        nPower := PlayObject.GetSeriesSkillDamage(UserMagic.MagicInfo.wMagicId, nPower);
        if MagBigExplosion(PlayObject,
          nPower,
          nTargetX, nTargetY,
          2,
          UserMagic.MagicInfo.wMagicId) then
        begin
          boTrain := True;
          PlayObject.m_dwReadySeriesSkillTick := GetTickCount();
        end;
      end;
    112:
      begin //旋转风火轮
        if MagBigExplosion(PlayObject,
          Round(1.45 * PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1)),
          nTargetX, nTargetY,
          2,
          UserMagic.MagicInfo.wMagicId) then
          boTrain := True;
      end;
    116:
      begin
        if MagExplosion_SS(PlayObject,
          Round(1.60 * PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1)),
          nTargetX, nTargetY,
          2,
          UserMagic.MagicInfo.wMagicId,
          UserMagic.btLevel) then
          boTrain := True;
      end;
    117:
      begin
        if MagExplosion_SS(PlayObject,
          Round(1.67 * PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1)),
          nTargetX, nTargetY,
          1,
          UserMagic.MagicInfo.wMagicId,
          UserMagic.btLevel) then
          boTrain := True;
      end;
{$IFEND SERIESSKILL}
  end;
  boTrainOk := boTrain;
  if boSpellFail then
    Exit;
  if boSpellFire then
    PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevel, MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY), Integer(TargeTBaseObject), sSendFalg);

  if ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or PlayObject.IsHero) and (UserMagic.btLevel < PlayObject.MagicMaxTrainLevel(UserMagic)) and boTrain then
  begin
    if UserMagic.wMagIdx in [100..111] then
      n1C := PlayObject.m_nInPowerLevel
    else
      n1C := PlayObject.m_Abil.Level;
    if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] <= n1C then
    begin
      PlayObject.TrainSkill(UserMagic, Random(3) + 1);
      if not PlayObject.CheckMagicLevelup(UserMagic) then
        PlayObject.SendDelayMsg(PlayObject, RM_MAGIC_LVEXP, 0, UserMagic.MagicInfo.wMagicId, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
    end;
  end;

  UserMagic := PlayObject.m_MagicArr[1][UserMagic.MagicInfo.wMagicId];
  if (UserMagic <> nil) then
  begin
    if PlayObject.m_nInPowerPoint >= 9 then
      Dec(PlayObject.m_nInPowerPoint, 9);
    if boTrain then
    begin
      if (UserMagic.btLevel < PlayObject.MagicMaxTrainLevel(UserMagic)) then
      begin
        if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] <= PlayObject.m_nInPowerLevel then
        begin
          PlayObject.TrainSkill(UserMagic, Random(3) + 1);
          if not PlayObject.CheckMagicLevelup(UserMagic) then
            PlayObject.SendDelayMsg(PlayObject, RM_MAGIC_LVEXP, 1, UserMagic.MagicInfo.wMagicId, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
        end;
      end;
    end;
  end;

  Result := True;
end;

function TMagicManager.MagMakePrivateTransparent(BaseObject: TBaseObject; nHTime: Integer): Boolean; //004930E8
var
  i: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  if BaseObject.m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] > 0 then
    Exit;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 9, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
    if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) and (TargeTBaseObject.m_TargetCret = BaseObject) then
    begin
      if (abs(TargeTBaseObject.m_nCurrX - BaseObject.m_nCurrX) > 1) or (abs(TargeTBaseObject.m_nCurrY - BaseObject.m_nCurrY) > 1) or (Random(2) = 0) then
      begin
        TargeTBaseObject.m_TargetCret := nil;
      end;
    end;
  end;
  BaseObjectList.Free;
  BaseObject.m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] := nHTime;
  BaseObject.m_nCharStatus := BaseObject.GetCharStatus();
  BaseObject.StatusChanged();
  BaseObject.m_boHideMode := True;
  BaseObject.m_boTransparent := True;
  Result := True;
end;

function TMagicManager.MagTamming(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY, nMagicLevel: Integer): Boolean; //00492368
var
  n14: Integer;
begin
  Result := False;
  if not (TargeTBaseObject.m_btRaceServer in [RC_PLAYOBJECT, RC_HERO]) and ((Random(4 - nMagicLevel) = 0)) then
  begin
    TargeTBaseObject.m_TargetCret := nil;
    if TargeTBaseObject.m_Master = BaseObject then
    begin
      TargeTBaseObject.OpenHolySeizeMode((nMagicLevel * 5 + 10) * 1000);
      Result := True;
    end
    else
    begin
      if Random(2) = 0 then
      begin
        if TargeTBaseObject.m_Abil.Level <= BaseObject.m_Abil.Level + 2 then
        begin
          if Random(3) = 0 then
          begin
            if Random((BaseObject.m_Abil.Level + 20) + (nMagicLevel * 5)) > (TargeTBaseObject.m_Abil.Level + g_Config.nMagTammingTargetLevel {10}) then
            begin
              if (TargeTBaseObject.m_btLifeAttrib = 0) and
                (TargeTBaseObject.m_Abil.Level < g_Config.nMagTammingLevel {50}) and
                (BaseObject.m_SlaveList.Count < g_Config.nMagTammingCount) then
              begin
                n14 := TargeTBaseObject.m_WAbil.MaxHP div g_Config.nMagTammingHPRate {100};
                if n14 <= 2 then
                  n14 := 2
                else
                  Inc(n14, n14);
                if (TargeTBaseObject.m_Master <> BaseObject) and (Random(n14) = 0) then
                begin
                  TargeTBaseObject.BreakCrazyMode();
                  if TargeTBaseObject.m_Master <> nil then
                    TargeTBaseObject.m_WAbil.HP := TargeTBaseObject.m_WAbil.HP div 10;

                  if TargeTBaseObject.m_boCanReAlive and (TargeTBaseObject.m_Master = nil) then
                  begin
                    TargeTBaseObject.m_boCanReAlive := False;
                    if (TargeTBaseObject.m_pMonGen <> nil) then
                    begin
                      if (TargeTBaseObject.m_pMonGen.nActiveCount > 0) then
                      begin
                        Dec(TargeTBaseObject.m_pMonGen.nActiveCount);
                      end;
                      TargeTBaseObject.m_pMonGen := nil;
                    end;
                  end;

                  TargeTBaseObject.m_Master := BaseObject;
                  //TargeTBaseObject.m_dwMasterRoyaltyTick := LongWord((Random(BaseObject.m_Abil.Level * 2) + (nMagicLevel shl 2) * 5 + 20) * 60 * 1000) + GetTickCount;
                  TargeTBaseObject.m_dwMasterRoyaltyTick := GetTickCount + Round((Random(BaseObject.m_Abil.Level * 2) + (nMagicLevel shl 2) * 5 + 20) * 60 / 10 * g_Config.dwMasterRoyaltyRate) * 1000;

                  TargeTBaseObject.m_btSlaveMakeLevel := nMagicLevel;
                  if TargeTBaseObject.m_dwMasterTick = 0 then
                    TargeTBaseObject.m_dwMasterTick := GetTickCount();
                  TargeTBaseObject.BreakHolySeizeMode();
                  if LongWord(1500 - nMagicLevel * 200) < LongWord(TargeTBaseObject.m_nWalkSpeed) then
                    TargeTBaseObject.m_nWalkSpeed := 1500 - nMagicLevel * 200;
                  if LongWord(2000 - nMagicLevel * 200) < LongWord(TargeTBaseObject.m_nNextHitTime) then
                    TargeTBaseObject.m_nNextHitTime := 2000 - nMagicLevel * 200;
                  TargeTBaseObject.RefShowName();
                  BaseObject.m_SlaveList.Add(TargeTBaseObject);
                end
                else
                begin
                  if Random(14) = 0 then
                    TargeTBaseObject.m_WAbil.HP := 0;
                end;
              end
              else
              begin
                if (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) and (Random(20) = 0) then
                  TargeTBaseObject.m_WAbil.HP := 0;
              end;
            end
            else
            begin
              if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) and (Random(20) = 0) then
                TargeTBaseObject.OpenCrazyMode(Random(20) + 10);
            end;
          end
          else
          begin
            if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then
              TargeTBaseObject.OpenCrazyMode(Random(20) + 10); //变红
          end;
        end;
      end
      else
        TargeTBaseObject.OpenHolySeizeMode((nMagicLevel * 5 + 10) * 1000);
      Result := True;
    end;
  end
  else
  begin
    if Random(2) = 0 then
      Result := True;
  end;
end;

function TMagicManager.MagTurnUndead(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY, nLevel: Integer): Boolean; //004926D4
var
  n14: Integer;
begin
  Result := False;
  if TargeTBaseObject.m_boSuperMan or (TargeTBaseObject.m_btRaceServer = RC_HERO) or not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then
    Exit;
  TAnimalObject(TargeTBaseObject).Struck {FFEC}(BaseObject);
  if TargeTBaseObject.m_TargetCret = nil then
  begin
    TAnimalObject(TargeTBaseObject).m_boRunAwayMode := True;
    TAnimalObject(TargeTBaseObject).m_dwRunAwayStart := GetTickCount();
    TAnimalObject(TargeTBaseObject).m_dwRunAwayTime := 10 * 1000;
  end;
  BaseObject.SetTargetCreat(TargeTBaseObject);
  if (Random(2) + (BaseObject.m_Abil.Level - 1)) > TargeTBaseObject.m_Abil.Level then
  begin
    if TargeTBaseObject.m_Abil.Level < g_Config.nMagTurnUndeadLevel then
    begin
      n14 := BaseObject.m_Abil.Level - TargeTBaseObject.m_Abil.Level;
      if Random(100) < ((nLevel shl 3) - nLevel + 15 + n14) then
      begin
        TargeTBaseObject.SetLastHiter(BaseObject);
        TargeTBaseObject.m_WAbil.HP := 0;
        Result := True;
      end
    end;
  end;
end;

function TMagicManager.MagWindTebo(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
var
  PoseBaseObject: TBaseObject;
begin
  Result := False;
  PoseBaseObject := PlayObject.GetPoseCreate;
  if (PoseBaseObject <> nil) and
    (PoseBaseObject <> PlayObject) and
    (not PoseBaseObject.m_boDeath) and
    (not PoseBaseObject.m_boGhost) and
    (PlayObject.IsProperTarget(PoseBaseObject, True)) and
    (not PoseBaseObject.m_boStickMode) then
  begin
    if (abs(PlayObject.m_nCurrX - PoseBaseObject.m_nCurrX) <= 1) and
      (abs(PlayObject.m_nCurrY - PoseBaseObject.m_nCurrY) <= 1) and
      (PlayObject.m_Abil.Level > PoseBaseObject.m_Abil.Level) then
    begin
      if Random(18) < _MIN(4, UserMagic.btLevel) * 6 + 6 + (PlayObject.m_Abil.Level - PoseBaseObject.m_Abil.Level) then
      begin
        PoseBaseObject.CharPushed(GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, PoseBaseObject.m_nCurrX, PoseBaseObject.m_nCurrY), _MAX(0, _MIN(4, UserMagic.btLevel) - 1) + 1);
        Result := True;
        PoseBaseObject.DMSkillFix();
      end;
    end;
  end;
end;

function TMagicManager.MagSaceMove(BaseObject: TBaseObject; nLevel: Integer): Boolean;
var
  Envir: TEnvirnoment;
  PlayObject: TPlayObject;
begin
  Result := False;
  if Random(11) < nLevel * 2 + 4 then
  begin
    BaseObject.SendRefMsg(RM_SPACEMOVE_FIRE2, 0, 0, 0, 0, '');
    if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
    begin
      Envir := BaseObject.m_PEnvir;
      BaseObject.MapRandomMove(BaseObject.m_sHomeMap, 1);
      if (Envir <> BaseObject.m_PEnvir) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then
      begin
        PlayObject := TPlayObject(BaseObject);
        PlayObject.m_boTimeRecall := False;
      end;
    end;
    Result := True;
  end;
end;

function TMagicManager.MagGroupAmyounsul(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  i, n, np: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
  StdItem: pTStdItem;
  nAmuletIdx: Integer;
begin
  Result := False;
  np := 0;
  if g_Config.boHeroNeedAmulet or ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) and not PlayObject.m_boOffLinePlay) then
  begin
    if CheckAmulet(PlayObject, 1, 2, nAmuletIdx) then
    begin
      StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[nAmuletIdx].wIndex);
      if StdItem <> nil then
      begin
        UseAmulet(PlayObject, 1, 2, nAmuletIdx);
        np := StdItem.Shape;
      end;
    end;
  end
  else
    np := PlayObject.m_btUseAmulet;
  if np <= 0 then
    Exit;

  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nTargetX, nTargetY, _MAX(1, _MIN(3, UserMagic.btLevel)), BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then
      Continue;
    if PlayObject.IsProperTarget(BaseObject, True) then
    begin
      if Random(BaseObject.m_btAntiPoison + 7) <= 6 then
      begin
        case np of
          1:
            begin
              nPower := GetPower13(40, UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;
              BaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DECHEALTH {中毒类型 - 绿毒}, nPower, Integer(PlayObject), UserMagic.btLevel div 4 * 10 + Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)) {UserMagic.btLevel}, '', 1000);
            end;
          2:
            begin
              nPower := GetPower13(30, UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;
              BaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DAMAGEARMOR {中毒类型 - 红毒}, nPower, Integer(PlayObject), UserMagic.btLevel div 4 * 10 + Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', 1000);
            end;
        end;
        if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
          Result := True;
        BaseObject.SetLastHiter(PlayObject);
        PlayObject.SetTargetCreat(BaseObject);
      end;
    end;
    if n > 99 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.Mag61(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  nDamage: Integer;
  BaseObject: TBaseObject;
  nPower, nPower2: Integer;
  nCX, nCY: Integer;
  WAbil: pTAbility;
begin
  Result := False;

  if PlayObject.IsHero then
  begin
    nPower := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.DC), SmallInt(HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC)) + 1) * 3.59 * (g_Config.nSkillTWPowerRate + PlayObject.m_wInPowerRateEx) / 100);
    WAbil := @PlayObject.m_Master.m_WAbil;
    nDamage := PlayObject.m_Master.GetAttackPower(LoWord(WAbil.SC), SmallInt((HiWord(WAbil.SC) - LoWord(WAbil.SC))));
  end
  else if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (PlayObject.m_HeroObject <> nil) then
  begin
    nPower := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.DC), SmallInt(HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC)) + 1) * 3.59 * (g_Config.nSkillTWPowerRate + PlayObject.m_wInPowerRateEx) / 100);
    WAbil := @PlayObject.m_HeroObject.m_WAbil;
    nDamage := PlayObject.m_HeroObject.GetAttackPower(LoWord(WAbil.SC), SmallInt((HiWord(WAbil.SC) - LoWord(WAbil.SC))));
  end;
  nPower := nPower + (nDamage div 2);

  for nCX := nTargetX - 3 to nTargetX + 3 do
  begin
    for nCY := nTargetY - 3 to nTargetY + 3 do
    begin
      if abs(nCX - nTargetX) = abs(nCY - nTargetY) then
      begin
        BaseObject := PlayObject.m_PEnvir.GetMovingObject(nCX, nCY, True);
        if PlayObject.IsProperTarget(BaseObject, True) then
        begin
          if BaseObject.m_btLifeAttrib = LA_UNDEAD then
            nPower2 := Round(nPower * 1.2)
          else
            nPower2 := nPower;
          BaseObject.m_boAttackedMag62 := True;
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower2, Integer(BaseObject), '', 100);
          if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
            Result := True;
        end;
      end;
    end;
  end;

  {if PlayObject.IsProperTarget(TargeTBaseObject, True) then begin
    if (Random(30) >= TargeTBaseObject.m_nantiMagic) then begin
      nPower := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.DC), SmallInt(HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC)) + 1) * 3.59 * (g_Config.nSkillTWPowerRate + PlayObject.m_wInPowerRateEx) / 100);
      if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
        nPower := Round(nPower * 1.5);
      TargeTBaseObject.m_boAttackedMag62 := True;
      PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 100);
      if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
        Result := True;
    end;
  end;}
end;

function TMagicManager.Mag62(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  BaseObject: TBaseObject;
  n, nPower: Integer;
  nCX, nCY: Integer;
begin
  Result := False;
  case PlayObject.m_btJob of
    0: n := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.DC), SmallInt(HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC)) + 1) * 3.58 * (g_Config.nSkillZWPowerRate + PlayObject.m_wInPowerRateEx) / 100);
    1: n := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1) * 3.08 * (g_Config.nSkillZWPowerRate + PlayObject.m_wInPowerRateEx) / 100);
    2: n := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1) * 3.18 * (g_Config.nSkillZWPowerRate + PlayObject.m_wInPowerRateEx) / 100);
  end;
  for nCX := nTargetX - 2 to nTargetX + 2 do
  begin
    for nCY := nTargetY - 2 to nTargetY + 2 do
    begin
      BaseObject := PlayObject.m_PEnvir.GetMovingObject(nCX, nCY, True);
      if PlayObject.IsProperTarget(BaseObject, True) then
      begin
        nPower := n;
        if BaseObject.m_btLifeAttrib = LA_UNDEAD then
          nPower := Round(n * 1.5);
        if ((abs(nCX - nTargetX) = 1) and (abs(nCY - nTargetY) in [0, 1])) or ((abs(nCX - nTargetX) in [0, 1]) and (abs(nCY - nTargetY) = 1)) then
          nPower := Round(n * 0.5)
        else if ((abs(nCX - nTargetX) = 2) and (abs(nCY - nTargetY) in [0..2])) or ((abs(nCX - nTargetX) in [0..2]) and (abs(nCY - nTargetY) = 2)) then
          nPower := Round(n * 0.2);
        //else if ((abs(nCX - nTargetX) = 3) and (abs(nCY - nTargetY) in [0..3])) or ((abs(nCX - nTargetX) in [0..3]) and (abs(nCY - nTargetY) = 3)) then
        //  nPower := Round(nPower * 0.3);
        BaseObject.m_boDragonFireSkill := True;
        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(BaseObject), '', 100);
        if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
          Result := True;
      end;
    end;
  end;
  {if PlayObject.IsProperTarget(TargeTBaseObject, True) then begin
    //if (Random(30) >= TargeTBaseObject.m_nantiMagic) then begin
    case PlayObject.m_btJob of
      0: nPower := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.DC), SmallInt(HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC)) + 1) * 3.58 * (g_Config.nSkillZWPowerRate + PlayObject.m_wInPowerRateEx) / 100);
      1: nPower := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1) * 3.08 * (g_Config.nSkillZWPowerRate + PlayObject.m_wInPowerRateEx) / 100);
      2: nPower := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1) * 3.18 * (g_Config.nSkillZWPowerRate + PlayObject.m_wInPowerRateEx) / 100);
    end;
    if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
      nPower := Round(nPower * 1.5);
    TargeTBaseObject.m_boDragonFireSkill := True;
    PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 100);
    if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
      Result := True;
    //end;
  end;}
end;

function TMagicManager.Mag63(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  i, n: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nTargetX, nTargetY, 3, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or BaseObject.m_boGhost or (PlayObject = BaseObject) then
      Continue;
    if not PlayObject.IsProperTarget(BaseObject, True) then
      Continue;
    if Random(BaseObject.m_btAntiPoison + 7) <= 6 then
    begin
      nPower := GetPower13(45, UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;
      BaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DECHEALTH, nPower, Integer(PlayObject), UserMagic.btLevel div 3 * 10 + Round((UserMagic.btLevel + 1) / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', 200);
    end;
    nPower := Round(PlayObject.GetAttackPower(LoWord(PlayObject.m_WAbil.SC), SmallInt((HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)))) * 1.62 * (g_Config.nSkillTTPowerRate + PlayObject.m_wInPowerRateEx) / 100);
    if Random(BaseObject.m_btSpeedPoint) >= PlayObject.m_btHitPoint then
      nPower := 0;
    if nPower > 0 then
    begin
      nPower := BaseObject.GetHitStruckDamage(PlayObject, nPower);
      nPower := Round(nPower * (g_Config.nMagNailPowerRate / 100));
    end;
    if nPower > 0 then
    begin
      BaseObject.StruckDamage(PlayObject, nPower, 63);
      PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 1, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), nPower, Integer(BaseObject), '', 300);
    end;
    if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
      Result := True;
    Inc(n);
    if n > 45 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.Mag64(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  BaseObject: TBaseObject;
  n, nPower: Integer;
  nCX, nCY: Integer;
begin
  Result := False;
  case PlayObject.m_btJob of
    0: n := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.DC), SmallInt(HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC)) + 1) * 2.90 * (g_Config.nSkillZTPowerRate + PlayObject.m_wInPowerRateEx) / 100);
    1: n := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1) * 3.15 * (g_Config.nSkillZTPowerRate + PlayObject.m_wInPowerRateEx) / 100);
    2: n := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1) * 3.28 * (g_Config.nSkillZTPowerRate + PlayObject.m_wInPowerRateEx) / 100);
  end;
  for nCX := nTargetX - 2 to nTargetX + 2 do
  begin
    for nCY := nTargetY - 2 to nTargetY + 2 do
    begin
      BaseObject := PlayObject.m_PEnvir.GetMovingObject(nCX, nCY, True);
      if PlayObject.IsProperTarget(BaseObject, True) then
      begin
        nPower := n;
        if BaseObject.m_btLifeAttrib = LA_UNDEAD then
          nPower := Round(n * 1.5);
        if ((abs(nCX - nTargetX) = 1) and (abs(nCY - nTargetY) in [0, 1])) or ((abs(nCX - nTargetX) in [0, 1]) and (abs(nCY - nTargetY) = 1)) then
          nPower := Round(n * 0.5)
        else if ((abs(nCX - nTargetX) = 2) and (abs(nCY - nTargetY) in [0..2])) or ((abs(nCX - nTargetX) in [0..2]) and (abs(nCY - nTargetY) = 2)) then
          nPower := Round(n * 0.2);
        //else if ((abs(nCX - nTargetX) = 3) and (abs(nCY - nTargetY) in [0..3])) or ((abs(nCX - nTargetX) in [0..3]) and (abs(nCY - nTargetY) = 3)) then
        //  nPower := Round(nPower * 0.3);
        BaseObject.m_boDragonFireSkill := True;
        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(BaseObject), '', 100);
        if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
          Result := True;
      end;
    end;
  end;

  {if PlayObject.IsProperTarget(TargeTBaseObject, True) then begin
    if (Random(20) >= TargeTBaseObject.m_nantiMagic) then begin
      case PlayObject.m_btJob of
        0: nPower := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.DC), SmallInt(HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC)) + 1) * 2.90 * (g_Config.nSkillZTPowerRate + PlayObject.m_wInPowerRateEx) / 100);
        1: nPower := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1) * 3.15 * (g_Config.nSkillZTPowerRate + PlayObject.m_wInPowerRateEx) / 100);
        2: nPower := Round(PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.SC), SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1) * 3.28 * (g_Config.nSkillZTPowerRate + PlayObject.m_wInPowerRateEx) / 100);
      end;
      if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
        nPower := Round(nPower * 1.5);
      TargeTBaseObject.m_boDragonFireSkill := True;
      PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 100);
      if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
        Result := True;
    end;
  end;}
end;

function TMagicManager.Mag65(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  i, n: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nTargetX, nTargetY, 3, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or BaseObject.m_boGhost or (PlayObject = BaseObject) then
      Continue;
    if not PlayObject.IsProperTarget(BaseObject, True) then
      Continue;
    //if (Random(60) >= BaseObject.m_nantiMagic) then begin
    nPower := Round(PlayObject.GetAttackPower(LoWord(PlayObject.m_WAbil.MC), SmallInt((HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)))) * 2.18 * (g_Config.nSkillZZPowerRate + PlayObject.m_wInPowerRateEx) / 100);
    if BaseObject.m_btLifeAttrib = LA_UNDEAD then
      nPower := Round(nPower * 1.5);
    BaseObject.m_boDragonFireSkill := True;
    PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(BaseObject), '', 900);
    if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
      Result := True;
    Inc(n);
    //end;
    if n > 45 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagGroupDeDing(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  i, n: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nTargetX, nTargetY, _MAX(1, _MIN(3, UserMagic.btLevel)), BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then
      Continue;
    if PlayObject.IsProperTarget(BaseObject, True) then
    begin
      nPower := PlayObject.GetAttackPower(LoWord(PlayObject.m_WAbil.DC), SmallInt((HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC))));
      if Random(BaseObject.m_btSpeedPoint) >= PlayObject.m_btHitPoint then
        nPower := 0;
      if nPower > 0 then
      begin
        nPower := BaseObject.GetHitStruckDamage(PlayObject, nPower);
        nPower := Round(nPower * (g_Config.nMagNailPowerRate / 100));
      end;
      if nPower > 0 then
      begin
        BaseObject.StruckDamage(PlayObject, nPower, 39);
        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 1, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), nPower, Integer(BaseObject), '', 200);
        PlayObject.SendRefMsg(RM_NORMALEFFECT, 0, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 1, '');
      end;
      if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
        Result := True;
      Inc(n);
    end;
    if n > 45 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagLightening(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
begin
  Result := False;
  if PlayObject.IsProperTarget(TargeTBaseObject, True) then
  begin
    if (Random(10) >= TargeTBaseObject.m_nantiMagic) then
    begin
      nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
      if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
        nPower := Round(nPower * 1.5);
      PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 600);
      if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
        Result := True;
    end;
  end;
end;

function TMagicManager.MagGroupLightening(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY, id: Integer; TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
var
  i, n: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  Result := False;
  boSpellFire := False;
  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nTargetX, nTargetY, _MAX(1, _MIN(3, UserMagic.btLevel)), BaseObjectList);
  PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevel, MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY), Integer(TargeTBaseObject), '');
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then
      Continue;
    if PlayObject.IsProperTarget(BaseObject, True) then
    begin
      if (Random(10) >= BaseObject.m_nantiMagic) then
      begin
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
        if BaseObject.m_btLifeAttrib = LA_UNDEAD then
          nPower := Round(nPower * 1.5);
        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), nPower, Integer(BaseObject), '', 600, id);
        if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
          Result := True;
        Inc(n);
      end;
      //if (BaseObject.m_nCurrX <> nTargetX) or (BaseObject.m_nCurrY <> nTargetY) then PlayObject.SendRefMsg(RM_10205, 0, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 4, '');
    end;
    if n > 45 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagHbFireBall(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY, id: Integer; var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  nDir: Integer;
  nPushCount: Integer;
begin
  Result := False;
  if not PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then
  begin
    TargeTBaseObject := nil;
    Exit;
  end;
  if not PlayObject.IsProperTarget(TargeTBaseObject, True) then
  begin
    TargeTBaseObject := nil;
    Exit;
  end;
  if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
    Result := True;
  if (PlayObject.m_Abil.Level > TargeTBaseObject.m_Abil.Level) and (not TargeTBaseObject.m_boStickMode) then
  begin
    if (Random(g_Config.nMagIceBallRange) < 6 + _MIN(4, UserMagic.btLevel) * 3) then
    begin
      nPushCount := Random(_MIN(4, UserMagic.btLevel));
      if nPushCount > 0 then
      begin
        nDir := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
        TargeTBaseObject.CharPushed(nDir, nPushCount);
        TargeTBaseObject.DMSkillFix();
      end;
    end;
  end;
  with PlayObject do
    nPower := GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
  PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 600, id);
end;

function TMagicManager.MagMakeFireCross(PlayObject: TPlayObject; nDamage, nHTime, nX, nY, nLevel: Integer): Integer; //00492C9C
var
  FireBurnEvent: TFireBurnEvent;
resourcestring
  sDisableInSafeZoneFireCross = '安全区不允许使用...';
begin
  Result := 0;
  if g_Config.boDisableInSafeZoneFireCross and PlayObject.InSafeZone(PlayObject.m_PEnvir, nX, nY) then
  begin
    PlayObject.SysMsg(sDisableInSafeZoneFireCross, c_Red, t_Notice);
    Exit;
  end;
  nDamage := Round(nDamage * (g_Config.nEarthFirePowerRate / 100));
  if PlayObject.m_PEnvir.GetEvent(nX, nY - 1) = nil then
  begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY - 1, ET_FIRE, nHTime * 1000, nDamage, nLevel div 4);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX - 1, nY) = nil then
  begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY, ET_FIRE, nHTime * 1000, nDamage, nLevel div 4);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX, nY) = nil then
  begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, ET_FIRE, nHTime * 1000, nDamage, nLevel div 4);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX + 1, nY) = nil then
  begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY, ET_FIRE, nHTime * 1000, nDamage, nLevel div 4);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX, nY + 1) = nil then
  begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY + 1, ET_FIRE, nHTime * 1000, nDamage, nLevel div 4);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  Result := 1;
end;

function TMagicManager.MagBigExplosion(BaseObject: TBaseObject; nPower, nX, nY: Integer; nRage, nmid: Integer): Boolean; //00492F4C
var
  i, n: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, nX, nY, nRage, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.IsProperTarget(TargeTBaseObject, True) then
    begin
      BaseObject.SetTargetCreat(TargeTBaseObject);
      TargeTBaseObject.SendMsg(BaseObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '', nmid);
      Result := True;
      Inc(n);
    end;
    if n > 45 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagBigExplosion_s(BaseObject: TBaseObject; nPower, nX, nY: Integer; nRage, nmid: Integer): Boolean; //00492F4C
var
  r: Real;
  i, n, p: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, nX, nY, nRage, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.IsProperTarget(TargeTBaseObject, True) then
    begin
      BaseObject.SetTargetCreat(TargeTBaseObject);
      r := Round((BaseObject.m_Abil.Level + 120) / 120);
      if r > 2.80 then
        r := 2.80;
      p := Round(nPower * r);
      TargeTBaseObject.SendMsg(BaseObject, RM_MAGSTRUCK, 0, p, 0, 0, '', nmid);
      Result := True;
      Inc(n);
    end;
    if n > 45 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagExplosion_SS(PlayObject: TPlayObject; nPower, nTargetX, nTargetY: Integer; nRage, nmid, lv: Integer): Boolean; //00492F4C
var
  BaseObject: TBaseObject;
  n: Integer;
  nCX, nCY: Integer;
  b: Boolean;
begin
  Result := False;
  b := False;
  n := nPower;
  Randomize();
  for nCX := nTargetX - nRage to nTargetX + nRage do
  begin
    for nCY := nTargetY - nRage to nTargetY + nRage do
    begin
      BaseObject := PlayObject.m_PEnvir.GetMovingObject(nCX, nCY, True);
      if PlayObject.IsProperTarget(BaseObject, True) then
      begin
        nPower := n;
        if BaseObject.m_btLifeAttrib = LA_UNDEAD then
          nPower := Round(n * 1.5);

        if ((abs(nCX - nTargetX) = 1) and (abs(nCY - nTargetY) in [0, 1])) or ((abs(nCX - nTargetX) in [0, 1]) and (abs(nCY - nTargetY) = 1)) then
        begin
          nPower := Round(n * 0.82);
        end
        else if ((abs(nCX - nTargetX) = 2) and (abs(nCY - nTargetY) in [0..2])) or ((abs(nCX - nTargetX) in [0..2]) and (abs(nCY - nTargetY) = 2)) then
        begin
          nPower := Round(n * 0.55)
        end
        else if ((abs(nCX - nTargetX) = 3) and (abs(nCY - nTargetY) in [0..3])) or ((abs(nCX - nTargetX) in [0..3]) and (abs(nCY - nTargetY) = 3)) then
        begin
          nPower := Round(nPower * 0.35);
        end;
        if Random(3) = 0 then
        begin
          if lv > Random(22) then
          begin
            BaseObject.m_btDoubleDamage := 1;
            b := True;
          end;
        end
        else
        begin
          if lv > Random(20) then
            BaseObject.m_btDoubleDamage := 2;
        end;

        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nRage + 1, MakeLong(nTargetX, nTargetY), nPower, Integer(BaseObject), '', 100, nmid);
        if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
          Result := True;
      end;
    end;
  end;
  if b then
    PlayObject.SendDelayMsg(PlayObject,
      RM_STRUCKEFFECTEX_DELAY,
      0,
      22,
      0,
      Integer(PlayObject),
      '', 160);
end;

function TMagicManager.MagBigExplosionEx(PlayObject: TPlayObject; nPower, nX, nY: Integer; nRage, nmid: Integer): Boolean;
var
  i, j, n: Integer;
  BaseObjectList: TList;
  BaseObjectA: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nX, nY, nRage, BaseObjectList);
  if BaseObjectList.Count > 0 then
  begin
    n := 0;
    nPower := Round(nPower * 1.67 * (g_Config.nMagicShootingStarPowerRate / 100));
    for i := 0 to BaseObjectList.Count - 1 do
    begin
      BaseObjectA := TBaseObject(BaseObjectList.Items[i]);
      if PlayObject.IsProperTarget(BaseObjectA, True) then
      begin
        PlayObject.SetTargetCreat(BaseObjectA);
        for j := 0 to 2 do
          PlayObject.SendDelayMsg(PlayObject,
            RM_DELAYMAGIC,
            5,
            MakeLong(nX, nY),
            nPower, //MakeLong(6, 6 {count}),
            Integer(BaseObjectA),
            '',
            1200 + j * 200, nmid);
        Result := True;
        Inc(n);
      end;
      if n > 20 then
        Break;
    end;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagElecBlizzard(BaseObject: TBaseObject; nPower: Integer): Boolean;
var
  i, n: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  nPowerPoint: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, BaseObject.m_nCurrX, BaseObject.m_nCurrY, g_Config.nElecBlizzardRange {2}, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
    if TargeTBaseObject.m_btLifeAttrib = 0 then
      nPowerPoint := nPower div 10
    else
      nPowerPoint := nPower;
    if BaseObject.IsProperTarget(TargeTBaseObject, True) then
    begin
      BaseObject.SetTargetCreat(TargeTBaseObject);
      TargeTBaseObject.SendMsg(BaseObject, RM_MAGSTRUCK, 0, nPowerPoint, 0, 0, '', SKILL_LIGHTFLOWER);
      Result := True;
      Inc(n);
    end;
    if n > 45 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagElecBlizzardEx(BaseObject: TBaseObject; nPower, nRage: Integer): Boolean;
var
  i, n: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  nPowerPoint: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, BaseObject.m_nCurrX, BaseObject.m_nCurrY, nRage, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
    if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
      nPowerPoint := Round(nPower * 1.3)
    else
      nPowerPoint := nPower;
    if BaseObject.IsProperTarget(TargeTBaseObject, True) then
    begin
      BaseObject.SetTargetCreat(TargeTBaseObject);
      TargeTBaseObject.SendMsg(BaseObject, RM_MAGSTRUCK, 0, nPowerPoint, 0, 0, '', SKILL_LIGHTFLOWER);
      Result := True;
      Inc(n);
    end;
    if n > 45 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagMakeHolyCurtain(BaseObject: TBaseObject; nPower: Integer; nX, nY, nmid: Integer): Integer;
var
  i, ii, nl: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  MagicEvent: pTMagicEvent;
  HolyCurtainEvent: THolyCurtainEvent;
begin
  Result := 0;
  if nPower > 240 then
    nPower := 240;

  if BaseObject.m_PEnvir.CanWalk(nX, nY, True) then
  begin
    nl := 5;
    if (TPlayObject(BaseObject).m_MagicArr[1][nmid] <> nil) then
    begin
      case TPlayObject(BaseObject).m_MagicArr[1][nmid].btLevel of
        0: nl := 5;
        1: nl := 10;
        2: nl := 20;
        3: nl := 40;
        4: nl := 50;
      else
        nl := 65;
      end;
    end;
    BaseObjectList := TList.Create;
    MagicEvent := nil;
    BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, nX, nY, 1, BaseObjectList);
    for i := 0 to BaseObjectList.Count - 1 do
    begin
      TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
      if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) and
        ((Random(4) + (BaseObject.m_Abil.Level + nl - 1)) > TargeTBaseObject.m_Abil.Level) and
        (TargeTBaseObject.m_Master = nil) and
        (TargeTBaseObject.m_btRaceServer <> rc_Escort) then
      begin
        TargeTBaseObject.OpenHolySeizeMode(nPower * 1000);
        if MagicEvent = nil then
        begin
          New(MagicEvent);
          for ii := 0 to 7 do
            MagicEvent.Events[ii] := nil;
          //FillChar(MagicEvent^, SizeOf(TMagicEvent), #0);
          MagicEvent.BaseObjectList := TList.Create;
          MagicEvent.dwStartTick := GetTickCount();
          MagicEvent.dwTime := nPower * 1000;
        end;
        MagicEvent.BaseObjectList.Add(TargeTBaseObject);
        Inc(Result);
      end
      else
      begin
        Result := 0;
        Break; //0405
      end;
    end;
    BaseObjectList.Free;
    if (Result > 0) and (MagicEvent <> nil) then
    begin
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 1, nY - 2, ET_HOLYCURTAIN, nPower * 1000);
      //g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[0] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 1, nY - 2, ET_HOLYCURTAIN, nPower * 1000);
      //g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[1] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 2, nY - 1, ET_HOLYCURTAIN, nPower * 1000);
      //g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[2] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 2, nY - 1, ET_HOLYCURTAIN, nPower * 1000);
      //g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[3] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 2, nY + 1, ET_HOLYCURTAIN, nPower * 1000);
      //g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[4] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 2, nY + 1, ET_HOLYCURTAIN, nPower * 1000);
      //g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[5] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 1, nY + 2, ET_HOLYCURTAIN, nPower * 1000);
      //g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[6] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 1, nY + 2, ET_HOLYCURTAIN, nPower * 1000);
      //g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[7] := HolyCurtainEvent;
      UserEngine.m_MagicEventList.Add(MagicEvent);
    end
    else if MagicEvent <> nil then
    begin
      MagicEvent.BaseObjectList.Free;
      Dispose(MagicEvent);
    end;
  end;
end;

function TMagicManager.MagMakeGroupTransparent(BaseObject: TBaseObject; nX, nY, nHTime: Integer): Boolean; //0049320C
var
  i, n: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, nX, nY, 1, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.IsProperFriend(TargeTBaseObject) or (BaseObject.m_btRaceServer = RC_HERO) then
    begin
      if TargeTBaseObject.m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] = 0 then
      begin
        TargeTBaseObject.SendDelayMsg(TargeTBaseObject, RM_TRANSPARENT, 0, nHTime, 0, 0, '', 800);
        Result := True;
        Inc(n);
      end;
    end;
    if n > 45 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MabMabe(BaseObject, TargeTBaseObject: TBaseObject; nPower, nLevel, nTargetX, nTargetY, id: Integer): Boolean;
var
  nLv: Integer;
begin
  Result := False;
  if BaseObject.MagCanHitTarget(BaseObject.m_nCurrX, BaseObject.m_nCurrY, TargeTBaseObject) then
  begin
    if BaseObject.IsProperTarget(TargeTBaseObject) then
    begin
      if (TargeTBaseObject.m_nantiMagic <= Random(10)) and (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= 1) then
      begin
        BaseObject.SendDelayMsg(BaseObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower div 3, Integer(TargeTBaseObject), '', 600);
        if (Random(2) + (BaseObject.m_Abil.Level - 1)) > TargeTBaseObject.m_Abil.Level then
        begin
          nLv := BaseObject.m_Abil.Level - TargeTBaseObject.m_Abil.Level;
          if (Random(g_Config.nMabMabeHitRandRate {100}) < _MAX(g_Config.nMabMabeHitMinLvLimit, (nLevel * 8) - nLevel + 15 + nLv)) then
          begin
            if (Random(g_Config.nMabMabeHitSucessRate {21}) < nLevel * 2 + 4) then
            begin
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
              begin
                BaseObject.SetPKFlag(BaseObject);
                BaseObject.SetTargetCreat(TargeTBaseObject);
              end;
              TargeTBaseObject.SetLastHiter(BaseObject);
              nPower := TargeTBaseObject.GetMagStruckDamage(BaseObject, nPower);
              BaseObject.SendDelayMsg(BaseObject, RM_DELAYMAGIC, 2, MakeLong(nTargetX, nTargetY), nPower, Integer(TargeTBaseObject), '', 600, id);
              if not TargeTBaseObject.m_boUnParalysis then
                TargeTBaseObject.SendDelayMsg(BaseObject, RM_POISON, POISON_STONE, nPower div g_Config.nMabMabeHitMabeTimeRate {20} + Random(nLevel), Integer(BaseObject), nLevel, '', 650);
              Result := True;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TMagicManager.MagMakeSnowMonSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic; nX: Integer; nY: Integer): Boolean;
var
  sMonName: string;
  nMakeLevel, nExpLevel: Integer;
  nCount: Integer;
  dwRoyaltySec: LongWord;
begin
  Result := False;
  if not PlayObject.MakeSinSuSlave then
  begin
    nExpLevel := UserMagic.btLevel;
    nMakeLevel := _MIN(4, UserMagic.btLevel);

    case nExpLevel of
      0, 1: sMonName := g_Config.sSnowMobName1;
      2: sMonName := g_Config.sSnowMobName2;
    else
      sMonName := g_Config.sSnowMobName3;
    end;

    nCount := 1;
    dwRoyaltySec := g_Config.IceMonLiveTime * 60;

    if nX >= 0 then
    begin
      if PlayObject.m_PEnvir <> nil then
      begin
        if PlayObject.m_PEnvir.CanWalk(nY, nY, True) then
        begin
          if PlayObject.MakeSlaveEx(sMonName, nX, nY, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
            Result := True;
        end
        else if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
          Result := True
        else
          PlayObject.SysMsg('目标不可达，不能召唤出属下', c_Red, t_Hint);
      end;
    end
    else if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
      Result := True;
  end;
end;

function TMagicManager.MagMakeSinSuSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic; nX: Integer; nY: Integer): Boolean;
var
  i: Integer;
  sMonName: string;
  nMakeLevel, nExpLevel: Integer;
  nCount: Integer;
  dwRoyaltySec: LongWord;
begin
  Result := False;
  if not PlayObject.MakeSinSuSlave then
  begin
    nExpLevel := UserMagic.btLevel;
    nMakeLevel := _MIN(4, UserMagic.btLevel);
    sMonName := g_Config.sDogz;
    if nExpLevel >= 4 then
      sMonName := g_Config.sDogz + IntToStr((nExpLevel div 4) + 4);
    nCount := g_Config.nDogzCount;
    dwRoyaltySec := 10 * 24 * 60 * 60;

    if not (nExpLevel >= 4) then
      for i := Low(g_Config.DogzArray) to High(g_Config.DogzArray) do
      begin
        if g_Config.DogzArray[i].nHumLevel = 0 then
          Break;
        if PlayObject.m_Abil.Level >= g_Config.DogzArray[i].nHumLevel then
        begin
          sMonName := g_Config.DogzArray[i].sMonName;
          nExpLevel := g_Config.DogzArray[i].nLevel;
          nCount := g_Config.DogzArray[i].nCount;
        end;
      end;
    if nX >= 0 then
    begin
      if PlayObject.m_PEnvir <> nil then
      begin
        if PlayObject.m_PEnvir.CanWalk(nY, nY, True) then
        begin
          if PlayObject.MakeSlaveEx(sMonName, nX, nY, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
            Result := True;
        end
        else if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
          Result := True
        else
          PlayObject.SysMsg('目标不可达,不能召唤神兽...', c_Red, t_Hint);
      end;
    end
    else if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
      Result := True;
  end;
end;

function TMagicManager.MagMakeEidolonSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
var
  sMonName: string;
  nMakeLevel, nExpLevel: Integer;
  nCount: Integer;
  dwRoyaltySec: LongWord;
begin
  Result := False;
  if not PlayObject.MakeSinSuSlave then
  begin
    sMonName := '月灵';
    nMakeLevel := UserMagic.btLevel;
    nExpLevel := UserMagic.btLevel;
    nCount := 1;
    dwRoyaltySec := 10 * 24 * 60 * 60;
    if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
      Result := True;
  end;
end;

function TMagicManager.MagMakeSuperSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
begin
  PlayObject.CmdRecallHero(nil, '', '', True);
  Result := True;
end;

function TMagicManager.MagMakeSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic; nX: Integer; nY: Integer): Boolean;
var
  i: Integer;
  sMonName: string;
  nMakeLevel, nExpLevel: Integer;
  nCount: Integer;
  dwRoyaltySec: LongWord;
begin
  Result := False;
  if not PlayObject.MakeSinSuSlave then
  begin
    nMakeLevel := _MIN(4, UserMagic.btLevel);
    nExpLevel := UserMagic.btLevel;
    sMonName := g_Config.sBoneFamm;

    if nExpLevel >= 4 then
      sMonName := g_Config.sBoneFamm + IntToStr(nExpLevel div 4);

    nCount := g_Config.nBoneFammCount;
    dwRoyaltySec := 10 * 24 * 60 * 60;

    if not (nExpLevel >= 4) then
      for i := Low(g_Config.BoneFammArray) to High(g_Config.BoneFammArray) do
      begin
        if g_Config.BoneFammArray[i].nHumLevel = 0 then
          Break;
        if PlayObject.m_Abil.Level >= g_Config.BoneFammArray[i].nHumLevel then
        begin
          sMonName := g_Config.BoneFammArray[i].sMonName;
          nExpLevel := g_Config.BoneFammArray[i].nLevel;
          nCount := g_Config.BoneFammArray[i].nCount;
        end;
      end;
    if nX > 0 then
    begin
      if PlayObject.m_PEnvir <> nil then
      begin
        if PlayObject.m_PEnvir.CanWalk(nY, nY, True) then
        begin
          if PlayObject.MakeSlaveEx(sMonName, nX, nY, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
            Result := True;
        end
        else if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
          Result := True
        else
          PlayObject.SysMsg('目标不可达,召唤失败...', c_Red, t_Hint);
      end;
    end
    else if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
      Result := True;
  end;
end;

function TMagicManager.MagGroupParalysis(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  i, n: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nTime: Integer;
begin
  Result := False;

  case UserMagic.btLevel of
    0: nTime := 01 * 1000;
    1: nTime := 03 * 1000;
    2: nTime := 06 * 1000;
    3: nTime := 10 * 1000;
  else
    nTime := 10 * 1000;
  end;
  PlayObject.m_dwUnParalysisTick := GetTickCount + nTime;
  PlayObject.m_dwUnParalysisTick2 := GetTickCount;
  if PlayObject.m_wStatusTimeArr[POISON_STONE] > 1 then
  begin
    PlayObject.m_wStatusTimeArr[POISON_STONE] := 1;
    PlayObject.SysMsg(Format('冲破石化状态，%d秒内防止被再次石化', [nTime div 1000]), c_Green, t_Hint);
  end
  else
    PlayObject.SysMsg(Format('%d秒内防止被石化', [nTime div 1000]), c_Green, t_Hint);

  if UserMagic.btLevel >= 3 then
  begin
    BaseObjectList := TList.Create;
    try
      PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, PlayObject.m_nCurrX, PlayObject.m_nCurrY, 3, BaseObjectList);
      n := 0;
      for i := 0 to BaseObjectList.Count - 1 do
      begin
        BaseObject := TBaseObject(BaseObjectList.Items[i]);
        if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then
          Continue;
        if PlayObject.IsProperTarget(BaseObject, True) then
        begin
          if not BaseObject.m_boUnParalysis and (GetTickCount >= BaseObject.m_dwUnParalysisTick) then
          begin
            BaseObject.MagPoison7(10, 3);
            Inc(n);
          end;
        end;
        if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
          Result := True;
        if n > 120 then
          Break;
      end;
    finally
      BaseObjectList.Free;
    end;
  end;
end;

function TMagicManager.MagGroupMb(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  i, n: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nTime: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  nTime := 2 * _MIN(4, UserMagic.btLevel) + Random(2) + 1;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, PlayObject.m_nCurrX, PlayObject.m_nCurrY, UserMagic.btLevel + 2, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if ((BaseObject.m_btRaceServer = RC_PLAYOBJECT) or BaseObject.IsHero) and (not g_Config.boGroupMbAttackPlayObject) then
      Continue;
    if (BaseObject.m_Master <> nil) and (not g_Config.boGroupMbAttackBaoBao) then
      Continue;
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then
      Continue;
    if PlayObject.IsProperTarget(BaseObject, True) then
    begin
      if (not BaseObject.m_boUnParalysis) and (not BaseObject.m_boFastParalysis) then
      begin
        if (BaseObject.m_Abil.Level < PlayObject.m_Abil.Level) or (Random(PlayObject.m_Abil.Level - BaseObject.m_Abil.Level) = 0) then
        begin
          BaseObject.MakePosion(nil, 0, POISON_STONE, nTime, 0);
          BaseObject.m_boFastParalysis := True;
          Inc(n);
        end;
      end;
    end;
    if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
      Result := True;
    if n > (_MIN(4, UserMagic.btLevel) + 1) * 15 then
      Break;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagPushArroundTaos(PlayObject: TBaseObject; nPushLevel: Integer): Integer;
var
  i, nDir, levelgap, push: Integer;
  BaseObject: TBaseObject;
begin
  Result := 0;
  for i := 0 to PlayObject.m_VisibleActors.Count - 1 do
  begin
    BaseObject := TBaseObject(pTVisibleBaseObject(PlayObject.m_VisibleActors.Items[i]).BaseObject);
    if (abs(PlayObject.m_nCurrX - BaseObject.m_nCurrX) <= 1) and (abs(PlayObject.m_nCurrY - BaseObject.m_nCurrY) <= 1) then
    begin
      if (not BaseObject.m_boDeath) and (BaseObject <> PlayObject) then
      begin
        if (PlayObject.m_Abil.Level >= BaseObject.m_Abil.Level) and (not
          BaseObject.m_boStickMode) then
        begin
          levelgap := PlayObject.m_Abil.Level - BaseObject.m_Abil.Level;
          if (Random(20) < 11 + nPushLevel * 3 + levelgap) then
          begin
            if PlayObject.IsProperTarget(BaseObject, True) then
            begin
              push := 1 + _MAX(0, nPushLevel - 1) + Random(2);
              nDir := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
              BaseObject.CharPushed(nDir, push);
              Inc(Result);
              BaseObject.DMSkillFix();
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TMagicManager.MagCaptureMonster(PlayObject: TPlayObject; TargeTBaseObject: TBaseObject; nLevel, nTargetX, nTargetY: Integer): Boolean;
var
  nX: Integer;
  nY: Integer;
  nRecallX: Integer;
  nRecallY: Integer;
  Buffer: array[0..255] of Byte;
begin
  Result := False;
  if (TargeTBaseObject <> nil) then
  begin
    if PlayObject.IsProperTarget(TargeTBaseObject) then
    begin
      if ((TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) or (g_Config.boMagCapturePlayer and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT))) and (not TargeTBaseObject.m_boStickMode) and not (TargeTBaseObject.m_btRaceServer in [RC_NPC, RC_PEACENPC]) then
      begin
        if PlayObject.m_Abil.Level {+ (nLevel * 1)} > TargeTBaseObject.m_Abil.Level then
        begin
          if (nLevel + 5) >= _MAX(abs(PlayObject.m_nCurrX - nTargetX), abs(PlayObject.m_nCurrY - nTargetY)) then
          begin
            if PlayObject.GetFrontPosition(nX, nY) then
            begin
              if PlayObject.GetRecallXY(nX, nY, 3, nRecallX, nRecallY) then
              begin
                if (PlayObject.m_PEnvir <> nil) and PlayObject.m_PEnvir.CanWalk(nRecallX, nRecallY, True) then
                begin
                  if TargeTBaseObject.m_PEnvir.DeleteFromMap(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY, OS_MOVINGOBJECT, TargeTBaseObject) > 0 then
                  begin
                    TargeTBaseObject.SendRefMsg(RM_DISAPPEAR, 0, 0, 0, 0, '');
                    TargeTBaseObject.m_nCurrX := nRecallX;
                    TargeTBaseObject.m_nCurrY := nRecallY;
                    if TargeTBaseObject.m_PEnvir.AddToMap(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY, OS_MOVINGOBJECT, TargeTBaseObject) = TargeTBaseObject then
                    begin
                      TargeTBaseObject.SendRefMsg(RM_DIGUP, TargeTBaseObject.m_btDirection, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY, 0, '');
                      TargeTBaseObject.SendRefMsg(RM_TURN, TargeTBaseObject.m_btDirection, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY, 0, TargeTBaseObject.GetShowName);
                      Result := True;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TMagicManager.MagSoulRecall(PlayObject: TPlayObject; TargeTBaseObject: TBaseObject; nLevel: Integer): Boolean;
var
  i, nX, nY, nRecallX, nRecallY: Integer;
  BaseObject: TBaseObject;
  //SlaveList                 : TList;
  Buffer: array[0..255] of Byte;
begin
  Result := False;
  with PlayObject do
  begin
    if (GetTickCount - m_dwDoRecallSlaveTick) > _MAX(1, ((8 - nLevel) * 1000)) then
    begin
      m_dwDoRecallSlaveTick := GetTickCount;
      {SlaveList := TList.Create;
      for i := 0 to m_SlaveList.Count - 1 do
        SlaveList.Add(TBaseObject(m_SlaveList.Items[i]));
      BaseObject := GetHeroObject;
      if BaseObject <> nil then
        SlaveList.Add(BaseObject);}
      for i := m_SlaveList.Count - 1 downto 0 do
      begin
        BaseObject := TBaseObject(m_SlaveList.Items[i]);
        if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, i + 1, nRecallX, nRecallY) then
        begin
          if not m_PEnvir.CanWalk(nRecallX, nRecallY, False) then
          begin
            GetFrontPosition(nX, nY);
            GetRecallXY(nX, nY, 3, nRecallX, nRecallY);
          end;
          with BaseObject do
          begin
            if (TargeTBaseObject <> nil) and PlayObject.IsProperTarget(TargeTBaseObject, True) then
            begin
              PlayObject.SetTargetCreat(TargeTBaseObject);
              SetTargetCreat(TargeTBaseObject);
            end
            else
            begin
              m_TargetCret := nil;
              PlayObject.m_TargetCret := nil;
            end;
            m_PEnvir.DeleteFromMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, BaseObject);
            SendRefMsg(RM_DISAPPEAR, 0, 0, 0, 0, '');
            m_nCurrX := nRecallX;
            m_nCurrY := nRecallY;
            m_btDirection := PlayObject.m_btDirection;
            m_PEnvir.AddToMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, BaseObject);
            SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
            SendRefMsg(RM_TURN, m_btDirection, m_nCurrX, m_nCurrY, 0, GetShowName);
            Result := True;
          end;
        end;
      end;
    end
    else
      SysMsg('技能施展时间未到!', c_Purple, t_Hint);
  end;
end;

function TMagicManager.MagPositionMove(PlayObject: TPlayObject; nX, nY, nLevel, nMagID: Integer): Boolean;
resourcestring
  sThePointCanMoveMsg = '你不能移动到当前位置!';
  sMoveFailMsg = '修炼等级不够,施展技能失效!';
  sTooFastMsg = '一定时间内不能连续使用此技能!';
begin
  Result := False;
  if PlayObject.m_PEnvir <> nil then
  begin
    if not PlayObject.m_PEnvir.CanWalk(nX, nY, False) or (abs(nX - PlayObject.m_nCurrX) > 20) or (abs(nY - PlayObject.m_nCurrY) > 20) then
    begin
      PlayObject.SysMsg(sThePointCanMoveMsg, c_Purple, t_Hint);
      Exit;
    end;
  end;
  if Random(11) > nLevel * 2 + 4 then
  begin
    PlayObject.SysMsg(sMoveFailMsg, c_Purple, t_Hint);
    Exit;
  end;
  if GetTickCount - PlayObject.m_dwDoFlyTick > 2500 then
  begin
    PlayObject.m_dwDoFlyTick := GetTickCount();
    PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE2, 0, 0, 0, 0, '');
    PlayObject.BaseObjectMove('', IntToStr(nX), IntToStr(nY));
    PlayObject.m_wStatusTimeArr[STATE_TRANSPARENT] := nLevel * 8 + 5;
    PlayObject.m_boHideMode := True;
    PlayObject.m_boTransparent := True;
    PlayObject.m_nCharStatus := PlayObject.GetCharStatus();
    PlayObject.StatusChanged();
    Result := True;
  end
  else
    PlayObject.SysMsg(sTooFastMsg, c_Purple, t_Hint);
end;

function TMagicManager.MagicDeadEye(PlayObject: TPlayObject; nX, nY, nPower: Integer; UserMagic: pTUserMagic): Boolean;
var
  i, n: Integer;
  xObjectList: TList;
  pBaseObject: TBaseObject;
begin
  Result := False;
  if GetTickCount - PlayObject.m_dwMagicIceRainTick > _MAX(5 * 1000, g_Config.nMagicDeadEyeInterval * 1000 - PlayObject.m_btReduceSpellTime * 1000) then
  begin
    PlayObject.m_dwMagicIceRainTick := GetTickCount();

    xObjectList := TList.Create;
    try
      n := 0;
      PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nX, nY, 3, xObjectList);

      for i := 0 to xObjectList.Count - 1 do
      begin
        pBaseObject := TBaseObject(xObjectList.Items[i]);
        if PlayObject.IsProperTarget(pBaseObject, True) then
        begin
          PlayObject.SetTargetCreat(pBaseObject);
          pBaseObject.SendMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '', UserMagic.wMagIdx);

          if g_Config.fMagicDeadEyeGreenPosion then
          begin
            pBaseObject.MakePosion(nil, 0, POISON_DECHEALTH, nPower div 2,
              UserMagic.btLevel div 4 * 10 + Round(UserMagic.btLevel / 3 * (nPower div 2 / g_Config.nAmyOunsulPoint)));
          end;

          if g_Config.fMagicDeadEyeRedPosion then
          begin
          pBaseObject.MakePosion(nil, 0, POISON_DAMAGEARMOR, nPower div 2,
            UserMagic.btLevel div 4 * 10 + Round(UserMagic.btLevel / 3 * (nPower div 2 / g_Config.nAmyOunsulPoint)));
          end;

          if ((pBaseObject.m_btRaceServer <> RC_PLAYOBJECT) and not pBaseObject.IsHero) and g_Config.fMagicDeadEyeParalysisPlayer then
            pBaseObject.MakePosion(nil, 0, POISON_STONE, _MIN(12, Round(UserMagic.btLevel * 1.5) + 1), 0);

          Inc(n);
        end;
        if n > 399 then
          Break;
      end;
    finally
      xObjectList.Free;
    end;

    Result := True;
  end
  else
  begin
    PlayObject.SysMsg(Format('%d秒后才能释放……',
      [(_MAX(5 * 1000, g_Config.nMagicDeadEyeInterval * 1000 - PlayObject.m_btReduceSpellTime * 1000) + 1000 - GetTickCount + PlayObject.m_dwMagicIceRainTick) div 1000]), c_Cust, t_Hint, $38, $FF);
  end;
end;

function TMagicManager.MagDragonRage(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
begin
  Result := False;
  if GetTickCount - PlayObject.m_dwDragonRageSkillTick > _MAX(5 * 1000, g_Config.nMagicDragonRageInterval * 1000 - PlayObject.m_btDragonRageSkillLevel * 1500) then
  begin
    PlayObject.m_dwDragonRageSkillTick := GetTickCount();

    PlayObject.MagPossessedUp(STATE_14, UserMagic.btLevel, g_Config.nMagicDragonRageDuration + UserMagic.btLevel * 2);

    Result := True;
  end
  else
  begin
    PlayObject.SysMsg(Format('%d秒后才能释放……',
      [(_MAX(5 * 1000, g_Config.nMagicDragonRageInterval * 1000 - PlayObject.m_btDragonRageSkillLevel * 1500) + 1000 - GetTickCount + PlayObject.m_dwDragonRageSkillTick) div 1000]), c_Cust, t_Hint, $38, $FF);
  end;
end;

function TMagicManager.MagicIceRain(PlayObject: TPlayObject; nX, nY, nPower: Integer; UserMagic: pTUserMagic): Boolean;
var
  nTargetX, nTargetY: Integer;
  xObjectList: TList;
  pBaseObject: TBaseObject;

  procedure MagicIceRainAttack();
  var
    i, n: Integer;
  begin
    n := 0;
    PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nTargetX, nTargetY, 2, xObjectList);

    for i := 0 to xObjectList.Count - 1 do
    begin
      pBaseObject := TBaseObject(xObjectList.Items[i]);
      if PlayObject.IsProperTarget(pBaseObject, True) then
      begin
        PlayObject.SetTargetCreat(pBaseObject);
        pBaseObject.SendMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '', UserMagic.wMagIdx);

        if ((pBaseObject.m_btRaceServer <> RC_PLAYOBJECT) and not pBaseObject.IsHero) or g_Config.fMagicIceRainParalysisPlayer then
          pBaseObject.MakePosion(nil, 0, POISON_STONE, _MIN(12, Round(UserMagic.btLevel * 1.5) + 1), 0);

        Result := True;
        Inc(n);
      end;
      if n > 199 then
        Break;
    end;
  end;

begin
  Result := False;
  if GetTickCount - PlayObject.m_dwMagicIceRainTick > _MAX(5 * 1000, g_Config.nMagicIceRainInterval * 1000 - PlayObject.m_btReduceSpellTime * 1000) then
  begin
    PlayObject.m_dwMagicIceRainTick := GetTickCount();

    xObjectList := TList.Create;
    try
      nTargetX := nX;
      nTargetY := nY;
      MagicIceRainAttack();

      xObjectList.Clear;
      nTargetX := nX - 2;
      nTargetY := nY - 3;
      MagicIceRainAttack();

      xObjectList.Clear;
      nTargetX := nX + 2;
      nTargetY := nY - 3;
      MagicIceRainAttack();

      xObjectList.Clear;
      nTargetX := nX + 2;
      nTargetY := nY + 3;
      MagicIceRainAttack();

      xObjectList.Clear;
      nTargetX := nX - 2;
      nTargetY := nY + 3;
      MagicIceRainAttack();
    finally
      xObjectList.Free;
    end;

    Result := True;
  end
  else
  begin
    PlayObject.SysMsg(Format('%d秒后才能释放……',
      [(_MAX(5 * 1000, g_Config.nMagicIceRainInterval * 1000 - PlayObject.m_btReduceSpellTime * 1000) + 1000 - GetTickCount + PlayObject.m_dwMagicIceRainTick) div 1000]), c_Cust, t_Hint, $38, $FF);
  end;
end;

function TMagicManager.MagMoveXY(PlayObject: TPlayObject; nX, nY, nPower: Integer; UserMagic: pTUserMagic): Boolean;
resourcestring
  sTagNoFreeMove = '目标不可到达';
  sFreeMoveFail = '施展技能失效';
  sTooFastMsg = '一定时间内不能连续使用此技能!';
begin
  Result := False;
  if PlayObject.m_PEnvir <> nil then
  begin
    if {not PlayObject.m_PEnvir.CanWalk(nX, nY, True) or}(abs(nX - PlayObject.m_nCurrX) > 15) or (abs(nY - PlayObject.m_nCurrY) > 15) then
    begin
      PlayObject.SysMsg(sTagNoFreeMove, c_Red, t_Hint);
      Exit;
    end;
    if not PlayObject.m_PEnvir.CanWalkOfItem(nX, nY, False, g_Config.fPosMoveAttackOnItem) then
    begin
      PlayObject.SysMsg(sTagNoFreeMove, c_Red, t_Hint);
      Exit;
    end;
  end
  else
  begin
    PlayObject.SysMsg(sFreeMoveFail, c_Red, t_Hint);
    Exit;
  end;
  if GetTickCount - PlayObject.m_dwDoFlyTick > _MAX(5 * 1000, g_Config.nPosMoveAttackInterval * 1000 - PlayObject.m_btReduceSpellTime * 1000) then
  begin
    PlayObject.m_dwDoFlyTick := GetTickCount();
    if (PlayObject.m_PEnvir <> nil) and
      (PlayObject.m_PEnvir.MoveToMovingObject(PlayObject.m_nCurrX, PlayObject.m_nCurrY, PlayObject, nX, nY, False) > 0) then
    begin
      PlayObject.SendDelayMsg(PlayObject, RM_DELAY_MAGIC, MakeWord(UserMagic.btLevel, UserMagic.wMagIdx), PlayObject.m_nCurrX, PlayObject.m_nCurrY, nPower, '', 200);
      PlayObject.m_nCurrX := nX;
      PlayObject.m_nCurrY := nY;
      Result := True;
    end
    else
      PlayObject.SysMsg(sTagNoFreeMove, c_Cust, t_Hint, $38, $FF);
  end
  else
  begin
    PlayObject.SysMsg(Format('%d秒后才能释放……',
      [(_MAX(5 * 1000, g_Config.nPosMoveAttackInterval * 1000 - PlayObject.m_btReduceSpellTime * 1000) + 1000 - GetTickCount + PlayObject.m_dwDoFlyTick) div 1000]), c_Cust, t_Hint, $38, $FF);
  end;
end;

function TMagicManager.MagMedusaEyes(PlayObject: TPlayObject; UserMagic: pTUserMagic; nX, nY: Integer; nmid: Integer): Boolean;
var
  i, n, nn, nRage, nTime: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
begin
  Result := False;
  case UserMagic.btLevel of
    0, 1: nRage := 1;
    2, 3: nRage := 2;
    4, 5: nRage := 3;
  else
    nRage := 4;
  end;

  nTime := _MIN(g_Config.SkillMedusaEyeEffectTimeMax, 8 + 2 * UserMagic.btLevel + Random(3) + 1);

  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nX, nY, nRage, BaseObjectList);
  n := 0;
  for i := 0 to BaseObjectList.Count - 1 do
  begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if PlayObject.IsProperTarget(BaseObject, True) then
    begin
      if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then
        Continue;

      if (not BaseObject.m_boUnParalysis) and (not BaseObject.m_boFastParalysis) then
      begin
        //if (BaseObject.m_Abil.Level < PlayObject.m_Abil.Level) or (Random(PlayObject.m_Abil.Level - BaseObject.m_Abil.Level) = 0) then begin
          //BaseObject.MakePosion(nil, 0, POISON_STONE, nTime, 0);

        nn := PlayObject.m_Abil.Level - BaseObject.m_Abil.Level;
        if nn > 0 then
          nTime := _MIN(g_Config.SkillMedusaEyeEffectTimeMax, nTime + Random(nn + 1));

        BaseObject.SendDelayMsg(PlayObject, RM_MAGMEDUSAEYE, UserMagic.btLevel + Random(UserMagic.btLevel + 2), nTime, 0, 0, '', 620, UserMagic.MagicInfo.wMagicId);
        PlayObject.SetTargetCreat(BaseObject);

        Inc(n);
        //end;
      end;

      Result := True;
      Inc(n);
    end;
    if n > (30 + UserMagic.btLevel * 10) then
      Break;
  end;
  BaseObjectList.Free;
end;

{
function TMagicManager.MagFreeMove(PlayObject: TPlayObject; nX, nY, nLevel, nMagid: Integer): Boolean;
resourcestring
  NoMapFreeMovemsg          = '当前地图禁止使用瞬移技能';
  TagNoFreeMove             = '不能移动到当前坐标';
  FreeMoveFail              = '施展技能失效';
begin
  Result := False;
  with PlayObject do begin
    if m_PEnvir <> nil then begin
      if m_PEnvir.m_MapFlag.boNOBATFLY then begin
        SysMsg(NoMapFreeMovemsg, c_Red, t_Hint);
        Exit;
      end;
      if not m_PEnvir.CanWalk(nX, nY, False) or (abs(nX - m_nCurrX) > 20) or (abs(nY - m_nCurrY) > 20) then begin
        SysMsg(TagNoFreeMove, c_Red, t_Hint);
        Exit;
      end;
    end;
    if Random(11) - ((nLevel * 2) + 4) > 0 then begin
      SysMsg(FreeMoveFail, c_Red, t_Hint);
      Exit;
    end;
    if GetTickCount - m_dwDoFlyTick > 2 * 1000 then begin
      m_dwDoFlyTick := GetTickCount();
      FreeMove(nX, nY, nMagid);
      if nMagid = 75 then begin
        PlayObject.m_wStatusTimeArr[STATE_TRANSPARENT] := GetRPow(PlayObject.m_WAbil.SC) + 20; //004931D2
        PlayObject.StatusChanged();
        PlayObject.m_boHideMode := True;
        PlayObject.m_boTransparentEx := True;
      end;
      Result := True;
    end;
  end;
end;

procedure TPlayObject.FreeMove(TagX, TagY, MagIdx: Integer);
var
  SendMessage               : TFreeMoveMessage;
  sChrName                  : string;
  BuffLen                   : Integer;
begin
  if m_PEnvir <> nil then begin
    if m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, TagX, TagY, False) > 0 then begin
      SendMessage.nParam1 := GetFeatureToLong;
      SendMessage.nParam2 := m_nCharStatus;
      SendMessage.wParam1 := m_WAbil.HP;
      SendMessage.wParam2 := m_WAbil.MaxHP;
      SendMessage.wParam3 := m_nCurrX;
      SendMessage.wParam4 := m_nCurrY;
      SendMessage.wParam5 := $FF0C;
      SendMessage.wParam6 := MagIdx;
      sChrName := GetShowName();
      BuffLen := _MIN(256, Length(sChrName));
      Move(sChrName, SendMessage.Buff, BuffLen);
      m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, TagX, TagY);
      m_nCurrX := TagX;
      m_nCurrY := TagY;
      SendRefMsg(RM_FREEMOVE, MakeWord(m_btDirection, MagIdx), m_nCurrX, m_nCurrY, 0, EncodeBuffer(@SendMessage, BuffLen + 20));
    end;
  end;
end;

        m_DefMsg := MakeDefaultMsg(SM_POSITIONFLY, Integer(ProcessMsg.BaseObject),
          ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
        SendSocket(@m_DefMsg, ProcessMsg.sMsg);

}

end.
