unit SimpleClass;

interface

uses
  SysUtils, FixedMemoryPool;

const
  DEFAULT_LIST_SIZE         = 128; //默认分配的节点个数

type
  size_type = Cardinal;
  ssize_t = Cardinal;
  size_t = Integer;
  T = Pointer;
  BOOL = LongBool;

type
  EQueue = class(Exception);

  PQueueNode = ^_QueueNode;
  _QueueNode = record
    Data: T;
    Def: size_t;
    NextNode,
      PrevNode: PQueueNode;
  end;
  TQueueNode = _QueueNode;

  TOnFreeEvent = procedure(Sender: TObject; Data: T) of object;
  //队列类
  TQueue = class
  private
    //头尾指针
    FRealHeader: PQueueNode;
    FHeader,
      FTail: PQueueNode;
    FInUseSize: size_t;
    FMaxSize: size_t;
    FOnFreeEvent: TOnFreeEvent;
    function GetItem(Index: size_t): T;
    function GetIfIsEmpty: Boolean;
  public
    property InUseSize: size_t read FInUseSize;
    property MaxSize: size_t read FMaxSize;
    property IsEmpty: Boolean read GetIfIsEmpty;
    property Item[Index: size_t]: T read GetItem; default;
    property OnFreeEvent: TOnFreeEvent read FOnFreeEvent write FOnFreeEvent;
    //
    function Push(Data: T): Boolean;
    function Peek: T;
    function Pop: T;
    function Last: T;
    //
    constructor Create(MaxSize: size_t); virtual;
    destructor Destroy; override;
  end;

  //========================
  //栈类
  //========================
  EStack = class(Exception);

  PStackNode = ^_tagStackNode;
  _tagStackNode = record
    Data: T;
  end;
  TStackNode = _tagStackNode;

  TStack = class
  private
    FMaxSize: size_t;
    FInUseSize: size_t;
    FHeader,
      PUseNode: PStackNode;
    function GetItem(Index: size_t): T;
    function GetIfIsEmpty: Boolean;
  public
    property InUseSize: size_t read FInUseSize;
    property MaxSize: size_t read FMaxSize;
    property IsEmpty: Boolean read GetIfIsEmpty;
    property Item[Index: size_t]: T read GetItem;

    //
    function Push(Data: T): Boolean;
    function Peek: T;
    function Pop: T;
    function Last: T;
    //
    constructor Create(MaxSize: size_t); virtual;
    destructor Destroy; override;
  end;

  //const
  //  DEFAULT_ALLOC_COUNT                   = 64;
  //
  //  DEFAULT_REALLOC_COUNT                 = 32;
  //
  //  MAX_ALLOC_SIZE                        = 64;

type
  Iterator = ^_tagIterator;
  _tagIterator = record
    Value: T;
    Next: Iterator;
    Prior: Iterator;
    Def: size_t;
  end;
  TIterator = _tagIterator;

  PIterator = Iterator;

  EList = class(Exception);

  TList = class
  private
    function GetSize: size_type;
  protected
    FEnd: Iterator;
    FBegin: Iterator;
    FMax_size: size_type;

    FMemManager: TFixedMemoryPool; //内存管理器

    function GetEmpty: Boolean;

  public
    property max_size: size_type read FMax_size;
    property size: size_type read GetSize;
    property empty: Boolean read GetEmpty;

    property Ibegin: Iterator read FBegin;
    property Iend: Iterator read FEnd;

    property Irbegin: Iterator read FEnd;
    property Irend: Iterator read FBegin;

    function push_front(const Value: T): Iterator;
    function push_back(const Value: T): Iterator;

    function find(const Value: T): Iterator;

    function insert(Position: Iterator; const Value: T): Iterator; overload;

    function insert(Position: Iterator; const first, Last: Iterator): Boolean; overload;

    function erase(Position: Iterator): Boolean;
    procedure Clear;

    procedure assignN(const first, Last: Iterator);
    procedure assign(List: TList);

    constructor Create(DefaultSize: size_type = DEFAULT_LIST_SIZE);

    destructor Destroy; override;
  end;

const
  MaxListSize               = Maxint div 16;

type
  PTList = ^TTList;
  TTList = array[0..MaxListSize - 1] of T;
  TListSortCompare = function(Item1, Item2: T): size_t;
  TListNotification = (lnAdded, lnExtracted, lnerased);

  TListAssignOp = (laCopy, laAnd, laOr, laXor, laSrcUnique, laDestUnique);

