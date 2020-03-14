unit SHSocket;

interface

uses
  Windows, Messages, SysUtils, WinSock2, IOCPTypeDef;

const
  RCVALL_OFF = 0;
  RCVALL_ON = 1;
  RCVALL_SOCKETLEVELONLY = 2;

  BUFFER_FULL_COUNT = 128;
  WRITE_BUF_LOCK_TIMEOUT = 20;
  SLEEP_WAIT_FACTIVE = 5000;
  IOC_VENDOR = $18000000;
  SIO_KEEPALIVE_VALS = IOC_IN or IOC_VENDOR or 4;
  LISTEN_MAX_USER_COUNT = 200;
  IPTOS_THROUGHPUT = $0008;

type
  PTCP_KEEPALIVE = ^_tcp_keepalive;
  _tcp_keepalive = record
    OnOff: DWORD;
    KeepAliveTime: DWORD;
    KeepAliveInterval: DWORD;
  end;
  TCP_KEEPALIVE = _tcp_keepalive;

type
  LPTRANSMIT_FILE_BUFFERS = ^_TRANSMIT_FILE_BUFFERS;
  _TRANSMIT_FILE_BUFFERS = record
    Head: Pointer;
    HeadLength: DWORD;
    Tail: Pointer;
    TailLength: DWORD;
  end;
  TRANSMIT_FILE_BUFFERS = _TRANSMIT_FILE_BUFFERS;

function TransmitFile(
  hSocket: TSocket;
  hFile: THANDLE;
  nNumberOfBytesToWrite,
  nNumberOfBytesPerSend: DWORD;
  lpOverlapped: LPWSAOVERLAPPED;
  lpTransmitBuffers: LPTRANSMIT_FILE_BUFFERS;
  dwReserved: DWORD
  ): BOOL; stdcall; external 'mswsock.dll' Name 'TransmitFile';

function AcceptEx(
  sListenSocket,
  sAcceptSocket: TSocket;
  lpOutputBuffer: Pointer;
  dwReceiveDataLength,
  dwLocalAddressLength,
  dwRemoteAddressLength: DWORD;
  var lpdwBytesReceived: DWORD;
  lpOverlapped: LPWSAOVERLAPPED
  ): BOOL; stdcall; external 'mswsock.dll' Name 'AcceptEx';

procedure GetAcceptExSockaddrs(
  lpOutputBuffer: Pointer;
  dwReceiveDataLength,
  dwLocalAddressLength,
  dwRemoteAddressLength: DWORD;
  var LocalSockaddr: PSockAddr;
  var LocalSockAddrLength: Integer;
  var RemoteSockaddr: PSockAddr;
  var RemoteSockaddrLength: Integer
  ); stdcall; external 'mswsock.dll' Name 'GetAcceptExSockaddrs';

type
  LPFN_ACCEPTEX = function(
    sListenSocket,
    sAcceptSocket: TSocket;
    lpOutputBuffer: Pointer;
    dwReceiveDataLength,
    dwLocalAddressLength,
    dwRemoteAddressLength: DWORD;
    var lpdwBytesReceived: DWORD;
    lpOverlapped: LPWSAOVERLAPPED): BOOL; stdcall;

  LPFN_GETACCEPTEXSOCKADDRS = procedure(
    lpOutputBuffer: Pointer;
    dwReceiveDataLength,
    dwLocalAddressLength,
    dwRemoteAddressLength: DWORD;
    var LocalSockaddr: PSockAddr;
    var LocalSockAddrLength: Integer;
    var RemoteSockaddr: PSockAddr;
    var RemoteSockaddrLength: Integer
    ); stdcall;

  LPFN_TRANSMITFILE = function(
    hSocket: TSocket;
    hFile: THANDLE;
    nNumberOfBytesToWrite,
    nNumberOfBytesPerSend: DWORD;
    lpOverlapped: LPWSAOVERLAPPED;
    lpTransmitBuffers: LPTRANSMIT_FILE_BUFFERS;
    dwReserved: DWORD
    ): BOOL; stdcall;

const
  WSAID_TRANSMITFILE: TGUID = '{B5367DF0-CBAC-11CF-95CA-00805F48A192}';
  WSAID_ACCEPTEX: TGUID = '{B5367DF1-CBAC-11CF-95CA-00805F48A192}';
  WSAID_GETACCEPTEXSOCKADDRS: TGUID = '{B5367DF2-CBAC-11CF-95CA-00805F48A192}';

