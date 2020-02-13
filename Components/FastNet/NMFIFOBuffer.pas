///////////////////////////////////////////////////////////////////////////
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////
//                                                                       //
// Copyright © 1999, NetMasters, L.L.C                                   //
//  - All rights reserved worldwide. -                                   //
//  Portions may be Copyright © Borland International, Inc.              //
//                                                                       //
// Unit:  NMFifoBuffer                                                   //
// Class: TNMFifoBuffer                                                  //
// Uses:  None                                                           //
//                                                                       //
// DESCRIPTION:                                                          //
//                                                                       //
//  This is a Buffered Disk buffer                                       //
//                                                                       //
//  Publics:  Append    -- Append bytes to the buffer                    //
//            Clear     -- Clear the buffer                              //
//            Create    -- Create the buffer                             //
//            Destroy   -- Destroy the buffer (Call free)                //
//            Peek      -- Return bytes from buffer                      //
//            Remove    -- Remove bytes from buffer                      //
//            Search    -- Rearch for strng in buffer                    //
//                                                                       //
//                                                                       //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE   //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR //
// PURPOSE.                                                              //
//                                                                       //
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Revision History
//
// 15-Dec-99 MDC -- 1.0.4.0 -- Do not allocate the disk buffer until needed.
// 25-Oct-99 MDC -- 1.0.3.0 -- Fix bug in Search, was returning FoundAts beyond
//                             actual memory buffer length.
// 21-Oct-99 MDC -- 1.0.2.0 -- Pre-allocate 1024 bytes in the disk file.
//                          -- Fix bug with search Spanning buffers.
// 15-Oct-99 MDC -- 1.0.1.0 -- Last minute changes
// 13-Aug-99 MDC -- 1.0.0.0 -- Original version
//
///////////////////////////////////////////////////////////////////////////
unit NMFifoBuffer;

interface

uses
  Classes, Windows, SysUtils;

type
  TNMFifoBuffer = class( TObject )
  private
    // BufStream
    FBufferSize: LongInt;                       // Current size of the BufStream

    // Memory Buffer
    FMemoryBufferCapacity: LongInt;             // Total Capacity of the memory buffer
    FMemoryBuffer: TMemoryStream;               // Memory stream
    FMemorySize: LongInt;                       // Current size of the memory buffer
    FMemoryAddPosition: LongInt;                // Current add position in memory buffer
    FMemoryRemovePosition: LongInt;             // Current remove position in memory buffer
    FMemoryLow: LongInt;                        // Shuffle when memory drops below this.

    // Disk Buffer
    FFilename: string;                          // Filename of the disk buffer
    FDiskBuffer: TFileStream;                   // File stream for the disk buffer
    FDiskSize: LongInt;                         // Current size of the disk buffer
    FDiskAddPosition: LongInt;                  // Current add position in disk buffer
    FDiskRemovePosition: LongInt;               // Current remove position in disk buffer

    FThreadRunning: Boolean;                    // Shuffle thread is running

    function _CreateTemporaryFileName: string;

    procedure _Init;
    procedure InitDiskBuffer;
    function _CalculateThreshold( const PercentMemory: Real ): LongInt;
    procedure _Shuffle( Data: Pointer );

    procedure _SetMemoryBufferCapacity( const NewCapacity: LongInt );
  protected
    property ThreadRunning: Boolean read FThreadRunning;
  public
    constructor Create;

    destructor Destroy; override;

    procedure Clear;

    procedure LoadFromStream( Stream: TStream );
    procedure LoadFromFile( const FileName: string );

    function Append( const Buffer: Pointer; const Count: LongInt ): LongInt;
    function Remove( Buffer: Pointer; const Count: LongInt ): LongInt;
    function Peek( Buffer: Pointer; const Count: LongInt ): LongInt;
    function Search( const Substr: Pointer ): LongInt;

    property BufferSize: Longint read FBufferSize;
    property MemorySize: Longint read FMemorySize;
    property DiskSize: Longint read FDiskSize;
  published
    property MemoryBufferCapacity: Longint read FMemoryBufferCapacity write _SetMemoryBufferCapacity;
    property MemoryLow: LongInt read FMemoryLow write FMemoryLow;
  end;

implementation
uses
  PSock;

// ***************************************************************************
//TNMFifoBuffer

constructor TNMFifoBuffer.Create;
begin
  inherited Create;
  FMemoryBufferCapacity := _CalculateThreshold( 0.05 ); // Init Threshold to 5% of free memory!
  _Init;
end;

destructor TNMFifoBuffer.Destroy;
begin
  if FDiskBuffer <> nil then
    begin
      FDiskBuffer.Free;
      DeleteFile( FFilename );
    end;
  FMemoryBuffer.Free;
  inherited;
