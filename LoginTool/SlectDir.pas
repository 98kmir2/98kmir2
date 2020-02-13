unit SlectDir;

interface

uses
  Classes, Controls, Forms, StdCtrls, ComCtrls, ShellCtrls, RzTreeVw, RzShellCtrls, Buttons;

type
  TFormSlectDir = class(TForm)
    BitBtnSelectDir: TBitBtn;
    BitBtnCancel: TBitBtn;
    LabelCaption: TLabel;
    RzShellTree: TRzShellTree;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure BitBtnSelectDirClick(Sender: TObject);
    procedure RzShellTreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Open({; var Dir: Widestring}): Boolean;
  end;

var
  FormSlectDir: TFormSlectDir;
  boSlectDir: Boolean = False;

implementation

{$R *.dfm}

uses LShare;

function TFormSlectDir.Open({; var Dir: Widestring}): Boolean;
begin
  LabelCaption.Caption := '请选择您的传奇客户端“Legend of mir2”目录：';
  ShowModal;
  Result := boSlectDir;
end;

procedure TFormSlectDir.RzShellTreeChange(Sender: TObject; Node: TTreeNode);
//var
 // S: string;
begin
  //S := RzShellTree.SelectedPathName; //Node.Text //RzShellTree.;
  //g_sWorkDir := S;
end;

procedure TFormSlectDir.BitBtnCancelClick(Sender: TObject);
begin
  boSlectDir := False;
  Close;
end;

procedure TFormSlectDir.BitBtnSelectDirClick(Sender: TObject);
begin
  boSlectDir := True;
  Close;
end;

procedure TFormSlectDir.FormCreate(Sender: TObject);
begin

end;

{procedure TFormSlectDir.ShellTreeViewChange(Sender: TObject;
  Node: TTreeNode);
begin
  g_sWorkDir := ShellTreeView.path;
end;}

end.
