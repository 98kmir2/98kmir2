unit AnimSprite;

interface

uses
  Windows, Classes, SysUtils, HGE, HGESprite, PngImage, Graphics, HGEParticle, HGEActors, Math;

const
  CURRENTLY_FRAME           = 0;
  CCARTOON_FRAME            = 1;
  LS_Record_Version         = 1;
  LS_SDesc                  = 'LSAnim';

type
  TRGBQuadEx = packed record
function GetARGB(): dword;
procedure SetAScale(Value: Single);
procedure SetCScale(Value: Single);
procedure SetARGB(Value: dword);
case byte of
  0: (dwColor: dword);
  1: (R: byte;
    G: byte;
    B: byte;
    A: byte);
  end;

  TLSHeader = packed record
    Version: Word;
    SDesc: array[0..127] of Char;
    BackgroundColor: TRGBQuadEx;
    FPS: byte;
    W: Word;
    H: Word;
    AxesCount: Word;
    FilesCount: Word;
    ControlCount: Word;
    BoResult: Boolean;
  end;

  TControlInfo = packed record
    wB: Word;
    wE: Word;
  end;
  PControlInfo = ^TControlInfo;

  TCustomType = packed record
    case byte of
      0: (D: Double);
      1: (X: Integer;
        Y: Integer);
  end;

  TTextureInfo = packed record
    btType: byte;
    nIndex: Word;
    X: Integer;
    Y: Integer;
    T: Word;
    L: Word;
    W: Word;
    H: Word;
    Rot: TCustomType;
    HScale: TCustomType;
    VScale: TCustomType;
  end;
  PTextureInfo = ^TTextureInfo;

  TFrame_Currently_Info = packed record
    btType: byte;
    PLACE: Word;
    Color: TRGBQuadEx;
    BLEND: byte;
    BX: Integer;
    BY: Integer;
    BRot: Double;
    BHScale: Double;
    BVScale: Double;
    BAlpha: byte;
    Count: Word;
  end;

  TFrame_Ccartoon_Info = packed record
    btType: byte;
    PLACE: Word;
    Color: TRGBQuadEx;
    BLEND: byte;
    BX: Integer;
    BY: Integer;
    BRot: Double;
    BHScale: Double;
    BVScale: Double;
    BAlpha: byte;
    EX: Integer;
    EY: Integer;
    ERot: Double;
    EHScale: Double;
    EVScale: Double;
    EAlpha: byte;
    Count: Word;
  end;

  TLSAnimSprite = class;
  TLSAnimPlayer = class;

  TLSAnimSprite = class(TSprite)
  private
    FLSAnimPlayer: TLSAnimPlayer;
    FStartTick: dword;
    FTimes: Integer;                    //播放时间
    FBout: Word;                        //播放次数
    FFileName: string;                  //当前文件
    FLight: byte;
    FAlpha: byte;
    procedure SetFileName(const Value: string);
    function GetRenderIndex(): Integer;
    procedure SetLight(Value: byte);
    procedure SetAlpha(Value: byte);
  public
    constructor Create(AParent: TSprite); override;
    destructor Destroy; override;
    procedure DoMove; override;
    procedure DoDraw; override;
    procedure Play(Bindex: Integer = -1; boFrame: Boolean = False);
    procedure Pause();
    procedure LoadFromIni(Sec, Key: string); override;
    function GetFirstFrame: ITexture;
  published
    property FileName: string read FFileName write SetFileName;
    property RenderIndex: Integer read GetRenderIndex;
    property Times: Integer read FTimes write FTimes;
    property Bout: Word read FBout write FBout;
    property Light: byte read FLight write SetLight;
    property Alpha: byte read FAlpha write SetAlpha;
  end;

  TGList = class(TList)
  private
    RTL: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

  TLSAnimPlayer = class
  private
    FParent: TObject;
    FHGE: IHGE;
    FStartTick: dword;
    FIsPlay: Boolean;
    FFileName: string;                  //当前文件
    FTierList: TGList;                  //图层列表
    FFilesList: TList;                  //资源列表
    FRenderIndex: Integer;              //当前播放的帧
    FMaxIndex: Word;
    FDTime: dword;
    FUseBout: dword;                    //播放次数
    FSprite: IHGESprite;
    FHScale: Double;
    FVScale: Double;
    FControlCount: Word;
    FResultContro: PControlInfo;
    FboResult: Boolean;
    FControIndex: Integer;
    FControlList: array of TControlInfo;
    FCurrentlyControl: PControlInfo;
    FboFrame: Boolean;
    FLoadHit: Boolean;
    FLight: Single;
    FAlpha: Single;
    procedure SetFileName(const Value: string);
    function ClearTierList: Boolean;
  protected
    function GetX(): Integer;
    function GetY(): Integer;
    function GetWidth(): Integer;
    function GetHeight(): Integer;
    procedure SetLight(Value: byte);
    procedure SetAlpha(Value: byte);
  public
    constructor Create(AParent: TObject);
    destructor Destroy; override;
    procedure DoMove;
    procedure DoDraw;
    procedure LoadFromBuffer(Buf: PChar; nSize: Integer);
    procedure LoadStream(Stream: TStream);
    procedure Play(Bindex: Integer = -1; boFrame: Boolean = False);
    procedure Pause();
    function GetLoadHit(): Boolean;
  published
    property FileName: string read FFileName write SetFileName;
    property RenderIndex: Integer read FRenderIndex;
    property X: Integer read GetX;
    property Y: Integer read GetY;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property Light: byte write SetLight;
    property Alpha: byte write SetAlpha;
  end;

type
  TTexPos = record
    X0, Y0, X1, Y1, X2, Y2, X3, Y3: Single;
  end;
  PTexPos = ^TTexPos;

  IHGESpriteEx = interface(IHGESprite)
    ['{BA602E7E-9E71-4093-B954-6A6EED7A9842}']
    procedure SetDistortion(const X, Y, Rot, HScale, VScale: Single; boInit: Boolean);
    procedure DoDraw(const X, Y: Single);
  end;

  { THGESpriteEx }

  THGESpriteEx = class(THGESprite, IHGESpriteEx)
  private
    FTexPos: TTexPos;
  protected
    procedure SetDistortion(const X, Y, Rot, HScale, VScale: Single; boInit: Boolean);
    procedure DoDraw(const X, Y: Single);
  public
  published
  end;

  //procedure Register;

implementation
uses
  HGEWinCtrl;

//procedure Register;
//begin
//  RegisterComponents('HGE',[THGELSAnimPlayer]);
//end;

type
  TFilesType = class(TObject)
  private
    FTexture: ITexture;
    FHGE: IHGE;
    FLoad: Boolean;
    FSize: Longword;
    FHandle: Pointer;
  protected
    function GetTexture(): ITexture;
  public
    constructor Create(Stream: TStream); overload;
    constructor Create(Buf: PChar; var nSize: Integer); overload;
    destructor Destroy; override;
  published
    property Texture: ITexture read GetTexture;
  end;

  TLSAnim = class
  private
    FParent: TLSAnimPlayer;
    FList: TList;                       //资源列表
    FParticleList: TList;               //粒子列表
    FRenderIndex: Integer;
    FBeginIndex: Integer;               //开始播放的帧
    FEndIndex: Integer;                 //播放到第几帧
    FBoDraw: Boolean;
    FBoParticDraw: Boolean;
    FColor: TRGBQuadEx;
    FCount: Integer;
    FHGE: IHGE;
    procedure AddTexture(pInfo: PTextureInfo); virtual;
    procedure ClearList(); virtual;
    procedure LoadStream(Stream: TStream); virtual;
    procedure LoadBuffer(Buf: PChar; var nSize: Integer); virtual;
    procedure ReinventParticle(); virtual;
  protected
    procedure DoMove(RenderIndex: Integer); virtual;
    procedure DoDraw; virtual;
  public
    constructor Create(AParent: TLSAnimPlayer); virtual;
    destructor Destroy; override;
  end;

  TTexture_Info = record
    btType: byte;
    Sprite: IInterface;
  end;
  PTexture_Info = ^TTexture_Info;

  TTexture_Currently_Info = record
    btType: byte;
    Sprite: IInterface;
    Pos: TTexPos;
  end;
  PTexture_Currently_Info = ^TTexture_Currently_Info;

  TLSAnim_Currently_Frame = class(TLSAnim)
  private
    FX: Double;
    FY: Double;
    FRot: Double;
    FHScale: Double;
    FVScale: Double;
    FAlpha: byte;
    procedure AddTexture(pInfo: PTextureInfo); override;
    procedure ClearList(); override;
    procedure LoadStream(Stream: TStream); override;
    procedure LoadBuffer(Buf: PChar; var nSize: Integer); override;
    procedure ReinventParticle(); override;
  protected
    procedure DoMove(RenderIndex: Integer); override;
    procedure DoDraw; override;
  public
    constructor Create(AParent: TLSAnimPlayer); override;
    destructor Destroy; override;
  end;

  TTexture_Ccartoon_Info = record
    btType: byte;
    Sprite: IInterface;
    X: Double;
    Y: Double;
    Rot: TCustomType;
    HScale: TCustomType;
    VScale: TCustomType;

    Pos: TTexPos;
  end;
  PTexture_Ccartoon_Info = ^TTexture_Ccartoon_Info;

  TLSAnim_Ccartoon_Frame = class(TLSAnim)
  private
    FBX: Double;
    FBY: Double;
    FBRot: Double;
    FBHScale: Double;
    FBVScale: Double;
    FBAlpha: byte;

    FEX: Double;
    FEY: Double;
    FERot: Double;
    FEHScale: Double;
    FEVScale: Double;
    FEAlpha: byte;
    procedure AddTexture(pInfo: PTextureInfo); override;
    procedure ClearList(); override;
    procedure LoadStream(Stream: TStream); override;
    procedure LoadBuffer(Buf: PChar; var nSize: Integer); override;
    procedure ReinventParticle(); override;
    procedure Refurbish();
  protected
    procedure DoMove(RenderIndex: Integer); override;
    procedure DoDraw; override;
  public
    constructor Create(AParent: TLSAnimPlayer); override;
    destructor Destroy; override;
  end;

  { TMapLayer }
  TMapLayer = class(TList)
  private
  protected
    procedure DoMove(RenderIndex: Integer);
    procedure DoDraw;
    procedure ReinventParticle();
  public
    destructor Destroy; override;
  published
  end;

  TMemoryStreamEx = class(TCustomMemoryStream)
  private
    FRes: IResource;
  protected
  public
    constructor Create(const pRes: IResource);
    destructor Destroy; override;
  end;

  { TMemoryStreamEx }

