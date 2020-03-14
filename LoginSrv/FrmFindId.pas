unit FrmFindId;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, {$IFDEF SQLDB}IDSQL, {$ELSE}IDDB, {$ENDIF}Grobal2;
type
  TFrmFindUserId = class(TForm)
    IdGrid: TStringGrid;
    Panel1: TPanel;
    EdFindId: TEdit;
    Label1: TLabel;
    BtnFindAll: TButton;
    Button1: TButton;
    BtnEdit: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnFindAllClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure EdFindIdKeyPress(Sender: TObject; var Key: Char);
  private
    procedure RefChrGrid(nIndex: Integer; var DBRecord: TAccountDBRecord);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmFindUserId: TFrmFindUserId;

implementation

uses EditUserInfo, LMain, MasSock, LSShare;

{$R *.DFM}

procedure TFrmFindUserId.EdFindIdKeyPress(Sender: TObject; var Key: Char);
var
  sAccount: string;
  n08, nIndex: Integer;
  DBRecord: TAccountDBRecord;
begin
  if Key <> #13 then
    Exit;
  sAccount := Trim(EdFindId.Text);
  IdGrid.RowCount := 1;
  try
    if AccountDB.Open then
    begin
      n08 := AccountDB.Index(sAccount);
      if n08 >= 0 then
      begin
        nIndex := AccountDB.Get(n08, DBRecord);
        if nIndex >= 0 then
          RefChrGrid(-1, DBRecord);
      end;
    end;
  finally
    AccountDB.Close;
  end;
end;

procedure TFrmFindUserId.FormCreate(Sender: TObject);
begin

  IdGrid.RowCount := 2;
  IdGrid.Cells[0, 0] := '�ʺ�';
  IdGrid.Cells[1, 0] := '����';
  IdGrid.Cells[2, 0] := '�û�����';
  IdGrid.Cells[3, 0] := '���֤��';
  IdGrid.Cells[4, 0] := '����';
  IdGrid.Cells[5, 0] := '����һ';
  IdGrid.Cells[6, 0] := '��һ';
  IdGrid.Cells[7, 0] := '�����';
  IdGrid.Cells[8, 0] := '�𰸶�';
  IdGrid.Cells[9, 0] := '�绰';
  IdGrid.Cells[10, 0] := '�ƶ��绰';
  IdGrid.Cells[11, 0] := '��עһ';
  IdGrid.Cells[12, 0] := '��ע��';
  IdGrid.Cells[13, 0] := '����ʱ��';
  IdGrid.Cells[14, 0] := '����¼ʱ��';
  IdGrid.Cells[15, 0] := '��������';
end;

procedure TFrmFindUserId.BtnFindAllClick(Sender: TObject);
var
  sAccount: string;
  AccountList: TStringList;
  I, nIndex: Integer;
  DBRecord: TAccountDBRecord;
begin
  try
    IdGrid.RowCount := 1;
    sAccount := Trim(EdFindId.Text);
    if sAccount = '' then
      Exit;
    AccountList := TStringList.Create;
    try
      if AccountDB.Open then
      begin
        if AccountDB.FindByName(sAccount, AccountList) > 0 then
        begin
          for I := 0 to AccountList.Count - 1 do
          begin
            nIndex := Integer(AccountList.Objects[I]);
            if AccountDB.GetBy(nIndex, DBRecord) then
              RefChrGrid(-1, DBRecord);
          end;
        end;
      end;
    finally
      AccountDB.Close;
    end;
    AccountList.Free;
  except
    MainOutMessage('TFrmFindUserId.BtnFindAllClick');
  end;
end;

procedure TFrmFindUserId.Button1Click(Sender: TObject);
begin
  FrmMasSoc.LoadServerAddr();
end;

procedure TFrmFindUserId.BtnEditClick(Sender: TObject);
var
  nRow, nIndex: Integer;
  sAccount: string;
  DBRecord: TAccountDBRecord;
  boCheckOK, bo12: Boolean;
  Config: pTConfig;
resourcestring
  sEditAccount = 'ch2';
