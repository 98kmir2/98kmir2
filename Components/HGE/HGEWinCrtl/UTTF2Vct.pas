{
    UTTF2Vct.pas               (was   UTTFToVector.pas;   changed   for   8.3   compatibility   )   
    
    TTF   to   Vector   converter   
    Copyright   (c)   1996-97   by   Marco   Cocco.   All   rights   reseved.   
    Copyright   (c)   1996-97   by   D3K   Artisan   Of   Ware.   All   rights   reseved.   
    
    Please   send   comments   to   d3k@italymail.com   
                                                    mcocco@hotmail.com   
    
    URL:   http://free.websight.com/Cocco2/   
    
    Do   you   need   additional   features   ?   Feel   free   to   ask   for   it!   
    
    ******************************************************************************   
    *       Permission   to   use,   copy,     modify,   and   distribute   this   software   and   its       *   
    *   documentation   without   fee   for   any   non-commerical   purpose   is   hereby   granted,*   
    *       provided   that   the   above   copyright   notice   appears   on   all   copies   and   that     *   
    *           both   that   copyright   notice   and   this   permission   notice   appear   in   all         *   
    *                                                   supporting   documentation.                                                     *   
    *                                                                                                                                                         *   
    *   NO   REPRESENTATIONS   ARE   MADE   ABOUT   THE   SUITABILITY   OF   THIS   SOFTWARE   FOR   ANY   *   
    *         PURPOSE.     IT   IS   PROVIDED   "AS   IS"   WITHOUT   EXPRESS   OR   IMPLIED   WARRANTY.       *   
    *       NEITHER   MARCO   COCCO   OR   D3K   SHALL   BE   LIABLE   FOR   ANY   DAMAGES   SUFFERED   BY       *   
    *                                                     THE   USE   OF   THIS   SOFTWARE.                                                   *   
    ******************************************************************************   
    *   D3K   -   Artisan   Of   Ware   -   A   Marco   Cocco's   Company                                                         *   
    *   Casella   Postale   99   -   09047   Selargius   (CA)   -   ITALY                                                     *   
    ******************************************************************************   
    
    History   
    ------------------------------------------------------------------   
    17/Dec/1996     v1.00   Start   of   implementation   
    19/Dec/1996     v1.01   Added   some   sparse   comments   
    20/Dec/1996     v1.02   Added   support   for   Delphi   1.0/Win3.x   
    20/Dec/1996     v2.00   Converterd   from   pure   class   to   component   
    20/Dec/1996     v2.01   Added   support   for   UNICODE   (Delphi   2.0   only)   
    03/Jan/1997     v2.02   Coordinate   scaling   causing   runtime   errors   has   been   fixed.   
                                          Bug   in   memory   allocation   has   been   fixed   (Delphi   1.0).   
                                          Now   works   even   with   R+,   Q+   
    04/Jan/1997     v2.03   Added   automatic   conversion   of   glyphs   to   a   GDI   region   
                                          (useful   for   clipping   &   special   effects)   
    14/Jan/1997     v2.04   Some   minor   changes   
    15/Jan/1997     v2.05   Some   minor   changes   
    
    To   do:   
        -   Test   for   new   routines   added   in   v2.03   
        -   Glyph   scaling   to   caller   defined   dimensions   (!)   
        -   Baseline   coordinate   retrieval   (!)   
        -   UNICODE   tests   (need   WinNT   to   do   this)   (!)   
        -   Increase   performance   and   spline   precision   (?)   
        -   Triangle   subdivision   for   texture   mapping   (?)   
        -   Char   to   char   morphing   (?)   
        -   3D   Extrusion   (?)   
    
        (!)   =   to   do   as   soon   as   possible   
        (?)   =   may   be   
}   

unit   UTTF2Vct;   
    
interface   
    
uses   
    {$IFDEF   WIN32}   
    Windows,   
    {$ELSE}   
    WinTypes,   WinProcs,   
    {$ENDIF}   
    Classes,   Graphics,   SysUtils;   
    
