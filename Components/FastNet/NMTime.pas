{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide.   //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMTime                                                      //
//                                                                        //
// DESCRIPTION:Internet Time Component                                    //
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
unit NMTime;
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
   SysUtils, Classes, Forms, Psock, Winsock, NMConst;
{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER120}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}
{$ObjExportAll On}
{$ENDIF}

//  CompName='TNMTime';
//  Major_Version='4';
//  Minor_Version='02';
//  Date_Version='012798';



type
   TNMTime = class(TPowerSock)
   private
      function GetTimeStr: string;
      function GetTimeInt: longint;
   protected
      { Protected declarations }
   public
      constructor Create(AOwner: TComponent); override;
   published
      property TimeStr: string read GetTimeStr;
      property TimeInt: longint read GetTimeInt;
   end; {_ TNMTime = class(TPowerSock) _}
   
procedure Register;

implementation



procedure Register;
begin
   RegisterComponents(Cons_Palette_Inet,[TNMTime]);
end; {_ procedure register; _}

constructor TNMTime.Create(AOwner: TComponent);
begin
   inherited create(AOwner);
   Port := 37;
   TimeOut := 500;
end; {_ constructor TNMTime.Create(AOwner: TComponent); _}

function TNMTime.GetTimeStr: string;
var i, ct: integer;
   handled: boolean;
   AStr   : string; 
   j      : double; 
begin
   BeenCanceled := FALSE; {Turn Canceled off}
   if FConnected then {If already connected raise exception}
      raise ESockError.create(sPSk_Cons_msg_Conn);
   Ct := 0;
   repeat
      try
         ResolveRemoteHost; {Resolve the IP address of remote host}
      except
         on E: ESockError do
               if (E.message = sPSk_Cons_msg_host_to) or (E.message = sPSk_Cons_msg_host_Can) then raise;
      end; {_ try _}
      if RemoteAddress.sin_addr.S_addr = 0 then
         if Ct > 0 then
            raise ESockError.create(sPSk_Cons_msg_add_null) {If Resolving failed raise exception}
         else {_ NOT if Ct > 0 then _}
            if not assigned(OnInvalidHost) then
               raise ESockError.create(sPSk_Cons_msg_add_null)
            else {_ NOT if not assigned(OnInvalidHost) then _}
            begin
               Handled := FALSE;
               OnInvalidHost(Handled);
               if not handled then
                  raise ESockError.create(sPSk_Cons_msg_add_null); {If Resolving failed raise exception}
               Ct := Ct + 1;
            end; {_ NOT if not assigned(OnInvalidHost) then _}
   until RemoteAddress.sin_addr.S_addr <> 0;
   StatusMessage(Status_Debug, sPSk_Cons_msg_Conning); {Inform Status}
   RemoteAddress.sin_family := AF_INET; {Make connected true}
   {$R-}
   if Proxy = '' then
      RemoteAddress.sin_port := htons(Port) {If no proxy get port from Port property}
   else {_ NOT if Proxy = '' then _}
      RemoteAddress.sin_port := htons(ProxyPort); {else get port from ProxyPort property}
   {$R+}
   i := SizeOf(RemoteAddress); {i := size of remoteaddress structure}
   {Connect to remote host}
   succeed := FALSE;
   Timedout := FALSE;
   TimerOn;
   WinSock.Connect(ThisSocket, RemoteAddress, i);
   repeat
      application.processmessages; {Process messages till response received}
   until Succeed or TimedOut; {Responce received,  Timed out or Cancelled exits loop}
   TimerOff;
   if TimedOut then raise Exception.create(Cons_Msg_ConnectionTimedOut);
   try
      while not DataAvailable do Application.processmessages;
      AStr := read (0);
   finally
      Disconnect;
   end; {_ try _}
   j := 0;
   if Length(Astr) > 0 then
   begin
      for i := 1 to length(Astr) do
      begin
         j := j * 256;
         j := j + ord(Astr[i]);
      end; {_ for i := 1 to length(Astr) do _}
   end; {_ if Length(Astr) > 0 then _}
   j := (j / (24 * 60 * 60));
   result := TimeToStr(TDateTime(j));
end; {_ function TNMTime.GetTimeStr: string; _}


function TNMTime.GetTimeInt: longint;
var i, ct: integer;
   handled: boolean;
   AStr   : string; 
   j      : longint;
begin
   BeenCanceled := FALSE; {Turn Canceled off}
   if FConnected then {If already connected raise exception}
      raise ESockError.create(sPSk_Cons_msg_Conn);
   Ct := 0;
   repeat
      try
         ResolveRemoteHost; {Resolve the IP address of remote host}
      except
         on E: ESockError do
               if (E.message = sPSk_Cons_msg_host_to) or (E.message = sPSk_Cons_msg_host_Can) then raise;
      end; {_ try _}
      if RemoteAddress.sin_addr.S_addr = 0 then
         if Ct > 0 then
            raise ESockError.create(sPSk_Cons_msg_add_null)
            {If Resolving failed raise exception}
         else {_ NOT if Ct > 0 then _}
            if not assigned(OnInvalidHost) then
               raise ESockError.create(sPSk_Cons_msg_add_null)
            else {_ NOT if not assigned(OnInvalidHost) then _}
            begin
               Handled := FALSE;
               OnInvalidHost(Handled);
               if not handled then
                  raise ESockError.create(sPSk_Cons_msg_add_null); {If Resolving failed raise exception}
               Ct := Ct + 1;
            end; {_ NOT if not assigned(OnInvalidHost) then _}
   until RemoteAddress.sin_addr.S_addr <> 0;
   StatusMessage(Status_Debug, sPSk_Cons_msg_Conning); {Inform Status}
   RemoteAddress.sin_family := AF_INET; {Make connected true}
   {$R-}
   if Proxy = '' then
      RemoteAddress.sin_port := htons(Port) {If no proxy get port from Port property}
   else {_ NOT if Proxy = '' then _}
      RemoteAddress.sin_port := htons(ProxyPort); {else get port from ProxyPort property}
   {$R+}
   i := SizeOf(RemoteAddress); {i := size of remoteaddress structure}
   {Connect to remote host}
   succeed := FALSE;
   Timedout := FALSE;
   TimerOn;
   WinSock.Connect(ThisSocket, RemoteAddress, i);
   repeat
      application.processmessages; {Process messages till response received}
   until Succeed or TimedOut; {Responce received,  Timed out or Cancelled exits loop}
   TimerOff;
   if TimedOut then raise Exception.create(Cons_Msg_ConnectionTimedOut);
   try
      while not DataAvailable do Application.processmessages;
      AStr := read (0);
   finally
      Disconnect;
   end; {_ try _}
   j := 0;
   if Length(Astr) > 0 then
   begin
      for i := 1 to length(Astr) do
      begin
         j := j * 256;
         j := j + ord(Astr[i]);
      end; {_ for i := 1 to length(Astr) do _}
   end; {_ if Length(Astr) > 0 then _}
   result := j;
end; {_ function TNMTime.GetTimeInt: longint; _}


end.

