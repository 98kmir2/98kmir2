unit FastMMLogReaderMainFrmU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, FastMMLogParserU, VirtualTreesUtils, 
  ActnList, Menus, ExtCtrls, ComCtrls, XPMan;

type
  TfrmReaderMain = class(TForm)
    ActionList1: TActionList;
    actOpen: TAction;
    MainMenu1: TMainMenu;
    actOpen1: TMenuItem;
    pnlDetail: TPanel;
    vtvStackTrace: TVirtualStringTree;
    pnlList: TPanel;
    vtvLeaks: TVirtualStringTree;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    tbsCallStack: TTabSheet;
    TabSheet4: TTabSheet;
    pnlMemoryDump: TPanel;
    Splitter3: TSplitter;
    memMemoryDumpHex: TMemo;
    memMemoryDumpText: TMemo;
    pnlCategory: TPanel;
    Splitter2: TSplitter;
    vtvReports: TVirtualStringTree;
    tbsSummary: TTabSheet;
    Panel1: TPanel;
    pnlSummary: TPanel;
    lsvPosition: TListView;
    Splitter4: TSplitter;
    lsvLeakCount: TListView;
    procedure FormCreate(Sender: TObject);
    procedure vtvLeaksMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure vtvLeaksGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vtvLeaksBeforeItemPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var CustomDraw: Boolean);
    procedure actOpenExecute(Sender: TObject);
    procedure vtvStackTraceGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vtvLeaksFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure FormShow(Sender: TObject);
    procedure vtvReportsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vtvReportsFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure vtvLeaksBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure PageControl1Change(Sender: TObject);
    procedure lsvPositionSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure vtvStackTraceFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure lsvLeakCountSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FLoggerReader: TFastMMLogParser;
    procedure RefreshDetail;
    procedure ShowSummary(aSummary: TSummary);
    procedure ClearViews;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;


  end;

var
  frmReaderMain: TfrmReaderMain;

implementation

uses StrUtils;



{$R *.dfm}


procedure TfrmReaderMain.AfterConstruction;
begin
  inherited;
  FLoggerReader := TFastMMLogParser.Create;
end;

destructor TfrmReaderMain.Destroy;
begin
  FLoggerReader.Free;
  inherited;
end;

procedure TfrmReaderMain.FormCreate(Sender: TObject);
begin
  vtvReports.NodeDataSize := SizeOf(TObject);
  vtvLeaks.NodeDataSize := SizeOf(TObject);
  vtvStackTrace.NodeDataSize := SizeOf(TObject);
  Font := Screen.MenuFont;
end;

procedure TfrmReaderMain.vtvLeaksMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  vtvLeaks.MultiLine[Node] := False;
  //NodeHeight := vtvLeaks.ComputeNodeHeight(TargetCanvas, Node, 0);
  //vtvLeaks.InvalidateNode(Node);
end;

procedure TfrmReaderMain.vtvLeaksGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  aObj: TAbstractContent;
  aLeak: TLeak;
  //sPrefix: string;
begin

  aObj := TAbstractContent(GetVirtualTreeNodeObj(Node));

  if aObj <> nil then
  begin
      //if (aObj is TReport) and (Column = 4) then CellText := aObj.DisplayText;

    if aObj is TLeak then aLeak := TLeak(aObj)
    else aLeak := nil;

    if aLeak <> nil then
    begin
      case Column of
        0:
          begin
            CellText := aLeak.DisplayText;
          end;
        1:
          begin
            CellText := IntToStr(aLeak.AllocationNumber);
          end;
        2:
          begin
            CellText := aLeak.ObjType;
          end;
        3:
          begin
            CellText := IntToStr(aLeak.Size);
          end;
        4:
          begin
            CellText := aLeak.MemoryDumpAddress;
          end;
      end;
    end;

  end;

end;

procedure TfrmReaderMain.vtvLeaksBeforeItemPaint(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect; var CustomDraw: Boolean);
begin
  //TargetCanvas.Rectangle(ItemRect);
  //CustomDraw := True;
end;

procedure TfrmReaderMain.actOpenExecute(Sender: TObject);
var
  I{, J}: Integer;
  aReportNode{, aLeakNode}: PVirtualNode;
  sFileName: string;
begin

  if PromptForFileName(sFileName, 'FastMM Log нд╪Ч|*.txt') then
  begin
    //FLoggerReader.LoadFromFile('Small.txt');
    //FLoggerReader.LoadFromFile('Large.txt');
    
    //StartCount;
    FLoggerReader.LoadFromFile(sFileName);
    //ShowTimeCount;
    ClearViews;
    //ShowMessage('s');
    vtvLeaks.BeginUpdate;

    try
      for I := 0 to FLoggerReader.Reports.Count - 1 do
      begin
        aReportNode := vtvReports.AddChild(nil, FLoggerReader.Reports[I]);
//
//        with TReport(FLoggerReader.Reports[I]) do
//        begin
//          for J := 0 to Leaks.Count - 1 do
//          begin
//            aLeakNode := vtvLeaks.AddChild(aReportNode, Leaks[J]);
//          end;
//        end;

      end;
    finally
      vtvLeaks.EndUpdate;
    end;
  end;


end;

procedure TfrmReaderMain.vtvStackTraceGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  aObj: TObject;
  aStackTrace: TStackTrace;
