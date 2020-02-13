unit CreateChr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Buttons;
type
  TFrmCreateChr = class(TForm)
    EdUserId: TEdit;
    EdChrName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    Label3: TLabel;
    EditSelectID: TEdit;
    procedure FormShow(Sender: TObject);
  private
    function GetInputInfo(): Boolean;
    { Private declarations }
  public
    sUserId: string;
    sChrName: string;
    nSelectID: Integer;
    function IncputChrInfo(): Boolean;
    { Public declarations }
  end;

var
  FrmCreateChr: TFrmCreateChr;

implementation

uses HUtil32;

{$R *.DFM}

procedure TFrmCreateChr.FormShow(Sender: TObject);
begin
  EdUserId.SetFocus;
end;

function TFrmCreateChr.IncputChrInfo: Boolean; //0x0049C65C
begin
  sUserId := '';
  sChrName := '';
  Result := GetInputInfo;
end;

function TFrmCreateChr.GetInputInfo(): Boolean;
begin
  Result := False;
  EdUserId.Text := sUserId;
  EdChrName.Text := sChrName;
  if ShowModal = mrOK then
  begin
    sUserId := Trim(EdUserId.Text);
    sChrName := Trim(EdChrName.Text);
    nSelectID := Str_ToInt(Trim(EditSelectID.Text), -1);
    if nSelectID < 0 then
    begin
      MessageBox(Handle, 'ѡ��ID���벻��ȷ��', 'ȷ����Ϣ', MB_OK + MB_ICONEXCLAMATION);
      Exit;
    end;
    Result := True;
  end;
end;
end.
