unit HumDB_SQL;

interface

uses
  Windows, Classes, SysUtils, Forms, MudUtil, Grobal2, ActiveX,
  DB, DBAccess, MSAccess, MemDS, MemData;

resourcestring
  sDBHeaderDesc             = '传奇数据库文件 2009/01/01';
  sDBIdxHeaderDesc          = '传奇数据库索引文件 2009/01/01';

type
  TDBHeader = packed record
    sDesc: string[$23];                 //0x00
    n24: Integer;                       //0x24
    n28: Integer;                       //0x28
    n2C: Integer;                       //0x2C
    n30: Integer;                       //0x30
    n34: Integer;                       //0x34
    n38: Integer;                       //0x38
    n3C: Integer;                       //0x3C
    n40: Integer;                       //0x40
    n44: Integer;                       //0x44
    n48: Integer;                       //0x48
    n4C: Integer;                       //0x4C
    n50: Integer;                       //0x50
    n54: Integer;                       //0x54
    n58: Integer;                       //0x58
    nLastIndex: Integer;                //0x5C
    dLastDate: TDateTime;               //0x60
    nHumCount: Integer;                 //0x68
    n6C: Integer;                       //0x6C
    n70: Integer;                       //0x70
    dUpdateDate: TDateTime;             //0x74
  end;
  pTDBHeader = ^TDBHeader;

  TIdxHeader = packed record
    sDesc: string[40];                  //0x00
    n2C: Integer;                       //0x2C
    n30: Integer;                       //0x30
    n34: Integer;                       //0x34
    n38: Integer;                       //0x38
    n3C: Integer;                       //0x3C
    n40: Integer;                       //0x40
    n44: Integer;                       //0x44
    n48: Integer;                       //0x48
    n4C: Integer;                       //0x4C
    n50: Integer;                       //0x50
    n54: Integer;                       //0x54
    n58: Integer;                       //0x58
    n5C: Integer;                       //0x5C
    n60: Integer;                       //0x60
    nQuickCount: Integer;               //0x64
    nHumCount: Integer;                 //0x68
    nDeleteCount: Integer;              //0x6C
    nLastIndex: Integer;                //0x70
    dUpdateDate: TDateTime;             //0x74
  end;

  pTHumInfo = ^THumInfo;
  TIdxRecord = record
    sChrName: string[15];
    nIndex: Integer;
  end;
  pTIdxRecord = ^TIdxRecord;

  {TFileHumDB = class
    m_OnChange: TNotifyEvent;
    m_boChanged: Boolean;               //0x18
    m_QuickList: TQuickList;            //0x98
    m_QuickIDList: TQuickIDList;        //0x9C
    m_nRecordCount: Integer;
  private
    procedure LoadQuickList;
    procedure Lock;
    procedure UnLock;
    function UpdateRecord(nIndex: Integer; HumRecord: THumInfo; boNew: Boolean): Boolean;
    function DeleteRecord(nIndex: Integer): Boolean;
    function GetRecord(nIndex: Integer; var HumDBRecord: THumInfo): Boolean;
  public
    constructor Create(sFileName: string);
    destructor Destroy; override;
    function Open(): Boolean;
    function OpenEx(): Boolean;
    procedure Close();
    function Index(sName: string): Integer;
    function Get(n08: Integer; var HumDBRecord: THumInfo): Integer;
    function GetBy(n08: Integer; var HumDBRecord: THumInfo): Boolean;
    function FindByName(sChrName: string; ChrList: TStringList): Integer;
    function FindByAccount(sAccount: string; var ChrList: TStringList): Integer;
    function ChrCountOfAccount(sAccount: string): Integer;
    function AllChrCountOfAccount(sAccount: string): Integer;
    function Add(HumRecord: THumInfo): Boolean;
    function Delete(sName: string): Boolean;
    function Update(nIndex: Integer; var HumDBRecord: THumInfo): Boolean;
    function UpdateBy(nIndex: Integer; var HumDBRecord: THumInfo): Boolean;
  end;}

  TFileDB = class
    m_OnChange: TNotifyEvent;           //0x10
    m_boChanged: Boolean;               //0x18
    m_MirQuickList: TQuickList;         //0xA4
    m_MirQuickIDList: TQuickList;
    m_nRecordCount: Integer;
  private
    procedure LoadQuickList;
    function GetRecord(nIndex: Integer; var HumanRCD: THumDataInfo): Boolean;
    function UpdateRecord(nIndex: Integer; var HumanRCD: THumDataInfo; boNew: Boolean): Boolean;
    function UpdateChrRecord(nIndex: Integer; var HumanRCD: TQueryChr; boNew: Boolean): Boolean;
    function DeleteRecord(nIndex: Integer): Boolean;
  public
    constructor Create(sFileName: string);
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    function Open(): Boolean;
    function OpenEx(): Boolean;
    procedure Close();
    function Index(sName: string): Integer;
    function Get(nIndex: Integer; var HumanRCD: THumDataInfo): Integer;
    function GetQryChar(nIndex: Integer; var QueryChrRcd: TQueryChr): Integer;

    function Update(nIndex: Integer; var HumanRCD: THumDataInfo): Boolean;
    function UpdateQryChar(nIndex: Integer; var QueryChrRcd: TQueryChr): Boolean;
    function Add(var HumanRCD: THumDataInfo): Boolean;
    function Find(sChrName: string; List: TStrings): Integer;
    procedure Rebuild();
    function Count(): Integer;
    function Delete(sChrName: string): Boolean; overload;
    function Delete(nIndex: Integer): Boolean; overload;
  end;

{$IFDEF SQLDB}
function InitializeSQL(): Boolean;
{$ENDIF}

var
{$IFDEF SQLDB}
  ADOConnection             : TMSConnection;
  dbQry                     : TMSQuery;
  g_boSQLIsReady            : Boolean = False;
  HumChrDB, HumDataDB       : TFileDB;
{$ELSE}
  HumChrDB                  : TFileHumDB;
  HumDataDB                 : TFileDB;  
{$ENDIF}

implementation

uses DBShare, HUtil32, EDcode;

{ TFileHumDB }

{$IFDEF SQLDB}

function InitializeSQL(): Boolean;
begin
  Result := False;
  if g_boSQLIsReady then Exit;

  ADOConnection.Database := g_sSQLDatabase;
  ADOConnection.Server := g_sSQLHost;
  ADOConnection.UserName := g_sSQLUserName;
  ADOConnection.Password := g_sSQLPassword;

  ADOConnection.LoginPrompt := False;

  dbQry.Connection := ADOConnection;

  try
    ADOConnection.Connect;
    g_boSQLIsReady := True;
  except
    MainOutMessage('SQL连接失败！');
    g_boSQLIsReady := False;
    Result := False;
    Exit;
  end;

  Result := True;
end;
{$ENDIF}

