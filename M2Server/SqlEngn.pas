unit SqlEngn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  SyncObjs, MudUtil, HUtil32, ObjBase, Grobal2, M2Share, DBSQL;

const
  // GAME --> DB
  LOADTYPE_REQGETLIST = 100;
  LOADTYPE_REQBUYITEM = 101;
  LOADTYPE_REQSELLITEM = 102;
  LOADTYPE_REQGETPAYITEM = 103;
  LOADTYPE_REQCANCELITEM = 104;
  LOADTYPE_REQREADYTOSELL = 105;
  LOADTYPE_REQCHECKTODB = 106;

  // DB --> GAME
  LOADTYPE_GETLIST = 200;
  LOADTYPE_BUYITEM = 201;
  LOADTYPE_SELLITEM = 202;
  LOADTYPE_GETPAYITEM = 203;
  LOADTYPE_CANCELITEM = 204;
  LOADTYPE_READYTOSELL = 205;

  KIND_NOTICE = 0;
  KIND_GENERAL = 1;
  KIND_ERROR = 255;

  // GAME --> DB
  GABOARD_REQGETLIST = 500;
  GABOARD_REQADDARTICLE = 501;
  GABOARD_REQDELARTICLE = 502;
  GABOARD_REQEDITARTICLE = 503;

  // DB --> GAME
  GABOARD_GETLIST = 600;
  GABOARD_ADDARTICLE = 601;
  GABOARD_DELARTICLE = 602;
  GABOARD_EDITARTICLE = 603;

type
  TSqlLoadRecord = record
    loadType: Integer;
    UserName: string[20];
    pRcd: Pointer; //
  end;
  PTSqlLoadRecord = ^TSqlLoadRecord;

  TSQLEngine = class(TThread)
  private
    SqlToDBList: TList;
    DbToGameList: TList;
    FActive: Boolean;
    procedure AddToDBList(pInfo: PTSqlLoadRecord);
    procedure AddToGameList(pInfo: PTSqlLoadRecord);
    function GetGameExecuteData: PTSqlLoadRecord;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ExecuteSaveCommand;
    function ExecuteLoadCommand: Integer;
    function RequestLoadPageUserMarket(ReqInfo_: TMarKetReqInfo): Boolean;
    function RequestSellItemUserMarket(UserName: string; pselladd: PTMarketLoad): Boolean;
    function RequestReadyToSellUserMarket(UserName: string; MarketName: string; SellWho: string): Boolean;
    function RequestBuyItemUserMarket(UserName: string; MarketName: string; BuyWho: string; sellindex: Integer): Boolean;
    function RequestCancelSellUserMarket(UserName: string; MarketName: string; SellWho: string; sellindex: Integer): Boolean;
    function RequestGetPayUserMarket(UserName: string; MarketName: string; SellWho: string; sellindex: Integer): Boolean;
    procedure CheckToDB(UserName: string; MarketName: string; SellWho: string; makeindex_: Integer; sellindex: Integer; CheckType: Integer);
    procedure Open(WantOpen: Boolean);
    procedure ExecuteRun;

    //function RequestLoadGuildAgitBoard(UserName, gname: string): Boolean;
    //function RequestGuildAgitBoardAddArticle(gname: string; OrgNum, SrcNum1, SrcNum2, SrcNum3, nKind, AgitNum: Integer; uname, data: string): Boolean;
    //function RequestGuildAgitBoardDelArticle(gname: string; OrgNum, SrcNum1, SrcNum2, SrcNum3: Integer; uname: string): Boolean;
    //function RequestGuildAgitBoardDelAll(gname: string; AgitNum: Integer; uname: string): Boolean;
    //function RequestGuildAgitBoardEditArticle(gname: string; OrgNum, SrcNum1, SrcNum2, SrcNum3: Integer; uname, data: string): Boolean;

  end;

var
  g_SQlEngine: TSQLEngine;
  g_UMDEBUG: Integer;

implementation

uses
  svMain;

constructor TSQLEngine.Create;
begin
  SqlToDBList := TList.Create;
  DbToGameList := TList.Create;
  FActive := True;
  g_UMDEBUG := 0;
  inherited Create(False);
  //FreeOnTerminate := TRUE;
end;

destructor TSQLEngine.Destroy;
begin
  SqlToDBList.Free;
  DbToGameList.Free;
  inherited Destroy;
end;

