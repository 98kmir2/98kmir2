unit FixedMemoryPool;

interface

uses
  Windows, SysUtils;

const
  DEFAULT_MEMORY_COUNT = 1024; //ÿ���ڴ�����ڴ��ĸ���
  MAX_REALLOC_COUNT = 128; //������·����ڴ����

type
  PMemPos = ^_tagMemPos; //��¼�ڵ��
  _tagMemPos = record
    HPos: Integer;
    LPos: Integer;
    MaxIndex: Integer;
    MinIndex: Integer;
    HMPos: Integer;
    LMPos: Integer;
  end;
  TMemPos = _tagMemPos;

  PXMemItem = ^_tagMemItem;

  PXMemNode = ^_tagMemNode;
  _tagMemNode = record
    InUse: BOOL; //�Ƿ���ʹ��
    PriorNode: PXMemNode; //ǰһ���ڵ�ĵ�ַ
    NextNode: PXMemNode; //��һ���ڵ�ĵ�ַ
    MemItem: PXMemItem; //�ڴ��ַ
    Index: Integer;
  end;
  TXMemNode = _tagMemNode;

  _tagMemItem = record
    MemNode: PXMemNode;
    MemBuffer: PChar;
  end;
  TXMemItem = _tagMemItem;

  TFreeMemEvent = procedure(Sender: TObject; const MemBuffer: PAnsiChar) of object;

  EFixedMemoryPool = class(Exception);

  TFixedMemoryPool = class
  private
    FReAllocCount: Integer;
    FReAllocMemCount: Integer;
    FReMemPosArray: array[0..MAX_REALLOC_COUNT - 1] of TMemPos;
    FMemLock: TRTLCriticalSection;
    FOnDestroyEvent: TFreeMemEvent;
    FMemRealHeader: PXMemNode;
    FMemLocalHeader: PXMemNode;
    FTailMemNode: PXMemNode;
    FFreeMemNode: PXMemNode;
    FPollMemNode: PXMemNode;
    FMemory: PXMemItem;
    FBlockSize: Integer;
    FBlockCount: Integer;
    FInUseBlock: Integer;
    FMaxInUseBlock: Integer;
    function GetFreeBlock: Integer;
  protected
    function ReAllocMemory: Boolean;
    procedure BuilderMemoryList(BaseMemoryNode: PXMemNode; BaseMemory: PXMemItem; MemoryIndex: Integer; BaseBlockCount: Integer = DEFAULT_MEMORY_COUNT);
    procedure DisposeMemItem;
    procedure FreeAllMemory;
  public
    property MemoryIDHeader: PXMemNode read FMemRealHeader;
    property MemoryLocalHeader: PXMemNode read FMemLocalHeader;
    property MemoryBlockCount: Integer read FBlockCount;
    property MemoryBlockSize: Integer read FBlockSize;
    property InUseBlock: Integer read FInUseBlock;
    property MaxInUseBlock: Integer read FMaxInUseBlock;
    property FreeBlock: Integer read GetFreeBlock;
    property OnDestroyEvent: TFreeMemEvent read FOnDestroyEvent write FOnDestroyEvent;
    procedure LockMemPool;
    procedure UnLockMemPool;
    procedure FirstMemory;
    procedure NextMemory;
    function MemoryItem: PAnsiChar;
    function MemoryIDItem: PXMemNode;
    function IsEnd: Boolean;
    function GetMemory(var ID: DWORD): Pointer;
    function FreeMemory(const Memory: Pointer): Boolean;
    function GetMemoryFromID(ID: DWORD): Pointer;
    function IsUserMemory(const Memory: Pointer): PXMemItem;
    procedure ClearMemPool; //��ʼ���ڴ�أ��ò��������ؽ��ڴ���е�����
    {MemoryBlockSize�Ƿ���Ĺ̶���С���ڴ�Ĵ�С
     MemoryBlockCount�ǵ�һ�η���Ĺ̶���С���ڴ����Ŀ �Ժ�ÿ�������ڴ涼������ͬ����С���ڴ��}
    constructor Create(MemoryBlockSize: Integer; MemoryBlockCount: Integer = DEFAULT_MEMORY_COUNT);
    destructor Destroy; override;
  end;

implementation

uses LogManager;

const
  SPACE_MEM_BLOCK_COUNT = 16;

