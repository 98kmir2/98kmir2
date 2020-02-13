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
    FrmMessageBox.Open('��¼�ʺŵĳ��ȱ������3λ��');
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
    MemoHelp.Text := '�����ʺ����ƿ��԰������ַ������ֵ���ϣ��ʺ����Ƴ��ȱ���Ϊ4�����ϡ���½�ʺŲ���Ϸ�е��������ƣ�����ϸ���봴���ʺ�������Ϣ�����ĵ�½�ʺſ��Ե�½��Ϸ��������վ����ȡ��һЩ�����Ϣ���������ĵ�½�ʺŲ�Ҫ����Ϸ�еĽ�ɫ����ͬ����ȷ��������벻�ᱻ�����ƽ⡣';
  if Sender = EditPassword then
    MemoHelp.Text := '��������������ַ������ֵ���ϣ������볤�ȱ�������4λ�����������������ݲ�Ҫ���ڼ򵥣��Է����˲µ������ס����������룬�����ʧ���뽫�޷���¼��Ϸ��';
  if Sender = EditConfirm then
    MemoHelp.Text := '�ٴ�����������ȷ�ϡ�';
  if Sender = EditYourName then
    MemoHelp.Text := '����������ȫ����';
  if Sender = EditSSNo then
    MemoHelp.Text := '������������֤�ţ����磺 720101-146720';
  if Sender = EditBirthDay then
    MemoHelp.Text := '�������������ա����磺1977/10/15';
  if Sender = EditQuiz1 then
    MemoHelp.Text := '�������һ��������ʾ���⣬�����ʾ���������붪ʧ���ҡ��������á�';
  if Sender = EditAnswer1 then
    MemoHelp.Text := '��������������Ĵ𰸡�';
  if Sender = EditQuiz2 then
    MemoHelp.Text := '������ڶ���������ʾ���⣬�����ʾ���������붪ʧ���ҡ��������á�';
  if Sender = EditAnswer2 then
    MemoHelp.Text := '��������������Ĵ𰸡�';
  if Sender = EditPhone then
    MemoHelp.Text := '���������ĵ绰���롣';
  if Sender = EditMobPhone then
    MemoHelp.Text := '�����������ֻ����롣';
  if Sender = EditEMail then
    MemoHelp.Text := '�����������ʼ���ַ�������ʼ���������������µ�һЩ��Ϣ��';
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
    FrmMessageBox.Open('���Ժ�ע���ʺ�...');
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
