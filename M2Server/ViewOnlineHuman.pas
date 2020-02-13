unit ViewOnlineHuman;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, Grobal2, Spin;

type
  TfrmViewOnlineHuman = class(TForm)
    PanelStatus: TPanel;
    GridHuman: TStringGrid;
    Timer: TTimer;
    Panel1: TPanel;
    ButtonRefGrid: TButton;
    ButtonView: TButton;
    ButtonSearch: TButton;
    EditSearchName: TEdit;
    ComboBoxSort: TComboBox;
    Label1: TLabel;
    ButtonKickOffLinPlayer: TButton;
    EditLevelMIN: TSpinEdit;
    EditLevelMAX: TSpinEdit;
    Label2: TLabel;
    CheckBoxHero: TCheckBox;
    ButtonKickSpecPlayer: TButton;
    EditSpecCharName: TEdit;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonRefGridClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxSortClick(Sender: TObject);
    procedure GridHumanDblClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ButtonSearchClick(Sender: TObject);
    procedure ButtonViewClick(Sender: TObject);
    procedure EditSearchNameKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonKickOffLinPlayerClick(Sender: TObject);
    procedure EditLevelMAXChange(Sender: TObject);
    procedure EditLevelMINChange(Sender: TObject);
    procedure EditLevelMINEnter(Sender: TObject);
    procedure EditLevelMAXEnter(Sender: TObject);
    procedure CheckBoxHeroClick(Sender: TObject);
    procedure ButtonKickSpecPlayerClick(Sender: TObject);
  private
    boRefGridSession: Boolean;
    ViewList: TStringList;
    dwTimeOutTick: LongWord;
    dwRefGridSession: LongWord;
    procedure RefGridSession();
    procedure GetOnlineList();
    procedure SortOnlineList(nSort: Integer);
    procedure ShowHumanInfo();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmViewOnlineHuman: TfrmViewOnlineHuman;

implementation

uses UsrEngn, M2Share, ObjBase, HUtil32, HumanInfo;

{$R *.dfm}

{ TfrmViewOnlineHuman }

procedure TfrmViewOnlineHuman.Open;
begin
  frmHumanInfo := TfrmHumanInfo.Create(Owner);
  dwTimeOutTick := GetTickCount();
  dwRefGridSession := GetTickCount();
  boRefGridSession := False;
  GetOnlineList();
  RefGridSession();
  Timer.Enabled := True;
  ShowModal;
  Timer.Enabled := False;
  frmHumanInfo.Free;
end;

procedure TfrmViewOnlineHuman.GetOnlineList;
var
  i: Integer;
  Hero: TBaseObject;
begin
  ViewList.Clear;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if CheckBoxHero.Checked then
    begin
      for i := 0 to UserEngine.m_HeroProcList.Count - 1 do
      begin
        Hero := UserEngine.m_HeroProcList.Items[i];
        if not Hero.m_boGhost then
          ViewList.AddObject(Hero.m_sCharName, Hero);
      end;
    end
    else
    begin
      for i := 0 to UserEngine.m_PlayObjectList.Count - 1 do
        ViewList.AddObject(UserEngine.m_PlayObjectList.Strings[i], UserEngine.m_PlayObjectList.Objects[i]);
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TfrmViewOnlineHuman.RefGridSession;
var
  i: Integer;
  PlayObject: TPlayObject;
  //PlayObject                : TBaseObject;