procedure TFixedMemoryPool.BuilderMemoryList(
  BaseMemoryNode: PXMemNode; //ͷ���ڴ�ڵ��
  BaseMemory: PXMemItem;
  MemoryIndex: Integer;
  BaseBlockCount: Integer = DEFAULT_MEMORY_COUNT); //�ڴ��
var
  i: Integer;
  PTRMemNode: PXMemNode;
  PTRMemory: PChar;
  FMemTempHeader: PXMemNode;
begin
  //�����ڴ��������
  FMemTempHeader := BaseMemoryNode;

  PTRMemNode := BaseMemoryNode;
  PTRMemNode.Index := MemoryIndex;
  PTRMemNode.PriorNode := nil;
  PTRMemNode.NextNode := PXMemNode(Integer(PTRMemNode) + SizeOf(TXMemNode));
  PTRMemNode.MemItem := BaseMemory;

  BaseMemory.MemNode := PTRMemNode;
  BaseMemory.MemBuffer := PChar(Integer(BaseMemory) + SizeOf(TXMemItem));

  PTRMemory := PChar(BaseMemory);

  Inc(PTRMemNode);
  Inc(PTRMemory, FBlockSize);

  for i := 0 to BaseBlockCount - 3 do
  begin
    PTRMemNode.PriorNode := FMemTempHeader;
    PTRMemNode.MemItem := PXMemItem(PTRMemory);
    PTRMemNode.Index := MemoryIndex + i + 1;
    PXMemItem(PTRMemory).MemNode := PTRMemNode;

    PXMemItem(PTRMemory).MemBuffer := PChar(Integer(PTRMemory) + SizeOf(TXMemItem));

    FMemTempHeader := PTRMemNode;
    Inc(PTRMemNode);
    Inc(PTRMemory, FBlockSize);

    FMemTempHeader.NextNode := PTRMemNode;
  end;

  PTRMemNode.PriorNode := FMemTempHeader;
  PTRMemNode.Index := FMemTempHeader.Index + 1;
  PTRMemNode.NextNode := nil;
  PTRMemNode.MemItem := PXMemItem(PTRMemory);

  PXMemItem(PTRMemory).MemNode := PTRMemNode;
  PXMemItem(PTRMemory).MemBuffer := PChar(Integer(PTRMemory) + SizeOf(TXMemItem));

  FTailMemNode := PTRMemNode;

  FReMemPosArray[FReAllocCount].LPos := Integer(BaseMemoryNode);
  FReMemPosArray[FReAllocCount].HPos := Integer(PTRMemNode);

  FReMemPosArray[FReAllocCount].MaxIndex := PTRMemNode.Index;
  FReMemPosArray[FReAllocCount].MinIndex := MemoryIndex;

  FReMemPosArray[FReAllocCount].LMPos := Integer(BaseMemory);
  FReMemPosArray[FReAllocCount].HMPos := Integer(PTRMemNode.MemItem);

  Inc(FReAllocCount);

end;

procedure TFixedMemoryPool.ClearMemPool;
var
  i: Integer;
  PTRClearNode: PXMemNode;
begin
  DisposeMemItem;

  for i := 0 to FReAllocCount - 1 do
  begin
    PTRClearNode := PXMemNode(FReMemPosArray[i].LPos);

    if i = 0 then
      BuilderMemoryList(
        PTRClearNode,
        PTRClearNode.MemItem,
        1,
        FReAllocMemCount + 1)
    else
      BuilderMemoryList(
        PTRClearNode,
        PTRClearNode.MemItem,
        FReMemPosArray[i - 1].MaxIndex + 1,
        FReAllocMemCount);

    //����ͷ�ڵ��ǰһ�ڵ�
    if i > 0 then
      PTRClearNode.PriorNode := PXMemNode(FReMemPosArray[i - 1].HPos);

    if i < FReAllocCount - 1 then
      //����β�ڵ�� ��һ�ڵ�
      PXMemNode(FReMemPosArray[i].HPos).NextNode := PXMemNode(FReMemPosArray[i + 1].LPos);

  end;

  FFreeMemNode := FMemRealHeader;
  FMemLocalHeader := nil;
  FInUseBlock := 0;
  FMaxInUseBlock := 0;
  FReAllocCount := 0;
end;

constructor TFixedMemoryPool.Create(MemoryBlockSize: Integer; MemoryBlockCount: Integer = DEFAULT_MEMORY_COUNT);
var
  FRealBlockCount: Integer;
