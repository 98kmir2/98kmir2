(*
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////
//                                                                       //
//  Copyright ?1996-1999,  NetMasters,  L.L.C - All rights reserved     //
//  worldwide. Portions may be Copyright ?Borland International,  Inc.  //
//                                                                       //
// PSock:  ( PSOCK.PAS )                                                 //
//                                                                       //
// DESCRIPTION:                                                          //
//                                                                       //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY //
// KIND,  EITHER EXPRESSED OR IMPLIED,  INCLUDING BUT NOT LIMITED TO THE //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR //
// PURPOSE.                                                              //
//                                                                       //
///////////////////////////////////////////////////////////////////////////

(************************************************************************)
(*                                                                      *)
(*  Unit: PSock;    (DELPHI 5 VERSION)                                  *)
(*  Enhanced Windows Power Socket                                       *)
(*  Initial Version 1.0 Oct-26 George Lambert                           *)
(*  Revision History: Initial Version 1.0                               *)
(*  + Nov-1-96 Version 1.0 -- Initial Version                           *)
(*  + Version 1 of Psock corresponds to version 3 of components         *)
(*  + Therefore version 2&3 skipped                                     *)
(*  + Oct-10-97 Version 4.0 -- Initial Version                          *)
(* Known Problems: None                                                 *)
(* Modification Ideas: None                                             *)
(*                                                                      *)
(************************************************************************)
// Revision History
// 01 26 00 - KNA -  Capture Stream looks for dataAvailable and dataAvailable
//                   looks for disconnects to overcome null file downloads
// 01 03 00 - KNA -  WSAStartup and WSACleanup protected for machines without Winsock
// 12 27 99 - KNA -  RequestCloseSocket on Recv = 0
// 12 21 99 - KNA -  TimerThread WM_ENDSESSIONQUERY handled
// 12 10 99 - MDC -  Added capibility to modify the FIFO Buffer capacity from descendents.
// 10 25 99 - MDC -  Fixed bug with .connect not clearing FifoQ
//                   In .create don't create FifoQ if in design mode
//                   Ken should clearinput reset fifoq?
// 07 26 99 - KNA -  WM_ENDSESSION destroys component
// 05 17 99 - KNA -  Timeout in accept
// 11 11 98 - KNA -  2 Layer Removed
// 10 26 89 - KNA -  Errors under <10000 ignored by Errorhandler
// 10 05 98 - KNA -  Nthword check for empty input
// 09 17 98 - KNA -  BytesRecvd correctly set initailly in CaptureString and CaptureStream
// 08 25 98 - RAR -  Corrected some problems in the code which caused
//                   WM_QUERYENDSESSION messages to be incorrectly handled
//                   in some cases.
// 06 18 98 - KNA -  Port Definitions removed
// 06 08 98 - KNA -  Dont fire Status and Disconnect on Destroy
// 06 08 98 - KNA -  L+ and D+ removed
// 05 02 98 - KNA -  Error strings added
// 04 30 98 - KNA -  {$T-} before setsockopt to compile despite options
// 03 31 98 - KNA -  OnRead moved to Public
// 03 24 98 - KNA -  SendFile can handle zero length files
// 03 23 98 - KNA -  InitWinsock and CleanSockets suppressed at design time
// 03 05 98 - KNA -  Any data in socket copied to stream on a close
// 02 21 98 - KNA -  Copy any data from MemoryStream to FileStream on CaptureFile
// 02 16 98 - KNA -  RequestcloseSocket in On_Close to reset socket
// 02 11 98 - KNA -  Move Pos of OnRead out of critical section
// 02 05 98 - KNA -  About Dialog , & t in getlocalIP create and destroy in
//                   try finally loop for robustness
// 02 01 30 - KNA -  Cancelling enabled in Accept routine
// 01 30 98 - KNA -  cancel added in accept - to enable cancelling
// 01 27 98 - KNA -  Final release Ver 4.00 VCLS
// 01 18 98 - KNA -  Added Sleep to reduce cpu utilization

unit Psock;

{$IFDEF VER100}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER110}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER120}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER125}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER130}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER150}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER160}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER170}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER180}
{$DEFINE NMF3}
{$ENDIF}

{$X+}
{$H+}
{$R-}
{$DEFINE _WINSOCKAPI_}

interface

uses
  Winsock, Classes, SysUtils, Extctrls, Forms, Messages, StdCtrls,
  WinProcs, NMConst, NMFIFOBuffer, SyncObjs;

{$IFDEF VER110}
{$OBJEXPORTALL On}
{$ENDIF}
{$IFDEF VER120}
{$OBJEXPORTALL On}
{$ENDIF}
{$IFDEF VER125}
{$OBJEXPORTALL On}
{$ENDIF}

type
  TSocket = Word;

const

  FD_ALL            = 63;

  {Size of receive and send buffer}
  MAX_RECV_BUF      = 65536;

  { Levels for reporting Status Messages}
  Status_None       = 0;
  Status_Informational = 1;
  Status_Basic      = 2;
  Status_Routines   = 4;
  Status_Debug      = 8;
  Status_Trace      = 16;

  {Carriage Return and Line Feed constants}
  CR                = #13;
  LF                = #10;
  CRLF              = #13#10;

  WM_ASYNCHRONOUSPROCESS = WM_USER + 101; {Message number for asynchronous socket messages}
  WM_WAITFORRESPONSE = WM_USER + 102;   {Message number for synchronous responses}

type
  TErrorMessage = record
    ErrorCode: Integer;
    Text: string[ 50 ];
  end;

const
  WinsockMessage    : array[ 0..50 ] of TErrorMessage =
    (
    ( ErrorCode: 10004; Text: 'Interrupted system call' ),
    ( ErrorCode: 10009; Text: 'Bad file number' ),
    ( ErrorCode: 10013; Text: 'Permission denied' ),
    ( ErrorCode: 10014; Text: 'Bad address' ),
    ( ErrorCode: 10022; Text: 'Invalid argument' ),
    ( ErrorCode: 10024; Text: 'Too many open files' ),
    ( ErrorCode: 10035; Text: 'Operation would block' ),
    ( ErrorCode: 10036; Text: 'Operation now in progress' ),
    ( ErrorCode: 10037; Text: 'Operation already in progress' ),
    ( ErrorCode: 10038; Text: 'Socket operation on non-socket' ),
    ( ErrorCode: 10039; Text: 'Destination address required' ),
    ( ErrorCode: 10040; Text: 'Message too long' ),
    ( ErrorCode: 10041; Text: 'Wrong protocol type for socket' ),
    ( ErrorCode: 10042; Text: 'Bad protocol option' ),
    ( ErrorCode: 10043; Text: 'Protocol not supported' ),
    ( ErrorCode: 10044; Text: 'Socket type not supported' ),
    ( ErrorCode: 10045; Text: 'Operation not supported on socket' ),
    ( ErrorCode: 10046; Text: 'Protocol family not supported' ),
    ( ErrorCode: 10047; Text: 'Address family not supported by protocol family' ),
    ( ErrorCode: 10048; Text: 'Address already in use' ),
    ( ErrorCode: 10049; Text: 'Can''t assign requested address' ),
    ( ErrorCode: 10050; Text: 'Network is down' ),
    ( ErrorCode: 10051; Text: 'Network is unreachable' ),
    ( ErrorCode: 10052; Text: 'Network dropped connection or reset' ),
    ( ErrorCode: 10053; Text: 'Software caused connection abort' ),
    ( ErrorCode: 10054; Text: 'Connection reset by peer' ),
    ( ErrorCode: 10055; Text: 'No buffer space available' ),
    ( ErrorCode: 10056; Text: 'Socket is already connected' ),
    ( ErrorCode: 10057; Text: 'Socket is not connected' ),
    ( ErrorCode: 10058; Text: 'Can''t send after socket shutdown' ),
    ( ErrorCode: 10059; Text: 'Too many references, can''t splice' ),
    ( ErrorCode: 10060; Text: 'Connection timed out' ),
    ( ErrorCode: 10061; Text: 'Connection refused' ),
    ( ErrorCode: 10062; Text: 'Too many levels of symbolic links' ),
    ( ErrorCode: 10063; Text: 'File name too long' ),
    ( ErrorCode: 10064; Text: 'Host is down' ),
    ( ErrorCode: 10065; Text: 'No route to Host' ),
    ( ErrorCode: 10066; Text: 'Directory not empty' ),
    ( ErrorCode: 10067; Text: 'Too many processes' ),
    ( ErrorCode: 10068; Text: 'Too many users' ),
    ( ErrorCode: 10069; Text: 'Disc quota exceeded' ),
    ( ErrorCode: 10070; Text: 'Stale NFS file handle' ),
    ( ErrorCode: 10071; Text: 'Too many levels of remote in path' ),
    ( ErrorCode: 10091; Text: 'Network subsystem is unavailable' ),
    ( ErrorCode: 10092; Text: 'Incompatible version of WINSOCK.DLL' ),
    ( ErrorCode: 10093; Text: 'Successful WSAStartup not yet performed' ),
    ( ErrorCode: 11001; Text: 'Host not found' ),
    ( ErrorCode: 11002; Text: 'Non-Authoritative Host not found' ),
    ( ErrorCode: 11003; Text: 'Non-Recoverable error: FORMERR, REFUSED, NOTIMP' ),
    ( ErrorCode: 11004; Text: 'Valid name, no data record of requested type' ),
    ( ErrorCode: 0; Text: 'Unrecognized error code' )
     );

