{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1996-1999, NetMasters, L.L.C - All rights reserved worldwide.   //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMMSG                                                      //
//                                                                        //
// DESCRIPTION:Internet Messaging Object Component                        //
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
// 01 27 98 - KNA -  Final release Ver 4.00 VCLS
//
unit NMMSG;
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
   Classes, SysUtils, Forms, Psock, NMConst, Winsock;
{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER120}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}
{$ObjExportAll On}
{$ENDIF}


//  CompName='NMMSG32';
//  Major_Version='4';
//  Minor_Version='02';
//  Date_Version='012798';

type
   TMSGEvent = procedure (Sender: TComponent; const sFrom, sMsg: string) of object;
   
   
   TNMMsg = class(TPowerSock)
   private
      sFromName: string;
      FOnMessageSent: TNotifyEvent;
   protected
   public
      constructor Create(AOwner: TComponent); override;
      procedure Abort; override;
      function PostIt(const sMsg: string): string;
   published
      property FromName: string read sFromName write sFromName;
      property OnMessageSent: TNotifyEvent read FOnMessageSent write FOnMessageSent;
   end; {_ TNMMsg = class(TPowerSock) _}
   
   
   
   TNMMSGServ = class(TNMGeneralServer)
   private
      FOnMSG: TMsgEvent;
   protected
   public
      constructor Create(AOwner: TComponent); override;
      procedure Serve; override;
   published
      property OnMSG: TMsgEvent read FOnMSG write FOnMSG;
   end; {_ TNMMSGServ = class(TNMGeneralServer) _}
   
   
   {Procs}
procedure Register;

implementation



procedure Register;
begin
   RegisterComponents(Cons_Palette_Inet,[TNMMsg, TNMMSGServ]);
end; {_ procedure register; _}

{TNMMSG}


constructor TNMMsg.Create;
begin
   inherited Create(AOwner);
   Port := 6711;
end; {_ constructor TNMMsg.Create; _}

function TNMMsg.PostIt;
 var i:integer;
begin
   Connect;
   try
      Write (Format('%.4d',[Length(FromName)]) + FromName);
      Write (Format('%.4d',[Length(sMsg)]) + sMsg);
      if assigned(FOnMessageSent) then FOnMessageSent(self);
      Result := read (16);
   finally
      DisConnect;
   end; {_ try _}
end; {_ function TNMMsg.PostIt; _}


procedure TNMMsg.Abort;
begin
   if Connected then
   begin
      Cancel;
      Disconnect;
   end; {_ if connected then _}
end; {_ procedure TNMMsg.Abort; _}



{TNMMSGServ}


constructor TNMMSGServ.Create;
begin
   inherited Create(AOwner);
   Port := 6711;
end; {_ constructor TNMMSGServ.Create; _}

procedure TNMMSGServ.Serve;
var sFrom, sMsg: string;
   i: integer;
begin
  try
   i := StrToInt(read (4));
   if i > 0 then
      sFrom := read (i);
   i := StrToInt(read (4));
   if i > 0 then
      sMsg := read (i)
   else  {_ NOT if i > 0 then _}sMsg := '';
   write ('OK' + '              ');
   if assigned(TNMMSGServ(Chief).FOnMSG) then (TNMMSGServ(Chief).FOnMSG(Self, sFrom, sMsg));
   while Connected and (not beencanceled) do
     Wait;
  except
  end;   
end; {_ procedure TNMMSGServ.Serve; _}


end.

