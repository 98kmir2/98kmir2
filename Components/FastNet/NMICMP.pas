(*
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////
//                                                                       //
//  Copyright © 1996-1999,  NetMasters,  L.L.C - All rights reserved     //
//  worldwide. Portions may be Copyright © Borland International,  Inc.  //
//                                                                       //
// NMICMP:  ( NMICMP.PAS )                                               //
//                                                                       //
// DESCRIPTION: ICMP (Internet Control Message Protocol) implementation  //
//              for Ping and Trace Route                                 //
//                                                                       //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY //
// KIND,  EITHER EXPRESSED OR IMPLIED,  INCLUDING BUT NOT LIMITED TO THE //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR //
// PURPOSE.                                                              //
//                                                                       //
//  + Aug-9-98  Version 4.1 -- ETS                                       //                                                                      //
///////////////////////////////////////////////////////////////////////////

(************************************************************************)
(*                                                                      *)
(*  Unit: NMICMP;                                                       *)
(*  Initial Version 1.0 Dec-12-1997 Ed Smith                            *)
(*  Last Update: 12-12-97 Ed Smith                                      *)
(*  Revision History: Initial Version 12-12-97                          *)
(*  Known Problems: None                                                *)
(*  Modification Ideas: Delay property in TNMPing(JDV)                  *)
(*                      Resolve IPs to Host Names in TraceRt            *)
(*                                                                      *)
(************************************************************************)
unit NMICMP;

interface

uses
 Windows,  Messages, SysUtils, Classes, Forms, Winsock;
{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER120}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}
{$ObjExportAll On}
{$ENDIF}

const
  WM_LOOKUPADDRESS = WM_USER + 101; // Message when looking up host

  // ICMP Status Codes
  BASE                   = 11000;
  OPER_ABORT             = -1;
  ICMP_SUCCESS           = 0;
  BUFF_TOO_SMALL         = BASE +  1;
  DEST_NET_UNREACHABLE   = BASE +  2;
  DEST_HOST_UNREACHABLE  = BASE +  3;
  DEST_PROT_UNREACHABLE  = BASE +  4;
  DEST_PORT_UNREACHABLE  = BASE +  5;
  NO_RESOURCES           = BASE +  6;
  BAD_OPTIONS            = BASE +  7;
  HW_ERROR               = BASE +  8;
  PACKET_TOO_BIG         = BASE +  9;
  REQ_TIMED_OUT          = BASE + 10;
  BAD_REQUEST            = BASE + 11;
  BAD_ROUTE              = BASE + 12;
  TTL_EXP_TRANSIT        = BASE + 13;
  TTL_EXP_REASSMBLE      = BASE + 14;
  PARAM_PROBLEM          = BASE + 15;
  SOURCE_QUENCH          = BASE + 16;
  OPTIONS_TOO_BIG        = BASE + 17;
  BAD_DEST               = BASE + 18;
  ADDR_DELETED           = BASE + 19;
  SPEC_MTU_CHANGE        = BASE + 20;
  MTU_CHANGE             = BASE + 21;
  UNLOAD                 = BASE + 22;
  GENERAL_FAILURE        = BASE + 50;
  IP_STATUS              = GENERAL_FAILURE;
  PENDING                = BASE +255;

  // String constants
  con_abort = 'Operation aborted';
  con_lookup_fail = 'Host lookup failed';
  con_cantload = 'Unable to load ICMP.DLL';
  con_winserror = 'Error starting Winsock';
  con_icmperr = 'Error initializing ICMP Handle';
  con_datachar = '#';
  con_icmpdll = 'ICMP.DLL';
  con_icmpcreatefile = 'IcmpCreateFile';
  con_icmpclosehandle = 'IcmpCloseHandle';
  con_icmpsendecho = 'IcmpSendEcho';
  con_localabort = 'Local Abort';
  con_palette = 'Internet';
  con_badimports = 'Failure to import one or more routines from ICMP.DLL';
  con_hosttimedout = 'Host lookup timed out';