procedure TSQLEngine.Open(WantOpen: Boolean);
begin
  EnterCriticalSection(SQLCriticalSection);
  try
    FActive := WantOpen;
  finally
    LeaveCriticalSection(SQLCriticalSection);
  end;
end;

procedure TSQLEngine.ExecuteSaveCommand;
begin

end;

function TSQLEngine.ExecuteLoadCommand: Integer;
var
  pload: PTSqlLoadRecord;
  bExit: Boolean;
  pSearchInfo: PTSearchSellItem;
  pLoadInfo: PTMarketLoad;
  rInfoList: TList;
  SqlResult: Integer;
  loadType: Integer;
begin
  Result := 0;
  bExit := False;
  pload := nil;
  while not bExit do
  begin
    Result := 1;
    try
      if not g_DBSQL.Connected then
      begin
        g_DBSQL.ReConnect;
        Continue;
      end;
    except
      MainOutMessageAPI('[Exception] ExecuteLoadCommand - g_DBSQL.Connected');
    end;

    try
      Result := 2;
      EnterCriticalSection(SQLCriticalSection);
      try
        if SqlToDBList <> nil then
        begin
          if SqlToDBList.Count > 0 then
          begin
            if SqlToDBList.Items[0] = nil then
              MainOutMessageAPI('SQLToDBList.Items[0] = nil' + ' [' + IntToStr(g_UMDEBUG) + ']');
            pload := SqlToDBList.Items[0];
            SqlToDBList.Delete(0);
            if g_UMDEBUG = 1000 then
            begin
              MainOutMessageAPI('SQLToDBList.Delete(0) count:' + IntToStr(SqlToDBList.Count) + ' [' + IntToStr(g_UMDEBUG) + ']');
              g_UMDEBUG := 6;
              bExit := False;
            end
            else
            begin
              g_UMDEBUG := 2;
              bExit := False;
            end;
          end
          else
          begin
            g_UMDEBUG := 3;
            pload := nil;
            bExit := True;
          end;
        end
        else
        begin
          if g_UMDEBUG = 1000 then
            MainOutMessageAPI('SqlToDBList = nil' + ' [' + IntToStr(g_UMDEBUG) + ']');
          g_UMDEBUG := 4;
          pload := nil;
          bExit := True;
        end;
      finally
        LeaveCriticalSection(SQLCriticalSection);
      end;

      Result := 3;
      if pload <> nil then
      begin
        loadType := pload.loadType;
        if (g_UMDEBUG > 0) and (g_UMDEBUG <> 2) then
          MainOutMessageAPI('[TestCode] ExecuteLoadCommand LoadType : ' + IntToStr(loadType) + ' [' + IntToStr(g_UMDEBUG) + ']');
        g_UMDEBUG := 5;

        Result := 30000 + loadType; //extended bug result
        case pload.loadType of
          LOADTYPE_REQGETLIST:
            begin
              g_UMDEBUG := 11;
              Result := 4;
              pSearchInfo := PTSearchSellItem(pload.pRcd);
              g_UMDEBUG := 12;
              if pSearchInfo <> nil then
              begin
                rInfoList := TList.Create;
                g_UMDEBUG := 21;
                if g_DBSQL = nil then
                  MainOutMessageAPI('[Exception] g_DBSql = nil');
                SqlResult := g_DBSQL.LoadPageUserMarket(
                  pSearchInfo.MarketName,
                  pSearchInfo.WHO,
                  pSearchInfo.ItemName,
                  pSearchInfo.ItemType,
                  pSearchInfo.ItemSet,
                  rInfoList
                  );
                //if rInfoList = nil then MainOutMessageAPI('[Exception] rInfoList = nil');
                g_UMDEBUG := 22;
                pSearchInfo.IsOK := SqlResult;
                pSearchInfo.pList := rInfoList;
                g_UMDEBUG := 23;
                g_UMDEBUG := 24;
                pload.loadType := LOADTYPE_GETLIST;
                g_UMDEBUG := 13;
                AddToGameList(pload);
                pSearchInfo := nil;
                pload := nil;
                g_UMDEBUG := 14;
              end
              else
              begin
                if g_UMDEBUG > 0 then
                  MainOutMessageAPI('[TestCode]ExecuteLoadCommand : pSearchInfo = nil' + IntToStr(loadType) + ' [' + IntToStr(g_UMDEBUG) + ']');
                g_UMDEBUG := 15;
              end;
            end;
          LOADTYPE_REQBUYITEM:
            begin
              Result := 5; //bug result
              g_UMDEBUG := 25;
              pLoadInfo := PTMarketLoad(pload.pRcd);
              if pLoadInfo <> nil then
              begin
                SqlResult := g_DBSQL.BuyOneUserMarket(pLoadInfo);
                pLoadInfo.IsOK := SqlResult;
                pload.loadType := LOADTYPE_BUYITEM;
                AddToGameList(pload);
                pLoadInfo := nil;
                pload := nil;
              end;
            end;
          LOADTYPE_REQSELLITEM:
            begin
              Result := 6; //bug result
              g_UMDEBUG := 16;
              pLoadInfo := PTMarketLoad(pload.pRcd);
              if pLoadInfo <> nil then
              begin
                g_UMDEBUG := 17;
                SqlResult := g_DBSQL.AddSellUserMarket(pLoadInfo);
                pLoadInfo.IsOK := SqlResult;
                pload.loadType := LOADTYPE_SELLITEM;
                AddToGameList(pload);
                pLoadInfo := nil;
                pload := nil;
                g_UMDEBUG := 18;
              end
              else
              begin
                g_UMDEBUG := 19;
              end;

            end;
          LOADTYPE_REQREADYTOSELL:
            begin
              Result := 7; //bug result
              g_UMDEBUG := 26;
              pLoadInfo := PTMarketLoad(pload.pRcd);
              g_UMDEBUG := 30;
              if pLoadInfo <> nil then
              begin
                SqlResult := g_DBSQL.ReadyToSell(pLoadInfo);
                pLoadInfo.IsOK := SqlResult;
                pload.loadType := LOADTYPE_READYTOSELL;
                AddToGameList(pload);
                pLoadInfo := nil;
                pload := nil;
              end;
              g_UMDEBUG := 31;
            end;
          LOADTYPE_REQCANCELITEM:
            begin
              Result := 8;
              g_UMDEBUG := 27;
              pLoadInfo := PTMarketLoad(pload.pRcd);
              if pLoadInfo <> nil then
              begin
                SqlResult := g_DBSQL.CancelUserMarket(pLoadInfo);
                pLoadInfo.IsOK := SqlResult;
                pload.loadType := LOADTYPE_CANCELITEM;
                AddToGameList(pload);
                pLoadInfo := nil;
                pload := nil;
              end;
            end;
          LOADTYPE_REQGETPAYITEM:
            begin
              Result := 9; //bug result
              g_UMDEBUG := 28;
              pLoadInfo := PTMarketLoad(pload.pRcd);
              if pLoadInfo <> nil then
              begin
                SqlResult := g_DBSQL.GetPayUserMarket(pLoadInfo);
                pLoadInfo.IsOK := SqlResult;
                pload.loadType := LOADTYPE_GETPAYITEM;
                AddToGameList(pload);
                pLoadInfo := nil;
                pload := nil;
              end;
            end;
          LOADTYPE_REQCHECKTODB:
            begin
              Result := 10; //bug result
              g_UMDEBUG := 29;
              pSearchInfo := PTSearchSellItem(pload.pRcd);
              if pSearchInfo <> nil then
              begin
                case pSearchInfo.CheckType of
                  MARKET_CHECKTYPE_SELLOK: g_DBSQL.ChkAddSellUserMarket(pSearchInfo, True);
                  MARKET_CHECKTYPE_SELLFAIL: g_DBSQL.ChkAddSellUserMarket(pSearchInfo, False);
                  MARKET_CHECKTYPE_BUYOK: g_DBSQL.ChkBuyOneUserMarket(pSearchInfo, True);
                  MARKET_CHECKTYPE_BUYFAIL: g_DBSQL.ChkBuyOneUserMarket(pSearchInfo, False);
                  MARKET_CHECKTYPE_CANCELOK: g_DBSQL.ChkCancelUserMarket(pSearchInfo, True);
                  MARKET_CHECKTYPE_CANCELFAIL: g_DBSQL.ChkCancelUserMarket(pSearchInfo, False);
                  MARKET_CHECKTYPE_GETPAYOK: g_DBSQL.ChkGetPayUserMarket(pSearchInfo, True);
                  MARKET_CHECKTYPE_GETPAYFAIL: g_DBSQL.ChkGetPayUserMarket(pSearchInfo, False);
                end;
                //FreeMem(pSearchInfo);
                Dispose(pSearchInfo);
                pSearchInfo := nil;
              end;
            end;
        else
          begin
            Result := 170000 + loadType; //extended bug result
            if g_UMDEBUG > 0 then
              MainOutMessageAPI('[TestCode]ExecuteLoadCommand : case else LoadType' + IntToStr(loadType) + ' [' + IntToStr(g_UMDEBUG) + ']');
            g_UMDEBUG := 20;
          end;
        end;

        Result := 15;
        if pload <> nil then
        begin
          Result := 16;
          Dispose(pload);
          pload := nil;
        end;
        //if g_TestTime = 12 then
        //  MainOutMessage('SQLEng Load :' + IntToStr(GetTickCount - loadtime) + ',' + IntToStr(loadType));
      end;
    except
      on E: Exception do
      begin
        MainOutMessageAPI('[Exception] ExecuteLoadCommand - ' + IntToStr(Result) + ' ' + IntToStr(g_UMDEBUG) + ' ' + E.Message);
      end;
    end;
  end;
