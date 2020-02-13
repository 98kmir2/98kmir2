unit HGEActors;

interface
uses
  Windows, SysUtils, Classes, HGE, HGESprite, HGEAnim, Math, HGENURBS, HGEDef;

const
  SListIndexError           = 'Index of the list exceeds the range. (%d)';
type

  {  ESpriteError  }
  ESpriteError = class(Exception);
  {  TSprite  }
  TSpriteEngine = class;

  TSprite = class
  private
    FEngine: TSpriteEngine;
    FParent: TSprite;
    FList: TList;
    FDeaded: Boolean;
    FDrawList: TList;
    FCollisioned: Boolean;
    FMoved: Boolean;
    FVisible: Boolean;
    FX: Double;
    FY: Double;
    FZ: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FAlpha: Byte;

    FPath: TNURBSCurveEx;
    FDistance: Single;                                                          // [0,100]
    FPosition: TPoint2;
    FMoveSpeed: Single;
    FAccel: Single;
    FUpdateSpeed: Single;
    FMaxParameter: Integer;
    FLoopMode: Integer;                                                         //0-无，1-重新从起点开始，2-反向运动
    procedure Add(Sprite: TSprite);
    procedure Remove(Sprite: TSprite);
    procedure AddDrawList(Sprite: TSprite);
    procedure Collision2;
    procedure Draw(nSign: integer);
    function GetClientRect: TRect;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSprite;
    function GetWorldX: Double;
    function GetWorldY: Double;
    procedure SetZ(Value: Integer);
    procedure SetAlpha(const Value: Byte);
    function GetPosition: TPoint2;
    procedure SetDistance(const Value: Single);
  protected
    FHGE: IHGE;
    procedure DoCollision(Sprite: TSprite; var Done: Boolean); virtual;
    procedure DoDraw; virtual;
    procedure DoMove; virtual;
    function NurbsMove: Boolean; virtual;
    function GetBoundsRect: TRect; virtual;
    function TestCollision(Sprite: TSprite): Boolean; virtual;
  public
    Tag: Integer;
    constructor Create(AParent: TSprite); virtual;
    destructor Destroy; override;
    procedure Clear;
    function Collision: Integer;
    function IsInArea(AX, AY: Integer): Boolean; dynamic;
    procedure Dead;
    procedure Move;
    procedure LoadFromIni(Sec, Key: string); virtual;
    function GetSpriteAt(X, Y: Integer): TSprite;
    function LoadPath(sFileName: string): Boolean;
    property BoundsRect: TRect read GetBoundsRect;
    property ClientRect: TRect read GetClientRect;
    property Collisioned: Boolean read FCollisioned write FCollisioned;
    property Count: Integer read GetCount;
    property Engine: TSpriteEngine read FEngine;
    property Items[Index: Integer]: TSprite read GetItem; default;
    property Moved: Boolean read FMoved write FMoved;
    property Parent: TSprite read FParent;
    property Visible: Boolean read FVisible write FVisible;
    property Width: Integer read FWidth write FWidth;
    property WorldX: Double read GetWorldX;
    property WorldY: Double read GetWorldY;
    property Height: Integer read FHeight write FHeight;
    property X: Double read FX write FX;
    property Y: Double read FY write FY;
    property Z: Integer read FZ write SetZ;
    property Alpha: Byte read FAlpha write SetAlpha;
    property Path: TNURBSCurveEx read FPath write FPath;
    property Distance: Single read FDistance write SetDistance;
    property Position: TPoint2 read GetPosition;
    property MoveSpeed: Single read FMoveSpeed write FMoveSpeed;
    property Accel: Single read FAccel write FAccel;
    property UpdateSpeed: Single read FUpdateSpeed write FUpdateSpeed;
    property MaxParameter: Integer read FMaxParameter write FMaxParameter;
    property LoopMode: integer read FLoopMode write FLoopMode;
    property Deaded: Boolean read FDeaded;
  end;

  {  TImageSprite  }

  TImageSprite = class(TSprite)
  private
    FImage: IHGEAnimation;
    FAnimStart: Integer;
    FAnimPos: integer;
    FAnimSpeed: Double;
    FAnimMode: Integer;
    FAnimCount: Integer;
    FRot: Single;
    FHScale: Single;
    FVScale: Single;
    procedure SetImage(Img: string);
    procedure SetAnimMode(const Value: Integer);
    procedure SetAnimCount(const Value: Integer);
    procedure SetAnimPos(const Value: integer);
    procedure SetAnimSpeed(const Value: Double);
    procedure SetAnimStart(const Value: Integer);
    procedure SetBlendMode(const Value: Integer);
  protected
    procedure DoDraw; override;
    procedure DoMove; override;
    function GetBoundsRect: TRect; override;
    function TestCollision(Sprite: TSprite): Boolean; override;
  public
    FHGE: IHGE;
    function GetDrawImageIndex: Integer;
    function GetDrawRect: TRect;
    procedure SetTexture(ATex: ITexture);
    constructor Create(AParent: TSprite); override;
    destructor Destroy; override;
    property AnimCount: Integer read FAnimCount write SetAnimCount;
    property AnimMode: Integer read FAnimMode write SetAnimMode;
    property AnimPos: integer read FAnimPos write SetAnimPos;
    property AnimSpeed: Double read FAnimSpeed write SetAnimSpeed;
    property AnimStart: Integer read FAnimStart write SetAnimStart;
    property Image: string write SetImage;
    property Anim: IHGEAnimation read FImage;
    property Rot: Single read FRot write FRot;
    property HScale: Single read FHScale write FHScale;
    property VScale: Single read FVScale write FVScale;
    property BlendMode: Integer write SetBlendMode;
  end;

  {  TImageSpriteEx  }

  TImageSpriteEx = class(TImageSprite)
  private
    FAngle: Integer;
    FAlpha: Integer;
  protected
    procedure DoDraw; override;
    function GetBoundsRect: TRect; override;
    function TestCollision(Sprite: TSprite): Boolean; override;
  public
    constructor Create(AParent: TSprite); override;
    property Angle: Integer read FAngle write FAngle;
    property Alpha: Integer read FAlpha write FAlpha;
  end;

  {  TSpriteEngine  }

  TSpriteEngine = class(TSprite)
  private
    FAllCount: Integer;
    FCollisionCount: Integer;
    FCollisionDone: Boolean;
    FCollisionRect: TRect;
    FCollisionSprite: TSprite;
    FDeadList: TList;
    FDrawCount: Integer;
    FSurfaceRect: TRect;
  public
    constructor Create(AParent: TSprite); override;
    destructor Destroy; override;
    procedure Dead;
    procedure Draw(nSign: Integer);
    property AllCount: Integer read FAllCount;
    property DrawCount: Integer read FDrawCount;
    property SurfaceRect: TRect read FSurfaceRect;
  end;

  {  EDXSpriteEngineError  }

  EDXSpriteEngineError = class(Exception);

  {  TCustomDXSpriteEngine  }

  TCustomDXSpriteEngine = class(TComponent)
  private
    FEngine: TSpriteEngine;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;
    procedure Dead;
    procedure Draw(nSign: Integer);
    procedure Move(MoveCount: Integer);
    property Engine: TSpriteEngine read FEngine;
  end;

  {  TDXSpriteEngine  }

  TDXSpriteEngine = class(TCustomDXSpriteEngine)
  published
  end;

  { TPolygon }
  TPolygon = class
  private
    HGE:IHGE;
    FPoints: array[0..6] of TPoint;
    FNumPoints: Byte;
    FPosition: Byte;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FColor: DWORD;
  protected
    procedure SetPosition(Position: Byte);
  public
    constructor Create;
    destructor Destroy; override;
    function Render(X, Y: Integer): Boolean;
  published
    property Left: Integer read FLeft write FLeft;
    property Top: Integer read FTop write FTop;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property Position: Byte read FPosition write SetPosition;
    property NumPoints: Byte read FNumPoints;
    property Color: DWORD read FColor write FColor;
  end;

