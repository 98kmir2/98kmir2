unit Envir;

interface

uses
  Windows, SysUtils, Classes, Graphics, MudUtil, Grobal2{$IF USEHASHLIST = 1}, CnHashTable{$IFEND};

type
{$IF VER_PATHMAP = 1}
  TTerrainTypes = (ttNormal, ttSand, ttForest, ttRoad, ttObstacle, ttPath);
  TMapData = array of array of TTerrainTypes;

  TPathMapCell = record
    Distance: Integer;
    Direction: Integer;
  end;
  TPathMapArray = array of array of TPathMapCell;

  TWaveCell = record //路线点
    X, Y: Integer;
    Cost: Integer;
    Direction: Integer;
  end;

  TWayPointInfo = record
    StartPoint: TPoint;
    EndPoint: TPoint;
    WayPoint: TPath;
  end;
  pTWayPointInfo = ^TWayPointInfo;
{$IFEND}

  //TGetCostFunc = function(X, Y, Direction: Integer; PathWidth: Integer = 0): Integer;

  TOSObject = record
    btType: Byte;
    dwAddTime: DWORD;
    CellObj: TObject;
  end;
  pTOSObject = ^TOSObject;

  TMapHeader = packed record
    wWidth: Word;
    wHeight: Word;
    sTitle: string[15];
    UpdateDate: TDateTime;
    Reserved: array[0..23] of Char;
  end;

  TMapUnitInfo = packed record
    wBkImg: Word;
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: Byte;
    btDoorOffset: Byte;
    btAniFrame: Byte;
    btAniTick: Byte;
    btArea: Byte;
    btLight: Byte;
  end;
  pTMapUnitInfo = ^TMapUnitInfo;
  TMap = array[0..1000 * 1000 - 1] of TMapUnitInfo;
  pTMap = ^TMap;

  TMapUnitInfo_New = packed record
    wBkImg: Word;
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: Byte;
    btDoorOffset: Byte;
    btAniFrame: Byte;
    btAniTick: Byte;
    btArea: Byte;
    btLight: Byte;
    btTitles: Byte;
    btSmTitles: Byte;
  end;
  pTMapUnitInfo_New = ^TMapUnitInfo_New;
  TMap_New = array[0..1000 * 1000 - 1] of TMapUnitInfo_New;
  pTMap_New = ^TMap_New;

  TMapUnitInfo_New2 = packed record
    wBkImg: Word;
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: Byte;
    btDoorOffset: Byte;
    btAniFrame: Byte;
    btAniTick: Byte;
    btArea: Byte;
    btLight: Byte;
    btTitles: Byte;
    btSmTitles: Byte;

    wBkImg2: Word; //1A
    wMidImg2: Word; //1C
    wFrImg2: Word; //1E
    btDoorIndex2: Byte; //20
    btDoorOffset2: Byte; //21
    btAniFrame2: Byte; //22
    btAniTick2: Byte; //23
    btArea2: Byte; //24
    btLight2: Byte; //25
    btTiles2: Byte; //26
    btsmTiles2: Byte; //27
    tempArr: array[0..7] of Byte;
  end;
  pTMapUnitInfo_New2 = ^TMapUnitInfo_New2;
  TMap_New2 = array[0..1000 * 1000 - 1] of TMapUnitInfo_New2;
  pTMap_New2 = ^TMap_New2;

  TMapCellinfo = record
    chFlag: Byte;
    ObjList: TList;
  end;
  pTMapCellinfo = ^TMapCellinfo;

{$IF VER_PATHMAP = 1}
  TPathMap = class
    m_MapHeader: TMapHeader;
    m_nPathWidth: Integer;
    //m_GetCostFunc: TGetCostFunc;
    m_PathMapArray: TPathMapArray;
    m_MapData: TMapData;
    m_mLatestWayPointList: TGList;
  public
    constructor Create;
    destructor Destroy; override;
    function FindPathOnMap(X, Y: Integer): TPath;
  private
    function DirToDX(Direction: Integer): Integer;
    function DirToDY(Direction: Integer): Integer;
  protected
    function GetCost(X, Y, Direction: Integer): Integer; //virtual;
    function FillPathMap(X1, Y1, X2, Y2: Integer): TPathMapArray;
  end;
{$IFEND}

  TEnvirnoment = class{$IF VER_PATHMAP = 1}(TPathMap){$IFEND}
{$IF VER_PATHMAP = 0}
    m_MapHeader: TMapHeader;
{$IFEND}
    m_sMapFileName: string;
    m_sClientMapName: string;
    m_sMapDesc: string;
    m_MapCellArray: array of TMapCellinfo;
    m_nMinMap: Integer;
    m_nServerIndex: Integer;
    //m_nRequestLevel: Integer;
    m_MapFlag: TMapFlag;
    m_boChFlag: Boolean;
    m_DoorList: TList;
    m_QuestList: TList;
    m_QuestNPC: TObject;
    m_MapEvents: TList;
  private
{$IF VER_PATHMAP = 1}
    FPath: TPath;
{$IFEND}
    m_nMonCount: Integer;
    m_nHumCount: Integer;
    m_nNimbusCount: Integer;
    procedure SetNimbusCount(value: Integer);
    procedure Initialize(nWidth, nHeight: Integer);
  public
{$IF VER_PATHMAP = 1}
    property Path: TPath read FPath write FPath;
    function FindPath(StartX, StartY, StopX, StopY, PathSpace: Integer): TPath; {overload;}
    //function FindPath(StopX, StopY: Integer): TPath; overload;
    procedure SetStartPos(StartX, StartY, PathSpace: Integer);
{$IFEND}
    constructor Create();
    destructor Destroy; override;
    procedure LoadMapEventList();
    function AddToMap(nX, nY: Integer; btType: Byte; pRemoveObject: TObject): Pointer;
    function AddToMapEx(nX, nY: Integer; OSObject: pTOSObject): Pointer;
    function CanWalk(nX, nY: Integer; boFlag: Boolean): Boolean;
    function CanWalkOfItem(nX, nY: Integer; boFlag, boItem: Boolean): Boolean;
    function CanWalkEx(nX, nY: Integer; boFlag: Boolean; PlayObject: TObject = nil): Boolean;
    function CanFly(nSX, nSY, nDX, nDY: Integer): Boolean;
    function MoveToMovingObject(nCX, nCY: Integer; Cert: TObject; nX, nY: Integer; boFlag: Boolean): Integer;
    function GetItem(nX, nY: Integer): pTMapItem;
    function GetMapItem(nX, nY: Integer; p: pTMapItem): pTMapItem;
    function DeleteFromMap(nX, nY: Integer; btType: Byte; pRemoveObject: TObject): Integer;
    function IsCheapStuff(): Boolean;
    procedure AddDoorToMap;
    function AddToMapMineEvent(nX, nY: Integer; nType: Integer; Event: TObject): TObject;
    function AddToMapItemEvent(nX, nY: Integer; nType: Integer; Event: TObject): TObject;

    function LoadMapData(sMapFile: string): Boolean;
    function CreateQuest(nFlag, nValue: Integer; sMonName, sItem, sQuest: string; boGrouped: Boolean): Boolean;
    function GetMapCellInfo(nX, nY: Integer; var MapCellInfo: pTMapCellinfo): Boolean;
    function GetXYObjCount(nX, nY: Integer): Integer;
    function GetXYObjCount_SafeZone(PlayObject: TObject; nX, nY: Integer): Integer;
    function GetNextPosition(sX, sY, nDir, nFlag: Integer; var snx: Integer; var sny: Integer): Boolean;
    function IsValidCell(nX, nY: Integer): Boolean;

    function CanSafeWalk(nX, nY: Integer): Boolean;
    function ArroundDoorOpened(nX, nY: Integer): Boolean;
    function GetMovingObject(nX, nY: Integer; boFlag: Boolean): Pointer;
    function GetMovingObjectA(nX, nY: Integer; boFlag: Boolean): Pointer;
    function GetQuestNPC(BaseObject: TObject; sCharName, sItem: string; boFlag: Boolean): TObject;
    function GetItemEx(nX, nY: Integer; var nCount: Integer): Pointer;
    function GetDoor(nX, nY: Integer): pTDoorInfo;
    function IsValidObject(nX, nY, nRage: Integer; BaseObject: TObject): Boolean;
    function GetRangeBaseObject(nX, nY: Integer; nRage: Integer; boFlag: Boolean; BaseObjectList: TList): Integer;
    function GetBaseObjects(nX, nY: Integer; boFlag: Boolean; BaseObjectList: TList): Integer;
    function GetEvent(nX, nY: Integer): TObject;
    function GetRangeEvent(nX, nY, range, id: Integer): TObject;
    function GetXYHuman(nMapX, nMapY: Integer): Boolean;
    function GetEnvirInfo(): string;
    function ExchangeMapPos(nX, nY, nX2, nY2: Integer; BaseObject: TObject): Boolean;

    procedure VerifyMapTime(nX, nY: Integer; BaseObject: TObject);
    procedure GetMarkMovement(nX, nY: Integer; boFlag: Boolean);
    procedure AddObjectCount(BaseObject: TObject);
    procedure DelObjectCount(BaseObject: TObject);
    property MonCount: Integer read m_nMonCount;
    property HumCount: Integer read m_nHumCount;
    property NimbusCount: Integer read m_nNimbusCount write SetNimbusCount;

    function InSafeZone(nX, nY: Integer): Boolean;
  protected
    //function GetCost(X, Y, Direction: Integer): Integer;
  end;

