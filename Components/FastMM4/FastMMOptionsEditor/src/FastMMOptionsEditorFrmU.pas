unit FastMMOptionsEditorFrmU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FastMM4OptionsEditorU, StdCtrls, ComCtrls, RzTreeVw, XPMan,
  ExtCtrls, Menus, ActnList, ImgList, ToolWin;

type
  TfrmFastMMOptionsEditor = class(TForm)
    ctvwEditor: TRzCheckTree;
    memDescription: TMemo;
    Splitter1: TSplitter;
    ActionList1: TActionList;
    actOpen: TAction;
    MainMenu1: TMainMenu;
    actOpen1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    actSave: TAction;
    actClose: TAction;
    actFullExpand: TAction;
    actFullCollapse: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ctvwEditorChange(Sender: TObject; Node: TTreeNode);
    procedure actOpenExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actFullExpandExecute(Sender: TObject);
    procedure actFullCollapseExecute(Sender: TObject);
  private
    { Private declarations }
    FEditor: TFastMMOptionsEditor;
    function GetFilter: string;
  public
    { Public declarations }
  end;

var
  frmFastMMOptionsEditor: TfrmFastMMOptionsEditor;

implementation

uses StrUtils;

{$R *.dfm}

const
  APP_TITLE = 'FastMM Options Editor';


procedure TfrmFastMMOptionsEditor.FormCreate(Sender: TObject);
begin
  Application.Title := APP_TITLE;
  Caption := APP_TITLE;
  ctvwEditor.OnChange := nil;
  Font := Screen.MenuFont;
  FEditor := TFastMMOptionsEditor.Create;
end;

procedure TfrmFastMMOptionsEditor.FormDestroy(Sender: TObject);
begin
  FEditor.Free;
end;

procedure TfrmFastMMOptionsEditor.ctvwEditorChange(Sender: TObject; Node: TTreeNode);
var
  I: Integer;
  aBlock: TContentBlock;
  nIdx: Integer;
  S: string;
begin

  aBlock := TContentBlock(Node.Data);

  nIdx := FEditor.Blocks.IndexOf(aBlock) - 1;

  if aBlock.BlockType = btDefine then
  begin
    for I := nIdx downto 0 do
    begin
      if TContentBlock(FEditor.Blocks[nIdx]).BlockType = btDescription then
      begin
        S := TContentBlock(FEditor.Blocks[nIdx]).Content.Text;
        S := StringReplace(S, '{', ' ', []);
        S := ReverseString(S);
        S := StringReplace(S, '}', ' ', []);
        S := ReverseString(S);
        memDescription.Lines.Text := S;
        Break;
      end;
    end;
  end else memDescription.Clear;
end;

procedure TfrmFastMMOptionsEditor.actOpenExecute(Sender: TObject);
var
  I: Integer;
  aBlock: TContentBlock;
  aTreeNode: TTreeNode;
  arrTreeNode: array of TTreeNode;
  nIndent: Integer;
  sText: string;
  sFileName: string;
begin

  if not PromptForFileName(sFileName, GetFilter) then Exit;

  ctvwEditor.Items.Clear;

  FEditor.LoadFormFile(sFileName);

  SetLength(arrTreeNode, 1);
  arrTreeNode[0] := nil;

  ctvwEditor.Items.BeginUpdate;

  try
    for I := 0 to FEditor.Blocks.Count - 1 do
    begin
      aBlock := TContentBlock(FEditor.Blocks[I]);
      case aBlock.BlockType of
        btGroup:
          begin
            arrTreeNode[0] := ctvwEditor.Items.Add(nil, Trim(aBlock.Content.Text));
            ctvwEditor.ItemState[arrTreeNode[0].AbsoluteIndex] := csUnknown;
            arrTreeNode[0].Data := aBlock;
          end;
        btDefine:
          begin
            nIndent := aBlock.Indent + 1;
            if Length(arrTreeNode) < nIndent + 1 then
              SetLength(arrTreeNode, nIndent + 1);

            sText := Format('%s [%d]', [Trim(aBlock.Content.Text), 
              aBlock.LineNumber + 1]);

            sText := StringReplace(sText, '{.', '{', []);

            aTreeNode := ctvwEditor.Items.AddChild(arrTreeNode[nIndent - 1],
                sText);
            arrTreeNode[nIndent] := aTreeNode;
            aTreeNode.Data := aBlock;

            if aBlock.Valid then
              ctvwEditor.ItemState[aTreeNode.AbsoluteIndex] := csChecked;

            if not aBlock.NeedConfig then
              ctvwEditor.ItemState[aTreeNode.AbsoluteIndex] := csUnknown;
          end;
      end;
    end;
    //ctvwEditor.FullExpand;
    if ctvwEditor.Items.Count > 0 then ctvwEditor.Items[0].MakeVisible;
  finally
    ctvwEditor.Items.EndUpdate;
    ctvwEditor.OnChange := ctvwEditorChange;
  end;

end;

procedure TfrmFastMMOptionsEditor.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmFastMMOptionsEditor.actSaveExecute(Sender: TObject);
var
  I: Integer;
  sFileName: string;
  aBlock: TContentBlock;
  aCheckState: TRzCheckState;
begin
  if not PromptForFileName(sFileName, GetFilter, '', '', '', True) then Exit;

  for I := 0 to ctvwEditor.Items.Count - 1 do
  begin
    aCheckState := ctvwEditor.ItemState[I];
    if aCheckState in [csChecked, csUnchecked] then
    begin
      aBlock := TContentBlock(ctvwEditor.Items[I].Data);
      case aCheckState of
        csChecked:
          begin
            FEditor.EnableLine(aBlock.LineNumber, True);
          end;
        csUnchecked:
          begin
            FEditor.EnableLine(aBlock.LineNumber, False);
          end;
      end;
    end;
  end;

  FEditor.SaveToFile(sFileName);

end;

function TfrmFastMMOptionsEditor.GetFilter: string;
const
  FILTER_FILENAME = 'FastMM4Options.inc';
begin
  Result := Format('%s|%s', [FILTER_FILENAME, FILTER_FILENAME]);
end;

procedure TfrmFastMMOptionsEditor.actFullExpandExecute(Sender: TObject);
begin
  with ctvwEditor do
  begin
    Items.BeginUpdate;
    FullExpand;
    Items.EndUpdate;
    if Selected <> nil then Selected.MakeVisible;
  end;
end;

procedure TfrmFastMMOptionsEditor.actFullCollapseExecute(Sender: TObject);
begin
  with ctvwEditor do
  begin
    Items.BeginUpdate;
    FullCollapse;
    Items.EndUpdate;
  end;
end;

end.
