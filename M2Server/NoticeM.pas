unit NoticeM;

interface

uses
  Windows, Classes, SysUtils;

type
  TNoticeMsg = record
    sMsg: string;
    sList: TStringList;
  end;
  TNoticeList = array[0..99] of TNoticeMsg;

  TNoticeManager = class
  private
    NoticeList: TNoticeList;
  public
    constructor Create();
    destructor Destroy; override;
    function GetNoticeMsg(sStr: string; LoadList: TStringList): Boolean;
    procedure LoadingNotice();
  end;

implementation

uses M2Share;

constructor TNoticeManager.Create;
var
  i: Integer;
begin
  for i := Low(NoticeList) to High(NoticeList) do
  begin
    NoticeList[i].sMsg := '';
    NoticeList[i].sList := nil;
  end;
end;

destructor TNoticeManager.Destroy;
var
  i: Integer;
begin
  for i := Low(NoticeList) to High(NoticeList) do
  begin
    if NoticeList[i].sList <> nil then
      NoticeList[i].sList.Free;
  end;
  inherited;
end;

procedure TNoticeManager.LoadingNotice();
var
  sFileName: string;
  i: Integer;
begin
  for i := Low(NoticeList) to High(NoticeList) do
  begin
    if NoticeList[i].sMsg = '' then
      Continue;
    sFileName := g_Config.sNoticeDir + NoticeList[i].sMsg + '.txt';
    if FileExists(sFileName) then
    begin
      try
        if NoticeList[i].sList = nil then
          NoticeList[i].sList := TStringList.Create;
        NoticeList[i].sList.LoadFromFile(sFileName);
      except
        MainOutMessageAPI('Error in loading notice text. file name is ' + sFileName);
      end;
    end;
  end;
end;

function TNoticeManager.GetNoticeMsg(sStr: string; LoadList: TStringList): Boolean;
var
  bo15: Boolean;
  n14: Integer;
  sFileName: string;
begin
  Result := False;
  bo15 := True;
  for n14 := Low(NoticeList) to High(NoticeList) do
  begin
    if CompareText(NoticeList[n14].sMsg, sStr) = 0 then
    begin
      if NoticeList[n14].sList <> nil then
      begin
        LoadList.AddStrings(NoticeList[n14].sList);
        Result := True;
      end;
      bo15 := False;
    end;
  end;
  if not bo15 then
    Exit;
  for n14 := Low(NoticeList) to High(NoticeList) do
  begin
    if NoticeList[n14].sMsg = '' then
    begin
      sFileName := g_Config.sNoticeDir + sStr + '.txt';
      if FileExists(sFileName) then
      begin
        try
          if NoticeList[n14].sList = nil then
            NoticeList[n14].sList := TStringList.Create;
          NoticeList[n14].sList.LoadFromFile(sFileName);
          LoadList.AddStrings(NoticeList[n14].sList);
        except
          MainOutMessageAPI('Error in loading notice text. file name is ' + sFileName);
        end;
        NoticeList[n14].sMsg := sStr;
        Result := True;
        Break;
      end;
    end;
  end;
end;

end.