{$IF VER_PATHMAP = 1}
  TWave = class //路线类
  private
    FData: array of TWaveCell;
    FPos: Integer;
    FCount: Integer;
    FMinCost: Integer;
    function GetItem: TWaveCell;
  public
    property item: TWaveCell read GetItem;
    property MinCost: Integer read FMinCost;
    constructor Create;
    destructor Destroy; override;
    procedure Add(NewX, NewY, NewCost, NewDirection: Integer);
    procedure Clear;
    function start: Boolean;
    function Next: Boolean;
  end;
{$IFEND}

  TMapManager = class({$IF USEHASHLIST = 1}TCnHashTableSmall{$ELSE}TGList{$IFEND})
  private
{$IF USEHASHLIST = 1}
    FLock: TRTLCriticalSection;
{$IFEND}
  public
    constructor Create();
    destructor Destroy; override;
    procedure LoadMapDoor();
    function AddMapInfo(sMapName, sMapDesc: string; nServerNumber: Integer; MapFlag: pTMapFlag; QuestNPC: TObject): TEnvirnoment;
    function GetMapInfo(nServerIdx: Integer; sMapName: string): TEnvirnoment;
    function AddMapRoute(sSMapNO: string; nSMapX, nSMapY: Integer; sDMapNO: string; nDMapX, nDMapY: Integer): Boolean;
    function GetMapOfServerIndex(sMapName: string): Integer;
    function FindMap(sMapName: string): TEnvirnoment;
    function FindMapEx(sMapName: string; GTNumber: Integer): TEnvirnoment;
    procedure ReSetMinMap();
    procedure ReSetMapDigItemLists(const slist: TStringList);
    procedure Run();
{$IF USEHASHLIST = 1}
    procedure Lock;
    procedure UnLock;
{$IFEND}
    //procedure ProcessMapDoor();
  end;

  TStartPoint = record
    sMapName: string[16];
    Envir: TEnvirnoment;
    nX: Integer;
    nY: Integer;
    //dwWhisperTick: LongWord;
  end;
  pTStartPoint = ^TStartPoint;

  TStartPointInfo = record
    sMapName: string[16];
    Envir: TEnvirnoment;
    nX: Integer;
    nY: Integer;
    boQUIZ: Boolean;
    nSize: Integer;
    nType: Integer;
    boPKZone: Boolean;
    boPKFire: Boolean;
    dwCrTick: LongWord;
    //dwWhisperTick: LongWord;
  end;
  pTStartPointInfo = ^TStartPointInfo;

  TME_Flag = record //触发标识
    nFlag: Integer; //触发标识(-1 - 800)
    boFlag: Boolean; //触发标识(0,1)值
  end;
  TME_Condition = record //触发条件
    nAction: Integer; //动作
    sItemName: string[ItemNameLen]; //物品
    boGroup: Boolean; //组队
  end;
  TME_Enent = record //事件类型
    boCall: Boolean; //是否调用
    sLabel: string[50]; //调用脚本标签
  end;

  TMapEvent = record
    //sMapName: string[14];               //地图号
    //Envir: TEnvirnoment;
    nCurrX: Integer; //座标X
    nCurrY: Integer; //座标Y
    cFlag: TME_Flag; //触发标识
    cCondition: TME_Condition; //触发条件
    nRate: Integer; //触发机率
    cEnent: TME_Enent; //事件类型
  end;
  pTMapEvent = ^TMapEvent;

  TMonGenInfo = record
    sMapName: string[16];
    nX, nY: Integer;
    sMonName: string[14]; //nAreaX: Integer; //nAreaY: Integer;
    nRange: Integer;
    nCount: Integer;
    nActiveCount: Integer;
    dwZenTime: LongWord;
    nMissionGenRate: Integer;
    CertList: TList;
    Envir: TEnvirnoment;
    nRace: Integer; // dwStartTime: LongWord;
    dwStartTick: LongWord;
  end;
  pTMonGenInfo = ^TMonGenInfo;

{$IF VER_PATHMAP = 1}const
  TerrainParams: array[TTerrainTypes] of Integer = (4, 6, 10, 2, -1, 0);
{$IFEND}

implementation

uses ObjBase, ObjNpc, M2Share, Event, ObjMon, HUtil32, Castle;

{ TEnvirList }
var
  Key: Integer = 0;

function TMapManager.AddMapInfo(sMapName, sMapDesc: string; nServerNumber: Integer; MapFlag: pTMapFlag; QuestNPC: TObject): TEnvirnoment;
var
  Envir: TEnvirnoment;
  i: Integer;
  sTemp, sSendMapName: string;
begin
  Result := nil;

  if Pos('|', sMapName) > 0 then
  begin
    sTemp := sMapName;
    sSendMapName := GetValidStr3(sTemp, sMapName, ['|']);
  end
  else if Pos('>', sMapName) > 0 then
  begin
    sTemp := sMapName;
    sMapName := ArrestStringEx(sTemp, '<', '>', sSendMapName);
  end
  else
    sSendMapName := sMapName;

  if Self.Exists(sMapName) then
  begin
    MainOutMessageAPI('MapInfo.txt 地图重复: ' + g_Config.sMapDir + sMapName + '.map');
    MainOutMessageAPI('请检查MapInfo.txt文件！');
    Exit;
  end;

  Envir := TEnvirnoment.Create; //0618
  Envir.m_sMapFileName := sMapName;
  Envir.m_sClientMapName := sSendMapName;
  Envir.m_sMapDesc := sMapDesc;
  Envir.m_nServerIndex := nServerNumber;
  Envir.m_MapFlag := MapFlag^;
  Envir.m_QuestNPC := QuestNPC;

  for i := 0 to MiniMapList.Count - 1 do
  begin
    if (CompareText(MiniMapList.Strings[i], Envir.m_sMapFileName) = 0) or
      (CompareText(MiniMapList.Strings[i], Envir.m_sClientMapName) = 0) then
    begin
      Envir.m_nMinMap := Integer(MiniMapList.Objects[i]);
      Break;
    end;
  end;

  if Envir.LoadMapData(g_Config.sMapDir + sSendMapName + '.map') then
  begin
    //Envir.m_GuildTerritory := g_GuildTerritory.FindGuildTerritory(MapFlag.nGuildTerritory);
    Envir.LoadMapEventList();
    Result := Envir;
{$IF USEHASHLIST = 1}
    //AddObject(Envir.m_sMapFileName, Envir);
    Self.Put(UpperCase(Envir.m_sMapFileName), Envir);
{$ELSE}
    Add(Envir);
{$IFEND}
    if (Envir.m_MapFlag.nThunder <> 0) or (Envir.m_MapFlag.nGreatThunder <> 0) or (Envir.m_MapFlag.nLava <> 0) or (Envir.m_MapFlag.nSpurt <> 0) then
      UserEngine.m_MapEffectList.Add(Envir);
  end
  else
  begin
    Envir.Free;
    MainOutMessageAPI('地图文件: ' + g_Config.sMapDir + sMapName + '.map' + ' 未找到！');
  end;
end;

function TMapManager.AddMapRoute(sSMapNO: string; nSMapX, nSMapY: Integer; sDMapNO: string; nDMapX, nDMapY: Integer): Boolean;
var
  GateObj: pTGateObj;
  SEnvir: TEnvirnoment;
  DEnvir: TEnvirnoment;
begin
  Result := False;
  SEnvir := FindMap(sSMapNO);
  DEnvir := FindMap(sDMapNO);
  if (SEnvir <> nil) and (DEnvir <> nil) then
  begin
    New(GateObj);
    //GateObj.boFlag := False;
    GateObj.DEnvir := DEnvir;
    GateObj.nDMapX := nDMapX;
    GateObj.nDMapY := nDMapY;
    if SEnvir.AddToMap(nSMapX, nSMapY, OS_GATEOBJECT, TObject(GateObj)) <> nil then
      Result := True
    else
      Dispose(GateObj);
  end;
end;

function TEnvirnoment.AddToMap(nX, nY: Integer; btType: Byte; pRemoveObject: TObject): Pointer;
var
  i, nCode, nGoldCount: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  MapItem: pTMapItem;
  bMapCellFill: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::AddToMap Code:%d';
