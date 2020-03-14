unit Punishment;

interface

uses
  Windows, Messages, Classes, StrUtils, SysUtils;

var
  g_PunishList: TStringList;

implementation

initialization
  g_PunishList := TStringList.Create;
  g_PunishList.CaseSensitive := False;
  g_PunishList.Sorted := True;

finalization
  g_PunishList.Free;

end.
