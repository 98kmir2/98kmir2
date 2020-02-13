unit DBSQL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, ADODB, Grobal2, MudUtil, DateUtils;

const
  GABOARD_NOTICE_LINE = 3;
  KIND_NOTICE = 0;

type
  TDBSQL = class(TObject)
  private
    FADOConnection: TADOConnection;
    FADOQuery: TADOQuery;
    FAutoConnectable: Boolean;
    FConnInfo: string;
    FFileName: string;
    FServerName: string;
    FLastConnTime: TDateTime;
    FLastConnMsec: DWORD;
    function LoadItemFromDB(pItem: PTMarketLoad; SqlDB: TADOQuery): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Connect(ServerName: string; FileName: string): Boolean;
    function ReConnect: Boolean;
    procedure Disconnect;
    property AutoConnectable: Boolean read FAutoConnectable write FAutoConnectable;
    function Connected: Boolean;
    function LoadPageUserMarket(MarketName: string; SellWho: string; ItemName: string; ItemType: Integer; ItemSet: Integer; SellItemList: TList): Integer;
    function AddSellUserMarket(pSellItem: PTMarketLoad): Integer;
    function ReadyToSell(var Readyitem: PTMarketLoad): Integer;
    function BuyOneUserMarket(var BuyItem: PTMarketLoad): Integer;
    function CancelUserMarket(var Cancelitem: PTMarketLoad): Integer;
    function GetPayUserMarket(var GetPayitem: PTMarketLoad): Integer;
    function ChkAddSellUserMarket(pSearchInfo: PTSearchSellItem; IsSucess: Boolean): Integer;
    function ChkBuyOneUserMarket(pSearchInfo: PTSearchSellItem; IsSucess: Boolean): Integer;
    function ChkCancelUserMarket(pSearchInfo: PTSearchSellItem; IsSucess: Boolean): Integer;
    function ChkGetPayUserMarket(pSearchInfo: PTSearchSellItem; IsSucess: Boolean): Integer;
  end;

var
  g_DBSQL: TDBSQL;

implementation

uses
  svMain, M2Share;

constructor TDBSQL.Create;
begin
  FADOConnection := TADOConnection.Create(nil);
  FADOQuery := TADOQuery.Create(nil);
  FConnInfo := '';
  FLastConnTime := 0;
  FLastConnMsec := 0;
  FAutoConnectable := False;
end;

destructor TDBSQL.Destroy;
begin
  Disconnect;
  FADOConnection.Free;
  FADOQuery.Free;
end;

function TDBSQL.Connect(ServerName: string; FileName: string): Boolean;
begin
  Result := False;
  FFileName := FileName;
  FServerName := ServerName;
  FConnInfo := g_sADODBString;
  if FConnInfo <> '' then
  begin
    FADOConnection.ConnectionString := FConnInfo;
    FADOConnection.LoginPrompt := False;
    FADOConnection.Connected := True;
    Result := FADOConnection.Connected;
    if Result then
    begin
      FADOQuery.Active := False;
      FADOQuery.Connection := FADOConnection;
      FLastConnTime := Now;
      MainOutMessageAPI('连接SQL数据成功...');
    end;
  end
  else
    MainOutMessageAPI(ServerName + ' : 连接SQL数据失败...');
  FLastConnMsec := GetTickCount;
end;

function TDBSQL.ReConnect: Boolean;
begin
  Result := False;
  if (FLastConnMsec + 15 * 1000) < GetTickCount then
  begin
    Disconnect;
    Result := Connect(FServerName, FFileName);
  end;
end;

function TDBSQL.Connected: Boolean;
begin
  Result := FADOConnection.Connected;
end;

procedure TDBSQL.Disconnect;
begin
  FADOQuery.Active := False;
  FADOConnection.Connected := False;
end;

function TDBSQL.LoadItemFromDB(pItem: PTMarketLoad; SqlDB: TADOQuery): Boolean;
var
  k: Integer;
