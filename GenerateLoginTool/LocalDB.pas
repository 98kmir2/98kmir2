unit LocalDB;

interface
uses
  Windows, Classes, SysUtils, ActiveX, ComCtrls, DBTables, Grobal2, cnHashTable, HUtil32;

type
  TLocalDB = class
  public
    m_PreList: TCnHashTableSmall;
    Query: TQuery;
    constructor Create();
    destructor Destroy; override;
    function LoadItemsDB(): Integer;
    function LoadFromItemsDB(): Integer;

    function GetStdItemName(nItemIdx: Integer): string;
    function GetStdItem(nItemIdx: Integer): pTStdItem;
  end;

procedure ReIniFileGuildName(f, o, n: string);

var
  g_LocalDBE                : TLocalDB;
  m_StdItemList             : TList;
  m_MagicList               : TList;
  ProcessDBCriticalSection  : TRTLCriticalSection;

implementation

uses
  IniFiles, MakePlugDLL;

procedure ReIniFileGuildName(f, o, n: string);
var
  ini                       : TIniFile;
begin
  ini := TIniFile.Create(f);
  if ini.ReadString('Guild', 'GuildName', '') = o then
    ini.WriteString('Guild', 'GuildName', n);
end;

function TLocalDB.GetStdItemName(nItemIdx: Integer): string;
begin
  Result := '';
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (m_StdItemList.Count > nItemIdx) then begin
    Result := pTStdItem(m_StdItemList.Items[nItemIdx]).Name;
  end else
    Result := '';
end;

function TLocalDB.GetStdItem(nItemIdx: Integer): pTStdItem;
begin
  Result := nil;
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (m_StdItemList.Count > nItemIdx) then begin
    Result := pTStdItem(m_StdItemList.Items[nItemIdx]);
  end else
    Result := nil;
end;

{function TLocalDB.FindMagic(nMagIdx, btclass: Integer): pTMagic;
var
  i, c                      : Integer;
  Magic                     : pTMagic;
begin
  Result := nil;
  for i := 0 to m_MagicList.Count - 1 do begin
    Magic := m_MagicList.Items[i];
    if (Magic.wMagicId = nMagIdx) then begin
      if (btclass = Magic.btClass) then begin
        Result := Magic;
        Break;
      end;
    end;
  end;
end;}

constructor TLocalDB.Create();
var
  i                         : Integer;
  ls                        : TStringList;
  s, sn,
    st,
    nonsuch,
    pickup,
    shouname                : string;
  p                         : pTCItemRule;
begin
  CoInitialize(nil);
  Query := TQuery.Create(nil);
  m_PreList := TCnHashTableSmall.Create;
  if FileExists('.\DefaultItemFilter.dat') then begin
    ls := TStringList.Create;
    ls.LoadFromFile('.\DefaultItemFilter.dat');
    for i := 0 to ls.Count - 1 do begin
      s := ls[i];
      if s = '' then continue;
      s := GetValidStr3(s, sn, [',']);
      s := GetValidStr3(s, st, [',']);
      s := GetValidStr3(s, nonsuch, [',']);
      pickup := GetValidStr3(s, shouname, [',']);
      New(p);
      p.rare := Str_ToInt(nonsuch, 0) <> 0;
      p.pick := Str_ToInt(pickup, 0) <> 0;
      p.shoW := Str_ToInt(shouname, 0) <> 0;
      m_PreList.Put(sn, TObject(p));

    end;
    ls.Free;
  end;

end;

destructor TLocalDB.Destroy;
begin
  m_PreList.Free;
  Query.Free;
  CoUnInitialize;
  inherited;
end;

function TLocalDB.LoadItemsDB: Integer;
var
  i, Idx                    : Integer;
  StdItem                   : pTStdItem;
resourcestring
  sSQLString                = 'select * from StdItems';
