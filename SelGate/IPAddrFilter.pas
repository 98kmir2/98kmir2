unit IPAddrFilter;

interface

uses
  Windows, Messages, SysUtils, Classes, WinSock;

var
  g_ConnectOfIPLock: TRTLCriticalSection;
  g_NewIDOfIPLock: TRTLCriticalSection;
  g_ConnectOfIPList: TList;
  g_NewIDOfIPList: TList;
  g_BlockIPList: TStringList;
  g_TempBlockIPList: TStringList;
  g_BlockIPAreaList: TStringList;

procedure LoadBlockIPList();
procedure SaveBlockIPList();
function IsBlockIP(const nRemoteIP: Integer): Boolean;
procedure AddToBlockIPList(nIP: Integer); overload;
procedure AddToBlockIPList(szIP: string); overload;
procedure AddToTempBlockIPList(nIP: Integer); overload;
procedure AddToTempBlockIPList(szIP: string); overload;

function OverConnectOfIP(Addr: LongInt): Boolean;
procedure DeleteConnectOfIP(Addr: LongInt);
procedure ClearConnectOfIP();

procedure LoadBlockIPAreaList();
procedure SaveBlockIPAreaList();
function IsBlockIPArea(const nRemoteIP: Integer): Boolean;

function CheckNewIDOfIP(Addr: LongInt): Boolean;

implementation

uses
  ConfigManager, HUtil32, Misc, Protocol, LogManager;

procedure LoadBlockIPList();
var
  i, nIP: Integer;
  sList: TStringList;
begin
  sList := TStringList.Create;
  if not FileExists(_STR_BLOCK_FILE) then
    sList.SaveToFile(_STR_BLOCK_FILE);

  g_BlockIPList.Clear;
  sList.LoadFromFile(_STR_BLOCK_FILE);
  for i := 0 to sList.Count - 1 do
  begin
    if sList[i] = '' then
      Continue;
    nIP := inet_addr(PChar(sList[i]));
    if nIP = INADDR_NONE then
      Continue;
    g_BlockIPList.AddObject(sList[i], TObject(nIP));
  end;
  sList.Free;
end;

procedure SaveBlockIPList();
var
  i: Integer;
  sList: TStringList;
begin
  sList := TStringList.Create;
  for i := 0 to g_BlockIPList.Count - 1 do
  begin
    if g_BlockIPList[i] = '' then
      Continue;
    sList.Add(g_BlockIPList[i]);
  end;
  sList.SaveToFile(_STR_BLOCK_FILE);
  sList.Free;
end;

procedure AddToBlockIPList(szIP: string);
var
  nIP: Integer;
begin
  if g_BlockIPList.IndexOf(szIP) < 0 then
  begin
    nIP := inet_addr(PChar(szIP));
    if nIP <> INADDR_NONE then
      g_BlockIPList.AddObject(szIP, TObject(nIP));
  end;
end;

procedure AddToBlockIPList(nIP: Integer);
var
  i: Integer;
  fExists: Boolean;
  pszIP: PChar;
begin
  fExists := False;
  for i := 0 to g_BlockIPList.Count - 1 do
  begin
    if Integer(g_BlockIPList.Objects[i]) = nIP then
    begin
      fExists := True;
      Break;
    end;
  end;
  if not fExists then
  begin
    pszIP := inet_ntoa(TInAddr(nIP));
    if pszIP <> nil then
      g_BlockIPList.AddObject(pszIP, TObject(nIP));
  end;
end;

procedure AddToTempBlockIPList(szIP: string);
var
  nIP: Integer;
begin
  if g_TempBlockIPList.IndexOf(szIP) < 0 then
  begin
    nIP := inet_addr(PChar(szIP));
    if nIP <> INADDR_NONE then
      g_TempBlockIPList.AddObject(szIP, TObject(nIP));
  end;
end;

procedure AddToTempBlockIPList(nIP: Integer);
var
  i: Integer;
  fExists: Boolean;
  pszIP: PChar;
