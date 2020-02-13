unit LNewAccount;

interface

uses
  Windows,dialogs, SysUtils, Classes, Controls, Forms, StdCtrls, Grobal2, RzBmpBtn, jpeg, ExtCtrls, RzForms, RzLabel, Graphics;

type
  TfrmNewAccount = class(TForm)
    LabelStatus: TLabel;
    ImageMain: TImage;
    MemoHelp: TMemo;
    EditAccount: TEdit;
    EditPassword: TEdit;
    EditConfirm: TEdit;
    EditYourName: TEdit;
    EditSSNo: TEdit;
    EditBirthDay: TEdit;
    EditQuiz1: TEdit;
    EditAnswer1: TEdit;
    EditQuiz2: TEdit;
    EditAnswer2: TEdit;
    EditPhone: TEdit;
    EditMobPhone: TEdit;
    EditEMail: TEdit;
    btnOK: TRzBmpButton;
    btnCancel: TRzBmpButton;
    RzFormShape1: TRzFormShape;
    RzLabel3: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    RzLabel7: TRzLabel;
    RzLabel8: TRzLabel;
    RzLabel9: TRzLabel;
    RzLabel10: TRzLabel;
    RzLabel11: TRzLabel;
    RzLabel12: TRzLabel;
    procedure EditEnter(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    function CheckUserEntrys(): Boolean;
    function NewIdCheckBirthDay(): Boolean;
    { Private declarations }

  public
    procedure Open();
    { Public declarations }
  end;

var
  frmNewAccount: TfrmNewAccount;
  NewIdRetryUE: TUserEntry;
  NewIdRetryAdd: TUserEntryAdd;

implementation

uses HUtil32, LMain, MsgBox;

var
  dwOKTick: LongWord;

{$R *.dfm}

function TfrmNewAccount.CheckUserEntrys: Boolean;
begin
  Result := False;
  EditAccount.Text := Trim(EditAccount.Text);
  EditQuiz1.Text := Trim(EditQuiz1.Text);
  EditYourName.Text := Trim(EditYourName.Text);
  if Length(EditAccount.Text) < 3 then begin
    FrmMessageBox.Open('登录帐号的长度必须大于3位！');
    Beep;
    EditAccount.SetFocus;
    Exit;
  end;
  if not NewIdCheckBirthDay then Exit;
  if Length(EditPassword.Text) < 3 then begin
    EditPassword.SetFocus;
    Exit;
  end;
  if EditPassword.Text <> EditConfirm.Text then begin
    EditConfirm.SetFocus;
    Exit;
  end;
  if Length(EditQuiz1.Text) < 1 then begin
    EditQuiz1.SetFocus;
    Exit;
  end;
  if Length(EditAnswer1.Text) < 1 then begin
    EditAnswer1.SetFocus;
    Exit;
  end;
  if Length(EditQuiz2.Text) < 1 then begin
    EditQuiz2.SetFocus;
    Exit;
  end;
  if Length(EditAnswer2.Text) < 1 then begin
    EditAnswer2.SetFocus;
    Exit;
  end;
  if Length(EditYourName.Text) < 1 then begin
    EditYourName.SetFocus;
    Exit;
  end;
  Result := True;
end;

procedure TfrmNewAccount.EditEnter(Sender: TObject);
begin
  if Sender = EditAccount then
    MemoHelp.Text := '您的帐号名称可以包括：字符、数字的组合，帐号名称长度必须为4或以上。登陆帐号并游戏中的人物名称，请仔细输入创建帐号所需信息。您的登陆帐号可以登陆游戏及我们网站，以取得一些相关信息。建议您的登陆帐号不要与游戏中的角色名相同，以确保你的密码不会被爆力破解。';
  if Sender = EditPassword then
    MemoHelp.Text := '您的密码可以是字符及数字的组合，但密码长度必须至少4位。建议您的密码内容不要过于简单，以防被人猜到。请记住您输入的密码，如果丢失密码将无法登录游戏。';
  if Sender = EditConfirm then
    MemoHelp.Text := '再次输入密码以确认。';
  if Sender = EditYourName then
    MemoHelp.Text := '请输入您的全名。';
  if Sender = EditSSNo then
    MemoHelp.Text := '请输入你的身份证号，例如： 720101-146720';
  if Sender = EditBirthDay then
    MemoHelp.Text := '请输入您的生日。例如：1977/10/15';
  if Sender = EditQuiz1 then
    MemoHelp.Text := '请输入第一个密码提示问题，这个提示将用于密码丢失后找。回密码用。';
  if Sender = EditAnswer1 then
    MemoHelp.Text := '请输入上面问题的答案。';
  if Sender = EditQuiz2 then
    MemoHelp.Text := '请输入第二个密码提示问题，这个提示将用于密码丢失后找。回密码用。';
  if Sender = EditAnswer2 then
    MemoHelp.Text := '请输入上面问题的答案。';
  if Sender = EditPhone then
    MemoHelp.Text := '请输入您的电话号码。';
  if Sender = EditMobPhone then
    MemoHelp.Text := '请输入您的手机号码。';
  if Sender = EditEMail then
    MemoHelp.Text := '请输入您的邮件地址。您的邮件将被接收最近更新的一些信息。';
end;

function TfrmNewAccount.NewIdCheckBirthDay: Boolean;
var
  Str, syear, smon, sday: string;
  ayear, amon, aday: Integer;
  flag: Boolean;
begin
  Result := True;
  flag := True;
  Str := EditBirthDay.Text;
  Str := GetValidStr3(Str, syear, ['/']);
  Str := GetValidStr3(Str, smon, ['/']);
  Str := GetValidStr3(Str, sday, ['/']);
  ayear := Str_ToInt(syear, 0);
  amon := Str_ToInt(smon, 0);
  aday := Str_ToInt(sday, 0);
  if (ayear <= 1890) or (ayear > 2101) then flag := False;
  if (amon <= 0) or (amon > 12) then flag := False;
  if (aday <= 0) or (aday > 31) then flag := False;
  if not flag then begin
    Beep;
    EditBirthDay.SetFocus;
    Result := False;
  end;
end;

procedure TfrmNewAccount.Open;
begin
  btnOK.Enabled := True;
  EditAccount.Text := '';
  EditPassword.Text := '';
  EditConfirm.Text := '';
  EditQuiz1.Text := '';
  EditAnswer1.Text := '';
  EditQuiz2.Text := '';
  EditAnswer2.Text := '';
  EditEMail.Text := '';
  EditPhone.Text := '';
  EditMobPhone.Text := '';
  EditBirthDay.Text := '';
  EditYourName.Text := '';
  ShowModal;
end;

procedure TfrmNewAccount.btnOKClick(Sender: TObject);
var
  ue: TUserEntry;
  ua: TUserEntryAdd;
begin
  if GetTickCount - dwOKTick < 5000 then begin
    FrmMessageBox.Open('请稍候注册帐号...');
    Exit;
  end;
  if CheckUserEntrys then begin
    FillChar(ue, SizeOf(TUserEntry), #0);
    FillChar(ua, SizeOf(TUserEntryAdd), #0);
    ue.sAccount := LowerCase(EditAccount.Text);
    ue.sPassword := EditPassword.Text;
    ue.sUserName := EditYourName.Text;
    ue.sSSNo := '650101-1455111';
    ue.sQuiz := EditQuiz1.Text;
    ue.sAnswer := Trim(EditAnswer1.Text);
    ue.sPhone := EditPhone.Text;
    ue.sEMail := Trim(EditEMail.Text);

    ua.sQuiz2 := EditQuiz2.Text;
    ua.sAnswer2 := Trim(EditAnswer2.Text);
    ua.sBirthDay := EditBirthDay.Text;
    ua.sMobilePhone := EditMobPhone.Text;

    NewIdRetryUE := ue;
    NewIdRetryUE.sAccount := '';
    NewIdRetryUE.sPassword := '';
    NewIdRetryAdd := ua;
    OutputDebugString(pchar(FrmMain.ClientSocket.Address + ':'+inttostr(FrmMain.ClientSocket.Port)));
    FrmMain.SendUpdateAccount(ue, ua);
    btnOK.Enabled := False;
    dwOKTick := GetTickCount();
  end;
end;

end.
