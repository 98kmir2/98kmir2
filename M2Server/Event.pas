unit Event;

interface

uses
  Windows, Classes, SysUtils, SyncObjs, ObjBase, Envir, Grobal2, MudUtil;

type
  TEvent = class
    m_nVisibleFlag: Integer;
    m_Envir: TEnvirnoment;
    m_nX: Integer;
    m_nY: Integer;
    m_nEventType: Integer;
    m_nEventParam: Integer;
    m_nEventLevel: Integer;
    m_dwOpenStartTick: LongWord;
    m_dwContinueTime: LongWord;
    m_dwCloseTick: LongWord;
    m_boClosed: Boolean;
    m_nDamage: Integer;
    m_Owner: TBaseObject;
    m_dwRunStart: LongWord;
    //m_dwRunTick: LongWord;
    m_boVisible: Boolean;
    m_boActive: Boolean;

    m_boAddToMap: Boolean;
  public
    constructor Create(tEnvir: TEnvirnoment; nTX, nTY, nType, dwETime: Integer; boVisible: Boolean);
    destructor Destroy; override;
    procedure Run(); virtual;
    procedure Close();
    //function IsWork(): Boolean;
    function CanClose(): Boolean;
  end;

  TStoneMineEvent = class(TEvent)
    m_nMineCount: Integer;
    m_nAddStoneCount: Integer;
    m_dwAddStoneMineTick: LongWord;
  public
    constructor Create(Envir: TEnvirnoment; nX, nY: Integer; nType: Integer);
    procedure AddStoneMine();
  end;

  TPileStones = class(TEvent)
  public
    constructor Create(Envir: TEnvirnoment; nX, nY: Integer; nType, nTime: Integer);
    procedure AddEventParam();
  end;

  THolyCurtainEvent = class(TEvent)
  public
    constructor Create(Envir: TEnvirnoment; nX, nY: Integer; nType, nTime: Integer);
  end;

  TFireBurnEvent = class(TEvent)
    m_dwTickTime: LongWord;
  public
    constructor Create(Creat: TBaseObject; nX, nY: Integer; nType: Integer; nTime, nDamage, nLevel: Integer);
    procedure Run(); override;
  end;

  TSafeZoneAureoleEvent = class(TEvent)
  public
    constructor Create(Envir: TEnvirnoment; nX, nY, nType: Integer);
    procedure Run(); override;
  end;

  TNimbusEvent = class(TEvent)
  public
    constructor Create(Envir: TEnvirnoment; nX, nY, nType, nTime: Integer);
    procedure Run(); override;
  end;

  TEventManager = class
    m_EventList: TGList;
    m_ClosedEventList: TGList;
  public
    constructor Create();
    destructor Destroy; override;
    function GetEvent(Envir: TEnvirnoment; nX, nY: Integer; nType: Integer): TEvent;
    procedure AddEvent(Event: TEvent);
    procedure Run();
  end;

  TMagicEvent = record
    BaseObjectList: TList;
    dwStartTick: LongWord;
    dwTime: LongWord;
    Events: array[0..7] of THolyCurtainEvent;
  end;
  pTMagicEvent = ^TMagicEvent;

implementation

uses M2Share;

{TAureoleEvent}

constructor TSafeZoneAureoleEvent.Create(Envir: TEnvirnoment; nX, nY, nType: Integer);
begin
  inherited Create(Envir, nX, nY, nType, 45 * 1000, True);
  m_boActive := False;
end;

procedure TSafeZoneAureoleEvent.Run;
begin
  m_dwOpenStartTick := GetTickCount;
  inherited Run;
end;

{ TNimbusEvent }

constructor TNimbusEvent.Create(Envir: TEnvirnoment; nX, nY, nType, nTime: Integer);
begin
  inherited Create(Envir, nX, nY, nType, nTime * 1000, True);
  //m_boActive := False;
end;

procedure TNimbusEvent.Run;
begin
  //m_dwOpenStartTick := GetTickCount;
  inherited Run;
end;

{ TStoneMineEvent }

constructor TStoneMineEvent.Create(Envir: TEnvirnoment; nX, nY, nType: Integer);
begin
  inherited Create(Envir, nX, nY, nType, 0, False);
  if nType in [ET_ITEMMINE1..ET_ITEMMINE3] then
  begin
    m_boAddToMap := m_Envir.AddToMapItemEvent(nX, nY, OS_EVENTOBJECT, self) <> nil;
    m_boVisible := False;
    m_nMineCount := Random(2000) + 300;
    m_dwAddStoneMineTick := GetTickCount();
    m_boActive := False;
    m_nAddStoneCount := Random(800) + 100;
  end
  else
  begin
    m_boAddToMap := m_Envir.AddToMapMineEvent(nX, nY, OS_EVENTOBJECT, self) <> nil;
    m_boVisible := False;
    m_nMineCount := Random(200) + 1;
    m_dwAddStoneMineTick := GetTickCount();
    m_boActive := False;
    m_nAddStoneCount := Random(80) + 1; //0710
  end;
