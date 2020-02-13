library zPlugOfEngine;
{
================================================================================
 增加引擎功能插件API，利用API接口，可以在现有的引擎功能基础上扩展大量的功能。
 网站：http://www.51ggame.com
 QQ:240621028
================================================================================
}

uses
  Windows,
  SysUtils,
  Classes,
  PlugMain in 'PlugMain.pas',
  PlayUserCmd in 'PlayUserCmd.pas',
  NpcScriptCmd in 'NpcScriptCmd.pas',
  PlugShare in 'PlugShare.pas',
  EngineAPI in '..\PlugInCommon\EngineAPI.pas',
  HUtil32 in '..\PlugInCommon\HUtil32.pas',
  PlayUser in 'PlayUser.pas',
  EngineType in '..\PlugInCommon\EngineType.pas',
  FunctionConfig in 'FunctionConfig.pas' {FrmFunctionConfig};

{$R *.res}
const
  PlugName = '飘飘网络引擎功能插件 (2006/8/18)';
  LoadPlus = '正在加载飘飘网络引擎功能插件';
  nFindObj = 5;
  nPlugHandle = 6;
type
  TMsgProc = procedure(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
  TFindProc = function(sProcName: PChar; nNameLen: Integer): Pointer; stdcall;
  TFindObj = function(sObjName: PChar; nNameLen: Integer): TObject; stdcall;
  TSetProc = function(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
  TGetFunAddr = function(nIndex: Integer): Pointer; stdcall;
function Init(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; GetFunAddr: TGetFunAddr): PChar; stdcall;
//var
  //FindObj: TFindObj;
begin
  PlugHandle := 0;
  MsgProc(LoadPlus, length(LoadPlus), 0);
  //FindObj := TFindObj(GetFunAddr(nFindObj));
  PlugHandle := PInteger(GetFunAddr(nPlugHandle))^;
  InitPlug();
  Result := PlugName;
end;

procedure UnInit();
begin
  UnInitPlug();
end;

procedure Config(); stdcall;
begin
  FrmFunctionConfig := TFrmFunctionConfig.Create(nil);
  FrmFunctionConfig.Open();
  FrmFunctionConfig.Free;
end;

exports
  Init, UnInit, Config;
begin

end.

