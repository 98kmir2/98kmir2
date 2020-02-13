unit EventTimer;

interface

uses
  Windows, SysUtils, MMSystem, PointerList;

{-----------------------------------------------------------------------------
 Unit Name: EventTimer
 Author:    孙辉
 Purpose:   本单元包含
                1。多媒体定时器    支持WIN98 Win2k WinXP
                2。事件线程池APC定时器   支持 Win2k WinXP
 History:
-----------------------------------------------------------------------------}

const
  //最大定时器工作数
  MAX_TIMER_WORK                        = 64;

type
  //定时器接口
  //提示
  //如果想关闭定时器只需要把WakeTime=0就可以了
  ITimer = interface
    ['{48ADB26A-116A-4010-81D0-9F5742606680}']
    procedure OnTimer(var WakeTime: DWORD);
  end;

  //可以传递参数给Timer的接口
  IDataTimer = interface
    ['{1423463A-6B96-4547-8D29-719EB1BFF8FD}']
    procedure OnDataTimer(const WakeTime: DWORD; const pContext: Pointer);
  end;

const
  WT_EXECUTEDEFAULT                     = $00000000;
  WT_EXECUTEINIOTHREAD                  = $00000001;
  WT_EXECUTEINUITHREAD                  = $00000002;
  WT_EXECUTEINWAITTHREAD                = $00000004;
  WT_EXECUTEONLYONCE                    = $00000008;
  WT_EXECUTEINTIMERTHREAD               = $00000020;
  WT_EXECUTELONGFUNCTION                = $00000010;
  WT_EXECUTEINPERSISTENTIOTHREAD        = $00000040;

  WT_EXECUTEINPERSISTENTTHREAD          = $00000080;
  WT_EXECUTEINLONGTHREAD                = $00000010;
  WT_EXECUTEDELETEWAIT                  = $00000008;