begin
  PanelStatus.Caption := '正在取得数据...';
  GridHuman.Visible := False;
  GridHuman.Cells[0, 1] := '';
  GridHuman.Cells[1, 1] := '';
  GridHuman.Cells[2, 1] := '';
  GridHuman.Cells[3, 1] := '';
  GridHuman.Cells[4, 1] := '';
  GridHuman.Cells[5, 1] := '';
  GridHuman.Cells[6, 1] := '';
  GridHuman.Cells[7, 1] := '';
  GridHuman.Cells[8, 1] := '';
  GridHuman.Cells[9, 1] := '';
  GridHuman.Cells[10, 1] := '';
  GridHuman.Cells[11, 1] := '';
  GridHuman.Cells[12, 1] := '';
  GridHuman.Cells[13, 1] := '';
  GridHuman.Cells[14, 1] := '';

  if ViewList.Count <= 0 then
  begin
    GridHuman.RowCount := 2;
    GridHuman.FixedRows := 1;
  end
  else
    GridHuman.RowCount := ViewList.Count + 1;
  for i := 0 to ViewList.Count - 1 do
  begin
    PlayObject := TPlayObject(ViewList.Objects[i]);
    GridHuman.Cells[0, i + 1] := IntToStr(i);
    GridHuman.Cells[1, i + 1] := PlayObject.m_sCharName;
    GridHuman.Cells[2, i + 1] := IntToSex(PlayObject.m_btGender);
    GridHuman.Cells[3, i + 1] := IntToJob(PlayObject.m_btJob);
    GridHuman.Cells[4, i + 1] := format('%d/%d', [PlayObject.m_Abil.Level, PlayObject.m_nInPowerLevel]);
    GridHuman.Cells[5, i + 1] := PlayObject.m_sMapName;
    GridHuman.Cells[6, i + 1] := IntToStr(PlayObject.m_nCurrX) + ':' + IntToStr(PlayObject.m_nCurrY);
    GridHuman.Cells[7, i + 1] := PlayObject.m_sUserID;
    if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
    begin
      GridHuman.Cells[8, i + 1] := PlayObject.m_sIPaddr;
      GridHuman.Cells[9, i + 1] := IntToStr(PlayObject.m_btPermission);
{$IF EXPIPLOCAL=1}
      GridHuman.Cells[10, i + 1] := GetIPLocal(PlayObject.m_sIPaddr);
{$ELSE}
      GridHuman.Cells[10, i + 1] := PlayObject.m_sIPLocal;
{$IFEND}
      if PlayObject.m_boOffLineFlag then
        GridHuman.Cells[14, i + 1] := '脱机在线'
      else
        GridHuman.Cells[14, i + 1] := '正常登陆';
    end
    else
    begin
      GridHuman.Cells[8, i + 1] := TPlayObject(PlayObject.m_Master).m_sIPaddr;
      GridHuman.Cells[9, i + 1] := IntToStr(0);
{$IF EXPIPLOCAL=1}
      GridHuman.Cells[10, i + 1] := GetIPLocal(TPlayObject(PlayObject.m_Master).m_sIPaddr);
{$ELSE}
      GridHuman.Cells[10, i + 1] := PlayObject.m_Master.m_sIPLocal;
{$IFEND}
      GridHuman.Cells[14, i + 1] := '正常登陆';
    end;
    GridHuman.Cells[11, i + 1] := IntToStr(PlayObject.m_nGameGold);
    GridHuman.Cells[12, i + 1] := IntToStr(PlayObject.m_nGamePoint);
    GridHuman.Cells[13, i + 1] := IntToStr(PlayObject.m_nPayMentPoint);
  end;
  GridHuman.Visible := True;
end;

procedure TfrmViewOnlineHuman.FormCreate(Sender: TObject);
begin
  ViewList := TStringList.Create;
  GridHuman.Cells[0, 0] := '序号';
  GridHuman.Cells[1, 0] := '人物名称';
  GridHuman.Cells[2, 0] := '性别';
  GridHuman.Cells[3, 0] := '职业';
  GridHuman.Cells[4, 0] := '等级/内功等级';
  GridHuman.Cells[5, 0] := '地图';
  GridHuman.Cells[6, 0] := '座标';
  GridHuman.Cells[7, 0] := '登录帐号';
  GridHuman.Cells[8, 0] := '登录IP';
  GridHuman.Cells[9, 0] := '权限';
  GridHuman.Cells[10, 0] := '所在地区';
  GridHuman.Cells[11, 0] := g_Config.sGameGoldName;
  GridHuman.Cells[12, 0] := g_Config.sGamePointName;
  GridHuman.Cells[13, 0] := g_Config.sPayMentPointName;
  GridHuman.Cells[14, 0] := '在线状态';
end;

procedure TfrmViewOnlineHuman.ButtonRefGridClick(Sender: TObject);
begin
  dwTimeOutTick := GetTickCount();
  GetOnlineList();
  RefGridSession();
end;

procedure TfrmViewOnlineHuman.FormDestroy(Sender: TObject);
begin
  ViewList.Free;
end;

procedure TfrmViewOnlineHuman.ComboBoxSortClick(Sender: TObject);
begin
  if ComboBoxSort.ItemIndex < 0 then
    Exit;
  dwTimeOutTick := GetTickCount();
  GetOnlineList();
  SortOnlineList(ComboBoxSort.ItemIndex);
  RefGridSession();
end;

procedure TfrmViewOnlineHuman.SortOnlineList(nSort: Integer);
var
  i: Integer;
  SortList: TStringList;
  PlayObject: TPlayObject;
