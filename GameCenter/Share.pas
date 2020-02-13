unit Share;

interface

uses
  SysUtils, INIFiles;

const
  CM_GETGAMELIST = 2000;
  SM_SENDGAMELIST = 5000;

type
  TGameZone = record
    sGameName: string[40];
    sGameIPaddr: string[15];
    sGameDomain: string[100];
    sProgamFile: string[20];
    sNoticeUrl: string[100];
    nGameIPPort: Integer;
    boOpened: Boolean;
    boIsOnServer: Boolean;
    sServerName: string[20];
  end;
  pTGameZone = ^TGameZone;

resourcestring
  g_sProductName = '程序名称: 传世(传奇)数据备份工具';
  g_sVersion = '程序版本: 1.01 Build 2009/10/27';
  g_sUpDateTime = '更新日期: 2009/10/27';
  g_sProgram = '程序制作: 98KM2';
  g_sWebSite = '程序网站: http://www.98km2.com';
  g_sBbsSite = '程序论坛: http://bbs.98km2.com';
  g_sIDDBDirEr = '[错误]：IDDB数据源目录设置错误...';
  g_sFBDirEr = '[错误]：FDB数据源目录设置错误...';
  g_sGuildDirEr = '[错误]：行会数据源目录设置错误...';
  g_sBackupDirEr = '[错误]：备份数据目录设置错误...';
  spIDDBDir = 'D:\Mirserver\LoginSrv\IDDB\'; //sp -> 缺省值
  spFDBDir = 'D:\Mirserver\DBServer\FDB\';
  spGuildDir = 'D:\Mirserver\Mir200\GuildBase\';
  spDataDir = 'D:\Mirserver\Mir200\Envir\QuestDiary\数据文件\';
  spSabukDir = 'D:\Mirserver\Mir200\Castle\';
  spBigBagSize = 'D:\Mirserver\Mir200\Envir\BigBag\';
  spBackupDir = 'D:\传世数据备份\';
  spOtherSourceDir1 = 'D:\其他源目录1\';
  spOtherSourceDir2 = 'D:\其他源目录2\';

var
  sConfigFileName: string = '.\Setup.ini';
  sIDDBDir: string = 'D:\Mirserver\LoginSrv\IDDB\';
  sFDBDir: string = 'D:\Mirserver\DBServer\FDB\';
  sGuildDir: string = 'D:\Mirserver\Mir200\GuildBase\';
  sDataDir: string = 'D:\Mirserver\Mir200\Envir\QuestDiary\数据文件\';
  sBakTime: string = '00:00:00';
  sSabukDir: string = 'D:\Mirserver\Mir200\Castle\';
  sBigBagSize: string = 'D:\Mirserver\Mir200\Envir\BigBag\';
  sBackupDir: string = 'D:\游戏数据备份\';
  sOtherSourceDir1: string = 'D:\其他源目录1\';
  sOtherSourceDir2: string = 'D:\其他源目录2\';
  g_sWinrarFile: string = 'C:\Program Files\WinRAR\';
  gBakWeek: Integer = 0;
  gMinInter: Integer = 820;
  bBakCheck: Boolean = True;
  bWeekCheck: Boolean = True;

  TotalFileNumbers: Integer;
  SearchFileType: string;
  Copying: Boolean;
  InterTime: Int64;

procedure SaveSetup(); //保存设置
procedure SetupChanged(); //设置变更
procedure LoadSetup();
function CheckDir(): Boolean;
function Time_ToStr(TimeStr: string): string;

implementation

uses GMain;

procedure SetupChanged();
begin
  frmMain.ModValue();
end;

procedure SaveSetup();
var
  Ini: TIniFile;
  //IDDBDir, FDBDir, GuildDir, DataDir, BackupDir, BakTime: string;
  //BakWeek: Integer;
  //BakCheck, WeekCheck: Boolean;
