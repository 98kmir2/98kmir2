unit DLLLoader;

interface

uses Windows, Classes;

const
  IMPORTED_NAME_OFFSET = $00000002;
  IMAGE_ORDINAL_FLAG32 = $80000000;
  IMAGE_ORDINAL_MASK32 = $0000FFFF;

  RTL_CRITSECT_TYPE = 0;
  RTL_RESOURCE_TYPE = 1;

  DLL_PROCESS_ATTACH = 1;
  DLL_THREAD_ATTACH = 2;
  DLL_THREAD_DETACH = 3;
  DLL_PROCESS_DETACH = 0;

  IMAGE_SizeHeader = 20;

  IMAGE_FILE_RELOCS_STRIPPED = $0001;
  IMAGE_FILE_EXECUTABLE_IMAGE = $0002;
  IMAGE_FILE_LINE_NUMS_STRIPPED = $0004;
  IMAGE_FILE_LOCAL_SYMS_STRIPPED = $0008;
  IMAGE_FILE_AGGRESIVE_WS_TRIM = $0010;
  IMAGE_FILE_BYTES_REVERSED_LO = $0080;
  IMAGE_FILE_32BIT_MACHINE = $0100;
  IMAGE_FILE_DEBUG_STRIPPED = $0200;
  IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP = $0400;
  IMAGE_FILE_NET_RUN_FROM_SWAP = $0800;
  IMAGE_FILE_SYSTEM = $1000;
  IMAGE_FILE_DLL = $2000;
  IMAGE_FILE_UP_SYSTEM_ONLY = $4000;
  IMAGE_FILE_BYTES_REVERSED_HI = $8000;

  IMAGE_FILE_MACHINE_UNKNOWN = 0;
  IMAGE_FILE_MACHINE_I386 = $14C;
  IMAGE_FILE_MACHINE_R3000 = $162;
  IMAGE_FILE_MACHINE_R4000 = $166;
  IMAGE_FILE_MACHINE_R10000 = $168;
  IMAGE_FILE_MACHINE_ALPHA = $184;
  IMAGE_FILE_MACHINE_POWERPC = $1F0;

  IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16;

  IMAGE_SUBSYSTEM_UNKNOWN = 0;
  IMAGE_SUBSYSTEM_NATIVE = 1;
  IMAGE_SUBSYSTEM_WINDOWS_GUI = 2;
  IMAGE_SUBSYSTEM_WINDOWS_CUI = 3;
  IMAGE_SUBSYSTEM_OS2_CUI = 5;
  IMAGE_SUBSYSTEM_POSIX_CUI = 7;
  IMAGE_SUBSYSTEM_RESERVED = 8;

  IMAGE_DIRECTORY_ENTRY_EXPORT = 0;
  IMAGE_DIRECTORY_ENTRY_IMPORT = 1;
  IMAGE_DIRECTORY_ENTRY_RESOURCE = 2;
  IMAGE_DIRECTORY_ENTRY_EXCEPTION = 3;
  IMAGE_DIRECTORY_ENTRY_SECURITY = 4;
  IMAGE_DIRECTORY_ENTRY_BASERELOC = 5;
  IMAGE_DIRECTORY_ENTRY_DEBUG = 6;
  IMAGE_DIRECTORY_ENTRY_COPYRIGHT = 7;
  IMAGE_DIRECTORY_ENTRY_GLOBALPTR = 8;
  IMAGE_DIRECTORY_ENTRY_TLS = 9;
  IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG = 10;
  IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT = 11;
  IMAGE_DIRECTORY_ENTRY_IAT = 12;

  IMAGE_SIZEOF_SHORT_NAME = 8;

  IMAGE_SCN_TYIMAGE_REG = $00000000;
  IMAGE_SCN_TYIMAGE_DSECT = $00000001;
  IMAGE_SCN_TYIMAGE_NOLOAD = $00000002;
  IMAGE_SCN_TYIMAGE_GROUP = $00000004;
  IMAGE_SCN_TYIMAGE_NO_PAD = $00000008;
  IMAGE_SCN_TYIMAGE_COPY = $00000010;
  IMAGE_SCN_CNT_CODE = $00000020;
  IMAGE_SCN_CNT_INITIALIZED_DATA = $00000040;
  IMAGE_SCN_CNT_UNINITIALIZED_DATA = $00000080;
  IMAGE_SCN_LNK_OTHER = $00000100;
  IMAGE_SCN_LNK_INFO = $00000200;
  IMAGE_SCN_TYIMAGE_OVER = $0000400;
  IMAGE_SCN_LNK_REMOVE = $00000800;
  IMAGE_SCN_LNK_COMDAT = $00001000;
  IMAGE_SCN_MEM_PROTECTED = $00004000;
  IMAGE_SCN_MEM_FARDATA = $00008000;
  IMAGE_SCN_MEM_SYSHEAP = $00010000;
  IMAGE_SCN_MEM_PURGEABLE = $00020000;
  IMAGE_SCN_MEM_16BIT = $00020000;
  IMAGE_SCN_MEM_LOCKED = $00040000;
  IMAGE_SCN_MEM_PRELOAD = $00080000;
  IMAGE_SCN_ALIGN_1BYTES = $00100000;
  IMAGE_SCN_ALIGN_2BYTES = $00200000;
  IMAGE_SCN_ALIGN_4BYTES = $00300000;
  IMAGE_SCN_ALIGN_8BYTES = $00400000;
  IMAGE_SCN_ALIGN_16BYTES = $00500000;
  IMAGE_SCN_ALIGN_32BYTES = $00600000;
  IMAGE_SCN_ALIGN_64BYTES = $00700000;
  IMAGE_SCN_LNK_NRELOC_OVFL = $01000000;
  IMAGE_SCN_MEM_DISCARDABLE = $02000000;
  IMAGE_SCN_MEM_NOT_CACHED = $04000000;
  IMAGE_SCN_MEM_NOT_PAGED = $08000000;
  IMAGE_SCN_MEM_SHARED = $10000000;
  IMAGE_SCN_MEM_EXECUTE = $20000000;
  IMAGE_SCN_MEM_READ = $40000000;
  IMAGE_SCN_MEM_WRITE = LONGWORD($80000000);

  IMAGE_REL_BASED_ABSOLUTE = 0;
  IMAGE_REL_BASED_HIGH = 1;
  IMAGE_REL_BASED_LOW = 2;
  IMAGE_REL_BASED_HIGHLOW = 3;
  IMAGE_REL_BASED_HIGHADJ = 4;
  IMAGE_REL_BASED_MIPS_JMPADDR = 5;
  IMAGE_REL_BASED_SECTION = 6;
  IMAGE_REL_BASED_REL32 = 7;

  IMAGE_REL_BASED_MIPS_JMPADDR16 = 9;
  IMAGE_REL_BASED_IA64_IMM64 = 9;
  IMAGE_REL_BASED_DIR64 = 10;
  IMAGE_REL_BASED_HIGH3ADJ = 11;

  PAGE_NOACCESS = 1;
  PAGE_READONLY = 2;
  PAGE_READWRITE = 4;
  PAGE_WRITECOPY = 8;
  PAGE_EXECUTE = $10;
  PAGE_EXECUTE_READ = $20;
  PAGE_EXECUTE_READWRITE = $40;
  PAGE_EXECUTE_WRITECOPY = $80;
  PAGE_GUARD = $100;
  PAGE_NOCACHE = $200;
  MEM_COMMIT = $1000;
  MEM_RESERVE = $2000;
  MEM_DECOMMIT = $4000;
  MEM_RELEASE = $8000;
  MEM_FREE = $10000;
  MEM_PRIVATE = $20000;
  MEM_MAPPED = $40000;
  MEM_RESET = $80000;
  MEM_TOP_DOWN = $100000;
  SEC_FILE = $800000;
  SEC_IMAGE = $1000000;
  SEC_RESERVE = $4000000;
  SEC_COMMIT = $8000000;
  SEC_NOCACHE = $10000000;
  MEM_IMAGE = SEC_IMAGE;

