unit ClientThread;

interface

uses
  Windows, SysUtils, WinSock2, ThreadPool, sharevar;

const
  READ_PACKET_LEN           = 32 * 1024;
  //每次投递的读缓冲大小都是32K这是为了提高效率，是系统的内存页面大小的四倍
  //由于和GS连接的数据量很大，所以需要开很大的写缓冲区
  //同时由于RUNGATE的处理速度比GS速度快，这个时候读缓冲
  //为32K就基本上足够了

  READ_BUFFER_LEN           = 64 * 1024;
  SEND_BUFFER_LEN           = 512 * 1024;

  TEMP_BUFFER_LEN           = 64 * 1024; ///临时加密解密缓冲区大小 进行加密和解密的缓冲大小
  SND_SOCKET_BUFFER_LEN     = 64 * 1024; //修改SOCKET发送和接收缓冲区大小
  REV_SOCKET_BUFFER_LEN     = 64 * 1024;

type
  TClientThread = class;
  TOnReadEvent = procedure(ClientThread: TClientThread; const Buffer: PChar; const BufLen: UINT) of object;
  TOnClientEvent = procedure(Sender: TObject) of object;
  TOnConnectEvent = procedure(Sender: TObject; const Connected: Boolean) of object;

  {
  |-----------------------------------------------|
  |<-HPos->||||||||||||
  |<-----RecvPos----->|
  }

  PCRecvObj = ^_tagCRecvObj;
  _tagCRecvObj = record
    Socket: TSocket;
    RecvPos: UINT;                      //RecvBuffer应该移动到的位置
    RecvLen: UINT;                      //下次接收缓冲区的长度
    RecvBuffer: PChar;                  //+64个字节防止下面溢出
    Buffer: array[0..READ_BUFFER_LEN + 63] of Char;
  end;
  TCRecvObj = _tagCRecvObj;

  PCSendObj = ^_tagCSendObj;
  _tagCSendObj = record
    InBufLen: UINT;
    DestBuffer: PChar;                  //DestBuffer
    BaseBuffer: PChar;                  //BaseBuffer
    Buffer: array[0..SEND_BUFFER_LEN + 63] of Char;
  end;
  TCSendObj = _tagCSendObj;

  TClientThread = class(TBaseThread)
  private
    FActive: BOOL;
    FSocket: TSocket;
    FLock: TRTLCriticalSection;
    FSendObj: TCSendObj;
    FWSAEvent: WSAEvent;
    FRecvObj: TCRecvObj;
    FOnReadEvent: TOnReadEvent;
    AUBuf: array[0..TEMP_BUFFER_LEN + 63] of Char;
    BUBuf: array[0..TEMP_BUFFER_LEN + 63] of Char;
    FErrorCode: Integer;
    FID: Integer;
    FServerPort: Integer;
    FServerIP: string;
    FEvent: THANDLE;
    FOnCloseEvent: TOnClientEvent;
    FOnConnectEvent: TOnConnectEvent;
    FInWork: BOOL;
    FWaitTimeOut: DWORD;
    FDisconnectReConnect: BOOL;
    FIsClose: BOOL;
    function InitClientSocket: Boolean;
    procedure CleanupClientSocket;
    procedure SetClientID(const Value: Integer);
    procedure SetServerIP(const Value: string);
    procedure SetServerPort(const Value: Integer);
    procedure SetActive(const Value: BOOL);
    procedure SetDisconnectConnect(const Value: BOOL);
  protected
    function SafeSend(const Buffer: PChar; const BufLen: UINT): Boolean;
    function GetEvents(LPNetEvent: LPWSANetworkEvents): Boolean;
    function ReadEvent(LPNetEvent: LPWSANetworkEvents): Boolean;
    function ReadData(): Boolean;
    function WriteEvent(LPNetEvent: LPWSANetworkEvents): Boolean;
    function ConnectEvent(LPNetEvent: LPWSANetworkEvents): Boolean;
    function CloseEvent(LPNetEvent: LPWSANetworkEvents): Boolean;
    procedure HandleError();
    procedure Run(); override;
    procedure DoActive(const Active: BOOL);
  public
    Pos: Integer;
    FAUBuf, FBUBuf: PChar;
    FConnectState: TCSState;
    FSendBeginTick: LongWord;
    FCheckTimeOutTime: LongWord;
    FCheckRecviceTick: LongWord;
    FCheckServerTimeMin: LongWord;
    FCheckServerTimeMax: LongWord;
    property OnReadEvent: TOnReadEvent read FOnReadEvent write FOnReadEvent;
    property OnConnectEvent: TOnConnectEvent read FOnConnectEvent write FOnConnectEvent;
    property OnCloseEvent: TOnClientEvent read FOnCloseEvent write FOnCloseEvent;
    property Active: BOOL read FActive write SetActive;
    property ServerIP: string read FServerIP write SetServerIP;
    property ServerPort: Integer read FServerPort write SetServerPort;
    property ID: Integer read FID write SetClientID;
    procedure ReaderDone(const IOLen: UINT);
    property DisconnectReConnect: BOOL read FDisconnectReConnect write SetDisconnectConnect;
    procedure SendBuffer(const Buffer: PChar; const BufLen: UINT);
    procedure SendText(const Text: string; const Len: UINT);
    procedure LockBuffer;
    procedure UnLockBuffer;
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses
  SHSocket, IOCPTypeDef, Messages, main;

