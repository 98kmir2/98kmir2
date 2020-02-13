unit IntHashMap;

interface

uses
  SysUtils, Windows, Classes;

const
  //最大的HASH表大小
  MAX_HASH_CHUNK_COUNT = 511;

  DEFAULT_NODE_COUNT = 60000;
  REALLOC_NODE_COUNT = 10000;

type
  TNodeManager = class;

  PIntHashKey = ^_tagIntHashKey;
  _tagIntHashKey = record
    Key: Cardinal;
    Ref: Integer;
  end;
  TIntHashKey = _tagIntHashKey;

  PPIntHashChunk = ^PIntHashChunk;
  PIntHashChunk = ^_tagIntHashChunk;
  _tagIntHashChunk = record
    NextChunk: PIntHashChunk;
    Key: Cardinal;
    Value: Integer;
  end;
  TIntHashChunk = _tagIntHashChunk;

  TTraverseHashItemEvent = procedure(
    const HashKey: Cardinal;
    const Value: Cardinal) of object;

  TIntHashMap = class
  private
    FHashRoot: array[0..MAX_HASH_CHUNK_COUNT - 1] of PIntHashChunk;
    FNodeManager: TNodeManager;
  protected
    function GetHashValue(const HashKey: TIntHashKey): DWORD;
  public
    property NodeManager: TNodeManager read FNodeManager;
    function Add(const HashKey: TIntHashKey; const Value: DWORD): Boolean;
    function Lookup(const HashKey: TIntHashKey; var Value: DWORD): Cardinal;

    function ExChange(const HashKey: TIntHashKey; const NewValue: DWORD): Cardinal; overload;
    function ExChange(const KeyIndex: Cardinal; const NewValue: DWORD): Cardinal; overload;

    function Delete(const HashKey: TIntHashKey): Boolean; overload;
    function Delete(const HashKey: TIntHashKey; const KeyIndex: Cardinal): boolean; overload;

    function LoadFromFile(const FileName: PChar): Boolean;
    procedure Traverse(TraverseHashEvent: TTraverseHashItemEvent);

    procedure Clear;

    //DefaultSize是初始化的NodeManager的节点
    constructor Create(DefaultSize: Cardinal = DEFAULT_NODE_COUNT);
    destructor Destroy; override;
  end;

  PHashTrack = ^_tagHashTrack;
  _tagHashTrack = record
    Key: DWORD;
    Value: DWORD;
  end;
  THashTrack = _tagHashTrack;

  THashTrackList = array[0..4095] of THashTrack;
  PHashTrackList = ^THashTrackList;

  TNodeManager = class
  private
    FList: TList;
    FCurrentChunk: PIntHashChunk;
    FCurrentCount: DWORD;
    FMaxCount: DWORD;
    FReAllocCount: DWORD;
    FFirstAllocCount: DWORD;

    FFreeList: TList;

    function GetCount: DWORD;
    function GetHashChunk(Index: Integer): TIntHashKey;
  public
    property HashChunk[Index: Integer]: TIntHashKey read GetHashChunk;
    property Count: DWORD read GetCount;
    function GetNode(): Pointer;
    procedure Clear;
    function DeleteNode(Node: Pointer): boolean;
    constructor Create(DefaultCount: Integer = DEFAULT_NODE_COUNT; ReAllocCount: Integer =
      DEFAULT_NODE_COUNT);

    destructor Destroy; override;
  end;

implementation

{ TNodeManager }

procedure TNodeManager.Clear;
begin
  FCurrentChunk := FList[0];
  FFreeList.Clear;
  FCurrentChunk := 0;
end;

constructor TNodeManager.Create(DefaultCount, ReAllocCount: Integer);

begin
  FList := TList.Create;
  FList.Capacity := 128;                //设置初始化大小

  FFreeList := TList.Create;
  FFreeList.Capacity := 3000;

  FCurrentChunk := AllocMem(DefaultCount * SizeOf(TIntHashChunk));
  FMaxCount := DefaultCount;
  FCurrentCount := 0;
  FReAllocCount := ReAllocCount;
  FFirstAllocCount := DefaultCount;

  FList.Add(FCurrentChunk);
end;

function TNodeManager.DeleteNode(Node: Pointer): boolean;
begin
  FFreeList.Add(Node);
  Result := True;
end;

destructor TNodeManager.Destroy;
var
  i                 : Integer;
  Memory            : Pointer;
begin
  for i := 0 to FList.Count - 1 do
  begin
    Memory := FList[i];
    FreeMem(Memory);
  end;

  FList.Free;
  inherited Destroy;
end;

function TNodeManager.GetCount: DWORD;
begin
  Result := DWORD(FFreeList.Count) + FCurrentCount;
end;

function TNodeManager.GetHashChunk(Index: Integer): TIntHashKey;
begin

end;

function TNodeManager.GetNode: Pointer;
begin

  if FFreeList.Count = 0 then
  begin
    if FCurrentCount < FMaxCount then
    begin
      Result := FCurrentChunk;
      Inc(FCurrentChunk);
    end
    else
    begin
      FCurrentChunk := AllocMem(FReAllocCount * SizeOf(TIntHashChunk));
      FList.Add(FCurrentChunk);
      Inc(FMaxCount, FReAllocCount);
      Result := FCurrentChunk;
    end;

    Inc(FCurrentCount);

  end
  else
  begin

    Result := FFreeList.Last;
    FFreeList.Delete(FFreeList.Count - 1);

  end;

end;

{ TIntHashMap }