type
  PPOINTER = ^POINTER;

  PLONGWORD = ^LONGWORD;
  PPLONGWORD = ^PLONGWORD;

  PWORD = ^WORD;
  PPWORD = ^PWORD;

  HINST = LONGWORD;
  HMODULE = HINST;

  PWordArray = ^TWordArray;
  TWordArray = array[0..(2147483647 div SIZEOF(WORD)) - 1] of WORD;

  PLongWordArray = ^TLongWordArray;
  TLongWordArray = array[0..(2147483647 div SIZEOF(LONGWORD)) - 1] of LONGWORD;

  PImageDOSHeader = ^TImageDOSHeader;
  TImageDOSHeader = packed record
    Signature: WORD;
    PartPag: WORD;
    PageCnt: WORD;
    ReloCnt: WORD;
    HdrSize: WORD;
    MinMem: WORD;
    MaxMem: WORD;
    ReloSS: WORD;
    ExeSP: WORD;
    ChkSum: WORD;
    ExeIP: WORD;
    ReloCS: WORD;
    TablOff: WORD;
    Overlay: WORD;
    Reserved: packed array[0..3] of WORD;
    OEMID: WORD;
    OEMInfo: WORD;
    Reserved2: packed array[0..9] of WORD;
    LFAOffset: LONGWORD;
  end;

  TISHMisc = packed record
    case INTEGER of
      0: (PhysicalAddress: LONGWORD);
      1: (VirtualSize: LONGWORD);
  end;

  PImageExportDirectory = ^TImageExportDirectory;
  TImageExportDirectory = packed record
    Characteristics: LONGWORD;
    TimeDateStamp: LONGWORD;
    MajorVersion: WORD;
    MinorVersion: WORD;
    Name: LONGWORD;
    Base: LONGWORD;
    NumberOfFunctions: LONGWORD;
    NumberOfNames: LONGWORD;
    AddressOfFunctions: PPLONGWORD;
    AddressOfNames: PPLONGWORD;
    AddressOfNameOrdinals: PPWORD;
  end;

  PImageSectionHeader = ^TImageSectionHeader;
  TImageSectionHeader = packed record
    Name: packed array[0..IMAGE_SIZEOF_SHORT_NAME - 1] of BYTE;
    Misc: TISHMisc;
    VirtualAddress: LONGWORD;
    SizeOfRawData: LONGWORD;
    PointerToRawData: LONGWORD;
    PointerToRelocations: LONGWORD;
    PointerToLinenumbers: LONGWORD;
    NumberOfRelocations: WORD;
    NumberOfLinenumbers: WORD;
    Characteristics: LONGWORD;
  end;

  PImageSectionHeaders = ^TImageSectionHeaders;
  TImageSectionHeaders = array[0..(2147483647 div SIZEOF(TImageSectionHeader)) - 1] of TImageSectionHeader;

  PImageDataDirectory = ^TImageDataDirectory;
  TImageDataDirectory = packed record
    VirtualAddress: LONGWORD;
    Size: LONGWORD;
  end;

  PImageFileHeader = ^TImageFileHeader;
  TImageFileHeader = packed record
    Machine: WORD;
    NumberOfSections: WORD;
    TimeDateStamp: LONGWORD;
    PointerToSymbolTable: LONGWORD;
    NumberOfSymbols: LONGWORD;
    SizeOfOptionalHeader: WORD;
    Characteristics: WORD;
  end;

  PImageOptionalHeader = ^TImageOptionalHeader;
  TImageOptionalHeader = packed record
    Magic: WORD;
    MajorLinkerVersion: BYTE;
    MinorLinkerVersion: BYTE;
    SizeOfCode: LONGWORD;
    SizeOfInitializedData: LONGWORD;
    SizeOfUninitializedData: LONGWORD;
    AddressOfEntryPoint: LONGWORD;
    BaseOfCode: LONGWORD;
    BaseOfData: LONGWORD;
    ImageBase: LONGWORD;
    SectionAlignment: LONGWORD;
    FileAlignment: LONGWORD;
    MajorOperatingSystemVersion: WORD;
    MinorOperatingSystemVersion: WORD;
    MajorImageVersion: WORD;
    MinorImageVersion: WORD;
    MajorSubsystemVersion: WORD;
    MinorSubsystemVersion: WORD;
    Win32VersionValue: LONGWORD;
    SizeOfImage: LONGWORD;
    SizeOfHeaders: LONGWORD;
    CheckSum: LONGWORD;
    Subsystem: WORD;
    DllCharacteristics: WORD;
    SizeOfStackReserve: LONGWORD;
    SizeOfStackCommit: LONGWORD;
    SizeOfHeapReserve: LONGWORD;
    SizeOfHeapCommit: LONGWORD;
    LoaderFlags: LONGWORD;
    NumberOfRvaAndSizes: LONGWORD;
    DataDirectory: packed array[0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES - 1] of TImageDataDirectory;
  end;

  PImageNTHeaders = ^TImageNTHeaders;
  TImageNTHeaders = packed record
    Signature: LONGWORD;
    FileHeader: TImageFileHeader;
    OptionalHeader: TImageOptionalHeader;
  end;

  PImageImportDescriptor = ^TImageImportDescriptor;
  TImageImportDescriptor = packed record
    OriginalFirstThunk: LONGWORD;
    TimeDateStamp: LONGWORD;
    ForwarderChain: LONGWORD;
    Name: LONGWORD;
    FirstThunk: LONGWORD;
  end;

  PImageBaseRelocation = ^TImageBaseRelocation;
  TImageBaseRelocation = packed record
    VirtualAddress: LONGWORD;
    SizeOfBlock: LONGWORD;
  end;

  PImageThunkData = ^TImageThunkData;
  TImageThunkData = packed record
    ForwarderString: LONGWORD;
    Funktion: LONGWORD;
    Ordinal: LONGWORD;
    AddressOfData: LONGWORD;
  end;

  PSection = ^TSection;
  TSection = packed record
    Base: POINTER;
    RVA: LONGWORD;
    Size: LONGWORD;
    Characteristics: LONGWORD;
  end;

  TSections = array of TSection;

  TDLLEntryProc = function(hinstDLL: HMODULE; dwReason: LONGWORD; lpvReserved: POINTER): BOOLEAN; STDCALL;

  TNameOrID = (niName, niID);

  TExternalLibrary = record
    LibraryName: string;
    LibraryHandle: HINST;
  end;

  TExternalLibrarys = array of TExternalLibrary;

  PDLLFunctionImport = ^TDLLFunctionImport;
  TDLLFunctionImport = record
    NameOrID: TNameOrID;
    Name: string;
    ID: INTEGER;
  end;

  PDLLImport = ^TDLLImport;
  TDLLImport = record
    LibraryName: string;
    LibraryHandle: HINST;
    Entries: array of TDLLFunctionImport;
  end;

  TImports = array of TDLLImport;

  PDLLFunctionExport = ^TDLLFunctionExport;
  TDLLFunctionExport = record
    Name: string;
    Index: INTEGER;
    FunctionPointer: POINTER;
  end;

  TExports = array of TDLLFunctionExport;

  TExportTreeLink = POINTER;

  PExportTreeNode = ^TExportTreeNode;
  TExportTreeNode = record
    TheChar: CHAR;
    Link: TExportTreeLink;
    LinkExist: BOOLEAN;
    Prevoius, Next, Up, Down: PExportTreeNode;
  end;

  TExportTree = class
  private
    Root: PExportTreeNode;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Dump;
    function Add(FunctionName: string; Link: TExportTreeLink): BOOLEAN;
    function Delete(FunctionName: string): BOOLEAN;
    function Find(FunctionName: string; var Link: TExportTreeLink): BOOLEAN;
  end;

  TDLLLoader = class
  private
    ImageBase: POINTER;
    ImageBaseDelta: INTEGER;
    DLLProc: TDLLEntryProc;
    ExternalLibraryArray: TExternalLibrarys;
    ImportArray: TImports;
    ExportArray: TExports;
    Sections: TSections;
    ExportTree: TExportTree;
    function FindExternalLibrary(LibraryName: string): INTEGER;
    function LoadExternalLibrary(LibraryName: string): INTEGER;
    function GetExternalLibraryHandle(LibraryName: string): HINST;
  public
    constructor Create;
    destructor Destroy; override;
    function Load(Stream: TStream): BOOLEAN;
    function Unload: BOOLEAN;
    function FindExport(FunctionName: string): POINTER;
    function FindExportPerIndex(FunctionIndex: INTEGER): POINTER;
    function GetExportList: TStringList;
  end;

