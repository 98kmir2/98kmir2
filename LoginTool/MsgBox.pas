unit MsgBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  RzBmpBtn, StdCtrls, RzLabel, jpeg;

type
  TFrmMessageBox = class(TForm)
    ImageMain: TImage;
    LabelHintMsg: TRzLabel;
    btnOK: TRzBmpButton;
    btnCancel: TRzBmpButton;
    RzURLLabel1: TRzURLLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    function Open(sHintMsg: string): Boolean;
    { Public declarations }
  end;

var
  FrmMessageBox: TFrmMessageBox;
  RetResult: Boolean;

implementation

{$R *.dfm}

function TFrmMessageBox.Open(sHintMsg: string): Boolean;
begin
  LabelHintMsg.Caption := sHintMsg;
  MessageBeep(320);
  ShowModal;
  Result := RetResult;
end;

procedure TFrmMessageBox.btnOKClick(Sender: TObject);
begin
  RetResult := True;
end;

procedure TFrmMessageBox.btnCancelClick(Sender: TObject);
begin
  RetResult := False;
end;

end.
