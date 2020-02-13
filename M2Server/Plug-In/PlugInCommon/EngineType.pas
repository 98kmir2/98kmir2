unit EngineType;

interface
uses
  Windows;
const
  LibName = 'M2Server.exe';
  MAPNAMELEN = 16;
  ACTORNAMELEN = 14;
  MAXPATHLEN = 255;
  DIRPATHLEN = 80;

  U_DRESS = 0;
  U_WEAPON = 1;
  U_RIGHTHAND = 2;
  U_NECKLACE = 3;
  U_HELMET = 4;
  U_ARMRINGL = 5;
  U_ARMRINGR = 6;
  U_RINGL = 7;
  U_RINGR = 8;
  U_BUJUK = 9;
  U_BELT = 10; //����
  U_BOOTS = 11; //Ь
  U_CHARM = 12;

  RC_PLAYOBJECT = 0;
  RC_GUARD = 11; //������
  RC_PEACENPC = 15;
  RC_ANIMAL = 50;
  RC_MONSTER = 80;
  RC_NPC = 10;
  RC_ARCHERGUARD = 112;

  sGameLogMsg = '%d'#9'%s'#9'%d'#9'%d'#9'%s'#9'%s'#9'%d'#9'%s'#9'%s';
  GAMELOGNUMBERBASE = 100;
  GAMELOGBUYITEM = GAMELOGNUMBERBASE + 1;

  CM_QUERYBAGITEMS = 81;
  SM_HORSERUN = 5;
  SM_WALK = 11;
  SM_RUN = 13;
  SM_ALIVE = 27;
  SM_DEATH = 32;
  SM_SKELETON = 33;
  SM_NOWDEATH = 34;
  SM_LEVELUP = 45;
  SM_ABILITY = 52;
  SM_BAGITEMS = 201;
  SM_SENDMYMAGIC = 211;
  SM_SENDUSERSTATE = 751;
  SM_SUBABILITY = 752;
  SM_SPACEMOVE_SHOW = 801;
  SM_SPACEMOVE_SHOW2 = 807;
  SM_CHANGEFACE = 1104;
  CM_USERBASE = 8000;
  SM_USERBASE = 9000;
  RM_USERBASE = 61000;
  RM_ABILITY = 10051;
