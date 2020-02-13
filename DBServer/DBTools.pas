unit DBTools;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Grids, ComCtrls, StdCtrls, ExtCtrls, Spin;

type
  TfrmDBTool = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    GridMirDBInfo: TStringGrid;
    GroupBox2: TGroupBox;
    GridHumDBInfo: TStringGrid;
    TabSheet2: TTabSheet;
    ButtonStartRebuild: TButton;
    LabelProcess: TLabel;
    TimerShowInfo: TTimer;
    GroupBox3: TGroupBox;
    CheckBoxDelDenyChr: TCheckBox;
    CheckBoxDelAllItem: TCheckBox;
    CheckBoxDelAllSkill: TCheckBox;
    CheckBoxDelBonusAbil: TCheckBox;
    CheckBoxDelLevel: TCheckBox;
    ProgressBar: TProgressBar;
    Label1: TLabel;
    LabelProcessPercent: TLabel;
    Label2: TLabel;
    TabSheet3: TTabSheet;
    GroupBox4: TGroupBox;
    EditLevelMin: TSpinEdit;
    Label6: TLabel;
    EditLevelMax: TSpinEdit;
    EditHumanCount: TSpinEdit;
    Label3: TLabel;
    ButtonExportData: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartRebuildClick(Sender: TObject);
    procedure TimerShowInfoTimer(Sender: TObject);
    procedure CheckBoxDelDenyChrClick(Sender: TObject);
    procedure CheckBoxDelLevelClick(Sender: TObject);
    procedure CheckBoxDelAllItemClick(Sender: TObject);
    procedure CheckBoxDelAllSkillClick(Sender: TObject);
    procedure CheckBoxDelBonusAbilClick(Sender: TObject);
    procedure EditLevelMinChange(Sender: TObject);
    procedure EditLevelMaxChange(Sender: TObject);
    procedure ButtonExportDataClick(Sender: TObject);
  private
    procedure RefDBInfo();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

  TBuildDB = class(TThread)
  private
    //procedure UpdateProcess();
  protected
    procedure Execute; override;
  end;

var
  frmDBTool: TfrmDBTool;

implementation

uses{$IFDEF SQLDB}HumDB_SQL{$ELSE}HumDB{$ENDIF}, DBShare, Grobal2, HashList;

var
  boRebuilding: Boolean = False;
  BuildDB: TBuildDB;
  nProcID: Integer;
  nProcMax: Integer;
  //UpdateProcessTick: LongWord;
  boDelDenyChr: Boolean = False;
  boDelAllItem: Boolean = False;
  boDelAllSkill: Boolean = False;
  boDelBonusAbil: Boolean = False;
  boDelLevel: Boolean = False;

{$R *.dfm}

  { TfrmDBTool }

procedure TfrmDBTool.Open;
begin
  RefDBInfo();
  ShowModal;
end;

procedure TfrmDBTool.RefDBInfo;
begin
  PageControl1.ActivePageIndex := 0;
{$IFDEF SQLDB}

{$ELSE}
  try
    if HumDataDB.OpenEx then
    begin
      GridMirDBInfo.Cells[1, 1] := HumDataDB.m_sDBFileName;
      GridMirDBInfo.Cells[1, 2] := HumDataDB.m_Header.sDesc;
      GridMirDBInfo.Cells[1, 3] := IntToStr(HumDataDB.m_Header.nHumCount);
      GridMirDBInfo.Cells[1, 4] := IntToStr(HumDataDB.m_MirQuickList.Count);
      GridMirDBInfo.Cells[1, 5] := IntToStr(HumDataDB.m_DeletedList.Count);
      GridMirDBInfo.Cells[1, 6] := DateTimeToStr(HumDataDB.m_Header.dUpdateDate);
    end;
  finally
    HumDataDB.Close();
  end;
  try
    if HumChrDB.OpenEx then
    begin
      GridHumDBInfo.Cells[1, 1] := HumChrDB.m_sDBFileName;
      GridHumDBInfo.Cells[1, 2] := HumChrDB.m_Header.sDesc;
      GridHumDBInfo.Cells[1, 3] := IntToStr(HumChrDB.m_Header.nHumCount);
      GridHumDBInfo.Cells[1, 4] := IntToStr(HumChrDB.m_QuickList.Count);
      GridHumDBInfo.Cells[1, 5] := IntToStr(HumChrDB.m_DeletedList.Count);
      GridHumDBInfo.Cells[1, 6] := DateTimeToStr(HumChrDB.m_Header.dUpdateDate);
    end;
  finally
    HumChrDB.Close();
  end;
{$ENDIF}
end;

