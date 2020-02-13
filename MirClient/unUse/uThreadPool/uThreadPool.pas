unit uThreadPool;

{   aPool.AddRequest(TMyRequest.Create(RequestParam1, RequestParam2, ...)); }

interface

uses
  Windows,
  Classes;

// �Ƿ��¼��־
// {$DEFINE NOLOGS}

type
  TCriticalSection = class(TObject)
  protected
    FSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    // �����ٽ���
    procedure Enter;
    // �뿪�ٽ���
    procedure Leave;
    // ���Խ���
    function TryEnter: Boolean;
  end;

type
  // �����������ݵĻ�����
  TWorkItem = class(TObject)
  public
    // �Ƿ����ظ�����
    function IsTheSame(DataObj: TWorkItem): Boolean; virtual;
    // ��� NOLOGS �����壬����á�
    function TextForLog: string; virtual;
  end;

type
  TThreadsPool = class;

  //�߳�״̬
  TThreadState = (tcsInitializing, tcsWaiting, tcsGetting, tcsProcessing,
    tcsProcessed, tcsTerminating, tcsCheckingDown);
  // �����߳̽������̳߳��ڣ� ��Ҫֱ�Ӵ�������������
  TProcessorThread = class(TThread)
  private
    // �����߳�ʱ��ʱ��Event����, �����߳�ֱ����ʼ�����
    hInitFinished: THandle;
    // ��ʼ��������Ϣ
    sInitError: string;
    // ��¼��־
    procedure WriteLog(const Str: string; Level: Integer = 0);
  protected
    // �߳��ٽ���ͬ������
    csProcessingDataObject: TCriticalSection;
    // ƽ������ʱ��
    FAverageProcessing: Integer;
    // �ȴ������ƽ��ʱ��
    FAverageWaitingTime: Integer;
    // ���߳�ʵ��������״̬
    FCurState: TThreadState;
    // ���߳�ʵ�����������̳߳�
    FPool: TThreadsPool;
    // ��ǰ��������ݶ���
    FProcessingDataObject: TWorkItem;
    // �߳�ֹͣ Event, TProcessorThread.Terminate �п��̵�
    hThreadTerminated: THandle;
    uProcessingStart: DWORD;
    // ��ʼ�ȴ���ʱ��, ͨ�� GetTickCount ȡ�á�
    uWaitingStart: DWORD;
    // ����ƽ������ʱ��
    function AverageProcessingTime: DWORD;
    // ����ƽ���ȴ�ʱ��
    function AverageWaitingTime: DWORD;
    procedure Execute; override;
    function IamCurrentlyProcess(DataObj: TWorkItem): Boolean;
    // ת��ö�����͵��߳�״̬Ϊ�ִ�����
    function InfoText: string;
    // �߳��Ƿ�ʱ�䴦��ͬһ�����󣿣�����������
    function IsDead: Boolean;
    // �߳��Ƿ�����ɵ�������
    function isFinished: Boolean;
    // �߳��Ƿ��ڿ���״̬
    function isIdle: Boolean;
    // ƽ��ֵУ�����㡣
    function NewAverage(OldAvg, NewVal: Integer): Integer;
  public
    Tag: Integer;
    constructor Create(APool: TThreadsPool);
    destructor Destroy; override;
    procedure Terminate;
  end;

  // �̳߳�ʼ��ʱ�������¼�
  TProcessorThreadInitializing = procedure(Sender: TThreadsPool; aThread:
    TProcessorThread) of object;
  // �߳̽���ʱ�������¼�
  TProcessorThreadFinalizing = procedure(Sender: TThreadsPool; aThread:
    TProcessorThread) of object;
  // �̴߳�������ʱ�������¼�
  TProcessRequest = procedure(Sender: TThreadsPool; WorkItem: TWorkItem; aThread: TProcessorThread) of object;
  
  TEmptyKind = (
    ekQueueEmpty,                       //����ȡ�պ�
    ekProcessingFinished                // ���һ����������Ϻ�
    );
  // ������п�ʱ�������¼�
  TQueueEmpty = procedure(Sender: TThreadsPool; EmptyKind: TEmptyKind) of
    object;

  TThreadsPool = class(TComponent)
  private
    csQueueManagment: TCriticalSection;
    csThreadManagment: TCriticalSection;
    FProcessRequest: TProcessRequest;
    FQueue: TList;
    FQueueEmpty: TQueueEmpty;
    // �̳߳�ʱ��ֵ
    FThreadDeadTimeout: DWORD;
    FThreadFinalizing: TProcessorThreadFinalizing;
    FThreadInitializing: TProcessorThreadInitializing;
    // �����е��߳�
    FThreads: TList;
    // ִ���� terminat �����˳�ָ��, ���ڽ������߳�.
    FThreadsKilling: TList;
    // ����, ����߳���
    FThreadsMax: Integer;
    // ����, ����߳���
    FThreadsMin: Integer;

    // �̳߳صȴ��¼�
    //FWaitEvent: THandle;
    // �߳���������
    //FRequestCount: Integer;

    // ��ƽ���ȴ�ʱ��
    function PoolAverageWaitingTime: Integer;
    procedure WriteLog(const Str: string; Level: Integer = 0);
  protected
    FLastGetPoint: Integer;
    // Semaphore�� ͳ���������
    hSemRequestCount: THandle;
    // Waitable timer. ÿ30����һ�ε�ʱ����ͬ��
    hTimCheckPoolDown: THandle;
    // �̳߳�ͣ������鲢��������̺߳����̣߳�
    procedure CheckPoolDown;
    // ������̣߳������䲻��Ĺ����߳�
    procedure CheckThreadsForGrow;
    procedure DoProcessed;
    procedure DoProcessRequest(aDataObj: TWorkItem; aThread: TProcessorThread);
      virtual;
    procedure DoQueueEmpty(EmptyKind: TEmptyKind); virtual;
    procedure DoThreadFinalizing(aThread: TProcessorThread); virtual;
    // ִ���¼�
    procedure DoThreadInitializing(aThread: TProcessorThread); virtual;
    // �ͷ� FThreadsKilling �б��е��߳�
    procedure FreeFinishedThreads;
    // ��������
    procedure GetRequest(out Request: TWorkItem);
    // ������߳�
    procedure KillDeadThreads;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // �ͽ��������Ƿ��ظ��ļ��, ��鷢���ظ��ͷ��� False
    function AddRequest(aDataObject: TWorkItem; CheckForDoubles: Boolean =
      False): Boolean; overload;
    // ת��ö�����͵��߳�״̬Ϊ�ִ�����
    function InfoText: string;
    //procedure WaitFor;
  published
    // �̴߳�������ʱ�������¼�
    property OnProcessRequest: TProcessRequest read FProcessRequest write FProcessRequest;
    // �����б�Ϊ��ʱ�ⷢ���¼�
    property OnQueueEmpty: TQueueEmpty read FQueueEmpty write FQueueEmpty;
    // �߳̽���ʱ�������¼�
    property OnThreadFinalizing: TProcessorThreadFinalizing read
      FThreadFinalizing write FThreadFinalizing;
    // �̳߳�ʼ��ʱ�������¼�
    property OnThreadInitializing: TProcessorThreadInitializing read
      FThreadInitializing write FThreadInitializing;
    // �̳߳�ʱֵ������), �������ʱ������Ϊ���߳�
    property ThreadDeadTimeout: DWORD read FThreadDeadTimeout write
      FThreadDeadTimeout default 0;
    // ����߳���
    property ThreadsMax: Integer read FThreadsMax write FThreadsMax default 1;
    // ��С�߳���
    property ThreadsMin: Integer read FThreadsMin write FThreadsMin default 0;
  end;

