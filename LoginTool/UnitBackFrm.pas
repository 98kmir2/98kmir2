unit UnitBackFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TBackForm = class(TForm)
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  BackForm: TBackForm;

implementation

{$R *.dfm}


procedure TBackForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  //Params.WndParent := 0;
  Params.WndParent := Application.Handle;
end;

procedure TBackForm.FormCreate(Sender: TObject);
begin
  Color := clWhite;
  TransparentColor := True;
  TransparentColorValue := clWhite;
  BorderStyle := bsNone;
end;

end.