type
  EVectorError = class(Exception);

  TVector = class(TObject)
  private
    FList: PTList;
    FCount: size_type;
    FCapacity: size_type;
  protected
    function Get(Index: size_t): T;
    procedure Grow;
    procedure Put(Index: size_t; Item: T);
    procedure SetCapacity(NewCapacity: size_type);
    procedure SetCount(NewCount: size_type);
  public
    constructor Create(DefaultSize: size_type = DEFAULT_LIST_SIZE);

    destructor Destroy; override;

    function push_back(Value: T): size_type;

    procedure Clear;
    procedure erase(Index: size_t);

    class procedure Error(const Msg: string; Data: size_t); overload; virtual;
    class procedure Error(Msg: PResStringRec; Data: size_t); overload;
    procedure Exchange(Index1, Index2: size_t);
    function Expand: TVector;
    function Extract(Item: T): T;

    function Ibegin: T;
    function Iend: T;

    function IndexOf(Item: T): size_t;
    procedure insert(Index: size_t; Item: T);

    procedure Move(CurIndex, NewIndex: size_t);
    function Remove(Item: T): size_t;
    procedure Pack;
    procedure Sort(Compare: TListSortCompare);
    procedure assign(ListA: TVector; AOperator: TListAssignOp = laCopy; ListB: TVector = nil);
    property Capacity: size_type read FCapacity write SetCapacity;
    property Count: size_type read FCount write SetCount;
    property Items[Index: size_t]: T read Get write Put; default;
    property List: PTList read FList;
  end;

type
  EStrToInt = class(Exception);

function StrToIntEx(const str: PChar; Len: Integer): Integer; overload;
function StrToIntEx(const str: PChar): Integer; overload;

function IntToStrEx(Value: Integer; const Buf: PChar): PChar;
function IntToStrLEx(Value: Integer; const Buf: PChar): Integer;

implementation

const
  LookupIntArray            : array[1..10] of Integer = (
    1,
    10,
    100,
    1000,
    10000,
    100000,
    1000000,
    10000000,
    100000000,
    1000000000);

  ECFStrLenOut              = '%d长度超过限制:%d';
  ECFNotIntChar             = '出现非整数字符:%s';

function StrToIntEx(const str: PChar; Len: Integer): Integer; overload;
var
  i                         : Integer;
  PBin                      : PByte;
  bNegative                 : Boolean;
begin
  PBin := PByte(str);

  Result := 0;

  if Len > 10 then
    raise EStrToInt.CreateFmt(ECFStrLenOut, [Len, 10]);

  //如果是负数
  if PBin^ = 45 then
  begin
    Dec(Len);
    Inc(PBin);
    bNegative := True;
  end
  else
    bNegative := False;

  for i := Len downto 1 do
  begin
    if (PBin^ >= 48) and (PBin^ < 57) then
    begin
      Result := Result + (PBin^ - 48) * LookupIntArray[i];
      Inc(PBin);
    end
    else
    begin
      raise EStrToInt.CreateFmt(ECFNotIntChar, [PChar(PBin)^]);

    end;

  end;

  if bNegative then
    Result := -1 * Result;

end;

function StrToIntEx(const str: PChar): Integer; overload;
begin
  Result := StrToIntEx(str, StrLen(str));
end;

procedure CvtInt64;
{ IN:
    EAX:  Address of the int64 value to be converted to text
    ESI:  Ptr to the right-hand side of the output buffer:  LEA ESI, StrBuf[32]
    ECX:  Base for conversion: 0 for signed decimal, or 10 or 16 for unsigned
    EDX:  Precision: zero padded minimum field width
  OUT:
    ESI:  Ptr to start of converted text (not start of buffer)
    ECX:  Byte length of converted text
}
asm
        OR      CL, CL
        JNZ     @start             // CL = 0  => signed integer conversion
        MOV     ECX, 10
        TEST    [EAX + 4], $80000000
        JZ      @start
        PUSH    [EAX + 4]
        PUSH    [EAX]
        MOV     EAX, ESP
        NEG     [ESP]              // negate the value
        ADC     [ESP + 4],0
        NEG     [ESP + 4]
        CALL    @start             // perform unsigned conversion
        MOV     [ESI-1].Byte, '-'  // tack on the negative sign
        DEC     ESI
        INC     ECX
        ADD     ESP, 8
        RET

