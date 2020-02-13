unit ThreadPool;

interface

uses
  Windows, SysUtils, SimpleClass;

//=================ϵͳĬ�ϵ��̳߳غ���������ǿ��=====================
const
  WT_EXECUTEDEFAULT         = $00000000;
  WT_EXECUTEINIOTHREAD      = $00000001;
  WT_EXECUTEINUITHREAD      = $00000002;
  WT_EXECUTEINWAITTHREAD    = $00000004;
  WT_EXECUTEONLYONCE        = $00000008;
  WT_EXECUTEINTIMERTHREAD   = $00000020;
  WT_EXECUTELONGFUNCTION    = $00000010;
  WT_EXECUTEINPERSISTENTIOTHREAD = $00000040;

  WT_EXECUTEINPERSISTENTTHREAD = $00000080;
  WT_EXECUTEINLONGTHREAD    = $00000010;
  WT_EXECUTEDELETEWAIT      = $00000008;

  MAX_THREAD_COUNT          = 6;
  MAX_THREAD_MAX            = 256;      //������߳���Ŀ

  THREAD_EXIT_RESULT        = 0;
  THREAD_WAIT_TIME          = 5000;     //�̳߳�ʱ�ر�ʱ��
  THREAD_TIME_OUT           = 5000;

  //����������󳤶�
  MAX_QUEUE_WORK_COUNT      = 1024;

type
  //�ص���������
  THREAD_START_ROUTINE = function(lpThreadParameter: Pointer): DWORD; stdcall;
  LPTHREAD_START_ROUTINE = ^THREAD_START_ROUTINE;

  //��������
function QueueUserWorkItem(pfnCallback: LPTHREAD_START_ROUTINE; pvContext: Pointer; dwFlags: ULONG): BOOL; stdcall; external 'kernel32.dll' name 'QueueUserWorkItem';