{ TClientThread }

//释放资源，同时删除关联到FWSAEvent上的FEvent
//如果需要连接，则重新激活FEvent

procedure TClientThread.CleanupClientSocket;
begin
  if FSocket <> INVALID_SOCKET then begin
    WSAEventSelect(FSocket, FWSAEvent, 0);
    SHSocket.FreeSocket(FSocket);
  end;
  if not FActive then begin             //如果没有连接到服务器则发生连接服务器失败事件
    if Assigned(FOnConnectEvent) then
      FOnConnectEvent(self, False);
  end else
    InterlockedExchange(Integer(FActive), Integer(False));

  if Assigned(FOnCloseEvent) then try
    FOnCloseEvent(self);
  except
    MainOutMessage('断开服务器连接出现异常', 6);
  end;
  if FDisconnectReConnect then begin    //如果需要断线重连时间
    Sleep(4000);
    SetEvent(FEvent);
  end;
end;

//检查是否有关闭事件发生。

function TClientThread.CloseEvent(LPNetEvent: LPWSANetworkEvents): Boolean;
begin
  if (LPNetEvent^.lNetworkEvents and FD_CLOSE) > 0 then begin
    FIsClose := True;
    Result := False;
    FErrorCode := 0;
    //正常关闭
{$IFDEF _SHDEBUG}
    SendMessage(hDebug, LB_ADDSTRING, 0, Integer(Format('CloseEvent', [FErrorCode])));
{$ENDIF}
  end else
    Result := True;
end;

//检查是否有FD_CONNECT消息

function TClientThread.ConnectEvent(LPNetEvent: LPWSANetworkEvents): Boolean;
begin
  if (LPNetEvent.lNetworkEvents and FD_CONNECT) > 0 then begin
    if LPNetEvent.iErrorCode[FD_CONNECT_BIT] <> 0 then begin
      FErrorCode := LPNetEvent.iErrorCode[FD_CONNECT_BIT];
      Result := False;
{$IFDEF _SHDEBUG}
      SendMessage(hDebug, LB_ADDSTRING, 0, Integer(Format('Connect Event %d', [FErrorCode])));
{$ENDIF}
    end else begin
      if Assigned(FOnConnectEvent) then
        FOnConnectEvent(self, True);
      Result := WSAEventSelect(FSocket, FWSAEvent, FD_READ or FD_WRITE or FD_CLOSE) <> SOCKET_ERROR;
      if Result then begin
        FRecvObj.Socket := FSocket;
        FRecvObj.RecvBuffer := @FRecvObj.Buffer;
        FRecvObj.RecvPos := 0;
        FRecvObj.RecvLen := READ_PACKET_LEN;
        FIsClose := False;
        FSendObj.InBufLen := 0;
        FSendObj.DestBuffer := FSendObj.BaseBuffer;
        FSendBeginTick := GetTickCount();
        FCheckRecviceTick := GetTickCount();
        InterlockedExchange(Integer(FActive), Integer(True));
        MainOutMessage(Format('线程%d连接GS %s:%d 成功...', [Pos, FServerIP, FServerPort]));
{$IFDEF SHDEBUG}
        SendMessage(hDebug, LB_ADDSTRING, 0, Integer(Format('线程[%d]连接 %s:%d 成功...', [Pos, FServerIP, FServerPort])));
{$ENDIF}
      end;
      //在这里发送登陆数据
    end;
  end else
    Result := True;