type
  TNMReg = class
  end;

  (*
    TNMShow = class(TForm)
      OKBtn: TButton;
      Image1: TImage;
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      Label4: TLabel;
      Label5: TLabel;
      Label6: TLabel;
      Label7: TLabel;
      Label8: TLabel;
      Label9: TLabel;
      Label10: TLabel;
      procedure Label8Click(Sender: TObject);
      procedure Button3Click(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure Button5Click(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure Button4Click(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;
  *)

    {Event Handlers}
  TOnErrorEvent = procedure( Sender: TComponent; Errno: Word; Errmsg: string ) of object;
  TOnHostResolved = procedure( Sender: TComponent ) of object;
  TOnStatus = procedure( Sender: TComponent; Status: string ) of object;
  THandlerEvent = procedure( var Handled: Boolean ) of object;

  { new basic pointer types }
  PLongint = ^Longint;
  PPLongInt = ^PLongint;
  PPChar = ^PChar;
  PINT = ^PInteger;

  THostInfo = record
    name: PChar;
    AliasList: PPChar;
    AddressType: Integer;
    AddressSize: Integer;
    AddressList: PPLongInt;
    Reserved: array[ 1..MAXGETHOSTSTRUCT ] of Char;
  end;

  TServerInfo = record
    name: PChar;
    Aliases: PPChar;
    PORT: Integer;
    Protocol: PChar;
    Reserved: array[ 1..MAXGETHOSTSTRUCT ] of Char;
  end;

  TProtocolInfo = record
    name: PChar;
    Aliases: PPChar;
    ProtocolID: Integer;
    Reserved: array[ 1..MAXGETHOSTSTRUCT ] of Char;
  end;

  TSocketAddress = record
    Family: Integer;
    PORT: Word;
    Address: Longint;
    Unused: array[ 1..8 ] of Char;
  end;

  TSocketList = record
    Count: Integer;
    DescriptorList: array[ 1..64 ] of Integer;
  end;

  TTimeValue = record
    Sec: Longint;
    uSec: Longint;
  end;

  {new WINSOCK pointer types}
  PWSAData = ^TWSAData;
  PHostInfo = ^THostInfo;
  PServerInfo = ^TServerInfo;
  PProtocolInfo = ^TProtocolInfo;
  PSocketAddress = ^TSocketAddress;
  PSocketList = ^TSocketList;
  PTimeValue = ^TTimeValue;

  ESockError = class( Exception );
  EAbortError = class( ESockError );

  TThreadTimer = class( TComponent )
  private
    FInterval: Cardinal;
    FWindowHandle: HWND;
    FOnTimer: TNotifyEvent;
    FEnabled: Boolean;
    procedure UpdateTimer;
    procedure SetEnabled( Value: Boolean );
    procedure SetInterval( Value: Cardinal );
    procedure SetOnTimer( Value: TNotifyEvent );
    procedure Wndproc( var Msg: TMessage );
  protected
    procedure Timer; dynamic;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
  end;

  {$IFNDEF NMF3}

  { TStringStream }
  TStringStream = class( TStream )
  private
    FDataString: string;
    FPosition: Integer;
  protected

  public
    procedure SetSize( NewSize: Longint );
    constructor Create( const AString: string );
    function Read( var Buffer; Count: Longint ): Longint; override;
    function ReadString( Count: Longint ): string;
    function Seek( Offset: Longint; Origin: Word ): Longint; override;
    function Write( const Buffer; Count: Longint ): Longint; override;
    procedure WriteString( const AString: string );
    property DataString: string read FDataString;
  end;

  TThreadList = class
  private
    FList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add( Item: Pointer );
    procedure Clear;
    function LockList: TList;
    procedure Remove( Item: Pointer );
    procedure UnlockList;
  end;
  {$ENDIF}

  {*******************************************************************************************
  Power Socket class definition
  ********************************************************************************************}
  TPowersock = class( TComponent )
  private
    Buf: array[ 0..MAX_RECV_BUF ] of Char;

    WaitSignal: TEvent;
    FAbout: TNMReg;

    {Event Handlers for Asynchronous socket events}
    FOnReadEvent: TNotifyEvent;
    FOnAcceptEvent: TNotifyEvent;
    FOnConnect: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FOnErrorEvent: TOnErrorEvent;       {Event handler for error notification}

    FInvalidHost: THandlerEvent;
    FOnHostResolved: TOnHostResolved;   {Event handler after a host name is found}
    FOnConnectionRequired: THandlerEvent;
    FOnStatus: TOnStatus;               {Event handler on a status change}
    FOnConnectionFailed: TNotifyEvent;
    FWSAInfo: TStringList;
    {Component Internals}
    FBytesSent: Longint;                {Number of bytes currently sent}

    Canceled: Boolean;                  {Flag to indicate request cancelled}
    DestroySocket: Boolean;             {flag to indicate socket to be destroyed or not}
    FLastErrorno: Integer;              {The last error Encountered}
    FTimeOut: Integer;                  {Time to wait before timout}
    FReportLevel: Integer;              {Reporting Level}
    _Status: string;                    {Current status}
    FProxy: string;                     {Name or IP of proxy server}
    FProxyPort: Integer;                {Port of proxy server}

    {TimeOut Functions}
    Timer: TThreadTimer;                {Timer for synchronous requests}

    {For Documentation of functions and procedures see implementation}
    procedure TimerFired( Sender: TObject );
    procedure Wndproc( var message: TMessage ); {}

  protected
    FifoQ: TNMFifoBuffer;
    Succeed: Boolean;                   {Flag for indicating if synchronous request succeded}
    TimedOut: Boolean;                  {Flag to indicate process timed out}
    FPort: Integer;                     {Port at server to connect to}
    FBytesTotal: Longint;               {Total number of bytes to send or receive}
    FBytesRecvd: Longint;               {Number of bytes currently received}
    FPacketRecvd: TNotifyEvent;         {Handler after each packet received for progress reports etc}
    FPacketSent: TNotifyEvent;          {Handler after each packet received for progress reports etc}
    Wait_Flag: Boolean;                 {Flag to indicate if synchronous request completed or not}
    RemoteAddress: TSockAddr;           {Address of remote host}
    ServerName: string;                 {Name of remote host}
    RemoteHost: PHostEnt;               {Entity to store remote host linfo from a Hostname request}
    FTransactionReply: string;          {Reply to a command request}
    FReplyNumber: Smallint;             {Reply number to a command request}
    DataGate: Boolean;
    AbortGate: Boolean;
    StrmType: Boolean;

    OnAbortrestart: TNotifyEvent;

    procedure TimerOn;
    procedure TimerOff;
    procedure InitWinsock;
    procedure ReadToBuffer;
    procedure SetLastErrorNo( Value: Integer );
    function SocketErrorStr( Errno: Word ): string;
    function GetLastErrorNo: Integer;
    function ErrorManager( Ignore: Word ): string;
    procedure SetWSAError( ErrorNo: Word; ErrorMsg: string );
    procedure StatusMessage( Level: Byte; Value: string );
    function GetRemoteIP: string;
    function GetLocalIP: string;

    procedure SetFifoCapacity( NewCapacity: LongInt );
    function GetFifoCapacity: LongInt;

    {Properties - Make Public the ones that the User needs to respond to in derived class}
    {Event Handlers for Asynchronous Events}
    property OnAccept: TNotifyEvent read FOnAcceptEvent write FOnAcceptEvent;
    {Event Handler for Errors}
    property OnError: TOnErrorEvent read FOnErrorEvent write FOnErrorEvent;
    {Event Handler for Status changes}
    property OnConnectionRequired: THandlerEvent read FOnConnectionRequired write FOnConnectionRequired;
    property Proxy: string read FProxy write FProxy; {name or IP of proxy server}
    property ProxyPort: Integer read FProxyPort write FProxyPort; {Port of proxy server}

  public
    ThisSocket: TSocket;                {The socket number of the Powersocket}
    FSocketWindow: HWND;                {Dummy window handle to receive Socket messages}
    FConnected: Boolean;                {Flag indicating socket connected or not}

    {For Documentation of functions and procedures see implementation}
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    {Runtime Properties}

    {Methods}
    function Accept: TSocket; virtual;
    procedure Cancel;
    procedure Connect; virtual;
    procedure Disconnect; virtual;
    procedure Wait;
    procedure Listen( sync: Boolean );
    procedure SendBuffer( Value: PChar; BufLen: Word );
    procedure Write( Value: string );
    procedure Writeln( Value: string );
    function Read( Value: Word ): string;
    function ReadLn: string;
    function Transaction( const CommandString: string ): string; virtual;
    procedure SendFile( Filename: string );
    procedure SendStream( MainStream: TStream );
    procedure SendRestStream( MainStream: TStream );
    procedure CaptureFile( Filename: string );
    procedure AppendFile( Filename: string );
    procedure CaptureStream( MainStream: TStream; Size: Longint );
    procedure CaptureString( var AString: string; Size: Longint );
    procedure FilterHeader( HeaderStream: TFileStream );
    procedure ResolveRemoteHost;
    procedure RequestCloseSocket;
    procedure Close( Socket: THandle );
    procedure Abort; virtual;
    procedure CertifyConnect;
    function DataAvailable: Boolean;
    procedure ClearInput;
    procedure CloseAfterData;
    procedure CloseImmediate;
    function GetLocalAddress: string;
    function GetPortString: string;
    property WSAInfo: TStringList read FWSAInfo; {Winsock info}
    property Connected: Boolean read FConnected;
    property LastErrorNo: Integer read GetLastErrorNo write SetLastErrorNo; {Last Socket error}
    property BeenCanceled: Boolean read Canceled write Canceled; {Status of Cancel request}
    property BeenTimedOut: Boolean read TimedOut;
    property ReplyNumber: Smallint read FReplyNumber; {Numerical result from transaction}
    property RemoteIP: string read GetRemoteIP;
    property LocalIP: string read GetLocalIP;
    property TransactionReply: string read FTransactionReply; {Result from commnd request}
    property BytesTotal: Longint read FBytesTotal; {Total bytes to send or receive}
    property BytesSent: Longint read FBytesSent; {Bytes currently sent}
    property BytesRecvd: Longint read FBytesRecvd; {Bytes currently received}
    property Handle: TSocket read ThisSocket; {Power Socket handle}
    property Status: string read _Status; {Current status}
    property OnRead: TNotifyEvent read FOnReadEvent write FOnReadEvent;
    property OnPacketRecvd: TNotifyEvent read FPacketRecvd write FPacketRecvd; {Handler for status messages during send or receive}
    property OnPacketSent: TNotifyEvent read FPacketSent write FPacketSent; {Handler for status messages during send or receive}

    property FifoCapacity: LongInt read GetFifoCapacity write SetFifoCapacity;
  published
    {Properties}
    property Host: string read ServerName write ServerName; {Host Nmae or IP of remote host}
    property Port: Integer read FPort write FPort; {Port of remote host}
    property TimeOut: Integer read FTimeOut write FTimeOut default 0; {Time before being timed out}
    property ReportLevel: Integer read FReportLevel write FReportLevel default Status_Informational;
    {Events}
    property OnDisconnect: TNotifyEvent read FOnDisconnect write FOnDisconnect;
    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
    property OnInvalidHost: THandlerEvent read FInvalidHost write FInvalidHost;
    property OnHostResolved: TOnHostResolved read FOnHostResolved write FOnHostResolved;
    property OnStatus: TOnStatus read FOnStatus write FOnStatus;
    property OnConnectionFailed: TNotifyEvent read FOnConnectionFailed write FOnConnectionFailed;
    property About: TNMReg read FAbout write FAbout;
  end;

  {*******************************************************************************************
  PowerSocket Server Class definition
  ********************************************************************************************}
  PTNMGeneralServer = ^TNMGeneralServer;

  TNMGeneralServer = class( TPowersock )
  private
    ATlist: TThreadList;
    FOnClientContact: TNotifyEvent;
    procedure DisPatchResponse( data: pointer );
  protected
    Chief: TNMGeneralServer;
  public
    ItsThread: TThread;
    constructor Create( AOwner: TComponent ); override;
    procedure Connect; override;
    procedure Loaded; override;
    procedure Serve; virtual;
    procedure Abort; override;
    destructor Destroy; override;
    procedure ServerAccept( Sender: TObject );
  published
    property OnClientContact: TNotifyEvent read FOnClientContact write FOnClientContact;
  end;

  {*******************************************************************************************
  Thread to Serve Client in Server Class definition
  ********************************************************************************************}
  TThreadMethod = procedure( Data: pointer ) of object;
  TSimpleThread = class( TThread )
  public
    constructor CreateSimple( CreateSuspended: boolean;
      _Action: TThreadMethod;
      _Data: pointer );
    procedure AbortThread;
  protected
    ThreadMethod: TThreadMethod;
    Data: pointer;

  private
    procedure Execute; override;
  end;

function ExecuteInThread( Handler: TThreadMethod; Data: pointer ): TSimpleThread;

procedure Register;

{For Documentation of functions and procedures see implementation}
function NthWord( InputString: string; Delimiter: Char; Number: Integer ): string;
function NthPos( InputString: string; Delimiter: Char; Number: Integer ): Integer;
procedure StreamLn( AStream: TStream; AString: string );
function PsockAllocateHWnd( Obj: TObject ): HWND;
function TmrAllocateHWnd( Obj: TObject ): HWND;

implementation
uses
  Shellapi;

var
  SockAvailable: boolean;
  MyWSAData: TWSAData;                {Socket Information}

procedure Register;
begin
  //RegisterComponents(Cons_Palette_Inet, [TPowersock, TNMGeneralServer]);
end;

{
procedure TNMShow.Label8Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'http://www.netmastersllc.com',
    nil, nil, SW_SHOW);
end;

procedure TNMShow.Button3Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'http://www.vcls.com/fastnet/versioncheck',
    nil, nil, SW_SHOW);
end;

procedure TNMShow.Button2Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'http://www.vcls.com/fastnet/mailinglist',
    nil, nil, SW_SHOW);
end;

procedure TNMShow.Button5Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'http://www.vcls.com/fastnet/sourcecode',
    nil, nil, SW_SHOW);
