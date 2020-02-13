unit HGECanvas;
(*
** hgeCanvas helper class
** Extension to the HGE engine
** Extension added by DraculaLin
** This extension is NOT part of the original HGE engine.
*)

interface

uses
  Windows,
  SysUtils,
  Math,
  HGEImages,
  HGE;

type

  THGECanvas = class
  private
    FWidth, FHeight: Single;
    FTexWidth, FTexHeight: Integer;
    procedure SetColor(Color: Cardinal); overload;
    procedure SetColor(Color1, Color2, Color3, Color4: Cardinal); overload;
    procedure SetPattern(Texture: ITexture; PatternIndex: Integer);
    procedure SetMirror(MirrorX, MirrorY: Boolean);
  protected
    FQuad: THGEQuad;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Draw(Image: ITexture; PatternIndex: Integer; X, Y: Single; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Draw(X, Y: Single; Image: ITexture; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Draw(X, Y: Single; Image: ITexture; Color: LongWord; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Draw(X, Y, X2, Y2: Single; Image: ITexture; BlendMode: Integer = BLEND_DEFAULT); overload;

    procedure DrawRect(X, Y, X2, Y2: Single; Image: ITexture; Color: LongWord; BlendMode: Integer = BLEND_DEFAULT);

    procedure DrawCol(X, Y: Single; Image: ITexture; Col: LongWord; BlendMode: Integer = BLEND_DEFAULT); overload;

    procedure DrawEx(Image: ITexture; PatternIndex: Integer; X, Y, CenterX, CenterY, ScaleX, ScaleY: Single;
      MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;
    procedure DrawEx(Image: ITexture; PatternIndex: Integer; X, Y, CenterX, CenterY, ScaleX, ScaleY: Single;
      MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer); overload;
    procedure DrawEx(Image: ITexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Color: Cardinal; BlendMode: Integer); overload;
    procedure DrawColor1(Image: ITexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Red, Green, Blue, Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawColor1(Image: ITexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Red, Green, Blue, Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawColor1(Image: ITexture; PatternIndex: Integer; X, Y: Single;
      Red, Green, Blue, Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawAlpha1(Image: ITexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawAlpha1(Image: ITexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawAlpha1(Image: ITexture; PatternIndex: Integer; X, Y: Single;
      Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawColor4(Image: ITexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;
    procedure DrawColor4(Image: ITexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;
    procedure DrawColor4(Image: ITexture; PatternIndex: Integer; X, Y: Single;
      Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;
    procedure DrawAlpha4(Image: ITexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer); overload;
    procedure DrawAlpha4(Image: ITexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer); overload;
    procedure DrawAlpha4(Image: ITexture; PatternIndex: Integer; X, Y: Single;
      Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer); overload;
    procedure Draw4V(Image: ITexture; PatternIndex: Integer; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single;
      MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer); overload;
    procedure Draw4V(Image: ITexture; PatternIndex: Integer; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single;
      MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;
    procedure DrawStretch(Image: ITexture; PatternIndex: Integer; X1, Y1, X2, Y2: Single;
      MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
    procedure DrawPart(Texture: ITexture; X, Y, SrcX, SrcY, Width, Height,
      ScaleX, ScaleY, CenterX, CenterY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer); overload;
    procedure DrawPart(Texture: ITexture; X, Y, SrcX, SrcY, Width, Height,
      ScaleX, ScaleY, CenterX, CenterY: Single; MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;
    procedure DrawPart(Texture: ITexture; X, Y, SrcX, SrcY, Width, Height: Single;
      Color: Cardinal; BlendMode: Integer); overload;
    procedure DrawRotate(Image: ITexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
      Angle, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer); overload;
    procedure DrawRotate(Image: ITexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
      Angle: Real; Color: Cardinal; BlendMode: Integer); overload;
    procedure DrawRotateColor4(Image: ITexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
      Angle, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
    procedure DrawRotateC(Image: ITexture; PatternIndex: Integer; X, Y, Angle,
      ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer); overload;
    procedure DrawRotateC(Image: ITexture; PatternIndex: Integer; X, Y, Angle: Single;
      Color: Cardinal; BlendMode: Integer); overload;
    procedure DrawWaveX(Image: ITexture; X, Y, Width, Height: Integer; Amp, Len,
      Phase: Integer; Color: Cardinal; BlendMode: Integer);
    procedure DrawWaveY(Image: ITexture; X, Y, Width, Height: Integer; Amp, Len,
      Phase: Integer; Color: Cardinal; BlendMode: Integer);
  end;

implementation

uses
  Share;

var
  FHGE                      : IHGE = nil;

constructor THGECanvas.Create;
begin
  FHGE := HGECreate(HGE_VERSION);
end;

destructor THGECanvas.Destroy;
begin
  FQuad.Tex := nil;
  inherited;
end;

procedure THGECanvas.SetColor(Color: Cardinal);
begin
  FQuad.V[0].Col := Color;
  FQuad.V[1].Col := Color;
  FQuad.V[2].Col := Color;
  FQuad.V[3].Col := Color;
end;

procedure THGECanvas.SetColor(Color1: Cardinal; Color2: Cardinal; Color3: Cardinal; Color4: Cardinal);
begin
  FQuad.V[0].Col := Color1;
  FQuad.V[1].Col := Color2;
  FQuad.V[2].Col := Color3;
  FQuad.V[3].Col := Color4;
end;

procedure THGECanvas.SetPattern(Texture: ITexture; PatternIndex: Integer);
var
  TexX1, TexY1, TexX2, TexY2: Single;
  Left, Right, Top, Bottom  : Integer;
  PHeight, PWidth, RowCount, ColCount: Integer;
begin
  if Assigned(Texture) then begin
    FTexWidth := FHGE.Texture_GetWidth(Texture); //true???  1111
    if FTexWidth = 0 then FTexWidth := FHGE.Texture_GetWidth(Texture, True);
    FTexHeight := FHGE.Texture_GetHeight(Texture);
    if FTexHeight = 0 then FTexWidth := FHGE.Texture_GetHeight(Texture, True);

    if Texture.PatternWidth = 0 then Texture.PatternWidth := FTexWidth;
    PWidth := Texture.PatternWidth;
    if Texture.PatternHeight = 0 then Texture.PatternHeight := FTexHeight;
    PHeight := Texture.PatternHeight;

    ColCount := Texture.GetWidth(True) div PWidth;
    RowCount := Texture.GetHeight(True) div PHeight;
  end else begin
    FTexWidth := 1;
    FTexHeight := 1;
    PHeight := FTexWidth;
    PWidth := FTexHeight;
    ColCount := 1;
    RowCount := 1;
  end;
  FQuad.Tex := Texture;

  if PatternIndex < 0 then
    PatternIndex := 0;
  if PatternIndex >= RowCount * ColCount then
    PatternIndex := RowCount * ColCount - 1;

  if ColCount = 0 then begin
    Left := 0;
    Right := Left + PWidth;
    Top := 0;
    Bottom := Top + PHeight;
  end else begin
    Left := (PatternIndex mod ColCount) * PWidth;
    Right := Left + PWidth;
    Top := (PatternIndex div ColCount) * PHeight;
    Bottom := Top + PHeight;
  end;

  FWidth := Right - Left;
  FHeight := Bottom - Top;

  TexX1 := Left / FTexWidth;
  TexY1 := Top / FTexHeight;
  TexX2 := (Left + FWidth) / FTexWidth;
  TexY2 := (Top + FHeight) / FTexHeight;

  FQuad.V[0].TX := TexX1;
  FQuad.V[0].TY := TexY1;
  FQuad.V[1].TX := TexX2;
  FQuad.V[1].TY := TexY1;
  FQuad.V[2].TX := TexX2;
  FQuad.V[2].TY := TexY2;
  FQuad.V[3].TX := TexX1;
  FQuad.V[3].TY := TexY2;
end;

procedure THGECanvas.SetMirror(MirrorX, MirrorY: Boolean);
var
  TX, TY                    : Single;
begin
  if (MirrorX) then begin
    TX := FQuad.V[0].TX;
    FQuad.V[0].TX := FQuad.V[1].TX;
    FQuad.V[1].TX := TX;
    TY := FQuad.V[0].TY;
    FQuad.V[0].TY := FQuad.V[1].TY;
    FQuad.V[1].TY := TY;
    TX := FQuad.V[3].TX;
    FQuad.V[3].TX := FQuad.V[2].TX;
    FQuad.V[2].TX := TX;
    TY := FQuad.V[3].TY;
    FQuad.V[3].TY := FQuad.V[2].TY;
    FQuad.V[2].TY := TY;
  end;

  if (MirrorY) then begin
    TX := FQuad.V[0].TX;
    FQuad.V[0].TX := FQuad.V[3].TX;
    FQuad.V[3].TX := TX;
    TY := FQuad.V[0].TY;
    FQuad.V[0].TY := FQuad.V[3].TY;
    FQuad.V[3].TY := TY;
    TX := FQuad.V[1].TX;
    FQuad.V[1].TX := FQuad.V[2].TX;
    FQuad.V[2].TX := TX;
    TY := FQuad.V[1].TY;
    FQuad.V[1].TY := FQuad.V[2].TY;
    FQuad.V[2].TY := TY;
  end;
end;

procedure THGECanvas.Draw(X, Y: Single; Image: ITexture; BlendMode: Integer);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  SetPattern(Image, 0);
  SetColor($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF);
  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + FWidth;
  TempY2 := Y + FHeight;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.Draw(X, Y, X2, Y2: Single; Image: ITexture; BlendMode: Integer);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  SetPattern(Image, 0);
  SetColor($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF);
  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + {FWidth +} X2;
  TempY2 := Y + FHeight;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.Draw(X, Y: Single; Image: ITexture; Color: LongWord; BlendMode: Integer = BLEND_DEFAULT);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  SetPattern(Image, 0);
  SetColor(Color, Color, Color, Color);
  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + FWidth;
  TempY2 := Y + FHeight;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawRect(X, Y, X2, Y2: Single; Image: ITexture; Color: LongWord; BlendMode: Integer = BLEND_DEFAULT);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  SetPattern(Image, 0);
  SetColor(Color, Color, Color, Color);
  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + X2;
  TempY2 := Y + Y2;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.Draw(Image: ITexture; PatternIndex: Integer; X, Y: Single; BlendMode: Integer);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  SetPattern(Image, PatternIndex);
  SetColor($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF);
  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + FWidth;
  TempY2 := Y + FHeight;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawCol(X, Y: Single; Image: ITexture; Col: LongWord; BlendMode: Integer);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  SetPattern(Image, 0);

  SetColor(Col, Col, Col, Col);

  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + FWidth;
  TempY2 := Y + FHeight;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawEx(Image: ITexture; PatternIndex: Integer; X, Y, CenterX, CenterY, ScaleX, ScaleY: Single;
  MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
var
  TempX1, TempY1, TempX2, TempY2: Single;

begin
  SetPattern(Image, PatternIndex);
  SetColor(Color1, Color2, Color3, Color4);
  TempX1 := X - CenterX * ScaleX;
  TempY1 := Y - CenterY * ScaleY;
  TempX2 := (X + FWidth * ScaleX) - CenterX * ScaleX;
  TempY2 := (Y + FHeight * ScaleY) - CenterY * ScaleY;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;
  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawEx(Image: ITexture; PatternIndex: Integer; X, Y, CenterX, CenterY, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  SetPattern(Image, PatternIndex);
  SetColor(Color);
  TempX1 := X - CenterX * ScaleX;
  TempY1 := Y - CenterY * ScaleY;
  TempX2 := (X + FWidth * ScaleX) - CenterX * ScaleX;
  TempY2 := (Y + FHeight * ScaleY) - CenterY * ScaleY;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;

  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawEx(Image: ITexture; PatternIndex: Integer; X: Single; Y: Single; Scale: Single; DoCenter: Boolean; Color: Cardinal; BlendMode: Integer);
var
  CenterPosX, CenterPosY    : Single;
begin
  if DoCenter then begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, Scale, Scale,
    False, False, Color, BlendMode);
end;

procedure THGECanvas.DrawColor1(Image: ITexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
  DoCenter, MirrorX, MirrorY: Boolean; Red, Green, Blue, Alpha: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY    : Single;
begin
  if DoCenter then begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, ScaleX, ScaleY,
    MirrorX, MirrorY, ARGB(Alpha, Red, Green, Blue), BlendMode);
end;

procedure THGECanvas.DrawColor1(Image: ITexture; PatternIndex: Integer; X, Y, Scale: Single;
  DoCenter: Boolean; Red, Green, Blue, Alpha: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY    : Single;
begin
  if DoCenter then begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, Scale, Scale,
    False, False, ARGB(Alpha, Red, Green, Blue), BlendMode);
end;

procedure THGECanvas.DrawColor1(Image: ITexture; PatternIndex: Integer; X, Y: Single;
  Red, Green, Blue, Alpha: Byte; BlendMode: Integer);
begin
  DrawEx(Image, PatternIndex, X, Y, 0, 0, 1, 1,
    False, False, ARGB(Alpha, Red, Green, Blue), BlendMode);
end;

procedure THGECanvas.DrawAlpha1(Image: ITexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
  DoCenter, MirrorX, MirrorY: Boolean; Alpha: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY    : Single;
begin
  if DoCenter then begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, ScaleX, ScaleY,
    MirrorX, MirrorY, ARGB(Alpha, 255, 255, 255), BlendMode);
end;

procedure THGECanvas.DrawAlpha1(Image: ITexture; PatternIndex: Integer; X, Y, Scale: Single;
  DoCenter: Boolean; Alpha: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY    : Single;
begin
  if DoCenter then begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;

  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, Scale, Scale,
    False, False, ARGB(Alpha, 255, 255, 255), BlendMode);
end;

procedure THGECanvas.DrawAlpha1(Image: ITexture; PatternIndex: Integer; X, Y: Single;
  Alpha: Byte; BlendMode: Integer);
begin
  DrawEx(Image, PatternIndex, X, Y, 0, 0, 1, 1,
    False, False, ARGB(Alpha, 255, 255, 255), BlendMode);
end;

procedure THGECanvas.DrawColor4(Image: ITexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
  DoCenter, MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
var
  CenterPosX, CenterPosY    : Single;
begin
  if DoCenter then begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, ScaleX, ScaleY,
    MirrorX, MirrorY, Color1, Color2, Color3, Color4, BlendMode);
end;

procedure THGECanvas.DrawColor4(Image: ITexture; PatternIndex: Integer; X, Y, Scale: Single;
  DoCenter: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
var
  CenterPosX, CenterPosY    : Single;
begin
  if DoCenter then begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, Scale, Scale,
    False, False, Color1, Color2, Color3, Color4, BlendMode);
end;

procedure THGECanvas.DrawColor4(Image: ITexture; PatternIndex: Integer; X, Y: Single;
  Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
begin
  DrawEx(Image, PatternIndex, X, Y, 0, 0, 1, 1,
    False, False, Color1, Color2, Color3, Color4, BlendMode);
end;

procedure THGECanvas.DrawAlpha4(Image: ITexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
  DoCenter, MirrorX, MirrorY: Boolean; Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY    : Single;
begin
  if DoCenter then begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, ScaleX, ScaleY,
    MirrorX, MirrorY,
    ARGB(Alpha1, 255, 255, 255), ARGB(Alpha2, 255, 255, 255), ARGB(Alpha3, 255, 255, 255), ARGB(Alpha4, 255, 255, 255), BlendMode);
end;

procedure THGECanvas.DrawAlpha4(Image: ITexture; PatternIndex: Integer; X, Y, Scale: Single;
  DoCenter: Boolean; Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY    : Single;
begin
  if DoCenter then begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, Scale, Scale,
    False, False,
    ARGB(Alpha1, 255, 255, 255), ARGB(Alpha2, 255, 255, 255), ARGB(Alpha3, 255, 255, 255), ARGB(Alpha4, 255, 255, 255), BlendMode);
end;

procedure THGECanvas.DrawAlpha4(Image: ITexture; PatternIndex: Integer; X, Y: Single;
  Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer);
begin
  DrawEx(Image, PatternIndex, X, Y, 0, 0, 1, 1,
    False, False,
    ARGB(Alpha1, 255, 255, 255), ARGB(Alpha2, 255, 255, 255), ARGB(Alpha3, 255, 255, 255), ARGB(Alpha4, 255, 255, 255), BlendMode);
end;

procedure THGECanvas.Draw4V(Image: ITexture; PatternIndex: Integer; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single;
  MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
begin
  SetPattern(Image, PatternIndex);
  SetColor(Color);
  FQuad.V[0].X := X1;
  FQuad.V[0].Y := Y1;
  FQuad.V[1].X := X2;
  FQuad.V[1].Y := Y2;
  FQuad.V[2].X := X3;
  FQuad.V[2].Y := Y3;
  FQuad.V[3].X := X4;
  FQuad.V[3].Y := Y4;
  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.Draw4V(Image: ITexture; PatternIndex: Integer; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single;
  MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
begin
  SetPattern(Image, PatternIndex);
  SetColor(Color1, Color2, Color3, Color4);
  FQuad.V[0].X := X1;
  FQuad.V[0].Y := Y1;
  FQuad.V[1].X := X2;
  FQuad.V[1].Y := Y2;
  FQuad.V[2].X := X3;
  FQuad.V[2].Y := Y3;
  FQuad.V[3].X := X4;
  FQuad.V[3].Y := Y4;
  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawStretch(Image: ITexture; PatternIndex: Integer; X1, Y1, X2, Y2: Single;
  MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
begin
  SetPattern(Image, PatternIndex);
  SetColor(Color);
  FQuad.V[0].X := X1;
  FQuad.V[0].Y := Y1;
  FQuad.V[1].X := X2;
  FQuad.V[1].Y := Y1;
  FQuad.V[2].X := X2;
  FQuad.V[2].Y := Y2;
  FQuad.V[3].X := X1;
  FQuad.V[3].Y := Y2;
  SetMirror(MirrorX, MirrorY);
  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawPart(Texture: ITexture; X, Y, SrcX, SrcY, Width, Height,
  ScaleX, ScaleY, CenterX, CenterY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
var
  TexX1, TexY1, TexX2, TexY2: Single;
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  // FTX := SrcX;
  // FTY := SrcY;
  FWidth := Width;
  FHeight := Height;

  if Assigned(Texture) then begin
    FTexWidth := FHGE.Texture_GetWidth(Texture);
    if FTexWidth = 0 then FTexWidth := FHGE.Texture_GetWidth(Texture, True);
    FTexHeight := FHGE.Texture_GetHeight(Texture);
    if FTexHeight = 0 then FTexHeight := FHGE.Texture_GetHeight(Texture, True);
  end else begin
    FTexWidth := 1;
    FTexHeight := 1;
  end;

  FQuad.Tex := Texture;

  TexX1 := SrcX / FTexWidth;
  TexY1 := SrcY / FTexHeight;
  TexX2 := (SrcX + Width) / FTexWidth;
  TexY2 := (SrcY + Height) / FTexHeight;

  FQuad.V[0].TX := TexX1;
  FQuad.V[0].TY := TexY1;
  FQuad.V[1].TX := TexX2;
  FQuad.V[1].TY := TexY1;
  FQuad.V[2].TX := TexX2;
  FQuad.V[2].TY := TexY2;
  FQuad.V[3].TX := TexX1;
  FQuad.V[3].TY := TexY2;

  FQuad.V[0].Z := 0.5;
  FQuad.V[1].Z := 0.5;
  FQuad.V[2].Z := 0.5;
  FQuad.V[3].Z := 0.5;
  SetColor(Color);
  TempX1 := X - CenterX * ScaleX;
  TempY1 := Y - CenterY * ScaleY;
  TempX2 := (X + FWidth * ScaleX) - CenterX * ScaleX;
  TempY2 := (Y + FHeight * ScaleY) - CenterY * ScaleY;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;
  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawPart(Texture: ITexture; X, Y, SrcX, SrcY, Width, Height,
  ScaleX, ScaleY, CenterX, CenterY: Single; MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
var
  TexX1, TexY1, TexX2, TexY2: Single;
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  // FTX := SrcX;
  // FTY := SrcY;
  FWidth := Width;
  FHeight := Height;

  if Assigned(Texture) then begin
    FTexWidth := FHGE.Texture_GetWidth(Texture);
    if FTexWidth = 0 then FTexWidth := FHGE.Texture_GetWidth(Texture, True);
    FTexHeight := FHGE.Texture_GetHeight(Texture);
    if FTexHeight = 0 then FTexHeight := FHGE.Texture_GetHeight(Texture, True);
  end else begin
    FTexWidth := 1;
    FTexHeight := 1;
  end;

  FQuad.Tex := Texture;

  TexX1 := SrcX / FTexWidth;
  TexY1 := SrcY / FTexHeight;
  TexX2 := (SrcX + Width) / FTexWidth;
  TexY2 := (SrcY + Height) / FTexHeight;

  FQuad.V[0].TX := TexX1;
  FQuad.V[0].TY := TexY1;
  FQuad.V[1].TX := TexX2;
  FQuad.V[1].TY := TexY1;
  FQuad.V[2].TX := TexX2;
  FQuad.V[2].TY := TexY2;
  FQuad.V[3].TX := TexX1;
  FQuad.V[3].TY := TexY2;

  FQuad.V[0].Z := 0.5;
  FQuad.V[1].Z := 0.5;
  FQuad.V[2].Z := 0.5;
  FQuad.V[3].Z := 0.5;
  SetColor(Color1, Color2, Color3, Color4);
  TempX1 := X - CenterX * ScaleX;
  TempY1 := Y - CenterY * ScaleY;
  TempX2 := (X + FWidth * ScaleX) - CenterX * ScaleX;
  TempY2 := (Y + FHeight * ScaleY) - CenterY * ScaleY;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;
  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawPart(Texture: ITexture; X, Y, SrcX, SrcY, Width, Height: Single;
  Color: Cardinal; BlendMode: Integer);
begin
  DrawPart(Texture, X, Y, SrcX, SrcY, Width, Height, 1, 1, 0, 0, False, False, Color, BlendMode);
end;

procedure THGECanvas.DrawRotate(Image: ITexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
  Angle, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;
begin
  // if (VScale=0) then
    // VScale := HScale;
  SetPattern(Image, PatternIndex);
  SetColor(Color);
  TX1 := -CenterX * ScaleX;
  TY1 := -CenterY * ScaleY;
  TX2 := (FWidth - CenterX) * ScaleX;
  TY2 := (FHeight - CenterY) * ScaleY;

  if (Angle <> 0.0) then begin
    CosT := Cos(Angle);
    SinT := Sin(Angle);

    FQuad.V[0].X := TX1 * CosT - TY1 * SinT + X;
    FQuad.V[0].Y := TX1 * SinT + TY1 * CosT + Y;

    FQuad.V[1].X := TX2 * CosT - TY1 * SinT + X;
    FQuad.V[1].Y := TX2 * SinT + TY1 * CosT + Y;

    FQuad.V[2].X := TX2 * CosT - TY2 * SinT + X;
    FQuad.V[2].Y := TX2 * SinT + TY2 * CosT + Y;

    FQuad.V[3].X := TX1 * CosT - TY2 * SinT + X;
    FQuad.V[3].Y := TX1 * SinT + TY2 * CosT + Y;
  end else begin
    FQuad.V[0].X := TX1 + X;
    FQuad.V[0].Y := TY1 + Y;
    FQuad.V[1].X := TX2 + X;
    FQuad.V[1].Y := TY1 + Y;
    FQuad.V[2].X := TX2 + X;
    FQuad.V[2].Y := TY2 + Y;
    FQuad.V[3].X := TX1 + X;
    FQuad.V[3].Y := TY2 + Y;
  end;
  SetMirror(MirrorX, MirrorY);
  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawRotate(Image: ITexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
  Angle: Real; Color: Cardinal; BlendMode: Integer);
begin
  DrawRotate(Image, PatternIndex, X, Y, CenterX, CenterY, Angle, 1, 1, False, False, Color, BlendMode);
end;

procedure THGECanvas.DrawRotateColor4(Image: ITexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
  Angle, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;
begin
  // if (VScale=0) then
    // VScale := HScale;
  SetPattern(Image, PatternIndex);
  SetColor(Color1, Color2, Color3, Color4);
  TX1 := -CenterX * ScaleX;
  TY1 := -CenterY * ScaleY;
  TX2 := (FWidth - CenterX) * ScaleX;
  TY2 := (FHeight - CenterY) * ScaleY;

  if (Angle <> 0.0) then begin
    CosT := Cos(Angle);
    SinT := Sin(Angle);

    FQuad.V[0].X := TX1 * CosT - TY1 * SinT + X;
    FQuad.V[0].Y := TX1 * SinT + TY1 * CosT + Y;

    FQuad.V[1].X := TX2 * CosT - TY1 * SinT + X;
    FQuad.V[1].Y := TX2 * SinT + TY1 * CosT + Y;

    FQuad.V[2].X := TX2 * CosT - TY2 * SinT + X;
    FQuad.V[2].Y := TX2 * SinT + TY2 * CosT + Y;

    FQuad.V[3].X := TX1 * CosT - TY2 * SinT + X;
    FQuad.V[3].Y := TX1 * SinT + TY2 * CosT + Y;
  end else begin
    FQuad.V[0].X := TX1 + X;
    FQuad.V[0].Y := TY1 + Y;
    FQuad.V[1].X := TX2 + X;
    FQuad.V[1].Y := TY1 + Y;
    FQuad.V[2].X := TX2 + X;
    FQuad.V[2].Y := TY2 + Y;
    FQuad.V[3].X := TX1 + X;
    FQuad.V[3].Y := TY2 + Y;
  end;
  SetMirror(MirrorX, MirrorY);
  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);

end;

procedure THGECanvas.DrawRotateC(Image: ITexture; PatternIndex: Integer; X, Y, Angle,
  ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
begin
  DrawRotate(Image, PatternIndex, X, Y, Image.PatternWidth div 2, Image.PatternHeight div 2,
    Angle, ScaleX, ScaleY, MirrorX, MirrorY, Color, BlendMode);
end;

procedure THGECanvas.DrawRotateC(Image: ITexture; PatternIndex: Integer; X, Y, Angle: Single;
  Color: Cardinal; BlendMode: Integer);
begin
  DrawRotate(Image, PatternIndex, X, Y, Image.PatternWidth div 2, Image.PatternHeight div 2,
    Angle, 1, 1, False, False, Color, BlendMode);
end;

procedure THGECanvas.DrawWaveX(Image: ITexture; X, Y, Width, Height: Integer; Amp, Len,
  Phase: Integer; Color: Cardinal; BlendMode: Integer);
var
  i, J                      : Integer;
begin
  for J := 0 to Width do begin
    i := Trunc(J * Image.PatternWidth / Width);
    DrawPart(Image, X + J, Y + Amp * Sin((Phase + J) * PI * Width / Len / 256),
      i, 0, 1, Height, Color, BlendMode);
  end;
end;

procedure THGECanvas.DrawWaveY(Image: ITexture; X, Y, Width, Height: Integer; Amp, Len,
  Phase: Integer; Color: Cardinal; BlendMode: Integer);
var
  i, J                      : Integer;
begin
  for J := 0 to Height do begin
    i := Trunc(J * Image.PatternHeight / Height);
    DrawPart(Image, X + Amp * Sin((Phase + J) * PI * Height / Len / 256), Y + J,
      0, i, Width, 1, Color, BlendMode);
  end;
end;

initialization
  FHGE := nil;

end.

