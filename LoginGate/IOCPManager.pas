unit IOCPManager;

interface

uses
  Windows, SysUtils, Messages, AcceptExWorkedThread, MemPool, FixedMemoryPool,
  ClientThread, IOCPTypeDef, WinSock2, Protocol;

type
  TNotifyEvent = procedure(Sender: TObject) of object;
  EIOCPServer = class(Exception);

  TIOCPServer = class
  private
    FUserList: TUserManager;
    FRecvSocket: TIOCPReader;
    FSendSocket: TIOCPWriter;
    FAcceptExSocket: TIOCPAccepter;
    FWorkThread: array[0..MAX_WORK_THREAD - 1] of TAcceptExWorkedThread;
    FIsStarted: BOOL;
    FOnStartEvent: TNotifyEvent;
    FOnStopEvent: TNotifyEvent;
    FThreadCount: Integer;
    FGameServerCount: Integer;
    FWriteBytes: Integer;
    FReadBytes: Integer;
    procedure SetGameServerCount(const Value: Integer);
  protected
    procedure CompPortInit(Sender: TObject; CompPort: THANDLE);
    procedure CompPortcleanup(Sender: TObject; CompPort: THANDLE);
  public
    property IsStarted: BOOL read FIsStarted;
    property GameServerCount: Integer read FGameServerCount write SetGameServerCount;
    property ReadBytes: Integer read FReadBytes write FReadBytes;
    property WriteBytes: Integer read FWriteBytes write FWriteBytes;
    property OnStartEvent: TNotifyEvent read FOnStartEvent write FOnStartEvent;
    property OnStopEvent: TNotifyEvent read FOnStopEvent write FOnStopEvent;
    property Reader: TIOCPReader read FRecvSocket;
    property Writer: TIOCPWriter read FSendSocket;
    property AcceptExSocket: TIOCPAccepter read FAcceptExSocket;
    property UserManager: TUserManager read FUserList;
    procedure StartService;
    procedure StopService;
    constructor Create();
    destructor Destroy; override;
  end;

  TIOCPManager = class
  private
    FIOCPServer: TIOCPServer;
    FCount: DWORD;
    FServerInfoList: PServerInfo;
  public
    property IOCPPortCount: DWORD read FCount;
    property IOCPServer: TIOCPServer read FIOCPServer;
    function InitServer(const Port: Integer; const ClientThread: TClientThread): TIOCPServer;
    constructor Create();
    destructor Destroy; override;
  end;

  PGameInfo = ^_tagGameInfo;
  _tagGameInfo = record
    Port: Integer;
    ClientThread: TClientThread;
  end;
  TGameInfo = _tagGameInfo;

  TGameServerManager = class
  private
    FCount: Integer;
    FGameList: array[0..MAX_SERVER_COUNT - 1] of TGameInfo;
    function GetClientThread(Index: Integer): TClientThread;
  public
    property GameItem[Index: Integer]: TClientThread read GetClientThread; default;
    property GameServerCount: Integer read FCount;
    function InitGameServer(const Port: Integer; const IP: string): TClientThread;
    function FindGameServer(const Port: Integer): TClientThread;
    procedure CloseAllGameServer();
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses
  LogManager;

{ TIOCPServer }

procedure TIOCPServer.CompPortcleanup(Sender: TObject; CompPort: THANDLE);
begin
  Sleep(1);
end;

procedure TIOCPServer.CompPortInit(Sender: TObject; CompPort: THANDLE);
var
  SystemInfo: TSystemInfo;
  i: Integer;
