unit GeneralConfig;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, LSShare, LMain,
  Controls, Forms, Dialogs, StdCtrls, Spin, ComCtrls;
type
  TfrmGeneralConfig = class(TForm)
    ButtonOK: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBoxNet: TGroupBox;
    LabelGateIPaddr: TLabel;
    LabelGatePort: TLabel;
    EditGateIPaddr: TEdit;
    EditGatePort: TEdit;
    TabSheet2: TTabSheet;
    GroupBoxInfo: TGroupBox;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    LabelServerIPaddr: TLabel;
    EditServerIPaddr: TEdit;
    EditServerPort: TEdit;
    LabelServerPort: TLabel;
    ButtonNetDefault: TButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditMonAddr: TEdit;
    EditMonPort: TEdit;
    GroupBox3: TGroupBox;
    CheckBoxDynamicIPMode: TCheckBox;
    CheckBoxTestServer: TCheckBox;
    CheckBoxEnableMakingID: TCheckBox;
    CheckBoxEnableGetbackPassword: TCheckBox;
    GroupBox4: TGroupBox;
    CheckBoxEditAutoClear: TCheckBox;
    EditAutoClearTime: TSpinEdit;
    Label12: TLabel;
    Label3: TLabel;
    ButtonGeneralDefault: TButton;
    EditIdDir: TEdit;
    Label4: TLabel;
    EditWebLogDir: TEdit;
    Label5: TLabel;
    EditCountLogDir: TEdit;
    Label8: TLabel;
    EditChrLogDir: TEdit;
    Label9: TLabel;
    CheckBoxAllowChangePassword: TCheckBox;
    Button1: TButton;
    TabSheet4: TTabSheet;
    GroupBox5: TGroupBox;
    SpinEditGetBackPassWordTick: TSpinEdit;
    SpinEditUpdateAccountTick: TSpinEdit;
    SpinEditChangePasswordTick: TSpinEdit;
    SpinEditAddNewUserTick: TSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    SpinEditnLockIdTick: TSpinEdit;
    TabSheet5: TTabSheet;
    Edit1: TEdit;
    Label15: TLabel;
    Label14: TLabel;
    SpinEditPwd: TSpinEdit;
    Label16: TLabel;
    ListBoxFilterText: TListBox;
    ButtonAdd: TButton;
    ButtonDel: TButton;
    Label17: TLabel;
    SpinEditCLPort: TSpinEdit;
    CheckBox1: TCheckBox;
    TabSheet6: TTabSheet;
    cbCloseSelGate: TCheckBox;
    seCloseSelGateTime: TSpinEdit;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonNetDefaultClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxFilterTextClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure cbCloseSelGateClick(Sender: TObject);
    procedure seCloseSelGateTimeChange(Sender: TObject);
  private
    { Private declarations }
  public
    function Open(): Boolean;
    procedure ShowConfig(Config: pTConfig);
    { Public declarations }
  end;

procedure SaveConfig(Config: pTConfig);

var
  frmGeneralConfig: TfrmGeneralConfig;

implementation

{$R *.DFM}

function TfrmGeneralConfig.Open(): Boolean;
var
  Config: pTConfig;
begin
  Config := @g_Config;
  LoadConfig(Config);
  ShowConfig(Config);
  Result := False;
  if Self.ShowModal = mrOK then
    Result := true;
end;

procedure TfrmGeneralConfig.seCloseSelGateTimeChange(Sender: TObject);
begin
  g_nCloseLoginGateTime := seCloseSelGateTime.Value;
  ButtonOK.Enabled := True;
end;

procedure TfrmGeneralConfig.ButtonOKClick(Sender: TObject);
var
  i: Integer;
  Config: pTConfig;
  sIdDir, sWebLogDir, sCountLogDir, sChrLogDir: string;