end;

procedure TSQLEngine.Execute;
var
  buginfo: Integer;
begin
  buginfo := 0;
  Suspend;
  while not Terminated do
  begin
    //try
    //  ExecuteSaveCommand;
    //except
    //  MainOutMessageAPI('EXCEPTION SQLEngine.ExecuteSaveCommand');
    //end;
    try
      buginfo := ExecuteLoadCommand;
    except
      MainOutMessageAPI('[Exception] :: TSQLEngine.ExecuteLoadCommand ' + IntToStr(buginfo) + ' [' + IntToStr(g_UMDEBUG) + ']');
      if buginfo = 3 then
        g_UMDEBUG := 1000;
    end;
    Sleep(1);
  end;
end;

// GAME SERVER ==> DB ==============================================

procedure TSQLEngine.AddToDBList(pInfo: PTSqlLoadRecord);
begin
  if pInfo = nil then
    Exit;
  EnterCriticalSection(SQLCriticalSection);
  try
    SqlToDBList.Add(pInfo);
  finally
    LeaveCriticalSection(SQLCriticalSection);
  end;
end;

function TSQLEngine.RequestLoadPageUserMarket(ReqInfo_: TMarKetReqInfo): Boolean;
var
  pload: PTSqlLoadRecord;
  flag: Boolean;
