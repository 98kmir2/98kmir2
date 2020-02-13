unit HGdiFont;

interface
  uses
   Windows,SysUtils,Classes,Graphics,HGE,HGESprite,FontSprite,pngimage;

const
  font_count   = $FFFF;// = sizeof(wchar_t);
  tex_size     = 256;



type
 tagEngineFontGlyph =record
    x       :Single;
    y       :Single;
    w       :Single;
    h       :Single;
    t       :ITexture;
    c       :WideChar;
 end;

 TENGINEFONTGLYPH =tagEngineFontGlyph;



TGdiFont =class(TFontSprite)
 	m_FontTextures     :TList;
	m_FontGlyphs       :array [0..font_count-1]of TENGINEFONTGLYPH ;
	m_nFontSize        :Single;
	m_nKerningWidth    :Single;
	m_nKerningHeight   :Single;
 	m_bItalic          :Boolean;

	m_pSprite          :IHGESprite;

	// GDI设备
  m_hMemDC            :HDC;
	m_hBrush            :HBRUSH;
	m_hFont             :HFONT;
	m_hBitmap           :HBITMAP;
 	m_pBuffer           :Pointer;

	// 临时构造字模纹理信息
	m_hTexLetter        :ITEXTURE;
	m_ptLetter          :TPOINT;
  m_text              :PWideChar;
private
 class var
   	m_pHGE             :IHGE;


public
  constructor Create(lpsFontName:string;nFaceSize:Integer;
              bBold :Boolean= FALSE;bItalic:Boolean = FALSE;bUnderline :Boolean= FALSE;bAntialias :Boolean= TRUE);override;
  destructor Destroy; override;
	procedure StaticCacheCharacter(const text:PWideChar);
  procedure GdiFont(lpsFontName:string;nFaceSize:Integer;
             bBold :Boolean= FALSE;bItalic:Boolean = FALSE;bUnderline :Boolean= FALSE;bAntialias :Boolean= TRUE);

	// 销毁字体
	procedure Release();override;

	// 渲染文本
	procedure	Printf(x, y:Single;  const Format: String; const Args: array of const);override;
	procedure	Render( x, y:Single; str:string );override;
	procedure	RenderEx(x, y:Single; const str:string; scale:Single= 1.0);override;
	// 设置与获取颜色
	procedure	SetColor( dwColor:DWORD ;i :integer= -1 ) ;override;
	function	GetColor( i :integer= 0 ):DWORD;override;
	// 获取文本区域大小
	function GetTextSize(text :PWideChar):TSIZE;override;
	// 根据相对坐标获取字符
	function	GetCharacterFromPos(text:PWideChar;pixel_x,pixel_y:Single ):WideChar;override;
	// 设置字间距
	procedure	SetKerningWidth(kerning:Single);override;
	procedure	SetKerningHeight(kerning:Single);override;
	// 获取字间距
	function	GetKerningWidth():Single;override;
	function	GetKerningHeight():Single;override;
	// 获取字体大小
	function	GetFontSize():Single;override;

private
	// 根据字符获取轮廓
	function	GetGlyphByCharacter(c:WideChar):UINT;
	function	GetWidthFromCharacter(c:WideChar):Single;inline;
	procedure	CacheCharacter(idx:UINT;c:WideChar);inline;
end;

implementation




{ TGdiFont }



constructor TGdiFont.Create(lpsFontName: string; nFaceSize: Integer; bBold,
  bItalic, bUnderline, bAntialias: Boolean);