implementation

function Mod2(i, i2: Integer): Integer;
begin
  Result := i mod i2;
  if Result < 0 then
    Result := i2 + Result;
end;

function Mod2f(i: Double; i2: Integer): Double;
begin
  if i2 = 0 then
    Result := i
  else
  begin
    Result := i - Trunc(i / i2) * i2;
    if Result < 0 then
      Result := i2 + Result;
  end;
end;

function PointInRect(const Point: TPoint; const Rect: TRect): Boolean;
begin
  Result := (Point.X >= Rect.Left) and
    (Point.X <= Rect.Right) and
    (Point.Y >= Rect.Top) and
    (Point.Y <= Rect.Bottom);
end;

function RectInRect(const Rect1, Rect2: TRect): Boolean;
begin
  Result := (Rect1.Left >= Rect2.Left) and
    (Rect1.Right <= Rect2.Right) and
    (Rect1.Top >= Rect2.Top) and
    (Rect1.Bottom <= Rect2.Bottom);
end;

function OverlapRect(const Rect1, Rect2: TRect): Boolean;
begin
  Result := (Rect1.Left < Rect2.Right) and
    (Rect1.Right > Rect2.Left) and
    (Rect1.Top < Rect2.Bottom) and
    (Rect1.Bottom > Rect2.Top);
