{$INCLUDE LS_DEF.inc}

unit NTNativeAPI;

interface

uses Windows, SysUtils;

type
  PPointer = ^Pointer;
  PVOID = Pointer;
  USHORT = Cardinal;
  LONG = Integer;
  Handle = THandle;
  PWSTR = PWideChar;
  TLUID = Int64;
  PLUID = ^TLUID;

  UNICODE_STRING = packed record
    Length,
      MaximumLength: WORD;
    Buffer: PWideChar;
  end;
  TUnicodeString = UNICODE_STRING;
  PUnicodeString = ^TUnicodeString;

  SYSTEM_INFORMATION_CLASS = (
    SystemBasicInformation,
    SystemProcessorInformation,
    SystemPerformanceInformation,
    SystemTimeOfDayInformation,
    SystemNotImplemented1,
    SystemProcessesAndThreadsInformation,
    SystemCallCounts,
    SystemConfigurationInformation,
    SystemProcessorTimes,
    SystemGlobalFlag,
    SystemNotImplemented2,
    SystemModuleInformation,
    SystemLockInformation,
    SystemNotImplemented3,
    SystemNotImplemented4,
    SystemNotImplemented5,
    SystemHandleInformation,
    SystemObjectInformation,
    SystemPagefileInformation,
    SystemInstructionEmulationCounts,
    SystemInvalidInfoClass1,
    SystemCacheInformation,
    SystemPoolTagInformation,
    SystemProcessorStatistics,
    SystemDpcInformation,
    SystemNotImplemented6,
    SystemLoadImage,
    SystemUnloadImage,
    SystemTimeAdjustment,
    SystemNotImplemented7,
    SystemNotImplemented8,
    SystemNotImplemented9,
    SystemCrashDumpInformation,
    SystemExceptionInformation,
    SystemCrashDumpStateInformation,
    SystemKernelDebuggerInformation,
    SystemContextSwitchInformation,
    SystemRegistryQuotaInformation,
    SystemLoadAndCallImage,
    SystemPrioritySeparation,
    SystemNotImplemented10,
    SystemNotImplemented11,
    SystemInvalidInfoClass2,
    SystemInvalidInfoClass3,
    SystemTimeZoneInformation,
    SystemLookasideInformation,
    SystemSetTimeSlipEvent,
    SystemCreateSession,
    SystemDeleteSession,
    SystemInvalidInfoClass4,
    SystemRangeStartInformation,
    SystemVerifierInformation,
    SystemAddVerifier,
    SystemSessionProcessesInformation);
  TSystemInformationClass = SYSTEM_INFORMATION_CLASS;

  TProcessTimes = record
    CreateTime,
      ExitTime,
      KernelTime,
      UserTime: LARGE_INTEGER;
  end;

  OBJECT_INFORMATION_CLASS = (
    ObjectBasicInformation,
    ObjectNameInformation,
    ObjectTypeInformation,
    ObjectAllTypesInformation,
    ObjectHandleInformation);
  TObjectInformationClass = OBJECT_INFORMATION_CLASS;

  SYSTEM_PROCESSOR_TIMES = packed record
    IdleTime: LARGE_INTEGER;
    KernelTime: LARGE_INTEGER;
    UserTime: LARGE_INTEGER;
    DpcTime: LARGE_INTEGER;
    InterruptTime: LARGE_INTEGER;
    InterruptCount: ULONG;
  end;
  TSystemProcessorTimes = SYSTEM_PROCESSOR_TIMES;
  PSystemProcessorTimes = ^TSystemProcessorTimes;

  CLIENT_ID = record
    UniqueProcess: Cardinal;
    UniqueThread: Cardinal;
  end;
  TClientID = CLIENT_ID;
  PClientID = ^TClientID;

  KPRIORITY = Longint;

  KWAIT_REASON = (
    Executive,
    FreePage,
    PageIn,
    PoolAllocation,
    DelayExecution,
    Suspended,
    UserRequest,
    WrExecutive,
    WrFreePage,
    WrPageIn,
    WrPoolAllocation,
    WrDelayExecution,
    WrSuspended,
    WrUserRequest,
    WrEventPair,
    WrQueue,
    WrLpcReceive,
    WrLpcReply,
    WrVirtualMemory,
    WrPageOut,
    WrRendezvous,
    Spare2,
    Spare3,
    Spare4,
    Spare5,
    Spare6,
    WrKernel,
    MaximumWaitReason);
  TKWaitReason = KWAIT_REASON;

  THREAD_STATE = (
    StateInitialized,
    StateReady,
    StateRunning,
    StateStandby,
    StateTerminated,
    StateWait,
    StateTransition,
    StateUnknown);
  TThreadState = THREAD_STATE;

  SYSTEM_THREAD_INFORMATION = record
    KernelTime: LARGE_INTEGER;
    UserTime: LARGE_INTEGER;
    CreateTime: LARGE_INTEGER;
    WaitTime: ULONG;
    StartAddress: PVOID;
    ClientId: CLIENT_ID;
    Priority: KPRIORITY;
    BasePriority: KPRIORITY;
    ContextSwitchCount: ULONG;
    State: Cardinal;
    WaitReason: Cardinal;
  end;
  TSystemThreadInformation = SYSTEM_THREAD_INFORMATION;
  PSystemThreadInformation = ^TSystemThreadInformation;

  VM_COUNTERS = record
    PeakVirtualSize: Cardinal;
    VirtualSize: Cardinal;
    PageFaultCount: Cardinal;
    PeakWorkingSetSize: Cardinal;
    WorkingSetSize: Cardinal;
    QuotaPeakPagedPoolUsage: Cardinal;
    QuotaPagedPoolUsage: Cardinal;
    QuotaPeakNonPagedPoolUsage: Cardinal;
    QuotaNonPagedPoolUsage: Cardinal;
    PagefileUsage: Cardinal;
    PeakPagefileUsage: Cardinal;
  end;
  TVMCounters = VM_COUNTERS;
  PVMCounters = ^TVMCounters;

  IO_COUNTERSEX = record
    ReadOperationCount: LARGE_INTEGER;
    WriteOperationCount: LARGE_INTEGER;
    OtherOperationCount: LARGE_INTEGER;
    ReadTransferCount: LARGE_INTEGER;
    WriteTransferCount: LARGE_INTEGER;
    OtherTransferCount: LARGE_INTEGER;
  end;
  TIOCounters = IO_COUNTERSEX;
  PIoCounters = ^TIOCounters;

