{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// Copyright © 1996-2000, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.                  //
//                                                                           //
// Unit Name: NMHTTP                                                         //
//                                                                           //
// DESCRIPTION:Internet HTTP Component                                       //
//                                                                           //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY     //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE       //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR     //
// PURPOSE.                                                                  //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 01 20 2000 - KNA -  Extra Information on Cookie Removed
//                     Comments on response failure improved
// 01 19 2000 - MDC -  When a POST redirects change method to GET
//                     Remove use of stringreplace function for version compatibility
// 01 15 2000 - MDC -  Remove Stupid comments, compact AssembleHTTPHeader code
//                     Addition of basic Proxy authenication
// 12 17 1999 - KNA -  Close Immediate and Fconected added to restore socket on a timeout
// 12 09 1999 - KNA -  variable number of = in base64 Encoded Auth string handled
// 12 01 1999 - KNA -  Post stream function
// 08 02 1999 - KNA -  Pages with no header in redirect handled
// 05 17 1999 - KNA -  Spaces in extention replaced
// 05 03 1999 - KNA -  Final release Ver 5.3 VCLS
//
unit NMHttp;
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
  SysUtils, Classes, PSock, NMExtstr, NMConst, NMUUE, NMURL, Winsock;
{$IFDEF VER110}
{$OBJEXPORTALL On}
{$ENDIF}
{$IFDEF VER120}
{$OBJEXPORTALL On}
{$ENDIF}
{$IFDEF VER125}
{$OBJEXPORTALL On}
{$ENDIF}

//  CompName='NMHTTP';
//  Major_Version='4';
//  Minor_Version='02';
//  Date_Version='012798';

const {Protocol}
  Prt_gopher = 'gopher';
  Prt_ftp = 'ftp';

  Prt_str_http = ' HTTP/1.0';
  Prox_Head_Str = 'Proxy-Connection: Keep-Alive';
  Prox_Host_Str = 'Host: ';
  Host_Accpt_Str1 = 'Accept: www/source, text/html, video/mpeg, image/jpeg, image/x-tiff';
  Host_Accpt_Str2 = 'Accept: image/x-rgb, image/x-xbm, image/gif, */*, application/postscript';
  Host_UserAgent = 'User-Agent';
  Head_From = 'From';
  Head_Host = 'Host';
  Head_Cookie = 'Cookie';
  Head_Referer = 'Referer';
  Head_Content = 'Content-type: application/x-www-form-urlencoded';
  Head_Link = 'Link: ';
  Head_URI = 'URI-header: ';
  Head_ContentLength = 'Content-Length: ';
  Head_SetCookie = 'SET-COOKIE:';
  Head_CL2 = 'CONTENT-LENGTH:';
  Head_length = 'ENGTH:';
  Head_Location = 'LOCATION:';

  Cmd_Get = 'GET ';
  Cmd_Options = 'OPTIONS ';
  Cmd_Post = 'POST ';
  Cmd_Put = 'PUT ';
  Cmd_Head = 'HEAD ';
  Cmd_Patch = 'PATCH ';
  Cmd_Copy = 'COPY ';
  Cmd_Move = 'MOVE ';
  Cmd_Link = 'LINK ';
  Cmd_Unlink = 'UNLINK ';
  Cmd_Delete = 'DELETE ';
  Cmd_Trace = 'TRACE ';

type
  {HTTP Transaction Type Options}
  CmdType = (CmdGET, CmdOPTIONS, CmdHEAD, CmdPOST, CmdPUT, CmdPATCH, CmdCOPY,
    CmdMOVE, CmdDELETE, CmdLINK, CmdUNLINK, CmdTRACE, CmdWRAPPED, cmdPOSTS);

  HTTPException = class(Exception);
  TResultEvent = procedure(Cmd: CmdType) of object;

  THeaderInfo = class(TPersistent)
  private
    FLocalAddress: string;
    FLocalProgram: string;
    FCookie: string;
    FReferer: string;
    FUserId: string;
    FPassword: string;
    FProxyUserId: string;
    FProxyPassword: string;
  published
    property LocalMailAddress: string read FLocalAddress write FLocalAddress;
    property LocalProgram: string read FLocalProgram write FLocalProgram;
    property Cookie: string read FCookie write FCookie;
    property Referer: string read FReferer write FReferer;
    property UserId: string read FUserId write FUserId;
    property Password: string read FPassword write FPassword;
    property ProxyUserId: string read FProxyUserId write FProxyUserId;
    property ProxyPassword: string read FProxyPassword write FProxyPassword;
  end;

  {*******************************************************************************************
  HTTP Class definition
  ********************************************************************************************}
  TNMHTTP = class(TPowersock)
  private
    FBody: string; {File Name for received file}
    FHeader: string; {File Name for saving Header}
    FSelector: string; {The Selector or Directory string}
    FSendHeader: TexStringList;
    FLocation: string;

    FHeaderInfo: THeaderInfo; {Header Information}

    FCookieIn: string; {Cookie - string}
    FInputFileMode: boolean; {Inputs - File Mode}
    FOutPutFileMode: boolean; {Output - File Mode}
    FEncodePosts: boolean;
    TheSendFile: string;
    FSendStream: TStream; {The name of File to send}
    TheDestURL: string; {The Destination URL in MOVE and COPY commands}
    URL_Holder: string; {Temporary holder for URL}
    ConnType: CmdType; {The Transaction type}

    // URL specifics
    FScheme: string;
    FUser: string;
    FPassword: string;
    FNetworkLocation: string;
    FPort: string;
    FQuery: string;
    FResource: string;
    FParameters: string;
    FPath: string;
    FFragment: string;

    FOnSuccess: TResultEvent; {Pointer to handler of function to execute after all bytes received}
    FOnFailure: TResultEvent;
    FOnAboutToSend: TNotifyEvent;
    FOnRedirect: THandlerEvent;
    FOnAuthenticationNeeded: TNotifyEvent;
//    FOnProxyAuthenticationNeeded: TNotifyEvent;

  protected
    procedure HTTPConnect; virtual;
//    procedure ParsetheURL; virtual;
    procedure AssembleHTTPHeader; virtual;
    procedure RemoveHeader; virtual;
    procedure SendHTTP; virtual;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Options(URL: string); virtual;
    procedure Get(URL: string); virtual;
    procedure Post(URL, PostData: string); virtual;
    procedure Put(URL, PutData: string); virtual;
    procedure Head(URL: string); virtual;
    procedure Patch(URL, PatchData: string); virtual;
    procedure Delete(URL: string); virtual;
    procedure Trace(URL, TraceData: string); virtual;
    procedure Copy(URL1, URL2: string); virtual;
    procedure Move(URL1, URL2: string); virtual;
    procedure Link(URL, link: string); virtual;
    procedure UnLink(URL, link: string); virtual;
    procedure Wrapped(URL, WrappedData: string); virtual;
    procedure Abort; override;
    procedure PostStream(URL: string; Stream: TStream); virtual;

    property SendHeader: TExStringList read FSendHeader write FSendHeader;
    property CookieIn: string read FCookieIn;

  published
    property OnPacketRecvd;
    property OnPacketSent;
    property Body: string read FBody write FBody;
    property Header: string read FHeader write FHeader;
    property HeaderInfo: THeaderInfo read FHeaderInfo write FHeaderInfo;
    property InputFileMode: boolean read FInputFileMode write FInputFileMode;
    property OutputFileMode: boolean read FOutputFileMode write FOutputFileMode;

    property Proxy;
    property ProxyPort;

    property OnAboutToSend: TNotifyEvent read FOnAboutToSend write FOnAboutToSend;
    property OnSuccess: TResultEvent read FOnSuccess write FOnSuccess;
    property OnFailure: TResultEvent read FOnFailure write FOnFailure;
    property OnRedirect: THandlerEvent read FOnRedirect write FOnRedirect;
    property OnAuthenticationNeeded: TNotifyEvent read FOnAuthenticationNeeded write FOnAuthenticationNeeded;
  end;

procedure Register; {Register Http component]

{*******************************************************************************************}

implementation

uses
  URLParse;

{*******************************************************************************************
Register Component in Internet Directory
********************************************************************************************}

procedure Register;
begin
  RegisterComponents(Cons_Palette_Inet, [TNMHTTP]);
end;

{*******************************************************************************************
Create HTTP component
********************************************************************************************}

constructor TNMHTTP.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FHeaderInfo := THeaderInfo.create;
  FSendHeader := TExStringList.create;
  FEncodePosts := TRUE;
  FHeader := sHTTP_Head_File; {Default Header File}
  FBody := sHTTP_Body_File;
  FInputFileMode := FALSE; {Inputs - File Mode}
  FOutPutFileMode := FALSE; {Output - File Mode}
  ProxyPort := 8080;
end;

destructor TNMHTTP.Destroy;
begin
  FHeaderInfo.free;
  FSendHeader.free;
  inherited destroy;
end;

{*******************************************************************************************
Get Page given by URL
********************************************************************************************}

procedure TNMHTTP.Get(URL: string);
begin
  ConnType := CmdGET; {Set transaction type to Get}
  URL_Holder := URL; {Set Locator to URL for later}
  HTTPConnect; {Get Page}
end;

{*******************************************************************************************
Get Option given by URL
********************************************************************************************}

procedure TNMHTTP.Options(URL: string);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  ConnType := CmdOPTIONS; {Set Connection type to get Options}
  HTTPConnect; {Connect to web and get Options}
end;

{*******************************************************************************************
Post File in FileName to given URL
********************************************************************************************}

procedure TNMHTTP.Post(URL, PostData: string);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  (*
    if FEncodePosts then
      begin
        NMURL1 := TNMURL.create(self);
        try
          if OutPutFileMode then
            begin
            end
          else
            begin
              NMURL1.InputString := postData;
              Postdata := NMURL1.Encode;
            end;
        finally
          NMURL1.Free;
        end;
      end;
  *)
  TheSendFile := PostData; {Set the file to send to filename}
  ConnType := CmdPOST; {Set Connection type to Post}
  HTTPConnect; {Connect to web and post}
end;

{*******************************************************************************************
Put File in FileName to given URL
********************************************************************************************}

procedure TNMHTTP.Put(URL, PutData: string);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  TheSendFile := PutData; {Set the file to send to filename}
  ConnType := CmdPUT; {Set Connection type to Put}
  HTTPConnect; {Connect to web and put}
end;

{*******************************************************************************************
Get Heading of given URL
********************************************************************************************}

procedure TNMHTTP.Head(URL: string);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  ConnType := CmdHEAD; {Set Connection type to Head}
  HTTPConnect; {Connect to web and get heading}
end;

{*******************************************************************************************
Patch given URL with given file
********************************************************************************************}

procedure TNMHTTP.Patch(URL, PatchData: string);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  TheSendFile := Patchdata; {Set the file to send to filename}
  ConnType := CmdPATCH; {Set Connection type to Patch}
  HTTPConnect; {Connect to web and patch}
end;

{*******************************************************************************************
Copy URL1 to URL2
********************************************************************************************}

procedure TNMHTTP.Copy(URL1, URL2: string);
begin
  URL_Holder := URL1; {Set Locator to URL for later}
  TheDestURL := URL2; {Set theDestURL to be used later}
  ConnType := CmdCOPY; {Set Connection type to COPY}
  HTTPConnect; {Connect to web and copy}
end;

{*******************************************************************************************
Move URL1 to URL2
********************************************************************************************}

procedure TNMHTTP.Move(URL1, URL2: string);
begin
  URL_Holder := URL1; {Set Locator to URL for later}
  TheDestURL := URL2; {Set theDestURL to be used later}
  ConnType := CmdMOVE; {Set Connection type to MOVE}
  HTTPConnect; {Connect to web and move}
end;

{*******************************************************************************************
Link URL to Link
********************************************************************************************}

procedure TNMHTTP.Link(URL, Link: string);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  TheDestURL := Link; {Set theDestURL to link later}
  TheSendFile := sHTTP_Data_File; {Set the file to send to entity.stf}
  ConnType := CmdLINK; {Set Connection type to LINK}
  HTTPConnect; {Connect to web and link}
end;

{*******************************************************************************************
UnLink URL from Link
********************************************************************************************}

procedure TNMHTTP.UnLink(URL, Link: string);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  TheDestURL := Link; {Set theDestURL to link later}
  TheSendFile := sHTTP_Data_File; {Set the file to send to entity.stf}
  ConnType := CmdUNLINK; {Set Connection type to UNLINK}
  HTTPConnect; {Connect to web and Unlink}
end;

{*******************************************************************************************
Delete URL
********************************************************************************************}

procedure TNMHTTP.Delete(URL: string);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  ConnType := CmdDELETE; {Set Connection type to DELETE}
  HTTPConnect; {Connect to web and Delete}
end;

{*******************************************************************************************
Request a trace from URL
********************************************************************************************}

procedure TNMHTTP.Trace(URL, TraceData: string);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  TheSendFile := TraceData; {Set the file to send to entity.stf}
  ConnType := CmdTRACE; {Set Connection type to TRACE}
  HTTPConnect; {Connect to web and TRACE}
end;

{*******************************************************************************************
Send Wrapped command to URL
********************************************************************************************}

procedure TNMHTTP.Wrapped(URL, WrappedData: string);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  TheSendFile := WrappedData; {Set the file to send to entity.stf}
  ConnType := CmdWRAPPED; {Set Connection type to TRACE}
  HTTPConnect; {Connect to web and send WRAPPED}
end;

{*******************************************************************************************
Abort transaction
********************************************************************************************}

procedure TNMHTTP.Abort;
begin
  Wait_Flag := TRUE; {Force fetch to come out of wait loop}
  cancel; {Set Flag to cancel present transaction}
end;

procedure TNMHTTP.PostStream(URL: string; Stream: TStream);
begin
  URL_Holder := URL; {Set Locator to URL for later}
  FSendStream := Stream; {Set the file to send to filename}
  ConnType := CmdPOSTS; {Set Connection type to Post}
  HTTPConnect; {Connect to web and post}
end;

{*******************************************************************************************
Carry out HTTP transaction
********************************************************************************************}

procedure TNMHTTP.HTTPConnect;
var
  Handled: boolean;
  LkHead: string;
  tmp: string;
begin
  repeat
    //ParsetheURL;                                   {Parse the URL to get Host, Port and Selector}
    ParseURL(URL_Holder, FScheme, FUser, FPassword, FNetworkLocation, FPort, FPath, FResource, FParameters, FQuery, FFragment);
    if (FUser <> '') or (FPassword <> '') then
      HeaderInfo.FUserId := FUser;
    HeaderInfo.FPassword := FPassword;
    Port := StrToInt(DefaultPort(FScheme));
    Host := FNetworkLocation;

    AssembleHTTPHeader;

    if assigned(FOnAboutToSend) then
      FOnAboutToSend(self);

    try
      Connect; {Now connect to  Host at Port}
      SendHTTP;
      FReplyNumber := 0;

      timeron;

      try
        while (FifoQ.BufferSize < 3) and (not beenCanceled) do
          wait;
      finally
        timeroff;
      end;

      if Timedout then
        raise ESockError.Create('Timed out waiting for response');
      if BeenCanceled then
        raise ESockError.Create('Wait for response Cancelled');

      Setlength(LkHead, 3);
      FifoQ.Peek(Pointer(@LkHead[1]), 3);

      if (LKHead = 'HTT') then
        RemoveHeader; {Get the Header of the file sent from host}

      if InputFileMode then
        CaptureFile(FBody) {Capture the body of the data from host}
      else
        CaptureString(FBody, -2);

      if ReplyNumber < 299 then
        begin
          if Assigned(FOnSuccess) then
            FOnSuccess(ConnType); {If a  message received event handler present execute it}

          StatusMessage(STATUS_BASIC, sHTTP_Msg_Trans); {Show status Message}
        end
      else if ReplyNumber > 399 then
        begin
          if Assigned(FOnFailure) then
            FOnFailure(ConnType)
        end
      else if (ReplyNumber >= 300) and (ReplyNumber <= 302) then
        URL_Holder := FLocation;

    finally
      CloseImmediate;
      FConnected := TRUE;
      Disconnect; {Disconnect from host}
    end;

    if (ReplyNumber > 299) and (ReplyNumber < 399) then
      begin
        Handled := FALSE;

        if CookieIn <> '' then
          HeaderInfo.Cookie := CookieIn;

        if assigned(OnRedirect) then
          OnRedirect(Handled);

        if Handled then
          break;

        ConnType := CmdGET; {Set transaction type to Get}

        if Pos('//', URL_Holder) = 0 then
          if Pos('/', URL_Holder) <> 1 then
            begin
              tmp := URL_Holder;
              URL_Holder := FScheme + '//' + FNetworkLocation;

              if FPort <> '' then
                URL_Holder := URL_Holder + FPort;

              URL_Holder := URL_Holder + FPath + tmp;
            end;
            //URL_Holder := 'http://' + Host + '/' + URL_Holder;
      end;

    if (ReplyNumber = 401) then
      if assigned(FOnAuthenticationNeeded) then
        FOnAuthenticationNeeded(self);

  until (ReplyNumber < 299) or (ReplyNumber > 399);
end;


(*
{*******************************************************************************************
Parse the URL
********************************************************************************************}

procedure TNMHTTP.ParsetheURL;
var
  Pos1                : integer;
  TempStr             : string;
begin
  if URL_Holder = '' then {Nothing to work on?}
    raise Exception.create( sHTTP_Cont_Msg_NoURL );

  if port = 0 then {Set default port}
    Port := 80;

  if Pos( '//', URL_Holder ) <> 0 then
    FSelector := system.Copy( URL_Holder, NthPos( URL_Holder, '/', 3 ), 256 )
  else if Pos( '/', URL_Holder ) <> 0 then
    FSelector := system.Copy( URL_Holder, Pos( '/', URL_Holder ), 256 )
  else
    Fselector := '';

  if Pos( ':', URL_Holder ) <> 0 then
    begin
      tempStr := LowerCase( NthWord( URL_Holder, ':', 1 ) ); {Extract URL type}

      if TempStr = Prt_gopher then
        Port := 70                              {If URL Type is gopher set port to 70}
      else if TempStr = Prt_ftp then
        Port := 21
      else if TempStr = 'https' then
        raise exception.create( 'HTTP Secure Socket is not supported' )
      else
        Port := 80;                             {If URL type is FTP set FPort to 21 else set port to 80}
    end;

  if Pos( '//', URL_Holder ) <> 0 then
    tempStr := NthWord( URL_Holder, '/', 3 )    {Extract Host part}
  else if URL_Holder[ 1 ] <> '/' then
    tempStr := NthWord( URL_Holder, '/', 1 )
  else
    tempstr := '';                              {Extract Host part}

  Pos1 := Pos( ':', tempStr );                  {see if a colon in host address}

  if Pos1 > 0 then
    {if so there is an embedded port number}
    begin
      Port := StrToInt( NthWord( tempStr, ':', 2 ) ); {If so extract port}
      system.Delete( tempStr, Pos1, 255 );      {and extract remaining IPAddr}
    end;

  if tempStr <> '' then
    Host := tempStr;

  if FSelector = '' then {If no seletor(directory) make it the home directory}
    begin FSelector := '/';
      URL_Holder := URL_Holder + '/';
    end;
end;
*)

{*******************************************************************************************
Send HTTP Header
********************************************************************************************}

procedure TNMHTTP.AssembleHTTPHeader;
var
  strm: TFileStream;
  Ins, Ous: TStringStream;
  NMUUProcessor1: TNMUUProcessor;
  tmp: string;
  i: PChar;
begin
  FSendHeader.clear; {Create memorystream to hold Http command}
  try
    case ConnType of
      {Construct the command line depending on type of Transaction}
      CmdGET:
        tmp := Cmd_Get;

      CmdOPTIONS:
        tmp := Cmd_Options;

      CmdPOST, CmdPOSTS:
        tmp := Cmd_Post;

      CmdPUT:
        tmp := Cmd_Put;

      CmdHEAD:
        tmp := Cmd_Head;

      CmdPATCH:
        tmp := Cmd_Patch;

      CmdCOPY:
        tmp := Cmd_Copy;

      CmdMOVE:
        tmp := Cmd_Move;

      CmdLINK:
        tmp := Cmd_Link;

      CmdUNLINK:
        tmp := Cmd_Unlink;

      CmdDELETE:
        tmp := Cmd_Delete;

      CmdTRACE:
        tmp := Cmd_Trace;
    end;

    if Proxy <> '' then
      begin
        i := StrPos(PChar(URL_Holder), ' ');
        while i <> nil do
          begin
            I^ := '+';
            i := StrPos(PChar(URL_Holder), ' ');
          end;

        {If Proxy server send whole URL}
        FsendHeader.add(tmp + URL_Holder + Prt_str_http);
        FsendHeader.add(Prox_Head_Str); {If Proxy ask connection to be kept alive}
        FsendHeader.add(Prox_Host_Str + Host); {Send host name to proxy}
      end
    else
      begin
        FSelector := FPath + FResource + FParameters + FQuery + FFragment;

        i := StrPos(PChar(FSelector), ' ');
        while i <> nil do
          begin
            I^ := '+';
            i := StrPos(PChar(FSelector), ' ');
          end;

        {If no proxy just send selector}
        FsendHeader.add(tmp + FSelector + Prt_str_http);
      end;

    {Send acceptable reply types}
    FsendHeader.values[Head_Host] := Host;
    FsendHeader.add(Host_Accpt_Str1);
    FsendHeader.add(Host_Accpt_Str2);

    if FHeaderInfo.FLocalAddress <> '' then
      FsendHeader.values[Host_UserAgent] := FHeaderInfo.FLocalAddress;

    if FHeaderInfo.FLocalProgram <> '' then
      FsendHeader.values[Head_From] := FHeaderInfo.FLocalProgram;

    if FHeaderInfo.FCookie <> '' then
      FsendHeader.values[Head_Cookie] := FHeaderInfo.FCookie;

    if FHeaderInfo.FReferer <> '' then
      FsendHeader.values[Head_Referer] := FHeaderInfo.FReferer;

    if (FHeaderInfo.FUserId <> '') and (FHeaderInfo.Fpassword <> '') then
      begin
        Ins := TStringStream.create(FHeaderInfo.FUserId + ':' + FHeaderInfo.Fpassword);
        Ous := TStringStream.create('');
        NMUUProcessor1 := TNMUUProcessor.create(self);
        try
          NMUUProcessor1.InputStream := Ins;
          NMUUProcessor1.OutputStream := Ous;
          NMUUProcessor1.method := UUMime;
          NMUUProcessor1.Encode;

          FsendHeader.values['Authorization'] := 'Basic ' + Ous.DataString;

        finally
          NMUUProcessor1.free;
          Ous.free;
          Ins.free;
        end;
      end;

    if (FHeaderInfo.FProxyUserId <> '') and (FHeaderInfo.FProxyPassword <> '') then
      begin
        Ins := TStringStream.create(FHeaderInfo.FProxyUserId + ':' + FHeaderInfo.FProxyPassword);
        Ous := TStringStream.create('');
        NMUUProcessor1 := TNMUUProcessor.create(self);

        try
          NMUUProcessor1.InputStream := Ins;
          NMUUProcessor1.OutputStream := Ous;
          NMUUProcessor1.method := UUMime;
          NMUUProcessor1.Encode;

          FsendHeader.values['Proxy-Authorization'] := 'Basic ' + Ous.DataString;

        finally
          NMUUProcessor1.free;
          Ous.free;
          Ins.free;
        end;
      end;

    FsendHeader.add(Head_Content); {Send content type of request}

    case ConnType of
      CmdLINK, CmdUNLINK:
        FsendHeader.add(Head_Link + TheDestURL); {Send link for link or unlink method}

      CmdMOVE, CmdCOPY:
        FsendHeader.add(Head_URI + TheDestURL); {Send destination URL for copy or move methods}
    end;

    case ConnType of
      {Construct the content length string}
      CmdPOSTS:
        FSendHeader.add(Head_ContentLength + IntToStr(FSendStream.size));

      CmdPOST, CmdPUT, CmdPATCH, CmdTRACE, CmdWRAPPED, CmdLINK, CmdUNLINK:
        begin
          if OutPutFileMode then
            begin
              strm := TFileStream.Create(TheSendFile, fmOpenRead); {Open stream}

              try
                FsendHeader.add(Head_ContentLength + IntToStr(strm.size)); {Send content length of stream}
              finally
                strm.destroy; {Destroy stream}
              end;
            end
          else
            FsendHeader.add(Head_ContentLength + IntToStr(length(TheSendFile)));
        end;
    end;

  finally
  end
end;

procedure TNMHTTP.SendHTTP;
begin
  write(FsendHeader.text);
  writeln('');

  case ConnType of
    CmdPOSTS:
      SendStream(FSendStream);

    CmdPOST, CmdPUT, CmdPATCH, CmdTRACE, CmdWRAPPED:
      if OutputFileMode then
        SendFile(TheSendFile)
      else
        write(TheSendFile);
  end;
end;

procedure TNMHTTP.RemoveHeader;
var
  strm: TFileStream;
  ReplyMess, tempbuff, temp2: string;
  i: integer;
  st: boolean;
begin
  strm := nil;
  FBytesTotal := 0;
  FCookieIn := '';

  if InPutFileMode then
    strm := TFileStream.Create(Header, fmCreate) {Create stream to take header}
  else
    FHeader := '';

  try
    ReplyMess := Readln;

    if ReplyMess <> '' then
      FReplyNumber := StrtoIntDef(NthWord(ReplyMess, ' ', 2), 0);

    if InPutFileMode then
      strm.WriteBuffer(ReplyMess[1], Length(ReplyMess)) {Write it to buffer}
    else
      FHeader := FHeader + ReplyMess;

    repeat
      ReplyMess := Readln;
      tempbuff := uppercase(ReplyMess); {Read a line}

      if NthWord(tempbuff, ' ', 1) = Head_SetCookie then
        begin
          if Pos(';', ReplyMess) > 0 then FCookieIn := system.Copy(ReplyMess, 13, Pos(';', ReplyMess) - 13)
          else FCookieIn := system.Copy(ReplyMess, 13, Length(ReplyMess) - 14);
        end;

      if NthWord(tempbuff, ' ', 1) = Head_Location then
        begin
          FLocation := system.Copy(ReplyMess, 11, 256);
          SetLength(FLocation, Length(FLocation) - 2);
        end;

      if NthWord(tempbuff, ' ', 1) = Head_CL2 then
        begin
          system.Delete(tempbuff, 1, pos(Head_length, tempbuff) + 6); {Delete anything before 'length:'}
          st := FALSE;
          temp2 := '';

          for i := 1 to length(tempbuff) do
            if st = TRUE then
              if ((tempbuff[i] < '0') or (tempbuff[i] > '9')) then
                break
              else
                temp2 := temp2 + tempbuff[i]
            else if ((tempbuff[i] >= '0') or (tempbuff[i] <= '9')) then
              begin
                temp2 := temp2 + tempbuff[i];
                st := TRUE;
              end;

          FBytesTotal := StrToIntDef(temp2, 0);
        end;

      if InPutFileMode then
        strm.WriteBuffer(ReplyMess[1], Length(ReplyMess)) {Write it to buffer}
      else
        FHeader := FHeader + ReplyMess;

    until (ReplyMess = #10) or (ReplyMess = #13#10) or (ReplyMess = ''); {Until blank line}
  finally
    if InPutFileMode then
      strm.free;
  end;
end;

end.

