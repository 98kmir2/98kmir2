unit DXSounds;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, ExtCtrls, MMSystem, ActiveX, CnHashTable,
  DXClass, DXWave,
{$IFDEF StandardDX}
  DirectSound, DirectMusic;
{$ELSE}
  DirectX;
{$ENDIF}

type

  {  EDirectSoundError  }

  EDirectSoundError = class(EDirectXError);
  EDirectSoundBufferError = class(EDirectSoundError);

  {  TDirectSound  }

  TDirectSoundBuffer = class;

  TDirectSound = class(TDirectX)
  private
    FBufferList: TList;
    FGlobalFocus: Boolean;
    FIDSound: IDirectSound;
    FInRestoreBuffer: Boolean;
    FStickyFocus: Boolean;
    function GetBuffer(Index: Integer): TDirectSoundBuffer;
    function GetBufferCount: Integer;
    function GetIDSound: IDirectSound;
    function GetISound: IDirectSound;
  protected
    procedure CheckBuffer(Buffer: TDirectSoundBuffer);
    procedure DoRestoreBuffer; virtual;
  public
    constructor Create(GUID: PGUID);
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    property BufferCount: Integer read GetBufferCount;
    property Buffers[Index: Integer]: TDirectSoundBuffer read GetBuffer;
    property IDSound: IDirectSound read GetIDSound;
    property ISound: IDirectSound read GetISound;
  end;

  {  TDirectSoundBuffer  }

  TDirectSoundBuffer = class(TDirectX)
  private
    FDSound: TDirectSound;
    FIDSBuffer: IDirectSoundBuffer;
    FCaps: TDSBCaps;
    FFormat: PWaveFormatEx;
    FFormatSize: Integer;
    FLockAudioPtr1, FLockAudioPtr2: array[0..0] of Pointer;
    FLockAudioSize1, FLockAudioSize2: array[0..0] of DWORD;
    FLockCount: Integer;
    function GetBitCount: Longint;
    function GetFormat: PWaveFormatEx;
    function GetFrequency: Integer;
    function GetIDSBuffer: IDirectSoundBuffer;
    function GetIBuffer: IDirectSoundBuffer;
    function GetPlaying: Boolean;
    function GetPan: Integer;
    function GetPosition: Longint;
    function GetSize: Integer;
    function GetStatus: Integer;
    function GetVolume: Integer;
    procedure SetFrequency(Value: Integer);
    procedure SetIDSBuffer(Value: IDirectSoundBuffer);
    procedure SetPan(Value: Integer);
    procedure SetPosition(Value: Longint);
    procedure SetVolume(Value: Integer);
  protected
    procedure Check; override;
  public
    FEffectTick: LongWord;
    constructor Create(ADirectSound: TDirectSound);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function CreateBuffer(const BufferDesc: TDSBufferDesc): Boolean;
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromMemory(const Format: TWaveFormatEx;
      Data: Pointer; Size: Integer);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromWave(Wave: TWave);
    function Lock(LockPosition, LockSize: Longint;
      var AudioPtr1: Pointer; var AudioSize1: Longint;
      var AudioPtr2: Pointer; var AudioSize2: Longint): Boolean;
    function Play(Loop: Boolean{$IFNDEF VER100} = False{$ENDIF}): Boolean;
    function Restore: Boolean;
    function SetFormat(const Format: TWaveFormatEx): Boolean;
    procedure SetSize(const Format: TWaveFormatEx; Size: Integer);
    procedure Stop;
    procedure UnLock;
    property BitCount: Longint read GetBitCount;
    property DSound: TDirectSound read FDSound;
    property Format: PWaveFormatEx read GetFormat;
    property FormatSize: Integer read FFormatSize;
    property Frequency: Integer read GetFrequency write SetFrequency;
    property IBuffer: IDirectSoundBuffer read GetIBuffer;
    property IDSBuffer: IDirectSoundBuffer read GetIDSBuffer write SetIDSBuffer;
    property Playing: Boolean read GetPlaying;
    property Pan: Integer read GetPan write SetPan;
    property Position: Longint read GetPosition write SetPosition;
    property Size: Integer read GetSize;
    property Volume: Integer read GetVolume write SetVolume;
  end;

  {  EAudioStreamError  }

  EAudioStreamError = class(Exception);

  {  TAudioStream  }

  TAudioStream = class
  private
    FAutoUpdate: Boolean;
    FBuffer: TDirectSoundBuffer;
    FBufferLength: Integer;
    FBufferPos: DWORD;
    FPlayBufferPos: DWORD;
    FBufferSize: DWORD;
    FDSound: TDirectSound;
    FLooped: Boolean;
    FPlayedSize: Integer;
    FPlaying: Boolean;
    FPosition: Integer;
    FWaveStream: TCustomWaveStream;
    FWritePosition: Integer;
    FNotifyEvent: THandle;
    FNotifyThread: TThread;
    function GetFormat: PWaveFormatEx;
    function GetFormatSize: Integer;
    function GetFrequency: Integer;
    function GetPan: Integer;
    function GetPlayedSize: Integer;
    function GetSize: Integer;
    function GetVolume: Integer;
    function GetWriteSize: Integer;
    procedure SetAutoUpdate(Value: Boolean);
    procedure SetBufferLength(Value: Integer);
    procedure SetFrequency(Value: Integer);
    procedure SetLooped(Value: Boolean);
    procedure SetPan(Value: Integer);
    procedure SetPlayedSize(Value: Integer);
    procedure SetPosition(Value: Integer);
    procedure SetVolume(Value: Integer);
    procedure SetWaveStream(Value: TCustomWaveStream);
    procedure Update2(InThread: Boolean);
    procedure UpdatePlayedSize;
    function WriteWave(WriteSize: Integer): Integer;
  public
    constructor Create(ADirectSound: TDirectSound);
    destructor Destroy; override;
    procedure Play;
    procedure RecreateBuf;
    procedure Stop;
    procedure Update;
    property AutoUpdate: Boolean read FAutoUpdate write SetAutoUpdate;
    property BufferLength: Integer read FBufferLength write SetBufferLength;
    property Format: PWaveFormatEx read GetFormat;
    property FormatSize: Integer read GetFormatSize;
    property Frequency: Integer read GetFrequency write SetFrequency;
    property Pan: Integer read GetPan write SetPan;
    property PlayedSize: Integer read GetPlayedSize write SetPlayedSize;
    property Playing: Boolean read FPlaying;
    property Position: Integer read FPosition write SetPosition;
    property Looped: Boolean read FLooped write SetLooped;
    property Size: Integer read GetSize;
    property Volume: Integer read GetVolume write SetVolume;
    property WaveStream: TCustomWaveStream read FWaveStream write SetWaveStream;
  end;

  {  TAudioFileStream  }

  TAudioFileStream = class(TAudioStream)
  private
    FFileName: string;
    FWaveFileStream: TWaveFileStream;
    procedure SetFileName(const Value: string);
  public
    destructor Destroy; override;
    property FileName: string read FFileName write SetFileName;
  end;

  {  TSoundCaptureFormat  }

  TSoundCaptureFormat = class(TCollectionItem)
  private
    FBitsPerSample: Integer;
    FChannels: Integer;
    FSamplesPerSec: Integer;
  public
    property BitsPerSample: Integer read FBitsPerSample;
    property Channels: Integer read FChannels;
    property SamplesPerSec: Integer read FSamplesPerSec;
  end;

  {  TSoundCaptureFormats  }

  TSoundCaptureFormats = class(TCollection)
  private
    function GetItem(Index: Integer): TSoundCaptureFormat;
  public
    constructor Create;
    function IndexOf(ASamplesPerSec, ABitsPerSample, AChannels: Integer): Integer;
    property Items[Index: Integer]: TSoundCaptureFormat read GetItem; default;
  end;

  {  TSoundCaptureStream  }

  ESoundCaptureStreamError = class(EWaveStreamError);

  TSoundCaptureStream = class(TCustomWaveStream2)
  private
    FBuffer: IDirectSoundCaptureBuffer;
    FBufferLength: Integer;
    FBufferPos: DWORD;
    FBufferSize: DWORD;
    FCapture: IDirectSoundCapture;
    FCaptureFormat: Integer;
    FCapturing: Boolean;
    FNotifyEvent: THandle;
    FNotifyThread: TThread;
    FOnFilledBuffer: TNotifyEvent;
    FSupportedFormats: TSoundCaptureFormats;
    function GetReadSize: Integer;
    procedure SetBufferLength(Value: Integer);
    procedure SetOnFilledBuffer(Value: TNotifyEvent);
  protected
    procedure DoFilledBuffer; virtual;
    function GetFilledSize: Integer; override;
    function ReadWave(var Buffer; Count: Integer): Integer; override;
  public
    constructor Create(GUID: PGUID);
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    procedure Start;
    procedure Stop;
    property BufferLength: Integer read FBufferLength write SetBufferLength;
    property CaptureFormat: Integer read FCaptureFormat write FCaptureFormat;
    property Capturing: Boolean read FCapturing;
    property OnFilledBuffer: TNotifyEvent read FOnFilledBuffer write SetOnFilledBuffer;
    property SupportedFormats: TSoundCaptureFormats read FSupportedFormats;
  end;

  {  TSoundEngine  }

  TSoundEngine = class
  private
    FDSound: TDirectSound;
    FEffectList: TList;
    FEffectWaveList: TCnHashTableSmall;
    FEnabled: Boolean;
    FTimer: TTimer;
    FSendRequestList: TStringlist;
    function GetEffect(Index: Integer): TDirectSoundBuffer;
    function GetEffectWave(Index: Integer): TWave;
    //function GetEffectName(Name: string): TDirectSoundBuffer;
    function GetEffectWaveName(Name: string): TWave;
    function GetEffectCount: Integer;
    function GetEffectWaveCount: Integer;
    procedure SetEnabled(Value: Boolean);
    procedure TimerEvent(Sender: TObject);
  public
    constructor Create(ADSound: TDirectSound);
    destructor Destroy; override;
    procedure Clear;
    //procedure EffectFile(const FileName: string; Loop, Wait: Boolean);
    //procedure EffectStream(Stream: TStream; Loop, Wait: Boolean);
    procedure EffectFile(const FileName: string; Loop, Wait, Exists: Boolean; Pan: Integer = -123456; lVolume: Integer = 100); //(Wave: TWave; Loop, Wait: Boolean);
    property EffectCount: Integer read GetEffectCount;
    property EffectWaveCount: Integer read GetEffectWaveCount;
    property Effects[Index: Integer]: TDirectSoundBuffer read GetEffect;
    property EffectWaves[Index: Integer]: TWave read GetEffectWave;
    property Enabled: Boolean read FEnabled write SetEnabled;
  end;

  {  EDXSoundError  }

  EDXSoundError = class(Exception);

  {  TCustomDXSound  }

  TCustomDXSound = class;

  TDXSoundOption = (soGlobalFocus, soStickyFocus, soExclusive);
  TDXSoundOptions = set of TDXSoundOption;

  TDXSoundNotifyType = (dsntDestroying, dsntInitializing, dsntInitialize, dsntFinalize, dsntRestore);
  TDXSoundNotifyEvent = procedure(Sender: TCustomDXSound; NotifyType: TDXSoundNotifyType) of object;

  TCustomDXSound = class(TComponent)
  private
    FAutoInitialize: Boolean;
    FCalledDoInitialize: Boolean;
    FDriver: PGUID;
    FDriverGUID: TGUID;
    FDSound: TDirectSound;
    FForm: TCustomForm;
    FInitialized: Boolean;
    FInternalInitialized: Boolean;
    FNotifyEventList: TList;
    FNowOptions: TDXSoundOptions;
    FOnFinalize: TNotifyEvent;
    FOnInitialize: TNotifyEvent;
    FOnInitializing: TNotifyEvent;
    FOnRestore: TNotifyEvent;
    FOptions: TDXSoundOptions;
    FPrimary: TDirectSoundBuffer;
    FSubClass: TControlSubClass;
    procedure FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);
    procedure NotifyEventList(NotifyType: TDXSoundNotifyType);
    procedure SetDriver(Value: PGUID);
    procedure SetForm(Value: TCustomForm);
    procedure SetOptions(Value: TDXSoundOptions);
  protected
    procedure DoFinalize; virtual;
    procedure DoInitialize; virtual;
    procedure DoInitializing; virtual;
    procedure DoRestore; virtual;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    procedure Finalize;
    procedure Initialize;
    procedure Restore;
    procedure RegisterNotifyEvent(NotifyEvent: TDXSoundNotifyEvent);
    procedure UnRegisterNotifyEvent(NotifyEvent: TDXSoundNotifyEvent);

    property AutoInitialize: Boolean read FAutoInitialize write FAutoInitialize;
    property Driver: PGUID read FDriver write SetDriver;
    property DSound: TDirectSound read FDSound;
    property Initialized: Boolean read FInitialized;
    property NowOptions: TDXSoundOptions read FNowOptions;
    property Primary: TDirectSoundBuffer read FPrimary;
    property OnFinalize: TNotifyEvent read FOnFinalize write FOnFinalize;
    property OnInitialize: TNotifyEvent read FOnInitialize write FOnInitialize;
    property OnInitializing: TNotifyEvent read FOnInitializing write FOnInitializing;
    property OnRestore: TNotifyEvent read FOnRestore write FOnRestore;
    property Options: TDXSoundOptions read FOptions write SetOptions;
  end;

  {  TDXSound  }

  TDXSound = class(TCustomDXSound)
  published
    property AutoInitialize;
    property Options;
    property OnFinalize;
    property OnInitialize;
    property OnInitializing;
    property OnRestore;
  end;

  {  EWaveCollectionError  }

  EWaveCollectionError = class(Exception);

  {  TWaveCollectionItem  }

  TWaveCollection = class;

  TWaveCollectionItem = class(THashCollectionItem)
  private
    FBuffer: TDirectSoundBuffer;
    FBufferList: TList;
    FFrequency: Integer;
    FInitialized: Boolean;
    FLooped: Boolean;
    FMaxPlayingCount: Integer;
    FPan: Integer;
    FVolume: Integer;
    FWave: TWave;
    function CreateBuffer: TDirectSoundBuffer;
    procedure Finalize;
    procedure Initialize;
    function GetBuffer: TDirectSoundBuffer;
    function GetWaveCollection: TWaveCollection;
    procedure SetFrequency(Value: Integer);
    procedure SetLooped(Value: Boolean);
    procedure SetMaxPlayingCount(Value: Integer);
    procedure SetPan(Value: Integer);
    procedure SetVolume(Value: Integer);
    procedure SetWave(Value: TWave);
  protected
    function GetPlaying: Boolean;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Play(Wait: Boolean);
    procedure Restore;
    procedure Stop;
    property Frequency: Integer read FFrequency write SetFrequency;
    property Initialized: Boolean read FInitialized;
    property Pan: Integer read FPan write SetPan;
    property Volume: Integer read FVolume write SetVolume;
    property WaveCollection: TWaveCollection read GetWaveCollection;

    property Playing: Boolean read GetPlaying;
  published
    property Looped: Boolean read FLooped write SetLooped;
    property MaxPlayingCount: Integer read FMaxPlayingCount write SetMaxPlayingCount;
    property Wave: TWave read FWave write SetWave;
  end;

  {  TWaveCollection  }

  TWaveCollection = class(THashCollection)
  private
    FDXSound: TCustomDXSound;
    FOwner: TPersistent;
    function GetItem(Index: Integer): TWaveCollectionItem;
    function Initialized: Boolean;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
    function Find(const Name: string): TWaveCollectionItem;
    procedure Finalize;
    procedure Initialize(DXSound: TCustomDXSound);
    procedure Restore;
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    property DXSound: TCustomDXSound read FDXSound;
    property Items[Index: Integer]: TWaveCollectionItem read GetItem; default;
  end;

  {  TCustomDXWaveList  }

  TCustomDXWaveList = class(TComponent)
  private
    FDXSound: TCustomDXSound;
    FItems: TWaveCollection;
    procedure DXSoundNotifyEvent(Sender: TCustomDXSound; NotifyType: TDXSoundNotifyType);
    procedure SetDXSound(Value: TCustomDXSound);
    procedure SetItems(Value: TWaveCollection);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property DXSound: TCustomDXSound read FDXSound write SetDXSound;
    property Items: TWaveCollection read FItems write SetItems;
  end;

  {  TDXWaveList  }

  TDXWaveList = class(TCustomDXWaveList)
  published
    property DXSound;
    property Items;
  end;

  {  EDXMusicError  }

  EDXMusicError = class(Exception);

  TMusicListCollection = class;

  {  TMusicListCollectionItem  }

  TMusicDataProp = class(TPersistent)
  private
    FMusicData: string;
    FMidiname: string;
    function GetMusicData: string;
    procedure SetMusicData(const Value: string);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadMidiData(Stream: TStream);
    procedure WriteMidiData(Stream: TStream);
  public
    property MusicData: string read GetMusicData write SetMusicData;
  published
    property MidiName: string read FMidiname write FMidiname;
  end;

  TMusicListCollectionItem = class(THashCollectionItem)
  private
    { Private declarations }
    FDirectMusicPerformance: IDirectMusicPerformance;
    FDirectSound: IDirectSound;
    FDirectMusic: IDirectMusic;
    FDirectMusicLoader: IDirectMusicLoader;
    FDirectMusicSegment: IDirectMusicSegment;
    FMusicObjDesc: TDMus_ObjectDesc;
    FDirectMusicSegmentState: IDirectMusicSegmentState;
    FRepeats: Cardinal;
    FStartpoint: Integer;
    FDuration: Integer;
    // startpoint props in seconds these used to hold millisecond value
    FActualDuration: Integer;
    FActualStartPoint: Integer;
    FIsInitialized: Boolean;
    FMusicDataProp: TMusicDataProp;
    procedure SetDuration(const Value: Integer);
    procedure SetRepeats(const Value: Cardinal);
    procedure SetStartPoint(const Value: Integer);
    function GetMusicListCollection: TMusicListCollection;
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    function Size: Integer;
    procedure Play;
    function IsPlaying: Boolean;
    procedure Stop;
    procedure Load;
    procedure Init;
    procedure LoadFromFile(const MidiFileName: string);
    procedure SaveToFile(const MidiFileName: string);
    property MusicCollection: TMusicListCollection read GetMusicListCollection;
    property IsInitialized: Boolean read FIsInitialized write FIsInitialized;
  published
    property Name;
    property Repeats: Cardinal read FRepeats write SetRepeats;
    property Duration: Integer read FDuration write SetDuration;
    property StartPoint: Integer read FStartpoint write SetStartPoint;
    property Midi: TMusicDataProp read FMusicDataProp write FMusicDataProp;
  end;

  {  TMusicListCollection  }

  TMusicListCollection = class(THashCollection)
  private
    FOwner: TPersistent;
    FDirectSound: IDirectSound;
  protected
    function GetItem(Index: Integer): TMusicListCollectionItem;
    procedure SetItem(Index: Integer; Value: TMusicListCollectionItem);
    procedure Update(Item: TCollectionItem); override;
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TComponent);
    function Add: TMusicListCollectionItem;
    function Find(const Name: string): TMusicListCollectionItem;
    procedure Restore;
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
{$IFDEF DelphiX_Spt4}
    function Insert(Index: Integer): TMusicListCollectionItem;
{$ENDIF}
    property Items[Index: Integer]: TMusicListCollectionItem read GetItem write SetItem;
  published
  end;

  {  TDXMusic  }

  TDXMusic = class(TComponent)
  private
    FDXSound: TDXSound;
    FMidis: TMusicListCollection;
    procedure SetMidis(const Value: TMusicListCollection);
    procedure SetDXSound(const Value: TDXSound);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DXSound: TDXSound read FDXSound write SetDXSound;
    property Midis: TMusicListCollection read FMidis write SetMidis;
  end;