(*constructor TFileHumDB.Create(sFileName: string); //0x0048B73C
begin
  m_QuickList := TQuickList.Create;
  m_QuickIDList := TQuickIDList.Create;
  n4ADAFC := 0;
  n4ADB04 := 0;
  boHumDBReady := False;
  m_nRecordCount := -1;
  if g_boSQLIsReady then
    LoadQuickList();
end;

destructor TFileHumDB.Destroy;
begin
  m_QuickList.Free;
  m_QuickIDList.Free;
  inherited;
end;

procedure TFileHumDB.Lock();            //0x0048B870
begin
  EnterCriticalSection(HumDB_CS);
end;

procedure TFileHumDB.UnLock();          //0x0048B888
begin
  LeaveCriticalSection(HumDB_CS);
end;

procedure TFileHumDB.LoadQuickList();
var
  nIndex                    : Integer;
  AccountList               : TStringList;
  ChrNameList               : TStringList;
  boDeleted                 : Boolean;
  sAccount, sChrName        : string;
resourcestring
  sSQL                      = 'SELECT * FROM TBL_CHARACTER';
begin
  m_nRecordCount := -1;
  m_QuickList.Clear;
  m_QuickIDList.Clear;

  n4ADAFC := 0;
  n4ADB00 := 0;
  n4ADB04 := 0;
  AccountList := TStringList.Create;
  ChrNameList := TStringList.Create;
  Lock();
  try
    try
      dbQry.SQL.Clear;
      dbQry.SQL.Add(sSQL);
      try
        dbQry.Open;
      except
        MainOutMessage('[Exception] TFileIDDB.LoadQuickList');
      end;

      m_nRecordCount := dbQry.RecordCount;
      n4ADB04 := m_nRecordCount;
      for nIndex := 0 to m_nRecordCount - 1 do begin
        Inc(n4ADAFC);

        boDeleted := dbQry.FieldByName('FLD_DELETED').AsBoolean;
        sAccount := Trim(dbQry.FieldByName('FLD_LOGINID').AsString);
        sChrName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);

        if not boDeleted then begin
          m_QuickList.AddObject(sChrName, TObject(nIndex));
          AccountList.AddObject(sAccount, TObject(nIndex));
          ChrNameList.AddObject(sChrName, TObject(nIndex));
          Inc(n4ADB00);
        end;

        dbQry.Next;
      end;
    finally
      dbQry.Close;
    end;
  finally
    Close();
  end;
  for nIndex := 0 to AccountList.Count - 1 do begin
    m_QuickIDList.AddRecord(AccountList.Strings[nIndex], ChrNameList.Strings[nIndex], Integer(AccountList.Objects[nIndex]));
    if (nIndex mod 100) = 0 then
      Application.ProcessMessages;
  end;
  AccountList.Free;
  ChrNameList.Free;
  m_QuickList.SortString(0, m_QuickList.Count - 1);
  boHumDBReady := True;
end;

function TFileHumDB.Open: Boolean;
begin
  Result := False;
  Lock();
  m_boChanged := False;
  Result := True
end;

function TFileHumDB.OpenEx: Boolean;
begin
  Result := Open;
end;

procedure TFileHumDB.Close;
begin
  if m_boChanged and Assigned(m_OnChange) then
    m_OnChange(Self);
  UnLock();
end;

function TFileHumDB.Index(sName: string): Integer;
begin
  Result := m_QuickList.GetIndex(sName);
end;

function TFileHumDB.Get(n08: Integer; var HumDBRecord: THumInfo): Integer;
{var
  nIndex                    : Integer;
begin
  nIndex := Integer(m_QuickList.Objects[n08]);
  if GetRecord(nIndex, HumDBRecord) then
    Result := nIndex
  else
    Result := -1;}
begin
  Result := -1;
  if n08 < 0 then Exit;
  if m_QuickList.Count <= n08 then Exit;
  if GetRecord(n08, HumDBRecord) then Result := n08;
end;

function TFileHumDB.GetRecord(nIndex: Integer; var HumDBRecord: THumInfo): Boolean;
var
  sChrName                  : string;
resourcestring
  sSQL = 'SELECT * FROM TBL_CHARACTER WHERE FLD_CHARNAME=''%s''';
begin
  Result := True;
  sChrName := m_QuickList[nIndex];
  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[Exception] TFileDB.GetRecord (1)');
      Exit;
    end;
    if dbQry.RecordCount > 0 then begin
      HumDBRecord.Header.boDeleted := dbQry.FieldByName('FLD_DELETED').AsBoolean;
      HumDBRecord.Header.dCreateDate := dbQry.FieldByName('FLD_CREATEDATE').AsDateTime;
      HumDBRecord.Header.sName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);
      HumDBRecord.sChrName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);
      HumDBRecord.boDeleted := dbQry.FieldByName('FLD_DELETED').AsBoolean;
      HumDBRecord.boSelected := dbQry.FieldByName('FLD_SELETED').AsBoolean;
      HumDBRecord.dModDate := dbQry.FieldByName('FLD_LASTUPDATE').AsDateTime;
    end;
  finally
    dbQry.Close;
  end;
end;

function TFileHumDB.FindByName(sChrName: string; ChrList: TStringList): Integer;
var
  i                         : Integer;
begin
  for i := 0 to m_QuickList.Count - 1 do begin
    if CompareLStr(m_QuickList.Strings[i], sChrName, Length(sChrName)) then begin
      ChrList.AddObject(m_QuickList.Strings[i], m_QuickList.Objects[i]);
    end;
  end;
  Result := ChrList.Count;
end;

function TFileHumDB.GetBy(n08: Integer; var HumDBRecord: THumInfo): Boolean;
begin
  if n08 >= 0 then
    Result := GetRecord(n08, HumDBRecord)
  else
    Result := False;
end;

function TFileHumDB.FindByAccount(sAccount: string; var ChrList: TStringList): Integer;
var
  ChrNameList               : TList;
  QuickID                   : pTQuickID;
  i                         : Integer;
begin
  ChrNameList := nil;
  m_QuickIDList.GetChrList(sAccount, ChrNameList);
  if ChrNameList <> nil then begin
    for i := 0 to ChrNameList.Count - 1 do begin
      QuickID := ChrNameList.Items[i];
      ChrList.AddObject(QuickID.sAccount, TObject(QuickID));
    end;
  end;
  Result := ChrList.Count;
end;

function TFileHumDB.ChrCountOfAccount(sAccount: string): Integer; //0x0048C5B0
var
  ChrList                   : TList;
  i, n18                    : Integer;
  HumDBRecord               : THumInfo;
begin
  n18 := 0;
  ChrList := nil;
  m_QuickIDList.GetChrList(sAccount, ChrList);
  if ChrList <> nil then begin
    for i := 0 to ChrList.Count - 1 do begin
      if GetBy(pTQuickID(ChrList.Items[i]).nIndex, HumDBRecord) and not HumDBRecord.boDeleted then
        Inc(n18);
    end;
  end;
  Result := n18;
end;

function TFileHumDB.Add(HumRecord: THumInfo): Boolean; //0x0048C1F4
var
  nIndex                    : Integer;
begin
  if m_QuickList.GetIndex(HumRecord.Header.sName) >= 0 then
    Result := False
  else begin
    nIndex := m_nRecordCount;
    Inc(m_nRecordCount);
    if UpdateRecord(nIndex, HumRecord, True) then begin
      m_QuickList.AddRecord(HumRecord.Header.sName, nIndex);
      m_QuickIDList.AddRecord(HumRecord.sAccount, HumRecord.sChrName, nIndex);
      Result := True;
    end
    else begin
      Result := False;
    end;
  end;
end;

function TFileHumDB.UpdateRecord(nIndex: Integer; HumRecord: THumInfo; boNew: Boolean): Boolean;
var
  HumRcd                    : THumInfo;
  nPosion, n10              : Integer;
begin
  nPosion := nIndex * SizeOf(THumInfo) + SizeOf(TDBHeader);
  if FileSeek(m_nFileHandle, nPosion, 0) = nPosion then begin
    n10 := FileSeek(m_nFileHandle, 0, 1);
    if boNew and
      (FileRead(m_nFileHandle, HumRcd, SizeOf(THumInfo)) = SizeOf(THumInfo)) and
      (not HumRcd.Header.boDeleted) and (HumRcd.Header.sName <> '') then
      Result := True
    else begin
      HumRecord.Header.boDeleted := False;
      HumRecord.Header.dCreateDate := Now();
      m_Header.dUpdateDate := Now();
      FileSeek(m_nFileHandle, 0, 0);
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
      FileSeek(m_nFileHandle, n10, 0);
      FileWrite(m_nFileHandle, HumRecord, SizeOf(THumInfo));
      FileSeek(m_nFileHandle, -SizeOf(THumInfo), 1);
      m_boChanged := True;
      Result := True;
    end;
  end else
    Result := False;
end;

function TFileHumDB.Delete(sName: string): Boolean; //0x0048BDE0
var
  n10                       : Integer;
  HumRecord                 : THumInfo;
  ChrNameList               : TList;
  n14                       : Integer;
begin
  Result := False;
  n10 := m_QuickList.GetIndex(sName);
  if n10 < 0 then
    Exit;
  Get(n10, HumRecord);
  if DeleteRecord(Integer(m_QuickList.Objects[n10])) then begin
    m_QuickList.Delete(n10);
    Result := True;
  end;
  n14 := m_QuickIDList.GetChrList(HumRecord.sAccount, ChrNameList);
  if n14 >= 0 then begin
    m_QuickIDList.DelRecord(n14, HumRecord.sChrName);
  end;