const
  NonPagedPool              = 0;
  PagedPool                 = 1;
  NonPagedPoolMustSucceed   = 2;
  DontUseThisType           = 3;
  NonPagedPoolCacheAligned  = 4;
  PagedPoolCacheAligned     = 5;
  NonPagedPoolCacheAlignedMustS = 6;
  MaxPoolType               = 7;
  NonPagedPoolSession       = 32;
  PagedPoolSession          = NonPagedPoolSession + 1;
  NonPagedPoolMustSucceedSession = PagedPoolSession + 1;
  DontUseThisTypeSession    = NonPagedPoolMustSucceedSession + 1;
  NonPagedPoolCacheAlignedSession = DontUseThisTypeSession + 1;
  PagedPoolCacheAlignedSession = NonPagedPoolCacheAlignedSession + 1;
  NonPagedPoolCacheAlignedMustSSession = PagedPoolCacheAlignedSession + 1;

type
  POOL_TYPE = NonPagedPool..NonPagedPoolCacheAlignedMustSSession;

  _SYSTEM_BASIC_INFORMATION = record    // Information Class 0
    Unknown: ULONG;
    MaximumIncrement: ULONG;
    PhysicalPageSize: ULONG;
    NumberOfPhysicalPages: ULONG;
    LowestPhysicalPage: ULONG;
    HighestPhysicalPage: ULONG;
    AllocationGranularity: ULONG;
    LowestUserAddress: ULONG;
    HighestUserAddress: ULONG;
    ActiveProcessors: ULONG;
    NumberProcessors: UCHAR;
  end;
  SYSTEM_BASIC_INFORMATION = _SYSTEM_BASIC_INFORMATION;
  PSYSTEM_BASIC_INFORMATION = ^SYSTEM_BASIC_INFORMATION;
  TSystemBasicInformation = SYSTEM_BASIC_INFORMATION;
  PSystemBasicInformation = ^TSystemBasicInformation;

  _SYSTEM_PROCESSOR_INFORMATION = record // Information Class 1
    ProcessorArchitecture: USHORT;
    ProcessorLevel: USHORT;
    ProcessorRevision: USHORT;
    Unknown: USHORT;
    FeatureBits: ULONG;
  end;
  SYSTEM_PROCESSOR_INFORMATION = _SYSTEM_PROCESSOR_INFORMATION;
  PSYSTEM_PROCESSOR_INFORMATION = ^SYSTEM_PROCESSOR_INFORMATION;
  TSystemProcessorInformation = SYSTEM_PROCESSOR_INFORMATION;
  PSystemProcessorInformation = ^TSystemProcessorInformation;

  SYSTEM_PROCESS_INFORMATION = record
    NextEntryDelta: ULONG;
    ThreadCount: ULONG;
    Reserved1: array[0..5] of ULONG;
    CreateTime: LARGE_INTEGER;
    UserTime: LARGE_INTEGER;
    KernelTime: LARGE_INTEGER;
    ProcessName: UNICODE_STRING;
    BasePriority: KPRIORITY;
    ProcessId: ULONG;
    InheritedFromProcessId: ULONG;
    HandleCount: ULONG;
    SessionId: ULONG;
    Reserved2: ULONG;
    VmCounters: VM_COUNTERS;
    IoCounters: IO_COUNTERSEX;          // Windows 2000 only
    Threads: array[0..255] of SYSTEM_THREAD_INFORMATION;
  end;
  TSystemProcessInformation = SYSTEM_PROCESS_INFORMATION;
  PSystemProcessInformation = ^TSystemProcessInformation;

  SYSTEM_MODULE_INFORMATION = record
    Reserved: array[0..1] of ULONG;
    Base: Pointer;
    Size: ULONG;
    Flags: ULONG;
    Index: WORD;
    Unknown: WORD;
    LoadCount: WORD;
    ModuleNameOffset: WORD;
    ImageName: array[0..255] of ANSICHAR;
  end;
  TSystemModuleInformation = SYSTEM_MODULE_INFORMATION;
  PSystemModuleInformation = ^TSystemModuleInformation;

  SYSTEM_HANDLE_TYPE = (OB_TYPE_UNKNOWN,
    OB_TYPE_TYPE,
    OB_TYPE_DIRECTORY,
    OB_TYPE_SYMBOLIC_LINK,
    OB_TYPE_TOKEN,
    OB_TYPE_PROCESS,
    OB_TYPE_THREAD,
    OB_TYPE_UNKNOWN_7,
    OB_TYPE_EVENT,
    OB_TYPE_EVENT_PAIR,
    OB_TYPE_MUTANT,
    OB_TYPE_UNKNOWN_11,
    OB_TYPE_SEMAPHORE,
    OB_TYPE_TIMER,
    OB_TYPE_PROFILE,
    OB_TYPE_WINDOW_STATION,
    OB_TYPE_DESKTOP,
    OB_TYPE_SECTION,
    OB_TYPE_KEY,
    OB_TYPE_PORT,
    OB_TYPE_WAITABLE_PORT,
    OB_TYPE_UNKNOWN_21,
    OB_TYPE_UNKNOWN_22,
    OB_TYPE_UNKNOWN_23,
    OB_TYPE_UNKNOWN_24,
    //OB_TYPE_CONTROLLER,
    //OB_TYPE_DEVICE,
    //OB_TYPE_DRIVER,
    OB_TYPE_IO_COMPLETION,
    OB_TYPE_FILE);
  TSystemHandleType = SYSTEM_HANDLE_TYPE;

  SYSTEM_HANDLE_INFORMATION = record
    {ProcessId: ULONG;
    ObjectTypeNumber: UCHAR;
    Flags: UCHAR;  // 0x01 = PROTECT_FROM_CLOSE, 0x02 = INHERIT
    Handle: WORD;
    Object_: Pointer;
    GrantedAccess: ACCESS_MASK;}
    ProcessId: Cardinal;
    HandleType: WORD;
    HandleNumber: WORD;
    KernelAddress: Cardinal;
    Flags: Cardinal;
  end;
  TSystemHandleInformation = SYSTEM_HANDLE_INFORMATION;
  PSystemHandleInformation = ^TSystemHandleInformation;

  {SYSTEM_OBJECT_TYPE_INFORMATION = record
    NextEntryOffset: ULONG;
    ObjectCount: ULONG;
    HandleCount: ULONG;
    TypeNumber: ULONG;
    InvalidAttributes: ULONG;
    GenericMapping: GENERIC_MAPPING;
    ValidAccessMask: ACCESS_MASK;
    PoolType: POOL_TYPE;
    Unknown: UCHAR;
    Name: UNICODE_STRING;
  end;
  TSystemObjectTypeInformation = SYSTEM_OBJECT_TYPE_INFORMATION;
  PSystemObjectTypeInformation = ^TSystemObjectTypeInformation;

  SYSTEM_OBJECT_INFORMATION = record
    NextEntryOffset: ULONG;
    Object_: PVOID;
    CreatorProcessId: ULONG;
    Unknown: USHORT;
    Flags: USHORT;
    PointerCount: ULONG;
    HandleCount: ULONG;
    PagedPoolUsage: ULONG;
    NonPagedPoolUsage: ULONG;
    ExclusiveProcessId: ULONG;
    SecurityDescriptor: PSECURITY_DESCRIPTOR;
    Name: UNICODE_STRING;
  end;
  TSystemObjectInformation = SYSTEM_OBJECT_INFORMATION;
  PSystemObjectInformation = ^TSystemObjectInformation;}

  OBJECT_BASIC_INFORMATION = record
    Attributes: ULONG;
    GrantedAccess: ACCESS_MASK;
    HandleCount: ULONG;
    PointerCount: ULONG;
    PagedPoolUsage: ULONG;
    NonPagedPoolUsage: ULONG;
    Reserved: array[0..2] of ULONG;
    NameInformationLength: ULONG;
    TypeInformationLength: ULONG;
    SecurityDescriptorLength: ULONG;
    CreateTime: LARGE_INTEGER;
  end;
  TObjectBasicInformation = OBJECT_BASIC_INFORMATION;
  PObjectBasicInformation = ^TObjectBasicInformation;

  OBJECT_TYPE_INFORMATION = record
    Name: UNICODE_STRING;
    ObjectCount: ULONG;
    HandleCount: ULONG;
    Reserved1: array[0..3] of ULONG;
    PeakObjectCount: ULONG;
    PeakHandleCount: ULONG;
    Reserved2: array[0..3] of ULONG;
    InvalidAttributes: ULONG;
    GenericMapping: GENERIC_MAPPING;
    ValidAccess: ULONG;
    Unknown: UCHAR;
    MaintainHandleDatabase: ByteBool;
    Reserved3: array[0..1] of UCHAR;
    PoolType: POOL_TYPE;
    PagedPoolUsage: ULONG;
    NonPagedPoolUsage: ULONG;
  end;
  TObjectTypeInformation = OBJECT_TYPE_INFORMATION;
  PObjectTypeInformation = ^TObjectTypeInformation;

  PROCESSINFOCLASS = (
    ProcessBasicInformation,
    ProcessQuotaLimits,
    ProcessIoCounters,
    ProcessVmCounters,
    ProcessTimes,
    ProcessBasePriority,
    ProcessRaisePriority,
    ProcessDebugPort,
    ProcessExceptionPort,
    ProcessAccessToken,
    ProcessLdtInformation,
    ProcessLdtSize,
    ProcessDefaultHardErrorMode,
    ProcessIoPortHandlers,              // Note: this is kernel mode only
    ProcessPooledUsageAndLimits,
    ProcessWorkingSetWatch,
    ProcessUserModeIOPL,
    ProcessEnableAlignmentFaultFixup,
    ProcessPriorityClass,
    ProcessWx86Information,
    ProcessHandleCount,
    ProcessAffinityMask,
    ProcessPriorityBoost,
    ProcessDeviceMap,
    ProcessSessionInformation,
    ProcessForegroundInformation,
    ProcessWow64Information,
    MaxProcessInfoClass);
  TProcessInfoClass = PROCESSINFOCLASS;

  PROCESS_BASIC_INFORMATION = record
    ExitStatus: Cardinal;
    PebBaseAddress: PVOID;
    AffinityMask: Cardinal;
    BasePriority: Cardinal;
    UniqueProcessId: Cardinal;
    InheritedFromUniqueProcessId: Cardinal;
  end;
  TProcessBasicInformation = PROCESS_BASIC_INFORMATION;
  PProcessBasicInformation = ^TProcessBasicInformation;

  PPROCESS_PARAMETERS = ^PROCESS_PARAMETERS;
  PROCESS_PARAMETERS = record
    AllocationSize: Cardinal;
    Size: Cardinal;
    Flags: Cardinal;
    Reserved: Cardinal;
    Console: Cardinal;
    ProcessGroup: Cardinal;
    hStdInput: THandle;
    hStdOutput: THandle;
    hStdError: THandle;
    CurrentDir: WideString;
    CurrentDirectoryHandle: THandle;
    LoadSearchPath: UNICODE_STRING;
    ImageName: UNICODE_STRING;
    CommandLine: UNICODE_STRING;
    Enviroment: PWSTR;
    dwX: Cardinal;
    dwY: Cardinal;
    dwXSize: Cardinal;
    dwYSize: Cardinal;
    dwXCountChars: Cardinal;
    dwYCountChars: Cardinal;
    dwFillAttributes: Cardinal;
    dwFlags: Cardinal;
    wShowWindow: Cardinal;
    WindowTitle: UNICODE_STRING;
    Desktop: UNICODE_STRING;
    Reserved1: UNICODE_STRING;
    Reserved2: UNICODE_STRING;
  end;

  MODULE_HEADER = record
    Unknown: array[0..1] of Cardinal;
    LoadOrder: LIST_ENTRY;
    MemOrder: LIST_ENTRY;
    InitOrder: LIST_ENTRY;
  end;

  PPROCESS_MODULE_INFO = ^PROCESS_MODULE_INFO;
  PROCESS_MODULE_INFO = record
    Size: Cardinal;
    ModuleHeader: MODULE_HEADER;
  end;

  PRTL_BITMAP = ^RTL_BITMAP;
  RTL_BITMAP = record
    SizeOfBitMap: Cardinal;             //* Number of bits in the bitmap */
    BitMapBuffer: PByte;                //* Bitmap data, assumed sized to a DWORD boundary */
  end;

  PSYSTEM_STRINGS = ^SYSTEM_STRINGS;
  SYSTEM_STRINGS = record
    SystemRoot: UNICODE_STRING;
    System32Root: UNICODE_STRING;
    BaseNamedObjects: UNICODE_STRING;
  end;

  PTEXT_INFO = ^TEXT_INFO;
  TEXT_INFO = record
    Reserved: PVOID;
    SystemStrings: PSYSTEM_STRINGS;
  end;

  INFOBLOCK = record
    Filler: array[0..16] of Cardinal;
    wszCmdLineAddress: Cardinal;
  end;

  _PEB = record
    Filler: array[0..3] of Cardinal;
    InfoBlockAddress: Cardinal;
  end;

  PPEB = ^PEB;
  PEB = record
    InheritedAddressSpace: boolean;
    ReadImageFileExecOptions: boolean;
    BeingDebugged: boolean;
    b003: byte;
    d004: Cardinal;
    SectionBaseAddress: PVOID;
    ProcessModuleInfo: PPROCESS_MODULE_INFO;
    ProcessParameters: PPROCESS_PARAMETERS;
    SubSystemData: DWORD;
    ProcessHeap: THandle;
    FastPebLock: PRTLCriticalSection;
    AcquireFastPebLock: PVOID;
    ReleaseFastPebLock: PVOID;
    d028: Cardinal;
    User32Dispatch: PVOID;
    d030: Cardinal;
    d034: Cardinal;
    d038: Cardinal;
    TlsBitMapSize: Cardinal;
    TlsBitMap: PRTL_BITMAP;
    TlsBitMapData: array[0..1] of Cardinal;
    p04C: PVOID;
    p050: PVOID;
    TextInfo: PTEXT_INFO;
    InitAnsiCodePageData: PVOID;
    InitOemCodePageData: PVOID;
    InitUnicodeCaseTableData: PVOID;
    KeNumberProcessors: Cardinal;
    NtGlobalFlag: Cardinal;
    d6C: Cardinal;
    MmCriticalSectionTimeout: LARGE_INTEGER;
    MmHeapSegmentReserve: Cardinal;
    MmHeapSegmentCommit: Cardinal;
    MmHeapDeCommitTotalFreeThreshold: Cardinal;
    MmHeapDeCommitFreeBlockThreshold: Cardinal;
    NumberOfHeaps: Cardinal;
    AvailableHeaps: Cardinal;
    ProcessHeapsListBuffer: PHandle;
    d094: Cardinal;
    d098: Cardinal;
    d09C: Cardinal;
    LoaderLock: PRTLCriticalSection;
    NtMajorVersion: Cardinal;
    NtMinorVersion: Cardinal;
    NtBuildNumber: Cardinal;
    CmNtCSDVersion: Cardinal;
    PlatformId: Cardinal;
    Subsystem: Cardinal;
    MajorSubsystemVersion: Cardinal;
    MinorSubsystemVersion: Cardinal;
    AffinityMask: Cardinal;
    ad0C4: array[0..34] of Cardinal;
    p150: PVOID;
    ad154: array[0..31] of Cardinal;
    Win32WindowStation: THandle;
    d1D8: Cardinal;
    d1DC: Cardinal;
    CSDVersion: PWORD;
    d1E4: Cardinal;
  end;

  THREADINFOCLASS = (
    ThreadBasicInformation,
    ThreadTimes,
    ThreadPriority,
    ThreadBasePriority,
    ThreadAffinityMask,
    ThreadImpersonationToken,
    ThreadDescriptorTableEntry,
    ThreadEnableAlignmentFaultFixup,
    ThreadEventPair_Reusable,
    ThreadQuerySetWin32StartAddress,
    ThreadZeroTlsCell,
    ThreadPerformanceCount,
    ThreadAmILastThread,
    ThreadIdealProcessor,
    ThreadPriorityBoost,
    ThreadSetTlsArrayAddress,
    ThreadIsIoPending,
    ThreadHideFromDebugger,
    MaxThreadInfoClass);
  TThreadInfoClass = THREADINFOCLASS;

  THREAD_BASIC_INFORMATION = record
    ExitStatus: Cardinal;
    TebBaseAddress: Cardinal;
    ClientId: CLIENT_ID;
    AffinityMask: Cardinal;
    Priority: Cardinal;
    BasePriority: Cardinal;
  end;
  TThreadBasicInformation = THREAD_BASIC_INFORMATION;
  PThreadBasicInformation = ^TThreadBasicInformation;

  ////////////////////////////////////////////////////////////////////