type   
    {   Font   stroke:   a   Font   Stroke   is   the   "basic"   element   of   a   character   glyph,   
                                that   is   a   glyph   is   a   sequence   of   connected   strokes   (lines).   
                                First   point   of   first   stroke   connects   to   last   point   of   last   stroke.   
                                All   strokes   with   equal   GlyphNumber   value   come   from   the   same   glyph.   
                                Strokes   of   the   same   glyph   are   stored   sequentially,   i.e.   stroke   0,   
                                stroke   1,   ...   stoke   n-1.   }   
    PFontStroke   =   ^TFontStroke;   
    TFontStroke   =   record   
                                    GlyphNumber:   integer;   
                                    Pt1,   Pt2:   TPoint;                     {   Note:   Strokes[i].Pt2=Strokes[i+1].Pt1   
                                                                                                          (also   Strokes[i].Pt1=Strokes[i-1].Pt2)   
                                                                                                            when   Strokes[i].GlyphNumber   =   Strokes[i+1].GlyphNumber   }   
                                end;   
    
    TEnumStrokesCallback   =   function(   Idx:   integer;   const   Stroke:   TFontStroke   ):   boolean   of   object;   
    
    TStrokeCollection   =   class(   TList   )   
        private   
        protected   
            function   GetNumGlyphs:   integer;   
            function   GetFontStroke(   Idx:   integer   ):   TFontStroke;   
            procedure   FreeStrokes;   
            function   GetBounds:   TRect;   
        public   
            constructor   Create;   virtual;   
            destructor   Destroy;   override;   
    
            {   Returns   the   index   of   the   first   stroke   for   the   glyph   number   GlyphNumber   }   
            function   StartOfGlyph(   GlyphNumber:   integer   ):   integer;   
            {   Returns   the   count   of   strokes   for   the   glyph   number   GlyphNumber.   }   
            function   GlyphNumStrokes(   GlyphNumber:   integer   ):   integer;   
            {   Enumerates   all   strokes   of   all   glyphs   }   
            procedure   EnumStrokes(   Callback:   TEnumStrokesCallback   );   
    
            {   Returns   the   number   of   glyphs   }   
            property   NumGlyphs:   integer   read   GetNumGlyphs;   
            {   Returns   the   stroke   number   Idx.   Use   StrartOfGlyph   to   determine   
                the   index   of   the   first   stroke   for   a   given   glyph.   
                Use   GlyphNumStrokes   to   determine   the   number   of   strokes   a   glyph   is.   }   
            property   Stroke[Idx:integer]:   TFontStroke   read   GetFontStroke;   
            {   Returns   the   smallest   rectangle   that   completely   bounds   all   glyphs   }   
            property   Bounds:   TRect   read   GetBounds;   
    end;   
    
    TTTFToVectorConverter   =   class(   TComponent   )   
        private   
            FFont:   TFont;   
            FSplinePrecision:   integer;   
            FUNICODE:   boolean;   
        protected   
            procedure   SetFont(   Value:   TFont   );   virtual;   
            procedure   SetSplinePrecision(   Value:   integer   );   
        public   
            constructor   Create(   Owner:   TComponent   );   override;   
            destructor   Destroy;   override;   
    
            function   GetCharacterGlyphs(   CharCode:   integer   ):   TStrokeCollection;   
            function   StrokesToRegion(Strokes:TStrokeCollection;SizeX,   SizeY,   OfsX,   OfsY:   integer   ):   HRGN;   
            function   GetCharacterRegion(   CharCode,   SizeX,   SizeY,   OfsX,   OfsY:   integer   ):   HRGN;   
    
        published   
            property   Font:   TFont   read   FFont   write   SetFont;   
            property   Precision:   integer   read   FSplinePrecision   write   SetSplinePrecision   default   5;   
            {$IFDEF   WIN32}   
            {   Set   to   TRUE   if   you   wish   retrieve   outlines   for   UNICODE   fonts   
                NEVER   TESTED!!!   }   
            property   UNICODE:   boolean   read   FUNICODE   write   FUNICODE   default   false;   
            {$ENDIF}   
    end;   
    
