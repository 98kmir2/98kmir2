unit PlugMain;

interface
uses
  Windows,SysUtils, EngineAPI, ExtCtrls, Classes;
procedure InitPlug();
procedure UnInitPlug();
implementation

uses PlayUserCmd, NpcScriptCmd, PlugShare, PlayUser, FunctionConfig;

procedure InitPlug();
begin
  InitPlayUserCmd();
  InitNpcScriptCmd();
  InitPlayUser();
  InitMsgFilter();
end;

procedure UnInitPlug();
begin
  UnInitPlayUserCmd();
  UnInitNpcScriptCmd();
  UnInitPlayUser();
  UnInitMsgFilter();
end;

end.