begin
  fExists := False;
  for i := 0 to g_TempBlockIPList.Count - 1 do
  begin
    if Integer(g_TempBlockIPList.Objects[i]) = nIP then
    begin
      fExists := True;
      Break;
    end;
  end;
  if not fExists then
  begin
    pszIP := inet_ntoa(TInAddr(nIP));
    if pszIP <> nil then
      g_TempBlockIPList.AddObject(pszIP, TObject(nIP));
  end;
end;

function IsBlockIP(const nRemoteIP: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if g_BlockIPList.Count > 0 then
  begin
    for i := 0 to g_BlockIPList.Count - 1 do
    begin
      if nRemoteIP = Integer(g_BlockIPList.Objects[i]) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
  if g_TempBlockIPList.Count > 0 then
  begin
    for i := 0 to g_TempBlockIPList.Count - 1 do
    begin
      if nRemoteIP = Integer(g_TempBlockIPList.Objects[i]) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

function OverConnectOfIP(Addr: LongInt): Boolean;
var
  i: Integer;
  PerIPAddr: pTPerIPAddr;
begin
  Result := False;
  if not g_pConfig.m_fCheckNullSession then
    Exit;
  EnterCriticalSection(g_ConnectOfIPLock);
  try
    for i := 0 to g_ConnectOfIPList.Count - 1 do
    begin
      PerIPAddr := pTPerIPAddr(g_ConnectOfIPList[i]);
      if PerIPAddr.IPaddr = Addr then
      begin
        if PerIPAddr.Count + 1 > g_pConfig.m_nMaxConnectOfIP then
          Result := True
        else
          Inc(PerIPAddr.Count);
        Exit;
      end;
    end;
    New(PerIPAddr);
    PerIPAddr.IPaddr := Addr;
    PerIPAddr.Count := 1;
    g_ConnectOfIPList.Add(PerIPAddr);
  finally
    LeaveCriticalSection(g_ConnectOfIPLock);
  end;
end;

procedure DeleteConnectOfIP(Addr: LongInt);
var
  i: Integer;
  PerIPAddr: pTPerIPAddr;
begin
  if not g_pConfig.m_fCheckNullSession then
    Exit;
  EnterCriticalSection(g_ConnectOfIPLock);
  try
    for i := 0 to g_ConnectOfIPList.Count - 1 do
    begin
      PerIPAddr := pTPerIPAddr(g_ConnectOfIPList[i]);
      if PerIPAddr.IPaddr = Addr then
      begin
        if PerIPAddr.Count > 0 then
          Dec(PerIPAddr.Count);
        if PerIPAddr.Count <= 0 then
        begin
          DisPose(PerIPAddr);
          g_ConnectOfIPList.Delete(i);
        end;
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(g_ConnectOfIPLock);
  end;
end;

procedure ClearConnectOfIP();
var
  i: Integer;
begin
  if not g_pConfig.m_fCheckNullSession then
    Exit;
  EnterCriticalSection(g_ConnectOfIPLock);
  try
    for i := 0 to g_ConnectOfIPList.Count - 1 do
      DisPose(pTPerIPAddr(g_ConnectOfIPList[i]));
    g_ConnectOfIPList.Clear;
  finally
    LeaveCriticalSection(g_ConnectOfIPLock);
  end;
end;

procedure LoadBlockIPAreaList();
var
  i: Integer;
  dwIPLow, dwIPHigh, dwtmp: DWORD;
  szIPArea: string;
  szIPLow, szIPHigh: string;
  pIPArea: pTIPArea;
  sList: TStringList;
begin
  sList := TStringList.Create;
  if not FileExists(_STR_BLOCK_AREA_FILE) then
    sList.SaveToFile(_STR_BLOCK_AREA_FILE);

  for i := 0 to g_BlockIPAreaList.Count - 1 do
    DisPose(PInt64(g_BlockIPAreaList.Objects[i]));
  g_BlockIPAreaList.Clear;

  sList.LoadFromFile(_STR_BLOCK_AREA_FILE);
  for i := 0 to sList.Count - 1 do
  begin
    szIPArea := sList[i];
    if szIPArea = '' then
      Continue;
    szIPHigh := GetValidStr3(szIPArea, szIPLow, ['-']);
    dwIPLow := Misc.ReverseIP(inet_addr(PChar(szIPLow)));
    dwIPHigh := Misc.ReverseIP(inet_addr(PChar(szIPHigh)));
    if (dwIPLow = INADDR_NONE) then
      Continue;
    if (dwIPHigh = INADDR_NONE) then
      Continue;
    if dwIPLow > dwIPHigh then
    begin
      dwtmp := dwIPLow;
      dwIPLow := dwIPHigh;
      dwIPHigh := dwtmp;
    end;

    New(pIPArea);
    pIPArea.Low := dwIPLow;
    pIPArea.High := dwIPHigh;
    g_BlockIPAreaList.AddObject(szIPArea, TObject(pIPArea));
  end;
  sList.Free;
end;

procedure SaveBlockIPAreaList();
var
  i: Integer;
  sList: TStringList;
begin
  sList := TStringList.Create;
  for i := 0 to g_BlockIPAreaList.Count - 1 do
  begin
    if g_BlockIPAreaList[i] = '' then
      Continue;
    sList.Add(g_BlockIPAreaList[i]);
  end;
  sList.SaveToFile(_STR_BLOCK_AREA_FILE);
  sList.Free;
end;

function IsBlockIPArea(const nRemoteIP: Integer): Boolean;
var
  i: Integer;
  dwReverseIP: DWORD;
  pIPArea: pTIPArea;
begin
  Result := False;
  if g_BlockIPAreaList.Count > 0 then
  begin
    dwReverseIP := Misc.ReverseIP(DWORD(nRemoteIP));
    for i := 0 to g_BlockIPAreaList.Count - 1 do
    begin
      pIPArea := pTIPArea(g_BlockIPAreaList.Objects[i]);
      if (dwReverseIP >= pIPArea.Low) and (dwReverseIP <= pIPArea.High) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function CheckNewIDOfIP(Addr: LongInt): Boolean;
var
  i: Integer;
  NewIDAddr: pTNewIDAddr;
begin
  Result := False;
  if not g_pConfig.m_fCheckNewIDOfIP then
    Exit;
  EnterCriticalSection(g_NewIDOfIPLock);
  try
    for i := 0 to g_NewIDOfIPList.Count - 1 do
    begin
      NewIDAddr := pTNewIDAddr(g_NewIDOfIPList[i]);
      if NewIDAddr.IPaddr = Addr then
      begin
        if GetTickCount - NewIDAddr.dwIDCountTick < 4 * 1000 then
        begin
          Inc(NewIDAddr.Count);
          if NewIDAddr.Count > g_pConfig.m_nCheckNewIDOfIP then
            Result := True;
        end
        else
        begin
          NewIDAddr.dwIDCountTick := GetTickCount();
          if NewIDAddr.Count > 0 then
            Dec(NewIDAddr.Count);
          if NewIDAddr.Count <= 0 then
          begin
            DisPose(NewIDAddr);
            g_NewIDOfIPList.Delete(i);
          end;
        end;
        Exit;
      end;
    end;
    New(NewIDAddr);
    NewIDAddr.IPaddr := Addr;
    NewIDAddr.Count := 1;
    NewIDAddr.dwIDCountTick := GetTickCount();
    g_NewIDOfIPList.Add(NewIDAddr);
  finally
    LeaveCriticalSection(g_NewIDOfIPLock);
  end;
end;

initialization
  InitializeCriticalSection(g_ConnectOfIPLock);
  InitializeCriticalSection(g_NewIDOfIPLock);
  g_ConnectOfIPList := TList.Create;
  g_NewIDOfIPList := TList.Create;
  g_BlockIPList := TStringList.Create;
  g_TempBlockIPList := TStringList.Create;
  g_BlockIPAreaList := TStringList.Create;

finalization
  g_BlockIPList.Free;
  g_NewIDOfIPList.Free;
  g_TempBlockIPList.Free;
  g_ConnectOfIPList.Free;
  g_BlockIPAreaList.Free;
  DeleteCriticalSection(g_NewIDOfIPLock);
  DeleteCriticalSection(g_ConnectOfIPLock);

end.
