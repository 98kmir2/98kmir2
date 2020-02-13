unit NMS_Stream;

interface

uses
  WinTypes, Classes, SysUtils;

type
  TS_BufferState = (bsUnknown, bsRead, bsWrite);
  TS_BufferStream = class(TStream)
  private
    fStream: TStream;
    fBuffer: PChar;
    fBufPtr: PChar;
    fBufEnd: PChar;
    fBufSize: Cardinal;
    fState: TS_BufferState;
    fOnFillBuffer: TNotifyEvent;
    fOnFlushBuffer: TNotifyEvent;

    function GetBufPosition: Integer;

  protected
    function FillBuffer: Boolean; virtual;


    procedure PutBack(Ch: Char); virtual;
    procedure AfterFillBuffer; virtual;
    procedure AfterFlushBuffer; virtual;

    property Buffer: PChar read fBuffer;
    property BufPtr: PChar read fBufPtr;
    property BufSize: Cardinal read fBufSize;
    property BufEnd: PChar read fBufEnd;
    property BufPosition: Integer read GetBufPosition;
    property State: TS_BufferState read fState;
    property Stream: TStream read fStream;

  public
    constructor Create(Stream: TStream); virtual;
    destructor Destroy; override;
    function FlushBuffer: Boolean; virtual;
    function Read(var Buffer; Count: LongInt): LongInt; override;
    function Write(const Buffer; Count: LongInt): LongInt; override;
    function Seek(Offset: LongInt; Origin: Word): LongInt; override;
    function IsEof: Boolean;

    property OnFillBuffer: TNotifyEvent read fOnFillBuffer write fOnFillBuffer;
    property OnFlushBuffer: TNotifyEvent read fOnFlushBuffer write fOnFlushBuffer;
  end;

const
//  BufferSize: Integer = 8192;
//  BufferSize: Integer = 16384;
  BufferSize: Integer = 32768;
//  BufferSize: Integer = 65536;

implementation

uses
  WinProcs, NMS_Huge;

constructor TS_BufferStream.Create(Stream: TStream);
begin
  inherited Create;
  fStream := Stream;
  fBufSize := BufferSize;
  GetMem(fBuffer, BufSize);
  fBufEnd := Buffer + BufSize;
  fState := bsUnknown;
end;

destructor TS_BufferStream.Destroy;
begin
  if State = bsWrite then
    FlushBuffer;
  FreeMem(fBuffer, BufSize);
  inherited Destroy;
end;

function TS_BufferStream.FillBuffer: Boolean;
var
  NumBytes: Cardinal;
begin
  NumBytes := Stream.Read(Buffer^, BufSize);
  fBufPtr := Buffer;
  fBufEnd := Buffer + NumBytes;
  Result := NumBytes > 0;
  if Result then
    fState := bsRead
  else
    fState := bsUnknown;
  AfterFillBuffer;
end;

function TS_BufferStream.FlushBuffer: Boolean;
var
  NumBytes: Cardinal;
begin
  NumBytes := BufPtr - Buffer;
  Result := NumBytes = Stream.Write(Buffer^, NumBytes);
  fBufPtr := Buffer;
  fState := bsUnknown;
  AfterFlushBuffer;
end;

function TS_BufferStream.Read(var Buffer; Count: LongInt): LongInt;
var
  Ptr: PChar;
  NumBytes: Cardinal;
begin
  if State = bsWrite then
    FlushBuffer
  else if BufPtr = nil then
    fBufPtr := BufEnd;
  Ptr := @Buffer;
  Result := 0;
  while Count > 0 do
  begin
     if BufPtr = BufEnd then
      if not FillBuffer then
        Break;
    NumBytes := BufEnd - BufPtr;
    if Count < NumBytes then
      NumBytes := Count;

    HMemCpy(Ptr, BufPtr, NumBytes);

    Dec(Count, NumBytes);
    Inc(fBufPtr, NumBytes);
    Inc(Result, NumBytes);
    Ptr := HugeOffset(Ptr, NumBytes);
  end;
end;

function TS_BufferStream.Write(const Buffer; Count: LongInt): LongInt;
var
  Ptr: Pointer;
  NumBytes: Cardinal;
begin
  if State = bsRead then
    fStream.Position := Position
  else if BufPtr = nil then
  begin
    fBufPtr := fBuffer;
    fBufEnd := fBuffer + BufSize;
  end;

  Ptr := @Buffer;
  Result := 0;
  while Count > 0 do
  begin
    NumBytes := BufEnd - BufPtr;
    if Count < NumBytes then
      NumBytes := Count;
    HMemCpy(BufPtr, Ptr, NumBytes);
    Dec(Count, NumBytes);
    Inc(fBufPtr, NumBytes);
    Inc(Result, NumBytes);
    Ptr := HugeOffset(Ptr, NumBytes);
    if BufPtr = BufEnd then
      if not FlushBuffer then
        Break;
  end;
  if BufPtr <> fBuffer then
    fState := bsWrite;
end;

function TS_BufferStream.Seek(Offset: LongInt; Origin: Word): LongInt;
var
  CurrentPosition: LongInt;
begin
  CurrentPosition := Stream.Position + BufPosition;

  case Origin of
    soFromBeginning: Result := Offset;
    soFromCurrent:   Result := Stream.Position + BufPosition + Offset;
    soFromEnd:       Result := Stream.Size - Offset;
  else
    raise Exception.CreateFmt('Invalid seek origin = %d', [Origin]);
  end;

   if Result <> CurrentPosition then
  begin
    if (State = bsWrite) and not FlushBuffer then
      raise EStreamError.Create('Seek error');
    Stream.Position := Result;
    fBufPtr := nil;
    fState := bsUnknown;
  end;
end;

function TS_BufferStream.GetBufPosition: Integer;
begin
  Result := 0;
  case State of
    bsUnknown: Result := 0;
    bsRead:    Result := BufPtr - BufEnd;
    bsWrite:   Result := BufPtr - Buffer;
  end;
end;

procedure TS_BufferStream.PutBack(Ch: Char);
begin
  if fBufPtr <= fBuffer then
    raise EStreamError.Create('PutBack overflow');
  Dec(fBufPtr);
  BufPtr[0] := Ch;
end;

function TS_BufferStream.IsEof: Boolean;
begin
  Result := (BufPtr = BufEnd) and
    (Stream.Position = Stream.Size);
end;

procedure TS_BufferStream.AfterFillBuffer;
begin
  if Assigned(fOnFillBuffer) then
    fOnFillBuffer(Self);
end;

procedure TS_BufferStream.AfterFlushBuffer;
begin
  if Assigned(fOnFlushBuffer) then
    fOnFlushBuffer(Self);
end;

end.
