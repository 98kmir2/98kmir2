unit IDSQL;

interface

uses
  Windows, SysUtils, Classes, Dialogs, Grobal2, MudUtil, DB, ADODB, ActiveX;

type
  TFileIDDB = class
  private
    ADOConnection: TADOConnection;
    dbQry: TADOQuery;

    m_boChanged: Boolean;
    m_OnChange: TNotifyEvent;
    m_QuickList: TQuickList;
    nRecordCount: Integer;

    FCriticalSection: TRTLCriticalSection;
  private
    procedure LoadQuickList;
    function GetRecord(nIndex: Integer; var DBRecord: TAccountDBRecord): Boolean;
    function UpdateRecord(nIndex: Integer; DBRecord: TAccountDBRecord; btFlag: Byte): Boolean;

  public
    constructor Create(sSQL: string);
    destructor Destroy; override;

    procedure Lock;
    procedure UnLock;

    function Open: Boolean;
    function OpenEx: Boolean;
    procedure Close;
    function Index(sName: string): Integer;
    function Get(nIndex: Integer; var DBRecord: TAccountDBRecord): Integer;
    function FindByName(sName: string; var List: TStringList): Integer;
    function GetBy(nIndex: Integer; var DBRecord: TAccountDBRecord): Boolean;
    function Update(nIndex: Integer; var DBRecord: TAccountDBRecord): Boolean;
    function Add(var DBRecord: TAccountDBRecord): Boolean;
    function Delete(nIndex: Integer; var DBRecord: TAccountDBRecord): Boolean;
  end;

var
  AccountDB                 : TFileIDDB;

implementation

uses
  LSShare, HUtil32;

constructor TFileIDDB.Create(sSQL: string);
begin
  inherited Create;
  CoInitialize(nil);

  InitializeCriticalSection(FCriticalSection);

  m_QuickList := TQuickList.Create;
  m_QuickList.boCaseSensitive := False;
  m_boChanged := False;
  nRecordCount := -1;
  g_n472A6C := 0;
  g_n472A74 := 0;
  g_boDataDBReady := False;

  ADOConnection := TADOConnection.Create(nil);
  dbQry := TADOQuery.Create(nil);

  ADOConnection.ConnectionString := sSQL;
  ADOConnection.LoginPrompt := False;
  ADOConnection.KeepConnection := True;

  dbQry.Connection := ADOConnection;
  dbQry.Prepared := True;

  try
    ADOConnection.Connected := True;
    LoadQuickList;
  except
    on E: Exception do begin
      MessageBox(0, 'SQL 连接失败！请检查SQL设置...', '提示信息', MB_OK);
      MainOutMessage('[警告] SQL 连接失败！请检查SQL设置...');
      MainOutMessage(sSQL);
      MainOutMessage(E.Message);
    end;
  end;
end;

destructor TFileIDDB.Destroy;
begin
  m_QuickList.Free;
  DeleteCriticalSection(FCriticalSection);

  dbQry.Free;
  ADOConnection.Free;

  CoUnInitialize;
  inherited;
end;

function TFileIDDB.OpenEx: Boolean;
begin
  Result := Open();
end;

function TFileIDDB.Open: Boolean;
begin
  Result := False;
  Lock();

  m_boChanged := False;
  Result := True;
end;

procedure TFileIDDB.Close;
begin
  if m_boChanged and Assigned(m_OnChange) then begin
    m_OnChange(Self);
  end;

  UnLock();
end;

procedure TFileIDDB.LoadQuickList;
var
  nIndex                    : Integer;
  boDeleted                 : Boolean;
  sAccount                  : string;
resourcestring
  sSQL                      = 'SELECT * FROM TBL_ACCOUNT';
begin
  nRecordCount := -1;
  g_n472A6C := 0;
  g_n472A70 := 0;
  g_n472A74 := 0;
  m_QuickList.Clear;

  Lock;
  try
    try
      dbQry.SQL.Clear;
      dbQry.SQL.Add(sSQL);
      try
        dbQry.Open;
      except
        MainOutMessage('[Exception] TFileIDDB.LoadQuickList');
      end;

      nRecordCount := dbQry.RecordCount;
      g_n472A74 := nRecordCount;
      for nIndex := 0 to nRecordCount - 1 do begin
        Inc(g_n472A6C);

        boDeleted := dbQry.FieldByName('FLD_DELETED').AsBoolean;
        sAccount := Trim(dbQry.FieldByName('FLD_LOGINID').AsString);

        if (not boDeleted) and (sAccount <> '') then begin
          //MainOutMessage(sAccount);

          m_QuickList.AddObject(sAccount, TObject(nIndex));
          Inc(g_n472A70);
        end;

        dbQry.Next;
      end;
    finally
      dbQry.Close;
    end;
  finally
    UnLock;
  end;

  m_QuickList.SortString(0, m_QuickList.Count - 1);
  g_boDataDBReady := True;