implementation

function StrToInt(S: string): INTEGER;
var
  C: INTEGER;
begin
  VAL(S, RESULT, C);
end;

function CreateExportTreeNode(AChar: CHAR): PExportTreeNode;
begin
  GETMEM(RESULT, SIZEOF(TExportTreeNode));
  RESULT^.TheChar := AChar;
  RESULT^.Link := nil;
  RESULT^.LinkExist := FALSE;
  RESULT^.Prevoius := nil;
  RESULT^.Next := nil;
  RESULT^.Up := nil;
  RESULT^.Down := nil;
end;

procedure DestroyExportTreeNode(Node: PExportTreeNode);
begin
  if ASSIGNED(Node) then begin
    DestroyExportTreeNode(Node^.Next);
    DestroyExportTreeNode(Node^.Down);
    FREEMEM(Node);
  end;
end;

constructor TExportTree.Create;
begin
  inherited Create;
  Root := nil;
end;

destructor TExportTree.Destroy;
begin
  DestroyExportTreeNode(Root);
  inherited Destroy;
end;

procedure TExportTree.Dump;
var
  Ident: INTEGER;
  procedure DumpNode(Node: PExportTreeNode);
  var
    SubNode: PExportTreeNode;
    IdentCounter, IdentOld: INTEGER;
  begin
    for IdentCounter := 1 to Ident do
      WRITE(' ');
    WRITE(Node^.TheChar);
    IdentOld := Ident;
    SubNode := Node^.Next;
    while ASSIGNED(SubNode) do begin
      WRITE(SubNode.TheChar);
      if not ASSIGNED(SubNode^.Next) then
        BREAK;
      INC(Ident);
      SubNode := SubNode^.Next;
    end;
    WRITELN;
    INC(Ident);
    while ASSIGNED(SubNode) and (SubNode <> Node) do begin
      if ASSIGNED(SubNode^.Down) then
        DumpNode(SubNode^.Down);
      SubNode := SubNode^.Prevoius;
      DEC(Ident);
    end;
    Ident := IdentOld;
    if ASSIGNED(Node^.Down) then
      DumpNode(Node^.Down);
  end;
