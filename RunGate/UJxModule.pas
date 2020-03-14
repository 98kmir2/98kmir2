unit UJxModule;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Contnrs, StdCtrls, IdHashMessageDigest, IdHashCRC, DCPcrypt, Mars;



const max_packetsize = 1024;
const
  JXSIGNATURE = $5441584A;

const PACKETSIG = $33333333;


type TJX_PACKET = record
    signature: Cardinal;
    totoallen: Integer;
    curOffset: Integer;
    curLen: Integer;
    Crc: Cardinal;
  end;
  PJX_PACKET = ^TJX_PACKET;
type

  TJX_HEADER = record
    jx_sign: Integer; //标示
    file_len: Integer; //文件长度
    file_crc: Cardinal; // 文件CrC
    //压缩存放
    srv_offset: Integer;
    srv_len: Integer;
    clt_offset: Integer;
    clt_len: Integer;
  end;
  PJX_HEADER = ^TJX_HEADER;

type
  PFNENDECODE = function(szbuf: PChar; len: Integer; szOut: PChar): Integer; stdcall;
  PFNGETFUNC = function(index: Integer): Integer; stdcall;
  PFNGETVERSION = function(): Integer; stdcall;
  PFNGETSTRCHECK = function(szbuf: PChar; len: Integer): Integer; stdcall;

type TVtable = record
    pfn_GetVersion: PFNGETVERSION;
    pfn_GetStrCheck: PFNGETSTRCHECK;
  end;
  PVtalbe = ^TVtable;

type
  TJxMoudle = class
    szFileName: string;
    mClient: TMemoryStream;
    mServer: TMemoryStream;
    hModule: Cardinal;
    m_vtable: PVtalbe;
    m_Ready: Boolean;
    m_MaxSize: Integer;
    m_BlockCount: Integer;

    function GetSendData(p: Pointer; offset: Integer): Integer; // 发送多少数据;
    function isReady: Boolean;
    constructor Create(sName: string);
    function GetVtable(): PVtalbe;
    function memLoadLibrary(pLib: Pointer): DWord;
  end;
  TJXManager = class
    curModule: TJxMoudle;
    m_lastmd5: string;
    procedure LoadJx;
    constructor Create();
  end;

var
  g_pJXMgr: TJXManager;

implementation

uses LogManager, MD5, Misc;

procedure ChangeReloc(baseorgp, basedllp, relocp: pointer; size: cardinal);
type
  TRelocblock = record
    vaddress: integer;
    size: integer;
  end;
  PRelocblock = ^TRelocblock;
var
  myreloc: PRelocblock;
  reloccount: integer;
  startp: ^word;
  i: cardinal;
  p: ^cardinal;
  dif: cardinal;


begin
  myreloc := relocp;
  dif := cardinal(basedllp) - cardinal(baseorgp);
  startp := pointer(cardinal(relocp) + 8);
  while myreloc^.vaddress <> 0 do
  begin
    reloccount := (myreloc^.size - 8) div sizeof(word);
    for i := 0 to reloccount - 1 do
    begin
      if (startp^ xor $3000 < $1000) then
      begin
        p := pointer(myreloc^.vaddress + startp^ mod $3000 + integer(basedllp));
        p^ := p^ + dif;
      end;
      startp := pointer(cardinal(startp) + sizeof(word));
    end;
    myreloc := pointer(startp);
    startp := pointer(cardinal(startp) + 8);
  end;
end;

procedure CreateImportTable(dllbasep, importp: pointer); stdcall;
type
  timportblock = record
    Characteristics: cardinal;
    TimeDateStamp: cardinal;
    ForwarderChain: cardinal;
    Name: pchar;
    FirstThunk: pointer;
  end;
  pimportblock = ^timportblock;
var
  myimport: pimportblock;
  thunksread, thunkswrite: ^pointer;
  dllname: pchar;
  dllh: thandle;
  old: cardinal;
begin
  myimport := importp;
  while (myimport^.FirstThunk <> nil) and (myimport^.Name <> nil) do
  begin
    dllname := pointer(integer(dllbasep) + integer(myimport^.name));
    dllh := LoadLibrary(dllname);
    thunksread := pointer(integer(myimport^.FirstThunk) + integer(dllbasep));
    thunkswrite := thunksread;
    if integer(myimport^.TimeDateStamp) = -1 then
      thunksread := pointer(integer(myimport^.Characteristics) + integer(dllbasep));
    while (thunksread^ <> nil) do
    begin
      if VirtualProtect(thunkswrite, 4, PAGE_EXECUTE_READWRITE, old) then
      begin
        if (cardinal(thunksread^) and $80000000 <> 0) then
          thunkswrite^ := GetProcAddress(dllh, pchar(cardinal(thunksread^) and $FFFF))
        else
          thunkswrite^ := GetProcAddress(dllh, pchar(integer(dllbasep) + integer(thunksread^) + 2));
        VirtualProtect(thunkswrite, 4, old, old);
      end;
      inc(thunksread, 1);
      inc(thunkswrite, 1);
    end;
    myimport := pointer(integer(myimport) + sizeof(timportblock));
  end;