begin
  SortList := TStringList.Create;
  case nSort of
    0:
      begin
        ViewList.Sort;
        Exit;
      end;
    1: for i := 0 to ViewList.Count - 1 do
        SortList.AddObject(IntToStr(TPlayObject(ViewList.Objects[i]).m_btGender), ViewList.Objects[i]);
    2: for i := 0 to ViewList.Count - 1 do
        SortList.AddObject(IntToStr(TPlayObject(ViewList.Objects[i]).m_btJob), ViewList.Objects[i]);
    3: for i := 0 to ViewList.Count - 1 do
        SortList.AddObject(IntToStr(TPlayObject(ViewList.Objects[i]).m_Abil.Level), ViewList.Objects[i]);
    4: for i := 0 to ViewList.Count - 1 do
        SortList.AddObject(TPlayObject(ViewList.Objects[i]).m_sMapName, ViewList.Objects[i]);
    5: for i := 0 to ViewList.Count - 1 do
      begin
        PlayObject := TPlayObject(ViewList.Objects[i]);
        if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
          SortList.AddObject(PlayObject.m_sIPaddr, ViewList.Objects[i])
        else
          SortList.AddObject(TPlayObject(PlayObject.m_Master).m_sIPaddr, ViewList.Objects[i]);
      end;
    6: for i := 0 to ViewList.Count - 1 do
      begin
        PlayObject := TPlayObject(ViewList.Objects[i]);
        if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
          SortList.AddObject(IntToStr(PlayObject.m_btPermission), ViewList.Objects[i])
        else
          SortList.AddObject(IntToStr(TPlayObject(PlayObject.m_Master).m_btPermission), ViewList.Objects[i]);
      end;
    7: for i := 0 to ViewList.Count - 1 do
      begin
        SortList.AddObject(TPlayObject(ViewList.Objects[i]).m_sIPLocal, ViewList.Objects[i]);
        PlayObject := TPlayObject(ViewList.Objects[i]);
        if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
          SortList.AddObject(PlayObject.m_sIPLocal, ViewList.Objects[i])
        else
          SortList.AddObject(TPlayObject(PlayObject.m_Master).m_sIPLocal, ViewList.Objects[i]);
      end;
  end;
  ViewList.Free;
  ViewList := SortList;
  ViewList.Sort;
end;

procedure TfrmViewOnlineHuman.GridHumanDblClick(Sender: TObject);
begin
  ShowHumanInfo();
end;

procedure TfrmViewOnlineHuman.TimerTimer(Sender: TObject);
begin
  if (ViewList.Count > 0) and ((GetTickCount - dwTimeOutTick > 60 * 1000) or (boRefGridSession and (GetTickCount > dwRefGridSession))) then
  begin
    boRefGridSession := False;
    ViewList.Clear;
    RefGridSession();
  end;
end;

procedure TfrmViewOnlineHuman.ButtonSearchClick(Sender: TObject);
var
  i: Integer;
  sHumanName: string;
  PlayObject: TBaseObject;
