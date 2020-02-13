{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide.   //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMUUE                                                       //
//  + Aug-9-98  Version 4.1 -- KNA                                        //
//                                                                        //
// DESCRIPTION:Internet UUEncode/UUDecode [MIME/BinHex] Component         //
//                                                                        //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY  //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE    //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR  //
// PURPOSE.                                                               //
//                                                                        //
////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 09 02 99 - MDC -  Rewrite of encode and decode routines.
// 10 22 98 - KNA -  If no 'end' no message;
// 01 27 98 - KNA -  Final release Ver 4.00 VCLS
//

unit NMUUE;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  UUMethods = (uuMime, uuCode);

  TNMUUProcessor = class(TComponent)
  private
    FOnBeginEncode: TNotifyEvent;
    FOnEndEncode: TNotifyEvent;
    FOnBeginDecode: TNotifyEvent;
    FOnEndDecode: TNotifyEvent;
    FInputStream: TStream;
    FOutputStream: TStream;
  protected
    FUUMethod: UUMethods;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure Encode;
    procedure Decode;
    property InputStream: TStream read FInputStream write FInputStream;
    property OutputStream: TStream read FOutputStream write FOutputStream;
  published
    property Method: UUMethods read FUUMethod write FUUMethod default uuMime;
    property OnBeginEncode: TNotifyEvent read FOnBeginEncode write FOnBeginEncode;
    property OnEndEncode: TNotifyEvent read FOnEndEncode write FOnEndEncode;
    property OnBeginDecode: TNotifyEvent read FOnBeginDecode write FOnBeginDecode;
    property OnEndDecode: TNotifyEvent read FOnEndDecode write FOnEndDecode;
  end;

procedure Register;

implementation
uses
  NM64Encode, NM64Decode, NMUUEncode, NMUUDecode;

procedure Register;

begin
  RegisterComponents( 'Internet', [ TNMUUProcessor ] );
end;

{*******************************************************************************
Create NMUUE and set code method to MIME by default
*******************************************************************************}

constructor TNMUUProcessor.Create( AOwner: TComponent );
begin
  inherited;
  fUUMethod := uuMime;
end;

{*******************************************************************************
Encode
*******************************************************************************}

procedure TNMUUProcessor.Encode;
begin
  FInputStream.Position:=0;
  if assigned( FOnBeginEncode ) then
    FOnBeginEncode( self );

  case method of
    UUMime: B64Encode(FInputStream, FOutputStream);
    UUCode: UUEEncode(FInputStream, FOutputStream);
  end;
  FInputStream.Position :=0;
  FOutputStream.Position :=0;
  if assigned( FOnEndEncode ) then
    FOnEndEncode( self );


end;

{*******************************************************************************************
Decode
********************************************************************************************}

procedure TNMUUProcessor.Decode;
begin
  FInputStream.Position:=0;
  if assigned( FOnBeginDecode ) then
    FOnBeginDecode( self );

  case method of
    UUMime: B64Decode(FInputStream, FOutputStream);
    UUCode: UUEDecode(FInputStream, FOutputStream);
  end;
  FInputStream.Position :=0;
  FOutputStream.Position :=0;
  if assigned( FOnEndDecode ) then
    FOnEndDecode( self );
end;

end.