begin
  nCode := 0;
  Result := nil;
  try
    bMapCellFill := False;
    if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
    begin
      if MapCellInfo.ObjList = nil then
      begin
        MapCellInfo.ObjList := TList.Create;
      end
      else
      begin
        if btType = OS_ITEMOBJECT then
        begin
          if CompareText(pTMapItem(pRemoveObject).Name, sSTRING_GOLDNAME) = 0 then
          begin
            for i := 0 to MapCellInfo.ObjList.Count - 1 do
            begin
              OSObject := MapCellInfo.ObjList.Items[i];
              if (OSObject <> nil) and (OSObject.btType = OS_ITEMOBJECT) then
              begin
                MapItem := pTMapItem(pTOSObject(MapCellInfo.ObjList.Items[i]).CellObj); //pTMapItem(OSObject.CellObj);
                if CompareText(MapItem.Name, sSTRING_GOLDNAME) = 0 then
                begin
                  nGoldCount := MapItem.Count + pTMapItem(pRemoveObject).Count;
                  if nGoldCount <= 2000 then
                  begin
                    MapItem.Count := nGoldCount;
                    MapItem.looks := GetGoldShape(nGoldCount);
                    MapItem.AniCount := 0;
                    MapItem.Reserved := 0;
                    OSObject.dwAddTime := GetTickCount();
                    Result := MapItem;
                    bMapCellFill := True;
                  end;
                end;
              end;
            end;
          end;
          if not bMapCellFill then
          begin
            nGoldCount := 0;
            for i := 0 to MapCellInfo.ObjList.Count - 1 do
            begin
              OSObject := MapCellInfo.ObjList.Items[i];
              if (OSObject <> nil) and (OSObject.btType = OS_ITEMOBJECT) then
              begin
                Inc(nGoldCount);
              end;
            end;
            if nGoldCount >= 5 then
            begin
              Result := nil;
              bMapCellFill := True;
            end;
          end;
        end;
      end;
      nCode := 10;
      if not bMapCellFill then
      begin
        New(OSObject);
        OSObject.btType := btType;
        OSObject.CellObj := pRemoveObject;
        OSObject.dwAddTime := GetTickCount();
        MapCellInfo.ObjList.Add(OSObject);
        Result := Pointer(pRemoveObject);
        //增加怪物计数
        if (btType = OS_MOVINGOBJECT) and not TBaseObject(pRemoveObject).m_boAddToMaped then
        begin
          TBaseObject(pRemoveObject).m_boDelFormMaped := False;
          TBaseObject(pRemoveObject).m_boAddToMaped := True;
          AddObjectCount(pRemoveObject);
        end;
        if (btType = OS_EVENTOBJECT) and (TEvent(pRemoveObject).m_nEventType in [ET_NIMBUS_1, ET_NIMBUS_2, ET_NIMBUS_3]) then
        begin
          NimbusCount := NimbusCount + 1;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [nCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

function TEnvirnoment.AddToMapEx(nX, nY: Integer; OSObject: pTOSObject): Pointer;
var
  nCode: Integer;
  MapCellInfo: pTMapCellinfo;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::AddToMap Code:%d';
begin
  nCode := 0;
  Result := nil;
  try
    if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
    begin
      if MapCellInfo.ObjList = nil then
        MapCellInfo.ObjList := TList.Create;

      OSObject.dwAddTime := GetTickCount();
      MapCellInfo.ObjList.Add(OSObject);
      Result := Pointer(OSObject.CellObj);

      if not TBaseObject(OSObject.CellObj).m_boAddToMaped then
      begin
        TBaseObject(OSObject.CellObj).m_boDelFormMaped := False;
        TBaseObject(OSObject.CellObj).m_boAddToMaped := True;
        AddObjectCount(OSObject.CellObj);
      end;

    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [nCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

procedure TEnvirnoment.AddDoorToMap(); //004B6A74
var
  i: Integer;
  Door: pTDoorInfo;
begin
  for i := 0 to m_DoorList.Count - 1 do
  begin
    Door := m_DoorList.Items[i];
    AddToMap(Door.nX, Door.nY, OS_DOOR, TObject(Door));
  end;
end;

function TEnvirnoment.GetMapCellInfo(nX, nY: Integer; var MapCellInfo: pTMapCellinfo): Boolean;
begin
  Result := False;
  if (nX >= 0) and (nX < m_MapHeader.wWidth) and (nY >= 0) and (nY < m_MapHeader.wHeight) then
  begin
    MapCellInfo := @m_MapCellArray[nX * m_MapHeader.wHeight + nY];
    Result := True;
  end;
end;

function TEnvirnoment.MoveToMovingObject(nCX, nCY: Integer; Cert: TObject; nX, nY: Integer; boFlag: Boolean): Integer; //004B612C
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  BaseObject: TBaseObject;
  OSObject: pTOSObject;
  bThrough: Boolean;
  bMoveOK: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::MoveToMovingObject';
label
  lRemoveObj;
begin
  {Result := 0;

  boGetMapCell := GetMapCellInfo(nX, nY, MapCellInfoTarget);
  if not boGetMapCell then begin
    Exit;
  end;

  if (MapCellInfoTarget.chFlag <> 0) then begin
    Result := -1;
    Exit;
  end;

  if not boFlag then begin
    //target cell can walkto?
    if MapCellInfoTarget.ObjList <> nil then begin
      for i := 0 to MapCellInfoTarget.ObjList.Count - 1 do begin
        OSObject := MapCellInfoTarget.ObjList.Items[i];
        if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if BaseObject <> nil then begin
            if BaseObject.m_boHoldPlace and
              not BaseObject.m_boGhost and
              not BaseObject.m_boDeath and
              not BaseObject.m_boFixedHideMode and
              not BaseObject.m_boObMode then
            begin
              Exit;
            end;
          end;
        end;
      end;
    end;
    goto lRemoveObj;
  end else begin
    lRemoveObj:
    boRemoveObj := False;
    if GetMapCellInfo(nCX, nCY, MapCellInfoCurrent) and (MapCellInfoCurrent.ObjList <> nil) then begin
      i := 0;
      while (True) do begin
        if MapCellInfoCurrent.ObjList.Count <= i then
          Break;
        OSObject := MapCellInfoCurrent.ObjList.Items[i];
        if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then begin
          if TBaseObject(OSObject.CellObj) = TBaseObject(Cert) then begin
            boRemoveObj := True;
            MapCellInfoCurrent.ObjList.Delete(i);
            Dispose(OSObject);
            if MapCellInfoCurrent.ObjList.Count > 0 then  //mutilobjects
              Continue;
            MapCellInfoCurrent.ObjList.Free;
            MapCellInfoCurrent.ObjList := nil;
            Break;
          end;
        end;
        Inc(i);
      end;
    end;
    if boRemoveObj then begin
      if MapCellInfoTarget.ObjList = nil then
        MapCellInfoTarget.ObjList := TList.Create;
      New(OSObject);
      OSObject.btType := OS_MOVINGOBJECT;
      OSObject.CellObj := Cert;
      OSObject.dwAddTime := GetTickCount;
      MapCellInfoTarget.ObjList.Add(OSObject);
      Result := 1;
    end;
  end;}

  Result := 0;
  //try
  bThrough := True;
  if not boFlag and GetMapCellInfo(nX, nY, MapCellInfo) then
  begin
    if MapCellInfo.chFlag = 0 then
    begin
      if MapCellInfo.ObjList <> nil then
      begin
        for i := 0 to MapCellInfo.ObjList.Count - 1 do
        begin
          OSObject := MapCellInfo.ObjList.Items[i];
          if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
          begin
            BaseObject := TBaseObject(pTOSObject(MapCellInfo.ObjList.Items[i]).CellObj); //TBaseObject(OSObject.CellObj); //0410
            if BaseObject <> nil then
            begin
              if BaseObject.m_boHoldPlace and
                not BaseObject.m_boGhost and
                not BaseObject.m_boDeath and
                not BaseObject.m_boFixedHideMode and
                not BaseObject.m_boObMode then
              begin
                bThrough := False;
                Break;
              end;
            end;
          end;
        end;
      end;
    end
    else
    begin
      bThrough := False;
      Result := -1;
    end;
  end;

  if bThrough then
  begin
    if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag <> 0) then
    begin
      Result := -1;
    end
    else
    begin
      bMoveOK := False;
      if GetMapCellInfo(nCX, nCY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
      begin
        i := 0;
        while (True) do
        begin
          if MapCellInfo.ObjList.Count <= i then
            Break;
          OSObject := MapCellInfo.ObjList.Items[i];
          if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
          begin
            if TBaseObject(OSObject.CellObj) = TBaseObject(Cert) then
            begin
              bMoveOK := True;
              MapCellInfo.ObjList.Delete(i); //0410
              Dispose(OSObject);
              if MapCellInfo.ObjList.Count > 0 then
                Continue;
              MapCellInfo.ObjList.Free;
              MapCellInfo.ObjList := nil;
              Break;
            end;
          end;
          Inc(i);
        end;
      end;
      if bMoveOK and GetMapCellInfo(nX, nY, MapCellInfo) then
      begin
        if MapCellInfo.ObjList = nil then
          MapCellInfo.ObjList := TList.Create;
        New(OSObject);
        OSObject.btType := OS_MOVINGOBJECT;
        OSObject.CellObj := Cert;
        OSObject.dwAddTime := GetTickCount;
        MapCellInfo.ObjList.Add(OSObject);
        Result := 1;
      end;
    end;
  end;
//  except
//    on E: Exception do begin
//      MainOutMessageAPI(sExceptionMsg);
//      MainOutMessageAPI(E.Message);
//    end;
//  end;
end;

function TEnvirnoment.CanWalk(nX, nY: Integer; boFlag: Boolean): Boolean;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  i: Integer;
begin
  Result := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
    Result := True;
    if not boFlag and (MapCellInfo.ObjList <> nil) then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
        begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if BaseObject <> nil then
          begin
            if not BaseObject.m_boGhost
              and BaseObject.m_boHoldPlace
              and not BaseObject.m_boDeath
              and not BaseObject.m_boFixedHideMode
              and not BaseObject.m_boObMode then
            begin
              Result := False;
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.CanWalkEx(nX, nY: Integer; boFlag: Boolean; PlayObject: TObject = nil): Boolean;
var
  i, nCanRun: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  Castle: TUserCastle;
begin
  Result := False;
  nCanRun := -1;
  if (PlayObject <> nil) and (TPlayObject(PlayObject).m_btRaceServer = RC_PLAYOBJECT) then
    nCanRun := TPlayObject(PlayObject).m_nCanRun;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
    Result := True;
    if not boFlag and (MapCellInfo.ObjList <> nil) then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
        begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if BaseObject <> nil then
          begin
            if (PlayObject <> nil) and (TPlayObject(PlayObject).m_btRaceServer = RC_PLAYOBJECT) then
            begin
              Castle := g_CastleManager.InCastleWarArea(BaseObject);
              if g_Config.boWarDisHumRun and (Castle <> nil) and (Castle.m_boUnderWar) then
                //
              else if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
              begin
                if g_Config.boRUNHUMAN or m_MapFlag.boRUNHUMAN or (nCanRun = 0) or (nCanRun = 2) then
                  Continue;
              end
              else if BaseObject.m_btRaceServer in [RC_NPC, RC_TRAINER] then
              begin
                if g_Config.boRunNpc or (nCanRun = 0) then
                  Continue;
              end
              else if BaseObject.m_btRaceServer in [RC_GUARD, RC_ARCHERGUARD] then
              begin
                if g_Config.boRunGuard or (nCanRun = 0) then
                  Continue;
              end
              else if g_Config.boRUNMON or m_MapFlag.boRUNMON or (nCanRun = 0) or (nCanRun = 1) then
                Continue;
            end;
            if not BaseObject.m_boGhost and BaseObject.m_boHoldPlace and not BaseObject.m_boDeath and not BaseObject.m_boFixedHideMode and not BaseObject.m_boObMode then
            begin
              Result := False;
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.InSafeZone(nX, nY: Integer): Boolean;
var
  i, j, nSafeX, nSafeY: Integer;
  StartPointInfo: pTStartPointInfo;
  P:pTStartPointRegion;
begin
  Result := m_MapFlag.boSAFE;
  if Result then Exit;

  if (m_sMapFileName <> g_Config.sRedHomeMap) or
    (abs(nX - g_Config.nRedHomeX) > g_Config.nSafeZoneSize) or
    (abs(nY - g_Config.nRedHomeY) > g_Config.nSafeZoneSize) then
    Result := False
  else
    Result := True;
  if Result then Exit;

  for i := 0 to g_StartPointManager.m_InfoList.Count - 1 do
  begin
    StartPointInfo := g_StartPointManager.m_InfoList.Items[i];
    //sMapName := StartPointInfo.sMapName;
    nSafeX := StartPointInfo.nX;
    nSafeY := StartPointInfo.nY;
    if (StartPointInfo.nSize >= CUSTOM_SAFEZONE_CONTROLSTART_INX) and (StartPointInfo.nSize <= CUSTOM_SAFEZONE_CONTROLEND_INX) then
    begin
      for j := 0 to g_StartPointRegionList_Server.Count - 1 do
      begin
        p := g_StartPointRegionList_Server.Items[j];
        if p^.nSizeCode = StartPointInfo.nSize then
        begin
          if PtInRegion(p^.rgn,nX,nY) then  //判断点是否在异形区域内，不包含边框
          begin
            Result := True;
            if StartPointInfo.boPKZone then
              Result := not Result;
            Break;
          end
          else if (PtInRegion(p^.rgn,nX,nY - 1) or PtInRegion(p^.rgn,nX,nY + 1) or PtInRegion(p^.rgn,nX - 1,nY) or PtInRegion(p^.rgn,nX + 1,nY)) then 
          begin
            Result := True;
            if StartPointInfo.boPKZone then
              Result := not Result;
            Break;
          end;
        end;
      end;
    end
    else
    begin
      if (StartPointInfo.Envir = Self) and
        (abs(nX - nSafeX) <= StartPointInfo.nSize) and
        (abs(nY - nSafeY) <= StartPointInfo.nSize) then
      begin
        Result := True;
        if StartPointInfo.boPKZone then
          Result := not Result;
        Break;
      end;
    end;
  end;
end;

function TEnvirnoment.CanWalkOfItem(nX, nY: Integer; boFlag, boItem: Boolean): Boolean;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  i: Integer;
begin
  Result := False; //0625
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
    Result := True;
    if (MapCellInfo.ObjList <> nil) then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if not boFlag and (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
        begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if BaseObject <> nil then
          begin
            if not BaseObject.m_boGhost
              and BaseObject.m_boHoldPlace
              and not BaseObject.m_boDeath
              and not BaseObject.m_boFixedHideMode
              and not BaseObject.m_boObMode then
            begin
              Result := False;
              Break;
            end;
          end;
        end;
        if not boItem and (OSObject <> nil) and (OSObject.btType = OS_ITEMOBJECT) then
        begin
          Result := False;
          Break;
        end;
      end;
    end;
  end;
end;

constructor TMapManager.Create;
begin
  inherited Create;
{$IF USEHASHLIST = 1}
  InitializeCriticalSection(FLock);
{$IFEND}
end;

destructor TMapManager.Destroy;
var
  i: Integer;
begin
  for i := 0 to Self.Count - 1 do
{$IF USEHASHLIST = 1}
    TEnvirnoment(Self.Values[Self.Keys[i]]).Free;
  DeleteCriticalSection(FLock);
{$ELSE}
  TEnvirnoment(Self.Items[i]).Free;
{$IFEND}
  inherited;
end;

{$IF USEHASHLIST = 1}

procedure TMapManager.Lock;
begin
  EnterCriticalSection(FLock);
end;

procedure TMapManager.UnLock;
begin
  LeaveCriticalSection(FLock);
end;
{$IFEND}

function TMapManager.FindMap(sMapName: string): TEnvirnoment;
begin
  Lock;
  try
{$IF USEHASHLIST = 1}
    //i := IndexOf(sMapName);
    //if i >= 0 then Result := TEnvirnoment(Objects[i]);
    Result := TEnvirnoment(Self.Values[UpperCase(sMapName)]);
{$ELSE}
    for i := 0 to Count - 1 do
    begin
      Map := TEnvirnoment(Items[i]);
      if CompareText(Map.m_sMapFileName, sMapName) = 0 then
      begin
        Result := Map;
        Break;
      end;
    end;
{$IFEND}
  finally
    UnLock;
  end;
end;

function TMapManager.FindMapEx(sMapName: string; GTNumber: Integer): TEnvirnoment; //4B7350
var
  Map: TEnvirnoment;
begin
  Result := nil;
  Lock;
  try
{$IF USEHASHLIST = 1}
    {i := IndexOf(sMapName);
    if i >= 0 then begin
      if TEnvirnoment(Objects[i]).m_MapFlag.nGuildTerritory = GTNumber then
        Result := TEnvirnoment(Objects[i]);
    end;}
    Map := TEnvirnoment(Self.Values[UpperCase(sMapName)]);
    if (Map <> nil) and (Map.m_MapFlag.nGuildTerritory = GTNumber) then
      Result := Map;
{$ELSE}
    for i := 0 to Count - 1 do
    begin
      Map := TEnvirnoment(Items[i]);
      if (CompareText(Map.m_sMapFileName, sMapName) = 0) and (Map.m_MapFlag.nGuildTerritory = GTNumber) then
      begin
        Result := Map;
        Break;
      end;
    end;
{$IFEND}
  finally
    UnLock;
  end;
end;

function TMapManager.GetMapInfo(nServerIdx: Integer; sMapName: string): TEnvirnoment;
var
  Map: TEnvirnoment;
begin
  Result := nil;
  Lock;
  try
{$IF USEHASHLIST = 1}
    {i := IndexOf(sMapName);
    if i >= 0 then begin
      if TEnvirnoment(Objects[i]).m_nServerIndex = nServerIdx then
        Result := TEnvirnoment(Objects[i]);
    end;}
    Map := TEnvirnoment(Self.Values[UpperCase(sMapName)]);
    if (Map <> nil) and (Map.m_nServerIndex = nServerIdx) then
      Result := Map;
{$ELSE}
    for i := 0 to Count - 1 do
    begin
      Envir := TEnvirnoment(Items[i]);
      if (Envir.m_nServerIndex = nServerIdx) and (CompareText(Envir.m_sMapFileName, sMapName) = 0) then
      begin
        Result := Envir;
        Break;
      end;
    end;
{$IFEND}
  finally
    UnLock;
  end;
end;

function TEnvirnoment.DeleteFromMap(nX, nY: Integer; btType: Byte; pRemoveObject: TObject): Integer;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  n18: Integer;
resourcestring
  sExceptionMsg1 = '[Exception] TEnvirnoment::DeleteFromMap -> Except 1 ** %d';
  sExceptionMsg2 = '[Exception] TEnvirnoment::DeleteFromMap -> Except 2 ** %d';
begin
  Result := -1;
  try
    if GetMapCellInfo(nX, nY, MapCellInfo) then
    begin
      if MapCellInfo <> nil then
      begin
        //try
        if MapCellInfo.ObjList <> nil then
        begin
          n18 := 0;
          while (True) do
          begin
            if MapCellInfo.ObjList.Count <= n18 then
              Break;
            OSObject := MapCellInfo.ObjList.Items[n18];
            if OSObject <> nil then
            begin
              if (OSObject.btType = btType) and (OSObject.CellObj = pRemoveObject) then
              begin
                MapCellInfo.ObjList.Delete(n18);
                Dispose(OSObject);
                Result := 1;
                if (btType = OS_MOVINGOBJECT) and not TBaseObject(pRemoveObject).m_boDelFormMaped then
                begin
                  TBaseObject(pRemoveObject).m_boDelFormMaped := True;
                  TBaseObject(pRemoveObject).m_boAddToMaped := False;
                  DelObjectCount(pRemoveObject);
                end;
                if (NimbusCount > 0) and (btType = OS_EVENTOBJECT) and (TEvent(pRemoveObject).m_nEventType in [ET_NIMBUS_1, ET_NIMBUS_2, ET_NIMBUS_3]) then
                begin
                  NimbusCount := NimbusCount - 1;
                end;
                if MapCellInfo.ObjList.Count > 0 then
                  Continue;
                MapCellInfo.ObjList.Free;
                MapCellInfo.ObjList := nil;
                Break;
              end;
            end
            else
            begin
              if n18 < MapCellInfo.ObjList.Count then
                MapCellInfo.ObjList.Delete(n18);
              if MapCellInfo.ObjList.Count > 0 then
                Continue;
              MapCellInfo.ObjList.Free;
              MapCellInfo.ObjList := nil;
              Break;
            end;
            Inc(n18);
          end;
        end
        else
          Result := -2;
        //except
        //  OSObject := nil;
        //  MainOutMessageAPI(Format(sExceptionMsg1, [btType]));
        //end;
      end
      else
        Result := -3;
    end
    else
      Result := 0;
  except
    MainOutMessageAPI(Format(sExceptionMsg2, [btType]));
  end;
end;

function TEnvirnoment.GetItem(nX, nY: Integer): pTMapItem; //004B5B0C
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := nil;
  m_boChFlag := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo <> nil) and (MapCellInfo.chFlag = 0) then
  begin
    m_boChFlag := True;
    if MapCellInfo.ObjList <> nil then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if OSObject = nil then
          Continue;
        if OSObject.btType = OS_ITEMOBJECT then
        begin
          Result := pTMapItem(OSObject.CellObj);
          Exit;
        end;
        if OSObject.btType = OS_GATEOBJECT then
          m_boChFlag := False;
        if OSObject.btType = OS_MOVINGOBJECT then
        begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if not BaseObject.m_boDeath then
            m_boChFlag := False;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetMapItem(nX, nY: Integer; p: pTMapItem): pTMapItem;
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := nil;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo <> nil) and (MapCellInfo.chFlag = 0) then
  begin
    if MapCellInfo.ObjList <> nil then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if OSObject = nil then
          Continue;
        if OSObject.btType = OS_ITEMOBJECT then
        begin
          if p = pTMapItem(OSObject.CellObj) then
          begin
            Result := pTMapItem(OSObject.CellObj);
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

function TMapManager.GetMapOfServerIndex(sMapName: string): Integer;
var
  Envir: TEnvirnoment;
begin
  Result := 0;
  Lock;
  try
{$IF USEHASHLIST = 1}
    //i := IndexOf(sMapName);
    //if i >= 0 then Result := TEnvirnoment(Objects[i]).m_nServerIndex;
    Envir := TEnvirnoment(Self.Values[UpperCase(sMapName)]);
    if (Envir <> nil) then
      Result := Envir.m_nServerIndex;
{$ELSE}
    for i := 0 to Count - 1 do
    begin
      Envir := Items[i];
      if (CompareText(Envir.m_sMapFileName, sMapName) = 0) then
      begin
        Result := Envir.m_nServerIndex;
        Break;
      end;
    end;
{$IFEND}
  finally
    UnLock;
  end;
end;

procedure TMapManager.LoadMapDoor;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
{$IF USEHASHLIST = 1}
    //TEnvirnoment(Objects[i]).AddDoorToMap;
    TEnvirnoment(Self.Values[Self.Keys[i]]).AddDoorToMap;
{$ELSE}
  TEnvirnoment(Items[i]).AddDoorToMap;
{$IFEND}

end;

{procedure TMapManager.ProcessMapDoor;
begin

end;}

procedure TMapManager.ReSetMinMap;
var
  ii: Integer;
  Envirnoment: TEnvirnoment;
begin
{$IF USEHASHLIST = 1}
  {for ii := 0 to MiniMapList.Count - 1 do begin
    i := IndexOf(MiniMapList.Strings[ii]);
    if i >= 0 then
      TEnvirnoment(Objects[i]).m_nMinMap := Integer(MiniMapList.Objects[ii]);
  end;}
  for ii := 0 to MiniMapList.Count - 1 do
  begin
    Envirnoment := TEnvirnoment(Self.Values[UpperCase(MiniMapList[ii])]);
    if Envirnoment <> nil then
      Envirnoment.m_nMinMap := Integer(MiniMapList.Objects[ii]);
  end;
{$ELSE}
  for i := 0 to Count - 1 do
  begin
    Envirnoment := TEnvirnoment(Items[i]);
    for ii := 0 to MiniMapList.Count - 1 do
    begin
      if CompareText(MiniMapList.Strings[ii], Envirnoment.m_sMapFileName) = 0 then
      begin
        Envirnoment.m_nMinMap := Integer(MiniMapList.Objects[ii]);
        Break;
      end;
    end;
  end;
{$IFEND}
end;

procedure TMapManager.ReSetMapDigItemLists(const slist: TStringList);
var
  i, ii: Integer;
  Envirnoment: TEnvirnoment;
begin
  Lock;
  try
{$IF USEHASHLIST = 1}
    for i := 0 to Count - 1 do
    begin
      Envirnoment := TEnvirnoment(Self.Values[Self.Keys[i]]);
      //if Envirnoment <> nil then
      Envirnoment.m_MapFlag.pDigItemList := nil;
    end;
    for i := 0 to Count - 1 do
    begin
      Envirnoment := TEnvirnoment(Self.Values[Self.Keys[i]]);
      for ii := 0 to slist.Count - 1 do
      begin
        if CompareText(slist.Strings[ii], Envirnoment.m_sMapFileName) = 0 then
        begin
          Envirnoment.m_MapFlag.pDigItemList := PTDigItemLists(slist.Objects[ii]);
          Break;
        end;
      end;
    end;
{$ELSE}
    for i := 0 to Count - 1 do
    begin
      Envirnoment := TEnvirnoment(Items[i]);
      if Envirnoment <> nil then
        Envirnoment.m_MapFlag.pDigItemList := nil;
    end;
    for i := 0 to Count - 1 do
    begin
      Envirnoment := TEnvirnoment(Items[i]);
      for ii := 0 to slist.Count - 1 do
      begin
        if slist.Strings[ii] = Envirnoment.m_sMapFileName then
        begin
          Envirnoment.m_MapFlag.pDigItemList := PTDigItemLists(slist.Objects[ii]);
          Break;
        end;
      end;
    end;
{$IFEND}
  finally
    UnLock;
  end;
end;

function TEnvirnoment.IsCheapStuff: Boolean; //004B6E24
begin
  if m_QuestList.Count > 0 then
    Result := True
  else
    Result := False;
end;

function TEnvirnoment.AddToMapItemEvent(nX, nY: Integer; nType: Integer; Event: TObject): TObject;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::AddToMapMineEvent';
begin
  Result := nil;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
    if MapCellInfo.ObjList = nil then
      MapCellInfo.ObjList := TList.Create;
    if nType = OS_EVENTOBJECT then
    begin
      New(OSObject);
      OSObject.btType := nType;
      OSObject.CellObj := Event;
      OSObject.dwAddTime := GetTickCount();
      MapCellInfo.ObjList.Add(OSObject);
      Result := Event;
    end;
  end;
end;

function TEnvirnoment.AddToMapMineEvent(nX, nY: Integer; nType: Integer; Event: TObject): TObject;
var
  Space: Boolean;
  X, Y: Integer;
  MapCellInfo, Mc: pTMapCellinfo;
  OSObject: pTOSObject;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::AddToMapMineEvent';
begin
  Result := nil;
  try
    if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag <> 0) then
    begin

      //人物可以走到的地方才放上矿藏
      Space := False;
      for X := nX - 1 to nX + 1 do
      begin
        for Y := nY - 1 to nY + 1 do
        begin
          if GetMapCellInfo(X, Y, Mc) then
          begin
            if (Mc.chFlag = 0) then
              Space := True;
          end;
          if Space then
            Break;
        end;
        if Space then
          Break;
      end;
      if Space then
      begin
        if MapCellInfo.ObjList = nil then
          MapCellInfo.ObjList := TList.Create;
        if nType = OS_EVENTOBJECT then
        begin
          New(OSObject);
          OSObject.btType := nType;
          OSObject.CellObj := Event;
          OSObject.dwAddTime := GetTickCount();
          MapCellInfo.ObjList.Add(OSObject);
          Result := Event;
        end;
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

