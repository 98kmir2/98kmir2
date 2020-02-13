unit ViewKernelInfo;

interface
                                      
uses
  Windows, SysUtils, Classes, Controls, Forms, ShellAPI,
  StdCtrls, ExtCtrls, ComCtrls, Grids, MudUtil, Menus;

type
  TfrmViewKernelInfo = class(TForm)
    Timer: TTimer;
    SysInfo_PageControl: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditLoadHumanDBCount: TEdit;
    EditLoadHumanDBErrorCoun: TEdit;
    EditSaveHumanDBCount: TEdit;
    EditHumanDBQueryID: TEdit;
    GroupBox4: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    EditItemNumber: TEdit;
    EditItemNumberEx: TEdit;
    TabSheet3: TTabSheet;
    TabSheet5: TTabSheet;
    GroupBox7: TGroupBox;
    GridThread: TStringGrid;
    ListViewGlobalVal: TListView;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditWinLotteryCount: TEdit;
    EditNoWinLotteryCount: TEdit;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EditWinLotteryLevel1: TEdit;
    EditWinLotteryLevel2: TEdit;
    EditWinLotteryLevel3: TEdit;
    EditWinLotteryLevel4: TEdit;
    EditWinLotteryLevel5: TEdit;
    EditWinLotteryLevel6: TEdit;
    ButtonRefGlobalVal: TButton;
    MainMenu: TMainMenu;
    VIEW_IINFO: TMenuItem;
    VIEW_IINFO_CHGREFINTER: TMenuItem;
    VIEW_IINFO_CHGREFINTER_H: TMenuItem;
    VIEW_IINFO_CHGREFINTER_N: TMenuItem;
    VIEW_IINFO_CHGREFINTER_L: TMenuItem;
    ListViewGlobaStrVal: TListView;
    ButtonClearSval: TButton;
    ButtonClearGval: TButton;
    A1: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    procedure TimerTimer(Sender: TObject);
    procedure ButtonRefGlobalValClick(Sender: TObject);
    procedure VIEW_IINFO_CHGREFINTER_HClick(Sender: TObject);
    procedure VIEW_IINFO_CHGREFINTER_NClick(Sender: TObject);
    procedure VIEW_IINFO_CHGREFINTER_LClick(Sender: TObject);
    procedure ButtonClearGvalClick(Sender: TObject);
    procedure ButtonClearSvalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    //CPUArrayValue: array[0..199] of integer;
    //ValueCount, EndIndex: integer;
    procedure GridThreadAdd(ThreadInfo: pTThreadInfo; Index: Integer);
  public
    { Public declarations }
    procedure Open();
    procedure ViewInfoChgRefInt(Interval: Integer; Sender: TObject);
  end;

var
  frmViewKernelInfo: TfrmViewKernelInfo;

implementation

uses M2Share, EDcode;

{$R *.dfm}

procedure TfrmViewKernelInfo.Open;
begin
  GridThread.Cells[0, 0] := '序号';
  GridThread.Cells[1, 0] := '句柄';
  GridThread.Cells[2, 0] := '线程ID';
  GridThread.Cells[3, 0] := '运行时间';
  GridThread.Cells[4, 0] := '运行状态';
  Timer.Enabled := True;
  SysInfo_PageControl.ActivePageIndex := 0;
  ShowModal;
  Timer.Enabled := False;
end;

procedure TfrmViewKernelInfo.TimerTimer(Sender: TObject);
var
  i: Integer;
  Config: pTConfig;
  ThreadInfo: pTThreadInfo;
begin
  Config := @g_Config;
  EditLoadHumanDBCount.Text := IntToStr(g_Config.nLoadDBCount);
  EditLoadHumanDBErrorCoun.Text := IntToStr(g_Config.nLoadDBErrorCount);
  EditSaveHumanDBCount.Text := IntToStr(g_Config.nSaveDBCount);
  EditHumanDBQueryID.Text := IntToStr(g_Config.nDBQueryID);
  EditItemNumber.Text := IntToStr(g_Config.nItemNumber);
  EditItemNumberEx.Text := IntToStr(g_Config.nItemNumberEx);
  EditWinLotteryCount.Text := IntToStr(g_Config.nWinLotteryCount);
  EditNoWinLotteryCount.Text := IntToStr(g_Config.nNoWinLotteryCount);
  EditWinLotteryLevel1.Text := IntToStr(g_Config.nWinLotteryLevel1);
  EditWinLotteryLevel2.Text := IntToStr(g_Config.nWinLotteryLevel2);
  EditWinLotteryLevel3.Text := IntToStr(g_Config.nWinLotteryLevel3);
  EditWinLotteryLevel4.Text := IntToStr(g_Config.nWinLotteryLevel4);
  EditWinLotteryLevel5.Text := IntToStr(g_Config.nWinLotteryLevel5);
  EditWinLotteryLevel6.Text := IntToStr(g_Config.nWinLotteryLevel6);

  for I := 0 to 2 - 1 do
  begin
    ThreadInfo := @Config.UserEngineThread[i];
    GridThreadAdd(ThreadInfo, i);
  end;

  ThreadInfo := @Config.IDSocketThread;
  GridThreadAdd(ThreadInfo, 2);
  ThreadInfo := @Config.DBSOcketThread;
  GridThreadAdd(ThreadInfo, 3);
  //CollectCPUData;
  //SysInfo_StatusBar32.Panels.Items[1].Text := 'CPU 使用: ' + IntToStr(round(GetCPUUsage(GetCPUCount - 1) * 100)) + '%';