//                                                                //
//           Token Object Definitions                             //
//                                                                //
//                                                                //
////////////////////////////////////////////////////////////////////

//
// Token information class structures
//

type
  PTOKEN_USER = ^TOKEN_USER;
{$EXTERNALSYM PTOKEN_USER}
  _TOKEN_USER = record
    User: SID_AND_ATTRIBUTES;
  end;
{$EXTERNALSYM _TOKEN_USER}
  TOKEN_USER = _TOKEN_USER;
{$EXTERNALSYM TOKEN_USER}
  TTokenUser = TOKEN_USER;
  PTokenUser = PTOKEN_USER;

  PTOKEN_OWNER = ^TOKEN_OWNER;
{$EXTERNALSYM PTOKEN_OWNER}
  _TOKEN_OWNER = record
    Owner: PSID;
  end;
{$EXTERNALSYM _TOKEN_OWNER}
  TOKEN_OWNER = _TOKEN_OWNER;
{$EXTERNALSYM TOKEN_OWNER}
  TTokenOwner = TOKEN_OWNER;
  PTokenOwner = PTOKEN_OWNER;

const
  TOKEN_SOURCE_LENGTH       = 8;
{$EXTERNALSYM TOKEN_SOURCE_LENGTH}

type
  PTOKEN_SOURCE = ^TOKEN_SOURCE;
{$EXTERNALSYM PTOKEN_SOURCE}
  _TOKEN_SOURCE = record
    SourceName: array[0..TOKEN_SOURCE_LENGTH - 1] of ANSICHAR;
    SourceIdentifier: TLUID;
  end;
{$EXTERNALSYM _TOKEN_SOURCE}
  TOKEN_SOURCE = _TOKEN_SOURCE;
{$EXTERNALSYM TOKEN_SOURCE}
  TTokenSource = TOKEN_SOURCE;
  PTokenSource = PTOKEN_SOURCE;

  PTOKEN_PRIMARY_GROUP = ^TOKEN_PRIMARY_GROUP;
{$EXTERNALSYM PTOKEN_PRIMARY_GROUP}
  _TOKEN_PRIMARY_GROUP = record
    PrimaryGroup: PSID;
  end;
{$EXTERNALSYM _TOKEN_PRIMARY_GROUP}
  TOKEN_PRIMARY_GROUP = _TOKEN_PRIMARY_GROUP;
{$EXTERNALSYM TOKEN_PRIMARY_GROUP}
  TTokenPrimaryGroup = TOKEN_PRIMARY_GROUP;
  PTokenPrimaryGroup = PTOKEN_PRIMARY_GROUP;

  PTOKEN_DEFAULT_DACL = ^TOKEN_DEFAULT_DACL;
{$EXTERNALSYM PTOKEN_DEFAULT_DACL}
  _TOKEN_DEFAULT_DACL = record
    DefaultDacl: PACL;
  end;
{$EXTERNALSYM _TOKEN_DEFAULT_DACL}
  TOKEN_DEFAULT_DACL = _TOKEN_DEFAULT_DACL;
{$EXTERNALSYM TOKEN_DEFAULT_DACL}
  TTokenDefaultDacl = TOKEN_DEFAULT_DACL;
  PTokenDefaultDacl = PTOKEN_DEFAULT_DACL;

  _TOKEN_GROUPS_AND_PRIVILEGES = record
    SidCount: DWORD;
    SidLength: DWORD;
    Sids: PSIDANDATTRIBUTES;
    RestrictedSidCount: DWORD;
    RestrictedSidLength: DWORD;
    RestrictedSids: PSIDANDATTRIBUTES;
    PrivilegeCount: DWORD;
    PrivilegeLength: DWORD;
    Privileges: PLUIDANDATTRIBUTES;
    AuthenticationId: TLUID;
  end;
{$EXTERNALSYM _TOKEN_GROUPS_AND_PRIVILEGES}
  TOKEN_GROUPS_AND_PRIVILEGES = _TOKEN_GROUPS_AND_PRIVILEGES;
{$EXTERNALSYM TOKEN_GROUPS_AND_PRIVILEGES}
  PTOKEN_GROUPS_AND_PRIVILEGES = ^TOKEN_GROUPS_AND_PRIVILEGES;
{$EXTERNALSYM PTOKEN_GROUPS_AND_PRIVILEGES}
  TTokenGroupsAndPrivileges = TOKEN_GROUPS_AND_PRIVILEGES;
  PTokenGroupsAndPrivileges = PTOKEN_GROUPS_AND_PRIVILEGES;

  TObjectAttributes = packed record
    Length: Cardinal;
    RootDirectory: THandle;
    ObjectName: PUnicodeString;
    Attributes: Cardinal;
    SecurityDescriptor: Pointer;        // Points to type SECURITY_DESCRIPTOR
    SecurityQualityOfService: Pointer;  // Points to type SECURITY_QUALITY_OF_SERVICE
  end;
  PObjectAttributes = ^TObjectAttributes;

  PLARGE_INTEGER = ^LARGE_INTEGER;

  IO_STATUS_BLOCK = record
    //union {
    Status: Cardinal;
    //    PVOID Pointer;
    //}
    Information: Cardinal;
  end;
  TIOStatusBlock = IO_STATUS_BLOCK;
  PIOStatusBlock = ^TIOStatusBlock;
  PIO_STATUS_BLOCK = ^IO_STATUS_BLOCK;

  FILE_INFORMATION_CLASS = (
    FileFiller0,
    FileDirectoryInformation,           // 1
    FileFullDirectoryInformation,       // 2
    FileBothDirectoryInformation,       // 3
    FileBasicInformation,               // 4  wdm
    FileStandardInformation,            // 5  wdm
    FileInternalInformation,            // 6
    FileEaInformation,                  // 7
    FileAccessInformation,              // 8
    FileNameInformation,                // 9
    FileRenameInformation,              // 10
    FileLinkInformation,                // 11
    FileNamesInformation,               // 12
    FileDispositionInformation,         // 13
    FilePositionInformation,            // 14 wdm
    FileFullEaInformation,              // 15
    FileModeInformation,                // 16
    FileAlignmentInformation,           // 17
    FileAllInformation,                 // 18
    FileAllocationInformation,          // 19
    FileEndOfFileInformation,           // 20 wdm
    FileAlternateNameInformation,       // 21
    FileStreamInformation,              // 22
    FilePipeInformation,                // 23
    FilePipeLocalInformation,           // 24
    FilePipeRemoteInformation,          // 25
    FileMailslotQueryInformation,       // 26
    FileMailslotSetInformation,         // 27
    FileCompressionInformation,         // 28
    FileObjectIdInformation,            // 29
    FileCompletionInformation,          // 30
    FileMoveClusterInformation,         // 31
    FileQuotaInformation,               // 32
    FileReparsePointInformation,        // 33
    FileNetworkOpenInformation,         // 34
    FileAttributeTagInformation,        // 35
    FileTrackingInformation,            // 36
    FileMaximumInformation);
  TFileInformationClass = FILE_INFORMATION_CLASS;

  PIO_APC_ROUTINE = procedure(ApcContext: PVOID; IoStatusBlock: PIO_STATUS_BLOCK; Reserved: ULONG); stdcall;

  _DEBUG_CONTROL_CODE = (
    // In the following five different versions of Windows NT, both
    nothing,
    SysDbgGetTraceInformation,          // = 1,
    SysDbgSetInternalBreakpoint,        // = 2,
    SysDbgSetSpecialCall,               // = 3,
    SysDbgClearSpecialCalls,            // 4,
    SysDbgQuerySpecialCalls,            // 5,

    // The following is the new NT 5.1 (Windows XP)

    SysDbgDbgBreakPointWithStatus,      // 6,
    // Access KdVersionBlock
    SysDbgSysGetVersion,                // 7,
    // Space from the kernel to user space copy, or copy from the user space to user space
    // User space but not copy from the kernel space
    SysDbgCopyMemoryChunks_0,           // 8,
    // SysDbgReadVirtualMemory ,// 8,

    // User space from the kernel space to copy, or copy from the user space to user space
    //But not copy from the kernel space to user space
    SysDbgCopyMemoryChunks_1,           // 9,
    //SysDbgWriteVirtualMemory ,// 9,

    //Copy from the physical address space to users, not kernel space wrote
    SysDbgCopyMemoryChunks_2,           // 10,
    //SysDbgReadVirtualMemory ,// 10,

    //Copy from the user to physical address space, can not read kernel space
    SysDbgCopyMemoryChunks_3,           // 11,
    //SysDbgWriteVirtualMemory ,// 11,

    //Read-write processor related control block
    SysDbgSysReadControlSpace,          // 12,
    SysDbgSysWriteControlSpace,         // 13,

    //Read and write ports
    SysDbgSysReadIoSpace,               // 14,
    SysDbgSysWriteIoSpace,              // 15,

    //Call RDMSR @ 4 respectively, and _ WRMSR @ 12
    SysDbgSysReadMsr,                   // 16,
    SysDbgSysWriteMsr,                  // 17,

    //Read and write data bus
    SysDbgSysReadBusData,               // 18,
    SysDbgSysWriteBusData,              // 19,

    SysDbgSysCheckLowMemory,            // 20,

    //The following is the new NT 5.2 (Windows Server 2003)

    //Were called _ KdEnableDebugger @ 0 and _ KdDisableDebugger @ 0
    SysDbgEnableDebugger,               // 21,
    SysDbgDisableDebugger,              // 22,

    //Access and set up some of the variables related to debugging
    SysDbgGetAutoEnableOnEvent,         // 23,
    SysDbgSetAutoEnableOnEvent,         // 24,
    SysDbgGetPitchDebugger,             // 25,
    SysDbgSetDbgPrintBufferSize,        // 26,
    SysDbgGetIgnoreUmExceptions,        // 27,
    SysDbgSetIgnoreUmExceptions         // 28
    );

  DEBUG_CONTROL_CODE = _DEBUG_CONTROL_CODE;
  TDebugControlCode = DEBUG_CONTROL_CODE;

  MSR_STRUCT = record
    MsrNum: Cardinal;                   // MSR number
    NotUsed: Cardinal;                  // Never accessed by the kernel
    MsrLo: Cardinal;                    // IN (write) or OUT (read): Low 32 bits of MSR
    MsrHi: Cardinal;                    // IN (write) or OUT (read): High 32 bits of MSR
  end;

  IO_STRUCT = record
    IoAddr: Cardinal;                   // IN: Aligned to NumBytes,I/O address
    Reserved1: Cardinal;                // Never accessed by the kernel
    pBuffer: Pointer;                   // IN (write) or OUT (read): Ptr to buffer
    NumBytes: Cardinal;                 // IN: # bytes to read/write. Only use 1, 2, or 4.
    Reserved4: Cardinal;                // Must be 1
    Reserved5: Cardinal;                // Must be 0
    Reserved6: Cardinal;                // Must be 1
    Reserved7: Cardinal;                // Never accessed by the kernel
  end;