begin
  Result := False;
  EnterCriticalSection(SQLCriticalSection);
  try
    flag := FActive;
  finally
    LeaveCriticalSection(SQLCriticalSection);
  end;

  if not flag then
    Exit;

  New(pload);
  pload.loadType := LOADTYPE_REQGETLIST;
  pload.UserName := ReqInfo_.UserName;
  GetMem(pload.pRcd, SizeOf(TSearchSellItem));
  PTSearchSellItem(pload.pRcd).MarketName := ReqInfo_.MarketName;
  PTSearchSellItem(pload.pRcd).WHO := ReqInfo_.SearchWho;
  PTSearchSellItem(pload.pRcd).ItemName := ReqInfo_.SearchItem;
  PTSearchSellItem(pload.pRcd).ItemType := ReqInfo_.ItemType;
  PTSearchSellItem(pload.pRcd).ItemSet := ReqInfo_.ItemSet;
  PTSearchSellItem(pload.pRcd).UserMode := ReqInfo_.UserMode;

  if pload = nil then
    Exit;
  AddToDBList(pload);

  if g_UMDEBUG = 1000 then
    MainOutMessageAPI('[Debug] RequestLoadPageUserMarket-AddToDBList' + ' [' + IntToStr(g_UMDEBUG) + ']');
  g_UMDEBUG := 1;

  Result := True;

end;

function TSQLEngine.RequestReadyToSellUserMarket(UserName: string; MarketName: string; SellWho: string): Boolean;
var
  pload: PTSqlLoadRecord;
begin
  Result := False;
  if not FActive then
    Exit;
  New(pload);
  pload.loadType := LOADTYPE_REQREADYTOSELL;
  pload.UserName := UserName;
  GetMem(pload.pRcd, SizeOf(TMarketLoad));
  PTMarketLoad(pload.pRcd).MarketName := MarketName;
  PTMarketLoad(pload.pRcd).SellWho := SellWho;
  if pload = nil then
    Exit;
  AddToDBList(pload);
  Result := True;
end;

//아이템 사기를 요청한다.