end;

function WideRect(ALeft, ATop, AWidth, AHeight: Integer): TRect;
begin
  with Result do begin
    Left := ALeft;
    Top := ATop;
    Right := ALeft + AWidth;
    Bottom := ATop + AHeight;
  end;
end;

{  TSprite  }

constructor TSprite.Create(AParent: TSprite);
begin
  inherited Create;
  Tag := 0;
  FHGE := HGECreate(HGE_VERSION);
  FAlpha := 255;
  FParent := AParent;
  if FParent <> nil then begin
    FParent.Add(Self);
    if FParent is TSpriteEngine then
      FEngine := TSpriteEngine(FParent)
    else
      FEngine := FParent.Engine;
    Inc(FEngine.FAllCount);
  end;
  FZ := 1;
  FCollisioned := True;
  FMoved := True;
  FVisible := True;
  FPath := nil;
  FDistance := 0;
  FMoveSpeed := 30;
  FAccel := 0;
  FUpdateSpeed := 0.01;
  FMaxParameter := 100;
  FLoopMode := 0;
end;

destructor TSprite.Destroy;
begin
  Clear;
  if FParent <> nil then begin
    Dec(FEngine.FAllCount);
    FParent.Remove(Self);
    FEngine.FDeadList.Remove(Self);
  end;
  FList.Free;
  FDrawList.Free;
  if FPath <> nil then FreeAndNil(FPath);
  inherited Destroy;
end;

procedure TSprite.Add(Sprite: TSprite);
begin
  if FList = nil then begin
    FList := TList.Create;
    FDrawList := TList.Create;
  end;
  FList.Add(Sprite);
  AddDrawList(Sprite);
end;

procedure TSprite.Remove(Sprite: TSprite);
begin
  FList.Remove(Sprite);
  FDrawList.Remove(Sprite);
  if FList.Count = 0 then begin
    FList.Free;
    FList := nil;
    FDrawList.Free;
    FDrawList := nil;
  end;
end;

procedure TSprite.AddDrawList(Sprite: TSprite);
var
  L, H, I, C                : Integer;
begin
  L := 0;
  H := FDrawList.Count - 1;
  while L <= H do begin
    I := (L + H) div 2;
    C := TSprite(FDrawList[I]).Z - Sprite.Z;
    if C < 0 then L := I + 1 else
      H := I - 1;
  end;
  FDrawList.Insert(L, Sprite);
end;

procedure TSprite.Clear;
begin
  while Count > 0 do
    Items[Count - 1].Free;
end;

function TSprite.Collision: Integer;
var
  i                         : Integer;
begin
  Result := 0;
  if (FEngine <> nil) and (not FDeaded) and (Collisioned) then begin
    with FEngine do
    begin
      FCollisionCount := 0;
      FCollisionDone := False;
      FCollisionRect := Self.BoundsRect;
      FCollisionSprite := Self;

      for i := 0 to Count - 1 do
        Items[i].Collision2;

      Result := FCollisionCount;
    end;
  end;
end;

procedure TSprite.Collision2;
var
  i                         : Integer;
