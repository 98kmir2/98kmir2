unit ObjGuard;

interface
uses
  Windows, Classes, Grobal2, ObjNpc;

type
  TSuperGuard = class(TNormNpc)
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
  end;

implementation

uses ObjBase, M2Share;

{ TSuperGuard }

function TSuperGuard.AttackTarget(): Boolean; //004977B4
var
  nOldX, nOldY: Integer;
  btOldDir: byte;
  wHitMode: Word;
  Buffer: array[0..255] of Byte;
begin
  Result := False;
  if m_TargetCret.m_PEnvir = m_PEnvir then
  begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
    begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();

      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      m_btDirection := m_btDirection mod 8;
      btOldDir := m_btDirection;
      try
        m_TargetCret.GetBackPosition(m_nCurrX, m_nCurrY);
        m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
        wHitMode := 0;
        _Attack(wHitMode, m_TargetCret);
        m_TargetCret.SetLastHiter(self);
        m_TargetCret.m_ExpHitter := nil;
      finally
        m_nCurrX := nOldX;
        m_nCurrY := nOldY;
        m_btDirection := btOldDir;
        SendRefMsg(RM_TURN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
      end;
      BreakHolySeizeMode();
    end;
    Result := True;
  end
  else
  begin
    DelTargetCreat();
  end;

end;

constructor TSuperGuard.Create; //004976B0
begin
  inherited;
  m_btRaceServer := RC_GUARD;
  m_nViewRangeX := 7;
  m_nViewRangeY := m_nViewRangeX;
  m_nLight := 4;
end;

destructor TSuperGuard.Destroy; //00497718
begin
  inherited;
end;

function TSuperGuard.Operate(ProcessMsg: pTProcessMessage): Boolean; //0049774C
begin
  {if (ProcessMsg.wIdent = RM_STRUCK) or (ProcessMsg.wIdent = RM_MAGSTRUCK) or (ProcessMsg.wIdent = RM_MAGSTRUCK) then begin
    if (ProcessMsg.BaseObject = self) and (TBaseObject(ProcessMsg.nParam3) <> nil) then begin
      SetLastHiter(TBaseObject(ProcessMsg.nParam3));
      //Struck(TBaseObject(ProcessMsg.nParam3));
      //BreakHolySeizeMode();
    end;
    Result := True;
  end else}
  Result := inherited Operate(ProcessMsg);
end;

procedure TSuperGuard.Run; //00497924
var
  i: Integer;
  BaseObject: TBaseObject;
begin
  if m_Master <> nil then
    m_Master := nil; //²»ÔÊÐíÕÙ»½Îª±¦±¦
  if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
  begin
    for i := 0 to m_VisibleActors.Count - 1 do
    begin
      BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
      if BaseObject.m_boDeath then
        Continue;
      if (BaseObject.PKLevel >= 2) or ((BaseObject.m_btRaceServer >= RC_MONSTER) and (not BaseObject.m_boMission)) then
      begin
        SetTargetCreat(BaseObject);
        Break;
      end;
    end;
  end;
  if m_TargetCret <> nil then
    AttackTarget();
  inherited;
end;

end.