type
  TQueueTimer = class;

  //关闭定时器只需要把 WakeTime=0就可以关闭该定时器
  TQueueTimerEvent = procedure(var WakeTime: DWORD) of object;

  TQueueDataTimerEvent = procedure(const WakeTime: DWORD; const pContext: Pointer) of object;

  PTimerItem = ^_TimerItem;

  TDoOnTimer = procedure(PItem: PTimerItem) of object;

  _TimerItem = record
    hTimer: THANDLE;                    //定时器句柄
    WakeTime: DWORD;                    //间隔时间
    ItemObj: TQueueTimer;               //类
    ItemProc: TDoOnTimer;               //运行函数地址，减少If else

    TimerEvent: TQueueTimerEvent;       //事件
    TimerInterface: ITimer;             //接口
    pContext: Pointer;                  //附带的参数 \\方便和PDTimerItem一样删除掉
  end;
  //上面和下面的结构是一样的，区别是上面的结构里pContext=nil的话说明是空的

  PDTimerItem = ^_DTimerItem;
  _DTimerItem = record
    hTimer: THANDLE;                    //定时器句柄
    WakeTime: DWORD;                    //间隔时间
    ItemObj: TQueueTimer;               //类
    ItemProc: TDoOnTimer;               //运行函数地址，减少If else

    //
    DataTimerEvent: TQueueDataTimerEvent;
    DataTimerInterface: IDataTimer;
    pContext: Pointer;                  //附带的参数 \\
  end;

  TTimerItem = _TimerItem;

  //===win2k/xp独有
  EQueueTimer = class(Exception);

  TQueueTimer = class
  private
    FActive: boolean;
    FTimerList: THPointerList;
    FMaxWork: Integer;
    FTimerLock: TRTLCriticalSection;
    //主事件定时器句柄
    hTimer: THANDLE;

    function IndexOfInterface(TimerInterface: ITimer): Integer;
    function IndexOfEvent(TimerEvent: TQueueTimerEvent): Integer;
    procedure SetActive(const Value: boolean);
    procedure ChangeTimer(const PItem: PTimerItem);
    procedure CreateQueueTimer;
    procedure CloseQueueTimer;
    procedure CheckQueueTimer(TimerResult: BOOL; TimerFunc: string);
    procedure SetMaxWork(const Value: Integer);

  protected
    procedure InterfaceDoOnTimer(PItem: PTimerItem);
    procedure ObjectDoOnTimer(PItem: PTimerItem);

    procedure DataObjectDoOnTimer(PItem: PTimerItem);
    procedure DataInterfaceDoOnTimer(PItem: PTimerItem);
    procedure DeleteTimer(const PItem: PTimerItem); virtual;
    procedure CreateTimer(const PItem: PTimerItem; Flags: ULONG; isOnece: boolean
      = False); virtual;
  public
    //增加新的定时器工作
    //TimerInterface:ITimer的接口
     //WakeTime 间隔时间
     //Flage标志
    function AddTimerWork(TimerInterface: ITimer; WakeTime: DWORD; Flags: ULONG
      = WT_EXECUTEDEFAULT): boolean; overload;
    function AddTimerWork(TimerEvent: TQueueTimerEvent; WakeTime: DWORD; Flags:
      ULONG = WT_EXECUTEDEFAULT): boolean; overload;
    procedure DeleteTimerWork(TimerInterface: ITimer); overload;
    procedure DeleteTimerWork(TimerEvent: TQueueTimerEvent); overload;

    //加入一个只执行一次的操作
    function AddOnceTimerWork(TimerEvent: TQueueDataTimerEvent; WakeTime: DWORD;
      pContext: Pointer; Flags: ULONG = WT_EXECUTEDEFAULT): boolean; overload;
    function AddOnceTimerWork(TimerInterface: IDataTimer; WakeTime: DWORD;
      pContext: Pointer; Flags: ULONG = WT_EXECUTEDEFAULT): boolean; overload;

    property Active: boolean read FActive write SetActive;
    //最大工作数量
    property MaxWork: Integer read FMaxWork write SetMaxWork;
    //构造函数
    constructor Create(MaxWork: Integer = MAX_TIMER_WORK);
    //析构函数
    destructor Destroy; override;
  end;

  TTimeEvent = procedure(Sender: TObject) of object;

  EEventTimer = class(Exception);

  TEventTimer = class
  private
    FEvent: UINT;
    FResolution: UINT;
    FTimeSignal: UINT;
    FActive: boolean;
    FOnTimeSignaled: TTimeEvent;
    procedure SetActive(const Value: boolean);
    procedure SetTimeSignal(const Value: UINT);
  protected
    procedure DoActive(Active: boolean);
    function Run(): boolean; virtual;
  public
    //发信号事件
    property TimeSignal: UINT read FTimeSignal write SetTimeSignal;
    property OnTimeSignaled: TTimeEvent read FOnTimeSignaled write
      FOnTimeSignaled;
    property Active: boolean read FActive write SetActive;

    constructor Create(TimeSignal: DWORD);
    //析构函数
    destructor Destroy; override;
  end;

  //TThreadTimer=class

implementation

uses
{$IFDEF SHDEBUG}
  IOCPTypeDef,
  Messages,
{$ENDIF}
  Math;

type
  WaitOrTimerCallback = procedure(pvContext: Pointer; fTimerOrWaitFired: BOOL);
  stdcall;
  WAIT_OR_TIMER_CALLBACK = WaitOrTimerCallback;

function CreateTimerQueue(
  ): THANDLE; stdcall; external kernel32 name 'CreateTimerQueue';

function CreateTimerQueueTimer(
  var hNewTimer: THANDLE;
  hTimerQueue: THANDLE;
  pfnCallback: WAIT_OR_TIMER_CALLBACK;
  pvContext: Pointer;
  dwDueTime: DWORD;
  dwPeriod: DWORD;
  dwFlags: DWORD
  ): BOOL; stdcall; external kernel32 name 'CreateTimerQueueTimer';

function DeleteTimerQueueTimer(
  hTimerQueue,
  hTimer,
  hCompletionEvent: THANDLE
  ): BOOL; stdcall; external kernel32 name 'DeleteTimerQueueTimer';

function ChangeTimerQueueTimer(
  hTimerQueue,
  hTimer: THANDLE;
  dwDueTime,
  dwPeriod: ULONG
  ): BOOL; stdcall; external kernel32 name 'ChangeTimerQueueTimer';

function DeleteTimerQueueEx(
  hTimerQueue,
  hCompletionEvent: THANDLE
  ): BOOL; stdcall; external kernel32 name 'DeleteTimerQueueEx';

{ TEventTimer }

