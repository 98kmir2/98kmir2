(*
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////
//                                                                       //
//  Copyright ?1997-1999,  NetMasters,  L.L.C - All rights reserved     //
//  worldwide. Portions may be Copyright ?Borland International,  Inc.  //
//                                                                       //
// NNTP:  ( NMNNTP.PAS )                                                 //
//                                                                       //
// DESCRIPTION: Internet/Intranet News Reader/Poster using NNTP Protocol //
//  + Aug-9-98  Version 4.1 -- KNA                                       //
//                                                                       //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY //
// KIND,  EITHER EXPRESSED OR IMPLIED,  INCLUDING BUT NOT LIMITED TO THE //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR //
// PURPOSE.                                                              //
//                                                                       //
///////////////////////////////////////////////////////////////////////////
*)
// Revision History

// 10 27 98 - KNA -  OnDecodeStart and OnDecodeEnd events addded
// 10 27 98 - KNA -  ParseAttachment False case handled
// 10 26 98 - KNA -  Calling of OnHeader, OnBody, OnArticle fixed
// 08 08 21 - KNA -  Line by line Authentication added 
// 08 03 98 - KNA -  Case begin 666 handled and M with no CR fixed
// 06 05 98 - KNA -  BytesTotal and Bytesrecvd implmented
// 06 01 98 - KNA -  OnPacketrecv  implemented;
// 05 20 98 - KNA -  ListEvent fires as data is Recvd;
// 02 05 98 - KNA -  PostRecord , HeaderRecord  Freed;
// 02 05 98 - KNA -  TempBody, TempHeader, FinalHeader  Freed;
// 02 02 98 - KNA -  Add Set Functions to assign values to StringList properties
// 01 27 98 - KNA -  Final release Ver 4.00 VCLS
//
unit NMNNTP;
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

interface

uses
   SysUtils, Classes, Forms, Psock, NMUUE, NMExtstr, NMConst;
{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER120}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}
{$ObjExportAll On}
{$ENDIF}

//  CompName='TNMNNTP';
//  Major_Version='4';
//  Minor_Version='03';
//  Date_Version='020398';

