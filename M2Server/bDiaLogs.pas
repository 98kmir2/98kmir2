unit bDiaLogs;

interface

uses Windows, Messages, SysUtils, CommDlg, Printers, Classes, Graphics, Controls, Forms, StdCtrls;

function BLUE_InputQuery(const ACaption, APrompt: string; var Value: string; boPassWord: Boolean = False): Boolean;
function BLUE_InputBox(const ACaption, APrompt, ADefault: string): string;

implementation

uses M2Share;

resourcestring
  SMsgDlgOK = '确定(&O)';
  SMsgDlgCancel = '取消(&C)';
  SFontName = '宋体';
  SCopyRight = '98KM2';

function BLUE_GetAveCharSize(Canvas: TCanvas): TPoint;
var
  i: Integer;
  Buffer: array[0..51] of Char;
begin
  for i := 0 to 25 do
    Buffer[i] := Chr(i + Ord('A'));
  for i := 0 to 25 do
    Buffer[i + 26] := Chr(i + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 60, TSize(Result));
  Result.x := Result.x div 52;
end;

function BLUE_InputQuery(const ACaption, APrompt: string; var Value: string; boPassWord: Boolean = False): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
  try
    Font.Name := SFontName;
    Font.Size := 9;
    Canvas.Font := Font;
    DialogUnits := BLUE_GetAveCharSize(Canvas);
    BorderStyle := bsSingle;
    BorderIcons := [biSystemMenu];
    Caption := ACaption + ' - ' + SCopyRight;
    ClientWidth := MulDiv(180, DialogUnits.x, 4);
    Position := poScreenCenter;

    Prompt := TLabel.Create(Form);
    with Prompt do
    begin
      Parent := Form;
      Caption := APrompt;
      Left := MulDiv(8, DialogUnits.x, 4);
      Top := MulDiv(8, DialogUnits.y, 8);
      Constraints.MaxWidth := MulDiv(164, DialogUnits.x, 4);
      WordWrap := True;
    end;

    Edit := TEdit.Create(Form);
    with Edit do
    begin
      Parent := Form;
      Left := Prompt.Left;
      Top := Prompt.Top + Prompt.Height + 5;
      Width := MulDiv(164, DialogUnits.x, 4);
      MaxLength := 255;
      if boPassWord then
        PasswordChar := '*'
      else
        PasswordChar := #0;
      Text := Value;
      SelectAll;
    end;

    ButtonTop := Edit.Top + Edit.Height + 15;
    ButtonWidth := MulDiv(50, DialogUnits.x, 4);
    ButtonHeight := MulDiv(16, DialogUnits.y, 8);
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := SMsgDlgOK;
      ModalResult := mrOk;
      Default := True;
      SetBounds(MulDiv(38, DialogUnits.x, 4), ButtonTop, ButtonWidth, ButtonHeight);
    end;
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := SMsgDlgCancel;
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(MulDiv(92, DialogUnits.x, 4), ButtonTop, ButtonWidth, ButtonHeight);
      Form.ClientHeight := Top + Height + 13;
    end;
    if ShowModal = mrOk then
    begin
      Value := Edit.Text;
      Result := True;
    end;
  finally
    Form.Free;
  end;
end;

function BLUE_InputBox(const ACaption, APrompt, ADefault: string): string;
begin
  Result := ADefault;
  BLUE_InputQuery(ACaption, APrompt, Result);
end;

end.