procedure TEnvirnoment.VerifyMapTime(nX, nY: Integer; BaseObject: TObject); //004B6980
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  boVerifyPos: Boolean;
//resourcestring
  //sExceptionMsg             = '[Exception] TEnvirnoment::VerifyMapTime';
begin
  //try
  boVerifyPos := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo <> nil) and (MapCellInfo.ObjList <> nil) then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) and (OSObject.CellObj = BaseObject) then
      begin
        OSObject.dwAddTime := GetTickCount();
        boVerifyPos := True;
        Break;
      end;
    end;
  end;
  if not boVerifyPos then
    AddToMap(nX, nY, OS_MOVINGOBJECT, BaseObject);
  //except
  //  MainOutMessageAPI(sExceptionMsg);
  //end;
end;

function TEnvirnoment.ExchangeMapPos(nX, nY, nX2, nY2: Integer; BaseObject: TObject): Boolean;
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject, OSObject2: pTOSObject;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::ExchangeMapPos';
begin
  Result := False;
  if (nX = nX2) and (nY = nY2) then
  begin
    Exit;
  end;

  try
    if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo <> nil) and (MapCellInfo.ObjList <> nil) then
    begin
      for i := MapCellInfo.ObjList.Count - 1 downto 0 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) and (OSObject.CellObj = BaseObject) then
        begin
          New(OSObject2);
          OSObject2^ := OSObject^;
          OSObject2.dwAddTime := GetTickCount();
          Dispose(OSObject);
          MapCellInfo.ObjList.Delete(i);

          TBaseObject(OSObject2.CellObj).m_nCurrX := nX2;
          TBaseObject(OSObject2.CellObj).m_nCurrY := nY2;
          AddToMapEx(nX2, nY2, OSObject2);

          if MapCellInfo.ObjList.Count > 0 then
            Continue;
          MapCellInfo.ObjList.Free;
          MapCellInfo.ObjList := nil;
          Result := True;
          Break;
        end;
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

