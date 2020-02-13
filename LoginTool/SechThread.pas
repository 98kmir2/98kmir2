unit SechThread;

interface

uses
  Classes, Windows, SysUtils, Registry;

type
  TMainOutProcList = procedure(const smsg: string) of object;

  TSechThread = class(TThread)
    //FSearchFile: Integer;
  private
    m_sCurMessage: string;
    sDrivers: TStringList;
    //sDrivers2: TStringList;
    procedure OutMessage;
  protected
    function IsMirDir(APath: string): Boolean;
    function FindFiles(APath: string): Boolean;
    function FindFiles2(APath: string): Boolean;
    procedure Execute; override;
  public
    constructor Create(const DiskList: TStringList);
    destructor Destroy; override;
  end;

var
  MainOutInforProc: TMainOutProcList;

implementation

uses
  LMain, HUtil32, LShare;

constructor TSechThread.Create(const DiskList: TStringList);
begin
  //FSearchFile := 0;
  sDrivers := TStringList.Create;
  //sDrivers2 := TStringList.Create;
  sDrivers.Text := DiskList.Text;
  //sDrivers2.Text := DiskList.Text;
  inherited Create(False);
end;

destructor TSechThread.Destroy();
begin
  inherited;
  sDrivers.Free;
  //sDrivers2.Free;
end;

const
  SEARCHFILE: array[0..1] of string = ('Data\cboweapon.wzl', 'Data\cboweapon.wis');

procedure TSechThread.OutMessage;
begin
  if Assigned(MainOutInforProc) then
    MainOutInforProc(m_sCurMessage);
end;

function TSechThread.IsMirDir(APath: string): Boolean;
begin
  Result := False;
  if DirectoryExists(Format('%s%s', [APath, 'Data'])) and
    DirectoryExists(Format('%s%s', [APath, 'map'])) and
    DirectoryExists(Format('%s%s', [APath, 'wav'])) and
    (FileExists(Format('%s%s', [APath, SEARCHFILE[0]])) or FileExists(Format('%s%s', [APath, SEARCHFILE[1]]))) then
    Result := True;
end;

function TSechThread.FindFiles2(APath: string): Boolean;

  function IsDirNotation(ADirName: string): Boolean;
  begin
    Result := ((ADirName = '.') or (ADirName = '..'));
  end;

var
  r, FindResult: Integer;
  FSearchRec, DSearchRec: TSearchRec;
  RegIniFile: TRegIniFile;
begin
  Result := False;
  m_sCurMessage := APath;
  Synchronize(OutMessage);

  if APath[Length(APath)] <> '\' then
    APath := APath + '\';

  if IsMirDir(APath) then begin
    //123456
    if MessageBox(FrmMain.Handle, PChar('����Ŀ¼��' + string(APath) + ' ���ҵ���' + #13 + #13 + 'ȷ��ʹ�ô�Ŀ¼�� [��]��' + #13 + '������������Ŀ¼�� [��]'),
      '��Ϣ��ʾ', MB_ICONINFORMATION + MB_YESNO) = ID_YES then begin
      FrmMain.TimerFindDir.Enabled := False;
      g_sWorkDir := APath;
    //  OutputDebugString(PChar('11:' + g_sWorkDir));

      m_sCurMessage := '�ͻ���Ŀ¼���ҵ�����';
      Synchronize(OutMessage);

      //MessageBox(FrmMain.Handle, PChar('����Ŀ¼��' + string(g_sWorkDir) + ' ���ҵ�'), '��Ϣ��ʾ', MB_ICONINFORMATION + MB_OK);
      RegIniFile := TRegIniFile.Create('Software\BlueSoft');
      RegIniFile.WriteString('LoginTool', 'MirClientDir', g_sWorkDir);
      RegIniFile.Free;
      FrmMain.TimerUpgrate.Enabled := True;
      g_boSecFinded := True;
      Result := True;
      FreeOnTerminate := False;
      self.Terminate;
    end;
  end;

  if not Result then begin
    FindResult := FindFirst(APath + '*.*', faDirectory, DSearchRec); //���뵱ǰĿ¼����Ŀ¼��������
    while FindResult = 0 do begin
      if ((DSearchRec.Attr and faDirectory) = faDirectory) and not IsDirNotation(DSearchRec.Name) then begin
        sDrivers.Add(APath + DSearchRec.Name);
      end;
      FindResult := FindNext(DSearchRec);
    end;
    SysUtils.FindClose(DSearchRec);
  end;
end;

function TSechThread.FindFiles(APath: string): Boolean;
var
  r, FindResult: Integer;
  FSearchRec, DSearchRec: TSearchRec;
  RegIniFile: TRegIniFile;

  function IsDirNotation(ADirName: string): Boolean;
  begin
    Result := ((ADirName = '.') or (ADirName = '..'));
  end;
begin
  Result := False;
  if APath[Length(APath)] <> '\' then
    APath := APath + '\';

  if IsMirDir(APath) then begin
    //123456
    if MessageBox(FrmMain.Handle, PChar('����Ŀ¼��' + string(APath) + ' ���ҵ���' + #13 + #13 + 'ȷ��ʹ�ô�Ŀ¼�� [��]��' + #13 + '������������Ŀ¼�� [��]'),
      '��Ϣ��ʾ', MB_ICONINFORMATION + MB_YESNO) = ID_YES then begin
      FrmMain.TimerFindDir.Enabled := False;
      g_sWorkDir := APath;
    //  OutputDebugString(PChar('22:' + g_sWorkDir));

      m_sCurMessage := '�ͻ���Ŀ¼���ҵ�����';
      Synchronize(OutMessage);

      //MessageBox(FrmMain.Handle, PChar('����Ŀ¼��' + string(g_sWorkDir) + ' ���ҵ�'), '��Ϣ��ʾ', MB_ICONINFORMATION + MB_OK);
      RegIniFile := TRegIniFile.Create('Software\BlueSoft');
      RegIniFile.WriteString('LoginTool', 'MirClientDir', g_sWorkDir);
      RegIniFile.Free;
      FrmMain.TimerUpgrate.Enabled := True;
      g_boSecFinded := True;
      Result := True;
      FreeOnTerminate := False;
      self.Terminate;
    end;
  end;

  if not Result then begin
    FindResult := FindFirst(APath + '*.*', faDirectory, DSearchRec); //���뵱ǰĿ¼����Ŀ¼��������
    while FindResult = 0 do begin
      if ((DSearchRec.Attr and faDirectory) = faDirectory) and not IsDirNotation(DSearchRec.Name) then
        if FindFiles(APath + DSearchRec.Name) then
          Break;
      FindResult := FindNext(DSearchRec);
    end;
    SysUtils.FindClose(DSearchRec);
  end;
end;

procedure TSechThread.Execute;
var
  i: Integer;
begin
  g_boSecCheck := False;
  g_boSecFinded := False;
  FreeOnTerminate := False;
  //FSearchFile := 0;
  i := 0;
  while not Terminated do begin

    while True do begin
      if i >= sDrivers.Count then begin
        FreeOnTerminate := False;
        Terminate;
        Break;
      end;
      if FindFiles2(sDrivers.Strings[i]) then
        Break;
      Inc(i);
    end;
  end;
  g_boSecCheck := True;
end;

end.