type
  //��־��־����
  TLogWriteProc = procedure(
    const Str: string;                  //��־
    LogID: Integer = 0;
    Level: Integer = 0                  //Level = 0 - ������Ϣ, 10 - ��������
    );

var
  WriteLog                  : TLogWriteProc; // �������ʵ����д��־

implementation
uses
  SysUtils;

// �����������ݵĻ�����
{
********************************** TWorkItem ***********************************
}

function TWorkItem.IsTheSame(DataObj: TWorkItem): Boolean;
begin
  Result := False;
end;                                    { TWorkItem.IsTheSame }

function TWorkItem.TextForLog: string;
begin
  Result := 'Request';
end;                                    { TWorkItem.TextForLog }

{
********************************* TThreadsPool *********************************
}

constructor TThreadsPool.Create(AOwner: TComponent);
var
  DueTo                     : Int64;
begin
{$IFNDEF NOLOGS}
  WriteLog('�����̳߳�', 5);
{$ENDIF}
  inherited;
  csQueueManagment := TCriticalSection.Create;
  FQueue := TList.Create;
  csThreadManagment := TCriticalSection.Create;
  FThreads := TList.Create;
  FThreadsKilling := TList.Create;
  FThreadsMin := 0;
  FThreadsMax := 1;
  FThreadDeadTimeout := 0;
  FLastGetPoint := 0;
  //FRequestCount := 0;
  //
  hSemRequestCount := CreateSemaphore(nil, 0, $7FFFFFFF, nil);

  DueTo := -1;
  //�ɵȴ��Ķ�ʱ����ֻ����Window NT4����ߣ�
  hTimCheckPoolDown := CreateWaitableTimer(nil, False, nil);

  if hTimCheckPoolDown = 0 then         // Win9x��֧��
    // In Win9x number of thread will be never decrised
    hTimCheckPoolDown := CreateEvent(nil, False, False, nil)
  else
    SetWaitableTimer(hTimCheckPoolDown, DueTo, 30000, nil, nil, False);