begin
  sHumanName := Trim(EditSearchName.Text);
  if sHumanName = '' then
  begin
    Application.MessageBox('请输入一个人物名称！', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  for i := 0 to ViewList.Count - 1 do
  begin
    PlayObject := TPlayObject(ViewList.Objects[i]);
    if CompareText(PlayObject.m_sCharName, sHumanName) = 0 then
    begin
      GridHuman.Row := i + 1;
      Exit;
    end;
  end;
  Application.MessageBox('人物/英雄没有在线！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmViewOnlineHuman.ButtonViewClick(Sender: TObject);
begin
  ShowHumanInfo();
end;

procedure TfrmViewOnlineHuman.ShowHumanInfo;
var
  nSelIndex: Integer;
  sPlayObjectName: string;
  PlayObject: TPlayObject;
  HeroObject: TBaseObject;
begin
  nSelIndex := GridHuman.Row;
  Dec(nSelIndex);
  if (nSelIndex < 0) or (ViewList.Count <= nSelIndex) then
  begin
    Application.MessageBox('请先选择一个要查看的人物/英雄', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  sPlayObjectName := GridHuman.Cells[1, nSelIndex + 1];
  if not CheckBoxHero.Checked then
  begin
    PlayObject := UserEngine.GetPlayObjectCS_Name(sPlayObjectName);
    if PlayObject = nil then
    begin
      Application.MessageBox('此人物已经不在线', '提示信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    if Integer(PlayObject) <> Integer(ViewList.Objects[nSelIndex]) then
    begin
      ViewList.Objects[nSelIndex] := PlayObject;
      RefGridSession();
    end;
  end
  else
  begin
    HeroObject := UserEngine.GetHeroObjectCS(sPlayObjectName);
    if HeroObject = nil then
    begin
      Application.MessageBox('此英雄已经不在线', '提示信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    if Integer(HeroObject) <> Integer(ViewList.Objects[nSelIndex]) then
    begin
      ViewList.Objects[nSelIndex] := HeroObject;
      RefGridSession();
    end;
  end;
  frmHumanInfo.PlayObject := TPlayObject(ViewList.Objects[nSelIndex]);
  frmHumanInfo.Top := self.Top + 20;
  frmHumanInfo.Left := self.Left;
  frmHumanInfo.Open();
end;

procedure TfrmViewOnlineHuman.EditSearchNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key <> #13 then
    Exit;
  ButtonSearchClick(Sender);
end;

procedure TfrmViewOnlineHuman.ButtonKickOffLinPlayerClick(Sender: TObject);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  if Application.MessageBox(PChar(format('是否确定踢除%d-%d等级的脱机人物？', [EditLevelMIN.Value, EditLevelMAX.Value])), '确认信息', MB_YESNO + MB_ICONQUESTION) <> IDYES then
    Exit;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to UserEngine.m_PlayObjectList.Count - 1 do
    begin
      PlayObject := TPlayObject(UserEngine.m_PlayObjectList.Objects[i]);
      if EditLevelMIN.Value > EditLevelMAX.Value then
      begin
        Application.MessageBox('踢除脱机人物等级设置错误！', '提示信息', MB_OK + MB_ICONINFORMATION);
        EditLevelMIN.SetFocus;
        Break;
      end;
      if (PlayObject.m_Abil.Level >= EditLevelMIN.Value) and (PlayObject.m_Abil.Level <= EditLevelMAX.Value) and PlayObject.m_boOffLineFlag then
        PlayObject.m_boKickFlag := True;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
  dwRefGridSession := GetTickCount() + 1500;
  boRefGridSession := True;
end;

procedure TfrmViewOnlineHuman.EditLevelMAXChange(Sender: TObject);
begin
  if EditLevelMAX.Value < EditLevelMIN.Value then
  begin
    EditLevelMAX.Value := EditLevelMIN.Value;
    Beep;
  end;
end;

procedure TfrmViewOnlineHuman.EditLevelMINChange(Sender: TObject);
begin
  if EditLevelMAX.Value < EditLevelMIN.Value then
  begin
    EditLevelMIN.Value := EditLevelMAX.Value;
    Beep;
  end;
end;

procedure TfrmViewOnlineHuman.EditLevelMINEnter(Sender: TObject);
begin
  if EditLevelMAX.Value < EditLevelMIN.Value then
  begin
    EditLevelMIN.Value := EditLevelMAX.Value;
    Beep;
  end;
end;

procedure TfrmViewOnlineHuman.EditLevelMAXEnter(Sender: TObject);
begin
  if EditLevelMAX.Value < EditLevelMIN.Value then
  begin
    EditLevelMAX.Value := EditLevelMIN.Value;
    Beep;
  end;
end;

procedure TfrmViewOnlineHuman.CheckBoxHeroClick(Sender: TObject);
begin
  ButtonKickOffLinPlayer.Enabled := not CheckBoxHero.Checked;
  EditLevelMIN.Enabled := not CheckBoxHero.Checked;
  EditLevelMAX.Enabled := not CheckBoxHero.Checked;
  Label2.Enabled := not CheckBoxHero.Checked;
  ButtonRefGridClick(Sender);
end;

procedure TfrmViewOnlineHuman.ButtonKickSpecPlayerClick(Sender: TObject);
var
  i: Integer;
  sSpec: string;
  PlayObject: TPlayObject;
begin
  sSpec := Trim(EditSpecCharName.Text);
  if sSpec = '' then
  begin
    Application.MessageBox('指定字符信息不能为空！', '提示信息', MB_YESNO + MB_ICONINFORMATION);
    Exit;
  end;
  if Application.MessageBox(PChar(format('是否确定踢除名字中包含 %s 的在线人物？', [sSpec])), '确认信息', MB_YESNO + MB_ICONQUESTION) <> IDYES then
    Exit;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to UserEngine.m_PlayObjectList.Count - 1 do
    begin
      PlayObject := TPlayObject(UserEngine.m_PlayObjectList.Objects[i]);
      if Pos(sSpec, PlayObject.m_sCharName) > 0 then
        PlayObject.m_boKickFlag := True;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
  dwRefGridSession := GetTickCount() + 1000;
  boRefGridSession := True;
end;

end.