type
  (*
  TAPCThreadPool = class;
  TWorkQueue = class;
  TPoolThread = class;

  //APCThread�ӿ�
  IThreadRun = interface
    ['{21B0CFB9-73A6-495B-86CD-B553E939BCA5}']
    function APCRun(): DWORD;
  end;

  //���Լ����̳߳غ����ӿ�
  IPoolThread = interface
    ['{5E76C68B-B08B-4DDB-A09B-21E9D0D6B3C5}']
    function InitThread(var pvContext: Pointer): Boolean; //��ʼ���߳���Ҫ����Դ
    function PoolThreadRun(Data: Pointer): DWORD; //��ִ�в���
    procedure Close;                    //�ر��߳�
    procedure CleanupThread(var pvContext: Pointer); //�ͷ��̷߳������Դ
  end; *)

  IBaseThread = interface
    ['{9EF2231E-29D5-4B9F-A4B0-B8A0167FF122}']
    procedure CloseThread;
    procedure BaseThreadRun(var Terminated: BOOL);
  end;

  (*PAPCThreadData = ^_apcThreadData;
  _apcThreadData = record
    Pool: TAPCThreadPool;
    RunInterface: IThreadRun;
    InUse: BOOL;                        //�Ƿ�ʹ��
  end;
  TAPCThreadData = _apcThreadData;

  TAPCThreadPool = class
  private
    //��������
    FWorkQueue: TWorkQueue;
    //�����е��߳���Ŀ
    FInWorkCount: Integer;
    //��ǰ����������
    FWorkCount: Integer;
    //�������������
    FMaxWork: Integer;
  protected
    procedure InitThread(ThreadData: PAPCThreadData); virtual;
    procedure CleaunpThread(ThreadData: PAPCThreadData); virtual;
  public
    //�������������
    property WorkCount: Integer read FWorkCount;
    property InWorkCount: Integer read FInWorkCount;
    function AddWork(WorkThread: IThreadRun; flags: DWORD =
      WT_EXECUTEINIOTHREAD): Boolean;

    constructor Create(MaxWork: Integer);
    destructor Destroy; override;
  end;

  //ĳ���߳��¼�
  TOnPoolEvent = procedure(PoolThread: TPoolThread) of object;

  TOnPoolEndEvent = procedure(PoolThread: TPoolThread; var ContinueDoWork: Boolean) of object;

  //�߳���Ҫ���е�����
  //AParam�Ǵ���ȥ�Ĳ���
  TOnThreadEvnet = procedure(Sender: TPoolThread; AParam: Pointer) of object;
  //�ͷ��¼�
  TOnFreeEvent = procedure(Sender: TObject; AItem: Pointer) of object;

  TThreadClass = class of TPoolThread;

  //����������
  TWorkQueue = class
  private
    FWorkQueue: TQueue;
    FWorkLock: TRTLCriticalSection;
    FOnFree: TOnFreeEvent;
    function GetIsEmpty: Boolean;
    function GetQueueWorkCount: Integer;
  public
    property OnFree: TOnFreeEvent read FOnFree write FOnFree;
    //����һ���µĹ���
    function AddWork(AParam: Pointer): Boolean;
    //�õ��µĹ���
    function GetWork: Pointer;

    property IsEmpty: Boolean read GetIsEmpty;

    property InQueueWork: Integer read GetQueueWorkCount;

    procedure Lock;
    procedure UnLock;

    constructor Create(MaxSize: Integer = MAX_QUEUE_WORK_COUNT);
    destructor Destroy; override;
  end;

  //�̳߳���
  EThreadPool = class(Exception);

  TThreadPool = class
  private
    FThreadList: array[0..255] of TPoolThread;

    FWorkQueue: TWorkQueue;

    FThreadClass: TThreadClass;
    //�Ƿ񴴽����߳�
    FCeativeThread: Boolean;
    //��ǰ���������е��߳���Ŀ
    FRunCount: Integer;
    //��������г���
    FMaxWork: Integer;

    //�߳���Ŀ
    FThreadCount: Integer;

    ThreadLock: TRTLCriticalSection;

    procedure OnThreadBegin(PoolThread: TPoolThread);
    procedure OnThreadEnd(PoolThread: TPoolThread; var ContinueDoWork: Boolean);
    function GetThreadItem(Index: Integer): TPoolThread;
    procedure InitPool(MaxThread: Integer);

    function FindThread(Thread: TPoolThread): Integer;

  protected
    function CreateNewThread(ID: Integer): TPoolThread; virtual;
  public
    procedure EnterQuery;
    property ThreadItems[Index: Integer]: TPoolThread read GetThreadItem;
    procedure ExitQuery;

    property WorkQueue: TWorkQueue read FWorkQueue;

    //���еĹ����߳���Ŀ
    property RunThreadCount: Integer read FRunCount;

    //��ǰ�����߳���Ŀ
    property ThreadCount: Integer read FThreadCount;
    //������߳���Ŀ
    property MaxWork: Integer read FMaxWork;

    //ɾ��һ���߳�
    function DeleteMandatory(Thread: TPoolThread): Boolean;

    //ֹͣ�����߳�
    procedure StopAllThread;

    //��������߳�
    procedure ClearAllThread;

    function AddWork(AParam: Pointer): Boolean;

    procedure SetManageThread(ThreadClass: TThreadClass);

    constructor Create(
      ThreadCount: Integer = MAX_THREAD_COUNT;
      MaxWork: Integer = MAX_QUEUE_WORK_COUNT); overload;

    constructor Create(
      ThreadClass: TThreadClass;
      ThreadCount: Integer = MAX_THREAD_COUNT; //����߳���Ŀ
      MaxWork: Integer = MAX_QUEUE_WORK_COUNT); overload; //��������г���

    constructor Create(
      PoolThreadInterface: IPoolThread;
      ThreadCount: Integer = MAX_THREAD_COUNT; //����߳���Ŀ
      MaxWork: Integer = MAX_QUEUE_WORK_COUNT); overload; //��������г���

    destructor Destroy; override;
  end;

  //�����̳߳���
  EPoolThread = class(Exception);

  TPoolThread = class
  private
    FEnd: Boolean;

    FPoolEvent: THANDLE;
    FThread: THANDLE;
    FThreadID: THANDLE;

    FInWork: BOOL;

    //�ṩ���̳߳���ʹ�õĹ���
    FOnWorkEnd: TOnPoolEndEvent;
    FOnWorkBegin: TOnPoolEvent;

    //��㹤���¼�
    FOnOutWorkEnd: TOnThreadEvnet;
    FOnOutWorkBegin: TOnThreadEvnet;

    FData: Pointer;
    procedure DoRun();
  protected
    FClose: BOOL;
    function InitThread: Boolean; virtual;
    procedure CleanupThread; virtual;
    procedure Run(Data: Pointer); virtual; abstract;

    procedure Close; virtual; abstract; //��ѭ��
  public
    //���������¼�
    property OnWorkEnd: TOnThreadEvnet read FOnOutWorkEnd write FOnOutWorkEnd;
    //������ʼ�¼�
    property OnWorkBegin: TOnThreadEvnet read FOnOutWorkBegin write
      FOnOutWorkBegin;

    property InWork: BOOL read FInWork;
    procedure Start;                    //������ѭ��
    procedure Stop;                     //�ر���ѭ��
    constructor Create(); virtual;
    destructor Destroy; override;
  end;

  //֧�ֽӿڵĳ��߳�
  TInterfacePoolThread = class(TPoolThread)
  private
    pvContext: Pointer;
    FInterfacePoolThread: IPoolThread;
  protected
    function InitThread: Boolean; override;
    procedure CleanupThread; override;
    procedure Run(Data: Pointer); override;
    procedure Close; override;
  public
    constructor CreateThread(InterfaceThread: IPoolThread);
    destructor Destroy; override;
  end;   *)

  //�����߳��࣬������̳�ʹ��
  TBThreadPriority = (bpIdle, bpLowest, bpLower, bpNormal, bpHigher, bpHighest, bpTimeCritical);

  EBaseThread = class(Exception);
  TBaseThread = class
  private
    FThread: THANDLE;
    FThreadID: THANDLE;
    FTerminated: BOOL;
    FStart: Boolean;
    FInterfaceThread: IBaseThread;
    FIsExit: BOOL;
    FSuspended: Boolean;
    function GetPriority: TBThreadPriority;
    procedure SetPriority(const Value: TBThreadPriority);
    procedure InitThread;
    procedure CleanupThread;
  protected
    FThreadType: string;
    property Terminated: BOOL read FTerminated;
    procedure Run(); virtual;
    procedure CloseThread; virtual;
  public
    property Exited: BOOL read FIsExit;
    property Handle: THANDLE read FThread;
    property Priority: TBThreadPriority read GetPriority write SetPriority; //���ȼ�
    property Suspended: Boolean read FSuspended;
    procedure Start;
    procedure Suspend;
    procedure Terminate;
    procedure Stop; virtual;
    procedure AfterConstruction; override;
    property ThreadType: string read FThreadType; //��¼�߳�����
    constructor Create(Start: Boolean = True); overload;
    constructor Create(InterfaceThread: IBaseThread; Start: Boolean = True); overload;
    destructor Destroy; override;
  end;