const {protocol}

   Trans_None = 0 ;
   Trans_List = 1 ;

   Cons_USerCmd           = 'USER ';                                       
   Cons_PassCmd           = 'PASS ';                                       
   Cons_QuitCmd           = 'QUIT';                                        
   Cons_GrpCmd            = 'GROUP ';                                      
   Cons_GrpPost           = 'POST';                                        
   Cons_GrpArtl           = 'ARTICLE ';                                    
   Cons_GrpList           = 'LIST';                                        
   Cons_GrpHead           = 'HEAD ';                                       
   Cons_GrpBody           = 'BODY ';                                       
   Cons_HdCSubj           = 'SUBJECT:';                                    
   Cons_HdCFrom           = 'FROM:';                                       
   Cons_HdCType           = 'CONTENT-TYPE:';                               
   Cons_HdCMId            = 'MESSAGE-ID:';                                 
   Cons_HdDate            = 'DATE:';                                       
   Cons_HdLine            = 'LINES:';                                      
   Cons_HdFrom            = 'From: ';                                      
   Cons_HdSubj            = 'Subject: ';                                   
   Cons_HdRply            = 'Reply-To: ';                                  
   Cons_HdNews            = 'NewsGroups: ';                                
   Cons_HdDist            = 'Distribution: ';                              
   Cons_HdOrgz            = 'Organization: ';                              
   Cons_HdMime            = 'Mime-Version: 1.0';                           
   Cons_HdText            = 'Content-Type: text/plain, charset="us-ascii"';
   Cons_HdMult            = 'Content-Type: multipart/mixed;                                                 boundary="';
   Cons_HdApp             = 'Content-Type: application/octet-stream;                      name="';
   Cons_HdBase64          = 'Content-Transfer-Encoding: base64';           
   Cons_HdDisp            = 'Content-Disposition: attachment;                                           filename="';
   

   type
   TPostRecordType        = class(TPersistent)
      
   private
      FPostheader: TExStringList;                                          
      function GetPrFromAddress: string;
      procedure SetPrFromAddress(index: string);
      function GetPrReplyTo: string;
      procedure SetPrReplyTo(index: string);
      function GetPrSubject: string;
      procedure SetPrSubject(index: string);
      function GetPrDistribution: string;
      procedure SetPrDistribution(index: string);
      function GetPrAppName: string;
      procedure SetPrAppName(index: string);
      function GetPrTimeDate: string;
      procedure SetPrTimeDate(index: string);
      function GetNewsGroups: string;
      procedure SetNewsGroups(index: string);
      function GetArticleId: integer;
      function GetPrByteCount: integer;
      function GetPrLineCount: integer;
   published
      property PrFromAddress: string read GetPrFromAddress write SetPrFromAddress;
      property PrReplyTo: string read GetPrReplyTo write SetPrReplyTo;
      property PrSubject: string read GetPrSubject write SetPrSubject;
      property PrDistribution: string read GetPrDistribution write SetPrDistribution;
      property PrAppName: string read GetPrAppName write SetPrAppName;
      property PrTimeDate: string read GetPrTimeDate write SetPrTimeDate;
      property PrNewsGroups: string read GetNewsGroups write SetNewsGroups;
      property PrByteCount: integer read GetPrByteCount;
      property PrLineCount: integer read GetPrLineCount;
      property PrArticleId: integer read GetArticleId;
      
   end; {_ TPostRecordType        = class(TPersistent) _}
   
   TCacheMode = (cmMixed, cmRemote, cmLocal);
   NNTPError = class(Exception);
   TGroupRetrievedEvent = procedure (name: string; FirstArticle, LastArticle: integer; Posting: boolean) of object;
   TGroupRetrievedCacheEvent = procedure (var Handled: boolean; name: string; FirstArticle, LastArticle: integer; Posting: boolean) of object;
   THeaderEvent = procedure (IdNo: integer; From, Subject, MsgId, Date: string; NumberLines: integer) of object;
   THeaderCacheEvent = procedure (var Handled: boolean; IdNo: integer; From, Subject, MsgId, Date: string; ArticleNo: integer) of object;
   TVarFileNameEvent = procedure(var FileName: String) of Object;   
   
   TNMNNTP = class(TPowerSock)
   private
      FTransType: integer;
      FUserId: string; {User ID storage}
      FPassword: string; {Password storage}
      FCacheMode: TCacheMode; {Cache Mode}
      FParseAttachments: Boolean; {Automatically Parse any attachments or not}
      FPosting: Boolean; {Is Posting allowed in newsgroup}
      FSelectedGroup: string; {Currently Selected News Group}
      FLoMessage: integer; {Lowest message in Selected news group}
      FHiMessage: integer; {Highest message in Selected news group}
      FHeader: TExStringList; {The Header of a received news message}
      FHeaderRecord: TPostRecordType;
      FBody: TExStringList; {The Body of a received news message}
      FAttachments: TStringList; {The list of filenames of attachments}
      FPostHeader: TExStringList; {The Header of a received news message}
      FPostRecord: TPostRecordType;
      FPostBody: TExStringList; {The Body of a received news message}
      FPostAttachments: TStringList; {The list of filenames of attachments}
      FArticleList: TStringList;
      FAttachmentPath: string; {The directory to save attachments to}
      FGroupList: TStringList; {The List of Groups in current server}
      FNewsDir: string;
      FTransactionInProgress: boolean;
      FBoundary: string;
      FCurrentArticle: integer;
      WaitforReset: integer;
      {Event Handlers}
      FOnDecodeStart: TVarFileNameEvent;
      FOnDecodeEnd: TNotifyEvent;
      FOnConnect: TNotifyEvent;
      FOnGroupSelect: TNotifyEvent;
      FOnGroupListUpdate: TGroupRetrievedEvent;
      FOnGroupListCacheUpdate: TGroupRetrievedCacheEvent;
      FOnGroupSelectRequired: THandlerEvent;
      FOnHeaderList: TNotifyEvent;
      FOnHeaderListCacheUpdate: THandlerEvent;
      FOnHeader: TNotifyEvent;
      FOnHeaderCacheUpdate: THeaderCacheEvent;
      FOnArticle: TNotifyEvent;
      FOnArticleCacheUpdate: THeaderCacheEvent;
      FOnBody: TNotifyEvent;
      FOnBodyCacheUpdate: THandlerEvent;
      FOnAuthenticationNeeded: THandlerEvent;
      FOnAuthenticationFailed: TNotifyEvent;
      FOnAbort: TNotifyEvent;
      FOnPosted: TNotifyEvent;
      FOnPostFailed: TOnErrorEvent;
      FOnInvalidArticle: TNotifyEvent;
      procedure InternalConnect;
      procedure RetreiveArticle(HBMode: integer; Ref: integer);
      procedure RetreiveList(AGMode: integer; Ref: integer);
      procedure AbortResume(Sender: TObject);
      procedure SetAttachmentPath(Path: string);
      procedure SetNewsDir(Dir: string);
      function ReadTillDot(DestinationList: TStringList; Command: string): boolean;
      procedure ReadTillBlankLine(Ref: integer);
      procedure Readfromcache(DestinationList: TStringList; ArticleNo: integer);
      procedure ExtractAttachments;
      procedure ExtractEmbedded;
      procedure ExtractMultipart;
      procedure Decode(AStream: TStream; var TFileName: string);
      procedure SetPostAttachments(Value: TStringList);
      procedure SetPostBody(Value: TExStringList);
      procedure SetPostHeader(Value: TExStringList);
   protected
      { Protected declarations }
   public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Connect; override;
      procedure Disconnect; override;
      procedure Abort; override;
      procedure SetGroup(Group: string);
      procedure PostArticle;
      procedure GetArticle(Ref: integer);
      procedure GetArticleHeader(Ref: integer);
      procedure GetArticleBody(Ref: integer);
      procedure GetGroupList;
      procedure GetArticleList(All: boolean; ArticleNumber: integer);
      function Transaction(const CommandString: string): string; override;
      property SelectedGroup: string read FSelectedGroup;
      property LoMessage: integer read FLoMessage;
      property HiMessage: integer read FHiMessage;
      property Posting: boolean read FPosting;
      property Header: TExStringList read FHeader;
      property HeaderRecord: TPostRecordType read FHeaderRecord write FHeaderRecord;
      property Body: TExStringList read FBody;
      property Attachments: TStringList read FAttachments;
      property GroupList: TStringList read FGroupList;
      property CurrentArticle: integer read FCurrentArticle;
      
   published
      property OnPacketRecvd;
      property UserId: string read FUserId write FUserId;
      property Password: string read FPassword write FPassword;
      property CacheMode: TCacheMode read FCacheMode write FCacheMode;
      property ParseAttachments: boolean read FParseAttachments write FParseAttachments;
      property AttachFilePath: string read FAttachmentPath write SetAttachmentPath;
      property NewsDir: string read FNewsDir write SetNewsDir;
      property PostHeader: TExStringList read FPostHeader write SetPostHeader;
      property PostBody: TExStringList read FPostBody write SetPostBody;
      property PostAttachments: TStringList read FPostAttachments write SetPostAttachments;
      property PostRecord: TPostRecordType read FPostRecord write FPostRecord;
      {Events}
      property OnConnectionRequired;
      property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
      property OnGroupSelect: TNotifyEvent read FOnGroupSelect write FOnGroupSelect;
      property OnGroupListUpdate: TGroupRetrievedEvent read FOnGroupListUpdate write FOnGroupListUpdate;
      property OnGroupListCacheUpdate: TGroupRetrievedCacheEvent read FOnGroupListCacheUpdate write FOnGroupListCacheUpdate;
      property OnGroupSelectRequired: THandlerEvent read FOnGroupSelectRequired write FOnGroupSelectRequired;
      property OnHeaderList: TNotifyEvent read FOnHeaderList write FOnHeaderList;
      property OnHeaderListCacheUpdate: THandlerEvent read FOnHeaderListCacheUpdate write FOnHeaderListCacheUpdate;
      property OnHeader: TNotifyEvent read FOnHeader write FOnHeader;
      property OnHeaderCacheUpdate: THeaderCacheEvent read FOnHeaderCacheUpdate write FOnHeaderCacheUpdate;
      property OnArticle: TNotifyEvent read FOnArticle write FOnArticle;
      property OnArticleCacheUpdate: THeaderCacheEvent read FOnArticleCacheUpdate write FOnArticleCacheUpdate;
      property OnBody: TNotifyEvent read FOnBody write FOnBody;
      property OnBodyCacheUpdate: THandlerEvent read FOnBodyCacheUpdate write FOnBodyCacheUpdate;
      property OnAuthenticationNeeded: THandlerEvent read FOnAuthenticationNeeded write FOnAuthenticationNeeded;
      property OnAuthenticationFailed: TNotifyEvent read FOnAuthenticationFailed write FOnAuthenticationFailed;
      property OnAbort: TNotifyEvent read FOnAbort write FOnAbort;
      property OnPosted: TNotifyEvent read FOnPosted write FOnPosted;
      property OnPostFailed: TOnErrorEvent read FOnPostFailed write FOnPostFailed;
      property OnInvalidArticle: TNotifyEvent read FOnInvalidArticle write FOnInvalidArticle;
      property OnDecodeStart: TVarFileNameEvent read FOnDecodeStart write FOnDecodeStart;
      property OnDecodeEnd: TNotifyEvent read FOnDecodeEnd write FOnDecodeEnd;
   end; {_ TNMNNTP = class(TPowerSock) _}
   
