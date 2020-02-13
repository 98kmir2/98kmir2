unit JClasses;

interface
uses SysUtils;
const
  MaxListSize               = Maxint div 16;
type
  EListError = class(Exception);
  PPointerList = ^TPointerList;
  TPointerList = array[0..MaxListSize - 1] of Pointer;
  TListSortCompare = function(Item1, Item2: Pointer): Integer;
  TListNotification = (lnAdded, lnExtracted, lnDeleted);

  TListAssignOp = (laCopy, laAnd, laOr, laXor, laSrcUnique, laDestUnique);

  CList = class(TObject)
  private
    FList: PPointerList;
    FCount: Integer;
    FCapacity: Integer;
  protected
    function Get(Index: Integer): Pointer;
    procedure Grow; virtual;
    procedure Put(Index: Integer; item: Pointer);
    procedure Notify(Ptr: Pointer; Action: TListNotification); virtual;
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCount(NewCount: Integer);
  public
    destructor Destroy; override;
    function Add(item: Pointer): Integer;
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    class procedure Error(const Msg: string; Data: Integer); overload; virtual;
    class procedure Error(Msg: PResStringRec; Data: Integer); overload;
    procedure Exchange(Index1, Index2: Integer);
    function Expand: CList;
    function Extract(item: Pointer): Pointer;
    function First: Pointer;
    function IndexOf(item: Pointer): Integer;
    procedure Insert(Index: Integer; item: Pointer);
    function Last: Pointer;
    procedure Move(CurIndex, NewIndex: Integer);
    function Remove(item: Pointer): Integer;
    procedure Pack;
    procedure Sort(Compare: TListSortCompare);
    procedure Assign(ListA: CList; AOperator: TListAssignOp = laCopy; ListB:
      CList = nil);
    property Capacity: Integer read FCapacity write SetCapacity;
    property Count: Integer read FCount write SetCount;
    property Items[Index: Integer]: Pointer read Get write Put; default;
    property List: PPointerList read FList;
  end;

implementation
uses RTLConsts, SysConst, Types;
{ TList }

destructor CList.Destroy;
begin
  Clear;
end;

function CList.Add(item: Pointer): Integer;
begin
  Result := FCount;
  if Result = FCapacity then
    Grow;
  FList^[Result] := item;
  Inc(FCount);
  if item <> nil then
    Notify(item, lnAdded);
end;

procedure CList.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

procedure CList.Delete(Index: Integer);
var
  temp                      : Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(@SListIndexError, Index);
  temp := Items[Index];
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(Pointer));
  if temp <> nil then
    Notify(temp, lnDeleted);
end;

class procedure CList.Error(const Msg: string; Data: Integer);

  function ReturnAddr: Pointer;
  asm
          MOV     EAX,[EBP+4]
  end;

begin
  raise EListError.CreateFmt(Msg, [Data])at ReturnAddr;
end;

class procedure CList.Error(Msg: PResStringRec; Data: Integer);
begin
  CList.Error(LoadResString(Msg), Data);
end;

procedure CList.Exchange(Index1, Index2: Integer);
var
  item                      : Pointer;
begin
  if (Index1 < 0) or (Index1 >= FCount) then
    Error(@SListIndexError, Index1);
  if (Index2 < 0) or (Index2 >= FCount) then
    Error(@SListIndexError, Index2);
  item := FList^[Index1];
  FList^[Index1] := FList^[Index2];
  FList^[Index2] := item;
end;

function CList.Expand: CList;
begin
  if FCount = FCapacity then
    Grow;
  Result := self;
end;

function CList.First: Pointer;
begin
  Result := Get(0);
end;

function CList.Get(Index: Integer): Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(@SListIndexError, Index);
  Result := FList^[Index];
end;

procedure CList.Grow;
var
  Delta                     : Integer;
begin
  if FCapacity > 64 then
    Delta := FCapacity div 4
  else if FCapacity > 8 then
    Delta := 16
  else
    Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function CList.IndexOf(item: Pointer): Integer;
begin
  Result := 0;
  while (Result < FCount) and (FList^[Result] <> item) do
    Inc(Result);
  if Result = FCount then
    Result := -1;
end;

procedure CList.Insert(Index: Integer; item: Pointer);
begin
  if (Index < 0) or (Index > FCount) then
    Error(@SListIndexError, Index);
  if FCount = FCapacity then
    Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(Pointer));
  FList^[Index] := item;
  Inc(FCount);
  if item <> nil then
    Notify(item, lnAdded);
end;

function CList.Last: Pointer;
begin
  Result := Get(FCount - 1);
end;

procedure CList.Move(CurIndex, NewIndex: Integer);
var
  item                      : Pointer;
begin
  if CurIndex <> NewIndex then begin
    if (NewIndex < 0) or (NewIndex >= FCount) then
      Error(@SListIndexError, NewIndex);
    item := Get(CurIndex);
    FList^[CurIndex] := nil;
    Delete(CurIndex);
    Insert(NewIndex, nil);
    FList^[NewIndex] := item;
  end;
