{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// Copyright © 1996-2000, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.                  //
//                                                                           //
// Unit Name: URLParse                                                       //
//                                                                           //
// DESCRIPTION: Internet URL parser                                          //
//                                                                           //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY     //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE       //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR     //
// PURPOSE.                                                                  //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 01 15 2000 - MDC -  if FPath is blank, replace with /
// 01 15 2000 - MDC -  Original unit
//
unit URLParse;

interface

const
  PortDefault         = '80';                   {HTTP}
  SchemeDefault       = 'http:';                {HTTP}
  NumberOfSchemes     = 16;

var
  PORTS               : array[ 1..NumberOfSchemes, 1..2 ] of string = (
    ( 'ftp:', '21' ),
    ( 'telnet:', '23' ),
    ( 'smtp:', '25' ),
    ( 'whois:', '43' ),
    ( 'whois++:', '63' ),
    ( 'gopher:', '70' ),
    ( 'http:', '80' ),
    ( 'pop3:', '110' ),
    ( 'nntp:', '119' ),
    ( 'news:', '119' ),
    ( 'imap2:', '143' ),
    ( 'irc:', '194' ),
    ( 'wais:', '210' ),
    ( 'imap3:', '220' ),
    ( 'ldap:', '389' ),
    ( 'https:', '443' ) );

procedure ParseURL( URL: string; var FScheme, FUser, FPassword, FNetworkLocation, FPort, FPath, FResource, FParameters, FQuery, FFragment: string );
function DefaultPort( const FScheme: string ): string;

implementation

uses
  SysUtils;

function DefaultPort( const FScheme: string ): string;
var
  i                   : Integer;
begin
  Result := PortDefault;

  if FScheme <> '' then
    for i := 1 to NumberOfSchemes do
      if AnsiCompareText( FScheme, PORTS[ i, 1 ] ) = 0 then
        begin
          Result := PORTS[ i, 2 ];
          break;
        end;
end;

function GetToEnd( const FindChar: Char; var ParseString: string; const KeepFirst: Boolean ): string;
var
  I, II               : Integer;
begin
  Result := '';
  if ParseString <> '' then
    begin
      I := Pos( FindChar, ParseString );
      if I > 0 then
        begin
          II := Length( ParseString ) - I + 1;
          Result := Copy( ParseString, I, II );
          Delete( ParseString, I, II );
        end;
      if Not KeepFirst then
        Delete(Result, 1, 1);
    end;
end;

{
Fielding                    Standards Track
RFC 1808           Relative Uniform Resource Locators          June 1995

2.4.  Parsing a URL

   An accepted method for parsing URLs is useful to clarify the
   generic-RL syntax of Section 2.2 and to describe the algorithm for
   resolving relative URLs presented in Section 4.  This section
   describes the parsing rules for breaking down a URL (relative or
   absolute) into the component parts described in Section 2.1.  The
   rules assume that the URL has already been separated from any
   surrounding text and copied to a "parse string".  The rules are
   listed in the order in which they would be applied by the parser.
}

{
2.4.1.  Parsing the Fragment Identifier

   If the parse string contains a crosshatch "#" character, then the
   substring after the first (left-most) crosshatch "#" and up to the
   end of the parse string is the <fragment> identifier.  If the
   crosshatch is the last character, or no crosshatch is present, then
   the fragment identifier is empty.  The matched substring, including
   the crosshatch character, is removed from the parse string before
   continuing.

   Note that the fragment identifier is not considered part of the URL.
   However, since it is often attached to the URL, parsers must be able
   to recognize and set aside fragment identifiers as part of the
   process.
}

function ParseFragment( var ParseString: string ): string;
begin
  Result := GetToEnd('#', ParseString, TRUE);
end;

{
2.4.2.  Parsing the Scheme

   If the parse string contains a colon ":" after the first character
   and before any characters not allowed as part of a scheme name (i.e.,
   any not an alphanumeric, plus "+", period ".", or hyphen "-"), the
   <scheme> of the URL is the substring of characters up to but not
   including the first colon.  These characters and the colon are then
   removed from the parse string before continuing.
}

function ParseScheme( var ParseString: string ): string;
var
  Temp                : string;
  SPtr, EPtr          : PChar;
begin
  Result := SchemeDefault;
  if ParseString <> '' then
    begin
      //  Temp := ParseString;
      SetString( Temp, PChar( ParseString ), Length( ParseString ) );

      SPtr := PChar( Temp );
      EPtr := SPtr;

      while EPtr^ in [ '1'..'0', 'A'..'Z', 'a'..'z', '+', '.', '-' ] do
        Inc( Eptr );

      if ( EPtr^ = ':' ) and ( ( EPtr + 1 )^ = '/' ) then
        begin
          inc( EPtr );
          EPtr^ := #0;
          Result := string( SPtr );
          Delete( ParseString, 1, EPtr - SPtr );
        end;
    end;
end;

{
2.4.3.  Parsing the Network Location/Login

   If the parse string begins with a double-slash "//", then the
   substring of characters after the double-slash and up to, but not
   including, the next slash "/" character is the network location/login
   (<net_loc>) of the URL.  If no trailing slash "/" is present, the
   entire remaining parse string is assigned to <net_loc>.  The double-
   slash and <net_loc> are removed from the parse string before
   continuing.
}

function ParseNetworkLocation( var ParseString: string ): string;
var
  Temp                : string;
  SPtr, EPtr          : PChar;
  I                   : Integer;
begin
  Result := '';
  if ParseString <> '' then
    begin
      SetString( Temp, PChar( ParseString ), Length( ParseString ) );

      SPtr := PChar( Temp );
      EPtr := SPtr;

      if ( EPtr^ = '/' ) and ( ( EPtr + 1 )^ = '/' ) then
        begin
          inc( EPtr, 2 );
          while not ( Eptr^ in [ #0, '/' ] ) do
            inc( EPtr );

          EPtr^ := #0;
          Result := string( SPtr + 2 );
          Delete( ParseString, 1, EPtr - SPtr );
        end
      else
        begin
          I := Pos( '/', ParseString );
          if I > 1 then
            begin
              Result := Copy( ParseString, 1, I - 1 );
              Delete( ParseString, 1, I - 1 );
            end
          else if I = 0 then
            begin
              Result := ParseString;
              ParseString := '';
            end
        end;
    end;
end;

{
2.4.4.  Parsing the Query Information

   If the parse string contains a question mark "?" character, then the
   substring after the first (left-most) question mark "?" and up to the
   end of the parse string is the <query> information.  If the question
   mark is the last character, or no question mark is present, then the
   query information is empty.  The matched substring, including the
   question mark character, is removed from the parse string before
   continuing.
}

function ParseQuery( var ParseString: string ): string;
begin
  Result := GetToEnd('?', ParseString, TRUE);
end;

{
2.4.5.  Parsing the Parameters

   If the parse string contains a semicolon ";" character, then the
   substring after the first (left-most) semicolon ";" and up to the end
   of the parse string is the parameters (<params>).  If the semicolon
   is the last character, or no semicolon is present, then <params> is
   empty.  The matched substring, including the semicolon character, is
   removed from the parse string before continuing.
}

function ParseParameters( var ParseString: string ): string;
begin
  Result := GetToEnd(';', ParseString, TRUE);
end;

{
        Parsing the Resource

   After the above steps, what is left of the parse string is the
   URL <path> and the slash "/" that may precede it and the Resource
   The resource is not specified in the RFC, it's our way of futher
   breaking down the URL into meaningful sections.
}

function ParseResource( var ParseString: string ): string;
var
  sPtr                : PChar;
  rPtr                : PChar;
begin
  if ParseString <> '' then
    begin
      sPtr := PChar( ParseString );
      if StrPos( sPtr, '.' ) <> nil then // If there is no dot, no resource
        begin
          rPtr := StrRScan( sPtr, '/' );
          rPtr^ := #0;
          inc( rPtr );
          Result := string( rPtr );
          dec( rPtr );
          rPtr^ := '/';
          inc( rPtr );
          rPtr^ := #0;
          SetLength( ParseString, StrLen( sPtr ) );
        end
      else
        Result := '';
    end;
end;

{
2.4.6.  Parsing the Path

   After the above steps, all that is left of the parse string is the
   URL <path> and the slash "/" that may precede it.  Even though the
   initial slash is not part of the URL path, the parser must remember
   whether or not it was present so that later processes can
   differentiate between relative and absolute paths.  Often this is
   done by simply storing the preceding slash along with the path.
}

function ParsePath( var ParseString: string ): string;
begin
  Result := ParseString;
end;

function ParsePassword( var ParseString: string ): string;
begin
  Result := GetToEnd(':', ParseString, FALSE);
end;

function ParseUserPassword( var ParseString: string ): string;
var
  I               : Integer;
begin
  Result := '';
  if ParseString <> '' then
    begin
      I := Pos( '@', ParseString );
      if I > 0 then
        begin
          Result := Copy( ParseString, 1, I - 1 );
          Delete( ParseString, 1, I );
        end;
    end;
end;

function ParsePort( var ParseString: string ): string;
begin
  Result := GetToEnd(':', ParseString, True);
end;

procedure ParseURL( URL: string; var FScheme, FUser, FPassword, FNetworkLocation, FPort, FPath, FResource, FParameters, FQuery, FFragment: string );
var
  ParseString         : string;

begin
  ParseString := URL;

  FFragment := ParseFragment( ParseString );
  FScheme := ParseScheme( ParseString );
  FNetworkLocation := ParseNetworkLocation( ParseString );
  FQuery := ParseQuery( ParseString );
  FParameters := ParseParameters( ParseString );
  FResource := ParseResource( ParseString );
  FPath := ParsePath( ParseString );
  If FPath = '' then
    FPath := '/';

  if FNetworkLocation <> '' then
    begin
      FUser := ParseUserPassword( FNetworkLocation );
      FPassword := ParsePassword( FUser );
      FPort := ParsePort( FNetworkLocation );
    end
  else
    begin
      FUser := '';
      FPassword := '';
    end;
end;

end.