begin
  Ini := TIniFile.Create(sConfigFileName);
  with Ini do
  begin
    WriteString('Setup', 'IDDBDir', sIDDBDir);
    WriteString('Setup', 'FDBDir', sFDBDir);
    WriteString('Setup', 'GuildDir', sGuildDir);
    WriteString('Setup', 'DataDir', sDataDir);
    WriteString('Setup', 'BigBagDir', sBigBagSize);
    WriteString('Setup', 'SabukDir', sSabukDir);
    WriteString('Setup', 'BackupDir', sBackupDir);
    WriteInteger('Setup', 'BakWeek', gBakWeek);
    WriteInteger('Setup', 'MinInter', gMinInter);
    WriteString('Setup', 'BakTime', sBakTime);
    WriteString('Setup', 'OtherSourceDir1', sOtherSourceDir1);
    WriteString('Setup', 'OtherSourceDir2', sOtherSourceDir2);
    WriteString('Setup', 'Winrar', g_sWinrarFile);

    WriteBool('Setup', 'BakCheck', bBakCheck);
    WriteBool('Setup', 'WeekCheck', bWeekCheck);
    WriteBool('Setup', 'Backup_IDDB', frmMain.CheckBox1.Checked);
    WriteBool('Setup', 'Backup_FDB', frmMain.CheckBox2.Checked);
    WriteBool('Setup', 'Backup_GUILD', frmMain.CheckBox3.Checked);
    WriteBool('Setup', 'Backup_DATA', frmMain.CheckBox4.Checked);
    WriteBool('Setup', 'Backup_BIGBAG', frmMain.CheckBox5.Checked);
    WriteBool('Setup', 'Backup_SABUK', frmMain.CheckBox6.Checked);
    WriteBool('Setup', 'Backup_OTHER1', frmMain.CheckBox7.Checked);
    WriteBool('Setup', 'Backup_OTHER2', frmMain.CheckBox8.Checked);
    WriteBool('Setup', 'UseWinrar', frmMain.CheckBox9.Checked);
    //WriteBool('Setup', 'ShowLog', FrmMain.CheckBoxLog.Checked);
    frmMain.BitBtnSaveSetup.Enabled := false;
    Free;
  end;
end;

procedure LoadSetup();
var
  Ini: TIniFile;
  n: Integer;
  data, data2, Temp: string;
