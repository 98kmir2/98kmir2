{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.                  //
//                                                                           //
// Unit Name: NMFileBuffer                                                   //
//                                                                           //
// DESCRIPTION: Add memory buffering to a file stream                        //
//                                                                           //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY     //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE       //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR     //
// PURPOSE.                                                                  //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 09 20 99 - MDC -  Added end of buffer pointer
// 09 02 99 - MDC -  New Unit
//

unit NMFileBuffer;

interface
uses
  Classes;

type
  TNMFileBuffer = class( TObject )
  private
    FSource: TStream;
    FSourceSize: LongInt;
    FBuffer: PChar;
    FBufPos: PChar;
    FBufEnd: PChar;
    FBufSize: LongInt;
  protected

  public
    constructor Create( const aSource: TStream );
    destructor Destroy; override;

    function NextMemoryBuffer( const Ptr: PChar; const Counter: LongInt ): Boolean;

    property BufPos: PChar read FBufPos;
    property BufEnd: PChar read FBufEnd;
    property BufSize: LongInt read FBufSize;
  published
  end;

implementation
uses
  SysUtils;

const
  MaxBufSize = $FFFD;

constructor TNMFileBuffer.Create( const aSource: TStream );
begin
  inherited Create;
  FBuffer := AllocMem( MaxBufSize + 2 );
  FSource := aSource;
  FSourceSize := FSource.Size;
  FSource.Position := 0;
  NextMemoryBuffer( FBufPos, 0 );
end;

destructor TNMFileBuffer.Destroy;
begin
  FreeMem( FBuffer );
end;

function TNMFileBuffer.NextMemoryBuffer( const Ptr: PChar; const Counter: LongInt ): Boolean;
var
  BytesRead: LongInt;
  FillPos: PChar;
begin
  if FSource.Position < FSourceSize then
    begin
      FBufPos := FBuffer + 1;
      FillPos := FBufPos;
      if Counter > 0 then
        begin
          System.Move( Ptr^, FillPos^, Counter );
          inc( FillPos, Counter );
        end;
      BytesRead := FSource.Read( FillPos^, MaxBufSize - Counter );
      FBufSize := MaxBufSize;
      if BytesRead < MaxBufSize - Counter then
        begin
          ( FillPos + BytesRead )^ := #0;
          FBufEnd := FillPos + BytesRead;
          FBufSize := BytesRead;
        end;
      Result := True;
    end
  else
    begin
      Result := False;
    end;
end;

end.