const
  ViewShare                 = 1;
  ViewUnmap                 = 2;

type
  SECTION_INHERIT = ViewShare..ViewUnmap;

  TNativeQueryInformationToken = function(TokenHandle: THandle;
    TokenInformationClass: TTokenInformationClass;
    TokenInformation: Pointer;
    TokenInformationLength: Cardinal;
    ReturnLength: PDWORD): Cardinal; stdcall;

  TNativeOpenProcessToken = function(ProcessHandle: THandle;
    DesiredAccess: Cardinal;
    TokenHandle: PHandle): Cardinal; stdcall;

  TNativeOpenProcess = function(ProcessHandle: PHandle;
    DesiredAccess: Cardinal;
    ObjectAttributes: PObjectAttributes;
    ClientId: PClientID): Cardinal; stdcall;

  TNativeOpenSection = function(SectionHandle: PHandle;
    DesiredAccess: Cardinal;
    ObjectAttributes: PObjectAttributes): Cardinal; stdcall;

  TNativeClose = function(Handle: THandle): Cardinal; stdcall;

  TNativeQuerySystemInformation = function(SystemInformationClass: TSystemInformationClass;
    SystemInformation: Pointer;
    SystemInformationLength: Cardinal;
    ReturnLength: PDWORD): Cardinal; stdcall;
  TNativeCreateSection = function(SectionHandle: PHandle;
    DesiredAccess: ACCESS_MASK;
    ObjectAttributes: PObjectAttributes;
    SectionSize: PLARGE_INTEGER;
    Protect: Cardinal; Attributes: ULONG;
    FileHandle: THandle): Cardinal; stdcall;
  TNativeMapViewOfSection = function(SectionHandle: THandle;
    ProcessHandle: THandle;
    BaseAddress: PPointer;
    ZeroBits: Cardinal;
    CommitSize: Cardinal;
    SectionOffset: PLARGE_INTEGER;
    ViewSize: PDWORD;
    InheritDisposition: SECTION_INHERIT;
    AllocationType: Cardinal;
    Protect: Cardinal): Cardinal; stdcall;
  TNativeUnmapViewOfSection = function(ProcessHandle: THandle; BaseAddress: Pointer): Cardinal; stdcall;
  TNativeOpenFile = function(FileHandle: PHandle;
    DesiredAccess: ACCESS_MASK;
    ObjectAttributes: PObjectAttributes;
    IoStatusBlock: PIOStatusBlock;
    ShareAccess: Cardinal;
    OpenOptions: Cardinal): Cardinal; stdcall;
  TNativeCreateFile = function(FileHandle: PHandle;
    DesiredAccess: ACCESS_MASK;
    ObjectAttributes: PObjectAttributes;
    IoStatusBlock: PIOStatusBlock;
    AllocationSize: PLARGE_INTEGER;
    FileAttributes: Cardinal;
    ShareAccess: Cardinal;
    CreateDisposition: Cardinal;
    CreateOptions: Cardinal;
    EaBuffer: Pointer;
    EaLength: Cardinal): Cardinal; stdcall;
  TNativeQueryObject = function(ObjectHandle: THandle;
    ObjectInformationClass:
    OBJECT_INFORMATION_CLASS;
    ObjectInformation: PVOID;
    ObjectInformationLength: ULONG;
    ReturnLength: PULONG): Cardinal; stdcall;
  TNativeQueryInformationProcess = function(ProcessHandle: Handle;
    ProcessInformationClass: PROCESSINFOCLASS;
    ProcessInformation: PVOID;
    ProcessInformationLength: ULONG;
    ReturnLength: PULONG): Cardinal; stdcall;
  TNativeQueryInformationThread = function(ThreadHandle: Handle;
    ThreadInformationClass: THREADINFOCLASS;
    ThreadInformation: PVOID;
    ThreadInformationLength: ULONG;
    ReturnLength: PULONG): Cardinal; stdcall;
  TNativeQueryInformationFile = function(FileHandle: Handle;
    IoStatusBlock: PIO_STATUS_BLOCK;
    FileInformation: PVOID;
    FileInformationLength: ULONG;
    FileInformationClass: FILE_INFORMATION_CLASS): Cardinal; stdcall;
  TNativeDuplicateObject = function(SourceProcessHandle: Handle;
    SourceHandle: Handle;
    TargetProcessHandle: Handle;
    TargetHandle: PHandle;
    DesiredAccess: ACCESS_MASK;
    Attributes: ULONG;
    Options: ULONG): Cardinal; stdcall;

  TNativeCreateToken = function(TokenHandle: PHandle;
    DesiredAccess: ACCESS_MASK;
    ObjectAttributes: PObjectAttributes;
    Type_: TTOKENTYPE;
    AuthenticationId: PLUID;
    ExpirationTime: PLARGE_INTEGER;
    User: PTOKEN_USER;
    Groups: PTOKENGROUPS;
    Privileges: PTOKENPRIVILEGES;
    Owner: PTokenOwner;
    PrimaryGroup: PTOKEN_PRIMARY_GROUP;
    DefaultDacl: PTOKEN_DEFAULT_DACL;
    Source: PTOKEN_SOURCE): Cardinal; stdcall;

  TNativeDeviceIoControlFile = function(FileHandle: Handle;
    Event: Handle;
    ApcRoutine: PIO_APC_ROUTINE;
    ApcContext: PVOID;
    IoStatusBlock: PIO_STATUS_BLOCK;
    IoControlCode: ULONG;
    InputBuffer: PVOID;
    InputBufferLength: ULONG;
    OutputBuffer: PVOID;
    OutputBufferLength: ULONG): Cardinal; stdcall;

  TNtSystemDebugControl = function(ControlCode: DEBUG_CONTROL_CODE;
    InputBuffer: PVOID;
    InputBufferLength: ULONG;
    OutputBuffer: PVOID;
    OutputBufferLength: ULONG;
    ReturnLength: PULONG
    ): Cardinal; stdcall;

  TNativeCreateProcess = function(out ProcessHandle: PHandle; DesiredAccess: ACCESS_MASK;
    ObjectAttributes: PObjectAttributes; InheritFromProcessHandle: THandle;
    InheritHandles: boolean; SectionHandle, DebugPort, ExceptionPort: THandle): Cardinal; stdcall;

