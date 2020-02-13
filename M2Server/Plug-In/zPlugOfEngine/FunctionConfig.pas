unit FunctionConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls, EngineAPI, EngineType, Menus, IniFiles;

type
  TFrmFunctionConfig = class(TForm)
    FunctionConfigControl: TPageControl;
    Label14: TLabel;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet5: TTabSheet;
    GroupBox21: TGroupBox;
    ListBoxitemList: TListBox;
    ButtonDisallowDel: TButton;
    ButtonDisallowSave: TButton;
    GroupBox22: TGroupBox;
    ListViewMsgFilter: TListView;
    GroupBox23: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    EditFilterMsg: TEdit;
    EditNewMsg: TEdit;
    ButtonMsgFilterAdd: TButton;
    ButtonMsgFilterDel: TButton;
    ButtonMsgFilterSave: TButton;
    ButtonMsgFilterChg: TButton;
    GroupBox5: TGroupBox;
    ListBoxUserCommand: TListBox;
    Label3: TLabel;
    EditCommandName: TEdit;
    ButtonUserCommandAdd: TButton;
    Label4: TLabel;
    SpinEditCommandIdx: TSpinEdit;
    ButtonUserCommandDel: TButton;
    ButtonUserCommandChg: TButton;
    GroupBox1: TGroupBox;
    ButtonDisallowDrop: TButton;
    ButtonDisallowDeal: TButton;
    ButtonDisallowStorage: TButton;
    ListViewDisallow: TListView;
    ButtonDisallowRepair: TButton;
    ButtonUserCommandSave: TButton;
    ButtonLoadCheckItemList: TButton;
    ButtonLoadUserCommandList: TButton;
    ButtonLoadMsgFilterList: TButton;
    procedure ListBoxUserCommandClick(Sender: TObject);
    procedure ButtonUserCommandAddClick(Sender: TObject);
    procedure ButtonUserCommandDelClick(Sender: TObject);
    procedure ButtonUserCommandChgClick(Sender: TObject);
    procedure ButtonUserCommandSaveClick(Sender: TObject);
    procedure ButtonLoadUserCommandListClick(Sender: TObject);
    procedure ListBoxitemListDblClick(Sender: TObject);
    procedure ListViewDisallowClick(Sender: TObject);
    procedure ButtonDisallowDropClick(Sender: TObject);
    procedure ButtonDisallowDealClick(Sender: TObject);
    procedure ButtonDisallowStorageClick(Sender: TObject);
    procedure ButtonDisallowRepairClick(Sender: TObject);
    procedure ButtonDisallowDelClick(Sender: TObject);
    procedure ButtonDisallowSaveClick(Sender: TObject);
    procedure ButtonLoadCheckItemListClick(Sender: TObject);
    procedure ListViewMsgFilterClick(Sender: TObject);
    procedure ButtonLoadMsgFilterListClick(Sender: TObject);
    procedure ButtonMsgFilterSaveClick(Sender: TObject);
    procedure ButtonMsgFilterAddClick(Sender: TObject);
    procedure ButtonMsgFilterChgClick(Sender: TObject);
    procedure ButtonMsgFilterDelClick(Sender: TObject);
  private
    { Private declarations }
    procedure RefLoadMsgFilterList();
    procedure RefLoadDisallowStdItems();
    function InCommandListOfName(sCommandName: string): Boolean;
    function InCommandListOfIndex(nIndex: Integer): Boolean;
    function InListBoxitemList(sItemName: string): Boolean;
    function InFilterMsgList(sFilterMsg: string): Boolean;
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmFunctionConfig: TFrmFunctionConfig;
  boModValued, boOpened: Boolean;
  boButtonDrop: Boolean;
  boButtonDeal: Boolean;
  boButtonStorage: Boolean;
  boButtonRepair: Boolean;
implementation
uses
  PlayUserCmd, PlayUser, PlugShare;
{$R *.dfm}

procedure TFrmFunctionConfig.Open();
var
  I: Integer;
  StdItem: _LPTOSTDITEM;
  List: Classes.TList;
