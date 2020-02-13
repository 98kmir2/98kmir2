{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide.   //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMPOP3                                                      //
//                                                                        //
// DESCRIPTION:Internet/Intranet POP3 Component  for retriving e-mail     //
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
// 01 26 00 - KNA - Eliminate Residual temp.mme files
// 01 21 00 - KNA - If attachment exists and
//                  no decode it didnt copy over to old - fixed
// 07 27 99 - KNA - BytesTotal and BytesRecvd implemented
// 01 07 99 - BD  - To support files with multiple .s
// 01 07 99 - KNA - -Err handled properly in both cases
// 11 21 98 - KNA - Look for '.' to end message at beginning of loop
// 08 09 98 - ETS - Added OnDecodeStart event to allow renaming attachments
// 08 09 98 - ETS - Wrote write access method for AttachFilePath property to add trailing backslash
// 08 03 98 - KNA - Simple Cancel on Abort
// 07 22 98 - KNA - OnRetrive events added for backward compatiblity
// 07 10 98 - KNA - Boundary Parsing moved
// 07 08 98 - KNA - Unique Id function added
// 06 22 98 - KNA - base64 all cases decoded
// 06 08 98 - KNA - OnPacketRecvd added
// 05 20 98 - KNA - Summary fields cleared , so blank field wouldnt give error
// 05 13 98 - KNA - base64 encoded body - unencoded
// 05 02 98 - KNA - Body of Summary available to user
// 02 05 98 - KNA - Ins, Ous create and destroy in try finally loop for robustness
// 01 27 98 - KNA - Final release Ver 4.00 VCLS
// 01 17 98 - KNA - OnConnect moved out of TransactionInProcess to enable Processing
//        in Event
unit NMpop3;
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
  Classes, PSock, Sysutils, NMUUE, NMExtstr, NMConst;
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
  POP3_PORT = 110;

   //  CompName     ='NMPOP3';
   //  Major_Version='4';
   //  Minor_Version='02';
   //  Date_Version ='012798';

const {Protocol}
  Cons_OK_Resp = '+OK';
  Cons_Err_Resp = '-ERR';
  Cons_Cmd_User = 'USER ';
  Cons_Cmd_Pass = 'PASS ';
  Cons_Cmd_Stat = 'STAT';
  Cons_Cmd_Quit = 'QUIT';
  Cons_Cmd_Top = 'TOP ';
  Cons_Cmd_List = 'LIST ';
  Cons_Cmd_Retr = 'RETR ';
  Cons_Cmd_Dele = 'DELE ';
  Cons_Cmd_Rset = 'RSET';
  Cons_Cmd_Uidl = 'UIDL ';
  Cons_Head_CSubj = 'SUBJECT:';
  Cons_Head_CFrom = 'FROM:';
  Cons_Head_CType = 'CONTENT-TYPE:';
  Cons_Head_CMid = 'MESSAGE-ID:';
  Cons_Head_CBoun = 'BOUNDARY=';
  Cons_Head_CCTE = 'CONTENT-TRANSFER-ENCODING';
  Cons_Head_FileN = 'FILENAME';
  Cons_Head_Subj = 'Subject:';
  Cons_Head_From = 'From:';
  Cons_Head_MId = 'Message-ID:';
  Cons_Head_Mult = 'multipart';
  Cons_Head_UUEn = 'X-UUENCODE';
  Cons_Head_B641 = 'base64';
  Cons_Head_B642 = 'Base64';





type
  TListEvent = procedure(Msg, Size: integer) of object;
      // Modification made by Edward T. Smith Sep 09 1998
  TVarFileNameEvent = procedure(var FileName: string) of object;
      // End

  TMailMessage = class(TPersistent)
  private
    FHead: TexStringList;
    FRawBody: TStringList;
    FBody: TStringList;
    Fcontenttypes, FAttachments: TStringList;
    FPartHeaders: TList;
    FContentType: string;
    FFrom: string;
    FSubject: string;
    FMessageId: string;

  public
    FBoundary: string;
    constructor Create;
    destructor Destroy; override;
    property Subject: string read FSubject;
    property From: string read FFrom;
    property RawBody: TStringList read FRawBody;
    property Body: TStringList read FBody;
    property Head: TExStringList read FHead;
    property MessageId: string read FMessageId write FMessageId;
    property ContentType: string read FContentType write FContentType;
    property Attachments: TStringList read FAttachments;
    property AttachContenttypes: TStringList read FContentTypes;
    property PartHeaders: TList read FPartHeaders;
  end; {_ TMailMessage      = class(TPersistent) _}

  TSummary = class(TPersistent)
  private
    FSubject: string;
    FFrom: string;
    FBytes: integer;
    FMessageId: string;
    FHeader: TExStringList;
  published
    constructor Create;
    destructor Destroy; override;
    property Subject: string read FSubject write FSubject;
    property From: string read FFrom write FFrom;
    property MessageId: string read FMessageId write FMessageId;
    property Bytes: integer read FBytes write FBytes;
    property Header: TExStringList read FHeader write FHeader;
  end; {_ TSummary          = class(TPersistent) _}

  TNMPOP3 = class(TPowerSock)
  private
      // Modification made by Edward T. Smith Sep 09 1998
    FOnDecodeStart: TVarFileNameEvent;
    FOnDecodeEnd: TNotifyEvent;
      // End
    NMUUProcessor1: TNMUUProcessor;
    FAttachFilePath, FFilename, FContent_type: string;
    FSummary: TSummary;
    FParse: boolean;
    FMailMessage: TMailMessage;
    FUserID, FPassword: string;
    FAbort, FDeleteOnRead, FTransactionInProgress: boolean;
    FMailCount, FFirstPart: integer;
    FOnAuthenticationNeeded: THandlerEvent;
    FOnAuthenticationFailed: THandlerEvent;
    FOnReset: TNotifyEvent;
    FOnList: TListEvent;
    FOnRetrieveStart: TNotifyEvent;
    FOnRetrieveEnd: TNotifyEvent;
    FOnSuccess: TNotifyEvent;
    FOnFailure: TNotifyEvent;
    FOnConnect: TNotifyEvent;
    WaitForReset: integer;
    procedure ReadMailParts;
    function ReadBody(var MailMessage: TMailMessage): boolean;
    procedure ReadHeader(Readfile: boolean; var MailMessage: TMailMessage);
    procedure AbortResume(Sender: TObject);
    procedure SetAttachFilePath(Value: string);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect; override;
    procedure Disconnect; override;
    procedure GetMailMessage(MailNumber: integer);
    procedure GetSummary(MailNumber: integer);
    procedure DeleteMailMessage(MailNumber: integer);
    procedure Extract(InString: string; var OutString: string);
    function UniqueID(MailNumber: integer): string;
    procedure Reset;
    procedure List;
    procedure Abort; override;
    property MailCount: integer read FMailCount;
    property Summary: TSummary read FSummary;
    property MailMessage: TMailMessage read FMailMessage;
    property OnRetriveStart: TNotifyEvent read FOnRetrieveStart write FOnRetrieveStart;
    property OnRetriveEnd: TNotifyEvent read FOnRetrieveEnd write FOnRetrieveEnd;

  published
    property OnConnectionRequired;
    property OnPacketRecvd;
    property BytesRecvd;
    property BytesTotal;
    property UserID: string read FUserID write FUserID;
    property Parse: boolean read FParse write FParse;
    property Password: string read FPassword write FPassword;
    property DeleteOnRead: boolean read FDeleteOnRead write FDeleteOnRead;
      // Modification made by Edward T. Smith Sep 09 1998
    property AttachFilePath: string read FAttachFilePath write SetAttachFilePath;
      // End
    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
    property OnAuthenticationNeeded: THandlerEvent read FOnAuthenticationNeeded write FOnAuthenticationNeeded;
    property OnAuthenticationFailed: THandlerEvent read FOnAuthenticationFailed write FOnAuthenticationFailed;
    property OnReset: TNotifyEvent read FOnReset write FOnReset;
    property OnList: TListEvent read FOnList write FOnList;
    property OnRetrieveStart: TNotifyEvent read FOnRetrieveStart write FOnRetrieveStart;
    property OnRetrieveEnd: TNotifyEvent read FOnRetrieveEnd write FOnRetrieveEnd;
    property OnSuccess: TNotifyEvent read FOnSuccess write FOnSuccess;
    property OnFailure: TNotifyEvent read FOnFailure write FOnFailure;
      // Modification made by Edward T. Smith Sep 09 1998
    property OnDecodeStart: TVarFileNameEvent read FOnDecodeStart write FOnDecodeStart;
    property OnDecodeEnd: TNotifyEvent read FOnDecodeEnd write FOnDecodeEnd;
      // End
  end; {_ TNMPOP3           = class(TPowerSock) _}

procedure Register;

implementation
var Readindex, TFileIndex: integer;

procedure Register;
begin
  RegisterComponents(Cons_Palette_Inet, [TNMPOP3]);
end; {_ procedure register; _}

constructor TSummary.Create;

begin
  inherited Create;
  FHeader := TExStringList.Create;

end;

destructor TSummary.Destroy;

begin
  FHeader.Free;
  inherited Destroy;
end;


// Modification made by Edward T. Smith Sep 09 1998

procedure TNMPOP3.SetAttachFilePath(Value: string);
begin
  if Value[Length(Value)] <> '\' then
    Value := Value + '\';
  FAttachFilePath := Value;
end;
// End

constructor TNMPOP3.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  Port := POP3_Port;
  FMailMessage := TMailMessage.create;
  FSummary := TSummary.create;
  FDeleteOnRead := FALSE;
  FTransactionInProgress := FALSE;
  FAttachFilePath := '';
  OnAbortRestart := AbortResume;
  WaitForReset := 2;
  NMUUProcessor1 := TNMUUProcessor.create(self);
end; {_ constructor TNMPOP3.Create(AOwner: TComponent); _}


destructor TNMPOP3.Destroy;

begin
  FSummary.free;
  FMailMessage.free;
  NMUUProcessor1.free;
  inherited Destroy;
end; {_ destructor TNMPOP3.Destroy; _}



procedure TNMPOP3.Connect;
var
  ReplyMess: string;
  Check: boolean;
  TryCt: integer;
  Done, ConnCalled, Handled: boolean;

  function CheckAuth(FromHost: string): boolean;
  begin
    if Pos(Cons_OK_Resp, NthWord(ReplyMess, ' ', 1)) > 0 then Result := TRUE
    else {_ NOT if Pos(Cons_OK_Resp, NthWord(ReplyMess, ' ', 1)) > 0 then Result := TRUE _}
      begin
        Result := FALSE;
        if TryCt > 0 then raise Exception.create(Cons_Msg_Auth_Fail)
        else {_ NOT if TryCt > 0 then raise Exception.create(Cons_Msg_Auth_Fail) _}
          if not assigned(FOnAuthenticationFailed) then
            raise Exception.create(Cons_Msg_Auth_Fail)
          else {_ NOT if not assigned(FOnAuthenticationFailed) then raise Exception.create(Cons_Msg_Auth_Fail) _}
            begin
              Handled := FALSE;
              FOnAuthenticationFailed(Handled);
              if not Handled then raise Exception.create(Cons_Msg_Auth_Fail);
              TryCt := TryCt + 1;
            end; {_ NOT if not assigned(FOnAuthenticationFailed) then raise Exception.create(Cons_Msg_Auth_Fail) _}
      end; {_ NOT if Pos(Cons_OK_Resp, NthWord(ReplyMess, ' ', 1)) > 0 then Result := TRUE _}
  end; {_ function CheckAuth(FromHost: string): boolean; _}

begin
  Done := FALSE;
  TryCt := 0;
  while (Password = '') or (UserID = '') do
    if not assigned(FOnAuthenticationNeeded) then raise Exception.create(Cons_Msg_Auth_Fail)
    else {_ NOT if not assigned(FOnAuthenticationNeeded) then raise Exception.create(Cons_Msg_Auth_Fail) _}
      begin
        if TryCt > 0 then break;
        handled := FALSE;
        FOnAuthenticationNeeded(Handled);
        if not handled then raise Exception.create(Cons_Msg_Auth_Fail);
        inc(TryCt);
      end; {_ NOT if not assigned(FOnAuthenticationNeeded) then raise Exception.create(Cons_Msg_Auth_Fail) _}
  ConnCalled := FALSE;
  if FTransactionInProgress then ConnCalled := TRUE else FTransactionInProgress := TRUE;
  try
    inherited Connect;
    try
      ReplyMess := ReadLn;
      if Pos(Cons_OK_Resp, NthWord(ReplyMess, ' ', 1)) = 0 then raise Exception.create(ReplyMess);
      Check := FALSE; TryCt := 0;
      while not check do
        begin
          ReplyMess := Transaction(Cons_Cmd_User + FUserID);
          if CheckAuth(ReplyMess) then
            begin
              ReplyMess := Transaction(Cons_Cmd_Pass + FPassword);
              Check := CheckAuth(ReplyMess)
            end; {_ if CheckAuth(ReplyMess) then _}
          TryCt := TryCt + 1;
        end; {_ while not check do _}
      Done := TRUE;
      ReplyMess := Transaction(Cons_Cmd_Stat);
      if Pos(Cons_OK_Resp, NthWord(ReplyMess, ' ', 1)) = 0 then raise Exception.create(ReplyMess);
      FMailCount := StrToIntDef(NthWord(ReplyMess, ' ', 2), 0);
    except
      Disconnect;
      raise
    end; {_ try _}
  finally
    if not ConnCalled then FTransactionInProgress := FALSE;
    if Done then
      if assigned(FOnConnect) then
        FOnConnect(self);
  end; {_ try _}
end; {_ procedure TNMPOP3.Connect; _}

procedure TNMPOP3.Disconnect;
var ReplyMess: string;
begin
  if Connected then
    try
      ReplyMess := Transaction(Cons_Cmd_Quit);
      if Pos(Cons_OK_Resp, NthWord(ReplyMess, ' ', 1)) = 0 then raise Exception.create(ReplyMess);
    finally
      inherited Disconnect;
    end; {_ try _}
end; {_ procedure TNMPOP3.Disconnect; _}

procedure TNMPOP3.GetSummary(MailNumber: integer);
var ReplyMess: string;
begin
  if not FTransactionInProgress then
    begin
      FTransactionInProgress := TRUE;
      try
        CertifyConnect;
        if assigned(FOnRetrieveStart) then FOnRetrieveStart(self);
        FAbort := FALSE;
        ReplyMess := Transaction(Cons_Cmd_Top + IntToStr(MailNumber) + ' 0');
        if Pos(Cons_OK_Resp, NthWord(ReplyMess, ' ', 1)) = 0 then raise Exception.create(ReplyMess);
        FSummary.FHeader.clear;
        FSummary.FSubject := '';
        FSummary.FFrom := '';
        FSummary.FMessageID := '';
        if not FAbort then
          repeat
            ReplyMess := readln;
            if Pos(Cons_Head_Subj, ReplyMess) = 1 then FSummary.FSubject := Copy(ReplyMess, 9, length(ReplyMess) - 10);
            if Pos(Cons_Head_From, ReplyMess) = 1 then FSummary.FFrom := Copy(ReplyMess, 6, length(ReplyMess) - 7);
            if Pos(Cons_Head_MId, ReplyMess) = 1 then FSummary.FMessageID := Copy(ReplyMess, 13, 256);
            if Replymess[Length(Replymess) - 1] = #13 then
              SetLength(Replymess, Length(Replymess) - 2)
            else {_ NOT if Replymess[Length(Replymess) - 1] = #13 then _}  SetLength(Replymess, Length(Replymess) - 1);
            FSummary.FHeader.add(ReplyMess);
          until ReplyMess = '.';
        ReplyMess := Transaction(Cons_Cmd_List + IntToStr(MailNumber));
        FSummary.FBytes := StrToInt(Trim(NthWord(ReplyMess, ' ', 3)));
        StatusMessage(Status_Informational, sPOP_Cons_Summ_Retr);
        if assigned(FOnRetrieveEnd) then FOnRetrieveEnd(self);
      finally
        FTransactionInProgress := FALSE;
      end; {_ try _}
    end; {_ if not FTransactionInProgress then _}
end; {_ procedure TNMPOP3.GetSummary(MailNumber: integer); _}

procedure TNMPOP3.GetMailMessage(MailNumber: integer);
var ReplyMess: string;
begin
  if not FTransactionInProgress then
    begin
      FTransactionInProgress := TRUE;
      CertifyConnect;
      if assigned(FOnRetrieveStart) then FOnRetrieveStart(self);
      try
        FContent_type := '';
        FMailMessage.FBoundary := '';
        FFilename := '';
        FAbort := FALSE;
        FFirstPart := 2;
        if assigned(OnPacketRecvd) then
          begin
            ReplyMess := Transaction(Cons_Cmd_List + IntToStr(MailNumber));
            FBytesTotal := StrToInt(Trim(NthWord(ReplyMess, ' ', 3)));
          end;
        ReplyMess := Transaction(Cons_Cmd_Retr + IntToStr(MailNumber));
        if Pos(Cons_OK_Resp, NthWord(ReplyMess, ' ', 1)) = 0 then raise Exception.create(ReplyMess);
        Readindex := 0;
        FMailMessage.FHead.clear;
        FMailMessage.FBody.clear;
        FMailMessage.FRawBody.clear;
        FMailMessage.FAttachments.clear;
        FMailMessage.Fcontenttypes.clear;
        FMailMessage.FSubject := '';
        FMailMessage.FContenttype := '';
        FBytesRecvd := 0;
        if not FAbort then ReadHeader(false, FMailMessage);
        ReplyMess := Readln;
        FBytesRecvd := FBytesRecvd + length(ReplyMess);
        if assigned(OnPacketRecvd) then OnPacketRecvd(Self);
        while ReplyMess <> '.' + #13#10 do
          begin
            ReplyMess := Copy(ReplyMess, 0, Length(ReplyMess) - 2);
            FMailMessage.FRawBody.add(ReplyMess);
            ReplyMess := Readln;
            FBytesRecvd := FBytesRecvd + length(ReplyMess);
            if assigned(OnPacketRecvd) then OnPacketRecvd(Self);
          end;
        if not FAbort then
          if pos(Lowercase(Cons_Head_Mult), LowerCase(FMailMessage.FContentType)) > 0 then ReadMailParts
          else if not FParse then FMailMessage.FBody.Assign(FMailMessage.FRawBody)
          else
            if (pos('BASE64', Uppercase(FContent_type)) > 0) then
              begin
                FFirstPart := 0;
                ReadBody(FMailMessage);
                FMailMessage.FBody.loadfromfile(FAttachFilePath + FMailMessage.FAttachments[0]);
              end
            else {_ NOT if pos(Cons_Head_Mult, FContentType) > 0 then ReadMailParts _}  ReadBody(FMailMessage);
        if FDeleteOnRead and not FAbort then
          begin
            ReplyMess := Transaction(Cons_Cmd_Dele + IntToStr(MailNumber));
            if NthWord(ReplyMess, ' ', 1) = Cons_Err_Resp then raise Exception.create(ReplyMess);
          end; {_ if FDeleteOnRead and not FAbort then _}
        if FAbort then Transaction(Cons_Cmd_Rset)
        else {_ NOT if FAbort then Transaction(Cons_Cmd_Rset) _}  StatusMessage(Status_Informational, sPOP_Cons_Msg_Retr);
      finally
        if assigned(FOnRetrieveEnd) then FOnRetrieveEnd(self);
        FTransactionInProgress := FALSE;
      end; {_ try _}
    end; {_ if not FTransactionInProgress then _}
end; {_ procedure TNMPOP3.GetMailMessage(MailNumber: integer); _}

procedure TNMPOP3.Extract(InString: string; var OutString: string);
var i: integer;
  found: boolean;
begin
  CertifyConnect;
  i := -1;
  found := FALSE;
  repeat
    i := i + 1;
    if (Pos(InString, FMailMessage.FHead[i]) > 0) then found := TRUE;
  until found or (i = (FMailMessage.FHead.count - 1));
  if found then OutString := Trim(Copy(FMailMessage.FHead[i], Pos(':', FMailMessage.FHead[i]) + 1, 255))
  else {_ NOT if found then OutString := Trim(Copy(FMailMessage.FHead[i], Pos(':', FMailMessage.FHead[i]) + 1, 255)) _}  OutString := '';
end; {_ procedure TNMPOP3.Extract(InString: string; var OutString: string); _}

procedure TNMPOP3.Reset;
var ReplyMess: string;
begin
  CertifyConnect;
  ReplyMess := Transaction(Cons_Cmd_Rset);
  if assigned(FOnReset) then FOnReset(self);
end; {_ procedure TNMPOP3.Reset; _}

procedure TNMPOP3.List;
var ReplyMess: string;
begin
  if not FTransactionInProgress then
    begin
      FTransactionInProgress := TRUE;
      try
        CertifyConnect;
        ReplyMess := Transaction(Cons_Cmd_List);
        ReplyMess := Readln;
        SetLength(ReplyMess, length(ReplyMess) - 2);
        while (ReplyMess <> '.') do
          begin
            if assigned(FOnList) then FOnList(StrToInt(NthWord(ReplyMess, ' ', 1)), StrToInt(NthWord(ReplyMess, ' ', 2)));
            ReplyMess := Readln;
            SetLength(ReplyMess, length(ReplyMess) - 2);
          end; {_ while (ReplyMess <> '.') do _}
      finally
        FTransactionInProgress := FALSE;
      end; {_ try _}
    end; {_ if not FTransactionInProgress then _}
end; {_ procedure TNMPOP3.List; _}


procedure TNMPOP3.ReadMailParts;
var ReplyMess: string;
  LastPart: boolean;
  TemMessage: TMailMessage;
begin
   {Extract Boundary Information}
  LastPart := FALSE;
   {Read Till First Boundary}
  TemMessage := TMailMessage.Create;
  repeat
    ReplyMess := FMailMessage.FRawBody[Readindex];
    inc(Readindex);
  until Pos(FMailMessage.FBoundary, ReplyMess) > 0;
  repeat
    if not FAbort then ReadHeader(true, TemMessage);
    if not FAbort then LastPart := ReadBody(FMailMessage);
  until (ReadIndex = FMailMessage.FRawBody.count) or (LastPart) or (FAbort) or (ReplyMess = '.' + #13#10);
  TemMessage.Free;
   {repeat
      ReplyMess := readln;
   until ReplyMess = '.' + #13#10; }
end; {_ procedure TNMPOP3.ReadMailParts; _}

procedure TNMPOP3.ReadHeader(Readfile: boolean; var MailMessage: TMailMessage);
var ReplyMess: string;
begin
  repeat
    if not FAbort then
      begin
        if ReadFile then
          begin
            if ReadIndex = FMailMessage.FRawBody.count then exit;
            ReplyMess := FMailMessage.FRawBody[Readindex];
            inc(Readindex);
          end
        else
          begin
            ReplyMess := ReadLn;
            FBytesRecvd := FBytesRecvd + length(ReplyMess);
            if assigned(OnPacketRecvd) then OnPacketRecvd(Self);
            SetLength(ReplyMess, length(ReplyMess) - 2);
          end;
        if FFirstPart = 2 then FMailMessage.FHead.add(ReplyMess);
        if (ReplyMess <> '') then
          begin
            if UpperCase(NthWord(ReplyMess, ' ', 1)) = Cons_Head_CSubj then
              FMailMessage.Fsubject := Copy(ReplyMess, 9, 256);
            if UpperCase(NthWord(ReplyMess, ' ', 1)) = Cons_Head_CFrom then
              FMailMessage.FFrom := Copy(ReplyMess, 7, 256);
            if UpperCase(NthWord(ReplyMess, ' ', 1)) = Cons_Head_CType then
              FMailMessage.FContentType := Copy(ReplyMess, 15, 256);
            if UpperCase(NthWord(ReplyMess, ' ', 1)) = Cons_Head_CMid then
              FMailMessage.FMessageID := Copy(ReplyMess, 13, 256);
            if Pos(Cons_Head_CBoun, UpperCase(ReplyMess)) > 0 then
              begin
                MailMessage.FBoundary := Copy(ReplyMess, Pos(Cons_Head_CBoun, UpperCase(ReplyMess)) + 9, 256);
                if (MailMessage.FBoundary[1] = #22) then
                  SetLength(MailMessage.FBoundary, Length(MailMessage.FBoundary) - 2)
                else {_ NOT if Boundary[1] = #22 then _}
                  begin
                    SetLength(MailMessage.FBoundary, Length(MailMessage.FBoundary) - 3);
                    MailMessage.FBoundary := Copy(MailMessage.FBoundary, 2, 255);
                  end; {_ NOT if Boundary[1] = #22 then _}
              end;
            if Pos(Cons_Head_CCTE, UpperCase(ReplyMess)) > 0 then
              FContent_type := Copy(ReplyMess, 28, 256);
            if (Pos(Cons_Head_FileN, UpperCase(ReplyMess)) > 0) or (Pos('NAME', UpperCase(ReplyMess)) > 0) then
              FFilename := NthWord(ReplyMess, '"', 2);
          end; {_ if (ReplyMess <> '') then _}
      end; {_ if not FAbort then _}
  until (ReplyMess = '') or FAbort;
  if FFirstPart = 2 then FFirstPart := 1;
end; {_ procedure TNMPOP3.ReadHeader; _}

//BD 1-7-99 To support files with multiple .s

function LastPos(StringSought, TheString: string): Integer;
var
  CurrentPos: Integer;
begin
  Result := 0;
  while Pos(StringSought, TheString) > 0 do
    begin
      CurrentPos := Pos(StringSought, TheString) + Length(StringSought) - 1;
      Result := Result + CurrentPos;
      TheString := Copy(TheString, CurrentPos + 1, Length(TheString));
    end;
  if Result > 0 then
    Result := Result - (Length(StringSought) - 1);
end;
//BD 1-7-99 To support files with multiple .s

function TNMPOP3.ReadBody(var MailMessage: TMailMessage): boolean;
var OutStream: TFileStream;
  ReplyMess, TFname1, TFName2: string;
  i: integer;
  Ins, Ous: TFileStream;

begin
  try
    result := FALSE;
    OutStream := nil;
   {if FFirstPart=1 then if (FContenttype<>'') and (pos('ascii',FContenttype)=0) then FFirstPart:=0;  }
    if FFirstPart = 0 then
      begin
        inc(TFileIndex);
        OutStream := TFileStream.create(FAttachFilePath + 'Temp' + IntToStr(TFileIndex) + '.mme', fmCreate);
      end; {_ if FFirstPart = 0 then _}
    StatusMessage(Status_Informational, sPOP_Cons_Msg_ExtrF);
    if ReadIndex = FMailMessage.FRawBody.count then exit;
    ReplyMess := FMailMessage.FRawBody[Readindex];
    inc(Readindex);
    while (Readindex <> FMailMessage.FRawBody.count) and (Pos(MailMessage.FBoundary, ReplyMess) = 0) and (ReplyMess <> '.' + #13#10) and (not FAbort) do
      begin
        if FFirstPart > 0 then
          begin
         //SetLength(ReplyMess, length(ReplyMess) - 2);
            FMailMessage.FBody.add(ReplyMess);
          end {_ if FFirstPart > 0 then _}
        else {_ NOT if FFirstPart > 0 then _} {FMailMessage.FBody.add(ReplyMess);}
          begin
            ReplyMess := ReplyMess + CRLF;
            OutStream.WriteBuffer(ReplyMess[1], length(ReplyMess));
          end;
        ReplyMess := FMailMessage.FRawBody[Readindex];
        inc(Readindex);
      end;
    if not Fabort and (FFirstPart = 0) and (OutStream.size > 0) then
      begin
        OutStream.Free;
        if FFileName = '' then FFileName := 'text.tmp';
        TFName1 := Copy(FFileName, 1, LastPos('.', FFileName) - 1);
        TFName2 := Copy(FFileName, Length(TFName1) + 2, Length(FFileName));
        i := 1;
        while FileExists(FAttachFilePath + FFileName) do
          begin
            FFileName := TFName1 + '_' + IntToStr(i) + '.' + TFName2;
            i := i + 1;
          end; {_ while FileExists(FAttachFilePath + FFileName) do _}

      // Modification made by Edward T. Smith Sep 09 1998
        if assigned(FOnDecodeStart) then
          FOnDecodeStart(FFileName);
      // End
        FMailMessage.FBody.add(#13#10 + sPOP_Cons_Msg_File + FFileName + sPOP_Cons_Msg_Extr);
        FMailMessage.FAttachments.Add(FFileName);
        FMailMessage.FContentTypes.Add(FMailMessage.Contenttype);
        if (Pos(Cons_Head_B641, Lowercase(FContent_type)) > 0) or (Pos(Cons_Head_UUEn, FContent_type) > 0) then
          begin
            Ins := TFileStream.create(FAttachFilePath + 'Temp' + IntToStr(TFileIndex) + '.mme', fmOpenRead);
            Ous := TFileStream.create(FAttachFilePath + FFilename, fmCreate);
            try
              NMUUProcessor1.InputStream := Ins;
              NMUUProcessor1.OutputStream := Ous;
              if (Pos(Cons_Head_UUEn, FContent_type) > 0) then NMUUProcessor1.method := UUCode else NMUUProcessor1.method := UUMime;
              StatusMessage(Status_Informational, sPOP_Cons_Msg_Deco);
              if ins.size <> 0 then NMUUProcessor1.Decode;
            finally
              Ins.free;
              Ous.free;
            end; {_ try _}
          end {_ if (Pos(Cons_Head_B641, FContent_type) > 0) or (Pos(Cons_Head_B642, FContent_type) > 0) or (Pos(Cons_Head_UUEn, FContent_type) > 0) then _}
        else {_ NOT if (Pos(Cons_Head_B641, FContent_type) > 0) or (Pos(Cons_Head_B642, FContent_type) > 0) or (Pos(Cons_Head_UUEn, FContent_type) > 0) then _}
          begin
            if FileExists(FAttachFilePath + FFilename) then DeleteFile(FAttachFilePath + FFilename);
            RenameFile(FAttachFilePath + 'Temp' + IntToStr(TFileIndex) + '.mme', FAttachFilePath + FFilename);
          end;
      end; {_ if not Fabort and (FFirstPart = 0) then _}
    if (Pos(MailMessage.FBoundary, ReplyMess) > 0) then
      begin
        ReplyMess := Copy(ReplyMess, Length(ReplyMess) - 3, 256);
        if Pos('--', ReplyMess) > 0 then result := true;
      end; {_ if (Pos(FBoundary, ReplyMess) > 0) then _}
    FFirstPart := 0;
  finally
    if FileExists(FAttachFilePath + 'Temp' + IntToStr(TFileIndex) + '.mme') then Deletefile(FAttachFilePath + 'Temp' + IntToStr(TFileIndex) + '.mme');
  end;
end; {_ function TNMPOP3.ReadBody: boolean; _}

procedure TNMPOP3.DeleteMailMessage(MailNumber: integer);
var ReplyMess: string;
  Done: boolean;
begin
  if not FTransactionInProgress then
    begin
      Done := FALSE;
      FTransactionInProgress := TRUE;
      try
        CertifyConnect;
        ReplyMess := Transaction(Cons_Cmd_Dele + IntToStr(MailNumber));
        if NthWord(ReplyMess, ' ', 1) = Cons_Err_Resp then
          begin
            if assigned(FOnFailure) then FOnFailure(self);
            raise Exception.create(ReplyMess);
          end {_ if NthWord(ReplyMess, ' ', 1) <> Cons_OK_Resp then _}
        else {_ NOT if NthWord(ReplyMess, ' ', 1) <> Cons_OK_Resp then _}  Done := TRUE;
      finally
        FTransactionInProgress := FALSE;
        if Done then
          if assigned(FOnSuccess) then
            FOnSuccess(self);
      end; {_ try _}
    end; {_ if not FTransactionInProgress then _}
end; {_ procedure TNMPOP3.DeleteMailMessage(MailNumber: integer); _}


function TNMPOP3.UniqueID(MailNumber: integer): string;
var ReplyMess: string;
begin
  if not FTransactionInProgress then
    begin
      Result := '';
      FTransactionInProgress := TRUE;
      try
        CertifyConnect;
        ReplyMess := Transaction(Cons_Cmd_Uidl + IntToStr(MailNumber));
        if NthWord(ReplyMess, ' ', 1) <> Cons_OK_Resp then
          begin
            if assigned(FOnFailure) then FOnFailure(self);
            raise Exception.create(ReplyMess);
          end {_ if NthWord(ReplyMess, ' ', 1) <> Cons_OK_Resp then _}
        else {_ NOT if NthWord(ReplyMess, ' ', 1) <> Cons_OK_Resp then _}
          Result := NthWord(ReplyMess, ' ', 3);
      finally
        FTransactionInProgress := FALSE;
      end; {_ try _}
    end; {_ if not FTransactionInProgress then _}
end;

procedure TNMPOP3.Abort;
begin
  Cancel;
  if Connected then
    begin
      //if FTransactionInProgress then
      //begin
      //   Cancel;
      //end {_ if FTransactionInProgress then _}
      //else {_ NOT if FTransactionInProgress then _}
      //begin
      inherited Disconnect;
      ClearInput;
      //end; {_ NOT if FTransactionInProgress then _}
    end; {_ if (not BeenCanceled) and Connected then _}
end; {_ procedure TNMPOP3.Abort; _}


procedure TNMPOP3.AbortResume(Sender: TObject);
begin
   //inherited Disconnect;
   //TMemoryStream(FIstream).clear;
end; {_ procedure TNMPOP3.AbortResume(Sender: TObject); _}

constructor TMailMessage.create;
begin
  FHead := TExStringList.create;
  FBody := TStringList.create;
  FAttachments := TStringList.create;
  FContentTypes := TStringList.create;
  FRawBody := TStringList.create;
  FPartHeaders := Tlist.Create;
end; {_ constructor TMailMessage.create; _}

destructor TMailMessage.destroy;
begin
  FHead.free;
  FBody.free;
  FAttachments.free;
  FContentTypes.free;
  FRawBody.free;
  FPartHeaders.free;
end; {_ destructor TMailMessage.destroy; _}

end.