const
  SO_CONNDATA = $7000;
  SO_CONNOPT = $7001;
  SO_DISCDATA = $7002;
  SO_DISCOPT = $7003;
  SO_CONNDATALEN = $7004;
  SO_CONNOPTLEN = $7005;
  SO_DISCDATALEN = $7006;
  SO_DISCOPTLEN = $7007;
  SO_OPENTYPE = $7008;
  SO_SYNCHRONOUS_ALERT = $10;
  SO_SYNCHRONOUS_NONALERT = $20;
  SO_MAXDG = $7009;
  SO_MAXPATHDG = $700A;
  SO_UPDATE_ACCEPT_CONTEXT = $700B;
  SO_CONNECT_TIME = $700C;
  SO_UPDATE_CONNECT_CONTEXT = $7010;
  TCP_BSDURGENT = $7000;

function InitUDPSocket(Port: Integer = 0): TSocket;
function InitTCPClient(Port: Integer = 0): TSocket;
function InitTCPServer(Port: Integer; IsReBind: BOOL = False; IsWin2kup: Boolean = True): TSocket;
procedure FreeSocket(var Socket: TSocket);

function SetRecvBufSize(Socket: TSocket; const BufSize: Integer): Boolean;
function SetSendBufSize(Socket: TSocket; const BufSize: Integer): Boolean;

function GetSendBufSize(Socket: TSocket): Integer;
function GetRecvBufSize(Socket: TSocket): Integer;

function SetSendTimeOut(Socket: TSocket; timeout: Integer): Boolean;
function SetRecvTimeOut(Socket: TSocket; timeout: Integer): Boolean;

function CheckSum(Buffer: PWord; size: Integer): Word;
function SetNoDelay(const Socket: TSocket): Boolean;
function SetBroadCast(const Socket: TSocket; IsBroadcast: Boolean): Boolean;
function SetNoNagle(Socket: TSocket; IsDisable: BOOL = True): Boolean;
function SetKeepALive(Socket: TSocket; timeout, TimePos: DWORD): Boolean;
function GetIPFromName(const HostName: string): string;
function SafeSend(Socket: TSocket; var Buffer; BufferSize: Integer): Boolean;
procedure SafeSleep(TimeSleep: DWORD);

implementation

const
  KEEP_LIVE_TIME = 1000 * 60 * 121;
  KEEP_LIVE_TIME_POS = 1000 * 60 * 121;

procedure SafeSleep(TimeSleep: DWORD);
var
  dwTime: DWORD;
  Msg: tMsg;
begin
  dwTime := GetTickCount();
  while GetTickCount() - TimeSleep < dwTime do
  begin
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then
      Continue
    else
      Exit;
  end;
end;

function SafeSend(Socket: TSocket; var Buffer; BufferSize: Integer): Boolean;
var
  pBuf: PChar;
  i, IsEnd, iRc: Integer;
begin
  Result := False;
  pBuf := @Buffer;
  IsEnd := BufferSize;
  for i := 0 to BUFFER_FULL_COUNT - 1 do
  begin
    iRc := send(Socket, pBuf^, IsEnd, 0);
    if iRc = IsEnd then
    begin
      Result := True;
      Break;
    end
    else if (iRc < IsEnd) and (iRc > 0) then
    begin
      Inc(pBuf, iRc);
      Dec(IsEnd, iRc);
      Continue;
    end
    else if WSAGetLastError() = WSAEWOULDBLOCK then
    begin
      Sleep(WRITE_BUF_LOCK_TIMEOUT);
      Continue;
    end
    else
      Break;
  end;
end;

function SetNoNagle(Socket: TSocket; IsDisable: BOOL = True): Boolean;
var
  iRc: Integer;
begin
  Result := False;
  iRc := SetSockOpt(
    Socket,
    IPPROTO_TCP,
    TCP_NODELAY,
    @IsDisable,
    SizeOf(BOOL));
  if iRc <> SOCKET_ERROR then
    Result := True;
end;

function GetIPFromName(const HostName: string): string;
var
  Host: PHostEnt;
  pHost: PChar;
begin
  Host := gethostbyname(PChar(HostName));
  if Host = nil then
  begin
    Result := '';
    Exit;
  end;
  pHost := Host^.h_addr^;
  Result := Format('%d.%d.%d.%d', [pHost[0], pHost[1], pHost[2], pHost[3]]);
end;

function SetBroadCast(const Socket: TSocket; IsBroadcast: Boolean): Boolean;
var
  bIsB: BOOL;
  iRc: Integer;