type
  THandle = Integer;

  // Record type for ICMP options
  PIPOptionInfo = ^TIPOptionInfo;
  TIPOptionInfo = packed record
    TTL: Byte;           // time to live (for TraceRt)
    TOS: Byte;           // Type of Service
    Flags: Byte;         // IP Header Flags
    OptionSize: Byte;    // Size of OptionData
    OptionData: Pointer; // pointer to option data
  end;

  // Record type for ICMP replies
  PIPEchoReply = ^TIPEchoReply;
  TIPEchoReply = packed record
    Address: u_long;          // replying address
    Status: u_long;           // Reply Status
    RTT: u_long;              //Round tip time in milliseconds
    DataSize: word;           // Size of data
    Reserved: word;           // Reserved for sys use
    Data: Pointer;            // Pointer to echoed data
    IPOptions: TIPOptionInfo; // Reply options
  end;

  //-------------Types for routines from ICMP.DLL
  TICMPCreateFile = function: THandle; stdcall;
  TICMPCloseHandle = function(ICMPHandle:THandle): Boolean; stdcall;
  TICMPSendEcho = function(ICMPHandle: THandle; // Handle gotten from ICMPCreateFile
                          DestAddress:longint; // Target IP (in NBO)
                          RequestData:pointer; // Pointer to request data to send
                          RequestSize:word;    // Length of RequestData
                          RequestOptions: PIPOptionInfo;
                          ReplyBuffer:pointer;
                          ReplySize:dword;     // Length of Reply
                          Timeout: DWord       // Time in milliseconds before TimeOut
                          ): dword; stdcall;

  //-------------Event types-------------//
  // When a ping comes back
  TPingEvent = procedure(Sender: TObject; Host: String; Size, Time: Integer) of Object;
  // When a TraceRt packet "hops"
  THopEvent = procedure(Sender: TObject; Host: String; Time1, Time2, Time3: Integer; HopNo: Integer) of Object;
  // Generic event when a host name might need to be known
  THostEvent = procedure(Sender: TObject; Host: String) of Object;
  // Status Event
  TStatusEvent = procedure(Sender: TObject; Status: Integer; Host: String) of Object;


  EICMPError = class(Exception);
  // Exception for ICMP Errors

  TNMICMP = class(TComponent)
  // NMICMP Class, base for NMPing and NMTraceRt
  private
    { Private declarations }
    DLLHandle: THandle; // Handle for ICMP.DLL
    ICMPHandle: THandle; // Handle for ICMP Functions
    WinHandle: HWND; // Window handle
    MyWSAData: TWSAData; // Winsock Data
    FHost: String; // Target host
    FTimeOut: Integer; // Timeout in milliseconds
    FPacketSize: Integer; // Size of data packets
    FAborted: Boolean; // If the current process has been aborted or not
//    FResolveIP: Boolean; // Resolve IPs to addresses
    FOnAbort: TNotifyEvent; // Called when the Abort method is used
    FOnInvalidHost: TNotifyEvent; // Called when the specified host is invalid
    FOnTimeOut: TNotifyEvent; // Called when an ICMP packet times out
    FHostUnreachable: THostEvent; // Destination host is unreachable
    FOnStatus: TStatusEvent; // For ICMP status messages
  protected
    { Protected declarations }
    // Functions from ICMP.DLL
    ICMPCreateFile: TICMPCreateFile;
    ICMPCloseHandle: TICMPCloseHandle;
    ICMPSendEcho: TICMPSendEcho;
    IPOptions: PIPOptioninfo; // Options for echo
    NetworkAddress: Longint; // Network address of target host
    HostInfo: PHostEnt; // Winsock struct contains info on remote host
    AddressInfo: TSockAddr; // Contains address info for remote host
    Success: Boolean; // Simple Success flag
    HostLookup: Boolean; // Set when the remote host lookup returns
    procedure WndProc(var Msg : TMessage); virtual; // Handles messages
    procedure ResolveAddresses; // Resolves network address/IP Address
    function GetHostName(InetAddr: Longint): String;

    // Events
    property OnTimeOut: TNotifyEvent read FOnTimeOut write FOnTimeOut;
  public
    { Public declarations }
//    HostName: String;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Abort; // Aborts current operation
  published
    { Published declarations }
    property Host: String read FHost write FHost;
    property PacketSize: Integer read FPacketSize write FPacketSize;
    property TimeOut: Integer read FTimeOut write FTimeOut;