procedure TfrmDBTool.FormCreate(Sender: TObject);
begin
  GridMirDBInfo.Cells[0, 0] := '参数';
  GridMirDBInfo.Cells[1, 0] := '内容';
  GridMirDBInfo.Cells[0, 1] := '文件位置';
  GridMirDBInfo.Cells[0, 2] := '文件标识';
  GridMirDBInfo.Cells[0, 3] := '记录总数';
  GridMirDBInfo.Cells[0, 4] := '有效数量';
  GridMirDBInfo.Cells[0, 5] := '删除数量';
  GridMirDBInfo.Cells[0, 6] := '更新日期';

  GridHumDBInfo.Cells[0, 0] := '参数';
  GridHumDBInfo.Cells[1, 0] := '内容';
  GridHumDBInfo.Cells[0, 1] := '文件位置';
  GridHumDBInfo.Cells[0, 2] := '文件标识';
  GridHumDBInfo.Cells[0, 3] := '记录总数';
  GridHumDBInfo.Cells[0, 4] := '有效数量';
  GridHumDBInfo.Cells[0, 5] := '删除数量';
  GridHumDBInfo.Cells[0, 6] := '更新日期';
end;

procedure TfrmDBTool.ButtonExportDataClick(Sender: TObject);
var
  nIndex, n, cnt: Integer;
  lmin, lmax: Integer;
  DBHeader: TDBHeader;
  HumData: THumDataInfo;
  List: TStringList;
  hList: THStringList;
begin
  cnt := EditHumanCount.Value;
  lmin := EditLevelMin.Value;
  lmax := EditLevelMax.Value;
  List := TStringList.Create;
  hList := THStringList.Create;
  boAutoClearDB := False;
{$IFDEF SQLDB}