function TSQLEngine.RequestBuyItemUserMarket(
  UserName: string;
  MarketName: string;
  BuyWho: string;
  sellindex: Integer
  ): Boolean;
var
  pload: PTSqlLoadRecord;
begin
  Result := False;
  if not FActive then
    Exit;
  New(pload);
  pload.loadType := LOADTYPE_REQBUYITEM;
  pload.UserName := UserName;
  GetMem(pload.pRcd, SizeOf(TMarketLoad));
  PTMarketLoad(pload.pRcd).MarketName := MarketName;
  PTMarketLoad(pload.pRcd).SellWho := BuyWho;
  PTMarketLoad(pload.pRcd).Index := sellindex;
  if pload = nil then
    Exit;
  AddToDBList(pload);
  Result := True;
end;

procedure TSQLEngine.CheckToDB(
  UserName: string;
  MarketName: string;
  SellWho: string;
  makeindex_: Integer;
  sellindex: Integer;
  CheckType: Integer
  );
var
  pload: PTSqlLoadRecord;
begin
  if not FActive then
  begin
    MainOutMessageAPI('[TestCode2] TSqlEngine.CheckToDB FActive is FALSE');
  end;

  New(pload);
  pload.loadType := LOADTYPE_REQCHECKTODB;
  pload.UserName := UserName;
  GetMem(pload.pRcd, SizeOf(TSearchSellItem));
  PTSearchSellItem(pload.pRcd).CheckType := CheckType;
  PTSearchSellItem(pload.pRcd).MarketName := MarketName;
  PTSearchSellItem(pload.pRcd).WHO := SellWho;
  PTSearchSellItem(pload.pRcd).MakeIndex := makeindex_;
  PTSearchSellItem(pload.pRcd).sellindex := sellindex;

  if pload = nil then
    Exit;
  AddToDBList(pload);

end;

function TSQLEngine.RequestSellItemUserMarket(UserName: string; pselladd: PTMarketLoad): Boolean;
var
  pload: PTSqlLoadRecord;
begin
  Result := False;
  if not FActive then
    Exit;

  New(pload);
  pload.loadType := LOADTYPE_REQSELLITEM;

  pload.UserName := UserName;
  GetMem(pload.pRcd, SizeOf(TMarketLoad));
  Move(pselladd^, pload.pRcd^, SizeOf(TMarketLoad));

  if pload = nil then
    Exit;
  AddToDBList(pload);

  Result := True;
end;

function TSQLEngine.RequestGetPayUserMarket(
  UserName: string;
  MarketName: string;
  SellWho: string;
  sellindex: Integer
  ): Boolean;
var
  pload: PTSqlLoadRecord;
begin
  Result := False;
  if not FActive then
    Exit;

  New(pload);
  pload.loadType := LOADTYPE_REQGETPAYITEM;

  pload.UserName := UserName;
  GetMem(pload.pRcd, SizeOf(TMarketLoad));

  PTMarketLoad(pload.pRcd).MarketName := MarketName;
  PTMarketLoad(pload.pRcd).SellWho := SellWho;
  PTMarketLoad(pload.pRcd).Index := sellindex;

  if pload = nil then
    Exit;
  AddToDBList(pload);

  Result := True;
end;

function TSQLEngine.RequestCancelSellUserMarket(
  UserName: string;
  MarketName: string;
  SellWho: string;
  sellindex: Integer
  ): Boolean;
var
  pload: PTSqlLoadRecord;
begin
  Result := False;
  if not FActive then
    Exit;

  New(pload);
  pload.loadType := LOADTYPE_REQCANCELITEM;

  pload.UserName := UserName;
  GetMem(pload.pRcd, SizeOf(TMarketLoad));

  PTMarketLoad(pload.pRcd).MarketName := MarketName;
  PTMarketLoad(pload.pRcd).SellWho := SellWho;
  PTMarketLoad(pload.pRcd).Index := sellindex;

  if pload = nil then
    Exit;
  AddToDBList(pload);

  Result := True;
end;

// DB --> GAME SERVER =============================================

procedure TSQLEngine.AddToGameList(pInfo: PTSqlLoadRecord);
begin
  if pInfo = nil then
    Exit;
  EnterCriticalSection(SQLCriticalSection);
  try
    DbToGameList.Add(pInfo);
  finally
    LeaveCriticalSection(SQLCriticalSection);
  end;
end;

