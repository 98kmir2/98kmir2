unit PlugIn;

interface

uses
  {FastMove,} Windows, Classes, SysUtils, Forms, Grobal2, SDK;

type
  TPlugInManage = class
    PlugList: TStringList;
  public
    constructor Create();
    destructor Destroy; override;
    procedure LoadPlugIn();
    procedure UnLoadPlugIn();
    function StartM2ServerDLL(): Boolean;
  end;

procedure MainMessage(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
procedure SendBroadCastMsg(Msg: PChar; MsgType: TMsgType); stdcall;
function FindProcTable(ProcName: PChar; nNameLen: Integer): Pointer; stdcall;
function SetProcTable(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall
function FindOBjTable(ObjName: PChar; nNameLen: Integer): TObject; stdcall;

implementation

uses M2Share, EDcode, MudUtil, VMProtectSDK;

const
  StrProc5 = 'PrQpORAtQSIaX`IkYRup';
  StrProc6 = 'PrQpPbQiWsMaR@yNNrQu';
  StrFun1 = 'MrQpQbQnXrakW\'; //GetVersion
  StrFun2 = 'MrQpR@yNNrQu'; //GetXORKey

var
  nM2ServerVersion: PInteger;
  nStartPlug: PInteger;

procedure TPlugInManage.LoadPlugIn;
var
  i: Integer;
  LoadList: TStringList;
  sPlugLibName: string;
  sPlugLibFileName: string;
  Moudle: THandle;
  PFunc: TPlugInit;
  PlugInfo: pTPlugInfo;
resourcestring
  sDLLInit = 'Init';
begin
  Exit;
{$I '..\Common\Macros\VMPB.inc'}
  LoadList := TStringList.Create;
  LoadList.Add(sIPlocalDLL);
  LoadList.Add(sPlugOfScript);
  LoadList.Add(sPlugOfEngine);
  //LoadList.Add(sSystemModule);
  for i := 0 to LoadList.Count - 1 do
  begin
    sPlugLibName := Trim(LoadList.Strings[i]);
    if (sPlugLibName = '') or (sPlugLibName[1] = ';') then
      Continue;
    sPlugLibFileName := g_Config.sPlugDir + sPlugLibName;
    if FileExists(sPlugLibFileName) then
    begin
      Moudle := LoadLibrary(PChar(sPlugLibFileName));
      if Moudle > 32 then
      begin
        PFunc := GetProcAddress(Moudle, PChar(sDLLInit));
        if @PFunc <> nil then
        begin
          New(PlugInfo);
          PlugInfo.DllName := sPlugLibFileName;
          PlugInfo.Module := Moudle;
          PlugInfo.sDesc := PFunc(Application.Handle, MainMessage, FindProcTable, SetProcTable, FindOBjTable);
          PlugList.AddObject(PlugInfo.sDesc, TObject(PlugInfo));
        end;
      end;
    end;
  end;
  LoadList.Free;
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure MainMessage(Msg: PChar; nMsgLen: Integer; nMode: Integer);
var
  MsgBuff: string;
begin
  if (Msg <> nil) and (nMsgLen > 0) then
  begin
    SetLength(MsgBuff, nMsgLen);
    Move(Msg^, MsgBuff[1], nMsgLen);
    case nMode of
      0: if g_MainMemo <> nil then
          g_MainMemo.Lines.Add(MsgBuff);
    else
      MainOutMessageAPI(MsgBuff);
    end;
  end;
end;

procedure SendBroadCastMsg(Msg: PChar; MsgType: TMsgType); stdcall;
begin
  if UserEngine <> nil then
    UserEngine.SendBroadCastMsgExt2(Msg, MsgType);
end;

function FindProcTable(ProcName: PChar; nNameLen: Integer): Pointer;
var
  i: Integer;
  sProcName: string;
begin
  Result := nil;
  SetLength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  for i := Low(ProcArray) to High(ProcArray) do
  begin
    if (ProcArray[i].nProcAddr <> nil) and (CompareText(sProcName, ProcArray[i].sProcName) = 0) then
    begin
      Result := ProcArray[i].nProcAddr;
      Break;
    end;
  end;
end;

function SetProcTable(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean;
var
  i: Integer;
  sProcName: string;
begin
  Result := False;
  SetLength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  for i := Low(PlugProcArray) to High(PlugProcArray) do
  begin
    if (PlugProcArray[i].nProcAddr = nil) and (CompareText(sProcName, PlugProcArray[i].sProcName) = 0) then
    begin
      PlugProcArray[i].nProcAddr := ProcAddr;
      Result := True;
      Break;
    end;
  end;
end;

function FindOBjTable(ObjName: PChar; nNameLen: Integer): TObject;
var
  i: Integer;
  sObjName: string;
begin
  Result := nil;
  SetLength(sObjName, nNameLen);
  Move(ObjName^, sObjName[1], nNameLen);
  for i := Low(ProcArray) to High(ProcArray) do
  begin
    if (ObjectArray[i].Obj <> nil) and (CompareText(sObjName, ObjectArray[i].sObjcName) = 0) then
    begin
      Result := ObjectArray[i].Obj;
      Break;
    end;
  end;
end;

constructor TPlugInManage.Create;
begin
  PlugList := TStringList.Create;
  //FillChar(ProcArray,SizeOf(ProcArray),0);
end;

destructor TPlugInManage.Destroy;
begin
  if PlugList.Count > 0 then
    UnLoadPlugIn();
  PlugList.Free;
  inherited;
end;

function TPlugInManage.StartM2ServerDLL: Boolean;
type
  TGetVersion = function(): Single; stdcall;
  TStartPlug = function(nConfig: pTConfig): Boolean;
begin
{$IF NEED_REG = 0} // 2019-09-16
  Result := True
{$ELSE}
{$IF USEWLSDK > 0}
{$I '..\Common\Macros\VMPB.inc'}
{$IFEND USEWLSDK}
  if ((nM2ServerVersion^ >= 0) and Assigned(PlugProcArray[nM2ServerVersion^].nProcAddr)) and
    (TGetVersion(PlugProcArray[nM2ServerVersion^].nProcAddr) = 1) and
    ((nStartPlug^ >= 0) and Assigned(PlugProcArray[nStartPlug^].nProcAddr)) then
  begin
    if TStartPlug(PlugProcArray[nStartPlug^].nProcAddr)(@g_Config) then
      Result := True;
  end
  else
  begin
    g_MapManager.Free;
    FrontEngine.Free;
    UserEngine.Free;
    Result := False;
  end;
{$IF USEWLSDK > 0}
{$I '..\Common\Macros\VMPE.inc'}
{$IFEND USEWLSDK}
{$IFEND NEED_REG}
end;

procedure TPlugInManage.UnLoadPlugIn;
resourcestring
  sPlunUnInit = 'UnInit';
begin
{$IF NEED_REG = 0} // 2019-09-16
  //exit;
{$ELSE}
  for i := 0 to PlugList.Count - 1 do
  begin
    //Module := THandle(PlugList.Objects[i]);
    Module := pTPlugInfo(PlugList.Objects[i]).Module;
    PFunc := GetProcAddress(Module, PChar(sPlunUnInit));
    if @PFunc <> nil then
      PFunc();

    FreeLibrary(Module);
    Dispose(pTPlugInfo(PlugList.Objects[i]));
  end;
  PlugList.Clear;
{$IFEND NEED_REG}
end;

procedure SetRemoteXORKey(nRemoteXORKey: Integer; XORStr: PChar); stdcall;
begin
  RemoteXORKey := nRemoteXORKey;
end;

function GetVersion(): Single; stdcall;
begin
  Result := M2ServerVersion;
end;

function GetXORKey(): Integer; stdcall;
begin
  LocalXORKey := GetTickCount;
  Result := LocalXORKey;
end;

procedure SetMaxUserCount(nUserCount: Integer); stdcall;
begin

end;

initialization
{$I '..\Common\Macros\VMPB.inc'}
  New(nM2ServerVersion);
  New(nStartPlug);
  nM2ServerVersion^ := -1;
  nStartPlug^ := -1;
  AddToProcTable(@SendBroadCastMsg, PN_SENDBROADCASTMSG);
  nM2ServerVersion^ := AddToPulgProcTable({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('M2ServerVersion') {'M2ServerVersion'});
  nStartPlug^ := AddToPulgProcTable({$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('StartPlug') {'StartPlug'});
  AddToProcTable(@SetMaxUserCount, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SetMaxUserCount')); {SetMaxUserCount}
  AddToProcTable(@SetRemoteXORKey, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('SetRemoteXORKey')); {SetRemoteXORKey}
  AddToProcTable(@GetVersion, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('GetVersion')); {GetVersion}
  AddToProcTable(@GetXORKey, {$IF USEWLSDK > 0}VMProtectDecryptStringA{$IFEND USEWLSDK}('GetXORKey')); {GetXORKey}
{$I '..\Common\Macros\VMPE.inc'}

finalization

end.
