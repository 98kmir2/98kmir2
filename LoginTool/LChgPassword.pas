unit LChgPassword;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  StdCtrls, RzButton, jpeg, ExtCtrls, RzBmpBtn, RzLabel, Graphics;

type
  TfrmChangePassword = class(TForm)
    ImageMain: TImage;
    EditAccount: TEdit;
    EditPassword: TEdit;
    EditNewPassword: TEdit;
    EditConfirm: TEdit;
    btnOK: TRzBmpButton;
    btnCancel: TRzBmpButton;
    RzLabel3: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel10: TRzLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmChangePassword: TfrmChangePassword;

implementation

uses LMain, MsgBox;

var
  dwOKTick: LongWord;

{$R *.dfm}

  { TfrmChangePassword }

procedure TfrmChangePassword.Open;
begin
  btnOK.Enabled := True;
  EditAccount.Text := '';
  EditPassword.Text := '';
  EditNewPassword.Text := '';
  EditConfirm.Text := '';
  ShowModal;
end;

procedure TfrmChangePassword.btnOKClick(Sender: TObject);
var
  uid, passwd, newpasswd: string;
begin
  if GetTickCount - dwOKTick < 5000 then begin
    FrmMessageBox.Open('���Ժ��ٵ�ȷ����');
    Exit;
  end;
  uid := Trim(EditAccount.Text);
  passwd := Trim(EditPassword.Text);
  newpasswd := Trim(EditNewPassword.Text);
  if uid = '' then begin
    FrmMessageBox.Open('��¼�ʺ����벻��ȷ��');
    EditAccount.SetFocus;
    Exit;
  end;
  if passwd = '' then begin
    FrmMessageBox.Open('���������벻��ȷ��');
    EditPassword.SetFocus;
    Exit;
  end;
  if newpasswd = '' then begin
    FrmMessageBox.Open('���������벻��ȷ��');
    EditNewPassword.SetFocus;
    Exit;
  end;
  if EditNewPassword.Text = EditConfirm.Text then begin
    FrmMain.SendChgPw(uid, passwd, newpasswd);
    dwOKTick := GetTickCount();
    btnOK.Enabled := False;
  end else begin
    FrmMessageBox.Open('������������벻ƥ�䣡');
    EditNewPassword.SetFocus;
  end;
end;

procedure TfrmChangePassword.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
