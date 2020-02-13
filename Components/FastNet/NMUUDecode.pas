{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.                  //
//                                                                           //
// Unit Name: NMUUDecode                                                     //
//                                                                           //
// DESCRIPTION:Internet UUE Decoder                                          //
//                                                                           //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY     //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE       //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR     //
// PURPOSE.                                                                  //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 09 02 99 - MDC -  New Unit
//

Unit NMUUDecode;

Interface
Uses
  Classes;

Function UUEDecode(Const Source: TStream; Var Destination: TStream): Boolean;

Implementation


Function UUEDecode(Const Source: TStream; Var Destination: TStream): Boolean;
Const
  EOL     = #0;
  EOB     = #0;
  CR      = #13;
  LF      = #10;
  Invalid = $FF;

Var
  Stream_Ptr: PChar;


  Function Decode_Char(c: Char): Byte;
  Begin
    Result := ((Byte(c) - $20) And $3F);
  End;

  Procedure decode;
  Var
    Char1: Byte;
    Char2: Byte;
    Char3: Byte;
    Char4: Byte;

    Line_Ptr: PChar;
    Line_Length: LongInt;
    Line: String;
  Begin
    Line_Length := Decode_Char(Stream_Ptr^);
    inc(Stream_Ptr);

    SetLength(Line, Line_Length);
    Line_Ptr := PChar(Line);

    While Line_Length > 0 Do
      Begin
        If Stream_Ptr^ > EOL Then
          Begin
            Char1 := Decode_Char(Stream_Ptr^);
            inc(Stream_Ptr);
          End
        Else
          char1 := Invalid;

        If Stream_Ptr^ > EOL Then
          Begin
            Char2 := Decode_Char(Stream_Ptr^);
            inc(Stream_Ptr);
          End
        Else
          char2 := Invalid;

        If Stream_Ptr^ > EOL Then
          Begin
            Char3 := Decode_Char(Stream_Ptr^);
            inc(Stream_Ptr);
          End
        Else
          char3 := Invalid;

        If Stream_Ptr^ > EOL Then
          Begin
            Char4 := Decode_Char(Stream_Ptr^);
            inc(Stream_Ptr);
          End
        Else
          char4 := Invalid;

        Line_Ptr^ := Char((Char1 Shl 2) Or (Char2 Shr 4));
        inc(Line_Ptr);
        Line_Ptr^ := Char((Char2 Shl 4) Or (Char3 Shr 2));
        inc(Line_Ptr);
        Line_Ptr^ := Char((Char3 Shl 6) Or (Char4));
        inc(Line_Ptr);
        dec(Line_Length, 3);
      End;
    Destination.Write(Pointer(Line)^, Length(Line));
  End;

Const
  MaxBufSize = $FFFE;

Var
  Buffer, FillPos, BufPos: PChar;
  Counter, BytesRead: LongInt;
  SourceSize: LongInt;
Begin
  Result := TRUE;

  SourceSize := Source.Size;
  destination.Seek(0, soFromEnd);

  Counter := 0;

  GetMem(Buffer, MaxBufSize + 1);
  FillPos := Buffer;
  inc(FillPos, MaxBufSize + 1);
  FillPos^ := EOB;
  Try
    While Source.Position < SourceSize Do
      Begin
        FillPos := Buffer;
        inc(FillPos, Counter);
        BytesRead := Source.Read(FillPos^, MaxBufSize - Counter);
        inc(counter, BytesRead);
        BufPos := Buffer;
        inc(FillPos, Counter );
        FillPos^ := EOB;
        Counter := 0;
        While BufPos^ <> EOB Do
          Begin
            Stream_Ptr := BufPos;

            While Not (BufPos^ In [EOB, LF, CR]) Do
              Inc(BufPos);
            If BufPos^ <> EOB Then
              Begin
                BufPos^ := EOL;
                Decode;
                If BufPos^ = EOB Then Inc(BufPos);
                If BufPos^ = CR Then Inc(BufPos);
                If BufPos^ = LF Then Inc(BufPos);
              End
            Else
              Begin
                Counter := BufPos - Stream_Ptr;
                System.Move(Stream_Ptr^, Buffer^, Counter + 1);
                Break;
              End;
          End;
      End;
    if Counter > 0 then
      begin
        Stream_Ptr := Buffer;
        Decode;
      end;
  Finally
    FreeMem(Buffer, MaxBufSize);
  End;
End;

End.

