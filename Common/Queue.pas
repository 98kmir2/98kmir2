unit Queue;

interface

uses
  Windows, Whlist;

type
  TQueuet = class(TWhBaseList)
  public
    function Enqueue(pData: pointer): boolean;
    function EnqueueHead(pData: pointer): boolean;
    function Dequeue(): pointer;
  end;

  TWHQueue = class(TQueuet)
  public
    m_cs: TRTLCriticalSection;

    constructor Create;
    destructor Destroy; override;

    function PushQ(lpbtQ: pointer): boolean;
    function PopQ(): pointer;

    function GetCount: integer;
  end;

implementation

{ TQueuet }

function TQueuet.Enqueue(pData: pointer): boolean;
begin
  Result := Insert(pData);
end;

function TQueuet.EnqueueHead(pData: pointer): boolean;
begin
  Result := InsertHead(pData);
end;

function TQueuet.Dequeue: pointer;
begin
  if IsEmpty() then
    Result := nil
  else
    Result := RemoveNode1(m_pHead);
end;

{ TWHQueue }

constructor TWHQueue.Create;
begin
  inherited;
  InitializeCriticalSection(m_cs);
end;

destructor TWHQueue.Destroy;
begin
  ClearAll();
  DeleteCriticalSection(m_cs);
  inherited;
end;

function TWHQueue.GetCount: integer;
begin
  try
    EnterCriticalSection(m_cs);
    Result := inherited GetCount;
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

function TWHQueue.PopQ: pointer;
begin
  Result := nil;
  try
    EnterCriticalSection(m_cs);
    Result := Dequeue();
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

function TWHQueue.PushQ(lpbtQ: pointer): boolean;
begin
  Result := false;
  try
    EnterCriticalSection(m_cs);
    Result := Enqueue(lpbtQ);
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

end.