end;

procedure TFileIDDB.Lock;
begin
  EnterCriticalSection(FCriticalSection);
end;

procedure TFileIDDB.UnLock;
begin
  LeaveCriticalSection(FCriticalSection);
end;

function TFileIDDB.FindByName(sName: string; var List: TStringList): Integer;
var
  I                         : Integer;
begin
  for I := 0 to m_QuickList.Count - 1 do begin
    //MainOutMessage(m_QuickList.Strings[I] + ' ' + sName);
    if CompareLStr(m_QuickList.Strings[I], sName, length(sName)) then begin
      List.AddObject(m_QuickList.Strings[I], m_QuickList.Objects[I]);
    end;
  end;
  Result := List.Count;
end;

function TFileIDDB.GetBy(nIndex: Integer; var DBRecord: TAccountDBRecord): Boolean;
begin
  if (nIndex >= 0) and (m_QuickList.Count > nIndex) then Result := GetRecord(nIndex, DBRecord)
  else
    Result := False;
end;

function TFileIDDB.GetRecord(nIndex: Integer; var DBRecord: TAccountDBRecord): Boolean;
var
  sAccount                  : string;
resourcestring
  sSQL                      = 'SELECT * FROM TBL_ACCOUNT WHERE FLD_LOGINID=''%s''';
