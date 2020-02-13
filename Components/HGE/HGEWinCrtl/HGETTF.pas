unit HGETTF;

interface
uses
  Windows, Classes, SysUtils, HGE, HGESprite, HGEFont, TTFFontApi;

const
  TabSize                   : Integer = 4;
  font_count                = $FFFF;    // = sizeof(wchar_t);

type
  uint32_t = UINT;
  int32_t = Integer;

type
  TexturePtr = array[0..0] of Longword;
  PTexturePtr = ^TexturePtr;

  TCacheEntry = record
    charCode: WCHAR;
    glyphIndex: uint32_t;
    Advance: uint32_t;
    Width: uint32_t;
    Height: uint32_t;
    glyphWidth: uint32_t;
    glyphHeight: uint32_t;
    Left: uint32_t;
    Top: uint32_t;
    Texture: ITexture;
    textureWidth: uint32_t;
    textureHeight: uint32_t;
  end;
  PTCacheEntry = ^TCacheEntry;

  TTFFont = class
    mLibrary: Pointer;
    mFilename: string;
    mFace: C_Face;
    mWidth: uint32_t;
    mHeight: uint32_t;
    mAutoCache: Boolean;
    mHaveKerning: Boolean;
    mUseKerning: Boolean;
    mSprite: IHGESprite;
    mHotSpotX: Single;
    mHotSpotY: Single;
    mXScale: Single;
    mYScale: Single;
    mRotation: Single;
    mLastSetWidth: uint32_t;
    mLastSetHeight: uint32_t;
    mCache: array[0..font_count] of PTCacheEntry;
  private
  class var
      mHGE                  : IHGE;
      public
  constructor Create(pLibrary: Pointer); virtual;
destructor Destroy; override;

function Load(const sFilename: string): Boolean;
procedure Unload();

function getFilename(): string;

function cacheChar(charCode: WCHAR): Boolean;
function cacheChars(const s: string): Boolean; overload;
function cacheChars(startCode, endCode: WCHAR): Boolean; overload;
function isCharCached(charCode: WCHAR): Boolean;
procedure clearCache();

function DrawChar(charCode: WCHAR; x, y: Single): Boolean;
function DrawString(const s: string; x, y: Single): Boolean;
function Printf(x, y: Single; format: string; const Args: array of const): Boolean;

function getCharWidth(charCode: WCHAR): Single;
function getCharHeight(charCode: WCHAR): Single;
function getStringWidth(const s: string): Single;
function getStringHeight(const s: string): Single;

procedure setColor(Color: uint32_t; i: Integer = -1);
procedure setBlendMode(Mode: Integer);
procedure setHotSpot(relX, relY: Single);
procedure setXScale(Scale: Single);
procedure setYScale(Scale: Single);
procedure setScale(Scale: Single);
procedure setRotation(Rotation: Single);

procedure setWidth(Width: uint32_t);
procedure setHeight(Height: uint32_t);
procedure setSize(Size: uint32_t);

function getColor(i: Integer = -1): uint32_t;
function getBlendMode(): Integer;
procedure getHotSpot(var hotX, hotY: Single);
function getRotation(): Single;

procedure autoCache(autoCache: Boolean); overload;
function autoCache(): Boolean; overload;

procedure useKerning(Kerning: Boolean);
function usingKerning(): Boolean;
function hasKerning(): Boolean;
function getCacheEntry(charCode: WCHAR): PTCacheEntry;
function setupSize: Boolean;

procedure renderGlyph(Glyph: FT_Bitmap; var Texture: ITexture; var textureWidth, textureHeight: uint32_t);
function spaceAdvance(): uint32_t;
    end;

implementation

constructor TTFFont.Create(pLibrary: Pointer);
var
  i                         : Integer;
