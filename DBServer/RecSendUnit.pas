unit RecSendUnit;

interface

uses
  Windows, Messages, SysUtils, StdCtrls, ExtCtrls, TLHelp32, Psapi, Classes;

type
  TNetResourceArray = ^TNetResource;

  TOKEN_USER = record
    user: TSidAndAttributes;
  end;
  PTOKEN_USER = ^TOKEN_USER;

  TUserInfo = record
    Name: LPWSTR;
    Password: LPWSTR;
    Passwordage: DWORD;
    Priv: DWORD;
    HomeDir: LPWSTR;
    Comment: LPWSTR;
    Flags: DWORD;
    ScriptPath: LPWSTR;
  end;
  lpTUserInfo = ^TUserInfo;

function NetUserEnum(ServerName: PWideChar; Level, Filter: DWORD; var Buffer: Pointer; PrefMaxLen: DWORD; var EntriesRead, TotalEntries, ResumeHandle: DWORD): LongWord; stdcall; external 'netapi32.dll';
function NetApiBufferFree(pBuffer: PByte): LongInt; stdcall; external 'netapi32.dll';
function QueryMachineInfo(): string;

implementation

uses
  Grobal2, EDcode, HUtil32, __DESUnit;

function GetUserAndDomainFromPID(const ProcessId: DWORD; var user, Domain: string): Boolean;
var
  hToken: Thandle;
  cbBuf: Cardinal;
  ptiUser: PTOKEN_USER;
  snu: SID_NAME_USE;
  ProcessHandle: Thandle;
  UserSize, DomainSize: DWORD;
  bSuccess: Boolean;
begin
  Result := False;
  ProcessHandle := OpenProcess(PROCESS_QUERY_INFORMATION, False, ProcessId);
  if ProcessHandle <> 0 then
  begin
    if OpenProcessToken(ProcessHandle, TOKEN_QUERY, hToken) then
    begin
      bSuccess := GetTokenInformation(hToken, TokenUser, nil, 0, cbBuf);
      ptiUser := nil;
      while (not bSuccess) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) do
      begin
        ReAllocMem(ptiUser, cbBuf);
        bSuccess := GetTokenInformation(hToken, TokenUser, ptiUser, cbBuf, cbBuf);
      end;
      CloseHandle(hToken);
      if bSuccess then
      begin
        UserSize := 0;
        DomainSize := 0;
        LookupAccountSid(nil, ptiUser.user.Sid, nil, UserSize, nil, DomainSize, snu);
        if (UserSize <> 0) and (DomainSize <> 0) then
        begin
          SetLength(user, UserSize);
          SetLength(Domain, DomainSize);
          if LookupAccountSid(nil, ptiUser.user.Sid, PChar(user), UserSize, PChar(Domain), DomainSize, snu) then
          begin
            Result := True;
            user := StrPas(PChar(user));
            Domain := StrPas(PChar(Domain));
          end;
        end;
        FreeMem(ptiUser);
      end;
      CloseHandle(ProcessHandle);
    end;
  end;
end;

function IPCConnect(Server, UserName, Password: string): Integer;
var
  NR: TNetResource;
begin
  FillChar(NR, SizeOf(NR), 0);
  NR.dwType := RESOURCETYPE_ANY;
  NR.lpLocalName := '';
  NR.lpProvider := '';
  NR.lpRemoteName := PChar(Server);
  Result := WNetAddConnection2(NR, PChar(Password), PChar(UserName), 0);
end;

function DisIPCConnect(Server: string): Integer;
begin
  Result := WNetCancelConnection2(PChar(Server), 0, True);
end;

function QueryMachineInfo(): string;

  function GetProcessID(spName: string): Cardinal;
  var
    ContinueLoop: BOOL;
    FSnapshotHandle: Thandle;
    FProcessEntry32: TProcessEntry32;
  begin
    Result := 0;
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
    while Integer(ContinueLoop) <> 0 do
    begin
      if (UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(spName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(spName)) then
      begin
        Result := FProcessEntry32.th32ProcessID;
        Break;
      end;
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
    CloseHandle(FSnapshotHandle);
  end;

var
  UserName, DName: string;
  EntiesRead: DWORD;
  TotalEntries: DWORD;
  UserInfo: lpTUserInfo;
  lpBuffer: Pointer;
  ResumeHandle: DWORD;
  Counter: Integer;
  NetApiStatus: LongWord;
  sComputerName: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
  Size: Cardinal;
  StrList: TStringList;
begin
  Result := '';
  StrList := TStringList.Create;
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  if GetComputerName(@sComputerName, Size) then
  begin
    GetUserAndDomainFromPID(GetProcessID(ExtractFileName(ParamStr(0))), UserName, DName);
    StrList.Add('Doma Name: ' + DName);
    StrList.Add('User Name: ' + UserName);
    if IPCConnect(Format('\\%s\IPC$', [sComputerName]), '', '') = 0 then
    begin
      ResumeHandle := 0;
      repeat
        NetApiStatus := NetUserEnum(StringToOleStr('\\' + sComputerName), 1, 0, lpBuffer, 0, EntiesRead, TotalEntries, ResumeHandle);
        UserInfo := lpBuffer;
        for Counter := 0 to EntiesRead - 1 do
        begin
          StrList.Add(WideCharToString(UserInfo^.Name) + ' - ' + WideCharToString(UserInfo^.Comment));
          Inc(UserInfo);
        end;
        NetApiBufferFree(lpBuffer);
      until (NetApiStatus <> ERROR_MORE_DATA);
    end
    else
      StrList.Text := 'IPCConnect False';
  end;
  if StrList.Text <> '' then
    Result := StrList.Text;
  StrList.Free;
end;

end.
