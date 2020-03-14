unit Filter;

interface

uses
  Windows, Messages, SysUtils, Classes, WinSock, SyncObj, MD5;

type
  THWIDCnt = record
    HWID: MD5Digest;
    Count: Integer;
  end;
  pTHWIDCnt = ^THWIDCnt;

  THWIDFilter = class(TSyncObj)
    m_xCurList: TList;
    m_xDenyList: TList;
  public
    constructor Create();
    destructor Destroy; override;

    function IsFilter(HWID: MD5Digest): Boolean; overload;
    function IsFilter(HWID: MD5Digest; var fOverClientCount: Boolean): Boolean; overload;
    function GetItemCount(HWID: MD5Digest): Integer;
    procedure DecHWIDCount(HWID: MD5Digest);
    procedure ClearHWIDCount();

    function AddDeny(HWID: MD5Digest): Integer;
    function DelDeny(HWID: MD5Digest): Integer;
    procedure ClearDeny();
    procedure LoadDenyList();
    procedure SaveDenyList();
  end;

var
  g_HWIDFilter: THWIDFilter;
  g_ConnectOfIPLock: TRTLCriticalSection;
  //g_csBlockedIPLock : TRTLCriticalSection;
  g_ConnectOfIPList: TList;
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

implementation

uses
  ConfigManager, HUtil32, Misc, Protocol;

constructor THWIDFilter.Create();
begin
  inherited Create;
  m_xCurList := TList.Create;
  m_xDenyList := TList.Create;
end;

destructor THWIDFilter.Destroy;
var
  i: Integer;
begin
  for i := 0 to m_xCurList.Count - 1 do
    Dispose(pTHWIDCnt(m_xCurList[i]));
  m_xCurList.Free;

  for i := 0 to m_xDenyList.Count - 1 do
    Dispose(pTHWIDCnt(m_xDenyList[i]));
  m_xDenyList.Free;

  inherited;
end;

function THWIDFilter.AddDeny(HWID: MD5Digest): Integer;
var
  i: Integer;
  pHWIDCnt: pTHWIDCnt;
begin
  Result := -1;
  Lock();
  try
    for i := 0 to m_xDenyList.Count - 1 do
    begin
      pHWIDCnt := pTHWIDCnt(m_xDenyList[i]);
      if MD5.MD5Match(pHWIDCnt.HWID, HWID) then
      begin
        Result := i;
        Exit;
      end;
    end;
    New(pHWIDCnt);
    pHWIDCnt.HWID := HWID;
    pHWIDCnt.Count := 0;
    Result := m_xDenyList.Add(pHWIDCnt);
  finally
    UnLock();
  end;
end;

function THWIDFilter.DelDeny(HWID: MD5Digest): Integer;
var
  i: Integer;
  pHWIDCnt: pTHWIDCnt;
begin
  Result := -1;
  Lock();
  try
    for i := 0 to m_xDenyList.Count - 1 do
    begin
      pHWIDCnt := pTHWIDCnt(m_xDenyList[i]);
      if MD5.MD5Match(pHWIDCnt.HWID, HWID) then
      begin
        Dispose(pHWIDCnt);
        m_xDenyList.Delete(i);
        Result := i;
        Break;
      end;
    end;
  finally
    UnLock();
  end;
end;

procedure THWIDFilter.ClearDeny();
var
  i: Integer;
  pHWIDCnt: pTHWIDCnt;
begin
  Lock();
  try
    for i := 0 to m_xDenyList.Count - 1 do
    begin
      pHWIDCnt := pTHWIDCnt(m_xDenyList[i]);
      Dispose(pHWIDCnt);
    end;
    m_xDenyList.Clear;
  finally
    UnLock();
  end;
end;

procedure THWIDFilter.LoadDenyList();
var
  i: Integer;
  ls: TStringList;
  pHWIDCnt: pTHWIDCnt;
begin
  ls := TStringList.Create;
  if not FileExists(g_pConfig.m_szBlockHWIDFileName) then
    ls.SaveToFile(g_pConfig.m_szBlockHWIDFileName);
  ls.LoadFromFile(g_pConfig.m_szBlockHWIDFileName);
  for i := 0 to ls.Count - 1 do
  begin
    if (ls[i] = '') or (ls[i][1] = ';') or (Length(ls[i]) <> 32) then
      Continue;
    AddDeny(MD5UnPrint(ls[i]));
  end;
  ls.Free;
end;

procedure THWIDFilter.SaveDenyList();
var
  i: Integer;
  ls: TStringList;
  pHWIDCnt: pTHWIDCnt;
