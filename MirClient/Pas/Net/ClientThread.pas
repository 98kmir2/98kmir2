unit ClientThread;

interface

uses
  Windows, SysUtils, WinSock2, ThreadPool, sharevar;

const
  READ_PACKET_LEN           = 32 * 1024;
  //ÿ��Ͷ�ݵĶ������С����32K����Ϊ�����Ч�ʣ���ϵͳ���ڴ�ҳ���С���ı�
  //���ں�GS���ӵ��������ܴ�������Ҫ���ܴ��д������
  //ͬʱ����RUNGATE�Ĵ����ٶȱ�GS�ٶȿ죬���ʱ�������
  //Ϊ32K�ͻ������㹻��

  READ_BUFFER_LEN           = 64 * 1024;
  SEND_BUFFER_LEN           = 512 * 1024;

  TEMP_BUFFER_LEN           = 64 * 1024; ///��ʱ���ܽ��ܻ�������С ���м��ܺͽ��ܵĻ����С
  SND_SOCKET_BUFFER_LEN     = 64 * 1024; //�޸�SOCKET���ͺͽ��ջ�������С
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
    RecvPos: UINT;                      //RecvBufferӦ���ƶ�����λ��
    RecvLen: UINT;                      //�´ν��ջ������ĳ���
    RecvBuffer: PChar;                  //+64���ֽڷ�ֹ�������
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

//�ͷ���Դ��ͬʱɾ��������FWSAEvent�ϵ�FEvent
//�����Ҫ���ӣ������¼���FEvent

procedure TClientThread.CleanupClientSocket;
begin
  if FSocket <> INVALID_SOCKET then begin
    WSAEventSelect(FSocket, FWSAEvent, 0);
    SHSocket.FreeSocket(FSocket);
  end;
  if not FActive then begin             //���û�����ӵ��������������ӷ�����ʧ���¼�
    if Assigned(FOnConnectEvent) then
      FOnConnectEvent(self, False);
  end else
    InterlockedExchange(Integer(FActive), Integer(False));

  if Assigned(FOnCloseEvent) then try
    FOnCloseEvent(self);
  except
    MainOutMessage('�Ͽ����������ӳ����쳣', 6);
  end;
  if FDisconnectReConnect then begin    //�����Ҫ��������ʱ��
    Sleep(4000);
    SetEvent(FEvent);
  end;
end;

//����Ƿ��йر��¼�������

function TClientThread.CloseEvent(LPNetEvent: LPWSANetworkEvents): Boolean;
begin
  if (LPNetEvent^.lNetworkEvents and FD_CLOSE) > 0 then begin
    FIsClose := True;
    Result := False;
    FErrorCode := 0;
    //�����ر�
{$IFDEF _SHDEBUG}
    SendMessage(hDebug, LB_ADDSTRING, 0, Integer(Format('CloseEvent', [FErrorCode])));
{$ENDIF}
  end else
    Result := True;
end;

//����Ƿ���FD_CONNECT��Ϣ

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
        MainOutMessage(Format('�߳�%d����GS %s:%d �ɹ�...', [Pos, FServerIP, FServerPort]));
{$IFDEF SHDEBUG}
        SendMessage(hDebug, LB_ADDSTRING, 0, Integer(Format('�߳�[%d]���� %s:%d �ɹ�...', [Pos, FServerIP, FServerPort])));
{$ENDIF}
      end;
      //�����﷢�͵�½����
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
  //�ص������Զ�����
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
    //�����Ҫ�������ӣ��򴥷��ź�
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
  MainOutMessage(Format('%s:%d �Ͽ�����' {��Code:%d}, [FServerIP, FServerPort {, FErrorCode}]), 8);
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

    //Ϊ�����Ч�ʣ����ýϴ�ķ��ͺͽ��ջ��壬��СGameServer�Ĺ���ѹ��
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
          MainOutMessage(Format('RunGate������������ݷ����쳣:%s...', [E.Message]), 5);
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
    end else begin                      //��ʼ������
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
      if dwRc <> WSA_WAIT_EVENT_0 then  //�����ǳ�ʱ����
        break;
      if not GetEvents(@NetEvents) then
        break;
      if not FActive then               //���û�����ӷ������ɹ��ż���Ƿ��������¼�
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

//��ȫ�ķ��ͺ���
//buffer�Ƿ��ͻ����ͷ��ַ BufLen�Ƿ��ͻ���ĳ���
//��Ҫ���˼·
// �����ǰ�ķ��ͻ�����û�����ݣ���ֱ�ӷ���buffer������ݣ�ֱ������ʧ�ܣ�ͬʱ
//�Ѹ�ʣ�µ����ݿ��������ͻ����еȴ��´η��ͻ�����FD_WRITE��Ϣʱ���͡�

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
    if InBufLen = 0 then begin          //�����ж��ϴε������Ƿ������
      if uSend = 0 then begin           //�Ը���һ��FD_WRITE��Ϣ
        Result := True;
        Exit;
      end;
    end else begin                      //����ϴε�����û�з���,���ε����ݺ��ϴε����ݺϲ�����
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

    //��ʼ��������
    while uSend > 0 do begin
      iRc := send(FSocket, pSendBuffer^, uSend, 0);
      if iRc > 0 then begin
        Dec(uSend, iRc);
        Inc(pSendBuffer, iRc);
      end else begin
        if WSAGetLastError() = WSAEWOULDBLOCK then begin
          //��ֹû���κ����ݷ��ͳ�ȥ�Ŀ���������
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
      MainOutMessage(Format('������ %s:%d ʧȥ��Ӧ���Ͽ�������...', [FServerIP, FServerPort]));
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
        Errlog(Format('�� %s:%d д���ݳ����˳�', [FServerIP, FServerPort]));
{$ENDIF}
    end else begin                      //��ʼ����д����
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
  //==0��-1����ȫ����������
  with FRecvObj do begin
    if IOLen >= FRecvObj.RecvPos then begin
      RecvLen := READ_PACKET_LEN;
      RecvBuffer := @Buffer;
      RecvPos := 0;
    end else begin
      //���û���κ����ݱ�����
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
        //�в������ݱ�������Ҫ��ʣ�µ����ݿ��������ջ����ͷ��
        iRecvLen := READ_BUFFER_LEN - RecvPos;
        if iRecvLen > READ_PACKET_LEN then
          iRecvLen := READ_PACKET_LEN
        else begin
          //����������ܻ������Ĵ�С���򶪵�ǰ��İ�
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

