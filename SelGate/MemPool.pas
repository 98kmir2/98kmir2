unit MemPool;

interface

uses
  Windows, SysUtils;

type
  PMemNode = ^_tagMemNode;
  _tagMemNode = record
    InUse: BOOL;
    PriorNode: PMemNode;
    NextNode: PMemNode;
    MemBuffer: PAnsiChar;
  end;
  TMemNode = _tagMemNode;

  TFreeMemEvent = procedure(const MemID: UINT; const MemBuffer: PAnsiChar) of object;

  EMemPool = class(Exception);

  TMemPool = class
  private
    FOnDestroyEvent: TFreeMemEvent;
    FMemRealHeader: PMemNode;
    FMemLocalHeader: PMemNode;
    FTailMemNode: PMemNode;
    FFreeMemNode: PMemNode;
    FPollMemNode: PMemNode;
    FMaxPosition: Integer;
    FMinPosition: Integer;
    FMemory: PAnsiChar;
    FRealBlockCount: Integer;
    FBlockSize: Integer;
    FBlockCount: Integer;
    FInUseBlock: Integer;
    function GetFreeBlock: Integer;
  protected
    procedure BuilderMemoryList;
    procedure DisposeMemItem;
  public
    FMemLock: TRTLCriticalSection;
    property MemoryIDHeader: PMemNode read FMemRealHeader;
    property MemoryLocalHeader: PMemNode read FMemLocalHeader;
    property RealBlockCount: Integer read FRealBlockCount;
    property MemoryBlockCount: Integer read FBlockCount;
    property MemoryBlockSize: Integer read FBlockSize;
    property InUseBlock: Integer read FInUseBlock;
    property FreeBlock: Integer read GetFreeBlock;
    property OnDestroyEvent: TFreeMemEvent read FOnDestroyEvent write FOnDestroyEvent;
    procedure LockMemPool;
    procedure UnLockMemPool;
    procedure FirstMemory;
    procedure NextMemory;
    function MemoryItem: PAnsiChar;
    function MemoryIDItem: PMemNode;
    function IsEnd: Boolean;
    function GetMemory(var MemID: UINT): Pointer;
    function FreeMemory(const MemID: UINT): Boolean;
    function IsRightKey(KeyID: Integer): Boolean;
    procedure ClearMemPool;
    constructor Create(MemoryBlockCount, MemoryBlockSize: Integer);
    destructor Destroy; override;
  end;

implementation

{$IFDEF SHDEBUG}
uses
  IOCPTypeDef, Messages;
{$ENDIF}

const
  //作为防止重复释放内存的间隔内存块
  SPACE_MEM_BLOCK_COUNT = 32;

  { TMemPool }

procedure TMemPool.BuilderMemoryList;
var
  i: Integer;
  PTRMemNode: PMemNode;
  PTRMemory: PAnsiChar;
begin
  //构造内存管理链表
  PTRMemNode := FMemRealHeader;
  PTRMemNode.PriorNode := nil;
  PTRMemNode.NextNode := PMemNode(Integer(PTRMemNode) + SizeOf(TMemNode));
  PTRMemNode.MemBuffer := FMemory;

  PTRMemory := FMemory;
  FMemLocalHeader := PTRMemNode;

  Inc(PTRMemNode);
  Inc(PTRMemory, FBlockSize);

  for i := 0 to FRealBlockCount - 3 do
  begin
    PTRMemNode.PriorNode := FMemLocalHeader;
    PTRMemNode.MemBuffer := PTRMemory;
    FMemLocalHeader := PTRMemNode;
    Inc(PTRMemNode);
    Inc(PTRMemory, FBlockSize);
    FMemLocalHeader.NextNode := PTRMemNode;
  end;

  PTRMemNode.PriorNode := FMemLocalHeader;
  PTRMemNode.NextNode := nil;
  PTRMemNode.MemBuffer := PTRMemory;

  FInUseBlock := 0;

  FMemLocalHeader := nil;
  FTailMemNode := PTRMemNode;
  FFreeMemNode := FMemRealHeader;
  FMinPosition := Integer(FMemRealHeader);
  FMaxPosition := Integer(PTRMemNode);
end;

procedure TMemPool.ClearMemPool;
begin
  DisposeMemItem;
  BuilderMemoryList;
end;

constructor TMemPool.Create(MemoryBlockCount, MemoryBlockSize: Integer);
begin

  FBlockCount := MemoryBlockCount;
  FBlockSize := MemoryBlockSize;
  FRealBlockCount := FBlockCount + SPACE_MEM_BLOCK_COUNT;
  FMemory := HeapAlloc(
    GetProcessHeap(),
    $8,
    FRealBlockCount * FBlockSize);
  if FMemory = nil then
    raise EMemPool.CreateFmt('分配内存缓冲错误，错误代码为：%d', [GetLastError()]);

  //$8 is HEAP_ZERO_MEMORY	but delphi no define this value
  FMemRealHeader := HeapAlloc(
    GetProcessHeap(),
    $8,
    FRealBlockCount * SizeOf(TMemNode));

  if FMemRealHeader = nil then
    raise EMemPool.CreateFmt('分配内存管理节点表错误，错误代码为：%d', [GetLastError()]);

  BuilderMemoryList;
  InitializeCriticalSection(FMemLock);
