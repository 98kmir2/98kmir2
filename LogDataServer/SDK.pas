unit SDK;

interface
//uses
  //Windows;

const
  SG_FORMHANDLE = 1000;
  SG_STARTNOW = 1001;
  SG_STARTOK = 1002;
  SG_USERACCOUNT = 1003;
  SG_USERACCOUNTCHANGESTATUS = 1004;
  SG_CHECKCODEADDR = 1006;
  GS_USERACCOUNT = 1007;
  SG_USERACCOUNTNOTFOUND = 1008;
  GS_CHANGEACCOUNTINFO = 1009;
  GS_QUIT = 2000;
  WM_SENDPROCMSG = $0401;

type
  TProgamType = (MsgData,
    tDBServer,
    tLoginSrv,
    tLogServer,
    tWolServer,
    tLoginGate,
    tLoginGate1,
    tSelGate,
    tSelGate1,
    tRunGate,
    tRunGate1,
    tRunGate2,
    tRunGate3,
    tRunGate4,
    tRunGate5,
    tRunGate6,
    tRunGate7);
  TCheckCode = record
    dwThread0: Integer;
    sThread0: Integer;
  end;

implementation

end.