end;

procedure TNMShow.Button1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'http://www.vcls.com/fastnet/knownbugs',
    nil, nil, SW_SHOW);
end;

procedure TNMShow.Button4Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'http://www.vcls.com/fastnet/bugreport',
    nil, nil, SW_SHOW);
end;          }

constructor TSimpleThread.CreateSimple( CreateSuspended: boolean;
  _Action: TThreadMethod;
  _Data: pointer );
begin
  ThreadMethod := _Action;              // Set these BEFORE calling
  Data := _Data;                        // inherited Create()!
  FreeOnTerminate := True;
  inherited Create( CreateSuspended );
end;

procedure TSimpleThread.Execute;
begin
  ThreadMethod( Data );
end;

procedure TSimpleThread.AbortThread;
begin
  Suspend;
  Free;                                 // Kills thread
end;

function ExecuteInThread( Handler: TThreadMethod;
  Data: pointer ): TSimpleThread;
begin
  Result := TSimpleThread.CreateSimple( False, Handler, Data );
end;

procedure WaitforSync( Handle: THandle );
begin
  repeat
    if MsgWaitForMultipleObjects( 1, Handle, False, INFINITE, QS_ALLINPUT ) = WAIT_OBJECT_0 + 1 then
      Application.ProcessMessages
    else
      BREAK;
  until True = False;
end;

{*******************************************************************************************
Create Power Socket
********************************************************************************************}

constructor TPowersock.Create( AOwner: TComponent );
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_create ); {Inform Status}
  inherited Create( AOwner );

  {$IFDEF DEMOVER}
  if not ( csDesigning in ComponentState ) then
    ShowMessage( 'This uses the Demo Version of the Netmasters Componnents. Please Register' );
  {$ENDIF}

  FSocketWindow := PsockAllocateHWnd( self ); {Create Window handle to receive message notification}
  WaitSignal := TEvent.Create( nil, True, False, '' );

  if not ( csDesigning in ComponentState ) then
    FifoQ := TNMFifoBuffer.Create;

  FProxy := '';                         {Default - No Proxy}

  {Initialize memory }
  GetMem( RemoteHost, MAXGETHOSTSTRUCT ); {Initialize memory for host address structure}

  Timer := TThreadTimer.Create( self ); {Create timer}
  Timer.Enabled := False;               {Timer Disabled}
  Timer.OnTimer := TimerFired;          {Set Function to execcute on TimeOut}
  FTimeout := 0;

  FWSAInfo := TStringList.Create;

  if SockAvailable then
    begin
      FWSAinfo.add(sPSk_Cons_winfo_ver + IntToStr(HiByte(MyWSADATA.wVersion)) + '.' + IntToStr(LoByte(MyWSADATA.wVersion)));
      FWSAinfo.add(sPSk_Cons_winfo_Hiver + IntToStr(HiByte(MyWSADATA.wHighVersion)) + '.' + IntToStr(LoByte(MyWSADATA.wHighVersion)));
      FWSAinfo.add(sPSk_Cons_winfo_Descr + MyWSADATA.szDescription);
      FWSAinfo.add(sPSk_Cons_winfo_Sys + MyWSADATA.szSystemStatus);
      FWSAinfo.add(sPSk_Cons_winfo_MaxSoc + IntToStr(MyWSADATA.iMaxSockets));
      FWSAinfo.add(sPSk_Cons_winfo_MaxUdp + IntToStr(MyWSADATA.iMaxUdpDg));
    end;

  Canceled := False;                    {Cancelled flag off}
  DestroySocket := False;               {Socket is active}
  FConnected := False;                  {Socket is not connected}

  {Call Initialization functions }
  InitWinsock;
  {Turn on Messaging.... }
end;

{*******************************************************************************************
Destroy Power Socket
********************************************************************************************}

destructor TPowersock.Destroy;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_Dest ); {Inform Status}
  try
    Abort;
    Cancel;
    FWSAInfo.Free;
    Timer.Free;
    FreeMem( RemoteHost, MAXGETHOSTSTRUCT ); {Free memory for fetching Host Entity}
    DestroyWindow( FSocketWindow );     {Release window handle for Winsock messages}
    WaitSignal.Destroy;
    FifoQ.Free;
    DestroySocket := True;              {set flag to destoy socket}
    if not ( csDesigning in ComponentState ) then
        RequestCloseSocket;             {close socket}
  finally
    inherited Destroy;
  end
end;

{*******************************************************************************************
Connect Power Socket to Remote
********************************************************************************************}