implementation

uses DXConsts, PatchUnit;

const
  dm_OK                     = 0;

function DXDirectSoundCreate(lpGUID: PGUID; out lpDS: IDirectSound;
  pUnkOuter: IUnknown): HRESULT;
type
  TDirectSoundCreate = function(lpGUID: PGUID; out lplpDD: IDirectSound;
    pUnkOuter: IUnknown): HRESULT; stdcall;
begin
  Result := TDirectSoundCreate(DXLoadLibrary('DSound.dll', 'DirectSoundCreate'))
    (lpGUID, lpDS, pUnkOuter);
end;

function DXDirectSoundEnumerate(lpCallback: TDSEnumCallbackA;
  lpContext: Pointer): HRESULT;
type
  TDirectSoundEnumerate = function(lpCallback: TDSEnumCallbackA;
    lpContext: Pointer): HRESULT; stdcall;
begin
  Result := TDirectSoundEnumerate(DXLoadLibrary('DSound.dll', 'DirectSoundEnumerateA'))
    (lpCallback, lpContext);
end;

function DXDirectSoundCaptureCreate(lpGUID: PGUID; out lplpDSC: IDirectSoundCapture;
  pUnkOuter: IUnknown): HRESULT;
type
  TDirectSoundCaptureCreate = function(lpGUID: PGUID; out lplpDD: IDirectSoundCapture;
    pUnkOuter: IUnknown): HRESULT; stdcall;
begin
  try
    Result := TDirectSoundCaptureCreate(DXLoadLibrary('DSound.dll', 'DirectSoundCaptureCreate'))
      (lpGUID, lplpDSC, pUnkOuter);
  except
    raise EDirectXError.Create(SSinceDirectX5);
  end;
end;

function DXDirectSoundCaptureEnumerate(lpCallback: TDSEnumCallbackA;
  lpContext: Pointer): HRESULT;
type
  TDirectSoundCaptureEnumerate = function(lpCallback: TDSEnumCallbackA;
    lpContext: Pointer): HRESULT; stdcall;
begin
  try
    Result := TDirectSoundCaptureEnumerate(DXLoadLibrary('DSound.dll', 'DirectSoundCaptureEnumerateA'))
      (lpCallback, lpContext);
  except
    raise EDirectXError.Create(SSinceDirectX5);
  end;
end;

var
  DirectSoundDrivers        : TDirectXDrivers;
  DirectSoundCaptureDrivers : TDirectXDrivers;

function EnumDirectSoundDrivers_DSENUMCALLBACK(lpGUID: PGUID; lpstrDescription: LPCSTR;
  lpstrModule: LPCSTR; lpContext: Pointer): BOOL; stdcall;
begin
  Result := True;
  with TDirectXDriver.Create(TDirectXDrivers(lpContext)) do begin
    GUID := lpGUID;
    Description := lpstrDescription;
    DriverName := lpstrModule;
  end;
end;

function EnumDirectSoundDrivers: TDirectXDrivers;
begin
  if DirectSoundDrivers = nil then begin
    DirectSoundDrivers := TDirectXDrivers.Create;
    try
      DXDirectSoundEnumerate(@EnumDirectSoundDrivers_DSENUMCALLBACK, DirectSoundDrivers);
    except
      DirectSoundDrivers.Free;
      raise;
    end;
  end;

  Result := DirectSoundDrivers;
end;

