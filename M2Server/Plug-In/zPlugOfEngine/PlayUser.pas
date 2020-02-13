unit PlayUser;

interface
uses
  Windows, Classes, SysUtils, StrUtils, ExtCtrls, EngineAPI, EngineType;
const
  MAXBAGITEM = 46;
  RM_MENU_OK = 10309;

procedure InitPlayUser();
procedure UnInitPlayUser();
procedure LoadCheckItemList();
procedure UnLoadCheckItemList();

procedure InitMsgFilter();
procedure UnInitMsgFilter();
procedure LoadMsgFilterList();
procedure UnLoadMsgFilterList();

function IsFilterMsg(var sMsg: string): Boolean;
procedure FilterMsg(PlayObject: TObject; pszSrcMsg: PChar; pszDestMsg: PChar; nDestLen: Integer); stdcall;

function CheckCanDropItem(PlayObject: TPlayObject; pszItemName: PChar): Boolean; stdcall;
function CheckCanDealItem(PlayObject: TPlayObject; pszItemName: PChar): Boolean; stdcall;
function CheckCanStorageItem(PlayObject: TPlayObject; pszItemName: PChar): Boolean; stdcall;
function CheckCanRepairItem(PlayObject: TPlayObject; pszItemName: PChar): Boolean; stdcall;
implementation

uses HUtil32, PlugShare;

procedure InitPlayUser();
begin
  LoadCheckItemList();
  TPlayObject_SetCheckClientDropItem(CheckCanDropItem);
  TPlayObject_SetCheckClientDealItem(CheckCanDealItem);
  TPlayObject_SetCheckClientStorageItem(CheckCanStorageItem);
  TPlayObject_SetCheckClientRepairItem(CheckCanRepairItem);
end;

procedure UnInitPlayUser();
begin
  TPlayObject_SetCheckClientDropItem(nil);
  TPlayObject_SetCheckClientDealItem(nil);
  TPlayObject_SetCheckClientStorageItem(nil);
  TPlayObject_SetCheckClientRepairItem(nil);
  UnLoadCheckItemList();
end;

procedure LoadCheckItemList();
var
  I: Integer;
  sFileName: string;
  LoadList: Classes.TStringList;
  sLineText: string;
  sItemName: string;
  sCanDrop: string;
  sCanDeal: string;
  sCanStorage: string;
  sCanRepair: string;
  CheckItem: pTCheckItem;