procedure TPowersock.Connect;
var
  CT, I             : Integer;
  Handled           : Boolean;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_Conning ); {Inform Status}
  Canceled := False;                    {Turn Canceled off}
  FifoQ.Clear;
  if FConnected then                    {If already connected raise exception}
    raise ESockError.Create( sPSk_Cons_msg_Conn );
  CT := 0;
  repeat
    try
      ResolveRemoteHost;                {Resolve the IP address of remote host}
    except
      on E: ESockError do
        if ( E.message = sPSk_Cons_msg_host_to ) or ( E.message = sPSk_Cons_msg_host_Can ) then
          raise;
    end;

    if RemoteAddress.sin_addr.S_addr = 0 then
      if CT > 0 then
        raise ESockError.Create( sPSk_Cons_msg_add_null ) {If Resolving failed raise exception}
      else if not assigned( OnInvalidHost ) then
        raise ESockError.Create( sPSk_Cons_msg_add_null )
      else
        begin
          Handled := False;
          OnInvalidHost( Handled );
          if not Handled then
            raise ESockError.Create( sPSk_Cons_msg_add_null );
          CT := CT + 1;
        end;
  until RemoteAddress.sin_addr.S_addr <> 0;
  RemoteAddress.sin_family := AF_INET;  {Make connected true}

  {$R-}
  if Proxy = '' then
    RemoteAddress.sin_port := htons( Port ) {If no proxy get port from Port property}
  else
    RemoteAddress.sin_port := htons( FProxyPort ); {else get port from ProxyPort property}
  {$R+}

  Wait_Flag := False;                   { Wait for synchronous response}
  I := SizeOf( RemoteAddress );         { get size of remoteaddress structure}

  {Connect to remote host}
  Succeed := True;
  I := Winsock.Connect( ThisSocket, RemoteAddress, I );
  if ( I = INVALID_SOCKET ) then
    ErrorManager( WSAEWOULDBLOCK );     {If error handle error}

  TimerOn;                              {Enable Timer on for TimeOuts}
  try
    while not ( FConnected or TimedOut or Canceled or ( not Succeed ) ) do
      Wait;
  finally
    TimerOff;                           {Disable Timer}
  end;

  CloseAfterData;
  if ( TimedOut or Canceled or not Succeed ) then
    begin
      if assigned( FOnConnectionFailed ) then
        FOnConnectionFailed( self );

      if TimedOut then
        begin
          try
            Disconnect;
          except
          end;
          raise ESockError.Create( Cons_Msg_ConnectionTimedOut );
        end;
      if Canceled then
        raise ESockError.Create( sPSk_Cons_msg_Conn_can );
      if Succeed = False then
        raise ESockError.Create( sPSk_Cons_msg_Conn_fai );
    end;
end;

{*******************************************************************************************
DisConnect Socket From Remote
********************************************************************************************}

procedure TPowersock.Disconnect;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_Disconn ); {Status Message}
  if FConnected then
    RequestCloseSocket; {Close socket and open new one}
end;

procedure TPowerSock.Wait;
begin
  WaitforSync( WaitSignal.Handle );
  WaitSignal.ResetEvent;
end;

procedure TPowersock.CertifyConnect;
var
  TryCt             : Integer;
  Handled           : Boolean;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_CertConn ); {Status Message}
  TryCt := 0;
  while not Connected do
    begin
      if TryCt > 0 then
        raise Exception.Create( sPSk_Cons_err_NotConn )
      else if not assigned( FOnConnectionRequired ) then
        raise Exception.Create( sPSk_Cons_err_NotConn )
      else
        begin
          Handled := False;
          FOnConnectionRequired( Handled );
          if not Handled then
            raise Exception.Create( sPSk_Cons_err_NotConn );
          TryCt := TryCt + 1;
        end;
    end;
end;

{*******************************************************************************************
Canel current transaction
********************************************************************************************}

procedure TPowersock.Cancel;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_Cancel ); {Status Message}
  Canceled := True;
  WaitSignal.SetEvent;
end;

{*******************************************************************************************
Send at value of length buflen
********************************************************************************************}

procedure TPowersock.SendBuffer( Value: PChar; BufLen: Word );
var
  rc2, LeftB        : integer;
begin
  StatusMessage( Status_Routines, sPSk_Cons_msg_SBuff ); {Status Message}
  TimerOn;
  try
    if not Canceled then
      begin
        {If explicit buffer length given use it else get it from string length}
        if BufLen = 0 then
          BufLen := StrLen( Value );
        LeftB := BufLen;
        repeat
          rc2 := Winsock.send( ThisSocket, Value[ BufLen - LeftB ], LeftB, 0 );
          if rc2 = 0 then
            break;

          if rc2 > -1 then
            begin
              LeftB := LeftB - rc2;
            end
          else
            ErrorManager( WSAEWOULDBLOCK );
        until ( LeftB = 0 ) or Canceled or TimedOut;
      end;

    if Canceled then
      begin
        Canceled := false;
        raise EAbortError.create( sPSk_Cons_msg_send_a );
        if assigned( OnAbortrestart ) then
          OnAbortrestart( self );
      end;
  finally
    TimerOff;
  end;
end;

{*******************************************************************************************
Write String To Socket
********************************************************************************************}

procedure TPowersock.Write( Value: string );
var
  MyStringStream    : TStringStream;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_write ); {Report Status}
  if length( value ) > MAX_RECV_BUF then
    begin
      MyStringStream := TStringStream.create( Value );
      try
        SendStream( MyStringStream );
      finally
        MyStringStream.free;
      end;
    end
  else
    begin
      StrPLCopy( Buf, Value, MAX_RECV_BUF ); {Copy string to buffer}
      SendBuffer( Buf, 0 );             {Send the buffer}
    end;
end;

{*******************************************************************************************
Write Line ending with Carriage Return and Line Feed To Socket
********************************************************************************************}

procedure TPowersock.Writeln( Value: string );
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_writeln ); {Inform Status}
  Value := Value + CRLF;
  write( Value );
end;

{*******************************************************************************************
Read Given Number of bytes from Socket
********************************************************************************************}

function TPowersock.Read( Value: Word ): string;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_read + IntToStr( Value ) + ' )' ); {Inform status}
  if Value = 0 then
    Value := FifoQ.BufferSize;
  TimerOn;
  while ( FifoQ.BufferSize < Value ) and ( not Canceled ) and ( not Timedout ) do
    Wait;
  TimerOff;
  if Value = 0 then
    Result := ''
  else
    begin
      SetLength( Result, Value );
      FifoQ.Remove( Pointer( @Result[ 1 ] ), Value );
    end;
  if Canceled then
    begin
      Canceled := false;
      raise EAbortError.create( sPSk_Cons_msg_send_a );
      if assigned( OnAbortrestart ) then
        OnAbortrestart( self );
    end;
end;

{*******************************************************************************************
Read Line from Socket
********************************************************************************************}

function TPowersock.ReadLn: string;
var
  i                 : integer;
  LF                : string;
begin
  LF := #10;

  StatusMessage( Status_Debug, sPSk_Cons_msg_readln ); {Inform status}
  Result := '';
  i := 0;
  TimerOn;
  try
    while not ( TimedOut or Canceled ) do
      begin
        if DataAvailable then
          begin
            i := FifoQ.Search( Pointer( LF ) );
            if i > 0 then
              break;
          end;
        Wait;
      end;

    if i > 0 then
      begin
        SetLength( Result, i );
        FifoQ.Remove( PChar( @Result[ 1 ] ), i );
      end;

    if Canceled then
      begin
        Canceled := false;
        raise EAbortError.Create( sPSk_Cons_msg_readln_a );
        if assigned( OnAbortrestart ) then
          OnAbortrestart( self );
      end;
  finally
    TimerOff
  end;
end;

{*******************************************************************************************
Send command To Socket and get Reply
********************************************************************************************}

function TPowersock.Transaction;
var
  I                 : Integer;
  temp              : string;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_transa ); {Inform status}
  FReplyNumber := 0;                    {Initialise Numerical reply}
  Writeln( CommandString );             {Write Command string to Socket}
  FTransactionReply := ReadLn;          {Get Reply}
  if Length( FTransactionReply ) > 0 then
    begin
      StatusMessage( Status_Informational, FTransactionReply ); {Report status}
      temp := '';
      for I := 1 to 10 do
        if ( FTransactionReply[ I ] >= '0' ) and ( FTransactionReply[ I ] <= '9' ) then
          temp := temp + FTransactionReply[ I ]
        else
          break;
      if temp <> '' then
        FReplyNumber := StrToIntDef( temp, 0 ); {Extract Numerical Result if any}
    end;
  Result := FTransactionReply;          {Return Reply}
end;

{*******************************************************************************************
Send File To Socket
********************************************************************************************}

procedure TPowersock.SendFile( Filename: string );
var
  strm              : TFileStream;
  rc, LeftB, rc2    : integer;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_sendf ); {Status Message}
  strm := TFileStream.Create( Filename, fmOpenRead );
  try
    repeat
      if not Canceled then
        begin
          rc := strm.read( Buf, MAX_RECV_BUF );
          {If explicit buffer length given use it else get it from string length}
          LeftB := rc;
          repeat
            rc2 := Winsock.send( ThisSocket, Buf[ rc - LeftB ], LeftB, 0 );
            if rc2 = 0 then
              break;
            if rc2 > -1 then
              begin
                LeftB := LeftB - rc2;
                FBytesSent := FBytesSent + rc2;
                if assigned( FPacketSent ) then
                  FPacketSent( self );
                TimerOn;
              end
            else
              ErrorManager( WSAEWOULDBLOCK );
            Application.ProcessMessages;
          until ( LeftB = 0 ) or Canceled;
        end;
    until ( strm.position = strm.size ) or canceled;
  finally
    strm.free;
  end;
  if Canceled then
    begin
      Canceled := False;
      raise EAbortError.Create( sPSk_Cons_msg_send_a );
      if assigned( OnAbortrestart ) then
        OnAbortrestart( self );
    end;
end;

{*******************************************************************************************
Send File To Socket
********************************************************************************************}