end;

function TFileHumDB.DeleteRecord(nIndex: Integer): Boolean; //0x0048BD58
var
  HumRcdHeader              : TRecordHeader;
begin
  Result := False;
  if FileSeek(m_nFileHandle, nIndex * SizeOf(THumInfo) + SizeOf(TDBHeader), 0) = -1 then
    Exit;
  HumRcdHeader.boDeleted := True;
  HumRcdHeader.dCreateDate := Now();
  FileWrite(m_nFileHandle, HumRcdHeader, SizeOf(TRecordHeader));
  m_DeletedList.Add(Pointer(nIndex));
  m_boChanged := True;
  Result := True;
end;

function TFileHumDB.Update(nIndex: Integer; var HumDBRecord: THumInfo): Boolean; //0x0048C14C
begin
  Result := False;
  if nIndex < 0 then
    Exit;
  if m_QuickList.Count <= nIndex then
    Exit;
  if UpdateRecord(Integer(m_QuickList.Objects[nIndex]), HumDBRecord, False) then
    Result := True;
end;

function TFileHumDB.UpdateBy(nIndex: Integer; var HumDBRecord: THumInfo):
  Boolean;                              //00048C1B4
begin
  Result := False;
  if UpdateRecord(nIndex, HumDBRecord, False) then
    Result := True;
end;

function TFileHumDB.AllChrCountOfAccount(sAccount: string): Integer;
var
  ChrList                   : TList;
  i, n18                    : Integer;
  HumDBRecord               : THumInfo;
begin
  n18 := 0;
  ChrList := nil;
  m_QuickIDList.GetChrList(sAccount, ChrList);
  if ChrList <> nil then begin
    for i := 0 to ChrList.Count - 1 do begin
      if GetBy(pTQuickID(ChrList.Items[i]).nIndex, HumDBRecord) then
        Inc(n18);
    end;
  end;
  Result := n18;
end;*)

{ TFileDB }

constructor TFileDB.Create(sFileName: string); //0x0048A0F4
begin
  boDataDBReady := False;
  m_MirQuickList := TQuickList.Create;
  m_MirQuickIDList  := TQuickList.Create;
  n4ADAE4 := 0;
  n4ADAF0 := 0;
  m_nRecordCount := -1;

  if g_boSQLIsReady then
    LoadQuickList();
end;

destructor TFileDB.Destroy;
begin
  m_MirQuickList.Free;
  m_MirQuickIDList.Free;
  inherited;
end;

procedure TFileDB.LoadQuickList;
var
  nIndex                    : Integer;
  boDeleted                 : Boolean;
  AccountList               : TStringList;
  ChrNameList               : TStringList;
  sAccount, sChrName        : string;
resourcestring
  sSQL                      = 'SELECT * FROM TBL_CHARACTER';
begin
  m_MirQuickList.Clear;
  m_MirQuickIDList.Clear;
  n4ADAE4 := 0;
  n4ADAE8 := 0;
  n4ADAF0 := 0;
  m_nRecordCount := -1;
  
  AccountList := TStringList.Create;
  ChrNameList := TStringList.Create;

  Lock;
  try
    try
      dbQry.SQL.Clear;
      dbQry.SQL.Add(sSQL);
      try
        dbQry.Open;
      except
        MainOutMessage('[Exception] TFileDB.LoadQuickList');
      end;

      m_nRecordCount := dbQry.RecordCount;
      n4ADAF0 := m_nRecordCount;
      for nIndex := 0 to m_nRecordCount - 1 do begin
        Inc(n4ADAE4);

        boDeleted := dbQry.FieldByName('FLD_DELETED').AsBoolean;
        sAccount := Trim(dbQry.FieldByName('FLD_LOGINID').AsString);
        sChrName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);

        if (not boDeleted) and (sChrName <> '') then begin
          m_MirQuickList.AddObject(sChrName, TObject(nIndex));
          AccountList.AddObject(sAccount, TObject(nIndex));
          ChrNameList.AddObject(sChrName, TObject(nIndex));
          Inc(n4ADAE8);
        end else begin
          Inc(n4ADAEC);
        end;

        dbQry.Next;
      end;
    finally
      dbQry.Close;
    end;
  finally
    Close();
  end;

  for nIndex := 0 to AccountList.Count - 1 do begin
    m_MirQuickIDList.AddRecord(AccountList.Strings[nIndex], ChrNameList.Strings[nIndex], Integer(AccountList.Objects[nIndex]));
    if (nIndex mod 100) = 0 then
      Application.ProcessMessages;
  end;
  
  AccountList.Free;
  ChrNameList.Free;
  m_MirQuickList.SortString(0, m_MirQuickList.Count - 1);
  boDataDBReady := True;
end;

procedure TFileDB.Lock;
begin
  EnterCriticalSection(HumDB_CS);
end;

procedure TFileDB.UnLock;
begin
  LeaveCriticalSection(HumDB_CS);
end;

function TFileDB.Open: Boolean;
begin
  Result := False;
  Lock();
  m_boChanged := False;
  Result := True
end;

procedure TFileDB.Close;
begin
  if m_boChanged and Assigned(m_OnChange) then
    m_OnChange(Self);
  UnLock();
end;

function TFileDB.OpenEx: Boolean;
begin
  Result := Open();
end;

function TFileDB.Index(sName: string): Integer;
begin
  Result := m_MirQuickList.GetIndex(sName);
end;

function TFileDB.Get(nIndex: Integer; var HumanRCD: THumDataInfo): Integer; //0x0048B320
var
  nIdx                      : Integer;
begin
  Result := -1;
  if nIndex < 0 then Exit;
  if m_MirQuickList.Count <= nIndex then Exit;
  if GetRecord(nIndex, HumanRCD) then Result := nIndex;
end;

function TFileDB.Update(nIndex: Integer; var HumanRCD: THumDataInfo): Boolean; //0x0048B36C
begin
  Result := False;
  if (nIndex >= 0) and (m_MirQuickList.Count > nIndex) then
    if UpdateRecord(nIndex, HumanRCD, False) then
      Result := True;
end;

function TFileDB.UpdateQryChar(nIndex: Integer; var QueryChrRcd: TQueryChr): Boolean;
begin
  Result := False;
  if (nIndex >= 0) and (m_MirQuickList.Count > nIndex) then
    if UpdateChrRecord(nIndex, QueryChrRcd, False) then
      Result := True;
end;

function TFileDB.UpdateChrRecord(nIndex: Integer; var QueryChrRcd: TQueryChr; boNew: Boolean): Boolean;
begin
  Result := True;
  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(format('UPDATE TBL_CHARACTER SET FLD_SEX=%d, FLD_JOB=%d WHERE FLD_CHARNAME=''%s''',
      [QueryChrRcd.btSex, QueryChrRcd.btJob, QueryChrRcd.sName]));
    try
      dbQry.Execute;
    except
      Result := False;
      MainOutMessage('[Exception] TFileDB.UpdateRecord (1)');
      Exit;
    end;

    m_boChanged := True;
  finally
    dbQry.Close;
  end;
end;

function TFileDB.Add(var HumanRCD: THumDataInfo): Boolean; //0x0048B3E0
var
  sChrName                  : string;
  nIndex                    : Integer;
begin
  sChrName := HumanRCD.Header.sName;
  if m_MirQuickList.GetIndex(sChrName) >= 0 then begin
    Result := False;
  end else begin
    nIndex := m_nRecordCount;
    Inc(m_nRecordCount);

    if UpdateRecord(nIndex, HumanRCD, True) then begin
      m_MirQuickList.AddRecord(sChrName, nIndex);
      Result := True;
    end else begin
      Result := False;
    end;
  end;
end;

function TFileDB.GetRecord(nIndex: Integer; var HumanRCD: THumDataInfo): Boolean; //0x0048B0C8
var
  sChrName                  : string;
  sTmp                      : string;
  str                       : string;
  i, ii                     : Integer;
  nCount                    : Integer;
  nPosition                 : Integer;
  Blob                      : TBlob;
  dw                        : DWord;
