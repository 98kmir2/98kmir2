///////////////////////////////////////////////////////////////////////////
//  Version:5.6.3   Build:1091  Date:1/31/00  //
//                                                                       //
// Copyright © 1996-1999, NetMasters, L.L.C                              //
//  - All rights reserved worldwide. -                                   //
//  Portions may be Copyright © Borland International, Inc.              //
//                                                                       //
// NMURL :  (NMURL.PAS)                                                  //
//                                                                       //
// DESCRIPTION:                                                          //
//                                                                       //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE   //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR //
// PURPOSE.                                                              //
//                                                                       //
///////////////////////////////////////////////////////////////////////////
// Revision History
// 01 27 98 - KNA -  Final release Ver 4.00 VCLS
//
unit NMURL;

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
   SysUtils, Classes, NMConst;
{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER120}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}
{$ObjExportAll On}
{$ENDIF}



   //  CompName     ='NMURL';               
   //  Major_Version='4';                   
   //  Minor_Version='02';                  
   //  Date_Version ='012798';              
   
   
   
type
   TOnErrorEvent = procedure (Sender: TObject; Operation, ErrMsg: string) of object;
   TNMURL = class(TComponent)
   private
      { Private declarations }
      FInputString: string;
      FOnError: TOnErrorEvent;
      function GetEncodeString: string;
      function GetDecodeString: string;
      function URLDecode(const InString: string): string;
      function URLEncode(const InString: string): string;
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      property Encode: string
         read GetEncodeString;
      property Decode: string
         read GetDecodeString;
   published
      { Published declarations }
      property InputString: string
         read FInputString
         write FInputString;
      property OnError: TOnErrorEvent read FOnError write FOnError;
   end; {_ TNMURL = class(TComponent) _}
   
procedure Register;

implementation

procedure Register;
begin
   RegisterComponents(Cons_Palette_Inet,[TNMURL]);
end; {_ procedure register; _}


constructor TNMURL.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FInputString := ''; { Initialize values }
end; {_ constructor TNMURL.Create(AOwner: TComponent); _}

destructor TNMURL.Destroy;
begin
   inherited Destroy;
end; {_ destructor TNMURL.Destroy; _}

function TNMURL.UrlDecode(const InString: string): string;
var
   i   : integer;
   Temp: string; 
begin
   result := '';
   Temp := '';
   i := 1;
   try
      while i <= Length(InString) do
      begin
         if InString[i] = '+' then
         begin
            Result := Result + ' ';
            inc(i);
            continue;
         end {_ if InString[i] = '+' then _}
         else if InString[i] = '%' then
         begin
            Temp := Concat('$', InString[i + 1], InString[i + 2]);
            Result := Result + Chr(StrToInt(Temp));
            inc(i, 3);
            continue;
         end; {_ if InString[i] = '%' then _}
         Result := Result + InString[i];
         inc(i)
      end; {_ while i <= Length(InString) do _}
   except
      on E: Exception do
         begin
            if Assigned(FOnError) then FOnError(Self, sURL_DecodeMessage, e.message);
            Result := InString;
         end; {_ inc(i) _}
   end; {_ try _}
end; {_ function TNMURL.UrlDecode(const InString: string): string; _}

function TNMURL.URLEncode(const InString: string): string;
var
   i: Word;
begin
   result := '';
   try
      for i := 1 to Length(InString) do
         case ord(InString[i]) of
            0..31, 33..47, 58..64, 91..96, 123..255:
               Result := Result + Format('%%%.2x',[Ord(InString[i])]);
            32: Result := Result + '+';
         else {_ NOT case ord(InString[i]) of _}
            Result := Result + InString[i];
         end; {_ NOT case ord(InString[i]) of _}
   except
      on E: Exception do
         begin
            if Assigned(FOnError) then FOnError(Self, sURL_EncodeMessage, e.message);
            Result := InString;
         end; {_ NOT case ord(InString[i]) of _}
   end; {_ try _}
end; {_ function TNMURL.URLEncode(const InString: string): string; _}

function TNMURL.GetEncodeString: string;
begin
   Result := URLEncode(FInputString);
end; {_ function TNMURL.GetEncodeString: string; _}

function TNMURL.GetDecodeString: string;
begin
   Result := URLDecode(FInputString);
end; {_ function TNMURL.GetDecodeString: string; _}


end.