begin
  //ÿ�����·����ڴ��С
  FReAllocMemCount := MemoryBlockCount;
  FReAllocCount := 0;
  FBlockCount := MemoryBlockCount;
  FBlockSize := MemoryBlockSize + SizeOf(TXMemItem);
  FRealBlockCount := FBlockCount + SPACE_MEM_BLOCK_COUNT;
  FMemory := HeapAlloc(GetProcessHeap(), $8, FRealBlockCount * FBlockSize);

  if FMemory = nil then
    raise EFixedMemoryPool.CreateFmt('�����ڴ滺����󣬴������Ϊ��%d', [GetLastError()]);

  //$8 is HEAP_ZERO_MEMORY	but delphi no define this value
  FMemRealHeader := HeapAlloc(GetProcessHeap(), $8, FRealBlockCount * SizeOf(TXMemNode));
  if FMemRealHeader = nil then
    raise EFixedMemoryPool.CreateFmt('�����ڴ����ڵ����󣬴������Ϊ��%d', [GetLastError()]);
  BuilderMemoryList(FMemRealHeader, FMemory, 1, FRealBlockCount);
  FFreeMemNode := FMemRealHeader;
  FMemLocalHeader := nil;
  FInUseBlock := 0;
  FMaxInUseBlock := 0;
  InitializeCriticalSection(FMemLock);
end;

destructor TFixedMemoryPool.Destroy;
begin

  DisposeMemItem;
  FreeAllMemory;
  DeleteCriticalSection(FMemLock);

  inherited Destroy;
end;

procedure TFixedMemoryPool.DisposeMemItem;
var
  i: Integer;
begin
  if not Assigned(FOnDestroyEvent) then
    Exit;
  FPollMemNode := FMemLocalHeader;
  for i := 0 to FInUseBlock - 1 do
  begin
    FOnDestroyEvent(self, FPollMemNode.MemItem.MemBuffer);
    FPollMemNode := FPollMemNode.NextNode;
  end;
end;

procedure TFixedMemoryPool.FirstMemory;
begin
  FPollMemNode := FMemLocalHeader;
end;

procedure TFixedMemoryPool.FreeAllMemory;
var
  i: Integer;
  PTRFreeNode: PXMemNode;
begin
  for i := 0 to FReAllocCount - 1 do
  begin
    PTRFreeNode := PXMemNode(FReMemPosArray[i].LPos);

    if PTRFreeNode.MemItem <> nil then
      HeapFree(GetProcessHeap(), 0, PTRFreeNode.MemItem);

    if PTRFreeNode <> nil then
      HeapFree(GetProcessHeap(), 0, PTRFreeNode);

  end;

end;

function TFixedMemoryPool.FreeMemory(const Memory: Pointer): Boolean;
var
  PTRFreeNode: PXMemNode;
  PTRFreeItem: PXMemItem;
begin
  Result := False;
  if FInUseBlock = 0 then
    Exit;
  PTRFreeItem := IsUserMemory(Memory);
  if PTRFreeItem <> nil then
  begin
    PTRFreeNode := PTRFreeItem.MemNode;
    if PTRFreeNode.InUse then
    begin
      if PTRFreeNode.PriorNode <> nil then
        PTRFreeNode.PriorNode.NextNode := PTRFreeNode.NextNode
      else
      begin
        //��������ͷ�ڵ�
        if FInUseBlock > 1 then
          FMemLocalHeader := PTRFreeNode.NextNode
        else
          FMemLocalHeader := nil;
      end;

      //�������ʼ����һ���ڵ���ڣ�PTRFreeNode.NextNode������Ϊnil
      PTRFreeNode.NextNode.PriorNode := PTRFreeNode.PriorNode;
      FTailMemNode.NextNode := PTRFreeNode;
      PTRFreeNode.PriorNode := FTailMemNode;
      PTRFreeNode.NextNode := nil;
      FTailMemNode := PTRFreeNode;
      //��ʼ�޸Ľڵ��
      //Dec(FInUseBlock);
      InterlockedDecrement(FInUseBlock);
      InterlockedExchange(Integer(PTRFreeNode.InUse), Integer(False));
      //PTRFreeNode.InUse := False;

      {if PTRFreeNode.MemItem <> nil then begin
        HeapFree(GetProcessHeap(), 0, PTRFreeNode.MemItem);
        MainOutMessage('PTRFreeNode.MemItem free');
      end;

      if PTRFreeNode <> nil then begin
        HeapFree(GetProcessHeap(), 0, PTRFreeNode);
        MainOutMessage('PTRFreeNode free');
      end;}

      Result := True;
    end;
  end;