function TSQLEngine.GetGameExecuteData: PTSqlLoadRecord;
begin
  Result := nil;
  EnterCriticalSection(SQLCriticalSection);
  try
    if DbToGameList <> nil then
    begin
      if DbToGameList.Count > 0 then
      begin
        Result := DbToGameList.Items[0];
        DbToGameList.Delete(0);
      end;
    end;
  finally
    LeaveCriticalSection(SQLCriticalSection);
  end;
end;

procedure TSQLEngine.ExecuteRun;
var
  pload: PTSqlLoadRecord;
  pSearchInfo: PTSearchSellItem;
  pLoadInfo: PTMarketLoad;
  hum: TPlayObject;
  i: Integer;
begin
  try
    pload := GetGameExecuteData;
    if pload <> nil then
    begin
      case pload.loadType of
        LOADTYPE_GETLIST:
          begin
            pSearchInfo := pload.pRcd;
            if pSearchInfo <> nil then
            begin
              hum := UserEngine.GetPlayObjectCS_Name(pload.UserName);
              if hum <> nil then
              begin
                hum.GetMarketData(pSearchInfo);
                hum.SendUserMarketList(0);
              end
              else
              begin
                //MainOutMessageAPI('INFO SQLENGINE DO NOT FIND USER FOR MARKETLIST!');
              end;

              if pSearchInfo.pList <> nil then
              begin
                for i := pSearchInfo.pList.Count - 1 downto 0 do
                begin
                  if pSearchInfo.pList.Items[0] <> nil then
                    Dispose(pSearchInfo.pList.Items[0]);
                  pSearchInfo.pList.Delete(0);
                end;
                pSearchInfo.pList.Free;
                pSearchInfo.pList := nil;
              end;
            end;
          end;
        LOADTYPE_SELLITEM:
          begin
            pLoadInfo := pload.pRcd;
            if pLoadInfo <> nil then
            begin
              hum := UserEngine.GetPlayObjectCS_Name(pload.UserName);
              if hum <> nil then
              begin
                hum.SellUserMarket(pLoadInfo);
              end
              else
              begin
                //MainOutMessageAPI('INFO SQLENGINE DO NOT FIND USER FOR SELLITEM!');
              end;
            end;
          end;
        LOADTYPE_READYTOSELL:
          begin
            pLoadInfo := pload.pRcd;
            if pLoadInfo <> nil then
            begin
              hum := UserEngine.GetPlayObjectCS_Name(pload.UserName);
              if hum <> nil then
                hum.ReadyToSellUserMarket(pLoadInfo)
              else
                //MainOutMessageAPI('INFO SQLENGINE DO NOT FIND USER FOR SELLITEM!');
            end;
          end;
        LOADTYPE_BUYITEM:
          begin
            pLoadInfo := pload.pRcd;
            if pLoadInfo <> nil then
            begin
              hum := UserEngine.GetPlayObjectCS_Name(pload.UserName);
              if hum <> nil then
              begin
                hum.BuyUserMarket(pLoadInfo);
              end
              else
              begin
                //MainOutMessageAPI('INFO SQLENGINE DO NOT FIND USER FOR SELLITEM!');
              end;
            end;
          end;
        LOADTYPE_CANCELITEM:
          begin
            pLoadInfo := pload.pRcd;
            if pLoadInfo <> nil then
            begin
              hum := UserEngine.GetPlayObjectCS_Name(pload.UserName);
              if hum <> nil then
              begin
                hum.CancelUserMarket(pLoadInfo);
              end
              else
              begin
                //MainOutMessageAPI('INFO SQLENGINE DO NOT FIND USER FOR CANCEL!');
              end;
            end;
          end;
        LOADTYPE_GETPAYITEM:
          begin
            pLoadInfo := pload.pRcd;
            if pLoadInfo <> nil then
            begin
              hum := UserEngine.GetPlayObjectCS_Name(pload.UserName);
              if hum <> nil then
              begin
                hum.GetPayUserMarket(pLoadInfo);
              end
              else
              begin
                //MainOutMessageAPI('INFO SQLENGINE DO NOT FIND USER FOR GETPAY!');
              end;
            end;
          end;

        {GABOARD_GETLIST: begin
            pBoardListInfo := pload.pRcd;
            if pBoardListInfo <> nil then begin
              if pBoardListInfo.GuildName <> '' then begin
                GuildAgitBoardMan.AddGaBoardList(pBoardListInfo);
                hum := UserEngine.GetPlayObject(pBoardListInfo.UserName);
                if hum <> nil then begin
                  hum.CmdReloadGaBoardList(pBoardListInfo.GuildName, 1);
                end;
              end;
              if pBoardListInfo.ArticleList <> nil then begin
                for i := pBoardListInfo.ArticleList.count - 1 downto 0 do begin
                  if pBoardListInfo.ArticleList.Items[0] <> nil then
                    Dispose(pBoardListInfo.ArticleList.Items[0]);
                  pBoardListInfo.ArticleList.Delete(0);
                end;
                pBoardListInfo.ArticleList.Free;
                pBoardListInfo.ArticleList := nil;
              end;
            end;
          end;
        GABOARD_ADDARTICLE:
          begin
            pArticleInfo := pload.pRcd;
            if pArticleInfo <> nil then begin
              //GuildAgitBoardMan.LoadAllGaBoardList( pArticleInfo.UserName );
            end;
          end;
        GABOARD_DELARTICLE:
          begin
            pArticleInfo := pload.pRcd;

            if pArticleInfo <> nil then begin
              //GuildAgitBoardMan.LoadAllGaBoardList( pArticleInfo.UserName );
            end;
          end;
        GABOARD_EDITARTICLE:
          begin
            pArticleInfo := pload.pRcd;

            if pArticleInfo <> nil then begin
              //GuildAgitBoardMan.LoadAllGaBoardList( pArticleInfo.UserName );
            end;
          end;}
      end;

      if pload.pRcd <> nil then
        FreeMem(pload.pRcd);
      Dispose(pload);
      pload := nil;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI('[Exception] TSQLEngine.ExecuteRun ' + E.Message);
    end;
  end;
