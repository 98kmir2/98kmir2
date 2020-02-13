unit SetBtnImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Jpeg, RzButton, ExtCtrls, ExtDlgs;

type
  TFrmSetBtnImage = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    RzButton1: TRzButton;
    RzButton2: TRzButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    RzButton3: TRzButton;
    OpenPictureDialog1: TOpenPictureDialog;
    RzButton4: TRzButton;
    RzButton5: TRzButton;
    RzButton6: TRzButton;
    procedure RzButton3Click(Sender: TObject);
    procedure RzButton4Click(Sender: TObject);
    procedure RzButton5Click(Sender: TObject);
    procedure RzButton6Click(Sender: TObject);
  private
    { Private declarations }

    procedure LoadBtnBitmap(Img: TImage);
  public
    { Public declarations }
  end;

var
  FrmSetBtnImage: TFrmSetBtnImage;

implementation

{$R *.dfm}

procedure TFrmSetBtnImage.LoadBtnBitmap(Img: TImage);
begin
  if OpenPictureDialog1.Execute then begin
    Img.Picture.Bitmap.LoadFromFile(OpenPictureDialog1.FileName);
  end;
end;

procedure TFrmSetBtnImage.RzButton3Click(Sender: TObject);
begin
  LoadBtnBitmap(Image1);
end;

procedure TFrmSetBtnImage.RzButton4Click(Sender: TObject);
begin
  LoadBtnBitmap(Image2);
end;

procedure TFrmSetBtnImage.RzButton5Click(Sender: TObject);
begin
  LoadBtnBitmap(Image3);
end;

procedure TFrmSetBtnImage.RzButton6Click(Sender: TObject);
begin
  LoadBtnBitmap(Image4);
end;

end.