{$ELSE}
  try
    if HumDataDB.Open then
    begin
      FileSeek(HumDataDB.m_nFileHandle, 0, 0);
      if FileRead(HumDataDB.m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then
      begin
        n := 0;
        for nIndex := 0 to DBHeader.nHumCount - 1 do
        begin
          if n > cnt then
            Break;
          if FileSeek(HumDataDB.m_nFileHandle, nIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader), 0) = -1 then
            Break;
          if FileRead(HumDataDB.m_nFileHandle, HumData, SizeOf(THumDataInfo)) <> SizeOf(THumDataInfo) then
            Break;
          if not HumData.Header.boDeleted and (HumData.Data.Abil.Level >= lmin) and (HumData.Data.Abil.Level <= lmax) then
          begin
            if (HumData.Data.sHeroMasterName = '') and (HumData.Data.sAccount <> '') then
            begin
              if hList.IndexOf(HumData.Data.sAccount) < 0 then
              begin
                List.Add(format('%s %s', [HumData.Data.sAccount, HumData.Data.sChrName]));
                hList.Add(HumData.Data.sAccount);
                inc(n);
              end;
            end;
          end;
          Application.ProcessMessages;
        end;
      end;
    end;
  finally
    HumDataDB.Close();
  end;
  if (List.Count > 0) and DirectoryExists('..\Mir200\Envir') then
  begin
    List.SaveToFile('..\Mir200\Envir\AutoLogin.txt');
    MessageBox(0, pchar(format('导出数据到：'#13#13'%s', [ExpandFileName('..\Mir200\Envir\AutoLogin.txt')])), '提示信息', MB_OK);
  end;
  List.Free;
  hList.Free;
{$ENDIF}
  boAutoClearDB := True; //ExtractFileName
end;

procedure TfrmDBTool.ButtonStartRebuildClick(Sender: TObject);
begin
  if Application.MessageBox('在重建数据库过程中，数据库服务器将停止工作，是否确认继续？', '提示信息', MB_IconInformation + MB_YesNo) = IDYes then
  begin
    boAutoClearDB := False;
    boRebuilding := True;
    ButtonStartRebuild.Enabled := False;
    BuildDB := TBuildDB.Create(False);
    BuildDB.FreeOnTerminate := True;
    TimerShowInfo.Enabled := True;
  end;
end;

{ TBuildDB }

procedure TBuildDB.Execute;
var
  i: Integer;
  NewChrDB: TFileHumDB;
  NewDataDB: TFileDB;
  sHumDBFile, sMirDBFile: string;
  SrcHumanRCD: THumDataInfo;
  HumRecord: THumInfo;
  nSrcHumIndex: Integer;
begin
  sHumDBFile := sHumDBFilePath + 'NewHum.DB';
  sMirDBFile := sHumDBFilePath + 'NewMir.DB';
  if FileExists(sHumDBFile) then
    DeleteFile(sHumDBFile);
  if FileExists(sMirDBFile) then
    DeleteFile(sMirDBFile);
  NewChrDB := TFileHumDB.Create(sHumDBFile);
  NewDataDB := TFileDB.Create(sMirDBFile);
  try
    if HumDataDB.Open and HumChrDB.Open then
    begin
      nProcID := 0;
      nProcMax := HumDataDB.m_MirQuickList.Count - 1;
      frmDBTool.ProgressBar.Max := nProcMax;
      for i := 0 to HumDataDB.m_MirQuickList.Count - 1 do
      begin
        nProcID := i;
        if (HumDataDB.Get(i, SrcHumanRCD) < 0) or (SrcHumanRCD.Data.sChrName = '') then
          Continue;
        if boDelDenyChr then
        begin
          FillChar(HumRecord, SizeOf(HumRecord), #0);
          nSrcHumIndex := HumChrDB.Index(SrcHumanRCD.Data.sChrName);
          if HumChrDB.GetBy(nSrcHumIndex, HumRecord) then
          begin
            if HumRecord.boDeleted then
              Continue;
          end;
        end;
        if boDelLevel then
        begin
          FillChar(SrcHumanRCD.Data.Abil, SizeOf(TOAbility), #0);
          SrcHumanRCD.Data.sCurMap := '3';
          SrcHumanRCD.Data.wCurX := 330;
          SrcHumanRCD.Data.wCurY := 330;
          SrcHumanRCD.Data.nGold := 0;
          SrcHumanRCD.Data.sHomeMap := '3';
          SrcHumanRCD.Data.wHomeX := 330;
          SrcHumanRCD.Data.wHomeY := 330;
          SrcHumanRCD.Data.btReLevel := 0;
          //FillChar(SrcHumanRCD.Data.sMasterName, SizeOf(SrcHumanRCD.Data.sMasterName), #0);
          SrcHumanRCD.Data.sMasterName := ''; //............
          SrcHumanRCD.Data.boMaster := False;
          //FillChar(SrcHumanRCD.Data.sDearName, SizeOf(SrcHumanRCD.Data.sDearName), #0);
          SrcHumanRCD.Data.sDearName := '';
          SrcHumanRCD.Data.btCreditPoint := 0;
          //SrcHumanRCD.Data.btMarryCount := 0;
          SrcHumanRCD.Data.sStoragePwd := '';
          SrcHumanRCD.Data.nGameGold := 0;
          SrcHumanRCD.Data.nPKPoint := 0;
        end;

        if boDelAllItem then
        begin
          FillChar(SrcHumanRCD.Data.HumItems, SizeOf(THumanUseItems), #0);
          FillChar(SrcHumanRCD.Data.BagItems, SizeOf(TBagItems), #0);
          FillChar(SrcHumanRCD.Data.StorageItems, SizeOf(TStorageItems), #0);
          //FillChar(SrcHumanRCD.Data.HumAddItems, SizeOf(THumAddItems), #0);
        end;

        if boDelAllSkill then
        begin
          FillChar(SrcHumanRCD.Data.Magic, SizeOf(THumMagic), #0);
        end;
        if boDelBonusAbil then
        begin
          FillChar(SrcHumanRCD.Data.BonusAbil, SizeOf(TNakedAbility), #0);
          SrcHumanRCD.Data.nBonusPoint := 0;
        end;

        NewDataDB.Lock;
        try
          if NewDataDB.Index(SrcHumanRCD.Data.sChrName) >= 0 then
            Continue;
        finally
          NewDataDB.UnLock;
        end;
        FillChar(HumRecord, SizeOf(THumInfo), #0);
        try
          if NewChrDB.Open then
          begin
            if NewChrDB.ChrCountOfAccount(SrcHumanRCD.Data.sChrName) < 2 then
            begin
              HumRecord.sChrName := SrcHumanRCD.Data.sChrName;
              HumRecord.sAccount := SrcHumanRCD.Data.sAccount;
              HumRecord.boDeleted := False;
              HumRecord.btCount := 0;
              HumRecord.Header.sName := SrcHumanRCD.Data.sChrName;
              NewChrDB.Add(HumRecord);
            end;
          end;
        finally
          NewChrDB.Close;
        end;

        try
          if NewDataDB.Open and (NewDataDB.Index(SrcHumanRCD.Data.sChrName) = -1) then
          begin
            NewDataDB.Add(SrcHumanRCD);
          end;
        finally
          NewDataDB.Close;
        end;
      end;
    end;
  finally
    HumDataDB.Close;
    HumChrDB.Close;
  end;
  NewChrDB.Free;
  NewDataDB.Free;
  boRebuilding := False;
  frmDBTool.ButtonStartRebuild.Enabled := True;
  boAutoClearDB := True;
end;
{
procedure TBuildDB.UpdateProcess;
begin
  if (GetTickCount - UpdateProcessTick > 1000) or (nProcID >= nProcMax) then begin
    UpdateProcessTick := GetTickCount();
    //frmDBTool.LabelProcess.Caption:=IntToStr(nProcID) + '/' + IntToStr(nProcMax);
  end;
end;
}

procedure TfrmDBTool.TimerShowInfoTimer(Sender: TObject);
begin
  ProgressBar.Position := nProcID;
  LabelProcess.Caption := format('当前处理索引:%d, 总数:%d', [nProcID, nProcMax]);
  LabelProcessPercent.Caption := IntToStr(nProcID * 100 div nProcMax) + '%';
  if not boRebuilding then
  begin
    TimerShowInfo.Enabled := False;
    MessageBox(0, '数据库重建完成，请到FDB目录重新命名重建后的DB数据库。', '提示信息', MB_OK);
  end;
end;

procedure TfrmDBTool.CheckBoxDelDenyChrClick(Sender: TObject);
begin
  boDelDenyChr := CheckBoxDelDenyChr.Checked;
end;

procedure TfrmDBTool.CheckBoxDelLevelClick(Sender: TObject);
begin
  boDelLevel := CheckBoxDelLevel.Checked;
end;

procedure TfrmDBTool.EditLevelMaxChange(Sender: TObject);
begin
  if EditLevelMin.Value > EditLevelMax.Value then
    EditLevelMax.Value := EditLevelMin.Value;
end;

procedure TfrmDBTool.EditLevelMinChange(Sender: TObject);
begin
  if EditLevelMin.Value > EditLevelMax.Value then
    EditLevelMin.Value := EditLevelMax.Value;
end;

procedure TfrmDBTool.CheckBoxDelAllItemClick(Sender: TObject);
begin
  boDelAllItem := CheckBoxDelAllItem.Checked;
end;

procedure TfrmDBTool.CheckBoxDelAllSkillClick(Sender: TObject);
begin
  boDelAllSkill := CheckBoxDelAllSkill.Checked;
end;

procedure TfrmDBTool.CheckBoxDelBonusAbilClick(Sender: TObject);
begin
  boDelBonusAbil := CheckBoxDelBonusAbil.Checked;
end;

end.