end;                                    { TThreadsPool.Create }

destructor TThreadsPool.Destroy;
var
  n, i                      : Integer;
  Handles                   : array of THandle;
begin
{$IFNDEF NOLOGS}
  WriteLog('�̳߳�����', 5);
{$ENDIF}
  csThreadManagment.Enter;

  SetLength(Handles, FThreads.Count);
  n := 0;
  for i := 0 to FThreads.Count - 1 do
    if FThreads[i] <> nil then begin
      Handles[n] := TProcessorThread(FThreads[i]).Handle;
      TProcessorThread(FThreads[i]).Terminate;
      Inc(n);
    end;

  csThreadManagment.Leave;              // lixiaoyu ����� 2009.1.6����û�д��д����޷��ɹ��ͷ�����ִ���еĹ������̣߳�������

  WaitForMultipleObjects(n, @Handles[0], True, 30000); // �ȴ��������߳�ִ����ֹ  lixiaoyu ע���� 2009.1.6

  csThreadManagment.Enter;              // lixiaoyu ����� 2009.1.6 �ٴν������������ͷ���Դ
  for i := 0 to FThreads.Count - 1 do
    TProcessorThread(FThreads[i]).Free;
  FThreads.Free;
  FThreadsKilling.Free;
  csThreadManagment.Free;

  csQueueManagment.Enter;
  for i := FQueue.Count - 1 downto 0 do
    TObject(FQueue[i]).Free;
  FQueue.Free;
  csQueueManagment.Free;

  CloseHandle(hSemRequestCount);
  CloseHandle(hTimCheckPoolDown);
  inherited;
end;                                    { TThreadsPool.Destroy }

{procedure TThreadsPool.WaitFor;
begin
  FWaitEvent := CreateEvent(nil, True, False, nil);
  WaitForSingleObject(FWaitEvent, INFINITE);
  CloseHandle(FWaitEvent);
  //csThreadManagment.Leave;
//    SetLength(Handles, FThreads.Count);
//    n := 0;
//    csThreadManagment.Enter;
//    for i := 0 to FThreads.Count - 1 do
//    begin
//        if FThreads[i] <> nil then
//        begin
//            //ThreadState := CheckThreadFreed( TProcessorThread( FThreads[i]) );
//
//            if not TProcessorThread(FThreads[i]).Terminated then
//            begin
//                Handles[n] := TProcessorThread( FThreads[i]).Handle;
//                Inc( n );
//            end;
//        end;
//    end;
  //WaitForMultipleObjects( n, @Handles[0], True, INFINITE );
end; }

function TThreadsPool.AddRequest(aDataObject: TWorkItem; CheckForDoubles:
  Boolean = False): Boolean;
var
  i                         : Integer;
begin
{$IFNDEF NOLOGS}
  WriteLog('AddRequest(' + aDataObject.TextForLog + ')', 2);
{$ENDIF}
  Result := False;
  csQueueManagment.Enter;
  try
    // ��� CheckForDoubles = TRUE
    // ����������Ƿ��ظ��ļ��
    if CheckForDoubles then
      for i := 0 to FQueue.Count - 1 do
        if (FQueue[i] <> nil) and aDataObject.IsTheSame(TWorkItem(FQueue[i])) then
          Exit;                         // ��������ͬ������

    csThreadManagment.Enter;
    try
      // ������̣߳������䲻��Ĺ����߳�
      CheckThreadsForGrow;

      // ��� CheckForDoubles = TRUE
      // �����Ƿ�����ͬ���������ڴ�����
      if CheckForDoubles then
        for i := 0 to FThreads.Count - 1 do
          if TProcessorThread(FThreads[i]).IamCurrentlyProcess(aDataObject) then
            Exit;                       // ��������ͬ������

    finally
      csThreadManagment.Leave;
    end;

    //������������
    FQueue.Add(aDataObject);

    //�ͷ�һ��ͬ���ź���
    ReleaseSemaphore(hSemRequestCount, 1, nil);
{$IFNDEF NOLOGS}
    WriteLog('�ͷ�һ��ͬ���ź���)', 1);
{$ENDIF}
    Result := True;
  finally
    csQueueManagment.Leave;
  end;
{$IFNDEF NOLOGS}
  //������Ϣ
  WriteLog('����һ������(' + aDataObject.TextForLog + ')', 1);
{$ENDIF}
  //Inc(FRequestCount);
