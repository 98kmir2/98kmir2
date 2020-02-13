{--------------------------------------------}
{$INCLUDE LS_DMA.inc}
const
  IDENTIFY_BUFFER_SIZE      = 512;
  SMB_BIOSINFO              = 0;        // BIOS Information
  SMB_SYSINFO               = 1;        // System Information
  SMB_BASEINFO              = 2;        // Base Board Information
  SMB_SYSENC                = 3;        // System Enclosure or Chassis
  SMB_CPU                   = 4;        // Processor Information
  SMB_MEMCTRL               = 5;        // Memory Controller Information
  SMB_MEMMOD                = 6;        // Memory Module Information
  SMB_CACHE                 = 7;        // Cache Information
  SMB_PORTCON               = 8;        // Port Connector Information
  SMB_SLOTS                 = 9;        // System Slots
  SMB_ONBOARD               = 10;       // On Board Devices Information
  SMB_OEMSTR                = 11;       // OEM Strings
  SMB_SYSCFG                = 12;       // System Configuration Options
  SMB_LANG                  = 13;       // BIOS Language Information
  SMB_GRP                   = 14;       // Group Associations
  SMB_EVENT                 = 15;       // System Event Log
  SMB_PHYSMEM               = 16;       // Physical Memory Array
  SMB_MEMDEV                = 17;       // Memory Device
  SMB_MEMERR32              = 18;       // 32-bit Memory Error Information
  SMB_MEMMAP                = 19;       // Memory Array Mapped Address
  SMB_MEMDEVMAP             = 20;       // Memory Device Mapped Address
  SMB_POINTER               = 21;       // Built-in Pointing Device
  SMB_BATTERY               = 22;       // Portable Battery
  SMB_RESET                 = 23;       // System Reset
  SMB_SECURITY              = 24;       // Hardware Security
  SMB_POWER                 = 25;       // System Power Controls
  SMB_VOLTAGE               = 26;       // Voltage Probe
  SMB_COOL                  = 27;       // Cooling Device
  SMB_TEMP                  = 28;       // Tempature Probe
  SMB_CURRENT               = 29;       // Electrical Current Probe
  SMB_OOBREM                = 30;       // Out-of-Band Remote Access
  SMB_BIS                   = 31;       // Boot Integrity Services (BIS) Entry Point
  SMB_SYSBOOT               = 32;       // System Boot Information
  SMB_MEMERR64              = 33;       // 64-bit Memory Error Information
  SMB_MGT                   = 34;       // Management Device
  SMB_MGTCMP                = 35;       // Management Device Component
  SMB_MGTTHR                = 36;       // Management Device Threshold Data
  SMB_MEMCHAN               = 37;       // Memory Channel
  SMB_IPMI                  = 38;       // IPMI Device Information
  SMB_SPS                   = 39;       // System Power Supply
  SMB_INACTIVE              = 126;      // Inactive
  SMB_EOT                   = 127;      // End-of-Table

  VER_NT_WORKSTATION        = $0000001;
  VER_NT_DOMAIN_CONTROLLER  = $0000002;
  VER_NT_SERVER             = $0000003;

  VER_SUITE_SMALLBUSINESS   = $00000001;
  VER_SUITE_ENTERPRISE      = $00000002;
  VER_SUITE_BACKOFFICE      = $00000004;
  VER_SUITE_COMMUNICATIONS  = $00000008;
  VER_SUITE_TERMINAL        = $00000010;
  VER_SUITE_SMALLBUSINESS_RESTRICTED = $00000020;
  VER_SUITE_EMBEDDEDNT      = $00000040;
  VER_SUITE_DATACENTER      = $00000080;
  VER_SUITE_SINGLEUSERTS    = $00000100;
  VER_SUITE_PERSONAL        = $00000200;
  VER_SUITE_BLADE           = $00000400;
  VER_SUITE_EMBEDDED_RESTRICTED = $00000800;

  rsKernel                  = 'KERNEL32.DLL';
  rsSetProcessAffinityMask  = 'SetProcessAffinityMask';
  rsGetNativeSystemInfo     = 'GetNativeSystemInfo';
  rsIsWow64Process          = 'IsWow64Process';

  PROCESSOR_ARCHITECTURE_AMD64 = 9;     //x64 (AMD or Intel)
  PROCESSOR_ARCHITECTURE_IA32_ON_WIN64 = 10; //WOW64
  PROCESSOR_ARCHITECTURE_IA64 = 6;      //Intel Itanium Processor Family (IPF)
  PROCESSOR_ARCHITECTURE_INTEL = 0;     //x86
  PROCESSOR_ARCHITECTURE_UNKNOWN = $FFFF;

  SM_MEDIACENTER            = 87;
  SM_SERVERR2               = 89;
  SM_STARTER                = 88;
  SM_TABLETPC               = 86;

  KEY_WOW64_64KEY           = $0100;

  ObjPhysMem                = '\Device\PhysicalMemory';
  ObjectName                : TUnicodeString = (
    Length: Length(ObjPhysMem) * SizeOf(WChar);
    MaximumLength: Length(ObjPhysMem) * SizeOf(WChar) + SizeOf(WChar);
    Buffer: ObjPhysMem;
    );
  DesiredAccess             : ACCESS_MASK = SECTION_MAP_READ;
  ObjectAttribs             : TOBJECTATTRIBUTES = (
    Length: SizeOf(TOBJECTATTRIBUTES);
    RootDirectory: 0;
    ObjectName: @ObjectName;
    Attributes: OBJ_CASE_INSENSITIVE;
    SecurityDescriptor: nil;
    SecurityQualityOfService: nil;
    );

  RomBiosDumpBase           = Cardinal($000C0000);
  RomBiosDumpBasePtr        = Pointer(RomBiosDumpBase);
  RomBiosDumpEnd            = Cardinal($000FFFFF);
  RomBiosDumpEndPtr         = Pointer(RomBiosDumpEnd);
  RomBiosDumpSize           = Cardinal(RomBiosDumpEnd - RomBiosDumpBase + 1);
  RomBiosBlockSize          = MaxWord;