constructor TMemoryStreamEx.Create(const pRes: IResource);
begin
  FRes := pRes;
  if FRes <> nil then
    SetPointer(FRes.Handle, FRes.Size);
end;

destructor TMemoryStreamEx.Destroy;
begin
  SetPointer(nil, 0);
  FRes := nil;
  inherited Destroy;
end;

{ TGList }

constructor TGList.Create;
begin
  inherited;
  InitializeCriticalSection(RTL);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(RTL);
  inherited;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(RTL);
end;

procedure TGList.UnLock;
begin
  LeaveCriticalSection(RTL);
end;

procedure GetScaleDistortion(const sX, sY, Rot, HScale, VScale, HotX, HotY: Single; const pPos: PTexPos); overload;
var
  hs, vs                    : Single;
  nX, nY                    : Single;
  CosT, SinT                : Single;
begin
  hs := HScale;
  vs := VScale;
  pPos^.X0 := (sX + pPos^.X0 - HotX) * hs;
  pPos^.Y0 := (sY + pPos^.Y0 - HotY) * vs;
  pPos^.X1 := (sX + pPos^.X1 - HotX) * hs;
  pPos^.Y1 := (sY + pPos^.Y1 - HotY) * vs;
  pPos^.X2 := (sX + pPos^.X2 - HotX) * hs;
  pPos^.Y2 := (sY + pPos^.Y2 - HotY) * vs;
  pPos^.X3 := (sX + pPos^.X3 - HotX) * hs;
  pPos^.Y3 := (sY + pPos^.Y3 - HotY) * vs;
  if (Rot <> 0.0) then begin
    CosT := Cos(Rot);
    SinT := Sin(Rot);
    nX := pPos^.X0;
    nY := pPos^.Y0;
    pPos^.X0 := nX * CosT - nY * SinT;
    pPos^.Y0 := nX * SinT + nY * CosT;
    nX := pPos^.X1;
    nY := pPos^.Y1;
    pPos^.X1 := nX * CosT - nY * SinT;
    pPos^.Y1 := nX * SinT + nY * CosT;
    nX := pPos^.X2;
    nY := pPos^.Y2;
    pPos^.X2 := nX * CosT - nY * SinT;
    pPos^.Y2 := nX * SinT + nY * CosT;
    nX := pPos^.X3;
    nY := pPos^.Y3;
    pPos^.X3 := nX * CosT - nY * SinT;
    pPos^.Y3 := nX * SinT + nY * CosT;
  end;
end;

procedure GetScaleDistortion(const sX, sY, Rot, HScale, VScale, HotX, HotY: Single; var X, Y: Single); overload;
var
  hs, vs                    : Single;
  nX, nY                    : Single;
  CosT, SinT                : Single;
begin
  hs := HScale;
  vs := VScale;
  X := (sX + X - HotX) * hs;
  Y := (sY + Y - HotY) * vs;
  if (Rot <> 0.0) then begin
    CosT := Cos(Rot);
    SinT := Sin(Rot);
    nX := X;
    nY := Y;
    X := nX * CosT - nY * SinT;
    Y := nX * SinT + nY * CosT;
  end;
end;

{ THGESpriteEx }

procedure THGESpriteEx.DoDraw(const X, Y: Single);
begin
  Render4V(X + FTexPos.X0, Y + FTexPos.Y0,
    X + FTexPos.X1, Y + FTexPos.Y1,
    X + FTexPos.X2, Y + FTexPos.Y2,
    X + FTexPos.X3, Y + FTexPos.Y3
    );
end;

procedure THGESpriteEx.SetDistortion(const X, Y, Rot, HScale, VScale: Single;
  boInit: Boolean);
var
  dHotX, dHotY              : Single;
  hs, vs                    : Single;
begin
  hs := HScale;
  vs := HScale;
  if (vs = 0) then
    vs := hs;
  dHotX := 0;
  dHotY := 0;
  if boInit then begin
    FTexPos.X0 := 0;
    FTexPos.Y0 := 0;
    FTexPos.X1 := Width;
    FTexPos.Y1 := 0;
    FTexPos.X2 := Width;
    FTexPos.Y2 := Height;
    FTexPos.X3 := 0;
    FTexPos.Y3 := Height;
    dHotX := HotX;
    dHotY := HotY;
  end;
  GetScaleDistortion(X, Y, Rot, hs, vs, dHotX, dHotY, @FTexPos);
end;

{ TMapLayer }

destructor TMapLayer.Destroy;
var
  I                         : Integer;
begin
  for I := 0 to Count - 1 do
    TLSAnim(Items[I]).Free;
  Clear;
  inherited;
end;

procedure TMapLayer.DoDraw;
var
  I                         : Integer;
begin
  for I := 0 to Count - 1 do
    TLSAnim(Items[I]).DoDraw();
end;

procedure TMapLayer.DoMove(RenderIndex: Integer);
var
  I                         : Integer;
begin
  for I := 0 to Count - 1 do
    TLSAnim(Items[I]).DoMove(RenderIndex);
end;

procedure TMapLayer.ReinventParticle;
var
  I                         : Integer;
begin
  for I := 0 to Count - 1 do
    TLSAnim(Items[I]).ReinventParticle();
end;

{ TRGBQuadEx }

function TRGBQuadEx.GetARGB: dword;
begin
  Result := ARGB(A, R, G, B);
end;

procedure TRGBQuadEx.SetARGB(Value: dword);
begin
  A := GetA(Value);
  R := GetR(Value);
  G := GetG(Value);
  B := GetB(Value);
end;

procedure TRGBQuadEx.SetAScale(Value: Single);
begin
  A := Trunc(A * Value);
end;

procedure TRGBQuadEx.SetCScale(Value: Single);
begin
  R := Trunc(R * Value);
  G := Trunc(G * Value);
  B := Trunc(B * Value);
end;

{ TFilesType }

constructor TFilesType.Create(Stream: TStream);
begin
  FTexture := nil;
  FHGE := HGECreate(HGE_VERSION);
  ;
  FLoad := False;
  FHandle := nil;
  FSize := 0;
  Assert(Stream <> nil);
  Stream.Read(FSize, SizeOf(Longword));
  if FSize > 0 then begin
    GetMem(FHandle, FSize);
    Stream.Read(FHandle^, FSize);
  end;
end;

constructor TFilesType.Create(Buf: PChar; var nSize: Integer);
begin
  FTexture := nil;
  FHGE := HGECreate(HGE_VERSION);
  ;
  FLoad := False;
  FHandle := nil;
  FSize := 0;
  Assert(Buf <> nil);
  Move(Buf[0], FSize, SizeOf(Longword));
  if FSize > 0 then begin
    GetMem(FHandle, FSize);
    Move(Buf[SizeOf(Longword)], FHandle^, FSize);
  end;
  nSize := FSize;
end;

destructor TFilesType.Destroy;
begin
  FTexture := nil;
  FHGE := nil;
  FLoad := False;
  if FHandle <> nil then
    FreeMem(FHandle, FSize);
  FHandle := nil;
  FSize := 0;
  inherited;
end;

function TFilesType.GetTexture: ITexture;
begin
  Assert(FHandle <> nil, 'FHandle = nil');
  if (FTexture = nil) and (not FLoad) and (FHandle <> nil) then begin
    FTexture := FHGE.Texture_Load(FHandle, FSize);
    FLoad := True;
  end;
  Result := FTexture;
end;

{ TLSAnim }

constructor TLSAnim.Create(AParent: TLSAnimPlayer);
begin
  FHGE := HGECreate(HGE_VERSION);
  FList := TList.Create;
  FParent := AParent;
  Assert(FParent <> nil);
  FBeginIndex := 0;                     //开始播放的帧
  FEndIndex := 0;                       //播放到第几帧
  FBoDraw := False;
  FBoParticDraw := False;
  FColor.dwColor := $FFFFFFFF;
  FCount := 0;
  FParticleList := nil;
end;

destructor TLSAnim.Destroy;
begin
  FList.Free;
  FList := nil;
  FParent := nil;
  FCount := 0;
  FHGE := nil;
  inherited;
