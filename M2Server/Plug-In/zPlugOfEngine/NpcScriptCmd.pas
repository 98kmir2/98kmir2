unit NpcScriptCmd;

interface
uses
  Windows, SysUtils, EngineAPI, EngineType, PlugShare;
const
  nGIVEUSERITEM = 10000;
  szGIVEUSERITEM = 'GIVEUSERITEM';
  nTAKEUSERITEM = 10001;
  szTAKEUSERITEM = 'TAKEUSERITEM';

  nCHECKLEVEL = 10000;
  szCHECKLEVEL = 'CHECKLEVEL';

  szString = '@@InPutString';
  szInteger = '@@InPutInteger';

procedure InitNpcScriptCmd();
procedure UnInitNpcScriptCmd();
function ScriptActionCmd(pszCmd: PChar): Integer; stdcall;
function ScriptConditionCmd(pszCmd: PChar): Integer; stdcall;

procedure ScriptAction(Npc: TObject; PlayObject: TObject; nCmdCode: Integer; pszParam1: PChar;
  nParam1: Integer; pszParam2: PChar; nParam2: Integer;
  pszParam3: PChar; nParam3: Integer; pszParam4: PChar;
  nParam4: Integer; pszParam5: PChar; nParam5: Integer;
  pszParam6: PChar; nParam6: Integer); stdcall;

function ScriptCondition(Npc: TObject; PlayObject: TObject; nCmdCode: Integer; pszParam1: PChar;
  nParam1: Integer; pszParam2: PChar; nParam2: Integer;
  pszParam3: PChar; nParam3: Integer; pszParam4: PChar;
  nParam4: Integer; pszParam5: PChar; nParam5: Integer;
  pszParam6: PChar; nParam6: Integer): Boolean; stdcall;

procedure CheckUserSelect(Merchant: TMerchant; PlayObject: TPlayObject; pszLabel, pszData: PChar); stdcall;
var
  OldScriptActionCmd: _TSCRIPTCMD;
  OldScriptConditionCmd: _TSCRIPTCMD;
  OldScriptAction: _TSCRIPTACTION;
  OldScriptCondition: _TSCRIPTCONDITION;
  OldUserSelelt: _TOBJECTACTIONUSERSELECT;
implementation
uses HUtil32, PlayUser;

procedure InitNpcScriptCmd();
begin
  OldScriptActionCmd := TNormNpc_GetScriptActionCmd();
  OldScriptConditionCmd := TNormNpc_GetScriptConditionCmd();
  OldScriptAction := TNormNpc_GetScriptAction();
  OldScriptCondition := TNormNpc_GetScriptCondition();
  OldUserSelelt := TMerchant_GetCheckUserSelect();
  TNormNpc_SetScriptActionCmd(PlugHandle, ScriptActionCmd);
  TNormNpc_SetScriptConditionCmd(PlugHandle, ScriptConditionCmd);
  TNormNpc_SetScriptAction(PlugHandle, ScriptAction);
  TNormNpc_SetScriptCondition(PlugHandle, ScriptCondition);
  TMerchant_SetCheckUserSelect(PlugHandle, CheckUserSelect);
end;

procedure UnInitNpcScriptCmd();
begin
  TNormNpc_SetScriptActionCmd(PlugHandle, OldScriptActionCmd);
  TNormNpc_SetScriptConditionCmd(PlugHandle, OldScriptConditionCmd);
  TNormNpc_SetScriptAction(PlugHandle, OldScriptAction);
  TNormNpc_SetScriptCondition(PlugHandle, OldScriptCondition);
  TMerchant_SetCheckUserSelect(PlugHandle, OldUserSelelt);
end;

//获取用户输入信息
procedure CheckUserSelect(Merchant: TMerchant; PlayObject: TPlayObject; pszLabel, pszData: PChar);
var
  sLabel, sData: string;
  nData: Integer;
  nLength: Integer;
begin
  sLabel := StrPas(pszLabel);
  nLength := CompareText(sLabel, szString);
  if nLength > 0 then begin
    sLabel := Copy(sLabel, Length(szString) + 1, nLength);
    sData := StrPas(pszData);
    if not IsFilterMsg(sData) then begin
      TPlayObject_SetUserInPutString(PlayObject, pszData);
      TNormNpc_GotoLable(Merchant, PlayObject, PChar('@InPutString' + sLabel));
    end else begin
      TNormNpc_GotoLable(Merchant, PlayObject, PChar('@MsgFilter'));
    end;
    Exit;
  end else
  nLength := CompareText(sLabel, szInteger);
  if nLength > 0 then begin
    sLabel := Copy(sLabel, Length(szInteger) + 1, nLength);
    sData := StrPas(pszData);
    nData := Str_ToInt(sData, -1);
    TPlayObject_SetUserInPutInteger(PlayObject, nData);
    TNormNpc_GotoLable(Merchant, PlayObject, PChar('@InPutInteger' + sLabel));
    Exit;
  end else begin
    //调用下一个插件处理函数
    if Assigned(OldUserSelelt) then begin
      OldUserSelelt(Merchant, PlayObject, pszLabel, pszData);
    end;
  end;
end;

function ScriptActionCmd(pszCmd: PChar): Integer; stdcall;
begin
  if StrIComp(pszCmd, szGIVEUSERITEM) = 0 then begin
    Result := nGIVEUSERITEM;
  end else
    if StrIComp(pszCmd, szTAKEUSERITEM) = 0 then begin
    Result := nTAKEUSERITEM;
  end else begin
    Result := -1;
  end;
  if (Result < 0) and Assigned(OldScriptActionCmd) then begin
    Result := OldScriptActionCmd(pszCmd);
  end;
end;

function ScriptConditionCmd(pszCmd: PChar): Integer; stdcall;
begin
  if StrIComp(pszCmd, szCHECKLEVEL) = 0 then begin
    Result := nCHECKLEVEL;
  end else begin
    Result := -1;
  end;
  if (Result < 0) and Assigned(OldScriptConditionCmd) then begin
    //调用下一个插件处理函数
    Result := OldScriptConditionCmd(pszCmd);
  end;
end;

procedure ActionOfGiveUserItem(Npc: TObject; PlayObject: TObject; pszItemName: PChar; nCount: Integer);
begin

end;

procedure ActionOfTakeUserItem(Npc: TObject; PlayObject: TObject; pszItemName: PChar; nCount: Integer);
begin

end;

procedure ScriptAction(Npc: TObject; PlayObject: TObject; nCmdCode: Integer; pszParam1: PChar;
  nParam1: Integer; pszParam2: PChar; nParam2: Integer;
  pszParam3: PChar; nParam3: Integer; pszParam4: PChar;
  nParam4: Integer; pszParam5: PChar; nParam5: Integer;
  pszParam6: PChar; nParam6: Integer); stdcall;
begin
  case nCmdCode of
    nGIVEUSERITEM: ActionOfGiveUserItem(Npc, PlayObject, pszParam1, nParam2);
    nTAKEUSERITEM: ActionOfTakeUserItem(Npc, PlayObject, pszParam1, nParam2);
  end;
end;

function ScriptCondition(Npc: TObject; PlayObject: TObject; nCmdCode: Integer; pszParam1: PChar;
  nParam1: Integer; pszParam2: PChar; nParam2: Integer;
  pszParam3: PChar; nParam3: Integer; pszParam4: PChar;
  nParam4: Integer; pszParam5: PChar; nParam5: Integer;
  pszParam6: PChar; nParam6: Integer): Boolean; stdcall;
begin
  Result := TRUE;
  case nCmdCode of
    nCHECKLEVEL: ;
  end;
end;

end.