function EnumDirectSoundCaptureDrivers: TDirectXDrivers;
begin
  if DirectSoundCaptureDrivers = nil then begin
    DirectSoundCaptureDrivers := TDirectXDrivers.Create;
    try
      DXDirectSoundCaptureEnumerate(@EnumDirectSoundDrivers_DSENUMCALLBACK, DirectSoundCaptureDrivers);
    except
      DirectSoundCaptureDrivers.Free;
      raise;
    end;
  end;

  Result := DirectSoundCaptureDrivers;
end;

{  TDirectSound  }

constructor TDirectSound.Create(GUID: PGUID);
begin
  inherited Create;
  FBufferList := TList.Create;

  if DXDirectSoundCreate(GUID, FIDSound, nil) <> DS_OK then
    raise EDirectSoundError.CreateFmt(SCannotInitialized, [SDirectSound]);
end;

destructor TDirectSound.Destroy;
begin
  while BufferCount > 0 do
    Buffers[BufferCount - 1].Free;
  FBufferList.Free;

  FIDSound := nil;
  inherited Destroy;
end;

class function TDirectSound.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectSoundDrivers;
end;

procedure TDirectSound.CheckBuffer(Buffer: TDirectSoundBuffer);
begin
  case Buffer.DXResult of
    DSERR_BUFFERLOST: begin
        if not FInRestoreBuffer then begin
          FInRestoreBuffer := True;
          try
            DoRestoreBuffer;
          finally
            FInRestoreBuffer := False;
          end;
        end;
      end;
  end;
end;

procedure TDirectSound.DoRestoreBuffer;
begin
end;

function TDirectSound.GetBuffer(Index: Integer): TDirectSoundBuffer;
begin
  Result := FBufferList[Index];
end;

function TDirectSound.GetBufferCount: Integer;
begin
  Result := FBufferList.Count;
end;

function TDirectSound.GetIDSound: IDirectSound;
begin
  if Self <> nil then
    Result := FIDSound
  else
    Result := nil;
end;

function TDirectSound.GetISound: IDirectSound;
begin
  Result := IDSound;
  if Result = nil then
    raise EDirectSoundError.CreateFmt(SNotMade, ['IDirectSound']);
end;

{  TDirectSoundBuffer  }

constructor TDirectSoundBuffer.Create(ADirectSound: TDirectSound);
begin
  inherited Create;
  FDSound := ADirectSound;
  FEffectTick := GetTickCount();
  FDSound.FBufferList.Add(Self);
end;

destructor TDirectSoundBuffer.Destroy;
begin
  IDSBuffer := nil;
  FDSound.FBufferList.Remove(Self);
  inherited Destroy;
end;

procedure TDirectSoundBuffer.Assign(Source: TPersistent);
var
  TempBuffer                : IDirectSoundBuffer;
begin
  if Source = nil then
    IDSBuffer := nil
  else if Source is TWave then
    LoadFromWave(TWave(Source))
  else if Source is TDirectSoundBuffer then begin
    if TDirectSoundBuffer(Source).IDSBuffer = nil then
      IDSBuffer := nil
    else begin
      FDSound.DXResult := FDSound.ISound.DuplicateSoundBuffer(TDirectSoundBuffer(Source).IDSBuffer,
        TempBuffer);
      if FDSound.DXResult = 0 then begin
        IDSBuffer := TempBuffer;
      end;
    end;
  end else
    inherited Assign(Source);
end;

procedure TDirectSoundBuffer.Check;
begin
  FDSound.CheckBuffer(Self);
end;

function TDirectSoundBuffer.CreateBuffer(const BufferDesc: TDSBufferDesc): Boolean;
var
  TempBuffer                : IDirectSoundBuffer;
begin
  IDSBuffer := nil;

  FDSound.DXResult := FDSound.ISound.CreateSoundBuffer(BufferDesc, TempBuffer, nil);
  FDXResult := FDSound.DXResult;
  Result := DXResult = DS_OK;
  if Result then
    IDSBuffer := TempBuffer;
end;

function TDirectSoundBuffer.GetBitCount: Longint;
begin
  Result := Format.wBitsPerSample;
end;

function TDirectSoundBuffer.GetFormat: PWaveFormatEx;
begin
  GetIBuffer;
  Result := FFormat;
end;

function TDirectSoundBuffer.GetFrequency: Integer;
begin
  DXResult := IBuffer.GetFrequency(DWORD(Result));
end;

function TDirectSoundBuffer.GetIDSBuffer: IDirectSoundBuffer;
begin
  if Self <> nil then
    Result := FIDSBuffer
  else
    Result := nil;
end;

function TDirectSoundBuffer.GetIBuffer: IDirectSoundBuffer;
begin
  Result := IDSBuffer;
  if Result = nil then
    raise EDirectSoundBufferError.CreateFmt(SNotMade, ['IDirectSoundBuffer']);
end;

function TDirectSoundBuffer.GetPlaying: Boolean;
begin
  Result := (GetStatus and (DSBSTATUS_PLAYING or DSBSTATUS_LOOPING)) <> 0;
end;

function TDirectSoundBuffer.GetPan: Integer;
begin
  DXResult := IBuffer.GetPan(Longint(Result));
end;

function TDirectSoundBuffer.GetPosition: Longint;
var
  dwCurrentWriteCursor      : Longint;
begin
  IBuffer.GetCurrentPosition(@DWORD(Result), @DWORD(dwCurrentWriteCursor));
end;

function TDirectSoundBuffer.GetSize: Integer;
begin
  Result := FCaps.dwBufferBytes;
end;

function TDirectSoundBuffer.GetStatus: Integer;
begin
  DXResult := IBuffer.GetStatus(DWORD(Result));
end;

function TDirectSoundBuffer.GetVolume: Integer;
begin
  DXResult := IBuffer.GetVolume(Longint(Result));
end;

procedure TDirectSoundBuffer.LoadFromFile(const FileName: string);
var
  Stream                    : TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TDirectSoundBuffer.LoadFromMemory(const Format: TWaveFormatEx;
  Data: Pointer; Size: Integer);
var
  Data1, Data2              : Pointer;
  Data1Size, Data2Size      : Longint;
begin
  SetSize(Format, Size);

  if Data <> nil then begin
    if Lock(0, Size, Data1, Data1Size, Data2, Data2Size) then begin
      try
        Move(Data^, Data1^, Data1Size);
        if Data2 <> nil then
          Move(Pointer(Longint(Data) + Data1Size)^, Data2^, Data2Size);
      finally
        UnLock;
      end;
    end else begin
      FIDSBuffer := nil;
      raise EDirectSoundBufferError.CreateFmt(SCannotLock, [SDirectSoundBuffer]);
    end;
  end;
end;

procedure TDirectSoundBuffer.LoadFromStream(Stream: TStream);
var
  Wave                      : TWave;
begin
  Wave := TWave.Create;
  try
    Wave.LoadFromStream(Stream);
    LoadFromWave(Wave);
  finally
    Wave.Free;
  end;
end;

procedure TDirectSoundBuffer.LoadFromWave(Wave: TWave);
begin
  LoadFromMemory(Wave.Format^, Wave.Data, Wave.Size);
end;

function TDirectSoundBuffer.Lock(LockPosition, LockSize: Longint;
  var AudioPtr1: Pointer; var AudioSize1: Longint;
  var AudioPtr2: Pointer; var AudioSize2: Longint): Boolean;
begin
  Result := False;
  if IDSBuffer = nil then Exit;

  if FLockCount > High(FLockAudioPtr1) then Exit;
  DXResult := IBuffer.Lock(LockPosition, LockSize,
    FLockAudioPtr1[FLockCount], {$IFNDEF DX7}@{$ENDIF}FLockAudioSize1[FLockCount],
    FLockAudioPtr2[FLockCount], {$IFNDEF DX7}@{$ENDIF}FLockAudioSize2[FLockCount], 0);
  Result := DXResult = DS_OK;

  if Result then begin
    AudioPtr1 := FLockAudioPtr1[FLockCount];
    AudioPtr2 := FLockAudioPtr2[FLockCount];
    AudioSize1 := FLockAudioSize1[FLockCount];
    AudioSize2 := FLockAudioSize2[FLockCount];
    Inc(FLockCount);
  end;
end;

function TDirectSoundBuffer.Play(Loop: Boolean): Boolean;
begin
  if Loop then
    DXResult := IBuffer.Play(0, 0, DSBPLAY_LOOPING)
  else
    DXResult := IBuffer.Play(0, 0, 0);
  Result := DXResult = DS_OK;
  if Result then FEffectTick := GetTickCount();
end;

function TDirectSoundBuffer.Restore: Boolean;
begin
  DXResult := IBuffer.Restore;
  Result := DXResult = DS_OK;
end;

function TDirectSoundBuffer.SetFormat(const Format: TWaveFormatEx): Boolean;
begin
  DXResult := IBuffer.SetFormat(FFormat{$IFDEF DX7}^{$ENDIF});
  Result := DXResult = DS_OK;

  if Result then begin
    FreeMem(FFormat);
    FFormat := nil;
    FFormatSize := 0;
    if IBuffer.GetFormat(PWaveFormatEx(nil), 0, @DWORD(FFormatSize)) = DS_OK then begin
      GetMem(FFormat, FFormatSize);
      IBuffer.GetFormat(FFormat, FFormatSize, nil);
    end;
  end;
end;

procedure TDirectSoundBuffer.SetFrequency(Value: Integer);
begin
  DXResult := IBuffer.SetFrequency(Value);
end;

procedure TDirectSoundBuffer.SetIDSBuffer(Value: IDirectSoundBuffer);
begin
  if FIDSBuffer = Value then Exit;

  FIDSBuffer := Value;
  FillChar(FCaps, SizeOf(FCaps), 0);
  FreeMem(FFormat);
  FFormat := nil;
  FFormatSize := 0;
  FLockCount := 0;

  if FIDSBuffer <> nil then begin
    FCaps.dwSize := SizeOf(FCaps);
    IBuffer.GetCaps(FCaps);

    if IBuffer.GetFormat(PWaveFormatEx(nil), 0, @DWORD(FFormatSize)) = DS_OK then begin
      GetMem(FFormat, FFormatSize);
      IBuffer.GetFormat(FFormat, FFormatSize, nil);
    end;
  end;
end;

procedure TDirectSoundBuffer.SetPan(Value: Integer);
begin
  DXResult := IBuffer.SetPan(Value);
end;

procedure TDirectSoundBuffer.SetPosition(Value: Longint);
begin
  DXResult := IBuffer.SetCurrentPosition(Value);
end;
{$IFNDEF DX7}
const
  DSBCAPS_CTRLDEFAULT       = DSBCAPS_CTRLFREQUENCY or DSBCAPS_CTRLPAN or DSBCAPS_CTRLVOLUME;
{$ENDIF}

procedure TDirectSoundBuffer.SetSize(const Format: TWaveFormatEx; Size: Integer);
var
  BufferDesc                : TDSBufferDesc;
begin
  {  IDirectSoundBuffer made.  }
  //FillChar(BufferDesc, SizeOf(BufferDesc), 0);

  BufferDesc.dwReserved := 0;
  FillChar(BufferDesc.guid3DAlgorithm, SizeOf(BufferDesc.guid3DAlgorithm), 0);

  with BufferDesc do begin
    dwSize := SizeOf(TDSBufferDesc);
    dwFlags := DSBCAPS_CTRLDEFAULT;
    if DSound.FStickyFocus then
      dwFlags := dwFlags or DSBCAPS_STICKYFOCUS
    else if DSound.FGlobalFocus then
      dwFlags := dwFlags or DSBCAPS_GLOBALFOCUS;
    dwBufferBytes := Size;
    lpwfxFormat := @Format;
  end;

  if not CreateBuffer(BufferDesc) then
    raise EDirectSoundBufferError.CreateFmt(SCannotMade, [SDirectSoundBuffer]);