var
   Stable: array[0..8] of string =
      ('Artid: ',
      'Subject: ',
      'From: ',
      'Date: ',
      'Message-Id: ',
      'References: ',
      'Bytecount: ',
      'Lines: ',
      'Optional-Header: '
      );
   
procedure Register;

implementation

procedure Register;
begin
   RegisterComponents(Cons_Palette_Inet,[TNMNNTP]);
end; {_ procedure register; _}

constructor TNMNNTP.Create;
begin
   inherited Create(AOwner);
   Port := 119;
   OnAbortRestart := AbortResume;
   WaitForReset := 2;
   FPostRecord := TPostRecordType.create;
   FHeaderRecord := TPostRecordType.create;
   FHeader := TExStringList.Create;
   FBody := TExStringList.Create;
   FAttachments := TStringList.Create;
   FPostHeader := TExStringList.Create;
   FPostBody := TExStringList.Create;
   FPostAttachments := TStringList.Create;
   FGroupList := TStringList.Create;
   FArticleList := TStringList.Create;
   FPostRecord.FPostHeader := FPostHeader;
   FHeaderRecord.FPostHeader := FHeader;
   FTransType := Trans_None;
end; {_ constructor TNMNNTP.Create; _}

destructor TNMNNTP.Destroy;
begin
   inherited Destroy;
   FPostRecord.free;
   FHeaderRecord.free;
   FHeader.free;
   FBody.free;
   FAttachments.free;
   FPostHeader.free;
   FPostBody.free;
   FPostAttachments.free;
   FGroupList.free;
   FArticleList.free;
end; {_ destructor TNMNNTP.Destroy; _}

procedure TNMNNTP.Connect;
var
   Done, ConnCalled: boolean;
   
begin
   ConnCalled := FALSE;
   Done := TRUE;
   if FTransactionInProgress then ConnCalled := TRUE else FTransactionInProgress := TRUE;
   try
      InternalConnect;
      Done := TRUE;
   finally
      if not ConnCalled then FTransactionInProgress := FALSE;
      if Done then
         if assigned(OnConnect) and connected
            then OnConnect(self);
   end; {_ try _}
end; {_ procedure TNMNNTP.Connect; _}

procedure TNMNNTP.Disconnect;
var
   ReplyMess: string;
begin
   if FTransactionInProgress then cancel;
   if Connected then
      try
         ReplyMess := Transaction(Cons_QuitCmd);
      finally
         inherited Disconnect;
      end; {_ try _}