end;

procedure TStoneMineEvent.AddStoneMine;
begin
  m_nMineCount := m_nAddStoneCount;
  m_dwAddStoneMineTick := GetTickCount();
end;

{ TEventManager }

procedure TEventManager.Run;
var
  i: Integer;
  Event: TEvent;
//resourcestring
  //sExceptionMsg             = '[Exception] TEventManager::Run %d';
  //sExceptionMsg2            = '[Exception] TEventManager::Run FreeMem %d';
begin
  m_EventList.Lock;
  try
    for i := m_EventList.Count - 1 downto 0 do
    begin
      Event := TEvent(m_EventList.Items[i]);
      if Event.m_boActive and ((GetTickCount - Event.m_dwRunStart) > 500) then
      begin
        Event.m_dwRunStart := GetTickCount();
        if Event.m_boClosed then
        begin
          m_EventList.Delete(i);

          m_ClosedEventList.Lock;
          try
            m_ClosedEventList.Add(Event);
          finally
            m_ClosedEventList.UnLock;
          end;
        end
        else
        begin
          Event.Run();
        end;
      end;
    end;
  finally
    m_EventList.UnLock;
  end;

  (*nCheckCode := 0;
  //try
  m_EventList.Lock;
  try
    i := 0;
    nCheckCode := 0;
    while (True) do begin
      if m_EventList.Count <= i then Break;
      Event := TEvent(m_EventList.Items[i]);
      nCheckCode := 2;
      if Event.m_boActive and ((GetTickCount - Event.m_dwRunStart) > 500 {Event.m_dwRunTick}) then begin
        Event.m_dwRunStart := GetTickCount();
        nCheckCode := 4;

        if not Event.m_boClosed then
          Event.Run();

        nCheckCode := 5;
        if Event.m_boClosed then begin
          nCheckCode := 6;
          m_ClosedEventList.Lock;
          try
            m_ClosedEventList.Add(Event);
          finally
            m_ClosedEventList.UnLock;
          end;
          m_EventList.Delete(i);
        end else
          Inc(i);
      end else
        Inc(i);
    end;
  finally
    m_EventList.UnLock;
  end;
  {except
    on E: Exception do begin
      MainOutMessageAPI(Format(sExceptionMsg, [nCheckCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;}
  *)

  //nCheckCode := 8;
  //try
  m_ClosedEventList.Lock;
  try
    // nCheckCode := 9;
    for i := m_ClosedEventList.Count - 1 downto 0 do
    begin
      Event := TEvent(m_ClosedEventList.Items[i]);
      if GetTickCount - Event.m_dwCloseTick > 5 * 60 * 1000 then
      begin
        // nCheckCode := 12;
        m_ClosedEventList.Delete(i);
        // nCheckCode := 13;
        TEvent(Event).Free;
      end;
    end;
  finally
    m_ClosedEventList.UnLock;
  end;
  {except
    on E: Exception do begin
      MainOutMessageAPI(Format(sExceptionMsg2, [nCheckCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;}
end;

function TEventManager.GetEvent(Envir: TEnvirnoment; nX, nY, nType: Integer): TEvent;
var
  i: Integer;
  Event: TEvent;
begin
  Result := nil;
  m_EventList.Lock;
  try
    for i := 0 to m_EventList.Count - 1 do
    begin
      Event := TEvent(m_EventList.Items[i]);
      if (Event.m_Envir = Envir) and
        (Event.m_nX = nX) and
        (Event.m_nY = nY) and
        (Event.m_nEventType = nType) then
      begin
        Result := Event;
        Break;
      end;
    end;
  finally
    m_EventList.UnLock;
  end;
end;

procedure TEventManager.AddEvent(Event: TEvent);
begin
  if (Event = nil) or not Event.m_boVisible then
    Exit; //0710
  m_EventList.Lock;
  try
    m_EventList.Add(Event);
  finally
    m_EventList.UnLock;
  end;
end;

constructor TEventManager.Create();
begin
  m_EventList := TGList.Create;
  m_ClosedEventList := TGList.Create;
end;

destructor TEventManager.Destroy;
var
  i: Integer;
  Event: TEvent;
begin
  {
   //  不能再释放   因为在envir地图释放的地方已经将对应的地图事件释放
    for i := 0 to m_EventList.Count - 1 do
    begin
      if TEvent(m_EventList.Items[i]) <> nil then
        TEvent(m_EventList.Items[i]).Free;
    end;
  }
  m_EventList.Free;

  for i := 0 to m_ClosedEventList.Count - 1 do
  begin
    if TEvent(m_ClosedEventList.Items[i]) <> nil then
      TEvent(m_ClosedEventList.Items[i]).Free;
  end;
  m_ClosedEventList.Free;
  inherited;
end;

{ THolyCurtainEvent }

constructor THolyCurtainEvent.Create(Envir: TEnvirnoment; nX, nY, nType, nTime: Integer);
begin
  inherited Create(Envir, nX, nY, nType, nTime, True);
end;

{ TFireBurnEvent }

constructor TFireBurnEvent.Create(Creat: TBaseObject; nX, nY, nType, nTime, nDamage, nLevel: Integer);
begin
  inherited Create(Creat.m_PEnvir, nX, nY, nType, nTime, True);
  m_nDamage := nDamage;
  m_Owner := Creat;
  m_nEventLevel := nLevel;
end;

procedure TFireBurnEvent.Run;
var
  i: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  if (m_nDamage > 0) and (m_Envir <> nil) and (m_Owner <> nil) and (GetTickCount - m_dwTickTime > 3000) then
  begin
    m_dwTickTime := GetTickCount();
    //if (m_Envir <> nil) and (m_Owner <> nil) then begin
    BaseObjectList := TList.Create;
    try
      try
        m_Envir.GeTBaseObjects(m_nX, m_nY, True, BaseObjectList);
        for i := 0 to BaseObjectList.Count - 1 do
        begin
          TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
          if (TargeTBaseObject <> nil) and (m_Owner.IsProperTarget(TargeTBaseObject)) then
          begin
            TargeTBaseObject.SendMsg(m_Owner, RM_MAGSTRUCK_MINE, 0, m_nDamage, 0, 0, '', SKILL_EARTHFIRE);
          end;
        end;
      except
        m_Owner := nil; //0618
      end;
    finally
      BaseObjectList.Free;
    end;
    //end;
  end;
  inherited;
end;

{ TEvent }

constructor TEvent.Create(tEnvir: TEnvirnoment; nTX, nTY, nType, dwETime: Integer; boVisible: Boolean); //004A7B68
begin
  m_dwOpenStartTick := GetTickCount();
  m_nEventType := nType;
  m_nEventParam := 0;
  m_nEventLevel := 0;
  m_dwContinueTime := dwETime;

  if nType = ET_FIRE then
  begin
    if m_dwContinueTime > g_Config.nFireBurnHoldTime then
      m_dwContinueTime := g_Config.nFireBurnHoldTime;
  end;

  m_boVisible := boVisible;
  m_boClosed := False;
  m_Envir := tEnvir;
  m_nX := nTX;
  m_nY := nTY;
  m_boActive := True;
  m_nDamage := 0;
  m_Owner := nil;
  m_dwRunStart := GetTickCount();
  //m_dwRunTick := 500;

  m_boAddToMap := False;
  
  if (m_Envir <> nil) and (m_boVisible) then
    m_boAddToMap := m_Envir.AddToMap(m_nX, m_nY, OS_EVENTOBJECT, self) <> nil
  else
    m_boVisible := False;
end;

destructor TEvent.Destroy;
begin
  m_boClosed := True;
  inherited;
end;

function TEvent.CanClose(): Boolean;
begin
  Result := False;
  if (m_nEventType = ET_FIRE) and g_Config.boFireBurnEventOff then
  begin
    if (m_Owner = nil) or m_Owner.m_boGhost or m_Owner.m_boDeath or (m_Envir = nil) or (m_Envir <> m_Owner.m_PEnvir) then
      Result := True;
  end;
end;

procedure TEvent.Run;
begin
  if not m_boClosed and (GetTickCount - m_dwOpenStartTick > m_dwContinueTime) or CanClose() then
  begin
    //m_Owner := nil;                     //0618    同步
    try
      Close();
    finally
      m_boClosed := True;
    end;
  end;
end;

procedure TEvent.Close;
begin
  m_dwCloseTick := GetTickCount();
  if m_boVisible then
  begin
    m_boVisible := False;
    if m_Envir <> nil then
    begin
      m_Envir.DeleteFromMap(m_nX, m_nY, OS_EVENTOBJECT, self);
      m_Envir := nil;
    end;
  end;
end;

{function TEvent.IsWork(): Boolean;
begin
  Result := True;
  if m_nEventType = ET_FIRE then begin
    if (m_Owner = nil) or m_Owner.m_boGhost or m_Owner.m_boDeath or (m_Envir = nil) then
      Result := False;
  end;
end;}

{ TPileStones }

constructor TPileStones.Create(Envir: TEnvirnoment; nX, nY, nType, nTime: Integer); //0710
begin
  inherited Create(Envir, nX, nY, nType, nTime, True);
  m_nEventParam := 1;
end;

procedure TPileStones.AddEventParam;
begin
  if m_nEventParam < 5 then
    Inc(m_nEventParam);
end;

end.
