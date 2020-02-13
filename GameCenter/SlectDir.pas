unit SlectDir;

interface

uses
  Classes, Controls, Forms,
  StdCtrls, Buttons, ComCtrls, ShellCtrls;

type
  TFormSlectDir = class(TForm)
    ShellTreeView: TShellTreeView;
    LabelCurPath: TLabel;
    BitBtnSelectDir: TBitBtn;
    BitBtnCancel: TBitBtn;
    procedure BitBtnSelectDirClick(Sender: TObject);
    procedure ShellTreeViewChange(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSlectDir              : TFormSlectDir;

implementation

uses GMain, Share;

{$R *.dfm}

procedure TFormSlectDir.BitBtnSelectDirClick(Sender: TObject);
var
  Dir                       : string;
begin
  Dir := LabelCurPath.Caption + '\';
  case SelectDirID of
    0: frmMain.EditIDDB.Text := Dir;
    1: frmMain.EditFDB.Text := Dir;
    2: frmMain.EditGuild.Text := Dir;
    3: frmMain.EditData.Text := Dir;
    4: frmMain.EditBigBagSize.Text := Dir;
    5: frmMain.EditSabuk.Text := Dir;
    6: frmMain.EditBakDir.Text := Dir;
    7: frmMain.EditOtherSourceDir1.Text := Dir;
    8: frmMain.EditOtherSourceDir2.Text := Dir;
    9: frmMain.EditWinrarFile.Text := Dir;
  end;
  frmMain.ModValue();
end;

procedure TFormSlectDir.ShellTreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  LabelCurPath.Caption := ShellTreeView.path;
end;

end.

