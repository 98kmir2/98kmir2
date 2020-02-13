unit ObjNpc;

interface

uses
  Windows, Classes, SysUtils, StrUtils, ObjBase, Grobal2, IniFiles, MD5;

type
  TUpgradeInfo = record
    sUserName: string[14];
    UserItem: TUserItem;
    btDc: byte;
    btSc: byte;
    btMc: byte;
    btDura: byte;
    dtTime: TDateTime;
    dwGetBackTick: LongWord;
  end;
  pTUpgradeInfo = ^TUpgradeInfo;

  TItemPrice = record
    wIndex: Word;
    nPrice: Integer;
  end;
  pTItemPrice = ^TItemPrice;

  TGoods = record
    sItemName: string[ItemNameLen];
    nCount: Integer;
    dwRefillTime: LongWord;
    dwRefillTick: LongWord;
  end;
  pTGoods = ^TGoods;

  TQuestActionInfo = record
    nCMDCode: Integer;
    sParam1: string;
    nParam1: Integer;
    sParam2: string;
    nParam2: Integer;
    sParam3: string;
    nParam3: Integer;
    sParam4: string;
    nParam4: Integer;
    sParam5: string;
    nParam5: Integer;
    sParam6: string;
    nParam6: Integer;
    sParam7: string;
    nParam7: Integer;
    sParam8: string;
    nParam8: Integer;
    sParam9: string;
    nParam9: Integer;
    sParam10: string;
    nParam10: Integer;
    sOpName: string;
    sOpHName: string;
  end;
  pTQuestActionInfo = ^TQuestActionInfo;

  TQuestConditionInfo = record
    nCMDCode: Integer;
    sParam1: string;
    nParam1: Integer;
    sParam2: string;
    nParam2: Integer;
    sParam3: string;
    nParam3: Integer;
    sParam4: string;
    nParam4: Integer;
    sParam5: string;
    nParam5: Integer;
    sParam6: string;
    nParam6: Integer;
    sOpName: string;
    sOpHName: string;
  end;
  pTQuestConditionInfo = ^TQuestConditionInfo;

  TSayingProcedure = record
    ConditionList: TList;
    ActionList: TList;
    sSayMsg: string;
    ElseActionList: TList;
    sElseSayMsg: string;
  end;
  pTSayingProcedure = ^TSayingProcedure;

  TSayingRecord = record
    sLabel: string;
    ProcedureList: TList;
    boExtJmp: Boolean;
  end;
  pTSayingRecord = ^TSayingRecord;

  TNormNpc = class(TAnimalObject)
    m_nFlag: ShortInt; //用于标识此NPC是否有效，用于重新加载NPC列表(-1 为无效)
    m_ScriptList: TList;
    m_sFilePath: string; //脚本文件所在目录
    m_boIsHide: Boolean; //此NPC是否是隐藏的，不显示在地图中
    m_boIsQuest: Boolean; //NPC类型为地图任务型的，加载脚本时的脚本文件名为 角色名-地图号.txt
    m_sPath: string;

    m_LastOprObject: TPlayObject;
    m_LastOprLabel: string;
    m_OprCount: Integer;
    m_dwGotoLabelTick: LongWord;
    m_sMDlgImgName: string;
  private
    procedure ScriptActionError(PlayObject: TPlayObject; sErrMsg: string; QuestActionInfo: pTQuestActionInfo; sCmd: string);
    procedure ScriptConditionError(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo; sCmd: string);
    procedure ExeAction(PlayObject: TPlayObject; sParam1, sParam2, sParam3: string; nParam1, nParam2, nParam3: Integer);
    procedure ActionOfChangeLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeAttackMode(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfChangeIPLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeTranPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeHeroLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfCreateMapNimbus(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKillSlaveName(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUnMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUnMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGiveItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGiveItemEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfCONFERTITLE(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDEPRIVETITLE(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfPlaySound(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfWebBrowser(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfOpenStorageView(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfTakeOn(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetScriptTimer(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKillScriptTimer(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfGetMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGetMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearHeroSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelNoJobSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAddSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSkillLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfHeroSkillLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfChangePkPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeHeroPkPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeIPExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeHeroExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeCreditPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeHeroCreditPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfChangeJob(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeHeroJob(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRecallGroupMembers(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGroupMembersMapMove(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearNameList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMapTing(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMobPlace(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nX, nY, nCount, nRange: Integer);
    procedure ActionOfSetMemberType(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetMemberLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGameStone(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGameGird(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfBonusAbil(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDropItemMap(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfReadRandomStr(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfReadRandomLine(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeMonPos(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfNimbus(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAbilityAdd(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfGamePoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAutoAddGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
    procedure ActionOfAutoSubGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
    procedure ActionOfChangeHairStyle(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfOpenGameGoldDeal(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfQueryGameGoldDeal(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfQueryGameGoldSell(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfLineMsg(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfScrollMsg(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetMerchantDlgImgName(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfChangeNameColor(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearPassword(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfReNewLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeGender(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKillSlave(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKillMonExpRate(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfPowerRate(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfStatusRate(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionofDETOXIFCATION(PlayObject: TPlayObject);
    procedure ActionOfNameColor(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeMode(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangePerMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKick(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfBonusPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRestReNewLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearNeedItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearMakeItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUpgradeItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUpgradeItemsEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMonGenEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMonGenEx2(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMoveToEscort(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfEscortFinish(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGiveUpEscort(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfClearMapMon(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearMapItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfAddMapRoute(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelMapRoute(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    //procedure ActionOfDGetGroupMembersCount(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfSetMapMode(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfPkZone(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRestBonusPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfTakeCastleGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfHumanHP(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfHumanMP(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildBuildPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildAuraePoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildstabilityPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildFlourishPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfOpenMagicBox(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetRankLevelName(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGmExecute(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildChiefItemCount(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAddNameDateList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelNameDateList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMobFireBurn(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMessageBox(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetScriptFlag(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAutoGetExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRecallmob(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRecallmobEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfLoadVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSaveVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfCalcVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelayCall(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfOffLine(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfOffLinePlay(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfSetOffLine(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSTARTTAKEGOLD(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearEctype(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo); //blue
    procedure ActionOfSetChatColor(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetChatFont(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildMapMove(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAddGuild(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRepairAllItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfCreateHero(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfCreateHeroEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfDeleteHero(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfTagMapInfo(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfTagMapMove(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRecallPlayer(PlayObject: TPlayObject; sCharName: string);
    procedure ActionOfRecallHero(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAffiliateGuild(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMapMoveHuman(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClientSetTargetXY(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfQueryBagItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetAttribute(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfQueryItemDlg(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfQueryValue(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfReleaseCollectExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfReSetCollectExpState(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGetStrLength(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGetPoseName(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfChangeVenationLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeVenationPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearVenationData(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfConvertSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfUpgradeDlgItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    function ActionOfDeleteDlgItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo): Boolean;
    procedure ActionOfGetDlgItemValue(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfWriteLineList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDeleteLineList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    function ConditionOfCheckMission(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckTitle(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfGiveItem(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfUnSealItem(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNimbusItemCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckAttackMode(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckEscortInNear(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfIsEscortIng(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckMapNimbusCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckVenationLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckCurrentDate(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGroupCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseDir(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseGender(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseMarry(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckLevelEx(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIPLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckHeroLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSlaveCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckBonusPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckAccountIPList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNameIPList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMarry(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMarryCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfHaveMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfPoseHaveMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckIsMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseIsMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckHaveGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsGuildMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsCastleaGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsCastleMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMemberType(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMemBerLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGameGold(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNimbus(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckGameDiamond(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGameGird(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCHECKMASTERONLINE(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCHECKDEARONLINE(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCHECKMASTERONMAP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCHECKDEARONMAP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCHECKPOSEISPRENTICE(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckGamePoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNameListPostion(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    //function ConditionOfCheckStringListPostion(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    // function ConditionOfCheckGuildList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
   
    function ConditionOfCheckReNewLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSlaveLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSlaveName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckOffLinePlayerCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckHeroOnLine(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    //function ConditionOfCheckOffLinePlay(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckHeroCreditPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCreditPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckOfGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPayMent(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckUseItem(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckBagSize(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckListCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckDC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckHP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckItemType(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    // function ConditionOfCheckItemLuck(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckExp(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleGold(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPasswordErrorCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfIsLockPassword(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfIsHigh(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfIsLockStorage(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGuildBuildPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGuildAuraePoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckStabilityPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckFlourishPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckContribution(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCHECKRANGEMONCOUNT(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCHECKRANGEMONCOUNTEX(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckItemAddValue(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckDlgItemAddValue(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckDlgItemType(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckDlgItemName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPosDlgItemName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckInMapRange(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsAttackGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsDefenseGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleDoorStatus(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsAttackAllyGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsDefenseAllyGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleChageDay(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleWarDay(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckOnlineLongMin(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckChiefItemCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNameDateList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMapHumanCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMapRangeHumanCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCHECKMAPMONCOUNT(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckVar(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckServerName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function GetDynamicVarList(PlayObject: TPlayObject; sType: string; var sName: string): TList;
    function ConditionOfCheckIsOnMap(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfIsSameGuildOnMap(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIniSectionExists(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    procedure ActionOfReadIniText(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfWriteIniText(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAutoMove(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGetTitlesCount(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    function ActionOfCheckActiveTitle(PlayObject: TPlayObject; QuestActionInfo: pTQuestConditionInfo): Boolean;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Initialize(); override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
    procedure Click(PlayObject: TPlayObject); virtual;
    procedure UserSelect(PlayObject: TPlayObject; sData: string); virtual;
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); virtual;
    function GetLineVariableText(PlayObject: TPlayObject; sMsg: string): string;
    procedure GotoLable(ActObject: TPlayObject; sLabel: string; boExtJmp: Boolean; sMsg: string = '');
    function ExVariableText(sMsg, sStr, sText: string): string;
    procedure LoadNpcScript();
    procedure ClearScript(); virtual;
    procedure SendMsgToUser(PlayObject: TPlayObject; sMsg: string);
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); virtual;
    function GetSellOffItemCount(PlayObject: TPlayObject): Integer;
    function CheckOnPostSell(sCharName: string; var DateTime: TDateTime): Boolean;
  end;

  TMerchant = class(TNormNpc)
    m_sScript: string;
    m_nPriceRate: Integer;
    m_boNoSeal: Boolean;
    m_boCastle: Boolean;
    dwRefillGoodsTick: LongWord;
    dwClearExpreUpgradeTick: LongWord;
    m_ItemTypeList: TList;
    m_SellOffList: TList;
    m_SellgoldList: TList;
    m_PostSellList: TList;
    m_PostGoldList: TList;
    m_RefillGoodsList: TList;
    m_GoodsList: TList;
    m_ItemPriceList: TList;
    m_UpgradeWeaponList: TList;
    m_boCanMove: Boolean;
    m_dwMoveTime: LongWord;
    m_dwMoveTick: LongWord;
    m_boBuy: Boolean;
    m_boSell: Boolean;
    m_boMakeDrug: Boolean;
    m_boPrices: Boolean;
    m_boStorage: Boolean;
    m_boGetback: Boolean;
    m_boUpgradenow: Boolean;
    m_boGetBackupgnow: Boolean;
    m_boRepair: Boolean;
    m_boS_repair: Boolean;
    m_boSendmsg: Boolean;
    m_boGetMarry: Boolean;
    m_boGetMaster: Boolean;
    m_boDealGold: Boolean;
    m_boUseItemName: Boolean;
    m_boOffLineMsg: Boolean;
    m_boMakeHero: Boolean;
    m_boCreateHero: Boolean;
    m_boInputInteger: Boolean;
    m_boInputString: Boolean;
    m_boYBDeal: Boolean;
    m_boItemMarket: Boolean;
  private
    procedure ClearExpreUpgradeListData();
    function CheckItemType(nStdMode: Integer): Boolean;
    procedure CheckItemPrice(nIndex: Integer);
    function GetRefillList(nIndex: Integer): TList;
    procedure AddItemPrice(nIndex, nPrice: Integer);
    function GetSellItemPrice(nPrice: Integer): Integer;
    function AddItemToGoodsList(UserItem: pTUserItem): Boolean;
    procedure GetBackupgWeapon(User: TPlayObject);
    procedure UpgradeWapon(User: TPlayObject);
    procedure ChangeUseItemName(PlayObject: TPlayObject; sLabel, sItemName: string);
    procedure StartDealGold(PlayObject: TPlayObject; sLabel, sGold: string);
    procedure RemoteMusic(PlayObject: TPlayObject; sLabel, sChrName: string);
    procedure RemoteMsg(PlayObject: TPlayObject; sLabel, sChrName: string);
    procedure SetOffLineMsg(PlayObject: TPlayObject; sMsg: string);
    procedure SaveUpgradingList;
    procedure GetMarry(PlayObject: TPlayObject; sDearName: string);
    procedure GetMaster(PlayObject: TPlayObject; sMasterName: string);   
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
    procedure UserSelect(PlayObject: TPlayObject; sData: string); override;
    procedure LoadNPCData();
    procedure SaveNPCData();
    procedure SaveSellOff();
    procedure SaveSellGold();
    procedure LoadUpgradeList();
    procedure RefillGoods();
    procedure LoadNpcScript();
    procedure Click(PlayObject: TPlayObject); override;
    procedure ClearScript(); override;
    procedure ClearData();

    procedure SendUserMarket(hum: TPlayObject; ItemType: Integer; UserMode: Integer);
    function GetItemPrice(nIndex: Integer): Integer;
    function GetUserPrice(PlayObject: TPlayObject; nPrice: Integer): Integer;

    function GetExchgItemBookCnt(UserItem: pTUserItem): Integer;
    function GetUserItemPrice(UserItem: pTUserItem): Integer;
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); override; //FFE9
    procedure ClientBuyItem(PlayObject: TPlayObject; sItemName: string; nInt, BuyCount: Integer);
    procedure ClientBuySaleItem(PlayObject: TPlayObject; sItemName: string; nMakeIndex: Integer);
    procedure ClientGetDetailGoodsList(PlayObject: TPlayObject; sItemName: string; nInt: Integer; nIdent: Integer);
    procedure ClientGetSaleItemList(PlayObject: TPlayObject; sItemName: string; nZz: Integer);
    procedure ClientQueryExchgBook(PlayObject: TPlayObject; UserItem: pTUserItem);
    procedure ClientQuerySellPrice(PlayObject: TPlayObject; UserItem: pTUserItem);
    function ClientSellItem(PlayObject: TPlayObject; UserItem: pTUserItem): Boolean;
    function ClientSellCountItem(PlayObject: TPlayObject; UserItem: pTUserItem; nCount: Integer): Boolean;
    procedure ClientMakeDrugItem(PlayObject: TPlayObject; sItemName: string);
    procedure ClientQueryRepairCost(PlayObject: TPlayObject; UserItem: pTUserItem);
    function ClientRepairItem(PlayObject: TPlayObject; UserItem: pTUserItem): Boolean;
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); override;
    Function  GetGoodString():string;
    procedure SendMerchandise(PlayObject: TPlayObject; sMsg: string);
  end;

  TGuildOfficial = class(TNormNpc)
  private
    function ReQuestBuildGuild(PlayObject: TPlayObject; sGuildName: string): Integer;
    function ReQuestGuildWar(PlayObject: TPlayObject; sGuildName: string): Integer;
    procedure DoNate(PlayObject: TPlayObject);
    procedure ReQuestCastleWar(PlayObject: TPlayObject; sIndex: string);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); override;
    procedure Run; override;
    procedure Click(PlayObject: TPlayObject); override;
    procedure UserSelect(PlayObject: TPlayObject; sData: string); override;
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); override;
  end;

  TTrainer = class(TNormNpc)
    m_dw568: LongWord;
    n56C: Integer;
    n570: Integer;
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
  end;

  TCastleOfficial = class(TMerchant)
  private
    procedure HireArcher(sIndex: string; PlayObject: TPlayObject);
    procedure HireGuard(sIndex: string; PlayObject: TPlayObject);
    procedure RepairDoor(PlayObject: TPlayObject);
    procedure RepairWallNow(nWallIndex: Integer; PlayObject: TPlayObject);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Click(PlayObject: TPlayObject); override;
    procedure UserSelect(PlayObject: TPlayObject; sData: string); override;
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); override;
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); override;
  end;

implementation

uses Castle, M2Share, HUtil32, LocalDB, Envir, Guild, EDcode, ObjMon2, Event, IdSrvClient, ObjMon;

procedure TCastleOfficial.Click(PlayObject: TPlayObject);
begin
  if m_Castle = nil then
  begin
    PlayObject.SysMsg('NPC不属于城堡', c_Red, t_Hint);
    Exit;
  end;
  if TUserCastle(m_Castle).IsMasterGuild(TGuild(PlayObject.m_MyGuild)) or (PlayObject.m_btPermission >= 3) then
    inherited;
end;

procedure TCastleOfficial.GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string);
var
  sText: string;
  CastleDoor: TCastleDoor;
begin
  inherited;
  if m_Castle = nil then
  begin
    sMsg := '????';
    Exit;
  end;
  if sVariable = '$CASTLEGOLD' then
  begin
    sText := IntToStr(TUserCastle(m_Castle).m_nTotalGold);
    sMsg := ExVariableText(sMsg, '<$CASTLEGOLD>', sText);
  end
  else if sVariable = '$TODAYINCOME' then
  begin
    sText := IntToStr(TUserCastle(m_Castle).m_nTodayIncome);
    sMsg := ExVariableText(sMsg, '<$TODAYINCOME>', sText);
  end
  else if sVariable = '$CASTLEDOORSTATE' then
  begin
    CastleDoor := TCastleDoor(TUserCastle(m_Castle).m_MainDoor.BaseObject);
    if CastleDoor.m_boDeath then
      sText := '损坏'
    else if CastleDoor.m_boOpened then
      sText := '开启'
    else
      sText := '关闭';
    sMsg := ExVariableText(sMsg, '<$CASTLEDOORSTATE>', sText);
  end
  else if sVariable = '$REPAIRDOORGOLD' then
  begin
    sText := IntToStr(g_Config.nRepairDoorPrice);
    sMsg := ExVariableText(sMsg, '<$REPAIRDOORGOLD>', sText);
  end
  else if sVariable = '$REPAIRWALLGOLD' then
  begin
    sText := IntToStr(g_Config.nRepairWallPrice);
    sMsg := ExVariableText(sMsg, '<$REPAIRWALLGOLD>', sText);
  end
  else if sVariable = '$GUARDFEE' then
  begin
    sText := IntToStr(g_Config.nHireGuardPrice);
    sMsg := ExVariableText(sMsg, '<$GUARDFEE>', sText);
  end
  else if sVariable = '$ARCHERFEE' then
  begin
    sText := IntToStr(g_Config.nHireArcherPrice);
    sMsg := ExVariableText(sMsg, '<$ARCHERFEE>', sText);
  end
  else if sVariable = '$GUARDRULE' then
  begin
    sText := '无效';
    sMsg := ExVariableText(sMsg, '<$GUARDRULE>', sText);
  end;

end;

procedure TCastleOfficial.UserSelect(PlayObject: TPlayObject; sData: string);
var
  s18, s20, sMsg, sLabel: string;
  boCanJmp: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TCastleManager::UserSelect... ';
begin
  inherited;
  try
    if m_Castle = nil then
    begin
      PlayObject.SysMsg('NPC不属于城堡', c_Red, t_Hint);
      Exit;
    end;
    if (sData <> '') and (sData[1] = '@') then
    begin
      sMsg := GetValidStr3(sData, sLabel, [#13]);
      s18 := '';
      PlayObject.m_sScriptLable := sData;
      if TUserCastle(m_Castle).IsMasterGuild(TGuild(PlayObject.m_MyGuild)) and
        (PlayObject.IsGuildMaster) then
      begin
        boCanJmp := PlayObject.LableIsCanJmp(sLabel);
        if CompareText(sLabel, sSL_SENDMSG) = 0 then
        begin
          if sMsg = '' then
            Exit;
        end;
        GotoLable(PlayObject, sLabel, not boCanJmp);
        if not boCanJmp then
          Exit;
        if CompareText(sLabel, sSL_SENDMSG) = 0 then
        begin
          SendCustemMsg(PlayObject, sMsg);
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
        end
        else if CompareText(sLabel, sCASTLENAME) = 0 then
        begin
          sMsg := Trim(sMsg);
          if sMsg <> '' then
          begin
            TUserCastle(m_Castle).m_sName := sMsg;
            TUserCastle(m_Castle).Save;
            TUserCastle(m_Castle).m_MasterGuild.RefMemberName;
            s18 := '城堡名称更改成功..';
          end
          else
            s18 := '城堡名称更改失败';
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
        end
        else if CompareText(sLabel, sWITHDRAWAL) = 0 then
        begin
          case TUserCastle(m_Castle).WithDrawalGolds(PlayObject, Str_ToInt(sMsg, 0)) of
            -4: s18 := '输入的金币数不正确';
            -3: s18 := '您无法携带更多的东西了';
            -2: s18 := '该城内没有这么多金币';
            -1: s18 := '只有行会 ' + TUserCastle(m_Castle).m_sOwnGuild + ' 的掌门人才能使用';
            1: GotoLable(PlayObject, sMAIN, False);
          end;
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
        end
        else if CompareText(sLabel, sRECEIPTS) = 0 then
        begin
          case TUserCastle(m_Castle).ReceiptGolds(PlayObject, Str_ToInt(sMsg, 0)) of
            -4: s18 := '输入的金币数不正确';
            -3: s18 := '你已经达到在城内存放货物的限制了';
            -2: s18 := '你没有那么多金币';
            -1: s18 := '只有行会 ' + TUserCastle(m_Castle).m_sOwnGuild + ' 的掌门人才能使用';
            1: GotoLable(PlayObject, sMAIN, False);
          end;
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
        end
        else if CompareText(sLabel, sOPENMAINDOOR) = 0 then
        begin
          TUserCastle(m_Castle).MainDoorControl(False);
        end
        else if CompareText(sLabel, sCLOSEMAINDOOR) = 0 then
        begin
          TUserCastle(m_Castle).MainDoorControl(True);
        end
        else if CompareText(sLabel, sREPAIRDOORNOW) = 0 then
        begin
          RepairDoor(PlayObject);
          GotoLable(PlayObject, sMAIN, False);
        end
        else if CompareText(sLabel, sREPAIRWALLNOW1) = 0 then
        begin
          RepairWallNow(1, PlayObject);
          GotoLable(PlayObject, sMAIN, False);
        end
        else if CompareText(sLabel, sREPAIRWALLNOW2) = 0 then
        begin
          RepairWallNow(2, PlayObject);
          GotoLable(PlayObject, sMAIN, False);
        end
        else if CompareText(sLabel, sREPAIRWALLNOW3) = 0 then
        begin
          RepairWallNow(3, PlayObject);
          GotoLable(PlayObject, sMAIN, False);
        end
        else if CompareLStr(sLabel, sHIREGUARDNOW, Length(sHIREGUARDNOW)) then
        begin
          s20 := Copy(sLabel, Length(sHIREGUARDNOW) + 1, Length(sLabel));
          HireGuard(s20, PlayObject);
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, '');
        end
        else if CompareLStr(sLabel, sHIREARCHERNOW, Length(sHIREARCHERNOW)) then
        begin
          s20 := Copy(sLabel, Length(sHIREARCHERNOW) + 1, Length(sLabel));
          HireArcher(s20, PlayObject);
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, '');
        end
        else if CompareText(sLabel, sEXIT) = 0 then
        begin
          PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
        end
        else if CompareText(sLabel, sBACK) = 0 then
        begin
          if PlayObject.m_sScriptGoBackLable = '' then
            PlayObject.m_sScriptGoBackLable := sMAIN;
          GotoLable(PlayObject, PlayObject.m_sScriptGoBackLable, False);
        end;
      end
      else
      begin
        s18 := '你没有权利使用';
        PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

procedure TCastleOfficial.HireGuard(sIndex: string; PlayObject: TPlayObject);
var
  n10: Integer;
  ObjUnit: pTObjUnit;
begin
  if m_Castle = nil then
  begin
    PlayObject.SysMsg('NPC不属于城堡', c_Red, t_Hint);
    Exit;
  end;
  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nHireGuardPrice then
  begin
    n10 := Str_ToInt(sIndex, 0) - 1;
    if n10 <= MAXCALSTEGUARD then
    begin
      if TUserCastle(m_Castle).m_Guard[n10].BaseObject = nil then
      begin
        if not TUserCastle(m_Castle).m_boUnderWar then
        begin
          ObjUnit := @TUserCastle(m_Castle).m_Guard[n10];
          ObjUnit.BaseObject :=
            UserEngine.RegenMonsterByName(TUserCastle(m_Castle).m_sMapName,
            ObjUnit.nX,
            ObjUnit.nY,
            ObjUnit.sName);
          if ObjUnit.BaseObject <> nil then
          begin
            Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nHireGuardPrice);
            ObjUnit.BaseObject.m_Castle := TUserCastle(m_Castle);
            TGuardUnit(ObjUnit.BaseObject).m_nX550 := ObjUnit.nX;
            TGuardUnit(ObjUnit.BaseObject).m_nY554 := ObjUnit.nY;
            TGuardUnit(ObjUnit.BaseObject).m_nDirection := 3;
            PlayObject.SysMsg('雇佣成功.', c_Green, t_Hint);
          end;

        end
        else
        begin
          PlayObject.SysMsg('现在无法雇佣', c_Red, t_Hint);
        end;
      end
    end
    else
    begin
      PlayObject.SysMsg('指令错误', c_Red, t_Hint);
    end;
  end
  else
  begin
    PlayObject.SysMsg('城内资金不足', c_Red, t_Hint);
  end;
end;

procedure TCastleOfficial.HireArcher(sIndex: string; PlayObject: TPlayObject);
var
  n10: Integer;
  ObjUnit: pTObjUnit;
begin
  if m_Castle = nil then
  begin
    PlayObject.SysMsg('NPC不属于城堡', c_Red, t_Hint);
    Exit;
  end;

  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nHireArcherPrice then
  begin
    n10 := Str_ToInt(sIndex, 0) - 1;
    if n10 <= MAXCASTLEARCHER then
    begin
      if TUserCastle(m_Castle).m_Archer[n10].BaseObject = nil then
      begin
        if not TUserCastle(m_Castle).m_boUnderWar then
        begin
          ObjUnit := @TUserCastle(m_Castle).m_Archer[n10];
          ObjUnit.BaseObject :=
            UserEngine.RegenMonsterByName(TUserCastle(m_Castle).m_sMapName,
            ObjUnit.nX,
            ObjUnit.nY,
            ObjUnit.sName);
          if ObjUnit.BaseObject <> nil then
          begin
            Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nHireArcherPrice);
            ObjUnit.BaseObject.m_Castle := TUserCastle(m_Castle);
            TGuardUnit(ObjUnit.BaseObject).m_nX550 := ObjUnit.nX;
            TGuardUnit(ObjUnit.BaseObject).m_nY554 := ObjUnit.nY;
            TGuardUnit(ObjUnit.BaseObject).m_nDirection := 3;
            PlayObject.SysMsg('雇佣成功.', c_Green, t_Hint);
          end;

        end
        else
        begin
          PlayObject.SysMsg('现在无法雇佣', c_Red, t_Hint);
        end;
      end
      else
      begin
        PlayObject.SysMsg('早已雇佣', c_Red, t_Hint);
      end;
    end
    else
    begin
      PlayObject.SysMsg('指令错误', c_Red, t_Hint);
    end;
  end
  else
  begin
    PlayObject.SysMsg('城内资金不足', c_Red, t_Hint);
  end;
end;
{ TMerchant }

procedure TMerchant.AddItemPrice(nIndex: Integer; nPrice: Integer);
var
  ItemPrice: pTItemPrice;
begin
  New(ItemPrice);
  ItemPrice.wIndex := nIndex;
  ItemPrice.nPrice := nPrice;
  m_ItemPriceList.Add(ItemPrice);
  FrmDB.SaveGoodPriceRecord(Self, m_sScript + '-' + m_sMapName);
end;

procedure TMerchant.CheckItemPrice(nIndex: Integer);
var
  i: Integer;
  ItemPrice: pTItemPrice;
  // n10: Integer;
  StdItem: pTStdItem;
begin
  for i := 0 to m_ItemPriceList.Count - 1 do
  begin
    ItemPrice := m_ItemPriceList.Items[i];
    if ItemPrice.wIndex = nIndex then
    begin
      {
      n10 := ItemPrice.nPrice;
      if Round(n10 * 1.1) > n10 then
      begin
        n10 := Round(n10 * 1.1);
      end
      else
        Inc(n10);
      }
      Exit;
    end;
  end;
  StdItem := UserEngine.GetStdItem(nIndex);
  if StdItem <> nil then
  begin
    AddItemPrice(nIndex, Round(StdItem.Price * 1.1));
  end;
end;

function TMerchant.GetRefillList(nIndex: Integer): TList;
var
  i: Integer;
  List: TList;
begin
  Result := nil;
  if nIndex <= 0 then
    Exit;
  for i := 0 to m_GoodsList.Count - 1 do
  begin
    List := TList(m_GoodsList.Items[i]);
    if List.Count > 0 then
    begin
      if pTUserItem(List.Items[0]).wIndex = nIndex then
      begin
        Result := List;
        Break;
      end;
    end;
  end;
end;

procedure TMerchant.RefillGoods;

  procedure RefillItems(var List: TList; sItemName: string; nInt: Integer);
  var
    i: Integer;
    UserItem: pTUserItem;
  begin
    if List = nil then
    begin
      List := TList.Create;
      m_GoodsList.Add(List);
    end;
    for i := 0 to nInt - 1 do
    begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
      begin
        List.Insert(0, UserItem);
      end
      else
        Dispose(UserItem);
    end;
  end;

  procedure DelReFillItem(var List: TList; nInt: Integer);
  var
    i: Integer;
  begin
    for i := List.Count - 1 downto 0 do
    begin
      if nInt <= 0 then
        Break;
      Dispose(pTUserItem(List.Items[i]));
      List.Delete(i);
      Dec(nInt);
    end;
  end;

var
  i, ii: Integer;
  Goods: pTGoods;
  nIndex, nRefillCount: Integer;
  RefillList, RefillList20: TList;
  bo21: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TMerchant::RefillGoods %s/%d:%d [%s] Code:%d';
begin
  try
    for i := 0 to m_RefillGoodsList.Count - 1 do
    begin
      Goods := m_RefillGoodsList.Items[i];
      if (GetTickCount - Goods.dwRefillTick) > Goods.dwRefillTime * 60 * 1000 then
      begin
        Goods.dwRefillTick := GetTickCount();
        nIndex := UserEngine.GetStdItemIdx(Goods.sItemName);
        if nIndex >= 0 then
        begin
          RefillList := GetRefillList(nIndex);
          nRefillCount := 0;
          if RefillList <> nil then
            nRefillCount := RefillList.Count;
          if Goods.nCount > nRefillCount then
          begin
            CheckItemPrice(nIndex);
            RefillItems(RefillList, Goods.sItemName, Goods.nCount - nRefillCount);
            FrmDB.SaveGoodRecord(Self, m_sScript + '-' + m_sMapName);
            FrmDB.SaveGoodPriceRecord(Self, m_sScript + '-' + m_sMapName);
          end;
          if Goods.nCount < nRefillCount then
          begin
            DelReFillItem(RefillList, nRefillCount - Goods.nCount);
            FrmDB.SaveGoodRecord(Self, m_sScript + '-' + m_sMapName);
            FrmDB.SaveGoodPriceRecord(Self, m_sScript + '-' + m_sMapName);
          end;
        end;
      end;
    end;
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      RefillList20 := TList(m_GoodsList.Items[i]);
      if RefillList20.Count > 1000 then
      begin
        bo21 := False;
        for ii := 0 to m_RefillGoodsList.Count - 1 do
        begin
          Goods := m_RefillGoodsList.Items[ii];
          nIndex := UserEngine.GetStdItemIdx(Goods.sItemName);
          if pTItemPrice(RefillList20.Items[0]).wIndex = nIndex then
          begin
            bo21 := True;
            Break;
          end;
        end;
        if not bo21 then
        begin
          DelReFillItem(RefillList20, RefillList20.Count - 1000);
        end
        else
        begin
          DelReFillItem(RefillList20, RefillList20.Count - 5000);
        end;
      end;
    end;
  except
    on E: Exception do
      MainOutMessageAPI(Format(sExceptionMsg, [m_sCharName, m_nCurrX, m_nCurrY, E.Message, nCHECK]));
  end;
end;

function TMerchant.CheckItemType(nStdMode: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to m_ItemTypeList.Count - 1 do
  begin
    if Integer(m_ItemTypeList.Items[i]) = nStdMode then
    begin
      Result := True;
      Break;
    end;
  end;
end;

// SendUserMarket(PlayObject, USERMARKET_TYPE_MINE, USERMARKET_MODE_INQUIRY)

procedure TMerchant.SendUserMarket(hum: TPlayObject; ItemType: Integer; UserMode: Integer);
begin
  case UserMode of
    USERMARKET_MODE_BUY, USERMARKET_MODE_INQUIRY: hum.RequireLoadUserMarket(g_Config.sServerName + '_' + m_sCharName, ItemType, UserMode, '', '');
    USERMARKET_MODE_SELL: hum.SendUserMarketSellReady(Self);
  end;
end;

function TMerchant.GetItemPrice(nIndex: Integer): Integer;
var
  i: Integer;
  ItemPrice: pTItemPrice;
  StdItem: pTStdItem;
begin
  Result := -1;
  for i := 0 to m_ItemPriceList.Count - 1 do
  begin
    ItemPrice := m_ItemPriceList.Items[i];
    if ItemPrice.wIndex = nIndex then
    begin
      Result := ItemPrice.nPrice;
      Break;
    end;
  end; // for
  if Result < 0 then
  begin
    StdItem := UserEngine.GetStdItem(nIndex);
    if StdItem <> nil then
    begin
      if CheckItemType(StdItem.StdMode) then
        Result := StdItem.Price;
    end;
  end;
end;

procedure TMerchant.SaveUpgradingList();
begin
  try
    //FrmDB.SaveUpgradeWeaponRecord(m_sCharName,m_UpgradeWeaponList);
    FrmDB.SaveUpgradeWeaponRecord(m_sScript + '-' + m_sMapName, m_UpgradeWeaponList);
  except
    MainOutMessageAPI('Failure in saving upgradinglist - ' + m_sCharName);
  end;
end;

procedure TMerchant.UpgradeWapon(User: TPlayObject);

  procedure sub_4A0218(ItemList: TList; var btDc: byte; var btSc: byte; var btMc: byte; var btDura: byte);
  var
    i, ii: Integer;
    DuraList: TList;
    UserItem: pTUserItem;
    StdItem: pTStdItem;
    StdItem80: TStdItem;
    DelItemList: TStringList;
    nDc, nSc, nMc, nDcMin, nDcMax, nScMin, nScMax, nMcMin, nMcMax, nDura, nItemCount: Integer;
  begin
    nDcMin := 0;
    nDcMax := 0;
    nScMin := 0;
    nScMax := 0;
    nMcMin := 0;
    nMcMax := 0;
    nDura := 0;
    nItemCount := 0;
    DelItemList := nil;
    DuraList := TList.Create;
    for i := ItemList.Count - 1 downto 0 do
    begin
      UserItem := ItemList.Items[i];
      if UserEngine.GetStdItemName(UserItem.wIndex) = g_Config.sBlackStone then
      begin
        DuraList.Add(Pointer(Round(UserItem.Dura / 1.0E3)));
        if DelItemList = nil then
          DelItemList := TStringList.Create;
        DelItemList.AddObject(g_Config.sBlackStone, TObject(UserItem.MakeIndex));
        Dispose(UserItem);
        ItemList.Delete(i);
      end
      else
      begin
        if IsUseItem(UserItem.wIndex) then
        begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem <> nil then
          begin
            StdItem80 := StdItem^;
            ItemUnit.GetItemAddValue(UserItem, StdItem80);
            nDc := 0;
            nSc := 0;
            nMc := 0;
            case StdItem80.StdMode of
              19, 20, 21:
                begin
                  nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC);
                  nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC);
                  nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC);
                end;
              22, 23:
                begin
                  nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC);
                  nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC);
                  nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC);
                end;
              24, 26:
                begin
                  nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC) + 1;
                  nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC) + 1;
                  nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC) + 1;
                end;
            end;
            if nDcMin < nDc then
            begin
              nDcMax := nDcMin;
              nDcMin := nDc;
            end
            else
            begin
              if nDcMax < nDc then
                nDcMax := nDc;
            end;
            if nScMin < nSc then
            begin
              nScMax := nScMin;
              nScMin := nSc;
            end
            else
            begin
              if nScMax < nSc then
                nScMax := nSc;
            end;
            if nMcMin < nMc then
            begin
              nMcMax := nMcMin;
              nMcMin := nMc;
            end
            else
            begin
              if nMcMax < nMc then
                nMcMax := nMc;
            end;
            if DelItemList = nil then
              DelItemList := TStringList.Create;
            DelItemList.AddObject(StdItem.Name, TObject(UserItem.MakeIndex));
            if StdItem.NeedIdentify = 1 then
              AddGameDataLogAPI('26' + #9 +
                User.m_sMapName + #9 +
                IntToStr(User.m_nCurrX) + #9 +
                IntToStr(User.m_nCurrY) + #9 +
                User.m_sCharName + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                '0');
            Dispose(UserItem);
            ItemList.Delete(i);
          end;
        end;
      end;
    end;
    for i := 0 to DuraList.Count - 1 do
    begin
      for ii := DuraList.Count - 1 downto i + 1 do
      begin
        if Integer(DuraList.Items[ii]) > Integer(DuraList.Items[ii - 1]) then
          DuraList.Exchange(ii, ii - 1);
      end;
    end;
    for i := 0 to DuraList.Count - 1 do
    begin
      nDura := nDura + Integer(DuraList.Items[i]);
      Inc(nItemCount);
      if nItemCount >= 5 then
        Break;
    end;
    btDura := Round(_MIN(5, nItemCount) + _MIN(5, nItemCount) * ((nDura / nItemCount) / 5.0));
    btDc := nDcMin div 5 + nDcMax div 3;
    btSc := nScMin div 5 + nScMax div 3;
    btMc := nMcMin div 5 + nMcMax div 3;
    if DelItemList <> nil then
      User.SendMsg(Self, RM_SENDDELITEMLIST, 0, Integer(DelItemList), 0, 0, '');

    if DuraList <> nil then
      DuraList.Free;

  end;
var
  i: Integer;
  bo0D: Boolean;
  UpgradeInfo: pTUpgradeInfo;
  StdItem: pTStdItem;
begin
  bo0D := False;
  for i := 0 to m_UpgradeWeaponList.Count - 1 do
  begin
    UpgradeInfo := m_UpgradeWeaponList.Items[i];
    if UpgradeInfo.sUserName = User.m_sCharName then
    begin
      GotoLable(User, sUPGRADEING, False);
      Exit;
    end;
  end;
  if (User.m_UseItems[U_WEAPON].wIndex <> 0) and (User.m_nGold >= g_Config.nUpgradeWeaponPrice) and (User.CheckItems(g_Config.sBlackStone) <> nil) then
  begin
    User.DecGold(g_Config.nUpgradeWeaponPrice);
    if m_boCastle or g_Config.boGetAllNpcTax then
    begin
      if m_Castle <> nil then
        TUserCastle(m_Castle).IncRateGold(g_Config.nUpgradeWeaponPrice)
      else if g_Config.boGetAllNpcTax then
        g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
    end;
    User.GoldChanged();
    New(UpgradeInfo);
    UpgradeInfo.sUserName := User.m_sCharName;
    UpgradeInfo.UserItem := User.m_UseItems[U_WEAPON];
    StdItem := UserEngine.GetStdItem(User.m_UseItems[U_WEAPON].wIndex);
    if StdItem.NeedIdentify = 1 then
      AddGameDataLogAPI('25' + #9 +
        User.m_sMapName + #9 +
        IntToStr(User.m_nCurrX) + #9 +
        IntToStr(User.m_nCurrY) + #9 +
        User.m_sCharName + #9 +
        StdItem.Name + #9 +
        IntToStr(User.m_UseItems[U_WEAPON].MakeIndex) + #9 +
        '1' + #9 +
        '0');
    User.SendDelItems(@User.m_UseItems[U_WEAPON]);
    User.m_UseItems[U_WEAPON].wIndex := 0;
    User.RecalcAbilitys();
    User.FeatureChanged();
    User.SendMsg(User, RM_ABILITY, 0, 0, 0, 0, '');
    sub_4A0218(User.m_ItemList, UpgradeInfo.btDc, UpgradeInfo.btSc, UpgradeInfo.btMc, UpgradeInfo.btDura);
    UpgradeInfo.dtTime := Now();
    UpgradeInfo.dwGetBackTick := GetTickCount();
    m_UpgradeWeaponList.Add(UpgradeInfo);
    SaveUpgradingList();
    bo0D := True;
  end;
  if bo0D then
  begin
    User.m_dwSaveRcdTick := 0;
    GotoLable(User, sUPGRADEOK, False)
  end
  else
    GotoLable(User, sUPGRADEFAIL, False);
end;

procedure TMerchant.GetBackupgWeapon(User: TPlayObject);
var
  i: Integer;
  UpgradeInfo: pTUpgradeInfo;
  n10, n18, n1C, n90: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  n18 := 0;
  UpgradeInfo := nil;
  if not User.IsEnoughBag then
  begin
    GotoLable(User, sGETBACKUPGFULL, False);
    Exit;
  end;
  for i := 0 to m_UpgradeWeaponList.Count - 1 do
  begin
    if pTUpgradeInfo(m_UpgradeWeaponList.Items[i]).sUserName = User.m_sCharName then
    begin
      n18 := 1;
      if ((GetTickCount - pTUpgradeInfo(m_UpgradeWeaponList.Items[i]).dwGetBackTick) > g_Config.dwUPgradeWeaponGetBackTime) or (User.m_btPermission >= 4) then
      begin
        UpgradeInfo := m_UpgradeWeaponList.Items[i];
        m_UpgradeWeaponList.Delete(i);
        SaveUpgradingList();
        n18 := 2;
        Break;
      end;
    end;
  end;
  if UpgradeInfo <> nil then
  begin
    case UpgradeInfo.btDura of
      0..8:
        begin
          if UpgradeInfo.UserItem.DuraMax > 3000 then
            Dec(UpgradeInfo.UserItem.DuraMax, 3000)
          else
            UpgradeInfo.UserItem.DuraMax := UpgradeInfo.UserItem.DuraMax shr 1;
          if UpgradeInfo.UserItem.Dura > UpgradeInfo.UserItem.DuraMax then
            UpgradeInfo.UserItem.Dura := UpgradeInfo.UserItem.DuraMax;
        end;
      9..15:
        begin
          if Random(UpgradeInfo.btDura) < 6 then
          begin
            if UpgradeInfo.UserItem.DuraMax > 1000 then
              Dec(UpgradeInfo.UserItem.DuraMax, 1000);
            if UpgradeInfo.UserItem.Dura > UpgradeInfo.UserItem.DuraMax then
              UpgradeInfo.UserItem.Dura := UpgradeInfo.UserItem.DuraMax;
          end;

        end;
      18..255:
        begin
          case Random(UpgradeInfo.btDura - 18) of
            1..4: Inc(UpgradeInfo.UserItem.DuraMax, 1000);
            5..7: Inc(UpgradeInfo.UserItem.DuraMax, 2000);
            8..255: Inc(UpgradeInfo.UserItem.DuraMax, 4000)
          end;
        end;
    end;
    if (UpgradeInfo.btDc = UpgradeInfo.btMc) and (UpgradeInfo.btMc = UpgradeInfo.btSc) then
      n1C := Random(3)
    else
      n1C := -1;
    if ((UpgradeInfo.btDc >= UpgradeInfo.btMc) and (UpgradeInfo.btDc >= UpgradeInfo.btSc)) or (n1C = 0) then
    begin
      n90 := _MIN(11, UpgradeInfo.btDc);
      n10 := _MIN(85, n90 shl 3 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);
      if Random(g_Config.nUpgradeWeaponDCRate) < n10 then
      begin
        UpgradeInfo.UserItem.btValue[10] := 10;
        if (n10 > 63) and (Random(g_Config.nUpgradeWeaponDCTwoPointRate) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 11;
        if (n10 > 79) and (Random(g_Config.nUpgradeWeaponDCThreePointRate) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 12;
      end
      else
        UpgradeInfo.UserItem.btValue[10] := 1;
    end;

    if ((UpgradeInfo.btMc >= UpgradeInfo.btDc) and (UpgradeInfo.btMc >= UpgradeInfo.btSc)) or (n1C = 1) then
    begin
      n90 := _MIN(11, UpgradeInfo.btMc);
      n10 := _MIN(85, n90 shl 3 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);

      if Random(g_Config.nUpgradeWeaponMCRate) < n10 then
      begin //if Random(100) < n10 then begin
        UpgradeInfo.UserItem.btValue[10] := 20;

        if (n10 > 63) and (Random(g_Config.nUpgradeWeaponMCTwoPointRate) = 0) then //if (n10 > 63) and (Random(30) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 21;

        if (n10 > 79) and (Random(g_Config.nUpgradeWeaponMCThreePointRate) = 0) then //if (n10 > 79) and (Random(200) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 22;
      end
      else
        UpgradeInfo.UserItem.btValue[10] := 1;
    end;

    if ((UpgradeInfo.btSc >= UpgradeInfo.btMc) and (UpgradeInfo.btSc >=
      UpgradeInfo.btDc)) or
      (n1C = 2) then
    begin
      n90 := _MIN(11, UpgradeInfo.btMc);
      n10 := _MIN(85, n90 shl 3 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);

      if Random(g_Config.nUpgradeWeaponSCRate) < n10 then
      begin //if Random(100) < n10 then begin
        UpgradeInfo.UserItem.btValue[10] := 30;

        if (n10 > 63) and (Random(g_Config.nUpgradeWeaponSCTwoPointRate) = 0) then //if (n10 > 63) and (Random(30) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 31;

        if (n10 > 79) and (Random(g_Config.nUpgradeWeaponSCThreePointRate) = 0) then //if (n10 > 79) and (Random(200) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 32;
      end
      else
        UpgradeInfo.UserItem.btValue[10] := 1;
    end;
    New(UserItem);
    UserItem^ := UpgradeInfo.UserItem;
    Dispose(UpgradeInfo);
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem.NeedIdentify = 1 then
      AddGameDataLogAPI('24' + #9 +
        User.m_sMapName + #9 +
        IntToStr(User.m_nCurrX) + #9 +
        IntToStr(User.m_nCurrY) + #9 +
        User.m_sCharName + #9 +
        StdItem.Name + #9 +
        IntToStr(UserItem.MakeIndex) + #9 +
        '1' + #9 +
        '0');
    User.AddItemToBag(UserItem);
    User.SendAddItem(UserItem);
  end;
  case n18 of
    0: GotoLable(User, sGETBACKUPGFAIL, False);
    1: GotoLable(User, sGETBACKUPGING, False);
    2: GotoLable(User, sGETBACKUPGOK, False);
  end;
end;

function TMerchant.GetUserPrice(PlayObject: TPlayObject; nPrice: Integer): Integer;
var
  n14: Integer;
begin
  if m_boCastle then
  begin
    if (m_Castle <> nil) and TUserCastle(m_Castle).IsMasterGuild(TGuild(PlayObject.m_MyGuild)) then
    begin
      n14 := _MAX(60, Round(m_nPriceRate * (g_Config.nCastleMemberPriceRate / 100)));
      Result := Round(nPrice / 100 * n14);
    end
    else
      Result := Round(nPrice / 100 * m_nPriceRate);
  end
  else
    Result := Round(nPrice / 100 * m_nPriceRate);
end;

procedure TMerchant.UserSelect(PlayObject: TPlayObject; sData: string);

  procedure SuperRepairItem(User: TPlayObject);
  begin
    User.SendMsg(Self, RM_SENDUSERSREPAIR, 0, Integer(Self), 0, 0, '');
  end;

  procedure BuyItem(User: TPlayObject; IsVisualization: Integer);
  var
    i, n10 : Integer;
    nSubMenu: ShortInt;
    sSENDMSG: string;
    UserItem: pTUserItem;
    StdItem: pTStdItem;
    List14: TList;
    GoodsData: TClientGoods;
  begin
    sSENDMSG := '';
    n10 := 0;
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      List14 := TList(m_GoodsList.Items[i]);
      UserItem := List14.Items[0];
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then
      begin
        GoodsData.Name := '';
        if UserItem.btValue[13] = 1 then GoodsData.Name := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);

        if GoodsData.Name = '' then GoodsData.Name := StdItem.Name;

        GoodsData.Price := GetUserPrice(User, GetItemPrice(UserItem.wIndex));
        GoodsData.Stock := List14.Count;
        if (StdItem.StdMode <= 4) or (StdItem.StdMode = 42) or (StdItem.StdMode = 31) then
           nSubMenu := 0
        else
          nSubMenu := 1;
        if StdItem.Overlap >= 1 then nSubMenu := 2;
        GoodsData.Grade := 5;
        GoodsData.SubMenu := nSubMenu;
        GoodsData.looks := StdItem.looks;
        sSENDMSG := sSENDMSG + EncodeBuffer(@GoodsData, SizeOf(TClientGoods));
        Inc(n10);
      end;
    end;
    User.SendMsg(Self, RM_SENDGOODSLIST, 0, Integer(Self), n10, IsVisualization, sSENDMSG);
  end;

  procedure SellItem(User: TPlayObject);
  begin
    User.SendMsg(Self, RM_SENDUSERSELL, 0, Integer(Self), 0, 0, '');
  end;

  procedure RepairItem(User: TPlayObject);
  begin
    User.SendMsg(Self, RM_SENDUSERREPAIR, 0, Integer(Self), 0, 0, '');
  end;

  procedure MakeDurg(User: TPlayObject);
  var
    i: Integer;
    List14: TList;
    UserItem: pTUserItem;
    StdItem: pTStdItem;
    sSENDMSG: string;
  begin
    sSENDMSG := '';
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      List14 := TList(m_GoodsList.Items[i]);
      UserItem := List14.Items[0];
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then
        sSENDMSG := sSENDMSG + StdItem.Name + '/' + IntToStr(0) + '/' + IntToStr(g_Config.nMakeDurgPrice) + '/' + IntToStr(1) + '/';
    end;
    if sSENDMSG <> '' then
      User.SendMsg(Self, RM_USERMAKEDRUGITEMLIST, 0, Integer(Self), 0, 0, sSENDMSG);
  end;

  procedure ItemPrices(User: TPlayObject);
  begin

  end;

  procedure Storage(User: TPlayObject);
  begin
    User.SendMsg(Self, RM_USERSTORAGEITEM, 0, Integer(Self), 0, 0, '');
  end;

  procedure GetBack(User: TPlayObject);
  begin
    User.SendMsg(Self, RM_USERGETBACKITEM, 0, Integer(Self), 0, 0, '');
  end;
var
  sLabel, sStr, sMsg: string;
  nPos, nInt: Integer;
  b, boCanJmp: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TMerchant::UserSelect... Data: %s';
begin
  inherited;
  if ClassNameIs(TMerchant.ClassName) then
  begin
    try
      if not m_boCastle or not ((m_Castle <> nil) and TUserCastle(m_Castle).m_boUnderWar) then
      begin
        if not PlayObject.m_boDeath and (sData <> '') and (sData[1] = '@') then
        begin
          sMsg := GetValidStr3(sData, sLabel, [#13]);
          sStr := '';
          PlayObject.m_sScriptLable := sData;
          boCanJmp := PlayObject.LableIsCanJmp(sLabel);
          if (CompareText(sLabel, sSL_SENDMSG) = 0) or (CompareText(sLabel, sOFFLINEMSG) = 0) or
            (CompareText(sLabel, sMAKEPEUMA) = 0) or (CompareText(sLabel, sCERATEHERO) = 0) or
            (CompareText(sLabel, sRECALLPLAYER) = 0) or CompareLStr(sLabel, sDEALGOLD, Length(sDEALGOLD)) or
            CompareLStr(sLabel, sINPUTINTEGER, Length(sINPUTINTEGER)) or CompareLStr(sLabel, sINPUTSTRING, Length(sINPUTSTRING)) then
          begin
            if sMsg = '' then Exit;

            // 修正@@InputInteger/@@InputString时，先触发@Label再给变量赋值的bug cc 2019-12-03 12:07:00
            if CompareLStr(sLabel, sINPUTINTEGER, Length(sINPUTINTEGER)) then
            begin
              if m_boInputInteger then
              begin
                sStr := Copy(sLabel, Length(sINPUTINTEGER) + 1, Length(sLabel) - Length(sINPUTINTEGER));
                nPos := Str_ToInt(sStr, 0);
                if not (nPos in [0..99]) then
                begin
                  MainOutMessageAPI('[脚本错误] ' + PlayObject.m_sCharName + ' ' + sINPUTINTEGER + ' 参数(0~99):' + sStr);
                  Exit;
                end;
                nInt := Str_ToInt(sMsg, -2100000000);
                if (nInt >= 2100000000) or (nInt <= -2100000000) then
                begin
                  PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '输入的数字范围必须在正负21亿之间，请重新编辑！');
                  Exit;
                end;
                PlayObject.m_nMval[nPos] := nInt;
                //GotoLable(PlayObject, '@InPutInteger' + sStr, False);
              end;
            end
            else if CompareLStr(sLabel, sINPUTSTRING, Length(sINPUTSTRING)) then
            begin
              if m_boInputString then
              begin
                sStr := Copy(sLabel, Length(sINPUTSTRING) + 1, Length(sLabel) - Length(sINPUTSTRING));
                nPos := Str_ToInt(sStr, 0);
                if not (nPos in [0..99]) then
                begin
                  MainOutMessageAPI('[脚本错误] ' + PlayObject.m_sCharName + ' ' + sINPUTSTRING + ' 参数(0~99):' + sStr);
                  Exit;
                end;
                if Length(sMsg) >= High(byte) then
                begin
                  PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '输入的数据长度必须在(0~255)之间，请重新编辑！');
                  Exit;
                end;
                if IsInGuildRankNameFilterList(sMsg) then
                begin
                  GotoLable(PlayObject, '@IsInFilterList', False);
                  Exit;
                end;
                PlayObject.m_nSval[nPos] := sMsg;
                //GotoLable(PlayObject, '@InPutString' + sStr, False);
              end;
            end
          end;
          
          GotoLable(PlayObject, sLabel, not boCanJmp, sMsg);
          if not boCanJmp then Exit;

          ///////////////////////////////////////////////////////
          if m_boItemMarket then
          begin
            b := False;
            if CompareText(sLabel, '@market_0') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_ALL, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_1') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_WEAPON, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_2') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_NECKLACE, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_3') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_RING, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_4') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_BRACELET, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_5') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_CHARM, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_6') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_HELMET, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_7') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_BELT, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_8') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_SHOES, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_9') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_ARMOR, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_10') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_DRINK, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_11') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_JEWEL, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_12') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_BOOK, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_13') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_MINERAL, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_14') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_QUEST, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_15') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_ETC, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_100') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_SET, USERMARKET_MODE_BUY)
            else if CompareText(sLabel, '@market_200') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_MINE, USERMARKET_MODE_INQUIRY)
            else if CompareText(sLabel, '@market_sell') = 0 then
              SendUserMarket(PlayObject, USERMARKET_TYPE_ALL, USERMARKET_MODE_SELL)
            else
              b := True;
            if not b then
              Exit;
          end;
          ///////////////////////////////////////////////////////

          if CompareText(sLabel, '@@SecretProperty') = 0 then
          begin
            PlayObject.SendDefMessage(SM_SecretProperty, 1, PlayObject.m_btSPLuck, PlayObject.m_btSPEnergy, 1, '');
          end
          else if CompareText(sLabel, sOFFLINEMSG) = 0 then
          begin
            if m_boOffLineMsg then
              SetOffLineMsg(PlayObject, sMsg);
          end
          else if CompareText(sLabel, sSL_SENDMSG) = 0 then
          begin
            if m_boSendmsg then
            begin
              if IsInGuildRankNameFilterList(sMsg) then
              begin
                PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '输入的信息中包含了非法字符，已被过滤，请重新输入。');
                Exit;
              end;
              SendCustemMsg(PlayObject, sMsg);
            end;
          end
          else if CompareText(sLabel, sSUPERREPAIR) = 0 then
          begin
            if m_boS_repair then
              SuperRepairItem(PlayObject);
          end
          else if CompareText(sLabel, sBUY) = 0 then
          begin
            if m_boBuy then
              BuyItem(PlayObject, 0);
          end
          else if CompareText(sLabel, sMERCHANDISE) = 0 then
          begin
            BuyItem(PlayObject, 1);
          end
          else if CompareText(sLabel, sSELL) = 0 then
          begin
            if m_boSell then
              SellItem(PlayObject);
          end
          else if CompareText(sLabel, sREPAIR) = 0 then
          begin
            if m_boRepair then
              RepairItem(PlayObject);
          end
          else if CompareText(sLabel, sMAKEDURG) = 0 then
          begin
            if m_boMakeDrug then
              MakeDurg(PlayObject);
          end
          else if CompareText(sLabel, sPRICES) = 0 then
          begin
            if m_boPrices then
              ItemPrices(PlayObject);
          end
          else if CompareText(sLabel, sSTORAGE) = 0 then
          begin
            if m_boStorage then
              Storage(PlayObject);
          end
          else if CompareText(sLabel, sGETBACK) = 0 then
          begin
            if m_boGetback then
              GetBack(PlayObject);
          end
          else if CompareText(sLabel, sUPGRADENOW) = 0 then
          begin
            if m_boUpgradenow then
              UpgradeWapon(PlayObject);
          end
          else if CompareText(sLabel, sGETBACKUPGNOW) = 0 then
          begin
            if m_boGetBackupgnow then
              GetBackupgWeapon(PlayObject);
          end
          else if CompareText(sLabel, sGETMARRY) = 0 then
          begin
            if m_boGetMarry then
              GetMarry(PlayObject, sMsg);
          end
          else if CompareText(sLabel, sGETMASTER) = 0 then
          begin
            if m_boGetMaster then
              GetMaster(PlayObject, sMsg);
          end
          else if CompareLStr(sLabel, sREMOTEMUSIC, Length(sREMOTEMUSIC)) then
            RemoteMusic(PlayObject, sLabel, sMsg)
          else if CompareLStr(sLabel, sREMOTEMSG, Length(sREMOTEMSG)) then
            RemoteMsg(PlayObject, sLabel, sMsg)
          else if CompareLStr(sLabel, sDEALGOLD, Length(sDEALGOLD)) then
          begin
            if m_boDealGold then
              StartDealGold(PlayObject, sLabel, sMsg);
          end
          else if CompareText(sLabel, sMAKEPEUMA) = 0 then
          begin
            if m_boMakeHero then
            begin
              if IsInGuildRankNameFilterList(sMsg) then
              begin
                PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '输入的名字中包含了非法字符，分身名字恢复默认值。');
                PlayObject.m_sPneumaName := '';
                Exit;
              end;
              PlayObject.m_sPneumaName := sMsg;
            end;
          end
          else if CompareText(sLabel, sCERATEHERO) = 0 then
          begin
            PlayObject.m_sTempHeroName := '';
            if m_boCreateHero then
            begin
              if IsInGuildRankNameFilterList(sMsg) then
              begin
                PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '输入的英雄名字中包含了非法字符，请重新编辑！');
                Exit;
              end;
              PlayObject.m_sTempHeroName := sMsg;
            end;
          end
          else if CompareText(sLabel, sCERATEHERO2) = 0 then
          begin
            PlayObject.m_sTempHeroName := '';
            if m_boCreateHero then
            begin
              if IsInGuildRankNameFilterList(sMsg) then
              begin
                PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '输入的英雄名字中包含了非法字符，请重新编辑！');
                Exit;
              end;
              PlayObject.m_sTempHeroName := sMsg;
            end;
          end
          else if CompareLStr(sLabel, sUSEITEMNAME, Length(sUSEITEMNAME)) then
          begin
            if m_boUseItemName then
            begin
              if IsInGuildRankNameFilterList(sMsg) then
              begin
                PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '自定义装备的名字中包含了非法字符，请重新编辑！');
                Exit;
              end;
              if Length(sMsg) > 14 then
              begin
                PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '自定义装备的名字不能超过14字节(7个汉字)，请重新编辑！');
                Exit;
              end;
              ChangeUseItemName(PlayObject, sLabel, sMsg);
            end;
          end
          else if CompareText(sLabel, sEXIT) = 0 then
            PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '')
          else if CompareText(sLabel, sBACK) = 0 then
          begin
            if PlayObject.m_sScriptGoBackLable = '' then
              PlayObject.m_sScriptGoBackLable := sMAIN;
            GotoLable(PlayObject, PlayObject.m_sScriptGoBackLable, False);
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        MainOutMessageAPI(Format(sExceptionMsg, [sData]));
        MainOutMessageAPI(E.Message);
      end;
    end;
  end;
end;

procedure TMerchant.Run();
var
  nCheckCode, nInteger: Integer;
resourcestring
  sExceptionMsg1 = '[Exception] TMerchant::Run... Code = %d';
  sExceptionMsg2 = '[Exception] TMerchant::Run -> Move Code = %d';
begin
  nCheckCode := 0;
  try
    if (GetTickCount - dwRefillGoodsTick) > 30 * 1000 then
    begin
      dwRefillGoodsTick := GetTickCount();
      RefillGoods();
      FrmDB.SavePostSellRecord(Self, m_sScript + '-' + m_sMapName);
      FrmDB.SavePostGoldRecord(Self, m_sScript + '-' + m_sMapName);
      if (m_wAppr in [52]) then
      begin
        //////////
        SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
      end;
    end;
    nCheckCode := 1;
    if (GetTickCount - dwClearExpreUpgradeTick) > 10 * 60 * 1000 then
    begin
      dwClearExpreUpgradeTick := GetTickCount();
      ClearExpreUpgradeListData();
    end;

    nCheckCode := 2;
    if not (m_wAppr in [60..67, 84, 85]) then
    begin
      if Random(50) = 0 then
        TurnTo(Random(8))
      else if Random(50) = 0 then
        SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    end;
     
    nCheckCode := 3;
    if m_boCastle and (m_Castle <> nil) and TUserCastle(m_Castle).m_boUnderWar then
    begin
      if not m_boFixedHideMode then
      begin
        SendRefMsg(RM_DISAPPEAR, 0, 0, 0, 0, '');
        m_boFixedHideMode := True;
      end;
    end
    else if m_boFixedHideMode then
    begin
      m_boFixedHideMode := False;
      SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    end;

    nCheckCode := 4;
    if m_boAutoChangeColor and (m_dwAutoChangeColorTime > 0) and (GetTickCount - m_dwAutoChangeColorTick > m_dwAutoChangeColorTime) then
    begin
      m_dwAutoChangeColorTick := GetTickCount();
      case m_nAutoChangeIdx of
        0: nInteger := STATE_TRANSPARENT;
        1: nInteger := POISON_STONE;
        2: nInteger := POISON_DONTMOVE;
        3: nInteger := POISON_SHOCKED;
        4: nInteger := POISON_DECHEALTH;
        5: nInteger := POISON_FREEZE;
        6: nInteger := POISON_DAMAGEARMOR;
      else
        begin
          m_nAutoChangeIdx := 0;
          nInteger := STATE_TRANSPARENT;
        end;
      end;
      Inc(m_nAutoChangeIdx);
      m_nCharStatus := (m_nCharStatusEx {and $FFFFF}) or (($80000000 shr nInteger) or 0);
      StatusChanged();
    end;
    if m_boFixColor and (m_nFixStatus <> m_nCharStatus) then
    begin
      case m_nFixColorIdx of
        0: nInteger := STATE_TRANSPARENT;
        1: nInteger := POISON_STONE;
        2: nInteger := POISON_DONTMOVE;
        3: nInteger := POISON_SHOCKED;
        4: nInteger := POISON_DECHEALTH;
        5: nInteger := POISON_FREEZE;
        6: nInteger := POISON_DAMAGEARMOR;
      else
        begin
          m_nFixColorIdx := 0;
          nInteger := STATE_TRANSPARENT;
        end;
      end;
      m_nCharStatus := (m_nCharStatusEx {and $FFFFF}) or (($80000000 shr nInteger) or 0);
      m_nFixStatus := m_nCharStatus;
      StatusChanged();
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg1, [nCheckCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;
  try
    if m_boCanMove and (GetTickCount - m_dwMoveTick > m_dwMoveTime * 1000) then
    begin
      m_dwMoveTick := GetTickCount();
      SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
      MapRandomMove(m_sMapName, 0);
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg2, [nCheckCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;
  inherited;
end;

function TMerchant.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);
end;

procedure TMerchant.LoadNPCData;
var
  sFile: string;
begin
  sFile := m_sScript + '-' + m_sMapName;
  FrmDB.LoadGoodRecord(Self, sFile);
  FrmDB.LoadGoodPriceRecord(Self, sFile);
  FrmDB.LoadSellOffRecord(Self, sFile);
  FrmDB.LoadSellGoldRecord(Self, sFile);
  FrmDB.LoadPostSellRecord(Self, sFile);
  FrmDB.LoadPostGoldRecord(Self, sFile);
  LoadUpgradeList();
end;

procedure TMerchant.SaveNPCData;
var
  sFile: string;
begin
  sFile := m_sScript + '-' + m_sMapName;
  FrmDB.SaveGoodRecord(Self, sFile);
  FrmDB.SaveGoodPriceRecord(Self, sFile);
  FrmDB.SavePostSellRecord(Self, sFile);
  FrmDB.SavePostGoldRecord(Self, sFile);
end;

procedure TMerchant.SaveSellOff;
var
  sFile: string;
begin
  sFile := m_sScript + '-' + m_sMapName;
  FrmDB.SaveSellOffRecord(Self, sFile);
end;

procedure TMerchant.SaveSellGold;
var
  sFile: string;
begin
  sFile := m_sScript + '-' + m_sMapName;
  FrmDB.SaveSellGoldRecord(Self, sFile);
end;

constructor TMerchant.Create;
begin
  inherited;
  m_btRaceImg := RCC_MERCHANT;
  m_wAppr := 0;
  m_nPriceRate := 100;
  m_boCastle := False;
  m_ItemTypeList := TList.Create;
  m_RefillGoodsList := TList.Create;
  m_GoodsList := TList.Create;
  m_SellOffList := TList.Create;
  m_SellgoldList := TList.Create;
  m_PostSellList := TList.Create;
  m_PostGoldList := TList.Create;
  m_ItemPriceList := TList.Create;
  m_UpgradeWeaponList := TList.Create;
  dwRefillGoodsTick := GetTickCount();
  dwClearExpreUpgradeTick := GetTickCount();
  m_boBuy := False;
  m_boSell := False;
  m_boMakeDrug := False;
  m_boPrices := False;
  m_boStorage := False;
  m_boGetback := False;
  m_boUpgradenow := False;
  m_boGetBackupgnow := False;
  m_boRepair := False;
  m_boS_repair := False;
  m_boGetMarry := False;
  m_boGetMaster := False;
  m_boUseItemName := False;
  m_boDealGold := False;
  m_boOffLineMsg := False;
  m_boMakeHero := False;
  m_boCreateHero := False;
  m_boInputInteger := False;
  m_boInputString := False;
  m_boYBDeal := False;
  m_boItemMarket := False;
  m_dwMoveTick := GetTickCount();
end;

destructor TMerchant.Destroy;
var
  i: Integer;
  ii: Integer;
  List: TList;
begin
  m_ItemTypeList.Free;

  for i := 0 to m_RefillGoodsList.Count - 1 do
    Dispose(pTGoods(m_RefillGoodsList.Items[i]));
  m_RefillGoodsList.Free;

  for i := 0 to m_GoodsList.Count - 1 do
  begin
    List := TList(m_GoodsList.Items[i]);
    for ii := 0 to List.Count - 1 do
      Dispose(pTUserItem(List.Items[ii]));
    List.Free;
  end;
  m_GoodsList.Free;

  for i := 0 to m_ItemPriceList.Count - 1 do
    Dispose(pTItemPrice(m_ItemPriceList.Items[i]));
  m_ItemPriceList.Free;

  for i := 0 to m_UpgradeWeaponList.Count - 1 do
    Dispose(pTUpgradeInfo(m_UpgradeWeaponList.Items[i]));
  m_UpgradeWeaponList.Free;

  for i := 0 to m_SellOffList.Count - 1 do
  begin //Momory Leaked - Fixed By Blue
    List := TList(m_SellOffList.Items[i]);
    for ii := 0 to List.Count - 1 do
      Dispose(pSellOff(List.Items[ii]));
    List.Free;
  end;
  m_SellOffList.Free;

  for i := 0 to m_SellgoldList.Count - 1 do //Momory Leaked - Fixed By Blue
    Dispose(pSellOff(m_SellgoldList.Items[i]));
  m_SellgoldList.Free;

  if m_boYBDeal then
  begin
    FrmDB.SavePostSellRecord(Self, m_sScript + '-' + m_sMapName);
    FrmDB.SavePostGoldRecord(Self, m_sScript + '-' + m_sMapName);
  end;

  for i := 0 to m_PostSellList.Count - 1 do
    Dispose(pTPostSell(m_PostSellList.Items[i]));
  m_PostSellList.Free;

  for i := 0 to m_PostGoldList.Count - 1 do
    Dispose(pTPostGold(m_PostGoldList.Items[i]));
  m_PostGoldList.Free;
  inherited;
end;

procedure TMerchant.ClearExpreUpgradeListData;
var
  i: Integer;
  UpgradeInfo: pTUpgradeInfo;
begin
  for i := m_UpgradeWeaponList.Count - 1 downto 0 do
  begin
    UpgradeInfo := m_UpgradeWeaponList.Items[i];
    if Integer(Round(Now - UpgradeInfo.dtTime)) >=
      g_Config.nClearExpireUpgradeWeaponDays then
    begin
      Dispose(UpgradeInfo);
      m_UpgradeWeaponList.Delete(i);
    end;
  end;
end;

procedure TMerchant.LoadNpcScript;
var
  SC: string;
begin
  m_ItemTypeList.Clear;
  m_sPath := sMarket_Def;
  SC := m_sScript + '-' + m_sMapName;
  FrmDB.LoadScriptFile(Self, sMarket_Def, SC, True);
  if Self = g_FunctionNPC then
    LoadQFLableList();
end;

procedure TMerchant.Click(PlayObject: TPlayObject);
begin
  inherited;
end;

procedure TMerchant.GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string);
var
  sText, s14: string;
  n18, i, ii, nCount: Integer;
  SellOff: pSellOff;
  PostGold: pTPostGold;
  List: TList;
  boFound: Boolean;
begin
  inherited;
  if sVariable = '$PRICERATE' then
  begin
    sText := IntToStr(m_nPriceRate);
    sMsg := ExVariableText(sMsg, '<$PRICERATE>', sText);
    Exit;
  end;
  if sVariable = '$UPGRADEWEAPONFEE' then
  begin
    sText := IntToStr(g_Config.nUpgradeWeaponPrice);
    sMsg := ExVariableText(sMsg, '<$UPGRADEWEAPONFEE>', sText);
    Exit;
  end;
  if sVariable = '$USERWEAPON' then
  begin
    if PlayObject.m_UseItems[U_WEAPON].wIndex <> 0 then
    begin
      sText :=
        UserEngine.GetStdItemName(PlayObject.m_UseItems[U_WEAPON].wIndex);
    end
    else
    begin
      sText := '无';
    end;
    sMsg := ExVariableText(sMsg, '<$USERWEAPON>', sText);
    Exit;
  end;
  if sVariable = '$QUERYYBDEALLOG' then
  begin
    sText := '';
    if m_PostGoldList <> nil then
    begin
      boFound := False;
      nCount := 0;
      for i := 0 to m_PostGoldList.Count - 1 do
      begin
        PostGold := pTPostGold(m_PostGoldList.Items[i]);
        if PostGold.sCharName = PlayObject.m_sCharName then
        begin
          boFound := True;
          Break;
        end;
      end;
      if boFound then
      begin
        n18 := 0;
        sText := '你的寄售物品在:\';
        for i := Low(PostGold.EGold) to High(PostGold.EGold) do
        begin
          if PostGold.EGold[i].nDealGold > 0 then
          begin
            if PostGold.EGold[i].boDealFlag then
            begin
              PostGold.EGold[i].boDealFlag := False;
              n18 := n18 + PostGold.EGold[i].nDealGold;
            end;
            sText := sText + FormatDateTime('dddddd,hh:mm:nn', PostGold.EGold[i].PostTime) + ', 与 ' + PostGold.EGold[i].sTargName + ' 交易成功, 获得 ' + IntToStr(PostGold.EGold[i].nDealGold) + ' 个元宝\';
            Inc(nCount);
          end;
        end;
        if n18 > 0 then
        begin
          FrmDB.SavePostGoldRecord(Self, m_sScript + '-' + m_sMapName);

          if PlayObject.m_nGameGold + n18 < High(Integer) then
          begin
            Inc(PlayObject.m_nGameGold, n18);
          end
          else
          begin
            n18 := High(Integer) - PlayObject.m_nGameGold;
            PlayObject.m_nGameGold := High(Integer);
          end;
          PlayObject.GameGoldChanged();

          if g_boGameLogGameGold then
            AddGameDataLogAPI(Format(g_sGameLogMsg1, [LOG_GAMEGOLD, PlayObject.m_sMapName, PlayObject.m_nCurrX, PlayObject.m_nCurrY, PlayObject.m_sCharName, g_Config.sGameGoldName, n18, '+', m_sCharName]));
        end;
      end;
      for i := 0 to m_PostGoldList.Count - 1 do
      begin
        PostGold := pTPostGold(m_PostGoldList.Items[i]);
        for ii := Low(PostGold.EGold) to High(PostGold.EGold) do
        begin
          if PostGold.EGold[ii].nDealGold > 0 then
          begin
            if PostGold.EGold[ii].sTargName = PlayObject.m_sCharName then
            begin
              sText := sText + FormatDateTime('dddddd,hh:mm:nn', PostGold.EGold[ii].PostTime) + ', 与 ' + PostGold.sCharName + ' 交易成功, 花费 ' + IntToStr(PostGold.EGold[ii].nDealGold) + ' 个元宝\';
              Inc(nCount);
              if nCount > 8 then
                Break;
            end;
          end;
        end;
        if nCount > 8 then
          Break;
      end;
    end;
    if sText = '' then
      sText := '当前没有任何物品交易记录';
    sMsg := ExVariableText(sMsg, '<$QUERYYBDEALLOG>', sText);
    Exit;
  end;

  //寄卖系统税率
  if sVariable = '$SELLOFFRATE' then
  begin
    sText := IntToStr(g_Config.SellTax) + '%';
    if sText = '' then
      sText := '10%';
    sMsg := ExVariableText(sMsg, '<$SELLOFFRATE>', sText);
    Exit;
  end;
  //我的物品
  if sVariable = '$SELLOFFITEM' then
  begin
    if m_SellOffList <> nil then
    begin
      sText := '';
      for i := m_SellOffList.Count - 1 downto 0 do
      begin
        List := m_SellOffList[i];
        if (List = nil) or (List.Count = 0) then
        begin
          m_SellOffList.Delete(i);
          Continue;
        end;
        for ii := 0 to List.Count - 1 do
        begin
          SellOff := pSellOff(List[ii]);
          if SellOff^.sCharName = PlayObject.m_sCharName then
          begin
            s14 := '';
            if SellOff^.item.btValue[13] = 1 then
              s14 := ItemUnit.GetCustomItemName(SellOff^.item.MakeIndex, SellOff^.item.wIndex);
            if s14 = '' then
              s14 := UserEngine.GetStdItemName(SellOff^.item.wIndex);
            sText := sText + '物品: ' + s14 + '  拍卖时间:' + DateTimeToStr(SellOff^.SellTime) + '\';
          end;
        end;
      end;
    end;
    if sText = '' then
      sText := '你没有在这拍卖的物品！';
    sMsg := ExVariableText(sMsg, '<$SELLOFFITEM>', sText);
    Exit;
  end;
  //我的款项
  if sVariable = '$SELLOUTGOLD' then
  begin
    if m_SellOffList <> nil then
    begin
      sText := '';
      for i := 0 to m_SellgoldList.Count - 1 do
      begin
        SellOff := pSellOff(m_SellgoldList[i]);
        if SellOff^.sCharName = PlayObject.m_sCharName then
        begin
          s14 := '';
          if SellOff^.item.btValue[13] = 1 then
            s14 := ItemUnit.GetCustomItemName(SellOff^.item.MakeIndex, SellOff^.item.wIndex);
          if s14 = '' then
            s14 := UserEngine.GetStdItemName(SellOff^.item.wIndex);
          sText := sText + '<物品: ' + s14 + '金额:' + IntToStr(SellOff^.Price) +
            '(税)' + IntToStr(SellOff^.Tax) + ' ' + g_Config.sGameGoldName +
            '  拍卖日期:' + DateTimeToStr(SellOff^.SellTime) + '>\';
        end;
      end;

    end;
    if sText = '' then
      sText := '你没有在这拍卖的款项！';
    sMsg := ExVariableText(sMsg, '<$SELLOUTGOLD>', sText);
    Exit;
  end;
end;

function TMerchant.GetExchgItemBookCnt(UserItem: pTUserItem): Integer;
var
  n10: Integer;
  StdItem: pTStdItem;
  nC: Integer;
  n14: Integer;
begin
  n10 := 0;
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (StdItem <> nil) then
  begin
    if not (StdItem.StdMode in [5, 6, 10..13, 15..24, 26..30, 51..54, 62..64]) then
    begin
      Result := -1;
      Exit;
    end;

    if StdItem.Need in [0..3] then
    begin
      n14 := StdItem.NeedLevel;
    end
    else if StdItem.Need = 4 then
    begin
      n14 := LoWord(StdItem.NeedLevel);
    end;

    if n14 < 38 then
    begin
      Result := -2;
      Exit;
    end;
    if n14 > 160 then
    begin
      Result := -3;
      Exit;
    end;

    n10 := n14;
    for nC := Low(UserItem.btValue) to High(UserItem.btValue) do
    begin
      if UserItem.btValue[nC] > 1 then
        Inc(n10);
    end;
    for nC := Low(UserItem.btValueEx) to High(UserItem.btValueEx) do
    begin
      if UserItem.btValueEx[nC] > 1 then
        Inc(n10);
    end;
  end;
  Result := n10 div 2;
end;

function TMerchant.GetUserItemPrice(UserItem: pTUserItem): Integer;
var
  n10: Integer;
  StdItem: pTStdItem;
  n20: real;
  nC: Integer;
  n14: Integer;
begin
  n10 := GetItemPrice(UserItem.wIndex);
  if n10 > 0 then
  begin
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) then
    begin
      if (StdItem.Overlap < 1) and (StdItem.StdMode > 4) and
        (StdItem.DuraMax > 0) and (UserItem.DuraMax > 0) then
      begin
        if StdItem.StdMode = 40 then
        begin //肉
          if UserItem.Dura <= UserItem.DuraMax then
          begin
            n20 := (n10 / 2.0 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
            n10 := _MAX(2, Round(n10 - n20));
          end
          else
            n10 := n10 + Round(n10 / UserItem.DuraMax * 2.0 * (UserItem.Dura - UserItem.DuraMax));
        end;

        if (StdItem.StdMode = 43) then
        begin
          if UserItem.DuraMax < 10000 then
            UserItem.DuraMax := 10000;
          if UserItem.Dura <= UserItem.DuraMax then
          begin
            n20 := (n10 / 2.0 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
            n10 := _MAX(2, Round(n10 - n20));
          end
          else
          begin
            //n10 := n10 + Round(n10 / UserItem.DuraMax * 1.3 * (UserItem.DuraMax - UserItem.Dura));
            n10 := n10 + Round(n10 / UserItem.DuraMax * 1.3 * (UserItem.Dura - UserItem.DuraMax));
          end;
        end;

        if (StdItem.Overlap < 1) and (StdItem.StdMode > 4) then
        begin
          n14 := 0;
          nC := 0;
          while (True) do
          begin
            if (StdItem.StdMode = 5) or (StdItem.StdMode = 6) then
            begin
              if (nC <> 4) or (nC <> 9) then
              begin
                if nC = 6 then
                begin
                  if UserItem.btValue[nC] > 10 then
                  begin
                    n14 := n14 + (UserItem.btValue[nC] - 10) * 2;
                  end;
                end
                else
                  n14 := n14 + UserItem.btValue[nC];
              end;
            end
            else
              Inc(n14, UserItem.btValue[nC]);
            Inc(nC);
            if nC >= 8 then
              Break;
          end;
          if n14 > 0 then
          begin
            n10 := n10 + (n10 div 5) * n14;
          end;
          n10 := Round(n10 / StdItem.DuraMax * UserItem.DuraMax);
          n20 := (n10 / 2.0 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
          n10 := _MAX(2, Round(n10 - n20));
        end;
      end;
    end;
  end;
  Result := n10;
end;

procedure TMerchant.ClientBuyItem(PlayObject: TPlayObject; sItemName: string; nInt, BuyCount: Integer);
var
  i, ii: Integer;
  done: Boolean;
  List20: TList;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  n1C, nPrice: Integer;
  sUserItemName: string;
begin
  done := False;
  n1C := 1;
  BuyCount := _MIN(MAX_OVERLAPITEM, BuyCount);
  for i := 0 to m_GoodsList.Count - 1 do
  begin
    if done or (m_boNoSeal) then
      Break;
    List20 := TList(m_GoodsList.Items[i]);
    UserItem := List20.Items[0];

    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then
    begin
      if PlayObject.IsAddWeightAvailable(UserEngine.GetStdItemWeight(UserItem.wIndex, BuyCount)) then
      begin
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName = '' then
          sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);
        if sUserItemName = sItemName then
        begin
          for ii := 0 to List20.Count - 1 do
          begin
            UserItem := List20.Items[ii];
            if (StdItem.StdMode <= 4) or (StdItem.StdMode = 42) or (StdItem.StdMode = 31) or (UserItem.MakeIndex = nInt) or (StdItem.Overlap >= 1) then
            begin
              nPrice := GetUserPrice(PlayObject, GetUserItemPrice(UserItem)) * BuyCount;
              if (PlayObject.m_nGold >= nPrice) and (nPrice > 0) then
              begin
                if StdItem.Overlap >= 1 then
                begin
                  UserItem.Dura := _MIN(MAX_OVERLAPITEM, BuyCount);
                  if PlayObject.UserCounterItemAdd(StdItem.StdMode, StdItem.Looks, BuyCount, StdItem.Name, False) then
                  begin
                    Dec(PlayObject.m_nGold, nPrice);
                    List20.Delete(ii);
                    if List20.Count = 0 then
                    begin
                      List20.Free;
                      m_GoodsList.Delete(i);
                    end;
                    PlayObject.WeightChanged;
                    n1C := 0;
                    done := True;
                    Break;
                  end;
                end;

                if PlayObject.AddItemToBag(UserItem) then
                begin
                  Dec(PlayObject.m_nGold, nPrice);
                  if m_boCastle or g_Config.boGetAllNpcTax then
                  begin
                    if m_Castle <> nil then
                      TUserCastle(m_Castle).IncRateGold(nPrice)
                    else if g_Config.boGetAllNpcTax then
                      g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
                  end;
                  PlayObject.SendAddItem(UserItem);
                  if StdItem.NeedIdentify = 1 then
                    AddGameDataLogAPI('9' + #9 +
                      PlayObject.m_sMapName + #9 +
                      IntToStr(PlayObject.m_nCurrX) + #9 +
                      IntToStr(PlayObject.m_nCurrY) + #9 +
                      PlayObject.m_sCharName + #9 +
                      StdItem.Name + #9 +
                      IntToStr(UserItem.MakeIndex) + #9 +
                      IntToStr(BuyCount) + #9 +
                      m_sCharName);
                  List20.Delete(ii);
                  if List20.Count <= 0 then
                  begin
                    List20.Free;
                    m_GoodsList.Delete(i);
                  end;
                  n1C := 0;
                end
                else
                  n1C := 2;
              end
              else
                n1C := 3;
              done := True;
              Break;
            end;
          end;
        end;
      end
      else
      begin
        n1C := 2;
        Break;
      end;
    end;
  end;
  
  if n1C = 0 then
    PlayObject.SendMsg(Self, RM_BUYITEM_SUCCESS, 0, PlayObject.m_nGold, nInt, 0, '')
  else
    PlayObject.SendMsg(Self, RM_BUYITEM_FAIL, 0, n1C, 0, 0, '');
end;

procedure TMerchant.ClientGetDetailGoodsList(PlayObject: TPlayObject; sItemName: string; nInt: Integer; nIdent: Integer);
var
  i, ii, nItemCount, nPrice: Integer;
  List: TList;
  UserItem: pTUserItem;
  item: TUserItem;
  pStdItem: pTStdItem;
  StdItem: TStdItem;
  ClientItem: TClientItem;
  sSENDMSG: string;
  SellOff: pSellOff;
begin
  if m_SellOffList.Count > 0 then
  begin
    nItemCount := 0;
    for i := 0 to m_SellOffList.Count - 1 do
    begin
      List := m_SellOffList[i];
      SellOff := pSellOff(List[0]);
      pStdItem := UserEngine.GetStdItem(SellOff.item.wIndex);
      if (pStdItem <> nil) and (pStdItem.Name = sItemName) then
      begin
        if (List.Count - 1) < nInt then
          nInt := _MAX(0, List.Count - 10);
        for ii := List.Count - 1 downto 0 do
        begin
          SellOff := pSellOff(List[ii]);
          item := SellOff.item;
          pStdItem := UserEngine.GetStdItem(item.wIndex);
          StdItem := pStdItem^;
          ItemUnit.GetItemAddValue(@item, StdItem);
          if SellOff.sCharName = PlayObject.m_sCharName then
            nPrice := 0
          else
            nPrice := SellOff.Price;
{$IF VER_ClientType_45}
          if PlayObject.m_nSoftVersionDateEx = 0 then
          begin
            CopyStdItemToOStdItem(@StdItem, @OClientItem.s);
            OClientItem.Dura := item.Dura;
            OClientItem.DuraMax := item.DuraMax;
            OClientItem.MakeIndex := item.MakeIndex;
            OClientItem.s.Price := nPrice;
            sSENDMSG := sSENDMSG + (EncodeBuffer(@OClientItem, SizeOf(TOClientItem))) + '/';
          end
          else
          begin
{$IFEND VER_ClientType_45}
            //ClientItem.s := StdItem;
            Move(StdItem, ClientItem.s, SizeOf(TClientStdItem));
            ClientItem.Dura := item.Dura;
            ClientItem.DuraMax := item.DuraMax;
            ClientItem.MakeIndex := item.MakeIndex;
            ClientItem.s.Price := nPrice;
            ClientItem.s.ItemType := item.btValue[14];

            GetSendClientItem(@item, PlayObject, ClientItem);

            sSENDMSG := sSENDMSG + (EncodeBuffer(@ClientItem, SizeOf(TClientItem))) + '/';
{$IF VER_ClientType_45}
          end;
{$IFEND VER_ClientType_45}
          Inc(nItemCount);
          if nItemCount >= 10 then Break;
        end;
        Break;
      end;
    end;
    PlayObject.SendMsg(Self, RM_GETSELLITEMSLIST, nIdent, Integer(Self), nItemCount, nInt, sSENDMSG);
    Exit;
  end;
{$IF VER_ClientType_45}
  if PlayObject.m_nSoftVersionDateEx = 0 then
  begin
    nItemCount := 0;
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      List := TList(m_GoodsList.Items[i]);
      if List.Count <= 0 then
        Continue;
      UserItem := List.Items[0];
      pStdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if (pStdItem <> nil) and (pStdItem.Name = sItemName) then
      begin
        if (List.Count - 1) < nInt then
          nInt := _MAX(0, List.Count - 10);
        StdItem := pStdItem^;
        ItemUnit.GetItemAddValue(UserItem, StdItem);
        //for ii := List.Count - 1 downto 0 do begin
        for ii := nInt to List.Count - 1 do
        begin
          UserItem := List.Items[ii];
          StdItem := pStdItem^;
          ItemUnit.GetItemAddValue(UserItem, StdItem);
          CopyStdItemToOStdItem(@StdItem, @OClientItem.s);
          OClientItem.Dura := UserItem.Dura;
          OClientItem.DuraMax := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
          OClientItem.MakeIndex := UserItem.MakeIndex;
          sSENDMSG := sSENDMSG + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
          Inc(nItemCount);
          if nItemCount >= 10 then
            Break;
        end;
        Break;
      end;
    end;
    PlayObject.SendMsg(Self, RM_SENDDETAILGOODSLIST, nIdent, Integer(Self), nItemCount, nInt, sSENDMSG);
  end
  else
  begin
{$IFEND VER_ClientType_45}
    nItemCount := 0;
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      List := TList(m_GoodsList.Items[i]);
      if List.Count <= 0 then
        Continue;
      UserItem := List.Items[0];
      pStdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if (pStdItem <> nil) and (pStdItem.Name = sItemName) then
      begin
        if (List.Count - 1) < nInt then
          nInt := _MAX(0, List.Count - 10);
        StdItem := pStdItem^;
        ItemUnit.GetItemAddValue(UserItem, StdItem);
        //for ii := List.Count - 1 downto 0 do begin
        for ii := nInt to List.Count - 1 do
        begin
          UserItem := List.Items[ii];
          StdItem := pStdItem^;
          ItemUnit.GetItemAddValue(UserItem, StdItem);
          //ClientItem.s := StdItem;
          Move(StdItem, ClientItem.s, SizeOf(TClientStdItem));
          ClientItem.Dura := UserItem.Dura;
          ClientItem.DuraMax := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
          ClientItem.MakeIndex := UserItem.MakeIndex;
          ClientItem.s.ItemType := UserItem.btValue[14];
          GetSendClientItem(UserItem, PlayObject, ClientItem);
          sSENDMSG := sSENDMSG + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
          if nIdent = 0 then
          begin
            Inc(nItemCount);
            if nItemCount >= 10 then Break;
          end;
        end;
        Break;
      end;
    end;
    PlayObject.SendMsg(Self, RM_SENDDETAILGOODSLIST, nIdent, Integer(Self), nItemCount, nInt, sSENDMSG);
{$IF VER_ClientType_45}
  end;
{$IFEND VER_ClientType_45}
end;

procedure TMerchant.ClientGetSaleItemList(PlayObject: TPlayObject; sItemName: string; nZz: Integer);
var
  item: TUserItem;
  SellOff: pSellOff;
  i, ii, nItemCount, nPrice: Integer;
  List: TList;
  StdItem: pTStdItem;
  sItem: TStdItem;
  sSENDMSG: string;
  ClientItem: TClientItem;
begin
  if m_SellOffList.Count > 0 then
  begin
    nItemCount := 0;
    for i := 0 to m_SellOffList.Count - 1 do
    begin
      List := m_SellOffList[i];
      SellOff := pSellOff(List[0]);
      StdItem := UserEngine.GetStdItem(SellOff.item.wIndex);
      if (StdItem <> nil) and (StdItem.Name = sItemName) then
      begin
        if (List.Count - 1) < nZz then
          nZz := _MAX(0, List.Count - 10);
        for ii := List.Count - 1 downto 0 do
        begin
          SellOff := pSellOff(List[ii]);
          item := SellOff.item;
          StdItem := UserEngine.GetStdItem(item.wIndex);
          sItem := StdItem^;
          ItemUnit.GetItemAddValue(@item, sItem);
          if CompareText(SellOff.sCharName, PlayObject.m_sCharName) = 0 then
            nPrice := 0
          else
            nPrice := SellOff.Price;
{$IF VER_ClientType_45}
          if PlayObject.m_nSoftVersionDateEx = 0 then
          begin
            CopyStdItemToOStdItem(@sItem, @OClientItem.s);
            OClientItem.Dura := item.Dura;
            OClientItem.DuraMax := item.DuraMax;
            OClientItem.MakeIndex := item.MakeIndex;
            OClientItem.s.Price := nPrice;
            sSENDMSG := sSENDMSG + (EncodeBuffer(@OClientItem, SizeOf(TOClientItem))) + '/';
          end
          else
          begin
{$IFEND VER_ClientType_45}
            Move(sItem, ClientItem.s, SizeOf(TClientStdItem));
            ClientItem.Dura := item.Dura;
            ClientItem.DuraMax := item.DuraMax;
            ClientItem.MakeIndex := item.MakeIndex;
            ClientItem.s.Price := nPrice;
            ClientItem.s.ItemType := item.btValue[14];
            GetSendClientItem(@item, PlayObject, ClientItem);
            sSENDMSG := sSENDMSG + (EncodeBuffer(@ClientItem, SizeOf(TClientItem))) + '/';
{$IF VER_ClientType_45}
          end;
{$IFEND VER_ClientType_45}
          Inc(nItemCount);
          if nItemCount >= 10 then
            Break;
        end;
        Break;
      end;
    end;
    PlayObject.SendMsg(Self, RM_GETSELLITEMSLIST, 0, Integer(Self), nItemCount, nZz, sSENDMSG);
  end;
end;

procedure TMerchant.ClientBuySaleItem(PlayObject: TPlayObject; sItemName: string; nMakeIndex: Integer);
var
  UserItem: pTUserItem;
  sUserItemName, sMapName: string;
  SellOff: pSellOff;
  i, ii: Integer;
  List: TList;
  pStdItem: pTStdItem;
  sSENDMSG: string;
  nECode, nPrice: Integer;
  boNotEnoughGold: Boolean;
  Player: TPlayObject;
begin
  boNotEnoughGold := False;
  nECode := 1;
  if m_SellOffList <> nil then
  begin
    sItemName := Trim(sItemName);
    sSENDMSG := '';
    for i := 0 to m_SellOffList.Count - 1 do
    begin
      if boNotEnoughGold then
        Break;
      List := m_SellOffList[i];
      if (List = nil) or (List.Count = 0) then
        Continue;
      SellOff := pSellOff(List[0]);
      if SellOff <> nil then
      begin
        sUserItemName := UserEngine.GetStdItemName(SellOff.item.wIndex);
        pStdItem := UserEngine.GetStdItem(SellOff.item.wIndex);
        if pStdItem <> nil then
        begin
          if PlayObject.IsAddWeightAvailable(pStdItem.Weight) then
          begin //0625
            if CompareText(sUserItemName, sItemName) = 0 then
            begin

              for ii := List.Count - 1 downto 0 do
              begin
                SellOff := pSellOff(List[ii]);
                if (SellOff.item.MakeIndex = nMakeIndex) then
                begin
                  if CompareText(SellOff.sCharName, PlayObject.m_sCharName) = 0 then
                    nPrice := 0
                  else
                    nPrice := SellOff.Price;
                  if (PlayObject.m_nGameGold >= nPrice) and (nPrice >= 0) then
                  begin
                    New(UserItem);
                    UserItem^ := SellOff.item;
                    if PlayObject.AddItemToBag(UserItem) then
                    begin
                      PlayObject.SendAddItem(UserItem);
                      PlayObject.m_nGameGold := PlayObject.m_nGameGold - nPrice;
                      if nPrice > 0 then
                        if g_boGameLogGameGold then
                          AddGameDataLogAPI(Format(g_sGameLogMsg1, [LOG_GAMEGOLD, PlayObject.m_sMapName, PlayObject.m_nCurrX, PlayObject.m_nCurrY, PlayObject.m_sCharName, g_Config.sGameGoldName, nPrice, '-', m_sCharName]));
                      if pStdItem.NeedIdentify = 1 then
                        AddGameDataLogAPI('14' + #9 + m_sMapName + #9 + IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 + m_sCharName + #9 + pStdItem.Name + #9 + IntToStr(UserItem^.MakeIndex) + #9 + '1' + #9 + m_sCharName);
                      if nPrice = 0 then
                        Dispose(SellOff)
                      else
                      begin
                        Player := UserEngine.GetPlayObject(SellOff.sCharName);
                        if m_PEnvir <> nil then
                          sMapName := m_PEnvir.m_sMapDesc;
                        if Player <> nil then
                          Player.SysMsg(Format('你的物品%s已被卖出，请立即到%s(%d:%d)的%s领取拍卖款。', [pStdItem^.Name, sMapName, m_nCurrX, m_nCurrY, m_sCharName]), c_Purple, t_Hint);
                        SellOff.Tax := (SellOff.Price * g_Config.SellTax) div 100;
                        SellOff.Price := SellOff.Price - SellOff.Tax;
                        m_SellgoldList.Add(SellOff);
                        SaveSellGold;
                      end;
                      List.Delete(ii);
                      if List.Count <= 0 then
                        m_SellOffList.Delete(i);
                      SaveSellOff;
                      nECode := 0;
                      boNotEnoughGold := True;
                      Break;
                    end
                    else
                    begin
                      Dispose(UserItem);
                      nECode := 2;
                      Break;
                    end;
                  end
                  else
                  begin
                    nECode := 3;
                    boNotEnoughGold := True;
                    Break;
                  end;
                end;
              end;
            end;
          end
          else
          begin
            nECode := 2;
            Break;
          end;

        end;
      end;
    end;
  end;

  if nECode = 0 then
    PlayObject.SendDefMessage(20010, PlayObject.m_nGameGold, LoWord(nMakeIndex), HiWord(nMakeIndex), 0, '')
  else
    PlayObject.SendDefMessage(20011, nECode, 0, 0, 0, '');
end;

procedure TMerchant.ClientQueryExchgBook(PlayObject: TPlayObject; UserItem: pTUserItem);
var
  nC: Integer;
begin
  nC := GetExchgItemBookCnt(UserItem);
  PlayObject.SendMsg(Self, RM_SENDBOOKCNT, 0, nC, 0, 0, '')
end;

procedure TMerchant.ClientQuerySellPrice(PlayObject: TPlayObject; UserItem: pTUserItem);
var
  nC: Integer;
begin
  nC := GetSellItemPrice(GetUserItemPrice(UserItem));
  if (nC >= 0) then
    PlayObject.SendMsg(Self, RM_SENDBUYPRICE, 0, nC, 0, 0, '')
  else
    PlayObject.SendMsg(Self, RM_SENDBUYPRICE, 0, 0, 0, 0, '');
end;

function TMerchant.GetSellItemPrice(nPrice: Integer): Integer;
begin
  Result := Round(nPrice / 2.0);
end;

function TMerchant.ClientSellItem(PlayObject: TPlayObject; UserItem: pTUserItem): Boolean;

  function sub_4A1C84(UserItem: pTUserItem): Boolean;
  var
    StdItem: pTStdItem;
  begin
    Result := True;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and ((StdItem.StdMode = 25) or (StdItem.StdMode = 30)) then
    begin
      if UserItem.Dura < 4000 then
        Result := False;
    end;
  end;
var
  nPrice: Integer;
  StdItem: pTStdItem;
begin
  Result := False;
  nPrice := GetSellItemPrice(GetUserItemPrice(UserItem));
  if (nPrice > 0) and (not m_boNoSeal) and sub_4A1C84(UserItem) then
  begin
    if PlayObject.IncGold(nPrice) then
    begin
      if m_boCastle or g_Config.boGetAllNpcTax then
      begin
        if m_Castle <> nil then
          TUserCastle(m_Castle).IncRateGold(nPrice)
        else if g_Config.boGetAllNpcTax then
          g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
      end;
      PlayObject.SendMsg(Self, RM_USERSELLITEM_OK, 0, PlayObject.m_nGold, 0, 0, '');
      AddItemToGoodsList(UserItem);
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem.NeedIdentify = 1 then
        AddGameDataLogAPI('10' + #9 + PlayObject.m_sMapName + #9 + IntToStr(PlayObject.m_nCurrX) + #9 + IntToStr(PlayObject.m_nCurrY) + #9 + PlayObject.m_sCharName + #9 + StdItem.Name + #9 + IntToStr(UserItem.MakeIndex) + #9 + '1' + #9 + m_sCharName);
      Result := True;
    end
    else
      PlayObject.SendMsg(Self, RM_USERSELLITEM_FAIL, 0, 0, 0, 0, '');
  end
  else
    PlayObject.SendMsg(Self, RM_USERSELLITEM_FAIL, 0, 0, 0, 0, '');
end;

function TMerchant.ClientSellCountItem(PlayObject: TPlayObject; UserItem: pTUserItem; nCount: Integer): Boolean;

  function CanSell(UserItem: pTUserItem): Boolean;
  var
    StdItem: pTStdItem;
  begin
    Result := True;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and ((StdItem.StdMode = 25) or (StdItem.StdMode = 30)) then
    begin
      if UserItem.Dura < 4000 then
        Result := False;
    end;
  end;
var
  remain: Integer;
  nPrice: Integer;
  StdItem: pTStdItem;
begin
  Result := False;
  nPrice := GetSellItemPrice(GetUserItemPrice(UserItem)) * nCount;
  remain := UserItem.Dura - nCount;
  if (nPrice > 0) and (not m_boNoSeal) and CanSell(UserItem) then
  begin
    if PlayObject.IncGold(nPrice) then
    begin
      if m_boCastle or g_Config.boGetAllNpcTax then
      begin
        if m_Castle <> nil then
          TUserCastle(m_Castle).IncRateGold(nPrice)
        else if g_Config.boGetAllNpcTax then
          g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
      end;
      PlayObject.SendMsg(Self, RM_USERSELLCOUNTITEM_OK, UserItem.MakeIndex, PlayObject.m_nGold, remain, nCount, '');
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem.NeedIdentify = 1 then
        AddGameDataLogAPI('10' + #9 + PlayObject.m_sMapName + #9 + IntToStr(PlayObject.m_nCurrX) + #9 + IntToStr(PlayObject.m_nCurrY) + #9 + PlayObject.m_sCharName + #9 + StdItem.Name + #9 + IntToStr(UserItem.MakeIndex) + #9 + '1' + #9 + m_sCharName);
      Result := True;
    end
    else
      PlayObject.SendMsg(Self, RM_USERSELLCOUNTITEM_FAIL, 0, 0, 0, 0, '');
  end
  else
    PlayObject.SendMsg(Self, RM_USERSELLCOUNTITEM_FAIL, 0, 0, 0, 0, '');
end;

function TMerchant.AddItemToGoodsList(UserItem: pTUserItem): Boolean;
var
  ItemList: TList;
begin
  Result := False;
  if UserItem.Dura <= 0 then
    Exit;
  ItemList := GetRefillList(UserItem.wIndex);
  if ItemList = nil then
  begin
    ItemList := TList.Create;
    m_GoodsList.Add(ItemList);
  end;
  ItemList.Insert(0, UserItem);
  Result := True;
end;

procedure TMerchant.ClientMakeDrugItem(PlayObject: TPlayObject; sItemName: string);

  function sub_4A28FC(PlayObject: TPlayObject; sItemName: string): Boolean;
  var
    i, ii, n1C: Integer;
    List10: TStringList;
    s20: string;
    List28: TStringList;
    UserItem: pTUserItem;
    ps: pTStdItem;
  begin
    Result := False;
    List10 := GetMakeItemInfo(sItemName);
    if List10 = nil then
      Exit;
    Result := True;
    for i := 0 to List10.Count - 1 do
    begin
      s20 := List10.Strings[i];
      n1C := Integer(List10.Objects[i]);
      for ii := 0 to PlayObject.m_ItemList.Count - 1 do
      begin
        UserItem := pTUserItem(PlayObject.m_ItemList[ii]);
        if UserEngine.GetStdItemName(UserItem.wIndex) = s20 then
        begin
          ps := UserEngine.GetStdItem(UserItem.wIndex);
          if ps <> nil then
          begin
            if ps.Overlap >= 1 then
              n1C := n1C - _MIN(UserItem.Dura, n1C)
            else
              Dec(n1C);
          end;
        end;
      end;
      if n1C > 0 then
      begin
        Result := False;
        Break;
      end;
    end; // for
    if Result then
    begin
      List28 := nil;
      for i := 0 to List10.Count - 1 do
      begin
        s20 := List10.Strings[i];
        n1C := Integer(List10.Objects[i]);
        for ii := PlayObject.m_ItemList.Count - 1 downto 0 do
        begin
          if n1C <= 0 then
            Break;
          UserItem := PlayObject.m_ItemList.Items[ii];
          if UserEngine.GetStdItemName(UserItem.wIndex) = s20 then
          begin
            ps := UserEngine.GetStdItem(UserItem.wIndex);
            if ps <> nil then
            begin
              if ps.Overlap >= 1 then
              begin
                if UserItem.Dura < Integer(List10.Objects[i]) then
                  UserItem.Dura := 0
                else
                  UserItem.Dura := UserItem.Dura - Integer(List10.Objects[i]);

                if UserItem.Dura > 0 then
                begin
                  PlayObject.SendMsg(Self, RM_COUNTERITEMCHANGE, 0, UserItem.MakeIndex, UserItem.Dura, 0, ps.Name);
                  Continue;
                end;
              end;
              if List28 = nil then
                List28 := TStringList.Create;
              List28.AddObject(s20, TObject(UserItem.MakeIndex));
              Dispose(UserItem);
              PlayObject.m_ItemList.Delete(ii);
              Dec(n1C);
            end;
          end;
        end;
      end;
      if List28 <> nil then
        PlayObject.SendMsg(Self, RM_SENDDELITEMLIST, 0, Integer(List28), 0, 0, '');
    end;
  end;
var
  i: Integer;
  List1C: TList;
  MakeItem, UserItem: pTUserItem;
  StdItem: pTStdItem;
  n14: Integer;
begin
  n14 := 1;
  for i := 0 to m_GoodsList.Count - 1 do
  begin
    List1C := TList(m_GoodsList.Items[i]);
    MakeItem := List1C.Items[0];
    StdItem := UserEngine.GetStdItem(MakeItem.wIndex);
    if (StdItem <> nil) and (StdItem.Name = sItemName) then
    begin
      if PlayObject.m_nGold >= g_Config.nMakeDurgPrice then
      begin
        if sub_4A28FC(PlayObject, sItemName) then
        begin
          New(UserItem);
          UserEngine.CopyToUserItemFromName(sItemName, UserItem);
          if PlayObject.AddItemToBag(UserItem) then
          begin
            Dec(PlayObject.m_nGold, g_Config.nMakeDurgPrice);
            PlayObject.SendAddItem(UserItem);
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            if StdItem.NeedIdentify = 1 then
              AddGameDataLogAPI('2' + #9 +
                PlayObject.m_sMapName + #9 +
                IntToStr(PlayObject.m_nCurrX) + #9 +
                IntToStr(PlayObject.m_nCurrY) + #9 +
                PlayObject.m_sCharName + #9 +
                //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                m_sCharName);
            n14 := 0;
            //PlayObject.m_dwSaveRcdTick := 0; //0408_1
            Break;
          end
          else
          begin
            Dispose(UserItem);
            n14 := 2;
          end;
        end
        else
          n14 := 4;
      end
      else
        n14 := 3;
    end;
  end; // for
  if n14 = 0 then
    PlayObject.SendMsg(Self, RM_MAKEDRUG_SUCCESS, 0, PlayObject.m_nGold, 0, 0, '')
  else
    PlayObject.SendMsg(Self, RM_MAKEDRUG_FAIL, 0, n14, 0, 0, '');
end;

procedure TMerchant.ClientQueryRepairCost(PlayObject: TPlayObject; UserItem: pTUserItem);
var
  nPrice, nRepairPrice: Integer;
begin
  nPrice := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
  if (nPrice > 0) and (UserItem.DuraMax > UserItem.Dura) then
  begin
    if UserItem.DuraMax > 0 then
    begin
      nRepairPrice := Round(nPrice div 3 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
    end
    else
      nRepairPrice := nPrice;
    if (PlayObject.m_sScriptLable = sSUPERREPAIR) then
    begin
      if m_boS_repair then
        nRepairPrice := nRepairPrice * g_Config.nSuperRepairPriceRate {3}
      else
        nRepairPrice := -1;
    end
    else
    begin
      if not m_boRepair then
        nRepairPrice := -1;
    end;
    PlayObject.SendMsg(Self, RM_SENDREPAIRCOST, 0, nRepairPrice, 0, 0, '');
  end
  else
  begin
    PlayObject.SendMsg(Self, RM_SENDREPAIRCOST, 0, -1, 0, 0, '');
  end;
end;

function TMerchant.ClientRepairItem(PlayObject: TPlayObject; UserItem: pTUserItem): Boolean;
var
  nPrice, nRepairPrice: Integer;
  StdItem: pTStdItem;
  boCanRepair: Boolean;
begin
  Result := False;
  boCanRepair := True;
  if (PlayObject.m_sScriptLable = sSUPERREPAIR) and not m_boS_repair then
    boCanRepair := False;
  if (PlayObject.m_sScriptLable <> sSUPERREPAIR) and not m_boRepair then
    boCanRepair := False;
  if PlayObject.m_sScriptLable = '@fail_s_repair' then
  begin
    SendMsgToUser(PlayObject, '对不起, 我不能帮你修理此类物品。\ \ \<Main/@main>');
    PlayObject.SendMsg(Self, RM_USERREPAIRITEM_FAIL, 0, 0, 0, 0, '');
    Exit;
  end;
  nPrice := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
  if PlayObject.m_sScriptLable = sSUPERREPAIR then
    nPrice := nPrice * g_Config.nSuperRepairPriceRate;
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if StdItem <> nil then
  begin
    if boCanRepair and (nPrice > 0) and (UserItem.DuraMax > UserItem.Dura) and (StdItem.StdMode <> 43) then
    begin
      if UserItem.DuraMax > 0 then
        nRepairPrice := Round(nPrice div 3 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura))
      else
        nRepairPrice := nPrice;
      if PlayObject.DecGold(nRepairPrice) then
      begin
        if m_boCastle or g_Config.boGetAllNpcTax then
        begin
          if m_Castle <> nil then
          begin
            TUserCastle(m_Castle).IncRateGold(nRepairPrice);
          end
          else if g_Config.boGetAllNpcTax then
          begin
            g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
          end;
        end;
        if PlayObject.m_sScriptLable = sSUPERREPAIR then
        begin
          UserItem.Dura := UserItem.DuraMax;
          PlayObject.SendMsg(Self, RM_USERREPAIRITEM_OK, 0, PlayObject.m_nGold,
            UserItem.Dura, UserItem.DuraMax, '');
          GotoLable(PlayObject, sSUPERREPAIROK, False);
        end
        else
        begin
          //Dec(UserItem.DuraMax, (UserItem.DuraMax - UserItem.Dura) div g_Config.nRepairItemDecDura);
          nPrice := (UserItem.DuraMax - UserItem.Dura) div g_Config.nRepairItemDecDura;
          if UserItem.DuraMax > nPrice then
            UserItem.DuraMax := UserItem.DuraMax - nPrice
          else
            UserItem.DuraMax := 1;
          UserItem.Dura := UserItem.DuraMax;
          PlayObject.SendMsg(Self, RM_USERREPAIRITEM_OK, 0, PlayObject.m_nGold, UserItem.Dura, UserItem.DuraMax, '');
          GotoLable(PlayObject, sREPAIROK, False);
        end;
        Result := True;
      end
      else
        PlayObject.SendMsg(Self, RM_USERREPAIRITEM_FAIL, 0, 0, 0, 0, '');
    end
    else
      PlayObject.SendMsg(Self, RM_USERREPAIRITEM_FAIL, 0, 0, 0, 0, '');
  end;
end;

procedure TMerchant.ClearScript;
begin
  m_boBuy := False;
  m_boSell := False;
  m_boMakeDrug := False;
  m_boPrices := False;
  m_boStorage := False;
  m_boGetback := False;
  m_boUpgradenow := False;
  m_boGetBackupgnow := False;
  m_boRepair := False;
  m_boS_repair := False;
  m_boGetMarry := False;
  m_boGetMaster := False;
  m_boDealGold := False;
  m_boUseItemName := False;
  m_boOffLineMsg := False;
  m_boMakeHero := False;
  m_boCreateHero := False;
  m_boInputInteger := False;
  m_boInputString := False;
  m_boYBDeal := False;
  m_boItemMarket := False;
  m_sMDlgImgName := '';
  inherited;
end;

procedure TMerchant.LoadUpgradeList;
var
  i: Integer;
resourcestring
  sLoadMsg = '[%s(%s %d:%d)] 读取%d条升级武器数据';
begin
  for i := 0 to m_UpgradeWeaponList.Count - 1 do
    Dispose(pTUpgradeInfo(m_UpgradeWeaponList.Items[i]));
  m_UpgradeWeaponList.Clear;
  try
    if FrmDB.LoadUpgradeWeaponRecord(m_sScript + '-' + m_sMapName, m_UpgradeWeaponList) > 0 then
      MainOutMessageAPI(Format(sLoadMsg, [m_sCharName, m_sMapName, m_nCurrX, m_nCurrY, m_UpgradeWeaponList.Count]));
  except
    MainOutMessageAPI('Failure in loading upgradinglist - ' + m_sCharName);
  end;
end;

procedure TMerchant.GetMarry(PlayObject: TPlayObject; sDearName: string);
var
  MarryHuman: TPlayObject;
begin
  MarryHuman := UserEngine.GetPlayObject(sDearName);
  if (MarryHuman <> nil) and
    (MarryHuman.m_PEnvir = PlayObject.m_PEnvir) and
    (abs(PlayObject.m_nCurrX - MarryHuman.m_nCurrX) < 5) and
    (abs(PlayObject.m_nCurrY - MarryHuman.m_nCurrY) < 5) then
    SendMsgToUser(MarryHuman, PlayObject.m_sCharName + ' 向你求婚，你是否愿意嫁给他为妻？')
  else
    Self.SendMsgToUser(PlayObject, sDearName + ' 没有在你身边，你的请求无效');
end;

procedure TMerchant.GetMaster(PlayObject: TPlayObject; sMasterName: string);
begin

end;

procedure TMerchant.SendCustemMsg(PlayObject: TPlayObject; sMsg: string);
begin
  inherited;
end;

procedure TMerchant.ClearData();
var
  i, ii: Integer;
  UserItem: pTUserItem;
  ItemList: TList;
  ItemPrice: pTItemPrice;
resourcestring
  sExceptionMsg = '[Exception] TMerchant::ClearData';
begin
  try
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      ItemList := TList(m_GoodsList.Items[i]);
      for ii := 0 to ItemList.Count - 1 do
      begin
        UserItem := ItemList.Items[ii];
        Dispose(UserItem);
      end;
      ItemList.Free;
    end;
    m_GoodsList.Clear;

    for i := 0 to m_ItemPriceList.Count - 1 do
    begin
      ItemPrice := m_ItemPriceList.Items[i];
      Dispose(ItemPrice);
    end;
    m_ItemPriceList.Clear;

    SaveNPCData();
  except
    on E: Exception do
    begin
      MainOutMessageAPI(sExceptionMsg);
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

procedure TMerchant.RemoteMusic(PlayObject: TPlayObject; sLabel, sChrName: string);
var
  Player: TPlayObject;
  sLineText, sSENDMSG, sMusic: string;
resourcestring
  sMsg = '%s/你好，%s！\你的朋友：%s 发送以下音乐给你：\ \<%s/@rmst://%s|%s>';
begin
  Player := UserEngine.GetPlayObject(sChrName);
  if Player <> nil then
  begin
    if Player.m_boRemoteMsg then
    begin
      sLineText := Copy(sLabel, Length(sREMOTEMUSIC) + 1, Length(sLabel) - Length(sREMOTEMUSIC));
      sLineText := GetValidStr3(sLineText, sMusic, ['|']);
      sSENDMSG := Format(sMsg, [m_sCharName, Player.m_sCharName, PlayObject.m_sCharName, sMusic, sMusic, sLineText]);
      Player.SendMsg(Player, RM_REMOTEMSG, 0, 0, 0, 0, EncodeString(sSENDMSG));
    end
    else
      PlayObject.SysMsg(Format('%s 不允许接收信息！', [Player.m_sCharName]), c_Red, t_Hint);
  end
  else
    PlayObject.SysMsg(Format(g_sNowNotOnLineOrOnOtherServer, [sChrName]), c_Red, t_Hint);
end;

procedure TMerchant.RemoteMsg(PlayObject: TPlayObject; sLabel, sChrName: string);
var
  Player: TPlayObject;
  sLineText, sSENDMSG: string;
resourcestring
  sMsg = '%s/你好，%s！\您的朋友：%s 发给你以下消息：\ \<请点击查看/@http://%s>';
begin
  Player := UserEngine.GetPlayObject(sChrName);
  if Player <> nil then
  begin
    if Player.m_boRemoteMsg then
    begin
      sLineText := Copy(sLabel, Length(sREMOTEMUSIC) + 1, Length(sLabel) - Length(sREMOTEMUSIC));
      sSENDMSG := Format(sMsg, [m_sCharName, Player.m_sCharName, PlayObject.m_sCharName, sLineText]);
      Player.SendMsg(Player, RM_REMOTEMSG, 0, 0, 0, 0, EncodeString(sSENDMSG));
    end
    else
      PlayObject.SysMsg(Format('%s 不允许接收信息！', [Player.m_sCharName]), c_Red, t_Hint);
  end
  else
    PlayObject.SysMsg(Format(g_sNowNotOnLineOrOnOtherServer, [sChrName]), c_Red, t_Hint);
end;

procedure TMerchant.StartDealGold(PlayObject: TPlayObject; sLabel, sGold: string);
var
  nDealGold: Integer;
  PoseBaseObject: TBaseObject;
begin
  nDealGold := Str_ToInt(sGold, -1);
  if nDealGold >= 0 then
  begin
    if PlayObject.m_nGameGold >= nDealGold then
    begin
      PoseBaseObject := PlayObject.GetPoseCreate();
      if (PoseBaseObject = nil) or (PoseBaseObject.GetPoseCreate <> PlayObject) or (PoseBaseObject.m_btRaceServer <> RC_PLAYOBJECT) or (PlayObject.m_DealGoldCreat <> PoseBaseObject) then
      begin
        GotoLable(PlayObject, '@dealgoldPlayError', False);
        Exit;
      end;
      Dec(PlayObject.m_nGameGold, nDealGold);
      if g_boGameLogGameGold then
        AddGameDataLogAPI(Format(g_sGameLogMsg1, [LOG_GAMEGOLD, PlayObject.m_sMapName, PlayObject.m_nCurrX, PlayObject.m_nCurrY, PlayObject.m_sCharName, g_Config.sGameGoldName, nDealGold, '-', m_sCharName]));

      if TPlayObject(PoseBaseObject).m_nGameGold + nDealGold < High(Integer) then
      begin
        Inc(TPlayObject(PoseBaseObject).m_nGameGold, nDealGold);
      end
      else
      begin
        nDealGold := High(Integer) - TPlayObject(PoseBaseObject).m_nGameGold;
        TPlayObject(PoseBaseObject).m_nGameGold := High(Integer);
      end;
      if g_boGameLogGameGold then
        AddGameDataLogAPI(Format(g_sGameLogMsg1, [LOG_GAMEGOLD, TPlayObject(PoseBaseObject).m_sMapName, TPlayObject(PoseBaseObject).m_nCurrX, TPlayObject(PoseBaseObject).m_nCurrY, TPlayObject(PoseBaseObject).m_sCharName, g_Config.sGameGoldName, nDealGold, '-', m_sCharName]));

      PlayObject.GameGoldChanged;
      PoseBaseObject.GameGoldChanged;

      PlayObject.SysMsg(Format('转出元宝到[%s]成功，转出元宝数量:%d 剩余元宝数量:%d', [PoseBaseObject.m_sCharName, nDealGold, PlayObject.m_nGameGold]), c_Purple, t_Hint);
      PoseBaseObject.SysMsg(Format('收到[%s]元宝成功，入账元宝数量:%d 当前元宝数量:%d', [PlayObject.m_sCharName, nDealGold, TPlayObject(PoseBaseObject).m_nGameGold]), c_Purple, t_Hint);
      PlayObject.m_DealGoldCreat := nil;
      TPlayObject(PoseBaseObject).m_DealGoldCreat := nil;
      GotoLable(PlayObject, '@main', False);
    end
    else
      GotoLable(PlayObject, '@dealgoldFail', False);
  end
  else
    GotoLable(PlayObject, '@dealgoldInputFail', False);
end;

procedure TMerchant.ChangeUseItemName(PlayObject: TPlayObject; sLabel, sItemName: string);
var
  sWhere: string;
  btWhere: byte;
  UserItem: pTUserItem;
  sMsg: string;
begin
  if not PlayObject.m_boChangeItemNameFlag then
    Exit;
  PlayObject.m_boChangeItemNameFlag := False;
  sWhere := Copy(sLabel, Length(sUSEITEMNAME) + 1, Length(sLabel) - Length(sUSEITEMNAME));
  btWhere := Str_ToInt(sWhere, -1);
  if btWhere in [Low(THumanUseItems)..High(THumanUseItems)] then
  begin
    UserItem := @PlayObject.m_UseItems[btWhere];
    if UserItem.wIndex = 0 then
    begin
      sMsg := Format(g_sYourUseItemIsNul, [GetUseItemName(btWhere)]);
      PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, sMsg);
      Exit;
    end;
    if InLimitItemList('', UserItem.wIndex, t_dCustomName) then
    begin
      PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '对不起，此物品禁止自定义名称');
      Exit;
    end;
    if UserItem.btValue[13] = 1 then
      ItemUnit.DelCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
    if sItemName <> '' then
    begin
      ItemUnit.AddCustomItemName(UserItem.MakeIndex, UserItem.wIndex, sItemName);
      UserItem.btValue[13] := 1;
    end
    else
    begin
      ItemUnit.DelCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      UserItem.btValue[13] := 0;
    end;
    ItemUnit.SaveCustomItemName();
    PlayObject.SendMsg(PlayObject, RM_SENDUSEITEMS, 0, 0, 0, 0, '');
    PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '');
  end;
end;

procedure TMerchant.SetOffLineMsg(PlayObject: TPlayObject; sMsg: string);
begin
  PlayObject.m_sOffLineLeaveword := sMsg;
end;

function TMerchant.GetGoodString: string;
begin
//
end;

procedure TMerchant.SendMerchandise(PlayObject: TPlayObject; sMsg: string);
begin
 //
end;

{ TTrainer }

constructor TTrainer.Create;
begin
  inherited;
  m_dw568 := GetTickCount();
  n56C := 0;
  n570 := 0;
end;

destructor TTrainer.Destroy;
begin
  inherited;
end;

function TTrainer.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := False;
  if (ProcessMsg.wIdent = RM_STRUCK) or (ProcessMsg.wIdent = RM_MAGSTRUCK) then
  begin
    if (ProcessMsg.BaseObject = Self) then
    begin
      Inc(n56C, ProcessMsg.wParam);
      m_dw568 := GetTickCount();
      Inc(n570);
      ProcessSayMsg('破坏力为 ' + IntToStr(ProcessMsg.wParam) + ',平均值为 ' + IntToStr(n56C div n570));
    end;
  end;
  if ProcessMsg.wIdent = RM_MAGSTRUCK then
    Result := inherited Operate(ProcessMsg);
end;

procedure TTrainer.Run;
begin
  if n570 > 0 then
  begin
    if (GetTickCount - m_dw568) > 3 * 1000 then
    begin
      ProcessSayMsg('总破坏力为  ' + IntToStr(n56C) + ',平均值为 ' + IntToStr(n56C div n570));
      n570 := 0;
      n56C := 0;
    end;
  end;
  inherited;
end;

{ TNormNpc }

procedure TNormNpc.ActionOfAddNameDateList(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  LoadList: TStringList;
  boFound: Boolean;
  sListFileName, sLineText, sHumName, sDate: string;
begin
  LoadList := TStringList.Create;
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;

  if FileExists(sListFileName) then
  begin
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessageAPI('loading fail.... => ' + sListFileName);
    end;
  end;
  boFound := False;
  for i := 0 to LoadList.Count - 1 do
  begin
    sLineText := Trim(LoadList.Strings[i]);
    sLineText := GetValidStr3(sLineText, sHumName, [' ', #9]);
    sLineText := GetValidStr3(sLineText, sDate, [' ', #9]);
    if CompareText(sHumName, PlayObject.m_sCharName) = 0 then
    begin
      LoadList.Strings[i] := PlayObject.m_sCharName + #9 + DateToStr(Date);
      boFound := True;
      Break;
    end;
  end;
  if not boFound then
    LoadList.Add(PlayObject.m_sCharName + #9 + DateToStr(Date));

  try
    LoadList.SaveToFile(sListFileName);
  except
    MainOutMessageAPI('saving fail.... => ' + sListFileName);
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfDelNameDateList(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  LoadList: TStringList;
  sLineText, sListFileName, sHumName, sDate: string;
  boFound: Boolean;
begin
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  LoadList := TStringList.Create;
  if FileExists(sListFileName) then
  begin
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessageAPI('loading fail.... => ' + sListFileName);
    end;
  end;
  boFound := False;
  for i := 0 to LoadList.Count - 1 do
  begin
    sLineText := Trim(LoadList.Strings[i]);
    sLineText := GetValidStr3(sLineText, sHumName, [' ', #9]);
    sLineText := GetValidStr3(sLineText, sDate, [' ', #9]);
    if CompareText(sHumName, PlayObject.m_sCharName) = 0 then
    begin
      LoadList.Delete(i);
      boFound := True;
      Break;
    end;
  end;
  if boFound then
  begin
    try
      LoadList.SaveToFile(sListFileName);
    except
      MainOutMessageAPI('saving fail.... => ' + sListFileName);
    end;
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfAddSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  nLevel: Integer;
begin
  Magic := UserEngine.FindMagic(QuestActionInfo.sParam1);
  if Magic <> nil then
  begin
    //if Magic.wMagicId in [100..111] then exit;
    if not PlayObject.IsTrainingSkill(Magic.wMagicId, Magic.btClass) then
    begin
      nLevel := _MIN(Magic.btTrainLv, Str_ToInt(QuestActionInfo.sParam2, 0));
      New(UserMagic);
      UserMagic.MagicInfo := Magic;
      UserMagic.wMagIdx := Magic.wMagicId;
      UserMagic.btKey := 0;
      UserMagic.btLevel := nLevel;
      UserMagic.nTranPoint := 0;
      PlayObject.m_MagicList.Add(UserMagic);
      PlayObject.SendAddMagic(UserMagic);
      PlayObject.RecalcAbilitys();
      if g_Config.boShowScriptActionMsg then
        PlayObject.SysMsg(Magic.sMagicName + '练习成功', c_Green, t_Hint);
      if (PlayObject.m_MagicArr[0][SKILL_ERGUM] <> nil) and not PlayObject.m_boUseThrusting then
      begin
        PlayObject.m_boUseThrusting := True;
        PlayObject.SendSocket(nil, '+LNG');
      end;
    end;
  end
  else
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_ADDSKILL);
end;

procedure TNormNpc.ActionOfAutoAddGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
begin
  if CompareText(QuestActionInfo.sParam1, 'START') = 0 then
  begin
    if (nPoint > 0) and (nTime > 0) then
    begin
      PlayObject.m_nIncGameGold := nPoint;
      PlayObject.m_dwIncGameGoldTime := LongWord(nTime * 1000);
      PlayObject.m_dwIncGameGoldTick := GetTickCount();
      PlayObject.m_boIncGameGold := True;
      Exit;
    end;
  end;
  if CompareText(QuestActionInfo.sParam1, 'STOP') = 0 then
  begin
    PlayObject.m_boIncGameGold := False;
    Exit;
  end;
  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AUTOADDGAMEGOLD);
end;

procedure TNormNpc.ActionOfAutoGetExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nTime, nPoint: Integer;
  boIsSafeZone: Boolean;
  sMAP: string;
  Envir: TEnvirnoment;
begin
  Envir := nil;
  nTime := Str_ToInt(QuestActionInfo.sParam1, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  boIsSafeZone := QuestActionInfo.sParam3[1] = '1';
  sMAP := QuestActionInfo.sParam4;
  if sMAP <> '' then
    Envir := g_MapManager.FindMap(sMAP);
  if (nTime <= 0) or (nPoint <= 0) or ((sMAP <> '') and (Envir = nil)) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETAUTOGETEXP);
    Exit;
  end;
  PlayObject.m_boAutoGetExpInSafeZone := boIsSafeZone;
  PlayObject.m_AutoGetExpEnvir := Envir;
  PlayObject.m_nAutoGetExpTime := nTime * 1000;
  PlayObject.m_nAutoGetExpPoint := nPoint;
end;

procedure TNormNpc.ActionOfAutoSubGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
begin
  if CompareText(QuestActionInfo.sParam1, 'START') = 0 then
  begin
    if (nPoint > 0) and (nTime > 0) then
    begin
      PlayObject.m_nDecGameGold := nPoint;
      PlayObject.m_dwDecGameGoldTime := LongWord(nTime * 1000);
      PlayObject.m_dwDecGameGoldTick := 0;
      PlayObject.m_boDecGameGold := True;
      Exit;
    end;
  end;
  if CompareText(QuestActionInfo.sParam1, 'STOP') = 0 then
  begin
    PlayObject.m_boDecGameGold := False;
    Exit;
  end;
  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AUTOSUBGAMEGOLD);

end;

procedure TNormNpc.ActionOfChangeHeroCreditPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nCreditPoint: Integer;
  cMethod: Char;
  Hero: TBaseObject;
begin
  Hero := PlayObject.GetHeroObjectA;
  if Hero = nil then  Exit;

  nCreditPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nCreditPoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CREDITPOINT);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if nCreditPoint >= 0 then
        begin
          if nCreditPoint > High(byte) then
          begin
            Hero.m_btCreditPoint := High(byte);
          end
          else
            Hero.m_btCreditPoint := nCreditPoint;
        end;
      end;
    '-':
      begin
        if Hero.m_btCreditPoint > byte(nCreditPoint) then
        begin
          Dec(Hero.m_btCreditPoint, byte(nCreditPoint));
        end
        else
          Hero.m_btCreditPoint := 0;
      end;
    '+':
      begin
        if Hero.m_btCreditPoint + byte(nCreditPoint) > High(byte) then
        begin
          Hero.m_btCreditPoint := High(byte);
        end
        else
          Inc(Hero.m_btCreditPoint, byte(nCreditPoint));
      end;
  else
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HEROCREDITPOINT);
  end;
end;

procedure TNormNpc.ActionOfChangeCreditPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nCreditPoint: Integer;
  cMethod: Char;
begin
  nCreditPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nCreditPoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CREDITPOINT);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if nCreditPoint >= 0 then
        begin
          if nCreditPoint > High(byte) then
          begin
            PlayObject.m_btCreditPoint := High(byte);
          end
          else
          begin
            PlayObject.m_btCreditPoint := nCreditPoint;
          end;
        end;
      end;
    '-':
      begin
        if PlayObject.m_btCreditPoint > byte(nCreditPoint) then
        begin
          Dec(PlayObject.m_btCreditPoint, byte(nCreditPoint));
        end
        else
        begin
          PlayObject.m_btCreditPoint := 0;
        end;
      end;
    '+':
      begin
        if PlayObject.m_btCreditPoint + byte(nCreditPoint) > High(byte) then
        begin
          PlayObject.m_btCreditPoint := High(byte);
        end
        else
        begin
          Inc(PlayObject.m_btCreditPoint, byte(nCreditPoint));
        end;
      end;
  else
    begin
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CREDITPOINT);
      Exit;
    end;
  end;
end;

procedure TNormNpc.ActionOfChangeIPExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nExp: LongWord;
  cMethod: Char;
  dwInt: LongWord;
begin
  nExp := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nExp < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEIPEXP);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': if nExp >= 0 then
      begin
        PlayObject.m_dwInPowerExp := LongWord(nExp);
        //dwInt := LongWord(nExp);
        if PlayObject.IsHero then
        begin
          PlayObject.m_Master.SendMsg(PlayObject.m_Master, RM_HEROWINIPEXP, 0, 0, 0, 0, '');
        end
        else if not PlayObject.m_boOffLineFlag then
          PlayObject.SendMsg(PlayObject, RM_WINIPEXP, 0, 0, 0, 0, '');
      end;
    '-':
      begin
        if PlayObject.m_dwInPowerExp > LongWord(nExp) then
          Dec(PlayObject.m_dwInPowerExp, LongWord(nExp))
        else
          PlayObject.m_dwInPowerExp := 0;
        if PlayObject.IsHero then
        begin
          PlayObject.m_Master.SendMsg(PlayObject.m_Master, RM_HEROWINIPEXP, 0, 0, 0, 0, '');
        end
        else if not PlayObject.m_boOffLineFlag then
          PlayObject.SendMsg(PlayObject, RM_WINIPEXP, 0, 0, 0, 0, '');
      end;
    '+':
      begin
        if PlayObject.m_dwInPowerExp + LongWord(nExp) > High(LongWord) then
          dwInt := High(LongWord) - PlayObject.m_dwInPowerExp
        else
          dwInt := LongWord(nExp);
        if PlayObject.IsHero then
        begin
          PlayObject.HeroGetIPExp(dwInt);
        end
        else
          PlayObject.GetExp(dwInt, True, True);
      end;
  end;
end;

procedure TNormNpc.ActionOfChangeExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nExp: LongWord;
  cMethod: Char;
  dwInt: LongWord;
begin
  nExp := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nExp < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEEXP);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if nExp >= 0 then
        begin
          PlayObject.m_Abil.Exp := LongWord(nExp);
        end;
      end;
    '-':
      begin
        if PlayObject.m_Abil.Exp > LongWord(nExp) then
          Dec(PlayObject.m_Abil.Exp, LongWord(nExp))
        else
          PlayObject.m_Abil.Exp := 0;
      end;
    '+':
      begin
        if PlayObject.m_Abil.Exp + LongWord(nExp) > High(LongWord) then
          dwInt := High(LongWord) - PlayObject.m_Abil.Exp
        else
          dwInt := LongWord(nExp);

        if PlayObject.IsHero then
        begin
          PlayObject.HeroGetExp(dwInt);
        end
        else
          PlayObject.GetExp(dwInt, True, False);
      end;
  end;
end;

procedure TNormNpc.ActionOfChangeHeroExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nExp: LongWord;
  cMethod: Char;
  dwInt: LongWord;
  Hero: TBaseObject;
begin
  //Hero := PlayObject.GetHeroObject;
  Hero := nil;
  if (PlayObject.m_HeroObject <> nil) and not PlayObject.m_HeroObject.m_boGhost then
    Hero := PlayObject.m_HeroObject;
  if Hero = nil then
    Exit;
  nExp := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nExp < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEHEROEXP);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if nExp >= 0 then
        begin
          Hero.m_Abil.Exp := LongWord(nExp);
        end;
      end;
    '-':
      begin
        if Hero.m_Abil.Exp > LongWord(nExp) then
            Dec(Hero.m_Abil.Exp, LongWord(nExp))
        else
            Hero.m_Abil.Exp := 0;
      end;
    '+':
      begin
        if Hero.m_Abil.Exp + LongWord(nExp) > High(LongWord) then
          dwInt := High(LongWord) - Hero.m_Abil.Exp
        else
          dwInt := LongWord(nExp);
        (Hero as TPlayObject).HeroGetExp(dwInt);
      end;
  end;
end;

procedure TNormNpc.ActionOfOpenGameGoldDeal(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nCode: Integer;
begin
  if PlayObject.m_btPostSell = 0 then
  begin
    if PlayObject.m_nGameGold > 0 then
    begin
      if (QuestActionInfo.nParam1 > 0) and (PlayObject.m_nGameGold >= QuestActionInfo.nParam1) then
      begin
        Dec(PlayObject.m_nGameGold, QuestActionInfo.nParam1);
        PlayObject.GameGoldChanged();
        PlayObject.m_btPostSell := 1;
        if g_boGameLogGameGold then
          AddGameDataLogAPI(Format(g_sGameLogMsg1, [LOG_GAMEGOLD, PlayObject.m_sMapName, PlayObject.m_nCurrX, PlayObject.m_nCurrY, PlayObject.m_sCharName, g_Config.sGameGoldName, QuestActionInfo.nParam1, '-', m_sCharName]));
        nCode := 0;
      end
      else
        nCode := -4;
    end
    else
      nCode := -2;
  end
  else
    nCode := -3;
  PlayObject.SendDefMessage(SM_OPENDEAL_FAIL, nCode, 0, 0, 0, '');
end;

procedure TNormNpc.ActionOfQueryGameGoldSell(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, nCode, nCount: Integer;
  PostSell: pTPostSell;
  pStdItem: pTStdItem;
  StdItem: TStdItem;
  UserItem: TUserItem;
  ClientItem: TClientItem;
  DateTime: TDateTime;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  sItemName, sSENDMSG: string;
  boFound: Boolean;
  pdc: PTDelayCallNPC;
begin
  sSENDMSG := '';
  nCount := 0;
  boFound := False;
  if (TMerchant(Self).m_PostSellList <> nil) and (TMerchant(Self).m_PostSellList.Count > 0) then
  begin
    for i := 0 to TMerchant(Self).m_PostSellList.Count - 1 do
    begin
      PostSell := pTPostSell(TMerchant(Self).m_PostSellList[i]);
      if PostSell.sCharName = PlayObject.m_sCharName then
      begin
        DateTime := PostSell.dPostTime;
        boFound := True;
        Break;
      end;
    end;
  end;
  if boFound then
  begin
    DecodeDate(PostSell.dPostTime, Year, Month, Day);
    DecodeTime(PostSell.dPostTime, Hour, Min, Sec, MSec);
    sSENDMSG := EncodeString(PostSell.sCharName + '/' + PostSell.sTargName + '/' + IntToStr(Month) + '-' + IntToStr(Day) + ' ' + IntToStr(Hour) + ':' + IntToStr(Min)) + '/';
    for i := Low(PostSell.aPostItems) to High(PostSell.aPostItems) do
    begin
      UserItem := PostSell.aPostItems[i];
      if UserItem.wIndex > 0 then
      begin
        pStdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if pStdItem <> nil then
        begin
          StdItem := pStdItem^;
          ItemUnit.GetItemAddValue(@UserItem, StdItem);
          ////////////
{$IF VER_ClientType_45}
          if PlayObject.m_wClientType = 46 then
          begin
{$IFEND VER_ClientType_45}
            Move(StdItem, ClientItem.s, SizeOf(TClientStdItem));
            sItemName := '';
            if UserItem.btValue[13] = 1 then
              sItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
            if sItemName <> '' then
              ClientItem.s.Name := sItemName;
            ClientItem.Dura := UserItem.Dura;
            ClientItem.DuraMax := UserItem.DuraMax;
            ClientItem.MakeIndex := UserItem.MakeIndex;
            ClientItem.s.ItemType := UserItem.btValue[14];
            GetSendClientItem(@UserItem, PlayObject, ClientItem);
            sSENDMSG := sSENDMSG + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
{$IF VER_ClientType_45}
          end
          else
          begin
            CopyStdItemToOStdItem(@StdItem, @OClientItem.s);
            sItemName := '';
            if UserItem.btValue[13] = 1 then
              sItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
            if sItemName <> '' then
              OClientItem.s.Name := sItemName;
            OClientItem.Dura := UserItem.Dura;
            OClientItem.DuraMax := UserItem.DuraMax;
            OClientItem.MakeIndex := UserItem.MakeIndex;
            sSENDMSG := sSENDMSG + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
          end;
{$IFEND VER_ClientType_45}
          ///////////////////////////
          Inc(nCount);
        end;
      end;
    end;
    if PostSell.nPostStone > 0 then
    begin
      FillChar(StdItem, SizeOf(TStdItem), 0);
      StdItem.Name := '金刚石';
      StdItem.StdMode := 48;
      StdItem.Weight := 1;
      StdItem.NeedLevel := 1;
      /////////////
{$IF VER_ClientType_45}
      if PlayObject.m_wClientType = 46 then
      begin
{$IFEND VER_ClientType_45}
        Move(StdItem, ClientItem.s, SizeOf(TClientStdItem));
        ClientItem.Dura := PostSell.nPostStone;
        ClientItem.DuraMax := PostSell.nPostStone;
        ClientItem.MakeIndex := 1;
        sSENDMSG := sSENDMSG + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
{$IF VER_ClientType_45}
      end
      else
      begin
        CopyStdItemToOStdItem(@StdItem, @OClientItem.s);
        OClientItem.Dura := PostSell.nPostStone;
        OClientItem.DuraMax := PostSell.nPostStone;
        OClientItem.MakeIndex := 1;
        sSENDMSG := sSENDMSG + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
      end;
{$IFEND VER_ClientType_45}
      /////////////////////////
      Inc(nCount);
    end;
    if nCount > 0 then
    begin
      if GetDayCount(Now, DateTime) > 3 then
        nCode := 9999 + 2
      else
        nCode := PostSell.nPostPrice;
      PlayObject.m_DefMsg := MakeDefaultMsg(SM_QUERYYBSELL_SELL, nCode, 0, 0, nCount);
      PlayObject.SendSocket(@PlayObject.m_DefMsg, sSENDMSG);
    end;
  end
  else
  begin
    //PlayObject.m_DefMsg := MakeDefaultMsg(SM_QUERYYBSELL_SELL, -1, 0, 0, nCount);
    //PlayObject.SendSocket(@PlayObject.m_DefMsg, sSENDMSG);
    New(pdc);
    pdc.nDelayCall := 500;
    pdc.sDelayCallLabel := '@AskYBSellFail';
    pdc.dwDelayCallTick := GetTickCount();
    pdc.bProcessed := False;
    pdc.DelayCallNPC := Integer(Self);
    PlayObject.m_DelayCallList.Add(pdc);
  end;
end;

procedure TNormNpc.ActionOfQueryGameGoldDeal(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, nCode, nCount: Integer;
  PostSell: pTPostSell;
  pStdItem: pTStdItem;
  StdItem: TStdItem;
  UserItem: TUserItem;
  ClientItem: TClientItem;
  DateTime: TDateTime;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  sItemName, sSENDMSG: string;
  boFound: Boolean;
  pdc: PTDelayCallNPC;
begin
  sSENDMSG := '';
  nCount := 0;
  boFound := False;
  if (TMerchant(Self).m_PostSellList <> nil) and (TMerchant(Self).m_PostSellList.Count > 0) then
  begin
    for i := 0 to TMerchant(Self).m_PostSellList.Count - 1 do
    begin
      PostSell := pTPostSell(TMerchant(Self).m_PostSellList[i]);
      if PostSell.sTargName = PlayObject.m_sCharName then
      begin
        DateTime := PostSell.dPostTime;
        boFound := True;
        Break;
      end;
    end;
  end;
  if boFound then
  begin
    DecodeDate(PostSell.dPostTime, Year, Month, Day);
    DecodeTime(PostSell.dPostTime, Hour, Min, Sec, MSec);
    sSENDMSG := EncodeString(PostSell.sCharName + '/' + PostSell.sTargName + '/' + IntToStr(Month) + '-' + IntToStr(Day) + ' ' + IntToStr(Hour) + ':' + IntToStr(Min)) + '/';
    for i := Low(PostSell.aPostItems) to High(PostSell.aPostItems) do
    begin
      UserItem := PostSell.aPostItems[i];
      if UserItem.wIndex > 0 then
      begin
        pStdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if pStdItem <> nil then
        begin
          StdItem := pStdItem^;
          ItemUnit.GetItemAddValue(@UserItem, StdItem);
{$IF VER_ClientType_45}
          if PlayObject.m_wClientType = 46 then
          begin
{$IFEND VER_ClientType_45}
            Move(StdItem, ClientItem.s, SizeOf(TClientStdItem));
            sItemName := '';
            if UserItem.btValue[13] = 1 then
              sItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
            if sItemName <> '' then
              ClientItem.s.Name := sItemName;
            ClientItem.Dura := UserItem.Dura;
            ClientItem.DuraMax := UserItem.DuraMax;
            ClientItem.MakeIndex := UserItem.MakeIndex;
            ClientItem.s.ItemType := UserItem.btValue[14];
            GetSendClientItem(@UserItem, PlayObject, ClientItem);
            sSENDMSG := sSENDMSG + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
            Inc(nCount);
{$IF VER_ClientType_45}
          end
          else
          begin
            CopyStdItemToOStdItem(@StdItem, @OClientItem.s);
            sItemName := '';
            if UserItem.btValue[13] = 1 then
              sItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
            if sItemName <> '' then
              OClientItem.s.Name := sItemName;
            OClientItem.Dura := UserItem.Dura;
            OClientItem.DuraMax := UserItem.DuraMax;
            OClientItem.MakeIndex := UserItem.MakeIndex;
            sSENDMSG := sSENDMSG + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
            Inc(nCount);
          end;
{$IFEND VER_ClientType_45}
        end;
      end;
    end;
    if PostSell.nPostStone > 0 then
    begin
      FillChar(StdItem, SizeOf(TStdItem), #0);
      StdItem.Name := '金刚石';
      StdItem.StdMode := 48;
{$IF VER_ClientType_45}
      if PlayObject.m_wClientType = 46 then
      begin
{$IFEND VER_ClientType_45}
        Move(StdItem, ClientItem.s, SizeOf(TClientStdItem));
        ClientItem.MakeIndex := 1;
        ClientItem.Dura := PostSell.nPostStone;
        sSENDMSG := sSENDMSG + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
{$IF VER_ClientType_45}
      end
      else
      begin
        CopyStdItemToOStdItem(@StdItem, @OClientItem.s);
        OClientItem.MakeIndex := 1;
        OClientItem.Dura := PostSell.nPostStone;
        sSENDMSG := sSENDMSG + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
      end;
{$IFEND VER_ClientType_45}
      Inc(nCount);
    end;
    if nCount > 0 then
    begin
      if GetDayCount(Now, DateTime) > 3 then
        nCode := 9999 + 2
      else
        nCode := PostSell.nPostPrice;
      PlayObject.m_DefMsg := MakeDefaultMsg(SM_QUERYYBSELL_DEAL, nCode, 0, 0, nCount);
      PlayObject.SendSocket(@PlayObject.m_DefMsg, sSENDMSG);
    end;
  end
  else
  begin
    New(pdc);
    pdc.nDelayCall := 500;
    pdc.sDelayCallLabel := '@AskYBDealFail';
    pdc.dwDelayCallTick := GetTickCount();
    pdc.bProcessed := False;
    pdc.DelayCallNPC := Integer(Self);
    PlayObject.m_DelayCallList.Add(pdc);
  end;
end;

procedure TNormNpc.ActionOfChangeHairStyle(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nHair: Integer;
begin
  nHair := Str_ToInt(QuestActionInfo.sParam1, -1);
  if (QuestActionInfo.sParam1 <> '') and (nHair >= 0) then
  begin
    PlayObject.m_btHair := nHair;
    PlayObject.FeatureChanged;
  end
  else
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HAIRSTYLE);
  end;
end;

procedure TNormNpc.ActionOfChangeJob(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nJob: Integer;
begin
  nJob := -1;
  if CompareLStr(QuestActionInfo.sParam1, sWARRIOR, 3) then
    nJob := 0;
  if CompareLStr(QuestActionInfo.sParam1, sWIZARD, 3) then
    nJob := 1;
  if CompareLStr(QuestActionInfo.sParam1, sTAOS, 3) then
    nJob := 2;
  if nJob < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEJOB);
    Exit;
  end;
  if PlayObject.m_btJob <> nJob then
  begin
    PlayObject.m_btJob := nJob;

    case PlayObject.m_btJob of
      0:
        begin
          PlayObject.m_nNextHitTime := _MAX(200, g_Config.nHeroNextHitTime_Warr);
          PlayObject.m_nWalkSpeed := _MAX(200, g_Config.nHeroWalkSpeed_Warr);
        end;
      1:
        begin
          PlayObject.m_nNextHitTime := _MAX(200, g_Config.nHeroNextHitTime_Wizard);
          PlayObject.m_nWalkSpeed := _MAX(200, g_Config.nHeroWalkSpeed_Wizard);
        end;
      2:
        begin
          PlayObject.m_nNextHitTime := _MAX(200, g_Config.nHeroNextHitTime_Taos);
          PlayObject.m_nWalkSpeed := _MAX(200, g_Config.nHeroWalkSpeed_Taos);
        end;
    end;
    PlayObject.m_nNonFrzWalkSpeed := PlayObject.m_nWalkSpeed;
    PlayObject.m_nNonFrzNextHitTime := PlayObject.m_nNextHitTime;

    PlayObject.HasLevelUp();
  end;
end;

procedure TNormNpc.ActionOfChangeHeroJob(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nJob: Integer;
  HeroObject: TBaseObject;
begin
  nJob := -1;
  if CompareLStr(QuestActionInfo.sParam1, sWARRIOR, 3) then
    nJob := 0;
  if CompareLStr(QuestActionInfo.sParam1, sWIZARD, 3) then
    nJob := 1;
  if CompareLStr(QuestActionInfo.sParam1, sTAOS, 3) then
    nJob := 2;
  if nJob < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEHEROJOB);
    Exit;
  end;
  HeroObject := PlayObject.GetHeroObjectA;
  if HeroObject <> nil then
  begin
    if HeroObject.m_btJob <> nJob then
    begin
      HeroObject.m_btJob := nJob;
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
      HeroObject.HasLevelUp();
    end;
  end;
end;

procedure TNormNpc.ActionOfChangeAttackMode(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  mode: Integer;
begin
  {if (PlayObject.m_PEnvir <> nil) and PlayObject.m_PEnvir.m_MapFlag.boNoSwitchAttackMode then begin
    PlayObject.SysMsg('当前地图不能更改攻击模式！', c_Red, t_Hint);
    Exit;
  end;}
  mode := Str_ToInt(QuestActionInfo.sParam1, -1);
  if not (mode in [0..6]) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEATTACKMODE);
    Exit;
  end;
  if (mode <> PlayObject.m_btAttatckMode) then
  begin
    PlayObject.m_btAttatckMode := mode;
    case PlayObject.m_btAttatckMode of
      HAM_ALL: PlayObject.SysMsg(sAttackModeOfAll, c_Green, t_Hint); //[攻击模式: 全体攻击]
      HAM_PEACE: PlayObject.SysMsg(sAttackModeOfPeaceful, c_Green, t_Hint); //[攻击模式: 和平攻击]
      HAM_DEAR: PlayObject.SysMsg(sAttackModeOfDear, c_Green, t_Hint); //[攻击模式: 和平攻击]
      HAM_MASTER: PlayObject.SysMsg(sAttackModeOfMaster, c_Green, t_Hint); //
      HAM_GROUP: PlayObject.SysMsg(sAttackModeOfGroup, c_Green, t_Hint); //[攻击模式: 编组攻击]
      HAM_GUILD: PlayObject.SysMsg(sAttackModeOfGuild, c_Green, t_Hint); //[攻击模式: 行会攻击]
      HAM_PKATTACK: PlayObject.SysMsg(sAttackModeOfRedWhite, c_Green, t_Hint); //[攻击模式: 红名攻击]
    end;
    PlayObject.SendMsg(PlayObject, RM_ATTACKMODE, 0, 0, 0, 0, '');
  end;
end;

procedure TNormNpc.ActionOfChangeLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  boChgOK: Boolean;
  nLevel: Integer;
  nLv: Integer;
  nOldLevel: Integer;
  cMethod: Char;
begin
  boChgOK := False;
  nOldLevel := PlayObject.m_Abil.Level;
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGELEVEL);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nLevel > 0) and (nLevel <= High(Word)) then
        begin
          PlayObject.m_Abil.Level := nLevel;
          if nOldLevel <> PlayObject.m_Abil.Level then
            PlayObject.LevelUPFunc();
          boChgOK := True;
        end;
      end;
    '-':
      begin
        nLv := _MAX(0, PlayObject.m_Abil.Level - nLevel);
        nLv := _MIN(High(Word), nLv);
        PlayObject.m_Abil.Level := nLv;
        if nOldLevel <> PlayObject.m_Abil.Level then
          PlayObject.LevelUPFunc();
        boChgOK := True;
      end;
    '+':
      begin
        nLv := _MAX(0, PlayObject.m_Abil.Level + nLevel);
        nLv := _MIN(High(Word), nLv);
        PlayObject.m_Abil.Level := nLv;
        if nOldLevel <> PlayObject.m_Abil.Level then
          PlayObject.LevelUPFunc();
        boChgOK := True;
      end;
  end;
  if boChgOK then
  begin
    PlayObject.HasLevelUp();
  end;
end;

procedure TNormNpc.ActionOfChangeTranPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, np, lv: Integer;
  sn: string;
  cMethod: Char;
  UserMagic: pTUserMagic;
begin
  sn := QuestActionInfo.sParam1;
  np := Str_ToInt(QuestActionInfo.sParam3, -1);
  if (sn = '') or (np < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGETRANPOINT);
    Exit;
  end;
  for i := 0 to PlayObject.m_MagicList.Count - 1 do
  begin
    UserMagic := PlayObject.m_MagicList.Items[i];
    if CompareText(UserMagic.MagicInfo.sMagicName, sn) = 0 then
    begin
      if UserMagic.btLevel < 15 then
      begin
        if UserMagic.MagicInfo.btClass = 0 then
          lv := PlayObject.m_Abil.Level
        else
          lv := PlayObject.m_nInPowerLevel;
        if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] <= lv then
        begin
          cMethod := QuestActionInfo.sParam2[1];
          case cMethod of
            '=': UserMagic.nTranPoint := np;
            '-':
              begin
                Dec(UserMagic.nTranPoint, np);
                if UserMagic.nTranPoint < 0 then
                  UserMagic.nTranPoint := 0;
              end;
            '+': Inc(UserMagic.nTranPoint, np);
          end;
          if not PlayObject.CheckMagicLevelup(UserMagic) then
          begin
            PlayObject.SendDelayMsg(PlayObject,
              RM_MAGIC_LVEXP,
              UserMagic.MagicInfo.btClass,
              UserMagic.MagicInfo.wMagicId,
              UserMagic.btLevel,
              UserMagic.nTranPoint,
              '', 1000);
          end;
        end;
      end;
      Break;
    end;
  end;
end;

procedure TNormNpc.ActionOfChangeIPLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nLevel: Integer;
  nLv: Integer;
  nOldLevel: Integer;
  cMethod: Char;
begin
  nOldLevel := PlayObject.m_nInPowerLevel;
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEIPLEVEL);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nLevel >= 0) and (nLevel <= MAX_IPLEVEL) then
        begin
          PlayObject.m_nInPowerLevel := nLevel;
        end;
      end;
    '-':
      begin
        nLv := _MAX(0, PlayObject.m_nInPowerLevel - nLevel);
        nLv := _MIN(MAX_IPLEVEL, nLv);
        PlayObject.m_nInPowerLevel := nLv;
      end;
    '+':
      begin
        nLv := _MAX(0, PlayObject.m_nInPowerLevel + nLevel);
        nLv := _MIN(MAX_IPLEVEL, nLv);
        PlayObject.m_nInPowerLevel := nLv;
      end;
  end;
  if nOldLevel <> PlayObject.m_nInPowerLevel then
    PlayObject.HasLevelUp(True);
end;

procedure TNormNpc.ActionOfChangeHeroLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  boChgOK: Boolean;
  nLevel: Integer;
  nLv: Integer;
  // nOldLevel: Integer;
  cMethod: Char;
  HeroObject: TBaseObject;
begin
  HeroObject := PlayObject.GetHeroObjectA;
  if HeroObject = nil then Exit;

  boChgOK := False;
  // nOldLevel := HeroObject.m_Abil.Level;
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEHEROLEVEL);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nLevel > 0) and (nLevel <= High(Word)) then
        begin
          HeroObject.m_Abil.Level := nLevel;
          boChgOK := True;
        end;
      end;
    '-':
      begin
        nLv := _MAX(0, HeroObject.m_Abil.Level - nLevel);
        nLv := _MIN(High(Word), nLv);
        HeroObject.m_Abil.Level := nLv;
        boChgOK := True;
      end;
    '+':
      begin
        nLv := _MAX(0, HeroObject.m_Abil.Level + nLevel);
        nLv := _MIN(High(Word), nLv);
        HeroObject.m_Abil.Level := nLv;
        boChgOK := True;
      end;
  end;
  if boChgOK then
    HeroObject.HasLevelUp();
end;

procedure TNormNpc.ActionOfChangePkPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nPKPOINT: Integer;
  nPoint: Integer;
  nOldPKLevel: Integer;
  cMethod: Char;
begin
  nOldPKLevel := PlayObject.PKLevel;
  nPKPOINT := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nPKPOINT < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEPKPOINT);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nPKPOINT >= 0) then
          PlayObject.m_nPkPoint := nPKPOINT;
      end;
    '-':
      begin
        nPoint := _MAX(0, PlayObject.m_nPkPoint - nPKPOINT);
        PlayObject.m_nPkPoint := nPoint;
      end;
    '+':
      begin
        nPoint := _MAX(0, PlayObject.m_nPkPoint + nPKPOINT);
        PlayObject.m_nPkPoint := nPoint;
      end;
  end;
  if nOldPKLevel <> PlayObject.PKLevel then
    PlayObject.RefNameColor;
end;

procedure TNormNpc.ActionOfChangeHeroPkPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nPKPOINT: Integer;
  nPoint: Integer;
  nOldPKLevel: Integer;
  cMethod: Char;
  HeroObject: TBaseObject;
begin
  HeroObject := PlayObject.GetHeroObjectA;
  if HeroObject = nil then
    Exit;
  nOldPKLevel := HeroObject.PKLevel;
  nPKPOINT := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nPKPOINT < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEHEROPKPOINT);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nPKPOINT >= 0) then
          HeroObject.m_nPkPoint := nPKPOINT;
      end;
    '-':
      begin
        nPoint := _MAX(0, HeroObject.m_nPkPoint - nPKPOINT);
        HeroObject.m_nPkPoint := nPoint;
      end;
    '+':
      begin
        nPoint := _MAX(0, HeroObject.m_nPkPoint + nPKPOINT);
        HeroObject.m_nPkPoint := nPoint;
      end;
  end;
  if nOldPKLevel <> HeroObject.PKLevel then
    HeroObject.RefNameColor;
end;

procedure TNormNpc.ActionOfClearMapMon(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  MonList: TList;
  Mon: TBaseObject;
  ii: Integer;
begin
  MonList := TList.Create;
  UserEngine.GetMapMonster(g_MapManager.FindMap(QuestActionInfo.sParam1), MonList);
  for ii := 0 to MonList.Count - 1 do
  begin
    Mon := TBaseObject(MonList.Items[ii]);
    if Mon.m_Master <> nil then
      Continue;
    if GetNoClearMonList(Mon.m_sCharName) then
      Continue;
    Mon.m_boNoItem := True;
    Mon.m_WAbil.HP := 0;
    Mon.MakeGhost;
  end;
  MonList.Free;
end;

//ClearMapItem map x y range

procedure TNormNpc.ActionOfClearMapItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, nX, nY, nRange: Integer;
  nStartX, nEndX: Integer;
  nStartY, nEndY: Integer;
  Envirnoment: TEnvirnoment;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  nX := Str_ToInt(QuestActionInfo.sParam2, -1);
  nY := Str_ToInt(QuestActionInfo.sParam3, -1);
  nRange := Str_ToInt(QuestActionInfo.sParam4, -1);
  Envirnoment := g_MapManager.FindMap(QuestActionInfo.sParam1);
  if (Envirnoment = nil) or (nX < 0) or (nY < 0) or (nRange <= 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CLEARMAPITEM);
    Exit;
  end;
  nStartX := nX - nRange;
  nEndX := nX + nRange;
  nStartY := nY - nRange;
  nEndY := nY + nRange;

  for nX := nStartX to nEndX do
  begin
    for nY := nStartY to nEndY do
    begin
      if Envirnoment.GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) and (MapCellInfo.ObjList <> nil) then
      begin
        i := 0;
        while (True) do
        begin
          if MapCellInfo.ObjList.Count <= i then
            Break;
          OSObject := MapCellInfo.ObjList.Items[i];
          if OSObject <> nil then
          begin
            if OSObject.btType = OS_ITEMOBJECT then
              OSObject.dwAddTime := 0;
          end;
          Inc(i);
        end;
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfAddMapRoute(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sSMapNO: string;
  nSMapX, nSMapY: Integer;
  sDMapNO: string;
  nDMapX, nDMapY: Integer;
begin
  sSMapNO := QuestActionInfo.sParam1;
  nSMapX := QuestActionInfo.nParam2;
  nSMapY := QuestActionInfo.nParam3;

  sDMapNO := QuestActionInfo.sParam4;
  nDMapX := QuestActionInfo.nParam5;
  nDMapY := QuestActionInfo.nParam6;

  g_MapManager.AddMapRoute(sSMapNO, nSMapX, nSMapY, sDMapNO, nDMapX, nDMapY);

  if QuestActionInfo.nParam7 <> 0 then
    g_MapManager.AddMapRoute(sDMapNO, nDMapX, nDMapY, sSMapNO, nSMapX, nSMapY);
end;

procedure TNormNpc.ActionOfDelMapRoute(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sSMapNO: string;
  nX, nY: Integer;
  Envirnoment: TEnvirnoment;
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  sSMapNO := QuestActionInfo.sParam1;
  nX := QuestActionInfo.nParam2;
  nY := QuestActionInfo.nParam3;
  Envirnoment := g_MapManager.FindMap(sSMapNO);
  if (Envirnoment = nil) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_DelMapRoute);
    Exit;
  end;
  if Envirnoment.GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo <> nil) and (MapCellInfo.chFlag = 0) then
  begin
    if MapCellInfo.ObjList <> nil then
    begin
      i := 0;
      while True do
      begin
        if MapCellInfo.ObjList.Count <= i then
          Break;
        OSObject := MapCellInfo.ObjList[i];
        if (OSObject = nil) or (OSObject.btType <> OS_GATEOBJECT) then
        begin
          inc(i);
          Continue;
        end;
        if OSObject.CellObj <> nil then
        begin
          Dispose(pTGateObj(OSObject.CellObj));
          OSObject.CellObj := nil;
        end;
        Dispose(OSObject);
        OSObject := nil;
        MapCellInfo.ObjList.Delete(i);
        if MapCellInfo.ObjList.Count > 0 then
          Continue;
        MapCellInfo.ObjList.Free;
        MapCellInfo.ObjList := nil;
        Break;
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfClearNameList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  LoadList: TStringList;
  sListFileName: string;
begin
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  LoadList := TStringList.Create;
  LoadList.Clear;
  try
    LoadList.SaveToFile(sListFileName);
  except
    MainOutMessageAPI('saving fail.... => ' + sListFileName);
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfClearSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  for i := PlayObject.m_MagicList.Count - 1 downto 0 do
  begin
    UserMagic := PlayObject.m_MagicList.Items[i];
    PlayObject.SendDelMagic(UserMagic);
    Dispose(UserMagic);
    //PlayObject.m_MagicList.Delete(i);
  end;
  PlayObject.m_MagicList.Clear;
  PlayObject.RecalcAbilitys();
end;

procedure TNormNpc.ActionOfClearHeroSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  UserMagic: pTUserMagic;
  Hero: TBaseObject;
begin
  Hero := PlayObject.GetHeroObjectA;
  if Hero = nil then
    Exit;
  for i := Hero.m_MagicList.Count - 1 downto 0 do
  begin
    UserMagic := Hero.m_MagicList.Items[i];
    TPlayObject(Hero).SendDelMagic(UserMagic);
    Dispose(UserMagic);
  end;
  Hero.m_MagicList.Clear;
  Hero.RecalcAbilitys();
  //PlayObject.SendHeroUseMagic();
end;

procedure TNormNpc.ActionOfDelNoJobSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  b: Boolean;
  UserMagic: pTUserMagic;
begin
  b := False;
  for i := PlayObject.m_MagicList.Count - 1 downto 0 do
  begin
    UserMagic := PlayObject.m_MagicList.Items[i];
    if (UserMagic.MagicInfo.btJob <> PlayObject.m_btJob) and (UserMagic.MagicInfo.btJob <> 99) then
    begin
      PlayObject.SendDelMagic(UserMagic);
      Dispose(UserMagic);
      PlayObject.m_MagicList.Delete(i);
      b := True;
    end;
  end;
  if b then
    PlayObject.RecalcAbilitys();
end;

procedure TNormNpc.ActionOfDelSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sMagicName: string;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
begin
  sMagicName := QuestActionInfo.sParam1;
  Magic := UserEngine.FindMagic(sMagicName);
  if Magic = nil then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_DELSKILL);
    Exit;
  end;
  for i := PlayObject.m_MagicList.Count - 1 downto 0 do
  begin
    UserMagic := PlayObject.m_MagicList.Items[i];
    if UserMagic.MagicInfo = Magic then
    begin
      PlayObject.SendDelMagic(UserMagic);
      Dispose(UserMagic);
      PlayObject.m_MagicList.Delete(i);
      PlayObject.RecalcAbilitys();
      Break;
    end;
  end;
end;

procedure TNormNpc.ActionOfGameStone(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

var
  nGameDiamond, nCount: Integer;
  sGameDiamond, sCount: string;
  nOldGameDiamond: Integer;
  cMethod: Char;
begin
  nOldGameDiamond := PlayObject.m_nGameDiamond;
  sCount := QuestActionInfo.sParam3;
  nCount := Str_ToInt(sCount, 1);
  sGameDiamond := QuestActionInfo.sParam2;
  nGameDiamond := Str_ToInt(sGameDiamond, -1);
  if (nGameDiamond < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GAMEDIAMOND);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nGameDiamond >= 0) then
        begin
          PlayObject.m_nGameDiamond := nGameDiamond;
        end;
      end;
    '-':
      begin
        nGameDiamond := _MAX(0, PlayObject.m_nGameDiamond - (nGameDiamond * nCount));
        PlayObject.m_nGameDiamond := nGameDiamond;
      end;
    '+':
      begin
        nGameDiamond := _MAX(0, PlayObject.m_nGameDiamond + (nGameDiamond * nCount));
        PlayObject.m_nGameDiamond := nGameDiamond;
      end;
  end;
  if nOldGameDiamond <> PlayObject.m_nGameDiamond then
    PlayObject.SendDefMessage(SM_REFDIAMOND, PlayObject.m_nGameDiamond, PlayObject.m_nGameGird, 0, 0, '');
end;

procedure TNormNpc.ActionOfGameGird(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

var
  nBressGird, nCount: Integer;
  sBressGird, sCount: string;
  nOldBressGird: Integer;
  cMethod: Char;
begin
  nOldBressGird := PlayObject.m_nGameGird;
  sCount := QuestActionInfo.sParam3;
  nCount := Str_ToInt(sCount, 1);
  sBressGird := QuestActionInfo.sParam2;
  nBressGird := Str_ToInt(sBressGird, -1);
  if (nBressGird < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GAMEGIRD);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nBressGird >= 0) then
        begin
          PlayObject.m_nGameGird := nBressGird;
        end;
      end;
    '-':
      begin
        nBressGird := _MAX(0, PlayObject.m_nGameGird - (nBressGird * nCount));
        PlayObject.m_nGameGird := nBressGird;
      end;
    '+':
      begin
        nBressGird := _MAX(0, PlayObject.m_nGameGird + (nBressGird * nCount));
        PlayObject.m_nGameGird := nBressGird;
      end;
  end;
  if nOldBressGird <> PlayObject.m_nGameGird then
    PlayObject.SendDefMessage(SM_REFDIAMOND, PlayObject.m_nGameDiamond, PlayObject.m_nGameGird, 0, 0, '');
end;

procedure TNormNpc.ActionOfChangeMonPos(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sMonName, sMAP: string;
  i, nN, nX1, nY1, nX2, nY2: Integer;
  Envir: TEnvirnoment;
  MonList: TList;
  BaseObject: TBaseObject;
begin
  //ChangeMonPos 怪物名称 原地图 原X 原Y 范围1 新地图 新X 新Y
  sMonName := QuestActionInfo.sParam1;

  if QuestActionInfo.sParam2 = 'SELF' then
    Envir := PlayObject.m_PEnvir
  else
    Envir := g_MapManager.FindMap(QuestActionInfo.sParam2);

  nX1 := Str_ToInt(QuestActionInfo.sParam3, -1);
  nY1 := Str_ToInt(QuestActionInfo.sParam4, -1);
  nN := Str_ToInt(QuestActionInfo.sParam5, 0);
  if QuestActionInfo.sParam6 = 'SELF' then
    sMAP := PlayObject.m_sMapName
  else
    sMAP := QuestActionInfo.sParam6;
  nX2 := Str_ToInt(QuestActionInfo.sParam7, -1);
  nY2 := Str_ToInt(QuestActionInfo.sParam8, -1);
  if (sMonName = '') or (Envir = nil) or (nX1 < 0) or (nY1 < 0) or (nX2 < 0) or (nY2 < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGERANGEMONPOS);
    Exit;
  end;

  MonList := TList.Create;
  Envir.GetRangeBaseObject(nX1, nY1, nN, True, MonList);
  for i := MonList.Count - 1 downto 0 do
  begin
    BaseObject := TBaseObject(MonList.Items[i]);
    if CompareText(BaseObject.m_sCharName, sMonName) = 0 then
    begin
      BaseObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
      BaseObject.SpaceMove(sMAP, nX2, nY2, 0);
    end;
  end;
  MonList.Free;
end;
//            1   2     3
//SetMission +/-/ sid step

procedure TNormNpc.ActionOfSetMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  st, sid, sDesc: string;
  nst, nStep, nClass: Integer;
  cMethod: Char;
begin
  nStep := Str_ToInt(QuestActionInfo.sParam3, 0);
  if (nStep < 0) or (QuestActionInfo.sParam1 = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SetMission);
    Exit;
  end;
  sid := QuestActionInfo.sParam2;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '+':
      begin
        nst := PlayObject.GetMissionStep(sid);
        if nst <= 0 then
        begin
          nStep := 1;
          PlayObject.m_MissionList.AddObject(sid, TObject(nStep));
          st := M2Share.GetMissionSendMsg(sid, nStep, nClass);
          if st <> '' then
            sDesc := GetLineVariableText(PlayObject, st); //'title=%s desc=%s';
          if sDesc <> '' then
            PlayObject.SendMsg(PlayObject, RM_SETMISSION, 1, Str_ToInt(sid, 0), nClass, 0, sDesc);
        end
        else if nst <> nStep then
        begin
          st := M2Share.GetMissionSendMsg(sid, nStep, nClass);
          if st <> '' then
            sDesc := GetLineVariableText(PlayObject, st); //'title=%s desc=%s';
          if sDesc <> '' then
            PlayObject.SendMsg(PlayObject, RM_SETMISSION, 1, Str_ToInt(sid, 0), nClass, 1, sDesc);
        end;
      end;
    '-':
      begin
        if PlayObject.DeleteMission(sid) >= 0 then
        begin
          if g_FunctionNPC <> nil then
            g_FunctionNPC.GotoLable(PlayObject, '@CancelMission', False);
          M2Share.GetMissionSendMsg(sid, 1, nClass);
          if nClass <> 0 then
            PlayObject.SendMsg(PlayObject, RM_SETMISSION, 2, Str_ToInt(sid, 0), nClass, 0, '');
        end;
      end;
    '^':
      begin
        nst := PlayObject.UpdateMission(sid, nStep);
        if nst > 0 then
        begin
          st := M2Share.GetMissionSendMsg(sid, nst, nClass);
          if st <> '' then
            sDesc := GetLineVariableText(PlayObject, st); //'title=%s desc=%s';
          if sDesc <> '' then
            PlayObject.SendMsg(PlayObject, RM_SETMISSION, 1, Str_ToInt(sid, 0), nClass, 1, sDesc);
        end;
      end;
  end;
end;

procedure TNormNpc.ActionOfClearMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, c: Integer;
  s: string;
begin
  for i := 0 to PlayObject.m_MissionList.Count - 1 do
  begin
    s := PlayObject.m_MissionList[i];
    M2Share.GetMissionSendMsg(s, 1, c);
    if c <> 0 then
      PlayObject.SendMsg(PlayObject, RM_SETMISSION, 2, Str_ToInt(s, 0), c, 0, '');
  end;
  PlayObject.m_MissionList.Clear;
end;

function TNormNpc.ConditionOfCheckTitle(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i, nStep, nPoint: Integer;
  cMethod: Char;
  pStdItem: pTStdItem;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if (nPoint < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CheckTitle);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam2[1];

  nStep := 0;
  for i := Low(THumTitles) to High(THumTitles) do
  begin
    pStdItem := UserEngine.GetTitle(PlayObject.m_Titles[i].Index);
    if pStdItem <> nil then
    begin
      if CompareText(pStdItem.Name, QuestConditionInfo.sParam1) = 0 then
      begin
        Inc(nStep);
      end;
    end;
  end;
  case cMethod of
    '=': if nStep = nPoint then
        Result := True;
    '>': if nStep > nPoint then
        Result := True;
    '<': if nStep < nPoint then
        Result := True;
  else if nStep >= nPoint then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMission(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nStep, nPoint: Integer;
  cMethod: Char;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if (nPoint < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CheckMission);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam2[1];
  nStep := PlayObject.GetMissionStep(QuestConditionInfo.sParam1);
  case cMethod of
    '=': if nStep = nPoint then
        Result := True;
    '>': if nStep > nPoint then
        Result := True;
    '<': if nStep < nPoint then
        Result := True;
  else if nStep >= nPoint then
    Result := True;
  end;
end;

procedure TNormNpc.ActionOfReadRandomStr(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, nNo, nGetLineOk: Integer;
  LoadList: TStringList;
  sLine, sName, sRate, sListFileName: string;
begin
  sListFileName := g_Config.sEnvirDir + QuestActionInfo.sParam1;
  if not FileExists(sListFileName) then
    sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  nNo := GetValNameNo(QuestActionInfo.sParam2);
  if (nNo < 0) or not FileExists(sListFileName) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_READRANDOMSTR);
    Exit;
  end;
  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sListFileName);
  if LoadList.Count <= 0 then
  begin
    LoadList.Free;
    Exit;
  end;

  nGetLineOk := -1;
  while nGetLineOk = -1 do
  begin
    for i := 0 to LoadList.Count - 1 do
    begin
      sLine := LoadList.Strings[i];
      if (sLine = '') or (sLine[1] = ';') then
        Continue;
      sRate := GetValidStr3(sLine, sName, [' ', #9]);
      if (sName = '') then
        Continue;
      if Random(Str_ToInt(sRate, 0) + 2) = 0 then
      begin
        case nNo of
          500..599: g_Config.GlobaDyTval[nNo - 500] := sName;
          600..699: PlayObject.m_nSval[nNo - 600] := sName;
        end;
        nGetLineOk := i;
        Break;
      end;
    end;
  end;

  {nGetLineOk := 0;
  while nGetLineOk = 0 do begin
    sLine := LoadList.Strings[Random(LoadList.Count)];
    if (sLine <> '') and (sLine[1] <> ';') then begin
      case nNo of
        500..599: g_Config.GlobaDyTval[nNo - 500] := sLine;
        600..699: PlayObject.m_nSval[nNo - 600] := sLine;
      end;
      nGetLineOk := 1;
    end;
  end;}

  LoadList.Free;
end;

procedure TNormNpc.ActionOfReadRandomLine(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nNo: Integer;
  LoadList: TStringList;
  sLine, sListFileName: string;
begin
  sListFileName := g_Config.sEnvirDir + QuestActionInfo.sParam1;
  if not FileExists(sListFileName) then
    sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  nNo := GetValNameNo(QuestActionInfo.sParam2);
  if (nNo < 0) or not FileExists(sListFileName) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_READRANDOMLINE);
    Exit;
  end;
  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sListFileName);
  if LoadList.Count <= 0 then
  begin
    LoadList.Free;
    Exit;
  end;
  sLine := LoadList.Strings[Random(LoadList.Count)];
  case nNo of
    500..599: g_Config.GlobaDyTval[nNo - 500] := sLine;
    600..699: PlayObject.m_nSval[nNo - 600] := sLine;
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfDropItemMap(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

  function GetDropMapPosition(Envir: TEnvirnoment; nOrgX, nOrgY, nRange: Integer; var nDX: Integer; var nDY: Integer): Boolean;
  var
    i, ii, III: Integer;
    nItemCount, n24, n28, n2C: Integer;
  begin
    n24 := 999;
    Result := False;
    n28 := 0;
    n2C := 0;
    for i := 1 to nRange do
    begin
      for ii := -i to i do
      begin
        for III := -i to i do
        begin
          nDX := nOrgX + III;
          nDY := nOrgY + ii;
          if Envir.GetItemEx(nDX, nDY, nItemCount) = nil then
          begin
            if Envir.m_boChFlag then
            begin
              Result := True;
              Break;
            end;
          end
          else if Envir.m_boChFlag and (n24 > nItemCount) then
          begin
            n24 := nItemCount;
            n28 := nDX;
            n2C := nDY;
          end;
        end;
        if Result then
          Break;
      end;
      if Result then
        Break;
    end;
    if not Result then
    begin
      if n24 < 8 then
      begin
        nDX := n28;
        nDY := n2C;
      end
      else
      begin
        nDX := nOrgX;
        nDY := nOrgY;
      end;
    end;
  end;
var
  sMAP, sItemName: string;
  i, tX, tY, dx, dy, idura: Integer;
  nRange, nCount: Integer;
  MapItem, pr: pTMapItem;
  StdItem: pTStdItem;
  UserItem: pTUserItem;
  Envir: TEnvirnoment;
begin
  //ThrowItem 地图号 坐标X 坐标Y 范围 物品 数量
  sMAP := QuestActionInfo.sParam1;
  if CompareText(sMAP, 'SELF') = 0 then
  begin
    if PlayObject.m_PEnvir <> nil then
    begin
      sMAP := PlayObject.m_PEnvir.m_sMapFileName;
      //if sMAP = '' then sMAP := PlayObject.m_PEnvir.m_sMapMapingName;
    end;
  end;
  tX := Str_ToInt(QuestActionInfo.sParam2, -1);
  tY := Str_ToInt(QuestActionInfo.sParam3, -1);
  nRange := Str_ToInt(QuestActionInfo.sParam4, -1);
  sItemName := Trim(QuestActionInfo.sParam5);
  nCount := Str_ToInt(QuestActionInfo.sParam6, 1);
  if (sMAP = '') or (tX < 0) or (tY < 0) or (sItemName = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_DROPITEMMAP);
    Exit;
  end;
  Envir := g_MapManager.FindMap(sMAP);
  if Envir <> nil then
  begin
    for i := 0 to nCount - 1 do
    begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
      begin
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if Random(g_Config.nMakeRandomAddValue) = 0 then
          UserEngine.RandomUpgradeItem(UserItem);
        if StdItem.StdMode in [15..24, 26] then
          if StdItem.Shape in [130, 131, 132] then
            UserEngine.GetUnknowItemValue(UserItem);
        if StdItem.StdMode = 40 then
        begin
          idura := UserItem.Dura;
          idura := idura - 2000;
          if idura < 0 then
            idura := 0;
          UserItem.Dura := idura;
        end;
        New(MapItem);
        MapItem.IsGold := False;
        MapItem.UserItem := UserItem^;
        //MapItem.Name := StdItem.Name;

        if (StdItem.Overlap >= 1) and (UserItem.Dura > 1) then
        begin
          MapItem.Name := Format('%s\(%d)', [StdItem.Name, UserItem.Dura])
        end
        else
        begin
          MapItem.Name := StdItem.Name;
        end;

        {if PCardinal(@MapItem.UserItem.btValue[22])^ > 0 then begin
          MapItem.Name := MapItem.Name + '\(已绑定)';
        end else begin
          case StdItem.SvrSet.nBind of
            1: if g_Config.boBindPickUp then MapItem.Name := MapItem.Name + '\(拾取后绑定)';
            2: if g_Config.boBindTakeOn then MapItem.Name := MapItem.Name + '\(装备后绑定)';
            3: if g_Config.boBindPickUp and g_Config.boBindTakeOn then MapItem.Name := MapItem.Name + '\(拾取或装备绑定)';
          end;
        end;}

        MapItem.Looks := StdItem.Looks;
        MapItem.boHeroPickup := StdItem.SvrSet.boHeroPickup;
        MapItem.AniCount := StdItem.AniCount;
        MapItem.Reserved := 0;
        MapItem.Count := 1;
        MapItem.OfBaseObject := nil;
        MapItem.dwCanPickUpTick := GetTickCount();
        MapItem.DropBaseObject := Self;
        GetDropMapPosition(Envir, tX, tY, nRange, dx, dy);
        pr := Envir.AddToMap(dx, dy, OS_ITEMOBJECT, TObject(MapItem));
        if pr = MapItem then
          SendRefMsg(RM_ITEMSHOW, MapItem.Looks, Integer(MapItem), dx, dy, MapItem.Name)
        else
        begin
          Dispose(MapItem);
          Dispose(UserItem);
        end;
      end
      else
      begin
        Dispose(UserItem);
        Break;
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfBonusAbil(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nCount: Integer;
  cMethod: Char;
  boChg: Boolean;
begin
  //if PlayObject.m_nBonusPoint < 1 then Exit;
  boChg := False;
  nCount := Str_ToInt(QuestActionInfo.sParam3, -1);
  if (nCount < 0) or (nCount > 1000) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_BONUSABIL);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam2[1];
  if QuestActionInfo.sParam1 = 'DC' then
  begin
    case cMethod of
      '+': if PlayObject.m_nBonusPoint >= nCount then
        begin
          Dec(PlayObject.m_nBonusPoint, nCount);
          Inc(PlayObject.m_BonusAbil.DC, nCount);
          boChg := True;
        end;
      '-': if PlayObject.m_BonusAbil.DC >= nCount then
        begin
          Dec(PlayObject.m_BonusAbil.DC, nCount);
          Inc(PlayObject.m_nBonusPoint, nCount);
          boChg := True;
        end;
    end;
  end
  else if QuestActionInfo.sParam1 = 'MC' then
  begin
    case cMethod of
      '+': if PlayObject.m_nBonusPoint >= nCount then
        begin
          Dec(PlayObject.m_nBonusPoint, nCount);
          Inc(PlayObject.m_BonusAbil.MC, nCount);
          boChg := True;
        end;
      '-': if PlayObject.m_BonusAbil.MC >= nCount then
        begin
          Dec(PlayObject.m_BonusAbil.MC, nCount);
          Inc(PlayObject.m_nBonusPoint, nCount);
          boChg := True;
        end;
    end;
  end
  else if QuestActionInfo.sParam1 = 'SC' then
  begin
    case cMethod of
      '+': if PlayObject.m_nBonusPoint >= nCount then
        begin
          Dec(PlayObject.m_nBonusPoint, nCount);
          Inc(PlayObject.m_BonusAbil.SC, nCount);
          boChg := True;
        end;
      '-': if PlayObject.m_BonusAbil.SC >= nCount then
        begin
          Dec(PlayObject.m_BonusAbil.SC, nCount);
          Inc(PlayObject.m_nBonusPoint, nCount);
          boChg := True;
        end;
    end;
  end
  else if QuestActionInfo.sParam1 = 'HP' then
  begin
    case cMethod of
      '+': if PlayObject.m_nBonusPoint >= nCount then
        begin
          Dec(PlayObject.m_nBonusPoint, nCount);
          Inc(PlayObject.m_BonusAbil.HP, nCount);
          boChg := True;
        end;
      '-': if PlayObject.m_BonusAbil.HP >= nCount then
        begin
          Dec(PlayObject.m_BonusAbil.HP, nCount);
          Inc(PlayObject.m_nBonusPoint, nCount);
          boChg := True;
        end;
    end;
  end
  else if QuestActionInfo.sParam1 = 'MP' then
  begin
    case cMethod of
      '+': if PlayObject.m_nBonusPoint >= nCount then
        begin
          Dec(PlayObject.m_nBonusPoint, nCount);
          Inc(PlayObject.m_BonusAbil.MP, nCount);
          boChg := True;
        end;
      '-': if PlayObject.m_BonusAbil.MP >= nCount then
        begin
          Dec(PlayObject.m_BonusAbil.MP, nCount);
          Inc(PlayObject.m_nBonusPoint, nCount);
          boChg := True;
        end;
    end;
  end
  else if QuestActionInfo.sParam1 = 'AC' then
  begin
    case cMethod of
      '+': if PlayObject.m_nBonusPoint >= nCount then
        begin
          Dec(PlayObject.m_nBonusPoint, nCount);
          Inc(PlayObject.m_BonusAbil.AC, nCount);
          boChg := True;
        end;
      '-': if PlayObject.m_BonusAbil.AC >= nCount then
        begin
          Dec(PlayObject.m_BonusAbil.AC, nCount);
          Inc(PlayObject.m_nBonusPoint, nCount);
          boChg := True;
        end;
    end;
  end
  else if QuestActionInfo.sParam1 = 'MAC' then
  begin
    case cMethod of
      '+': if PlayObject.m_nBonusPoint >= nCount then
        begin
          Dec(PlayObject.m_nBonusPoint, nCount);
          Inc(PlayObject.m_BonusAbil.MAC, nCount);
          boChg := True;
        end;
      '-': if PlayObject.m_BonusAbil.MAC >= nCount then
        begin
          Dec(PlayObject.m_BonusAbil.MAC, nCount);
          Inc(PlayObject.m_nBonusPoint, nCount);
          boChg := True;
        end;
    end;
  end
  else if QuestActionInfo.sParam1 = 'HIT' then
  begin
    case cMethod of
      '+': if PlayObject.m_nBonusPoint >= nCount then
        begin
          Dec(PlayObject.m_nBonusPoint, nCount);
          Inc(PlayObject.m_BonusAbil.HIT, nCount);
          boChg := True;
        end;
      '-': if PlayObject.m_BonusAbil.HIT >= nCount then
        begin
          Dec(PlayObject.m_BonusAbil.HIT, nCount);
          Inc(PlayObject.m_nBonusPoint, nCount);
          boChg := True;
        end;
    end;
  end
  else if QuestActionInfo.sParam1 = 'SPD' then
  begin
    case cMethod of
      '+': if PlayObject.m_nBonusPoint >= nCount then
        begin
          Dec(PlayObject.m_nBonusPoint, nCount);
          Inc(PlayObject.m_BonusAbil.Speed, nCount);
          boChg := True;
        end;
      '-': if PlayObject.m_BonusAbil.Speed >= nCount then
        begin
          Dec(PlayObject.m_BonusAbil.Speed, nCount);
          Inc(PlayObject.m_nBonusPoint, nCount);
          boChg := True;
        end;
    end;
  end
  else if QuestActionInfo.sParam1 = 'X2' then
  begin
    case cMethod of
      '+': if PlayObject.m_nBonusPoint >= nCount then
        begin
          Dec(PlayObject.m_nBonusPoint, nCount);
          Inc(PlayObject.m_BonusAbil.X2, nCount);
          boChg := True;
        end;
      '-': if PlayObject.m_BonusAbil.X2 >= nCount then
        begin
          Dec(PlayObject.m_BonusAbil.X2, nCount);
          Inc(PlayObject.m_nBonusPoint, nCount);
          boChg := True;
        end;
    end;
  end;
  if not boChg then
    Exit;
  PlayObject.RecalcLevelAbilitys();
  PlayObject.RecalcAbilitys();

  if  m_WAbil.HP > m_WAbil.MaxHP then
    m_WAbil.HP := m_WAbil.MaxHP;
  if  m_WAbil.MP > m_WAbil.MaxMP then
    m_WAbil.MP := m_WAbil.MaxMP;

  PlayObject.SendMsg(Self, RM_LEVELUP, 0, m_Abil.Exp, 0, 0, '');
end;

procedure TNormNpc.ActionOfGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nGameGold, nCount: Integer;
  sGameGold, sCount: string;
  nOldGameGold: Integer;
  cMethod: Char;
begin
  nOldGameGold := PlayObject.m_nGameGold;
  sCount := QuestActionInfo.sParam3;
  nCount := Str_ToInt(sCount, 1);
  sGameGold := QuestActionInfo.sParam2;
  nGameGold := Str_ToInt(sGameGold, -1);
  if (nGameGold < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GAMEGOLD);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nGameGold >= 0) then
        begin
          PlayObject.m_nGameGold := nGameGold;
        end;
      end;
    '-':
      begin
        nGameGold := _MAX(0, PlayObject.m_nGameGold - (nGameGold * nCount));
        PlayObject.m_nGameGold := nGameGold;
      end;
    '+':
      begin
        nGameGold := _MAX(0, PlayObject.m_nGameGold + (nGameGold * nCount));
        PlayObject.m_nGameGold := nGameGold;
      end;
  end;
  if g_boGameLogGameGold then
  begin
    AddGameDataLogAPI(Format(g_sGameLogMsg1, [LOG_GAMEGOLD,
      PlayObject.m_sMapName,
        PlayObject.m_nCurrX,
        PlayObject.m_nCurrY,
        PlayObject.m_sCharName,
        g_Config.sGameGoldName,
        nGameGold,
        cMethod,
        m_sCharName]));
  end;
  if nOldGameGold <> PlayObject.m_nGameGold then
    PlayObject.GameGoldChanged;
end;

procedure TNormNpc.ActionOfAbilityAdd(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  Pos, value, addtime: Integer;
begin
  if CompareText(QuestActionInfo.sParam1, 'CLEAR') = 0 then
  begin
    FillChar(PlayObject.m_wStatusArrValue2, SizeOf(PlayObject.m_wStatusArrValue2), #0);
    PlayObject.RecalcAbilitys();
    PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
    Exit;
  end;
  Pos := Str_ToInt(QuestActionInfo.sParam1, -1);
  value := Str_ToInt(QuestActionInfo.sParam2, -1);
  addtime := Str_ToInt(QuestActionInfo.sParam3, -1);
  if not (Pos in [0..6]) or ((value < 0) or (value > 65535)) or (addtime < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AbilityAdd);
    Exit;
  end;
  PlayObject.m_wStatusArrValue2[Pos] := value;
  PlayObject.m_dwStatusArrTimeOutTick2[Pos] := GetTickCount + addtime * 1000;
  PlayObject.RecalcAbilitys();
  PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
  case Pos of
    0: PlayObject.SysMsg(Format('HP附加%d点，有效时间%d秒', [value, addtime]), c_Purple, t_Hint);
    1: PlayObject.SysMsg(Format('MP附加%d点，有效时间%d秒', [value, addtime]), c_Purple, t_Hint);
    2: PlayObject.SysMsg(Format('防御附加%d点，有效时间%d秒', [value, addtime]), c_Purple, t_Hint);
    3: PlayObject.SysMsg(Format('魔御附加%d点，有效时间%d秒', [value, addtime]), c_Purple, t_Hint);
    4: PlayObject.SysMsg(Format('攻击附加%d点，有效时间%d秒', [value, addtime]), c_Purple, t_Hint);
    5: PlayObject.SysMsg(Format('魔法附加%d点，有效时间%d秒', [value, addtime]), c_Purple, t_Hint);
    6: PlayObject.SysMsg(Format('道术附加%d点，有效时间%d秒', [value, addtime]), c_Purple, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfNimbus(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nGameGold, nCount: Integer;
  sGameGold, sCount: string;
  // nOldGameGold: Integer;
  cMethod: Char;
begin
  // nOldGameGold := PlayObject.m_dwGatherNimbus;
  sCount := QuestActionInfo.sParam3;
  nCount := Str_ToInt(sCount, 1);
  sGameGold := QuestActionInfo.sParam2;
  nGameGold := Str_ToInt(sGameGold, -1);
  if (nGameGold < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_NIMBUS);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nGameGold >= 0) then
        begin
          PlayObject.m_dwGatherNimbus := nGameGold;
        end;
      end;
    '-':
      begin
        nGameGold := _MAX(0, PlayObject.m_dwGatherNimbus - (nGameGold * nCount));
        PlayObject.m_dwGatherNimbus := nGameGold;
      end;
    '+':
      begin
        nGameGold := _MAX(0, PlayObject.m_dwGatherNimbus + (nGameGold * nCount));
        PlayObject.m_dwGatherNimbus := nGameGold;
      end;
  end;
  {if g_boGameLogGameGold then begin
    AddGameDataLogAPI(Format(g_sGameLogMsg1, [LOG_GAMEGOLD,
      PlayObject.m_sMapName,
        PlayObject.m_nCurrX,
        PlayObject.m_nCurrY,
        PlayObject.m_sCharName,
        g_Config.sGameGoldName,
        nGameGold,
        cMethod,
        m_sCharName]));
  end;
  if nOldGameGold <> PlayObject.m_dwGatherNimbus then
    PlayObject.GameGoldChanged;}
end;

procedure TNormNpc.ActionOfGamePoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nGamePoint: Integer;
  sGamePoint: string;
  nOldGamePoint: Integer;
  cMethod: Char;
begin
  nOldGamePoint := PlayObject.m_nGamePoint;
  sGamePoint := QuestActionInfo.sParam2;
  nGamePoint := Str_ToInt(sGamePoint, -1);
  if nGamePoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GAMEPOINT);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nGamePoint >= 0) then
        begin
          PlayObject.m_nGamePoint := nGamePoint;
        end;
      end;
    '-':
      begin
        nGamePoint := _MAX(0, PlayObject.m_nGamePoint - nGamePoint);
        PlayObject.m_nGamePoint := nGamePoint;
      end;
    '+':
      begin
        nGamePoint := _MAX(0, PlayObject.m_nGamePoint + nGamePoint);
        PlayObject.m_nGamePoint := nGamePoint;
      end;
  end;
  if g_boGameLogGamePoint then
  begin
    AddGameDataLogAPI(Format(g_sGameLogMsg1, [LOG_GAMEPOINT,
      PlayObject.m_sMapName,
        PlayObject.m_nCurrX,
        PlayObject.m_nCurrY,
        PlayObject.m_sCharName,
        g_Config.sGamePointName,
        nGamePoint,
        cMethod,
        m_sCharName]));
  end;
  if nOldGamePoint <> PlayObject.m_nGamePoint then
    PlayObject.GameGoldChanged;
end;

procedure TNormNpc.ActionOfGetMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  PoseBaseObject: TBaseObject;
begin
  PoseBaseObject := PlayObject.GetPoseCreate();
  if (PoseBaseObject <> nil) and (PoseBaseObject.m_btRaceServer = RC_PLAYOBJECT)
    and (PoseBaseObject.m_btGender <> PlayObject.m_btGender) then
  begin
    PlayObject.m_sDearName := PoseBaseObject.m_sCharName;
    PlayObject.RefShowName;
    PoseBaseObject.RefShowName;
  end
  else
    GotoLable(PlayObject, '@MarryError', False);
end;

procedure TNormNpc.ActionOfGetMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseBaseObject: TBaseObject;
begin
  PoseBaseObject := PlayObject.GetPoseCreate();
  if (PoseBaseObject <> nil) and (PoseBaseObject.m_btRaceServer = RC_PLAYOBJECT)
    and (PoseBaseObject.m_btGender <> PlayObject.m_btGender) then
  begin
    PlayObject.m_sMasterName := PoseBaseObject.m_sCharName;
    PlayObject.RefShowName;
    PoseBaseObject.RefShowName;
  end
  else
    GotoLable(PlayObject, '@MasterError', False);
end;

procedure TNormNpc.ActionOfScrollMsg(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sMsg: string;
  Sec, fc, bc: Integer;
begin
  sMsg := GetLineVariableText(PlayObject, QuestActionInfo.sParam1);
  sMsg := AnsiReplaceText(sMsg, '%s', PlayObject.m_sCharName);
  sMsg := AnsiReplaceText(sMsg, '%d', m_sCharName);
  if PlayObject.m_PEnvir <> nil then
    sMsg := AnsiReplaceText(sMsg, '%m', PlayObject.m_PEnvir.m_sMapDesc);
  sMsg := AnsiReplaceText(sMsg, '%x', IntToStr(PlayObject.m_nCurrX));
  sMsg := AnsiReplaceText(sMsg, '%y', IntToStr(PlayObject.m_nCurrY));
  fc := Str_ToInt(QuestActionInfo.sParam2, -1);
  bc := Str_ToInt(QuestActionInfo.sParam3, -1);
  if fc = -1 then
    fc := 150;
  if bc = -1 then
    bc := 14;
  UserEngine.SendScrollMsg(sMsg, t_System, c_Cust, fc, bc, Sec)
end;

procedure TNormNpc.ActionOfSetMerchantDlgImgName(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  //if Self.ClassType = TMerchant then begin
  if m_sMDlgImgName <> QuestActionInfo.sParam1 then
  begin
    m_sMDlgImgName := QuestActionInfo.sParam1;
    PlayObject.SendDefMessage(SM_SetMerchantDlgImgName, 0, 0, 0, 0, QuestActionInfo.sParam1);
  end;
  //end;
end;

procedure TNormNpc.ActionOfLineMsg(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sMsg: string;
  Sec, fc, bc: Integer;
  pdc: PTDelayCallNPC;
begin
  sMsg := GetLineVariableText(PlayObject, QuestActionInfo.sParam2);
  sMsg := AnsiReplaceText(sMsg, '%s', PlayObject.m_sCharName);
  sMsg := AnsiReplaceText(sMsg, '%d', m_sCharName);
  if PlayObject.m_PEnvir <> nil then
    sMsg := AnsiReplaceText(sMsg, '%m', PlayObject.m_PEnvir.m_sMapDesc);
  sMsg := AnsiReplaceText(sMsg, '%x', IntToStr(PlayObject.m_nCurrX));
  sMsg := AnsiReplaceText(sMsg, '%y', IntToStr(PlayObject.m_nCurrY));

  fc := Str_ToInt(QuestActionInfo.sParam3, -1);
  bc := Str_ToInt(QuestActionInfo.sParam4, -1);
  Sec := Str_ToInt(QuestActionInfo.sParam5, -1);

  if (fc in [0..255]) and (bc in [0..255]) and (fc <> bc) then
  begin
    case QuestActionInfo.nParam1 of
      0: if Sec > 0 then
          UserEngine.SendBroadCastMsg(sMsg, t_System, c_Cust, fc, bc, Sec)
        else
          UserEngine.SendBroadCastMsg(sMsg, t_System, c_Cust, fc, bc);
      1: if Sec > 0 then
          UserEngine.SendBroadCastMsg('(*) ' + sMsg, t_System, c_Cust, fc, bc, Sec)
        else
          UserEngine.SendBroadCastMsg('(*) ' + sMsg, t_System, c_Cust, fc, bc);
      2: if Sec > 0 then
          UserEngine.SendBroadCastMsg('[' + m_sCharName + ']' + sMsg, t_System, c_Cust, fc, bc, Sec)
        else
          UserEngine.SendBroadCastMsg('[' + m_sCharName + ']' + sMsg, t_System, c_Cust, fc, bc);
      3: if Sec > 0 then
          UserEngine.SendBroadCastMsg('[' + PlayObject.m_sCharName + ']' + sMsg, t_System, c_Cust, fc, bc, Sec)
        else
          UserEngine.SendBroadCastMsg('[' + PlayObject.m_sCharName + ']' + sMsg, t_System, c_Cust, fc, bc);
      4: ProcessSayMsg(sMsg);
      5..07: if Sec > 0 then
          PlayObject.SysMsg(sMsg, c_Cust, t_Say, fc, bc, Sec)
        else
          PlayObject.SysMsg(sMsg, c_Cust, t_Say, fc, bc);
      8..10: if PlayObject.m_MyGuild <> nil then
        begin
          if Sec > 0 then
            TGuild(PlayObject.m_MyGuild).SendGuildMsg(PlayObject.m_sCharName + ': ' + sMsg, 4, fc, bc, Sec)
          else
            TGuild(PlayObject.m_MyGuild).SendGuildMsg(PlayObject.m_sCharName + ': ' + sMsg, 4, fc, bc);
        end;

      11: if Sec > 0 then
          UserEngine.CryCry(RM_CRY, PlayObject.m_PEnvir, PlayObject.m_nCurrX, PlayObject.m_nCurrY, 100, fc, bc, sMsg, Sec)
        else
          UserEngine.CryCry(RM_CRY, PlayObject.m_PEnvir, PlayObject.m_nCurrX, PlayObject.m_nCurrY, 100, fc, bc, sMsg);
      12: if Sec > 0 then
          PlayObject.SendGroupText(PlayObject.m_sCharName + ': ' + sMsg, 1, fc, bc, Sec)
        else
          PlayObject.SendGroupText(PlayObject.m_sCharName + ': ' + sMsg, 1, fc, bc);
    else
      begin
        ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SENDMSG);
        Exit;
      end;
    end;

    if (Sec > 0) and (QuestActionInfo.sParam6 <> '') then
    begin
      New(pdc);
      pdc.nDelayCall := Sec * 1000;
      pdc.sDelayCallLabel := QuestActionInfo.sParam6;
      pdc.dwDelayCallTick := GetTickCount();
      pdc.bProcessed := False;
      pdc.DelayCallNPC := Integer(Self);
      PlayObject.m_DelayCallList.Add(pdc);
    end;
    Exit;
  end;
  case QuestActionInfo.nParam1 of
    0: UserEngine.SendBroadCastMsg(sMsg, t_System);
    1: UserEngine.SendBroadCastMsg('(*) ' + sMsg, t_System);
    2: UserEngine.SendBroadCastMsg('[' + m_sCharName + ']' + sMsg, t_System);
    3: UserEngine.SendBroadCastMsg('[' + PlayObject.m_sCharName + ']' + sMsg, t_System);
    4: ProcessSayMsg(sMsg);
    5: PlayObject.SysMsg(sMsg, c_Red, t_Say);
    6: PlayObject.SysMsg(sMsg, c_Green, t_Say);
    7: PlayObject.SysMsg(sMsg, c_Blue, t_Say);
    8: if PlayObject.m_MyGuild <> nil then
        TGuild(PlayObject.m_MyGuild).SendGuildMsg(PlayObject.m_sCharName + ': ' + sMsg, 1);
    9: if PlayObject.m_MyGuild <> nil then
        TGuild(PlayObject.m_MyGuild).SendGuildMsg(PlayObject.m_sCharName + ': ' + sMsg, 2);
    10: if PlayObject.m_MyGuild <> nil then
        TGuild(PlayObject.m_MyGuild).SendGuildMsg(PlayObject.m_sCharName + ': ' + sMsg, 3);
    11: UserEngine.CryCry(RM_CRY, PlayObject.m_PEnvir, PlayObject.m_nCurrX, PlayObject.m_nCurrY, 100, g_Config.btCryMsgFColor, g_Config.btCryMsgBColor, sMsg);
    12: PlayObject.SendGroupText(PlayObject.m_sCharName + ': ' + sMsg);
  else
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SENDMSG);
  end;
end;

procedure TNormNpc.ActionOfMapTing(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin

end;

procedure TNormNpc.ActionOfMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  sSayMsg: string;
begin
  if PlayObject.m_sDearName <> '' then
    Exit;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate());
  if PoseHuman = nil then
  begin
    GotoLable(PlayObject, '@MarryCheckDir', False);
    Exit;
  end;
  if QuestActionInfo.sParam1 = '' then
  begin
    if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then
    begin
      GotoLable(PlayObject, '@HumanTypeErr', False);
      Exit;
    end;
    if PoseHuman.GetPoseCreate = PlayObject then
    begin
      if PlayObject.m_btGender <> PoseHuman.m_btGender then
      begin
        GotoLable(PlayObject, '@StartMarry', False);
        GotoLable(PoseHuman, '@StartMarry', False);
        if (PlayObject.m_btGender = 0) and (PoseHuman.m_btGender = 1) then
        begin
          sSayMsg := AnsiReplaceText(g_sStartMarryManMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sStartMarryManAskQuestionMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        end
        else if (PlayObject.m_btGender = 1) and (PoseHuman.m_btGender = 0) then
        begin
          sSayMsg := AnsiReplaceText(g_sStartMarryWoManMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sStartMarryWoManAskQuestionMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        end;
        PlayObject.m_boStartMarry := True;
        PoseHuman.m_boStartMarry := True;
      end
      else
      begin
        GotoLable(PoseHuman, '@MarrySexErr', False);
        GotoLable(PlayObject, '@MarrySexErr', False);
      end;
    end
    else
    begin
      GotoLable(PlayObject, '@MarryDirErr', False);
      GotoLable(PoseHuman, '@MarryCheckDir', False);
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'REQUESTMARRY' {sREQUESTMARRY}) = 0 then
  begin
    if PlayObject.m_boStartMarry and PoseHuman.m_boStartMarry then
    begin
      if (PlayObject.m_btGender = 0) and (PoseHuman.m_btGender = 1) then
      begin
        sSayMsg := AnsiReplaceText(g_sMarryManAnswerQuestionMsg, '%n', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
        UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        sSayMsg := AnsiReplaceText(g_sMarryManAskQuestionMsg, '%n', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
        UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        GotoLable(PlayObject, '@WateMarry', False);
        GotoLable(PoseHuman, '@RevMarry', False);
      end;
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'RESPONSEMARRY' {sRESPONSEMARRY}) = 0 then
  begin
    if (PlayObject.m_btGender = 1) and (PoseHuman.m_btGender = 0) then
    begin
      if CompareText(QuestActionInfo.sParam2, 'OK') = 0 then
      begin
        if PlayObject.m_boStartMarry and PoseHuman.m_boStartMarry then
        begin
          sSayMsg := AnsiReplaceText(g_sMarryWoManAnswerQuestionMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sMarryWoManGetMarryMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          GotoLable(PlayObject, '@EndMarry', False);
          GotoLable(PoseHuman, '@EndMarry', False);
          PlayObject.m_boStartMarry := False;
          PoseHuman.m_boStartMarry := False;
          PlayObject.m_sDearName := PoseHuman.m_sCharName;
          PlayObject.m_DearHuman := PoseHuman;
          PoseHuman.m_sDearName := PlayObject.m_sCharName;
          PoseHuman.m_DearHuman := PlayObject;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
        end;
      end
      else
      begin
        if PlayObject.m_boStartMarry and PoseHuman.m_boStartMarry then
        begin
          GotoLable(PlayObject, '@EndMarryFail', False);
          GotoLable(PoseHuman, '@EndMarryFail', False);
          PlayObject.m_boStartMarry := False;
          PoseHuman.m_boStartMarry := False;
          sSayMsg := AnsiReplaceText(g_sMarryWoManDenyMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sMarryWoManCancelMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        end;
      end;
    end;
    Exit;
  end;
end;

procedure TNormNpc.ActionOfMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
begin
  if PlayObject.m_sMasterName <> '' then
    Exit;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate());
  if PoseHuman = nil then
  begin
    GotoLable(PlayObject, '@MasterCheckDir', False);
    Exit;
  end;
  if QuestActionInfo.sParam1 = '' then
  begin
    if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then
    begin
      GotoLable(PlayObject, '@HumanTypeErr', False);
      Exit;
    end;
    if PoseHuman.GetPoseCreate = PlayObject then
    begin
      GotoLable(PlayObject, '@StartGetMaster', False);
      GotoLable(PoseHuman, '@StartMaster', False);
      PlayObject.m_boStartMaster := True;
      PoseHuman.m_boStartMaster := True;
    end
    else
    begin
      GotoLable(PlayObject, '@MasterDirErr', False);
      GotoLable(PoseHuman, '@MasterCheckDir', False);
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'REQUESTMASTER') = 0 then
  begin
    if PlayObject.m_boStartMaster and PoseHuman.m_boStartMaster then
    begin
      PlayObject.m_PoseBaseObject := PoseHuman;
      PoseHuman.m_PoseBaseObject := PlayObject;
      GotoLable(PlayObject, '@WateMaster', False);
      GotoLable(PoseHuman, '@RevMaster', False);
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'RESPONSEMASTER') = 0 then
  begin
    if CompareText(QuestActionInfo.sParam2, 'OK') = 0 then
    begin
      if (PlayObject.m_PoseBaseObject = PoseHuman) and
        (PoseHuman.m_PoseBaseObject = PlayObject) then
      begin
        if PlayObject.m_boStartMaster and PoseHuman.m_boStartMaster then
        begin
          GotoLable(PlayObject, '@EndMaster', False);
          GotoLable(PoseHuman, '@EndMaster', False);
          PlayObject.m_boStartMaster := False;
          PoseHuman.m_boStartMaster := False;
          if PlayObject.m_sMasterName = '' then
          begin
            PlayObject.m_sMasterName := PoseHuman.m_sCharName;
            PlayObject.m_boMaster := True;
          end;
          PlayObject.m_MasterList.Add(PoseHuman);
          PoseHuman.m_sMasterName := PlayObject.m_sCharName;
          PoseHuman.m_boMaster := False;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
        end;
      end;
    end
    else
    begin
      if PlayObject.m_boStartMaster and PoseHuman.m_boStartMaster then
      begin
        GotoLable(PlayObject, '@EndMasterFail', False);
        GotoLable(PoseHuman, '@EndMasterFail', False);
        PlayObject.m_boStartMaster := False;
        PoseHuman.m_boStartMaster := False;
      end;
    end;
    Exit;
  end;

end;

procedure TNormNpc.ActionOfMessageBox(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, GetLineVariableText(PlayObject, QuestActionInfo.sParam1));
end;

procedure TNormNpc.ActionOfMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sMapName: string;
begin
  if (QuestActionInfo.sParam1 <> '') and (QuestActionInfo.nParam2 > 0) and (QuestActionInfo.nParam3 > 0) then
  begin
    sMapName := QuestActionInfo.sParam1;
    if CompareText(sMapName, 'SELF') = 0 then
    begin
      if PlayObject.m_PEnvir <> nil then
      begin
        sMapName := PlayObject.m_PEnvir.m_sMapFileName;
        //if sMapName = '' then sMapName := PlayObject.m_PEnvir.m_sMapMapingName;
      end;
    end;
    g_sMissionMap := sMapName;
    g_nMissionX := QuestActionInfo.nParam2;
    g_nMissionY := QuestActionInfo.nParam3;
  end
  else
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MISSION);
end;

//MOBFIREBURN MAP X Y TYPE TIME POINT

procedure TNormNpc.ActionOfMobFireBurn(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sMAP: string;
  nX, nY, nType, nTime, nPoint: Integer;
  FireBurnEvent: TFireBurnEvent;
  Envir: TEnvirnoment;
  OldEnvir: TEnvirnoment;
begin
  Exit;

  sMAP := QuestActionInfo.sParam1;
  nX := Str_ToInt(QuestActionInfo.sParam2, -1);
  nY := Str_ToInt(QuestActionInfo.sParam3, -1);
  nType := Str_ToInt(QuestActionInfo.sParam4, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam5, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam6, -1);
  if (sMAP = '') or (nX < 0) or (nY < 0) or (nType < 0) or (nTime < 0) or (nPoint < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MOBFIREBURN);
    Exit;
  end;
  if g_Config.boFireBurnEventOff then
    Exit;
  Envir := g_MapManager.FindMap(sMAP);
  if Envir <> nil then
  begin
    OldEnvir := PlayObject.m_PEnvir;
    PlayObject.m_PEnvir := Envir;
    try
      FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, nType, nTime * 1000, nPoint, 0);
      g_EventManager.AddEvent(FireBurnEvent);
    finally
      PlayObject.m_PEnvir := OldEnvir;
    end;
  end;
  //ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MOBFIREBURN);
end;

procedure TNormNpc.ActionOfMobPlace(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nX, nY, nCount, nRange: Integer);
var
  i, ii, nRace: Integer;
  nRandX, nRandY: Integer;
  Mon: TBaseObject;
  pWayPointInfo: pTWayPointInfo;
  boFind: Boolean;
begin
  nRace := UserEngine.GetMonRace(QuestActionInfo.sParam1);
  for i := 0 to nCount - 1 do
  begin
    if (nRace <> RC_MISSION) and (nRange > 0) then
    begin
      nRandX := Random(nRange * 2 + 1) + (nX - nRange);
      nRandY := Random(nRange * 2 + 1) + (nY - nRange);
    end
    else
    begin
      nRandX := nX;
      nRandY := nY;
    end;
    Mon := UserEngine.RegenMonsterByName(g_sMissionMap, nRandX, nRandY, QuestActionInfo.sParam1);
    if Mon <> nil then
    begin
      Mon.m_boMission := True;
      Mon.m_nMissionX := g_nMissionX;
      Mon.m_nMissionY := g_nMissionY;
{$IF VER_PATHMAP = 1}
      if (Mon.m_btRaceServer = RC_MISSION) and (Mon.m_PEnvir <> nil) then
      begin
        Mon.m_PEnvir.m_mLatestWayPointList.Lock;
        try
          boFind := False;
          for ii := 0 to Mon.m_PEnvir.m_mLatestWayPointList.Count - 1 do
          begin
            pWayPointInfo := Mon.m_PEnvir.m_mLatestWayPointList[ii];
            if (pWayPointInfo.StartPoint.X = Mon.m_nCurrX) and (pWayPointInfo.StartPoint.Y = Mon.m_nCurrY) and
              (pWayPointInfo.EndPoint.X = Mon.m_nMissionX) and (pWayPointInfo.EndPoint.Y = Mon.m_nMissionY) then
            begin
              TMissionMonsterEx(Mon).m_WayPoint := pWayPointInfo.WayPoint;
              TMissionMonsterEx(Mon).m_nMoveStep := 1;
              boFind := True;
              Break;
            end;
          end;
          if not boFind then
          begin
            TMissionMonsterEx(Mon).m_WayPoint := Mon.m_PEnvir.FindPath(Mon.m_nCurrX, Mon.m_nCurrY, Mon.m_nMissionX, Mon.m_nMissionY, 0);
            TMissionMonsterEx(Mon).m_nMoveStep := 1;
            //if TMissionMonsterEx(Mon).m_WayPoint <> nil then
            //  MainOutMessage('TMissionMonsterEx(Mon).m_WayPoint <> nil');
            New(pWayPointInfo);
            pWayPointInfo.StartPoint := Point(Mon.m_nCurrX, Mon.m_nCurrY);
            pWayPointInfo.EndPoint := Point(Mon.m_nMissionX, Mon.m_nMissionY);
            pWayPointInfo.WayPoint := TMissionMonsterEx(Mon).m_WayPoint;
            Mon.m_PEnvir.m_mLatestWayPointList.Add(pWayPointInfo);
          end;
        finally
          Mon.m_PEnvir.m_mLatestWayPointList.UnLock;
        end;
      end;
{$IFEND}
    end
    else
    begin
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MOBPLACE);
      Break;
    end;
  end;
end;

procedure TNormNpc.ActionOfGroupMembersMapMove(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  X, Y: Integer;
  Actor: TPlayObject;
  i: Integer;
  IsOK: Boolean;
  sMAP, sX, sY: string;
begin
  sMAP := QuestActionInfo.sParam1;
  sX := QuestActionInfo.sParam2;
  sY := QuestActionInfo.sParam3;
  if (sMAP = '') or (PlayObject.m_GroupOwner = nil) then
    Exit;

  X := Str_ToInt(sX, -1);
  Y := Str_ToInt(sY, -1);
  if (X = -1) or (Y = -1) then
    IsOK := True
  else
    IsOK := False;
  for i := 0 to PlayObject.m_GroupOwner.m_GroupMembers.Count - 1 do
  begin
    Actor := TPlayObject(PlayObject.m_GroupOwner.m_GroupMembers.Objects[i]);
    Actor.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
    if IsOK then
      Actor.MapRandomMove(sMAP, 0)
    else
      Actor.SpaceMove(sMAP, X, Y, 0);
  end;
end;

procedure TNormNpc.ActionOfRecallGroupMembers(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  X, Y: Integer;
  Actor: TPlayObject;
  i: Integer;
  IsOK: Boolean;
  sMAP, sX, sY: string;
begin
  sMAP := QuestActionInfo.sParam1;
  sX := QuestActionInfo.sParam2;
  sY := QuestActionInfo.sParam3;
  if (sMAP = '') or (PlayObject.m_GroupOwner = nil) then
    Exit;
  X := Str_ToInt(sX, -1);
  Y := Str_ToInt(sY, -1);
  if (X = -1) or (Y = -1) then
    IsOK := True
  else
    IsOK := False;
  for i := 0 to PlayObject.m_GroupOwner.m_GroupMembers.Count - 1 do
  begin
    Actor := TPlayObject(PlayObject.m_GroupOwner.m_GroupMembers.Objects[i]);
    Actor.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
    if IsOK then
      Actor.MapRandomMove(sMAP, 0)
    else
      Actor.SpaceMove(sMAP, X, Y, 0);
  end;
end;

procedure TNormNpc.ActionOfSetRankLevelName(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sRankLevelName: string;
begin
  sRankLevelName := QuestActionInfo.sParam1;
  if sRankLevelName = '' then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETRANKLEVELNAME);
    Exit;
  end;
  PlayObject.m_sRankLevelName := sRankLevelName;
  PlayObject.RefShowName;
end;

procedure TNormNpc.ActionOfSTARTTAKEGOLD(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  BasePoseObject: TBaseObject;
resourcestring
  sPoseNilMsg = '元宝交易双方必须面对面站好';
begin
  BasePoseObject := PlayObject.GetPoseCreate();
  if (BasePoseObject = nil) or (BasePoseObject.GetPoseCreate <> PlayObject) or (BasePoseObject.m_btRaceServer <> RC_PLAYOBJECT) then
  begin
    PlayObject.SysMsg(sPoseNilMsg, c_Red, t_Hint);
    GotoLable(PlayObject, '@dealgoldPost', False);
    Exit;
  end;
  PlayObject.m_DealGoldCreat := TPlayObject(BasePoseObject);
  TPlayObject(BasePoseObject).m_DealGoldCreat := PlayObject;
  PlayObject.m_DealGoldLastTick := GetTickCount();
  TPlayObject(BasePoseObject).m_DealGoldLastTick := GetTickCount();
  GotoLable(PlayObject, '@startdealgold', False);
end;

procedure TNormNpc.ActionOfOffLine(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nTime, nPoint: Integer;
resourcestring
  sOffLineStartMsg = '[提示]：服务器已经为你开启了脱机泡点功能，你现在可以下线了……';
begin
  PlayObject.m_DefMsg := MakeDefaultMsg(SM_SYSMESSAGE, Integer(PlayObject), MakeWord(g_Config.btPurpleMsgFColor, g_Config.btPurpleMsgBColor), 0, 1);
  PlayObject.SendSocket(@PlayObject.m_DefMsg, EncodeString(sOffLineStartMsg));

  nTime := Str_ToInt(QuestActionInfo.sParam1, 5);
  nPoint := Str_ToInt(QuestActionInfo.sParam2, 500);
  // nKickOffLine := Str_ToInt(QuestActionInfo.sParam3, 1440 * 15);
  PlayObject.m_boAutoGetExpInSafeZone := True;
  PlayObject.m_AutoGetExpEnvir := PlayObject.m_PEnvir;
  PlayObject.m_nAutoGetExpTime := nTime * 1000;
  PlayObject.m_nAutoGetExpPoint := nPoint;
  PlayObject.m_boOffLineFlag := True;
  PlayObject.m_boAllowGroup := False;
  PlayObject.m_btHeroRelax := 2;
  //PlayObject.m_dwKickOffLineTick := GetTickCount + LongWord(nKickOffLine * 60 * 1000);
  FrmIDSoc.SendHumanLogOutMsg(PlayObject.m_sUserID, PlayObject.m_nSessionID);
  PlayObject.SendDefMessage(SM_OUTOFCONNECTION, 0, 0, 0, 0, '');
end;

procedure TNormNpc.ActionOfOffLinePlay(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nKickOffLine: Integer;
begin
  nKickOffLine := Str_ToInt(QuestActionInfo.sParam1, 1);

  PlayObject.m_DefMsg := MakeDefaultMsg(SM_SYSMESSAGE, Integer(PlayObject), MakeWord(g_Config.btPurpleMsgFColor, g_Config.btPurpleMsgBColor), 0, 1);
  PlayObject.SendSocket(@PlayObject.m_DefMsg, EncodeString(Format('已为你开启了%d分钟的离线打怪功能，你现在可以下线了……', [nKickOffLine])));

  PlayObject.m_boOffLineFlag := True;
  PlayObject.m_boOffLinePlay := True;
  PlayObject.m_dwKickOffLineTick := GetTickCount + LongWord(nKickOffLine * 60 * 1000);

  PlayObject.m_boAllowGroup := False;
  PlayObject.m_btAttatckMode := HAM_PEACE;

  FrmIDSoc.SendHumanLogOutMsg(PlayObject.m_sUserID, PlayObject.m_nSessionID);
  PlayObject.SendDefMessage(SM_OUTOFCONNECTION, 0, 0, 0, 0, '');
end;

procedure TNormNpc.ActionOfSetOffLine(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  if QuestActionInfo.sParam1 = 'ON' then
    PlayObject.m_boSetOffLine := True;
  if QuestActionInfo.sParam1 = 'OFF' then
    PlayObject.m_boSetOffLine := False;
end;

procedure TNormNpc.ActionOfSetScriptFlag(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  boFlag: Boolean;
  nWhere: Integer;
begin
  nWhere := Str_ToInt(QuestActionInfo.sParam1, -1);
  boFlag := Str_ToInt(QuestActionInfo.sParam2, -1) = 1;
  case nWhere of
    0: PlayObject.m_boSendMsgFlag := boFlag;
    1: PlayObject.m_boChangeItemNameFlag := boFlag;
  else
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETSCRIPTFLAG);
  end;
end;

procedure TNormNpc.ActionOfHeroSkillLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  HeroObject: TBaseObject;
  i: Integer;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  nLevel: Integer;
  cMethod: Char;
begin
  HeroObject := PlayObject.GetHeroObjectA;
  if HeroObject = nil then
    Exit;
  nLevel := Str_ToInt(QuestActionInfo.sParam3, -1);
  if nLevel < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HEROSKILLLEVEL);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam2[1];
  Magic := UserEngine.FindMagic(QuestActionInfo.sParam1);
  if Magic <> nil then
  begin
    for i := 0 to HeroObject.m_MagicList.Count - 1 do
    begin
      UserMagic := HeroObject.m_MagicList.Items[i];
      if UserMagic.MagicInfo = Magic then
      begin
        case cMethod of
          '=':
            begin
              if nLevel >= 0 then
              begin
                nLevel := _MIN(15, nLevel);
                UserMagic.btLevel := nLevel;
              end;
            end;
          '-':
            begin
              if UserMagic.btLevel >= nLevel then
                Dec(UserMagic.btLevel, nLevel)
              else
                UserMagic.btLevel := 0;
            end;
          '+':
            begin
              if UserMagic.btLevel + nLevel < 15 then
                Inc(UserMagic.btLevel, nLevel)
              else
                UserMagic.btLevel := 15;
            end;
        end;
        HeroObject.SendDelayMsg(HeroObject, RM_MAGIC_LVEXP, Magic.btClass, UserMagic.MagicInfo.wMagicId, UserMagic.btLevel, UserMagic.nTranPoint, '', 100);
        Break;
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfSkillLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  nLevel: Integer;
  cMethod: Char;
begin
  nLevel := Str_ToInt(QuestActionInfo.sParam3, -1);
  if nLevel < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SKILLLEVEL);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam2[1];
  Magic := UserEngine.FindMagic(QuestActionInfo.sParam1);
  if Magic <> nil then
  begin
    for i := 0 to PlayObject.m_MagicList.Count - 1 do
    begin
      UserMagic := PlayObject.m_MagicList.Items[i];
      if UserMagic.MagicInfo = Magic then
      begin
        case cMethod of
          '=':
            begin
              if nLevel >= 0 then
              begin
                nLevel := _MIN(15, nLevel);
                UserMagic.btLevel := nLevel;
              end;
            end;
          '-':
            begin
              if UserMagic.btLevel >= nLevel then
                Dec(UserMagic.btLevel, nLevel)
              else
                UserMagic.btLevel := 0;
            end;
          '+':
            begin
              if UserMagic.btLevel + nLevel < 15 then
                Inc(UserMagic.btLevel, nLevel)
              else
                UserMagic.btLevel := 15;
            end;
        end;
        PlayObject.SendDelayMsg(PlayObject, RM_MAGIC_LVEXP, Magic.btClass, UserMagic.MagicInfo.wMagicId, UserMagic.btLevel, UserMagic.nTranPoint, '', 100);
        Break;
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfTakeCastleGold(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nGold: Integer;
begin
  nGold := Str_ToInt(QuestActionInfo.sParam1, -1);
  if (nGold < 0) or (m_Castle = nil) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_TAKECASTLEGOLD);
    Exit;
  end;

  if nGold <= TUserCastle(m_Castle).m_nTotalGold then
  begin
    Dec(TUserCastle(m_Castle).m_nTotalGold, nGold);
  end
  else
  begin
    TUserCastle(m_Castle).m_nTotalGold := 0;
  end;
end;

procedure TNormNpc.ActionOfUnMarry(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  LoadList: TStringList;
  sUnMarryFileName: string;
begin
  if PlayObject.m_sDearName = '' then
  begin
    GotoLable(PlayObject, '@ExeMarryFail', False);
    Exit;
  end;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate);
  if PoseHuman = nil then
  begin
    GotoLable(PlayObject, '@UnMarryCheckDir', False);
  end;
  if PoseHuman <> nil then
  begin
    if QuestActionInfo.sParam1 = '' then
    begin
      if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then
      begin
        GotoLable(PlayObject, '@UnMarryTypeErr', False);
        Exit;
      end;
      if PoseHuman.GetPoseCreate = PlayObject then
      begin
        if (PlayObject.m_sDearName = PoseHuman.m_sCharName)
          {and (PosHum.AddInfo.sDearName = Hum.sName)}then
        begin
          GotoLable(PlayObject, '@StartUnMarry', False);
          GotoLable(PoseHuman, '@StartUnMarry', False);
          Exit;
        end;
      end;
    end;
  end;
  if (CompareText(QuestActionInfo.sParam1, 'REQUESTUNMARRY' {sREQUESTUNMARRY}) =
    0) then
  begin
    if (QuestActionInfo.sParam2 = '') then
    begin
      if PoseHuman <> nil then
      begin
        PlayObject.m_boStartUnMarry := True;
        if PlayObject.m_boStartUnMarry and PoseHuman.m_boStartUnMarry then
        begin
          UserEngine.SendBroadCastMsg('[' + m_sCharName + ']: ' + '我宣布'
            {sUnMarryMsg8}+ PoseHuman.m_sCharName + ' ' + '与' {sMarryMsg0} +
            PlayObject.m_sCharName + ' ' + ' ' + '正式脱离夫妻关系'
            {sUnMarryMsg9}, t_Say);
          PlayObject.m_sDearName := '';
          PoseHuman.m_sDearName := '';
          Inc(PlayObject.m_btMarryCount);
          Inc(PoseHuman.m_btMarryCount);
          PlayObject.m_boStartUnMarry := False;
          PoseHuman.m_boStartUnMarry := False;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
          GotoLable(PlayObject, '@UnMarryEnd', False);
          GotoLable(PoseHuman, '@UnMarryEnd', False);
        end
        else
          GotoLable(PlayObject, '@WateUnMarry', False);
      end;
      Exit;
    end
    else
    begin
      //强行离婚
      if (CompareText(QuestActionInfo.sParam2, 'FORCE') = 0) then
      begin
        UserEngine.SendBroadCastMsg('[' + m_sCharName + ']: ' + '我宣布'
          {sUnMarryMsg8}+ PlayObject.m_sCharName + ' ' + '与' {sMarryMsg0} +
          PlayObject.m_sDearName + ' ' + ' ' + '已经正式脱离夫妻关系'
          {sUnMarryMsg9}, t_Say);
        PoseHuman := UserEngine.GetPlayObject(PlayObject.m_sDearName);
        if PoseHuman <> nil then
        begin
          PoseHuman.m_sDearName := '';
          Inc(PoseHuman.m_btMarryCount);
          PoseHuman.RefShowName;
        end
        else
        begin
          sUnMarryFileName := g_Config.sEnvirDir + 'UnMarry.txt';
          LoadList := TStringList.Create;
          if FileExists(sUnMarryFileName) then
          begin
            LoadList.LoadFromFile(sUnMarryFileName);
          end;
          LoadList.Add(PlayObject.m_sDearName);
          LoadList.SaveToFile(sUnMarryFileName);
          LoadList.Free;
        end;
        PlayObject.m_sDearName := '';
        Inc(PlayObject.m_btMarryCount);
        GotoLable(PlayObject, '@UnMarryEnd', False);
        PlayObject.RefShowName;
      end;
      Exit;
    end;
  end;
end;

procedure TNormNpc.ClearScript;
var
  III, IIII: Integer;
  i, ii: Integer;
  Script: pTScript;
  SayingRecord: pTSayingRecord;
  SayingProcedure: pTSayingProcedure;
begin
  for i := 0 to m_ScriptList.Count - 1 do
  begin
    Script := m_ScriptList.Items[i];
    for ii := 0 to Script.RecordList.Count - 1 do
    begin
      SayingRecord := Script.RecordList.Items[ii];
      for III := 0 to SayingRecord.ProcedureList.Count - 1 do
      begin
        SayingProcedure := SayingRecord.ProcedureList.Items[III];
        for IIII := 0 to SayingProcedure.ConditionList.Count - 1 do
          Dispose(pTQuestConditionInfo(SayingProcedure.ConditionList.Items[IIII]));
        for IIII := 0 to SayingProcedure.ActionList.Count - 1 do
          Dispose(pTQuestActionInfo(SayingProcedure.ActionList.Items[IIII]));
        for IIII := 0 to SayingProcedure.ElseActionList.Count - 1 do
          Dispose(pTQuestActionInfo(SayingProcedure.ElseActionList.Items[IIII]));
        SayingProcedure.ConditionList.Free;
        SayingProcedure.ActionList.Free;
        SayingProcedure.ElseActionList.Free;
        Dispose(SayingProcedure);
      end;
      SayingRecord.ProcedureList.Free;
      Dispose(SayingRecord);
    end;
    Script.RecordList.Free;
    Dispose(Script);
  end;
  m_ScriptList.Clear;
end;

procedure TNormNpc.Click(PlayObject: TPlayObject);
begin
  m_OprCount := 0;
  PlayObject.m_nScriptGotoCount := 0;
  PlayObject.m_sScriptGoBackLable := '';
  PlayObject.m_sScriptCurrLable := '';
  GotoLable(PlayObject, '@main', False);
end;

function TNormNpc.ConditionOfCheckAccountIPList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sListFileName, sCharName: string;
  sCharAccount: string;
  sCharIPaddr: string;
  sLine: string;
  sName: string;
  sIPaddr: string;
begin
  Result := False;
  sCharName := PlayObject.m_sCharName;
  sCharAccount := PlayObject.m_sUserID;
  sCharIPaddr := PlayObject.m_sIPaddr;
  LoadList := TStringList.Create;
  sListFileName := g_Config.sEnvirDir + QuestConditionInfo.sParam1;
  if not FileExists(sListFileName) then
    sListFileName := g_Config.sEnvirDir + m_sPath + QuestConditionInfo.sParam1;

  if FileExists(sListFileName) then
  begin
    LoadList.LoadFromFile(sListFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      sLine := LoadList.Strings[i];
      if sLine[1] = ';' then
        Continue;
      sIPaddr := GetValidStr3(sLine, sName, [' ', '/', #9]);
      sIPaddr := Trim(sIPaddr);
      if (sName = sCharAccount) and (sIPaddr = sCharIPaddr) then
      begin
        Result := True;
        Break;
      end;
    end;
  end
  else
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKACCOUNTIPLIST);
  LoadList.Free
end;

function TNormNpc.ConditionOfCheckBagSize(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nSize: Integer;
begin
  Result := False;
  nSize := Str_ToInt(QuestConditionInfo.sParam1, 0);
  if (nSize <= 0) or (nSize > PlayObject.GetMaxBagItem) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKBAGSIZE);
    Exit;
  end;
  if PlayObject.m_ItemList.Count + nSize <= PlayObject.GetMaxBagItem then
    Result := True;
end;

function TNormNpc.ConditionOfCheckBonusPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nTotlePoint, nPoint: Integer;
  cMethod: Char;
begin
  Result := False;
  nTotlePoint := PlayObject.m_BonusAbil.DC +
    PlayObject.m_BonusAbil.MC +
    PlayObject.m_BonusAbil.SC +
    PlayObject.m_BonusAbil.AC +
    PlayObject.m_BonusAbil.MAC +
    PlayObject.m_BonusAbil.HP +
    PlayObject.m_BonusAbil.MP +
    PlayObject.m_BonusAbil.HIT +
    PlayObject.m_BonusAbil.Speed +
    PlayObject.m_BonusAbil.X2;

  nTotlePoint := nTotlePoint + PlayObject.m_nBonusPoint;
  cMethod := QuestConditionInfo.sParam1[1];
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if (nPoint < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKBONUSPOINT);
    Exit;
  end;
  case cMethod of
    '=': if nTotlePoint = nPoint then
        Result := True;
    '>': if nTotlePoint > nPoint then
        Result := True;
    '<': if nTotlePoint < nPoint then
        Result := True;
  else if nTotlePoint >= nPoint then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckHP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;

  function CheckHighHP(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=':
        begin
          if PlayObject.m_WAbil.MaxHP = nMax then
          begin
            Result := True;
          end;
        end;
      '>':
        begin
          if PlayObject.m_WAbil.MaxHP > nMax then
          begin
            Result := True;
          end;
        end;
      '<':
        begin
          if PlayObject.m_WAbil.MaxHP < nMax then
          begin
            Result := True;
          end;
        end;
    else
      begin
        if PlayObject.m_WAbil.MaxHP >= nMax then
        begin
          Result := True;
        end;
      end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam3[1];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if not (nMIN in [0..100]) or (nMax < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKHP);
    Exit;
  end;
  case cMethodMin of
    '=':
      begin
        if Round(PlayObject.m_WAbil.HP / PlayObject.m_WAbil.MaxHP * 100) = nMIN then
        begin
          Result := CheckHighHP;
        end;
      end;
    '>':
      begin
        if Round(PlayObject.m_WAbil.HP / PlayObject.m_WAbil.MaxHP * 100) > nMIN then
        begin
          Result := CheckHighHP;
        end;
      end;
    '<':
      begin
        if Round(PlayObject.m_WAbil.HP / PlayObject.m_WAbil.MaxHP * 100) < nMIN then
        begin
          Result := CheckHighHP;
        end;
      end;
  else
    begin
      if Round(PlayObject.m_WAbil.HP / PlayObject.m_WAbil.MaxHP * 100) >= nMIN then
      begin
        Result := CheckHighHP;
      end;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckMP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;

  function CheckHighMP(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=':
        begin
          if PlayObject.m_WAbil.MaxMP = nMax then
          begin
            Result := True;
          end;
        end;
      '>':
        begin
          if PlayObject.m_WAbil.MaxMP > nMax then
          begin
            Result := True;
          end;
        end;
      '<':
        begin
          if PlayObject.m_WAbil.MaxMP < nMax then
          begin
            Result := True;
          end;
        end;
    else
      begin
        if PlayObject.m_WAbil.MaxMP >= nMax then
        begin
          Result := True;
        end;
      end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam3[1];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if not (nMIN in [0..100]) or (nMax < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMP);
    Exit;
  end;

  case cMethodMin of
    '=':
      begin
        if Round(PlayObject.m_WAbil.MP / m_WAbil.MaxMP * 100) = nMIN then
        begin
          Result := CheckHighMP;
        end;
      end;
    '>':
      begin
        if Round(PlayObject.m_WAbil.MP / m_WAbil.MaxMP * 100) > nMIN then
        begin
          Result := CheckHighMP;
        end;
      end;
    '<':
      begin
        if Round(PlayObject.m_WAbil.MP / m_WAbil.MaxMP * 100) < nMIN then
        begin
          Result := CheckHighMP;
        end;
      end;
  else
    begin
      if Round(PlayObject.m_WAbil.MP / m_WAbil.MaxMP * 100) >= nMIN then
      begin
        Result := CheckHighMP;
      end;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckDC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;

  function CheckHighDC(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=':
        begin
          if HiWord(PlayObject.m_WAbil.DC) = nMax then
          begin
            Result := True;
          end;
        end;
      '>':
        begin
          if HiWord(PlayObject.m_WAbil.DC) > nMax then
          begin
            Result := True;
          end;
        end;
      '<':
        begin
          if HiWord(PlayObject.m_WAbil.DC) < nMax then
          begin
            Result := True;
          end;
        end;
    else
      begin
        if HiWord(PlayObject.m_WAbil.DC) >= nMax then
        begin
          Result := True;
        end;
      end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam3[1];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (nMIN < 0) or (nMax < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKDC);
    Exit;
  end;

  case cMethodMin of
    '=':
      begin
        if (LoWord(PlayObject.m_WAbil.DC) = nMIN) then
        begin
          Result := CheckHighDC;
        end;
      end;
    '>':
      begin
        if (LoWord(PlayObject.m_WAbil.DC) > nMIN) then
        begin
          Result := CheckHighDC;
        end;
      end;
    '<':
      begin
        if (LoWord(PlayObject.m_WAbil.DC) < nMIN) then
        begin
          Result := CheckHighDC;
        end;
      end;
  else
    begin
      if (LoWord(PlayObject.m_WAbil.DC) >= nMIN) then
      begin
        Result := CheckHighDC;
      end;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckMC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;

  function CheckHighMC(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=':
        begin
          if HiWord(PlayObject.m_WAbil.MC) = nMax then
          begin
            Result := True;
          end;
        end;
      '>':
        begin
          if HiWord(PlayObject.m_WAbil.MC) > nMax then
          begin
            Result := True;
          end;
        end;
      '<':
        begin
          if HiWord(PlayObject.m_WAbil.MC) < nMax then
          begin
            Result := True;
          end;
        end;
    else
      begin
        if HiWord(PlayObject.m_WAbil.MC) >= nMax then
        begin
          Result := True;
        end;
      end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam3[1];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (nMIN < 0) or (nMax < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMC);
    Exit;
  end;

  case cMethodMin of
    '=':
      begin
        if (LoWord(PlayObject.m_WAbil.MC) = nMIN) then
        begin
          Result := CheckHighMC;
        end;
      end;
    '>':
      begin
        if (LoWord(PlayObject.m_WAbil.MC) > nMIN) then
        begin
          Result := CheckHighMC;
        end;
      end;
    '<':
      begin
        if (LoWord(PlayObject.m_WAbil.MC) < nMIN) then
        begin
          Result := CheckHighMC;
        end;
      end;
  else
    begin
      if (LoWord(PlayObject.m_WAbil.MC) >= nMIN) then
      begin
        Result := CheckHighMC;
      end;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckSC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;

  function CheckHighSC(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=':
        begin
          if HiWord(PlayObject.m_WAbil.SC) = nMax then
          begin
            Result := True;
          end;
        end;
      '>':
        begin
          if HiWord(PlayObject.m_WAbil.SC) > nMax then
          begin
            Result := True;
          end;
        end;
      '<':
        begin
          if HiWord(PlayObject.m_WAbil.SC) < nMax then
          begin
            Result := True;
          end;
        end;
    else
      begin
        if HiWord(PlayObject.m_WAbil.SC) >= nMax then
        begin
          Result := True;
        end;
      end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam3[1];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (nMIN < 0) or (nMax < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSC);
    Exit;
  end;

  case cMethodMin of
    '=':
      begin
        if (LoWord(PlayObject.m_WAbil.SC) = nMIN) then
        begin
          Result := CheckHighSC;
        end;
      end;
    '>':
      begin
        if (LoWord(PlayObject.m_WAbil.SC) > nMIN) then
        begin
          Result := CheckHighSC;
        end;
      end;
    '<':
      begin
        if (LoWord(PlayObject.m_WAbil.SC) < nMIN) then
        begin
          Result := CheckHighSC;
        end;
      end;
  else
    begin
      if (LoWord(PlayObject.m_WAbil.SC) >= nMIN) then
      begin
        Result := CheckHighSC;
      end;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckExp(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  dwExp: LongWord;
begin
  Result := False;
  dwExp := Str_ToInt(QuestConditionInfo.sParam2, 0);
  if dwExp = 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKEXP);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_Abil.Exp = dwExp then
        Result := True;
    '>': if PlayObject.m_Abil.Exp > dwExp then
        Result := True;
    '<': if PlayObject.m_Abil.Exp < dwExp then
        Result := True;
  else if PlayObject.m_Abil.Exp >= dwExp then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckFlourishPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGuild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo,
      sSC_CHECKFLOURISHPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    Exit;
  end;
  Guild := TGuild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nFlourishing = nPoint then
        Result := True;
    '>': if Guild.nFlourishing > nPoint then
        Result := True;
    '<': if Guild.nFlourishing < nPoint then
        Result := True;
  else if Guild.nFlourishing >= nPoint then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckChiefItemCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nCount: Integer;
  Guild: TGuild;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKFLOURISHPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    Exit;
  end;
  Guild := TGuild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nChiefItemCount = nCount then
        Result := True;
    '>': if Guild.nChiefItemCount > nCount then
        Result := True;
    '<': if Guild.nChiefItemCount < nCount then
        Result := True;
  else if Guild.nChiefItemCount >= nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGuildAuraePoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGuild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKAURAEPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    Exit;
  end;
  Guild := TGuild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nAurae = nPoint then
        Result := True;
    '>': if Guild.nAurae > nPoint then
        Result := True;
    '<': if Guild.nAurae < nPoint then
        Result := True;
  else if Guild.nAurae >= nPoint then
    Result := True;
  end;

end;

function TNormNpc.ConditionOfCheckGuildBuildPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGuild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKBUILDPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    Exit;
  end;
  Guild := TGuild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nBuildPoint = nPoint then
        Result := True;
    '>': if Guild.nBuildPoint > nPoint then
        Result := True;
    '<': if Guild.nBuildPoint < nPoint then
        Result := True;
  else if Guild.nBuildPoint >= nPoint then
    Result := True;
  end;

end;

function TNormNpc.ConditionOfCheckStabilityPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGuild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo,
      sSC_CHECKSTABILITYPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    Exit;
  end;
  Guild := TGuild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nStability = nPoint then
        Result := True;
    '>': if Guild.nStability > nPoint then
        Result := True;
    '<': if Guild.nStability < nPoint then
        Result := True;
  else if Guild.nStability >= nPoint then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGameDiamond(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGameDiamond, nCount: Integer;
  sGameDiamond, sCount: string;
begin
  Result := False;
  sCount := QuestConditionInfo.sParam3;
  nCount := Str_ToInt(sCount, 1);
  sGameDiamond := QuestConditionInfo.sParam2;
  nGameDiamond := Str_ToInt(sGameDiamond, -1);
  if nGameDiamond < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGAMEDIAMOND);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nGameDiamond = nGameDiamond * nCount then
        Result := True;
    '>': if PlayObject.m_nGameDiamond > nGameDiamond * nCount then
        Result := True;
    '<': if PlayObject.m_nGameDiamond < nGameDiamond * nCount then
        Result := True;
  else if PlayObject.m_nGameDiamond >= nGameDiamond * nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGameGird(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGameGird, nCount: Integer;
  sGameGird, sCount: string;
begin
  Result := False;
  sCount := QuestConditionInfo.sParam3;
  nCount := Str_ToInt(sCount, 1);
  sGameGird := QuestConditionInfo.sParam2;
  nGameGird := Str_ToInt(sGameGird, -1);
  if nGameGird < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGAMEGIRD);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nGameGird = nGameGird * nCount then
        Result := True;
    '>': if PlayObject.m_nGameGird > nGameGird * nCount then
        Result := True;
    '<': if PlayObject.m_nGameGird < nGameGird * nCount then
        Result := True;
  else if PlayObject.m_nGameGird >= nGameGird * nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGameGold(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGameGold, nCount: Integer;
  sGameGold, sCount: string;
begin
  Result := False;
  sCount := QuestConditionInfo.sParam3;
  nCount := Str_ToInt(sCount, 1);
  sGameGold := QuestConditionInfo.sParam2;
  nGameGold := Str_ToInt(sGameGold, -1);
  if (nGameGold < 0) or (nCount < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGAMEGOLD);
    Exit;
  end;

  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nGameGold = nGameGold * nCount then
        Result := True;
    '>': if PlayObject.m_nGameGold > nGameGold * nCount then
        Result := True;
    '<': if PlayObject.m_nGameGold < nGameGold * nCount then
        Result := True;
  else if PlayObject.m_nGameGold >= nGameGold * nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckNimbus(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGameGold, nCount: Integer;
  sGameGold, sCount: string;
begin
  Result := False;
  sCount := QuestConditionInfo.sParam3;
  nCount := Str_ToInt(sCount, 1);
  sGameGold := QuestConditionInfo.sParam2;
  nGameGold := Str_ToInt(sGameGold, -1);
  if (nGameGold < 0) or (nCount < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNIMBUS);
    Exit;
  end;

  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_dwGatherNimbus = nGameGold * nCount then
        Result := True;
    '>': if PlayObject.m_dwGatherNimbus > nGameGold * nCount then
        Result := True;
    '<': if PlayObject.m_dwGatherNimbus < nGameGold * nCount then
        Result := True;
  else if PlayObject.m_dwGatherNimbus >= nGameGold * nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGamePoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGamePoint: Integer;
begin
  Result := False;
  nGamePoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nGamePoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGAMEPOINT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nGamePoint = nGamePoint then
        Result := True;
    '>': if PlayObject.m_nGamePoint > nGamePoint then
        Result := True;
    '<': if PlayObject.m_nGamePoint < nGamePoint then
        Result := True;
  else if PlayObject.m_nGamePoint >= nGamePoint then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckCurrentDate(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  sDateTime, sYear, sMonth, sDay: string;
  wYear, wMonth, wDay: Word;
  nCount: Integer;
begin
  Result := False;
  sDateTime := QuestConditionInfo.sParam2;
  sDateTime := GetValidStr3(sDateTime, sYear, ['-']);
  sDateTime := GetValidStr3(sDateTime, sMonth, ['-']);
  sDateTime := GetValidStr3(sDateTime, sDay, ['-']);
  wYear := Str_ToInt(sYear, -1);
  wMonth := Str_ToInt(sMonth, -1);
  wDay := Str_ToInt(sDay, -1);
  if (wYear < 0) or not (wMonth in [1..12]) or not (wDay in [1..31]) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCURRENTDATE);
    Exit;
  end;
  nCount := GetDayCount(Now, EncodeDate(wYear, wMonth, wDay));
  PlayObject.m_nMval[0] := nCount;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nCount = 0 then
        Result := True;
    '>': if nCount > 0 then
        Result := True;
    '<': if nCount < 0 then
        Result := True;
  else if nCount >= 0 then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGroupCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nCount, nValNo: Integer;
begin
  Result := False;
  if PlayObject.m_GroupOwner = nil then
    Exit;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGROUPCOUNT);
    Exit;
  end;
  nValNo := GetValNameNo(QuestConditionInfo.sParam3);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_GroupOwner.m_GroupMembers.Count = nCount then
        Result := True;
    '>': if PlayObject.m_GroupOwner.m_GroupMembers.Count > nCount then
        Result := True;
    '<': if PlayObject.m_GroupOwner.m_GroupMembers.Count < nCount then
        Result := True;
  else if PlayObject.m_GroupOwner.m_GroupMembers.Count >= nCount then
    Result := True;
  end;
  if nValNo >= 0 then
  begin
    case nValNo of
      0..9: PlayObject.m_nVal[nValNo] := PlayObject.m_GroupOwner.m_GroupMembers.Count;
      100..199: g_Config.GlobalVal[nValNo - 100] := PlayObject.m_GroupOwner.m_GroupMembers.Count;
      200..299: PlayObject.m_DyVal[nValNo - 200] := PlayObject.m_GroupOwner.m_GroupMembers.Count;
      300..399: PlayObject.m_nMval[nValNo - 300] := PlayObject.m_GroupOwner.m_GroupMembers.Count;
      400..499: g_Config.GlobaDyMval[nValNo - 400] := PlayObject.m_GroupOwner.m_GroupMembers.Count;
      700..799: g_Config.HGlobalVal[nValNo - 700] := PlayObject.m_GroupOwner.m_GroupMembers.Count;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckHaveGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := PlayObject.m_MyGuild <> nil;
end;

function TNormNpc.ConditionOfCheckInMapRange(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  sMapName: string;
  nX, nY, nRange: Integer;
begin
  Result := False;
  sMapName := QuestConditionInfo.sParam1;
  nX := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nY := Str_ToInt(QuestConditionInfo.sParam3, -1);
  nRange := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (sMapName = '') or (nX < 0) or (nY < 0) or (nRange < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKINMAPRANGE);
    Exit;
  end;
  if CompareText(PlayObject.m_sMapName, sMapName) <> 0 then
    Exit;
  if (abs(PlayObject.m_nCurrX - nX) <= nRange) and (abs(PlayObject.m_nCurrY - nY) <= nRange) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckIsAttackGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISATTACKGUILD);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
    Exit;
  Result := TUserCastle(m_Castle).IsAttackGuild(TGuild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckCastleChageDay(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nDay: Integer;
  cMethod: Char;
  nChangeDay: Integer;
begin
  Result := False;
  nDay := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if (nDay < 0) or (m_Castle = nil) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CASTLECHANGEDAY);
    Exit;
  end;
  nChangeDay := GetDayCount(Now, TUserCastle(m_Castle).m_ChangeDate);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nChangeDay = nDay then
        Result := True;
    '>': if nChangeDay > nDay then
        Result := True;
    '<': if nChangeDay < nDay then
        Result := True;
  else if nChangeDay >= nDay then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckCastleWarDay(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nDay: Integer;
  cMethod: Char;
  nWarDay: Integer;
begin
  Result := False;
  nDay := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if (nDay < 0) or (m_Castle = nil) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CASTLEWARDAY);
    Exit;
  end;
  nWarDay := GetDayCount(Now, TUserCastle(m_Castle).m_WarDate);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nWarDay = nDay then
        Result := True;
    '>': if nWarDay > nDay then
        Result := True;
    '<': if nWarDay < nDay then
        Result := True;
  else if nWarDay >= nDay then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckCastleDoorStatus(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nDay: Integer;
  nDoorStatus: Integer;
  CastleDoor: TCastleDoor;
begin
  Result := False;
  nDay := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nDoorStatus := -1;
  if CompareText(QuestConditionInfo.sParam1, '损坏') = 0 then
    nDoorStatus := 0;
  if CompareText(QuestConditionInfo.sParam1, '开启') = 0 then
    nDoorStatus := 1;
  if CompareText(QuestConditionInfo.sParam1, '关闭') = 0 then
    nDoorStatus := 2;

  if (nDay < 0) or (m_Castle = nil) or (nDoorStatus < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCASTLEDOOR);
    Exit;
  end;
  CastleDoor := TCastleDoor(TUserCastle(m_Castle).m_MainDoor.BaseObject);

  case nDoorStatus of
    0: if CastleDoor.m_boDeath then
        Result := True;
    1: if CastleDoor.m_boOpened then
        Result := True;
    2: if not CastleDoor.m_boOpened then
        Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckIsAttackAllyGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISATTACKALLYGUILD);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
    Exit;
  Result := TUserCastle(m_Castle).IsAttackAllyGuild(TGuild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckIsDefenseAllyGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISDEFENSEALLYGUILD);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
    Exit;
  Result := TUserCastle(m_Castle).IsDefenseAllyGuild(TGuild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckIsDefenseGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISDEFENSEGUILD);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
    Exit;
  Result := TUserCastle(m_Castle).IsDefenseGuild(TGuild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckIsCastleaGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if g_CastleManager.IsCastleMember(PlayObject) <> nil then
    Result := True;
end;

function TNormNpc.ConditionOfCheckIsCastleMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if PlayObject.IsGuildMaster and (g_CastleManager.IsCastleMember(PlayObject) <> nil) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckIsGuildMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := PlayObject.IsGuildMaster;
end;

function TNormNpc.ConditionOfCheckIsMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if (PlayObject.m_sMasterName <> '') and (PlayObject.m_boMaster) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckListCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := True;
end;

function TNormNpc.ConditionOfCheckItemAddValue(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nWhere, nAVWhere: Integer;
  nAddAllValue, nAddValue: Integer;
  UserItem: pTUserItem;
  cMethod: Char;
begin
  Result := False;
  nWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  nAVWhere := Str_ToInt(QuestConditionInfo.sParam2, -1);
  cMethod := QuestConditionInfo.sParam3[1];
  nAddValue := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if not (nWhere in [Low(THumanUseItems)..High(THumanUseItems)]) or (nAddValue < 0) or not (nAVWhere in [0..30]) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKITEMADDVALUE);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  if (UserItem = nil) or (UserItem.wIndex <= 0) then
  begin
    PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, '对不起，您对应的装备位置没有带好装备！');
    Exit;
  end;

  if nAVWhere > 13 then
  begin
    if nAVWhere = 14 then
    begin
      nAddAllValue := UserItem.Dura div 1000;
    end
    else if nAVWhere = 15 then
    begin
      nAddAllValue := UserItem.DuraMax div 1000;
    end
    else if nAVWhere = 16 then
    begin
      nAddAllValue := UserItem.btValue[14];
    end
    else if nAVWhere = 17 then
    begin
      nAddAllValue := UserItem.btValue[15] div 16;
    end
    else if nAVWhere = 18 then
    begin
      nAddAllValue := UserItem.btValue[15] mod 16;
    end
    else if nAVWhere = 19 then
    begin
      nAddAllValue := UserItem.btValue[16] div 16;
    end
    else if nAVWhere = 20 then
    begin
      nAddAllValue := UserItem.btValue[16] mod 16;
    end
    else if nAVWhere = 21 then
    begin
      nAddAllValue := UserItem.btValue[17] div 16;
    end
    else if nAVWhere = 22 then
    begin
      nAddAllValue := UserItem.btValue[17] mod 16;
    end
    else
    begin
      nAddAllValue := UserItem.btValue[nAVWhere - 5];
    end;
  end
  else
    nAddAllValue := UserItem.btValue[nAVWhere];

  case cMethod of
    '=': if nAddAllValue = nAddValue then
        Result := True;
    '>': if nAddAllValue > nAddValue then
        Result := True;
    '<': if nAddAllValue < nAddValue then
        Result := True;
  else if nAddAllValue >= nAddValue then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckDlgItemType(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i, nStdMode: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  nStdMode := -1;
  if (PlayObject.m_nDlgItemIndex > 0) then
  begin
    for i := 0 to PlayObject.m_ItemList.Count - 1 do
    begin
      UserItem := PlayObject.m_ItemList.Items[i];
      if UserItem.MakeIndex = PlayObject.m_nDlgItemIndex then
      begin
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if StdItem <> nil then
        begin
          if StdItem.StdMode in [5..7, 10..13, 15..30, 51, 61] then
            nStdMode := StdItem.StdMode;
        end;
        Break;
      end;
    end;
  end;
  if nStdMode < 0 then
    Exit;
  if QuestConditionInfo.sParam1 = 'DRESS' then
  begin
    if nStdMode in [10, 11] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'WEAPON' then
  begin
    if nStdMode in [5, 6] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'MEDAL' then
  begin
    if nStdMode in [30] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'NECKLACE' then
  begin
    if nStdMode in [19, 20, 21] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'HELMET' then
  begin
    if nStdMode in [15] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'HELMETEX' then
  begin
    if nStdMode in [16] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'ARMRING' then
  begin
    if nStdMode in [24, 26] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'RING' then
  begin
    if nStdMode in [22, 23] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'BOOTS' then
  begin
    if nStdMode in [28] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'BELT' then
  begin
    if nStdMode in [27] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'CHARM' then
  begin
    if nStdMode in [7, 29] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'BUJUK' then
  begin
    if nStdMode in [25, 51, 61] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'DRUM' then
  begin
    if nStdMode in [17] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'HORSE' then
  begin
    if nStdMode in [18] then
      Result := True;
  end
  else if QuestConditionInfo.sParam1 = 'FASHION' then
  begin
    if nStdMode in [12, 13] then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckDlgItemName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  if (PlayObject.m_nDlgItemIndex = 0) then
    Exit;
  for i := 0 to PlayObject.m_ItemList.Count - 1 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem.MakeIndex = PlayObject.m_nDlgItemIndex then
    begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then
      begin
        //PlayObject.SysMsg(QuestConditionInfo.sParam1+ ' ' + StdItem.Name, c_Green, t_Hint);
        if CompareText(QuestConditionInfo.sParam1, StdItem.Name) = 0 then
          Result := True;
      end;
      Break;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckPosDlgItemName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  if (PlayObject.m_nDlgItemIndex = 0) then
    Exit;
  for i := 0 to PlayObject.m_ItemList.Count - 1 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem.MakeIndex = PlayObject.m_nDlgItemIndex then
    begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then
      begin
        if AnsiPos(QuestConditionInfo.sParam1, StdItem.Name) > 0 then
          Result := True;
      end;
      Break;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckDlgItemAddValue(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  UserItem: pTUserItem;
  nAVWhere, nAddValue, nAddAllValue: Integer;
  cMethod: Char;
begin
  Result := False;
  nAVWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  nAddValue := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if (nAddValue < 0) or not (nAVWhere in [0..30]) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKDLGITEMADDVALUE);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam2[1];
  if (PlayObject.m_nDlgItemIndex = 0) then
    Exit;
  for i := 0 to PlayObject.m_ItemList.Count - 1 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem.MakeIndex = PlayObject.m_nDlgItemIndex then
    begin
      if nAVWhere > 13 then
      begin
        if nAVWhere = 14 then
          nAddAllValue := UserItem.Dura div 1000
        else if nAVWhere = 15 then
          nAddAllValue := UserItem.DuraMax div 1000
        else if nAVWhere = 16 then
        begin
          nAddAllValue := UserItem.btValue[14];
        end
        else if nAVWhere = 17 then
        begin
          nAddAllValue := UserItem.btValue[15] div 16;
        end
        else if nAVWhere = 18 then
        begin
          nAddAllValue := UserItem.btValue[15] mod 16;
        end
        else if nAVWhere = 19 then
        begin
          nAddAllValue := UserItem.btValue[16] div 16;
        end
        else if nAVWhere = 20 then
        begin
          nAddAllValue := UserItem.btValue[16] mod 16;
        end
        else if nAVWhere = 21 then
        begin
          nAddAllValue := UserItem.btValue[17] div 16;
        end
        else if nAVWhere = 22 then
        begin
          nAddAllValue := UserItem.btValue[17] mod 16;
        end
        else
        begin
          nAddAllValue := UserItem.btValue[nAVWhere - 5];
        end;
      end
      else
        nAddAllValue := UserItem.btValue[nAVWhere];
      case cMethod of
        '=': if nAddAllValue = nAddValue then
            Result := True;
        '>': if nAddAllValue > nAddValue then
            Result := True;
        '<': if nAddAllValue < nAddValue then
            Result := True;
      else if nAddAllValue >= nAddValue then
        Result := True;
      end;
      Break;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckItemType(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nWhere: Integer;
  nType: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  nWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  nType := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if not (nWhere in [Low(THumanUseItems)..High(THumanUseItems)]) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKITEMTYPE);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  if UserItem.wIndex = 0 then
    Exit;
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (StdItem <> nil) and (StdItem.StdMode = nType) then
    Result := True;
end;
 {
function TNormNpc.ConditionOfCheckItemLuck(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nWhere: Integer;
  i, Val, nValue, nValue2: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  StdItemA: TStdItem;
  cMethod: Char;
begin
  Result := False;
  nWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  nValue2 := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if not (nWhere in [Low(THumanUseItems)..High(THumanUseItems)]) or (nValue2 < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKITEMLUCK);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  if UserItem.wIndex = 0 then
    Exit;
  cMethod := QuestConditionInfo.sParam2[1];
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (StdItem <> nil) then
  begin
    StdItemA := StdItem^;
    ItemUnit.GetItemAddValue(UserItem, StdItemA);
    nValue := 0;
    case StdItem.StdMode of
      5, 6:
        begin
          nValue := LoWord(StdItemA.AC);
        end;
      19:
        begin
          nValue := HiWord(StdItemA.MAC);
        end;
    end;
    if StdItemA.Eva.EvaTimes > 0 then
    begin
      for i := Low(StdItemA.Eva.Abil) to High(StdItemA.Eva.Abil) do
      begin
        if (StdItemA.Eva.Abil[i].btValue > 0) and (StdItemA.Eva.Abil[i].btType in [1..30]) then
        begin
          Val := StdItemA.Eva.Abil[i].btValue;
          case StdItemA.Eva.Abil[i].btType of
            09: if StdItemA.StdMode in [5, 6, 19] then
                nValue := _MIN(High(byte), nValue + Val);
          end;
        end;
      end;
    end;

    case cMethod of
      '=': if nValue = nValue2 then
          Result := True;
      '>': if nValue > nValue2 then
          Result := True;
      '<': if nValue < nValue2 then
          Result := True;
    else if nValue >= nValue2 then
      Result := True;
    end;
  end;
end;
}
function TNormNpc.ConditionOfCheckLevelEx(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
begin
  Result := False;

  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKLEVELEX);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_Abil.Level = nLevel then
        Result := True;
    '>': if PlayObject.m_Abil.Level > nLevel then
        Result := True;
    '<': if PlayObject.m_Abil.Level < nLevel then
        Result := True;
  else if PlayObject.m_Abil.Level >= nLevel then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckIPLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
begin
  Result := False;

  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKIPLEVEL);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nInPowerLevel = nLevel then
        Result := True;
    '>': if PlayObject.m_nInPowerLevel > nLevel then
        Result := True;
    '<': if PlayObject.m_nInPowerLevel < nLevel then
        Result := True;
  else if PlayObject.m_nInPowerLevel >= nLevel then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckHeroLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
  HeroObject: TBaseObject;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKHEROLEVEL);
    Exit;
  end;
  HeroObject := PlayObject.GetHeroObjectA;
  if HeroObject <> nil then
  begin
    cMethod := QuestConditionInfo.sParam1[1];
    case cMethod of
      '=': if HeroObject.m_Abil.Level = nLevel then
          Result := True;
      '>': if HeroObject.m_Abil.Level > nLevel then
          Result := True;
      '<': if HeroObject.m_Abil.Level < nLevel then
          Result := True;
    else if HeroObject.m_Abil.Level >= nLevel then
      Result := True;
    end;
  end;
end;

{function TNormNpc.ConditionOfCheckStringListPostion(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  LoadList                  : TStringList;
  sStr, sFile               : string;
begin
  Result := False;
  sFile := g_Config.sEnvirDir + QuestConditionInfo.sParam1;
  sStr := QuestConditionInfo.sParam2;
  if not FileExists(sFile) or (sStr = '') then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSTRINGLIST);
    Exit;
  end;
  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sFile);
  if LoadList.IndexOf(sStr) >= 0 then
    Result := True;
  LoadList.Free;
end;}

function TNormNpc.ConditionOfCheckNameListPostion(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sCharName, sListFileName: string;
  nNamePostion, nPostion: Integer;
  sLine: string;
  cMethod: Char;
begin
  Result := False;
  nPostion := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if nPostion < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMELISTPOSITION);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam2[1];
  nNamePostion := -1;
  sCharName := PlayObject.m_sCharName;
  LoadList := TStringList.Create;
  sListFileName := g_Config.sEnvirDir + QuestConditionInfo.sParam1;
  if not FileExists(sListFileName) then
    sListFileName := g_Config.sEnvirDir + m_sPath + QuestConditionInfo.sParam1;

  if FileExists(sListFileName) then
  begin
    LoadList.LoadFromFile(sListFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      sLine := Trim(LoadList.Strings[i]);
      if (sLine = '') or (sLine[1] = ';') then
        Continue;
      if CompareText(sLine, sCharName) = 0 then
      begin
        nNamePostion := i;
        Break;
      end;
    end;
  end
  else
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMELISTPOSITION);
    //Exit;               //0618     memory leak
  end;
  LoadList.Free;
  if nNamePostion = -1 then
    Exit;

  case cMethod of
    '=': if nNamePostion = nPostion then
        Result := True;
    '>': if nNamePostion > nPostion then
        Result := True;
    '<': if nNamePostion < nPostion then
        Result := True;
  else if nNamePostion >= nPostion then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMarry(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if PlayObject.m_sDearName <> '' then
    Result := True;
end;

function TNormNpc.ConditionOfCheckMarryCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMARRYCOUNT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btMarryCount = nCount then
        Result := True;
    '>': if PlayObject.m_btMarryCount > nCount then
        Result := True;
    '<': if PlayObject.m_btMarryCount < nCount then
        Result := True;
  else if PlayObject.m_btMarryCount >= nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if (PlayObject.m_sMasterName <> '') and (not PlayObject.m_boMaster) then
    Result := True;
end;

function TNormNpc.ConditionOfCHECKMASTERONLINE(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if (PlayObject.m_sMasterName <> '') and (UserEngine.GetPlayObject(PlayObject.m_sMasterName) <> nil) then
    Result := True;
end;

function TNormNpc.ConditionOfCHECKDEARONLINE(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if (PlayObject.m_sDearName <> '') and (UserEngine.GetPlayObject(PlayObject.m_sDearName) <> nil) then
    Result := True;
end;

function TNormNpc.ConditionOfCHECKMASTERONMAP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  MasterObject: TPlayObject;
begin
  Result := False;
  if (PlayObject.m_sMasterName <> '') then
  begin
    MasterObject := UserEngine.GetPlayObject(PlayObject.m_sMasterName);
    if (MasterObject.m_sMapName = QuestConditionInfo.sParam1) or ((QuestConditionInfo.sParam1 = 'SELF') and (MasterObject.m_sMapName = PlayObject.m_sMapName)) then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCHECKDEARONMAP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  DearObject: TPlayObject;
begin
  Result := False;
  if (PlayObject.m_sDearName <> '') then
  begin
    DearObject := UserEngine.GetPlayObject(PlayObject.m_sDearName);
    if (DearObject.m_sMapName = QuestConditionInfo.sParam1) or ((QuestConditionInfo.sParam1 = 'SELF') and (DearObject.m_sMapName = PlayObject.m_sMapName)) then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCHECKPOSEISPRENTICE(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) and (PoseHuman.GetPoseCreate = PlayObject) then
  begin
    if (PoseHuman.m_sMasterName = m_sCharName) and (not PoseHuman.m_boMaster) then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMemBerLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMEMBERLEVEL);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nMemberLevel = nLevel then
        Result := True;
    '>': if PlayObject.m_nMemberLevel > nLevel then
        Result := True;
    '<': if PlayObject.m_nMemberLevel < nLevel then
        Result := True;
  else if PlayObject.m_nMemberLevel >= nLevel then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMemberType(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nType: Integer;
  cMethod: Char;
begin
  Result := False;
  nType := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nType < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMEMBERTYPE);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nMemberType = nType then
        Result := True;
    '>': if PlayObject.m_nMemberType > nType then
        Result := True;
    '<': if PlayObject.m_nMemberType < nType then
        Result := True;
  else if PlayObject.m_nMemberType >= nType then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckNameIPList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sCharName, sListFileName: string;
  sCharAccount: string;
  sCharIPaddr: string;
  sLine: string;
  sName: string;
  sIPaddr: string;
begin
  Result := False;
  sCharName := PlayObject.m_sCharName;
  sCharAccount := PlayObject.m_sUserID;
  sCharIPaddr := PlayObject.m_sIPaddr;
  LoadList := TStringList.Create;
  sListFileName := g_Config.sEnvirDir + QuestConditionInfo.sParam1;
  if not FileExists(sListFileName) then
    sListFileName := g_Config.sEnvirDir + m_sPath + QuestConditionInfo.sParam1;
  if FileExists(sListFileName) then
  begin
    LoadList.LoadFromFile(sListFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      sLine := LoadList.Strings[i];
      if sLine[1] = ';' then
        Continue;
      sIPaddr := GetValidStr3(sLine, sName, [' ', '/', #9]);
      sIPaddr := Trim(sIPaddr);
      if (sName = sCharName) and (sIPaddr = sCharIPaddr) then
      begin
        Result := True;
        Break;
      end;
    end;
  end
  else
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMEIPLIST);
  end;
  LoadList.Free
end;

function TNormNpc.ConditionOfCheckPoseDir(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.GetPoseCreate = PlayObject) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    case QuestConditionInfo.nParam1 of
      1: if PoseHuman.m_btGender = PlayObject.m_btGender then
          Result := True; //要求相同性别
      2: if PoseHuman.m_btGender <> PlayObject.m_btGender then
          Result := True; //要求不同性别
    else
      Result := True; //无参数时不判别性别
    end;
  end;
end;

function TNormNpc.ConditionOfCheckPoseGender(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
  btSex: byte;
begin
  Result := False;
  btSex := 0;
  if CompareText(QuestConditionInfo.sParam1, 'MAN') = 0 then
  begin
    btSex := 0;
  end
  else if CompareText(QuestConditionInfo.sParam1, '男') = 0 then
  begin
    btSex := 0;
  end
  else if CompareText(QuestConditionInfo.sParam1, 'WOMAN') = 0 then
  begin
    btSex := 1;
  end
  else if CompareText(QuestConditionInfo.sParam1, '女') = 0 then
  begin
    btSex := 1;
  end;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    if PoseHuman.m_btGender = btSex then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPoseIsMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    if (TPlayObject(PoseHuman).m_sMasterName <> '') and (TPlayObject(PoseHuman).m_boMaster) then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPoseLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  PoseHuman: TBaseObject;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKPOSELEVEL);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    case cMethod of
      '=': if PoseHuman.m_Abil.Level = nLevel then
          Result := True;
      '>': if PoseHuman.m_Abil.Level > nLevel then
          Result := True;
      '<': if PoseHuman.m_Abil.Level < nLevel then
          Result := True;
    else if PoseHuman.m_Abil.Level >= nLevel then
      Result := True;
    end;
  end;

end;

function TNormNpc.ConditionOfCheckPoseMarry(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    if TPlayObject(PoseHuman).m_sDearName <> '' then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPoseMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    if (TPlayObject(PoseHuman).m_sMasterName <> '') and not (TPlayObject(PoseHuman).m_boMaster) then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckServerName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if QuestConditionInfo.sParam1 = g_Config.sServerName then
    Result := True;
end;

function TNormNpc.ConditionOfCheckIsOnMap(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if {(PlayObject.m_sMapFileName = QuestConditionInfo.sParam1) or}  CompareText(PlayObject.m_sMapName, QuestConditionInfo.sParam1) = 0 then
    Result := True;
end;

function TNormNpc.ConditionOfIsSameGuildOnMap(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if UserEngine.IsSameGuildOnMap(QuestConditionInfo.sParam1) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckSlaveCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSLAVECOUNT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_SlaveList.Count = nCount then
        Result := True;
    '>': if PlayObject.m_SlaveList.Count > nCount then
        Result := True;
    '<': if PlayObject.m_SlaveList.Count < nCount then
        Result := True;
  else if PlayObject.m_SlaveList.Count >= nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckIniSectionExists(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  MyIniFile: TIniFile;
  sFileName: String;
begin
  Result := False;
  try
    if (QuestConditionInfo.sParam1 = '') or (QuestConditionInfo.sParam2 = '') then
    begin
      ScriptConditionError(PlayObject,  QuestConditionInfo, sSC_CHECKINISECTIONEXISTS);
      exit;
    end;

    sFileName := g_Config.sEnvirDir + m_sPath + QuestConditionInfo.sParam1;
    MyIniFile := TIniFile.Create(sFileName);
    Result := MyIniFile.SectionExists(QuestConditionInfo.sParam2);
  finally
    MyIniFile.Free;
  end;
end;

constructor TNormNpc.Create;
begin
  inherited;
  m_boSuperMan := True;
  m_btRaceServer := RC_NPC;
  m_nLight := 2;
  m_btAntiPoison := 99;
  m_ScriptList := TList.Create;
  m_boStickMode := True;
  m_sFilePath := '';
  m_boIsHide := False;
  m_boIsQuest := True;
  m_dwSearchTime := Random(1500) + 2500;

  m_LastOprObject := nil;
  m_LastOprLabel := '';
  m_OprCount := 0;
  m_dwGotoLabelTick := GetTickCount;
  m_sMDlgImgName := '';
end;

destructor TNormNpc.Destroy;
begin
  ClearScript();
  m_ScriptList.Free;
  inherited;
end;

procedure TNormNpc.ExeAction(PlayObject: TPlayObject; sParam1, sParam2, sParam3: string; nParam1, nParam2, nParam3: Integer);
var
  nInt1: Integer;
  dwInt: LongWord;
begin
  if CompareText(sParam1, 'CHANGEEXP') = 0 then
  begin
    nInt1 := Str_ToInt(sParam2, -1);
    case nInt1 of
      0:
        begin
          if nParam3 >= 0 then
          begin
            PlayObject.m_Abil.Exp := LongWord(nParam3);
            PlayObject.HasLevelUp();
          end;
        end;
      1:
        begin
          if PlayObject.m_Abil.Exp >= LongWord(nParam3) then
          begin
            if (PlayObject.m_Abil.Exp - LongWord(nParam3)) > (High(LongWord) - PlayObject.m_Abil.Exp) then
            begin
              dwInt := High(LongWord) - PlayObject.m_Abil.Exp;
            end
            else
            begin
              dwInt := LongWord(nParam3);
            end;
          end
          else
          begin
            if (LongWord(nParam3) - PlayObject.m_Abil.Exp) > (High(LongWord) - LongWord(nParam3)) then
            begin
              dwInt := High(LongWord) - LongWord(nParam3);
            end
            else
            begin
              dwInt := LongWord(nParam3);
            end;
          end;
          Inc(PlayObject.m_Abil.Exp, dwInt);
          PlayObject.HasLevelUp();
        end;
      2:
        begin
          if PlayObject.m_Abil.Exp > LongWord(nParam3) then
          begin
            Dec(PlayObject.m_Abil.Exp, LongWord(nParam3));
          end
          else
          begin
            PlayObject.m_Abil.Exp := 0;
          end;
          PlayObject.HasLevelUp();
        end;
    end;
    PlayObject.SysMsg('您当前经验点数为: ' + IntToStr(PlayObject.m_Abil.Exp) + '/' + IntToStr(PlayObject.m_Abil.MaxExp), c_Green, t_Hint);
    Exit;
  end;

  if CompareText(sParam1, 'CHANGELEVEL') = 0 then
  begin
    nInt1 := Str_ToInt(sParam2, -1);
    case nInt1 of
      0:
        begin
          if nParam3 >= 0 then
          begin
            PlayObject.m_Abil.Level := LongWord(nParam3);
            PlayObject.HasLevelUp();
          end;
        end;
      1:
        begin
          if PlayObject.m_Abil.Level >= LongWord(nParam3) then
          begin
            if (PlayObject.m_Abil.Level - LongWord(nParam3)) > (High(Word) - PlayObject.m_Abil.Level) then
            begin
              dwInt := High(Word) - PlayObject.m_Abil.Level;
            end
            else
            begin
              dwInt := LongWord(nParam3);
            end;
          end
          else
          begin
            if (LongWord(nParam3) - PlayObject.m_Abil.Level) > (High(Word) - LongWord(nParam3)) then
            begin
              dwInt := High(LongWord) - LongWord(nParam3);
            end
            else
            begin
              dwInt := LongWord(nParam3);
            end;
          end;
          Inc(PlayObject.m_Abil.Level, dwInt);
          PlayObject.HasLevelUp();
        end;
      2:
        begin
          if PlayObject.m_Abil.Level > LongWord(nParam3) then
          begin
            Dec(PlayObject.m_Abil.Level, LongWord(nParam3));
          end
          else
          begin
            PlayObject.m_Abil.Level := 0;
          end;
          PlayObject.HasLevelUp();
        end;
    end;
    PlayObject.SysMsg('您当前等级为: ' + IntToStr(PlayObject.m_Abil.Level),
      c_Green, t_Hint);
    Exit;
  end;

  if CompareText(sParam1, 'KILL') = 0 then
  begin
    nInt1 := Str_ToInt(sParam2, -1);
    case nInt1 of
      1:
        begin
          PlayObject.m_boNoItem := True;
          PlayObject.Die;
        end;
      2:
        begin
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
      3:
        begin
          PlayObject.m_boNoItem := True;
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
    else
      begin
        PlayObject.Die;
      end;
    end;
    Exit;
  end;
  if CompareText(sParam1, 'KICK') = 0 then
  begin
    PlayObject.m_boKickFlag := True;
    Exit;
  end;
end;

function TNormNpc.GetLineVariableText(PlayObject: TPlayObject; sMsg: string): string;
var
  nCount: Integer;
  sVariable: string;
begin
  nCount := 0;

  while (True) do
  begin
    //if TagCount(sMsg, '>') < 1 then
    //  Break;
    if Pos('>', sMsg) <= 0 then
      Break;
    ArrestStringEx(sMsg, '<', '>', sVariable);
    if (sVariable <> '') then
    begin
      if (sVariable[1] = '$') then
        GetVariableText(PlayObject, sMsg, sVariable);
      //else if CompareLStr(sVariable, 'PIC=$', 5) then begin
      //  //text <PIC=$STR(S1) LABEL=@testlabel> text
      //  sRemain := GetValidStr3(sVariable, sPic, [' ']);
      //end;
    end;
    Inc(nCount);
    if nCount >= 101 then
      Break;
  end;
  Result := sMsg;
end;

procedure TNormNpc.GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string);
var
  sText, s14: string;
  i: Integer;
  n18: Integer;
  wHour: Word;
  wMinute: Word;
  wSecond: Word;
  nSecond: Integer;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  sMAP, sX, sY: string;
  Envir: TEnvirnoment;
  Hero: TBaseObject;
  StdItem: pTStdItem;

  objidx: TObject;
  VarIdx: Integer;
  PlayObject2: TPlayObject;
  Str: string;
begin
  objidx := g_VariablesList.GetValues(sVariable);
  if objidx <> nil then
  begin
    Str := Format('<%s>', [sVariable]);

    PlayObject2 := PlayObject;
    VarIdx := Integer(objidx);
    if Integer(objidx) > 10000 then
    begin
      Hero := PlayObject.GetHeroObjectA;
      if Hero = nil then
      begin
        sMsg := ExVariableText(sMsg, Str, '???');
        Exit;
      end;
      PlayObject2 := Hero as TPlayObject;
      VarIdx := Integer(objidx) - 10000;
    end;
    case VarIdx of
      v_SERVERNAME:
        begin
          sMsg := ExVariableText(sMsg, '<$SERVERNAME>', g_Config.sServerName);
        end;
      v_SERVERIP:
        begin
          sMsg := ExVariableText(sMsg, '<$SERVERIP>', g_Config.sServerIPaddr);
        end;
      v_WEBSITE:
        begin
          sMsg := ExVariableText(sMsg, '<$WEBSITE>', g_Config.sWebSite);
        end;
      v_BBSSITE:
        begin
          sMsg := ExVariableText(sMsg, '<$BBSSITE>', g_Config.sBbsSite);
        end;
      v_CLIENTDOWNLOAD:
        begin
          sMsg := ExVariableText(sMsg, '<$CLIENTDOWNLOAD>', g_Config.sClientDownload);
        end;
      v_QQ:
        begin
          sMsg := ExVariableText(sMsg, '<$QQ>', g_Config.sQQ);
        end;
      v_PHONE:
        begin
          sMsg := ExVariableText(sMsg, '<$PHONE>', g_Config.sPhone);
        end;
      v_BANKACCOUNT0:
        begin
          sMsg := ExVariableText(sMsg, '<$BANKACCOUNT0>', g_Config.sBankAccount0);
        end;
      v_BANKACCOUNT1:
        begin
          sMsg := ExVariableText(sMsg, '<$BANKACCOUNT1>', g_Config.sBankAccount1);
        end;
      v_BANKACCOUNT2:
        begin
          sMsg := ExVariableText(sMsg, '<$BANKACCOUNT2>', g_Config.sBankAccount2);
        end;
      v_BANKACCOUNT3:
        begin
          sMsg := ExVariableText(sMsg, '<$BANKACCOUNT3>', g_Config.sBankAccount3);
        end;
      v_BANKACCOUNT4:
        begin
          sMsg := ExVariableText(sMsg, '<$BANKACCOUNT4>', g_Config.sBankAccount4);
        end;
      v_BANKACCOUNT5:
        begin
          sMsg := ExVariableText(sMsg, '<$BANKACCOUNT5>', g_Config.sBankAccount5);
        end;
      v_BANKACCOUNT6:
        begin
          sMsg := ExVariableText(sMsg, '<$BANKACCOUNT6>', g_Config.sBankAccount6);
        end;
      v_BANKACCOUNT7:
        begin
          sMsg := ExVariableText(sMsg, '<$BANKACCOUNT7>', g_Config.sBankAccount7);
        end;
      v_BANKACCOUNT8:
        begin
          sMsg := ExVariableText(sMsg, '<$BANKACCOUNT8>', g_Config.sBankAccount8);
        end;
      v_BANKACCOUNT9:
        begin
          sMsg := ExVariableText(sMsg, '<$BANKACCOUNT9>', g_Config.sBankAccount9);
        end;
      v_GAMEGOLDNAME:
        begin
          sMsg := ExVariableText(sMsg, '<$GAMEGOLDNAME>', g_Config.sGameGoldName);
        end;
      v_GAMEPOINTNAME:
        begin
          sMsg := ExVariableText(sMsg, '<$GAMEPOINTNAME>', g_Config.sGamePointName);
        end;
      v_USERCOUNT:
        begin
          sMsg := ExVariableText(sMsg, '<$USERCOUNT>', Format('%d', [UserEngine.PlayObjectCount]));
        end;
      v_MACRUNTIME:
        begin
          sText := CurrToStr(GetTickCount / (24 * 60 * 60 * 1000));
          sMsg := ExVariableText(sMsg, '<$MACRUNTIME>', sText);
        end;
      v_SERVERRUNTIME:
        begin
          nSecond := (GetTickCount() - g_dwStartTick) div 1000;
          wHour := nSecond div 3600;
          wMinute := (nSecond div 60) mod 60;
          wSecond := nSecond mod 60;
          sText := Format('%d:%d:%d', [wHour, wMinute, wSecond]);
          sMsg := ExVariableText(sMsg, '<$SERVERRUNTIME>', sText);
        end;
      v_DATETIME:
        begin
          sText := FormatDateTime('dddddd,dddd,hh:nn:ss', Now);
          sMsg := ExVariableText(sMsg, '<$DATETIME>', sText);
        end;
      v_HIGHLEVELINFO:
        begin
          if g_HighLevelHuman <> nil then
          begin
            sText := TPlayObject(g_HighLevelHuman).GetMyInfo;
          end
          else
            sText := '????';
          sMsg := ExVariableText(sMsg, '<$HIGHLEVELINFO>', sText);
        end;
      v_HIGHPKINFO:
        begin
          if g_HighPKPointHuman <> nil then
          begin
            sText := TPlayObject(g_HighPKPointHuman).GetMyInfo;
          end
          else
            sText := '????';
          sMsg := ExVariableText(sMsg, '<$HIGHPKINFO>', sText);
        end;
      v_HIGHDCINFO:
        begin
          if g_HighDCHuman <> nil then
          begin
            sText := TPlayObject(g_HighDCHuman).GetMyInfo;
          end
          else
            sText := '????';
          sMsg := ExVariableText(sMsg, '<$HIGHDCINFO>', sText);
        end;
      v_HIGHMCINFO:
        begin
          if g_HighMCHuman <> nil then
          begin
            sText := TPlayObject(g_HighMCHuman).GetMyInfo;
          end
          else
            sText := '????';
          sMsg := ExVariableText(sMsg, '<$HIGHMCINFO>', sText);
        end;
      v_HIGHSCINFO:
        begin
          if g_HighSCHuman <> nil then
          begin
            sText := TPlayObject(g_HighSCHuman).GetMyInfo;
          end
          else
            sText := '????';
          sMsg := ExVariableText(sMsg, '<$HIGHSCINFO>', sText);
        end;
      v_HIGHONLINEINFO:
        begin
          if g_HighOnlineHuman <> nil then
          begin
            sText := TPlayObject(g_HighOnlineHuman).GetMyInfo;
          end
          else
            sText := '????';
          sMsg := ExVariableText(sMsg, '<$HIGHONLINEINFO>', sText);
        end;

      (***********************个人信息***********************)
      v_CURRENTMAPDESC:
        begin
          if PlayObject2.m_PEnvir <> nil then
            sText := PlayObject2.m_PEnvir.m_sMapDesc
          else
            sText := '未知';
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_CURRENTMAP:
        begin
          if PlayObject2.m_PEnvir <> nil then
            sText := PlayObject2.m_PEnvir.m_sMapFileName
          else
            sText := '未知';
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_CURRENTX:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_nCurrX));
        end;
      v_CURRENTY:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_nCurrY));
        end;
      v_GENDER:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToSex(PlayObject2.m_btGender));
        end;
      {v_H_GENDER: begin
          Hero := PlayObject.GetHeroObjectA;
          if Hero <> nil then
            sText := IntToSex(Hero.m_btGender)
          else
            sText := '未知';
          sMsg := ExVariableText(sMsg, '<$H.GENDER>', sText);
        end;}
      v_JOB:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToJob(PlayObject2.m_btJob));
        end;
      {v_H_JOB: begin
          Hero := PlayObject.GetHeroObjectA;
          if Hero <> nil then
            sText := IntToJob(Hero.m_btJob)
          else
            sText := '未知';
          sMsg := ExVariableText(sMsg, '<$H.JOB>', sText);
        end;}
      v_ABILITYADDPOINT0:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_wStatusArrValue2[0]));
        end;
      v_ABILITYADDPOINT1:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_wStatusArrValue2[1]));
        end;
      v_ABILITYADDPOINT2:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_wStatusArrValue2[2]));
        end;
      v_ABILITYADDPOINT3:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_wStatusArrValue2[3]));
        end;
      v_ABILITYADDPOINT4:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_wStatusArrValue2[4]));
        end;
      v_ABILITYADDPOINT5:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_wStatusArrValue2[5]));
        end;
      v_ABILITYADDPOINT6:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_wStatusArrValue2[6]));
        end;
      v_ABILITYADDTIME0:
        begin
          nSecond := Integer(PlayObject2.m_dwStatusArrTimeOutTick2[0] - GetTickCount) div 1000;
          if nSecond < 0 then
            nSecond := 0;
          sMsg := ExVariableText(sMsg, Str, IntToStr(nSecond));
        end;
      v_ABILITYADDTIME1:
        begin
          nSecond := Integer(PlayObject2.m_dwStatusArrTimeOutTick2[1] - GetTickCount) div 1000;
          if nSecond < 0 then
            nSecond := 0;
          sMsg := ExVariableText(sMsg, Str, IntToStr(nSecond));
        end;
      v_ABILITYADDTIME2:
        begin
          nSecond := Integer(PlayObject2.m_dwStatusArrTimeOutTick2[2] - GetTickCount) div 1000;
          if nSecond < 0 then
            nSecond := 0;
          sMsg := ExVariableText(sMsg, Str, IntToStr(nSecond));
        end;
      v_ABILITYADDTIME3:
        begin
          nSecond := Integer(PlayObject2.m_dwStatusArrTimeOutTick2[3] - GetTickCount) div 1000;
          if nSecond < 0 then
            nSecond := 0;
          sMsg := ExVariableText(sMsg, Str, IntToStr(nSecond));
        end;
      v_ABILITYADDTIME4:
        begin
          nSecond := Integer(PlayObject2.m_dwStatusArrTimeOutTick2[4] - GetTickCount) div 1000;
          if nSecond < 0 then
            nSecond := 0;
          sMsg := ExVariableText(sMsg, Str, IntToStr(nSecond));
        end;
      v_ABILITYADDTIME5:
        begin
          nSecond := Integer(PlayObject2.m_dwStatusArrTimeOutTick2[5] - GetTickCount) div 1000;
          if nSecond < 0 then
            nSecond := 0;
          sMsg := ExVariableText(sMsg, Str, IntToStr(nSecond));
        end;
      v_ABILITYADDTIME6:
        begin
          nSecond := Integer(PlayObject2.m_dwStatusArrTimeOutTick2[6] - GetTickCount) div 1000;
          if nSecond < 0 then
            nSecond := 0;
          sMsg := ExVariableText(sMsg, Str, IntToStr(nSecond));
        end;
      v_USERNAME:
        begin
          sMsg := ExVariableText(sMsg, Str, PlayObject2.m_sCharName);
        end;
      v_MEMBRETYPE:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_nMemberType));
        end;
      v_MEMBRELEVEL:
        begin
          sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_nMemberLevel));
        end;
      v_ROBBER:
        begin
          if PlayObject.m_Robber <> nil then
            sMsg := ExVariableText(sMsg, '<$ROBBER>', PlayObject.m_Robber.m_sCharName)
          else
            sMsg := ExVariableText(sMsg, '<$ROBBER>', '未知');
        end;
      v_DLGITEMNAME:
        begin
          if (PlayObject.m_nDlgItemIndex = 0) then
            Exit;
          for i := 0 to PlayObject.m_ItemList.Count - 1 do
          begin
            if pTUserItem(PlayObject.m_ItemList.Items[i]).MakeIndex = PlayObject.m_nDlgItemIndex then
            begin
              StdItem := UserEngine.GetStdItem(pTUserItem(PlayObject.m_ItemList.Items[i]).wIndex);
              if StdItem <> nil then
                sMsg := ExVariableText(sMsg, '<$DLGITEMNAME>', StdItem.Name);
              Break;
            end;
          end;
        end;
      v_RANDOMNO:
        begin
          sMsg := ExVariableText(sMsg, '<$RANDOMNO>', PlayObject.m_sRandomNo);
        end;
      v_DEALGOLDPLAY:
        begin
          if PlayObject.m_DealGoldCreat <> nil then
          begin
            sText := PlayObject.m_DealGoldCreat.m_sCharName;
          end
          else
            sText := '????';
          sMsg := ExVariableText(sMsg, '<$DEALGOLDPLAY>', sText);
        end;
      v_MONKILLER:
        begin
          if PlayObject2.m_LastHiter <> nil then
          begin
            if (PlayObject2.m_LastHiter.m_btRaceServer <> RC_PLAYOBJECT) and (not PlayObject2.m_LastHiter.IsHero) then
              sMsg := ExVariableText(sMsg, Str, PlayObject2.m_LastHiter.m_sCharName);
          end
          else
            sMsg := ExVariableText(sMsg, Str, '???');
        end;
      v_KILLER:
        begin
          if PlayObject2.m_LastHiter <> nil then
          begin
            if (PlayObject2.m_LastHiter.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject2.m_LastHiter.IsHero) then
              sMsg := ExVariableText(sMsg, Str, PlayObject2.m_LastHiter.m_sCharName);
          end
          else
            sMsg := ExVariableText(sMsg, Str, '???');
        end;
      v_DECEDENT:
        begin
          if PlayObject2.m_LastHiter <> nil then
          begin
            sText := PlayObject2.m_sCharName;
          end
          else
            sText := '???';
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_RELEVEL:
        begin
          sMsg := ExVariableText(sMsg, Str, Format('%d', [PlayObject2.m_btReLevel]));
        end;
      {v_H_RELEVEL: begin
          Hero := PlayObject.GetHeroObjectA;
          if Hero <> nil then
            sText := IntToStr(Hero.m_btReLevel)
          else
            sText := '0';
          sMsg := ExVariableText(sMsg, '<$H.RELEVEL>', sText);
        end;}
      v_HUMANSHOWNAME:
        begin
          sMsg := ExVariableText(sMsg, Str, PlayObject2.GetShowName);
        end;

      (***********************行会人数变量***********************)
      v_GUILDHUMCOUNT:
        begin
          if PlayObject.m_MyGuild <> nil then
            sMsg := ExVariableText(sMsg, '<$GUILDHUMCOUNT>', IntToStr(TGuild(PlayObject.m_MyGuild).Count))
          else
            sMsg := '无';
        end;
      v_GUILDNAME:
        begin
          if PlayObject.m_MyGuild <> nil then
            sMsg := ExVariableText(sMsg, '<$GUILDNAME>', TGuild(PlayObject.m_MyGuild).sGuildName)
          else
            sMsg := '无';
        end;
      v_RANKNAME:
        begin
          sMsg := ExVariableText(sMsg, '<$RANKNAME>', PlayObject.m_sGuildRankName);
        end;
      v_LEVEL:
        begin
          sText := IntToStr(PlayObject2.m_Abil.Level);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_GCEPAYMENT:
        begin
          sText := IntToStr(PlayObject.m_btCollectExpLv);
          if (PlayObject.m_PEnvir <> nil) {and (PlayObject.m_PEnvir.m_MapFlag.PCollectExp <> nil)} then
            sText := IntToStr(PlayObject.m_btCollectExpLv * PlayObject.m_PEnvir.m_MapFlag.PCollectExp.nGainExpPayment);
          sMsg := ExVariableText(sMsg, '<$GCEPAYMENT>', sText);
        end;
      v_COLLECTEXP:
        begin
          sText := IntToStr(PlayObject.m_dwCollectExp);
          sMsg := ExVariableText(sMsg, '<$COLLECTEXP>', sText);
        end;
      v_COLLECTIPEXP:
        begin
          sText := IntToStr(PlayObject.m_dwCollectIpExp);
          sMsg := ExVariableText(sMsg, '<$COLLECTIPEXP>', sText);
        end;
      v_GAINCOLLECTEXP:
        begin
          if (PlayObject.m_btCollectExpLv in [2..4]) then
          begin
            sText := '0';
            if (PlayObject.m_PEnvir <> nil) {and (PlayObject.m_PEnvir.m_MapFlag.PCollectExp <> nil)} then
              if PlayObject.m_dwCollectExp >= PlayObject.m_PEnvir.m_MapFlag.PCollectExp.dwCollectExps[PlayObject.m_btCollectExpLv] then
                sText := IntToStr(PlayObject.m_PEnvir.m_MapFlag.PCollectExp.dwCollectExps[PlayObject.m_btCollectExpLv])
              else
                sText := IntToStr(PlayObject.m_PEnvir.m_MapFlag.PCollectExp.dwCollectExps[PlayObject.m_btCollectExpLv - 1]);
            sMsg := ExVariableText(sMsg, '<$GAINCOLLECTEXP>', sText);
          end
          else
          begin
            sMsg := ExVariableText(sMsg, '<$GAINCOLLECTEXP>', '0');
          end;
        end;
      v_GAINCOLLECTIPEXP:
        begin
          if (PlayObject.m_btCollectExpLv in [2..4]) then
          begin
            sText := '0';
            if (PlayObject.m_PEnvir <> nil) {and (PlayObject.m_PEnvir.m_MapFlag.PCollectExp <> nil)} then
              if PlayObject.m_dwCollectIpExp >= PlayObject.m_PEnvir.m_MapFlag.PCollectExp.dwCollectIPExps[PlayObject.m_btCollectExpLv] then
                sText := IntToStr(PlayObject.m_PEnvir.m_MapFlag.PCollectExp.dwCollectIPExps[PlayObject.m_btCollectExpLv])
              else
                sText := IntToStr(PlayObject.m_PEnvir.m_MapFlag.PCollectExp.dwCollectIPExps[PlayObject.m_btCollectExpLv - 1]);
            sMsg := ExVariableText(sMsg, '<$GAINCOLLECTIPEXP>', sText);
          end
          else
          begin
            sMsg := ExVariableText(sMsg, '<$GAINCOLLECTIPEXP>', '0');
          end;
        end;
      v_HP:
        begin
          sText := IntToStr(PlayObject2.m_WAbil.HP);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXHP:
        begin
          sText := IntToStr(PlayObject2.m_WAbil.MaxHP);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MP:
        begin
          sText := IntToStr(PlayObject2.m_WAbil.MP);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXMP:
        begin
          sText := IntToStr(PlayObject2.m_WAbil.MaxMP);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_AC:
        begin
          sText := IntToStr(LoWord(PlayObject2.m_WAbil.AC));
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXAC:
        begin
          sText := IntToStr(HiWord(PlayObject2.m_WAbil.AC));
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAC:
        begin
          sText := IntToStr(LoWord(PlayObject2.m_WAbil.MAC));
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXMAC:
        begin
          sText := IntToStr(HiWord(PlayObject2.m_WAbil.MAC));
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_DC:
        begin
          sText := IntToStr(LoWord(PlayObject2.m_WAbil.DC));
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXDC:
        begin
          sText := IntToStr(HiWord(PlayObject2.m_WAbil.DC));
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MC:
        begin
          sText := IntToStr(LoWord(PlayObject2.m_WAbil.MC));
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXMC:
        begin
          sText := IntToStr(HiWord(PlayObject2.m_WAbil.MC));
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_SC:
        begin
          sText := IntToStr(LoWord(PlayObject2.m_WAbil.SC));
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXSC:
        begin
          sText := IntToStr(HiWord(PlayObject2.m_WAbil.SC));
          sMsg := ExVariableText(sMsg, Str, sText);
        end;

      v_HIT:
        begin
          sText := IntToStr(PlayObject2.m_btHitPoint);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_SPD:
        begin
          sText := IntToStr(PlayObject2.m_btSpeedPoint);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSPOINT:
        begin
          sText := IntToStr(PlayObject2.m_nBonusPoint);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSABIL_AC:
        begin
          sText := IntToStr(PlayObject2.m_BonusAbil.AC);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSABIL_MAC:
        begin
          sText := IntToStr(PlayObject2.m_BonusAbil.MAC);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSABIL_DC:
        begin
          sText := IntToStr(PlayObject2.m_BonusAbil.DC);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSABIL_MC:
        begin
          sText := IntToStr(PlayObject2.m_BonusAbil.MC);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSABIL_SC:
        begin
          sText := IntToStr(PlayObject2.m_BonusAbil.SC);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSABIL_HP:
        begin
          sText := IntToStr(PlayObject2.m_BonusAbil.HP);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSABIL_MP:
        begin
          sText := IntToStr(PlayObject2.m_BonusAbil.MP);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSABIL_HIT:
        begin
          sText := IntToStr(PlayObject2.m_BonusAbil.HIT);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSABIL_SPD:
        begin
          sText := IntToStr(PlayObject2.m_BonusAbil.Speed);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSABIL_X2:
        begin
          sText := IntToStr(PlayObject2.m_BonusAbil.X2);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;

      v_BONUSTICK_AC:
        begin
          case PlayObject2.m_btJob of
            0: sText := IntToStr(g_Config.BonusAbilofWarr.AC);
            1: sText := IntToStr(g_Config.BonusAbilofWizard.AC);
            2: sText := IntToStr(g_Config.BonusAbilofTaos.AC);
          end;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSTICK_MAC:
        begin
          case PlayObject2.m_btJob of
            0: sText := IntToStr(g_Config.BonusAbilofWarr.MAC);
            1: sText := IntToStr(g_Config.BonusAbilofWizard.MAC);
            2: sText := IntToStr(g_Config.BonusAbilofTaos.MAC);
          end;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSTICK_DC:
        begin
          case PlayObject2.m_btJob of
            0: sText := IntToStr(g_Config.BonusAbilofWarr.DC);
            1: sText := IntToStr(g_Config.BonusAbilofWizard.DC);
            2: sText := IntToStr(g_Config.BonusAbilofTaos.DC);
          end;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSTICK_MC:
        begin
          case PlayObject2.m_btJob of
            0: sText := IntToStr(g_Config.BonusAbilofWarr.MC);
            1: sText := IntToStr(g_Config.BonusAbilofWizard.MC);
            2: sText := IntToStr(g_Config.BonusAbilofTaos.MC);
          end;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSTICK_SC:
        begin
          case PlayObject2.m_btJob of
            0: sText := IntToStr(g_Config.BonusAbilofWarr.SC);
            1: sText := IntToStr(g_Config.BonusAbilofWizard.SC);
            2: sText := IntToStr(g_Config.BonusAbilofTaos.SC);
          end;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSTICK_HP:
        begin
          case PlayObject2.m_btJob of
            0: sText := IntToStr(g_Config.BonusAbilofWarr.HP);
            1: sText := IntToStr(g_Config.BonusAbilofWizard.HP);
            2: sText := IntToStr(g_Config.BonusAbilofTaos.HP);
          end;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSTICK_MP:
        begin
          case PlayObject2.m_btJob of
            0: sText := IntToStr(g_Config.BonusAbilofWarr.MP);
            1: sText := IntToStr(g_Config.BonusAbilofWizard.MP);
            2: sText := IntToStr(g_Config.BonusAbilofTaos.MP);
          end;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSTICK_HIT:
        begin
          case PlayObject2.m_btJob of
            0: sText := IntToStr(g_Config.BonusAbilofWarr.HIT);
            1: sText := IntToStr(g_Config.BonusAbilofWizard.HIT);
            2: sText := IntToStr(g_Config.BonusAbilofTaos.HIT);
          end;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSTICK_SPD:
        begin
          case PlayObject2.m_btJob of
            0: sText := IntToStr(g_Config.BonusAbilofWarr.Speed);
            1: sText := IntToStr(g_Config.BonusAbilofWizard.Speed);
            2: sText := IntToStr(g_Config.BonusAbilofTaos.Speed);
          end;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BONUSTICK_X2:
        begin
          case PlayObject2.m_btJob of
            0: sText := IntToStr(g_Config.BonusAbilofWarr.X2);
            1: sText := IntToStr(g_Config.BonusAbilofWizard.X2);
            2: sText := IntToStr(g_Config.BonusAbilofTaos.X2);
          end;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;

      v_EXP:
        begin
          sText := IntToStr(PlayObject2.m_Abil.Exp);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXEXP:
        begin
          sText := IntToStr(PlayObject2.m_Abil.MaxExp);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_PKPOINT:
        begin
          sText := IntToStr(PlayObject2.m_nPkPoint);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_CREDITPOINT:
        begin
          sText := IntToStr(PlayObject2.m_btCreditPoint);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_HEROCREDITPOINT:
        begin
          Hero := PlayObject.GetHeroObjectA;
          if Hero <> nil then
            sText := IntToStr(Hero.m_btCreditPoint)
          else
            sText := '0';
          sMsg := ExVariableText(sMsg, '<$HEROCREDITPOINT>', sText);
        end;
      v_HW:
        begin
          sText := IntToStr(PlayObject2.m_WAbil.HandWeight);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXHW:
        begin
          sText := IntToStr(PlayObject2.m_WAbil.MaxHandWeight);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BW:
        begin
          sText := IntToStr(PlayObject2.m_WAbil.Weight);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXBW:
        begin
          sText := IntToStr(PlayObject2.m_WAbil.MaxWeight);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;

      v_WW:
        begin
          sText := IntToStr(PlayObject2.m_WAbil.WearWeight);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_MAXWW:
        begin
          sText := IntToStr(PlayObject2.m_WAbil.MaxWearWeight);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;

      v_GOLDCOUNT:
        begin
          sText := IntToStr(PlayObject2.m_nGold) + '/' + IntToStr(PlayObject2.m_nGoldMax);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_GAMEGOLD:
        begin
          sText := IntToStr(PlayObject2.m_nGameGold);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_NIMBUS:
        begin
          sText := IntToStr(PlayObject2.m_dwGatherNimbus);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      {v_H_NIMBUS: begin
          Hero := PlayObject.GetHeroObjectA;
          if Hero <> nil then
            sText := IntToStr(TPlayObject(Hero).m_dwGatherNimbus)
          else
            sText := '0';
          sMsg := ExVariableText(sMsg, '<$H.NIMBUS>', sText);
        end;}

      v_GAMEPOINT:
        begin
          sText := IntToStr(PlayObject2.m_nGamePoint);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_GAMEDIAMOND:
        begin
          sText := IntToStr(PlayObject2.m_nGameDiamond);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_GAMEGIRD:
        begin
          sText := IntToStr(PlayObject2.m_nGameGird);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_HUNGER:
        begin
          sText := IntToStr(PlayObject2.GetMyStatus);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_LOGINTIME:
        begin
          sText := DateTimeToStr(PlayObject2.m_dLogonTime);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_LOGINLONG:
        begin
          sText := IntToStr((GetTickCount - PlayObject2.m_dwLogonTick) div 60000) + '分钟';
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_DRESS:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_DRESS].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_WEAPON:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_WEAPON].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_RIGHTHAND:
        begin
          sText :=
            UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_RIGHTHAND].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_HELMET:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_HELMET].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_HELMETEX:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_HELMETEX].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_NECKLACE:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_NECKLACE].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_RING_R:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_RINGR].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_RING_L:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_RINGL].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_ARMRING_R:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_ARMRINGR].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_ARMRING_L:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_ARMRINGL].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BUJUK:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_BUJUK].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BELT:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_BELT].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_BOOTS:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_BOOTS].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_CHARM:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_CHARM].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_DRUM:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_DRUM].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_HORSE:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_HORSE].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_FASHION:
        begin
          sText := UserEngine.GetStdItemName(PlayObject2.m_UseItems[U_FASHION].wIndex);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_HWID:
        begin
          sText := MD5.MD5Print(PlayObject2.m_xHWID);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_IPADDR:
        begin
          sText := PlayObject.m_sIPaddr;
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_IPLOCAL:
        begin
{$IF EXPIPLOCAL=1}
          sText := GetIPLocal(PlayObject.m_sIPaddr);
{$ELSE}
          sText := PlayObject.m_sIPLocal;
{$IFEND}
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      v_GUILDBUILDPOINT:
        begin
          if PlayObject.m_MyGuild = nil then
          begin
            sText := '无';
          end
          else
          begin
            sText := IntToStr(TGuild(PlayObject.m_MyGuild).nBuildPoint);
          end;
          sMsg := ExVariableText(sMsg, '<$GUILDBUILDPOINT>', sText);
        end;
      v_GUILDAURAEPOINT:
        begin
          if PlayObject.m_MyGuild = nil then
          begin
            sText := '无';
          end
          else
          begin
            sText := IntToStr(TGuild(PlayObject.m_MyGuild).nAurae);
          end;
          sMsg := ExVariableText(sMsg, '<$GUILDAURAEPOINT>', sText);
        end;
      v_GUILDSTABILITYPOINT:
        begin
          if PlayObject.m_MyGuild = nil then
          begin
            sText := '无';
          end
          else
          begin
            sText := IntToStr(TGuild(PlayObject.m_MyGuild).nStability);
          end;
          sMsg := ExVariableText(sMsg, '<$GUILDSTABILITYPOINT>', sText);
        end;
      v_GUILDFLOURISHPOINT:
        begin
          if PlayObject.m_MyGuild = nil then
          begin
            sText := '无';
          end
          else
          begin
            sText := IntToStr(TGuild(PlayObject.m_MyGuild).nFlourishing);
          end;
          sMsg := ExVariableText(sMsg, '<$GUILDFLOURISHPOINT>', sText);
        end;
      v_REQUESTCASTLEWARITEM:
        begin
          sText := g_Config.sZumaPiece;
          sMsg := ExVariableText(sMsg, '<$REQUESTCASTLEWARITEM>', sText);
        end;
      v_REQUESTCASTLEWARDAY:
        begin
          sText := g_Config.sZumaPiece;
          sMsg := ExVariableText(sMsg, '<$REQUESTCASTLEWARDAY>', sText);
        end;
      v_REQUESTBUILDGUILDITEM:
        begin
          sText := g_Config.sWomaHorn;
          sMsg := ExVariableText(sMsg, '<$REQUESTBUILDGUILDITEM>', sText);
        end;
      v_OWNERGUILD:
        begin
          if m_Castle <> nil then
          begin
            sText := TUserCastle(m_Castle).m_sOwnGuild;
            if sText = '' then
              sText := '游戏管理';
          end
          else
          begin
            sText := '????';
          end;
          sMsg := ExVariableText(sMsg, '<$OWNERGUILD>', sText);
        end;

      v_CASTLENAME:
        begin
          if m_Castle <> nil then
          begin
            sText := TUserCastle(m_Castle).m_sName;
          end
          else
          begin
            sText := '????';
          end;
          sMsg := ExVariableText(sMsg, '<$CASTLENAME>', sText);
        end;
      v_LORD:
        begin
          if m_Castle <> nil then
          begin
            if TUserCastle(m_Castle).m_MasterGuild <> nil then
            begin
              sText := TUserCastle(m_Castle).m_MasterGuild.GetChiefName();
            end
            else
              sText := '管理员';
          end
          else
          begin
            sText := '????';
          end;
          sMsg := ExVariableText(sMsg, '<$LORD>', sText);
        end;
      v_GUILDWARFEE:
        begin
          sMsg := ExVariableText(sMsg, '<$GUILDWARFEE>', IntToStr(g_Config.nGuildWarPrice));
        end;
      v_BUILDGUILDFEE:
        begin
          sMsg := ExVariableText(sMsg, '<$BUILDGUILDFEE>', IntToStr(g_Config.nBuildGuildPrice));
        end;
      v_CASTLEWARDATE:
        begin
          if m_Castle = nil then
            m_Castle := g_CastleManager.GetCastle(0);
          if m_Castle <> nil then
          begin
            if not TUserCastle(m_Castle).m_boUnderWar then
            begin
              sText := TUserCastle(m_Castle).GetWarDate();
              if sText <> '' then
                sMsg := ExVariableText(sMsg, '<$CASTLEWARDATE>', sText)
              else
                sMsg := '暂时没有行会攻城！\ \<返回/@main>';
            end
            else
              sMsg := '现正在攻城中！\ \<返回/@main>';
          end
          else
            sText := '????';
        end;
      v_LISTOFWAR:
        begin
          if m_Castle <> nil then
            sText := TUserCastle(m_Castle).GetAttackWarList()
          else
            sText := '????';
          if sText <> '' then
            sMsg := ExVariableText(sMsg, '<$LISTOFWAR>', sText)
          else
            sMsg := '现在没有行会申请攻城战\ \<返回/@main>';
        end;
      v_CASTLECHANGEDATE:
        begin
          if m_Castle <> nil then
            sText := DateTimeToStr(TUserCastle(m_Castle).m_ChangeDate)
          else
            sText := '????';
          sMsg := ExVariableText(sMsg, '<$CASTLECHANGEDATE>', sText);
        end;
      v_CASTLEWARLASTDATE:
        begin
          if m_Castle <> nil then
            sText := DateTimeToStr(TUserCastle(m_Castle).m_WarDate)
          else
            sText := '????';
          sMsg := ExVariableText(sMsg, '<$CASTLEWARLASTDATE>', sText);
        end;
      v_CASTLEGETDAYS:
        begin
          if m_Castle <> nil then
            sText := IntToStr(GetDayCount(Now, TUserCastle(m_Castle).m_ChangeDate))
          else
            sText := '????';
          sMsg := ExVariableText(sMsg, '<$CASTLEGETDAYS>', sText);
        end;
      v_CMD_DATE:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_DATE>', g_GameCommand.Data.sCmd);
        end;
      v_CMD_ALLOWMSG:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_ALLOWMSG>', g_GameCommand.ALLOWMSG.sCmd);
        end;
      v_CMD_LETSHOUT:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_LETSHOUT>', g_GameCommand.LETSHOUT.sCmd);
        end;
      v_CMD_LETTRADE:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_LETTRADE>', g_GameCommand.LETTRADE.sCmd);
        end;
      v_CMD_LETGUILD:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_LETGUILD>', g_GameCommand.LETGUILD.sCmd);
        end;
      v_CMD_ENDGUILD:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_ENDGUILD>', g_GameCommand.ENDGUILD.sCmd);
        end;
      v_CMD_BANGUILDCHAT:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_BANGUILDCHAT>', g_GameCommand.BANGUILDCHAT.sCmd);
        end;
      v_CMD_AUTHALLY:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_AUTHALLY>', g_GameCommand.AUTHALLY.sCmd);
        end;
      v_CMD_AUTH:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_AUTH>', g_GameCommand.AUTH.sCmd);
        end;
      v_CMD_AUTHCANCEL:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_AUTHCANCEL>', g_GameCommand.AUTHCANCEL.sCmd);
        end;
      v_CMD_USERMOVE:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_USERMOVE>', g_GameCommand.USERMOVE.sCmd);
        end;
      v_CMD_SEARCHING:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_SEARCHING>', g_GameCommand.SEARCHING.sCmd);
        end;
      v_CMD_ALLOWGROUPCALL:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_ALLOWGROUPCALL>', g_GameCommand.ALLOWGROUPCALL.sCmd);
        end;
      v_CMD_GROUPRECALLL:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_GROUPRECALLL>', g_GameCommand.GROUPRECALLL.sCmd);
        end;
      v_CMD_ATTACKMODE:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_ATTACKMODE>', g_GameCommand.ATTACKMODE.sCmd);
        end;
      v_CMD_REST:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_REST>', g_GameCommand.REST.sCmd);
        end;
      v_CMD_STORAGESETPASSWORD:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_STORAGESETPASSWORD>', g_GameCommand.SETPASSWORD.sCmd);
        end;
      v_CMD_STORAGECHGPASSWORD:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_STORAGECHGPASSWORD>', g_GameCommand.CHGPASSWORD.sCmd);
        end;
      v_CMD_STORAGELOCK:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_STORAGELOCK>', g_GameCommand.Lock.sCmd);
        end;
      v_CMD_STORAGEUNLOCK:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_STORAGEUNLOCK>', g_GameCommand.UNLOCKSTORAGE.sCmd);
        end;
      v_CMD_UNLOCK:
        begin
          sMsg := ExVariableText(sMsg, '<$CMD_UNLOCK>', g_GameCommand.UnLock.sCmd);
        end;
      v_LUCK:
        begin
          sText := IntToStr(PlayObject2.m_nLuck);
          sMsg := ExVariableText(sMsg, Str, sText);
        end;
      V_CurItemName:  
        begin
          sMsg := ExVariableText(sMsg, '<$CurItemName>', PlayObject.m_CurItemName);
        end;
      V_CurItemIdx:
        begin
          sMsg := ExVariableText(sMsg, '<$CurItemIdx>', IntToStr(PlayObject.m_CurItemIdx));
        end;

    end;
  end
  else
  begin
    Str := Format('<%s>', [sVariable]);

    if CompareLStr(sVariable, '$TAGMAPNAME', Length('$TAGMAPNAME')) then
    begin
      for i := Low(TMakerMapInfo) to High(TMakerMapInfo) do
      begin
        sMAP := '$TAGMAPNAME' + IntToStr(i);
        if sVariable = sMAP then
        begin
          if (PlayObject.m_MakerMapInfo[i].sMapName <> '') then
          begin
            Envir := g_MapManager.FindMap(PlayObject.m_MakerMapInfo[i].sMapName);
            if Envir <> nil then
              sText := Envir.m_sMapDesc
            else
              sText := '未知'
          end
          else
            sText := '未记录';
          sMsg := ExVariableText(sMsg, sMAP, sText);
          Exit;
        end;
      end;
      Exit;
    end;

    if CompareLStr(sVariable, '$TAGX', Length('$TAGX')) then
    begin
      for i := Low(TMakerMapInfo) to High(TMakerMapInfo) do
      begin
        sX := '$TAGX' + IntToStr(i);
        if sVariable = sX then
        begin
          if PlayObject.m_MakerMapInfo[i].wMapX > 0 then
            sText := IntToStr(PlayObject.m_MakerMapInfo[i].wMapX)
          else
            sText := 'X';
          sMsg := ExVariableText(sMsg, sX, sText);
          Exit;
        end;
      end;
      Exit;
    end;

    if CompareLStr(sVariable, '$TAGY', Length('$TAGY')) then
    begin
      for i := Low(TMakerMapInfo) to High(TMakerMapInfo) do
      begin
        sY := '$TAGY' + IntToStr(i);
        if sVariable = sY then
        begin
          if PlayObject.m_MakerMapInfo[i].wMapY > 0 then
            sText := IntToStr(PlayObject.m_MakerMapInfo[i].wMapY)
          else
            sText := 'Y';
          sMsg := ExVariableText(sMsg, sY, sText);
          Exit;
        end;
      end;
      Exit;
    end;

    if CompareLStr(sVariable, '$HUMAN(', Length('$HUMAN(')) then
    begin
      ArrestStringEx(sVariable, '(', ')', s14);
      boFoundVar := False;
      for i := 0 to PlayObject.m_DynamicVarList.Count - 1 do
      begin
        DynamicVar := PlayObject.m_DynamicVarList.Items[i];
        if CompareText(DynamicVar.sName, s14) = 0 then
        begin
          case DynamicVar.VarType of
            vInteger:
              begin
                sMsg := ExVariableText(sMsg, Str, IntToStr(DynamicVar.nInternet));
                boFoundVar := True;
              end;
            vString:
              begin
                sMsg := ExVariableText(sMsg, Str, DynamicVar.sString);
                boFoundVar := True;
              end;
          end;
          Break;
        end;
      end;
      if not boFoundVar then
        sMsg := ExVariableText(sMsg, Str, '???');
      Exit;
    end;

    if CompareLStr(sVariable, '$H.HUMAN(', Length('$H.HUMAN(')) then
    begin
      Hero := PlayObject.GetHeroObjectA;
      if Hero = nil then
      begin
        sMsg := ExVariableText(sMsg, Str, '???');
        Exit;
      end;
      PlayObject2 := Hero as TPlayObject;

      ArrestStringEx(sVariable, '(', ')', s14);
      boFoundVar := False;
      for i := 0 to PlayObject2.m_DynamicVarList.Count - 1 do
      begin
        DynamicVar := PlayObject2.m_DynamicVarList.Items[i];
        if CompareText(DynamicVar.sName, s14) = 0 then
        begin
          case DynamicVar.VarType of
            vInteger:
              begin
                sMsg := ExVariableText(sMsg, Str, IntToStr(DynamicVar.nInternet));
                boFoundVar := True;
              end;
            vString:
              begin
                sMsg := ExVariableText(sMsg, Str, DynamicVar.sString);
                boFoundVar := True;
              end;
          end;
          Break;
        end;
      end;
      if not boFoundVar then
        sMsg := ExVariableText(sMsg, Str, '???');
      Exit;
    end;

    if CompareLStr(sVariable, '$GUILD(', Length('$GUILD(')) then
    begin
      if PlayObject.m_MyGuild = nil then
        Exit;
      ArrestStringEx(sVariable, '(', ')', s14);
      boFoundVar := False;
      for i := 0 to TGuild(PlayObject.m_MyGuild).m_DynamicVarList.Count - 1 do
      begin
        DynamicVar := TGuild(PlayObject.m_MyGuild).m_DynamicVarList.Items[i];
        if CompareText(DynamicVar.sName, s14) = 0 then
        begin
          case DynamicVar.VarType of
            vInteger:
              begin
                sMsg := ExVariableText(sMsg, Str, IntToStr(DynamicVar.nInternet));
                boFoundVar := True;
              end;
            vString:
              begin
                sMsg := ExVariableText(sMsg, Str, DynamicVar.sString);
                boFoundVar := True;
              end;
          end;
          Break;
        end;
      end;
      if not boFoundVar then
        sMsg := ExVariableText(sMsg, Str, '???');
      Exit;
    end;

    if CompareLStr(sVariable, '$GLOBAL(', Length('$GLOBAL(')) then
    begin
      ArrestStringEx(sVariable, '(', ')', s14);
      boFoundVar := False;
      for i := 0 to g_DynamicVarList.Count - 1 do
      begin
        DynamicVar := g_DynamicVarList.Items[i];
        if CompareText(DynamicVar.sName, s14) = 0 then
        begin
          case DynamicVar.VarType of
            vInteger:
              begin
                sMsg := ExVariableText(sMsg, Str, IntToStr(DynamicVar.nInternet));
                boFoundVar := True;
              end;
            vString:
              begin
                sMsg := ExVariableText(sMsg, Str, DynamicVar.sString);
                boFoundVar := True;
              end;
          end;
          Break;
        end;
      end;
      if not boFoundVar then
        sMsg := ExVariableText(sMsg, Str, '???');
      Exit;
    end;

    if CompareLStr(sVariable, '$STR(', Length('$STR(')) then
    begin
      ArrestStringEx(sVariable, '(', ')', s14);
      n18 := GetValNameNo(s14);
      if n18 >= 0 then
      begin
        case n18 of
          000..009: sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject.m_nVal[n18]));
          100..199: sMsg := ExVariableText(sMsg, Str, IntToStr(g_Config.GlobalVal[n18 - 100]));
          200..299: sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject.m_DyVal[n18 - 200]));
          300..399: sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject.m_nMval[n18 - 300]));
          400..499: sMsg := ExVariableText(sMsg, Str, IntToStr(g_Config.GlobaDyMval[n18 - 400]));
          500..599: sMsg := ExVariableText(sMsg, Str, g_Config.GlobaDyTval[n18 - 500]);
          600..699: sMsg := ExVariableText(sMsg, Str, PlayObject.m_nSval[n18 - 600]);
          700..799: sMsg := ExVariableText(sMsg, Str, IntToStr(g_Config.HGlobalVal[n18 - 700]));
        end;
      end
      else
        sMsg := ExVariableText(sMsg, Str, '???');
      Exit;
    end;

    if CompareLStr(sVariable, '$H.STR(', Length('$H.STR(')) then
    begin
      Hero := PlayObject.GetHeroObjectA;
      if Hero = nil then
      begin
        sMsg := ExVariableText(sMsg, Str, '???');
        Exit;
      end;
      PlayObject2 := Hero as TPlayObject;

      ArrestStringEx(sVariable, '(', ')', s14);
      n18 := GetValNameNo(s14);
      if n18 >= 0 then
      begin
        case n18 of
          000..009: sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_nVal[n18]));
          100..199: sMsg := ExVariableText(sMsg, Str, IntToStr(g_Config.GlobalVal[n18 - 100]));
          200..299: sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_DyVal[n18 - 200]));
          300..399: sMsg := ExVariableText(sMsg, Str, IntToStr(PlayObject2.m_nMval[n18 - 300]));
          400..499: sMsg := ExVariableText(sMsg, Str, IntToStr(g_Config.GlobaDyMval[n18 - 400]));
          500..599: sMsg := ExVariableText(sMsg, Str, g_Config.GlobaDyTval[n18 - 500]);
          600..699: sMsg := ExVariableText(sMsg, Str, PlayObject2.m_nSval[n18 - 600]);
          700..799: sMsg := ExVariableText(sMsg, Str, IntToStr(g_Config.HGlobalVal[n18 - 700]));
        end;
      end;
      Exit;
    end;

    if CompareLStr(sVariable, '$PARAM(', Length('$PARAM(')) then
    begin
      ArrestStringEx(sVariable, '(', ')', s14);
      n18 := Str_ToInt(s14, -1);
      if n18 >= 0 then
      begin
        case n18 of
          000..007: sMsg := ExVariableText(sMsg, '<' + sVariable + '>', PlayObject.m_sCmdParams[n18]);
        end;
      end;
    end;
  end;
end;

procedure TNormNpc.GotoLable(ActObject: TPlayObject; sLabel: string; boExtJmp: Boolean; sMsg: string = '');
var
  i, ii, III: Integer;
  ListBatch: TStringList;
  boCheckOK: Boolean;
  nBatch: Integer;
  sSENDMSG: string;
  Script: pTScript;
  Script3C: pTScript;
  SayingRecord: pTSayingRecord;
  SayingProcedure: pTSayingProcedure;
  UserItem: pTUserItem;
  s, SC, s14: string;
  HeroObject: TBaseObject;
  PlayObject: TPlayObject;
  tQuestUser, tqu: TPlayObject;

  function CheckQuestStatus(ScriptInfo: pTScript): Boolean;
  var
    i: Integer;
  begin
    Result := True;
    if not ScriptInfo.boQuest then
      Exit;
    i := 0;
    while (True) do
    begin
      if (ScriptInfo.QuestInfo[i].nRandRage > 0) and
        (Random(ScriptInfo.QuestInfo[i].nRandRage) <> 0) then
      begin
        Result := False;
        Break;
      end;
      if PlayObject.GetQuestFalgStatus(ScriptInfo.QuestInfo[i].wFlag) <> ScriptInfo.QuestInfo[i].btValue then
      begin
        Result := False;
        Break;
      end;
      Inc(i);
      if i >= 10 then
        Break;
    end;
  end;

  function QuestCheckCondition(ConditionList: TList; OprateObject: TPlayObject; QActObject: TPlayObject): Boolean;
  var
    Hour, Min, Sec, MSec: Word;
    s50: string;
    i, n10, n14, n18, n1C: Integer;
    nMaxDura, nDura: Integer;
    StdItem: pTStdItem;
    Envir: TEnvirnoment;
    QuestConditionInfo: pTQuestConditionInfo;
    Human: TPlayObject;
    PlayObject: TPlayObject;

    function CheckItemW(sItemType: string; nParam: Integer): pTUserItem;
    var
      nCount: Integer;
    begin
      Result := nil;
      if CompareLStr(sItemType, '[NECKLACE]', 4) then
      begin
        if PlayObject.m_UseItems[U_NECKLACE].wIndex > 0 then
        begin
          Result := @PlayObject.m_UseItems[U_NECKLACE];
        end;
        Exit;
      end;
      if CompareLStr(sItemType, '[RING]', 4) then
      begin
        if PlayObject.m_UseItems[U_RINGL].wIndex > 0 then
        begin
          Result := @PlayObject.m_UseItems[U_RINGL];
        end;
        if PlayObject.m_UseItems[U_RINGR].wIndex > 0 then
        begin
          Result := @PlayObject.m_UseItems[U_RINGR];
        end;
        Exit;
      end;
      if CompareLStr(sItemType, '[ARMRING]', 4) then
      begin
        if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then
        begin
          Result := @PlayObject.m_UseItems[U_ARMRINGL];
        end;
        if PlayObject.m_UseItems[U_ARMRINGR].wIndex > 0 then
        begin
          Result := @PlayObject.m_UseItems[U_ARMRINGR];
        end;
        Exit;
      end;
      if CompareLStr(sItemType, '[WEAPON]', 4) then
      begin
        if PlayObject.m_UseItems[U_WEAPON].wIndex > 0 then
        begin
          Result := @PlayObject.m_UseItems[U_WEAPON];
        end;
        Exit;
      end;
      if CompareLStr(sItemType, '[HELMET]', 4) then
      begin
        if PlayObject.m_UseItems[U_HELMET].wIndex > 0 then
        begin
          Result := @PlayObject.m_UseItems[U_HELMET];
        end;
        Exit;
      end;
      if CompareLStr(sItemType, '[HELMETEX]', 4) then
      begin
        if PlayObject.m_UseItems[U_HELMETEX].wIndex > 0 then
        begin
          Result := @PlayObject.m_UseItems[U_HELMETEX];
        end;
        Exit;
      end;
      Result := PlayObject.sub_4C4CD4(sItemType, nCount);
      if nCount < nParam then
        Result := nil;
    end;

    function CheckStringList(sHumName, sListFileName: string): Boolean;
    var
      i: Integer;
      LoadList: TStringList;
    begin
      Result := False;
      sListFileName := g_Config.sEnvirDir + sListFileName;
      if FileExists(sListFileName) then
      begin
        LoadList := TStringList.Create;
        try
          LoadList.LoadFromFile(sListFileName);
        except
          MainOutMessageAPI('loading fail.... => ' + sListFileName);
        end;
        for i := 0 to LoadList.Count - 1 do
        begin
          if CompareText(Trim(LoadList.Strings[i]), sHumName) = 0 then
          begin
            Result := True;
            Break;
          end;
        end;
        LoadList.Free;
      end
      else
        MainOutMessageAPI('file not found => ' + sListFileName);
    end;

    procedure SetVal(sIndex: string; nCount: Integer);
    var
      n14: Integer;
    begin
      n14 := GetValNameNo(sIndex);
      if n14 >= 0 then
      begin
        case n14 of
          000..009: PlayObject.m_nVal[n14] := nCount;
          100..199: g_Config.GlobalVal[n14 - 100] := nCount;
          200..299: PlayObject.m_DyVal[n14 - 200] := nCount;
          300..399: PlayObject.m_nMval[n14 - 300] := nCount;
          400..499: g_Config.GlobaDyMval[n14 - 400] := nCount;
          500..599: g_Config.GlobaDyTval[n14 - 500] := IntToStr(nCount);
          600..699: PlayObject.m_nSval[n14 - 600] := IntToStr(nCount);
          700..799: g_Config.HGlobalVal[n14 - 700] := nCount;
        end;
      end;
    end;

    function CheckDieMon(MonName: string): Boolean;
    begin
      Result := False;
      if MonName = '' then
        Result := True;
      if (PlayObject.m_LastHiter <> nil) and (PlayObject.m_LastHiter.m_sCharName = MonName) then
        Result := True;
    end;

    function CheckKillMon(MonName: string): Boolean;
    begin
      Result := False;
      if MonName = '' then
        Result := True;
      if (PlayObject.m_TargetCret <> nil) and (PlayObject.m_TargetCret.m_sCharName = MonName) then
        Result := True;
    end;

    function CheckMagicName(MagicName: string): Boolean;
    var
      i: Integer;
    begin
      Result := False;
      with PlayObject do
      begin
        for i := 0 to m_MagicList.Count - 1 do
        begin
          if (pTUserMagic(m_MagicList.Items[i]).MagicInfo.sMagicName = MagicName) then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;

    end;

    function CheckMagicLevel(MagicName: string; which: string; Level: Integer): Boolean;
    var
      i: Integer;
    begin
      Result := False;
      with PlayObject do
      begin
        for i := 0 to m_MagicList.Count - 1 do
        begin
          if (pTUserMagic(m_MagicList.Items[i]).MagicInfo.sMagicName = MagicName) then
          begin
            if which = '=' then
            begin
              if (pTUserMagic(m_MagicList.Items[i]).btLevel = Level) then
                Result := True;
            end;
            if which = '>' then
            begin
              if (pTUserMagic(m_MagicList.Items[i]).btLevel > Level) then
                Result := True;
            end;
            if which = '>=' then
            begin
              if (pTUserMagic(m_MagicList.Items[i]).btLevel >= Level) then
                Result := True;
            end;
            if which = '<' then
            begin
              if (pTUserMagic(m_MagicList.Items[i]).btLevel < Level) then
                Result := True;
            end;
            if which = '<=' then
            begin
              if (pTUserMagic(m_MagicList.Items[i]).btLevel <= Level) then
                Result := True;
            end;
            if which = '<>' then
            begin
              if (pTUserMagic(m_MagicList.Items[i]).btLevel <> Level) then
                Result := True;
            end;
            Exit;
          end;
        end;
      end;
    end;

    function CheckISGROUPMASTER(): Boolean;
    begin
      Result := False;
      if PlayObject.m_GroupOwner = PlayObject then
        Result := True;
    end;

    function CheckCodeList(sListFileName, CardNo: string): Boolean;
    var
      LoadList: TStringList;
      sText: string;
      i: Integer;
    begin
      Result := False;
      sListFileName := g_Config.sEnvirDir + sListFileName;
      LoadList := TStringList.Create;
      if FileExists(sListFileName) then
      begin
        try
          LoadList.LoadFromFile(sListFileName);
          for i := 0 to LoadList.Count - 1 do
          begin
            sText := Trim(LoadList[i]);
            if sText = CardNo then
            begin
              Result := True;
              Break;
            end;
          end;
        except
          MainOutMessageAPI('loading fail.... => ' + sListFileName);
        end;
      end;
      LoadList.Free;
    end;

    function CheckRandomNo(sNumber: string): Boolean;
    begin
      Result := False;
      if PlayObject.m_sRandomNo = sNumber then
        Result := True;
    end;

    function CheckUserDateType(CharName: string; sListFileName, sMethod, sDay, param1, param2: string): Boolean;
    var
      nDay: Integer;
      UseDay, LastDay: Integer;
      nnday: TDateTime;
      i: Integer;
      LoadList: TStringList;
      sText, Name, ssDay: string;
    begin
      Result := False;
      sListFileName := g_Config.sEnvirDir + sListFileName;
      LoadList := TStringList.Create;
      if FileExists(sListFileName) then
      begin
        try
          LoadList.LoadFromFile(sListFileName);
        except
          MainOutMessageAPI('loading fail.... => ' + sListFileName);
        end;
      end;
      nDay := Str_ToInt(sDay, 0);
      for i := 0 to LoadList.Count - 1 do
      begin
        sText := Trim(LoadList[i]);
        sText := GetValidStrCap(sText, Name, [' ', #9]);
        Name := Trim(Name);
        if CharName = Name then
        begin
          ssDay := Trim(sText);
          nnday := Str_ToDate(ssDay);
          UseDay := Round(Date - nnday);
          LastDay := nDay - UseDay;
          case sMethod[1] of
            '=': if LastDay = 0 then
                Result := True;
            '<': if LastDay > 0 then
                Result := True;
            '>': if LastDay < 0 then
              begin
                Result := True;
                LastDay := 0;
              end;
          else if LastDay <= 0 then
            Result := True;
          end;
          SetVal(param1, UseDay);
          SetVal(param2, LastDay);
          Break;
        end;
      end;
      LoadList.Free;
    end;

  begin
    Result := True;
    QuestConditionInfo := nil;
    PlayObject := OprateObject;
    New(QuestConditionInfo);
    try
      for i := 0 to ConditionList.Count - 1 do
      begin
        PlayObject := OprateObject;
        QuestConditionInfo^ := pTQuestConditionInfo(ConditionList.Items[i])^;
        if (QuestConditionInfo.sParam1 <> '') then
        begin
          if (QuestConditionInfo.sParam1[1] = '$') then
          begin
            s50 := QuestConditionInfo.sParam1;
            QuestConditionInfo.sParam1 := '<' + QuestConditionInfo.sParam1 + '>';
            GetVariableText(PlayObject, QuestConditionInfo.sParam1, s50);
          end
          else if Pos('>', QuestConditionInfo.sParam1) > 0 then
            QuestConditionInfo.sParam1 := GetLineVariableText(PlayObject, QuestConditionInfo.sParam1);
        end;
        if (QuestConditionInfo.sParam2 <> '') then
        begin
          if (QuestConditionInfo.sParam2[1] = '$') then
          begin
            s50 := QuestConditionInfo.sParam2;
            QuestConditionInfo.sParam2 := '<' + QuestConditionInfo.sParam2 + '>';
            GetVariableText(PlayObject, QuestConditionInfo.sParam2, s50);
          end
          else if Pos('>', QuestConditionInfo.sParam2) > 0 then
            QuestConditionInfo.sParam2 := GetLineVariableText(PlayObject, QuestConditionInfo.sParam2);
        end;
        if (QuestConditionInfo.sParam3 <> '') then
        begin
          if (QuestConditionInfo.sParam3[1] = '$') then
          begin
            s50 := QuestConditionInfo.sParam3;
            QuestConditionInfo.sParam3 := '<' + QuestConditionInfo.sParam3 + '>';
            GetVariableText(PlayObject, QuestConditionInfo.sParam3, s50);
          end
          else if Pos('>', QuestConditionInfo.sParam3) > 0 then
            QuestConditionInfo.sParam3 := GetLineVariableText(PlayObject, QuestConditionInfo.sParam3);
        end;
        if (QuestConditionInfo.sParam4 <> '') then
        begin
          if (QuestConditionInfo.sParam4[1] = '$') then
          begin
            s50 := QuestConditionInfo.sParam4;
            QuestConditionInfo.sParam4 := '<' + QuestConditionInfo.sParam4 + '>';
            GetVariableText(PlayObject, QuestConditionInfo.sParam4, s50);
          end
          else if Pos('>', QuestConditionInfo.sParam4) > 0 then
            QuestConditionInfo.sParam4 := GetLineVariableText(PlayObject, QuestConditionInfo.sParam4);
        end;
        if (QuestConditionInfo.sParam5 <> '') then
        begin
          if (QuestConditionInfo.sParam5[1] = '$') then
          begin
            s50 := QuestConditionInfo.sParam5;
            QuestConditionInfo.sParam5 := '<' + QuestConditionInfo.sParam5 + '>';
            GetVariableText(PlayObject, QuestConditionInfo.sParam5, s50);
          end
          else if Pos('>', QuestConditionInfo.sParam5) > 0 then
            QuestConditionInfo.sParam5 := GetLineVariableText(PlayObject, QuestConditionInfo.sParam5);
        end;
        if (QuestConditionInfo.sParam6 <> '') then
        begin
          if (QuestConditionInfo.sParam6[1] = '$') then
          begin
            s50 := QuestConditionInfo.sParam6;
            QuestConditionInfo.sParam6 := '<' + QuestConditionInfo.sParam6 + '>';
            GetVariableText(PlayObject, QuestConditionInfo.sParam6, s50);
          end
          else if Pos('>', QuestConditionInfo.sParam6) > 0 then
            QuestConditionInfo.sParam6 := GetLineVariableText(PlayObject, QuestConditionInfo.sParam6);
        end;

        //参数变量解释以主执行人物为依据
        if (QuestConditionInfo.sOpName <> '') then
        begin
          if (Length(QuestConditionInfo.sOpName) > 2) then
          begin
            if (QuestConditionInfo.sOpName[1] = '$') then
            begin
              s50 := QuestConditionInfo.sOpName;
              QuestConditionInfo.sOpName := '<' + QuestConditionInfo.sOpName + '>';
              GetVariableText(PlayObject, QuestConditionInfo.sOpName, s50);
            end
            else if Pos('>', QuestConditionInfo.sOpName) > 0 then
              QuestConditionInfo.sOpName := GetLineVariableText(PlayObject, QuestConditionInfo.sOpName);
            Human := UserEngine.GetPlayObject(QuestConditionInfo.sOpName);
            if Human <> nil then
            begin
              PlayObject := Human;
              if (QuestConditionInfo.sOpHName <> '') and (QuestConditionInfo.sOpHName = 'H') then
              begin
                Human := TPlayObject(PlayObject.GetHeroObjectA);
                if (Human <> nil) then
                begin
                  PlayObject := Human;
                end
                else
                begin
                  Result := False;
                  Break;
                end;
              end;
            end
            else
            begin
              Result := False;
              Break;
            end;
          end
          else if CompareText(QuestConditionInfo.sOpName, 'H') = 0 then
          begin
            Human := TPlayObject(PlayObject.GetHeroObjectA);
            if (Human <> nil) then
            begin
              PlayObject := Human;
            end
            else
            begin
              Result := False;
              Break;
            end;
          end;
        end;

        if IsStringNumber(QuestConditionInfo.sParam1) then
          QuestConditionInfo.nParam1 := Str_ToInt(QuestConditionInfo.sParam1, 0);
        if IsStringNumber(QuestConditionInfo.sParam2) then
          QuestConditionInfo.nParam2 := Str_ToInt(QuestConditionInfo.sParam2, 0);    
        if IsStringNumber(QuestConditionInfo.sParam3) then
          QuestConditionInfo.nParam3 := Str_ToInt(QuestConditionInfo.sParam3, 0);   
        if IsStringNumber(QuestConditionInfo.sParam4) then
          QuestConditionInfo.nParam4 := Str_ToInt(QuestConditionInfo.sParam4, 0);
        if IsStringNumber(QuestConditionInfo.sParam5) then
          QuestConditionInfo.nParam5 := Str_ToInt(QuestConditionInfo.sParam5, 0);
        if IsStringNumber(QuestConditionInfo.sParam6) then
          QuestConditionInfo.nParam6 := Str_ToInt(QuestConditionInfo.sParam6, 0);
        case QuestConditionInfo.nCMDCode of
          nSc_checkcastlewar: Result := TUserCastle(g_CastleManager.GetCastle(0)).m_boUnderWar;
          nCheckCodeList: Result := CheckCodeList(m_sPath + QuestConditionInfo.sParam1, sMsg);
          nSC_CHECKRANDOMNO: Result := CheckRandomNo(sMsg);
          nCheckDiemon: Result := CheckDieMon(QuestConditionInfo.sParam1);
          ncheckkillplaymon: Result := CheckKillMon(QuestConditionInfo.sParam1);
          nSC_CHECKMAGICNAME: Result := CheckMagicName(QuestConditionInfo.sParam1);
          nSC_CHECKMAGICLEVEL: Result := CheckMagicLevel(QuestConditionInfo.sParam1, QuestConditionInfo.sParam2, QuestConditionInfo.nParam3);
          nSC_CHEckISGROUPMASTER: Result := CheckISGROUPMASTER();
          nCHECKUSERDATE:
            begin
              Result := CheckUserDateType(PlayObject.m_sCharName,
                m_sPath + QuestConditionInfo.sParam1,
                QuestConditionInfo.sParam2,
                QuestConditionInfo.sParam3,
                QuestConditionInfo.sParam4,
                QuestConditionInfo.sParam5);
            end;
          nCHECK:
            begin
              n14 := Str_ToInt(QuestConditionInfo.sParam1, 0);
              n18 := Str_ToInt(QuestConditionInfo.sParam2, 0);
              n10 := PlayObject.GetQuestFalgStatus(n14);
              if n10 = 0 then
              begin
                if n18 <> 0 then
                  Result := False;
              end
              else
              begin
                if n18 = 0 then
                  Result := False;
              end;
            end;
          nRANDOM:
            begin
              if Random(QuestConditionInfo.nParam1) <> 0 then
                Result := False;
            end;
          nGENDER:
            begin
              if CompareText(QuestConditionInfo.sParam1, sMAN) = 0 then
              begin
                if PlayObject.m_btGender <> 0 then
                  Result := False;
              end
              else
              begin
                if PlayObject.m_btGender <> 1 then
                  Result := False;
              end;
            end;
          nDAYTIME:
            begin
              if CompareText(QuestConditionInfo.sParam1, sSUNRAISE) = 0 then
              begin
                if g_nGameTime <> 0 then
                  Result := False;
              end;
              if CompareText(QuestConditionInfo.sParam1, sDay) = 0 then
              begin
                if g_nGameTime <> 1 then
                  Result := False;
              end;
              if CompareText(QuestConditionInfo.sParam1, sSUNSET) = 0 then
              begin
                if g_nGameTime <> 2 then
                  Result := False;
              end;
              if CompareText(QuestConditionInfo.sParam1, sNIGHT) = 0 then
              begin
                if g_nGameTime <> 3 then
                  Result := False;
              end;
            end;
          nCHECKOPEN:
            begin
              n14 := Str_ToInt(QuestConditionInfo.sParam1, 0);
              n18 := Str_ToInt(QuestConditionInfo.sParam2, 0);
              n10 := PlayObject.GetQuestUnitOpenStatus(n14);
              if n10 = 0 then
              begin
                if n18 <> 0 then
                  Result := False;
              end
              else
              begin
                if n18 = 0 then
                  Result := False;
              end;
            end;
          nCHECKUNIT:
            begin
              n14 := Str_ToInt(QuestConditionInfo.sParam1, 0);
              n18 := Str_ToInt(QuestConditionInfo.sParam2, 0);
              n10 := PlayObject.GetQuestUnitStatus(n14);
              if n10 = 0 then
              begin
                if n18 <> 0 then
                  Result := False;
              end
              else
              begin
                if n18 = 0 then
                  Result := False;
              end;
            end;
          nCHECKLEVEL:
            begin
              if PlayObject.m_Abil.Level < QuestConditionInfo.nParam1 then
                Result := False;
            end;
          nCHECKJOB:
            begin
              if CompareLStr(QuestConditionInfo.sParam1, sWARRIOR, 3) then
              begin
                if PlayObject.m_btJob <> 0 then
                  Result := False;
              end;
              if CompareLStr(QuestConditionInfo.sParam1, sWIZARD, 3) then
              begin
                if PlayObject.m_btJob <> 1 then
                  Result := False;
              end;
              if CompareLStr(QuestConditionInfo.sParam1, sTAOS, 3) then
              begin
                if PlayObject.m_btJob <> 2 then
                  Result := False;
              end;
            end;
          nSC_CHECKHEROJOB:
            begin
              HeroObject := PlayObject.GetHeroObjectA;
              if HeroObject <> nil then
              begin
                if CompareLStr(QuestConditionInfo.sParam1, sWARRIOR, 3) then
                  if HeroObject.m_btJob <> 0 then
                    Result := False;
                if CompareLStr(QuestConditionInfo.sParam1, sWIZARD, 3) then
                  if HeroObject.m_btJob <> 1 then
                    Result := False;
                if CompareLStr(QuestConditionInfo.sParam1, sTAOS, 3) then
                  if HeroObject.m_btJob <> 2 then
                    Result := False;
              end;
            end;

          nCHECKBBCOUNT: if PlayObject.m_SlaveList.Count < QuestConditionInfo.nParam1 then
              Result := False;
          nCHECKITEM:
            begin
              UserItem := PlayObject.QuestCheckItem(QuestConditionInfo.sParam1, n1C, nMaxDura, nDura);
              if n1C < Str_ToInt(QuestConditionInfo.sParam2, 1) then
                Result := False;
            end;
          nCHECKITEMW:
            begin
              UserItem := CheckItemW(QuestConditionInfo.sParam1, QuestConditionInfo.nParam2);
              if UserItem = nil then
                Result := False;
            end;
          nCHECKGOLD:
            begin
              s14 := QuestConditionInfo.sParam1;
              n18 := Str_ToInt(s14, -1);
              if PlayObject.m_nGold < n18 then
                Result := False;
            end;
          nISTAKEITEM: if SC <> QuestConditionInfo.sParam1 then
              Result := False;
          nCHECKDURA:
            begin
              UserItem := PlayObject.QuestCheckItem(QuestConditionInfo.sParam1, n1C, nMaxDura, nDura);
              if Round(nDura / 1000) < QuestConditionInfo.nParam2 then
                Result := False;
            end;
          nCHECKDURAEVA:
            begin
              UserItem := PlayObject.QuestCheckItem(QuestConditionInfo.sParam1, n1C, nMaxDura, nDura);
              if n1C > 0 then
              begin
                if Round(nMaxDura / n1C / 1000) < QuestConditionInfo.nParam2 then
                  Result := False;
              end
              else
                Result := False;
            end;
          nSC_CHECKCURRENTDATE: if not ConditionOfCheckCurrentDate(PlayObject, QuestConditionInfo) then
              Result := False;
          nDAYOFWEEK:
            begin
              if CompareLStr(QuestConditionInfo.sParam1, sSUN, Length(sSUN)) then
              begin
                if DayOfWeek(Now) <> 1 then
                  Result := False;
              end;
              if CompareLStr(QuestConditionInfo.sParam1, sMON, Length(sMON)) then
              begin
                if DayOfWeek(Now) <> 2 then
                  Result := False;
              end;
              if CompareLStr(QuestConditionInfo.sParam1, sTUE, Length(sTUE)) then
              begin
                if DayOfWeek(Now) <> 3 then
                  Result := False;
              end;
              if CompareLStr(QuestConditionInfo.sParam1, sWED, Length(sWED)) then
              begin
                if DayOfWeek(Now) <> 4 then
                  Result := False;
              end;
              if CompareLStr(QuestConditionInfo.sParam1, sTHU, Length(sTHU)) then
              begin
                if DayOfWeek(Now) <> 5 then
                  Result := False;
              end;
              if CompareLStr(QuestConditionInfo.sParam1, sFRI, Length(sFRI)) then
              begin
                if DayOfWeek(Now) <> 6 then
                  Result := False;
              end;
              if CompareLStr(QuestConditionInfo.sParam1, sSAT, Length(sSAT)) then
              begin
                if DayOfWeek(Now) <> 7 then
                  Result := False;
              end;
            end;
          nHOUR:
            begin
              if (QuestConditionInfo.nParam1 <> 0) and (QuestConditionInfo.nParam2 = 0) then
                QuestConditionInfo.nParam2 := QuestConditionInfo.nParam1;
              DecodeTime(Time, Hour, Min, Sec, MSec);
              if (Hour < QuestConditionInfo.nParam1) or (Hour > QuestConditionInfo.nParam2) then
                Result := False;
            end;
          nMIN:
            begin
              if (QuestConditionInfo.nParam1 <> 0) and (QuestConditionInfo.nParam2 = 0) then
                QuestConditionInfo.nParam2 := QuestConditionInfo.nParam1;
              DecodeTime(Time, Hour, Min, Sec, MSec);
              if (Min < QuestConditionInfo.nParam1) or (Min > QuestConditionInfo.nParam2) then
                Result := False;
            end;
          nCHECKPKPOINT: if PlayObject.PKLevel < QuestConditionInfo.nParam1 then
              Result := False;
          nSC_CHECKHEROPKPOINT:
            begin
              HeroObject := PlayObject.GetHeroObjectA;
              if HeroObject <> nil then
              begin
                if HeroObject.PKLevel < QuestConditionInfo.nParam1 then
                  Result := False;
              end;
            end;
          nCHECKLUCKYPOINT: if PlayObject.m_nBodyLuckLevel < QuestConditionInfo.nParam1 then
              Result := False;
          nCHECKMONMAP:
            begin
              Envir := g_MapManager.FindMap(QuestConditionInfo.sParam1);
              if Envir <> nil then
              begin
                if UserEngine.GetMapMonster(Envir, nil) < QuestConditionInfo.nParam2 then
                  Result := False;
              end;
            end;
          nCHECKMONAREA: ;
          nCHECKHUM:
            begin
              if UserEngine.GetMapHuman(QuestConditionInfo.sParam1) < QuestConditionInfo.nParam2 then
                Result := False;
            end;
          nCHECKBAGGAGE:
            begin
              if PlayObject.IsEnoughBag then
              begin
                if QuestConditionInfo.sParam1 <> '' then
                begin
                  Result := False;
                  StdItem := UserEngine.GetStdItem(QuestConditionInfo.sParam1);
                  if StdItem <> nil then
                  begin
                    if PlayObject.IsAddWeightAvailable(StdItem.Weight) then
                      Result := True;
                  end;
                end;
              end
              else
                Result := False;
            end;
          nCHECKNAMELIST: if not CheckStringList(PlayObject.m_sCharName, m_sPath + QuestConditionInfo.sParam1) then
              Result := False;
          nCHECKACCOUNTLIST: if not CheckStringList(PlayObject.m_sUserID, m_sPath + QuestConditionInfo.sParam1) then
              Result := False;
          nCHECKIPLIST: if not CheckStringList(PlayObject.m_sIPaddr, m_sPath + QuestConditionInfo.sParam1) then
              Result := False;
          nSC_CHECKSTRINGLIST: if not CheckStringList(QuestConditionInfo.sParam2, m_sPath + QuestConditionInfo.sParam1) then
              Result := False;
          nSC_CHECKMISSION: if not ConditionOfCheckMission(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKTITLE: if not ConditionOfCheckTitle(PlayObject, QuestConditionInfo) then
              Result := False;

          nEQUAL:
            begin
              n10 := GetValNameNo(QuestConditionInfo.sParam1);
              s14 := QuestConditionInfo.sParam2;
              n18 := Str_ToInt(s14, -1) * Str_ToInt(QuestConditionInfo.sParam3, 1);   
              if n10 >= 0 then
              begin
                case n10 of
                  0..9: if PlayObject.m_nVal[n10] <> n18 then
                      Result := False;
                  100..199: if g_Config.GlobalVal[n10 - 100] <> n18 then
                      Result := False;
                  200..299: if PlayObject.m_DyVal[n10 - 200] <> n18 then
                      Result := False;
                  300..399: if PlayObject.m_nMval[n10 - 300] <> n18 then
                      Result := False;
                  400..499: if g_Config.GlobaDyMval[n10 - 400] <> n18 then
                      Result := False;
                  500..599: if g_Config.GlobaDyTval[n10 - 500] <> s14 then
                      Result := False;
                  600..699: if PlayObject.m_nSval[n10 - 600] <> s14 then
                      Result := False;
                  700..799: if g_Config.HGlobalVal[n10 - 700] <> n18 then
                      Result := False;
                end;
              end
              else
                Result := False;
            end;
          nLARGE:
            begin
              n10 := GetValNameNo(QuestConditionInfo.sParam1);
              s14 := QuestConditionInfo.sParam2;
              n18 := Str_ToInt(s14, -1) * Str_ToInt(QuestConditionInfo.sParam3, 1);
              if n10 >= 0 then
              begin
                case n10 of
                  0..9: if PlayObject.m_nVal[n10] <= n18 then
                      Result := False;
                  100..199: if g_Config.GlobalVal[n10 - 100] <= n18 then
                      Result := False;
                  200..299: if PlayObject.m_DyVal[n10 - 200] <= n18 then
                      Result := False;
                  300..399: if PlayObject.m_nMval[n10 - 300] <= n18 then
                      Result := False;
                  400..499: if g_Config.GlobaDyMval[n10 - 400] <= n18 then
                      Result := False;
                  500..599: if Str_ToInt(g_Config.GlobaDyTval[n10 - 500], -1) <= n18 then
                      Result := False;
                  600..699: if Str_ToInt(PlayObject.m_nSval[n10 - 600], -1) <= n18 then
                      Result := False;
                  700..799: if g_Config.HGlobalVal[n10 - 700] <= n18 then
                      Result := False;
                end;
              end
              else
                Result := False;
            end;
          nSMALL:
            begin
              n10 := GetValNameNo(QuestConditionInfo.sParam1);
              s14 := QuestConditionInfo.sParam2;
              n18 := Str_ToInt(s14, -1) * Str_ToInt(QuestConditionInfo.sParam3, 1);
              if n10 >= 0 then
              begin
                case n10 of
                  0..9: if PlayObject.m_nVal[n10] >= n18 then
                      Result := False;
                  100..199: if g_Config.GlobalVal[n10 - 100] >= n18 then
                      Result := False;
                  200..299: if PlayObject.m_DyVal[n10 - 200] >= n18 then
                      Result := False;
                  300..399: if PlayObject.m_nMval[n10 - 300] >= n18 then
                      Result := False;
                  400..499: if g_Config.GlobaDyMval[n10 - 400] >= n18 then
                      Result := False;
                  500..599: if Str_ToInt(g_Config.GlobaDyTval[n10 - 500], -1) >= n18 then
                      Result := False;
                  600..699: if Str_ToInt(PlayObject.m_nSval[n10 - 600], -1) >= n18 then
                      Result := False;
                  700..799: if g_Config.HGlobalVal[n10 - 700] >= n18 then
                      Result := False;
                end;
              end
              else
                Result := False;
            end;
          nSC_ISSYSOP: if not (PlayObject.m_btPermission >= 4) then
              Result := False;
          nSC_ISADMIN: if not (PlayObject.m_btPermission >= 6) then
              Result := False;
          nSC_CHECKGAMEGOLDDEAL: if PlayObject.m_btPostSell = 0 then
              Result := False;
          nSC_CHECKGROUPCOUNT: if not ConditionOfCheckGroupCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKPOSEDIR: if not ConditionOfCheckPoseDir(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKPOSELEVEL: if not ConditionOfCheckPoseLevel(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKPOSEGENDER: if not ConditionOfCheckPoseGender(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKLEVELEX: if not ConditionOfCheckLevelEx(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKIPLEVEL: if not ConditionOfCheckIPLevel(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKHEROLEVEL: if not ConditionOfCheckHeroLevel(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKBONUSPOINT: if not ConditionOfCheckBonusPoint(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMARRY: if not ConditionOfCheckMarry(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKPOSEMARRY: if not ConditionOfCheckPoseMarry(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMARRYCOUNT: if not ConditionOfCheckMarryCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMASTER: if not ConditionOfCheckMaster(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_HAVEMASTER: if not ConditionOfHaveMaster(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKPOSEMASTER: if not ConditionOfCheckPoseMaster(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_POSEHAVEMASTER: if not ConditionOfPoseHaveMaster(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKISMASTER: if not ConditionOfCheckIsMaster(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_HASGUILD: if not ConditionOfCheckHaveGuild(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ISONCASTLEWAR: Result := TUserCastle(g_CastleManager.GetCastle(0)).m_boUnderWar;
          nSC_ISGUILDMASTER: if not ConditionOfCheckIsGuildMaster(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKCASTLEMASTER: if not ConditionOfCheckIsCastleMaster(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ISCASTLEGUILD: if not ConditionOfCheckIsCastleaGuild(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ISATTACKGUILD: if not ConditionOfCheckIsAttackGuild(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ISDEFENSEGUILD: if not ConditionOfCheckIsDefenseGuild(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKCASTLEDOOR: if not ConditionOfCheckCastleDoorStatus(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ISATTACKALLYGUILD: if not ConditionOfCheckIsAttackAllyGuild(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ISDEFENSEALLYGUILD: if not ConditionOfCheckIsDefenseAllyGuild(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKPOSEISMASTER: if not ConditionOfCheckPoseIsMaster(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKNAMEIPLIST: if not ConditionOfCheckNameIPList(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKACCOUNTIPLIST: if not ConditionOfCheckAccountIPList(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKSLAVECOUNT: if not ConditionOfCheckSlaveCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ISNEWHUMAN: if not PlayObject.m_boNewHuman then
              Result := False;
          nSC_CHECKMEMBERTYPE: if not ConditionOfCheckMemberType(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMEMBERLEVEL: if not ConditionOfCheckMemBerLevel(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKGAMEGOLD: if not ConditionOfCheckGameGold(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKNIMBUS: if not ConditionOfCheckNimbus(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKGAMEDIAMOND: if not ConditionOfCheckGameDiamond(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKGAMEGIRD: if not ConditionOfCheckGameGird(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMASTERONLINE: if not ConditionOfCHECKMASTERONLINE(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKDEARONLINE: if not ConditionOfCHECKDEARONLINE(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMASTERONMAP: if not ConditionOfCHECKMASTERONMAP(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKDEARONMAP: if not ConditionOfCHECKDEARONMAP(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKPOSEISPRENTICE: if not ConditionOfCHECKPOSEISPRENTICE(PlayObject, QuestConditionInfo) then
              Result := False;

          nSC_CHECKGAMEPOINT: if not ConditionOfCheckGamePoint(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKNAMELISTPOSITION: if not ConditionOfCheckNameListPostion(PlayObject, QuestConditionInfo) then
              Result := False;

          //nSC_CHECKGUILDLIST:     if not ConditionOfCheckGuildList(PlayObject,QuestConditionInfo) then Result:=False;
          nSC_CHECKGUILDLIST:
            begin
              if PlayObject.m_MyGuild <> nil then
              begin
                if not CheckStringList(TGuild(PlayObject.m_MyGuild).sGuildName, m_sPath + QuestConditionInfo.sParam1) then
                  Result := False;
              end
              else
                Result := False;
            end;
          nSC_CHECKRENEWLEVEL: if not ConditionOfCheckReNewLevel(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKSLAVELEVEL: if not ConditionOfCheckSlaveLevel(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKSLAVENAME: if not ConditionOfCheckSlaveName(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKCREDITPOINT: if not ConditionOfCheckCreditPoint(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKHEROCREDITPOINT: if not ConditionOfCheckHeroCreditPoint(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKOFGUILD: if not ConditionOfCheckOfGuild(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKPAYMENT: if not ConditionOfCheckPayMent(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKUSEITEM: if not ConditionOfCheckUseItem(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKBAGSIZE: if not ConditionOfCheckBagSize(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKLISTCOUNT: if not ConditionOfCheckListCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKDC: if not ConditionOfCheckDC(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMC: if not ConditionOfCheckMC(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKSC: if not ConditionOfCheckSC(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKHP: if not ConditionOfCheckHP(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMP: if not ConditionOfCheckMP(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKITEMTYPE: if not ConditionOfCheckItemType(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKEXP: if not ConditionOfCheckExp(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKCASTLEGOLD: if not ConditionOfCheckCastleGold(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_PASSWORDERRORCOUNT: if not ConditionOfCheckPasswordErrorCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ISLOCKPASSWORD: if not ConditionOfIsLockPassword(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ISLOCKSTORAGE: if not ConditionOfIsLockStorage(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKBUILDPOINT: if not ConditionOfCheckGuildBuildPoint(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKAURAEPOINT: if not ConditionOfCheckGuildAuraePoint(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKSTABILITYPOINT: if not ConditionOfCheckStabilityPoint(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKFLOURISHPOINT: if not ConditionOfCheckFlourishPoint(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKCONTRIBUTION: if not ConditionOfCheckContribution(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKRANGEMONCOUNT: if not ConditionOfCHECKRANGEMONCOUNT(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKRANGEMONCOUNTEX: if not ConditionOfCHECKRANGEMONCOUNTEX(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKITEMADDVALUE: if not ConditionOfCheckItemAddValue(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKINMAPRANGE: if not ConditionOfCheckInMapRange(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CASTLECHANGEDAY: if not ConditionOfCheckCastleChageDay(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CASTLEWARDAY: if not ConditionOfCheckCastleWarDay(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ONLINELONGMIN: if not ConditionOfCheckOnlineLongMin(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKGUILDCHIEFITEMCOUNT: if not ConditionOfCheckChiefItemCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKNAMEDATELIST: if not ConditionOfCheckNameDateList(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMAPHUMANCOUNT: if not ConditionOfCheckMapHumanCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMAPRANGEHUMANCOUNT: if not ConditionOfCheckMapRangeHumanCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKMAPMONCOUNT: if not ConditionOfCHECKMAPMONCOUNT(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKVAR: if not ConditionOfCheckVar(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKSERVERNAME: if not ConditionOfCheckServerName(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_ISHIGH: if not ConditionOfIsHigh(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKISONMAP: if not ConditionOfCheckIsOnMap(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_IsSameGuildOnMap: if not ConditionOfIsSameGuildOnMap(PlayObject, QuestConditionInfo) then
              Result := False;

          nSC_ISDUPMODE: if PlayObject.m_PEnvir.GetXYObjCount(PlayObject.m_nCurrX, PlayObject.m_nCurrY) <= 1 then
              Result := False;
          nSC_INSAFEZONE: if not PlayObject.InSafeZone() then
              Result := False;
          nSC_CHECKDLGITEMADDVALUE: if not ConditionOfCheckDlgItemAddValue(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKDLGITEMTYPE: if not ConditionOfCheckDlgItemType(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKDLGITEMNAME: if not ConditionOfCheckDlgItemName(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKPOSDLGITEMNAME: if not ConditionOfCheckPosDlgItemName(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_GIVEOK: if not ConditionOfGiveItem(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_UNWRAPNIMBUSITEM: if not ConditionOfUnSealItem(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKNIMBUSITEMCOUNT: if not ConditionOfCheckNimbusItemCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKATTACKMODE: if not ConditionOfCheckAttackMode(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKESCORTINNEAR: if not ConditionOfCheckEscortInNear(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_IsEscortIng: if not ConditionOfIsEscortIng(PlayObject, QuestConditionInfo) then
              Result := False;

          nSC_CHECKMAPNIMBUSCOUNT: if not ConditionOfCheckMapNimbusCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKVENATIONLEVEL: if not ConditionOfCheckVenationLevel(PlayObject, QuestConditionInfo) then
              Result := False;

          nSC_KILLBYHUM: if (PlayObject.m_LastHiter <> nil) and ((PlayObject.m_LastHiter.m_btRaceServer <> RC_PLAYOBJECT) and not PlayObject.m_LastHiter.IsHero) then
              Result := False;
          nSC_KILLBYMON: if (PlayObject.m_LastHiter <> nil) and ((PlayObject.m_LastHiter.m_btRaceServer = RC_PLAYOBJECT) or PlayObject.m_LastHiter.IsHero) then
              Result := False;
          nSC_CHECKSIGNMAP: if (PlayObject.m_sMarkerMap = '') or (CompareText(PlayObject.m_sMarkerMap, QuestConditionInfo.sParam1) <> 0) then
              Result := False;
          nSC_CHECKONLINE: if UserEngine.GetPlayObject(QuestConditionInfo.sParam1) = nil then
              Result := False;
          //nSC_CHECKOFFLINEPLAY: : if not ConditionOfCheckOffLinePlay(PlayObject, QuestConditionInfo) then Result := False;
          nSC_OFFLINEPLAYERCOUNT: if not ConditionOfCheckOffLinePlayerCount(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKHEROONLINE: if not ConditionOfCheckHeroOnLine(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_HAVEHERO: if PlayObject.m_sHeroName = '' then
              Result := False;
          nSC_CHECKINISECTIONEXISTS: if not ConditionOfCheckIniSectionExists(PlayObject, QuestConditionInfo) then
              Result := False;
          nSC_CHECKACTIVETITLE: if not ActionOfCheckActiveTitle(PlayObject, QuestConditionInfo) then  Result := False;
          {else if @Engine_SetScriptCondition <> nil then
            Result := Engine_SetScriptCondition(Self, PlayObject,
              QuestConditionInfo.nCMDCode,
              PChar(QuestConditionInfo.sParam1),
              QuestConditionInfo.nParam1,
              PChar(QuestConditionInfo.sParam2),
              QuestConditionInfo.nParam2,
              PChar(QuestConditionInfo.sParam3),
              QuestConditionInfo.nParam3,
              PChar(QuestConditionInfo.sParam4),
              QuestConditionInfo.nParam4,
              PChar(QuestConditionInfo.sParam5),
              QuestConditionInfo.nParam5,
              PChar(QuestConditionInfo.sParam6),
              QuestConditionInfo.nParam6);}
        end;
        if not Result then
          Break;
      end;
    finally
      if QuestConditionInfo <> nil then
      begin //0822
        Dispose(QuestConditionInfo);
        QuestConditionInfo := nil;
      end;
    end;
  end;

  function JmpToLable(sLabel: string): Boolean;
  begin
    Result := False;
    Inc(PlayObject.m_nScriptGotoCount);
    if PlayObject.m_nScriptGotoCount > g_Config.nScriptGotoCountLimit {10} then
      Exit;
    GotoLable(PlayObject, sLabel, False);
    Result := True;
  end;

  procedure GoToQuest(nQuest: Integer);
  var
    i: Integer;
    Script: pTScript;
  begin
    for i := 0 to m_ScriptList.Count - 1 do
    begin
      Script := m_ScriptList.Items[i];
      if Script.nQuest = nQuest then
      begin
        PlayObject.m_Script := Script;
        PlayObject.m_NPC := Self;
        GotoLable(PlayObject, sMAIN, False);
        Break;
      end;
    end;
  end;

  procedure AddUseDateList(sHumName, sListFileName: string); //0049B620
  var
    i: Integer;
    LoadList: TStringList;
    s10, sText: string;
    bo15: Boolean;
  begin
    sListFileName := g_Config.sEnvirDir + sListFileName;
    LoadList := TStringList.Create;
    if FileExists(sListFileName) then
    begin
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessageAPI('loading fail.... => ' + sListFileName);
      end;
    end;
    bo15 := False;
    for i := 0 to LoadList.Count - 1 do
    begin
      sText := Trim(LoadList.Strings[i]);
      sText := GetValidStrCap(sText, s10, [' ', #9]);
      if CompareText(sHumName, s10) = 0 then
      begin
        bo15 := True;
        Break;
      end;
    end;
    if not bo15 then
    begin
      s10 := Format('%s    %s', [sHumName, DateTimeToStr(Date)]);
      LoadList.Add(s10);
      try
        LoadList.SaveToFile(sListFileName);
      except
        MainOutMessageAPI('saving fail.... => ' + sListFileName);
      end;
    end;
    LoadList.Free;
  end;

  procedure Groupmapmove(sMAP, sX, sY, slv, sLabel, sloader, s: string);
  var
    X, Y, nLv: Integer;
    Actor: TPlayObject;
    i: Integer;
    IsOK, br: Boolean;
  begin
    if (sMAP = '') or (PlayObject.m_GroupOwner = nil) then
      Exit;

    IsOK := ((sloader = '') or (PlayObject.m_GroupOwner = PlayObject)); //group master
    if IsOK then
    begin
      X := Str_ToInt(sX, -1);
      Y := Str_ToInt(sY, -1);
      if (X = -1) or (Y = -1) then
        br := True
      else
        br := False;
      nLv := Str_ToInt(slv, -1);
      for i := 0 to PlayObject.m_GroupOwner.m_GroupMembers.Count - 1 do
      begin
        Actor := TPlayObject(PlayObject.m_GroupOwner.m_GroupMembers.Objects[i]);
        if Actor.m_Abil.Level >= nLv then
        begin
          Actor.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
          if br then
            Actor.MapRandomMove(sMAP, 0)
          else
            Actor.SpaceMove(sMAP, X, Y, 0);

          if (g_FunctionNPC <> nil) then
            g_FunctionNPC.GotoLable(Actor, sLabel, False);

        end;
      end;
    end;
  end;

  procedure DelCodeList(sListFileName, CardNo: string);
  var
    LoadList: TStringList;
    sText: string;
    i: Integer;
  begin
    sListFileName := g_Config.sEnvirDir + sListFileName;
    LoadList := TStringList.Create;
    if FileExists(sListFileName) then
    begin
      try
        LoadList.LoadFromFile(sListFileName);
        for i := 0 to LoadList.Count - 1 do
        begin
          sText := Trim(LoadList[i]);
          if sText = CardNo then
          begin
            LoadList.Delete(i);
            LoadList.SaveToFile(sListFileName);
            Break;
          end;
        end;
      except
        MainOutMessageAPI('loading fail.... => ' + sListFileName);
      end;
    end;
    LoadList.Free;
  end;

  procedure DELUseDateList(sHumName, sListFileName: string); //0049B620
  var
    i: Integer;
    LoadList: TStringList;
    s10, sText: string;
    bo15: Boolean;
  begin
    sListFileName := g_Config.sEnvirDir + sListFileName;
    LoadList := TStringList.Create;
    if FileExists(sListFileName) then
    begin
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessageAPI('loading fail.... => ' + sListFileName);
      end;
    end;
    bo15 := False;
    for i := 0 to LoadList.Count - 1 do
    begin
      sText := Trim(LoadList.Strings[i]);
      sText := GetValidStrCap(sText, s10, [' ', #9]);
      if CompareText(sHumName, s10) = 0 then
      begin
        bo15 := True;
        LoadList.Delete(i);
        Break;
      end;
    end;
    if bo15 then
    begin
      try
        LoadList.SaveToFile(sListFileName);
      except
        MainOutMessageAPI('saving fail.... => ' + sListFileName);
      end;
    end;
    LoadList.Free;
  end;

  procedure ActionOfCALLMOB(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
  var
    Mon: TBaseObject;
    nCount, i: Integer;
    s: TStringList;
    MonName: string;
    NameColor, BodyIndex: Integer;
  begin
    nCount := QuestActionInfo.nParam7;
    if QuestActionInfo.nParam5 = 1 then
      NameColor := g_Config.ReNewNameColor[QuestActionInfo.nParam6]
    else
      NameColor := 255;
    if QuestActionInfo.nParam5 = 2 then
      BodyIndex := QuestActionInfo.nParam6 - 1
    else
      BodyIndex := -1;

    for i := 0 to nCount - 1 do
    begin
      if QuestActionInfo.nParam1 = 1 then
      begin
        s := TStringList.Create;
        s.CommaText := QuestActionInfo.sParam2;
        MonName := Trim(s[0]);
      end
      else
        MonName := QuestActionInfo.sParam2;

      if QuestActionInfo.nParam3 <= 1 then
        Mon := PlayObject.MakeSlave(MonName, 3, QuestActionInfo.nParam3, 100, 10 * 24 * 60 * 60, NameColor, BodyIndex)
      else
        Mon := PlayObject.MakeSlave(MonName, 3, QuestActionInfo.nParam3, 100, QuestActionInfo.nParam3 * 60, NameColor, BodyIndex);

      if QuestActionInfo.nParam1 = 1 then
      begin
        if s.Count < 22 then
          Exit;
        if Mon <> nil then
        begin
          Mon.m_btRaceServer := Str_ToInt(s[1], 0);
          Mon.m_btRaceImg := Str_ToInt(s[2], 0);
          Mon.m_wAppr := Str_ToInt(s[3], 0);
          Mon.m_Abil.Level := Str_ToInt(s[4], 0);
          Mon.m_btLifeAttrib := Str_ToInt(s[5], 0);
          Mon.m_btCoolEye := Str_ToInt(s[6], 0);
          Mon.m_dwFightExp := Str_ToInt(s[7], 0);
          Mon.m_Abil.HP := Str_ToInt(s[8], 100);
          Mon.m_Abil.MaxHP := Str_ToInt(s[8], 100);
          Mon.m_btMonsterWeapon := LoByte(Str_ToInt(s[9], 100));
          //Mon.m_Abil.MP:=Monster.wMP;
          Mon.m_Abil.MP := 0;
          Mon.m_Abil.MaxMP := Str_ToInt(s[9], 100);
          Mon.m_Abil.AC := MakeLong(Str_ToInt(s[10], 10), Str_ToInt(s[10], 10));
          Mon.m_Abil.MAC := MakeLong(Str_ToInt(s[11], 10), Str_ToInt(s[11], 10));
          Mon.m_Abil.DC := MakeLong(Str_ToInt(s[12], 10), Str_ToInt(s[13], 10));
          Mon.m_Abil.MC := MakeLong(Str_ToInt(s[14], 10), Str_ToInt(s[14], 10));
          Mon.m_Abil.SC := MakeLong(Str_ToInt(s[15], 10), Str_ToInt(s[15], 10));
          Mon.m_btSpeedPoint := Str_ToInt(s[16], 10);
          Mon.m_btHitPoint := Str_ToInt(s[17], 10);
          Mon.m_nWalkSpeed := Str_ToInt(s[18], 10);
          Mon.m_nWalkStep := Str_ToInt(s[19], 10);
          Mon.m_dwWalkWait := Str_ToInt(s[20], 10);
          Mon.m_nNextHitTime := Str_ToInt(s[21], 10);
          Mon.m_nNonFrzWalkSpeed := Mon.m_nWalkSpeed;
          Mon.m_nNonFrzNextHitTime := Mon.m_nNextHitTime;
          Mon.RecalcAbilitys;
        end;
      end;
      if Mon <> nil then
        Mon.RefNameColor;
    end;
  end;

  procedure AddList(sHumName, sListFileName: string); //0049B620
  var
    i: Integer;
    LoadList: TStringList;
    s10: string;
    bo15: Boolean;
  begin
    sListFileName := g_Config.sEnvirDir + sListFileName;
    LoadList := TStringList.Create;
    if FileExists(sListFileName) then
    begin
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessageAPI('loading fail.... => ' + sListFileName);
      end;
    end;
    bo15 := False;
    for i := 0 to LoadList.Count - 1 do
    begin
      s10 := Trim(LoadList.Strings[i]);
      if CompareText(sHumName, s10) = 0 then
      begin
        bo15 := True;
        Break;
      end;
    end;
    if not bo15 then
    begin
      LoadList.Add(sHumName);
      try
        LoadList.SaveToFile(sListFileName);
      except
        MainOutMessageAPI('saving fail.... => ' + sListFileName);
      end;
    end;
    LoadList.Free;
  end;

  procedure DelList(sHumName, sListFileName: string); //0049B7F8
  var
    i: Integer;
    LoadList: TStringList;
    s10: string;
    bo15: Boolean;
  begin
    sListFileName := g_Config.sEnvirDir + sListFileName;
    LoadList := TStringList.Create;
    if FileExists(sListFileName) then
    begin
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessageAPI('loading fail.... => ' + sListFileName);
      end;
    end;
    bo15 := False;
    for i := 0 to LoadList.Count - 1 do
    begin
      s10 := Trim(LoadList.Strings[i]);
      if CompareText(sHumName, s10) = 0 then
      begin
        LoadList.Delete(i);
        bo15 := True;
        Break;
      end;
    end;
    if bo15 then
    begin
      try
        LoadList.SaveToFile(sListFileName);
      except
        MainOutMessageAPI('saving fail.... => ' + sListFileName);
      end;
    end;
    LoadList.Free;
  end;

  procedure TakeItem(PlayObject: TPlayObject; sItemName: string; nItemCount: Integer); //0049C998
  begin
    if CompareText(sItemName, sSTRING_GOLDNAME) = 0 then
    begin
      PlayObject.DecGold(nItemCount);
      PlayObject.GoldChanged();
      if g_boGameLogGold then
        AddGameDataLogAPI('10' + #9 + PlayObject.m_sMapName + #9 + IntToStr(PlayObject.m_nCurrX) + #9 + IntToStr(PlayObject.m_nCurrY) + #9 + PlayObject.m_sCharName + #9 + sSTRING_GOLDNAME + #9 + IntToStr(nItemCount) + #9 + '1' + #9 + m_sCharName);
      Exit;
    end;
    //StdItem := UserEngine.GetStdItem(sItemName);
    //if StdItem <> nil then
    PlayObject.DelBagStdItemNameCount(sItemName, nItemCount, m_sCharName);

    {for i := PlayObject.m_ItemList.Count - 1 downto 0 do begin
      if nItemCount <= 0 then Break;
      UserItem := PlayObject.m_ItemList.Items[i];
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then begin
        if CompareText(StdItem.Name, sItemName) = 0 then begin
          if StdItem.Overlap >= 1 then begin
            if StdItem.NeedIdentify = 1 then
              AddGameDataLogAPI('10' + #9 +
                PlayObject.m_sMapName + #9 +
                IntToStr(PlayObject.m_nCurrX) + #9 +
                IntToStr(PlayObject.m_nCurrY) + #9 +
                PlayObject.m_sCharName + #9 +
                sItemName + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                IntToStr(nItemCount) + #9 +
                m_sCharName);

            if UserItem.Dura >= nItemCount then begin
              UserItem.Dura := UserItem.Dura - nItemCount;

              if UserItem.Dura <= 0 then begin
                PlayObject.SendDelItems(UserItem);
                Dispose(UserItem);
                PlayObject.m_ItemList.Delete(i);
              end else begin
                PlayObject.SendMsg(self, RM_COUNTERITEMCHANGE, 0, UserItem.MakeIndex, UserItem.Dura, 0, StdItem.Name);
              end;
            end else begin
              PlayObject.SendDelItems(UserItem);
              Dispose(UserItem);
              PlayObject.m_ItemList.Delete(i);
            end;
            Break;
          end else begin
            if StdItem.NeedIdentify = 1 then
              AddGameDataLogAPI('10' + #9 +
                PlayObject.m_sMapName + #9 +
                IntToStr(PlayObject.m_nCurrX) + #9 +
                IntToStr(PlayObject.m_nCurrY) + #9 +
                PlayObject.m_sCharName + #9 +
                sItemName + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                m_sCharName);
            PlayObject.SendDelItems(UserItem);
            SC := UserEngine.GetStdItemName(UserItem.wIndex);
            Dispose(UserItem);
            PlayObject.m_ItemList.Delete(i);
            Dec(nItemCount);
          end;
        end;
      end;
    end;}
  end;

  {procedure GiveItem(sItemName: string; nItemCount: Integer); //0049D1D0
  var
    i, idx                  : Integer;
    UserItem                : pTUserItem;
    StdItem, StdItem2       : pTStdItem;
  begin
    if CompareText(sItemName, sSTRING_GOLDNAME) = 0 then begin
      PlayObject.IncGold(nItemCount);
      PlayObject.GoldChanged();
      if g_boGameLogGold then
        AddGameDataLogAPI('9' + #9 + PlayObject.m_sMapName + #9 + IntToStr(PlayObject.m_nCurrX) + #9 + IntToStr(PlayObject.m_nCurrY) + #9 + PlayObject.m_sCharName + #9 + sSTRING_GOLDNAME + #9 + IntToStr(nItemCount) + #9 + '1' + #9 + m_sCharName);
      Exit;
    end;
    if UserEngine.GetStdItemIdx(sItemName) > 0 then begin
      if not (nItemCount in [1..50]) then nItemCount := 1;
      idx := UserEngine.GetStdItemIdx(sItemName);
      StdItem := UserEngine.GetStdItem(idx);
      if (idx > 0) and (StdItem <> nil) then begin
        for i := 0 to nItemCount - 1 do begin
          if StdItem.Overlap >= 1 then begin
            if PlayObject.UserCounterItemAdd(StdItem.StdMode, StdItem.Looks, nItemCount, sItemName, False) then begin

              if StdItem.NeedIdentify = 1 then
                AddGameDataLogAPI('9' + #9 + PlayObject.m_sMapName + #9 + IntToStr(PlayObject.m_nCurrX) + #9 + IntToStr(PlayObject.m_nCurrY) + #9 + PlayObject.m_sCharName + #9 + sItemName + #9 + IntToStr(UserItem.MakeIndex) + #9 + IntToStr(nItemCount) + #9 + m_sCharName);

              PlayObject.WeightChanged;
              Exit;
            end;
          end;

          if PlayObject.IsEnoughBag then begin
            New(UserItem);
            if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then begin
              if StdItem.Overlap >= 1 then
                UserItem.Dura := nItemCount;
              PlayObject.m_ItemList.Add((UserItem));
              PlayObject.SendAddItem(UserItem);
              StdItem := UserEngine.GetStdItem(UserItem.wIndex);
              if StdItem.NeedIdentify = 1 then
                AddGameDataLogAPI('9' + #9 + PlayObject.m_sMapName + #9 + IntToStr(PlayObject.m_nCurrX) + #9 + IntToStr(PlayObject.m_nCurrY) + #9 + PlayObject.m_sCharName + #9 + sItemName + #9 + IntToStr(UserItem.MakeIndex) + #9 + '1' + #9 + m_sCharName);
            end else
              Dispose(UserItem);
            if StdItem.Overlap >= 1 then Break;
          end else begin
            New(UserItem);
            if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then begin
              StdItem2 := UserEngine.GetStdItem(UserItem.wIndex);
              if StdItem2.Overlap >= 1 then
                UserItem.Dura := nItemCount;
              if StdItem2.NeedIdentify = 1 then
                AddGameDataLogAPI('9' + #9 + PlayObject.m_sMapName + #9 + IntToStr(PlayObject.m_nCurrX) + #9 + IntToStr(PlayObject.m_nCurrY) + #9 + PlayObject.m_sCharName + #9 + sItemName + #9 + IntToStr(UserItem.MakeIndex) + #9 + '1' + #9 + m_sCharName);
              PlayObject.DropItemDown(UserItem, 3, False, PlayObject, nil);
              if StdItem2.Overlap >= 1 then Break;
            end;
            Dispose(UserItem);
          end;
        end;
      end;
    end;
  end;}

  procedure TakeWItem(sItemName: string; nItemCount: Integer); //0049CCF8
  var
    i, n: Integer;
    psd: pTStdItem;
  label
    labLog;
  begin
    psd := nil;
    if CompareLStr(sItemName, '[NECKLACE]', Length('[NECKLACE]')) then
    begin
      if PlayObject.m_UseItems[U_NECKLACE].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_NECKLACE]);
        n := PlayObject.m_UseItems[U_NECKLACE].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_NECKLACE].wIndex);
        PlayObject.m_UseItems[U_NECKLACE].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[RING]', Length('[RING]')) then
    begin
      if PlayObject.m_UseItems[U_RINGL].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_RINGL]);
        n := PlayObject.m_UseItems[U_RINGL].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_RINGL].wIndex);
        PlayObject.m_UseItems[U_RINGL].wIndex := 0;
        goto labLog;
      end;
      if PlayObject.m_UseItems[U_RINGR].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_RINGR]);
        n := PlayObject.m_UseItems[U_RINGR].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_RINGR].wIndex);
        PlayObject.m_UseItems[U_RINGR].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[ARMRING]', Length('[ARMRING]')) then
    begin
      if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_ARMRINGL]);
        n := PlayObject.m_UseItems[U_ARMRINGL].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
        PlayObject.m_UseItems[U_ARMRINGL].wIndex := 0;
        goto labLog;
      end;
      if PlayObject.m_UseItems[U_ARMRINGR].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_ARMRINGR]);
        n := PlayObject.m_UseItems[U_ARMRINGR].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_ARMRINGR].wIndex);
        PlayObject.m_UseItems[U_ARMRINGR].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[WEAPON]', Length('[WEAPON]')) then
    begin
      if PlayObject.m_UseItems[U_WEAPON].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_WEAPON]);
        n := PlayObject.m_UseItems[U_WEAPON].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_WEAPON].wIndex);
        PlayObject.m_UseItems[U_WEAPON].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[HELMET]', Length('[HELMET]')) then
    begin
      if PlayObject.m_UseItems[U_HELMET].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_HELMET]);
        n := PlayObject.m_UseItems[U_HELMET].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_HELMET].wIndex);
        PlayObject.m_UseItems[U_HELMET].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[HELMETEX]', Length('[HELMETEX]')) then
    begin
      if PlayObject.m_UseItems[U_HELMETEX].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_HELMETEX]);
        n := PlayObject.m_UseItems[U_HELMETEX].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_HELMETEX].wIndex);
        PlayObject.m_UseItems[U_HELMETEX].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[DRESS]', Length('[DRESS]')) then
    begin
      if PlayObject.m_UseItems[U_DRESS].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_DRESS]);
        n := PlayObject.m_UseItems[U_DRESS].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_DRESS].wIndex);
        PlayObject.m_UseItems[U_DRESS].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[U_BUJUK]', Length('[U_BUJUK]')) then
    begin
      if PlayObject.m_UseItems[U_BUJUK].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_BUJUK]);
        n := PlayObject.m_UseItems[U_BUJUK].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_BUJUK].wIndex);
        PlayObject.m_UseItems[U_BUJUK].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[U_BELT]', Length('[U_BELT]')) then
    begin
      if PlayObject.m_UseItems[U_BELT].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_BELT]);
        n := PlayObject.m_UseItems[U_BELT].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_BELT].wIndex);
        PlayObject.m_UseItems[U_BELT].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[U_BOOTS]', Length('[U_BOOTS]')) then
    begin
      if PlayObject.m_UseItems[U_BOOTS].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_BOOTS]);
        n := PlayObject.m_UseItems[U_BOOTS].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_BOOTS].wIndex);
        PlayObject.m_UseItems[U_BOOTS].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[U_CHARM]', Length('[U_CHARM]')) then
    begin
      if PlayObject.m_UseItems[U_CHARM].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_CHARM]);
        n := PlayObject.m_UseItems[U_CHARM].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_CHARM].wIndex);
        PlayObject.m_UseItems[U_CHARM].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[U_DRUM]', Length('[U_DRUM]')) then
    begin
      if PlayObject.m_UseItems[U_DRUM].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_DRUM]);
        n := PlayObject.m_UseItems[U_DRUM].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_DRUM].wIndex);
        PlayObject.m_UseItems[U_DRUM].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[U_HORSE]', Length('[U_HORSE]')) then
    begin
      if PlayObject.m_UseItems[U_HORSE].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_HORSE]);
        n := PlayObject.m_UseItems[U_HORSE].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_HORSE].wIndex);
        PlayObject.m_UseItems[U_HORSE].wIndex := 0;
        goto labLog;
      end;
    end;
    if CompareLStr(sItemName, '[U_FASHION]', Length('[U_FASHION]')) then
    begin
      if PlayObject.m_UseItems[U_FASHION].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_FASHION]);
        n := PlayObject.m_UseItems[U_FASHION].MakeIndex;
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[U_FASHION].wIndex);
        PlayObject.m_UseItems[U_FASHION].wIndex := 0;
        goto labLog;
      end;
    end;
    labLog: begin
      if (psd <> nil) then
      begin
        PlayObject.RecalcAbilitys();
        PlayObject.FeatureChanged;
        if (psd.NeedIdentify = 1) then
          AddGameDataLogAPI('10' + #9 +
            PlayObject.m_sMapName + #9 +
            IntToStr(PlayObject.m_nCurrX) + #9 +
            IntToStr(PlayObject.m_nCurrY) + #9 +
            PlayObject.m_sCharName + #9 +
            psd.Name + #9 +
            IntToStr(n) + #9 +
            '1' + #9 +
            m_sCharName);
      end;
    end;
    for i := Low(THumanUseItems) to High(THumanUseItems) do
    begin
      if nItemCount <= 0 then
        Exit;
      psd := nil;
      if PlayObject.m_UseItems[i].wIndex > 0 then
      begin
        psd := UserEngine.GetStdItem(PlayObject.m_UseItems[i].wIndex);
        if (psd <> nil) and (CompareText(psd.Name, sItemName) = 0) then
        begin
          PlayObject.SendDelItems(@PlayObject.m_UseItems[i]);
          if psd.NeedIdentify = 1 then
            AddGameDataLogAPI('10' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              psd.Name + #9 +
              IntToStr(PlayObject.m_UseItems[i].MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
          PlayObject.m_UseItems[i].wIndex := 0;
          PlayObject.RecalcAbilitys();
          PlayObject.FeatureChanged;
          Dec(nItemCount);
        end;
      end;
    end;
  end;

  function QuestActionProcess(ActionList: TList; OprateObject: TPlayObject): Boolean;
  var
    i, ii: Integer;
    //pQuestActionInfo        : pTQuestActionInfo;
    QuestActionInfo: pTQuestActionInfo;
    n14, n18, n1C, n28, n2C: Integer;
    n20X, n24Y, n34, n38, n3C, n40: Integer;
    s44, s48, s4C, s50: string;
    Envir: TEnvirnoment;
    List58: TList;
    User: TPlayObject;
    PlayObject: TPlayObject;
    StdItem: pTStdItem;
    pDelayCallNPC: PTDelayCallNPC;
  begin
    Result := True;
    n18 := 0;
    n34 := 0;
    n38 := 0;
    n3C := 0;
    n40 := 0;
    New(QuestActionInfo);
    try
      for i := 0 to ActionList.Count - 1 do
      begin
        PlayObject := OprateObject;
        QuestActionInfo^ := pTQuestActionInfo(ActionList.Items[i])^;
        if (QuestActionInfo.sParam1 <> '') then
        begin
          if (QuestActionInfo.sParam1[1] = '$') then
          begin
            s50 := QuestActionInfo.sParam1;
            QuestActionInfo.sParam1 := '<' + QuestActionInfo.sParam1 + '>';
            GetVariableText(PlayObject, QuestActionInfo.sParam1, s50);
          end
          else if Pos('>', QuestActionInfo.sParam1) > 0 then
            QuestActionInfo.sParam1 := GetLineVariableText(PlayObject, QuestActionInfo.sParam1);
        end;
        if (QuestActionInfo.sParam2 <> '') then
        begin
          if (QuestActionInfo.sParam2[1] = '$') then
          begin
            s50 := QuestActionInfo.sParam2;
            QuestActionInfo.sParam2 := '<' + QuestActionInfo.sParam2 + '>';
            GetVariableText(PlayObject, QuestActionInfo.sParam2, s50);
          end
          else if Pos('>', QuestActionInfo.sParam2) > 0 then
            QuestActionInfo.sParam2 := GetLineVariableText(PlayObject, QuestActionInfo.sParam2);
        end;
        if (QuestActionInfo.sParam3 <> '') then
        begin
          if (QuestActionInfo.sParam3[1] = '$') then
          begin
            s50 := QuestActionInfo.sParam3;
            QuestActionInfo.sParam3 := '<' + QuestActionInfo.sParam3 + '>';
            GetVariableText(PlayObject, QuestActionInfo.sParam3, s50);
          end
          else if Pos('>', QuestActionInfo.sParam3) > 0 then
            QuestActionInfo.sParam3 := GetLineVariableText(PlayObject, QuestActionInfo.sParam3);
        end;
        if (QuestActionInfo.sParam4 <> '') then
        begin
          if (QuestActionInfo.sParam4[1] = '$') then
          begin
            s50 := QuestActionInfo.sParam4;
            QuestActionInfo.sParam4 := '<' + QuestActionInfo.sParam4 + '>';
            GetVariableText(PlayObject, QuestActionInfo.sParam4, s50);
          end
          else if Pos('>', QuestActionInfo.sParam4) > 0 then
            QuestActionInfo.sParam4 := GetLineVariableText(PlayObject, QuestActionInfo.sParam4);
        end;
        if (QuestActionInfo.sParam5 <> '') then
        begin
          if (QuestActionInfo.sParam5[1] = '$') then
          begin
            s50 := QuestActionInfo.sParam5;
            QuestActionInfo.sParam5 := '<' + QuestActionInfo.sParam5 + '>';
            GetVariableText(PlayObject, QuestActionInfo.sParam5, s50);
          end
          else if Pos('>', QuestActionInfo.sParam5) > 0 then
            QuestActionInfo.sParam5 := GetLineVariableText(PlayObject, QuestActionInfo.sParam5);
        end;
        if (QuestActionInfo.sParam6 <> '') then
        begin
          if (QuestActionInfo.sParam6[1] = '$') then
          begin
            s50 := QuestActionInfo.sParam6;
            QuestActionInfo.sParam6 := '<' + QuestActionInfo.sParam6 + '>';
            GetVariableText(PlayObject, QuestActionInfo.sParam6, s50);
          end
          else if Pos('>', QuestActionInfo.sParam6) > 0 then
            QuestActionInfo.sParam6 := GetLineVariableText(PlayObject, QuestActionInfo.sParam6);
        end;
        if (QuestActionInfo.sParam7 <> '') then
        begin
          if (QuestActionInfo.sParam7[1] = '$') then
          begin
            s50 := QuestActionInfo.sParam7;
            QuestActionInfo.sParam7 := '<' + QuestActionInfo.sParam7 + '>';
            GetVariableText(PlayObject, QuestActionInfo.sParam7, s50);
          end
          else if Pos('>', QuestActionInfo.sParam7) > 0 then
            QuestActionInfo.sParam7 := GetLineVariableText(PlayObject, QuestActionInfo.sParam7);
        end;
        if (QuestActionInfo.sParam8 <> '') then
        begin
          if (QuestActionInfo.sParam8[1] = '$') then
          begin
            s50 := QuestActionInfo.sParam8;
            QuestActionInfo.sParam8 := '<' + QuestActionInfo.sParam8 + '>';
            GetVariableText(PlayObject, QuestActionInfo.sParam8, s50);
          end
          else if Pos('>', QuestActionInfo.sParam8) > 0 then
            QuestActionInfo.sParam8 := GetLineVariableText(PlayObject, QuestActionInfo.sParam8);
        end;
        if (QuestActionInfo.sParam9 <> '') then
        begin
          if (QuestActionInfo.sParam9[1] = '$') then
          begin
            s50 := QuestActionInfo.sParam9;
            QuestActionInfo.sParam9 := '<' + QuestActionInfo.sParam9 + '>';
            GetVariableText(PlayObject, QuestActionInfo.sParam9, s50);
          end
          else if Pos('>', QuestActionInfo.sParam9) > 0 then
            QuestActionInfo.sParam9 := GetLineVariableText(PlayObject, QuestActionInfo.sParam9);
        end;
        if (QuestActionInfo.sParam10 <> '') then
        begin
          if (QuestActionInfo.sParam10[1] = '$') then
          begin
            s50 := QuestActionInfo.sParam10;
            QuestActionInfo.sParam10 := '<' + QuestActionInfo.sParam10 + '>';
            GetVariableText(PlayObject, QuestActionInfo.sParam10, s50);
          end
          else if Pos('>', QuestActionInfo.sParam10) > 0 then
            QuestActionInfo.sParam10 := GetLineVariableText(PlayObject, QuestActionInfo.sParam10);
        end;

        //参数变量解释以主执行人物为依据
        if (QuestActionInfo.sOpName <> '') then
        begin
          if (Length(QuestActionInfo.sOpName) > 2) then
          begin
            if (QuestActionInfo.sOpName[1] = '$') then
            begin
              s50 := QuestActionInfo.sOpName;
              QuestActionInfo.sOpName := '<' + QuestActionInfo.sOpName + '>';
              GetVariableText(PlayObject, QuestActionInfo.sOpName, s50);
            end
            else if Pos('>', QuestActionInfo.sOpName) > 0 then
              QuestActionInfo.sOpName := GetLineVariableText(PlayObject, QuestActionInfo.sOpName);
            User := UserEngine.GetPlayObject(QuestActionInfo.sOpName);
            if User <> nil then
            begin
              PlayObject := User;
              if QuestActionInfo.sOpHName = 'H' then
              begin
                User := TPlayObject(PlayObject.GetHeroObjectA);
                if (User <> nil) then
                begin
                  PlayObject := User;
                end
                else
                begin
                  Result := False;
                  //Break;      //0628
                  Continue;
                end;
              end;
            end
            else
            begin
              Result := False;
              //Break;       //0628
              Continue;
            end;
          end
          else if CompareText(QuestActionInfo.sOpName, 'H') = 0 then
          begin
            User := TPlayObject(PlayObject.GetHeroObjectA);
            if (User <> nil) then
            begin
              PlayObject := User;
            end
            else
            begin
              Result := False;
              //Break;    //0628
              Continue;
            end;
          end;
        end;

        if IsStringNumber(QuestActionInfo.sParam1) then
          QuestActionInfo.nParam1 := Str_ToInt(QuestActionInfo.sParam1, 0);
        if IsStringNumber(QuestActionInfo.sParam2) then
          QuestActionInfo.nParam2 := Str_ToInt(QuestActionInfo.sParam2, 0);     
        if IsStringNumber(QuestActionInfo.sParam3) then
          QuestActionInfo.nParam3 := Str_ToInt(QuestActionInfo.sParam3, 0);    
        if IsStringNumber(QuestActionInfo.sParam4) then
          QuestActionInfo.nParam4 := Str_ToInt(QuestActionInfo.sParam4, 0);
        if IsStringNumber(QuestActionInfo.sParam5) then
          QuestActionInfo.nParam5 := Str_ToInt(QuestActionInfo.sParam5, 0);
        if IsStringNumber(QuestActionInfo.sParam6) then
          QuestActionInfo.nParam6 := Str_ToInt(QuestActionInfo.sParam6, 0);
        if IsStringNumber(QuestActionInfo.sParam7) then
          QuestActionInfo.nParam7 := Str_ToInt(QuestActionInfo.sParam7, 0);
        if IsStringNumber(QuestActionInfo.sParam8) then
          QuestActionInfo.nParam8 := Str_ToInt(QuestActionInfo.sParam8, 0);
        if IsStringNumber(QuestActionInfo.sParam9) then
          QuestActionInfo.nParam9 := Str_ToInt(QuestActionInfo.sParam9, 0);
        if IsStringNumber(QuestActionInfo.sParam10) then
          QuestActionInfo.nParam10 := Str_ToInt(QuestActionInfo.sParam10, 0);

        case QuestActionInfo.nCMDCode of
          nSet:
            begin
              n28 := Str_ToInt(QuestActionInfo.sParam1, 0);
              n2C := Str_ToInt(QuestActionInfo.sParam2, 0);
              PlayObject.SetQuestFlagStatus(n28, n2C);
            end;
          nTAKE: TakeItem(PlayObject, QuestActionInfo.sParam1, Str_ToInt(QuestActionInfo.sParam2, 1));
          nSC_GIVE: ActionOfGiveItem(PlayObject, QuestActionInfo);
          nSC_GIVEEX: ActionOfGiveItemEx(PlayObject, QuestActionInfo);
          nSC_CONFERTITLE: ActionOfCONFERTITLE(PlayObject, QuestActionInfo);
          nSC_DEPRIVETITLE: ActionOfDEPRIVETITLE(PlayObject, QuestActionInfo);
          nSC_PLAYSOUND: ActionOfPlaySound(PlayObject, QuestActionInfo);

          nTAKEW: TakeWItem(QuestActionInfo.sParam1, QuestActionInfo.nParam2);
          nCLOSE: PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
          nRESET: for ii := 0 to QuestActionInfo.nParam2 - 1 do
              PlayObject.SetQuestFlagStatus(QuestActionInfo.nParam1 + ii, 0);
          nSETOPEN:
            begin
              n28 := Str_ToInt(QuestActionInfo.sParam1, 0);
              n2C := Str_ToInt(QuestActionInfo.sParam2, 0);
              PlayObject.SetQuestUnitOpenStatus(n28, n2C);
            end;
          nSETUNIT:
            begin
              n28 := Str_ToInt(QuestActionInfo.sParam1, 0);
              n2C := Str_ToInt(QuestActionInfo.sParam2, 0);
              PlayObject.SetQuestUnitStatus(n28, n2C);
            end;
          nRESETUNIT: for ii := 0 to QuestActionInfo.nParam2 - 1 do
              PlayObject.SetQuestUnitStatus(QuestActionInfo.nParam1 + ii, 0);
          nBREAK: Result := False;
          nTIMERECALL:
            begin
              PlayObject.m_boTimeRecall := True;
              PlayObject.m_sMoveMap := PlayObject.m_sMapName;
              PlayObject.m_nMoveX := PlayObject.m_nCurrX;
              PlayObject.m_nMoveY := PlayObject.m_nCurrY;
              PlayObject.m_dwTimeRecallTick := GetTickCount + LongWord(QuestActionInfo.nParam1 * 60 * 1000);
            end;
          nSC_PARAM1:
            begin
              n34 := QuestActionInfo.nParam1;
              s44 := QuestActionInfo.sParam1;
            end;
          nSC_PARAM2:
            begin
              n38 := QuestActionInfo.nParam1;
              s48 := QuestActionInfo.sParam1;
            end;
          nSC_PARAM3:
            begin
              n3C := QuestActionInfo.nParam1;
              s4C := QuestActionInfo.sParam1;
            end;
          nSC_PARAM4:
            begin
              n40 := QuestActionInfo.nParam1;
              s50 := QuestActionInfo.sParam1;
            end;
          nSC_EXEACTION:
            begin
              n40 := QuestActionInfo.nParam1;
              s50 := QuestActionInfo.sParam1;
              ExeAction(PlayObject, QuestActionInfo.sParam1,
                QuestActionInfo.sParam2, QuestActionInfo.sParam3,
                QuestActionInfo.nParam1, QuestActionInfo.nParam2,
                QuestActionInfo.nParam3);
            end;
          nSC_WEBBROWSER: ActionOfWebBrowser(PlayObject, QuestActionInfo);
          nSC_OPENSTORAGEVIEW: ActionOfOpenStorageView(PlayObject, QuestActionInfo);
          nSC_TAKEON: ActionOfTakeOn(PlayObject, QuestActionInfo);
          nMAPMOVE:
            begin
              PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
              PlayObject.SpaceMove(QuestActionInfo.sParam1, QuestActionInfo.nParam2, QuestActionInfo.nParam3, 0);
              boCheckOK := True;
            end;
          nMAP:
            begin
              PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
              PlayObject.MapRandomMove(QuestActionInfo.sParam1, 0);
              boCheckOK := True;
            end;
          nTAKECHECKITEM:
            if UserItem <> nil then
            begin
              StdItem := UserEngine.GetStdItem(UserItem.wIndex);
              if StdItem <> nil then
              begin
                if PlayObject.QuestTakeCheckItem(UserItem) then
                  if StdItem.NeedIdentify = 1 then
                    AddGameDataLogAPI('10' + #9 +
                      PlayObject.m_sMapName + #9 +
                      IntToStr(PlayObject.m_nCurrX) + #9 +
                      IntToStr(PlayObject.m_nCurrY) + #9 +
                      PlayObject.m_sCharName + #9 +
                      StdItem.Name + #9 +
                      IntToStr(UserItem.MakeIndex) + #9 +
                      '1' + #9 +
                      m_sCharName);
              end;
            end
            else
              ScriptActionError(PlayObject, '', QuestActionInfo, sTAKECHECKITEM);
          nMONGEN:
            begin
              for ii := 0 to QuestActionInfo.nParam2 - 1 do
              begin
                n20X := Random(QuestActionInfo.nParam3 * 2 + 1) + (n38 - QuestActionInfo.nParam3);
                n24Y := Random(QuestActionInfo.nParam3 * 2 + 1) + (n3C - QuestActionInfo.nParam3);
                UserEngine.RegenMonsterByName(s44, n20X, n24Y, QuestActionInfo.sParam1);
              end;
            end;
          nMONCLEAR:
            begin
              List58 := TList.Create;
              UserEngine.GetMapMonster(g_MapManager.FindMap(QuestActionInfo.sParam1), List58);
              for ii := 0 to List58.Count - 1 do
              begin
                if TBaseObject(List58.Items[ii]).m_Master <> nil then
                  Continue;
                TBaseObject(List58.Items[ii]).m_boNoItem := True;
                TBaseObject(List58.Items[ii]).m_WAbil.HP := 0;
                TBaseObject(List58.Items[ii]).MakeGhost;
              end;
              List58.Free;
            end;
          nMOV:
            begin
              n14 := GetValNameNo(QuestActionInfo.sParam1);
              s14 := QuestActionInfo.sParam2;
              n18 := Str_ToInt(s14, 1) * Str_ToInt(QuestActionInfo.sParam3, 1);     
              if n14 >= 0 then
              begin
                case n14 of
                  0..9: PlayObject.m_nVal[n14] := n18;
                  100..199: g_Config.GlobalVal[n14 - 100] := n18;
                  200..299: PlayObject.m_DyVal[n14 - 200] := n18;
                  300..399: PlayObject.m_nMval[n14 - 300] := n18;
                  400..499: g_Config.GlobaDyMval[n14 - 400] := n18;
                  500..599: g_Config.GlobaDyTval[n14 - 500] := s14;
                  600..699: PlayObject.m_nSval[n14 - 600] := s14;
                  700..799: g_Config.HGlobalVal[n14 - 700] := n18;
                else
                  ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
                end;
              end
              else
                ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
            end;
          nINC:
            begin
              n14 := GetValNameNo(QuestActionInfo.sParam1);
              s14 := QuestActionInfo.sParam2;
              n18 := Str_ToInt(s14, 1) * Str_ToInt(QuestActionInfo.sParam3, 1);    
              if n14 >= 0 then
              begin
                case n14 of
                  0..9:
                    begin
                      if QuestActionInfo.nParam2 > 1 then
                        Inc(PlayObject.m_nVal[n14], n18 {QuestActionInfo.nParam2})
                      else
                        Inc(PlayObject.m_nVal[n14]);
                    end;
                  100..199:
                    begin
                      if n18 > 1 then
                        Inc(g_Config.GlobalVal[n14 - 100], n18 {QuestActionInfo.nParam2})
                      else
                        Inc(g_Config.GlobalVal[n14 - 100]);
                    end;
                  200..299:
                    begin
                      if n18 > 1 then
                        Inc(PlayObject.m_DyVal[n14 - 200], n18 {QuestActionInfo.nParam2})
                      else
                        Inc(PlayObject.m_DyVal[n14 - 200]);
                    end;
                  300..399:
                    begin
                      if n18 > 1 then
                        Inc(PlayObject.m_nMval[n14 - 300], n18 {QuestActionInfo.nParam2})
                      else
                        Inc(PlayObject.m_nMval[n14 - 300]);
                    end;
                  400..499:
                    begin
                      if n18 > 1 then
                        Inc(g_Config.GlobaDyMval[n14 - 400], n18 {QuestActionInfo.nParam2})
                      else
                        Inc(g_Config.GlobaDyMval[n14 - 400]);
                    end;
                  500..599: if s14 = '' then
                      g_Config.GlobaDyTval[n14 - 500] := g_Config.GlobaDyTval[n14 - 500] + ' '
                    else
                      g_Config.GlobaDyTval[n14 - 500] := g_Config.GlobaDyTval[n14 - 500] + s14;

                  600..699: if s14 = '' then
                      PlayObject.m_nSval[n14 - 600] := PlayObject.m_nSval[n14 - 600] + ' '
                    else
                      PlayObject.m_nSval[n14 - 600] := PlayObject.m_nSval[n14 - 600] + s14;

                  700..799:
                    begin
                      if n18 > 1 then
                        Inc(g_Config.HGlobalVal[n14 - 700], n18)
                      else
                        Inc(g_Config.HGlobalVal[n14 - 700]);
                    end;
                else
                  ScriptActionError(PlayObject, '', QuestActionInfo, sINC);
                end;
                //end;
              end
              else
                ScriptActionError(PlayObject, '', QuestActionInfo, sINC);
            end;
          nDEC:
            begin
              n14 := GetValNameNo(QuestActionInfo.sParam1);
              s14 := QuestActionInfo.sParam2;
              n18 := Str_ToInt(s14, 1) * Str_ToInt(QuestActionInfo.sParam3, 1);    
              if n14 >= 0 then
              begin
                case n14 of
                  0..9:
                    begin
                      if n18 > 1 then
                        Dec(PlayObject.m_nVal[n14], n18 {QuestActionInfo.nParam2})
                      else
                        Dec(PlayObject.m_nVal[n14]);
                    end;
                  100..199:
                    begin
                      if n18 > 1 then
                        Dec(g_Config.GlobalVal[n14 - 100], n18 {QuestActionInfo.nParam2})
                      else
                        Dec(g_Config.GlobalVal[n14 - 100]);
                    end;
                  200..299:
                    begin
                      if n18 > 1 then
                        Dec(PlayObject.m_DyVal[n14 - 200], n18 {QuestActionInfo.nParam2})
                      else
                        Dec(PlayObject.m_DyVal[n14 - 200]);
                    end;
                  300..399:
                    begin
                      if n18 > 1 then
                        Dec(PlayObject.m_nMval[n14 - 300], n18 {QuestActionInfo.nParam2})
                      else
                        Dec(PlayObject.m_nMval[n14 - 300]);
                    end;
                  400..499:
                    begin
                      if n18 > 1 then
                        Dec(g_Config.GlobaDyMval[n14 - 400], n18 {QuestActionInfo.nParam2})
                      else
                        Dec(g_Config.GlobaDyMval[n14 - 400]);
                    end;
                  500..599: g_Config.GlobaDyTval[n14 - 500] := DecStr(g_Config.GlobaDyTval[n14 - 500], QuestActionInfo.nParam2, QuestActionInfo.nParam3);
                  600..699: PlayObject.m_nSval[n14 - 600] := DecStr(PlayObject.m_nSval[n14 - 600], QuestActionInfo.nParam2, QuestActionInfo.nParam3);
                  700..799:
                    begin
                      if n18 > 1 then
                        Dec(g_Config.HGlobalVal[n14 - 700], n18 {QuestActionInfo.nParam2})
                      else
                        Dec(g_Config.HGlobalVal[n14 - 700]);
                    end;
                else
                  ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
                end;
              end
              else
                ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
            end;
          nSUM:
            begin
              n18 := 0;
              n14 := GetValNameNo(QuestActionInfo.sParam1);
              if n14 >= 0 then
              begin
                case n14 of
                  000..009: n18 := PlayObject.m_nVal[n14];
                  100..199: n18 := g_Config.GlobalVal[n14 - 100];
                  200..299: n18 := PlayObject.m_DyVal[n14 - 200];
                  300..399: n18 := PlayObject.m_nMval[n14 - 300];
                  400..499: n18 := g_Config.GlobaDyMval[n14 - 400];
                  700..799: n18 := g_Config.HGlobalVal[n14 - 700];
                else
                  ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
                  Exit;
                end;
              end
              else
              begin
                ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
                Exit;
              end;
              n1C := 0;
              n14 := GetValNameNo(QuestActionInfo.sParam2);
              if n14 >= 0 then
              begin
                case n14 of
                  000..009: n1C := PlayObject.m_nVal[n14];
                  100..199: n1C := g_Config.GlobalVal[n14 - 100];
                  200..299: n1C := PlayObject.m_DyVal[n14 - 200];
                  300..399: n1C := PlayObject.m_nMval[n14 - 300];
                  400..499: n1C := g_Config.GlobaDyMval[n14 - 400];
                  700..799: n1C := g_Config.HGlobalVal[n14 - 700];
                else
                  ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
                  Exit;
                end;
              end;

              if (QuestActionInfo.sParam3 = '') then
              begin
                n14 := GetValNameNo(QuestActionInfo.sParam1);
                if n14 >= 0 then
                begin
                  case n14 of
                    000..009: PlayObject.m_nVal[9] := PlayObject.m_nVal[9] + n18 + n1C;
                    100..199: g_Config.GlobalVal[99] := g_Config.GlobalVal[99] + n18 + n1C;
                    200..299: PlayObject.m_DyVal[9] := PlayObject.m_DyVal[9] + n18 + n1C;
                    300..399: PlayObject.m_nMval[99] := PlayObject.m_nMval[99] + n18 + n1C;
                    400..499: g_Config.GlobaDyMval[99] := g_Config.GlobaDyMval[99] + n18 + n1C;
                    700..799: g_Config.HGlobalVal[99] := g_Config.HGlobalVal[99] + n18 + n1C;
                  end;
                end;
              end
              else
              begin
                n14 := GetValNameNo(QuestActionInfo.sParam3);
                if n14 >= 0 then
                begin
                  case n14 of
                    000..009: PlayObject.m_nVal[n14] := n18 + n1C;
                    100..199: g_Config.GlobalVal[n14 - 100] := n18 + n1C;
                    200..299: PlayObject.m_DyVal[n14 - 200] := n18 + n1C;
                    300..399: PlayObject.m_nMval[n14 - 300] := n18 + n1C;
                    400..499: g_Config.GlobaDyMval[n14 - 400] := n18 + n1C;
                    700..799: g_Config.HGlobalVal[n14 - 700] := n18 + n1C;
                  else
                    ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
                  end;
                end
                else
                begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
                  Exit;
                end;
              end;
            end;
          nSC_MUL:
            begin
              n14 := GetValNameNo(QuestActionInfo.sParam1);
              s14 := QuestActionInfo.sParam2;
              n18 := Str_ToInt(s14, 1) * Str_ToInt(QuestActionInfo.sParam3, 1);             
              if n14 >= 0 then
              begin
                case n14 of
                  000..009: if QuestActionInfo.nParam2 > 1 then
                      PlayObject.m_nVal[n14] := PlayObject.m_nVal[n14] * n18;
                  100..199: if QuestActionInfo.nParam2 > 1 then
                      g_Config.GlobalVal[n14 - 100] := g_Config.GlobalVal[n14 - 100] * n18;
                  200..299: if QuestActionInfo.nParam2 > 1 then
                      PlayObject.m_DyVal[n14 - 200] := PlayObject.m_DyVal[n14 - 200] * n18;
                  300..399: if QuestActionInfo.nParam2 > 1 then
                      PlayObject.m_nMval[n14 - 300] := PlayObject.m_nMval[n14 - 300] * n18;
                  400..499: if QuestActionInfo.nParam2 > 1 then
                      g_Config.GlobaDyMval[n14 - 400] := g_Config.GlobaDyMval[n14 - 400] * n18;
                  700..799: if QuestActionInfo.nParam2 > 1 then
                      g_Config.HGlobalVal[n14 - 700] := g_Config.HGlobalVal[n14 - 700] * n18;
                else
                  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MUL);
                end;
              end
              else
                ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MUL);
            end;
          nSC_DIV:
            begin
              n14 := GetValNameNo(QuestActionInfo.sParam1);
              s14 := QuestActionInfo.sParam2;
              n18 := Str_ToInt(s14, 1) * Str_ToInt(QuestActionInfo.sParam3, 1);          
              if n14 >= 0 then
              begin
                case n14 of
                  000..009: if QuestActionInfo.nParam2 > 1 then
                      PlayObject.m_nVal[n14] := PlayObject.m_nVal[n14] div n18;
                  100..199: if QuestActionInfo.nParam2 > 1 then
                      g_Config.GlobalVal[n14 - 100] := g_Config.GlobalVal[n14 - 100] div n18;
                  200..299: if QuestActionInfo.nParam2 > 1 then
                      PlayObject.m_DyVal[n14 - 200] := PlayObject.m_DyVal[n14 - 200] div n18;
                  300..399: if QuestActionInfo.nParam2 > 1 then
                      PlayObject.m_nMval[n14 - 300] := PlayObject.m_nMval[n14 - 300] div n18;
                  400..499: if QuestActionInfo.nParam2 > 1 then
                      g_Config.GlobaDyMval[n14 - 400] := g_Config.GlobaDyMval[n14 - 400] div n18;
                  700..799: if QuestActionInfo.nParam2 > 1 then
                      g_Config.HGlobalVal[n14 - 700] := g_Config.HGlobalVal[n14 - 700] div n18;
                else
                  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MUL);
                end;
              end
              else
                ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MUL);
            end;
          nSC_PERCENT:
            begin
              n14 := GetValNameNo(QuestActionInfo.sParam1);
              s14 := QuestActionInfo.sParam2;
              n18 := Str_ToInt(s14, 1) * Str_ToInt(QuestActionInfo.sParam3, 1);              
              if n14 >= 0 then
              begin
                case n14 of
                  000..009: if QuestActionInfo.nParam2 > 1 then
                      PlayObject.m_nVal[n14] := PlayObject.m_nVal[n14] * 100 div n18;
                  100..199: if QuestActionInfo.nParam2 > 1 then
                      g_Config.GlobalVal[n14 - 100] := g_Config.GlobalVal[n14 - 100] * 100 div n18;
                  200..299: if QuestActionInfo.nParam2 > 1 then
                      PlayObject.m_DyVal[n14 - 200] := PlayObject.m_DyVal[n14 - 200] * 100 div n18;
                  300..399: if QuestActionInfo.nParam2 > 1 then
                      PlayObject.m_nMval[n14 - 300] := PlayObject.m_nMval[n14 - 300] * 100 div n18;
                  400..499: if QuestActionInfo.nParam2 > 1 then
                      g_Config.GlobaDyMval[n14 - 400] := g_Config.GlobaDyMval[n14 - 400] * 100 div n18;
                  700..799: if QuestActionInfo.nParam2 > 1 then
                      g_Config.HGlobalVal[n14 - 700] := g_Config.HGlobalVal[n14 - 700] * 100 div n18;
                else
                  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MUL);
                end;
              end
              else
                ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MUL);
            end;
          nSC_OPENBOOK:
            begin
              PlayObject.m_DefMsg := MakeDefaultMsg(SM_BOOK, Integer(Self), Str_ToInt(QuestActionInfo.sParam1, 0), Str_ToInt(QuestActionInfo.sParam2, 0), 0);
              PlayObject.SendSocket(@PlayObject.m_DefMsg, EncodeString(QuestActionInfo.sParam3));
            end;
          nSC_OPENBOX:
            begin
              PlayObject.ScriptOpenBox(QuestActionInfo.sParam1);
            end;
          nSC_QUERYREFINEITEM:
            begin
              PlayObject.m_DefMsg := MakeDefaultMsg(SM_QUERYREFINEITEM, 0, 0, 0, 0);
              PlayObject.SendSocket(@PlayObject.m_DefMsg, '');
            end;
          nBREAKTIMERECALL:
            begin
              PlayObject.m_boTimeRecall := False;
            end;
          nSC_SETSCTIMER:
            begin
              ActionOfSetScriptTimer(PlayObject, QuestActionInfo);
            end;
          nSC_KILLSCTIMER:
            begin
              ActionOfKillScriptTimer(PlayObject, QuestActionInfo);
            end;
          nCHANGEMODE:
            begin
              case QuestActionInfo.nParam1 of
                1: PlayObject.CmdChangeAdminMode('', 10, '', Str_ToInt(QuestActionInfo.sParam2, 0) = 1);
                2: PlayObject.CmdChangeSuperManMode('', 10, '', Str_ToInt(QuestActionInfo.sParam2, 0) = 1);
                3: PlayObject.CmdChangeObMode('', 10, '', Str_ToInt(QuestActionInfo.sParam2, 0) = 1);
              else
                begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sCHANGEMODE);
                end;
              end;
            end;
          nPKPOINT:
            begin
              if QuestActionInfo.nParam1 = 0 then
                PlayObject.m_nPkPoint := 0
              else
              begin
                if QuestActionInfo.nParam1 < 0 then
                begin
                  if (PlayObject.m_nPkPoint + QuestActionInfo.nParam1) >= 0 then
                    Inc(PlayObject.m_nPkPoint, QuestActionInfo.nParam1)
                  else
                    PlayObject.m_nPkPoint := 0;
                end
                else
                begin
                  if (PlayObject.m_nPkPoint + QuestActionInfo.nParam1) > 10000 then
                    PlayObject.m_nPkPoint := 10000
                  else
                    Inc(PlayObject.m_nPkPoint, QuestActionInfo.nParam1);
                end;
              end;
              PlayObject.RefNameColor();
            end;
          nCHANGEXP:
            begin

            end;
          nSC_RECALLMOB: ActionOfRecallmob(PlayObject, QuestActionInfo);
          nSC_RECALLMOBEX: ActionOfRecallmobEx(PlayObject, QuestActionInfo);
          nSC_READRANDOMSTR: ActionOfReadRandomStr(PlayObject, QuestActionInfo);
          nSC_READRANDOMLINE: ActionOfReadRandomLine(PlayObject, QuestActionInfo);

          nSC_CHANGERANGEMONPOS: ActionOfChangeMonPos(PlayObject, QuestActionInfo);
          nKICK:
            begin
              PlayObject.m_boReconnection := True;
              PlayObject.m_boSoftClose := True;
            end;
          nMOVR:
            begin
              n14 := GetValNameNo(QuestActionInfo.sParam1);
              if n14 >= 0 then
              begin
                case n14 of
                  0..9: PlayObject.m_nVal[n14] := Random(QuestActionInfo.nParam2);
                  100..199: g_Config.GlobalVal[n14 - 100] := Random(QuestActionInfo.nParam2);
                  200..299: PlayObject.m_DyVal[n14 - 200] := Random(QuestActionInfo.nParam2);
                  300..399: PlayObject.m_nMval[n14 - 300] := Random(QuestActionInfo.nParam2);
                  400..499: g_Config.GlobaDyMval[n14 - 400] := Random(QuestActionInfo.nParam2);
                  700..799: g_Config.HGlobalVal[n14 - 700] := Random(QuestActionInfo.nParam2);
                else
                  ScriptActionError(PlayObject, '', QuestActionInfo, sMOVR);
                end;
              end
              else
                ScriptActionError(PlayObject, '', QuestActionInfo, sMOVR);
            end;
          nMOVREX:
            begin
              n14 := GetValNameNo(QuestActionInfo.sParam1);
              if n14 >= 0 then
              begin
                case n14 of
                  0..9: PlayObject.m_nVal[n14] := QuestActionInfo.nParam2 + Random(QuestActionInfo.nParam3 - QuestActionInfo.nParam2 + 1);
                  100..199: g_Config.GlobalVal[n14 - 100] := QuestActionInfo.nParam2 + Random(QuestActionInfo.nParam3 - QuestActionInfo.nParam2 + 1);
                  200..299: PlayObject.m_DyVal[n14 - 200] := QuestActionInfo.nParam2 + Random(QuestActionInfo.nParam3 - QuestActionInfo.nParam2 + 1);
                  300..399: PlayObject.m_nMval[n14 - 300] := QuestActionInfo.nParam2 + Random(QuestActionInfo.nParam3 - QuestActionInfo.nParam2 + 1);
                  400..499: g_Config.GlobaDyMval[n14 - 400] := QuestActionInfo.nParam2 + Random(QuestActionInfo.nParam3 - QuestActionInfo.nParam2 + 1);
                  700..799: g_Config.HGlobalVal[n14 - 700] := QuestActionInfo.nParam2 + Random(QuestActionInfo.nParam3 - QuestActionInfo.nParam2 + 1);
                else
                  ScriptActionError(PlayObject, '', QuestActionInfo, sMOVREX);
                end;
              end
              else
                ScriptActionError(PlayObject, '', QuestActionInfo, sMOVREX);
            end;
          nEXCHANGEMAP:
            begin
              Envir := g_MapManager.FindMap(QuestActionInfo.sParam1);
              if Envir <> nil then
              begin
                List58 := TList.Create;
                UserEngine.GetMapRageHuman(Envir, 0, 0, 1000, List58);
                if List58.Count > 0 then
                begin
                  User := TPlayObject(List58.Items[0]);
                  if QuestActionInfo.sParam2 = 'APPR' then
                  begin
                    if User.m_sMasterName = m_sCharName then
                      User.MapRandomMove(m_sMapName, 0);
                  end
                  else if QuestActionInfo.sParam2 = 'DEAR' then
                  begin
                    if User.m_sDearName = m_sCharName then
                      User.MapRandomMove(m_sMapName, 0);
                  end
                  else if QuestActionInfo.sParam2 = '' then
                    User.MapRandomMove(m_sMapName, 0);
                end;
                List58.Free;
                PlayObject.MapRandomMove(QuestActionInfo.sParam1, 0);
              end
              else
                ScriptActionError(PlayObject, '', QuestActionInfo, sEXCHANGEMAP);
            end;
          nRECALLMAP:
            begin
              Envir := g_MapManager.FindMap(QuestActionInfo.sParam1);
              if Envir <> nil then
              begin
                List58 := TList.Create;
                UserEngine.GetMapRageHuman(Envir, 0, 0, 1000, List58);
                for ii := 0 to List58.Count - 1 do
                begin
                  User := TPlayObject(List58.Items[ii]);
                  User.MapRandomMove(Self.m_sMapName, 0);
                  if ii > 20 then
                    Break;
                end;
                List58.Free;
              end
              else
                ScriptActionError(PlayObject, '', QuestActionInfo, sRECALLMAP);
            end;
          nADDBATCH: ListBatch.AddObject(QuestActionInfo.sParam1, TObject(n18));
          nBATCHDELAY: n18 := QuestActionInfo.nParam1 * 1000;
          nBATCHMOVE:
            begin
              for ii := 0 to ListBatch.Count - 1 do
              begin
                PlayObject.SendDelayMsg(Self, RM_MAPRANDOMMOVE, 0, 0, 0, 0, ListBatch.Strings[ii], Integer(ListBatch.Objects[ii]) + nBatch);
                Inc(nBatch, Integer(ListBatch.Objects[ii]));
              end;
            end;
          nPLAYDICE:
            begin
              PlayObject.m_sPlayDiceLabel := QuestActionInfo.sParam2;
              PlayObject.SendMsg(Self,
                RM_PLAYDICE,
                QuestActionInfo.nParam1,
                MakeLong(MakeWord(PlayObject.m_DyVal[0], PlayObject.m_DyVal[1]),
                MakeWord(PlayObject.m_DyVal[2], PlayObject.m_DyVal[3])),
                MakeLong(MakeWord(PlayObject.m_DyVal[4], PlayObject.m_DyVal[5]),
                MakeWord(PlayObject.m_DyVal[6], PlayObject.m_DyVal[7])),
                MakeLong(MakeWord(PlayObject.m_DyVal[8], PlayObject.m_DyVal[9]),
                0),
                QuestActionInfo.sParam2);
              boCheckOK := True;
            end;
          nADDNAMELIST: AddList(PlayObject.m_sCharName, m_sPath + QuestActionInfo.sParam1);
          nDELNAMELIST: DelList(PlayObject.m_sCharName, m_sPath + QuestActionInfo.sParam1);
          nADDUSERDATE: AddUseDateList(PlayObject.m_sCharName, m_sPath + QuestActionInfo.sParam1);
          nDELUSERDATE: DELUseDateList(PlayObject.m_sCharName, m_sPath + QuestActionInfo.sParam1);
          nYCCALLMOB: ActionOfCALLMOB(PlayObject, QuestActionInfo);
          nClearCodeList: DelCodeList(m_sPath + QuestActionInfo.sParam1, sMsg);
          ngroupmapmove: Groupmapmove(QuestActionInfo.sParam1,
              QuestActionInfo.sParam2,
              QuestActionInfo.sParam3,
              QuestActionInfo.sParam4,
              QuestActionInfo.sParam5,
              QuestActionInfo.sParam6,
              QuestActionInfo.sParam7);
          nthroughhum:
            begin
              if PlayObject <> nil then
              begin
                PlayObject.m_nCanRun := QuestActionInfo.nParam1;
                PlayObject.m_dwCanRunTime := GetTickCount + QuestActionInfo.nParam2 * 1000;
                PlayObject.SysMsg(Format('您当前穿人模式更改为〖%s〗，时间为%d秒。', [sHumRun[QuestActionInfo.nParam1 mod 3], QuestActionInfo.nParam2]), c_Green, t_Hint);
              end;
            end;
          nADDGUILDLIST: if PlayObject.m_MyGuild <> nil then
              AddList(TGuild(PlayObject.m_MyGuild).sGuildName, m_sPath + QuestActionInfo.sParam1);
          nDELGUILDLIST: if PlayObject.m_MyGuild <> nil then
              DelList(TGuild(PlayObject.m_MyGuild).sGuildName, m_sPath + QuestActionInfo.sParam1);
          nSC_LINEMSG, nSC_SENDMSG: ActionOfLineMsg(PlayObject, QuestActionInfo);
          nSC_SENDSCROLLMSG: ActionOfScrollMsg(PlayObject, QuestActionInfo);
          nSC_SETMERCHANTDLGIMGNAME: ActionOfSetMerchantDlgImgName(PlayObject, QuestActionInfo);

          nADDACCOUNTLIST: AddList(PlayObject.m_sUserID, m_sPath + QuestActionInfo.sParam1);
          nDELACCOUNTLIST: DelList(PlayObject.m_sUserID, m_sPath + QuestActionInfo.sParam1);
          nADDIPLIST: AddList(PlayObject.m_sIPaddr, m_sPath + QuestActionInfo.sParam1);
          nDELIPLIST: DelList(PlayObject.m_sIPaddr, m_sPath + QuestActionInfo.sParam1);
          nGOQUEST: GoToQuest(QuestActionInfo.nParam1);
          nENDQUEST: PlayObject.m_Script := nil;
          nGOTO:
            begin
              if not JmpToLable(QuestActionInfo.sParam1) then
              begin
                MainOutMessageAPI('[脚本死循环] NPC:' + m_sCharName + ' 位置:' + m_sMapName + '(' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) + ')' + ' 命令:' + sGOTO + ' ' + QuestActionInfo.sParam1);
                Result := False;
              end;
            end;
          nSC_HAIRCOLOR: ;
          nSC_WEARCOLOR: ;
          nSC_HAIRSTYLE: ActionOfChangeHairStyle(PlayObject, QuestActionInfo);
          nSC_MONRECALL: ;
          nSC_HORSECALL: ;
          nSC_HAIRRNDCOL: ;
          nSC_KILLHORSE: ;
          nSC_RANDSETDAILYQUEST: ;
          nSC_OPENGAMEGOLDDEAL: ActionOfOpenGameGoldDeal(PlayObject, QuestActionInfo);
          nSC_QUERYGAMEGOLDSELL: ActionOfQueryGameGoldSell(PlayObject, QuestActionInfo);
          nSC_QUERYGAMEGOLDDEAL: ActionOfQueryGameGoldDeal(PlayObject, QuestActionInfo);
          nSC_DROPITEMMAP: ActionOfDropItemMap(PlayObject, QuestActionInfo);

          nSC_RECALLGROUPMEMBERS: ActionOfRecallGroupMembers(PlayObject, QuestActionInfo);
          nSC_GROUPMAPTING: ActionOfGroupMembersMapMove(PlayObject, QuestActionInfo);
          nSC_CLEARNAMELIST: ActionOfClearNameList(PlayObject, QuestActionInfo);
          nSC_MAPTING: ActionOfMapTing(PlayObject, QuestActionInfo);
          nSC_CHANGELEVEL: ActionOfChangeLevel(PlayObject, QuestActionInfo);
          nSC_CHANGETRANPOINT: ActionOfChangeTranPoint(PlayObject, QuestActionInfo);
          nSC_CHANGEIPLEVEL: ActionOfChangeIPLevel(PlayObject, QuestActionInfo);
          nSC_CHANGEHEROLEVEL: ActionOfChangeHeroLevel(PlayObject, QuestActionInfo);
          nSC_CREATEMAPNIMBUS: ActionOfCreateMapNimbus(PlayObject, QuestActionInfo);
          nSC_KILLSLAVENAME: ActionOfKillSlaveName(PlayObject, QuestActionInfo);

          NSC_CLEARMAPITEM: ActionOfClearMapItem(PlayObject, QuestActionInfo);
          nSC_ADDMAPROUTE: ActionOfAddMapRoute(PlayObject, QuestActionInfo);
          nSC_DELMAPROUTE: ActionOfDelMapRoute(PlayObject, QuestActionInfo);

          nSC_MARRY: ActionOfMarry(PlayObject, QuestActionInfo);
          nSC_MASTER: ActionOfMaster(PlayObject, QuestActionInfo);
          nSC_UNMASTER: ActionOfUnMaster(PlayObject, QuestActionInfo);
          nSC_UNMARRY: ActionOfUnMarry(PlayObject, QuestActionInfo);
          nSC_GETMARRY: ActionOfGetMarry(PlayObject, QuestActionInfo);
          nSC_GETMASTER: ActionOfGetMaster(PlayObject, QuestActionInfo);
          nSC_CLEARSKILL: ActionOfClearSkill(PlayObject, QuestActionInfo);
          nSC_CLEARHEROSKILL: ActionOfClearHeroSkill(PlayObject, QuestActionInfo);
          nSC_DELNOJOBSKILL: ActionOfDelNoJobSkill(PlayObject, QuestActionInfo);
          nSC_DELSKILL: ActionOfDelSkill(PlayObject, QuestActionInfo);
          nSC_ADDSKILL: ActionOfAddSkill(PlayObject, QuestActionInfo);
          nSC_SKILLLEVEL: ActionOfSkillLevel(PlayObject, QuestActionInfo);
          nSC_HEROSKILLLEVEL: ActionOfHeroSkillLevel(PlayObject, QuestActionInfo);
          nSC_CHANGEPKPOINT: ActionOfChangePkPoint(PlayObject, QuestActionInfo);
          nSC_CHANGEHEROPKPOINT: ActionOfChangeHeroPkPoint(PlayObject, QuestActionInfo);
          nSC_CHANGEEXP: ActionOfChangeExp(PlayObject, QuestActionInfo);
          nSC_CHANGEIPEXP: ActionOfChangeIPExp(PlayObject, QuestActionInfo);
          nSC_CHANGEHEROEXP: ActionOfChangeHeroExp(PlayObject, QuestActionInfo);
          nSC_CHANGEJOB: ActionOfChangeJob(PlayObject, QuestActionInfo);
          nSC_CHANGEHEROJOB: ActionOfChangeHeroJob(PlayObject, QuestActionInfo);
          nSC_MISSION: ActionOfMission(PlayObject, QuestActionInfo);
          nSC_SETMISSION: ActionOfSetMission(PlayObject, QuestActionInfo);
          nSC_CLEARMISSION: ActionOfClearMission(PlayObject, QuestActionInfo);

          nSC_MOBPLACE: ActionOfMobPlace(PlayObject, QuestActionInfo, n34, n38, n3C, n40);
          nSC_SETMEMBERTYPE: ActionOfSetMemberType(PlayObject, QuestActionInfo);
          nSC_SETMEMBERLEVEL: ActionOfSetMemberLevel(PlayObject, QuestActionInfo);
          nSC_GAMEGOLD: ActionOfGameGold(PlayObject, QuestActionInfo);
          nSC_NIMBUS: ActionOfNimbus(PlayObject, QuestActionInfo);
          nSC_ABILITYADD: ActionOfAbilityAdd(PlayObject, QuestActionInfo);

          nSC_GAMEDIAMOND: ActionOfGameStone(PlayObject, QuestActionInfo);
          nSC_GAMEGIRD: ActionOfGameGird(PlayObject, QuestActionInfo);
          nSC_BONUSABIL: ActionOfBonusAbil(PlayObject, QuestActionInfo);

          nSC_GAMEPOINT: ActionOfGamePoint(PlayObject, QuestActionInfo);
          nSC_AUTOADDGAMEGOLD: ActionOfAutoAddGameGold(PlayObject, QuestActionInfo, n34, n38);
          nSC_AUTOSUBGAMEGOLD: ActionOfAutoSubGameGold(PlayObject, QuestActionInfo, n34, n38);
          nSC_CHANGENAMECOLOR: ActionOfChangeNameColor(PlayObject, QuestActionInfo);
          nSC_CLEARPASSWORD: ActionOfClearPassword(PlayObject, QuestActionInfo);
          nSC_RENEWLEVEL: ActionOfReNewLevel(PlayObject, QuestActionInfo);
          nSC_KILLSLAVE: ActionOfKillSlave(PlayObject, QuestActionInfo);
          nSC_CHANGEGENDER: ActionOfChangeGender(PlayObject, QuestActionInfo);
          nSC_KILLMONEXPRATE: ActionOfKillMonExpRate(PlayObject, QuestActionInfo);
          nSC_SETRANDOMNO:
            begin
              Randomize;
              while True do
              begin
                n2C := Random(9999);
                if (n2C >= 100) and (IntToStr(n2C) <> PlayObject.m_sRandomNo) then
                begin
                  PlayObject.m_sRandomNo := IntToStr(n2C);
                  Break;
                end;
              end;
            end;
          nSC_POWERRATE: ActionOfPowerRate(PlayObject, QuestActionInfo);
          nSC_DETOXIFCATION: ActionofDETOXIFCATION(PlayObject);
          nSC_STATUSRATE: ActionOfStatusRate(PlayObject, QuestActionInfo);
          nSC_NAMECOLOR: ActionOfNameColor(PlayObject, QuestActionInfo);
          nSC_CHANGEMODE: ActionOfChangeMode(PlayObject, QuestActionInfo);
          nSC_CHANGEPERMISSION: ActionOfChangePerMission(PlayObject, QuestActionInfo);
          nSC_KILL: ActionOfKill(PlayObject, QuestActionInfo);
          nSC_KICK: ActionOfKick(PlayObject, QuestActionInfo);
          nSC_BONUSPOINT: ActionOfBonusPoint(PlayObject, QuestActionInfo);
          nSC_RESTRENEWLEVEL: ActionOfRestReNewLevel(PlayObject, QuestActionInfo);
          nSC_DELMARRY: ActionOfDelMarry(PlayObject, QuestActionInfo);
          nSC_DELMASTER: ActionOfDelMaster(PlayObject, QuestActionInfo);
          nSC_CREDITPOINT: ActionOfChangeCreditPoint(PlayObject, QuestActionInfo);
          nSC_HEROCREDITPOINT: ActionOfChangeHeroCreditPoint(PlayObject, QuestActionInfo);
          nSC_CHANGEATTACKMODE: ActionOfChangeAttackMode(PlayObject, QuestActionInfo);

          nSC_CLEARNEEDITEMS: ActionOfClearNeedItems(PlayObject, QuestActionInfo);
          nSC_CLEARMAEKITEMS: ActionOfClearMakeItems(PlayObject, QuestActionInfo);
          nSC_SETSENDMSGFLAG: PlayObject.m_boSendMsgFlag := True;
          nSC_UPGRADEITEMS: ActionOfUpgradeItems(PlayObject, QuestActionInfo);
          nSC_UPGRADEITEMSEX: ActionOfUpgradeItemsEx(PlayObject, QuestActionInfo);
          nSC_MONGENEX: ActionOfMonGenEx(PlayObject, QuestActionInfo);
          nSC_MONGENEX2: ActionOfMonGenEx2(PlayObject, QuestActionInfo);
          nSC_MoveToEscort: ActionOfMoveToEscort(PlayObject, QuestActionInfo);
          NSC_EscortFinish: ActionOfEscortFinish(PlayObject, QuestActionInfo);
          NSC_GiveUpEscort: ActionOfGiveUpEscort(PlayObject, QuestActionInfo);

          nSC_CLEARMAPMON: ActionOfClearMapMon(PlayObject, QuestActionInfo);
          nSC_SETMAPMODE: ActionOfSetMapMode(PlayObject, QuestActionInfo);
          nSC_PKZONE: ActionOfPkZone(PlayObject, QuestActionInfo);
          nSC_RESTBONUSPOINT: ActionOfRestBonusPoint(PlayObject, QuestActionInfo);
          nSC_TAKECASTLEGOLD: ActionOfTakeCastleGold(PlayObject, QuestActionInfo);
          nSC_HUMANHP: ActionOfHumanHP(PlayObject, QuestActionInfo);
          nSC_HUMANMP: ActionOfHumanMP(PlayObject, QuestActionInfo);
          nSC_BUILDPOINT: ActionOfGuildBuildPoint(PlayObject, QuestActionInfo);
          nSC_AURAEPOINT: ActionOfGuildAuraePoint(PlayObject, QuestActionInfo);
          nSC_STABILITYPOINT: ActionOfGuildstabilityPoint(PlayObject, QuestActionInfo);
          nSC_FLOURISHPOINT: ActionOfGuildFlourishPoint(PlayObject, QuestActionInfo);
          nSC_OPENMAGICBOX: ActionOfOpenMagicBox(PlayObject, QuestActionInfo);
          nSC_SETRANKLEVELNAME: ActionOfSetRankLevelName(PlayObject, QuestActionInfo);
          nSC_OFFLINE: ActionOfOffLine(PlayObject, QuestActionInfo);
          nSC_OFFLINEPLAY: ActionOfOffLinePlay(PlayObject, QuestActionInfo);

          nSC_QUERYBINDITEM: PlayObject.SendDefMessage(SM_QUERYBINDITEM, Integer(Self), QuestActionInfo.nParam1, 0, 0, '');
          nSC_BINDRESUME: PlayObject.m_boCanBind := True;
          nSC_UNBINDRESUME: PlayObject.m_boCanUnBind := True;

          nSC_SETOFFLINE: ActionOfSetOffLine(PlayObject, QuestActionInfo);
          nSC_STARTTAKEGOLD: ActionOfSTARTTAKEGOLD(PlayObject, QuestActionInfo);
          nSC_DELAYCALL, nSC_DELAYGOTO: ActionOfDelayCall(PlayObject, QuestActionInfo);
          nSC_CLEARDELAYGOTO:
            begin
              for n2C := 0 to PlayObject.m_DelayCallList.Count - 1 do
              begin
                pDelayCallNPC := PlayObject.m_DelayCallList[n2C];
                pDelayCallNPC.bProcessed := True;
                pDelayCallNPC.dwReleaseTick := GetTickCount;
                //Dispose(PTDelayCallNPC(PlayObject.m_DelayCallList[n2C]));
                //PlayObject.m_DelayCallList.Clear;
              end;
            end;
          nSC_CHATCOLOR: ActionOfSetChatColor(PlayObject, QuestActionInfo);
          nSC_CHATFONT: ActionOfSetChatFont(PlayObject, QuestActionInfo);
          nSC_GUILDMAPMOVE: ActionOfGuildMapMove(PlayObject, QuestActionInfo);
          nSC_RECALLPNEUMA: PlayObject.CmdRecallHero(nil, PlayObject.m_sPneumaName, '', True);
          nSC_RECALLHeroEX: PlayObject.CmdRecallHero(nil, PlayObject.m_sPneumaName, '', False);
          nSC_ADDGUILD: ActionOfAddGuild(PlayObject, QuestActionInfo);
          nSC_REPAIRALL: ActionOfRepairAllItem(PlayObject, QuestActionInfo);
          nSC_CREATEHERO: ActionOfCreateHero(PlayObject, QuestActionInfo);
          nSC_CREATEHEROEX: ActionOfCreateHeroEx(PlayObject, QuestActionInfo);

          nSC_DELETEHERO: ActionOfDeleteHero(PlayObject, QuestActionInfo);
          nSC_TAGMAPINFO: ActionOfTagMapInfo(PlayObject, QuestActionInfo);
          nSC_TAGMAPMOVE: ActionOfTagMapMove(PlayObject, QuestActionInfo);
          nSC_RECALLPLAYER: ActionOfRecallPlayer(PlayObject, sMsg);
          nSC_RECALLHERO: ActionOfRecallHero(PlayObject, QuestActionInfo);
          nSC_AFFILIATEGUILD: ActionOfAffiliateGuild(PlayObject, QuestActionInfo);
          nSC_MAPMOVEHUMAN: ActionOfMapMoveHuman(PlayObject, QuestActionInfo);
          nSC_SETTARGETXY: ActionOfClientSetTargetXY(PlayObject, QuestActionInfo);
          nSC_QUERYITEMDLG: ActionOfQueryItemDlg(PlayObject, QuestActionInfo);
          nSC_QUERYVALUE: ActionOfQueryValue(PlayObject, QuestActionInfo);
          nSC_RELEASECOLLECTEXP: ActionOfReleaseCollectExp(PlayObject, QuestActionInfo);
          nSC_RESETCOLLECTEXPSTATE: ActionOfReSetCollectExpState(PlayObject, QuestActionInfo);
          nSC_GETSTRLENGTH: ActionOfGetStrLength(PlayObject, QuestActionInfo);
          nSC_GETPOSENAME: ActionOfGetPoseName(PlayObject, QuestActionInfo);

          nSC_CHANGEVENATIONLEVEL: ActionOfChangeVenationLevel(PlayObject, QuestActionInfo);
          nSC_CHANGEVENATIONPOINT: ActionOfChangeVenationPoint(PlayObject, QuestActionInfo);
          nSC_CLEARVENATIONDATA: ActionOfClearVenationData(PlayObject, QuestActionInfo);
          nSC_CONVERTSKILL: ActionOfConvertSkill(PlayObject, QuestActionInfo);

          nSC_UPGRADEDLGITEM: ActionOfUpgradeDlgItem(PlayObject, QuestActionInfo);
          nSC_GETDLGITEMVALUE: ActionOfGetDlgItemValue(PlayObject, QuestActionInfo);
          nSC_TAKEDLGITEM: ActionOfDeleteDlgItem(PlayObject, QuestActionInfo);
          nSC_ADDLINELIST: ActionOfWriteLineList(PlayObject, QuestActionInfo);
          nSC_DELLINELIST: ActionOfDeleteLineList(PlayObject, QuestActionInfo);

          nSC_QUERYBAGITEMS: ActionOfQueryBagItems(PlayObject, QuestActionInfo);
          nSC_SETATTRIBUTE: ActionOfSetAttribute(PlayObject, QuestActionInfo);
          nSC_SETOFFLINEFUNC: PlayObject.m_sOffLineLabel := QuestActionInfo.sParam1;
          nSC_GMEXECUTE: ActionOfGmExecute(PlayObject, QuestActionInfo);
          nSC_GUILDCHIEFITEMCOUNT: ActionOfGuildChiefItemCount(PlayObject, QuestActionInfo);
          nSC_ADDNAMEDATELIST: ActionOfAddNameDateList(PlayObject, QuestActionInfo);
          nSC_DELNAMEDATELIST: ActionOfDelNameDateList(PlayObject, QuestActionInfo);
          nSC_MOBFIREBURN: ActionOfMobFireBurn(PlayObject, QuestActionInfo);
          nSC_MESSAGEBOX: ActionOfMessageBox(PlayObject, QuestActionInfo);
          nSC_SETSCRIPTFLAG: ActionOfSetScriptFlag(PlayObject, QuestActionInfo);
          nSC_SETAUTOGETEXP: ActionOfAutoGetExp(PlayObject, QuestActionInfo);
          nSC_VAR: ActionOfVar(PlayObject, QuestActionInfo);
          nSC_LOADVAR: ActionOfLoadVar(PlayObject, QuestActionInfo);
          nSC_SAVEVAR: ActionOfSaveVar(PlayObject, QuestActionInfo);
          nSC_CALCVAR: ActionOfCalcVar(PlayObject, QuestActionInfo);
          nSC_CLEAREctype: ActionOfClearEctype(PlayObject, QuestActionInfo);
          nSC_READINITEXT: ActionOfReadIniText(PlayObject, QuestActionInfo);
          nSC_WRITEINITEXT: ActionOfWriteIniText(PlayObject, QuestActionInfo);
          nSC_AUTOMOVE: ActionOfAutoMove(PlayObject, QuestActionInfo);
          nSC_GETTITLESCOUNT: ActionOfGetTitlesCount(PlayObject, QuestActionInfo);
          {else if Assigned(Engine_SetScriptAction) then //if @Engine_SetScriptAction <> nil then
            Engine_SetScriptAction(Self, PlayObject,
              QuestActionInfo.nCMDCode,
              PChar(QuestActionInfo.sParam1),
              QuestActionInfo.nParam1,
              PChar(QuestActionInfo.sParam2),
              QuestActionInfo.nParam2,
              PChar(QuestActionInfo.sParam3),
              QuestActionInfo.nParam3,
              PChar(QuestActionInfo.sParam4),
              QuestActionInfo.nParam4,
              PChar(QuestActionInfo.sParam5),
              QuestActionInfo.nParam5,
              PChar(QuestActionInfo.sParam6),
              QuestActionInfo.nParam6);}
        end;
      end;
    finally
      if QuestActionInfo <> nil then
      begin
        Dispose(QuestActionInfo);
        QuestActionInfo := nil;
      end;
    end;
  end;

  procedure SendMerChantSayMsg(sMsg: string; boFlag: Boolean; SendMsgObject: TPlayObject);
  var
    s10, s14: string;
    nC: Integer;
    PlayObject: TPlayObject;
  begin
    s14 := sMsg;
    nC := 0;
    PlayObject := SendMsgObject;

    //if Self.ClassType = TMerchant then
    PlayObject.SendDefMessage(SM_SetMerchantDlgImgName, 0, 0, 0, 0, m_sMDlgImgName);

    while (True) do
    begin
      //if TagCount(s14, '>') < 1 then
      if Pos('>', s14) <= 0 then
        Break;
      s14 := ArrestStringEx(s14, '<', '>', s10);
      if (s10 <> '') and (s10[1] = '$') then
        GetVariableText(PlayObject, sMsg, s10);
      Inc(nC);
      if (nC >= 101) then
        Break;
    end;
    try
      if SendMsgObject.IsHero then
        PlayObject := SendMsgObject.m_Master as TPlayObject;
    except
      PlayObject := SendMsgObject;
    end;
    //if not PlayObject.m_boHideSendSayMsg then begin
    PlayObject.GetScriptLabel(sMsg);
    if boFlag then
      PlayObject.SendFirstMsg(Self, RM_MERCHANTSAY, 0, 0, 0, 0, m_sCharName + '/' + sMsg)
    else
      PlayObject.SendMsg(Self, RM_MERCHANTSAY, 0, 0, 0, 0, m_sCharName + '/' + sMsg);
    //end else
    //  PlayObject.m_boHideSendSayMsg := False;
  end;

var bContinue: Boolean;
begin

  bContinue := True;
  PlayObject := ActObject;
  if PlayObject.m_btRaceServer <> RC_PLAYOBJECT then bContinue := False;
  if not bContinue then exit;

  if (m_LastOprLabel = sLabel) and (m_LastOprObject = PlayObject) and (GetTickCount() - m_dwGotoLabelTick <= 1) then
  begin
    Inc(m_OprCount);
    if m_OprCount > 15 then
    begin
      s := Format('[脚本死循环] %s%s-%s.txt [%s]', [m_sPath, m_sCharName, m_sMapName, sLabel]);
      if (PlayObject.m_btPermission >= 6) then
        PlayObject.SysMsg(s, c_Red, t_Hint);
      MainOutMessageAPI(s);
      m_OprCount := 0;
      Exit;
    end;
  end
  else if m_OprCount > 0 then
    m_OprCount := 0;

  m_LastOprObject := PlayObject;
  m_LastOprLabel := sLabel;
  m_dwGotoLabelTick := GetTickCount();

  Script := nil;
  if PlayObject.m_NPC <> Self then
  begin
    PlayObject.m_NPC := nil;
    PlayObject.m_Script := nil;
    FillChar(PlayObject.m_nVal, SizeOf(PlayObject.m_nVal), #0);
  end;
  if CompareText(sLabel, '@main') = 0 then
  begin
    for i := 0 to m_ScriptList.Count - 1 do
    begin
      Script3C := m_ScriptList.Items[i];
      for ii := 0 to Script3C.RecordList.Count - 1 do
      begin
        SayingRecord := Script3C.RecordList.Items[ii];
        if CompareText(sLabel, SayingRecord.sLabel) = 0 then
        begin
          Script := Script3C;
          PlayObject.m_Script := Script;
          PlayObject.m_NPC := Self;
          Break;
        end;
        if Script <> nil then
          Break;
      end;
    end;
  end;
  if Script = nil then
  begin
    if (PlayObject.m_Script <> nil) and (m_ScriptList <> nil) then
    begin
      for i := m_ScriptList.Count - 1 downto 0 do
      begin
        if m_ScriptList.Items[i] = PlayObject.m_Script then
        begin
          Script := m_ScriptList.Items[i];
          {break; BLUE ???}
        end;
      end;
    end;
    if Script = nil then
    begin
      if (m_ScriptList <> nil) then
      begin
        for i := m_ScriptList.Count - 1 downto 0 do
        begin
          if CheckQuestStatus(pTScript(m_ScriptList.Items[i])) then
          begin
            Script := m_ScriptList.Items[i];
            PlayObject.m_Script := Script;
            PlayObject.m_NPC := Self;
          end;
        end;
      end;
    end;
  end;
  //跳转到指定示签执行
  if (Script <> nil) then
  begin
    nBatch := 0;
    ListBatch := TStringList.Create;
    for ii := 0 to Script.RecordList.Count - 1 do
    begin
      SayingRecord := Script.RecordList.Items[ii];
      if CompareText(sLabel, SayingRecord.sLabel) = 0 then
      begin
        if boExtJmp and not SayingRecord.boExtJmp then
          Break;
        sSENDMSG := '';
        tQuestUser := nil;
        for III := 0 to SayingRecord.ProcedureList.Count - 1 do
        begin
          SayingProcedure := SayingRecord.ProcedureList.Items[III];
          boCheckOK := False;
          tQuestUser := nil;
          if QuestCheckCondition(SayingProcedure.ConditionList, PlayObject, tQuestUser) then
          begin
            sSENDMSG := sSENDMSG + SayingProcedure.sSayMsg;
            if not QuestActionProcess(SayingProcedure.ActionList, PlayObject) then
              Break;
            if boCheckOK then
            begin
              if (tQuestUser <> nil) then
              begin
                //if tQuestUser.IsHero then
                //  tqu := tQuestUser.m_Master as TPlayObject
                //else
                tqu := tQuestUser;
              end
              else
                tqu := PlayObject;
              SendMerChantSayMsg(sSENDMSG, True, tqu);
            end;
          end
          else
          begin
            sSENDMSG := sSENDMSG + SayingProcedure.sElseSayMsg;
            if not QuestActionProcess(SayingProcedure.ElseActionList, PlayObject) then
              Break;
            if boCheckOK then
            begin
              if (tQuestUser <> nil) then
              begin
                //if tQuestUser.IsHero then
                //  tqu := tQuestUser.m_Master as TPlayObject
                //else
                tqu := tQuestUser;
              end
              else
                tqu := PlayObject;
              SendMerChantSayMsg(sSENDMSG, True, tqu);
            end;
          end;
        end;
        if (sSENDMSG <> '') then
        begin
          if (tQuestUser <> nil) then
          begin
            //if tQuestUser.IsHero then
            //  tqu := tQuestUser.m_Master as TPlayObject
            //else
            tqu := tQuestUser;
          end
          else
            tqu := PlayObject;
          SendMerChantSayMsg(sSENDMSG, False, tqu);
        end;
        Break;
      end;
    end;
    ListBatch.Free;
  end;

{$IF VER_ClientType_45}
  if not (PlayObject.m_wClientType in [45, 46]) then
  begin
    if CompareText(sLabel, '@selloff') = 0 then
      PlayObject.SendMsg(Self, RM_SELLOFF, 0, 0, 0, 0, '');
    if CompareText(sLabel, '@buyoff') = 0 then
      PlayObject.SendMsg(Self, RM_BUYOFF, 0, 0, 0, 0, '');
    //取款
    ii := 0;
    III := 0;
    if CompareText(sLabel, '@getsellgold') = 0 then
    begin
      List := TMerchant(Self).m_SellgoldList;
      for i := List.Count - 1 downto 0 do
      begin
        SellOff := pSellOff(List[i]);
        if SellOff^.sCharName = PlayObject.m_sCharName then
        begin
          s14 := '';
          if SellOff^.item.btValue[13] = 1 then
            s14 := ItemUnit.GetCustomItemName(SellOff^.item.MakeIndex, SellOff^.item.wIndex);
          if s14 = '' then
            s14 := UserEngine.GetStdItemName(SellOff^.item.wIndex);
          Inc(ii, SellOff^.Price);
          Inc(III, SellOff^.Tax);
          List.Delete(i);
          Dispose(SellOff);
          SC := '物品: ' + s14 + '金额:' + IntToStr(SellOff^.Price) + '(税)' + IntToStr(SellOff^.Tax) + ' ' + g_Config.sGameGoldName + '  拍卖日期:' + DateTimeToStr(SellOff^.SellTime) + '';
          PlayObject.SysMsg(SC, c_Green, t_Hint);
        end;
      end;
      if ii > 0 then
      begin
        PlayObject.m_nGameGold := PlayObject.m_nGameGold + ii;
        PlayObject.GameGoldChanged;
        PlayObject.SysMsg('总金额:' + IntToStr(ii) + '(税)' + IntToStr(III) + g_Config.sGameGoldName, c_Green, t_Hint);
        TMerchant(Self).SaveSellGold;
        if g_boGameLogGameGold then
          AddGameDataLogAPI(Format(g_sGameLogMsg1, [LOG_GAMEGOLD, PlayObject.m_sMapName, PlayObject.m_nCurrX, PlayObject.m_nCurrY, PlayObject.m_sCharName, g_Config.sGameGoldName, ii, '+', m_sCharName]));
      end;
    end;
  end;
{$IFEND VER_ClientType_45}
end;

procedure TNormNpc.LoadNpcScript;
var
  s08: string;
begin
  if m_boIsQuest then
  begin
    m_sPath := sNpc_def;
    s08 := m_sCharName + '-' + m_sMapName;
    FrmDB.LoadNpcScript(Self, m_sFilePath, s08);
  end
  else
  begin
    m_sPath := m_sFilePath;
    FrmDB.LoadNpcScript(Self, m_sFilePath, m_sCharName);
  end;
end;

function TNormNpc.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);
end;

procedure TNormNpc.Run;
begin
  if m_Master <> nil then
    m_Master := nil;
  inherited;
end;

procedure TNormNpc.ScriptActionError(PlayObject: TPlayObject; sErrMsg: string; QuestActionInfo: pTQuestActionInfo; sCmd: string);
var
  sMsg: string;
resourcestring
  sOutMessage = '[脚本错误] %s 脚本命令:%s NPC名称:%s 地图:%s(%d:%d) 参数1:%s 参数2:%s 参数3:%s 参数4:%s 参数5:%s 参数6:%s 参数7:%s 参数8:%s 参数9:%s 参数10:%s';
begin
  sMsg := Format(sOutMessage, [sErrMsg,
    sCmd,
      m_sCharName,
      m_sMapName,
      m_nCurrX,
      m_nCurrY,
      QuestActionInfo.sParam1,
      QuestActionInfo.sParam2,
      QuestActionInfo.sParam3,
      QuestActionInfo.sParam4,
      QuestActionInfo.sParam5,
      QuestActionInfo.sParam6,
      QuestActionInfo.sParam7,
      QuestActionInfo.sParam8,
      QuestActionInfo.sParam9,
      QuestActionInfo.sParam10]);
  MainOutMessageAPI(sMsg);
end;

procedure TNormNpc.ScriptConditionError(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo; sCmd: string);
var
  sMsg: string;
begin
  sMsg := 'Cmd:' + sCmd +
    ' NPC名称:' + m_sCharName +
    ' 地图:' + m_sMapName +
    ' 座标:' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) +
    ' 参数1:' + QuestConditionInfo.sParam1 +
    ' 参数2:' + QuestConditionInfo.sParam2 +
    ' 参数3:' + QuestConditionInfo.sParam3 +
    ' 参数4:' + QuestConditionInfo.sParam4 +
    ' 参数5:' + QuestConditionInfo.sParam5;
  MainOutMessageAPI('[脚本参数不正确] ' + sMsg);
end;

procedure TNormNpc.SendMsgToUser(PlayObject: TPlayObject; sMsg: string);
begin
  PlayObject.SendMsg(Self, RM_MERCHANTSAY, 0, 0, 0, 0, m_sCharName + '/' + sMsg);
end;

function TNormNpc.ExVariableText(sMsg, sStr, sText: string): string; //0049ADB8
var
  n10: Integer;
  s14, s18: string;
begin
  n10 := Pos(sStr, sMsg);
  if n10 > 0 then
  begin
    s14 := Copy(sMsg, 1, n10 - 1);
    s18 := Copy(sMsg, Length(sStr) + n10, Length(sMsg));
    Result := s14 + sText + s18;
  end
  else
    Result := sMsg;
end;

procedure TNormNpc.UserSelect(PlayObject: TPlayObject; sData: string); //0049EC28
var
  sMsg, sLabel: string;
begin
  m_OprCount := 0;
  PlayObject.m_nScriptGotoCount := 0;

  //处理脚本命令 @back 返回上级标签内容
  if (sData <> '') and (sData[1] = '@') then
  begin
    sMsg := GetValidStr3(sData, sLabel, [#13]);
    if (PlayObject.m_sScriptCurrLable <> sLabel) then
    begin
      if (sLabel <> sBACK) then
      begin
        PlayObject.m_sScriptGoBackLable := PlayObject.m_sScriptCurrLable;
        PlayObject.m_sScriptCurrLable := sLabel;
      end
      else
      begin
        if PlayObject.m_sScriptCurrLable <> '' then
          PlayObject.m_sScriptCurrLable := ''
        else
          PlayObject.m_sScriptGoBackLable := '';
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfChangeNameColor(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nColor: Integer;
begin
  nColor := QuestActionInfo.nParam1;
  if (nColor < 0) or (nColor > 255) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGENAMECOLOR);
    Exit;
  end;
  PlayObject.m_btNameColor := nColor;
  PlayObject.RefNameColor();
end;

procedure TNormNpc.ActionOfClearPassword(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_sStoragePwd := '';
  PlayObject.m_boPasswordLocked := False;
end;

procedure TNormNpc.ActionOfRecallmob(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  Mon: TBaseObject;
begin
  Mon := PlayObject.MakeSlave(QuestActionInfo.sParam1,
    3,
    Str_ToInt(QuestActionInfo.sParam2, 0),
    Str_ToInt(QuestActionInfo.sParam3, 1),
    QuestActionInfo.nParam4 * 60,
    255,
    -1,
    QuestActionInfo.sParam7 = '');
  if Mon <> nil then
  begin
    if (QuestActionInfo.sParam5 <> '') and (QuestActionInfo.sParam5[1] = '1') then
      Mon.m_boAutoChangeColor := True
    else if QuestActionInfo.nParam6 > 0 then
    begin
      Mon.m_boFixColor := True;
      Mon.m_nFixColorIdx := QuestActionInfo.nParam6 - 1;
    end;
  end;
end;

procedure TNormNpc.ActionOfRecallmobEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  boShow: Boolean;
  Mon: TBaseObject;
begin
  boShow := False;
  if QuestActionInfo.sParam9 = '' then
    boShow := True;
  Mon := PlayObject.MakeSlaveEx(QuestActionInfo.sParam1, QuestActionInfo.nParam2, QuestActionInfo.nParam3,
    3,
    Str_ToInt(QuestActionInfo.sParam4, 0),
    Str_ToInt(QuestActionInfo.sParam5, 1),
    QuestActionInfo.nParam6 * 60,
    255,
    -1,
    boShow);
  if Mon <> nil then
  begin
    if (QuestActionInfo.sParam7 <> '') and (QuestActionInfo.sParam7[1] = '1') then
      Mon.m_boAutoChangeColor := True
    else if QuestActionInfo.nParam8 > 0 then
    begin
      Mon.m_boFixColor := True;
      Mon.m_nFixColorIdx := QuestActionInfo.nParam8 - 1;
    end;
  end;
end;

procedure TNormNpc.ActionOfReNewLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nReLevel, nLevel: Integer;
  nBounsuPoint: Integer;
begin
  nReLevel := Str_ToInt(QuestActionInfo.sParam1, -1);
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  nBounsuPoint := Str_ToInt(QuestActionInfo.sParam3, -1);
  if (nReLevel < 0) or (nLevel < 0) or (nBounsuPoint < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_RENEWLEVEL);
    Exit;
  end;

  if (PlayObject.m_btReLevel + nReLevel) <= 255 then
  begin
    Inc(PlayObject.m_btReLevel, nReLevel);
    if nLevel > 0 then
      PlayObject.m_Abil.Level := nLevel;
    if g_Config.boReNewLevelClearExp then
      PlayObject.m_Abil.Exp := 0;
    Inc(PlayObject.m_nBonusPoint, nBounsuPoint);
    PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
    PlayObject.HasLevelUp();
    PlayObject.RefShowName();
  end;
end;

procedure TNormNpc.ActionOfChangeGender(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nGENDER: Integer;
begin
  nGENDER := Str_ToInt(QuestActionInfo.sParam1, -1);
  if not (nGENDER in [0, 1]) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEGENDER);
    Exit;
  end;

  PlayObject.m_btGender := nGENDER;
  PlayObject.FeatureChanged;
end;

procedure TNormNpc.ActionOfKillSlave(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sMonName: string;
  nX, nY, nRange, nCount: Integer;
  Envir: TEnvirnoment;
  MonList: TList;
  BaseObject: TBaseObject;
begin
  if CompareText(QuestActionInfo.sParam1, 'SELF') = 0 then
  begin
    if PlayObject.m_PEnvir <> nil then
      Envir := PlayObject.m_PEnvir;
  end
  else
    Envir := g_MapManager.FindMap(QuestActionInfo.sParam1);
  nX := Str_ToInt(QuestActionInfo.sParam2, -1);
  nY := Str_ToInt(QuestActionInfo.sParam3, -1);
  nRange := Str_ToInt(QuestActionInfo.sParam4, -1);
  sMonName := QuestActionInfo.sParam5;
  nCount := Str_ToInt(QuestActionInfo.sParam6, -1);
  if (Envir = nil) or (nX < 0) or (nY < 0) or (nRange < 0) or (nCount < 0) or (sMonName = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_KILLSLAVE);
    Exit;
  end;
  MonList := TList.Create;
  Envir.GetRangeBaseObject(nX, nY, nRange, True, MonList);
  nRange := 0;
  for i := MonList.Count - 1 downto 0 do
  begin
    BaseObject := TBaseObject(MonList.Items[i]);
    if BaseObject.IsHero or (BaseObject.m_Master <> PlayObject) then
      Continue;
    if (sMonName = '*') or (CompareText(BaseObject.m_sCharName, sMonName) = 0) then
    begin
      if QuestActionInfo.nParam7 = 0 then
        BaseObject.MakeGhost
      else
        BaseObject.m_WAbil.HP := 0;
      Inc(nRange);
      if nRange >= nCount then
        Break;
    end;
  end;
  MonList.Free;
end;

procedure TNormNpc.ActionOfKillMonExpRate(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nRate: Integer;
  nTime: Integer;
begin
  nRate := Str_ToInt(QuestActionInfo.sParam1, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nRate < 0) or (nTime < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_KILLMONEXPRATE);
    Exit;
  end;
  PlayObject.m_nKillMonExpRate := nRate;
  //PlayObject.m_dwKillMonExpRateTime:=_MIN(High(Word),nTime);
  PlayObject.m_dwKillMonExpRateTime := LongWord(nTime);
  if g_Config.boShowScriptActionMsg then
    PlayObject.SysMsg(Format(g_sChangeKillMonExpRateMsg, [PlayObject.m_nKillMonExpRate / 100, PlayObject.m_dwKillMonExpRateTime]), c_Green, t_Hint);
end;

procedure TNormNpc.ActionOfMonGenEx(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sMapName, sMonName: string;
  nMapX, nMapY, nRange, nCount: Integer;
  nRandX, nRandY: Integer;
begin
  sMapName := QuestActionInfo.sParam1;
  nMapX := Str_ToInt(QuestActionInfo.sParam2, -1);
  nMapY := Str_ToInt(QuestActionInfo.sParam3, -1);
  sMonName := QuestActionInfo.sParam4;
  nRange := QuestActionInfo.nParam5;
  nCount := QuestActionInfo.nParam6;
  if (sMapName = '') or (nMapX <= 0) or (nMapY <= 0) or (sMapName = '') or
    (nRange <= 0) or (nCount <= 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MONGENEX);
    Exit;
  end;
  for i := 0 to nCount - 1 do
  begin
    nRandX := Random(nRange * 2 + 1) + (nMapX - nRange);
    nRandY := Random(nRange * 2 + 1) + (nMapY - nRange);
    if UserEngine.RegenMonsterByName(sMapName, nRandX, nRandY, sMonName) = nil then
    begin
      //ScriptActionError(PlayObject,'',QuestActionInfo,sSC_MONGENEX);
      Break;
    end;
  end;
end;

procedure TNormNpc.ActionOfMonGenEx2(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  sMonName: string;
  Mon: TBaseObject;
begin
  Mon := UserEngine.GetEscort(PlayObject.m_sCharName);
  if Mon <> nil then
  begin
    GotoLable(PlayObject, '@isEscorting', False);
    Exit;
  end;

  if (PlayObject.m_Escort <> nil) and
    not PlayObject.m_Escort.m_boGhost and
    not PlayObject.m_Escort.m_boDeath then
  begin
    GotoLable(PlayObject, '@isEscorting', False);
    Exit;
  end;

  sMonName := QuestActionInfo.sParam1;

  if (sMonName = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MONGENEX2);
    Exit;
  end;

  Mon := UserEngine.RegenEscort(PlayObject.m_sMapName, sMonName, PlayObject);
  if Mon <> nil then
  begin
    Mon.m_Master := PlayObject;
    Mon.m_dwMasterRoyaltyTick := GetTickCount + Round(45 * 60 / 10 * g_Config.dwMasterRoyaltyRate) * 1000;
    Mon.m_btSlaveMakeLevel := 3;
    Mon.m_btSlaveExpLevel := 0;
    Mon.RecalcAbilitys();
    Mon.RefNameColor();
    if QuestActionInfo.sParam2 <> '' then
      Mon.m_boShowMasterName := False;
    PlayObject.m_Escort := Mon;
  end
  else
  begin
    GotoLable(PlayObject, '@EscortFail', False);
  end;
end;

procedure TNormNpc.ActionOfMoveToEscort(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nX, nY: Integer;
  Mon: TBaseObject;
begin
  Mon := UserEngine.GetEscort(PlayObject.m_sCharName);
  if Mon = nil then
  begin
    GotoLable(PlayObject, '@MoveToEscort_Fail_1', False);
    Exit;
  end;

  if (PlayObject.m_Escort = nil) or
    PlayObject.m_Escort.m_boGhost or
    PlayObject.m_Escort.m_boDeath then
  begin
    GotoLable(PlayObject, '@MoveToEscort_Fail_1', False);
    Exit;
  end;

  if PlayObject.m_Escort.m_PEnvir = nil then
  begin
    GotoLable(PlayObject, '@MoveToEscort_Fail_2', False);
    Exit;
  end;

  if PlayObject.m_Escort.GetRecallXY(PlayObject.m_Escort.m_nCurrX, PlayObject.m_Escort.m_nCurrY, 3, nX, nY) then
  begin
    PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
    PlayObject.SpaceMove(PlayObject.m_Escort.m_sMapName, nX, nY, 0);
  end;
end;

procedure TNormNpc.ActionOfEscortFinish(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  Mon: TBaseObject;
begin
  Mon := UserEngine.GetEscort(PlayObject.m_sCharName);
  if Mon = nil then
  begin
    GotoLable(PlayObject, '@FinishEscort_Fail_1', False);
    Exit;
  end;

  if (PlayObject.m_Escort = nil) or
    PlayObject.m_Escort.m_boGhost or
    PlayObject.m_Escort.m_boDeath then
  begin
    GotoLable(PlayObject, '@FinishEscort_Fail_1', False);
    Exit;
  end
  else
  begin
    if ((abs(m_nCurrX - PlayObject.m_Escort.m_nCurrX) > 8) or (abs(m_nCurrY - PlayObject.m_Escort.m_nCurrY) > 8)) then
    begin
      GotoLable(PlayObject, '@FinishEscort_Fail_2', False);
      Exit;
    end;
  end;

  GotoLable(PlayObject, '@FinishEscort_' + PlayObject.m_Escort.m_sCharName, False);
end;

function TNormNpc.ConditionOfIsEscortIng(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;

  if UserEngine.GetEscort(PlayObject.m_sCharName) = nil then Exit;

  if (PlayObject.m_Escort = nil) or
    PlayObject.m_Escort.m_boGhost or
    PlayObject.m_Escort.m_boDeath then
    Exit;

  //if ((abs(PlayObject.m_nCurrX - PlayObject.m_Escort.m_nCurrX) > 8) or (abs(PlayObject.m_nCurrY - PlayObject.m_Escort.m_nCurrY) > 8)) then
  //  Exit;

  Result := True;
end;

function TNormNpc.ConditionOfCheckEscortInNear(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;

  if UserEngine.GetEscort(PlayObject.m_sCharName) = nil then
    Exit;

  if (PlayObject.m_Escort = nil) or
    PlayObject.m_Escort.m_boGhost or
    PlayObject.m_Escort.m_boDeath then
    Exit;

  if ((abs(PlayObject.m_nCurrX - PlayObject.m_Escort.m_nCurrX) > 8) or (abs(PlayObject.m_nCurrY - PlayObject.m_Escort.m_nCurrY) > 8)) then
    Exit;

  Result := True;
end;

procedure TNormNpc.ActionOfGiveUpEscort(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  Mon: TBaseObject;
begin
  Mon := UserEngine.GetEscort(PlayObject.m_sCharName);
  if Mon = nil then
  begin
    //PlayObject.SysMsg('你没有押运的镖车，放弃任务失败！', c_Green, t_Hint);
    Exit;
  end;

  if (PlayObject.m_Escort = nil) or
    PlayObject.m_Escort.m_boGhost or
    PlayObject.m_Escort.m_boDeath then
  begin
    //PlayObject.SysMsg('你没有押运的镖车，放弃任务失败！', c_Green, t_Hint);
    Exit;
  end;
  if Mon = PlayObject.m_Escort then
  begin
    Mon.MakeGhost;
    Mon.m_Master := nil;
    PlayObject.m_Escort := nil;
  end;
end;

procedure TNormNpc.ActionOfOpenMagicBox(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  Monster: TBaseObject;
  sMonName: string;
  nX, nY: Integer;
begin
  sMonName := QuestActionInfo.sParam1;
  if sMonName = '' then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_OPENMAGICBOX);
    Exit;
  end;
  PlayObject.GetFrontPosition(nX, nY);
  Monster := UserEngine.RegenMonsterByName(PlayObject.m_PEnvir.m_sMapFileName, nX, nY, sMonName);
  if Monster = nil then
  begin
    Exit;
  end;
  Monster.Die;
end;

procedure TNormNpc.ActionOfPkZone(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nX, nY: Integer;
  FireBurnEvent: TFireBurnEvent;
  nMinX, nMaxX, nMinY, nMaxY: Integer;
  nRange, nType, nTime, nPoint: Integer;
begin
  nRange := Str_ToInt(QuestActionInfo.sParam1, -1);
  nType := Str_ToInt(QuestActionInfo.sParam2, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam3, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam4, -1);
  if (nRange < 0) or (nType < 0) or (nTime < 0) or (nPoint < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_PKZONE);
    Exit;
  end;
  nMinX := m_nCurrX - nRange;
  nMaxX := m_nCurrX + nRange;
  nMinY := m_nCurrY - nRange;
  nMaxY := m_nCurrY + nRange;
  for nX := nMinX to nMaxX do
  begin
    for nY := nMinY to nMaxY do
    begin
      if ((nX < nMaxX) and (nY = nMinY)) or
        ((nY < nMaxY) and (nX = nMinX)) or
        (nX = nMaxX) or (nY = nMaxY) then
      begin
        FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, nType, nTime * 1000, nPoint, 0);
        g_EventManager.AddEvent(FireBurnEvent);
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfPowerRate(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nRate: Integer;
  nTime: Integer;
begin
  nRate := Str_ToInt(QuestActionInfo.sParam1, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nRate < 0) or (nTime < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_POWERRATE);
    Exit;
  end;
  PlayObject.m_nPowerRate := nRate;
  PlayObject.m_dwPowerRateTime := LongWord(nTime);
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sChangePowerRateMsg, [PlayObject.m_nPowerRate / 100, PlayObject.m_dwPowerRateTime]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfChangeMode(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nMode: Integer;
  boOpen: Boolean;
begin
  nMode := QuestActionInfo.nParam1;
  boOpen := Str_ToInt(QuestActionInfo.sParam2, -1) = 1;
  if nMode in [1..3] then
  begin
    case nMode of
      1:
        begin
          PlayObject.m_boAdminMode := boOpen;
          if PlayObject.m_boAdminMode then
            PlayObject.SysMsg(sGameMasterMode, c_Green, t_Hint)
          else
            PlayObject.SysMsg(sReleaseGameMasterMode, c_Green, t_Hint);
        end;
      2:
        begin
          PlayObject.m_boSuperMan := boOpen;
          if PlayObject.m_boSuperMan then
            PlayObject.SysMsg(sSupermanMode, c_Green, t_Hint)
          else
            PlayObject.SysMsg(sReleaseSupermanMode, c_Green, t_Hint);
        end;
      3:
        begin
          PlayObject.m_boObMode := boOpen;
          if PlayObject.m_boObMode then
            PlayObject.SysMsg(sObserverMode, c_Green, t_Hint)
          else
            PlayObject.SysMsg(g_sReleaseObserverMode, c_Green, t_Hint);
        end;
    end;
  end
  else
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEMODE);
  end;

end;

procedure TNormNpc.ActionOfChangePerMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nPermission: Integer;
begin
  nPermission := Str_ToInt(QuestActionInfo.sParam1, -1);
  if nPermission in [0..10] then
    PlayObject.m_btPermission := nPermission
  else
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEPERMISSION);
    Exit;
  end;
  if g_Config.boShowScriptActionMsg then
    PlayObject.SysMsg(Format(g_sChangePermissionMsg, [PlayObject.m_btPermission]), c_Green, t_Hint);
end;

procedure TNormNpc.ActionOfOpenStorageView(PlayObject: TPlayObject; QuestActioninfo: pTQuestActionInfo);
begin
  PlayObject.SendMsg(Self, RM_OPENSTORAGEVIEW, 0, Integer(Self), 0, 0, '');
end;

procedure TNormNpc.ActionOfWebBrowser(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sWebSite: string;
resourcestring
  sHttp = 'http://';
begin
  sWebSite := QuestActionInfo.sParam1;
  if Pos(sHttp, sWebSite) > 0 then
    sWebSite := StringReplace(sWebSite, sHttp, '', [rfReplaceAll]);
  PlayObject.m_DefMsg := MakeDefaultMsg(SM_SHELLEXECUTE, QuestActionInfo.nParam2, 0, 0, 0);
  PlayObject.SendSocket(@PlayObject.m_DefMsg, sWebSite);
end;

procedure TNormNpc.ActionOfReadIniText(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  MyIniFile: TIniFile;
  varType: Integer;
  sValue: String;
  nValue: Integer;
  sFileName: String;
begin
  if (QuestActionInfo.sParam1 = '') or (QuestActionInfo.sParam2 = '') or (QuestActionInfo.sParam3 = '') or (QuestActionInfo.sParam4 = '')then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, 'ReadIniText');
    exit;
  end;

  try
    sFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
    MyIniFile := TIniFile.Create(sFileName);
    sValue := MyIniFile.ReadString(QuestActionInfo.sParam2,QuestActionInfo.sParam3,'');
  finally
    MyIniFile.Free;
  end;


  varType := GetValNameNo(QuestActionInfo.sParam4);
  nValue := Str_ToInt(sValue, 0);
  if varType >= 0 then
  begin
    case varType of
      0..9: PlayObject.m_nVal[varType] := nValue;
      100..199: g_Config.GlobalVal[varType - 100] := nValue;
      200..299: PlayObject.m_DyVal[varType - 200] := nValue;
      300..399: PlayObject.m_nMval[varType - 300] := nValue;
      400..499: g_Config.GlobaDyMval[varType - 400] := nValue;
      500..599: g_Config.GlobaDyTval[varType - 500] := sValue;
      600..699: PlayObject.m_nSval[varType - 600] := sValue;
      700..799: g_Config.HGlobalVal[varType - 700] := nValue;
    else
      ScriptActionError(PlayObject, '', QuestActionInfo, 'ReadIniText');
    end;
  end
  else
    ScriptActionError(PlayObject, '', QuestActionInfo, 'ReadIniText');

end;

procedure TNormNpc.ActionOfWriteIniText(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  MyIniFile: TIniFile;
  sFileName: String;
begin
  try
    if (QuestActionInfo.sParam1 = '') or (QuestActionInfo.sParam2 = '') or (QuestActionInfo.sParam3 = '') then
    begin
      ScriptActionError(PlayObject, '', QuestActionInfo, 'WriteIniText');
      exit;
    end;
    sFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
    MyIniFile := TIniFile.Create(sFileName);
    MyIniFile.WriteString(QuestActionInfo.sParam2,QuestActionInfo.sParam3,QuestActionInfo.sParam4);
  finally
    MyIniFile.Free;
  end;
end;


function GetItemWhere(pStdItem: pTStdItem): Integer;
begin
  Result := -1;
  if pStdItem = nil then
    Exit;
  case pStdItem.StdMode of
    10, 11:
      begin
        Result := U_DRESS;
      end;
    12, 13:
      begin
        Result := U_FASHION;
      end;
    5, 6:
      begin
        Result := U_WEAPON;
      end;
    30:
      begin
        Result := U_RIGHTHAND;
      end;
    19, 20, 21:
      begin
        Result := U_NECKLACE;
      end;
    15:
      begin
        Result := U_HELMET;
      end;
    17:
      begin
        Result := U_DRUM;
      end;
    18:
      begin
        Result := U_HORSE;
      end;
    24, 26:
      begin
        Result := U_ARMRINGL;
      end;
    22, 23:
      begin
        Result := U_RINGL;
      end;
    25:
      begin
        Result := U_BUJUK;
      end;
    27:
      begin
        Result := U_BELT;
      end;
    28:
      begin
        Result := U_BOOTS;
      end;
    7, 29:
      begin
        Result := U_CHARM;
      end;
  end;
end;

procedure TNormNpc.ActionOfTakeOn(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nWhere: Integer;
  sItemName: string;
  pStdItem: pTStdItem;
begin
  sItemName := QuestActionInfo.sParam1;
  nWhere := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (sItemName = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_TAKEON);
    Exit;
  end;

  if nWhere = -1 then
  begin
    pStdItem := UserEngine.GetStdItem(sItemName);
    if pStdItem <> nil then
      nWhere := GetItemWhere(pStdItem);
  end;
  if nWhere in [Low(THumanUseItems)..High(THumanUseItems)] then
  begin
    if PlayObject.AutoTakeOnItem(nWhere, sItemName) then
    begin
      PlayObject.SendMsg(PlayObject, RM_SENDUSEITEMS, 0, 0, 0, 0, '');
      PlayObject.FeatureChanged();
    end;
  end
end;

procedure TNormNpc.ActionOfSetScriptTimer(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nTimerID, nTnterval: Integer;
begin
  nTimerID := Str_ToInt(QuestActionInfo.sParam1, -1);
  nTnterval := Str_ToInt(QuestActionInfo.sParam2, 1);
  if not (nTimerID in [0..9]) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETSCTIMER);
    Exit;
  end;
  PlayObject.m_aScriptTimers[nTimerID].bActive := True;
  PlayObject.m_aScriptTimers[nTimerID].dwExecTick := GetTickCount;
  PlayObject.m_aScriptTimers[nTimerID].dwTnterval := _MAX(1000, nTnterval * 1000);
end;

procedure TNormNpc.ActionOfKillScriptTimer(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nTimerID: Integer;
begin
  nTimerID := Str_ToInt(QuestActionInfo.sParam1, -1);
  if not (nTimerID in [0..9]) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_KILLSCTIMER);
    Exit;
  end;
  PlayObject.m_aScriptTimers[nTimerID].bActive := False;
end;

procedure TNormNpc.ActionOfGiveItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, n: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  StdItemIndex: Integer;
  sItemName, sItemCount: string;
  nItemCount: Integer;

  nValueType, nValue: Integer;

  Eva: TEvaluation;
  szTIInfo: string;
  szBaseAbil: string;
  szMystAbil: string;
  szAdvAbil: string;
  szSpSkill: string;
  szEvaTimes: string;
  szAbil, szType, szValue: string;
  btType, btValue: Integer;
  nAdvAbil: Integer;
  nSpSkill: Integer;
  nEvaTimes: Integer;
  nQuality: Integer;
  AbilArr: array[0..3] of TEvaAbil;

  procedure TreasureIdentifyItem();
  begin
    if StdItem.Eva.EvaTimesMax > 0 then
    begin
      szTIInfo := QuestActionInfo.sParam5;
      szTIInfo := GetValidStr3(szTIInfo, szBaseAbil, ['|']);
      szTIInfo := GetValidStr3(szTIInfo, szMystAbil, ['|']);
      szTIInfo := GetValidStr3(szTIInfo, szAdvAbil, ['|']);
      szTIInfo := GetValidStr3(szTIInfo, szSpSkill, ['|']);
      szTIInfo := GetValidStr3(szTIInfo, szEvaTimes, ['|']);

      //szBaseAbil := QuestActionInfo.sParam5;
      n := 0;
      FillChar(AbilArr, SizeOf(AbilArr), #0);
      while szBaseAbil <> '' do
      begin
        szBaseAbil := GetValidStr3(szBaseAbil, szAbil, [',']);
        if szAbil <> '' then
        begin
          szAbil := GetValidStr3(szAbil, szType, ['=']);
          szAbil := GetValidStr3(szAbil, szValue, ['=']);
          btType := Str_ToInt(szType, -1);
          btValue := Str_ToInt(szValue, -1);
          if (btType in [1..30]) and (btValue in [1..15]) and CheckTIType(btType, StdItem.StdMode) then
          begin
            AbilArr[n].btType := btType;
            AbilArr[n].btValue := btValue;
            Inc(n);
            if n > High(AbilArr) then
              Break;
          end;
        end;
      end;
      if n > 0 then
      begin
        SetItemEvaInfo(UserItem, t_BaseAbil, 0, AbilArr);
      end;

      //szMystAbil := QuestActionInfo.sParam6;
      n := 0;
      FillChar(AbilArr, SizeOf(AbilArr), #0);
      while szMystAbil <> '' do
      begin
        szMystAbil := GetValidStr3(szMystAbil, szAbil, [',']);
        if szAbil <> '' then
        begin
          szAbil := GetValidStr3(szAbil, szType, ['=']);
          szAbil := GetValidStr3(szAbil, szValue, ['=']);
          btType := Str_ToInt(szType, -1);
          btValue := Str_ToInt(szValue, -1);
          if (btType in [1..30]) and (btValue in [1..15]) and CheckTIType(btType, StdItem.StdMode) then
          begin
            AbilArr[n].btType := btType;
            AbilArr[n].btValue := btValue;
            Inc(n);
            if n > High(AbilArr) then
              Break;
          end;
        end;
      end;
      if n > 0 then
      begin
        SetItemEvaInfo(UserItem, t_AdvAbilMax, n, AbilArr);
        SetItemEvaInfo(UserItem, t_MystAbil, 0, AbilArr);
      end;

      nAdvAbil := Str_ToInt(szAdvAbil, -1);
      if nAdvAbil in [1..127] then
      begin
        UserItem.btValueEx[1] := nAdvAbil;
        if n = 0 then
          SetItemEvaInfo(UserItem, t_AdvAbilMax, 1, AbilArr);
      end;

      nSpSkill := Str_ToInt(szSpSkill, -1);
      if nSpSkill in [1..127] then
      begin
        UserItem.btValueEx[18] := nSpSkill;
        if n = 0 then
          SetItemEvaInfo(UserItem, t_AdvAbilMax, 1, AbilArr);
      end;

      nEvaTimes := Str_ToInt(szEvaTimes, -1);
      if nEvaTimes in [1..StdItem.Eva.EvaTimesMax] then
      begin
        SetItemEvaInfo(UserItem, t_EvaTimes, nEvaTimes, AbilArr);
      end;

      GetItemEvaInfo(UserItem, Eva);
      nQuality := _MIN(255, Eva.Quality + 68 + Random(89));
      SetItemEvaInfo(UserItem, t_Quality, nQuality, AbilArr);
    end;
  end;
begin
  sItemName := QuestActionInfo.sParam1;
  sItemCount := QuestActionInfo.sParam2;
  nItemCount := Str_ToInt(sItemCount, 1);

  nValueType := Str_ToInt(QuestActionInfo.sParam3, -1);
  nValue := Str_ToInt(QuestActionInfo.sParam4, -1);

  if (sItemName = '') or (nItemCount <= 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GIVE);
    Exit;
  end;

  if CompareText(sItemName, sSTRING_GOLDNAME) = 0 then
  begin
    PlayObject.IncGold(nItemCount);
    PlayObject.GoldChanged();
    if g_boGameLogGold then
      AddGameDataLogAPI('9' + #9 +
        PlayObject.m_sMapName + #9 +
        IntToStr(PlayObject.m_nCurrX) + #9 +
        IntToStr(PlayObject.m_nCurrY) + #9 +
        PlayObject.m_sCharName + #9 +
        sSTRING_GOLDNAME + #9 +
        IntToStr(nItemCount) + #9 +
        '1' + #9 +
        m_sCharName);
    Exit;
  end;

  StdItemIndex := UserEngine.GetStdItemIdx(sItemName);
  StdItem := UserEngine.GetStdItem(StdItemIndex);

  if StdItem = nil then Exit;


    while nItemCount>0 do
    begin

      UserItem := GetOverlapItemFromBag(PlayObject.m_ItemList, StdItem, StdItemIndex);
      if UserItem <> nil then
      begin
        if UserItem.DuraMax - UserItem.Dura > nItemCount then
        begin
          UserItem.Dura := UserItem.Dura + nItemCount;
          nItemCount := 0;
        end
        else
        begin
          nItemCount := nItemCount - (UserItem.DuraMax - UserItem.Dura);
          UserItem.Dura := UserItem.DuraMax;
        end;
        PlayObject.SendChangeBagItemDura(UserItem.MakeIndex, UserItem.Dura, False);
        Continue;
      end;
      

      if PlayObject.IsEnoughBag then
      begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
        begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem.StdMode in [5, 6, 1..13, 15..24, 26..30, 51..54, 62..64] then
          begin
            if (nValueType in [0..(27 + 3)]) and (nValue in [0..255]) then
            begin
              if nValueType > 13 then
              begin
                if nValueType = 14 then
                begin
                  nValue := _MIN(65, nValue);
                  UserItem.Dura := nValue * 1000;
                end
                else if nValueType = 15 then
                begin
                  nValue := _MIN(65, nValue);
                  UserItem.DuraMax := nValue * 1000;
                end
                else if nValueType = 16 then
                begin
                  UserItem.btValue[14] := nValue;
                end
                else if nValueType = 17 then
                begin
                  UserItem.btValue[15] := _MIN(15, nValue) * 16 + UserItem.btValue[15] mod 16;
                end
                else if nValueType = 18 then
                begin
                  UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nValue);
                end
                else if nValueType = 19 then
                begin
                  UserItem.btValue[16] := _MIN(15, nValue) * 16 + UserItem.btValue[16] mod 16;
                end
                else if nValueType = 20 then
                begin
                  UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nValue);
                end
                else if nValueType = 21 then
                begin
                  UserItem.btValue[17] := _MIN(15, nValue) * 16 + UserItem.btValue[17] mod 16;
                end
                else if nValueType = 22 then
                begin
                  UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nValue);
                end
                else
                  UserItem.btValue[nValueType - (2 + 3)] := nValue;
              end
              else
                UserItem.btValue[nValueType] := nValue;
            end;
            TreasureIdentifyItem();
          end;

          if CheckIsOverlapItem(StdItem) then
          begin
            if UserItem.DuraMax <= nItemCount then
            begin
              UserItem.Dura := UserItem.DuraMax;
              Dec(nItemCount, UserItem.Dura);
            end
            else
            begin
              UserItem.Dura := nItemCount;
              nItemCount := 0;
            end;
          end
          else
          begin
            Dec(nItemCount, 1);
          end;

          PlayObject.m_ItemList.Add(UserItem);
          PlayObject.SendAddItem(UserItem);
          if StdItem.NeedIdentify = 1 then
            AddGameDataLogAPI('9' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              sItemName + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
        end
        else
        begin
          Dispose(UserItem);
          break;
        end;
      end
      else
      begin

        New(UserItem);
        if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
        begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem.NeedIdentify = 1 then
            AddGameDataLogAPI('9' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              sItemName + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
          if StdItem.StdMode in [5, 6, 10..13, 15..24, 26..30, 51..54, 62..64] then
          begin
            if (nValueType in [0..(27 + 3)]) and (nValue in [0..255]) then
            begin
              if nValueType > 13 then
              begin
                if nValueType = 14 then
                begin
                  nValue := _MIN(65, nValue);
                  UserItem.Dura := nValue * 1000;
                end
                else if nValueType = 15 then
                begin
                  nValue := _MIN(65, nValue);
                  UserItem.DuraMax := nValue * 1000;
                end
                else if nValueType = 16 then
                begin
                  UserItem.btValue[14] := nValue;
                end
                else if nValueType = 17 then
                begin
                  UserItem.btValue[15] := _MIN(15, nValue) * 16 + UserItem.btValue[15] mod 16;
                end
                else if nValueType = 18 then
                begin
                  UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nValue);
                end
                else if nValueType = 19 then
                begin
                  UserItem.btValue[16] := _MIN(15, nValue) * 16 + UserItem.btValue[16] mod 16;
                end
                else if nValueType = 20 then
                begin
                  UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nValue);
                end
                else if nValueType = 21 then
                begin
                  UserItem.btValue[17] := _MIN(15, nValue) * 16 + UserItem.btValue[17] mod 16;
                end
                else if nValueType = 22 then
                begin
                  UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nValue);
                end
                else
                  UserItem.btValue[nValueType - (2 + 3)] := nValue;
              end
              else
                UserItem.btValue[nValueType] := nValue;
            end;
            TreasureIdentifyItem();
          end;


          if CheckIsOverlapItem(StdItem) then
          begin
            if UserItem.DuraMax <= nItemCount then
            begin
              UserItem.Dura := UserItem.DuraMax;
              Dec(nItemCount, UserItem.Dura);
            end
            else
            begin
              UserItem.Dura := nItemCount;
              nItemCount := 0;
            end;
          end
          else
          begin
            Dec(nItemCount, 1);
          end;

          PlayObject.DropItemDown(UserItem, 3, False, PlayObject, nil);
        end
        else
        begin
          nItemCount := 0;
        end;
        Dispose(UserItem);
      end;
    end;
end;

procedure TNormNpc.ActionOfCONFERTITLE(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, nPoint: Integer;
  IsSetActive: Boolean;
begin
  if (QuestActionInfo.sParam1 = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CONFERTITLE);
    Exit;
  end;

  nPoint := UserEngine.GetTitleIdx(QuestActionInfo.sParam1);
  if nPoint <= 0 then Exit;

  IsSetActive := QuestActionInfo.nParam2 = 1;

  for i := Low(THumTitles) to High(THumTitles) do
  begin
    if PlayObject.m_Titles[i].Index = nPoint then
    begin
      if IsSetActive then                      
        PlayObject.ClientChangeTitle(0, nPoint);
      Exit;
    end;
  end;

  for i := Low(THumTitles) to High(THumTitles) do
  begin
    if PlayObject.m_Titles[i].Index = 0 then
    begin
      PlayObject.m_Titles[i].Index := nPoint;
      //PlayObject.m_Titles[i].Time := GetItemFormatDate();
      PlayObject.m_Titles[i].Time := 0;
      PlayObject.SendMyTitles(True);
      if IsSetActive then                      
        PlayObject.ClientChangeTitle(0, nPoint);
      Break;
    end;
  end;
end;

//PlaySound FileName Loop Map

procedure TNormNpc.ActionOfPlaySound(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, nLoop: Integer;
  szFileName, szMapName: string;
  Envir: TEnvirnoment;
  Player: TPlayObject;
begin
  szFileName := QuestActionInfo.sParam1;
  nLoop := Str_ToInt(QuestActionInfo.sParam2, 0);
  if nLoop > 1 then
    nLoop := 1;
  if nLoop < 0 then
    nLoop := 0;
  szMapName := QuestActionInfo.sParam3;
  if szFileName = '' then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_PLAYSOUND);
    Exit;
  end;

  if CompareText(szMapName, 'stop') = 0 then
  begin
    for i := 0 to UserEngine.m_PlayObjectList.Count - 1 do
    begin
      Player := TPlayObject(UserEngine.m_PlayObjectList.Objects[i]);
      if not Player.m_boGhost and not Player.m_boOffLineFlag then
      begin
        Player.SendMsg(Player, RM_PLAYSOUND, 0, 0, 0, 0, '');
      end;
    end;
    Exit;
  end;

  if CompareText(szMapName, 'all') = 0 then
  begin
    for i := 0 to UserEngine.m_PlayObjectList.Count - 1 do
    begin
      Player := TPlayObject(UserEngine.m_PlayObjectList.Objects[i]);
      if not Player.m_boGhost and not Player.m_boOffLineFlag then
      begin
        Player.SendMsg(Player, RM_PLAYSOUND, nLoop, 0, 0, 0, szFileName);
      end;
    end;
  end
  else if (CompareText(szMapName, 'guild') = 0) and (PlayObject.m_MyGuild <> nil) then
  begin
    for i := 0 to UserEngine.m_PlayObjectList.Count - 1 do
    begin
      Player := TPlayObject(UserEngine.m_PlayObjectList.Objects[i]);
      if not Player.m_boGhost and not Player.m_boOffLineFlag and (Player.m_MyGuild <> nil) then
      begin
        if Player.m_MyGuild = PlayObject.m_MyGuild then
          Player.SendMsg(Player, RM_PLAYSOUND, nLoop, 0, 0, 0, szFileName);
      end;
    end;
  end
  else
  begin
    Envir := g_MapManager.FindMap(szMapName);
    if Envir <> nil then
    begin
      for i := 0 to UserEngine.m_PlayObjectList.Count - 1 do
      begin
        Player := TPlayObject(UserEngine.m_PlayObjectList.Objects[i]);
        if not Player.m_boGhost and not Player.m_boOffLineFlag and (Player.m_PEnvir = Envir) then
        begin
          Player.SendMsg(Player, RM_PLAYSOUND, nLoop, 0, 0, 0, szFileName);
        end;
      end;
    end
    else
    begin
      PlayObject.SendMsg(PlayObject, RM_PLAYSOUND, nLoop, 0, 0, 0, szFileName);
    end;
  end;
end;

procedure TNormNpc.ActionOfDEPRIVETITLE(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, nStep, nPoint: Integer;
begin
  if (QuestActionInfo.sParam1 = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_DEPRIVETITLE);
    Exit;
  end;

  if CompareText(QuestActionInfo.sParam1, 'all') = 0 then
  begin
    nStep := 0;
    for i := Low(THumTitles) to High(THumTitles) do
    begin
      if PlayObject.m_Titles[i].Index > 0 then
      begin
        if (PlayObject.m_btActiveTitle in [1..6]) and (PlayObject.m_btActiveTitle - 1 = i) then
        begin
          PlayObject.ClientChangeTitle(0, 0);
        end;
        PlayObject.m_Titles[i].Index := 0;
        Inc(nStep);
      end;
    end;
    if nStep > 0 then
    begin
      PlayObject.SendMyTitles(True);
      if PlayObject.m_btActiveTitle > 0 then
      begin

        PlayObject.m_btActiveTitle := 0;
        PlayObject.RecalcAbilitys();
        PlayObject.FeatureChanged();
        PlayObject.SendDefMessage(SM_CHANGETITLE, 0, 0, 0, byte(PlayObject.IsHero), '');
      end;
    end;
    Exit;
  end;

  nPoint := UserEngine.GetTitleIdx(QuestActionInfo.sParam1);
  if nPoint <= 0 then Exit;

  for i := Low(THumTitles) to High(THumTitles) do
  begin
    if PlayObject.m_Titles[i].Index = nPoint then
    begin
      if (PlayObject.m_btActiveTitle in [1..6]) and (PlayObject.m_btActiveTitle - 1 = i) then
      begin
        PlayObject.ClientChangeTitle(0, 0);
      end;
      {if PlayObject.m_btActiveTitle = i + 1 then begin
        PlayObject.m_btActiveTitle := 0;
        PlayObject.RecalcAbilitys();
        PlayObject.FeatureChanged();
        PlayObject.SendDefMessage(SM_CHANGETITLE, 0, 0, 0, Byte(PlayObject.IsHero), '');
      end;}
      PlayObject.m_Titles[i].Index := 0;
      PlayObject.SendMyTitles(True);
      Break;
    end;
  end;
end;

procedure TNormNpc.ActionOfGiveItemEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, n: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  StdItemIndex: Integer;
  sItemName, sItemCount: string;
  nItemCount: Integer;

  nValueType, nValue: Integer;

  Eva: TEvaluation;
  szTIInfo: string;
  szBaseAbil: string;
  szMystAbil: string;
  szAdvAbil: string;
  szSpSkill: string;
  szEvaTimes: string;
  szAbil, szType, szValue: string;
  btType, btValue: Integer;
  nAdvAbil: Integer;
  nSpSkill: Integer;
  nEvaTimes: Integer;
  nQuality: Integer;
  AbilArr: array[0..3] of TEvaAbil;

  procedure PutAddValueItem();
  var
    sAddValue: string;
  begin
    sAddValue := QuestActionInfo.sParam3;
    while sAddValue <> '' do
    begin
      sAddValue := GetValidStr3(sAddValue, szAbil, [',']);
      if szAbil <> '' then
      begin
        szAbil := GetValidStr3(szAbil, szType, ['=']);
        szAbil := GetValidStr3(szAbil, szValue, ['=']);

        nValueType := Str_ToInt(szType, -1);
        nValue := Str_ToInt(szValue, -1);

        if (nValueType in [0..(27 + 3)]) and (nValue in [0..255]) then
        begin
          if nValueType > 13 then
          begin
            if nValueType = 14 then
            begin
              nValue := _MIN(65, nValue);
              UserItem.Dura := nValue * 1000;
            end
            else if nValueType = 15 then
            begin
              nValue := _MIN(65, nValue);
              UserItem.DuraMax := nValue * 1000;
            end
            else if nValueType = 16 then
            begin
              UserItem.btValue[14] := nValue;
            end
            else if nValueType = 17 then
            begin
              UserItem.btValue[15] := _MIN(15, nValue) * 16 + UserItem.btValue[15] mod 16;
            end
            else if nValueType = 18 then
            begin
              UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nValue);
            end
            else if nValueType = 19 then
            begin
              UserItem.btValue[16] := _MIN(15, nValue) * 16 + UserItem.btValue[16] mod 16;
            end
            else if nValueType = 20 then
            begin
              UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nValue);
            end
            else if nValueType = 21 then
            begin
              UserItem.btValue[17] := _MIN(15, nValue) * 16 + UserItem.btValue[17] mod 16;
            end
            else if nValueType = 22 then
            begin
              UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nValue);
            end
            else
              UserItem.btValue[nValueType - (2 + 3)] := nValue;
          end
          else
            UserItem.btValue[nValueType] := nValue;
        end;
      end;
    end;
  end;

  procedure TreasureIdentifyItem();
  begin
    if StdItem.Eva.EvaTimesMax > 0 then
    begin
      szTIInfo := QuestActionInfo.sParam4;
      szTIInfo := GetValidStr3(szTIInfo, szBaseAbil, ['|']);
      szTIInfo := GetValidStr3(szTIInfo, szMystAbil, ['|']);
      szTIInfo := GetValidStr3(szTIInfo, szAdvAbil, ['|']);
      szTIInfo := GetValidStr3(szTIInfo, szSpSkill, ['|']);
      szTIInfo := GetValidStr3(szTIInfo, szEvaTimes, ['|']);

      n := 0;
      FillChar(AbilArr, SizeOf(AbilArr), #0);
      while szBaseAbil <> '' do
      begin
        szBaseAbil := GetValidStr3(szBaseAbil, szAbil, [',']);
        if szAbil <> '' then
        begin
          szAbil := GetValidStr3(szAbil, szType, ['=']);
          szAbil := GetValidStr3(szAbil, szValue, ['=']);
          btType := Str_ToInt(szType, -1);
          btValue := Str_ToInt(szValue, -1);
          if (btType in [1..30]) and (btValue in [1..15]) and CheckTIType(btType, StdItem.StdMode) then
          begin
            AbilArr[n].btType := btType;
            AbilArr[n].btValue := btValue;
            Inc(n);
            if n > High(AbilArr) then
              Break;
          end;
        end;
      end;
      if n > 0 then
      begin
        SetItemEvaInfo(UserItem, t_BaseAbil, 0, AbilArr);
      end;

      n := 0;
      FillChar(AbilArr, SizeOf(AbilArr), #0);
      while szMystAbil <> '' do
      begin
        szMystAbil := GetValidStr3(szMystAbil, szAbil, [',']);
        if szAbil <> '' then
        begin
          szAbil := GetValidStr3(szAbil, szType, ['=']);
          szAbil := GetValidStr3(szAbil, szValue, ['=']);
          btType := Str_ToInt(szType, -1);
          btValue := Str_ToInt(szValue, -1);
          if (btType in [1..30]) and (btValue in [1..15]) and CheckTIType(btType, StdItem.StdMode) then
          begin
            AbilArr[n].btType := btType;
            AbilArr[n].btValue := btValue;
            Inc(n);
            if n > High(AbilArr) then
              Break;
          end;
        end;
      end;
      if n > 0 then
      begin
        SetItemEvaInfo(UserItem, t_AdvAbilMax, n, AbilArr);
        SetItemEvaInfo(UserItem, t_MystAbil, 0, AbilArr);
      end;

      nAdvAbil := Str_ToInt(szAdvAbil, -1);
      if nAdvAbil in [1..127] then
      begin
        UserItem.btValueEx[1] := nAdvAbil;
        if n = 0 then
          SetItemEvaInfo(UserItem, t_AdvAbilMax, 1, AbilArr);
      end;

      nSpSkill := Str_ToInt(szSpSkill, -1);
      if nSpSkill in [1..127] then
      begin
        UserItem.btValueEx[18] := nSpSkill;
        if n = 0 then
          SetItemEvaInfo(UserItem, t_AdvAbilMax, 1, AbilArr);
      end;

      nEvaTimes := Str_ToInt(szEvaTimes, -1);
      if nEvaTimes in [1..StdItem.Eva.EvaTimesMax] then
      begin
        SetItemEvaInfo(UserItem, t_EvaTimes, nEvaTimes, AbilArr);
      end;

      GetItemEvaInfo(UserItem, Eva);
      nQuality := _MIN(255, Eva.Quality + 68 + Random(89));
      SetItemEvaInfo(UserItem, t_Quality, nQuality, AbilArr);
    end;
  end;
begin
  sItemName := QuestActionInfo.sParam1;
  sItemCount := QuestActionInfo.sParam2;
  nItemCount := Str_ToInt(sItemCount, 1);

  if (sItemName = '') or (nItemCount <= 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GIVEEX);
    Exit;
  end;

  if CompareText(sItemName, sSTRING_GOLDNAME) = 0 then
  begin
    PlayObject.IncGold(nItemCount);
    PlayObject.GoldChanged();
    if g_boGameLogGold then
      AddGameDataLogAPI('9' + #9 +
        PlayObject.m_sMapName + #9 +
        IntToStr(PlayObject.m_nCurrX) + #9 +
        IntToStr(PlayObject.m_nCurrY) + #9 +
        PlayObject.m_sCharName + #9 +
        sSTRING_GOLDNAME + #9 +
        IntToStr(nItemCount) + #9 +
        '1' + #9 +
        m_sCharName);
    Exit;
  end;


  StdItemIndex := UserEngine.GetStdItemIdx(sItemName);
  StdItem := UserEngine.GetStdItem(StdItemIndex);

  if StdItem = nil then Exit;

    while nItemCount>0 do
    begin

      UserItem := GetOverlapItemFromBag(PlayObject.m_ItemList, StdItem, StdItemIndex);
      if UserItem <> nil then
      begin
        if UserItem.DuraMax - UserItem.Dura > nItemCount then
        begin
          UserItem.Dura := UserItem.Dura + nItemCount;
          nItemCount := 0;
        end
        else
        begin
          nItemCount := nItemCount - (UserItem.DuraMax - UserItem.Dura);
          UserItem.Dura := UserItem.DuraMax;
        end;
        PlayObject.SendChangeBagItemDura(UserItem.MakeIndex, UserItem.Dura, False);
        Continue;
      end;
          

      if PlayObject.IsEnoughBag then
      begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
        begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem.StdMode in [5, 6, 10..13, 15..24, 26..30, 51..54, 62..64] then
          begin
            PutAddValueItem();
            TreasureIdentifyItem();
          end;

          if CheckIsOverlapItem(StdItem) then
          begin
            if UserItem.DuraMax <= nItemCount then
            begin
              UserItem.Dura := UserItem.DuraMax;
              Dec(nItemCount, UserItem.Dura);
            end
            else
            begin
              UserItem.Dura := nItemCount;
              nItemCount := 0;
            end;
          end
          else
          begin
            Dec(nItemCount, 1);
          end;
          

          PlayObject.m_ItemList.Add(UserItem);
          PlayObject.SendAddItem(UserItem);
          if StdItem.NeedIdentify = 1 then
            AddGameDataLogAPI('9' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              sItemName + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
        end
        else
        begin
          Dispose(UserItem);
          break;
        end;
      end
      else
      begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
        begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem.NeedIdentify = 1 then
            AddGameDataLogAPI('9' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              sItemName + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
          if StdItem.StdMode in [5, 6, 10..13, 15..24, 26..30, 51..54, 62..64] then
          begin
            PutAddValueItem();
            TreasureIdentifyItem();
          end;

        if CheckIsOverlapItem(StdItem) then
        begin
          if UserItem.DuraMax <= nItemCount then
          begin
            UserItem.Dura := UserItem.DuraMax;
            Dec(nItemCount, UserItem.Dura);
          end
          else
          begin
            UserItem.Dura := nItemCount;
            nItemCount := 0;
          end;
        end
        else
        begin
          Dec(nItemCount, 1);
        end;
          PlayObject.DropItemDown(UserItem, 3, False, PlayObject, nil);
        end
        else
        begin
          nItemCount := 0;
        end;
        Dispose(UserItem);
      end;
    end;
end;

procedure TNormNpc.ActionOfGmExecute(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sData: string;
  btOldPermission: byte;
  sParam1, sParam2, sParam3, sParam4, sParam5, sParam6: string;
begin
  sParam1 := QuestActionInfo.sParam1;
  sParam2 := QuestActionInfo.sParam2;
  sParam3 := QuestActionInfo.sParam3;
  sParam4 := QuestActionInfo.sParam4;
  sParam5 := QuestActionInfo.sParam5;
  sParam6 := QuestActionInfo.sParam6;
  if CompareText(sParam2, 'Self') = 0 then
    sParam2 := PlayObject.m_sCharName;
  sData := Format('@%s %s %s %s %s %s', [sParam1, sParam2, sParam3, sParam4, sParam5, sParam6]);
  btOldPermission := PlayObject.m_btPermission;
  try
    PlayObject.m_btPermission := 10;
    PlayObject.ProcessUserLineMsg(sData);
  finally
    PlayObject.m_btPermission := btOldPermission;
  end;
end;

procedure TNormNpc.ActionOfGuildAuraePoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nAuraePoint: Integer;
  cMethod: Char;
  Guild: TGuild;
begin
  nAuraePoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nAuraePoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AURAEPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    PlayObject.SysMsg(g_sScriptGuildAuraePointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGuild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        Guild.nAurae := nAuraePoint;
      end;
    '-':
      begin
        if Guild.nAurae >= nAuraePoint then
          Guild.nAurae := Guild.nAurae - nAuraePoint
        else
          Guild.nAurae := 0;
      end;
    '+':
      begin
        if (High(Integer) - Guild.nAurae) >= nAuraePoint then
          Guild.nAurae := Guild.nAurae + nAuraePoint
        else
          Guild.nAurae := High(Integer);
      end;
  end;
  if g_Config.boShowScriptActionMsg then
    PlayObject.SysMsg(Format(g_sScriptGuildAuraePointMsg, [Guild.nAurae]), c_Green, t_Hint);
end;

procedure TNormNpc.ActionOfGuildBuildPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nBuildPoint: Integer;
  cMethod: Char;
  Guild: TGuild;
begin
  nBuildPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nBuildPoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_BUILDPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    PlayObject.SysMsg(g_sScriptGuildBuildPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGuild(PlayObject.m_MyGuild);
  {//$I License.inc}
   // if g_Config.nRegCheckCode <= 0 then Exit;
  {//$I License.inc}
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        Guild.nBuildPoint := nBuildPoint;
      end;
    '-':
      begin
        if Guild.nBuildPoint >= nBuildPoint then
        begin
          Guild.nBuildPoint := Guild.nBuildPoint - nBuildPoint;
        end
        else
        begin
          Guild.nBuildPoint := 0;
        end;
      end;
    '+':
      begin
        if (High(Integer) - Guild.nBuildPoint) >= nBuildPoint then
        begin
          Guild.nBuildPoint := Guild.nBuildPoint + nBuildPoint;
        end
        else
        begin
          Guild.nBuildPoint := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptGuildBuildPointMsg, [Guild.nBuildPoint]),
      c_Green, t_Hint);
  end;

end;

procedure TNormNpc.ActionOfGuildChiefItemCount(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nItemCount: Integer;
  cMethod: Char;
  Guild: TGuild;
begin
  nItemCount := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nItemCount < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GUILDCHIEFITEMCOUNT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    PlayObject.SysMsg(g_sScriptGuildFlourishPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGuild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        Guild.nChiefItemCount := nItemCount;
      end;
    '-':
      begin
        if Guild.nChiefItemCount >= nItemCount then
        begin
          Guild.nChiefItemCount := Guild.nChiefItemCount - nItemCount;
        end
        else
        begin
          Guild.nChiefItemCount := 0;
        end;
      end;
    '+':
      begin
        if (High(Integer) - Guild.nChiefItemCount) >= nItemCount then
        begin
          Guild.nChiefItemCount := Guild.nChiefItemCount + nItemCount;
        end
        else
        begin
          Guild.nChiefItemCount := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptChiefItemCountMsg, [Guild.nChiefItemCount]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGuildFlourishPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);

var
  nFlourishPoint: Integer;
  cMethod: Char;
  Guild: TGuild;
begin
  nFlourishPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nFlourishPoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_FLOURISHPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    PlayObject.SysMsg(g_sScriptGuildFlourishPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGuild(PlayObject.m_MyGuild);
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        Guild.nFlourishing := nFlourishPoint;
      end;
    '-':
      begin
        if Guild.nFlourishing >= nFlourishPoint then
        begin
          Guild.nFlourishing := Guild.nFlourishing - nFlourishPoint;
        end
        else
        begin
          Guild.nFlourishing := 0;
        end;
      end;
    '+':
      begin
        if (High(Integer) - Guild.nFlourishing) >= nFlourishPoint then
        begin
          Guild.nFlourishing := Guild.nFlourishing + nFlourishPoint;
        end
        else
        begin
          Guild.nFlourishing := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptGuildFlourishPointMsg, [Guild.nFlourishing]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGuildstabilityPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);

var
  nStabilityPoint: Integer;
  cMethod: Char;
  Guild: TGuild;
begin
  nStabilityPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nStabilityPoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_STABILITYPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    PlayObject.SysMsg(g_sScriptGuildStabilityPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGuild(PlayObject.m_MyGuild);
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        Guild.nStability := nStabilityPoint;
      end;
    '-':
      begin
        if Guild.nStability >= nStabilityPoint then
        begin
          Guild.nStability := Guild.nStability - nStabilityPoint;
        end
        else
        begin
          Guild.nStability := 0;
        end;
      end;
    '+':
      begin
        if (High(Integer) - Guild.nStability) >= nStabilityPoint then
        begin
          Guild.nStability := Guild.nStability + nStabilityPoint;
        end
        else
        begin
          Guild.nStability := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptGuildStabilityPointMsg, [Guild.nStability]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfHumanHP(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nHP: Integer;
  cMethod: Char;
begin
  nHP := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nHP < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HUMANHP);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        PlayObject.m_WAbil.HP := nHP;
      end;
    '-':
      begin
        if PlayObject.m_WAbil.HP >= nHP then
        begin
          Dec(PlayObject.m_WAbil.HP, nHP);
        end
        else
        begin
          PlayObject.m_WAbil.HP := 0;
        end;
      end;
    '+':
      begin
        Inc(PlayObject.m_WAbil.HP, nHP);
        if PlayObject.m_WAbil.HP > PlayObject.m_WAbil.MaxHP then
          PlayObject.m_WAbil.HP := PlayObject.m_WAbil.MaxHP;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    //PlayObject.SysMsg(Format(g_sScriptChangeHumanHPMsg, [PlayObject.m_WAbil.MaxHP]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfHumanMP(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nMP: Integer;
  cMethod: Char;
begin
  nMP := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nMP < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HUMANMP);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        PlayObject.m_WAbil.MP := nMP;
      end;
    '-':
      begin
        if PlayObject.m_WAbil.MP >= nMP then
        begin
          Dec(PlayObject.m_WAbil.MP, nMP);
        end
        else
        begin
          PlayObject.m_WAbil.MP := 0;
        end;
      end;
    '+':
      begin
        Inc(PlayObject.m_WAbil.MP, nMP);
        if PlayObject.m_WAbil.MP > PlayObject.m_WAbil.MaxMP then
          PlayObject.m_WAbil.MP := PlayObject.m_WAbil.MaxMP;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    //PlayObject.SysMsg(Format(g_sScriptChangeHumanMPMsg, [PlayObject.m_WAbil.MaxMP]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfKick(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  if PlayObject.IsHero then
  begin
    if not PlayObject.m_boHeroSaveRcd then
    begin
      PlayObject.m_boHeroSaveRcd := True;
      UserEngine.SaveHumanRcd(PlayObject);
    end;
    PlayObject.SendRefMsg(RM_HEROLOGOUT, 0, PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0, '');
    TPlayObject(PlayObject.m_Master).m_dwRecallHeroTick := 0;
    TPlayObject(PlayObject.m_Master).m_HeroObject := nil;
  end
  else
    PlayObject.m_boKickFlag := True;
end;

procedure TNormNpc.ActionOfKill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nMode: Integer;
begin
  nMode := Str_ToInt(QuestActionInfo.sParam1, -1);
  if nMode in [0..3] then
  begin
    case nMode of
      1:
        begin
          PlayObject.m_boNoItem := True;
          PlayObject.Die;
        end;
      2:
        begin
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
      3:
        begin
          PlayObject.m_boNoItem := True;
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
    else
      begin
        PlayObject.Die;
      end;
    end;
  end
  else
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_KILL);
end;

procedure TNormNpc.ActionOfBonusPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nBonusPoint: Integer;
  cMethod: Char;
begin
  nBonusPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nBonusPoint < 0) or (nBonusPoint > 10000) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_BONUSPOINT);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        FillChar(PlayObject.m_BonusAbil, SizeOf(TNakedAbility), #0);
        PlayObject.HasLevelUp();
        PlayObject.m_nBonusPoint := nBonusPoint;
        PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
      end;
    '-':
      begin
        if PlayObject.m_nBonusPoint > nBonusPoint then
        begin
          Dec(PlayObject.m_nBonusPoint, nBonusPoint);
          PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
        end
        else
          PlayObject.m_nBonusPoint := 0;
      end;
    '+':
      begin
        Inc(PlayObject.m_nBonusPoint, nBonusPoint);
        PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
      end;
  end;
end;

procedure TNormNpc.ActionOfDelMarry(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_sDearName := '';
  PlayObject.RefShowName;
end;

procedure TNormNpc.ActionOfDelMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_sMasterName := '';
  PlayObject.RefShowName;
end;

procedure TNormNpc.ActionOfRestBonusPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nTotleUsePoint: Integer;
begin
  nTotleUsePoint := PlayObject.m_BonusAbil.DC +
    PlayObject.m_BonusAbil.MC +
    PlayObject.m_BonusAbil.SC +
    PlayObject.m_BonusAbil.AC +
    PlayObject.m_BonusAbil.MAC +
    PlayObject.m_BonusAbil.HP +
    PlayObject.m_BonusAbil.MP +
    PlayObject.m_BonusAbil.HIT +
    PlayObject.m_BonusAbil.Speed +
    PlayObject.m_BonusAbil.X2;
  FillChar(PlayObject.m_BonusAbil, SizeOf(TNakedAbility), #0);

  Inc(PlayObject.m_nBonusPoint, nTotleUsePoint);
  PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
  PlayObject.HasLevelUp();
  PlayObject.SysMsg('分配点数已复位', c_Red, t_Hint);
end;

procedure TNormNpc.ActionOfRestReNewLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_btReLevel := 0;
  PlayObject.HasLevelUp();
end;

procedure TNormNpc.ActionOfSetMapMode(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  Envir: TEnvirnoment;
  sMapName: string;
  sMapMode, sParam1, sParam2 {,sParam3,sParam4}: string;
begin
  sMapName := QuestActionInfo.sParam1;
  sMapMode := QuestActionInfo.sParam2;
  sParam1 := QuestActionInfo.sParam3;
  sParam2 := QuestActionInfo.sParam4;
  //  sParam3:=QuestActionInfo.sParam5;
  //  sParam4:=QuestActionInfo.sParam6;

  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) or (sMapMode = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETMAPMODE);
    Exit;
  end;
  if CompareText(sMapMode, 'SAFE') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boSAFE := True;
    end
    else
    begin
      Envir.m_MapFlag.boSAFE := False;
    end;
  end
  else if CompareText(sMapMode, 'DARK') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boDARK := True;
    end
    else
    begin
      Envir.m_MapFlag.boDARK := False;
    end;
  end
  else if CompareText(sMapMode, 'DARK') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boDARK := True;
    end
    else
    begin
      Envir.m_MapFlag.boDARK := False;
    end;
  end
  else if CompareText(sMapMode, 'FIGHT') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boFIGHTZone := True;
    end
    else
    begin
      Envir.m_MapFlag.boFIGHTZone := False;
    end;
  end
  else if CompareText(sMapMode, 'FIGHT3') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boFIGHT3Zone := True;
    end
    else
    begin
      Envir.m_MapFlag.boFIGHT3Zone := False;
    end;
  end
  else if CompareText(sMapMode, 'DAY') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boDAY := True;
    end
    else
    begin
      Envir.m_MapFlag.boDAY := False;
    end;
  end
  else if CompareText(sMapMode, 'QUIZ') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boQUIZ := True;
    end
    else
    begin
      Envir.m_MapFlag.boQUIZ := False;
    end;
  end
  else if CompareText(sMapMode, 'NORECONNECT') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boNORECONNECT := True;
      Envir.m_MapFlag.sReConnectMap := sParam1;
    end
    else
    begin
      Envir.m_MapFlag.boNORECONNECT := False;
    end;
  end
  else if CompareText(sMapMode, 'MUSIC') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boMUSIC := True;
      Envir.m_MapFlag.nMUSICID := Str_ToInt(sParam1, -1);
    end
    else
    begin
      Envir.m_MapFlag.boMUSIC := False;
    end;
  end
  else if CompareText(sMapMode, 'EXPRATE') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boEXPRATE := True;
      Envir.m_MapFlag.nEXPRATE := Str_ToInt(sParam1, -1);
    end
    else
    begin
      Envir.m_MapFlag.boEXPRATE := False;
    end;
  end
  else if CompareText(sMapMode, 'PKWINLEVEL') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boPKWINLEVEL := True;
      Envir.m_MapFlag.nPKWINLEVEL := Str_ToInt(sParam1, -1);
    end
    else
    begin
      Envir.m_MapFlag.boPKWINLEVEL := False;
    end;
  end
  else if CompareText(sMapMode, 'PKWINEXP') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boPKWINEXP := True;
      Envir.m_MapFlag.nPKWINEXP := Str_ToInt(sParam1, -1);
    end
    else
    begin
      Envir.m_MapFlag.boPKWINEXP := False;
    end;
  end
  else if CompareText(sMapMode, 'PKLOSTLEVEL') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boPKLOSTLEVEL := True;
      Envir.m_MapFlag.nPKLOSTLEVEL := Str_ToInt(sParam1, -1);
    end
    else
    begin
      Envir.m_MapFlag.boPKLOSTLEVEL := False;
    end;
  end
  else if CompareText(sMapMode, 'PKLOSTEXP') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boPKLOSTEXP := True;
      Envir.m_MapFlag.nPKLOSTEXP := Str_ToInt(sParam1, -1);
    end
    else
    begin
      Envir.m_MapFlag.boPKLOSTEXP := False;
    end;
  end
  else if CompareText(sMapMode, 'DECHP') = 0 then
  begin
    if (sParam1 <> '') and (sParam2 <> '') then
    begin
      Envir.m_MapFlag.boDECHP := True;
      Envir.m_MapFlag.nDECHPTIME := Str_ToInt(sParam1, -1);
      Envir.m_MapFlag.nDECHPPOINT := Str_ToInt(sParam2, -1);
    end
    else
    begin
      Envir.m_MapFlag.boDECHP := False;
    end;
  end
  else if CompareText(sMapMode, 'DECGAMEGOLD') = 0 then
  begin
    if (sParam1 <> '') and (sParam2 <> '') then
    begin
      Envir.m_MapFlag.boDECGAMEGOLD := True;
      Envir.m_MapFlag.nDECGAMEGOLDTIME := Str_ToInt(sParam1, -1);
      Envir.m_MapFlag.nDECGAMEGOLD := Str_ToInt(sParam2, -1);
    end
    else
    begin
      Envir.m_MapFlag.boDECGAMEGOLD := False;
    end;
  end
  else if CompareText(sMapMode, 'RUNHUMAN') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boRUNHUMAN := True;
    end
    else
    begin
      Envir.m_MapFlag.boRUNHUMAN := False;
    end;
  end
  else if CompareText(sMapMode, 'RUNMON') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boRUNMON := True;
    end
    else
    begin
      Envir.m_MapFlag.boRUNMON := False;
    end;
  end
  else if CompareText(sMapMode, 'NEEDHOLE') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boNEEDHOLE := True;
    end
    else
    begin
      Envir.m_MapFlag.boNEEDHOLE := False;
    end;
  end
  else if CompareText(sMapMode, 'NORECALL') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boNORECALL := True;
    end
    else
    begin
      Envir.m_MapFlag.boNORECALL := False;
    end;
  end
  else if CompareText(sMapMode, 'NOGUILDRECALL') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boNOGUILDRECALL := True;
    end
    else
    begin
      Envir.m_MapFlag.boNOGUILDRECALL := False;
    end;
  end
  else if CompareText(sMapMode, 'NODEARRECALL') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boNODEARRECALL := True;
    end
    else
    begin
      Envir.m_MapFlag.boNODEARRECALL := False;
    end;
  end
  else if CompareText(sMapMode, 'NOMASTERRECALL') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boNOMASTERRECALL := True;
    end
    else
    begin
      Envir.m_MapFlag.boNOMASTERRECALL := False;
    end;
  end
  else if CompareText(sMapMode, 'NORANDOMMOVE') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boNORANDOMMOVE := True;
    end
    else
    begin
      Envir.m_MapFlag.boNORANDOMMOVE := False;
    end;
  end
  else if CompareText(sMapMode, 'NODRUG') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boNODRUG := True;
    end
    else
    begin
      Envir.m_MapFlag.boNODRUG := False;
    end;
  end
  else if CompareText(sMapMode, 'MINE') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boMINE := True;
    end
    else
    begin
      Envir.m_MapFlag.boMINE := False;
    end;
  end
  else if CompareText(sMapMode, 'NOPOSITIONMOVE') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.m_MapFlag.boNOPOSITIONMOVE := True;
    end
    else
    begin
      Envir.m_MapFlag.boNOPOSITIONMOVE := False;
    end;
  end;
end;

procedure TNormNpc.ActionOfSetMemberLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nLevel: Integer;
  cMethod: Char;
begin
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETMEMBERLEVEL);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        PlayObject.m_nMemberLevel := nLevel;
      end;
    '-':
      begin
        Dec(PlayObject.m_nMemberLevel, nLevel);
        if PlayObject.m_nMemberLevel < 0 then
          PlayObject.m_nMemberLevel := 0;
      end;
    '+':
      begin
        Inc(PlayObject.m_nMemberLevel, nLevel);
        if PlayObject.m_nMemberLevel > 65535 then
          PlayObject.m_nMemberLevel := 65535;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sChangeMemberLevelMsg,
      [PlayObject.m_nMemberLevel]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfSetMemberType(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nType: Integer;
  cMethod: Char;
begin
  nType := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nType < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETMEMBERTYPE);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        PlayObject.m_nMemberType := nType;
      end;
    '-':
      begin
        Dec(PlayObject.m_nMemberType, nType);
        if PlayObject.m_nMemberType < 0 then
          PlayObject.m_nMemberType := 0;
      end;
    '+':
      begin
        Inc(PlayObject.m_nMemberType, nType);
        if PlayObject.m_nMemberType > 65535 then
          PlayObject.m_nMemberType := 65535;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sChangeMemberTypeMsg,
      [PlayObject.m_nMemberType]), c_Green, t_Hint);
  end;
end;
{
function TNormNpc.ConditionOfCheckGuildList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
end;
}

function TNormNpc.ConditionOfCHECKRANGEMONCOUNT(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sMapName: string;
  nX, nY, nRange, nCount: Integer;
  cMethod: Char;
  nMapRangeCount: Integer;
  Envir: TEnvirnoment;
  MonList: TList;
  BaseObject: TBaseObject;
begin
  Result := False;
  sMapName := QuestConditionInfo.sParam1;
  if CompareText(sMapName, 'SELF') = 0 then
  begin
    if PlayObject.m_PEnvir <> nil then
    begin
      sMapName := PlayObject.m_PEnvir.m_sMapFileName;
      //if sMapName = '' then sMapName := PlayObject.m_PEnvir.m_sMapMapingName;
    end;
  end;
  nX := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nY := Str_ToInt(QuestConditionInfo.sParam3, -1);
  nRange := Str_ToInt(QuestConditionInfo.sParam4, -1);
  cMethod := QuestConditionInfo.sParam5[1];
  nCount := Str_ToInt(QuestConditionInfo.sParam6, -1);
  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) or (nX < 0) or (nY < 0) or (nRange < 0) or (nCount < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKRANGEMONCOUNT);
    Exit;
  end;

  MonList := TList.Create;
  Envir.GetRangeBaseObject(nX, nY, nRange, True, MonList);
  for i := MonList.Count - 1 downto 0 do
  begin
    BaseObject := TBaseObject(MonList.Items[i]);
    if (BaseObject.m_btRaceServer < RC_ANIMAL) or (BaseObject.m_btRaceServer = RC_ARCHERGUARD) or (BaseObject.m_Master <> nil) then
      MonList.Delete(i);
  end;
  nMapRangeCount := MonList.Count;
  case cMethod of
    '=': if nMapRangeCount = nCount then
        Result := True;
    '>': if nMapRangeCount > nCount then
        Result := True;
    '<': if nMapRangeCount < nCount then
        Result := True;
  else if nMapRangeCount >= nCount then
    Result := True;
  end;
  MonList.Free;
end;

function TNormNpc.ConditionOfCHECKRANGEMONCOUNTEX(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sMapName, sMonName: string;
  nX, nY, nCount: Integer;
  cMethod: Char;
  nMapRangeCount: Integer;
  Envir: TEnvirnoment;
  MonList: TList;
  BaseObject: TBaseObject;
begin
  Result := False;
  sMapName := QuestConditionInfo.sParam1;
  if CompareText(sMapName, 'SELF') = 0 then
  begin
    if PlayObject.m_PEnvir <> nil then
    begin
      sMapName := PlayObject.m_PEnvir.m_sMapFileName;
      //if sMapName = '' then sMapName := PlayObject.m_PEnvir.m_sMapMapingName;
    end;
  end;
  nX := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nY := Str_ToInt(QuestConditionInfo.sParam3, -1);
  sMonName := QuestConditionInfo.sParam4;
  cMethod := QuestConditionInfo.sParam5[1];
  nCount := Str_ToInt(QuestConditionInfo.sParam6, -1);
  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) or (nX < 0) or (nY < 0) or (sMonName = '') or (nCount < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKRANGEMONCOUNT);
    Exit;
  end;
  MonList := TList.Create;
  Envir.GetRangeBaseObject(nX, nY, 0, True, MonList);
  for i := MonList.Count - 1 downto 0 do
  begin
    BaseObject := TBaseObject(MonList.Items[i]);
    if CompareText(BaseObject.m_sCharName, sMonName) <> 0 then
      MonList.Delete(i);
  end;
  nMapRangeCount := MonList.Count;
  case cMethod of
    '=': if nMapRangeCount = nCount then
        Result := True;
    '>': if nMapRangeCount > nCount then
        Result := True;
    '<': if nMapRangeCount < nCount then
        Result := True;
  else if nMapRangeCount >= nCount then
    Result := True;
  end;
  MonList.Free;
end;

function TNormNpc.ConditionOfCheckOffLinePlayerCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_OFFLINEPLAYERCOUNT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if UserEngine.OfflinePlayCount = nCount then
        Result := True;
    '>': if UserEngine.OfflinePlayCount > nCount then
        Result := True;
    '<': if UserEngine.OfflinePlayCount < nCount then
        Result := True;
  else if UserEngine.OfflinePlayCount >= nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckHeroOnLine(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  obj: TBaseObject;
begin
  obj := PlayObject.GetHeroObjectA;
  Result := (obj <> nil) and not obj.m_boDeath;
end;

{function TNormNpc.ConditionOfCheckOffLinePlay(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := PlayObject.GetHeroObjectA <> nil;
end;}

function TNormNpc.ConditionOfCheckReNewLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKRENEWLEVEL);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btReLevel = nLevel then
        Result := True;
    '>': if PlayObject.m_btReLevel > nLevel then
        Result := True;
    '<': if PlayObject.m_btReLevel < nLevel then
        Result := True;
  else if PlayObject.m_btReLevel >= nLevel then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckSlaveLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  nLevel: Integer;
  cMethod: Char;
  BaseObject: TBaseObject;
  nSlaveLevel: Integer;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSLAVELEVEL);
    Exit;
  end;
  nSlaveLevel := -1;
  for i := 0 to PlayObject.m_SlaveList.Count - 1 do
  begin
    BaseObject := TBaseObject(PlayObject.m_SlaveList.Items[i]);
    if BaseObject.m_Abil.Level > nSlaveLevel then
      nSlaveLevel := BaseObject.m_Abil.Level;
  end;
  if nSlaveLevel < 0 then
    Exit;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nSlaveLevel = nLevel then
        Result := True;
    '>': if nSlaveLevel > nLevel then
        Result := True;
    '<': if nSlaveLevel < nLevel then
        Result := True;
  else if nSlaveLevel >= nLevel then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckUseItem(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nWhere: Integer;
  //  UserItem                  : pTUserItem;
  //  StdItem                   : pTStdItem;
begin
  Result := False;
  nWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  if (nWhere < 0) or (nWhere > High(THumanUseItems)) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKUSEITEM);
    Exit;
  end;
  if PlayObject.m_UseItems[nWhere].wIndex > 0 then
    Result := True;

end;

function TNormNpc.ConditionOfCheckVar(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sType: string;
  sVarName: string;
  sVarValue: string;
  nVarValue: Integer;
  sName: string;
  sMethod: string;
  cMethod: Char;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
resourcestring
  sVarFound = '变量%s已存在，变量类型:%s';
  sVarTypeError = '变量类型错误，错误类型:%s 当前支持类型(HUMAN、GUILD、GLOBAL)';
begin
  Result := False;
  sType := QuestConditionInfo.sParam1;
  sVarName := QuestConditionInfo.sParam2;
  sMethod := QuestConditionInfo.sParam3;
  sVarValue := QuestConditionInfo.sParam4;
  nVarValue := Str_ToInt(sVarValue, 0);

  if (sType = '') or (sVarName = '') or (sMethod = '') then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKVAR);
    Exit;
  end;
  cMethod := sMethod[1];
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then
  begin
    ScriptConditionError(PlayObject {,format(sVarTypeError,[sType])}, QuestConditionInfo, sSC_CHECKVAR);
    Exit;
  end;
  for i := 0 to DynamicVarList.Count - 1 do
  begin
    DynamicVar := DynamicVarList.Items[i];
    if CompareText(DynamicVar.sName, sVarName) = 0 then
    begin
      case DynamicVar.VarType of
        vInteger:
          begin
            case cMethod of
              '=': if DynamicVar.nInternet = nVarValue then
                  Result := True;
              '>': if DynamicVar.nInternet > nVarValue then
                  Result := True;
              '<': if DynamicVar.nInternet < nVarValue then
                  Result := True;
            else if DynamicVar.nInternet >= nVarValue then
              Result := True;
            end;
          end;
        vString:
          begin
            case cMethod of
              '=': if DynamicVar.sString = sVarValue then
                  Result := True;
            end;
          end;
      end;
      boFoundVar := True;
      Break;
    end;
  end;
  if not boFoundVar then
    ScriptConditionError(PlayObject, {format(sVarFound,[sVarName,sType]),} QuestConditionInfo, sSC_CHECKVAR);
end;

function TNormNpc.ConditionOfHaveMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if PlayObject.m_sMasterName <> '' then
    Result := True;
end;

function TNormNpc.ConditionOfPoseHaveMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    if (TPlayObject(PoseHuman).m_sMasterName <> '') then
      Result := True;
  end;
end;

procedure TNormNpc.ActionOfUnMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  //  LoadList                  : TStringList;
  //  sUnMarryFileName          : string;
  sMsg: string;
begin
  if PlayObject.m_sMasterName = '' then
  begin
    GotoLable(PlayObject, '@ExeMasterFail', False);
    Exit;
  end;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate);
  if PoseHuman = nil then
  begin
    GotoLable(PlayObject, '@UnMasterCheckDir', False);
  end;
  if PoseHuman <> nil then
  begin
    if QuestActionInfo.sParam1 = '' then
    begin
      if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then
      begin
        GotoLable(PlayObject, '@UnMasterTypeErr', False);
        Exit;
      end;
      if PoseHuman.GetPoseCreate = PlayObject then
      begin
        if (PlayObject.m_sMasterName = PoseHuman.m_sCharName) then
        begin
          if PlayObject.m_boMaster then
          begin
            GotoLable(PlayObject, '@UnIsMaster', False);
            Exit;
          end;
          if PlayObject.m_sMasterName <> PoseHuman.m_sCharName then
          begin
            GotoLable(PlayObject, '@UnMasterError', False);
            Exit;
          end;

          GotoLable(PlayObject, '@StartUnMaster', False);
          GotoLable(PoseHuman, '@WateUnMaster', False);
          Exit;
        end;
      end;
    end;
  end;
  if (CompareText(QuestActionInfo.sParam1, 'REQUESTUNMASTER' {sREQUESTUNMARRY})
    = 0) then
  begin
    if (QuestActionInfo.sParam2 = '') then
    begin
      if PoseHuman <> nil then
      begin
        PlayObject.m_boStartUnMaster := True;
        if PlayObject.m_boStartUnMaster and PoseHuman.m_boStartUnMaster then
        begin
          sMsg := AnsiReplaceText(g_sNPCSayUnMasterOKMsg, '%n', m_sCharName);
          sMsg := AnsiReplaceText(sMsg, '%s', PlayObject.m_sCharName);
          sMsg := AnsiReplaceText(sMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sMsg, t_Say);
          PlayObject.m_sMasterName := '';
          PoseHuman.m_sMasterName := '';
          PlayObject.m_boStartUnMaster := False;
          PoseHuman.m_boStartUnMaster := False;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
          GotoLable(PlayObject, '@UnMasterEnd', False);
          GotoLable(PoseHuman, '@UnMasterEnd', False);
        end
        else
        begin
          GotoLable(PlayObject, '@WateUnMaster', False);
          GotoLable(PoseHuman, '@RevUnMaster', False);
        end;
      end;
      Exit;
    end
    else
    begin
      //强行出师
      if (CompareText(QuestActionInfo.sParam2, 'FORCE') = 0) then
      begin
        sMsg := AnsiReplaceText(g_sNPCSayForceUnMasterMsg, '%n', m_sCharName);
        sMsg := AnsiReplaceText(sMsg, '%s', PlayObject.m_sCharName);
        sMsg := AnsiReplaceText(sMsg, '%d', PlayObject.m_sMasterName);
        UserEngine.SendBroadCastMsg(sMsg, t_Say);

        PoseHuman := UserEngine.GetPlayObject(PlayObject.m_sMasterName);
        if PoseHuman <> nil then
        begin
          PoseHuman.m_sMasterName := '';
          PoseHuman.RefShowName;
        end
        else
        begin
          g_UnForceMasterList.Lock;
          try
            g_UnForceMasterList.Add(PlayObject.m_sMasterName);
            SaveUnForceMasterList();
          finally
            g_UnForceMasterList.UnLock;
          end;
        end;
        PlayObject.m_sMasterName := '';
        GotoLable(PlayObject, '@UnMasterEnd', False);
        PlayObject.RefShowName;
      end;
      Exit;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckCastleGold(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGold: Integer;
begin
  Result := False;
  nGold := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if (nGold < 0) or (m_Castle = nil) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCASTLEGOLD);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if TUserCastle(m_Castle).m_nTotalGold = nGold then
        Result := True;
    '>': if TUserCastle(m_Castle).m_nTotalGold > nGold then
        Result := True;
    '<': if TUserCastle(m_Castle).m_nTotalGold < nGold then
        Result := True;
  else if TUserCastle(m_Castle).m_nTotalGold >= nGold then
    Result := True;
  end;
  {
  Result:=False;
  nGold:=Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nGold < 0 then begin
    ScriptConditionError(PlayObject,QuestConditionInfo,sSC_CHECKCASTLEGOLD);
    exit;
  end;
  cMethod:=QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if UserCastle.m_nTotalGold = nGold then Result:=True;
    '>': if UserCastle.m_nTotalGold > nGold then Result:=True;
    '<': if UserCastle.m_nTotalGold < nGold then Result:=True;
    else if UserCastle.m_nTotalGold >= nGold then Result:=True;
  end;
  }
end;

function TNormNpc.ConditionOfCheckContribution(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  {nContribution := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nContribution < 0 then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCONTRIBUTION);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_wContribution = nContribution then
        Result := True;
    '>': if PlayObject.m_wContribution > nContribution then
        Result := True;
    '<': if PlayObject.m_wContribution < nContribution then
        Result := True;
  else if PlayObject.m_wContribution >= nContribution then
    Result := True;
  end;}
end;

function TNormNpc.ConditionOfCheckCreditPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCreditPoint: Integer;
  cMethod: Char;
begin
  Result := False;
  nCreditPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCreditPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCREDITPOINT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btCreditPoint = nCreditPoint then
        Result := True;
    '>': if PlayObject.m_btCreditPoint > nCreditPoint then
        Result := True;
    '<': if PlayObject.m_btCreditPoint < nCreditPoint then
        Result := True;
  else if PlayObject.m_btCreditPoint >= nCreditPoint then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckHeroCreditPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCreditPoint: Integer;
  cMethod: Char;
  Hero: TBaseObject;
begin
  Result := False;
  Hero := PlayObject.GetHeroObjectA;
  if Hero = nil then
    Exit;
  nCreditPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCreditPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKHEROCREDITPOINT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Hero.m_btCreditPoint = nCreditPoint then
        Result := True;
    '>': if Hero.m_btCreditPoint > nCreditPoint then
        Result := True;
    '<': if Hero.m_btCreditPoint < nCreditPoint then
        Result := True;
  else if Hero.m_btCreditPoint >= nCreditPoint then
    Result := True;
  end;
end;

procedure TNormNpc.ActionOfClearNeedItems(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  nNeed: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  nNeed := Str_ToInt(QuestActionInfo.sParam1, -1);
  if (nNeed < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CLEARNEEDITEMS);
    Exit;
  end;
  for i := PlayObject.m_ItemList.Count - 1 downto 0 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and (StdItem.Need = nNeed) then
    begin
      PlayObject.SendDelItems(UserItem);
      if StdItem.NeedIdentify = 1 then
        AddGameDataLogAPI('10' + #9 +
          PlayObject.m_sMapName + #9 +
          IntToStr(PlayObject.m_nCurrX) + #9 +
          IntToStr(PlayObject.m_nCurrY) + #9 +
          PlayObject.m_sCharName + #9 +
          StdItem.Name + #9 +
          IntToStr(UserItem.MakeIndex) + #9 +
          '1' + #9 +
          m_sCharName);
      Dispose(UserItem);
      PlayObject.m_ItemList.Delete(i);
    end;
  end;
  for i := PlayObject.m_StorageItemList.Count - 1 downto 0 do
  begin
    UserItem := PlayObject.m_StorageItemList.Items[i];
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and (StdItem.Need = nNeed) then
    begin
      if StdItem.NeedIdentify = 1 then
        AddGameDataLogAPI('10' + #9 +
          PlayObject.m_sMapName + #9 +
          IntToStr(PlayObject.m_nCurrX) + #9 +
          IntToStr(PlayObject.m_nCurrY) + #9 +
          PlayObject.m_sCharName + #9 +
          StdItem.Name + #9 +
          IntToStr(UserItem.MakeIndex) + #9 +
          '1' + #9 +
          m_sCharName);
      Dispose(UserItem);
      PlayObject.m_StorageItemList.Delete(i);
      //PlayObject.m_dwSaveRcdTick := 0;  //0408_1
    end;
  end;
end;

procedure TNormNpc.ActionOfClearMakeItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  nMakeIndex: Integer;
  sItemName: string;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  boMatchName: Boolean;
begin
  sItemName := QuestActionInfo.sParam1;
  nMakeIndex := QuestActionInfo.nParam2;
  boMatchName := QuestActionInfo.sParam3 = '1';
  if (sItemName = '') or (nMakeIndex <= 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CLEARMAKEITEMS);
    Exit;
  end;
  for i := PlayObject.m_ItemList.Count - 1 downto 0 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem.MakeIndex <> nMakeIndex then
      Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if not boMatchName or ((StdItem <> nil) and (CompareText(StdItem.Name, sItemName) = 0)) then
    begin
      PlayObject.SendDelItems(UserItem);
      Dispose(UserItem);
      PlayObject.m_ItemList.Delete(i);
    end;
  end;
  for i := PlayObject.m_StorageItemList.Count - 1 downto 0 do
  begin
    UserItem := PlayObject.m_StorageItemList.Items[i];
    if UserItem.MakeIndex <> nMakeIndex then
      Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if not boMatchName or ((StdItem <> nil) and (CompareText(StdItem.Name, sItemName) = 0)) then
    begin
      Dispose(UserItem);
      PlayObject.m_StorageItemList.Delete(i);
    end;
  end;

  for i := Low(PlayObject.m_UseItems) to High(PlayObject.m_UseItems) do
  begin
    UserItem := @PlayObject.m_UseItems[i];
    if UserItem.MakeIndex <> nMakeIndex then
      Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if not boMatchName or ((StdItem <> nil) and (CompareText(StdItem.Name, sItemName) = 0)) then
    begin
      UserItem.wIndex := 0;
    end;
  end;
  //PlayObject.m_dwSaveRcdTick := 0;      //0408_1
end;

procedure TNormNpc.SendCustemMsg(PlayObject: TPlayObject; sMsg: string);
begin
  if not g_Config.boSendCustemMsg then
  begin
    PlayObject.SysMsg(g_sSendCustMsgCanNotUseNowMsg, c_Red, t_Hint);
    Exit;
  end;
  if PlayObject.m_boSendMsgFlag then
  begin
    PlayObject.m_boSendMsgFlag := False;
    UserEngine.SendBroadCastMsg(PlayObject.m_sCharName + ': ' + sMsg, t_Cust);
  end;
end;

function TNormNpc.ConditionOfCheckOfGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if QuestConditionInfo.sParam1 = '' then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKOFGUILD);
    Exit;
  end;
  if (PlayObject.m_MyGuild <> nil) then
  begin
    if CompareText(TGuild(PlayObject.m_MyGuild).sGuildName,
      QuestConditionInfo.sParam1) = 0 then
    begin
      Result := True;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckOnlineLongMin(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nOnlineMin: Integer;
  nOnlineTime: Integer;
begin
  Result := False;
  nOnlineMin := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nOnlineMin < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ONLINELONGMIN);
    Exit;
  end;
  nOnlineTime := (GetTickCount - PlayObject.m_dwLogonTick) div 60000;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nOnlineTime = nOnlineMin then
        Result := True;
    '>': if nOnlineTime > nOnlineMin then
        Result := True;
    '<': if nOnlineTime < nOnlineMin then
        Result := True;
  else if nOnlineTime >= nOnlineMin then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPasswordErrorCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nErrorCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nErrorCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nErrorCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo,
      sSC_PASSWORDERRORCOUNT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btPwdFailCount = nErrorCount then
        Result := True;
    '>': if PlayObject.m_btPwdFailCount > nErrorCount then
        Result := True;
    '<': if PlayObject.m_btPwdFailCount < nErrorCount then
        Result := True;
  else if PlayObject.m_btPwdFailCount >= nErrorCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfIsHigh(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
begin
  Result := False;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    'L': if g_HighLevelHuman = PlayObject then
        Result := True;
    'P': if g_HighPKPointHuman = PlayObject then
        Result := True;
    'D': if g_HighDCHuman = PlayObject then
        Result := True;
    'M': if g_HighMCHuman = PlayObject then
        Result := True;
    'S': if g_HighSCHuman = PlayObject then
        Result := True;
  else if g_HighLevelHuman = PlayObject then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfIsLockPassword(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := PlayObject.m_boPasswordLocked;
end;

function TNormNpc.ConditionOfIsLockStorage(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := not PlayObject.m_boCanGetBackItem;
end;

function TNormNpc.ConditionOfCheckPayMent(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nPayMent: Integer;
begin
  Result := False;
  nPayMent := Str_ToInt(QuestConditionInfo.sParam1, -1);
  if nPayMent < 1 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKPAYMENT);
    Exit;
  end;

  if PlayObject.m_nPayMent = nPayMent then
    Result := True;

end;

function TNormNpc.ConditionOfCheckSlaveName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sSlaveName: string;
  BaseObject: TBaseObject;
begin
  Result := False;
  sSlaveName := QuestConditionInfo.sParam1;
  if sSlaveName = '' then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSLAVENAME);
    Exit;
  end;
  for i := 0 to PlayObject.m_SlaveList.Count - 1 do
  begin
    BaseObject := TBaseObject(PlayObject.m_SlaveList.Items[i]);
    if CompareText(sSlaveName, BaseObject.m_sCharName) = 0 then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TNormNpc.ActionOfUpgradeItems(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nRate, nWhere, nValType, nPoint, nAddPoint: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  nWhere := Str_ToInt(QuestActionInfo.sParam1, -1);
  nRate := Str_ToInt(QuestActionInfo.sParam2, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam3, -1);
  if (nWhere < 0) or (nWhere > High(THumanUseItems)) or (nRate < 0) or (nPoint < 0) or (nPoint > 255) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_UPGRADEITEMS);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (UserItem.wIndex <= 0) or (StdItem = nil) then
  begin
    PlayObject.SysMsg('你身上没有戴指定物品', c_Red, t_Hint);
    Exit;
  end;
  nRate := Random(nRate);
  nPoint := Random(nPoint);
  nValType := Random(30);
  if nRate <> 0 then
  begin
    PlayObject.SysMsg('装备升级失败', c_Red, t_Hint);
    Exit;
  end;
  if nValType = 14 then
  begin
    nAddPoint := (nPoint * 1000);
    if UserItem.Dura + nAddPoint > High(Word) then
      nAddPoint := High(Word) - UserItem.Dura;
    UserItem.Dura := UserItem.Dura + nAddPoint;
  end
  else if nValType = 15 then
  begin
    nAddPoint := (nPoint * 1000);
    if UserItem.DuraMax + nAddPoint > High(Word) then
      nAddPoint := High(Word) - UserItem.DuraMax;
    UserItem.DuraMax := UserItem.DuraMax + nAddPoint;
  end
  else if nValType in [16..(27 + 3)] then
  begin
    nAddPoint := nPoint;
    if nValType = 16 then
    begin
      UserItem.btValue[14] := nAddPoint;
    end
    else if nValType = 17 then
    begin
      UserItem.btValue[15] := _MIN(15, UserItem.btValue[15] div 16 + nAddPoint) * 16 + UserItem.btValue[15] mod 16;
    end
    else if nValType = 18 then
    begin
      UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, UserItem.btValue[15] mod 16 + nAddPoint);
    end
    else if nValType = 19 then
    begin
      UserItem.btValue[16] := _MIN(15, UserItem.btValue[16] div 16 + nAddPoint) * 16 + UserItem.btValue[16] mod 16;
    end
    else if nValType = 20 then
    begin
      UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, UserItem.btValue[16] mod 16 + nAddPoint);
    end
    else if nValType = 21 then
    begin
      UserItem.btValue[17] := _MIN(15, UserItem.btValue[17] div 16 + nAddPoint) * 16 + UserItem.btValue[17] mod 16;
    end
    else if nValType = 22 then
    begin
      UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, UserItem.btValue[17] mod 16 + nAddPoint);
    end
    else
    begin
      nAddPoint := nPoint;
      if UserItem.btValue[nValType - 5] + nAddPoint > High(byte) then
      begin
        nAddPoint := High(byte) - UserItem.btValue[nValType - 5];
      end;
      UserItem.btValue[nValType - 5] := UserItem.btValue[nValType - 5] + nAddPoint;
    end;
  end
  else
  begin
    nAddPoint := nPoint;
    if UserItem.btValue[nValType] + nAddPoint > High(byte) then
    begin
      nAddPoint := High(byte) - UserItem.btValue[nValType];
    end;

    UserItem.btValue[nValType] := UserItem.btValue[nValType] + nAddPoint;
  end;
  PlayObject.SendUpdateItem(UserItem);
  PlayObject.SysMsg('装备升级成功', c_Green, t_Hint);

  {PlayObject.SysMsg(StdItem.Name + ': ' +
    IntToStr(UserItem.Dura) + '/' +
    IntToStr(UserItem.DuraMax) + '/' +
    IntToStr(UserItem.btValue[0]) + '/' +
    IntToStr(UserItem.btValue[1]) + '/' +
    IntToStr(UserItem.btValue[2]) + '/' +

    IntToStr(UserItem.btValue[3]) + '/' +
    IntToStr(UserItem.btValue[4]) + '/' +
    IntToStr(UserItem.btValue[5]) + '/' +
    IntToStr(UserItem.btValue[6]) + '/' +
    IntToStr(UserItem.btValue[7]) + '/' +
    IntToStr(UserItem.btValue[8]) + '/' +
    IntToStr(UserItem.btValue[9]) + '/' +
    IntToStr(UserItem.btValue[10]) + '/' +
    IntToStr(UserItem.btValue[11]) + '/' +
    IntToStr(UserItem.btValue[12]) + '/' +
    IntToStr(UserItem.btValue[13])
    , c_Blue, t_Hint);}

end;

procedure TNormNpc.ActionOfUpgradeItemsEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nRate, nWhere, nValType, nPoint, nAddPoint: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  nUpgradeItemStatus: Integer;
  nRatePoint: Integer;
begin
  nWhere := Str_ToInt(QuestActionInfo.sParam1, -1);
  nValType := Str_ToInt(QuestActionInfo.sParam2, -1);
  nRate := Str_ToInt(QuestActionInfo.sParam3, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam4, -1);
  nUpgradeItemStatus := Str_ToInt(QuestActionInfo.sParam5, -1);
  if (nValType < 0) or (nValType > 30) or (nWhere < 0) or (nWhere > High(THumanUseItems))
    or (nRate < 0) or (nPoint < 0) or (nPoint > 255) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_UPGRADEITEMSEX);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (UserItem.wIndex <= 0) or (StdItem = nil) then
  begin
    PlayObject.SysMsg('你身上没有戴指定物品', c_Red, t_Hint);
    Exit;
  end;
  nRatePoint := Random(nRate * 10);
  nPoint := _MAX(1, Random(nPoint));

  if not (nRatePoint in [0..10]) then
  begin
    case nUpgradeItemStatus of //
      0: if QuestActionInfo.sParam6 = '' then
          PlayObject.SysMsg('装备升级未成功', c_Red, t_Hint);
      1:
        begin
          PlayObject.SendDelItems(UserItem);
          if StdItem.NeedIdentify = 1 then
            AddGameDataLogAPI('10' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              StdItem.Name + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
          UserItem.wIndex := 0;
          if QuestActionInfo.sParam6 = '' then
            PlayObject.SysMsg('装备破碎', c_Red, t_Hint);
        end;
      2:
        begin
          if QuestActionInfo.sParam6 = '' then PlayObject.SysMsg('装备升级失败，装备属性恢复默认', c_Red, t_Hint);

          if nValType > 13 then
          begin
            if nValType = 16 then
            begin
              UserItem.btValue[14] := 0;
            end
            else if nValType = 17 then
            begin
              UserItem.btValue[15] := UserItem.btValue[15] mod 16;
            end
            else if nValType = 18 then
            begin
              UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16;
            end
            else if nValType = 19 then
            begin
              UserItem.btValue[16] := UserItem.btValue[16] mod 16;
            end
            else if nValType = 20 then
            begin
              UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16;
            end
            else if nValType = 21 then
            begin
              UserItem.btValue[17] := UserItem.btValue[17] mod 16;
            end
            else if nValType = 22 then
            begin
              UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16;
            end
            else
            begin
              if not (nValType in [14, 15]) then
                UserItem.btValue[nValType - 5] := 0;
            end;
          end
          else
            UserItem.btValue[nValType] := 0;
          PlayObject.SendUpdateItem(UserItem);
        end;
    end;
    Exit;
  end;
  if nValType = 14 then
  begin
    nAddPoint := (nPoint * 1000);
    if UserItem.Dura + nAddPoint > High(Word) then
      nAddPoint := High(Word) - UserItem.Dura;
    UserItem.Dura := UserItem.Dura + nAddPoint;
  end
  else if nValType = 15 then
  begin
    nAddPoint := (nPoint * 1000);
    if UserItem.DuraMax + nAddPoint > High(Word) then
      nAddPoint := High(Word) - UserItem.DuraMax;
    UserItem.DuraMax := UserItem.DuraMax + nAddPoint;
  end
  else if nValType >= 16 then
  begin
    nAddPoint := nPoint;
    if nValType = 16 then
    begin
      nAddPoint := nPoint;
      if UserItem.btValue[nValType - 2] + nAddPoint > High(byte) then
        nAddPoint := High(byte) - UserItem.btValue[nValType - 2];
      UserItem.btValue[nValType - 2] := UserItem.btValue[nValType - 2] + nAddPoint;
    end
    else if nValType = 17 then
    begin
      UserItem.btValue[15] := _MIN(15, UserItem.btValue[15] div 16 + nAddPoint) * 16 + UserItem.btValue[15] mod 16;
    end
    else if nValType = 18 then
    begin
      UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, UserItem.btValue[15] mod 16 + nAddPoint);
    end
    else if nValType = 19 then
    begin
      UserItem.btValue[16] := _MIN(15, UserItem.btValue[16] div 16 + nAddPoint) * 16 + UserItem.btValue[16] mod 16;
    end
    else if nValType = 20 then
    begin
      UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, UserItem.btValue[16] mod 16 + nAddPoint);
    end
    else if nValType = 21 then
    begin
      UserItem.btValue[17] := _MIN(15, UserItem.btValue[17] div 16 + nAddPoint) * 16 + UserItem.btValue[17] mod 16;
    end
    else if nValType = 22 then
    begin
      UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, UserItem.btValue[17] mod 16 + nAddPoint);
    end
    else
    begin
      nAddPoint := nPoint;
      if UserItem.btValue[nValType - 5] + nAddPoint > High(byte) then
        nAddPoint := High(byte) - UserItem.btValue[nValType - 5];
      UserItem.btValue[nValType - 5] := UserItem.btValue[nValType - 5] + nAddPoint;
    end;
  end
  else
  begin
    nAddPoint := nPoint;
    if UserItem.btValue[nValType] + nAddPoint > High(byte) then
      nAddPoint := High(byte) - UserItem.btValue[nValType];
    UserItem.btValue[nValType] := UserItem.btValue[nValType] + nAddPoint;
  end;
  PlayObject.SendUpdateItem(UserItem);
  if QuestActionInfo.sParam6 = '' then
    PlayObject.SysMsg('装备升级成功', c_Green, t_Hint);

  {if QuestActionInfo.sParam6 = '' then PlayObject.SysMsg(StdItem.Name + ': ' +
      IntToStr(UserItem.Dura) + '/' +
      IntToStr(UserItem.DuraMax) + '-' +
      IntToStr(UserItem.btValue[0]) + '/' +
      IntToStr(UserItem.btValue[1]) + '/' +
      IntToStr(UserItem.btValue[2]) + '/' +
      IntToStr(UserItem.btValue[3]) + '/' +
      IntToStr(UserItem.btValue[4]) + '/' +
      IntToStr(UserItem.btValue[5]) + '/' +
      IntToStr(UserItem.btValue[6]) + '/' +
      IntToStr(UserItem.btValue[7]) + '/' +
      IntToStr(UserItem.btValue[8]) + '/' +
      IntToStr(UserItem.btValue[9]) + '/' +
      IntToStr(UserItem.btValue[10]) + '/' +
      IntToStr(UserItem.btValue[11]) + '/' +
      IntToStr(UserItem.btValue[12]) + '/' +
      IntToStr(UserItem.btValue[13])
      , c_Blue, t_Hint);}

end;
//声明变量
//VAR 数据类型(Integer String) 类型(HUMAN GUILD GLOBAL) 变量值

procedure TNormNpc.ActionOfVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  VarType: TVarType;
  sVarName: string;
  sVarValue: string;
  nVarValue: Integer;
  sName: string;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
resourcestring
  sVarFound = '变量%s已存在，变量类型:%s';
  sVarTypeError = '变量类型错误，错误类型:%s 当前支持类型(HUMAN、GUILD、GLOBAL)';
begin
  sType := QuestActionInfo.sParam2;
  sVarName := QuestActionInfo.sParam3;
  sVarValue := QuestActionInfo.sParam4;
  nVarValue := Str_ToInt(QuestActionInfo.sParam4, 0);
  VarType := vNone;
  if CompareText(QuestActionInfo.sParam1, 'Integer') = 0 then
    VarType := vInteger;
  if CompareText(QuestActionInfo.sParam1, 'String') = 0 then
    VarType := vString;

  if (sType = '') or (sVarName = '') or (VarType = vNone) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_VAR);
    Exit;
  end;

  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then
  begin
    //Dispose(DynamicVar);
    ScriptActionError(PlayObject, Format(sVarTypeError, [sType]), QuestActionInfo, sSC_VAR);
    Exit;
  end;
  boFoundVar := False;
  for i := 0 to DynamicVarList.Count - 1 do
  begin
    if CompareText(pTDynamicVar(DynamicVarList.Items[i]).sName, sVarName) = 0 then
    begin
      boFoundVar := True;
      Break;
    end;
  end;
  if not boFoundVar then
  begin
    New(DynamicVar);
    DynamicVar.sName := sVarName;
    DynamicVar.VarType := VarType;
    DynamicVar.nInternet := nVarValue;
    DynamicVar.sString := sVarValue;

    DynamicVarList.Add(DynamicVar);
  end
  else
  begin
    ScriptActionError(PlayObject, Format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_VAR);
    //Dispose(DynamicVar);
  end;
end;
//读取变量值
//LOADVAR 变量类型 变量名 文件名

procedure TNormNpc.ActionOfLoadVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  sVarName: string;
  sFileName: string;
  sName: string;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
  IniFile: TIniFile;
resourcestring
  sVarFound = '变量%s不存在，变量类型:%s';
  sVarTypeError = '变量类型错误，错误类型:%s 当前支持类型(HUMAN、GUILD、GLOBAL)';
begin
  sType := QuestActionInfo.sParam1;
  sVarName := QuestActionInfo.sParam2;
  sFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam3;
  if (sType = '') or (sVarName = '') or not FileExists(sFileName) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_LOADVAR);
    Exit;
  end;
  boFoundVar := False;
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then
  begin
    Dispose(DynamicVar);
    ScriptActionError(PlayObject, Format(sVarTypeError, [sType]), QuestActionInfo, sSC_VAR);
    Exit;
  end;

  IniFile := TIniFile.Create(sFileName);
  for i := 0 to DynamicVarList.Count - 1 do
  begin
    DynamicVar := DynamicVarList.Items[i];
    if CompareText(DynamicVar.sName, sVarName) = 0 then
    begin
      case DynamicVar.VarType of
        vInteger: DynamicVar.nInternet := IniFile.ReadInteger(sName, DynamicVar.sName, 0);
        vString: DynamicVar.sString := IniFile.ReadString(sName, DynamicVar.sName, '');
      end;
      boFoundVar := True;
      Break;
    end;
  end;

  if not boFoundVar then
    ScriptActionError(PlayObject, Format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_LOADVAR);
  IniFile.Free;
end;

//保存变量值
//SAVEVAR 变量类型 变量名 文件名

procedure TNormNpc.ActionOfSaveVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  sVarName: string;
  sFileName: string;
  sName: string;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
  IniFile: TIniFile;
resourcestring
  sVarFound = '变量%s不存在，变量类型:%s';
  sVarTypeError = '变量类型错误，错误类型:%s 当前支持类型(HUMAN、GUILD、GLOBAL)';
begin
  sType := QuestActionInfo.sParam1;
  sVarName := QuestActionInfo.sParam2;
  sFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam3;
  if (sType = '') or (sVarName = '') or not FileExists(sFileName) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SAVEVAR);
    Exit;
  end;
  boFoundVar := False;
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then
  begin
    Dispose(DynamicVar);
    ScriptActionError(PlayObject, Format(sVarTypeError, [sType]), QuestActionInfo, sSC_VAR);
    Exit;
  end;
  IniFile := TIniFile.Create(sFileName);
  for i := 0 to DynamicVarList.Count - 1 do
  begin
    DynamicVar := DynamicVarList.Items[i];
    if CompareText(DynamicVar.sName, sVarName) = 0 then
    begin
      case DynamicVar.VarType of
        vInteger: IniFile.WriteInteger(sName, DynamicVar.sName, DynamicVar.nInternet);
        vString: IniFile.WriteString(sName, DynamicVar.sName, DynamicVar.sString);
      end;
      boFoundVar := True;
      Break;
    end;
  end;
  if not boFoundVar then
    ScriptActionError(PlayObject, Format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_SAVEVAR);
  IniFile.Free;
end;
//对变量进行运算(+、-、*、/)

procedure TNormNpc.ActionOfCalcVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  sVarName: string;
  sName: string;
  sVarValue: string;
  nVarValue: Integer;
  sMethod: string;
  cMethod: Char;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
resourcestring
  sVarFound = '变量%s不存在，变量类型:%s';
  sVarTypeError = '变量类型错误，错误类型:%s 当前支持类型(HUMAN、GUILD、GLOBAL)';
begin
  sType := QuestActionInfo.sParam1;
  sVarName := QuestActionInfo.sParam2;
  sMethod := QuestActionInfo.sParam3;
  sVarValue := QuestActionInfo.sParam4;
  nVarValue := Str_ToInt(QuestActionInfo.sParam4, 0);
  if (sType = '') or (sVarName = '') or (sMethod = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CALCVAR);
    Exit;
  end;
  boFoundVar := False;
  cMethod := sMethod[1];
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then
  begin
    Dispose(DynamicVar);
    ScriptActionError(PlayObject, Format(sVarTypeError, [sType]), QuestActionInfo, sSC_CALCVAR);
    Exit;
  end;
  for i := 0 to DynamicVarList.Count - 1 do
  begin
    DynamicVar := DynamicVarList.Items[i];
    if CompareText(DynamicVar.sName, sVarName) = 0 then
    begin
      case DynamicVar.VarType of
        vInteger:
          begin
            case cMethod of
              '=': DynamicVar.nInternet := nVarValue;
              '+': DynamicVar.nInternet := DynamicVar.nInternet + nVarValue;
              '-': DynamicVar.nInternet := DynamicVar.nInternet - nVarValue;
              '*': DynamicVar.nInternet := DynamicVar.nInternet * nVarValue;
              '/': DynamicVar.nInternet := DynamicVar.nInternet div nVarValue;
            end;
          end;
        vString:
          begin
            case cMethod of
              '=': DynamicVar.sString := sVarValue;
              '+': DynamicVar.sString := DynamicVar.sString + sVarValue;
            end;
          end;
      end;
      boFoundVar := True;
      Break;
    end;
  end;
  if not boFoundVar then
    ScriptActionError(PlayObject, Format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_CALCVAR);
end;

procedure TNormNpc.ActionOfDelayCall(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  pdc: PTDelayCallNPC;
begin
  if (QuestActionInfo.sParam2 = '') or (QuestActionInfo.nParam1 <= 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_DELAYGOTO + ' 或 ' + sSC_DELAYCALL);
    Exit;
  end;
  New(pdc);
  pdc.nDelayCall := _MAX(1, QuestActionInfo.nParam1);
  pdc.sDelayCallLabel := QuestActionInfo.sParam2;
  pdc.dwDelayCallTick := GetTickCount();
  pdc.bProcessed := False;
  pdc.DelayCallNPC := Integer(Self);
  PlayObject.m_DelayCallList.Add(pdc);
end;

procedure TNormNpc.ActionOfClearEctype(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.DeleteBagEctype();
  PlayObject.DeleteStorageEctype();
end;

procedure TNormNpc.Initialize;
begin
  inherited Initialize;
  m_Castle := g_CastleManager.InCastleWarArea(Self);
end;

function TNormNpc.ConditionOfCheckNameDateList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sListFileName, sLineText, sHumName, sDate: string;
  boDeleteExprie, boNoCompareHumanName: Boolean;
  dOldDate: TDateTime;
  cMethod: Char;
  nValNo, nValNoDay, nDayCount, nDay: Integer;
begin
  Result := False;
  nDayCount := Str_ToInt(QuestConditionInfo.sParam3, -1);
  nValNo := GetValNameNo(QuestConditionInfo.sParam4);
  nValNoDay := GetValNameNo(QuestConditionInfo.sParam5);
  boDeleteExprie := CompareText(QuestConditionInfo.sParam6, '清理') = 0;
  boNoCompareHumanName := CompareText(QuestConditionInfo.sParam6, '1') = 0;
  cMethod := QuestConditionInfo.sParam2[1];
  if nDayCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMEDATELIST);
    Exit;
  end;
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestConditionInfo.sParam1;
  if FileExists(sListFileName) then
  begin
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessageAPI('loading fail.... => ' + sListFileName);
    end;
    for i := 0 to LoadList.Count - 1 do
    begin
      sLineText := Trim(LoadList.Strings[i]);
      sLineText := GetValidStr3(sLineText, sHumName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sDate, [' ', #9]);
      if (CompareText(sHumName, PlayObject.m_sCharName) = 0) or boNoCompareHumanName then
      begin
        nDay := High(Integer);
        if TryStrToDateTime(sDate, dOldDate) then
          nDay := GetDayCount(Now, dOldDate);
        case cMethod of
          '=': if nDay = nDayCount then
              Result := True;
          '>': if nDay > nDayCount then
              Result := True;
          '<': if nDay < nDayCount then
              Result := True;
        else if nDay >= nDayCount then
          Result := True;
        end;
        if nValNo >= 0 then
        begin
          case nValNo of
            0..9: PlayObject.m_nVal[nValNo] := nDay;
            100..199: g_Config.GlobalVal[nValNo - 100] := nDay;
            200..299: PlayObject.m_DyVal[nValNo - 200] := nDay;
            300..399: PlayObject.m_nMval[nValNo - 300] := nDay;
            400..499: g_Config.GlobaDyMval[nValNo - 400] := nDay;
            700..799: g_Config.HGlobalVal[nValNo - 700] := nDay;
          end;
        end;
        if nValNoDay >= 0 then
        begin
          case nValNoDay of
            0..9: PlayObject.m_nVal[nValNoDay] := nDayCount - nDay;
            100..199: g_Config.GlobalVal[nValNoDay - 100] := nDayCount - nDay;
            200..299: PlayObject.m_DyVal[nValNoDay - 200] := nDayCount - nDay;
            300..399: PlayObject.m_nMval[nValNoDay - 300] := nDayCount - nDay;
            700..799: g_Config.HGlobalVal[nValNoDay - 700] := nDayCount - nDay;
          end;
        end;
        if not Result then
        begin
          if boDeleteExprie then
          begin
            LoadList.Delete(i);
            try
              LoadList.SaveToFile(sListFileName);
            except
              MainOutMessageAPI('Save fail.... => ' + sListFileName);
            end;
          end;
        end;
        Break;
      end;
    end;
    LoadList.Free;
  end
  else
    MainOutMessageAPI('file not found => ' + sListFileName);
end;

function TNormNpc.ConditionOfCheckMapHumanCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount, nHumanCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMAPHUMANCOUNT);
    Exit;
  end;
  nHumanCount := UserEngine.GetMapHuman(QuestConditionInfo.sParam1);
  cMethod := QuestConditionInfo.sParam2[1];
  case cMethod of
    '=': if nHumanCount = nCount then
        Result := True;
    '>': if nHumanCount > nCount then
        Result := True;
    '<': if nHumanCount < nCount then
        Result := True;
  else if nHumanCount >= nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMapRangeHumanCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nX, nY, nR, nCount, nHumanCount: Integer;
  cMethod: Char;
  Envir: TEnvirnoment;
begin
  //CheckMapRangeHumanCount map x y range > 100
  Result := False;
  Envir := g_MapManager.FindMap(QuestConditionInfo.sParam1);
  nX := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nY := Str_ToInt(QuestConditionInfo.sParam3, -1);
  nR := Str_ToInt(QuestConditionInfo.sParam4, -1);
  nCount := Str_ToInt(QuestConditionInfo.sParam6, -1);
  if (nCount < 0) or (nX < 0) or (nY < 0) or (nR < 1) or (Envir = nil) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMAPRANGEHUMANCOUNT);
    Exit;
  end;

  nHumanCount := UserEngine.GetMapOfRangeHumanCount(Envir, nX, nY, nR);
  cMethod := QuestConditionInfo.sParam5[1];
  case cMethod of
    '=': if nHumanCount = nCount then
        Result := True;
    '>': if nHumanCount > nCount then
        Result := True;
    '<': if nHumanCount < nCount then
        Result := True;
  else if nHumanCount >= nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCHECKMAPMONCOUNT(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount, nMonCount: Integer;
  cMethod: Char;
  Envir: TEnvirnoment;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam3, -1);
  Envir := g_MapManager.FindMap(QuestConditionInfo.sParam1);
  if (nCount < 0) or (Envir = nil) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMAPMONCOUNT);
    Exit;
  end;

  nMonCount := UserEngine.GetMapMonster(Envir, nil);

  cMethod := QuestConditionInfo.sParam2[1];
  case cMethod of
    '=': if nMonCount = nCount then
        Result := True;
    '>': if nMonCount > nCount then
        Result := True;
    '<': if nMonCount < nCount then
        Result := True;
  else if nMonCount >= nCount then
    Result := True;
  end;
end;

function TNormNpc.GetDynamicVarList(PlayObject: TPlayObject; sType: string; var sName: string): TList;
begin
  Result := nil;
  if CompareLStr(sType, 'HUMAN', Length('HUMAN')) then
  begin
    Result := PlayObject.m_DynamicVarList;
    sName := PlayObject.m_sCharName;
  end
  else if CompareLStr(sType, 'GUILD', Length('GUILD')) then
  begin
    if PlayObject.m_MyGuild = nil then
      Exit;
    Result := TGuild(PlayObject.m_MyGuild).m_DynamicVarList;
    sName := TGuild(PlayObject.m_MyGuild).sGuildName;
  end
  else if CompareLStr(sType, 'GLOBAL', Length('GLOBAL')) then
  begin
    Result := g_DynamicVarList;
    sName := 'GLOBAL';
  end;
end;

function TNormNpc.CheckOnPostSell(sCharName: string; var DateTime: TDateTime): Boolean;
var
  i: Integer;
  PostSell: pTPostSell;
begin
  Result := False;
  DateTime := Now;
  if ClassNameIs(TMerchant.ClassName) then
  begin
    if (TMerchant(Self).m_PostSellList <> nil) and (TMerchant(Self).m_PostSellList.Count > 0) then
    begin
      for i := 0 to TMerchant(Self).m_PostSellList.Count - 1 do
      begin
        PostSell := pTPostSell(TMerchant(Self).m_PostSellList[i]);
        if PostSell.sCharName = sCharName then
        begin
          DateTime := PostSell.dPostTime;
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

function TNormNpc.GetSellOffItemCount(PlayObject: TPlayObject): Integer;
var
  i, ii: Integer;
  List: TList;
  SellOff: pSellOff;
  m_SellOffList: TList;
begin
  Result := 0;
  if not (ClassNameIs(TMerchant.ClassName)) then
    Exit;
  m_SellOffList := TMerchant(Self).m_SellOffList;

  if m_SellOffList <> nil then
  begin
    for i := m_SellOffList.Count - 1 downto 0 do
    begin
      List := m_SellOffList[i];
      if (List = nil) or (List.Count = 0) then
      begin
        m_SellOffList.Delete(i);
        Continue;
      end;
      for ii := 0 to List.Count - 1 do
      begin
        SellOff := pSellOff(List[ii]);
        if SellOff^.sCharName = PlayObject.m_sCharName then
        begin
          Inc(Result);
        end;
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfStatusRate(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nRate: Integer;
  nTime: Integer;
  nIndex: Integer;
begin
  nIndex := Str_ToInt(QuestActionInfo.sParam1, -1);
  nRate := Str_ToInt(QuestActionInfo.sParam2, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam3, -1);
  if (nRate < 1) or (nTime < 0) or (nIndex < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_POWERRATE);
    Exit;
  end;

  PlayObject.m_wPowerRate[nIndex] := nRate - 1;
  PlayObject.m_wPowerRateTick[nIndex] := GetTickCount + LongWord(nTime * 1000);
  case nIndex of
    0: PlayObject.SysMsg(Format('防御力倍数:%d 时长%d秒',
        [PlayObject.m_wPowerRate[nIndex] + 1, nTime]), c_Green, t_Hint);
    1: PlayObject.SysMsg(Format('魔御力倍数:%d 时长%d秒',
        [PlayObject.m_wPowerRate[nIndex] + 1, nTime]), c_Green, t_Hint);
    2: PlayObject.SysMsg(Format('攻击力倍数:%d 时长%d秒',
        [PlayObject.m_wPowerRate[nIndex] + 1, nTime]), c_Green, t_Hint);
    3: PlayObject.SysMsg(Format('魔法力倍数:%d 时长%d秒',
        [PlayObject.m_wPowerRate[nIndex] + 1, nTime]), c_Green, t_Hint);
    4: PlayObject.SysMsg(Format('道术倍数:%d 时长%d秒',
        [PlayObject.m_wPowerRate[nIndex] + 1, nTime]), c_Green, t_Hint);
    5: PlayObject.SysMsg(Format('体力值倍数:%d 时长%d秒',
        [PlayObject.m_wPowerRate[nIndex] + 1, nTime]), c_Green, t_Hint);
    6: PlayObject.SysMsg(Format('魔法值倍数:%d 时长%d秒',
        [PlayObject.m_wPowerRate[nIndex] + 1, nTime]), c_Green, t_Hint);
  end;
  PlayObject.m_sStatuName := QuestActionInfo.sParam4;
  PlayObject.RecalcAbilitys;
  PlayObject.SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
  PlayObject.RefShowName;
end;

procedure TNormNpc.ActionOfNameColor(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nIndex: Integer;
begin
  nIndex := Str_ToInt(QuestActionInfo.sParam1, -1);

  if (nIndex < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_POWERRATE);
    Exit;
  end;
  PlayObject.m_boNameChangeColor := nIndex = 1;
end;

procedure TNormNpc.ActionofDETOXIFCATION(PlayObject: TPlayObject);
var
  i: Integer;
  boChg: Boolean;
begin
  boChg := False;
  if PlayObject = nil then
    Exit;
  with PlayObject do
  begin
    for i := Low(m_dwStatusArrTick) to High(m_dwStatusArrTick) do
    begin //004C832E
      if (m_wStatusTimeArr[i] > 0) then
      begin
        boChg := True;
        m_wStatusTimeArr[i] := 0;
      end;
    end;

    if boChg then
    begin
      m_nCharStatus := GetCharStatus();
      StatusChanged();
    end;
  end;
end;
procedure TNormNpc.ActionOfAutoMove(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  MapCellInfo: pTMapCellinfo;
begin
  if PlayObject = nil then Exit;
  if m_PEnvir.GetMapCellInfo(QuestActionInfo.nParam1, QuestActionInfo.nParam2, MapCellInfo) and (MapCellInfo.chFlag = 0) then
     PlayObject.SendDefMessage(SM_AUTOMOVE, 0, QuestActionInfo.nParam1, QuestActionInfo.nParam2, 0, '');
end;
procedure TNormNpc.ActionOfGetTitlesCount(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  I, Sum: Integer;
begin
  if QuestActionInfo.sParam1 = '' then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo,sSC_GETTITLESCOUNT);
    Exit;
  end;

  Sum := 0;
  if PlayObject <> nil then
  begin
    for I := Low(PlayObject.m_Titles)  to  High(PlayObject.m_Titles) do
    begin
      if PlayObject.m_Titles[I].Index > 0 then
        Inc(Sum);
    end;
  end;
  
  I := GetValNameNo(QuestActionInfo.sParam1);
  case I of
    0..9: PlayObject.m_nVal[I] := Sum;                          // P 变量
    100..199: g_Config.GlobalVal[I mod 100] := Sum;             // G 变量
    200..299: PlayObject.m_DyVal[I mod 200] := Sum;             // D 变量
    300..399: PlayObject.m_nMval[I mod 300] := Sum;             // M 变量
    400..499: g_Config.GlobaDyMval[I mod 400] := Sum;           // I 变量
    700..799: g_Config.HGlobalVal[I mod 700] := Sum;            // H 变量
  end
end;

function TNormNpc.ActionOfCheckActiveTitle(PlayObject: TPlayObject; QuestActionInfo: pTQuestConditionInfo): Boolean;
var
  Tindex: Integer;
begin
  Result := True;
  if QuestActionInfo.sParam1 <> '' then
  begin
    Tindex := UserEngine.GetTitleIdx(QuestActionInfo.sParam1);
    if Tindex <> PlayObject.m_btActiveTitle then  Result := False;
  end
  else
    ScriptConditionError(PlayObject, QuestActionInfo, sSC_CHECKACTIVETITLE);
end;

{ TGuildOfficial }

procedure TGuildOfficial.Click(PlayObject: TPlayObject); //004A30F4
begin
  inherited;
end;

procedure TGuildOfficial.GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string);
var
  i, ii: Integer;
  sText: string;
  List: TStringList;
  sStr: string;
begin
  inherited;
  if sVariable = '$REQUESTCASTLELIST' then
  begin
    sText := '';
    List := TStringList.Create;
    g_CastleManager.GetCastleNameList(List);
    for i := 0 to List.Count - 1 do
    begin
      ii := i + 1;
      if ((ii div 2) * 2 = ii) then
        sStr := '\'
      else
        sStr := '';

      sText := sText + Format('<%s/@requestcastlewarnow%d> %s',
        [List.Strings[i], i, sStr]);
    end;
    sText := sText + '\ \';
    List.Free;
    sMsg := ExVariableText(sMsg, '<$REQUESTCASTLELIST>', sText);
  end;
end;

procedure TGuildOfficial.Run; //004A37F0
begin
  if Random(40) = 0 then
    TurnTo(Random(8))
  else
  begin
    if Random(30) = 0 then
      SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  end;
  inherited;
end;

procedure TGuildOfficial.UserSelect(PlayObject: TPlayObject; sData: string);
var
  sMsg, sLabel: string;
  boCanJmp: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TGuildOfficial::UserSelect... ';
begin
  inherited;
  try
    if (sData <> '') and (sData[1] = '@') then
    begin
      sMsg := GetValidStr3(sData, sLabel, [#13]);
      boCanJmp := PlayObject.LableIsCanJmp(sLabel);
      GotoLable(PlayObject, sLabel, not boCanJmp);
      if not boCanJmp then
        Exit;
      if CompareText(sLabel, sBUILDGUILDNOW) = 0 then
      begin
        ReQuestBuildGuild(PlayObject, sMsg);
      end
      else if CompareText(sLabel, sSCL_GUILDWAR) = 0 then
      begin
        ReQuestGuildWar(PlayObject, sMsg);
      end
      else if CompareText(sLabel, sDONATE) = 0 then
      begin
        DoNate(PlayObject);
      end
      else if CompareText(sLabel, sREQUESTCASTLEWAR) = 0 then
      begin
        ReQuestCastleWar(PlayObject, sMsg);
      end
      else if CompareLStr(sLabel, sREQUESTCASTLEWAR, Length(sREQUESTCASTLEWAR)) then
      begin
        ReQuestCastleWar(PlayObject, Copy(sLabel, Length(sREQUESTCASTLEWAR) + 1, Length(sLabel) - Length(sREQUESTCASTLEWAR)));
      end
      else if CompareText(sLabel, sEXIT) = 0 then
      begin
        PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
      end
      else if CompareText(sLabel, sBACK) = 0 then
      begin
        if PlayObject.m_sScriptGoBackLable = '' then
          PlayObject.m_sScriptGoBackLable := sMAIN;
        GotoLable(PlayObject, PlayObject.m_sScriptGoBackLable, False);
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

function TGuildOfficial.ReQuestBuildGuild(PlayObject: TPlayObject; sGuildName: string): Integer;
var
  UserItem: pTUserItem;
begin
  Result := 0;
  sGuildName := Trim(sGuildName);
  UserItem := nil;
  if sGuildName = '' then
    Result := -4;
  if Length(sGuildName) > 14 then
  begin
    PlayObject.SysMsg('行会的名字只能在７个汉字以内!', c_Red, t_Hint);
    Result := -4;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    if PlayObject.m_nGold >= g_Config.nBuildGuildPrice then
    begin
      UserItem := PlayObject.CheckItems(g_Config.sWomaHorn);
      if UserItem = nil then
        Result := -3; //'你没有准备好需要的全部物品'
    end
    else
      Result := -2; //'缺少创建费用'
  end
  else
    Result := -1; //'您已经加入其它行会'
  if Result = 0 then
  begin
    if g_GuildManager.AddGuild(sGuildName, PlayObject.m_sCharName) then
    begin
      UserEngine.SendInterMsg(ISM_ADDGUILD, g_nServerIndex, sGuildName + '/' + PlayObject.m_sCharName);
      PlayObject.SendDelItems(UserItem);
      PlayObject.DelBagItem(UserItem.MakeIndex, g_Config.sWomaHorn);
      PlayObject.DecGold(g_Config.nBuildGuildPrice);
      PlayObject.GoldChanged();
      PlayObject.m_MyGuild := g_GuildManager.MemberOfGuild(PlayObject.m_sCharName);
      if PlayObject.m_MyGuild <> nil then
      begin
        PlayObject.m_sGuildRankName := TGuild(PlayObject.m_MyGuild).GetRankName(PlayObject, PlayObject.m_nGuildRankNo);
        RefShowName();
      end;
    end
    else
      Result := -4;
  end;
  if Result >= 0 then
    PlayObject.SendMsg(Self, RM_BUILDGUILD_OK, 0, 0, 0, 0, '')
  else
    PlayObject.SendMsg(Self, RM_BUILDGUILD_FAIL, 0, Result, 0, 0, '');
end;

function TGuildOfficial.ReQuestGuildWar(PlayObject: TPlayObject; sGuildName: string): Integer;
begin
  if g_GuildManager.FindGuild(sGuildName) <> nil then
  begin
    if PlayObject.m_nGold >= g_Config.nGuildWarPrice then
    begin
      PlayObject.DecGold(g_Config.nGuildWarPrice);
      PlayObject.GoldChanged();
      PlayObject.ReQuestGuildWar(sGuildName);
    end
    else
    begin
      PlayObject.SysMsg('你没有足够的金币', c_Red, t_Hint);
    end;
  end
  else
  begin
    PlayObject.SysMsg('行会 ' + sGuildName + ' 不存在', c_Red, t_Hint);
  end;
  Result := 1;
end;

procedure TGuildOfficial.DoNate(PlayObject: TPlayObject); //004A346C
begin
  PlayObject.SendMsg(Self, RM_DONATE_OK, 0, 0, 0, 0, '');
end;

procedure TGuildOfficial.ReQuestCastleWar(PlayObject: TPlayObject; sIndex: string);
var
  UserItem: pTUserItem;
  Castle: TUserCastle;
  nIndex: Integer;
begin
  nIndex := Str_ToInt(sIndex, -1);
  if nIndex < 0 then
    nIndex := 0;
  Castle := g_CastleManager.GetCastle(nIndex);
  if PlayObject.IsGuildMaster and not Castle.IsMember(PlayObject) then
  begin
    UserItem := PlayObject.CheckItems(g_Config.sZumaPiece);
    if UserItem <> nil then
    begin
      if Castle.AddAttackerInfo(TGuild(PlayObject.m_MyGuild)) then
      begin
        PlayObject.SendDelItems(UserItem);
        PlayObject.DelBagItem(UserItem.MakeIndex, g_Config.sZumaPiece);
        GotoLable(PlayObject, '~@request_ok', False);
      end
      else
        PlayObject.SysMsg('你现在无法请求攻城', c_Red, t_Hint);
    end
    else
      PlayObject.SysMsg('你没有' + g_Config.sZumaPiece + '', c_Red, t_Hint);
  end
  else
    PlayObject.SysMsg('你的请求被取消', c_Red, t_Hint);
end;

procedure TCastleOfficial.RepairDoor(PlayObject: TPlayObject); //004A3FB8
begin
  if m_Castle = nil then
  begin
    PlayObject.SysMsg('NPC不属于城堡', c_Red, t_Hint);
    Exit;
  end;
  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nRepairDoorPrice then
  begin
    if TUserCastle(m_Castle).RepairDoor then
    begin
      Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nRepairDoorPrice);
      PlayObject.SysMsg('修理成功', c_Green, t_Hint);
    end
    else
      PlayObject.SysMsg('城门不需要修理', c_Green, t_Hint);
  end
  else
    PlayObject.SysMsg('城内资金不足', c_Red, t_Hint);
end;

procedure TCastleOfficial.RepairWallNow(nWallIndex: Integer; PlayObject: TPlayObject);
begin
  if m_Castle = nil then
  begin
    PlayObject.SysMsg('NPC不属于城堡', c_Red, t_Hint);
    Exit;
  end;

  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nRepairWallPrice then
  begin
    if TUserCastle(m_Castle).RepairWall(nWallIndex) then
    begin
      Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nRepairWallPrice);
      PlayObject.SysMsg('修理成功', c_Green, t_Hint);
    end
    else
    begin
      PlayObject.SysMsg('城门不需要修理', c_Green, t_Hint);
    end;
  end
  else
  begin
    PlayObject.SysMsg('城内资金不足', c_Red, t_Hint);
  end;
end;

constructor TCastleOfficial.Create;
begin
  inherited;
end;

destructor TCastleOfficial.Destroy;
begin
  inherited;
end;

constructor TGuildOfficial.Create;
begin
  inherited;
  m_btRaceImg := RCC_MERCHANT;
  m_wAppr := 8;
end;

destructor TGuildOfficial.Destroy;
begin
  inherited;
end;

procedure TGuildOfficial.SendCustemMsg(PlayObject: TPlayObject; sMsg: string);
begin
  inherited;
end;

procedure TCastleOfficial.SendCustemMsg(PlayObject: TPlayObject; sMsg: string);
begin
  if not g_Config.boSubkMasterSendMsg then
  begin
    PlayObject.SysMsg(g_sSubkMasterMsgCanNotUseNowMsg, c_Red, t_Hint);
    Exit;
  end;
  if PlayObject.m_boSendMsgFlag then
  begin
    PlayObject.m_boSendMsgFlag := False;
    UserEngine.SendBroadCastMsg(PlayObject.m_sCharName + ': ' + sMsg, t_Castle);
  end;
end;

procedure TNormNpc.ActionOfSetChatColor(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  //PlayObject.m_btChatColor := QuestActionInfo.nParam1;
end;

procedure TNormNpc.ActionOfSetChatFont(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  //PlayObject.m_btChatFont := QuestActionInfo.nParam1;
end;

procedure TNormNpc.ActionOfGuildMapMove(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, ii: Integer;
  dwValue: LongWord;
  GuildMember: TPlayObject;
  GuildRank: pTGuildRank;
  nRecallCount, nNoRecallCount: Integer;
  Castle: TUserCastle;
  nX, nY: Integer;
  boIsOK: Boolean;
resourcestring
  sNotGuildMasterMsg = '行会掌门人才可以使用此功能。';
  sPEnvirNoGuildRecallMsg = '本地图不允许使用此功能。';
  sNoMoveUnderWarMsg = '攻城区域不允许使用此功能。';
begin
  if QuestActionInfo.sParam1 = '' then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GUILDMAPMOVE);
    Exit;
  end;
  nX := Str_ToInt(QuestActionInfo.sParam2, -1);
  nY := Str_ToInt(QuestActionInfo.sParam3, -1);
  if (nX = -1) or (nY = -1) then
    boIsOK := True
  else
    boIsOK := False;
  if not PlayObject.IsGuildMaster then
  begin
    PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, sNotGuildMasterMsg);
    Exit;
  end;
  if PlayObject.m_PEnvir.m_MapFlag.boNOGUILDRECALL then
  begin
    PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, sPEnvirNoGuildRecallMsg);
    Exit;
  end;
  Castle := g_CastleManager.InCastleWarArea(PlayObject);
  if (Castle <> nil) and Castle.m_boUnderWar then
  begin
    PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, sNoMoveUnderWarMsg);
    Exit;
  end;
  nRecallCount := 0;
  nNoRecallCount := 0;
  dwValue := (GetTickCount - PlayObject.m_dwGroupRcallTick) div 1000;
  PlayObject.m_dwGroupRcallTick := PlayObject.m_dwGroupRcallTick + dwValue * 1000;
  if PlayObject.m_wGroupRcallTime > dwValue then
    Dec(PlayObject.m_wGroupRcallTime, dwValue)
  else
    PlayObject.m_wGroupRcallTime := 0;
  if PlayObject.m_wGroupRcallTime > 0 then
  begin
    PlayObject.SysMsg(Format('%d 秒之后才可以再使用此功能', [PlayObject.m_wGroupRcallTime]), c_Red, t_Hint);
    Exit;
  end;
  for i := 0 to TGuild(PlayObject.m_MyGuild).m_RankList.Count - 1 do
  begin
    GuildRank := TGuild(PlayObject.m_MyGuild).m_RankList.Items[i];
    for ii := 0 to GuildRank.MemberList.Count - 1 do
    begin
      GuildMember := TPlayObject(GuildRank.MemberList.GetValues(GuildRank.MemberList.Keys[ii]));
      if GuildMember <> nil then
      begin
        if PlayObject = GuildMember then
          Continue;
        if GuildMember.m_boAllowGuildReCall then
        begin
          if GuildMember.m_PEnvir.m_MapFlag.boNORECALL then
            PlayObject.SysMsg(Format('%s 所在的地图不允许传送', [GuildMember.m_sCharName]), c_Red, t_Hint)
          else
          begin
            GuildMember.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            if boIsOK then
              GuildMember.MapRandomMove(QuestActionInfo.sParam1, 0)
            else
              GuildMember.SpaceMove(QuestActionInfo.sParam1, nX, nY, 0);
            //PlayObject.RecallHuman(GuildMember.m_sCharName);
            Inc(nRecallCount);
          end;
        end
        else
        begin
          Inc(nNoRecallCount);
          PlayObject.SysMsg(Format('%s 不允许行会合一', [GuildMember.m_sCharName]), c_Red, t_Hint);
        end;
      end;
    end;
  end;
  PlayObject.SysMsg(Format('已传送%d个成员，%d个成员未被传送。', [nRecallCount, nNoRecallCount]), c_Green, t_Hint);
  PlayObject.m_dwGroupRcallTick := GetTickCount();
  PlayObject.m_wGroupRcallTime := g_Config.nGuildRecallTime;
end;

procedure TNormNpc.ActionOfAddGuild(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  boAddState: Boolean;
  sGuildName, sGuildChief: string;
begin
  sGuildName := QuestActionInfo.sParam1;
  sGuildChief := PlayObject.m_sCharName;
  if sGuildName = '' then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_ADDGUILD);
    Exit;
  end;
  boAddState := False;
  if g_GuildManager.MemberOfGuild(sGuildChief) = nil then
  begin
    if g_GuildManager.AddGuild(sGuildName, sGuildChief) then
    begin
      UserEngine.SendInterMsg(ISM_ADDGUILD, g_nServerIndex, sGuildName + '/' + sGuildChief);
      boAddState := True;
    end;
  end;
  if boAddState then
  begin
    PlayObject.m_MyGuild := TObject(g_GuildManager.MemberOfGuild(sGuildChief));
    if PlayObject.m_MyGuild <> nil then
    begin
      PlayObject.m_sGuildRankName := TGuild(PlayObject.m_MyGuild).GetRankName(PlayObject, PlayObject.m_nGuildRankNo);
      PlayObject.RefShowName();
    end;
  end;
end;

procedure TNormNpc.ActionOfRepairAllItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  boIsHasItem: Boolean;
  sUserItemName: string;
begin
  boIsHasItem := False;
  with PlayObject do
  begin
    for i := Low(m_UseItems) to High(m_UseItems) do
    begin
      if m_UseItems[i].wIndex <= 0 then
        Continue;
      sUserItemName := UserEngine.GetStdItemName(m_UseItems[i].wIndex);
      if InLimitItemList(sUserItemName, -1, t_dRepair) then
      begin
        SysMsg(sUserItemName + ' 禁止修理！', c_Red, t_Hint);
        Continue;
      end;
      m_UseItems[i].Dura := m_UseItems[i].DuraMax;
      SendMsg(Self, RM_DURACHANGE, i, m_UseItems[i].Dura, m_UseItems[i].DuraMax, 0, '');
      boIsHasItem := True;
    end;
    if boIsHasItem then
      SysMsg('您身上的的装备修复成功...', c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfCreateHero(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sJob, sSex: string;
begin
  if PlayObject.m_sHeroName = '' then
  begin
    if PlayObject.m_sTempHeroName <> '' then
    begin
      sJob := QuestActionInfo.sParam1;
      sSex := QuestActionInfo.sParam2;
      if (sJob <> '') or (sSex <> '') then
      begin
        UserEngine.SaveHumanRcd(PlayObject, PlayObject.m_sTempHeroName, sJob, sSex);
        GotoLable(PlayObject, '@CreateingHero', False);
      end
      else
        ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CREATEHERO);
    end
    else
      GotoLable(PlayObject, '@SetHeroName', False);
  end
  else
    GotoLable(PlayObject, '@HaveHero', False);
end;

procedure TNormNpc.ActionOfCreateHeroEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sJob, sSex: string;
begin
  if PlayObject.m_sTempHeroName <> '' then
  begin
    sJob := QuestActionInfo.sParam1;
    sSex := QuestActionInfo.sParam2;
    if (sJob <> '') or (sSex <> '') then
    begin
      UserEngine.SaveHumanRcd(PlayObject, PlayObject.m_sTempHeroName, sJob, sSex, True);
      GotoLable(PlayObject, '@CreateingHero', False);
    end
    else
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CREATEHERO);
  end
  else
    GotoLable(PlayObject, '@SetHeroName', False);
end;

procedure TNormNpc.ActionOfDeleteHero(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  if PlayObject.GetHeroObjectA = nil then
  begin
    if PlayObject.m_sHeroName <> '' then
    begin
      PlayObject.m_sHeroName := '';
      GotoLable(PlayObject, '@DeleteHeroOK', False);
    end
    else
      GotoLable(PlayObject, '@NotHaveHero', False);
  end
  else
    GotoLable(PlayObject, '@LogOutHeroFirst', False);
end;

procedure TNormNpc.ActionOfTagMapInfo(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nIdx: Integer;
  sMAP: string;
resourcestring
  sWar = '%d 秒后才能使用该功能...';
  sWarMsg = '当前地图不允许记录坐标信息...';
begin
  nIdx := Str_ToInt(QuestActionInfo.sParam1, 0);
  if not (nIdx in [1..6]) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_TAGMAPINFO);
    Exit;
  end;
  if (PlayObject.m_PEnvir <> nil) and PlayObject.m_PEnvir.m_MapFlag.boNoTagMapInfo then
  begin
    PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, sWarMsg);
    Exit;
  end;
  if GetTickCount - PlayObject.m_dwSaveHumanDataTick > 60 * 1000 then
  begin
    PlayObject.m_dwSaveHumanDataTick := GetTickCount;

    //if PlayObject.m_sMapFileName <> '' then
    //  sMAP := PlayObject.m_sMapFileName
    //else
    sMAP := PlayObject.m_sMapName;
    PlayObject.m_MakerMapInfo[nIdx].sMapName := sMAP;
    PlayObject.m_MakerMapInfo[nIdx].wMapX := PlayObject.m_nCurrX;
    PlayObject.m_MakerMapInfo[nIdx].wMapY := PlayObject.m_nCurrY;
    PlayObject.SaveHumanCustomData();
  end
  else
    PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, Format(sWar, [60 - ((GetTickCount - PlayObject.m_dwSaveHumanDataTick) div 1000) + 1]));
  //PlayObject.SysMsg(Format(sWar, [60 - ((GetTickCount - PlayObject.m_dwSaveHumanDataTick) div 1000) + 1]), c_Purple, t_Hint);
end;

procedure TNormNpc.ActionOfTagMapMove(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nIdx: Integer;
  Envir: TEnvirnoment;
begin
  nIdx := Str_ToInt(QuestActionInfo.sParam1, 0);
  if not (nIdx in [1..6]) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_TAGMAPMOVE);
    Exit;
  end;
  if (PlayObject.m_MakerMapInfo[nIdx].sMapName <> '') and (PlayObject.m_MakerMapInfo[nIdx].wMapX > 0) and (PlayObject.m_MakerMapInfo[nIdx].wMapY > 0) then
  begin
    Envir := g_MapManager.FindMap(PlayObject.m_MakerMapInfo[nIdx].sMapName);
    if Envir <> nil then
    begin
      if Envir.CanWalk(PlayObject.m_MakerMapInfo[nIdx].wMapX, PlayObject.m_MakerMapInfo[nIdx].wMapY, True) then
        PlayObject.SpaceMove(PlayObject.m_MakerMapInfo[nIdx].sMapName, PlayObject.m_MakerMapInfo[nIdx].wMapX, PlayObject.m_MakerMapInfo[nIdx].wMapY, 0)
      else
        PlayObject.SysMsg(Format(g_sGameCommandPositionMoveCanotMoveToMap, [PlayObject.m_MakerMapInfo[nIdx].sMapName, PlayObject.m_MakerMapInfo[nIdx].wMapX, PlayObject.m_MakerMapInfo[nIdx].wMapY]), c_Purple, t_Hint);
    end;
  end;
end;

procedure TNormNpc.ActionOfQueryBagItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nIntervalTime: Integer;
begin
  nIntervalTime := Str_ToInt(QuestActionInfo.sParam1, 10);
  if GetTickCount - PlayObject.m_dwQueryBagItemsTick > nIntervalTime * 1000 then
  begin
    PlayObject.m_dwQueryBagItemsTick := GetTickCount;
    PlayObject.ClientQueryBagItems();
  end
  else
    PlayObject.SysMsg(IntToStr(nIntervalTime) + '秒时间内不能连续刷新背包物品...', c_Purple, t_Hint);
end;

procedure TNormNpc.ActionOfSetAttribute(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nAttribute: Integer;
begin
  nAttribute := Str_ToInt(QuestActionInfo.sParam1, 0);
  if not nAttribute in [0..5] then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETATTRIBUTE);
    Exit;
  end;
  PlayObject.m_btAttribute := nAttribute;
  PlayObject.RefShowName();
end;

procedure TNormNpc.ActionOfRecallHero(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
  begin
    if QuestActionInfo.sParam1 = '' then
      PlayObject.SendMsg(PlayObject, CM_RECALLHERO, 0, 0, 0, 0, '')
    else
      PlayObject.SendMsg(PlayObject, CM_UNRECALLHERO, 0, 0, 0, 0, '');
  end;
end;

procedure TNormNpc.ActionOfRecallPlayer(PlayObject: TPlayObject; sCharName: string);
resourcestring
  sIPaddr = '@HERO@';
  sIsHaveHero = '您现在已经带有英雄了，不能再召唤自己的角色！';
  sCharOnline = '当前角色已经在线，你不能召唤！';
  sCanNotRecallSelf = '对不起，您不能召唤自己！';
begin
  try
    if (sCharName = '') then
      Exit;
    if PlayObject.GetHeroObjectA <> nil then
    begin
      PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, sIsHaveHero);
      Exit;
    end;
    if sCharName = PlayObject.m_sCharName then
    begin
      PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, sCanNotRecallSelf);
      Exit;
    end;
    if UserEngine.GetPlayObjectNotGhost(sCharName) <> nil then
    begin
      PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, sCharOnline);
      Exit;
    end;
    if UserEngine.GetHeroObject(sCharName) <> nil then
    begin
      PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, sCharOnline);
      Exit;
    end;
    if (sCharName <> '') then
      FrontEngine.AddToLoadRcdList(PlayObject.m_sUserID,
        sCharName,
        sIPaddr,
        2,
        PlayObject.m_nSessionID,
        PlayObject.m_nPayMent,
        PlayObject.m_nPayMode,
        PlayObject.m_nSoftVersionDate,
        PlayObject.m_nSocket,
        PlayObject.m_nGSocketIdx,
        PlayObject.m_nGateIdx,
        PlayObject.m_sCharName,
        nil);
  except
  end;
end;

procedure TNormNpc.ActionOfClientSetTargetXY(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  if (QuestActionInfo.nParam1 > 0) and (QuestActionInfo.nParam2 > 0) then
    PlayObject.SendDefMessage(SM_SETTARGETXY, QuestActionInfo.nParam1, QuestActionInfo.nParam2, 0, 0, '');
end;

procedure TNormNpc.ActionOfAffiliateGuild(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  g: TGuild;
  p: TPlayObject;
begin
  if QuestActionInfo.sParam1 = '' then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AFFILIATEGUILD);
    Exit;
  end;
  g := g_GuildManager.FindGuild(QuestActionInfo.sParam1);
  if g <> nil then
  begin
    if PlayObject.m_boAllowGuild then
    begin
      if not g.IsMember(PlayObject.m_sCharName) then
      begin
        if (PlayObject.m_MyGuild = nil) then
        begin
          if g.AddMember(PlayObject) then
          begin
            UserEngine.SendInterMsg(ISM_RELOADGUILD, g_nServerIndex, g.sGuildName);
            PlayObject.m_MyGuild := g;
            PlayObject.m_sGuildRankName := g.GetRankName(PlayObject, PlayObject.m_nGuildRankNo);
            PlayObject.RefShowName();
            PlayObject.SysMsg('你已加入行会: ' + g.sGuildName + ' 当前封号为: ' + PlayObject.m_sGuildRankName, c_Green, t_Hint);
            p := UserEngine.GetPlayObject(g.GetChiefName);
            if p <> nil then
            begin
              p.ClientGuildMemberList();
              p.SendDefMessage(SM_GUILDADDMEMBER_OK, 0, 0, 0, 0, '');
            end;
          end
          else
            PlayObject.SysMsg('对不起，' + QuestActionInfo.sParam1 + '行会人数已满。', c_Red, t_Hint);
        end
        else
          PlayObject.SysMsg('你已经加入其他行会，如想加入' + QuestActionInfo.sParam1 + '行会，请先退出原来的行会。', c_Red, t_Hint);
      end
      else
        PlayObject.SysMsg('你已经加入本行会了', c_Red, t_Hint);
    end
    else
      PlayObject.SysMsg('你拒绝加入行会，[允许命令为 @' + g_GameCommand.LETGUILD.sCmd + ']', c_Red, t_Hint);
  end
  else
    PlayObject.SysMsg('行会 ' + QuestActionInfo.sParam1 + ' 不存在', c_Red, t_Hint);
end;

procedure TNormNpc.ActionOfMapMoveHuman(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  ii: Integer;
  List: TList;
  User: TPlayObject;
  Envir, TarEnvir: TEnvirnoment;
begin
  Envir := g_MapManager.FindMap(QuestActionInfo.sParam1);
  TarEnvir := g_MapManager.FindMap(QuestActionInfo.sParam2);
  if (Envir <> nil) and (TarEnvir <> nil) then
  begin
    List := TList.Create;
    UserEngine.GetMapRageHuman(Envir, 0, 0, 1000, List);
    if List.Count > 0 then
    begin
      for ii := 0 to List.Count - 1 do
      begin
        User := TPlayObject(List[ii]);
        User.MapRandomMove(QuestActionInfo.sParam2, 0);
      end;
    end;
    List.Free;
  end
  else
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MAPMOVEHUMAN);
end;

procedure TNormNpc.ActionOfQueryValue(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  btStrLabel, btType, btLen: byte;
  sHint: string;
begin
  btStrLabel := QuestActionInfo.nParam1;
  if not (btStrLabel in [0..99]) then
    btStrLabel := 0;
  PlayObject.m_btValLabel := btStrLabel;
  btType := QuestActionInfo.nParam2;
  if not (btType in [0..2]) then
    btType := 0;
  PlayObject.m_btValType := btType;
  btLen := _MAX(1, QuestActionInfo.nParam3);
  PlayObject.m_sGotoNpcLabel := QuestActionInfo.sParam4;
  sHint := QuestActionInfo.sParam5;
  PlayObject.m_btValNPCType := 0;
  if CompareText(QuestActionInfo.sParam6, 'QF') = 0 then
    PlayObject.m_btValNPCType := 1
  else if CompareText(QuestActionInfo.sParam6, 'QM') = 0 then
    PlayObject.m_btValNPCType := 2;
  if sHint = '' then
    sHint := '请输入：';
  PlayObject.SendDefMessage(SM_QUERYVALUE, 0, MakeWord(btType, btLen), 0, 0, sHint);
end;

procedure TNormNpc.ActionOfReleaseCollectExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  //
end;

procedure TNormNpc.ActionOfReSetCollectExpState(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin
  with PlayObject do
  begin
    m_btCollectExpLv := 0;
    if (m_PEnvir <> nil) {and (m_PEnvir.m_MapFlag.PCollectExp <> nil)} and ((m_PEnvir.m_MapFlag.PCollectExp.nCollectExp > 0) or (m_PEnvir.m_MapFlag.PCollectExp.nCollectIPExp > 0)) then
      m_btCollectExpLv := 1;
    m_dwCollectExp := 0;
    m_dwCollectIpExp := 0;
    SendMsg(PlayObject, RM_COLLECTEXP, 0, 0, 0, 0, '');
    CollectLevelUp(m_btCollectExpLv <> 0, 1);
  end;
end;

procedure TNormNpc.ActionOfGetPoseName(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nValNo: Integer;
  PoseHuman: TBaseObject;
begin
  nValNo := GetValNameNo(QuestActionInfo.sParam1);
  if nValNo >= 0 then
  begin
    PoseHuman := PlayObject.GetPoseCreate();
    if (PoseHuman <> nil) and (PoseHuman.GetPoseCreate = PlayObject) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
    begin
      case nValNo of
        500..599: g_Config.GlobaDyTval[nValNo - 500] := PoseHuman.m_sCharName;
        600..699: PlayObject.m_nSval[nValNo - 600] := PoseHuman.m_sCharName;
      end;
    end;
  end
  else
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GETPOSENAME);
end;

procedure TNormNpc.ActionOfGetStrLength(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nCount, nValNo: Integer;
begin
  nCount := 0;
  if QuestActionInfo.sParam1 <> '' then
    nCount := Length(QuestActionInfo.sParam1);
  nValNo := GetValNameNo(QuestActionInfo.sParam2);
  if nValNo >= 0 then
  begin
    case nValNo of
      000..009: PlayObject.m_nVal[nValNo] := nCount;
      100..199: g_Config.GlobalVal[nValNo - 100] := nCount;
      200..299: PlayObject.m_DyVal[nValNo - 200] := nCount;
      300..399: PlayObject.m_nMval[nValNo - 300] := nCount;
      400..499: g_Config.GlobaDyMval[nValNo - 400] := nCount;
      700..799: g_Config.HGlobalVal[nValNo - 700] := nCount;
    end;
  end;
end;

procedure TNormNpc.ActionOfChangeVenationLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  bIshero: Boolean;
  n, v, p, nChg: Integer;
  cMethod: Char;
begin
  v := QuestActionInfo.nParam1;
  p := QuestActionInfo.nParam3;
  bIshero := PlayObject.IsHero;
  if not v in [0..3] then
  begin
    if bIshero then
      TPlayObject(PlayObject.m_Master).SendDefMessage(SM_TRAINVENATION, -1, v, 0, 1, '')
    else
      PlayObject.SendDefMessage(SM_TRAINVENATION, -1, v, 0, 0, ''); //选择脉络发生错误...
    Exit;
  end;
  if not p in [0..5] then
  begin
    Exit;
  end;

  if p = 0 then
  begin
    PlayObject.m_VenationInfos[v].Point := 0;
    if bIshero then
    begin
      TPlayObject(PlayObject.m_Master).m_DefMsg := MakeDefaultMsg(SM_BREAKPOINT, 0, v, 0, 1);
      TPlayObject(PlayObject.m_Master).SendSocket(@TPlayObject(PlayObject.m_Master).m_DefMsg, EncodeBuffer(@PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos)));
    end
    else
    begin
      PlayObject.m_DefMsg := MakeDefaultMsg(SM_BREAKPOINT, 0, v, 0, byte(PlayObject.IsHero));
      PlayObject.SendSocket(@PlayObject.m_DefMsg, EncodeBuffer(@PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos)));
    end;
    PlayObject.RecalcAbilitys();
    PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
    PlayObject.SendMsg(PlayObject, RM_SUBABILITY, 0, 0, 0, 0, '');
    PlayObject.SendRefMsg(RM_STRUCKEFFECTEX, 0, 18, 0, 0, '');
  end
  else if PlayObject.m_VenationInfos[v].Point <> 5 then
  begin
    PlayObject.m_VenationInfos[v].Point := 5;
    if bIshero then
    begin
      TPlayObject(PlayObject.m_Master).m_DefMsg := MakeDefaultMsg(SM_BREAKPOINT, 0, v, 5, 1);
      TPlayObject(PlayObject.m_Master).SendSocket(@TPlayObject(PlayObject.m_Master).m_DefMsg, EncodeBuffer(@PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos)));
    end
    else
    begin
      PlayObject.m_DefMsg := MakeDefaultMsg(SM_BREAKPOINT, 0, v, 5, byte(PlayObject.IsHero));
      PlayObject.SendSocket(@PlayObject.m_DefMsg, EncodeBuffer(@PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos)));
    end;

    PlayObject.RecalcAbilitys();
    PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
    PlayObject.SendMsg(PlayObject, RM_SUBABILITY, 0, 0, 0, 0, '');
    PlayObject.SendRefMsg(RM_STRUCKEFFECTEX, 0, 18, 0, 0, '');
  end;

  nChg := PlayObject.m_VenationInfos[v].Level;
  cMethod := QuestActionInfo.sParam2[1];
  case cMethod of
    '=':
      begin
        PlayObject.m_VenationInfos[v].Level := _MIN(5, p);
      end;
    '-':
      begin
        if PlayObject.m_VenationInfos[v].Level > p then
        begin
          Dec(PlayObject.m_VenationInfos[v].Level, p);
        end
        else
          PlayObject.m_VenationInfos[v].Level := 0;
      end;
    '+':
      begin
        PlayObject.m_VenationInfos[v].Level := _MIN(5, PlayObject.m_VenationInfos[v].Level + p);
      end;
  else
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_ChangeVenationLevel);
  end;

  if nChg <> PlayObject.m_VenationInfos[v].Level then
  begin
    if bIshero then
    begin
      TPlayObject(PlayObject.m_Master).m_DefMsg := MakeDefaultMsg(SM_BREAKPOINT, 0, v, PlayObject.m_VenationInfos[v].Level, 1);
      TPlayObject(PlayObject.m_Master).SendSocket(@TPlayObject(PlayObject.m_Master).m_DefMsg, EncodeBuffer(@PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos)));
    end
    else
    begin
      PlayObject.m_DefMsg := MakeDefaultMsg(SM_TRAINVENATION, 0, v, PlayObject.m_VenationInfos[v].Level, 0);
      PlayObject.SendSocket(@PlayObject.m_DefMsg, EncodeBuffer(@PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos)));
    end;

    if PlayObject.m_VenationInfos[v].Level = 2 then
    begin
      PlayObject.AddSkillByName(g_JobofSeriesSkill[PlayObject.m_btJob][v], 0);
      //PlayObject.SysMsg(Format('恭喜你通过不懈的努力,将%s升级为一重,习得连击招式:%s', [g_VaStrs[v], g_JobofSeriesSkill[m_btJob][v]]), c_Green, t_Hint);
    end
    else
    begin
      //PlayObject.SysMsg(Format('恭喜你将%s升级为%s重,提升%s的暴击率和暴击威力', [g_VaStrs[v], g_VLevelStr[PlayObject.m_VenationInfos[v].Level - 1], g_JobofSeriesSkill[PlayObject.m_btJob][v]]), c_Green, t_Hint);
    end;
    PlayObject.RecalcAbilitys();
    case PlayObject.m_btJob of
      0: case v of
          0: n := 101;
          1: n := 100;
          2: n := 102;
          3: n := 103;
        end;
      1: case v of
          0: n := 107;
          1: n := 104;
          2: n := 105;
          3: n := 106;
        end;
      2: case v of
          0: n := 108;
          1: n := 109;
          2: n := 110;
          3: n := 111;
        end;
    end;
    if PlayObject.m_MagicArr[0][n] <> nil then
      PlayObject.SendMsg(PlayObject,
        RM_MAGIC_MAXLV,
        PlayObject.m_MagicArr[0][n].MagicInfo.btClass,
        PlayObject.m_MagicArr[0][n].MagicInfo.wMagicId,
        PlayObject.MagicMaxTrainLevel(PlayObject.m_MagicArr[0][n]), 0, ''); //0929

    PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
    PlayObject.SendMsg(PlayObject, RM_SUBABILITY, 0, 0, 0, 0, '');
    PlayObject.SendRefMsg(RM_STRUCKEFFECTEX, 0, 18, 0, 0, '');

  end;
end;

function TNormNpc.ConditionOfCheckVenationLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  v, p, nLv: Integer;
  cMethod: Char;
begin
  Result := False;
  v := QuestConditionInfo.nParam1;
  p := QuestConditionInfo.nParam3;

  if not v in [0..3] then
    Exit;
  if not p in [0..5] then
    Exit;

  nLv := PlayObject.m_VenationInfos[v].Level;
  cMethod := QuestConditionInfo.sParam2[1];
  case cMethod of
    '=': if nLv = p then
        Result := True;
    '>': if nLv > p then
        Result := True;
    '<': if nLv < p then
        Result := True;
  else if nLv >= p then
    Result := True;
  end;
end;

procedure TNormNpc.ActionOfClearVenationData(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  bIshero: Boolean;
begin
  bIshero := PlayObject.IsHero;
  FillChar(PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos), 0);
  FillChar(PlayObject.m_SeriesSkillArr, SizeOf(PlayObject.m_SeriesSkillArr), 0);
  PlayObject.SendMsg(PlayObject, RM_SERIESSKILLARR, 0, 0, 0, 0, '');
  if bIshero then
  begin
    TPlayObject(PlayObject.m_Master).m_DefMsg := MakeDefaultMsg(SM_TRAINVENATION, 0, 0, 0, 1);
    TPlayObject(PlayObject.m_Master).SendSocket(@TPlayObject(PlayObject.m_Master).m_DefMsg, EncodeBuffer(@PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos)));
  end
  else
  begin
    PlayObject.m_DefMsg := MakeDefaultMsg(SM_TRAINVENATION, 0, 0, 0, 0);
    PlayObject.SendSocket(@PlayObject.m_DefMsg, EncodeBuffer(@PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos)));
  end;

  PlayObject.RecalcAbilitys();
  PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
  PlayObject.SendMsg(PlayObject, RM_SUBABILITY, 0, 0, 0, 0, '');
end;

procedure TNormNpc.ActionOfChangeVenationPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  bIshero: Boolean;
  v, p: Integer;
begin
  v := QuestActionInfo.nParam1;
  p := QuestActionInfo.nParam2;
  bIshero := PlayObject.IsHero;
  if not (v in [0..3]) then
  begin
    if bIshero then
      TPlayObject(PlayObject.m_Master).SendDefMessage(SM_BREAKPOINT, -1, v, p, 1, '')
    else
      PlayObject.SendDefMessage(SM_BREAKPOINT, -1, v, p, 0, ''); //选择脉络发生错误...
    Exit;
  end;
  if not (p in [1..5]) then
  begin
    if bIshero then
      TPlayObject(PlayObject.m_Master).SendDefMessage(SM_BREAKPOINT, -2, v, p, 1, '')
    else
      PlayObject.SendDefMessage(SM_BREAKPOINT, -2, v, p, 0, ''); //选择穴位发生错误...
    Exit;
  end;
  if PlayObject.m_VenationInfos[v].Point < p then
  begin
    if p - PlayObject.m_VenationInfos[v].Point = 1 then
    begin

      Inc(PlayObject.m_VenationInfos[v].Point);
      if PlayObject.m_VenationInfos[v].Point = 5 then
      begin
        PlayObject.m_VenationInfos[v].Level := 1;
        PlayObject.SysMsg(Format('恭喜你打通了%s,修为更进一步', [g_VaStrs[v]]), c_Green, t_Hint);
      end;
      if bIshero then
      begin
        TPlayObject(PlayObject.m_Master).m_DefMsg := MakeDefaultMsg(SM_BREAKPOINT, 0, v, p, 1);
        TPlayObject(PlayObject.m_Master).SendSocket(@TPlayObject(PlayObject.m_Master).m_DefMsg, EncodeBuffer(@PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos)));
      end
      else
      begin
        PlayObject.m_DefMsg := MakeDefaultMsg(SM_BREAKPOINT, 0, v, p, 0);
        PlayObject.SendSocket(@PlayObject.m_DefMsg, EncodeBuffer(@PlayObject.m_VenationInfos, SizeOf(PlayObject.m_VenationInfos)));
      end;
      PlayObject.SysMsg(Format('恭喜你冲破了%s上的%s穴,获得防御属性提升,修为更进一步', [g_VaStrs[v], g_VPStrs[v, p]]), c_Green, t_Hint);
      //UserEngine.SendBroadCastMsg(Format('恭喜:%s在舒经活络丸的作用下,冲破了%s上的%s穴,获得防御属性提升,修为更进一步', [PlayObject.m_sCharName, g_VaStrs[v], g_VPStrs[v, p]]), t_System);
      PlayObject.RecalcAbilitys();
      PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
      PlayObject.SendMsg(PlayObject, RM_SUBABILITY, 0, 0, 0, 0, '');
      PlayObject.SendRefMsg(RM_STRUCKEFFECTEX, 0, 18, 0, 0, '');
    end
    else
    begin
      if PlayObject.IsHero then
        TPlayObject(PlayObject.m_Master).SendDefMessage(SM_BREAKPOINT, -5, v, p, 1, '')
      else
        PlayObject.SendDefMessage(SM_BREAKPOINT, -5, v, p, 0, ''); //此穴位目前不可打通...
    end;
  end
  else
  begin
    if PlayObject.IsHero then
      TPlayObject(PlayObject.m_Master).SendDefMessage(SM_BREAKPOINT, -4, v, p, 1, '')
    else
      PlayObject.SendDefMessage(SM_BREAKPOINT, -4, v, p, 0, ''); //此穴位已经打通
  end;
end;

procedure TNormNpc.ActionOfConvertSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i, n: Integer;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  tempUserMagic: TUserMagic;
  s, d: string;
begin
  s := QuestActionInfo.sParam1;
  d := QuestActionInfo.sParam2;
  n := -1;
  for i := 0 to PlayObject.m_MagicList.Count - 1 do
  begin
    if (pTUserMagic(PlayObject.m_MagicList.Items[i]).MagicInfo.sMagicName = s) then
    begin
      n := i;
      Break;
    end;
  end;
  if n < 0 then
    Exit;
  Magic := UserEngine.FindMagic(d);
  if Magic <> nil then
  begin
    if not PlayObject.IsTrainingSkill(Magic.wMagicId, Magic.btClass) then
    begin
      UserMagic := pTUserMagic(PlayObject.m_MagicList.Items[n]);
      tempUserMagic := UserMagic^;
      UserMagic.MagicInfo := Magic;
      UserMagic.wMagIdx := Magic.wMagicId;
      PlayObject.SendConvertMagic(tempUserMagic.MagicInfo.btClass, Magic.btClass, tempUserMagic.wMagIdx, Magic.wMagicId, UserMagic);
      FillChar(PlayObject.m_SeriesSkillArr, SizeOf(PlayObject.m_SeriesSkillArr), 0);
      PlayObject.SendMsg(PlayObject, RM_SERIESSKILLARR, 0, 0, 0, 0, '');
      PlayObject.RecalcAbilitys();
    end
    else
    begin
      for i := PlayObject.m_MagicList.Count - 1 downto 0 do
      begin
        UserMagic := PlayObject.m_MagicList[i];
        if (UserMagic.MagicInfo = Magic) then
        begin
          PlayObject.SendDelMagic(UserMagic);
          Dispose(UserMagic);
          PlayObject.m_MagicList.Delete(i);
          PlayObject.RecalcAbilitys();
          Break;
        end;
      end;

      UserMagic := pTUserMagic(PlayObject.m_MagicList.Items[n]);
      tempUserMagic := UserMagic^;
      UserMagic.MagicInfo := Magic;
      UserMagic.wMagIdx := Magic.wMagicId;

      PlayObject.SendConvertMagic(tempUserMagic.MagicInfo.btClass, Magic.btClass, tempUserMagic.wMagIdx, Magic.wMagicId, UserMagic);
      FillChar(PlayObject.m_SeriesSkillArr, SizeOf(PlayObject.m_SeriesSkillArr), 0);
      PlayObject.SendMsg(PlayObject, RM_SERIESSKILLARR, 0, 0, 0, 0, '');
      PlayObject.RecalcAbilitys();
    end;
  end;
end;

procedure TNormNpc.ActionOfQueryItemDlg(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sHint: string;
begin
  PlayObject.m_boTakeDlgItem := QuestActionInfo.nParam3 <> 0;
  PlayObject.m_sGotoNpcLabel := QuestActionInfo.sParam2;
  sHint := QuestActionInfo.sParam1;
  if sHint = '' then
    sHint := '请输入:';
  PlayObject.SendDefMessage(SM_QUERYITEMDLG, Integer(Self), 0, 0, 0, sHint);
end;

procedure TNormNpc.ActionOfGetDlgItemValue(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
//GETBOXITEMVALUE变量（赋予到变量M0~99） 属性位置(0-14)
var
  i, nValNo: Integer;
  nValType: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  nValType := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nValType < 0) or (nValType > 30) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GETDLGITEMVALUE);
    Exit;
  end;
  nValNo := GetValNameNo(QuestActionInfo.sParam1);
  if (nValNo >= 300) and (nValNo <= 399) then
  begin
    if (PlayObject.m_nDlgItemIndex = 0) then
      Exit;
    for i := 0 to PlayObject.m_ItemList.Count - 1 do
    begin
      UserItem := PlayObject.m_ItemList.Items[i];
      if (UserItem.MakeIndex = PlayObject.m_nDlgItemIndex) then
      begin
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if StdItem <> nil then
        begin
          if not (StdItem.StdMode in [5..7, 10..13, 15..30, 51, 61]) then
            PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '对不起，当前物品不允许升级！')
          else
          begin
            if nValType > 13 then
            begin
              if nValType = 14 then
                PlayObject.m_nMval[nValNo - 300] := UserItem.Dura div 1000
              else if nValType = 15 then
                PlayObject.m_nMval[nValNo - 300] := UserItem.DuraMax div 1000
              else if nValType = 16 then
                PlayObject.m_nMval[nValNo - 300] := UserItem.btValue[14]
              else if nValType = 17 then
                PlayObject.m_nMval[nValNo - 300] := UserItem.btValue[15] div 16
              else if nValType = 18 then
                PlayObject.m_nMval[nValNo - 300] := UserItem.btValue[15] mod 16
              else if nValType = 19 then
                PlayObject.m_nMval[nValNo - 300] := UserItem.btValue[16] div 16
              else if nValType = 20 then
                PlayObject.m_nMval[nValNo - 300] := UserItem.btValue[16] mod 16
              else if nValType = 21 then
                PlayObject.m_nMval[nValNo - 300] := UserItem.btValue[17] div 16
              else if nValType = 22 then
                PlayObject.m_nMval[nValNo - 300] := UserItem.btValue[17] mod 16
              else
                PlayObject.m_nMval[nValNo - 300] := UserItem.btValue[nValType - 5];
            end
            else
              PlayObject.m_nMval[nValNo - 300] := UserItem.btValue[nValType];
          end;
        end;
        Break;
      end;
    end;
  end;
end;

function TNormNpc.ActionOfDeleteDlgItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo): Boolean;
var
  i: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  if (PlayObject.m_nDlgItemIndex = 0) then
    Exit;
  for i := PlayObject.m_ItemList.Count - 1 downto 0 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem.MakeIndex = PlayObject.m_nDlgItemIndex then
    begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then
      begin
        if (StdItem.Overlap >= 1) then
        begin
          if UserItem.Dura >= 1 then
          begin
            UserItem.Dura := UserItem.Dura - 1;
            if UserItem.Dura <= 0 then
            begin
              if StdItem.NeedIdentify = 1 then
                AddGameDataLogAPI('10' + #9 +
                  PlayObject.m_sMapName + #9 +
                  IntToStr(PlayObject.m_nCurrX) + #9 +
                  IntToStr(PlayObject.m_nCurrY) + #9 +
                  PlayObject.m_sCharName + #9 +
                  StdItem.Name + #9 +
                  IntToStr(UserItem.MakeIndex) + #9 +
                  IntToStr(1) + #9 +
                  m_sCharName);
              PlayObject.SendDelItems(UserItem);
              Dispose(UserItem);
              PlayObject.m_ItemList.Delete(i);
              PlayObject.SendDefMessage(SM_ITEMDLGSELECT, 1, 255, 0, 0, '');
            end
            else
            begin
              PlayObject.SendMsg(Self, RM_COUNTERITEMCHANGE, 0, UserItem.MakeIndex, UserItem.Dura, 0, StdItem.Name);
              PlayObject.SendDefMessage(SM_ITEMDLGSELECT, 1, 0, 0, 0, '');
            end;
          end
          else
          begin
            if StdItem.NeedIdentify = 1 then
              AddGameDataLogAPI('10' + #9 +
                PlayObject.m_sMapName + #9 +
                IntToStr(PlayObject.m_nCurrX) + #9 +
                IntToStr(PlayObject.m_nCurrY) + #9 +
                PlayObject.m_sCharName + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                IntToStr(1) + #9 +
                m_sCharName);
            PlayObject.SendDelItems(UserItem);
            Dispose(UserItem);
            PlayObject.m_ItemList.Delete(i);
            PlayObject.SendDefMessage(SM_ITEMDLGSELECT, 1, 255, 0, 0, '');
          end;

        end
        else
        begin
          if StdItem.NeedIdentify = 1 then
            AddGameDataLogAPI('10' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              StdItem.Name + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
          PlayObject.SendDelItems(UserItem);
          Dispose(UserItem);
          PlayObject.m_ItemList.Delete(i);
          PlayObject.SendDefMessage(SM_ITEMDLGSELECT, 1, 255, 0, 0, '');
        end;
      end;
      Break;
    end;
  end;
end;

procedure TNormNpc.ActionOfWriteLineList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  LoadList: TStringList;
  sListFileName: string;
begin
  sListFileName := g_Config.sEnvirDir + QuestActionInfo.sParam1;
  if not FileExists(sListFileName) then
    sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;

  LoadList := TStringList.Create;
  if FileExists(sListFileName) then
    LoadList.LoadFromFile(sListFileName);
  if LoadList.IndexOf(QuestActionInfo.sParam2) < 0 then
  begin
    LoadList.Add(QuestActionInfo.sParam2);
    LoadList.SaveToFile(sListFileName);
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfDeleteLineList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  LoadList: TStringList;
  sListFileName: string;
begin
  sListFileName := g_Config.sEnvirDir + QuestActionInfo.sParam1;
  if not FileExists(sListFileName) then
    sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  LoadList := TStringList.Create;
  if FileExists(sListFileName) then
    LoadList.LoadFromFile(sListFileName);
  i := LoadList.IndexOf(QuestActionInfo.sParam2);
  if i >= 0 then
  begin
    LoadList.Delete(i);
    LoadList.SaveToFile(sListFileName);
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfUpgradeDlgItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
//UPGRADEBOXITEM 属性位置(0-14) 成功机率(0-100) 点数机率(0-255) 是否破碎(0,1)
var
  i: Integer;
  nRate, nValType, nPoint, nAddPoint: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  nUpgradeItemStatus: Integer;
begin
  nValType := Str_ToInt(QuestActionInfo.sParam1, -1);
  nRate := Str_ToInt(QuestActionInfo.sParam2, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam3, -1);
  nUpgradeItemStatus := Str_ToInt(QuestActionInfo.sParam4, -1);
  if (nValType < 0) or (nValType > 30) or not (nRate in [0..100]) or (nPoint < 0) or (nPoint > 255) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_UPGRADEDLGITEM);
    Exit;
  end;
  Dec(nRate);
  if (PlayObject.m_nDlgItemIndex = 0) then
    Exit;
  for i := 0 to PlayObject.m_ItemList.Count - 1 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    if (UserItem.MakeIndex = PlayObject.m_nDlgItemIndex) then
    begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem = nil then
      begin
        PlayObject.SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '请放上你要升级的装备');
        Exit;
      end;
      if not (StdItem.StdMode in [5..7, 10..13, 15..30, 51, 61]) then
      begin
        PlayObject.SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '对不起，当前物品不允许升级');
        Exit;
      end;
      //nRatePoint := Random((nRate + UserItem.btValue[nValType]));
      if nRate >= Random(100) then
      begin
        nPoint := _MAX(1, Random(nPoint));
        if nValType = 14 then
        begin
          nAddPoint := (nPoint * 1000);
          if UserItem.Dura + nAddPoint > High(Word) then
            nAddPoint := High(Word) - UserItem.Dura;
          UserItem.Dura := UserItem.Dura + nAddPoint;
        end
        else if nValType = 15 then
        begin
          nAddPoint := (nPoint * 1000);
          if UserItem.DuraMax + nAddPoint > High(Word) then
            nAddPoint := High(Word) - UserItem.DuraMax;
          UserItem.DuraMax := UserItem.DuraMax + nAddPoint;
        end
        else
        begin
          nAddPoint := nPoint;
          if nValType >= 16 then
          begin
            if nValType = 16 then
            begin
              UserItem.btValue[14] := nAddPoint;
            end
            else if nValType = 17 then
            begin
              UserItem.btValue[15] := _MIN(15, UserItem.btValue[15] div 16 + nAddPoint) * 16 + UserItem.btValue[15] mod 16;
            end
            else if nValType = 18 then
            begin
              UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, UserItem.btValue[15] mod 16 + nAddPoint);
            end
            else if nValType = 19 then
            begin
              UserItem.btValue[16] := _MIN(15, UserItem.btValue[16] div 16 + nAddPoint) * 16 + UserItem.btValue[16] mod 16;
            end
            else if nValType = 20 then
            begin
              UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, UserItem.btValue[16] mod 16 + nAddPoint);
            end
            else if nValType = 21 then
            begin
              UserItem.btValue[17] := _MIN(15, UserItem.btValue[17] div 16 + nAddPoint) * 16 + UserItem.btValue[17] mod 16;
            end
            else if nValType = 22 then
            begin
              UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, UserItem.btValue[17] mod 16 + nAddPoint);
            end
            else
            begin
              if UserItem.btValue[nValType - 5] + nAddPoint > High(byte) then
                nAddPoint := High(byte) - UserItem.btValue[nValType - 5];
              UserItem.btValue[nValType - 5] := UserItem.btValue[nValType - 5] + nAddPoint;
            end;
          end
          else
          begin
            if UserItem.btValue[nValType] + nAddPoint > High(byte) then
              nAddPoint := High(byte) - UserItem.btValue[nValType];
            UserItem.btValue[nValType] := UserItem.btValue[nValType] + nAddPoint;
          end;
        end;
        PlayObject.SendUpdateItem(UserItem);
        if QuestActionInfo.sParam5 = '' then
          PlayObject.SysMsg('你的 ' + StdItem.Name + ' 升级成功', c_Purple, t_Hint);
      end
      else
      begin
        case nUpgradeItemStatus of
          0: if QuestActionInfo.sParam5 = '' then
              PlayObject.SysMsg('升级未成功', c_Red, t_Hint);
          1:
            begin
              if StdItem.NeedIdentify = 1 then
                AddGameDataLogAPI('21' + #9 + PlayObject.m_sMapName + #9 + IntToStr(PlayObject.m_nCurrX) + #9 + IntToStr(PlayObject.m_nCurrY) + #9 + PlayObject.m_sCharName + #9 + StdItem.Name + #9 + IntToStr(UserItem.MakeIndex) + #9 + '1' + #9 + '0');
              PlayObject.SendDelItems(UserItem);
              Dispose(UserItem); //0413
              PlayObject.m_ItemList.Delete(i);
              PlayObject.WeightChanged();
              //PlayObject.m_dwSaveRcdTick := 0; //0408_1
              PlayObject.SendDefMessage(SM_ITEMDLGSELECT, 1, 255, 0, 0, '');
              PlayObject.SendDefMessage(SM_BREAKWEAPON, Integer(PlayObject), 0, 0, 0, '');
              if QuestActionInfo.sParam5 = '' then
                PlayObject.SysMsg('升级失败,装备已破碎', c_Red, t_Hint);
            end;
          2:
            begin
              if QuestActionInfo.sParam5 = '' then
                PlayObject.SysMsg('升级失败,装备属性恢复默认', c_Red, t_Hint);
              if nValType >= 16 then
              begin
                if nValType = 16 then
                  UserItem.btValue[14] := 0
                else if nValType = 17 then
                  UserItem.btValue[15] := UserItem.btValue[15] mod 16
                else if nValType = 18 then
                  UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16
                else if nValType = 19 then
                  UserItem.btValue[16] := UserItem.btValue[16] mod 16
                else if nValType = 20 then
                  UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16
                else if nValType = 21 then
                  UserItem.btValue[17] := UserItem.btValue[17] mod 16
                else if nValType = 22 then
                  UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16;
              end
              else
              begin
                UserItem.btValue[nValType] := 0;
                PlayObject.SendUpdateItem(UserItem);
              end;
            end;
        end;
      end;
      Break;
    end;
  end;
end;

function TNormNpc.ConditionOfGiveItem(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  sItemName, sItemCount: string;
  nItemCount: Integer;
begin
  Result := False;
  sItemName := QuestConditionInfo.sParam1;
  sItemCount := QuestConditionInfo.sParam2;
  nItemCount := Str_ToInt(sItemCount, 1);
  if (sItemName = '') or (nItemCount <= 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_GIVEOK);
    Exit;
  end;

  if CompareText(sItemName, sSTRING_GOLDNAME) = 0 then
  begin
    PlayObject.IncGold(nItemCount);
    PlayObject.GoldChanged();
    if g_boGameLogGold then
      AddGameDataLogAPI('9' + #9 +
        PlayObject.m_sMapName + #9 +
        IntToStr(PlayObject.m_nCurrX) + #9 +
        IntToStr(PlayObject.m_nCurrY) + #9 +
        PlayObject.m_sCharName + #9 +
        sSTRING_GOLDNAME + #9 +
        IntToStr(nItemCount) + #9 +
        '1' + #9 +
        m_sCharName);
    Result := True;
    Exit;
  end;

  if UserEngine.GetStdItemIdx(sItemName) > 0 then
  begin
    if not (nItemCount in [1..50]) then
      nItemCount := 1;

    for i := 0 to nItemCount - 1 do
    begin
      if PlayObject.IsEnoughBag then
      begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
        begin
          PlayObject.m_ItemList.Add((UserItem));
          PlayObject.SendAddItem(UserItem);
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem.NeedIdentify = 1 then
            AddGameDataLogAPI('9' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              sItemName + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
          Result := True;
        end
        else
          Dispose(UserItem);
      end
      else
      begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
        begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem.NeedIdentify = 1 then
            AddGameDataLogAPI('9' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              sItemName + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
          if PlayObject.DropItemDown(UserItem, 3, False, PlayObject, nil) then
            Result := True;
        end;
        Dispose(UserItem);
      end;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckMapNimbusCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount: Integer;
  Envir: TEnvirnoment;
  cMethod: Char;
  sMAP: string;
begin
  Result := False;
  Envir := nil;
  sMAP := QuestConditionInfo.sParam1;
  nCount := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if sMAP <> '' then
    Envir := g_MapManager.FindMap(sMAP);
  if (nCount <= 0) or (Envir = nil) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CheckMapNimbusCount);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam2[1];
  case cMethod of
    '=': if Envir.NimbusCount = nCount then
        Result := True;
    '>': if Envir.NimbusCount > nCount then
        Result := True;
    '<': if Envir.NimbusCount < nCount then
        Result := True;
  else if Envir.NimbusCount >= nCount then
    Result := True;
  end;
end;

procedure TNormNpc.ActionOfKillSlaveName(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sSlaveName: string;
  BaseObject: TBaseObject;
begin
  sSlaveName := QuestActionInfo.sParam1;
  if sSlaveName = '' then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_KILLSLAVENAME);
    Exit;
  end;
  for i := 0 to PlayObject.m_SlaveList.Count - 1 do
  begin
    BaseObject := TBaseObject(PlayObject.m_SlaveList.Items[i]);
    if not BaseObject.m_boDeath and (CompareText(sSlaveName, BaseObject.m_sCharName) = 0) then
    begin
      BaseObject.m_WAbil.HP := 0;
      //Break;
    end;
  end;
end;

//CreateMapNimbus map(地图) rate(密集度1~255) time(秒)

procedure TNormNpc.ActionOfCreateMapNimbus(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  nW, nH: Integer;
  NimbusEvent: TNimbusEvent;

  nRate, nTime: Integer;
  Envir: TEnvirnoment;
  sMAP: string;
begin
  Envir := nil;
  sMAP := QuestActionInfo.sParam1;
  nRate := Str_ToInt(QuestActionInfo.sParam2, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam3, -1);
  if sMAP <> '' then
    Envir := g_MapManager.FindMap(sMAP);
  if not (nRate in [1..255]) or (Envir = nil) or (nTime <= 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CreateMapNimbus);
    Exit;
  end;

  //nRate := 256 - nRate;
  Randomize();
  if Envir.NimbusCount <= 0 then
  begin
    for nW := 0 to Envir.m_MapHeader.wWidth - 1 do
    begin
      for nH := 0 to Envir.m_MapHeader.wHeight - 1 do
      begin
        if Random(nRate) = 0 then
        begin
          if Envir.CanWalk(nW, nH, True) then
          begin

            NimbusEvent := TNimbusEvent.Create(Envir, nW, nH, ET_NIMBUS_1 + Random(3), nTime);
            g_EventManager.AddEvent(NimbusEvent);

          end;
        end;

      end;
    end;
  end;
end;

function TNormNpc.ConditionOfUnSealItem(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  UserItem: pTUserItem;
  pStdItem: pTStdItem;
begin
  Result := False;
  for i := 0 to PlayObject.m_ItemList.Count - 1 do
  begin
    UserItem := PlayObject.m_ItemList[i];
    pStdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (pStdItem <> nil) and (pStdItem.StdMode = 2) and (pStdItem.Shape = 12) and (UserItem.btValue[0] = 0) and (UserItem.Dura = UserItem.DuraMax) then
    begin
      UserItem.btValue[0] := 1;
      PlayObject.SendUpdateItem(UserItem);
      Result := True;
      Break;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckAttackMode(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if not (nCount in [0..6]) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CheckAttackMode);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btAttatckMode = nCount then
        Result := True;
    '>': if PlayObject.m_btAttatckMode > nCount then
        Result := True;
    '<': if PlayObject.m_btAttatckMode < nCount then
        Result := True;
  else if PlayObject.m_btAttatckMode >= nCount then
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckNimbusItemCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i, n, nCount: Integer;
  isUnWrap: Integer;
  UserItem: pTUserItem;
  pStdItem: pTStdItem;
  cMethod: Char;
  sItemName: string;
begin
  Result := False;
  sItemName := QuestConditionInfo.sParam1;
  isUnWrap := QuestConditionInfo.nParam2;
  nCount := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (nCount < 0) or (sItemName = '') then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNIMBUSITEMCOUNT);
    Exit;
  end;
  n := 0;
  for i := 0 to PlayObject.m_ItemList.Count - 1 do
  begin
    UserItem := PlayObject.m_ItemList[i];
    pStdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (pStdItem <> nil) and
      (pStdItem.StdMode = 2) and
      (pStdItem.Shape = 12) and
      (UserItem.btValue[0] = isUnWrap) and
      (UserItem.Dura = UserItem.DuraMax) and
      (CompareText(sItemName, pStdItem.Name) = 0) then
    begin
      Inc(n);
    end;
  end;
  cMethod := QuestConditionInfo.sParam3[1];
  case cMethod of
    '=': if n = nCount then
        Result := True;
    '>': if n > nCount then
        Result := True;
    '<': if n < nCount then
        Result := True;
  else if n >= nCount then
    Result := True;
  end;
end;

end.
