unit SDK;

interface
//uses
  //Windows;

const
  //////--------------- And By Blue------2006-01-05---------///////////
  SG_FORMHANDLE = 1000;
  SG_STARTNOW = 1001;
  SG_STARTOK = 1002;
  SG_USERACCOUNT = 1003;
  SG_USERACCOUNTNOTFOUND = 1004;
  SG_USERACCOUNTCHANGESTATUS = 1005;
  SG_CHECKCODEADDR = 1006;
  GS_QUIT = 2000;
  GS_USERACCOUNT = 2001;
  GS_CHANGEACCOUNTINFO = 2002;
  WM_SENDPROCMSG = $0401;

type
  TProgamType = (
    MsgData = 1,
    tDBServer = 0,
    tLoginSrv = 2,
    tWolServer = 3,
    //tM2Server = 3,
    tLogServer = 4,
    tRunGate = 5,
    tRunGate1 = 6,
    tRunGate2 = 7,
    tRunGate3 = 8,
    tRunGate4 = 9,
    tRunGate5 = 10,
    tRunGate6 = 11,
    tRunGate7 = 12,
    tSelGate = 13,
    tSelGate1 = 14,
    tLoginGate = 15,
    tLoginGate1 = 16
    );

  TCheckCode = record
    dwThread0: Integer;
    sThread0: Integer;
  end;

  TpConfig = record
    nCheckLicenseFail: Integer;
    dwRequestVersion: Integer;
    nProcessTick: LongWord;
    nProcesstime: LongWord;
  end;
  pTpConfig = ^TpConfig;

implementation

end.