type
  PTBaseObject = ^TBaseObject;
  PTEnvirnoment = ^TEnvirnoment;

  TList = TObject;
  TStringList = TObject;
  TBaseObject = TObject;
  TPlayObject = TObject;
  TNormNpc = TObject;
  TMerchant = TObject;
  TEnvirnoment = TObject;
  TUserEngine = TObject;
  TMagicManager = TObject;
  TGuild = TObject;

  _TBANKPWD = string[6];
  _LPTBANKPWD = ^_TBANKPWD;
  _TMAPNAME = string[MAPNAMELEN];
  _LPTMAPNAME = ^_TMAPNAME;
  _TACTORNAME = string[ACTORNAMELEN];
  _LPTACTORNAME = ^_TACTORNAME;
  _TPATHNAME = string[MAXPATHLEN];
  _LPTPATHNAME = ^_TPATHNAME;
  _TDIRNAME = string[DIRPATHLEN];
  _LPTDIRNAME = ^_TDIRNAME;

  _TSHORTSTRING = packed record
    btLen: Byte;
    Strings: array[0..High(Byte) - 1] of Char;
  end;

  _LPTSHORTSTRING = ^_TSHORTSTRING;
  _TMSGCOLOR = (mc_Red, mc_Green, mc_Blue, mc_White);
  _TMSGTYPE = (mt_Notice, mt_Hint, mt_System, mt_Say, mt_Mon, mt_GM, mt_Cust, mt_Castle);
  _TDEFAULTMESSAGE = packed record
    nRecog: Integer;
    wIdent: Word;
    wParam: Word;
    wTag: Word;
    wSeries: Word;
  end;
  _LPTDEFAULTMESSAGE = ^_TDEFAULTMESSAGE;
  _TSHORTMESSAGE = packed record
    wIdent: Word;
    wMsg: Word;
  end;
  _LPTSHORTMESSAGE = ^_TSHORTMESSAGE;
  _TMESSAGEBODYW = packed record
    wParam1: Word;
    wParam2: Word;
    wTag1: Word;
    wTag2: Word;
  end;
  _LPTMESSAGEBODYW = ^_TMESSAGEBODYW;

  _TMESSAGEBODYWL = packed record
    nParam1: Integer;
    nParam2: Integer;
    nTag1: Integer;
    nTag2: Integer;
  end;
  _LPTMESSAGEBODYWL = ^_TMESSAGEBODYWL;

  _TCHARDESC = packed record
    nFeature: Integer;
    nStatus: Integer;
  end;
  _LPTCHARDESC = ^_TCHARDESC;

  _TCHARDESCEX = packed record
    nFeature: Integer;
    nStatus: Integer;
    nFeatureEx: Integer;
  end;
  _LPTCHARDESCEX = ^_TCHARDESCEX;

  _TABILITY = packed record
    wLevel: Word;
    nAC: Integer;
    nMAC: Integer;
    nDC: Integer;
    nMC: Integer;
    nSC: Integer;
    wHP: Word;
    wMP: Word;
    wMaxHP: Word;
    wMaxMP: Word;
    dwExp: LongWord;
    dwMaxExp: LongWord;
    wWeight: Word;
    wMaxWeight: Word;
    wWearWeight: Word;
    wMaxWearWeight: Word;
    wHandWeight: Word;
    wMaxHandWeight: Word;
  end;
  _LPTABILITY = ^_TABILITY;

  _TOABILITY = packed record
    wLevel: Word;
    wAC: Word;
    wMAC: Word;
    wDC: Word;
    wMC: Word;
    wSC: Word;
    wHP: Word;
    wMP: Word;
    wMaxHP: Word;
    wMaxMP: Word;
    btReserved1: Byte;
    btReserved2: Byte;
    btReserved3: Byte;
    btReserved4: Byte;
    dwExp: LongWord;
    dwMaxExp: LongWord;
    wWeight: Word;
    wMaxWeight: Word;
    btWearWeight: Byte;
    btMaxWearWeight: Byte;
    btHandWeight: Byte;
    btMaxHandWeight: Byte;
  end;
  _LPTOABILITY = ^_TOABILITY;

  _TSTDITEM = packed record
    szName: string[14];
    btStdMode: Byte;
    btShape: Byte;
    btWeight: Byte;
    btAniCount: Byte;
    nSource: Shortint;
    btReserved: Byte;
    btNeedIdentify: Byte;
    wLooks: Word;
    wDuraMax: Word;
    wReserved1: Word;
    nAC: Integer;
    nMAC: Integer;
    nDC: Integer;
    nMC: Integer;
    nSC: Integer;
    nNeed: Integer;
    nNeedLevel: Integer;
    nPrice: Integer;
  end;
  _LPTSTDITEM = ^_TSTDITEM;

  _TOSTDITEM = packed record
    szName: string[14];
    btStdMode: Byte;
    btShape: Byte;
    btWeight: Byte;
    btAniCount: Byte;
    nSource: Shortint;
    btReserved: Byte;
    btNeedIdentify: Byte;
    wLooks: Word;
    wDuraMax: Word;
    wAC: Word;
    wMAC: Word;
    wDC: Word;
    wMC: Word;
    wSC: Word;
    btNeed: Byte;
    btNeedLevel: Byte;
    btReserved1: Byte;
    btReserved2: Byte;
    nPrice: Integer;
  end;
  _LPTOSTDITEM = ^_TOSTDITEM;

  _TCLIENTITEM = packed record
    S: _TSTDITEM;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  _LPTCLIENTITEM = ^_TCLIENTITEM;

  _TOCLIENTITEM = packed record
    S: _TOSTDITEM;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  _LPTOCLIENTITEM = ^_TOCLIENTITEM;
  _TSENDUSERCLIENTITEM = packed record
    wIdx: Word;
    ClientItem: _TOCLIENTITEM;
  end;
  _TOUSERSTATEINFO = packed record
    nFeature: Integer;
    btUserNameLen: Byte;
    szUserName: array[0..14] of Char;
    wNameColor: Word;
    wCharState: Word;
    btGuildNameLen: Byte;
    szGuildName: array[0..13] of Char;
    btGuildRankNameLen: Byte;
    szGuildRankName: array[0..14] of Char;
    btGender: Byte;
    UseItems: array[0..12] of _TOCLIENTITEM;
  end;
  _LPTOUSERSTATEINFO = ^_TOUSERSTATEINFO;
  _TUSERITEM = packed record
    nMakeIndex: Integer;
    wIndex: Word;
    wDura: Word;
    wDuraMax: Word;
    btValue: array[0..13] of Byte;
  end;
  pTUserItem = ^_TUSERITEM;
  _TPLAYUSEITEMS = array[0..12] of _TUSERITEM;
  _LPTPLAYUSEITEMS = ^_TPLAYUSEITEMS;

  _TMAGIC = packed record
    wMagicId: Word;
    sMagicName: string[12];
    btEffectType: Byte;
    btEffect: Byte;
    bt11: Byte;
    wSpell: Word;
    wPower: Word;
    TrainLevel: array[0..3] of Byte;
    w02: Word;
    MaxTrain: array[0..3] of Integer;
    btTrainLv: Byte;
    btJob: Byte;
    wMagicIdx: Word;
    dwDelayTime: LongWord;
    btDefSpell: Byte;
    btDefPower: Byte;
    wMaxPower: Word;
    btDefMaxPower: Byte;
    sDescr: string[18];
  end;
  _LPTMAGIC = ^_TMAGIC;
  _TUSERMAGIC = record
    MagicInfo: _LPTMAGIC;
    wMagIdx: Word;
    btLevel: Byte;
    btKey: Byte;
    nTranPoint: Integer;
  end;
  _LPTUSERMAGIC = ^_TUSERMAGIC;
  _TCLIENTMAGIC = record
    Key: Char;
    Level: Byte;
    wXX: Word;
    nCurTrain: Integer;
    Def: _TMAGIC;
  end;
  _LPTCLIENTMAGIC = ^_TCLIENTMAGIC;
  _TGUILDRANK = packed record
    nRankNo: Integer;
    sRankName: string[100];
    MemberList: Pointer;
  end;
  _LPTGUILDRANK = ^_TGUILDRANK;

  _TOBJECTACTION = procedure(PlayObject: TObject); stdcall;
  _TOBJECTACTIONEX = function(PlayObject: TObject): BOOL; stdcall;
  _TOBJECTACTIONXY = procedure(AObject, BObject: TObject; nX, nY: Integer); stdcall;
  _TOBJECTACTIONXYD = procedure(AObject, BObject: TObject; nX, nY: Integer; btDir: Byte); stdcall;
  _TOBJECTACTIONXYDM = procedure(AObject, BObject: TObject; nX, nY: Integer; btDir: Byte; nMode: Integer); stdcall;
  _TOBJECTACTIONXYDWS = procedure(AObject, BObject: TObject; wIdent: Word; nX, nY: Integer; btDir: Byte; pszMsg: PChar); stdcall;
  _TOBJECTACTIONOBJECT = procedure(AObject, BObject, CObject: TObject; nInt: Integer); stdcall;
  _TOBJECTACTIONDETAILGOODS = procedure(Merchant: TObject; PlayObject: TObject; pszItemName: PChar; nInt: Integer); stdcall;
  _TOBJECTUSERCMD = function(AObject: TObject; pszCmd, pszParam1, pszParam2, pszParam3, pszParam4, pszParam5, pszParam6, pszParam7: PChar): Boolean; stdcall;
  _TPLAYSENDSOCKET = function(AObject: TObject; DefMsg: _LPTDEFAULTMESSAGE; pszMsg: PChar): Boolean; stdcall;
  _TOBJECTACTIONITEM = function(AObject: TObject; pszItemName: PChar): Boolean; stdcall;
  _TOBJECTCLIENTMSG = function(PlayObject: TObject; DefMsg: _LPTDEFAULTMESSAGE; Buff: PChar; NewBuff: PChar): Integer; stdcall;
  _TOBJECTACTIONFEATURE = function(AObject, BObject: TObject): Integer; stdcall;
  _TOBJECTACTIONSENDGOODS = procedure(AObject: TObject; nNpcRecog, nCount, nPostion: Integer; pszData: PChar); stdcall;
  _TOBJECTACTIONCHECKUSEITEM = function(nIdx: Integer; StdItem: _LPTSTDITEM): Boolean; stdcall;

  _TOBJECTACTIONENTERMAP = function(AObject: TObject; Envir: TObject; nX, nY: Integer): Boolean; stdcall;
  _TOBJECTFILTERMSG = procedure(PlayObject: TObject; pszSrcMsg: PChar; pszDestMsg: PChar; nDestLen: Integer); stdcall;

  _TEDCODE = procedure(pszSource: PChar; pszDest: PChar; nSrcLen, nDestLen: Integer); stdcall;
  _TDOSPELL = function(AObject: TObject; PlayObject: TPlayObject; UserMagic: _LPTUSERMAGIC; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var nHookStatus: Integer): Boolean; stdcall;

  _TOBJECTUSERRUNMSG = procedure(PlayObject: TPlayObject; var UseItems: _TPLAYUSEITEMS; var WAbil: _TABILITY); stdcall;
  _TOBJECTACTIONUSERSELECT = procedure(Merchant: TMerchant; PlayObject: TPlayObject; pszLabel, pszData: PChar); stdcall;

  _TSCRIPTCMD = function(pszCmd: PChar): Integer; stdcall;

  TRunSocketObject_Open = procedure(GateIdx, nSocket: Integer; sIPaddr: PChar); stdcall;
  TRunSocketObject_Close = procedure(GateIdx, nSocket: Integer); stdcall;
  TRunSocketObject_Eeceive_OK = procedure(); stdcall;
  TRunSocketObject_Data = procedure(GateIdx, nSocket: Integer; MsgBuff: PChar); stdcall;

  _TSCRIPTACTION = procedure(Npc: TObject;
    PlayObject: TObject;
    nCmdCode: Integer;
    pszParam1: PChar;
    nParam1: Integer;
    pszParam2: PChar;
    nParam2: Integer;
    pszParam3: PChar;
    nParam3: Integer;
    pszParam4: PChar;
    nParam4: Integer;
    pszParam5: PChar;
    nParam5: Integer;
    pszParam6: PChar;
    nParam6: Integer); stdcall;
  _TSCRIPTCONDITION = function(Npc: TObject;
    PlayObject: TObject;
    nCmdCode: Integer;
    pszParam1: PChar;
    nParam1: Integer;
    pszParam2: PChar;
    nParam2: Integer;
    pszParam3: PChar;
    nParam3: Integer;
    pszParam4: PChar;
    nParam4: Integer;
    pszParam5: PChar;
    nParam5: Integer;
    pszParam6: PChar;
    nParam6: Integer): Boolean; stdcall;

  _TOBJECTOPERATEMESSAGE = function(BaseObject: TObject;
    wIdent: Word;
    wParam: Word;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    MsgObject: TObject;
    dwDeliveryTime: LongWord;
    pszMsg: PChar;
    var boReturn: Boolean): Boolean; stdcall;


implementation

end.