begin
  if Collisioned then begin
    if (Self <> FEngine.FCollisionSprite) and OverlapRect(BoundsRect, FEngine.FCollisionRect) and
      FEngine.FCollisionSprite.TestCollision(Self) and TestCollision(FEngine.FCollisionSprite) then
    begin
      Inc(FEngine.FCollisionCount);
      FEngine.FCollisionSprite.DoCollision(Self, FEngine.FCollisionDone);
      if (not FEngine.FCollisionSprite.Collisioned) or (FEngine.FCollisionSprite.FDeaded) then
      begin
        FEngine.FCollisionDone := True;
      end;
    end;
    if FEngine.FCollisionDone then Exit;
    for i := 0 to Count - 1 do
      Items[i].Collision2;
  end;
end;

procedure TSprite.Dead;
begin
  if (FEngine <> nil) and (not FDeaded) then
  begin
    FDeaded := True;
    FEngine.FDeadList.Add(Self);
    FEngine.FDrawList.Remove(Self);
  end;
end;

function TSprite.GetPosition: TPoint2;
begin
  if (FPath = nil) or (FPath.CPCount <= 0) then begin
    Result.X := X;
    Result.Y := Y;
  end else
    Result := FPath.GetXY(Distance / FMaxParameter);
end;

procedure TSprite.SetDistance(const Value: Single);
begin
  FDistance := Value;
end;

function TSprite.NurbsMove: Boolean;
var
  Point                     : TPoint2;
begin
  Result := False;
  if (FPath = nil) or (FPath.CPCount = 0) then Exit;
  FDistance := FDistance + FMoveSpeed * FUpdateSpeed;
  FMoveSpeed := FMoveSpeed + FAccel * FUpdateSpeed;
  if FDistance > FMaxParameter then FDistance := FMaxParameter;
  if FDistance < 0 then FDistance := 0;
  Point := GetPosition;
  X := Point.X;
  Y := Point.Y;
  if (FDistance >= FMaxParameter) or (FDistance <= 0) then begin
    case FLoopMode of
      0: ;
      1: FDistance := 0;
      2: FUpdateSpeed := -FUpdateSpeed;
    end;
    Result := True;
  end;
end;

procedure TSprite.DoMove;
begin
  NurbsMove;
end;

procedure TSprite.DoDraw;
begin
end;

procedure TSprite.DoCollision(Sprite: TSprite; var Done: Boolean);
begin
end;

function TSprite.TestCollision(Sprite: TSprite): Boolean;
begin
  Result := True;
end;

procedure TSprite.Move;
var
  i                         : Integer;
begin
  if FMoved then
  begin
    DoMove;
    for i := 0 to Count - 1 do
      Items[i].Move;
  end;
end;

procedure TSprite.Draw;
var
  i                         : Integer;
  R1, R2                    : TRect;
begin
  if FVisible then begin
    if FEngine <> nil then
      R1 := FEngine.FSurfaceRect
    else
      R1 := Bounds(0, 0, 800, 600);
    R2 := BoundsRect;
    if (R2.Left < R1.Right) or (R2.Right > R1.Left) or (R2.Top < R1.Bottom) or (R2.Bottom > R1.Top) then begin
      if (Sign(FZ) = nSign) or ((nSign = 1) and (FZ >= 0)) then DoDraw;
      if FEngine <> nil then Inc(FEngine.FDrawCount);
    end;
    try
      if FDrawList <> nil then
      begin
        for i := 0 to FDrawList.Count - 1 do
          TSprite(FDrawList[i]).Draw(nSign);
      end;
    except
    end;
  end;
end;

function TSprite.GetSpriteAt(X, Y: Integer): TSprite;

  procedure Collision_GetSpriteAt(X, Y: Double; Sprite: TSprite);
  var
    i                       : Integer;
    X2, Y2                  : Double;
  begin
    if Sprite.Visible and PointInRect(Point(Round(X), Round(Y))
      , Bounds(Round(Sprite.X), Round(Sprite.Y), Sprite.Width, Sprite.Height)) then
    begin
      if IsInArea(Round(X), Round(Y)) and ((Result = nil) or (Sprite.Z > Result.Z)) then
        Result := Sprite;
    end;

    X2 := X - Sprite.X;
    Y2 := Y - Sprite.Y;
    for i := 0 to Sprite.Count - 1 do
      Collision_GetSpriteAt(X2, Y2, Sprite.Items[i]);
  end;

var
  i                         : Integer;
  X2, Y2                    : Double;
