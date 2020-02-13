library zPlugOfEngine;
{
================================================================================
 �������湦�ܲ��API������API�ӿڣ����������е����湦�ܻ�������չ�����Ĺ��ܡ�
 ��վ��http://www.51ggame.com
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
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/8/18)';
  LoadPlus = '���ڼ���ƮƮ�������湦�ܲ��';
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