begin
  Result := False;
  if SqlDB = nil then
    Exit;
  with SqlDB do
  begin
    //if IncDay(FieldByName('FLD_SELLDATE').AsDateTime, 100) > Date() then begin
    pItem.Index := FieldByName('FLD_MAKEINDEX').AsInteger;
    pItem.SellState := FieldByName('FLD_SELLOK').AsInteger;
    pItem.SellWho := Trim(FieldByName('FLD_SELLWHO').AsString);
    pItem.ItemName := Trim(FieldByName('FLD_ITEMNAME').AsString);
    pItem.SellPrice := FieldByName('FLD_SELLPRICE').AsInteger;
    pItem.SellDate := FormatDateTime('YYMMDDHHNNSS', FieldByName('FLD_SELLDATE').AsDateTime);
    pItem.UserItem.MakeIndex := FieldByName('FLD_MAKEINDEX').AsInteger;
    pItem.UserItem.wIndex := FieldByName('FLD_INDEX').AsInteger;
    pItem.UserItem.Dura := FieldByName('FLD_DURA').AsInteger;
    pItem.UserItem.DuraMax := FieldByName('FLD_DURAMAX').AsInteger;

    for k := Low(pItem.UserItem.btValue) to High(pItem.UserItem.btValue) do
      pItem.UserItem.btValue[k] := FieldByName('FLD_DESC' + IntToStr(k)).AsInteger;

    for k := Low(pItem.UserItem.btValueEx) to High(pItem.UserItem.btValueEx) do
      pItem.UserItem.btValueEx[k] := FieldByName('FLD_V' + IntToStr(k)).AsInteger;

    Result := True;
    //end;
  end;
end;

function TDBSQL.LoadPageUserMarket(MarketName: string; SellWho: string; ItemName: string; ItemType: Integer; ItemSet: Integer; SellItemList: TList): Integer;
var
  SearchStr: string;
  pSellItem: PTMarketLoad;
  i: Integer;