begin
 inherited Create(lpsFontName,nFaceSize, bBold, bItalic, bUnderline, bAntialias);
	GdiFont(lpsFontName,nFaceSize,bBold,bItalic,bUnderline,bAntialias);
	// 缓冲下面的这些字符，因为是最常用的。
	StaticCacheCharacter('0123456789');
	StaticCacheCharacter('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
	StaticCacheCharacter('abcdefghijklmnopqrstuvwxyz');
	StaticCacheCharacter('`-=\\[];\'',./~!@#$%^&*()_+|{}:"<>?');
end;

destructor TGdiFont.Destroy;
var
  size :Integer;
  hTex :ITEXTURE;
  I    :Integer;
begin
	size := m_FontTextures.Count;
  for I := 0 to size - 1 do begin
     m_FontTextures.Items[I];
		 hTex  := ITEXTURE(m_FontTextures.Items[I]);
     hTex  :=nil;
	end;
  m_FontTextures.Free;

	if m_hBitmap<> 0  then DeleteObject(m_hBitmap);
	if m_hFont  <> 0  then DeleteObject(m_hFont);
	if m_hBrush <> 0  then DeleteObject(m_hBrush);
	if m_hMemDC <> 0  then DeleteDC(m_hMemDC);

  m_pSprite :=nil;

  if m_pHGE <> nil then
    m_pHGE:=nil;
  FreeMem(M_text);
  inherited;
end;


procedure TGdiFont.GdiFont(lpsFontName:string;nFaceSize:Integer;
             bBold :Boolean= FALSE;bItalic:Boolean = FALSE;bUnderline :Boolean= FALSE;bAntialias :Boolean= TRUE);
var
  DC        :HDC;
  Weight    :Integer;
  Quality   :DWORD;
  hTexLetter:ITEXTURE;
  bmi       :BITMAPINFO;
  P1,P2     :Integer;
begin

	m_pHGE := hgeCreate(HGE_VERSION);
  m_FontTextures   :=TList.Create;
  GetMem(M_text, 1024 * Sizeof(PwideChar));
	// 创建GDI相关设备
	DC       := GetDC(m_pHGE.System_GetState(HGE_HWND));
	m_hMemDC := CreateCompatibleDC(DC);
	if (0 = m_hMemDC) then Exit;
    	ReleaseDC(m_pHGE.System_GetState(HGE_HWND),DC);

	SetMapMode(m_hMemDC, TRANSPARENT);
	SetTextAlign(m_hMemDC, TA_TOP);
	SetTextColor(m_hMemDC,RGB(255,255,255));
 	SetBkColor(m_hMemDC,RGB(0,0,0));

	m_hBrush  := CreateSolidBrush(RGB(0,0,0));
	if (0 = m_hBrush) then Exit;

	m_bItalic := bItalic;
  if bBold then Weight := FW_BOLD
  else  Weight := FW_NORMAL;
  if bAntialias then Quality := ANTIALIASED_QUALITY
  else  Quality := NONANTIALIASED_QUALITY;

	m_hFont   := CreateFont(  -nFaceSize,
                            0,
                            0,
                            0,
                            Weight,
                            Integer(bItalic),
                            Integer(bUnderline),
                            0,
                            GB2312_CHARSET,
                            OUT_DEFAULT_PRECIS,
                            CLIP_DEFAULT_PRECIS,
                            Quality,
                            FF_DONTCARE or DEFAULT_PITCH,
                            PChar(lpsFontName));
	if (0 = m_hFont) then Exit;
	SelectObject(m_hMemDC, m_hFont);

	hTexLetter := m_pHGE.Texture_Create(tex_size,tex_size);
	if (nil = (hTexLetter)) then Exit;
  FillChar(bmi,sizeof(bmi),0);

	bmi.bmiHeader.biSize        := sizeof(BITMAPINFOHEADER);
	bmi.bmiHeader.biPlanes      := 1;
	bmi.bmiHeader.biBitCount    := 32;
	bmi.bmiHeader.biCompression := BI_RGB;
	bmi.bmiHeader.biWidth       := m_pHGE.Texture_GetWidth(hTexLetter);;
	bmi.bmiHeader.biHeight      := -m_pHGE.Texture_GetHeight(hTexLetter);

	m_pBuffer := nil;
  p1 :=0;
  p2 :=0;
	m_hBitmap := CreateDIBSection(m_hMemDC, bmi, DIB_RGB_COLORS, m_pBuffer, p1, p2);
	if (0 = (m_hBitmap))then Exit;
	SelectObject(m_hMemDC, m_hBitmap);

	//
	m_FontTextures.clear();
  FillChar(m_FontGlyphs,sizeof(TENGINEFONTGLYPH)*font_count,0);

	m_nFontSize      := nFaceSize;
	m_nKerningWidth  := 0;
	m_nKerningHeight := 0;

	m_pSprite  :=  THGESprite.Create( nil, 0, 0, 0, 0 );
  m_pSprite.SetColor( ARGB( 255, 255, 255, 255 ) );

  FillChar(m_ptLetter,sizeof(m_ptLetter),0);
  m_hTexLetter  := hTexLetter;
	m_FontTextures.Add(TObject(hTexLetter));
	

end;

procedure TGdiFont.StaticCacheCharacter(const text: PWideChar);
var
 I     :Integer;
begin
   I := 0;
  while text[I] <> #0 do begin
    GetGlyphByCharacter(text[I]);
    inc(I);
  end;
end;

// 释放一个TypeFont精灵对象
procedure TGdiFont.Release;
begin
  inherited;
  Free;
end;

procedure TGdiFont.Printf(x, y: Single;  const Format: String; const Args: array of const);
begin
  inherited;
  Render(X,Y,SysUtils.Format(Format,Args));
end;

procedure TGdiFont.Render(x, y: Single; str:string);
var
 offsetX    :Single;
 offsetY    :Single;
 I          :Integer;
 idx        :UINT;
begin
  inherited;
	offsetX := x;
	offsetY := y;
  StringToWideChar(str, M_text, Length(str) * SizeOf(WideChar) + 1);
  I := 0;
  while M_text[I] <> #0 do begin
		if (M_text[I] = #13) or (M_text[I] = #10 ) then begin
			offsetX := x;
			offsetY :=offsetY + (m_nFontSize + m_nKerningHeight);
    end	else begin
		  idx := GetGlyphByCharacter(M_text[I]);
			if ( idx > 0) then begin
				m_pSprite.SetTexture( m_FontGlyphs[idx].t );
				m_pSprite.SetTextureRect( m_FontGlyphs[idx].x, m_FontGlyphs[idx].y, m_FontGlyphs[idx].w, m_FontGlyphs[idx].h );
				m_pSprite.Render(offsetX, offsetY);

   //   画出当前所用到的字体纹理
        //m_pSprite.SetTextureRect(0, 0, m_FontGlyphs[idx].t.GetWidth, m_FontGlyphs[idx].t.GetHeight );
        //m_pSprite.Render(200, 200);
        
				offsetX := offsetX + (GetWidthFromCharacter(M_text[I]) + m_nKerningWidth);
			end	else begin
				offsetX := offsetX + (GetWidthFromCharacter(M_text[I]) + m_nKerningWidth);
			end;
		end;
    inc(I);
  end;

end;

procedure TGdiFont.RenderEx(x, y: Single; const str:string; scale: Single);
begin
  inherited;
  Render(x,y,str);
end;

// 设置与获取颜色
procedure TGdiFont.SetColor(dwColor: DWORD; i: integer);
begin
  inherited;
    m_pSprite.SetColor(dwColor,i);
end;

function TGdiFont.GetColor(i: integer): DWORD;
begin
 Result := m_pSprite.GetColor(i);
end;

// 获取文本宽高
function TGdiFont.GetTextSize(text:PWideChar): TSIZE;
var
 dim       :SIZE;
 nRowWidth :Single;
 I         :Integer;
begin
	dim.cx    := 0;
  dim.cy    := Round(m_nFontSize);
	nRowWidth := 0;
  I := 0;
 while text[I] <> #0 do begin
		if (text[I] = #13) or (text[I] = #10 ) then begin
			dim.cy :=dim.cy + Round(m_nFontSize + m_nKerningHeight);
			if (dim.cx < Round(nRowWidth)) then
				dim.cx := Round(nRowWidth);
			nRowWidth := 0;
		end	else
			nRowWidth :=nRowWidth+ (GetWidthFromCharacter(text[I]) + m_nKerningWidth);
    inc(I);   
  end;

	if (dim.cx < Round(nRowWidth)) then
		dim.cx := Round(nRowWidth);

	Result := dim;
end;


// 根据坐标获取字符
function TGdiFont.GetCharacterFromPos(text:PWideChar; pixel_x,
  pixel_y: Single): WideChar;
var
  X    :Single;
  Y    :Single;
  I    :Integer;
  w    :Single;
begin
	x := 0;
	y := 0;
  I := 0;
 while text[I] <> #0 do begin
		if (text[I] = #13) or (text[I] = #10 ) then begin
			x := 0;
			y :=y + (m_nFontSize+m_nKerningHeight);
      Inc(I);
	   	if (text[I] <> #0) then
         break;
    end;

    w := GetWidthFromCharacter(text[I]);
		if (pixel_x > x) and (pixel_x <= x + w) and
		   (pixel_y > y) and (pixel_y <= y + m_nFontSize) then begin
		   Result := text[I];
       Exit;
    end;
		x :=x+ (w+m_nKerningWidth);
		Inc(I);
  end;


	Result := #0;
end;

// 设置字间距
procedure TGdiFont.SetKerningWidth(kerning: Single);
begin
  inherited;
	m_nKerningWidth := kerning;
end;


procedure TGdiFont.SetKerningHeight(kerning: Single);
begin
  inherited;
	m_nKerningHeight := kerning;
end;


// 获取字间距
function TGdiFont.GetKerningWidth: Single;
begin
	Result := m_nKerningWidth;
end;

function TGdiFont.GetKerningHeight: Single;
begin
  Result := m_nKerningHeight;
end;

function TGdiFont.GetFontSize: Single;
begin
  Result :=  m_nFontSize;
end;

// 根据字符获取轮廓
function TGdiFont.GetGlyphByCharacter(c:WideChar): UINT;
var
 idx    :UINT;
begin
	idx := UINT(c);
	if (nil = (m_FontGlyphs[idx].t)) then
    CacheCharacter(idx,c);
	Result := idx;
end;



procedure TGdiFont.CacheCharacter(idx: UINT;c:WideChar);
var
 sChar      :array [0..1] of WideChar;
 szChar     :SIZE;
 font_w     :Integer;
 font_h     :Integer;
 hTexLetter :ITEXTURE;
 rcFill     :TRECT;
 target_pixels:PLongword;
 pbm        :PByte;
 tex_w      :Integer;
 tex_h      :Integer;
 y          :Integer;
 x          :Integer;
 alpha      :Byte;
 nRGB       :Byte;
 bm0        :Byte;
 bm1        :Byte;
 bm2        :Byte;
 target_bak :PLongword;
begin
	if (idx < font_count) and (nil = (m_FontGlyphs[idx].t)) then begin
		sChar[0] := c;
		sChar[1] := #0;

		//TEXTMETRICW tm;
		//GetTextMetricsW(m_hMemDC,&tm);

	  szChar.cx := 0;
    szChar.cy := 0;

		GetTextExtentPoint32W(m_hMemDC,PWideChar(@sChar[0]),1,szChar);

		font_w := szChar.cx;
		font_h := szChar.cy;

		if (m_ptLetter.x + font_w >= tex_size) then begin
			m_ptLetter.x := 0;
			if(m_ptLetter.y + font_h >= tex_size - font_h) then begin
				m_ptLetter.y := 0;

				hTexLetter := m_pHGE.Texture_Create(tex_size,tex_size);
				if (nil = (hTexLetter)) then Exit;
				m_FontTextures.Add(TObject(hTexLetter));
				m_hTexLetter := hTexLetter;

				rcFill.Left    :=0;
        rcFill.Top     :=0;
        rcFill.Right   :=tex_size;
        rcFill.Bottom  :=tex_size;
				FillRect(m_hMemDC,rcFill,m_hBrush);
			end	else
				m_ptLetter.y :=m_ptLetter.y + font_h;
		end;

		TextOutW(m_hMemDC,m_ptLetter.x,m_ptLetter.y,PWideChar(@sChar[0]),1);

		target_pixels := m_pHGE.Texture_Lock(m_hTexLetter,FALSE);

		if (target_pixels <> nil) then begin
       pbm  := pbyte(m_pBuffer);
		   tex_w := m_pHGE.Texture_GetWidth(m_hTexLetter);
		   tex_h := m_pHGE.Texture_GetHeight(m_hTexLetter);

			// 不带背景色绘制字体
			for y:=0 to tex_w-1 do begin
				for x:=0  to tex_h-1 do begin
          target_bak  := target_pixels;
					alpha := 0;
					// 绘制字体
          bm0 :=pbm^;
          Inc(pbm,1);
          bm1 :=pbm^;
          Inc(pbm,1);
          bm2 :=pbm^;
          Inc(target_bak,y*tex_w+x);
          if $FFFFFF = RGB(bm2,bm1,bm0) then
            target_bak^:= ARGB($FF,$FF,$FF,$FF)
          else
            target_bak^:= ARGB($00,$00,$00,$00);
          Inc(pbm,2);
				end;
			end;
		end;

		m_pHGE.Texture_Unlock(m_hTexLetter);
		m_FontGlyphs[idx].x := (m_ptLetter.x);
		m_FontGlyphs[idx].y := (m_ptLetter.y);
		m_FontGlyphs[idx].w := (font_w);
		m_FontGlyphs[idx].h := (font_h);
		m_FontGlyphs[idx].t :=  m_hTexLetter;
		m_FontGlyphs[idx].c := c;

		m_ptLetter.x := m_ptLetter.x +font_w;
  end;

end;



function TGdiFont.GetWidthFromCharacter(c:WideChar): Single;
var
  idx  :UINT;
begin
	idx := GetGlyphByCharacter(c);
	if (idx > 0) and (idx < font_count) then begin
		Result := m_FontGlyphs[idx].w;
    Exit;
  end;

	if (UINT(c) >= $2000) then begin
		Result :=	m_nFontSize;
	end else
    Result :=	_floor(m_nFontSize / 2);

end;














initialization
  TGdiFont.m_pHGE := nil;

end.
