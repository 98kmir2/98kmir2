unit EditUserInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, {$IFDEF SQLDB}IDSQL, {$ELSE}IDDB, {$ENDIF}Grobal2;
type
  TFrmUserInfoEdit = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label8: TLabel;
    EdId: TEdit;
    EdPasswd: TEdit;
    EdUserName: TEdit;
    EdBirthDay: TEdit;
    EdPhone: TEdit;
    Button1: TButton;
    Button2: TButton;
    CkFullEdit: TCheckBox;
    EdSSNo: TEdit;
    EdQuiz: TEdit;
    EdAnswer: TEdit;
    EdQuiz2: TEdit;
    EdAnswer2: TEdit;
    EdMobilePhone: TEdit;
    EdMemo1: TEdit;
    EdMemo2: TEdit;
    EdEMail: TEdit;
    procedure CkFullEditClick(Sender: TObject);

  private
    { Private declarations }
  public
    function sub_466B10(boNew: Boolean; var DBRecord: TAccountDBRecord): Boolean;
    function sub_466AEC(var DBRecord: TAccountDBRecord): Boolean;
    { Public declarations }
  end;

var
  FrmUserInfoEdit: TFrmUserInfoEdit;

implementation

{$R *.DFM}
//00467148

procedure TFrmUserInfoEdit.CkFullEditClick(Sender: TObject);
var
  bo05: Boolean;
begin
  bo05 := CkFullEdit.Checked;
  EdUserName.Enabled := bo05;
  EdSSNo.Enabled := bo05;
  EdBirthDay.Enabled := bo05;
  EdQuiz.Enabled := bo05;
  EdAnswer.Enabled := bo05;
  EdQuiz2.Enabled := bo05;
  EdAnswer2.Enabled := bo05;
  EdPhone.Enabled := bo05;
  EdMobilePhone.Enabled := bo05;
  EdMemo1.Enabled := bo05;
  EdMemo2.Enabled := bo05;
  EdEMail.Enabled := bo05;

end;
//00466B10

function TFrmUserInfoEdit.sub_466B10(boNew: Boolean; var DBRecord: TAccountDBRecord): Boolean;
begin
  Result := False;
  if not boNew then
  begin
    CkFullEdit.Enabled := true;
    CkFullEdit.Checked := False;
    CkFullEditClick(Self);
    EdId.Enabled := False;
  end
  else
  begin
    CkFullEdit.Enabled := False;
    CkFullEdit.Checked := true;
    CkFullEditClick(Self);
    EdId.Enabled := true;
  end;
  EdId.Text := DBRecord.UserEntry.sAccount;
  EdPasswd.Text := DBRecord.UserEntry.sPassword;
  EdUserName.Text := DBRecord.UserEntry.sUserName;
  EdSSNo.Text := DBRecord.UserEntry.sSSNo;
  EdBirthDay.Text := DBRecord.UserEntryAdd.sBirthDay;
  EdQuiz.Text := DBRecord.UserEntry.sQuiz;
  EdAnswer.Text := DBRecord.UserEntry.sAnswer;
  EdQuiz2.Text := DBRecord.UserEntryAdd.sQuiz2;
  EdAnswer2.Text := DBRecord.UserEntryAdd.sAnswer2;
  EdPhone.Text := DBRecord.UserEntry.sPhone;
  EdMobilePhone.Text := DBRecord.UserEntryAdd.sMobilePhone;
  EdMemo1.Text := DBRecord.UserEntryAdd.sMemo;
  EdMemo2.Text := DBRecord.UserEntryAdd.sMemo2;
  EdEMail.Text := DBRecord.UserEntry.sEMail;
  if Self.ShowModal <> mrOK then
    exit;
  if boNew then
  begin
    DBRecord.UserEntry.sAccount := Trim(EdId.Text);
  end;
  DBRecord.UserEntry.sPassword := Trim(EdPasswd.Text);
  DBRecord.UserEntry.sUserName := Trim(EdUserName.Text);
  DBRecord.UserEntry.sSSNo := Trim(EdSSNo.Text);
  DBRecord.UserEntryAdd.sBirthDay := Trim(EdBirthDay.Text);
  DBRecord.UserEntry.sQuiz := Trim(EdQuiz.Text);
  DBRecord.UserEntry.sAnswer := Trim(EdAnswer.Text);
  DBRecord.UserEntryAdd.sQuiz2 := Trim(EdQuiz2.Text);
  DBRecord.UserEntryAdd.sAnswer2 := Trim(EdAnswer2.Text);
  DBRecord.UserEntry.sPhone := Trim(EdPhone.Text);
  DBRecord.UserEntryAdd.sMobilePhone := Trim(EdMobilePhone.Text);
  DBRecord.UserEntryAdd.sMemo := Trim(EdMemo1.Text);
  DBRecord.UserEntryAdd.sMemo2 := Trim(EdMemo2.Text);
  DBRecord.UserEntry.sEMail := Trim(EdEMail.Text);
  Result := true;
end;

function TFrmUserInfoEdit.sub_466AEC(var DBRecord: TAccountDBRecord): Boolean;
begin
  Result := sub_466B10(False, DBRecord);
end;

end.
