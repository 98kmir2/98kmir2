unit ViewHighRank;

interface

uses
  Windows, SysUtils, Classes, ObjBase, MudUtil, Controls, Forms, StdCtrls, ExtCtrls, ComCtrls;
  
type
  TfrmHighRank = class(TForm)
    ButtonClear: TButton;
    ButtonRefShow: TButton;
    TimerClean: TTimer;
    GroupBox1: TGroupBox;
    ListViewServerHighRank: TListView;
    GroupBox2: TGroupBox;
    ListViewOnlineHighRank: TListView;
    CheckBoxRefRealTime: TCheckBox;

    procedure ButtonRefShowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure TimerCleanTimer(Sender: TObject);
    procedure ListViewServerHighRankColumnClick(Sender: TObject;
      Column: TListColumn);
  private
    //ViewOnLineList: TStringList;
    ViewOnLineList: TQuickList;
    dwTimeOutTick: LongWord;
    dwTimeRefTick: LongWord;
    procedure GetOnlineList();
    procedure RefViewOnlineHighRank();
    procedure SortOnlineList(nSort: Integer);
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmHighRank               : TfrmHighRank;

implementation

uses M2Share, Grobal2;

{$R *.DFM}

procedure TfrmHighRank.RefViewOnlineHighRank;
var
  i                         : Integer;
  PlayObject                : TPlayObject;
  ListItem                  : TListItem;
begin
  try
    for i := 0 to ViewOnLineList.Count - 1 do begin
      PlayObject := TPlayObject(ViewOnLineList.Objects[i]);
      ListItem := ListViewOnlineHighRank.Items.add;
      ListItem.Caption := IntToStr(i);
      ListItem.SubItems.add(PlayObject.m_sCharName);
      ListItem.SubItems.add(IntToStr(PlayObject.m_Abil.Level));
      ListItem.SubItems.add(IntToStr(PlayObject.m_Abil.Exp));
      ListItem.SubItems.add(IntToStr(LoWord(PlayObject.m_WAbil.AC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.AC)));
      ListItem.SubItems.add(IntToStr(LoWord(PlayObject.m_WAbil.MAC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.MAC)));
      ListItem.SubItems.add(IntToStr(LoWord(PlayObject.m_WAbil.DC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.DC)));
      ListItem.SubItems.add(IntToStr(LoWord(PlayObject.m_WAbil.MC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.MC)));
      ListItem.SubItems.add(IntToStr(LoWord(PlayObject.m_WAbil.SC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.SC)));
      ListItem.SubItems.add(IntToStr(PlayObject.m_nPkPoint));
    end;
  except
  end;
end;

procedure TfrmHighRank.SortOnlineList(nSort: Integer);
var
  i                         : Integer;
  SortList                  : TQuickList;
begin
  SortList := TQuickList.Create;
  case nSort of
    2: begin
        for i := 0 to ViewOnLineList.Count - 1 do
          SortList.AddObject(IntToStr(TPlayObject(ViewOnLineList.Objects[i]).m_Abil.Level), ViewOnLineList.Objects[i]);
      end;
    4: begin
        for i := 0 to ViewOnLineList.Count - 1 do
          SortList.AddObject(IntToStr(HiWord(TPlayObject(ViewOnLineList.Objects[i]).m_WAbil.MAC)), ViewOnLineList.Objects[i]);
      end;
    5: begin
        for i := 0 to ViewOnLineList.Count - 1 do
          SortList.AddObject(IntToStr(HiWord(TPlayObject(ViewOnLineList.Objects[i]).m_WAbil.AC)), ViewOnLineList.Objects[i]);
      end;
    6: begin
        for i := 0 to ViewOnLineList.Count - 1 do
          SortList.AddObject(IntToStr(HiWord(TPlayObject(ViewOnLineList.Objects[i]).m_WAbil.DC)), ViewOnLineList.Objects[i]);
      end;
    7: begin
        for i := 0 to ViewOnLineList.Count - 1 do
          SortList.AddObject(IntToStr(HiWord(TPlayObject(ViewOnLineList.Objects[i]).m_WAbil.MC)), ViewOnLineList.Objects[i]);
      end;
    8: begin
        for i := 0 to ViewOnLineList.Count - 1 do
          SortList.AddObject(IntToStr(HiWord(TPlayObject(ViewOnLineList.Objects[i]).m_WAbil.SC)), ViewOnLineList.Objects[i]);
      end;
    9: begin
        for i := 0 to ViewOnLineList.Count - 1 do
          SortList.AddObject(IntToStr(TPlayObject(ViewOnLineList.Objects[i]).m_nPkPoint), ViewOnLineList.Objects[i]);
      end;
  end;
  ViewOnLineList.Free;
  ViewOnLineList := SortList;
  ViewOnLineList.Sort;
end;

procedure TfrmHighRank.Open;
begin
  ShowModal;
end;

procedure TfrmHighRank.GetOnlineList;
var
  i                         : Integer;
  //it                        : IStrIntMapIterator;
begin
  ViewOnLineList.Clear;
  try
    EnterCriticalSection(ProcessHumanCriticalSection);
    for i := 0 to UserEngine.m_PlayObjectList.Count - 1 do begin
      ViewOnLineList.AddObject(UserEngine.m_PlayObjectList.Strings[i], UserEngine.m_PlayObjectList.Objects[i]);
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TfrmHighRank.ButtonRefShowClick(Sender: TObject);
begin
  dwTimeOutTick := GetTickCount();
  ButtonClearClick(Sender);
  GetOnlineList();
  SortOnlineList(0);
  RefViewOnlineHighRank();
end;

procedure TfrmHighRank.FormCreate(Sender: TObject);
begin
  dwTimeOutTick := GetTickCount();
  dwTimeRefTick := GetTickCount();
  ViewOnLineList := TQuickList.Create;
end;

procedure TfrmHighRank.FormDestroy(Sender: TObject);
begin
  ViewOnLineList.Free;
end;

procedure TfrmHighRank.ButtonClearClick(Sender: TObject);
begin
  dwTimeOutTick := GetTickCount();
  if ListViewServerHighRank.Items.Count > 0 then
    ListViewOnlineHighRank.Clear;
  if ListViewOnlineHighRank.Items.Count > 0 then
    ListViewOnlineHighRank.Clear;
end;

procedure TfrmHighRank.TimerCleanTimer(Sender: TObject);
begin
  if CheckBoxRefRealTime.Checked then begin
    if GetTickCount - dwTimeRefTick > 3 * 1000 then
      dwTimeRefTick := GetTickCount();
    ButtonRefShowClick(Sender);
  end else if GetTickCount - dwTimeOutTick > 20 * 1000 then
    ButtonClearClick(Sender);
end;

procedure TfrmHighRank.ListViewServerHighRankColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if Column.Index in [2, 4, 5, 6, 7, 8, 9] then begin
    dwTimeOutTick := GetTickCount();
    ButtonClearClick(Sender);
    GetOnlineList();
    SortOnlineList(Column.Index);
    RefViewOnlineHighRank();
  end;
end;

end.

