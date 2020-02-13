unit LocalDB;

interface
uses
  Windows, Classes, SysUtils, ActiveX, DBTables, Grobal2,math;

type
  TLocalDB = class
  public
    Query: TQuery;
    constructor Create();
    destructor Destroy; override;
    function LoadItemsDB(): Integer;
    function LoadMagicDB(): Integer;
    function FindMagic(nMagIdx, btclass: Integer): pTMagic;
    function GetStdItemName(nItemIdx: Integer): string;
  end;

var
  LocalDBE: TLocalDB;
  m_StdItemList: TList;
  m_MagicList: TList;
  ProcessDBCriticalSection: TRTLCriticalSection;

implementation

uses DBShare;

function TLocalDB.GetStdItemName(nItemIdx: Integer): string;
begin
  Result := '';
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (m_StdItemList.Count > nItemIdx) then
  begin
    Result := pTStdItem(m_StdItemList.Items[nItemIdx]).Name;
  end
  else
    Result := '';
end;

function TLocalDB.FindMagic(nMagIdx, btclass: Integer): pTMagic;
var
  i: Integer;
  Magic: pTMagic;
begin
  Result := nil;
  for i := 0 to m_MagicList.Count - 1 do
  begin
    Magic := m_MagicList.Items[i];
    if (Magic.wMagicId = nMagIdx) then
    begin
      if (btclass = Magic.btclass) then
      begin
        Result := Magic;
        Break;
      end;
    end;
  end;
end;

constructor TLocalDB.Create();
begin
  CoInitialize(nil);
  Query := TQuery.Create(nil);
end;

destructor TLocalDB.Destroy;
begin
  Query.Free;
  CoUnInitialize;
  inherited;
end;

function TLocalDB.LoadItemsDB: Integer;
var
  i, Idx: Integer;
  StdItem: pTStdItem;
resourcestring
  sSQLString = 'select * from StdItems';
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
      for i := 0 to Query.RecordCount - 1 do
      begin
        New(StdItem);
        try
          Idx := Query.FieldByName('Idx').AsInteger;
          StdItem.Name := Query.FieldByName('Name').AsString;
          StdItem.StdMode := Max(0, Min(Query.FieldByName('StdMode').AsInteger, High(StdItem.StdMode)));
          StdItem.Shape := Max(0, Min(Query.FieldByName('Shape').AsInteger, High(StdItem.Shape)));
          StdItem.Weight := Max(0, Min(Query.FieldByName('Weight').AsInteger, High(StdItem.Weight)));
          StdItem.AniCount := Max(0, Min(Query.FieldByName('AniCount').AsInteger, High(StdItem.AniCount)));
          StdItem.Source := Max(0, Min(Query.FieldByName('Source').AsInteger, High(StdItem.Source)));
          StdItem.Reserved := Max(0, Min(Query.FieldByName('Reserved').AsInteger, High(StdItem.Reserved)));
          StdItem.Looks := Max(0, Min(Query.FieldByName('Looks').AsInteger, High(StdItem.Looks)));
          StdItem.DuraMax := Max(0, Min(Query.FieldByName('DuraMax').AsInteger, High(StdItem.DuraMax)));
          StdItem.AC := MakeLong(Round(Query.FieldByName('Ac').AsInteger), Round(Query.FieldByName('Ac2').AsInteger));
          StdItem.MAC := MakeLong(Round(Query.FieldByName('Mac').AsInteger), Round(abs(Query.FieldByName('MAc2').AsInteger)));
          StdItem.DC := MakeLong(Round(Query.FieldByName('Dc').AsInteger), Round(Query.FieldByName('Dc2').AsInteger));
          StdItem.MC := MakeLong(Round(Query.FieldByName('Mc').AsInteger), Round(Query.FieldByName('Mc2').AsInteger));
          StdItem.SC := MakeLong(Round(Query.FieldByName('Sc').AsInteger), Round(Query.FieldByName('Sc2').AsInteger));
          StdItem.Need := Query.FieldByName('Need').AsInteger;
          StdItem.NeedLevel := Query.FieldByName('NeedLevel').AsInteger;
          StdItem.Price := Query.FieldByName('Price').AsInteger;
          StdItem.NeedIdentify := 1;
          if m_StdItemList.Count = Idx then
          begin
            m_StdItemList.Add(StdItem);
            if Result < 0 then
              Result := 0;
            Inc(Result);
          end
          else
          begin
            Result := -100;
            Exit;
          end;
          Query.Next;
        except
          MainOutMessage(Format('加载物品错误: %s; %d', [Query.FieldByName('Name').AsString, Idx]));
          Dispose(StdItem);
        end;
      end;
    finally
      Query.Close;
    end;
  finally
    LeaveCriticalSection(ProcessDBCriticalSection);
  end;
end;

function TLocalDB.LoadMagicDB(): Integer;
var
  i: Integer;
  Magic: pTMagic;
resourcestring
  sSQLString = 'select * from Magic';
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
      for i := 0 to Query.RecordCount - 1 do
      begin
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

        Magic.btclass := 0;
        if CompareText(Magic.sDescr, '英雄') = 0 then
          Magic.btclass := 0
        else if CompareText(Magic.sDescr, '怒之') = 0 then
          Magic.btclass := 1
        else if CompareText(Magic.sDescr, '静之') = 0 then
          Magic.btclass := 2;

        if Magic.wMagicId > 0 then
          m_MagicList.Add(Magic)
        else
          Dispose(Magic);
        if Result < 0 then
          Result := 0;
        Inc(Result);
        Query.Next;
      end;
    finally
      Query.Close;
    end;
  finally
    LeaveCriticalSection(ProcessDBCriticalSection);
  end;
end;

initialization
  InitializeCriticalSection(ProcessDBCriticalSection);
  m_StdItemList := TList.Create;
  m_MagicList := TList.Create;

finalization
  LocalDBE.Free;
  DeleteCriticalSection(ProcessDBCriticalSection);

end.