resourcestring
  sSQL1                     = 'SELECT * FROM TBL_CHARACTER WHERE FLD_CHARNAME=''%s''';
  sSQL2                     = 'SELECT * FROM TBL_BONUSABILITY WHERE FLD_CHARNAME=''%s''';
  sSQL3                     = 'SELECT * FROM TBL_QUEST WHERE FLD_CHARNAME=''%s''';
  sSQL4                     = 'SELECT * FROM TBL_MAGIC WHERE FLD_CHARNAME=''%s''';
  sSQL5                     = 'SELECT * FROM TBL_ITEM WHERE FLD_CHARNAME=''%s''';
  sSQL6                     = 'SELECT * FROM TBL_STORAGE WHERE FLD_CHARNAME=''%s''';
  sSQL7                     = 'SELECT * FROM TBL_ADDON WHERE FLD_CHARNAME=''%s''';
begin
  Result := True;
  sChrName := m_MirQuickList[nIndex];

  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL1, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[Exception] TFileDB.GetRecord (1)');
      Exit;
    end;
    if dbQry.RecordCount > 0 then begin
      HumanRCD.Header.sName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);
      HumanRCD.Header.boDeleted := dbQry.FieldByName('FLD_DELETED').AsBoolean;
      HumanRCD.Header.dCreateDate := dbQry.FieldByName('FLD_CREATEDATE').AsDateTime;

      HumanRCD.Data.sChrName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);
      HumanRCD.Data.sCurMap := Trim(dbQry.FieldByName('FLD_MAPNAME').AsString);
      HumanRCD.Data.wCurX := dbQry.FieldByName('FLD_CX').AsInteger;
      HumanRCD.Data.wCurY := dbQry.FieldByName('FLD_CY').AsInteger;
      HumanRCD.Data.btDir := dbQry.FieldByName('FLD_DIR').AsInteger;
      HumanRCD.Data.btHair := dbQry.FieldByName('FLD_HAIR').AsInteger;
      HumanRCD.Data.btSex := dbQry.FieldByName('FLD_SEX').AsInteger;
      HumanRCD.Data.btJob := dbQry.FieldByName('FLD_JOB').AsInteger;
      HumanRCD.Data.nGold := dbQry.FieldByName('FLD_GOLD').AsInteger;

      //TAbility
      HumanRCD.Data.Abil.Level := dbQry.FieldByName('FLD_LEVEL').AsInteger;
      dw := DWord(dbQry.FieldByName('FLD_HP').AsInteger);
      HumanRCD.Data.Abil.HP := LoWord(dw);
      HumanRCD.Data.Abil.AC := HiWord(dw);
      dw := DWord(dbQry.FieldByName('FLD_MP').AsInteger);
      HumanRCD.Data.Abil.MP := LoWord(dw);
      HumanRCD.Data.Abil.MAC := HiWord(dw);
      HumanRCD.Data.Abil.Exp := dbQry.FieldByName('FLD_EXP').AsInteger;
      HumanRCD.Data.sHomeMap := Trim(dbQry.FieldByName('FLD_HOMEMAP').AsString);
      HumanRCD.Data.wHomeX := dbQry.FieldByName('FLD_HOMECX').AsInteger;
      HumanRCD.Data.wHomeY := dbQry.FieldByName('FLD_HOMECY').AsInteger;
      HumanRCD.Data.sDearName := Trim(dbQry.FieldByName('FLD_DEARCHARNAME').AsString);
      HumanRCD.Data.sMasterName := Trim(dbQry.FieldByName('FLD_MASTERCHARNAME').AsString);
      HumanRCD.Data.boMaster := dbQry.FieldByName('FLD_MASTER').AsBoolean;
      HumanRCD.Data.btCreditPoint := dbQry.FieldByName('FLD_CREDITPOINT').AsInteger;
      HumanRCD.Data.btInPowerLevel := dbQry.FieldByName('FLD_IPLEVEL').AsInteger; //word
      HumanRCD.Data.sStoragePwd := Trim(dbQry.FieldByName('FLD_STORAGEPASSWD').AsString);
      HumanRCD.Data.btReLevel := dbQry.FieldByName('FLD_REBIRTHLEVEL').AsInteger;
      HumanRCD.Data.boLockLogon := dbQry.FieldByName('FLD_LOCKLOGON').AsBoolean;
      HumanRCD.Data.wInPowerPoint := dbQry.FieldByName('FLD_IPPOINT').AsInteger; //word
      //TNakedAbility
      HumanRCD.Data.nBonusPoint := dbQry.FieldByName('FLD_BONUSPOINT').AsInteger;
      HumanRCD.Data.nGameGold := dbQry.FieldByName('FLD_GAMEGOLD').AsInteger;
      HumanRCD.Data.nGamePoint := dbQry.FieldByName('FLD_GAMEPOINT').AsInteger;
      HumanRCD.Data.nPayMentPoint := dbQry.FieldByName('FLD_PAYPOINT').AsInteger;
      HumanRCD.Data.nHungerStatus := dbQry.FieldByName('FLD_HUNGRYSTATE').AsInteger;
      HumanRCD.Data.nPKPoint := dbQry.FieldByName('FLD_PKPOINT').AsInteger;
      HumanRCD.Data.btAllowGroup := Byte(dbQry.FieldByName('FLD_ALLOWPARTY').AsBoolean);
      HumanRCD.Data.btClPkPoint := dbQry.FieldByName('FLD_FREEGULITYCOUNT').AsInteger;
      HumanRCD.Data.btAttatckMode := dbQry.FieldByName('FLD_ATTACKMODE').AsInteger;
      HumanRCD.Data.btIncHealth := dbQry.FieldByName('FLD_INCHEALTH').AsInteger;
      HumanRCD.Data.btIncSpell := dbQry.FieldByName('FLD_INCSPELL').AsInteger;
      HumanRCD.Data.btIncHealing := dbQry.FieldByName('FLD_INCHEALING').AsInteger;
      HumanRCD.Data.btFightZoneDieCount := dbQry.FieldByName('FLD_FIGHTZONEDIE').AsInteger;
      HumanRCD.Data.sAccount := Trim(dbQry.FieldByName('FLD_LOGINID').AsString);
      HumanRCD.Data.btNewHuman := dbQry.FieldByName('FLD_TESTSERVERRESETCOUNT').AsInteger;
      HumanRCD.Data.dwInPowerExp := dbQry.FieldByName('FLD_IPEXP').AsInteger;
      HumanRCD.Data.dwGatherNimbus := dbQry.FieldByName('FLD_NIMBUSPOINT').AsInteger;
      HumanRCD.Data.btAttribute := dbQry.FieldByName('FLD_NATUREELEMENT').AsInteger;
      HumanRCD.Data.boAllowGuildRecall := dbQry.FieldByName('FLD_ENABLEGRECALL').AsBoolean;
      HumanRCD.Data.boAllowGroupRecall := dbQry.FieldByName('FLD_ENABLEGROUPRECALL').AsBoolean;
      HumanRCD.Data.nKillMonExpRate := dbQry.FieldByName('FLD_GAINEXPRATE').AsInteger;
      HumanRCD.Data.dwKillMonExpRateTime := dbQry.FieldByName('FLD_GAINEXPRATETIME').AsInteger;
      HumanRCD.Data.sHeroName := Trim(dbQry.FieldByName('FLD_HERONAME').AsString);
      HumanRCD.Data.sHeroMasterName := Trim(dbQry.FieldByName('FLD_HEROMASTERNAME').AsString);
      HumanRCD.Data.btOptnYBDeal := dbQry.FieldByName('FLD_OPENGAMEGOLDDEAL').AsInteger;
      HumanRCD.Data.wGroupRcallTime := dbQry.FieldByName('FLD_GROUPRECALLTIME').AsInteger;
      HumanRCD.Data.dBodyLuck := dbQry.FieldByName('FLD_BODYLUCK').AsFloat;

      HumanRCD.Data.sMarkerMap := Trim(dbQry.FieldByName('FLD_MARKMAP').AsString);
      HumanRCD.Data.wMarkerX := dbQry.FieldByName('FLD_MARKMAPX').AsInteger;
      HumanRCD.Data.wMarkerY := dbQry.FieldByName('FLD_MARKMAPY').AsInteger;
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL2, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[Exception] TFileDB.GetRecord (2)');
      Exit;
    end;
    if dbQry.RecordCount > 0 then begin
      HumanRCD.Data.BonusAbil.AC := dbQry.FieldByName('FLD_AC').AsInteger;
      HumanRCD.Data.BonusAbil.MAC := dbQry.FieldByName('FLD_MAC').AsInteger;
      HumanRCD.Data.BonusAbil.DC := dbQry.FieldByName('FLD_DC').AsInteger;
      HumanRCD.Data.BonusAbil.MC := dbQry.FieldByName('FLD_MC').AsInteger;
      HumanRCD.Data.BonusAbil.SC := dbQry.FieldByName('FLD_SC').AsInteger;
      HumanRCD.Data.BonusAbil.HP := dbQry.FieldByName('FLD_HP').AsInteger;
      HumanRCD.Data.BonusAbil.MP := dbQry.FieldByName('FLD_MP').AsInteger;
      HumanRCD.Data.BonusAbil.Hit := dbQry.FieldByName('FLD_HIT').AsInteger;
      HumanRCD.Data.BonusAbil.Speed := dbQry.FieldByName('FLD_SPEED').AsInteger;
      HumanRCD.Data.BonusAbil.X2 := dbQry.FieldByName('FLD_RESERVED').AsInteger;
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL3, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[Exception] TFileDB.GetRecord (3)');
      Exit;
    end;
    if dbQry.RecordCount > 0 then begin
      sTmp := Trim(dbQry.FieldByName('FLD_QUESTOPENINDEX').AsString);
      if sTmp <> '' then
        Decode6BitBuf(PChar(sTmp), @HumanRCD.Data.QuestUnitOpen, Length(sTmp), SizeOf(HumanRCD.Data.QuestUnitOpen));

      sTmp := dbQry.FieldByName('FLD_QUESTFININDEX').AsString;
      if sTmp <> '' then
        Decode6BitBuf(PChar(sTmp), @HumanRCD.Data.QuestUnit, Length(sTmp), SizeOf(HumanRCD.Data.QuestUnit));

      sTmp := dbQry.FieldByName('FLD_QUEST').AsString;
      if sTmp <> '' then
        Decode6BitBuf(PChar(sTmp), @HumanRCD.Data.QuestFlag, Length(sTmp), SizeOf(HumanRCD.Data.QuestFlag));
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL4, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[Exception] TFileDB.GetRecord (4)');
      Exit;
    end;
    nCount := dbQry.RecordCount - 1;
    if nCount > High(THumMagic) then nCount := High(THumMagic);
    for i := 0 to nCount do begin
      HumanRCD.Data.Magic[i].wMagIdx := dbQry.FieldByName('FLD_MAGICID').AsInteger;
      HumanRCD.Data.Magic[i].btClass := dbQry.FieldByName('FLD_TYPE').AsInteger;
      HumanRCD.Data.Magic[i].btLevel := dbQry.FieldByName('FLD_LEVEL').AsInteger;
      HumanRCD.Data.Magic[i].btKey := dbQry.FieldByName('FLD_USEKEY').AsInteger;
      HumanRCD.Data.Magic[i].nTranPoint := dbQry.FieldByName('FLD_CURRTRAIN').AsInteger;
      dbQry.Next;
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL5, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[Exception] TFileDB.GetRecord (5)');
      Exit;
    end;
    nCount := dbQry.RecordCount - 1;
    if nCount > High(TBagItems) + High(THumItems) then
      nCount := High(TBagItems) + High(THumItems);
    for i := 0 to nCount do begin
      nPosition := dbQry.FieldByName('FLD_POSITION').AsInteger - 1;

      if (nPosition >= 0) and (nPosition <= High(THumItems)) then begin
        HumanRCD.Data.HumItems[nPosition].MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
        HumanRCD.Data.HumItems[nPosition].wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
        HumanRCD.Data.HumItems[nPosition].Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
        HumanRCD.Data.HumItems[nPosition].DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
        for ii := Low(HumanRCD.Data.HumItems[nPosition].btValue) to High(HumanRCD.Data.HumItems[nPosition].btValue) do
          HumanRCD.Data.HumItems[nPosition].btValue[ii] := dbQry.FieldByName(format('FLD_VALUE%d', [ii])).AsInteger;
      end else begin
        HumanRCD.Data.BagItems[i].MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
        HumanRCD.Data.BagItems[i].wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
        HumanRCD.Data.BagItems[i].Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
        HumanRCD.Data.BagItems[i].DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
        for ii := Low(HumanRCD.Data.HumItems[i].btValue) to High(HumanRCD.Data.HumItems[i].btValue) do
          HumanRCD.Data.HumItems[i].btValue[ii] := dbQry.FieldByName(format('FLD_VALUE%d', [ii])).AsInteger;
      end;
      dbQry.Next;
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL6, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[Exception] TFileDB.GetRecord (6)');
      Exit;
    end;
    nCount := dbQry.RecordCount - 1;
    if nCount > High(TStorageItems) then nCount := High(TStorageItems);
    for i := 0 to nCount do begin
      HumanRCD.Data.StorageItems[i].MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
      HumanRCD.Data.StorageItems[i].wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
      HumanRCD.Data.StorageItems[i].Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
      HumanRCD.Data.StorageItems[i].DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
      for ii := Low(HumanRCD.Data.StorageItems[i].btValue) to High(HumanRCD.Data.StorageItems[i].btValue) do
        HumanRCD.Data.StorageItems[i].btValue[ii] := dbQry.FieldByName(format('FLD_VALUE%d', [ii])).AsInteger;
      dbQry.Next;
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL7, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[Exception] TFileDB.GetRecord (7)');
      Exit;
    end;
    if dbQry.RecordCount > 0 then begin
      //TStatusTime;
      sTmp := dbQry.FieldByName('FLD_STATUS').AsString;
      i := Low(HumanRCD.Data.wStatusTimeArr);
      while sTmp <> '' do begin
        sTmp := GetValidStr3(sTmp, str, ['/']);
        HumanRCD.Data.wStatusTimeArr[i] := StrToInt(str);
        Inc(i);
        if i > High(HumanRCD.Data.wStatusTimeArr) then Break;
      end;

      //TSeriesSkillArr;
      sTmp := dbQry.FieldByName('FLD_SERIESSKILLORDER').AsString;
      i := Low(HumanRCD.Data.SeriesSkillArr);
      while sTmp <> '' do begin
        sTmp := GetValidStr3(sTmp, str, ['/']);
        HumanRCD.Data.SeriesSkillArr[i] := StrToInt(str);
        Inc(i);
        if i > High(HumanRCD.Data.SeriesSkillArr) then Break;
      end;

      sTmp := dbQry.FieldByName('FLD_MISSION').AsString;
      if sTmp <> '' then
        Decode6BitBuf(PChar(sTmp), @HumanRCD.Data.MissionFlag[0], Length(sTmp), SizeOf(HumanRCD.Data.MissionFlag));

      sTmp := dbQry.FieldByName('FLD_VENATION').AsString;
      if sTmp <> '' then
        Decode6BitBuf(PChar(sTmp), @HumanRCD.Data.VenationInfos, Length(sTmp), SizeOf(HumanRCD.Data.VenationInfos));
    end;

  finally
    dbQry.Close;
  end;