end;

destructor TMemPool.Destroy;
begin

  DisposeMemItem;

  if FMemRealHeader <> nil then
    HeapFree(GetProcessHeap(), 0, FMemRealHeader);

  if FMemory <> nil then
    HeapFree(GetProcessHeap(), 0, FMemory);

  DeleteCriticalSection(FMemLock);
  inherited Destroy;
end;

procedure TMemPool.DisposeMemItem;
var
  i: Integer;
begin
  if not Assigned(FOnDestroyEvent) then
    Exit;
  FPollMemNode := FMemLocalHeader;
  for i := 0 to FInUseBlock - 1 do
  begin
    FOnDestroyEvent(Integer(FPollMemNode), FPollMemNode.MemBuffer);
    FPollMemNode := FPollMemNode.NextNode;
  end;
end;

procedure TMemPool.FirstMemory;
begin
  FPollMemNode := FMemLocalHeader;
end;

function TMemPool.FreeMemory(const MemID: UINT): Boolean;
var
  PTRFreeNode: PMemNode;
begin
  Result := False;
  if not IsRightKey(MemID) then
  begin
{$IFDEF SHDEBUG}
    SendMessage(hDebug, LB_ADDSTRING, 0, Integer(Format('Error MemoryAddr !!! MemID:%d LowAddr:%d HighAddr:%d InUseBlock:%d', [MemID, FMinPosition, FMaxPosition, FInUseBlock])));
{$ENDIF}
    Exit;
  end;

  PTRFreeNode := PMemNode(MemID);

  if PTRFreeNode.InUse then
  begin
    if PTRFreeNode.PriorNode <> nil then
      PTRFreeNode.PriorNode.NextNode := PTRFreeNode.NextNode
    else
    begin
      //重新设置头节点
      if FInUseBlock > 1 then
        FMemLocalHeader := PTRFreeNode.NextNode
      else
        FMemLocalHeader := nil;
    end;

    PTRFreeNode.NextNode.PriorNode := PTRFreeNode.PriorNode;

    PTRFreeNode.NextNode := nil;
    PTRFreeNode.PriorNode := FTailMemNode;
    FTailMemNode.NextNode := PTRFreeNode;
    FTailMemNode := PTRFreeNode;
    //开始修改节点表
    InterlockedDecrement(FInUseBlock);
    InterlockedExchange(Integer(PTRFreeNode.InUse), Integer(False));
    Result := True;
  end;
end;

function TMemPool.GetFreeBlock: Integer;
begin
  Result := FBlockCount - FInUseBlock;
end;

function TMemPool.GetMemory(var MemID: UINT): Pointer;
var
  PTRFreeNode: PMemNode;
begin
  Result := nil;
  MemID := 0;
  if FInUseBlock >= FBlockCount then
    Exit;
  PTRFreeNode := FFreeMemNode;
  PTRFreeNode.InUse := True;
  Result := PTRFreeNode.MemBuffer;
  MemID := UINT(PTRFreeNode);
  if FMemLocalHeader = nil then
    FMemLocalHeader := PTRFreeNode;
  FFreeMemNode := FFreeMemNode.NextNode;
  InterlockedIncrement(FInUseBlock);
end;

function TMemPool.IsEnd: Boolean;
begin
  if (FPollMemNode = nil) or (not FPollMemNode.InUse) then
    Result := True
  else
    Result := False;
end;

function TMemPool.IsRightKey(KeyID: Integer): Boolean;
begin
  Result := False;
  if (KeyID >= FMinPosition) and (KeyID <= FMaxPosition) then
  begin
    if (KeyID - FMinPosition) mod SizeOf(TMemNode) = 0 then
      Result := True;
  end;
end;

procedure TMemPool.LockMemPool;
begin
  EnterCriticalSection(FMemLock);
end;

function TMemPool.MemoryIDItem: PMemNode;
begin
  Result := FPollMemNode;
end;

function TMemPool.MemoryItem: PAnsiChar;
begin
  Result := FPollMemNode.MemBuffer;
end;

procedure TMemPool.NextMemory;
begin
  if FPollMemNode <> nil then
    FPollMemNode := FPollMemNode.NextNode
  else
    FPollMemNode := nil;
end;

procedure TMemPool.UnLockMemPool;
begin
  LeaveCriticalSection(FMemLock);
end;

end.
