unit ChangeDir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzBmpBtn, StdCtrls, RzLabel, ExtCtrls;

type
  TFrmChDir = class(TForm)
    ImageMain: TImage;
    RzLabel3: TRzLabel;
    RzLabel10: TRzLabel;
    btnOK: TRzBmpButton;
    EditAccount: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmChDir: TFrmChDir;

implementation

{$R *.dfm}

end.