begin
  Ini := TIniFile.Create(sConfigFileName);
  if FileExists(sConfigFileName) then
  begin
    sIDDBDir := Ini.ReadString('Setup', 'IDDBDir', sIDDBDir);
    sFDBDir := Ini.ReadString('Setup', 'FDBDir', sFDBDir);
    sGuildDir := Ini.ReadString('Setup', 'GuildDir', sGuildDir);
    sDataDir := Ini.ReadString('Setup', 'DataDir', sDataDir);
    sBigBagSize := Ini.ReadString('Setup', 'BigBagDir', sBigBagSize);
    sSabukDir := Ini.ReadString('Setup', 'SabukDir', sSabukDir);
    sBackupDir := Ini.ReadString('Setup', 'BackupDir', sBackupDir);
    sOtherSourceDir1 := Ini.ReadString('Setup', 'OtherSourceDir1', sOtherSourceDir1);
    sOtherSourceDir2 := Ini.ReadString('Setup', 'OtherSourceDir2', sOtherSourceDir2);
    gBakWeek := Ini.ReadInteger('Setup', 'BakWeek', gBakWeek);
    gMinInter := Ini.ReadInteger('Setup', 'MinInter', gMinInter);
    sBakTime := Ini.ReadString('Setup', 'BakTime', '');
    bBakCheck := Ini.ReadBool('Setup', 'BakCheck', bBakCheck);
    bWeekCheck := Ini.ReadBool('Setup', 'WeekCheck', bWeekCheck);
    g_sWinrarFile := ExtractFilePath(Ini.ReadString('Setup', 'Winrar', g_sWinrarFile));
    Ini.WriteString('Setup', 'Winrar', g_sWinrarFile);

  end
  else
  begin
    Ini.WriteString('Setup', 'IDDBDir', sIDDBDir);
    Ini.WriteString('Setup', 'FDBDir', sFDBDir);
    Ini.WriteString('Setup', 'GuildDir', sGuildDir);
    Ini.WriteString('Setup', 'BackupDir', sBackupDir);
    Ini.WriteString('Setup', 'DataDir', sDataDir);
    Ini.WriteString('Setup', 'BigBagDir', sBigBagSize);
    Ini.WriteString('Setup', 'SabukDir', sSabukDir);
    Ini.WriteString('Setup', 'SabukDir', sOtherSourceDir1);
    Ini.WriteString('Setup', 'SabukDir', sOtherSourceDir2);
    Ini.WriteString('Setup', 'OtherSourceDir1', sOtherSourceDir1);
    Ini.WriteString('Setup', 'OtherSourceDir2', sOtherSourceDir2);
    Ini.WriteString('Setup', 'BakTime', sBakTime);
    Ini.WriteInteger('Setup', 'BakWeek', gBakWeek);
    Ini.WriteInteger('Setup', 'MinInter', gMinInter);
    Ini.WriteBool('Setup', 'BakWeek', bBakCheck);
    Ini.WriteBool('Setup', 'WeekCheck', bWeekCheck);
    Ini.WriteString('Setup', 'Winrar', g_sWinrarFile);
  end;
  frmMain.EditIDDB.Text := sIDDBDir;
  frmMain.EditFDB.Text := sFDBDir;
  frmMain.EditGuild.Text := sGuildDir;
  frmMain.EditData.Text := sDataDir;
  frmMain.EditBigBagSize.Text := sBigBagSize;
  frmMain.EditSabuk.Text := sSabukDir;
  frmMain.EditBakDir.Text := sBackupDir;
  frmMain.EditOtherSourceDir1.Text := sOtherSourceDir1;
  frmMain.EditOtherSourceDir2.Text := sOtherSourceDir2;
  frmMain.EditWinrarFile.Text := g_sWinrarFile;

  frmMain.ComboBoxInterDay.ItemIndex := gBakWeek;
  frmMain.CheckBoxBackupTimer.Checked := bBakCheck;
  frmMain.RadioButtonWeek.Checked := bWeekCheck;
  frmMain.RadioButtonMin.Checked := not bWeekCheck;
  frmMain.SpinEditMinInter.Value := gMinInter;
  frmMain.CheckBox1.Checked := Ini.ReadBool('Setup', 'Backup_IDDB', True);
  frmMain.CheckBox2.Checked := Ini.ReadBool('Setup', 'Backup_FDB', True);
  frmMain.CheckBox3.Checked := Ini.ReadBool('Setup', 'Backup_GUILD', True);
  frmMain.CheckBox4.Checked := Ini.ReadBool('Setup', 'Backup_DATA', True);
  frmMain.CheckBox5.Checked := Ini.ReadBool('Setup', 'Backup_BIGBAG', True);
  frmMain.CheckBox6.Checked := Ini.ReadBool('Setup', 'Backup_SABUK', True);
  frmMain.CheckBox7.Checked := Ini.ReadBool('Setup', 'Backup_OTHER1', True);
  frmMain.CheckBox8.Checked := Ini.ReadBool('Setup', 'Backup_OTHER2', True);
  frmMain.CheckBox9.Checked := Ini.ReadBool('Setup', 'UseWinrar', True);
  //FrmMain.CheckBoxLog.Checked := Ini.ReadBool('Setup', 'ShowLog', false);
  data := sBakTime;
  n := Pos(':', data);
  if n > 0 then
  begin
    data2 := Copy(data, 1, n - 1);
    Temp := Copy(data, n + 1, Length(data));
    n := Pos(':', Temp);
    data := Copy(Temp, 1, n - 1);
  end;
  frmMain.SpinEditHour.Value := StrToInt(data2);
  frmMain.SpinEditMin.Value := StrToInt(data);
  frmMain.ComboBoxInterDay.ItemIndex := Ini.ReadInteger('Setup', 'BakWeek', 0);
  Ini.Free;
end;

function CheckDir(): Boolean;
var
  s: string;