//    property ResolveIPs: Boolean read FResolveIP write FResolveIP;
    //Events
    property OnAbort: TNotifyEvent read FOnAbort write FOnAbort;
    property OnInvalidHost: TNotifyEvent read FOnInvalidHost write FOnInvalidHost;
    property OnHostUnreachable: THostEvent read FHostUnreachable write FHostUnreachable;
    property OnStatus: TStatusEvent read FOnStatus write FOnStatus;
  end;

  TNMPing = class(TNMICMP)
  // NMPing, for pinging remote hosts
  private
    FOnPing: TPingEvent;
    FPings: Integer;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Ping;
  published
    property Pings: Integer read FPings write FPings;
    property OnPing: TPingEvent read FOnPing write FOnPing;
    property OnTimeOut; // From TNMICMP
  end;

  TNMTraceRt = class(TNMICMP)
  // NMTraceRt, for tracing the route to remote hosts
  private
    FHops: Integer; // Maximum number of hops (hosts to pass)
    FTraceComplete: TNotifyEvent;
    FOnHop: THopEvent; // Hop event
  protected
    TraceDone: Boolean; // Is the trace done?
  public
    constructor Create(AOwner: TComponent); override;
    procedure Trace;
  published
    // properties
    property MaxHops: Integer read FHops write FHops;
    // Events
    property OnHop: THopEvent read FOnHop write FOnHop;
    property OnTraceComplete: TNotifyEvent read FTraceComplete write FTraceComplete;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents(con_palette, [TNMPing, TNMTraceRt]);
end;


//--------------------------------------------------------------------------//
//------------TNMICMP (base class for TNMPing and TNMTraceRt----------------//
//--------------------------------------------------------------------------//
procedure TNMICMP.WndProc(var Msg : TMessage);
begin
  Success := false;
  If Msg.Msg = WM_LOOKUPADDRESS then
  Begin
    if Msg.lparamhi = 0 then
      Success := true
    else
      Success := false;
      HostLookup := TRUE;
  End;
end;

function TNMICMP.GetHostName(InetAddr: Longint): String;
var
  HostRes: PHostEnt;
begin
  // Returns Host name from a network address
  GetMem(HostRes, MAXGETHOSTSTRUCT);
  try
    WSAAsyncGetHostByAddr(WinHandle, WM_LOOKUPADDRESS, PChar(InetAddr), 4, PF_INET, PChar(HostRes), MAXGETHOSTSTRUCT);
    repeat
      Application.ProcessMessages;
    until HostLookup or FAborted;
    if FAborted then
      raise EICMPError.Create(con_abort);
(******* Need to check this out, to see if the host resolution is working right. ****)
    Result := StrPas(HostRes^.h_name);
  finally
    FreeMem(HostRes, MAXGETHOSTSTRUCT);
  end;
end;

//---This procedure needs to set the Network Address for the target host.
procedure TNMICMP.ResolveAddresses;
var
  Buff: Array[0..127] of Char;
begin
  // See if an IP Address was set as the host
  AddressInfo.sin_addr.s_addr := Inet_Addr(StrPCopy(Buff, FHost));
  If AddressInfo.sin_addr.s_addr = SOCKET_ERROR then
  Begin // If not, resolve it a different way
    AddressInfo.sin_addr.s_addr := 0;
    HostLookup := FALSE;
    WSAAsyncGetHostByName(WinHandle, WM_LOOKUPADDRESS, Buff, PChar(HostInfo), MAXGETHOSTSTRUCT);
    repeat
      Application.ProcessMessages;
    until HostLookup or FAborted;

    // If the host lookup was aborted
    If FAborted then
      raise EICMPError.Create(con_abort);

    // if the host lookup failed
    If (not HostLookup) or (not Success) then
    Begin
      if assigned(FOnInvalidHost) then
        FOnInvalidHost(Self);
      raise EICMPError.Create(con_lookup_fail);
    End
    else
    begin
      // Look up host name if resolve IP is true
      with AddressInfo.sin_addr.S_un_b do
      begin
        s_b1 := HostInfo.h_addr_list^[0];
        s_b2 := HostInfo.h_addr_list^[1];
        s_b3 := HostInfo.h_addr_list^[2];
        s_b4 := HostInfo.h_addr_list^[3];
      end;
    end;
  End;
  NetworkAddress := AddressInfo.sin_addr.s_addr;
//  If FResolveIP then
//    HostName := GetHostName(NetworkAddress);
end;