constructor TEnvirnoment.Create;
begin
  inherited; //0410
  m_nMinMap := 0;
  m_nMonCount := 0;
  m_nHumCount := 0;
  m_nNimbusCount := 0;
  m_nServerIndex := 0;
  m_sMapFileName := '';
  m_DoorList := TList.Create;
  m_QuestList := TList.Create;
  m_MapEvents := TList.Create;
  Pointer(m_MapCellArray) := nil;
end;

destructor TEnvirnoment.Destroy;
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  nX, nY: Integer;
  DoorInfo: pTDoorInfo;
begin
  //if m_MapFlag.sNotAllowUseItems <> nil then
  //  m_MapFlag.sNotAllowUseItems.Free;
  for nX := 0 to m_MapHeader.wWidth - 1 do
  begin
    for nY := 0 to m_MapHeader.wHeight - 1 do
    begin
      if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
      begin
        for i := 0 to MapCellInfo.ObjList.Count - 1 do
        begin
          OSObject := MapCellInfo.ObjList.Items[i];
          case OSObject.btType of
            OS_ITEMOBJECT: Dispose(pTMapItem(OSObject.CellObj));
            OS_GATEOBJECT: Dispose(pTGateObj(OSObject.CellObj));
            OS_EVENTOBJECT: TEvent(OSObject.CellObj).Free;
          end;
          Dispose(OSObject);
        end;
        MapCellInfo.ObjList.Free;
        MapCellInfo.ObjList := nil;
      end;
    end;
  end;

  for i := 0 to m_DoorList.Count - 1 do
  begin
    DoorInfo := m_DoorList.Items[i];
    Dec(DoorInfo.Status.nRefCount);
    if DoorInfo.Status.nRefCount <= 0 then
      Dispose(DoorInfo.Status);
    Dispose(DoorInfo);
  end;
  m_DoorList.Free;

  for i := 0 to m_QuestList.Count - 1 do
    Dispose(pTMapQuestInfo(m_QuestList.Items[i]));
  m_QuestList.Free;

  for i := 0 to m_MapEvents.Count - 1 do
    Dispose(pTMapEvent(m_MapEvents[i]));
  m_MapEvents.Free;

  m_MapFlag.sNotAllowUseMag.Free;
  m_MapFlag.sNotAllowUseItems.Free;
  FreeMem(Pointer(m_MapCellArray));
  Pointer(m_MapCellArray) := nil;

  inherited;
end;

function TEnvirnoment.LoadMapData(sMapFile: string): Boolean; //004B54E0
var
  i, fHandle: Integer;
  nMapSize: Integer;
  n24, nW, nH: Integer;
  MapBuffer: pTMap;
  MapBuffer_New: pTMap_New;
  MapBuffer_New2: pTMap_New2;
  Point: Integer;
  Door: pTDoorInfo;
  MapCellInfo: pTMapCellinfo;
begin
  Result := False;
  if FileExists(sMapFile) then
  begin
    fHandle := FileOpen(sMapFile, fmOpenRead or fmShareExclusive);
    if fHandle > 0 then
    begin
      FileRead(fHandle, m_MapHeader, SizeOf(TMapHeader));
      Initialize(m_MapHeader.wWidth, m_MapHeader.wHeight);
      nMapSize := m_MapHeader.wWidth * SizeOf(TMapUnitInfo) * m_MapHeader.wHeight;
      MapBuffer := AllocMem(nMapSize);
      case Byte(m_MapHeader.Reserved[0]) of
        6:
          begin
            nMapSize := m_MapHeader.wWidth * SizeOf(TMapUnitInfo_New2) * m_MapHeader.wHeight;
            MapBuffer_New2 := AllocMem(nMapSize);
            FileRead(fHandle, MapBuffer_New2^, nMapSize);
            for i := 0 to m_MapHeader.wWidth * m_MapHeader.wHeight - 1 do
              Move(MapBuffer_New2[i], MapBuffer[i], SizeOf(TMapUnitInfo));
            FreeMem(MapBuffer_New2);
          end;
        2:
          begin
            nMapSize := m_MapHeader.wWidth * SizeOf(TMapUnitInfo_New) * m_MapHeader.wHeight;
            MapBuffer_New := AllocMem(nMapSize);
            FileRead(fHandle, MapBuffer_New^, nMapSize);
            for i := 0 to m_MapHeader.wWidth * m_MapHeader.wHeight - 1 do
              Move(MapBuffer_New[i], MapBuffer[i], SizeOf(TMapUnitInfo));
            FreeMem(MapBuffer_New);
          end;
      else
        begin
          FileRead(fHandle, MapBuffer^, nMapSize);
        end;
      end;

      {if Byte(m_MapHeader.Reserved[0]) <> 2 then begin
        FileRead(fHandle, MapBuffer^, nMapSize);
      end else begin
        nMapSize_New := m_MapHeader.wWidth * SizeOf(TMapUnitInfo_New) * m_MapHeader.wHeight;
        MapBuffer_New := AllocMem(nMapSize_New);
        FileRead(fHandle, MapBuffer_New^, nMapSize_New);
        for i := 0 to m_MapHeader.wWidth * m_MapHeader.wHeight - 1 do
          Move(MapBuffer_New[i], MapBuffer[i], SizeOf(TMapUnitInfo));
        FreeMem(MapBuffer_New);
      end;}