begin
  Result := True;
  sIDDBDir := frmMain.EditIDDB.Text;
  sFDBDir := frmMain.EditFDB.Text;
  sGuildDir := frmMain.EditGuild.Text;
  sDataDir := frmMain.EditData.Text;
  sSabukDir := frmMain.EditSabuk.Text;
  sBigBagSize := frmMain.EditBigBagSize.Text;
  sBackupDir := frmMain.EditBakDir.Text;
  sOtherSourceDir1 := frmMain.EditOtherSourceDir1.Text;
  sOtherSourceDir2 := frmMain.EditOtherSourceDir2.Text;
  g_sWinrarFile := frmMain.EditWinrarFile.Text;

  frmMain.ComboBoxInterDay.ItemIndex := 0;
  bWeekCheck := frmMain.RadioButtonWeek.Checked;
  gBakWeek := 0;
  sBakTime := IntToStr(frmMain.SpinEditHour.Value) + ':' + IntToStr(frmMain.SpinEditMin.Value) + ':00';
  bBakCheck := frmMain.CheckBoxBackupTimer.Checked;
  gMinInter := frmMain.SpinEditMinInter.Value;
  s := '[' + DateTimeToStr(Now) + '] ';
  if frmMain.CheckBox1.Checked then
    if not DirectoryExists(sIDDBDir) or (sIDDBDir[Length(sIDDBDir)] <> '\') then
    begin
      frmMain.LabelNotice.Caption := (s + 'IDDB数据 目录设置错误...');
      frmMain.EditIDDB.SetFocus;
      Result := false;
      Exit;
    end;
  if frmMain.CheckBox2.Checked then
    if not DirectoryExists(sFDBDir) or (sFDBDir[Length(sFDBDir)] <> '\') then
    begin
      frmMain.LabelNotice.Caption := (s + 'FDB数据 目录设置错误...');
      frmMain.EditFDB.SetFocus;
      Result := false;
      Exit;
    end;
  if frmMain.CheckBox3.Checked then
    if not DirectoryExists(sGuildDir) or (sGuildDir[Length(sGuildDir)] <> '\') then
    begin
      frmMain.LabelNotice.Caption := (s + 'GuildBase数据 目录设置错误...');
      frmMain.EditGuild.SetFocus;
      Result := false;
      Exit;
    end;
  if frmMain.CheckBox4.Checked then
    if not DirectoryExists(sDataDir) or (sDataDir[Length(sDataDir)] <> '\') then
    begin
      frmMain.LabelNotice.Caption := (s + '数据文件数据 目录设置错误...');
      frmMain.EditData.SetFocus;
      Result := false;
      Exit;
    end;
  if frmMain.CheckBox5.Checked then
    if not DirectoryExists(sBigBagSize) or (sBigBagSize[Length(sBigBagSize)] <> '\') then
    begin
      frmMain.LabelNotice.Caption := (s + '大包裹数据文件 数据目录设置错误...');
      frmMain.EditBigBagSize.SetFocus;
      Result := false;
      Exit;
    end;
  if frmMain.CheckBox6.Checked then
    if not DirectoryExists(sSabukDir) or (sSabukDir[Length(sSabukDir)] <> '\') then
    begin
      frmMain.LabelNotice.Caption := (s + '沙巴克 数据目录设置错误...');
      frmMain.EditSabuk.SetFocus;
      Result := false;
      Exit;
    end;
  if frmMain.CheckBox7.Checked then
    if not DirectoryExists(sOtherSourceDir1) or (sOtherSourceDir1[Length(sOtherSourceDir1)] <> '\') then
    begin
      frmMain.LabelNotice.Caption := (s + '其他源备份目录(1)设置错误...');
      frmMain.EditOtherSourceDir1.SetFocus;
      Result := false;
      Exit;
    end;
  if frmMain.CheckBox8.Checked then
    if not DirectoryExists(sOtherSourceDir2) or (sOtherSourceDir2[Length(sOtherSourceDir2)] <> '\') then
    begin
      frmMain.LabelNotice.Caption := (s + '其他源备份目录(2)设置错误...');
      frmMain.EditOtherSourceDir2.SetFocus;
      Result := false;
      Exit;
    end;
  if not DirectoryExists(sBackupDir) or (sBackupDir[Length(sBackupDir)] <> '\') then
  begin
    frmMain.LabelNotice.Caption := (s + '数据备份 目录设置错误...');
    //frmMain.EditBakDir.SetFocus;
    Result := false;
    Exit;
  end;
  frmMain.LabelNotice.Caption := '目录设置已经保存...';
end;

function Time_ToStr(TimeStr: string): string;
var
  n: Integer;
  Hour, Min, Sec, Temp: string;
begin
  Result := '';
  Temp := TimeStr;
  n := Pos(':', Temp);
  if n > 0 then
  begin
    Hour := Copy(Temp, 1, n - 1); //分解出小时
    Temp := Copy(Temp, n + 1, Length(Temp)); //放置剩余部分
    n := Pos(':', Temp);
    Min := Copy(Temp, 1, n - 1); //分解出分
    Sec := Copy(Temp, n + 1, Length(Temp)); //放置剩余部分,就是最后的秒
    Result := Hour + '-' + Min + '-' + Sec; //输出结果
  end;
end;

end.