end;

function TFileDB.UpdateRecord(nIndex: Integer; var HumanRCD: THumDataInfo; boNew: Boolean): Boolean; //0x0048B134
var
  sdt                       : string;
  i                         : Integer;
  sTmp, sTmp2, sTmp3        : string;
  hd                        : pTHumData;
  m                         : TMemoryStream;
  dwHP, dwMP                : DWord;
  TempBuf                   : array[0..BUFFERSIZE - 1] of Char;
const
  sSqlStr                   = 'INSERT INTO TBL_CHARACTER ( FLD_CHARNAME, FLD_LOGINID, FLD_DELETED, FLD_CREATEDATE, FLD_MAPNAME,' +
    'FLD_CX, FLD_CY, FLD_DIR, FLD_HAIR, FLD_SEX, FLD_JOB, FLD_LEVEL, FLD_GOLD,' +
    'FLD_HOMEMAP, FLD_HOMECX, FLD_HOMECY, FLD_PKPOINT, FLD_ATTACKMODE, FLD_FIGHTZONEDIE,' +
    'FLD_BODYLUCK, FLD_INCHEALTH, FLD_INCSPELL, FLD_INCHEALING, FLD_BONUSPOINT,' +
    'FLD_HUNGRYSTATE, FLD_TESTSERVERRESETCOUNT, FLD_ENABLEGRECALL) VALUES' +
    '( ''%s'', ''%s'', 0, GETDATE(), '',' +
    '0, 0, 0, %d, %d, %d, 0, 0,' +
    ''', 0, 0, 0, 0, 0,' +
    '0, 0, 0, 0, 0,' +
    '0, 0, 0)';

  sSqlStr2                  = 'UPDATE TBL_CHARACTER SET FLD_DELETED=%d, FLD_CREATEDATE=''%s'', ' +
    'FLD_MAPNAME=''%s'', FLD_CX=%d, FLD_CY=%d, FLD_DIR=%d, FLD_HAIR=%d, FLD_SEX=%d, ' +
    'FLD_JOB=%d, FLD_GOLD=%d, FLD_LEVEL=%d, FLD_HP=%d, FLD_MP=%d, FLD_EXP=%d, ' +
    'FLD_HOMEMAP=''%s'', FLD_HOMECX=%d, FLD_HOMECY=%d, FLD_DEARCHARNAME=''%s'', ' +
    'FLD_MASTERCHARNAME=''%s'', FLD_MASTER=%d, FLD_CREDITPOINT=%d, FLD_IPLEVEL=%d, ' +
    'FLD_STORAGEPASSWD=''%s'', FLD_REBIRTHLEVEL=%d, FLD_LOCKLOGON=%d, FLD_IPPOINT=%d, ' +
    'FLD_BONUSPOINT=%d, FLD_GAMEGOLD=%d, FLD_GAMEPOINT=%d, FLD_PAYPOINT=%d, ' +
    'FLD_HUNGRYSTATE=%d, FLD_PKPOINT=%d, FLD_ALLOWPARTY=%d, FLD_FREEGULITYCOUNT=%d, ' +
    'FLD_ATTACKMODE=%d, FLD_INCHEALTH=%d, FLD_INCSPELL=%d, FLD_INCHEALING=%d, ' +
    'FLD_FIGHTZONEDIE=%d, FLD_TESTSERVERRESETCOUNT=%d, FLD_IPEXP=%d, ' +
    'FLD_NIMBUSPOINT=%d, FLD_NATUREELEMENT=%d, FLD_ENABLEGRECALL=%d, ' +
    'FLD_ENABLEGROUPRECALL=%d, FLD_GAINEXPRATE=%d, FLD_GAINEXPRATETIME=%d, ' +
    'FLD_HERONAME=''%s'', FLD_HEROMASTERNAME=''%s'', FLD_OPENGAMEGOLDDEAL=%d, ' +
    'FLD_GROUPRECALLTIME=%d, FLD_BODYLUCK=%f, FLD_MARKMAP=''%s'', ' +
    'FLD_MARKMAPX=%d, FLD_MARKMAPY=%d WHERE FLD_CHARNAME=''%s''';

  sSqlStr3                  = 'UPDATE TBL_BONUSABILITY SET ' +
    'FLD_AC=%d, FLD_MAC=%d, FLD_DC=%d, FLD_MC=%d, FLD_SC=%d, ' +
    'FLD_HP=%d, FLD_MP=%d, FLD_HIT=%d, FLD_SPEED=%d, FLD_RESERVED=%d, ' +
    'WHERE FLD_CHARNAME=''%s''';

  sSqlStr4                  = 'DELETE FROM TBL_QUEST WHERE FLD_CHARNAME=''%s''';

  sSqlStr5                  = 'INSERT INTO TBL_QUEST (FLD_CHARNAME, FLD_QUESTOPENINDEX, FLD_QUESTFININDEX, FLD_QUEST) ' +
    'VALUES(:FLD_CHARNAME, :FLD_QUESTOPENINDEX, :FLD_QUESTFININDEX, :FLD_QUEST)';