end;

procedure TDirectSoundBuffer.SetVolume(Value: Integer);
begin
  DXResult := IBuffer.SetVolume(Value);
end;

procedure TDirectSoundBuffer.Stop;
begin
  DXResult := IBuffer.Stop;
end;

procedure TDirectSoundBuffer.UnLock;
begin
  if IDSBuffer = nil then Exit;
  if FLockCount = 0 then Exit;

  Dec(FLockCount);
  DXResult := IBuffer.UnLock(FLockAudioPtr1[FLockCount], FLockAudioSize1[FLockCount],
    FLockAudioPtr2[FLockCount], FLockAudioSize2[FLockCount]);
end;

{  TAudioStream  }

type
  TAudioStreamNotify = class(TThread)
  private
    FAudio: TAudioStream;
    FSleepTime: Integer;
    FStopOnTerminate: Boolean;
    constructor Create(Audio: TAudioStream);
    destructor Destroy; override;
    procedure Execute; override;
    procedure Update;
    procedure ThreadTerminate(Sender: TObject);
  end;

constructor TAudioStreamNotify.Create(Audio: TAudioStream);
begin
  FAudio := Audio;

  OnTerminate := ThreadTerminate;

  FAudio.FNotifyEvent := CreateEvent(nil, False, False, nil);
  FAudio.FNotifyThread := Self;

  FSleepTime := Min(FAudio.FBufferLength div 4, 1000 div 20);
  FStopOnTerminate := True;

  FreeOnTerminate := True;
  inherited Create(False);
end;

destructor TAudioStreamNotify.Destroy;
begin
  FreeOnTerminate := False;

  SetEvent(FAudio.FNotifyEvent);
  inherited Destroy;
  CloseHandle(FAudio.FNotifyEvent);

  FAudio.FNotifyThread := nil;
end;

procedure TAudioStreamNotify.ThreadTerminate(Sender: TObject);
begin
  FAudio.FNotifyThread := nil;
  if FStopOnTerminate then FAudio.Stop;
end;

procedure TAudioStreamNotify.Execute;
begin
  while WaitForSingleObject(FAudio.FNotifyEvent, FSleepTime) = WAIT_TIMEOUT do
    Synchronize(Update);
end;

procedure TAudioStreamNotify.Update;
begin
  if not FAudio.Playing then begin
    SetEvent(FAudio.FNotifyEvent);
    Exit;
  end;

  try
    FAudio.Update2(True);
  except
    on E: Exception do begin
      Application.HandleException(E);
      SetEvent(FAudio.FNotifyEvent);
    end;
  end;
end;

constructor TAudioStream.Create(ADirectSound: TDirectSound);
begin
  inherited Create;
  FDSound := ADirectSound;
  FAutoUpdate := True;
  FBuffer := TDirectSoundBuffer.Create(FDSound);
  FBufferLength := 1000;
end;

destructor TAudioStream.Destroy;
begin
  Stop;
  WaveStream := nil;
  FBuffer.Free;
  inherited Destroy;
end;

function TAudioStream.GetFormat: PWaveFormatEx;
begin
  if WaveStream = nil then
    raise EAudioStreamError.Create(SWaveStreamNotSet);
  Result := WaveStream.Format;
end;

function TAudioStream.GetFormatSize: Integer;
begin
  if WaveStream = nil then
    raise EAudioStreamError.Create(SWaveStreamNotSet);
  Result := WaveStream.FormatSize;
end;

function TAudioStream.GetFrequency: Integer;
begin
  Result := FBuffer.Frequency;
end;

function TAudioStream.GetPan: Integer;
begin
  Result := FBuffer.Pan;
end;

function TAudioStream.GetPlayedSize: Integer;
begin
  if Playing then UpdatePlayedSize;
  Result := FPlayedSize;
end;

function TAudioStream.GetSize: Integer;
begin
  if WaveStream <> nil then
    Result := WaveStream.Size
  else
    Result := 0;
end;

function TAudioStream.GetVolume: Integer;
begin
  Result := FBuffer.Volume;
end;

procedure TAudioStream.UpdatePlayedSize;
var
  PlayPosition, PlayedSize  : DWORD;
begin
  PlayPosition := FBuffer.Position;

  if FPlayBufferPos <= PlayPosition then begin
    PlayedSize := PlayPosition - FPlayBufferPos
  end else begin
    PlayedSize := PlayPosition + (FBufferSize - FPlayBufferPos);
  end;

  Inc(FPlayedSize, PlayedSize);

  FPlayBufferPos := PlayPosition;
end;

function TAudioStream.GetWriteSize: Integer;
var
  PlayPosition              : DWORD;
  i                         : Integer;
begin
  PlayPosition := FBuffer.Position;

  if FBufferPos <= PlayPosition then begin
    Result := PlayPosition - FBufferPos
  end else begin
    Result := PlayPosition + (FBufferSize - FBufferPos);
  end;

  i := WaveStream.FilledSize;
  if i >= 0 then Result := Min(Result, i);
end;

procedure TAudioStream.Play;
begin
  if not FPlaying then begin
    if WaveStream = nil then
      raise EAudioStreamError.Create(SWaveStreamNotSet);

    if Size = 0 then Exit;

    FPlaying := True;
    try
      SetPosition(FPosition);
      if FAutoUpdate then
        FNotifyThread := TAudioStreamNotify.Create(Self);
    except
      Stop;
      raise;
    end;
  end;
end;

procedure TAudioStream.RecreateBuf;
var
  APlaying                  : Boolean;
  APosition                 : Integer;
  AFrequency                : Integer;
  APan                      : Integer;
  AVolume                   : Integer;
begin
  APlaying := Playing;

  APosition := Position;
  AFrequency := Frequency;
  APan := Pan;
  AVolume := Volume;

  SetWaveStream(WaveStream);

  Position := APosition;
  Frequency := AFrequency;
  Pan := APan;
  Volume := AVolume;

  if APlaying then Play;
end;

procedure TAudioStream.SetAutoUpdate(Value: Boolean);
begin
  if FAutoUpdate <> Value then begin
    FAutoUpdate := Value;
    if FPlaying then begin
      if FNotifyThread <> nil then begin
        (FNotifyThread as TAudioStreamNotify).FStopOnTerminate := False;
        FNotifyThread.Free;
      end;

      if FAutoUpdate then
        FNotifyThread := TAudioStreamNotify.Create(Self);
    end;
  end;
end;

procedure TAudioStream.SetBufferLength(Value: Integer);
begin
  if Value < 10 then Value := 10;
  if FBufferLength <> Value then begin
    FBufferLength := Value;
    if WaveStream <> nil then RecreateBuf;
  end;
end;

procedure TAudioStream.SetFrequency(Value: Integer);
begin
  FBuffer.Frequency := Value;
end;

procedure TAudioStream.SetLooped(Value: Boolean);
begin
  if FLooped <> Value then begin
    FLooped := Value;
    Position := Position;
  end;
end;

procedure TAudioStream.SetPan(Value: Integer);
begin
  FBuffer.Pan := Value;
end;

procedure TAudioStream.SetPlayedSize(Value: Integer);
begin
  if Playing then UpdatePlayedSize;
  FPlayedSize := Value;
end;

procedure TAudioStream.SetPosition(Value: Integer);
begin
  if WaveStream = nil then
    raise EAudioStreamError.Create(SWaveStreamNotSet);

  Value := Max(Min(Value, Size - 1), 0);
  Value := Value div Format^.nBlockAlign * Format^.nBlockAlign;

  FPosition := Value;

  if Playing then begin
    try
      FBuffer.Stop;

      FBufferPos := 0;
      FPlayBufferPos := 0;
      FWritePosition := Value;

      WriteWave(FBufferSize);

      FBuffer.Position := 0;
      FBuffer.Play(True);
    except
      Stop;
      raise;
    end;
  end;
end;

procedure TAudioStream.SetVolume(Value: Integer);
begin
  FBuffer.Volume := Value;
end;

procedure TAudioStream.SetWaveStream(Value: TCustomWaveStream);
var
  BufferDesc                : TDSBufferDesc;
begin
  Stop;

  FWaveStream := nil;
  FBufferPos := 0;
  FPosition := 0;
  FWritePosition := 0;

  if (Value <> nil) and (FBufferLength > 0) then begin
    FBufferSize := FBufferLength * Integer(Value.Format^.nAvgBytesPerSec) div 1000;

    FillChar(BufferDesc, SizeOf(BufferDesc), 0);
    with BufferDesc do begin
      dwSize := SizeOf(TDSBufferDesc);
      dwFlags := DSBCAPS_CTRLDEFAULT or DSBCAPS_GETCURRENTPOSITION2;
      if FDSound.FStickyFocus then
        dwFlags := dwFlags or DSBCAPS_STICKYFOCUS
      else if FDSound.FGlobalFocus then
        dwFlags := dwFlags or DSBCAPS_GLOBALFOCUS;
      dwBufferBytes := FBufferSize;
      lpwfxFormat := Value.Format;
    end;

    if not FBuffer.CreateBuffer(BufferDesc) then
      raise EDirectSoundBufferError.CreateFmt(SCannotMade, [SDirectSoundBuffer]);
  end else begin
    FBuffer.IDSBuffer := nil;
    FBufferSize := 0;
  end;

  FWaveStream := Value;
end;

procedure TAudioStream.Stop;
begin
  if FPlaying then begin
    FPlaying := False;
    FBuffer.Stop;
    FNotifyThread.Free;
  end;
end;

procedure TAudioStream.Update;
begin
  Update2(False);
end;

procedure TAudioStream.Update2(InThread: Boolean);
var
  WriteSize                 : Integer;
begin
  if not FPlaying then Exit;

  try
    UpdatePlayedSize;

    if Size < 0 then begin
      WriteSize := GetWriteSize;
      if WriteSize > 0 then begin
        WriteSize := WriteWave(WriteSize);
        FPosition := FPosition + WriteSize;
      end;
    end else begin
      if FLooped then begin
        WriteSize := GetWriteSize;
        if WriteSize > 0 then begin
          WriteWave(WriteSize);
          FPosition := (FPosition + WriteSize) mod Size;
        end;
      end else begin
        if FPosition < Size then begin
          WriteSize := GetWriteSize;
          if WriteSize > 0 then begin
            WriteWave(WriteSize);
            FPosition := FPosition + WriteSize;
            if FPosition > Size then FPosition := Size;
          end;
        end else begin
          if InThread then
            SetEvent(FNotifyEvent)
          else
            Stop;
        end;
      end;
    end;
  except
    if InThread then
      SetEvent(FNotifyEvent)
    else
      Stop;
    raise;
  end;
end;