begin
  inherited Create();
  mHGE := hgeCreate(HGE_VERSION);
  mLibrary := pLibrary;
  mFace.Face := nil;
  mFace.charmap := nil;
  mFace.bitmap := nil;
  mWidth := (32);
  mHeight := (32);
  mAutoCache := (true);
  mHaveKerning := (false);
  mUseKerning := (true);
  mSprite := THGESprite.Create(nil, 0.0, 0.0, 0.0, 0.0);
  mHotSpotX := (0.5);
  mHotSpotY := (0.5);
  mXScale := (1.0);
  mYScale := (1.0);
  mRotation := (0.0);
  mLastSetWidth := (0);
  mLastSetHeight := (0);

  for i := 0 to font_count do
    mCache[i] := nil;

end;

destructor TTFFont.Destroy;
begin
  Unload();
  inherited;
end;

function TTFFont.Load(const sFilename: string): Boolean;
begin
  if C_FT_New_Face(mLibrary, PChar(sFilename), 0, mFace) <> 0 then begin
    Result := false;
    Exit;
  end;

  //We only support scalable Unicode fonts
  if (mFace.bitmap = nil) or not (C_FT_IS_SCALABLE(mFace) <> 0) then begin
    C_FT_Done_Face(mFace);
    Result := false;
    Exit;
  end;
  mFilename := sFilename;
  if (C_FT_HAS_KERNING(mFace) = 0) then
    mHaveKerning := true;

  Result := true;
end;

procedure TTFFont.Unload;
begin
  mFilename := '';
  clearCache();
  mSprite := nil;
  mHGE := nil;
  if mFace.Face <> nil then begin
    C_FT_Done_Face(mFace);
    mFace.Face := nil;
    mFace.charmap := nil;
  end;
end;

function TTFFont.cacheChar(charCode: WCHAR): Boolean;
var
  Entry                     : PTCacheEntry;
begin
  if (isCharCached(charCode)) then begin
    Result := true;
    Exit;
  end;

  if (Word(charCode) = 0) then begin
    Result := false;
    Exit;
  end;

  if (not setupSize()) then begin
    Result := false;
    Exit;
  end;

  New(Entry);
  Entry.charCode := charCode;
  Entry.glyphIndex := C_FT_Get_Char_Index(mFace, Word(charCode));
  if (Entry.glyphIndex = 0) then begin
    Dispatch(Entry);
    Result := false;
    Exit;
  end;

  if (C_FT_Load_Glyph(mFace, Entry.glyphIndex, FT_LOAD_RENDER) <> 0) then begin
    Dispatch(Entry);
    Result := false;
    Exit;
  end;
  Entry.Width := mWidth;
  Entry.Height := mHeight;
  Entry.glyphWidth := mFace.bitmap.Width;
  Entry.glyphHeight := mFace.bitmap.rows;
  renderGlyph(mFace.bitmap^, Entry.Texture, Entry.textureWidth, Entry.textureHeight);
  Entry.Left := mFace.bitmap_left;
  Entry.Top := mFace.bitmap_top;
  Entry.Advance := mFace.Advance.x div 64;
  mCache[Word(charCode)] := Entry;
  Result := true;
end;

function TTFFont.cacheChars(const s: string): Boolean;
var
  Ret                       : Boolean;
  P                         : PWideChar;
  i                         : Integer;