@start:   // perform unsigned conversion
        PUSH    ESI
        SUB     ESP, 4
        FNSTCW  [ESP+2].Word     // save
        FNSTCW  [ESP].Word       // scratch
        OR      [ESP].Word, $0F00  // trunc toward zero, full precision
        FLDCW   [ESP].Word

        MOV     [ESP].Word, CX
        FLD1
        TEST    [EAX + 4], $80000000 // test for negative
        JZ      @ld1                 // FPU doesn't understand unsigned ints
        PUSH    [EAX + 4]            // copy value before modifying
        PUSH    [EAX]
        AND     [ESP + 4], $7FFFFFFF // clear the sign bit
        PUSH    $7FFFFFFF
        PUSH    $FFFFFFFF
        FILD    [ESP + 8].QWord     // load value
        FILD    [ESP].QWord
        FADD    ST(0), ST(2)        // Add 1.  Produces unsigned $80000000 in ST(0)
        FADDP   ST(1), ST(0)        // Add $80000000 to value to replace the sign bit
        ADD     ESP, 16
        JMP     @ld2
@ld1:
        FILD    [EAX].QWord         // value
@ld2:
        FILD    [ESP].Word          // base
        FLD     ST(1)
@loop:
        DEC     ESI
        FPREM                       // accumulator mod base
        FISTP   [ESP].Word
        FDIV    ST(1), ST(0)        // accumulator := acumulator / base
        MOV     AL, [ESP].Byte      // overlap long FPU division op with int ops
        ADD     AL, '0'
        CMP     AL, '0'+10
        JB      @store
        ADD     AL, ('A'-'0')-10
@store:
        MOV     [ESI].Byte, AL
        FLD     ST(1)           // copy accumulator
        FCOM    ST(3)           // if accumulator >= 1.0 then loop
        FSTSW   AX
        SAHF
        JAE @loop

        FLDCW   [ESP+2].Word
        ADD     ESP,4

        FFREE   ST(3)
        FFREE   ST(2)
        FFREE   ST(1);
        FFREE   ST(0);

        POP     ECX             // original ESI
        SUB     ECX, ESI        // ECX = length of converted string
        SUB     EDX,ECX
        JBE     @done           // output longer than field width = no pad
        SUB     ESI,EDX
        MOV     AL,'0'
        ADD     ECX,EDX
        JMP     @z
@zloop: MOV     [ESI+EDX].Byte,AL
@z:     DEC     EDX
        JNZ     @zloop
        MOV     [ESI].Byte,AL
@done:
end;

procedure CvtInt;
{ IN:
    EAX:  The integer value to be converted to text
    ESI:  Ptr to the right-hand side of the output buffer:  LEA ESI, StrBuf[16]
    ECX:  Base for conversion: 0 for signed decimal, 10 or 16 for unsigned
    EDX:  Precision: zero padded minimum field width
  OUT:
    ESI:  Ptr to start of converted text (not start of buffer)
    ECX:  Length of converted text
}
asm
        OR      CL,CL
        JNZ     @CvtLoop
@C1:    OR      EAX,EAX
        JNS     @C2
        NEG     EAX
        CALL    @C2
        MOV     AL,'-'
        INC     ECX
        DEC     ESI
        MOV     [ESI],AL
        RET
@C2:    MOV     ECX,10

@CvtLoop:
        PUSH    EDX
        PUSH    ESI
@D1:    XOR     EDX,EDX
        DIV     ECX
        DEC     ESI
        ADD     DL,'0'
        CMP     DL,'0'+10
        JB      @D2
        ADD     DL,('A'-'0')-10
@D2:    MOV     [ESI],DL
        OR      EAX,EAX
        JNE     @D1
        POP     ECX
        POP     EDX
        SUB     ECX,ESI
        SUB     EDX,ECX
        JBE     @D5
        ADD     ECX,EDX
        MOV     AL,'0'
        SUB     ESI,EDX
        JMP     @z
@zloop: MOV     [ESI+EDX],AL
@z:     DEC     EDX
        JNZ     @zloop
        MOV     [ESI],AL
@D5:
end;

//Buf长度一定要大于32

function Int64ToStrEx(Value: Int64; const Buf: PChar): PChar;
asm
        PUSH    ESI
        MOV     ESI, EDX
        XOR     ECX, ECX       // base 10 signed
        PUSH    EAX            // result ptr
        XOR     EDX, EDX       // zero filled field width: 0 for no leading zeros
        LEA     EAX, Value
        CALL    CvtInt64

        MOV     EDX, ESI
        POP     EAX            // result ptr
        POP     ESI
