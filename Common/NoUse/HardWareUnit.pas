unit HardWareUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, StdCtrls,
  NTNativeAPI;

function GetIdeSerialNumber(DeviceNumber: BYTE): PChar;
function GetMainBoardSerialNumber(): PChar;

implementation

{$INCLUDE MD_DEF.inc}

var
  hDevice                   : Thandle;
  cbBytesReturned           : DWORD;
  SCIP                      : TSendCmdInParams;
  aIdOutCmd                 : array[0..(SizeOf(TSendCmdOutParams) + IDENTIFY_BUFFER_SIZE - 1) - 1] of BYTE;
  IdOutCmd                  : TSendCmdOutParams absolute aIdOutCmd;

procedure ChangeByteOrder(var Data; Size: Integer);
var
  ptr                       : PChar;
  i                         : Integer;
  c                         : CHAR;
begin
  ptr := @Data;
  for i := 0 to (Size shr 1) - 1 do begin
    c := ptr^;
    ptr^ := (ptr + 1)^;
    (ptr + 1)^ := c;
    Inc(ptr, 2);
  end;
end;

function GetIdeSerialNumber(DeviceNumber: BYTE): PChar;
begin
  Result := 'Not Available';            // 如果出错则返回空串
  if SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT then begin // Windows NT, Windows 2000
    // 提示! 改变名称可适用于其它驱动器，如第二个驱动器： '\\.\PhysicalDrive1\'
    //hDevice := GetHandle_PhysicalDrive(DeviceNumber);
    hDevice := CreateFile('\\.\PhysicalDrive0', GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if hDevice = INVALID_HANDLE_VALUE then
      hDevice := CreateFile('\\.\PhysicalDrive0', GENERIC_READ or GENERIC_WRITE,
        FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  end else                              // Version Windows 95 OSR2, Windows 98
    hDevice := CreateFile('\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0);

  if hDevice = INVALID_HANDLE_VALUE then
    Exit;

  try
    FillChar(SCIP, SizeOf(TSendCmdInParams) - 1, #0);
    FillChar(aIdOutCmd, SizeOf(aIdOutCmd), #0);
    cbBytesReturned := 0;
    // Set up data structures for IDENTIFY command.
    with SCIP do begin
      cBufferSize := IDENTIFY_BUFFER_SIZE;
      // bDriveNumber := 0;
      with irDriveRegs do begin
        bSectorCountReg := 1;
        bSectorNumberReg := 1;
        // if Win32Platform = VER_PLATFORM_WIN32_NT then bDriveHeadReg := $A0
        // else bDriveHeadReg := $A0 or ((bDriveNum and 1) shl 4);
        bDriveHeadReg := $A0;
        bCommandReg := $EC;
      end;
    end;
    if not DeviceIoControl(hDevice, $0007C088, @SCIP, SizeOf(TSendCmdInParams) - 1, @aIdOutCmd, SizeOf(aIdOutCmd), cbBytesReturned, nil) then
      Exit;
  finally
    CloseHandle(hDevice);
  end;

  with PIdSector(@IdOutCmd.bBuffer)^ do begin
    ChangeByteOrder(sSerialNumber, SizeOf(sSerialNumber));
    (PChar(@sSerialNumber) + SizeOf(sSerialNumber))^ := #0;
    Result := PChar(Trim(sSerialNumber));
  end;
end;

/////

function DumpRomBiosFw(RomBase: Pointer; RomSize: Cardinal; out Dump): boolean;
const
  FwTP                      = $4649524D; // 'FIRM' The raw firmware table provider.
var
  HMod                      : HMODULE;
  Size                      : UINT;
  List                      : PDWordArray;
  Loop                      : Integer;
  BLen                      : UINT;
  Buff                      : PByteArray;
  Base                      : boolean;
  Over                      : boolean;
  BOff                      : UINT;
  DOff                      : UINT;
begin
  Result := False;
  HMod := GetModuleHandle(kernel32);
  if HMod = 0 then
    SetLastError(ERROR_CALL_NOT_IMPLEMENTED)
  else begin
    if not Assigned(EnumSystemFirmwareTables) then
      EnumSystemFirmwareTables := GetProcAddress(HMod, 'EnumSystemFirmwareTables');
    if not Assigned(GetSystemFirmwareTable) then
      GetSystemFirmwareTable := GetProcAddress(HMod, 'GetSystemFirmwareTable');
    if not Assigned(EnumSystemFirmwareTables) or
      not Assigned(GetSystemFirmwareTable) then
      Exit
    else begin
      Size := EnumSystemFirmwareTables(FwTP, nil^, 0) + 2 * SizeOf(DWORD);
      List := PDWordArray(LocalAlloc(LPTR, Size));
      if List <> nil then try
        Base := False;
        Over := False;
        FillChar(Dump, RomSize, 0);
        Size := EnumSystemFirmwareTables(FwTP, List^, Size);
        for Loop := 0 to Integer(Size div SizeOf(DWORD)) - 1 do
          if List[Loop] < Cardinal(RomBase) + RomSize then begin
            BLen := GetSystemFirmwareTable(FwTP, List[Loop], nil^, 0) + $20000;
            Buff := PByteArray(LocalAlloc(LPTR, BLen));
            if Buff <> nil then try
              BLen := GetSystemFirmwareTable(FwTP, List[Loop], Buff^, BLen);
              if (BLen > 0) and (List[Loop] + BLen > Cardinal(RomBase)) then begin
                if List[Loop] <= Cardinal(RomBase) then begin
                  Base := True;
                  BOff := Cardinal(RomBase) - List[Loop];
                  DOff := 0;
                end
                else begin
                  BOff := 0;
                  DOff := List[Loop] - Cardinal(RomBase);
                end;
                if DOff + BLen >= RomSize then begin
                  Over := True;
                  BLen := RomSize - DOff;
                end;
                Move(Buff[BOff], TByteArray(Dump)[DOff], BLen);
              end;
            finally
              LocalFree(HLOCAL(Buff));
            end;
          end;
        Result := Base and Over;
      finally
        LocalFree(HLOCAL(List));
      end;
    end;
  end;
end;

function GetMainBoardSerialNumber(): PChar;
const
  smbios_as                 : AnsiString = '_SM_';
  dmi_as                    : AnsiString = '_DMI_';
var
  i                         : Integer;
  SI                        : TSystemInfo;
  dwPageSize                : Cardinal;
  pszMemory                 : PAnsiChar;
  dwMemorySize              : Cardinal;
  dwStartAddress            : Cardinal;
  dwSize                    : Cardinal;
  dwEndAddress              : Cardinal;

  SectionHandle             : Thandle;
  ViewOfPhysMem             : Pointer;
  BlockStart, AddrOfs       : Cardinal;
  AddrSeg                   : BYTE;
  S                         : string;
  TmpBuf                    : TMemoryBuffer;
  ok, ok2                   : boolean;

  m                         : PAnsiChar;
  fw                        : boolean;
  buf                       : TRomBiosDump;
  p, blockptr               : Cardinal;
  Buffer                    : TArrayBuffer;
  dwStart                   : Cardinal;

  btMajorVersion            : BYTE;
  btMinorVersion            : BYTE;
  szVersion                 : string;
  szRevision                : string;

  dwStructStart             : DWORD;
  wTableCount               : Word;
  wLen                      : Word;
  dwStructure_StartAddress  : DWORD;
  dwStructure_MemorySize    : DWORD;
  pszStructure_Memory       : PAnsiChar;

  l, sl                     : BYTE;
  c                         : Cardinal;
  Found                     : boolean;

  StructTables              : TStructTables;
  szMBMan                   : string;
  szMBMod                   : string;
  szMBVer                   : string;
  szMBSN                    : string;
  szMBAT                    : string;
  szMBLIC                   : string;

  function GetAddressCharValue(Address: Cardinal): AnsiChar;
  begin
    if (Address >= dwStartAddress) and (Address <= dwStartAddress + dwMemorySize) then
      Result := pszMemory[Address - dwStartAddress]
    else
      Result := #0;
  end;

  function GetAddressArrayValue(Address: Cardinal; Length: BYTE): TArrayBuffer;
  begin
    try
      if Address + Length > dwStartAddress + dwMemorySize then
        Length := dwStartAddress + dwMemorySize - Address;
      if (Address >= dwStartAddress) and (Address <= dwStartAddress + dwMemorySize) then
        Move(pszMemory[Address - dwStartAddress], Result[0], Length)
      else
        FillChar(Result, SizeOf(Result), 0);
    except
      FillChar(Result, SizeOf(Result), 0);
    end;
  end;

  function GetAddressByteValue(Address: Cardinal): BYTE;
  begin
    try
      if (Address >= dwStartAddress) and (Address <= dwStartAddress + dwMemorySize) then
        Result := Ord(pszMemory[Address - dwStartAddress])
      else
        Result := 0;
    except
      Result := 0;
    end;
  end;

  function GetAddressWordValue(Address: Cardinal): Word;
  begin
    try
      if (Address >= dwStartAddress) and ((Address + SizeOf(Word)) <= (dwStartAddress + dwMemorySize)) then
        Move(pszMemory[Address - dwStartAddress], Result, SizeOf(Word))
      else
        Result := 0;
    except
      Result := 0;
    end
  end;

  function GetAddressDWORDValue(Address: Cardinal): Cardinal;
  begin
    try
      if (Address >= dwStartAddress) and (Address <= (dwStartAddress + dwMemorySize) - SizeOf(Cardinal)) then
        Move(pszMemory[Address - dwStartAddress], Result, SizeOf(Cardinal))
      else
        Result := 0;
    except
      Result := 0;
    end;
  end;

  function IsValidAddress(A: Cardinal): boolean;
  begin
    Result := (A >= dwStructure_StartAddress) and (A <= dwStructure_StartAddress + dwStructure_MemorySize);
  end;

  function GetAddressArrayValue2(Address: Cardinal; Length: BYTE): TArrayBuffer;
  begin
    try
      if Address + Length > dwStructure_StartAddress + dwStructure_MemorySize then
        Length := dwStructure_StartAddress + dwStructure_MemorySize - Address;
      if (Address >= dwStructure_StartAddress) and (Address <= dwStructure_StartAddress + dwStructure_MemorySize) then
        Move(pszStructure_Memory[Address - dwStructure_StartAddress], Result[0], Length)
      else
        FillChar(Result, SizeOf(Result), 0);
    except
      FillChar(Result, SizeOf(Result), 0);
    end;
  end;

  function GetAddressByteValue2(Address: Cardinal): BYTE;
  begin
    try
      if (Address >= dwStructure_StartAddress) and (Address <= dwStructure_StartAddress + dwStructure_MemorySize) then
        Result := Ord(pszStructure_Memory[Address - dwStructure_StartAddress])
      else
        Result := 0;
    except
      Result := 0;
    end;
  end;

  function GetAddressWordValue2(Address: Cardinal): Word;
  begin
    try
      if (Address >= dwStructure_StartAddress) and ((Address + SizeOf(Word)) <= (dwStructure_StartAddress + dwStructure_MemorySize)) then
        Move(pszStructure_Memory[Address - dwStructure_StartAddress], Result, SizeOf(Word))
      else
        Result := 0;
    except
      Result := 0;
    end
  end;

  function GetAddressDWORDValue2(Address: Cardinal): Cardinal;
  begin
    try
      if (Address >= dwStructure_StartAddress) and (Address <= (dwStructure_StartAddress + dwStructure_MemorySize) - SizeOf(Cardinal)) then
        Move(pszStructure_Memory[Address - dwStructure_StartAddress], Result, SizeOf(Cardinal))
      else
        Result := 0;
    except
      Result := 0;
    end;
  end;

  function FindTableRecord(AType: BYTE; ST: TStructTables; From: Cardinal = 0): TStructTable;
  var
    i                       : Integer;
  begin
    Finalize(Result);
    FillChar(Result, SizeOf(TStructTable), 0);
    for i := From to High(ST) do
      if ST[i].Indicator = AType then begin
        Result := ST[i];
        Break;
      end;
  end;

  function GetAddressString(Address: Cardinal; Index: BYTE): string;
  var
    i, l                    : Integer;
    S                       : string;
  begin
    S := '';
    l := 0;
    try
      for i := 1 to Index do begin
        S := GetAddressArrayValue2(Address + l, 255);
        l := l + Length(S) + 1;
        if S = '' then
          Break;
      end;
      Result := Trim(S);
    except
      S := '';
    end;
    Result := S;
  end;

begin
  //Result := '';
  Result := PChar(Format('<%s>', [GetIdeSerialNumber(0)]));
  dwPageSize := g_xSystemInfo.dwPageSize;

  fw := False;

  szVersion := '';
  szRevision := '';
  pszMemory := nil;
  pszStructure_Memory := nil;
  dwMemorySize := 0;
  dwStartAddress := 0;
  dwSize := 0;
  dwEndAddress := 0;
  dwStructStart := 0;
  wTableCount := 0;
  wLen := 0;
  dwStructure_StartAddress := 0;
  dwStructure_MemorySize := 0;

  blockptr := RomBiosDumpBase;

  szMBMan := '';
  szMBMod := '';
  szMBVer := '';
  szMBSN := '';
  szMBAT := '';
  szMBLIC := '';

  try
    repeat
      ok := False;
      if not fw then
        ok := DumpRomBiosFw(RomBiosDumpBasePtr, RomBiosDumpSize, buf);
      if ok then begin
        dwStartAddress := 0;
        dwEndAddress := RomBiosDumpSize - 1;
        dwMemorySize := RomBiosDumpSize;
        m := AllocMem(SizeOf(buf.ByteArray));
        try
          Move(buf.ByteArray[0], m[0], SizeOf(buf.ByteArray));

          ReAllocMem(pszMemory, SizeOf(buf.ByteArray));
          Move(m[0], pszMemory[0], SizeOf(buf.ByteArray));
        finally
          FreeMem(m);
          m := nil;
        end;
        fw := True;
      end;
      if not ok then begin
        dwStartAddress := blockptr;
        dwEndAddress := blockptr + RomBiosBlockSize;
        dwMemorySize := RomBiosBlockSize;

        //RefreshData ......
        ok2 := False;
        ReAllocMem(pszMemory, dwMemorySize);
        if Win32Platform = VER_PLATFORM_WIN32_NT then begin
          InitNativeAPI;
          if (NtOpenSection(@SectionHandle, DesiredAccess, @ObjectAttribs) = STATUS_SUCCESS) then try
            BlockStart := dwStartAddress - (dwStartAddress mod dwPageSize);
            ViewOfPhysMem := MapViewOfFile(SectionHandle, DesiredAccess, 0, dwStartAddress, dwMemorySize + dwStartAddress - BlockStart);
            if Assigned(ViewOfPhysMem) then try
              ZeroMemory(pszMemory, dwMemorySize);
              if dwStartAddress < BlockStart then
                Move(PAnsiChar(ViewOfPhysMem)[dwStartAddress], pszMemory[0], dwMemorySize)
              else
                Move(PAnsiChar(ViewOfPhysMem)[dwStartAddress - BlockStart], pszMemory[0], dwMemorySize);
              //Move(ViewOfPhysMem^,FMemory[0],dwMemorySize);
              ok2 := True;
            finally
              UnmapViewOfFile(ViewOfPhysMem);
            end;
          finally
            NtClose(SectionHandle);
          end;
          if not ok2 and not IsWow64 then begin
            S := IntToHex(dwStartAddress, 8);
            AddrSeg := StrToInt('$' + Copy(S, 4, 1) + Copy(S, 3, 1));
            AddrOfs := StrToInt('$' + Copy(S, 5, 4));
            ReadRomBios16(AddrSeg, TmpBuf, INFINITE);
            Move(TmpBuf[AddrOfs], pszMemory[0], dwMemorySize);
            ok2 := True;
          end;
        end else begin
          try
            Move(ptr(dwStartAddress)^, pszMemory[0], dwMemorySize);
            ok2 := True;
          except
          end;
        end;
        if not ok2 then begin
          if pszMemory <> nil then
            FreeMem(pszMemory);
          pszMemory := nil;
        end;
      end;

      ok := Assigned(pszMemory);
      if ok then begin
        for i := dwStartAddress to dwEndAddress do begin
          if (GetAddressCharValue(i) = smbios_as[1]) then begin
            FillChar(Buffer, SizeOf(Buffer), 0);
            Buffer := GetAddressArrayValue(i, Length(smbios_as));
            if (Pos(smbios_as, string(Buffer)) = 1) then begin
              Buffer := GetAddressArrayValue(i + 16, Length(dmi_as));
              if (Pos(dmi_as, string(Buffer)) = 1) then begin
                dwStart := i;
                Break;
              end;
            end;
          end;
        end;
      end;
      if dwStart = 0 then begin
        for i := dwStartAddress to dwEndAddress do begin
          if (GetAddressCharValue(i) = dmi_as[1]) then begin
            FillChar(Buffer, SizeOf(Buffer), 0);
            Buffer := GetAddressArrayValue(i, Length(dmi_as));
            if Pos(dmi_as, string(Buffer)) = 1 then begin
              dwStart := i - $10;
              Break;
            end;
          end;
        end;
      end;
      Inc(blockptr, RomBiosBlockSize + 1);
    until (dwStart > 0) or (blockptr > RomBiosDumpEnd);

    try
      if (dwStart > 0) then begin
        btMinorVersion := GetAddressByteValue(dwStart + $7);
        btMajorVersion := GetAddressByteValue(dwStart + $6);
        szVersion := Format('%d.%d', [btMajorVersion, btMinorVersion]);
        szRevision := Format('%d.%d', [Lo(GetAddressByteValue(dwStart + $1F)), Hi(GetAddressByteValue(dwStart + $1F))]);

        dwStructStart := GetAddressDWORDValue(dwStart + $18);
        wTableCount := GetAddressWordValue(dwStart + $1C);
        wLen := GetAddressWordValue(dwStart + $16);
        if (dwStructStart <= 0) then begin
          Exit;
        end;

        dwStructure_StartAddress := dwStructStart;
        dwStructure_MemorySize := wLen;
        if fw then begin
          dwStructStart := dwStructStart - RomBiosDumpBase;
          if dwStructStart >= dwMemorySize then
            dwStructStart := dwStart + $1F;
          dwStructure_MemorySize := wLen;
          dwStructure_StartAddress := 0;

          //dwStructure_LoadFromMemory(pszMemory, dwStructStart, wLen);
          ReAllocMem(pszStructure_Memory, dwStructure_MemorySize);
          Move(pszMemory[dwStructStart], pszStructure_Memory[0], dwStructure_MemorySize);
          dwStructStart := 0;
        end else begin
          //RefreshData ......
          ok2 := False;
          ReAllocMem(pszStructure_Memory, dwStructure_MemorySize);
          if Win32Platform = VER_PLATFORM_WIN32_NT then begin
            InitNativeAPI;
            if (NtOpenSection(@SectionHandle, DesiredAccess, @ObjectAttribs) = STATUS_SUCCESS) then try
              BlockStart := dwStructure_StartAddress - (dwStructure_StartAddress mod dwPageSize);
              ViewOfPhysMem := MapViewOfFile(SectionHandle, DesiredAccess, 0, dwStructure_StartAddress, dwStructure_MemorySize + dwStructure_StartAddress - BlockStart);
              if Assigned(ViewOfPhysMem) then try
                ZeroMemory(pszMemory, dwMemorySize);
                if dwStructure_StartAddress < BlockStart then
                  Move(PAnsiChar(ViewOfPhysMem)[dwStructure_StartAddress], pszStructure_Memory[0], dwStructure_MemorySize)
                else
                  Move(PAnsiChar(ViewOfPhysMem)[dwStructure_StartAddress - BlockStart], pszStructure_Memory[0], dwStructure_MemorySize);
                //Move(ViewOfPhysMem^,FMemory[0],dwMemorySize);
                ok2 := True;
              finally
                UnmapViewOfFile(ViewOfPhysMem);
              end;
            finally
              NtClose(SectionHandle);
            end;
            if not ok2 and not IsWow64 then begin
              S := IntToHex(dwStructure_StartAddress, 8);
              AddrSeg := StrToInt('$' + Copy(S, 4, 1) + Copy(S, 3, 1));
              AddrOfs := StrToInt('$' + Copy(S, 5, 4));
              ReadRomBios16(AddrSeg, TmpBuf, INFINITE);
              Move(TmpBuf[AddrOfs], pszStructure_Memory[0], dwStructure_MemorySize);
              ok2 := True;
            end;
          end else begin
            try
              Move(ptr(dwStructure_StartAddress)^, pszStructure_Memory[0], dwStructure_MemorySize);
              ok2 := True;
            except
            end;
          end;
          if not ok2 then begin
            if pszStructure_Memory <> nil then
              FreeMem(pszStructure_Memory);
            pszStructure_Memory := nil;
          end;
        end;

        ////////////////////////////
        p := 0;
        if not IsValidAddress(dwStructStart) then
          Exit;

        SetLength(StructTables, Length(StructTables) + 1);
        with StructTables[High(StructTables)] do begin
          Address := dwStructStart + p;
          Indicator := GetAddressByteValue2(dwStructStart + p);
          Length := GetAddressByteValue2(dwStructStart + p + 1);
          Handle := GetAddressWordValue2(dwStructStart + p + 2);
        end;
        Found := GetAddressByteValue2(dwStructStart + p) = 0;
        repeat
          sl := GetAddressByteValue2(dwStructStart + p + 1);
          p := p + sl + 1;
          i := 0;
          l := GetAddressByteValue2(dwStructStart + p - 1);
          if not ((StructTables[High(StructTables)].Indicator = 5) and (l > 5) and (l <> 32)) then begin
            while IsValidAddress(dwStructStart + p + i) and ((l + GetAddressByteValue2(dwStructStart + p + i) <> 0) or (Found and (GetAddressByteValue2(dwStructStart + p + i + 1) = 0))) do begin
              l := GetAddressByteValue2(dwStructStart + p + i);
              Inc(i);
            end;
            p := p + i + 1;
          end else
            p := p - 1;
          SetLength(StructTables, Length(StructTables) + 1);
          with StructTables[High(StructTables)] do begin
            Address := dwStructStart + p;
            Indicator := GetAddressByteValue2(dwStructStart + p);
            Length := GetAddressByteValue2(dwStructStart + p + 1);
            Handle := GetAddressWordValue2(dwStructStart + p + 2);
          end;

          Found := Found or (GetAddressByteValue2(dwStructStart + p) = 0);
        until (GetAddressByteValue2(dwStructStart + p) = SMB_EOT) or (dwStructStart + p >= dwStructStart + dwStructure_MemorySize);

        p := FindTableRecord(SMB_BASEINFO, StructTables).Address;
        if (p >= dwStructStart) and (GetAddressByteValue2(p) = 2) then begin
          sl := GetAddressByteValue2(p + 1);
          if GetAddressByteValue2(p + 4) > 0 then
            szMBMan := GetAddressString(p + sl, GetAddressByteValue2(p + 4));
          if GetAddressByteValue2(p + 5) > 0 then
            szMBMod := GetAddressString(p + sl, GetAddressByteValue2(p + 5));
          if GetAddressByteValue2(p + 6) > 0 then
            szMBVer := GetAddressString(p + sl, GetAddressByteValue2(p + 6));
          if GetAddressByteValue2(p + 7) > 0 then
            szMBSN := GetAddressString(p + sl, GetAddressByteValue2(p + 7));
          if GetAddressByteValue2(p + 8) > 0 then
            szMBAT := GetAddressString(p + sl, GetAddressByteValue2(p + 8));
          if FindTableRecord(SMB_BASEINFO, StructTables).Length >= $A then
            if GetAddressByteValue2(p + $A) > 0 then
              szMBLIC := GetAddressString(p + sl, GetAddressByteValue2(p + $A));
          //Result := PChar(szMBSN);
          Result := PChar(Format('%s %s %s [%s] %s %s %s', [szMBMan, szMBMod, szMBVer, GetIdeSerialNumber(0), szMBSN, szMBAT, szMBLIC]));
        end;
      end;
    finally
      if pszMemory <> nil then
        FreeMem(pszMemory);
      pszMemory := nil;
    end;
  finally
    if pszMemory <> nil then
      FreeMem(pszMemory);
    pszMemory := nil;
    if pszStructure_Memory <> nil then
      FreeMem(pszStructure_Memory);
    pszStructure_Memory := nil;
  end;
end;

initialization
  //SetProcessAffinity := nil;
  FillChar(g_xSystemInfo, SizeOf(g_xSystemInfo), 0);
  Kernel32Handle := GetModuleHandle(PChar(rsKernel));
  if Kernel32Handle = 0 then
    Kernel32Handle := LoadLibrary(PChar(rsKernel));
  if Kernel32Handle <> 0 then begin
    //SetProcessAffinity := GetProcAddress(Kernel32Handle, PChar(rsSetProcessAffinityMask));
    GetNativeSystemInfo := GetProcAddress(Kernel32Handle, PChar(rsGetNativeSystemInfo));
    IsWow64Process := GetProcAddress(Kernel32Handle, PChar(rsIsWow64Process));
    if not Assigned(GetNativeSystemInfo) then
      GetNativeSystemInfo := GetSystemInfo;

    if Assigned(IsWow64Process) then
      IsWow64Process(GetCurrentProcess, IsWow64);
      
    if IsWow64 then
      GetNativeSystemInfo(g_xSystemInfo)
    else
      GetSystemInfo(g_xSystemInfo);
  end;

end.

