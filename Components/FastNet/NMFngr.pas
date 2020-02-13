{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1997 -1999, NetMasters, L.L.C - All rights reserved worldwide.   //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMFngr                                                      //
//                                                                        //
// DESCRIPTION:Internet Finger Component                                  //
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
unit NMFngr;

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
   Classes, Forms, Psock ,NMConst;
{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER120}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}
{$ObjExportAll On}
{$ENDIF}

//  CompName='TNMFinger';
//  Major_Version='4';
//  Minor_Version='02';
//  Date_Version='012798';

type
   TNMFinger = class(TPowerSock)
   private
      FUser: string;
      function GetFingerString: string;
   protected
      { Protected declarations }
   public
      constructor Create(AOwner: TComponent); override;
   published
      property FingerStr: string read GetFingerString;
      property User: string read Fuser write Fuser;
   end; {_ TNMFinger = class(TPowerSock) _}
   
procedure Register;

implementation



procedure Register;
begin
   RegisterComponents(Cons_Palette_Inet,[TNMFinger]);
end; {_ procedure register; _}

constructor TNMFinger.Create(AOwner: TComponent);
begin
   inherited create(AOwner);
   Port := 79;
end; {_ constructor TNMFinger.Create(AOwner: TComponent); _}

function TNMFinger.GetFingerString: string;
begin
   Result := '';
   if (not (csDesigning in ComponentState)) and (not (CSLoading in ComponentState)) then
   begin
      Connect;
      try
         writeln(FUser);
         while Connected or (DataAvailable) do
            if DataAvailable then Result := Result + ReadLn
            else  {_ NOT if DataAvailable then Result := Result + ReadLn _}
               Application.ProcessMessages;
      finally
         Disconnect;
      end; {_ try _}
   end {_ if (not (csDesigning in ComponentState)) and (not (CSLoading in ComponentState)) then _}
end; {_ function TNMFinger.GetFingerString: string; _}



end.

