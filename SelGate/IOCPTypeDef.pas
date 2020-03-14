unit IOCPTypeDef;

interface

uses
  Windows, SysUtils, WinSock2, Messages;

type
  PIOCPCommObj = ^_tagIOCPCommObj;
  _tagIOCPCommObj = record
    PTRIOKey: WSAOVERLAPPED;
    Socket: TSocket;
    WorkType: DWORD;
    PostTime: DWORD;
    WBuf: WSABUF;
    AddObject: Pointer;
    MemIndex: UINT;
    ABuffer: PChar;
    BBuffer: PChar;
  end;
  TIOCPCommObj = _tagIOCPCommObj;

function PostIOCPRecv(const PIOCPData: PIOCPCommObj): Boolean;
function PostIOCPSend(const PIOCPData: PIOCPCommObj): Boolean;

implementation

function PostIOCPRecv(const PIOCPData: PIOCPCommObj): Boolean;
var
  iRc: Integer;
  dwFlags, dwSendBytes: DWORD;
begin
  dwFlags := 0;
  with PIOCPData^ do
  begin
    PTRIOKey.Internal := 0;
    PTRIOKey.InternalHigh := 0;
    PTRIOKey.Offset := 0;
    PTRIOKey.OffsetHigh := 0;
    PTRIOKey.hEvent := 0;
    iRc := WSARecv(
      Socket,
      @WBuf,
      1,
      dwSendBytes,
      dwFlags,
      @PTRIOKey,
      nil);

    Result := True;
    if iRc = SOCKET_ERROR then
    begin
      iRc := WSAGetLastError();
      if iRc <> WSA_IO_PENDING then
      begin
        Result := False;
      end;
    end;
  end;
end;

function PostIOCPSend(const PIOCPData: PIOCPCommObj): Boolean;
var
  iRc: Integer;
  dwFlags, dwSendBytes: DWORD;
begin
  dwFlags := 0;
  with PIOCPData^ do
  begin
    PTRIOKey.Internal := 0;
    PTRIOKey.InternalHigh := 0;
    PTRIOKey.Offset := 0;
    PTRIOKey.OffsetHigh := 0;
    PTRIOKey.hEvent := 0;
    iRc := WSASend(
      Socket,
      @WBuf,
      1,
      dwSendBytes,
      dwFlags,
      @PTRIOKey,
      nil);

    Result := True;
    if iRc = SOCKET_ERROR then
    begin
      iRc := WSAGetLastError();
      if iRc <> WSA_IO_PENDING then
      begin
        Result := False;
      end;
    end;
  end;
end;

end.