procedure WaitFor(var hThread: THANDLE; WaitTime: DWORD);

implementation

{$IFDEF SHDEBUG}
uses
  IOCPTypeDef, Messages;
{$ENDIF}

procedure WaitForMThread(hThread: PHANDLE; ThreadCount: DWORD; WaitTime: DWORD);
var
  dwRc,
    dwExit, i               : DWORD;
  Msg                       : tMsg;
begin
  dwExit := 0;
  while True do begin                   //�ܹؼ�
    if GetCurrentThreadID = MainThreadID then
      dwRc := MsgWaitForMultipleObjects(
        ThreadCount,
        hThread,
        False,
        WaitTime,
        QS_SENDMESSAGE)
    else
      dwRc := WaitForMultipleObjects(
        ThreadCount,
        @hThread,
        True,
        WaitTime);

    case dwRc of
      WAIT_TIMEOUT: begin
          for i := 0 to ThreadCount - 1 do begin
            GetExitCodeThread(hThread^, dwExit);
            TerminateThread(hThread^, dwExit);
            Inc(hThread);
          end;
          break;
        end;
      WAIT_OBJECT_0 + 1: begin
          PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
        end;
    else
      break;
    end;
  end;

  for i := 0 to ThreadCount - 1 do
    if hThread^ <> INVALID_HANDLE_VALUE then begin
      CloseHandle(hThread^);
      hThread^ := INVALID_HANDLE_VALUE;
      Inc(hThread);
    end;