begin
  Result := True;
  sAccount := m_QuickList[nIndex];

  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL, [sAccount]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[Exception] TFileIDDB.GetRecord (1)');
      Exit;
    end;

    DBRecord.Header.sAccount := Trim(dbQry.FieldByName('FLD_LOGINID').AsString);
    //DBRecord.Header.sAccount := '';
    DBRecord.Header.boDeleted := dbQry.FieldByName('FLD_DELETED').AsBoolean;
    DBRecord.Header.CreateDate := dbQry.FieldByName('FLD_CREATEDATE').AsDateTime;
    DBRecord.Header.UpdateDate := dbQry.FieldByName('FLD_LASTUPDATE').AsDateTime;

    DBRecord.nErrorCount := dbQry.FieldByName('FLD_ERRORCOUNT').AsInteger;
    DBRecord.dwActionTick := dbQry.FieldByName('FLD_ACTIONTICK').AsInteger;

    DBRecord.UserEntry.sAccount := Trim(dbQry.FieldByName('FLD_LOGINID').AsString);
    DBRecord.UserEntry.sPassword := Trim(dbQry.FieldByName('FLD_PASSWORD').AsString);
    DBRecord.UserEntry.sUserName := Trim(dbQry.FieldByName('FLD_USERNAME').AsString);

    DBRecord.UserEntry.sSSNo := Trim(dbQry.FieldByName('FLD_SSNO').AsString);
    DBRecord.UserEntry.sPhone := Trim(dbQry.FieldByName('FLD_PHONE').AsString);
    DBRecord.UserEntry.sQuiz := Trim(dbQry.FieldByName('FLD_QUIZ1').AsString);
    DBRecord.UserEntry.sAnswer := Trim(dbQry.FieldByName('FLD_ANSWER1').AsString);
    DBRecord.UserEntry.sEMail := Trim(dbQry.FieldByName('FLD_EMAIL').AsString);
    DBRecord.UserEntryAdd.sQuiz2 := Trim(dbQry.FieldByName('FLD_QUIZ2').AsString);
    DBRecord.UserEntryAdd.sAnswer2 := Trim(dbQry.FieldByName('FLD_ANSWER2').AsString);
    DBRecord.UserEntryAdd.sBirthDay := Trim(dbQry.FieldByName('FLD_BIRTHDAY').AsString);
    DBRecord.UserEntryAdd.sMobilePhone := Trim(dbQry.FieldByName('FLD_MOBILEPHONE').AsString);
    DBRecord.UserEntryAdd.sMemo := '';  //Trim(dbQry.FieldByName('FLD_MEMO1').AsString);
    DBRecord.UserEntryAdd.sMemo2 := ''; //Trim(dbQry.FieldByName('FLD_MEMO2').AsString);

    {dbQry.SQL.Clear;
    dbQry.SQL.Add(format(sSQL2, [sAccount]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[Exception] TFileIDDB.GetRecord (2)');
    end;

    DBRecord.UserEntry.sSSNo := Trim(dbQry.FieldByName('FLD_SSNO').AsString);
    DBRecord.UserEntry.sPhone := Trim(dbQry.FieldByName('FLD_PHONE').AsString);
    DBRecord.UserEntry.sQuiz := Trim(dbQry.FieldByName('FLD_QUIZ1').AsString);
    DBRecord.UserEntry.sAnswer := Trim(dbQry.FieldByName('FLD_ANSWER1').AsString);
    DBRecord.UserEntry.sEMail := Trim(dbQry.FieldByName('FLD_EMAIL').AsString);
    //--------------------------------------------------------------------------------
    DBRecord.UserEntryAdd.sQuiz2 := Trim(dbQry.FieldByName('FLD_QUIZ2').AsString);
    DBRecord.UserEntryAdd.sAnswer2 := Trim(dbQry.FieldByName('FLD_ANSWER2').AsString);
    DBRecord.UserEntryAdd.sBirthDay := Trim(dbQry.FieldByName('FLD_BIRTHDAY').AsString);
    DBRecord.UserEntryAdd.sMobilePhone := Trim(dbQry.FieldByName('FLD_MOBILEPHONE').AsString);
    DBRecord.UserEntryAdd.sMemo := Trim(dbQry.FieldByName('FLD_MEMO1').AsString);
    DBRecord.UserEntryAdd.sMemo2 := Trim(dbQry.FieldByName('FLD_MEMO2').AsString); }
  finally
    dbQry.Close;
  end;
end;

function TFileIDDB.Index(sName: string): Integer;
begin
  Result := m_QuickList.GetIndex(sName);
end;

function TFileIDDB.Get(nIndex: Integer; var DBRecord: TAccountDBRecord): Integer;
begin
  Result := -1;
  if nIndex < 0 then Exit;
  if m_QuickList.Count <= nIndex then Exit;
  if GetRecord(nIndex, DBRecord) then Result := nIndex
end;

function TFileIDDB.UpdateRecord(nIndex: Integer; DBRecord: TAccountDBRecord; btFlag: Byte): Boolean;
var
  sdt                       : string;
const
  sUpdateRecord1            = 'INSERT INTO TBL_ACCOUNT (FLD_LOGINID, FLD_PASSWORD, FLD_USERNAME, FLD_CREATEDATE, FLD_LASTUPDATE, FLD_DELETED, FLD_ERRORCOUNT, FLD_ACTIONTICK, ' +
    'FLD_SSNO, FLD_BIRTHDAY, FLD_PHONE, FLD_MOBILEPHONE, FLD_EMAIL, FLD_QUIZ1, FLD_ANSWER1, FLD_QUIZ2, FLD_ANSWER2) ' +
    'VALUES( ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', 0, 0, 0, ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'')';
  sUpdateRecord2            = 'UPDATE TBL_ACCOUNT SET FLD_DELETED=1, FLD_CREATEDATE=''%s'' ' +
    'WHERE FLD_LOGINID=''%s''';
  sUpdateRecord0            = 'UPDATE TBL_ACCOUNT SET FLD_PASSWORD=''%s'', FLD_USERNAME=''%s'', ' +
    'FLD_LASTUPDATE=''%s'', FLD_ERRORCOUNT=%d, FLD_ACTIONTICK=%d, ' +
    'FLD_SSNO=''%s'', FLD_BIRTHDAY=''%s'', FLD_PHONE=''%s'', ' +
    'FLD_MOBILEPHONE=''%s'', FLD_EMAIL=''%s'', FLD_QUIZ1=''%s'', FLD_ANSWER1=''%s'', FLD_QUIZ2=''%s'', ' +
    'FLD_ANSWER2=''%s'' WHERE FLD_LOGINID=''%s''';
begin
  Result := True;
  sdt := FormatDateTime('mm"/"dd"/"yyyy hh":"nn":"ss', Now);

  try
    dbQry.SQL.Clear;

    case btFlag of
      1: begin                          // New
          //MainOutMessage('TFileIDDB.UpdateRecord (1)');
          dbQry.SQL.Add(format(sUpdateRecord1,
            [DBRecord.UserEntry.sAccount,
            DBRecord.UserEntry.sPassword,
              DBRecord.UserEntry.sUserName,
              sdt,
              sdt,
              DBRecord.UserEntry.sSSNo,
              DBRecord.UserEntryAdd.sBirthDay,
              DBRecord.UserEntry.sPhone,
              DBRecord.UserEntryAdd.sMobilePhone,
              DBRecord.UserEntry.sEMail,
              DBRecord.UserEntry.sQuiz,
              DBRecord.UserEntry.sAnswer,
              DBRecord.UserEntryAdd.sQuiz2,
              DBRecord.UserEntryAdd.sAnswer2]));

          try
            dbQry.ExecSQL;
          except
            on E: Exception do begin
              Result := False;
              MainOutMessage('[Exception] TFileIDDB.UpdateRecord');
              MainOutMessage(E.Message);
              Exit;
            end;
          end;
        end;

      2: begin                          // Delete
          //MainOutMessage('TFileIDDB.UpdateRecord (2)');
          dbQry.SQL.Add(format(sUpdateRecord2,
            [sdt,
            DBRecord.UserEntry.sAccount]));

          try
            dbQry.ExecSQL;
          except
            Result := False;
            MainOutMessage('[Exception] TFileIDDB.UpdateRecord (3)');
          end;
        end;
    else begin                          //General Update
        //MainOutMessage('TFileIDDB.UpdateRecord (0)');
        dbQry.SQL.Add(format(sUpdateRecord0,
          [DBRecord.UserEntry.sPassword,
          DBRecord.UserEntry.sUserName,
            sdt,
            DBRecord.nErrorCount,
            DBRecord.dwActionTick,
            DBRecord.UserEntry.sSSNo,
            DBRecord.UserEntryAdd.sBirthDay,
            DBRecord.UserEntry.sPhone,
            DBRecord.UserEntryAdd.sMobilePhone,
            DBRecord.UserEntry.sEMail,
            DBRecord.UserEntry.sQuiz,
            DBRecord.UserEntry.sAnswer,
            DBRecord.UserEntryAdd.sQuiz2,
            DBRecord.UserEntryAdd.sAnswer2,
            DBRecord.UserEntry.sAccount]));

        try
          dbQry.ExecSQL;
        except
          on E: Exception do begin
            Result := False;
            MainOutMessage('[Exception] TFileIDDB.UpdateRecord (0)');
            MainOutMessage(E.Message);
            Exit;
          end;
        end;

        {dbQry.SQL.Clear;
        dbQry.SQL.Add(format('UPDATE TBL_ACCOUNTADD SET FLD_SSNO=''%s'', FLD_BIRTHDAY=''%s'', FLD_PHONE=''%s'', ' +
          'FLD_MOBILEPHONE=''%s'', FLD_EMAIL=''%s'', FLD_QUIZ1=''%s'', FLD_ANSWER1=''%s'', FLD_QUIZ2=''%s'', ' +
          'FLD_ANSWER2=''%s'' WHERE FLD_LOGINID=''%s''',
          [DBRecord.UserEntry.sSSNo,
          DBRecord.UserEntryAdd.sBirthDay,
            DBRecord.UserEntry.sPhone,
            DBRecord.UserEntryAdd.sMobilePhone,
            DBRecord.UserEntry.sEMail,
            DBRecord.UserEntry.sQuiz,
            DBRecord.UserEntry.sAnswer,
            DBRecord.UserEntryAdd.sQuiz2,
            DBRecord.UserEntryAdd.sAnswer2,
            //DBRecord.UserEntryAdd.sMemo,
          //DBRecord.UserEntryAdd.sMemo2,
          DBRecord.UserEntry.sAccount]));

        try
          dbQry.ExecSQL;
        except
          Result := False;
          MainOutMessage('[Exception] TFileIDDB.UpdateRecord (5)');
        end;}
      end;
    end;

    m_boChanged := True;
  finally
    dbQry.Close;
  end;
end;

function TFileIDDB.Update(nIndex: Integer; var DBRecord: TAccountDBRecord): Boolean;
begin
  Result := False;
  if nIndex < 0 then Exit;
  if m_QuickList.Count <= nIndex then Exit;
  if UpdateRecord(nIndex, DBRecord, 0) then
    Result := True;
end;

function TFileIDDB.Add(var DBRecord: TAccountDBRecord): Boolean;
var
  sAccount                  : string;
  nIndex                    : Integer;
begin
  sAccount := DBRecord.UserEntry.sAccount;
  if m_QuickList.GetIndex(sAccount) >= 0 then begin
    Result := False;
  end else begin
    nIndex := nRecordCount;
    Inc(nRecordCount);

    if UpdateRecord(nIndex, DBRecord, 1) then begin
      m_QuickList.AddRecord(sAccount, nIndex);
      Result := True;
    end else begin
      Result := False;
    end;
  end;
end;

function TFileIDDB.Delete(nIndex: Integer; var DBRecord: TAccountDBRecord): Boolean;
begin
  Result := False;
  if nIndex < 0 then Exit;
  if m_QuickList.Count <= nIndex then Exit;
  if UpdateRecord(nIndex, DBRecord, 2) then begin
    m_QuickList.Delete(nIndex);
    Result := True;
  end;
end;

end.