end;

procedure TLSAnim.ClearList;
begin
end;

procedure TLSAnim.AddTexture(pInfo: PTextureInfo);
begin
end;

procedure TLSAnim.DoDraw;
begin
end;

procedure TLSAnim.DoMove(RenderIndex: Integer);
var
  I                         : Integer;
  TexInfo                   : PTexture_Info;
  Particle                  : IHGEParticleSystem;
  dt                        : Single;
begin
  FBoDraw := False;
  if (RenderIndex >= FBeginIndex) and (RenderIndex <= FEndIndex) then begin
    FBoDraw := True;
    if FParticleList <> nil then
      FBoParticDraw := True;
  end;
  if not FBoDraw and FBoParticDraw and (RenderIndex > FEndIndex) and
    (FParticleList <> nil) and (FParticleList.Count > 0) then begin
    FBoParticDraw := False;
    for I := 0 to FParticleList.Count - 1 do begin
      TexInfo := PTexture_Info(FParticleList[I]);
      if TexInfo^.Sprite <> nil then begin
        if TexInfo^.btType = 3 then begin
          Particle := TexInfo^.Sprite as IHGEParticleSystem;
          if Particle.GetParticlesAlive > 0 then begin
            dt := FHGE.Timer_GetDelta;
            Particle.Update(dt);
            FBoParticDraw := True;
          end;
        end;
      end;
    end;
    if not FBoParticDraw then begin
      for I := 0 to FParticleList.Count - 1 do begin
        TexInfo := PTexture_Info(FParticleList[I]);
        if TexInfo^.Sprite <> nil then begin
          if TexInfo^.btType = 3 then begin
            Particle := TexInfo^.Sprite as IHGEParticleSystem;
            Particle.Stop(True);
          end;
        end;
      end;
    end;
  end;
end;

procedure TLSAnim.LoadBuffer(Buf: PChar; var nSize: Integer);
var
  I                         : Integer;
  nPosition, nPos           : Int64;
  btType                    : byte;
  TextureInfo               : TTextureInfo;
begin
  //读取下面的纹理
  nPos := 0;
  for I := 0 to FCount - 1 do begin
    nPosition := nPos;
    Move(Buf[nPos], btType, SizeOf(byte));
    Inc(nPos, SizeOf(byte));
    nPos := nPosition;
    case btType of
      0: begin
          Move(Buf[nPos], TextureInfo, SizeOf(TTextureInfo) - (SizeOf(TCustomType) * 3));
          Inc(nPos, SizeOf(TTextureInfo) - (SizeOf(TCustomType) * 3));
        end;
      1, 2: begin
          Move(Buf[nPos], TextureInfo, SizeOf(TTextureInfo));
          Inc(nPos, SizeOf(TTextureInfo));
        end;
      3: begin
          Move(Buf[nPos], TextureInfo, SizeOf(TTextureInfo) - (SizeOf(TCustomType) * 2));
          Inc(nPos, SizeOf(TTextureInfo) - (SizeOf(TCustomType) * 2));
        end
    else
      Assert(False, 'TLSAnim::LoadStream btType2 不知道的类型');
    end;
    AddTexture(@TextureInfo);
  end;
  nSize := nPos;
end;

procedure TLSAnim.LoadStream(Stream: TStream);
var
  I                         : Integer;
  nPosition                 : Int64;
  btType                    : byte;
  TextureInfo               : TTextureInfo;
begin
  //读取下面的纹理
  for I := 0 to FCount - 1 do begin
    nPosition := Stream.Position;
    Stream.Read(btType, SizeOf(byte));
    Stream.Position := nPosition;
    case btType of
      0: Stream.Read(TextureInfo, SizeOf(TTextureInfo) - (SizeOf(TCustomType) * 3));
      1, 2: Stream.Read(TextureInfo, SizeOf(TTextureInfo));
      3: Stream.Read(TextureInfo, SizeOf(TTextureInfo) - (SizeOf(TCustomType) * 2));
    else
      Assert(False, 'TLSAnim::LoadStream btType2 不知道的类型');
    end;
    AddTexture(@TextureInfo);
  end;
end;

procedure TLSAnim.ReinventParticle;
begin
end;

{ TLSAnimSprite }

constructor TLSAnimSprite.Create(AParent: TSprite);
begin
  inherited;
  FLSAnimPlayer := TLSAnimPlayer.Create(Self);
  FFileName := '';
  FStartTick := GetTickCount;
  FTimes := 0;                          //播放时间
  FBout := 0;                           //播放次数
  FAlpha := $FF;
  FLight := $FF;
  FLSAnimPlayer.Light := FLight;
  FLSAnimPlayer.Alpha := FAlpha;
end;

destructor TLSAnimSprite.Destroy;
begin
  FLSAnimPlayer.Free;
  inherited;
end;

procedure TLSAnimSprite.DoDraw;
var
  I, II                     : Integer;
  MapLayer                  : TMapLayer;
begin
  FLSAnimPlayer.DoDraw;
end;

procedure TLSAnimSprite.DoMove;
var
  I, II                     : Integer;
  MapLayer                  : TMapLayer;
  PControl                  : PControlInfo;
begin
  if (FTimes > 0) and (Integer(GetTickCount - FStartTick) > FTimes) then begin
    FTimes := 0;
    FBout := 0;
    Dead;
    Exit;
  end;
  if (FBout > 0) and (FLSAnimPlayer.FUseBout > FBout) then begin
    Dead;
    FTimes := 0;
    FBout := 0;
    Exit;
  end;
  FLSAnimPlayer.DoMove;
end;

function TLSAnimSprite.GetRenderIndex: Integer;
begin
  Result := FLSAnimPlayer.RenderIndex;
end;

procedure TLSAnimSprite.LoadFromIni(Sec, Key: string);
begin
  inherited LoadFromIni(Sec, Key);
  FTimes := FHGE.Ini_GetInt(Sec, Key + '_Times', FTimes);
  FBout := FHGE.Ini_GetInt(Sec, Key + '_Bout', FBout);
  FileName := FHGE.Ini_GetString(Sec, Key + '_URL', FileName);
end;

procedure TLSAnimSprite.Pause;
begin
  FLSAnimPlayer.Pause;
end;

procedure TLSAnimSprite.Play(Bindex: Integer = -1; boFrame: Boolean = False);
begin
  FLSAnimPlayer.Play(Bindex, boFrame);
end;

procedure TLSAnimSprite.SetFileName(const Value: string);
begin
  if FFileName <> Value then begin
    FFileName := Value;
    FLSAnimPlayer.FileName := FFileName;
  end;
end;

procedure TLSAnimSprite.SetAlpha(Value: byte);
begin
  if FAlpha <> Value then begin
    FAlpha := Value;
    FLSAnimPlayer.Alpha := FAlpha;
  end;
end;

procedure TLSAnimSprite.SetLight(Value: byte);
begin
  if FLight <> Value then begin
    FLight := Value;
    FLSAnimPlayer.Light := FLight;
  end;
end;

function TLSAnimSprite.GetFirstFrame: ITexture;
var
  Target                    : ITarget;
begin
  Result := nil;
  if FLSAnimPlayer.GetLoadHit then begin
    Target := FHGE.Target_Create(Width, Height, False);
    if Target <> nil then begin
      Result := Target.Tex;
      FLSAnimPlayer.Play;
      FLSAnimPlayer.DoMove;
      FLSAnimPlayer.FRenderIndex := 0;
      FHGE.Gfx_BeginScene(Target);
      try
        FHGE.Gfx_Clear(0);
        FLSAnimPlayer.DoDraw;
      finally
        FHGE.Gfx_EndScene;
        Target := nil;
      end;
      FLSAnimPlayer.Pause;
    end;
  end;
end;

{ TLSAnim_CURRENTLY }

constructor TLSAnim_Currently_Frame.Create(AParent: TLSAnimPlayer);
begin
  inherited;
  FX := 0.0;
  FY := 0.0;
  FRot := 0.0;
  FHScale := 1.0;
  FVScale := 1.0;
  FAlpha := 255;
  FColor.A := FAlpha;
  FRenderIndex := -1;
end;

destructor TLSAnim_Currently_Frame.Destroy;
begin
  ClearList();
  inherited;
end;

procedure TLSAnim_Currently_Frame.ClearList();
var
  I                         : Integer;
  TexInfo                   : PTexture_Currently_Info;
begin
  if FParticleList <> nil then begin
    FParticleList.Free;
    FParticleList := nil;
  end;
  for I := 0 to FList.Count - 1 do begin
    TexInfo := PTexture_Currently_Info(FList[I]);
    TexInfo^.Sprite := nil;
    Dispose(TexInfo);
  end;
  FList.Clear;
end;

procedure TLSAnim_Currently_Frame.AddTexture(pInfo: PTextureInfo);
var
  TexInfo                   : PTexture_Currently_Info;
  FilesType                 : TFilesType;
  Tex                       : ITexture;
  TX1, TY1, nW, nH          : Integer;
  HotX, HotY                : Single;
  D                         : IHGESprite;
  Particle                  : IHGEParticleSystem;
  pList                     : TList;
