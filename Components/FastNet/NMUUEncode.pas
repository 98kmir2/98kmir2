{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.                  //
//                                                                           //
// Unit Name: NMUUEncode                                                     //
//                                                                           //
// DESCRIPTION:Internet UUE Encoder                                          //
//                                                                           //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY     //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE       //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR     //
// PURPOSE.                                                                  //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 12 09 99 - MDC -  Encoded incorrect length when buffer <ENCODELINELENGTH.
// 12 03 99 - MDC -  Fix bug when last buffer < ENCODELINELENGTH characters.
// 09 20 99 - MDC -  Fix to use NMFileBuffer.BufEnd as end of buffer pointer.
// 09 02 99 - MDC -  New Unit
//

unit NMUUEncode;

interface
uses
  Classes;

function UUEEncode( const source, destination: TStream ): Boolean;

implementation
uses
  NMFileBuffer;

function UUEEncode( const source, destination: TStream ): Boolean;

  function EncodeAByte( c: Byte ): Byte;
  begin
    if c > 0 then
      Result := ( c and $3F ) + $20
    else
      Result := ord( '`' );
  end;

const
  CRLF = #13#10;
  ENCODELINELENGTH = 45;
  EOB = #0;
  INVALID = $00;
var
  TotalBytes: Integer;
  index: Integer;

  Output: string;
  line_index: Integer;
  LinePtr: PChar;
  Len: Integer;
  Len1: Integer;
  OutputLength: Integer;

  Char1: Byte;
  Char2: Byte;
  Char3: Byte;

  OutChar1: Byte;
  OutChar2: Byte;
  OutChar3: Byte;
  OutChar4: Byte;

  InputPtr: PChar;
  BufferEnd: PChar;
  MemStuff: TNMFileBuffer;

  Process: Boolean;

begin
  Process := True;

  destination.Seek( 0, soFromEnd );

  TotalBytes := source.Size;
  index := 0;

  Char1 := 0;
  Char2 := 0;
  Char3 := 0;

  Output := '';
  OutputLength := ENCODELINELENGTH div 3 * 4;

  MemStuff := TNMFileBuffer.Create( Source );
  try
    InputPtr := MemStuff.BufPos;
    BufferEnd := MemStuff.BufEnd;
    while Process do
      begin
        line_index := 0;

        if ( ( TotalBytes - index ) >= ENCODELINELENGTH ) then
          begin
            // Output the number of bytes in this line
            SetLength( Output, OutputLength + 1 );
            LinePtr := PChar( Output );
            OutChar1 := EncodeAByte( ENCODELINELENGTH );
            LinePtr^ := Chr( OutChar1 );
            inc( LinePtr );

            while ( line_index < ENCODELINELENGTH ) do
              begin
                if InputPtr >= BufferEnd then
                  if not MemStuff.NextMemoryBuffer( InputPtr, 0 ) then
                    Break
                  else
                    begin
                      InputPtr := MemStuff.BufPos;
                      BufferEnd := MemStuff.BufEnd;
                    end;
                Char1 := Byte( InputPtr^ );
                inc( InputPtr );
                inc( line_index );
                inc( index );

                if InputPtr >= BufferEnd then
                  if not MemStuff.NextMemoryBuffer( InputPtr, 0 ) then
                    Break
                  else
                    begin
                      InputPtr := MemStuff.BufPos;
                      BufferEnd := MemStuff.BufEnd;
                    end;
                Char2 := Byte( InputPtr^ );
                inc( InputPtr );
                inc( line_index );
                inc( index );

                if InputPtr >= BufferEnd then
                  if not MemStuff.NextMemoryBuffer( InputPtr, 0 ) then
                    Break
                  else
                    begin
                      InputPtr := MemStuff.BufPos;
                      BufferEnd := MemStuff.BufEnd;
                    end;
                Char3 := Byte( InputPtr^ );
                inc( InputPtr );
                inc( line_index );
                inc( index );

                OutChar1 := Char1 shr 2;
                OutChar2 := ( ( ( Char1 shl 4 ) and $30 ) or ( ( Char2 shr 4 ) and $0F ) );
                OutChar3 := ( ( ( Char2 shl 2 ) and $3C ) or ( ( Char3 shr 6 ) and $03 ) );
                OutChar4 := Char3 and $3F;

                OutChar1 := EncodeAByte( OutChar1 );
                OutChar2 := EncodeAByte( OutChar2 );
                OutChar3 := EncodeAByte( OutChar3 );
                OutChar4 := EncodeAByte( OutChar4 );

                LinePtr^ := Chr( OutChar1 );
                inc( LinePtr );
                LinePtr^ := Chr( OutChar2 );
                inc( LinePtr );
                LinePtr^ := Chr( OutChar3 );
                inc( LinePtr );
                LinePtr^ := Chr( OutChar4 );
                inc( LinePtr );
              end;
            if InputPtr >= BufferEnd then
              if not MemStuff.NextMemoryBuffer( InputPtr, 0 ) then
                Break
              else
                begin
                  InputPtr := MemStuff.BufPos;
                  BufferEnd := MemStuff.BufEnd;
                end;
          end
        else
          begin
            Len := TotalBytes - index;   // get bytes left over
            Len1 := Len div 3;
            if frac(Len / 3) > 0.0 then  // always round up!
              inc(Len1);
            Len1 := Len1 * 4;
            SetLength( Output, Len1 + 1 );
            LinePtr := PChar( Output );
            OutChar1 := EncodeAByte( Len );
            LinePtr^ := Chr( OutChar1 );
            inc( LinePtr );

            while ( index < TotalBytes ) do
              begin
                if ( index < TotalBytes ) then
                  begin
                    if InputPtr >= BufferEnd then
                      if not MemStuff.NextMemoryBuffer( InputPtr, 0 ) then
                        Break
                      else
                        begin
                          InputPtr := MemStuff.BufPos;
                          BufferEnd := MemStuff.BufEnd;
                        end;
                    Char1 := Byte( InputPtr^ );
                    inc( InputPtr );
                  end
                else
                  begin
                    Char1 := INVALID;
                  end;

                inc( index );

                if ( index < TotalBytes ) then
                  begin
                    if InputPtr >= BufferEnd then
                      if not MemStuff.NextMemoryBuffer( InputPtr, 0 ) then
                        Break
                      else
                        begin
                          InputPtr := MemStuff.BufPos;
                          BufferEnd := MemStuff.BufEnd;
                        end;
                    Char2 := Byte( InputPtr^ );
                    inc( InputPtr );
                  end
                else
                  begin
                    Char2 := INVALID;
                  end;

                inc( index );

                if ( index < TotalBytes ) then
                  begin
                    if InputPtr >= BufferEnd then
                      if not MemStuff.NextMemoryBuffer( InputPtr, 0 ) then
                        Break
                      else
                        begin
                          InputPtr := MemStuff.BufPos;
                          BufferEnd := MemStuff.BufEnd;
                        end;
                    Char3 := Byte( InputPtr^ );
                    inc( InputPtr );
                  end
                else
                  begin
                    Char3 := INVALID;
                  end;

                inc( index );

                OutChar1 := Char1 shr 2;
                OutChar2 := ( ( ( Char1 shl 4 ) and $30 ) or ( ( Char2 shr 4 ) and $0F ) );
                OutChar3 := ( ( ( Char2 shl 2 ) and $3C ) or ( ( Char3 shr 6 ) and $03 ) );
                OutChar4 := Char3 and $3F;

                OutChar1 := EncodeAByte( OutChar1 );
                OutChar2 := EncodeAByte( OutChar2 );
                OutChar3 := EncodeAByte( OutChar3 );
                OutChar4 := EncodeAByte( OutChar4 );

                LinePtr^ := Chr( OutChar1 );
                inc( LinePtr );
                LinePtr^ := Chr( OutChar2 );
                inc( LinePtr );
                LinePtr^ := Chr( OutChar3 );
                inc( LinePtr );
                LinePtr^ := Chr( OutChar4 );
                inc( LinePtr );
              end;
            Process := False;
          end;

        LinePtr^ := #0;
        destination.Write( PChar( Output )^, Length( Output ) );
        destination.Write( CRLF, 2 );
      end;
  finally
    MemStuff.Free;
  end;
  Result := TRUE;     // no errors reported
end;

end.

