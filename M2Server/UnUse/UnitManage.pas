unit UnitManage;

interface
uses
  Windows, Grobal2, MudUtil;
type
  TThreadInfo = record
    nRunFlag: Integer; //0x00
    boActived: BOOL; //0x04
    dwRunTick: LongWord; //0x08
    Config: pTConfig; //0x0C
    boTerminaled: BOOL; //0x10
    hThreadHandle: THandle; //0x14
    dwThreadID: LongWord; //0x18
    n1C: Integer; //0x1C
    n20: Integer; //0x20
    n24: Integer; //0x24
    nRunTime: LongWord;
    nMaxRunTime: LongWord;
  end;
  pTThreadInfo = ^TThreadInfo;
  
procedure StartRegThread(Config: pTConfig; ThreadInfo: pTThreadInfo);
procedure RegServerThread(ThreadInfo: pTThreadInfo); stdcall;

implementation

procedure StartRegThread(Config: pTConfig; ThreadInfo: pTThreadInfo);
begin
  ThreadInfo.Config := Config;
  ThreadInfo.hThreadHandle := CreateThread(nil,
    0,
    @RegServerThread,
    ThreadInfo,
    0,
    ThreadInfo.dwThreadID);
end;

procedure RegServerThread(ThreadInfo: pTThreadInfo); stdcall;
begin

end;
end.