end;

// Support routines.
// ***************************************************************************

function TNMFifoBuffer.Remove( Buffer: Pointer; const Count: LongInt ): LongInt;
var
  tmp                 : LongInt;
begin
  while FThreadRunning do
    Sleep( 50 );
  Result := 0;

  if ( Count > 0 ) and ( FBufferSize > 0 ) then
    begin
      if IsBadWritePtr( PByteArray( Buffer ), Count ) then
        raise Exception.Create( 'Can''t write to the destination buffer' );

      tmp := Count;
      if FMemoryRemovePosition + Count > FMemoryBufferCapacity then
        tmp := FMemoryBufferCapacity - FMemoryRemovePosition;

      FMemorybuffer.Position := FMemoryRemovePosition;
      if tmp > 0 then
        begin
          Result := FMemorybuffer.Read( Buffer^, tmp );
          dec( FMemorySize, Result );
          inc( FMemoryRemovePosition, Result );
        end
      else
        Result := 0;

      tmp := 0;
      if FDiskBuffer <> nil then
        begin
          if Result < Count then
            begin
              FDiskBuffer.Position := FDiskRemovePosition;
              tmp := FDiskBuffer.Read( Pointer( Longint( Buffer ) + Result )^, Count - Result );
              Dec( FDiskSize, tmp );
              inc( FDiskRemovePosition, tmp );
            end;
        end;

      Result := Result + tmp;
      dec( FBufferSize, Result );

      if FMemorySize = 0 then
        begin
          FMemoryAddPosition := 0;
          FMemoryRemovePosition := 0;
          if FDiskSize > 0 then
            begin
              FThreadRunning := True;
              ExecuteInThread( _Shuffle, nil );
            end;
        end;
    end;
end;

function TNMFifoBuffer.Peek( Buffer: Pointer; const Count: LongInt ): LongInt;
var
  tmp                 : LongInt;
begin
  while FThreadRunning do
    Sleep( 50 );
  Result := 0;

  if ( Count > 0 ) and ( FBufferSize > 0 ) then
    begin
      if IsBadWritePtr( PByteArray( Buffer ), Count ) then
        raise Exception.Create( 'Can''t write to the destination buffer' );

      tmp := Count;
      if FMemoryRemovePosition + Count > FMemoryBufferCapacity then
        tmp := FMemoryBufferCapacity - FMemoryRemovePosition;

      FMemorybuffer.Position := FMemoryRemovePosition;
      Result := FMemorybuffer.Read( Buffer^, tmp );

      tmp := 0;
      if FDiskBuffer <> nil then
        begin
          if Result < Count then
            begin
              FDiskBuffer.Position := FDiskRemovePosition;
              tmp := FDiskBuffer.Read( Pointer( Longint( Buffer ) + Result )^, Count - Result );
            end;
        end;

      Result := Result + tmp;
    end;
end;

function TNMFifoBuffer.Search( const Substr: Pointer ): LongInt;
var
  Ptr, Ptr1           : PChar;
  SubLen              : LongInt;

  function InternalSearch: LongInt;
  var
    Sav1, Sav2        : PChar;
  begin
    Sav1 := Ptr;
    Sav2 := StrPos( Ptr, Ptr1 );
    Result := LongInt( Sav2 - Sav1 );
    inc( Result, SubLen );
    if Result < 0 then
      Result := 0;
  end;

const
  MaxBufSize          = $FFFF;

var
  Buffer              : PChar;
  DiskPosition, DiskSize, Count, FoundAt, A1, A2: LongInt;

