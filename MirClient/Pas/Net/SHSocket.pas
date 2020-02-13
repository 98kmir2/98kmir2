unit SHSocket;

interface

uses
  Windows, Messages, SysUtils, WinSock2, IOCPTypeDef;

const
  BUFFER_FULL_COUNT         = 128;      //���������ظ��������ݰ��Ĵ����Ĵ���
  WRITE_BUF_LOCK_TIMEOUT    = 08;       //20;       //���ͻ�����������ʱ�䳬ʱ
  SLEEP_WAIT_FACTIVE        = 5000;
  RCVALL_OFF                = 0;
  RCVALL_ON                 = 1;
  RCVALL_SOCKETLEVELONLY    = 2;
  IOC_VENDOR                = $18000000;
  SIO_KEEPALIVE_VALS        = IOC_IN or IOC_VENDOR or 4;
  LISTEN_MAX_USER_COUNT     = 256;      //200;      //�ڼ����˿���ȴ�������Ŀ
  IPTOS_THROUGHPUT          = $0008;    //�������������֪��WINSOCK2֧��֧��???

type
  PTCP_KEEPALIVE = ^_tcp_keepalive;
  _tcp_keepalive = record
    onoff: DWORD;
    keepalivetime: DWORD;
    keepaliveinterval: DWORD;
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
  WSAID_TRANSMITFILE        : TGUID = '{B5367DF0-CBAC-11CF-95CA-00805F48A192}';
  WSAID_ACCEPTEX            : TGUID = '{B5367DF1-CBAC-11CF-95CA-00805F48A192}';
  WSAID_GETACCEPTEXSOCKADDRS: TGUID = '{B5367DF2-CBAC-11CF-95CA-00805F48A192}';

const
  SO_CONNDATA               = $7000;
  SO_CONNOPT                = $7001;
  SO_DISCDATA               = $7002;
  SO_DISCOPT                = $7003;
  SO_CONNDATALEN            = $7004;
  SO_CONNOPTLEN             = $7005;
  SO_DISCDATALEN            = $7006;
  SO_DISCOPTLEN             = $7007;
  SO_OPENTYPE               = $7008;
  SO_SYNCHRONOUS_ALERT      = $10;
  SO_SYNCHRONOUS_NONALERT   = $20;
  SO_MAXDG                  = $7009;
  SO_MAXPATHDG              = $700A;
  SO_UPDATE_ACCEPT_CONTEXT  = $700B;
  SO_CONNECT_TIME           = $700C;
  SO_UPDATE_CONNECT_CONTEXT = $7010;
  TCP_BSDURGENT             = $7000;

  //��ʼ��UDP�׽���
function InitUDPSocket(Port: Integer = 0): TSocket;
//��ʼ��TCPClient
function InitTCPClient(Port: Integer = 0): TSocket;
//��ʼ��TCPServer
//��һ�������Ƿ�����ظ��󶨵�ĳһ�˿�
function InitTCPServer(Port: Integer; IsReBind: BOOL = False; IsWin2kup: Boolean
  = True): TSocket;
//�ͷ��׽�����Դ
procedure FreeSocket(var Socket: TSocket);
//���÷��ͺͽ��ܻ�������С
function SetRecvBufSize(Socket: TSocket; const BufSize: Integer): Boolean;
function SetSendBufSize(Socket: TSocket; const BufSize: Integer): Boolean;
//�õ����ͺͽ��ܻ�������С
function GetSendBufSize(Socket: TSocket): Integer;
function GetRecvBufSize(Socket: TSocket): Integer;
//����������ʽ�µķ��ͺͽ��ܳ�ʱ
function SetSendTimeOut(Socket: TSocket; timeout: Integer): Boolean;
function SetRecvTimeOut(Socket: TSocket; timeout: Integer): Boolean;
//У���㷨
function checksum(Buffer: PWord; size: Integer): Word; //У��ͺ���
//���ò��ȴ����̹ر��׽���
function SetNoDelay(const Socket: TSocket): Boolean;
//���ù㲥��������
function SetBroadCast(const Socket: TSocket; IsBroadcast: Boolean): Boolean;
//���ò���Ҫ/��ҪNagle�㷨
function SetNoNagle(Socket: TSocket; IsDisable: BOOL = True): Boolean;
//���ñ������Ӳ���
function SetKeepALive(Socket: TSocket; timeout, TimePos: DWORD): Boolean;
//�ӻ������ֵõ�IP
function GetIPFromName(const HostName: string): string;
//��ȫ��Ϣ����
procedure SafeSleep(TimeSleep: DWORD);
//��ȫ�ķ��ͺ���
function SafeSend(Socket: TSocket; var Buffer; BufferSize: Integer): Boolean;

