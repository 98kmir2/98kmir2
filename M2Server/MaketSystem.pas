unit MaketSystem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  Grobal2;

type
  TMarketItemManager = class //(TObject)
  private
    FState: Integer;
    // FMaxPage: Integer;
    FCurrPage: Integer;
    FLoadedpage: Integer;
    FItems: TList;
    FSelectedIndex: Integer;
    FUserMode: Integer;
    FItemType: Integer;
  private
    procedure RemoveAll;
    procedure InitFirst;
    function CheckIndex(index_: Integer): Boolean;
  public
    ReqInfo: TMarKetReqInfo;
    constructor Create;
    destructor Destroy; override;
    procedure Load;
    procedure ReLoad;
    procedure Add(pInfo_: PTMarketItem);
    procedure Delete(index_: Integer);
    procedure Clear;

    function GetItem(index_: Integer; var rSelected: Boolean): PTMarketItem; overload;
    function GetItem(index_: Integer): PTMarketItem; overload;
    function IsExistIndex(index_: Integer; var rMoney_: Integer): Boolean;
    function IsMyItem(index_: Integer; CharName_: string): Boolean;
    function select(index_: Integer): Boolean;
    function IsEmpty: Boolean;
    function Count: Integer;
    function PageCount: Integer;

    procedure OnMsgReadData;
    procedure OnMsgWriteData;

    property UserMode: Integer read FUserMode write FUserMode;
    property ItemType: Integer read FItemType write FItemType;
    property LodedPage: Integer read FLoadedpage;
    property CurrPage: Integer read FCurrPage write FCurrPage;

  end;

implementation

constructor TMarketItemManager.Create;
begin
  InitFirst;
end;

destructor TMarketItemManager.Destroy;
begin
  RemoveAll;
  FItems.Free;
  inherited;
end;

procedure TMarketItemManager.RemoveAll;
var
  i: Integer;
  pInfo: PTMarketItem;
begin
  for i := FItems.Count - 1 downto 0 do
  begin
    pInfo := FItems.Items[i];
    //if pInfo <> nil then
    Dispose(pInfo);
  end;
  FItems.Clear;

  FState := MAKET_STATE_EMPTY;
end;

function TMarketItemManager.CheckIndex(index_: Integer): Boolean;
begin
  if (index_ >= 0) and (index_ < FItems.Count) then
    Result := True
  else
    Result := False;
end;

procedure TMarketItemManager.InitFirst;
begin
  FItems := TList.Create;
  FSelectedIndex := -1;
  FState := MAKET_STATE_EMPTY;

  ReqInfo.UserName := '';
  ReqInfo.MarketName := '';
  ReqInfo.SearchWho := '';
  ReqInfo.SearchItem := '';
  ReqInfo.ItemType := 0;
  ReqInfo.ItemSet := 0;
  ReqInfo.UserMode := 0;

end;

procedure TMarketItemManager.Load;
begin
  if IsEmpty and (FState = MAKET_STATE_EMPTY) then
  begin
    OnMsgReadData;
  end;
end;

procedure TMarketItemManager.ReLoad;
begin
  if not IsEmpty then
    RemoveAll;
  Load;
end;

procedure TMarketItemManager.Add(pInfo_: PTMarketItem);
begin
  if (FItems <> nil) and (pInfo_ <> nil) then
    FItems.Add(pInfo_);
  if (FItems.Count mod MAKET_ITEMCOUNT_PER_PAGE) = 0 then
    FLoadedpage := (FItems.Count div MAKET_ITEMCOUNT_PER_PAGE)
  else
    FLoadedpage := (FItems.Count div MAKET_ITEMCOUNT_PER_PAGE) + 1;
end;

procedure TMarketItemManager.Delete(index_: Integer);
begin

end;

procedure TMarketItemManager.Clear;
begin
  RemoveAll;
  FSelectedIndex := -1;
  FState := MAKET_STATE_EMPTY;
end;

function TMarketItemManager.select(index_: Integer): Boolean;
begin
  Result := False;
  if CheckIndex(index_) then
  begin
    FSelectedIndex := index_;
    Result := True;
  end;
end;

function TMarketItemManager.IsEmpty: Boolean;
begin
  if FItems.Count > 0 then
    Result := False
  else
    Result := True;
end;

function TMarketItemManager.Count: Integer;
begin
  Result := FItems.Count;
end;

function TMarketItemManager.PageCount: Integer;
begin
  if FItems.Count mod MAKET_ITEMCOUNT_PER_PAGE = 0 then
    Result := FItems.Count div MAKET_ITEMCOUNT_PER_PAGE
  else
    Result := (FItems.Count div MAKET_ITEMCOUNT_PER_PAGE) + 1;
end;

function TMarketItemManager.GetItem(
  index_: Integer;
  var rSelected: Boolean
  ): PTMarketItem;
begin
  Result := GetItem(index_);
  if Result <> nil then
  begin
    if index_ = FSelectedIndex then
      rSelected := True
    else
      rSelected := False;
  end;
end;

function TMarketItemManager.GetItem(
  index_: Integer
  ): PTMarketItem;
begin
  Result := nil;
  if CheckIndex(index_) then
    Result := PTMarketItem(FItems.Items[index_]);
end;

function TMarketItemManager.IsExistIndex(index_: Integer; var rMoney_: Integer): Boolean;
var
  i: Integer;
  pInfo: PTMarketItem;
begin
  Result := False;
  rMoney_ := 0;
  for i := 0 to FItems.Count - 1 do
  begin
    pInfo := FItems[i];
    if pInfo <> nil then
    begin
      if pInfo.Index = index_ then
      begin
        Result := True;
        rMoney_ := pInfo.SellPrice;
        Exit;
      end;
    end;
  end;
end;

function TMarketItemManager.IsMyItem(index_: Integer; CharName_: string): Boolean;
var
  i: Integer;
  pInfo: PTMarketItem;
begin
  Result := False;
  if CharName_ = '' then
    Exit;
  for i := 0 to FItems.Count - 1 do
  begin
    pInfo := FItems[i];
    if pInfo <> nil then
    begin
      if pInfo.Index = index_ then
      begin
        if (pInfo.SellWho = CharName_) then
          Result := True;
        Exit;
      end;
    end;
  end;
end;

procedure TMarketItemManager.OnMsgReadData;
begin

end;

procedure TMarketItemManager.OnMsgWriteData;
begin

end;

end.