begin
  Result := False;
  bIsB := IsBroadcast;
  iRc := SetSockOpt(
    Socket,
    SOL_SOCKET,
    SO_BROADCAST,
    @bIsB,
    SizeOf(bIsB));
  if iRc <> SOCKET_ERROR then
    Result := True;
end;

function SetSendTimeOut(Socket: TSocket; timeout: Integer): Boolean;
begin
  Result := True;
  if SetSockOpt(
    Socket,
    SOL_SOCKET,
    SO_SNDTIMEO,
    @timeout,
    SizeOf(timeout)) = SOCKET_ERROR then
    Result := False;
end;

function SetRecvTimeOut(Socket: TSocket; timeout: Integer): Boolean;
begin
  Result := True;
  if SetSockOpt(
    Socket,
    SOL_SOCKET,
    SO_RCVTIMEO,
    @timeout,
    SizeOf(timeout)) = SOCKET_ERROR then
    Result := False;
end;

function SetSendBufSize(Socket: TSocket; const BufSize: Integer): Boolean;
var
  iRc: Integer;
begin
  Result := True;
  iRc := SetSockOpt(
    Socket,
    SOL_SOCKET,
    SO_SNDBUF,
    @BufSize,
    SizeOf(BufSize));
  if iRc = SOCKET_ERROR then
    Result := False;
end;

function GetSendBufSize(Socket: TSocket): Integer;
var
  iRc, size: Integer;
begin
  Result := -1;
  size := SizeOf(Integer);

  iRc := getsockopt(
    Socket,
    SOL_SOCKET,
    SO_SNDBUF,
    @Result,
    size);

  if iRc = SOCKET_ERROR then
  begin
    Result := -1;
    Exit;
  end;

end;

function GetRecvBufSize(Socket: TSocket): Integer;
var
  iRc, size: Integer;
begin
  Result := -1;
  size := SizeOf(Integer);
  iRc := getsockopt(
    Socket,
    SOL_SOCKET,
    SO_RCVBUF,
    @Result,
    size);
  if iRc = SOCKET_ERROR then
  begin
    Result := -1;
    Exit;
  end;
end;

function SetRecvBufSize(Socket: TSocket; const BufSize: Integer): Boolean;
var
  iRc: Integer;
begin
  Result := False;
  iRc := SetSockOpt(
    Socket,
    SOL_SOCKET,
    SO_RCVBUF,
    @BufSize,
    SizeOf(BufSize));
  if iRc = SOCKET_ERROR then
    Exit;
  Result := True;
end;

procedure FreeSocket(var Socket: TSocket);
var
  ASocket: TSocket;
begin
  if Socket <> INVALID_SOCKET then
  begin
    //shutdown(Socket, SD_BOTH);
    ASocket := InterlockedExchange(Integer(Socket), Integer(INVALID_SOCKET));
    SetNoDelay(ASocket);
    CloseSocket(ASocket);
  end;
end;

function InitUDPSocket(Port: Integer): TSocket;
var
  AddrIn: TSockAddrIn;
  bReLinten: BOOL;
begin

  Result := WSASocket(AF_INET,
    SOCK_DGRAM,
    0,
    nil,
    0,
    WSA_FLAG_OVERLAPPED);

  if Result = INVALID_SOCKET then
    Exit;

  //设置在TIME_WAIT状态下可以再次在相同的端口上监听
  if Port = 0 then
    Exit;

  bReLinten := True;
  if SetSockOpt(
    Result,
    SOL_SOCKET,
    SO_REUSEADDR,
    @bReLinten,
    SizeOf(bReLinten)) <> 0 then
    Exit;

  AddrIn.sin_family := AF_INET;
  AddrIn.sin_port := htons(Port);
  AddrIn.sin_addr.S_addr := INADDR_ANY;

  if bind(Result, @AddrIn, SizeOf(AddrIn)) = SOCKET_ERROR then
  begin
    FreeSocket(Result);
    Exit;
  end;

end;

function InitTCPClient(Port: Integer = 0): TSocket;
var
  SI: TSockAddrIn;
begin
  Result := WSASocket(
    AF_INET,
    SOCK_STREAM,
    0,
    nil,
    0,
    WSA_FLAG_OVERLAPPED
    );
  if Result = INVALID_SOCKET then
    Exit;

  if Port <> 0 then
  begin
    SI.sin_family := AF_INET;
    SI.sin_port := htons(Port);
    SI.sin_addr.S_addr := INADDR_ANY;
    if bind(Result, @SI, SizeOf(SI)) = SOCKET_ERROR then
      FreeSocket(Result);
  end;