implementation

const
  KEEP_LIVE_TIME            = 1000 * 60 * 121;
  KEEP_LIVE_TIME_POS        = 1000 * 60 * 121;

procedure SafeSleep(TimeSleep: DWORD);
var
  dwTime                    : DWORD;
  Msg                       : tMsg;
begin
  dwTime := GetTickCount();
  while GetTickCount() - TimeSleep < dwTime do begin
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then
      Continue
    else
      Exit;
  end;
end;

///////////////////////

function SafeSend(Socket: TSocket; var Buffer; BufferSize: Integer): Boolean;
var
  pBuf                      : PChar;
  i,
    IsEnd,
    iRc                     : Integer;
begin
  Result := False;
  pBuf := @Buffer;
  IsEnd := BufferSize;
  for i := 0 to BUFFER_FULL_COUNT - 1 do begin
    iRc := send(Socket, pBuf^, IsEnd, 0);
    if iRc = IsEnd then begin           //���������ķ��������е����ݰ�
      Result := True;
      Break;
    end else begin
      //û�з��������е�����
      if (iRc < IsEnd) and (iRc > 0) then begin
        Inc(pBuf, iRc);
        Dec(IsEnd, iRc);
        Continue;
      end else begin
        //������ͳ���
        //���������ˣ���Ϣһ�����·���
        if WSAGetLastError() = WSAEWOULDBLOCK then begin
          Sleep(WRITE_BUF_LOCK_TIMEOUT);
          Continue;
        end else
          Break;
        //��������
      end;
    end;
  end;
end;

///////////////////////

function SetNoNagle(Socket: TSocket; IsDisable: BOOL = True): Boolean;
var
  iRc                       : Integer;
begin
  Result := False;
  iRc := setsockopt(
    Socket,
    IPPROTO_TCP,
    TCP_NODELAY,
    @IsDisable,
    SizeOf(BOOL));
  if iRc <> SOCKET_ERROR then
    Result := True;
end;

///////////////////////

function GetIPFromName(const HostName: string): string;
var
  Host                      : PHostEnt;
  pHost                     : PChar;
begin
  Host := gethostbyname(PChar(HostName));
  if Host = nil then begin
    Result := '';
    Exit;
  end;
  pHost := Host^.h_addr^;
  Result := Format('%d.%d.%d.%d', [pHost[0], pHost[1], pHost[2], pHost[3]]);
end;

///////////////////////

function SetBroadCast(const Socket: TSocket; IsBroadcast: Boolean): Boolean;
var
  bIsB                      : BOOL;
  iRc                       : Integer;
begin
  Result := False;
  bIsB := IsBroadcast;                  //�ص㣬����Ҫ����...
  iRc := setsockopt(
    Socket,
    SOL_SOCKET,
    SO_BROADCAST,
    @bIsB,
    SizeOf(bIsB));
  if iRc <> SOCKET_ERROR then
    Result := True;
end;

///////////////////////

function SetSendTimeOut(Socket: TSocket; timeout: Integer): Boolean;
begin
  Result := True;
  if setsockopt(
    Socket,
    SOL_SOCKET,
    SO_SNDTIMEO,
    @timeout,
    SizeOf(timeout)) = SOCKET_ERROR then
    Result := False;
