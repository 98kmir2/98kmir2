///////////////////////////////////////////////////////////////////////////
//  Version:5.6.3   Build:1091  Date:1/31/00  //
//                                                                       //
// Copyright © 1997-1999, NetMasters, L.L.C                              //
//  - All rights reserved worldwide. -                                   //
//  Portions may be Copyright © Borland International, Inc.              //
//                                                                       //
// fstrings :  (STRINGS.PAS)                                             //
//                                                                       //
// DESCRIPTION:                                                          //
//                                                                       //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE   //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR //
// PURPOSE.                                                              //
//                                                                       //
///////////////////////////////////////////////////////////////////////////
// Revision History
// 10 27 98 - KNA -  Blank space at start removed
// 01 27 98 - KNA -  Final release Ver 4.00 VCLS
//
unit NMExtstr;

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

uses  Classes, Sysutils;
{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER120}
{$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}
{$ObjExportAll On}
{$ENDIF}

//  CompName='NMExtStr';
//  Major_Version='4';
//  Minor_Version='02';
//  Date_Version='012798';

type
    TExStringList = class ( tstringlist )
    protected
      function IndexOfName(const Name: string): Integer;
      function GetValue(const Name: string): string;
      procedure SetValue(const Name, Value: string);
    public
      property Values[const Name: string]: string read GetValue write SetValue; 

end;

implementation

uses Consts, TypInfo;

function TExStringList.GetValue(const Name: string): string;
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if I >= 0 then
    begin
      Result := Copy(Get(I), Length(Name) + 2, MaxInt);
      if Result[1]=' ' then Result:= Copy(Result, 2, MaxInt)
    end
    else
    Result := '';
end;

function TExStringList.IndexOfName(const Name: string): Integer;
var
  P: Integer;
  S: string;
  top, bottom : integer;
  test : integer;
  done : boolean;
begin
  if sorted then
    begin
      done := false;
      top := 0;
      bottom := getcount -1;
      repeat
        result := ((bottom - top) div 2 ) + top;
        S := Get(Result);
        P := Pos(':', S);
        test := AnsiCompareText(Copy(S, 1, P-1), Name);
        if test = 0 then
          done := true
        else if test < 0 then
               top := result +1
             else
               bottom := result - 1;
        if top  = bottom + 1 then
          begin
            result := -1;
            exit;
          end;                                                             
      until done;
    end
  else
    begin
      for Result := 0 to GetCount - 1 do
        begin
          S := Get(Result);
          P := Pos(':', S);
          if (P <> 0) and (AnsiCompareText(Copy(S, 1, P - 1), Name) = 0) then Exit;
        end;
      Result := -1;
    end;
end;

procedure TExStringList.SetValue(const Name, Value: string);
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if Value <> '' then
  begin
    if I < 0 then I := Add('');
    Put(I, Name + ': ' + Value);
  end else
  begin
    if I >= 0 then Delete(I);
  end;
end;

end.
