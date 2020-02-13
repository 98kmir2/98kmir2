unit CastleAttackEdit;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, ComCtrls, StdCtrls, Castle;

type
  TFormCastleAttackEdit = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    DateTimePicker: TDateTimePicker;
    ButtonOK: TButton;
    CheckBoxAllGuild: TCheckBox;
    ListBoxGuildList: TListBox;
    ButtonCancel: TButton;
    procedure ButtonOKClick(Sender: TObject);
    procedure CheckBoxAllGuildClick(Sender: TObject);
    procedure ListBoxGuildListClick(Sender: TObject);
    procedure EditNameChange(Sender: TObject);
  private
    { Private declarations }
  public
    function Open(AttackerInfo: pTAttackerInfo; IsEdit: Boolean): Boolean;
  end;

var
  FormCastleAttackEdit: TFormCastleAttackEdit;
  boCanAddAttackerInfo: Boolean;

implementation

uses Guild, M2Share;

{$R *.dfm}

function TFormCastleAttackEdit.Open(AttackerInfo: pTAttackerInfo; IsEdit: Boolean): Boolean;
var
  sGuildName: string;
begin
  Result := False;
  boCanAddAttackerInfo := False;
  if IsEdit then
  begin
    Caption := '±‡º≠π•≥«…Í«Î';
    EditName.Text := AttackerInfo^.sGuildName;
    DateTimePicker.DateTime := AttackerInfo^.AttackDate;
    CheckBoxAllGuild.Enabled := False;
    ListBoxGuildList.Enabled := False;
  end
  else
  begin
    Caption := '‘ˆº”π•≥«…Í«Î';
    DateTimePicker.DateTime := Now();
    CheckBoxAllGuild.Enabled := True;
    ListBoxGuildList.Enabled := True;
  end;
  ShowModal();
  AttackerInfo^.Guild := nil;
  if boCanAddAttackerInfo then
  begin
    if CheckBoxAllGuild.Checked then
    begin
      AttackerInfo^.AttackDate := DateTimePicker.Date;
      Result := True;
    end
    else
    begin
      sGuildName := Trim(EditName.Text);
      AttackerInfo^.sGuildName := sGuildName;
      AttackerInfo^.Guild := g_GuildManager.FindGuild(sGuildName);
      AttackerInfo^.AttackDate := DateTimePicker.Date;
    end;
  end;
end;

procedure TFormCastleAttackEdit.ButtonOKClick(Sender: TObject);
begin
  boCanAddAttackerInfo := True;
  Close();
end;

procedure TFormCastleAttackEdit.CheckBoxAllGuildClick(Sender: TObject);
begin
  EditName.Text := '';
  EditName.Enabled := not CheckBoxAllGuild.Checked;
  ButtonOK.Enabled := True;
end;

procedure TFormCastleAttackEdit.ListBoxGuildListClick(Sender: TObject);
var
  nIndex: Integer;
begin
  nIndex := ListBoxGuildList.ItemIndex;
  if (nIndex < 0) or (nIndex >= ListBoxGuildList.Items.Count) then
    Exit;
  EditName.Text := ListBoxGuildList.Items.Strings[nIndex];
end;

procedure TFormCastleAttackEdit.EditNameChange(Sender: TObject);
begin
  ButtonOK.Enabled := EditName.Text <> '';
end;

end.
