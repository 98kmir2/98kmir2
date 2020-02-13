{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.                  //
//                                                                           //
// Unit Name: NM64Decode                                                     //
//                                                                           //
// DESCRIPTION:Internet Base 64 Decoder                                      //
//                                                                           //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY     //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE       //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR     //
// PURPOSE.                                                                  //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 12 03 99 - MDC - Even faster now, initialize table in unit initialization section
// 09 02 99 - MDC -  New Unit
//

unit NM64Decode;

interface
uses
  Classes;

function B64Decode( const Source: TStream; var Destination: TStream ): Boolean;

implementation
uses
  sysutils;

const
  INVALID = $FF;

var
  B64_Table: array[ 0..255 ] of Byte;

function B64Decode( const Source: TStream; var Destination: TStream ): Boolean;
const
  EOD = '=';
  EOB = $FE;
  INVALID = $FF;
  CR = #13;
  LF = #10;
  EOL = #0;

var
  Stream_Ptr: PChar;

  procedure Decode;
  var
    Char1: Byte;
    Char2: Byte;
    Char3: Byte;
    Char4: Byte;
    Count: Integer;

    Line_Ptr: PChar;
    Line_Length: LongInt;
    Line: string;
  begin
    Line_Length := StrLen( Stream_Ptr ) * 3 div 4;
    SetLength( Line, Line_Length );
    Line_Ptr := PChar( Line );

    while Line_Length > 0 do
      begin
        Count := 0;
        if Stream_Ptr^ > EOL then
          begin
            Char1 := B64_Table[ Byte( Stream_Ptr^ ) ];
            Inc( Stream_Ptr );
          end
        else
          Char1 := INVALID;

        if Stream_Ptr^ > EOL then
          begin
            Char2 := B64_Table[ Byte( Stream_Ptr^ ) ];
            Inc( Stream_Ptr );
          end
        else
          Char2 := INVALID;

        if Stream_Ptr^ > EOL then
          begin
            Char3 := B64_Table[ Byte( Stream_Ptr^ ) ];
            Inc( Stream_Ptr );
          end
        else
          Char3 := INVALID;

        if Stream_Ptr^ > EOL then
          begin
            Char4 := B64_Table[ Byte( Stream_Ptr^ ) ];
            Inc( Stream_Ptr );
          end
        else
          Char4 := INVALID;

        if ( Char1 = INVALID ) or ( Char2 = INVALID ) then
          raise Exception.Create( 'Invalid data encountered within stream' )
        else
          begin
            Line_Ptr^ := Char( ( Char1 shl 2 ) or ( ( Char2 and $30 ) shr 4 ) );
            inc( Line_Ptr );
            inc( Count );

            if ( Char3 <> INVALID ) then
              begin
                Line_Ptr^ := Char( ( ( Char2 and $0F ) shl 4 ) or ( ( Char3 and $3C ) shr 2 ) );
                inc( Line_Ptr );
                inc( Count );

                if ( Char4 <> INVALID ) then
                  begin
                    Line_Ptr^ := Char( ( ( Char3 and $03 ) shl 6 ) or ( Char4 ) );
                    inc( Line_Ptr );
                    inc( Count );
                  end;
              end
          end;
        dec( Line_Length, Count );
      end;
    Destination.Write( Pointer( Line )^, Line_Ptr - PChar( Line ) );
  end;

const
  MaxBufSize = $FFFE;

var
  Buffer, FillPos, BufPos: PChar;
  Counter, BytesRead: LongInt;
  SourceSize: LongInt;
begin
  Result := TRUE;

//  InitTable;

  SourceSize := Source.Size;
  destination.Seek( 0, soFromEnd );

  Counter := 0;

  GetMem( Buffer, MaxBufSize + 1 );
  FillPos := Buffer;
  BufPos := Buffer;
  inc( FillPos, MaxBufSize + 1 );
  FillPos^ := EOL;
  try
    while ( Source.Position < SourceSize ) and ( BufPos^ <> EOD ) do
      begin
        FillPos := Buffer;
        inc( FillPos, Counter );
        BytesRead := Source.Read( FillPos^, MaxBufSize - Counter );
        inc( counter, BytesRead );
        BufPos := Buffer;
        inc( FillPos, Counter );
        FillPos^ := EOL;
        Counter := 0;
        while ( BufPos^ <> EOL ) do
          begin
            Stream_Ptr := BufPos;
            while not ( BufPos^ in [ EOL, LF, CR, EOD ] ) do
              Inc( BufPos );
            if ( BufPos^ <> EOL ) or ( BufPos^ = EOD ) then
              begin
                BufPos^ := EOL;
                Decode;
                if BufPos^ = EOL then Inc( BufPos );
                if BufPos^ = CR then Inc( BufPos );
                if BufPos^ = LF then Inc( BufPos );
              end
            else
              begin
                Counter := BufPos - Stream_Ptr;
                System.Move( Stream_Ptr^, Buffer^, Counter );
                Break;
              end;
          end;
      end;
    if Counter > 0 then
      begin
        Stream_Ptr := Buffer;
        Decode;
      end;
  finally
    FreeMem( Buffer, MaxBufSize );
  end;
end;

initialization
  begin
    FillChar( B64_Table, sizeof( B64_Table ), INVALID );

    B64_Table[ 43 ] := 62;
    B64_Table[ 47 ] := 63;
    B64_Table[ 48 ] := 52;
    B64_Table[ 49 ] := 53;
    B64_Table[ 50 ] := 54;
    B64_Table[ 51 ] := 55;
    B64_Table[ 52 ] := 56;
    B64_Table[ 53 ] := 57;
    B64_Table[ 54 ] := 58;
    B64_Table[ 55 ] := 59;
    B64_Table[ 56 ] := 60;
    B64_Table[ 57 ] := 61;
    B64_Table[ 65 ] := 0;
    B64_Table[ 66 ] := 1;
    B64_Table[ 67 ] := 2;
    B64_Table[ 68 ] := 3;
    B64_Table[ 69 ] := 4;
    B64_Table[ 70 ] := 5;
    B64_Table[ 71 ] := 6;
    B64_Table[ 72 ] := 7;
    B64_Table[ 73 ] := 8;
    B64_Table[ 74 ] := 9;
    B64_Table[ 75 ] := 10;
    B64_Table[ 76 ] := 11;
    B64_Table[ 77 ] := 12;
    B64_Table[ 78 ] := 13;
    B64_Table[ 79 ] := 14;
    B64_Table[ 80 ] := 15;
    B64_Table[ 81 ] := 16;
    B64_Table[ 82 ] := 17;
    B64_Table[ 83 ] := 18;
    B64_Table[ 84 ] := 19;
    B64_Table[ 85 ] := 20;
    B64_Table[ 86 ] := 21;
    B64_Table[ 87 ] := 22;
    B64_Table[ 88 ] := 23;
    B64_Table[ 89 ] := 24;
    B64_Table[ 90 ] := 25;
    B64_Table[ 97 ] := 26;
    B64_Table[ 98 ] := 27;
    B64_Table[ 99 ] := 28;
    B64_Table[ 100 ] := 29;
    B64_Table[ 101 ] := 30;
    B64_Table[ 102 ] := 31;
    B64_Table[ 103 ] := 32;
    B64_Table[ 104 ] := 33;
    B64_Table[ 105 ] := 34;
    B64_Table[ 106 ] := 35;
    B64_Table[ 107 ] := 36;
    B64_Table[ 108 ] := 37;
    B64_Table[ 109 ] := 38;
    B64_Table[ 110 ] := 39;
    B64_Table[ 111 ] := 40;
    B64_Table[ 112 ] := 41;
    B64_Table[ 113 ] := 42;
    B64_Table[ 114 ] := 43;
    B64_Table[ 115 ] := 44;
    B64_Table[ 116 ] := 45;
    B64_Table[ 117 ] := 46;
    B64_Table[ 118 ] := 47;
    B64_Table[ 119 ] := 48;
    B64_Table[ 120 ] := 49;
    B64_Table[ 121 ] := 50;
    B64_Table[ 122 ] := 51;
  end;

end.