function TAudioStream.WriteWave(WriteSize: Integer): Integer;

  procedure WriteData(Size: Integer);
  var
    Data1, Data2            : Pointer;
    Data1Size, Data2Size    : Longint;
  begin
    if FBuffer.Lock(FBufferPos, Size, Data1, Data1Size, Data2, Data2Size) then begin
      try
        FWaveStream.Position := FWritePosition;
        FWaveStream.ReadBuffer(Data1^, Data1Size);
        FWritePosition := FWritePosition + Data1Size;

        if Data2 <> nil then begin
          FWaveStream.ReadBuffer(Data2^, Data2Size);
          FWritePosition := FWritePosition + Data2Size;
        end;

        FBufferPos := (FBufferPos + DWORD(Data1Size) + DWORD(Data2Size)) mod FBufferSize;
      finally
        FBuffer.UnLock;
      end;
    end;
  end;

  procedure WriteData2(Size: Integer);
  var
    Data1, Data2            : Pointer;
    Data1Size, Data2Size, s1, s2: Longint;
  begin
    if FBuffer.Lock(FBufferPos, Size, Data1, Data1Size, Data2, Data2Size) then begin
      try
        FWaveStream.Position := FWritePosition;
        s1 := FWaveStream.Read(Data1^, Data1Size);
        FWritePosition := FWritePosition + s1;
        FBufferPos := (FBufferPos + DWORD(s1)) mod FBufferSize;
        Inc(Result, s1);

        if (Data2 <> nil) and (s1 = Data1Size) then begin
          s2 := FWaveStream.Read(Data2^, Data2Size);
          FWritePosition := FWritePosition + s2;
          FBufferPos := (FBufferPos + DWORD(s2)) mod FBufferSize;
          Inc(Result, s2);
        end;
      finally
        FBuffer.UnLock;
      end;
    end;
  end;

  procedure WriteSilence(Size: Integer);
  var
    C                       : Byte;
    Data1, Data2            : Pointer;
    Data1Size, Data2Size    : Longint;
  begin
    if Format^.wBitsPerSample = 8 then C := $80 else C := 0;

    if FBuffer.Lock(FBufferPos, Size, Data1, Data1Size, Data2, Data2Size) then begin
      try
        FillChar(Data1^, Data1Size, C);

        if Data2 <> nil then
          FillChar(Data2^, Data2Size, C);
      finally
        FBuffer.UnLock;
      end;
      FBufferPos := (FBufferPos + DWORD(Data1Size) + DWORD(Data2Size)) mod FBufferSize;
      FWritePosition := FWritePosition + Data1Size + Data2Size;
    end;
  end;

var
  DataSize                  : Integer;
begin
  if Size >= 0 then begin
    Result := WriteSize;
    if FLooped then begin
      while WriteSize > 0 do begin
        DataSize := Min(Size - FWritePosition, WriteSize);

        WriteData(DataSize);
        FWritePosition := FWritePosition mod Size;

        Dec(WriteSize, DataSize);
      end;
    end else begin
      DataSize := Size - FWritePosition;

      if DataSize <= 0 then begin
        WriteSilence(WriteSize);
      end else
        if DataSize >= WriteSize then begin
          WriteData(WriteSize);
        end else begin
          WriteData(DataSize);
          WriteSilence(WriteSize - DataSize);
        end;
    end;
  end else begin
    Result := 0;
    WriteData2(WriteSize);
  end;
end;

{  TAudioFileStream  }

destructor TAudioFileStream.Destroy;
begin
  inherited Destroy;
  FWaveFileStream.Free;
end;

procedure TAudioFileStream.SetFileName(const Value: string);
begin
  if FFileName = Value then Exit;

  FFileName := Value;

  if FWaveFileStream <> nil then begin
    WaveStream := nil;
    FWaveFileStream.Free;
    FWaveFileStream := nil;
  end;

  if Value <> '' then begin
    try
      FWaveFileStream := TWaveFileStream.Create(Value, fmOpenRead or fmShareDenyWrite);
      FWaveFileStream.Open(False);
      WaveStream := FWaveFileStream;
    except
      WaveStream := nil;
      FFileName := '';
      raise;
    end;
  end;
end;

{  TSoundCaptureFormats  }

constructor TSoundCaptureFormats.Create;
begin
  inherited Create(TSoundCaptureFormat);
end;

function TSoundCaptureFormats.GetItem(Index: Integer): TSoundCaptureFormat;
begin
  Result := TSoundCaptureFormat(inherited Items[Index]);
end;

function TSoundCaptureFormats.IndexOf(ASamplesPerSec, ABitsPerSample, AChannels: Integer): Integer;
var
  i                         : Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    with Items[i] do
      if (FSamplesPerSec = ASamplesPerSec) and (FBitsPerSample = ABitsPerSample) and (FChannels = AChannels) then begin
        Result := i;
        Break;
      end;
end;

{  TSoundCaptureStream  }

type
  TSoundCaptureStreamNotify = class(TThread)
  private
    FCapture: TSoundCaptureStream;
    FSleepTime: Integer;
    constructor Create(Capture: TSoundCaptureStream);
    destructor Destroy; override;
    procedure Execute; override;
    procedure Update;
  end;

constructor TSoundCaptureStreamNotify.Create(Capture: TSoundCaptureStream);
begin
  FCapture := Capture;

  FCapture.FNotifyEvent := CreateEvent(nil, False, False, nil);
  FSleepTime := Min(FCapture.FBufferLength div 4, 1000 div 20);

  FreeOnTerminate := True;
  inherited Create(True);
end;

destructor TSoundCaptureStreamNotify.Destroy;
begin
  FreeOnTerminate := False;
  SetEvent(FCapture.FNotifyEvent);

  inherited Destroy;

  CloseHandle(FCapture.FNotifyEvent);
  FCapture.FNotifyThread := nil;

  if Assigned(FCapture.FOnFilledBuffer) then FCapture.Stop;
end;

procedure TSoundCaptureStreamNotify.Execute;
begin
  while WaitForSingleObject(FCapture.FNotifyEvent, FSleepTime) = WAIT_TIMEOUT do begin
    Synchronize(Update);
  end;
end;

procedure TSoundCaptureStreamNotify.Update;
begin
  if FCapture.FilledSize > 0 then begin
    try
      FCapture.DoFilledBuffer;
    except
      on E: Exception do begin
        Application.HandleException(E);
        SetEvent(FCapture.FNotifyEvent);
      end;
    end;
  end;
end;

constructor TSoundCaptureStream.Create(GUID: PGUID);
const
  SamplesPerSecList         : array[0..6] of Integer = (8000, 11025, 22050, 33075, 44100, 48000, 96000);
  BitsPerSampleList         : array[0..3] of Integer = (8, 16, 24, 32);
  ChannelsList              : array[0..1] of Integer = (1, 2);
var
  ASamplesPerSec, ABitsPerSample, AChannels: Integer;
  dscbd                     : TDSCBufferDesc;
  TempBuffer                : IDirectSoundCaptureBuffer;
  Format                    : TWaveFormatEx;
begin
  inherited Create;
  FBufferLength := 1000;
  FSupportedFormats := TSoundCaptureFormats.Create;

  if DXDirectSoundCaptureCreate(GUID, FCapture, nil) <> DS_OK then
    raise ESoundCaptureStreamError.CreateFmt(SCannotInitialized, [SDirectSoundCapture]);

  {  The supported format list is acquired.  }
  for ASamplesPerSec := Low(SamplesPerSecList) to High(SamplesPerSecList) do
    for ABitsPerSample := Low(BitsPerSampleList) to High(BitsPerSampleList) do
      for AChannels := Low(ChannelsList) to High(ChannelsList) do begin
        {  Test  }
        MakePCMWaveFormatEx(Format, SamplesPerSecList[ASamplesPerSec], BitsPerSampleList[ABitsPerSample], ChannelsList[AChannels]);

        FillChar(dscbd, SizeOf(dscbd), 0);
        dscbd.dwSize := SizeOf(dscbd);
        dscbd.dwBufferBytes := Format.nAvgBytesPerSec;
        dscbd.lpwfxFormat := @Format;

        {  If the buffer can be made,  the format of present can be used.  }
        if FCapture.CreateCaptureBuffer(dscbd, TempBuffer, nil) = DS_OK then begin
          TempBuffer := nil;
          with TSoundCaptureFormat.Create(FSupportedFormats) do begin
            FSamplesPerSec := Format.nSamplesPerSec;
            FBitsPerSample := Format.wBitsPerSample;
            FChannels := Format.nChannels;
          end;
        end;
      end;
end;

destructor TSoundCaptureStream.Destroy;
begin
  Stop;
  FSupportedFormats.Free;
  inherited Destroy;
end;

procedure TSoundCaptureStream.DoFilledBuffer;
begin
  if Assigned(FOnFilledBuffer) then FOnFilledBuffer(Self);
end;

class function TSoundCaptureStream.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectSoundCaptureDrivers;
end;

function TSoundCaptureStream.GetFilledSize: Integer;
begin
  Result := GetReadSize;
end;

function TSoundCaptureStream.GetReadSize: Integer;
var
  CapturePosition, ReadPosition: DWORD;
begin
  if FBuffer.GetCurrentPosition(@DWORD(CapturePosition), @DWORD(ReadPosition)) = DS_OK then begin
    if FBufferPos <= ReadPosition then
      Result := ReadPosition - FBufferPos
    else
      Result := FBufferSize - FBufferPos + ReadPosition;
  end else
    Result := 0;
end;

function TSoundCaptureStream.ReadWave(var Buffer; Count: Integer): Integer;
var
  Size                      : Integer;
  Data1, Data2              : Pointer;
  Data1Size, Data2Size      : DWORD;
  C                         : Byte;
begin
  if not FCapturing then
    Start;

  Result := 0;
  while Result < Count do begin
    Size := Min(Count - Result, GetReadSize);
    if Size > 0 then begin
      if FBuffer.Lock(FBufferPos, Size, Data1, {$IFNDEF DX7}@{$ENDIF}Data1Size,
        Data2, {$IFNDEF DX7}@{$ENDIF}Data2Size, 0) = DS_OK then begin
        Move(Data1^, Pointer(Integer(@Buffer) + Result)^, Data1Size);
        Result := Result + Integer(Data1Size);

        if Data2 <> nil then begin
          Move(Data2^, Pointer(Integer(@Buffer) + Result)^, Data2Size);
          Result := Result + Integer(Data1Size);
        end;

        FBuffer.UnLock(Data1, Data1Size, Data2, Data2Size);
        FBufferPos := (FBufferPos + Data1Size + Data2Size) mod FBufferSize;
      end else
        Break;
    end;
    if Result < Count then Sleep(50);
  end;

  case Format^.wBitsPerSample of
    8: C := $80;
    16: C := $00;
  else
    C := $00;
  end;

  FillChar(Pointer(Integer(@Buffer) + Result)^, Count - Result, C);
  Result := Count;
end;

procedure TSoundCaptureStream.SetBufferLength(Value: Integer);
begin
  FBufferLength := Max(Value, 0);
end;

procedure TSoundCaptureStream.SetOnFilledBuffer(Value: TNotifyEvent);
begin
  if CompareMem(@TMethod(FOnFilledBuffer), @TMethod(Value), SizeOf(TMethod)) then Exit;

  if FCapturing then begin
    if Assigned(FOnFilledBuffer) then
      FNotifyThread.Free;

    FOnFilledBuffer := Value;

    if Assigned(FOnFilledBuffer) then begin
      FNotifyThread := TSoundCaptureStreamNotify.Create(Self);
      FNotifyThread.Resume;
    end;
  end else
    FOnFilledBuffer := Value;
end;

procedure TSoundCaptureStream.Start;
var
  dscbd                     : TDSCBufferDesc;
begin
  Stop;
  try
    FCapturing := True;

    FormatSize := SizeOf(TWaveFormatEx);
    with FSupportedFormats[CaptureFormat] do
      MakePCMWaveFormatEx(Format^, SamplesPerSec, BitsPerSample, Channels);

    FBufferSize := Max(MulDiv(Format^.nAvgBytesPerSec, FBufferLength, 1000), 8000);

    FillChar(dscbd, SizeOf(dscbd), 0);
    dscbd.dwSize := SizeOf(dscbd);
    dscbd.dwBufferBytes := FBufferSize;
    dscbd.lpwfxFormat := Format;

    if FCapture.CreateCaptureBuffer(dscbd, FBuffer, nil) <> DS_OK then
      raise ESoundCaptureStreamError.CreateFmt(SCannotMade, [SDirectSoundCaptureBuffer]);

    FBufferPos := 0;

    FBuffer.Start(DSCBSTART_LOOPING);

    if Assigned(FOnFilledBuffer) then begin
      FNotifyThread := TSoundCaptureStreamNotify.Create(Self);
      FNotifyThread.Resume;
    end;
  except
    Stop;
    raise;
  end;
