{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide.   //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMEcho                                                     //
//                                                                        //
// DESCRIPTION:Internet Echo Component                                    //
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
unit NMEcho;

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
   Classes, SysUtils, Psock, NMConst;
{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER120}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}
{$ObjExportAll On}
{$ENDIF}

//  CompName='TNMEcho';
//  Major_Version='4';
//  Minor_Version='02';
//  Date_Version='012798';



   
type
   TNMEcho = class(TPowerSock)
   private
      FEchoInStr: string;
      FElapsedTime: single;
      
   protected
      { Protected declarations }
   public
      constructor Create(AOwner: TComponent); override;
      function Echo(EchoString: string): string;
      property ElapsedTime: single read FElapsedTime;
   published
      property OnConnectionRequired;
      
   end; {_ TNMEcho = class(TPowerSock) _}
   
procedure Register;

implementation



procedure Register;
begin
   RegisterComponents(Cons_Palette_Inet,[TNMEcho]);
end; {_ procedure register; _}

constructor TNMEcho.Create(AOwner: TComponent);
begin
   inherited create(AOwner);
   FEchoInStr := sEcho_Cons_Msg_echoS;
   Port := 7;
end; {_ constructor TNMEcho.Create(AOwner: TComponent); _}

function TNMEcho.Echo(EchoString: string): string;
var i: TdateTime;
begin
   if (not (csDesigning in ComponentState)) and (not (CSLoading in ComponentState)) then
   begin
      CertifyConnect;
      i := now;
      Writeln(EchoString);
      Result := ReadLn;
      FElapsedTime:=24 * 60 * 60 * 100 * (now - i);
   end {_ if (not (csDesigning in ComponentState)) and (not (CSLoading in ComponentState)) then _}
   else  {_ NOT if (not (csDesigning in ComponentState)) and (not (CSLoading in ComponentState)) then _}Result := '';
end; {_ function TNMEcho.Echo(EchoString: string): string; _}


end.