procedure TPowersock.SendRestStream( MainStream: TStream );
var
  rc, LeftB, rc2, r3: longint;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_sendstrm ); {Status Message}
  if not Canceled then
    begin
      {If explicit buffer length given use it else get it from string length}
      FBytesSent := 0;
      FBytesTotal := MainStream.Size;

      repeat
        r3 := MainStream.Size - MainStream.Position;
        if r3 > MAX_RECV_BUF then
          r3 := MAX_RECV_BUF;
        rc := MainStream.read( Buf, r3 );
        LeftB := rc;
        repeat
          rc2 := Winsock.send( ThisSocket, Buf[ rc - LeftB ], LeftB, 0 );
          if rc2 = 0 then
            exit;
          if rc2 > 0 then
            begin
              LeftB := LeftB - rc2;
              FBytesSent := FBytesSent + rc2;
              TimerOn;
              if assigned( FPacketSent ) then
                FPacketSent( self );
            end
          else
            ErrorManager( WSAEWOULDBLOCK );
          Application.ProcessMessages;
        until ( LeftB = 0 ) or Canceled;
      until ( MainStream.Size = MainStream.Position ) or Canceled;
    end;

  if Canceled then
    begin
      Canceled := False;
      raise EAbortError.Create( sPSk_Cons_msg_send_a );
      if assigned( OnAbortrestart ) then
        OnAbortrestart( self );
    end;
end;

{*******************************************************************************************
Send File To Socket
********************************************************************************************}

procedure TPowersock.SendStream( MainStream: TStream );
var
  rc, LeftB, rc2, r3: longint;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_sendstrm ); {Status Message}
  MainStream.Position := 0;

  if not Canceled then
    begin
      {If explicit buffer length given use it else get it from string length}
      FBytesSent := 0;
      FBytesTotal := MainStream.Size;
      repeat
        r3 := MainStream.Size - MainStream.Position;
        if r3 > MAX_RECV_BUF then
          r3 := MAX_RECV_BUF;
        rc := MainStream.read( Buf, r3 );
        LeftB := rc;
        repeat
          rc2 := Winsock.send( ThisSocket, Buf[ rc - LeftB ], LeftB, 0 );
          if rc2 = 0 then
            exit;
          if rc2 > 0 then
            begin
              LeftB := LeftB - rc2;
              FBytesSent := FBytesSent + rc2;
              if assigned( FPacketSent ) then
                FPacketSent( self );
            end
          else
            ErrorManager( WSAEWOULDBLOCK );
          Application.ProcessMessages;
        until ( LeftB = 0 ) or Canceled;
      until ( MainStream.Size = MainStream.Position ) or Canceled;
    end;

  if Canceled then
    begin
      Canceled := False;
      raise EAbortError.Create( sPSk_Cons_msg_send_a );
      if assigned( OnAbortrestart ) then
        OnAbortrestart( self );
    end;
end;

{*******************************************************************************************
Append File from Socket
********************************************************************************************}

procedure TPowersock.AppendFile( Filename: string );
var
  strm              : TFileStream;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_cap_fil_app ); {Send status}
  strm := TFileStream.Create( Filename, fmOpenWrite ); {Create file stream to read from}
  try
    strm.Position := Strm.Size;
    CaptureStream( strm, -2 );
  finally
    strm.Free;
  end;
end;

{*******************************************************************************************
Capture File from Socket
********************************************************************************************}

procedure TPowersock.CaptureFile( Filename: string );
var
  strm              : TFileStream;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_cap_fil ); {Send status}
  strm := TFileStream.Create( Filename, fmCreate ); {Create file stream to read from}
  try
    CaptureStream( strm, -2 );
  finally
    strm.Free;
  end;
end;

{*******************************************************************************************
Capture File from Socket
********************************************************************************************}

procedure TPowersock.CaptureStream( MainStream: TStream; Size: Longint );
var
  j                 : Longint;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_cap_strm ); {Send status}
  FBytesRecvd := 0;
  TimerOn;
  try
    while ( not Canceled ) do
      begin
        while ( (not (DataAvailable)) and ( not Canceled ) and ( Connected ) and ( Size <> -1 ) ) do
          Wait;
        j := FifoQ.BufferSize;

        if j > MAX_RECV_BUF then
          j := MAX_RECV_BUF;
        FifoQ.Remove( @Buf, j );
        MainStream.WriteBuffer( Buf, j ); {Write it to stream}
        FBytesRecvd := FBytesRecvd + j;
        if assigned( FPacketRecvd ) then
          FPacketRecvd( self );
        TimerOn;
        if ( ( not Connected ) or ( MainStream.size = Size ) ) or ( Size = -1 ) then
          break;
      end;
    if Canceled then
      begin
        Canceled := False;
        raise EAbortError.Create( sPSk_Cons_msg_cap_a );
        if assigned( OnAbortrestart ) then
          OnAbortrestart( self );
      end;
  finally
    TimerOff;
  end;
end;

{*******************************************************************************************
Capture File from Socket
********************************************************************************************}

procedure TPowersock.CaptureString( var AString: string; Size: Longint );
var
  i, j              : Longint;

begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_string ); {Send status}
  StatusMessage( Status_Debug, sPSk_Cons_msg_cap_fil );
  FBytesRecvd := 0;
  SetLength( AString, 0 );
  TimerOn;
  try
    while ( not Canceled ) do
      begin
        while ( ( FifoQ.BufferSize = 0 ) and ( not Canceled ) and ( Connected ) and ( Size <> -1 ) ) do
          Wait;
        i := Length( AString );
        j := FifoQ.BufferSize;

        if Size <> -1 then
          if i + j < Size then
            j := Size - i;

        if j <> 0 then
          begin
            SetLength( AString, i + j );
            FifoQ.Remove( @AString[ i + 1 ], j );
            FBytesRecvd := FBytesRecvd + j;
            TimerOn;
          end;

        if assigned( FPacketRecvd ) then
          FPacketRecvd( self );

        if not Connected then
          break;
      end;

    if Canceled then
      begin
        Canceled := False;
        raise EAbortError.Create( sPSk_Cons_msg_cap_a );
        if assigned( OnAbortrestart ) then
          OnAbortrestart( self );
      end;
  finally
    TimerOff;
  end;
end;

{*******************************************************************************************
Filter out a MIME header
********************************************************************************************}

procedure TPowersock.FilterHeader( HeaderStream: TFileStream );
var
  StrIn             : string;

begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_filthead ); {Inform status}
  repeat
    StrIn := ReadLn;                    {Read a line}
    HeaderStream.WriteBuffer( StrIn[ 1 ], Length( StrIn ) ) {Write it to buffer}
  until ( StrIn = LF ) or ( StrIn = CRLF ) or ( StrIn = '' ); {Until blank line}
end;

{*******************************************************************************************
Initialize Socket and Listen to It
********************************************************************************************}

procedure TPowersock.Listen( sync: Boolean );

begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_Listen ); {Report status}

  {Set Address to blank}
  RemoteAddress.sin_addr.S_addr := Inet_Addr( StrPCopy( Buf, '0.0.0.0' ) );
  RemoteAddress.sin_family := AF_INET;  {Family = Internet address}
  RemoteAddress.sin_port := htons( Port ); {Set port to given port}

  {Bind Socket to given address}
  Winsock.bind( ThisSocket, RemoteAddress, SizeOf( RemoteAddress ) );

  {Direct reply message to WM_WAITFORRESPONSE handler}
  if sync then
    WSAAsyncselect( ThisSocket, FSocketWindow, WM_WAITFORRESPONSE, FD_ALL )
  else
    WSAAsyncselect( ThisSocket, FSocketWindow, WM_ASYNCHRONOUSPROCESS, FD_ALL );

  {Listen to socket}
  Winsock.Listen( ThisSocket, 5 );
end;

{*******************************************************************************************
Accept Input from Listening Socket
********************************************************************************************}

function TPowersock.Accept;
var
  SockHandle        : TSocket;
  ASocKAddr         : TSockAddr;
  Asize             : Integer;
begin
  StatusMessage( Status_Routines, sPSk_Cons_msg_accept ); {Status message}
  TimerOn;

  while ( not Wait_Flag ) and ( not Canceled ) do
    wait;
  TimerOff;
  {if error create exception}
  if Canceled then
    raise ESockError.Create( sPSk_Cons_msg_acc_can );
  if not Succeed then
    raise ESockError.Create( sPSk_Cons_err_data_conn );
  Asize := SizeOf( ASocKAddr );         {Size of Socket address structure}

  {Accept socket}
  {$IFDEF NMF3}
  SockHandle := Winsock.Accept( ThisSocket, @ASocKAddr, @Asize );
  {$ELSE}
  SockHandle := Winsock.Accept( ThisSocket, ASocKAddr, Asize );
  {$ENDIF}
  Result := SockHandle;                 {Make the Accepte socket This Socket}
  WSAAsyncselect( SockHandle, FSocketWindow, WM_ASYNCHRONOUSPROCESS, FD_ALL ); {To direct messages to clientsocket}
  RemoteAddress := ASocKAddr;           {save remote host address info}

  if Canceled then
    begin
      Canceled := false;
      raise EAbortError.create( sPSk_Cons_msg_send_a );
      if assigned( OnAbortrestart ) then
        OnAbortrestart( self );
    end;
end;

{*******************************************************************************************
Return Error Message Corresponding To Error number
********************************************************************************************}

function TPowersock.SocketErrorStr( Errno: Word ): string;
var
  x                 : integer;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_elookup + Result ); {Status message}
  Result := '';
  if Errno <> 0 then
    begin
      for x := 0 to 50 do               {Get error string}
        if winsockmessage[ x ].errorcode = errno then
          Result := inttostr( winsockmessage[ x ].errorcode ) + ':' + winsockmessage[ x ].text;
      if Result = '' then               {If not found say unknown error}
        Result := sPSk_Cons_msg_unknown + IntToStr( Errno );
    end;
