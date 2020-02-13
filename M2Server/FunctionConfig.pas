unit FunctionConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin, Grids, Grobal2, ExtCtrls, TLHelp32;

type
  TfrmFunctionConfig = class(TForm)
    FunctionConfigControl: TPageControl;
    Label14: TLabel;
    MonSaySheet: TTabSheet;
    TabSheet1: TTabSheet;
    PasswordSheet: TTabSheet;
    GroupBox1: TGroupBox;
    CheckBoxEnablePasswordLock: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBoxLockGetBackItem: TCheckBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    EditErrorPasswordCount: TSpinEdit;
    CheckBoxErrorCountKick: TCheckBox;
    ButtonPasswordLockSave: TButton;
    GroupBox4: TGroupBox;
    CheckBoxLockWalk: TCheckBox;
    CheckBoxLockRun: TCheckBox;
    CheckBoxLockHit: TCheckBox;
    CheckBoxLockSpell: TCheckBox;
    CheckBoxLockSendMsg: TCheckBox;
    CheckBoxLockInObMode: TCheckBox;
    CheckBoxLockLogin: TCheckBox;
    CheckBoxLockUseItem: TCheckBox;
    CheckBoxLockDropItem: TCheckBox;
    CheckBoxLockDealItem: TCheckBox;
    TabSheetGeneral: TTabSheet;
    GroupBox7: TGroupBox;
    CheckBoxHungerSystem: TCheckBox;
    ButtonGeneralSave: TButton;
    GroupBoxHunger: TGroupBox;
    CheckBoxHungerDecPower: TCheckBox;
    CheckBoxHungerDecHP: TCheckBox;
    TabSheet33: TTabSheet;
    TabSheet34: TTabSheet;
    TabSheet35: TTabSheet;
    GroupBox8: TGroupBox;
    Label13: TLabel;
    EditUpgradeWeaponMaxPoint: TSpinEdit;
    Label15: TLabel;
    EditUpgradeWeaponPrice: TSpinEdit;
    Label16: TLabel;
    EditUPgradeWeaponGetBackTime: TSpinEdit;
    Label17: TLabel;
    EditClearExpireUpgradeWeaponDays: TSpinEdit;
    Label18: TLabel;
    Label19: TLabel;
    GroupBox18: TGroupBox;
    ScrollBarUpgradeWeaponDCRate: TScrollBar;
    Label20: TLabel;
    EditUpgradeWeaponDCRate: TEdit;
    Label21: TLabel;
    ScrollBarUpgradeWeaponDCTwoPointRate: TScrollBar;
    EditUpgradeWeaponDCTwoPointRate: TEdit;
    Label22: TLabel;
    ScrollBarUpgradeWeaponDCThreePointRate: TScrollBar;
    EditUpgradeWeaponDCThreePointRate: TEdit;
    GroupBox19: TGroupBox;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    ScrollBarUpgradeWeaponSCRate: TScrollBar;
    EditUpgradeWeaponSCRate: TEdit;
    ScrollBarUpgradeWeaponSCTwoPointRate: TScrollBar;
    EditUpgradeWeaponSCTwoPointRate: TEdit;
    ScrollBarUpgradeWeaponSCThreePointRate: TScrollBar;
    EditUpgradeWeaponSCThreePointRate: TEdit;
    GroupBox20: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    ScrollBarUpgradeWeaponMCRate: TScrollBar;
    EditUpgradeWeaponMCRate: TEdit;
    ScrollBarUpgradeWeaponMCTwoPointRate: TScrollBar;
    EditUpgradeWeaponMCTwoPointRate: TEdit;
    ScrollBarUpgradeWeaponMCThreePointRate: TScrollBar;
    EditUpgradeWeaponMCThreePointRate: TEdit;
    ButtonUpgradeWeaponSave: TButton;
    GroupBox21: TGroupBox;
    ButtonMasterSave: TButton;
    GroupBox22: TGroupBox;
    EditMasterOKLevel: TSpinEdit;
    Label29: TLabel;
    GroupBox23: TGroupBox;
    EditMasterOKCreditPoint: TSpinEdit;
    Label30: TLabel;
    EditMasterOKBonusPoint: TSpinEdit;
    Label31: TLabel;
    GroupBox24: TGroupBox;
    ScrollBarMakeMineHitRate: TScrollBar;
    EditMakeMineHitRate: TEdit;
    Label32: TLabel;
    Label33: TLabel;
    ScrollBarMakeMineRate: TScrollBar;
    EditMakeMineRate: TEdit;
    GroupBox25: TGroupBox;
    Label34: TLabel;
    Label35: TLabel;
    ScrollBarStoneTypeRate: TScrollBar;
    EditStoneTypeRate: TEdit;
    ScrollBarGoldStoneMax: TScrollBar;
    EditGoldStoneMax: TEdit;
    Label36: TLabel;
    ScrollBarSilverStoneMax: TScrollBar;
    EditSilverStoneMax: TEdit;
    Label37: TLabel;
    ScrollBarSteelStoneMax: TScrollBar;
    EditSteelStoneMax: TEdit;
    Label38: TLabel;
    EditBlackStoneMax: TEdit;
    ScrollBarBlackStoneMax: TScrollBar;
    ButtonMakeMineSave: TButton;
    GroupBox26: TGroupBox;
    Label39: TLabel;
    EditStoneMinDura: TSpinEdit;
    Label40: TLabel;
    EditStoneGeneralDuraRate: TSpinEdit;
    Label41: TLabel;
    EditStoneAddDuraRate: TSpinEdit;
    Label42: TLabel;
    EditStoneAddDuraMax: TSpinEdit;
    TabSheet37: TTabSheet;
    GroupBox27: TGroupBox;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    ScrollBarWinLottery1Max: TScrollBar;
    EditWinLottery1Max: TEdit;
    ScrollBarWinLottery2Max: TScrollBar;
    EditWinLottery2Max: TEdit;
    ScrollBarWinLottery3Max: TScrollBar;
    EditWinLottery3Max: TEdit;
    ScrollBarWinLottery4Max: TScrollBar;
    EditWinLottery4Max: TEdit;
    EditWinLottery5Max: TEdit;
    ScrollBarWinLottery5Max: TScrollBar;
    Label48: TLabel;
    ScrollBarWinLottery6Max: TScrollBar;
    EditWinLottery6Max: TEdit;
    EditWinLotteryRate: TEdit;
    ScrollBarWinLotteryRate: TScrollBar;
    Label49: TLabel;
    GroupBox28: TGroupBox;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    EditWinLottery1Gold: TSpinEdit;
    EditWinLottery2Gold: TSpinEdit;
    EditWinLottery3Gold: TSpinEdit;
    EditWinLottery4Gold: TSpinEdit;
    Label54: TLabel;
    EditWinLottery5Gold: TSpinEdit;
    Label55: TLabel;
    EditWinLottery6Gold: TSpinEdit;
    ButtonWinLotterySave: TButton;
    TabSheet38: TTabSheet;
    GroupBox29: TGroupBox;
    Label56: TLabel;
    EditReNewNameColor1: TSpinEdit;
    LabelReNewNameColor1: TLabel;
    Label58: TLabel;
    EditReNewNameColor2: TSpinEdit;
    LabelReNewNameColor2: TLabel;
    Label60: TLabel;
    EditReNewNameColor3: TSpinEdit;
    LabelReNewNameColor3: TLabel;
    Label62: TLabel;
    EditReNewNameColor4: TSpinEdit;
    LabelReNewNameColor4: TLabel;
    Label64: TLabel;
    EditReNewNameColor5: TSpinEdit;
    LabelReNewNameColor5: TLabel;
    Label66: TLabel;
    EditReNewNameColor6: TSpinEdit;
    LabelReNewNameColor6: TLabel;
    Label68: TLabel;
    EditReNewNameColor7: TSpinEdit;
    LabelReNewNameColor7: TLabel;
    Label70: TLabel;
    EditReNewNameColor8: TSpinEdit;
    LabelReNewNameColor8: TLabel;
    Label72: TLabel;
    EditReNewNameColor9: TSpinEdit;
    LabelReNewNameColor9: TLabel;
    Label74: TLabel;
    EditReNewNameColor10: TSpinEdit;
    LabelReNewNameColor10: TLabel;
    ButtonReNewLevelSave: TButton;
    GroupBox30: TGroupBox;
    Label57: TLabel;
    EditReNewNameColorTime: TSpinEdit;
    TabSheet39: TTabSheet;
    ButtonMonUpgradeSave: TButton;
    GroupBox32: TGroupBox;
    Label65: TLabel;
    LabelMonUpgradeColor1: TLabel;
    Label67: TLabel;
    LabelMonUpgradeColor2: TLabel;
    Label69: TLabel;
    LabelMonUpgradeColor3: TLabel;
    Label71: TLabel;
    LabelMonUpgradeColor4: TLabel;
    Label73: TLabel;
    LabelMonUpgradeColor5: TLabel;
    Label75: TLabel;
    LabelMonUpgradeColor6: TLabel;
    Label76: TLabel;
    LabelMonUpgradeColor7: TLabel;
    Label77: TLabel;
    LabelMonUpgradeColor8: TLabel;
    EditMonUpgradeColor1: TSpinEdit;
    EditMonUpgradeColor2: TSpinEdit;
    EditMonUpgradeColor3: TSpinEdit;
    EditMonUpgradeColor4: TSpinEdit;
    EditMonUpgradeColor5: TSpinEdit;
    EditMonUpgradeColor6: TSpinEdit;
    EditMonUpgradeColor7: TSpinEdit;
    EditMonUpgradeColor8: TSpinEdit;
    GroupBox31: TGroupBox;
    Label61: TLabel;
    Label63: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    EditMonUpgradeKillCount1: TSpinEdit;
    EditMonUpgradeKillCount2: TSpinEdit;
    EditMonUpgradeKillCount3: TSpinEdit;
    EditMonUpgradeKillCount4: TSpinEdit;
    EditMonUpgradeKillCount5: TSpinEdit;
    EditMonUpgradeKillCount6: TSpinEdit;
    EditMonUpgradeKillCount7: TSpinEdit;
    EditMonUpLvNeedKillBase: TSpinEdit;
    EditMonUpLvRate: TSpinEdit;
    Label84: TLabel;
    CheckBoxReNewChangeColor: TCheckBox;
    GroupBox33: TGroupBox;
    CheckBoxReNewLevelClearExp: TCheckBox;
    GroupBox34: TGroupBox;
    Label85: TLabel;
    EditPKFlagNameColor: TSpinEdit;
    LabelPKFlagNameColor: TLabel;
    Label87: TLabel;
    EditPKLevel1NameColor: TSpinEdit;
    LabelPKLevel1NameColor: TLabel;
    Label89: TLabel;
    EditPKLevel2NameColor: TSpinEdit;
    LabelPKLevel2NameColor: TLabel;
    Label91: TLabel;
    EditAllyAndGuildNameColor: TSpinEdit;
    LabelAllyAndGuildNameColor: TLabel;
    Label93: TLabel;
    EditWarGuildNameColor: TSpinEdit;
    LabelWarGuildNameColor: TLabel;
    Label95: TLabel;
    EditInFreePKAreaNameColor: TSpinEdit;
    LabelInFreePKAreaNameColor: TLabel;
    TabSheet40: TTabSheet;
    Label86: TLabel;
    EditMonUpgradeColor9: TSpinEdit;
    LabelMonUpgradeColor9: TLabel;
    GroupBox35: TGroupBox;
    CheckBoxMasterDieMutiny: TCheckBox;
    Label88: TLabel;
    EditMasterDieMutinyRate: TSpinEdit;
    Label90: TLabel;
    EditMasterDieMutinyPower: TSpinEdit;
    Label92: TLabel;
    EditMasterDieMutinySpeed: TSpinEdit;
    GroupBox36: TGroupBox;
    Label94: TLabel;
    Label96: TLabel;
    CheckBoxSpiritMutiny: TCheckBox;
    EditSpiritMutinyTime: TSpinEdit;
    EditSpiritPowerRate: TSpinEdit;
    ButtonSpiritMutinySave: TButton;
    ButtonMonSayMsgSave: TButton;
    ButtonUpgradeWeaponDefaulf: TButton;
    ButtonMakeMineDefault: TButton;
    ButtonWinLotteryDefault: TButton;
    TabSheet42: TTabSheet;
    GroupBox44: TGroupBox;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    ScrollBarWeaponMakeUnLuckRate: TScrollBar;
    EditWeaponMakeUnLuckRate: TEdit;
    ScrollBarWeaponMakeLuckPoint1: TScrollBar;
    EditWeaponMakeLuckPoint1: TEdit;
    ScrollBarWeaponMakeLuckPoint2: TScrollBar;
    EditWeaponMakeLuckPoint2: TEdit;
    ScrollBarWeaponMakeLuckPoint2Rate: TScrollBar;
    EditWeaponMakeLuckPoint2Rate: TEdit;
    EditWeaponMakeLuckPoint3: TEdit;
    ScrollBarWeaponMakeLuckPoint3: TScrollBar;
    Label110: TLabel;
    ScrollBarWeaponMakeLuckPoint3Rate: TScrollBar;
    EditWeaponMakeLuckPoint3Rate: TEdit;
    ButtonWeaponMakeLuckDefault: TButton;
    ButtonWeaponMakeLuckSave: TButton;
    GroupBox47: TGroupBox;
    Label112: TLabel;
    CheckBoxBBMonAutoChangeColor: TCheckBox;
    EditBBMonAutoChangeColorTime: TSpinEdit;
    LabelReNewChangeColorLevel: TLabel;
    SpinEditReNewChangeColorLevel: TSpinEdit;
    PageControlSkill: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet47: TTabSheet;
    ButtonSkillSave: TButton;
    GroupBox17: TGroupBox;
    Label12: TLabel;
    EditMagicAttackRage: TSpinEdit;
    PageControlMag_Warr: TPageControl;
    TabSheet48: TTabSheet;
    TabSheet49: TTabSheet;
    GroupBox10: TGroupBox;
    Label4: TLabel;
    Label10: TLabel;
    EditSwordLongPowerRate: TSpinEdit;
    GroupBox9: TGroupBox;
    CheckBoxLimitSwordLong: TCheckBox;
    PageControlMag_Taos: TPageControl;
    TabSheet11: TTabSheet;
    TabSheet23: TTabSheet;
    TabSheet30: TTabSheet;
    GroupBox6: TGroupBox;
    GridBoneFamm: TStringGrid;
    GroupBox5: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    EditBoneFammName: TEdit;
    EditBoneFammCount: TSpinEdit;
    GroupBox12: TGroupBox;
    GridDogz: TStringGrid;
    GroupBox11: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditDogzName: TEdit;
    EditDogzCount: TSpinEdit;
    TabSheet32: TTabSheet;
    GroupBox42: TGroupBox;
    Label103: TLabel;
    EditMabMabeHitSucessRate: TSpinEdit;
    GroupBox43: TGroupBox;
    Label104: TLabel;
    EditMabMabeHitMabeTimeRate: TSpinEdit;
    GroupBox41: TGroupBox;
    Label101: TLabel;
    Label102: TLabel;
    EditMabMabeHitRandRate: TSpinEdit;
    EditMabMabeHitMinLvLimit: TSpinEdit;
    EditBody: TEdit;
    Label115: TLabel;
    GroupBox50: TGroupBox;
    Label116: TLabel;
    SpinEditBodyCount: TSpinEdit;
    CheckBoxAllowMakeSlave: TCheckBox;
    TabSheet31: TTabSheet;
    GroupBox16: TGroupBox;
    Label11: TLabel;
    EditAmyOunsulPoint: TSpinEdit;
    PageControlMag_Wizard: TPageControl;
    TabSheet6: TTabSheet;
    TabSheet15: TTabSheet;
    TabSheet16: TTabSheet;
    GroupBox14: TGroupBox;
    Label8: TLabel;
    EditSnowWindRange: TSpinEdit;
    GroupBox13: TGroupBox;
    Label7: TLabel;
    EditFireBoomRage: TSpinEdit;
    TabSheet12: TTabSheet;
    TabSheet19: TTabSheet;
    GroupBox46: TGroupBox;
    CheckBoxFireCrossInSafeZone: TCheckBox;
    GroupBox37: TGroupBox;
    Label97: TLabel;
    EditMagTurnUndeadLevel: TSpinEdit;
    GroupBox15: TGroupBox;
    Label9: TLabel;
    EditElecBlizzardRange: TSpinEdit;
    TabSheet20: TTabSheet;
    GroupBox45: TGroupBox;
    Label111: TLabel;
    EditTammingCount: TSpinEdit;
    GroupBox38: TGroupBox;
    Label98: TLabel;
    EditMagTammingLevel: TSpinEdit;
    GroupBox39: TGroupBox;
    Label99: TLabel;
    Label100: TLabel;
    EditMagTammingTargetLevel: TSpinEdit;
    EditMagTammingHPRate: TSpinEdit;
    TabSheet5: TTabSheet;
    GroupBox51: TGroupBox;
    Label59: TLabel;
    SpinEditMagNailTime: TSpinEdit;
    GroupBox66: TGroupBox;
    Label134: TLabel;
    Label135: TLabel;
    SpinEditFireHitPowerRate: TSpinEdit;
    CheckBoxNoDoubleFireHit: TCheckBox;
    TabSheet7: TTabSheet;
    GroupBox57: TGroupBox;
    Label123: TLabel;
    Label124: TLabel;
    EditMagNailPowerRate: TSpinEdit;
    TabSheet8: TTabSheet;
    GroupBox60: TGroupBox;
    Label125: TLabel;
    EditMagIceBallRange: TSpinEdit;
    GroupBox61: TGroupBox;
    Label126: TLabel;
    Label127: TLabel;
    EditEarthFirePowerRate: TSpinEdit;
    TabSheet9: TTabSheet;
    GroupBox62: TGroupBox;
    CheckBoxMagCapturePlayer: TCheckBox;
    GroupBox63: TGroupBox;
    Label128: TLabel;
    EditHPStoneStart: TSpinEdit;
    Label129: TLabel;
    EditMPStoneStart: TSpinEdit;
    EditHPStoneTime: TSpinEdit;
    EditMPStoneTime: TSpinEdit;
    Label130: TLabel;
    EditHPStoneAddPoint: TSpinEdit;
    EditMPStoneAddPoint: TSpinEdit;
    Label131: TLabel;
    EditHPStoneDecDura: TSpinEdit;
    Label132: TLabel;
    EditMPStoneDecDura: TSpinEdit;
    Label133: TLabel;
    TabSheet10: TTabSheet;
    PageControlJointAttack: TPageControl;
    TabSheet13: TTabSheet;
    TabSheet14: TTabSheet;
    TabSheet18: TTabSheet;
    TabSheet21: TTabSheet;
    TabSheet22: TTabSheet;
    TabSheet24: TTabSheet;
    GroupBox67: TGroupBox;
    Label143: TLabel;
    Label144: TLabel;
    EditSkillWWPowerRate: TSpinEdit;
    GroupBox68: TGroupBox;
    Label145: TLabel;
    Label146: TLabel;
    EditSkillTWPowerRate: TSpinEdit;
    GroupBox69: TGroupBox;
    Label147: TLabel;
    Label148: TLabel;
    EditSkillZWPowerRate: TSpinEdit;
    GroupBox70: TGroupBox;
    Label149: TLabel;
    Label150: TLabel;
    EditSkillTTPowerRate: TSpinEdit;
    GroupBox71: TGroupBox;
    Label151: TLabel;
    Label152: TLabel;
    EditSkillZTPowerRate: TSpinEdit;
    GroupBox72: TGroupBox;
    Label153: TLabel;
    Label154: TLabel;
    EditSkillZZPowerRate: TSpinEdit;
    TabSheet25: TTabSheet;
    GroupBox73: TGroupBox;
    Label155: TLabel;
    Label156: TLabel;
    EditEnergyStepUpRate: TSpinEdit;
    GroupBox74: TGroupBox;
    CheckBoxAllowJointAttack: TCheckBox;
    GroupBox40: TGroupBox;
    CheckBoxGroupAttrib: TCheckBox;
    Label157: TLabel;
    EditGroupAttribHPMPRate: TSpinEdit;
    Label139: TLabel;
    EditnGroupAttribPowerRate: TSpinEdit;
    Label158: TLabel;
    Label159: TLabel;
    Label160: TLabel;
    TabSheet26: TTabSheet;
    GroupBox48: TGroupBox;
    CheckBoxGroupMbAttackPlayObject: TCheckBox;
    CheckBoxGroupMbAttackBaobao: TCheckBox;
    CheckBoxLockRecallHero: TCheckBox;
    GroupBox75: TGroupBox;
    CheckBoxMagCanHitTarget: TCheckBox;
    TabSheet17: TTabSheet;
    GroupBox76: TGroupBox;
    Label163: TLabel;
    Label164: TLabel;
    SpinEditPursueHitPowerRate: TSpinEdit;
    cbNoDoublePursueHit: TCheckBox;
    GroupBox77: TGroupBox;
    SpinEditGatherExpRate: TSpinEdit;
    Label167: TLabel;
    CheckBoxMonSayMsg: TCheckBox;
    CheckBoxStorageEX: TCheckBox;
    CheckBoxShowShieldEffect: TCheckBox;
    CheckBoxAutoOpenShield: TCheckBox;
    CheckBoxEnableMapEvent: TCheckBox;
    CheckBoxFireBurnEventOff: TCheckBox;
    Label169: TLabel;
    SpinEditInternalPowerRate: TSpinEdit;
    SpinEditInternalPowerSkillRate: TSpinEdit;
    Label170: TLabel;
    TabSheet27: TTabSheet;
    GroupBox78: TGroupBox;
    Label171: TLabel;
    Label172: TLabel;
    seMagicShootingStarPowerRate: TSpinEdit;
    GroupBox49: TGroupBox;
    Label113: TLabel;
    Label114: TLabel;
    EditSellCount: TSpinEdit;
    EditSellTax: TSpinEdit;
    PageControl1: TPageControl;
    TabSheet28: TTabSheet;
    TabSheet29: TTabSheet;
    GroupBox55: TGroupBox;
    Label161: TLabel;
    CheckBoxNoButchItemSubGird: TCheckBox;
    EditDiButchItemNeedGird: TSpinEdit;
    GroupBox53: TGroupBox;
    Label120: TLabel;
    Label121: TLabel;
    LabelHeroNameColor: TLabel;
    Label141: TLabel;
    EditHeroName: TEdit;
    EditHeroSlaveName: TEdit;
    CheckBoxPShowMasterName: TCheckBox;
    EditHeroNameColor: TSpinEdit;
    GroupBox54: TGroupBox;
    Label122: TLabel;
    SpinEditHeroFireSwordTime: TSpinEdit;
    GroupBox58: TGroupBox;
    RadioButtonMag12: TRadioButton;
    RadioButtonMag25: TRadioButton;
    RadioButtonMag0: TRadioButton;
    CheckBoxDoMotaebo: TCheckBox;
    CheckBoxHeroNeedAmulet: TCheckBox;
    GroupBox65: TGroupBox;
    Label142: TLabel;
    Label165: TLabel;
    CheckBoxAllowHeroPickUpItem: TCheckBox;
    CheckBoxTaosHeroAutoChangePoison: TCheckBox;
    EditRecallHeroIntervalTime: TSpinEdit;
    CheckBoxHeroCalcHitSpeed: TCheckBox;
    CheckBoxHeroLockTarget: TCheckBox;
    speHeroRecallPneumaTime: TSpinEdit;
    GroupBox52: TGroupBox;
    Label118: TLabel;
    Label119: TLabel;
    Label117: TLabel;
    EditHeroNextHitTime_Warr: TSpinEdit;
    EditHeroNextHitTime_Wizard: TSpinEdit;
    EditHeroNextHitTime_Taos: TSpinEdit;
    GroupBox64: TGroupBox;
    Label136: TLabel;
    Label137: TLabel;
    Label138: TLabel;
    EditHeroWalkSpeed_Warr: TSpinEdit;
    EditHeroWalkSpeed_Wizard: TSpinEdit;
    EditHeroWalkSpeed_Taos: TSpinEdit;
    ButtonHeroSetSave: TButton;
    GroupBox79: TGroupBox;
    ButtonHeroSetSave2: TButton;
    SpinEditWarrCmpInvTime: TSpinEdit;
    Label173: TLabel;
    Label174: TLabel;
    Label175: TLabel;
    SpinEditTaosCmpInvTime: TSpinEdit;
    SpinEditWizaCmpInvTime: TSpinEdit;
    Label176: TLabel;
    EditMonUpgradeColor10: TSpinEdit;
    LabelMonUpgradeColor10: TLabel;
    LabelMonUpgradeColor11: TLabel;
    LabelMonUpgradeColor12: TLabel;
    LabelMonUpgradeColor13: TLabel;
    LabelMonUpgradeColor14: TLabel;
    LabelMonUpgradeColor15: TLabel;
    EditMonUpgradeColor15: TSpinEdit;
    EditMonUpgradeColor14: TSpinEdit;
    Label177: TLabel;
    Label178: TLabel;
    Label179: TLabel;
    EditMonUpgradeColor13: TSpinEdit;
    EditMonUpgradeColor12: TSpinEdit;
    Label180: TLabel;
    Label181: TLabel;
    EditMonUpgradeColor11: TSpinEdit;
    GroupBox86: TGroupBox;
    Label140: TLabel;
    Label199: TLabel;
    CheckBoxGetFullExp: TCheckBox;
    EditHeroGainExpRate: TSpinEdit;
    EditHeroGainExpRate2: TSpinEdit;
    Label182: TLabel;
    SpinEditShadowExpriesTime: TSpinEdit;
    Label183: TLabel;
    CheckBoxIgnoreTagDefence: TCheckBox;
    TabSheet36: TTabSheet;
    Label184: TLabel;
    SpinEditMagBubbleDefenceRate: TSpinEdit;
    TabSheet41: TTabSheet;
    PageControl2: TPageControl;
    TabSheet43: TTabSheet;
    speSeriesSkillReleaseInvTime: TSpinEdit;
    Label185: TLabel;
    GroupBox80: TGroupBox;
    Label186: TLabel;
    spePowerRateOfSeriesSkill_100: TSpinEdit;
    Label187: TLabel;
    spePowerRateOfSeriesSkill_101: TSpinEdit;
    Label188: TLabel;
    spePowerRateOfSeriesSkill_102: TSpinEdit;
    spePowerRateOfSeriesSkill_103: TSpinEdit;
    Label189: TLabel;
    spePowerRateOfSeriesSkill_104: TSpinEdit;
    spePowerRateOfSeriesSkill_105: TSpinEdit;
    spePowerRateOfSeriesSkill_106: TSpinEdit;
    spePowerRateOfSeriesSkill_107: TSpinEdit;
    Label190: TLabel;
    Label191: TLabel;
    Label192: TLabel;
    Label193: TLabel;
    spePowerRateOfSeriesSkill_108: TSpinEdit;
    spePowerRateOfSeriesSkill_109: TSpinEdit;
    spePowerRateOfSeriesSkill_110: TSpinEdit;
    spePowerRateOfSeriesSkill_111: TSpinEdit;
    Label194: TLabel;
    Label195: TLabel;
    Label196: TLabel;
    Label197: TLabel;
    CheckBoxIgnoreTagDefence2: TCheckBox;
    TabSheet44: TTabSheet;
    seBoneFammDcEx: TSpinEdit;
    Label198: TLabel;
    Label200: TLabel;
    seDogzDcEx: TSpinEdit;
    Label201: TLabel;
    seAngelDcEx: TSpinEdit;
    TabSheet45: TTabSheet;
    Label202: TLabel;
    seMagSuckHpRate: TSpinEdit;
    Label162: TLabel;
    EditCordialAddHPMax: TSpinEdit;
    speEatItemsTime: TSpinEdit;
    Label166: TLabel;
    Label203: TLabel;
    seMagSuckHpPowerRate: TSpinEdit;
    TabSheet46: TTabSheet;
    GroupBox56: TGroupBox;
    Label205: TLabel;
    seTwinPowerRate: TSpinEdit;
    cbTDBeffect: TCheckBox;
    seMagSquPowerRate: TSpinEdit;
    cbLimitSquAttack: TCheckBox;
    Label204: TLabel;
    seSmiteLongHit2PowerRate: TSpinEdit;
    Label206: TLabel;
    Bevel1: TBevel;
    seSSFreezeRate: TSpinEdit;
    Label207: TLabel;
    GroupBox82: TGroupBox;
    cbNullAttackOnSale: TCheckBox;
    cbMedalItemLight: TCheckBox;
    cbSpiritMutinyDie: TCheckBox;
    TabSheet50: TTabSheet;
    seDoubleScRate: TSpinEdit;
    Label210: TLabel;
    cbEffectHeroDropRate: TCheckBox;
    GroupBox83: TGroupBox;
    CheckBoxClientAP: TCheckBox;
    cbClientAdjustSpeed: TCheckBox;
    cbClientNoFog: TCheckBox;
    cbStallSystem: TCheckBox;
    seSetShopNeedLevel: TSpinEdit;
    cbRecallHeroCtrl: TCheckBox;
    cbClientAutoLongAttack: TCheckBox;
    cbLargeMagicRange: TCheckBox;
    SpinEditInternalPowerRate2: TSpinEdit;
    Label211: TLabel;
    cbDeathWalking: TCheckBox;
    SpinEditTest: TSpinEdit;
    cbHeroSys: TCheckBox;
    GroupBox84: TGroupBox;
    boBindNoSell: TCheckBox;
    boBindNoScatter: TCheckBox;
    boBindNoMelt: TCheckBox;
    boBindNoUse: TCheckBox;
    boBindNoPickUp: TCheckBox;
    seSuperSkillInvTime: TSpinEdit;
    Label212: TLabel;
    Bevel2: TBevel;
    Label213: TLabel;
    sePowerRate_115: TSpinEdit;
    TabSheet51: TTabSheet;
    seDoMotaeboPauseTime: TSpinEdit;
    Label214: TLabel;
    GroupBox85: TGroupBox;
    cbItemSuiteDamageTypes_IP: TCheckBox;
    cbItemSuiteDamageTypes_HP: TCheckBox;
    cbItemSuiteDamageTypes_MP: TCheckBox;
    cbCliAutoSay: TCheckBox;
    Label215: TLabel;
    seDoubleScInvTime: TSpinEdit;
    cbMutiHero: TCheckBox;
    cbBindPickup: TCheckBox;
    cbBindTakeOn: TCheckBox;
    Label217: TLabel;
    seSquareHitPowerRate: TSpinEdit;
    GroupBox59: TGroupBox;
    Label168: TLabel;
    CheckBoxHeroMaxHealthType: TCheckBox;
    SpinEditHeroMaxHealthRate: TSpinEdit;
    Label218: TLabel;
    Label219: TLabel;
    SpinEditHeroMaxHealthRate1: TSpinEdit;
    Label220: TLabel;
    SpinEditHeroMaxHealthRate2: TSpinEdit;
    Label216: TLabel;
    seShieldHoldTime: TSpinEdit;
    cbSmiteDamegeShow: TCheckBox;
    TabSheet52: TTabSheet;
    PageControl3: TPageControl;
    TabSheet53: TTabSheet;
    TabSheet54: TTabSheet;
    Label221: TLabel;
    seDetcetItemRate: TSpinEdit;
    Label222: TLabel;
    seMakeItemButchRate: TSpinEdit;
    Label223: TLabel;
    seMakeItemRate: TSpinEdit;
    btnEvaluationSave: TButton;
    PageControl4: TPageControl;
    TabSheet55: TTabSheet;
    TabSheet56: TTabSheet;
    TabSheet57: TTabSheet;
    Label226: TLabel;
    setiWeaponDCAddRate: TSpinEdit;
    setiWeaponDCAddValueMaxLimit: TSpinEdit;
    Label224: TLabel;
    Label225: TLabel;
    setiWeaponDCAddValueRate: TSpinEdit;
    Label227: TLabel;
    Label228: TLabel;
    Label229: TLabel;
    setiWeaponMCAddRate: TSpinEdit;
    Label230: TLabel;
    setiWeaponMCAddValueMaxLimit: TSpinEdit;
    Label231: TLabel;
    setiWeaponMCAddValueRate: TSpinEdit;
    Label232: TLabel;
    setiWeaponSCAddRate: TSpinEdit;
    Label233: TLabel;
    setiWeaponSCAddValueMaxLimit: TSpinEdit;
    Label234: TLabel;
    setiWeaponSCAddValueRate: TSpinEdit;
    Label235: TLabel;
    Label236: TLabel;
    Label237: TLabel;
    setiWeaponLuckAddValueMaxLimit: TSpinEdit;
    Label238: TLabel;
    setiWeaponLuckAddValueRate: TSpinEdit;
    Label239: TLabel;
    setiWeaponLuckAddRate: TSpinEdit;
    Label240: TLabel;
    Label241: TLabel;
    setiWeaponHolyAddValueMaxLimit: TSpinEdit;
    Label242: TLabel;
    setiWeaponHolyAddValueRate: TSpinEdit;
    Label243: TLabel;
    setiWeaponHolyAddRate: TSpinEdit;
    Label244: TLabel;
    setiWeaponHitSpdAddRate: TSpinEdit;
    Label245: TLabel;
    setiWeaponHitSpdAddValueMaxLimit: TSpinEdit;
    Label246: TLabel;
    setiWeaponHitSpdAddValueRate: TSpinEdit;
    Label247: TLabel;
    setiWeaponCurseAddValueMaxLimit: TSpinEdit;
    setiWeaponCurseAddRate: TSpinEdit;
    Label248: TLabel;
    setiWeaponCurseAddValueRate: TSpinEdit;
    Label249: TLabel;
    Label250: TLabel;
    Label251: TLabel;
    setiWeaponHitAddRate: TSpinEdit;
    Label252: TLabel;
    Label253: TLabel;
    Label254: TLabel;
    setiWeaponHitAddValueRate: TSpinEdit;
    Label255: TLabel;
    setiWeaponHitAddValueMaxLimit: TSpinEdit;
    PageControl5: TPageControl;
    TabSheet59: TTabSheet;
    TabSheet60: TTabSheet;
    setiSpiritAddRate: TSpinEdit;
    setiSpiritAddValueRate: TSpinEdit;
    Label265: TLabel;
    Label263: TLabel;
    Label264: TLabel;
    setiSucessRate: TSpinEdit;
    setiSucessRateEx: TSpinEdit;
    setiSecretPropertyAddValueRate: TSpinEdit;
    setiSecretPropertyAddRate: TSpinEdit;
    setiSecretPropertyAddValueMaxLimit: TSpinEdit;
    Label256: TLabel;
    Label257: TLabel;
    setiExchangeItemRate: TSpinEdit;
    Label266: TLabel;
    Label267: TLabel;
    Label261: TLabel;
    Label262: TLabel;
    Label260: TLabel;
    Label259: TLabel;
    Label258: TLabel;
    Label268: TLabel;
    Label269: TLabel;
    Label270: TLabel;
    Label271: TLabel;
    Label272: TLabel;
    Label273: TLabel;
    Label274: TLabel;
    Label275: TLabel;
    Label276: TLabel;
    Label277: TLabel;
    Label278: TLabel;
    Label279: TLabel;
    Label280: TLabel;
    Label281: TLabel;
    Label282: TLabel;
    Label283: TLabel;
    Label292: TLabel;
    Label293: TLabel;
    Label294: TLabel;
    Label295: TLabel;
    setiDressDCAddRate: TSpinEdit;
    setiDressDCAddValueMaxLimit: TSpinEdit;
    setiDressDCAddValueRate: TSpinEdit;
    setiDressMCAddRate: TSpinEdit;
    setiDressMCAddValueMaxLimit: TSpinEdit;
    setiDressMCAddValueRate: TSpinEdit;
    setiDressSCAddRate: TSpinEdit;
    setiDressSCAddValueMaxLimit: TSpinEdit;
    setiDressSCAddValueRate: TSpinEdit;
    setiDressACAddValueMaxLimit: TSpinEdit;
    setiDressACAddValueRate: TSpinEdit;
    setiDressACAddRate: TSpinEdit;
    setiDressMACAddValueMaxLimit: TSpinEdit;
    setiDressMACAddRate: TSpinEdit;
    setiDressMACAddValueRate: TSpinEdit;
    Label285: TLabel;
    Label286: TLabel;
    Label287: TLabel;
    Label288: TLabel;
    Label289: TLabel;
    Label290: TLabel;
    Label291: TLabel;
    Label296: TLabel;
    Label297: TLabel;
    Label298: TLabel;
    Label299: TLabel;
    Label300: TLabel;
    Label301: TLabel;
    Label302: TLabel;
    Label303: TLabel;
    Label304: TLabel;
    Label305: TLabel;
    Label306: TLabel;
    setiWearingLuckAddValueMaxLimit: TSpinEdit;
    setiWearingLuckAddValueRate: TSpinEdit;
    setiWearingHitAddValueMaxLimit: TSpinEdit;
    setiWearingHitAddValueRate: TSpinEdit;
    setiWearingSpeedAddValueRate: TSpinEdit;
    setiWearingSpeedAddValueMaxLimit: TSpinEdit;
    Label307: TLabel;
    setiWearingLuckAddRate: TSpinEdit;
    setiWearingAntiMagicAddValueMaxLimit: TSpinEdit;
    setiWearingAntiMagicAddValueRate: TSpinEdit;
    setiWearingAntiMagicAddRate: TSpinEdit;
    Label308: TLabel;
    Label309: TLabel;
    setiWearingHealthRecoverAddValueRate: TSpinEdit;
    setiWearingHitAddRate: TSpinEdit;
    setiWearingSpeedAddRate: TSpinEdit;
    setiWearingHealthRecoverAddValueMaxLimit: TSpinEdit;
    setiWearingHealthRecoverAddRate: TSpinEdit;
    Label284: TLabel;
    Label310: TLabel;
    setiWearingSpellRecoverAddRate: TSpinEdit;
    Label311: TLabel;
    setiWearingSpellRecoverAddValueMaxLimit: TSpinEdit;
    Label312: TLabel;
    setiWearingSpellRecoverAddValueRate: TSpinEdit;
    TabSheet58: TTabSheet;
    Label313: TLabel;
    Label314: TLabel;
    Label315: TLabel;
    Label316: TLabel;
    Label317: TLabel;
    Label318: TLabel;
    Label319: TLabel;
    Label320: TLabel;
    tiAbilTagDropAddRate: TSpinEdit;
    tiAbilPreDropAddRate: TSpinEdit;
    tiAbilSuckAddRate: TSpinEdit;
    tiAbilIpRecoverAddRate: TSpinEdit;
    Label321: TLabel;
    Label322: TLabel;
    Label323: TLabel;
    Label324: TLabel;
    tiAbilTagDropAddValueMaxLimit: TSpinEdit;
    tiAbilPreDropAddValueMaxLimit: TSpinEdit;
    tiAbilSuckAddValueMaxLimit: TSpinEdit;
    tiAbilIpRecoverAddValueMaxLimit: TSpinEdit;
    Label325: TLabel;
    Label326: TLabel;
    Label327: TLabel;
    Label328: TLabel;
    tiAbilTagDropAddValueRate: TSpinEdit;
    tiAbilPreDropAddValueRate: TSpinEdit;
    tiAbilSuckAddValueRate: TSpinEdit;
    tiAbilIpRecoverAddValueRate: TSpinEdit;
    Label329: TLabel;
    Label330: TLabel;
    Label331: TLabel;
    Label332: TLabel;
    Label333: TLabel;
    Label334: TLabel;
    Label335: TLabel;
    Label336: TLabel;
    tiAbilIpExAddRate: TSpinEdit;
    tiAbilIpDamAddRate: TSpinEdit;
    tiAbilIpReduceAddRate: TSpinEdit;
    tiAbilIpDecAddRate: TSpinEdit;
    Label337: TLabel;
    Label338: TLabel;
    Label339: TLabel;
    Label340: TLabel;
    tiAbilIpExAddValueMaxLimit: TSpinEdit;
    tiAbilIpDamAddValueMaxLimit: TSpinEdit;
    tiAbilIpReduceAddValueMaxLimit: TSpinEdit;
    tiAbilIpDecAddValueMaxLimit: TSpinEdit;
    Label341: TLabel;
    Label342: TLabel;
    Label343: TLabel;
    Label344: TLabel;
    tiAbilIpExAddValueRate: TSpinEdit;
    tiAbilIpDamAddValueRate: TSpinEdit;
    tiAbilIpReduceAddValueRate: TSpinEdit;
    tiAbilIpDecAddValueRate: TSpinEdit;
    tiAbilGangUpAddRate: TSpinEdit;
    tiAbilBangAddRate: TSpinEdit;
    Label345: TLabel;
    tiAbilPalsyReduceAddRate: TSpinEdit;
    Label346: TLabel;
    Label347: TLabel;
    tiAbilHPExAddRate: TSpinEdit;
    Label348: TLabel;
    Label349: TLabel;
    Label350: TLabel;
    Label351: TLabel;
    Label352: TLabel;
    Label353: TLabel;
    Label354: TLabel;
    Label355: TLabel;
    Label356: TLabel;
    Label357: TLabel;
    tiAbilBangAddValueRate: TSpinEdit;
    tiAbilHPExAddValueRate: TSpinEdit;
    tiAbilPalsyReduceAddValueRate: TSpinEdit;
    tiAbilGangUpAddValueRate: TSpinEdit;
    tiAbilBangAddValueMaxLimit: TSpinEdit;
    Label358: TLabel;
    Label359: TLabel;
    tiAbilGangUpAddValueMaxLimit: TSpinEdit;
    Label360: TLabel;
    tiAbilHPExAddValueMaxLimit: TSpinEdit;
    tiAbilPalsyReduceAddValueMaxLimit: TSpinEdit;
    tiAbilCCAddRate: TSpinEdit;
    tiAbilMPExAddRate: TSpinEdit;
    Label361: TLabel;
    tiAbilPoisonReduceAddRate: TSpinEdit;
    Label362: TLabel;
    Label363: TLabel;
    tiAbilPoisonRecoverAddRate: TSpinEdit;
    Label364: TLabel;
    Label365: TLabel;
    Label366: TLabel;
    Label367: TLabel;
    Label368: TLabel;
    Label369: TLabel;
    Label370: TLabel;
    Label371: TLabel;
    Label372: TLabel;
    Label373: TLabel;
    tiAbilMPExAddValueRate: TSpinEdit;
    tiAbilPoisonRecoverAddValueRate: TSpinEdit;
    tiAbilPoisonReduceAddValueRate: TSpinEdit;
    tiAbilCCAddValueRate: TSpinEdit;
    tiAbilMPExAddValueMaxLimit: TSpinEdit;
    Label374: TLabel;
    Label375: TLabel;
    tiAbilCCAddValueMaxLimit: TSpinEdit;
    Label376: TLabel;
    tiAbilPoisonRecoverAddValueMaxLimit: TSpinEdit;
    tiAbilPoisonReduceAddValueMaxLimit: TSpinEdit;
    Label377: TLabel;
    Label378: TLabel;
    spSecretPropertySucessRate: TSpinEdit;
    TabSheet61: TTabSheet;
    Label394: TLabel;
    spEnergyAddTime: TSpinEdit;
    tiSpSkillAddHPMax: TCheckBox;
    Label393: TLabel;
    Label395: TLabel;
    spMakeBookSucessRate: TSpinEdit;
    cbHeroAutoLockTarget: TCheckBox;
    Label396: TLabel;
    nSuperSkill68InvTime: TSpinEdit;
    Label397: TLabel;
    IceMonLiveTime: TSpinEdit;
    tiHPSkillAddHPMax: TCheckBox;
    tiMPSkillAddMPMax: TCheckBox;
    Label398: TLabel;
    tiAddHealthPlus_0: TSpinEdit;
    tiAddHealthPlus_1: TSpinEdit;
    tiAddHealthPlus_2: TSpinEdit;
    Label399: TLabel;
    Label400: TLabel;
    tiAddSpellPlus_0: TSpinEdit;
    tiAddSpellPlus_1: TSpinEdit;
    tiAddSpellPlus_2: TSpinEdit;
    Label402: TLabel;
    Label401: TLabel;
    Label403: TLabel;
    Label404: TLabel;
    Label405: TLabel;
    Skill_68_MP: TCheckBox;
    Label406: TLabel;
    Skill77Time: TSpinEdit;
    Skill77Inv: TSpinEdit;
    Label408: TLabel;
    SkillMedusaEyeEffectTimeMax: TSpinEdit;
    Label409: TLabel;
    Label410: TLabel;
    Label411: TLabel;
    Label412: TLabel;
    Label413: TLabel;
    Label414: TLabel;
    Label415: TLabel;
    Label416: TLabel;
    Label417: TLabel;
    Label418: TLabel;
    Label419: TLabel;
    Label420: TLabel;
    Label421: TLabel;
    Label422: TLabel;
    tiSpMagicAddRate1: TSpinEdit;
    tiSpMagicAddRate2: TSpinEdit;
    tiSpMagicAddRate3: TSpinEdit;
    tiSpMagicAddRate4: TSpinEdit;
    tiSpMagicAddRate5: TSpinEdit;
    tiSpMagicAddRate6: TSpinEdit;
    tiSpMagicAddRate7: TSpinEdit;
    Label423: TLabel;
    Label424: TLabel;
    tiSpMagicAddRate8: TSpinEdit;
    Label379: TLabel;
    Label380: TLabel;
    Label381: TLabel;
    Label382: TLabel;
    Label383: TLabel;
    Label384: TLabel;
    Label385: TLabel;
    Label386: TLabel;
    Label387: TLabel;
    Label388: TLabel;
    Label389: TLabel;
    Label390: TLabel;
    Label391: TLabel;
    Label392: TLabel;
    SpecialSkills1: TSpinEdit;
    SpecialSkills2: TSpinEdit;
    SpecialSkills3: TSpinEdit;
    SpecialSkills4: TSpinEdit;
    SpecialSkills5: TSpinEdit;
    SpecialSkills6: TSpinEdit;
    SpecialSkills7: TSpinEdit;
    Label425: TLabel;
    tiSpMagicAddMaxLevel: TSpinEdit;
    tiSpMagicAddAtFirst: TCheckBox;
    Label426: TLabel;
    Label427: TLabel;
    Label428: TLabel;
    Label429: TLabel;
    Label430: TLabel;
    tiOpenSystem: TCheckBox;
    tiPutAbilOnce: TCheckBox;
    boHeroEvade: TCheckBox;
    boHeroRecalcWalkTick: TCheckBox;
    boHeroHitCmp: TCheckBox;
    Skill77PowerRate: TSpinEdit;
    EditHeroHitSpeedMax: TSpinEdit;
    TabSheet62: TTabSheet;
    GroupBox87: TGroupBox;
    Label407: TLabel;
    sePosMoveAttackPowerRate: TSpinEdit;
    cbPosMoveAttackParalysisPlayer: TCheckBox;
    Label431: TLabel;
    sePosMoveAttackInterval: TSpinEdit;
    GroupBox88: TGroupBox;
    Label432: TLabel;
    Label433: TLabel;
    seMagicIceRainPowerRate: TSpinEdit;
    cbMagicIceRainParalysisPlayer: TCheckBox;
    seMagicIceRainInterval: TSpinEdit;
    GroupBox89: TGroupBox;
    Label434: TLabel;
    Label435: TLabel;
    seMagicDeadEyePowerRate: TSpinEdit;
    cbMagicDeadEyeParalysisPlayer: TCheckBox;
    seMagicDeadEyeInterval: TSpinEdit;
    GroupBox81: TGroupBox;
    Label208: TLabel;
    Label209: TLabel;
    spePowerRateOfSeriesSkill_114: TSpinEdit;
    speSmiteWideHitSkillInvTime: TSpinEdit;
    cbSkill_114_MP: TCheckBox;
    GroupBox90: TGroupBox;
    Label437: TLabel;
    seMagicDragonRageInterval: TSpinEdit;
    Label436: TLabel;
    seMagicDragonRageDuration: TSpinEdit;
    seMagicDragonRageDamageAdd: TSpinEdit;
    Label438: TLabel;
    TabSheet63: TTabSheet;
    Label439: TLabel;
    EditHealingRate: TSpinEdit;
    TabSheet64: TTabSheet;
    GroupBox91: TGroupBox;
    Label440: TLabel;
    Label441: TLabel;
    SpinEdit1: TSpinEdit;
    CheckBox1: TCheckBox;
    SpinEdit2: TSpinEdit;
    cbPosMoveAttackOnItem: TCheckBox;
    cbDieDeductionExp: TCheckBox;
    CheckBoxHeroHomicideAddMasterPkPoint: TCheckBox;
    CheckBoxHeroKillHumanAddPkPoint: TCheckBox;
    chkMagicDeadEyeGreenPosion: TCheckBox;
    chkMagicDeadEyeRedPosion: TCheckBox;
    chkJointStrikeUI: TCheckBox;
    chkOpenFindPathMyMap: TCheckBox;
    procedure CheckBoxEnablePasswordLockClick(Sender: TObject);
    procedure CheckBoxLockGetBackItemClick(Sender: TObject);
    procedure CheckBoxLockDealItemClick(Sender: TObject);
    procedure CheckBoxLockDropItemClick(Sender: TObject);
    procedure CheckBoxLockWalkClick(Sender: TObject);
    procedure CheckBoxLockRunClick(Sender: TObject);
    procedure CheckBoxLockHitClick(Sender: TObject);
    procedure CheckBoxLockSpellClick(Sender: TObject);
    procedure CheckBoxLockSendMsgClick(Sender: TObject);
    procedure CheckBoxLockInObModeClick(Sender: TObject);
    procedure EditErrorPasswordCountChange(Sender: TObject);
    procedure ButtonPasswordLockSaveClick(Sender: TObject);
    procedure CheckBoxErrorCountKickClick(Sender: TObject);
    procedure CheckBoxLockLoginClick(Sender: TObject);
    procedure CheckBoxLockUseItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxHungerSystemClick(Sender: TObject);
    procedure CheckBoxHungerDecHPClick(Sender: TObject);
    procedure CheckBoxHungerDecPowerClick(Sender: TObject);
    procedure ButtonGeneralSaveClick(Sender: TObject);
    procedure CheckBoxLimitSwordLongClick(Sender: TObject);
    procedure ButtonSkillSaveClick(Sender: TObject);
    procedure EditBoneFammNameChange(Sender: TObject);
    procedure EditBoneFammCountChange(Sender: TObject);
    procedure EditSwordLongPowerRateChange(Sender: TObject);
    procedure EditFireBoomRageChange(Sender: TObject);
    procedure EditSnowWindRangeChange(Sender: TObject);
    procedure EditElecBlizzardRangeChange(Sender: TObject);
    procedure EditDogzCountChange(Sender: TObject);
    procedure EditDogzNameChange(Sender: TObject);
    procedure GridBoneFammSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure EditAmyOunsulPointChange(Sender: TObject);
    procedure EditMagicAttackRageChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponDCRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponDCTwoPointRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponDCThreePointRateChange(
      Sender: TObject);
    procedure ScrollBarUpgradeWeaponSCRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponSCTwoPointRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponSCThreePointRateChange(
      Sender: TObject);
    procedure ScrollBarUpgradeWeaponMCRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponMCTwoPointRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponMCThreePointRateChange(
      Sender: TObject);
    procedure EditUpgradeWeaponMaxPointChange(Sender: TObject);
    procedure EditUpgradeWeaponPriceChange(Sender: TObject);
    procedure EditUPgradeWeaponGetBackTimeChange(Sender: TObject);
    procedure EditClearExpireUpgradeWeaponDaysChange(Sender: TObject);
    procedure ButtonUpgradeWeaponSaveClick(Sender: TObject);
    procedure EditMasterOKLevelChange(Sender: TObject);
    procedure ButtonMasterSaveClick(Sender: TObject);
    procedure EditMasterOKCreditPointChange(Sender: TObject);
    procedure EditMasterOKBonusPointChange(Sender: TObject);
    procedure ScrollBarMakeMineHitRateChange(Sender: TObject);
    procedure ScrollBarMakeMineRateChange(Sender: TObject);
    procedure ScrollBarStoneTypeRateChange(Sender: TObject);
    procedure ScrollBarGoldStoneMaxChange(Sender: TObject);
    procedure ScrollBarSilverStoneMaxChange(Sender: TObject);
    procedure ScrollBarSteelStoneMaxChange(Sender: TObject);
    procedure ScrollBarBlackStoneMaxChange(Sender: TObject);
    procedure ButtonMakeMineSaveClick(Sender: TObject);
    procedure EditStoneMinDuraChange(Sender: TObject);
    procedure EditStoneGeneralDuraRateChange(Sender: TObject);
    procedure EditStoneAddDuraRateChange(Sender: TObject);
    procedure EditStoneAddDuraMaxChange(Sender: TObject);
    procedure ButtonWinLotterySaveClick(Sender: TObject);
    procedure EditWinLottery1GoldChange(Sender: TObject);
    procedure EditWinLottery2GoldChange(Sender: TObject);
    procedure EditWinLottery3GoldChange(Sender: TObject);
    procedure EditWinLottery4GoldChange(Sender: TObject);
    procedure EditWinLottery5GoldChange(Sender: TObject);
    procedure EditWinLottery6GoldChange(Sender: TObject);
    procedure ScrollBarWinLottery1MaxChange(Sender: TObject);
    procedure ScrollBarWinLottery2MaxChange(Sender: TObject);
    procedure ScrollBarWinLottery3MaxChange(Sender: TObject);
    procedure ScrollBarWinLottery4MaxChange(Sender: TObject);
    procedure ScrollBarWinLottery5MaxChange(Sender: TObject);
    procedure ScrollBarWinLottery6MaxChange(Sender: TObject);
    procedure ScrollBarWinLotteryRateChange(Sender: TObject);
    procedure ButtonReNewLevelSaveClick(Sender: TObject);
    procedure EditReNewNameColor1Change(Sender: TObject);
    procedure EditReNewNameColor2Change(Sender: TObject);
    procedure EditReNewNameColor3Change(Sender: TObject);
    procedure EditReNewNameColor4Change(Sender: TObject);
    procedure EditReNewNameColor5Change(Sender: TObject);
    procedure EditReNewNameColor6Change(Sender: TObject);
    procedure EditReNewNameColor7Change(Sender: TObject);
    procedure EditReNewNameColor8Change(Sender: TObject);
    procedure EditReNewNameColor9Change(Sender: TObject);
    procedure EditReNewNameColor10Change(Sender: TObject);
    procedure EditReNewNameColorTimeChange(Sender: TObject);
    procedure FunctionConfigControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure ButtonMonUpgradeSaveClick(Sender: TObject);
    procedure EditMonUpgradeColor1Change(Sender: TObject);
    procedure EditMonUpgradeColor2Change(Sender: TObject);
    procedure EditMonUpgradeColor3Change(Sender: TObject);
    procedure EditMonUpgradeColor4Change(Sender: TObject);
    procedure EditMonUpgradeColor5Change(Sender: TObject);
    procedure EditMonUpgradeColor6Change(Sender: TObject);
    procedure EditMonUpgradeColor7Change(Sender: TObject);
    procedure EditMonUpgradeColor8Change(Sender: TObject);
    procedure EditMonUpgradeColor9Change(Sender: TObject);
    procedure CheckBoxReNewChangeColorClick(Sender: TObject);
    procedure CheckBoxReNewLevelClearExpClick(Sender: TObject);
    procedure EditPKFlagNameColorChange(Sender: TObject);
    procedure EditPKLevel1NameColorChange(Sender: TObject);
    procedure EditPKLevel2NameColorChange(Sender: TObject);
    procedure EditAllyAndGuildNameColorChange(Sender: TObject);
    procedure EditWarGuildNameColorChange(Sender: TObject);
    procedure EditInFreePKAreaNameColorChange(Sender: TObject);
    procedure EditMonUpgradeKillCount1Change(Sender: TObject);
    procedure EditMonUpgradeKillCount2Change(Sender: TObject);
    procedure EditMonUpgradeKillCount3Change(Sender: TObject);
    procedure EditMonUpgradeKillCount4Change(Sender: TObject);
    procedure EditMonUpgradeKillCount5Change(Sender: TObject);
    procedure EditMonUpgradeKillCount6Change(Sender: TObject);
    procedure EditMonUpgradeKillCount7Change(Sender: TObject);
    procedure EditMonUpLvNeedKillBaseChange(Sender: TObject);
    procedure EditMonUpLvRateChange(Sender: TObject);
    procedure CheckBoxMasterDieMutinyClick(Sender: TObject);
    procedure EditMasterDieMutinyRateChange(Sender: TObject);
    procedure EditMasterDieMutinyPowerChange(Sender: TObject);
    procedure EditMasterDieMutinySpeedChange(Sender: TObject);
    procedure ButtonSpiritMutinySaveClick(Sender: TObject);
    procedure CheckBoxSpiritMutinyClick(Sender: TObject);
    procedure EditSpiritMutinyTimeChange(Sender: TObject);
    procedure EditSpiritPowerRateChange(Sender: TObject);
    procedure EditMagTurnUndeadLevelChange(Sender: TObject);
    procedure EditMagTammingLevelChange(Sender: TObject);
    procedure EditMagTammingTargetLevelChange(Sender: TObject);
    procedure EditMagTammingHPRateChange(Sender: TObject);
    procedure ButtonMonSayMsgSaveClick(Sender: TObject);
    procedure CheckBoxMonSayMsgClick(Sender: TObject);
    procedure ButtonUpgradeWeaponDefaulfClick(Sender: TObject);
    procedure ButtonMakeMineDefaultClick(Sender: TObject);
    procedure ButtonWinLotteryDefaultClick(Sender: TObject);
    procedure EditMabMabeHitRandRateChange(Sender: TObject);
    procedure EditMabMabeHitMinLvLimitChange(Sender: TObject);
    procedure EditMabMabeHitSucessRateChange(Sender: TObject);
    procedure EditMabMabeHitMabeTimeRateChange(Sender: TObject);
    procedure ButtonWeaponMakeLuckDefaultClick(Sender: TObject);
    procedure ButtonWeaponMakeLuckSaveClick(Sender: TObject);
    procedure ScrollBarWeaponMakeUnLuckRateChange(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint1Change(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint2Change(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint2RateChange(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint3Change(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint3RateChange(Sender: TObject);
    procedure EditTammingCountChange(Sender: TObject);
    procedure CheckBoxFireCrossInSafeZoneClick(Sender: TObject);
    procedure CheckBoxBBMonAutoChangeColorClick(Sender: TObject);
    procedure EditBBMonAutoChangeColorTimeChange(Sender: TObject);
    procedure CheckBoxGroupMbAttackPlayObjectClick(Sender: TObject);
    procedure CheckBoxGroupMbAttackBaobaoClick(Sender: TObject);
    procedure EditSellCountChange(Sender: TObject);
    procedure ButtonSellSaveClick(Sender: TObject);
    procedure SpinEditBodyCountChange(Sender: TObject);
    procedure CheckBoxAllowMakeSlaveClick(Sender: TObject);
    procedure SpinEditReNewChangeColorLevelChange(Sender: TObject);
    procedure SpinEditMagNailTimeChange(Sender: TObject);
    procedure SpinEditFireHitPowerRateChange(Sender: TObject);
    procedure CheckBoxNoDoubleFireHitClick(Sender: TObject);
    procedure SpinEditTestChange(Sender: TObject);
    procedure ButtonHeroSetSaveClick(Sender: TObject);
    procedure EditHeroNextHitTime_WarrChange(Sender: TObject);
    procedure EditHeroNextHitTime_WizardChange(Sender: TObject);
    procedure EditHeroNextHitTime_TaosChange(Sender: TObject);
    procedure EditHeroNameChange(Sender: TObject);
    procedure EditHeroSlaveNameChange(Sender: TObject);
    procedure SpinEditHeroFireSwordTimeChange(Sender: TObject);
    procedure EditMagNailPowerRateChange(Sender: TObject);
    procedure RadioButtonMag12Click(Sender: TObject);
    procedure RadioButtonMag25Click(Sender: TObject);
    procedure CheckBoxDoMotaeboClick(Sender: TObject);
    procedure CheckBoxEnableMapEventClick(Sender: TObject);
    procedure CheckBoxPShowMasterNameClick(Sender: TObject);
    procedure EditMagIceBallRangeChange(Sender: TObject);
    procedure EditEarthFirePowerRateChange(Sender: TObject);
    procedure CheckBoxMagCapturePlayerClick(Sender: TObject);
    procedure EditHPStoneStartChange(Sender: TObject);
    procedure EditMPStoneStartChange(Sender: TObject);
    procedure EditHPStoneTimeChange(Sender: TObject);
    procedure EditMPStoneTimeChange(Sender: TObject);
    procedure EditHPStoneAddPointChange(Sender: TObject);
    procedure EditMPStoneAddPointChange(Sender: TObject);
    procedure EditHPStoneDecDuraChange(Sender: TObject);
    procedure EditMPStoneDecDuraChange(Sender: TObject);
    procedure CheckBoxFireBurnEventOffClick(Sender: TObject);
    procedure CheckBoxStorageEXClick(Sender: TObject);
    procedure EditHeroWalkSpeed_WarrChange(Sender: TObject);
    procedure EditHeroWalkSpeed_WizardChange(Sender: TObject);
    procedure EditHeroWalkSpeed_TaosChange(Sender: TObject);
    procedure RadioButtonMag0Click(Sender: TObject);
    procedure EditHeroNameColorChange(Sender: TObject);
    procedure CheckBoxAllowHeroPickUpItemClick(Sender: TObject);
    procedure CheckBoxTaosHeroAutoChangePoisonClick(Sender: TObject);
    procedure EditHeroGainExpRateChange(Sender: TObject);
    procedure EditRecallHeroIntervalTimeChange(Sender: TObject);
    procedure CheckBoxHeroCalcHitSpeedClick(Sender: TObject);
    procedure EditSkillWWPowerRateChange(Sender: TObject);
    procedure CheckBoxAllowJointAttackClick(Sender: TObject);
    procedure CheckBoxGroupAttribClick(Sender: TObject);
    procedure EditGroupAttribHPMPRateChange(Sender: TObject);
    procedure EditnGroupAttribPowerRateChange(Sender: TObject);
    procedure CheckBoxHeroKillHumanAddPkPointClick(Sender: TObject);
    procedure CheckBoxHeroLockTargetClick(Sender: TObject);
    procedure CheckBoxLockRecallHeroClick(Sender: TObject);
    procedure CheckBoxNoButchItemSubGirdClick(Sender: TObject);
    procedure EditDiButchItemNeedGirdChange(Sender: TObject);
    procedure CheckBoxShowShieldEffectClick(Sender: TObject);
    procedure CheckBoxAutoOpenShieldClick(Sender: TObject);
    procedure EditCordialAddHPMaxChange(Sender: TObject);
    procedure CheckBoxMagCanHitTargetClick(Sender: TObject);
    procedure CheckBoxHeroNeedAmuletClick(Sender: TObject);
    procedure speHeroRecallPneumaTimeChange(Sender: TObject);
    procedure speEatItemsTimeChange(Sender: TObject);
    procedure SpinEditGatherExpRateChange(Sender: TObject);
    procedure SpinEditHeroMaxHealthRateChange(Sender: TObject);
    procedure CheckBoxHeroMaxHealthTypeClick(Sender: TObject);
    procedure EditMonUpgradeColor10Change(Sender: TObject);
    procedure EditMonUpgradeColor11Change(Sender: TObject);
    procedure EditMonUpgradeColor12Change(Sender: TObject);
    procedure EditMonUpgradeColor13Change(Sender: TObject);
    procedure EditMonUpgradeColor14Change(Sender: TObject);
    procedure EditMonUpgradeColor15Change(Sender: TObject);
    procedure cbItemSuiteDamageTypes_IPClick(Sender: TObject);
    procedure btnEvaluationSaveClick(Sender: TObject);
    procedure setiWeaponDCAddRateChange(Sender: TObject);
    procedure tiSpSkillAddHPMaxClick(Sender: TObject);
    procedure sePosMoveAttackPowerRateChange(Sender: TObject);
    procedure cbPosMoveAttackParalysisPlayerClick(Sender: TObject);
  private
    boOpened: Boolean;
    boModValued: Boolean;
    botiOpenSystem: Boolean;
    procedure ModValue();
    procedure uModValue();
    procedure RefReNewLevelConf;
    procedure RefUpgradeWeapon;
    procedure RefMakeMine;
    procedure RefWinLottery;
    procedure RefMonUpgrade;
    procedure RefGeneral;
    procedure RefSpiritMutiny;
    procedure RefMagicSkill;
    procedure RefMonSayMsg;
    procedure RefWeaponMakeLuck();
    { Private declarations }
  public
    procedure Open;
    procedure InitConfig;
    { Public declarations }
  end;

var
  frmFunctionConfig: TfrmFunctionConfig;

implementation

uses M2Share, HUtil32, svMain, VMProtectSDK{$IF USEWLSDK = 1}, WinlicenseSDK{$ELSEIF USEWLSDK = 2}, SELicenseSDK, SESDK{$IFEND}, LocalDB;

{$R *.dfm}

{ TfrmFunctionConfig }

procedure TfrmFunctionConfig.ModValue;
begin
  boModValued := True;
  ButtonPasswordLockSave.Enabled := True;
  ButtonGeneralSave.Enabled := True;
  ButtonSkillSave.Enabled := True;
  ButtonUpgradeWeaponSave.Enabled := True;
  ButtonMasterSave.Enabled := True;
  ButtonMakeMineSave.Enabled := True;
  ButtonWinLotterySave.Enabled := True;
  ButtonReNewLevelSave.Enabled := True;
  ButtonMonUpgradeSave.Enabled := True;
  ButtonSpiritMutinySave.Enabled := True;
  ButtonMonSayMsgSave.Enabled := True;
  ButtonHeroSetSave.Enabled := True;
  ButtonWeaponMakeLuckSave.Enabled := True;
  ButtonHeroSetSave2.Enabled := True;
  btnEvaluationSave.Enabled := True;
end;

procedure TfrmFunctionConfig.uModValue;
begin
  boModValued := False;
  ButtonPasswordLockSave.Enabled := False;
  ButtonGeneralSave.Enabled := False;
  ButtonSkillSave.Enabled := False;
  ButtonUpgradeWeaponSave.Enabled := False;
  ButtonMasterSave.Enabled := False;
  ButtonMakeMineSave.Enabled := False;
  ButtonWinLotterySave.Enabled := False;
  ButtonReNewLevelSave.Enabled := False;
  ButtonMonUpgradeSave.Enabled := False;
  ButtonSpiritMutinySave.Enabled := False;
  ButtonMonSayMsgSave.Enabled := False;
  ButtonHeroSetSave.Enabled := False;
  ButtonWeaponMakeLuckSave.Enabled := False;
  ButtonHeroSetSave2.Enabled := False;
  btnEvaluationSave.Enabled := False;
end;

procedure TfrmFunctionConfig.FunctionConfigControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if boModValued then
  begin
    if Application.MessageBox('参数设置已经被修改，是否确认不保存修改的设置？', '确认信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
      uModValue
    else
      AllowChange := False;
  end;
end;

procedure TfrmFunctionConfig.InitConfig;
var
  i: Integer;
begin
  RefGeneral();
  CheckBoxHungerSystem.Checked := g_Config.boHungerSystem;
  CheckBoxHungerDecHP.Checked := g_Config.boHungerDecHP;
  CheckBoxHungerDecPower.Checked := g_Config.boHungerDecPower;
  CheckBoxEnableMapEvent.Checked := g_Config.boEnableMapEvent;
  CheckBoxFireBurnEventOff.Checked := g_Config.boFireBurnEventOff;
  CheckBoxClientAP.Checked := g_Config.boClientAutoPlay;
  cbHeroSys.Checked := g_Config.boHeroSystem;
  boBindNoScatter.Checked := g_Config.boBindNoScatter;
  boBindNoMelt.Checked := g_Config.boBindNoMelt;
  boBindNoUse.Checked := g_Config.boBindNoUse;
  boBindNoSell.Checked := g_Config.boBindNoSell;
  boBindNoPickUp.Checked := g_Config.boBindNoPickUp;
  cbBindPickup.Checked := g_Config.boBindPickUp;
  cbBindTakeOn.Checked := g_Config.boBindTakeOn;

  cbItemSuiteDamageTypes_IP.Checked := g_Config.ItemSuiteDamageTypes and $1 <> 0;
  cbItemSuiteDamageTypes_HP.Checked := g_Config.ItemSuiteDamageTypes and $2 <> 0;
  cbItemSuiteDamageTypes_MP.Checked := g_Config.ItemSuiteDamageTypes and $4 <> 0;

  cbClientAdjustSpeed.Checked := g_Config.boSpeedCtrl;
  cbStallSystem.Checked := g_Config.boStallSystem;
  cbClientNoFog.Checked := g_Config.boClientNoFog;
  cbDeathWalking.Checked := g_Config.DeathWalking;
  cbRecallHeroCtrl.Checked := g_Config.boRecallHeroCtrl;
  cbEffectHeroDropRate.Checked := g_Config.EffectHeroDropRate;
  cbClientAutoLongAttack.Checked := g_Config.ClientAotoLongAttack;
  cbSmiteDamegeShow.Checked := g_Config.cbSmiteDamegeShow;

  cbCliAutoSay.Checked := g_Config.ClientAutoSay;
  cbMutiHero.Checked := g_Config.cbMutiHero;

  CheckBoxStorageEX.Checked := g_Config.boExtendStorage;
  CheckBoxGroupAttrib.Checked := g_Config.boHumanAttribute;
  EditGroupAttribHPMPRate.Value := g_Config.nGroupAttribHPMPRate;
  EditnGroupAttribPowerRate.Value := g_Config.nGroupAttribPowerRate;
  CheckBoxHungerSystemClick(CheckBoxHungerSystem);
  CheckBoxEnablePasswordLock.Checked := g_Config.boPasswordLockSystem;
  CheckBoxLockGetBackItem.Checked := g_Config.boLockGetBackItemAction;
  CheckBoxLockDealItem.Checked := g_Config.boLockDealAction;
  CheckBoxLockDropItem.Checked := g_Config.boLockDropAction;
  CheckBoxLockWalk.Checked := g_Config.boLockWalkAction;
  CheckBoxLockRun.Checked := g_Config.boLockRunAction;
  CheckBoxLockHit.Checked := g_Config.boLockHitAction;
  CheckBoxLockSpell.Checked := g_Config.boLockSpellAction;
  CheckBoxLockSendMsg.Checked := g_Config.boLockSendMsgAction;
  CheckBoxLockInObMode.Checked := g_Config.boLockInObModeAction;
  CheckBoxLockLogin.Checked := g_Config.boLockHumanLogin;
  CheckBoxLockUseItem.Checked := g_Config.boLockUserItemAction;
  CheckBoxLockRecallHero.Checked := g_Config.boLockRecallAction;

  CheckBoxEnablePasswordLockClick(CheckBoxEnablePasswordLock);
  CheckBoxLockLoginClick(CheckBoxLockLogin);
  EditErrorPasswordCount.Value := g_Config.nPasswordErrorCountLock;
  EditBoneFammName.Text := g_Config.sBoneFamm;
  EditBoneFammCount.Value := g_Config.nBoneFammCount;

  EditHealingRate.Value := g_Config.nHealingRate;
  seDoubleScInvTime.Value := g_Config.DoubleScInvTime;
  seBoneFammDcEx.Value := g_Config.nBoneFammDcEx;
  seDogzDcEx.Value := g_Config.nDogzDcEx;
  seAngelDcEx.Value := g_Config.nAngelDcEx;
  seMagSuckHpRate.Value := g_Config.nMagSuckHpRate;
  seDoubleScRate.Value := g_Config.nDoubleScRate;

  seMagSuckHpPowerRate.Value := g_Config.nMagSuckHpPowerRate;

  EditBody.Text := g_Config.sBody;
  SpinEditBodyCount.Value := g_Config.nBodyCount;
  CheckBoxAllowMakeSlave.Checked := g_Config.boAllowBodyMakeSlave;
  chkJointStrikeUI.Checked := g_Config.boJointStrikeUI;
  chkOpenFindPathMyMap.Checked := g_Config.boOpenFindPathMyMap;
  
  for i := Low(g_Config.BoneFammArray) to High(g_Config.BoneFammArray) do
  begin
    if g_Config.BoneFammArray[i].nHumLevel <= 0 then
      Break;
    GridBoneFamm.Cells[0, i + 1] := IntToStr(g_Config.BoneFammArray[i].nHumLevel);
    GridBoneFamm.Cells[1, i + 1] := g_Config.BoneFammArray[i].sMonName;
    GridBoneFamm.Cells[2, i + 1] := IntToStr(g_Config.BoneFammArray[i].nCount);
    GridBoneFamm.Cells[3, i + 1] := IntToStr(g_Config.BoneFammArray[i].nLevel);
  end;

  EditDogzName.Text := g_Config.sDogz;
  EditDogzCount.Value := g_Config.nDogzCount;
  for i := Low(g_Config.DogzArray) to High(g_Config.DogzArray) do
  begin
    if g_Config.DogzArray[i].nHumLevel <= 0 then
      Break;
    GridDogz.Cells[0, i + 1] := IntToStr(g_Config.DogzArray[i].nHumLevel);
    GridDogz.Cells[1, i + 1] := g_Config.DogzArray[i].sMonName;
    GridDogz.Cells[2, i + 1] := IntToStr(g_Config.DogzArray[i].nCount);
    GridDogz.Cells[3, i + 1] := IntToStr(g_Config.DogzArray[i].nLevel);
  end;

  RefMagicSkill();

  RefUpgradeWeapon();
  RefMakeMine();
  RefWinLottery();
  EditMasterOKLevel.Value := g_Config.nMasterOKLevel;
  EditMasterOKCreditPoint.Value := g_Config.nMasterOKCreditPoint;
  EditMasterOKBonusPoint.Value := g_Config.nMasterOKBonusPoint;

  EditSellTax.Value := g_Config.SellTax;
  EditSellCount.Value := g_Config.SellCount;

  EditHeroNextHitTime_Warr.Value := g_Config.nHeroNextHitTime_Warr;
  EditHeroNextHitTime_Wizard.Value := g_Config.nHeroNextHitTime_Wizard;
  EditHeroNextHitTime_Taos.Value := g_Config.nHeroNextHitTime_Taos;

  SpinEditHeroMaxHealthRate.Value := g_Config.nHeroMaxHealthRate;
  SpinEditHeroMaxHealthRate1.Value := g_Config.nHeroMaxHealthRate1;
  SpinEditHeroMaxHealthRate2.Value := g_Config.nHeroMaxHealthRate2;
  CheckBoxHeroMaxHealthType.Checked := g_Config.boHeroMaxHealthType;

  cbHeroAutoLockTarget.Checked := g_Config.boHeroAutoLockTarget;
  boHeroHitCmp.Checked := g_Config.boHeroHitCmp;
  boHeroEvade.Checked := g_Config.boHeroEvade;
  boHeroRecalcWalkTick.Checked := g_Config.boHeroRecalcWalkTick;

  cbSkill_114_MP.Checked := g_Config.boSkill_114_MP;
  Skill_68_MP.Checked := g_Config.boSkill_68_MP;

  EditHeroWalkSpeed_Warr.Value := g_Config.nHeroWalkSpeed_Warr;
  EditHeroWalkSpeed_Wizard.Value := g_Config.nHeroWalkSpeed_Wizard;
  EditHeroWalkSpeed_Taos.Value := g_Config.nHeroWalkSpeed_Taos;

  SpinEditWarrCmpInvTime.Value := g_Config.nWarrCmpInvTime;
  SpinEditWizaCmpInvTime.Value := g_Config.nWizaCmpInvTime;
  SpinEditTaosCmpInvTime.Value := g_Config.nTaosCmpInvTime;

  tiOpenSystem.Checked := g_Config.tiOpenSystem;
  tiPutAbilOnce.Checked := g_Config.tiPutAbilOnce;
  botiOpenSystem := g_Config.tiOpenSystem;
  seDetcetItemRate.Value := g_Config.nDetectItemRate;
  seMakeItemButchRate.Value := g_Config.nMakeItemButchRate;
  seMakeItemRate.Value := g_Config.nMakeItemRate;

  setiSpiritAddRate.Value := g_Config.tiSpiritAddRate;
  setiSpiritAddValueRate.Value := g_Config.tiSpiritAddValueRate;
  setiSecretPropertyAddRate.Value := g_Config.tiSecretPropertyAddRate;
  setiSecretPropertyAddValueMaxLimit.Value := g_Config.tiSecretPropertyAddValueMaxLimit;
  setiSecretPropertyAddValueRate.Value := g_Config.tiSecretPropertyAddValueRate;
  setiSucessRate.Value := g_Config.tiSucessRate;
  setiSucessRateEx.Value := g_Config.tiSucessRateEx;
  setiExchangeItemRate.Value := g_Config.tiExchangeItemRate;
  spSecretPropertySucessRate.Value := g_Config.spSecretPropertySucessRate;
  spMakeBookSucessRate.Value := g_Config.spMakeBookSucessRate;
  spEnergyAddTime.Value := g_Config.spEnergyAddTime;

  tiSpSkillAddHPMax.Checked := g_Config.tiSpSkillAddHPMax;
  tiHPSkillAddHPMax.Checked := g_Config.tiHPSkillAddHPMax;
  tiMPSkillAddMPMax.Checked := g_Config.tiMPSkillAddMPMax;

  tiSpMagicAddAtFirst.Checked := g_Config.tiSpMagicAddAtFirst;

  tiAddHealthPlus_0.Value := g_Config.tiAddHealthPlus_0;
  tiAddHealthPlus_1.Value := g_Config.tiAddHealthPlus_1;
  tiAddHealthPlus_2.Value := g_Config.tiAddHealthPlus_2;
  tiAddSpellPlus_0.Value := g_Config.tiAddSpellPlus_0;
  tiAddSpellPlus_1.Value := g_Config.tiAddSpellPlus_1;
  tiAddSpellPlus_2.Value := g_Config.tiAddSpellPlus_2;

  setiWeaponDCAddRate.Value := g_Config.tiWeaponDCAddRate;
  setiWeaponDCAddValueMaxLimit.Value := g_Config.tiWeaponDCAddValueMaxLimit;
  setiWeaponDCAddValueRate.Value := g_Config.tiWeaponDCAddValueRate;
  setiWeaponMCAddRate.Value := g_Config.tiWeaponMCAddRate;
  setiWeaponMCAddValueMaxLimit.Value := g_Config.tiWeaponMCAddValueMaxLimit;
  setiWeaponMCAddValueRate.Value := g_Config.tiWeaponMCAddValueRate;
  setiWeaponSCAddRate.Value := g_Config.tiWeaponSCAddRate;
  setiWeaponSCAddValueMaxLimit.Value := g_Config.tiWeaponSCAddValueMaxLimit;
  setiWeaponSCAddValueRate.Value := g_Config.tiWeaponSCAddValueRate;
  setiWeaponLuckAddRate.Value := g_Config.tiWeaponLuckAddRate;
  setiWeaponLuckAddValueMaxLimit.Value := g_Config.tiWeaponLuckAddValueMaxLimit;
  setiWeaponLuckAddValueRate.Value := g_Config.tiWeaponLuckAddValueRate;
  setiWeaponCurseAddRate.Value := g_Config.tiWeaponCurseAddRate;
  setiWeaponCurseAddValueMaxLimit.Value := g_Config.tiWeaponCurseAddValueMaxLimit;
  setiWeaponCurseAddValueRate.Value := g_Config.tiWeaponCurseAddValueRate;
  setiWeaponHitAddRate.Value := g_Config.tiWeaponHitAddRate;
  setiWeaponHitAddValueMaxLimit.Value := g_Config.tiWeaponHitAddValueMaxLimit;
  setiWeaponHitAddValueRate.Value := g_Config.tiWeaponHitAddValueRate;
  setiWeaponHitSpdAddRate.Value := g_Config.tiWeaponHitSpdAddRate;
  setiWeaponHitSpdAddValueMaxLimit.Value := g_Config.tiWeaponHitSpdAddValueMaxLimit;
  setiWeaponHitSpdAddValueRate.Value := g_Config.tiWeaponHitSpdAddValueRate;
  setiWeaponHolyAddRate.Value := g_Config.tiWeaponHolyAddRate;
  setiWeaponHolyAddValueMaxLimit.Value := g_Config.tiWeaponHolyAddValueMaxLimit;
  setiWeaponHolyAddValueRate.Value := g_Config.tiWeaponHolyAddValueRate;

  setiDressDCAddRate.Value := g_Config.tiWearingDCAddRate;
  setiDressDCAddValueMaxLimit.Value := g_Config.tiWearingDCAddValueMaxLimit;
  setiDressDCAddValueRate.Value := g_Config.tiWearingDCAddValueRate;
  setiDressMCAddRate.Value := g_Config.tiWearingMCAddRate;
  setiDressMCAddValueMaxLimit.Value := g_Config.tiWearingMCAddValueMaxLimit;
  setiDressMCAddValueRate.Value := g_Config.tiWearingMCAddValueRate;
  setiDressSCAddRate.Value := g_Config.tiWearingSCAddRate;
  setiDressSCAddValueMaxLimit.Value := g_Config.tiWearingSCAddValueMaxLimit;
  setiDressSCAddValueRate.Value := g_Config.tiWearingSCAddValueRate;
  setiDressACAddRate.Value := g_Config.tiWearingACAddRate;
  setiDressACAddValueMaxLimit.Value := g_Config.tiWearingACAddValueMaxLimit;
  setiDressACAddValueRate.Value := g_Config.tiWearingACAddValueRate;
  setiDressMACAddRate.Value := g_Config.tiWearingMACAddRate;
  setiDressMACAddValueMaxLimit.Value := g_Config.tiWearingMACAddValueMaxLimit;
  setiDressMACAddValueRate.Value := g_Config.tiWearingMACAddValueRate;

  setiWearingHitAddRate.Value := g_Config.tiWearingHitAddRate;
  setiWearingHitAddValueMaxLimit.Value := g_Config.tiWearingHitAddValueMaxLimit;
  setiWearingHitAddValueRate.Value := g_Config.tiWearingHitAddValueRate;
  setiWearingSpeedAddRate.Value := g_Config.tiWearingSpeedAddRate;
  setiWearingSpeedAddValueMaxLimit.Value := g_Config.tiWearingSpeedAddValueMaxLimit;
  setiWearingSpeedAddValueRate.Value := g_Config.tiWearingSpeedAddValueRate;
  setiWearingLuckAddRate.Value := g_Config.tiWearingLuckAddRate;
  setiWearingLuckAddValueMaxLimit.Value := g_Config.tiWearingLuckAddValueMaxLimit;
  setiWearingLuckAddValueRate.Value := g_Config.tiWearingLuckAddValueRate;
  setiWearingAntiMagicAddRate.Value := g_Config.tiWearingAntiMagicAddRate;
  setiWearingAntiMagicAddValueMaxLimit.Value := g_Config.tiWearingAntiMagicAddValueMaxLimit;
  setiWearingAntiMagicAddValueRate.Value := g_Config.tiWearingAntiMagicAddValueRate;
  setiWearingHealthRecoverAddRate.Value := g_Config.tiWearingHealthRecoverAddRate;
  setiWearingHealthRecoverAddValueMaxLimit.Value := g_Config.tiWearingHealthRecoverAddValueMaxLimit;
  setiWearingHealthRecoverAddValueRate.Value := g_Config.tiWearingHealthRecoverAddValueRate;
  setiWearingSpellRecoverAddRate.Value := g_Config.tiWearingSpellRecoverAddRate;
  setiWearingSpellRecoverAddValueMaxLimit.Value := g_Config.tiWearingSpellRecoverAddValueMaxLimit;
  setiWearingSpellRecoverAddValueRate.Value := g_Config.tiWearingSpellRecoverAddValueRate;

  tiAbilTagDropAddRate.Value := g_Config.tiAbilTagDropAddRate;
  tiAbilTagDropAddValueMaxLimit.Value := g_Config.tiAbilTagDropAddValueMaxLimit;
  tiAbilTagDropAddValueRate.Value := g_Config.tiAbilTagDropAddValueRate;
  tiAbilPreDropAddRate.Value := g_Config.tiAbilPreDropAddRate;
  tiAbilPreDropAddValueMaxLimit.Value := g_Config.tiAbilPreDropAddValueMaxLimit;
  tiAbilPreDropAddValueRate.Value := g_Config.tiAbilPreDropAddValueRate;
  tiAbilSuckAddRate.Value := g_Config.tiAbilSuckAddRate;
  tiAbilSuckAddValueMaxLimit.Value := g_Config.tiAbilSuckAddValueMaxLimit;
  tiAbilSuckAddValueRate.Value := g_Config.tiAbilSuckAddValueRate;
  tiAbilIpRecoverAddRate.Value := g_Config.tiAbilIpRecoverAddRate;
  tiAbilIpRecoverAddValueMaxLimit.Value := g_Config.tiAbilIpRecoverAddValueMaxLimit;
  tiAbilIpRecoverAddValueRate.Value := g_Config.tiAbilIpRecoverAddValueRate;
  tiAbilIpExAddRate.Value := g_Config.tiAbilIpExAddRate;
  tiAbilIpExAddValueMaxLimit.Value := g_Config.tiAbilIpExAddValueMaxLimit;
  tiAbilIpExAddValueRate.Value := g_Config.tiAbilIpExAddValueRate;
  tiAbilIpDamAddRate.Value := g_Config.tiAbilIpDamAddRate;
  tiAbilIpDamAddValueMaxLimit.Value := g_Config.tiAbilIpDamAddValueMaxLimit;
  tiAbilIpDamAddValueRate.Value := g_Config.tiAbilIpDamAddValueRate;
  tiAbilIpReduceAddRate.Value := g_Config.tiAbilIpReduceAddRate;
  tiAbilIpReduceAddValueMaxLimit.Value := g_Config.tiAbilIpReduceAddValueMaxLimit;
  tiAbilIpReduceAddValueRate.Value := g_Config.tiAbilIpReduceAddValueRate;
  tiAbilIpDecAddRate.Value := g_Config.tiAbilIpDecAddRate;
  tiAbilIpDecAddValueMaxLimit.Value := g_Config.tiAbilIpDecAddValueMaxLimit;
  tiAbilIpDecAddValueRate.Value := g_Config.tiAbilIpDecAddValueRate;
  tiAbilBangAddRate.Value := g_Config.tiAbilBangAddRate;
  tiAbilBangAddValueMaxLimit.Value := g_Config.tiAbilBangAddValueMaxLimit;
  tiAbilBangAddValueRate.Value := g_Config.tiAbilBangAddValueRate;
  tiAbilGangUpAddRate.Value := g_Config.tiAbilGangUpAddRate;
  tiAbilGangUpAddValueMaxLimit.Value := g_Config.tiAbilGangUpAddValueMaxLimit;
  tiAbilGangUpAddValueRate.Value := g_Config.tiAbilGangUpAddValueRate;
  tiAbilPalsyReduceAddRate.Value := g_Config.tiAbilPalsyReduceAddRate;
  tiAbilPalsyReduceAddValueMaxLimit.Value := g_Config.tiAbilPalsyReduceAddValueMaxLimit;
  tiAbilPalsyReduceAddValueRate.Value := g_Config.tiAbilPalsyReduceAddValueRate;
  tiAbilHPExAddRate.Value := g_Config.tiAbilHPExAddRate;
  tiAbilHPExAddValueMaxLimit.Value := g_Config.tiAbilHPExAddValueMaxLimit;
  tiAbilHPExAddValueRate.Value := g_Config.tiAbilHPExAddValueRate;
  tiAbilMPExAddRate.Value := g_Config.tiAbilMPExAddRate;
  tiAbilMPExAddValueMaxLimit.Value := g_Config.tiAbilMPExAddValueMaxLimit;
  tiAbilMPExAddValueRate.Value := g_Config.tiAbilMPExAddValueRate;
  tiAbilCCAddRate.Value := g_Config.tiAbilCCAddRate;
  tiAbilCCAddValueMaxLimit.Value := g_Config.tiAbilCCAddValueMaxLimit;
  tiAbilCCAddValueRate.Value := g_Config.tiAbilCCAddValueRate;
  tiAbilPoisonReduceAddRate.Value := g_Config.tiAbilPoisonReduceAddRate;
  tiAbilPoisonReduceAddValueMaxLimit.Value := g_Config.tiAbilPoisonReduceAddValueMaxLimit;
  tiAbilPoisonReduceAddValueRate.Value := g_Config.tiAbilPoisonReduceAddValueRate;
  tiAbilPoisonRecoverAddRate.Value := g_Config.tiAbilPoisonRecoverAddRate;
  tiAbilPoisonRecoverAddValueMaxLimit.Value := g_Config.tiAbilPoisonRecoverAddValueMaxLimit;
  tiAbilPoisonRecoverAddValueRate.Value := g_Config.tiAbilPoisonRecoverAddValueRate;

  SpecialSkills1.Value := g_Config.tiSpecialSkills1AddRate;
  SpecialSkills2.Value := g_Config.tiSpecialSkills2AddRate;
  SpecialSkills3.Value := g_Config.tiSpecialSkills3AddRate;
  SpecialSkills4.Value := g_Config.tiSpecialSkills4AddRate;
  SpecialSkills5.Value := g_Config.tiSpecialSkills5AddRate;
  SpecialSkills6.Value := g_Config.tiSpecialSkills6AddRate;
  SpecialSkills7.Value := g_Config.tiSpecialSkills7AddRate;

  tiSpMagicAddMaxLevel.Value := g_Config.tiSpMagicAddMaxLevel;
  tiSpMagicAddRate1.Value := g_Config.tiSpMagicAddRate1;
  tiSpMagicAddRate2.Value := g_Config.tiSpMagicAddRate2;
  tiSpMagicAddRate3.Value := g_Config.tiSpMagicAddRate3;
  tiSpMagicAddRate4.Value := g_Config.tiSpMagicAddRate4;
  tiSpMagicAddRate5.Value := g_Config.tiSpMagicAddRate5;
  tiSpMagicAddRate6.Value := g_Config.tiSpMagicAddRate6;
  tiSpMagicAddRate7.Value := g_Config.tiSpMagicAddRate7;
  tiSpMagicAddRate8.Value := g_Config.tiSpMagicAddRate8;

  cbDieDeductionExp.Checked := g_Config.fDieDeductionExp;
  CheckBoxNoButchItemSubGird.Checked := g_Config.boNoButchItemSubGird;
  EditDiButchItemNeedGird.Value := g_Config.nButchItemNeedGird;
  CheckBoxShowShieldEffect.Checked := g_Config.boShowShieldEffect;
  CheckBoxAutoOpenShield.Checked := g_Config.boAutoOpenShield;

  EditCordialAddHPMax.Value := g_Config.nCordialAddHPMPMax;
  speEatItemsTime.Value := g_Config.nEatItemTime;
  seSetShopNeedLevel.Value := g_Config.SetShopNeedLevel;
  SpinEditGatherExpRate.Value := g_Config.nGatherExpRate;
  SpinEditInternalPowerRate.Value := g_Config.nInternalPowerRate;
  SpinEditInternalPowerRate2.Value := g_Config.nInternalPowerRate2;
  SpinEditInternalPowerSkillRate.Value := g_Config.nInternalPowerSkillRate;

  SpinEditHeroFireSwordTime.Value := g_Config.nHeroFireSwordTime div 1000;
  EditHeroName.Text := g_Config.sHeroName;
  EditHeroSlaveName.Text := g_Config.sHeroSlaveName;
  EditMagNailPowerRate.Value := g_Config.nMagNailPowerRate;
  EditMagIceBallRange.Value := g_Config.nMagIceBallRange;
  EditEarthFirePowerRate.Value := g_Config.nEarthFirePowerRate;
  seMagicShootingStarPowerRate.Value := g_Config.nMagicShootingStarPowerRate;

  CheckBoxMagCapturePlayer.Checked := g_Config.boMagCapturePlayer;
  CheckBoxAllowJointAttack.Checked := g_Config.boAllowJointAttack;

  seSSFreezeRate.Value := g_Config.nSSFreezeRate;
  speSeriesSkillReleaseInvTime.Value := g_Config.nSeriesSkillReleaseInvTime div 1000;
  speSmiteWideHitSkillInvTime.Value := g_Config.nSmiteWideHitSkillInvTime div 1000;
  spePowerRateOfSeriesSkill_100.Value := g_Config.nPowerRateOfSeriesSkill_100;
  spePowerRateOfSeriesSkill_101.Value := g_Config.nPowerRateOfSeriesSkill_101;
  spePowerRateOfSeriesSkill_102.Value := g_Config.nPowerRateOfSeriesSkill_102;
  spePowerRateOfSeriesSkill_103.Value := g_Config.nPowerRateOfSeriesSkill_103;
  spePowerRateOfSeriesSkill_104.Value := g_Config.nPowerRateOfSeriesSkill_104;
  spePowerRateOfSeriesSkill_105.Value := g_Config.nPowerRateOfSeriesSkill_105;
  spePowerRateOfSeriesSkill_106.Value := g_Config.nPowerRateOfSeriesSkill_106;
  spePowerRateOfSeriesSkill_107.Value := g_Config.nPowerRateOfSeriesSkill_107;
  spePowerRateOfSeriesSkill_108.Value := g_Config.nPowerRateOfSeriesSkill_108;
  spePowerRateOfSeriesSkill_109.Value := g_Config.nPowerRateOfSeriesSkill_109;
  spePowerRateOfSeriesSkill_110.Value := g_Config.nPowerRateOfSeriesSkill_110;
  spePowerRateOfSeriesSkill_111.Value := g_Config.nPowerRateOfSeriesSkill_111;
  spePowerRateOfSeriesSkill_114.Value := g_Config.nPowerRateOfSeriesSkill_114;

  cbPosMoveAttackOnItem.Checked := g_Config.fPosMoveAttackOnItem;
  cbPosMoveAttackParalysisPlayer.Checked := g_Config.fPosMoveAttackParalysisPlayer;
  cbMagicIceRainParalysisPlayer.Checked := g_Config.fMagicIceRainParalysisPlayer;
  cbMagicDeadEyeParalysisPlayer.Checked := g_Config.fMagicDeadEyeParalysisPlayer;
  chkMagicDeadEyeRedPosion.Checked := g_Config.fMagicDeadEyeRedPosion;
  chkMagicDeadEyeGreenPosion.Checked := g_Config.fMagicDeadEyeGreenPosion;
  sePosMoveAttackPowerRate.Value := g_Config.nPosMoveAttackPowerRate;
  sePosMoveAttackInterval.Value := g_Config.nPosMoveAttackInterval;
  seMagicIceRainPowerRate.Value := g_Config.nMagicIceRainPowerRate;
  seMagicIceRainInterval.Value := g_Config.nMagicIceRainInterval;
  seMagicDeadEyePowerRate.Value := g_Config.nMagicDeadEyePowerRate;
  seMagicDeadEyeInterval.Value := g_Config.nMagicDeadEyeInterval;
  seMagicDragonRageInterval.Value := g_Config.nMagicDragonRageInterval;
  seMagicDragonRageDuration.Value := g_Config.nMagicDragonRageDuration;
  seMagicDragonRageDamageAdd.Value := g_Config.nMagicDragonRageDamageAdd;


  RadioButtonMag0.Checked := (g_Config.nHeroMainSkill = 0);
  RadioButtonMag12.Checked := (g_Config.nHeroMainSkill = 12);
  RadioButtonMag25.Checked := (g_Config.nHeroMainSkill = 25);
  CheckBoxDoMotaebo.Checked := g_Config.boHeroDoMotaebo;
  CheckBoxHeroNeedAmulet.Checked := g_Config.boHeroNeedAmulet;

  CheckBoxPShowMasterName.Checked := g_Config.boPShowMasterName;
  CheckBoxAllowHeroPickUpItem.Checked := g_Config.boAllowHeroPickUpItem;
  CheckBoxTaosHeroAutoChangePoison.Checked := g_Config.boTaosHeroAutoChangePoison;
  CheckBoxHeroCalcHitSpeed.Checked := g_Config.boCalcHeroHitSpeed;
  CheckBoxHeroKillHumanAddPkPoint.Checked := g_Config.boHeroHomicideAddPKPoint;
  CheckBoxHeroHomicideAddMasterPkPoint.Checked := g_Config.boHeroHomicideAddMasterPkPoint;

  CheckBoxHeroLockTarget.Checked := g_Config.boHeroLockTarget;
  CheckBoxGetFullExp.Checked := g_Config.boGetFullRateExp;
  EditHeroGainExpRate.Enabled := not g_Config.boGetFullRateExp;

  EditHeroNameColor.Value := g_Config.nHeroNameColor;
  EditHeroGainExpRate.Value := g_Config.nHeroGainExpRate;
  EditHeroGainExpRate2.Value := g_Config.nHeroGetExpRate;
  SpinEditShadowExpriesTime.Value := g_Config.nShadowExpriesTime;
  EditRecallHeroIntervalTime.Value := g_Config.nRecallHeroIntervalTime;
  speHeroRecallPneumaTime.Value := g_Config.dwCloneSelfTime div 1000;
  EditHeroHitSpeedMax.Value := g_Config.nHeroHitSpeedMax;

  RefReNewLevelConf();
  RefMonUpgrade();
  RefSpiritMutiny();
  RefMonSayMsg();
  RefWeaponMakeLuck();
end;

procedure TfrmFunctionConfig.Open;
{$IF USEWLSDK = 2}
var
  SELicenseUserInfo: sSELicenseUserInfoA;
  SELicenseTrialInfo: sSELicenseTrialInfo;
{$IFEND USEWLSDK}
begin
  boOpened := False;
  uModValue();
{$IF SERIESSKILL}
  TabSheet41.Caption := '连技设置';
  PageControl2.Visible := True;
{$ELSE}
  TabSheet41.Caption := '其他设置';
  PageControl2.Visible := False;
{$IFEND SERIESSKILL}

{$IF USEWLSDK = 1}
{$I '..\Common\Macros\VMPB.inc'}
  bHook := False;
  sDlls := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('IPLocal.dll mPlugOfScript.dll mPlugOfEngine.dll mSystemModule.dll mPlugOfAccess.dll');
  mHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, GetCurrentProcessId);
  if mHandle <> 0 then
  begin
    FModuleEntry32.dwSize := SizeOf(TModuleEntry32);
    if Module32First(mHandle, FModuleEntry32) then
    begin
      while Module32Next(mHandle, FModuleEntry32) do
      begin
        if LowerCase(Trim(ExtractFilePath(FModuleEntry32.szExePath))) = LowerCase(ExtractFilePath(ParamStr(0))) then
        begin
          if Pos(LowerCase(ExtractFileName(FModuleEntry32.szModule)), LowerCase(sDlls)) <= 0 then
          begin
            bHook := True;
            Break;
          end;
        end;
      end;
    end;
    CloseHandle(mHandle);
  end;

  if not bHook {and not WLProtectCheckCodeIntegrity()} then
  begin
    InitConfig();
  end;
{$I '..\Common\Macros\VMPE.inc'}
{$ELSEIF USEWLSDK = 2}
  //{$I '..\Common\Macros\PROTECT_START2.inc'}
{$I '..\Common\Macros\VMPB.inc'}
  //if SECheckProtection() = 0 then begin
  //if SECheckProtection() {and not VMProtectIsDebuggerPresent(True) and VMProtectIsValidImageCRC()} then begin
  bHook := False;
  sDlls := {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('IPLocal.dll mPlugOfScript.dll mPlugOfEngine.dll mSystemModule.dll mPlugOfAccess.dll');
  mHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, GetCurrentProcessId);
  if mHandle <> 0 then
  begin
    FModuleEntry32.dwSize := SizeOf(TModuleEntry32);
    if Module32First(mHandle, FModuleEntry32) then
    begin
      while Module32Next(mHandle, FModuleEntry32) do
      begin
        if LowerCase(Trim(ExtractFilePath(FModuleEntry32.szExePath))) = LowerCase(ExtractFilePath(ParamStr(0))) then
        begin
          if Pos(LowerCase(ExtractFileName(FModuleEntry32.szModule)), LowerCase(sDlls)) <= 0 then
          begin
            bHook := True;
            Break;
          end;
        end;
      end;
    end;
    CloseHandle(mHandle);
  end;

  if not bHook {and not WLProtectCheckCodeIntegrity()} then
  begin
    InitConfig();
  end;
  //end;
  //{$I '..\Common\Macros\PROTECT_END2.inc'}
{$I '..\Common\Macros\VMPE.inc'}
{$ELSE}
  InitConfig();
{$IFEND USEWLSDK}
  boOpened := True;
  FunctionConfigControl.ActivePageIndex := 0;
  ShowModal;
end;

procedure TfrmFunctionConfig.FormCreate(Sender: TObject);
begin
  {tiLevelHP.Cells[0, 0] := '强身等级';
  tiLevelHP.Cells[1, 0] := '+HP值';
  for i := 1 to tiLevelHP.RowCount - 1 do
    tiLevelHP.Cells[0, i] := IntToStr(i);

  tiLevelMP.Cells[0, 0] := '聚魔等级';
  tiLevelMP.Cells[1, 0] := '+MP值';
  for i := 1 to tiLevelMP.RowCount - 1 do
    tiLevelMP.Cells[0, i] := IntToStr(i);}

  GridBoneFamm.Cells[0, 0] := '人物等级';
  GridBoneFamm.Cells[1, 0] := '怪物名称';
  GridBoneFamm.Cells[2, 0] := '数量';
  GridBoneFamm.Cells[3, 0] := '等级';

  GridDogz.Cells[0, 0] := '人物等级';
  GridDogz.Cells[1, 0] := '怪物名称';
  GridDogz.Cells[2, 0] := '数量';
  GridDogz.Cells[3, 0] := '等级';

  FunctionConfigControl.ActivePageIndex := 0;
  PageControlSkill.ActivePageIndex := 0;
  PageControlMag_Warr.ActivePageIndex := 0;
  PageControlMag_Wizard.ActivePageIndex := 0;
  PageControlMag_Taos.ActivePageIndex := 0;
  PageControlJointAttack.ActivePageIndex := 0;
{$IF (SoftVersion = VERPRO) or (SoftVersion = VERENT)}
  CheckBoxHungerDecPower.Visible := True;
{$ELSE}
  CheckBoxHungerDecPower.Visible := False;
{$IFEND}
{$IF SoftVersion = VERDEMO}
  Caption := '功能设置[演示版本，所有设置调整有效，但不能保存]'
{$IFEND}
end;

procedure TfrmFunctionConfig.CheckBoxEnablePasswordLockClick(
  Sender: TObject);
begin
  case CheckBoxEnablePasswordLock.Checked of
    True:
      begin
        CheckBoxLockGetBackItem.Enabled := True;
        CheckBoxLockLogin.Enabled := True;
      end;
    False:
      begin
        CheckBoxLockGetBackItem.Checked := False;
        CheckBoxLockLogin.Checked := False;
        CheckBoxLockGetBackItem.Enabled := False;
        CheckBoxLockLogin.Enabled := False;
      end;
  end;
  if not boOpened then
    Exit;
  g_Config.boPasswordLockSystem := CheckBoxEnablePasswordLock.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockGetBackItemClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockGetBackItemAction := CheckBoxLockGetBackItem.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockDealItemClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockDealAction := CheckBoxLockDealItem.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockDropItemClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockDropAction := CheckBoxLockDropItem.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockUseItemClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockUserItemAction := CheckBoxLockUseItem.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockLoginClick(Sender: TObject);
begin
  case CheckBoxLockLogin.Checked of //
    True:
      begin
        CheckBoxLockWalk.Enabled := True;
        CheckBoxLockRun.Enabled := True;
        CheckBoxLockHit.Enabled := True;
        CheckBoxLockSpell.Enabled := True;
        CheckBoxLockInObMode.Enabled := True;
        CheckBoxLockSendMsg.Enabled := True;
        CheckBoxLockDealItem.Enabled := True;
        CheckBoxLockDropItem.Enabled := True;
        CheckBoxLockUseItem.Enabled := True;
        CheckBoxLockRecallHero.Checked := True;
      end;
    False:
      begin
        CheckBoxLockWalk.Checked := False;
        CheckBoxLockRun.Checked := False;
        CheckBoxLockHit.Checked := False;
        CheckBoxLockSpell.Checked := False;
        CheckBoxLockInObMode.Checked := False;
        CheckBoxLockSendMsg.Checked := False;
        CheckBoxLockDealItem.Checked := False;
        CheckBoxLockDropItem.Checked := False;
        CheckBoxLockUseItem.Checked := False;
        CheckBoxLockRecallHero.Checked := False;
      end;
  end;
  if not boOpened then
    Exit;
  g_Config.boLockHumanLogin := CheckBoxLockLogin.Checked;
  ModValue();

end;

procedure TfrmFunctionConfig.CheckBoxLockWalkClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockWalkAction := CheckBoxLockWalk.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockRunClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockRunAction := CheckBoxLockRun.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockHitClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockHitAction := CheckBoxLockHit.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockSpellClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockSpellAction := CheckBoxLockSpell.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockSendMsgClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockSendMsgAction := CheckBoxLockSendMsg.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockInObModeClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockInObModeAction := CheckBoxLockInObMode.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditErrorPasswordCountChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nPasswordErrorCountLock := EditErrorPasswordCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxErrorCountKickClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nPasswordErrorCountLock := EditErrorPasswordCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonPasswordLockSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup', 'PasswordLockSystem', g_Config.boPasswordLockSystem);
  Config.WriteBool('Setup', 'PasswordLockDealAction', g_Config.boLockDealAction);
  Config.WriteBool('Setup', 'PasswordLockDropAction', g_Config.boLockDropAction);
  Config.WriteBool('Setup', 'PasswordLockGetBackItemAction', g_Config.boLockGetBackItemAction);
  Config.WriteBool('Setup', 'PasswordLockWalkAction', g_Config.boLockWalkAction);
  Config.WriteBool('Setup', 'PasswordLockRunAction', g_Config.boLockRunAction);
  Config.WriteBool('Setup', 'PasswordLockHitAction', g_Config.boLockHitAction);
  Config.WriteBool('Setup', 'PasswordLockSpellAction', g_Config.boLockSpellAction);
  Config.WriteBool('Setup', 'PasswordLockSendMsgAction', g_Config.boLockSendMsgAction);
  Config.WriteBool('Setup', 'PasswordLockInObModeAction', g_Config.boLockInObModeAction);
  Config.WriteBool('Setup', 'PasswordLockUserItemAction', g_Config.boLockUserItemAction);

  Config.WriteBool('Setup', 'PasswordLockHumanLogin', g_Config.boLockHumanLogin);
  Config.WriteInteger('Setup', 'PasswordErrorCountLock', g_Config.nPasswordErrorCountLock);

{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.RefGeneral();
begin
  EditPKFlagNameColor.Value := g_Config.btPKFlagNameColor;
  EditPKLevel1NameColor.Value := g_Config.btPKLevel1NameColor;
  EditPKLevel2NameColor.Value := g_Config.btPKLevel2NameColor;
  EditAllyAndGuildNameColor.Value := g_Config.btAllyAndGuildNameColor;
  EditWarGuildNameColor.Value := g_Config.btWarGuildNameColor;
  EditInFreePKAreaNameColor.Value := g_Config.btInFreePKAreaNameColor;
  EditHPStoneStart.Value := g_Config.nHPStoneStartRate;
  EditMPStoneStart.Value := g_Config.nMPStoneStartRate;
  EditHPStoneTime.Value := g_Config.nHPStoneIntervalTime div 1000;
  EditMPStoneTime.Value := g_Config.nMPStoneIntervalTime div 1000;
  EditHPStoneAddPoint.Value := g_Config.nHPStoneAddRate;
  EditMPStoneAddPoint.Value := g_Config.nMPStoneAddRate;
  EditHPStoneDecDura.Value := g_Config.nHPStoneDecDura;
  EditMPStoneDecDura.Value := g_Config.nMPStoneDecDura;
end;

procedure TfrmFunctionConfig.CheckBoxHungerSystemClick(Sender: TObject);
begin
  if CheckBoxHungerSystem.Checked then
  begin
    CheckBoxHungerDecHP.Enabled := True;
    CheckBoxHungerDecPower.Enabled := True;
  end
  else
  begin
    CheckBoxHungerDecHP.Checked := False;
    CheckBoxHungerDecPower.Checked := False;
    CheckBoxHungerDecHP.Enabled := False;
    CheckBoxHungerDecPower.Enabled := False;
  end;

  if not boOpened then
    Exit;
  g_Config.boHungerSystem := CheckBoxHungerSystem.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxHungerDecHPClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boHungerDecHP := CheckBoxHungerDecHP.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxHungerDecPowerClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boHungerDecPower := CheckBoxHungerDecPower.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.btnEvaluationSaveClick(Sender: TObject);
begin
  if botiOpenSystem <> g_Config.tiOpenSystem then
  begin
    Config.WriteBool('Setup', 'tiOpenSystem', g_Config.tiOpenSystem);
    FrmDB.LoadItemsDB();
  end;
  Config.WriteBool('Setup', 'tiPutAbilOnce', g_Config.tiPutAbilOnce);
  Config.WriteInteger('Setup', 'DetectItemRate', g_Config.nDetectItemRate);
  Config.WriteInteger('Setup', 'MakeItemButchRate', g_Config.nMakeItemButchRate);
  Config.WriteInteger('Setup', 'MakeItemRate', g_Config.nMakeItemRate);

  Config.WriteInteger('Setup', 'tiSpiritAddRate', g_Config.tiSpiritAddRate);
  Config.WriteInteger('Setup', 'tiSpiritAddValueRate', g_Config.tiSpiritAddValueRate);
  Config.WriteInteger('Setup', 'tiSecretPropertyAddRate', g_Config.tiSecretPropertyAddRate);
  Config.WriteInteger('Setup', 'tiSecretPropertyAddValueMaxLimit', g_Config.tiSecretPropertyAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiSecretPropertyAddValueRate', g_Config.tiSecretPropertyAddValueRate);
  Config.WriteInteger('Setup', 'tiSucessRate', g_Config.tiSucessRate);
  Config.WriteInteger('Setup', 'tiSucessRateEx', g_Config.tiSucessRateEx);
  Config.WriteInteger('Setup', 'tiExchangeItemRate', g_Config.tiExchangeItemRate);
  Config.WriteInteger('Setup', 'spSecretPropertySucessRate', g_Config.spSecretPropertySucessRate);
  Config.WriteInteger('Setup', 'spMakeBookSucessRate', g_Config.spMakeBookSucessRate);
  Config.WriteInteger('Setup', 'spEnergyAddTime', g_Config.spEnergyAddTime);
  Config.WriteBool('Setup', 'tiSpSkillAddHPMax', g_Config.tiSpSkillAddHPMax);
  Config.WriteBool('Setup', 'tiHPSkillAddHPMax', g_Config.tiHPSkillAddHPMax);
  Config.WriteBool('Setup', 'tiMPSkillAddMPMax', g_Config.tiMPSkillAddMPMax);
  Config.WriteInteger('Setup', 'tiAddHealthPlus_0', g_Config.tiAddHealthPlus_0);
  Config.WriteInteger('Setup', 'tiAddHealthPlus_1', g_Config.tiAddHealthPlus_1);
  Config.WriteInteger('Setup', 'tiAddHealthPlus_2', g_Config.tiAddHealthPlus_2);
  Config.WriteInteger('Setup', 'tiAddSpellPlus_0', g_Config.tiAddSpellPlus_0);
  Config.WriteInteger('Setup', 'tiAddSpellPlus_1', g_Config.tiAddSpellPlus_1);
  Config.WriteInteger('Setup', 'tiAddSpellPlus_2', g_Config.tiAddSpellPlus_2);

  Config.WriteInteger('Setup', 'tiWeaponDCAddRate', g_Config.tiWeaponDCAddRate);
  Config.WriteInteger('Setup', 'tiWeaponDCAddValueMaxLimit', g_Config.tiWeaponDCAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWeaponDCAddValueRate', g_Config.tiWeaponDCAddValueRate);
  Config.WriteInteger('Setup', 'tiWeaponMCAddRate', g_Config.tiWeaponMCAddRate);
  Config.WriteInteger('Setup', 'tiWeaponMCAddValueMaxLimit', g_Config.tiWeaponMCAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWeaponMCAddValueRate', g_Config.tiWeaponMCAddValueRate);
  Config.WriteInteger('Setup', 'tiWeaponSCAddRate', g_Config.tiWeaponSCAddRate);
  Config.WriteInteger('Setup', 'tiWeaponSCAddValueMaxLimit', g_Config.tiWeaponSCAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWeaponSCAddValueRate', g_Config.tiWeaponSCAddValueRate);
  Config.WriteInteger('Setup', 'tiWeaponLuckAddRate', g_Config.tiWeaponLuckAddRate);
  Config.WriteInteger('Setup', 'tiWeaponLuckAddValueMaxLimit', g_Config.tiWeaponLuckAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWeaponLuckAddValueRate', g_Config.tiWeaponLuckAddValueRate);
  Config.WriteInteger('Setup', 'tiWeaponCurseAddRate', g_Config.tiWeaponCurseAddRate);
  Config.WriteInteger('Setup', 'tiWeaponCurseAddValueMaxLimit', g_Config.tiWeaponCurseAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWeaponCurseAddValueRate', g_Config.tiWeaponCurseAddValueRate);
  Config.WriteInteger('Setup', 'tiWeaponHitAddRate', g_Config.tiWeaponHitAddRate);
  Config.WriteInteger('Setup', 'tiWeaponHitAddValueMaxLimit', g_Config.tiWeaponHitAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWeaponHitAddValueRate', g_Config.tiWeaponHitAddValueRate);
  Config.WriteInteger('Setup', 'tiWeaponHitSpdAddRate', g_Config.tiWeaponHitSpdAddRate);
  Config.WriteInteger('Setup', 'tiWeaponHitSpdAddValueMaxLimit', g_Config.tiWeaponHitSpdAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWeaponHitSpdAddValueRate', g_Config.tiWeaponHitSpdAddValueRate);
  Config.WriteInteger('Setup', 'tiWeaponHolyAddRate', g_Config.tiWeaponHolyAddRate);
  Config.WriteInteger('Setup', 'tiWeaponHolyAddValueMaxLimit', g_Config.tiWeaponHolyAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWeaponHolyAddValueRate', g_Config.tiWeaponHolyAddValueRate);

  Config.WriteInteger('Setup', 'tiWearingDCAddRate', g_Config.tiWearingDCAddRate);
  Config.WriteInteger('Setup', 'tiWearingDCAddValueMaxLimit', g_Config.tiWearingDCAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingDCAddValueRate', g_Config.tiWearingDCAddValueRate);
  Config.WriteInteger('Setup', 'tiWearingMCAddRate', g_Config.tiWearingMCAddRate);
  Config.WriteInteger('Setup', 'tiWearingMCAddValueMaxLimit', g_Config.tiWearingMCAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingMCAddValueRate', g_Config.tiWearingMCAddValueRate);
  Config.WriteInteger('Setup', 'tiWearingSCAddRate', g_Config.tiWearingSCAddRate);
  Config.WriteInteger('Setup', 'tiWearingSCAddValueMaxLimit', g_Config.tiWearingSCAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingSCAddValueRate', g_Config.tiWearingSCAddValueRate);
  Config.WriteInteger('Setup', 'tiWearingACAddRate', g_Config.tiWearingACAddRate);
  Config.WriteInteger('Setup', 'tiWearingACAddValueMaxLimit', g_Config.tiWearingACAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingACAddValueRate', g_Config.tiWearingACAddValueRate);
  Config.WriteInteger('Setup', 'tiWearingMACAddRate', g_Config.tiWearingMACAddRate);
  Config.WriteInteger('Setup', 'tiWearingMACAddValueMaxLimit', g_Config.tiWearingMACAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingMACAddValueRate', g_Config.tiWearingMACAddValueRate);

  Config.WriteInteger('Setup', 'tiWearingHitAddRate', g_Config.tiWearingHitAddRate);
  Config.WriteInteger('Setup', 'tiWearingHitAddValueMaxLimit', g_Config.tiWearingHitAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingHitAddValueRate', g_Config.tiWearingHitAddValueRate);
  Config.WriteInteger('Setup', 'tiWearingSpeedAddRate', g_Config.tiWearingSpeedAddRate);
  Config.WriteInteger('Setup', 'tiWearingSpeedAddValueMaxLimit', g_Config.tiWearingSpeedAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingSpeedAddValueRate', g_Config.tiWearingSpeedAddValueRate);
  Config.WriteInteger('Setup', 'tiWearingLuckAddRate', g_Config.tiWearingLuckAddRate);
  Config.WriteInteger('Setup', 'tiWearingLuckAddValueMaxLimit', g_Config.tiWearingLuckAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingLuckAddValueRate', g_Config.tiWearingLuckAddValueRate);
  Config.WriteInteger('Setup', 'tiWearingAntiMagicAddRate', g_Config.tiWearingAntiMagicAddRate);
  Config.WriteInteger('Setup', 'tiWearingAntiMagicAddValueMaxLimit', g_Config.tiWearingAntiMagicAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingAntiMagicAddValueRate', g_Config.tiWearingAntiMagicAddValueRate);
  Config.WriteInteger('Setup', 'tiWearingHealthRecoverAddRate', g_Config.tiWearingHealthRecoverAddRate);
  Config.WriteInteger('Setup', 'tiWearingHealthRecoverAddValueMaxLimit', g_Config.tiWearingHealthRecoverAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingHealthRecoverAddValueRate', g_Config.tiWearingHealthRecoverAddValueRate);
  Config.WriteInteger('Setup', 'tiWearingSpellRecoverAddRate', g_Config.tiWearingSpellRecoverAddRate);
  Config.WriteInteger('Setup', 'tiWearingSpellRecoverAddValueMaxLimit', g_Config.tiWearingSpellRecoverAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiWearingSpellRecoverAddValueRate', g_Config.tiWearingSpellRecoverAddValueRate);

  Config.WriteInteger('Setup', 'tiAbilTagDropAddRate', g_Config.tiAbilTagDropAddRate);
  Config.WriteInteger('Setup', 'tiAbilTagDropAddValueMaxLimit', g_Config.tiAbilTagDropAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilTagDropAddValueRate', g_Config.tiAbilTagDropAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilPreDropAddRate', g_Config.tiAbilPreDropAddRate);
  Config.WriteInteger('Setup', 'tiAbilPreDropAddValueMaxLimit', g_Config.tiAbilPreDropAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilPreDropAddValueRate', g_Config.tiAbilPreDropAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilSuckAddRate', g_Config.tiAbilSuckAddRate);
  Config.WriteInteger('Setup', 'tiAbilSuckAddValueMaxLimit', g_Config.tiAbilSuckAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilSuckAddValueRate', g_Config.tiAbilSuckAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilIpRecoverAddRate', g_Config.tiAbilIpRecoverAddRate);
  Config.WriteInteger('Setup', 'tiAbilIpRecoverAddValueMaxLimit', g_Config.tiAbilIpRecoverAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilIpRecoverAddValueRate', g_Config.tiAbilIpRecoverAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilIpExAddRate', g_Config.tiAbilIpExAddRate);
  Config.WriteInteger('Setup', 'tiAbilIpExAddValueMaxLimit', g_Config.tiAbilIpExAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilIpExAddValueRate', g_Config.tiAbilIpExAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilIpDamAddRate', g_Config.tiAbilIpDamAddRate);
  Config.WriteInteger('Setup', 'tiAbilIpDamAddValueMaxLimit', g_Config.tiAbilIpDamAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilIpDamAddValueRate', g_Config.tiAbilIpDamAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilIpReduceAddRate', g_Config.tiAbilIpReduceAddRate);
  Config.WriteInteger('Setup', 'tiAbilIpReduceAddValueMaxLimit', g_Config.tiAbilIpReduceAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilIpReduceAddValueRate', g_Config.tiAbilIpReduceAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilIpDecAddRate', g_Config.tiAbilIpDecAddRate);
  Config.WriteInteger('Setup', 'tiAbilIpDecAddValueMaxLimit', g_Config.tiAbilIpDecAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilIpDecAddValueRate', g_Config.tiAbilIpDecAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilBangAddRate', g_Config.tiAbilBangAddRate);
  Config.WriteInteger('Setup', 'tiAbilBangAddValueMaxLimit', g_Config.tiAbilBangAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilBangAddValueRate', g_Config.tiAbilBangAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilGangUpAddRate', g_Config.tiAbilGangUpAddRate);
  Config.WriteInteger('Setup', 'tiAbilGangUpAddValueMaxLimit', g_Config.tiAbilGangUpAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilGangUpAddValueRate', g_Config.tiAbilGangUpAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilPalsyReduceAddRate', g_Config.tiAbilPalsyReduceAddRate);
  Config.WriteInteger('Setup', 'tiAbilPalsyReduceAddValueMaxLimit', g_Config.tiAbilPalsyReduceAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilPalsyReduceAddValueRate', g_Config.tiAbilPalsyReduceAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilHPExAddRate', g_Config.tiAbilHPExAddRate);
  Config.WriteInteger('Setup', 'tiAbilHPExAddValueMaxLimit', g_Config.tiAbilHPExAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilHPExAddValueRate', g_Config.tiAbilHPExAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilMPExAddRate', g_Config.tiAbilMPExAddRate);
  Config.WriteInteger('Setup', 'tiAbilMPExAddValueMaxLimit', g_Config.tiAbilMPExAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilMPExAddValueRate', g_Config.tiAbilMPExAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilCCAddRate', g_Config.tiAbilCCAddRate);
  Config.WriteInteger('Setup', 'tiAbilCCAddValueMaxLimit', g_Config.tiAbilCCAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilCCAddValueRate', g_Config.tiAbilCCAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilPoisonReduceAddRate', g_Config.tiAbilPoisonReduceAddRate);
  Config.WriteInteger('Setup', 'tiAbilPoisonReduceAddValueMaxLimit', g_Config.tiAbilPoisonReduceAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilPoisonReduceAddValueRate', g_Config.tiAbilPoisonReduceAddValueRate);
  Config.WriteInteger('Setup', 'tiAbilPoisonRecoverAddRate', g_Config.tiAbilPoisonRecoverAddRate);
  Config.WriteInteger('Setup', 'tiAbilPoisonRecoverAddValueMaxLimit', g_Config.tiAbilPoisonRecoverAddValueMaxLimit);
  Config.WriteInteger('Setup', 'tiAbilPoisonRecoverAddValueRate', g_Config.tiAbilPoisonRecoverAddValueRate);

  Config.WriteInteger('Setup', 'tiSpecialSkills1AddRate', g_Config.tiSpecialSkills1AddRate);
  Config.WriteInteger('Setup', 'tiSpecialSkills2AddRate', g_Config.tiSpecialSkills2AddRate);
  Config.WriteInteger('Setup', 'tiSpecialSkills3AddRate', g_Config.tiSpecialSkills3AddRate);
  Config.WriteInteger('Setup', 'tiSpecialSkills4AddRate', g_Config.tiSpecialSkills4AddRate);
  Config.WriteInteger('Setup', 'tiSpecialSkills5AddRate', g_Config.tiSpecialSkills5AddRate);
  Config.WriteInteger('Setup', 'tiSpecialSkills6AddRate', g_Config.tiSpecialSkills6AddRate);
  Config.WriteInteger('Setup', 'tiSpecialSkills7AddRate', g_Config.tiSpecialSkills7AddRate);

  Config.WriteBool('Setup', 'tiSpMagicAddAtFirst', g_Config.tiSpMagicAddAtFirst);
  Config.WriteInteger('Setup', 'tiSpMagicAddMaxLevel', g_Config.tiSpMagicAddMaxLevel);
  Config.WriteInteger('Setup', 'tiSpMagicAddRate1', g_Config.tiSpMagicAddRate1);
  Config.WriteInteger('Setup', 'tiSpMagicAddRate2', g_Config.tiSpMagicAddRate2);
  Config.WriteInteger('Setup', 'tiSpMagicAddRate3', g_Config.tiSpMagicAddRate3);
  Config.WriteInteger('Setup', 'tiSpMagicAddRate4', g_Config.tiSpMagicAddRate4);
  Config.WriteInteger('Setup', 'tiSpMagicAddRate5', g_Config.tiSpMagicAddRate5);
  Config.WriteInteger('Setup', 'tiSpMagicAddRate6', g_Config.tiSpMagicAddRate6);
  Config.WriteInteger('Setup', 'tiSpMagicAddRate7', g_Config.tiSpMagicAddRate7);
  Config.WriteInteger('Setup', 'tiSpMagicAddRate8', g_Config.tiSpMagicAddRate8);
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonGeneralSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup', 'HungerSystem', g_Config.boHungerSystem);
  Config.WriteBool('Setup', 'HungerDecHP', g_Config.boHungerDecHP);
  Config.WriteBool('Setup', 'HungerDecPower', g_Config.boHungerDecPower);
  Config.WriteBool('Setup', 'EnableMapEvent', g_Config.boEnableMapEvent);
  Config.WriteBool('Setup', 'ShowShieldEffect', g_Config.boShowShieldEffect);
  Config.WriteBool('Setup', 'AutoOpenShield', g_Config.boAutoOpenShield);

  Config.WriteInteger('Setup', 'PKFlagNameColor', g_Config.btPKFlagNameColor);
  Config.WriteInteger('Setup', 'AllyAndGuildNameColor', g_Config.btAllyAndGuildNameColor);
  Config.WriteInteger('Setup', 'WarGuildNameColor', g_Config.btWarGuildNameColor);
  Config.WriteInteger('Setup', 'InFreePKAreaNameColor', g_Config.btInFreePKAreaNameColor);
  Config.WriteInteger('Setup', 'PKLevel1NameColor', g_Config.btPKLevel1NameColor);
  Config.WriteInteger('Setup', 'PKLevel2NameColor', g_Config.btPKLevel2NameColor);

  Config.WriteInteger('Setup', 'HPStoneStartRate', g_Config.nHPStoneStartRate);
  Config.WriteInteger('Setup', 'MPStoneStartRate', g_Config.nMPStoneStartRate);
  Config.WriteInteger('Setup', 'HPStoneIntervalTime', g_Config.nHPStoneIntervalTime);
  Config.WriteInteger('Setup', 'MPStoneIntervalTime', g_Config.nMPStoneIntervalTime);
  Config.WriteInteger('Setup', 'HPStoneAddRate', g_Config.nHPStoneAddRate);
  Config.WriteInteger('Setup', 'MPStoneAddRate', g_Config.nMPStoneAddRate);
  Config.WriteInteger('Setup', 'HPStoneDecDura', g_Config.nHPStoneDecDura);
  Config.WriteInteger('Setup', 'MPStoneDecDura', g_Config.nMPStoneDecDura);
  Config.WriteBool('Setup', 'FireBurnEventOff', g_Config.boFireBurnEventOff);
  Config.WriteBool('Setup', 'ClientAutoPlay', g_Config.boClientAutoPlay);
  Config.WriteBool('Setup', 'HeroSystem', g_Config.boHeroSystem);

  Config.WriteBool('Setup', 'SpeedCtrl', g_Config.boSpeedCtrl);
  Config.WriteBool('Setup', 'boRecallHeroCtrl', g_Config.boRecallHeroCtrl);
  Config.WriteBool('Setup', 'EffectHeroDropRate', g_Config.EffectHeroDropRate);
  Config.WriteBool('Setup', 'ClientAotoLongAttack', g_Config.ClientAotoLongAttack);
  Config.WriteBool('Setup', 'ClientAutoSay', g_Config.ClientAutoSay);
  Config.WriteBool('Setup', 'MutiHero', g_Config.cbMutiHero);
  Config.WriteBool('Setup', 'SmiteDamegeShow', g_Config.cbSmiteDamegeShow);
  Config.WriteBool('Setup', 'JointStrikeUI', g_Config.boJointStrikeUI);
  Config.WriteBool('Setup', 'OpenFindPathMyMap', g_Config.boOpenFindPathMyMap);
  Config.WriteBool('Setup', 'StallSystem', g_Config.boStallSystem);
  Config.WriteBool('Setup', 'ClientNoFog', g_Config.boClientNoFog);
  Config.WriteBool('Setup', 'DeathWalking', g_Config.DeathWalking);

  Config.WriteBool('Setup', 'ExtendStorage', g_Config.boExtendStorage);
  Config.WriteBool('Setup', 'MonSayMsg', g_Config.boMonSayMsg);
  Config.WriteInteger('Setup', 'EatItemTime', g_Config.nEatItemTime);
  Config.WriteInteger('Setup', 'SetShopNeedLevel', g_Config.SetShopNeedLevel);

  Config.WriteInteger('Setup', 'CordialAddHPMPMax', g_Config.nCordialAddHPMPMax);
  Config.WriteInteger('Setup', 'GatherExpRate', g_Config.nGatherExpRate);
  Config.WriteInteger('Setup', 'InternalPowerRate', g_Config.nInternalPowerRate);
  Config.WriteInteger('Setup', 'InternalPowerRate2', g_Config.nInternalPowerRate2);
  Config.WriteInteger('Setup', 'InternalPowerSkillRate', g_Config.nInternalPowerSkillRate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.EditMagicAttackRageChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagicAttackRage := EditMagicAttackRage.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.RefMagicSkill;
begin
  SpinEditMagNailTime.Value := g_Config.dwMagNailTick;
  EditSwordLongPowerRate.Value := g_Config.nSwordLongPowerRate;

  EditEnergyStepUpRate.Value := g_Config.nEnergyStepUpRate;
  EditSkillWWPowerRate.Value := g_Config.nSkillWWPowerRate;
  EditSkillTWPowerRate.Value := g_Config.nSkillTWPowerRate;
  EditSkillZWPowerRate.Value := g_Config.nSkillZWPowerRate;
  EditSkillTTPowerRate.Value := g_Config.nSkillTTPowerRate;
  EditSkillZTPowerRate.Value := g_Config.nSkillZTPowerRate;
  EditSkillZZPowerRate.Value := g_Config.nSkillZZPowerRate;

  CheckBoxNoDoubleFireHit.Checked := g_Config.boNoDoubleFireHit;

  cbTDBeffect.Checked := g_Config.boTDBeffect;
  cbLimitSquAttack.Checked := g_Config.boLimitSquAttack;
  SpinEditFireHitPowerRate.Value := g_Config.nFireHitPowerRate;
  seTwinPowerRate.Value := g_Config.nMagTwinPowerRate;
  seMagSquPowerRate.Value := g_Config.nMagSquPowerRate;

  seSmiteLongHit2PowerRate.Value := g_Config.SmiteLongHit2PowerRate;
  seSuperSkillInvTime.Value := g_Config.SuperSkillInvTime;

  sePowerRate_115.Value := g_Config.ssPowerRate_115;
  nSuperSkill68InvTime.Value := g_Config.nSuperSkill68InvTime;
  IceMonLiveTime.Value := g_Config.IceMonLiveTime;
  Skill77Time.Value := g_Config.Skill77Time;
  Skill77Inv.Value := g_Config.Skill77Inv;
  Skill77PowerRate.Value := g_Config.Skill77PowerRate;
  SkillMedusaEyeEffectTimeMax.Value := g_Config.SkillMedusaEyeEffectTimeMax;

  seDoMotaeboPauseTime.Value := g_Config.PushedPauseTime;

  cbNoDoublePursueHit.Checked := g_Config.boNoDoublePursueHit;
  SpinEditPursueHitPowerRate.Value := g_Config.nPursueHitPowerRate;
  seSquareHitPowerRate.Value := g_Config.nSquareHitPowerRate;

  CheckBoxLimitSwordLong.Checked := g_Config.boLimitSwordLong;
  EditFireBoomRage.Value := g_Config.nFireBoomRage;
  EditSnowWindRange.Value := g_Config.nSnowWindRange;
  EditElecBlizzardRange.Value := g_Config.nElecBlizzardRange;
  EditMagicAttackRage.Value := g_Config.nMagicAttackRage;
  EditAmyOunsulPoint.Value := g_Config.nAmyOunsulPoint;
  EditMagTurnUndeadLevel.Value := g_Config.nMagTurnUndeadLevel;

  SpinEditMagBubbleDefenceRate.Value := g_Config.nMagBubbleDefenceRate;
  seShieldHoldTime.Value := g_Config.nFireBurnHoldTime div 1000;

  EditMagTammingLevel.Value := g_Config.nMagTammingLevel;
  EditMagTammingTargetLevel.Value := g_Config.nMagTammingTargetLevel;
  EditMagTammingHPRate.Value := g_Config.nMagTammingHPRate;
  EditTammingCount.Value := g_Config.nMagTammingCount;
  EditMabMabeHitRandRate.Value := g_Config.nMabMabeHitRandRate;
  EditMabMabeHitMinLvLimit.Value := g_Config.nMabMabeHitMinLvLimit;
  EditMabMabeHitSucessRate.Value := g_Config.nMabMabeHitSucessRate;
  EditMabMabeHitMabeTimeRate.Value := g_Config.nMabMabeHitMabeTimeRate;
  CheckBoxFireCrossInSafeZone.Checked := g_Config.boDisableInSafeZoneFireCross;
  CheckBoxGroupMbAttackPlayObject.Checked := g_Config.boGroupMbAttackPlayObject;
  CheckBoxGroupMbAttackBaobao.Checked := g_Config.boGroupMbAttackBaoBao;
  CheckBoxMagCanHitTarget.Checked := g_Config.boMagCanHitTarget;
  CheckBoxIgnoreTagDefence.Checked := g_Config.boIgnoreTagDefence;
  CheckBoxIgnoreTagDefence2.Checked := g_Config.boIgnoreTagDefence2;
  cbLargeMagicRange.Checked := g_Config.LargeMagicRange;

end;

procedure TfrmFunctionConfig.EditBoneFammCountChange(Sender: TObject);
begin
  if not boOpened then
    Exit;

  if Sender = seDoubleScRate then
    g_Config.nDoubleScRate := seDoubleScRate.Value
  else if Sender = seBoneFammDcEx then
    g_Config.nBoneFammDcEx := seBoneFammDcEx.Value
  else if Sender = seDoubleScInvTime then
    g_Config.DoubleScInvTime := seDoubleScInvTime.Value

  else if Sender = seDogzDcEx then
    g_Config.nDogzDcEx := seDogzDcEx.Value
  else if Sender = seAngelDcEx then
    g_Config.nAngelDcEx := seAngelDcEx.Value
  else if Sender = seMagSuckHpRate then
    g_Config.nMagSuckHpRate := seMagSuckHpRate.Value
  else if Sender = seMagSuckHpPowerRate then
    g_Config.nMagSuckHpPowerRate := seMagSuckHpPowerRate.Value
  else
    g_Config.nBoneFammCount := EditBoneFammCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditDogzCountChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nDogzCount := EditDogzCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLimitSwordLongClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLimitSwordLong := CheckBoxLimitSwordLong.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSwordLongPowerRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nSwordLongPowerRate := EditSwordLongPowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditBoneFammNameChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  ModValue();
end;

procedure TfrmFunctionConfig.EditDogzNameChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  ModValue();
end;

procedure TfrmFunctionConfig.EditFireBoomRageChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nFireBoomRage := EditFireBoomRage.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSnowWindRangeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nSnowWindRange := EditSnowWindRange.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditElecBlizzardRangeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nElecBlizzardRange := EditElecBlizzardRange.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTurnUndeadLevelChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if EditMagTurnUndeadLevel = Sender then
    g_Config.nMagTurnUndeadLevel := EditMagTurnUndeadLevel.Value
  else if seShieldHoldTime = Sender then
    g_Config.nFireBurnHoldTime := seShieldHoldTime.Value * 1000
  else
    g_Config.nMagBubbleDefenceRate := SpinEditMagBubbleDefenceRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.GridBoneFammSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  if not boOpened then
    Exit;
  ModValue();
end;

procedure TfrmFunctionConfig.EditAmyOunsulPointChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nAmyOunsulPoint := EditAmyOunsulPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxFireCrossInSafeZoneClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boDisableInSafeZoneFireCross := CheckBoxFireCrossInSafeZone.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxGroupMbAttackPlayObjectClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boGroupMbAttackPlayObject := CheckBoxGroupMbAttackPlayObject.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonSkillSaveClick(Sender: TObject);
var
  i: Integer;
  RecallArray: array[0..9] of TRecallMigic;
  Rect: TGridRect;
begin
  FillChar(RecallArray, SizeOf(RecallArray), #0);

  g_Config.sBoneFamm := Trim(EditBoneFammName.Text);
  g_Config.sDogz := Trim(EditDogzName.Text);

  for i := Low(RecallArray) to High(RecallArray) do
  begin
    RecallArray[i].nHumLevel := Str_ToInt(GridBoneFamm.Cells[0, i + 1], -1);
    RecallArray[i].sMonName := Trim(GridBoneFamm.Cells[1, i + 1]);
    RecallArray[i].nCount := Str_ToInt(GridBoneFamm.Cells[2, i + 1], -1);
    RecallArray[i].nLevel := Str_ToInt(GridBoneFamm.Cells[3, i + 1], -1);
    if GridBoneFamm.Cells[0, i + 1] = '' then
      Break;
    if (RecallArray[i].nHumLevel <= 0) then
    begin
      Application.MessageBox('人物等级设置错误', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 0;
      Rect.Top := i + 1;
      Rect.Right := 0;
      Rect.Bottom := i + 1;
      GridBoneFamm.Selection := Rect;
      Exit;
    end;
    if UserEngine.GetMonRace(RecallArray[i].sMonName) <= 0 then
    begin
      Application.MessageBox('怪物名称设置错误，请查看DB库是否有对应的怪物', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 1;
      Rect.Top := i + 1;
      Rect.Right := 1;
      Rect.Bottom := i + 1;
      GridBoneFamm.Selection := Rect;
      Exit;
    end;
    if RecallArray[i].nCount <= 0 then
    begin
      Application.MessageBox('召唤数量设置错误', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 2;
      Rect.Top := i + 1;
      Rect.Right := 2;
      Rect.Bottom := i + 1;
      GridBoneFamm.Selection := Rect;
      Exit;
    end;
    if RecallArray[i].nLevel < 0 then
    begin
      Application.MessageBox('召唤等级设置错误', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 3;
      Rect.Top := i + 1;
      Rect.Right := 3;
      Rect.Bottom := i + 1;
      GridBoneFamm.Selection := Rect;
      Exit;
    end;
  end;

  for i := Low(RecallArray) to High(RecallArray) do
  begin
    RecallArray[i].nHumLevel := Str_ToInt(GridDogz.Cells[0, i + 1], -1);
    RecallArray[i].sMonName := Trim(GridDogz.Cells[1, i + 1]);
    RecallArray[i].nCount := Str_ToInt(GridDogz.Cells[2, i + 1], -1);
    RecallArray[i].nLevel := Str_ToInt(GridDogz.Cells[3, i + 1], -1);
    if GridDogz.Cells[0, i + 1] = '' then
      Break;
    if (RecallArray[i].nHumLevel <= 0) then
    begin
      Application.MessageBox('人物等级设置错误', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 0;
      Rect.Top := i + 1;
      Rect.Right := 0;
      Rect.Bottom := i + 1;
      GridDogz.Selection := Rect;
      Exit;
    end;
    if UserEngine.GetMonRace(RecallArray[i].sMonName) <= 0 then
    begin
      Application.MessageBox('怪物名称设置错误，请查看DB库是否有对应的怪物', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 1;
      Rect.Top := i + 1;
      Rect.Right := 1;
      Rect.Bottom := i + 1;
      GridDogz.Selection := Rect;
      Exit;
    end;
    if RecallArray[i].nCount <= 0 then
    begin
      Application.MessageBox('召唤数量设置错误', '错误信息', MB_OK +
        MB_ICONERROR);
      Rect.Left := 2;
      Rect.Top := i + 1;
      Rect.Right := 2;
      Rect.Bottom := i + 1;
      GridDogz.Selection := Rect;
      Exit;
    end;
    if RecallArray[i].nLevel < 0 then
    begin
      Application.MessageBox('召唤等级设置错误', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 3;
      Rect.Top := i + 1;
      Rect.Right := 3;
      Rect.Bottom := i + 1;
      GridDogz.Selection := Rect;
      Exit;
    end;
  end;
  FillChar(g_Config.BoneFammArray, SizeOf(g_Config.BoneFammArray), #0);

  for i := Low(g_Config.BoneFammArray) to High(g_Config.BoneFammArray) do
  begin
    Config.WriteInteger('Setup', 'BoneFammHumLevel' + IntToStr(i), 0);
    Config.WriteString('Names', 'BoneFamm' + IntToStr(i), '');
    Config.WriteInteger('Setup', 'BoneFammCount' + IntToStr(i), 0);
    Config.WriteInteger('Setup', 'BoneFammLevel' + IntToStr(i), 0);
  end;

  for i := Low(g_Config.BoneFammArray) to High(g_Config.BoneFammArray) do
  begin
    if GridBoneFamm.Cells[0, i + 1] = '' then
      Break;
    g_Config.BoneFammArray[i].nHumLevel := Str_ToInt(GridBoneFamm.Cells[0, i + 1], -1);
    g_Config.BoneFammArray[i].sMonName := Trim(GridBoneFamm.Cells[1, i + 1]);
    g_Config.BoneFammArray[i].nCount := Str_ToInt(GridBoneFamm.Cells[2, i + 1], -1);
    g_Config.BoneFammArray[i].nLevel := Str_ToInt(GridBoneFamm.Cells[3, i + 1], -1);

    Config.WriteInteger('Setup', 'BoneFammHumLevel' + IntToStr(i), g_Config.BoneFammArray[i].nHumLevel);
    Config.WriteString('Names', 'BoneFamm' + IntToStr(i), g_Config.BoneFammArray[i].sMonName);
    Config.WriteInteger('Setup', 'BoneFammCount' + IntToStr(i), g_Config.BoneFammArray[i].nCount);
    Config.WriteInteger('Setup', 'BoneFammLevel' + IntToStr(i), g_Config.BoneFammArray[i].nLevel);
  end;

  FillChar(g_Config.DogzArray, SizeOf(g_Config.DogzArray), #0);
  for i := Low(g_Config.DogzArray) to High(g_Config.DogzArray) do
  begin
    Config.WriteInteger('Setup', 'DogzHumLevel' + IntToStr(i), 0);
    Config.WriteString('Names', 'Dogz' + IntToStr(i), '');
    Config.WriteInteger('Setup', 'DogzCount' + IntToStr(i), 0);
    Config.WriteInteger('Setup', 'DogzLevel' + IntToStr(i), 0);
  end;
  for i := Low(g_Config.DogzArray) to High(g_Config.DogzArray) do
  begin
    if GridDogz.Cells[0, i + 1] = '' then
      Break;
    g_Config.DogzArray[i].nHumLevel := Str_ToInt(GridDogz.Cells[0, i + 1], -1);
    g_Config.DogzArray[i].sMonName := Trim(GridDogz.Cells[1, i + 1]);
    g_Config.DogzArray[i].nCount := Str_ToInt(GridDogz.Cells[2, i + 1], -1);
    g_Config.DogzArray[i].nLevel := Str_ToInt(GridDogz.Cells[3, i + 1], -1);
    Config.WriteInteger('Setup', 'DogzHumLevel' + IntToStr(i), g_Config.DogzArray[i].nHumLevel);
    Config.WriteString('Names', 'Dogz' + IntToStr(i), g_Config.DogzArray[i].sMonName);
    Config.WriteInteger('Setup', 'DogzCount' + IntToStr(i), g_Config.DogzArray[i].nCount);
    Config.WriteInteger('Setup', 'DogzLevel' + IntToStr(i), g_Config.DogzArray[i].nLevel);
  end;

{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup', 'Skill_68_MP', g_Config.boSkill_68_MP);
  Config.WriteInteger('Setup', 'MagNailTick', g_Config.dwMagNailTick);
  Config.WriteBool('Setup', 'LimitSwordLong', g_Config.boLimitSwordLong);
  Config.WriteInteger('Setup', 'SwordLongPowerRate', g_Config.nSwordLongPowerRate);

  Config.WriteInteger('Setup', 'EnergyStepUpRate', g_Config.nEnergyStepUpRate);
  Config.WriteInteger('Setup', 'SkillWWPowerRate', g_Config.nSkillWWPowerRate);
  Config.WriteInteger('Setup', 'SkillTWPowerRate', g_Config.nSkillTWPowerRate);
  Config.WriteInteger('Setup', 'SkillZWPowerRate', g_Config.nSkillZWPowerRate);
  Config.WriteInteger('Setup', 'SkillTTPowerRate', g_Config.nSkillTTPowerRate);
  Config.WriteInteger('Setup', 'SkillZTPowerRate', g_Config.nSkillZTPowerRate);
  Config.WriteInteger('Setup', 'SkillZZPowerRate', g_Config.nSkillZZPowerRate);

  Config.WriteInteger('Setup', 'FireHitPowerRate', g_Config.nFireHitPowerRate);
  Config.WriteInteger('Setup', 'nMagTwinPowerRate', g_Config.nMagTwinPowerRate);
  Config.WriteInteger('Setup', 'nMagSquPowerRate', g_Config.nMagSquPowerRate);
  Config.WriteInteger('Setup', 'SmiteLongHit2PowerRate', g_Config.SmiteLongHit2PowerRate);
  Config.WriteInteger('Setup', 'SuperSkillInvTime', g_Config.SuperSkillInvTime);
  Config.WriteInteger('Setup', 'ssPowerRate_115', g_Config.ssPowerRate_115);
  Config.WriteInteger('Setup', 'nSuperSkill68InvTime', g_Config.nSuperSkill68InvTime);
  Config.WriteInteger('Setup', 'IceMonLiveTime', g_Config.IceMonLiveTime);
  Config.WriteInteger('Setup', 'Skill77Time', g_Config.Skill77Time);
  Config.WriteInteger('Setup', 'Skill77Inv', g_Config.Skill77Inv);
  Config.WriteInteger('Setup', 'Skill77PowerRate', g_Config.Skill77PowerRate);

  Config.WriteInteger('Setup', 'SkillMedusaEyeEffectTimeMax', g_Config.SkillMedusaEyeEffectTimeMax);

  Config.WriteInteger('Setup', 'PushedPauseTime', g_Config.PushedPauseTime);

  Config.WriteBool('Setup', 'NoDoubleFireHit', g_Config.boNoDoubleFireHit);
  Config.WriteBool('Setup', 'boTDBeffect', g_Config.boTDBeffect);
  Config.WriteBool('Setup', 'SquAttackLimit', g_Config.boLimitSquAttack);
  Config.WriteInteger('Setup', 'PursueHitPowerRate', g_Config.nPursueHitPowerRate);
  Config.WriteBool('Setup', 'NoDoublePursueHit', g_Config.boNoDoublePursueHit);
  Config.WriteInteger('Setup', 'SquareHitPowerRate', g_Config.nSquareHitPowerRate);

  Config.WriteInteger('Setup', 'BoneFammCount', g_Config.nBoneFammCount);
  Config.WriteString('Names', 'BoneFamm', g_Config.sBoneFamm);
  Config.WriteInteger('Setup', 'BodyCount', g_Config.nBodyCount);
  Config.WriteBool('Setup', 'AllowBodyMakeSlave', g_Config.boAllowBodyMakeSlave);

  Config.WriteInteger('Setup', 'DoubleScInvTime', g_Config.DoubleScInvTime);
  Config.WriteInteger('Setup', 'BoneFammDcEx', g_Config.nBoneFammDcEx);
  Config.WriteInteger('Setup', 'DogzDcEx', g_Config.nDogzDcEx);
  Config.WriteInteger('Setup', 'AngelDcEx', g_Config.nAngelDcEx);
  Config.WriteInteger('Setup', 'MagSuckHpRate', g_Config.nMagSuckHpRate);
  Config.WriteInteger('Setup', 'MagSuckHpPowerRate', g_Config.nMagSuckHpPowerRate);
  Config.WriteInteger('Setup', 'nDoubleScRate', g_Config.nDoubleScRate);

  Config.WriteString('Names', 'Body', g_Config.sBody);
  Config.WriteInteger('Setup', 'DogzCount', g_Config.nDogzCount);
  Config.WriteString('Names', 'Dogz', g_Config.sDogz);
  Config.WriteInteger('Setup', 'FireBoomRage', g_Config.nFireBoomRage);
  Config.WriteInteger('Setup', 'SnowWindRange', g_Config.nSnowWindRange);
  Config.WriteInteger('Setup', 'ElecBlizzardRange', g_Config.nElecBlizzardRange);
  Config.WriteInteger('Setup', 'AmyOunsulPoint', g_Config.nAmyOunsulPoint);

  Config.WriteInteger('Setup', 'MagicAttackRage', g_Config.nMagicAttackRage);
  Config.WriteInteger('Setup', 'MagTurnUndeadLevel', g_Config.nMagTurnUndeadLevel);
  Config.WriteInteger('Setup', 'MagBubbleDefenceRate', g_Config.nMagBubbleDefenceRate);
  Config.WriteInteger('Setup', 'ShieldHoldTime', g_Config.nFireBurnHoldTime);

  Config.WriteInteger('Setup', 'MagTammingLevel', g_Config.nMagTammingLevel);
  Config.WriteInteger('Setup', 'MagTammingTargetLevel', g_Config.nMagTammingTargetLevel);
  Config.WriteInteger('Setup', 'MagTammingTargetHPRate', g_Config.nMagTammingHPRate);
  Config.WriteInteger('Setup', 'MagTammingCount', g_Config.nMagTammingCount);

  Config.WriteInteger('Setup', 'MabMabeHitRandRate', g_Config.nMabMabeHitRandRate);
  Config.WriteInteger('Setup', 'MabMabeHitMinLvLimit', g_Config.nMabMabeHitMinLvLimit);
  Config.WriteInteger('Setup', 'MabMabeHitSucessRate', g_Config.nMabMabeHitSucessRate);
  Config.WriteInteger('Setup', 'MabMabeHitMabeTimeRate', g_Config.nMabMabeHitMabeTimeRate);

  Config.WriteBool('Setup', 'DisableInSafeZoneFireCross', g_Config.boDisableInSafeZoneFireCross);
  Config.WriteBool('Setup', 'GroupMbAttackPlayObject', g_Config.boGroupMbAttackPlayObject);
  Config.WriteBool('Setup', 'GroupMbAttackBaoBao', g_Config.boGroupMbAttackBaoBao);
  Config.WriteBool('Setup', 'MagCanHitTarget', g_Config.boMagCanHitTarget);
  Config.WriteBool('Setup', 'LargeMagicRange', g_Config.LargeMagicRange);
  Config.WriteBool('Setup', 'IgnoreTagDefence', g_Config.boIgnoreTagDefence);
  Config.WriteBool('Setup', 'IgnoreTagDefence2', g_Config.boIgnoreTagDefence2);

  Config.WriteInteger('Setup', 'MagNailPowerRate', g_Config.nMagNailPowerRate);
  Config.WriteInteger('Setup', 'MagIceBallRange', g_Config.nMagIceBallRange);
  Config.WriteInteger('Setup', 'EarthFirePowerRate', g_Config.nEarthFirePowerRate);
  Config.WriteInteger('Setup', 'MagicShootingStarPowerRate', g_Config.nMagicShootingStarPowerRate);

  Config.WriteBool('Setup', 'MagCapturePlayer', g_Config.boMagCapturePlayer);
  Config.WriteBool('Setup', 'AllowJointAttack', g_Config.boAllowJointAttack);

  Config.WriteInteger('Setup', 'nSSFreezeRate', g_Config.nSSFreezeRate);
  Config.WriteInteger('Setup', 'SeriesSkillReleaseInvTime', g_Config.nSeriesSkillReleaseInvTime);
  Config.WriteInteger('Setup', 'SmiteWideHitSkillInvTime', g_Config.nSmiteWideHitSkillInvTime);

  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_100', g_Config.nPowerRateOfSeriesSkill_100);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_101', g_Config.nPowerRateOfSeriesSkill_101);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_102', g_Config.nPowerRateOfSeriesSkill_102);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_103', g_Config.nPowerRateOfSeriesSkill_103);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_104', g_Config.nPowerRateOfSeriesSkill_104);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_105', g_Config.nPowerRateOfSeriesSkill_105);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_106', g_Config.nPowerRateOfSeriesSkill_106);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_107', g_Config.nPowerRateOfSeriesSkill_107);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_108', g_Config.nPowerRateOfSeriesSkill_108);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_109', g_Config.nPowerRateOfSeriesSkill_109);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_110', g_Config.nPowerRateOfSeriesSkill_110);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_111', g_Config.nPowerRateOfSeriesSkill_111);
  Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_114', g_Config.nPowerRateOfSeriesSkill_114);

  Config.WriteBool('Setup', 'Skill_114_MP', g_Config.boSkill_114_MP);

  Config.WriteBool('Setup', 'PosMoveAttackOnItem', g_Config.fPosMoveAttackOnItem);
  Config.WriteBool('Setup', 'PosMoveAttackParalysisPlayer', g_Config.fPosMoveAttackParalysisPlayer);
  Config.WriteBool('Setup', 'MagicIceRainParalysisPlayer', g_Config.fMagicIceRainParalysisPlayer);
  Config.WriteBool('Setup', 'MagicDeadEyeParalysisPlayer', g_Config.fMagicDeadEyeParalysisPlayer);
  Config.WriteBool('Setup', 'MagicDeadEyeRedPosion', g_Config.fMagicDeadEyeRedPosion);
  Config.WriteBool('Setup', 'MagicDeadEyeGreenPosion', g_Config.fMagicDeadEyeGreenPosion);
  Config.WriteInteger('Setup', 'PosMoveAttackPowerRate', g_Config.nPosMoveAttackPowerRate);
  Config.WriteInteger('Setup', 'PosMoveAttackInterval', g_Config.nPosMoveAttackInterval);
  Config.WriteInteger('Setup', 'MagicIceRainPowerRate', g_Config.nMagicIceRainPowerRate);
  Config.WriteInteger('Setup', 'MagicIceRainInterval', g_Config.nMagicIceRainInterval);
  Config.WriteInteger('Setup', 'MagicDeadEyePowerRate', g_Config.nMagicDeadEyePowerRate);
  Config.WriteInteger('Setup', 'MagicDeadEyeInterval', g_Config.nMagicDeadEyeInterval);
  Config.WriteInteger('Setup', 'MagicDragonRageInterval', g_Config.nMagicDragonRageInterval);
  Config.WriteInteger('Setup', 'MagicDragonRageDuration', g_Config.nMagicDragonRageDuration);
  Config.WriteInteger('Setup', 'MagicDragonRageDamageAdd', g_Config.nMagicDragonRageDamageAdd);

  Config.WriteInteger('Setup', 'HealingRate', g_Config.nHealingRate);


{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.RefUpgradeWeapon();
begin
  ScrollBarUpgradeWeaponDCRate.Position := g_Config.nUpgradeWeaponDCRate;
  ScrollBarUpgradeWeaponDCTwoPointRate.Position := g_Config.nUpgradeWeaponDCTwoPointRate;
  ScrollBarUpgradeWeaponDCThreePointRate.Position := g_Config.nUpgradeWeaponDCThreePointRate;

  ScrollBarUpgradeWeaponMCRate.Position := g_Config.nUpgradeWeaponMCRate;
  ScrollBarUpgradeWeaponMCTwoPointRate.Position := g_Config.nUpgradeWeaponMCTwoPointRate;
  ScrollBarUpgradeWeaponMCThreePointRate.Position := g_Config.nUpgradeWeaponMCThreePointRate;

  ScrollBarUpgradeWeaponSCRate.Position := g_Config.nUpgradeWeaponSCRate;
  ScrollBarUpgradeWeaponSCTwoPointRate.Position := g_Config.nUpgradeWeaponSCTwoPointRate;
  ScrollBarUpgradeWeaponSCThreePointRate.Position := g_Config.nUpgradeWeaponSCThreePointRate;

  EditUpgradeWeaponMaxPoint.Value := g_Config.nUpgradeWeaponMaxPoint;
  EditUpgradeWeaponPrice.Value := g_Config.nUpgradeWeaponPrice;
  EditUPgradeWeaponGetBackTime.Value := g_Config.dwUPgradeWeaponGetBackTime div 1000;
  EditClearExpireUpgradeWeaponDays.Value := g_Config.nClearExpireUpgradeWeaponDays;
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponDCRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponDCRate.Position;
  EditUpgradeWeaponDCRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponDCRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponDCTwoPointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponDCTwoPointRate.Position;
  EditUpgradeWeaponDCTwoPointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponDCTwoPointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponDCThreePointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponDCThreePointRate.Position;
  EditUpgradeWeaponDCThreePointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponDCThreePointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponSCRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponSCRate.Position;
  EditUpgradeWeaponSCRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponSCRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponSCTwoPointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponSCTwoPointRate.Position;
  EditUpgradeWeaponSCTwoPointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponSCTwoPointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponSCThreePointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponSCThreePointRate.Position;
  EditUpgradeWeaponSCThreePointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponSCThreePointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponMCRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponMCRate.Position;
  EditUpgradeWeaponMCRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponMCRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponMCTwoPointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponMCTwoPointRate.Position;
  EditUpgradeWeaponMCTwoPointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponMCTwoPointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponMCThreePointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponMCThreePointRate.Position;
  EditUpgradeWeaponMCThreePointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponMCThreePointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.EditUpgradeWeaponMaxPointChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponMaxPoint := EditUpgradeWeaponMaxPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditUpgradeWeaponPriceChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponPrice := EditUpgradeWeaponPrice.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditUPgradeWeaponGetBackTimeChange(Sender:
  TObject);
begin
  if not boOpened then
    Exit;
  g_Config.dwUPgradeWeaponGetBackTime := EditUPgradeWeaponGetBackTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditClearExpireUpgradeWeaponDaysChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nClearExpireUpgradeWeaponDays :=
    EditClearExpireUpgradeWeaponDays.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonUpgradeWeaponSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'UpgradeWeaponMaxPoint', g_Config.nUpgradeWeaponMaxPoint);
  Config.WriteInteger('Setup', 'UpgradeWeaponPrice', g_Config.nUpgradeWeaponPrice);
  Config.WriteInteger('Setup', 'ClearExpireUpgradeWeaponDays', g_Config.nClearExpireUpgradeWeaponDays);
  Config.WriteInteger('Setup', 'UPgradeWeaponGetBackTime', g_Config.dwUPgradeWeaponGetBackTime);

  Config.WriteInteger('Setup', 'UpgradeWeaponDCRate', g_Config.nUpgradeWeaponDCRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponDCTwoPointRate', g_Config.nUpgradeWeaponDCTwoPointRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponDCThreePointRate', g_Config.nUpgradeWeaponDCThreePointRate);

  Config.WriteInteger('Setup', 'UpgradeWeaponMCRate', g_Config.nUpgradeWeaponMCRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponMCTwoPointRate', g_Config.nUpgradeWeaponMCTwoPointRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponMCThreePointRate', g_Config.nUpgradeWeaponMCThreePointRate);

  Config.WriteInteger('Setup', 'UpgradeWeaponSCRate', g_Config.nUpgradeWeaponSCRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponSCTwoPointRate', g_Config.nUpgradeWeaponSCTwoPointRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponSCThreePointRate', g_Config.nUpgradeWeaponSCThreePointRate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonUpgradeWeaponDefaulfClick(
  Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息', MB_YESNO +
    MB_ICONQUESTION) <> IDYES then
  begin
    Exit;
  end;
  g_Config.nUpgradeWeaponMaxPoint := 20;
  g_Config.nUpgradeWeaponPrice := 10000;
  g_Config.nClearExpireUpgradeWeaponDays := 8;
  g_Config.dwUPgradeWeaponGetBackTime := 60 * 60 * 1000;

  g_Config.nUpgradeWeaponDCRate := 100;
  g_Config.nUpgradeWeaponDCTwoPointRate := 30;
  g_Config.nUpgradeWeaponDCThreePointRate := 200;

  g_Config.nUpgradeWeaponMCRate := 100;
  g_Config.nUpgradeWeaponMCTwoPointRate := 30;
  g_Config.nUpgradeWeaponMCThreePointRate := 200;

  g_Config.nUpgradeWeaponSCRate := 100;
  g_Config.nUpgradeWeaponSCTwoPointRate := 30;
  g_Config.nUpgradeWeaponSCThreePointRate := 200;
  RefUpgradeWeapon();
end;

procedure TfrmFunctionConfig.EditMasterOKLevelChange(Sender: TObject);
begin
  if EditMasterOKLevel.Text = '' then
  begin
    EditMasterOKLevel.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nMasterOKLevel := EditMasterOKLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterOKCreditPointChange(
  Sender: TObject);
begin
  if EditMasterOKCreditPoint.Text = '' then
  begin
    EditMasterOKCreditPoint.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nMasterOKCreditPoint := EditMasterOKCreditPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterOKBonusPointChange(Sender: TObject);
begin
  if EditMasterOKBonusPoint.Text = '' then
  begin
    EditMasterOKBonusPoint.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nMasterOKBonusPoint := EditMasterOKBonusPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonMasterSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'MasterOKLevel', g_Config.nMasterOKLevel);
  Config.WriteInteger('Setup', 'MasterOKCreditPoint',
    g_Config.nMasterOKCreditPoint);
  Config.WriteInteger('Setup', 'MasterOKBonusPoint',
    g_Config.nMasterOKBonusPoint);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonMakeMineSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'MakeMineHitRate', g_Config.nMakeMineHitRate);
  Config.WriteInteger('Setup', 'MakeMineRate', g_Config.nMakeMineRate);
  Config.WriteInteger('Setup', 'StoneTypeRate', g_Config.nStoneTypeRate);
  Config.WriteInteger('Setup', 'StoneTypeRateMin', g_Config.nStoneTypeRateMin);
  Config.WriteInteger('Setup', 'GoldStoneMin', g_Config.nGoldStoneMin);
  Config.WriteInteger('Setup', 'GoldStoneMax', g_Config.nGoldStoneMax);
  Config.WriteInteger('Setup', 'SilverStoneMin', g_Config.nSilverStoneMin);
  Config.WriteInteger('Setup', 'SilverStoneMax', g_Config.nSilverStoneMax);
  Config.WriteInteger('Setup', 'SteelStoneMin', g_Config.nSteelStoneMin);
  Config.WriteInteger('Setup', 'SteelStoneMax', g_Config.nSteelStoneMax);
  Config.WriteInteger('Setup', 'BlackStoneMin', g_Config.nBlackStoneMin);
  Config.WriteInteger('Setup', 'BlackStoneMax', g_Config.nBlackStoneMax);
  Config.WriteInteger('Setup', 'StoneMinDura', g_Config.nStoneMinDura);
  Config.WriteInteger('Setup', 'StoneGeneralDuraRate',
    g_Config.nStoneGeneralDuraRate);
  Config.WriteInteger('Setup', 'StoneAddDuraRate', g_Config.nStoneAddDuraRate);
  Config.WriteInteger('Setup', 'StoneAddDuraMax', g_Config.nStoneAddDuraMax);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonMakeMineDefaultClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息', MB_YESNO +
    MB_ICONQUESTION) <> IDYES then
  begin
    Exit;
  end;
  g_Config.nMakeMineHitRate := 4;
  g_Config.nMakeMineRate := 12;
  g_Config.nStoneTypeRate := 120;
  g_Config.nStoneTypeRateMin := 56;
  g_Config.nGoldStoneMin := 1;
  g_Config.nGoldStoneMax := 2;
  g_Config.nSilverStoneMin := 3;
  g_Config.nSilverStoneMax := 20;
  g_Config.nSteelStoneMin := 21;
  g_Config.nSteelStoneMax := 45;
  g_Config.nBlackStoneMin := 46;
  g_Config.nBlackStoneMax := 56;
  g_Config.nStoneMinDura := 3000;
  g_Config.nStoneGeneralDuraRate := 13000;
  g_Config.nStoneAddDuraRate := 20;
  g_Config.nStoneAddDuraMax := 10000;
  RefMakeMine();
end;

procedure TfrmFunctionConfig.RefMakeMine();
begin
  ScrollBarMakeMineHitRate.Position := g_Config.nMakeMineHitRate;
  ScrollBarMakeMineHitRate.Min := 0;
  ScrollBarMakeMineHitRate.Max := 10;

  ScrollBarMakeMineRate.Position := g_Config.nMakeMineRate;
  ScrollBarMakeMineRate.Min := 0;
  ScrollBarMakeMineRate.Max := 50;

  ScrollBarStoneTypeRate.Position := g_Config.nStoneTypeRate;
  ScrollBarStoneTypeRate.Min := g_Config.nStoneTypeRateMin;
  ScrollBarStoneTypeRate.Max := 500;

  ScrollBarGoldStoneMax.Min := 1;
  ScrollBarGoldStoneMax.Max := g_Config.nSilverStoneMax;

  ScrollBarSilverStoneMax.Min := g_Config.nGoldStoneMax;
  ScrollBarSilverStoneMax.Max := g_Config.nSteelStoneMax;

  ScrollBarSteelStoneMax.Min := g_Config.nSilverStoneMax;
  ScrollBarSteelStoneMax.Max := g_Config.nBlackStoneMax;

  ScrollBarBlackStoneMax.Min := g_Config.nSteelStoneMax;
  ScrollBarBlackStoneMax.Max := g_Config.nStoneTypeRate;

  ScrollBarGoldStoneMax.Position := g_Config.nGoldStoneMax;
  ScrollBarSilverStoneMax.Position := g_Config.nSilverStoneMax;
  ScrollBarSteelStoneMax.Position := g_Config.nSteelStoneMax;
  ScrollBarBlackStoneMax.Position := g_Config.nBlackStoneMax;

  EditStoneMinDura.Value := g_Config.nStoneMinDura div 1000;
  EditStoneGeneralDuraRate.Value := g_Config.nStoneGeneralDuraRate div 1000;
  EditStoneAddDuraRate.Value := g_Config.nStoneAddDuraRate;
  EditStoneAddDuraMax.Value := g_Config.nStoneAddDuraMax div 1000;
end;

procedure TfrmFunctionConfig.ScrollBarMakeMineHitRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarMakeMineHitRate.Position;
  EditMakeMineHitRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nMakeMineHitRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarMakeMineRateChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarMakeMineRate.Position;
  EditMakeMineRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nMakeMineRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarStoneTypeRateChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarStoneTypeRate.Position;
  EditStoneTypeRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  ScrollBarBlackStoneMax.Max := nPostion;
  g_Config.nStoneTypeRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarGoldStoneMaxChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarGoldStoneMax.Position;
  EditGoldStoneMax.Text := IntToStr(g_Config.nGoldStoneMin) + '-' +
    IntToStr(g_Config.nGoldStoneMax);
  if not boOpened then
    Exit;
  g_Config.nSilverStoneMin := nPostion + 1;
  ScrollBarSilverStoneMax.Min := nPostion + 1;
  g_Config.nGoldStoneMax := nPostion;
  EditSilverStoneMax.Text := IntToStr(g_Config.nSilverStoneMin) + '-' +
    IntToStr(g_Config.nSilverStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarSilverStoneMaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarSilverStoneMax.Position;
  EditSilverStoneMax.Text := IntToStr(g_Config.nSilverStoneMin) + '-' +
    IntToStr(g_Config.nSilverStoneMax);
  if not boOpened then
    Exit;
  ScrollBarGoldStoneMax.Max := nPostion - 1;
  g_Config.nSteelStoneMin := nPostion + 1;
  ScrollBarSteelStoneMax.Min := nPostion + 1;
  g_Config.nSilverStoneMax := nPostion;
  EditGoldStoneMax.Text := IntToStr(g_Config.nGoldStoneMin) + '-' +
    IntToStr(g_Config.nGoldStoneMax);
  EditSteelStoneMax.Text := IntToStr(g_Config.nSteelStoneMin) + '-' +
    IntToStr(g_Config.nSteelStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarSteelStoneMaxChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarSteelStoneMax.Position;
  EditSteelStoneMax.Text := IntToStr(g_Config.nSteelStoneMin) + '-' +
    IntToStr(g_Config.nSteelStoneMax);
  if not boOpened then
    Exit;
  ScrollBarSilverStoneMax.Max := nPostion - 1;
  g_Config.nBlackStoneMin := nPostion + 1;
  ScrollBarBlackStoneMax.Min := nPostion + 1;
  g_Config.nSteelStoneMax := nPostion;
  EditSilverStoneMax.Text := IntToStr(g_Config.nSilverStoneMin) + '-' +
    IntToStr(g_Config.nSilverStoneMax);
  EditBlackStoneMax.Text := IntToStr(g_Config.nBlackStoneMin) + '-' +
    IntToStr(g_Config.nBlackStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarBlackStoneMaxChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarBlackStoneMax.Position;
  EditBlackStoneMax.Text := IntToStr(g_Config.nBlackStoneMin) + '-' +
    IntToStr(g_Config.nBlackStoneMax);
  if not boOpened then
    Exit;
  ScrollBarSteelStoneMax.Max := nPostion - 1;
  ScrollBarStoneTypeRate.Min := nPostion;
  g_Config.nBlackStoneMax := nPostion;
  EditSteelStoneMax.Text := IntToStr(g_Config.nSteelStoneMin) + '-' +
    IntToStr(g_Config.nSteelStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneMinDuraChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nStoneMinDura := EditStoneMinDura.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneGeneralDuraRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nStoneGeneralDuraRate := EditStoneGeneralDuraRate.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneAddDuraRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nStoneAddDuraRate := EditStoneAddDuraRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneAddDuraMaxChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nStoneAddDuraMax := EditStoneAddDuraMax.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.RefWinLottery;
begin
  ScrollBarWinLotteryRate.Max := 100000;
  ScrollBarWinLotteryRate.Position := g_Config.nWinLotteryRate;
  ScrollBarWinLottery1Max.Max := g_Config.nWinLotteryRate;
  ScrollBarWinLottery1Max.Min := g_Config.nWinLottery1Min;
  ScrollBarWinLottery2Max.Max := g_Config.nWinLottery1Max;
  ScrollBarWinLottery2Max.Min := g_Config.nWinLottery2Min;
  ScrollBarWinLottery3Max.Max := g_Config.nWinLottery2Max;
  ScrollBarWinLottery3Max.Min := g_Config.nWinLottery3Min;
  ScrollBarWinLottery4Max.Max := g_Config.nWinLottery3Max;
  ScrollBarWinLottery4Max.Min := g_Config.nWinLottery4Min;
  ScrollBarWinLottery5Max.Max := g_Config.nWinLottery4Max;
  ScrollBarWinLottery5Max.Min := g_Config.nWinLottery5Min;
  ScrollBarWinLottery6Max.Max := g_Config.nWinLottery5Max;
  ScrollBarWinLottery6Max.Min := g_Config.nWinLottery6Min;
  ScrollBarWinLotteryRate.Min := g_Config.nWinLottery1Max;

  ScrollBarWinLottery1Max.Position := g_Config.nWinLottery1Max;
  ScrollBarWinLottery2Max.Position := g_Config.nWinLottery2Max;
  ScrollBarWinLottery3Max.Position := g_Config.nWinLottery3Max;
  ScrollBarWinLottery4Max.Position := g_Config.nWinLottery4Max;
  ScrollBarWinLottery5Max.Position := g_Config.nWinLottery5Max;
  ScrollBarWinLottery6Max.Position := g_Config.nWinLottery6Max;

  EditWinLottery1Gold.Value := g_Config.nWinLottery1Gold;
  EditWinLottery2Gold.Value := g_Config.nWinLottery2Gold;
  EditWinLottery3Gold.Value := g_Config.nWinLottery3Gold;
  EditWinLottery4Gold.Value := g_Config.nWinLottery4Gold;
  EditWinLottery5Gold.Value := g_Config.nWinLottery5Gold;
  EditWinLottery6Gold.Value := g_Config.nWinLottery6Gold;
end;

procedure TfrmFunctionConfig.ButtonWinLotterySaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'WinLottery1Gold', g_Config.nWinLottery1Gold);
  Config.WriteInteger('Setup', 'WinLottery2Gold', g_Config.nWinLottery2Gold);
  Config.WriteInteger('Setup', 'WinLottery3Gold', g_Config.nWinLottery3Gold);
  Config.WriteInteger('Setup', 'WinLottery4Gold', g_Config.nWinLottery4Gold);
  Config.WriteInteger('Setup', 'WinLottery5Gold', g_Config.nWinLottery5Gold);
  Config.WriteInteger('Setup', 'WinLottery6Gold', g_Config.nWinLottery6Gold);
  Config.WriteInteger('Setup', 'WinLottery1Min', g_Config.nWinLottery1Min);
  Config.WriteInteger('Setup', 'WinLottery1Max', g_Config.nWinLottery1Max);
  Config.WriteInteger('Setup', 'WinLottery2Min', g_Config.nWinLottery2Min);
  Config.WriteInteger('Setup', 'WinLottery2Max', g_Config.nWinLottery2Max);
  Config.WriteInteger('Setup', 'WinLottery3Min', g_Config.nWinLottery3Min);
  Config.WriteInteger('Setup', 'WinLottery3Max', g_Config.nWinLottery3Max);
  Config.WriteInteger('Setup', 'WinLottery4Min', g_Config.nWinLottery4Min);
  Config.WriteInteger('Setup', 'WinLottery4Max', g_Config.nWinLottery4Max);
  Config.WriteInteger('Setup', 'WinLottery5Min', g_Config.nWinLottery5Min);
  Config.WriteInteger('Setup', 'WinLottery5Max', g_Config.nWinLottery5Max);
  Config.WriteInteger('Setup', 'WinLottery6Min', g_Config.nWinLottery6Min);
  Config.WriteInteger('Setup', 'WinLottery6Max', g_Config.nWinLottery6Max);
  Config.WriteInteger('Setup', 'WinLotteryRate', g_Config.nWinLotteryRate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.cbItemSuiteDamageTypes_IPClick(Sender: TObject);
var
  nStatus: Integer;
begin
  if not boOpened then
    Exit;
  nStatus := 0;
  if cbItemSuiteDamageTypes_IP.Checked then
    nStatus := (1 shl 0) or nStatus;

  if cbItemSuiteDamageTypes_HP.Checked then
    nStatus := (1 shl 1) or nStatus;

  if cbItemSuiteDamageTypes_MP.Checked then
    nStatus := (1 shl 2) or nStatus;

  g_Config.ItemSuiteDamageTypes := nStatus;
  ModValue();
end;

procedure TfrmFunctionConfig.cbPosMoveAttackParalysisPlayerClick(Sender: TObject);
begin
  if not boOpened then
    Exit;

  if Sender = cbPosMoveAttackOnItem then
    g_Config.fPosMoveAttackOnItem := TCheckBox(Sender).Checked
  else if Sender = cbPosMoveAttackParalysisPlayer then
    g_Config.fPosMoveAttackParalysisPlayer := TCheckBox(Sender).Checked
  else if Sender = cbMagicIceRainParalysisPlayer then
    g_Config.fMagicIceRainParalysisPlayer := TCheckBox(Sender).Checked
  else if Sender = cbMagicDeadEyeParalysisPlayer then
    g_Config.fMagicDeadEyeParalysisPlayer := TCheckBox(Sender).Checked
  else if Sender = chkMagicDeadEyeRedPosion then
    g_Config.fMagicDeadEyeRedPosion := TCheckBox(Sender).checked
  else if Sender = chkMagicDeadEyeGreenPosion then
    g_Config.fMagicDeadEyeGreenPosion := TCheckBox(Sender).checked;

  ModValue();
end;

procedure TfrmFunctionConfig.sePosMoveAttackPowerRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = sePosMoveAttackPowerRate then
    g_Config.nPosMoveAttackPowerRate := TSpinEdit(Sender).Value
  else if Sender = sePosMoveAttackInterval then
    g_Config.nPosMoveAttackInterval := TSpinEdit(Sender).Value
  else if Sender = seMagicIceRainPowerRate then
    g_Config.nMagicIceRainPowerRate := TSpinEdit(Sender).Value
  else if Sender = seMagicIceRainInterval then
    g_Config.nMagicIceRainInterval := TSpinEdit(Sender).Value
  else if Sender = seMagicDeadEyePowerRate then
    g_Config.nMagicDeadEyePowerRate := TSpinEdit(Sender).Value
  else if Sender = seMagicDeadEyeInterval then
  begin
    if TSpinEdit(Sender).Value >= 5 then
    begin
      g_Config.nMagicDeadEyeInterval := TSpinEdit(Sender).Value;
    end
    else
    begin
      showmessage('该技能间隔时间不能低于5秒');
      g_Config.nMagicDeadEyeInterval := 5;
      TSpinEdit(Sender).Value := 5;
      exit;
    end;
  end
  else if Sender = seMagicDragonRageInterval then
    g_Config.nMagicDragonRageInterval := TSpinEdit(Sender).Value
  else if Sender = seMagicDragonRageDuration then
    g_Config.nMagicDragonRageDuration := TSpinEdit(Sender).Value
  else if Sender = seMagicDragonRageDamageAdd then
    g_Config.nMagicDragonRageDamageAdd := TSpinEdit(Sender).Value;

  ModValue();
end;

procedure TfrmFunctionConfig.ButtonWinLotteryDefaultClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息', MB_YESNO +
    MB_ICONQUESTION) <> IDYES then
  begin
    Exit;
  end;

  g_Config.nWinLottery1Gold := 1000000;
  g_Config.nWinLottery2Gold := 200000;
  g_Config.nWinLottery3Gold := 100000;
  g_Config.nWinLottery4Gold := 10000;
  g_Config.nWinLottery5Gold := 1000;
  g_Config.nWinLottery6Gold := 500;
  g_Config.nWinLottery6Min := 1;
  g_Config.nWinLottery6Max := 4999;
  g_Config.nWinLottery5Min := 14000;
  g_Config.nWinLottery5Max := 15999;
  g_Config.nWinLottery4Min := 16000;
  g_Config.nWinLottery4Max := 16149;
  g_Config.nWinLottery3Min := 16150;
  g_Config.nWinLottery3Max := 16169;
  g_Config.nWinLottery2Min := 16170;
  g_Config.nWinLottery2Max := 16179;
  g_Config.nWinLottery1Min := 16180;
  g_Config.nWinLottery1Max := 16185;
  g_Config.nWinLotteryRate := 30000;
  RefWinLottery();
end;

procedure TfrmFunctionConfig.EditWinLottery1GoldChange(Sender: TObject);
begin
  if EditWinLottery1Gold.Text = '' then
  begin
    EditWinLottery1Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery1Gold := EditWinLottery1Gold.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditWinLottery2GoldChange(Sender: TObject);
begin
  if EditWinLottery2Gold.Text = '' then
  begin
    EditWinLottery2Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery2Gold := EditWinLottery2Gold.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditWinLottery3GoldChange(Sender: TObject);
begin
  if EditWinLottery3Gold.Text = '' then
  begin
    EditWinLottery3Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery3Gold := EditWinLottery3Gold.Value;
  ModValue();

end;

procedure TfrmFunctionConfig.EditWinLottery4GoldChange(Sender: TObject);
begin
  if EditWinLottery4Gold.Text = '' then
  begin
    EditWinLottery4Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery4Gold := EditWinLottery4Gold.Value;
  ModValue();

end;

procedure TfrmFunctionConfig.EditWinLottery5GoldChange(Sender: TObject);
begin
  if EditWinLottery5Gold.Text = '' then
  begin
    EditWinLottery5Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery5Gold := EditWinLottery5Gold.Value;
  ModValue();

end;

procedure TfrmFunctionConfig.EditWinLottery6GoldChange(Sender: TObject);
begin
  if EditWinLottery6Gold.Text = '' then
  begin
    EditWinLottery6Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery6Gold := EditWinLottery6Gold.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery1MaxChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery1Max.Position;
  EditWinLottery1Max.Text := IntToStr(g_Config.nWinLottery1Min) + '-' +
    IntToStr(g_Config.nWinLottery1Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery1Max := nPostion;
  ScrollBarWinLottery2Max.Max := nPostion - 1;
  ScrollBarWinLotteryRate.Min := nPostion;
  EditWinLottery1Max.Text := IntToStr(g_Config.nWinLottery1Min) + '-' +
    IntToStr(g_Config.nWinLottery1Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery2MaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery2Max.Position;
  EditWinLottery2Max.Text := IntToStr(g_Config.nWinLottery2Min) + '-' +
    IntToStr(g_Config.nWinLottery2Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery1Min := nPostion + 1;
  ScrollBarWinLottery1Max.Min := nPostion + 1;
  g_Config.nWinLottery2Max := nPostion;
  EditWinLottery2Max.Text := IntToStr(g_Config.nWinLottery2Min) + '-' +
    IntToStr(g_Config.nWinLottery2Max);
  EditWinLottery1Max.Text := IntToStr(g_Config.nWinLottery1Min) + '-' +
    IntToStr(g_Config.nWinLottery1Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery3MaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery3Max.Position;
  EditWinLottery3Max.Text := IntToStr(g_Config.nWinLottery3Min) + '-' +
    IntToStr(g_Config.nWinLottery3Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery2Min := nPostion + 1;
  ScrollBarWinLottery2Max.Min := nPostion + 1;
  g_Config.nWinLottery3Max := nPostion;
  EditWinLottery3Max.Text := IntToStr(g_Config.nWinLottery3Min) + '-' +
    IntToStr(g_Config.nWinLottery3Max);
  EditWinLottery2Max.Text := IntToStr(g_Config.nWinLottery2Min) + '-' +
    IntToStr(g_Config.nWinLottery2Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery4MaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery4Max.Position;
  EditWinLottery4Max.Text := IntToStr(g_Config.nWinLottery4Min) + '-' +
    IntToStr(g_Config.nWinLottery4Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery3Min := nPostion + 1;
  ScrollBarWinLottery3Max.Min := nPostion + 1;
  g_Config.nWinLottery4Max := nPostion;
  EditWinLottery4Max.Text := IntToStr(g_Config.nWinLottery4Min) + '-' +
    IntToStr(g_Config.nWinLottery4Max);
  EditWinLottery3Max.Text := IntToStr(g_Config.nWinLottery3Min) + '-' +
    IntToStr(g_Config.nWinLottery3Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery5MaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery5Max.Position;
  EditWinLottery5Max.Text := IntToStr(g_Config.nWinLottery5Min) + '-' +
    IntToStr(g_Config.nWinLottery5Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery4Min := nPostion + 1;
  ScrollBarWinLottery4Max.Min := nPostion + 1;
  g_Config.nWinLottery5Max := nPostion;
  EditWinLottery5Max.Text := IntToStr(g_Config.nWinLottery5Min) + '-' +
    IntToStr(g_Config.nWinLottery5Max);
  EditWinLottery4Max.Text := IntToStr(g_Config.nWinLottery4Min) + '-' +
    IntToStr(g_Config.nWinLottery4Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery6MaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery6Max.Position;
  EditWinLottery6Max.Text := IntToStr(g_Config.nWinLottery6Min) + '-' +
    IntToStr(g_Config.nWinLottery6Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery5Min := nPostion + 1;
  ScrollBarWinLottery5Max.Min := nPostion + 1;
  g_Config.nWinLottery6Max := nPostion;
  EditWinLottery6Max.Text := IntToStr(g_Config.nWinLottery6Min) + '-' +
    IntToStr(g_Config.nWinLottery6Max);
  EditWinLottery5Max.Text := IntToStr(g_Config.nWinLottery5Min) + '-' +
    IntToStr(g_Config.nWinLottery5Max);
  ModValue();

end;

procedure TfrmFunctionConfig.ScrollBarWinLotteryRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLotteryRate.Position;
  EditWinLotteryRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  ScrollBarWinLottery1Max.Max := nPostion;
  g_Config.nWinLotteryRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.RefReNewLevelConf();
begin
  EditReNewNameColor1.Value := g_Config.ReNewNameColor[0];
  EditReNewNameColor2.Value := g_Config.ReNewNameColor[1];
  EditReNewNameColor3.Value := g_Config.ReNewNameColor[2];
  EditReNewNameColor4.Value := g_Config.ReNewNameColor[3];
  EditReNewNameColor5.Value := g_Config.ReNewNameColor[4];
  EditReNewNameColor6.Value := g_Config.ReNewNameColor[5];
  EditReNewNameColor7.Value := g_Config.ReNewNameColor[6];
  EditReNewNameColor8.Value := g_Config.ReNewNameColor[7];
  EditReNewNameColor9.Value := g_Config.ReNewNameColor[8];
  EditReNewNameColor10.Value := g_Config.ReNewNameColor[9];
  EditReNewNameColorTime.Value := g_Config.dwReNewNameColorTime div 1000;
  SpinEditReNewChangeColorLevel.Value := g_Config.btReNewChangeColorLevel;
  CheckBoxReNewChangeColor.Checked := g_Config.boReNewChangeColor;
  CheckBoxReNewLevelClearExp.Checked := g_Config.boReNewLevelClearExp;
end;

procedure TfrmFunctionConfig.ButtonReNewLevelSaveClick(Sender: TObject);
{$IF SoftVersion <> VERDEMO}
var
  i: Integer;
{$IFEND}
begin
{$IF SoftVersion <> VERDEMO}
  for i := Low(g_Config.ReNewNameColor) to High(g_Config.ReNewNameColor) do
  begin
    Config.WriteInteger('Setup', 'ReNewNameColor' + IntToStr(i),
      g_Config.ReNewNameColor[i]);
  end;
  Config.WriteInteger('Setup', 'ReNewNameColorTime', g_Config.dwReNewNameColorTime);
  Config.WriteInteger('Setup', 'ReNewChangeColorLevel', g_Config.btReNewChangeColorLevel);
  Config.WriteBool('Setup', 'ReNewChangeColor', g_Config.boReNewChangeColor);
  Config.WriteBool('Setup', 'ReNewLevelClearExp',
    g_Config.boReNewLevelClearExp);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor1Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor1.Value;
  LabelReNewNameColor1.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[0] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor2Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor2.Value;
  LabelReNewNameColor2.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[1] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor3Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor3.Value;
  LabelReNewNameColor3.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[2] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor4Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor4.Value;
  LabelReNewNameColor4.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[3] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor5Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor5.Value;
  LabelReNewNameColor5.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[4] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor6Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor6.Value;
  LabelReNewNameColor6.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[5] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor7Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor7.Value;
  LabelReNewNameColor7.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[6] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor8Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor8.Value;
  LabelReNewNameColor8.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[7] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor9Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor9.Value;
  LabelReNewNameColor9.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[8] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor10Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditReNewNameColor10.Value;
  LabelReNewNameColor10.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[9] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColorTimeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.dwReNewNameColorTime := EditReNewNameColorTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.RefMonUpgrade();
begin
  EditMonUpgradeColor1.Value := g_Config.SlaveColor[0];
  EditMonUpgradeColor2.Value := g_Config.SlaveColor[1];
  EditMonUpgradeColor3.Value := g_Config.SlaveColor[2];
  EditMonUpgradeColor4.Value := g_Config.SlaveColor[3];
  EditMonUpgradeColor5.Value := g_Config.SlaveColor[4];
  EditMonUpgradeColor6.Value := g_Config.SlaveColor[5];
  EditMonUpgradeColor7.Value := g_Config.SlaveColor[6];
  EditMonUpgradeColor8.Value := g_Config.SlaveColor[7];
  EditMonUpgradeColor9.Value := g_Config.SlaveColor[8];
  EditMonUpgradeColor10.Value := g_Config.SlaveColor[9];
  EditMonUpgradeColor11.Value := g_Config.SlaveColor[10];
  EditMonUpgradeColor12.Value := g_Config.SlaveColor[11];
  EditMonUpgradeColor13.Value := g_Config.SlaveColor[12];
  EditMonUpgradeColor14.Value := g_Config.SlaveColor[13];
  EditMonUpgradeColor15.Value := g_Config.SlaveColor[14];

  EditMonUpgradeKillCount1.Value := g_Config.MonUpLvNeedKillCount[0];
  EditMonUpgradeKillCount2.Value := g_Config.MonUpLvNeedKillCount[1];
  EditMonUpgradeKillCount3.Value := g_Config.MonUpLvNeedKillCount[2];
  EditMonUpgradeKillCount4.Value := g_Config.MonUpLvNeedKillCount[3];
  EditMonUpgradeKillCount5.Value := g_Config.MonUpLvNeedKillCount[4];
  EditMonUpgradeKillCount6.Value := g_Config.MonUpLvNeedKillCount[5];
  EditMonUpgradeKillCount7.Value := g_Config.MonUpLvNeedKillCount[6];

  EditMonUpLvNeedKillBase.Value := g_Config.nMonUpLvNeedKillBase;
  EditMonUpLvRate.Value := g_Config.nMonUpLvRate;

  CheckBoxMasterDieMutiny.Checked := g_Config.boMasterDieMutiny;
  EditMasterDieMutinyRate.Value := g_Config.nMasterDieMutinyRate;
  EditMasterDieMutinyPower.Value := g_Config.nMasterDieMutinyPower;
  EditMasterDieMutinySpeed.Value := g_Config.nMasterDieMutinySpeed;

  CheckBoxMasterDieMutinyClick(CheckBoxMasterDieMutiny);

  CheckBoxBBMonAutoChangeColor.Checked := g_Config.boBBMonAutoChangeColor;
  EditBBMonAutoChangeColorTime.Value := g_Config.dwBBMonAutoChangeColorTime div 1000;
end;

procedure TfrmFunctionConfig.ButtonMonUpgradeSaveClick(Sender: TObject);
{$IF SoftVersion <> VERDEMO}
var
  i: Integer;
{$IFEND}
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'MonUpLvNeedKillBase', g_Config.nMonUpLvNeedKillBase);
  Config.WriteInteger('Setup', 'MonUpLvRate', g_Config.nMonUpLvRate);
  for i := Low(g_Config.MonUpLvNeedKillCount) to High(g_Config.MonUpLvNeedKillCount) do
    Config.WriteInteger('Setup', 'MonUpLvNeedKillCount' + IntToStr(i), g_Config.MonUpLvNeedKillCount[i]);
  for i := Low(g_Config.SlaveColor) to High(g_Config.SlaveColor) do
    Config.WriteInteger('Setup', 'SlaveColor' + IntToStr(i), g_Config.SlaveColor[i]);
  Config.WriteBool('Setup', 'MasterDieMutiny', g_Config.boMasterDieMutiny);
  Config.WriteInteger('Setup', 'MasterDieMutinyRate', g_Config.nMasterDieMutinyRate);
  Config.WriteInteger('Setup', 'MasterDieMutinyPower', g_Config.nMasterDieMutinyPower);
  Config.WriteInteger('Setup', 'MasterDieMutinyPower', g_Config.nMasterDieMutinySpeed);

  Config.WriteBool('Setup', 'BBMonAutoChangeColor', g_Config.boBBMonAutoChangeColor);
  Config.WriteInteger('Setup', 'BBMonAutoChangeColorTime', g_Config.dwBBMonAutoChangeColorTime);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor1Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor1.Value;
  LabelMonUpgradeColor1.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[0] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor2Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor2.Value;
  LabelMonUpgradeColor2.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[1] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor3Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor3.Value;
  LabelMonUpgradeColor3.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[2] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor4Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor4.Value;
  LabelMonUpgradeColor4.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[3] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor5Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor5.Value;
  LabelMonUpgradeColor5.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[4] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor6Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor6.Value;
  LabelMonUpgradeColor6.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[5] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor7Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor7.Value;
  LabelMonUpgradeColor7.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[6] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor8Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor8.Value;
  LabelMonUpgradeColor8.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[7] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor9Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor9.Value;
  LabelMonUpgradeColor9.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[8] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor10Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor10.Value;
  LabelMonUpgradeColor10.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[9] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor11Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor11.Value;
  LabelMonUpgradeColor11.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[10] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor12Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor12.Value;
  LabelMonUpgradeColor12.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[11] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor13Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor13.Value;
  LabelMonUpgradeColor13.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[12] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor14Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor14.Value;
  LabelMonUpgradeColor14.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[13] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor15Change(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditMonUpgradeColor15.Value;
  LabelMonUpgradeColor15.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[14] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxReNewChangeColorClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boReNewChangeColor := CheckBoxReNewChangeColor.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxReNewLevelClearExpClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boReNewLevelClearExp := CheckBoxReNewLevelClearExp.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditPKFlagNameColorChange(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditPKFlagNameColor.Value;
  LabelPKFlagNameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btPKFlagNameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditPKLevel1NameColorChange(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditPKLevel1NameColor.Value;
  LabelPKLevel1NameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btPKLevel1NameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditPKLevel2NameColorChange(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditPKLevel2NameColor.Value;
  LabelPKLevel2NameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btPKLevel2NameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditAllyAndGuildNameColorChange(
  Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditAllyAndGuildNameColor.Value;
  LabelAllyAndGuildNameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btAllyAndGuildNameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditWarGuildNameColorChange(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditWarGuildNameColor.Value;
  LabelWarGuildNameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btWarGuildNameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditInFreePKAreaNameColorChange(
  Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditInFreePKAreaNameColor.Value;
  LabelInFreePKAreaNameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btInFreePKAreaNameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount1Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[0] := EditMonUpgradeKillCount1.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount2Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[1] := EditMonUpgradeKillCount2.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount3Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[2] := EditMonUpgradeKillCount3.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount4Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[3] := EditMonUpgradeKillCount4.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount5Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[4] := EditMonUpgradeKillCount5.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount6Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[5] := EditMonUpgradeKillCount6.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount7Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[6] := EditMonUpgradeKillCount7.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpLvNeedKillBaseChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMonUpLvNeedKillBase := EditMonUpLvNeedKillBase.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpLvRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMonUpLvRate := EditMonUpLvRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxMasterDieMutinyClick(Sender: TObject);
begin
  if CheckBoxMasterDieMutiny.Checked then
  begin
    EditMasterDieMutinyRate.Enabled := True;
    EditMasterDieMutinyPower.Enabled := True;
    EditMasterDieMutinySpeed.Enabled := True;
  end
  else
  begin
    EditMasterDieMutinyRate.Enabled := False;
    EditMasterDieMutinyPower.Enabled := False;
    EditMasterDieMutinySpeed.Enabled := False;
  end;
  if not boOpened then
    Exit;
  g_Config.boMasterDieMutiny := CheckBoxMasterDieMutiny.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterDieMutinyRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMasterDieMutinyRate := EditMasterDieMutinyRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterDieMutinyPowerChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMasterDieMutinyPower := EditMasterDieMutinyPower.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterDieMutinySpeedChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMasterDieMutinySpeed := EditMasterDieMutinySpeed.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxBBMonAutoChangeColorClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boBBMonAutoChangeColor := CheckBoxBBMonAutoChangeColor.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditBBMonAutoChangeColorTimeChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.dwBBMonAutoChangeColorTime := EditBBMonAutoChangeColorTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.RefSpiritMutiny();
begin
  cbNullAttackOnSale.Checked := g_Config.boNullAttackOnSale;
  cbMedalItemLight.Checked := g_Config.boMedalItemLight;
  cbSpiritMutinyDie.Checked := g_Config.boSpiritMutinyDie;
  CheckBoxSpiritMutiny.Checked := g_Config.boSpiritMutiny;
  EditSpiritMutinyTime.Value := g_Config.dwSpiritMutinyTime div (60 * 1000);
  EditSpiritPowerRate.Value := g_Config.nSpiritPowerRate;
  CheckBoxSpiritMutinyClick(CheckBoxSpiritMutiny);
end;

procedure TfrmFunctionConfig.ButtonSpiritMutinySaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup', 'SpiritMutiny', g_Config.boSpiritMutiny);
  Config.WriteInteger('Setup', 'SpiritMutinyTime', g_Config.dwSpiritMutinyTime);
  Config.WriteInteger('Setup', 'SpiritPowerRate', g_Config.nSpiritPowerRate);
  Config.WriteInteger('Setup', 'SellOffCountLimit', g_Config.SellCount);
  Config.WriteInteger('Setup', 'SellOffRate', g_Config.SellTax);
  Config.WriteBool('Setup', 'SpiritMutinyDie', g_Config.boSpiritMutinyDie);
  Config.WriteBool('Setup', 'boMedalItemLight', g_Config.boMedalItemLight);
  Config.WriteBool('Setup', 'boNullAttackOnSale', g_Config.boNullAttackOnSale);
  Config.WriteBool('Setup', 'boBindNoScatter', g_Config.boBindNoScatter);
  Config.WriteBool('Setup', 'boBindNoMelt', g_Config.boBindNoMelt);
  Config.WriteBool('Setup', 'boBindNoUse', g_Config.boBindNoUse);
  Config.WriteBool('Setup', 'boBindNoSell', g_Config.boBindNoSell);
  Config.WriteBool('Setup', 'boBindNoPickUp', g_Config.boBindNoPickUp);
  Config.WriteBool('Setup', 'BindPickUp', g_Config.boBindPickUp);
  Config.WriteBool('Setup', 'BindTakeOn', g_Config.boBindTakeOn);

  Config.WriteInteger('Setup', 'ItemSuiteDamageTypes', g_Config.ItemSuiteDamageTypes);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSpiritMutinyClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = CheckBoxSpiritMutiny then
  begin
    if CheckBoxSpiritMutiny.Checked then
      EditSpiritMutinyTime.Enabled := CheckBoxSpiritMutiny.Checked
    else
    begin
      EditSpiritMutinyTime.Enabled := False;
      EditSpiritPowerRate.Enabled := False;
    end;
    g_Config.boSpiritMutiny := CheckBoxSpiritMutiny.Checked;
  end
  else if Sender = cbSpiritMutinyDie then
    g_Config.boSpiritMutinyDie := cbSpiritMutinyDie.Checked
  else if Sender = cbMedalItemLight then
    g_Config.boMedalItemLight := cbMedalItemLight.Checked
  else if Sender = cbNullAttackOnSale then
    g_Config.boNullAttackOnSale := cbNullAttackOnSale.Checked
  else if Sender = boBindNoScatter then
    g_Config.boBindNoScatter := boBindNoScatter.Checked
  else if Sender = boBindNoMelt then
    g_Config.boBindNoMelt := boBindNoMelt.Checked
  else if Sender = boBindNoUse then
    g_Config.boBindNoUse := boBindNoUse.Checked
  else if Sender = boBindNoSell then
    g_Config.boBindNoSell := boBindNoSell.Checked
  else if Sender = boBindNoPickUp then
    g_Config.boBindNoPickUp := boBindNoPickUp.Checked
  else if Sender = cbBindPickup then
    g_Config.boBindPickUp := cbBindPickup.Checked
  else if Sender = cbBindTakeOn then
    g_Config.boBindTakeOn := cbBindTakeOn.Checked
  else

    g_Config.boSpiritMutiny := CheckBoxSpiritMutiny.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSpiritMutinyTimeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.dwSpiritMutinyTime := EditSpiritMutinyTime.Value * 60 * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSpiritPowerRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nSpiritPowerRate := EditSpiritPowerRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTammingLevelChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagTammingLevel := EditMagTammingLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTammingTargetLevelChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagTammingTargetLevel := EditMagTammingTargetLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTammingHPRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagTammingHPRate := EditMagTammingHPRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditTammingCountChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagTammingCount := EditTammingCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitRandRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMabMabeHitRandRate := EditMabMabeHitRandRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitMinLvLimitChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMabMabeHitMinLvLimit := EditMabMabeHitMinLvLimit.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitSucessRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMabMabeHitSucessRate := EditMabMabeHitSucessRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitMabeTimeRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMabMabeHitMabeTimeRate := EditMabMabeHitMabeTimeRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.RefMonSayMsg;
begin
  CheckBoxMonSayMsg.Checked := g_Config.boMonSayMsg;
end;

procedure TfrmFunctionConfig.ButtonMonSayMsgSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup', 'GroupAttribute', g_Config.boHumanAttribute);
  Config.WriteInteger('Setup', 'GroupAttribHPMPRate', g_Config.nGroupAttribHPMPRate);
  Config.WriteInteger('Setup', 'GroupAttribPowerRate', g_Config.nGroupAttribPowerRate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.CheckBoxMonSayMsgClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boMonSayMsg := CheckBoxMonSayMsg.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.RefWeaponMakeLuck;
begin
  ScrollBarWeaponMakeUnLuckRate.Min := 1;
  ScrollBarWeaponMakeUnLuckRate.Max := 50;
  ScrollBarWeaponMakeUnLuckRate.Position := g_Config.nWeaponMakeUnLuckRate;

  ScrollBarWeaponMakeLuckPoint1.Min := 1;
  ScrollBarWeaponMakeLuckPoint1.Max := 10;
  ScrollBarWeaponMakeLuckPoint1.Position := g_Config.nWeaponMakeLuckPoint1;

  ScrollBarWeaponMakeLuckPoint2.Min := 1;
  ScrollBarWeaponMakeLuckPoint2.Max := 10;
  ScrollBarWeaponMakeLuckPoint2.Position := g_Config.nWeaponMakeLuckPoint2;

  ScrollBarWeaponMakeLuckPoint3.Min := 1;
  ScrollBarWeaponMakeLuckPoint3.Max := 10;
  ScrollBarWeaponMakeLuckPoint3.Position := g_Config.nWeaponMakeLuckPoint3;

  ScrollBarWeaponMakeLuckPoint2Rate.Min := 1;
  ScrollBarWeaponMakeLuckPoint2Rate.Max := 50;
  ScrollBarWeaponMakeLuckPoint2Rate.Position :=
    g_Config.nWeaponMakeLuckPoint2Rate;

  ScrollBarWeaponMakeLuckPoint3Rate.Min := 1;
  ScrollBarWeaponMakeLuckPoint3Rate.Max := 50;
  ScrollBarWeaponMakeLuckPoint3Rate.Position :=
    g_Config.nWeaponMakeLuckPoint3Rate;
end;

procedure TfrmFunctionConfig.ButtonWeaponMakeLuckDefaultClick(
  Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息', MB_YESNO +
    MB_ICONQUESTION) <> IDYES then
  begin
    Exit;
  end;
  g_Config.nWeaponMakeUnLuckRate := 20;
  g_Config.nWeaponMakeLuckPoint1 := 1;
  g_Config.nWeaponMakeLuckPoint2 := 3;
  g_Config.nWeaponMakeLuckPoint3 := 7;
  g_Config.nWeaponMakeLuckPoint2Rate := 6;
  g_Config.nWeaponMakeLuckPoint3Rate := 40;
  RefWeaponMakeLuck();
end;

procedure TfrmFunctionConfig.ButtonWeaponMakeLuckSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'WeaponMakeUnLuckRate', g_Config.nWeaponMakeUnLuckRate);
  Config.WriteInteger('Setup', 'WeaponMakeLuckPoint1', g_Config.nWeaponMakeLuckPoint1);
  Config.WriteInteger('Setup', 'WeaponMakeLuckPoint2', g_Config.nWeaponMakeLuckPoint2);
  Config.WriteInteger('Setup', 'WeaponMakeLuckPoint3', g_Config.nWeaponMakeLuckPoint3);
  Config.WriteInteger('Setup', 'WeaponMakeLuckPoint2Rate', g_Config.nWeaponMakeLuckPoint2Rate);
  Config.WriteInteger('Setup', 'WeaponMakeLuckPoint3Rate', g_Config.nWeaponMakeLuckPoint3Rate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeUnLuckRateChange(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeUnLuckRate.Position;
  EditWeaponMakeUnLuckRate.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeUnLuckRate := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint1Change(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeLuckPoint1.Position;
  EditWeaponMakeLuckPoint1.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeLuckPoint1 := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint2Change(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeLuckPoint2.Position;
  EditWeaponMakeLuckPoint2.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeLuckPoint2 := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint2RateChange(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeLuckPoint2Rate.Position;
  EditWeaponMakeLuckPoint2Rate.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeLuckPoint2Rate := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint3Change(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeLuckPoint3.Position;
  EditWeaponMakeLuckPoint3.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeLuckPoint3 := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint3RateChange(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeLuckPoint3Rate.Position;
  EditWeaponMakeLuckPoint3Rate.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeLuckPoint3Rate := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxGroupMbAttackBaobaoClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boGroupMbAttackBaoBao := CheckBoxGroupMbAttackBaobao.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSellCountChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.SellCount := EditSellCount.Value;
  g_Config.SellTax := EditSellTax.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonSellSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'SellOffCountLimit', g_Config.SellCount);
  Config.WriteInteger('Setup', 'SellOffRate', g_Config.SellTax);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.SpinEditBodyCountChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nBodyCount := SpinEditBodyCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxAllowMakeSlaveClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boAllowBodyMakeSlave := CheckBoxAllowMakeSlave.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditReNewChangeColorLevelChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.btReNewChangeColorLevel := SpinEditReNewChangeColorLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditMagNailTimeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.dwMagNailTick := SpinEditMagNailTime.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.SpinEditFireHitPowerRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = nSuperSkill68InvTime then
    g_Config.nSuperSkill68InvTime := nSuperSkill68InvTime.Value
  else if Sender = sePowerRate_115 then
    g_Config.ssPowerRate_115 := sePowerRate_115.Value
  else if Sender = Skill77Time then
    g_Config.Skill77Time := Skill77Time.Value
  else if Sender = Skill77Inv then
    g_Config.Skill77Inv := Skill77Inv.Value
  else if Sender = SkillMedusaEyeEffectTimeMax then
    g_Config.SkillMedusaEyeEffectTimeMax := SkillMedusaEyeEffectTimeMax.Value
  else if Sender = Skill77PowerRate then
    g_Config.Skill77PowerRate := Skill77PowerRate.Value

  else if Sender = IceMonLiveTime then
    g_Config.IceMonLiveTime := IceMonLiveTime.Value
  else if Sender = seDoMotaeboPauseTime then
    g_Config.PushedPauseTime := seDoMotaeboPauseTime.Value
  else if Sender = seSuperSkillInvTime then
    g_Config.SuperSkillInvTime := seSuperSkillInvTime.Value
  else if Sender = seSmiteLongHit2PowerRate then
    g_Config.SmiteLongHit2PowerRate := seSmiteLongHit2PowerRate.Value
  else if Sender = seMagSquPowerRate then
    g_Config.nMagSquPowerRate := seMagSquPowerRate.Value
  else if Sender = seTwinPowerRate then
    g_Config.nMagTwinPowerRate := seTwinPowerRate.Value
  else if Sender = SpinEditFireHitPowerRate then
    g_Config.nFireHitPowerRate := SpinEditFireHitPowerRate.Value
  else if Sender = seSquareHitPowerRate then
    g_Config.nSquareHitPowerRate := seSquareHitPowerRate.Value

  else if Sender = SpinEditPursueHitPowerRate then
    g_Config.nPursueHitPowerRate := SpinEditPursueHitPowerRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditGatherExpRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = SpinEditGatherExpRate then
    g_Config.nGatherExpRate := SpinEditGatherExpRate.Value
  else if Sender = SpinEditInternalPowerRate then
    g_Config.nInternalPowerRate := SpinEditInternalPowerRate.Value
  else if Sender = SpinEditInternalPowerRate2 then
    g_Config.nInternalPowerRate2 := SpinEditInternalPowerRate2.Value
  else if Sender = SpinEditInternalPowerSkillRate then
    g_Config.nInternalPowerSkillRate := SpinEditInternalPowerSkillRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxNoDoubleFireHitClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = cbLimitSquAttack then
    g_Config.boLimitSquAttack := cbLimitSquAttack.Checked
  else if Sender = cbTDBeffect then
    g_Config.boTDBeffect := cbTDBeffect.Checked
  else if Sender = CheckBoxNoDoubleFireHit then
    g_Config.boNoDoubleFireHit := CheckBoxNoDoubleFireHit.Checked
  else if Sender = cbNoDoublePursueHit then
    g_Config.boNoDoublePursueHit := cbNoDoublePursueHit.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditTestChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nTest := SpinEditTest.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.tiSpSkillAddHPMaxClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  with Sender as TCheckBox do
  begin
    case tag of
      0: g_Config.tiSpSkillAddHPMax := Checked;
      1: g_Config.tiHPSkillAddHPMax := Checked;
      2: g_Config.tiMPSkillAddMPMax := Checked;
      3: g_Config.tiSpMagicAddAtFirst := Checked;
      4: g_Config.tiOpenSystem := Checked;
      5: g_Config.tiPutAbilOnce := Checked;
    end;
  end;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonHeroSetSaveClick(Sender: TObject);
begin
  if ButtonHeroSetSave2 = Sender then
  begin
    Config.WriteInteger('Setup', 'WarrCmpInvTime', g_Config.nWarrCmpInvTime);
    Config.WriteInteger('Setup', 'WizaCmpInvTime', g_Config.nWizaCmpInvTime);
    Config.WriteInteger('Setup', 'TaosCmpInvTime', g_Config.nTaosCmpInvTime);
    Config.WriteBool('Setup', 'GetFullRateExp', g_Config.boGetFullRateExp);
    Config.WriteInteger('Setup', 'HeroGetExpRate', g_Config.nHeroGetExpRate);
    Config.WriteInteger('Setup', 'HeroMaxHealthRate', g_Config.nHeroMaxHealthRate);
    Config.WriteInteger('Setup', 'HeroMaxHealthRate1', g_Config.nHeroMaxHealthRate1);
    Config.WriteInteger('Setup', 'HeroMaxHealthRate2', g_Config.nHeroMaxHealthRate2);
    Config.WriteInteger('Setup', 'HeroGainExpRate', g_Config.nHeroGainExpRate);
    Config.WriteBool('Setup', 'HeroMaxHealthType', g_Config.boHeroMaxHealthType);
    Config.WriteBool('Setup', 'HeroAutoLockTarget', g_Config.boHeroAutoLockTarget);
    Config.WriteBool('Setup', 'boHeroHitCmp', g_Config.boHeroHitCmp);
    Config.WriteBool('Setup', 'boHeroEvade', g_Config.boHeroEvade);
    Config.WriteBool('Setup', 'boHeroRecalcWalkTick', g_Config.boHeroRecalcWalkTick);

    uModValue();
    Exit;
  end;
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'HeroNextHitTime_Warr', g_Config.nHeroNextHitTime_Warr);
  Config.WriteInteger('Setup', 'HeroNextHitTime_Wizard', g_Config.nHeroNextHitTime_Wizard);
  Config.WriteInteger('Setup', 'HeroNextHitTime_Taos', g_Config.nHeroNextHitTime_Taos);
  Config.WriteInteger('Setup', 'HeroWalkSpeed_Warr', g_Config.nHeroWalkSpeed_Warr);
  Config.WriteInteger('Setup', 'HeroWalkSpeed_Wizard', g_Config.nHeroWalkSpeed_Wizard);
  Config.WriteInteger('Setup', 'HeroWalkSpeed_Taos', g_Config.nHeroWalkSpeed_Taos);

  Config.WriteBool('Setup', 'HeroMaxHealthType', g_Config.boHeroMaxHealthType);
  Config.WriteInteger('Setup', 'ShadowExpriesTime', g_Config.nShadowExpriesTime);

  Config.WriteString('Names', 'HeroName', g_Config.sHeroName);
  Config.WriteString('Names', 'HeroSlaveName', g_Config.sHeroSlaveName);
  Config.WriteInteger('Setup', 'HeroFireSwordTime', g_Config.nHeroFireSwordTime);
  Config.WriteBool('Setup', 'HeroShowMasterName', g_Config.boPShowMasterName);
  Config.WriteBool('Setup', 'AllowHeroPickUpItem', g_Config.boAllowHeroPickUpItem);
  Config.WriteBool('Setup', 'TaosHeroAutoChangePoison', g_Config.boTaosHeroAutoChangePoison);
  Config.WriteBool('Setup', 'CalcHeroHitSpeed', g_Config.boCalcHeroHitSpeed);

  Config.WriteInteger('Setup', 'HeroMainSkill', g_Config.nHeroMainSkill);
  Config.WriteBool('Setup', 'HeroDoMotaebo', g_Config.boHeroDoMotaebo);
  Config.WriteBool('Setup', 'HeroNeedAmulet', g_Config.boHeroNeedAmulet);
  Config.WriteInteger('Setup', 'HeroNameColor', g_Config.nHeroNameColor);

  Config.WriteInteger('Setup', 'RecallHeroIntervalTime', g_Config.nRecallHeroIntervalTime);
  Config.WriteBool('Setup', 'HeroHomicideAddPKPoint', g_Config.boHeroHomicideAddPKPoint);
  Config.WriteBool('Setup', 'HeroHomicideAddMasterPkPoint', g_Config.boHeroHomicideAddMasterPkPoint);

  Config.WriteBool('Setup', 'HeroLockTarget', g_Config.boHeroLockTarget);

  Config.WriteBool('Setup', 'DieDeductionExp', g_Config.fDieDeductionExp);
  Config.WriteBool('Setup', 'NoButchItemSubGird', g_Config.boNoButchItemSubGird);
  Config.WriteInteger('Setup', 'ButchItemNeedGird', g_Config.nButchItemNeedGird);

  Config.WriteInteger('Setup', 'CloneSelfTime', g_Config.dwCloneSelfTime);
  Config.WriteInteger('Setup', 'HeroHitSpeedMax', g_Config.nHeroHitSpeedMax);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.EditHeroNextHitTime_WarrChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nHeroNextHitTime_Warr := EditHeroNextHitTime_Warr.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHeroNextHitTime_WizardChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nHeroNextHitTime_Wizard := EditHeroNextHitTime_Wizard.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHeroNextHitTime_TaosChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nHeroNextHitTime_Taos := EditHeroNextHitTime_Taos.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHeroNameChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.sHeroName := EditHeroName.Text;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHeroSlaveNameChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.sHeroSlaveName := EditHeroSlaveName.Text;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditHeroFireSwordTimeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nHeroFireSwordTime := SpinEditHeroFireSwordTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditHeroMaxHealthRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = SpinEditHeroMaxHealthRate then
    g_Config.nHeroMaxHealthRate := SpinEditHeroMaxHealthRate.Value;
  if Sender = SpinEditHeroMaxHealthRate1 then
    g_Config.nHeroMaxHealthRate1 := SpinEditHeroMaxHealthRate1.Value;
  if Sender = SpinEditHeroMaxHealthRate2 then
    g_Config.nHeroMaxHealthRate2 := SpinEditHeroMaxHealthRate2.Value;

  ModValue();
end;

procedure TfrmFunctionConfig.EditMagNailPowerRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagNailPowerRate := EditMagNailPowerRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.RadioButtonMag12Click(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if RadioButtonMag12.Checked then
    g_Config.nHeroMainSkill := 12;
  ModValue();
end;

procedure TfrmFunctionConfig.RadioButtonMag25Click(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if RadioButtonMag25.Checked then
    g_Config.nHeroMainSkill := 25;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxDoMotaeboClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boHeroDoMotaebo := CheckBoxDoMotaebo.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxEnableMapEventClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boEnableMapEvent := CheckBoxEnableMapEvent.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxPShowMasterNameClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boPShowMasterName := CheckBoxPShowMasterName.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagIceBallRangeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagIceBallRange := EditMagIceBallRange.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditEarthFirePowerRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if EditEarthFirePowerRate = Sender then
    g_Config.nEarthFirePowerRate := EditEarthFirePowerRate.Value
  else
    g_Config.nMagicShootingStarPowerRate := seMagicShootingStarPowerRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxMagCapturePlayerClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boMagCapturePlayer := CheckBoxMagCapturePlayer.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHPStoneStartChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nHPStoneStartRate := EditHPStoneStart.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMPStoneStartChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMPStoneStartRate := EditMPStoneStart.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHPStoneTimeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nHPStoneIntervalTime := EditHPStoneTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMPStoneTimeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMPStoneIntervalTime := EditMPStoneTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHPStoneAddPointChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nHPStoneAddRate := EditHPStoneAddPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMPStoneAddPointChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMPStoneAddRate := EditMPStoneAddPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHPStoneDecDuraChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nHPStoneDecDura := EditHPStoneDecDura.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMPStoneDecDuraChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMPStoneDecDura := EditMPStoneDecDura.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxFireBurnEventOffClick(
  Sender: TObject);
begin
  if not boOpened then Exit;
  
  if Sender = cbSmiteDamegeShow then
    g_Config.cbSmiteDamegeShow := cbSmiteDamegeShow.Checked
  else if Sender = cbClientAutoLongAttack then
    g_Config.ClientAotoLongAttack := cbClientAutoLongAttack.Checked
  else if Sender = cbCliAutoSay then
    g_Config.ClientAutoSay := cbCliAutoSay.Checked
  else if Sender = cbMutiHero then
    g_Config.cbMutiHero := cbMutiHero.Checked
  else if Sender = cbEffectHeroDropRate then
    g_Config.EffectHeroDropRate := cbEffectHeroDropRate.Checked
  else if Sender = cbRecallHeroCtrl then
    g_Config.boRecallHeroCtrl := cbRecallHeroCtrl.Checked
  else if Sender = cbClientAdjustSpeed then
    g_Config.boSpeedCtrl := cbClientAdjustSpeed.Checked
  else if Sender = CheckBoxClientAP then
    g_Config.boClientAutoPlay := CheckBoxClientAP.Checked
  else if Sender = cbHeroSys then
    g_Config.boHeroSystem := cbHeroSys.Checked
  else if Sender = cbStallSystem then
    g_Config.boStallSystem := cbStallSystem.Checked
  else if Sender = cbClientNoFog then
    g_Config.boClientNoFog := cbClientNoFog.Checked
  else if Sender = cbDeathWalking then
    g_Config.DeathWalking := cbDeathWalking.Checked
  else if Sender = chkJointStrikeUI then
    g_Config.boJointStrikeUI := chkJointStrikeUI.Checked
  else if Sender = chkOpenFindPathMyMap then
    g_Config.boOpenFindPathMyMap := chkOpenFindPathMyMap.Checked
  else
    g_Config.boFireBurnEventOff := CheckBoxFireBurnEventOff.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxStorageEXClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boExtendStorage := CheckBoxStorageEX.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHeroWalkSpeed_WarrChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = EditHeroWalkSpeed_Warr then
    g_Config.nHeroWalkSpeed_Warr := EditHeroWalkSpeed_Warr.Value
  else if Sender = SpinEditWarrCmpInvTime then
    g_Config.nWarrCmpInvTime := SpinEditWarrCmpInvTime.Value
  else if Sender = SpinEditWizaCmpInvTime then
    g_Config.nWizaCmpInvTime := SpinEditWizaCmpInvTime.Value
  else if Sender = SpinEditTaosCmpInvTime then
    g_Config.nTaosCmpInvTime := SpinEditTaosCmpInvTime.Value
  else if Sender = seDetcetItemRate then
    g_Config.nDetectItemRate := (Sender as TSpinEdit).Value
  else if Sender = seMakeItemButchRate then
    g_Config.nMakeItemButchRate := (Sender as TSpinEdit).Value
  else if Sender = seMakeItemRate then
    g_Config.nMakeItemRate := (Sender as TSpinEdit).Value;

  ModValue();
end;

procedure TfrmFunctionConfig.EditHeroWalkSpeed_WizardChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nHeroWalkSpeed_Wizard := EditHeroWalkSpeed_Wizard.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHeroWalkSpeed_TaosChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nHeroWalkSpeed_Taos := EditHeroWalkSpeed_Taos.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.RadioButtonMag0Click(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if RadioButtonMag0.Checked then
    g_Config.nHeroMainSkill := 0;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHeroNameColorChange(Sender: TObject);
var
  btColor: byte;
begin
  btColor := EditHeroNameColor.Value;
  LabelHeroNameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.nHeroNameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxAllowHeroPickUpItemClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = CheckBoxGetFullExp then
  begin
    g_Config.boGetFullRateExp := CheckBoxGetFullExp.Checked;
    EditHeroGainExpRate.Enabled := not g_Config.boGetFullRateExp;
  end
  else
    g_Config.boAllowHeroPickUpItem := CheckBoxAllowHeroPickUpItem.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxTaosHeroAutoChangePoisonClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boTaosHeroAutoChangePoison := CheckBoxTaosHeroAutoChangePoison.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHeroGainExpRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = SpinEditShadowExpriesTime then
  begin
    g_Config.nShadowExpriesTime := SpinEditShadowExpriesTime.Value;
  end
  else if Sender = EditHeroGainExpRate2 then
  begin
    g_Config.nHeroGetExpRate := EditHeroGainExpRate2.Value;
  end
  else
    g_Config.nHeroGainExpRate := EditHeroGainExpRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditRecallHeroIntervalTimeChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nRecallHeroIntervalTime := EditRecallHeroIntervalTime.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxHeroCalcHitSpeedClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boCalcHeroHitSpeed := CheckBoxHeroCalcHitSpeed.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSkillWWPowerRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = seSSFreezeRate then
    g_Config.nSSFreezeRate := seSSFreezeRate.Value
  else if Sender = EditEnergyStepUpRate then
    g_Config.nEnergyStepUpRate := EditEnergyStepUpRate.Value
  else if Sender = EditSkillWWPowerRate then
    g_Config.nSkillWWPowerRate := EditSkillWWPowerRate.Value
  else if Sender = EditSkillTWPowerRate then
    g_Config.nSkillTWPowerRate := EditSkillTWPowerRate.Value
  else if Sender = EditSkillZWPowerRate then
    g_Config.nSkillZWPowerRate := EditSkillZWPowerRate.Value
  else if Sender = EditSkillTTPowerRate then
    g_Config.nSkillTTPowerRate := EditSkillTTPowerRate.Value
  else if Sender = EditSkillZTPowerRate then
    g_Config.nSkillZTPowerRate := EditSkillZTPowerRate.Value
  else if Sender = EditSkillZZPowerRate then
    g_Config.nSkillZZPowerRate := EditSkillZZPowerRate.Value
  else if Sender = speSeriesSkillReleaseInvTime then
    g_Config.nSeriesSkillReleaseInvTime := speSeriesSkillReleaseInvTime.Value * 1000
  else if Sender = speSmiteWideHitSkillInvTime then
    g_Config.nSmiteWideHitSkillInvTime := speSmiteWideHitSkillInvTime.Value * 1000
  else if Sender = spePowerRateOfSeriesSkill_100 then
    g_Config.nPowerRateOfSeriesSkill_100 := spePowerRateOfSeriesSkill_100.Value
  else if Sender = spePowerRateOfSeriesSkill_101 then
    g_Config.nPowerRateOfSeriesSkill_101 := spePowerRateOfSeriesSkill_101.Value
  else if Sender = spePowerRateOfSeriesSkill_102 then
    g_Config.nPowerRateOfSeriesSkill_102 := spePowerRateOfSeriesSkill_102.Value
  else if Sender = spePowerRateOfSeriesSkill_103 then
    g_Config.nPowerRateOfSeriesSkill_103 := spePowerRateOfSeriesSkill_103.Value

  else if Sender = spePowerRateOfSeriesSkill_104 then
    g_Config.nPowerRateOfSeriesSkill_104 := spePowerRateOfSeriesSkill_104.Value
  else if Sender = spePowerRateOfSeriesSkill_105 then
    g_Config.nPowerRateOfSeriesSkill_105 := spePowerRateOfSeriesSkill_105.Value
  else if Sender = spePowerRateOfSeriesSkill_106 then
    g_Config.nPowerRateOfSeriesSkill_106 := spePowerRateOfSeriesSkill_106.Value
  else if Sender = spePowerRateOfSeriesSkill_107 then
    g_Config.nPowerRateOfSeriesSkill_107 := spePowerRateOfSeriesSkill_107.Value

  else if Sender = spePowerRateOfSeriesSkill_108 then
    g_Config.nPowerRateOfSeriesSkill_108 := spePowerRateOfSeriesSkill_108.Value
  else if Sender = spePowerRateOfSeriesSkill_109 then
    g_Config.nPowerRateOfSeriesSkill_109 := spePowerRateOfSeriesSkill_109.Value
  else if Sender = spePowerRateOfSeriesSkill_110 then
    g_Config.nPowerRateOfSeriesSkill_110 := spePowerRateOfSeriesSkill_110.Value
  else if Sender = spePowerRateOfSeriesSkill_111 then
    g_Config.nPowerRateOfSeriesSkill_111 := spePowerRateOfSeriesSkill_111.Value
  else if Sender = spePowerRateOfSeriesSkill_114 then
    g_Config.nPowerRateOfSeriesSkill_114 := spePowerRateOfSeriesSkill_114.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxAllowJointAttackClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = cbSkill_114_MP then
    g_Config.boSkill_114_MP := cbSkill_114_MP.Checked
  else if Sender = Skill_68_MP then
    g_Config.boSkill_68_MP := Skill_68_MP.Checked
  else
    g_Config.boAllowJointAttack := CheckBoxAllowJointAttack.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxGroupAttribClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boHumanAttribute := CheckBoxGroupAttrib.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditGroupAttribHPMPRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nGroupAttribHPMPRate := EditGroupAttribHPMPRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditnGroupAttribPowerRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nGroupAttribPowerRate := EditnGroupAttribPowerRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxHeroKillHumanAddPkPointClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = CheckBoxHeroKillHumanAddPkPoint then
  begin
    g_Config.boHeroHomicideAddPKPoint := CheckBoxHeroKillHumanAddPkPoint.Checked;
    if g_Config.boHeroHomicideAddPKPoint then
    begin
      CheckBoxHeroHomicideAddMasterPkPoint.Checked := False;
      g_Config.boHeroHomicideAddMasterPkPoint := False;
    end;
  end
  else if Sender = CheckBoxHeroHomicideAddMasterPkPoint then
  begin
    g_Config.boHeroHomicideAddMasterPkPoint := CheckBoxHeroHomicideAddMasterPkPoint.Checked;
    if g_Config.boHeroHomicideAddMasterPkPoint then
    begin
      CheckBoxHeroKillHumanAddPkPoint.Checked := False;
      g_Config.boHeroHomicideAddPKPoint := False;
    end;
  end;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxHeroLockTargetClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boHeroLockTarget := CheckBoxHeroLockTarget.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxHeroMaxHealthTypeClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if cbHeroAutoLockTarget = Sender then
    g_Config.boHeroAutoLockTarget := cbHeroAutoLockTarget.Checked
  else if boHeroEvade = Sender then
    g_Config.boHeroEvade := boHeroEvade.Checked
  else if boHeroRecalcWalkTick = Sender then
    g_Config.boHeroRecalcWalkTick := boHeroRecalcWalkTick.Checked
  else if boHeroHitCmp = Sender then
    g_Config.boHeroHitCmp := boHeroHitCmp.Checked
  else

    g_Config.boHeroMaxHealthType := CheckBoxHeroMaxHealthType.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockRecallHeroClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLockRecallAction := CheckBoxLockRecallHero.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxNoButchItemSubGirdClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = cbDieDeductionExp then
    g_Config.fDieDeductionExp := cbDieDeductionExp.Checked
  else
    g_Config.boNoButchItemSubGird := CheckBoxNoButchItemSubGird.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditDiButchItemNeedGirdChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nButchItemNeedGird := EditDiButchItemNeedGird.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxShowShieldEffectClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boShowShieldEffect := CheckBoxShowShieldEffect.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxAutoOpenShieldClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boAutoOpenShield := CheckBoxAutoOpenShield.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditCordialAddHPMaxChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = EditHealingRate then
    g_Config.nHealingRate := EditHealingRate.Value
  else
    g_Config.nCordialAddHPMPMax := EditCordialAddHPMax.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxMagCanHitTargetClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if cbLargeMagicRange = Sender then
    g_Config.LargeMagicRange := cbLargeMagicRange.Checked
  else if CheckBoxMagCanHitTarget = Sender then
    g_Config.boMagCanHitTarget := CheckBoxMagCanHitTarget.Checked
  else if Skill_68_MP = Sender then
    g_Config.boSkill_68_MP := Skill_68_MP.Checked
  else if CheckBoxIgnoreTagDefence = Sender then
    g_Config.boIgnoreTagDefence := CheckBoxIgnoreTagDefence.Checked
  else
    g_Config.boIgnoreTagDefence2 := CheckBoxIgnoreTagDefence2.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxHeroNeedAmuletClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boHeroNeedAmulet := CheckBoxHeroNeedAmulet.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.speHeroRecallPneumaTimeChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = EditHeroHitSpeedMax then
    g_Config.nHeroHitSpeedMax := EditHeroHitSpeedMax.Value
  else
    g_Config.dwCloneSelfTime := speHeroRecallPneumaTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.setiWeaponDCAddRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  with Sender as TSpinEdit do
  begin
    case tag of
      -1: g_Config.tiSpiritAddRate := Value;
      -2: g_Config.tiSpiritAddValueRate := Value;
      -3: g_Config.tiSecretPropertyAddRate := Value;
      -4: g_Config.tiSecretPropertyAddValueMaxLimit := Value;
      -5: g_Config.tiSecretPropertyAddValueRate := Value;
      -6: g_Config.tiSucessRate := Value;
      -7: g_Config.tiSucessRateEx := Value;
      -8: g_Config.tiExchangeItemRate := Value;
      -9: g_Config.spSecretPropertySucessRate := Value;
      -10: g_Config.spEnergyAddTime := Value;
      -11: g_Config.spMakeBookSucessRate := Value;
      -12: g_Config.tiAddHealthPlus_0 := Value;
      -13: g_Config.tiAddHealthPlus_1 := Value;
      -14: g_Config.tiAddHealthPlus_2 := Value;
      -15: g_Config.tiAddSpellPlus_0 := Value;
      -16: g_Config.tiAddSpellPlus_1 := Value;
      -17: g_Config.tiAddSpellPlus_2 := Value;

      00: g_Config.tiWeaponDCAddRate := Value;
      01: g_Config.tiWeaponDCAddValueMaxLimit := Value;
      02: g_Config.tiWeaponDCAddValueRate := Value;
      03: g_Config.tiWeaponMCAddRate := Value;
      04: g_Config.tiWeaponMCAddValueMaxLimit := Value;
      05: g_Config.tiWeaponMCAddValueRate := Value;
      06: g_Config.tiWeaponSCAddRate := Value;
      07: g_Config.tiWeaponSCAddValueMaxLimit := Value;
      08: g_Config.tiWeaponSCAddValueRate := Value;
      09: g_Config.tiWeaponLuckAddRate := Value;
      10: g_Config.tiWeaponLuckAddValueMaxLimit := Value;
      11: g_Config.tiWeaponLuckAddValueRate := Value;
      12: g_Config.tiWeaponCurseAddRate := Value;
      13: g_Config.tiWeaponCurseAddValueMaxLimit := Value;
      14: g_Config.tiWeaponCurseAddValueRate := Value;
      15: g_Config.tiWeaponHitAddRate := Value;
      16: g_Config.tiWeaponHitAddValueMaxLimit := Value;
      17: g_Config.tiWeaponHitAddValueRate := Value;
      18: g_Config.tiWeaponHitSpdAddRate := Value;
      19: g_Config.tiWeaponHitSpdAddValueMaxLimit := Value;
      20: g_Config.tiWeaponHitSpdAddValueRate := Value;
      21: g_Config.tiWeaponHolyAddRate := Value;
      22: g_Config.tiWeaponHolyAddValueMaxLimit := Value;
      23: g_Config.tiWeaponHolyAddValueRate := Value;

      30: g_Config.tiWearingDCAddRate := Value;
      31: g_Config.tiWearingDCAddValueMaxLimit := Value;
      32: g_Config.tiWearingDCAddValueRate := Value;
      33: g_Config.tiWearingMCAddRate := Value;
      34: g_Config.tiWearingMCAddValueMaxLimit := Value;
      35: g_Config.tiWearingMCAddValueRate := Value;
      36: g_Config.tiWearingSCAddRate := Value;
      37: g_Config.tiWearingSCAddValueMaxLimit := Value;
      38: g_Config.tiWearingSCAddValueRate := Value;
      39: g_Config.tiWearingACAddRate := Value;
      40: g_Config.tiWearingACAddValueMaxLimit := Value;
      41: g_Config.tiWearingACAddValueRate := Value;
      42: g_Config.tiWearingMACAddRate := Value;
      43: g_Config.tiWearingMACAddValueMaxLimit := Value;
      44: g_Config.tiWearingMACAddValueRate := Value;

      45: g_Config.tiWearingHitAddRate := Value;
      46: g_Config.tiWearingHitAddValueMaxLimit := Value;
      47: g_Config.tiWearingHitAddValueRate := Value;
      48: g_Config.tiWearingSpeedAddRate := Value;
      49: g_Config.tiWearingSpeedAddValueMaxLimit := Value;
      50: g_Config.tiWearingSpeedAddValueRate := Value;
      51: g_Config.tiWearingLuckAddRate := Value;
      52: g_Config.tiWearingLuckAddValueMaxLimit := Value;
      53: g_Config.tiWearingLuckAddValueRate := Value;
      54: g_Config.tiWearingAntiMagicAddRate := Value;
      55: g_Config.tiWearingAntiMagicAddValueMaxLimit := Value;
      56: g_Config.tiWearingAntiMagicAddValueRate := Value;
      57: g_Config.tiWearingHealthRecoverAddRate := Value;
      58: g_Config.tiWearingHealthRecoverAddValueMaxLimit := Value;
      59: g_Config.tiWearingHealthRecoverAddValueRate := Value;
      60: g_Config.tiWearingSpellRecoverAddRate := Value;
      61: g_Config.tiWearingSpellRecoverAddValueMaxLimit := Value;
      62: g_Config.tiWearingSpellRecoverAddValueRate := Value;

      100: g_Config.tiAbilTagDropAddRate := Value;
      101: g_Config.tiAbilTagDropAddValueMaxLimit := Value;
      102: g_Config.tiAbilTagDropAddValueRate := Value;
      103: g_Config.tiAbilPreDropAddRate := Value;
      104: g_Config.tiAbilPreDropAddValueMaxLimit := Value;
      105: g_Config.tiAbilPreDropAddValueRate := Value;
      106: g_Config.tiAbilSuckAddRate := Value;
      107: g_Config.tiAbilSuckAddValueMaxLimit := Value;
      108: g_Config.tiAbilSuckAddValueRate := Value;
      109: g_Config.tiAbilIpRecoverAddRate := Value;
      110: g_Config.tiAbilIpRecoverAddValueMaxLimit := Value;
      111: g_Config.tiAbilIpRecoverAddValueRate := Value;
      112: g_Config.tiAbilIpExAddRate := Value;
      113: g_Config.tiAbilIpExAddValueMaxLimit := Value;
      114: g_Config.tiAbilIpExAddValueRate := Value;
      115: g_Config.tiAbilIpDamAddRate := Value;
      116: g_Config.tiAbilIpDamAddValueMaxLimit := Value;
      117: g_Config.tiAbilIpDamAddValueRate := Value;
      118: g_Config.tiAbilIpReduceAddRate := Value;
      119: g_Config.tiAbilIpReduceAddValueMaxLimit := Value;
      120: g_Config.tiAbilIpReduceAddValueRate := Value;
      121: g_Config.tiAbilIpDecAddRate := Value;
      122: g_Config.tiAbilIpDecAddValueMaxLimit := Value;
      123: g_Config.tiAbilIpDecAddValueRate := Value;
      124: g_Config.tiAbilBangAddRate := Value;
      125: g_Config.tiAbilBangAddValueMaxLimit := Value;
      126: g_Config.tiAbilBangAddValueRate := Value;
      127: g_Config.tiAbilGangUpAddRate := Value;
      128: g_Config.tiAbilGangUpAddValueMaxLimit := Value;
      129: g_Config.tiAbilGangUpAddValueRate := Value;
      130: g_Config.tiAbilPalsyReduceAddRate := Value;
      131: g_Config.tiAbilPalsyReduceAddValueMaxLimit := Value;
      132: g_Config.tiAbilPalsyReduceAddValueRate := Value;
      133: g_Config.tiAbilHPExAddRate := Value;
      134: g_Config.tiAbilHPExAddValueMaxLimit := Value;
      135: g_Config.tiAbilHPExAddValueRate := Value;
      136: g_Config.tiAbilMPExAddRate := Value;
      137: g_Config.tiAbilMPExAddValueMaxLimit := Value;
      138: g_Config.tiAbilMPExAddValueRate := Value;
      139: g_Config.tiAbilCCAddRate := Value;
      140: g_Config.tiAbilCCAddValueMaxLimit := Value;
      141: g_Config.tiAbilCCAddValueRate := Value;
      142: g_Config.tiAbilPoisonReduceAddRate := Value;
      143: g_Config.tiAbilPoisonReduceAddValueMaxLimit := Value;
      144: g_Config.tiAbilPoisonReduceAddValueRate := Value;
      145: g_Config.tiAbilPoisonRecoverAddRate := Value;
      146: g_Config.tiAbilPoisonRecoverAddValueMaxLimit := Value;
      147: g_Config.tiAbilPoisonRecoverAddValueRate := Value;

      150: g_Config.tiSpecialSkills1AddRate := Value;
      151: g_Config.tiSpecialSkills2AddRate := Value;
      152: g_Config.tiSpecialSkills3AddRate := Value;
      153: g_Config.tiSpecialSkills4AddRate := Value;
      154: g_Config.tiSpecialSkills5AddRate := Value;
      155: g_Config.tiSpecialSkills6AddRate := Value;
      156: g_Config.tiSpecialSkills7AddRate := Value;

      157: g_Config.tiSpMagicAddRate1 := Value;
      158: g_Config.tiSpMagicAddRate2 := Value;
      159: g_Config.tiSpMagicAddRate3 := Value;
      160: g_Config.tiSpMagicAddRate4 := Value;
      161: g_Config.tiSpMagicAddRate5 := Value;
      162: g_Config.tiSpMagicAddRate6 := Value;
      163: g_Config.tiSpMagicAddRate7 := Value;
      164: g_Config.tiSpMagicAddRate8 := Value;
      165: g_Config.tiSpMagicAddMaxLevel := Value;
    end;
  end;
  ModValue();
end;

procedure TfrmFunctionConfig.speEatItemsTimeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if Sender = seSetShopNeedLevel then
    g_Config.SetShopNeedLevel := seSetShopNeedLevel.Value
  else
    g_Config.nEatItemTime := speEatItemsTime.Value;
  ModValue();
end;

end.