begin

  aObj := GetVirtualTreeNodeObj(Node);

  if aObj is TStackTrace then
  begin
    aStackTrace := TStackTrace(aObj);

    case Column of
      0: CellText := aStackTrace.Address;
      1: CellText := aStackTrace.UnitName;
      2: CellText := aStackTrace.LeakInClass;
      3: CellText := aStackTrace.LeakInMethod;
      4: if aStackTrace.LineNumber > 0 then
           CellText := IntToStr(aStackTrace.LineNumber)
         else CellText := '';
    end;

    //CellText := aStackTrace.DisplayText;

  end else CellText := aObj.ClassName;
end;

procedure TfrmReaderMain.vtvLeaksFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  I: Integer;
  aObj: TAbstractContent;
  aLeak: TLeak;
begin
  vtvStackTrace.Clear;

  if Node = nil then Exit;

  aObj := TAbstractContent(GetVirtualTreeNodeObj(Node));

  if aObj is TLeak then
  begin
    aLeak := TLeak(aObj);
    if aLeak <> nil then
    begin
      for I := 0 to aLeak.StackTraces.Count - 1 do
      begin
        vtvStackTrace.AddChild(nil, TStackTrace(aLeak.StackTraces[I]));
      end;
      memMemoryDumpHex.Text := aLeak.MemoryDumpHex;
      memMemoryDumpText.Text := aLeak.MemoryDumpText;
      RefreshDetail;
    end;
  end;

end;

procedure TfrmReaderMain.FormShow(Sender: TObject);
begin
  BoundsRect := Screen.WorkAreaRect;
  vtvLeaks.Height := ClientHeight div 2;
  vtvStackTrace.Width := ClientWidth div 2;
  memMemoryDumpHex.Height := memMemoryDumpHex.Parent.ClientHeight div 2;
end;

procedure TfrmReaderMain.vtvReportsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  aObj: TAbstractContent;
begin
  aObj := TAbstractContent(GetVirtualTreeNodeObj(Node));
  CellText := aObj.LogTime;
end;

procedure TfrmReaderMain.vtvReportsFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  I: Integer;
  aLeakNode: PVirtualNode;
  aReportObj: TReport;
begin
//
  vtvLeaks.Clear;

  aReportObj := TReport(GetVirtualTreeNodeObj(Node));

  for I := 0 to aReportObj.Leaks.Count - 1 do
  begin
    aLeakNode := vtvLeaks.AddChild(nil);
    SetVirtualTreeNodeObj(aLeakNode, aReportObj.Leaks[I]);
  end;

  ShowSummary(aReportObj.Summary);

  RefreshDetail;

end;

procedure TfrmReaderMain.vtvLeaksBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
begin
  //if Node.Index mod 2 <> 0 then TargetCanvas.Brush.Color := clCream
  //if Node.Index mod 2 <> 0 then TargetCanvas.Brush.Color := clAqua
  if Node.Index mod 2 <> 0 then TargetCanvas.Brush.Color := clYellow
  else TargetCanvas.Brush.Color := clWhite;
  TargetCanvas.FillRect(CellRect);
end;

procedure TfrmReaderMain.PageControl1Change(Sender: TObject);
begin
  RefreshDetail;
end;

procedure TfrmReaderMain.RefreshDetail;
begin
  vtvStackTrace.Refresh;
  memMemoryDumpHex.Refresh;
  memMemoryDumpText.Refresh;
  lsvPosition.Refresh;
  lsvLeakCount.Refresh;
end;

procedure TfrmReaderMain.ShowSummary(aSummary: TSummary);
const
  DELIMITER_STR = ':';
var
  I: Integer;
  aStrList: TStringList;
  S, sCap, sDetail: WideString;
begin
  lsvPosition.Clear;
  aStrList := TStringList.Create;

  try
    aStrList.Text := aSummary.DisplayText;
    for I := 0 to aStrList.Count - 1 do
    begin
      S := aStrList[I];
      sCap := Trim(LeftStr(S, Pos(DELIMITER_STR, S) - 1));
      sDetail := Trim(RightStr(S,
        Length(S) - Pos(DELIMITER_STR, S) - Length(DELIMITER_STR) + 1));
      with lsvPosition.Items.Add do
      begin
        Caption := sCap;
        SubItems.Add(sDetail);
      end;
    end;
  finally
    aStrList.Free;
  end;


end;

procedure TfrmReaderMain.lsvPositionSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
const
  DELIMITER_STR = ' x ';
var
  I: Integer;
  S, sType, sCount: WideString;
  aStrList: TStringList;
begin
  //ShowMessage(Item.Caption);
  lsvLeakCount.Items.Clear;
  if not Selected then Exit;

  S := Item.SubItems[0];
  S := StringReplace(S, ',', #13, [rfReplaceAll]);

  aStrList := TStringList.Create;

  try
    aStrList.Text := S;

    for I := 0 to aStrList.Count - 1 do
    begin
      with lsvLeakCount.Items.Add do
      begin
        S := aStrList[I];
        sType := Trim(LeftStr(S, Pos(DELIMITER_STR, S) - 1));
        sCount := Trim(RightStr(S,
          Length(S) - Pos(DELIMITER_STR, S) - Length(DELIMITER_STR) + 1));
        Caption := sType;
        SubItems.Add(sCount);
      end;
    end;

    RefreshDetail;
  finally
    aStrList.Free;
  end;



end;

procedure TfrmReaderMain.vtvStackTraceFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  RefreshDetail;
end;

procedure TfrmReaderMain.lsvLeakCountSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  RefreshDetail;
end;

procedure TfrmReaderMain.ClearViews;
begin
  vtvReports.Clear;
  vtvLeaks.Clear;
  vtvStackTrace.Clear;
  lsvPosition.Clear;
  lsvLeakCount.Clear;
  memMemoryDumpHex.Clear;
  memMemoryDumpText.Clear;
end;

end.