end;

(*
function TSQLEngine.RequestLoadGuildAgitBoard(UserName, gname: string): Boolean;
var
  pload                     : PTSqlLoadRecord;
begin
  Result := FALSE;
  if not FActive then Exit;

  New(pload);
  pload.loadType := GABOARD_REQGETLIST;
  pload.UserName := UserName;
  GetMem(pload.pRcd, SizeOf(TSearchGaBoardList));

   // 읽는 종류 생성
  PTSearchGaBoardList(pload.pRcd).AgitNum := 0;
  PTSearchGaBoardList(pload.pRcd).GuildName := gname; //장원이름으로 찾기.
  PTSearchGaBoardList(pload.pRcd).OrgNum := -1;
  PTSearchGaBoardList(pload.pRcd).SrcNum1 := -1;
  PTSearchGaBoardList(pload.pRcd).SrcNum2 := -1;
  PTSearchGaBoardList(pload.pRcd).SrcNum3 := -1;
  PTSearchGaBoardList(pload.pRcd).Kind := KIND_GENERAL;
  PTSearchGaBoardList(pload.pRcd).UserName := UserName;

   {debug code} if pload = nil then Exit;
  AddToDBList(pload);

  Result := TRUE;
end;

function TSQLEngine.RequestGuildAgitBoardAddArticle(gname: string; OrgNum, SrcNum1, SrcNum2, SrcNum3, nKind, AgitNum: Integer; uname, data: string): Boolean;
var
  pload                     : PTSqlLoadRecord;
begin
  Result := FALSE;
  if not FActive then Exit;

   // 읽기 레코드 생성
  New(pload);
  pload.loadType := GABOARD_REQADDARTICLE;
  pload.UserName := uname;
  GetMem(pload.pRcd, SizeOf(TGaBoardArticleLoad));

   // 읽는 종류 생성
  PTGaBoardArticleLoad(pload.pRcd).AgitNum := AgitNum;
  PTGaBoardArticleLoad(pload.pRcd).GuildName := gname;
  PTGaBoardArticleLoad(pload.pRcd).OrgNum := OrgNum;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum1 := SrcNum1;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum2 := SrcNum2;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum3 := SrcNum3;
  PTGaBoardArticleLoad(pload.pRcd).Kind := nKind;
  PTGaBoardArticleLoad(pload.pRcd).UserName := uname;
  FillChar(PTGaBoardArticleLoad(pload.pRcd).Content, SizeOf(PTGaBoardArticleLoad(pload.pRcd).Content), #0);
  StrPLCopy(PTGaBoardArticleLoad(pload.pRcd).Content, data, SizeOf(PTGaBoardArticleLoad(pload.pRcd).Content) - 1);

   {debug code} if pload = nil then Exit;
  AddToDBList(pload);

  Result := TRUE;
end;

function TSQLEngine.RequestGuildAgitBoardDelArticle(gname: string; OrgNum, SrcNum1, SrcNum2, SrcNum3: Integer; uname: string): Boolean;
var
  pload                     : PTSqlLoadRecord;
begin
  Result := FALSE;
  if not FActive then Exit;

   // 읽기 레코드 생성
  New(pload);
  pload.loadType := GABOARD_REQDELARTICLE;
  pload.UserName := uname;
  GetMem(pload.pRcd, SizeOf(TGaBoardArticleLoad));

   // 읽는 종류 생성
  PTGaBoardArticleLoad(pload.pRcd).AgitNum := 0;
  PTGaBoardArticleLoad(pload.pRcd).GuildName := gname;
  PTGaBoardArticleLoad(pload.pRcd).OrgNum := OrgNum;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum1 := SrcNum1;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum2 := SrcNum2;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum3 := SrcNum3;
  PTGaBoardArticleLoad(pload.pRcd).Kind := KIND_ERROR;
  PTGaBoardArticleLoad(pload.pRcd).UserName := uname;
  FillChar(PTGaBoardArticleLoad(pload.pRcd).Content, SizeOf(PTGaBoardArticleLoad(pload.pRcd).Content), #0);

   {debug code} if pload = nil then Exit;
  AddToDBList(pload);

  Result := TRUE;
end;

function TSQLEngine.RequestGuildAgitBoardDelAll(gname: string; AgitNum: Integer; uname: string): Boolean;
var
  pload                     : PTSqlLoadRecord;
begin
  Result := FALSE;
  if not FActive then Exit;

  if AgitNum = 0 then Exit;

   // 읽기 레코드 생성
  New(pload);
  pload.loadType := GABOARD_REQDELARTICLE;
  pload.UserName := uname;
  GetMem(pload.pRcd, SizeOf(TGaBoardArticleLoad));

   // 읽는 종류 생성
  PTGaBoardArticleLoad(pload.pRcd).AgitNum := AgitNum;
  PTGaBoardArticleLoad(pload.pRcd).GuildName := gname;
  PTGaBoardArticleLoad(pload.pRcd).OrgNum := 0;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum1 := 0;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum2 := 0;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum3 := 0;
  PTGaBoardArticleLoad(pload.pRcd).Kind := KIND_ERROR;
  PTGaBoardArticleLoad(pload.pRcd).UserName := uname;
  FillChar(PTGaBoardArticleLoad(pload.pRcd).Content, SizeOf(PTGaBoardArticleLoad(pload.pRcd).Content), #0);

   {debug code} if pload = nil then Exit;
  AddToDBList(pload);

  Result := TRUE;
end;

function TSQLEngine.RequestGuildAgitBoardEditArticle(gname: string; OrgNum, SrcNum1, SrcNum2, SrcNum3: Integer; uname, data: string): Boolean;
var
  pload                     : PTSqlLoadRecord;
begin
  Result := FALSE;
  if not FActive then Exit;

   // 읽기 레코드 생성
  New(pload);
  pload.loadType := GABOARD_REQEDITARTICLE;
  pload.UserName := uname;
  GetMem(pload.pRcd, SizeOf(TGaBoardArticleLoad));

   // 읽는 종류 생성
  PTGaBoardArticleLoad(pload.pRcd).AgitNum := 0;
  PTGaBoardArticleLoad(pload.pRcd).GuildName := gname;
  PTGaBoardArticleLoad(pload.pRcd).OrgNum := OrgNum;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum1 := SrcNum1;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum2 := SrcNum2;
  PTGaBoardArticleLoad(pload.pRcd).SrcNum3 := SrcNum3;
  PTGaBoardArticleLoad(pload.pRcd).Kind := KIND_ERROR;
  PTGaBoardArticleLoad(pload.pRcd).UserName := uname;
  FillChar(PTGaBoardArticleLoad(pload.pRcd).Content, SizeOf(PTGaBoardArticleLoad(pload.pRcd).Content), #0);
  StrPLCopy(PTGaBoardArticleLoad(pload.pRcd).Content, data, SizeOf(PTGaBoardArticleLoad(pload.pRcd).Content) - 1);

   {debug code} if pload = nil then Exit;
  AddToDBList(pload);

  Result := TRUE;
end;
*)

end.