procedure TimeProc(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD); stdcall;
begin
  if uTimerID = TEventTimer(dwUser).FEvent then
    TEventTimer(dwUser).Run();
end;

constructor TEventTimer.Create(TimeSignal: DWORD);
var
  timecaps                              : TTIMECAPS;
begin
  FTimeSignal := TimeSignal;
  FActive := False;
  FEvent := 0;
  timeGetDevCaps(@timecaps, SizeOf(TIMECAPS));
  FResolution := Min(Max(timecaps.wPeriodMin, 1), timecaps.wPeriodMax);
  timeBeginPeriod(FResolution);
{$IFDEF SHDEBUG}
  SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar('Timer线程开始启动...')));
{$ENDIF}
end;

destructor TEventTimer.Destroy;
begin
  SetActive(False);
  timeEndPeriod(FResolution);
{$IFDEF SHDEBUG}
  SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar('Timer线程关闭...')));
{$ENDIF}
  inherited Destroy;
end;

procedure TEventTimer.DoActive(Active: boolean);
begin
  if Active then
  begin
    FEvent := timeSetEvent(
      FTimeSignal,
      FResolution,
      @TimeProc,
      DWORD(Self),
      TIME_PERIODIC);
    if FEvent = 0 then
      raise EEventTimer.CreateFmt(
        '开始启动定时器发生错误，错误代码为：%d',
        [GetLastError()]);
    FActive := Active;
  end
  else
  begin
    if FEvent <> 0 then
      timeKillEvent(FEvent);
{$IFDEF SHDEBUG}
    SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar('Timer关闭...')));
{$ENDIF}
    FActive := Active;
  end;
end;

function TEventTimer.Run(): boolean;
begin
  Result := False;
  if Assigned(FOnTimeSignaled) then
  try
    FOnTimeSignaled(Self);
    Result := True;
  except
    Result := False;
  end;
end;

procedure TEventTimer.SetActive(const Value: boolean);
begin
  if FActive <> Value then
    DoActive(Value);
end;

procedure TEventTimer.SetTimeSignal(const Value: UINT);
begin
  if Value <> FTimeSignal then
  begin
    if FActive then
      raise EEventTimer.Create('定时器工作中，不能调整分辨率...');
    FTimeSignal := Value;
  end;
end;

//==QueueTimer相关操作
//==每一个节点保存的结构

procedure QueueTimerFunc(pvContext: Pointer; fTimerOrWaitFired: BOOL); stdcall;
var
  OrdWakeTime                           : DWORD;
begin
  with PTimerItem(pvContext)^ do
  begin
    OrdWakeTime := WakeTime;
    ItemProc(pvContext);
    if OrdWakeTime <> WakeTime then
    begin
      if WakeTime = 0 then
        ItemObj.DeleteTimer(pvContext)
      else
        ItemObj.ChangeTimer(pvContext);
    end;
  end;
end;

{ TQueueTimer }

function TQueueTimer.AddOnceTimerWork(
  TimerEvent: TQueueDataTimerEvent;
  WakeTime: DWORD;
  pContext: Pointer;
  Flags: ULONG = WT_EXECUTEDEFAULT
  ): boolean;
var
  PItem                                 : PDTimerItem;
begin
  Result := False;
  if (not FActive)
    or (FTimerList.Count >= FMaxWork)
    or (WakeTime = 0) then
    Exit;

  New(PItem);
  try
    PItem.WakeTime := WakeTime;
    PItem.ItemObj := Self;
    PItem.ItemProc := DataObjectDoOnTimer;
    PItem.pContext := pContext;
    @PItem.DataTimerEvent := @TimerEvent;
    CreateTimer(PTimerItem(PItem), Flags);
    Result := True;
  except
    Dispose(PItem);
    raise;
  end;
end;

function TQueueTimer.AddOnceTimerWork(
  TimerInterface: IDataTimer;
  WakeTime: DWORD;
  pContext: Pointer;
  Flags: ULONG = WT_EXECUTEDEFAULT
  ): boolean;
var
  PItem                                 : PDTimerItem;