begin
  Result := True;
  sdt := FormatDateTime(SQLDTFORMAT, Now);

  try
    dbQry.SQL.Clear;
    hd := @HumanRCD.Data;
    if boNew then begin
      dbQry.SQL.Clear;
      dbQry.SQL.Add(format(sSqlStr, [hd.sChrName, hd.sAccount, hd.btHair, hd.btSex, hd.btJob]));
      try
        dbQry.Execute;
      except
        Result := False;
        MainOutMessage('[Exception] TFileDB.UpdateRecord (1)');
        Exit;
      end;
    end else begin
      dwHP := MakeLong(hd.Abil.HP, hd.Abil.AC);
      dwMP := MakeLong(hd.Abil.MP, hd.Abil.MAC);
      dbQry.SQL.Clear;
      dbQry.SQL.Add(format(sSqlStr2, [
        0, FormatDateTime(SQLDTFORMAT, HumanRCD.Header.dCreateDate),
          hd.sCurMap, hd.wCurX, hd.wCurY, hd.btDir, hd.btHair, hd.btSex,
          hd.btJob, hd.nGold, hd.Abil.Level, dwHP, dwMP, hd.Abil.Exp,
          hd.sHomeMap, hd.wHomeX, hd.wHomeY, hd.sDearName,
          hd.sMasterName, Byte(hd.boMaster), hd.btCreditPoint, hd.btInPowerLevel,
          hd.sStoragePwd, hd.btReLevel, Byte(hd.boLockLogon), hd.wInPowerPoint,
          hd.nBonusPoint, hd.nGameGold, hd.nGamePoint, hd.nPayMentPoint,
          hd.nHungerStatus, hd.nPKPoint, Byte(hd.btAllowGroup), hd.btClPkPoint,
          hd.btAttatckMode, hd.btIncHealth, hd.btIncSpell, hd.btIncHealing,
          hd.btFightZoneDieCount, hd.btNewHuman, hd.dwInPowerExp,
          hd.dwGatherNimbus, hd.btAttribute, Byte(hd.boAllowGuildRecall),
          hd.boAllowGroupRecall, hd.nKillMonExpRate, hd.dwKillMonExpRateTime,
          hd.sHeroName, hd.sHeroMasterName, hd.btOptnYBDeal,
          hd.wGroupRcallTime, hd.dBodyLuck, hd.sMarkerMap,
          hd.wMarkerX, hd.wMarkerY, HumanRCD.Header.sName
          ]));
      try
        dbQry.Execute;
      except
        Result := False;
        MainOutMessage('[Exception] TFileDB.UpdateRecord (2)');
        Exit;
      end;

      dbQry.SQL.Clear;
      dbQry.SQL.Add(format(sSqlStr3,
        [hd.BonusAbil.AC, hd.BonusAbil.MAC, hd.BonusAbil.DC, hd.BonusAbil.MC,
        hd.BonusAbil.SC, hd.BonusAbil.HP, hd.BonusAbil.MP, hd.BonusAbil.Hit,
          hd.BonusAbil.Speed, hd.BonusAbil.X2, HumanRCD.Header.sName]));
      try
        dbQry.Execute;
      except
        Result := False;
        MainOutMessage('[Exception] TFileDB.UpdateRecord (3)');
      end;

      // Delete Quest Data
      dbQry.SQL.Clear;
      dbQry.SQL.Add(format(sSqlStr4, [HumanRCD.Header.sName]));
      try
        dbQry.Execute;
      except
        Result := False;
        MainOutMessage('[Exception] TFileDB.UpdateRecord (DELETE TBL_QUEST)');
      end;

      try
        dbQry.SQL.Clear;
        dbQry.SQL.Text := sSqlStr5;
        dbQry.ParamByName('FLD_CHARNAME').Value := HumanRCD.Header.sName;
        Encode6BitBuf(@HumanRCD.Data.QuestUnitOpen, @TempBuf, SizeOf(HumanRCD.Data.QuestUnitOpen), SizeOf(TempBuf));
        dbQry.ParamByName('FLD_QUESTOPENINDEX').Value := StrPas(TempBuf);
        Encode6BitBuf(@HumanRCD.Data.QuestUnit, @TempBuf, SizeOf(HumanRCD.Data.QuestUnit), SizeOf(TempBuf));
        dbQry.ParamByName('FLD_QUESTFININDEX').Value := StrPas(TempBuf);
        Encode6BitBuf(@HumanRCD.Data.QuestFlag, @TempBuf, SizeOf(HumanRCD.Data.QuestFlag), SizeOf(TempBuf));
        dbQry.ParamByName('FLD_QUEST').Value := StrPas(TempBuf);
        dbQry.Execute;
      except
        Result := False;
        MainOutMessage('[Exception] TFileDB.UpdateRecord (INSERT TBL_QUEST)');
      end;

      // Delete Magic Data
      dbQry.SQL.Clear;
      dbQry.SQL.Add(format('DELETE FROM TBL_MAGIC WHERE FLD_CHARNAME=''%s''', [HumanRCD.Header.sName]));
      try
        dbQry.Execute;
      except
        Result := False;
        MainOutMessage('[Exception] TFileDB.UpdateRecord (DELETE TBL_MAGIC)');
      end;
      for i := 0 to High(hd.Magic) do begin
        if hd.Magic[i].wMagIdx > 0 then begin
          dbQry.SQL.Clear;
          dbQry.SQL.Add(format('INSERT TBL_MAGIC(FLD_CHARNAME, FLD_MAGICID, FLD_TYPE, FLD_LEVEL, FLD_USEKEY, FLD_CURRTRAIN) VALUES ' +
            '( ''%s'', %d, %d, %d, %d, %d )',
            [HumanRCD.Header.sName,
            hd.Magic[i].btClass, hd.Magic[i].wMagIdx, hd.Magic[i].btLevel, hd.Magic[i].btKey, hd.Magic[i].nTranPoint]));
          try
            dbQry.Execute;
          except
            Result := False;
            MainOutMessage('[Exception] TFileDB.UpdateRecord (INSERT TBL_MAGIC)');
          end;
        end;
      end;

      // Delete Item Data
      dbQry.SQL.Clear;
      dbQry.SQL.Add(format('DELETE FROM TBL_ITEM WHERE FLD_CHARNAME=''%s''', [HumanRCD.Header.sName]));
      try
        dbQry.Execute;
      except
        Result := False;
        MainOutMessage('[Exception] TFileDB.UpdateRecord (DELETE TBL_ITEM)');
      end;
      for i := 0 to High(hd.BagItems) do begin
        if (hd.BagItems[i].wIndex > 0) and (hd.BagItems[i].MakeIndex > 0) then begin
          dbQry.SQL.Clear;
          dbQry.SQL.Add(format('INSERT TBL_ITEM(FLD_CHARNAME, FLD_POSITION, ' +
            'FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, FLD_VALUE0, FLD_VALUE1, ' +
            'FLD_VALUE2, FLD_VALUE3, FLD_VALUE4, FLD_VALUE5, FLD_VALUE6, FLD_VALUE7, FLD_VALUE8, FLD_VALUE9, ' +
            'FLD_VALUE10, FLD_VALUE11, FLD_VALUE12, FLD_VALUE13, FLD_VALUE14, FLD_VALUE15, FLD_VALUE16, ' +
            'FLD_VALUE17, FLD_VALUE18, FLD_VALUE19, FLD_VALUE20, FLD_VALUE21, FLD_VALUE22, FLD_VALUE23, ' +
            'FLD_VALUE24, FLD_VALUE25) VALUES ' +
            '( ''%s'', 0, ' +
            '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, ' +
            '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d )',
            [HumanRCD.Header.sName, 0,
            hd.BagItems[i].MakeIndex, hd.BagItems[i].wIndex, hd.BagItems[i].Dura,
              hd.BagItems[i].DuraMax, hd.BagItems[i].btValue[0], hd.BagItems[i].btValue[1],
              hd.BagItems[i].btValue[2], hd.BagItems[i].btValue[3], hd.BagItems[i].btValue[4],
              hd.BagItems[i].btValue[5], hd.BagItems[i].btValue[6], hd.BagItems[i].btValue[7],
              hd.BagItems[i].btValue[8], hd.BagItems[i].btValue[9], hd.BagItems[i].btValue[10],
              hd.BagItems[i].btValue[11], hd.BagItems[i].btValue[12], hd.BagItems[i].btValue[13],
              hd.BagItems[i].btValue[14], hd.BagItems[i].btValue[15], hd.BagItems[i].btValue[16],
              hd.BagItems[i].btValue[17], hd.BagItems[i].btValue[18], hd.BagItems[i].btValue[19],
              hd.BagItems[i].btValue[20], hd.BagItems[i].btValue[21], hd.BagItems[i].btValue[22],
              hd.BagItems[i].btValue[23], hd.BagItems[i].btValue[24], hd.BagItems[i].btValue[25]]));

          try
            dbQry.Execute;
          except
            Result := False;
            MainOutMessage('[Exception] TFileDB.UpdateRecord (INSERT TBL_ITEM)');
          end;
        end;
      end;

      for i := 0 to High(hd.HumItems) do begin
        if (hd.HumItems[i].wIndex > 0) and (hd.HumItems[i].MakeIndex > 0) then begin
          dbQry.SQL.Clear;
          dbQry.SQL.Add(format('INSERT TBL_ITEM(FLD_CHARNAME, FLD_POSITION, FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, ' +
            'FLD_VALUE0, FLD_VALUE1, FLD_VALUE2, FLD_VALUE3, FLD_VALUE4, FLD_VALUE5, FLD_VALUE6, FLD_VALUE7, FLD_VALUE8, ' +
            'FLD_VALUE9, FLD_VALUE10, FLD_VALUE11, FLD_VALUE12, FLD_VALUE13, FLD_VALUE14, FLD_VALUE15, FLD_VALUE16, FLD_VALUE17, FLD_VALUE18, ' +
            'FLD_VALUE19, FLD_VALUE20, FLD_VALUE21, FLD_VALUE22, FLD_VALUE23, FLD_VALUE24, FLD_VALUE25) VALUES ' +
            '( ''%s'', %d, %d, %d, ' +
            '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, ' +
            '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, ' +
            '%d, %d, %d, %d, %d, %d, %d, %d )',
            [HumanRCD.Header.sName, i + 1,
            hd.HumItems[i].MakeIndex, hd.HumItems[i].wIndex, hd.HumItems[i].Dura, hd.HumItems[i].DuraMax,
              hd.HumItems[i].btValue[0], hd.HumItems[i].btValue[1], hd.HumItems[i].btValue[2],
              hd.HumItems[i].btValue[3], hd.HumItems[i].btValue[4], hd.HumItems[i].btValue[5],
              hd.HumItems[i].btValue[6], hd.HumItems[i].btValue[7], hd.HumItems[i].btValue[8],
              hd.HumItems[i].btValue[9], hd.HumItems[i].btValue[10], hd.HumItems[i].btValue[11],
              hd.HumItems[i].btValue[12], hd.HumItems[i].btValue[13], hd.HumItems[i].btValue[14],
              hd.HumItems[i].btValue[15], hd.HumItems[i].btValue[16], hd.HumItems[i].btValue[17],
              hd.HumItems[i].btValue[18], hd.HumItems[i].btValue[19], hd.HumItems[i].btValue[20],
              hd.HumItems[i].btValue[21], hd.HumItems[i].btValue[22], hd.HumItems[i].btValue[23],
              hd.HumItems[i].btValue[24], hd.HumItems[i].btValue[25]]));
          try
            dbQry.Execute;
          except
            Result := False;
            MainOutMessage('[Exception] TFileDB.UpdateRecord (13)');
          end;
        end;
      end;

      // Delete Store Item Data
      dbQry.SQL.Clear;
      dbQry.SQL.Add(format('DELETE FROM TBL_STORAGE WHERE FLD_CHARNAME=''%s''', [HumanRCD.Header.sName]));
      try
        dbQry.Execute;
      except
        Result := False;
        MainOutMessage('[Exception] TFileDB.UpdateRecord (10)');
      end;

      for i := 0 to High(hd.StorageItems) do begin
        if (hd.StorageItems[i].wIndex > 0) and (hd.StorageItems[i].MakeIndex > 0) then begin
          dbQry.SQL.Clear;
          dbQry.SQL.Add(format('INSERT TBL_STORAGE( FLD_CHARNAME, FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, ' +
            'FLD_VALUE0, FLD_VALUE1, FLD_VALUE2, FLD_VALUE3, FLD_VALUE4, FLD_VALUE5, FLD_VALUE6, FLD_VALUE7, FLD_VALUE8, ' +
            'FLD_VALUE9, FLD_VALUE10, FLD_VALUE11, FLD_VALUE12, FLD_VALUE13, FLD_VALUE14, FLD_VALUE15, FLD_VALUE16, FLD_VALUE17, FLD_VALUE18, ' +
            'FLD_VALUE19, FLD_VALUE20, FLD_VALUE21, FLD_VALUE22, FLD_VALUE23, FLD_VALUE24, FLD_VALUE25) VALUES ' +
            '( ''%s'', %d, %d, %d, ' +
            '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, ' +
            '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, ' +
            '%d, %d, %d, %d, %d, %d, %d, %d )',
            [HumanRCD.Header.sName,
            hd.StorageItems[i].MakeIndex, hd.StorageItems[i].wIndex, hd.StorageItems[i].Dura, hd.StorageItems[i].DuraMax,
              hd.StorageItems[i].btValue[0], hd.StorageItems[i].btValue[1], hd.StorageItems[i].btValue[2],
              hd.StorageItems[i].btValue[3], hd.StorageItems[i].btValue[4], hd.StorageItems[i].btValue[5],
              hd.StorageItems[i].btValue[6], hd.StorageItems[i].btValue[7], hd.StorageItems[i].btValue[8],
              hd.StorageItems[i].btValue[9], hd.StorageItems[i].btValue[10], hd.StorageItems[i].btValue[11],
              hd.StorageItems[i].btValue[12], hd.StorageItems[i].btValue[13]]));

          try
            dbQry.Execute;
          except
            Result := False;
            MainOutMessage('[Exception] TFileDB.UpdateRecord (11)');
          end;
        end;
      end;

      dbQry.SQL.Clear;
      dbQry.SQL.Add(format('DELETE FROM TBL_ADDON WHERE FLD_CHARNAME=''%s''', [HumanRCD.Header.sName]));
      try
        dbQry.Execute;
      except
        Result := False;
        MainOutMessage('[Exception] TFileDB.UpdateRecord (DELETE TBL_ADDON)');
      end;

      sTmp := '';
      for i := 0 to High(HumanRCD.Data.wStatusTimeArr) do
        sTmp := sTmp + IntToStr(HumanRCD.Data.wStatusTimeArr[i]) + '/';
      sTmp2 := '';
      for i := 0 to High(HumanRCD.Data.SeriesSkillArr) do
        sTmp2 := sTmp2 + IntToStr(HumanRCD.Data.SeriesSkillArr[i]) + '/';
      Encode6BitBuf(@HumanRCD.Data.MissionFlag[0], @TempBuf, SizeOf(HumanRCD.Data.MissionFlag), SizeOf(TempBuf));
      sTmp3 := StrPas(TempBuf);
      Encode6BitBuf(@HumanRCD.Data.VenationInfos, @TempBuf, SizeOf(HumanRCD.Data.VenationInfos), SizeOf(TempBuf));
      dbQry.SQL.Clear;
      dbQry.SQL.Add(format('INSERT TBL_ADDON (FLD_CHARNAME, FLD_STATUS, FLD_SERIESSKILLORDER, FLD_MISSION, FLD_VENATION) ' +
        'VALUES (''%s'', ''%s'', ''%s'', ''%s'', ''%s'')',
        [HumanRCD.Header.sName,
        sTmp, sTmp2, sTmp3,
          StrPas(TempBuf)]));
      try
        dbQry.Execute;
      except
        Result := False;
        MainOutMessage('[Exception] TFileDB.UpdateRecord (INSERT TBL_ADDON (FLD_STATUS))');
      end;

    end;

    m_boChanged := True;
  finally
    dbQry.Close;
  end;