end;

procedure WaitFor(var hThread: THANDLE; WaitTime: DWORD);
var
  dwRc,
    dwExit                  : DWORD;
  Msg                       : tMsg;
begin
  dwExit := 0;
  while True do begin                   //�ܹؼ�
    if GetCurrentThreadID = MainThreadID then
      dwRc := MsgWaitForMultipleObjects(
        1,
        hThread,
        False,
        WaitTime,
        QS_SENDMESSAGE)
    else
      dwRc := WaitForSingleObject(
        hThread,
        WaitTime);

    case dwRc of
      WAIT_TIMEOUT: begin
          GetExitCodeThread(hThread, dwExit);
          TerminateThread(hThread, dwExit);
          break;
        end;
      WAIT_OBJECT_0 + 1: begin
          PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
        end;
    else
      break;
    end;
  end;

  if hThread <> INVALID_HANDLE_VALUE then begin
    CloseHandle(hThread);
    hThread := INVALID_HANDLE_VALUE;
  end;
end;

(*
{ TThreadPool }

constructor TThreadPool.Create(ThreadCount: Integer = MAX_THREAD_COUNT; MaxWork:
  Integer = MAX_QUEUE_WORK_COUNT);
begin
  FMaxWork := MaxWork;
  InitPool(ThreadCount);
end;

function TThreadPool.AddWork(AParam: Pointer): Boolean;
var
  i                         : Integer;
  AThread                   : TPoolThread;
begin
  Result := False;
  //�ȼ���Ƿ��п����߳�
  EnterCriticalSection(ThreadLock);
  try
    for i := 0 to FThreadCount - 1 do begin
      AThread := TPoolThread(FThreadList[i]);
      if not AThread.InWork then begin
        AThread.FData := AParam;
        AThread.Start;
        InterlockedExchange(Integer(AThread.FInWork), Integer(True));
        Result := True;
      end;
    end;
    //���û�п����߳����������ӵ������б�
  finally
    LeaveCriticalSection(ThreadLock);
  end;

  if Result then
    Exit;

  FWorkQueue.Lock;
  try
    Result := FWorkQueue.AddWork(AParam);
  finally
    FWorkQueue.UnLock;
  end;
end;

constructor TThreadPool.Create(ThreadClass: TThreadClass; ThreadCount: Integer; MaxWork: Integer);
var
  AThread                   : TPoolThread;
  i                         : Integer;
begin
  FMaxWork := MaxWork;
  InitPool(ThreadCount);

  FThreadClass := ThreadClass;

  for i := 0 to FThreadCount - 1 do begin
    AThread := CreateNewThread(i);
    AThread.FOnWorkBegin := OnThreadBegin;
    AThread.FOnWorkEnd := OnThreadEnd;
    FThreadList[i] := AThread;
  end;
  //�ܵĹ�����
  FCeativeThread := True;
end;

function TThreadPool.DeleteMandatory(Thread: TPoolThread): Boolean;
var
  i                         : Integer;
begin
  EnterCriticalSection(ThreadLock);
  try
    Thread.Close;
    FreeAndNil(Thread);
    i := FindThread(Thread);
    if i <> -1 then
      FThreadList[i] := nil;

    InterlockedDecrement(FThreadCount);
    Result := True;
  finally
    LeaveCriticalSection(ThreadLock);
  end;
end;

destructor TThreadPool.Destroy;
var
  i                         : Integer;
  AThread                   : TPoolThread;
begin

  //�ر��̳߳������е��߳�
  if FCeativeThread then begin
    EnterCriticalSection(ThreadLock);
    try
      for i := 0 to FThreadCount - 1 do begin
        AThread := TPoolThread(FThreadList[i]);
        AThread.Close;
        FreeAndNil(AThread);
      end;
    finally
      LeaveCriticalSection(ThreadLock);
    end;
  end;

  DeleteCriticalSection(ThreadLock);
  FWorkQueue.Free;
  inherited Destroy;
end;

procedure TThreadPool.EnterQuery;
begin
  EnterCriticalSection(ThreadLock);
end;

procedure TThreadPool.ExitQuery;
begin
  LeaveCriticalSection(ThreadLock);
end;

function TThreadPool.GetThreadItem(Index: Integer): TPoolThread;
begin
  Result := TPoolThread(FThreadList[Index]);
end;

procedure TThreadPool.InitPool(MaxThread: Integer);
begin
  FRunCount := 0;
  if MaxThread > MAX_THREAD_MAX then
    raise EThreadPool.CreateFmt('����߳���ĿΪ:%d��%d����������...', [MAX_THREAD_MAX, MaxThread]);

  InitializeCriticalSection(ThreadLock);

  FThreadCount := MaxThread;

  FWorkQueue := TWorkQueue.Create(FMaxWork);

  FCeativeThread := False;
end;

procedure TThreadPool.OnThreadEnd(PoolThread: TPoolThread; var ContinueDoWork: Boolean);
var
  PData                     : Pointer;
begin
  //��ʼ��鹤�������Ƿ�ǿգ�����ǿվͰ����µĹ�������
  if PoolThread.FClose then
    Exit;
  FWorkQueue.Lock;
  try
    PData := FWorkQueue.GetWork;
  finally
    FWorkQueue.UnLock;
  end;

  if Assigned(PData) then begin
    PoolThread.FData := PData;
    ContinueDoWork := True;
  end else begin
    //���û���ҵ��µĹ�����������Ϊû�й���
    InterlockedDecrement(FRunCount);
    InterlockedExchange(Integer(PoolThread.FInWork), Integer(False));
  end;

end;

procedure TThreadPool.OnThreadBegin(PoolThread: TPoolThread);
begin
  InterlockedIncrement(FRunCount);
end;

procedure TThreadPool.StopAllThread;
var
  AThread                   : TPoolThread;
  i                         : Integer;
begin
  EnterCriticalSection(ThreadLock);
  try
    for i := 0 to FThreadCount - 1 do begin
      AThread := TPoolThread(FThreadList[i]);
      AThread.Close;
    end;
  finally
    LeaveCriticalSection(ThreadLock);
  end;
end;

procedure TThreadPool.SetManageThread(ThreadClass: TThreadClass);
var
  i                         : Integer;
  AThread                   : TPoolThread;
begin
  if FCeativeThread then
    raise EThreadPool.Create('�߳��Ѿ�����...');

  FThreadClass := ThreadClass;

  for i := 0 to FThreadCount - 1 do begin
    AThread := CreateNewThread(i);
    AThread.FOnWorkBegin := OnThreadBegin;
    AThread.FOnWorkEnd := OnThreadEnd;
    FThreadList[i] := AThread;
  end;

  FCeativeThread := True;

end;

function TThreadPool.CreateNewThread(ID: Integer): TPoolThread;
begin
  Result := FThreadClass.Create;
end;

procedure TThreadPool.ClearAllThread;
var
  i                         : Integer;
  AThread                   : TPoolThread;
begin
  for i := 0 to FThreadCount - 1 do begin
    AThread := TPoolThread(FThreadList[i]);
    AThread.Free;
  end;

  FThreadCount := 0;
  FCeativeThread := False;
end;

function TThreadPool.FindThread(Thread: TPoolThread): Integer;
var
  i                         : Integer;
begin
  Result := -1;
  for i := 0 to FThreadCount - 1 do begin
    if FThreadList[i] = Thread then begin
      Result := i;
      break;
    end;
  end;
end;

{ TPoolThread }

{==========================================================================}

function ThreadProc(AThread: TPoolThread): Integer;
begin
  Result := THREAD_EXIT_RESULT;
{$IFDEF SHDEBUG}
  SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar('��½У���߳�����')));
{$ENDIF}
  try
    AThread.DoRun;
  finally
    AThread.FEnd := True;
{$IFDEF SHDEBUG}
    SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar('��½У���߳��˳�')));
{$ENDIF}
    EndThread(Result);
  end;