begin
  Config := @g_Config;
  sIdDir := Trim(EditIdDir.Text);
  sWebLogDir := Trim(EditWebLogDir.Text);
  sCountLogDir := Trim(EditCountLogDir.Text);
  sChrLogDir := Trim(EditChrLogDir.Text);
  if not DirectoryExists(sIdDir) or (sIdDir[Length(sIdDir)] <> '\') then
  begin
    Application.MessageBox('IdDir目录设置错误！', '错误信息', MB_OK + MB_ICONERROR);
    EditIdDir.SetFocus;
    Exit;
  end;
  if not DirectoryExists(sWebLogDir) or (sWebLogDir[Length(sWebLogDir)] <> '\') then
  begin
    Application.MessageBox('WebLogDir目录设置错误！', '错误信息', MB_OK + MB_ICONERROR);
    EditWebLogDir.SetFocus;
    Exit;
  end;
  if not DirectoryExists(sCountLogDir) or (sCountLogDir[Length(sCountLogDir)] <> '\') then
  begin
    Application.MessageBox('CountLogDir目录设置错误！', '错误信息', MB_OK + MB_ICONERROR);
    EditCountLogDir.SetFocus;
    Exit;
  end;
  if not DirectoryExists(sChrLogDir) or (sChrLogDir[Length(sChrLogDir)] <> '\') then
  begin
    Application.MessageBox('ChrLogDir目录设置错误！', '错误信息', MB_OK + MB_ICONERROR);
    EditChrLogDir.SetFocus;
    Exit;
  end;
  Config.sIdDir := sIdDir;
  Config.sWebLogDir := sWebLogDir;
  Config.sCountLogDir := sCountLogDir;
  Config.sChrLogDir := sChrLogDir;

  Config.boTestServer := CheckBoxTestServer.Checked;
  Config.boEnableMakingID := CheckBoxEnableMakingID.Checked;
  Config.boGetbackPassword := CheckBoxEnableGetbackPassword.Checked;
  Config.boAutoClear := CheckBoxEditAutoClear.Checked;
  Config.boDynamicIPMode := CheckBoxDynamicIPMode.Checked;
  Config.dwAutoClearTime := EditAutoClearTime.Value;
  Config.sGateAddr := EditGateIPaddr.Text;
  Config.nGatePort := StrToInt(EditGatePort.Text);
  Config.sServerAddr := EditServerIPaddr.Text;
  Config.nServerPort := StrToInt(EditServerPort.Text);
  Config.sMonAddr := EditMonAddr.Text;
  Config.nMonPort := StrToInt(EditMonPort.Text);
  Config.boAllowChangePassword := CheckBoxAllowChangePassword.Checked;
  Config.dwAddNewUserTick := SpinEditAddNewUserTick.Value;
  Config.dwChgPassWordTick := SpinEditChangePasswordTick.Value;
  Config.dwUpdateUserInfoTick := SpinEditUpdateAccountTick.Value;
  Config.GetBackPasswordTick := SpinEditGetBackPassWordTick.Value;
  Config.nLockIdTick := SpinEditnLockIdTick.Value * 1000;

  Config.CLPort := SpinEditCLPort.Value;
  Config.CLPwd := SpinEditPwd.Value;
  Config.CLOpen := CheckBox1.Checked;

  if Config.CLOpen <> frmMain.ServerSocket.Active then
  begin
    if Config.CLOpen then
    begin
      frmMain.ServerSocket.Address := '0.0.0.0';
      frmMain.ServerSocket.Port := Config.CLPort;
      frmMain.ServerSocket.Active := true;
    end
    else
      frmMain.ServerSocket.Active := False;
  end;

  SaveConfig(Config);

  FilterIPList.Clear;
  for i := 0 to ListBoxFilterText.Items.Count - 1 do
    FilterIPList.Add(ListBoxFilterText.Items.Strings[i]);
  FilterIPList.SaveToFile('.\AllowConnectIPList.txt');
end;

procedure TfrmGeneralConfig.cbCloseSelGateClick(Sender: TObject);
begin
  g_boCloseLoginGate := cbCloseSelGate.Checked;
  ButtonOK.Enabled := True;
end;

procedure TfrmGeneralConfig.ShowConfig(Config: pTConfig);
var
  i: Integer;
begin
  CheckBoxTestServer.Checked := Config.boTestServer;
  CheckBoxEnableMakingID.Checked := Config.boEnableMakingID;
  CheckBoxEnableGetbackPassword.Checked := Config.boGetbackPassword;
  CheckBoxEditAutoClear.Checked := Config.boAutoClear;
  CheckBoxAllowChangePassword.Checked := Config.boAllowChangePassword;
  CheckBoxDynamicIPMode.Checked := Config.boDynamicIPMode;
  EditAutoClearTime.Value := Config.dwAutoClearTime;
  EditGateIPaddr.Text := Config.sGateAddr;
  EditGatePort.Text := IntToStr(Config.nGatePort);
  EditServerIPaddr.Text := Config.sServerAddr;
  EditServerPort.Text := IntToStr(Config.nServerPort);
  EditMonAddr.Text := Config.sMonAddr;
  EditMonPort.Text := IntToStr(Config.nMonPort);
  SpinEditAddNewUserTick.Value := Config.dwAddNewUserTick;
  SpinEditChangePasswordTick.Value := Config.dwChgPassWordTick;
  SpinEditUpdateAccountTick.Value := Config.dwUpdateUserInfoTick;
  SpinEditGetBackPassWordTick.Value := Config.GetBackPasswordTick;
  SpinEditnLockIdTick.Value := Config.nLockIdTick div 1000;

  CheckBox1.Checked := Config.CLOpen;
  SpinEditCLPort.Value := Config.CLPort;
  SpinEditPwd.Value := Config.CLPwd;
  for i := 0 to FilterIPList.Count - 1 do
    ListBoxFilterText.Items.Add(FilterIPList[i]);
end;

procedure TfrmGeneralConfig.ButtonAddClick(Sender: TObject);
var
  sInputText: string;
begin
  if not InputQuery('增加过滤文字', '请输入新的文字:', sInputText) then
    Exit;
  if sInputText = '' then
  begin
    Application.MessageBox('输入的字符不能为空！', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  ListBoxFilterText.Items.Add(sInputText);
end;

procedure TfrmGeneralConfig.ButtonDelClick(Sender: TObject);
var
  nSelectIndex: Integer;
begin
  nSelectIndex := ListBoxFilterText.ItemIndex;
  if (nSelectIndex >= 0) and (nSelectIndex < ListBoxFilterText.Items.Count) then
  begin
    ListBoxFilterText.Items.Delete(nSelectIndex);
  end;
  if nSelectIndex >= ListBoxFilterText.Items.Count then
    ListBoxFilterText.ItemIndex := nSelectIndex - 1
  else
    ListBoxFilterText.ItemIndex := nSelectIndex;
  if ListBoxFilterText.ItemIndex < 0 then
  begin
    ButtonDel.Enabled := False;
  end;
end;

procedure TfrmGeneralConfig.ButtonNetDefaultClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置?', '确认信息', MB_ICONINFORMATION + MB_YESNO) = IDNO then
    Exit;
  CheckBoxTestServer.Checked := true;
  CheckBoxEnableMakingID.Checked := true;
  CheckBoxEnableGetbackPassword.Checked := true;
  CheckBoxEditAutoClear.Checked := False;
end;

procedure SaveConfig(Config: pTConfig);

  procedure SaveConfigString(sSection, sIdent, sDefault: string);
  begin
    Config.IniConf.WriteString(sSection, sIdent, sDefault);
  end;

  procedure SaveConfigInteger(sSection, sIdent: string; nDefault: Integer);
  begin
    Config.IniConf.WriteInteger(sSection, sIdent, nDefault);
  end;

  procedure SaveConfigBoolean(sSection, sIdent: string; boDefault: Boolean);
  begin
    Config.IniConf.WriteBool(sSection, sIdent, boDefault);
  end;
resourcestring
  sSectionServer = 'Server';
  sSectionDB = 'DB';
  sIdentDBServer = 'DBServer';
  sIdentFeeServer = 'FeeServer';
  sIdentLogServer = 'LogServer';
  sIdentGateAddr = 'GateAddr';
  sIdentGatePort = 'GatePort';
  sIdentServerAddr = 'ServerAddr';
  sIdentServerPort = 'ServerPort';
  sIdentMonAddr = 'MonAddr';
  sIdentMonPort = 'MonPort';
  sIdentDBSPort = 'DBSPort';
  sIdentFeePort = 'FeePort';
  sIdentLogPort = 'LogPort';
  sIdentReadyServers = 'ReadyServers';
  sIdentTestServer = 'TestServer';
  sIdentDynamicIPMode = 'DynamicIPMode';
  sEnableMakingID = 'EnableMakingID';
  sEnableGetbackPassword = 'EnableGetbackPassword';
  sAutoClear = 'AutoClear';
  sAutoClearTime = 'AutoClearTime';
  sChrLogDir = 'IdLogDir';
  sIdentIdDir = 'IdDir';
  sIdentWebLogDir = 'WebLogDir';
  sIdentCountLogDir = 'CountLogDir';
  sIdentFeedIDList = 'FeedIDList';
  sIdentFeedIPList = 'FeedIPList';
  sAllowChangePassword = 'AllowChangePassword';
begin
  SaveConfigBoolean(sSectionServer, 'CloseLoginGate', g_boCloseLoginGate);
  SaveConfigInteger(sSectionServer, 'CloseLoginGateTime', g_nCloseLoginGateTime);

  SaveConfigInteger(sSectionServer, 'CLPort', Config.CLPort);
  SaveConfigInteger(sSectionServer, 'CLPwd', Config.CLPwd);
  SaveConfigBoolean(sSectionServer, 'CLOpen', Config.CLOpen);

  SaveConfigString(sSectionServer, sIdentDBServer, Config.sDBServer);
  SaveConfigString(sSectionServer, sIdentFeeServer, Config.sFeeServer);
  SaveConfigString(sSectionServer, sIdentLogServer, Config.sLogServer);

  SaveConfigString(sSectionServer, sIdentGateAddr, Config.sGateAddr);
  SaveConfigInteger(sSectionServer, sIdentGatePort, Config.nGatePort);
  SaveConfigString(sSectionServer, sIdentServerAddr, Config.sServerAddr);
  SaveConfigInteger(sSectionServer, sIdentServerPort, Config.nServerPort);
  SaveConfigString(sSectionServer, sIdentMonAddr, Config.sMonAddr);
  SaveConfigInteger(sSectionServer, sIdentMonPort, Config.nMonPort);

  SaveConfigInteger(sSectionServer, sIdentDBSPort, Config.nDBSPort);
  SaveConfigInteger(sSectionServer, sIdentFeePort, Config.nFeePort);
  SaveConfigInteger(sSectionServer, sIdentLogPort, Config.nLogPort);

  SaveConfigInteger(sSectionServer, 'AddNewUserTick', Config.dwAddNewUserTick);
  SaveConfigInteger(sSectionServer, 'ChgPassWordTick', Config.dwChgPassWordTick);
  SaveConfigInteger(sSectionServer, 'UpdateUserInfoTick', Config.dwUpdateUserInfoTick);
  SaveConfigInteger(sSectionServer, 'BackPasswordTick', Config.GetBackPasswordTick);
  SaveConfigInteger(sSectionServer, 'UnLockIdTick', Config.nLockIdTick);

  SaveConfigInteger(sSectionServer, sIdentReadyServers, Config.nReadyServers);
  SaveConfigBoolean(sSectionServer, sEnableMakingID, Config.boEnableMakingID);
  SaveConfigBoolean(sSectionServer, sIdentDynamicIPMode, Config.boDynamicIPMode);
  SaveConfigBoolean(sSectionServer, sIdentTestServer, Config.boTestServer);
  SaveConfigBoolean(sSectionServer, sEnableGetbackPassword, Config.boGetbackPassword);
  SaveConfigBoolean(sSectionServer, sAutoClear, Config.boAutoClear);
  SaveConfigInteger(sSectionServer, sAutoClearTime, Config.dwAutoClearTime);
  SaveConfigBoolean(sSectionServer, sAllowChangePassword, Config.boAllowChangePassword);

  SaveConfigString(sSectionDB, sIdentIdDir, Config.sIdDir);
  SaveConfigString(sSectionDB, sIdentWebLogDir, Config.sWebLogDir);
  SaveConfigString(sSectionDB, sIdentCountLogDir, Config.sCountLogDir);
  SaveConfigString(sSectionDB, sChrLogDir, Config.sChrLogDir);

  SaveConfigString(sSectionDB, sIdentFeedIDList, Config.sFeedIDList);
  SaveConfigString(sSectionDB, sIdentFeedIPList, Config.sFeedIPList);
end;

procedure TfrmGeneralConfig.Button1Click(Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置?', '确认信息', MB_ICONINFORMATION + MB_YESNO) = IDNO then
    Exit;
  EditIdDir.Text := '.\IDDB\';
  EditWebLogDir.Text := '.\GameWFolder\';
  EditCountLogDir.Text := '.\CountLog\';
  EditChrLogDir.Text := '.\ChrLog\';
end;

procedure TfrmGeneralConfig.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmGeneralConfig.ListBoxFilterTextClick(Sender: TObject);
begin
  ButtonDel.Enabled := (ListBoxFilterText.ItemIndex >= 0) and (ListBoxFilterText.ItemIndex < ListBoxFilterText.Items.Count);
end;

end.