end;

function TFileDB.Find(sChrName: string; List: TStrings): Integer;
var
  i                         : Integer;
begin
  for i := 0 to m_MirQuickList.Count - 1 do begin
    if CompareLStr(m_MirQuickList.Strings[i], sChrName, Length(sChrName)) then
      List.AddObject(m_MirQuickList.Strings[i], m_MirQuickList.Objects[i]);
  end;
  Result := List.Count;
end;

function TFileDB.Delete(nIndex: Integer): Boolean; //0x0048AF4C
var
  i                         : Integer;
  s14                       : string;
begin
  Result := False;
  for i := 0 to m_MirQuickList.Count - 1 do begin
    if Integer(m_MirQuickList.Objects[i]) = nIndex then begin
      s14 := m_MirQuickList.Strings[i];
      if DeleteRecord(nIndex) then begin
        m_MirQuickList.Delete(i);
        Result := True;
        Break;
      end;
    end;
  end;
end;

function TFileDB.DeleteRecord(nIndex: Integer): Boolean; //0x0048AD8C
var
  sChrName                  : string;
  sdt                       : string;
begin
  Result := True;
  sdt := FormatDateTime(SQLDTFORMAT, Now);
  sChrName := m_MirQuickList[nIndex];
  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(format('UPDATE TBL_CHARACTER SET FLD_DELETED=1, FLD_CREATEDATE=''%s'' WHERE FLD_CHARNAME=''%s''', [sdt, sChrName]));
    try
      dbQry.Execute;
    except
      Result := False;
      MainOutMessage('[Exception] TFileDB.DeleteRecord');
    end;
    m_boChanged := True;
  finally
    dbQry.Close;
  end;