begin
  Result := nil;

  X2 := X - Self.X;
  Y2 := Y - Self.Y;
  for i := 0 to Count - 1 do
    Collision_GetSpriteAt(X2, Y2, Items[i]);
end;

function TSprite.GetBoundsRect: TRect;
begin
  Result := Bounds(Trunc(WorldX), Trunc(WorldY), Width, Height);
end;

function TSprite.GetClientRect: TRect;
begin
  Result := Bounds(0, 0, Width, Height);
end;

function TSprite.GetCount: Integer;
begin
  if FList <> nil then
    Result := FList.Count
  else
    Result := 0;
end;

function TSprite.GetItem(Index: Integer): TSprite;
begin
  if FList <> nil then
    Result := FList[Index]
  else
    raise ESpriteError.CreateFmt(SListIndexError, [Index]);
end;

function TSprite.GetWorldX: Double;
begin
  if Parent <> nil then
    Result := Parent.WorldX + FX
  else
    Result := FX;
end;

function TSprite.GetWorldY: Double;
begin
  if Parent <> nil then
    Result := Parent.WorldY + FY
  else
    Result := FY;
end;

function TSprite.IsInArea(AX, AY: Integer): Boolean;
begin
  Result := True;
end;

procedure TSprite.LoadFromIni(Sec, Key: string);
begin
  X := FHGE.Ini_GetFloat(Sec, Key + '_Left', X);
  Y := FHGE.Ini_GetFloat(Sec, Key + '_Top', Y);
  Z := FHGE.Ini_GetInt(Sec, Key + '_Z', Z);
  Width := FHGE.Ini_GetInt(Sec, Key + '_Width', Width);
  Height := FHGE.Ini_GetInt(Sec, Key + '_Height', Height);
  LoadPath(FHGE.Ini_GetString(Sec, Key + '_Path', ''));
  if FPath <> nil then begin
    FMoveSpeed := FHGE.Ini_GetFloat(Sec, Key + '_Speed', FMoveSpeed);
    FLoopMode := FHGE.Ini_GetInt(Sec, Key + '_LoopMode', FLoopMode);
    FAccel := FHGE.Ini_GetFloat(Sec, Key + 'Accel', FAccel);
  end;
end;

function TSprite.LoadPath(sFileName: string): Boolean;
begin
  if FPath <> nil then begin
    FPath.Free;
    FPath := nil;
  end;
  FPath := TNURBSCurveEx.Create;
  if not FPath.LoadCurve(sFileName) then FreeAndNil(FPath);
end;

procedure TSprite.SetAlpha(const Value: Byte);
var
  i                         : integer;
begin
  FAlpha := Value;
  if FDrawList <> nil then
  begin
    for i := 0 to FDrawList.Count - 1 do
      TSprite(FDrawList[i]).Alpha := Value;
  end;
end;

procedure TSprite.SetZ(Value: Integer);
begin
  try
    if FZ <> Value then begin
      FZ := Value;
      if Parent <> nil then begin
        Parent.FDrawList.Remove(Self);
        Parent.AddDrawList(Self);
      end;
    end;
  except
  end;
end;

{  TImageSprite  }

constructor TImageSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  FHGE := HGECreate(HGE_VERSION);
  FAnimStart := 0;
  FAnimPos := 0;
  FAnimSpeed := 10;
  FAnimMode := 0;
  FAnimCount := 1;
  FRot := 0.0;
  FHScale := 1.0;
  FVScale := 1.0;
end;

procedure TImageSprite.SetAnimCount(const Value: Integer);
begin
  FAnimCount := Value;
  if FImage <> nil then FImage.SetFrames(Value);
end;

procedure TImageSprite.SetAnimMode(const Value: Integer);
begin
  FAnimMode := Value;
  if FImage <> nil then FImage.SetMode(Value);
end;

procedure TImageSprite.SetAnimPos(const Value: integer);
begin
  FAnimPos := Value;
  if FImage <> nil then FImage.SetFrame(Value);
end;

procedure TImageSprite.SetAnimSpeed(const Value: Double);
begin
  FAnimSpeed := Value;
  if FImage <> nil then FImage.SetSpeed(Value);
end;

procedure TImageSprite.SetAnimStart(const Value: Integer);
begin
  FAnimStart := Value;
  if FImage <> nil then FImage.SetFrame(Value);