begin
  if pInfo <> nil then begin
    pList := FParent.FFilesList;
    if pList = nil then Exit;

    New(TexInfo);
    try

      nW := pInfo^.W;
      nH := pInfo^.H;
      TX1 := pInfo^.X;
      TY1 := pInfo^.Y;
      HotX := nW / 2;
      HotY := nH / 2;
      TexInfo^.btType := pInfo^.btType;
      if TexInfo^.btType in [0..2] then begin
        Tex := nil;
        FilesType := nil;
        if pInfo^.nIndex < pList.Count then
          FilesType := TFilesType(pList[pInfo^.nIndex]);
        if FilesType <> nil then Tex := FilesType.Texture;
        D := THGESprite.Create(Tex, pInfo^.T, pInfo^.L, nW, nH);
        TexInfo^.Sprite := D as IInterface;
        D.SetColor(FColor.GetARGB);
        //选算出自已的
        case pInfo^.btType of
          0, 1: begin
              TexInfo^.Pos.X0 := 0;
              TexInfo^.Pos.Y0 := 0;
              TexInfo^.Pos.X1 := nW;
              TexInfo^.Pos.Y1 := 0;
              TexInfo^.Pos.X2 := nW;
              TexInfo^.Pos.Y2 := nH;
              TexInfo^.Pos.X3 := 0;
              TexInfo^.Pos.Y3 := nH;
              if pInfo^.btType = 0 then
                GetScaleDistortion(0, 0, 0, 1, 1, HotX, HotY, @TexInfo^.Pos)
              else
                GetScaleDistortion(0, 0, pInfo^.Rot.D, pInfo^.HScale.D, pInfo^.VScale.D, HotX, HotY, @TexInfo^.Pos);
            end;
          2: begin
              TexInfo^.Pos.X0 := 0 - HotX;
              TexInfo^.Pos.Y0 := 0 - HotY;
              TexInfo^.Pos.X1 := pInfo^.Rot.X - HotX;
              TexInfo^.Pos.Y1 := pInfo^.Rot.Y - HotY;
              TexInfo^.Pos.X2 := pInfo^.HScale.X - HotX;
              TexInfo^.Pos.Y2 := pInfo^.HScale.Y - HotY;
              TexInfo^.Pos.X3 := pInfo^.VScale.X - HotX;
              TexInfo^.Pos.Y3 := pInfo^.VScale.Y - HotY;
            end;
        end;
        GetScaleDistortion(TX1, TY1, FRot, FHScale, FVScale, 0, 0, @TexInfo^.Pos);
        GetScaleDistortion(FX, FY, 0, FParent.FHScale, FParent.FVScale, 0, 0, @TexInfo^.Pos)
      end else
        if TexInfo^.btType = 3 then begin

          Tex := nil;
          FilesType := nil;
          if (pInfo^.Rot.X >= 0) and (pInfo^.Rot.X < pList.Count) then
            FilesType := TFilesType(pList[pInfo^.Rot.X]);
          if FilesType <> nil then Tex := FilesType.Texture;
          D := THGESpriteEx.Create(Tex, pInfo^.T, pInfo^.L, nW, nH);

          FilesType := nil;
          if pInfo^.nIndex < pList.Count then
            FilesType := TFilesType(pList[pInfo^.nIndex]);

          if FilesType <> nil then Particle := THGEParticleSystem.Create(FilesType.FHandle, FilesType.FSize, D)
          else Particle := THGEParticleSystem.Create(nil, 0, D);
          TexInfo^.Sprite := Particle as IInterface;

          TexInfo^.Pos.X0 := TX1;
          TexInfo^.Pos.Y0 := TY1;
          if FParticleList = nil then FParticleList := TList.Create;
          FParticleList.Add(TexInfo);
        end;

      FList.Add(TexInfo);
    except
      Dispose(TexInfo);
    end;
  end;
end;

procedure TLSAnim_Currently_Frame.DoDraw;
var
  I, II                     : Integer;
  TexInfo                   : PTexture_Currently_Info;
  D                         : IHGESprite;
  D2                        : IHGESpriteEx;
  Particle                  : IHGEParticleSystem;
  Par                       : PHGEParticle;
  Col                       : Longword;
  RGBQuad                   : TRGBQuadEx;
  A                         : Integer;
  nX, nY                    : Single;
begin
  if FBoDraw then begin
    nX := FParent.X;
    nY := FParent.Y;
    for I := 0 to FList.Count - 1 do begin
      TexInfo := PTexture_Currently_Info(FList[I]);
      if TexInfo^.Sprite <> nil then begin
        if TexInfo^.btType in [0..2] then begin
          D := TexInfo.Sprite as IHGESprite;
          Col := D.GetColor();
          try
            RGBQuad.SetARGB(Col);
            RGBQuad.SetAScale(FParent.FAlpha);
            RGBQuad.SetCScale(FParent.FLight);
            D.SetColor(RGBQuad.GetARGB);
            D.Render4V(nX + TexInfo.Pos.X0, nY + TexInfo.Pos.Y0,
              nX + TexInfo.Pos.X1, nY + TexInfo.Pos.Y1,
              nX + TexInfo.Pos.X2, nY + TexInfo.Pos.Y2,
              nX + TexInfo.Pos.X3, nY + TexInfo.Pos.Y3
              );
          finally
            D.SetColor(Col);
          end;
        end else if TexInfo^.btType = 3 then begin
          Particle := TexInfo^.Sprite as IHGEParticleSystem;
          if Particle.Info^.Sprite <> nil then begin
            Col := Particle.Info^.Sprite.GetColor;
            for II := 0 to Particle.GetParticlesAlive - 1 do begin
              Par := Particle.GetParticles(II);
              if (Par <> nil) then begin
                RGBQuad.R := Trunc(Par^.Color.R * 255);
                RGBQuad.G := Trunc(Par^.Color.G * 255);
                RGBQuad.B := Trunc(Par^.Color.B * 255);
                RGBQuad.A := Trunc(Par^.Color.A * 255);
                RGBQuad.SetAScale(FAlpha / 255);
                RGBQuad.SetAScale(FParent.FAlpha);
                RGBQuad.SetCScale(FParent.FLight);

                Particle.Info^.Sprite.SetColor(RGBQuad.GetARGB);
                D2 := Particle.Info^.Sprite as IHGESpriteEx;
                D2.SetDistortion(0, 0, Par^.Spin * Par^.Age, Par^.Size, Par^.Size, True);
                D2.SetDistortion(Par^.Location.X, Par^.Location.Y, FRot, FHScale, FVScale, False);
                D2.SetDistortion(FX, FY, 0, FParent.FHScale, FParent.FVScale, False);
                D2.DoDraw(nX, nY);
              end;
            end;
            Particle.Info^.Sprite.SetColor(Col);
          end;
        end;
      end;
    end;
  end else if FBoParticDraw and (FParticleList <> nil) then begin
    nX := FParent.X;
    nY := FParent.Y;
    for I := 0 to FParticleList.Count - 1 do begin
      TexInfo := PTexture_Currently_Info(FParticleList[I]);
      if TexInfo^.Sprite <> nil then begin
        if TexInfo^.btType = 3 then begin
          Particle := TexInfo^.Sprite as IHGEParticleSystem;
          if Particle.Info^.Sprite <> nil then begin
            Col := Particle.Info^.Sprite.GetColor;
            for II := 0 to Particle.GetParticlesAlive - 1 do begin
              Par := Particle.GetParticles(II);
              if (Par <> nil) then begin
                RGBQuad.R := Trunc(Par^.Color.R * 255);
                RGBQuad.G := Trunc(Par^.Color.G * 255);
                RGBQuad.B := Trunc(Par^.Color.B * 255);
                RGBQuad.A := Trunc(Par^.Color.A * 255);
                RGBQuad.SetAScale(FAlpha / 255);
                RGBQuad.SetAScale(FParent.FAlpha);
                RGBQuad.SetCScale(FParent.FLight);

                Particle.Info^.Sprite.SetColor(RGBQuad.GetARGB);
                D2 := Particle.Info^.Sprite as IHGESpriteEx;
                D2.SetDistortion(0, 0, Par^.Spin * Par^.Age, Par^.Size, Par^.Size, True);
                D2.SetDistortion(Par^.Location.X, Par^.Location.Y, FRot, FHScale, FVScale, False);
                D2.SetDistortion(FX, FY, 0, FParent.FHScale, FParent.FVScale, False);
                D2.DoDraw(nX, nY);
              end;
            end;
            Particle.Info^.Sprite.SetColor(Col);
          end;
        end;
      end;
    end;

  end;
end;

procedure TLSAnim_Currently_Frame.DoMove(RenderIndex: Integer);
var
  I                         : Integer;
  TexInfo                   : PTexture_Currently_Info;
  Particle                  : IHGEParticleSystem;
  dt                        : Single;
begin
  inherited DoMove(RenderIndex);
  if FBoDraw and (FParticleList <> nil) then begin
    for I := 0 to FParticleList.Count - 1 do begin
      TexInfo := PTexture_Currently_Info(FParticleList[I]);
      if TexInfo^.Sprite <> nil then begin
        if TexInfo^.btType = 3 then begin
          Particle := TexInfo^.Sprite as IHGEParticleSystem;
          if Particle.GetParticlesAlive <= 0 then
            Particle.FireAt(TexInfo.Pos.X0, TexInfo.Pos.Y0);

          dt := FHGE.Timer_GetDelta;
          Particle.Update(dt);
        end;
      end;
    end;
  end;
end;