end;

constructor TClientThread.Create;
begin
  FConnectState := stConnecting;
  FSendBeginTick := GetTickCount();
  FCheckTimeOutTime := g_dwCheckServerTimeOutTime;
  FWaitTimeOut := $FFFFFFFF;
  FEvent := CreateEvent(nil, False, False, nil);
  FWSAEvent := WSACreateEvent();
  FDisconnectReConnect := True;
  InitializeCriticalSection(FLock);
  FThreadType := 'Connection GS';
  FSendObj.BaseBuffer := @FSendObj.Buffer;
  FAUBuf := @AUBuf[0];
  FBUBuf := @BUBuf[0];
  inherited Create(True);
end;

destructor TClientThread.Destroy;
begin
  //关掉断线自动重连
  InterlockedExchange(Integer(FDisconnectReConnect), Integer(False));
  if FActive then
    DoActive(False);
  Terminate;
  SetEvent(FEvent);
  inherited Destroy;                    //WaitFor Thread Exit
  CloseHandle(FEvent);
  WSACloseEvent(FWSAEvent);
  DeleteCriticalSection(FLock);
end;

procedure TClientThread.DoActive(const Active: BOOL);
begin
  if Active then begin
    //如果需要重新连接，则触发信号
    SetEvent(FEvent);
  end else if FInWork then begin
    InterlockedExchange(Integer(FInWork), Integer(False));
    WSASetEvent(FWSAEvent);
  end;
end;

function TClientThread.GetEvents(LPNetEvent: LPWSANetworkEvents): Boolean;
var
  iRc                       : Integer;
begin
  iRc := WSAEnumNetworkEvents(
    FSocket,
    FWSAEvent,
    LPNetEvent);
  Result := iRc <> SOCKET_ERROR;
{$IFDEF _SHDEBUG}
  if Result = False then
    SendMessage(hDebug, LB_ADDSTRING, 0, Integer(Format('Get Event %d', [WSAGetLastError()])));
{$ENDIF}
end;

procedure TClientThread.HandleError;
begin
  if FErrorCode = 0 then
    FErrorCode := WSAGetLastError();
  MainOutMessage(Format('%s:%d 断开连接' {，Code:%d}, [FServerIP, FServerPort {, FErrorCode}]), 8);
end;

function TClientThread.InitClientSocket: Boolean;
var
  iRc                       : Integer;
  SI                        : TSockAddrIn;
begin
  FErrorCode := 0;
  FIsClose := False;

  FSocket := SHSocket.InitTCPClient();
  Result := FSocket <> INVALID_SOCKET;

  if Result then begin
    iRc := WSAEventSelect(FSocket, FWSAEvent, FD_CONNECT);
    if iRc = SOCKET_ERROR then
      Result := False;
  end;

  if Result then begin
    SI.sin_family := AF_INET;
    SI.sin_port := htons(FServerPort);
    SI.sin_addr.S_addr := inet_addr(PChar(FServerIP));

    //为了提高效率，设置较大的发送和接收缓冲，减小GameServer的工作压力
    SetSendBufSize(FSocket, SND_SOCKET_BUFFER_LEN);
    SetRecvBufSize(FSocket, REV_SOCKET_BUFFER_LEN);

    iRc := connect(FSocket, @SI, SizeOf(SI));

    if iRc = SOCKET_ERROR then begin
      FErrorCode := WSAGetLastError();
      if FErrorCode <> WSAEWOULDBLOCK then
        Result := False;
    end;
  end;
end;

function TClientThread.ReadData(): Boolean;
var
  iRc                       : Integer;
begin
  //if Assigned(FOnReadEvent) then
  with FRecvObj do begin
    iRc := recv(Socket, RecvBuffer^, RecvLen, 0);
    if iRc > 0 then begin
      Result := True;
      {
      |-----------------------------------------------|
      |<-HPos->||||||||||||
      |<-----RecvPos----->|
      }
      Inc(RecvPos, iRc);
      try
        FOnReadEvent(self, Buffer, RecvPos);
      except
        on E: Exception do begin
          ReaderDone(iRc);
          MainOutMessage(Format('RunGate处理服务器数据发生异常:%s...', [E.Message]), 5);
        end;
      end;
    end else
      Result := False;
  end;