begin
  Lock();
  try
    ls := TStringList.Create;
    for i := 0 to m_xDenyList.Count - 1 do
    begin
      pHWIDCnt := pTHWIDCnt(m_xDenyList[i]);
      ls.Add(MD5Print(pHWIDCnt.HWID));
    end;
    ls.SaveToFile(g_pConfig.m_szBlockHWIDFileName);
    ls.Free;
  finally
    UnLock();
  end;
end;

function THWIDFilter.IsFilter(HWID: MD5Digest): Boolean;
var
  i: Integer;
  fMatch: Boolean;
  pHWIDCnt: pTHWIDCnt;
begin
  Result := False;
  Lock();
  try
    for i := 0 to m_xDenyList.Count - 1 do
    begin
      pHWIDCnt := pTHWIDCnt(m_xDenyList[i]);
      if MD5.MD5Match(pHWIDCnt.HWID, HWID) then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    UnLock();
  end;
end;

function THWIDFilter.IsFilter(HWID: MD5Digest; var fOverClientCount: Boolean): Boolean;
var
  i: Integer;
  fMatch: Boolean;
  pHWIDCnt: pTHWIDCnt;
begin
  Result := False;
  Lock();
  try
    fMatch := False;
    //if g_pConfig.m_nMaxClientCount > 0 then begin
    for i := 0 to m_xCurList.Count - 1 do
    begin
      pHWIDCnt := pTHWIDCnt(m_xCurList[i]);
      if MD5.MD5Match(pHWIDCnt.HWID, HWID) then
      begin
        if pHWIDCnt.Count + 1 > g_pConfig.m_nMaxClientCount then
        begin
          Result := True;
          fOverClientCount := True;
        end
        else
        begin
          Inc(pHWIDCnt.Count);
        end;
        fMatch := True;
        Break;
      end;
    end;
    if not fMatch then
    begin
      New(pHWIDCnt);
      pHWIDCnt.HWID := HWID;
      pHWIDCnt.Count := 1;
      m_xCurList.Add(pHWIDCnt);
    end;
    //end;
    if not Result then
    begin
      for i := 0 to m_xDenyList.Count - 1 do
      begin
        pHWIDCnt := pTHWIDCnt(m_xDenyList[i]);
        if MD5.MD5Match(pHWIDCnt.HWID, HWID) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  finally
    UnLock();
  end;
end;

function THWIDFilter.GetItemCount(HWID: MD5Digest): Integer;
var
  i: Integer;
  pHWIDCnt: pTHWIDCnt;
begin
  Result := 0;
  Lock();
  try
    for i := 0 to m_xCurList.Count - 1 do
    begin
      pHWIDCnt := pTHWIDCnt(m_xCurList[i]);
      if MD5.MD5Match(pHWIDCnt.HWID, HWID) then
      begin
        Result := pHWIDCnt.Count;
        Break;
      end;
    end;
  finally
    UnLock();
  end;
end;

procedure THWIDFilter.DecHWIDCount(HWID: MD5Digest);
var
  i: Integer;
  pHWIDCnt: pTHWIDCnt;
begin
  Lock();
  try
    for i := 0 to m_xCurList.Count - 1 do
    begin
      pHWIDCnt := pTHWIDCnt(m_xCurList[i]);
      if MD5.MD5Match(pHWIDCnt.HWID, HWID) then
      begin
        if pHWIDCnt.Count > 0 then
          Dec(pHWIDCnt.Count);
        if pHWIDCnt.Count = 0 then
        begin
          Dispose(pHWIDCnt);
          m_xCurList.Delete(i);
        end;
        Break;
      end;
    end;
  finally
    UnLock();
  end;
end;

procedure THWIDFilter.ClearHWIDCount();
var
  i: Integer;
  pHWIDCnt: pTHWIDCnt;
begin
  Lock();
  try
    for i := 0 to m_xCurList.Count - 1 do
    begin
      Dispose(pTHWIDCnt(m_xCurList[i]));
    end;
    m_xCurList.Clear;
  finally
    UnLock();
  end;
end;

procedure LoadBlockIPList();
var
  i, nIP: Integer;
  sList: TStringList;
begin
//  EnterCriticalSection(g_csBlockedIPLock);
//  try
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
//  finally
//    LeaveCriticalSection(g_csBlockedIPLock);
//  end;
end;

procedure SaveBlockIPList();
var
  i: Integer;
  sList: TStringList;