end;

procedure TPowersock.CloseAfterData;
var
  gudtLinger        : Tlinger;
begin
  gudtLinger.l_onoff := 0;
  gudtLinger.l_linger := 0;
  setsockopt( ThisSocket, SOL_SOCKET, SO_LINGER, @gudtLinger, 4 );
end;

procedure TPowersock.CloseImmediate;
var
  gudtLinger        : Tlinger;
begin
  gudtLinger.l_onoff := 0;
  gudtLinger.l_linger := 0;
  setsockopt( ThisSocket, SOL_SOCKET, SO_DONTLINGER, @gudtLinger, 4 );
end;
{*******************************************************************************************
TimeOut Handler
********************************************************************************************}

procedure TPowersock.TimerFired( Sender: TObject );
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_ttrig ); {Status Message}
  TimerOff;                             {Switch off timer}
  TimedOut := True;                     {Set timed out flag}
  WaitSignal.SetEvent;
  Abort;
end;

{*******************************************************************************************
Set Timer On
********************************************************************************************}

procedure TPowersock.TimerOn;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_TimerOn ); {Status Message}
  TimedOut := False;                    {Timed out flag reset}
  Timer.Enabled := False;               {Enable timer}
  Timer.Interval := FTimeOut;           {Set TimeOut Interval}
  Timer.Enabled := True;                {Enable timer}
end;

{*******************************************************************************************
Set Timer Off
********************************************************************************************}

procedure TPowersock.TimerOff;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_TimerOff ); {Status Message}
  Timer.Enabled := False;               {Disable timer}
end;

{*******************************************************************************************
Initialize WinSock
********************************************************************************************}

procedure TPowersock.InitWinsock;
var
  gudtLinger: Tlinger;
begin
  StatusMessage(Status_Debug, sPSk_Cons_msg_InitSock); {Status Message}
  {Startup Winsock}
  if (not (csDesigning in ComponentState)) and SockAvailable then
    try
      ThisSocket := Socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
      gudtLinger.l_onoff := 0;
      gudtLinger.l_linger := 0;
{$T-}
      setsockopt(ThisSocket, SO_DONTLINGER, SO_LINGER, @gudtLinger, 4);
{$T+}
      if ThisSocket = TSocket(INVALID_SOCKET) then
        ErrorManager(WSAEWOULDBLOCK); {If error handle error}
      WSAAsyncselect(ThisSocket, FSocketWindow, WM_ASYNCHRONOUSPROCESS, FD_ALL);
    except
      raise ESockError.Create(sPSk_Cons_err_werr);
    end;
end;

{*******************************************************************************************
Socket Windows Message handler
********************************************************************************************}

procedure TPowersock.Wndproc( var message: TMessage );
begin
  try
    with message do
      begin
        if LParamHi > 0 then
          Succeed := False              {Succeed flag not set}
        else
          Succeed := True;

        case Msg of
          WM_ASYNCHRONOUSPROCESS:
            case LParamLo of

              FD_CONNECT:
                if Succeed then
                  begin
                    // If any data has come in, it should be added to the incoming data queue now.
                    FConnected := True;
                    WaitSignal.SetEvent;
                    if assigned( FOnConnect ) then
                      FOnConnect( self );
                  end;

              FD_CLOSE:
                begin
                  try
                    if FConnected then
                      begin
                        ClearInput;
                        RequestCloseSocket;
                      end;
                  except
                  end;
                  WaitSignal.SetEvent;
                  if assigned( FOnDisconnect ) then
                    FOnDisconnect( self );
                end;

              FD_READ:
                try
                  ReadToBuffer;
                  if assigned( FOnReadEvent ) then
                    FOnReadEvent( self )
                except
                end;

              FD_ACCEPT:
                begin
                  FConnected := True;
                  WaitSignal.SetEvent;
                  if assigned( FOnAcceptEvent ) then
                    FOnAcceptEvent( self );
                end;
            end;

          WM_WAITFORRESPONSE:
            begin
              Wait_Flag := True;
              WaitSignal.SetEvent;

              if LParamLo = FD_ACCEPT then
                begin
                  FConnected := True;
                  if not ( csDestroying in ComponentState ) then
                    if assigned( FOnConnect ) then
                      FOnConnect( self );
                end;
            end;
        end;
      end;
  except
  end;
end;

procedure TPowersock.ReadToBuffer;
var
  rc                : integer;
begin
  repeat
    rc := recv( ThisSocket, Buf, MAX_RECV_BUF, 0 );
    if rc = 0 then
      RequestCloseSocket;

    if rc > 0 then
      FifoQ.Append( Pointer( @Buf ), rc );
    WaitSignal.SetEvent;
  until rc < MAX_RECV_BUF;
end;

{*******************************************************************************************
Request Socket to be closed
********************************************************************************************}

procedure TPowersock.RequestCloseSocket;
begin
  StatusMessage( Status_Routines, sPSk_Cons_msg_RCloseSock ); {Report status}
  FConnected := False;
  if ThisSocket <> TSocket( INVALID_SOCKET ) then
    begin
      {Close it}
      Winsock.CloseSocket( ThisSocket );
      if not ( csDestroying in ComponentState ) then
        if assigned( FOnDisconnect ) then
          FOnDisconnect( self );
      if not DestroySocket then
        begin
          ThisSocket := Socket( PF_INET, SOCK_STREAM, IPPROTO_IP );
          WSAAsyncselect( ThisSocket, FSocketWindow, WM_ASYNCHRONOUSPROCESS, FD_OOB or FD_ACCEPT or FD_CONNECT or FD_CLOSE or FD_READ );
        end
    end;
end;

{*******************************************************************************************
Get The last error
********************************************************************************************}

function TPowersock.GetLastErrorNo: Integer;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_getLastE ); {Report Status}
  Result := FLastErrorno;               {Get Last error to result}
end;

{*******************************************************************************************
Set The Last Error
********************************************************************************************}

procedure TPowersock.SetLastErrorNo( Value: Integer );
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_setLastE ); {Report status}
  FLastErrorno := Value;                {Set Last error to value}
end;

{*******************************************************************************************
Handle Power socket error
********************************************************************************************}

function TPowersock.ErrorManager( Ignore: Word ): string;
var
  slasterror        : string;
begin
  FLastErrorno := wsagetlasterror;      {Set last error}
  if FLastErrorno <> Ignore then
    if ( FLastErrorno > 10000 ) then
      begin
        slasterror := SocketErrorStr( FLastErrorno ); {Get the description string for error}
        if assigned( FOnErrorEvent ) then {If error handler present excecute it}
          FOnErrorEvent( self, FLastErrorno, slasterror );
        raise ESockError.Create( slasterror ); {raise exception}
      end;
  Result := slasterror;                 {return error string}
end;

{*******************************************************************************************
Set Powersock error
********************************************************************************************}

procedure TPowersock.SetWSAError( ErrorNo: Word; ErrorMsg: string );
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_SetSockE ); {Report status}
  FLastErrorno := ErrorNo;              {Set Last error to error}
  if Length( ErrorMsg ) = 0 then
    SocketErrorStr( ErrorNo );          {If error message not there set it to error no}
  WSASetLastError( ErrorNo );           {Set Socket error to error no}
  if assigned( FOnErrorEvent ) then     {If error handler present excecute it}
    FOnErrorEvent( self, FLastErrorno, ErrorMsg );
end;

{*******************************************************************************************
Output a Status message: depends on current Reporting Level
********************************************************************************************}

procedure TPowersock.StatusMessage( Level: Byte; Value: string );
begin
  try
    if Level <= ReportLevel then
      begin
        _Status := Value;               {Set status to vale of error}
        if not ( csDestroying in ComponentState ) then
          if assigned( FOnStatus ) then
            FOnStatus( self, _Status ); {If Status handler present excecute it}
      end;
  except
  end;
end;

function TPowersock.DataAvailable: Boolean;
var
  rc                : integer;
  mc                : char;
begin
  result := FifoQ.BufferSize > 0;
  if not result then
    begin
      rc := recv(ThisSocket, mc, 1, MSG_PEEK);
      if rc > 0 then
        begin
          result := TRUE;
          ReadToBuffer;
        end
      else if rc = 0 then
        begin
          result:=TRUE;
          try
            if FConnected then
              begin
                ClearInput;
                RequestCloseSocket;
              end;
          except
          end;
          WaitSignal.SetEvent;
          if assigned(FOnDisconnect) then
            FOnDisconnect(self);
        end;
    end;
end;

procedure TPowersock.ClearInput;
var
  Buf               : array[ 0..MAX_RECV_BUF ] of Char;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_ClearInput ); {Inform status}
  recv( ThisSocket, Buf, MAX_RECV_BUF, 0 );
end;

{*******************************************************************************************
Resolve IP Address of Remote Host
********************************************************************************************}

