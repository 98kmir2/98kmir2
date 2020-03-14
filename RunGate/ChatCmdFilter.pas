unit ChatCmdFilter;

interface

uses
  Windows, Messages, SysUtils, Classes, WinSock;

var
  g_ChatCmdFilterList: TStringList;

procedure LoadChatCmdFilterList();

implementation

uses
  ConfigManager, Protocol;

procedure LoadChatCmdFilterList();
var
  i, nIP: Integer;
  sList: TStringList;
begin
  sList := TStringList.Create;
  if not FileExists(_STR_CHAT_CMD_FILTER_FILE) then
    sList.SaveToFile(_STR_CHAT_CMD_FILTER_FILE);

  g_ChatCmdFilterList.Clear;
  sList := TStringList.Create;
  sList.LoadFromFile(_STR_CHAT_CMD_FILTER_FILE);
  for i := 0 to sList.Count - 1 do
  begin
    if sList[i] = '' then
      Continue;
    g_ChatCmdFilterList.Add(sList[i]);
  end;
  sList.Free;
end;

initialization
  g_ChatCmdFilterList := TStringList.Create;
  g_ChatCmdFilterList.CaseSensitive := False;
  g_ChatCmdFilterList.Sorted := True;

finalization
  g_ChatCmdFilterList.Free;

end.