begin
  Result := False;
  if (not FActive)
    or (FTimerList.Count >= FMaxWork)
    or (WakeTime = 0) then
    Exit;

  New(PItem);
  try
    PItem.WakeTime := WakeTime;
    PItem.ItemObj := Self;
    PItem.ItemProc := DataInterfaceDoOnTimer;
    PItem.pContext := pContext;
    PItem.DataTimerInterface := TimerInterface;
    CreateTimer(PTimerItem(PItem), Flags);
    Result := True;
  except
    Dispose(PItem);
    raise;
  end;
end;

function TQueueTimer.AddTimerWork(
  TimerEvent: TQueueTimerEvent;
  WakeTime: DWORD;
  Flags: ULONG
  ): boolean;
var
  PItem                                 : PTimerItem;
begin
  Result := False;

  if IndexOfEvent(TimerEvent) < 0 then
  begin
    if (not FActive)
      or (FTimerList.Count >= FMaxWork)
      or (WakeTime = 0) then
      Exit;

    New(PItem);
    try
      PItem.WakeTime := WakeTime;
      PItem.ItemProc := ObjectDoOnTimer;
      PItem.TimerEvent := TimerEvent;
      PItem.ItemObj := Self;
      PItem.TimerInterface := nil;
      CreateTimer(PItem, Flags);
      Result := True;
    except
      Dispose(PItem);
      raise;
    end;
  end;

end;

function TQueueTimer.AddTimerWork(
  TimerInterface: ITimer;
  WakeTime: DWORD;
  Flags: ULONG
  ): boolean;
var
  PItem                                 : PTimerItem;
begin
  Result := False;

  if IndexOfInterface(TimerInterface) < 0 then
  begin
    if (not FActive)
      or (FTimerList.Count >= FMaxWork)
      or (WakeTime = 0) then
      Exit;

    New(PItem);
    try
      PItem.WakeTime := WakeTime;
      PItem.ItemProc := InterfaceDoOnTimer;
      PItem.TimerInterface := TimerInterface;
      PItem.ItemObj := Self;
      PItem.TimerEvent := nil;
      CreateTimer(PItem, Flags);
      Result := True;
    except
      Dispose(PItem);
      raise;
    end;

  end;

end;

procedure TQueueTimer.ChangeTimer(const PItem: PTimerItem);
begin
  CheckQueueTimer(ChangeTimerQueueTimer(
    hTimer,
    PItem.hTimer,
    PItem.WakeTime,
    PItem.WakeTime), 'ChangeTimerQueueTimer');
end;

procedure TQueueTimer.CheckQueueTimer(
  TimerResult: BOOL; TimerFunc: string);
var
  iRc                                   : Integer;
begin
  if not TimerResult then
  begin
    iRc := GetLastError();
    //如果是操作没有完成则不能认为是失败
    if iRc <> ERROR_IO_PENDING then
      raise EQueueTimer.CreateFmt('%s发生错误，错误代码为:%d', [TimerFunc,
        GetLastError()])
  end;
end;

procedure TQueueTimer.CloseQueueTimer;
var
  i                                     : Integer;
  PItem                                 : PTimerItem;
begin
  try
    for i := 0 to FTimerList.Count - 1 do
    begin
      PItem := FTimerList.Items[i];

      CheckQueueTimer(
        DeleteTimerQueueTimer(hTimer, PItem.hTimer, 0),
        'DeleteTimerQueueTimer');
      //让进行中的任务结束
      Dispose(PItem);
    end;
    FActive := False;
    FTimerList.Clear;
  finally
    CheckQueueTimer(DeleteTimerQueueEx(hTimer, 0), 'DeleteTimerQueueEx');
  end;
end;

constructor TQueueTimer.Create(MaxWork: Integer = MAX_TIMER_WORK);
begin
  FMaxWork := MaxWork;
  InitializeCriticalSection(FTimerLock);
  FTimerList := THPointerList.Create;
  FTimerList.Capacity := FMaxWork;
  FActive := False;
end;

procedure TQueueTimer.CreateQueueTimer;
begin
  hTimer := CreateTimerQueue();
  FActive := hTimer <> 0;
end;

procedure TQueueTimer.CreateTimer(const PItem: PTimerItem; Flags: ULONG;
  isOnece: boolean = False);
var
  dwBegin                               : DWORD;