procedure TPowersock.ResolveRemoteHost;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_ResolvHos ); {Inform status}

  if FProxy = '' then
    RemoteAddress.sin_addr.S_addr := Inet_Addr( StrPCopy( Buf, ServerName ) )
  else
    {else use Host address}
    RemoteAddress.sin_addr.S_addr := Inet_Addr( StrPCopy( Buf, FProxy ) );

  if RemoteAddress.sin_addr.S_addr = SOCKET_ERROR then
    {If given name not an IP address already}
    begin
      RemoteAddress.sin_addr.S_addr := 0;
      TimerOn;                          {Enable Timer}
      Wait_Flag := False;               {Reset flag indicating wait over}

      {Resolve IP address}
      wsaasyncgethostbyname( FSocketWindow, WM_WAITFORRESPONSE, Buf, PChar( RemoteHost ), MAXGETHOSTSTRUCT );

      repeat
        Wait;
      until Wait_Flag or TimedOut or Canceled; {Till host name resolved, Timed out or Cancelled}

      TimerOff;                         {Disable timer}

      {Handle errors}
      if TimedOut then
        raise ESockError.Create( sPSk_Cons_msg_host_to );

      if Canceled then
        raise ESockError.Create( sPSk_Cons_msg_host_Can );

      if Succeed = False then
        raise ESockError.Create( sPSk_Cons_msg_host_Fail );

      {Fill up remote host information with retreived results}
      with RemoteAddress.sin_addr.S_un_b do
        begin
          s_b1 := RemoteHost.h_addr_list^[ 0 ];
          s_b2 := RemoteHost.h_addr_list^[ 1 ];
          s_b3 := RemoteHost.h_addr_list^[ 2 ];
          s_b4 := RemoteHost.h_addr_list^[ 3 ];
        end;

      {If Remote host handler exists execute it}
      if assigned( FOnHostResolved ) then
        FOnHostResolved( self );
    end;
end;

{*******************************************************************************************
Abort a Socket
********************************************************************************************}

procedure TPowersock.Abort;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_Abort ); {Inform status}
  Cancel;
end;

{*******************************************************************************************
Close a Socket
********************************************************************************************}

procedure TPowersock.Close( Socket: THandle );
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_CloseSock ); {Inform status}
  CloseSocket( Socket );                {Close socket}
end;

{*******************************************************************************************
Get IP Address of remote machine in dotted decimal notation
********************************************************************************************}

function TPowersock.GetRemoteIP: string;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_GetRemoteIP ); {Inform status}
  Result := inet_ntoa( RemoteAddress.sin_addr );
end;

{*******************************************************************************************
Get IP Address of local machine in dotted decimal notation
********************************************************************************************}

function TPowersock.GetLocalIP: string;
var
  pH                : PHostEnt;
  T                 : PChar;
begin
  StatusMessage( Status_Debug, sPSk_Cons_msg_GetLocalIP ); {Inform status}
  T := AllocMem( 200 );
  try
    gethostname( T, 200 );
    pH := gethostbyname( T );
    Result := Format( '%d.%d.%d.%d', [ Ord( pH.h_addr_list^[ 0 ] ), Ord( pH.h_addr_list^[ 1 ] ), Ord( pH.h_addr_list^[ 2 ] ), Ord( pH.h_addr_list^[ 3 ] ) ] );
  finally
    FreeMem( T, 200 );
  end;
end;

{*******************************************************************************************
Get Address String of Local Machine
********************************************************************************************}

function TPowersock.GetLocalAddress;
var
  sockaddr          : TSockAddrIn;
  iSize, Commas     : Integer;
  P                 : PChar;
begin
  iSize := SizeOf( TSockAddr );         {Size of Address structure}
  {Get Local Socket info}
  getsockname( ThisSocket, sockaddr, iSize );
  P := inet_ntoa( sockaddr.sin_addr );
  iSize := 0;
  Commas := 0;

  while Commas < 3 do
    begin
      if P[ iSize ] = '.' then
        begin
          P[ iSize ] := ',';
          inc( Commas );
        end;
      inc( iSize );
    end;

  Result := StrPas( P );
end;

{*******************************************************************************************
Get Port String of a listening Port
********************************************************************************************}

function TPowersock.GetPortString;
var
  sockaddr          : TSockAddrIn;
  iSize             : Integer;
begin
  iSize := SizeOf( TSockAddr );         {Size of Address structure}
  getsockname( ThisSocket, sockaddr, iSize );

  with sockaddr do                      {Format IP address to required string type}
    Result := Format( ',%d,%d', [ Lo( sin_port ), Hi( sin_port ) ] );
end;

procedure TPowersock.SetFifoCapacity( NewCapacity: Longint );
begin
  Fifoq.MemoryBufferCapacity := NewCapacity;
end;

function TPowersock.GetFifoCapacity: Longint;
begin
  Result := Fifoq.MemoryBufferCapacity;
end;

{*******************************************************************************************
********************************************************************************************
********************************************************************************************}

{ TTimer }

constructor TThreadTimer.Create( AOwner: TComponent );
begin
  inherited Create( AOwner );
  FEnabled := True;
  FInterval := 1000;
  FWindowHandle := TmrAllocateHWnd( self );
end;

destructor TThreadTimer.Destroy;
begin
  FEnabled := False;
  UpdateTimer;
  DestroyWindow( FWindowHandle );
  inherited Destroy;
end;

procedure TThreadTimer.Wndproc( var Msg: TMessage );
begin
  with Msg do
    if Msg = WM_TIMER then
      try
        Timer;
      except
        Application.HandleException( self );
      end
    else
      Result := DefWindowProc( 0, Msg, WPARAM, LPARAM );
end;

procedure TThreadTimer.UpdateTimer;
begin
  KillTimer( FWindowHandle, 1 );
  if ( FInterval <> 0 ) and FEnabled and assigned( FOnTimer ) then
    if SetTimer( FWindowHandle, 1, FInterval, nil ) = 0 then
      raise Exception.Create( sPSk_Cons_msg_NoTimer );
end;

procedure TThreadTimer.SetEnabled( Value: Boolean );
begin
  if Value <> FEnabled then
    begin
      FEnabled := Value;
      UpdateTimer;
    end;
end;

procedure TThreadTimer.SetInterval( Value: Cardinal );
begin
  if Value <> FInterval then
    begin
      FInterval := Value;
      UpdateTimer;
    end;
end;

procedure TThreadTimer.SetOnTimer( Value: TNotifyEvent );
begin
  FOnTimer := Value;
  UpdateTimer;
end;

procedure TThreadTimer.Timer;
begin
  if assigned( FOnTimer ) then
    FOnTimer( self );
end;

{*******************************************************************************************
********************************************************************************************
********************************************************************************************}

{*******************************************************************************************
Create Server - If Demo version handles demo Registering
********************************************************************************************}

constructor TNMGeneralServer.Create;
var
  Tp                : TClass;
begin
  inherited Create( AOwner );
  Tp := AOwner.ClassType;
  ATlist := nil;
  repeat
    if Tp = TNMGeneralServer then
      break
    else
      Tp := Tp.ClassParent;
  until Tp = nil;
  if Tp = nil then
    ATlist := TThreadList.Create;
end;

destructor TNMGeneralServer.Destroy;
begin
  try
    try
      Abort;
    finally
      if ATlist <> nil then
        ATlist.Free;
      ATlist := nil;
    end;
  finally
    inherited Destroy;
  end;
end;

{*******************************************************************************************
Override connect so no inherited connection
********************************************************************************************}

procedure TNMGeneralServer.Connect;
begin
  {Does not call inherited connect}
end;

{*******************************************************************************************
On Loading the General Sever. Set the ServerAccept method to handle accepts from
a client and start listening for connections.
********************************************************************************************}

procedure TNMGeneralServer.Loaded;
begin
  inherited Loaded;
  if not ( csDesigning in ComponentState ) then
    begin
      OnAccept := ServerAccept;
      Listen( False );
    end;
end;

procedure TNMGeneralServer.Abort;
var
  X                 : Integer;
begin
  if ATlist <> nil then
    begin
      with ATlist.LockList do
        try
          for X := 0 to Count - 1 do
            TNMGeneralServer( Items[ X ] ).Cancel;
        finally
          ATlist.UnlockList;
        end;
    end;
end;

{*******************************************************************************************
The method to accept a connection from a client.  It kicks off a thread to handle a client
and resumes listning on the original socket.
********************************************************************************************}

procedure TNMGeneralServer.ServerAccept;
begin
  ExecuteInThread( DisPatchResponse, nil );
end;

procedure TNMGeneralServer.DisPatchResponse( data: pointer );
var
  ServSock          : TNMGeneralServer;
begin
  ServSock := TNMGeneralServer( TComponentClass( ( self.ClassType( ) ) ).Create( Owner ) );
  ServSock.FConnected := True;
  ServSock.RemoteAddress := RemoteAddress;
  ServSock.OnConnect := OnConnect;
  ServSock.OnDisConnect := OnDisConnect;
  Winsock.CloseSocket( ServSock.ThisSocket );
  wait_flag := TRUE;
  ServSock.ThisSocket := Accept;
  WSAAsyncselect( ServSock.ThisSocket, ServSock.FSocketWindow, WM_ASYNCHRONOUSPROCESS, FD_ALL ); {To direct messages to clientsocket}
  ATlist.Add( ServSock );
  ServSock.Chief := self;
  ServSock.serve;
  ATList.Remove( ServSock );
  ServSock.Destroy;
end;

{*******************************************************************************************
The base server metod for GeneralServer. This has to be overridden by a derived
server to provide the servers functionality.
********************************************************************************************}

procedure TNMGeneralServer.Serve;
begin
end;

{*******************************************************************************************
********************************************************************************************
********************************************************************************************}

{$IFNDEF NMF3}

{ TStringStream }

constructor TStringStream.Create( const AString: string );
begin
  inherited Create;
  FDataString := AString;
end;

function TStringStream.Read( var Buffer; Count: Longint ): Longint;
begin
  Result := Length( FDataString ) - FPosition;
  if Result > Count then
    Result := Count;
  Move( PChar( @FDataString[ FPosition + 1 ] )^, Buffer, Result );
  Inc( FPosition, Result );
end;

