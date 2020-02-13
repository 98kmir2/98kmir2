unit CPUInfoMin;

interface

uses
  Windows, SysUtils, Classes, MMSystem;

type
  TCPUIDResult = packed record
    EAX: DWord;
    EBX: DWord;
    ECX: DWord;
    EDX: DWord;
  end;
  TCPUInfo = packed record
    Name: string[48];
    Brand: Word;
    APIC: DWord;
    Vendor: string[12];
    Frequency: Real;
    Family: integer;
    Model: integer;
    Stepping: integer;
    EFamily: integer;
    EModel: integer;
    EStepping: integer;
    MMX: Boolean;
    MMXPlus: Boolean;
    AMD3DNow: Boolean;
    AMD3DNowPlus: Boolean;
    SSE: Boolean;
    SSE2: Boolean;
    IA64: Boolean;
    X86_64: Boolean;
  end;

function getCPUInfo: TCPUInfo;

implementation

function CPUID(EAX: DWord): TCPUIDResult;
var
  rEAX, rEBX                : DWord;
  rECX, rEDX                : DWord;
begin
  asm
    push EAX
    push EBX
    push ECX
    push EDX
    mov EAX,EAX
    //******************************************************
    //cpuid指令，因为Delphi的汇编编译器没有内置该指令，
    //所以用该指令的机器语言代码$0F,$A2来实现
    //******************************************************
    db $0F,$A2
    mov rEAX,EAX
    mov rEBX,EBX
    mov rECX,ECX
    mov rEDX,EDX
    pop EDX
    pop ECX
    pop EBX
    pop EAX
  end;
  Result.EAX := rEAX;
  Result.EBX := rEBX;
  Result.ECX := rECX;
  Result.EDX := rEDX;
end;

function GetCPUSpeed: Real;
const
  timePeriod                = 1000;
var
  HighFreq, TestFreq, Count1, Count2: int64;
  TimeStart                 : integer;
  TimeStop                  : integer;
  ElapsedTime               : DWord;
  StartTicks                : DWord;
  EndTicks                  : DWord;
  TotalTicks                : DWord;
begin
  StartTicks := 0;
  EndTicks := 0;
  if QueryPerformanceFrequency(HighFreq) then begin

    TestFreq := HighFreq div 100;

    QueryPerformanceCounter(Count1);
    repeat
      QueryPerformanceCounter(Count2);
    until Count1 <> Count2;
    asm
      push ebx
      xor eax,eax
      xor ebx,ebx
      xor ecx,ecx
      xor edx,edx
      db $0F,$A2               /// cpuid
      db $0F,$31               /// rdtsc
      mov StartTicks,eax
      pop ebx
    end;

    repeat
      QueryPerformanceCounter(Count1);
    until Count1 - Count2 >= TestFreq;

    asm
      push ebx
      xor eax,eax
      xor ebx,ebx
      xor ecx,ecx
      xor edx,edx
      db $0F,$A2               /// cpuid
      db $0F,$31               /// rdtsc
      mov EndTicks,eax
      pop ebx
    end;

    ElapsedTime := MulDiv(Count1 - Count2, 1000000, HighFreq);
  end
  else begin
    timeBeginPeriod(1);
    TimeStart := timeGetTime;

    repeat
      TimeStop := timeGetTime;
    until TimeStop <> TimeStart;

    asm
      push ebx
      xor eax,eax
      xor ebx,ebx
      xor ecx,ecx
      xor edx,edx
      db $0F,$A2               /// cpuid
      db $0F,$31               /// rdtsc
      mov StartTicks,eax
      pop ebx
    end;

    repeat
      TimeStart := timeGetTime;
    until TimeStart - TimeStop >= timePeriod;

    asm
      push ebx
      xor eax,eax
      xor ebx,ebx
      xor ecx,ecx
      xor edx,edx
      db $0F,$A2               /// cpuid
      db $0F,$31               /// rdtsc
      mov EndTicks,eax
      pop ebx
    end;
    timeEndPeriod(1);

    ElapsedTime := (TimeStart - TimeStop) * 1000;
  end;
  TotalTicks := EndTicks - StartTicks;
  Result := TotalTicks / ElapsedTime;
end;

function getCPUInfo: TCPUInfo;
type
  TRegChar = array[0..3] of char;
var
  lvCPUID                   : TCPUIDResult;
  I                         : integer;
begin
  lvCPUID := CPUID(0);
  Result.Vendor := TRegChar(lvCPUID.EBX) + TRegChar(lvCPUID.EDX) + TRegChar(lvCPUID.ECX);
  lvCPUID := CPUID(1);
  Result.Frequency := GetCPUSpeed;
  Result.Family := (lvCPUID.EAX and $F00) shr 8;
  Result.Model := (lvCPUID.EAX and $78) shr 4;
  Result.Stepping := (lvCPUID.EAX and $F);
  Result.EFamily := (lvCPUID.EAX and $7800000) shr 20;
  Result.EModel := (lvCPUID.EAX and $78000) shr 16;
  Result.EStepping := (lvCPUID.EAX and $F);
  Result.APIC := (lvCPUID.EBX and $1FE00000) shr 23;
  Result.Brand := lvCPUID.EBX and $7F;
  Result.MMX := (lvCPUID.EDX and $800000) = $800000;
  Result.SSE := (lvCPUID.EDX and $2000000) = $2000000;
  Result.SSE2 := (lvCPUID.EDX and $4000000) = $4000000;
  Result.IA64 := (lvCPUID.EDX and $40000000) = $40000000;
  lvCPUID := CPUID($80000001);
  Result.MMXPlus := (lvCPUID.EDX and $800000) = $800000;
  Result.AMD3DNow := (lvCPUID.EDX and $10000000) = $10000000;
  Result.AMD3DNowPlus := (lvCPUID.EDX and $8000000) = $8000000;
  Result.X86_64 := (lvCPUID.EDX and $40000000) = $40000000;
  if (Result.Vendor = 'GenuineIntel') and ((Result.Family <> 15) or
    (Result.EFamily <> 0)) then
    Result.Name := Result.Vendor + ' Processor'
  else begin
    Result.Name := '';
    for I := 2 to 4 do begin
      lvCPUID := CPUID($80000000 + I);
      Result.Name := Result.Name +
        TRegChar(lvCPUID.EAX) +
        TRegChar(lvCPUID.EBX) +
        TRegChar(lvCPUID.ECX) +
        TRegChar(lvCPUID.EDX);
    end;
    Result.Name := Trim(Result.Name);
  end;
end;

end.