begin
  boOpened := False;
  boModValued := False;
  ButtonUserCommandDel.Enabled := False;
  ButtonUserCommandChg.Enabled := False;
  ButtonDisallowDel.Enabled := False;
  ButtonMsgFilterDel.Enabled := False;
  ButtonMsgFilterChg.Enabled := False;
  ListBoxitemList.Items.Clear;
  ListBoxUserCommand.Items.Clear;
  List := Classes.TList(TUserEngine_GetStdItemList);
  for I := 0 to List.Count - 1 do begin
    StdItem := List.Items[I];
    ListBoxitemList.Items.AddObject(StdItem.szName, TObject(StdItem));
  end;
  RefLoadMsgFilterList();
  RefLoadDisallowStdItems();
  ListBoxUserCommand.Items.Clear;
  ListBoxUserCommand.Items.AddStrings(g_UserCmdList);
  boOpened := True;
  FunctionConfigControl.ActivePageIndex := 0;
  ShowModal;
end;

procedure TFrmFunctionConfig.ListBoxUserCommandClick(Sender: TObject);
var
  nItemIndex: Integer;
begin
  try
    nItemIndex := ListBoxUserCommand.ItemIndex;
    EditCommandName.Text := ListBoxUserCommand.Items.Strings[nItemIndex];
    SpinEditCommandIdx.Value := Integer(ListBoxUserCommand.Items.Objects[nItemIndex]);
    ButtonUserCommandDel.Enabled := True;
    ButtonUserCommandChg.Enabled := True;
  except
    EditCommandName.Text := '';
    SpinEditCommandIdx.Value := 0;
    ButtonUserCommandDel.Enabled := False;
    ButtonUserCommandChg.Enabled := False;
  end;
end;