begin
  Result := UMResult_Fail;
  with FADOQuery do
  begin
    SearchStr := '';
    if (ItemName <> '') then
    begin
      SearchStr := 'EXEC UM_LOAD_ITEMNAME ''' + MarketName + ''',''' + ItemName + ''''
    end
    else if (SellWho <> '') then
    begin
      SearchStr := 'EXEC UM_LOAD_USERNAME ''' + MarketName + ''',''' + SellWho + '''';
    end
    else if (ItemSet <> 0) then
    begin
      SearchStr := 'EXEC UM_LOAD_ITEMSET ''' + MarketName + ''',' + IntToStr(ItemSet)
    end
    else if (ItemType >= 0) then
    begin
      SearchStr := 'EXEC UM_LOAD_ITEMTYPE ''' + MarketName + ''',' + IntToStr(ItemType);
    end;
    if SearchStr = '' then
      Exit;
    //MainOutMessageAPI(SearchStr);
    try
      if Active then
        Close;
      SQL.Clear;
      SQL.Add(SearchStr);
      if not Active then
        Open;
    except
    end;

    try
      First;
      for i := 0 to RecordCount - 1 do
      begin
        New(pSellItem);
        if LoadItemFromDB(pSellItem, FADOQuery) then
          SellItemList.Add(pSellItem)
        else
          Dispose(pSellItem);
        if not Eof then
          Next;
      end;
      if Active then
        Close;
      Result := UMRESULT_SUCCESS;
    except
      on E: Exception do
      begin
        MainOutMessageAPI('[Exception] TFrmSql.LoadPageUserMarket -> LoadItemFromDB (' + IntToStr(RecordCount) + '),' + E.Message);
        Result := UMResult_ReadFail;
        if Active then
          Close;
      end;
    end;
  end;
end;

function TDBSQL.AddSellUserMarket(pSellItem: PTMarketLoad): Integer;
var
  sQuery: string;
begin
  with FADOQuery do
  begin
    sQuery :=
      'INSERT INTO TBL_ITEMMARKET (FLD_MARKETNAME,FLD_SELLOK,FLD_ITEMTYPE,FLD_ITEMSET,FLD_ITEMNAME,FLD_SELLWHO,' +
      'FLD_SELLPRICE,FLD_SELLDATE,FLD_MAKEINDEX,FLD_INDEX,FLD_DURA,FLD_DURAMAX,FLD_DESC0,FLD_DESC1,FLD_DESC2,' +
      'FLD_DESC3,FLD_DESC4,FLD_DESC5,FLD_DESC6,FLD_DESC7,FLD_DESC8,FLD_DESC9,FLD_DESC10,FLD_DESC11,FLD_DESC12,' +
      'FLD_DESC13,FLD_DESC14,FLD_DESC15,FLD_DESC16,FLD_DESC17,FLD_DESC18,FLD_DESC19,FLD_DESC20,FLD_DESC21,FLD_DESC22,' +
      'FLD_DESC23,FLD_DESC24,FLD_DESC25,' +
      'FLD_V0,FLD_V1,FLD_V2,FLD_V3,FLD_V4,FLD_V5,FLD_V6,FLD_V7,FLD_V8,FLD_V9,FLD_V10,FLD_V11,FLD_V12,FLD_V13,' +
      'FLD_V14,FLD_V15,FLD_V16,FLD_V17,FLD_V18,FLD_V19' +
      ') Values(''' +
      string(pSellItem.MarketName) + ''',' +
      IntToStr(MARKET_DBSELLTYPE_READYSELL) + ',' +
      IntToStr(pSellItem.MarketType) + ',' +
      IntToStr(pSellItem.SetType) + ',''' +
      pSellItem.ItemName + ''',''' +
      pSellItem.SellWho + ''',' +
      IntToStr(pSellItem.SellPrice) + ',' +
      'DATE(),' +
      IntToStr(pSellItem.UserItem.MakeIndex) + ',' +
      IntToStr(pSellItem.UserItem.wIndex) + ',' +
      IntToStr(pSellItem.UserItem.Dura) + ',' +
      IntToStr(pSellItem.UserItem.DuraMax) + ',' +
      IntToStr(pSellItem.UserItem.btValue[0]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[1]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[2]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[3]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[4]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[5]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[6]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[7]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[8]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[9]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[10]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[11]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[12]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[13]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[14]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[15]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[16]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[17]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[18]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[19]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[20]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[21]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[22]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[23]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[24]) + ',' +
      IntToStr(pSellItem.UserItem.btValue[25]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[0]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[1]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[2]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[3]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[4]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[5]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[6]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[7]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[8]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[9]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[10]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[11]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[12]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[13]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[14]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[15]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[16]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[17]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[18]) + ',' +
      IntToStr(pSellItem.UserItem.btValueEx[19]) +
      ')';
    try
      SQL.Clear;
      SQL.Add(sQuery);
      ExecSQL;
      Result := UMRESULT_SUCCESS;
    except
      //MainOutMessageAPI('[Exception] TFrmSql.AddSellUserMarket -> ExecSQL');
      //for i := 0 to SQL.Count - 1 do MainOutMessageAPI('ExecSQL :' + SQL[i]);
      Result := UMResult_Fail;
    end;
  end;
end;

function TDBSQL.ReadyToSell(var Readyitem: PTMarketLoad): Integer;
var
  SearchStr: string;
begin
  with FADOQuery do
  begin
    SearchStr := 'EXEC UM_READYTOSELL_NEW ''' + Readyitem.MarketName + ''',''' + Readyitem.SellWho + '''';

    try
      if Active then
        Close;
      SQL.Clear;
      SQL.Add(SearchStr);
      //ExecSQL();
      if not Active then
        Open;
    except
    end;

    try
      if RecordCount >= 0 then
      begin
        Readyitem.SellCount := RecordCount;
        Result := UMRESULT_SUCCESS;
      end
      else
      begin
        Readyitem.SellCount := 0;
        Result := UMResult_Fail;
      end;
      if Active then
        Close;
    except
      //MainOutMessageAPI('[Exception] TFrmSql.ReadyToSell -> RecordCount');
      Readyitem.SellCount := 0;
      Result := UMResult_Fail;
      if Active then
        Close;
    end;
  end;
end;

function TDBSQL.BuyOneUserMarket(var BuyItem: PTMarketLoad): Integer;
var
  SearchStr: string;
  CheckType: Integer;
  ChangeType: Integer;
  ItemIndex: Integer;
begin
  with FADOQuery do
  begin
    CheckType := MARKET_DBSELLTYPE_SELL;
    ChangeType := MARKET_DBSELLTYPE_READYBUY;
    ItemIndex := BuyItem.Index;

    SearchStr := 'Select * from TBL_ITEMMARKET'
      + ' WHERE (FLD_MAKEINDEX = ' + IntToStr(ItemIndex)
      + ' AND FLD_SELLOK = ' + IntToStr(CheckType)
      + ')';

    try
      SQL.Clear;
      SQL.Add(SearchStr);
      if not Active then
        Open;
    except
    end;

    if RecordCount = 1 then
    begin
      if LoadItemFromDB(BuyItem, FADOQuery) then
      begin
        Result := UMRESULT_SUCCESS;
        BuyItem.SellState := ChangeType;
        SearchStr := 'EXEC UM_LOAD_INDEX ' + IntToStr(ItemIndex) + ',' + IntToStr(CheckType) + ',' + IntToStr(ChangeType);
        SQL.Clear;
        SQL.Add(SearchStr);
        ExecSQL;
      end
      else
        Result := UMResult_Fail;
    end
    else
      Result := UMResult_Fail;
    if Active then
      Close;
  end;
end;

function TDBSQL.CancelUserMarket(var Cancelitem: PTMarketLoad): Integer;
var
  SearchStr: string;
  CheckType: Integer;
  ChangeType: Integer;
  ItemIndex: Integer;
begin
  with FADOQuery do
  begin
    CheckType := MARKET_DBSELLTYPE_SELL;
    ChangeType := MARKET_DBSELLTYPE_READYCANCEL;
    ItemIndex := Cancelitem.Index;

    SearchStr := 'Select * from TBL_ITEMMARKET'
      + ' WHERE (FLD_MAKEINDEX = ' + IntToStr(ItemIndex)
      + ' AND FLD_SELLOK = ' + IntToStr(CheckType)
      + ')';

    SQL.Clear;
    SQL.Add(SearchStr);

    try
      if not Active then
        Open;
    except
    end;

    if RecordCount = 1 then
    begin
      if LoadItemFromDB(Cancelitem, FADOQuery) then
      begin
        Cancelitem.SellState := ChangeType;
        Result := UMRESULT_SUCCESS;
        SearchStr := 'EXEC UM_LOAD_INDEX ' + IntToStr(ItemIndex) + ',' + IntToStr(CheckType) + ',' + IntToStr(ChangeType);
        SQL.Clear;
        SQL.Add(SearchStr);
        ExecSQL;
      end
      else
        Result := UMResult_Fail;
    end
    else
      Result := UMResult_Fail;

    if Active then
      Close;
  end;
end;

function TDBSQL.GetPayUserMarket(var GetPayitem: PTMarketLoad): Integer;
var
  SearchStr: string;
  CheckType: Integer;
  ChangeType: Integer;
  ItemIndex: Integer;
begin
  with FADOQuery do
  begin
    CheckType := MARKET_DBSELLTYPE_BUY;
    ChangeType := MARKET_DBSELLTYPE_READYGETPAY;
    ItemIndex := GetPayitem.Index;

    SearchStr := 'Select * from TBL_ITEMMARKET'
      + ' WHERE (FLD_MAKEINDEX = ' + IntToStr(ItemIndex)
      + ' AND FLD_SELLOK = ' + IntToStr(CheckType)
      + ')';

    SQL.Clear;
    SQL.Add(SearchStr);

    try
      if not Active then
        Open;
    except
    end;

    if RecordCount = 1 then
    begin
      if LoadItemFromDB(GetPayitem, FADOQuery) then
      begin
        Result := UMRESULT_SUCCESS;
        GetPayitem.SellState := ChangeType;
        SearchStr := 'EXEC UM_LOAD_INDEX ' + IntToStr(ItemIndex) + ',' + IntToStr(CheckType) + ',' + IntToStr(ChangeType);
        SQL.Clear;
        SQL.Add(SearchStr);
        ExecSQL;
      end
      else
        Result := UMResult_Fail;
    end
    else
      Result := UMResult_Fail;

    if Active then
      Close;
  end;
end;

function TDBSQL.ChkAddSellUserMarket(pSearchInfo: PTSearchSellItem; IsSucess: Boolean): Integer;
var
  SearchStr: string;
  CheckType: Integer;
  ChangeType: Integer;
  MakeIndex: Integer;
  SellWho: string;
  MarketName: string;
begin
  with FADOQuery do
  begin
    CheckType := MARKET_DBSELLTYPE_READYSELL;
    if IsSucess then
      ChangeType := MARKET_DBSELLTYPE_SELL
    else
      ChangeType := MARKET_DBSELLTYPE_DELETE;

    MakeIndex := pSearchInfo.MakeIndex;
    SellWho := pSearchInfo.WHO;
    MarketName := pSearchInfo.MarketName;

    SearchStr := 'EXEC UM_CHECK_MAKEINDEX ''' + MarketName + ''',''' + SellWho + ''',' + IntToStr(MakeIndex) + ',' + IntToStr(CheckType) + ',' + IntToStr(ChangeType);

    try
      SQL.Clear;
      SQL.Add(SearchStr);
      ExecSQL(); //execute no result
    except
    end;

    SearchStr := 'EXEC UM_CHECK_DELETE ''' + MarketName + ''',' + IntToStr(MakeIndex) + ',' + IntToStr(MARKET_DBSELLTYPE_DELETE);
    try
      SQL.Clear;
      SQL.Add(SearchStr);
      ExecSQL(); //execute no result
    except
    end;

    Result := UMRESULT_SUCCESS;
    if Active then
      Close;
  end;
end;

function TDBSQL.ChkBuyOneUserMarket(pSearchInfo: PTSearchSellItem; IsSucess: Boolean): Integer;
var
  SearchStr: string;
  CheckType: Integer;
  ChangeType: Integer;
  Index: Integer;
  SellWho: string;
  MarketName: string;
begin
  with FADOQuery do
  begin
    CheckType := MARKET_DBSELLTYPE_READYBUY;
    if IsSucess then
      ChangeType := MARKET_DBSELLTYPE_BUY
    else
      ChangeType := MARKET_DBSELLTYPE_SELL;
    Index := pSearchInfo.sellindex;
    SellWho := pSearchInfo.WHO;
    MarketName := pSearchInfo.MarketName;

    SearchStr := 'EXEC UM_CHECK_INDEX_BUY ''' + MarketName + ''',''' + SellWho + ''',' + IntToStr(Index) + ',' + IntToStr(CheckType) + ',' + IntToStr(ChangeType);
    //MainOutMessageAPI(SearchStr);
    try
      SQL.Clear;
      SQL.Add(SearchStr);
      ExecSQL();
    except
    end;

    Result := UMRESULT_SUCCESS;
    if Active then  Close;
  end;
end;

function TDBSQL.ChkCancelUserMarket(pSearchInfo: PTSearchSellItem; IsSucess: Boolean): Integer;
var
  SearchStr: string;
  CheckType: Integer;
  ChangeType: Integer;
  Index: Integer;
  SellWho: string;
  MarketName: string;
begin
  with FADOQuery do
  begin
    CheckType := MARKET_DBSELLTYPE_READYCANCEL;
    if IsSucess then
      ChangeType := MARKET_DBSELLTYPE_DELETE
    else
      ChangeType := MARKET_DBSELLTYPE_SELL;

    Index := pSearchInfo.sellindex;
    SellWho := pSearchInfo.WHO;
    MarketName := pSearchInfo.MarketName;

    SearchStr := 'EXEC UM_CHECK_INDEX ''' + MarketName + ''',''' + SellWho + ''',' + IntToStr(Index) + ',' + IntToStr(CheckType) + ',' + IntToStr(ChangeType);

    try
      SQL.Clear;
      SQL.Add(SearchStr);
      ExecSQL();
    except
    end;

    SearchStr := 'EXEC UM_CHECK_DELETE ''' + MarketName + ''',' + IntToStr(Index) + ',' + IntToStr(MARKET_DBSELLTYPE_DELETE);
    try
      SQL.Clear;
      SQL.Add(SearchStr);
      ExecSQL(); //execute no result
    except
    end;

    Result := UMRESULT_SUCCESS;
    if Active then
      Close;
  end;
end;

function TDBSQL.ChkGetPayUserMarket(pSearchInfo: PTSearchSellItem; IsSucess: Boolean): Integer;
var
  SearchStr: string;
  CheckType: Integer;
  ChangeType: Integer;
  Index: Integer;
  SellWho: string;
  MarketName: string;
begin
  with FADOQuery do
  begin
    CheckType := MARKET_DBSELLTYPE_READYGETPAY;
    if IsSucess then
      ChangeType := MARKET_DBSELLTYPE_DELETE
    else
      ChangeType := MARKET_DBSELLTYPE_BUY;

    Index := pSearchInfo.sellindex;
    SellWho := pSearchInfo.WHO;
    MarketName := pSearchInfo.MarketName;

    SearchStr := 'EXEC UM_CHECK_INDEX ''' + MarketName + ''',''' + SellWho + ''',' + IntToStr(Index) + ',' + IntToStr(CheckType) + ',' + IntToStr(ChangeType);

    try
      SQL.Clear;
      SQL.Add(SearchStr);
      ExecSQL();
    except
    end;

    SearchStr := 'EXEC UM_CHECK_DELETE ''' + MarketName + ''',' + IntToStr(Index) + ',' + IntToStr(MARKET_DBSELLTYPE_DELETE);
    try
      SQL.Clear;
      SQL.Add(SearchStr);
      ExecSQL(); //execute no result
    except
    end;

    Result := UMRESULT_SUCCESS;
    if Active then
      Close;
  end;
end;

end.