begin
  Ident := 0;
  DumpNode(Root);
end;

function TExportTree.Add(FunctionName: string; Link: TExportTreeLink): BOOLEAN;
var
  StringLength, Position, PositionCounter: INTEGER;
  NewNode, LastNode, Node: PExportTreeNode;
  StringChar, NodeChar: CHAR;
begin
  RESULT := FALSE;
  StringLength := LENGTH(FunctionName);
  if StringLength > 0 then begin
    LastNode := nil;
    Node := Root;
    for Position := 1 to StringLength do begin
      StringChar := FunctionName[Position];
      if ASSIGNED(Node) then begin
        NodeChar := Node^.TheChar;
        if NodeChar = StringChar then begin
          LastNode := Node;
          Node := Node^.Next;
        end
        else begin
          while (NodeChar < StringChar) and ASSIGNED(Node^.Down) do begin
            Node := Node^.Down;
            NodeChar := Node^.TheChar;
          end;
          if NodeChar = StringChar then begin
            LastNode := Node;
            Node := Node^.Next;
          end
          else begin
            NewNode := CreateExportTreeNode(StringChar);
            if NodeChar < StringChar then begin
              NewNode^.Down := Node^.Down;
              NewNode^.Up := Node;
              if ASSIGNED(NewNode^.Down) then begin
                NewNode^.Down^.Up := NewNode;
              end;
              NewNode^.Prevoius := Node^.Prevoius;
              Node^.Down := NewNode;
            end
            else if NodeChar > StringChar then begin
              NewNode^.Down := Node;
              NewNode^.Up := Node^.Up;
              if ASSIGNED(NewNode^.Up) then begin
                NewNode^.Up^.Down := NewNode;
              end;
              NewNode^.Prevoius := Node^.Prevoius;
              if not ASSIGNED(NewNode^.Up) then begin
                if ASSIGNED(NewNode^.Prevoius) then begin
                  NewNode^.Prevoius^.Next := NewNode;
                end
                else begin
                  Root := NewNode;
                end;
              end;
              Node^.Up := NewNode;
            end;
            LastNode := NewNode;
            Node := LastNode^.Next;
          end;
        end;
      end
      else begin
        for PositionCounter := Position to StringLength do begin
          NewNode := CreateExportTreeNode(FunctionName[PositionCounter]);
          if ASSIGNED(LastNode) then begin
            NewNode^.Prevoius := LastNode;
            LastNode^.Next := NewNode;
            LastNode := LastNode^.Next;
          end
          else begin
            if not ASSIGNED(Root) then begin
              Root := NewNode;
              LastNode := Root;
            end;
          end;
        end;
        BREAK;
      end;
    end;
    if ASSIGNED(LastNode) then begin
      if not LastNode^.LinkExist then begin
        LastNode^.Link := Link;
        LastNode^.LinkExist := TRUE;
        RESULT := TRUE;
      end;
    end;
  end;
end;

function TExportTree.Delete(FunctionName: string): BOOLEAN;
var
  StringLength, Position: INTEGER;
  Node: PExportTreeNode;
  StringChar, NodeChar: CHAR;
begin
  RESULT := FALSE;
  StringLength := LENGTH(FunctionName);
  if StringLength > 0 then begin
    Node := Root;
    for Position := 1 to StringLength do begin
      StringChar := FunctionName[Position];
      if ASSIGNED(Node) then begin
        NodeChar := Node^.TheChar;
        while (NodeChar <> StringChar) and ASSIGNED(Node^.Down) do begin
          Node := Node^.Down;
          NodeChar := Node^.TheChar;
        end;
        if NodeChar = StringChar then begin
          if (Position = StringLength) and Node^.LinkExist then begin
            Node^.LinkExist := FALSE;
            RESULT := TRUE;
            BREAK;
          end;
          Node := Node^.Next;
        end;
      end
      else begin
        BREAK;
      end;
    end;
  end;
end;