procedure   Register;   
    
implementation   

{$IFNDEF   WIN32}   
type   
    DWORD   =   longint;   
    
    PTTPolygonHeader   =   ^TTTPolygonHeader;   
    TTTPolygonHeader   =   packed   record   
        cb:   DWORD;   
        dwType:   DWORD;   
        pfxStart:   TPointFX;   
    end;   
    
const   
    GDI_ERROR   =   -1;   
{$ENDIF}   
    
{   ***   TStrokeCollection   ******************   }   
    
constructor   TStrokeCollection.Create;   
begin   
    inherited   Create;   
end;   
    
destructor   TStrokeCollection.Destroy;   
begin   
    FreeStrokes;   
    inherited   Destroy;   
end;   
    
procedure   TStrokeCollection.FreeStrokes;   
var   i:   integer;   
begin   
    for   i   :=   0   to   Count-1   do   
    begin   
        {$IFDEF   WIN32}   
        FreeMem(   Items[i]   );   
        {$ELSE}   
        FreeMem(   Items[i],   sizeof(TFontStroke)   );   
        {$ENDIF}
        Items[i]   :=   nil;   
    end;   
    Pack;
end;   
    
function   TStrokeCollection.GetNumGlyphs:   integer;   
begin   
    if   Count   =   0   then   
        Result   :=   0   
    else   
        Result   :=   PFontStroke(Items[Count-1])^.GlyphNumber+1;   
end;   
    
function   TStrokeCollection.StartOfGlyph(   GlyphNumber:   integer   ):   integer;   
var   ng,   i:   integer;   
begin   
    ng   :=   GetNumGlyphs;   
    if   (GlyphNumber<0)   or   (GlyphNumber>=ng)   then   
        Result   :=   -1   
    else   
    begin   
        for   i   :=   0   to   Count-1   do   
            if   PFontStroke(Items[i])^.GlyphNumber   =   GlyphNumber   then   
                break;   
        Result   :=   i;   
    end;   
end;   
    
function   TStrokeCollection.GlyphNumStrokes(   GlyphNumber:   integer   ):   integer;   
var   sog,   eog:   integer;   
begin   
    sog   :=   StartOfGlyph(   GlyphNumber   );   
    if   sog   <   0   then   
        Result   :=   -1   
    else   
    begin   
        eog   :=   StartOfGlyph(   GlyphNumber+1   );   
        if   eog   <   0   then   
            eog   :=   Count;   
        Result   :=   eog   -   sog;   
    end;   
end;   
    
function   TStrokeCollection.GetFontStroke(   Idx:   integer   ):   TFontStroke;   
begin   
    if   (Idx>=0)   and   (Idx<Count)   then   
        Result   :=   PFontStroke(Items[Idx])^   
    else   
        Error('List   out   of   bounds.',0);   
end;   
    
procedure   TStrokeCollection.EnumStrokes(   Callback:   TEnumStrokesCallback   );   
var   i:   integer;   
begin   
    if   not   Assigned(   Callback   )   then   
        exit;   
    for   i   :=   0   to   Count-1   do   
        if   not   Callback(   i,   PFontStroke(Items[i])^   )   then   
            break;   
end;   
    
function   TStrokeCollection.GetBounds:   TRect;   
var   i:   integer;   
        fs:   PFontStroke;   