end;

function IntToStrEx(Value: Integer; const Buf: PChar): PChar;
begin
  Result := nil;
end;

function IntToStrLEx(Value: Integer; const Buf: PChar): Integer;
begin
  Result := 0;
end;

{ TQueue }

constructor TQueue.Create(MaxSize: size_t);

  procedure BuilderQueue;
  var
    i                       : size_t;
    PTemp                   : PQueueNode;
  begin
    FHeader := FRealHeader;
    PTemp := FRealHeader;

    for i := 0 to FMaxSize - 1 do
    begin
      Inc(PTemp);
      FHeader.NextNode := PTemp;
      PTemp.PrevNode := FHeader;
      FHeader := PTemp;
    end;

    PTemp.NextNode := FRealHeader;
    FRealHeader.PrevNode := PTemp;

    //设置头尾指针
    FHeader := FRealHeader;
    FTail := FHeader.NextNode;
  end;

begin
  FMaxSize := MaxSize;
  FInUseSize := 0;
  GetMem(FRealHeader, SizeOf(TQueueNode) * (FMaxSize + 1));
  BuilderQueue;
end;

destructor TQueue.Destroy;
begin
  if Assigned(FOnFreeEvent) then
  begin
    while FHeader <> FTail do
      FOnFreeEvent(self, Pop);
  end;

  FreeMem(FRealHeader);
  inherited Destroy;
end;

function TQueue.GetIfIsEmpty: Boolean;
begin
  Result := FInUseSize = 0;
end;

function TQueue.GetItem(Index: size_t): T;
var
  i                         : size_t;
  PTemp                     : PQueueNode;
begin
  if (Index < FInUseSize) and (Index >= 0) then
  begin
    PTemp := FTail;
    for i := 0 to Index - 1 do
    begin
      PTemp := PTemp.NextNode;
    end;
    Result := PTemp.Data;
  end
  else
    Result := nil;
end;

function TQueue.Last: T;
begin
  Result := FTail;
end;

function TQueue.Peek: T;
begin
  Result := FHeader;
end;

function TQueue.Pop: T;
begin
  if FInUseSize > 0 then
  begin
    Result := FTail.Data;
    FTail := FTail.NextNode;
    Dec(FInUseSize);
  end
  else
    Result := nil;
end;

function TQueue.Push(Data: T): Boolean;
begin
  if FInUseSize < FMaxSize then
  begin
    FHeader.NextNode.Data := Data;
    FHeader := FHeader.NextNode;
    Result := True;
    Inc(FInUseSize);
  end
  else
    Result := False;
end;

{ TStack }

constructor TStack.Create(MaxSize: size_t);
begin
  FMaxSize := MaxSize;

  //预先分配一快内存作为间隔结点
  GetMem(FHeader, (FMaxSize + 1) * SizeOf(TStackNode));
  FInUseSize := 0;
  PUseNode := FHeader;
end;

destructor TStack.Destroy;
begin
  FreeMem(FHeader);
  inherited Destroy;
end;

function TStack.GetIfIsEmpty: Boolean;
begin
  Result := FInUseSize = 0;
end;

function TStack.GetItem(Index: size_t): T;
var
  PTemp                     : PStackNode;
begin
  Result := nil;
  if (Index < FInUseSize) and (Index >= 0) then
  begin
    PTemp := FHeader;
    Inc(PTemp, Index);
    Result := PTemp.Data;
  end;

end;

function TStack.Last: T;
begin
  if FInUseSize <> 0 then
    Result := FHeader.Data
  else
    Result := nil;
end;

function TStack.Peek: T;
begin
  Result := PUseNode.Data;
end;

function TStack.Pop: T;
begin
  if FInUseSize > 0 then
  begin
    Result := PUseNode.Data;
    Dec(PUseNode);
    Dec(FInUseSize);
  end
  else
    Result := nil;
end;

function TStack.Push(Data: T): Boolean;
begin
  if FInUseSize >= FMaxSize then
    Result := False
  else
  begin
    Inc(PUseNode);
    PUseNode.Data := Data;
    Inc(FInUseSize);
    Result := True;
  end;
end;

{ TList }

procedure TList.assign(List: TList);
var
  AddIterator               : Iterator;