procedure TLSAnim_Currently_Frame.LoadBuffer(Buf: PChar; var nSize: Integer);
var
  FrameInfo                 : TFrame_Currently_Info;
  ASize                     : Integer;
begin
  nSize := 0;
  Move(Buf[0], FrameInfo, SizeOf(TFrame_Currently_Info));
  Inc(nSize, SizeOf(TFrame_Currently_Info));
  FBeginIndex := FrameInfo.PLACE;
  FEndIndex := 0;
  FX := FrameInfo.BX;
  FY := FrameInfo.BY;
  FRot := FrameInfo.BRot;
  FHScale := FrameInfo.BHScale;
  FVScale := FrameInfo.BVScale;
  FAlpha := FrameInfo.BAlpha;
  FColor := FrameInfo.Color;
  FColor.A := FAlpha;
  FCount := FrameInfo.Count;
  inherited LoadBuffer(@Buf[nSize], ASize);
  Inc(nSize, ASize);
end;

procedure TLSAnim_Currently_Frame.LoadStream(Stream: TStream);
var
  FrameInfo                 : TFrame_Currently_Info;
begin
  Stream.Read(FrameInfo, SizeOf(TFrame_Currently_Info));
  FBeginIndex := FrameInfo.PLACE;
  FEndIndex := 0;
  FX := FrameInfo.BX;
  FY := FrameInfo.BY;
  FRot := FrameInfo.BRot;
  FHScale := FrameInfo.BHScale;
  FVScale := FrameInfo.BVScale;
  FAlpha := FrameInfo.BAlpha;
  FColor := FrameInfo.Color;
  FColor.A := FAlpha;
  FCount := FrameInfo.Count;
  inherited LoadStream(Stream);
end;

procedure TLSAnim_Currently_Frame.ReinventParticle;
var
  I                         : Integer;
  TexInfo                   : PTexture_Currently_Info;
  Particle                  : IHGEParticleSystem;
begin
  if (FParticleList <> nil) then begin
    for I := 0 to FParticleList.Count - 1 do begin
      TexInfo := PTexture_Currently_Info(FParticleList[I]);
      if TexInfo^.Sprite <> nil then begin
        if TexInfo^.btType = 3 then begin
          Particle := TexInfo^.Sprite as IHGEParticleSystem;
          Particle.Stop(True);
        end;
      end;
    end;
  end;
end;

{ TLSAnim_Ccartoon }

constructor TLSAnim_Ccartoon_Frame.Create(AParent: TLSAnimPlayer);
begin
  inherited;
  FBX := 0.0;
  FBY := 0.0;
  FBRot := 0.0;
  FBHScale := 1.0;
  FBVScale := 1.0;
  FBAlpha := 255;
  FEX := 0.0;
  FEY := 0.0;
  FERot := 0.0;
  FEHScale := 1.0;
  FEVScale := 1.0;
  FEAlpha := 255;
  FColor.A := FBAlpha;
  FRenderIndex := -1;
end;

destructor TLSAnim_Ccartoon_Frame.Destroy;
begin
  ClearList();
  inherited;
end;

procedure TLSAnim_Ccartoon_Frame.ClearList;
var
  I                         : Integer;
  TexInfo                   : PTexture_Ccartoon_Info;
begin
  if FParticleList <> nil then begin
    FParticleList.Free;
    FParticleList := nil;
  end;
  for I := 0 to FList.Count - 1 do begin
    TexInfo := PTexture_Ccartoon_Info(FList[I]);
    TexInfo^.Sprite := nil;
    Dispose(TexInfo);
  end;
  FList.Clear;
end;

procedure TLSAnim_Ccartoon_Frame.AddTexture(pInfo: PTextureInfo);
var
  TexInfo                   : PTexture_Ccartoon_Info;
  FilesType                 : TFilesType;
  Tex                       : ITexture;
  D                         : IHGESprite;
  Particle                  : IHGEParticleSystem;
  pList                     : TList;
begin
  if pInfo <> nil then begin
    pList := FParent.FFilesList;
    if pList = nil then Exit;

    New(TexInfo);
    try
      TexInfo^.btType := pInfo^.btType;
      TexInfo^.X := pInfo^.X;
      TexInfo^.Y := pInfo^.Y;
      if TexInfo^.btType in [0..2] then begin
        Tex := nil;
        FilesType := nil;
        if pInfo^.nIndex < pList.Count then
          FilesType := TFilesType(pList[pInfo^.nIndex]);
        if FilesType <> nil then Tex := FilesType.Texture;
        D := THGESprite.Create(Tex, pInfo^.T, pInfo^.L, pInfo^.W, pInfo^.H);
        TexInfo^.Sprite := D as IInterface;
        D.SetColor(FColor.GetARGB);
        TexInfo^.Rot := pInfo^.Rot;
        TexInfo^.HScale := pInfo^.HScale;
        TexInfo^.VScale := pInfo^.VScale;
      end else
        if TexInfo^.btType = 3 then begin
          Tex := nil;
          FilesType := nil;
          if (pInfo^.Rot.X >= 0) and (pInfo^.Rot.X < pList.Count) then
            FilesType := TFilesType(pList[pInfo^.Rot.X]);
          if FilesType <> nil then Tex := FilesType.Texture;
          D := THGESpriteEx.Create(Tex, pInfo^.T, pInfo^.L, pInfo^.W, pInfo^.H);

          FilesType := nil;
          if pInfo^.nIndex < pList.Count then
            FilesType := TFilesType(pList[pInfo^.nIndex]);
          if FilesType <> nil then Particle := THGEParticleSystem.Create(FilesType.FHandle, FilesType.FSize, D)
          else Particle := THGEParticleSystem.Create(nil, 0, D);
          TexInfo^.Sprite := Particle as IInterface;

          if FParticleList = nil then FParticleList := TList.Create;
          FParticleList.Add(TexInfo);
        end;

      FList.Add(TexInfo);
    except
      Dispose(TexInfo);
    end;
  end;
end;

procedure TLSAnim_Ccartoon_Frame.DoDraw;
var
  I, II                     : Integer;
  TexInfo                   : PTexture_Ccartoon_Info;
  D                         : IHGESprite;
  D2                        : IHGESpriteEx;
  Particle                  : IHGEParticleSystem;
  Par                       : PHGEParticle;
  Col                       : Longword;
  RGBQuad                   : TRGBQuadEx;
  A                         : Integer;
  nX, nY                    : Single;
begin
  if FBoDraw then begin
    nX := FParent.X;
    nY := FParent.Y;
    for I := 0 to FList.Count - 1 do begin
      TexInfo := PTexture_Ccartoon_Info(FList[I]);
      if TexInfo^.Sprite <> nil then begin
        if TexInfo^.btType in [0..2] then begin
          D := TexInfo^.Sprite as IHGESprite;
          Col := D.GetColor();
          try
            RGBQuad.SetARGB(Col);
            RGBQuad.SetAScale(FParent.FAlpha);
            RGBQuad.SetCScale(FParent.FLight);
            D.SetColor(RGBQuad.GetARGB);
            D.Render4V(nX + TexInfo.Pos.X0, nY + TexInfo.Pos.Y0,
              nX + TexInfo.Pos.X1, nY + TexInfo.Pos.Y1,
              nX + TexInfo.Pos.X2, nY + TexInfo.Pos.Y2,
              nX + TexInfo.Pos.X3, nY + TexInfo.Pos.Y3
              );
          finally
            D.SetColor(Col);
          end;
        end else if TexInfo^.btType = 3 then begin
          Particle := TexInfo^.Sprite as IHGEParticleSystem;
          if Particle.Info^.Sprite <> nil then begin
            Col := Particle.Info^.Sprite.GetColor;
            for II := 0 to Particle.GetParticlesAlive - 1 do begin
              Par := Particle.GetParticles(II);
              if (Par <> nil) then begin
                RGBQuad.R := Trunc(Par^.Color.R * 255);
                RGBQuad.G := Trunc(Par^.Color.G * 255);
                RGBQuad.B := Trunc(Par^.Color.B * 255);
                RGBQuad.A := Trunc(Par^.Color.A * 255);
                RGBQuad.SetAScale(TexInfo^.Pos.Y3 / 255);
                RGBQuad.SetAScale(FParent.FAlpha);
                RGBQuad.SetCScale(FParent.FLight);

                Particle.Info^.Sprite.SetColor(RGBQuad.GetARGB);
                D2 := Particle.Info^.Sprite as IHGESpriteEx;
                D2.SetDistortion(0, 0, Par^.Spin * Par^.Age, Par^.Size, Par^.Size, True);
                D2.SetDistortion(Par^.Location.X - TexInfo.Pos.X1,
                  Par^.Location.Y - TexInfo.Pos.Y1,
                  TexInfo.Pos.X2,
                  TexInfo.Pos.Y2,
                  TexInfo.Pos.X3, False);

                D2.SetDistortion(TexInfo.Pos.X1, TexInfo.Pos.Y1, 0, FParent.FHScale, FParent.FVScale, False);
                D2.DoDraw(nX, nY);
              end;
            end;
            Particle.Info^.Sprite.SetColor(Col);
          end;
        end;
      end;
    end;
  end else if FBoParticDraw and (FParticleList <> nil) then begin
    nX := FParent.X;
    nY := FParent.Y;
    for I := 0 to FParticleList.Count - 1 do begin
      TexInfo := PTexture_Ccartoon_Info(FParticleList[I]);
      if TexInfo^.Sprite <> nil then begin
        if TexInfo^.btType = 3 then begin
          Particle := TexInfo^.Sprite as IHGEParticleSystem;
          if Particle.Info^.Sprite <> nil then begin
            Col := Particle.Info^.Sprite.GetColor;
            for II := 0 to Particle.GetParticlesAlive - 1 do begin
              Par := Particle.GetParticles(II);
              if (Par <> nil) then begin
                RGBQuad.R := Trunc(Par^.Color.R * 255);
                RGBQuad.G := Trunc(Par^.Color.G * 255);
                RGBQuad.B := Trunc(Par^.Color.B * 255);
                RGBQuad.A := Trunc(Par^.Color.A * 255);
                RGBQuad.SetAScale(TexInfo^.Pos.Y3 / 255);
                RGBQuad.SetAScale(FParent.FAlpha);
                RGBQuad.SetCScale(FParent.FLight);

                Particle.Info^.Sprite.SetColor(RGBQuad.GetARGB);
                D2 := Particle.Info^.Sprite as IHGESpriteEx;
                D2.SetDistortion(0, 0, Par^.Spin * Par^.Age, Par^.Size, Par^.Size, True);
                D2.SetDistortion(Par^.Location.X - TexInfo.Pos.X1,
                  Par^.Location.Y - TexInfo.Pos.Y1,
                  TexInfo.Pos.X2,
                  TexInfo.Pos.Y2,
                  TexInfo.Pos.X3, False);

                D2.SetDistortion(TexInfo.Pos.X1, TexInfo.Pos.Y1, 0, FParent.FHScale, FParent.FVScale, False);
                D2.DoDraw(nX, nY);
              end;
            end;
            Particle.Info^.Sprite.SetColor(Col);
          end;
        end;
      end;
    end;
  end;