begin   
    if   Count   =   0   then   
    begin   
        Result   :=   Rect(   0,   0,   0,   0   );   
        exit;   
    end;   
    Result   :=   Rect(   MaxInt,   MaxInt,   -MaxInt,   -MaxInt   );   
    for   i   :=   0   to   Count-1   do   
    begin   
        fs   :=   Items[i];   
        if   fs^.Pt1.X   <   Result.Left   then   
            Result.Left   :=   fs^.Pt1.X;   
        if   fs^.Pt1.X   >   Result.Right   then   
            Result.Right   :=   fs^.Pt1.X;   
        if   fs^.Pt2.X   <   Result.Left   then   
            Result.Left   :=   fs^.Pt2.X;   
        if   fs^.Pt2.X   >   Result.Right   then   
            Result.Right   :=   fs^.Pt2.X;   
        if   fs^.Pt1.Y   <   Result.Top   then   
            Result.Top   :=   fs^.Pt1.Y;   
        if   fs^.Pt1.Y   >   Result.Bottom   then   
            Result.Bottom   :=   fs^.Pt1.Y;   
        if   fs^.Pt2.Y   <   Result.Top   then   
            Result.Top   :=   fs^.Pt2.Y;   
        if   fs^.Pt2.Y   >   Result.Bottom   then   
            Result.Bottom   :=   fs^.Pt2.Y;   
    end;   
end;   


{   ***   TTTFToVectorConverter   **************   }

constructor   TTTFToVectorConverter.Create(   Owner:   TComponent   );
begin
    inherited   Create(   Owner   );
    FFont   :=   TFont.Create;
    FFont.Name   :=   'Arial';
    FFont.Size   :=   28;
    FSplinePrecision   :=   8;
    FUNICODE   :=   false;
end;

destructor   TTTFToVectorConverter.Destroy;
begin
    FFont.Free;
    inherited   Destroy;
end;

procedure   TTTFToVectorConverter.SetFont(   Value:   TFont   );   
begin   
    FFont.Assign(   Value   );
end;   
    
procedure   TTTFToVectorConverter.SetSplinePrecision(   Value:   integer   );   
begin
    if   (Value<1)   or   (Value>100)   then   
        exit;   
    FSplinePrecision   :=   Value;   
end;   

type   
    TFXPArray   =   array[0..MaxInt   div   sizeof(TPOINTFX)-1]   of   TPOINTFX;   
    PFXPArray   =   ^TFXPArray;   
    
function   TTTFToVectorConverter.GetCharacterGlyphs(   CharCode:   integer   ):   TStrokeCollection;   
const   EMSIZE   =   1024;   SIZEX   =   1024;   SIZEY   =   1024;
type   TDPoint   =   record   x,y:   double   end;   
var   res,   bufSize   :   integer;   
        bufPtr,   buf:   PTTPolygonHeader;   
        pc:   PTTPolyCurve;   
        dc,   mdc:   HDC;   
        ofont:   HFONT;
        gm:   TGLYPHMETRICS;   
        m2:   TMAT2;   
        ps,   p1,   p2   :   TDPoint;   
        ofs,   ofs2,   pcSize:   integer;   
        done:   boolean;   
        i:   integer;
        pfxA,   pfxB,   pfXC:   TDPoint;   
        lpAPFX:   PFXPArray;   
        polyN:   integer;   
        pcType:   integer;   
        first:   boolean;   

    function   Fix2Double(   AFix:   TFixed   ):   double;   
    begin   
        Result   :=   AFix.fract/65536.0   +   AFix.value;   
    end;   
    
    function   EqualPoints(   var   p1,   p2:   TDPoint   ):   boolean;
    begin   
        Result   :=   (p1.X   =   p2.X)   and   
                            (p1.Y   =   p2.Y);   
    end;   
    
    procedure   NewStroke(   GlyphNumber:   integer;   var   Pt1,   Pt2:   TDPoint   );
    var   ps:   PFontStroke;   
    begin   
        ps   :=   AllocMem(   sizeof(TFontStroke)   );   
        ps^.GlyphNumber   :=   GlyphNumber;   
        ps^.Pt1.X   :=   round(Pt1.X/EMSIZE*SIZEX);
        ps^.Pt1.Y   :=   round(Pt1.Y/EMSIZE*SIZEY);   
        ps^.Pt2.X   :=   round(Pt2.X/EMSIZE*SIZEX);   
        ps^.Pt2.Y   :=   round(Pt2.Y/EMSIZE*SIZEY);   
        Result.Add(   ps   );   
    end;
    
    procedure   DrawQSpline(   APolyN:   integer;   var   pa,   pb,   pc:   TDPoint   );   
    var   di,   i:   double;   
            p1,p2:   TDPoint;   
    begin
        di   :=   1.0   /   FSplinePrecision;   
        i   :=   di;   
        p2   :=   pa;   
        while   i<=1.0   do   
        begin
            if   i-di/2   >   1.0-di   then   
                i   :=   1.0;   
            p1   :=   p2;   
            p2.X   :=   (pa.X-2*pb.X+pc.X)*sqr(i)   +   (2*pb.X-2*pa.X)*i   +   pa.X;
            p2.Y   :=   (pa.Y-2*pb.Y+pc.Y)*sqr(i)   +   (2*pb.Y-2*pa.Y)*i   +   pa.Y;   
            if   not   EqualPoints(   p1,   p2   )   then   
                NewStroke(   APolyN,   p1,   p2   );   
            i   :=   i   +   di;
        end;
        pc   :=   p2;
    end;