type                                    //Disk Serial Nomber
  TIDERegs = packed record
    bFeaturesReg: byte;                 // Used for specifying SMART "commands".
    bSectorCountReg: byte;              // IDE sector count register
    bSectorNumberReg: byte;             // IDE sector number register
    bCylLowReg: byte;                   // IDE low order cylinder value
    bCylHighReg: byte;                  // IDE high order cylinder value
    bDriveHeadReg: byte;                // IDE drive/head register
    bCommandReg: byte;                  // Actual IDE command.
    bReserved: byte;                    // reserved for future use. Must be zero.
  end;

  TSendCmdInParams = packed record
    cBufferSize: DWORD;                 // Buffer size in bytes
    irDriveRegs: TIDERegs;              // Structure with drive register values.
    bDriveNumber: byte;                 // Physical drive number to send command to (0,1,2,3).
    bReserved: array[0..2] of byte;
    dwReserved: array[0..3] of DWORD;
    bBuffer: array[0..0] of byte;       // Input buffer.
  end;

  TIdSector = packed record
    wGenConfig: WORD;
    wNumCyls: WORD;
    wReserved: WORD;
    wNumHeads: WORD;
    wBytesPerTrack: WORD;
    wBytesPerSector: WORD;
    wSectorsPerTrack: WORD;
    wVendorUnique: array[0..2] of WORD;
    sSerialNumber: array[0..19] of CHAR;
    wBufferType: WORD;
    wBufferSize: WORD;
    wECCSize: WORD;
    sFirmwareRev: array[0..7] of CHAR;
    sModelNumber: array[0..39] of CHAR;
    wMoreVendorUnique: WORD;
    wDoubleWordIO: WORD;
    wCapabilities: WORD;
    wReserved1: WORD;
    wPIOTiming: WORD;
    wDMATiming: WORD;
    wBS: WORD;
    wNumCurrentCyls: WORD;
    wNumCurrentHeads: WORD;
    wNumCurrentSectorsPerTrack: WORD;
    ulCurrentSectorCapacity: DWORD;
    wMultSectorStuff: WORD;
    ulTotalAddressableSectors: DWORD;
    wSingleWordDMA: WORD;
    wMultiWordDMA: WORD;
    bReserved: array[0..127] of byte;
  end;
  PIdSector = ^TIdSector;

  TDriverStatus = packed record
    bDriverError: byte;                 // 驱动器返回的错误代码，无错则返回0
    bIDEStatus: byte;                   // IDE出错寄存器的内容，只有当bDriverError 为 SMART_IDE_ERROR 时有效
    bReserved: array[0..1] of byte;
    dwReserved: array[0..1] of DWORD;
  end;

  TSendCmdOutParams = packed record
    cBufferSize: DWORD;                 // bBuffer的大小
    DriverStatus: TDriverStatus;        // 驱动器状态
    bBuffer: array[0..0] of byte;       // 用于保存从驱动器读出的数据的缓冲区，实际长度由cBufferSize决定
  end;

  //DMA
  PMemoryBuffer = ^TMemoryBuffer;
  TMemoryBuffer = array[0..65535] of ANSICHAR;
  TArrayBuffer = array[0..254] of ANSICHAR;