end;

///////////////////////

function SetRecvTimeOut(Socket: TSocket; timeout: Integer): Boolean;
begin
  Result := True;
  if setsockopt(
    Socket,
    SOL_SOCKET,
    SO_RCVTIMEO,
    @timeout,
    SizeOf(timeout)) = SOCKET_ERROR then
    Result := False;
end;

///////////////////////

function SetSendBufSize(Socket: TSocket; const BufSize: Integer): Boolean;
var
  iRc                       : Integer;
begin
  Result := True;
  iRc := setsockopt(
    Socket,
    SOL_SOCKET,
    SO_SNDBUF,
    @BufSize,
    SizeOf(BufSize));
  if iRc = SOCKET_ERROR then
    Result := False;
end;

///////////////////////

function GetSendBufSize(Socket: TSocket): Integer;
var
  iRc, size                 : Integer;
begin
  Result := -1;
  size := SizeOf(Integer);

  iRc := getsockopt(
    Socket,
    SOL_SOCKET,
    SO_SNDBUF,
    @Result,
    size);

  if iRc = SOCKET_ERROR then begin
    Result := -1;
    Exit;
  end;

end;

///////////////////////

function GetRecvBufSize(Socket: TSocket): Integer;
var
  iRc, size                 : Integer;
begin
  Result := -1;
  size := SizeOf(Integer);
  iRc := getsockopt(
    Socket,
    SOL_SOCKET,
    SO_RCVBUF,
    @Result,
    size);
  if iRc = SOCKET_ERROR then begin
    Result := -1;
    Exit;
  end;
end;

///////////////////////

function SetRecvBufSize(Socket: TSocket; const BufSize: Integer): Boolean;
var
  iRc                       : Integer;
begin
  Result := False;
  iRc := setsockopt(
    Socket,
    SOL_SOCKET,
    SO_RCVBUF,
    @BufSize,
    SizeOf(BufSize));
  if iRc = SOCKET_ERROR then
    Exit;
  Result := True;
end;

///////////////////////

procedure FreeSocket(var Socket: TSocket);
var
  ASocket                   : TSocket;
begin
  if Socket <> INVALID_SOCKET then begin
    //shutdown(Socket, SD_BOTH);
    ASocket := InterlockedExchange(Integer(Socket), Integer(INVALID_SOCKET));
    SetNoDelay(ASocket);
    closesocket(ASocket);
  end;
end;

///////////////////////
//���Port=0����˵���� Client

function InitUDPSocket(Port: Integer): TSocket;
var
  AddrIn                    : TSockAddrIn;
  bReLinten                 : BOOL;
begin

  Result := WSASocket(AF_INET,
    SOCK_DGRAM,
    0,
    nil,
    0,
    WSA_FLAG_OVERLAPPED);

  if Result = INVALID_SOCKET then
    Exit;

  //������TIME_WAIT״̬�¿����ٴ�����ͬ�Ķ˿��ϼ���

  if Port = 0 then
    Exit;

  bReLinten := True;
  if setsockopt(
    Result,
    SOL_SOCKET,
    SO_REUSEADDR,
    @bReLinten,
    SizeOf(bReLinten)) <> 0 then
    Exit;

  AddrIn.sin_family := AF_INET;
  AddrIn.sin_port := htons(Port);
  AddrIn.sin_addr.S_addr := INADDR_ANY;

  if bind(Result, @AddrIn, SizeOf(AddrIn)) = SOCKET_ERROR then begin
    FreeSocket(Result);
    Exit;
  end;

end;

///////////////////////