function TFrmFunctionConfig.InCommandListOfIndex(nIndex: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to ListBoxUserCommand.Items.Count - 1 do begin
    if nIndex = Integer(ListBoxUserCommand.Items.Objects[I]) then begin
      Result := True;
      Break;
    end;
  end;
end;

function TFrmFunctionConfig.InCommandListOfName(sCommandName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to ListBoxUserCommand.Items.Count - 1 do begin
    if CompareText(sCommandName, ListBoxUserCommand.Items.Strings[I]) = 0 then begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TFrmFunctionConfig.ButtonUserCommandAddClick(Sender: TObject);
var
  sCommandName: string;
  nCommandIndex: Integer;
begin
  sCommandName := Trim(EditCommandName.Text);
  nCommandIndex := SpinEditCommandIdx.Value;
  if sCommandName = '' then begin
    Application.MessageBox('请输入命令！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if InCommandListOfName(sCommandName) then begin
    Application.MessageBox('输入的命令已经存在，请选择其他命令！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if InCommandListOfIndex(nCommandIndex) then begin
    Application.MessageBox('输入的命令编号已经存在，请选择其他命令编号！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  ListBoxUserCommand.Items.AddObject(sCommandName, TObject(nCommandIndex));
end;

procedure TFrmFunctionConfig.ButtonUserCommandDelClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认删除此命令？', '确认信息', MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    try
      ListBoxUserCommand.DeleteSelected;
    except
    end;
  end;
end;

procedure TFrmFunctionConfig.ButtonUserCommandChgClick(Sender: TObject);
var
  sCommandName: string;
  nCommandIndex: Integer;
  I, nItemIndex: Integer;
begin
  sCommandName := Trim(EditCommandName.Text);
  nCommandIndex := SpinEditCommandIdx.Value;
  if sCommandName = '' then begin
    Application.MessageBox('请输入命令！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if InCommandListOfName(sCommandName) then begin
    Application.MessageBox('你要修改的命令已经存在，请选择其他命令！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if InCommandListOfIndex(nCommandIndex) then begin
    Application.MessageBox('你要修改的命令编号已经存在，请选择其他命令编号！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  nItemIndex := ListBoxUserCommand.ItemIndex;
  try
    ListBoxUserCommand.Items.Strings[nItemIndex] := sCommandName;
    ListBoxUserCommand.Items.Objects[nItemIndex] := TObject(nCommandIndex);
    Application.MessageBox('修改完成！！！', '提示信息', MB_ICONQUESTION);
  except
    Application.MessageBox('修改失败！！！', '提示信息', MB_ICONQUESTION);
  end;
end;

procedure TFrmFunctionConfig.ButtonUserCommandSaveClick(Sender: TObject);
var
  sFileName: string;
  I: Integer;
  sCommandName: string;
  nCommandIndex: Integer;
  SaveList: Classes.TStringList;
begin
  ButtonUserCommandSave.Enabled := False;
  sFileName := '.\UserCmd.txt';
  SaveList := Classes.TStringList.Create;
  SaveList.Add(';引擎插件配置文件');
  SaveList.Add(';命令名称'#9'对应编号');
  for I := 0 to ListBoxUserCommand.Items.Count - 1 do begin
    sCommandName := ListBoxUserCommand.Items.Strings[I];
    nCommandIndex := Integer(ListBoxUserCommand.Items.Objects[I]);
    SaveList.Add(sCommandName + #9 + IntToStr(nCommandIndex));
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Application.MessageBox('保存完成！！！', '提示信息', MB_ICONQUESTION);
  ButtonUserCommandSave.Enabled := True;
end;

procedure TFrmFunctionConfig.ButtonLoadUserCommandListClick(
  Sender: TObject);
begin
  ButtonLoadUserCommandList.Enabled := False;
  LoadUserCmdList();
  ListBoxUserCommand.Items.Clear;
  ListBoxUserCommand.Items.AddStrings(g_UserCmdList);
  Application.MessageBox('重新加载自定义命令列表完成！！！', '提示信息', MB_ICONQUESTION);
  ButtonLoadUserCommandList.Enabled := True;
end;

function TFrmFunctionConfig.InListBoxitemList(sItemName: string): Boolean;
var
  I: Integer;
  ListItem: TListItem;
begin
  Result := False;
  ListViewDisallow.Items.BeginUpdate;
  try
    for I := 0 to ListViewDisallow.Items.Count - 1 do begin
      ListItem := ListViewDisallow.Items.Item[I];
      if CompareText(sItemName, ListItem.Caption) = 0 then begin
        Result := True;
        Break;
      end;
    end;
  finally
    ListViewDisallow.Items.EndUpdate;
  end;
end;

procedure TFrmFunctionConfig.ListBoxitemListDblClick(Sender: TObject);
var
  ListItem: TListItem;
  sItemName: string;
  I: Integer;
  nItemIndex:Integer;
begin
  nItemIndex:=ListBoxitemList.ItemIndex;
  try
    sItemName := ListBoxitemList.Items.Strings[nItemIndex];
  except
    sItemName := '';
  end;
  if (sItemName <> '') then begin
    if InListBoxitemList(sItemName) then begin
      Application.MessageBox('你要选择的物品已经在禁止物品列表中，请选择其他物品！！！', '提示信息', MB_ICONQUESTION);
      Exit;
    end;
    ListViewDisallow.Items.BeginUpdate;
    try
      ListItem := ListViewDisallow.Items.Add;
      ListItem.Caption := sItemName;
      ListItem.SubItems.Add('0');
      ListItem.SubItems.Add('0');
      ListItem.SubItems.Add('0');
      ListItem.SubItems.Add('0');
    finally
      ListViewDisallow.Items.EndUpdate;
    end;
  end;
end;

procedure TFrmFunctionConfig.ListViewDisallowClick(Sender: TObject);
var
  ListItem: TListItem;
  boCanDrop: Boolean;
  boCanDeal: Boolean;
  boCanStorage: Boolean;
  boCanRepair: Boolean;
  nItemIndex:Integer;
begin
  try
    nItemIndex:=ListViewDisallow.ItemIndex;
    ListItem := ListViewDisallow.Items.Item[nItemIndex];
    boCanDrop := Boolean(StrToInt(ListItem.SubItems.Strings[0]));
    boCanDeal := Boolean(StrToInt(ListItem.SubItems.Strings[1]));
    boCanStorage := Boolean(StrToInt(ListItem.SubItems.Strings[2]));
    boCanRepair := Boolean(StrToInt(ListItem.SubItems.Strings[3]));
    ButtonDisallowDrop.Enabled := True;
    ButtonDisallowDeal.Enabled := True;
    ButtonDisallowStorage.Enabled := True;
    ButtonDisallowRepair.Enabled := True;
    ButtonDisallowDel.Enabled := True;
    if not boCanDrop then begin
      ButtonDisallowDrop.Caption := '禁止仍';
      boButtonDrop := False;
    end else begin
      ButtonDisallowDrop.Caption := '允许仍';
      boButtonDrop := True;
    end;
    if not boCanDeal then begin
      ButtonDisallowDeal.Caption := '禁止交易';
      boButtonDeal := False;
    end else begin
      ButtonDisallowDeal.Caption := '允许交易';
      boButtonDeal := True;
    end;
    if not boCanStorage then begin
      ButtonDisallowStorage.Caption := '禁止存';
      boButtonStorage := False;
    end else begin
      ButtonDisallowStorage.Caption := '允许存';
      boButtonStorage := True;
    end;
    if not boCanRepair then begin
      ButtonDisallowRepair.Caption := '禁止修理';
      boButtonRepair := False;
    end else begin
      ButtonDisallowRepair.Caption := '允许修理';
      boButtonRepair := True;
    end;
  except
    ButtonDisallowDrop.Enabled := False;
    ButtonDisallowDeal.Enabled := False;
    ButtonDisallowStorage.Enabled := False;
    ButtonDisallowRepair.Enabled := False;
    ButtonDisallowDel.Enabled := False;
  end;
end;

procedure TFrmFunctionConfig.ButtonDisallowDropClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  try
    ListItem := ListViewDisallow.Items.Item[ListViewDisallow.ItemIndex];
    if boButtonDrop then begin
      ListItem.SubItems.Strings[0] := '0';
      boButtonDrop := False;
      ButtonDisallowDrop.Caption := '禁止仍';
    end else begin
      ListItem.SubItems.Strings[0] := '1';
      boButtonDrop := True;
      ButtonDisallowDrop.Caption := '允许仍';
    end;
  except
  end;
end;

procedure TFrmFunctionConfig.ButtonDisallowDealClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  try
    ListItem := ListViewDisallow.Items.Item[ListViewDisallow.ItemIndex];
    if boButtonDeal then begin
      ListItem.SubItems.Strings[1] := '0';
      boButtonDeal := False;
      ButtonDisallowDeal.Caption := '禁止交易';
    end else begin
      ListItem.SubItems.Strings[1] := '1';
      boButtonDeal := True;
      ButtonDisallowDeal.Caption := '允许交易';
    end;
  except
  end;
end;

procedure TFrmFunctionConfig.ButtonDisallowStorageClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  try
    ListItem := ListViewDisallow.Items.Item[ListViewDisallow.ItemIndex];
    if boButtonStorage then begin
      ListItem.SubItems.Strings[2] := '0';
      boButtonStorage := False;
      ButtonDisallowStorage.Caption := '禁止存';
    end else begin
      ListItem.SubItems.Strings[2] := '1';
      boButtonStorage := True;
      ButtonDisallowStorage.Caption := '允许存';
    end;
  except
  end;
end;

procedure TFrmFunctionConfig.ButtonDisallowRepairClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  try
    ListItem := ListViewDisallow.Items.Item[ListViewDisallow.ItemIndex];
    if boButtonRepair then begin
      ListItem.SubItems.Strings[3] := '0';
      boButtonRepair := False;
      ButtonDisallowRepair.Caption := '禁止修理';
    end else begin
      ListItem.SubItems.Strings[3] := '1';
      boButtonRepair := True;
      ButtonDisallowRepair.Caption := '允许修理';
    end;
  except
  end;
end;

procedure TFrmFunctionConfig.ButtonDisallowDelClick(Sender: TObject);
begin
  try
    ListViewDisallow.DeleteSelected;
  except
  end;
end;

procedure TFrmFunctionConfig.RefLoadDisallowStdItems();
var
  I: Integer;
  ListItem: TListItem;
  CheckItem: pTCheckItem;
  sItemName: string;
  sCanDrop: string;
  sCanDeal: string;
  sCanStorage: string;
  sCanRepair: string;
begin
  ListViewDisallow.Items.Clear;
  for I := 0 to g_CheckItemList.Count - 1 do begin
    CheckItem := pTCheckItem(g_CheckItemList.Items[I]);
    sItemName := CheckItem.szItemName;
    sCanDrop := IntToStr(Integer(CheckItem.boCanDrop));
    sCanDeal := IntToStr(Integer(CheckItem.boCanDeal));
    sCanStorage := IntToStr(Integer(CheckItem.boCanStorage));
    sCanRepair := IntToStr(Integer(CheckItem.boCanRepair));
    ListViewDisallow.Items.BeginUpdate;
    try
      ListItem := ListViewDisallow.Items.Add;
      ListItem.Caption := sItemName;
      ListItem.SubItems.Add(sCanDrop);
      ListItem.SubItems.Add(sCanDeal);
      ListItem.SubItems.Add(sCanStorage);
      ListItem.SubItems.Add(sCanRepair);
    finally
      ListViewDisallow.Items.EndUpdate;
    end;
  end;
end;

procedure TFrmFunctionConfig.ButtonDisallowSaveClick(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  SaveList: Classes.TStringList;
  sFileName: string;
  sLineText: string;
  sItemName: string;
  sCanDrop: string;
  sCanDeal: string;
  sCanStorage: string;
  sCanRepair: string;
begin
  ButtonDisallowSave.Enabled := False;
  sFileName := '.\CheckItemList.txt';
  SaveList := Classes.TStringList.Create;
  SaveList.Add(';引擎插件禁止物品配置文件');
  SaveList.Add(';物品名称'#9'扔'#9'交易'#9'存'#9'修');
  ListViewDisallow.Items.BeginUpdate;
  try
    for I := 0 to ListViewDisallow.Items.Count - 1 do begin
      ListItem := ListViewDisallow.Items.Item[I];
      sItemName := ListItem.Caption;
      sCanDrop := ListItem.SubItems.Strings[0];
      sCanDeal := ListItem.SubItems.Strings[1];
      sCanStorage := ListItem.SubItems.Strings[2];
      sCanRepair := ListItem.SubItems.Strings[3];
      sLineText := sItemName + #9 + sCanDrop + #9 + sCanDeal + #9 + sCanStorage + #9 + sCanRepair;
      SaveList.Add(sLineText);
    end;
  finally
    ListViewDisallow.Items.EndUpdate;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Application.MessageBox('保存完成！！！', '提示信息', MB_ICONQUESTION);
  ButtonDisallowSave.Enabled := True;
end;

procedure TFrmFunctionConfig.ButtonLoadCheckItemListClick(Sender: TObject);
begin
  LoadCheckItemList();
  RefLoadDisallowStdItems();
  Application.MessageBox('重新加载禁止物品配置完成！！！', '提示信息', MB_ICONQUESTION);
end;

procedure TFrmFunctionConfig.RefLoadMsgFilterList();
var
  I: Integer;
  ListItem: TListItem;
  FilterMsg: pTFilterMsg;
begin
  ListViewMsgFilter.Items.BeginUpdate;
  ListViewMsgFilter.Items.Clear;
  try
    for I := 0 to g_MsgFilterList.Count - 1 do begin
      ListItem := ListViewMsgFilter.Items.Add;
      FilterMsg := g_MsgFilterList.Items[I];
      ListItem.Caption := FilterMsg.sFilterMsg;
      ListItem.SubItems.Add(FilterMsg.sNewMsg);
    end;
  finally
    ListViewMsgFilter.Items.EndUpdate;
  end;
end;

procedure TFrmFunctionConfig.ListViewMsgFilterClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  try
    ListItem := ListViewMsgFilter.Items.Item[ListViewMsgFilter.ItemIndex];
    EditFilterMsg.Text := ListItem.Caption;
    EditNewMsg.Text := ListItem.SubItems.Strings[0];
    ButtonMsgFilterDel.Enabled := True;
    ButtonMsgFilterChg.Enabled := True;
  except
    EditFilterMsg.Text := '';
    EditNewMsg.Text := '';
    ButtonMsgFilterDel.Enabled := False;
    ButtonMsgFilterChg.Enabled := False;
  end;
end;

procedure TFrmFunctionConfig.ButtonLoadMsgFilterListClick(Sender: TObject);
begin
  LoadMsgFilterList();
  RefLoadMsgFilterList();
  Application.MessageBox('重新加载消息过滤列表完成！！！', '提示信息', MB_ICONQUESTION);
end;

procedure TFrmFunctionConfig.ButtonMsgFilterSaveClick(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  SaveList: Classes.TStringList;
  sFilterMsg: string;
  sNewMsg: string;
  sFileName: string;
begin
  ButtonMsgFilterSave.Enabled := False;
  sFileName := '.\MsgFilterList.txt';
  SaveList := Classes.TStringList.Create;
  SaveList.Add(';引擎插件消息过滤配置文件');
  SaveList.Add(';过滤消息'#9'替换消息');
  ListViewMsgFilter.Items.BeginUpdate;
  try
    for I := 0 to ListViewMsgFilter.Items.Count - 1 do begin
      ListItem := ListViewMsgFilter.Items.Item[I];
      sFilterMsg := ListItem.Caption;
      sNewMsg := ListItem.SubItems.Strings[0];
      SaveList.Add(sFilterMsg + #9 + sNewMsg);
    end;
  finally
    ListViewMsgFilter.Items.EndUpdate;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Application.MessageBox('保存完成！！！', '提示信息', MB_ICONQUESTION);
  ButtonMsgFilterSave.Enabled := True;
end;

function TFrmFunctionConfig.InFilterMsgList(sFilterMsg: string): Boolean;
var
  I: Integer;
  ListItem: TListItem;
begin
  Result := False;
  try
    for I := 0 to ListViewMsgFilter.Items.Count - 1 do begin
      ListItem := ListViewMsgFilter.Items.Item[I];
      if CompareText(sFilterMsg, ListItem.Caption) = 0 then begin
        Result:=TRUE;
        Break;
      end;
    end;
  finally
    ListViewMsgFilter.Items.EndUpdate;
  end;
end;

procedure TFrmFunctionConfig.ButtonMsgFilterAddClick(Sender: TObject);
var
  sFilterMsg: string;
  sNewMsg: string;
  ListItem: TListItem;
begin
  sFilterMsg := Trim(EditFilterMsg.Text);
  sNewMsg := Trim(EditNewMsg.Text);
  if sFilterMsg = '' then begin
    Application.MessageBox('请输入过滤消息！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if InFilterMsgList(sFilterMsg) then begin
    Application.MessageBox('你输入的过滤消息已经存在！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  ListViewMsgFilter.Items.BeginUpdate;
  try
    ListItem := ListViewMsgFilter.Items.Add;
    ListItem.Caption := sFilterMsg;
    ListItem.SubItems.Add(sNewMsg);
  finally
    ListViewMsgFilter.Items.EndUpdate;
  end;
end;

procedure TFrmFunctionConfig.ButtonMsgFilterChgClick(Sender: TObject);
var
  sFilterMsg: string;
  sNewMsg: string;
  ListItem: TListItem;
begin
  sFilterMsg := Trim(EditFilterMsg.Text);
  sNewMsg := Trim(EditNewMsg.Text);
  if sFilterMsg = '' then begin
    Application.MessageBox('请输入过滤消息！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if InFilterMsgList(sFilterMsg) then begin
    Application.MessageBox('你输入的过滤消息已经存在！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  ListViewMsgFilter.Items.BeginUpdate;
  try
    ListItem := ListViewMsgFilter.Items.Item[ListViewMsgFilter.ItemIndex];
    ListItem.Caption := sFilterMsg;
    ListItem.SubItems.Strings[0] := sNewMsg;
  finally
    ListViewMsgFilter.Items.EndUpdate;
  end;
end;

procedure TFrmFunctionConfig.ButtonMsgFilterDelClick(Sender: TObject);
begin
  try
    ListViewMsgFilter.DeleteSelected;
  except
  end;
end;

end.

