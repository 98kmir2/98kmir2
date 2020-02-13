unit HWIDFilter;

interface

uses
  Windows, Messages, SysUtils, Classes, WinSock, SyncObj, MD5;

const
  szBlockHWIDFileName = '.\BlockHWID.txt';
type
  THWIDCnt = record
    HWID: MD5Digest;
    Count: Integer;
  end;
  pTHWIDCnt = ^THWIDCnt;

  THWIDFilter = class(TSyncObj)
    m_xCurList: TList;
    m_xDenyList: TList;
    m_xAllowedList: TList;
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

implementation

uses
  M2Share, HUtil32;

constructor THWIDFilter.Create();
begin
  inherited Create;
  m_xCurList := TList.Create;
  m_xDenyList := TList.Create;
  m_xAllowedList := TList.Create;
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

  for i := 0 to m_xAllowedList.Count - 1 do
    Dispose(pTHWIDCnt(m_xAllowedList[i]));
  m_xAllowedList.Free;

  inherited;
end;

function THWIDFilter.AddDeny(HWID: MD5Digest): Integer;
var
  i: Integer;
  pHWIDCnt: pTHWIDCnt;
begin
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
begin
  ls := TStringList.Create;
  if not FileExists(szBlockHWIDFileName) then
    ls.SaveToFile(szBlockHWIDFileName);
  ls.LoadFromFile(szBlockHWIDFileName);
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
    ls.SaveToFile(szBlockHWIDFileName);
    ls.Free;
  finally
    UnLock();
  end;
end;

function THWIDFilter.IsFilter(HWID: MD5Digest): Boolean;
var
  i: Integer;
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
        if pHWIDCnt.Count + 1 > g_Config.nMaxClientCount then
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

initialization

finalization


end.