end;
{==========================================================================}

constructor TPoolThread.Create();
var
  dwFlags                   : DWORD;
begin
  FInWork := False;
  FPoolEvent := CreateEvent(nil, False, False, nil);
  FClose := False;
  dwFlags := 0;
  FEnd := False;
  FThread := BeginThread(
    nil,
    0,
    @ThreadProc,
    Pointer(self),
    dwFlags,
    FThreadID);
end;

constructor TThreadPool.Create(PoolThreadInterface: IPoolThread;
  ThreadCount: Integer; MaxWork: Integer);
var
  AThread                   : TInterfacePoolThread;
  i                         : Integer;
begin
  FMaxWork := MaxWork;

  InitPool(ThreadCount);

  FThreadClass := TInterfacePoolThread;

  for i := 0 to ThreadCount - 1 do begin
    AThread := TInterfacePoolThread(CreateNewThread(i));
    AThread.FOnWorkBegin := OnThreadBegin;
    AThread.FOnWorkEnd := OnThreadEnd;
    FThreadList[i] := AThread;
  end;

  FCeativeThread := True;

end;

destructor TPoolThread.Destroy;
begin
  //�ȹر��߳���ѭ��
  Stop;
  FInWork := False;
  CloseHandle(FPoolEvent);
  inherited Destroy;