begin
    Result   :=   nil;
    if   Font.Handle   =   0   then
        exit;

    dc   :=   GetDC(   0   );
    mdc   :=   CreateCompatibleDC(   dc   );
    ReleaseDC(   0,   dc   );

    FFont.Size   :=   EMSIZE;   
    ofont   :=   SelectObject(   mdc,   FFont.Handle   );
    
    m2.eM11.value   :=   1;   m2.eM11.fract   :=   1;   {   Identity   matrix   }
    m2.eM12.value   :=   0;   m2.eM12.fract   :=   1;   {   |1,0|                       }
    m2.eM21.value   :=   0;   m2.eM21.fract   :=   1;   {   |0,1|                       }
    m2.eM22.value   :=   1;   m2.eM22.fract   :=   1;
{$IFDEF WIN32}
 if not FUNICODE   then
        bufSize   :=   GetGlyphOutline(   mdc,
                                                                CharCode,
                                                                GGO_NATIVE,
                                                                gm,
                                                                0,   nil,   
                                                                m2   )   
    else   
        bufSize   :=   GetGlyphOutlineW(   mdc,   
                                                                  CharCode,   
                                                                  GGO_NATIVE,   
                                                                  gm,   
                                                                  0,   nil,   
                                                                  m2   );   
{$ELSE}
    bufSize   :=   GetGlyphOutline(   mdc,   
                                                            CharCode,   
                                                            GGO_NATIVE,   
                                                            gm,   
                                                            0,   nil,   
                                                            m2   );   
{$ENDIF}
    if   (bufSize   =   GDI_ERROR)   or   (bufSize=0)   then   
    begin   
        SelectObject(   mdc,   ofont   );   
        DeleteDC(   mdc   );   
        exit;   
    end;   
    
    bufPtr   :=   AllocMem(   bufSize   );   
    buf   :=   bufPtr;   
    