end;

procedure TfrmViewKernelInfo.GridThreadAdd(ThreadInfo: pTThreadInfo; Index: Integer);
begin
  GridThread.Cells[0, Index + 1] := Format('%d', [Index]);
  GridThread.Cells[1, Index + 1] := Format('%d', [ThreadInfo.hThreadHandle]);
  GridThread.Cells[2, Index + 1] := Format('%d', [ThreadInfo.dwThreadID]);
  GridThread.Cells[3, Index + 1] := Format('%d/%d/%d', [GetTickCount - ThreadInfo.dwRunTick, ThreadInfo.nRunTime, ThreadInfo.nMaxRunTime]);
  GridThread.Cells[4, Index + 1] := Format('%d', [ThreadInfo.nRunFlag]);
end;

procedure TfrmViewKernelInfo.ButtonRefGlobalValClick(Sender: TObject);
var
  i: Integer;
  ListItem: TListItem;
begin
  try
    ListViewGlobalVal.Clear;
    for i := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do
    begin
      ListItem := ListViewGlobalVal.Items.Add;
      ListItem.Caption := IntToStr(i);
      ListItem.SubItems.Add(IntToStr(g_Config.GlobalVal[i]));
    end;
    ListViewGlobaStrVal.Clear;
    for i := Low(g_Config.GlobaDyTval) to High(g_Config.GlobaDyTval) do
    begin
      ListItem := ListViewGlobaStrVal.Items.Add;
      ListItem.Caption := IntToStr(i);
      ListItem.SubItems.Add(g_Config.GlobaDyTval[i]);
    end;
  except
  end;
end;

procedure TfrmViewKernelInfo.ViewInfoChgRefInt(Interval: Integer; Sender: TObject);
begin
  VIEW_IINFO_CHGREFINTER_H.Checked := False;
  VIEW_IINFO_CHGREFINTER_N.Checked := False;
  VIEW_IINFO_CHGREFINTER_L.Checked := False;
  Timer.Interval := Interval;
  TMenuItem(Sender).Checked := True;
end;

procedure TfrmViewKernelInfo.VIEW_IINFO_CHGREFINTER_HClick(
  Sender: TObject);
begin
  ViewInfoChgRefInt(500, Sender);
end;

procedure TfrmViewKernelInfo.VIEW_IINFO_CHGREFINTER_NClick(
  Sender: TObject);
begin
  ViewInfoChgRefInt(1000, Sender);
end;

procedure TfrmViewKernelInfo.VIEW_IINFO_CHGREFINTER_LClick(
  Sender: TObject);
begin
  ViewInfoChgRefInt(4000, Sender);
end;

procedure TfrmViewKernelInfo.Button1Click(Sender: TObject);
begin
  if Application.MessageBox('是否确认初始化全局变量I？', '确认信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    FillChar(g_Config.GlobaDyMval, SizeOf(g_Config.GlobaDyMval), #0);
    ButtonRefGlobalValClick(Sender);
    Application.MessageBox('全局变量I初始化完毕', '提示信息', MB_OK + MB_ICONQUESTION);
  end;
end;

procedure TfrmViewKernelInfo.Button2Click(Sender: TObject);
begin
  if Application.MessageBox('是否确认初始化全局变量H？', '确认信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    FillChar(g_Config.HGlobalVal, SizeOf(g_Config.HGlobalVal), #0);
    ButtonRefGlobalValClick(Sender);
    Application.MessageBox('全局变量H初始化完毕', '提示信息', MB_OK + MB_ICONQUESTION);
  end;
end;

procedure TfrmViewKernelInfo.ButtonClearGvalClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认初始化全局变量G？', '确认信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    FillChar(g_Config.GlobalVal, SizeOf(g_Config.GlobalVal), #0);
    ButtonRefGlobalValClick(Sender);
    Application.MessageBox('全局变量G初始化完毕', '提示信息', MB_OK + MB_ICONQUESTION);
  end;
end;

procedure TfrmViewKernelInfo.ButtonClearSvalClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认初始化全局变量S？', '确认信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    FillChar(g_Config.GlobaDyTval, SizeOf(g_Config.GlobaDyTval), #0);
    ButtonRefGlobalValClick(Sender);
    Application.MessageBox('全局变量S初始化完毕', '提示信息', MB_OK + MB_ICONQUESTION);
  end;
end;

procedure TfrmViewKernelInfo.FormCreate(Sender: TObject);
begin
  ButtonRefGlobalValClick(Sender);
end;

procedure TfrmViewKernelInfo.A1Click(Sender: TObject);
begin
  ShellAbout(self.Handle,
    PChar('游戏数据引擎 V5.06 By BLUE'),
    PChar('版权所有 (C) 2005-2008 BLUE软件'), HICON(nil)); ;
end;

end.