const
  NTDLL_DLL                 = 'NTDLL.DLL';

  STATUS_SUCCESS            = $00000000;
  STATUS_UNSUCCESSFUL       = $C0000001;
  STATUS_INFO_LENGTH_MISMATCH = $C0000004;
  STATUS_BUFFER_OVERFLOW    = $80000005;
  STATUS_INVALID_HANDLE     = $C0000008;
  STATUS_DATATYPE_MISALIGNMENT = $80000002;

  //Valid values for the Attributes field
  OBJ_INHERIT               = $00000002;
  OBJ_PERMANENT             = $00000010;
  OBJ_EXCLUSIVE             = $00000020;
  OBJ_CASE_INSENSITIVE      = $00000040;
  OBJ_OPENIF                = $00000080;
  OBJ_OPENLINK              = $00000100;
  OBJ_VALID_ATTRIBUTES      = $000001F2;

var
  NTDLLHandle               : THandle = 0;
  UnloadNTDLL               : boolean;

  NtOpenSection             : TNativeOpenSection = nil;
  NtClose                   : TNativeClose = nil;
  NtQueryInformationToken   : TNativeQueryInformationToken = nil;
  NtOpenProcessToken        : TNativeOpenProcessToken = nil;
  NtOpenProcess             : TNativeOpenProcess = nil;
  NtQuerySystemInformation  : TNativeQuerySystemInformation = nil;
  NtCreateSection           : TNativeCreateSection = nil;
  NtMapViewOfSection        : TNativeMapViewOfSection = nil;
  NtUnmapViewOfSection      : TNativeUnmapViewOfSection = nil;
  NtCreateFile              : TNativeCreateFile = nil;
  NtOpenFile                : TNativeOpenFile = nil;
  NtQueryObject             : TNativeQueryObject = nil;
  NtQueryInformationProcess : TNativeQueryInformationProcess = nil;
  NtQueryInformationThread  : TNativeQueryInformationThread = nil;
  NtQueryInformationFile    : TNativeQueryInformationFile = nil;
  NtDuplicateObject         : TNativeDuplicateObject = nil;
  NtCreateToken             : TNativeCreateToken = nil;
  NtDeviceIoControlFile     : TNativeDeviceIoControlFile = nil;
  NtSystemDebugControl      : TNtSystemDebugControl = nil;
  NtCreateProcess           : TNativeCreateProcess = nil;