constructor TNMICMP.Create(AOwner: TComponent);
begin
 // Basic TComponent create
  inherited Create(AOwner);

  // Allocate space for remote host info
  GetMem(HostInfo, MAXGETHOSTSTRUCT);

  ICMPHandle := -1; // Nullify the ICMP Handle
  // Constant expression violates subrange bounds

  FTimeOut := 5000; // default timeout to 5 seconds
  FPacketSize := 32; // Default packetsize to 32 bytes

  DLLHandle := -1; // Nullify DLL handle
  // Constant expression violates subrange bounds

  FAborted := FALSE; // Operation not aborted
  @ICMPCreateFile := nil;
  @ICMPCloseHandle := nil;
  @ICMPSendEcho := nil;
  // Allocate window handle and message handling procedure
  // For winsock calls (just looking up host names)
  WinHandle := AllocateHwnd(Self.WndProc);

  // Dynamically load ICMP.DLL
  DLLHandle := LoadLibrary(Pchar(con_icmpdll));

  // Setting up ICMP Functions from ICMP.DLL
  If DLLHandle <> -1 then
  Begin
    @ICMPCreateFile := GetProcAddress(DLLHandle, con_icmpcreatefile);
    @ICMPCloseHandle := GetProcAddress(DLLHandle, con_icmpclosehandle);
    @ICMPSendEcho := GetProcAddress(DLLHandle, con_icmpsendecho);
  End
  else
    raise EICMPError.Create(con_cantload);
  If (@ICMPCreateFile = nil) or
     (@ICMPCloseHandle = nil) or
     (@ICMPSendEcho = nil) then
       raise EICMPError.Create(con_badimports);
  // Init winsock for getting host names and stuff
  if WSAStartUp($0101, MyWSADATA) <> 0 then
    raise EICMPError.Create(con_winserror);

  // Init memory for IPOptions
  GetMem(IPOptions, SizeOf(TIPOptionInfo));

  // Allocate ICMP Handle
  ICMPHandle := ICMPCreateFile;

end;

destructor TNMICMP.Destroy;
begin

  // Free window handle
  DeAllocateHWnd(WinHandle);

  // Free the ICMP handle
  if ICMPHandle <> -1 then
    ICMPCloseHandle(ICMPHandle);

  // Free the DLL library
  if DLLHandle <> -1 then
    FreeLibrary(DLLHandle);

  // cleanup winsock
  WSACleanup;

  // Free memory for IPOptions
  If IPOptions <> nil then
    FreeMem(IPOptions, SizeOf(TIPOptionInfo));

  // Free memory allocated for HostInfo structure
  If HostInfo <> nil then
    FreeMem(HostInfo, MAXGETHOSTSTRUCT);

  // basic TComponent destroy
  inherited Destroy;
end;

procedure TNMICMP.Abort;
begin
  // Set the abort switch to True
  FAborted := TRUE;

  // Call the abort event if it's been set
  if assigned(FOnStatus) then
    FOnStatus(Self, OPER_ABORT, con_localabort);

  if assigned(FOnAbort) then
    FOnAbort(Self);
end;


//--------------------------------------------------------------------------//
//----------------------------TNMPing---------------------------------------//
//--------------------------------------------------------------------------//


constructor TNMPing.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPings := 4;
end;

procedure TNMPing.Ping;
var
  Tms, ReplySize: Integer;
  ReqData: Pointer;
  EchoReply: PIPEchoReply;
  ReplyAddress: TInAddr;
begin
  FAborted := FALSE;
  ResolveAddresses;
  If ICMPHandle = -1 then
    raise EICMPError.Create(con_icmperr);
  GetMem(ReqData, FPacketSize);
  ReplySize := SizeOf(TIPEchoReply)+FPacketSize+16;
  GetMem(EchoReply, ReplySize);
  try
    with IPOptions^ do
    Begin
      TTL := 255; // TTL 255 for a ping
      TOS := 0; // Type of Service
      Flags := 0;
      OptionSize := 0;
      OptionData := nil;
    End;
    FillChar(ReqData^,FPacketSize, con_datachar);
    For Tms := 1 to FPings do
    Begin
      // Pinging
      // If the operation has been aborted, exit the loop
      Application.ProcessMessages;
      If FAborted then
      Begin
        FAborted := FALSE;
        Exit;
      End;
      ICMPSendEcho(ICMPHandle, NetworkAddress, ReqData, FPacketSize, IPOptions, EchoReply, ReplySize, FTimeOut);
      ReplyAddress.S_addr := EchoReply^.Address;
      Case EchoReply^.Status of
        ICMP_SUCCESS:
          If assigned(FOnPing) then
//            If (not FResolveIP) then
              FOnPing(Self, StrPas(inet_ntoa(ReplyAddress)), EchoReply^.DataSize, EchoReply^.RTT);
//            else
//              FOnPing(Self, HostName, EchoReply^.DataSize, EchoReply^.RTT);
        DEST_NET_UNREACHABLE, DEST_HOST_UNREACHABLE:
          If assigned(FHostUnreachable) then
//            If (not FResolveIP) then
              FHostUnreachable(Self, StrPas(inet_ntoa(ReplyAddress)));
