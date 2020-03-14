unit AbusiveFilter;

interface

uses
  Windows, Messages, Classes, StrUtils, SysUtils;

var
  g_AbuseList: TStringList;

procedure LoadChatFilterList();
function CheckChatFilter(var szChat: string; var fKick: BOOL): Byte;

implementation

uses
  ConfigManager, Protocol;

procedure LoadChatFilterList();
var
  i, nIP: Integer;
  sList: TStringList;
begin
  sList := TStringList.Create;
  if not FileExists(_STR_CHAT_FILTER_FILE) then
    sList.SaveToFile(_STR_CHAT_FILTER_FILE);

  g_AbuseList.Clear;
  sList := TStringList.Create;
  sList.LoadFromFile(_STR_CHAT_FILTER_FILE);
  for i := 0 to sList.Count - 1 do
  begin
    if sList[i] = '' then
      Continue;
    g_AbuseList.AddObject(sList[i], nil);
  end;
  sList.Free;
end;

function CheckChatFilter(var szChat: string; var fKick: BOOL): Byte;
var
  i, nLen, nCount: Integer;
  szFilter, szRplace: string;
begin
  Result := 0;
  nCount := 0;
  for i := 0 to g_AbuseList.Count - 1 do
  begin
    szFilter := g_AbuseList[i];
    if AnsiContainsText(szChat, szFilter) then
    begin
      Result := 1;
      case g_pConfig.m_tChatFilterMethod of
        ctDropconnect:
          begin
            fKick := False;
            Break;
          end;
        ctReplaceAll:
          begin
            Result := 2;
            szChat := g_pConfig.m_szChatFilterReplace;
            Break;
          end;
        ctReplaceOne:
          begin
            Result := 2;
            szRplace := '';
            for nLen := 1 to Length(szFilter) do
              szRplace := szRplace + '*';
            szChat := AnsiReplaceText(szChat, szFilter, szRplace);
            Inc(nCount);
            if nCount > 4 then
              Break;
          end;
      end;
      //Break;
    end;
  end;
end;

initialization
  g_AbuseList := TStringList.Create;

finalization
  g_AbuseList.Free;

end.