function InitNativeAPI: boolean;
procedure FreeNativeAPI;

const
  cKWaitReason              : array[TKWaitReason] of string = (
    'Executive',
    'FreePage',
    'PageIn',
    'PoolAllocation',
    'DelayExecution',
    'Suspended',
    'UserRequest',
    'WrExecutive',
    'WrFreePage',
    'WrPageIn',
    'WrPoolAllocation',
    'WrDelayExecution',
    'WrSuspended',
    'WrUserRequest',
    'WrEventPair',
    'WrQueue',
    'WrLpcReceive',
    'WrLpcReply',
    'WrVirtualMemory',
    'WrPageOut',
    'WrRendezvous',
    'Spare2',
    'Spare3',
    'Spare4',
    'Spare5',
    'Spare6',
    'WrKernel',
    'MaximumWaitReason');

  cThreadState              : array[TThreadState] of string = (
    'Initialized',
    'Ready',
    'Running',
    'Standby',
    'Terminated',
    'Wait',
    'Transition',
    'Unknown');

  cSystemHandleType         : array[TSystemHandleType] of string =
    ('Unknown',
    'Type',
    'Directory',
    'Symbolic Link',
    'Token',
    'Process',
    'Thread',
    'Unknown 7',
    'Event',
    'Event Pair',
    'Mutant',
    'Unknown 11',
    'Semaphore',
    'Timer',
    'Profile',
    'Window Station',
    'Desktop',
    'Section',
    'Key',
    'Port',
    'Waitable Port',
    'Unknown 21',
    'Unknown 22',
    'Unknown 23',
    'Unknown 24',
    //OB_TYPE_CONTROLLER,
    //OB_TYPE_DEVICE,
    //OB_TYPE_DRIVER,
    'I/O Completion',
    'File');

  //function CreateSystemToken: THandle;