end;

procedure TSoundCaptureStream.Stop;
begin
  if FCapturing then begin
    FNotifyThread.Free;
    FCapturing := False;
    if FBuffer <> nil then
      FBuffer.Stop;
    FBuffer := nil;
  end;
end;

{  TSoundEngine  }

constructor TSoundEngine.Create(ADSound: TDirectSound);
begin
  inherited Create;
  FDSound := ADSound;
  FEnabled := True;

  FSendRequestList := TStringlist.Create;
  FSendRequestList.CaseSensitive := False;
  FSendRequestList.Sorted := True;

  FEffectList := TList.Create;
  FEffectWaveList := TCnHashTableSmall.Create;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 500;
  FTimer.OnTimer := TimerEvent;
end;

destructor TSoundEngine.Destroy;
begin
  Clear;
  FTimer.Free;
  FEffectList.Free;
  FEffectWaveList.Free;
  FSendRequestList.Free;
  inherited Destroy;
end;

procedure TSoundEngine.Clear;
var
  i                         : Integer;
begin
  for i := EffectCount - 1 downto 0 do
    Effects[i].Free;
  FEffectList.Clear;

  for i := EffectWaveCount - 1 downto 0 do
    EffectWaves[i].Free;
  FEffectWaveList.Clear;
end;

{procedure TSoundEngine.EffectFile(const FileName: string; Loop, Wait: Boolean);
var
  Stream                    : TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    EffectStream(Stream, Loop, Wait);
  finally
    Stream.Free;
  end;
end;

procedure TSoundEngine.EffectStream(Stream: TStream; Loop, Wait: Boolean);
var
  Wave                      : TWave;
begin
  Wave := TWave.Create;
  try
    Wave.LoadFromStream(Stream);
    EffectWave(Wave, Loop, Wait);
  finally
    Wave.Free;
  end;
end;}

procedure TSoundEngine.EffectFile(const FileName: string; Loop, Wait, Exists: Boolean; Pan: Integer; lVolume: Integer); //(Wave: TWave; Loop, Wait: Boolean);
var
  Buffer                    : TDirectSoundBuffer;
  Stream                    : TFileStream;
  Wave                      : TWave;
begin
  if not FEnabled then
    Exit;
  if not Exists then begin
    if FSendRequestList.IndexOf(FileName) < 0 then begin
      FSendRequestList.Add(FileName);
      PatchUnit.g_PatchClientManager.SendProcMsg(Self, FileName, PM_WAV, 0);
    end;
    Exit;
  end;

  Wave := GetEffectWaveName(FileName);
  if Wave <> nil then begin
    Wave.FEffectTick := GetTickCount();
    if Wait then begin
      Buffer := TDirectSoundBuffer.Create(FDSound);
      try
        Buffer.LoadFromWave(Wave);
        Buffer.Play(False);
        while Buffer.Playing do
          Sleep(1);
      finally
        Buffer.Free;
      end;
    end else begin
      //if FEffectList.Count > 50 then exit;
      Buffer := TDirectSoundBuffer.Create(FDSound);
      try
        Buffer.LoadFromWave(Wave);

        Buffer.Pan := Pan;
        Buffer.Volume := lVolume;

        Buffer.Play(Loop);
      except
        Buffer.Free;
        Buffer := nil;
        raise;
      end;
      if Buffer <> nil then FEffectList.Add(Buffer);
    end;
    Exit;
  end;

  if Exists {FileExists(FileName)} then try
    //Stream := TFileStream.Create(FileName, fmOpenRead);
    //try
    Wave := TWave.Create;
    Wave.FEffectTick := GetTickCount();
    //try
      //Wave.LoadFromStream(Stream);
    Wave.LoadFromFile(FileName);
    FEffectWaveList.Put(FileName, TObject(Wave));

    //EffectWave
    if Wait then begin
      Buffer := TDirectSoundBuffer.Create(FDSound);
      try
        Buffer.LoadFromWave(Wave);
        Buffer.Play(False);
        while Buffer.Playing do
          Sleep(1);
      finally
        Buffer.Free;
      end;
    end else begin
      Buffer := TDirectSoundBuffer.Create(FDSound);
      try
        Buffer.LoadFromWave(Wave);

        Buffer.Pan := Pan;
        Buffer.Volume := lVolume;

        Buffer.Play(Loop);
      except
        Buffer.Free;
        Buffer := nil;
        raise;
      end;
      if Buffer <> nil then FEffectList.Add(Buffer);
    end;
    {finally
      //Wave.Free;
    end;}
    //finally
    //  Stream.Free;
    //end;
  except
  end;
end;

function TSoundEngine.GetEffect(Index: Integer): TDirectSoundBuffer;
begin
  Result := TDirectSoundBuffer(FEffectList[Index]);
end;

function TSoundEngine.GetEffectWave(Index: Integer): TWave;
begin
  Result := TWave(FEffectWaveList.Values[FEffectWaveList.Keys[Index]]);
end;

{function TSoundEngine.GetEffectName(Name: string): TDirectSoundBuffer;
begin
  Result := TDirectSoundBuffer(FEffectList.Values[Name]);
end;}

function TSoundEngine.GetEffectWaveName(Name: string): TWave;
begin
  Result := TWave(FEffectWaveList.Values[Name]);
end;

function TSoundEngine.GetEffectCount: Integer;
begin
  Result := FEffectList.Count;
end;

function TSoundEngine.GetEffectWaveCount: Integer;
begin
  Result := FEffectWaveList.Count;
end;

procedure TSoundEngine.SetEnabled(Value: Boolean);
var
  i                         : Integer;
begin
  for i := EffectCount - 1 downto 0 do
    Effects[i].Free;
  FEffectList.Clear;

  for i := EffectWaveCount - 1 downto 0 do
    EffectWaves[i].Free;
  FEffectWaveList.Clear;

  FEnabled := Value;
  FTimer.Enabled := Value;
end;

procedure TSoundEngine.TimerEvent(Sender: TObject);
var
  i                         : Integer;
  obj                       : TDirectSoundBuffer;
  wav                       : TWave;
begin
  for i := EffectCount - 1 downto 0 do begin
    obj := TDirectSoundBuffer(FEffectList[i]);
    if not obj.Playing then begin
      obj.Free;
      FEffectList.Delete(i);
    end;
  end;
  for i := EffectWaveCount - 1 downto 0 do begin
    wav := GetEffectWave(i);
    if (GetTickCount - wav.FEffectTick > 10 * 1000) then begin
      wav.Free;
      FEffectWaveList.Delete(FEffectWaveList.Keys[i]);
    end;
  end;
end;

{  TCustomDXSound  }

type
  TDXSoundDirectSound = class(TDirectSound)
  private
    FDXSound: TCustomDXSound;
  protected
    procedure DoRestoreBuffer; override;
  end;

procedure TDXSoundDirectSound.DoRestoreBuffer;
begin
  inherited DoRestoreBuffer;
  FDXSound.Restore;
end;

constructor TCustomDXSound.Create(AOwner: TComponent);
begin
  FNotifyEventList := TList.Create;
  inherited Create(AOwner);
  FAutoInitialize := True;
  Options := [];
end;

destructor TCustomDXSound.Destroy;
begin
  Finalize;
  NotifyEventList(dsntDestroying);
  FNotifyEventList.Free;
  inherited Destroy;
end;

type
  PDXSoundNotifyEvent = ^TDXSoundNotifyEvent;

procedure TCustomDXSound.RegisterNotifyEvent(NotifyEvent: TDXSoundNotifyEvent);
var
  Event                     : PDXSoundNotifyEvent;
begin
  UnRegisterNotifyEvent(NotifyEvent);

  New(Event);
  Event^ := NotifyEvent;
  FNotifyEventList.Add(Event);

  if Initialized then begin
    NotifyEvent(Self, dsntInitialize);
    NotifyEvent(Self, dsntRestore);
  end;
end;

procedure TCustomDXSound.UnRegisterNotifyEvent(NotifyEvent: TDXSoundNotifyEvent);
var
  Event                     : PDXSoundNotifyEvent;
  i                         : Integer;
begin
  for i := 0 to FNotifyEventList.Count - 1 do begin
    Event := FNotifyEventList[i];
    if (TMethod(Event^).Code = TMethod(NotifyEvent).Code) and
      (TMethod(Event^).Data = TMethod(NotifyEvent).Data) then begin
      Dispose(Event);
      FNotifyEventList.Delete(i);

      if Initialized then
        NotifyEvent(Self, dsntFinalize);

      Break;
    end;
  end;
end;

procedure TCustomDXSound.NotifyEventList(NotifyType: TDXSoundNotifyType);
var
  i                         : Integer;
begin
  for i := FNotifyEventList.Count - 1 downto 0 do
    PDXSoundNotifyEvent(FNotifyEventList[i])^(Self, NotifyType);
end;

procedure TCustomDXSound.FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);
begin
  case Message.msg of
    WM_CREATE: begin
        DefWindowProc(Message);
        SetForm(FForm);
        Exit;
      end;
  end;
  DefWindowProc(Message);
end;

class function TCustomDXSound.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectSoundDrivers;
end;

procedure TCustomDXSound.DoFinalize;
begin
  if Assigned(FOnFinalize) then FOnFinalize(Self);
end;

procedure TCustomDXSound.DoInitialize;
begin
  if Assigned(FOnInitialize) then FOnInitialize(Self);
end;

procedure TCustomDXSound.DoInitializing;
begin
  if Assigned(FOnInitializing) then FOnInitializing(Self);
end;

procedure TCustomDXSound.DoRestore;
begin
  if Assigned(FOnRestore) then FOnRestore(Self);
end;

procedure TCustomDXSound.Finalize;
begin
  if FInternalInitialized then begin
    try
      FSubClass.Free;
      FSubClass := nil;

      try
        if FCalledDoInitialize then begin
          FCalledDoInitialize := False;
          DoFinalize;
        end;
      finally
        NotifyEventList(dsntFinalize);
      end;
    finally
      FInitialized := False;
      FInternalInitialized := False;

      SetOptions(FOptions);

      FPrimary.Free;
      FPrimary := nil;
      FDSound.Free;
      FDSound := nil;
    end;
  end;
end;

procedure TCustomDXSound.Initialize;
const
  PrimaryDesc               : TDSBufferDesc = (
    dwSize: SizeOf(PrimaryDesc);
    dwFlags: DSBCAPS_PRIMARYBUFFER);
var
  Component                 : TComponent;
begin
  Finalize;

  Component := Owner;
  while (Component <> nil) and (not (Component is TCustomForm)) do
    Component := Component.Owner;
  if Component = nil then
    raise EDXSoundError.Create(SNoForm);

  NotifyEventList(dsntInitializing);
  DoInitializing;

  FInternalInitialized := True;
  try
    {  DirectSound initialization.  }
    FDSound := TDXSoundDirectSound.Create(Driver);
    TDXSoundDirectSound(FDSound).FDXSound := Self;

    FDSound.FGlobalFocus := soGlobalFocus in FNowOptions;

    {  Primary buffer made.  }
    FPrimary := TDirectSoundBuffer.Create(FDSound);
    if not FPrimary.CreateBuffer(PrimaryDesc) then
      raise EDXSoundError.CreateFmt(SCannotMade, [SDirectSoundPrimaryBuffer]);

    FInitialized := True;

    SetForm(TCustomForm(Component));
  except
    Finalize;
    raise;
  end;

  NotifyEventList(dsntInitialize);

  FCalledDoInitialize := True;
  DoInitialize;

  Restore;