begin
  FillChar(SystemInfo, SizeOf(TSystemInfo), #0);
  GetSystemInfo(SystemInfo);
  FThreadCount := SystemInfo.dwNumberOfProcessors * 2 + 2;
  if FThreadCount > MAX_WORK_THREAD then
    FThreadCount := MAX_WORK_THREAD;
  FAcceptExSocket.ThreadCount := FThreadCount;

  for i := 0 to FThreadCount - 1 do
  begin
    FWorkThread[i] := TAcceptExWorkedThread.Create(
      FSendSocket,
      FRecvSocket,
      FAcceptExSocket,
      CompPort);
  end;

  FAcceptExSocket.SendSocket := FSendSocket;
  FAcceptExSocket.RecvSocket := FRecvSocket;
end;

constructor TIOCPServer.Create();
begin
  FUserList := TUserManager.Create(MAX_GAME_USER);
  FSendSocket := TIOCPWriter.Create(MAX_GAME_USER, FUserList);
  FRecvSocket := TIOCPReader.Create(MAX_GAME_USER, FSendSocket, FUserList);
  FAcceptExSocket := TIOCPAccepter.Create(MAX_LOGIN_USER, FUserList);
end;

destructor TIOCPServer.Destroy;
begin
  if FIsStarted then
    StopService
  else
  begin
    FUserList.Free;
    FSendSocket.Free;
    FRecvSocket.Free;
    FAcceptExSocket.Free;
  end;
  inherited Destroy;
end;

procedure TIOCPServer.SetGameServerCount(const Value: Integer);
begin
  if FIsStarted then
    Exit;
  if FGameServerCount <> Value then
    FGameServerCount := Value;
end;

procedure TIOCPServer.StartService;
begin
  if FIsStarted then
    Exit;
  try
    FAcceptExSocket.OnInitCompPortFinished := CompPortInit;
    FAcceptExSocket.OnCleanupComPortEnd := CompPortcleanup;
    FAcceptExSocket.Active := True;
    FIsStarted := True;
    if Assigned(FOnStartEvent) then
      FOnStartEvent(self);
  except
    on E: Exception do
      raise EIOCPServer.CreateFmt('打开服务失败：%s...', [E.Message]);
  end;
end;

procedure TIOCPServer.StopService;
var
  i: Integer;
begin
  if FIsStarted then
  try

    FAcceptExSocket.Active := False;

    for i := 0 to FThreadCount - 1 do
    begin
      FWorkThread[i].Free;
    end;

    FAcceptExSocket.Free;
    FreeAndNil(FSendSocket);
    FreeAndNil(FRecvSocket);

    if Assigned(FOnStopEvent) then
      FOnStopEvent(self);

    FreeAndNil(FUserList);
    FIsStarted := False;
  except
    on E: Exception do
      raise EIOCPServer.CreateFmt('关闭服务失败，错误消息为：%s...', [E.Message]);
  end;
end;

{ TGameServerManager }

procedure TGameServerManager.CloseAllGameServer;
var
  i: Integer;
begin
  for i := 0 to FCount - 1 do
  begin
    FGameList[i].ClientThread.DisconnectReConnect := False;
    FGameList[i].ClientThread.OnCloseEvent := nil;
    FGameList[i].ClientThread.Active := False;
    Sleep(50);
  end;
end;

constructor TGameServerManager.Create;
begin
  FCount := 0;
end;

destructor TGameServerManager.Destroy;
var
  i: Integer;
begin
  for i := 0 to FCount - 1 do
    FGameList[i].ClientThread.Free;
  inherited Destroy;
end;

function TGameServerManager.FindGameServer(const Port: Integer): TClientThread;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FCount - 1 do
  begin
    if FGameList[i].Port = Port then
    begin
      Result := FGameList[i].ClientThread;
      Break;
    end;
  end;
end;

function TGameServerManager.GetClientThread(Index: Integer): TClientThread;
begin
  Result := FGameList[Index].ClientThread;
end;

function TGameServerManager.InitGameServer(const Port: Integer; const IP: string): TClientThread;
begin
  Result := nil;
  if FCount >= MAX_SERVER_COUNT then
    Exit;
  FGameList[FCount].Port := Port;
  Result := TClientThread.Create;
  FGameList[FCount].ClientThread := Result;
  Result.ServerPort := Port;
  Result.ServerIP := IP;
  //if (Pos('127.0.0.1', IP) > 0) or (Pos('192.168.', IP) > 0) then
  //  Result.m_fKeepAlive := True;
  Inc(FCount);
end;

{ TIOCPManager }

constructor TIOCPManager.Create();
begin
  FIOCPServer := TIOCPServer.Create;
  FServerInfoList := FIOCPServer.FAcceptExSocket.ServerInfo;
  FCount := 0;
end;

destructor TIOCPManager.Destroy();
begin
  FIOCPServer.Free;
  inherited Destroy;
end;

function TIOCPManager.InitServer(const Port: Integer; const ClientThread: TClientThread): TIOCPServer;
begin
  Result := nil;
  if FCount >= MAX_SERVER_COUNT then
    Exit;
  FIOCPServer.AcceptExSocket.InitServer(Port, ClientThread);
  Result := FIOCPServer;
  Inc(FCount);
end;

end.