end;                                    { TThreadsPool.AddRequest }

{
�� �� ����TThreadsPool.CheckPoolDown
�����������̳߳�ͣ������鲢��������̺߳����̣߳�
�����������
�� �� ֵ: ��
�������ڣ�2006.10.22 11:31
�޸����ڣ�2006.
��    �ߣ�Kook
����˵����
}

procedure TThreadsPool.CheckPoolDown;
var
  i                         : Integer;
begin
{$IFNDEF NOLOGS}
  WriteLog('TThreadsPool.CheckPoolDown', 1);
{$ENDIF}
  csThreadManagment.Enter;
  try
{$IFNDEF NOLOGS}
    WriteLog(InfoText, 2);
{$ENDIF}
    // ������߳�
    KillDeadThreads;
    // �ͷ� FThreadsKilling �б��е��߳�
    FreeFinishedThreads;

    // ����߳̿��У�����ֹ��
    for i := FThreads.Count - 1 downto FThreadsMin do
      if TProcessorThread(FThreads[i]).isIdle then begin
        //������ֹ����
        TProcessorThread(FThreads[i]).Terminate;
        //������������
        FThreadsKilling.Add(FThreads[i]);
        //�ӹ��������г���
        FThreads.Delete(i);
        //todo: ����
        Break;
      end;
  finally
    csThreadManagment.Leave;
  end;
end;                                    { TThreadsPool.CheckPoolDown }

{
�� �� ����TThreadsPool.CheckThreadsForGrow
����������������̣߳������䲻��Ĺ����߳�
�����������
�� �� ֵ: ��
�������ڣ�2006.10.22 11:31
�޸����ڣ�2006.
��    �ߣ�Kook
����˵����
}

procedure TThreadsPool.CheckThreadsForGrow;
var
  AvgWait                   : Integer;
  i                         : Integer;
begin
  {
    New thread created if:
    �½��̵߳�������
      1. �����߳���С����С�߳���
      2. �����߳���С������߳��� and �̳߳�ƽ���ȴ�ʱ�� < 100ms(ϵͳæ)
      3. ������ڹ����߳�����4��
  }

  csThreadManagment.Enter;
  try
    KillDeadThreads;
    if FThreads.Count < FThreadsMin then begin
{$IFNDEF NOLOGS}
      WriteLog('�����߳���С����С�߳���', 4);
{$ENDIF}
      for i := FThreads.Count to FThreadsMin - 1 do try
        FThreads.Add(TProcessorThread.Create(Self));
      except
        on e: Exception do

          WriteLog(
            'TProcessorThread.Create raise: ' + e.ClassName + #13#10#9'Message: '
            + e.Message,
            9
            );
      end
    end
    else if FThreads.Count < FThreadsMax then begin
{$IFNDEF NOLOGS}
      WriteLog('�����߳���С������߳��� and �̳߳�ƽ���ȴ�ʱ�� < 100ms', 3);
{$ENDIF}
      AvgWait := PoolAverageWaitingTime;
{$IFNDEF NOLOGS}
      WriteLog(Format(
        'FThreads.Count (%d)<FThreadsMax(%d), AvgWait=%d',
        [FThreads.Count, FThreadsMax, AvgWait]),
        4
        );
{$ENDIF}

      if AvgWait < 100 then try
        FThreads.Add(TProcessorThread.Create(Self));
      except
        on e: Exception do
          WriteLog(
            'TProcessorThread.Create raise: ' + e.ClassName +
            #13#10#9'Message: ' + e.Message,
            9
            );
      end;
    end;
  finally
    csThreadManagment.Leave;
  end;
end;                                    { TThreadsPool.CheckThreadsForGrow }

procedure TThreadsPool.DoProcessed;
var
  i                         : Integer;
begin
  if (FLastGetPoint < FQueue.Count) then
    Exit;
  csThreadManagment.Enter;
  try
    for i := 0 to FThreads.Count - 1 do
      if TProcessorThread(FThreads[i]).FCurState in [tcsProcessing] then
        Exit;
  finally
    csThreadManagment.Leave;
  end;
  DoQueueEmpty(ekProcessingFinished);