begin
  EnterCriticalSection(ProcessDBCriticalSection);
  try
    try
      for i := 0 to m_StdItemList.Count - 1 do
        Dispose(pTStdItem(m_StdItemList.Items[i]));
      m_StdItemList.Clear;
      Result := -1;
      Query.SQL.Clear;
      Query.SQL.Add(sSQLString);
      try
        Query.Open;
      finally
        Result := -2;
      end;
      for i := 0 to Query.RecordCount - 1 do begin
        New(StdItem);
        Idx := Query.FieldByName('Idx').AsInteger;
        StdItem.Name := Query.FieldByName('Name').AsString;
        StdItem.StdMode := Query.FieldByName('StdMode').AsInteger;
        StdItem.Shape := Query.FieldByName('Shape').AsInteger;
        StdItem.Weight := Query.FieldByName('Weight').AsInteger;
        StdItem.AniCount := Query.FieldByName('AniCount').AsInteger;
        StdItem.Source := Query.FieldByName('Source').AsInteger;
        StdItem.Reserved := Query.FieldByName('Reserved').AsInteger;
        StdItem.Looks := Query.FieldByName('Looks').AsInteger;
        StdItem.DuraMax := Word(Query.FieldByName('DuraMax').AsInteger);
        StdItem.AC := MakeLong(Round(Query.FieldByName('Ac').AsInteger), Round(Query.FieldByName('Ac2').AsInteger));
        StdItem.MAC := MakeLong(Round(Query.FieldByName('Mac').AsInteger), Round(abs(Query.FieldByName('MAc2').AsInteger)));
        StdItem.DC := MakeLong(Round(Query.FieldByName('Dc').AsInteger), Round(Query.FieldByName('Dc2').AsInteger));
        StdItem.MC := MakeLong(Round(Query.FieldByName('Mc').AsInteger), Round(Query.FieldByName('Mc2').AsInteger));
        StdItem.SC := MakeLong(Round(Query.FieldByName('Sc').AsInteger), Round(Query.FieldByName('Sc2').AsInteger));
        StdItem.Need := Query.FieldByName('Need').AsInteger;
        StdItem.NeedLevel := Query.FieldByName('NeedLevel').AsInteger;
        StdItem.Price := Query.FieldByName('Price').AsInteger;

        //StdItem.UniqueItem := Query.FieldByName('UniqueItem').AsInteger;
        //StdItem.Overlap := Query.FieldByName('Overlap').AsInteger;
        //StdItem.ItemType := Query.FieldByName('ItemType').AsInteger;
        //StdItem.ItemSet := Query.FieldByName('ItemSet').AsInteger;
        //StdItem.Reference := Query.FieldByName('Reference').AsString;

        StdItem.NeedIdentify := 1;
        if m_StdItemList.Count = Idx then begin
          m_StdItemList.Add(StdItem);
          if Result < 0 then
            Result := 0;
          Inc(Result);
        end else begin
          Result := -100;
          Exit;
        end;
        Query.Next;
      end;
    finally
      Query.Close;
    end;
  finally
    LeaveCriticalSection(ProcessDBCriticalSection);
  end;
end;

function TLocalDB.LoadFromItemsDB: Integer;
var
  i, Idx                    : Integer;
  s                         : string;
  p                         : pTCItemRule;
  b                         : Boolean;
  StdMode, AniCount, Shape  : Integer;
resourcestring
  sSQLString                = 'select * from StdItems';
begin
  EnterCriticalSection(ProcessDBCriticalSection);
  try
    try
      Query.SQL.Clear;
      Query.SQL.Add(sSQLString);
      try
        Query.Open;
      finally
        Result := -2;
      end;

      frmMain.AdvStringGrid1.RowCount := Query.RecordCount + 1;

      for i := 1 to Query.RecordCount do begin
        s := Query.FieldByName('Name').AsString;

        StdMode := Query.FieldByName('StdMode').AsInteger;
        Shape := Query.FieldByName('shape').AsInteger;
        AniCount := Query.FieldByName('anicount').AsInteger;

        frmMain.AdvStringGrid1.Cells[0, i + 1] := s;
        case StdMode of
          10, 11, 15, 16, 27, 28: frmMain.AdvStringGrid1.Cells[1, i + 1] := '服装类';
          5, 6: frmMain.AdvStringGrid1.Cells[1, i + 1] := '武器类';
          19..26, 30: frmMain.AdvStringGrid1.Cells[1, i + 1] := '首饰类';
          0, 3: frmMain.AdvStringGrid1.Cells[1, i + 1] := '药品类';
          31: begin
              if (Shape > 0) and ((pos('药', s) > 0) or (pos('太阳', s) > 0) or (pos('雪霜', s) > 0)) then
                frmMain.AdvStringGrid1.Cells[1, i + 1] := '药品类'
              else
                frmMain.AdvStringGrid1.Cells[1, i + 1] := '其他类';
            end;
        else
          frmMain.AdvStringGrid1.Cells[1, i + 1] := '其他类';
        end;

        p := pTCItemRule(m_PreList.GetValues(s));
        if p <> nil then begin

          if p.rare then begin
            frmMain.AdvStringGrid1.AddCheckBox(2, i + 1, True, False);
          end else begin
            frmMain.AdvStringGrid1.AddCheckBox(2, i + 1, False, False);
          end;

          if p.pick then begin
            frmMain.AdvStringGrid1.AddCheckBox(3, i + 1, True, False);
          end else begin
            frmMain.AdvStringGrid1.AddCheckBox(3, i + 1, False, False);
          end;

          if p.show then begin
            frmMain.AdvStringGrid1.AddCheckBox(4, i + 1, True, False);
          end else begin
            frmMain.AdvStringGrid1.AddCheckBox(4, i + 1, False, False);
          end;
        end else begin
          b := Query.FieldByName('NeedLevel').AsInteger >= 42;
          frmMain.AdvStringGrid1.AddCheckBox(2, i + 1, b, False);
          frmMain.AdvStringGrid1.AddCheckBox(3, i + 1, b, False);
          frmMain.AdvStringGrid1.AddCheckBox(4, i + 1, b, False);
          frmMain.AdvStringGrid1.Cells[0, i + 1] := s;
        end;

        Query.Next;
      end;
    finally
      Query.Close;
    end;
  finally
    LeaveCriticalSection(ProcessDBCriticalSection);
  end;