begin
  if FMemManager.InUseBlock <> 0 then
    FMemManager.ClearMemPool;

  AddIterator := List.FBegin;

  while AddIterator <> List.FEnd do
  begin
    push_back(AddIterator.Value);
    AddIterator := AddIterator.Next;
  end;

end;

procedure TList.assignN(const first, Last: Iterator);
var
  AddIterator               : Iterator;
begin

  if FMemManager.InUseBlock <> 0 then
    FMemManager.ClearMemPool;

  AddIterator := first;

  while AddIterator <> Last do
  begin
    push_back(AddIterator.Value);
    AddIterator := AddIterator.Next;
  end;

end;

procedure TList.Clear;
begin
  FMemManager.ClearMemPool;
  FBegin := nil;
  FEnd := nil;
end;

constructor TList.Create(DefaultSize: size_type);
begin
  FMemManager := TFixedMemoryPool.Create(SizeOf(TIterator), DefaultSize);

  //其实可以不用设置这些值
  FBegin := nil;
  FEnd := nil;

  FMax_size := DefaultSize;

end;

destructor TList.Destroy;
begin
  FMemManager.Free;

  inherited Destroy;
end;

function TList.erase(Position: Iterator): Boolean;
begin

  Result := FMemManager.FreeMemory(Position);

  if (Result) and (Position <> FEnd) then
  begin
    Position.Next.Prior := Position.Prior;

    if Position.Prior <> nil then
      Position.Prior.Next := Position.Next
    else
    begin
      FBegin := Position.Next;
    end;

  end
  else
    Result := False;

end;

function TList.find(const Value: T): Iterator;
var
  PTRFind                   : Iterator;
begin
  Result := nil;

  FMemManager.FirstMemory;
  while not FMemManager.IsEnd do
  begin
    PTRFind := Iterator(FMemManager.MemoryItem);
    if PTRFind.Value = Value then
    begin
      Result := PTRFind;
      break;
    end;
    FMemManager.NextMemory();
  end;

end;

function TList.GetEmpty: Boolean;
begin
  Result := GetSize = 0;
end;

function TList.GetSize: size_type;
begin
  if FMemManager.InUseBlock > 0 then
    Result := size_type(FMemManager.InUseBlock - 1) //这个是为了减去FEnd分配的节点
  else
    Result := 0;

end;

function TList.insert(Position: Iterator; const first, Last: Iterator): Boolean;
var
  PTRInsert                 : Iterator;
begin
  PTRInsert := first;
  Result := False;

  try
    while PTRInsert <> Last do
    begin
      Position := insert(Position, PTRInsert.Value);
      if Position <> nil then
        PTRInsert := PTRInsert.Next
      else
        Exit;
    end;
    Result := True;
  except
  end;

end;

function TList.insert(Position: Iterator; const Value: T): Iterator;
var
  dwID                      : Cardinal;
begin

  if Position <> FBegin then
  begin

    if Position = FEnd then
    begin
      Result := nil;
      Exit;
    end;

    Result := FMemManager.GetMemory(dwID);

    if Result <> nil then
    begin
      Result.Next := Position.Next;
      Result.Prior := Position;

      Position.Next.Prior := Result;
      Position.Next := Result;
      Result.Value := Value;
    end;

  end
  else
  begin
    Result := push_back(Value);
  end;

end;

function TList.push_back(const Value: T): Iterator;
var
  dwID                      : Cardinal;
begin
  Result := FMemManager.GetMemory(dwID);

  if Result <> nil then
  begin

    Result.Value := Value;

    if FEnd <> nil then
    begin
      Result.Prior := FEnd.Prior;
      FEnd.Prior.Next := Result;
    end
    else
    begin
      FEnd := FMemManager.GetMemory(dwID); //初始化最后一个接点
      FEnd.Next := nil;
      FEnd.Value := nil;
      Result.Prior := nil;
      FBegin := Result;
    end;

    FEnd.Prior := Result;
    Result.Next := FEnd;

  end;

end;

function TList.push_front(const Value: T): Iterator;
var
  WID                       : Cardinal;
begin

  Result := FMemManager.GetMemory(WID);

  if Result <> nil then
  begin

    Result.Value := Value;

    if FBegin <> nil then
    begin
      Result.Prior := FBegin.Prior;
      Result.Next := FBegin;
      FBegin.Prior := Result;
    end
    else
    begin
      FEnd := FMemManager.GetMemory(WID); //初始化最后一个接点
      FEnd.Next := nil;
      FEnd.Value := nil;
      FEnd.Prior := Result;
      Result.Prior := nil;

    end;

    FBegin := Result;

  end;

