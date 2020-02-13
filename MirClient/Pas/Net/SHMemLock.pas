unit SHMemLock;

interface

uses
  Windows;

type
  TMemLock = class
  private
    //操作锁
    FMemLock: TRTLCriticalSection;
    //释放资源
    FIsExit: BOOL;
    //写信号
    FWriteEvent: THANDLE;
    //读信号
    FReadEvent: THANDLE;
    //当前读用户量
    FReadCount: Integer;
    //当前写用户数目
    FWriteCount: Integer;

    //有多少正在读操作
    FInReadCount: Integer;
    //有多少正在写操作
    FInWriteCount: Integer;

    FWaitTimeOut: DWORD;
  public
    procedure BeginRead;
    procedure EndRead;
    procedure BeginWrite;
    procedure EndWrite;

    constructor Create();
    destructor Destroy; override;
  end;

implementation

const
  DEFAULT_IOTIME_OUNT = $FFFFFFFF;

{ TMemLock }

procedure TMemLock.BeginRead;
var
  bWait: boolean;
begin

  EnterCriticalSection(FMemLock);

  //如果没有任何读操作
  if FWriteCount = 0 then
    bWait := False
  else
    bWait := True;

  Inc(FReadCount);

  LeaveCriticalSection(FMemLock);

  if bWait then
    WaitForSingleObject(FReadEvent, FWaitTimeOut);


  //增加读操作数目
  InterlockedIncrement(FInReadCount);
end;

procedure TMemLock.BeginWrite;
var
  IsWait: boolean;
begin
  IsWait := True;

  EnterCriticalSection(FMemLock);
  //如果有读操作在进行中
      //只有进行中的写操作和
      //进行中的读操作全部完成才能进行新的写操作
  if (FReadCount = 0) and (FWriteCount = 0) then
    IsWait := False;

  Inc(FWriteCount);

  LeaveCriticalSection(FMemLock);

  if IsWait then
    WaitForSingleObject(FWriteEvent, FWaitTimeOut);

  InterlockedIncrement(FInWriteCount);
end;

constructor TMemLock.Create;
begin
  FReadEvent := CreateEvent(nil, True, False, nil);
  FWriteEvent := CreateEvent(nil, False, False, nil);
  FReadCount := 0;
  FWriteCount := 0;
  FIsExit := False;

  FInReadCount := 0;
    //有多少正在写操作
  FInWriteCount := 0; ;

  FWaitTimeOut := DEFAULT_IOTIME_OUNT;
  InitializeCriticalSection(FMemLock);
end;

destructor TMemLock.Destroy;
begin
  InterlockedExchange(Integer(FIsExit), Integer(True));
  CloseHandle(FReadEvent);
  CloseHandle(FWriteEvent);
  DeleteCriticalSection(FMemLock);
  inherited Destroy;
end;

procedure TMemLock.EndRead;
var
  bReSetRead: Boolean;
  bSetWrite: Boolean;
begin

  InterlockedDecrement(FInReadCount);

  //这个时候进行中的写操作FInWriteCount=0

  bReSetRead := False;
  bSetWrite := False;

  EnterCriticalSection(FMemLock);
  Dec(FReadCount);

  //如果没有读操作,允许写操作，禁止读操作，
  //读操作可以在下一次BeginRead里解除锁定
  if FReadCount = 0 then
  //使FReadEvent不发信号
    bReSetRead := True;

  //如果进行中的读操作全部完成
  //同时有新的写操作需要进行，则启动写操作
  if FInReadCount = 0 then
    if FWriteCount > 0 then
      bSetWrite := True;
  LeaveCriticalSection(FMemLock);

  if bReSetRead then
    ReSetEvent(FReadEvent);
  if bSetWrite then
    SetEvent(FWriteEvent);

end;

procedure TMemLock.EndWrite;
var
  bSetRead: boolean;
  bSetWrite: boolean;
begin
  InterlockedDecrement(FInWriteCount);

  //在写操作结束的时候， FReadCount就是全部的需要读的操作了
  // FInRead=0
  // FInWrite=0
      //是否需要发出信号启动读操作
  bSetRead := False;
      //是否需要发出信号启动写操作
  bSetWrite := False;

  EnterCriticalSection(FMemLock);
  Dec(FWriteCount);

  //如果需要进行的写操作比较多
  if FWriteCount > FReadCount then
  begin
  //因为这个时候没有进行中的读操作
    bSetWrite := True;
  end
  else
  begin
  //如果有读操作则使读操作进行
    if FReadCount > 0 then
    begin
      bSetRead := True;
    end;
  end;
  LeaveCriticalSection(FMemLock);


  if bSetWrite then
    SetEvent(FWriteEvent);
  if bSetRead then
    SetEvent(FReadEvent);

end;

end.