begin
  Result := 0;
  SubLen := StrLen( SubStr );
  // we must have something in the buffer and
  // the search must be less or equal the buffer size.
  if ( FMemorySize > 0 ) then
    if ( SubLen > FBufferSize ) or ( SubLen > MaxBufSize ) then
      Result := -1
    else
      begin
        Ptr1 := SubStr;

        while FThreadRunning do
          Sleep( 50 );

        Ptr := Pointer( FMemoryBuffer.Memory );
        inc( Ptr, FMemoryRemovePosition );

        FoundAt := 0;

        if SubLen <= FMemorySize then
          FoundAt := InternalSearch;

        if FoundAt > FMemorySize then
          FoundAt := 0;

        if FoundAt = 0 then
          begin
            if FDiskSize > 0 then
              begin
                DiskPosition := 0;
                DiskSize := FDiskSize;
                Buffer := AllocMem( MaxBufSize );
                try
                  // take care of the possibility that the substr spans both buffers
                  if subLen = FBufferSize then  // Exact match entire buffer
                    begin
                      A1 := FMemorySize;
                      A2 := FDiskSize;
                    end
                  else if SubLen > FMemorySize then // all of memory and part of disk
                    begin
                      A1 := FMemorySize;
                      A2 := SubLen - 1;
                    end
                  else
                    begin                       // part of memory and part of disk
                      A1 := SubLen - 1;
                      A2 := SubLen - 1;
                    end;
                  move( Pointer( LongInt( FMemoryBuffer.Memory ) + FMemoryBufferCapacity - A1 )^, Buffer^, A1 );
                  FDiskBuffer.Position := DiskPosition + FDiskRemovePosition;
                  FDiskBuffer.Read( Pointer( Longint( Buffer ) + A1 )^, A2 );
                  Ptr := Buffer;
                  FoundAt := InternalSearch;
                  if FoundAt > 0 then
                    begin
                      if ( subLen <= FMemorySize ) then
                        FoundAt := FMemorySize + FoundAt - A1;
                    end
                  else
                    begin
                      if SubLen <= FDiskSize then
                        begin
                          Count := 0;
                          while ( FoundAt = 0 ) and ( DiskSize > 0 ) do
                            begin
                              inc( DiskPosition, Count );
                              FDiskBuffer.Position := DiskPosition + FDiskRemovePosition;
                              Count := FDiskBuffer.Read( Buffer^, MaxBufSize );
                              if Count <= 0 then
                                break;
                              Ptr := Buffer;
                              FoundAt := InternalSearch;
                            end;
                          if FoundAt > 0 then
                            FoundAt := FMemorySize + DiskPosition + FoundAt;
                        end;
                    end;
                finally
                  FreeMem( Buffer, MaxBufSize );
                end;
              end;
          end;
        Result := FoundAt;
      end;
end;

function TNMFifoBuffer.Append( const Buffer: Pointer; const Count: LongInt ): LongInt;
begin
  while FThreadRunning do
    Sleep( 50 );
  Result := 0;

  if Count > 0 then
    begin
      if IsBadReadPtr( PByteArray( Buffer ), Count ) then
        raise Exception.Create( 'Can''t read the source buffer' );

      Result := Count;
      if FMemoryAddPosition + Count > FMemoryBufferCapacity then
        Result := FMemoryBufferCapacity - FMemoryAddPosition;

      FMemoryBuffer.Position := FMemoryAddPosition;
      Result := FMemoryBuffer.Write( Buffer^, Result );
      inc( FMemorySize, Result );
      inc( FMemoryAddPosition, Result );
      inc( FBufferSize, Result );

      if Result < Count then
        begin
          if FDiskBuffer = nil then
            InitDiskBuffer;

          FDiskBuffer.Position := FDiskAddPosition;
          Result := FDiskBuffer.Write( Pointer( Longint( Buffer ) + Result )^, Count - Result );
          inc( FDiskSize, Result );
          inc( FDiskAddPosition, Result );
          inc( FBufferSize, Result );
        end;
    end;
end;

procedure TNMFifoBuffer._Init;
var
  Zero                : string;
begin
  FDiskSize := 0;                               // Current size of the disk buffer
  FDiskAddPosition := 0;                        // Current add position in disk buffer
  FDiskRemovePosition := 0;                     // Current remove position in disk buffer

  FBufferSize := 0;                             // Current size of the BufStream

  FMemoryBuffer := TMemoryStream.Create;        // Memory stream
  FMemoryBuffer.Size := FMemoryBufferCapacity;
  FMemoryBuffer.Position := FMemoryBuffer.Size;
  Zero := #0;
  FMemoryBuffer.Write( PChar( Zero )^, 1 );     // Put a zero at the end of the memory buffer
  FMemorySize := 0;                             // Current size of the memory buffer
  FMemoryAddPosition := 0;                      // Current add position in memory buffer
  FMemoryRemovePosition := 0;                   // Current remove position in memory buffer
  FMemoryLow := 0;                              // Shuffle when memory drops below this.
  FThreadRunning := False;                      // Shuffle thread is running
end;

procedure TNMFifobuffer.InitDiskBuffer;
begin
  FFilename := _CreateTemporaryFileName;        // Filename of the disk buffer
  FDiskBuffer := TFileStream.Create( FFilename, fmOpenReadWrite or fmShareExclusive ); // File stream for the disk buffer
  FDiskBuffer.Size := 1024;                     // pre-allocate a small disk file size.
  FDiskSize := 0;                               // Current size of the disk buffer
  FDiskAddPosition := 0;                        // Current add position in disk buffer
  FDiskRemovePosition := 0;                     // Current remove position in disk buffer
end;

procedure TNMFifoBuffer._SetMemoryBufferCapacity( const NewCapacity: LongInt );
begin
  if NewCapacity < FMemorysize then
    raise Exception.Create( 'Can not lower memory capacity at this time' );
  FMemoryBuffer.SetSize( NewCapacity );
  FMemoryBufferCapacity := NewCapacity;
