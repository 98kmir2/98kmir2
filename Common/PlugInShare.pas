unit PlugInShare;

interface
uses
  Windows, Classes;
const
  ARRAYLEN                  = 99;

type
  TPlugInfo = packed record
    sDllName: string;
    sDesc: string;
    mModule: THandle;
  end;
  pTPlugInfo = ^TPlugInfo;

  TProc = packed record
    sProcName: string;
    nProcAddr: Pointer;
  end;
  TProcArray = array[0..ARRAYLEN] of TProc;

  TMyObject = packed record
    sObjcName: string;
    oObject: TObject;
  end;
  TObjectArray = array[0..ARRAYLEN] of TMyObject;

  TClassProc = procedure(Sender: TObject);
  TMsgProc = procedure(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
  TIPLocal = procedure(IPAddr: PChar; var IP: array of Char; IPSize: Integer); stdcall;
  TFindProc = function(ProcName: PChar; nNameLen: Integer): Pointer; stdcall;
  TSetProc = function(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
  TFindObj = function(ObjName: PChar; nNameLen: Integer): TObject; stdcall;
  TPlugInit = function(AppHandle: HWND; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; FindObj: TFindObj): PChar; stdcall;
  TDeCryptString = procedure(Src, Dest: PChar; nSrc: Integer; var nDest: Integer); stdcall;
  TPlugConfig = procedure(); stdcall;

implementation

end.