begin
  Ret := true;
  GetMem(P, Length(s) * SizeOf(WideChar) + 1);
  try
    StringToWideChar(s, P, Length(s) * SizeOf(WideChar) + 1);
    i := 0;
    while (P[i] <> #0) do begin
      if (not cacheChar(P[i])) then
        Ret := false;
      Inc(i);
    end;
  finally
    FreeMem(P);
    Result := Ret;
  end;
end;

function TTFFont.cacheChars(startCode, endCode: WCHAR): Boolean;
var
  Ret                       : Boolean;
  i                         : WCHAR;
begin
  Ret := true;
  for i := startCode to endCode do begin
    if (not cacheChar(i)) then
      Ret := false;
  end;
  Result := Ret;
end;

procedure TTFFont.clearCache;
var
  i                         : Integer;
begin
  for i := 0 to font_count do begin
    if mCache[i] <> nil then begin
      mCache[i].Texture := nil;
      Dispatch(mCache[i]);
      mCache[i] := nil;
    end;
  end;
end;

function TTFFont.DrawChar(charCode: WCHAR; x, y: Single): Boolean;
var
  theGlyph                  : PTCacheEntry;
begin
  if (mAutoCache) then
    cacheChar(charCode);

  theGlyph := getCacheEntry(charCode);
  if (nil = theGlyph) or (nil = theGlyph.Texture) then begin
    Result := false;
    Exit;
  end;

  x := x + theGlyph.Left;
  y := y - theGlyph.Top;

  mSprite.SetTexture(theGlyph.Texture);
  mSprite.SetTextureRect(0.0, 0.0, theGlyph.textureWidth, theGlyph.textureHeight);

  x := x + mHotSpotX * theGlyph.glyphWidth;
  y := y + mHotSpotY * theGlyph.glyphHeight;

  mSprite.setHotSpot(mHotSpotX * theGlyph.glyphWidth, mHotSpotY * theGlyph.glyphHeight);
  mSprite.RenderEx(x, y, mRotation, mXScale, mYScale);
  mSprite.setHotSpot(0.0, 0.0);
  Result := true;
end;

function TTFFont.DrawString(const s: string; x, y: Single): Boolean;
var
  Ret                       : Boolean;
  penX                      : Single;
  penY                      : Single;
  previousGlyph             : uint32_t;
  Delta                     : FT_Vector;
  theGlyph                  : PTCacheEntry;
  P                         : PWideChar;
  i                         : Integer;
begin
  Ret := true;
  penX := x;
  penY := y;
  previousGlyph := 0;
  theGlyph := nil;

  GetMem(P, Length(s) * SizeOf(WideChar) + 1);
  try
    StringToWideChar(s, P, Length(s) * SizeOf(WideChar) + 1);
    i := 0;
    while (P[i] <> #0) do begin
      if (mAutoCache) then
        cacheChar(P[i]);
      //Special cases
      case Word(P[i]) of
        9: begin
            penX := penX + spaceAdvance() * TabSize;
            previousGlyph := 0;
            continue;
          end;
        11: begin
            penY := penY + mHeight * TabSize;
            previousGlyph := 0;
            continue;
          end;
        10: begin
            penY := penY + mHeight;
            penX := x;
            previousGlyph := 0;
            continue;
          end;
      end;

      theGlyph := getCacheEntry(P[i]);
      if (theGlyph = nil) then begin
        Ret := false;
        previousGlyph := 0;
        continue;
      end;
      //Kerning
      if (previousGlyph <> 0) and mHaveKerning and mUseKerning then begin
        C_FT_Get_Kerning(mFace, previousGlyph, theGlyph.glyphIndex, FT_KERNING_DEFAULT, Delta);
        penX := penX + Delta.x shl 6;
        penY := penY + Delta.y shl 6;
      end;
      if (not DrawChar(P[i], penX, penY)) then
        Ret := false;

      penX := penX + theGlyph.Advance;
      previousGlyph := theGlyph.glyphIndex;
      Inc(i);
    end;
  finally
    FreeMem(P);
    Result := Ret;
  end;
end;

function TTFFont.Printf(x, y: Single; format: string; const Args: array of const): Boolean;
begin
  Result := DrawString(SysUtils.format(format, Args), x, y);
end;

function TTFFont.getCharWidth(charCode: WCHAR): Single;
var
  theGlyph                  : PTCacheEntry;
begin
  theGlyph := getCacheEntry(charCode);
  if (theGlyph = nil) then begin
    Result := 0;
    Exit;
  end;
  Result := theGlyph.glyphWidth;
end;

function TTFFont.getCharHeight(charCode: WCHAR): Single;
var
  theGlyph                  : PTCacheEntry;
begin
  theGlyph := getCacheEntry(charCode);
  if (theGlyph = nil) then begin
    Result := 0;
    Exit;
  end;
  Result := theGlyph.glyphHeight;
end;

function TTFFont.getStringWidth(const s: string): Single;
var
  theGlyph                  : PTCacheEntry;
  previousGlyph             : uint32_t;
  Width                     : Single;
  Delta                     : FT_Vector;
  P                         : PWideChar;
  i                         : Integer;
begin
  theGlyph := nil;
  previousGlyph := 0;
  Width := 0.0;
  //Note that we don't count the last char's advance

  GetMem(P, Length(s) * SizeOf(WideChar) + 1);
  try
    StringToWideChar(s, P, Length(s) * SizeOf(WideChar) + 1);
    i := 0;
    while (P[i] <> #0) do begin
      if (mAutoCache) then
        cacheChar(P[i]);
      //Special cases
      case Word(P[i]) of
        9: begin
            Width := Width + spaceAdvance() * TabSize;
            previousGlyph := 0;
            continue;
          end;
        11: begin
            previousGlyph := 0;
            continue;
          end;
        10: begin
            previousGlyph := 0;
            continue;
          end;
      end;
      theGlyph := getCacheEntry(P[i]);
      if (theGlyph = nil) then begin
        previousGlyph := 0;
        continue;
      end;
      //Kerning
      if (previousGlyph <> 0) and mHaveKerning and mUseKerning then begin
        C_FT_Get_Kerning(mFace, previousGlyph, theGlyph.glyphIndex, FT_KERNING_DEFAULT, Delta);
        Width := Width + Delta.x shr 6;
      end;
      if P[i + 1] = #0 then
        Width := Width + theGlyph.glyphWidth
      else
        Width := Width + theGlyph.Advance;

      previousGlyph := theGlyph.glyphIndex;
      Inc(i);
    end;
  finally
    FreeMem(P);
    Result := Width;
  end;
end;

function TTFFont.getStringHeight(const s: string): Single;
var
  theGlyph                  : PTCacheEntry;
  Height                    : Single;
  P                         : PWideChar;
  i                         : Integer;
begin
  theGlyph := nil;
  Height := 0.0;
  GetMem(P, Length(s) * SizeOf(WideChar) + 1);
  try
    StringToWideChar(s, P, Length(s) * SizeOf(WideChar) + 1);
    i := 0;
    while (P[i] <> #0) do begin
      //Special cases
      case Word(P[i]) of
        11: begin
            Height := Height + mHeight * TabSize;
            continue;
          end;
        10: begin
            Height := Height + mHeight;
            continue;
          end;
      end;
      theGlyph := getCacheEntry(P[i]);
      if (theGlyph = nil) then
        continue;
      if (theGlyph.glyphHeight > Height) then
        Height := theGlyph.glyphHeight;
      Inc(i);
    end;
  finally
    FreeMem(P);
    Result := Height;
  end;
end;

function TTFFont.setupSize: Boolean;
begin
  if (mLastSetWidth <> mWidth) or (mLastSetHeight <> mHeight) then begin
    if (C_FT_Set_Pixel_Sizes(mFace, mWidth, mHeight) <> 0) then begin
      Result := false;
      Exit;
    end;
    mLastSetWidth := mWidth;
    mLastSetHeight := mHeight;
  end;
  Result := true;
end;

function TTFFont.getCacheEntry(charCode: WCHAR): PTCacheEntry;
var
  theGlyph                  : PTCacheEntry;
begin
  Result := nil;
  if (Word(charCode) >= 0) and (Word(charCode) <= font_count) then begin
    theGlyph := mCache[Word(charCode)];
    if theGlyph <> nil then begin
      if (theGlyph.Width = mWidth) and (theGlyph.Height = mHeight) then
        Result := theGlyph;
    end;
  end;
end;

procedure TTFFont.renderGlyph(Glyph: FT_Bitmap; var Texture: ITexture;
  var textureWidth, textureHeight: uint32_t);
var
  TexturePtr                : PTexturePtr;
  glyphWidth                : uint32_t;
  glyphHeight               : uint32_t;
  Pixel                     : uint32_t;
  i                         : Longword;
  row, col                  : Integer;
  Src                       : PUCHAR;
  Alpha                     : uint32_t;
begin
  Texture := nil;
  TexturePtr := nil;
  textureWidth := 0;
  textureHeight := 0;
  glyphWidth := Glyph.Width;
  glyphHeight := Glyph.rows;
  Pixel := ($FF shl 16) or ($FF shl 8) or $FF;

  if (glyphWidth = 0) or (glyphHeight = 0) then Exit;

  Texture := mHGE.Texture_Create(glyphWidth, glyphHeight);
  if (Texture = nil) then Exit;

  textureWidth := mHGE.Texture_GetWidth(Texture);
  textureHeight := mHGE.Texture_GetHeight(Texture);
  TexturePtr := Pointer(mHGE.Texture_Lock(Texture, false));
  i := 0;
  while i < textureWidth * textureHeight do begin
    TexturePtr[i] := Pixel;
    Inc(i, 4);
  end;
  for row := 0 to glyphHeight - 1 do begin
    Src := PUCHAR(Integer(Glyph.buffer) + row * Glyph.pitch);
    for col := 0 to glyphWidth - 1 do begin
      Alpha := Src^;
      Inc(Src);
      TexturePtr[row * textureWidth + col] := Pixel or (Alpha shl 24);
    end;
  end;
  mHGE.Texture_Unlock(Texture);
end;

function TTFFont.spaceAdvance: uint32_t;
var
  Space                     : PTCacheEntry;
begin
  cacheChar(' ');
  Space := getCacheEntry(' ');
  Result := Space.Advance;
end;

function TTFFont.isCharCached(charCode: WCHAR): Boolean;
begin
  Result := getCacheEntry(charCode) <> nil;
end;

procedure TTFFont.setScale(Scale: Single);
begin
  mXScale := Scale;
  mYScale := Scale;
end;

procedure TTFFont.setRotation(Rotation: Single);
begin
  mRotation := Rotation;
end;

procedure TTFFont.setWidth(Width: uint32_t);
begin
  mWidth := Width;
end;

procedure TTFFont.setHeight(Height: uint32_t);
begin
  mHeight := Height;
end;

procedure TTFFont.setSize(Size: uint32_t);
begin
  mWidth := Size;
  mHeight := Size;
end;

procedure TTFFont.setColor(Color: uint32_t; i: Integer = -1);
begin
  mSprite.setColor(Color, i);
end;

procedure TTFFont.setBlendMode(Mode: Integer);
begin
  mSprite.setBlendMode(Mode);
end;

procedure TTFFont.setHotSpot(relX, relY: Single);
begin
  mHotSpotX := relX;
  mHotSpotY := relY;
end;

procedure TTFFont.setXScale(Scale: Single);
begin
  mXScale := Scale;
end;

procedure TTFFont.setYScale(Scale: Single);
begin
  mYScale := Scale;
end;

function TTFFont.getColor(i: Integer = -1): uint32_t;
begin
  Result := mSprite.getColor(i);
end;

function TTFFont.getBlendMode(): Integer;
begin
  Result := mSprite.getBlendMode();
end;

procedure TTFFont.getHotSpot(var hotX, hotY: Single);
begin
  hotX := mHotSpotX;
  hotY := mHotSpotY;
end;

function TTFFont.getRotation(): Single;
begin
  Result := mRotation;
end;

procedure TTFFont.autoCache(autoCache: Boolean);
begin
  mAutoCache := autoCache;
end;

function TTFFont.autoCache(): Boolean;
begin
  Result := mAutoCache;
end;

procedure TTFFont.useKerning(Kerning: Boolean);
begin
  mUseKerning := Kerning;
end;

function TTFFont.usingKerning(): Boolean;
begin
  Result := mUseKerning;
end;

function TTFFont.hasKerning(): Boolean;
begin
  Result := mHaveKerning;
end;

function TTFFont.getFilename: string;
begin
  Result := mFilename;
end;

end.