end;

{function TLocalDB.LoadMagicDB(): Integer;
var
  i                         : Integer;
  Magic                     : pTMagic;
resourcestring
  sSQLString                = 'select * from Magic';
begin
  Result := -1;
  EnterCriticalSection(ProcessDBCriticalSection);
  try
    Query.SQL.Clear;
    Query.SQL.Add(sSQLString);
    try
      Query.Open;
    finally
      Result := -2;
    end;
    for i := 0 to Query.RecordCount - 1 do begin
      New(Magic);
      Magic.wMagicId := Query.FieldByName('MagId').AsInteger;
      Magic.sMagicName := Query.FieldByName('MagName').AsString;
      Magic.btEffectType := Query.FieldByName('EffectType').AsInteger;
      Magic.btEffect := Query.FieldByName('Effect').AsInteger;
      Magic.wSpell := Query.FieldByName('Spell').AsInteger;
      Magic.wPower := Query.FieldByName('Power').AsInteger;
      Magic.wMaxPower := Query.FieldByName('MaxPower').AsInteger;
      Magic.btJob := Query.FieldByName('Job').AsInteger;
      Magic.TrainLevel[0] := Query.FieldByName('NeedL1').AsInteger;
      Magic.TrainLevel[1] := Query.FieldByName('NeedL2').AsInteger;
      Magic.TrainLevel[2] := Query.FieldByName('NeedL3').AsInteger;
      Magic.TrainLevel[3] := Query.FieldByName('NeedL3').AsInteger;
      Magic.MaxTrain[0] := Query.FieldByName('L1Train').AsInteger;
      Magic.MaxTrain[1] := Query.FieldByName('L2Train').AsInteger;
      Magic.MaxTrain[2] := Query.FieldByName('L3Train').AsInteger;
      Magic.MaxTrain[3] := Magic.MaxTrain[2];
      Magic.btTrainLv := 3;
      Magic.dwDelayTime := Query.FieldByName('Delay').AsInteger;
      Magic.btDefSpell := Query.FieldByName('DefSpell').AsInteger;
      Magic.btDefPower := Query.FieldByName('DefPower').AsInteger;
      Magic.btDefMaxPower := Query.FieldByName('DefMaxPower').AsInteger;
      Magic.sDescr := Query.FieldByName('Descr').AsString;

      Magic.btClass := 0;
      if CompareText(Magic.sDescr, '英雄') = 0 then
        Magic.btClass := 0
      else if CompareText(Magic.sDescr, '怒之') = 0 then
        Magic.btClass := 1
      else if CompareText(Magic.sDescr, '静之') = 0 then
        Magic.btClass := 2;

      if Magic.wMagicId > 0 then
        m_MagicList.Add(Magic)
      else
        Dispose(Magic);
      if Result < 0 then
        Result := 0;
      Inc(Result);
      Query.Next;
    end;
    Query.Close;
  finally
    LeaveCriticalSection(ProcessDBCriticalSection);
  end;
end;}

initialization
  InitializeCriticalSection(ProcessDBCriticalSection);
  m_StdItemList := TList.Create;
  m_MagicList := TList.Create;

finalization
  DeleteCriticalSection(ProcessDBCriticalSection);

end.