end;

procedure TLSAnim_Ccartoon_Frame.DoMove(RenderIndex: Integer);
var
  I                         : Integer;
  TexInfo                   : PTexture_Ccartoon_Info;
  Particle                  : IHGEParticleSystem;
  dt                        : Single;
  BoDraw                    : Boolean;
begin
  BoDraw := FBoDraw;
  inherited DoMove(RenderIndex);
  if FBoDraw then begin
    if FRenderIndex <> RenderIndex then begin
      FRenderIndex := RenderIndex;
      Refurbish();
    end;
    if FParticleList <> nil then begin
      for I := 0 to FParticleList.Count - 1 do begin
        TexInfo := PTexture_Ccartoon_Info(FParticleList[I]);
        if TexInfo^.Sprite <> nil then begin
          if TexInfo^.btType = 3 then begin
            Particle := TexInfo^.Sprite as IHGEParticleSystem;
            if Particle.GetParticlesAlive <= 0 then
              Particle.FireAt(TexInfo.Pos.X0, TexInfo.Pos.Y0);

            dt := FHGE.Timer_GetDelta;
            Particle.Update(dt);
          end;
        end;
      end;
    end;

  end;
end;

procedure TLSAnim_Ccartoon_Frame.LoadBuffer(Buf: PChar; var nSize: Integer);
var
  FrameInfo                 : TFrame_Ccartoon_Info;
  ASize                     : Integer;
begin
  nSize := 0;
  if Buf = nil then Exit;
  Move(Buf[nSize], FrameInfo, SizeOf(TFrame_Ccartoon_Info));
  Inc(nSize, SizeOf(TFrame_Ccartoon_Info));
  FBeginIndex := FrameInfo.PLACE;
  FEndIndex := 0;
  FColor := FrameInfo.Color;
  FBX := FrameInfo.BX;
  FBY := FrameInfo.BY;
  FBRot := FrameInfo.BRot;
  FBHScale := FrameInfo.BHScale;
  FBVScale := FrameInfo.BVScale;
  FBAlpha := FrameInfo.BAlpha;
  FColor.A := FBAlpha;
  FEX := FrameInfo.EX;
  FEY := FrameInfo.EY;
  FERot := FrameInfo.ERot;
  FEHScale := FrameInfo.EHScale;
  FEVScale := FrameInfo.EVScale;
  FEAlpha := FrameInfo.EAlpha;
  FCount := FrameInfo.Count;
  FRenderIndex := -1;
  inherited LoadBuffer(@Buf[nSize], ASize);
  Inc(nSize, ASize);
end;

procedure TLSAnim_Ccartoon_Frame.LoadStream(Stream: TStream);
var
  FrameInfo                 : TFrame_Ccartoon_Info;
begin
  if Stream = nil then Exit;
  Stream.Read(FrameInfo, SizeOf(TFrame_Ccartoon_Info));
  FBeginIndex := FrameInfo.PLACE;
  FEndIndex := 0;
  FColor := FrameInfo.Color;
  FBX := FrameInfo.BX;
  FBY := FrameInfo.BY;
  FBRot := FrameInfo.BRot;
  FBHScale := FrameInfo.BHScale;
  FBVScale := FrameInfo.BVScale;
  FBAlpha := FrameInfo.BAlpha;
  FColor.A := FBAlpha;
  FEX := FrameInfo.EX;
  FEY := FrameInfo.EY;
  FERot := FrameInfo.ERot;
  FEHScale := FrameInfo.EHScale;
  FEVScale := FrameInfo.EVScale;
  FEAlpha := FrameInfo.EAlpha;
  FCount := FrameInfo.Count;
  FRenderIndex := -1;
  inherited LoadStream(Stream);
end;

procedure TLSAnim_Ccartoon_Frame.Refurbish();
var
  nFrameCount               : Integer;
  nCurrently                : Integer;
  GX, GY                    : Double;
  GRot, GHScale, GVScale    : Double;
  GAlpha                    : byte;

  function GetExcursion(Bbt, Ebt: byte): byte; overload;
  var
    nnn                     : Integer;
  begin
    if (Ebt <> Bbt) and (nFrameCount <> 0) then begin
      nnn := Round((Max(Bbt, Ebt) - Min(Bbt, Ebt)) / nFrameCount * nCurrently);
      if Ebt > Bbt then
        Result := Bbt + nnn
      else
        Result := Bbt - nnn;
    end else
      Result := Bbt;
  end;

  function GetExcursion(Bbt, Ebt: Integer): Integer; overload;
  var
    nnn                     : Integer;
  begin
    if (Ebt <> Bbt) and (nFrameCount <> 0) then begin
      nnn := Round((Max(Bbt, Ebt) - Min(Bbt, Ebt)) / nFrameCount * nCurrently);
      if Ebt > Bbt then
        Result := Bbt + nnn
      else
        Result := Bbt - nnn;
    end else
      Result := Bbt;
  end;

  function GetExcursion(Bbt, Ebt: Double): Double; overload;
  var
    nnn                     : Double;
  begin
    if (Ebt <> Bbt) and (nFrameCount <> 0) then begin
      nnn := (Max(Bbt, Ebt) - Min(Bbt, Ebt)) / nFrameCount * nCurrently;
      if Ebt > Bbt then
        Result := Bbt + nnn
      else
        Result := Bbt - nnn;
    end else
      Result := Bbt;
  end;

var
  I                         : Integer;
  TexInfo                   : PTexture_Ccartoon_Info;
  TX1, TY1, nW, nH          : Single;
  HotX, HotY                : Single;
  D                         : IHGESprite;
  Particle                  : IHGEParticleSystem;
begin
  if not FBoDraw then Exit;
  nFrameCount := FEndIndex - FBeginIndex;
  nCurrently := FRenderIndex - FBeginIndex;
  GAlpha := GetExcursion(FBAlpha, FEAlpha);
  FColor.A := GAlpha;
  GX := GetExcursion(FBX, FEX);
  GY := GetExcursion(FBY, FEY);
  GRot := GetExcursion(FBRot, FERot);
  GHScale := GetExcursion(FBHScale, FEHScale);
  GVScale := GetExcursion(FBVScale, FEVScale);
  for I := 0 to FList.Count - 1 do begin
    TexInfo := PTexture_Ccartoon_Info(FList[I]);
    TX1 := TexInfo^.X;
    TY1 := TexInfo^.Y;
    if TexInfo.btType in [0..2] then begin
      D := (TexInfo^.Sprite as IHGESprite);
      D.SetColor(FColor.GetARGB);
      nW := D.GetWidth;
      nH := D.GetHeight;
      HotX := nW / 2;
      HotY := nH / 2;
      //选算出自已的
      case TexInfo^.btType of
        0, 1: begin
            TexInfo^.Pos.X0 := 0;
            TexInfo^.Pos.Y0 := 0;
            TexInfo^.Pos.X1 := nW;
            TexInfo^.Pos.Y1 := 0;
            TexInfo^.Pos.X2 := nW;
            TexInfo^.Pos.Y2 := nH;
            TexInfo^.Pos.X3 := 0;
            TexInfo^.Pos.Y3 := nH;
            if TexInfo^.btType = 0 then
              GetScaleDistortion(0, 0, 0, 1, 1, HotX, HotY, @TexInfo^.Pos)
            else
              GetScaleDistortion(0, 0, TexInfo^.Rot.D, TexInfo^.HScale.D, TexInfo^.VScale.D, HotX, HotY, @TexInfo^.Pos);
          end;
        2: begin
            TexInfo^.Pos.X0 := 0 - HotX;
            TexInfo^.Pos.Y0 := 0 - HotY;
            TexInfo^.Pos.X1 := TexInfo^.Rot.X - HotX;
            TexInfo^.Pos.Y1 := TexInfo^.Rot.Y - HotY;
            TexInfo^.Pos.X2 := TexInfo^.HScale.X - HotX;
            TexInfo^.Pos.Y2 := TexInfo^.HScale.Y - HotY;
            TexInfo^.Pos.X3 := TexInfo^.VScale.X - HotX;
            TexInfo^.Pos.Y3 := TexInfo^.VScale.Y - HotY;
          end;
      end;
      //在算出  Frame 的
      GetScaleDistortion(TX1, TY1, GRot, GHScale, GVScale, 0, 0, @TexInfo^.Pos);
      //在算出 总图层 的
      GetScaleDistortion(GX, GY, 0, FParent.FHScale, FParent.FVScale, 0, 0, @TexInfo^.Pos)
    end else
      if TexInfo.btType = 3 then begin
        if (TexInfo^.Sprite <> nil) then begin
          Particle := TexInfo^.Sprite as IHGEParticleSystem;
          if Particle.Info^.Sprite <> nil then begin
            TexInfo^.Pos.X0 := GX + TexInfo.X;
            TexInfo^.Pos.Y0 := GY + TexInfo.Y;

            Particle.MoveTo(TexInfo^.Pos.X0, TexInfo^.Pos.Y0);

            TexInfo^.Pos.X1 := GX;
            TexInfo^.Pos.Y1 := GY;
            TexInfo^.Pos.X2 := GRot;
            TexInfo^.Pos.Y2 := GHScale;
            TexInfo^.Pos.X3 := GVScale;
            TexInfo^.Pos.Y3 := GAlpha;
          end;
        end;
      end;
  end;
