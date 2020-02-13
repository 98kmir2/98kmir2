unit ClFunc;

interface

uses
  Windows, Messages, SysUtils, DXDraws;

procedure DxBoldTextOut(Surface: TDirectDrawSurface; X, Y, fcolor, bcolor: Integer; szText: string; bold: Byte = 1; bk: Integer = 1; Alpha: Integer = 255);

implementation

procedure DxBoldTextOut(Surface: TDirectDrawSurface; X, Y, fcolor, bcolor: Integer; szText: string; bold: Byte; bk: Integer; Alpha: Integer);
begin
  //
end;

end.