end;

function TClientThread.ReadEvent(LPNetEvent: LPWSANetworkEvents): Boolean;
begin
  if (LPNetEvent.lNetworkEvents and FD_READ) > 0 then begin
    if LPNetEvent.iErrorCode[FD_READ_BIT] = 0 then begin
      Result := ReadData;
      if not Result then begin
        if WSAGetLastError() = WSAEWOULDBLOCK then
          Result := True;
      end;
    end else begin                      //开始读数据
      FErrorCode := LPNetEvent^.iErrorCode[FD_READ_BIT];
      if (FErrorCode <> WSAEWOULDBLOCK) then
        Result := False
      else
        Result := True;
{$IFDEF _SHDEBUG}
      SendMessage(hDebug, LB_ADDSTRING, 0, Integer(Format('Read Event %d', [FErrorCode])));
{$ENDIF}
    end;
  end else
    Result := True;
end;

procedure TClientThread.Run();
var
  dwRc                      : DWORD;
  NetEvents                 : TWSANETWORKEVENTS;
begin
  while True do begin
    dwRc := WaitForSingleObject(FEvent, INFINITE);
    if Terminated then
      break;
    if dwRc <> WAIT_OBJECT_0 then
      break;
    {if FConnectState <> stTimeOut then
      if GetTickCount - FSendBeginTick > FCheckTimeOutTime then begin
        FConnectState := stTimeOut;
        DisconnectReConnect := False;
      end;}
    if not InitClientSocket then begin
      CleanupClientSocket;
      Continue;
    end;
    InterlockedExchange(Integer(FInWork), Integer(True));
    FIsClose := False;

    while True do begin
      dwRc := WSAWaitForMultipleEvents(1, @FWSAEvent, False, INFINITE, False);
      if not FInWork then
        break;
      if dwRc <> WSA_WAIT_EVENT_0 then  //不考虑超时问题
        break;
      if not GetEvents(@NetEvents) then
        break;
      if not FActive then               //如果没有连接服务器成功才检查是否有连接事件
        if not ConnectEvent(@NetEvents) then
          break;
      if not ReadEvent(@NetEvents) then
        break;
      if not WriteEvent(@NetEvents) then
        break;
      if not CloseEvent(@NetEvents) then
        break;
    end;
    if not FIsClose then
      HandleError;
    InterlockedExchange(Integer(FInWork), Integer(False));
    CleanupClientSocket;
  end;
end;

//安全的发送函数
//buffer是发送缓冲的头地址 BufLen是发送缓冲的长度
//主要设计思路
// 如果以前的发送缓冲里没有数据，则直接发送buffer里的数据，直到发送失败，同时
//把该剩下的数据拷贝到发送缓冲中等待下次发送或者有FD_WRITE消息时发送。

function TClientThread.SafeSend(const Buffer: PChar; const BufLen: UINT): Boolean;
var
  iRc                       : Integer;
  uSend                     : UINT;
  pSendBuffer               : PChar;
begin
  Result := False;
  EnterCriticalSection(FLock);
  pSendBuffer := Buffer;
  uSend := BufLen;
  with FSendObj do try
    if InBufLen = 0 then begin          //首先判断上次的数据是否发送完毕
      if uSend = 0 then begin           //对付第一个FD_WRITE消息
        Result := True;
        Exit;
      end;
    end else begin                      //如果上次的数据没有发完,本次的数据和上次的数据合并发送
      Inc(uSend, InBufLen);
      if (uSend < SEND_BUFFER_LEN) then begin
        if (BufLen > 0) then
          Move(pSendBuffer^, DestBuffer^, BufLen);
      end else begin
        DestBuffer := BaseBuffer;
        InBufLen := 0;
        Exit;
      end;
      pSendBuffer := BaseBuffer;
    end;

    //开始发送数据
    while uSend > 0 do begin
      iRc := send(FSocket, pSendBuffer^, uSend, 0);
      if iRc > 0 then begin
        Dec(uSend, iRc);
        Inc(pSendBuffer, iRc);
      end else begin
        if WSAGetLastError() = WSAEWOULDBLOCK then begin
          //防止没有任何数据发送出去的拷贝到缓冲
          if pSendBuffer <> BaseBuffer then
            Move(pSendBuffer^, BaseBuffer^, uSend);
          DestBuffer := PChar(UINT(BaseBuffer) + uSend);
          break;
        end else
          Exit;
      end;
    end;
    InBufLen := uSend;
    Result := True;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