function TExportTree.Find(FunctionName: string; var Link: TExportTreeLink): BOOLEAN;
var
  StringLength, Position: INTEGER;
  Node: PExportTreeNode;
  StringChar, NodeChar: CHAR;
begin
  RESULT := FALSE;
  StringLength := LENGTH(FunctionName);
  if StringLength > 0 then begin
    Node := Root;
    for Position := 1 to StringLength do begin
      StringChar := FunctionName[Position];
      if ASSIGNED(Node) then begin
        NodeChar := Node^.TheChar;
        while (NodeChar <> StringChar) and ASSIGNED(Node^.Down) do begin
          Node := Node^.Down;
          NodeChar := Node^.TheChar;
        end;
        if NodeChar = StringChar then begin
          if (Position = StringLength) and Node^.LinkExist then begin
            Link := Node^.Link;
            RESULT := TRUE;
            BREAK;
          end;
          Node := Node^.Next;
        end;
      end
      else begin
        BREAK;
      end;
    end;
  end;
end;

constructor TDLLLoader.Create;
begin
  inherited Create;
  ImageBase := nil;
  DLLProc := nil;
  ExternalLibraryArray := nil;
  ImportArray := nil;
  ExportArray := nil;
  Sections := nil;
  ExportTree := nil;
end;

destructor TDLLLoader.Destroy;
begin
  if @DLLProc <> nil then
    Unload;
  if ASSIGNED(ExportTree) then
    ExportTree.Destroy;
  inherited Destroy;
end;

function TDLLLoader.FindExternalLibrary(LibraryName: string): INTEGER;
var
  I: INTEGER;
begin
  RESULT := -1;
  for I := 0 to LENGTH(ExternalLibraryArray) - 1 do begin
    if ExternalLibraryArray[I].LibraryName = LibraryName then begin
      RESULT := I;
      EXIT;
    end;
  end;
end;

function TDLLLoader.LoadExternalLibrary(LibraryName: string): INTEGER;
begin
  RESULT := FindExternalLibrary(LibraryName);
  if RESULT < 0 then begin
    RESULT := LENGTH(ExternalLibraryArray);
    SETLENGTH(ExternalLibraryArray, LENGTH(ExternalLibraryArray) + 1);
    ExternalLibraryArray[RESULT].LibraryName := LibraryName;
    ExternalLibraryArray[RESULT].LibraryHandle := LoadLibrary(PCHAR(LibraryName));
  end;
end;

function TDLLLoader.GetExternalLibraryHandle(LibraryName: string): LONGWORD;
var
  I: INTEGER;
begin
  RESULT := 0;
  for I := 0 to LENGTH(ExternalLibraryArray) - 1 do begin
    if ExternalLibraryArray[I].LibraryName = LibraryName then begin
      RESULT := ExternalLibraryArray[I].LibraryHandle;
      EXIT;
    end;
  end;
end;