end;

procedure TPoolThread.DoRun;
label
  DoWork;
var
  dwRc                      : DWORD;
  ContinueDo                : Boolean;
begin

  if not InitThread then
    Exit;

  try
    while True do begin
      dwRc := WaitForSingleObject(
        FPoolEvent,
        INFINITE);

      DoWork:
      if FClose then
        break;

      if dwRc <> WAIT_OBJECT_0 then
        break;

      //��ʼ�����̳߳��¼�
      FOnWorkBegin(self);

      if Assigned(FOnOutWorkBegin) then
        FOnOutWorkBegin(self, FData);
      try
        Run(FData);
      except
        //��¼�쳣��Ϣ
      end;

      if Assigned(FOnOutWorkEnd) then
        FOnOutWorkEnd(self, FData);

      ContinueDo := False;
      FOnWorkEnd(self, ContinueDo);

      if ContinueDo then
        goto DoWork;

    end;

  finally
    CleanupThread;
  end;
end;

procedure TPoolThread.CleanupThread;
begin
end;

function TPoolThread.InitThread: Boolean;
begin
  Result := True;
end;

procedure TPoolThread.Start;
begin
  SetEvent(FPoolEvent);
end;

procedure TPoolThread.Stop;             //�ر��߳�
begin
  InterlockedExchange(Integer(FClose), Integer(True));
  SetEvent(FPoolEvent);
  Close;
  if not FEnd then                      //�ٹر���ѭ��
    WaitFor(FThread, THREAD_WAIT_TIME)
  else begin
    if FThread <> INVALID_HANDLE_VALUE then begin
      CloseHandle(FThread);
      FThread := INVALID_HANDLE_VALUE;
    end;
  end;
end;

{ TWorkQueue }

function TWorkQueue.AddWork(AParam: Pointer): Boolean;
begin
  Result := FWorkQueue.Push(AParam);
end;

constructor TWorkQueue.Create(MaxSize: Integer = MAX_QUEUE_WORK_COUNT);
begin
  FWorkQueue := TQueue.Create(MaxSize);
  InitializeCriticalSection(FWorkLock);
end;

destructor TWorkQueue.Destroy;
var
  i                         : Integer;