end;

{ TVector }

resourcestring
  SVectorCapacityError      = 'Vector capacity out of bounds (%d)';
  SVectorCountError         = 'Vector count out of bounds (%d)';
  SVectorIndexError         = 'Vector index out of bounds (%d)';

destructor TVector.Destroy;
begin
  Clear;
end;

function TVector.push_back(Value: T): size_type;
begin
  Result := FCount;
  if Result = FCapacity then
    Grow;
  FList^[Result] := Value;
  Inc(FCount);
end;

procedure TVector.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

procedure TVector.erase(Index: size_t);
//var
//  Temp                                  : T;
begin
  if (Index < 0) or (size_type(Index) >= FCount) then
    Error(@SVectorIndexError, Index);

  //Temp := Items[Index];
  Dec(FCount);
  if Index < size_t(FCount) then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - size_type(Index)) * SizeOf(T));
end;

class procedure TVector.Error(const Msg: string; Data: size_t);

  function ReturnAddr: T;
  asm
          MOV     EAX,[EBP+4]
  end;

begin
  raise EVectorError.CreateFmt(Msg, [Data])at ReturnAddr;
end;

class procedure TVector.Error(Msg: PResStringRec; Data: size_t);
begin
  TVector.Error(LoadResString(Msg), Data);
end;

procedure TVector.Exchange(Index1, Index2: size_t);
var
  Item                      : T;
begin
  if (Index1 < 0) or (size_type(Index1) >= FCount) then
    Error(@SVectorIndexError, Index1);
  if (Index2 < 0) or (size_type(Index2) >= FCount) then
    Error(@SVectorIndexError, Index2);
  Item := FList^[Index1];
  FList^[Index1] := FList^[Index2];
  FList^[Index2] := Item;
end;

function TVector.Expand: TVector;
begin
  if FCount = FCapacity then
    Grow;
  Result := self;
end;

function TVector.Ibegin: T;
begin
  Result := Get(0);
end;

function TVector.Get(Index: size_t): T;
begin
  if (Index < 0) or (Index >= size_t(FCount)) then
    Error(@SVectorIndexError, Index);
  Result := FList^[Index];
end;

procedure TVector.Grow;
var
  Delta                     : size_type;
begin
  if FCapacity > 64 then
    Delta := FCapacity div 4
  else if FCapacity > 8 then
    Delta := 16
  else
    Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TVector.IndexOf(Item: T): size_t;
begin
  Result := 0;
  while (Result < size_t(FCount)) and (FList^[Result] <> Item) do
    Inc(Result);
  if Result = size_t(FCount) then
    Result := -1;
end;

procedure TVector.insert(Index: size_t; Item: T);
begin
  if (Index < 0) or (Index > size_t(FCount)) then
    Error(@SVectorIndexError, Index);
  if FCount = FCapacity then
    Grow;
  if Index < size_t(FCount) then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - size_type(Index)) * SizeOf(T));
  FList^[Index] := Item;
  Inc(FCount);
end;

function TVector.Iend: T;
begin
  Result := Get(FCount - 1);
end;

procedure TVector.Move(CurIndex, NewIndex: size_t);
var
  Item                      : T;
begin
  if CurIndex <> NewIndex then
  begin
    if (NewIndex < 0) or (NewIndex >= size_t(FCount)) then
      Error(@SVectorIndexError, NewIndex);
    Item := Get(CurIndex);
    FList^[CurIndex] := nil;
    erase(CurIndex);
    insert(NewIndex, nil);
    FList^[NewIndex] := Item;
  end;
end;

procedure TVector.Put(Index: size_t; Item: T);
//var
//  Temp                                  : T;
begin
  if (Index < 0) or (Index >= size_t(FCount)) then
    Error(@SVectorIndexError, Index);
  if Item <> FList^[Index] then
  begin
    //Temp := FList^[Index];
    FList^[Index] := Item;
    //    if Temp <> nil then
    //      Notify(Temp, lnerased);
    //    if Item <> nil then
    //      Notify(Item, lnAdded);
  end;
end;

function TVector.Remove(Item: T): size_t;
begin
  Result := IndexOf(Item);
  if Result >= 0 then
    erase(Result);
end;

procedure TVector.Pack;
var
  i                         : size_t;
