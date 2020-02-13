{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// Copyright © 1997-2000, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.                  //
//                                                                           //
// Unit Name: NMSMTP                                                         //
//                                                                           //
// DESCRIPTION: Internet SMTP Component                                      //
//                                                                           //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY     //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE       //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR     //
// PURPOSE.                                                                  //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 01 27 2000 - MDC -  removed left behind 'mike.tst' from SendAttachments
//                     removed unnecessary comments,
//              KNA -  Unnecessary redefintion of uumime and uuencode removed
// 12 01 1998 - KNA -  CR between attachment content and boundary
// 05 26 1998 - KNA -  Stream pos set to 0
// 08 03 1998 - KNA -  Abort changed to plain cancel
// 06 22 1998 - KNA -  HTML,SGML, RichText, tab separated supported
// 06 08 1998 - KNA -  tHTML ect vhanged to mtHTML
// 06 05 1998 - KNA -  ReplyTo address added
// 04 24 1998 - KNA -  var Parameter on HandlerIncomplete and hiToaddress changed
// 02 26 1998 - KNA -  Force blank line after headers
// 02 16 1998 - KNA -  Extra '.' added to line with '.'
// 02 02 1998 - KNA -  Add Set Functions to assign values to StringList properties
// 01 27 1998 - KNA -  Final release Ver 4.00 VCLS
// 01 17 1998 4.01.1  OnConnect Moved after TransactionProgress reset
//          To enable processing on OnContact
//          Date variable added to PostMessage

unit NMsmtp;
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
  Classes, PSock, sysutils, NMuue, NMConst, NMExtstr;
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


  SMTP_PORT           = 25;

  //  CompName     ='TNMSMTP';
  //  Major_Version='4';
  //  Minor_Version='03';
  //  Date_Version ='020398';

  CRLF                = #13#10;

  hiFromAddress       = 1;
  hiToAddress         = 2;

const                                           {protocol}
  Cons_Helo           = 'HELO ';
  Cons_Quit           = 'QUIT';
  Cons_Rset           = 'RSET';
  Cons_From           = 'MAIL FROM:<';
  Cons_To             = 'RCPT TO:<';
  Cons_Date           = 'DATA';
  Cons_Expn           = 'EXPN ';
  Cons_Vrfy           = 'VRFY ';
  Cons_Head_subj      = 'Subject';
  Cons_Head_from      = 'From: ';
  Cons_Head_To        = 'To: ';
  Cons_Head_CC        = 'CC: ';
  Cons_Head_mail      = 'X-Mailer';
  Cons_Head_ReplyTo   = 'Reply-To';
  Cons_Head_Date      = 'Date';
  Cons_Head_mime      = 'Mime-Version: 1.0';
  Cons_Head_disp      = 'Content-Disposition: attachment; filename="';
  Cons_Head_ba64      = 'Content-Transfer-Encoding: base64';
  Cons_Head_appl      = 'Content-Type: application/octet-stream; name="';
  Cons_Head_text      = 'Content-Type: text/plain; charset=';
  Cons_Head_Enriched  = 'Content-Type: text/enriched; charset=';
  Cons_Head_Sgml      = 'Content-Type: text/sgml; charset=';
  Cons_Head_TabSeperated = 'Content-Type: text/tab-separated-values; charset=';
  Cons_Head_mtHtml    = 'Content-Type: text/html; charset=';
  // Cons_Head_text2       = 'Content-Type: text/plain, charset="iso-8859-1"';
  Cons_Head_mult      = 'Content-Type: multipart/mixed; boundary="';
  Cons_Head_7Bit      = 'Content-Transfer-Encoding: 7Bit';

type
  TSubType = ( mtPlain, mtEnriched, mtSgml, mtTabSeperated, mtHtml );

  THeaderInComplete = procedure( var handled: boolean; hiType: integer ) of object;
  TRecipientNotFound = procedure( Recipient: string ) of object;
  TMailListReturn = procedure( MailAddress: string ) of object;
  TFileItem = procedure( Filename: string ) of object;

  TPostMessage = class( TPersistent )
  private

    FFromName, FFrom, FSubject, FLocalProgram, FDate, FReplyTo: string;
    FAttachments, FTo, FCC, FBCC: TStringList;
    FBody: TStringlist;
  protected
    procedure SetLinesTo( Value: TStringlist );
    procedure SetLinesCC( Value: TStringlist );
    procedure SetLinesBCC( Value: TStringlist );
    procedure SetLinesBody( Value: TStringlist );
    procedure SetLinesAttachments( Value: TStringlist );
  public
    constructor Create;
    destructor Destroy; override;

  published

    property FromAddress: string read FFrom write fFrom;
    property FromName: string read FFromName write fFromName;
    property ToAddress: Tstringlist read FTo write SetLinesTo;
    property ToCarbonCopy: Tstringlist read FCc write SetLinesCc;
    property ToBlindCarbonCopy: Tstringlist read FBcc write SetLinesBcc;
    property Body: Tstringlist read FBody write SetLinesBody;
    property Attachments: TstringList read FAttachments write SetLinesAttachments;
    property Subject: string read FSubject write FSubject;
    property LocalProgram: string read FLocalProgram write FLocalProgram;
    property Date: string read FDate write FDate;
    property ReplyTo: string read FReplyTo write FReplyTo;
  end;

  TNMSMTP = class( TPowerSock )
  private
    FCharset: string;
    FOnConnect: TNotifyEvent;
    FPostMessage: TPostMessage;
    FsenFmem: TMemoryStream;
    (*{$IFDEF NMF3}
          FSendFile: TS_BufferStream;
    {$ELSE}   *)
    FSendFile: TMemoryStream;
    //{$ENDIF}
    FFinalHeader: TExStringList;
    FTransactionInProgress, FAbort: boolean;
    FUserID, FBoundary: string;
    FSubType: TSubType;
    FOnHeaderInComplete: THeaderInComplete;
    FOnSendStart, FOnSuccess, FOnFailure: TNotifyEvent;
    FOnEncodeStart, FOnEncodeEnd: TFileItem;
    FOnAttachmentNotFound: TFileItem;
    FRecipientNotFound {,FMessageSent}: TRecipientNotFound;
    FMailListReturn: TMailListReturn;
    FOnAuthenticationFailed: THandlerEvent;
    fUUMethod: UUMethods;
    FClearParams: boolean;
    WaitForReset: integer;
    {$IFDEF NMDEMO}
    DemoStamped: boolean;
    {$ENDIF}
    procedure ReadExtraLines( var ReplyMess: string );
    procedure SendAttachments( i: integer );
    procedure AssembleMail;
    procedure AbortResume( Sender: TObject );
    procedure SetFinalHeader( Value: TExStringList );
    //function CreateTemporaryFileName: string;
  protected

  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure Connect; override;
    procedure Disconnect; override;
    procedure SendMail;
    procedure Abort; override;
    procedure ClearParameters;
    function ExtractAddress( TotalAddress: string ): string;
    function Verify( UserName: string ): boolean;
    function ExpandList( MailList: string ): boolean;
  published
    property OnPacketSent;
    property OnConnectionRequired;
    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
    property UserID: string read FUserID write FUserID;
    property PostMessage: TPostMessage read FPostMessage write FPostMessage;
    property FinalHeader: TExStringList read FFinalHeader write SetFinalHeader;
    property EncodeType: UUMethods read fUUMethod write fUUMethod;
    property ClearParams: boolean read FClearParams write FClearParams;
    property SubType: TSubType read FSubType write FSubType;
    property Charset: string read FCharset write FCharset;
    property OnRecipientNotFound: TRecipientNotFound read FRecipientNotFound write FRecipientNotFound;
    property OnHeaderIncomplete: THeaderInComplete read FOnHeaderIncomplete write FOnHeaderIncomplete;
    property OnSendStart: TNotifyEvent read FOnSendStart write FOnSendStart;
    property OnSuccess: TNotifyEvent read FOnSuccess write FOnSuccess;
    property OnFailure: TNotifyEvent read FOnFailure write FOnFailure;
    property OnEncodeStart: TFileItem read FOnEncodeStart write FOnEncodeStart;
    property OnEncodeEnd: TFileItem read FOnEncodeEnd write FOnEncodeEnd;
    property OnMailListReturn: TMailListReturn read FMailListReturn write FMailListReturn;
    property OnAttachmentNotFound: TFileItem read FOnAttachmentNotFound write FOnAttachmentNotFound;
    property OnAuthenticationFailed: THandlerEvent read FOnAuthenticationFailed write FOnAuthenticationFailed;
  end;

procedure Register;

implementation
uses
  Windows;

var
  mailcount           : integer;

procedure Register;

begin
  RegisterComponents( Cons_Palette_Inet, [ TNMSMTP ] );
end;

function StripCRLF( InStr: string ): string;
begin
  if Instr <> '' then
    if InStr[ Length( InStr ) ] = #10 then
      Result := Copy( Instr, 1, Length( InStr ) - 2 )
    else
      Result := Instr;
end;

{*******************************************************************************************
Constructor - Create String Lists to hold body, attachment list and distribution lists.
Sets Default port and clears Transaction in Progress flag.
********************************************************************************************}

constructor TNMSMTP.Create( AOwner: TComponent );

begin
  inherited Create( AOwner );
  try
    Port := SMTP_Port;
    EncodeType := UUMime;
    FTransactionInProgress := FALSE;
    FPostMessage := TPostMessage.create;
    FFinalHeader := TExStringList.create;
    FSenFMem := TmemoryStream.create;
    (*{$IfDef NMF3}
        FSendFile := TS_BufferStream.create(FsenFmem);
    {$ELSE}  *)
    FSendFile := TMemoryStream.create;
    // {$ENDIF}
    FClearParams := TRUE;
    FSubType := mtPlain;
    FCharset := 'us-ascii';
    OnAbortRestart := AbortResume;
    WaitForReset := 2;
  except
    Destroy;
  end;
end;

{*******************************************************************************************
Constructor - Destroys String Lists holding body, attachment list and distribution lists.
********************************************************************************************}

destructor TNMSMTP.Destroy;

begin
  if FPostMessage <> nil then
    FPostMessage.free;
  FFinalHeader.free;
  FSendFile.free;
  FsenFmem.free;
  inherited Destroy;
end;

{*******************************************************************************************
Connect - Calls inherited socket connect and gets reply. Sends Greeting to server
and gets reply.
********************************************************************************************}

procedure TNMSMTP.Connect;

var
  ReplyMess           : string;
  TryCt               : integer;
  ConnCalled, handled : boolean;
  Done                : boolean;
begin
  ConnCalled := FALSE;
  Done := FALSE;
  if FTransactionInProgress then
    ConnCalled := TRUE
  else
    FTransactionInProgress := TRUE;
  try
    inherited Connect;
    try
      ReplyMess := ReadLn;
      ReadExtraLines( ReplyMess );
      if ReplyNumber > 399 then
        raise Exception.create( ReplyMess );
      TryCt := 0;
      repeat
        ReplyMess := Transaction( Cons_Helo + FUserID );
        ReadExtraLines( ReplyMess );
        if ReplyNumber > 299 then
          if TryCt > 0 then
            raise Exception.create( Cons_Msg_Auth_Fail )
          else if not assigned( FOnAuthenticationFailed ) then
            raise Exception.create( Cons_Msg_Auth_Fail )
          else
            begin
              Handled := FALSE;
              FOnAuthenticationFailed( Handled );
              if not Handled then
                raise Exception.create( Cons_Msg_Auth_Fail );
              TryCt := TryCt + 1;
            end;
      until ReplyNumber < 299;
      Done := TRUE;
    except
      DisConnect;
      raise
    end;
  finally
    if not ConnCalled then
      FTransactionInProgress := FALSE;
    if Done then
      if assigned( FOnConnect ) then
        FOnConnect( self );
  end;
end;

{*******************************************************************************************
Disconnect - Sends Quit message to server and gets Reply. Calls inherited disconnect to
close socket.
********************************************************************************************}

procedure TNMSMTP.Disconnect;

var
  ReplyMess           : string;

begin
  Beencanceled := FALSE;
  try
    ReplyMess := Transaction( Cons_Quit );
    if ReplyNumber > 339 then
      raise Exception.create( ReplyMess );
  finally
    inherited DisConnect;
  end;
end;

{*******************************************************************************************
SendMail - Posts a mail message to the server
********************************************************************************************}

procedure TNMSMTP.SendMail;

var
  ReplyMess           : string;
  i, TryCt            : integer;
  Done, Handled       : boolean;
  TAdd                : string;

begin
  if not FTransactionInProgress then
    begin
      Done := FALSE;
      FTransactionInProgress := TRUE;
      try
        AssembleMail;
        CertifyConnect;
        TryCt := 0;
        repeat
          if ( FPostMessage.FFrom = '' ) or ( ( FPostMessage.FTo.count = 0 ) and ( FPostMessage.FCC.count = 0 ) and ( FPostMessage.FBCC.count = 0 ) ) then
            if TryCt > 0 then
              raise Exception.create( sSMTP_Msg_Incomp_Head )
            else if not assigned( FOnHeaderIncomplete ) then
              raise Exception.create( sSMTP_Msg_Incomp_Head )
            else
              begin
                Handled := FALSE;
                if FPostMessage.FFrom = '' then
                  FOnHeaderIncomplete( Handled, hiFromAddress )
                else
                  FOnHeaderIncomplete( Handled, hiToAddress );
                if not Handled then
                  raise Exception.create( sSMTP_Msg_Incomp_Head );
                TryCt := TryCt + 1;
              end;
        until ( FPostMessage.FFrom <> '' ) and ( ( FPostMessage.FTo.count <> 0 ) or ( FPostMessage.FCC.count <> 0 ) or ( FPostMessage.FBCC.count <> 0 ) );
        if assigned( FOnSendStart ) then
          FOnSendStart( self );
        FAbort := FALSE;
        ReplyMess := Transaction( Cons_Rset );
        if ReplyNumber > 399 then
          raise Exception.create( ReplyMess );
        if not FAbort then
          ReplyMess := Transaction( Cons_From + FPostMessage.FFrom + '>' );
        if ReplyNumber > 399 then
          raise Exception.create( ReplyMess );
        if not FAbort then
          for i := 1 to FPostMessage.FTo.Count do
            begin
              Tadd := ExtractAddress( StripCRLF( FPostMessage.FTo.strings[ i - 1 ] ) );
              if Tadd <> '' then
                begin
                  ReplyMess := Transaction( Cons_To + Tadd + '>' );
                  if ReplyNumber > 300 then
                    if Assigned( FRecipientNotFound ) then
                      FRecipientNotFound( FPostMessage.FTo.strings[ i - 1 ] );
                end;
            end;
        if not FAbort then
          for i := 1 to FPostMessage.FCc.Count do
            begin
              Tadd := ExtractAddress( StripCRLF( FPostMessage.FCc.strings[ i - 1 ] ) );
              if Tadd <> '' then
                begin
                  ReplyMess := Transaction( Cons_To + Tadd + '>' );
                  if ReplyNumber > 300 then
                    if Assigned( FRecipientNotFound ) then
                      FRecipientNotFound( FPostMessage.FTo.strings[ i - 1 ] );
                end;
            end;
        if not FAbort then
          for i := 1 to FPostMessage.FBCc.Count do
            begin
              Tadd := ExtractAddress( FPostMessage.FBCc.strings[ i - 1 ] );
              if Tadd <> '' then
                begin
                  ReplyMess := Transaction( Cons_To + Tadd + '>' );
                  if ReplyNumber > 300 then
                    if Assigned( FRecipientNotFound ) then
                      FRecipientNotFound( FPostMessage.FTo.strings[ i - 1 ] );
                end;
            end;
        if not FAbort then
          ReplyMess := Transaction( Cons_Date );
        if ReplyNumber > 399 then
          raise Exception.create( ReplyMess );
        write( FFinalHeader.text + CRLF );
        SendStream( FSendFile );
        ReplyMess := Transaction( CRLF + '.' );
        if ReplyNumber > 399 then
          begin
            if assigned( FOnFailure ) then
              FOnFailure( self );
            raise Exception.create( ReplyMess );
          end
        else
          Done := TRUE;
        if FAbort then
          ReplyMess := Transaction( CRLF + Cons_Rset );
        if FClearParams then
          ClearParameters;
      finally
        FTransactionInProgress := FALSE;
        if Done then
          if assigned( FOnSuccess ) then
            FOnSuccess( self );
      end;
    end;
end;

procedure TNMSMTP.AssembleMail;
var
  i                   : integer;
  Tstr                : string;
begin
  FFinalHeader.clear;
  FFinalHeader.add( Cons_Head_from + FPostMessage.FFromname + '<' + FPostMessage.FFrom + '>' );
  for i := 1 to FPostMessage.FTo.Count do
    begin

      if ( i = 1 ) then
        Tstr := Cons_Head_To + StripCRLF( FPostMessage.FTo.strings[ 0 ] )
      else
        TStr := Tstr + ',' + StripCRLF( FPostMessage.FTo.strings[ i - 1 ] );
      if ( i = FPostMessage.FTo.Count ) then
        FFinalHeader.add( Tstr );
    end;
  for i := 1 to FPostMessage.FCC.Count do
    begin
      if ( i = 1 ) then
        Tstr := Cons_Head_CC + StripCRLF( FPostMessage.FCC.strings[ 0 ] )
      else
        TStr := Tstr + ',' + StripCRLF( FPostMessage.FCC.strings[ i - 1 ] );
      if ( i = FPostMessage.FCC.Count ) then
        FFinalHeader.add( Tstr );
    end;
  FFinalHeader.values[ Cons_Head_subj ] := FPostMessage.FSubject;
  FFinalHeader.values[ Cons_Head_mail ] := FPostMessage.FLocalProgram;
  if ( FPostMessage.FReplyTo <> '' ) then
    FFinalHeader.values[ Cons_Head_ReplyTo ] := FPostMessage.FReplyTo;
  if ( FPostMessage.FDate <> '' ) then
    FFinalHeader.values[ Cons_Head_Date ] := FPostMessage.FDate;
  FFinalHeader.add( Cons_Head_mime );
  if ( FPostMessage.FAttachments.count = 0 ) then
    begin
      case FSubType of
        mtEnriched: FFinalHeader.add( Cons_Head_Enriched + FCharSet );
        mtSgml: FFinalHeader.add( Cons_Head_Sgml + FCharSet );
        mtTabSeperated: FFinalHeader.add( Cons_Head_TabSeperated + FCharSet );
        mtHtml: FFinalHeader.add( Cons_Head_mtHtml + FCharSet );
        else
          FFinalHeader.add( Cons_Head_text + FCharSet );
      end;
      {FFinalHeader.add(Cons_Head_7Bit);    }
    end
  else
    begin
      FBoundary := '====================54535' + TimeToStr( mailcount ) + '====';
      inc( mailcount );
      FFinalHeader.add( Cons_Head_mult + FBoundary + '"' );
    end;
  (*  {$IfDef NMF3}
       FSendFile.Flushbuffer;
   {$ELSE}    *)
  FSendFile.clear;
  // {$ENDIF}
  try
    if ( FPostMessage.FAttachments.count = 0 ) then
      for i := 1 to FPostMessage.FBody.count do
        begin
          TStr := FPostMessage.FBody[ i - 1 ] + CRLF;
          if TStr[ 1 ] = '.' then
            TStr := '.' + TStr;
          FSendFile.write( TStr[ 1 ], length( TStr ) );
        end
    else
      begin
        TStr := '--' + Fboundary + CRLF + Cons_Head_text + FCharSet + CRLF + CRLF;
        FSendFile.write( TStr[ 1 ], length( TStr ) );
        for i := 1 to FPostMessage.FBody.count do
          begin
            TStr := FPostMessage.FBody[ i - 1 ] + CRLF;
            if TStr[ 1 ] = '.' then
              TStr := '.' + TStr;
            FSendFile.write( TStr[ 1 ], length( TStr ) );
          end;

        for i := 1 to FPostMessage.FAttachments.count do
          SendAttachments( i );
        TStr := '--' + Fboundary + '--' + CRLF;
        FSendFile.write( TStr[ 1 ], length( TStr ) );
      end;
    FSendFile.Position := 0;
  finally
    {FSendFile.free; }
  end;
end;

{
function TNMSMTP.CreateTemporaryFileName: string;
var
  nBufferLength: DWord;
  lpPathName, lpTempFileName: PChar;
begin
  Result := '';
  lpPathName := nil;
  lpTempFileName := nil;

  // first get the length of the tempory path
  nBufferLength := GetTempPath( 0, lpPathName );
  Win32Check( BOOL( nBufferLength ) );
  // Allocate a buffer of the specified length + 1
  lpPathName := AllocMem( nBufferLength );
  try
    // Get the tempory path
    Win32Check( BOOL( GetTempPath( nBufferLength, lpPathName ) ) );
    // Increase the tempory path to hold the file name also.
    lpTempFileName := AllocMem( 256 );
    try
      // Get the temporary file name
      Win32Check( BOOL( GetTempFileName( lpPathName, PChar( 'Buf' ), 0, lpTempFileName ) ) );
      // return the file name and path
      SetString( Result, lpTempFileName, StrLen( lpTempFileName ) );
      // Lastly free the buffers.
    finally
      FreeMem( lpPathName );
    end;
  finally
    FreeMem( lpTempFileName );
  end;
  if Result = '' then
    raise Exception.Create( 'Can''t create a temporary file' );
end;
}

{*******************************************************************************************
SendAttachments - Sends attachched file to server.
********************************************************************************************}

procedure TNMSMTP.SendAttachments;

var
  UUPROC              : TNMUUProcessor;
  Tstr                : string;
  //  SFileS: TFileStream;
  SfileF              : TFileStream;
begin
  TStr := '--' + Fboundary + CRLF;
  TStr := TStr + Cons_Head_appl + ExtractFileName( FPostMessage.FAttachments[ i - 1 ] ) + '"' + CRLF;
  TStr := TStr + Cons_Head_ba64 + CRLF;
  TStr := TStr + Cons_Head_disp + ExtractFileName( FPostMessage.FAttachments[ i - 1 ] ) + '"';
  TStr := TStr + CRLF + CRLF;
  FsendFile.write( Tstr[ 1 ], length( Tstr ) );
  //SfileS := nil;
  uuproc := nil;
  try
    uuproc := TNMUUProcessor.create( self );
    //    Tstr := CreateTemporaryFileName;
    //    SFileS := TFileStream.create(Tstr, fmCreate);
    uuproc.method := EncodeType;
    SfileF := TFileStream.create( FPostMessage.FAttachments[ i - 1 ], fmOpenRead );
    uuproc.InPutStream := SfileF;
    uuproc.OutPutStream := FsendFile;
    //    uuproc.OutPutStream := SFileS;
    if assigned( OnEncodeStart ) then
      OnEncodeStart( FPostMessage.FAttachments[ i - 1 ] );
    try
      uuproc.encode;
    except
      on E: EFOpenError do
        begin
          if assigned( OnAttachmentNotFound ) then
            OnAttachmentNotFound( FPostMessage.FAttachments[ i - 1 ] );
          raise;
        end;
    end;

    if assigned( OnEncodeEnd ) then
      OnEncodeEnd( FPostMessage.FAttachments[ i - 1 ] );
    try
      //SFileS.position := 0;
      //FSendFile.CopyFrom(SFileS, SFileS.size);
    finally
      //SFileA.Free;
      SfileF.free;
    end;
  finally
    //SysUtils.DeleteFile( Tstr );
    FsendFile.Position := FsendFile.Size;
    TStr := CRLF;
    FsendFile.write( Tstr[ 1 ], length( Tstr ) );
    //SfileS.Free;
    uuproc.free
  end;

end;

{*******************************************************************************************
Process Extra Lines in Transaction
********************************************************************************************}

procedure TNMSMTP.ReadExtraLines;

begin
  while ( ReplyMess[ 1 ] = ' ' ) or ( ReplyMess[ 4 ] = '-' ) do {If extra Lines}
    ReplyMess := ReadLn;
end;

{*******************************************************************************************
Verify
********************************************************************************************}

function TNMSMTP.Verify( UserName: string ): boolean;
var
  ReplyMess           : string;
begin
  CertifyConnect;
  ReplyMess := Transaction( Cons_Vrfy + Username );
  if ReplyNumber > 251 then
    Result := FALSE
  else
    result := TRUE;
end;

{*******************************************************************************************
Aborts a transaction
********************************************************************************************}

procedure TNMSMTP.Abort;
begin
  inherited abort;
  (*if (not BeenCanceled) and Connected then
  begin
     if FTransactionInProgress then
     begin
        Cancel;
     end
     else
     begin
        inherited Disconnect;
        TMemoryStream(FIstream).clear;
     end;
  end;    *)
end;

procedure TNMSMTP.AbortResume( Sender: TObject );
begin
  inherited DisConnect;
  ClearInput;
end;

{*******************************************************************************************
Aborts a transaction
********************************************************************************************}

function TNMSMTP.ExpandList( MailList: string ): boolean;
var
  ReplyMess           : string;
begin
  Result := FALSE;
  if not FTransactionInProgress then
    begin
      FTransactionInProgress := TRUE;
      try
        CertifyConnect;
        ReplyMess := Transaction( Cons_Expn + MailList );
        if ReplyNumber > 399 then
          Result := FALSE
        else
          begin
            Result := TRUE;
            if assigned( OnMailListReturn ) then
              OnMailListReturn( ReplyMess );
            ReadExtraLines( ReplyMess );
          end;
      finally
        FTransactionInProgress := TRUE;
      end;
    end;
end;

{*******************************************************************************************
Aborts a transaction
********************************************************************************************}

function TNMSMTP.ExtractAddress( TotalAddress: string ): string;

begin
  if Pos( '<', TotalAddress ) > 0 then
    result := NthWord( NthWord( TotalAddress, '<', 2 ), '>', 1 )
  else if Pos( ':', TotalAddress ) > 0 then
    result := NthWord( TotalAddress, ':', 2 )
  else
    result := TotalAddress;
end;

procedure TNMSMTP.SetFinalHeader( Value: TExStringList );
begin
  FFinalHeader.assign( value );
end;

{*******************************************************************************************
Constructor - Create String Lists to hold body, attachment list and distribution lists.
Sets Default port and clears Transaction in Progress flag.
********************************************************************************************}

constructor TPostMessage.Create;

begin
  inherited Create;
  FTO := TStringList.create;
  FCC := TStringList.create;
  FBCC := TStringList.create;
  FBody := TStringList.create;
  FAttachments := TStringList.create;

end;

{*******************************************************************************************
Constructor - Destroys String Lists holding body, attachment list and distribution lists.
********************************************************************************************}

destructor TPostMessage.Destroy;

begin
  FTO.free;
  FCC.free;
  FBCC.free;
  FAttachments.free;
  FBody.free;
  inherited Destroy;
end;

{*******************************************************************************************
ClearParameters - Clears distribution lists and Attachments.
********************************************************************************************}

procedure TNMSMTP.ClearParameters;

begin
  FPostMessage.FTo.clear;
  FPostMessage.FCC.clear;
  FPostMessage.FBCC.clear;
  FPostMessage.FAttachments.clear;
end;
{*******************************************************************************************
Aborts a transaction
********************************************************************************************}

procedure TPostMessage.SetLinesTo( Value: TStringlist );

begin
  FTo.Assign( Value );
end;

{*******************************************************************************************
Aborts a transaction
********************************************************************************************}

procedure TPostMessage.SetLinesCC( Value: TStringlist );

begin
  FCC.Assign( Value );
end;

{*******************************************************************************************
Aborts a transaction
********************************************************************************************}

procedure TPostMessage.SetLinesBCC( Value: TStringlist );
begin
  FBCC.Assign( Value );
end;

{*******************************************************************************************
Aborts a transaction
********************************************************************************************}

procedure TPostMessage.SetLinesBody( Value: TStringlist );
begin
  FBody.Assign( Value );
end;

{*******************************************************************************************
Aborts a transaction
********************************************************************************************}

procedure TPostMessage.SetLinesAttachments( Value: TStringlist );
begin
  FAttachments.Assign( Value );
end;

end.