function TDLLLoader.Load(Stream: TStream): BOOLEAN;
var
  ImageDOSHeader: TImageDOSHeader;
  ImageNTHeaders: TImageNTHeaders;
  OldProtect: LONGWORD;
  function ConvertPointer(RVA: LONGWORD): POINTER;
  var
    I: INTEGER;
  begin
    RESULT := nil;
    for I := 0 to LENGTH(Sections) - 1 do begin
      if (RVA < (Sections[I].RVA + Sections[I].Size)) and (RVA >= Sections[I].RVA) then begin
        RESULT := POINTER(LONGWORD((RVA - LONGWORD(Sections[I].RVA)) + LONGWORD(Sections[I].Base)));
        EXIT;
      end;
    end;
  end;
  function ReadImageHeaders: BOOLEAN;
  begin
    RESULT := FALSE;
    if Stream.Size > 0 then begin
      FILLCHAR(ImageNTHeaders, SIZEOF(TImageNTHeaders), #0);
      if Stream.Read(ImageDOSHeader, SIZEOF(TImageDOSHeader)) <> SIZEOF(TImageDOSHeader) then
        EXIT;
      if ImageDOSHeader.Signature <> $5A4D then
        EXIT;
      if Stream.Seek(ImageDOSHeader.LFAOffset, soFromBeginning) <> LONGINT(ImageDOSHeader.LFAOffset) then
        EXIT;
      if Stream.Read(ImageNTHeaders.Signature, SIZEOF(LONGWORD)) <> SIZEOF(LONGWORD) then
        EXIT;
      if ImageNTHeaders.Signature <> $00004550 then
        EXIT;
      if Stream.Read(ImageNTHeaders.FileHeader, SIZEOF(TImageFileHeader)) <> SIZEOF(TImageFileHeader) then
        EXIT;
      if ImageNTHeaders.FileHeader.Machine <> $14C then
        EXIT;
      if Stream.Read(ImageNTHeaders.OptionalHeader, ImageNTHeaders.FileHeader.SizeOfOptionalHeader) <>
        ImageNTHeaders.FileHeader.SizeOfOptionalHeader then
        EXIT;
      RESULT := TRUE;
    end;
  end;
  function InitializeImage: BOOLEAN;
  var
    SectionBase: POINTER;
    OldPosition: INTEGER;
  begin
    RESULT := FALSE;
    if ImageNTHeaders.FileHeader.NumberOfSections > 0 then begin
      ImageBase := VirtualAlloc(nil, ImageNTHeaders.OptionalHeader.SizeOfImage, MEM_RESERVE, PAGE_NOACCESS);
      ImageBaseDelta := LONGWORD(ImageBase) - ImageNTHeaders.OptionalHeader.ImageBase;
      SectionBase := VirtualAlloc(ImageBase, ImageNTHeaders.OptionalHeader.SizeOfHeaders, MEM_COMMIT, PAGE_READWRITE);
      OldPosition := Stream.Position;
      Stream.Seek(0, soFromBeginning);
      Stream.Read(SectionBase^, ImageNTHeaders.OptionalHeader.SizeOfHeaders);
      VirtualProtect(SectionBase, ImageNTHeaders.OptionalHeader.SizeOfHeaders, PAGE_READONLY, OldProtect);
      Stream.Seek(OldPosition, soFromBeginning);
      RESULT := TRUE;
    end;
  end;
  function ReadSections: BOOLEAN;
  var
    I: INTEGER;
    Section: TImageSectionHeader;
    SectionHeaders: PImageSectionHeaders;
  begin
    RESULT := FALSE;
    if ImageNTHeaders.FileHeader.NumberOfSections > 0 then begin
      GETMEM(SectionHeaders, ImageNTHeaders.FileHeader.NumberOfSections * SIZEOF(TImageSectionHeader));
      if Stream.Read(SectionHeaders^, (ImageNTHeaders.FileHeader.NumberOfSections * SIZEOF(TImageSectionHeader))) <>
        (ImageNTHeaders.FileHeader.NumberOfSections * SIZEOF(TImageSectionHeader)) then
        EXIT;
      SETLENGTH(Sections, ImageNTHeaders.FileHeader.NumberOfSections);
      for I := 0 to ImageNTHeaders.FileHeader.NumberOfSections - 1 do begin
        Section := SectionHeaders^[I];
        Sections[I].RVA := Section.VirtualAddress;
        Sections[I].Size := Section.SizeOfRawData;
        if Sections[I].Size < Section.Misc.VirtualSize then begin
          Sections[I].Size := Section.Misc.VirtualSize;
        end;
        Sections[I].Characteristics := Section.Characteristics;
        Sections[I].Base := VirtualAlloc(POINTER(LONGWORD(Sections[I].RVA + LONGWORD(ImageBase))), Sections[I].Size,
          MEM_COMMIT, PAGE_READWRITE);
        FILLCHAR(Sections[I].Base^, Sections[I].Size, #0);
        if Section.PointerToRawData <> 0 then begin
          Stream.Seek(Section.PointerToRawData, soFromBeginning);
          if Stream.Read(Sections[I].Base^, Section.SizeOfRawData) <> LONGINT(Section.SizeOfRawData) then
            EXIT;
        end;
      end;
      FREEMEM(SectionHeaders);
      RESULT := TRUE;
    end;
  end;
  function ProcessRelocations: BOOLEAN;
  var
    Relocations: PCHAR;
    Position: LONGWORD;
    BaseRelocation: PImageBaseRelocation;
    Base: POINTER;
    NumberOfRelocations: LONGWORD;
    Relocation: PWordArray;
    RelocationCounter: LONGINT;
    RelocationPointer: POINTER;
    RelocationType: LONGWORD;
  begin
    if ImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0 then begin
      RESULT := FALSE;
      Relocations :=
        ConvertPointer(ImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress);
      Position := 0;
      while ASSIGNED(Relocations) and (Position <
        ImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size) do begin
        BaseRelocation := PImageBaseRelocation(Relocations);
        Base := ConvertPointer(BaseRelocation^.VirtualAddress);
        if not ASSIGNED(Base) then
          EXIT;
        NumberOfRelocations := (BaseRelocation^.SizeOfBlock - SIZEOF(TImageBaseRelocation)) div SIZEOF(WORD);
        Relocation := POINTER(LONGWORD(LONGWORD(BaseRelocation) + SIZEOF(TImageBaseRelocation)));
        for RelocationCounter := 0 to NumberOfRelocations - 1 do begin
          RelocationPointer := POINTER(LONGWORD(LONGWORD(Base) + (Relocation^[RelocationCounter] and $FFF)));
          RelocationType := Relocation^[RelocationCounter] shr 12;
          case RelocationType of
            IMAGE_REL_BASED_ABSOLUTE: begin
              end;
            IMAGE_REL_BASED_HIGH: begin
                PWORD(RelocationPointer)^ := (LONGWORD(((LONGWORD(PWORD(RelocationPointer)^ + LONGWORD(ImageBase) -
                  ImageNTHeaders.OptionalHeader.ImageBase)))) shr 16) and $FFFF;
              end;
            IMAGE_REL_BASED_LOW: begin
                PWORD(RelocationPointer)^ := LONGWORD(((LONGWORD(PWORD(RelocationPointer)^ + LONGWORD(ImageBase) -
                  ImageNTHeaders.OptionalHeader.ImageBase)))) and $FFFF;
              end;
            IMAGE_REL_BASED_HIGHLOW: begin
                PPOINTER(RelocationPointer)^ := POINTER((LONGWORD(LONGWORD(PPOINTER(RelocationPointer)^) + LONGWORD(ImageBase)
                  - ImageNTHeaders.OptionalHeader.ImageBase)));
              end;
            IMAGE_REL_BASED_HIGHADJ: begin
                // ???
              end;
            IMAGE_REL_BASED_MIPS_JMPADDR: begin
                // Only for MIPS CPUs ;)
              end;
          end;
        end;
        Relocations := POINTER(LONGWORD(LONGWORD(Relocations) + BaseRelocation^.SizeOfBlock));
        INC(Position, BaseRelocation^.SizeOfBlock);
      end;
    end;
    RESULT := TRUE;
  end;
  function ProcessImports: BOOLEAN;
  var
    ImportDescriptor: PImageImportDescriptor;
    ThunkData: PLONGWORD;
    Name: PCHAR;
    DLLImport: PDLLImport;
    DLLFunctionImport: PDLLFunctionImport;
    FunctionPointer: POINTER;
  begin
    if ImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress <> 0 then begin
      ImportDescriptor :=
        ConvertPointer(ImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress);
      if ASSIGNED(ImportDescriptor) then begin
        SETLENGTH(ImportArray, 0);
        while ImportDescriptor^.Name <> 0 do begin
          Name := ConvertPointer(ImportDescriptor^.Name);
          SETLENGTH(ImportArray, LENGTH(ImportArray) + 1);
          LoadExternalLibrary(Name);
          DLLImport := @ImportArray[LENGTH(ImportArray) - 1];
          DLLImport^.LibraryName := Name;
          DLLImport^.LibraryHandle := GetExternalLibraryHandle(Name);
          DLLImport^.Entries := nil;
          if ImportDescriptor^.TimeDateStamp = 0 then begin
            ThunkData := ConvertPointer(ImportDescriptor^.FirstThunk);
          end
          else begin
            ThunkData := ConvertPointer(ImportDescriptor^.OriginalFirstThunk);
          end;
          while ThunkData^ <> 0 do begin
            SETLENGTH(DLLImport^.Entries, LENGTH(DLLImport^.Entries) + 1);
            DLLFunctionImport := @DLLImport^.Entries[LENGTH(DLLImport^.Entries) - 1];
            if (ThunkData^ and IMAGE_ORDINAL_FLAG32) <> 0 then begin
              DLLFunctionImport^.NameOrID := niID;
              DLLFunctionImport^.ID := ThunkData^ and IMAGE_ORDINAL_MASK32;
              DLLFunctionImport^.Name := '';
              FunctionPointer := GetProcAddress(DLLImport^.LibraryHandle, PCHAR(ThunkData^ and IMAGE_ORDINAL_MASK32));
            end
            else begin
              Name := ConvertPointer(LONGWORD(ThunkData^) + IMPORTED_NAME_OFFSET);
              DLLFunctionImport^.NameOrID := niName;
              DLLFunctionImport^.ID := 0;
              DLLFunctionImport^.Name := Name;
              FunctionPointer := GetProcAddress(DLLImport^.LibraryHandle, Name);
            end;
            PPOINTER(Thunkdata)^ := FunctionPointer;
            INC(ThunkData);
          end;
          INC(ImportDescriptor);
        end;
      end;
    end;
    RESULT := TRUE;
  end;
  function ProtectSections: BOOLEAN;
  var
    I: INTEGER;
    Characteristics: LONGWORD;
    Flags: LONGWORD;
  begin
    RESULT := FALSE;
    if ImageNTHeaders.FileHeader.NumberOfSections > 0 then begin
      for I := 0 to ImageNTHeaders.FileHeader.NumberOfSections - 1 do begin
        Characteristics := Sections[I].Characteristics;
        Flags := 0;
        if (Characteristics and IMAGE_SCN_MEM_EXECUTE) <> 0 then begin
          if (Characteristics and IMAGE_SCN_MEM_READ) <> 0 then begin
            if (Characteristics and IMAGE_SCN_MEM_WRITE) <> 0 then begin
              Flags := Flags or PAGE_EXECUTE_READWRITE;
            end
            else begin
              Flags := Flags or PAGE_EXECUTE_READ;
            end;
          end
          else if (Characteristics and IMAGE_SCN_MEM_WRITE) <> 0 then begin
            Flags := Flags or PAGE_EXECUTE_WRITECOPY;
          end
          else begin
            Flags := Flags or PAGE_EXECUTE;
          end;
        end
        else if (Characteristics and IMAGE_SCN_MEM_READ) <> 0 then begin
          if (Characteristics and IMAGE_SCN_MEM_WRITE) <> 0 then begin
            Flags := Flags or PAGE_READWRITE;
          end
          else begin
            Flags := Flags or PAGE_READONLY;
          end;
        end
        else if (Characteristics and IMAGE_SCN_MEM_WRITE) <> 0 then begin
          Flags := Flags or PAGE_WRITECOPY;
        end
        else begin
          Flags := Flags or PAGE_NOACCESS;
        end;
        if (Characteristics and IMAGE_SCN_MEM_NOT_CACHED) <> 0 then begin
          Flags := Flags or PAGE_NOCACHE;
        end;
        VirtualProtect(Sections[I].Base, Sections[I].Size, Flags, OldProtect);
      end;
      RESULT := TRUE;
    end;
  end;
  function InitializeLibrary: BOOLEAN;
  begin
    RESULT := FALSE;
    @DLLProc := ConvertPointer(ImageNTHeaders.OptionalHeader.AddressOfEntryPoint);
    if DLLProc(CARDINAL(ImageBase), DLL_PROCESS_ATTACH, nil) then begin
      RESULT := TRUE;
    end;
  end;
  function ProcessExports: BOOLEAN;
  var
    I: INTEGER;
    ExportDirectory: PImageExportDirectory;
    ExportDirectorySize: LONGWORD;
    FunctionNamePointer: POINTER;
    FunctionName: PCHAR;
    FunctionIndexPointer: POINTER;
    FunctionIndex: LONGWORD;
    FunctionPointer: POINTER;
    ForwarderCharPointer: PCHAR;
    ForwarderString: string;
    ForwarderLibrary: string;
    ForwarderLibraryHandle: HINST;
    function ParseStringToNumber(AString: string): LONGWORD;
    var
      CharCounter: INTEGER;
    begin
      RESULT := 0;
      for CharCounter := 0 to LENGTH(AString) - 1 do begin
        if AString[CharCounter] in ['0'..'9'] then begin
          RESULT := (RESULT * 10) + BYTE(BYTE(AString[CharCounter]) - BYTE('0'));
        end
        else begin
          EXIT;
        end;
      end;
    end;
  begin
    if ImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress <> 0 then begin
      ExportTree := TExportTree.Create;
      ExportDirectory :=
        ConvertPointer(ImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress);
      if ASSIGNED(ExportDirectory) then begin
        ExportDirectorySize := ImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].Size;
        SETLENGTH(ExportArray, ExportDirectory^.NumberOfNames);
        for I := 0 to ExportDirectory^.NumberOfNames - 1 do begin
          FunctionNamePointer := ConvertPointer(LONGWORD(ExportDirectory^.AddressOfNames));
          FunctionNamePointer := ConvertPointer(PLongWordArray(FunctionNamePointer)^[I]);
          FunctionName := FunctionNamePointer;
          FunctionIndexPointer := ConvertPointer(LONGWORD(ExportDirectory^.AddressOfNameOrdinals));
          FunctionIndex := PWordArray(FunctionIndexPointer)^[I];
          FunctionPointer := ConvertPointer(LONGWORD(ExportDirectory^.AddressOfFunctions));
          FunctionPointer := ConvertPointer(PLongWordArray(FunctionPointer)^[FunctionIndex]);
          ExportArray[I].Name := FunctionName;
          ExportArray[I].Index := FunctionIndex;
          if (LONGWORD(ExportDirectory) < LONGWORD(FunctionPointer)) and (LONGWORD(FunctionPointer) <
            (LONGWORD(ExportDirectory) + ExportDirectorySize)) then begin
            ForwarderCharPointer := FunctionPointer;
            ForwarderString := ForwarderCharPointer;
            while ForwarderCharPointer^ <> '.' do
              INC(ForwarderCharPointer);
            ForwarderLibrary := COPY(ForwarderString, 1, POS('.', ForwarderString) - 1);
            LoadExternalLibrary(ForwarderLibrary);
            ForwarderLibraryHandle := GetExternalLibraryHandle(ForwarderLibrary);
            if ForwarderCharPointer^ = '#' then begin
              INC(ForwarderCharPointer);
              ForwarderString := ForwarderCharPointer;
              ForwarderCharPointer := ConvertPointer(ParseStringToNumber(ForwarderString));
              ForwarderString := ForwarderCharPointer;
            end
            else begin
              ForwarderString := ForwarderCharPointer;
              ExportArray[I].FunctionPointer := GetProcAddress(ForwarderLibraryHandle, PCHAR(ForwarderString));
            end;
          end
          else begin
            ExportArray[I].FunctionPointer := FunctionPointer;
          end;
          ExportTree.Add(ExportArray[I].Name, ExportArray[I].FunctionPointer);
        end
      end;
    end;
    RESULT := TRUE;
  end;
begin
  RESULT := FALSE;
  if ASSIGNED(Stream) then begin
    Stream.Seek(0, soFromBeginning);
    if Stream.Size > 0 then begin
      if ReadImageHeaders then begin
        if InitializeImage then begin
          if ReadSections then begin
            if ProcessRelocations then begin
              if ProcessImports then begin
                if ProtectSections then begin
                  if InitializeLibrary then begin
                    if ProcessExports then begin
                      RESULT := TRUE;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TDLLLoader.Unload: BOOLEAN;
var
  I, J: INTEGER;
begin
  RESULT := FALSE;
  if @DLLProc <> nil then begin
    DLLProc(LONGWORD(ImageBase), DLL_PROCESS_DETACH, nil);
  end;
  for I := 0 to LENGTH(Sections) - 1 do begin
    if ASSIGNED(Sections[I].Base) then begin
      VirtualFree(Sections[I].Base, 0, MEM_RELEASE);
    end;
  end;
  SETLENGTH(Sections, 0);
  for I := 0 to LENGTH(ExternalLibraryArray) - 1 do begin
    ExternalLibraryArray[I].LibraryName := '';
    FreeLibrary(ExternalLibraryArray[I].LibraryHandle);
  end;
  SETLENGTH(ExternalLibraryArray, 0);
  for I := 0 to LENGTH(ImportArray) - 1 do begin
    for J := 0 to LENGTH(ImportArray[I].Entries) - 1 do begin
      ImportArray[I].Entries[J].Name := '';
    end;
    SETLENGTH(ImportArray[I].Entries, 0);
  end;
  SETLENGTH(ImportArray, 0);
  for I := 0 to LENGTH(ExportArray) - 1 do
    ExportArray[I].Name := '';
  SETLENGTH(ExportArray, 0);
  VirtualFree(ImageBase, 0, MEM_RELEASE);
  if ASSIGNED(ExportTree) then begin
    ExportTree.Destroy;
    ExportTree := nil;
  end;
end;

function TDLLLoader.FindExport(FunctionName: string): POINTER;
var
  I: INTEGER;
begin
  RESULT := nil;
  if ASSIGNED(ExportTree) then begin
    ExportTree.Find(FunctionName, RESULT);
  end
  else begin
    for I := 0 to LENGTH(ExportArray) - 1 do begin
      if ExportArray[I].Name = FunctionName then begin
        RESULT := ExportArray[I].FunctionPointer;
        EXIT;
      end;
    end;
  end;
end;

function TDLLLoader.FindExportPerIndex(FunctionIndex: INTEGER): POINTER;
var
  I: INTEGER;
begin
  RESULT := nil;
  for I := 0 to LENGTH(ExportArray) - 1 do begin
    if ExportArray[I].Index = FunctionIndex then begin
      RESULT := ExportArray[I].FunctionPointer;
      EXIT;
    end;
  end;
end;

function TDLLLoader.GetExportList: TStringList;
var
  I: INTEGER;
begin
  RESULT := TStringList.Create;
  for I := 0 to LENGTH(ExportArray) - 1 do
    RESULT.Add(ExportArray[I].Name);
  RESULT.Sort;
end;

end.