end;

procedure TLSAnim_Ccartoon_Frame.ReinventParticle;
var
  I                         : Integer;
  TexInfo                   : PTexture_Ccartoon_Info;
  Particle                  : IHGEParticleSystem;
begin
  if (FParticleList <> nil) then begin
    for I := 0 to FParticleList.Count - 1 do begin
      TexInfo := PTexture_Ccartoon_Info(FParticleList[I]);
      if TexInfo^.Sprite <> nil then begin
        if TexInfo^.btType = 3 then begin
          Particle := TexInfo^.Sprite as IHGEParticleSystem;
          Particle.Stop(True);
        end;
      end;
    end;
  end;
end;

{ TLSAnimPlayer }

constructor TLSAnimPlayer.Create(AParent: TObject);
begin
  inherited Create;
  FParent := AParent;
  FHGE := HGECreate(HGE_VERSION);
  ;
  FTierList := TGList.Create;
  FFilesList := TGList.Create;
  FFileName := '';
  FIsPlay := False;
  FStartTick := GetTickCount;
  FDTime := 0;
  FUseBout := 0;
  FMaxIndex := 0;
  FHScale := 1.0;
  FVScale := 1.0;
  FResultContro := nil;
  FboResult := False;
  SetLength(FControlList, 0);
  FCurrentlyControl := nil;
  FboFrame := False;
  FLoadHit := False;
  FLight := 1.0;
  FAlpha := 1.0;
end;

destructor TLSAnimPlayer.Destroy;
begin
  ClearTierList();
  FTierList.Free;
  FFilesList.Free;
  FSprite := nil;
  inherited;
end;

function TLSAnimPlayer.ClearTierList: Boolean;
var
  I                         : Integer;
  MapLayer                  : TMapLayer;
begin
  FTierList.Lock;
  try
    for I := 0 to FTierList.Count - 1 do
      TMapLayer(FTierList[I]).Free;
    FTierList.Clear;
  finally
    FTierList.UnLock;
  end;
  for I := 0 to FFilesList.Count - 1 do
    TFilesType(FFilesList[I]).Free;
  FFilesList.Clear;

  FControlCount := 0;
  FControIndex := 0;
  if FResultContro <> nil then
    Dispose(FResultContro);
  FResultContro := nil;
  SetLength(FControlList, 0);
  FCurrentlyControl := nil;
  FboResult := False;
end;

procedure TLSAnimPlayer.DoDraw;
var
  I, II                     : Integer;
  MapLayer                  : TMapLayer;
begin
  if not FIsPlay then Exit;
  FHGE.Gfx_SetClipping(Round(X), Round(Y), Width, Height);
  try
    if FSprite <> nil then
      FSprite.Render(X, Y);
    FTierList.Lock;
    try
      for I := 0 to FTierList.Count - 1 do begin
        MapLayer := TMapLayer(FTierList[I]);
        MapLayer.DoDraw;
      end;
    finally
      FTierList.UnLock;
    end;
  finally
    FHGE.Gfx_SetClipping();
  end;
end;

procedure TLSAnimPlayer.DoMove;
var
  I, II                     : Integer;
  MapLayer                  : TMapLayer;
  PControl                  : PControlInfo;
begin
  if FIsPlay then begin
    if (GetTickCount - FStartTick) > FDTime then begin
      FStartTick := GetTickCount;
      if (FboFrame) then begin
      end else
        if FCurrentlyControl = nil then begin //如果没有要求的话
          if (FResultContro <> nil) and FboResult then begin //先检查是不是要放结束控制
            if FRenderIndex = FResultContro.wE then
              FRenderIndex := FResultContro.wB
            else
              Inc(FRenderIndex);
          end else begin
            if (FControlCount > 0) then begin //如果播放控制表不为空
              if (FControIndex < 0) or (FControIndex >= FControlCount) then
                FControIndex := 0;

              PControl := @FControlList[FControIndex];
              if FRenderIndex >= PControl^.wE then begin
                Inc(FControIndex);
                if FControIndex >= FControlCount then begin
                  FControIndex := 0;
                  if FResultContro <> nil then begin
                    FboResult := True;
                    FRenderIndex := FResultContro.wB;
                  end else begin
                    PControl := @FControlList[FControIndex];
                    FRenderIndex := PControl^.wB;
                  end;
                end else begin
                  PControl := @FControlList[FControIndex];
                  FRenderIndex := PControl^.wB;
                end;
              end else
                Inc(FRenderIndex);
            end else begin              //如果播放控制表为空
              Inc(FRenderIndex);
              if (FRenderIndex >= FMaxIndex) then begin
                if FResultContro <> nil then begin
                  FboResult := True;
                  FRenderIndex := FResultContro.wB;
                end else begin
                  Inc(FUseBout);
                  FRenderIndex := 0;
                end;
              end;
            end;
          end;
        end else begin
          if FRenderIndex >= FCurrentlyControl.wE then begin
            FRenderIndex := FCurrentlyControl.wB;
            Inc(FUseBout);
          end else
            Inc(FRenderIndex);
        end;
    end;

    FTierList.Lock;
    try
      for I := 0 to FTierList.Count - 1 do begin
        MapLayer := TMapLayer(FTierList[I]);
        MapLayer.DoMove(FRenderIndex);
      end;
    finally
      FTierList.UnLock;
    end;
  end;
end;

procedure TLSAnimPlayer.Pause;
begin
  FIsPlay := False;
  FCurrentlyControl := nil;
  FboFrame := False;
end;

procedure TLSAnimPlayer.Play(Bindex: Integer = -1; boFrame: Boolean = False);
var
  I                         : Integer;
  MapLayer                  : TMapLayer;
begin
  FStartTick := GetTickCount;
  FboFrame := False;
  FRenderIndex := 0;
  FControIndex := 0;
  FCurrentlyControl := nil;
  if boFrame then begin
    if (Bindex < 0) then Bindex := 0;
    if (Bindex >= FMaxIndex) then Bindex := FMaxIndex - 1;
    FRenderIndex := Bindex;
    FboFrame := boFrame;
  end else begin
    if (Bindex >= 0) and (Bindex < FControlCount) then begin
      FCurrentlyControl := @FControlList[Bindex];
      FRenderIndex := FCurrentlyControl.wB;
    end;
  end;
  FTierList.Lock;
  try
    for I := 0 to FTierList.Count - 1 do begin
      MapLayer := TMapLayer(FTierList[I]);
      MapLayer.ReinventParticle();
    end;
  finally
    FTierList.UnLock;
  end;
  FIsPlay := True;
  FboResult := False;
end;

procedure TLSAnimPlayer.LoadFromBuffer(Buf: PChar; nSize: Integer);
var
  Header                    : TLSHeader;
  I, II                     : Integer;
  pLSAnim                   : TLSAnim;
  pUpLSAnim                 : TLSAnim;
  nPosition                 : Int64;
  wTemp, wTemp2             : Word;
  MapLayer                  : TMapLayer;
  nAllCount                 : Word;
  SDesc                     : string;
  btType1                   : byte;
  nPos                      : Integer;
  nTmp                      : Integer;