type
  TFNEnumSystemFirmwareTables = function(FirmwareTableProviderSignature: DWORD;
    out pFirmwareTableEnumBuffer; BufferSize: DWORD): UINT; stdcall;
  TFNGetSystemFirmwareTable = function(FirmwareTableProviderSignature: DWORD;
    FirmwareTableID: DWORD; out pFirmwareTableBuffer; BufferSize: DWORD): UINT;
  stdcall;

{$IFNDEF RAD6PLUS}
  POSVersionInfoEx = ^TOSVersionInfoEx;
  TOSVersionInfoEx = record
    dwOSVersionInfoSize: Cardinal;
    dwMajorVersion: Cardinal;
    dwMinorVersion: Cardinal;
    dwBuildNumber: Cardinal;
    dwPlatformId: Cardinal;
    szCSDVersion: array[0..127] of CHAR;
    wServicePackMajor: Word;
    wServicePackMinor: Word;
    wSuiteMask: Word;
    wProductType: BYTE;
    wReserved: BYTE;
  end;
{$ENDIF}

  TNtProductType = (ptUnknown, ptWorkStation, ptServer, ptAdvancedServer, ptDataCenter, ptWeb);

  TNTSuite = (suSmallBusiness, suEnterprise, suBackOffice, suCommunications,
    suTerminal, suSmallBusinessRestricted, suEmbeddedNT, suDataCenter,
    suSingleUserTS, suPersonal, suBlade, suEmbeddedRestricted);
  TNTSuites = set of TNTSuite;

  TTerminateStatus = (tsError, tsClose, tsTerminate);

  TConnectionType = (ctNone, ctLAN, ctDialup);

  TOSVersion = (osUnknown, os95, os98, osME, osNT4, os2K, osXP, osXP64, os2K3, osVista, osLonghorn);

  TVersionInfo = record
    FileName,
      Version,
      ProductName,
      CompanyName,
      Description,
      Comments,
      Copyright,
      InternalName,
      ProductVersion: string;
    Major,
      Minor,
      Release,
      Build: Cardinal;
    ProductMajor,
      ProductMinor,
      ProductRelease,
      ProductBuild: Cardinal;
    SpecialBuild: string;
  end;

  TMediaType = (dtUnknown, dtNotExists, dtRemovable, dtFixed, dtRemote, dtCDROM, dtRAMDisk);

  TFileFlag = (fsCaseIsPreserved, fsCaseSensitive, fsUnicodeStoredOnDisk,
    fsPersistentAcls, fsFileCompression, fsVolumeIsCompressed,
    fsLongFileNames,
    // following flags are valid only for Windows2000
    fsEncryptedFileSystemSupport, fsObjectIDsSupport, fsReparsePointsSupport,
    fsSparseFilesSupport, fsDiskQuotasSupport);
  TFileFlags = set of TFileFlag;

  TDiskSign = string[2];

  TDiskInfo = record
    Sign: TDiskSign;
    MediaType: TMediaType;
    FileFlags: TFileFlags;
    SectorsPerCluster,
      BytesPerSector,
      FreeClusters,
      TotalClusters,
      Serial: Cardinal;
    Capacity,
      FreeSpace: Int64;
    VolumeLabel,
      SerialNumber,
      FileSystem: shortstring;
  end;

  PWindowInfo = ^TWindowInfo;
  TWindowInfo = record
    ClassName,
      Text: shortstring;
    Handle,
      Process,
      Thread: longword;
    ParentWin,
      WndProc,
      Instance,
      ID,
      UserData,
      Style,
      ExStyle: longint;
    Rect,
      ClientRect: TRect;
    Atom,
      ClassBytes,
      WinBytes,
      ClassWndProc,
      ClassInstance,
      Background,
      Cursor,
      Icon,
      ClassStyle: longword;
    Styles,
      ExStyles,
      ClassStyles: tstringlist;
    Visible: boolean;
  end;

  TFileInfo = record
    Name: string;
    FileType: string;
    Size: Cardinal;
    Created,
      Accessed,
      Modified: TDateTime;
    Attributes: Cardinal;
    BinaryType: string;
    IconHandle: Thandle;
  end;

  TPrivilegeInfo = record
    Name,
      DisplayName: shortstring;
    Flags: Cardinal;
  end;
  TPrivilegeList = array of TPrivilegeInfo;

  TTokenGroupInfo = record
    SID,
      Domain,
      Name: shortstring;
    Flags: Cardinal;
  end;
  TTokenGroupList = array of TTokenGroupInfo;

  TLoadLibraryA = function(lpLibFileName: PAnsiChar): HMODULE; stdcall;
  TGetProcAddress = function(HMODULE: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
  TFreeLibrary = function(hLibModule: HMODULE): BOOL; stdcall;

  TInjectDllData = record
    pLoadLib: TLoadLibraryA;
    pGetProcAddr: TGetProcAddress;
    pFreeLib: TFreeLibrary;
    LibName: Pointer;
  end;
  PInjectDllData = ^TInjectDllData;

  PByteArray = ^TByteArray;
  TByteArray = array[0..High(Integer) div SizeOf(BYTE) - 1] of BYTE;
  PDWordArray = ^TDWordArray;
  TDWordArray = array[0..High(Integer) div SizeOf(DWORD) - 1] of DWORD;

  PRomBiosDump = ^TRomBiosDump;
  TRomBiosDump = record
    ByteArray: array[0..RomBiosDumpSize - 1] of BYTE;
  end;

  TStructTable = record
    Address: Cardinal;
    Indicator: BYTE;
    Length: BYTE;
    Handle: Word;
    Name: shortstring;
  end;
  TStructTables = array of TStructTable;

  TSetProcessAffinityMask = function(hProcess: Thandle; dwProcessAffinityMask: Cardinal): BOOL; stdcall;
  TGetNativeSystemInfo = procedure(var lpSystemInfo: TSystemInfo); stdcall;
  TIsWow64Process = function(Handle: Windows.Thandle; var Res: Windows.BOOL): Windows.BOOL; stdcall;

var
  Kernel32Handle            : Thandle = 0;
  //SetProcessAffinity        : TSetProcessAffinityMask = nil;
  GetNativeSystemInfo       : TGetNativeSystemInfo = nil;
  IsWow64Process            : TIsWow64Process = nil;

  EnumSystemFirmwareTables  : TFNEnumSystemFirmwareTables = nil;
  GetSystemFirmwareTable    : TFNGetSystemFirmwareTable = nil;

  g_xSystemInfo             : TSystemInfo;
  //OSVIX                     : TOSVersionInfoEx;
  //OSVI                      : TOSVersionInfo;
  //OSName, OSEdition, ClassKey: string;
  //IsNT, IsNT4, IsNT5, Is95, Is98, Is2K, IsOSR2, IsSE, IsME, IsXP, IsXP64, Is2K3, IsVista: boolean;
  //Profilepath, WindowsUser, MachineName, Domain: string;
  //OS                        : TOSVersion;
  //Memory                    : Int64;
  //EXEVersionInfo            : TVersionInfo;
  //InstalledSuites           : TNTSuites;
  //ProductType               : TNtProductType;
  IsWow64                   : BOOL = False;
  //g_fGetSysInfo             : BOOL = False;