end;

procedure TCustomDXSound.Loaded;
begin
  inherited Loaded;

  if FAutoInitialize and (not (csDesigning in ComponentState)) then begin
    try
      Initialize;
    except
      on E: EDirectSoundError do ;
    else raise;
    end;
  end;
end;

procedure TCustomDXSound.Restore;
begin
  if FInitialized then begin
    NotifyEventList(dsntRestore);
    DoRestore;
  end;
end;

procedure TCustomDXSound.SetDriver(Value: PGUID);
begin
  if not IsBadHugeReadPtr(Value, SizeOf(TGUID)) then begin
    FDriverGUID := Value^;
    FDriver := @FDriverGUID;
  end else
    FDriver := Value;
end;

procedure TCustomDXSound.SetForm(Value: TCustomForm);
var
  Level                     : Integer;
begin
  FForm := Value;

  FSubClass.Free;
  FSubClass := TControlSubClass.Create(FForm, FormWndProc);

  if FInitialized then begin
    if soExclusive in FNowOptions then
      Level := DSSCL_EXCLUSIVE
    else
      Level := DSSCL_NORMAL;

    FDSound.DXResult := FDSound.ISound.SetCooperativeLevel(FForm.Handle, Level);
  end;
end;

procedure TCustomDXSound.SetOptions(Value: TDXSoundOptions);
const
  DXSoundOptions            = [soGlobalFocus, soStickyFocus, soExclusive];
  InitOptions               : TDXSoundOptions = [soExclusive];
var
  OldOptions                : TDXSoundOptions;
begin
  FOptions := Value;

  if Initialized then begin
    OldOptions := FNowOptions;

    FNowOptions := (FNowOptions - (DXSoundOptions - InitOptions)) +
      (Value - InitOptions);

    FDSound.FGlobalFocus := soGlobalFocus in FNowOptions;
    FDSound.FStickyFocus := soStickyFocus in FNowOptions;
  end else
    FNowOptions := FOptions;
end;

{  TWaveCollectionItem  }

constructor TWaveCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FWave := TWave.Create;
  FBufferList := TList.Create;
end;

destructor TWaveCollectionItem.Destroy;
begin
  Finalize;
  FWave.Free;
  FBufferList.Free;
  inherited Destroy;
end;

procedure TWaveCollectionItem.Assign(Source: TPersistent);
var
  PrevInitialized           : Boolean;
begin
  if Source is TWaveCollectionItem then begin
    PrevInitialized := Initialized;
    Finalize;

    FLooped := TWaveCollectionItem(Source).FLooped;
    Name := TWaveCollectionItem(Source).Name;
    FMaxPlayingCount := TWaveCollectionItem(Source).FMaxPlayingCount;

    FFrequency := TWaveCollectionItem(Source).FFrequency;
    FPan := TWaveCollectionItem(Source).FPan;
    FVolume := TWaveCollectionItem(Source).FVolume;

    FWave.Assign(TWaveCollectionItem(Source).FWave);

    if PrevInitialized then
      Restore;
  end else
    inherited Assign(Source);
end;

function TWaveCollectionItem.GetPlaying: Boolean;
var
  Buffer                    : TDirectSoundBuffer;
  Index                     : Integer;
begin
  Result := False;
  if not FInitialized then Exit;
  assert(GetBuffer <> nil);
  assert(FBufferList <> nil);
  if FLooped then begin
    Buffer := GetBuffer;
    assert(Buffer <> nil);
    Result := Buffer.Playing;
  end
  else begin
    for Index := 0 to FBufferList.Count - 1 do begin
      Result := TDirectSoundBuffer(FBufferList[Index]).Playing;
      if Result then
        Break;
    end;
  end;
end;                                    {GetPlaying}

function TWaveCollectionItem.GetBuffer: TDirectSoundBuffer;
begin
  if FInitialized and (FBuffer = nil) then
    Restore;
  Result := FBuffer;
end;

function TWaveCollectionItem.GetWaveCollection: TWaveCollection;
begin
  Result := Collection as TWaveCollection;
end;

procedure TWaveCollectionItem.Finalize;
var
  i                         : Integer;
begin
  if not FInitialized then Exit;
  FInitialized := False;

  for i := 0 to FBufferList.Count - 1 do
    TDirectSoundBuffer(FBufferList[i]).Free;
  FBufferList.Clear;
  FBuffer.Free;
  FBuffer := nil;
end;

procedure TWaveCollectionItem.Initialize;
begin
  Finalize;
  FInitialized := WaveCollection.Initialized;
end;

function TWaveCollectionItem.CreateBuffer: TDirectSoundBuffer;
begin
  Result := nil;
  if GetBuffer = nil then Exit;

  Result := TDirectSoundBuffer.Create(WaveCollection.DXSound.DSound);
  try
    Result.Assign(GetBuffer);
  except
    Result.Free;
    raise;
  end;
end;

procedure TWaveCollectionItem.Play(Wait: Boolean);
var
  NewBuffer                 : TDirectSoundBuffer;
  i                         : Integer;
begin
  if not FInitialized then Exit;

  if FLooped then begin
    GetBuffer.Stop;
    GetBuffer.Position := 0;
    GetBuffer.Play(True);
  end else begin
    NewBuffer := nil;
    for i := 0 to FBufferList.Count - 1 do
      if not TDirectSoundBuffer(FBufferList[i]).Playing then begin
        NewBuffer := FBufferList[i];
        Break;
      end;

    if NewBuffer = nil then begin
      if FMaxPlayingCount = 0 then begin
        NewBuffer := CreateBuffer;
        if NewBuffer = nil then Exit;

        FBufferList.Add(NewBuffer);
      end else begin
        if FBufferList.Count < FMaxPlayingCount then begin
          NewBuffer := CreateBuffer;
          if NewBuffer = nil then Exit;

          FBufferList.Add(NewBuffer);
        end else begin
          NewBuffer := FBufferList[0];
          FBufferList.Move(0, FBufferList.Count - 1);
        end;
      end;
    end;

    NewBuffer.Stop;
    NewBuffer.Position := 0;
    NewBuffer.Frequency := FFrequency;
    NewBuffer.Pan := FPan;
    NewBuffer.Volume := FVolume;
    NewBuffer.Play(False);

    if Wait then begin
      while NewBuffer.Playing do
        Sleep(10);
    end;
  end;
end;

procedure TWaveCollectionItem.Restore;
begin
  if FWave.Size = 0 then Exit;

  if not FInitialized then begin
    if WaveCollection.Initialized then
      Initialize;
    if not FInitialized then Exit;
  end;

  if FBuffer = nil then
    FBuffer := TDirectSoundBuffer.Create(WaveCollection.DXSound.DSound);

  FBuffer.LoadFromWave(FWave);
  FBuffer.Frequency := FFrequency;
  FBuffer.Pan := FPan;
  FBuffer.Volume := FVolume;
end;

procedure TWaveCollectionItem.Stop;
var
  i                         : Integer;
begin
  if not FInitialized then Exit;

  FBuffer.Stop;
  for i := 0 to FBufferList.Count - 1 do
    TDirectSoundBuffer(FBufferList[i]).Stop;
end;

procedure TWaveCollectionItem.SetFrequency(Value: Integer);
begin
  FFrequency := Value;
  if FInitialized then
    GetBuffer.Frequency := Value;
end;

procedure TWaveCollectionItem.SetLooped(Value: Boolean);
begin
  if FLooped <> Value then begin
    Stop;
    FLooped := Value;
  end;
end;

procedure TWaveCollectionItem.SetMaxPlayingCount(Value: Integer);
var
  i                         : Integer;
begin
  if Value < 0 then Value := 0;

  if FMaxPlayingCount <> Value then begin
    FMaxPlayingCount := Value;

    if FInitialized then begin
      for i := 0 to FBufferList.Count - 1 do
        TDirectSoundBuffer(FBufferList[i]).Free;
      FBufferList.Clear;
    end;
  end;
end;

procedure TWaveCollectionItem.SetPan(Value: Integer);
begin
  FPan := Value;
  if FInitialized then
    GetBuffer.Pan := Value;
end;

procedure TWaveCollectionItem.SetVolume(Value: Integer);
begin
  FVolume := Value;
  if FInitialized then
    GetBuffer.Volume := Value;
end;

procedure TWaveCollectionItem.SetWave(Value: TWave);
begin
  FWave.Assign(Value);
end;

{  TWaveCollection  }

constructor TWaveCollection.Create(AOwner: TPersistent);
begin
  inherited Create(TWaveCollectionItem);
  FOwner := AOwner;
end;

function TWaveCollection.GetItem(Index: Integer): TWaveCollectionItem;
begin
  Result := TWaveCollectionItem(inherited Items[Index]);
end;

function TWaveCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TWaveCollection.Find(const Name: string): TWaveCollectionItem;
var
  i                         : Integer;
begin
  i := IndexOf(Name);
  if i = -1 then
    raise EWaveCollectionError.CreateFmt(SWaveNotFound, [Name]);
  Result := Items[i];
end;

procedure TWaveCollection.Finalize;
var
  i                         : Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Finalize;
  FDXSound := nil;
end;

procedure TWaveCollection.Initialize(DXSound: TCustomDXSound);
var
  i                         : Integer;
begin
  Finalize;
  FDXSound := DXSound;
  for i := 0 to Count - 1 do
    Items[i].Initialize;
end;

function TWaveCollection.Initialized: Boolean;
begin
  Result := (FDXSound <> nil) and (FDXSound.Initialized);
end;

procedure TWaveCollection.Restore;
var
  i                         : Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Restore;
end;

type
  TWaveCollectionComponent = class(TComponent)
  private
    FList: TWaveCollection;
  published
    property List: TWaveCollection read FList write FList;
  end;

procedure TWaveCollection.LoadFromFile(const FileName: string);
var
  Stream                    : TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TWaveCollection.LoadFromStream(Stream: TStream);
var
  Component                 : TWaveCollectionComponent;
begin
  Clear;
  Component := TWaveCollectionComponent.Create(nil);
  try
    Component.FList := Self;
    Stream.ReadComponentRes(Component);

    if Initialized then begin
      Initialize(FDXSound);
      Restore;
    end;
  finally
    Component.Free;
  end;
end;

procedure TWaveCollection.SaveToFile(const FileName: string);
var
  Stream                    : TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TWaveCollection.SaveToStream(Stream: TStream);
var
  Component                 : TWaveCollectionComponent;
begin
  Component := TWaveCollectionComponent.Create(nil);
  try
    Component.FList := Self;
    Stream.WriteComponentRes('DelphiXWaveCollection', Component);
  finally
    Component.Free;
  end;
end;

{  TCustomDXWaveList  }

constructor TCustomDXWaveList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TWaveCollection.Create(Self);
end;

destructor TCustomDXWaveList.Destroy;
begin
  DXSound := nil;
  FItems.Free;
  inherited Destroy;
end;

procedure TCustomDXWaveList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (DXSound = AComponent) then
    DXSound := nil;
end;

procedure TCustomDXWaveList.DXSoundNotifyEvent(Sender: TCustomDXSound;
  NotifyType: TDXSoundNotifyType);
begin
  case NotifyType of
    dsntDestroying: DXSound := nil;
    dsntInitialize: FItems.Initialize(Sender);
    dsntFinalize: FItems.Finalize;
    dsntRestore: FItems.Restore;
  end;
end;

