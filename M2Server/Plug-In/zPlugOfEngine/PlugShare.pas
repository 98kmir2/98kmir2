unit PlugShare;

interface
uses
  Windows, Classes, EngineAPI, EngineType;
type
  TUserCommand = record
    nIndex: Integer;
    sCommandName: string[100];
  end;
  pTUserCommand = ^TUserCommand;

  TFilterMsg = record
    sFilterMsg: string[100];
    sNewMsg: string[100];
  end;
  pTFilterMsg = ^TFilterMsg;

  TCheckItem = record
    szItemName: string[14];
    boCanDrop: Boolean;
    boCanDeal: Boolean;
    boCanStorage: Boolean;
    boCanRepair: Boolean;
  end;
  pTCheckItem = ^TCheckItem;
  
var
  PlugHandle: Integer;

  g_UserCmdList: Classes.TStringList;
  g_CheckItemList: Classes.TList;
  g_MsgFilterList: Classes.TList;
  
implementation

end.