begin
  if isOnece then
    dwBegin := 0
  else
    dwBegin := PItem.WakeTime;

  CheckQueueTimer(
    CreateTimerQueueTimer(
    PItem.hTimer,
    hTimer,
    QueueTimerFunc,
    PItem,
    PItem.WakeTime,
    dwBegin,
    Flags), 'CheckQueueTimer');

  EnterCriticalSection(FTimerLock);
  try
    FTimerList.Add(PItem);
  finally
    LeaveCriticalSection(FTimerLock);
  end;
end;

procedure TQueueTimer.DataInterfaceDoOnTimer(PItem: PTimerItem);
begin
  with PDTimerItem(PItem)^ do
  begin
    DataTimerInterface.OnDataTimer(WakeTime, pContext);
    WakeTime := 0;
  end;
end;

procedure TQueueTimer.DataObjectDoOnTimer(PItem: PTimerItem);
begin
  with PDTimerItem(PItem)^ do
  begin
    DataTimerEvent(WakeTime, pContext);
    WakeTime := 0;
  end;
end;

procedure TQueueTimer.DeleteTimer(const PItem: PTimerItem);
begin
  try
    CheckQueueTimer(
      DeleteTimerQueueTimer(hTimer, PItem.hTimer, 0),
      'DeleteTimerQueueTimer');

  finally
    EnterCriticalSection(FTimerLock);
    try
      FTimerList.Remove(PItem);
    finally
      LeaveCriticalSection(FTimerLock);
    end;
    Dispose(PItem);
  end;

end;

procedure TQueueTimer.DeleteTimerWork(TimerInterface: ITimer);
var
  PItem                                 : PTimerItem;
  i                                     : Integer;
begin
  for i := 0 to FTimerList.Count - 1 do
  begin
    PItem := FTimerList.Items[i];
    if PItem.TimerInterface = TimerInterface then
    begin
      DeleteTimer(PItem);
      break;
    end;
  end;
end;

procedure TQueueTimer.DeleteTimerWork(TimerEvent: TQueueTimerEvent);
var
  PItem                                 : PTimerItem;
  i                                     : Integer;
begin
  for i := 0 to FTimerList.Count - 1 do
  begin
    PItem := FTimerList.Items[i];
    if @PItem.TimerEvent = @TimerEvent then
    begin
      DeleteTimer(PItem);
      break;
    end;
  end;
end;

destructor TQueueTimer.Destroy;
var
  PItem                                 : PTimerItem;
  i                                     : Integer;
begin
  if FActive then
  try
    CloseQueueTimer;
  except
    for i := 0 to FTimerList.Count - 1 do
    begin
      PItem := FTimerList.Items[i];
      Dispose(PItem);
    end;
  end;
  FTimerList.Free;
  DeleteCriticalSection(FTimerLock);
  inherited Destroy;
end;

function TQueueTimer.IndexOfEvent(TimerEvent: TQueueTimerEvent): Integer;
var
  PItem                                 : PTimerItem;
  i                                     : Integer;
begin
  Result := -1;
  for i := 0 to FTimerList.Count - 1 do
  begin
    PItem := FTimerList.Items[i];
    if PItem.TimerInterface = nil then
      if @PItem.TimerEvent = @TimerEvent then
      begin
        Result := i;
        break;
      end;
  end;
end;

function TQueueTimer.IndexOfInterface(TimerInterface: ITimer): Integer;
var
  PItem                                 : PTimerItem;
  i                                     : Integer;
begin
  Result := -1;
  for i := 0 to FTimerList.Count - 1 do
  begin
    PItem := FTimerList.Items[i];
    if not Assigned(PItem.TimerEvent) then
      if PItem.TimerInterface = TimerInterface then
      begin
        Result := i;
        break;
      end;
  end;
end;

procedure TQueueTimer.InterfaceDoOnTimer(PItem: PTimerItem);
begin
  PItem.TimerInterface.OnTimer(PItem.WakeTime);
end;

procedure TQueueTimer.ObjectDoOnTimer(PItem: PTimerItem);
begin
  PItem.TimerEvent(PItem.WakeTime);
end;

procedure TQueueTimer.SetActive(const Value: boolean);
begin
  if FActive <> Value then
  begin
    if Value then
      CreateQueueTimer
    else
      CloseQueueTimer;
  end;
end;

procedure TQueueTimer.SetMaxWork(const Value: Integer);
begin
  if FMaxWork <> Value then
    InterlockedExchange(FMaxWork, Value);
end;

end.

