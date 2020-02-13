{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1996-1999, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMSTRM                                                      //
//                                                                        //
// DESCRIPTION:Internet Stream Messaging Object Component                 //
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
// 02 05 98 - KNA -  MemoryStream create and Free in try finally loop for robustness
//                   in Serve method
// 01 27 98 - KNA -  Final release Ver 4.00 VCLS
//
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

unit NMSTRM;

interface

uses
   SysUtils, Classes, Forms, Psock, NMConst;
{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER120}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}
{$ObjExportAll On}
{$ENDIF}


//  CompName='NMSTRM32';
//  Major_Version='4';
//  Minor_Version='02';
//  Date_Version='012798';

type
   TStrmEvent = procedure (Sender: TComponent; const sFrom: string; strm: Tstream) of object;
   
   
   
   TNMStrm = class(TPowerSock)
   private
      sFromName: string;
      FOnMessageSent: TNotifyEvent;
   protected
   public
      constructor Create(AOwner: TComponent); override;
      procedure Abort; override;
      function PostIt(const sStrm: TStream): string;
   published
      property OnPacketRecvd;
      property OnPacketSent;
      property FromName: string read sFromName write sFromName;
      property OnMessageSent: TNotifyEvent read FOnMessageSent write FOnMessageSent;
   end; {_ TNMStrm = class(TPowerSock) _}
   
   TNMStrmServ = class(TNMGeneralServer)
   private
      FOnMSG: TStrmEvent;
   protected
   public
      constructor Create(AOwner: TComponent); override;
      procedure Serve; override;
   published
      property OnMSG: TStrmEvent read FOnMSG write FOnMSG;
   end; {_ TNMStrmServ = class(TNMGeneralServer) _}
   
   {Procs}
procedure Register;

implementation



procedure Register;
begin
   RegisterComponents(Cons_Palette_Inet,[TNMStrm, TNMStrmServ]);
end; {_ procedure register; _}



constructor TNMStrm.Create;
   
begin
   inherited Create(AOwner);
   Port := 6711;
end; {_ constructor TNMStrm.Create; _}

function TNMStrm.PostIt;
   
begin
   Connect;
   try
      write (Format('%.4d',[Length(FromName)]) + FromName);
      write (Format('%10d',[sStrm.size]));
      SendStream(sStrm);
      if assigned(FOnMessageSent) then FOnMessageSent(self);
      Result := read (16);
   finally
      Disconnect;
   end; {_ try _}
end; {_ function TNMStrm.PostIt; _}

procedure TNMStrm.Abort;
begin
   if connected then
   begin
      cancel;
      Disconnect;
   end; {_ if connected then _}
end; {_ procedure TNMStrm.Abort; _}

constructor TNMStrmServ.Create;
   
begin
   inherited Create(AOwner);
   Port := 6711;
end; {_ constructor TNMStrmServ.Create; _}

procedure TNMStrmServ.Serve;
var sFrom: string;
   Stg: string;       
   i  : longint;      
   st : TMemorystream;
begin
   st := TMemorystream.create;
   try
      Stg := read (4);
      i := StrToInt(Stg);
      if i > 0 then
         sFrom := read (i);
      Stg := read (10);
      i := StrToInt(Stg);
      FBytesRecvd := 0;
      FBytesTotal := i;
      try
        if i > 0 then
          CaptureStream(st, i);
      finally
        write ('OK' + '              ');
      end;  
      st.position := 0;
      if Assigned(TNMStrmServ(Chief).FOnMSG) then TNMStrmServ(Chief).FOnMSG(Self, sFrom, st);
   finally
      st.free;
      while Connected and (not beencanceled) do
         Wait;
   end; {_ try _}
end; {_ procedure TNMStrmServ.Serve; _}

end.