end;

procedure TImageSprite.SetBlendMode(const Value: Integer);
begin
  if FImage <> nil then
    FImage.SetBlendMode(Value);
end;

procedure TImageSprite.SetImage(Img: string);
var
  Tex                       : ITexture;
begin
  FImage := nil;
  Tex := FHGE.Texture_Load(Img);
  SetTexture(Tex);
end;

procedure TImageSprite.SetTexture(ATex: ITexture);
begin
  if ATex <> nil then begin
    if Width = 0 then Width := ATex.GetWidth(True) div FAnimCount;
    if Height = 0 then height := Atex.GetHeight(True);
    FImage := THGEAnimation.Create(ATex, FAnimCount, FAnimSpeed, 0, 0, Width, Height);
    if FImage <> nil then FImage.Play;
  end else
    FImage := nil;
end;

function TImageSprite.GetBoundsRect: TRect;
var
  dx, dy                    : Integer;
begin
  dx := Trunc(WorldX);
  dy := Trunc(WorldY);
  Result := Bounds(dx, dy, Width, Height);
end;

procedure TImageSprite.DoMove;
begin
  if FImage <> nil then
    FImage.Update(FHGE.Timer_GetDelta);
end;

function TImageSprite.GetDrawImageIndex: Integer;
begin
  if FImage = nil then result := 0
  else
    Result := FImage.GetFrame;
end;

function TImageSprite.GetDrawRect: TRect;
begin
  Result := BoundsRect;
  OffsetRect(Result, (Width - round(FImage.GetWidth)) div 2, (Height - Round(FImage.GetHeight)) div 2);
end;

destructor TImageSprite.destroy;
begin
  FHGE := nil;
  if FImage <> nil then FImage := nil;
  inherited;
end;

procedure TImageSprite.DoDraw;
var
  r                         : TRect;
begin
  if FImage <> nil then begin
    r := GetDrawRect;
    FImage.renderEx(r.Left, r.Top, FRot, FHScale, FVScale);
  end;
end;

function TImageSprite.TestCollision(Sprite: TSprite): Boolean;
begin
  Result := False;
end;

{  TImageSpriteEx  }

constructor TImageSpriteEx.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  FAlpha := 255;
end;

procedure TImageSpriteEx.DoDraw;
var
  r                         : TRect;
begin
  r := Bounds(Trunc(WorldX), Trunc(WorldY), Width, Height);

  if FAngle and $FF = 0 then
  begin
    inherited;
  end else
  begin
    inherited;
  end;
end;

function TImageSpriteEx.GetBoundsRect: TRect;
begin
  Result := FEngine.SurfaceRect;
end;

function TImageSpriteEx.TestCollision(Sprite: TSprite): Boolean;
begin
  if Sprite is TImageSpriteEx then
  begin
    Result := OverlapRect(Bounds(Trunc(Sprite.WorldX), Trunc(Sprite.WorldY), Sprite.Width, Sprite.Height),
      Bounds(Trunc(WorldX), Trunc(WorldY), Width, Height));
  end else
  begin
    Result := OverlapRect(Sprite.BoundsRect, Bounds(Trunc(WorldX), Trunc(WorldY), Width, Height));
  end;
end;

{  TSpriteEngine  }

constructor TSpriteEngine.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  FDeadList := TList.Create;
end;

destructor TSpriteEngine.Destroy;
begin
  FDeadList.Free;
  inherited Destroy;
end;

procedure TSpriteEngine.Dead;
begin
  while FDeadList.Count > 0 do
    TSprite(FDeadList[FDeadList.Count - 1]).Free;
  FDeadList.Clear;
end;

procedure TSpriteEngine.Draw;
begin
  FDrawCount := 0;
  inherited Draw(nSign);
end;

{  TCustomDXSpriteEngine  }

constructor TCustomDXSpriteEngine.Create(AOnwer: TComponent);
begin
  inherited Create(AOnwer);
  FEngine := TSpriteEngine.Create(nil);
end;

destructor TCustomDXSpriteEngine.Destroy;
begin
  FEngine.Free;
  inherited Destroy;
end;

procedure TCustomDXSpriteEngine.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

procedure TCustomDXSpriteEngine.Dead;
begin
  FEngine.Dead;