end;

procedure TFileDB.Rebuild;              //0x0048A688
begin
  //
end;

function TFileDB.Count: Integer;
begin
  Result := m_MirQuickList.Count;
end;

function TFileDB.Delete(sChrName: string): Boolean; //0x0048AEB4
var
  nIndex                    : Integer;
begin
  Result := False;
  nIndex := m_MirQuickList.GetIndex(sChrName);
  if nIndex < 0 then Exit;
  if DeleteRecord(nIndex) then begin
    m_MirQuickList.Delete(nIndex);
    Result := True;
  end;
end;

function TFileDB.GetQryChar(nIndex: Integer; var QueryChrRcd: TQueryChr): Integer;
var
  sChrName                  : string;
resourcestring
  sSQL                      = 'SELECT * FROM TBL_CHARACTER WHERE FLD_CHARNAME=''%s''';
begin
  Result := -1;
  if nIndex < 0 then Exit;
  if m_QuickList.Count <= nIndex then Exit;

  sChrName := m_QuickList[nIndex];

  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL, [sChrName]));
    try
      dbQry.Open;
    except
      OutMainMessage('[Exception] TFileDB.GetQryChar (1)');
      Exit;
    end;

    if dbQry.RecordCount > 0 then begin
      QueryChrRcd.sName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);
      QueryChrRcd.btClass := dbQry.FieldByName('FLD_JOB').AsInteger;
      QueryChrRcd.btHair := dbQry.FieldByName('FLD_HAIR').AsInteger;
      QueryChrRcd.btGender := dbQry.FieldByName('FLD_SEX').AsInteger;
      QueryChrRcd.btLevel := dbQry.FieldByName('FLD_LEVEL').AsInteger;
    end;
  finally
    dbQry.Close;
  end;

  Result := nIndex;
end;

initialization
{$IFDEF SQLDB}
  CoInitialize(nil);
  ADOConnection := TMSConnection.Create(nil);
  dbQry := TMSQuery.Create(nil);
{$ENDIF}

finalization
{$IFDEF SQLDB}
  dbQry.Free;
  ADOConnection.Free;
  CoUnInitialize;
{$ENDIF}

end.