begin
  if nSize = 0 then Exit;
  ClearTierList();
  FControIndex := 0;
  if nSize > SizeOf(TLSHeader) then begin
    Move(Buf[0], Header, SizeOf(TLSHeader));
    nPos := SizeOf(TLSHeader);
    SDesc := StrPas(@Header.SDesc[0]);
    if (Header.Version <> LS_Record_Version) or
      (SDesc <> LS_SDesc) then Exit;
    FDTime := Round(1000 / Header.FPS);
    FHScale := (Width / Header.W);
    FVScale := (Height / Header.H);
    if Header.BackgroundColor.A > 0 then begin
      FSprite := THGESprite.Create(nil, 0, 0, Width, Height);
      FSprite.SetColor(Header.BackgroundColor.GetARGB);
    end;

    for I := 0 to Header.FilesCount - 1 do begin
      FFilesList.Add(TFilesType.Create(@Buf[nPos], nTmp));
      Inc(nPos, nTmp);
    end;

    FControlCount := Header.ControlCount;
    if Header.BoResult then begin
      New(FResultContro);
      Move(Buf[nPos], FResultContro^, SizeOf(TControlInfo));
      Inc(nPos, SizeOf(TControlInfo));
    end;

    SetLength(FControlList, FControlCount);
    for I := 0 to FControlCount - 1 do begin
      Move(Buf[nPos], FControlList[I], SizeOf(TControlInfo));
      Inc(nPos, SizeOf(TControlInfo));
    end;

    FTierList.Lock;
    try
      for I := 0 to Header.AxesCount - 1 do begin
        MapLayer := TMapLayer.Create;
        try
          Move(Buf[nPos], nAllCount, SizeOf(Word));
          Inc(nPos, SizeOf(Word));
          if nAllCount > FMaxIndex then FMaxIndex := nAllCount;
          Move(Buf[nPos], wTemp, SizeOf(Word));
          Inc(nPos, SizeOf(Word));
          pUpLSAnim := nil;
          for II := 0 to wTemp - 1 do begin
            nPosition := nPos;
            Move(Buf[nPos], btType1, SizeOf(byte));
            Inc(nPos, SizeOf(byte));
            case btType1 of
              CURRENTLY_FRAME: begin
                  pLSAnim := TLSAnim_Currently_Frame.Create(Self);
                  nPos := nPosition;
                  TLSAnim_Currently_Frame(pLSAnim).LoadBuffer(@Buf[nPos], nTmp);
                  Inc(nPos, nTmp);
                end;
              CCARTOON_FRAME: begin
                  pLSAnim := TLSAnim_Ccartoon_Frame.Create(Self);
                  nPos := nPosition;
                  TLSAnim_Ccartoon_Frame(pLSAnim).LoadBuffer(@Buf[nPos], nTmp);
                  Inc(nPos, nTmp);
                end;
              $FF: begin
                  pLSAnim := TLSAnim.Create(Self);
                  Move(Buf[nPos], wTemp2, SizeOf(Word));
                  Inc(nPos, SizeOf(Word));
                  pLSAnim.FBeginIndex := wTemp2;
                end;
            else
              Assert(False, 'btType1 不知道的类型');
            end;
            if pLSAnim <> nil then begin
              pLSAnim.FEndIndex := nAllCount - 1;
              MapLayer.Add(pLSAnim);
              if pUpLSAnim <> nil then
                pUpLSAnim.FEndIndex := pLSAnim.FBeginIndex - 1;
              pUpLSAnim := pLSAnim;
            end;
          end;
          FTierList.Add(MapLayer);
        except
          MapLayer.Free;
          Exit;
        end;
      end;

      FLoadHit := True;
    finally
      FTierList.UnLock;
      for I := 0 to FFilesList.Count - 1 do begin
        if FFilesList[I] <> nil then
          TFilesType(FFilesList[I]).Free;
      end;
      FFilesList.Clear;
    end;
  end;
end;

procedure TLSAnimPlayer.LoadStream(Stream: TStream);
var
  Header                    : TLSHeader;
  I, II                     : Integer;
  pLSAnim                   : TLSAnim;
  pUpLSAnim                 : TLSAnim;
  nPosition                 : Int64;
  wTemp, wTemp2             : Word;
  MapLayer                  : TMapLayer;
  nAllCount                 : Word;
  SDesc                     : string;
  btType1                   : byte;
begin
  if Stream = nil then Exit;
  ClearTierList();
  FControIndex := 0;
  //LoadFromBuffer(Stream.);
  Stream.Position := 0;
  if Stream.Size > SizeOf(TLSHeader) then begin
    Stream.Read(Header, SizeOf(TLSHeader)); //读取文件头
    SDesc := StrPas(@Header.SDesc[0]);
    if (Header.Version <> LS_Record_Version) or
      (SDesc <> LS_SDesc) then Exit;
    FDTime := Round(1000 / Header.FPS);
    FHScale := (Width / Header.W);
    FVScale := (Height / Header.H);
    if Header.BackgroundColor.A > 0 then begin
      FSprite := THGESprite.Create(nil, 0, 0, Width, Height);
      FSprite.SetColor(Header.BackgroundColor.GetARGB);
    end;

    for I := 0 to Header.FilesCount - 1 do begin
      FFilesList.Add(TFilesType.Create(Stream));
    end;

    FControlCount := Header.ControlCount;
    if Header.BoResult then begin
      New(FResultContro);
      Stream.Read(FResultContro^, SizeOf(TControlInfo));
    end;

    SetLength(FControlList, FControlCount);
    for I := 0 to FControlCount - 1 do
      Stream.Read(FControlList[I], SizeOf(TControlInfo));

    FTierList.Lock;
    try
      for I := 0 to Header.AxesCount - 1 do begin
        MapLayer := TMapLayer.Create;
        try
          Stream.Read(nAllCount, SizeOf(Word));
          if nAllCount > FMaxIndex then FMaxIndex := nAllCount;
          Stream.Read(wTemp, SizeOf(Word));
          pUpLSAnim := nil;
          for II := 0 to wTemp - 1 do begin
            nPosition := Stream.Position;
            Stream.Read(btType1, SizeOf(byte));
            case btType1 of
              CURRENTLY_FRAME: begin
                  pLSAnim := TLSAnim_Currently_Frame.Create(Self);
                  Stream.Position := nPosition;
                  TLSAnim_Currently_Frame(pLSAnim).LoadStream(Stream);
                end;
              CCARTOON_FRAME: begin
                  pLSAnim := TLSAnim_Ccartoon_Frame.Create(Self);
                  Stream.Position := nPosition;
                  TLSAnim_Ccartoon_Frame(pLSAnim).LoadStream(Stream);
                end;
              $FF: begin
                  pLSAnim := TLSAnim.Create(Self);
                  Stream.Read(wTemp2, SizeOf(Word));
                  pLSAnim.FBeginIndex := wTemp2;
                end;
            else
              Assert(False, 'btType1 不知道的类型');
            end;
            if pLSAnim <> nil then begin
              pLSAnim.FEndIndex := nAllCount - 1;
              MapLayer.Add(pLSAnim);
              if pUpLSAnim <> nil then
                pUpLSAnim.FEndIndex := pLSAnim.FBeginIndex - 1;
              pUpLSAnim := pLSAnim;
            end;
          end;
          FTierList.Add(MapLayer);
        except
          MapLayer.Free;
          Exit;
        end;
      end;

      FLoadHit := True;
    finally
      FTierList.UnLock;
      for I := 0 to FFilesList.Count - 1 do begin
        if FFilesList[I] <> nil then
          TFilesType(FFilesList[I]).Free;
      end;
      FFilesList.Clear;
    end;

  end;

end;

procedure TLSAnimPlayer.SetFileName(const Value: string);
var
  Res                       : IResource;
  nSize                     : Longword;
  Stream                    : TMemoryStreamEx;
begin
  if FFileName <> Value then begin
    FFileName := Value;
    nSize := 0;
    FLoadHit := False;
    Res := FHGE.Resource_Load(FFileName, @nSize);
    if (Res <> nil) and (nSize > 0) then begin
      FSprite := nil;
      FMaxIndex := 0;
      Stream := TMemoryStreamEx.Create(Res);
      try
        Stream.Position := 0;
        LoadStream(Stream);
      finally
        Stream.Free;
        Res := nil;
      end;
    end;
  end;
end;

function TLSAnimPlayer.GetHeight: Integer;
begin
  Result := 0;
  if FParent is TSprite then
    Result := (FParent as TSprite).Height
  else if FParent is THGEControl then
    Result := (FParent as THGEControl).Height;
end;

function TLSAnimPlayer.GetLoadHit: Boolean;
begin
  Result := FLoadHit;
end;

function TLSAnimPlayer.GetWidth: Integer;
begin
  Result := 0;
  if FParent is TSprite then
    Result := (FParent as TSprite).Width
  else if FParent is THGEControl then
    Result := (FParent as THGEControl).Width;
end;

function TLSAnimPlayer.GetX: Integer;
begin
  Result := 0;
  if FParent is TSprite then
    Result := Round((FParent as TSprite).X)
  else if FParent is THGEControl then begin
    Result := (FParent as THGEControl).Left;
    Result := (FParent as THGEControl).SurfaceX(Result);
  end;
end;

function TLSAnimPlayer.GetY: Integer;
begin
  Result := 0;
  if FParent is TSprite then
    Result := Round((FParent as TSprite).Y)
  else if FParent is THGEControl then begin
    Result := (FParent as THGEControl).Top;
    Result := (FParent as THGEControl).SurfaceX(Result);
  end;
end;

procedure TLSAnimPlayer.SetAlpha(Value: byte);
begin
  FAlpha := Value / 255
end;

procedure TLSAnimPlayer.SetLight(Value: byte);
begin
  FLight := Value / 255
end;

end.