{$IF VER_PATHMAP = 1}
      SetLength(m_MapData, m_MapHeader.wWidth, m_MapHeader.wHeight);
{$IFEND}

      for nW := 0 to m_MapHeader.wWidth - 1 do
      begin
        n24 := nW * m_MapHeader.wHeight;
        for nH := 0 to m_MapHeader.wHeight - 1 do
        begin
{$IF VER_PATHMAP = 1}
          if (MapBuffer[n24 + nH].wBkImg) and $8000 = 0 then
            m_MapData[nW, nH] := ttNormal
          else
            m_MapData[nW, nH] := ttObstacle;
{$IFEND}
          if (MapBuffer[n24 + nH].wBkImg) and $8000 <> 0 then
          begin
            MapCellInfo := @m_MapCellArray[n24 + nH];
            MapCellInfo.chFlag := 1;
          end;
          if MapBuffer[n24 + nH].wFrImg and $8000 <> 0 then
          begin
            MapCellInfo := @m_MapCellArray[n24 + nH];
            MapCellInfo.chFlag := 2;
          end;
          if MapBuffer[n24 + nH].btDoorIndex and $80 <> 0 then
          begin
            Point := (MapBuffer[n24 + nH].btDoorIndex and $7F);
            if Point > 0 then
            begin
              New(Door);
              Door.nX := nW;
              Door.nY := nH;
              Door.nPoint := Point;
              Door.Status := nil;
              for i := 0 to m_DoorList.Count - 1 do
              begin
                if abs(pTDoorInfo(m_DoorList.Items[i]).nX - Door.nX) <= 10 then
                begin
                  if abs(pTDoorInfo(m_DoorList.Items[i]).nY - Door.nY) <= 10 then
                  begin
                    if pTDoorInfo(m_DoorList.Items[i]).nPoint = Point then
                    begin
                      Door.Status := pTDoorInfo(m_DoorList.Items[i]).Status;
                      Inc(Door.Status.nRefCount);
                      Break;
                    end;
                  end;
                end;
              end;
              if Door.Status = nil then
              begin
                New(Door.Status);
                Door.Status.boOpened := False;
                Door.Status.dwOpenTick := 0;
                Door.Status.nRefCount := 1;
              end;
              m_DoorList.Add(Door);
            end;
          end;
        end;
      end;
      FreeMem(MapBuffer);
      FileClose(fHandle);
      Result := True;
    end;
  end;
end;

procedure TEnvirnoment.SetNimbusCount(value: Integer);
begin
  if m_nNimbusCount <> value then
    m_nNimbusCount := value;
end;

procedure TEnvirnoment.Initialize(nWidth, nHeight: Integer); //004B53FC
var
  nW, nH: Integer;
  MapCellInfo: pTMapCellinfo;
begin
  if (nWidth > 1) and (nHeight > 1) then
  begin
    if m_MapCellArray <> nil then
    begin
      for nW := 0 to m_MapHeader.wWidth - 1 do
      begin
        for nH := 0 to m_MapHeader.wHeight - 1 do
        begin
          MapCellInfo := @m_MapCellArray[nW * m_MapHeader.wHeight + nH];
          if MapCellInfo.ObjList <> nil then
          begin
            MapCellInfo.ObjList.Free;
            MapCellInfo.ObjList := nil;
          end;
        end;
      end;
      FreeMem(Pointer(m_MapCellArray));
      Pointer(m_MapCellArray) := nil;
    end;
    Pointer(m_MapCellArray) := AllocMem((m_MapHeader.wWidth * m_MapHeader.wHeight) * SizeOf(TMapCellinfo));
  end;
end;

function TEnvirnoment.CreateQuest(nFlag, nValue: Integer; sMonName, sItem, sQuest: string; boGrouped: Boolean): Boolean; //004B6C3C
var
  MapQuest: pTMapQuestInfo;
  MapMerchant: TMerchant;
begin
  Result := False;
  if nFlag < 0 then
    Exit;
  New(MapQuest);
  MapQuest.nFlag := nFlag;
  if nValue > 1 then
    nValue := 1;
  MapQuest.nValue := nValue;
  if sMonName = '*' then
    sMonName := '';
  MapQuest.sMonName := sMonName;
  if sItem = '*' then
    sItem := '';
  MapQuest.sItemName := sItem;
  if sQuest = '*' then
    sQuest := '';
  MapQuest.boGrouped := boGrouped;
  MapMerchant := TMerchant.Create;
  MapMerchant.m_sMapName := '0';
  MapMerchant.m_nCurrX := 0;
  MapMerchant.m_nCurrY := 0;
  MapMerchant.m_sCharName := sQuest;
  MapMerchant.m_sFCharName := FilterCharName(MapMerchant.m_sCharName);
  MapMerchant.m_nFlag := 0;
  MapMerchant.m_wAppr := 0;
  MapMerchant.m_sFilePath := 'MapQuest_def\';
  MapMerchant.m_boIsHide := True;
  MapMerchant.m_boIsQuest := False;

  UserEngine.QuestNPCList.Add(MapMerchant);
  MapQuest.NPC := MapMerchant;
  m_QuestList.Add(MapQuest);
  Result := True;
end;

function TEnvirnoment.GetXYObjCount(nX, nY: Integer): Integer;
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  //pListNode                 : PTWHNode;
begin
  Result := 0;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil){$IF NEWGETMAPCELL = 1} and (MapCellInfo.chFlag <> 1){$IFEND} then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
      begin
        BaseObject := TBaseObject(OSObject.CellObj);
        if BaseObject <> nil then
        begin
          if not BaseObject.m_boGhost and
            BaseObject.m_boHoldPlace and
            not BaseObject.m_boDeath and
            not BaseObject.m_boFixedHideMode and
            not BaseObject.m_boObMode then
          begin
            Inc(Result);
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetXYObjCount_SafeZone(PlayObject: TObject; nX, nY: Integer): Integer;
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  //pListNode                 : PTWHNode;
begin
  Result := 0;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil){$IF NEWGETMAPCELL = 1} and (MapCellInfo.chFlag <> 1){$IFEND} then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
      begin
        BaseObject := TBaseObject(OSObject.CellObj);
        if BaseObject <> nil then
        begin
          if not BaseObject.m_boGhost and
            BaseObject.m_boHoldPlace and
            not BaseObject.m_boDeath and
            not BaseObject.m_boFixedHideMode and
            not BaseObject.m_boObMode and
            ((BaseObject.m_btRaceServer in [RC_NPC, RC_PEACENPC]) or (BaseObject = PlayObject)) then
          begin
            Inc(Result);
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetNextPosition(sX, sY, nDir, nFlag: Integer; var snx: Integer; var sny: Integer): Boolean;
begin
  snx := sX;
  sny := sY;
  case nDir of
    DR_UP: if sny > nFlag - 1 then
        Dec(sny, nFlag);
    DR_DOWN: if sny < (m_MapHeader.wHeight - nFlag) then
        Inc(sny, nFlag);
    DR_LEFT: if snx > nFlag - 1 then
        Dec(snx, nFlag);
    DR_RIGHT: if snx < (m_MapHeader.wWidth - nFlag) then
        Inc(snx, nFlag);
    DR_UPLEFT:
      begin
        if (snx > nFlag - 1) and (sny > nFlag - 1) then
        begin
          Dec(snx, nFlag);
          Dec(sny, nFlag);
        end;
      end;
    DR_UPRIGHT:
      begin
        if (snx > nFlag - 1) and (sny < (m_MapHeader.wHeight - nFlag)) then
        begin
          Inc(snx, nFlag);
          Dec(sny, nFlag);
        end;
      end;
    DR_DOWNLEFT:
      begin
        if (snx < (m_MapHeader.wWidth - nFlag)) and (sny > nFlag - 1) then
        begin
          Dec(snx, nFlag);
          Inc(sny, nFlag);
        end;
      end;
    DR_DOWNRIGHT:
      begin
        if (snx < (m_MapHeader.wWidth - nFlag)) and (sny < (m_MapHeader.wHeight - nFlag)) then
        begin
          Inc(snx, nFlag);
          Inc(sny, nFlag);
        end;
      end;
  end;
  if (snx = sX) and (sny = sY) then
    Result := False
  else
    Result := True;
end;

function TEnvirnoment.CanSafeWalk(nX, nY: Integer): Boolean; //004B609C
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
    Result := True;
    if MapCellInfo.ObjList = nil then
      Exit;
    for i := MapCellInfo.ObjList.Count - 1 downto 0 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if (OSObject <> nil) and (OSObject.btType = OS_EVENTOBJECT) then
      begin
        if TEvent(OSObject.CellObj).m_nDamage > 0 then
        begin
          Result := False;
          Break; //0615
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.ArroundDoorOpened(nX, nY: Integer): Boolean; //004B6B48
var
  i: Integer;
  Door: pTDoorInfo;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::ArroundDoorOpened ';
begin
  Result := True;
  try
    for i := 0 to m_DoorList.Count - 1 do
    begin
      Door := m_DoorList.Items[i];
      if (abs(Door.nX - nX) <= 1) and ((abs(Door.nY - nY) <= 1)) then
      begin
        if not Door.Status.boOpened then
        begin
          Result := False;
          Break;
        end;
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

function TEnvirnoment.GetMovingObject(nX, nY: Integer; boFlag: Boolean): Pointer; //0618
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := nil;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil){$IF NEWGETMAPCELL = 1} and (MapCellInfo.chFlag <> 1){$IFEND} then
  begin
    for i := MapCellInfo.ObjList.Count - 1 downto 0 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
      begin
        BaseObject := TBaseObject(OSObject.CellObj);
        if (BaseObject <> nil) and
          not BaseObject.m_boGhost and
          BaseObject.m_boHoldPlace and
          (not boFlag or not BaseObject.m_boDeath) then
        begin
          Result := BaseObject;
          Break;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetMovingObjectA(nX, nY: Integer; boFlag: Boolean): Pointer; //0618
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := nil;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil){$IF NEWGETMAPCELL = 1} and (MapCellInfo.chFlag <> 1){$IFEND} then
  begin
    for i := MapCellInfo.ObjList.Count - 1 downto 0 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if OSObject <> nil then
      begin
        if (OSObject.btType = OS_MOVINGOBJECT) then
        begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if (BaseObject <> nil) and
            not BaseObject.m_boGhost and
            not (BaseObject.m_btRaceServer in [RC_NPC, RC_PEACENPC]) and
            BaseObject.m_boHoldPlace and
            (not boFlag or not BaseObject.m_boDeath) then
          begin
            Result := BaseObject;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetQuestNPC(BaseObject: TObject; sCharName, sItem: string; boFlag: Boolean): TObject; //004B6E4C
var
  i: Integer;
  MapQuestFlag: pTMapQuestInfo;
  nFlagValue: Integer;
  bo1D: Boolean;