begin
  sFileName := '.\CheckItemList.txt';

  if g_CheckItemList <> nil then begin
    UnLoadCheckItemList();
  end;
  g_CheckItemList := Classes.TList.Create;
  if not FileExists(sFileName) then begin
    LoadList := Classes.TStringList.Create();
    LoadList.Add(';引擎插件禁止物品配置文件');
    LoadList.Add(';物品名称'#9'扔'#9'交易'#9'存'#9'修');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;
  LoadList := Classes.TStringList.Create();
  LoadList.LoadFromFile(sFileName);
  for I := 0 to LoadList.Count - 1 do begin
    sLineText := LoadList.Strings[I];
    if (sLineText <> '') and (sLineText[1] <> ';') then begin
      sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sCanDrop, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sCanDeal, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sCanStorage, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sCanRepair, [' ', #9]);
      if (sItemName <> '') then begin
        New(CheckItem);
        CheckItem.szItemName := sItemName;
        CheckItem.boCanDrop := sCanDrop = '1';
        CheckItem.boCanDeal := sCanDeal = '1';
        CheckItem.boCanStorage := sCanStorage = '1';
        CheckItem.boCanRepair := sCanRepair = '1';
        g_CheckItemList.Add(CheckItem);
      end;
    end;
  end;
  LoadList.Free;
end;
procedure UnLoadCheckItemList();
var
  I: Integer;
  CheckItem: pTCheckItem;
begin
  for I := 0 to g_CheckItemList.Count - 1 do begin
    CheckItem := g_CheckItemList.Items[I];
    Dispose(CheckItem);
  end;
  g_CheckItemList.Free;
  g_CheckItemList := nil;
end;
function CheckCanDropItem(PlayObject: TPlayObject; pszItemName: PChar): Boolean; stdcall;
resourcestring
  sMsg = '此物品禁止扔在地上！！！';
var
  I: Integer;
  CheckItem: pTCheckItem;
  NormNpc: TNormNpc;
begin
  Result := True;
  for I := 0 to g_CheckItemList.Count - 1 do begin
    CheckItem := g_CheckItemList.Items[I];
    if (CheckItem.boCanDrop) and (CompareText(CheckItem.szItemName, pszItemName) = 0) then begin
      NormNpc := TNormNpc_GetManageNpc();
      TBaseObject_SendMsg(PlayObject, NormNpc, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, PChar(sMsg));
      Result := False;
      break;
    end;
  end;
end;
function CheckCanDealItem(PlayObject: TPlayObject; pszItemName: PChar): Boolean; stdcall;
resourcestring
  sMsg = '此物品禁止交易！！！';
var
  I: Integer;
  CheckItem: pTCheckItem;
  NormNpc: TNormNpc;
begin
  Result := True;
  for I := 0 to g_CheckItemList.Count - 1 do begin
    CheckItem := g_CheckItemList.Items[I];
    if (CheckItem.boCanDeal) and (CompareText(CheckItem.szItemName, pszItemName) = 0) then begin
      NormNpc := TNormNpc_GetManageNpc();
      TBaseObject_SendMsg(PlayObject, NormNpc, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, PChar(sMsg));
      Result := False;
      break;
    end;
  end;
end;
function CheckCanStorageItem(PlayObject: TPlayObject; pszItemName: PChar): Boolean; stdcall;
resourcestring
  sMsg = '此物品禁止存仓库！！！';
var
  I: Integer;
  CheckItem: pTCheckItem;
  NormNpc: TNormNpc;
begin
  Result := True;
  for I := 0 to g_CheckItemList.Count - 1 do begin
    CheckItem := g_CheckItemList.Items[I];
    if (CheckItem.boCanStorage) and (CompareText(CheckItem.szItemName, pszItemName) = 0) then begin
      NormNpc := TNormNpc_GetManageNpc();
      TBaseObject_SendMsg(PlayObject, NormNpc, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, PChar(sMsg));
      Result := False;
      break;
    end;
  end;
end;
function CheckCanRepairItem(PlayObject: TPlayObject; pszItemName: PChar): Boolean; stdcall;
resourcestring
  sMsg = '此物品禁止修理！！！';
var
  I: Integer;
  CheckItem: pTCheckItem;
  NormNpc: TNormNpc;
begin
  Result := True;
  for I := 0 to g_CheckItemList.Count - 1 do begin
    CheckItem := g_CheckItemList.Items[I];
    if (CheckItem.boCanRepair) and (CompareText(CheckItem.szItemName, pszItemName) = 0) then begin
      NormNpc := TNormNpc_GetManageNpc();
      TBaseObject_SendMsg(PlayObject, NormNpc, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, PChar(sMsg));
      Result := False;
      break;
    end;
  end;
end;
//==============================================================================
function IsFilterMsg(var sMsg: string): Boolean;
var
  I: Integer;
  nLen: Integer;
  sReplaceText: string;
  sFilterText: string;
  FilterMsg: pTFilterMsg;
begin
  Result := False;
  if g_MsgFilterList = nil then begin
    Result := True;
    Exit;
  end;
  for I := 0 to g_MsgFilterList.Count - 1 do begin
    FilterMsg := g_MsgFilterList.Items[I];
    if (FilterMsg.sFilterMsg <> '') and (AnsiContainsText(sMsg, FilterMsg.sFilterMsg)) then begin
      sMsg := AnsiReplaceText(sMsg, FilterMsg.sFilterMsg, FilterMsg.sNewMsg);
      Result := True;
      break;
    end;
  end;
end;

procedure FilterMsg(PlayObject: TObject; pszSrcMsg: PChar; pszDestMsg: PChar; nDestLen: Integer);
var
  sSrcMsg: string;
begin
  sSrcMsg := StrPas(pszSrcMsg);
  IsFilterMsg(sSrcMsg);
  nDestLen := Length(sSrcMsg);
  Move(sSrcMsg[1], pszDestMsg^, nDestLen);
end;

procedure LoadMsgFilterList();
var
  I: Integer;
  sFileName: string;
  LoadList: Classes.TStringList;
  sLineText: string;
  sFilterMsg: string;
  sNewMsg: string;
  FilterMsg: pTFilterMsg;
begin
  sFileName := '.\MsgFilterList.txt';
  g_MsgFilterList.Clear;
  if not FileExists(sFileName) then begin
    LoadList := Classes.TStringList.Create;
    LoadList.Add(';引擎插件消息过滤配置文件');
    LoadList.Add(';过滤消息'#9'替换消息');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;
  LoadList := Classes.TStringList.Create();
  LoadList.LoadFromFile(sFileName);
  for I := 0 to LoadList.Count - 1 do begin
    sLineText := LoadList.Strings[I];
    if (sLineText <> '') and (sLineText[1] <> ';') then begin
      sLineText := GetValidStr3(sLineText, sFilterMsg, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sNewMsg, [' ', #9]);
      if (sFilterMsg <> '') then begin
        New(FilterMsg);
        FilterMsg^.sFilterMsg := sFilterMsg;
        FilterMsg^.sNewMsg := sNewMsg;
        g_MsgFilterList.Add(FilterMsg);
      end;
    end;
  end;
  LoadList.Free;
end;

procedure UnLoadMsgFilterList();
var
  I: Integer;
begin
  for I := 0 to g_MsgFilterList.Count - 1 do begin
    Dispose(g_MsgFilterList.Items[I]);
  end;
  g_MsgFilterList.Free;
  g_MsgFilterList := nil;
end;

procedure InitMsgFilter();
begin
  g_MsgFilterList := Classes.TList.Create;
  LoadMsgFilterList();
  TPlayObject_SetHookFilterMsg(FilterMsg);
end;

procedure UnInitMsgFilter();
begin
  TPlayObject_SetHookFilterMsg(nil);
  UnLoadMsgFilterList();
end;

end.