begin
  for i := FCount - 1 downto 0 do
    if Items[i] = nil then
      erase(i);
end;

procedure TVector.SetCapacity(NewCapacity: size_type);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
    Error(@SVectorCapacityError, NewCapacity);
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FList, NewCapacity * SizeOf(T));
    FCapacity := NewCapacity;
  end;
end;

procedure TVector.SetCount(NewCount: size_type);
var
  i                         : size_type;
begin
  if NewCount > MaxListSize then
    Error(@SVectorCountError, NewCount);

  if NewCount > FCapacity then
    SetCapacity(NewCount);

  if NewCount > FCount then
    FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(T), 0)
  else
    for i := FCount - 1 downto NewCount do
      erase(i);

  FCount := NewCount;
end;

procedure QuickSort(SortList: PTList; l, R: size_t;
  SCompare: TListSortCompare);
var
  i, J                      : size_t;
  P, T                      : Pointer;
begin
  repeat
    i := l;
    J := R;
    P := SortList^[(l + R) shr 1];
    repeat
      while SCompare(SortList^[i], P) < 0 do
        Inc(i);
      while SCompare(SortList^[J], P) > 0 do
        Dec(J);
      if i <= J then
      begin
        T := SortList^[i];
        SortList^[i] := SortList^[J];
        SortList^[J] := T;
        Inc(i);
        Dec(J);
      end;
    until i > J;
    if l < J then
      QuickSort(SortList, l, J, SCompare);
    l := i;
  until i >= R;
end;

procedure TVector.Sort(Compare: TListSortCompare);
begin
  if (FList <> nil) and (Count > 0) then
    QuickSort(FList, 0, Count - 1, Compare);
end;

function TVector.Extract(Item: T): T;
var
  i                         : size_t;
begin
  Result := nil;
  i := IndexOf(Item);
  if i >= 0 then
  begin
    Result := Item;
    FList^[i] := nil;
    erase(i);
  end;
end;

procedure TVector.assign(ListA: TVector; AOperator: TListAssignOp; ListB: TVector);
var
  i                         : size_type;
  LTemp, LSource            : TVector;
begin
  // ListB given?
  if ListB <> nil then
  begin
    LSource := ListB;
    assign(ListA);
  end
  else
    LSource := ListA;

  // on with the show
  case AOperator of

    // 12345, 346 = 346 : only those in the new list
    laCopy:
      begin
        Clear;
        Capacity := LSource.Capacity;
        for i := 0 to LSource.Count - 1 do
          push_back(LSource[i]);
      end;

    // 12345, 346 = 34 : intersection of the two lists
    laAnd:
      for i := Count - 1 downto 0 do
        if LSource.IndexOf(Items[i]) = -1 then
          erase(i);

    // 12345, 346 = 123456 : union of the two lists
    laOr:
      for i := 0 to LSource.Count - 1 do
        if IndexOf(LSource[i]) = -1 then
          push_back(LSource[i]);

    // 12345, 346 = 1256 : only those not in both lists
    laXor:
      begin
        LTemp := TVector.Create(); // Temp holder of 4 byte values
        try
          LTemp.Capacity := LSource.Count;
          for i := 0 to LSource.Count - 1 do
            if IndexOf(LSource[i]) = -1 then
              LTemp.push_back(LSource[i]);
          for i := Count - 1 downto 0 do
            if LSource.IndexOf(Items[i]) <> -1 then
              erase(i);
          i := Count + LTemp.Count;
          if Capacity < i then
            Capacity := i;
          for i := 0 to LTemp.Count - 1 do
            push_back(LTemp[i]);
        finally
          LTemp.Free;
        end;
      end;

    // 12345, 346 = 125 : only those unique to source
    laSrcUnique:
      for i := Count - 1 downto 0 do
        if LSource.IndexOf(Items[i]) <> -1 then
          erase(i);

    // 12345, 346 = 6 : only those unique to dest
    laDestUnique:
      begin
        LTemp := TVector.Create;
        try
          LTemp.Capacity := LSource.Count;
          for i := LSource.Count - 1 downto 0 do
            if IndexOf(LSource[i]) = -1 then
              LTemp.push_back(LSource[i]);
          assign(LTemp);
        finally
          LTemp.Free;
        end;
      end;
  end;
end;

constructor TVector.Create(DefaultSize: size_type);
begin
  SetCapacity(DefaultSize);
end;

end.