implementation

function InitNativeAPI;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then begin
    NTDLLHandle := GetModuleHandle(NTDLL_DLL);
    UnloadNTDLL := NTDLLHandle = 0;
    if NTDLLHandle = 0 then
      NTDLLHandle := LoadLibrary(NTDLL_DLL);
    if NTDLLHandle <> 0 then begin
      @NtQueryInformationToken := GetProcAddress(NTDLLHandle, 'NtQueryInformationToken');
      @NtOpenProcessToken := GetProcAddress(NTDLLHandle, 'NtOpenProcessToken');
      @NtOpenSection := GetProcAddress(NTDLLHandle, 'NtOpenSection');
      @NtClose := GetProcAddress(NTDLLHandle, 'NtClose');
      @NtOpenProcess := GetProcAddress(NTDLLHandle, 'NtOpenProcess');
      @NtCreateProcess := GetProcAddress(NTDLLHandle, 'NtCreateProcess');
      @NtQuerySystemInformation := GetProcAddress(NTDLLHandle, 'NtQuerySystemInformation');
      @NtCreateSection := GetProcAddress(NTDLLHandle, 'NtCreateSection');
      @NtCreateToken := GetProcAddress(NTDLLHandle, 'NtCreateToken');
      @NtMapViewOfSection := GetProcAddress(NTDLLHandle, 'NtMapViewOfSection');
      @NtUnmapViewOfSection := GetProcAddress(NTDLLHandle, 'NtUnmapViewOfSection');
      @NtOpenFile := GetProcAddress(NTDLLHandle, 'NtOpenFile');
      @NtCreateFile := GetProcAddress(NTDLLHandle, 'NtCreateFile');
      @NtQueryObject := GetProcAddress(NTDLLHandle, 'NtQueryObject');
      @NtQueryInformationProcess := GetProcAddress(NTDLLHandle, 'NtQueryInformationProcess');
      @NtQueryInformationThread := GetProcAddress(NTDLLHandle, 'NtQueryInformationThread');
      @NtQueryInformationFile := GetProcAddress(NTDLLHandle, 'NtQueryInformationFile');
      @NtDuplicateObject := GetProcAddress(NTDLLHandle, 'NtDuplicateObject');
      @NtDeviceIoControlFile := GetProcAddress(NTDLLHandle, 'NtDeviceIoControlFile');
      @NtSystemDebugControl := GetProcAddress(NTDLLHandle, 'ZwSystemDebugControl');
    end;
  end;
  Result := (NTDLLHandle <> 0) and Assigned(NtQueryObject);
end;

procedure FreeNativeAPI;
begin
  if (NTDLLHandle <> 0) and UnloadNTDLL then begin
    if not FreeLibrary(NTDLLHandle) then
      raise Exception.Create(Format('Unload Error: %s - 0x%x', [NTDLL_DLL, GetModuleHandle(NTDLL_DLL)]))
    else
      NTDLLHandle := 0;
  end;
end;

initialization
  InitNativeAPI;

finalization
  FreeNativeAPI;

end.