//            else
//              FHostUnreachable(Self, HostName);
        REQ_TIMED_OUT:
          if assigned(FOnTimeout) then
            FOnTimeOut(Self);
      end;
      if assigned(FOnStatus) then
//        If (not FResolveIP) then
          FOnStatus(Self, EchoReply^.Status, StrPas(inet_ntoa(ReplyAddress)));
//        else
//          FOnStatus(Self, EchoReply^.Status, HostName);
    End;
  finally
    If ReqData <> nil then
      FreeMem(ReqData, FPacketSize);
    If EchoReply <> nil then
      FreeMem(EchoReply, ReplySize);
  end;

end;

//--------------------------------------------------------------------------//
//---------------------------TNMTraceRt-------------------------------------//
//--------------------------------------------------------------------------//


constructor TNMTraceRt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHops := 30;
end;

procedure TNMTraceRt.Trace;
var
  Tmp, Tms, ReplySize: Integer;
  ReqData: Pointer;
  EchoReply: PIPEchoReply;
  ReplyAddress: TInAddr;
  ReplyTime: Array [1..3] of Integer;
begin
  FAborted := FALSE;
  TraceDone := FALSE;
  ResolveAddresses;
  If ICMPHandle = -1 then
    raise EICMPError.Create(con_icmperr);
  GetMem(ReqData, FPacketSize);
  FillChar(ReqData^,FPacketSize, con_datachar);
  ReplySize := SizeOf(TIPEchoReply)+FPacketSize+16;
  GetMem(EchoReply, ReplySize);
  try
    Tms := 0;
    while (Tms <= FHops) and (not FAborted) and (not TraceDone) do
    Begin
      Inc(Tms);
      For Tmp := 1 to 3 do
      Begin
        with IPOptions^ do
        Begin
          TTL := Tms; // TTL 255 for a ping
          TOS := 0; // Type of Service
          Flags := 0;
          OptionSize := 0;
          OptionData := nil;
        End;

        // Send the actual data packet
        ICMPSendEcho(ICMPHandle, NetworkAddress, ReqData, FPacketSize, IPOptions, EchoReply, ReplySize, FTimeOut);
        Application.ProcessMessages;
        If FAborted then
          Break;

        // Put replying address into a TInAddr struct for resolution
        ReplyAddress.S_addr := EchoReply^.Address;

        Case EchoReply^.Status of
          // Successful hop
          ICMP_SUCCESS, TTL_EXP_TRANSIT:
            ReplyTime[Tmp] := EchoReply^.RTT;

          // If the packet timed out, set a -1 reply time
          REQ_TIMED_OUT:
          begin
            ReplyTime[Tmp] := -1;
            if Assigned(FOnTimeOut) then
              FOnTimeOut(Self);
          end;
        End;
      //End;
      End;
      If FAborted then
      Begin
        Break;
      End;

      Case EchoReply^.Status of
        // If it's a successful hop, fire off the event
        ICMP_SUCCESS, TTL_EXP_TRANSIT, REQ_TIMED_OUT:
          If assigned(FOnHop) then
//            If (not FResolveIP) then
              FOnHop(Self, StrPas(inet_ntoa(ReplyAddress)), ReplyTime[1], ReplyTime[2], ReplyTime[3], Tms);
//            else
//              FOnHop(Self, HostName, ReplyTime[1], ReplyTime[2], ReplyTime[3], Tms);
        DEST_HOST_UNREACHABLE, DEST_NET_UNREACHABLE:
        Begin
          If assigned(FHostUnreachable) then
//            If (not FResolveIP) then
              FHostUnreachable(Self, StrPas(inet_ntoa(ReplyAddress)));
//            else
//              FHostUnreachable(Self, HostName);
          TraceDone := TRUE;
        End;
      end;

      // Fire off status event
      if assigned(FOnStatus) then
//        If (not FResolveIP) then
          FOnStatus(Self, EchoReply^.Status, StrPas(inet_ntoa(ReplyAddress)));
//        else
//          FOnStatus(Self, EchoReply^.Status, HostName);

      // If the address reached this time is the target, and the echo was successful, the trace is over
      If (EchoReply^.Address = NetworkAddress) and
         (EchoReply^.Status = ICMP_SUCCESS) then
      Begin
        if assigned(FTraceComplete) then
          FTraceComplete(Self);
        TraceDone := TRUE;
      End;
    End;
  finally
    If ReqData <> nil then
      FreeMem(ReqData, FPacketSize);
    If EchoReply <> nil then
      FreeMem(EchoReply, ReplySize);
  end;
end;

end.