begin
  Config := @g_Config;
  nRow := IdGrid.Row;
  if nRow <= 0 then
    Exit;
  sAccount := IdGrid.Cells[0, nRow];
  if sAccount = '' then
    Exit;
  boCheckOK := False;
  try
    if AccountDB.OpenEx then
    begin
      nIndex := AccountDB.Index(sAccount);
      if nIndex >= 0 then
        if AccountDB.Get(nIndex, DBRecord) >= 0 then
          boCheckOK := true;
    end;
  finally
    AccountDB.Close;
  end;
  if FrmUserInfoEdit.sub_466AEC(DBRecord) then
  begin
    try
      if AccountDB.Open then
      begin
        nIndex := AccountDB.Index(sAccount);
        if nIndex >= 0 then
          if AccountDB.Update(nIndex, DBRecord) then
          begin
            RefChrGrid(nRow, DBRecord);
            bo12 := true;
          end;
      end;
    finally
      AccountDB.Close;
    end;
  end;
  if bo12 then
    WriteLogMsg(Config, sEditAccount, DBRecord.UserEntry, DBRecord.UserEntryAdd);
end;

procedure TFrmFindUserId.Button2Click(Sender: TObject);
var
  DBRecord: TAccountDBRecord;
  sAccount: string;
  nIndex: Integer;
  boMakeSuccess: Boolean;
  Config: pTConfig;
resourcestring
  sAddAccount = 'ch2';
  sMakingIDSuccess = '�����ʺųɹ�: %s';
begin
  Config := @g_Config;
  FillChar(DBRecord, SizeOf(TAccountDBRecord), #0);
  boMakeSuccess := False;
  if FrmUserInfoEdit.sub_466B10(true, DBRecord) and (DBRecord.UserEntry.sAccount <> '') then
  begin
    sAccount := DBRecord.UserEntry.sAccount;
    DBRecord.Header.sAccount := sAccount;
    try
      if AccountDB.Open then
      begin
        nIndex := AccountDB.Index(sAccount);
        if nIndex < 0 then
        begin
          if AccountDB.Add(DBRecord) then
            boMakeSuccess := true;
        end;
      end;
    finally
      AccountDB.Close;
    end;
  end;
  if boMakeSuccess then
  begin
    MainOutMessage(Format(sMakingIDSuccess, [sAccount]));
    WriteLogMsg(Config, sAddAccount, DBRecord.UserEntry, DBRecord.UserEntryAdd);
  end;
end;

procedure TFrmFindUserId.RefChrGrid(nIndex: Integer; var DBRecord: TAccountDBRecord);
var
  nRow: Integer;
begin
  try
    if nIndex <= 0 then
    begin
      IdGrid.RowCount := IdGrid.RowCount + 1;
      IdGrid.FixedRows := 1;
      nRow := IdGrid.RowCount - 1;
    end
    else
      nRow := nIndex;
    IdGrid.Cells[0, nRow] := DBRecord.UserEntry.sAccount;
    IdGrid.Cells[1, nRow] := DBRecord.UserEntry.sPassword;
    IdGrid.Cells[2, nRow] := DBRecord.UserEntry.sUserName;
    IdGrid.Cells[3, nRow] := DBRecord.UserEntry.sSSNo;
    IdGrid.Cells[4, nRow] := DBRecord.UserEntryAdd.sBirthDay;
    IdGrid.Cells[5, nRow] := DBRecord.UserEntry.sQuiz;
    IdGrid.Cells[6, nRow] := DBRecord.UserEntry.sAnswer;
    IdGrid.Cells[7, nRow] := DBRecord.UserEntryAdd.sQuiz2;
    IdGrid.Cells[8, nRow] := DBRecord.UserEntryAdd.sAnswer2;
    IdGrid.Cells[9, nRow] := DBRecord.UserEntry.sPhone;
    IdGrid.Cells[10, nRow] := DBRecord.UserEntryAdd.sMobilePhone;
    IdGrid.Cells[11, nRow] := DBRecord.UserEntryAdd.sMemo;
    IdGrid.Cells[12, nRow] := DBRecord.UserEntryAdd.sMemo2;
    IdGrid.Cells[13, nRow] := DateTimeToStr(DBRecord.Header.CreateDate);
    IdGrid.Cells[14, nRow] := DateTimeToStr(DBRecord.Header.UpdateDate);
    IdGrid.Cells[15, nRow] := DBRecord.UserEntry.sEMail;
  except
  end;
end;

end.