function InitTCPClient(Port: Integer = 0): TSocket;
var
  SI                        : TSockAddrIn;
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

  if Port <> 0 then {//�����󶨵�ĳһ�˿�Ҳ�ǿ��Ե�} begin
    SI.sin_family := AF_INET;
    SI.sin_port := htons(Port);
    SI.sin_addr.S_addr := INADDR_ANY;

    if bind(Result, @SI, SizeOf(SI)) = SOCKET_ERROR then
      FreeSocket(Result);
  end;

end;

///////////////////////

function InitTCPServer(Port: Integer; IsReBind: BOOL = False; IsWin2kup: Boolean = True): TSocket;
var
  SI                        : TSockAddrIn;
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

  if IsReBind then {//���׽����ظ����԰�} begin
    if setsockopt(
      Result,
      SOL_SOCKET,
      SO_REUSEADDR,
      @IsReBind,
      SizeOf(IsReBind))
      = SOCKET_ERROR then begin
      FreeSocket(Result);
      Exit;
    end;
  end
  else begin

    if IsWin2kup then begin
      IsReBind := True;
      //�򿪷�ֹ��������
      if setsockopt(Result,
        SOL_SOCKET,
        SO_EXCLUSIVEADDRUSE,
        @IsReBind,
        SizeOf(IsReBind)) = SOCKET_ERROR then begin
        FreeSocket(Result);
        Exit;
      end;
    end;

  end;

  // if not SetKeepALive(Result,KEEP_LIVE_TIME,KEEP_LIVE_TIME) then
 //    MessageBox(0,'���ô���','��ʾ',MB_ICONINFORMATION);

  SI.sin_family := AF_INET;
  SI.sin_port := htons(Port);
  SI.sin_addr.S_addr := INADDR_ANY;

  //�󶨵�ĳһ�˿�
  if bind(Result, @SI, SizeOf(SI)) = SOCKET_ERROR then begin
    FreeSocket(Result);
    Exit;
  end;

  //��ʼ����
  if listen(Result, LISTEN_MAX_USER_COUNT) = SOCKET_ERROR then
    FreeSocket(Result);

end;

///////////////////////

function SetNoDelay(const Socket: TSocket): Boolean;
var
  secNodelay                : TLinger;
begin
  Result := True;

  secNodelay.l_linger := 0;
  secNodelay.l_onoff := 1;

  if setsockopt(Socket,                 //���ò������ȴ�״̬
    SOL_SOCKET,
    SO_LINGER,
    @secNodelay,
    SizeOf(TLinger)) = SOCKET_ERROR then
    Result := False;

end;

function SetKeepALive(Socket: TSocket; timeout, TimePos: DWORD): Boolean;
var
  secKeepLive               : TCP_KEEPALIVE;
  //  iLength:Integer;
begin
  with secKeepLive do begin
    onoff := RCVALL_ON;
  end;
  Result := True;
  // iLength:=SizeOf(secKeepLive);
 //
 //  if getsockopt(Socket, SOL_SOCKET,SO_KEEPALIVE, @secKeepLive, iLength) = SOCKET_ERROR then
 //    Result := False;

  if setsockopt(
    Socket,
    SOL_SOCKET,
    Integer(SIO_KEEPALIVE_VALS),
    @secKeepLive,
    SizeOf(secKeepLive)) = SOCKET_ERROR then
    Result := False;

end;

///////////////////////////

function checksum(Buffer: PWord; size: Integer): Word; //У��ͺ���
var
  Cksum                     : LongWord;
  Buf                       : PWord;
begin
  Cksum := 0;
  Buf := Buffer;

  while size > 1 do begin
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

///////////////////////

procedure InitWsocket;
var
  aWSAData                  : TWSAData;
begin
  if WSAStartup($202, aWSAData) <> 0 then begin
    MessageBox(0,                       //GetForegroundWindow(),
      '��������ҪWINSOCK2���û��ϰ汾̫�ͣ�������' +
      'WINSOCK��WINSOCK2',
      '����',
      MB_ICONERROR);
  end;
end;

procedure FreeWsocket;
begin
  if WSACleanup <> 0 then begin
    MessageBox(0,
      '���WS2_32.DLLʧ�ܣ�',
      '����',
      MB_ICONERROR);
  end;
end;

initialization
  InitWsocket;

finalization
  FreeWsocket;

end.