begin
  Result := nil;
  for i := 0 to m_QuestList.Count - 1 do
  begin
    MapQuestFlag := m_QuestList.Items[i];
    nFlagValue := TPlayObject(BaseObject).GetQuestFalgStatus(MapQuestFlag.nFlag);
    if nFlagValue = MapQuestFlag.nValue then
    begin
      if (boFlag = MapQuestFlag.boGrouped) or (not boFlag) then
      begin
        bo1D := False;
        if (MapQuestFlag.sMonName <> '') and (MapQuestFlag.sItemName <> '') then
        begin
          if (MapQuestFlag.sMonName = sCharName) and (MapQuestFlag.sItemName = sItem) then
          begin
            Result := MapQuestFlag.NPC;
            Break;
          end;
        end;
        if (MapQuestFlag.sMonName <> '') and (MapQuestFlag.sItemName = '') then
        begin
          if (MapQuestFlag.sMonName = sCharName) and (sItem = '') then
          begin
            Result := MapQuestFlag.NPC;
            Break;
          end;
        end;
        if (MapQuestFlag.sMonName = '') and (MapQuestFlag.sItemName <> '') then
        begin
          if (MapQuestFlag.sItemName = sItem) then
          begin
            Result := MapQuestFlag.NPC;
            Break;
          end;
        end;

        if bo1D then
        begin
          Result := MapQuestFlag.NPC;
          Break;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetItemEx(nX, nY: Integer; var nCount: Integer): Pointer; //004B5C10
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := nil;
  nCount := 0;
  m_boChFlag := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
    m_boChFlag := True;
    if MapCellInfo.ObjList <> nil then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if OSObject <> nil then
        begin
          if OSObject.btType = OS_ITEMOBJECT then
          begin
            Result := Pointer(OSObject.CellObj);
            Inc(nCount);
          end;
          if OSObject.btType = OS_GATEOBJECT then
            m_boChFlag := False;
          if OSObject.btType = OS_MOVINGOBJECT then
          begin
            BaseObject := TBaseObject(OSObject.CellObj);
            if not BaseObject.m_boDeath then
              m_boChFlag := False;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetDoor(nX, nY: Integer): pTDoorInfo; //004B6ACC
var
  i: Integer;
  Door: pTDoorInfo;
begin
  Result := nil;
  for i := 0 to m_DoorList.Count - 1 do
  begin
    Door := m_DoorList.Items[i];
    if (Door.nX = nX) and (Door.nY = nY) then
    begin
      Result := Door;
      Exit;
    end;
  end;
end;

function TEnvirnoment.IsValidObject(nX, nY, nRage: Integer; BaseObject: TObject): Boolean;
var
  nXX, nYY, i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := False;
  for nXX := nX - nRage to nX + nRage do
  begin
    for nYY := nY - nRage to nY + nRage do
    begin
      if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil){$IF NEWGETMAPCELL = 1} and (MapCellInfo.chFlag <> 1){$IFEND} then
      begin
        for i := 0 to MapCellInfo.ObjList.Count - 1 do
        begin
          OSObject := MapCellInfo.ObjList.Items[i];
          if OSObject.CellObj = BaseObject then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetRangeBaseObject(nX, nY, nRage: Integer; boFlag: Boolean; BaseObjectList: TList): Integer;
var
  nXX, nYY: Integer;
begin
  if nRage <= 0 then
  begin
    GetBaseObjects(nX, nY, boFlag, BaseObjectList);
  end
  else
  begin
    for nXX := nX - nRage to nX + nRage do
    begin
      for nYY := nY - nRage to nY + nRage do
        GetBaseObjects(nXX, nYY, boFlag, BaseObjectList);
    end;
  end;
  Result := BaseObjectList.Count;
end;

function TEnvirnoment.GetBaseObjects(nX, nY: Integer; boFlag: Boolean; BaseObjectList: TList): Integer; //004B58F8
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil){$IF NEWGETMAPCELL = 1} and (MapCellInfo.chFlag <> 1){$IFEND} then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
      begin
        BaseObject := TBaseObject(OSObject.CellObj);
        if BaseObject <> nil then
        begin
          if not BaseObject.m_boGhost and BaseObject.m_boHoldPlace then
          begin
            if not boFlag or not BaseObject.m_boDeath then
              BaseObjectList.Add(BaseObject);
          end;
        end;
      end;
    end;
  end;
  Result := BaseObjectList.Count;
end;

function TEnvirnoment.GetEvent(nX, nY: Integer): TObject; //004B5D24
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := nil;
  m_boChFlag := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if (OSObject <> nil) and (OSObject.btType = OS_EVENTOBJECT) then
      begin
        Result := OSObject.CellObj;
        Break; //0618
      end;
    end;
    {for i := MapCellInfo.ObjList.Count - 1 downto 0 do begin     //0410
      OSObject := MapCellInfo.ObjList.Items[i];
      if (OSObject <> nil) and (OSObject.btType = OS_EVENTOBJECT) then begin
        Result := OSObject.CellObj;
        Break;
      end;
    end;}
  end;
end;

function TEnvirnoment.GetRangeEvent(nX, nY, range, id: Integer): TObject;
var
  i, X, Y: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := nil;
  m_boChFlag := False;
  if not (range in [1..10]) then
    Exit;

  for X := nX - range to nX + range do
  begin
    for Y := nY - range to nY + range do
    begin
      if GetMapCellInfo(X, Y, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
      begin
        for i := 0 to MapCellInfo.ObjList.Count - 1 do
        begin
          OSObject := MapCellInfo.ObjList.Items[i];
          if (OSObject <> nil) and (OSObject.btType = OS_EVENTOBJECT) and (id = Integer(OSObject.CellObj)) then
          begin
            Result := OSObject.CellObj;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

procedure TEnvirnoment.GetMarkMovement(nX, nY: Integer; boFlag: Boolean); //004B5E8C
var
  MapCellInfo: pTMapCellinfo;
begin
  if GetMapCellInfo(nX, nY, MapCellInfo) then
  begin
    if boFlag then
      MapCellInfo.chFlag := 0
    else
      MapCellInfo.chFlag := 2;
  end;
end;

function TEnvirnoment.CanFly(nSX, nSY, nDX, nDY: Integer): Boolean; //004B600C
var
  r28, r30: real;
  n14, n18, n1C: Integer;
begin
  Result := True;
  r28 := (nDX - nSX) / 1.0E1;
  r30 := (nDY - nDX) / 1.0E1;
  n14 := 0;
  while (True) do
  begin
    n18 := Round(nSX + r28);
    n1C := Round(nSY + r30);
    if not CanWalk(n18, n1C, True) then
    begin
      Result := False;
      Break;
    end;
    Inc(n14);
    if n14 >= 10 then
      Break;
  end;
end;

function TEnvirnoment.GetXYHuman(nMapX, nMapY: Integer): Boolean;
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := False;
  if GetMapCellInfo(nMapX, nMapY, MapCellInfo) and (MapCellInfo.ObjList <> nil){$IF NEWGETMAPCELL = 1} and (MapCellInfo.chFlag <> 1){$IFEND} then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then
      begin
        BaseObject := TBaseObject(OSObject.CellObj);
        if (BaseObject <> nil) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.IsValidCell(nX, nY: Integer): Boolean; //0x004B5FC8
var
  MapCellInfo: pTMapCellinfo;
begin
  Result := True;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 2) then
    Result := False;
end;

function TEnvirnoment.GetEnvirInfo: string;
var
  sMsg: string;
begin
  sMsg := '地图名:%s(%s) DAY:%s DARK:%s SAFE:%s FIGHT:%s FIGHT3:%s QUIZ:%s NORECONNECT:%s(%s) MUSIC:%s(%d) EXPRATE:%s(%f) PKWINLEVEL:%s(%d) PKLOSTLEVEL:%s(%d) PKWINEXP:%s(%d) PKLOSTEXP:%s(%d) DECHP:%s(%d/%d) INCHP:%s(%d/%d)';
  sMsg := sMsg + ' DECGAMEGOLD:%s(%d/%d) INCGAMEGOLD:%s(%d/%d) INCGAMEPOINT:%s(%d/%d) RUNHUMAN:%s RUNMON:%s NEEDHOLE:%s NORECALL:%s NOGUILDRECALL:%s NODEARRECALL:%s NOMASTERRECALL:%s NODRUG:%s MINE:%s NOPOSITIONMOVE:%s';
  Result := Format(sMsg, [m_sMapFileName,
    m_sMapDesc,
      BoolToCStr(m_MapFlag.boDAY),
      BoolToCStr(m_MapFlag.boDARK),
      BoolToCStr(m_MapFlag.boSAFE),
      BoolToCStr(m_MapFlag.boFIGHTZone),
      BoolToCStr(m_MapFlag.boFIGHT3Zone),
      BoolToCStr(m_MapFlag.boQUIZ),
      BoolToCStr(m_MapFlag.boNORECONNECT), m_MapFlag.sReConnectMap,
      BoolToCStr(m_MapFlag.boMUSIC), m_MapFlag.nMUSICID,
      BoolToCStr(m_MapFlag.boEXPRATE), m_MapFlag.nEXPRATE / 100,
      BoolToCStr(m_MapFlag.boPKWINLEVEL), m_MapFlag.nPKWINLEVEL,
      BoolToCStr(m_MapFlag.boPKLOSTLEVEL), m_MapFlag.nPKLOSTLEVEL,
      BoolToCStr(m_MapFlag.boPKWINEXP), m_MapFlag.nPKWINEXP,
      BoolToCStr(m_MapFlag.boPKLOSTEXP), m_MapFlag.nPKLOSTEXP,
      BoolToCStr(m_MapFlag.boDECHP), m_MapFlag.nDECHPTIME, m_MapFlag.nDECHPPOINT,
      BoolToCStr(m_MapFlag.boINCHP), m_MapFlag.nINCHPTIME, m_MapFlag.nINCHPPOINT,
      BoolToCStr(m_MapFlag.boDECGAMEGOLD), m_MapFlag.nDECGAMEGOLDTIME, m_MapFlag.nDECGAMEGOLD,
      BoolToCStr(m_MapFlag.boINCGAMEGOLD), m_MapFlag.nINCGAMEGOLDTIME, m_MapFlag.nINCGAMEGOLD,
      BoolToCStr(m_MapFlag.boINCGAMEPOINT), m_MapFlag.nINCGAMEPOINTTIME, m_MapFlag.nINCGAMEPOINT,
      BoolToCStr(m_MapFlag.boRUNHUMAN),
      BoolToCStr(m_MapFlag.boRUNMON),
      BoolToCStr(m_MapFlag.boNEEDHOLE),
      BoolToCStr(m_MapFlag.boNORECALL),
      BoolToCStr(m_MapFlag.boNOGUILDRECALL),
      BoolToCStr(m_MapFlag.boNODEARRECALL),
      BoolToCStr(m_MapFlag.boNOMASTERRECALL),
      BoolToCStr(m_MapFlag.boNODRUG),
      BoolToCStr(m_MapFlag.boMINE),
      BoolToCStr(m_MapFlag.boNOPOSITIONMOVE)
      ]);
end;

procedure TEnvirnoment.AddObjectCount(BaseObject: TObject);
var
  btRaceServer: Byte;
begin
  btRaceServer := TBaseObject(BaseObject).m_btRaceServer;
  if btRaceServer = RC_PLAYOBJECT then
    Inc(m_nHumCount);
  if btRaceServer >= RC_ANIMAL then
    Inc(m_nMonCount);
  //m_nNimbusCount
end;

procedure TEnvirnoment.DelObjectCount(BaseObject: TObject);
var
  btRaceServer: Byte;