end;                                    { TThreadsPool.DoProcessed }

procedure TThreadsPool.DoProcessRequest(aDataObj: TWorkItem; aThread:
  TProcessorThread);
begin
  if Assigned(FProcessRequest) then
    FProcessRequest(Self, aDataObj, aThread);
end;                                    { TThreadsPool.DoProcessRequest }

procedure TThreadsPool.DoQueueEmpty(EmptyKind: TEmptyKind);
begin
  if Assigned(FQueueEmpty) then
    FQueueEmpty(Self, EmptyKind);
end;                                    { TThreadsPool.DoQueueEmpty }

procedure TThreadsPool.DoThreadFinalizing(aThread: TProcessorThread);
begin
  if Assigned(FThreadFinalizing) then
    FThreadFinalizing(Self, aThread);
end;                                    { TThreadsPool.DoThreadFinalizing }

procedure TThreadsPool.DoThreadInitializing(aThread: TProcessorThread);
begin
  if Assigned(FThreadInitializing) then
    FThreadInitializing(Self, aThread);
end;                                    { TThreadsPool.DoThreadInitializing }

{
�� �� ����TThreadsPool.FreeFinishedThreads
�����������ͷ� FThreadsKilling �б��е��߳�
�����������
�� �� ֵ: ��
�������ڣ�2006.10.22 11:34
�޸����ڣ�2006.
��    �ߣ�Kook
����˵����
}

procedure TThreadsPool.FreeFinishedThreads;
var
  i                         : Integer;
begin
  if csThreadManagment.TryEnter then try
    for i := FThreadsKilling.Count - 1 downto 0 do
      if TProcessorThread(FThreadsKilling[i]).isFinished then begin
        TProcessorThread(FThreadsKilling[i]).Free;
        FThreadsKilling.Delete(i);
      end;
  finally
    csThreadManagment.Leave
  end;
end;                                    { TThreadsPool.FreeFinishedThreads }

{
�� �� ����TThreadsPool.GetRequest
������������������
���������out Request: TRequestDataObject
�� �� ֵ: ��
�������ڣ�2006.10.22 11:34
�޸����ڣ�2006.
��    �ߣ�Kook
����˵����
}

