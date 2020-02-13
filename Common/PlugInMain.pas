unit PlugInMain;

interface
uses
  Windows, Classes, SysUtils, Forms, Grobal2, SDK;
type
  TPlugInManage = class
    PlugList: TStringList;
  public
    constructor Create();
    destructor Destroy; override;
    procedure LoadPlugIn();
    procedure UnLoadPlugIn();
    procedure StartM2ServerDLL();
  end;

procedure MainMessage(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
procedure SendBroadCastMsg(Msg: PChar; MsgType: TMsgType); stdcall;
function FindProcTable(ProcName: PChar; nNameLen: Integer): Pointer; stdcall;
function SetProcTable(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall
function FindOBjTable(ObjName: PChar; nNameLen: Integer): TObject; stdcall;

implementation

uses M2Share, EDcode, MudUtil;

const
  StrProc5                  = 'PrQpORAtQSIaX`IkYRup';
  StrProc6                  = 'PrQpPbQiWsMaR@yNNrQu';
  StrFun1                   = 'MrQpQbQnXrakW\'; //GetVersion
  StrFun2                   = 'MrQpR@yNNrQu'; //GetXORKey

var
  nM2ServerVersion          : Integer = -1;
  nStartPlug                : Integer = -1;

procedure TPlugInManage.LoadPlugIn;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sPlugFileName             : string;
  sPlugLibName              : string;
  sPlugLibFileName          : string;
  Moudle                    : THandle;
  PFunc                     : TPlugInit;
  PlugInfo                  : pTPlugInfo;
  boCheckOK                 : Boolean;
resourcestring
  sPlugOfScript             = 'mPlugOfScript.dll';
  //sPlugOfEngine             = 'mPlugOfEngine.dll';
  //sPlugOfShop               = 'mPlugOfShop.dll';
  //sMirServerDLL             = 'MirServer.dll';
  sSystemModule             = 'mSystemModule.dll';
  sIPlocalDLL               = 'IPLocal.dll';
  sDLLInit                  = 'Init';
begin
  g_nDebugCode := 41541528;
  //{$IF PLUGINLIST = 1}
  //InitPlugArrayTable();
  //sPlugFileName := g_Config.sPlugDir + 'PlugList.txt';
  //if not FileExists(sPlugFileName) then begin
  //  LoadList := TStringList.Create;
  //  LoadList.Add(sMirServerDLL);
  //  LoadList.SaveToFile(sPlugFileName);
  //  LoadList.Free;
  //end;
  //{$ELSE}
  asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
  LoadList := TStringList.Create;
  asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
  LoadList.Add(sSystemModule);
  asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
  //LoadList.Add(sPlugOfEngine);
  //asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
  LoadList.Add(sIPlocalDLL);
  asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
  LoadList.Add(sPlugOfScript);
  asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
  //LoadList.Add(sPlugOfShop);
  asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
  //{$IFEND}
  //{$IF PLUGINLIST = 1}
  //LoadList := TStringList.Create;
  //LoadList.LoadFromFile(sPlugFileName);
  //boCheckOK := False;
  //for i := 0 to LoadList.Count - 1 do begin
  //  sPlugLibName := Trim(LoadList.Strings[i]);
  //  if CompareText(sPlugLibName, sMirServerDLL) = 0 then begin
  //    boCheckOK := True;
  //    Break;
  //  end;
  //end;
  //if not boCheckOK then
  //  LoadList.Add(sMirServerDLL);
  //{$IFEND}
  asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
  for i := 0 to LoadList.Count - 1 do begin
    asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
    sPlugLibName := Trim(LoadList.Strings[i]);
    asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
    if (sPlugLibName = '') or (sPlugLibName[1] = ';') then
      Continue;
    asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
    sPlugLibFileName := g_Config.sPlugDir + sPlugLibName;
    asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
    if FileExists(sPlugLibFileName) then begin
      asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
      Moudle := LoadLibrary(PChar(sPlugLibFileName));
      asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
      if Moudle > 32 then begin
        asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
        PFunc := GetProcAddress(Moudle, PChar(sDLLInit));
        asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
        if @PFunc <> nil then begin
          asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
          New(PlugInfo);
          asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
          PlugInfo.DllName := sPlugLibFileName;
          asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
          PlugInfo.Module := Moudle;
          asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
          PlugInfo.sDesc := PFunc(Application.Handle, MainMessage, FindProcTable, SetProcTable, FindOBjTable);
          asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
          PlugList.AddObject(PlugInfo.sDesc, TObject(PlugInfo));
          asm DB $EB,$06,$55,$44,$55,$03,$55,$09; end;
        end;
      end;
    end;
  end;
  LoadList.Free;
end;

procedure MainMessage(Msg: PChar; nMsgLen: Integer; nMode: Integer);
var
  MsgBuff                   : string;
begin
  if (Msg <> nil) and (nMsgLen > 0) then begin
    SetLength(MsgBuff, nMsgLen);
    Move(Msg^, MsgBuff[1], nMsgLen);
    case nMode of
      0: if g_MainMemo <> nil then g_MainMemo.Lines.Add(MsgBuff);
    else
      MainOutMessageAPI(MsgBuff);
    end;
  end;
end;

procedure SendBroadCastMsg(Msg: PChar; MsgType: TMsgType); stdcall;
begin
  if UserEngine <> nil then
    UserEngine.SendBroadCastMsgExt(Msg, MsgType);
end;

function FindProcTable(ProcName: PChar; nNameLen: Integer): Pointer;
var
  i                         : Integer;
  sProcName                 : string;
begin
  Result := nil;
  SetLength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  for i := Low(ProcArray) to High(ProcArray) do begin
    if (ProcArray[i].nProcAddr <> nil) and (CompareText(sProcName, ProcArray[i].sProcName) = 0) then begin
      Result := ProcArray[i].nProcAddr;
      Break;
    end;
  end;
end;

function SetProcTable(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean;
var
  i                         : Integer;
  sProcName                 : string;
begin
  Result := False;
  SetLength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  for i := Low(PlugProcArray) to High(PlugProcArray) do begin
    if (PlugProcArray[i].nProcAddr = nil) and (CompareText(sProcName, PlugProcArray[i].sProcName) = 0) then begin
      PlugProcArray[i].nProcAddr := ProcAddr;
      Result := True;
      Break;
    end;
  end;
end;

function FindOBjTable(ObjName: PChar; nNameLen: Integer): TObject;
var
  i                         : Integer;
  sObjName                  : string;
begin
  Result := nil;
  SetLength(sObjName, nNameLen);
  Move(ObjName^, sObjName[1], nNameLen);
  for i := Low(ProcArray) to High(ProcArray) do begin
    if (ObjectArray[i].Obj <> nil) and (CompareText(sObjName, ObjectArray[i].sObjcName) = 0) then begin
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
  if PlugList.Count > 0 then UnLoadPlugIn();
  PlugList.Free;
  inherited;
end;

procedure TPlugInManage.StartM2ServerDLL;
type
  TGetVersion = function(): Single; stdcall;
  TStartPlug = procedure(nConfig: pTConfig);
begin
  if (nM2ServerVersion >= 0) and Assigned(PlugProcArray[nM2ServerVersion].nProcAddr) then begin
    if TGetVersion(PlugProcArray[nM2ServerVersion].nProcAddr) = 1 then begin
      if (nStartPlug >= 0) and Assigned(PlugProcArray[nStartPlug].nProcAddr) then
        TStartPlug(PlugProcArray[nStartPlug].nProcAddr)(@g_Config);
    end;
  end;
end;

procedure TPlugInManage.UnLoadPlugIn;
var
  i                         : Integer;
  Module                    : THandle;
  PFunc                     : procedure();
resourcestring
  sPlunUnInit               = 'UnInit';
begin
  for i := 0 to PlugList.Count - 1 do begin
    Module := THandle(PlugList.Objects[i]);
    PFunc := GetProcAddress(Module, PChar(sPlunUnInit));
    if @PFunc <> nil then
      PFunc();
    FreeLibrary(Module);
  end;
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
  AddToProcTable(@SendBroadCastMsg, PN_SENDBROADCASTMSG);
  nM2ServerVersion := AddToPulgProcTable(DecodeString('OOEOUSErUSERUSEoVRyj') {'M2ServerVersion'});
  nStartPlug := AddToPulgProcTable(DecodeString('PsM]XcMLWCQc') {'StartPlug'});
  AddToProcTable(@SetMaxUserCount, DecodeString(StrProc5)); {SetMaxUserCount}
  AddToProcTable(@SetRemoteXORKey, DecodeString(StrProc6)); {SetRemoteXORKey}
  AddToProcTable(@GetVersion, DecodeString(StrFun1)); {GetVersion}
  AddToProcTable(@GetXORKey, DecodeString(StrFun2)); {GetXORKey}

finalization

end.

