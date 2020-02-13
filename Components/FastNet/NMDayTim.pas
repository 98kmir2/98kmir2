{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide.   //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMdayTime                                                   //
//                                                                        //
// DESCRIPTION:Internet DayTime Component                                 //
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
// 01 27 98 - KNA - Final release Ver 4.00 VCLS
// 01 18 98 - KNA - TimerOff moved
// 01 27 98 - KNA - wait for input

unit NMDayTim;

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

//  CompName='TNMdayTim';
//  Major_Version='4';
//  Minor_Version='02';
//  Date_Version='012798';





type
  TNMDayTime = class(TPowerSock)
  private
    function GetTimeStr:string;
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent);override;
    property DayTimeStr:string read GetTimeStr;
  published

  end;

procedure Register;

implementation



procedure Register;
begin
  RegisterComponents(Cons_Palette_Inet, [TNMDayTime]);
end;

constructor TNMDayTime.Create(AOwner: TComponent);
begin
 inherited create(AOwner);
 Port:=13;
 TimeOut:=500;
end;

function TNMDayTime.GetTimeStr:string;
  var i,ct:integer;
    handled:boolean;
begin
  BeenCanceled := FALSE;                           {Turn Canceled off}
  if FConnected then                          {If already connected raise exception}
    raise ESockError.create( sPSk_Cons_msg_Conn );
  Ct:=0;
  repeat
    try
      ResolveRemoteHost;                         {Resolve the IP address of remote host}
    except
      On E:ESockError do
        if (E.Message= sPSk_Cons_msg_host_to ) or (E.Message= sPSk_Cons_msg_host_Can) then raise;
    end;
    if RemoteAddress.sin_addr.S_addr=0 then
      if Ct>0 then raise ESockError.create( sPSk_Cons_msg_add_null ){If Resolving failed raise exception}
      else
       if not assigned(OnInvalidHost) then raise ESockError.create( sPSk_Cons_msg_add_null )
       else
        begin
          Handled:=FALSE;
          OnInvalidHost(Handled);
          if not handled then raise ESockError.create( sPSk_Cons_msg_add_null );{If Resolving failed raise exception}
          Ct:=Ct+1;
        end;
  until RemoteAddress.sin_addr.S_addr <>0;
  StatusMessage( Status_Debug, sPSk_Cons_msg_Conning );{Inform Status}
  RemoteAddress.sin_family := AF_INET;        {Make connected true}
  {$R-}
  if Proxy = '' then
    RemoteAddress.sin_port := htons( Port ){If no proxy get port from Port property}
  else
    RemoteAddress.sin_port := htons( ProxyPort ); {else get port from ProxyPort property}
  {$R+}
  i := SizeOf( RemoteAddress );                 {i := size of remoteaddress structure}
  {Connect to remote host}
  succeed:=FALSE;
  Timedout:=FALSE;
  TimerOn;
  WinSock.Connect( ThisSocket, RemoteAddress, i );
  repeat
    application.processmessages;         {Process messages till response received}
  until  Succeed or TimedOut;    {Responce received,  Timed out or Cancelled exits loop}
  TimerOff;
  if TimedOut then raise Exception.create(Cons_Msg_ConnectionTimedOut);
  try
   while not DataAvailable do
    Application.processmessages;
   Result:=Read(0);
  finally
    Disconnect;
  end;
end;


end.
