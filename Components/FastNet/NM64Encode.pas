{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.                  //
//                                                                           //
// Unit Name: NM64Encode                                                     //
//                                                                           //
// DESCRIPTION:Internet Base 64 Encoder                                      //
//                                                                           //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY     //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE       //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR     //
// PURPOSE.                                                                  //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 09 20 99 - MDC -  Fix to use NMFileBuffer.BufEnd as end of buffer pointer.
// 09 02 99 - MDC -  New Unit
//

unit NM64Encode;

interface
uses
  Classes;

function B64Encode( const source, destination: TStream ): Boolean;

implementation
uses
  NMFileBuffer;

var
  B64Table: array[ 0..63 ] of Char =
    ( 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '+', '/' );

function B64Encode( const source, destination: TStream ): Boolean;
var
  Counter: LongInt;
  TotalBytes: LongInt;

  EOD: Char;
  B64Char: Char;
  Char1: Char;
  Char2: Char;
  Char3: Char;

  InputPtr, OutputPtr, BufferEnd: PChar;

  MemStuff: TNMFileBuffer;

  Output: string;
  Len: Integer;
begin
  Counter := 0;
  TotalBytes := source.Size;

  EOD := '=';
  Len := 62;
  Output := '';
  SetLength( Output, Len );
  OutputPtr := PChar( Output );

  destination.Seek( 0, soFromEnd );

  MemStuff := TNMFileBuffer.Create( Source );
  try
    InputPtr := MemStuff.BufPos;
    BufferEnd := MemStuff.BufEnd;
    while True do
      begin
        if InputPtr >= BufferEnd then
          if not MemStuff.NextMemoryBuffer( InputPtr, 0 ) then
            Break
          else
            begin
              InputPtr := MemStuff.BufPos;
              BufferEnd := MemStuff.BufEnd;
            end;
        Char1 := InputPtr^;
        inc( InputPtr );
        B64Char := B64Table[ Byte( Char1 ) shr 2 ];
        OutputPtr^ := B64Char;
        inc( OutputPtr );
        inc( Counter );

        if Counter >= TotalBytes then
          begin
            Char2 := #0;
            B64Char := B64Table[ ( ( ( Byte( Char1 ) and $03 ) shl 4 ) or ( ( Byte( Char2 ) and $F0 ) shr 4 ) ) ];
            OutputPtr^ := B64Char;
            inc( OutputPtr );
            OutputPtr^ := EOD;
            inc( OutputPtr );
            OutputPtr^ := EOD;
            inc( OutputPtr );
          end
        else
          begin
            if InputPtr >= BufferEnd then
              if not MemStuff.NextMemoryBuffer( InputPtr, 0 ) then
                Break
              else
                begin
                  InputPtr := MemStuff.BufPos;
                  BufferEnd := MemStuff.BufEnd;
                end;
            Char2 := InputPtr^;
            inc( InputPtr );
            B64Char := B64Table[ ( ( ( Byte( Char1 ) and $03 ) shl 4 ) or ( ( Byte( Char2 ) and $F0 ) shr 4 ) ) ];
            OutputPtr^ := B64Char;
            inc( OutputPtr );
            inc( Counter );

            if Counter >= TotalBytes then
              begin
                Char3 := #0;
                B64Char := B64Table[ ( ( ( Byte( Char2 ) and $0F ) shl 2 ) or ( ( Byte( Char3 ) and $C0 ) shr 6 ) ) ];
                OutputPtr^ := B64Char;
                inc( OutputPtr );
                OutputPtr^ := EOD;
                inc( OutputPtr );
              end
            else
              begin
                if InputPtr >= BufferEnd then
                  if not MemStuff.NextMemoryBuffer( InputPtr, 0 ) then
                    Break
                  else
                    begin
                      InputPtr := MemStuff.BufPos;
                      BufferEnd := MemStuff.BufEnd;
                    end;
                Char3 := InputPtr^;
                inc( InputPtr );
                B64Char := B64Table[ ( ( ( Byte( Char2 ) and $0F ) shl 2 ) or ( ( Byte( Char3 ) and $C0 ) shr 6 ) ) ];
                OutputPtr^ := B64Char;
                inc( OutputPtr );
                inc( Counter );
                B64Char := B64Table[ ( Byte( Char3 ) and $3F ) ];
                OutputPtr^ := B64Char;
                inc( OutputPtr );
              end;
          end;

        if ( Counter mod 45 = 0 ) or ( ( OutputPtr - 1 )^ = EOD ) then
          begin
            if ( ( OutputPtr - 1 )^ <> EOD ) then
              begin
                OutputPtr^ := #13;
                inc( OutputPtr );
                OutputPtr^ := #10;
                inc( OutputPtr );
                OutputPtr^ := #0;
              end
            else
              begin
                len := LongInt( OutputPtr ) - LongInt( Output );
                SetLength( Output, len );
              end;
            destination.Write( PChar( Output )^, Len );
            OutputPtr := PChar( Output );
          end;
      end;
  finally
    MemStuff.Free;
  end;

  len := LongInt( OutputPtr ) - LongInt( Output );
  if len > 0 then
    begin
      SetLength( Output, len );
      destination.Write( PChar( Output )^, Len );
    end;

  destination.Write( EOD, 1 );
  result := TRUE;
end;

end.