function TStringStream.Write( const Buffer; Count: Longint ): Longint;
begin
  Result := Count;
  SetLength( FDataString, ( FPosition + Result ) );
  Move( Buffer, PChar( @FDataString[ FPosition + 1 ] )^, Result );
  Inc( FPosition, Result );
end;

function TStringStream.Seek( Offset: Longint; Origin: Word ): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: FPosition := FPosition + Offset;
    soFromEnd: FPosition := Length( FDataString ) - Offset;
  end;
  if FPosition > Length( FDataString ) then
    FPosition := Length( FDataString )
  else if FPosition < 0 then
    FPosition := 0;
  Result := FPosition;
end;

function TStringStream.ReadString( Count: Longint ): string;
var
  Len               : Integer;
begin
  Len := Length( FDataString ) - FPosition;
  if Len > Count then
    Len := Count;
  SetString( Result, PChar( @FDataString[ FPosition + 1 ] ), Len );
  Inc( FPosition, Len );
end;

procedure TStringStream.WriteString( const AString: string );
begin
  Write( PChar( AString )^, Length( AString ) );
end;

procedure TStringStream.SetSize( NewSize: Longint );
begin
  SetLength( FDataString, NewSize );
  if FPosition > NewSize then
    FPosition := NewSize;
end;

{*******************************************************************************************
********************************************************************************************
********************************************************************************************}

{ TThreadList }

constructor TThreadList.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TThreadList.Destroy;
begin
  LockList;                             // Make sure nobody else is inside the list.
  try
    FList.Free;
    inherited Destroy;
  finally
    UnlockList;
  end;
end;

procedure TThreadList.Add( Item: Pointer );
begin
  LockList;
  try
    if FList.IndexOf( Item ) = -1 then
      FList.Add( Item );
  finally
    UnlockList;
  end;
end;

procedure TThreadList.Clear;
begin
  LockList;
  try
    FList.Clear;
  finally
    UnlockList;
  end;
end;

function TThreadList.LockList: TList;
begin
  Result := FList;
end;

procedure TThreadList.Remove( Item: Pointer );
begin
  LockList;
  try
    FList.Remove( Item );
  finally
    UnlockList;
  end;
end;

procedure TThreadList.UnlockList;
begin
end;
{$ENDIF}

{*******************************************************************************************
********************************************************************************************
********************************************************************************************}

{*******************************************************************************************
Get Nth Word in a string
  InputString: The string on which the Nth Word is to be found
  Delimiter: The seperator for words - normally the space charachter but can be anything else
             for example if you are parsing an URL it can be the '/' charachter
  Number: The Nth word to be found . ie if you want the third Number:=3
  Result: The Nth Word as a string
********************************************************************************************}

function NthWord( InputString: string; Delimiter: Char; Number: Integer ): string;
var
  I, J, K           : Integer;
  temp              : string;
begin
  if InputString = '' then
    Result := ''
  else
    begin
      I := 0;                           {Initialize variables}
      J := 1;
      K := Length( InputString ) + 1;
      temp := '';

      repeat
        if InputString[ J ] = Delimiter then
          Inc( I )
        else
          {if delimter count is correct, copy to output string}
          if I = Number - 1 then
            temp := temp + InputString[ J ];
        Inc( J );                       {Go to next character}
      until ( ( I = Number ) or ( J = K ) ); {Until delimter past count or end of string}

      Result := temp;                   {Return result}
    end;
end;

{*******************************************************************************************
Get Position of Nth Occurrence of a Delimiter
  InputString: The string on which the Nth Occurence is to be found
  Delimiter: The charachter for whose Nth Occurence you are surching for
  Number: The Nth Occurence to be found . ie if you want the third Occurence Number:=3
  Result: The Positio of the Nth Occurence
********************************************************************************************}

function NthPos( InputString: string; Delimiter: Char; Number: Integer ): Integer;
var
  I, J, K           : Integer;
begin
  I := 0;
  J := 1;
  K := Length( InputString ) + 1;       {Initialize variables}

  repeat
    if InputString[ J ] = Delimiter then
      I := I + 1;
    J := J + 1;                         {Go to next word}
  until ( ( I = Number ) or ( J = K ) ); {Until pos found or end of string}

  if J <> K then
    Result := J - 1
  else
    Result := K;
end;

{*******************************************************************************************
Append string to stream
  Astream: The stream to append to
  AString: The string to be  appended
********************************************************************************************}

procedure StreamLn( AStream: TStream; AString: string );
var
  Tempstr           : string;
begin
  Tempstr := AString + CRLF;            {Add Carriage Return  and Line Feed}
  AStream.WriteBuffer( Tempstr[ 1 ], Length( Tempstr ) ); {Write string to stream}
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ The windows message handler                                               }

function PsockWindowProc(
  ahWnd: HWND;
  auMsg: Integer;
  awParam: WPARAM;
  alParam: LPARAM ): Integer; stdcall;
var
  Obj               : TPowersock;
  MsgRec            : TMessage;
begin
  Obj := TPowersock( GetWindowLong( ahWnd, 0 ) );
  if ( ( not Assigned( Obj ) ) or ( auMsg < WM_ASYNCHRONOUSPROCESS ) ) then
    Result := DefWindowProc( ahWnd, auMsg, awParam, alParam )
  else
    begin
      MsgRec.Msg := auMsg;
      MsgRec.WPARAM := awParam;
      MsgRec.LPARAM := alParam;
      MsgRec.Result := 0;
      Obj.Wndproc( MsgRec );
      Result := MsgRec.Result;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This global variable is used to store the windows class characteristic    }
{ and is needed to register the window class used by TWSocket               }
var
  PsockWindowClass  : TWndClass = (
    Style: 0;
    lpfnWndproc: @PsockWindowProc;
    cbClsExtra: 0;
    cbWndExtra: SizeOf( Pointer );
    HInstance: 0;
    HICON: 0;
    HCURSOR: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'PsockWindowClass' );

function PsockAllocateHWnd( Obj: TObject ): HWND;
var
  TempClass         : TWndClass;
  ClassRegistered   : Boolean;
begin
  { Check if the window class is  registered}
  if PsockWindowClass.HInstance = 0 then
    PsockWindowClass.HInstance := HInstance;

  ClassRegistered := GetClassInfo( HInstance, PsockWindowClass.lpszClassName, TempClass );

  if not ClassRegistered then
    begin
      Result := WinProcs.RegisterClass( PsockWindowClass );
      if Result = 0 then
        Exit;
    end;

  { Create a new window                                               }
  Result := CreateWindowEx( WS_EX_TOOLWINDOW,
    PsockWindowClass.lpszClassName,
    '',                                 { Window name   }
    WS_POPUP,                           { Window Style  }
    0, 0,                               { X, Y          }
    0, 0,                               { Width, Height }
    0,                                  { hWndParent    }
    0,                                  { hMenu         }
    HInstance,                          { hInstance     }
    nil );                              { CreateParam   }

  if ( Result <> 0 ) and assigned( Obj ) then
    SetWindowLong( Result, 0, Integer( Obj ) );

end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ The windows message handler                                               }

function TmrWindowProc(
  ahWnd: HWND;
  auMsg: Integer;
  awParam: WPARAM;
  alParam: LPARAM ): Integer; stdcall;
var
  Obj               : TThreadTimer;
  MsgRec            : TMessage;
begin
  // OBJ is created by you here every time I get a window message.
  Obj := TThreadTimer(GetWindowLong(ahWnd, 0));

  if not assigned(Obj) then
    Result := DefWindowProc(ahWnd, auMsg, awParam, alParam)
  else
    begin
      MsgRec.Msg := auMsg;
      MsgRec.WPARAM := awParam;
      MsgRec.LPARAM := alParam;
      if (auMsg <> WM_TIMER) then
        Result := DefWindowProc(ahWnd, auMsg, awParam, alParam)
      else
        begin
          Obj.Wndproc(MsgRec);
          Result := MsgRec.Result;
        end;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This global variable is used to store the windows class characteristic    }
{ and is needed to register the window class used by TWSocket               }
var
  TmrWindowClass    : TWndClass = (
    Style: 0;
    lpfnWndproc: @TmrWindowProc;
    cbClsExtra: 0;
    cbWndExtra: SizeOf( Pointer );
    HInstance: 0;
    HICON: 0;
    HCURSOR: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'TmrWindowClass' );

function TmrAllocateHWnd( Obj: TObject ): HWND;
var
  TempClass         : TWndClass;
  ClassRegistered   : Boolean;
begin
  { Check if the window class is  registered}
  if TmrWindowClass.HInstance = 0 then
    TmrWindowClass.HInstance := HInstance;
  ClassRegistered := GetClassInfo( HInstance, TmrWindowClass.lpszClassName, TempClass );

  if not ClassRegistered then
    begin
      Result := WinProcs.RegisterClass( TmrWindowClass );
      if Result = 0 then
        Exit;
    end;

  { Create a new window                                               }
  Result := CreateWindowEx( WS_EX_TOOLWINDOW,
    TmrWindowClass.lpszClassName,
    '',                                 { Window name   }
    WS_POPUP,                           { Window Style  }
    0, 0,                               { X, Y          }
    0, 0,                               { Width, Height }
    0,                                  { hWndParent    }
    0,                                  { hMenu         }
    HInstance,                          { hInstance     }
    nil );                              { CreateParam   }

  if ( Result <> 0 ) and assigned( Obj ) then
    SetWindowLong( Result, 0, Integer( Obj ) );
end;

initialization;
  try
    SockAvailable := WSAStartUp($0101, MyWSADATA) <> -1;
  except
  end;

finalization;

  try
    if SockAvailable then WSACleanUp; {Clean up Winsock}
  except
  end;

end.

