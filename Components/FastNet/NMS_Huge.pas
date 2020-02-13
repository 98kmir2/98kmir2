unit NMS_Huge;

interface

  procedure HugeInc(var HugePtr: Pointer; Amount: LongInt);
  procedure HugeDec(var HugePtr: Pointer; Amount: LongInt);
  function HugeOffset(HugePtr: Pointer; Amount: LongInt): Pointer;

{$ifdef WIN32}
  { The Win3.1 API defines hmemcpy to copy memory
    that might span a segment boundary. Win32
    does not define it, so add it, for
    portability. }

  procedure HMemCpy(DstPtr, SrcPtr: Pointer; Amount: LongInt);

{$else}
  { The Win32 API defines these functions, so
    they are needed only for Win3.1. }

  procedure ZeroMemory(Ptr: Pointer; Length: LongInt);
  procedure FillMemory(Ptr: Pointer; Length: LongInt; Fill: Byte);
{$endif}

implementation

{$ifdef WIN32}

procedure HugeInc(var HugePtr: Pointer; Amount: LongInt);
begin
  HugePtr := PChar(HugePtr) + Amount;
end;

procedure HugeDec(var HugePtr: Pointer; Amount: LongInt);
begin
  HugePtr := PChar(HugePtr) - Amount;
end;

function HugeOffset(HugePtr: Pointer; Amount: LongInt): Pointer;
begin
  Result := PChar(HugePtr) + Amount;
end;

procedure HMemCpy(DstPtr, SrcPtr: Pointer; Amount: LongInt);
begin
  Move(SrcPtr^, DstPtr^, Amount);
end;

{$else}

uses SysUtils, WinTypes;

procedure HugeShift; far; external 'KERNEL' index 113;

procedure HugeInc(var HugePtr: Pointer; Amount: LongInt); assembler;
asm
  { Store Amount in DX:AX. }
  mov ax, Amount.Word[0]
  mov dx, Amount.Word[2]
  { Get the reference to HugePtr }
  les bx, HugePtr
  { Add the offset parts. }
  add ax, es:[bx]
  { Propagate carry to the high word of Amount }
  adc dx, 0
  mov cx, Offset HugeShift
  { Shift high word of Amount for segment }
  shl dx, cl
  { Increment the segment of HugePtr }
  add es:[bx+2], dx
  mov es:[bx], ax
end;

procedure HugeDec(var HugePtr: Pointer; Amount: LongInt); assembler;
asm
  { Store HugePtr ptr in es:[bx] }
  les bx, HugePtr
  mov ax, es:[bx]
  { Subtract the offset parts }
  sub ax, Amount.Word[0]
  mov dx, Amount.Word[2]
  { Propagate carry to the high word of Amount }
  adc dx, 0
  mov cx, OFFSET HugeShift
  { Shift high word of Amount for segment }
  shl dx, cl
  sub es:[bx+2], dx
  mov es:[bx], ax
end;

function HugeOffset(HugePtr: Pointer; Amount: LongInt): Pointer; assembler;
asm
  { Store Amount in DX:AX }
  mov ax, Amount.Word[0]
  mov dx, Amount.Word[2]
  { Add the offset parts }
  add ax, HugePtr.Word[0]
  { Propagate carry to the high word of Amount }
  adc dx, 0
  mov cx, OFFSET HugeShift
  { Shift high word of Amount for segment }
  shl dx, cl
  { Increment the segment of HugePtr }
  add dx, HugePtr.Word[2]
end;

procedure FillWords(DstPtr: Pointer; Size: Word; Fill: Word); assembler;
asm
  mov ax, Fill            { Get the fill word }
  les di, DstPtr          { Get the pointer }
  mov cx, Size.Word[0]    { Get the size }
  cld                     { Clear the direction flag }
  rep stosw               { Fill the memory }
end;

procedure FillMemory(Ptr: Pointer; Length: LongInt; Fill: Byte);
var
  NBytes: Cardinal;
  NWords: Cardinal;
  FillWord: Word;
begin
  WordRec(FillWord).Hi := Fill;
  WordRec(FillWord).Lo := Fill;
  while Length > 1 do
  begin
    if Ofs(Ptr^) = 0 then
      NBytes := $FFFE
    else
      NBytes := $10000 - Ofs(Ptr^);
    if NBytes > Length then
      NBytes := Length;
    NWords := NBytes div 2;
    FillWords(Ptr, NWords, FillWord);
    NBytes := NWords * 2;
    Dec(Length, NBytes);
    Ptr := HugeOffset(Ptr, NBytes);
  end;
  if Length > 0 then
    PByte(Ptr)^ := Fill;
end;

procedure ZeroMemory(Ptr: Pointer; Length: LongInt);
begin
  FillMemory(Ptr, Length, 0);
end;

{$endif}

end.