procedure TCustomDXWaveList.SetDXSound(Value: TCustomDXSound);
begin
  if FDXSound <> nil then
    FDXSound.UnRegisterNotifyEvent(DXSoundNotifyEvent);

  FDXSound := Value;

  if FDXSound <> nil then
    FDXSound.RegisterNotifyEvent(DXSoundNotifyEvent);
end;

procedure TCustomDXWaveList.SetItems(Value: TWaveCollection);
begin
  FItems.Assign(Value);
end;

{(c) 2006 Jaro Benes, Play midi from memory module}

{ TMusicDataProp }

type
  TMidiDataHeader = packed record
    Size: Integer;
  end;

procedure TMusicDataProp.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Midi', ReadMidiData, WriteMidiData, Length(Self.FMusicData) <> 0);
end;

function TMusicDataProp.GetMusicData: string;
begin
  SetLength(Result, Length(FMusicData));
  if Length(FMusicData) <> 0 then
    Move(FMusicData[1], Result[1], Length(FMusicData));
end;

procedure TMusicDataProp.ReadMidiData(Stream: TStream);
var
  Header                    : TMidiDataHeader;
begin
  Stream.ReadBuffer(Header, SizeOf(Header));
  SetLength(FMusicData, Header.Size);
  Stream.ReadBuffer(FMusicData[1], Header.Size);
end;

procedure TMusicDataProp.SetMusicData(const Value: string);
begin
  SetLength(FMusicData, Length(Value));
  if Length(Value) <> 0 then
    Move(Value[1], FMusicData[1], Length(Value));
end;

procedure TMusicDataProp.WriteMidiData(Stream: TStream);
var
  Header                    : TMidiDataHeader;
begin
  Header.Size := Length(FMusicData);
  Stream.WriteBuffer(Header, SizeOf(Header));
  Stream.WriteBuffer(FMusicData[1], Header.Size);
end;

{ TMusicListCollectionItem }

procedure TMusicListCollectionItem.Load;
var
  MidiFilelength            : Integer;
begin
  // kdyby nahodou uz nejaky existoval tak ho znic
  if FDirectMusicSegment <> nil then
    FDirectMusicSegment := nil;
  ZeroMemory(@FMusicObjDesc, SizeOf(TDMus_ObjectDesc));
  // tohle je popisek parametru - chceme hrat z pameti
  with FMusicObjDesc do begin
    dwSize := SizeOf(TDMus_ObjectDesc);
    guidclass := CLSID_DirectMusicSegment;
    //tohle jen pokud je to ze souboru
    //dwvaliddata := DMUS_OBJ_CLASS or DMUS_OBJ_FULLPATH or DMUS_OBJ_FILENAME;
    dwvaliddata := DMUS_OBJ_CLASS or DMUS_OBJ_MEMORY or DMUS_OBJ_LOADED;
    pbMemData := @FMusicDataProp.FMusicData[1];
    llMemLength := Length(FMusicDataProp.FMusicData);
  end;
  if FDirectMusicLoader.GetObject(FMusicObjDesc, IID_IDirectMusicSegment, FDirectMusicSegment) <> dm_OK then
    raise EDXMusicError.Create('Failed to Get object for Direct music');
  ;
  if FDirectMusicSegment.setParam(GUID_StandardMidiFile, $FFFFFFFF, 0, 0, Pointer(FDirectMusicPerformance)) <> dm_OK then
    raise EDXMusicError.Create('Failed to Set param for Direct music');
  ;
  if FDirectMusicSegment.setParam(GUID_Download, $FFFFFFFF, 0, 0, Pointer(FDirectMusicPerformance)) <> dm_OK then
    raise EDXMusicError.Create('Failed to Set param for Direct music');
  ;
  FDirectMusicSegment.GetLength(MidiFilelength);
  if (FActualDuration < MidiFilelength) and (FActualDuration > 0) then
    FDirectMusicSegment.SetLength(FActualDuration);
  if FActualStartPoint < MidiFilelength - FActualDuration then
    FDirectMusicSegment.SetStartPoint(FActualStartPoint);
  // jak opakovat
  FDirectMusicSegment.SetRepeats(Repeats - 1);
end;

constructor TMusicListCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  CoInitialize(nil);
  FMusicDataProp := TMusicDataProp.Create;
  SetLength(FMusicDataProp.FMusicData, 0);
  FDirectMusicPerformance := nil;
  FDirectMusic := nil;
  FDirectSound := nil;
  FDirectMusicSegment := nil;
  FDirectMusicLoader := nil;
  FIsInitialized := False;
end;

procedure TMusicListCollectionItem.Stop;
begin
  if FDirectMusicPerformance <> nil then
    FDirectMusicPerformance.Stop(nil, nil, 0, 0);
end;

function TMusicListCollectionItem.GetDisplayName: string;
begin
  Result := inherited GetDisplayName
end;

procedure TMusicListCollectionItem.Play;
begin
  if not FIsInitialized then
    Init;
  Load;
  if FDirectMusicPerformance <> nil then
    FDirectMusicPerformance.PlaySegment(FDirectMusicSegment, 0, 0, @FDirectMusicSegmentState);
end;

function TMusicListCollectionItem.IsPlaying: Boolean;
begin
  Result := False;
  if FDirectMusicPerformance <> nil then
    Result := FDirectMusicPerformance.IsPlaying(FDirectMusicSegment, FDirectMusicSegmentState) = dm_OK;
end;

destructor TMusicListCollectionItem.Destroy;
begin
  FDirectMusicPerformance := nil;
  FDirectMusic := nil;
  FDirectSound := nil;
  FDirectMusicSegment := nil;
  FDirectMusicLoader := nil;
  FMusicDataProp.Free;
  CoUninitialize;
  inherited Destroy;
end;

procedure TMusicListCollectionItem.SetRepeats(const Value: Cardinal);
begin
  FRepeats := Value;
end;

procedure TMusicListCollectionItem.SetStartPoint(const Value: Integer);
begin
  FStartpoint := Value;
end;

procedure TMusicListCollectionItem.SetDuration(const Value: Integer);
begin
  FDuration := Value;
end;

procedure TMusicListCollectionItem.Init;
var
  OK                        : Boolean;
begin
  FIsInitialized := False;
  OK := False;
  // vytvor FDirectMusicPerformance pokud uz neni vytvoreno
  if FDirectMusicPerformance = nil then
    OK := CoCreateInstance(CLSID_DirectMusicPerformance, nil, CLSCTX_INPROC,
      IID_IDirectMusicperformance, FDirectMusicPerformance) = dm_OK;
  if not OK then Exit;
  if FDirectSound <> nil then
    OK := FDirectMusicPerformance.Init({$IFDEF DX7}@{$ENDIF}FDirectMusic, FDirectSound, 0) = dm_OK
  else
    OK := FDirectMusicPerformance.Init({$IFDEF DX7}@{$ENDIF}FDirectMusic, nil, 0) = dm_OK;
  if not OK then Exit;
  // vychozi midi port
  // pridej pokud neni nastaven
  if FDirectMusicPerformance.Addport(nil) <> dm_OK then Exit;
  // zkus vytvorit loader
  OK := CoCreateInstance(CLSID_DirectMusicLoader, nil, CLSCTX_INPROC,
    IID_IDirectMusicLoader, FDirectMusicLoader) = dm_OK;
  FIsInitialized := OK;
end;

function TMusicListCollectionItem.GetMusicListCollection: TMusicListCollection;
begin
  Result := Collection as TMusicListCollection;
end;

procedure TMusicListCollectionItem.SaveToFile(const MidiFileName: string);
var
  F                         : file;
begin
  AssignFile(F, MidiFileName);
  Rewrite(F, 1);
  try
    BlockWrite(F, FMusicDataProp.FMusicData[1], Length(FMusicDataProp.FMusicData));
  finally
    CloseFile(F);
  end;
end;

procedure TMusicListCollectionItem.LoadFromFile(const MidiFileName: string);
var
  F                         : file;
  S                         : string;
  i                         : Integer;
begin
  AssignFile(F, MidiFileName);
  Reset(F, 1);
  try
    SetLength(FMusicDataProp.FMusicData, FileSize(F));
    BlockRead(F, FMusicDataProp.FMusicData[1], FileSize(F));
    S := ExtractFileName(MidiFileName);
    i := Pos(ExtractFileExt(S), S);
    if i > 0 then S := Copy(S, 1, i - 1);
    FMusicDataProp.MidiName := S;
  finally
    CloseFile(F);
  end;
  Name := ExtractFileName(MidiFileName);
end;

function TMusicListCollectionItem.Size: Integer;
begin
  Result := Length(FMusicDataProp.FMusicData);
end;

{ TMusicListCollection }

constructor TMusicListCollection.Create(AOwner: TComponent);
begin
  inherited Create(TMusicListCollectionItem);
  FOwner := AOwner;
end;

function TMusicListCollection.Add: TMusicListCollectionItem;
begin
  Result := TMusicListCollectionItem(inherited Add);
  Result.FDirectSound := Self.FDirectSound;
end;

function TMusicListCollection.GetItem(Index: Integer): TMusicListCollectionItem;
begin
  Result := TMusicListCollectionItem(inherited GetItem(Index));
end;

procedure TMusicListCollection.SetItem(Index: Integer;
  Value: TMusicListCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TMusicListCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;

function TMusicListCollection.Find(
  const Name: string): TMusicListCollectionItem;
var
  i                         : Integer;
begin
  i := IndexOf(Name);
  if i = -1 then
    raise EDXMusicError.CreateFmt('The midi document does not exist: %s.', [Name]);
  Result := Items[i];
end;
{$IFDEF DelphiX_Spt4}

function TMusicListCollection.Insert(Index: Integer): TMusicListCollectionItem;
begin
  Result := TMusicListCollectionItem(inherited Insert(Index));
end;
{$ENDIF}

function TMusicListCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TMusicListCollection.Restore;
begin

end;

procedure TMusicListCollection.SaveToFile(const FileName: string);
var
  Stream                    : TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TMusicListCollection.LoadFromFile(const FileName: string);
var
  Stream                    : TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

type
  TMidiCollectionComponent = class(TComponent)
  private
    FList: TMusicListCollection;
  published
    property List: TMusicListCollection read FList write FList;
  end;

procedure TMusicListCollection.SaveToStream(Stream: TStream);
var
  Component                 : TMidiCollectionComponent;
begin
  Component := TMidiCollectionComponent.Create(nil);
  try
    Component.FList := Self;
    Stream.WriteComponentRes('DelphiXMidiCollection', Component);
  finally
    Component.Free;
  end;
end;

procedure TMusicListCollection.LoadFromStream(Stream: TStream);
var
  Component                 : TMidiCollectionComponent;
begin
  Clear;
  Component := TMidiCollectionComponent.Create(nil);
  try
    Component.FList := Self;
    Stream.ReadComponentRes(Component);
    Restore;
  finally
    Component.Free;
  end;
end;

{ TDXMusic }

constructor TDXMusic.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMidis := TMusicListCollection.Create(Self);
  if Assigned(FDXSound) then
    FMidis.FDirectSound := FDXSound.DSound.IDSound;
end;

procedure TDXMusic.SetMidis(const Value: TMusicListCollection);
begin
  FMidis.Assign(Value);
end;

destructor TDXMusic.Destroy;
begin
  FMidis.Free;
  inherited Destroy;
end;

procedure TDXMusic.SetDXSound(const Value: TDXSound);
begin
  FDXSound := Value;
  if Assigned(FDXSound) then
    FMidis.FDirectSound := FDXSound.DSound.IDSound;
end;

initialization
finalization
  DirectSoundDrivers.Free;
  DirectSoundCaptureDrivers.Free;
end.