{$IFDEF WIN32}
    if   not   FUNICODE   then   
        res   :=   GetGlyphOutline(   mdc,   
                                                        CharCode,   
                                                        GGO_NATIVE,   
                                                        gm,   
                                                        bufSize,   pchar(buf),   
                                                        m2   )   
    else   
        res   :=   GetGlyphOutlineW(   mdc,   
                                                          CharCode,   
                                                          GGO_NATIVE,   
                                                          gm,   
                                                          bufSize,   pchar(buf),   
                                                          m2   );   
    {$ELSE}   
    res   :=   GetGlyphOutline(   mdc,   
                                                    CharCode,   
                                                    GGO_NATIVE,   
                                                    gm,   
                                                    bufSize,   pchar(buf),   
                                                    m2   );   
    {$ENDIF}   
    SelectObject(   mdc,   ofont   );   
    DeleteDC(   mdc   );   
    if   (res   =   GDI_ERROR)   or   (buf^.dwType   <>   TT_POLYGON_TYPE)   then   
    begin   
        {$IFDEF   WIN32}   
        FreeMem(   bufPtr   );   
        {$ELSE}   
        FreeMem(   bufPtr,   bufSize   );   
        {$ENDIF}   
        exit;   
    end;   
    
    Result   :=   TStrokeCollection.Create;   
    
    done   :=   false;   
    ofs   :=   0;   
    polyN   :=   0;   
    while   not   done   do   
    begin   
        ps.X   :=   Fix2Double(   buf^.pfxStart.X   );   
        ps.Y   :=   Fix2Double(   buf^.pfxStart.Y   );   
        pcSize   :=   buf^.cb   -   sizeof(TTTPOLYGONHEADER);   
        pchar(pc)   :=   pchar(buf)   +   sizeof(TTTPOLYGONHEADER);   
        ofs2   :=   0;   
        p2   :=   ps;   
        while   not   done   and   (ofs2   <   pcSize)   do   
        begin   
            pcType   :=   pc^.wType;   
            case   pcType   of   
                TT_PRIM_LINE:   
                    begin   
                        lpAPFX   :=   @pc^.apfx[0];   
                        for   i   :=   0   to   pc^.cpfx-1   do   
                        begin   
                            p1   :=   p2;   
                            p2.X   :=   Fix2Double(lpAPFX^[i].X);   
                            p2.Y   :=   Fix2Double(lpAPFX^[i].Y);   
                            if   not   EqualPoints(   p1,   p2   )   then   
                                NewStroke(   polyN,   p1,   p2   );   
                        end;   
                    end;   
                TT_PRIM_QSPLINE:   
                    begin   
                        lpAPFX   :=   @pc^.apfx[0];   
                        pfxA   :=   p2;   
                        for   i   :=   0   to   pc^.cpfx-2   do   
                        begin   
                            pfxB.X   :=   Fix2Double(lpAPFX^[i].X);   
                            pfxB.Y   :=   Fix2Double(lpAPFX^[i].Y);   
                            if   i   <   pc^.cpfx-2   then   
                            begin   
                                pfxC.X   :=   Fix2Double(lpAPFX^[i+1].X);   
                                pfxC.Y   :=   Fix2Double(lpAPFX^[i+1].Y);   
                                pfxC.X   :=   (pfxC.X   +   pfxB.X)   /   2;   
                                pfxC.Y   :=   (pfxC.Y   +   pfxB.Y)   /   2;   
                            end   
                            else   
                            begin   
                                pfxC.X   :=   Fix2Double(lpAPFX^[i+1].X);   
                                pfxC.Y   :=   Fix2Double(lpAPFX^[i+1].Y);   
                            end;   
                            DrawQSpline(   polyN,   pfxA,   pfxB,   pfxC   );   
                            pfxA   :=   pfxC;   
                        end;   
                        p2   :=   pfxC;   
                    end;   
            end;   
            ofs2   :=   ofs2   +   sizeof(TTTPOLYCURVE)   +   (pc^.cpfx-1)*sizeof(TPOINTFX);   
            pchar(pc)   :=   pchar(pc)   +   sizeof(TTTPOLYCURVE)   +   (pc^.cpfx-1)*sizeof(TPOINTFX);   
        end;   
        if   not   done   then   
        begin   
            p1   :=   p2;   
            p2   :=   ps;   
            if   not   EqualPoints(   p1,   p2   )   then   
                NewStroke(   polyN,   p1,   p2   );   
            ofs   :=   ofs   +   pcSize   +   sizeof(TTTPOLYGONHEADER);   
            done   :=   ofs   >=   bufSize-sizeof(TTTPolygonHeader);   
            pchar(buf)   :=   pchar(pc);   
            inc(   polyN   );   
        end;   
    end;   
    {$IFDEF   WIN32}   
    FreeMem(   bufPtr   );   
    {$ELSE}   
    FreeMem(   bufPtr,   bufSize   );   
    {$ENDIF}   