begin
  if Assigned(FOnFree) then
    for i := 0 to FWorkQueue.InUseSize - 1 do
      FOnFree(self, FWorkQueue.Pop);

  FWorkQueue.Free;
  DeleteCriticalSection(FWorkLock);

  inherited Destroy;
end;

function TWorkQueue.GetIsEmpty: Boolean;
begin
  EnterCriticalSection(FWorkLock);
  try
    Result := FWorkQueue.InUseSize = 0;
  finally
    LeaveCriticalSection(FWorkLock);
  end;
end;

function TWorkQueue.GetQueueWorkCount: Integer;
begin
  EnterCriticalSection(FWorkLock);
  try
    Result := FWorkQueue.InUseSize;
  finally
    LeaveCriticalSection(FWorkLock);
  end;
end;

function TWorkQueue.GetWork: Pointer;
begin
  Result := FWorkQueue.Pop;
end;

procedure TWorkQueue.Lock;
begin
  EnterCriticalSection(FWorkLock);
end;

procedure TWorkQueue.UnLock;
begin
  LeaveCriticalSection(FWorkLock);
end;

{ APCThread }

function APCThreadRun(APCData: PAPCThreadData): DWORD; stdcall;
begin
  with APCData^ do begin
    Pool.InitThread(APCData);
    try
      Result := RunInterface.APCRun();
    finally
      Pool.CleaunpThread(APCData);
    end;
  end;
end;

{ APCThreadPool }

function TAPCThreadPool.AddWork(WorkThread: IThreadRun; flags: DWORD =
  WT_EXECUTEINIOTHREAD or WT_EXECUTEDEFAULT): Boolean;
var
  ThreadData                : PAPCThreadData;
begin
  New(ThreadData);
  ThreadData.RunInterface := WorkThread;
  ThreadData.Pool := self;
  InterlockedIncrement(FWorkCount);
  Result := QueueUserWorkItem(
    @APCThreadRun,
    ThreadData,
    flags);
end;

procedure TAPCThreadPool.CleaunpThread(ThreadData: PAPCThreadData);
begin
  Dispose(ThreadData);
  InterlockedDecrement(FInWorkCount);
end;

constructor TAPCThreadPool.Create(MaxWork: Integer);
begin
  FMaxWork := MaxWork;
  FWorkCount := 0;
  FInWorkCount := 0;
end;

destructor TAPCThreadPool.Destroy;
begin
  FWorkQueue.Free;
  inherited Destroy;
end;

procedure TAPCThreadPool.InitThread(ThreadData: PAPCThreadData);
begin
  InterlockedIncrement(FInWorkCount);
  InterlockedDecrement(FWorkCount);
end;  *)

{BaseThread}

function BaseThreadProc(BaseThread: TBaseThread): Integer;
begin
  Result := THREAD_EXIT_RESULT;
  try
{$IFDEF SHDEBUG}
    SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar('Thread Init')));
{$ENDIF}
    BaseThread.Run;
  finally
{$IFDEF SHDEBUG}
    SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar(BaseThread.FThreadType + 'Thread cleanup')));
{$ENDIF}
    BaseThread.FIsExit := True;
    EndThread(Result);
  end;

end;

{ TBaseThread }
const
  Priorities                : array[TBThreadPriority] of Integer =
    (THREAD_PRIORITY_IDLE, THREAD_PRIORITY_LOWEST, THREAD_PRIORITY_BELOW_NORMAL,
    THREAD_PRIORITY_NORMAL, THREAD_PRIORITY_ABOVE_NORMAL,
    THREAD_PRIORITY_HIGHEST, THREAD_PRIORITY_TIME_CRITICAL);

constructor TBaseThread.Create(Start: Boolean);
begin
  InitThread;
  FStart := Start;
end;

constructor TBaseThread.Create(InterfaceThread: IBaseThread; Start: Boolean);
begin
  InitThread;
  FInterfaceThread := InterfaceThread;
  FStart := Start;
end;

destructor TBaseThread.Destroy;
begin
  if not FStart then
    Start;
  CleanupThread;
  inherited Destroy;
end;

