unit SHMemLock;

interface

uses
  Windows;

type
  TMemLock = class
  private
    //������
    FMemLock: TRTLCriticalSection;
    //�ͷ���Դ
    FIsExit: BOOL;
    //д�ź�
    FWriteEvent: THANDLE;
    //���ź�
    FReadEvent: THANDLE;
    //��ǰ���û���
    FReadCount: Integer;
    //��ǰд�û���Ŀ
    FWriteCount: Integer;

    //�ж������ڶ�����
    FInReadCount: Integer;
    //�ж�������д����
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

  //���û���κζ�����
  if FWriteCount = 0 then
    bWait := False
  else
    bWait := True;

  Inc(FReadCount);

  LeaveCriticalSection(FMemLock);

  if bWait then
    WaitForSingleObject(FReadEvent, FWaitTimeOut);


  //���Ӷ�������Ŀ
  InterlockedIncrement(FInReadCount);
end;

procedure TMemLock.BeginWrite;
var
  IsWait: boolean;
begin
  IsWait := True;

  EnterCriticalSection(FMemLock);
  //����ж������ڽ�����
      //ֻ�н����е�д������
      //�����еĶ�����ȫ����ɲ��ܽ����µ�д����
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
    //�ж�������д����
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

  //���ʱ������е�д����FInWriteCount=0

  bReSetRead := False;
  bSetWrite := False;

  EnterCriticalSection(FMemLock);
  Dec(FReadCount);

  //���û�ж�����,����д��������ֹ��������
  //��������������һ��BeginRead��������
  if FReadCount = 0 then
  //ʹFReadEvent�����ź�
    bReSetRead := True;

  //��������еĶ�����ȫ�����
  //ͬʱ���µ�д������Ҫ���У�������д����
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

  //��д����������ʱ�� FReadCount����ȫ������Ҫ���Ĳ�����
  // FInRead=0
  // FInWrite=0
      //�Ƿ���Ҫ�����ź�����������
  bSetRead := False;
      //�Ƿ���Ҫ�����ź�����д����
  bSetWrite := False;

  EnterCriticalSection(FMemLock);
  Dec(FWriteCount);

  //�����Ҫ���е�д�����Ƚ϶�
  if FWriteCount > FReadCount then
  begin
  //��Ϊ���ʱ��û�н����еĶ�����
    bSetWrite := True;
  end
  else
  begin
  //����ж�������ʹ����������
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