end;

procedure CList.Put(Index: Integer; item: Pointer);
var
  temp                      : Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(@SListIndexError, Index);
  if item <> FList^[Index] then begin
    temp := FList^[Index];
    FList^[Index] := item;
    if temp <> nil then
      Notify(temp, lnDeleted);
    if item <> nil then
      Notify(item, lnAdded);
  end;
end;

function CList.Remove(item: Pointer): Integer;
begin
  Result := IndexOf(item);
  if Result >= 0 then
    Delete(Result);
end;

procedure CList.Pack;
var
  i                         : Integer;
begin
  for i := FCount - 1 downto 0 do
    if Items[i] = nil then
      Delete(i);
end;

procedure CList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
    Error(@SListCapacityError, NewCapacity);
  if NewCapacity <> FCapacity then begin
    ReAllocMem(FList, NewCapacity * SizeOf(Pointer));
    FCapacity := NewCapacity;
  end;
end;

procedure CList.SetCount(NewCount: Integer);
var
  i                         : Integer;
begin
  if (NewCount < 0) or (NewCount > MaxListSize) then
    Error(@SListCountError, NewCount);
  if NewCount > FCapacity then
    SetCapacity(NewCount);
  if NewCount > FCount then
    FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0)
  else
    for i := FCount - 1 downto NewCount do
      Delete(i);
  FCount := NewCount;
end;

procedure QuickSort(SortList: PPointerList; l, r: Integer;
  SCompare: TListSortCompare);
var
  i, j                      : Integer;
  P, t                      : Pointer;
begin
  repeat
    i := l;
    j := r;
    P := SortList^[(l + r) shr 1];
    repeat
      while SCompare(SortList^[i], P) < 0 do
        Inc(i);
      while SCompare(SortList^[j], P) > 0 do
        Dec(j);
      if i <= j then begin
        t := SortList^[i];
        SortList^[i] := SortList^[j];
        SortList^[j] := t;
        Inc(i);
        Dec(j);
      end;
    until i > j;
    if l < j then
      QuickSort(SortList, l, j, SCompare);
    l := i;
  until i >= r;
end;

procedure CList.Sort(Compare: TListSortCompare);
begin
  if (FList <> nil) and (Count > 0) then
    QuickSort(FList, 0, Count - 1, Compare);
end;

function CList.Extract(item: Pointer): Pointer;
var
  i                         : Integer;
begin
  Result := nil;
  i := IndexOf(item);
  if i >= 0 then begin
    Result := item;
    FList^[i] := nil;
    Delete(i);
    Notify(Result, lnExtracted);
  end;
end;

procedure CList.Notify(Ptr: Pointer; Action: TListNotification);
begin
end;

procedure CList.Assign(ListA: CList; AOperator: TListAssignOp; ListB: CList);
var
  i                         : Integer;
  LTemp, LSource            : CList;
begin
  // ListB given?
  if ListB <> nil then begin
    LSource := ListB;
    Assign(ListA);
  end
  else
    LSource := ListA;

  // on with the show
  case AOperator of

    // 12345, 346 = 346 : only those in the new list
    laCopy: begin
        Clear;
        Capacity := LSource.Capacity;
        for i := 0 to LSource.Count - 1 do
          Add(LSource[i]);
      end;

    // 12345, 346 = 34 : intersection of the two lists
    laAnd:
      for i := Count - 1 downto 0 do
        if LSource.IndexOf(Items[i]) = -1 then
          Delete(i);

    // 12345, 346 = 123456 : union of the two lists
    laOr:
      for i := 0 to LSource.Count - 1 do
        if IndexOf(LSource[i]) = -1 then
          Add(LSource[i]);

    // 12345, 346 = 1256 : only those not in both lists
    laXor: begin
        LTemp := CList.Create; // Temp holder of 4 byte values
        try
          LTemp.Capacity := LSource.Count;
          for i := 0 to LSource.Count - 1 do
            if IndexOf(LSource[i]) = -1 then
              LTemp.Add(LSource[i]);
          for i := Count - 1 downto 0 do
            if LSource.IndexOf(Items[i]) <> -1 then
              Delete(i);
          i := Count + LTemp.Count;
          if Capacity < i then
            Capacity := i;
          for i := 0 to LTemp.Count - 1 do
            Add(LTemp[i]);
        finally
          LTemp.Free;
        end;
      end;

    // 12345, 346 = 125 : only those unique to source
    laSrcUnique:
      for i := Count - 1 downto 0 do
        if LSource.IndexOf(Items[i]) <> -1 then
          Delete(i);

    // 12345, 346 = 6 : only those unique to dest
    laDestUnique: begin
        LTemp := CList.Create;
        try
          LTemp.Capacity := LSource.Count;
          for i := LSource.Count - 1 downto 0 do
            if IndexOf(LSource[i]) = -1 then
              LTemp.Add(LSource[i]);
          Assign(LTemp);
        finally
          LTemp.Free;
        end;
      end;
  end;
end;
end.