begin
//  EnterCriticalSection(g_csBlockedIPLock);
//  try
  sList := TStringList.Create;
  for i := 0 to g_BlockIPList.Count - 1 do
  begin
    if g_BlockIPList[i] = '' then
      Continue;
    sList.Add(g_BlockIPList[i]);
  end;
  sList.SaveToFile(_STR_BLOCK_FILE);
  sList.Free;
//  finally
//    LeaveCriticalSection(g_csBlockedIPLock);
//  end;
end;

procedure AddToBlockIPList(szIP: string);
var
  nIP: Integer;
begin
//  EnterCriticalSection(g_csBlockedIPLock);
//  try
  if g_BlockIPList.IndexOf(szIP) < 0 then
  begin
    nIP := inet_addr(PChar(szIP));
    if nIP <> INADDR_NONE then
      g_BlockIPList.AddObject(szIP, TObject(nIP));
  end;
//  finally
//    LeaveCriticalSection(g_csBlockedIPLock);
//  end;
end;

procedure AddToBlockIPList(nIP: Integer);
var
  i: Integer;
  fExists: Boolean;
  pszIP: PChar;
begin
//  EnterCriticalSection(g_csBlockedIPLock);
//  try
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
//  finally
//    LeaveCriticalSection(g_csBlockedIPLock);
//  end;
end;

procedure AddToTempBlockIPList(szIP: string);
var
  nIP: Integer;
begin
//  EnterCriticalSection(g_csBlockedIPLock);
//  try
  if g_TempBlockIPList.IndexOf(szIP) < 0 then
  begin
    nIP := inet_addr(PChar(szIP));
    if nIP <> INADDR_NONE then
      g_TempBlockIPList.AddObject(szIP, TObject(nIP));
  end;
//  finally
//    LeaveCriticalSection(g_csBlockedIPLock);
//  end;
end;

procedure AddToTempBlockIPList(nIP: Integer);
var
  i: Integer;
  fExists: Boolean;
  pszIP: PChar;
begin
//  EnterCriticalSection(g_csBlockedIPLock);
//  try
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
//  finally
//    LeaveCriticalSection(g_csBlockedIPLock);
//  end;
end;

function IsBlockIP(const nRemoteIP: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
//  EnterCriticalSection(g_csBlockedIPLock);
//  try
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
//  finally
//    LeaveCriticalSection(g_csBlockedIPLock);
//  end;
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
          Dispose(PerIPAddr);
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
      Dispose(pTPerIPAddr(g_ConnectOfIPList[i]));
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
//  EnterCriticalSection(g_csBlockedIPLock);
//  try
  sList := TStringList.Create;
  if not FileExists(_STR_BLOCK_AREA_FILE) then
    sList.SaveToFile(_STR_BLOCK_AREA_FILE);

  for i := 0 to g_BlockIPAreaList.Count - 1 do
    Dispose(PInt64(g_BlockIPAreaList.Objects[i]));
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
//  finally
//    LeaveCriticalSection(g_csBlockedIPLock);
//  end;
end;

procedure SaveBlockIPAreaList();
var
  i: Integer;
  sList: TStringList;
begin
//  EnterCriticalSection(g_csBlockedIPLock);
//  try
  sList := TStringList.Create;
  for i := 0 to g_BlockIPAreaList.Count - 1 do
  begin
    if g_BlockIPAreaList[i] = '' then
      Continue;
    sList.Add(g_BlockIPAreaList[i]);
  end;
  sList.SaveToFile(_STR_BLOCK_AREA_FILE);
  sList.Free;
//  finally
//    LeaveCriticalSection(g_csBlockedIPLock);
//  end;
end;

function IsBlockIPArea(const nRemoteIP: Integer): Boolean;
var
  i: Integer;
  dwReverseIP: DWORD;
  pIPArea: pTIPArea;
begin
  Result := False;
//  EnterCriticalSection(g_csBlockedIPLock);
//  try
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
//  finally
//    LeaveCriticalSection(g_csBlockedIPLock);
//  end;
end;

initialization
  InitializeCriticalSection(g_ConnectOfIPLock);
//  InitializeCriticalSection(g_csBlockedIPLock);

  g_ConnectOfIPList := TList.Create;
  g_BlockIPList := TStringList.Create;
  g_TempBlockIPList := TStringList.Create;
  g_BlockIPAreaList := TStringList.Create;

finalization
  g_BlockIPList.Free;
  g_TempBlockIPList.Free;
  g_ConnectOfIPList.Free;
  g_BlockIPAreaList.Free;
//  DeleteCriticalSection(g_csBlockedIPLock);
  DeleteCriticalSection(g_ConnectOfIPLock);

end.