end;

function InitTCPServer(Port: Integer; IsReBind: BOOL = False; IsWin2kup: Boolean = True): TSocket;
var
  SI: TSockAddrIn;
begin
  Result := WSASocket(
    AF_INET,
    SOCK_STREAM,
    0,
    nil,
    0,
    WSA_FLAG_OVERLAPPED
    );

  if Result = INVALID_SOCKET then
    Exit;

  if IsReBind then {让套接字重复可以绑定}
  begin
    if SetSockOpt(
      Result,
      SOL_SOCKET,
      SO_REUSEADDR,
      @IsReBind,
      SizeOf(IsReBind))
      = SOCKET_ERROR then
    begin
      FreeSocket(Result);
      Exit;
    end;
  end
  else
  begin
    if IsWin2kup then
    begin
      IsReBind := True;
      if SetSockOpt(Result,
        SOL_SOCKET,
        SO_EXCLUSIVEADDRUSE,
        @IsReBind,
        SizeOf(IsReBind)) = SOCKET_ERROR then
      begin
        FreeSocket(Result);
        Exit;
      end;
    end;
  end;

  //if not SetKeepALive(Result,KEEP_LIVE_TIME,KEEP_LIVE_TIME) then
  //  MessageBox(0,'设置错误','提示',MB_ICONINFORMATION);

  SI.sin_family := AF_INET;
  SI.sin_port := htons(Port);
  SI.sin_addr.S_addr := INADDR_ANY;

  //绑定到某一端口
  if bind(Result, @SI, SizeOf(SI)) = SOCKET_ERROR then
  begin
    FreeSocket(Result);
    Exit;
  end;

  //开始监听
  if listen(Result, LISTEN_MAX_USER_COUNT) = SOCKET_ERROR then
    FreeSocket(Result);

end;

function SetNoDelay(const Socket: TSocket): Boolean;
var
  secNodelay: TLinger;
begin
  Result := True;

  secNodelay.l_linger := 0;
  secNodelay.l_onoff := 1;

  if SetSockOpt(Socket, //设置不进入半等待状态
    SOL_SOCKET,
    SO_LINGER,
    @secNodelay,
    SizeOf(TLinger)) = SOCKET_ERROR then
    Result := False;

end;

function SetKeepALive(Socket: TSocket; timeout, TimePos: DWORD): Boolean;
var
  secKeepLive: TCP_KEEPALIVE;
  //iLength                   : Integer;
begin
  with secKeepLive do
  begin
    OnOff := RCVALL_ON;
  end;
  Result := True;

  //iLength:=SizeOf(secKeepLive);
  //if getsockopt(Socket, SOL_SOCKET,SO_KEEPALIVE, @secKeepLive, iLength) = SOCKET_ERROR then
  //   Result := False;

  if SetSockOpt(
    Socket,
    SOL_SOCKET,
    Integer(SIO_KEEPALIVE_VALS),
    @secKeepLive,
    SizeOf(secKeepLive)) = SOCKET_ERROR then
    Result := False;

end;

function CheckSum(Buffer: PWord; size: Integer): Word;
var
  Cksum: LongWord;
  Buf: PWord;
begin
  Cksum := 0;
  Buf := Buffer;

  while size > 1 do
  begin
    Cksum := Cksum + Buf^;
    Inc(Buf);
    Dec(size, SizeOf(Word));
  end;

  if size = 1 then
    Inc(Cksum, PByte(Buf)^);

  Cksum := (Cksum shr 16) + (Cksum and $FFFF);
  Cksum := (Cksum shr 16) + Cksum;
  Result := Word(not Cksum);

end;

procedure InitWsocket;
var
  aWSAData: TWSAData;
begin
  if WSAStartup($202, aWSAData) <> 0 then
  begin
    MessageBox(0,
      '本程序需要WINSOCK2，该机上版本太低，请升级WINSOCK到WINSOCK2',
      '错误',
      MB_ICONERROR);
  end;
end;

procedure FreeWsocket;
begin
  if WSACleanup <> 0 then
  begin
    {MessageBox(0,
      'WSACleanup 清除WS2_32.DLL失败！',
      '错误',
      MB_ICONERROR);}
  end;
end;

initialization
  InitWsocket;

finalization
  FreeWsocket;

end.