end;

procedure TCustomDXSpriteEngine.Draw;
begin
  FEngine.Draw(nSign);
end;

procedure TCustomDXSpriteEngine.Move(MoveCount: Integer);
begin
  FEngine.Move;
end;

{ TPolygon }

constructor TPolygon.Create;
begin
  inherited Create;
  HGE := HGECReate(HGE_VERSION);
  FLeft := 0;
  FTop := 0;
  FWidth := 24;
  FHeight := 24;
  FNumPoints := 0;
  FPosition := 0;
  FColor := $B3479FB2;
end;

destructor TPolygon.Destroy;
begin
  inherited;
  HGE := nil;
end;

function TPolygon.Render(X, Y: Integer): Boolean;
var
  i : Integer;
begin
  if FNumPoints > 0 then begin
    for I := 0 to 6 do begin
      Inc(FPoints[i].X, X);
      Inc(FPoints[i].Y, Y);
    end;
    HGE.Polygon(FPoints, FNumPoints, FColor, True);
  end;
end;

procedure TPolygon.SetPosition(Position: Byte);
var
  RW                        : Integer;
  RH                        : Integer;
begin
  FPosition := Position;
  if FPosition >= 100 then begin
    FNumPoints := 0;
    Exit;
  end;
  RW := FWidth div 2;
  RH := FHeight div 2;
  case FPosition of
    0..12: begin
        FNumPoints := 7;
        FPoints[0].X := FLeft + RW;
        FPoints[0].Y := FTop + RH;
        FPoints[1].X := FPoints[0].X + Round(RW * (0.084 * FPosition));
        FPoints[1].Y := FTop;
        FPoints[2].X := FLeft + FWidth;
        FPoints[2].Y := FTop;
        FPoints[3].X := FLeft + FWidth;
        FPoints[3].Y := FTop + FHeight;
        FPoints[4].X := FLeft;
        FPoints[4].Y := FTop + FHeight;
        FPoints[5].X := FLeft;
        FPoints[5].Y := FTop;
        FPoints[6].X := FLeft + RW;
        FPoints[6].Y := FTop;
      end;
    13..37: begin
        FNumPoints := 6;
        FPoints[0].X := FLeft + RW;
        FPoints[0].Y := FTop + RH;
        FPoints[1].X := FLeft + FWidth;
        FPoints[1].Y := FTop + Round(FHeight * (0.042 * (FPosition - 13)));
        FPoints[2].X := FLeft + FWidth;
        FPoints[2].Y := FTop + FHeight;
        FPoints[3].X := FLeft;
        FPoints[3].Y := FTop + FHeight;
        FPoints[4].X := FLeft;
        FPoints[4].Y := FTop;
        FPoints[5].X := FLeft + RW;
        FPoints[5].Y := FTop;
      end;
    38..62: begin
        FNumPoints := 5;
        FPoints[0].X := FLeft + RW;
        FPoints[0].Y := FTop + RH;
        FPoints[1].X := FLeft + FWidth - Round(FWidth * (0.042 * (FPosition - 38)));
        FPoints[1].Y := FTop + FHeight;
        FPoints[2].X := FLeft;
        FPoints[2].Y := FTop + FHeight;
        FPoints[3].X := FLeft;
        FPoints[3].Y := FTop;
        FPoints[4].X := FLeft + RW;
        FPoints[4].Y := FTop;
      end;
    63..87: begin
        FNumPoints := 4;
        FPoints[0].X := FLeft + RW;
        FPoints[0].Y := FTop + RH;
        FPoints[1].X := FLeft;
        FPoints[1].Y := FTop + FHeight - Round(FHeight * (0.042 * (FPosition - 63)));
        FPoints[2].X := FLeft;
        FPoints[2].Y := FTop;
        FPoints[3].X := FLeft + RW;
        FPoints[3].Y := FTop;
      end;
    88..99: begin
        FNumPoints := 3;
        FPoints[0].X := FLeft + RW;
        FPoints[0].Y := FTop + RH;
        FPoints[1].X := FLeft + Round(RW * (0.091 * (FPosition - 88)));
        FPoints[1].Y := FTop;
        FPoints[2].X := FLeft + RW;
        FPoints[2].Y := FTop;
      end;
  end;
end;

end.

