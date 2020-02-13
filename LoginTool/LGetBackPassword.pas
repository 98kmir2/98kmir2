unit LGetBackPassword;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  StdCtrls, jpeg, ExtCtrls, RzBmpBtn, Mask, RzEdit, RzLabel, Graphics;

type
  TfrmGetBackPassword = class(TForm)
    ImageMain: TImage;
    EditAccount: TEdit;
    EditBirthDay: TEdit;
    EditQuiz1: TEdit;
    EditAnswer1: TEdit;
    EditQuiz2: TEdit;
    EditAnswer2: TEdit;
    btnCancel: TRzBmpButton;
    btnOK: TRzBmpButton;
    RzLabel3: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    RzLabel10: TRzLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnColseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmGetBackPassword: TfrmGetBackPassword;

implementation

uses LMain, MsgBox;
var
  dwOKTick: LongWord;
{$R *.dfm}

  { TfrmGetBackPassword }

procedure TfrmGetBackPassword.Open;
begin
  btnOK.Enabled := True;
  EditAccount.Text := '';
  EditQuiz1.Text := '';
  EditAnswer1.Text := '';
  EditQuiz2.Text := '';
  EditAnswer2.Text := '';
  EditBirthDay.Text := '';
  ShowModal;
end;

procedure TfrmGetBackPassword.btnOKClick(Sender: TObject);
var
  sAccount, sQuest1, sAnswer1, sQuest2, sAnswer2, sBirthDay: string;
begin
  if GetTickCount - dwOKTick < 10000 then begin
    FrmMessageBox.Open('请稍候10秒后再点确定！');
    Exit;
  end;
  dwOKTick := GetTickCount();
  sAccount := Trim(EditAccount.Text);
  sQuest1 := Trim(EditQuiz1.Text);
  sAnswer1 := Trim(EditAnswer1.Text);
  sQuest2 := Trim(EditQuiz2.Text);
  sAnswer2 := Trim(EditAnswer2.Text);
  sBirthDay := Trim(EditBirthDay.Text);
  if sAccount = '' then begin
    FrmMessageBox.Open('帐号输入不正确！');
    EditAccount.SetFocus;
    Exit;
  end;
  if (sQuest1 = '') and (sAnswer1 = '') and (sQuest2 = '') and (sAnswer2 = '') then begin
    FrmMessageBox.Open('密码问答输入不正确！');
    Exit;
  end;
  if (sQuest1 = '') and (sAnswer1 = '') and (sQuest2 = '') and (sAnswer2 = '') then begin
    FrmMessageBox.Open('密码问答输入不正确！');
    Exit;
  end;
  if (sBirthDay = '') then begin
    FrmMessageBox.Open('出生日期输入不正确！');
    EditBirthDay.SetFocus;
    Exit;
  end;
  if sQuest1 = '' then sQuest1 := 'test';
  if sAnswer1 = '' then sAnswer1 := 'test';
  if sQuest2 = '' then sQuest2 := 'test';
  if sAnswer2 = '' then sAnswer2 := 'test';
  FrmMain.SendGetBackPassword(sAccount, sQuest1, sAnswer1, sQuest2, sAnswer2, sBirthDay);
  btnOK.Enabled := False;
  Close();
end;

procedure TfrmGetBackPassword.btnColseClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmGetBackPassword.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