function TIntHashMap.Add(const HashKey: TIntHashKey; const Value: DWORD): Boolean;
var
  NewChunk          : PIntHashChunk;
  Hash              : Cardinal;
begin
  Hash := HashKey.Key mod MAX_HASH_CHUNK_COUNT;

  try
    NewChunk := FNodeManager.GetNode;
    Result := True;
  except
    Result := False;
    Exit;
  end;

  NewChunk.Key := HashKey.Key;
  NewChunk.Value := Value;
  NewChunk.NextChunk := FHashRoot[Hash];
  FHashRoot[Hash] := NewChunk;

end;

procedure TIntHashMap.Clear;
begin
  FillChar(FHashRoot, sizeo(FHashRoot), 0);

end;

constructor TIntHashMap.Create(DefaultSize: Cardinal);
begin
  FNodeManager := TNodeManager.Create(DefaultSize);
end;

function TIntHashMap.Delete(const HashKey: TIntHashKey; const KeyIndex: Cardinal): boolean;
var
  PDeleteChunk      : PPIntHashChunk;
  DeleteChunk       : PIntHashChunk;
begin
  PDeleteChunk := PPIntHashChunk(KeyIndex);
  DeleteChunk := PDeleteChunk^;

  Result := False;

  if DeleteChunk <> nil then
  begin
    if FNodeManager.DeleteNode(DeleteChunk) then
    begin
      PDeleteChunk^ := DeleteChunk.NextChunk;
      Result := True;
    end;

  end;

end;

function TIntHashMap.Delete(const HashKey: TIntHashKey): Boolean;
var
  KeyIndex          : Cardinal;
  FindValue         : DWORD;
begin
  KeyIndex := Lookup(HashKey, FindValue);

  if KeyIndex <> 0 then
    Result := Delete(HashKey, KeyIndex)
  else
    Result := False;

end;

destructor TIntHashMap.Destroy;
begin
  FNodeManager.Free;
  inherited Destroy;
end;

function TIntHashMap.ExChange(const HashKey: TIntHashKey; const NewValue: DWORD): Cardinal;
var
  KeyIndex          : Cardinal;
  OldValue          : Cardinal;
begin
  KeyIndex := Lookup(HashKey, OldValue);
  if (KeyIndex <> 0) and (PPIntHashChunk(KeyIndex)^ <> nil) then
  begin
    PPIntHashChunk(KeyIndex)^.Value := NewValue;
    Result := OldValue;
  end
  else
    Result := 0;

end;

function TIntHashMap.ExChange(const KeyIndex: Cardinal; const NewValue: DWORD): Cardinal;
begin
  if (KeyIndex <> 0) and (PPIntHashChunk(KeyIndex)^ <> nil) then
  begin
    Result := PPIntHashChunk(KeyIndex)^.Value;
    PPIntHashChunk(KeyIndex)^.Value := NewValue;
  end
  else
    Result := 0;
end;

function TIntHashMap.GetHashValue(const HashKey: TIntHashKey): DWORD;
begin
  Result := HashKey.Key mod MAX_HASH_CHUNK_COUNT;
end;

function TIntHashMap.LoadFromFile(const FileName: PChar; PMemory: PChar; MemLen: DWORD): Boolean;
var
  hFile             : Integer;
  nLen, i           : DWORD;
  pTackList         : PHashTrackList;
  HashK             : TIntHashKey;
begin
  Result := False;

  hFile := _lopen(FileName, OF_READ or OF_SHARE_DENY_NONE);
  if hFile = HFILE_ERROR then
    Exit;

  try
    _llseek(hFile, 0, 0);

    nLen := _lread(hFile, PMemory, MemLen);
    if MemLen <= nLen then
      Exit;

    PMemory[MemLen] := #0;

  finally
    _lclose(hFile);
  end;

  nLen := nLen div sizeof(THashTrack);

  pTackList := PHashTrackList(PMemory);

  if nLen > 2000 then
    Exit;

  Clear;
  FNodeManager.Clear;

  for i := 0 to nLen - 1 do
  begin
    HashK.Key := pTrackList[i].Key;
    Add(HashK, pTrackList[i].Value);
  end;

  Result := True;

end;

function TIntHashMap.Lookup(const HashKey: TIntHashKey; var Value: DWORD): Cardinal;
var
  Hash              : Cardinal;
  PRootChunk        : PPIntHashChunk;
  RootChunk         : PIntHashChunk;
begin
  //最简单的HASH算法，由于物品ID没有任何规律，所以用这个算法速度快
  Hash := HashKey.Key mod MAX_HASH_CHUNK_COUNT;

  PRootChunk := @FHashRoot[Hash];

  while PRootChunk^ <> nil do
  begin
    RootChunk := PRootChunk^;
    if RootChunk.Key = HashKey.Key then
    begin
      Value := RootChunk.Value;
      Result := Cardinal(PRootChunk);
      Exit;
    end;

    PRootChunk := @RootChunk.NextChunk;
  end;

  Result := 0;
end;

procedure TIntHashMap.Traverse(TraverseHashEvent: TTraverseHashItemEvent);
var
  i                 : Integer;
  PRootChunk        : PPIntHashChunk;
  RootChunk         : PIntHashChunk;
begin
  for i := 0 to MAX_HASH_CHUNK_COUNT - 1 do
  begin
    PRootChunk := @FHashRoot[i];

    while PRootChunk^ <> nil do
    begin
      RootChunk := PRootChunk^;
      TraverseHashEvent(RootChunk.Key, RootChunk.Value);
      PRootChunk := @RootChunk.NextChunk;
    end;

  end;

end;

end.