end;

function TNMFifoBuffer._CalculateThreshold( const PercentMemory: Real ): LongInt;
const
  MinCapacity         = 64 * 1024;
var
  MS                  : TMemoryStatus;
begin
  MS.dwLength := SizeOf( TMemoryStatus );
  GlobalMemoryStatus( MS );
  Result := Trunc( MS.dwAvailPhys * PercentMemory ) - ( Trunc( MS.dwAvailPhys * PercentMemory ) mod 1024 );
  if Result < MinCapacity then
    Result := MinCapacity;
end;

function TNMFifoBuffer._CreateTemporaryFileName: string;
var
  nBufferLength       : DWORD;
  lpPathName, lpTempFileName: PChar;
begin
  Result := '';
  lpPathName := nil;
  lpTempFileName := nil;

  // first get the length of the tempory path
  nBufferLength := GetTempPath( 0, lpPathName );
  Win32Check( BOOL( nBufferLength ) );
  // Allocate a buffer of the specified length + 1
  lpPathName := AllocMem( nBufferLength );
  try
    // Get the tempory path
    Win32Check( BOOL( GetTempPath( nBufferLength, lpPathName ) ) );
    // Increase the tempory path to hold the file name also.
    lpTempFileName := AllocMem( 256 );
    try
      // Get the temporary file name
      Win32Check( BOOL( GetTempFileName( lpPathName, PChar( 'Buf' ), 0, lpTempFileName ) ) );
      // return the file name and path
      SetString( Result, lpTempFileName, StrLen( lpTempFileName ) );
      // Lastly free the buffers.
    finally
      FreeMem( lpPathName );
    end;
  finally
    FreeMem( lpTempFileName );
  end;
  if Result = '' then
    raise Exception.Create( 'Can''t create a temporary file' );
end;

procedure TNMFifoBuffer._Shuffle( Data: Pointer );
var
  tmp                 : LongInt;
  Size                : LongInt;
begin
  if FDiskBuffer <> nil then
    begin
      FDiskBuffer.Position := FDiskRemovePosition;
      if FDiskSize < FMemoryBufferCapacity then
        Size := FDiskSize
      else
        Size := FMemoryBufferCapacity;
      tmp := FDiskBuffer.Read( FMemoryBuffer.Memory^, Size );
      FMemorySize := tmp;
      FMemoryAddPosition := tmp;
      FMemoryRemovePosition := 0;

      Dec( FDiskSize, tmp );
      if FDiskSize > 0 then
        inc( FDiskRemovePosition, tmp )
      else
        begin
          FDiskAddPosition := 0;
          FDiskRemovePosition := 0;
        end;
    end;

  FThreadRunning := False;
end;

procedure TNMFifoBuffer.Clear;
begin
  while FThreadRunning do
    Sleep( 50 );

  if FDiskBuffer <> nil then
    begin
      FDiskBuffer.Free;
      DeleteFile( FFilename );
    end;

  FMemoryBuffer.Free;
  _Init;
end;

procedure TNMFifoBuffer.LoadFromStream( Stream: TStream );
var
  Count               : Longint;
begin
  Stream.Position := 0;
  Count := Stream.Size;
  if Count > 0 then
    if Count <= FMemoryBufferCapacity then
      begin
        FMemoryBuffer.LoadFromStream( Stream );
        FBufferSize := Count;

        FMemorySize := Count;
        FMemoryAddPosition := Count;
        FMemoryRemovePosition := 0;

        FDiskSize := 0;
        FDiskAddPosition := 0;
        FDiskRemovePosition := 0;
      end
    else
      begin
        if FDiskBuffer = nil then
          InitDiskBuffer;

        FDiskBuffer.CopyFrom( Stream, Count );
        FBufferSize := Count;

        FMemorySize := 0;
        FMemoryAddPosition := FMemoryBufferCapacity; // set to max so shuffle can shuffle
        FMemoryRemovePosition := FMemoryBufferCapacity; // set to max so shuffle can shuffle

        FDiskSize := Count;
        FDiskAddPosition := Count;
        FDiskRemovePosition := 0;

        FThreadRunning := True;                 // do this here so that thread initialization is counted as thread running
        ExecuteInThread( _Shuffle, nil );
      end;
end;

procedure TNMFifoBuffer.LoadFromFile( const FileName: string );
var
  Stream              : TStream;
begin
  Stream := TFileStream.Create( FileName, fmOpenRead or fmShareDenyWrite );
  try
    LoadFromStream( Stream );
  finally
    Stream.Free;
  end;
end;

end.