end;   

function   TTTFToVectorConverter.GetCharacterRegion(   CharCode,   SizeX,   SizeY,   OfsX,   OfsY:   integer   ):   HRGN;   
var   strokes:   TStrokeCollection;   
        cbounds:   TRect;   
        i,   j,   k,   sog:   integer;   
        polys,   pps:   ^TPoint;   
        {$ifdef   WIN32}   
        polyCounts,   ppc:   ^UINT;   
        {$else}   
        polyCounts,   ppc:   ^word;   
        {$endif}   
        stroke:   TFontStroke;   
        sx,   sy:   double;   {   Scaling   factors   }   
begin   
    {   **************************************   }   
    {     Convert   to   polilines                                     }   
    {   **************************************   }   
    strokes   :=   GetCharacterGlyphs(   CharCode   );   
    if   strokes   =   nil   then   
    begin   
        Result   :=   0;   
        exit;   
    end;   
    {   **************************************   }   
    {     Compose   the   GDI   region                                 }   
    {   **************************************   }   
    {     Get   character   bounds   }   
    cbounds   :=   strokes.Bounds;   
    {     Scaling   factors   }   
    sx   :=   SizeX/(cbounds.Right-cbounds.Left+1);   
    sy   :=   SizeY/(cbounds.Bottom-cbounds.Top+1);   
    {     Allocate   memory   for   (all)   the   points   }   
    polys   :=   AllocMem(   sizeof(TPoint)   *   strokes.Count   );   
    {     Allocate   memory   for   the   "points   per   polygon"   counters   }   
    {$IFDEF   WIN32}   
    polyCounts   :=   AllocMem(   sizeof(UINT)   *   strokes.NumGlyphs   );   
    {$ELSE}   
    polyCounts   :=   AllocMem(   sizeof(word)   *   strokes.NumGlyphs   );   
    {$ENDIF}   
    {     Copy   glyphs'   points   to   the   allocated   buffers   }   
    pps   :=   polys;   
    ppc   :=   polyCounts;   
    for   i   :=   0   to   strokes.NumGlyphs-1   do   
    begin   
        ppc^   :=   strokes.GlyphNumStrokes(   i   );   
        sog   :=   strokes.StartOfGlyph(   i   );   
        for   j   :=   0   to   ppc^-1   do   
        begin   
            {     Get   a   stroke   }   
            stroke   :=   strokes.Stroke[sog+j];   
            {     Store   it   }   
            pps^.x   :=   OfsX   +   round(   (stroke.Pt1.X-cbounds.Left)   *   sx   );   
            pps^.y   :=   OfsY   +   round(   (cbounds.Bottom-stroke.Pt1.Y)   *   sy   );   {     Flip   vertically!   }   
            {     Next   }   
            pps   :=   pointer(   pchar(pps)   +   sizeof(TPoint)   );   
        end;   
        ppc   :=   pointer(   pchar(ppc)   +   sizeof(ppc^)   );   
    end;   
    Result   :=   CreatePolyPolygonRgn(   polys^,   
                                                                    polyCounts^,   
                                                                    strokes.NumGlyphs,   
                                                                    WINDING   );   
    {     Release   buffers   }   
    {$IFDEF   WIN32}   
    FreeMem(   polys   );   
    FreeMem(   polyCounts   );   
    {$ELSE}   
    FreeMem(   polys,   sizeof(TPoint)   *   strokes.Count   );   
    FreeMem(   polyCounts,   sizeof(word)   *   strokes.NumGlyphs   );   
    {$ENDIF}   
    {     Release   the   strokes   }   
    strokes.Free;   
end;   
    
function   TTTFToVectorConverter.StrokesToRegion(Strokes:TStrokeCollection;SizeX,   SizeY,   OfsX,   OfsY:   integer   ):   HRGN;   
var   
        cbounds:   TRect;   
        i,   j,   k,   sog:   integer;   
        polys,   pps:   ^TPoint;   
        {$ifdef   WIN32}   
        polyCounts,   ppc:   ^UINT;   
        {$else}   
        polyCounts,   ppc:   ^word;   
        {$endif}   
        stroke:   TFontStroke;   
        sx,   sy:   double;   {   Scaling   factors   }   
begin   
    {   **************************************   }   
    {     Convert   to   polilines                                     }   
    {   **************************************   }   
    if   strokes   =   nil   then   
    begin   
        Result   :=   0;   
        exit;   
    end;   
    {   **************************************   }   
    {     Compose   the   GDI   region                                 }   
    {   **************************************   }   
    {     Get   character   bounds   }   
    cbounds   :=   strokes.Bounds;   
    {     Scaling   factors   }   
    sx   :=   SizeX/(cbounds.Right-cbounds.Left+1);   
    sy   :=   SizeY/(cbounds.Bottom-cbounds.Top+1);   
    {     Allocate   memory   for   (all)   the   points   }   
    polys   :=   AllocMem(   sizeof(TPoint)   *   strokes.Count   );   
    {     Allocate   memory   for   the   "points   per   polygon"   counters   }   
    {$IFDEF   WIN32}   
    polyCounts   :=   AllocMem(   sizeof(UINT)   *   strokes.NumGlyphs   );   
    {$ELSE}   
    polyCounts   :=   AllocMem(   sizeof(word)   *   strokes.NumGlyphs   );   
    {$ENDIF}   
    {     Copy   glyphs'   points   to   the   allocated   buffers   }   
    pps   :=   polys;   
    ppc   :=   polyCounts;   
    for   i   :=   0   to   strokes.NumGlyphs-1   do   
    begin   
        ppc^   :=   strokes.GlyphNumStrokes(   i   );   
        sog   :=   strokes.StartOfGlyph(   i   );   
        for   j   :=   0   to   ppc^-1   do   
        begin   
            {     Get   a   stroke   }   
            stroke   :=   strokes.Stroke[sog+j];   
            {     Store   it   }   
            pps^.x   :=   OfsX   +   round(   (stroke.Pt1.X-cbounds.Left)   *   sx   );   
            pps^.y   :=   OfsY   +   round(   (cbounds.Bottom-stroke.Pt1.Y)   *   sy   );   {     Flip   vertically!   }   
            {     Next   }   
            pps   :=   pointer(   pchar(pps)   +   sizeof(TPoint)   );   
        end;   
        ppc   :=   pointer(   pchar(ppc)   +   sizeof(ppc^)   );   
    end;   
    Result   :=   CreatePolyPolygonRgn(   polys^,   
                                                                    polyCounts^,   
                                                                    strokes.NumGlyphs,   
                                                                    WINDING   );   
    {     Release   buffers   }   
    {$IFDEF   WIN32}   
    FreeMem(   polys   );   
    FreeMem(   polyCounts   );   
    {$ELSE}   
    FreeMem(   polys,   sizeof(TPoint)   *   strokes.Count   );   
    FreeMem(   polyCounts,   sizeof(word)   *   strokes.NumGlyphs   );   
    {$ENDIF}   
    {     Release   the   strokes   }   
    strokes.Free;   
end;   


function   CharCode(value:string):UINT;   
begin
    if   Length(value)=1   then
    begin
        CharCode:=Ord(Value[1]);
    end
    else   if   (Length(value)=2)   and(Value[1]   in   LeadBytes)     then
    begin
        CharCode:=(Ord(Value[1])   shl   8   )or   Ord(Value[2]);
    end
    else
    begin
        Raise(Exception.Create(value+'不是合法的中西文字符!'));
        Exit;
    end;
end;
    
procedure   Register;   
begin   
    RegisterComponents(   'D3K',   [TTTFToVectorConverter]);   
end;   
   end.   