function TBaseThread.GetPriority: TBThreadPriority;
var
  P                         : Integer;
  ThreadPriority            : TBThreadPriority;
begin
  P := GetThreadPriority(FThread);
  if P = THREAD_PRIORITY_ERROR_RETURN then
    raise EBaseThread.CreateFmt('�õ��߳����ȼ������������Ϊ:%d', [GetLastError()]);

  Result := bpNormal;

  for ThreadPriority := Low(TBThreadPriority) to High(TBThreadPriority) do
    if Priorities[ThreadPriority] = P then
      Result := ThreadPriority;
end;

procedure TBaseThread.SetPriority(const Value: TBThreadPriority);
begin
  if not SetThreadPriority(FThread, Priorities[Value]) then
    raise EBaseThread.CreateFmt('�����߳����ȼ������������Ϊ:%d', [GetLastError]);
end;

procedure TBaseThread.Start;
var
  dwCount                   : DWORD;
begin
  dwCount := ResumeThread(FThread);
  try
    if dwCount = 1 then
      FSuspended := False
    else if dwCount = $FFFFFFFF then
      raise EBaseThread.CreateFmt('�����̳߳��ִ��󣬴������Ϊ:%d', [GetLastError()]);
    FStart := True;
  except
    if dwCount > 1 then
      FStart := False;
    raise;
  end;
end;

procedure TBaseThread.Suspend;
var
  OrdSuspend                : Boolean;
begin
  OrdSuspend := FSuspended;
  try
    if SuspendThread(FThread) = $FFFFFFFF then raise EBaseThread.CreateFmt('�����̳߳��ִ��󣬴������Ϊ:%d', [GetLastError()]);
    FSuspended := True;
  except
    FSuspended := OrdSuspend;
    raise;
  end;
end;

procedure TBaseThread.AfterConstruction;
begin
  inherited;
  if FStart then
    Start;
end;

procedure TBaseThread.CleanupThread;
begin
  if (not FIsExit) then begin
    Terminate;
    if Assigned(FInterfaceThread) then
      FInterfaceThread.CloseThread;
    WaitFor(FThread, THREAD_TIME_OUT);
    FThreadID := 0;
  end;
  if FThread <> INVALID_HANDLE_VALUE then
    CloseHandle(FThread);
end;

procedure TBaseThread.InitThread;
var
  dwFlags                   : DWORD;
begin
  FTerminated := False;
  FInterfaceThread := nil;
  FStart := False;
  FIsExit := False;
  FSuspended := True;
  dwFlags := CREATE_SUSPENDED;
  FThread := BeginThread(
    nil,
    0,
    @BaseThreadProc,
    Pointer(self),
    dwFlags,
    FThreadID);
end;

procedure TBaseThread.Terminate;
begin
  if not FTerminated then
    InterlockedExchange(Integer(FTerminated), Integer(True));
end;

procedure TBaseThread.Run;
begin
  if FInterfaceThread <> nil then
    FInterfaceThread.BaseThreadRun(FTerminated);
end;

procedure TBaseThread.Stop;
begin
  Terminate;
  if FInterfaceThread <> nil then
    FInterfaceThread.CloseThread
  else
    CloseThread;
end;

procedure TBaseThread.CloseThread;
begin
end;

(*
{ TInterfacePoolThread }

procedure TInterfacePoolThread.CleanupThread;
begin
  FInterfacePoolThread.CleanupThread(pvContext);
end;

procedure TInterfacePoolThread.Close;
begin
  FInterfacePoolThread.Close;
end;

constructor TInterfacePoolThread.CreateThread(InterfaceThread: IPoolThread);
begin
  FInterfacePoolThread := InterfaceThread;
  inherited Create;
end;

destructor TInterfacePoolThread.Destroy;
begin
  inherited Destroy;
end;

function TInterfacePoolThread.InitThread: Boolean;
begin
  Result := FInterfacePoolThread.InitThread(pvContext);
end;

procedure TInterfacePoolThread.Run(Data: Pointer);
begin
  FInterfacePoolThread.PoolThreadRun(Data);
end;
  *)

end.