begin
  btRaceServer := TBaseObject(BaseObject).m_btRaceServer;
  if btRaceServer = RC_PLAYOBJECT then
    Dec(m_nHumCount);
  if btRaceServer >= RC_ANIMAL then
    Dec(m_nMonCount);
  //m_nNimbusCount
end;

procedure TMapManager.Run;
begin
  //
end;

{$IF VER_PATHMAP = 1}

constructor TPathMap.Create;
begin
  inherited;
  m_nPathWidth := 0;
  m_mLatestWayPointList := TGList.Create;
end;

destructor TPathMap.Destroy;
var
  i: Integer;
begin
  for i := 0 to m_mLatestWayPointList.Count - 1 do
    Dispose(pTWayPointInfo(m_mLatestWayPointList[i]));
  m_mLatestWayPointList.Free;
  inherited;
end;

function TPathMap.FindPathOnMap(X, Y: Integer): TPath;
var
  Direction: Integer;
begin
  Result := nil;
  if (X >= m_MapHeader.wWidth) or (Y >= m_MapHeader.wHeight) then
    Exit;
  if m_PathMapArray[Y, X].Distance < 0 then
    Exit;
  SetLength(Result, m_PathMapArray[Y, X].Distance + 1);
  while m_PathMapArray[Y, X].Distance > 0 do
  begin
    Result[m_PathMapArray[Y, X].Distance] := Point(X, Y);
    Direction := m_PathMapArray[Y, X].Direction;
    X := X - DirToDX(Direction);
    Y := Y - DirToDY(Direction);
  end;
  Result[0] := Point(X, Y);
end;

function TPathMap.DirToDX(Direction: Integer): Integer;
begin
  case Direction of
    0, 4: Result := 0;
    1..3: Result := 1;
  else
    Result := -1;
  end;
end;

function TPathMap.DirToDY(Direction: Integer): Integer;
begin
  case Direction of
    2, 6: Result := 0;
    3..5: Result := 1;
  else
    Result := -1;
  end;
end;

function TPathMap.GetCost(X, Y, Direction: Integer): Integer;
var
  Cost: Integer;
begin
  Direction := (Direction and 7);
  if (X < 0) or (X >= m_MapHeader.wWidth) or (Y < 0) or (Y >= m_MapHeader.wHeight) then
    Result := -1
  else
  begin
    Result := TerrainParams[m_MapData[X, Y]];
    if (X < m_MapHeader.wWidth - m_nPathWidth) and (X > m_nPathWidth) and (Y < m_MapHeader.wHeight - m_nPathWidth) and (Y > m_nPathWidth) then
    begin
      Cost := TerrainParams[m_MapData[X - m_nPathWidth, Y]] + TerrainParams[m_MapData[X + m_nPathWidth, Y]] + TerrainParams[m_MapData[X, Y - m_nPathWidth]] + TerrainParams[m_MapData[X, Y + m_nPathWidth]];
      if Cost < 4 * TerrainParams[ttNormal] then
        Result := -1;
    end;
    if ((Direction and 1) = 1) and (Result > 0) then
      Result := Result + (Result shr 1);
  end;
end;

{function TPathMap.GetCost(X, Y, Direction: Integer): Integer;
begin
  Direction := (Direction and 7);
  if (X < 0) or (X >= m_MapHeader.wWidth) or (Y < 0) or (Y >= m_MapHeader.wHeight) then
    Result := -1
  else
    Result := m_GetCostFunc(X, Y, Direction, m_nPathWidth);
end;}

function TPathMap.FillPathMap(X1, Y1, X2, Y2: Integer): TPathMapArray;
var
  X, Y: Integer;
  OldWave, NewWave: TWave;
  Finished: Boolean;
  i: TWaveCell;

  procedure TestNeighbours;
  var
    X, Y, c, d: Integer;
  begin
    for d := 0 to 7 do
    begin
      X := OldWave.item.X + DirToDX(d);
      Y := OldWave.item.Y + DirToDY(d);
      c := GetCost(X, Y, d);
      if (c >= 0) and (Result[Y, X].Distance < 0) then
        NewWave.Add(X, Y, c, d);
    end;
  end;

  procedure ExchangeWaves;
  var
    W: TWave;
  begin
    W := OldWave;
    OldWave := NewWave;
    NewWave := W;
    NewWave.Clear;
  end;

begin
  Finished := ((X1 = X2) and (Y1 = Y2));
  if Finished then
    Exit;

  SetLength(Result, m_MapHeader.wHeight, m_MapHeader.wWidth);
  for Y := 0 to (m_MapHeader.wHeight - 1) do
    for X := 0 to (m_MapHeader.wWidth - 1) do
      Result[Y, X].Distance := -1;

  OldWave := TWave.Create;
  NewWave := TWave.Create;
  Result[Y1, X1].Distance := 0; // 起点Distance:=0
  OldWave.Add(X1, Y1, 0, 0); //将起点加入OldWave
  TestNeighbours;

  //Finished := ((X1 = X2) and (Y1 = Y2)); //检验是否到达终点
  while not Finished do
  begin
    ExchangeWaves; //
    if not OldWave.start then
      Break;
    repeat
      i := OldWave.item;
      i.Cost := i.Cost - OldWave.MinCost; // 如果大于MinCost
      if i.Cost > 0 then // 加入NewWave
        NewWave.Add(i.X, i.Y, i.Cost, i.Direction) //更新Cost= cost-MinCost
      else
      begin //  处理最小COST的点
        if Result[i.Y, i.X].Distance >= 0 then
          Continue;
        Result[i.Y, i.X].Distance := Result[i.Y - DirToDY(i.Direction), i.X - DirToDX(i.Direction)].Distance + 1;
        Result[i.Y, i.X].Direction := i.Direction;
        Finished := ((i.X = X2) and (i.Y = Y2)); //检验是否到达终点
        if Finished then
          Break;
        TestNeighbours;
      end;

    until not OldWave.Next;
  end;
  NewWave.Free;
  OldWave.Free;
end;

constructor TWave.Create;
begin
  Clear;
end;

destructor TWave.Destroy;
begin
  FData := nil;
  inherited Destroy;
end;

function TWave.GetItem: TWaveCell;
begin
  Result := FData[FPos];
end;

procedure TWave.Add(NewX, NewY, NewCost, NewDirection: Integer);
begin
  if FCount >= Length(FData) then
    SetLength(FData, Length(FData) + $400 {30});
  with FData[FCount] do
  begin
    X := NewX;
    Y := NewY;
    Cost := NewCost;
    Direction := NewDirection;
  end;
  Inc(FCount);
  if NewCost < FMinCost then
    FMinCost := NewCost;
end;

procedure TWave.Clear;
begin
  FPos := 0;
  FCount := 0;
  FMinCost := High(Integer);
end;

function TWave.start: Boolean;
begin
  FPos := 0;
  Result := (FCount > 0);
end;

function TWave.Next: Boolean;
begin
  Inc(FPos);
  Result := (FPos < FCount);
end;

{function TEnvirnoment.FindPath(StopX, StopY: Integer): TPath;
begin
  Result := FindPathOnMap(StopX, StopY);
end;}

function TEnvirnoment.FindPath(StartX, StartY, StopX, StopY, PathSpace: Integer): TPath;
begin
  m_nPathWidth := PathSpace;
  m_PathMapArray := FillPathMap(StartX, StartY, StopX, StopY);
  Result := FindPathOnMap(StopX, StopY);
end;

procedure TEnvirnoment.SetStartPos(StartX, StartY, PathSpace: Integer);
begin
  m_nPathWidth := PathSpace;
  m_PathMapArray := FillPathMap(StartX, StartY, -1, -1);
end;

{$IFEND}

procedure TEnvirnoment.LoadMapEventList();
var
  i, nX, nY: Integer;
  sFileName: string;
  LoadList: TStringList;
  sLineText: string;
  sMapName, sCurrX, sCurrY, sFlag, sCondition, sRate, sEnent: string;
  sFlag_a, sFlag_b, sCondition_a, sCondition_b, sCondition_c, sEnent_a, sEnent_b: string;
  MapEvent: pTMapEvent;
begin
  sFileName := g_Config.sEnvirDir + 'MapEvent.txt';
  if not FileExists(sFileName) then
  begin
    LoadList := TStringList.Create();
    LoadList.Add(';地图事件触发列表');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;

  for i := 0 to m_MapEvents.Count - 1 do
    Dispose(pTMapEvent(m_MapEvents[i]));
  m_MapEvents.Clear;

  LoadList := TStringList.Create();
  LoadList.LoadFromFile(sFileName);
  for i := 0 to LoadList.Count - 1 do
  begin
    sLineText := Trim(LoadList.Strings[i]);
    if (sLineText <> '') and (sLineText[1] <> ';') then
    begin
      sLineText := GetValidStr3(sLineText, sMapName, [#9, ' ']);
      if m_sMapFileName <> sMapName then
        Continue;
      sLineText := GetValidStr3(sLineText, sCurrX, [#9, ' ']);
      sLineText := GetValidStr3(sLineText, sCurrY, [#9, ' ']);
      sLineText := GetValidStr3(sLineText, sFlag, [#9, ' ']);
      sLineText := GetValidStr3(sLineText, sCondition, [#9, ' ']);
      sLineText := GetValidStr3(sLineText, sRate, [#9, ' ']);
      sLineText := GetValidStr3(sLineText, sEnent, [#9, ' ']);

      //if m_sMapFileName <> sMapName then continue;

      if TryStrToInt(sCurrX, nX) and TryStrToInt(sCurrY, nY) then
      begin
        New(MapEvent);
        MapEvent.nCurrX := nX;
        MapEvent.nCurrY := nY;
        sFlag := GetValidStr3(sFlag, sFlag_a, [':']);
        sFlag := GetValidStr3(sFlag, sFlag_b, [':']);
        MapEvent.cFlag.nFlag := StrToIntDef(sFlag_a, 0);
        MapEvent.cFlag.boFlag := StrToIntDef(sFlag_b, 0) > 0;

        sCondition := GetValidStr3(sCondition, sCondition_a, [':']);
        sCondition := GetValidStr3(sCondition, sCondition_b, [':']);
        sCondition := GetValidStr3(sCondition, sCondition_c, [':']);
        MapEvent.cCondition.nAction := StrToIntDef(sCondition_a, 0);
        MapEvent.cCondition.sItemName := sCondition_b;
        MapEvent.cCondition.boGroup := StrToIntDef(sCondition_c, 0) > 0;

        MapEvent.nRate := StrToIntDef(sRate, 0);

        sEnent := GetValidStr3(sEnent, sEnent_a, [':']);
        sEnent := GetValidStr3(sEnent, sEnent_b, [':']);
        MapEvent.cEnent.boCall := StrToIntDef(sEnent_a, 0) > 0;
        MapEvent.cEnent.sLabel := sEnent_b;
        m_MapEvents.Add(MapEvent);
      end;
    end;
  end;
  LoadList.Free;
end;

end.