procedure TClientThread.SendBuffer(const Buffer: PChar; const BufLen: UINT);
begin
  if FActive then begin
    if not SafeSend(Buffer, BufLen) then begin
      SHSocket.FreeSocket(FSocket);
      DoActive(False);
{$IFDEF SHDEBUG}
      MainOutMessage(Format('服务器 %s:%d 失去响应，断开其连接...', [FServerIP, FServerPort]));
{$ENDIF}
    end;
  end;
end;

procedure TClientThread.SetActive(const Value: BOOL);
begin
  if FActive <> Value then begin
    DoActive(Value);
  end;
end;

procedure TClientThread.SetClientID(const Value: Integer);
begin
  FID := Value;
end;

procedure TClientThread.SetServerIP(const Value: string);
begin
  if FServerIP <> Value then
    FServerIP := Value;
end;

procedure TClientThread.SetServerPort(const Value: Integer);
begin
  if FServerPort <> Value then
    FServerPort := Value;
end;

function TClientThread.WriteEvent(LPNetEvent: LPWSANetworkEvents): Boolean;
begin
  if (LPNetEvent.lNetworkEvents and FD_WRITE) > 0 then begin
    if LPNetEvent.iErrorCode[FD_WRITE_BIT] = 0 then begin
      Result := SafeSend(nil, 0);

{$IFDEF SHDEBUG}
      if not Result then
        Errlog(Format('向 %s:%d 写数据出错，退出', [FServerIP, FServerPort]));
{$ENDIF}
    end else begin                      //开始继续写数据
      FErrorCode := LPNetEvent^.iErrorCode[FD_WRITE_BIT];

      if (FErrorCode <> WSAEWOULDBLOCK) then
        Result := False
      else
        Result := True;

{$IFDEF _SHDEBUG}
      SendMessage(hDebug, LB_ADDSTRING, 0, Integer(Format('Write Event %d', [FErrorCode])));
{$ENDIF}
    end;
  end
  else
    Result := True;

end;

procedure TClientThread.SetDisconnectConnect(const Value: BOOL);
begin
  if FDisconnectReConnect <> Value then
    InterlockedExchange(Integer(FDisconnectReConnect), Integer(Value));
end;

procedure TClientThread.SendText(const Text: string; const Len: UINT);
begin
  SendBuffer(@Text[1], Len);
end;

procedure TClientThread.LockBuffer;
begin
  EnterCriticalSection(FLock);
end;

procedure TClientThread.UnLockBuffer;
begin
  LeaveCriticalSection(FLock);
end;

procedure TClientThread.ReaderDone(const IOLen: UINT);
var
  iRecvLen                  : UINT;
begin
  //==0和-1都是全部处理完了
  with FRecvObj do begin
    if IOLen >= FRecvObj.RecvPos then begin
      RecvLen := READ_PACKET_LEN;
      RecvBuffer := @Buffer;
      RecvPos := 0;
    end else begin
      //如果没有任何数据被处理
      if IOLen > 0 then begin
        Dec(RecvPos, IOLen);
        Move(Buffer[IOLen], Buffer, RecvPos);
        RecvBuffer := @Buffer[RecvPos];
        iRecvLen := READ_BUFFER_LEN - RecvPos;
        if iRecvLen > READ_PACKET_LEN then
          iRecvLen := READ_PACKET_LEN;
        RecvLen := iRecvLen;
      end else begin
        {
        |-----------------------------------------------|
        |<-HPos->||||||||||||
        |<-----RecvPos----->|
        |-----------------------------------------------|
        }
        //有部分数据被处理，需要把剩下的数据拷贝到接收缓冲的头部
        iRecvLen := READ_BUFFER_LEN - RecvPos;
        if iRecvLen > READ_PACKET_LEN then
          iRecvLen := READ_PACKET_LEN
        else begin
          //如果超过接受缓冲区的大小，则丢掉前面的包
          if iRecvLen = 0 then begin
            iRecvLen := READ_PACKET_LEN;
            RecvPos := 0;
          end;
        end;
        RecvLen := iRecvLen;
        RecvBuffer := @Buffer[RecvPos];
      end;
    end;
  end;
end;

end.