end;

function TFixedMemoryPool.GetFreeBlock: Integer;
begin
  Result := FBlockCount - FInUseBlock;
end;

function TFixedMemoryPool.GetMemory(var ID: DWORD): Pointer;
var
  PTRFreeNode: PXMemNode;
begin
  Result := nil;
  ID := 0;
  if FInUseBlock >= FBlockCount then
  begin
    //���·����ڴ�
    if not ReAllocMemory then
      Exit;
  end;

  PTRFreeNode := FFreeMemNode;
  if FMemLocalHeader = nil then
    FMemLocalHeader := PTRFreeNode;

  FFreeMemNode := FFreeMemNode.NextNode;
  InterlockedExchange(Integer(PTRFreeNode.InUse), Integer(True));
  //PTRFreeNode.InUse := True;

  Result := PTRFreeNode.MemItem.MemBuffer;
  ID := PTRFreeNode.Index;
  //Inc(FInUseBlock);
  InterlockedIncrement(FInUseBlock);
  if FInUseBlock > FMaxInUseBlock then
    InterlockedExchange(FMaxInUseBlock, FInUseBlock);
    //FMaxInUseBlock := FInUseBlock;
end;

function TFixedMemoryPool.GetMemoryFromID(ID: DWORD): Pointer;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FReAllocCount - 1 do
  begin
    if Integer(ID) <= FReMemPosArray[i].MaxIndex then
    begin
      Result := Pointer(FReMemPosArray[i].LPos + (Integer(ID) - FReMemPosArray[i].MinIndex) * SizeOf(TXMemNode));
      break;
    end;
  end;
end;

function TFixedMemoryPool.IsEnd: Boolean;
begin
  //Ǳ�����⣺û�м��FPollMemNode����Ч�Ժͷ�Χ
  if (FPollMemNode = nil) or (not FPollMemNode.InUse) then
    Result := True
  else
    Result := False;

end;

function TFixedMemoryPool.IsUserMemory(const Memory: Pointer): PXMemItem;
var
  i, KeyID: Integer;
begin
  Result := nil;
  KeyID := Integer(Memory) - SizeOf(TXMemItem);
  for i := 0 to FReAllocCount - 1 do
  begin
    if (KeyID <= FReMemPosArray[i].HMPos) and (KeyID >= FReMemPosArray[i].LMPos) then
    begin
      if ((KeyID - FReMemPosArray[i].LMPos) mod FBlockSize) = 0 then
      begin
        Result := PXMemItem(KeyID);
        break;
      end;
    end;
  end;
end;

procedure TFixedMemoryPool.LockMemPool;
begin
  EnterCriticalSection(FMemLock);
end;

function TFixedMemoryPool.MemoryIDItem: PXMemNode;
begin
  Result := FPollMemNode;
end;

function TFixedMemoryPool.MemoryItem: PAnsiChar;
begin
  Result := FPollMemNode.MemItem.MemBuffer;
end;

procedure TFixedMemoryPool.NextMemory;
begin
  FPollMemNode := FPollMemNode.NextNode;
end;

function TFixedMemoryPool.ReAllocMemory: Boolean;
var
  FReMemory: PXMemItem;
  FReHeader, FOrdTail: PXMemNode;
begin
  Result := False;

  if FReAllocCount > MAX_REALLOC_COUNT then
    Exit;

  FOrdTail := FTailMemNode;

  //$8 is HEAP_ZERO_MEMORY	but delphi no define this value
  FReHeader := HeapAlloc(
    GetProcessHeap(),
    $8,
    FReAllocMemCount * SizeOf(TXMemNode));

  if FReHeader = nil then
    Exit;

  FReMemory := HeapAlloc(
    GetProcessHeap(),
    $8,
    FReAllocMemCount * FBlockSize);

  if FReMemory = nil then
    Exit;

  BuilderMemoryList(
    FReHeader,
    FReMemory,
    FReMemPosArray[FReAllocCount].MaxIndex + 1,
    FReAllocMemCount);

  //�ϲ���
  FReHeader.PriorNode := FOrdTail;
  FOrdTail.NextNode := FReHeader;
  Result := True;

  Inc(FBlockCount, FReAllocMemCount);

end;

procedure TFixedMemoryPool.UnLockMemPool;
begin
  LeaveCriticalSection(FMemLock);
end;

end.