procedure TThreadsPool.GetRequest(out Request: TWorkItem);
begin
{$IFNDEF NOLOGS}
  WriteLog('��������', 2);
{$ENDIF}
  csQueueManagment.Enter;
  try
    //�����յĶ���Ԫ��
    while (FLastGetPoint < FQueue.Count) and (FQueue[FLastGetPoint] = nil) do
      Inc(FLastGetPoint);

    Assert(FLastGetPoint < FQueue.Count);
    //ѹ�����У������Ԫ��
    if (FQueue.Count > 127) and (FLastGetPoint >= (3 * FQueue.Count) div 4) then begin
{$IFNDEF NOLOGS}
      WriteLog('FQueue.Pack', 1);
{$ENDIF}
      FQueue.Pack;
      FLastGetPoint := 0;
    end;

    Request := TWorkItem(FQueue[FLastGetPoint]);
    FQueue[FLastGetPoint] := nil;
    Inc(FLastGetPoint);
    if (FLastGetPoint = FQueue.Count) then {//���������������} begin

      DoQueueEmpty(ekQueueEmpty);
      FQueue.Clear;
      FLastGetPoint := 0;
    end;
  finally
    csQueueManagment.Leave;
  end;
end;                                    { TThreadsPool.GetRequest }

function TThreadsPool.InfoText: string;
begin
  Result := '';
  //end;
  //{$ELSE}
  //var
  //  i: Integer;
  //begin
  //  csQueueManagment.Enter;
  //  csThreadManagment.Enter;
  //  try
  //    if (FThreads.Count = 0) and (FThreadsKilling.Count = 1) and
  //      TProcessorThread(FThreadsKilling[0]).isFinished then
  //      FreeFinishedThreads;
  //
  //    Result := Format(
  //      'Pool thread: Min=%d, Max=%d, WorkingThreadsCount=%d, TerminatedThreadCount=%d, QueueLength=%d'#13#10,
  //      [ThreadsMin, ThreadsMax, FThreads.Count, FThreadsKilling.Count,
  //      FQueue.Count]
  //        );
  //    if FThreads.Count > 0 then
  //      Result := Result + 'Working threads:'#13#10;
  //    for i := 0 to FThreads.Count - 1 do
  //      Result := Result + TProcessorThread(FThreads[i]).InfoText + #13#10;
  //    if FThreadsKilling.Count > 0 then
  //      Result := Result + 'Terminated threads:'#13#10;
  //    for i := 0 to FThreadsKilling.Count - 1 do
  //      Result := Result + TProcessorThread(FThreadsKilling[i]).InfoText + #13#10;
  //  finally
  //    csThreadManagment.Leave;
  //    csQueueManagment.Leave;
  //  end;
  //end;
  //{$ENDIF}
end;                                    { TThreadsPool.InfoText }

{
�� �� ����TThreadsPool.KillDeadThreads
����������������߳�
�����������
�� �� ֵ: ��
�������ڣ�2006.10.22 11:32
�޸����ڣ�2006.
��    �ߣ�Kook
����˵����
}

procedure TThreadsPool.KillDeadThreads;
var
  i                         : Integer;
begin
  // Check for dead threads
  if csThreadManagment.TryEnter then try
    for i := 0 to FThreads.Count - 1 do
      if TProcessorThread(FThreads[i]).IsDead then begin
        // Dead thread moverd to other list.
        // New thread created to replace dead one
        TProcessorThread(FThreads[i]).Terminate;
        FThreadsKilling.Add(FThreads[i]);
        try
          FThreads[i] := TProcessorThread.Create(Self);
        except
          on e: Exception do begin
            FThreads[i] := nil;
{$IFNDEF NOLOGS}
            WriteLog(
              'TProcessorThread.Create raise: ' + e.ClassName +
              #13#10#9'Message: ' + e.Message,
              9
              );
{$ENDIF}
          end;
        end;
      end;
  finally
    csThreadManagment.Leave
  end;
end;                                    { TThreadsPool.KillDeadThreads }

function TThreadsPool.PoolAverageWaitingTime: Integer;
var
  i                         : Integer;
begin
  Result := 0;
  if FThreads.Count > 0 then begin
    for i := 0 to FThreads.Count - 1 do
      Inc(Result, TProcessorThread(FThreads[i]).AverageWaitingTime);
    Result := Result div FThreads.Count
  end
  else
    Result := 1;
end;                                    { TThreadsPool.PoolAverageWaitingTime }

procedure TThreadsPool.WriteLog(const Str: string; Level: Integer = 0);
begin
{$IFNDEF NOLOGS}
  uThreadPool.WriteLog(Str, 0, Level);
{$ENDIF}
end;                                    { TThreadsPool.WriteLog }

// �����߳̽������̳߳��ڣ� ��Ҫֱ�Ӵ�������������
{
******************************* TProcessorThread *******************************
}

constructor TProcessorThread.Create(APool: TThreadsPool);
begin
  WriteLog('���������߳�', 5);
  inherited Create(True);
  FPool := APool;

  FAverageWaitingTime := 1000;
  FAverageProcessing := 3000;

  sInitError := '';
  {
  ���������������£�
  ��
   ����һ������ nil ���ɡ�
   ���������Ƿ�����ֶ������ƺš�
   ���������ƺŵ���ʼ״̬��False ��ʾ��ơ�
   �����ģ�Event ����, ����������ͬ�Ļ�����ָ��ͬһ������������Ҫ������Event���󣬱�Ҫ��������ͬ������(���������ַ�������.ΪNIL�Ļ�ϵͳÿ�λ��Լ�����һ����ͬ�����֣����Ǳ��δ����Ķ����µ�EVENT)��
   ����ֵ��Event handle��
  }
  hInitFinished := CreateEvent(nil, True, False, nil);
  hThreadTerminated := CreateEvent(nil, True, False, nil);
  csProcessingDataObject := TCriticalSection.Create;
  try
    WriteLog('TProcessorThread.Create::Resume', 3);
    Resume;
    //����, �ȴ���ʼ�����
    WaitForSingleObject(hInitFinished, INFINITE);
    if sInitError <> '' then
      raise Exception.Create(sInitError);
  finally
    CloseHandle(hInitFinished);
  end;
  WriteLog('TProcessorThread.Create::Finished', 3);
end;                                    { TProcessorThread.Create }

destructor TProcessorThread.Destroy;
begin
  WriteLog('�����߳�����', 5);
  CloseHandle(hThreadTerminated);
  csProcessingDataObject.Free;
  inherited;
end;                                    { TProcessorThread.Destroy }

function TProcessorThread.AverageProcessingTime: DWORD;
begin
  if (FCurState in [tcsProcessing]) then
    Result := NewAverage(FAverageProcessing, GetTickCount - uProcessingStart)
  else
    Result := FAverageProcessing
end;                                    { TProcessorThread.AverageProcessingTime }

function TProcessorThread.AverageWaitingTime: DWORD;
begin
  if (FCurState in [tcsWaiting, tcsCheckingDown]) then
    Result := NewAverage(FAverageWaitingTime, GetTickCount - uWaitingStart)
  else
    Result := FAverageWaitingTime
end;                                    { TProcessorThread.AverageWaitingTime }

procedure TProcessorThread.Execute;

type
  THandleID = (hidTerminateThread, hidRequest, hidCheckPoolDown);
var
  WaitedTime                : Integer;
  Handles                   : array[THandleID] of THandle;

begin
  WriteLog('�����߳̽�������', 3);
  //��ǰ״̬����ʼ��
  FCurState := tcsInitializing;
  try
    //ִ���ⲿ�¼�
    FPool.DoThreadInitializing(Self);
  except
    on e: Exception do
      sInitError := e.Message;
  end;

  //��ʼ����ɣ���ʼ��Event�̵�
  SetEvent(hInitFinished);

  WriteLog('TProcessorThread.Execute::Initialized', 3);

  //�����̳߳ص�ͬ�� Event
  Handles[hidTerminateThread] := hThreadTerminated;
  Handles[hidRequest] := FPool.hSemRequestCount;
  Handles[hidCheckPoolDown] := FPool.hTimCheckPoolDown;

  //ʱ�����
  //todo: �������߳����� GetTickCount; �᲻����
  uWaitingStart := GetTickCount;
  //�����ÿ�
  FProcessingDataObject := nil;

  //��Ѳ��
  while not Terminated do begin
    //��ǰ״̬���ȴ�
    FCurState := tcsWaiting;
    //�����̣߳�ʹ�߳�����
    case WaitForMultipleObjects(Length(Handles), @Handles, False, INFINITE) - WAIT_OBJECT_0 of

      WAIT_OBJECT_0 + ord(hidTerminateThread): begin
          WriteLog('TProcessorThread.Execute:: Terminate event signaled ', 5);
          //��ǰ״̬��������ֹ�߳�
          FCurState := tcsTerminating;
          //�˳���Ѳ��(�����߳�)
          Break;
        end;

      WAIT_OBJECT_0 + ord(hidRequest): begin
          WriteLog('TProcessorThread.Execute:: Request semaphore signaled ', 3);
          //�ȴ���ʱ��
          WaitedTime := GetTickCount - uWaitingStart;
          //���¼���ƽ���ȴ�ʱ��
          FAverageWaitingTime := NewAverage(FAverageWaitingTime, WaitedTime);
          //��ǰ״̬����������
          FCurState := tcsGetting;
          //����ȴ�ʱ����̣����鹤���߳��Ƿ��㹻
          if WaitedTime < 5 then
            FPool.CheckThreadsForGrow;
          //���̳߳ص���������еõ�����
          FPool.GetRequest(FProcessingDataObject);
          //��ʼ�����ʱ���
          uProcessingStart := GetTickCount;
          //��ǰ״̬��ִ������
          FCurState := tcsProcessing;
          try
{$IFNDEF NOLOGS}
            WriteLog('Processing: ' + FProcessingDataObject.TextForLog, 2);
{$ENDIF}
            //ִ������
            FPool.DoProcessRequest(FProcessingDataObject, Self);
          except
            on e: Exception do
              WriteLog(
                'OnProcessRequest for ' + FProcessingDataObject.TextForLog +
                #13#10'raise Exception: ' + e.Message,
                8
                );
          end;

          //�ͷ��������
          csProcessingDataObject.Enter;
          try
            FProcessingDataObject.Free;
            FProcessingDataObject := nil;
          finally
            csProcessingDataObject.Leave;
          end;
          //���¼���
          FAverageProcessing := NewAverage(FAverageProcessing, GetTickCount - uProcessingStart);
          //��ǰ״̬��ִ���������
          FCurState := tcsProcessed;
          //ִ���߳����¼�
          FPool.DoProcessed;

          uWaitingStart := GetTickCount;
          //�߳���������1
          //Dec(FPool.FRequestCount);
          //��������߳�����ִ�����
          //if FPool.FRequestCount = 0 then begin
          //  SetEvent(FPool.FWaitEvent);
          //end;
        end;
      WAIT_OBJECT_0 + ord(hidCheckPoolDown): begin
          // !!! Never called under Win9x
          WriteLog('TProcessorThread.Execute:: CheckPoolDown timer signaled ', 4);
          //��ǰ״̬���̳߳�ͣ������鲢��������̺߳����̣߳�
          FCurState := tcsCheckingDown;
          FPool.CheckPoolDown;
        end;
    end;
  end;
  FCurState := tcsTerminating;

  FPool.DoThreadFinalizing(Self);
end;                                    { TProcessorThread.Execute }

function TProcessorThread.IamCurrentlyProcess(DataObj: TWorkItem): Boolean;
begin
  csProcessingDataObject.Enter;
  try
    Result := (FProcessingDataObject <> nil) and
      DataObj.IsTheSame(FProcessingDataObject);
  finally
    csProcessingDataObject.Leave;
  end;
end;                                    { TProcessorThread.IamCurrentlyProcess }

function TProcessorThread.InfoText: string;

const
  ThreadStateNames          : array[TThreadState] of string =
    (
    'tcsInitializing',
    'tcsWaiting',
    'tcsGetting',
    'tcsProcessing',
    'tcsProcessed',
    'tcsTerminating',
    'tcsCheckingDown'
    );

begin
{$IFNDEF NOLOGS}
  Result := Format(
    '%5d: %15s, AverageWaitingTime=%6d, AverageProcessingTime=%6d',
    [ThreadID, ThreadStateNames[FCurState], AverageWaitingTime,
    AverageProcessingTime]
      );
  case FCurState of
    tcsWaiting:
      Result := Result + ', WaitingTime=' + IntToStr(GetTickCount -
        uWaitingStart);
    tcsProcessing:
      Result := Result + ', ProcessingTime=' + IntToStr(GetTickCount -
        uProcessingStart);
  end;

  csProcessingDataObject.Enter;
  try
    if FProcessingDataObject <> nil then
      Result := Result + ' ' + FProcessingDataObject.TextForLog;
  finally
    csProcessingDataObject.Leave;
  end;
{$ENDIF}
end;                                    { TProcessorThread.InfoText }

function TProcessorThread.IsDead: Boolean;
begin
  Result :=
    Terminated or
    (FPool.ThreadDeadTimeout > 0) and (FCurState = tcsProcessing) and
    (GetTickCount - uProcessingStart > FPool.ThreadDeadTimeout);
  if Result then
    WriteLog('Thread dead', 5);
end;                                    { TProcessorThread.IsDead }

function TProcessorThread.isFinished: Boolean;
begin
  Result := WaitForSingleObject(Handle, 0) = WAIT_OBJECT_0;
end;                                    { TProcessorThread.isFinished }

function TProcessorThread.isIdle: Boolean;
begin
  // ����߳�״̬�� tcsWaiting, tcsCheckingDown
  // ���� �ռ�ʱ�� > 100ms,
  // ���� ƽ���Ⱥ�����ʱ�����ƽ������ʱ��� 50%
  // ����Ϊ���С�
  Result :=
    (FCurState in [tcsWaiting, tcsCheckingDown]) and
    (AverageWaitingTime > 100) and
    (AverageWaitingTime * 2 > AverageProcessingTime);
end;                                    { TProcessorThread.isIdle }

function TProcessorThread.NewAverage(OldAvg, NewVal: Integer): Integer;
begin
  Result := (OldAvg * 2 + NewVal) div 3;
end;                                    { TProcessorThread.NewAverage }

procedure TProcessorThread.Terminate;
begin
  WriteLog('TProcessorThread.Terminate', 5);
  inherited Terminate;
  SetEvent(hThreadTerminated);
end;                                    { TProcessorThread.Terminate }

procedure TProcessorThread.WriteLog(const Str: string; Level: Integer = 0);
begin
{$IFNDEF NOLOGS}
  uThreadPool.WriteLog(Str, ThreadID, Level);
{$ENDIF}
end;                                    { TProcessorThread.WriteLog }

{
******************************* TCriticalSection *******************************
}

constructor TCriticalSection.Create;
begin
  InitializeCriticalSection(FSection);
end;                                    { TCriticalSection.Create }

destructor TCriticalSection.Destroy;
begin
  DeleteCriticalSection(FSection);
end;                                    { TCriticalSection.Destroy }

procedure TCriticalSection.Enter;
begin
  EnterCriticalSection(FSection);
end;                                    { TCriticalSection.Enter }

procedure TCriticalSection.Leave;
begin
  LeaveCriticalSection(FSection);
end;                                    { TCriticalSection.Leave }

function TCriticalSection.TryEnter: Boolean;
begin
  Result := TryEnterCriticalSection(FSection);
end;                                    { TCriticalSection.TryEnter }

procedure NoLogs(const Str: string; LogID: Integer = 0; Level: Integer = 0);
begin
end;

initialization
  WriteLog := NoLogs;
end.

