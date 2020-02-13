{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1996-1999, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMFtp                                                       //
//                                                                        //
// DESCRIPTION:Internet FTP Component                                     //
//  + Aug-9-98  Version 4.1 -- KNA                                        //
//                                                                        //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY  //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE    //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR  //
// PURPOSE.                                                               //
//                                                                        //
////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 01 26 00 - KNA -  List looks for Disconnect at start of loop
// 01 13 00 - KNA -  List Mask added
// 12 21 99 - KNA -  Waits chaged to DataSocket.wait
// 12 17 99 - KNA -  End Condition Changed from DataAvailable to Datasocket.connected
// 12 17 99 - KNA -  Entry requirement for List, NList loop added
// 05 17 99 - KNA -  Cancel for both data and control channel
// 12 02 98 - KNA -  FireWall Type added
// 10 21 98 - KNA -  Firewall added
// 10 19 98 - KNA -  PassiveMode added
// 10 13 98 - KNA -  OutPut Stream cleared on Abort
// 06 05 98 - KNA -  DirectoryList moved to pblic from published
// 05 07 98 - KNA -  OnConnectionFailed  added to Connect failure
// 03 31 98 - KNA -  Server side Disconnect 426 Handled
// 03 06 98 - KNA -  The Accepting socket closed
// 03 04 98 - KNA -  The Failure threshhold on password moved from 300 to 400
// 03 02 98 - KNA -  OnAuthenticationNeeded restored
// 02 25 98 - KNA -  The truncation on lists to handle Unix LF in add to CRLF
// 02 18 98 - KNA -  Clean up of control socket before connect
// 02 05 98 - KNA -  Strm crete and destroy in try finally loop for robustness
// 02 02 98 - KNA -  Linger reset On closing Datasocket in Upload
//                   prevent premature closing of Datasocket
// 01 27 98 - KNA -  Final release Ver 4.00 VCLS
//
unit NMFtp;
{$X+}
{$R-}

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

interface

uses
  SysUtils, WinProcs, Classes, PSock, Forms, WinSock, NMConst;
{$IFDEF VER110}
{$OBJEXPORTALL On}
{$ENDIF}
{$IFDEF VER120}
{$OBJEXPORTALL On}
{$ENDIF}
{$IFDEF VER125}
{$OBJEXPORTALL On}
{$ENDIF}

const

   {Transmission Type}
  MODE_ASCII = 1;
  MODE_IMAGE = 2;
  MODE_BYTE = 3;

   //  CompName     ='NMFTP';
   //  Major_Version='4';
   //  Minor_Version='02';
   //  Date_Version ='012798';

const {protocol}
  Cont_Quit = 'QUIT';
  Cont_User = 'USER ';
  Cont_Pass = 'PASS ';
  Cont_Cwd = 'CWD ';
  Cont_Rnfr = 'RNFR ';
  Cont_Rnto = 'RNTO ';
  Cont_Dele = 'DELE ';
  Cont_Mkd = 'MKD ';
  Cont_Rmd = 'RMD ';
  Cont_Port = 'PORT ';
  Cont_List = 'LIST';
  Cont_Nlst = 'NLST';
  Cont_Retr = 'RETR ';
  Cont_Stou = 'STOU';
  Cont_Stor = 'STOR ';
  Cont_Pwd = 'PWD';
  Cont_Typ = 'TYPE ';
  No_Byte = 'BYTE';
  Cont_Rein = 'REIN';
  Cont_Allo = 'ALLO ';
  Cont_Appe = 'APPE ';
  Cont_Rest = 'REST ';



const
  NMOS_UNKNOWN = -1;
  NMOS_FIRST = 2400;
  NMOS_UNIX = 2400;
  NMOS_WINDOWS = 2401;
  NMOS_VM = 2402;
  NMOS_BULL = 2403;
  NMOS_MAC = 2404;
  NMOS_TOPS20 = 2405;
  NMOS_VMS = 2406;
  NMOS_OS2 = 2407;
  NMOS_MVS_IBM = 2408;
  NMOS_MVS_INTERLINK = 2409;
  NMOS_OTHER = 2410;
  NMOS_AUTO = 2411;
  NMOS_NT = 2412;
  NMOS_TANDEM = 2413;
  NMOS_AS400 = 2414;
  NMOS_OS9 = 2415;
  NMOS_NETWARE = 2416;

type
  TFirewallType = (FTUser, FtOpen, FtSite);

  TFTPDirectoryList = class(TObject)
  private
    FAttribute, FName, FModifDate, FSize: TStringList;
    tokens: array[1..25] of shortstring;
    NoTokens: integer;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure ParseLine(Line: string); virtual;
    procedure Clear;
    property Attribute: TStringlist read FAttribute;
    property name: TStringlist read FName;
    property Size: TStringlist read FSize;
    property ModifDate: TStringlist read FModifDate;
  published

  end; {_ TFTPDirectoryList = class(TObject) _}

  TFTPUnixList = class(TFTPDirectoryList)
  public
    procedure ParseLine(Line: string); override;
  end; {_ TFTPUnixList = class(TFTPDirectoryList) _}

  TFTPNETWAREList = class(TFTPDirectoryList)
  public
    procedure ParseLine(Line: string); override;
  end; {_ TFTPNETWAREList = class(TFTPDirectoryList) _}

  TFTPDOSList = class(TFTPDirectoryList)
  public
    procedure ParseLine(Line: string); override;
  end; {_ TFTPDOSList = class(TFTPDirectoryList) _}
  TFTPVMSList = class(TFTPDirectoryList)
  public
    procedure ParseLine(Line: string); override;
  end; {_ TFTPVMSList = class(TFTPDirectoryList) _}
  TFTPMVSList = class(TFTPDirectoryList)
  public
    procedure ParseLine(Line: string); override;
  end; {_ TFTPMVSList = class(TFTPDirectoryList) _}
  TFTPVMList = class(TFTPDirectoryList)
  public
    procedure ParseLine(Line: string); override;
  end; {_ TFTPVMList = class(TFTPDirectoryList) _}
  TFTPMACOSList = class(TFTPDirectoryList)
  public
    procedure ParseLine(Line: string); override;
  end; {_ TFTPMACOSList = class(TFTPDirectoryList) _}
  TFTPAS400List = class(TFTPDirectoryList)
  public
    procedure ParseLine(Line: string); override;
  end; {_ TFTPAS400List = class(TFTPDirectoryList) _}
  TFTPOTHERList = class(TFTPDirectoryList)
  public
    procedure ParseLine(Line: string); override;
  end; {_ TFTPOTHERList = class(TFTPDirectoryList) _}

type


  TCmdType = (cmdChangeDir,
    cmdMakeDir,
    cmdDelete,
    cmdRemoveDir,
    cmdList,
    cmdRename,
    cmdUpRestore,
    cmdDownRestore,
    cmdDownload,
    cmdUpload,
    cmdAppend,
    cmdReInit,
    cmdAllocate,
    cmdNList,
    cmdDoCommand,
    cmdCurrentDir);

  FTPException = class(Exception); {FTP Exceptions}
  TFailureEvent = procedure(var Handled: Boolean; Trans_Type: TCmdType) of object;
  TSuccessEvent = procedure(Trans_Type: TCmdType) of object;
  TUnsupportedEvent = procedure(Trans_Type: TCmdType) of object;
  TNMListItem = procedure(Listing: string) of object;

   {*******************************************************************************************
   FTP Class Definition
   ********************************************************************************************}

  TNMFTP = class(TPowersock)
  private
    ProcessLock: TRTLCriticalSection;
    FUserID, FPassword: string; {Password and User ID strings}
    FPassive: boolean;
    DataSocket: TPowersock; {Socket for Data Transfers}
    FTransactionStart, FTransactionStop: TNotifyEvent; {Handler after each packet received for progress reports etc}
    FOnSuccess: TSuccessEvent;
    FOnFailure: TFailureEvent;
    FOnAuthenticationNeeded: THandlerEvent;
    FOnAuthenticationFailed: THandlerEvent;
    FOnListItem: TNMListItem;
    FOnConnect: TNotifyEvent;
    FOnUnSupportedFunction: TUnsupportedEvent;
    FVendor: integer;
    FFTPDirectoryList: TFTPDirectoryList;
    FParseList: boolean;
    FFirewallType: TFirewallType;
      // Added these 2 property containers to support user ID and password
      // with firewalls
    FFWUserID, FFWPassword: string;
      // Added FFWAuth property container for optional firewall authentication

    FFWAuth: Boolean;
    FListMask: string;
    function GetBytesRcvd: Longint;
    function GetBytesSent: Longint;
    function GetBytesTotal(Replymess: string): Longint;
    function Transaction(const CommandString: string): string; override;
    procedure CheckRead(Sender: TObject);
    function GetCurrentDir: string;
    procedure ReadExtraLines(Replymess: string);
    procedure Flush;
      { FTPStatus:TStringEvent ;  }
  protected
      { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure Connect; override;
    destructor Destroy; override;
    procedure Disconnect; override;
    procedure DoCommand(CommandStr: string);
    procedure ChangeDir(DirName: string);
    procedure Mode(TheMode: Integer);
    procedure Delete(Filename: string);
    procedure MakeDirectory(DirectoryName: string);
    procedure RemoveDir(DirectoryName: string);
    procedure List;
    procedure Rename(Filename, FileName2: string);
    procedure Download(RemoteFile, LocalFile: string);
    procedure DownloadRestore(RemoteFile, LocalFile: string);
    procedure Upload(LocalFile, RemoteFile: string);
    procedure UploadUnique(LocalFile: string);
    procedure UploadAppend(LocalFile, RemoteFile: string);
    procedure UploadRestore(LocalFile, RemoteFile: string; Position: Integer);
    procedure Reinitialize;
    procedure Allocate(FileSize: Integer);
    procedure Nlist;
    procedure Abort; override;
    property CurrentDir: string read GetCurrentDir;
    property BytesSent: Longint read GetBytesSent;
    property BytesRecvd: Longint read GetBytesRcvd;
    property FTPDirectoryList: TFTPDirectoryList read FFTPDirectoryList;
  published
    property OnPacketRecvd;
    property OnPacketSent;
    property OnError;
    property OnConnectionRequired;
    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
    property UserID: string read FUserID write FUserID;
    property Password: string read FPassword write FPassword;
    property OnTransactionStart: TNotifyEvent read FTransactionStart write FTransactionStart;
    property OnTransactionStop: TNotifyEvent read FTransactionStop write FTransactionStop;
    property OnAuthenticationNeeded: THandlerEvent read FOnAuthenticationNeeded write FOnAuthenticationNeeded;
    property OnAuthenticationFailed: THandlerEvent read FOnAuthenticationFailed write FOnAuthenticationFailed;
    property OnFailure: TFailureEvent read FOnFailure write FOnFailure;
    property OnSuccess: TSuccessEvent read FOnSuccess write FOnSuccess;
    property OnListItem: TNMListItem read FOnListItem write FOnListItem;
    property OnUnSupportedFunction: TUnsupportedEvent read FOnUnSupportedFunction write FOnUnSupportedFunction;
    property Vendor: integer read FVendor write FVendor;
    property ParseList: boolean read FParseList write FParseList;
    property Proxy;
    property ProxyPort;
    property Passive: boolean read FPassive write FPassive;
    property FirewallType: TFirewallType read FFirewallType write FFirewallType;
      // Added these 2 properties to support user ID and password with firewalls
    property FWUserID: string read FFWUserID write FFWUserID;
    property FWPassword: string read FFWPassword write FFWPassword;

// Added FWAuthenticate for optional firewall authentication
    property FWAuthenticate: Boolean read FFWAuth write FFWAuth;
    property ListMask: string read FListMask write FListMask;

  end; {_ TNMFTP            = class(TPowersock) _}

procedure Register;

implementation


{*******************************************************************************************
Register the  TNMFTP Component  in the internet pallette
********************************************************************************************}

procedure Register;
begin
  RegisterComponents(Cons_Palette_Inet, [TNMFTP]);
end; {_ procedure register; _}

constructor TFTPDirectoryList.Create;
begin
  inherited Create;
  FAttribute := TStringlist.create;
  FName := TStringlist.create;
  FModifDate := TStringlist.create;
  FSize := TStringlist.create;
end; {_ constructor TFTPDirectoryList.Create; _}

destructor TFTPDirectoryList.Destroy;
begin
  FAttribute.free;
  FModifDate.free;
  FName.free;
  FSize.free;
  inherited Destroy;
end; {_ destructor TFTPDirectoryList.Destroy; _}

procedure TFTPDirectoryList.ParseLine(Line: string);
var

  i, j: integer;

  procedure skipblanks;
  begin

    repeat
      inc(j)
    until (line[j] <> ' ') or (j > length(line));
  end; {_ repeat _}

begin
  for i := 1 to 25 do tokens[i] := ''; //clear tokens;
  i := 1;
  j := 1;
  tokens[1] := '';
  repeat
    if line[j] <> ' ' then
      begin
        tokens[i] := tokens[i] + line[j];
        inc(j)
      end {_ if line[i] <> ' ' then _}
    else {_ NOT if line[i] <> ' ' then _}
      begin
        inc(i);
        tokens[i] := '';
        skipblanks;
      end; {_ NOT if line[i] <> ' ' then _}

  until j > length(Line);
  NoTokens := i;


end; {_ procedure skipblanks; _}

procedure TFTPDirectoryList.Clear;
begin
  FAttribute.clear;
  FName.clear;
  FSize.clear;
  FModifDate.clear;
end; {_ procedure TFTPDirectoryList.Clear; _}


procedure TFTPUnixList.ParseLine(Line: string);
begin
  inherited ParseLine(Line);
  if NoTokens > 7 then
    begin
      FName.add(tokens[NoTokens]);
      FSize.add(tokens[NoTokens - 4]);
      FModifDate.add(tokens[NoTokens - 3] + ' ' + tokens[NoTokens - 2] + ' ' + tokens[NoTokens - 1]);
      FAttribute.add(tokens[1]);
    end; {_ if NoTokens > 7 then _}
end; {_ procedure TFTPUnixList.ParseLine(Line: string); _}

procedure TFTPNETWAREList.ParseLine(Line: string);
begin
  inherited ParseLine(Line);
  if NoTokens > 7 then
    begin
      FName.add(tokens[NoTokens - 1]);
      FSize.add(tokens[NoTokens - 5]);
      FModifDate.add(tokens[NoTokens - 4] + ' ' + tokens[NoTokens - 3] + ' ' + tokens[NoTokens - 2]);
      FAttribute.add(tokens[1]);
    end; {_ if NoTokens > 7 then _}
end; {_ procedure TFTPNETWAREList.ParseLine(Line: string); _}

procedure TFTPDOSList.ParseLine(Line: string);
begin
  inherited ParseLine(Line);
  if NoTokens > 7 then
    begin
      FName.add(tokens[NoTokens - 1]);
      FSize.add(tokens[NoTokens - 5]);
      FModifDate.add(tokens[NoTokens - 4] + ' ' + tokens[NoTokens - 3] + ' ' + tokens[NoTokens - 2]);
      FAttribute.add(tokens[1]);
    end; {_ if NoTokens > 7 then _}
end; {_ procedure TFTPDOSList.ParseLine(Line: string); _}

procedure TFTPVMSList.ParseLine(Line: string);
begin
  inherited ParseLine(Line);
  if NoTokens > 7 then
    begin
      FName.add(tokens[NoTokens - 1]);
      FSize.add(tokens[NoTokens - 5]);
      FModifDate.add(tokens[NoTokens - 4] + ' ' + tokens[NoTokens - 3] + ' ' + tokens[NoTokens - 2]);
      FAttribute.add(tokens[1]);
    end; {_ if NoTokens > 7 then _}
end; {_ procedure TFTPVMSList.ParseLine(Line: string); _}

procedure TFTPMVSList.ParseLine(Line: string);
begin
  inherited ParseLine(Line);
  if NoTokens > 7 then
    begin
      FName.add(tokens[NoTokens - 1]);
      FSize.add(tokens[NoTokens - 5]);
      FModifDate.add(tokens[NoTokens - 4] + ' ' + tokens[NoTokens - 3] + ' ' + tokens[NoTokens - 2]);
      FAttribute.add(tokens[1]);
    end; {_ if NoTokens > 7 then _}
end; {_ procedure TFTPMVSList.ParseLine(Line: string); _}

procedure TFTPVMList.ParseLine(Line: string);
begin
  inherited ParseLine(Line);
  if NoTokens > 7 then
    begin
      FName.add(tokens[NoTokens - 1]);
      FSize.add(tokens[NoTokens - 5]);
      FModifDate.add(tokens[NoTokens - 4] + ' ' + tokens[NoTokens - 3] + ' ' + tokens[NoTokens - 2]);
      FAttribute.add(tokens[1]);
    end; {_ if NoTokens > 7 then _}
end; {_ procedure TFTPVMList.ParseLine(Line: string); _}

procedure TFTPMACOSList.ParseLine(Line: string);
begin
  inherited ParseLine(Line);
  if NoTokens > 7 then
    begin
      FName.add(tokens[NoTokens - 1]);
      FSize.add(tokens[NoTokens - 5]);
      FModifDate.add(tokens[NoTokens - 4] + ' ' + tokens[NoTokens - 3] + ' ' + tokens[NoTokens - 2]);
      FAttribute.add(tokens[1]);
    end; {_ if NoTokens > 7 then _}
end; {_ procedure TFTPMACOSList.ParseLine(Line: string); _}

procedure TFTPAS400List.ParseLine(Line: string);
begin
  inherited ParseLine(Line);
  if NoTokens > 3 then
    begin
      if tokens[NoTokens][1] = '*' then
        FName.add(tokens[NoTokens])
      else FName.add(tokens[NoTokens - 1]);
      FAttribute.add(tokens[1]);
    end; {_ if NoTokens > 7 then _}
end; {_ procedure TFTPAS400List.ParseLine(Line: string); _}

procedure TFTPOTHERList.ParseLine(Line: string);
begin
  inherited ParseLine(Line);
  if NoTokens > 7 then
    begin
      FName.add(tokens[NoTokens]);
      FSize.add(tokens[NoTokens - 4]);
      FModifDate.add(tokens[NoTokens - 3] + ' ' + tokens[NoTokens - 2] + ' ' + tokens[NoTokens - 1]);
      FAttribute.add(tokens[1]);
    end; {_ if NoTokens > 7 then _}
end; {_ procedure TFTPOTHERList.ParseLine(Line: string); _}


{*******************************************************************************************
Initialize the  TNMFTP Component
********************************************************************************************}

constructor TNMFTP.Create;

begin
  inherited Create(AOwner); {Do Inherited create}
  Port := 21; {Set Default Port}
   {OnRead:=ProcessIdleRead;}{Set read functions for Asyncronous Reads}
  DataSocket := nil;
  FFTPDirectoryList := nil;
  FVendor := NMOS_AUTO;
  OnRead := CheckRead;
  InitializeCriticalSection(ProcessLock);
end; {_ constructor TNMFTP.Create; _}

destructor TNMFTP.Destroy;
begin
  Cancel;
  DeleteCriticalSection(ProcessLock);
 //  if Connected then Disconnect;
  if FFTPDirectoryList <> nil then
    FFTPDirectoryList.free;
  inherited Destroy;
end; {_ destructor TNMFTP.Destroy; _}

{*******************************************************************************************
Disconnect from server
********************************************************************************************}

procedure TNMFTP.Disconnect;
var
  Replymess: string;
begin
  BeenCanceled := False; {Reset Cancelled flag}
  if Connected then
      {If Connected}
    begin
      StatusMessage(Status_Informational, Cont_Quit); {Inform Status}
      try
        FFTPDirectoryList.free;
        FFTPDirectoryList := nil;
        FVendor := NMOS_AUTO;
        if DataAvailable then read(0);
        Replymess := Transaction(Cont_Quit); {Do a Quit transaction}
        if ((ReplyNumber > 300) and (ReplyNumber < 600))
          then raise FTPException.Create(Replymess); {If Error raise exception}
        CloseImmediate;
      finally
        inherited Disconnect; {Finally Disconnect}
      end {_ try _}
    end; {_ if Connected then _}
end; {_ procedure TNMFTP.Disconnect; _}

{*******************************************************************************************
Initialize a FTP connection
********************************************************************************************}

procedure TNMFTP.Connect;
var
  Replymess: string;
  Handled: boolean;

begin
  BeenCanceled := False; {Reset Cancelled flag}
  if not Connected then
      {If not already connected}
    begin
      ClearInput;
      inherited Connect; {Do the inherited connect}
      try
        Replymess := ' ';
        ReadExtraLines(Replymess);
        if ReplyNumber > 400 then
          begin
            if assigned(OnConnectionFailed) then OnConnectionFailed(self);
            raise FTPException.Create(Replymess); {If Error show exception}
          end;
         // Below this line added by Edward T. Smith 11/18/1998
// FFWUserID is the firewall user ID
        if FFWAuth then
          begin
            Replymess := Transaction(Cont_User + FFWUserID); {Send User Name and check result}
            if (ReplyNumber > 400) and (ReplyNumber < 600) then
              begin
                if assigned(OnConnectionFailed) then OnConnectionFailed(self);
                raise FTPException.Create(Replymess); {If Error show exception}
              end;
            if ReplyNumber = 331 then
              {If Password Needed}
              begin
                StatusMessage(Status_Informational, Cont_Pass); {Show outgoing Message} {Show Outgoing Message}
                Replymess := Transaction(Cont_Pass + FFWPassword); {Send Password and check result}
// FFWPassword is the firewall password
                if (ReplyNumber > 400) and (ReplyNumber < 600) then
                  begin
                    if assigned(OnConnectionFailed) then OnConnectionFailed(self);
                    raise FTPException.Create(Replymess); {If Error show exception}
                  end;
              end; {_ if ReplyNumber = 331 then _}
          end; // FIrewall Authentication

// Above this line added by Edward T. Smith 11/18/1998
        if (FUserID = '') or (Password = '') then
          if assigned(FOnAuthenticationNeeded) then FOnAuthenticationNeeded(Handled);
        if Proxy <> '' then
          begin
            case FFirewallType of
              ftUser: Replymess := Transaction('USER ' + USERID + '@' + Host);
              ftOpen: Replymess := Transaction('OPEN ' + Host);
              ftSite: Replymess := Transaction('SITE ' + Host);
            end;
          end;
        if (Proxy = '') or (FFirewallType <> ftUser) then
          begin
            StatusMessage(Status_Informational, Cont_User + UserID); {Show Outgoing message}
            Replymess := Transaction(Cont_User + UserID); {Send User Name and check result}
            if (ReplyNumber > 400) and (ReplyNumber < 600) then
              begin
                if assigned(OnConnectionFailed) then OnConnectionFailed(self);
                raise FTPException.Create(Replymess); {If Error show exception}
              end;
          end;
        if ReplyNumber = 331 then
            {If Password Needed}
          begin
            StatusMessage(Status_Informational, Cont_Pass); {Show outgoing Message} {Show Outgoing Message}
            Replymess := Transaction(Cont_Pass + Password); {Send Password and check result}
            if (ReplyNumber > 400) and (ReplyNumber < 600) then
              begin
                if assigned(OnConnectionFailed) then OnConnectionFailed(self);
                raise FTPException.Create(Replymess); {If Error show exception}
              end;
          end; {_ if ReplyNumber = 331 then _}
        if assigned(FOnConnect) then FOnConnect(self);
      except {If fault}
        if Connected then Disconnect; {Disconnect}
        StatusMessage(Status_Informational, sFTP_Msg_Disconnect); {Show Status}
        raise; {Show disconnected status}
      end; {_ try _}
    end; {_ if not Connected then _}
end; {_ procedure TNMFTP.Connect; _}
{*******************************************************************************************
Do a generic FTP Command
********************************************************************************************}

procedure TNMFTP.DoCommand(CommandStr: string);
var Replymess: string;
  Handled: Boolean;
  ThisCmd: TCmdType;
begin
  if NthWord(CommandStr, ' ', 1) + ' ' = Cont_Cwd then ThisCmd := cmdChangeDir
  else if NthWord(CommandStr, ' ', 1) + ' ' = Cont_Dele then ThisCmd := cmdDelete
  else if NthWord(CommandStr, ' ', 1) + ' ' = Cont_Mkd then ThisCmd := cmdMakeDir
  else if NthWord(CommandStr, ' ', 1) + ' ' = Cont_Rmd then ThisCmd := cmdRemoveDir
  else if CommandStr = Cont_Pwd then ThisCmd := cmdCurrentDir
  else {_ NOT if CommandStr = Cont_Pwd then ThisCmd := cmdCurrentDir _}  ThisCmd := cmdDoCommand;
  BeenCanceled := False; {Reset Cancelled flag}
  CertifyConnect;
  if Connected then
      {If connected}
    begin
      StatusMessage(Status_Informational, CommandStr); {Show Outgoing Message}
      if DataAvailable then read(0);
      Replymess := Transaction(CommandStr); {Send command and chectk result}
      if (ReplyNumber > 399) and (ReplyNumber < 600) then
        begin
          if assigned(FOnUnSupportedFunction) and (ReplyNumber >= 500) and (ReplyNumber <= 502) then FOnUnSupportedFunction(ThisCmd);
          if not assigned(FOnFailure) then raise FTPException.Create(Replymess)
            {Raise exception on errors}
          else {_ NOT if not assigned(FOnFailure) then raise FTPException.Create(Replymess) _}
            begin
              Handled := False;
              FOnFailure(Handled, ThisCmd);
              if not Handled then raise FTPException.Create(Replymess);
            {Raise exception on errors}
            end {_ NOT if not assigned(FOnFailure) then raise FTPException.Create(Replymess) _}
        end {_ if (ReplyNumber > 399) and (ReplyNumber < 600) then _}
      else if assigned(FOnSuccess) then FOnSuccess(ThisCmd);
    end; {_ if Connected then _}
end; {_ procedure TNMFTP.DoCommand(CommandStr: string); _}

{*******************************************************************************************
Change the Dirctory at remote host
********************************************************************************************}

procedure TNMFTP.ChangeDir(DirName: string);
begin
  DoCommand(Cont_Cwd + DirName); {Do Change Directory}
end; {_ procedure TNMFTP.ChangeDir(DirName: string); _}

{*******************************************************************************************
Rename  File in Remote Server
********************************************************************************************}


procedure TNMFTP.Rename(Filename, FileName2: string);
var
  Replymess: string;
  Handled: Boolean;
begin
  BeenCanceled := False; {Reset Cancelled flag}
  CertifyConnect;
  if Connected then
      {If connected}
    begin
      if DataAvailable then read(0);
      StatusMessage(Status_Informational, Cont_Rnfr + Filename); {Show Outgoing Message}
      Replymess := Transaction(Cont_Rnfr + Filename); {Send Rename from and check result}
      if (ReplyNumber > 351) and (ReplyNumber < 600) then
        if not assigned(FOnFailure) then raise FTPException.Create(Replymess)
            {Raise exception on errors}
        else {_ NOT if not assigned(FOnFailure) then raise FTPException.Create(Replymess) _}
          begin
            Handled := False;
            FOnFailure(Handled, cmdRename);
            if not Handled then raise FTPException.Create(Replymess);
            {Raise exception on errors}
          end; {_ NOT if not assigned(FOnFailure) then raise FTPException.Create(Replymess) _}
      StatusMessage(Status_Informational, Cont_Rnto + FileName2); {Show Outgoing Message}
      Replymess := Transaction(Cont_Rnto + FileName2); {Send Rename to and check result}
      if (ReplyNumber > 300) and (ReplyNumber < 600) then
        begin
          if assigned(FOnUnSupportedFunction) and (ReplyNumber >= 500) and (ReplyNumber <= 502) then FOnUnSupportedFunction(cmdRename);
          if not assigned(FOnFailure) then
            raise FTPException.Create(Replymess)
            {Raise exception on errors}
          else {_ NOT if not assigned(FOnFailure) then _}
            begin
              Handled := False;
              FOnFailure(Handled, cmdRename);
              if not Handled then
                raise FTPException.Create(Replymess);
            {Raise exception on errors}
            end {_ NOT if not assigned(FOnFailure) then _}
        end {_ if (ReplyNumber > 300) and (ReplyNumber < 600) then _}
      else if assigned(FOnSuccess) then FOnSuccess(cmdRename);
    end; {_ if Connected then _} {Resume Asynchronous Processing}
end; {_ procedure TNMFTP.Rename(Filename, FileName2: string); _}

{*******************************************************************************************
Delete file in remote server
********************************************************************************************}


procedure TNMFTP.Delete(Filename: string);

begin
  DoCommand(Cont_Dele + Filename); {Send Delete command and check result}
end; {_ procedure TNMFTP.Delete(Filename: string); _}

{*******************************************************************************************
Delete file in remote server
********************************************************************************************}

procedure TNMFTP.MakeDirectory(DirectoryName: string);

begin
  DoCommand(Cont_Mkd + DirectoryName); {Send Delete command and check result}
end; {_ procedure TNMFTP.MakeDirectory(DirectoryName: string); _}

{*******************************************************************************************
Delete file in remote server
********************************************************************************************}

procedure TNMFTP.RemoveDir(DirectoryName: string);
begin
  DoCommand(Cont_Rmd + DirectoryName); {Send Delete command and check result}
end; {_ procedure TNMFTP.RemoveDir(DirectoryName: string); _}


{*******************************************************************************************
Upload file to Remote Server with unique name
********************************************************************************************}

procedure TNMFTP.UploadUnique(LocalFile: string);
var
  Replymess: string;
  strm: TFileStream;
  Done, Handled: Boolean;
  Tsck: TSocket;
label CleanUp;
begin
  Done := False;
  BeenCanceled := False; {Reset Cancelled flag}
  CertifyConnect;
  if Connected then
      {If connected}
    begin
      DataSocket := TPowersock.Create(self); {Create a Data socket}
      DataSocket.TimeOut := TimeOut;
      try
        if DataAvailable then read(0);
        DataSocket.Timeout := Timeout;
        DataSocket.Port := 0; {Set Port to Zero}
        DataSocket.Listen(True); {Listen in the datasocket}
        strm := TFileStream.Create(LocalFile, fmOpenRead);
        try
          FBytesTotal := strm.Size;
        finally
          strm.Destroy;
        end; {_ try _}
        StatusMessage(Status_Informational, Cont_Port + GetLocalAddress + DataSocket.GetPortString); {Show Outgoing Message}
        Replymess := Transaction(Cont_Port + GetLocalAddress + DataSocket.GetPortString); {Send Port for data socket}
        if (ReplyNumber > 300) and (ReplyNumber < 600) then
          if not assigned(FOnFailure) then raise FTPException.Create(Replymess)
               {Raise exception on errors}
          else {_ NOT if not assigned(FOnFailure) then raise FTPException.Create(Replymess) _}
            begin
              Handled := False;
              FOnFailure(Handled, cmdUpload);
              if not Handled then raise FTPException.Create(Replymess)
              else goto Cleanup;
               {Raise exception on errors}
            end; {_ NOT if not assigned(FOnFailure) then raise FTPException.Create(Replymess) _}
        if assigned(FPacketSent) then
          DataSocket.OnPacketSent := FPacketSent; {Set function to handle data socket status}
        StatusMessage(Status_Informational, Cont_Stou); {Show Outgoing Message}
        Replymess := Transaction(Cont_Stou); {Give store unique cmmand}
        if (ReplyNumber > 300) and (ReplyNumber < 600) then
          begin
            if assigned(FOnUnSupportedFunction) and (ReplyNumber >= 500) and (ReplyNumber <= 502) then FOnUnSupportedFunction(cmdUpload);
            if not assigned(FOnFailure) then
              raise FTPException.Create(Replymess)
               {Raise exception on errors}
            else {_ NOT if not assigned(FOnFailure) then _}
              begin
                Handled := False;
                FOnFailure(Handled, cmdUpload);
                if not Handled then
                  raise FTPException.Create(Replymess)
                else goto Cleanup;
               {Raise exception on errors}
              end; {_ NOT if not assigned(FOnFailure) then _}
          end; {_ if (ReplyNumber > 300) and (ReplyNumber < 600) then _}
        Tsck := DataSocket.handle;
        DataSocket.ThisSocket := DataSocket.Accept; {Accept the datasocket}
        WinSock.CloseSocket(Tsck);
        if assigned(FTransactionStart) then FTransactionStart(self);
        if not (BeenCanceled or BeenTimedOut) then DataSocket.SendFile(LocalFile);
         {If no Local filename specified save file same as remote}
        if assigned(FTransactionStop) then FTransactionStop(self);
        DataSocket.RequestCloseSocket;
        if not (BeenCanceled or BeenTimedOut) then
          if DataAvailable then readln
          else {_ NOT if DataAvailable > 0 then read (0); _}  Replymess := sFTP_Cont_Msg_UpldS;
        StatusMessage(Status_Informational, Replymess);
        if not (BeenCanceled or BeenTimedOut) then ReadExtraLines(Replymess); {Read Extra Lines}
        Done := True;
        Cleanup:
      finally
        DataSocket.Destroy; {Destroy datasocket}
        DataSocket := nil;
        if Done then if assigned(FOnSuccess) then FOnSuccess(cmdUpload);
      end; {_ try _}
    end; {_ if Connected then _}
end; {_ procedure TNMFTP.UploadUnique(LocalFile: string); _}



{*******************************************************************************************
List Current Directory in Remote Server
********************************************************************************************}

procedure TNMFTP.List;
var
  Replymess: string;
  Success, Handled: Boolean;
  Tsck: TSocket;
label CleanUp;
begin
  EnterCriticalSection(ProcessLock);
  Success := False;
  BeenCanceled := False; {If there is a cancelled process reset it}
   //if Fabort then
   //  begin
   //    ReplyMess:= transaction('ABOR');
   //    Fabort := False;
   //  end;

  CertifyConnect; {Make sure Connection exists}
  if Connected then
    begin
      if DataAvailable then read(0);
      DataSocket := TPowersock.Create(self); {Create a Data socket}
      DataSocket.TimeOut := TimeOut;
      if assigned(FPacketRecvd) then
        DataSocket.OnPacketRecvd := FPacketRecvd; {Set function to handle data socket status}
      if FParseList then
        begin
          if FFTPDirectoryList = nil then
            begin
              if Vendor = NMOS_AUTO then
                begin
                  try DoCommand('SYST')except end;
                  if (Pos('UNIX', TransactionReply) > 0) then
                    FVendor := NMOS_UNIX
                  else if (Pos('NETWARE', TransactionReply) > 0) then
                    FVendor := NMOS_NETWARE
                  else if (Pos('DOS', TransactionReply) > 0) then
                    FVendor := NMOS_WINDOWS
                  else if (Pos('VMS', TransactionReply) > 0) then
                    FVendor := NMOS_VMS
                  else if (Pos('MVS', TransactionReply) > 0) then
                    FVendor := NMOS_MVS_IBM
                  else if (Pos('VM', TransactionReply) > 0) then
                    FVendor := NMOS_VM
                  else if (Pos('MACOS', TransactionReply) > 0) then
                    FVendor := NMOS_MAC
                  else if (Pos('OS/400', TransactionReply) > 0) then
                    FVendor := NMOS_AS400
                  else {_ NOT if (Pos('OS/400', TransactionReply) > 0) then _}
                    FVendor := NMOS_OTHER;
                end; {_ if Vendor = NMOS_AUTO then _}
              case FVendor of
                NMOS_UNIX: FFTPDirectoryList := TFTPUnixList.create;
                NMOS_NETWARE: FFTPDirectoryList := TFTPUnixList.create;
                NMOS_WINDOWS: FFTPDirectoryList := TFTPUnixList.create;
                NMOS_VMS: FFTPDirectoryList := TFTPUnixList.create;
                NMOS_MVS_IBM: FFTPDirectoryList := TFTPUnixList.create;
                NMOS_VM: FFTPDirectoryList := TFTPUnixList.create;
                NMOS_MAC: FFTPDirectoryList := TFTPUnixList.create;
                NMOS_AS400: FFTPDirectoryList := TFTPUnixList.create;
                NMOS_OTHER: FFTPDirectoryList := TFTPUnixList.create;
              end; {_ case FVendor of _}
            end; {_ if FFTPDirectoryList <> nil then _}
          FFTPDirectoryList.clear;
        end; {_ if FParseList then _}
      DataSocket.TimeOut := TimeOut;

      try
        if FPassive then
          begin
            ReplyMess := Transaction('PASV');
            if (ReplyNumber > 499) then
              if not assigned(FOnFailure) then
                raise FTPException.Create(Replymess)
              else
                begin
                  Handled := False;
                  FOnFailure(Handled, cmdList);
                  if not Handled then
                    raise FTPException.Create(Replymess)
                  else goto CleanUp;
                              {Raise exception on errors}
                end; {_ NOT if not assigned(FOnFailure) then _}
            DataSocket.Port := StrToInt(Copy(NthWord(replyMess, ',', 6), 1, Pos(')', NthWord(replyMess, ',', 6)) - 1)) + (256 * StrToInt(NthWord(replyMess, ',', 5)));
            DataSocket.Host := Host;
            DataSocket.connect;
          end
        else { _FPassive_ }
          begin
            DataSocket.Port := 0; {Set Port to Zero}
            DataSocket.Listen(True); {Listen in the datasocket}
            Replymess := Transaction(Cont_Port + GetLocalAddress + DataSocket.GetPortString); {Send Port for data socket}
            if (ReplyNumber > 300) and (ReplyNumber < 600) then
              if not assigned(FOnFailure) then
                raise FTPException.Create(Replymess)
                        {Raise exception on errors}
              else {_ NOT if not assigned(FOnFailure) then _}
                begin
                  Handled := False;
                  FOnFailure(Handled, cmdList);
                  if not Handled then
                    raise FTPException.Create(Replymess)
                  else goto CleanUp;
                           {Raise exception on errors}
                end; {_ NOT if not assigned(FOnFailure) then _}

          end { not _FPassive_ };
        StatusMessage(Status_Informational, Cont_List); {Show Outgoing Message}
        if FListMask = '' then Replymess := Transaction(Cont_List)
        else Replymess := Transaction(Cont_List + ' ' + FListMask); {Send List command}
        if (ReplyNumber > 300) and (ReplyNumber < 600) then
          begin
            if assigned(FOnUnSupportedFunction) and (ReplyNumber >= 500) and (ReplyNumber <= 502) then FOnUnSupportedFunction(cmdList);
            if not assigned(FOnFailure) then
              raise FTPException.Create(Replymess)
                    {Raise exception on errors}
            else {_ NOT if not assigned(FOnFailure) then _}
              begin
                Handled := False;
                FOnFailure(Handled, cmdList);
                if not Handled then
                  raise FTPException.Create(Replymess)
                else goto CleanUp;
                  {Raise exception on errors}
              end; {_ NOT if not assigned(FOnFailure) then _}
          end; {_ if (ReplyNumber > 300) and (ReplyNumber < 600) then _}
        if not FPassive then
          begin
            Tsck := DataSocket.handle;
            DataSocket.ThisSocket := DataSocket.Accept; {Accept the datasocket}
            WinSock.CloseSocket(Tsck);
          end;
        if assigned(FTransactionStart) then FTransactionStart(self);
        while not (BeenCanceled or BeenTimedOut or DataSocket.DataAvailable) and DataSocket.Connected do
          DataSocket.wait;
        if not (BeenCanceled or BeenTimedOut) then
          repeat
            if DataSocket.DataAvailable then
              begin
                Replymess := DataSocket.readln;
                if (Replymess = '') then break;
                if Length(Replymess) > 2 then
                  if Replymess[Length(Replymess) - 1] = #13 then
                    SetLength(Replymess, Length(Replymess) - 2)
                  else
                    SetLength(Replymess, Length(Replymess) - 1);
                if FParseList then
                  FFTPdirectoryList.ParseLine(Replymess);
                if assigned(FOnListItem) then FOnListItem(Replymess);
              end
            else
              DataSocket.Wait; //Application.ProcessMessages;
          until (((not DataSocket.Connected) or DataAvailable) and (not DataSocket.DataAvailable)) or BeenTimedOut or BeenCanceled;
        if assigned(FTransactionStop) then FTransactionStop(self);
        if DataSocket.Connected then DataSocket.RequestCloseSocket;
        if not (BeenCanceled or BeenTimedOut) then
          Replymess := readln;
        if ReplyMess = '' then ReplyMess := '226 Data Transfer successful';
        StatusMessage(Status_Informational, Replymess);
        if not (BeenCanceled or BeenTimedOut) then ReadExtraLines(Replymess); {Read Extra Lines}
        Success := True;
        CleanUp:
      finally
        DataSocket.Destroy; { _Destroy datasocket_ }
        DataSocket := nil;
        if BeenCanceled then
          begin
            BeenCanceled := False;
            ReplyMess := Transaction('ABOR');
          end;
        LeaveCriticalSection(ProcessLock);
        if Success then if assigned(FOnSuccess) then FOnSuccess(cmdList);
      end {_ try _}
    end; { _Connected_ }
end;

{*******************************************************************************************
Upload a file to a Remote Server
********************************************************************************************}

procedure TNMFTP.Upload(LocalFile, RemoteFile: string);
var
  Replymess: string;
  strm: TFileStream;
  Success, Handled: Boolean;
  Tsck: TSocket;
label CleanUp;
begin
  try
    Success := False;
    BeenCanceled := False; {If there is a cancelled process reset it}
    CertifyConnect; {Make sure Connection exists}
    if Connected then
      begin
        EnterCriticalSection(ProcessLock);
        if DataAvailable then read(0);
        DataSocket := TPowersock.Create(self); {Create a Data socket}
        DataSocket.TimeOut := TimeOut;
        strm := TFileStream.Create(LocalFile, fmOpenRead);
        DataSocket.TimeOut := TimeOut;
        if assigned(FPacketSent) then
          DataSocket.OnPacketSent := FPacketSent; {Set function to handle data socket status}
        try
          FBytesTotal := strm.Size;
        finally
          strm.Destroy;
        end; {_ try _}
        try
          if FPassive then
            begin
              ReplyMess := Transaction('PASV');
              if (ReplyNumber > 499) then
                if not assigned(FOnFailure) then
                  raise FTPException.Create(Replymess)
                else
                  begin
                    Handled := False;
                    FOnFailure(Handled, cmdUpload);
                    if not Handled then
                      raise FTPException.Create(Replymess)
                    else goto CleanUp;
                              {Raise exception on errors}
                  end; {_ NOT if not assigned(FOnFailure) then _}
              DataSocket.Port := StrToInt(Copy(NthWord(replyMess, ',', 6), 1, Pos(')', NthWord(replyMess, ',', 6)) - 1)) + (256 * StrToInt(NthWord(replyMess, ',', 5)));
              DataSocket.Host := Host;
              DataSocket.connect;
            end
          else { _FPassive_ }
            begin
              DataSocket.Port := 0; {Set Port to Zero}
              DataSocket.Listen(True); {Listen in the datasocket}
              Replymess := Transaction(Cont_Port + GetLocalAddress + DataSocket.GetPortString); {Send Port for data socket}
              if (ReplyNumber > 300) and (ReplyNumber < 600) then
                if not assigned(FOnFailure) then
                  raise FTPException.Create(Replymess)
                        {Raise exception on errors}
                else {_ NOT if not assigned(FOnFailure) then _}
                  begin
                    Handled := False;
                    FOnFailure(Handled, cmdUpload);
                    if not Handled then
                      raise FTPException.Create(Replymess)
                    else goto CleanUp;
                           {Raise exception on errors}
                  end; {_ NOT if not assigned(FOnFailure) then _}

            end { not _FPassive_ };
          if RemoteFile = '' then
            begin
              StatusMessage(Status_Informational, Cont_Stor + LocalFile); {Show Outgoing Message}
              Replymess := Transaction(Cont_Stor + ExtractFileName(LocalFile)) {Give store unique cmmand}
            end {_ if RemoteFile = '' then _}
          else {_ NOT if RemoteFile = '' then _}
            begin
              StatusMessage(Status_Informational, Cont_Stor + RemoteFile); {Show Outgoing Message}
              Replymess := Transaction(Cont_Stor + RemoteFile); {Give store unique cmmand}
            end; {_ NOT if RemoteFile = '' then _}
          if (ReplyNumber > 300) and (ReplyNumber < 600) then
            begin
              if assigned(FOnUnSupportedFunction) and (ReplyNumber >= 500) and (ReplyNumber <= 502) then FOnUnSupportedFunction(cmdUpload);
              if not assigned(FOnFailure) then
                raise FTPException.Create(Replymess)
                    {Raise exception on errors}
              else {_ NOT if not assigned(FOnFailure) then _}
                begin
                  Handled := False;
                  FOnFailure(Handled, cmdUpload);
                  if not Handled then
                    raise FTPException.Create(Replymess)
                  else goto CleanUp;
                     {Raise exception on errors}
                end; {_ NOT if not assigned(FOnFailure) then _}
            end; {_ if (ReplyNumber > 300) and (ReplyNumber < 600) then _}
          if not FPassive then
            begin
              Tsck := DataSocket.handle;
              DataSocket.ThisSocket := DataSocket.Accept; {Accept the datasocket}
              WinSock.CloseSocket(Tsck);
            end;
          if assigned(FTransactionStart) then FTransactionStart(self);
          DataSocket.CloseAfterData;
          if not (BeenCanceled or BeenTimedOut) then DataSocket.SendFile(LocalFile);
            {If no Local filename specified save file same as remote}
          if assigned(FTransactionStop) then FTransactionStop(self);
          WinSock.CloseSocket(DataSocket.ThisSocket);
          Replymess := readln;
          if ReplyMess = '' then ReplyMess := '226 Data Transfer successful';
          StatusMessage(Status_Informational, Replymess);
          if not (BeenCanceled or BeenTimedOut) then ReadExtraLines(Replymess); {Read Extra Lines}
          Success := True;
          CleanUp:
        finally
          DataSocket.Destroy; { _Destroy datasocket_ }
          DataSocket := nil;
          LeaveCriticalSection(ProcessLock);
          if Success then if assigned(FOnSuccess) then FOnSuccess(cmdUpload);

        end {_ try _}
      end; { _Connected_ }
  except
    Handled := False;
    FOnFailure(Handled, cmdUpload);
    if not Handled then
      raise;
  end;
end;

{*******************************************************************************************
Upload a file to a Remote Server
********************************************************************************************}

procedure TNMFTP.UploadRestore(LocalFile, RemoteFile: string; Position: Integer);
var
  Replymess: string;
  strm: TFileStream;
  Success, Handled: Boolean;
  Tsck: TSocket;
  gudtLinger: Tlinger;
label CleanUp;

begin
  Success := False;
  BeenCanceled := False; {If there is a cancelled process reset it}
  CertifyConnect; {Make sure Connection exists}
  if Connected then
    begin
      if DataAvailable then read(0);
      DataSocket := TPowersock.Create(self); {Create a Data socket}
      DataSocket.TimeOut := TimeOut;
      strm := TFileStream.Create(LocalFile, fmOpenRead);
      DataSocket.TimeOut := TimeOut;
      if assigned(FPacketSent) then
        DataSocket.OnPacketSent := FPacketSent; {Set function to handle data socket status}
      try
        FBytesTotal := strm.Size;
      finally
        strm.Destroy;
      end; {_ try _}
      try
        if FPassive then
          begin
            ReplyMess := Transaction('PASV');
            if (ReplyNumber > 499) then
              if not assigned(FOnFailure) then
                raise FTPException.Create(Replymess)
              else
                begin
                  Handled := False;
                  FOnFailure(Handled, cmdUpload);
                  if not Handled then
                    raise FTPException.Create(Replymess)
                  else goto CleanUp;
                              {Raise exception on errors}
                end; {_ NOT if not assigned(FOnFailure) then _}
            DataSocket.Port := StrToInt(Copy(NthWord(replyMess, ',', 6), 1, Pos(')', NthWord(replyMess, ',', 6)) - 1)) + (256 * StrToInt(NthWord(replyMess, ',', 5)));
            DataSocket.Host := Host;
            DataSocket.connect;
          end
        else { _FPassive_ }
          begin
            DataSocket.Port := 0; {Set Port to Zero}
            DataSocket.Listen(True); {Listen in the datasocket}
            Replymess := Transaction(Cont_Port + GetLocalAddress + DataSocket.GetPortString); {Send Port for data socket}
            if (ReplyNumber > 300) and (ReplyNumber < 600) then
              if not assigned(FOnFailure) then
                raise FTPException.Create(Replymess)
                        {Raise exception on errors}
              else {_ NOT if not assigned(FOnFailure) then _}
                begin
                  Handled := False;
                  FOnFailure(Handled, cmdUpload);
                  if not Handled then
                    raise FTPException.Create(Replymess)
                  else goto CleanUp;
                           {Raise exception on errors}
                end; {_ NOT if not assigned(FOnFailure) then _}

          end { not _FPassive_ };
        if RemoteFile = '' then
          begin
            StatusMessage(Status_Informational, Cont_Rest + IntToStr(Position) + '' + Cont_stor); {Show Outgoing Message}
            Replymess := Transaction(Cont_Rest + IntToStr(Position));
            Replymess := Transaction(Cont_stor + ExtractFileName(LocalFile)); {Give store unique cmmand}
          end {_ if RemoteFile = '' then _}
        else {_ NOT if RemoteFile = '' then _}
          begin
            StatusMessage(Status_Informational, Cont_Rest + IntToStr(Position) + '' + Cont_stor); {Show Outgoing Message}
            Replymess := Transaction(Cont_Rest + IntToStr(Position));
            Replymess := Transaction(Cont_stor + RemoteFile); {Give store unique cmmand}
          end; {_ NOT if RemoteFile = '' then _}
        if (ReplyNumber > 399) and (ReplyNumber < 600) then
          begin
            if assigned(FOnUnSupportedFunction) and (ReplyNumber >= 500) and (ReplyNumber <= 502) then FOnUnSupportedFunction(cmdUpload);
            if not assigned(FOnFailure) then
              raise FTPException.Create(Replymess)
                    {Raise exception on errors}
            else {_ NOT if not assigned(FOnFailure) then _}
              begin
                Handled := False;
                FOnFailure(Handled, cmdUpload);
                if not Handled then
                  raise FTPException.Create(Replymess)
                else goto CleanUp;
                     {Raise exception on errors}
              end; {_ NOT if not assigned(FOnFailure) then _}
          end; {_ if (ReplyNumber > 300) and (ReplyNumber < 600) then _}
        if not FPassive then
          begin
            Tsck := DataSocket.handle;
            DataSocket.ThisSocket := DataSocket.Accept; {Accept the datasocket}
            WinSock.CloseSocket(Tsck);
          end;
        if assigned(FTransactionStart) then FTransactionStart(self);
        Strm := TFileStream.Create(LocalFile, fmOpenRead);
        Strm.Position := Position;
        try
          if not (BeenCanceled or BeenTimedOut)
            then DataSocket.SendRestStream(Strm);
        finally
          Strm.free;
        end;
            {If no Local filename specified save file same as remote}
        if assigned(FTransactionStop) then FTransactionStop(self);
        gudtLinger.l_onoff := 0;
        gudtLinger.l_linger := 0;
        setsockopt(DataSocket.ThisSocket, SOL_SOCKET, SO_LINGER, @gudtLinger, 4);
        DataSocket.RequestCloseSocket;
        if not (BeenCanceled or BeenTimedOut) then
          Replymess := read(0);
        if ReplyMess = '' then ReplyMess := '226 Data Transfer successful';
        StatusMessage(Status_Informational, Replymess);
        if not (BeenCanceled or BeenTimedOut) then ReadExtraLines(Replymess); {Read Extra Lines}
        Success := True;
        CleanUp:
      finally
        DataSocket.Destroy; { _Destroy datasocket_ }
        DataSocket := nil;
        if Success then if assigned(FOnSuccess) then FOnSuccess(cmdUpload);
      end {_ try _}
    end; { _Connected_ }
end;

{*******************************************************************************************
Download a file from a Remote Server
********************************************************************************************}

procedure TNMFTP.Download(RemoteFile, LocalFile: string);
var
  Replymess: string;
  Success, Handled: Boolean;
  Tsck: TSocket;
label CleanUp;
begin
  try
    Success := False;
    BeenCanceled := False; {If there is a cancelled process reset it}
    CertifyConnect; {Make sure Connection exists}
    if Connected then
      begin
        EnterCriticalSection(ProcessLock);
        if DataAvailable then read(0);
        DataSocket := TPowersock.Create(self); {Create a Data socket}
        DataSocket.TimeOut := TimeOut;
        if assigned(FPacketRecvd) then
          DataSocket.OnPacketRecvd := FPacketRecvd; {Set function to handle data socket status}
        try
          if FPassive then
            begin
              ReplyMess := Transaction('PASV');
              if (ReplyNumber > 499) then
                if not assigned(FOnFailure) then
                  raise FTPException.Create(Replymess)
                else
                  begin
                    Handled := False;
                    FOnFailure(Handled, cmdDownLoad);
                    if not Handled then
                      raise FTPException.Create(Replymess)
                    else goto CleanUp;
                              {Raise exception on errors}
                  end; {_ NOT if not assigned(FOnFailure) then _}
              DataSocket.Port := StrToInt(Copy(NthWord(replyMess, ',', 6), 1, Pos(')', NthWord(replyMess, ',', 6)) - 1)) + (256 * StrToInt(NthWord(replyMess, ',', 5)));
              DataSocket.Host := Host;
              DataSocket.connect;
            end
          else { _FPassive_ }
            begin
              DataSocket.Port := 0; {Set Port to Zero}
              DataSocket.Listen(True); {Listen in the datasocket}
              Replymess := Transaction(Cont_Port + GetLocalAddress + DataSocket.GetPortString); {Send Port for data socket}
              if (ReplyNumber > 300) and (ReplyNumber < 600) then
                if not assigned(FOnFailure) then
                  raise FTPException.Create(Replymess)
                        {Raise exception on errors}
                else {_ NOT if not assigned(FOnFailure) then _}
                  begin
                    Handled := False;
                    FOnFailure(Handled, cmdDownload);
                    if not Handled then
                      raise FTPException.Create(Replymess)
                    else goto CleanUp;
                           {Raise exception on errors}
                  end; {_ NOT if not assigned(FOnFailure) then _}

            end { not _FPassive_ };
          StatusMessage(Status_Informational, Cont_Retr + RemoteFile); {Show Outgoing Message}
          FBytesTotal := 0;
          Replymess := inherited Transaction(Cont_Retr + RemoteFile);
          if (ReplyNumber > 300) and (ReplyNumber < 600) then
            if not assigned(FOnFailure) then raise FTPException.Create(Replymess)
               {Raise exception on errors}
            else {_ NOT if not assigned(FOnFailure) then raise FTPException.Create(Replymess) _}
              begin
                Handled := False;
                FOnFailure(Handled, cmdDownload);
                if not Handled then raise FTPException.Create(Replymess)
                else goto CleanUp;
                     {Raise exception on errors}
              end; {_ NOT if not assigned(FOnFailure) then raise FTPException.Create(Replymess) _}
          FBytesTotal := GetBytesTotal(Replymess);
          while (Replymess[1] = ' ') or (Replymess[4] = '-') do
            begin
              Replymess := readln; {Handle Extra Lines}
              StatusMessage(Status_Informational, Replymess); {Show Received Lines}
              if FBytesTotal = 0 then FBytesTotal := GetBytesTotal(Replymess);
              if (ReplyNumber > 300) and (ReplyNumber < 600) then
                begin
                  if assigned(FOnUnSupportedFunction) and (ReplyNumber >= 500) and (ReplyNumber <= 502) then FOnUnSupportedFunction(cmdDownload);
                  if not assigned(FOnFailure) then
                    raise FTPException.Create(Replymess)
                  {Raise exception on errors}
                  else {_ NOT if not assigned(FOnFailure) then _}
                    begin
                      Handled := False;
                      FOnFailure(Handled, cmdDownload);
                      if not Handled then
                        raise FTPException.Create(Replymess);
                     {Raise exception on errors}
                    end; {_ NOT if not assigned(FOnFailure) then _}
                end; {_ if (ReplyNumber > 300) and (ReplyNumber < 600) then _}
            end; {_ while (Replymess[1] = ' ') or (Replymess[4] = '-') do _}
          if not FPassive then
            begin
              Tsck := DataSocket.handle;
              DataSocket.ThisSocket := DataSocket.Accept; {Accept the datasocket}
              WinSock.CloseSocket(Tsck);
            end;
          FBytesTotal := GetBytesTotal(Replymess);
          if assigned(FTransactionStart) then FTransactionStart(self);
          if not (BeenCanceled or BeenTimedOut) then
            if LocalFile = '' then DataSocket.CaptureFile(RemoteFile)
               {If no Local filename specified save file same as remote}
            else {_ NOT if LocalFile = '' then DataSocket.CaptureFile(RemoteFile) _}  DataSocket.CaptureFile(LocalFile); {If Local filename specified save file under it}
          if assigned(FTransactionStop) then FTransactionStop(self);
          DataSocket.RequestCloseSocket;
          FBytesTotal := DataSocket.BytesRecvd;
          StatusMessage(Status_Informational, (sFTP_Msg_Recvd + IntToStr(BytesTotal) + sFTP_No_Bytes));
          if not (BeenCanceled or BeenTimedOut) then Replymess := readln;
            //if ReplyMess='' then ReplyMess:='226 Data Transfer successful';
          StatusMessage(Status_Informational, Replymess);
          if not (BeenCanceled or BeenTimedOut) then ReadExtraLines(Replymess);
            {Read Extra Lines}
            {If no Local filename specified save file same as remote}
          if assigned(FTransactionStop) then FTransactionStop(self);
          Success := True;
          CleanUp:
        finally
          DataSocket.Destroy; { _Destroy datasocket_ }
          DataSocket := nil;
          if BeenCanceled then
            begin
              BeenCanceled := False;
              ReplyMess := Transaction('ABOR');
            end;
          if Success then if assigned(FOnSuccess) then FOnSuccess(cmdDownload);
        end {_ try _}
      end; { _Connected_ }
  except
    Handled := False;
    FOnFailure(Handled, cmdDownload);
    if not Handled then
      raise;
  end;
end;

{*******************************************************************************************
Download a file from a Remote Server
********************************************************************************************}

procedure TNMFTP.DownloadRestore(RemoteFile, LocalFile: string);
var
  Replymess: string;
  Success, Handled: Boolean;
  AFileStream: TFileStream;
  Posn: Integer;
  Tsck: TSocket;
label CleanUp;
begin
  Success := False;
  BeenCanceled := False; {If there is a cancelled process reset it}
  CertifyConnect; {Make sure Connection exists}
  if Connected then
    begin
      if DataAvailable then read(0);
      DataSocket := TPowersock.Create(self); {Create a Data socket}
      DataSocket.TimeOut := TimeOut;
      if Localfile = '' then LocalFile := RemoteFile;
      if assigned(FPacketRecvd) then
        DataSocket.OnPacketRecvd := FPacketRecvd; {Set function to handle data socket status}
      try
        if FPassive then
          begin
            ReplyMess := Transaction('PASV');
            if (ReplyNumber > 499) then
              if not assigned(FOnFailure) then
                raise FTPException.Create(Replymess)
              else
                begin
                  Handled := False;
                  FOnFailure(Handled, cmdDownLoad);
                  if not Handled then
                    raise FTPException.Create(Replymess)
                  else goto CleanUp;
                              {Raise exception on errors}
                end; {_ NOT if not assigned(FOnFailure) then _}
            DataSocket.Port := StrToInt(Copy(NthWord(replyMess, ',', 6), 1, Pos(')', NthWord(replyMess, ',', 6)) - 1)) + (256 * StrToInt(NthWord(replyMess, ',', 5)));
            DataSocket.Host := Host;
            DataSocket.connect;
          end
        else { _FPassive_ }
          begin
            DataSocket.Port := 0; {Set Port to Zero}
            DataSocket.Listen(True); {Listen in the datasocket}
            Replymess := Transaction(Cont_Port + GetLocalAddress + DataSocket.GetPortString); {Send Port for data socket}
            if (ReplyNumber > 300) and (ReplyNumber < 600) then
              if not assigned(FOnFailure) then
                raise FTPException.Create(Replymess)
                        {Raise exception on errors}
              else {_ NOT if not assigned(FOnFailure) then _}
                begin
                  Handled := False;
                  FOnFailure(Handled, cmdDownload);
                  if not Handled then
                    raise FTPException.Create(Replymess)
                  else goto CleanUp;
                           {Raise exception on errors}
                end; {_ NOT if not assigned(FOnFailure) then _}

          end { not _FPassive_ };
        try
          AFileStream := TFileStream.Create(LocalFile, fmOpenRead); {If Local filename specified save file under it}
          Posn := AFileStream.Size;
          AFileStream.Free;
        except
          Posn := 0;
        end;
        StatusMessage(Status_Informational, Cont_Rest + Cont_Retr + RemoteFile); {Show Outgoing Message}
        FBytesTotal := 0;
        Replymess := inherited Transaction(Cont_Rest + IntToStr(Posn));
        Replymess := inherited Transaction(Cont_Retr + RemoteFile);
        if (ReplyNumber > 300) and (ReplyNumber < 600) then
          if not assigned(FOnFailure) then raise FTPException.Create(Replymess)
               {Raise exception on errors}
          else {_ NOT if not assigned(FOnFailure) then raise FTPException.Create(Replymess) _}
            begin
              Handled := False;
              FOnFailure(Handled, cmdDownload);
              if not Handled then raise FTPException.Create(Replymess);
                     {Raise exception on errors}
            end; {_ NOT if not assigned(FOnFailure) then raise FTPException.Create(Replymess) _}
        FBytesTotal := GetBytesTotal(Replymess);
        while (Replymess[1] = ' ') or (Replymess[4] = '-') do
          begin
            Replymess := readln; {Handle Extra Lines}
            StatusMessage(Status_Informational, Replymess); {Show Received Lines}
            if FBytesTotal = 0 then FBytesTotal := GetBytesTotal(Replymess);
            if (ReplyNumber > 300) and (ReplyNumber < 600) then
              begin
                if assigned(FOnUnSupportedFunction) and (ReplyNumber >= 500) and (ReplyNumber <= 502) then FOnUnSupportedFunction(cmdDownload);
                if not assigned(FOnFailure) then
                  raise FTPException.Create(Replymess)
                  {Raise exception on errors}
                else {_ NOT if not assigned(FOnFailure) then _}
                  begin
                    Handled := False;
                    FOnFailure(Handled, cmdDownload);
                    if not Handled then
                      raise FTPException.Create(Replymess);
                     {Raise exception on errors}
                  end; {_ NOT if not assigned(FOnFailure) then _}
              end; {_ if (ReplyNumber > 300) and (ReplyNumber < 600) then _}
          end; {_ while (Replymess[1] = ' ') or (Replymess[4] = '-') do _}
        if not FPassive then
          begin
            Tsck := DataSocket.handle;
            DataSocket.ThisSocket := DataSocket.Accept; {Accept the datasocket}
            WinSock.CloseSocket(Tsck);
          end;
        FBytesTotal := GetBytesTotal(Replymess);
        if assigned(FTransactionStart) then FTransactionStart(self);
        if not (BeenCanceled or BeenTimedOut) then
          if LocalFile = '' then DataSocket.AppendFile(RemoteFile)
               {If no Local filename specified save file same as remote}
          else {_ NOT if LocalFile = '' then DataSocket.CaptureFile(RemoteFile) _}  DataSocket.AppendFile(LocalFile); {If Local filename specified save file under it}
        if assigned(FTransactionStop) then FTransactionStop(self);
        DataSocket.RequestCloseSocket;
        FBytesTotal := DataSocket.BytesRecvd;
        StatusMessage(Status_Informational, (sFTP_Msg_Recvd + IntToStr(BytesTotal) + sFTP_No_Bytes));
        if not (BeenCanceled or BeenTimedOut) then Replymess := read(0);
        if ReplyMess = '' then ReplyMess := '226 Data Transfer successful';
        StatusMessage(Status_Informational, Replymess);
        if not (BeenCanceled or BeenTimedOut) then ReadExtraLines(Replymess);
            {Read Extra Lines}
            {If no Local filename specified save file same as remote}
        if assigned(FTransactionStop) then FTransactionStop(self);
        Success := True;
        CleanUp:
      finally
        DataSocket.Destroy; { _Destroy datasocket_ }
        DataSocket := nil;
        if BeenCanceled then
          begin
            BeenCanceled := False;
            ReplyMess := Transaction('ABOR');
          end;
        if Success then if assigned(FOnSuccess) then FOnSuccess(cmdDownload);
      end {_ try _}
    end; { _Connected_ }
end;


{*******************************************************************************************
Upload a file to a Remote Server  and append to existing file
********************************************************************************************}

procedure TNMFTP.UploadAppend(LocalFile, RemoteFile: string);
var
  Replymess: string;
  strm: TFileStream;
  Success, Handled: Boolean;
  Tsck: TSocket;
label CleanUp;
begin
  Success := False;
  BeenCanceled := False; {If there is a cancelled process reset it}
  CertifyConnect; {Make sure Connection exists}
  if Connected then
    begin
      if DataAvailable then read(0);
      DataSocket := TPowersock.Create(self); {Create a Data socket}
      DataSocket.TimeOut := TimeOut;
      strm := TFileStream.Create(LocalFile, fmOpenRead);
      DataSocket.TimeOut := TimeOut;
      if assigned(FPacketSent) then
        DataSocket.OnPacketSent := FPacketSent; {Set function to handle data socket status}
      try
        FBytesTotal := strm.Size;
      finally
        strm.Destroy;
      end; {_ try _}
      try
        if FPassive then
          begin
            ReplyMess := Transaction('PASV');
            if (ReplyNumber > 499) then
              if not assigned(FOnFailure) then
                raise FTPException.Create(Replymess)
              else
                begin
                  Handled := False;
                  FOnFailure(Handled, cmdAppend);
                  if not Handled then
                    raise FTPException.Create(Replymess)
                  else goto CleanUp;
                              {Raise exception on errors}
                end; {_ NOT if not assigned(FOnFailure) then _}
            DataSocket.Port := StrToInt(Copy(NthWord(replyMess, ',', 6), 1, Pos(')', NthWord(replyMess, ',', 6)) - 1)) + (256 * StrToInt(NthWord(replyMess, ',', 5)));
            DataSocket.Host := Host;
            DataSocket.connect;
          end
        else { _FPassive_ }
          begin
            DataSocket.Port := 0; {Set Port to Zero}
            DataSocket.Listen(True); {Listen in the datasocket}
            Replymess := Transaction(Cont_Port + GetLocalAddress + DataSocket.GetPortString); {Send Port for data socket}
            if (ReplyNumber > 300) and (ReplyNumber < 600) then
              if not assigned(FOnFailure) then
                raise FTPException.Create(Replymess)
                        {Raise exception on errors}
              else {_ NOT if not assigned(FOnFailure) then _}
                begin
                  Handled := False;
                  FOnFailure(Handled, cmdAppend);
                  if not Handled then
                    raise FTPException.Create(Replymess)
                  else goto CleanUp;
                           {Raise exception on errors}
                end; {_ NOT if not assigned(FOnFailure) then _}

          end { not _FPassive_ };
        if RemoteFile = '' then
          begin
            StatusMessage(Status_Informational, Cont_Appe + LocalFile); {Show Outgoing Message}
            Replymess := Transaction(Cont_Appe + ExtractFileName(LocalFile)) {Give store unique cmmand}
          end {_ if RemoteFile = '' then _}
        else {_ NOT if RemoteFile = '' then _}
          begin
            StatusMessage(Status_Informational, Cont_Appe + RemoteFile); {Show Outgoing Message}
            Replymess := Transaction(Cont_Appe + RemoteFile); {Give store unique cmmand}
          end; {_ NOT if RemoteFile = '' then _}
        if (ReplyNumber > 300) and (ReplyNumber < 600) then
          begin
            if assigned(FOnUnSupportedFunction) and (ReplyNumber >= 500) and (ReplyNumber <= 502) then FOnUnSupportedFunction(cmdAppend);
            if not assigned(FOnFailure) then
              raise FTPException.Create(Replymess)
                    {Raise exception on errors}
            else {_ NOT if not assigned(FOnFailure) then _}
              begin
                Handled := False;
                FOnFailure(Handled, cmdAppend);
                if not Handled then
                  raise FTPException.Create(Replymess)
                else goto CleanUp;
                     {Raise exception on errors}
              end; {_ NOT if not assigned(FOnFailure) then _}
          end; {_ if (ReplyNumber > 300) and (ReplyNumber < 600) then _}
        if not FPassive then
          begin
            Tsck := DataSocket.handle;
            DataSocket.ThisSocket := DataSocket.Accept; {Accept the datasocket}
            WinSock.CloseSocket(Tsck);
          end;
        if assigned(FTransactionStart) then FTransactionStart(self);
        if not (BeenCanceled or BeenTimedOut) then DataSocket.SendFile(LocalFile);
            {If no Local filename specified save file same as remote}
        if assigned(FTransactionStop) then FTransactionStop(self);
        CloseAfterData;
        DataSocket.RequestCloseSocket;
        if not (BeenCanceled or BeenTimedOut) then
          Replymess := readln;
        if ReplyMess = '' then ReplyMess := '226 Data Transfer successful';
        StatusMessage(Status_Informational, Replymess);
        if not (BeenCanceled or BeenTimedOut) then ReadExtraLines(Replymess); {Read Extra Lines}
        Success := True;
        CleanUp:
      finally
        DataSocket.Destroy; { _Destroy datasocket_ }
        DataSocket := nil;
        if Success then if assigned(FOnSuccess) then FOnSuccess(cmdAppend);
      end {_ try _}
    end; { _Connected_ }
end;

{*******************************************************************************************
Get Current Directory in Remote Server
********************************************************************************************}

function TNMFTP.GetCurrentDir;
begin
  DoCommand(Cont_Pwd); {Send get Current directory Command}
  Result := NthWord(TransactionReply, '"', 2);
end; {_ function TNMFTP.GetCurrentDir; _}

{*******************************************************************************************
Change the mode for file transactions
********************************************************************************************}

procedure TNMFTP.Mode(TheMode: Integer);
begin
  case TheMode of
    MODE_ASCII: DoCommand(Cont_Typ + 'A'); {Send AsCII Command}
    MODE_IMAGE: DoCommand(Cont_Typ + 'I'); {Send Image Command}
    MODE_BYTE: DoCommand(Cont_Typ + 'L 8'); {Send Byte Command}
  end; {_ case TheMode of _}
end; {_ procedure TNMFTP.Mode(TheMode: Integer); _}

{*******************************************************************************************
Get the value of BytesReceived property
********************************************************************************************}

function TNMFTP.GetBytesRcvd;
begin Result := DataSocket.BytesRecvd end;

{*******************************************************************************************
Get the value of BytesReceived property
********************************************************************************************}

function TNMFTP.GetBytesSent;
begin Result := DataSocket.BytesSent end;

{*******************************************************************************************
Get the value of BytesTotal property
********************************************************************************************}

function TNMFTP.GetBytesTotal;
var
  ReplyP: string[255];
  I: Integer;
begin
  I := Pos(No_Byte, UpperCase(Replymess));
  if I > 0 then
    begin
      ReplyP := '';
      while (Replymess[I] < '0') or (Replymess[I] > '9') do
        I := I - 1;
      while (Replymess[I] >= '0') and (Replymess[I] <= '9') do
        I := I - 1;
      I := I + 1;
      while (Replymess[I] >= '0') and (Replymess[I] <= '9') do
        begin
          ReplyP := ReplyP + Replymess[I];
          I := I + 1;
        end; {_ while (Replymess[I] >= '0') and (Replymess[I] <= '9') do _}
      Result := StrToIntDef(ReplyP, 0);
    end {_ if I > 0 then _}
  else {_ NOT if I > 0 then _}  Result := 0;
end; {_ function TNMFTP.GetBytesTotal; _}

{*******************************************************************************************
Abort a FTP file transaction
********************************************************************************************}

procedure TNMFTP.Abort;

begin
  // ReplyMess:= transaction('ABOR');
  if DataSocket <> nil then
    begin
      //DataSocket.FOStream.size := 0;
      DataSocket.Cancel; {Cancel Read or write}
    end; {_ if DataSocket <> nil then _}
  Cancel;
   //FAbort := True;
end; {_ procedure TNMFTP.Abort; _}


{*******************************************************************************************
Process Extra Lines in Transaction
********************************************************************************************}

function TNMFTP.Transaction(const CommandString: string): string;
var Replymess: string;
begin
  Replymess := inherited Transaction(CommandString);
  ReadExtraLines(Replymess);
  Result := Replymess;
end; {_ function TNMFTP.Transaction(const CommandString: string): string; _}

procedure TNMFTP.ReadExtraLines;

begin
  while (Replymess[1] = ' ') or (Replymess[4] = '-') do
      {If extra Lines}
    begin
      Replymess := readln; {Handle Extra Lines}
      StatusMessage(Status_Informational, Replymess); {Show Received Lines}
    end; {_ while (Replymess[1] = ' ') or (Replymess[4] = '-') do _}
end; {_ procedure TNMFTP.ReadExtraLines; _}



{*******************************************************************************************
List Files in Current Directory in Remote Server
********************************************************************************************}


procedure TNMFTP.Nlist;
var
  Replymess: string;
  Done: Boolean;
  Sck1: Integer;
begin {Stop Asynchronous Processing}
  Done := False;
  BeenCanceled := False; {Reset Cancelled flag}
  CertifyConnect;
  if Connected then
      {If connected}
    begin
      DataSocket := TPowersock.Create(self); {Create a Data socket}
      DataSocket.TimeOut := TimeOut;
      try
        if DataAvailable then read(0);
        DataSocket.Timeout := Timeout;
        DataSocket.Port := 0; {Set Port to Zero}
        DataSocket.Listen(True); {Listen in the datasocket}
        StatusMessage(Status_Informational, Cont_Port + GetLocalAddress + DataSocket.GetPortString); {Show Outgoing Message}
        Replymess := Transaction(Cont_Port + GetLocalAddress + DataSocket.GetPortString); {Send Port for data socket}
        if (ReplyNumber > 300) and (ReplyNumber < 600)
          then raise FTPException.Create(Replymess);
         {Raise exception on errors}
        StatusMessage(Status_Informational, Cont_Nlst); {Show Outgoing Message}
        if FListMask = '' then Replymess := Transaction(Cont_Nlst)
        else Replymess := Transaction(Cont_Nlst + ' ' + FListMask); {Send List command}
        if (ReplyNumber > 300) and (ReplyNumber < 600)
          then raise FTPException.Create(Replymess);
         {Raise exception on errors}
        FBytesTotal := GetBytesTotal(Replymess);
        Sck1 := DataSocket.ThisSocket;
        DataSocket.ThisSocket := DataSocket.Accept; {Accept the datasocket}
        Winsock.Closesocket(Sck1); {Accept the datasocket}
        if assigned(FTransactionStart) then FTransactionStart(self);
        while not (BeenCanceled or BeenTimedOut or DataSocket.DataAvailable) do
          Datasocket.wait;
        if not (BeenCanceled or BeenTimedOut) then
          repeat
            if DataSocket.DataAvailable then
              begin
                Replymess := DataSocket.readln;
                if Length(Replymess) > 2 then
                  if Replymess[Length(Replymess) - 1] = #13 then
                    SetLength(Replymess, Length(Replymess) - 2)
                  else {_ NOT if Replymess[Length(Replymess) - 1] = #13 then _}  SetLength(Replymess, Length(Replymess) - 1);
                if assigned(FOnListItem) then FOnListItem(Replymess);
              end {_ if  DataAvailable > 0 then read (0); _}
            else {_ NOT if DataAvailable > 0 then read (0); _}
              Datasocket.Wait; //Application.ProcessMessages;
          until (((not DataSocket.Connected) or DataAvailable) and (not DataSocket.DataAvailable)) or BeenTimedOut or BeenCanceled; {Capture incoming data}
         {Capture incoming data}
        if assigned(FTransactionStop) then FTransactionStop(self);
        DataSocket.RequestCloseSocket;
        FBytesTotal := DataSocket.BytesRecvd;
        StatusMessage(Status_Informational, (sFTP_Msg_Recvd + IntToStr(BytesTotal) + sFTP_No_Bytes));
        if not (BeenCanceled or BeenTimedOut) then Replymess := read(0);
        if ReplyMess = '' then ReplyMess := '226 Data Transfer successful';
        StatusMessage(Status_Informational, Replymess);
        if not (BeenCanceled or BeenTimedOut) then ReadExtraLines(Replymess); {Read Extra Lines}
        Done := True;
      finally
        DataSocket.Destroy; {Destroy datasocket}
        DataSocket := nil;
        if Done then if assigned(FOnSuccess) then FOnSuccess(cmdNList);
        if BeenCanceled then Flush;
      end; {_ try _}
    end; {_ if Connected then _}
end; {_ procedure TNMFTP.Nlist; _}


procedure TNMFTP.Reinitialize;
begin
  DoCommand(Cont_Rein);
end; {_ procedure TNMFTP.Reinitialize; _}

procedure TNMFTP.Allocate(FileSize: Integer);
begin
  DoCommand(Cont_Allo + IntToStr(FileSize));
end; {_ procedure TNMFTP.Allocate(FileSize: Integer); _}


procedure TNMFTP.CheckRead(Sender: TObject);
begin
  (*if DataAvailable  then
  begin
    { AStr := TMemoryStream(FIstream).Memory;
     if Astr[0] ='4' then
        if AStr[1] = '2' then
           if (AStr[2] ='1') or (AStr[2] ='6') then
               Cancel;    }
  end;  *)
end;

procedure TNMFTP.Flush;
var STime: TDateTime;
var Replymess: string;
begin
  BeenCanceled := False;
  STime := Now;
  repeat
    Replymess := read(0);
    Application.ProcessMessages;
  until (Replymess <> '') or (Now - STime > 1.1E-5);
  StatusMessage(Status_Informational, Replymess);
end; {_ procedure TNMFTP.Flush; _}

end.