end; {_ procedure TNMNNTP.Disconnect; _}

procedure TNMNNTP.Abort;
begin
   Cancel;
   if (not BeenCanceled) and Connected then
   begin
      if FTransactionInProgress then
      begin
         Cancel;
      end {_ if FTransactionInProgress then _}
      else {_ NOT if FTransactionInProgress then _}
      begin
         inherited Disconnect;
         //TMemoryStream(FIstream).clear;
      end; {_ NOT if FTransactionInProgress then _}
   end; {_ if (not BeenCanceled) and Connected then _}
end; {_ procedure TNMNNTP.Abort; _}

procedure TNMNNTP.AbortResume(Sender: TObject);
begin
   inherited DisConnect;
   //TMemoryStream(FIstream).clear;
end; {_ procedure TNMNNTP.AbortResume(Sender: TObject); _}

procedure TNMNNTP.SetAttachmentPath(Path: string);
begin
   if Path[length(Path)] <> '\' then FAttachmentPath := Path + '\'
   else {_ NOT if Path[length(Path)] <> '\' then FAttachmentPath := Path + '\' _} FAttachmentPath := Path;
end; {_ procedure TNMNNTP.SetAttachmentPath(Path: string); _}


procedure TNMNNTP.SetNewsDir(Dir: string);
begin
   if Dir[length(Dir)] <> '\' then
      FNewsDir := Dir + '\'
   else {_ NOT if Dir[length(Dir)] <> '\' then _}
      FNewsDir := Dir;
end; {_ procedure TNMNNTP.SetNewsDir(Dir: string); _}

procedure TNMNNTP.SetGroup(Group: string);
var
   ReplyMess: string; 
   Done     : boolean;
begin
   Done := FALSE;
   if FTransactionInProgress then Exit;
   try
      FTransactionInProgress := TRUE;
      if (CacheMode <> cmLocal) then
      begin
         CertifyConnect;
         ReplyMess := Transaction(Cons_GrpCmd + Group);
         if ReplyNumber > 299 then raise NNTPError.create(sNNTP_Cons_InvGrpErr)
         else {_ NOT if ReplyNumber > 299 then raise NNTPError.create(Cons_InvGrpErr) _} FSelectedGroup := Group;
      end; {_ if (CacheMode <> cmLocal) then _}
      FLoMessage := StrToIntDef(NthWord(ReplyMess, ' ', 3), 0);
      FHiMessage := StrToIntDef(NthWord(ReplyMess, ' ', 4), 0);
      Done := TRUE;
   finally
      FTransactionInProgress := FALSE;
      if done and assigned(OnGroupSelect) then FOnGroupSelect(self);
   end; {_ try _}
end; {_ procedure TNMNNTP.SetGroup(Group: string); _}

procedure TNMNNTP.PostArticle;
var
   ReplyMess: string; 
   Done     : boolean;
   i:integer;
   UUPROC: TNMUUProcessor;
   SFileA: TmemoryStream;
   SfileF : TFileStream;
begin
   Done := FALSE;
   if FTransactionInProgress then Exit;
   try
      FTransactionInProgress := TRUE;
      CertifyConnect;
      ReplyMess := Transaction(Cons_GrpPost);
      write (FpostHeader.text + CRLF + CRLF);
      write (FpostBody.text);
      if FPostAttachments.count>0 then
      begin
         uuproc := TNMUUProcessor.create(self);
         SFileA:=TmemoryStream.create;
         uuproc.method := uuCode;
         uuproc.OutPutStream := SFileA;
         for i:=1 to FPostAttachments.count do
         begin
            SFileA.clear;
            writeln('' + CRLF );
            writeln('begin 666 '+ExtractFileName(FPostAttachments[i-1]));
            //if assigned(OnEncodeStart) then OnEncodeStart(FPostMessage.FAttachments[i - 1]);
            SfileF := TFileStream.create(FPostAttachments[i - 1], fmOpenRead);
            try

               uuproc.InPutStream := SfileF;
               uuproc.encode;
               Sendstream(SfileA);
            except
               on E: EFOpenError do
                 begin
                    //if assigned(OnAttachmentNotFound) then OnAttachmentNotFound(FPostMessage.FAttachments[i - 1]);
                    //raise;
                end; {_ SendAttachments(i); _}
            end; {_ try _}
            SfileF.free;
            //if assigned(OnEncodeEnd) then OnEncodeEnd(FPostMessage.FAttachments[i - 1]);
            writeln('end');
            writeln('' +CRLF);
         end;
         uuproc.free;
         SFileA.free;
      end;
      ReplyMess := Transaction('.');
      if ReplyNumber > 299 then
      begin
         raise NNTPError.create(sNNTP_Cons_PostingErr);
      end {_ if ReplyNumber > 299 then _}
      else {_ NOT if ReplyNumber > 299 then _} Done := TRUE;
   finally
      FTransactionInProgress := FALSE;
      if Done then
   begin if assigned(OnPosted) then OnPosted(self) end
else {_ NOT procedure TNMNNTP.PostArticle; _}
   if assigned(OnPostFailed) then
      OnPostFailed(self, ReplyNumber, TransactionReply);
end; {_ NOT procedure TNMNNTP.PostArticle; _}
end; {_ NOT procedure TNMNNTP.PostArticle; _}



procedure TNMNNTP.GetArticle(Ref: integer);
begin
   RetreiveArticle(3, Ref);
end; {_ procedure TNMNNTP.GetArticle(Ref: integer); _}


procedure TNMNNTP.GetArticleList(All: boolean; ArticleNumber: integer);
begin
   if All or (ArticleNumber < LoMessage) then RetreiveList(2, LoMessage)
   else {_ NOT if All or (ArticleNumber < LoMessage) then RetreiveList(2, LoMessage) _} RetreiveList(2, ArticleNumber);
end; {_ procedure TNMNNTP.GetArticleList(All: boolean; ArticleNumber: integer); _}

procedure TNMNNTP.GetGroupList;
   
begin
   RetreiveList(1, 0);
end; {_ procedure TNMNNTP.GetGroupList; _}

procedure TNMNNTP.GetArticleHeader(Ref: integer);
   
begin
   RetreiveArticle(1, Ref);
end; {_ procedure TNMNNTP.GetArticleHeader(Ref: integer); _}



function TNMNNTP.Transaction(const CommandString: string): string;
var GroupSelected: boolean;
   handled: boolean;

         Procedure AuthFail;
         begin
            if assigned(FOnAuthenticationFailed) then FOnAuthenticationFailed(self);
            raise NNTPError.Create(Cons_Msg_Auth_Fail);
         end;
begin
   BeenCanceled:=False;
   GroupSelected := FALSE;
   while not GroupSelected do
   begin
      GroupSelected := TRUE;
      Result := inherited Transaction(CommandString);
      if ReplyNumber = 480 then
      begin
         if ((FUserID = '') or (FPassword = '')) then
         begin
            Handled := FALSE;
            if assigned(FOnAuthenticationNeeded) then FOnAuthenticationNeeded(Handled);
            if not Handled then AuthFail;
         end; {_ if ((FUserID = '') or (FPassword = '')) then _}
        Result :=inherited Transaction('AUTHINFO USER '+UserID);
        if ReplyNumber=381 then inherited Transaction('AUTHINFO PASS '+Password);
        if ReplyNumber=502 then AuthFail;
        Result := inherited Transaction(CommandString);
        if ReplyNumber=502 then AuthFail;
      end;
      if ReplyNumber = 412 then
      begin
         GroupSelected := FALSE;
         if (SelectedGroup = '') and not assigned(FOnGroupSelectRequired) then raise Exception.create(sNNTP_Cons_GrpErr);
         handled := FALSE;
         if assigned(FOnGroupSelectRequired) then FOnGroupSelectRequired(handled);
         if not handled and (SelectedGroup = '') then raise Exception.create(sNNTP_Cons_GrpErr);
         FTransactionInProgress := FALSE;
         SetGroup(SelectedGroup);
         FTransactionInProgress := TRUE;
      end; {_ if ReplyNumber = 412 then _}
   end; {_ while not GroupSelected do _}
end; {_ function TNMNNTP.Transaction(const CommandString: string): string; _}


procedure TNMNNTP.GetArticleBody(Ref: integer);
   
begin
   RetreiveArticle(2, Ref);
end; {_ procedure TNMNNTP.GetArticleBody(Ref: integer); _}


procedure TNMNNTP.InternalConnect;
var
   ReplyMess: string; 
   handled  : boolean;
begin
   inherited Connect;
   try
      ReplyMess :=  Readln;
      if (ReplyNumber >= 400) and (ReplyNumber <> 480) then EsockError.create(sNNTP_Cons_LogInSerErr);
      if ((ReplyNumber < 400) and (ReplyNumber > 300)) or (ReplyNumber = 480) then
      begin
         if ((FUserID = '') or (FPassword = '')) then
         begin
            Handled := FALSE;
            if assigned(FOnAuthenticationNeeded) then FOnAuthenticationNeeded(Handled);
            if not Handled then raise NNTPError.Create(Cons_Msg_Auth_Fail);
         end; {_ if ((FUserID = '') or (FPassword = '')) then _}
         ReplyMess := Transaction(Cons_USerCmd + FUserID);
         if (ReplyNumber >= 400) and (ReplyNumber <> 480) then EsockError.create(sNNTP_Cons_LogInSerErr);
         if ((ReplyNumber < 400) and (ReplyNumber > 300)) or (ReplyNumber = 480) then
            ReplyMess := Transaction(Cons_PassCmd + FPassword);
         if ReplyNumber > 299 then
         begin
            if assigned(FOnAuthenticationFailed) then FOnAuthenticationFailed(self);
            raise NNTPError.Create(Cons_Msg_Auth_Fail);
         end; {_ if ReplyNumber > 299 then _}
      end; {_ if ((ReplyNumber < 400) and (ReplyNumber > 300)) or (ReplyNumber = 480) then _}
   except
      Disconnect;
      raise;
   end; {_ try _}
end; {_ procedure TNMNNTP.InternalConnect; _}


procedure TNMNNTP.RetreiveArticle(HBMode: integer; Ref: integer);
   
   function IsInCache(HBMode, I: integer): boolean;
      
   begin
      result := False;
   end; {_ function IsInCache(HBMode, I: integer): boolean; _}
   
var LCM: integer;
   Done, result: boolean;
   
begin
   Done := FALSE;
   Result := FALSE;
   LCM := 1;
   if FTransactionInProgress then Exit;
   try
      FTransactionInProgress := TRUE;
      CertifyConnect;
      if (CacheMode <> cmMixed) and IsInCache(HBMode, ref) then LCM := 1
      else {_ NOT if (CacheMode <> cmMixed) and IsInCache(HBMode, ref) then LCM := 1 _} LCM := 3;
      case LCM of
         1:
         begin
            if (HBMode and $1) <> 0 then Readfromcache(FHeader, Ref);
            if (HBMode and $2) <> 0 then Readfromcache(FBody, Ref);
         end; {_ 1: _}
         3:
         begin
            case HBMode of
               1:
               begin
                  Result := ReadTillDot(FHeader, 'HEAD ' + IntToStr(Ref));
                  FHeader.values['ArtId'] := IntToStr(Ref);
                  Done := TRUE;
               end; {_ 1: _}
               2:
               begin
 //                 FBytesTotal:=StrToIntdef(FHeader.values['Lines'],0);
                  Result := ReadTillDot(FBody, 'BODY' + IntToStr(Ref));
                  Done := TRUE;
               end; {_ 2: _}
               3:
               begin
                  ReadTillBlankLine(Ref);
                  FBytesTotal:=StrToIntdef(FHeader.values['Lines'],0);
                  Result := ReadTillDot(FBody, '');
                  if FParseAttachments then
                     ExtractAttachments;
                  FHeader.values['ArtId'] := IntToStr(Ref);
                  Done := TRUE;
               end; {_ 3: _}
            end; {_ case HBMode of _}
            if not Result then raise NNTPError.create(sNNTP_Cons_RetrErr);
         end; {_ 3: _}
         
      end; {_ case LCM of _}
      FCurrentArticle := Ref;
   finally
      FTransactionInProgress := FALSE;
      if Done then
         case HBMode of
            1: if assigned(FOnHeader) then FOnHeader(Self);
            2: if assigned(FOnBody) then FOnBody(Self);
            3: if assigned(FOnArticle) then FOnArticle(Self);
         end; {_ case LCM of _}
   end; {_ try _}
end; {_ procedure TNMNNTP.RetreiveArticle(HBMode: integer; Ref: integer); _}

procedure TNMNNTP.RetreiveList(AGMode: integer; Ref: integer);
var
   i, j, k   : integer;
   AStr, Bstr: string; 
begin
   if FTransactionInProgress then Exit;
   try
      FTransactionInProgress := TRUE;
      case AGmode of
         1: if cacheMode <> cmLocal then
         begin
            CertifyConnect;
            FTransType := Trans_List;
            ReadTillDot(FGroupList, 'LIST');
            FTransType := Trans_None;
         end; {_ 1: if cacheMode <> cmLocal then _}
         2:
         begin
            if cacheMode <> cmLocal then
            begin
               CertifyConnect;
               if (ReadTillDot(FArticleList, 'XOVER ' + IntToStr(Ref) + '-' + IntToStr(HiMessage))) then
                  for i := 1 to FArticleList.count - 1 do
                  begin
                     FHeader.clear;
                     BStr := FArticleList[i - 1];
                     j := POS(#13, BStr);
                     if j > 0 then BStr[j] := #0;
                     k := 0;
                     repeat
                        j := Pos(#9, BStr);
                        if j > 0 then
                        begin
                           Astr := COPY(BStr, j + 1, 255);
                           SetLength(BStr,j-1);
                        end; {_ if j > 0 then _}
                         FHeader.add(Stable[k] + BStr);
                        Bstr := AStr;
                        inc(k);
                     until (j = 0) or (k=9);
                     if assigned(FOnHeaderList) then FOnHeaderList(self);
                  end {_ for i := 1 to FArticleList.count - 1 do _}
               else {_ NOT if (ReadTillDot(FArticleList, 'XOVER ' + IntToStr(Ref) + '-' + IntToStr(HiMessage))) then _}
                  for i := ref to HiMessage do
                  begin
                     ReadTillDot(FHeader, 'HEAD ' + IntToStr(i));
                     if assigned(FOnHeaderList) then FOnHeaderList(self);
                  end; {_ for i := ref to HiMessage do _}
            end; {_ if cacheMode <> cmLocal then _}
         end; {_ 2: _}
      end; {_ case AGmode of _}
   finally
      FTransactionInProgress := FALSE;
   end; {_ try _}
end; {_ procedure TNMNNTP.RetreiveList(AGMode: integer; Ref: integer); _}

function TNMNNTP.ReadTillDot(DestinationList: TStringList; Command: string): boolean;
var
   ReplyMess: string;
begin
   result := TRUE;
   FBytesRecvd := 0;
   DestinationList.clear;
   if Command <> '' then ReplyMess := Transaction(Command);
   if ReplyNumber > 299 then result := FALSE
   else {_ NOT if ReplyNumber > 299 then result := FALSE _}
      repeat
         ReplyMess := ReadLn;
         inc(FBytesRecvd);
         if assigned(OnPacketRecvd) then OnPacketRecvd(self);
         SetLength(ReplyMess, Length(ReplyMess) - 2);
         DestinationList.Add(ReplyMess);
         if ReplyMess <> '.' then
            if FtransType = Trans_List then
               if assigned(OnGroupListUpdate) then
                  OnGroupListUpdate(NthWord(ReplyMess, ' ', 1), StrToInt(NthWord(ReplyMess, ' ', 2)), StrToInt(NthWord(ReplyMess, ' ', 3)), NthWord(ReplyMess, ' ', 4) = 'F');
     until (ReplyMess = '.');
end; {_ function TNMNNTP.ReadTillDot(DestinationList: TStringList; Command: string): boolean; _}





procedure TNMNNTP.ReadTillBlankLine(Ref: integer);
var
   ReplyMess: string;
begin
   FHeader.Clear;
   ReplyMess := Transaction('ARTICLE ' + IntToStr(Ref));
   if ReplyNumber < 299 then
      repeat
         ReplyMess := ReadLn;
         SetLength(ReplyMess, Length(ReplyMess) - 2);
         FHeader.Add(ReplyMess);
      until (ReplyMess = '')
   else {_ NOT if ReplyNumber < 299 then _}
      begin
        if ReplyNumber=423 then
           FOnInvalidArticle(self);
        raise Exception.create(sNNTP_Cons_ArtErr);
      end;
end; {_ procedure TNMNNTP.ReadTillBlankLine(Ref: integer); _}


procedure TNMNNTP.Readfromcache(DestinationList: TStringList; ArticleNo: integer);
begin
end; {_ procedure TNMNNTP.Readfromcache(DestinationList: TStringList; ArticleNo: integer); _}

procedure TNMNNTP.ExtractAttachments;
var
   AStr: string;
begin
   AStr := FHeader.values['Content-Type'];
   if Astr = '' then ExtractEmbedded
   else {_ NOT if Astr = '' then ExtractEmbedded _}
      if (Pos('multipart', Lowercase(AStr)) <> 0) then
      begin
         FBoundary := Copy(AStr, Pos('dary=', AStr) + 7, 256);
         if FBoundary[1] = #22 then
            SetLength(FBoundary, Length(FBoundary) - 2)
         else {_ NOT if FBoundary[1] = #22 then _}
         begin
            SetLength(FBoundary, Length(FBoundary) - 3);
            FBoundary := Copy(FBoundary, 2, 255);
         end; {_ NOT if FBoundary[1] = #22 then _}
         ExtractMultipart;
      end {_ if (Pos('multipart', Uppercase(AStr)) <> 0) then _}
      else {_ NOT if (Pos('multipart', Uppercase(AStr)) <> 0) then _} ExtractEmbedded;
end; {_ procedure TNMNNTP.ExtractAttachments; _}

procedure TNMNNTP.ExtractEmbedded;
var i: integer;
   Pmode              : boolean;    
   TFilename          : string;     
   TempBody           :TStringStream;
   FinalBody: TstringList;
begin
   Pmode := FALSE;
   TempBody := TStringStream.create('');
   FinalBody := TStringList.create;
   try
      i := -1;
      repeat
         inc(i);
         if ((length(Body[i]) = 61) and (Pos(' ', Body[i]) = 0)) or (Pos('begin 644', Body[i]) > 0) or (Pos('begin 666', Body[i]) > 0) then
         begin
            if (Pos('begin 644', Body[i]) > 0) or (Pos('begin 666', Body[i]) > 0) then
            begin
               Pmode := TRUE;
               TFilename := NthWord(Body[i], ' ', 3);
               inc(i);     //Added KNA 6-24-98
            end {_ if Pos('begin 644', Body[i]) > 0 then _}
            else {_ NOT if Pos('begin 644', Body[i]) > 0 then _} TFilename := 'extract.dat';
            {$IFDEF NMF3} TempBody.Size:=0{$ELSE} TempBody.SetSize(0){$ENDIF};
            repeat
               TempBody.WriteString(Body[i]);
               inc(i);
            until ((not Pmode) and (length(Body[i]) <> 61)) or (PMode and (Pos('end', Body[i]) > 0));
            if assigned(FOnDecodeStart) then
                FOnDecodeStart(TFilename);
            Decode(TempBody, TFilename);
            if assigned(FOnDecodeEnd) then
                FOnDecodeEnd(self);
            Attachments.Add(TFileName);
            FinalBody.add(#13#10 + sNNTP_Cons_FileMsg1 + FAttachmentPath + TFileName + sNNTP_Cons_FileMsg2);
         end {_ if ((length(Body[i]) = 61) and (Pos(' ', Body[i]) = 0)) or (Pos('begin 644', Body[i]) > 0) then _}
         else {_ NOT if ((length(Body[i]) = 61) and (Pos(' ', Body[i]) = 0)) or (Pos('begin 644', Body[i]) > 0) then _} FinalBody.add(Body[i]);
      until Body[i] = '.';
      Body.assign(FinalBody);
   finally
      TempBody.free;
      FinalBody.free;
   end; {_ try _}
end; {_ procedure TNMNNTP.ExtractEmbedded; _}

procedure TNMNNTP.ExtractMultipart;
var i: integer;
   TempHead : TExStringList;
   Tempbody : TStringStream;
   FinalBody          : TExStringList;
   ReplyMess          : string;       
   TFileName, Ct1, Ct2: string;       
begin
   i := 0;
   TempHead := TExStringList.create;
   TempBody := TStringStream.create('');
   FinalBody := TExStringList.create;
   try
      while Pos(FBoundary, FBody[i]) = 0 do inc(i);
      repeat
         TempHead.clear;
         {$IFDEF NMF3} TempBody.Size:=0{$ELSE} TempBody.SetSize(0){$ENDIF};
         repeat
            inc(i);
            Temphead.add(FBody[i]);
         until FBody[i] = '';
         repeat
            inc(i);
            TempBody.WriteString(FBody[i]);
         until Pos(FBoundary, FBody[i]) > 0;
         Ct1 := Temphead.values['Content-Type:'];
         Ct2 := Temphead.values['Content-Transfer-Encoding'];
         if Pos('text', Ct1) > 0 then FinalBody.add(TempBody.DataString)
         else {_ NOT if Pos('text', Ct1) > 0 then FinalBody.add(TempBody.text) _}
         begin
            if Pos('name', Ct1) > 0 then TFileName := NthWord(ReplyMess, '"', 2)
            else {_ NOT if Pos('name', Ct1) > 0 then TFileName := NthWord(ReplyMess, '"', 2) _} TFileName := 'Extract.dat';
            if (Pos('base64', Ct2) > 0) or (Pos('Base64', Ct2) > 0) or (Pos('X-UUENCODE', Ct2) > 0) then
               Decode(TempBody, TFileName)
            else {_ NOT if (Pos('base64', Ct2) > 0) or (Pos('Base64', Ct2) > 0) or (Pos('X-UUENCODE', Ct2) > 0) then _} {TempBody.SaveToFile(TFileName)};
            Attachments.Add(TFileName);
            FinalBody.add(#13#10 + sNNTP_Cons_FileMsg1 + FAttachmentPath + TFileName + sNNTP_Cons_FileMsg2);
         end; {_ NOT if Pos('text', Ct1) > 0 then FinalBody.add(TempBody.text) _}
      until Pos(FBoundary + '--', FBody[i]) > 0;
      while FBody[i] <> '.' do inc(i);
      FBody.assign(Finalbody);
   finally
      TempHead.free;
      TempBody.free;
      FinalBody.free;
   end; {_ try _}
end; {_ procedure TNMNNTP.ExtractMultipart; _}

procedure TNMNNTP.Decode(AStream: TStream; var TFileName: string);
var i: integer;
   Tempcode        : TFileStream;   
   uuproc          : TNMUUProcessor;
   TFname1, TFname2: string;        
begin
   TFname1 := NthWord(TFileName, '.', 1);
   TFname2 := NthWord(TFileName, '.', 2);
   i := 1;
   while FileExists(FAttachmentPath + TFileName) do
   begin
      TFileName := TFName1 + '_' + IntToStr(i) + '.' + TFName2;
      i := i + 1;
   end; {_ while FileExists(FAttachmentPath + TFileName) do _}
   Tempcode := TFileStream.create(FAttachmentPath + TFileName, fmCreate);
   try
      uuproc := TNMUUProcessor.create(self);
      uuproc.method := uucode;
//      uuproc.method := uumime;  
      uuproc.OutputStream := Tempcode;
      uuproc.InPutStream := AStream;
      AStream.position := 0;
      uuproc.decode;
      uuproc.free;
   finally
      Tempcode.free;
   end; {_ try _}
end; {_ procedure TNMNNTP.Decode(AStringList: TStringList; var TFileName: string); _}

procedure TNMNNTP.SetPostAttachments(Value: TStringList);
begin
   FPostAttachments.assign(value);
end; {_ procedure TNMNNTP.SetPostAttachments(Value: TStringList); _}

procedure TNMNNTP.SetPostBody(Value: TExStringList);
begin
   FPostBody.assign(value);
end; {_ procedure TNMNNTP.SetPostBody(Value: TExStringList); _}

procedure TNMNNTP.SetPostHeader(Value: TExStringList);
begin
   FPostHeader.assign(value);
end; {_ procedure TNMNNTP.SetPostHeader(Value: TExStringList); _}

function TPostRecordType.GetPrLineCount;
begin result := StrToInt(FPostHeader.values['Lines']) end;
function TPostRecordType.GetPrByteCount;
begin result := StrToInt(FPostHeader.values['Bytecount']) end;
function TPostRecordType.GetPrFromAddress;
begin result := FPostHeader.values['From'] end;
procedure TPostRecordType.SetPrFromAddress;
begin FPostHeader.values['From'] := index end;
function TPostRecordType.GetPrReplyTo;
begin result := FPostHeader.values['ReplyTo'] end;
procedure TPostRecordType.SetPrReplyTo;
begin FPostHeader.values['ReplyTo'] := index end;
function TPostRecordType.GetPrSubject;
begin result := FPostHeader.values['Subject'] end;
procedure TPostRecordType.SetPrSubject;
begin FPostHeader.values['Subject'] := index end;
function TPostRecordType.GetPrDistribution;
begin result := FPostHeader.values['Distribution'] end;
procedure TPostRecordType.SetPrDistribution;
begin FPostHeader.values['Distribution'] := index end;
function TPostRecordType.GetPrAppName;
begin result := FPostHeader.values['X-Newsreader'] end;
procedure TPostRecordType.SetPrAppName;
begin FPostHeader.values['X-Newsreader'] := index end;
function TPostRecordType.GetPrTimeDate;
begin result := FPostHeader.values['Date'] end;
procedure TPostRecordType.SetPrTimeDate;
begin FPostHeader.values['Date'] := index end;
function TPostRecordType.GetNewsGroups;
begin result := FPostHeader.values['Newsgroups'] end;
procedure TPostRecordType.SetNewsGroups;
begin FPostHeader.values['Newsgroups'] := index end;
function TPostRecordType.GetArticleID;
begin
   result := StrToIntDef(FPostHeader.values['ArtID'], 0);
end; {_ function TPostRecordType.GetArticleID; _}
end.