end;

{ TJxMoudle }

constructor TJxMoudle.Create(sName: string);
var m: TMemoryStream;
  jxhead: PJX_HEADER;
  MyCRC: TIdHashCRC32;
  crc: Cardinal;
  temp: TMemoryStream;
  DCP_mars: TDCP_mars;
begin
  m_Ready := False;
  if not FileExists(sName) then
  begin

    g_pLogMgr.Add(Format('文件 %s 不存在', [sName]));
    Exit;
  end;
  m := TMemoryStream.Create;
  m.LoadFromFile(sName);
  if m.Size < SizeOf(TJxMoudle) then
  begin
    g_pLogMgr.Add(Format(' %s 太小', [sName]));
    Exit;
  end;
  jxhead := m.Memory;

  if jxhead.jx_sign <> JXSIGNATURE then
  begin

    g_pLogMgr.Add(Format(' %s  sinerr', [sName]));
    Exit;
  end;
  if jxhead.file_len <> (jxhead.srv_len + jxhead.clt_len) then
  begin

    g_pLogMgr.Add(Format(' %s  sinerr', [sName]));

    Exit;
  end;
  //文件完整性校验
  MyCRC := TIdHashCRC32.Create;
  m.Position := SizeOf(TJX_HEADER);
  crc := MyCRC.HashValue(m);
  MyCRC.Free;
  if jxhead.file_crc <> crc then
  begin

    g_pLogMgr.Add(Format(' %s  crcerror', [sName]));
    Exit;
  end;
  DCP_mars := TDCP_mars.Create(nil);

  try
    begin
      temp := TMemoryStream.Create;
      mClient := TMemoryStream.Create;
      mServer := TMemoryStream.Create;


      m.Position := jxhead.srv_offset;
      temp.CopyFrom(m, jxhead.srv_len);
      mServer.SetSize(temp.Size);
      mServer.Position := 0;
      temp.Position := 0;
      DCP_mars.InitStr('d3d3Lmp4YW50aS5jb20gc2VydmVy');
      DCP_mars.DecryptStream(temp, mServer, temp.Size);


      m.Position := jxhead.clt_offset;

      temp.Clear;
      temp.CopyFrom(m, jxhead.clt_len);

      mClient.SetSize(temp.Size);
      mClient.Position := 0;
      temp.Position := 0;
      DCP_mars.InitStr('d3d3Lmp4YW50aS5jb20gY2xpZW50');
      DCP_mars.DecryptStream(temp, mClient, temp.Size);

      DCP_mars.Free;
      temp.Free;
      m.Free;
      hModule := self.memLoadLibrary(mServer.Memory);

      if m_vtable <> nil then
      begin
        g_pLogMgr.Add(Format('反外挂模块[ver:%d]加载成功', [m_vtable.pfn_GetVersion()]));
        m_Ready := true;
        m_MaxSize := max_packetsize;
        m_BlockCount := (mClient.Size + m_MaxSize - 1) div m_MaxSize;

      end;
    end;
  except
    on E: Exception do
    begin
      g_pLogMgr.Add(Format('反外挂模块加载失败 %s', [e.Message]));
      exit;
    end;
  end;


//  g_pLogMgr.Add('反外挂模块加载成功');
end;

function CalcBufferCRC(Buffer: PChar; nSize: Integer): Integer;
var
  I: Integer;
  Int: ^Integer;
  nCrc: Integer;
begin
  Int := Pointer(Buffer);
  nCrc := 0;
  for I := 0 to nSize div 4 - 1 do
  begin
    nCrc := nCrc xor Int^;
    Int := Pointer(Integer(Int) + 4);
  end;
  Result := nCrc;
end;

function TJxMoudle.GetSendData(p: Pointer; offset: Integer): Integer;
var rlen: Integer;
  packet: PJX_PACKET;
  encryptbuf: array[0..1024 * 4 - 1] of Char;
  ptmp: PChar;
  start: Integer;
begin

  if (offset < 0) or (offset >= m_BlockCount) then
  begin
    Result := 0;
    g_pLogMgr.Add('err in GetSendData');
    Exit;
  end;
  start := offset * m_MaxSize;
  if start > mClient.Size then
  begin
    Result := 0;
    g_pLogMgr.Add('err in GetSendData');
    Exit;
  end;

  rlen := max_packetsize;

  if (start + max_packetsize) > mClient.Size then
  begin
    rlen := mClient.Size - start;
  end;

  ptmp := Pchar(@encryptbuf[0]);
  CopyMemory(pchar(ptmp) + sizeof(TJX_PACKET), pchar(mClient.Memory) + start, rlen);

  packet := PJX_PACKET(ptmp);
  packet.signature := PACKETSIG;
  packet.totoallen := mClient.Size;
  packet.curOffset := start;
  packet.curLen := rlen;
//  packet.Crc := CalcBufferCRC(Pchar(Integer(mClient.Memory) + start), rlen);

  rlen := rlen + SizeOf(TJX_PACKET);

  //数据都得加密
  Result := EncodeBuf(Integer(@encryptbuf[0]), rlen, Integer(p));

end;

function TJxMoudle.GetVtable: PVtalbe;
begin

  Result := nil;
end;

function TJxMoudle.isReady: Boolean;
begin
  Result := m_Ready;
end;

function TJxMoudle.memLoadLibrary(pLib: Pointer): DWord;
var
  DllMain: function(dwHandle, dwReason, dwReserved: DWord): DWord; stdcall;
  IDH: PImageDosHeader;
  INH: PImageNtHeaders;
  SEC: PImageSectionHeader;
  dwSecCount: DWord;
  dwLen: DWord;
  dwmemsize: DWord;
  i: Integer;
  pAll: Pointer;

begin
  Result := 0;
  IDH := pLib;
  if isBadReadPtr(IDH, SizeOf(TImageDosHeader)) or (IDH^.e_magic <> IMAGE_DOS_SIGNATURE) then
    Exit;
  INH := pointer(cardinal(pLib) + cardinal(IDH^._lfanew));
  if isBadReadPtr(INH, SizeOf(TImageNtHeaders)) or (INH^.Signature <> IMAGE_NT_SIGNATURE) then
    Exit;
// if (pReserved <> nil) then
//    dwLen := Length(pReserved)+1
// else
  dwLen := 0;
  SEC := Pointer(Integer(INH) + SizeOf(TImageNtHeaders));
  dwMemSize := INH^.OptionalHeader.SizeOfImage;
  if (dwMemSize = 0) then
    Exit;
  pAll := VirtualAlloc(nil, dwMemSize + dwLen, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  if (pAll = nil) then
    Exit;
  dwSecCount := INH^.FileHeader.NumberOfSections;
  CopyMemory(pAll, IDH, DWord(SEC) - DWord(IDH) + dwSecCount * SizeOf(TImageSectionHeader));
// CopyMemory(Pointer(DWord(pAll) + dwMemSize),pReserved,dwLen-1);
  CopyMemory(Pointer(DWord(pAll) + dwMemSize), nil, dwLen - 1);
  for i := 0 to dwSecCount - 1 do
  begin
    CopyMemory(Pointer(DWord(pAll) + SEC^.VirtualAddress),
      Pointer(DWord(pLib) + DWord(SEC^.PointerToRawData)),
      SEC^.SizeOfRawData);
    SEC := Pointer(Integer(SEC) + SizeOf(TImageSectionHeader));
  end;
  if (INH^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0) then
    ChangeReloc(Pointer(INH^.OptionalHeader.ImageBase),
      pAll,
      Pointer(DWord(pAll) + INH^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress),
      INH^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size);
  CreateImportTable(pAll, Pointer(DWord(pAll) + INH^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress));
  @DllMain := Pointer(INH^.OptionalHeader.AddressOfEntryPoint + DWord(pAll));
// if (INH^.OptionalHeader.AddressOfEntryPoint <> 0) and (bDllMain) then
  if INH^.OptionalHeader.AddressOfEntryPoint <> 0 then
  begin
    try
//      if (pReserved <> nil) then
//        DllMain(DWord(pAll),DLL_PROCESS_ATTACH,DWord(pAll)+dwMemSize)
//      else
      DllMain(DWord(pAll), DLL_PROCESS_ATTACH, 0);
      DllMain(DWord(pAll), 5, Integer(@m_vtable));

    except
    end;
  end;
  Result := DWord(pAll);
end;


{ TJXManager }

function GetFileMD5(const iFileName: string): string;
var
  MemSteam: TMemoryStream;
  MyMD5: TIdHashMessageDigest5;
begin
  MemSteam := TMemoryStream.Create;
  MemSteam.LoadFromFile(iFileName);
  MyMD5 := TIdHashMessageDigest5.Create;
  Result := MyMD5.AsHex(MyMD5.HashValue(MemSteam));
  MyMD5.Free;
  MemSteam.Free;
end;

constructor TJXManager.Create;
begin
  curModule := nil;
  m_lastmd5 := '';
end;

procedure TJXManager.LoadJx;
var tmp: TJxMoudle;
  szdir: string;
  nver: Integer;
  smd5: string;
begin
  szdir := ExtractFilePath(ParamStr(0)) + '\反外挂模块\jxanti.jx';
  if not FileExists(szdir) then
  begin
    g_pLogMgr.Add('反外挂模块不存在...');
    Exit;
  end;

  smd5 := GetFileMD5(szdir);
  if smd5 = m_lastmd5 then
  begin
    g_pLogMgr.Add('反外挂模块已经存在...');
    Exit;
  end;
  m_lastmd5 := smd5;
  tmp := TJxMoudle.Create(szdir);
  if tmp.isReady then
  begin
    curModule := tmp;
  end
  else
    tmp.free;


end;





end.
